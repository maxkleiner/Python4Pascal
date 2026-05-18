unit uP4P.PyCode;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  TPyCode = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function NewEmpty(const filename, funcname: string; firstlineno: integer): IPyObject;
      class function AddWatcher(callback: PyCode_WatchCallback): integer;
      class function ClearWatcher(watcher_id: integer): boolean;
      class function Addr2Line(const co: IPyObject; byte_offset: integer): integer;
      class function Addr2Location(const co: IPyObject; byte_offset: integer; out start_line, start_column, end_line, end_column: Integer): boolean;
      class function GetCode(const co: IPyObject): IPyObject;
      class function GetVarnames(const co: IPyObject): IPyObject;
      class function GetCellvars(const co: IPyObject): IPyObject;
      class function GetFreevars(const co: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyCode.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCode_Type);
end;

class function TPyCode.NewEmpty(const filename, funcname: string; firstlineno: integer): IPyObject;
var
  TempFilename, TempFuncname : AnsiString;
begin
  if assigned(PyCode_NewEmpty) then
    begin
      TempFilename := StringToPyUTF8(filename);
      TempFuncname := StringToPyUTF8(funcname);
      Result       := TPyObject.Wrap(PyCode_NewEmpty(PAnsiChar(TempFilename), PAnsiChar(TempFuncname), firstlineno));
    end
   else
    Result := nil;
end;

class function TPyCode.AddWatcher(callback: PyCode_WatchCallback): integer;
begin
  if assigned(PyCode_AddWatcher) then
    Result := PyCode_AddWatcher(callback)
   else
    Result := -1;
end;

class function TPyCode.ClearWatcher(watcher_id: integer): boolean;
begin
  Result := assigned(PyCode_ClearWatcher) and
            (PyCode_ClearWatcher(watcher_id) = 0);
end;

class function TPyCode.Addr2Line(const co: IPyObject; byte_offset: integer): integer;
begin
  if assigned(PyCode_Addr2Line) and
     TPyObject.IsInitialized(co) then
    Result := PyCode_Addr2Line(PPyCodeObject(co.PyObject), byte_offset)
   else
    Result := -1;
end;

class function TPyCode.Addr2Location(const co: IPyObject; byte_offset: integer; out start_line, start_column, end_line, end_column: Integer): boolean;
begin
  Result := assigned(PyCode_Addr2Location) and
            TPyObject.IsInitialized(co) and
            (PyCode_Addr2Location(PPyCodeObject(co.PyObject), byte_offset, start_line, start_column, end_line, end_column) <> 0);
end;

class function TPyCode.GetCode(const co: IPyObject): IPyObject;
begin
  if assigned(PyCode_GetCode) and
     TPyObject.IsInitialized(co) then
    Result := TPyObject.Wrap(PyCode_GetCode(PPyCodeObject(co.PyObject)))
   else
    Result := nil;
end;

class function TPyCode.GetVarnames(const co: IPyObject): IPyObject;
begin
  if assigned(PyCode_GetVarnames) and
     TPyObject.IsInitialized(co) then
    Result := TPyObject.Wrap(PyCode_GetVarnames(PPyCodeObject(co.PyObject)))
   else
    Result := nil;
end;

class function TPyCode.GetCellvars(const co: IPyObject): IPyObject;
begin
  if assigned(PyCode_GetCellvars) and
     TPyObject.IsInitialized(co) then
    Result := TPyObject.Wrap(PyCode_GetCellvars(PPyCodeObject(co.PyObject)))
   else
    Result := nil;
end;

class function TPyCode.GetFreevars(const co: IPyObject): IPyObject;
begin
  if assigned(PyCode_GetFreevars) and
     TPyObject.IsInitialized(co) then
    Result := TPyObject.Wrap(PyCode_GetFreevars(PPyCodeObject(co.PyObject)))
   else
    Result := nil;
end;

end.
