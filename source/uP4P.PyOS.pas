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
      class function FSPath(const path: IPyObject): IPyObject;
      class function InterruptOccurred: boolean;
      class function string_to_double(const str: string; const overflow_exception: IPyObject): double;
      class function double_to_string(val: double; format_code: TPyDoubleToStringFormatCode; flags: integer; out type_: integer): string;
      class function mystrnicmp(const str1, str2: PAnsiChar; size_: Py_ssize_t): integer; overload;
      class function mystrnicmp(const str1, str2: string; size_: Py_ssize_t): integer; overload;
      class function mystricmp(const str1, str2: PAnsiChar): integer; overload;
      class function mystricmp(const str1, str2: string): integer; overload;
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

class function TPyOS.FSPath(const path: IPyObject): IPyObject;
begin
  if assigned(PyOS_FSPath) and
     TPyObject.IsInitialized(path) then
    Result := TPyObject.Wrap(PyOS_FSPath(path.PyObject))
   else
    Result := nil;
end;

class function TPyOS.InterruptOccurred: boolean;
begin
  Result := assigned(PyOS_InterruptOccurred) and
            (PyOS_InterruptOccurred() <> 0);
end;

class function TPyOS.string_to_double(const str: string; const overflow_exception: IPyObject): double;
var
  TempStr : AnsiString;
  TempExc : PPyObject;
begin
  Result := -1;

  if (length(str) > 0) and assigned(PyOS_string_to_double) then
    begin
      TempStr := StringToPyUTF8(str);

      if TPyObject.IsInitialized(overflow_exception) then
        TempExc := overflow_exception.PyObject
       else
        TempExc := nil;

      Result := PyOS_string_to_double(PAnsiChar(TempStr), nil, TempExc);
    end;
end;

class function TPyOS.double_to_string(val: double; format_code: TPyDoubleToStringFormatCode; flags: integer; out type_: integer): string;
var
  TempFormat : AnsiChar;
begin
  Result := '';

  if assigned(PyOS_double_to_string) then
    begin
      case format_code of
        fc_lowercase_e : TempFormat := 'e';
        fc_E           : TempFormat := 'E';
        fc_lowercase_f : TempFormat := 'f';
        fc_F           : TempFormat := 'F';
        fc_lowercase_g : TempFormat := 'g';
        fc_G           : TempFormat := 'G';
        else             TempFormat := 'r'; // fc_r
      end;

      Result := PyUTF8ToString(PyOS_double_to_string(val, TempFormat, 0, flags, type_), True);
    end;
end;

class function TPyOS.mystrnicmp(const str1, str2: PAnsiChar; size_: Py_ssize_t): integer;
begin
  if assigned(PyOS_mystrnicmp) then
    Result := PyOS_mystrnicmp(str1, str2, size_)
   else
    Result := 0;
end;

class function TPyOS.mystrnicmp(const str1, str2: string; size_: Py_ssize_t): integer;
var
  TempStr1, TempStr2 : AnsiString;
begin
  TempStr1 := StringToPyUTF8(str1);
  TempStr2 := StringToPyUTF8(str2);
  Result   := mystrnicmp(PAnsiChar(TempStr1), PAnsiChar(TempStr2), size_);
end;

class function TPyOS.mystricmp(const str1, str2: PAnsiChar): integer;
begin
  if assigned(PyOS_mystricmp) then
    Result := PyOS_mystricmp(str1, str2)
   else
    Result := 0;
end;

class function TPyOS.mystricmp(const str1, str2: string): integer;
var
  TempStr1, TempStr2 : AnsiString;
begin
  TempStr1 := StringToPyUTF8(str1);
  TempStr2 := StringToPyUTF8(str2);
  Result   := mystricmp(PAnsiChar(TempStr1), PAnsiChar(TempStr2));
end;

end.
