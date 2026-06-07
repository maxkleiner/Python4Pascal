unit uP4P.PyDict;

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
  TPyDict = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function New: IPyObject;
      class function GetItem(const mp, key: IPyObject): IPyObject;
      class function GetItemWithError(const mp, key: IPyObject): IPyObject;
      class function SetItem(const mp, key, val: IPyObject): boolean;
      class function DelItem(const mp, key: IPyObject): boolean;
      class procedure Clear(const mp: IPyObject);
      class function Next(const mp: IPyObject; var pos: Py_ssize_t; out key, val: IPyObject): boolean;
      class function Keys(const mp: IPyObject): IPyObject;
      class function Values(const mp: IPyObject): IPyObject;
      class function Items(const mp: IPyObject): IPyObject;
      class function Size(const mp: IPyObject): Py_ssize_t;
      class function Copy(const mp: IPyObject): IPyObject;
      class function Contains(const mp, key: IPyObject): integer;
      class function Update(const mp, other: IPyObject): boolean;
      class function Merge(const mp, other: IPyObject; override_: boolean): boolean;
      class function MergeFromSeq2(const d, seq2: IPyObject; override_: boolean): boolean;
      class function GetItemString(const dp: IPyObject; const key: string): IPyObject;
      class function SetItemString(const dp: IPyObject; const key: string; const item: IPyObject): boolean; overload;
      class function SetItemString(const dp: IPyObject; const key: AnsiString; const item: IPyObject): boolean; overload;
      class function DelItemString(const dp: IPyObject; const key: string): boolean;
      class function GetItemRef(const mp, key: IPyObject; out result_: IPyObject): integer;
      class function GetItemStringRef(const mp: IPyObject; const key: string; out result_: IPyObject): integer;
      class function SetDefault(const p, key, defaultobj: IPyObject): IPyObject;
      class function SetDefaultRef(const p, key, default_value: IPyObject; out result_: IPyObject): integer;
      class function ContainsString(const p: IPyObject; const key: string): integer;
      class function Pop(const p, key: IPyObject; out result_: IPyObject): integer;
      class function PopString(const p: IPyObject; const key: string; out result_: IPyObject): integer;
      class function AddWatcher(callback: PyDict_WatchCallback): integer;
      class function ClearWatcher(watcher_id: integer): boolean;
      class function Watch(watcher_id: integer; const dict: IPyObject): boolean;
      class function Unwatch(watcher_id: integer; const dict: IPyObject): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyList;

class function TPyDict.New: IPyObject;
begin
  if assigned(PyDict_New) then
    Result := TPyObject.Wrap(PyDict_New())
   else
    Result := nil;
end;

class function TPyDict.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            TPyTypeObject.FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_DICT_SUBCLASS));
end;

class function TPyDict.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyDict_Type);
end;

class function TPyDict.GetItem(const mp, key: IPyObject): IPyObject;
begin
  if assigned(PyDict_GetItem) and
     TPyObject.IsInitialized(mp) and
     TPyObject.IsInitialized(key) then
    Result := TPyObject.Wrap(PyDict_GetItem(mp.PyObject, key.PyObject), False)
   else
    Result := nil;
end;

class function TPyDict.GetItemWithError(const mp, key: IPyObject): IPyObject;
begin
  if assigned(PyDict_GetItemWithError) and
     TPyObject.IsInitialized(mp) and
     TPyObject.IsInitialized(key) then
    Result := TPyObject.Wrap(PyDict_GetItemWithError(mp.PyObject, key.PyObject), False)
   else
    Result := nil;
end;

class function TPyDict.SetItem(const mp, key, val: IPyObject): boolean;
begin
  Result := assigned(PyDict_SetItem) and
            TPyObject.IsInitialized(mp) and
            TPyObject.IsInitialized(val) and
            TPyObject.IsInitialized(key) and
            (PyDict_SetItem(mp.PyObject, key.PyObject, val.PyObject) = 0);
end;

class function TPyDict.DelItem(const mp, key: IPyObject): boolean;
begin
  Result := assigned(PyDict_DelItem) and
            TPyObject.IsInitialized(mp) and
            TPyObject.IsInitialized(key) and
            (PyDict_DelItem(mp.PyObject, key.PyObject) = 0);
end;

class procedure TPyDict.Clear(const mp: IPyObject);
begin
  if assigned(PyDict_Clear) and
     TPyObject.IsInitialized(mp) then
    PyDict_Clear(mp.PyObject);
end;

class function TPyDict.Next(const mp: IPyObject; var pos: Py_ssize_t; out key, val: IPyObject): boolean;
var
  TempKey, TempVal: PPyObject;
begin
  Result := False;
  key    := nil;
  val    := nil;

  if assigned(PyDict_Next) and
     TPyObject.IsInitialized(mp) and
     (PyDict_Next(mp.PyObject, @pos, TempKey, TempVal) <> 0) and
     assigned(TempKey) and
     assigned(TempVal) then
    begin
      key    := TPyObject.Wrap(TempKey, False);
      val    := TPyObject.Wrap(TempVal, False);
      Result := True;
    end;
end;

class function TPyDict.Keys(const mp: IPyObject): IPyObject;
begin
  if assigned(PyDict_Keys) and TPyObject.IsInitialized(mp) then
    Result := TPyObject.Wrap(PyDict_Keys(mp.PyObject))
   else
    Result := nil;
end;

class function TPyDict.Values(const mp: IPyObject): IPyObject;
begin
  if assigned(PyDict_Values) and TPyObject.IsInitialized(mp) then
    Result := TPyObject.Wrap(PyDict_Values(mp.PyObject))
   else
    Result := nil;
end;

class function TPyDict.Items(const mp: IPyObject): IPyObject;
begin
  if assigned(PyDict_Items) and TPyObject.IsInitialized(mp) then
    Result := TPyObject.Wrap(PyDict_Items(mp.PyObject))
   else
    Result := nil;
end;

class function TPyDict.Size(const mp: IPyObject): Py_ssize_t;
begin
  if assigned(PyDict_Size) and TPyObject.IsInitialized(mp) then
    Result := PyDict_Size(mp.PyObject)
   else
    Result := -1;
end;

class function TPyDict.Copy(const mp: IPyObject): IPyObject;
begin
  if assigned(PyDict_Copy) and TPyObject.IsInitialized(mp) then
    Result := TPyObject.Wrap(PyDict_Copy(mp.PyObject))
   else
    Result := nil;
end;

class function TPyDict.Contains(const mp, key: IPyObject): integer;
begin
  if assigned(PyDict_Contains) and
     TPyObject.IsInitialized(mp) and
     TPyObject.IsInitialized(key) then
    Result := PyDict_Contains(mp.PyObject, key.PyObject)
   else
    Result := -1;
end;

class function TPyDict.Update(const mp, other: IPyObject): boolean;
begin
  Result := assigned(PyDict_Update) and
            TPyObject.IsInitialized(mp) and
            TPyObject.IsInitialized(other) and
            (PyDict_Update(mp.PyObject, other.PyObject) = 0);
end;

class function TPyDict.Merge(const mp, other: IPyObject; override_: boolean): boolean;
begin
  Result := assigned(PyDict_Merge) and
            TPyObject.IsInitialized(mp) and
            TPyObject.IsInitialized(other) and
            (PyDict_Merge(mp.PyObject, other.PyObject, ord(override_)) = 0);
end;

class function TPyDict.MergeFromSeq2(const d, seq2: IPyObject; override_: boolean): boolean;
begin
  Result := assigned(PyDict_MergeFromSeq2) and
            TPyObject.IsInitialized(d) and
            TPyObject.IsInitialized(seq2) and
            (PyDict_MergeFromSeq2(d.PyObject, seq2.PyObject, ord(override_)) = 0);
end;

class function TPyDict.GetItemString(const dp: IPyObject; const key: string): IPyObject;
var
  TempString: AnsiString;
begin
  if assigned(PyDict_GetItemString) and TPyObject.IsInitialized(dp) then
    begin
      TempString := StringToPyUTF8(key);
      Result     := TPyObject.Wrap(PyDict_GetItemString(dp.PyObject, PAnsiChar(TempString)), False)
    end
   else
    Result := nil;
end;

class function TPyDict.SetItemString(const dp: IPyObject; const key: string; const item: IPyObject): boolean;
begin
  Result := SetItemString(dp, StringToPyUTF8(key), item);
end;

class function TPyDict.SetItemString(const dp: IPyObject; const key: AnsiString; const item: IPyObject): boolean;
begin
  if assigned(PyDict_SetItemString) and
     TPyObject.IsInitialized(dp) and
     TPyObject.IsInitialized(item) then
    Result := (PyDict_SetItemString(dp.PyObject, PAnsiChar(key), item.PyObject) = 0)
   else
    Result := False;
end;

class function TPyDict.DelItemString(const dp: IPyObject; const key: string): boolean;
var
  TempString: AnsiString;
begin
  if assigned(PyDict_DelItemString) and
     TPyObject.IsInitialized(dp) then
    begin
      TempString := StringToPyUTF8(key);
      Result     := (PyDict_DelItemString(dp.PyObject, PAnsiChar(TempString)) = 0)
    end
   else
    Result := False;
end;

class function TPyDict.GetItemRef(const mp, key: IPyObject; out result_: IPyObject): integer;
var
  TempResult : PPyObject;
begin
  if assigned(PyDict_GetItemRef) and
     TPyObject.IsInitialized(mp) and
     TPyObject.IsInitialized(key) then
    begin
      TempResult := nil;
      Result     := PyDict_GetItemRef(mp.PyObject, key.PyObject, @TempResult);
      result_    := TPyObject.Wrap(TempResult);
    end
   else
    begin
      result_ := nil;
      Result  := 0;
    end;
end;

class function TPyDict.GetItemStringRef(const mp: IPyObject; const key: string; out result_: IPyObject): integer;
var
  TempString : AnsiString;
  TempResult : PPyObject;
begin
  if assigned(PyDict_GetItemStringRef) and
     TPyObject.IsInitialized(mp) then
    begin
      TempResult := nil;
      TempString := StringToPyUTF8(key);
      Result     := PyDict_GetItemStringRef(mp.PyObject, PAnsiChar(TempString), @TempResult);
      result_    := TPyObject.Wrap(TempResult);
    end
   else
    begin
      result_ := nil;
      Result  := 0;
    end;
end;

class function TPyDict.SetDefault(const p, key, defaultobj: IPyObject): IPyObject;
begin
  if assigned(PyDict_SetDefault) and
     TPyObject.IsInitialized(p) and
     TPyObject.IsInitialized(key) and
     TPyObject.IsInitialized(defaultobj) then
    Result := TPyObject.Wrap(PyDict_SetDefault(p.PyObject, key.PyObject, defaultobj.PyObject), False)
   else
    Result := nil;
end;

class function TPyDict.SetDefaultRef(const p, key, default_value: IPyObject; out result_: IPyObject): integer;
var
  TempResult : PPyObject;
begin
  if assigned(PyDict_SetDefaultRef) and
     TPyObject.IsInitialized(p) and
     TPyObject.IsInitialized(key) and
     TPyObject.IsInitialized(default_value) then
    begin
      Result  := PyDict_SetDefaultRef(p.PyObject, key.PyObject, default_value.PyObject, @TempResult);
      result_ := TPyObject.Wrap(TempResult);
    end
   else
    begin
      Result  := -1;
      result_ := nil;
    end;
end;

class function TPyDict.ContainsString(const p: IPyObject; const key: string): integer;
var
  TempString : AnsiString;
begin
  if assigned(PyDict_ContainsString) and
     TPyObject.IsInitialized(p) then
    begin
      TempString := StringToPyUTF8(key);
      Result     := PyDict_ContainsString(p.PyObject, PAnsiChar(TempString))
    end
   else
    Result := -1;
end;

class function TPyDict.Pop(const p, key: IPyObject; out result_: IPyObject): integer;
var
  TempResult : PPyObject;
begin
  if assigned(PyDict_Pop) and
     TPyObject.IsInitialized(p) and
     TPyObject.IsInitialized(key) then
    begin
      Result  := PyDict_Pop(p.PyObject, key.PyObject, @TempResult);
      result_ := TPyObject.Wrap(TempResult);
    end
   else
    begin
      Result  := -1;
      result_ := nil;
    end;
end;

class function TPyDict.PopString(const p: IPyObject; const key: string; out result_: IPyObject): integer;
var
  TempResult : PPyObject;
  TempString : AnsiString;
begin
  if assigned(PyDict_PopString) and
     TPyObject.IsInitialized(p) then
    begin
      TempString := StringToPyUTF8(key);
      Result     := PyDict_PopString(p.PyObject, PAnsiChar(TempString), @TempResult);
      result_    := TPyObject.Wrap(TempResult);
    end
   else
    begin
      Result  := -1;
      result_ := nil;
    end;
end;

class function TPyDict.AddWatcher(callback: PyDict_WatchCallback): integer;
begin
  if assigned(PyDict_AddWatcher) then
    Result := PyDict_AddWatcher(callback)
   else
    Result := -1;
end;

class function TPyDict.ClearWatcher(watcher_id: integer): boolean;
begin
  Result := assigned(PyDict_ClearWatcher) and
            (PyDict_ClearWatcher(watcher_id) = 0);
end;

class function TPyDict.Watch(watcher_id: integer; const dict: IPyObject): boolean;
begin
  Result := assigned(PyDict_Watch) and
            TPyObject.IsInitialized(dict) and
            (PyDict_Watch(watcher_id, dict.PyObject) = 0);
end;

class function TPyDict.Unwatch(watcher_id: integer; const dict: IPyObject): boolean;
begin
  Result := assigned(PyDict_Unwatch) and
            TPyObject.IsInitialized(dict) and
            (PyDict_Unwatch(watcher_id, dict.PyObject) = 0);
end;

end.
