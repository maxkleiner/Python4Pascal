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
  /// <summary>
  /// Helper class for all PyLong_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/long.html#integer-objects">See the article about Integer Objects.</see></para>
  /// </remarks>
  TPyLong = class
    public
      /// <summary>
      /// <para>Return a C_long representation of obj. If obj is not an
      /// instance of PyLongObject, first call its __index__() method
      /// (if present) to convert it to a PyLongObject.</para>
      /// <para>Raise OverflowError if the value of obj is out of range for a
      /// long.</para>
      /// <para>Returns -1 on error. Use TPyErr.Occurred() to
      /// disambiguate.</para>
      /// </summary>
      class function AsLong(const obj: IPyObject): C_Long;
      /// <summary>
      /// <para>Return a C_long representation of obj. If obj is not an instance
      /// of PyLongObject, first call its __index__() method (if present) to
      /// convert it to a PyLongObject.</para>
      /// <para>If the value of obj is greater than LONG_MAX or less than
      /// LONG_MIN, set overflow to 1 or -1, respectively, and return -1;
      /// otherwise, set overflow to 0. If any other exception occurs set
      /// overflow to 0 and return -1 as usual.</para>
      /// <para>Returns -1 on error. Use TPyErr.Occurred() to
      /// disambiguate.</para>
      /// </summary>
      class function AsLongAndOverflow(const obj: IPyObject; var overflow: integer): C_Long;
      /// <summary>
      /// <para>Return a Py_ssize_t representation of pylong. pylong must be
      /// an instance of PyLongObject.</para>
      /// <para>Raise OverflowError if the value of pylong is out of range for a
      /// Py_ssize_t.</para>
      /// <para>Returns -1 on error. Use TPyErr.Occurred() to
      /// disambiguate.</para>
      /// </summary>
      class function AsSsize_t(const pylong: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Return a NativeUInt representation of pylong. pylong must be an
      /// instance of PyLongObject.</para>
      /// <para>Raise OverflowError if the value of pylong is out of range for a
      /// size_t.</para>
      /// <para>Returns (size_t)-1 on error. Use TPyErr.Occurred() to
      /// disambiguate.</para>
      /// </summary>
      class function AsSize_t(const pylong: IPyObject): NativeUInt;
      /// <summary>
      /// <para>Return a C_ULong representation of pylong. pylong must be an
      /// instance of PyLongObject.</para>
      /// <para>Raise OverflowError if the value of pylong is out of range for a
      /// unsigned long.</para>
      /// <para>Returns (unsigned long)-1 on error. Use TPyErr.Occurred() to
      /// disambiguate.</para>
      /// </summary>
      class function AsUnsignedLong(const pylong: IPyObject): C_ULong;
      /// <summary>
      /// <para>Return a C_ULong representation of obj. If obj is not an
      /// instance of PyLongObject, first call its __index__() method
      /// (if present) to convert it to a PyLongObject.</para>
      /// <para>If the value of obj is out of range for an unsigned long, return
      /// the reduction of that value modulo ULONG_MAX + 1.</para>
      /// <para>Returns (unsigned long)-1 on error. Use TPyErr.Occurred() to
      /// disambiguate.</para>
      /// </summary>
      class function AsUnsignedLongMask(const obj: IPyObject): C_ULong;
      /// <summary>
      /// <para>Similar to TPyLong.AsLong(), but store the result in a integer
      /// instead of a C_long.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function AsInt(const obj: IPyObject): integer;
      /// <summary>
      /// <para>Set *value to an Integer representation of obj.</para>
      /// <para>If obj is not an instance of PyLongObject, first call its
      /// __index__() method (if present) to convert it to a PyLongObject.</para>
      /// <para>If the obj value is out of range, raise an OverflowError.</para>
      /// <para>Set aValue and return True on success. Set an exception and
      /// return False on error.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function AsInt32(const obj: IPyObject; out aValue: Integer): boolean;
      /// <summary>
      /// <para>Set aValue to a cardinal representation of obj.</para>
      /// <para>If obj is not an instance of PyLongObject, first call its
      /// __index__() method (if present) to convert it to a PyLongObject.</para>
      /// <para>If obj is negative, raise a ValueError.</para>
      /// <para>If the obj value is out of range, raise an OverflowError.</para>
      /// <para>Set aValue and return True on success. Set an exception and
      /// return False on error.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function AsUInt32(const obj: IPyObject; out aValue: cardinal): boolean;
      /// <summary>
      /// <para>Set *value to an int64 representation of obj.</para>
      /// <para>If obj is not an instance of PyLongObject, first call its
      /// __index__() method (if present) to convert it to a PyLongObject.</para>
      /// <para>If the obj value is out of range, raise an OverflowError.</para>
      /// <para>Set aValue and return True on success. Set an exception and
      /// return False on error.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function AsInt64(const obj: IPyObject; out aValue: int64): boolean;
      /// <summary>
      /// <para>Set aValue to a uint64 representation of obj.</para>
      /// <para>If obj is not an instance of PyLongObject, first call its
      /// __index__() method (if present) to convert it to a PyLongObject.</para>
      /// <para>If obj is negative, raise a ValueError.</para>
      /// <para>If the obj value is out of range, raise an OverflowError.</para>
      /// <para>Set aValue and return True on success. Set an exception and
      /// return False on error.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function AsUInt64(const obj: IPyObject; out aValue: uint64): boolean;
      /// <summary>
      /// <para>Return a double representation of pylong. pylong must be an
      /// instance of PyLongObject.</para>
      /// <para>Raise OverflowError if the value of pylong is out of range for
      /// a double.</para>
      /// <para>Returns -1.0 on error. Use TPyErr.Occurred() to
      /// disambiguate.</para>
      /// </summary>
      class function AsDouble(const pylong: IPyObject): double;
      /// <summary>
      /// <para>Convert a Python integer pylong to a pointer. If pylong cannot
      /// be converted, an OverflowError will be raised. This is only assured
      /// to produce a usable void pointer for values created with
      /// TPyLong.FromVoidPtr().</para>
      /// <para>Returns nil on error. Use TPyErr.Occurred() to
      /// disambiguate.</para>
      /// </summary>
      class function AsVoidPtr(const pylong: IPyObject): Pointer;
      /// <summary>
      /// <para>Return an Int64 representation of obj. If obj is not an instance
      /// of PyLongObject, first call its __index__() method (if present) to
      /// convert it to a PyLongObject.</para>
      /// <para>Raise OverflowError if the value of obj is out of range for a
      /// Int64.</para>
      /// <para>Returns -1 on error. Use TPyErr.Occurred() to
      /// disambiguate.</para>
      /// </summary>
      class function AsLongLong(const obj: IPyObject): Int64;
      /// <summary>
      /// <para>Return a uint64 representation of pylong. pylong must be an
      /// instance of PyLongObject.</para>
      /// <para>Raise OverflowError if the value of pylong is out of range for
      /// a uint64.</para>
      /// <para>Returns uint64(-1) on error. Use TPyErr.Occurred() to
      /// disambiguate.</para>
      /// </summary>
      class function AsUnsignedLongLong(const pylong: IPyObject): uint64;
      /// <summary>
      /// <para>Return a uint64 representation of obj. If obj is not an instance
      /// of PyLongObject, first call its __index__() method (if present) to
      /// convert it to a PyLongObject.</para>
      /// <para>If the value of obj is out of range for an uint64, return the
      /// reduction of that value modulo ULLONG_MAX + 1.</para>
      /// <para>Returns (uint64)-1 on error. Use TPyErr.Occurred() to
      /// disambiguate.</para>
      /// </summary>
      class function AsUnsignedLongLongMask(const obj: IPyObject): uint64;
      /// <summary>
      /// <para>Return a Int64 representation of obj. If obj is not an instance
      /// of PyLongObject, first call its __index__() method (if present) to
      /// convert it to a PyLongObject.</para>
      /// <para>If the value of obj is greater than LLONG_MAX or less than
      /// LLONG_MIN, set overflow to 1 or -1, respectively, and return -1;
      /// otherwise, set overflow to 0. If any other exception occurs set
      /// overflow to 0 and return -1 as usual.</para>
      /// <para>Returns -1 on error. Use TPyErr.Occurred() to
      /// disambiguate.</para>
      /// </summary>
      class function AsLongLongAndOverflow(const obj: IPyObject; var overflow: integer): Int64;
      /// <summary>
      /// <para>Copy the Python integer value pylong to a native buffer of size
      /// n_bytes. The flags can be set to -1 to behave similarly to a C cast,
      /// or to values documented below to control the behavior.</para>
      /// <para>Returns -1 with an exception raised on error. This may happen
      /// if pylong cannot be interpreted as an integer, or if pylong was
      /// negative and the Py_ASNATIVEBYTES_REJECT_NEGATIVE flag was set.</para>
      /// <para>Otherwise, returns the number of bytes required to store the
      /// value. If this is equal to or less than n_bytes, the entire value was
      /// copied. All n_bytes of the buffer are written: remaining bytes filled
      /// by copies of the sign bit.</para>
      /// <para>If the returned value is greater than n_bytes, the value was
      /// truncated: as many of the lowest bits of the value as could fit are
      /// written, and the higher bits are ignored. This matches the typical
      /// behavior of a C-style downcast.</para>
      /// <para>Note: Overflow is not considered an error. If the returned value
      /// is larger than n_bytes, most significant bits were discarded.</para>
      /// <para>0 will never be returned.</para>
      /// <para>Values are always copied as two's-complement.</para>
      /// </summary>
      class function AsNativeBytes(const obj: IPyObject; buffer: Pointer; n_bytes: Py_ssize_t; flags: integer): Py_ssize_t;
      /// <summary>
      /// <para>If obj is an instance of PyLongObject or its subtype, return 1
      /// when it's positive and 0 otherwise. Else set an exception and
      /// return -1.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function IsPositive(const obj: IPyObject): integer;
      /// <summary>
      /// <para>If obj is an instance of PyLongObject or its subtype, return 1
      /// when it's positive and 0 otherwise. Else set an exception and
      /// return -1.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function IsNegative(const obj: IPyObject): integer;
      /// <summary>
      /// <para>If obj is an instance of PyLongObject or its subtype, return 1
      /// when it's zero and 0 otherwise. Else set an exception and
      /// return -1.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function IsZero(const obj: IPyObject): integer;
      /// <summary>
      /// <para>Get the sign of the integer object obj.</para>
      /// <para>On success, set sign to the integer sign (0, -1 or +1 for zero,
      /// negative or positive integer, respectively) and return True.</para>
      /// <para>On failure, return False with an exception set. This function
      /// always succeeds if obj is a PyLongObject or its subtype.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function GetSign(const obj: IPyObject; out sign: integer): boolean;
      /// <summary>
      /// <para>Export a Python int object.</para>
      /// <para>On success, fill in export_long and return True. On error, set
      /// an exception and return False.</para>
      /// <para>TPyLong.FreeExport() must be called when the export is no longer
      /// needed.</para>
      /// <para>CPython implementation detail: This function always succeeds if
      /// obj is a Python int object or a subclass.</para>
      /// </summary>
      class function Export_(const obj: IPyObject; var export_long: IPyLongExport): boolean;
      /// <summary>
      /// <para>Return a new PyLongObject object from v, or nil on
      /// failure.</para>
      /// <para>CPython implementation detail: CPython keeps an array of integer
      /// objects for all integers between -5 and 1024. When you create an int
      /// in that range you actually just get back a reference to the existing
      /// object.</para>
      /// </summary>
      class function FromLong(v: C_Long): IPyObject;
      /// <summary>
      /// <para>Return a new PyLongObject object from a C_ULong, or nil
      /// on failure.</para>
      /// </summary>
      class function FromUnsignedLong(v: C_ULong): IPyObject;
      /// <summary>
      /// <para>Return a new PyLongObject object from a NativeUInt, or nil on
      /// failure.</para>
      /// </summary>
      class function FromSize_t(v: NativeUInt): IPyObject;
      /// <summary>
      /// <para>Return a new PyLongObject object from a Py_ssize_t, or nil on
      /// failure.</para>
      /// </summary>
      class function FromSsize_t(v: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Return a new PyLongObject object from the integer part of v,
      /// or nil on failure.</para>
      /// </summary>
      class function FromDouble(v: double): IPyObject;
      /// <summary>
      /// <para>Return a new PyLongObject object from a integer, or nil with an
      /// exception set on failure.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function FromInt32(value: integer): IPyObject;
      /// <summary>
      /// <para>Return a new PyLongObject object from a cardinal, or nil with an
      /// exception set on failure.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function FromUInt32(value: cardinal): IPyObject;
      /// <summary>
      /// <para>Return a new PyLongObject object from a int64, or nil with an
      /// exception set on failure.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function FromInt64(value: int64): IPyObject;
      /// <summary>
      /// <para>Return a new PyLongObject object from a uint64, or nil with an
      /// exception set on failure.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function FromUInt64(value: uint64): IPyObject;
      /// <summary>
      /// <para>Create a Python integer from the pointer p. The pointer value
      /// can be retrieved from the resulting value using
      /// TPyLong.AsVoidPtr().</para>
      /// </summary>
      class function FromVoidPtr(p: Pointer): IPyObject;
      /// <summary>
      /// <para>Return a new PyLongObject object from a int64, or nil on
      /// failure.</para>
      /// </summary>
      class function FromLongLong(v: int64): IPyObject;
      /// <summary>
      /// <para>Return a new PyLongObject object from a uint64, or nil on
      /// failure.</para>
      /// </summary>
      class function FromUnsignedLongLong(v: uint64): IPyObject;
      /// <summary>
      /// <para>Return a new PyLongObject based on the string value in str,
      /// which is interpreted according to the radix in base, or nil on
      /// failure. If base is 0, str is interpreted using the Integer literals
      /// definition; in this case, leading zeros in a non-zero decimal number
      /// raises a ValueError. If base is not 0, it must be between 2 and 36,
      /// inclusive. Leading and trailing whitespace and single underscores
      /// after a base specifier and between digits are ignored. If there are
      /// no digits, ValueError will be raised.</para>
      /// <para>See also TPyLong.AsNativeBytes() and TPyLong.FromNativeBytes()
      /// functions can be used to convert a PyLongObject to/from an array of
      /// bytes in base 256.</para>
      /// </summary>
      class function FromString(const str: string; base: integer): IPyObject;
      /// <summary>
      /// <para>Convert a sequence of Unicode digits in the string u to a Python
      /// integer value.</para>
      /// </summary>
      class function FromUnicodeObject(const u: IPyObject; base: integer): IPyObject;
      /// <summary>
      /// <para>Create a Python integer from the value contained in the first
      /// n_bytes of buffer, interpreted as a two's-complement signed
      /// number.</para>
      /// <para>flags are as for TPyLong.AsNativeBytes(). Passing -1 will select
      /// the native endian that CPython was compiled with and assume that the
      /// most-significant bit is a sign bit. Passing
      /// Py_ASNATIVEBYTES_UNSIGNED_BUFFER will produce the same result as
      /// calling TPyLong.FromUnsignedNativeBytes(). Other flags are
      /// ignored.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function FromNativeBytes(buffer: Pointer; n_bytes: NativeUInt; flags: integer): IPyObject; overload;
      /// <summary>
      /// <para>Create a Python integer from the value contained in the stream,
      /// interpreted as a two's-complement signed number.</para>
      /// <para>flags are as for TPyLong.AsNativeBytes(). Passing -1 will select
      /// the native endian that CPython was compiled with and assume that the
      /// most-significant bit is a sign bit. Passing
      /// Py_ASNATIVEBYTES_UNSIGNED_BUFFER will produce the same result as
      /// calling TPyLong.FromUnsignedNativeBytes(). Other flags are
      /// ignored.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function FromNativeBytes(const aStream: TMemoryStream; flags: integer): IPyObject; overload;
      /// <summary>
      /// <para>Create a Python integer from the value contained in the first
      /// n_bytes of buffer, interpreted as an unsigned number.</para>
      /// <para>flags are as for TPyLong.AsNativeBytes(). Passing -1 will select
      /// the native endian that CPython was compiled with and assume that the
      /// most-significant bit is not a sign bit. Flags other than endian are
      /// ignored.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function FromUnsignedNativeBytes(buffer: Pointer; n_bytes: NativeUInt; flags: integer): IPyObject; overload;
      /// <summary>
      /// <para>Create a Python integer from the value contained in the stream,
      /// interpreted as an unsigned number.</para>
      /// <para>flags are as for TPyLong.AsNativeBytes(). Passing -1 will select
      /// the native endian that CPython was compiled with and assume that the
      /// most-significant bit is not a sign bit. Flags other than endian are
      /// ignored.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function FromUnsignedNativeBytes(const aStream: TMemoryStream; flags: integer): IPyObject; overload;
      /// <summary>
      /// <para>Wrap a Variant with a python integer object.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant): IPyObject; overload;
      /// <summary>
      /// <para>Wrap a Variant with a python integer object.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject; overload;
      /// <summary>
      /// <para>Get the native layout of Python int objects.</para>
      /// <para>See the PyLongLayout structure.</para>
      /// <para>The function must not be called before Python initialization nor
      /// after Python finalization. The returned layout is valid until Python
      /// is finalized. The layout is the same for all Python sub-interpreters
      /// in a process, and so it can be cached.</para>
      /// </summary>
      class function GetNativeLayout: PPyLongLayout;
      /// <summary>
      /// <para>On success, return a read only named tuple, that holds
      /// information about Python's internal representation of integers.
      /// See sys.int_info for description of individual fields.</para>
      /// <para>On failure, return nil with an exception set.</para>
      /// </summary>
      class function GetInfo: IPyObject;
      /// <summary>
      /// <para>Return true if its argument is a PyLongObject or a subtype of
      /// PyLongObject. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if its argument is a PyLongObject, but not a subtype
      /// of PyLongObject. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyType;

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
    {$IFDEF SUPPORTS_VARUINT64}
    varUInt64    : Result := FromUnsignedLongLong(aVariant);
    {$ENDIF}
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
            TPyType.FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_LONG_SUBCLASS));
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

class function TPyLong.IsPositive(const obj: IPyObject): integer;
begin
  if assigned(PyLong_IsPositive) and
     TPyObject.IsInitialized(obj) then
    Result := PyLong_IsPositive(obj.PyObject)
   else
    Result := -1;
end;

class function TPyLong.IsNegative(const obj: IPyObject): integer;
begin
  if assigned(PyLong_IsNegative) and
     TPyObject.IsInitialized(obj) then
    Result := PyLong_IsNegative(obj.PyObject)
   else
    Result := -1;
end;

class function TPyLong.IsZero(const obj: IPyObject): integer;
begin
  if assigned(PyLong_IsZero) and
     TPyObject.IsInitialized(obj) then
    Result := PyLong_IsZero(obj.PyObject)
   else
    REsult := -1;
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

class function TPyLong.Export_(const obj: IPyObject; var export_long: IPyLongExport): boolean;
begin
  Result := assigned(PyLong_Export) and
            TPyObject.IsInitialized(obj) and
            (PyLong_Export(obj.PyObject, export_long.LongExport) = 0);
end;

end.
