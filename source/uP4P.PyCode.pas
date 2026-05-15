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
  TPyCode = class(TPyObject, IPyCodeObject)
    protected
      FPyCodeObject : PPyCodeObject;

      function  GetInitialized: boolean; override;
      function  GetPyObject: PPyObject; override;
      function  GetPyCodeObject: PPyCodeObject;
      procedure SetPyObject(aValue: PPyObject); override;
      function  Addr2Line(byte_offset: integer): integer;
      function  Addr2Location(byte_offset: integer; out start_line, start_column, end_line, end_column: Integer): boolean;
      function  GetCode: IPyObject;
      function  GetVarnames: IPyObject;
      function  GetCellvars: IPyObject;
      function  GetFreevars: IPyObject;

    public
      constructor Create(aPyCodeObject: PPyCodeObject); reintroduce;

      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function WrapCodeObj(aPyCodeObject: Pointer): IPyCodeObject; inline;
      class function NewEmpty(const filename, funcname: string; firstlineno: integer): IPyCodeObject;
      class function AddWatcher(callback: PyCode_WatchCallback): integer;
      class function ClearWatcher(watcher_id: integer): boolean;

      property PyCodeObject : PPyCodeObject read GetPyCodeObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

constructor TPyCode.Create(aPyCodeObject: PPyCodeObject);
begin
  inherited Create;

  FPyObject     := nil;
  FPyCodeObject := aPyCodeObject;
  FObjRefOwner  := True;
end;

class function TPyCode.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCode_Type);
end;

class function TPyCode.WrapCodeObj(aPyCodeObject: Pointer): IPyCodeObject;
begin
  if assigned(aPyCodeObject) then
    Result := TPyCode.Create(aPyCodeObject)
   else
    Result := nil;
end;

class function TPyCode.NewEmpty(const filename, funcname: string; firstlineno: integer): IPyCodeObject;
var
  TempFilename, TempFuncname : AnsiString;
begin
  if assigned(PyCode_NewEmpty) then
    begin
      TempFilename := StringToPyUTF8(filename);
      TempFuncname := StringToPyUTF8(funcname);
      Result       := WrapCodeObj(PyCode_NewEmpty(PAnsiChar(TempFilename), PAnsiChar(TempFuncname), firstlineno));
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

function TPyCode.GetInitialized: boolean;
begin
  Result := assigned(FPyCodeObject);
end;

function TPyCode.GetPyObject: PPyObject;
begin
  Result := @FPyCodeObject.ob_base.ob_base;
end;

function TPyCode.GetPyCodeObject: PPyCodeObject;
begin
  Result := @FPyCodeObject;
end;

procedure TPyCode.SetPyObject(aValue: PPyObject);
begin
  FPyCodeObject.ob_base.ob_base := aValue^;
end;

function TPyCode.Addr2Line(byte_offset: integer): integer;
begin
  if Initialized and assigned(PyCode_Addr2Line) then
    Result := PyCode_Addr2Line(PyCodeObject, byte_offset)
   else
    Result := -1;
end;

function TPyCode.Addr2Location(byte_offset: integer; out start_line, start_column, end_line, end_column: Integer): boolean;
begin
  Result := Initialized and
            assigned(PyCode_Addr2Location) and
            (PyCode_Addr2Location(PyCodeObject, byte_offset, start_line, start_column, end_line, end_column) <> 0);
end;

function TPyCode.GetCode: IPyObject;
begin
  if Initialized and assigned(PyCode_GetCode) then
    Result := Wrap(PyCode_GetCode(PyCodeObject))
   else
    Result := nil;
end;

function TPyCode.GetVarnames: IPyObject;
begin
  if Initialized and assigned(PyCode_GetVarnames) then
    Result := Wrap(PyCode_GetVarnames(PyCodeObject))
   else
    Result := nil;
end;

function TPyCode.GetCellvars: IPyObject;
begin
  if Initialized and assigned(PyCode_GetCellvars) then
    Result := Wrap(PyCode_GetCellvars(PyCodeObject))
   else
    Result := nil;
end;

function TPyCode.GetFreevars: IPyObject;
begin
  if Initialized and assigned(PyCode_GetFreevars) then
    Result := Wrap(PyCode_GetFreevars(PyCodeObject))
   else
    Result := nil;
end;

end.
