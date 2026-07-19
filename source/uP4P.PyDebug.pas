unit uP4P.PyDebug;

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
  TPyDebug = class
    public
      class function GetEnv(const name_: string): string;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPyDebug.GetEnv(const name_: string): string;
var
  TempName : AnsiString;
begin
  if assigned(Py_GETENV) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := PyUTF8ToString(Py_GETENV(PAnsiChar(TempName)));
    end
   else
    Result := '';
end;

end.
