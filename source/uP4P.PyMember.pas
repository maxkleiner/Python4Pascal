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
  TPyMember = class
    public
      class function GetOne(const obj_addr: string; const m: PyMemberDef): IPyObject;
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
