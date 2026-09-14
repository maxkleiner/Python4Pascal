unit uP4P.PyFrozenSet;

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
  /// <summary>
  /// Helper class for all PyFrozenSet_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/set.html#set-objects">See the article about Set Objects.</see></para>
  /// </remarks>
  TPyFrozenSet = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is a frozenset object or an instance
      /// of a subtype. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject is a frozenset object but not an
      /// instance of a subtype. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new frozenset containing objects returned by the
      /// iterable. The iterable may be nil to create a new empty frozenset.
      /// Return the new set on success or nil on failure. Raise TypeError if
      /// iterable is not actually iterable.</para>
      /// <para>Note: The operation is atomic on free threading when iterable is
      /// a set, frozenset or dict.</para>
      /// </summary>
      class function New(const iterable: IPyObject): IPyObject;
  end;

implementation

class function TPyFrozenSet.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyFrozenSet_Type);
end;

class function TPyFrozenSet.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyFrozenSet_Type);
end;

class function TPyFrozenSet.New(const iterable: IPyObject): IPyObject;
begin
  if assigned(PyFrozenSet_New) then
    begin
      if TPyObject.IsInitialized(iterable) then
        Result := TPyObject.Wrap(PyFrozenSet_New(iterable.PyObject))
       else
        Result := TPyObject.Wrap(PyFrozenSet_New(nil));
    end
   else
    Result := nil;
end;

end.
