unit umain;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,
  uP4P.Interfaces, uP4P.Types, uP4P.Constants, uP4P.PyObject, uP4P.Engine;

function PyInit_simplepythonextension: PPyObject; cdecl;
function PyModExport_simplepythonextension: PPySlot; cdecl;

implementation

uses
  uextensionmodule;

var
  GExtension : TExtensionModule = nil;

function PyInit_simplepythonextension: PPyObject; cdecl;
begin
  GlobalP4PEngine := TP4PEngine.Create;

  if GlobalP4PEngine.LoadInExtensionModule then
    begin
      GExtension := TExtensionModule.Create;
      Result     := PPyObject(GExtension.ModuleDef);
    end
   else
    Result := nil;
end;

function PyModExport_simplepythonextension: PPySlot; cdecl;
begin
  GlobalP4PEngine := TP4PEngine.Create;

  if GlobalP4PEngine.LoadInExtensionModule then
    begin
      GExtension := TExtensionModule.Create;
      Result     := GExtension.Slots;
    end
   else
    Result := nil;
end;

procedure DestroyExtension;
begin
  if assigned(GExtension) then
    FreeAndNil(GExtension);
end;

procedure FinalizeExtension;
begin
  if assigned(GExtension) then
    GExtension.Finalize;
end;

initialization

finalization
  FinalizeExtension;
  DestroyGlobalP4PEngine;
  DestroyExtension;

end.

