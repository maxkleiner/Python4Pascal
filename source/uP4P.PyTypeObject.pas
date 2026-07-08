unit uP4P.PyTypeObject;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
   TPyTypeObject = class
     public
       class function FromSpec(spec: PPyType_Spec): IPyObject;
       class function FromSpecWithBases(spec: PPyType_Spec; const bases: IPyObject): IPyObject;
       class function GetSlot(type_: PPyTypeObject; i: integer): Pointer;
       class function FromModuleAndSpec(const module: IPyObject; spec: PPyType_Spec; const bases: IPyObject): IPyObject;
       class function GetModule(type_: PPyTypeObject): IPyObject;
       class function GetModuleState(type_: PPyTypeObject): Pointer;
       class function GetName(type_: PPyTypeObject): IPyObject;
       class function GetQualName(type_: PPyTypeObject): IPyObject;
       class function GetFullyQualifiedName(type_: PPyTypeObject): IPyObject;
       class function GetModuleName(type_: PPyTypeObject): IPyObject;
       class function FromMetaclass(metaclass: PPyTypeObject; const module: IPyObject; spec: PPyType_Spec; const bases: IPyObject): IPyObject;
       class function GetTypeDataSize(cls: PPyTypeObject): Py_ssize_t;
       class function GetBaseByToken(type_: PPyTypeObject; token: Pointer; var result_: PPyTypeObject): integer;
       class function IsSubtype(type1, type2: PPyTypeObject): boolean; overload;
       class function IsSubtype(const aPyObject: IPyObject; type2: PPyTypeObject): boolean; overload;
       class function GetFlags(aPyTypeObject: PPyTypeObject): C_ULong;
       class function Ready(type_: PPyTypeObject): boolean;
       class function GenericAlloc(type_: PPyTypeObject; nitems: Py_ssize_t): IPyObject;
       class function GenericNew(type_: PPyTypeObject; const args, kwds: IPyObject): IPyObject;
       class procedure ClearCache;
       class procedure Modified(aPyTypeObject: PPyTypeObject);
       class function GetModuleByDef(type_: PPyTypeObject; def: PPyModuleDef): IPyObject;
       class function Freeze(type_: PPyTypeObject): boolean;
       class function GetDict(type_: PPyTypeObject): IPyObject;
       class function AddWatcher(callback: PyType_WatchCallback): integer;
       class function ClearWatcher(watcher_id: integer): boolean;
       class function Watch(watcher_id: integer; const type_: IPyObject): boolean;
       class function Unwatch(watcher_id: integer; const type_: IPyObject): boolean;
       class function SUPPORTS_WEAKREFS(type_: PPyTypeObject): boolean;
       class function HasFeature(aPyTypeObject: PPyTypeObject; feature: C_ULong): boolean;
       class function FastSubclass(aPyTypeObject: PPyTypeObject; feature: C_ULong): boolean;
       class function Check(const aPyObject: IPyObject): boolean;
       class function CheckExact(const aPyObject: IPyObject): boolean;
   end;

implementation

class function TPyTypeObject.FromSpec(spec: PPyType_Spec): IPyObject;
begin
  if assigned(PyType_FromSpec) then
    Result := TPyObject.Wrap(PyType_FromSpec(spec))
   else
    Result := nil;
end;

class function TPyTypeObject.FromSpecWithBases(spec: PPyType_Spec; const bases: IPyObject): IPyObject;
begin
  if assigned(PyType_FromSpecWithBases) and
     TPyObject.IsInitialized(bases) then
    Result := TPyObject.Wrap(PyType_FromSpecWithBases(spec, bases.PyObject))
   else
    Result := nil;
end;

class function TPyTypeObject.GetSlot(type_: PPyTypeObject; i: integer): Pointer;
begin
  if assigned(PyType_GetSlot) then
    Result := TPyObject.Wrap(PyType_GetSlot(type_, i))
   else
    Result := nil;
end;

class function TPyTypeObject.FromModuleAndSpec(const module: IPyObject; spec: PPyType_Spec; const bases: IPyObject): IPyObject;
var
  TempModule, TempBases: Pointer;
begin
  if assigned(PyType_FromModuleAndSpec) then
    begin
      if TPyObject.IsInitialized(module) then
        TempModule := module.PyObject
       else
        TempModule := nil;

      if TPyObject.IsInitialized(bases) then
        TempBases := bases.PyObject
       else
        TempBases := nil;

      Result := TPyObject.Wrap(PyType_FromModuleAndSpec(TempModule, spec, TempBases));
    end
   else
    Result := nil;
end;

class function TPyTypeObject.GetModule(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyType_GetModule) then
    Result := TPyObject.Wrap(PyType_GetModule(type_), False)
   else
    Result := nil;
end;

class function TPyTypeObject.GetModuleState(type_: PPyTypeObject): Pointer;
begin
  if assigned(PyType_GetModuleState) then
    Result := PyType_GetModuleState(type_)
   else
    Result := nil;
end;

class function TPyTypeObject.GetName(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyType_GetName) then
    Result := TPyObject.Wrap(PyType_GetName(type_))
   else
    Result := nil;
end;

class function TPyTypeObject.GetQualName(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyType_GetQualName) then
    Result := TPyObject.Wrap(PyType_GetQualName(type_))
   else
    Result := nil;
end;

class function TPyTypeObject.GetFullyQualifiedName(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyType_GetFullyQualifiedName) then
    Result := TPyObject.Wrap(PyType_GetFullyQualifiedName(type_))
   else
    Result := nil;
end;

class function TPyTypeObject.GetModuleName(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyType_GetModuleName) then
    Result := TPyObject.Wrap(PyType_GetModuleName(type_))
   else
    Result := nil;
end;

class function TPyTypeObject.FromMetaclass(metaclass: PPyTypeObject; const module: IPyObject; spec: PPyType_Spec; const bases: IPyObject): IPyObject;
var
  TempModule, TempBases: Pointer;
begin
  if assigned(PyType_FromMetaclass) then
    begin
      if TPyObject.IsInitialized(module) then
        TempModule := module.PyObject
       else
        TempModule := nil;

      if TPyObject.IsInitialized(bases) then
        TempBases := bases.PyObject
       else
        TempBases := nil;

      Result := TPyObject.Wrap(PyType_FromMetaclass(metaclass, TempModule, spec, TempBases));
    end
   else
    Result := nil;
end;

class function TPyTypeObject.GetTypeDataSize(cls: PPyTypeObject): Py_ssize_t;
begin
  if assigned(PyType_GetTypeDataSize) then
    Result := PyType_GetTypeDataSize(cls)
   else
    Result := 0;
end;

class function TPyTypeObject.GetBaseByToken(type_: PPyTypeObject; token: Pointer; var result_: PPyTypeObject): integer;
begin
  if assigned(PyType_GetBaseByToken) then
    Result := PyType_GetBaseByToken(type_, token, @result_)
   else
    Result := -1;
end;

class function TPyTypeObject.IsSubtype(const aPyObject: IPyObject; type2: PPyTypeObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            IsSubType(aPyObject.PyTypeObject, type2);
end;

class function TPyTypeObject.IsSubtype(type1, type2: PPyTypeObject): boolean;
begin
  Result := assigned(PyType_IsSubtype) and
            assigned(type1) and
            assigned(type2) and
            (PyType_IsSubtype(type1, type2) <> 0);
end;

class function TPyTypeObject.GetFlags(aPyTypeObject: PPyTypeObject): C_ULong;
begin
  if assigned(PyType_GetFlags) and
     assigned(aPyTypeObject) then
    Result := PyType_GetFlags(aPyTypeObject)
   else
    Result := 0;
end;

class function TPyTypeObject.Ready(type_: PPyTypeObject): boolean;
begin
  Result := assigned(PyType_Ready) and
            (PyType_Ready(type_) = 0);
end;

class function TPyTypeObject.GenericAlloc(type_: PPyTypeObject; nitems: Py_ssize_t): IPyObject;
begin
  if assigned(PyType_GenericAlloc) then
    Result := TPyObject.Wrap(PyType_GenericAlloc(type_, nitems))
   else
    Result := nil;
end;

class function TPyTypeObject.GenericNew(type_: PPyTypeObject; const args, kwds: IPyObject): IPyObject;
begin
  if assigned(PyType_GenericNew) and
     TPyObject.IsInitialized(args) and
     TPyObject.IsInitialized(kwds) then
    Result := TPyObject.Wrap(PyType_GenericNew(type_, args.PyObject, kwds.PyObject))
   else
    Result := nil;
end;

class procedure TPyTypeObject.ClearCache;
begin
  if assigned(PyType_ClearCache) then
    PyType_ClearCache();
end;

class procedure TPyTypeObject.Modified(aPyTypeObject: PPyTypeObject);
begin
  if assigned(PyType_Modified) and assigned(aPyTypeObject) then
    PyType_Modified(aPyTypeObject);
end;

class function TPyTypeObject.GetModuleByDef(type_: PPyTypeObject; def: PPyModuleDef): IPyObject;
begin
  if assigned(PyType_GetModuleByDef) then
    Result := TPyObject.Wrap(PyType_GetModuleByDef(type_, def), False)
   else
    Result := nil;
end;

class function TPyTypeObject.Freeze(type_: PPyTypeObject): boolean;
begin
  Result := assigned(PyType_Freeze) and
            (PyType_Freeze(type_) = 0);
end;

class function TPyTypeObject.GetDict(type_: PPyTypeObject): IPyObject;
begin
  if assigned(PyType_GetDict) then
    Result := TPyObject.Wrap(PyType_GetDict(type_))
   else
    Result := nil;
end;

class function TPyTypeObject.AddWatcher(callback: PyType_WatchCallback): integer;
begin
  if assigned(PyType_AddWatcher) then
    Result := PyType_AddWatcher(callback)
   else
    Result := -1;
end;

class function TPyTypeObject.ClearWatcher(watcher_id: integer): boolean;
begin
  Result := assigned(PyType_ClearWatcher) and
            (PyType_ClearWatcher(watcher_id) = 0);
end;

class function TPyTypeObject.Watch(watcher_id: integer; const type_: IPyObject): boolean;
begin
  Result := assigned(PyType_Watch) and
            TPyObject.IsInitialized(type_) and
            (PyType_Watch(watcher_id, type_.PyObject) <> 0);
end;

class function TPyTypeObject.Unwatch(watcher_id: integer; const type_: IPyObject): boolean;
begin
  Result := assigned(PyType_Unwatch) and
            TPyObject.IsInitialized(type_) and
            (PyType_Unwatch(watcher_id, type_.PyObject) <> 0);
end;

class function TPyTypeObject.SUPPORTS_WEAKREFS(type_: PPyTypeObject): boolean;
begin
  Result := assigned(PyType_SUPPORTS_WEAKREFS) and
            assigned(type_) and
            (PyType_SUPPORTS_WEAKREFS(type_) <> 0);
end;

class function TPyTypeObject.HasFeature(aPyTypeObject: PPyTypeObject; feature: C_ULong): boolean;
begin
  Result := assigned(aPyTypeObject) and ((GetFlags(aPyTypeObject) and feature) <> 0);
end;

class function TPyTypeObject.FastSubclass(aPyTypeObject: PPyTypeObject; feature: C_ULong): boolean;
begin
  Result := assigned(aPyTypeObject) and HasFeature(aPyTypeObject, feature);
end;

class function TPyTypeObject.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_TYPE_SUBCLASS));
end;

class function TPyTypeObject.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and aPyObject.IsType(PyType_Type);
end;

end.
