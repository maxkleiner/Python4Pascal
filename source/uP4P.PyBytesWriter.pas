unit uP4P.PyBytesWriter;

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
  /// <para>The PyBytesWriter API can be used to create a Python bytes
  /// object.</para>
  /// <para>Added in version 3.15.</para>
  /// objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/bytes.html#pybyteswriter">See the article about PyBytesWriter.</see></para>
  /// </remarks>
  TPyBytesWriter = class
    public
      /// <summary>
      /// <para>Create a PyBytesWriter to write size bytes.</para>
      /// <para>If size is greater than zero, allocate size bytes, and set
      /// the writer size to size. The caller is responsible to write size
      /// bytes using TPyBytesWriter.GetData(). This function does not
      /// overallocate.</para>
      /// <para>On error, set an exception and return nil.</para>
      /// <para>size must be positive or zero.</para>
      /// </summary>
      class function Create(size_: Py_ssize_t): PPyBytesWriter;
      /// <summary>
      /// <para>Discard a PyBytesWriter created by
      /// TPyBytesWriter.Create().</para>
      /// <para>Do nothing if writer is nil.</para>
      /// <para>The writer instance is invalid after the call. No API can
      /// be called on the writer after TPyBytesWriter.Discard().</para>
      /// </summary>
      class procedure Discard(writer: PPyBytesWriter);
      /// <summary>
      /// <para>Finish a PyBytesWriter created by
      /// TPyBytesWriter.Create().</para>
      /// <para>On success, return a Python bytes object. On error, set an
      /// exception and return nil.</para>
      /// <para>The writer instance is invalid after the call in any
      /// case.</para>
      /// <para>No API can be called on the writer after
      /// TPyBytesWriter.Finish().</para>
      /// </summary>
      class function Finish(writer: PPyBytesWriter): IPyObject;
      /// <summary>
      /// <para>Similar to TPyBytesWriter.Finish(), but resize the writer
      /// to size bytes before creating the bytes object.</para>
      /// </summary>
      class function FinishWithSize(writer: PPyBytesWriter; size_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Similar to TPyBytesWriter.Finish(), but resize the writer
      /// using buf pointer before creating the bytes object.</para>
      /// <para>Set an exception and return nil if buf pointer is outside
      /// the internal buffer bounds.</para>
      /// <para>Function pseudo-code:</para>
      /// <code>
      /// Py_ssize_t size = (char*)buf - (char*)PyBytesWriter_GetData(writer);
      /// return PyBytesWriter_FinishWithSize(writer, size);</para>
      /// </code>
      /// </summary>
      class function FinishWithPointer(writer: PPyBytesWriter; buf: Pointer): IPyObject;
      /// <summary>
      /// <para>Get the writer data: start of the internal buffer.</para>
      /// <para>The pointer remains valid until a PyBytesWriter function
      /// other than TPyBytesWriter.GetData() or TPyBytesWriter.GetSize()
      /// is called on writer.</para>
      /// <para>The function cannot fail.</para>
      /// </summary>
      class function GetData(writer: PPyBytesWriter): Pointer;
      /// <summary>
      /// <para>Get the writer size.</para>
      /// <para>The function does not invalidate pointers returned by
      /// TPyBytesWriter.GetData().</para>
      /// <para>The function cannot fail.</para>
      /// </summary>
      class function GetSize(writer: PPyBytesWriter): Py_ssize_t;
      /// <summary>
      /// <para>Grow the writer internal buffer by size_ bytes, write size_
      /// bytes of bytes_ at the writer end, and add size_ to the writer
      /// size.</para>
      /// <para>If size is equal to -1, call strlen(bytes) to get the
      /// string length.</para>
      /// <para>On success, return True. On error, set an exception and
      /// return False.</para>
      /// </summary>
      class function WriteBytes(writer: PPyBytesWriter; const bytes_: Pointer; size_: Py_ssize_t): boolean; overload;
      /// <summary>
      /// <para>Grow the writer internal buffer by aStreamsize.size bytes,
      /// write aStream.size bytes at the writer end, and add
      /// aStreamsize.size to the writer size.</para>
      /// <para>On success, return True. On error, set an exception and
      /// return False.</para>
      /// </summary>
      class function WriteBytes(writer: PPyBytesWriter; const aStream: TMemoryStream): boolean; overload;
      /// <summary>
      /// <para>Resize the writer to size bytes. It can be used to enlarge
      /// or to shrink the writer. This function typically overallocates
      /// to achieve amortized performance when resizing multiple
      /// times.</para>
      /// <para>Newly allocated bytes are left uninitialized.</para>
      /// <para>On success, return True. On error, set an exception
      /// and return False.</para>
      /// <para>size must be positive or zero.</para>
      /// </summary>
      class function Resize(writer: PPyBytesWriter; size_: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Resize the writer by adding grow bytes to the current
      /// writer size. This function typically overallocates to achieve
      /// amortized performance when resizing multiple times.</para>
      /// <para>Newly allocated bytes are left uninitialized.</para>
      /// <para>On success, return True. On error, set an exception
      /// and return False.</para>
      /// <para>size can be negative to shrink the writer.</para>
      /// </summary>
      class function Grow(writer: PPyBytesWriter; size_: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Similar to TPyBytesWriter.Grow(), but update also the
      /// buf pointer.</para>
      /// <para>The buf pointer is moved if the internal buffer is moved
      /// in memory. The buf relative position within the internal buffer
      /// is left unchanged.</para>
      /// <para>On error, set an exception and return nil.</para>
      /// <para>buf must not be nil.</para>
      /// <para>Function pseudo-code:</para>
      /// <code>
      /// Py_ssize_t pos = (char*)buf - (char*)PyBytesWriter_GetData(writer);
      /// if (PyBytesWriter_Grow(writer, size) < 0) {
      ///     return NULL;
      /// }
      /// return (char*)PyBytesWriter_GetData(writer) + pos;
      /// </code>
      /// </summary>
      class function GrowAndUpdatePointer(writer: PPyBytesWriter; size_: Py_ssize_t; buf: Pointer): Pointer;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

// TPyBytesWriter

class function TPyBytesWriter.Create(size_: Py_ssize_t): PPyBytesWriter;
begin
  if assigned(PyBytesWriter_Create) and (size_ >= 0) then
    Result := PyBytesWriter_Create(size_)
   else
    Result := nil;
end;

class procedure TPyBytesWriter.Discard(writer: PPyBytesWriter);
begin
  if assigned(PyBytesWriter_Discard) and assigned(writer) then
    PyBytesWriter_Discard(writer);
end;

class function TPyBytesWriter.Finish(writer: PPyBytesWriter): IPyObject;
begin
  if assigned(PyBytesWriter_Finish) and assigned(writer) then
    Result := TPyObject.Wrap(PyBytesWriter_Finish(writer))
   else
    Result := nil;
end;

class function TPyBytesWriter.FinishWithSize(writer: PPyBytesWriter; size_: Py_ssize_t): IPyObject;
begin
  if assigned(PyBytesWriter_FinishWithSize) and assigned(writer) then
    Result := TPyObject.Wrap(PyBytesWriter_FinishWithSize(writer, size_))
   else
    Result := nil;
end;

class function TPyBytesWriter.FinishWithPointer(writer: PPyBytesWriter; buf: Pointer): IPyObject;
begin
  if assigned(PyBytesWriter_FinishWithPointer) and assigned(writer) then
    Result := TPyObject.Wrap(PyBytesWriter_FinishWithPointer(writer, buf))
   else
    Result := nil;
end;

class function TPyBytesWriter.GetData(writer: PPyBytesWriter): Pointer;
begin
  if assigned(PyBytesWriter_GetData) and assigned(writer) then
    Result := PyBytesWriter_GetData(writer)
   else
    Result := nil;
end;

class function TPyBytesWriter.GetSize(writer: PPyBytesWriter): Py_ssize_t;
begin
  if assigned(PyBytesWriter_GetSize) and assigned(writer) then
    Result := PyBytesWriter_GetSize(writer)
   else
    Result := 0;
end;

class function TPyBytesWriter.WriteBytes(writer: PPyBytesWriter; const bytes_: Pointer; size_: Py_ssize_t): boolean;
begin
  Result := assigned(writer) and
            assigned(bytes_) and
            assigned(PyBytesWriter_WriteBytes) and
            (PyBytesWriter_WriteBytes(writer, bytes_, size_) = 0);
end;

class function TPyBytesWriter.WriteBytes(writer: PPyBytesWriter; const aStream: TMemoryStream): boolean;
begin
  if assigned(aStream) and (aStream.Size > 0) then
    Result := WriteBytes(writer, aStream.Memory, aStream.Size)
   else
    Result := False;
end;

class function TPyBytesWriter.Resize(writer: PPyBytesWriter; size_: Py_ssize_t): boolean;
begin
  Result := assigned(writer) and
            assigned(PyBytesWriter_Resize) and
            (PyBytesWriter_Resize(writer, size_) = 0);
end;

class function TPyBytesWriter.Grow(writer: PPyBytesWriter; size_: Py_ssize_t): boolean;
begin
  Result := assigned(writer) and
            assigned(PyBytesWriter_Grow) and
            (PyBytesWriter_Grow(writer, size_) = 0);
end;

class function TPyBytesWriter.GrowAndUpdatePointer(writer: PPyBytesWriter; size_: Py_ssize_t; buf: Pointer): Pointer;
begin
  if assigned(writer) and
     assigned(buf) and
     assigned(PyBytesWriter_GrowAndUpdatePointer) then
    Result := PyBytesWriter_GrowAndUpdatePointer(writer, size_, buf)
   else
    Result := nil;
end;

end.
