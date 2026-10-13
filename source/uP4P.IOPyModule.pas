unit uP4P.IOPyModule;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF}
  uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.CustomPyModule, uP4P.PyNone, uP4P.PyModuleDef, uP4P.PySlotManager,
  uP4P.PyCustomModuleSlotManager;

const
  IOPyModuleName = 'pyio';

type
  /// <summary>
  /// <para>TIOPyModule is a custom module created to capture the input and
  /// output in Python.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/module.html#module-objects">See the article about Module Objects.</see></para>
  /// </remarks>
  TIOPyModule = class(TCustomPyModule)
    protected
      procedure CreateModuleDef; override;
      procedure CreateSlotManager; override;
      function  Write(args: PPyObject): PPyObject;
      function  Read(args: PPyObject): PPyObject;

    public
      /// <summary>
      /// Helper function used to run the initialization Python code for this
      /// module.
      /// </summary>
      class function RunInitCode: boolean;
      /// <summary>
      /// Helper function used to run the Python code that restores the original
      /// input and output.
      /// </summary>
      class function RunRestoreCode: boolean;
  end;

  /// <summary>
  /// <para>TPyIOModuleDef is a custom PyModuleDef that declares custom write
  /// and read methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/extension-modules.html#multi-phase-initialization">See the article about Multi-phase initialization.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyMethodDef">See the article about PyMethodDef.</see></para>
  /// </remarks>
  TPyIOModuleDef = class(TPyModuleDef)
    protected
      /// <summary>
      /// This procedure adds the custom write and read methods.
      /// </summary>
      procedure AddAllMethods; override;
  end;

  /// <summary>
  /// <para>TPyIOSlotManager is a custom TPySlotManager that declares custom
  /// write and read methods.</para>
  /// </summary>
  TPyIOSlotManager = class(TPyCustomModuleSlotManager)
    protected
      /// <summary>
      /// This procedure adds the custom write and read methods.
      /// </summary>
      procedure AddAllMethods; override;
  end;

implementation

uses
  uP4P.Engine, uP4P.PyTuple, uP4P.PyRun;

function pyio_write(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) then
    begin
      if GlobalP4PEngine.IsIOModule(self) then
        Result := GlobalP4PEngine.IOModule.Write(args)
       else
        if GlobalP4PEngine.SearchModule(self, TempModule) and
           (TempModule is TIOPyModule) then
          Result := TIOPyModule(TempModule).Write(args)
         else
          Result := TPyNone.ReturnNone;
    end
   else
    Result := TPyNone.ReturnNone;
end;

function pyio_read(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) then
    begin
      if GlobalP4PEngine.IsIOModule(self) then
        Result := GlobalP4PEngine.IOModule.Read(args)
       else
        if GlobalP4PEngine.SearchModule(self, TempModule) and
           (TempModule is TIOPyModule) then
          Result := TIOPyModule(TempModule).Read(args)
         else
          Result := TPyNone.ReturnNone;
    end
   else
    Result := TPyNone.ReturnNone;
end;

procedure TPyIOModuleDef.AddAllMethods;
begin
  inherited AddAllMethods;

  // We add the "read" and "write" methods. The pyio_write and pyio_read
  // functions will execute the TIOPyModule.Read and TIOPyModule.Write
  // functions in Delphi.
  AddMethod('write', 'write(string) -> None', @pyio_write, METH_VARARGS);
  AddMethod('read',  'read() -> string',      @pyio_read,  METH_VARARGS);
end;

procedure TPyIOSlotManager.AddAllMethods;
begin
  inherited AddAllMethods;

  // We add the "read" and "write" methods. The pyio_write and pyio_read
  // functions will execute the TIOPyModule.Read and TIOPyModule.Write
  // functions in Delphi.
  AddMethod('write', 'write(string) -> None', @pyio_write, METH_VARARGS);
  AddMethod('read',  'read() -> string',      @pyio_read,  METH_VARARGS);
end;

function TIOPyModule.Write(args: PPyObject): PPyObject;
var
  TempArgs, TempItem : IPyObject;
begin
  TempArgs := TPyObject.Wrap(args, False);

  if TPyTuple.Check(TempArgs) then
    begin
      TempItem := TPyTuple.GetItem(TempArgs, 0);
      if assigned(TempItem) then
        GlobalP4PEngine.doOnOutputMessage(TempItem.AsString);
    end;

  Result := TPyNone.ReturnNone;
end;

function TIOPyModule.Read(args: PPyObject): PPyObject;
var
  TempResult : IPyObject;
begin
  TempResult := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.doOnInputMessage(TempResult) and
     assigned(TempResult) then
    Result := TempResult.UnWrap
   else
    Result := TPyNone.ReturnNone;
end;

procedure TIOPyModule.CreateModuleDef;
begin
  FModuleDef := TPyIOModuleDef.Create;
end;

procedure TIOPyModule.CreateSlotManager;
begin
  FSlotManager := TPyIOSlotManager.Create;
end;

class function TIOPyModule.RunInitCode: boolean;
const
  InitCode = 'import sys' + LF +
             'class DebugOutput:' + LF +
             '  pyio = __import__("' + IOPyModuleName + '")' + LF +
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
  Result := TPyRun.SimpleString(InitCode);
end;

class function TIOPyModule.RunRestoreCode: boolean;
const
  RestoreCode = 'import sys' + LF +
                'if hasattr(sys, "old_stdout"): sys.stdout=sys.old_stdout' + LF +
                'if hasattr(sys, "old_stdin"): sys.stdin=sys.old_stdin' + LF +
                'if hasattr(sys, "old_stderr"): sys.stderr=sys.old_stderr' + LF + #0;
begin
  Result := TPyRun.SimpleString(RestoreCode);
end;

end.
