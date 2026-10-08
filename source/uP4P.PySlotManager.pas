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
  /// <para>TPySlotManager is used to store the information about the module
  /// and to manage the method and slot lists.</para>
  /// </summary>
  TPySlotManager = class(TInterfacedObject, IPySlotManager)
    protected
      FName                  : string;
      FDocStrings            : string;
      FSlotList              : TList;
      FSlots                 : PySlotArray;
      FMethodList            : TList;
      FMethods               : PyMethodDefArray;
      FABIInfo               : PyAbiInfo;

      function  GetName: AnsiString;
      function  GetHasMethodsSlot: boolean;
      function  GetHasSentinelSlot: boolean;
      function  GetHasSentinelMethod: boolean;
      function  GetSlots: PPySlot;
      function  GetABIInfo: PPyAbiInfo;

      procedure DestroySlotList;
      procedure DestroySlots;
      procedure DestroyMethodList;
      procedure DestroyMethods;

      procedure CreateSlotArray;
      procedure CreateMethodArray;

      function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
      function  AddNameSlot: boolean;
      function  AddDocStringsSlot: boolean;
      function  AddABIInfoSlot: boolean;
      function  AddExecSlot(const aExecFunction: exec_modulefunc): boolean;
      function  AddMultipleInterpretersSlot(aSupport: TMultIntprSupport): boolean;
      function  AddGILSlot(aGILUsed: boolean): boolean;
      function  AddSentinelMethod: boolean;
      procedure AddSentinelSlot;
      procedure AddMethodsSlot;

      /// <summary>
      /// Override this procedure to add your custom slots.
      /// </summary>
      procedure AddAllSlots(const aExecFunction: exec_modulefunc; aMultIntprSupport : TMultIntprSupport; aGILUsed: boolean); virtual;
      /// <summary>
      /// Override this procedure to add your custom methods.
      /// </summary>
      procedure AddAllMethods; virtual;

    public
      constructor Create(const aName: string; const aDocStrings: string = '');
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      /// <summary>
      /// Create the slots with the methods and all the module information.
      /// </summary>
      procedure   BuildMethodsAndSlots(const aExecFunction: exec_modulefunc; aMultIntprSupport : TMultIntprSupport; aGILUsed: boolean);

      property  Name_                  : AnsiString     read GetName;
      /// <summary>
      /// Return True if the slot list has a Py_mod_methods slot.
      /// </summary>
      property  HasMethodsSlot         : boolean        read GetHasMethodsSlot;
      /// <summary>
      /// Return True if the last slot has a Py_slot_end value in the
      /// sl_id field.
      /// </summary>
      property  HasSentinelSlot        : boolean        read GetHasSentinelSlot;
      /// <summary>
      /// Return True if the last method in the list is a sentinel method.
      /// </summary>
      property  HasSentinelMethod      : boolean        read GetHasSentinelMethod;
      /// <summary>
      /// Return a pointer to the first slot.
      /// </summary>
      property  Slots                  : PPySlot        read GetSlots;
      /// <summary>
      /// Return a pointer to the ABI info record.
      /// </summary>
      property  ABIInfo                : PPyAbiInfo     read GetABIInfo;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyMethodDef, uP4P.Py_mod, uP4P.PyABIInfo;

constructor TPySlotManager.Create(const aName: string; const aDocStrings: string = '');
begin
  inherited Create;

  FName           := aName;
  FDocStrings     := aDocStrings;
  FSlotList       := nil;
  FSlots          := nil;
  FMethodList     := nil;
  FMethods        := nil;

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

procedure TPySlotManager.AddAllSlots(const aExecFunction: exec_modulefunc; aMultIntprSupport : TMultIntprSupport; aGILUsed: boolean);
begin
  AddNameSlot;
  AddDocStringsSlot;
  AddABIInfoSlot;
  AddExecSlot(aExecFunction);
  AddMultipleInterpretersSlot(aMultIntprSupport);
  AddGILSlot(aGILUsed);
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

function TPySlotManager.AddExecSlot(const aExecFunction: exec_modulefunc): boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) then
    begin
      TempSlot := TPySlot.Create;
      {$IFDEF FPC}
      TempSlot.Set_FUNC(TPy_mod.exec, _Py_funcptr_t(aExecFunction));
      {$ELSE}
      TempSlot.Set_FUNC(TPy_mod.exec, @aExecFunction);
      {$ENDIF}

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPySlotManager.AddMultipleInterpretersSlot(aSupport: TMultIntprSupport): boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) then
    begin
      TempSlot := TPySlot.Create;

      case aSupport of
        miUnsupported  : TempSlot.Set_DATA(TPy_mod.multiple_interpreters, Py_MOD_MULTIPLE_INTERPRETERS_NOT_SUPPORTED);
        piGilSupported : TempSlot.Set_DATA(TPy_mod.multiple_interpreters, Py_MOD_PER_INTERPRETER_GIL_SUPPORTED);
        else             TempSlot.Set_DATA(TPy_mod.multiple_interpreters, Py_MOD_MULTIPLE_INTERPRETERS_SUPPORTED);
      end;

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPySlotManager.AddGILSlot(aGILUsed: boolean): boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) then
    begin
      TempSlot := TPySlot.Create;

      if aGILUsed then
        TempSlot.Set_DATA(TPy_mod.gil, Py_MOD_GIL_USED)
       else
        TempSlot.Set_DATA(TPy_mod.gil, Py_MOD_GIL_NOT_USED);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPySlotManager.GetName: AnsiString;
begin
  Result := StringToPyUTF8(FName);
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

procedure TPySlotManager.BuildMethodsAndSlots(const aExecFunction: exec_modulefunc; aMultIntprSupport : TMultIntprSupport; aGILUsed: boolean);
begin
  AddAllSlots(aExecFunction, aMultIntprSupport, aGILUsed);
  AddAllMethods;

  if not(HasSentinelMethod) then
    AddSentinelMethod;

  CreateMethodArray;
  AddMethodsSlot;

  if not(HasSentinelSlot) then
    AddSentinelSlot;

  CreateSlotArray;
end;

procedure TPySlotManager.AddMethodsSlot;
var
  TempSlot : TPySlot;
begin
  if assigned(FSlotList) and assigned(FMethods) and (length(FMethods) > 0) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_STATIC_DATA(TPy_mod.methods, @FMethods[0]);

      FSlotList.Add(TempSlot);
    end;
end;

procedure TPySlotManager.AddSentinelSlot;
var
  TempSlot : TPySlot;
begin
  if assigned(FSlotList) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_END;

      FSlotList.Add(TempSlot);
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
