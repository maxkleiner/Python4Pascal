unit uP4P.PyLong;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.PyNumber;

type
  TPyLong = class
    public
      class function AsLong(const obj: IPyObject): C_Long;
      class function AsLongAndOverflow(const obj: IPyObject; var overflow: integer): C_Long;
      class function AsSsize_t(const pylong: IPyObject): Py_ssize_t;
      class function AsSize_t(const pylong: IPyObject): NativeUInt;
      class function AsUnsignedLong(const pylong: IPyObject): C_ULong;
      class function AsUnsignedLongMask(const obj: IPyObject): C_ULong;
      class function AsInt(const obj: IPyObject): integer;
      class function AsInt32(const obj: IPyObject; out aValue: Integer): boolean;
      class function AsUInt32(const obj: IPyObject; out aValue: cardinal): boolean;
      class function AsInt64(const obj: IPyObject; out aValue: int64): boolean;
      class function AsUInt64(const obj: IPyObject; out aValue: uint64): boolean;
      class function AsDouble(const pylong: IPyObject): double;
      class function AsVoidPtr(const pylong: IPyObject): Pointer;
      class function AsLongLong(const obj: IPyObject): Int64;
      class function AsUnsignedLongLong(const pylong: IPyObject): uint64;
      class function AsUnsignedLongLongMask(const obj: IPyObject): uint64;
      class function AsLongLongAndOverflow(const obj: IPyObject; var overflow: integer): Int64;
      class function AsNativeBytes(const obj: IPyObject; buffer: Pointer; n_bytes: Py_ssize_t; flags: integer): Py_ssize_t;
      class function IsPositive(const obj: IPyObject): boolean;
      class function IsNegative(const obj: IPyObject): boolean;
      class function IsZero(const obj: IPyObject): boolean;
      class function GetSign(const obj: IPyObject; out sign: integer): boolean;
      class function Export_(const obj: IPyObject; var aLongExport: IPyLongExport): boolean;
      class function FromLong(v: C_Long): IPyObject;
      class function FromUnsignedLong(v: C_ULong): IPyObject;
      class function FromSize_t(v: NativeUInt): IPyObject;
      class function FromSsize_t(v: Py_ssize_t): IPyObject;
      class function FromDouble(v: double): IPyObject;
      class function FromInt32(value: integer): IPyObject;
      class function FromUInt32(value: cardinal): IPyObject;
      class function FromInt64(value: int64): IPyObject;
      class function FromUInt64(value: uint64): IPyObject;
      class function FromVoidPtr(p: Pointer): IPyObject;
      class function FromLongLong(v: int64): IPyObject;
      class function FromUnsignedLongLong(v: uint64): IPyObject;
      class function FromString(const str: string; base: integer): IPyObject;
      class function FromUnicodeObject(const u: IPyObject; base: integer): IPyObject;
      class function FromNativeBytes(buffer: Pointer; n_bytes: NativeUInt; flags: integer): IPyObject; overload;
      class function FromNativeBytes(const aStream: TMemoryStream; flags: integer): IPyObject; overload;
      class function FromUnsignedNativeBytes(buffer: Pointer; n_bytes: NativeUInt; flags: integer): IPyObject; overload;
      class function FromUnsignedNativeBytes(const aStream: TMemoryStream; flags: integer): IPyObject; overload;
      class function FromVariant(const aVariant: Variant): IPyObject; overload;
      class function FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject; overload;
      class function GetNativeLayout: PPyLongLayout;
      class function GetInfo: IPyObject;
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyLong.FromLong(v: C_Long): IPyObject;
begin
  if assigned(PyLong_FromLong) then
    Result := TPyObject.Wrap(PyLong_FromLong(v))
   else
    Result := nil;
end;

class function TPyLong.FromUnsignedLong(v: C_ULong): IPyObject;
begin
  if assigned(PyLong_FromUnsignedLong) then
    Result := TPyObject.Wrap(PyLong_FromUnsignedLong(v))
   else
    Result := nil;
end;

class function TPyLong.FromSize_t(v: NativeUInt): IPyObject;
begin
  if assigned(PyLong_FromSize_t) then
    Result := TPyObject.Wrap(PyLong_FromSize_t(v))
   else
    Result := nil;
end;

class function TPyLong.FromSsize_t(v: Py_ssize_t): IPyObject;
begin
  if assigned(PyLong_FromSsize_t) then
    Result := TPyObject.Wrap(PyLong_FromSsize_t(v))
   else
    Result := nil;
end;

class function TPyLong.FromDouble(v: double): IPyObject;
begin
  if assigned(PyLong_FromDouble) then
    Result := TPyObject.Wrap(PyLong_FromDouble(v))
   else
    Result := nil;
end;

class function TPyLong.FromInt32(value: integer): IPyObject;
begin
  if assigned(PyLong_FromInt32) then
    Result := TPyObject.Wrap(PyLong_FromInt32(value))
   else
    Result := nil;
end;

class function TPyLong.FromUInt32(value: cardinal): IPyObject;
begin
  if assigned(PyLong_FromUInt32) then
    Result := TPyObject.Wrap(PyLong_FromUInt32(value))
   else
    Result := nil;
end;

class function TPyLong.FromInt64(value: int64): IPyObject;
begin
  if assigned(PyLong_FromInt64) then
    Result := TPyObject.Wrap(PyLong_FromInt64(value))
   else
    Result := nil;
end;

class function TPyLong.FromUInt64(value: uint64): IPyObject;
begin
  if assigned(PyLong_FromUInt64) then
    Result := TPyObject.Wrap(PyLong_FromUInt64(value))
   else
    Result := nil;
end;

class function TPyLong.FromVoidPtr(p: Pointer): IPyObject;
begin
  if assigned(PyLong_FromVoidPtr) then
    Result := TPyObject.Wrap(PyLong_FromVoidPtr(p))
   else
    Result := nil;
end;

class function TPyLong.FromLongLong(v: int64): IPyObject;
begin
  if assigned(PyLong_FromLongLong) then
    Result := TPyObject.Wrap(PyLong_FromLongLong(v))
   else
    Result := nil;
end;

class function TPyLong.FromUnsignedLongLong(v: uint64): IPyObject;
begin
  if assigned(PyLong_FromUnsignedLongLong) then
    Result := TPyObject.Wrap(PyLong_FromUnsignedLongLong(v))
   else
    Result := nil;
end;

class function TPyLong.FromString(const str: string; base: integer): IPyObject;
var
  TempString : AnsiString;
  TempPend   : PAnsiChar;
begin
  Result := nil;
  if not(assigned(PyLong_FromString)) or (length(str) = 0) or (base < 0) or (base = 1) or (base > 36) then exit;

  TempString := StringToPyUTF8(str);
  Result     := TPyObject.Wrap(PyLong_FromString(PAnsiChar(TempString), @TempPend, base));
end;

class function TPyLong.FromUnicodeObject(const u: IPyObject; base: integer): IPyObject;
begin
  if assigned(PyLong_FromUnicodeObject) and
     TPyObject.IsInitialized(u) then
    Result := TPyObject.Wrap(PyLong_FromUnicodeObject(u.PyObject, base))
   else
    Result := nil;
end;

class function TPyLong.FromNativeBytes(buffer: Pointer; n_bytes: NativeUInt; flags: integer): IPyObject;
begin
  if assigned(PyLong_FromNativeBytes) and assigned(buffer) then
    Result := TPyObject.Wrap(PyLong_FromNativeBytes(buffer, n_bytes, flags))
   else
    Result := nil;
end;

class function TPyLong.FromNativeBytes(const aStream: TMemoryStream; flags: integer): IPyObject;
begin
  if assigned(aStream) and (aStream.Size > 0) then
    Result := FromNativeBytes(aStream.Memory, aStream.Size, flags)
   else
    Result := nil;
end;

class function TPyLong.FromUnsignedNativeBytes(buffer: Pointer; n_bytes: NativeUInt; flags: integer): IPyObject;
begin
  if assigned(PyLong_FromUnsignedNativeBytes) and assigned(buffer) then
    Result := TPyObject.Wrap(PyLong_FromUnsignedNativeBytes(buffer, n_bytes, flags))
   else
    Result := nil;
end;

class function TPyLong.FromUnsignedNativeBytes(const aStream: TMemoryStream; flags: integer): IPyObject;
begin
  if assigned(aStream) and (aStream.Size > 0) then
    Result := FromUnsignedNativeBytes(aStream.Memory, aStream.Size, flags)
   else
    Result := nil;
end;

class function TPyLong.FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject;
begin
  case aVarType of
    varSmallint,
    varByte,
    varShortInt,
    varWord,
    varInteger   : Result := FromLong(integer(aVariant));
    varLongWord  : Result := FromUnsignedLong(cardinal(aVariant));
    varInt64     : Result := FromLongLong(aVariant);
    varUInt64    : Result := FromUnsignedLongLong(aVariant);
    else           Result := nil;
  end;
end;

class function TPyLong.FromVariant(const aVariant: Variant): IPyObject;
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

class function TPyLong.GetNativeLayout: PPyLongLayout;
begin
  if assigned(PyLong_GetNativeLayout) then
    Result := PyLong_GetNativeLayout()
   else
    Result := nil;
end;

class function TPyLong.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            TPyTypeObject.FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_LONG_SUBCLASS));
end;

class function TPyLong.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyLong_Type);
end;

class function TPyLong.AsLong(const obj: IPyObject): C_Long;
begin
  if assigned(PyLong_AsLong) and
     TPyObject.IsInitialized(obj) then
    Result := PyLong_AsLong(obj.PyObject)
   else
    Result := -1;
end;

class function TPyLong.AsLongAndOverflow(const obj: IPyObject; var overflow: integer): C_Long;
begin
  if assigned(PyLong_AsLongAndOverflow) and
     TPyObject.IsInitialized(obj) then
    Result := PyLong_AsLongAndOverflow(obj.PyObject, overflow)
   else
    Result := -1;
end;

class function TPyLong.AsSsize_t(const pylong: IPyObject): Py_ssize_t;
begin
  if assigned(PyLong_AsSsize_t) and
     TPyObject.IsInitialized(pylong) then
    Result := PyLong_AsSsize_t(pylong.PyObject)
   else
    Result := -1;
end;

class function TPyLong.AsSize_t(const pylong: IPyObject): NativeUInt;
begin
  if assigned(PyLong_AsSize_t) and
     TPyObject.IsInitialized(pylong) then
    Result := PyLong_AsSize_t(pylong.PyObject)
   else
    Result := NativeUInt(-1);
end;

class function TPyLong.AsUnsignedLong(const pylong: IPyObject): C_ULong;
begin
  if assigned(PyLong_AsUnsignedLong) and
     TPyObject.IsInitialized(pylong) then
    Result := PyLong_AsUnsignedLong(pylong.PyObject)
   else
    Result := C_ULong(-1);
end;

class function TPyLong.AsUnsignedLongMask(const obj: IPyObject): C_ULong;
begin
  if assigned(PyLong_AsUnsignedLongMask) and
     TPyObject.IsInitialized(obj) then
    Result := PyLong_AsUnsignedLongMask(obj.PyObject)
   else
    Result := C_ULong(-1);
end;

class function TPyLong.AsInt(const obj: IPyObject): integer;
begin
  if assigned(PyLong_AsInt) and
     TPyObject.IsInitialized(obj) then
    Result := PyLong_AsInt(obj.PyObject)
   else
    Result := -1;
end;

class function TPyLong.AsInt32(const obj: IPyObject; out aValue: Integer): boolean;
begin
  Result := assigned(PyLong_AsInt32) and
            TPyObject.IsInitialized(obj) and
            (PyLong_AsInt32(obj.PyObject, aValue) = 0);
end;

class function TPyLong.AsUInt32(const obj: IPyObject; out aValue: cardinal): boolean;
begin
  Result := assigned(PyLong_AsUInt32) and
            TPyObject.IsInitialized(obj) and
            (PyLong_AsUInt32(obj.PyObject, aValue) = 0);
end;

class function TPyLong.AsInt64(const obj: IPyObject; out aValue: int64): boolean;
begin
  Result := assigned(PyLong_AsInt64) and
            TPyObject.IsInitialized(obj) and
            (PyLong_AsInt64(obj.PyObject, aValue) = 0);
end;

class function TPyLong.AsUInt64(const obj: IPyObject; out aValue: uint64): boolean;
begin
  Result := assigned(PyLong_AsUInt64) and
            TPyObject.IsInitialized(obj) and
            (PyLong_AsUInt64(obj.PyObject, aValue) = 0);
end;

class function TPyLong.AsDouble(const pylong: IPyObject): double;
begin
  if assigned(PyLong_AsDouble) and
     TPyObject.IsInitialized(pylong) then
    Result := PyLong_AsDouble(pylong.PyObject)
   else
    Result := -1;
end;

class function TPyLong.AsVoidPtr(const pylong: IPyObject): Pointer;
begin
  if assigned(PyLong_AsVoidPtr) and
     TPyObject.IsInitialized(pylong) then
    Result := PyLong_AsVoidPtr(pylong.PyObject)
   else
    Result := nil;
end;

class function TPyLong.AsLongLong(const obj: IPyObject): Int64;
begin
  if assigned(PyLong_AsLongLong) and
     TPyObject.IsInitialized(obj) then
    Result := PyLong_AsLongLong(obj.PyObject)
   else
    Result := -1;
end;

class function TPyLong.AsUnsignedLongLong(const pylong: IPyObject): uint64;
begin
  if assigned(PyLong_AsUnsignedLongLong) and
     TPyObject.IsInitialized(pylong) then
    Result := PyLong_AsUnsignedLongLong(pylong.PyObject)
   else
    Result := uint64(-1);
end;

class function TPyLong.AsUnsignedLongLongMask(const obj: IPyObject): uint64;
begin
  if assigned(PyLong_AsUnsignedLongLongMask) and
     TPyObject.IsInitialized(obj) then
    Result := PyLong_AsUnsignedLongLongMask(obj.PyObject)
   else
    Result := uint64(-1);
end;

class function TPyLong.AsLongLongAndOverflow(const obj: IPyObject; var overflow: integer): Int64;
begin
  if assigned(PyLong_AsLongLongAndOverflow) and
     TPyObject.IsInitialized(obj) then
    Result := PyLong_AsLongLongAndOverflow(obj.PyObject, overflow)
   else
    Result := -1;
end;

class function TPyLong.AsNativeBytes(const obj: IPyObject; buffer: Pointer; n_bytes: Py_ssize_t; flags: integer): Py_ssize_t;
begin
  if assigned(PyLong_AsNativeBytes) and
     TPyObject.IsInitialized(obj) then
    Result := PyLong_AsNativeBytes(obj.PyObject, buffer, n_bytes, flags)
   else
    Result := -1;
end;

class function TPyLong.IsPositive(const obj: IPyObject): boolean;
begin
  Result := assigned(PyLong_IsPositive) and
            TPyObject.IsInitialized(obj) and
            (PyLong_IsPositive(obj.PyObject) > 0);
end;

class function TPyLong.IsNegative(const obj: IPyObject): boolean;
begin
  Result := assigned(PyLong_IsNegative) and
            TPyObject.IsInitialized(obj) and
            (PyLong_IsNegative(obj.PyObject) > 0);
end;

class function TPyLong.IsZero(const obj: IPyObject): boolean;
begin
  Result := assigned(PyLong_IsZero) and
            TPyObject.IsInitialized(obj) and
            (PyLong_IsZero(obj.PyObject) > 0);
end;

class function TPyLong.GetSign(const obj: IPyObject; out sign: integer): boolean;
begin
  Result := assigned(PyLong_GetSign) and
            TPyObject.IsInitialized(obj) and
            (PyLong_GetSign(obj.PyObject, sign) = 0);
end;

class function TPyLong.GetInfo: IPyObject;
begin
  if assigned(PyLong_GetInfo) then
    Result := TPyObject.Wrap(PyLong_GetInfo())
   else
    Result := nil;
end;

class function TPyLong.Export_(const obj: IPyObject; var aLongExport: IPyLongExport): boolean;
begin
  Result := assigned(PyLong_Export) and
            TPyObject.IsInitialized(obj) and
            (PyLong_Export(obj.PyObject, aLongExport.LongExport) = 0);
end;

end.
