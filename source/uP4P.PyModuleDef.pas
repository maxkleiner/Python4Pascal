unit uP4P.PyModuleDef;

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
  TPyModuleDef = class
    public
      class function Init(const def: PyModuleDef): PPyObject;
  end;

implementation

class function TPyModuleDef.Init(const def: PyModuleDef): PPyObject;
begin
  if assigned(PyModuleDef_Init) then
    Result := PyModuleDef_Init(@def)
   else
    Result := nil;
end;

end.
