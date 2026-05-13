unit uP4P.PyList;

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
  TPyList = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function New(len: Py_ssize_t): IPyObject;
      class function Size(const list: IPyObject): Py_ssize_t;
      class function GetItem(const list: IPyObject; index: Py_ssize_t): IPyObject;
      class function GetItemRef(const list: IPyObject; index: Py_ssize_t): IPyObject;
      class function SetItem(const list: IPyObject; index: Py_ssize_t; const item: IPyObject): boolean;
      class function Insert(const list: IPyObject; index: Py_ssize_t; const item: IPyObject): boolean;
      class function Append(const list, item: IPyObject): boolean;
      class function GetSlice(const list: IPyObject; low, high: Py_ssize_t): IPyObject;
      class function SetSlice(const list: IPyObject; low, high: Py_ssize_t; const itemlist: IPyObject): boolean;
      class function Sort(const list: IPyObject): boolean;
      class function Reverse(const list: IPyObject): boolean;
      class function AsTuple(const list: IPyObject): IPyObject;
      class function Extend(const self_, iterable: IPyObject): boolean;
      class function Clear(const self_: IPyObject): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyTuple;

class function TPyList.New(len: Py_ssize_t): IPyObject;
begin
  if assigned(PyList_New) then
    Result := TPyObject.Wrap(PyList_New(len))
   else
    Result := nil;
end;

class function TPyList.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            TPyTypeObject.FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_LIST_SUBCLASS));
end;

class function TPyList.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyList_Type);
end;

class function TPyList.Size(const list: IPyObject): Py_ssize_t;
begin
  if assigned(PyList_Size) and
     TPyObject.IsInitialized(list) then
    Result := PyList_Size(list.PyObject)
   else
    Result := -1;
end;

class function TPyList.GetItem(const list: IPyObject; index: Py_ssize_t): IPyObject;
begin
  if assigned(PyList_GetItem) then
    Result := TPyObject.Wrap(PyList_GetItem(list.PyObject, index), False, False)
   else
    Result := nil;
end;

class function TPyList.GetItemRef(const list: IPyObject; index: Py_ssize_t): IPyObject;
begin
  if assigned(PyList_GetItemRef) then
    Result := TPyObject.Wrap(PyList_GetItemRef(list.PyObject, index))
   else
    Result := nil;
end;

class function TPyList.SetItem(const list: IPyObject; index: Py_ssize_t; const item: IPyObject): boolean;
begin
  Result := assigned(PyList_SetItem) and
            TPyObject.IsInitialized(list) and
            TPyObject.IsInitialized(item) and
            (PyList_SetItem(list.PyObject, index, item.UnWrap) = 0);
end;

class function TPyList.Insert(const list: IPyObject; index: Py_ssize_t; const item: IPyObject): boolean;
begin
  Result := assigned(PyList_Insert) and
            TPyObject.IsInitialized(list) and
            TPyObject.IsInitialized(item) and
            (PyList_Insert(list.PyObject, index, item.PyObject) = 0);
end;

class function TPyList.Append(const list, item: IPyObject): boolean;
begin
  Result := assigned(PyList_Append) and
            TPyObject.IsInitialized(list) and
            TPyObject.IsInitialized(item) and
            (PyList_Append(list.PyObject, item.PyObject) = 0);
end;

class function TPyList.GetSlice(const list: IPyObject; low, high: Py_ssize_t): IPyObject;
begin
  if assigned(PyList_GetSlice) and
     TPyObject.IsInitialized(list) then
    Result := TPyObject.Wrap(PyList_GetSlice(list.PyObject, low, high))
   else
    Result := nil;
end;

class function TPyList.SetSlice(const list: IPyObject; low, high: Py_ssize_t; const itemlist: IPyObject): boolean;
begin
  Result := assigned(PyList_SetSlice) and
            TPyObject.IsInitialized(list) and
            TPyObject.IsInitialized(itemlist) and
            (PyList_SetSlice(list.PyObject, low, high, itemlist.PyObject) = 0);
end;

class function TPyList.Sort(const list: IPyObject): boolean;
begin
  Result := assigned(PyList_Sort) and
            TPyObject.IsInitialized(list) and
            (PyList_Sort(list.PyObject) = 0);
end;

class function TPyList.Reverse(const list: IPyObject): boolean;
begin
  Result := assigned(PyList_Reverse) and
            TPyObject.IsInitialized(list) and
            (PyList_Reverse(list.PyObject) = 0);
end;

class function TPyList.AsTuple(const list: IPyObject): IPyObject;
begin
  if assigned(PyList_AsTuple) and
     TPyObject.IsInitialized(list) then
    Result := TPyObject.Wrap(PyList_AsTuple(list.PyObject))
   else
    Result := nil;
end;

class function TPyList.Extend(const self_, iterable: IPyObject): boolean;
begin
  Result := assigned(PyList_Extend) and
            TPyObject.IsInitialized(self_) and
            TPyObject.IsInitialized(iterable) and
            (PyList_Extend(self_.PyObject, iterable.PyObject) = 0);
end;

class function TPyList.Clear(const self_: IPyObject): boolean;
begin
  Result := assigned(PyList_Clear) and
            TPyObject.IsInitialized(self_) and
            (PyList_Clear(self_.PyObject) = 0);
end;

end.
