unit uP4P.PyState;

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
  TPyState = class
    public
      class function AddModule(const module: IPyObject; def: PPyModuleDef): boolean;
      class function RemoveModule(def: PPyModuleDef): boolean;
      class function FindModule(def: PPyModuleDef): IPyObject;
  end;

implementation

class function TPyState.AddModule(const module: IPyObject; def: PPyModuleDef): boolean;
begin
  Result := assigned(PyState_AddModule) and
            TPyObject.IsInitialized(module) and
            assigned(def) and
            (PyState_AddModule(module.PyObject, def) = 0);
end;

class function TPyState.RemoveModule(def: PPyModuleDef): boolean;
begin
  Result := assigned(PyState_RemoveModule) and
            assigned(def) and
            (PyState_RemoveModule(def) = 0);
end;

class function TPyState.FindModule(def: PPyModuleDef): IPyObject;
begin
  if assigned(PyState_FindModule) and assigned(def) then
    Result := TPyObject.Wrap(PyState_FindModule(def))
   else
    Result := nil;
end;

end.
