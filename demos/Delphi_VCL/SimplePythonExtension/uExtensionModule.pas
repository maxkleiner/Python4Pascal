unit uExtensionModule;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I ..\..\..\source\p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.CustomPyModule, uP4P.PyNone, uP4P.PyModuleDef, uP4P.PySlotManager;

type
  TExtensionModule = class(TCustomPyModule)
    protected
      procedure CreateModuleDef; override;
      procedure CreateSlotManager; override;
      function  NumberIsEven(args: PPyObject): PPyObject;
  end;

  TExtensionPyModuleDef = class(TPyModuleDef)
    protected
      procedure AddAllMethods; override;
  end;

  TExtensionPySlotManager = class(TPySlotManager)
    protected
      procedure AddAllMethods; override;
  end;

implementation

uses
  uP4P.Engine, uP4P.PyTuple, uP4P.PyBool;

function extmod_is_even(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(self, TempModule) and
     (TempModule is TExtensionModule) then
    Result := TExtensionModule(TempModule).NumberIsEven(args)
   else
    Result := TPyNone.ReturnNone;
end;

{ TExtensionModule }

procedure TExtensionModule.CreateModuleDef;
begin
  FModuleDef := TExtensionPyModuleDef.Create(FName, FDocStrings);
end;

procedure TExtensionModule.CreateSlotManager;
begin
  FSlotManager := TExtensionPySlotManager.Create(FName, FDocStrings);
end;

function TExtensionModule.NumberIsEven(args: PPyObject): PPyObject;
var
  TempArgs, TempNumber : IPyObject;
begin
  TempArgs := TPyObject.Wrap(args, False);

  if TPyTuple.Check(TempArgs) then
    begin
      TempNumber := TPyTuple.GetItem(TempArgs, 0);

      if (TempNumber.AsInteger mod 2 = 0) then
        Result := TPyBool.ReturnTrue
       else
        Result := TPyBool.ReturnFalse;
    end
   else
    Result := TPyNone.ReturnNone;
end;

{ TExtensionPyModuleDef }

procedure TExtensionPyModuleDef.AddAllMethods;
begin
  AddMethod('is_even', '', @extmod_is_even, METH_VARARGS);
end;

{ TExtensionPySlotManager }

procedure TExtensionPySlotManager.AddAllMethods;
begin
  AddMethod('is_even', '', @extmod_is_even, METH_VARARGS);
end;

end.
