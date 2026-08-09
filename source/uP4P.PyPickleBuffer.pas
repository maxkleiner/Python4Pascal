unit uP4P.PyPickleBuffer;

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
  /// Helper class for all PyPickleBuffer_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/picklebuffer.html#pickle-buffer-objects">See the article about Pickle buffer objects.</see></para>
  /// </remarks>
  TPyPickleBuffer = class
    public
      /// <summary>
      /// <para>Return true if op is a pickle buffer instance. This function
      /// always succeeds.</para>
      /// </summary>
      class function Check(const op: IPyObject): boolean;
      /// <summary>
      /// <para>Create a pickle buffer from the object obj.</para>
      /// <para>This function will fail if obj doesn't support the buffer
      /// protocol.</para>
      /// <para>On success, return a new pickle buffer instance. On failure,
      /// set an exception and return nil.</para>
      /// <para>Analogous to calling pickle.PickleBuffer with obj in
      /// Python.</para>
      /// </summary>
      class function FromObject(const obj: IPyObject): IPyObject;
      /// <summary>
      /// <para>Get a pointer to the underlying Py_buffer that the pickle
      /// buffer wraps.</para>
      /// <para>The returned pointer is valid as long as picklebuf is alive and
      /// has not been released. The caller must not modify or free the
      /// returned Py_buffer. If the pickle buffer has been released, raise
      /// ValueError.</para>
      /// <para>On success, return a pointer to the buffer view. On failure,
      /// set an exception and return nil.</para>
      /// </summary>
      class function GetBuffer(const picklebuf: IPyObject): PPy_buffer;
      /// <summary>
      /// <para>Release the underlying buffer held by the pickle buffer.</para>
      /// <para>Return True on success. On failure, set an exception and return
      /// False.</para>
      /// <para>Analogous to calling pickle.PickleBuffer.release() in
      /// Python.</para>
      /// </summary>
      class function Release(const picklebuf: IPyObject): boolean;
  end;

implementation

class function TPyPickleBuffer.Check(const op: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(op) and
            op.IsType(PyPickleBuffer_Type);
end;

class function TPyPickleBuffer.FromObject(const obj: IPyObject): IPyObject;
begin
  if assigned(PyPickleBuffer_FromObject) and
     TPyObject.IsInitialized(obj) then
    Result := TPyObject.Wrap(PyPickleBuffer_FromObject(obj.PyObject))
   else
    Result := nil;
end;

class function TPyPickleBuffer.GetBuffer(const picklebuf: IPyObject): PPy_buffer;
begin
  if assigned(PyPickleBuffer_GetBuffer) and
     TPyObject.IsInitialized(picklebuf) then
    Result := PyPickleBuffer_GetBuffer(picklebuf.PyObject)
   else
    Result := nil;
end;

class function TPyPickleBuffer.Release(const picklebuf: IPyObject): boolean;
begin
  Result := assigned(PyPickleBuffer_Release) and
            TPyObject.IsInitialized(picklebuf) and
            (PyPickleBuffer_Release(picklebuf.PyObject) = 0);
end;

end.
