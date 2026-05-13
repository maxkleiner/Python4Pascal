unit uP4P.PyComplex;

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
  TPyComplex = class
    public
      class function RealAsDouble(const ob: IPyObject): double;
      class function ImagAsDouble(const ob: IPyObject): double;
      class function AsCComplex(const ob: IPyObject): Py_complex;
      class function FromDoubles(const real, imag: double): IPyObject;
      class function FromCComplex(const v: Py_complex): IPyObject;
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyComplex.FromDoubles(const real, imag: double): IPyObject;
begin
  if assigned(PyComplex_FromDoubles) then
    Result := TPyObject.Wrap(PyComplex_FromDoubles(real, imag))
   else
    Result := nil;
end;

class function TPyComplex.FromCComplex(const v: Py_complex): IPyObject;
begin
  if assigned(PyComplex_FromCComplex) then
    Result := TPyObject.Wrap(PyComplex_FromCComplex(v))
   else
    Result := nil;
end;

class function TPyComplex.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyComplex_Type);
end;

class function TPyComplex.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyComplex_Type);
end;

class function TPyComplex.RealAsDouble(const ob: IPyObject): double;
begin
  if assigned(PyComplex_RealAsDouble) and TPyObject.IsInitialized(ob) then
    Result := PyComplex_RealAsDouble(ob.PyObject)
   else
    Result := -1;
end;

class function TPyComplex.ImagAsDouble(const ob: IPyObject): double;
begin
  if assigned(PyComplex_ImagAsDouble) and TPyObject.IsInitialized(ob) then
    Result := PyComplex_ImagAsDouble(ob.PyObject)
   else
    Result := -1;
end;

class function TPyComplex.AsCComplex(const ob: IPyObject): Py_complex;
begin
  if assigned(PyComplex_AsCComplex) and TPyObject.IsInitialized(ob) then
    Result := PyComplex_AsCComplex(ob.PyObject)
   else
    Result.real := -1;
end;

end.
