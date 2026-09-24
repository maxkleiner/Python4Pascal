unit uP4P.PyAnyDict;

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
  uP4P.Interfaces;

type
  /// <summary>
  /// Helper class to check Dict Objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/dict.html#frozen-dictionary-objects">See the article about Frozen dictionary objects.</see></para>
  /// </remarks>
  TPyAnyDict = class
    public
      /// <summary>
      /// <para>Return true if p is a dict object, a frozendict object, or
      /// an instance of a subtype of the dict or frozendict type.
      /// This function always succeeds.</para>
      /// </summary>
      class function Check(const p: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if p is a dict object or a frozendict object,
      /// but not an instance of a subtype of the dict or frozendict type.
      /// This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const p: IPyObject): boolean;
  end;

implementation

uses
  uP4P.PyDict, uP4P.PyFrozenDict;

{ TPyAnyDict }

class function TPyAnyDict.Check(const p: IPyObject): boolean;
begin
  Result := TPyDict.Check(p) or
            TPyFrozenDict.Check(p);
end;

class function TPyAnyDict.CheckExact(const p: IPyObject): boolean;
begin
  Result := TPyDict.CheckExact(p) or
            TPyFrozenDict.CheckExact(p);
end;

end.
