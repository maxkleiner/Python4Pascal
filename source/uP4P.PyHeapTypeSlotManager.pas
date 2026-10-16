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
  TPyHeapTypeSlotManager = class(TInterfacedObject, IPyHeapTypeSlotManager)
    protected
      FName                  : AnsiString;
      FDocStrings            : AnsiString;
      FSlotList              : TList;
      FSlots                 : PySlotArray;
      FMethodList            : TList;
      FMethods               : PyMethodDefArray;
      FToken                 : pointer;
      FMetaclass             : PPyTypeObject;
      FModule                : IPyObject;
      FBases                 : IPyObject;

      function  GetName: AnsiString;
      function  GetDocStrings: AnsiString;
      function  GetToken: pointer;
      function  GetHasSentinelSlot: boolean;
      function  GetHasSentinelMethod: boolean;
      function  GetSlots: PPySlot;
      function  GetMetaclass: PPyTypeObject;
      function  GetModule: IPyObject;
      function  GetBases: IPyObject;

      procedure SetName(const aValue: AnsiString);
      procedure SetDocStrings(const aValue: AnsiString);
      procedure SetToken(aValue: pointer);
      procedure SetMetaclass(aValue: PPyTypeObject);
      procedure SetModule(const aValue: IPyObject);
      procedure SetBases(const aValue: IPyObject);

      procedure DestroySlotList;
      procedure DestroySlots;
      procedure DestroyMethodList;
      procedure DestroyMethods;

      procedure CreateSlotArray;
      procedure CreateMethodArray;

      function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
      function  AddSentinelMethod: boolean;
      function  AddSentinelSlot: boolean;
      function  AddNameSlot: boolean;
      function  AddDocStringsSlot: boolean;
      function  AddTokenSlot: boolean;
      function  AddMethodsSlot: boolean;
      function  AddMetaclassSlot: boolean;
      function  AddModuleSlot: boolean;
      function  AddBasesSlot: boolean;

      /// <summary>
      /// Override this procedure to add your custom slots.
      /// </summary>
      procedure AddAllSlots; virtual;
      /// <summary>
      /// Override this procedure to add your custom methods.
      /// </summary>
      procedure AddAllMethods; virtual;

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
  end;

implementation

uses
  uP4P.PyMethodDef, uP4P.Engine, uP4P.PyObject, uP4P.PySlot;

constructor TPyHeapTypeSlotManager.Create;
begin
  inherited Create;

  FName                  := '';
  FDocStrings            := '';
  FSlotList              := nil;
  FSlots                 := nil;
  FMethodList            := nil;
  FMethods               := nil;
  FToken                 := nil;
  FMetaclass             := nil;
  FModule                := nil;
  FBases                 := nil;
end;

destructor TPyHeapTypeSlotManager.Destroy;
begin
  try
    DestroySlotList;
    DestroySlots;
    DestroyMethodList;
    DestroyMethods;
  finally
    inherited Destroy;
  end;
end;

procedure TPyHeapTypeSlotManager.AfterConstruction;
begin
  inherited AfterConstruction;

  FSlotList   := TList.Create;
  FMethodList := TList.Create;
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

function TPyHeapTypeSlotManager.AddSentinelMethod: boolean;
begin
  Result := AddMethod('', '', nil, 0);
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

  if assigned(FSlotList) and (length(FName) > 0) then
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

  if assigned(FSlotList) and assigned(FMethods) and (length(FMethods) > 0) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_STATIC_DATA(Py_tp_methods, @FMethods[0]);

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

procedure TPyHeapTypeSlotManager.AddAllSlots;
begin
  AddNameSlot;
  AddDocStringsSlot;
  AddMetaclassSlot;
  AddModuleSlot;
  AddBasesSlot;
  AddTokenSlot;
end;

procedure TPyHeapTypeSlotManager.AddAllMethods;
begin
  //
end;

procedure TPyHeapTypeSlotManager.Initialize;
begin
  AddAllSlots;
  AddAllMethods;

  if not(HasSentinelMethod) then
    AddSentinelMethod;

  CreateMethodArray;
  AddMethodsSlot;

  if not(HasSentinelSlot) then
    AddSentinelSlot;

  CreateSlotArray;
end;

end.
