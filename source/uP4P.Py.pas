unit uP4P.Py;

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
  TPy = class
    public
      class procedure FatalError(const message_: string);
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class procedure TPy.FatalError(const message_: string);
var
  TempMessage : AnsiString;
begin
  if assigned(Py_FatalError) then
    begin
      TempMessage := StringToPyUTF8(message_);
      Py_FatalError(PAnsiChar(TempMessage));
    end;
end;

end.
