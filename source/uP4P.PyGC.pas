unit uP4P.PyGC;

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
  TPyGC = class
    public
      class function Collect: Py_ssize_t;
      class function Enable: boolean;
      class function Disable: boolean;
      class function IsEnabled: boolean;
      class function Resize(varobj: PPyVarObject; size: Py_ssize_t): PPyVarObject;
      class function New(type_: PPyTypeObject): IPyObject;
      class function NewVar(type_: PPyTypeObject; size: Py_ssize_t): PPyVarObject;
      class procedure Del(ptr: pointer);
      class procedure GetArenaAllocator(allocator: PPyObjectArenaAllocator);
      class procedure SetArenaAllocator(allocator: PPyObjectArenaAllocator);
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPyGC.Collect: Py_ssize_t;
begin
  if assigned(PyGC_Collect) then
    Result := PyGC_Collect()
   else
    Result := 0;
end;

class function TPyGC.Enable: boolean;
begin
  Result := assigned(PyGC_Enable) and (PyGC_Enable() <> 0);
end;

class function TPyGC.Disable: boolean;
begin
  Result := assigned(PyGC_Disable) and (PyGC_Disable() <> 0);
end;

class function TPyGC.IsEnabled: boolean;
begin
  Result := assigned(PyGC_IsEnabled) and (PyGC_IsEnabled() <> 0);
end;

class function TPyGC.Resize(varobj: PPyVarObject; size: Py_ssize_t): PPyVarObject;
begin
  if assigned(_PyObject_GC_Resize) then
    Result := _PyObject_GC_Resize(varobj, size)
   else
    Result := nil;
end;

class function TPyGC.New(type_: PPyTypeObject): IPyObject;
begin
  if assigned(_PyObject_GC_New) then
    Result := TPyObject.Wrap(_PyObject_GC_New(type_))
   else
    Result := nil;
end;

class function TPyGC.NewVar(type_: PPyTypeObject; size: Py_ssize_t): PPyVarObject;
begin
  if assigned(_PyObject_GC_NewVar) then
    Result := _PyObject_GC_NewVar(type_, size)
   else
    Result := nil;
end;

class procedure TPyGC.Del(ptr: pointer);
begin
  if assigned(PyObject_GC_Del) and assigned(ptr) then
    PyObject_GC_Del(ptr);
end;

class procedure TPyGC.GetArenaAllocator(allocator: PPyObjectArenaAllocator);
begin
  if assigned(PyObject_GetArenaAllocator) then
    PyObject_GetArenaAllocator(allocator);
end;

class procedure TPyGC.SetArenaAllocator(allocator: PPyObjectArenaAllocator);
begin
  if assigned(PyObject_SetArenaAllocator) then
    PyObject_SetArenaAllocator(allocator);
end;

end.
