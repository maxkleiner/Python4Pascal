unit uP4P.PyFrozenSet;

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
  TPyFrozenSet = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function New(const iterable: IPyObject): IPyObject;
      class function Add(const set_, key: IPyObject): boolean;
      class function Contains(const anyset, key: IPyObject): integer;
      class function Size(const anyset: IPyObject): Py_ssize_t;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyFrozenSet.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyFrozenSet_Type);
end;

class function TPyFrozenSet.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyFrozenSet_Type);
end;

class function TPyFrozenSet.New(const iterable: IPyObject): IPyObject;
begin
  if assigned(PyFrozenSet_New) and
     TPyObject.IsInitialized(iterable) then
    Result := TPyObject.Wrap(PyFrozenSet_New(iterable.PyObject))
   else
    Result := nil;
end;

class function TPyFrozenSet.Add(const set_, key: IPyObject): boolean;
begin
  Result := assigned(PySet_Add) and
            TPyObject.IsInitialized(set_) and
            TPyObject.IsInitialized(key) and
            (PySet_Add(set_.PyObject, key.PyObject) = 0);
end;

class function TPyFrozenSet.Contains(const anyset, key: IPyObject): integer;
begin
  if assigned(PySet_Contains) and
     TPyObject.IsInitialized(anyset) and
     TPyObject.IsInitialized(key) then
    Result := PySet_Contains(anyset.PyObject, key.PyObject)
   else
    Result := -1;
end;

class function TPyFrozenSet.Size(const anyset: IPyObject): Py_ssize_t;
begin
  if assigned(PySet_Size) and
     TPyObject.IsInitialized(anyset) then
    Result := PySet_Size(anyset.PyObject)
   else
    Result := 0;
end;

end.
