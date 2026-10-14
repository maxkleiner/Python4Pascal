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
  uP4P.Types, uP4P.Interfaces, uP4P.PyObject, uP4P.PyType;

type
  TCustomHeapType = class
    protected
      FName                  : string;
      FHeapType              : IPyObject;
      FTypeSpec              : IPyType_Spec;
      FSlotManager           : IPySlotManager;
      FMetaclass             : PPyTypeObject;
      FModule                : IPyObject;
      FBases                 : IPyObject;
      FUseLegacyAPI          : boolean;
      FID                    : cardinal;

      function  GetHeapType: IPyObject;
      function  GetName: AnsiString;
      function  GetSlots: PPySlot;
      function  GetTypeSpec: PPyType_Spec;
      function  GetMetaclass: PPyTypeObject;
      function  GetModule: IPyObject;
      function  GetBases: IPyObject;
      function  GetUseLegacyAPI: boolean;
      function  GetToken: pointer;

      procedure SetMetaclass(aValue: PPyTypeObject);
      procedure SetModule(const aValue: IPyObject);
      procedure SetBases(const aValue: IPyObject);
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
      constructor Create(const aName: string);
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
      /// <para>Destroy the heap type and remove it from the internal heap types
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
      property HeapType                      : IPyObject           read GetHeapType;
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
      /// <para>Metaclass is used to construct the resulting type object.</para>
      /// <para>When metaclass is nil, the metaclass is derived from bases
      /// (or Py_tp_base[s] slots if bases is nil, see below).</para>
      /// <para>Metaclasses that override tp_new are not supported, except if
      /// tp_new is nil.</para>
      /// </summary>
      property Metaclass                     : PPyTypeObject       read GetMetaclass                write SetMetaclass;
      /// <summary>
      /// <para>Module can be used to record the module in which the new class
      /// is defined. It must be a module object or nil. If not nil, the module
      /// is associated with the new type and can later be retrieved with
      /// TPyType.GetModule(). The associated module is not inherited by
      /// subclasses; it must be specified for each class individually.</para>
      /// </summary>
      property Module                        : IPyObject           read GetModule                   write SetModule;
      /// <summary>
      /// <para>Bases can be used to specify base classes; it can either be only
      /// one class or a tuple of classes. If bases is nil, the Py_tp_bases slot
      /// is used instead. If that also is nil, the Py_tp_base slot is used
      /// instead. If that also is nil, the new type derives from object.</para>
      /// </summary>
      property Bases                         : IPyObject           read GetBases                    write SetBases;
      /// <summary>
      /// <para>Use the legacy API to initialize the module.</para>
      /// </summary>
      property UseLegacyAPI                  : boolean             read GetUseLegacyAPI             write SetUseLegacyAPI;
      /// <summary>
      /// <para>The heap type token.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/type.html#c.Py_tp_token">See the article about Py_tp_token.</see></para>
      /// <para>Added in version 3.14.</para>
      /// </remarks>
      property Token                         : Pointer             read GetToken;
  end;

implementation

uses
  uP4P.PyModule, uP4P.Engine, uP4P.Constants, uP4P.PySlotManager,
  uP4P.MiscFunctions, uP4P.PyType_Spec, uP4P.PyHeapTypeSlotManager;

constructor TCustomHeapType.Create(const aName: string);
begin
  inherited Create;

  FName                  := aName;
  FHeapType              := nil;
  FTypeSpec              := nil;
  FSlotManager           := nil;
  FMetaclass             := nil;
  FModule                := nil;
  FBases                 := nil;

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
    FMetaclass   := nil;
    FModule      := nil;
    FBases       := nil;
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

function TCustomHeapType.GetHeapType: IPyObject;
begin
  Result := FHeapType;
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

function TCustomHeapType.GetMetaclass: PPyTypeObject;
begin
  Result := FMetaclass;
end;

function TCustomHeapType.GetModule: IPyObject;
begin
  Result := FModule;
end;

function TCustomHeapType.GetBases: IPyObject;
begin
  Result := FBases;
end;

function TCustomHeapType.GetUseLegacyAPI: boolean;
begin
  Result := FUseLegacyAPI;
end;

function TCustomHeapType.GetToken: pointer;
begin
  Result := TPyType.GetSlot(FHeapType, Py_tp_token);
end;

function TCustomHeapType.GetSlots: PPySlot;
begin
  if assigned(FSlotManager) then
    Result := FSlotManager.Slots
   else
    Result := nil;
end;

procedure TCustomHeapType.SetMetaclass(aValue: PPyTypeObject);
begin
  FMetaclass := aValue;
end;

procedure TCustomHeapType.SetModule(const aValue: IPyObject);
begin
  FModule := aValue;
end;

procedure TCustomHeapType.SetBases(const aValue: IPyObject);
begin
  FBases := aValue;
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
  FSlotManager := TPyHeapTypeSlotManager.Create;
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
begin
  Result := False;
  if assigned(FHeapType) then exit;

  CreateTypeSpec;

  FTypeSpec.Name_ := StringToPyUTF8(FName);
  FTypeSpec.Token := {%H-}pointer(FID);

  FTypeSpec.BuildMethodsAndSlots;

  FHeapType := TPyType.FromMetaclass(FMetaclass, FModule, FTypeSpec.TypeSpec, FBases);

  if TPyObject.IsInitialized(FHeapType) then
    Result := True
   else
    GlobalP4PEngine.GetRaisedException;
end;

function TCustomHeapType.UnifiedSlotInitialization: boolean;
begin
  Result := False;
  if assigned(FHeapType) then exit;

  CreateSlotManager;

  FSlotManager.Name_ := StringToPyUTF8(FName);
  FSlotManager.Token := {%H-}pointer(FID);

  FSlotManager.BuildMethodsAndSlots;

  FHeapType := TPyType.FromSlots(FSlotManager.Slots);

  if TPyObject.IsInitialized(FHeapType) then
    Result := True
   else
    GlobalP4PEngine.GetRaisedException;
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
