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

      function  GetPyObject: PPyObject;
      function  GetInitialized: boolean;
      function  GetRefCnt: integer;
      function  GetObjRefOwner: boolean;
      function  GetPyTypeObject: PPyTypeObject;
      function  GetTypeData(cls: PPyTypeObject): Pointer;

      procedure SetObjRefOwner(aValue: boolean);
      procedure SetPyObject(aValue: PPyObject);

      function  IsTrueSingleton: boolean;
      function  IsFalseSingleton: boolean;
      function  IsNoneSingleton: boolean;
      procedure IncRef;
      procedure DecRef;
      function  NewRef: Pointer;
      function  XNewRef: Pointer;
      function  SameAs(aPyObject: Pointer): boolean; overload;
      function  SameAs(const aPyObject: IPyObject): boolean; overload;
      function  IsType(aPyTypeObject: PPyTypeObject): boolean;
      function  TypeCheck(aPyTypeObject: PPyTypeObject): boolean;
      procedure InitPyObject;
      function  IsInstance(const aTypeOrClass: IPyObject): integer;
      function  IsSubclass(const aTypeOrClass: IPyObject): integer;
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
      function  SetAttrString(const attr_name: string; const value: IPyObject): boolean;
      function  DelAttrString(const attr_name: string): boolean;
      function  HasAttrString(const attr_name: string): boolean;
      function  GetAttr(const attr_name: IPyObject): IPyObject;
      function  GetOptionalAttr(const attr_name: IPyObject; out result_: IPyObject): boolean;
      function  GetOptionalAttrString(const attr_name: string; out result_: IPyObject): boolean;
      function  SetAttr(const attr_name, value: IPyObject): boolean;
      function  DelAttr(const attr_name: IPyObject): boolean;
      function  HasAttr(const attr_name: IPyObject): boolean;
      function  HasAttrWithError(const attr_name: IPyObject): integer;
      function  HasAttrStringWithError(const attr_name: string): integer;
      function  SelfIter: IPyObject;
      function  GenericGetAttr(const name_: IPyObject): IPyObject;
      function  GenericSetAttr(const name_, value: IPyObject): boolean;
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
      procedure Track;
      procedure UnTrack;
      function  IsTracked: boolean;
      function  IsFinalized: boolean;
      function  IS_GC: boolean;
      function  GenericHash: Py_hash_t;

      property Initialized : boolean   read GetInitialized;
      property PyObject    : PPyObject read GetPyObject    write SetPyObject;
      property ObjRefOwner : boolean   read GetObjRefOwner write SetObjRefOwner;
      property RefCnt      : integer   read GetRefCnt;

    public
      constructor Create(aPyObject: Pointer; aObjRefOwner, aUseNewRef: boolean);
      destructor  Destroy; override;
      function    UnWrap: Pointer;

      class function  Wrap(aPyObject: Pointer; aObjRefOwner: boolean = True; aUseNewRef: boolean = False): IPyObject; inline;
      class function  IsInitialized(const aPyObject: IPyObject): boolean; inline;
      class function  GetConstant(constant_id: cardinal): IPyObject;
      class function  GetConstantBorrowed(constant_id: cardinal): IPyObject;
      class function  Malloc(size: NativeUInt): pointer;
      class function  Calloc(nelem, elsize: NativeUInt): pointer;
      class function  Realloc(ptr: pointer; new_size: NativeUInt): pointer;
      class procedure FreePointer(ptr: pointer);
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

constructor TPyObject.Create(aPyObject: Pointer; aObjRefOwner, aUseNewRef: boolean);
begin
  inherited Create;

  if aUseNewRef and assigned(aPyObject) and assigned(Py_NewRef) then
    begin
      FPyObject    := Py_NewRef(aPyObject);
      FObjRefOwner := True;
    end
   else
    begin
      FPyObject    := aPyObject;
      FObjRefOwner := aObjRefOwner;
    end;
end;

destructor TPyObject.Destroy;
begin
  if FObjRefOwner then
    DecRef;

  inherited Destroy;
end;

class function TPyObject.Wrap(aPyObject: Pointer; aObjRefOwner: boolean = True; aUseNewRef: boolean = False): IPyObject;
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

class function TPyObject.GetConstant(constant_id: cardinal): IPyObject;
begin
  if assigned(Py_GetConstant) and
     (constant_id in [Py_CONSTANT_NONE..Py_CONSTANT_EMPTY_TUPLE]) then
    Result := Wrap(Py_GetConstant(constant_id))
   else
    Result := nil;
end;

class function TPyObject.GetConstantBorrowed(constant_id: cardinal): IPyObject;
begin
  if assigned(Py_GetConstantBorrowed) and
     (constant_id in [Py_CONSTANT_NONE..Py_CONSTANT_EMPTY_TUPLE]) then
    Result := Wrap(Py_GetConstantBorrowed(constant_id), False)
   else
    Result := nil;
end;

class function TPyObject.Malloc(size: NativeUInt): pointer;
begin
  if assigned(PyObject_Malloc) then
    Result := PyObject_Malloc(size)
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

class procedure TPyObject.FreePointer(ptr: pointer);
begin
  if assigned(PyObject_Free) then
    PyObject_Free(ptr);
end;

function TPyObject.UnWrap: Pointer;
begin
  Result       := FPyObject;
  FObjRefOwner := False;
end;

function TPyObject.IsType(aPyTypeObject: PPyTypeObject): boolean;
begin
  Result := (GetPyTypeObject = aPyTypeObject);
end;

function TPyObject.TypeCheck(aPyTypeObject: PPyTypeObject): boolean;
begin
  Result := IsType(aPyTypeObject) or
            TPyTypeObject.IsSubtype(GetPyTypeObject, aPyTypeObject);
end;

procedure TPyObject.InitPyObject;
begin
  FPyObject    := nil;
  FObjRefOwner := False;
end;

function TPyObject.IsInstance(const aTypeOrClass: IPyObject): integer;
begin
  if Initialized and
     assigned(PyObject_IsInstance) and
     assigned(aTypeOrClass) and
     aTypeOrClass.Initialized then
    Result := PyObject_IsInstance(FPyObject, aTypeOrClass.PyObject)
   else
    Result := 0;
end;

function TPyObject.IsSubclass(const aTypeOrClass: IPyObject): integer;
begin
  if Initialized and
     assigned(PyObject_IsSubclass) and
     assigned(aTypeOrClass) and
     aTypeOrClass.Initialized then
    Result := PyObject_IsSubclass(FPyObject, aTypeOrClass.PyObject)
   else
    Result := 0;
end;

function TPyObject.GenericGetDict(context: Pointer): IPyObject;
begin
  if initialized and
     assigned(PyObject_GenericGetDict) then
    Result := Wrap(PyObject_GenericGetDict(FPyObject, context))
   else
    Result := nil;
end;

function TPyObject.CheckBuffer: boolean;
begin
  Result := Initialized and
            assigned(PyObject_CheckBuffer) and
            (PyObject_CheckBuffer(FPyObject) <> 0);
end;

function TPyObject.GetBuffer(var view: Py_buffer; flags: Integer): boolean;
begin
  Result := Initialized and
            assigned(PyObject_GetBuffer) and
            (PyObject_GetBuffer(FPyObject, @view, flags) = 0);
end;

function TPyObject.CopyData(const src: IPyObject): boolean;
begin
  Result := Initialized and
            IsInitialized(src) and
            assigned(PyObject_CopyData) and
            (PyObject_CopyData(FPyObject, src.PyObject) = 0);
end;

function TPyObject.Repr: IPyObject;
begin
  if initialized and
     assigned(PyObject_Repr) then
    Result := Wrap(PyObject_Repr(FPyObject))
   else
    Result := nil;
end;

function TPyObject.Str: IPyObject;
begin
  if initialized and
     assigned(PyObject_Str) then
    Result := Wrap(PyObject_Str(FPyObject))
   else
    Result := nil;
end;

function TPyObject.ASCII: IPyObject;
begin
  if initialized and
     assigned(PyObject_ASCII) then
    Result := Wrap(PyObject_ASCII(FPyObject))
   else
    Result := nil;
end;

function TPyObject.Bytes: IPyObject;
begin
  if initialized and
     assigned(PyObject_Bytes) then
    Result := Wrap(PyObject_Bytes(FPyObject))
   else
    Result := nil;
end;

function TPyObject.RichCompare(const obj: IPyObject; opid: integer): IPyObject;
begin
  if Initialized and
     assigned(PyObject_RichCompare) and
     IsInitialized(obj) and
     (opid in [Py_LT..Py_GE]) then
    Result := Wrap(PyObject_RichCompare(FPyObject, obj.PyObject, opid))
   else
    Result := nil;
end;

function TPyObject.RichCompareBool(const obj: IPyObject; opid: integer): integer;
begin
  if Initialized and
     assigned(PyObject_RichCompareBool) and
     IsInitialized(obj) and
     (opid in [Py_LT..Py_GE]) then
    Result := PyObject_RichCompareBool(FPyObject, obj.PyObject, opid)
   else
    Result := -1;
end;

function TPyObject.GetAttrString(const attr_name: string): IPyObject;
var
  TempName : AnsiString;
begin
  if Initialized and assigned(PyObject_GetAttrString) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := Wrap(PyObject_GetAttrString(FPyObject, PAnsiChar(TempName)))
    end
   else
    Result := nil;
end;

function TPyObject.SetAttrString(const attr_name: string; const value: IPyObject): boolean;
var
  TempName : AnsiString;
begin
  if Initialized and
     assigned(PyObject_SetAttrString) and
     IsInitialized(value) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := (PyObject_SetAttrString(FPyObject, PAnsiChar(TempName), value.PyObject) = 0)
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
      Result   := (PyObject_DelAttrString(FPyObject, PAnsiChar(TempName)) = 0)
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
      Result   := (PyObject_HasAttrString(FPyObject, PAnsiChar(TempName)) <> 0)
    end
   else
    Result := False;
end;

function TPyObject.GetAttr(const attr_name: IPyObject): IPyObject;
begin
  if Initialized and
     assigned(PyObject_GetAttr) and
     IsInitialized(attr_name) then
    Result := Wrap(PyObject_GetAttr(FPyObject, attr_name.PyObject))
   else
    Result := nil;
end;

function TPyObject.GetOptionalAttr(const attr_name: IPyObject; out result_: IPyObject): boolean;
var
  TempObj : PPyObject;
begin
  if Initialized and
     assigned(PyObject_GetOptionalAttr) and
     IsInitialized(attr_name) then
    begin
      Result  := (PyObject_GetOptionalAttr(FPyObject, attr_name.PyObject, @TempObj) <> 0);
      result_ := Wrap(TempObj);
    end
   else
    Result := False;
end;

function TPyObject.GetOptionalAttrString(const attr_name: string; out result_: IPyObject): boolean;
var
  TempObj  : PPyObject;
  TempName : AnsiString;
begin
  if Initialized and
     assigned(PyObject_GetOptionalAttrString) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := (PyObject_GetOptionalAttrString(FPyObject, PAnsiChar(TempName), @TempObj) <> 0);
      result_  := Wrap(TempObj);
    end
   else
    Result := False;
end;

function TPyObject.SetAttr(const attr_name, value: IPyObject): boolean;
begin
  if Initialized and
     assigned(PyObject_SetAttr) and
     IsInitialized(attr_name) and
     IsInitialized(value) then
    Result := (PyObject_SetAttr(FPyObject, attr_name.PyObject, value.PyObject) = 0)
   else
    Result := False;
end;

function TPyObject.DelAttr(const attr_name: IPyObject): boolean;
begin
  if Initialized and
     assigned(PyObject_DelAttr) and
     IsInitialized(attr_name) then
    Result := (PyObject_DelAttr(FPyObject, attr_name.PyObject) = 0)
   else
    Result := False;
end;

function TPyObject.HasAttr(const attr_name: IPyObject): boolean;
begin
  if Initialized and
     assigned(PyObject_HasAttr) and
     IsInitialized(attr_name) then
    Result := (PyObject_HasAttr(FPyObject, attr_name.PyObject) <> 0)
   else
    Result := False;
end;

function TPyObject.HasAttrWithError(const attr_name: IPyObject): integer;
begin
  if Initialized and
     assigned(PyObject_HasAttr) and
     IsInitialized(attr_name) then
    Result := PyObject_HasAttr(FPyObject, attr_name.PyObject)
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
      Result   := PyObject_HasAttrString(FPyObject, PAnsiChar(TempName))
    end
   else
    Result := -1;
end;

function TPyObject.SelfIter: IPyObject;
begin
  if Initialized and
     assigned(PyObject_SelfIter) then
    Result := Wrap(PyObject_SelfIter(FPyObject))
   else
    Result := nil;
end;

function TPyObject.GenericGetAttr(const name_: IPyObject): IPyObject;
begin
  if Initialized and
     assigned(PyObject_GenericGetAttr) and
     IsInitialized(name_) then
    Result := Wrap(PyObject_GenericGetAttr(FPyObject, name_.PyObject))
   else
    Result := nil;
end;

function TPyObject.GenericSetAttr(const name_, value: IPyObject): boolean;
begin
  if Initialized and
     assigned(PyObject_GenericSetAttr) and
     IsInitialized(name_) and
     IsInitialized(value) then
    Result := (PyObject_GenericSetAttr(FPyObject, name_.PyObject, value.PyObject) = 0)
   else
    Result := False;
end;

function TPyObject.GenericSetDict(const value: IPyObject; context: Pointer): boolean;
begin
  if Initialized and
     assigned(PyObject_GenericSetDict) and
     IsInitialized(value) then
    Result := (PyObject_GenericSetDict(FPyObject, value.PyObject, context) = 0)
   else
    Result := False;
end;

function TPyObject.Hash: Py_hash_t;
begin
  if Initialized and assigned(PyObject_Hash) then
    Result := PyObject_Hash(FPyObject)
   else
    Result := -1;
end;

function TPyObject.HashNotImplemented: Py_hash_t;
begin
  if Initialized and assigned(PyObject_HashNotImplemented) then
    Result := PyObject_HashNotImplemented(FPyObject)
   else
    Result := -1;
end;

function TPyObject.IsTrue: integer;
begin
  if Initialized and assigned(PyObject_IsTrue) then
    Result := PyObject_IsTrue(FPyObject)
   else
    Result := -1;
end;

function TPyObject.Not_: integer;
begin
  if Initialized and assigned(PyObject_Not) then
    Result := PyObject_Not(FPyObject)
   else
    Result := -1;
end;

procedure TPyObject.ClearWeakRefs;
begin
  if Initialized and assigned(PyObject_ClearWeakRefs) then
    PyObject_ClearWeakRefs(FPyObject);
end;

function TPyObject.Dir: IPyObject;
begin
  if Initialized and
     assigned(PyObject_Dir) then
    Result := Wrap(PyObject_Dir(FPyObject))
   else
    Result := nil;
end;

function TPyObject.ReprEnter: boolean;
begin
  Result := Initialized and
            assigned(Py_ReprEnter) and
            (Py_ReprEnter(FPyObject) = 0);
end;

procedure TPyObject.ReprLeave;
begin
  if Initialized and assigned(Py_ReprLeave) then
    Py_ReprLeave(FPyObject);
end;

function TPyObject.Print(file_: PFILE; flags: integer): boolean;
begin
  Result := Initialized and
            assigned(PyObject_Print) and
            assigned(file_) and
            (PyObject_Print(FPyObject, file_, flags) = 0);
end;

procedure TPyObject.CallFinalizer;
begin
  if Initialized and assigned(PyObject_CallFinalizer) then
    PyObject_CallFinalizer(FPyObject);
end;

function TPyObject.CallFinalizerFromDealloc: boolean;
begin
  Result := Initialized and
            assigned(PyObject_CallFinalizerFromDealloc) and
            (PyObject_CallFinalizerFromDealloc(FPyObject) = 0);
end;

function TPyObject.GetItemData: Pointer;
begin
  if Initialized and assigned(PyObject_GetItemData) then
    Result := PyObject_GetItemData(FPyObject)
   else
    Result := nil;
end;

function TPyObject.VisitManagedDict(visit: visitproc; arg: Pointer): integer;
begin
  if Initialized and assigned(PyObject_VisitManagedDict) then
    Result := PyObject_VisitManagedDict(FPyObject, visit, arg)
   else
    Result := 0;
end;

procedure TPyObject.ClearManagedDict;
begin
  if Initialized and assigned(PyObject_ClearManagedDict) then
    PyObject_ClearManagedDict(FPyObject);
end;

procedure TPyObject.Track;
begin
  if Initialized and assigned(PyObject_GC_Track) then
    PyObject_GC_Track(FPyObject);
end;

procedure TPyObject.UnTrack;
begin
  if Initialized and assigned(PyObject_GC_UnTrack) then
    PyObject_GC_UnTrack(FPyObject);
end;

function TPyObject.IsTracked: boolean;
begin
  Result := Initialized and
            assigned(PyObject_GC_IsTracked) and
            (PyObject_GC_IsTracked(FPyObject) <> 0);
end;

function TPyObject.IsFinalized: boolean;
begin
  Result := Initialized and
            assigned(PyObject_GC_IsFinalized) and
            (PyObject_GC_IsFinalized(FPyObject) <> 0);
end;

function TPyObject.IS_GC: boolean;
begin
  Result := Initialized and
            assigned(PyObject_IS_GC) and
            (PyObject_IS_GC(FPyObject) <> 0);
end;

function TPyObject.GenericHash: Py_hash_t;
begin
  if Initialized and assigned(PyObject_GenericHash) then
    Result := PyObject_GenericHash(FPyObject)
   else
    Result := -1;
end;

function TPyObject.GetInitialized: boolean;
begin
  Result := assigned(FPyObject);
end;

function TPyObject.GetPyObject: PPyObject;
begin
  Result := @FPyObject;
end;

function TPyObject.GetRefCnt: integer;
begin
  if Initialized and assigned(Py_REFCNT) then
    Result := Py_REFCNT(FPyObject)
   else
    Result := 0;
end;

function TPyObject.GetObjRefOwner: boolean;
begin
  Result := FObjRefOwner;
end;

function TPyObject.IsTrueSingleton: boolean;
begin
  Result :=  Initialized and
             assigned(Py_IsTrue) and
             (Py_IsTrue(FPyObject) <> 0);
end;

function TPyObject.IsFalseSingleton: boolean;
begin
  Result :=  Initialized and
             assigned(Py_IsFalse) and
             (Py_IsFalse(FPyObject) <> 0);
end;

function TPyObject.IsNoneSingleton: boolean;
begin
  Result :=  Initialized and
             assigned(Py_IsNone) and
             (Py_IsNone(FPyObject) <> 0);
end;

function TPyObject.GetPyTypeObject: PPyTypeObject;
begin
  if Initialized and assigned(Py_TYPE) then
    Result := Py_TYPE(FPyObject)
   else
    Result := nil;
end;

function TPyObject.GetTypeData(cls: PPyTypeObject): Pointer;
begin
  if Initialized and assigned(PyObject_GetTypeData) then
    Result := PyObject_GetTypeData(FPyObject, cls)
   else
    Result := nil;
end;

procedure TPyObject.SetObjRefOwner(aValue: boolean);
begin
  FObjRefOwner := aValue;
end;

procedure TPyObject.SetPyObject(aValue: PPyObject);
begin
  FPyObject := aValue;
end;

procedure TPyObject.IncRef;
begin
  if Initialized and assigned(Py_IncRef) then
    Py_IncRef(FPyObject);
end;

procedure TPyObject.DecRef;
begin
  if Initialized and assigned(Py_DecRef) then
    Py_DecRef(FPyObject);
end;

function TPyObject.NewRef: Pointer;
begin
  if Initialized and assigned(Py_NewRef) then
    Result := Py_NewRef(FPyObject)
   else
    Result := nil;
end;

function TPyObject.XNewRef: Pointer;
begin
  if assigned(Py_XNewRef) then
    Result := Py_XNewRef(FPyObject)
   else
    Result := nil;
end;

function TPyObject.SameAs(aPyObject: Pointer): boolean;
begin
  Result := Initialized and
            assigned(Py_Is) and
            (Py_Is(FPyObject, aPyObject) <> 0);
end;

function TPyObject.SameAs(const aPyObject: IPyObject): boolean;
begin
  Result := SameAs(aPyObject.PyObject);
end;

end.

