unit uP4P.PyMember;

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
  /// Helper class for all PyMember_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#accessing-attributes-of-extension-types">See the article about Accessing attributes of extension types.</see></para>
  /// </remarks>
  TPyMember = class
    public
      /// <summary>
      /// <para>Get an attribute belonging to the object at address obj_addr.
      /// The attribute is described by PyMemberDef m. Returns nil on
      /// error.</para>
      /// </summary>
      class function GetOne(const obj_addr: string; const m: PyMemberDef): IPyObject;
      /// <summary>
      /// <para>Set an attribute belonging to the object at address obj_addr to
      /// object o. The attribute to set is described by PyMemberDef m.
      /// Returns True if successful and False on failure.</para>
      /// </summary>
      class function SetOne(const obj_addr: string; const m: PyMemberDef; const o: IPyObject): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyMember.GetOne(const obj_addr: string; const m: PyMemberDef): IPyObject;
var
  TempObjAddr : AnsiString;
begin
  if assigned(PyMember_GetOne) then
    begin
      TempObjAddr := StringToPyUTF8(obj_addr);
      Result      := TPyObject.Wrap(PyMember_GetOne(PAnsiChar(TempObjAddr), @m))
    end
   else
    Result := nil;
end;

class function TPyMember.SetOne(const obj_addr: string; const m: PyMemberDef; const o: IPyObject): boolean;
var
  TempObjAddr : AnsiString;
begin
  Result := False;

  if assigned(PyMember_SetOne) and
     TPyObject.IsInitialized(o) then
    begin
      TempObjAddr := StringToPyUTF8(obj_addr);
      Result      := (PyMember_SetOne(PAnsiChar(TempObjAddr), @m, o.PyObject) = 0)
    end;
end;

end.
