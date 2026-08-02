unit uP4P.PyAnySet;

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
  /// Helper class to check Set Objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/set.html#set-objects">See the Set Objects article.</see></para>
  /// </remarks>
  TPyAnySet = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is a set object, a frozenset object,
      /// or an instance of a subtype. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject is a set object or a frozenset object
      /// but not an instance of a subtype. This function always
      /// succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.PySet, uP4P.PyFrozenSet;

class function TPyAnySet.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPySet.Check(aPyObject) or
            TPyFrozenSet.Check(aPyObject);
end;

class function TPyAnySet.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPySet.CheckExact(aPyObject) or
            TPyFrozenSet.CheckExact(aPyObject);
end;

end.
