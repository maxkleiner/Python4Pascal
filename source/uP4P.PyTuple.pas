unit uP4P.PyTuple;

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
  TPyTuple = class
    public
      class function Size(const p: IPyObject): Py_ssize_t;
      class function GetItem(const p: IPyObject; pos: Py_ssize_t): IPyObject;
      class function SetItem(const p: IPyObject; pos: Py_ssize_t; const o: IPyObject): boolean;
      class function GetSlice(const p: IPyObject; low, high: Py_ssize_t): IPyObject;
      class function New(len: Py_ssize_t): IPyObject;
      class function Pack(const objects: array of IPyObject): IPyObject; virtual;
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyTuple.New(len: Py_ssize_t): IPyObject;
begin
  if assigned(PyTuple_New) then
    Result := TPyObject.Wrap(PyTuple_New(len))
   else
    Result := nil;
end;

class function TPyTuple.Pack(const objects: array of IPyObject): IPyObject;
var
  TempObject: PPyObject;
  n: Py_ssize_t;
begin
  Result := nil;
  if not(assigned(PyTuple_Pack)) then exit;

  //TODO: Find a way to call PyTuple_Pack with a varable number of arguments using an open array with an arbitrary length.

  n := length(objects);
  case n of
    10 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject, objects[4].PyObject, objects[5].PyObject, objects[6].PyObject, objects[7].PyObject, objects[8].PyObject, objects[9].PyObject);
    09 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject, objects[4].PyObject, objects[5].PyObject, objects[6].PyObject, objects[7].PyObject, objects[8].PyObject);
    08 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject, objects[4].PyObject, objects[5].PyObject, objects[6].PyObject, objects[7].PyObject);
    07 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject, objects[4].PyObject, objects[5].PyObject, objects[6].PyObject);
    06 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject, objects[4].PyObject, objects[5].PyObject);
    05 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject, objects[4].PyObject);
    04 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject, objects[3].PyObject);
    03 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject, objects[2].PyObject);
    02 : TempObject := PyTuple_Pack(n, objects[0].PyObject, objects[1].PyObject);
    01 : TempObject := PyTuple_Pack(n, objects[0].PyObject);
    else TempObject := nil;
  end;

  Result := TPyObject.Wrap(TempObject);
end;

class function TPyTuple.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            TPyTypeObject.FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_TUPLE_SUBCLASS));
end;

class function TPyTuple.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyTuple_Type);
end;

class function TPyTuple.Size(const p: IPyObject): Py_ssize_t;
begin
  if assigned(PyTuple_Size) and
     TPyObject.IsInitialized(p) then
    Result := PyTuple_Size(p.PyObject)
   else
    Result := -1;
end;

class function TPyTuple.GetItem(const p: IPyObject; pos: Py_ssize_t): IPyObject;
begin
  if assigned(PyTuple_GetItem) then
    Result := TPyObject.Wrap(PyTuple_GetItem(p.PyObject, pos), False)
   else
    Result := nil;
end;

class function TPyTuple.SetItem(const p: IPyObject; pos: Py_ssize_t; const o: IPyObject): boolean;
begin
  Result := assigned(PyTuple_SetItem) and
            TPyObject.IsInitialized(p) and
            TPyObject.IsInitialized(o) and
            (PyTuple_SetItem(p.PyObject, pos, o.UnWrap) = 0);
end;

class function TPyTuple.GetSlice(const p: IPyObject; low, high: Py_ssize_t): IPyObject;
begin
  if assigned(PyTuple_GetSlice) then
    Result := TPyObject.Wrap(PyTuple_GetSlice(p.PyObject, low, high))
   else
    Result := nil;
end;

end.
