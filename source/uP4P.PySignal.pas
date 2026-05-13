unit uP4P.PySignal;

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
  TPySignal = class
    public
      class function SetWakeupFd(fd: integer): integer;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPySignal.SetWakeupFd(fd: integer): integer;
begin
  if assigned(PySignal_SetWakeupFd) then
    Result := PySignal_SetWakeupFd(fd)
   else
    Result := -1;
end;

end.
