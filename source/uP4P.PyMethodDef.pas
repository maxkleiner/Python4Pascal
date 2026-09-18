unit uP4P.PyMethodDef;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// <para>TPyMethodDef is used to store the information about module
  /// methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyMethodDef">See the article about PyMethodDef.</see></para>
  /// </remarks>
  TPyMethodDef = class
    protected
      FMethod      : PyMethodDef;
      FName        : AnsiString;
      FDocStrings  : AnsiString;

      function  GetIsSentinel: boolean;

    public
      constructor Create(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer);
      /// <summary>
      /// Record used to describe a method of an extension type.
      /// </summary>
      property Method      : PyMethodDef       read FMethod;
      /// <summary>
      /// Return True if this is the last method definition in the slot list.
      /// The sentinel method definition has a 0 as ml_flags and a nil value in
      /// ml_meth and ml_doc.
      /// </summary>
      property IsSentinel  : boolean           read GetIsSentinel;
  end;

implementation

uses
  uP4P.MiscFunctions;

constructor TPyMethodDef.Create(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer);
begin
  inherited Create;

  FName       := StringToPyUTF8(aName);
  FDocStrings := StringToPyUTF8(aDocStrings);

  if (length(aName) > 0) then
    FMethod.ml_name := PAnsiChar(FName)
   else
    FMethod.ml_name := nil;

  FMethod.ml_meth  := aMethod;
  FMethod.ml_flags := aFlags;

  if (length(aDocStrings) > 0) then
    FMethod.ml_doc := PAnsiChar(FDocStrings)
   else
    FMethod.ml_doc := nil;
end;

function TPyMethodDef.GetIsSentinel: boolean;
begin
  Result := (FMethod.ml_name = nil) and not(assigned(FMethod.ml_meth)) and (FMethod.ml_flags = 0) and (FMethod.ml_doc = nil);
end;

end.
