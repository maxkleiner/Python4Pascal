unit uP4P.PyGenericAlias;

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
  uP4P.LibFunctions, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// <para>GenericAlias objects are generally created by subscripting a
  /// class.</para>
  /// <para>They are most often used with container classes, such as list or
  /// dict.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/library/stdtypes.html#generic-alias-type">See the article about Generic Alias Type.</see></para>
  /// </remarks>
  TPyGenericAlias = class
    public
      /// <summary>
      /// <para>Create a GenericAlias object. Equivalent to calling the Python
      /// class types.GenericAlias. The origin and args arguments set the
      /// GenericAlias's __origin__ and __args__ attributes respectively.
      /// origin should be a PyTypeObject*, and args can be a PyTupleObject* or
      /// any PyObject*. If args passed is not a tuple, a 1-tuple is
      /// automatically constructed and __args__ is set to (args,).
      /// Minimal checking is done for the arguments, so the function will
      /// succeed even if origin is not a type. The GenericAlias's
      /// __parameters__ attribute is constructed lazily from __args__.</para>
      /// </summary>
      class function New(const origin, args: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return True if the aPyObject's type is GenericAlias or a subtype
      /// of GenericAlias.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.Py;

class function TPyGenericAlias.New(const origin, args: IPyObject): IPyObject;
begin
  Result := TPy.GenericAlias(origin, args);
end;

class function TPyGenericAlias.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(Py_GenericAliasType);
end;

end.
