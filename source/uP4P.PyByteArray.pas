unit uP4P.PyByteArray;

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
  TPyByteArray = class
    public
      class function Concat(const ob1, ob2: IPyObject): IPyObject;
      class function Size(const ob: IPyObject): Py_ssize_t;
      class function AsString(const ob: IPyObject): string;
      class function AsBuffer(const ob: IPyObject): PByte;
      class function Resize(const ob: IPyObject; size: Py_ssize_t): boolean;
      class function FromObject(const ob: IPyObject): IPyObject;
      class function FromString(const str: string): IPyObject;
      class function FromStringAndSize(const str: AnsiString; size: Py_ssize_t): IPyObject;
      class function FromBufferAndSize(const buffer: PByte; size: Py_ssize_t): IPyObject;
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyByteArray.FromObject(const ob: IPyObject): IPyObject;
begin
  if assigned(PyByteArray_FromObject) and TPyObject.IsInitialized(ob) then
    Result := TPyObject.Wrap(PyByteArray_FromObject(ob.PyObject))
   else
    Result := nil;
end;

class function TPyByteArray.FromString(const str: string): IPyObject;
var
  TempString: AnsiString;
begin
  Result := nil;
  if not(assigned(PyByteArray_FromStringAndSize)) or (length(str) = 0) then exit;

  TempString := StringToPyUTF8(str);
  Result     := TPyObject.Wrap(PyByteArray_FromStringAndSize(PAnsiChar(TempString), length(TempString)));
end;

class function TPyByteArray.FromStringAndSize(const str: AnsiString; size: Py_ssize_t): IPyObject;
begin
  if assigned(PyByteArray_FromStringAndSize) then
    Result := TPyObject.Wrap(PyByteArray_FromStringAndSize(PAnsiChar(str), size))
   else
    Result := nil;
end;

class function TPyByteArray.FromBufferAndSize(const buffer: PByte; size: Py_ssize_t): IPyObject;
begin
  if assigned(PyByteArray_FromStringAndSize) and assigned(buffer) then
    Result := TPyObject.Wrap(PyByteArray_FromStringAndSize(PAnsiChar(buffer), size))
   else
    Result := nil;
end;

class function TPyByteArray.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyByteArray_Type);
end;

class function TPyByteArray.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyByteArray_Type);
end;

class function TPyByteArray.Concat(const ob1, ob2: IPyObject): IPyObject;
begin
  if assigned(PyByteArray_Concat) and
     TPyObject.IsInitialized(ob1) and
     TPyObject.IsInitialized(ob2) then
    Result := TPyObject.Wrap(PyByteArray_Concat(ob1.PyObject, ob2.PyObject))
   else
    Result := nil;
end;

class function TPyByteArray.Size(const ob: IPyObject): Py_ssize_t;
begin
  if assigned(PyByteArray_Size) and TPyObject.IsInitialized(ob) then
    Result := PyByteArray_Size(ob.PyObject)
   else
    Result := 0;
end;

class function TPyByteArray.AsString(const ob: IPyObject): string;
begin
  if assigned(PyByteArray_AsString) and TPyObject.IsInitialized(ob) then
    Result := PyUTF8ToString(PyByteArray_AsString(ob.PyObject))
   else
    Result := '';
end;

class function TPyByteArray.AsBuffer(const ob: IPyObject): PByte;
begin
  if assigned(PyByteArray_AsString) and TPyObject.IsInitialized(ob) then
    Result := PByte(PyByteArray_AsString(ob.PyObject))
   else
    Result := nil;
end;

class function TPyByteArray.Resize(const ob: IPyObject; size: Py_ssize_t): boolean;
begin
  Result := TPyObject.IsInitialized(ob) and
            assigned(PyByteArray_Resize) and
            (PyByteArray_Resize(ob.PyObject, size) <> -1);
end;

end.
