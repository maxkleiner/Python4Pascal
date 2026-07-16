unit uP4P.PyBytes;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.Variants,
  {$ELSE}
    Classes, Variants,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  TPyBytes = class
    public
      class function Size(const ob: IPyObject): Py_ssize_t;
      class function AsString(const ob: IPyObject): string;
      class function AsAnsiString(const ob: IPyObject): AnsiString;
      class function AsWideString(const ob: IPyObject): WideString;
      class function AsBuffer(const ob: IPyObject): PByte;
      class function Repr(const ob: IPyObject; smartquotes: boolean): IPyObject;
      class procedure Concat(const bytes, newpart: IPyObject);
      class procedure ConcatAndDel(const bytes, newpart: IPyObject);
      class function AsStringAndSize(const ob: IPyObject; var buffer: string; var length: Py_ssize_t): boolean;
      class function AsBufferAndSize(const ob: IPyObject; var buffer: PByte; var length: Py_ssize_t): boolean;
      class function Join(const sep, iterable: IPyObject): IPyObject;
      class function FromStringAndSize(const str: string; size_: Py_ssize_t): IPyObject;
      class function FromBufferAndSize(const buffer: PByte; size_: Py_ssize_t): IPyObject;
      class function FromString(const str: string): IPyObject;
      class function FromBuffer(const buffer: PByte): IPyObject;
      class function FromObject(const ob: IPyObject): IPyObject;
      class function FromVariant(const aVariant: Variant): IPyObject; overload;
      class function FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject; overload;
      class function DecodeEscape(const s: string; errors: TPyCodecErrors): IPyObject;
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;

  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyBytes.FromStringAndSize(const str: string; size_: Py_ssize_t): IPyObject;
var
  TempString: AnsiString;
begin
  if assigned(PyBytes_FromStringAndSize) then
    begin
      TempString := StringToPyUTF8(str);
      Result     := TPyObject.Wrap(PyBytes_FromStringAndSize(PAnsiChar(TempString), size_))
    end
   else
    Result := nil;
end;

class function TPyBytes.FromBufferAndSize(const buffer: PByte; size_: Py_ssize_t): IPyObject;
begin
  if assigned(PyBytes_FromStringAndSize) then
    Result := TPyObject.Wrap(PyBytes_FromStringAndSize(PAnsiChar(buffer), size_))
   else
    Result := nil;
end;

class function TPyBytes.FromString(const str: string): IPyObject;
var
  TempString: AnsiString;
begin
  if assigned(PyBytes_FromString) then
    begin
      TempString := StringToPyUTF8(str);
      Result     := TPyObject.Wrap(PyBytes_FromString(PAnsiChar(TempString)))
    end
   else
    Result := nil;
end;

class function TPyBytes.FromBuffer(const buffer: PByte): IPyObject;
begin
  if assigned(PyBytes_FromString) then
    Result := TPyObject.Wrap(PyBytes_FromString(PAnsiChar(buffer)))
   else
    Result := nil;
end;

class function TPyBytes.FromObject(const ob: IPyObject): IPyObject;
begin
  if assigned(PyBytes_FromObject) and TPyObject.IsInitialized(ob) then
    Result := TPyObject.Wrap(PyBytes_FromObject(ob.PyObject))
   else
    Result := nil;
end;

class function TPyBytes.FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject;
begin
  case aVarType of
    varOleStr,
    {$IFDEF SUPPORTS_VARUSTRING}
    varUString,
    {$ENDIF}
    varString  : Result := FromString(string(aVariant))
    else         Result := nil;
  end;
end;

class function TPyBytes.FromVariant(const aVariant: Variant): IPyObject;
var
  TempType    : TVarType;
  TempVariant : Variant;
begin
  TempVariant := aVariant;
  TempType    := varByRef or varVariant;

  while VarType(TempVariant) = TempType do
    TempVariant := Variant(PVarData(TVarData(TempVariant).VPointer)^);

  Result := FromVariant(TempVariant, VarType(TempVariant) and (VarTypeMask or VarArray));
end;

class function TPyBytes.DecodeEscape(const s: string; errors: TPyCodecErrors): IPyObject;
var
  TempString, TempErrors : AnsiString;
begin
  if assigned(PyBytes_DecodeEscape) then
    begin
      TempErrors := ErrorToAnsiString(errors);
      TempString := StringToPyUTF8(s);
      // Changed in version 3.9: unicode and recode_encoding are now unused.
      Result     := TPyObject.Wrap(PyBytes_DecodeEscape(PAnsiChar(TempString), length(TempString), PAnsiChar(TempErrors), 0, nil));
    end
   else
    Result := nil;
end;

class function TPyBytes.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            TPyTypeObject.FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_BYTES_SUBCLASS));
end;

class function TPyBytes.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyBytes_Type);
end;

class function TPyBytes.Size(const ob: IPyObject): Py_ssize_t;
begin
  if assigned(PyBytes_Size) and TPyObject.IsInitialized(ob) then
    Result := PyBytes_Size(ob.PyObject)
   else
    Result := 0;
end;

class function TPyBytes.AsString(const ob: IPyObject): string;
begin
  if assigned(PyBytes_AsString) and TPyObject.IsInitialized(ob) then
    Result := PyUTF8ToString(PyBytes_AsString(ob.PyObject))
   else
    Result := '';
end;

class function TPyBytes.AsAnsiString(const ob: IPyObject): AnsiString;
begin
  if assigned(PyBytes_AsString) and TPyObject.IsInitialized(ob) then
    Result := PyBytes_AsString(ob.PyObject)
   else
    Result := '';
end;

class function TPyBytes.AsWideString(const ob: IPyObject): WideString;
begin
  if assigned(PyBytes_AsString) and TPyObject.IsInitialized(ob) then
    Result := PyUTF8ToWideString(PyBytes_AsString(ob.PyObject))
   else
    Result := '';
end;

class function TPyBytes.AsBuffer(const ob: IPyObject): PByte;
begin
  if assigned(PyBytes_AsString) and TPyObject.IsInitialized(ob) then
    Result := PByte(PyBytes_AsString(ob.PyObject))
   else
    Result := nil;
end;

class function TPyBytes.Repr(const ob: IPyObject; smartquotes: boolean): IPyObject;
begin
  if assigned(PyBytes_AsString) and TPyObject.IsInitialized(ob) then
    Result := TPyObject.Wrap(PyBytes_Repr(ob.PyObject, ord(smartquotes)))
   else
    Result := nil;
end;

class procedure TPyBytes.Concat(const bytes, newpart: IPyObject);
var
  TempObject : PPyObject;
begin
  if assigned(PyBytes_Concat) and
     TPyObject.IsInitialized(bytes) and
     TPyObject.IsInitialized(newpart) then
    begin
      TempObject := bytes.PyObject;
      PyBytes_Concat(@TempObject, newpart.PyObject);
      if not(assigned(TempObject)) then bytes.InitPyObject;
    end;
end;

class procedure TPyBytes.ConcatAndDel(const bytes, newpart: IPyObject);
var
  TempRefCnt : integer;
  TempObject : PPyObject;
begin
  if assigned(PyBytes_ConcatAndDel) and
     TPyObject.IsInitialized(bytes) and
     TPyObject.IsInitialized(newpart) then
    begin
      TempObject := bytes.PyObject;
      TempRefCnt := newpart.RefCnt;

      PyBytes_ConcatAndDel(@TempObject, newpart.PyObject);
      if not(assigned(TempObject)) then bytes.InitPyObject;

      if (TempRefCnt = 1) then
        newpart.InitPyObject;
    end;
end;

class function TPyBytes.AsStringAndSize(const ob: IPyObject; var buffer: string; var length: Py_ssize_t): boolean;
var
  TempBuffer: PAnsiChar;
begin
  if assigned(PyBytes_AsStringAndSize) and
     TPyObject.IsInitialized(ob) and
     (PyBytes_AsStringAndSize(ob.PyObject, TempBuffer, length) = 0) then
    begin
      buffer := PyUTF8ToString(TempBuffer);
      Result := True;
    end
   else
    Result := False;
end;

class function TPyBytes.AsBufferAndSize(const ob: IPyObject; var buffer: PByte; var length: Py_ssize_t): boolean;
begin
  Result := assigned(PyBytes_AsStringAndSize) and
            TPyObject.IsInitialized(ob) and
            (PyBytes_AsStringAndSize(ob.PyObject, PAnsiChar(buffer), length) = 0);
end;

class function TPyBytes.Join(const sep, iterable: IPyObject): IPyObject;
begin
  if assigned(PyBytes_Join) and
     TPyObject.IsInitialized(sep) and
     TPyObject.IsInitialized(iterable) then
    Result := TPyObject.Wrap(PyBytes_Join(sep.PyObject, iterable.PyObject))
   else
    Result := nil;
end;

end.
