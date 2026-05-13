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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  TPyNumber = class
    public
      class function Check(const o: IPyObject): boolean;
      class function Add(const o1, o2: IPyObject): IPyObject;
      class function Subtract(const o1, o2: IPyObject): IPyObject;
      class function Multiply(const o1, o2: IPyObject): IPyObject;
      class function MatrixMultiply(const o1, o2: IPyObject): IPyObject;
      class function FloorDivide(const o1, o2: IPyObject): IPyObject;
      class function TrueDivide(const o1, o2: IPyObject): IPyObject;
      class function Remainder(const o1, o2: IPyObject): IPyObject;
      class function Divmod(const o1, o2: IPyObject): IPyObject;
      class function Power(const o1, o2, o3: IPyObject): IPyObject;
      class function Negative(const o: IPyObject): IPyObject;
      class function Positive(const o: IPyObject): IPyObject;
      class function Absolute_(const o: IPyObject): IPyObject;
      class function Invert(const o: IPyObject): IPyObject;
      class function Lshift(const o1, o2: IPyObject): IPyObject;
      class function Rshift(const o1, o2: IPyObject): IPyObject;
      class function And_(const o1, o2: IPyObject): IPyObject;
      class function Xor_(const o1, o2: IPyObject): IPyObject;
      class function Or_(const o1, o2: IPyObject): IPyObject;
      class function Index(const o: IPyObject): IPyObject;
      class function AsSsize_t(const o, exc: IPyObject): Py_ssize_t;
      class function Long(const o: IPyObject): IPyObject;
      class function Float(const o: IPyObject): IPyObject;
      class function InPlaceAdd(const o1, o2: IPyObject): IPyObject;
      class function InPlaceSubtract(const o1, o2: IPyObject): IPyObject;
      class function InPlaceMultiply(const o1, o2: IPyObject): IPyObject;
      class function InPlaceMatrixMultiply(const o1, o2: IPyObject): IPyObject;
      class function InPlaceFloorDivide(const o1, o2: IPyObject): IPyObject;
      class function InPlaceTrueDivide(const o1, o2: IPyObject): IPyObject;
      class function InPlaceRemainder(const o1, o2: IPyObject): IPyObject;
      class function InPlacePower(const o1, o2, o3: IPyObject): IPyObject;
      class function InPlaceLshift(const o1, o2: IPyObject): IPyObject;
      class function InPlaceRshift(const o1, o2: IPyObject): IPyObject;
      class function InPlaceAnd(const o1, o2: IPyObject): IPyObject;
      class function InPlaceXor(const o1, o2: IPyObject): IPyObject;
      class function InPlaceOr(const o1, o2: IPyObject): IPyObject;
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
        Result := TPyObject.Wrap(PyNumber_Power(o1.PyObject, o2.PyObject, TPyNone.New.PyObject));
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
        Result := TPyObject.Wrap(PyNumber_InPlacePower(o1.PyObject, o2.PyObject, TPyNone.New.PyObject));
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
