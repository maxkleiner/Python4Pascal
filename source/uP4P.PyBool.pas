unit uP4P.PyBool;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyBool_* methods. Booleans in Python are implemented
  /// as a subclass of integers. There are only two booleans, Py_False and
  /// Py_True. As such, the normal creation and deletion functions don't apply
  /// to booleans.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/bool.html#boolean-objects">See the article about Boolean Objects.</see></para>
  /// </remarks>
  TPyBool = class
    public
      /// <summary>
      /// <para>Return Py_True or Py_False, depending on the truth value of aValue.</para>
      /// </summary>
      class function FromLong(aValue: C_Long): IPyObject;
      /// <summary>
      /// <para>Wrap a Variant with a Python boolean type.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant): IPyObject; overload;
      /// <summary>
      /// <para>Wrap a Variant with a Python boolean type.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject; overload;
      /// <summary>
      /// <para>Return a IPyObject instance wrapping a False boolean.</para>
      /// </summary>
      class function NewFalse: IPyObject;
      /// <summary>
      /// <para>Return a IPyObject instance wrapping a True boolean.</para>
      /// </summary>
      class function NewTrue: IPyObject;
      /// <summary>
      /// <para>Return a valid Py_False pointer.</para>
      /// </summary>
      class function ReturnFalse: PPyObject;
      /// <summary>
      /// <para>Return a valid Py_True pointer.</para>
      /// </summary>
      class function ReturnTrue: PPyObject;
      /// <summary>
      /// <para>Return true if aPyObject is of type PyBool_Type. This function
      /// always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.Engine, uP4P.Py;

class function TPyBool.FromLong(aValue: C_Long): IPyObject;
begin
  if assigned(PyBool_FromLong) then
    Result := TPyObject.Wrap(PyBool_FromLong(aValue))
   else
    Result := nil;
end;

class function TPyBool.FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject;
begin
  if (aVarType = varBoolean) then
    Result := TPyBool.FromLong(ord(boolean(aVariant)))
   else
    Result := nil;
end;

class function TPyBool.FromVariant(const aVariant: Variant): IPyObject;
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

class function TPyBool.NewFalse: IPyObject;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    Result := TPyObject.Wrap(Py_False, False)
   else
    Result := TPyObject.Wrap(Py_False, True, True);
end;

class function TPyBool.NewTrue: IPyObject;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    Result := TPyObject.Wrap(Py_True, False)
   else
    Result := TPyObject.Wrap(Py_True, True, True);
end;

class function TPyBool.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and aPyObject.IsType(PyBool_Type);
end;

class function TPyBool.ReturnFalse: PPyObject;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    Result := PPyObject(Py_False)
   else
    Result := TPy.NewRef(Py_False);
end;

class function TPyBool.ReturnTrue: PPyObject;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    Result := PPyObject(Py_True)
   else
    Result := TPy.NewRef(Py_True);
end;

end.
