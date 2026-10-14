unit uP4P.PySlotManager;

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
  uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PySlot;

type
  /// <summary>
  /// <para>TPySlotManager is the base class that it's used to store the
  /// information about the module and to manage the method and slot
  /// lists.</para>
  /// </summary>
  TPySlotManager = class(TInterfacedObject, IPySlotManager)
    protected
      FName                  : AnsiString;
      FDocStrings            : AnsiString;
      FSlotList              : TList;
      FSlots                 : PySlotArray;
      FMethodList            : TList;
      FMethods               : PyMethodDefArray;
      FABIInfo               : PyAbiInfo;
      FExecFunction          : exec_modulefunc;
      FMultIntprSupport      : TMultIntprSupport;
      FGILUsed               : boolean;
      FToken                 : pointer;
      FMetaclass             : PPyTypeObject;
      FModule                : IPyObject;
      FBases                 : IPyObject;

      function  GetName: AnsiString;
      function  GetDocStrings: AnsiString;
      function  GetExecFunction: exec_modulefunc;
      function  GetMultIntprSupport: TMultIntprSupport;
      function  GetGILUsed: boolean;
      function  GetToken: pointer;
      function  GetHasMethodsSlot: boolean;
      function  GetHasSentinelSlot: boolean;
      function  GetHasSentinelMethod: boolean;
      function  GetSlots: PPySlot;
      function  GetABIInfo: PPyAbiInfo;
      function  GetMetaclass: PPyTypeObject;
      function  GetModule: IPyObject;
      function  GetBases: IPyObject;

      procedure SetName(const aValue: AnsiString);
      procedure SetDocStrings(const aValue: AnsiString);
      procedure SetExecFunction(aValue: exec_modulefunc);
      procedure SetMultIntprSupport(aValue: TMultIntprSupport);
      procedure SetGILUsed(aValue: boolean);
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
      function  AddNameSlot: boolean;
      function  AddDocStringsSlot: boolean;
      function  AddABIInfoSlot: boolean;
      function  AddExecSlot: boolean;
      function  AddMultipleInterpretersSlot: boolean;
      function  AddGILSlot: boolean;
      function  AddTokenSlot: boolean;
      function  AddSentinelSlot: boolean;
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
      /// Create the slots with the methods and all the module information.
      /// </summary>
      procedure   BuildMethodsAndSlots;
      /// <summary>
      /// Name of the new module or data type.
      /// </summary>
      property  Name_                  : AnsiString         read GetName                 write SetName;
      /// <summary>
      /// The docstring of the new module or data type.
      /// </summary>
      property  DocStrings             : AnsiString         read GetDocStrings           write SetDocStrings;
      /// <summary>
      /// Return True if the slot list has a Py_mod_methods slot.
      /// </summary>
      property  HasMethodsSlot         : boolean            read GetHasMethodsSlot;
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
      /// Return a pointer to the ABI info record.
      /// </summary>
      property  ABIInfo                : PPyAbiInfo         read GetABIInfo;
      /// <summary>
      /// Function that will execute, or initialize, the module.
      /// </summary>
      property  ExecFunction           : exec_modulefunc    read GetExecFunction         write SetExecFunction;
      /// <summary>
      /// This slot determines whether or not importing this module in a
      /// subinterpreter will fail.
      /// If it's not specified, the import machinery defaults to miSupported.
      /// </summary>
      property  MultIntprSupport       : TMultIntprSupport  read GetMultIntprSupport     write SetMultIntprSupport;
      /// <summary>
      /// The module depends on the presence of the global interpreter lock
      /// (GIL) or it's safe to run without an active GIL.
      /// </summary>
      property  GILUsed                : boolean            read GetGILUsed              write SetGILUsed;
      /// <summary>
      /// The associated token is a pointer-sized value intended to identify of
      /// the module state's memory layout.
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
  uP4P.PyMethodDef, uP4P.Py_mod, uP4P.PyABIInfo, uP4P.Engine, uP4P.PyObject;

constructor TPySlotManager.Create;
begin
  inherited Create;

  FName                  := '';
  FDocStrings            := '';
  FSlotList              := nil;
  FSlots                 := nil;
  FMethodList            := nil;
  FMethods               := nil;
  FExecFunction          := nil;
  FMultIntprSupport      := piUnknown;
  FGILUsed               := True;
  FToken                 := nil;
  FMetaclass             := nil;
  FModule                := nil;
  FBases                 := nil;

  TPyABIInfo.VAR_(FABIInfo);
end;

destructor TPySlotManager.Destroy;
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

procedure TPySlotManager.AfterConstruction;
begin
  inherited AfterConstruction;

  FSlotList   := TList.Create;
  FMethodList := TList.Create;
end;

procedure TPySlotManager.DestroySlotList;
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

procedure TPySlotManager.DestroySlots;
begin
  if assigned(FSlots) then
    begin
      SetLength(FSlots, 0);
      FSlots := nil;
    end;
end;

procedure TPySlotManager.DestroyMethodList;
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

procedure TPySlotManager.DestroyMethods;
begin
  if assigned(FMethods) then
    begin
      SetLength(FMethods, 0);
      FMethods := nil;
    end;
end;

function TPySlotManager.AddSentinelMethod: boolean;
begin
  Result := AddMethod('', '', nil, 0);
end;

procedure TPySlotManager.AddAllSlots;
begin
  //
end;

procedure TPySlotManager.AddAllMethods;
begin
  //
end;

function TPySlotManager.AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
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

function TPySlotManager.AddNameSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and (length(FName) > 0) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_STATIC_STRING(TPy_mod.name, FName);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPySlotManager.AddDocStringsSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and (length(FDocStrings) > 0) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_STRING(TPy_mod.doc, FDocStrings);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPySlotManager.AddABIInfoSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_DATA(TPy_mod.abi, ABIInfo);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPySlotManager.AddExecSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FExecFunction) then
    begin
      TempSlot := TPySlot.Create;
      {$IFDEF FPC}
      TempSlot.Set_FUNC(TPy_mod.exec, _Py_funcptr_t(FExecFunction));
      {$ELSE}
      TempSlot.Set_FUNC(TPy_mod.exec, @FExecFunction);
      {$ENDIF}

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPySlotManager.AddMultipleInterpretersSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and (FMultIntprSupport <> piUnknown) then
    begin
      TempSlot := TPySlot.Create;

      case FMultIntprSupport of
        miUnsupported  : TempSlot.Set_DATA(TPy_mod.multiple_interpreters, Py_MOD_MULTIPLE_INTERPRETERS_NOT_SUPPORTED);
        piGilSupported : TempSlot.Set_DATA(TPy_mod.multiple_interpreters, Py_MOD_PER_INTERPRETER_GIL_SUPPORTED);
        miSupported    : TempSlot.Set_DATA(TPy_mod.multiple_interpreters, Py_MOD_MULTIPLE_INTERPRETERS_SUPPORTED);
      end;

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPySlotManager.AddGILSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) then
    begin
      TempSlot := TPySlot.Create;

      if FGILUsed then
        TempSlot.Set_DATA(TPy_mod.gil, Py_MOD_GIL_USED)
       else
        TempSlot.Set_DATA(TPy_mod.gil, Py_MOD_GIL_NOT_USED);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPySlotManager.AddTokenSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FToken) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_DATA(TPy_mod.token, FToken);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPySlotManager.GetName: AnsiString;
begin
  Result := FName;
end;

function TPySlotManager.GetDocStrings: AnsiString;
begin
  Result := FDocStrings;
end;

function TPySlotManager.GetHasMethodsSlot: boolean;
var
  i : integer;
begin
  Result := False;

  i := 0;
  while (i < FSlotList.Count) do
    if TPySlot(FSlotList[i]).IsMethods then
      begin
        Result := True;
        exit;
      end
     else
      inc(i);
end;

function TPySlotManager.GetHasSentinelSlot: boolean;
begin
  Result := assigned(FSlotList) and
            (FSlotList.Count > 0) and
            TPySlot(FSlotList[FSlotList.Count - 1]).IsEnd;
end;

function TPySlotManager.GetHasSentinelMethod: boolean;
begin
  Result := assigned(FMethodList) and
            (FMethodList.Count > 0) and
            TPyMethodDef(FMethodList[FMethodList.Count - 1]).IsSentinel;
end;

function TPySlotManager.GetSlots: PPySlot;
begin
  if (Length(FSlots) > 0) then
    Result := @FSlots[0]
   else
    Result := nil;
end;

function TPySlotManager.GetABIInfo: PPyAbiInfo;
begin
  Result := @FABIInfo;
end;

function TPySlotManager.GetMetaclass: PPyTypeObject;
begin
  Result := FMetaclass;
end;

function TPySlotManager.GetModule: IPyObject;
begin
  Result := FModule;
end;

function TPySlotManager.GetBases: IPyObject;
begin
  Result := FBases;
end;

function TPySlotManager.GetExecFunction: exec_modulefunc;
begin
  Result := FExecFunction;
end;

function TPySlotManager.GetMultIntprSupport: TMultIntprSupport;
begin
  Result := FMultIntprSupport;
end;

function TPySlotManager.GetGILUsed: boolean;
begin
  Result := FGILUsed;
end;

function TPySlotManager.GetToken: pointer;
begin
  Result := FToken;
end;

procedure TPySlotManager.SetName(const aValue: AnsiString);
begin
  FName := aValue;
end;

procedure TPySlotManager.SetDocStrings(const aValue: AnsiString);
begin
  FDocStrings := aValue;
end;

procedure TPySlotManager.SetExecFunction(aValue: exec_modulefunc);
begin
  FExecFunction := aValue;
end;

procedure TPySlotManager.SetMultIntprSupport(aValue: TMultIntprSupport);
begin
  FMultIntprSupport := aValue;
end;

procedure TPySlotManager.SetGILUsed(aValue: boolean);
begin
  FGILUsed := aValue;
end;

procedure TPySlotManager.SetToken(aValue: pointer);
begin
  FToken := aValue;
end;

procedure TPySlotManager.SetMetaclass(aValue: PPyTypeObject);
begin
  FMetaclass := aValue;
end;

procedure TPySlotManager.SetModule(const aValue: IPyObject);
begin
  FModule := aValue;
end;

procedure TPySlotManager.SetBases(const aValue: IPyObject);
begin
  FBases := aValue;
end;

procedure TPySlotManager.BuildMethodsAndSlots;
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

function TPySlotManager.AddMethodsSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FMethods) and (length(FMethods) > 0) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_STATIC_DATA(TPy_mod.methods, @FMethods[0]);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPySlotManager.AddMetaclassSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FMetaclass) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_DATA(Py_tp_metaclass, FMetaclass);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPySlotManager.AddModuleSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and TPyObject.IsInitialized(FModule) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_DATA(Py_tp_module, FModule.PyObject);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPySlotManager.AddBasesSlot: boolean;
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

function TPySlotManager.AddSentinelSlot: boolean;
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

procedure TPySlotManager.CreateSlotArray;
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

procedure TPySlotManager.CreateMethodArray;
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

end.
