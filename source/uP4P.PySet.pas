unit uP4P.PySet;

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
  TPySet = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function New(const iterable: IPyObject): IPyObject;
      class function Add(const set_, key: IPyObject): boolean;
      class function Clear(const set_: IPyObject): boolean;
      class function Contains(const anyset, key: IPyObject): integer;
      class function Discard(const set_, key: IPyObject): integer;
      class function Pop(const set_: IPyObject): IPyObject;
      class function Size(const anyset: IPyObject): Py_ssize_t;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPySet.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PySet_Type);
end;

class function TPySet.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PySet_Type);
end;

class function TPySet.New(const iterable: IPyObject): IPyObject;
begin
  if assigned(PySet_New) and
     TPyObject.IsInitialized(iterable) then
    Result := TPyObject.Wrap(PySet_New(iterable.PyObject))
   else
    Result := nil;
end;

class function TPySet.Add(const set_, key: IPyObject): boolean;
begin
  Result := assigned(PySet_Add) and
            TPyObject.IsInitialized(set_) and
            TPyObject.IsInitialized(key) and
            (PySet_Add(set_.PyObject, key.PyObject) = 0);
end;

class function TPySet.Clear(const set_: IPyObject): boolean;
begin
  Result := assigned(PySet_Clear) and
            TPyObject.IsInitialized(set_) and
            (PySet_Clear(set_.PyObject) = 0);
end;

class function TPySet.Contains(const anyset, key: IPyObject): integer;
begin
  if assigned(PySet_Contains) and
     TPyObject.IsInitialized(anyset) and
     TPyObject.IsInitialized(key) then
    Result := PySet_Contains(anyset.PyObject, key.PyObject)
   else
    Result := -1;
end;

class function TPySet.Discard(const set_, key: IPyObject): integer;
begin
  if assigned(PySet_Discard) and
     TPyObject.IsInitialized(set_) and
     TPyObject.IsInitialized(key) then
    Result := PySet_Discard(set_.PyObject, key.PyObject)
   else
    Result := -1;
end;

class function TPySet.Pop(const set_: IPyObject): IPyObject;
begin
  if assigned(PySet_Pop) and
     TPyObject.IsInitialized(set_) then
    Result := TPyObject.Wrap(PySet_Pop(set_.PyObject))
   else
    Result := nil;
end;

class function TPySet.Size(const anyset: IPyObject): Py_ssize_t;
begin
  if assigned(PySet_Size) and
     TPyObject.IsInitialized(anyset) then
    Result := PySet_Size(anyset.PyObject)
   else
    Result := 0;
end;

end.
