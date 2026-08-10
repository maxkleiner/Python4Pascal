unit uP4P.PySequence;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.Variants,
  {$ELSE}
    Classes, Variants,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PySequence_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/sequence.html#sequence-protocol">See the article about the Sequence Protocol.</see></para>
  /// </remarks>
  TPySequence = class
    public
      /// <summary>
      /// <para>Return True if the object provides the sequence protocol, and
      /// False otherwise. Note that it returns True for Python classes with a
      /// __getitem__() method, unless they are dict subclasses, since in
      /// general it is impossible to determine what type of keys the class
      /// supports. This function always succeeds.</para>
      /// </summary>
      class function Check(const o: IPyObject): boolean;
      /// <summary>
      /// <para>Returns the number of objects in sequence o on success, and -1
      /// on failure. This is equivalent to the Python expression len(o).</para>
      /// </summary>
      class function Size(const o: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Returns the number of objects in sequence o on success, and -1
      /// on failure. This is equivalent to the Python expression len(o).</para>
      /// </summary>
      class function Length(const o: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Return the concatenation of o1 and o2 on success, and nil on
      /// failure. This is the equivalent of the Python expression
      /// o1 + o2.</para>
      /// </summary>
      class function Concat(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the result of repeating sequence object o count times,
      /// or nil on failure. This is the equivalent of the Python expression
      /// o * count.</para>
      /// </summary>
      class function Repeat_(const o: IPyObject; count_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Internal function used by the Variant version of GetSlice</para>
      /// </summary>
      class function GetSliceIndex(const i: TVarData; aEllipsisDefault: integer): integer;
      /// <summary>
      /// <para>Return the ith element of o, or nil on failure. This is the
      /// equivalent of the Python expression o[i].</para>
      /// </summary>
      class function GetItem(const o: IPyObject; i: Py_ssize_t): IPyObject; overload;
      /// <summary>
      /// <para>Variant version of GetItem</para>
      /// </summary>
      class function GetItem(const o: IPyObject; const i: TVarData): IPyObject; overload;
      /// <summary>
      /// <para>Return the slice of sequence object o between i1 and i2, or nil
      /// on failure. This is the equivalent of the Python expression
      /// o[i1:i2].</para>
      /// </summary>
      class function GetSlice(const o: IPyObject; i1, i2: Py_ssize_t): IPyObject; overload;
      /// <summary>
      /// <para>Variant version of GetSlice</para>
      /// </summary>
      class function GetSlice(const o: IPyObject; const i1, i2: TVarData): IPyObject; overload;
      /// <summary>
      /// <para>Assign object v to the ith element of o. Raise an exception and
      /// return False on failure; return True on success. This is the
      /// equivalent of the Python statement o[i] = v. This function does not
      /// "steal" a reference to v.</para>
      /// <para>If v is nil, the element is deleted, but this feature is
      /// deprecated in favour of using TPySequence.DelItem().</para>
      /// </summary>
      class function SetItem(const o: IPyObject; i: Py_ssize_t; v: IPyObject): boolean; overload;
      /// <summary>
      /// <para>Variant version of SetItem</para>
      /// </summary>
      class function SetItem(const o: IPyObject; const i, v: TVarData): boolean; overload;
      /// <summary>
      /// <para>Delete the ith element of object o. Returns False on failure.
      /// This is the equivalent of the Python statement del o[i].</para>
      /// </summary>
      class function DelItem(const o: IPyObject; i: Py_ssize_t): boolean; overload;
      /// <summary>
      /// <para>Variant version of DelItem</para>
      /// </summary>
      class function DelItem(const o: IPyObject; const i: TVarData): boolean; overload;
      /// <summary>
      /// <para>Assign the sequence object v to the slice in sequence object o
      /// from i1 to i2. This is the equivalent of the Python statement
      /// o[i1:i2] = v.</para>
      /// </summary>
      class function SetSlice(const o: IPyObject; i1, i2: Py_ssize_t; v: IPyObject): boolean; overload;
      /// <summary>
      /// <para>Variant version of SetSlice</para>
      /// </summary>
      class function SetSlice(const o: IPyObject; const i1, i2, v: TVarData): boolean; overload;
      /// <summary>
      /// <para>Delete the slice in sequence object o from i1 to i2. Returns
      /// False on failure. This is the equivalent of the Python statement
      /// del o[i1:i2].</para>
      /// </summary>
      class function DelSlice(const o: IPyObject; i1, i2: Py_ssize_t): boolean; overload;
      /// <summary>
      /// <para>Variant version of DelSlice</para>
      /// </summary>
      class function DelSlice(const o: IPyObject; const i1, i2: TVarData): boolean; overload;
      /// <summary>
      /// <para>Return a tuple object with the same contents as the sequence or
      /// iterable o, or nil on failure. If o is a tuple, a new reference will
      /// be returned, otherwise a tuple will be constructed with the
      /// appropriate contents. This is equivalent to the Python expression
      /// tuple(o).</para>
      /// </summary>
      class function Tuple(const o: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return a list object with the same contents as the sequence or
      /// iterable o, or nil on failure. The returned list is guaranteed to be
      /// new. This is equivalent to the Python expression list(o).</para>
      /// </summary>
      class function List(const o: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the sequence or iterable o as an object usable by the
      /// other PySequence_Fast* family of functions. If the object is not a
      /// sequence or iterable, raises TypeError with m as the message text.
      /// Returns nil on failure.</para>
      /// <para>The PySequence_Fast* functions are thus named because they
      /// assume o is a PyTupleObject or a PyListObject and access the data
      /// fields of o directly.</para>
      /// <para>As a CPython implementation detail, if o is already a sequence
      /// or list, it will be returned.</para>
      /// </summary>
      class function Fast(const o: IPyObject; const m: string): IPyObject;
      /// <summary>
      /// <para>Return the number of occurrences of value in o, that is, return
      /// the number of keys for which o[key] == value. On failure, return -1.
      /// This is equivalent to the Python expression o.count(value).</para>
      /// </summary>
      class function Count(const o, value: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Determine if o contains value. If an item in o is equal to
      /// value, return 1, otherwise return 0. On error, return -1. This is
      /// equivalent to the Python expression value in o.</para>
      /// </summary>
      class function Contains(const o, value: IPyObject): integer; overload;
      /// <summary>
      /// <para>Variant version of Contains</para>
      /// </summary>
      class function Contains(const o: IPyObject; const value: TVarData): integer; overload;
      /// <summary>
      /// <para>Alias for PySequence_Contains().</para>
      /// <para>Soft deprecated since version 3.14: The function should no
      /// longer be used to write new code.</para>
      /// </summary>
      class function In_(const o, value: IPyObject): integer;
      /// <summary>
      /// <para>Return the first index i for which o[i] == value. On error,
      /// return -1. This is equivalent to the Python expression
      /// o.index(value).</para>
      /// </summary>
      class function Index(const o, value: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Return the concatenation of o1 and o2 on success, and nil on
      /// failure. The operation is done in-place when o1 supports it. This is
      /// the equivalent of the Python expression o1 += o2.</para>
      /// </summary>
      class function InPlaceConcat(const o1, o2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the result of repeating sequence object o count times,
      /// or nil on failure. The operation is done in-place when o supports it.
      /// This is the equivalent of the Python expression o *= count.</para>
      /// </summary>
      class function InPlaceRepeat(const o: IPyObject; count_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Cast the values in this sequence as a Variant array.</para>
      /// </summary>
      class function CastValueAsVariant(const o: IPyObject): Variant;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyEllipsis;

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

class function TPySequence.GetItem(const o: IPyObject; const i: TVarData): IPyObject;
var
  TempIndex : integer;
begin
  TempIndex := Variant(i);
  Result    := GetItem(o, TempIndex);
end;

class function TPySequence.GetSlice(const o: IPyObject; i1, i2: Py_ssize_t): IPyObject;
begin
  if assigned(PySequence_GetSlice) and
     TPyObject.IsInitialized(o) then
    Result := TPyObject.Wrap(PySequence_GetSlice(o.PyObject, i1, i2))
   else
    Result := nil;
end;

class function TPySequence.GetSliceIndex(const i: TVarData; aEllipsisDefault: integer): integer;
var
  TempIndex : IPyObject;
begin
  TempIndex := TPyObject.FromVarData(i);

  if TPyEllipsis.Check(TempIndex) then
    Result := aEllipsisDefault
   else
    Result := TempIndex.AsInteger;
end;

class function TPySequence.GetSlice(const o: IPyObject; const i1, i2: TVarData): IPyObject;
begin
  Result := GetSlice(o, GetSliceIndex(i1, 0), GetSliceIndex(i2, o.Length));
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

class function TPySequence.SetItem(const o: IPyObject; const i, v: TVarData): boolean;
var
  TempIndex : integer;
  TempValue : IPyObject;
begin
  try
    TempIndex := Variant(i);
    TempValue := TPyObject.FromVarData(v);
    Result    := SetItem(o, TempIndex, TempValue);
  finally
    TempValue := nil;
  end;
end;

class function TPySequence.DelItem(const o: IPyObject; i: Py_ssize_t): boolean;
begin
  Result := assigned(PySequence_DelItem) and
            TPyObject.IsInitialized(o) and
            (PySequence_DelItem(o.PyObject, i) <> -1);
end;

class function TPySequence.DelItem(const o: IPyObject; const i: TVarData): boolean;
var
  TempIndex : integer;
begin
  TempIndex := Variant(i);
  Result    := DelItem(o, TempIndex);
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

class function TPySequence.SetSlice(const o: IPyObject; const i1, i2, v: TVarData): boolean;
var
  TempValue : IPyObject;
begin
  try
    TempValue := TPyObject.FromVarData(v);
    Result    := SetSlice(o, GetSliceIndex(i1, 0), GetSliceIndex(i2, o.Length), TempValue);
  finally
    TempValue := nil;
  end;
end;

class function TPySequence.DelSlice(const o: IPyObject; i1, i2: Py_ssize_t): boolean;
begin
  if assigned(PySequence_DelSlice) and
     TPyObject.IsInitialized(o) then
    Result := (PySequence_DelSlice(o.PyObject, i1, i2) <> -1)
   else
    Result := False;
end;

class function TPySequence.DelSlice(const o: IPyObject; const i1, i2: TVarData): boolean;
begin
  Result := DelSlice(o, GetSliceIndex(i1, 0), GetSliceIndex(i2, o.Length));
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

class function TPySequence.Contains(const o: IPyObject; const value: TVarData): integer;
var
  TempValue : IPyObject;
begin
  try
    TempValue := TPyObject.FromVardata(value);
    Result    := Contains(o, TempValue);
  finally
    TempValue := nil;
  end;
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

class function TPySequence.CastValueAsVariant(const o: IPyObject): Variant;
var
  i, TempLen : integer;
  TempItem : IPyObject;
begin
  if Check(o) then
    begin
      TempLen := TPySequence.Length(o);

      if (TempLen > 0) then
        begin
          Result := VarArrayCreate([0, pred(TempLen)], varVariant);

          for i := 0 to pred(TempLen) do
            begin
              TempItem := TPySequence.GetItem(o, i);

              if TPyObject.IsInitialized(TempItem) then
                Result[i] := TempItem.CastValueAsVariant
               else
                Result[i] := null;
            end;
        end
       else
        Result := null;
    end
   else
    Result := null;
end;

end.
