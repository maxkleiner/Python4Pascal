unit uP4P.CustomPyModule;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// <para>TCustomPyModule is the base class for all the modules created with
  /// the Python API methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/module.html#module-objects">See the article about Module Objects.</see></para>
  /// </remarks>
  TCustomPyModule = class
    protected
      FModule                : IPyObject;
      FModuleDef             : PyModuleDef;
      FName                  : AnsiString;
      FDocStrings            : AnsiString;
      FSlotList              : TList;
      FSlots                 : array of PyModuleDef_Slot;
      FMethodList            : TList;
      FMethods               : array of PyMethodDef;
      FIsExtension           : boolean;
      FOnAfterInitialization : TNotifyEvent;
      FMultIntprSupport      : TMultIntprSupport;
      FInitializedModuleDef  : boolean;

      function  GetHasSentinelSlot: boolean;
      function  GetHasSentinelMethod: boolean;

      procedure DestroySlotList;
      procedure DestroySlots;
      procedure DestroyMethodList;
      procedure DestroyMethods;
      procedure CreateSlotArray;
      procedure CreateMethodArray;
      function  InitializeModuleDef(const aName, aDocStrings: string) : boolean;
      function  AddSentinelMethod: boolean;
      function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
      function  AddSentinelSlot: boolean;
      function  AddSlot(aSlot: integer; aValue: Pointer): boolean;
      function  AddCreateSlot(const aCreateFunction: create_modulefunc): boolean;
      function  AddExecSlot(const aExecFunction: exec_modulefunc): boolean;
      function  AddMultipleInterpretersSlot(aSupport: TMultIntprSupport): boolean;
      function  AddGILSlot(aGILUsed: boolean): boolean;
      /// <summary>
      /// Override this procedure to add your custom slots.
      /// </summary>
      procedure AddAllSlots; virtual;
      /// <summary>
      /// Override this procedure to add your custom methods.
      /// </summary>
      procedure AddAllMethods; virtual;
      /// <summary>
      /// Return True if the last slot in the list is a sentinel slot.
      /// </summary>
      property  HasSentinelSlot        : boolean        read GetHasSentinelSlot;
      /// <summary>
      /// Return True if the last method in the list is a sentinel method.
      /// </summary>
      property  HasSentinelMethod      : boolean        read GetHasSentinelMethod;

    public
      constructor Create(const aName: string; const aDocStrings: string = ''; aIsExtension : boolean = False);
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      procedure   BeforeDestruction; override;
      /// <summary>
      /// <para>Internal function used to trigger the OnAfterInitialization
      /// event. Don't use!</para>
      /// </summary>
      function    doOnAfterInitialization: integer;
      /// <summary>
      /// <para>Test if this module is the same as the "other" module.</para>
      /// </summary>
      function    SameAs(const other: PPyObject): boolean;
      /// <summary>
      /// <para>Create the module and all the slots and methods.</para>
      /// </summary>
      function    Initialize: boolean;
      /// <summary>
      /// <para>Module name.</para>
      /// </summary>
      property Name_                         : AnsiString          read FName;
      /// <summary>
      /// <para>PyObject instance of this module.</para>
      /// </summary>
      property Module                        : IPyObject           read FModule;
      /// <summary>
      /// Multiple interpreter support in a module.
      /// </summary>
      property MultIntprSupport              : TMultIntprSupport   read FMultIntprSupport         write FMultIntprSupport;
      /// <summary>
      /// ModuleDef was initialized correctly.
      /// </summary>
      property InitializedModuleDef          : boolean             read FInitializedModuleDef;
      /// <summary>
      /// <para>Event triggered after the module has been initialized.</para>
      /// </summary>
      property OnAfterInitialization         : TNotifyEvent        read FOnAfterInitialization    write FOnAfterInitialization;
  end;

  /// <summary>
  /// <para>TCustomPyModuleDefSlot is used to store the information about module
  /// slots.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/module.html#module-slots">See the article about Module slots.</see></para>
  /// </remarks>
  TCustomPyModuleDefSlot = class
    protected
      FSlot : PyModuleDef_Slot;

      function  GetIsSentinel: boolean;

    public
      constructor Create(aSlot: integer; aValue: Pointer);
      /// <summary>
      /// Module slot record.
      /// </summary>
      property Slot        : PyModuleDef_Slot  read FSlot;
      /// <summary>
      /// Return True if this is the last slot in the list. The sentinel
      /// slot has 0 as ID and nil as value.
      /// </summary>
      property IsSentinel  : boolean           read GetIsSentinel;
  end;

  /// <summary>
  /// <para>TCustomPyMethodDef is used to store the information about module
  /// methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyMethodDef">See the article about PyMethodDef.</see></para>
  /// </remarks>
  TCustomPyMethodDef = class
    protected
      FMethod      : PyMethodDef;
      FName        : AnsiString;
      FDocStrings  : AnsiString;

      function  GetIsSentinel: boolean;

    public
      constructor Create(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer);
      /// <summary>
      /// Record used to describe a method of an extension type.
      /// </summary>
      property Method      : PyMethodDef       read FMethod;
      /// <summary>
      /// Return True if this is the last method definition in the slot list.
      /// The sentinel method definition has a 0 as ml_flags and a nil value in
      /// ml_meth and ml_doc.
      /// </summary>
      property IsSentinel  : boolean           read GetIsSentinel;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.Engine, uP4P.PyModuleSpecHelper, uP4P.PyModule,
  uP4P.PyImport, uP4P.PyDict, uP4P.PyModuleDef, uP4P.Py_mod;

function Exec_Module(module: PPyObject): integer; cdecl;
var
  TempModule : TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(module, TempModule) then
    TempModule.doOnAfterInitialization;

  Result := 0;
end;

constructor TCustomPyModuleDefSlot.Create(aSlot: integer; aValue: Pointer);
begin
  inherited Create;

  FSlot.slot  := aSlot;
  FSlot.value := aValue;
end;

function TCustomPyModuleDefSlot.GetIsSentinel: boolean;
begin
  Result := (FSlot.slot = 0) and (FSlot.value = nil);
end;

constructor TCustomPyMethodDef.Create(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer);
begin
  inherited Create;

  FName       := StringToPyUTF8(aName);
  FDocStrings := StringToPyUTF8(aDocStrings);

  if (length(aName) > 0) then
    FMethod.ml_name := PAnsiChar(FName)
   else
    FMethod.ml_name := nil;

  FMethod.ml_meth  := aMethod;
  FMethod.ml_flags := aFlags;

  if (length(aDocStrings) > 0) then
    FMethod.ml_doc := PAnsiChar(FDocStrings)
   else
    FMethod.ml_doc := nil;
end;

function TCustomPyMethodDef.GetIsSentinel: boolean;
begin
  Result := (FMethod.ml_name = nil) and not(assigned(FMethod.ml_meth)) and (FMethod.ml_flags = 0) and (FMethod.ml_doc = nil);
end;

constructor TCustomPyModule.Create(const aName, aDocStrings: string; aIsExtension : boolean);
begin
  inherited Create;

  FModule                := nil;
  FName                  := StringToPyUTF8(aName);
  FDocStrings            := StringToPyUTF8(aDocStrings);
  FSlotList              := nil;
  FSlots                 := nil;
  FMethodList            := nil;
  FMethods               := nil;
  FOnAfterInitialization := nil;
  FMultIntprSupport      := miSupported;
  FIsExtension           := aIsExtension;
  FInitializedModuleDef  := InitializeModuleDef(aName, aDocStrings);
end;

destructor TCustomPyModule.Destroy;
begin
  try
    FModule := nil;

    DestroySlotList;
    DestroySlots;
    DestroyMethodList;
    DestroyMethods;
  finally
    inherited Destroy;
  end;
end;

procedure TCustomPyModule.AfterConstruction;
begin
  inherited AfterConstruction;

  FSlotList   := TList.Create;
  FMethodList := TList.Create;

  if FInitializedModuleDef and (GlobalP4PEngine <> nil) then
    GlobalP4PEngine.AddModule(self);
end;

procedure TCustomPyModule.BeforeDestruction;
begin
  if FInitializedModuleDef and (GlobalP4PEngine <> nil) then
    GlobalP4PEngine.RemoveModule(self);

  inherited BeforeDestruction;
end;

function TCustomPyModule.InitializeModuleDef(const aName, aDocStrings: string) : boolean;
begin
  Result := False;

  try
    FillChar(FModuleDef, SizeOf(FModuleDef), 0);

    if assigned(TPyModuleDef.Init(FModuleDef)) then
      begin
        if (length(aName) > 0) then
          FModuleDef.m_name := PAnsiChar(FName)
         else
          FModuleDef.m_name := nil;

        if (length(aDocStrings) > 0) then
          FModuleDef.m_doc := PAnsiChar(FDocStrings)
         else
          FModuleDef.m_doc := nil;

        Result := True;
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TCustomPyModule.InitializeModuleDef', e) then raise;
  end;
end;

function TCustomPyModule.AddSentinelMethod: boolean;
begin
  Result := AddMethod('', '', nil, 0);
end;

function TCustomPyModule.AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
var
  TempMethod : TCustomPyMethodDef;
begin
  Result := False;

  if assigned(FMethodList) then
    begin
      TempMethod := TCustomPyMethodDef.Create(aName, aDocStrings, aMethod, aFlags);
      Result     := (FMethodList.Add(TempMethod) >= 0);
    end;
end;

function TCustomPyModule.AddSentinelSlot: boolean;
begin
  Result := AddSlot(0, nil);
end;

function TCustomPyModule.AddSlot(aSlot: integer; aValue: Pointer): boolean;
var
  TempSlot : TCustomPyModuleDefSlot;
begin
  Result := False;

  if assigned(FSlotList) then
    begin
      TempSlot := TCustomPyModuleDefSlot.Create(aSlot, aValue);
      Result   := (FSlotList.Add(TempSlot) >= 0);
    end;
end;

function TCustomPyModule.AddCreateSlot(const aCreateFunction: create_modulefunc): boolean;
begin
  {$IFDEF FPC}
  Result := AddSlot(TPy_mod.create, Pointer(aCreateFunction));
  {$ELSE}
  Result := AddSlot(TPy_mod.create, @aCreateFunction);
  {$ENDIF}
end;

function TCustomPyModule.AddExecSlot(const aExecFunction: exec_modulefunc): boolean;
begin
  {$IFDEF FPC}
  Result := AddSlot(TPy_mod.exec, Pointer(aExecFunction));
  {$ELSE}
  Result := AddSlot(TPy_mod.exec, @aExecFunction);
  {$ENDIF}
end;

function TCustomPyModule.AddMultipleInterpretersSlot(aSupport: TMultIntprSupport): boolean;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    case aSupport of
      miUnsupported  : Result := AddSlot(TPy_mod.multiple_interpreters, Py_MOD_MULTIPLE_INTERPRETERS_NOT_SUPPORTED);
      piGilSupported : Result := AddSlot(TPy_mod.multiple_interpreters, Py_MOD_PER_INTERPRETER_GIL_SUPPORTED);
      else             Result := AddSlot(TPy_mod.multiple_interpreters, Py_MOD_MULTIPLE_INTERPRETERS_SUPPORTED);
    end
   else
    Result := False;
end;

function TCustomPyModule.AddGILSlot(aGILUsed: boolean): boolean;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 13, 0) then
    begin
      if aGILUsed then
        Result := AddSlot(TPy_mod.gil, Py_MOD_GIL_USED)
       else
        Result := AddSlot(TPy_mod.gil, Py_MOD_GIL_NOT_USED);
    end
   else
    Result := False;
end;

procedure TCustomPyModule.DestroySlotList;
var
  i : integer;
begin
  if assigned(FSlotList) then
    begin
      i := pred(FSlotList.Count);
      while (i >= 0) do
        begin
          TCustomPyModuleDefSlot(FSlotList[i]).Free;
          FSlotList[i] := nil;
          dec(i);
        end;

      FreeAndNil(FSlotList);
    end;
end;

procedure TCustomPyModule.DestroySlots;
begin
  if assigned(FSlots) then
    begin
      SetLength(FSlots, 0);
      FSlots := nil;
    end;
end;

procedure TCustomPyModule.DestroyMethodList;
var
  i : integer;
begin
  if assigned(FMethodList) then
    begin
      i := pred(FMethodList.Count);
      while (i >= 0) do
        begin
          TCustomPyMethodDef(FMethodList[i]).Free;
          FMethodList[i] := nil;
          dec(i);
        end;

      FreeAndNil(FMethodList);
    end;
end;

procedure TCustomPyModule.DestroyMethods;
begin
  if assigned(FMethods) then
    begin
      SetLength(FMethods, 0);
      FMethods := nil;
    end;
end;

procedure TCustomPyModule.CreateSlotArray;
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
          FSlots[i] := TCustomPyModuleDefSlot(FSlotList[i]).Slot;
          inc(i);
        end;
    end;
end;

procedure TCustomPyModule.CreateMethodArray;
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
          FMethods[i] := TCustomPyMethodDef(FMethodList[i]).Method;
          inc(i);
        end;
    end;
end;

function TCustomPyModule.GetHasSentinelSlot: boolean;
begin
  Result := assigned(FSlotList) and
            (FSlotList.Count > 0) and
            TCustomPyModuleDefSlot(FSlotList[FSlotList.Count - 1]).IsSentinel;
end;

function TCustomPyModule.GetHasSentinelMethod: boolean;
begin
  Result := assigned(FMethodList) and
            (FMethodList.Count > 0) and
            TCustomPyMethodDef(FMethodList[FMethodList.Count - 1]).IsSentinel;

end;

procedure TCustomPyModule.AddAllSlots;
begin
  AddExecSlot(@Exec_Module);
  AddMultipleInterpretersSlot(FMultIntprSupport);
end;

procedure TCustomPyModule.AddAllMethods;
begin
  //
end;

function TCustomPyModule.doOnAfterInitialization: integer;
begin
  Result := 0;

  if assigned(FOnAfterInitialization) then
    FOnAfterInitialization(self);
end;

function TCustomPyModule.SameAs(const other: PPyObject): boolean;
begin
  Result := assigned(FModule) and
            assigned(other) and
            FModule.SameAs(other);
end;

function TCustomPyModule.Initialize: boolean;
var
  TempSpec : IPyObject;
begin
  Result := False;
  if assigned(FModule) or not(FInitializedModuleDef) then exit;

  AddAllSlots;
  AddAllMethods;

  if not(HasSentinelSlot) then
    AddSentinelSlot;

  if not(HasSentinelMethod) then
    AddSentinelMethod;

  CreateSlotArray;
  CreateMethodArray;

  FModuleDef.m_slots   := @FSlots[0];
  FModuleDef.m_methods := @FMethods[0];

  if FIsExtension then
    Result := True
   else
    try
      TempSpec := TPyModuleSpecHelper.FromModuleName(FName);

      // Create the module from the definition and spec
      FModule  := TPyModule.FromDefAndSpec(@FModuleDef, TempSpec);

      if assigned(FModule) then
        begin
          // TPyModule.ExecDef executes the module.
          // It triggers Py_mod_exec slot, which triggers
          // the TCustomPyModule.OnAfterInitialization event.
          if TPyModule.ExecDef(FModule, @FModuleDef) then
            Result := GlobalP4PEngine.AddModuleToSys(self);
        end
       else
        GlobalP4PEngine.GetRaisedException;
    finally
      TempSpec := nil;
    end;
end;

end.
