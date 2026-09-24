unit uP4P.PyFloat;

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
  uP4P.LibFunctions, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyFloat_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/float.html#floating-point-objects">See the article about Floating-Point Objects.</see></para>
  /// </remarks>
  TPyFloat = class
    public
      /// <summary>
      /// <para>Return a double representation of the contents of pyfloat.
      /// If pyfloat is not a Python floating-point object but has a
      /// __float__() method, this method will first be called to convert
      /// pyfloat into a float. If __float__() is not defined then it falls
      /// back to __index__(). This method returns -1.0 upon failure, so one
      /// should call TPyErr.Occurred() to check for errors.</para>
      /// </summary>
      class function AsDouble(const obj: IPyObject): double;
      /// <summary>
      /// <para>Create a PyFloatObject object from v, or nil on failure.</para>
      /// </summary>
      class function FromDouble(v: double): IPyObject;
      /// <summary>
      /// <para>Create a PyFloatObject object based on the string value in str,
      /// or nil on failure.</para>
      /// </summary>
      class function FromString(const str: IPyObject): IPyObject;
      /// <summary>
      /// <para>Wrap a Variant with a Python float object.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant): IPyObject; overload;
      /// <summary>
      /// <para>Wrap a Variant with a Python float object.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject; overload;
      /// <summary>
      /// <para>Return a TPyFloat that represents a quiet not-a-number (qNaN)
      /// value.</para>
      /// </summary>
      class function ReturnNAN: IPyObject;
      /// <summary>
      /// <para>Return a TPyFloat that represents a infinity value.</para>
      /// </summary>
      class function ReturnINF(sign: boolean): IPyObject;
      /// <summary>
      /// <para>Return the maximum representable finite float DBL_MAX as
      /// double.</para>
      /// </summary>
      class function GetMax: double;
      /// <summary>
      /// <para>Return the minimum normalized positive float DBL_MIN as
      /// double.</para>
      /// </summary>
      class function GetMin: double;
      /// <summary>
      /// <para>Return a structseq instance which contains information about
      /// the precision, minimum and maximum values of a float. It's a thin
      /// wrapper around the header file float.h.</para>
      /// </summary>
      class function GetInfo: IPyObject;
      /// <summary>
      /// <para>Return true if its argument is a PyFloatObject or a subtype of
      /// PyFloatObject. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if its argument is a PyFloatObject, but not a
      /// subtype of PyFloatObject. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Pack a double as the IEEE 754 binary16 half-precision
      /// format.</para>
      /// </summary>
      class function Pack2(const x: double; p: pbyte; le: boolean): boolean;
      /// <summary>
      /// <para>Pack a double as the IEEE 754 binary32 half-precision
      /// format.</para>
      /// </summary>
      class function Pack4(const x: double; p: pbyte; le: boolean): boolean;
      /// <summary>
      /// <para>Pack a double as the IEEE 754 binary64 half-precision
      /// format.</para>
      /// </summary>
      class function Pack8(const x: double; p: pbyte; le: boolean): boolean;
      /// <summary>
      /// <para>Unpack the IEEE 754 binary16 half-precision format as a
      /// double.</para>
      /// </summary>
      class function UnPack2(p: pbyte; le: boolean): double;
      /// <summary>
      /// <para>Unpack the IEEE 754 binary32 half-precision format as a
      /// double.</para>
      /// </summary>
      class function UnPack4(p: pbyte; le: boolean): double;
      /// <summary>
      /// <para>Unpack the IEEE 754 binary64 half-precision format as a
      /// double.</para>
      /// </summary>
      class function UnPack8(p: pbyte; le: boolean): double;
  end;

implementation

class function TPyFloat.FromDouble(v: double): IPyObject;
begin
  if assigned(PyFloat_FromDouble) then
    Result := TPyObject.Wrap(PyFloat_FromDouble(v))
   else
    Result := nil;
end;

class function TPyFloat.FromString(const str: IPyObject): IPyObject;
begin
  if assigned(PyFloat_FromString) and
     TPyObject.IsInitialized(str) then
    Result := TPyObject.Wrap(PyFloat_FromString(str.PyObject))
   else
    Result := nil;
end;

class function TPyFloat.FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject;
begin
  case aVarType of
    varSingle,
    varDouble,
    varCurrency : Result := TPyFloat.FromDouble(aVariant);
    else          Result := nil;
  end;
end;

class function TPyFloat.FromVariant(const aVariant: Variant): IPyObject;
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

class function TPyFloat.ReturnNAN: IPyObject;
begin
  Result := FromDouble(Py_NAN);
end;

class function TPyFloat.ReturnINF(sign: boolean): IPyObject;
begin
  if sign then
    Result := FromDouble(Py_INFINITY)
   else
    Result := FromDouble(-Py_INFINITY);
end;

class function TPyFloat.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyFloat_Type);
end;

class function TPyFloat.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyFloat_Type);
end;

class function TPyFloat.GetMax: double;
begin
  if assigned(PyFloat_GetMax) then
    Result := PyFloat_GetMax()
   else
    Result := 0;
end;

class function TPyFloat.GetMin: double;
begin
  if assigned(PyFloat_GetMin) then
    Result := PyFloat_GetMin()
   else
    Result := 0;
end;

class function TPyFloat.GetInfo: IPyObject;
begin
  if assigned(PyFloat_GetInfo) then
    Result := TPyObject.Wrap(PyFloat_GetInfo())
   else
    Result := nil;
end;

class function TPyFloat.Pack2(const x: double; p: pbyte; le: boolean): boolean;
begin
  Result := assigned(PyFloat_Pack2) and
            (PyFloat_Pack2(x, p, ord(le)) = 0);
end;

class function TPyFloat.Pack4(const x: double; p: pbyte; le: boolean): boolean;
begin
  Result := assigned(PyFloat_Pack4) and
            (PyFloat_Pack4(x, p, ord(le)) = 0);
end;

class function TPyFloat.Pack8(const x: double; p: pbyte; le: boolean): boolean;
begin
  Result := assigned(PyFloat_Pack8) and
            (PyFloat_Pack8(x, p, ord(le)) = 0);
end;

class function TPyFloat.UnPack2(p: pbyte; le: boolean): double;
begin
  if assigned(PyFloat_Unpack2) then
    Result := PyFloat_Unpack2(p, ord(le))
   else
    Result := -1;
end;

class function TPyFloat.UnPack4(p: pbyte; le: boolean): double;
begin
  if assigned(PyFloat_Unpack4) then
    Result := PyFloat_Unpack4(p, ord(le))
   else
    Result := -1;
end;

class function TPyFloat.UnPack8(p: pbyte; le: boolean): double;
begin
  if assigned(PyFloat_Unpack8) then
    Result := PyFloat_Unpack8(p, ord(le))
   else
    Result := -1;
end;

class function TPyFloat.AsDouble(const obj: IPyObject): double;
begin
  if assigned(PyFloat_AsDouble) and
     TPyObject.IsInitialized(obj) then
    Result := PyFloat_AsDouble(obj.PyObject)
   else
    Result := -1;
end;


end.
