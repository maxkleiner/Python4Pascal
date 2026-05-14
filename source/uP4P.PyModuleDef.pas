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
      class function Init(def: PPyModuleDef): IPyObject;
  end;

implementation

class function TPyModuleDef.Init(def: PPyModuleDef): IPyObject;
begin
  if assigned(PyModuleDef_Init) then
    Result := TPyObject.Wrap(PyModuleDef_Init(def), False, False)
   else
    Result := nil;
end;

end.
