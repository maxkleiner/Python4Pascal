unit uP4P.PyMapping;

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
  TPyMapping = class
    public
      class function Check(const o: IPyObject): boolean;
      class function Size(const o: IPyObject): Py_ssize_t;
      class function Length(const o: IPyObject): Py_ssize_t;
      class function HasKeyString(const o: IPyObject; const key: string): boolean;
      class function HasKey(const o, key: IPyObject): boolean;
      class function HasKeyWithError(const o, key: IPyObject): integer;
      class function HasKeyStringWithError(const o: IPyObject; const key: string): integer;
      class function Keys(const o: IPyObject): IPyObject;
      class function Values(const o: IPyObject): IPyObject;
      class function Items(const o: IPyObject): IPyObject;
      class function GetItemString(const o: IPyObject; const key: string): IPyObject;
      class function GetOptionalItem(const obj, key: IPyObject; out result_: IPyObject): integer;
      class function GetOptionalItemString(const obj: IPyObject; const key: string; out result_: IPyObject): integer;
      class function SetItemString(const o: IPyObject; const key: string; const v: IPyObject): integer;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPyMapping.Check(const o: IPyObject): boolean;
begin
  Result := assigned(PyMapping_Check) and
            TPyObject.IsInitialized(o) and
            (PyMapping_Check(o.PyObject) <> 0);
end;

class function TPyMapping.Size(const o: IPyObject): Py_ssize_t;
begin
  if assigned(PyMapping_Size) and
     TPyObject.IsInitialized(o) then
    Result := PyMapping_Size(o.PyObject)
   else
    Result := -1;
end;

class function TPyMapping.Length(const o: IPyObject): Py_ssize_t;
begin
  if assigned(PyMapping_Length) and
     TPyObject.IsInitialized(o) then
    Result := PyMapping_Length(o.PyObject)
   else
    Result := -1;
end;

class function TPyMapping.HasKeyString(const o: IPyObject; const key: string): boolean;
var
  TempKey : AnsiString;
begin
  if assigned(PyMapping_HasKeyString) and
     TPyObject.IsInitialized(o) then
    begin
      TempKey := StringToPyUTF8(key);
      Result  := (PyMapping_HasKeyString(o.PyObject, PAnsiChar(TempKey)) <> 0);
    end
   else
    Result := False;
end;

class function TPyMapping.HasKey(const o, key: IPyObject): boolean;
begin
  if assigned(PyMapping_HasKey) and
     TPyObject.IsInitialized(o) and
     TPyObject.IsInitialized(key) then
    Result := (PyMapping_HasKey(o.PyObject, key.PyObject) <> 0)
   else
    Result := False;
end;

class function TPyMapping.HasKeyWithError(const o, key: IPyObject): integer;
begin
  if assigned(PyMapping_HasKeyWithError) and
     TPyObject.IsInitialized(o) and
     TPyObject.IsInitialized(key) then
    Result := PyMapping_HasKeyWithError(o.PyObject, key.PyObject)
   else
    Result := -1;
end;

class function TPyMapping.HasKeyStringWithError(const o: IPyObject; const key: string): integer;
var
  TempKey : AnsiString;
begin
  if assigned(PyMapping_HasKeyStringWithError) and
     TPyObject.IsInitialized(o) then
    begin
      TempKey := StringToPyUTF8(key);
      Result  := PyMapping_HasKeyStringWithError(o.PyObject, PAnsiChar(TempKey));
    end
   else
    Result := -1;
end;

class function TPyMapping.Keys(const o: IPyObject): IPyObject;
begin
  if assigned(PyMapping_Keys) and
     TPyObject.IsInitialized(o) then
    Result := TPyObject.Wrap(PyMapping_Keys(o.PyObject))
   else
    Result := nil;
end;

class function TPyMapping.Values(const o: IPyObject): IPyObject;
begin
  if assigned(PyMapping_Values) and
     TPyObject.IsInitialized(o) then
    Result := TPyObject.Wrap(PyMapping_Values(o.PyObject))
   else
    Result := nil;
end;

class function TPyMapping.Items(const o: IPyObject): IPyObject;
begin
  if assigned(PyMapping_Items) and
     TPyObject.IsInitialized(o) then
    Result := TPyObject.Wrap(PyMapping_Items(o.PyObject))
   else
    Result := nil;
end;

class function TPyMapping.GetItemString(const o: IPyObject; const key: string): IPyObject;
var
  TempKey : AnsiString;
begin
  if assigned(PyMapping_GetItemString) and
     TPyObject.IsInitialized(o) then
    begin
      TempKey := StringToPyUTF8(key);
      Result  := TPyObject.Wrap(PyMapping_GetItemString(o.PyObject, PAnsiChar(TempKey)));
    end
   else
    Result := nil;
end;

class function TPyMapping.GetOptionalItem(const obj, key: IPyObject; out result_: IPyObject): integer;
var
  TempResult : PPyObject;
begin
  Result  := -1;
  result_ := nil;

  if assigned(PyMapping_GetOptionalItem) and
     TPyObject.IsInitialized(obj) and
     TPyObject.IsInitialized(key) then
    begin
      Result  := PyMapping_GetOptionalItem(obj.PyObject, key.PyObject, TempResult);

      if (Result = 1) then
        result_ := TPyObject.Wrap(TempResult);
    end;
end;

class function TPyMapping.GetOptionalItemString(const obj: IPyObject; const key: string; out result_: IPyObject): integer;
var
  TempResult : PPyObject;
  TempKey : AnsiString;
begin
  Result  := -1;
  result_ := nil;

  if assigned(PyMapping_GetOptionalItemString) and
     TPyObject.IsInitialized(obj) then
    begin
      TempKey := StringToPyUTF8(key);
      Result  := PyMapping_GetOptionalItemString(obj.PyObject, PAnsiChar(TempKey), TempResult);

      if (Result = 1) then
        result_ := TPyObject.Wrap(TempResult);
    end;
end;

class function TPyMapping.SetItemString(const o: IPyObject; const key: string; const v: IPyObject): integer;
var
  TempKey : AnsiString;
begin
  Result := -1;

  if assigned(PyMapping_SetItemString) and
     TPyObject.IsInitialized(o) and
     TPyObject.IsInitialized(v) then
    begin
      TempKey := StringToPyUTF8(key);
      Result  := PyMapping_SetItemString(o.PyObject, PAnsiChar(TempKey), v.PyObject);
    end;
end;

end.
