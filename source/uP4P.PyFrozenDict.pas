unit uP4P.PyFrozenDict;

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
  /// Helper class for all PyFrozenDict_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/dict.html#frozen-dictionary-objects">See the article about Frozen dictionary objects.</see></para>
  /// </remarks>
  TPyFrozenDict = class
    public
      /// <summary>
      /// <para>Return true if p is a dict object, a frozendict object, or an
      /// instance of a subtype of the dict or frozendict type.
      /// This function always succeeds.</para>
      /// </summary>
      class function Check(const p: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if p is a dict object or a frozendict object,
      /// but not an instance of a subtype of the dict or frozendict type.
      /// This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const p: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new frozendict from an iterable, or nil on failure
      /// with an exception set. Create an empty dictionary if iterable is
      /// nil.</para>
      /// </summary>
      class function New(const iterable: IPyObject): IPyObject;
  end;

implementation

class function TPyFrozenDict.Check(const p: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(p) and
            p.TypeCheck(PyFrozenDict_Type);
end;

class function TPyFrozenDict.CheckExact(const p: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(p) and
            p.IsType(PyFrozenDict_Type);
end;

class function TPyFrozenDict.New(const iterable: IPyObject): IPyObject;
begin
  if assigned(PyFrozenDict_New) then
    begin
      if TPyObject.IsInitialized(iterable) then
        Result := TPyObject.Wrap(PyFrozenDict_New(iterable.PyObject))
       else
        Result := TPyObject.Wrap(PyFrozenDict_New(nil));
    end
   else
    Result := nil;
end;

end.
