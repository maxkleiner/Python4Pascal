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
  /// <summary>
  /// Helper class for all PySet_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/set.html#set-objects">See the article about Set Objects.</see></para>
  /// </remarks>
  TPySet = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is a set object or an instance of a
      /// subtype. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject is a set object but not an instance
      /// of a subtype. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new set containing objects returned by the iterable.
      /// The iterable may be nil to create a new empty set. Return the new
      /// set on success or nil on failure. Raise TypeError if iterable is not
      /// actually iterable. The constructor is also useful for copying a set
      /// (c=set(s)).</para>
      /// <para>Note: The operation is atomic on free threading when iterable
      /// is a set, frozenset or dict.</para>
      /// </summary>
      class function New(const iterable: IPyObject): IPyObject;
      /// <summary>
      /// <para>Add key to a set instance. Also works with frozenset instances
      /// (like TPyTuple.SetItem() it can be used to fill in the values of
      /// brand new frozensets before they are exposed to other code).
      /// Return True on success or False on failure. Raise a TypeError if the
      /// key is unhashable. Raise a MemoryError if there is no room to grow.
      /// Raise a SystemError if set is not an instance of set or its
      /// subtype.</para>
      /// <para>Note: The operation is atomic on free threading when key is
      /// str, int, float, bool or bytes.</para>
      /// </summary>
      class function Add(const set_, key: IPyObject): boolean;
      /// <summary>
      /// <para>Empty an existing set of all elements. Return True on success.
      /// Return False and raise SystemError if set is not an instance of set
      /// or its subtype.</para>
      /// <para>Note: In the free-threaded build, the set is emptied before its
      /// entries are cleared, so other threads will observe an empty set
      /// rather than intermediate states.</para>
      /// </summary>
      class function Clear(const set_: IPyObject): boolean;
      /// <summary>
      /// <para>Return 1 if found, 0 if not found, and -1 if an error is
      /// encountered. Unlike the Python __contains__() method, this function
      /// does not automatically convert unhashable sets into temporary
      /// frozensets. Raise a TypeError if the key is unhashable. Raise
      /// SystemError if anyset is not a set, frozenset, or an instance of a
      /// subtype.</para>
      /// <para>Note: The operation is atomic on free threading when key is
      /// str, int, float, bool or bytes.</para>
      /// </summary>
      class function Contains(const anyset, key: IPyObject): integer;
      /// <summary>
      /// <para>Return 1 if found and removed, 0 if not found (no action taken),
      /// and -1 if an error is encountered. Does not raise KeyError for
      /// missing keys. Raise a TypeError if the key is unhashable. Unlike the
      /// Python discard() method, this function does not automatically convert
      /// unhashable sets into temporary frozensets. Raise SystemError if set
      /// is not an instance of set or its subtype.</para>
      /// <para>Note: The operation is atomic on free threading when key is
      /// str, int, float, bool or bytes.</para>
      /// </summary>
      class function Discard(const set_, key: IPyObject): integer;
      /// <summary>
      /// <para>Return a new reference to an arbitrary object in the set, and
      /// removes the object from the set. Return nil on failure.
      /// Raise KeyError if the set is empty. Raise a SystemError if set is not
      /// an instance of set or its subtype.</para>
      /// </summary>
      class function Pop(const set_: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the length of a set or frozenset object. Equivalent to
      /// len(anyset). Raises a SystemError if anyset is not a set, frozenset,
      /// or an instance of a subtype.</para>
      /// </summary>
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
