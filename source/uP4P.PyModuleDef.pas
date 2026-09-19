unit uP4P.PyModuleDef;

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
  /// <para>TPyModuleDef is used to store the information about modules and
  /// it's also a helper class for all PyModuleDef_* methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/extension-modules.html#multi-phase-initialization">See the article about Multi-phase initialization.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyMethodDef">See the article about PyMethodDef.</see></para>
  /// </remarks>
  TPyModuleDef = class(TInterfacedObject, IPyModuleDef)
    protected
      FModuleDef             : PyModuleDef;
      FName                  : AnsiString;
      FDocStrings            : AnsiString;
      FSlotList              : TList;
      FSlots                 : PyModuleDef_SlotArray;
      FMethodList            : TList;
      FMethods               : PyMethodDefArray;
      FInitialized           : boolean;

      function  Initialize(const aName, aDocStrings: string) : boolean;

      procedure CreateSlotArray;
      procedure CreateMethodArray;

      procedure DestroySlotList;
      procedure DestroySlots;
      procedure DestroyMethodList;
      procedure DestroyMethods;

      function  GetInitialized: boolean;
      function  GetName: AnsiString;
      function  GetHasSentinelSlot: boolean;
      function  GetHasSentinelMethod: boolean;
      function  GetModuleDef: PPyModuleDef;

      /// <summary>
      /// Override this procedure to add your custom slots.
      /// </summary>
      procedure AddAllSlots(const aExecFunction: exec_modulefunc; aMultIntprSupport : TMultIntprSupport); virtual;
      /// <summary>
      /// Override this procedure to add your custom methods.
      /// </summary>
      procedure AddAllMethods; virtual;

      function  AddSentinelMethod: boolean;
      function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
      function  AddSentinelSlot: boolean;
      function  AddSlot(aSlot: integer; aValue: Pointer): boolean;
      function  AddCreateSlot(const aCreateFunction: create_modulefunc): boolean;
      function  AddExecSlot(const aExecFunction: exec_modulefunc): boolean;
      function  AddMultipleInterpretersSlot(aSupport: TMultIntprSupport): boolean;
      function  AddGILSlot(aGILUsed: boolean): boolean;

    public
      constructor Create(const aName: string; const aDocStrings: string = '');
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      procedure   BuildMethodsAndSlots(const aExecFunction: exec_modulefunc; aMultIntprSupport : TMultIntprSupport); virtual;
      /// <summary>
      /// <para>Ensure a module definition is a properly initialized Python
      /// object that correctly reports its type and a reference count.</para>
      /// <para>Return def cast to PPyObject, or nil if an error
      /// occurred.</para>
      /// <para>Calling this function is required for Multi-phase
      /// initialization. It should not be used in other contexts.</para>
      /// <para>Note that Python assumes that PyModuleDef structures are
      /// statically allocated. This function may return either a new reference
      /// or a borrowed one; this reference must not be released.</para>
      /// </summary>
      class function Init(const def: PyModuleDef): PPyObject;

      property  Initialized            : boolean        read FInitialized;
      /// <summary>
      /// <para>Module name.</para>
      /// </summary>
      property  Name_                  : AnsiString     read GetName;
      /// <summary>
      /// Return True if the last slot in the list is a sentinel slot.
      /// </summary>
      property  HasSentinelSlot        : boolean        read GetHasSentinelSlot;
      /// <summary>
      /// Return True if the last method in the list is a sentinel method.
      /// </summary>
      property  HasSentinelMethod      : boolean        read GetHasSentinelMethod;
      /// <summary>
      /// Return a poiter to PyModuleDef.
      /// </summary>
      property  ModuleDef              : PPyModuleDef   read GetModuleDef;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyModuleDef_Slot, uP4P.PyMethodDef, uP4P.Py_mod,
  uP4P.Engine;

constructor TPyModuleDef.Create(const aName, aDocStrings: string);
begin
  inherited Create;

  FName           := StringToPyUTF8(aName);
  FDocStrings     := StringToPyUTF8(aDocStrings);
  FSlotList       := nil;
  FSlots          := nil;
  FMethodList     := nil;
  FMethods        := nil;
  FInitialized    := Initialize(aName, aDocStrings);
end;

destructor TPyModuleDef.Destroy;
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

procedure TPyModuleDef.AfterConstruction;
begin
  inherited AfterConstruction;

  FSlotList   := TList.Create;
  FMethodList := TList.Create;
end;

procedure TPyModuleDef.BuildMethodsAndSlots(const aExecFunction: exec_modulefunc; aMultIntprSupport : TMultIntprSupport);
begin
  AddAllSlots(aExecFunction, aMultIntprSupport);
  AddAllMethods;

  if not(HasSentinelSlot) then
    AddSentinelSlot;

  if not(HasSentinelMethod) then
    AddSentinelMethod;

  CreateSlotArray;
  CreateMethodArray;

  FModuleDef.m_slots   := @FSlots[0];
  FModuleDef.m_methods := @FMethods[0];
end;

procedure TPyModuleDef.AddAllSlots(const aExecFunction: exec_modulefunc; aMultIntprSupport : TMultIntprSupport);
begin
  AddExecSlot(aExecFunction);
  AddMultipleInterpretersSlot(aMultIntprSupport);
end;

procedure TPyModuleDef.AddAllMethods;
begin
  //
end;

function TPyModuleDef.AddSentinelMethod: boolean;
begin
  Result := AddMethod('', '', nil, 0);
end;

function TPyModuleDef.AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
var
  TempMethod : TPyMethodDef;
begin
  Result := False;

  if assigned(FMethodList) then
    begin
      TempMethod := TPyMethodDef.Create(aName, aDocStrings, aMethod, aFlags);
      Result     := (FMethodList.Add(TempMethod) >= 0);
    end;
end;

function TPyModuleDef.AddSentinelSlot: boolean;
begin
  Result := AddSlot(0, nil);
end;

function TPyModuleDef.AddSlot(aSlot: integer; aValue: Pointer): boolean;
var
  TempSlot : TPyModuleDef_Slot;
begin
  Result := False;

  if assigned(FSlotList) then
    begin
      TempSlot := TPyModuleDef_Slot.Create(aSlot, aValue);
      Result   := (FSlotList.Add(TempSlot) >= 0);
    end;
end;

function TPyModuleDef.AddCreateSlot(const aCreateFunction: create_modulefunc): boolean;
begin
  {$IFDEF FPC}
  Result := AddSlot(TPy_mod.create, Pointer(aCreateFunction));
  {$ELSE}
  Result := AddSlot(TPy_mod.create, @aCreateFunction);
  {$ENDIF}
end;

function TPyModuleDef.AddExecSlot(const aExecFunction: exec_modulefunc): boolean;
begin
  {$IFDEF FPC}
  Result := AddSlot(TPy_mod.exec, Pointer(aExecFunction));
  {$ELSE}
  Result := AddSlot(TPy_mod.exec, @aExecFunction);
  {$ENDIF}
end;

function TPyModuleDef.AddMultipleInterpretersSlot(aSupport: TMultIntprSupport): boolean;
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

function TPyModuleDef.AddGILSlot(aGILUsed: boolean): boolean;
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

function TPyModuleDef.Initialize(const aName, aDocStrings: string) : boolean;
begin
  Result := False;

  try
    FillChar(FModuleDef, SizeOf(FModuleDef), 0);

    if assigned(Init(FModuleDef)) then
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
      if CustomExceptionHandler('TPyModuleDef.Initialize', e) then raise;
  end;
end;

procedure TPyModuleDef.CreateSlotArray;
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
          FSlots[i] := TPyModuleDef_Slot(FSlotList[i]).Slot;
          inc(i);
        end;
    end;
end;

procedure TPyModuleDef.CreateMethodArray;
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

procedure TPyModuleDef.DestroySlotList;
var
  i : integer;
begin
  if assigned(FSlotList) then
    begin
      i := pred(FSlotList.Count);
      while (i >= 0) do
        begin
          TPyModuleDef_Slot(FSlotList[i]).Free;
          FSlotList[i] := nil;
          dec(i);
        end;

      FreeAndNil(FSlotList);
    end;
end;

procedure TPyModuleDef.DestroySlots;
begin
  if assigned(FSlots) then
    begin
      SetLength(FSlots, 0);
      FSlots := nil;
    end;
end;

procedure TPyModuleDef.DestroyMethodList;
var
  i : integer;
begin
  if assigned(FMethodList) then
    begin
      i := pred(FMethodList.Count);
      while (i >= 0) do
        begin
          TPyMethodDef(FMethodList[i]).Free;
          FMethodList[i] := nil;
          dec(i);
        end;

      FreeAndNil(FMethodList);
    end;
end;

procedure TPyModuleDef.DestroyMethods;
begin
  if assigned(FMethods) then
    begin
      SetLength(FMethods, 0);
      FMethods := nil;
    end;
end;

function TPyModuleDef.GetInitialized: boolean;
begin
  Result := FInitialized;
end;

function TPyModuleDef.GetName: AnsiString;
begin
  Result := FName;
end;

function TPyModuleDef.GetHasSentinelSlot: boolean;
begin
  Result := assigned(FSlotList) and
            (FSlotList.Count > 0) and
            TPyModuleDef_Slot(FSlotList[FSlotList.Count - 1]).IsSentinel;
end;

function TPyModuleDef.GetHasSentinelMethod: boolean;
begin
  Result := assigned(FMethodList) and
            (FMethodList.Count > 0) and
            TPyMethodDef(FMethodList[FMethodList.Count - 1]).IsSentinel;
end;

function TPyModuleDef.GetModuleDef: PPyModuleDef;
begin
  Result := @FModuleDef;
end;

class function TPyModuleDef.Init(const def: PyModuleDef): PPyObject;
begin
  if assigned(PyModuleDef_Init) then
    Result := PyModuleDef_Init(@def)
   else
    Result := nil;
end;

end.
