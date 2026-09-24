unit uP4P.PySentinel;

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
  /// Helper class for all PySentinel_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/sentinel.html#sentinel-objects">See the article about Sentinel objects.</see></para>
  /// <para><see href="https://docs.python.org/3.15/builtins/functions.html#sentinel">See the article about Python sentinels.</see></para>
  /// <para>Added in version 3.15.</para>
  /// </remarks>
  TPySentinel = class
    public
      /// <summary>
      /// <para>Return true if o is a sentinel object or a subtype. The sentinel
      /// type does not currently allow subclasses, so this check is exact.
      /// Future Python versions may choose to allow subtyping.
      /// This function always succeeds.</para>
      /// </summary>
      class function Check(const o: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if o is a sentinel object, but not a subtype.
      /// The sentinel type does not currently allow subclasses. Future Python
      /// versions may choose to allow subtyping.
      /// This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const o: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new sentinel object with __name__ set to name_ and
      /// __module__ set to module_name.</para>
      /// <para>name must not be empty.</para>
      /// <para>If module_name is empty, __module__ is set to None.</para>
      /// <para>If repr is empty, repr() returns __name__.</para>
      /// <para>Return nil with an exception set on failure.</para>
      /// <para>For pickling to work, module_name must be the name of an
      /// importable module, and the sentinel must be accessible from that
      /// module under a path matching name. Pickle treats name as a global
      /// variable name in module_name (see object.__reduce__()).</para>
      /// </summary>
      class function New(const name_, module_name, repr: string): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPySentinel.Check(const o: IPyObject): boolean;
begin
  // Subclasses are not allowed.
  Result := CheckExact(o);
end;

class function TPySentinel.CheckExact(const o: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(o) and
            o.IsType(PySentinel_Type);
end;

class function TPySentinel.New(const name_, module_name, repr: string): IPyObject;
var
  TempName, TempModuleName, TempRepr : AnsiString;
  TempNamePtr, TempModuleNamePtr, TempReprPtr : PAnsiChar;
begin
  Result := nil;
  if not(assigned(PySentinel_New)) or (length(name_) = 0) then exit;

  TempName    := StringToPyUTF8(name_);
  TempNamePtr := PAnsiChar(TempName);

  if (length(module_name) > 0) then
    begin
      TempModuleName    := StringToPyUTF8(module_name);
      TempModuleNamePtr := PAnsiChar(TempModuleName);
    end
   else
    TempModuleNamePtr := nil;

  if (length(repr) > 0) then
    begin
      TempRepr    := StringToPyUTF8(repr);
      TempReprPtr := PAnsiChar(TempRepr);
    end
   else
    TempReprPtr := nil;

  Result := TPyObject.Wrap(PySentinel_New(TempNamePtr, TempModuleNamePtr, TempReprPtr));
end;

end.
