unit uP4P.PySys;

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
  TPySys = class
    public
      class function GetObject(const name_: string): IPyObject;
      class function SetObject(const name_: string; const v: IPyObject): boolean;
      class function GetXOptions: IPyObject;
      class function AuditTuple(const event: string; const args: IPyObject): boolean;
      class function AddAuditHook(hook: Py_AuditHookFunction; userData: Pointer): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPySys.GetObject(const name_: string): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PySys_GetObject) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PySys_GetObject(PAnsiChar(TempName)));
    end
   else
    Result := nil;
end;

class function TPySys.SetObject(const name_: string; const v: IPyObject): boolean;
var
  TempName : AnsiString;
begin
  if assigned(PySys_SetObject) and
     TPyObject.IsInitialized(v) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PySys_SetObject(PAnsiChar(TempName), v.PyObject) = 0);
    end
   else
    Result := False;
end;

class function TPySys.GetXOptions: IPyObject;
begin
  if assigned(PySys_GetXOptions) then
    Result := TPyObject.Wrap(PySys_GetXOptions())
   else
    Result := nil;
end;

class function TPySys.AuditTuple(const event: string; const args: IPyObject): boolean;
var
  TempEvent : AnsiString;
begin
  if assigned(PySys_AuditTuple) then
    begin
      TempEvent := StringToPyUTF8(event);

      if TPyObject.IsInitialized(args) then
        Result := (PySys_AuditTuple(PAnsiChar(TempEvent), args.PyObject) = 0)
       else
        Result := (PySys_AuditTuple(PAnsiChar(TempEvent), nil) = 0);
    end
   else
    Result := False;
end;

class function TPySys.AddAuditHook(hook: Py_AuditHookFunction; userData: Pointer): boolean;
begin
  Result := assigned(PySys_AddAuditHook) and
            (PySys_AddAuditHook(hook, userData) = 0);
end;

end.
