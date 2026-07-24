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
  TPyBuffer = class
    public
      class function GetPointer(var view: Py_buffer; const indices: Py_ssize_t_array): Pointer;
      class function SizeFromFormat(const format: PAnsiChar): Py_ssize_t;
      class function ToContiguous(buf: Pointer; var src: Py_buffer; len: Py_ssize_t; order: TPyBufferOrder): boolean;
      class function FromContiguous(var view: Py_buffer; const buf: Pointer; len: Py_ssize_t; fort: TPyBufferOrder): boolean;
      class function IsContiguous(var view: Py_buffer; order: TPyBufferOrder): boolean;
      class procedure FillContiguousStrides(ndims: Integer; shape, strides: PPy_ssize_t; itemsize: Integer; order: TPyBufferOrder);
      class function FillInfo(var view: Py_buffer; const exporter: IPyObject; buf: Pointer; len: Py_ssize_t; readonly, flags: Integer): boolean;
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
            (PyBuffer_IsContiguous(@view, TempOrder) = 0);
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
