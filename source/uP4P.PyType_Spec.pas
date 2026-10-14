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
      FSlotList   : TList;
      FSlots      : PyType_SlotArray;
      FMethodList : TList;
      FMethods    : PyMethodDefArray;
      FToken      : pointer;

      function  GetName: AnsiString;
      function  GetBasicsize: integer;
      function  GetItemsize: integer;
      function  GetFlags: cardinal;
      function  GetHasSentinelSlot: boolean;
      function  GetHasSentinelMethod: boolean;
      function  GetSlots: PPyType_Slot;
      function  GetTypeSpec: PPyType_Spec;
      function  GetToken: pointer;

      procedure SetName(const aValue: AnsiString);
      procedure SetBasicsize(aValue: integer);
      procedure SetItemsize(aValue: integer);
      procedure SetFlags(aValue: cardinal);
      procedure SetToken(aValue: pointer);

      procedure CreateSlotArray;
      procedure CreateMethodArray;

      procedure DestroySlotList;
      procedure DestroySlots;
      procedure DestroyMethodList;
      procedure DestroyMethods;

      /// <summary>
      /// Override this procedure to add your custom slots.
      /// </summary>
      procedure AddAllSlots; virtual;
      /// <summary>
      /// Override this procedure to add your custom methods.
      /// </summary>
      procedure AddAllMethods; virtual;

      function  AddSlot(aSlot: integer; aPfunc: Pointer): boolean;
      function  AddSentinelSlot: boolean;
      function  AddSentinelMethod: boolean;
      function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
      procedure AddMethodsSlot;
      procedure AddTokenSlot;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      /// <summary>
      /// Create the methods and the slots with all the type information.
      /// </summary>
      procedure   BuildMethodsAndSlots;
      /// <summary>
      /// Name of the type, used to set PyTypeObject.tp_name.
      /// </summary>
      property Name_                   : AnsiString        read GetName              write SetName;
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
      /// Type flags, used to set PyTypeObject.tp_flags.
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
  uP4P.PyMethodDef, uP4P.PyType_Slot, uP4P.Engine;

constructor TPyType_Spec.Create;
begin
  inherited Create;

  FName                  := '';
  FSlotList              := nil;
  FSlots                 := nil;
  FMethodList            := nil;
  FMethods               := nil;
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
  finally
    inherited Destroy;
  end;
end;

procedure TPyType_Spec.AfterConstruction;
begin
  inherited AfterConstruction;

  FSlotList   := TList.Create;
  FMethodList := TList.Create;
end;

procedure TPyType_Spec.BuildMethodsAndSlots;
begin
  AddAllSlots;
  AddAllMethods;

  if not(HasSentinelSlot) then
    AddSentinelSlot;

  if not(HasSentinelMethod) then
    AddSentinelMethod;

  CreateMethodArray;
  CreateSlotArray;

  FTypeSpec.slots := Slots;
end;

function TPyType_Spec.GetName: AnsiString;
begin
  Result := FName;
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

procedure TPyType_Spec.AddAllMethods;
begin
  //
end;

procedure TPyType_Spec.AddAllSlots;
begin
  //
end;

function TPyType_Spec.AddSentinelMethod: boolean;
begin
  Result := AddMethod('', '', nil, 0);
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

procedure TPyType_Spec.AddMethodsSlot;
begin
  //Don't add the methods slot if the only element in the list is the sentinel.
  if assigned(FMethods) and (length(FMethods) > 1) then
    AddSlot(Py_tp_methods, @FMethods[0]);
end;

procedure TPyType_Spec.AddTokenSlot;
begin
  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 14, 0) then
    AddSlot(Py_tp_token, FToken);
end;

function TPyType_Spec.AddSentinelSlot: boolean;
begin
  Result := AddSlot(0, nil);
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

end.
