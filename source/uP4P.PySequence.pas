unit uP4P.PySequence;

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
  TPySequence = class
    public
      class function Check(const o: IPyObject): boolean;
      class function Size(const o: IPyObject): Py_ssize_t;
      class function Length(const o: IPyObject): Py_ssize_t;
      class function Concat(const o1, o2: IPyObject): IPyObject;
      class function Repeat_(const o: IPyObject; count_: Py_ssize_t): IPyObject;
      class function GetItem(const o: IPyObject; i: Py_ssize_t): IPyObject;
      class function GetSlice(const o: IPyObject; i1, i2: Py_ssize_t): IPyObject;
      class function SetItem(const o: IPyObject; i: Py_ssize_t; v: IPyObject): boolean;
      class function DelItem(const o: IPyObject; i: Py_ssize_t): boolean;
      class function SetSlice(const o: IPyObject; i1, i2: Py_ssize_t; v: IPyObject): boolean;
      class function DelSlice(const o: IPyObject; i1, i2: Py_ssize_t): boolean;
      class function Tuple(const o: IPyObject): IPyObject;
      class function List(const o: IPyObject): IPyObject;
      class function Fast(const o: IPyObject; const m: string): IPyObject;
      class function Count(const o, value: IPyObject): Py_ssize_t;
      class function Contains(const o, value: IPyObject): integer;
      class function In_(const o, value: IPyObject): integer;
      class function Index(const o, value: IPyObject): Py_ssize_t;
      class function InPlaceConcat(const o1, o2: IPyObject): IPyObject;
      class function InPlaceRepeat(const o: IPyObject; count_: Py_ssize_t): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPySequence.Check(const o: IPyObject): boolean;
begin
  Result := assigned(PySequence_Check) and
            TPyObject.IsInitialized(o) and
            (PySequence_Check(o.PyObject) <> 0);
end;

class function TPySequence.Size(const o: IPyObject): Py_ssize_t;
begin
  if assigned(PySequence_Size) and
     TPyObject.IsInitialized(o) then
    Result := PySequence_Size(o.PyObject)
   else
    Result := -1;
end;

class function TPySequence.Length(const o: IPyObject): Py_ssize_t;
begin
  if assigned(PySequence_Length) and
     TPyObject.IsInitialized(o) then
    Result := PySequence_Length(o.PyObject)
   else
    Result := -1;
end;

class function TPySequence.Concat(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(PySequence_Concat) and
     TPyObject.IsInitialized(o1) and
     TPyObject.IsInitialized(o2) then
    Result := TPyObject.Wrap(PySequence_Concat(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPySequence.Repeat_(const o: IPyObject; count_: Py_ssize_t): IPyObject;
begin
  if assigned(PySequence_Repeat) and
     TPyObject.IsInitialized(o) then
    Result := TPyObject.Wrap(PySequence_Repeat(o.PyObject, count_))
   else
    Result := nil;
end;

class function TPySequence.GetItem(const o: IPyObject; i: Py_ssize_t): IPyObject;
begin
  if assigned(PySequence_GetItem) and
     TPyObject.IsInitialized(o) then
    Result := TPyObject.Wrap(PySequence_GetItem(o.PyObject, i))
   else
    Result := nil;
end;

class function TPySequence.GetSlice(const o: IPyObject; i1, i2: Py_ssize_t): IPyObject;
begin
  if assigned(PySequence_GetSlice) and
     TPyObject.IsInitialized(o) then
    Result := TPyObject.Wrap(PySequence_GetSlice(o.PyObject, i1, i2))
   else
    Result := nil;
end;

class function TPySequence.SetItem(const o: IPyObject; i: Py_ssize_t; v: IPyObject): boolean;
begin
  if assigned(PySequence_SetItem) and
     TPyObject.IsInitialized(o) then
    begin
      if TPyObject.IsInitialized(v) then
        Result := (PySequence_SetItem(o.PyObject, i, v.PyObject) = 0)
       else
        Result := (PySequence_SetItem(o.PyObject, i, nil) = 0);
    end
   else
    Result := False;
end;

class function TPySequence.DelItem(const o: IPyObject; i: Py_ssize_t): boolean;
begin
  Result := assigned(PySequence_DelItem) and
            TPyObject.IsInitialized(o) and
            (PySequence_DelItem(o.PyObject, i) <> -1);
end;

class function TPySequence.SetSlice(const o: IPyObject; i1, i2: Py_ssize_t; v: IPyObject): boolean;
begin
  if assigned(PySequence_SetSlice) and
     TPyObject.IsInitialized(o) then
    begin
      if TPyObject.IsInitialized(v) then
        Result := (PySequence_SetSlice(o.PyObject, i1, i2, v.PyObject) <> -1)
       else
        Result := (PySequence_SetSlice(o.PyObject, i1, i2, nil) <> -1);
    end
   else
    Result := False;
end;

class function TPySequence.DelSlice(const o: IPyObject; i1, i2: Py_ssize_t): boolean;
begin
  if assigned(PySequence_DelSlice) and
     TPyObject.IsInitialized(o) then
    Result := (PySequence_DelSlice(o.PyObject, i1, i2) <> -1)
   else
    Result := False;
end;

class function TPySequence.Tuple(const o: IPyObject): IPyObject;
begin
  if assigned(PySequence_Tuple) and
     TPyObject.IsInitialized(o) then
    Result := TPyObject.Wrap(PySequence_Tuple(o.PyObject))
   else
    Result := nil;
end;

class function TPySequence.List(const o: IPyObject): IPyObject;
begin
  if assigned(PySequence_List) and
     TPyObject.IsInitialized(o) then
    Result := TPyObject.Wrap(PySequence_List(o.PyObject))
   else
    Result := nil;
end;

class function TPySequence.Fast(const o: IPyObject; const m: string): IPyObject;
var
  TempString : AnsiString;
begin
  if assigned(PySequence_Fast) and
     TPyObject.IsInitialized(o) then
    begin
      TempString := StringToPyUTF8(m);
      Result     := TPyObject.Wrap(PySequence_Fast(o.PyObject, PAnsiChar(TempString)))
    end
   else
    Result := nil;
end;

class function TPySequence.Count(const o, value: IPyObject): Py_ssize_t;
begin
  if assigned(PySequence_Count) and
     TPyObject.IsInitialized(o) and
     TPyObject.IsInitialized(value) then
    Result := PySequence_Count(o.PyObject, value.PyObject)
   else
    Result := -1;
end;

class function TPySequence.Contains(const o, value: IPyObject): integer;
begin
  if assigned(PySequence_Contains) and
     TPyObject.IsInitialized(o) and
     TPyObject.IsInitialized(value) then
    Result := PySequence_Contains(o.PyObject, value.PyObject)
   else
    Result := -1;
end;

class function TPySequence.In_(const o, value: IPyObject): integer;
begin
  if assigned(PySequence_In) and
     TPyObject.IsInitialized(o) and
     TPyObject.IsInitialized(value) then
    Result := PySequence_In(o.PyObject, value.PyObject)
   else
    Result := -1;
end;

class function TPySequence.Index(const o, value: IPyObject): Py_ssize_t;
begin
  if assigned(PySequence_Index) and
     TPyObject.IsInitialized(o) and
     TPyObject.IsInitialized(value) then
    Result := PySequence_Index(o.PyObject, value.PyObject)
   else
    Result := -1;
end;

class function TPySequence.InPlaceConcat(const o1, o2: IPyObject): IPyObject;
begin
  if assigned(PySequence_InPlaceConcat) and
     TPyObject.IsInitialized(o1) and
     TPyObject.IsInitialized(o2) then
    Result := TPyObject.Wrap(PySequence_InPlaceConcat(o1.PyObject, o2.PyObject))
   else
    Result := nil;
end;

class function TPySequence.InPlaceRepeat(const o: IPyObject; count_: Py_ssize_t): IPyObject;
begin
  if assigned(PySequence_InPlaceRepeat) and
     TPyObject.IsInitialized(o) then
    Result := TPyObject.Wrap(PySequence_InPlaceRepeat(o.PyObject, count_))
   else
    Result := nil;
end;

end.
