unit uExtensionModule;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I ..\..\..\source\p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.CustomPyModule, uP4P.PyNone, uP4P.PyModuleDef, uP4P.PyModuleSlotManager;

type
  TExtensionModule = class(TCustomPyModule)
    protected
      procedure CreateModuleDef; override;
      procedure CreateSlotManager; override;
      function  NumberIsEven(args: PPyObject): PPyObject;
      function  CustomUppercase(args: PPyObject): PPyObject;

    public
      constructor Create; reintroduce;
      procedure   AfterConstruction; override;
  end;

  TExtensionPyModuleDef = class(TPyModuleDef)
    protected
      procedure AddAllMethods; override;
  end;

  TExtensionPySlotManager = class(TPyModuleSlotManager)
    protected
      procedure AddAllMethods; override;
  end;

implementation

uses
  uP4P.Engine, uP4P.PyTuple, uP4P.PyBool, uP4P.PyUnicode;

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

function extmod_uppercase(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(self, TempModule) and
     (TempModule is TExtensionModule) then
    Result := TExtensionModule(TempModule).CustomUppercase(args)
   else
    Result := TPyNone.ReturnNone;
end;

{ TExtensionModule }

constructor TExtensionModule.Create;
begin
  inherited Create('SimplePythonExtension', True);

  FMultIntprSupport := piGilSupported;
end;

procedure TExtensionModule.AfterConstruction;
begin
  inherited AfterConstruction;

  Initialize;
end;

procedure TExtensionModule.CreateModuleDef;
begin
  FModuleDef := TExtensionPyModuleDef.Create;
end;

procedure TExtensionModule.CreateSlotManager;
begin
  FSlotManager := TExtensionPySlotManager.Create;
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

function TExtensionModule.CustomUppercase(args: PPyObject): PPyObject;
var
  TempArgs, TempString, TempResult : IPyObject;
begin
  TempArgs := TPyObject.Wrap(args, False);

  if TPyTuple.Check(TempArgs) then
    begin
      TempString := TPyTuple.GetItem(TempArgs, 0);
      TempResult := TPyUnicode.FromString(uppercase(TempString.AsString));
      Result     := TempResult.UnWrap;
    end
   else
    Result := TPyNone.ReturnNone;
end;

{ TExtensionPyModuleDef }

procedure TExtensionPyModuleDef.AddAllMethods;
begin
  AddMethod('is_even', '', @extmod_is_even, METH_VARARGS);
  AddMethod('uppercase', '', @extmod_uppercase, METH_VARARGS);
end;

{ TExtensionPySlotManager }

procedure TExtensionPySlotManager.AddAllMethods;
begin
  AddMethod('is_even', '', @extmod_is_even, METH_VARARGS);
  AddMethod('uppercase', '', @extmod_uppercase, METH_VARARGS);
end;

end.
