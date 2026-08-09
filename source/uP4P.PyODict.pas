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
  /// <summary>
  /// Helper class for all PyODict_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/dict.html#ordered-dictionaries">See the article about Ordered Dictionaries.</see></para>
  /// </remarks>
  TPyODict = class
    public
      /// <summary>
      /// <para>Return true if od is an ordered dictionary object or an instance
      /// of a subtype of the OrderedDict type. This function always
      /// succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if od is an ordered dictionary object, but not an
      /// instance of a subtype of the OrderedDict type. This function always
      /// succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new empty ordered dictionary, or nil on failure.</para>
      /// <para>This is analogous to TPyDict,New().</para>
      /// </summary>
      class function New: IPyObject;
      /// <summary>
      /// <para>Insert value into the ordered dictionary od with a key of key.
      /// Return True on success or False with an exception set on
      /// failure.</para>
      /// <para>This is analogous to TPyDict.SetItem().</para>
      /// </summary>
      class function SetItem(const od, key, value: IPyObject): boolean;
      /// <summary>
      /// <para>Remove the entry in the ordered dictionary od with key key.
      /// Return True on success or False with an exception set on
      /// failure.</para>
      /// <para>This is analogous to TPyDict.DelItem().</para>
      /// </summary>
      class function DelItem(const od, key: IPyObject): boolean;
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

end.
