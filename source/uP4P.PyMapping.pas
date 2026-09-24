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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyMapping_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/mapping.html#mapping-protocol">See the article about Mapping Protocol.</see></para>
  /// </remarks>
  TPyMapping = class
    public
      /// <summary>
      /// <para>Return True if the object provides the mapping protocol or
      /// supports slicing, and False otherwise. Note that it returns True for
      /// Python classes with a __getitem__() method, since in general it is
      /// impossible to determine what type of keys the class supports.
      /// This function always succeeds.</para>
      /// </summary>
      class function Check(const o: IPyObject): boolean;
      /// <summary>
      /// <para>Returns the number of keys in object o on success, and -1 on
      /// failure. This is equivalent to the Python expression len(o).</para>
      /// </summary>
      class function Size(const o: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Returns the number of keys in object o on success, and -1 on
      /// failure. This is equivalent to the Python expression len(o).</para>
      /// </summary>
      class function Length(const o: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>This is the same as TPyMapping.HasKey(), but key is specified as
      /// a string, rather than a IPyObject.</para>
      /// <para>Note: Exceptions that occur when this calls the __getitem__()
      /// method or while creating the temporary str object are silently
      /// ignored. For proper error handling, use
      /// TPyMapping.HasKeyStringWithError(), TPyMapping.GetOptionalItemString()
      /// or TPyMapping.GetItemString() instead.</para>
      /// </summary>
      class function HasKeyString(const o: IPyObject; const key: string): boolean;
      /// <summary>
      /// <para>Return True if the mapping object has the key key and False
      /// otherwise. This is equivalent to the Python expression key in o.
      /// This function always succeeds.</para>
      /// <para>Note: Exceptions which occur when this calls the __getitem__()
      /// method are silently ignored. For proper error handling, use
      /// TPyMapping.HasKeyWithError(), TPyMapping.GetOptionalItem() or
      /// TPyObject.GetItem() instead.</para>
      /// </summary>
      class function HasKey(const o, key: IPyObject): boolean;
      /// <summary>
      /// <para>Return 1 if the mapping object has the key key and 0 otherwise.
      /// This is equivalent to the Python expression key in o. On failure,
      /// return -1.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function HasKeyWithError(const o, key: IPyObject): integer;
      /// <summary>
      /// <para>This is the same as TPyMapping.HasKeyWithError(), but key is
      /// specified as a string, rather than a IPyObject.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function HasKeyStringWithError(const o: IPyObject; const key: string): integer;
      /// <summary>
      /// <para>On success, return a list of the keys in object o. On failure,
      /// return nil.</para>
      /// </summary>
      class function Keys(const o: IPyObject): IPyObject;
      /// <summary>
      /// <para>On success, return a list of the values in object o. On failure,
      /// return nil.</para>
      /// </summary>
      class function Values(const o: IPyObject): IPyObject;
      /// <summary>
      /// <para>On success, return a list of the items in object o, where each
      /// item is a tuple containing a key-value pair. On failure,
      /// return nil.</para>
      /// </summary>
      class function Items(const o: IPyObject): IPyObject;
      /// <summary>
      /// <para>This is the same as TPyObject.GetItem(), but key is specified as
      /// a string, rather than a IPyObject.</para>
      /// </summary>
      class function GetItemString(const o: IPyObject; const key: string): IPyObject;
      /// <summary>
      /// <para>Variant of TPyObject.GetItem() which doesn't raise KeyError if
      /// the key is not found.</para>
      /// <para>If the key is found, return 1 and set result_ to a new strong
      /// reference to the corresponding value. If the key is not found,
      /// return 0 and set result_ to nil; the KeyError is silenced. If an error
      /// other than KeyError is raised, return -1 and set result_ to nil.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function GetOptionalItem(const obj, key: IPyObject; out result_: IPyObject): integer;
      /// <summary>
      /// <para>This is the same as TPyMapping.GetOptionalItem(), but key is
      /// specified as a string, rather than a IPyObject.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function GetOptionalItemString(const obj: IPyObject; const key: string; out result_: IPyObject): integer;
      /// <summary>
      /// <para>This is the same as TPyObject.SetItem(), but key is specified
      /// as a string, rather than a IPyObject.</para>
      /// </summary>
      class function SetItemString(const o: IPyObject; const key: string; const v: IPyObject): boolean; overload;
      {$IFDEF DELPHI12_UP}
      /// <summary>
      /// <para>This is the same as TPyObject.SetItem(), but key is specified
      /// as a string, rather than a IPyObject.</para>
      /// </summary>
      class function SetItemString(const o: IPyObject; const key: AnsiString; const v: IPyObject): boolean; overload;
      {$ENDIF}
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

class function TPyMapping.SetItemString(const o: IPyObject; const key: string; const v: IPyObject): boolean;
var
  TempKey : AnsiString;
begin
  Result := False;

  if assigned(PyMapping_SetItemString) and
     TPyObject.IsInitialized(o) and
     TPyObject.IsInitialized(v) then
    begin
      TempKey := StringToPyUTF8(key);
      Result  := (PyMapping_SetItemString(o.PyObject, PAnsiChar(TempKey), v.PyObject) = 0);
    end;
end;

{$IFDEF DELPHI12_UP}
class function TPyMapping.SetItemString(const o: IPyObject; const key: AnsiString; const v: IPyObject): boolean;
begin
  Result := assigned(PyMapping_SetItemString) and
            TPyObject.IsInitialized(o) and
            TPyObject.IsInitialized(v) and
            (PyMapping_SetItemString(o.PyObject, PAnsiChar(key), v.PyObject) = 0);
end;
{$ENDIF}

end.
