unit uP4P.PyHeapTypeSlotManager;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF}
  uP4P.Types, uP4P.Constants, uP4P.Interfaces;

type
  /// <summary>
  /// <para>TPyCustomHeapTypeSlotManager is used to store the information about
  /// the heap type and to manage the method and slot lists.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/type.html#creating-heap-allocated-types">See the article about Creating Heap-Allocated Types.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/type.html#c.PyTypeObject">See the article about PyTypeObject.</see></para>
  /// </remarks>
  TPyHeapTypeSlotManager = class(TInterfacedObject, IPyHeapTypeSlotManager)
    protected
      FName                  : AnsiString;
      FDocStrings            : AnsiString;
      FSlotList              : TList;
      FSlots                 : PySlotArray;
      FMethodList            : TList;
      FMethods               : PyMethodDefArray;
      FMemberList            : TList;
      FMembers               : PyMemberDefArray;
      FGetSetList            : TList;
      FGetSets               : PyGetSetDefArray;
      FToken                 : pointer;
      FMetaclass             : PPyTypeObject;
      FModule                : IPyObject;
      FBases                 : IPyObject;
      FBasicsize             : Py_ssize_t;
      FExtraBasicsize        : Py_ssize_t;
      FItemsize              : Py_ssize_t;
      FFlags                 : NativeUInt;

      function  GetName: AnsiString;
      function  GetDocStrings: AnsiString;
      function  GetToken: pointer;
      function  GetHasSentinelSlot: boolean;
      function  GetHasSentinelMethod: boolean;
      function  GetHasSentinelMember: boolean;
      function  GetHasSentinelGetSet: boolean;
      function  GetSlots: PPySlot;
      function  GetMetaclass: PPyTypeObject;
      function  GetModule: IPyObject;
      function  GetBases: IPyObject;
      function  GetBasicsize: Py_ssize_t;
      function  GetExtraBasicsize: Py_ssize_t;
      function  GetItemsize: Py_ssize_t;
      function  GetFlags: NativeUInt;

      procedure SetName(const aValue: AnsiString);
      procedure SetDocStrings(const aValue: AnsiString);
      procedure SetToken(aValue: pointer);
      procedure SetMetaclass(aValue: PPyTypeObject);
      procedure SetModule(const aValue: IPyObject);
      procedure SetBases(const aValue: IPyObject);
      procedure SetBasicSize(aValue: Py_ssize_t);
      procedure SetExtraBasicSize(aValue: Py_ssize_t);
      procedure SetItemSize(aValue: Py_ssize_t);
      procedure SetFlags(aValue: NativeUInt);

      procedure CreateSlotArray;
      procedure CreateMethodArray;
      procedure CreateMemberArray;
      procedure CreateGetSetArray;

      procedure DestroySlotList;
      procedure DestroySlots;
      procedure DestroyMethodList;
      procedure DestroyMethods;
      procedure DestroyMemberList;
      procedure DestroyMembers;
      procedure DestroyGetSetList;
      procedure DestroyGetSets;

      function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
      function  AddMember(const aName, aDocStrings: string; aType, aFlags: integer; aOffset: Py_ssize_t): boolean;
      function  AddGetSet(const aName, aDocStrings: string; const aGet: getter; const aSet: setter; aClosure: pointer): boolean;
      function  AddSentinelMethod: boolean;
      function  AddSentinelSlot: boolean;
      function  AddSentinelMember: boolean;
      function  AddSentinelGetSet: boolean;
      function  AddNameSlot: boolean;
      function  AddDocStringsSlot: boolean;
      function  AddTokenSlot: boolean;
      function  AddMethodsSlot: boolean;
      function  AddMembersSlot: boolean;
      function  AddGetSetsSlot: boolean;
      function  AddMetaclassSlot: boolean;
      function  AddModuleSlot: boolean;
      function  AddBasesSlot: boolean;
      function  AddBasicsizeSlot: boolean;
      function  AddExtraBasicsizeSlot: boolean;
      function  AddItemsizeSlot: boolean;
      function  AddFlagsSlot: boolean;
      function  AddSlotsSlot(const aSlots: PPyType_Slot): boolean;
      function  AddSubslotsSlot(const aSlots: PPySlot): boolean;
      function  AddReprSlot(const aFunc: tp_reprfunc): boolean;

      /// <summary>
      /// Override this procedure to add your custom slots.
      /// </summary>
      procedure AddAllSlots; virtual;
      /// <summary>
      /// Override this procedure to add your custom methods.
      /// </summary>
      procedure AddAllMethods; virtual;
      /// <summary>
      /// Override this procedure to add your custom members.
      /// </summary>
      procedure AddAllMembers; virtual;
      /// <summary>
      /// Override this procedure to add your custom getsets.
      /// </summary>
      procedure AddAllGetSets; virtual;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      /// <summary>
      /// Create the slots with the methods and all the heap type information.
      /// </summary>
      procedure   Initialize; virtual;

      /// <summary>
      /// Name of the new data type.
      /// </summary>
      property  Name_                  : AnsiString         read GetName                 write SetName;
      /// <summary>
      /// The docstring of the new data type.
      /// </summary>
      property  DocStrings             : AnsiString         read GetDocStrings           write SetDocStrings;
      /// <summary>
      /// Return True if the last slot has a Py_slot_end value in the
      /// sl_id field.
      /// </summary>
      property  HasSentinelSlot        : boolean            read GetHasSentinelSlot;
      /// <summary>
      /// Return True if the last method in the list is a sentinel method.
      /// </summary>
      property  HasSentinelMethod      : boolean            read GetHasSentinelMethod;
      /// <summary>
      /// Return True if the last method in the list is a sentinel member.
      /// </summary>
      property  HasSentinelMember      : boolean            read GetHasSentinelMember;
      /// <summary>
      /// Return True if the last method in the list is a sentinel getsetter.
      /// </summary>
      property  HasSentinelGetSet      : boolean            read GetHasSentinelGetSet;
      /// <summary>
      /// Return a pointer to the first slot.
      /// </summary>
      property  Slots                  : PPySlot            read GetSlots;
      /// <summary>
      /// The associated token is a pointer-sized value intended to identify
      /// this object.
      /// </summary>
      property  Token                  : pointer            read GetToken                write SetToken;
      /// <summary>
      /// <para>Metaclass is used to construct the resulting type object.</para>
      /// <para>When metaclass is nil, the metaclass is derived from bases
      /// (or Py_tp_base[s] slots if bases is nil, see below).</para>
      /// <para>Metaclasses that override tp_new are not supported, except if
      /// tp_new is nil.</para>
      /// </summary>
      property  Metaclass              : PPyTypeObject       read GetMetaclass           write SetMetaclass;
      /// <summary>
      /// <para>Module can be used to record the module in which the new class
      /// is defined. It must be a module object or nil. If not nil, the module
      /// is associated with the new type and can later be retrieved with
      /// TPyType.GetModule(). The associated module is not inherited by
      /// subclasses; it must be specified for each class individually.</para>
      /// </summary>
      property  Module                 : IPyObject           read GetModule              write SetModule;
      /// <summary>
      /// <para>Bases can be used to specify base classes; it can either be only
      /// one class or a tuple of classes. If bases is nil, the Py_tp_bases slot
      /// is used instead. If that also is nil, the Py_tp_base slot is used
      /// instead. If that also is nil, the new type derives from object.</para>
      /// </summary>
      property  Bases                  : IPyObject           read GetBases               write SetBases;
      /// <summary>
      /// <para>The size of the instance in bytes. It is used to set
      /// PyTypeObject.tp_basicsize.</para>
      /// <para>The value must be positive.</para>
      /// <para>This may not be used in PyType_Spec.slots. Use
      /// PyType_Spec.basicsize instead.</para>
      /// <para>This slot may not be used with TPyType.GetSlot(). Use
      /// PyTypeObject.tp_basicsize instead if needed, but be aware that a
      /// type's size is often considered an implementation detail.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      property  Basicsize              : Py_ssize_t          read GetBasicsize           write SetBasicsize;
      /// <summary>
      /// <para>Type data size in bytes, that is, how much space instances of
      /// the class need in addition to space needed for superclasses.</para>
      /// <para>The value is used, together with the size of superclasses, to
      /// set PyTypeObject.tp_basicsize. Python will insert padding as needed
      /// to meet tp_basicsize's alignment requirements.</para>
      /// <para>Use TPyObject.GetTypeData() to get a pointer to
      /// subclass-specific memory reserved this way.</para>
      /// <para>The value must be positive. To specify that instances need no
      /// additional size (that is, size should be inherited), omit the
      /// Py_tp_extra_basicsize slot rather than set it to zero.</para>
      /// <para>Specifying both Py_tp_basicsize and Py_tp_extra_basicsize is
      /// an error.</para>
      /// <para>This may not be used in PyType_Spec.slots. Use negative
      /// PyType_Spec.basicsize instead.</para>
      /// <para>This slot may not be used with TPyType.GetSlot().</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      property  ExtraBasicsize         : Py_ssize_t          read GetExtraBasicsize      write SetExtraBasicsize;
      /// <summary>
      /// <para>The size of one element of a variable-size type, in bytes.
      /// Used to set PyTypeObject.tp_itemsize. See tp_itemsize documentation
      /// for caveats.</para>
      /// <para>The value must be positive.</para>
      /// <para>If this slot is missing, tp_itemsize is inherited. Extending
      /// arbitrary variable-sized classes is dangerous, since some types use
      /// a fixed offset for variable-sized memory, which can then overlap
      /// fixed-sized memory used by a subclass. To help prevent mistakes,
      /// inheriting itemsize is only possible in the following
      /// situations:</para>
      /// <code>
      /// - The base is not variable-sized (its tp_itemsize is zero).
      /// - The requested PyType_Spec.basicsize is positive, suggesting that
      ///   the memory layout of the base class is known.
      /// - The requested PyType_Spec.basicsize is zero, suggesting that the
      ///   subclass does not access the instance's memory directly.
      /// </code>
      /// <para>With the Py_TPFLAGS_ITEMS_AT_END flag.</para>
      /// <para>This may not be used in PyType_Spec.slots. Use
      /// PyType_Spec.itemsize instead.</para>
      /// <para>This slot may not be used with TPyType.GetSlot().</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      property  Itemsize               : Py_ssize_t          read GetItemsize            write SetItemsize;
      /// <summary>
      /// <para>Type flags, used to set PyTypeObject.tp_flags.</para>
      /// <para>The Py_TPFLAGS_HEAPTYPE flag is not set,
      /// TPyType.FromSpecWithBases() sets it automatically.</para>
      /// <para>This may not be used in PyType_Spec.slots. Use negative
      /// PyType_Spec.basicsize instead.</para>
      /// <para>This slot may not be used with TPyType.GetSlot().
      /// Use TPyType.GetFlags() instead.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      property  Flags                  : NativeUInt          read GetFlags               write SetFlags;
  end;

implementation

uses
  uP4P.PyMethodDef, uP4P.Engine, uP4P.PyObject, uP4P.PySlot, uP4P.PyMemberDef,
  uP4P.PyGetSetDef;

constructor TPyHeapTypeSlotManager.Create;
begin
  inherited Create;

  FName                  := '';
  FDocStrings            := '';
  FSlotList              := nil;
  FSlots                 := nil;
  FMethodList            := nil;
  FMethods               := nil;
  FMemberList            := nil;
  FMembers               := nil;
  FGetSetList            := nil;
  FGetSets               := nil;
  FToken                 := nil;
  FMetaclass             := nil;
  FModule                := nil;
  FBases                 := nil;
  FBasicsize             := low(Py_ssize_t);
  FExtraBasicsize        := low(Py_ssize_t);
  FItemsize              := low(Py_ssize_t);
  FFlags                 := 0;
end;

destructor TPyHeapTypeSlotManager.Destroy;
begin
  try
    DestroySlotList;
    DestroySlots;
    DestroyMethodList;
    DestroyMethods;
    DestroyMemberList;
    DestroyMembers;
    DestroyGetSetList;
    DestroyGetSets;
  finally
    inherited Destroy;
  end;
end;

procedure TPyHeapTypeSlotManager.AfterConstruction;
begin
  inherited AfterConstruction;

  FSlotList   := TList.Create;
  FMethodList := TList.Create;
  FMemberList := TList.Create;
  FGetSetList := TList.Create;
end;

procedure TPyHeapTypeSlotManager.DestroySlotList;
var
  i : integer;
begin
  if assigned(FSlotList) then
    try
      i := pred(FSlotList.Count);
      while (i >= 0) do
        begin
          TPySlot(FSlotList[i]).Free;
          FSlotList[i] := nil;
          dec(i);
        end;
    finally
      FreeAndNil(FSlotList);
    end;
end;

procedure TPyHeapTypeSlotManager.DestroySlots;
begin
  if assigned(FSlots) then
    begin
      SetLength(FSlots, 0);
      FSlots := nil;
    end;
end;

procedure TPyHeapTypeSlotManager.DestroyMethodList;
var
  i : integer;
begin
  if assigned(FMethodList) then
    try
      i := pred(FMethodList.Count);
      while (i >= 0) do
        begin
          TPyMethodDef(FMethodList[i]).Free;
          FMethodList[i] := nil;
          dec(i);
        end;
    finally
      FreeAndNil(FMethodList);
    end;
end;

procedure TPyHeapTypeSlotManager.DestroyMethods;
begin
  if assigned(FMethods) then
    begin
      SetLength(FMethods, 0);
      FMethods := nil;
    end;
end;

procedure TPyHeapTypeSlotManager.DestroyMemberList;
var
  i : integer;
begin
  if assigned(FMemberList) then
    try
      i := pred(FMemberList.Count);
      while (i >= 0) do
        begin
          TPyMemberDef(FMemberList[i]).Free;
          FMemberList[i] := nil;
          dec(i);
        end;
    finally
      FreeAndNil(FMemberList);
    end;
end;

procedure TPyHeapTypeSlotManager.DestroyMembers;
begin
  if assigned(FMembers) then
    begin
      SetLength(FMembers, 0);
      FMembers := nil;
    end;
end;

procedure TPyHeapTypeSlotManager.DestroyGetSetList;
var
  i : integer;
begin
  if assigned(FGetSetList) then
    try
      i := pred(FGetSetList.Count);
      while (i >= 0) do
        begin
          TPyGetSetDef(FGetSetList[i]).Free;
          FGetSetList[i] := nil;
          dec(i);
        end;
    finally
      FreeAndNil(FGetSetList);
    end;
end;

procedure TPyHeapTypeSlotManager.DestroyGetSets;
begin
  if assigned(FGetSets) then
    begin
      SetLength(FGetSets, 0);
      FGetSets := nil;
    end;
end;

procedure TPyHeapTypeSlotManager.CreateSlotArray;
var
  i : integer;
begin
  DestroySlots;

  if assigned(FSlotList) and (FSlotList.Count > 0) then
    begin
      SetLength(FSlots, FSlotList.Count);

      i := 0;
      while (i < FSlotList.Count) do
        begin
          FSlots[i] := TPySlot(FSlotList[i]).Slot;
          inc(i);
        end;
    end;
end;

procedure TPyHeapTypeSlotManager.CreateMethodArray;
var
  i : integer;
begin
  DestroyMethods;

  if assigned(FMethodList) and (FMethodList.Count > 0) then
    begin
      SetLength(FMethods, FMethodList.Count);

      i := 0;
      while (i < FMethodList.Count) do
        begin
          FMethods[i] := TPyMethodDef(FMethodList[i]).Method;
          inc(i);
        end;
    end;
end;

procedure TPyHeapTypeSlotManager.CreateMemberArray;
var
  i : integer;
begin
  DestroyMembers;

  if assigned(FMemberList) and (FMemberList.Count > 0) then
    begin
      SetLength(FMembers, FMemberList.Count);

      i := 0;
      while (i < FMemberList.Count) do
        begin
          FMembers[i] := TPyMemberDef(FMemberList[i]).MemberDef;
          inc(i);
        end;
    end;
end;

procedure TPyHeapTypeSlotManager.CreateGetSetArray;
var
  i : integer;
begin
  DestroyGetSets;

  if assigned(FGetSetList) and (FGetSetList.Count > 0) then
    begin
      SetLength(FGetSets, FGetSetList.Count);

      i := 0;
      while (i < FGetSetList.Count) do
        begin
          FGetSets[i] := TPyGetSetDef(FGetSetList[i]).GetSetDef;
          inc(i);
        end;
    end;
end;

function TPyHeapTypeSlotManager.GetName: AnsiString;
begin
  Result := FName;
end;

function TPyHeapTypeSlotManager.GetDocStrings: AnsiString;
begin
  Result := FDocStrings;
end;

function TPyHeapTypeSlotManager.GetToken: pointer;
begin
  Result := FToken;
end;

function TPyHeapTypeSlotManager.GetHasSentinelSlot: boolean;
begin
  Result := assigned(FSlotList) and
            (FSlotList.Count > 0) and
            TPySlot(FSlotList[FSlotList.Count - 1]).IsEnd;
end;

function TPyHeapTypeSlotManager.GetHasSentinelMethod: boolean;
begin
  Result := assigned(FMethodList) and
            (FMethodList.Count > 0) and
            TPyMethodDef(FMethodList[FMethodList.Count - 1]).IsSentinel;
end;

function TPyHeapTypeSlotManager.GetHasSentinelMember: boolean;
begin
  Result := assigned(FMemberList) and
            (FMemberList.Count > 0) and
            TPyMemberDef(FMemberList[FMemberList.Count - 1]).IsSentinel;
end;

function TPyHeapTypeSlotManager.GetHasSentinelGetSet: boolean;
begin
  Result := assigned(FGetSetList) and
            (FGetSetList.Count > 0) and
            TPyGetSetDef(FGetSetList[FGetSetList.Count - 1]).IsSentinel;
end;

function TPyHeapTypeSlotManager.GetSlots: PPySlot;
begin
  if (Length(FSlots) > 0) then
    Result := @FSlots[0]
   else
    Result := nil;
end;

function TPyHeapTypeSlotManager.GetMetaclass: PPyTypeObject;
begin
  Result := FMetaclass;
end;

function TPyHeapTypeSlotManager.GetModule: IPyObject;
begin
  Result := FModule;
end;

function TPyHeapTypeSlotManager.GetBases: IPyObject;
begin
  Result := FBases;
end;

function TPyHeapTypeSlotManager.GetBasicsize: Py_ssize_t;
begin
  Result := FBasicsize;
end;

function TPyHeapTypeSlotManager.GetExtraBasicsize: Py_ssize_t;
begin
  Result := FExtraBasicsize;
end;

function TPyHeapTypeSlotManager.GetItemsize: Py_ssize_t;
begin
  Result := FItemsize;
end;

function TPyHeapTypeSlotManager.GetFlags: NativeUInt;
begin
  Result := FFlags;
end;

procedure TPyHeapTypeSlotManager.SetName(const aValue: AnsiString);
begin
  FName := aValue;
end;

procedure TPyHeapTypeSlotManager.SetDocStrings(const aValue: AnsiString);
begin
  FDocStrings := aValue;
end;

procedure TPyHeapTypeSlotManager.SetToken(aValue: pointer);
begin
  FToken := aValue;
end;

procedure TPyHeapTypeSlotManager.SetMetaclass(aValue: PPyTypeObject);
begin
  FMetaclass := aValue;
end;

procedure TPyHeapTypeSlotManager.SetModule(const aValue: IPyObject);
begin
  FModule := aValue;
end;

procedure TPyHeapTypeSlotManager.SetBases(const aValue: IPyObject);
begin
  FBases := aValue;
end;

procedure TPyHeapTypeSlotManager.SetBasicSize(aValue: Py_ssize_t);
begin
  FBasicsize := aValue;
end;

procedure TPyHeapTypeSlotManager.SetExtraBasicSize(aValue: Py_ssize_t);
begin
  FExtraBasicsize := aValue;
end;

procedure TPyHeapTypeSlotManager.SetItemSize(aValue: Py_ssize_t);
begin
  FItemsize := aValue;
end;

procedure TPyHeapTypeSlotManager.SetFlags(aValue: NativeUInt);
begin
  FFlags := aValue;
end;

function TPyHeapTypeSlotManager.AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
var
  TempMethod : TPyMethodDef;
begin
  Result := False;

  if assigned(FMethodList) then
    begin
      TempMethod := TPyMethodDef.Create(aName, aDocStrings, aMethod, aFlags);

      if (FMethodList.Add(TempMethod) >= 0) then
        Result := True
       else
        TempMethod.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddMember(const aName, aDocStrings: string; aType, aFlags: integer; aOffset: Py_ssize_t): boolean;
var
  TempMember : TPyMemberDef;
begin
  Result := False;

  if assigned(FMemberList) then
    begin
      TempMember := TPyMemberDef.Create(aName, aDocStrings, aType, aFlags, aOffset);

      if (FMemberList.Add(TempMember) >= 0) then
        Result := True
       else
        TempMember.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddGetSet(const aName, aDocStrings: string; const aGet: getter; const aSet: setter; aClosure: pointer): boolean;
var
  TempGetSet : TPyGetSetDef;
begin
  Result := False;

  if assigned(FGetSetList) then
    begin
      TempGetSet := TPyGetSetDef.Create(aName, aDocStrings, aGet, aSet, aClosure);

      if (FGetSetList.Add(TempGetSet) >= 0) then
        Result := True
       else
        TempGetSet.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddSentinelMethod: boolean;
begin
  Result := AddMethod('', '', nil, 0);
end;

function TPyHeapTypeSlotManager.AddSentinelMember: boolean;
begin
  Result := AddMember('', '', 0, 0, 0);
end;

function TPyHeapTypeSlotManager.AddSentinelGetSet: boolean;
begin
  Result := AddGetSet('', '', nil, nil, nil);
end;

function TPyHeapTypeSlotManager.AddSentinelSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_END;

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddNameSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) and
     assigned(FSlotList) and
     (length(FName) > 0) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_STATIC_STRING(Py_tp_name, FName);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddDocStringsSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and (length(FDocStrings) > 0) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_STRING(Py_tp_doc, FDocStrings);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddTokenSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 14, 0) and
     assigned(FSlotList) and
     assigned(FToken) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_DATA(Py_tp_token, FToken);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddMethodsSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FMethods) and (length(FMethods) > 1) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_STATIC_DATA(Py_tp_methods, @FMethods[0]);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddMembersSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FMembers) and (length(FMembers) > 1) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_STATIC_DATA(Py_tp_members, @FMembers[0]);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddGetSetsSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FGetSets) and (length(FGetSets) > 1) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_STATIC_DATA(Py_tp_getset, @FGetSets[0]);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddMetaclassSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) and
     assigned(FSlotList) and
     assigned(FMetaclass) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_DATA(Py_tp_metaclass, FMetaclass);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddModuleSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) and
     assigned(FSlotList) and
     TPyObject.IsInitialized(FModule) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_DATA(Py_tp_module, FModule.PyObject);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddBasesSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and TPyObject.IsInitialized(FBases) then
    begin
      TempSlot := TPySlot.Create;

      if (GlobalP4PEngine <> nil) and
         GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
        TempSlot.Set_DATA(Py_tp_bases, FBases.PyObject)
       else
        TempSlot.Set_DATA(Py_tp_base, FBases.PyObject);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddBasicsizeSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) and
     assigned(FSlotList) and
     (FBasicsize <> low(Py_ssize_t)) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_SIZE(Py_tp_basicsize, FBasicsize);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddExtraBasicsizeSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) and
     assigned(FSlotList) and
     (FExtraBasicsize <> low(Py_ssize_t)) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_SIZE(Py_tp_extra_basicsize, FExtraBasicsize);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddItemsizeSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) and
     assigned(FSlotList) and
     (FItemsize <> low(Py_ssize_t)) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_SIZE(Py_tp_itemsize, FItemsize);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddFlagsSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) and
     assigned(FSlotList) and
     (FFlags <> 0) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_UINT64(Py_tp_flags, FFlags);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddSlotsSlot(const aSlots: PPyType_Slot): boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) and
     assigned(FSlotList) and
     assigned(aSlots) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_DATA(Py_tp_slots, aSlots);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddSubslotsSlot(const aSlots: PPySlot): boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) and
     assigned(FSlotList) and
     assigned(aSlots) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_DATA(Py_slot_subslots, aSlots);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyHeapTypeSlotManager.AddReprSlot(const aFunc: tp_reprfunc): boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(aFunc) then
    begin
      TempSlot := TPySlot.Create;
      {$IFDEF FPC}
      TempSlot.Set_FUNC(Py_tp_repr, _Py_funcptr_t(aFunc));
      {$ELSE}
      TempSlot.Set_FUNC(Py_tp_repr, @aFunc);
      {$ENDIF}

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

procedure TPyHeapTypeSlotManager.AddAllSlots;
begin
  AddNameSlot;
  AddDocStringsSlot;
  AddMetaclassSlot;
  AddModuleSlot;
  AddBasesSlot;
  AddMethodsSlot;
  AddMembersSlot;
  AddGetSetsSlot;
  AddTokenSlot;
  AddBasicsizeSlot;
  AddExtraBasicsizeSlot;
  AddItemsizeSlot;
  AddFlagsSlot;
end;

procedure TPyHeapTypeSlotManager.AddAllMethods;
begin
  //
end;

procedure TPyHeapTypeSlotManager.AddAllMembers;
begin
  //
end;

procedure TPyHeapTypeSlotManager.AddAllGetSets;
begin
  //
end;

procedure TPyHeapTypeSlotManager.Initialize;
begin
  AddAllMethods;
  AddAllMembers;
  AddAllGetSets;

  if not(HasSentinelMethod) then
    AddSentinelMethod;

  if not(HasSentinelMember) then
    AddSentinelMember;

  if not(HasSentinelGetSet) then
    AddSentinelGetSet;

  CreateMethodArray;
  CreateGetSetArray;
  CreateSlotArray;

  AddAllSlots;

  if not(HasSentinelSlot) then
    AddSentinelSlot;

  CreateSlotArray;
end;

end.
