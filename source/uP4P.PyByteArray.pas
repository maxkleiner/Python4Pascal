unit uP4P.PyByteArray;

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
  /// Helper class for all PyByteArray_* methods used to handle bytearray
  /// objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/bytearray.html#byte-array-objects">See the article about Byte Array Objects.</see></para>
  /// </remarks>
  TPyByteArray = class
    public
      /// <summary>
      /// <para>Concat bytearrays ob1 and ob2 and return a new bytearray with
      /// the result.</para>
      /// <para>On failure, return nil with an exception set.</para>
      /// <para>Note: If the object implements the buffer protocol, then the
      /// buffer must not be mutated while the bytearray object is being
      /// created.</para>
      /// </summary>
      class function Concat(const ob1, ob2: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the size of bytearray after checking for a nil
      /// pointer.</para>
      /// </summary>
      class function Size(const ob: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Return the contents of bytearray as a string after checking
      /// for a nil pointer.</para>
      /// <para>Note: It is not thread-safe to mutate the bytearray object
      // while using the returned string.</para>
      /// </summary>
      class function AsString(const ob: IPyObject): string;
      /// <summary>
      /// <para>Return the contents of bytearray as a PByte after checking
      /// for a nil pointer. The returned PByte always has an extra nil byte
      /// appended.</para>
      /// <para>Note: It is not thread-safe to mutate the bytearray object
      // while using the returned PByte.</para>
      /// </summary>
      class function AsBuffer(const ob: IPyObject): PByte;
      /// <summary>
      /// <para>Resize the internal buffer of bytearray to len. Return False in
      /// case of a failure with an exception set.</para>
      /// <para>Changed in version 3.14: A negative len will now result in an
      /// exception being set and False returned.</para>
      /// </summary>
      class function Resize(const ob: IPyObject; len: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Return a new bytearray object from any object, ob, that
      /// implements the buffer protocol.</para>
      /// <para>On failure, return nil with an exception set.</para>
      /// <para>Note: If the object implements the buffer protocol, then the
      /// buffer must not be mutated while the bytearray object is being
      /// created.</para>
      /// </summary>
      class function FromObject(const ob: IPyObject): IPyObject;
      /// <summary>
      /// <para>Create a new bytearray object from a string.</para>
      /// <para>On failure, return nil with an exception set.</para>
      /// </summary>
      class function FromString(const str: string): IPyObject;
      /// <summary>
      /// <para>Create a new bytearray object from str and its length, len.</para>
      /// <para>On failure, return nil with an exception set.</para>
      /// </summary>
      class function FromStringAndSize(const str: AnsiString; len: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Create a new bytearray object from buffer and its length,
      /// len.</para>
      /// <para>On failure, return nil with an exception set.</para>
      /// </summary>
      class function FromBufferAndSize(const buffer: PByte; len: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Return true if the object aPyObject is a bytearray object or an
      /// instance of a subtype of the bytearray type. This function always
      /// succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if the object aPyObject is a bytearray object,
      /// but not an instance of a subtype of the bytearray type. This function
      /// always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyType;

class function TPyByteArray.FromObject(const ob: IPyObject): IPyObject;
begin
  if assigned(PyByteArray_FromObject) and TPyObject.IsInitialized(ob) then
    Result := TPyObject.Wrap(PyByteArray_FromObject(ob.PyObject))
   else
    Result := nil;
end;

class function TPyByteArray.FromString(const str: string): IPyObject;
var
  TempString: AnsiString;
begin
  Result := nil;
  if not(assigned(PyByteArray_FromStringAndSize)) or (length(str) = 0) then exit;

  TempString := StringToPyUTF8(str);
  Result     := TPyObject.Wrap(PyByteArray_FromStringAndSize(PAnsiChar(TempString), length(TempString)));
end;

class function TPyByteArray.FromStringAndSize(const str: AnsiString; len: Py_ssize_t): IPyObject;
begin
  if assigned(PyByteArray_FromStringAndSize) then
    Result := TPyObject.Wrap(PyByteArray_FromStringAndSize(PAnsiChar(str), len))
   else
    Result := nil;
end;

class function TPyByteArray.FromBufferAndSize(const buffer: PByte; len: Py_ssize_t): IPyObject;
begin
  if assigned(PyByteArray_FromStringAndSize) and assigned(buffer) then
    Result := TPyObject.Wrap(PyByteArray_FromStringAndSize(PAnsiChar(buffer), len))
   else
    Result := nil;
end;

class function TPyByteArray.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyByteArray_Type);
end;

class function TPyByteArray.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyByteArray_Type);
end;

class function TPyByteArray.Concat(const ob1, ob2: IPyObject): IPyObject;
begin
  if assigned(PyByteArray_Concat) and
     TPyObject.IsInitialized(ob1) and
     TPyObject.IsInitialized(ob2) then
    Result := TPyObject.Wrap(PyByteArray_Concat(ob1.PyObject, ob2.PyObject))
   else
    Result := nil;
end;

class function TPyByteArray.Size(const ob: IPyObject): Py_ssize_t;
begin
  if assigned(PyByteArray_Size) and TPyObject.IsInitialized(ob) then
    Result := PyByteArray_Size(ob.PyObject)
   else
    Result := 0;
end;

class function TPyByteArray.AsString(const ob: IPyObject): string;
begin
  if assigned(PyByteArray_AsString) and TPyObject.IsInitialized(ob) then
    Result := PyUTF8ToString(PyByteArray_AsString(ob.PyObject))
   else
    Result := '';
end;

class function TPyByteArray.AsBuffer(const ob: IPyObject): PByte;
begin
  if assigned(PyByteArray_AsString) and TPyObject.IsInitialized(ob) then
    Result := PByte(PyByteArray_AsString(ob.PyObject))
   else
    Result := nil;
end;

class function TPyByteArray.Resize(const ob: IPyObject; len: Py_ssize_t): boolean;
begin
  Result := TPyObject.IsInitialized(ob) and
            assigned(PyByteArray_Resize) and
            (PyByteArray_Resize(ob.PyObject, len) <> -1);
end;

end.
