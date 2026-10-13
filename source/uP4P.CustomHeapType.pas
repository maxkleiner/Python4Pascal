unit uP4P.CustomHeapType;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.AnsiStrings,
  {$ELSE}
    Classes, SysUtils, {$IFDEF DELPHI12_UP}AnsiStrings,{$ENDIF}
  {$ENDIF}
  uP4P.Types, uP4P.Interfaces;

type
  TCustomHeapType = class
    protected
      FName                  : string;
      FHeapType              : IPyObject;
      FTypeSpec              : IPyType_Spec;
      FSlotManager           : IPySlotManager;
      FUseLegacyAPI          : boolean;
      FID                    : cardinal;

      function  GetName: AnsiString;
      function  GetSlots: PPySlot;
      function  GetTypeSpec: PPyType_Spec;

      procedure SetUseLegacyAPI(aValue: boolean);
      /// <summary>
      /// Override this procedure to create your custom IPyType_Spec instance.
      /// </summary>
      procedure CreateTypeSpec; virtual;
      /// <summary>
      /// Override this procedure to create your custom IPySlotManager instance.
      /// </summary>
      procedure CreateSlotManager; virtual;
      /// <summary>
      /// Initialize the heap type in Python 3.14 or older. It uses an
      /// IPyType_Spec instance.
      /// </summary>
      function  LegacyInitialization: boolean;
      /// <summary>
      /// Initialize the heap type in Python 3.15 or newer. It uses an
      /// IPySlotManager instance.
      /// </summary>
      function  UnifiedSlotInitialization: boolean;
      /// <summary>
      /// <para>Add the heap type to the internal heap type list.</para>
      /// </summary>
      procedure AddHeapType; virtual;
      /// <summary>
      /// <para>Remove the heap type from the internal heap type list.</para>
      /// </summary>
      procedure RemoveHeapType; virtual;

    public
      constructor Create(const aName: string; aIsExtension: boolean = False);
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      procedure   BeforeDestruction; override;
      /// <summary>
      /// <para>Test if this heap type is the same as the "other" heap
      /// type.</para>
      /// </summary>
      function    SameAs(const other: PPyObject): boolean; virtual;
      /// <summary>
      /// <para>Create the heap type and all the slots.</para>
      /// </summary>
      function    Initialize: boolean;
      /// <summary>
      /// <para>Destroy the heap type and remove it from the internal modules
      /// list in GlobalP4PEngine.</para>
      /// <para>This is necessary before calling TPy.EndInterpreter.</para>
      /// </summary>
      /// <remarks>
      /// <para>See the TP4PThread class.</para>
      /// </remarks>
      procedure   Finalize;

      /// <summary>
      /// <para>PyObject instance of this heap type.</para>
      /// </summary>
      property HeapType                      : IPyObject           read FHeapType;
      /// <summary>
      /// Return a pointer to the PyType_Spec record.
      /// </summary>
      property TypeSpec                      : PPyType_Spec        read GetTypeSpec;
      /// <summary>
      /// Return a pointer to the first slot.
      /// </summary>
      property Slots                         : PPySlot             read GetSlots;
      /// <summary>
      /// <para>heap type name.</para>
      /// </summary>
      property Name_                         : AnsiString          read GetName;
      /// <summary>
      /// <para>Use the legacy API to initialize the module.</para>
      /// </summary>
      property UseLegacyAPI                  : boolean             read FUseLegacyAPI             write SetUseLegacyAPI;
  end;

implementation

uses
  uP4P.PyModuleSpecHelper, uP4P.PyModule, uP4P.Engine,
  uP4P.PyModuleDef, uP4P.PySlotManager, uP4P.MiscFunctions,
  uP4P.PyType_Spec, uP4P.PyCustomModuleSlotManager;

constructor TCustomHeapType.Create(const aName: string; aIsExtension: boolean);
begin
  inherited Create;

  FName                  := aName;
  FHeapType              := nil;
  FTypeSpec              := nil;
  FSlotManager           := nil;

  if (GlobalP4PEngine <> nil) then
    begin
      FID           := GlobalP4PEngine.NextID;
      FUseLegacyAPI := not(GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0));
    end
   else
    begin
      FID           := 0;
      FUseLegacyAPI := True;
    end;
end;

destructor TCustomHeapType.Destroy;
begin
  try
    FTypeSpec    := nil;
    FSlotManager := nil;
  finally
    inherited Destroy;
  end;
end;

procedure TCustomHeapType.AfterConstruction;
begin
  inherited AfterConstruction;

  AddHeapType;
end;

procedure TCustomHeapType.BeforeDestruction;
begin
  try
    Finalize;
  finally
    inherited BeforeDestruction;
  end;
end;

procedure TCustomHeapType.Finalize;
begin
  RemoveHeapType;
  FHeapType := nil;
end;

function TCustomHeapType.GetName: AnsiString;
begin
  if assigned(FTypeSpec) then
    Result := FTypeSpec.Name_
   else
    if assigned(FSlotManager) then
      Result := FSlotManager.Name_
     else
      Result := '';
end;

function TCustomHeapType.GetTypeSpec: PPyType_Spec;
begin
  if assigned(FTypeSpec) then
    Result := FTypeSpec.TypeSpec
   else
    Result := nil;
end;

function TCustomHeapType.GetSlots: PPySlot;
begin
  if assigned(FSlotManager) then
    Result := FSlotManager.Slots
   else
    Result := nil;
end;

procedure TCustomHeapType.SetUseLegacyAPI(aValue: boolean);
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
    FUseLegacyAPI := aValue
   else
    FUseLegacyAPI := True;
end;

procedure TCustomHeapType.CreateTypeSpec;
begin
  FTypeSpec := TPyType_Spec.Create;
end;

procedure TCustomHeapType.CreateSlotManager;
begin
  FSlotManager := TPyCustomModuleSlotManager.Create;
end;

function TCustomHeapType.SameAs(const other: PPyObject): boolean;
begin
  Result := False;
  if not(assigned(other)) then exit;

  if assigned(FHeapType) then
    Result := FHeapType.SameAs(other)
   else
    Result := (Trim(Name_) = TPyModule.GetName(other));
end;

function TCustomHeapType.LegacyInitialization: boolean;
var
  TempSpec : IPyObject;
begin
  Result := False;
  if assigned(FHeapType) then exit;

  CreateTypeSpec;

  FTypeSpec.Name_ := StringToPyUTF8(FName);

  FTypeSpec.BuildSlots;
          {
  try
    TempSpec := TPyModuleSpecHelper.FromModuleName(FModuleDef.Name_);
    FModule  := TPyModule.FromDefAndSpec(FModuleDef.ModuleDef, TempSpec);

    if AddToSysModules and
       TPyModule.ExecDef(FModule, FModuleDef.ModuleDef) then
      Result := True
     else
      GlobalP4PEngine.GetRaisedException;
  finally
    TempSpec := nil;
  end;                    }
end;

function TCustomHeapType.UnifiedSlotInitialization: boolean;
var
  TempSpec : IPyObject;
begin
  Result := False;
  if assigned(FHeapType) then exit;

  CreateSlotManager;

  FSlotManager.Name_            := StringToPyUTF8(FName);
  FSlotManager.Token            := {%H-}pointer(FID);

  FSlotManager.BuildSlots;
  {
  try
    TempSpec := TPyModuleSpecHelper.FromModuleName(FSlotManager.Name_);
    FModule  := TPyModule.FromSlotsAndSpec(FSlotManager.Slots, TempSpec);

    if AddToSysModules and
       TPyModule.Exec(FModule) then
      Result := True
     else
      GlobalP4PEngine.GetRaisedException;
  finally
    TempSpec := nil;
  end;   }
end;

function TCustomHeapType.Initialize: boolean;
begin
  if FUseLegacyAPI then
    Result := LegacyInitialization
   else
    Result := UnifiedSlotInitialization;
end;

procedure TCustomHeapType.AddHeapType;
begin
  if (GlobalP4PEngine <> nil) then
    GlobalP4PEngine.AddHeapType(self);
end;

procedure TCustomHeapType.RemoveHeapType;
begin
  if (GlobalP4PEngine <> nil) then
    GlobalP4PEngine.RemoveHeapType(self);
end;

end.
