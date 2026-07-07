unit uP4P.PyObject;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces;

type
  TPyObject = class(TInterfacedObject, IPyObject)
    protected
      FPyObject    : PPyObject;
      FObjRefOwner : boolean;

      function  GetPyObject: PPyObject; virtual;
      function  GetInitialized: boolean; virtual;
      function  GetRefCnt: integer;
      function  GetObjRefOwner: boolean;
      function  GetPyTypeObject: PPyTypeObject;
      function  GetTypeData(const cls: PyTypeObject): Pointer;
      function  GetAsString: string;
      function  GetAsVariant: Variant;

      procedure SetObjRefOwner(aValue: boolean);
      procedure SetPyObject(aValue: PPyObject); virtual;

      function  IsTrueSingleton: boolean;
      function  IsFalseSingleton: boolean;
      function  IsNoneSingleton: boolean;
      procedure IncRef;
      procedure DecRef;
      function  NewRef: Pointer;
      function  XNewRef: Pointer;
      function  SameAs(const other: IPyObject): boolean; overload;
      function  SameAs(const other: PPyObject): boolean; overload;
      function  IsType(aPyTypeObject: PPyTypeObject): boolean;
      function  TypeCheck(aPyTypeObject: PPyTypeObject): boolean;
      procedure InitPyObject;
      function  IsInstance(const cls: IPyObject): integer;
      function  IsSubclass(const cls: IPyObject): integer;
      function  GenericGetDict(context: Pointer): IPyObject;
      function  CheckBuffer: boolean;
      function  GetBuffer(var view: Py_buffer; flags: Integer): boolean;
      function  CopyData(const src: IPyObject): boolean;
      function  Repr: IPyObject;
      function  Str: IPyObject;
      function  ASCII: IPyObject;
      function  Bytes: IPyObject;
      function  RichCompare(const obj: IPyObject; opid: integer): IPyObject;
      function  RichCompareBool(const obj: IPyObject; opid: integer): integer;
      function  GetAttrString(const attr_name: string): IPyObject;
      function  GetAttrString2(const attr_name: string): Pointer;
      function  SetAttrString(const attr_name: string; const value: IPyObject): boolean;
      function  SetAttrString2(const attr_name: string; value: Pointer): boolean;
      function  DelAttrString(const attr_name: string): boolean;
      function  HasAttrString(const attr_name: string): boolean;
      function  GetAttr(const attr_name: IPyObject): IPyObject;
      function  GetOptionalAttr(const attr_name: IPyObject; out result_: IPyObject): boolean;
      function  GetOptionalAttr2(const attr_name: IPyObject; out result_: Pointer): boolean;
      function  GetOptionalAttrString(const attr_name: string; out result_: IPyObject): boolean;
      function  GetOptionalAttrString2(const attr_name: string; out result_: Pointer): boolean;
      function  SetAttr(const attr_name, value: IPyObject): boolean;
      function  SetAttr2(const attr_name: IPyObject; value: Pointer): boolean;
      function  DelAttr(const attr_name: IPyObject): boolean;
      function  HasAttr(const attr_name: IPyObject): boolean;
      function  HasAttrWithError(const attr_name: IPyObject): integer;
      function  HasAttrStringWithError(const attr_name: string): integer;
      function  SelfIter: IPyObject;
      function  GenericGetAttr(const name_: IPyObject): IPyObject;
      function  GenericGetAttr2(const name_: IPyObject): Pointer;
      function  GenericSetAttr(const name_, value: IPyObject): boolean;
      function  GenericSetAttr2(const name_: IPyObject; value: Pointer): boolean;
      function  GenericSetDict(const value: IPyObject; context: Pointer): boolean;
      function  Hash: Py_hash_t;
      function  HashNotImplemented: Py_hash_t;
      function  IsTrue: integer;
      function  Not_: integer;
      procedure ClearWeakRefs;
      function  Dir: IPyObject;
      function  ReprEnter: boolean;
      procedure ReprLeave;
      function  Print(file_: PFILE; flags: integer): boolean;
      procedure CallFinalizer;
      function  CallFinalizerFromDealloc: boolean;
      function  GetItemData: Pointer;
      function  VisitManagedDict(visit: visitproc; arg: Pointer): integer;
      procedure ClearManagedDict;
      procedure GC_Track;
      procedure GC_UnTrack;
      function  GC_IsTracked: boolean;
      function  GC_IsFinalized: boolean;
      function  IS_GC: boolean;
      function  GenericHash: Py_hash_t;
      function  AsFileDescriptor: integer;
      function  Type_: IPyObject;
      function  Size: Py_ssize_t;
      function  Length: Py_ssize_t;
      function  GetItem(const key: IPyObject): IPyObject;
      function  SetItem(const key, v: IPyObject): boolean;
      function  DelItemString(const key: string): boolean;
      function  DelItem(const key: IPyObject): boolean;
      function  Format(const format_spec: IPyObject): IPyObject;
      function  GetIter: IPyObject;
      function  GetAIter: IPyObject;
      function  LengthHint(defaultvalue: Py_ssize_t): Py_ssize_t;
      function  CallNoArgs: IPyObject;
      function  Call(const args, kwargs: IPyObject): IPyObject;
      function  CallObject(const args: IPyObject): IPyObject;
      function  Vectorcall(const args: IPyObjectArray; const kwnames: IPyObject): IPyObject;
      function  VectorcallDict(const args: IPyObjectArray; const kwargs: IPyObject): IPyObject;
      function  CallOneArg(const arg: IPyObject): IPyObject;
      function  UnWrap: Pointer;

    public
      constructor Create(aPyObject: Pointer; aObjRefOwner, aUseNewRef: boolean); overload;
      destructor  Destroy; override;

      class function  Wrap(aPyObject: Pointer; aObjRefOwner: boolean = True; aUseNewRef: boolean = False): IPyObject; inline;
      class function  IsInitialized(const aPyObject: IPyObject): boolean; inline;
      class function  Malloc(size_: NativeUInt): pointer;
      class function  Calloc(nelem, elsize: NativeUInt): pointer;
      class function  Realloc(ptr: pointer; new_size: NativeUInt): pointer;
      class procedure Free_(ptr: pointer);
      class function  Init(const ob: IPyObject; typeobj: PPyTypeObject): IPyObject;
      class function  InitVar(const ob: IPyObject; typeobj: PPyTypeObject; size_: Py_ssize_t): IPyObject;
      class function  New(typeobj: PPyTypeObject): IPyObject;
      class function  NewVar(typeobj: PPyTypeObject; size_: Py_ssize_t): IPyObject;
      class function  VectorcallMethod(const name: IPyObject; const args: IPyObjectArray; const kwnames: IPyObject): IPyObject;
      class function  GC_Resize(varobj: PPyVarObject; size_: Py_ssize_t): PPyVarObject;
      class function  GC_New(typeobj: PPyTypeObject): IPyObject;
      class function  GC_NewVar(typeobj: PPyTypeObject; size_: Py_ssize_t): PPyVarObject;
      class procedure GC_Del(ptr: pointer);
      class procedure GetArenaAllocator(allocator: PPyObjectArenaAllocator);
      class procedure SetArenaAllocator(allocator: PPyObjectArenaAllocator);

      property Initialized   : boolean         read GetInitialized;
      property PyObject      : PPyObject       read GetPyObject      write SetPyObject;
      property ObjRefOwner   : boolean         read GetObjRefOwner   write SetObjRefOwner;
      property RefCnt        : integer         read GetRefCnt;
      property PyTypeObject  : PPyTypeObject   read GetPyTypeObject;
      property AsString      : string          read GetAsString;
      property AsVariant     : Variant         read GetAsVariant;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.Py, uP4P.PyUnicode, uP4P.PyBytes;

constructor TPyObject.Create(aPyObject: Pointer; aObjRefOwner, aUseNewRef: boolean);
begin
  inherited Create;

  if aUseNewRef and assigned(aPyObject) then
    begin
      FPyObject    := TPy.NewRef(aPyObject);
      FObjRefOwner := assigned(FPyObject);
    end
   else
    begin
      FPyObject    := aPyObject;
      FObjRefOwner := aObjRefOwner;
    end;
end;

destructor TPyObject.Destroy;
begin
  try
    if FObjRefOwner then
      DecRef;
  finally
    inherited Destroy;
  end;
end;

class function TPyObject.Wrap(aPyObject: Pointer; aObjRefOwner, aUseNewRef: boolean): IPyObject;
begin
  if assigned(aPyObject) then
    Result := TPyObject.Create(aPyObject, aObjRefOwner, aUseNewRef)
   else
    Result := nil;
end;

class function TPyObject.IsInitialized(const aPyObject: IPyObject): boolean;
begin
  Result := (aPyObject <> nil) and aPyObject.Initialized;
end;

class function TPyObject.Malloc(size_: NativeUInt): pointer;
begin
  if assigned(PyObject_Malloc) then
    Result := PyObject_Malloc(size_)
   else
    Result := nil;
end;

class function TPyObject.Calloc(nelem, elsize: NativeUInt): pointer;
begin
  if assigned(PyObject_Calloc) then
    Result := PyObject_Calloc(nelem, elsize)
   else
    Result := nil;
end;

class function TPyObject.Realloc(ptr: pointer; new_size: NativeUInt): pointer;
begin
  if assigned(PyObject_Realloc) then
    Result := PyObject_Realloc(ptr, new_size)
   else
    Result := nil;
end;

class procedure TPyObject.Free_(ptr: pointer);
begin
  if assigned(PyObject_Free) then
    PyObject_Free(ptr);
end;

class function TPyObject.Init(const ob: IPyObject; typeobj: PPyTypeObject): IPyObject;
begin
  if assigned(PyObject_Init) and
     TPyObject.IsInitialized(ob) and
     assigned(typeobj) then
    Result := TPyObject.Wrap(PyObject_Init(ob.PyObject, typeobj), False)
   else
    Result := nil;
end;

class function TPyObject.InitVar(const ob: IPyObject; typeobj: PPyTypeObject; size_: Py_ssize_t): IPyObject;
begin
  if assigned(PyObject_InitVar) and
     TPyObject.IsInitialized(ob) and
     assigned(typeobj) then
    Result := TPyObject.Wrap(PyObject_InitVar(PPyVarObject(ob.PyObject), typeobj, size_), False)
   else
    Result := nil;
end;

class function TPyObject.New(typeobj: PPyTypeObject): IPyObject;
begin
  if assigned(PyObject_New) and
     assigned(typeobj) then
    Result := TPyObject.Wrap(PyObject_New(typeobj))
   else
    Result := nil;
end;

class function TPyObject.NewVar(typeobj: PPyTypeObject; size_: Py_ssize_t): IPyObject;
begin
  if assigned(PyObject_NewVar) and
     assigned(typeobj) then
    Result := TPyObject.Wrap(PyObject_NewVar(typeobj, size_))
   else
    Result := nil;
end;

function TPyObject.CallNoArgs: IPyObject;
begin
  if Initialized and
     assigned(PyObject_CallNoArgs) then
    Result := TPyObject.Wrap(PyObject_CallNoArgs(PyObject))
   else
    Result := nil;
end;

function TPyObject.Call(const args, kwargs: IPyObject): IPyObject;
begin
  if Initialized and
     assigned(PyObject_Call) and
     TPyObject.IsInitialized(args) then
    begin
      if TPyObject.IsInitialized(kwargs) then
        Result := TPyObject.Wrap(PyObject_Call(PyObject, args.PyObject, kwargs.PyObject))
       else
        Result := TPyObject.Wrap(PyObject_Call(PyObject, args.PyObject, nil));
    end
   else
    Result := nil;
end;

function TPyObject.CallObject(const args: IPyObject): IPyObject;
begin
  if Initialized and
     assigned(PyObject_CallObject) then
    begin
      if TPyObject.IsInitialized(args) then
        Result := TPyObject.Wrap(PyObject_CallObject(PyObject, args.PyObject))
       else
        Result := TPyObject.Wrap(PyObject_CallObject(PyObject, nil));
    end
   else
    Result := nil;
end;

function TPyObject.Vectorcall(const args: IPyObjectArray; const kwnames: IPyObject): IPyObject;
var
  TempArgs : PPyObjectArray;
  TempArgsPtr : PPPyObject;
  TempArgsLen, i : integer;
  TempKwnames : PPyObject;
begin
  Result := nil;

  if Initialized and
     assigned(PyObject_Vectorcall) then
    begin
      TempArgsLen := System.length(args);
      if (TempArgsLen > 0) then
        begin
          SetLength(TempArgs, TempArgsLen);

          for i := 0 to pred(TempArgsLen) do
            TempArgs[i] := args[i].PyObject;

          TempArgsPtr := @TempArgs[0];
        end
       else
        TempArgsPtr := nil;

      if TPyObject.IsInitialized(kwnames) then
        TempKwnames := kwnames.PyObject
       else
        TempKwnames := nil;

      Result := TPyObject.Wrap(PyObject_Vectorcall(PyObject, TempArgsPtr, TempArgsLen, TempKwnames));
    end;
end;

class function TPyObject.VectorcallMethod(const name: IPyObject; const args: IPyObjectArray; const kwnames: IPyObject): IPyObject;
var
  TempArgs : PPyObjectArray;
  TempArgsPtr : PPPyObject;
  TempArgsLen, i : integer;
  TempKwnames : PPyObject;
begin
  Result := nil;

  if assigned(PyObject_VectorcallMethod) and
     TPyObject.IsInitialized(name) then
    begin
      TempArgsLen := System.length(args);
      if (TempArgsLen > 0) then
        begin
          SetLength(TempArgs, TempArgsLen);

          for i := 0 to pred(TempArgsLen) do
            TempArgs[i] := args[i].PyObject;

          TempArgsPtr := @TempArgs[0];
        end
       else
        TempArgsPtr := nil;

      if TPyObject.IsInitialized(kwnames) then
        TempKwnames := kwnames.PyObject
       else
        TempKwnames := nil;

      Result := TPyObject.Wrap(PyObject_VectorcallMethod(name.PyObject, TempArgsPtr, TempArgsLen, TempKwnames));
    end;
end;

function TPyObject.UnWrap: Pointer;
begin
  Result       := PyObject;
  FObjRefOwner := False;
end;

function TPyObject.IsType(aPyTypeObject: PPyTypeObject): boolean;
begin
  Result := (aPyTypeObject <> nil) and (GetPyTypeObject = aPyTypeObject);
end;

function TPyObject.TypeCheck(aPyTypeObject: PPyTypeObject): boolean;
begin
  Result := IsType(aPyTypeObject) or
            TPyTypeObject.IsSubtype(GetPyTypeObject, aPyTypeObject);
end;

procedure TPyObject.InitPyObject;
begin
  PyObject     := nil;
  FObjRefOwner := False;
end;

function TPyObject.IsInstance(const cls: IPyObject): integer;
begin
  if Initialized and
     assigned(PyObject_IsInstance) and
     TPyObject.IsInitialized(cls) then
    Result := PyObject_IsInstance(PyObject, cls.PyObject)
   else
    Result := -1;
end;

function TPyObject.IsSubclass(const cls: IPyObject): integer;
begin
  if Initialized and
     assigned(PyObject_IsSubclass) and
     TPyObject.IsInitialized(cls) then
    Result := PyObject_IsSubclass(PyObject, cls.PyObject)
   else
    Result := -1;
end;

function TPyObject.GenericGetDict(context: Pointer): IPyObject;
begin
  if initialized and
     assigned(PyObject_GenericGetDict) then
    Result := Wrap(PyObject_GenericGetDict(PyObject, context))
   else
    Result := nil;
end;

function TPyObject.CheckBuffer: boolean;
begin
  Result := Initialized and
            assigned(PyObject_CheckBuffer) and
            (PyObject_CheckBuffer(PyObject) <> 0);
end;

function TPyObject.GetBuffer(var view: Py_buffer; flags: Integer): boolean;
begin
  Result := Initialized and
            assigned(PyObject_GetBuffer) and
            (PyObject_GetBuffer(PyObject, @view, flags) = 0);
end;

function TPyObject.CopyData(const src: IPyObject): boolean;
begin
  Result := Initialized and
            IsInitialized(src) and
            assigned(PyObject_CopyData) and
            (PyObject_CopyData(PyObject, src.PyObject) = 0);
end;

function TPyObject.Repr: IPyObject;
begin
  if initialized and
     assigned(PyObject_Repr) then
    Result := Wrap(PyObject_Repr(PyObject))
   else
    Result := nil;
end;

function TPyObject.Str: IPyObject;
begin
  if initialized and
     assigned(PyObject_Str) then
    Result := Wrap(PyObject_Str(PyObject))
   else
    Result := nil;
end;

function TPyObject.ASCII: IPyObject;
begin
  if initialized and
     assigned(PyObject_ASCII) then
    Result := Wrap(PyObject_ASCII(PyObject))
   else
    Result := nil;
end;

function TPyObject.Bytes: IPyObject;
begin
  if initialized and
     assigned(PyObject_Bytes) then
    Result := Wrap(PyObject_Bytes(PyObject))
   else
    Result := nil;
end;

function TPyObject.RichCompare(const obj: IPyObject; opid: integer): IPyObject;
begin
  if Initialized and
     assigned(PyObject_RichCompare) and
     IsInitialized(obj) and
     (opid in [Py_LT..Py_GE]) then
    Result := Wrap(PyObject_RichCompare(PyObject, obj.PyObject, opid))
   else
    Result := nil;
end;

function TPyObject.RichCompareBool(const obj: IPyObject; opid: integer): integer;
begin
  if Initialized and
     assigned(PyObject_RichCompareBool) and
     IsInitialized(obj) and
     (opid in [Py_LT..Py_GE]) then
    Result := PyObject_RichCompareBool(PyObject, obj.PyObject, opid)
   else
    Result := -1;
end;

function TPyObject.GetAttrString(const attr_name: string): IPyObject;
begin
  Result := Wrap(GetAttrString2(attr_name));
end;

function TPyObject.GetAttrString2(const attr_name: string): Pointer;
var
  TempName : AnsiString;
begin
  if Initialized and assigned(PyObject_GetAttrString) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := PyObject_GetAttrString(PyObject, PAnsiChar(TempName))
    end
   else
    Result := nil;
end;

function TPyObject.SetAttrString(const attr_name: string; const value: IPyObject): boolean;
begin
  Result := assigned(value) and
            SetAttrString2(attr_name, value.PyObject);
end;

function TPyObject.SetAttrString2(const attr_name: string; value: Pointer): boolean;
var
  TempName : AnsiString;
begin
  if Initialized and
     assigned(PyObject_SetAttrString) and
     assigned(value) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := (PyObject_SetAttrString(PyObject, PAnsiChar(TempName), value) = 0)
    end
   else
    Result := False;
end;

function TPyObject.DelAttrString(const attr_name: string): boolean;
var
  TempName : AnsiString;
begin
  if Initialized and assigned(PyObject_DelAttrString) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := (PyObject_DelAttrString(PyObject, PAnsiChar(TempName)) = 0)
    end
   else
    Result := False;
end;

function TPyObject.HasAttrString(const attr_name: string): boolean;
var
  TempName : AnsiString;
begin
  if Initialized and assigned(PyObject_HasAttrString) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := (PyObject_HasAttrString(PyObject, PAnsiChar(TempName)) <> 0)
    end
   else
    Result := False;
end;

function TPyObject.GetAttr(const attr_name: IPyObject): IPyObject;
begin
  if Initialized and
     assigned(PyObject_GetAttr) and
     IsInitialized(attr_name) then
    Result := Wrap(PyObject_GetAttr(PyObject, attr_name.PyObject))
   else
    Result := nil;
end;

function TPyObject.GetOptionalAttr(const attr_name: IPyObject; out result_: IPyObject): boolean;
var
  TempPointer : Pointer;
begin
  if GetOptionalAttr2(attr_name, TempPointer) then
    begin
      Result  := True;
      result_ := Wrap(TempPointer);
    end
   else
    Result := False;
end;

function TPyObject.GetOptionalAttr2(const attr_name: IPyObject; out result_: Pointer): boolean;
var
  TempObj : PPyObject;
begin
  if Initialized and
     assigned(PyObject_GetOptionalAttr) and
     IsInitialized(attr_name) then
    begin
      Result  := (PyObject_GetOptionalAttr(PyObject, attr_name.PyObject, @TempObj) <> 0);
      result_ := TempObj;
    end
   else
    Result := False;
end;

function TPyObject.GetOptionalAttrString(const attr_name: string; out result_: IPyObject): boolean;
var
  TempPointer : Pointer;
begin
  if GetOptionalAttrString2(attr_name, TempPointer) then
    begin
      Result  := True;
      result_ := Wrap(TempPointer);
    end
   else
    Result := False;
end;

function TPyObject.GetOptionalAttrString2(const attr_name: string; out result_: Pointer): boolean;
var
  TempObj  : PPyObject;
  TempName : AnsiString;
begin
  if Initialized and
     assigned(PyObject_GetOptionalAttrString) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := (PyObject_GetOptionalAttrString(PyObject, PAnsiChar(TempName), @TempObj) <> 0);
      result_  := TempObj;
    end
   else
    Result := False;
end;

function TPyObject.SetAttr(const attr_name, value: IPyObject): boolean;
begin
  Result := assigned(attr_name) and
            assigned(value) and
            SetAttr2(attr_name, value.PyObject);
end;

function TPyObject.SetAttr2(const attr_name: IPyObject; value: Pointer): boolean;
begin
  if Initialized and
     assigned(PyObject_SetAttr) and
     IsInitialized(attr_name) and
     assigned(value) then
    Result := (PyObject_SetAttr(PyObject, attr_name.PyObject, value) = 0)
   else
    Result := False;
end;

function TPyObject.DelAttr(const attr_name: IPyObject): boolean;
begin
  if Initialized and
     assigned(PyObject_DelAttr) and
     IsInitialized(attr_name) then
    Result := (PyObject_DelAttr(PyObject, attr_name.PyObject) = 0)
   else
    Result := False;
end;

function TPyObject.HasAttr(const attr_name: IPyObject): boolean;
begin
  if Initialized and
     assigned(PyObject_HasAttr) and
     IsInitialized(attr_name) then
    Result := (PyObject_HasAttr(PyObject, attr_name.PyObject) <> 0)
   else
    Result := False;
end;

function TPyObject.HasAttrWithError(const attr_name: IPyObject): integer;
begin
  if Initialized and
     assigned(PyObject_HasAttr) and
     IsInitialized(attr_name) then
    Result := PyObject_HasAttr(PyObject, attr_name.PyObject)
   else
    Result := -1;
end;

function TPyObject.HasAttrStringWithError(const attr_name: string): integer;
var
  TempName : AnsiString;
begin
  if Initialized and assigned(PyObject_HasAttrString) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := PyObject_HasAttrString(PyObject, PAnsiChar(TempName))
    end
   else
    Result := -1;
end;

function TPyObject.SelfIter: IPyObject;
begin
  if Initialized and
     assigned(PyObject_SelfIter) then
    Result := Wrap(PyObject_SelfIter(PyObject))
   else
    Result := nil;
end;

function TPyObject.GenericGetAttr(const name_: IPyObject): IPyObject;
begin
  Result := Wrap(GenericGetAttr2(name_));
end;

function TPyObject.GenericGetAttr2(const name_: IPyObject): Pointer;
begin
  if Initialized and
     assigned(PyObject_GenericGetAttr) and
     IsInitialized(name_) then
    Result := PyObject_GenericGetAttr(PyObject, name_.PyObject)
   else
    Result := nil;
end;

function TPyObject.GenericSetAttr(const name_, value: IPyObject): boolean;
begin
  Result := assigned(value) and
            GenericSetAttr2(name_, value.PyObject);
end;

function TPyObject.GenericSetAttr2(const name_: IPyObject; value: Pointer): boolean;
begin
  if Initialized and
     assigned(PyObject_GenericSetAttr) and
     IsInitialized(name_) and
     assigned(value) then
    Result := (PyObject_GenericSetAttr(PyObject, name_.PyObject, value) = 0)
   else
    Result := False;
end;

function TPyObject.GenericSetDict(const value: IPyObject; context: Pointer): boolean;
begin
  if Initialized and
     assigned(PyObject_GenericSetDict) and
     IsInitialized(value) then
    Result := (PyObject_GenericSetDict(PyObject, value.PyObject, context) = 0)
   else
    Result := False;
end;

function TPyObject.Hash: Py_hash_t;
begin
  if Initialized and assigned(PyObject_Hash) then
    Result := PyObject_Hash(PyObject)
   else
    Result := -1;
end;

function TPyObject.HashNotImplemented: Py_hash_t;
begin
  if Initialized and assigned(PyObject_HashNotImplemented) then
    Result := PyObject_HashNotImplemented(PyObject)
   else
    Result := -1;
end;

function TPyObject.IsTrue: integer;
begin
  if Initialized and assigned(PyObject_IsTrue) then
    Result := PyObject_IsTrue(PyObject)
   else
    Result := -1;
end;

function TPyObject.Not_: integer;
begin
  if Initialized and assigned(PyObject_Not) then
    Result := PyObject_Not(PyObject)
   else
    Result := -1;
end;

procedure TPyObject.ClearWeakRefs;
begin
  if Initialized and assigned(PyObject_ClearWeakRefs) then
    PyObject_ClearWeakRefs(PyObject);
end;

function TPyObject.Dir: IPyObject;
begin
  if Initialized and
     assigned(PyObject_Dir) then
    Result := Wrap(PyObject_Dir(PyObject))
   else
    Result := nil;
end;

function TPyObject.ReprEnter: boolean;
begin
  Result := TPy.ReprEnter(self);
end;

procedure TPyObject.ReprLeave;
begin
  TPy.ReprLeave(self);
end;

function TPyObject.Print(file_: PFILE; flags: integer): boolean;
begin
  Result := Initialized and
            assigned(PyObject_Print) and
            assigned(file_) and
            (PyObject_Print(PyObject, file_, flags) = 0);
end;

procedure TPyObject.CallFinalizer;
begin
  if Initialized and assigned(PyObject_CallFinalizer) then
    PyObject_CallFinalizer(PyObject);
end;

function TPyObject.CallFinalizerFromDealloc: boolean;
begin
  Result := Initialized and
            assigned(PyObject_CallFinalizerFromDealloc) and
            (PyObject_CallFinalizerFromDealloc(PyObject) = 0);
end;

function TPyObject.GetItemData: Pointer;
begin
  if Initialized and assigned(PyObject_GetItemData) then
    Result := PyObject_GetItemData(PyObject)
   else
    Result := nil;
end;

function TPyObject.VisitManagedDict(visit: visitproc; arg: Pointer): integer;
begin
  if Initialized and assigned(PyObject_VisitManagedDict) then
    Result := PyObject_VisitManagedDict(PyObject, visit, arg)
   else
    Result := 0;
end;

procedure TPyObject.ClearManagedDict;
begin
  if Initialized and assigned(PyObject_ClearManagedDict) then
    PyObject_ClearManagedDict(PyObject);
end;

procedure TPyObject.GC_Track;
begin
  if Initialized and assigned(PyObject_GC_Track) then
    PyObject_GC_Track(PyObject);
end;

procedure TPyObject.GC_UnTrack;
begin
  if Initialized and assigned(PyObject_GC_UnTrack) then
    PyObject_GC_UnTrack(PyObject);
end;

function TPyObject.GC_IsTracked: boolean;
begin
  Result := Initialized and
            assigned(PyObject_GC_IsTracked) and
            (PyObject_GC_IsTracked(PyObject) <> 0);
end;

function TPyObject.GC_IsFinalized: boolean;
begin
  Result := Initialized and
            assigned(PyObject_GC_IsFinalized) and
            (PyObject_GC_IsFinalized(PyObject) <> 0);
end;

function TPyObject.IS_GC: boolean;
begin
  Result := Initialized and
            assigned(PyObject_IS_GC) and
            (PyObject_IS_GC(PyObject) <> 0);
end;

function TPyObject.GenericHash: Py_hash_t;
begin
  if Initialized and assigned(PyObject_GenericHash) then
    Result := PyObject_GenericHash(PyObject)
   else
    Result := -1;
end;

function TPyObject.AsFileDescriptor: integer;
begin
  if Initialized and assigned(PyObject_AsFileDescriptor) then
    Result := PyObject_AsFileDescriptor(PyObject)
   else
    Result := -1;
end;

function TPyObject.Type_: IPyObject;
begin
  if Initialized and assigned(PyObject_Type) then
    Result := TPyObject.Wrap(PyObject_Type(FPyObject))
   else
    Result := nil;
end;

function TPyObject.Size: Py_ssize_t;
begin
  if Initialized and assigned(PyObject_Size) then
    Result := PyObject_Size(FPyObject)
   else
    Result := -1;
end;

function TPyObject.Length: Py_ssize_t;
begin
  if Initialized and assigned(PyObject_Length) then
    Result := PyObject_Length(FPyObject)
   else
    Result := -1;
end;

function TPyObject.GetItem(const key: IPyObject): IPyObject;
begin
  if Initialized and
     assigned(PyObject_GetItem) and
     TPyObject.IsInitialized(key) then
    Result := TPyObject.Wrap(PyObject_GetItem(FPyObject, key.PyObject))
   else
    Result := nil;
end;

function TPyObject.SetItem(const key, v: IPyObject): boolean;
begin
  Result := Initialized and
            assigned(PyObject_SetItem) and
            TPyObject.IsInitialized(key) and
            TPyObject.IsInitialized(v) and
            (PyObject_SetItem(FPyObject, key.PyObject, v.PyObject) = 0);
end;

function TPyObject.DelItemString(const key: string): boolean;
var
  TempKey : AnsiString;
begin
  if Initialized and
     assigned(PyObject_DelItemString) then
    begin
      TempKey := StringToPyUTF8(key);
      Result  := (PyObject_DelItemString(FPyObject, PAnsiChar(TempKey)) <> -1);
    end
   else
    Result := False;
end;

function TPyObject.DelItem(const key: IPyObject): boolean;
begin
  Result := Initialized and
            assigned(PyObject_DelItem) and
            TPyObject.IsInitialized(key) and
            (PyObject_DelItem(FPyObject, key.PyObject) <> -1);
end;

function TPyObject.Format(const format_spec: IPyObject): IPyObject;
begin
  Result := nil;

  if Initialized and
     assigned(PyObject_Format) then
    begin
      if TPyObject.IsInitialized(format_spec) then
        Result := TPyObject.Wrap(PyObject_Format(FPyObject, format_spec.PyObject))
       else
        Result := TPyObject.Wrap(PyObject_Format(FPyObject, nil));
    end;
end;

function TPyObject.GetIter: IPyObject;
begin
  if Initialized and
     assigned(PyObject_GetIter) then
    Result := TPyObject.Wrap(PyObject_GetIter(FPyObject))
   else
    Result := nil;
end;

function TPyObject.GetAIter: IPyObject;
begin
  if Initialized and
     assigned(PyObject_GetAIter) then
    Result := TPyObject.Wrap(PyObject_GetAIter(FPyObject))
   else
    Result := nil;
end;

function TPyObject.LengthHint(defaultvalue: Py_ssize_t): Py_ssize_t;
begin
  if Initialized and
     assigned(PyObject_LengthHint) then
    Result := PyObject_LengthHint(FPyObject, defaultvalue)
   else
    Result := -1;
end;

function TPyObject.VectorcallDict(const args: IPyObjectArray; const kwargs: IPyObject): IPyObject;
var
  TempArgs : PPyObjectArray;
  TempArgsPtr : PPPyObject;
  TempArgsLen, i : integer;
  TempKwargsPtr : PPyObject;
begin
  Result := nil;

  if Initialized and
     assigned(PyObject_VectorcallDict) then
    begin
      TempArgsLen := System.length(args);
      if (TempArgsLen > 0) then
        begin
          SetLength(TempArgs, TempArgsLen);

          for i := 0 to pred(TempArgsLen) do
            TempArgs[i] := args[i].PyObject;

          TempArgsPtr := @TempArgs[0];
        end
       else
        TempArgsPtr := nil;

      if TPyObject.IsInitialized(kwargs) then
        TempKwargsPtr := kwargs.PyObject
       else
        TempKwargsPtr := nil;

      Result := TPyObject.Wrap(PyObject_VectorcallDict(PyObject, TempArgsPtr, TempArgsLen, TempKwargsPtr));
    end;
end;

function TPyObject.CallOneArg(const arg: IPyObject): IPyObject;
begin
  if Initialized and
     assigned(PyObject_CallOneArg) and
     TPyObject.IsInitialized(arg) then
    Result := TPyObject.Wrap(PyObject_CallOneArg(PyObject, arg.PyObject))
   else
    Result := nil;
end;


class function TPyObject.GC_Resize(varobj: PPyVarObject; size_: Py_ssize_t): PPyVarObject;
begin
  if assigned(PyObject_GC_Resize) then
    Result := PyObject_GC_Resize(varobj, size_)
   else
    Result := nil;
end;

class function TPyObject.GC_New(typeobj: PPyTypeObject): IPyObject;
begin
  if assigned(PyObject_GC_New) then
    Result := TPyObject.Wrap(PyObject_GC_New(typeobj))
   else
    Result := nil;
end;

class function TPyObject.GC_NewVar(typeobj: PPyTypeObject; size_: Py_ssize_t): PPyVarObject;
begin
  if assigned(PyObject_GC_NewVar) then
    Result := PyObject_GC_NewVar(typeobj, size_)
   else
    Result := nil;
end;

class procedure TPyObject.GC_Del(ptr: pointer);
begin
  if assigned(PyObject_GC_Del) and assigned(ptr) then
    PyObject_GC_Del(ptr);
end;

class procedure TPyObject.GetArenaAllocator(allocator: PPyObjectArenaAllocator);
begin
  if assigned(PyObject_GetArenaAllocator) then
    PyObject_GetArenaAllocator(allocator);
end;

class procedure TPyObject.SetArenaAllocator(allocator: PPyObjectArenaAllocator);
begin
  if assigned(PyObject_SetArenaAllocator) then
    PyObject_SetArenaAllocator(allocator);
end;

function TPyObject.GetInitialized: boolean;
begin
  Result := assigned(FPyObject);
end;

function TPyObject.GetPyObject: PPyObject;
begin
  Result := FPyObject;
end;

function TPyObject.GetRefCnt: integer;
begin
  Result := TPy.RefCnt(self);
end;

function TPyObject.GetObjRefOwner: boolean;
begin
  Result := FObjRefOwner;
end;

function TPyObject.IsTrueSingleton: boolean;
begin
  Result := TPy.IsTrue(self);
end;

function TPyObject.IsFalseSingleton: boolean;
begin
  Result := TPy.IsFalse(self);
end;

function TPyObject.IsNoneSingleton: boolean;
begin
  Result := TPy.IsNone(self);
end;

function TPyObject.GetPyTypeObject: PPyTypeObject;
begin
  Result := TPy.Type_(self);
end;

function TPyObject.GetTypeData(const cls: PyTypeObject): Pointer;
begin
  if Initialized and assigned(PyObject_GetTypeData) then
    Result := PyObject_GetTypeData(PyObject, @cls)
   else
    Result := nil;
end;

function TPyObject.GetAsString: string;
var
  TempStr : IPyObject;
begin
  if TPyUnicode.Check(self) then
    Result := PyUTF8ToString(TPyUnicode.AsUTF8(self))
   else
    if TPyBytes.Check(self) then
      Result := TPyBytes.AsString(self)
     else
      begin
        TempStr := self.Str;

        if TPyUnicode.Check(TempStr) then
          Result := PyUTF8ToString(TPyUnicode.AsUTF8(TempStr));
      end;
end;

function TPyObject.GetAsVariant: Variant;
begin
  //
end;

procedure TPyObject.SetObjRefOwner(aValue: boolean);
begin
  FObjRefOwner := aValue;
end;

procedure TPyObject.SetPyObject(aValue: PPyObject);
begin
  PyObject := aValue;
end;

procedure TPyObject.IncRef;
begin
  TPy.IncRef(self);
end;

procedure TPyObject.DecRef;
begin
  TPy.DecRef(self);
end;

function TPyObject.NewRef: Pointer;
begin
  Result := TPy.NewRef(IPyObject(self));
end;

function TPyObject.XNewRef: Pointer;
begin
  Result := TPy.XNewRef(IPyObject(self));
end;

function TPyObject.SameAs(const other: IPyObject): boolean;
begin
  Result := TPy.Is_(self, other);
end;

function TPyObject.SameAs(const other: PPyObject): boolean;
begin
  Result := Initialized and TPy.Is_(PyObject, other);
end;

end.

