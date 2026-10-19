unit uP4P.PyType_Spec;

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
  /// Class defining a type's behavior.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/type.html#c.PyType_Spec">See the article about PyType_Spec.</see></para>
  /// </remarks>
  TPyType_Spec = class(TInterfacedObject, IPyType_Spec)
    protected
      FTypeSpec   : PyType_Spec;
      FName       : AnsiString;
      FDocStrings : AnsiString;
      FToken      : pointer;
      FSlotList   : TList;
      FSlots      : PyType_SlotArray;
      FMethodList : TList;
      FMethods    : PyMethodDefArray;
      FMemberList : TList;
      FMembers    : PyMemberDefArray;
      FGetSetList : TList;
      FGetSets    : PyGetSetDefArray;

      function  GetName: AnsiString;
      function  GetDocStrings: AnsiString;
      function  GetBasicsize: integer;
      function  GetItemsize: integer;
      function  GetFlags: cardinal;
      function  GetHasSentinelSlot: boolean;
      function  GetHasSentinelMethod: boolean;
      function  GetHasSentinelMember: boolean;
      function  GetHasSentinelGetSet: boolean;
      function  GetSlots: PPyType_Slot;
      function  GetTypeSpec: PPyType_Spec;
      function  GetToken: pointer;

      procedure SetName(const aValue: AnsiString);
      procedure SetDocStrings(const aValue: AnsiString);
      procedure SetBasicsize(aValue: integer);
      procedure SetItemsize(aValue: integer);
      procedure SetFlags(aValue: cardinal);
      procedure SetToken(aValue: pointer);

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

      /// <summary>
      /// Add a generic slot.
      /// </summary>
      function  AddSlot(aSlot: integer; aPfunc: Pointer): boolean;
      /// <summary>
      /// Add a method.
      /// </summary>
      function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
      /// <summary>
      /// Add a member.
      /// </summary>
      function  AddMember(const aName, aDocStrings: string; aType, aFlags: integer; aOffset: Py_ssize_t): boolean;
      /// <summary>
      /// Add a getset.
      /// </summary>
      function  AddGetSet(const aName, aDocStrings: string; const aGet: getter; const aSet: setter; aClosure: pointer): boolean;

      /// <summary>
      /// Add a sentinel method slot.
      /// </summary>
      function  AddSentinelMethod: boolean;
      /// <summary>
      /// Add a sentinel member slot.
      /// </summary>
      function  AddSentinelMember: boolean;
      /// <summary>
      /// Add a sentinel getset slot.
      /// </summary>
      function  AddSentinelGetSet: boolean;
      /// <summary>
      /// Add a sentinel slot.
      /// </summary>
      function  AddSentinelSlot: boolean;

      /// <summary>
      /// Add a Py_tp_alloc slot.
      /// </summary>
      procedure AddAllocSlot(const aFunc: allocfunc);
      /// <summary>
      /// Add a Py_tp_call slot.
      /// </summary>
      procedure AddCallSlot(const aFunc: ternaryfunc);
      /// <summary>
      /// Add a Py_tp_clear slot.
      /// </summary>
      procedure AddClearSlot(const aFunc: inquiry);
      /// <summary>
      /// Add a Py_tp_dealloc slot.
      /// </summary>
      procedure AddDeallocSlot(const aFunc: destructor_);
      /// <summary>
      /// Add a Py_tp_del slot.
      /// </summary>
      procedure AddDelSlot(const aFunc: destructor_);
      /// <summary>
      /// Add a Py_tp_descr_get slot.
      /// </summary>
      procedure AddDescrGetSlot(const aFunc: descrgetfunc);
      /// <summary>
      /// Add a Py_tp_descr_set slot.
      /// </summary>
      procedure AddDescrSetSlot(const aFunc: descrsetfunc);
      /// <summary>
      /// Add a Py_tp_doc slot.
      /// </summary>
      procedure AddDocSlot;
      /// <summary>
      /// Add a Py_tp_finalize slot.
      /// </summary>
      procedure AddFinalizeSlot(const aFunc: destructor_);
      /// <summary>
      /// Add a Py_tp_free slot.
      /// </summary>
      procedure AddFreeSlot(const aFunc: freefunc);
      /// <summary>
      /// Add a Py_tp_getattr slot.
      /// </summary>
      procedure AddGetAttrSlot(const aFunc: getattrfunc);
      /// <summary>
      /// Add a Py_tp_getattro slot.
      /// </summary>
      procedure AddGetAttroSlot(const aFunc: getattrofunc);
      /// <summary>
      /// Add a Py_tp_getset slot.
      /// </summary>
      procedure AddGetSetsSlot;
      /// <summary>
      /// Add a Py_tp_hash slot.
      /// </summary>
      procedure AddHashSlot(const aFunc: hashfunc);
      /// <summary>
      /// Add a Py_tp_init slot.
      /// </summary>
      procedure AddInitSlot(const aFunc: initproc);
      /// <summary>
      /// Add a Py_tp_is_gc slot.
      /// </summary>
      procedure AddIsGCSlot(const aFunc: inquiry);
      /// <summary>
      /// Add a Py_tp_iter slot.
      /// </summary>
      procedure AddIterSlot(const aFunc: getiterfunc);
      /// <summary>
      /// Add a Py_tp_iternext slot.
      /// </summary>
      procedure AddIterNextSlot(const aFunc: iternextfunc);
      /// <summary>
      /// Add a Py_tp_members slot.
      /// </summary>
      procedure AddMembersSlot;
      /// <summary>
      /// Add a Py_tp_methods slot.
      /// </summary>
      procedure AddMethodsSlot;
      /// <summary>
      /// Add a Py_tp_new slot.
      /// </summary>
      procedure AddNewSlot(const aFunc: newfunc);
      /// <summary>
      /// Add a Py_tp_repr slot.
      /// </summary>
      procedure AddReprSlot(const aFunc: reprfunc);
      /// <summary>
      /// Add a Py_tp_richcompare slot.
      /// </summary>
      procedure AddRichCompareSlot(const aFunc: richcmpfunc);
      /// <summary>
      /// Add a Py_tp_setattr slot.
      /// </summary>
      procedure AddSetAttrSlot(const aFunc: setattrfunc);
      /// <summary>
      /// Add a Py_tp_setattro slot.
      /// </summary>
      procedure AddSetAttroSlot(const aFunc: setattrofunc);
      /// <summary>
      /// Add a Py_tp_slots slot.
      /// </summary>
      procedure AddSlotsSlot(const aSlots: PPyType_Slot);
      /// <summary>
      /// Add a Py_tp_str slot.
      /// </summary>
      procedure AddStrSlot(const aFunc: reprfunc);
      /// <summary>
      /// Add a Py_slot_subslots slot.
      /// </summary>
      procedure AddSubslotsSlot(const aSlots: PPySlot);
      /// <summary>
      /// Add a Py_tp_token slot.
      /// </summary>
      procedure AddTokenSlot;
      /// <summary>
      /// Add a Py_tp_traverse slot.
      /// </summary>
      procedure AddTraverseSlot(const aFunc: traverseproc);
      /// <summary>
      /// Add a Py_tp_vectorcall slot.
      /// </summary>
      procedure AddVectorcallSlot(const aFunc: vectorcallfunc);

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
      /// Create the methods and the slots with all the heap type information.
      /// </summary>
      procedure   Initialize; virtual;
      /// <summary>
      /// Name of the type, used to set PyTypeObject.tp_name.
      /// </summary>
      property Name_                   : AnsiString        read GetName              write SetName;
      /// <summary>
      /// <para>The docstring for this type object. This is exposed as the
      /// __doc__ attribute on the type and instances of the type.</para>
      /// </summary>
      property DocStrings              : AnsiString        read GetDocStrings        write SetDocStrings;
      /// <summary>
      /// <para>If positive, specifies the size of the instance in bytes. It is
      /// used to set PyTypeObject.tp_basicsize.</para>
      /// <para>If zero, specifies that tp_basicsize should be inherited.</para>
      /// <para>If negative, the absolute value specifies how much space
      /// instances of the class need in addition to the superclass.</para>
      /// <para>Use TPyObject.GetTypeData to get a pointer to subclass-specific
      /// memory reserved this way.</para>
      /// <para>For negative basicsize, Python will insert padding when needed
      /// to meet tp_basicsize's alignment requirements.</para>
      /// </summary>
      property Basicsize               : integer           read GetBasicsize         write SetBasicsize;
      /// <summary>
      /// Size of one element of a variable-size type, in bytes. Used to set
      /// PyTypeObject.tp_itemsize. See tp_itemsize documentation for caveats.
      /// </summary>
      property Itemsize                : integer           read GetItemsize          write SetItemsize;
      /// <summary>
      /// <para>Type flags, used to set PyTypeObject.tp_flags.</para>
      /// <para>Use the Py_TPFLAGS_* constants.</para>
      /// </summary>
      property Flags                   : cardinal          read GetFlags             write SetFlags;
      /// <summary>
      /// Return True if the last slot has a {0, nil} value.
      /// </summary>
      property HasSentinelSlot         : boolean           read GetHasSentinelSlot;
      /// <summary>
      /// Return True if the last method in the list is a sentinel method.
      /// </summary>
      property HasSentinelMethod       : boolean           read GetHasSentinelMethod;
      /// <summary>
      /// Return True if the last method in the list is a sentinel member.
      /// </summary>
      property HasSentinelMember       : boolean           read GetHasSentinelMember;
      /// <summary>
      /// Return True if the last method in the list is a sentinel getsetter.
      /// </summary>
      property HasSentinelGetSet       : boolean           read GetHasSentinelGetSet;
      /// <summary>
      /// Return a pointer to the first slot.
      /// </summary>
      property Slots                   : PPyType_Slot      read GetSlots;
      /// <summary>
      /// Return a pointer to the PyType_Spec record.
      /// </summary>
      property TypeSpec                : PPyType_Spec      read GetTypeSpec;
      /// <summary>
      /// <para>The associated token records a static memory layout ID for a
      /// class.</para>
      /// <para>Useg the special value Py_TP_USE_SPEC to set the token to the
      /// class's PyType_Spec.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      property  Token                  : pointer           read GetToken             write SetToken;
  end;

implementation

uses
  uP4P.PyMethodDef, uP4P.PyType_Slot, uP4P.Engine, uP4P.PyMemberDef,
  uP4P.PyGetSetDef;

constructor TPyType_Spec.Create;
begin
  inherited Create;

  FName                  := '';
  FSlotList              := nil;
  FSlots                 := nil;
  FMethodList            := nil;
  FMethods               := nil;
  FMemberList            := nil;
  FMembers               := nil;
  FGetSetList            := nil;
  FGetSets               := nil;
  FToken                 := Py_TP_USE_SPEC;

  FillChar(FTypeSpec, SizeOf(FTypeSpec), 0);
end;

destructor TPyType_Spec.Destroy;
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

procedure TPyType_Spec.AfterConstruction;
begin
  inherited AfterConstruction;

  FSlotList   := TList.Create;
  FMethodList := TList.Create;
  FMemberList := TList.Create;
  FGetSetList := TList.Create;
end;

function TPyType_Spec.GetName: AnsiString;
begin
  Result := FName;
end;

function TPyType_Spec.GetDocStrings: AnsiString;
begin
  Result := FDocStrings;
end;

function TPyType_Spec.GetBasicsize: integer;
begin
  Result := FTypeSpec.basicsize;
end;

function TPyType_Spec.GetItemsize: integer;
begin
  Result := FTypeSpec.itemsize;
end;

function TPyType_Spec.GetFlags: cardinal;
begin
  Result := FTypeSpec.flags;
end;

function TPyType_Spec.GetHasSentinelSlot: boolean;
begin
  Result := assigned(FSlotList) and
            (FSlotList.Count > 0) and
            TPyType_Slot(FSlotList[FSlotList.Count - 1]).IsSentinel;
end;

function TPyType_Spec.GetHasSentinelMethod: boolean;
begin
  Result := assigned(FMethodList) and
            (FMethodList.Count > 0) and
            TPyMethodDef(FMethodList[FMethodList.Count - 1]).IsSentinel;
end;

function TPyType_Spec.GetHasSentinelMember: boolean;
begin
  Result := assigned(FMemberList) and
            (FMemberList.Count > 0) and
            TPyMemberDef(FMemberList[FMemberList.Count - 1]).IsSentinel;
end;

function TPyType_Spec.GetHasSentinelGetSet: boolean;
begin
  Result := assigned(FGetSetList) and
            (FGetSetList.Count > 0) and
            TPyGetSetDef(FGetSetList[FGetSetList.Count - 1]).IsSentinel;
end;

function TPyType_Spec.GetSlots: PPyType_Slot;
begin
  if (Length(FSlots) > 0) then
    Result := @FSlots[0]
   else
    Result := nil;
end;

function TPyType_Spec.GetTypeSpec: PPyType_Spec;
begin
  Result := @FTypeSpec;
end;

function TPyType_Spec.GetToken: pointer;
begin
  Result := FToken;
end;

procedure TPyType_Spec.SetName(const aValue: AnsiString);
begin
  FName          := aValue;
  FTypeSpec.name := PAnsiChar(FName);
end;

procedure TPyType_Spec.SetDocStrings(const aValue: AnsiString);
begin
  FDocStrings := aValue;
end;

procedure TPyType_Spec.SetBasicsize(aValue: integer);
begin
  FTypeSpec.basicsize := aValue;
end;

procedure TPyType_Spec.SetItemsize(aValue: integer);
begin
  FTypeSpec.itemsize := aValue;
end;

procedure TPyType_Spec.SetFlags(aValue: cardinal);
begin
  FTypeSpec.flags := aValue;
end;

procedure TPyType_Spec.SetToken(aValue: pointer);
begin
  FToken := aValue;
end;

procedure TPyType_Spec.CreateSlotArray;
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
          FSlots[i] := TPyType_Slot(FSlotList[i]).Slot;
          inc(i);
        end;
    end;
end;

procedure TPyType_Spec.CreateMethodArray;
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

procedure TPyType_Spec.CreateMemberArray;
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

procedure TPyType_Spec.CreateGetSetArray;
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

procedure TPyType_Spec.DestroySlotList;
var
  i : integer;
begin
  if assigned(FSlotList) then
    try
      i := pred(FSlotList.Count);
      while (i >= 0) do
        begin
          TPyType_Slot(FSlotList[i]).Free;
          FSlotList[i] := nil;
          dec(i);
        end;
    finally
      FreeAndNil(FSlotList);
    end;
end;

procedure TPyType_Spec.DestroySlots;
begin
  if assigned(FSlots) then
    begin
      SetLength(FSlots, 0);
      FSlots := nil;
    end;
end;

procedure TPyType_Spec.DestroyMethodList;
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

procedure TPyType_Spec.DestroyMethods;
begin
  if assigned(FMethods) then
    begin
      SetLength(FMethods, 0);
      FMethods := nil;
    end;
end;

procedure TPyType_Spec.DestroyMemberList;
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

procedure TPyType_Spec.DestroyMembers;
begin
  if assigned(FMembers) then
    begin
      SetLength(FMembers, 0);
      FMembers := nil;
    end;
end;

procedure TPyType_Spec.DestroyGetSetList;
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

procedure TPyType_Spec.DestroyGetSets;
begin
  if assigned(FGetSets) then
    begin
      SetLength(FGetSets, 0);
      FGetSets := nil;
    end;
end;

function TPyType_Spec.AddSlot(aSlot: integer; aPfunc: Pointer): boolean;
var
  TempSlot : TPyType_Slot;
begin
  Result := False;

  if assigned(FSlotList) then
    begin
      TempSlot := TPyType_Slot.Create(aSlot, aPfunc);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyType_Spec.AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
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

function TPyType_Spec.AddMember(const aName, aDocStrings: string; aType, aFlags: integer; aOffset: Py_ssize_t): boolean;
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

function TPyType_Spec.AddGetSet(const aName, aDocStrings: string; const aGet: getter; const aSet: setter; aClosure: pointer): boolean;
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

function TPyType_Spec.AddSentinelMethod: boolean;
begin
  Result := AddMethod('', '', nil, 0);
end;

function TPyType_Spec.AddSentinelMember: boolean;
begin
  Result := AddMember('', '', 0, 0, 0);
end;

function TPyType_Spec.AddSentinelGetSet: boolean;
begin
  Result := AddGetSet('', '', nil, nil, nil);
end;

function TPyType_Spec.AddSentinelSlot: boolean;
begin
  Result := AddSlot(0, nil);
end;

procedure TPyType_Spec.AddAllocSlot(const aFunc: allocfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_alloc, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddCallSlot(const aFunc: ternaryfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_call, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddClearSlot(const aFunc: inquiry);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_clear, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddDeallocSlot(const aFunc: destructor_);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_dealloc, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddDelSlot(const aFunc: destructor_);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_del, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddDescrGetSlot(const aFunc: descrgetfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_descr_get, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddDescrSetSlot(const aFunc: descrsetfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_descr_set, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddDocSlot;
begin
  if (length(FDocStrings) > 0) then
    AddSlot(Py_tp_doc, PAnsiChar(FDocStrings));
end;

procedure TPyType_Spec.AddFinalizeSlot(const aFunc: destructor_);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_finalize, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddFreeSlot(const aFunc: freefunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_free, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddGetAttrSlot(const aFunc: getattrfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_getattr, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddGetAttroSlot(const aFunc: getattrofunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_getattro, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddGetSetsSlot;
begin
  if assigned(FGetSets) and (length(FGetSets) > 1) then
    AddSlot(Py_tp_getset, @FGetSets[0]);
end;

procedure TPyType_Spec.AddHashSlot(const aFunc: hashfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_hash, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddInitSlot(const aFunc: initproc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_init, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddIsGCSlot(const aFunc: inquiry);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_is_gc, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddIterSlot(const aFunc: getiterfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_iter, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddIterNextSlot(const aFunc: iternextfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_iternext, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddMembersSlot;
begin
  if assigned(FMembers) and (length(FMembers) > 1) then
    AddSlot(Py_tp_members, @FMembers[0]);
end;

procedure TPyType_Spec.AddMethodsSlot;
begin
  if assigned(FMethods) and (length(FMethods) > 1) then
    AddSlot(Py_tp_methods, @FMethods[0]);
end;

procedure TPyType_Spec.AddNewSlot(const aFunc: newfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_new, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddReprSlot(const aFunc: reprfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_repr, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddRichCompareSlot(const aFunc: richcmpfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_richcompare, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddSetAttrSlot(const aFunc: setattrfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_setattr, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddSetAttroSlot(const aFunc: setattrofunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_setattro, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddSlotsSlot(const aSlots: PPyType_Slot);
begin
  if assigned(aSlots) then
    AddSlot(Py_tp_slots, aSlots);
end;

procedure TPyType_Spec.AddStrSlot(const aFunc: reprfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_str, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddSubslotsSlot(const aSlots: PPySlot);
begin
  if assigned(aSlots) then
    AddSlot(Py_slot_subslots, aSlots);
end;

procedure TPyType_Spec.AddTokenSlot;
begin
  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 14, 0) then
    AddSlot(Py_tp_token, FToken);
end;

procedure TPyType_Spec.AddTraverseSlot(const aFunc: traverseproc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_traverse, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddVectorcallSlot(const aFunc: vectorcallfunc);
begin
  if assigned(aFunc) then
    AddSlot(Py_tp_vectorcall, {$IFNDEF FPC}@{$ENDIF}aFunc);
end;

procedure TPyType_Spec.AddAllSlots;
begin
  AddDocSlot;
  AddMethodsSlot;
  AddMembersSlot;
  AddGetSetsSlot;
  AddTokenSlot;
end;

procedure TPyType_Spec.AddAllMethods;
begin
  //
end;

procedure TPyType_Spec.AddAllMembers;
begin
  //
end;

procedure TPyType_Spec.AddAllGetSets;
begin
  //
end;

procedure TPyType_Spec.Initialize;
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
  CreateMemberArray;
  CreateGetSetArray;

  AddAllSlots;

  if not(HasSentinelSlot) then
    AddSentinelSlot;

  CreateSlotArray;

  FTypeSpec.slots := Slots;
end;

end.
