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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  TPyFloat = class
    public
      class function AsDouble(const obj: IPyObject): double;
      class function FromDouble(v: double): IPyObject;
      class function FromString(const str: IPyObject): IPyObject;
      class function FromVariant(const aVariant: Variant): IPyObject; overload;
      class function FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject; overload;
      class function ReturnNAN: IPyObject;
      class function ReturnINF(sign: boolean): IPyObject;
      class function GetMax: double;
      class function GetMin: double;
      class function GetInfo: IPyObject;
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function Pack2(const x: double; p: pbyte; le: boolean): boolean;
      class function Pack4(const x: double; p: pbyte; le: boolean): boolean;
      class function Pack8(const x: double; p: pbyte; le: boolean): boolean;
      class function UnPack2(p: pbyte; le: boolean): double;
      class function UnPack4(p: pbyte; le: boolean): double;
      class function UnPack8(p: pbyte; le: boolean): double;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

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
