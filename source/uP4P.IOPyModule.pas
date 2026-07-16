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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.CustomPyModule, uP4P.PyNone;

const
  ModuleName = 'pyio';

  InitCode = 'import sys' + LF +
             'class DebugOutput:' + LF +
             '  pyio = __import__("' + ModuleName + '")' + LF +
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

  RestoreCode = 'import sys' + LF +
                'if hasattr(sys, "old_stdout"): sys.stdout=sys.old_stdout' + LF +
                'if hasattr(sys, "old_stdin"): sys.stdin=sys.old_stdin' + LF +
                'if hasattr(sys, "old_stderr"): sys.stderr=sys.old_stderr' + LF + #0;

type
  TIOPyModule = class(TCustomPyModule)
    protected
      procedure AddAllMethods; override;
      function  Write(args: PPyObject): PPyObject;
      function  Read(args: PPyObject): PPyObject;

    public
      class function RunInitCode: boolean;
      class function RunRestoreCode: boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.Engine, uP4P.PyTuple, uP4P.PyUnicode, uP4P.PyBytes,
  uP4P.PyRun;

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
          Result := TPyNone.New.PyObject;
    end
   else
    Result := TPyNone.New.PyObject;
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
          Result := TPyNone.New.PyObject;
    end
   else
    Result := TPyNone.New.PyObject;
end;

procedure TIOPyModule.AddAllMethods;
begin
  inherited AddAllMethods;

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
      GlobalP4PEngine.doOnOutputMessage(TempItem.AsString);
    end;

  Result := TPyNone.New.PyObject;
end;

function TIOPyModule.Read(args: PPyObject): PPyObject;
var
  TempResult : IPyObject;
begin
  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.doOnInputMessage(TempResult) then
    Result := TempResult.UnWrap
   else
    Result := TPyNone.New.PyObject;
end;

class function TIOPyModule.RunInitCode: boolean;
begin
  Result := TPyRun.SimpleString(InitCode);
end;

class function TIOPyModule.RunRestoreCode: boolean;
begin
  Result := TPyRun.SimpleString(RestoreCode);
end;


end.
