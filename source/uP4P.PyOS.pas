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


end.
