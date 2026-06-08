unit uP4P.Engine;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.SyncObjs,
  {$ELSE}
    Classes, SysUtils, SyncObjs,
  {$ENDIF}
  uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject, uP4P.Loader,
  uP4P.CustomPyModule, uP4P.IOPyModule;

type
  TP4PEngine = class(TP4PLoader)
    protected
      FModules  : TList;
      FSyncObj  : TCriticalSection;
      FIOModule : TIOPyModule;

      function  Lock: boolean;
      procedure UnLock;
      procedure RedirectIO;

    public
      constructor Create; override;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      procedure   BeforeDestruction; override;
      procedure   AddModuleToSys(const aModule: TCustomPyModule);
      procedure   AddModule(const aModule: TCustomPyModule);
      procedure   RemoveModule(const aModule: TCustomPyModule);
      function    SearchModule(module: PPyObject; var aResult: TCustomPyModule): boolean;
      /// <summary>
      /// Initialize the Python interpreter.
      /// </summary>
      function    Initialize: boolean; override;

      function doOnOnAfterModuleInitialization(module: PPyObject): integer;
  end;

var
  /// <summary>
  /// Global instance of TP4PEngine used to simplify the initialization and destruction.
  /// </summary>
  GlobalP4PEngine : TP4PEngine = nil;

procedure DestroyGlobalP4PEngine;

implementation

uses
  uP4P.PyModule, uP4P.PyImport, uP4P.PyDict, uP4P.PyRun;

procedure DestroyGlobalP4PEngine;
begin
  if assigned(GlobalP4PEngine) then
    FreeAndNil(GlobalP4PEngine);
end;

constructor TP4PEngine.Create;
begin
  inherited Create;

  FModules  := nil;
  FSyncObj  := nil;
  FIOModule := nil;
end;

destructor TP4PEngine.Destroy;
begin
  if assigned(FModules) then
    FreeAndNil(FModules);

  if assigned(FSyncObj) then
    FreeAndNil(FSyncObj);

  if assigned(FIOModule) then
    FreeAndNil(FIOModule);

  inherited Destroy;
end;

procedure TP4PEngine.AfterConstruction;
begin
  inherited AfterConstruction;

  FModules := TList.Create;
end;

procedure TP4PEngine.BeforeDestruction;
begin
  if assigned(FIOModule) then
    FreeAndNil(FIOModule);

  inherited BeforeDestruction;
end;

function TP4PEngine.doOnOnAfterModuleInitialization(module: PPyObject): integer;
var
  TempModule : TCustomPyModule;
begin
  if SearchModule(module, TempModule) then
    Result := TempModule.doOnAfterInitialization
   else
    Result := 0;
end;

function TP4PEngine.Lock: boolean;
begin
  if assigned(FSyncObj) then
    begin
      FSyncObj.Acquire;
      Result := True;
    end
   else
    Result := False;
end;

procedure TP4PEngine.UnLock;
begin
  if assigned(FSyncObj) then
    FSyncObj.Release;
end;

procedure TP4PEngine.AddModuleToSys(const aModule: TCustomPyModule);
var
  TempModuleDict : IPyObject;
begin
  // add the module to sys.modules
  TempModuleDict := TPyImport.GetModuleDict;
  TPyDict.SetItemString(TempModuleDict, aModule.Name_, aModule.Module);
  TempModuleDict := nil;
end;

procedure TP4PEngine.AddModule(const aModule: TCustomPyModule);
begin
  if Lock then
    try
      if assigned(FModules) then
        FModules.Add(aModule);
    finally
      UnLock;
    end;
end;

procedure TP4PEngine.RemoveModule(const aModule: TCustomPyModule);
begin
  if Lock then
    try
      if assigned(FModules) then
        FModules.Remove(aModule);
    finally
      UnLock;
    end;
end;

function TP4PEngine.SearchModule(module: PPyObject; var aResult: TCustomPyModule): boolean;
var
  i: integer;
  TempModule : TCustomPyModule;
begin
  Result  := False;
  aResult := nil;

  if Lock then
    try
      if assigned(FModules) then
        for i := 0 to pred(FModules.Count) do
          begin
            TempModule := TCustomPyModule(FModules[i]);

            if TempModule.SameAs(module) then
              begin
                aResult := TempModule;
                break;
              end;
          end;
    finally
      UnLock;
    end;
end;

procedure TP4PEngine.RedirectIO;
const
  code = 'import sys'+LF+
         'class DebugOutput:'+LF+
         '  pyio = __import__("pyio")'+LF+
         '  softspace=0'+LF+
         '  encoding=None'+LF+
         '  def write(self,message):'+LF+
         '     self.pyio.write(message)'+LF+
         '  def readline(self, size=None):'+LF+
         '     return self.pyio.read(size)'+LF+
         '  def flush(self):' + LF +
         '     pass' + LF +
         '  def isatty(self):' + LF +
         '     return False' + LF +
         'sys.old_stdin=sys.stdin'+LF+
         'sys.old_stdout=sys.stdout'+LF+
         'sys.old_stderr=sys.stderr'+LF+
         'sys.stdin=sys.stderr=sys.stdout=DebugOutput()'+LF+#0;
begin
  if assigned(FIOModule) then exit;

  FIOModule := TIOPyModule.Create('pyio');
  FIOModule.Initialize;

  TPyRun.SimpleString(code);
end;

function TP4PEngine.Initialize: boolean;
begin
  if inherited Initialize then
    begin
      RedirectIO;
      Result := True;
    end
   else
    Result := False;
end;

end.
