unit uP4P.PyODict;

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
  TPyODict = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function New: IPyObject;
      class function SetItem(const od, key, value: IPyObject): boolean;
      class function DelItem(const od, key: IPyObject): boolean;
      class function GetItem(const od, key: IPyObject): IPyObject;
      class function GetItemWithError(const od, key: IPyObject): IPyObject;
      class function Size(const od: IPyObject): Py_ssize_t;
      class function GetItemString(const od: IPyObject; const key: string): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyList;

class function TPyODict.New: IPyObject;
begin
  if assigned(PyODict_New) then
    Result := TPyObject.Wrap(PyODict_New())
   else
    Result := nil;
end;

class function TPyODict.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyODict_Type);
end;

class function TPyODict.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyODict_Type);
end;

class function TPyODict.SetItem(const od, key, value: IPyObject): boolean;
begin
  Result := assigned(PyODict_SetItem) and
            TPyObject.IsInitialized(od) and
            TPyObject.IsInitialized(value) and
            TPyObject.IsInitialized(key) and
            (PyODict_SetItem(od.PyObject, key.PyObject, value.PyObject) = 0);
end;

class function TPyODict.DelItem(const od, key: IPyObject): boolean;
begin
  Result := assigned(PyODict_DelItem) and
            TPyObject.IsInitialized(od) and
            TPyObject.IsInitialized(key) and
            (PyODict_DelItem(od.PyObject, key.PyObject) = 0);
end;

class function TPyODict.GetItem(const od, key: IPyObject): IPyObject;
begin
  if assigned(PyDict_GetItem) and
     TPyObject.IsInitialized(od) and
     TPyObject.IsInitialized(key) then
    Result := TPyObject.Wrap(PyDict_GetItem(od.PyObject, key.PyObject), False)
   else
    Result := nil;
end;

class function TPyODict.GetItemWithError(const od, key: IPyObject): IPyObject;
begin
  if assigned(PyDict_GetItemWithError) and
     TPyObject.IsInitialized(od) and
     TPyObject.IsInitialized(key) then
    Result := TPyObject.Wrap(PyDict_GetItemWithError(od.PyObject, key.PyObject), False)
   else
    Result := nil;
end;

class function TPyODict.Size(const od: IPyObject): Py_ssize_t;
begin
  if assigned(PyDict_Size) and TPyObject.IsInitialized(od) then
    Result := PyDict_Size(od.PyObject)
   else
    Result := -1;
end;

class function TPyODict.GetItemString(const od: IPyObject; const key: string): IPyObject;
var
  TempString: AnsiString;
begin
  if assigned(PyDict_GetItemString) and TPyObject.IsInitialized(od) then
    begin
      TempString := StringToPyUTF8(key);
      Result     := TPyObject.Wrap(PyDict_GetItemString(od.PyObject, PAnsiChar(TempString)), False)
    end
   else
    Result := nil;
end;

end.
