unit uP4P.PyOS;

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
  TPyOS = class
    public
      class function strtoul(const str: string; base: integer): C_ULong;
      class function strtol(const str: string; base: integer): C_Long;
      class function CheckStack: boolean;
      class function Readline(sys_stdin, sys_stdout: PFILE; const prompt: string): string;
      class function getsig(i: integer): PyOS_sighandler_t;
      class function setsig(i: integer; s: PyOS_sighandler_t): PyOS_sighandler_t;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyOS.strtoul(const str: string; base: integer): C_ULong;
var
  TempStr: AnsiString;
begin
  if assigned(PyOS_strtoul) and (base in [0, 2..36]) then
    begin
      TempStr := StringToPyUTF8(str);
      Result  := PyOS_strtoul(PAnsiChar(TempStr), nil, base);
    end
   else
    Result := 0;
end;

class function TPyOS.strtol(const str: string; base: integer): C_Long;
var
  TempStr: AnsiString;
begin
  if assigned(PyOS_strtol) and (base in [0, 2..36]) then
    begin
      TempStr := StringToPyUTF8(str);
      Result  := PyOS_strtol(PAnsiChar(TempStr), nil, base);
    end
   else
    Result := 0;
end;

class function TPyOS.CheckStack: boolean;
begin
  Result := assigned(PyOS_CheckStack) and
            (PyOS_CheckStack() <> 0);
end;

class function TPyOS.Readline(sys_stdin, sys_stdout: PFILE; const prompt: string): string;
var
  TempPrompt : AnsiString;
begin
  Result := '';

  if assigned(PyOS_Readline) then
    begin
      TempPrompt := StringToPyUTF8(prompt);
      Result     := PyUTF8ToString(PyOS_Readline(sys_stdin, sys_stdout, PAnsiChar(TempPrompt)));
    end;
end;

class function TPyOS.getsig(i: integer): PyOS_sighandler_t;
begin
  if assigned(PyOS_getsig) then
    Result := PyOS_getsig(i)
   else
    Result := nil;
end;

class function TPyOS.setsig(i: integer; s: PyOS_sighandler_t): PyOS_sighandler_t;
begin
  if assigned(PyOS_setsig) then
    Result := PyOS_setsig(i, s)
   else
    Result := nil;
end;

end.
