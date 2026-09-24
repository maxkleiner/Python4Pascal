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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// <para>A bytes writer instance.</para>
  /// <para>The PyBytesWriter API can be used to create a Python bytes
  /// object.</para>
  /// <para>The API is not thread safe: a writer should only be used by a
  /// single thread at the same time.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/bytes.html#pybyteswriter">See the article about PyBytesWriter.</see></para>
  /// <para>Added in version 3.15.</para>
  /// </remarks>
  TPyBytesWriter = class(TInterfacedObject, IPyBytesWriter)
    protected
      FPyBytesWriter : PPyBytesWriter;

      function GetInitialized: boolean;
      function GetWriter: PPyBytesWriter;
      /// <summary>
      /// <para>Get the writer data: start of the internal buffer.</para>
      /// <para>The pointer remains valid until a PyBytesWriter function
      /// other than TPyBytesWriter.GetData() or TPyBytesWriter.GetSize()
      /// is called on writer.</para>
      /// <para>The function cannot fail.</para>
      /// </summary>
      function GetData: Pointer;
      /// <summary>
      /// <para>Get the writer size.</para>
      /// <para>The function does not invalidate pointers returned by
      /// TPyBytesWriter.GetData().</para>
      /// <para>The function cannot fail.</para>
      /// </summary>
      function GetSize: Py_ssize_t;

      procedure SetWriter(aValue: PPyBytesWriter);
      /// <summary>
      /// <para>Discard a PyBytesWriter created by
      /// TPyBytesWriter.Create().</para>
      /// <para>Do nothing if writer is nil.</para>
      /// <para>The writer instance is invalid after the call. No API can
      /// be called on the writer after TPyBytesWriter.Discard().</para>
      /// </summary>
      procedure Discard;

    public
      constructor Create(aWriter: PPyBytesWriter); overload;
      destructor  Destroy; override;
      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      class function IsInitialized(const aWriter: IPyBytesWriter): boolean; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
      /// <summary>
      /// <para>Helper function used to wrap a PyBytesWriter pointer with a
      /// TPyBytesWriter instance.</para>
      /// </summary>
      class function Wrap(aWriter: PPyBytesWriter): IPyBytesWriter; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
      /// <summary>
      /// <para>Create a PyBytesWriter to write size bytes.</para>
      /// <para>If size is greater than zero, allocate size bytes, and set
      /// the writer size to size. The caller is responsible to write size
      /// bytes using TPyBytesWriter.GetData(). This function does not
      /// overallocate.</para>
      /// <para>On error, set an exception and return nil.</para>
      /// <para>size must be positive or zero.</para>
      /// </summary>
      class function Create(size_: Py_ssize_t): IPyBytesWriter; overload;
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
      function Finish: IPyObject;
      /// <summary>
      /// <para>Similar to TPyBytesWriter.Finish(), but resize the writer
      /// to size bytes before creating the bytes object.</para>
      /// </summary>
      function FinishWithSize(size_: Py_ssize_t): IPyObject;
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
      function FinishWithPointer(buf: Pointer): IPyObject;
      /// <summary>
      /// <para>Grow the writer internal buffer by size_ bytes, write size_
      /// bytes of bytes_ at the writer end, and add size_ to the writer
      /// size.</para>
      /// <para>If size is equal to -1, call strlen(bytes) to get the
      /// string length.</para>
      /// <para>On success, return True. On error, set an exception and
      /// return False.</para>
      /// </summary>
      function WriteBytes(const bytes_: Pointer; size_: Py_ssize_t): boolean; overload;
      /// <summary>
      /// <para>Grow the writer internal buffer by aStreamsize.size bytes,
      /// write aStream.size bytes at the writer end, and add
      /// aStreamsize.size to the writer size.</para>
      /// <para>On success, return True. On error, set an exception and
      /// return False.</para>
      /// </summary>
      function WriteBytes(const aStream: TMemoryStream): boolean; overload;
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
      function Resize(size_: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Resize the writer by adding grow bytes to the current
      /// writer size. This function typically overallocates to achieve
      /// amortized performance when resizing multiple times.</para>
      /// <para>Newly allocated bytes are left uninitialized.</para>
      /// <para>On success, return True. On error, set an exception
      /// and return False.</para>
      /// <para>size can be negative to shrink the writer.</para>
      /// </summary>
      function Grow(size_: Py_ssize_t): boolean;
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
      function GrowAndUpdatePointer(size_: Py_ssize_t; buf: Pointer): Pointer;
      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      property Initialized  : boolean               read GetInitialized;
      /// <summary>
      /// <para>Pointer to PyBytesWriter</para>
      /// </summary>
      property Writer       : PPyBytesWriter        read GetWriter         write SetWriter;
      /// <summary>
      /// <para>Get the writer data: start of the internal buffer.</para>
      /// <para>The pointer remains valid until a PyBytesWriter function
      /// other than TPyBytesWriter.GetData() or TPyBytesWriter.GetSize()
      /// is called on writer.</para>
      /// <para>The function cannot fail.</para>
      /// </summary>
      property Data         : Pointer               read GetData;
      /// <summary>
      /// <para>Get the writer size.</para>
      /// <para>The function does not invalidate pointers returned by
      /// TPyBytesWriter.GetData().</para>
      /// <para>The function cannot fail.</para>
      /// </summary>
      property Size         : Py_ssize_t            read GetSize;
  end;

implementation

constructor TPyBytesWriter.Create(aWriter: PPyBytesWriter);
begin
  inherited Create;

  FPyBytesWriter := aWriter;
end;

destructor TPyBytesWriter.Destroy;
begin
  Discard;

  inherited Destroy;
end;

class function TPyBytesWriter.IsInitialized(const aWriter: IPyBytesWriter): boolean;
begin
  Result := (aWriter <> nil) and aWriter.Initialized;
end;

class function TPyBytesWriter.Wrap(aWriter: PPyBytesWriter): IPyBytesWriter;
begin
  if assigned(aWriter) then
    Result := TPyBytesWriter.Create(aWriter)
   else
    Result := nil;
end;

function TPyBytesWriter.GetInitialized: boolean;
begin
  Result := assigned(FPyBytesWriter);
end;

function TPyBytesWriter.GetWriter: PPyBytesWriter;
begin
  Result := FPyBytesWriter;
end;

procedure TPyBytesWriter.SetWriter(aValue: PPyBytesWriter);
begin
  FPyBytesWriter := aValue;
end;

class function TPyBytesWriter.Create(size_: Py_ssize_t): IPyBytesWriter;
begin
  if assigned(PyBytesWriter_Create) and (size_ >= 0) then
    Result := TPyBytesWriter.Wrap(PyBytesWriter_Create(size_))
   else
    Result := nil;
end;

procedure TPyBytesWriter.Discard;
begin
  if Initialized and assigned(PyBytesWriter_Discard) then
    begin
      PyBytesWriter_Discard(FPyBytesWriter);
      FPyBytesWriter := nil;
    end;
end;

function TPyBytesWriter.Finish: IPyObject;
begin
  if Initialized and assigned(PyBytesWriter_Finish) then
    begin
      Result := TPyObject.Wrap(PyBytesWriter_Finish(FPyBytesWriter));
      FPyBytesWriter := nil;
    end
   else
    Result := nil;
end;

function TPyBytesWriter.FinishWithSize(size_: Py_ssize_t): IPyObject;
begin
  if Initialized and assigned(PyBytesWriter_FinishWithSize) then
    begin
      Result := TPyObject.Wrap(PyBytesWriter_FinishWithSize(FPyBytesWriter, size_));
      FPyBytesWriter := nil;
    end
   else
    Result := nil;
end;

function TPyBytesWriter.FinishWithPointer(buf: Pointer): IPyObject;
begin
  if Initialized and assigned(PyBytesWriter_FinishWithPointer) then
    begin
      Result := TPyObject.Wrap(PyBytesWriter_FinishWithPointer(FPyBytesWriter, buf));
      FPyBytesWriter := nil;
    end
   else
    Result := nil;
end;

function TPyBytesWriter.GetData: Pointer;
begin
  if Initialized and assigned(PyBytesWriter_GetData) then
    Result := PyBytesWriter_GetData(FPyBytesWriter)
   else
    Result := nil;
end;

function TPyBytesWriter.GetSize: Py_ssize_t;
begin
  if Initialized and assigned(PyBytesWriter_GetSize) then
    Result := PyBytesWriter_GetSize(FPyBytesWriter)
   else
    Result := 0;
end;

function TPyBytesWriter.WriteBytes(const bytes_: Pointer; size_: Py_ssize_t): boolean;
begin
  Result := Initialized and
            assigned(bytes_) and
            assigned(PyBytesWriter_WriteBytes) and
            (PyBytesWriter_WriteBytes(writer, bytes_, size_) = 0);
end;

function TPyBytesWriter.WriteBytes(const aStream: TMemoryStream): boolean;
begin
  if assigned(aStream) and (aStream.Size > 0) then
    Result := WriteBytes(aStream.Memory, aStream.Size)
   else
    Result := False;
end;

function TPyBytesWriter.Resize(size_: Py_ssize_t): boolean;
begin
  Result := Initialized and
            assigned(PyBytesWriter_Resize) and
            (PyBytesWriter_Resize(writer, size_) = 0);
end;

function TPyBytesWriter.Grow(size_: Py_ssize_t): boolean;
begin
  Result := Initialized and
            assigned(PyBytesWriter_Grow) and
            (PyBytesWriter_Grow(writer, size_) = 0);
end;

function TPyBytesWriter.GrowAndUpdatePointer(size_: Py_ssize_t; buf: Pointer): Pointer;
begin
  if Initialized and
     assigned(buf) and
     assigned(PyBytesWriter_GrowAndUpdatePointer) then
    Result := PyBytesWriter_GrowAndUpdatePointer(writer, size_, buf)
   else
    Result := nil;
end;

end.
