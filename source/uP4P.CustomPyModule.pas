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
  TCustomPyModule = class
    protected
      FModule                : IPyObject;
      FModuleDef             : PyModuleDef;
      FName                  : AnsiString;
      FDocStrings            : AnsiString;
      FSlotList              : TList;
      FSlots                 : array of Pointer;
      FMethodList            : TList;
      FMethods               : array of Pointer;
      FIsExtension           : boolean;
      FOnAfterInitialization : TNotifyEvent;

      function  GetHasSentinelSlot: boolean;
      function  GetHasSentinelMethod: boolean;

      procedure DestroySlotList;
      procedure DestroySlots;
      procedure DestroyMethodList;
      procedure DestroyMethods;
      procedure CreateSlotArray;
      procedure CreateMethodArray;
      function  AddSentinelMethod: boolean;
      function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
      function  AddSentinelSlot: boolean;
      function  AddSlot(aSlot: integer; aValue: Pointer): boolean;
      function  AddCreateSlot(const aCreateFunction: create_modulefunc): boolean;
      function  AddExecSlot(const aExecFunction: exec_modulefunc): boolean;
      function  AddMultipleInterpretersSlot(aSupport: TMultIntprSupport): boolean;
      function  AddGILSlot(aGILUsed: boolean): boolean;
      procedure AddAllSlots; virtual;
      procedure AddAllMethods; virtual;

      property  HasSentinelSlot        : boolean        read GetHasSentinelSlot;
      property  HasSentinelMethod      : boolean        read GetHasSentinelMethod;

    public
      constructor Create(const aName: string; const aDocStrings: string = ''; aIsExtension : boolean = False);
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      procedure   BeforeDestruction; override;
      function    doOnAfterInitialization: integer;
      function    SameAs(const other: PPyObject): boolean;
      function    Initialize: boolean;

      property Name_                         : AnsiString     read FName;
      property Module                        : IPyObject      read FModule;
      property OnAfterInitialization         : TNotifyEvent   read FOnAfterInitialization    write FOnAfterInitialization;
  end;

  TCustomPyModuleDefSlot = class
    protected
      FSlot : PyModuleDef_Slot;

      function  GetIsSentinel: boolean;

    public
      constructor Create(aSlot: integer; aValue: Pointer);

      property Slot        : PyModuleDef_Slot  read FSlot;
      property IsSentinel  : boolean           read GetIsSentinel;
  end;

  TCustomPyMethodDef = class
    protected
      FMethod      : PyMethodDef;
      FName        : AnsiString;
      FDocStrings  : AnsiString;

      function  GetIsSentinel: boolean;

    public
      constructor Create(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer);

      property Method      : PyMethodDef       read FMethod;
      property IsSentinel  : boolean           read GetIsSentinel;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.Engine, uP4P.PyModuleSpecHelper, uP4P.PyModule, uP4P.PyImport, uP4P.PyDict;


function Exec_Module(module: PPyObject): integer; cdecl;
var
  TempModule : TCustomPyModule;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.SearchModule(module, TempModule) then
    TempModule.doOnAfterInitialization;

  Result := 0;
end;

{$REGION 'TCustomPyModuleDefSlot'}
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
{$ENDREGION}

{$REGION 'TCustomPyMethodDef'}
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
{$ENDREGION}

{$REGION 'TCustomPyModule'}
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
  FIsExtension           := aIsExtension;

  FillChar(FModuleDef, SizeOf(FModuleDef), 0);

  FModuleDef.m_base.ob_base.ob_refcnt := 1;

  if (length(aName) > 0) then
    FModuleDef.m_name := PAnsiChar(FName)
   else
    FModuleDef.m_name := nil;

  if (length(aDocStrings) > 0) then
    FModuleDef.m_doc := PAnsiChar(FDocStrings)
   else
    FModuleDef.m_doc := nil;
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

  if (GlobalP4PEngine <> nil) then
    GlobalP4PEngine.AddModule(self);
end;

procedure TCustomPyModule.BeforeDestruction;
begin
  if (GlobalP4PEngine <> nil) then
    GlobalP4PEngine.RemoveModule(self);

  inherited BeforeDestruction;
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
  Result := AddSlot(Py_mod_create, @aCreateFunction);
end;

function TCustomPyModule.AddExecSlot(const aExecFunction: exec_modulefunc): boolean;
begin
  Result := AddSlot(Py_mod_exec, @aExecFunction);
end;

function TCustomPyModule.AddMultipleInterpretersSlot(aSupport: TMultIntprSupport): boolean;
begin
  case aSupport of
    miUnsupported  : Result := AddSlot(Py_mod_multiple_interpreters, Py_MOD_MULTIPLE_INTERPRETERS_NOT_SUPPORTED);
    piGilSupported : Result := AddSlot(Py_mod_multiple_interpreters, Py_MOD_PER_INTERPRETER_GIL_SUPPORTED);
    else             Result := AddSlot(Py_mod_multiple_interpreters, Py_MOD_MULTIPLE_INTERPRETERS_SUPPORTED);
  end;
end;

function TCustomPyModule.AddGILSlot(aGILUsed: boolean): boolean;
begin
  if aGILUsed then
    Result := AddSlot(Py_mod_gil, Py_MOD_GIL_USED)
   else
    Result := AddSlot(Py_mod_gil, Py_MOD_GIL_NOT_USED);
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
          FreeAndNil(FSlotList[i]);
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
          FreeAndNil(FMethodList[i]);
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
          FSlots[i] := @TCustomPyModuleDefSlot(FSlotList[i]).Slot;
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
          FMethods[i] := @TCustomPyMethodDef(FMethodList[i]).Method;
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

  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    AddMultipleInterpretersSlot(miSupported);
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
  Result := assigned(FModule) and assigned(other) and FModule.SameAs(other);
end;

function TCustomPyModule.Initialize: boolean;
var
  TempSpec : IPyObject;
begin
  Result := False;
  if assigned(FModule) then exit;

  AddAllSlots;
  AddAllMethods;

  if not(HasSentinelSlot) then
    AddSentinelSlot;

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

      if assigned(FModule) and (GlobalP4PEngine <> nil) then
        begin
          // Execute the module (triggers Py_mod_exec slot)
          Result := TPyModule.ExecDef(FModule, @FModuleDef) and
                    GlobalP4PEngine.AddModuleToSys(self);
        end;
    finally
      TempSpec := nil;
    end;
end;
{$ENDREGION}

end.
