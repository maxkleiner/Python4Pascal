unit uTestModule;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.CustomPyModule, uP4P.PyNone, uP4P.PyModuleDef, uP4P.PyModuleSlotManager;

const
  TEST_MODULE_NAME = 'mytest';

type
  TTestModule = class(TCustomPyModule)
    protected
      procedure CreateModuleDef; override;
      procedure CreateSlotManager; override;
      function  NumberIsEven(args: PPyObject): PPyObject;
  end;

  TPyTestModuleDef = class(TPyModuleDef)
    protected
      procedure AddAllMethods; override;
  end;

  TPyTestSlotManager = class(TPyModuleSlotManager)
    protected
      procedure AddAllMethods; override;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.Engine, uP4P.PyTuple, uP4P.PyUnicode, uP4P.PyBytes,
  uP4P.PyRun, uP4P.PyBool;

function mytest_is_even(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(self, TempModule) and
     (TempModule is TTestModule) then
    Result := TTestModule(TempModule).NumberIsEven(args)
   else
    Result := TPyNone.ReturnNone;
end;

{ TTestModule }

procedure TTestModule.CreateModuleDef;
begin
  FModuleDef := TPyTestModuleDef.Create;
end;

procedure TTestModule.CreateSlotManager;
begin
  FSlotManager := TPyTestSlotManager.Create;
end;

function TTestModule.NumberIsEven(args: PPyObject): PPyObject;
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

{ TPyTestModuleDef }

procedure TPyTestModuleDef.AddAllMethods;
begin
  inherited AddAllMethods;

  AddMethod('is_even', '', @mytest_is_even, METH_VARARGS);
end;

{ TPyTestSlotManager }

procedure TPyTestSlotManager.AddAllMethods;
begin
  inherited AddAllMethods;

  AddMethod('is_even', '', @mytest_is_even, METH_VARARGS);
end;

end.
