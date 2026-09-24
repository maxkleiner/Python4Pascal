unit uP4P.PyNumber;

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
  /// Helper class for all PyNumber_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/number.html#number-protocol">See the article about the Number Protocol.</see></para>
  /// </remarks>
  TPyNumber = class
    public
      /// <summary>
      /// <para>Returns True if the object o provides numeric protocols, and
      /// false otherwise. This function always succeeds.</para>
      /// </summary>
      class function Check(const o: IPyObject): boolean;
      /// <summary>
      /// <para>Returns the result of adding o1 and o2, or nil on failure.
      /// This is the equivalent of the Python expression o1 + o2.</para>
      /// </summary>
      class function Add(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the result of subtracting o2 from o1, or nil on failure.
      /// This is the equivalent of the Python expression o1 - o2.</para>
      /// </summary>
      class function Subtract(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the result of multiplying o1 and o2, or nil on failure.
      /// This is the equivalent of the Python expression o1 * o2.</para>
      /// </summary>
      class function Multiply(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the result of matrix multiplication on o1 and o2, or nil
      /// on failure. This is the equivalent of the Python expression
      /// o1 @ o2.</para>
      /// </summary>
      class function MatrixMultiply(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the floor of o1 divided by o2, or nil on failure.
      /// This is the equivalent of the Python expression o1 // o2.</para>
      /// </summary>
      class function FloorDivide(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return a reasonable approximation for the mathematical value of
      /// o1 divided by o2, or nil on failure. The return value is "approximate"
      /// because binary floating-point numbers are approximate; it is not
      /// possible to represent all real numbers in base two. This function can
      /// return a floating-point value when passed two integers. This is the
      /// equivalent of the Python expression o1 / o2.</para>
      /// </summary>
      class function TrueDivide(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the remainder of dividing o1 by o2, or nil on failure.
      /// This is the equivalent of the Python expression o1 % o2.</para>
      /// </summary>
      class function Remainder(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>See the built-in function divmod(). Returns nil on failure.
      /// This is the equivalent of the Python expression divmod(o1, o2).</para>
      /// </summary>
      class function Divmod(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>See the built-in function pow(). Returns nil on failure.
      /// This is the equivalent of the Python expression pow(o1, o2, o3),
      /// where o3 is optional. If o3 is to be ignored, pass Py_None in its
      /// place (passing nil for o3 would cause an illegal memory
      /// access).</para>
      /// </summary>
      class function Power(const o1, o2, o3: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the negation of o on success, or nil on failure.
      /// This is the equivalent of the Python expression -o.</para>
      /// </summary>
      class function Negative(const o: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns o on success, or nil on failure. This is the equivalent
      /// of the Python expression +o.</para>
      /// </summary>
      class function Positive(const o: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the absolute value of o, or nil on failure. This is the
      /// equivalent of the Python expression abs(o).</para>
      /// </summary>
      class function Absolute_(const o: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the bitwise negation of o on success, or nil on failure.
      /// This is the equivalent of the Python expression ~o.</para>
      /// </summary>
      class function Invert(const o: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the result of left shifting o1 by o2 on success, or nil
      /// on failure. This is the equivalent of the Python expression
      /// o1 << o2.</para>
      /// </summary>
      class function Lshift(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the result of right shifting o1 by o2 on success, or nil
      /// on failure. This is the equivalent of the Python expression
      /// o1 >> o2.</para>
      /// </summary>
      class function Rshift(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the "bitwise and" of o1 and o2 on success and nil on
      /// failure. This is the equivalent of the Python expression
      /// o1 & o2.</para>
      /// </summary>
      class function And_(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the "bitwise exclusive or" of o1 by o2 on success, or
      /// nil on failure. This is the equivalent of the Python expression
      /// o1 ^ o2.</para>
      /// </summary>
      class function Xor_(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the "bitwise or" of o1 and o2 on success, or nil on
      /// failure. This is the equivalent of the Python expression
      /// o1 | o2.</para>
      /// </summary>
      class function Or_(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the o converted to a Python int on success or nil with a
      /// TypeError exception raised on failure.</para>
      /// </summary>
      class function Index(const o: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns o converted to a Py_ssize_t value if o can be
      /// interpreted as an integer. If the call fails, an exception is raised
      /// and -1 is returned.</para>
      /// <para>If o can be converted to a Python int but the attempt to convert
      /// to a Py_ssize_t value would raise an OverflowError, then the exc
      /// argument is the type of exception that will be raised (usually
      /// IndexError or OverflowError). If exc is nil, then the exception is
      /// cleared and the value is clipped to PY_SSIZE_T_MIN for a negative
      /// integer or PY_SSIZE_T_MAX for a positive integer.</para>
      /// </summary>
      class function AsSsize_t(const o, exc: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Returns the o converted to an integer object on success, or nil
      /// on failure. This is the equivalent of the Python expression
      /// int(o).</para>
      /// </summary>
      class function Long(const o: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the o converted to a float object on success, or nil on
      /// failure. This is the equivalent of the Python expression
      /// float(o).</para>
      /// </summary>
      class function Float(const o: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the result of adding o1 and o2, or nil on failure.
      /// The operation is done in-place when o1 supports it. This is the
      /// equivalent of the Python statement o1 += o2.</para>
      /// </summary>
      class function InPlaceAdd(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the result of subtracting o2 from o1, or nil on failure.
      /// The operation is done in-place when o1 supports it. This is the
      /// equivalent of the Python statement o1 -= o2.</para>
      /// </summary>
      class function InPlaceSubtract(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the result of multiplying o1 and o2, or nil on failure.
      /// The operation is done in-place when o1 supports it. This is the
      /// equivalent of the Python statement o1 *= o2.</para>
      /// </summary>
      class function InPlaceMultiply(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the result of matrix multiplication on o1 and o2, or nil
      /// on failure. The operation is done in-place when o1 supports it.
      /// This is the equivalent of the Python statement o1 @= o2.</para>
      /// </summary>
      class function InPlaceMatrixMultiply(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the mathematical floor of dividing o1 by o2, or nil on
      /// failure. The operation is done in-place when o1 supports it.
      /// This is the equivalent of the Python statement o1 //= o2.</para>
      /// </summary>
      class function InPlaceFloorDivide(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return a reasonable approximation for the mathematical value of
      ///  o1 divided by o2, or nil on failure. The return value is
      /// "approximate" because binary floating-point numbers are approximate;
      /// it is not possible to represent all real numbers in base two. This
      /// function can return a floating-point value when passed two integers.
      /// The operation is done in-place when o1 supports it. This is the
      /// equivalent of the Python statement o1 /= o2.</para>
      /// </summary>
      class function InPlaceTrueDivide(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the remainder of dividing o1 by o2, or nil on failure.
      /// The operation is done in-place when o1 supports it. This is the
      /// equivalent of the Python statement o1 %= o2.</para>
      /// </summary>
      class function InPlaceRemainder(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>See the built-in function pow(). Returns nil on failure.
      /// The operation is done in-place when o1 supports it. This is the
      /// equivalent of the Python statement o1 **= o2 when o3 is Py_None, or
      /// an in-place variant of pow(o1, o2, o3) otherwise. If o3 is to be
      /// ignored, pass Py_None in its place (passing nil for o3 would cause
      /// an illegal memory access).</para>
      /// </summary>
      class function InPlacePower(const o1, o2, o3: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the result of left shifting o1 by o2 on success, or nil
      /// on failure. The operation is done in-place when o1 supports it. This
      /// is the equivalent of the Python statement o1 <<= o2.</para>
      /// </summary>
      class function InPlaceLshift(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the result of right shifting o1 by o2 on success, or
      /// nil on failure. The operation is done in-place when o1 supports it.
      /// This is the equivalent of the Python statement o1 >>= o2.</para>
      /// </summary>
      class function InPlaceRshift(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the "bitwise and" of o1 and o2 on success and nil on
      /// failure. The operation is done in-place when o1 supports it. This is
      /// the equivalent of the Python statement o1 &= o2.</para>
      /// </summary>
      class function InPlaceAnd(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the "bitwise exclusive or" of o1 by o2 on success,
      /// or nil on failure. The operation is done in-place when o1 supports it.
      /// This is the equivalent of the Python statement o1 ^= o2.</para>
      /// </summary>
      class function InPlaceXor(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the "bitwise or" of o1 and o2 on success, or nil on
      /// failure. The operation is done in-place when o1 supports it. This is
      /// the equivalent of the Python statement o1 |= o2.</para>
      /// </summary>
      class function InPlaceOr(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Returns the integer n converted to base base as a string. The
      /// base argument must be one of 2, 8, 10, or 16. For base 2, 8, or 16,
      /// the returned string is prefixed with a base marker of '0b', '0o', or
      /// '0x', respectively. If n is not a Python int, it is converted with
      /// TPyNumber.Index() first.</para>
      /// </summary>
      class function ToBase(const n: IPyObject; base: integer): IPyObject;
  end;

implementation

uses
  uP4P.PyNone;

class function TPyNumber.Check(const o: IPyObject): boolean;
begin
  Result := assigned(PyNumber_Check) and
            assigned(o) and
            o.Initialized and
            (PyNumber_Check(o.PyObject) <> 0);
end;

class function TPyNumber.Add(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_Add) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_Add(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Subtract(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_Subtract) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_Subtract(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Multiply(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_Multiply) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_Multiply(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.MatrixMultiply(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_MatrixMultiply) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_MatrixMultiply(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.FloorDivide(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_FloorDivide) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_FloorDivide(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.TrueDivide(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_TrueDivide) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_TrueDivide(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Remainder(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_Remainder) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_Remainder(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Divmod(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_Divmod) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_Divmod(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Power(const o1, o2, o3: IPyObject): IPyObject;
begin
  Result := nil;

  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_Power) and
     o1.Initialized and
     o2.Initialized then
    begin
      if assigned(o3) and o3.Initialized then
        Result := TPyObject.Wrap(PyNumber_Power(o1.PyObject, o2.PyObject, o3.PyObject))
       else
        Result := TPyObject.Wrap(PyNumber_Power(o1.PyObject, o2.PyObject, TPyNone.ReturnNone));
    end;
end;

class function TPyNumber.Negative(const o: IPyObject): IPyObject;
begin
  if assigned(o) and
     assigned(PyNumber_Negative) and
     o.Initialized then
    Result := TPyObject.Wrap(PyNumber_Negative(o.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Positive(const o: IPyObject): IPyObject;
begin
  if assigned(o) and
     assigned(PyNumber_Positive) and
     o.Initialized then
    Result := TPyObject.Wrap(PyNumber_Positive(o.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Absolute_(const o: IPyObject): IPyObject;
begin
  if assigned(o) and
     assigned(PyNumber_Absolute) and
     o.Initialized then
    Result := TPyObject.Wrap(PyNumber_Absolute(o.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Invert(const o: IPyObject): IPyObject;
begin
  if assigned(o) and
     assigned(PyNumber_Invert) and
     o.Initialized then
    Result := TPyObject.Wrap(PyNumber_Invert(o.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Lshift(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_Lshift) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_Lshift(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Rshift(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_Rshift) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_Rshift(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.And_(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_And) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_And(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Xor_(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_Xor) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_Xor(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Or_(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_Or) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_Or(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Index(const o: IPyObject): IPyObject;
begin
  if assigned(PyNumber_Index) and
     assigned(o) and
     o.Initialized then
    Result := TPyObject.Wrap(PyNumber_Index(o.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.AsSsize_t(const o, exc: IPyObject): Py_ssize_t;
begin
  if assigned(PyNumber_AsSsize_t) and
     assigned(o) and
     assigned(exc) and
     o.Initialized and
     exc.Initialized then
    Result := PyNumber_AsSsize_t(o.PyObject, exc.PyObject)
   else
    Result := -1;
end;

class function TPyNumber.Long(const o: IPyObject): IPyObject;
begin
  if assigned(PyNumber_Long) and
     assigned(o) and
     o.Initialized then
    Result := TPyObject.Wrap(PyNumber_Long(o.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.Float(const o: IPyObject): IPyObject;
begin
  if assigned(PyNumber_Float) and
     assigned(o) and
     o.Initialized then
    Result := TPyObject.Wrap(PyNumber_Float(o.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.InPlaceAdd(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_InPlaceAdd) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_InPlaceAdd(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.InPlaceSubtract(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_InPlaceSubtract) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_InPlaceSubtract(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.InPlaceMultiply(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_InPlaceMultiply) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_InPlaceMultiply(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.InPlaceMatrixMultiply(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_InPlaceMatrixMultiply) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_InPlaceMatrixMultiply(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.InPlaceFloorDivide(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_InPlaceFloorDivide) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_InPlaceFloorDivide(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.InPlaceTrueDivide(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_InPlaceTrueDivide) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_InPlaceTrueDivide(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.InPlaceRemainder(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_InPlaceRemainder) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_InPlaceRemainder(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.InPlacePower(const o1, o2, o3: IPyObject): IPyObject;
begin
  Result := nil;

  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_InPlacePower) and
     o1.Initialized and
     o2.Initialized then
    begin
      if assigned(o3) and o3.Initialized then
        Result := TPyObject.Wrap(PyNumber_InPlacePower(o1.PyObject, o2.PyObject, o3.PyObject))
       else
        Result := TPyObject.Wrap(PyNumber_InPlacePower(o1.PyObject, o2.PyObject, TPyNone.ReturnNone));
    end;
end;

class function TPyNumber.InPlaceLshift(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_InPlaceLshift) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_InPlaceLshift(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.InPlaceRshift(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_InPlaceRshift) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_InPlaceRshift(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.InPlaceAnd(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_InPlaceAnd) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_InPlaceAnd(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.InPlaceXor(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_InPlaceXor) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_InPlaceXor(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.InPlaceOr(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(o1) and
     assigned(o2) and
     assigned(PyNumber_InPlaceOr) and
     o1.Initialized and
     o2.Initialized then
    Result := TPyObject.Wrap(PyNumber_InPlaceOr(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPyNumber.ToBase(const n: IPyObject; base: integer): IPyObject;
begin
  if assigned(n) and
     assigned(PyNumber_ToBase) and
     n.Initialized then
    Result := TPyObject.Wrap(PyNumber_ToBase(n.PyObject, base))
   else
    Result := nil;
end;

end.
