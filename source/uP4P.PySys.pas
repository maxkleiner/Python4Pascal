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
      class procedure WriteStdout(const format_: string; const args: array of const); overload;
      class procedure WriteStdout(const format_: string); overload;
      class procedure WriteStderr(const format_: string; const args: array of const); overload;
      class procedure WriteStderr(const format_: string); overload;
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
      Result   := TPyObject.Wrap(PySys_GetObject(PAnsiChar(TempName)), False);
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
    Result := TPyObject.Wrap(PySys_GetXOptions(), False)
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

class procedure TPySys.WriteStdout(const format_: string; const args: array of const);
var
  TempMsg : AnsiString;
begin
  if assigned(PySys_WriteStdout) then
    begin
      TempMsg := StringToPyUTF8(format_);
      //TODO: Find a better way to call PySys_WriteStdout with a variable number of arguments.
      case length(args) of
        05 : PySys_WriteStdout(PAnsiChar(TempMsg), args[0], args[1], args[2], args[3], args[4]);
        04 : PySys_WriteStdout(PAnsiChar(TempMsg), args[0], args[1], args[2], args[3]);
        03 : PySys_WriteStdout(PAnsiChar(TempMsg), args[0], args[1], args[2]);
        02 : PySys_WriteStdout(PAnsiChar(TempMsg), args[0], args[1]);
        01 : PySys_WriteStdout(PAnsiChar(TempMsg), args[0]);
        else PySys_WriteStdout(PAnsiChar(TempMsg));
      end;
    end;
end;

class procedure TPySys.WriteStdout(const format_: string);
var
  TempMsg : AnsiString;
begin
  if assigned(PySys_WriteStdout) then
    begin
      TempMsg := StringToPyUTF8(format_);
      PySys_WriteStdout(PAnsiChar(TempMsg));
    end;
end;

class procedure TPySys.WriteStderr(const format_: string; const args: array of const);
var
  TempMsg : AnsiString;
begin
  if assigned(PySys_WriteStderr) then
    begin
      TempMsg := StringToPyUTF8(format_);
      //TODO: Find a better way to call PySys_WriteStderr with a variable number of arguments.
      case length(args) of
        05 : PySys_WriteStderr(PAnsiChar(TempMsg), args[0], args[1], args[2], args[3], args[4]);
        04 : PySys_WriteStderr(PAnsiChar(TempMsg), args[0], args[1], args[2], args[3]);
        03 : PySys_WriteStderr(PAnsiChar(TempMsg), args[0], args[1], args[2]);
        02 : PySys_WriteStderr(PAnsiChar(TempMsg), args[0], args[1]);
        01 : PySys_WriteStderr(PAnsiChar(TempMsg), args[0]);
        else PySys_WriteStderr(PAnsiChar(TempMsg));
      end;
    end;
end;

class procedure TPySys.WriteStderr(const format_: string);
var
  TempMsg : AnsiString;
begin
  if assigned(PySys_WriteStderr) then
    begin
      TempMsg := StringToPyUTF8(format_);
      PySys_WriteStderr(PAnsiChar(TempMsg));
    end;
end;

end.
