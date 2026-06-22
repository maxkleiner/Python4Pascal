unit uP4P.Engine;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.SyncObjs, System.Types,
  {$ELSE}
    Classes, SysUtils, SyncObjs, Types,
  {$ENDIF}
  uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject, uP4P.Loader,
  uP4P.CustomPyModule, uP4P.IOPyModule;

type
  TOnOutputMessageEvent = procedure(Sender: TObject; const message_: string) of object;
  TOnInputMessageEvent  = procedure(Sender: TObject; var message_: string) of object;

  TP4PEngine = class(TP4PLoader)
    protected
      FModules          : TList;
      FSyncObj          : TCriticalSection;
      FIOModule         : TIOPyModule;
      FOnOutputMessage  : TOnOutputMessageEvent;
      FOnInputMessage   : TOnInputMessageEvent;

      function  Lock: boolean;
      procedure UnLock;
      procedure DestroyIOModule;
      procedure DestroyModules;
      function  RedirectIO: boolean;
      function  RestoreIO: boolean;

    public
      constructor Create; override;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      procedure   BeforeDestruction; override;
      function    AddModuleToSys(const aModule: TCustomPyModule): boolean;
      procedure   AddModule(const aModule: TCustomPyModule);
      procedure   RemoveModule(const aModule: TCustomPyModule);
      function    SearchModule(module: PPyObject; var aResult: TCustomPyModule): boolean;
      procedure   doOnOutputMessage(const aMessage: string);
      function    doOnInputMessage(var aResultObj: IPyObject): boolean;
      /// <summary>
      /// Initialize the Python interpreter.
      /// </summary>
      function    Initialize: boolean; override;
      procedure   Finalize; override;

      function    GetRaisedException: boolean;


      property IOModule         : TIOPyModule              read FIOModule;
      property OnOutputMessage  : TOnOutputMessageEvent    read FOnOutputMessage   write FOnOutputMessage;
      property OnInputMessage   : TOnInputMessageEvent     read FOnInputMessage    write FOnInputMessage;
  end;

var
  /// <summary>
  /// Global instance of TP4PEngine used to simplify the initialization and destruction.
  /// </summary>
  GlobalP4PEngine : TP4PEngine = nil;

procedure DestroyGlobalP4PEngine;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyModule, uP4P.PyImport, uP4P.PyDict, uP4P.PyRun,
  uP4P.PyErr, uP4P.PyUnicode, uP4P.PyBytes, uP4P.PyNone;

procedure DestroyGlobalP4PEngine;
begin
  if assigned(GlobalP4PEngine) then
    FreeAndNil(GlobalP4PEngine);
end;

constructor TP4PEngine.Create;
begin
  inherited Create;

  FModules         := nil;
  FSyncObj         := nil;
  FIOModule        := nil;
  FOnOutputMessage := nil;
  FOnInputMessage  := nil;
end;

destructor TP4PEngine.Destroy;
begin
  try
    DestroyModules;

    if assigned(FSyncObj) then
      FreeAndNil(FSyncObj);
  finally
    inherited Destroy;
  end;
end;

procedure TP4PEngine.AfterConstruction;
begin
  inherited AfterConstruction;

  FModules := TList.Create;
end;

procedure TP4PEngine.BeforeDestruction;
begin
  DestroyIOModule;

  inherited BeforeDestruction;
end;

procedure TP4PEngine.DestroyModules;
begin
  if Lock then
    try
      if assigned(FModules) then
        FreeAndNil(FModules);
    finally
      UnLock;
    end;
end;

procedure TP4PEngine.DestroyIOModule;
begin
  if assigned(FIOModule) then
    FreeAndNil(FIOModule);
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

function TP4PEngine.AddModuleToSys(const aModule: TCustomPyModule): boolean;
var
  TempModuleDict : IPyObject;
begin
  // add the module to sys.modules
  TempModuleDict := TPyImport.GetModuleDict;
  Result         := TPyDict.SetItemString(TempModuleDict, aModule.Name_, aModule.Module);
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

procedure TP4PEngine.doOnOutputMessage(const aMessage: string);
begin
  if assigned(FOnOutputMessage) then
    FOnOutputMessage(self, aMessage);
end;

function TP4PEngine.doOnInputMessage(var aResultObj: IPyObject): boolean;
var
  TempMessage: string;
begin
  if assigned(FOnInputMessage) then
    begin
      FOnInputMessage(self, TempMessage);
      aResultObj := TPyUnicode.FromString(TempMessage);
      Result     := True;
    end
   else
    Result := False;
end;

function TP4PEngine.RedirectIO: boolean;
const
  code = 'import sys' + LF +
         'class DebugOutput:' + LF +
         '  pyio = __import__("pyio")' + LF +
         '  softspace=0' + LF +
         '  encoding=None' + LF +
         '  def write(self,message):' + LF +
         '     self.pyio.write(message)' + LF +
         '  def readline(self, size_=None):' + LF +
         '     return self.pyio.read(size_)' + LF +
         '  def flush(self):' + LF +
         '     pass' + LF +
         '  def isatty(self):' + LF +
         '     return False' + LF +
         'sys.old_stdin=sys.stdin' + LF +
         'sys.old_stdout=sys.stdout' + LF +
         'sys.old_stderr=sys.stderr' + LF +
         'sys.stdin=sys.stderr=sys.stdout=DebugOutput()' + LF + #0;
begin
  Result := False;

  if not(assigned(FIOModule)) then
    begin
      FIOModule := TIOPyModule.Create('pyio');
      if not(FIOModule.Initialize) then exit;
    end;

  Result := TPyRun.SimpleString(code);
end;

function TP4PEngine.RestoreIO: boolean;
const
  code = 'import sys' + LF +
         'if hasattr(sys, "old_stdout"): sys.stdout=sys.old_stdout' + LF +
         'if hasattr(sys, "old_stdin"): sys.stdin=sys.old_stdin' + LF +
         'if hasattr(sys, "old_stderr"): sys.stderr=sys.old_stderr' + LF + #0;
begin
  Result := TPyRun.SimpleString(code);
end;

function TP4PEngine.Initialize: boolean;
begin
  Result := inherited Initialize and
            RedirectIO;
end;

procedure TP4PEngine.Finalize;
begin
  try
    //RestoreIO;
  finally
    inherited Finalize;
  end;
end;

function TP4PEngine.GetRaisedException: boolean;
var
  TempType, TempValue, TempTraceback, TempStr : IPyObject;
begin
  Result := False;

  if PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    TempValue := TPyErr.GetRaisedException()
   else
    TPyErr.Fetch(TempType, TempValue, TempTraceback);

  if TPyUnicode.Check(TempValue) then
    begin
      FLastErrorMessage := PyUTF8ToString(TPyUnicode.AsUTF8(TempValue));
      Result := True;
    end
   else
    if TPyBytes.Check(TempValue) then
      begin
        FLastErrorMessage := TPyBytes.AsString(TempValue);
        Result := True;
      end
     else
      begin
        TempStr := TempValue.Str;

        if TPyUnicode.Check(TempStr) then
          begin
            FLastErrorMessage := PyUTF8ToString(TPyUnicode.AsUTF8(TempStr));
            Result := True;
          end;
      end;

  if TPyObject.IsInitialized(TempValue) then
    begin
      if PythonLibIsGreaterOrEqualThan(3, 12, 0) then
        TPyErr.SetRaisedException(TempValue)
       else
        TPyErr.Restore(TempType, TempValue, TempTraceback);
    end;
end;

end.
