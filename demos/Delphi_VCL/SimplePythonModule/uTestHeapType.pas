unit uTestHeapType;

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
  uP4P.CustomHeapType, uP4P.PyNone, uP4P.PyType_Spec, uP4P.PyHeapTypeSlotManager;

const
  TEST_TYPE_NAME = 'mytype';

type
  TTestHeapType = class(TCustomHeapType)
    protected
      procedure CreateTypeSpec; override;
      procedure CreateSlotManager; override;

  end;

  TPyTestType_Spec = class(TPyType_Spec)
    protected
      procedure AddAllMethods; override;
  end;

  TPyTestSlotManager = class(TPyHeapTypeSlotManager)
    protected
      procedure AddAllMethods; override;
  end;


implementation

uses
  uP4P.MiscFunctions, uP4P.Engine, uP4P.PyTuple, uP4P.PyUnicode, uP4P.PyBytes,
  uP4P.PyRun, uP4P.PyBool;

{ TTestHeapType }

procedure TTestHeapType.CreateSlotManager;
begin
  FSlotManager := TPyTestSlotManager.Create;
end;

procedure TTestHeapType.CreateTypeSpec;
begin
  FTypeSpec := TPyTestType_Spec.Create;
end;

{ TPyTestType_Spec }

procedure TPyTestType_Spec.AddAllMethods;
begin
  inherited;

end;

{ TPyTestSlotManager }

procedure TPyTestSlotManager.AddAllMethods;
begin
  inherited;

end;

end.
