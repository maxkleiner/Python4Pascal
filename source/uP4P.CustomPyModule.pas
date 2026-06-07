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
  TCustomPyModule = class(TInterfacedObject, ICustomPyModule)
    protected
      FModule      : IPyObject;
      FModuleDef   : PyModuleDef;
      FName        : AnsiString;
      FDocStrings  : AnsiString;
      FSlotList    : TList;
      FSlots       : array of Pointer;
      FMethodList  : TList;
      FMethods     : array of Pointer;
      FIsExtension : boolean;

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
      procedure AddAllSlots; virtual;
      procedure AddAllMethods; virtual;

    public
      constructor Create(const aName: string; const aDocStrings: string = ''; aIsExtension : boolean = False);
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      procedure   Initialize;

      property HasSentinelSlot        : boolean        read GetHasSentinelSlot;
      property HasSentinelMethod      : boolean        read GetHasSentinelMethod;
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
  uP4P.MiscFunctions, uP4P.Loader, uP4P.PyModuleSpecHelper, uP4P.PyModule, uP4P.PyImport, uP4P.PyDict;

function Exec_Module(self, args: PPyObject): PPyObject; cdecl;
begin
  Result := nil;
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
  FModule := nil;

  DestroySlotList;
  DestroySlots;
  DestroyMethodList;
  DestroyMethods;

  inherited Destroy;
end;

procedure TCustomPyModule.AfterConstruction;
begin
  inherited AfterConstruction;

  FSlotList   := TList.Create;
  FMethodList := TList.Create;
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
  AddSlot(Py_mod_exec, @Exec_Module);

  if assigned(GlobalP4PLoader) and GlobalP4PLoader.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    AddSlot(Py_mod_multiple_interpreters, Py_MOD_MULTIPLE_INTERPRETERS_SUPPORTED);
end;

procedure TCustomPyModule.AddAllMethods;
begin
  //
end;

procedure TCustomPyModule.Initialize;
var
  TempSpec, TempModuleDict : IPyObject;
begin
  if assigned(FModule) then exit;

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

  if not(FIsExtension) then
    try
      TempSpec := TPyModuleSpecHelper.FromModuleName(FName);

      // Create the module from the definition and spec
      FModule  := TPyModule.FromDefAndSpec(@FModuleDef, TempSpec);

      // Execute the module (triggers Py_mod_exec slot)
      TPyModule.ExecDef(FModule, @FModuleDef);

      // add the module to sys.modules
      TempModuleDict := TPyImport.GetModuleDict;
      TPyDict.SetItemString(TempModuleDict, FName, FModule);
    finally
      TempSpec       := nil;
      TempModuleDict := nil;
    end;
end;
{$ENDREGION}

end.
