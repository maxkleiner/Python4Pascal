unit uMain;

{$I ..\..\..\source\p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.SysUtils,
  {$ELSE}
    SysUtils,
  {$ENDIF}
  uP4P.Interfaces, uP4P.Types, uP4P.Constants, uP4P.PyObject, uP4P.Engine;

function PyInit_SimplePythonExtension: PPyObject; cdecl;

implementation

uses
  uExtensionModule;

var
  GExtension : TExtensionModule = nil;

function PyInit_SimplePythonExtension: PPyObject;
begin
  GlobalP4PEngine := TP4PEngine.Create;

  GExtension                  := TExtensionModule.Create('SimplePythonExtension', True);
  GExtension.MultIntprSupport := piGilSupported;

  if GlobalP4PEngine.LoadInExtensionModule then
    Result := PPyObject(GExtension.ModuleDef)
   else
    Result := nil;
end;

procedure DestroyExtension;
begin
  if assigned(GExtension) then
    FreeAndNil(GExtension);
end;

initialization

finalization
  DestroyGlobalP4PEngine;
  DestroyExtension;

end.
