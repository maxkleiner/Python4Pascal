unit uP4P.PyBuffer;

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
  /// Helper class for all PyBuffer_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/buffer.html#buffer-related-functions">See the article about Buffer-related functions.</see></para>
  /// </remarks>
  TPyBuffer = class
    public
      /// <summary>
      /// <para>Get the memory area pointed to by the indices inside the given
      /// view. indices must point to an array of view->ndim indices.</para>
      /// </summary>
      class function GetPointer(var view: Py_buffer; const indices: Py_ssize_t_array): Pointer;
      /// <summary>
      /// <para>Return the implied itemsize from format. On error, raise an
      /// exception and return -1.</para>
      /// </summary>
      class function SizeFromFormat(const format: PAnsiChar): Py_ssize_t;
      /// <summary>
      /// <para>Copy len bytes from src to its contiguous representation in buf.
      /// order can be 'C' or 'F' or 'A' (for C-style or Fortran-style ordering
      /// or either one). True is returned on success, False on error.</para>
      /// <para>This function fails if len != src->len.</para>
      /// </summary>
      class function ToContiguous(buf: Pointer; var src: Py_buffer; len: Py_ssize_t; order: TPyBufferOrder): boolean;
      /// <summary>
      /// <para>Copy contiguous len bytes from buf to view. fort can be 'C' or
      /// 'F' (for C-style or Fortran-style ordering). True is returned on
      /// success, False on error.</para>
      /// </summary>
      class function FromContiguous(var view: Py_buffer; const buf: Pointer; len: Py_ssize_t; fort: TPyBufferOrder): boolean;
      /// <summary>
      /// <para>Return True if the memory defined by the view is C-style
      /// (order is 'C') or Fortran-style (order is 'F') contiguous or
      /// either one (order is 'A'). Return False otherwise. This function
      /// always succeeds.</para>
      /// </summary>
      class function IsContiguous(var view: Py_buffer; order: TPyBufferOrder): boolean;
      /// <summary>
      /// <para>Fill the strides array with byte-strides of a contiguous
      /// (C-style if order is 'C' or Fortran-style if order is 'F') array of
      /// the given shape with the given number of bytes per element.</para>
      /// </summary>
      class procedure FillContiguousStrides(ndims: Integer; shape, strides: PPy_ssize_t; itemsize: Integer; order: TPyBufferOrder);
      /// <summary>
      /// <para>Handle buffer requests for an exporter that wants to expose buf
      /// of size len with writability set according to readonly. buf is
      /// interpreted as a sequence of unsigned bytes.</para>
      /// <para>The flags argument indicates the request type. This function
      /// always fills in view as specified by flags, unless buf has been
      /// designated as read-only and PyBUF_WRITABLE is set in flags.</para>
      /// <para>On success, set view->obj to a new reference to exporter and
      /// return True. Otherwise, raise BufferError, set view->obj to nil and
      /// return False;</para>
      /// <para>If this function is used as part of a getbufferproc, exporter
      /// MUST be set to the exporting object and flags must be passed
      /// unmodified. Otherwise, exporter MUST be nil.</para>
      /// </summary>
      class function FillInfo(var view: Py_buffer; const exporter: IPyObject; buf: Pointer; len: Py_ssize_t; readonly, flags: Integer): boolean;
      /// <summary>
      /// <para>Release the buffer view and release the strong reference
      /// (i.e. decrement the reference count) to the view's supporting object,
      /// view->obj. This function MUST be called when the buffer is no longer
      /// being used, otherwise reference leaks may occur.</para>
      /// <para>It is an error to call this function on a buffer that was not
      /// obtained via TPyObject.GetBuffer().</para>
      /// </summary>
      class procedure Release(var view: Py_buffer);
  end;

implementation

class function TPyBuffer.GetPointer(var view: Py_buffer; const indices: Py_ssize_t_array): Pointer;
begin
  if assigned(PyBuffer_GetPointer) and (length(indices) > 0) then
    Result := PyBuffer_GetPointer(@view, @indices[0])
   else
    Result := nil;
end;

class function TPyBuffer.SizeFromFormat(const format: PAnsiChar): Py_ssize_t;
begin
  if assigned(PyBuffer_SizeFromFormat) then
    Result := PyBuffer_SizeFromFormat(format)
   else
    Result := -1;
end;

class function TPyBuffer.ToContiguous(buf: Pointer; var src: Py_buffer; len: Py_ssize_t; order: TPyBufferOrder): boolean;
var
  TempOrder : AnsiChar;
begin
  case order of
    pboC         : TempOrder := 'C';
    pboFortran   : TempOrder := 'F';
    else           TempOrder := 'A'; // pboEitherOne
  end;

  Result := assigned(PyBuffer_ToContiguous) and
            (PyBuffer_ToContiguous(buf, @src, len, TempOrder) = 0);
end;

class function TPyBuffer.FromContiguous(var view: Py_buffer; const buf: Pointer; len: Py_ssize_t; fort: TPyBufferOrder): boolean;
var
  TempFort : AnsiChar;
begin
  Result := False;

  case fort of
    pboC       : TempFort := 'C';
    pboFortran : TempFort := 'F';
    else         exit;            // pboEitherOne
  end;

  Result := assigned(PyBuffer_FromContiguous) and
            (PyBuffer_FromContiguous(@view, buf, len, TempFort) = 0);
end;

class function TPyBuffer.IsContiguous(var view: Py_buffer; order: TPyBufferOrder): boolean;
var
  TempOrder : AnsiChar;
begin
  case order of
    pboC         : TempOrder := 'C';
    pboFortran   : TempOrder := 'F';
    else           TempOrder := 'A'; // pboEitherOne
  end;

  Result := assigned(PyBuffer_IsContiguous) and
            (PyBuffer_IsContiguous(@view, TempOrder) <> 0);
end;

class procedure TPyBuffer.FillContiguousStrides(ndims: Integer; shape, strides: PPy_ssize_t; itemsize: Integer; order: TPyBufferOrder);
var
  TempOrder : AnsiChar;
begin
  if assigned(PyBuffer_FillContiguousStrides) then
    begin
      case order of
        pboC       : TempOrder := 'C';
        pboFortran : TempOrder := 'F';
        else         exit;            // pboEitherOne
      end;

      PyBuffer_FillContiguousStrides(ndims, shape, strides, itemsize, TempOrder);
    end;
end;

class function TPyBuffer.FillInfo(var view: Py_buffer; const exporter: IPyObject; buf: Pointer; len: Py_ssize_t; readonly, flags: Integer): boolean;
begin
  Result := assigned(PyBuffer_FillInfo) and
            TPyObject.IsInitialized(exporter) and
            (PyBuffer_FillInfo(@view, exporter.PyObject, buf, len, readonly, flags) = 0);
end;

class procedure TPyBuffer.Release(var view: Py_buffer);
begin
  if assigned(PyBuffer_Release) then
    PyBuffer_Release(@view);
end;

end.
