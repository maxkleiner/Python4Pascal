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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyComplex_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/complex.html#complex-number-objects">See the article about the Complex Number Objects.</see></para>
  /// </remarks>
  TPyComplex = class
    public
      /// <summary>
      /// <para>Return the real part of op as a double.</para>
      /// <para>If op is not a Python complex number object but has a
      /// __complex__() method, this method will first be called to convert op
      /// to a Python complex number object. If __complex__() is not defined
      /// then it falls back to call TPyFloat.AsDouble() and returns its
      /// result.</para>
      /// <para>Upon failure, this method returns -1.0 with an exception set,
      /// so one should call TPyErr.Occurred() to check for errors.</para>
      /// <para>Changed in version 3.13: Use __complex__() if available.</para>
      /// </summary>
      class function RealAsDouble(const op: IPyObject): double;
      /// <summary>
      /// <para>Return the imaginary part of op as a C double.</para>
      /// <para>If op is not a Python complex number object but has a
      /// __complex__() method, this method will first be called to convert op
      /// to a Python complex number object. If __complex__() is not defined
      /// then it falls back to call TPyFloat.AsDouble() and returns 0.0 on
      /// success.</para>
      /// <para>Upon failure, this method returns -1.0 with an exception set,
      /// so one should call PyErr_Occurred() to check for errors.</para>
      /// <para>Changed in version 3.13: Use __complex__() if available.</para>
      /// </summary>
      class function ImagAsDouble(const op: IPyObject): double;
      /// <summary>
      /// <para>Return the Py_complex value of the complex number op.</para>
      /// <para>If op is not a Python complex number object but has a
      /// __complex__() method, this method will first be called to convert op
      /// to a Python complex number object. If __complex__() is not defined
      /// then it falls back to __float__(). If __float__() is not defined then
      /// it falls back to __index__().</para>
      /// <para>Upon failure, this method returns Py_complex with real set to
      /// -1.0 and with an exception set, so one should call TPyErr.Occurred()
      /// to check for errors.</para>
      /// </summary>
      class function AsCComplex(const op: IPyObject): Py_complex;
      /// <summary>
      /// <para>Return a new PyComplexObject object from real and imag.
      /// Return nil with an exception set on error.</para>
      /// </summary>
      class function FromDoubles(const real, imag: double): IPyObject;
      /// <summary>
      /// <para>Create a new Python complex number object from a Py_complex
      /// value. Return nil with an exception set on error.</para>
      /// </summary>
      class function FromCComplex(const v: Py_complex): IPyObject;
      /// <summary>
      /// <para>Return true if its argument is a PyComplexObject or a subtype
      /// of PyComplexObject. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if its argument is a PyComplexObject, but not a
      /// subtype of PyComplexObject. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
  end;

implementation

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

class function TPyComplex.RealAsDouble(const op: IPyObject): double;
begin
  if assigned(PyComplex_RealAsDouble) and TPyObject.IsInitialized(op) then
    Result := PyComplex_RealAsDouble(op.PyObject)
   else
    Result := -1;
end;

class function TPyComplex.ImagAsDouble(const op: IPyObject): double;
begin
  if assigned(PyComplex_ImagAsDouble) and TPyObject.IsInitialized(op) then
    Result := PyComplex_ImagAsDouble(op.PyObject)
   else
    Result := -1;
end;

class function TPyComplex.AsCComplex(const op: IPyObject): Py_complex;
begin
  if assigned(PyComplex_AsCComplex) and TPyObject.IsInitialized(op) then
    Result := PyComplex_AsCComplex(op.PyObject)
   else
    Result.real := -1;
end;

end.
