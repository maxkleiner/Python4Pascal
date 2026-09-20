unit uTestModule;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, Vcl.Forms,
  {$ELSE}
    Classes, Forms,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.CustomPyModule, uP4P.PyNone, uP4P.PyModuleDef, uP4P.PySlotManager;

const
  TEST_MODULE_NAME = 'mytest';

type
  TTestModule = class(TCustomPyModule)
    protected
      FMainForm : TForm;

      procedure CreateModuleDef; override;
      procedure CreateSlotManager; override;
      function  Write(args: PPyObject): PPyObject;
      function  Read(args: PPyObject): PPyObject;

    public
      property MainForm : TForm  read FMainForm  write FMainForm;
  end;

  TPyTestModuleDef = class(TPyModuleDef)
    protected
      procedure AddAllMethods; override;
  end;

  TPyTestSlotManager = class(TPySlotManager)
    protected
      procedure AddAllMethods; override;
  end;

implementation

uses
  uMainForm,
  uP4P.MiscFunctions, uP4P.Engine, uP4P.PyTuple, uP4P.PyUnicode, uP4P.PyBytes,
  uP4P.PyRun;

function mytest_write(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(self, TempModule) and
     (TempModule is TTestModule) then
    Result := TTestModule(TempModule).Write(args)
   else
    Result := TPyNone.ReturnNone;
end;

function mytest_read(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(self, TempModule) and
     (TempModule is TTestModule) then
    Result := TTestModule(TempModule).Read(args)
   else
    Result := TPyNone.ReturnNone;
end;

{ TTestModule }

procedure TTestModule.CreateModuleDef;
begin
  FModuleDef := TPyTestModuleDef.Create(FName, FDocStrings);
end;

procedure TTestModule.CreateSlotManager;
begin
  FSlotManager := TPyTestSlotManager.Create(FName, FDocStrings);
end;

function TTestModule.Write(args: PPyObject): PPyObject;
var
  TempArgs, TempItem : IPyObject;
begin
  TempArgs := TPyObject.Wrap(args, False);

  if TPyTuple.Check(TempArgs) and assigned(FMainForm) then
    begin
      TempItem := TPyTuple.GetItem(TempArgs, 0);
      TMainForm(FMainForm).CustomValue := TempItem.AsString;
    end;

  Result := TPyNone.ReturnNone;
end;

function TTestModule.Read(args: PPyObject): PPyObject;
var
  TempResult : IPyObject;
begin
  if assigned(FMainForm) then
    begin
      TempResult := TPyUnicode.FromString(TMainForm(FMainForm).CustomValue);
      Result     := TempResult.UnWrap;
    end
   else
    Result := TPyNone.ReturnNone;
end;

{ TPyTestModuleDef }

procedure TPyTestModuleDef.AddAllMethods;
begin
  inherited AddAllMethods;

  AddMethod('write', '', @mytest_write, METH_VARARGS);
  AddMethod('read', '', @mytest_read, METH_VARARGS);
end;

{ TPyTestSlotManager }

procedure TPyTestSlotManager.AddAllMethods;
begin
  inherited AddAllMethods;

  AddMethod('write', '', @mytest_write, METH_VARARGS);
  AddMethod('read', '', @mytest_read, METH_VARARGS);
end;

end.
