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

    public
      function GetID(args: PPyObject): PPyObject;
  end;

  TPyTestType_Spec = class(TPyType_Spec)
    protected
      procedure AddAllSlots; override;
      procedure AddAllMethods; override;
  end;

  TPyTestSlotManager = class(TPyHeapTypeSlotManager)
    protected
      procedure AddAllSlots; override;
      procedure AddAllMethods; override;
  end;


implementation

uses
  System.SysUtils,
  uP4P.MiscFunctions, uP4P.Engine, uP4P.PyTuple, uP4P.PyUnicode, uP4P.PyBytes,
  uP4P.PyRun, uP4P.PyBool, uP4P.PyLong;

function mytype_repr(self: PPyObject): PPyObject; cdecl;
var
  TempResult : IPyObject;
begin
  TempResult := TPyUnicode.FromString('<' + TEST_TYPE_NAME + ' object at 0x' + IntToHex(uint64(self), SizeOf(Pointer) * 2) + '>');
  Result     := TempResult.UnWrap;
end;

function mytype_getid(self, args: PPyObject): PPyObject; cdecl;
var
  TempType: TCustomHeapType;
begin
  TempType := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchHeapType(self, False, TempType) and
     (TempType is TTestHeapType) then
    Result := TTestHeapType(TempType).GetID(args)
   else
    Result := TPyNone.ReturnNone;
end;

{ TTestHeapType }

procedure TTestHeapType.CreateSlotManager;
begin
  FSlotManager       := TPyTestSlotManager.Create;
  FSlotManager.Flags := Py_TPFLAGS_DEFAULT or Py_TPFLAGS_BASETYPE;
end;

procedure TTestHeapType.CreateTypeSpec;
begin
  FTypeSpec       := TPyTestType_Spec.Create;
  FTypeSpec.Flags := Py_TPFLAGS_DEFAULT or Py_TPFLAGS_BASETYPE;
end;

function TTestHeapType.GetID(args: PPyObject): PPyObject;
var
  TempResult : IPyObject;
begin
  TempResult := TPyLong.FromLong(self.ID);
  Result     := TempResult.UnWrap;
end;

{ TPyTestType_Spec }

procedure TPyTestType_Spec.AddAllSlots;
begin
  inherited AddAllSlots;

  AddReprSlot(mytype_repr);
end;

procedure TPyTestType_Spec.AddAllMethods;
begin
  inherited;
  AddMethod('getid', '', @mytype_getid, METH_VARARGS);
end;

{ TPyTestSlotManager }

procedure TPyTestSlotManager.AddAllSlots;
begin
  inherited AddAllSlots;

  AddReprSlot(mytype_repr);
end;

procedure TPyTestSlotManager.AddAllMethods;
begin
  inherited;
  AddMethod('getid', '', @mytype_getid, METH_VARARGS);
end;

end.
