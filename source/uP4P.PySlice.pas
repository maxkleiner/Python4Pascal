unit uP4P.PySlice;

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
  TPySlice = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function New(const start, stop, step: IPyObject): IPyObject;
      class function GetIndices(const slice: IPyObject; length: Py_ssize_t; var start, stop, step: Py_ssize_t): boolean;
      class function GetIndicesEx(const slice: IPyObject; length: Py_ssize_t; var start, stop, step, slicelength: Py_ssize_t): boolean;
      class function Unpack(const slice: IPyObject; var start, stop, step: Py_ssize_t): boolean;
      class function AdjustIndices(length: Py_ssize_t; var start, stop: Py_ssize_t; step: Py_ssize_t): Py_ssize_t;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPySlice.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PySlice_Type);
end;

class function TPySlice.New(const start, stop, step: IPyObject): IPyObject;
begin
  if assigned(PySlice_New) and
     TPyObject.IsInitialized(start) and
     TPyObject.IsInitialized(stop) and
     TPyObject.IsInitialized(step) then
    Result := TPyObject.Wrap(PySlice_New(start.PyObject, stop.PyObject, step.PyObject))
   else
    Result := nil;
end;

class function TPySlice.GetIndices(const slice: IPyObject; length: Py_ssize_t; var start, stop, step: Py_ssize_t): boolean;
begin
  Result := TPyObject.IsInitialized(slice) and
            assigned(PySlice_GetIndices) and
            (PySlice_GetIndices(slice.PyObject, length, @start, @stop, @step) = 0);
end;

class function TPySlice.GetIndicesEx(const slice: IPyObject; length: Py_ssize_t; var start, stop, step, slicelength: Py_ssize_t): boolean;
begin
  Result := TPyObject.IsInitialized(slice) and
            assigned(PySlice_GetIndicesEx) and
            (PySlice_GetIndicesEx(slice.PyObject, length, @start, @stop, @step, @slicelength) = 0);
end;

class function TPySlice.Unpack(const slice: IPyObject; var start, stop, step: Py_ssize_t): boolean;
begin
  Result := TPyObject.IsInitialized(slice) and
            assigned(PySlice_Unpack) and
            (PySlice_Unpack(slice.PyObject, @start, @stop, @step) = 0);
end;

class function TPySlice.AdjustIndices(length: Py_ssize_t; var start, stop: Py_ssize_t; step: Py_ssize_t): Py_ssize_t;
begin
  if assigned(PySlice_AdjustIndices) then
    Result := PySlice_AdjustIndices(length, @start, @stop, step)
   else
    REsult := -1;
end;

end.
