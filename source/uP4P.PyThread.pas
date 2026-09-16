unit uP4P.PyThread;

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
  /// Helper class for all PyThread_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/threads.html#operating-system-thread-apis">See the article about Operating system thread APIs.</see></para>
  /// </remarks>
  TPyThread = class
    public
      /// <summary>
      /// <para>Initialize PyThread* APIs. Python executes this function
      /// automatically, so there's little need to call it from an extension
      /// module.</para>
      /// </summary>
      class procedure init_thread;
      /// <summary>
      /// <para>Start function func in a new thread with argument arg. The
      /// resulting thread is not intended to be joined.</para>
      /// <para>func must not be nil, but arg may be nil.</para>
      /// <para>On success, this function returns the identifier of the new
      /// thread; on failure, this returns PYTHREAD_INVALID_THREAD_ID.</para>
      /// <para>The caller does not need to hold an attached thread
      /// state.</para>
      /// </summary>
      class function  start_new_thread(func_: PyThread_start_new_thread_func; arg: Pointer): C_ULong;
      /// <summary>
      /// <para>Return the identifier of the current thread, which will never
      /// be zero.</para>
      /// <para>This function cannot fail, and the caller does not need to hold
      /// an attached thread state.</para>
      /// <para>See also threading.get_ident() and threading.Thread.ident
      /// expose this identifier to Python.</para>
      /// </summary>
      class function  get_thread_ident: C_ULong;
      /// <summary>
      /// <para>Get the native identifier of the current thread as it was
      /// assigned by the operating system's kernel, which will never be less
      /// than zero.</para>
      /// <para>This function is only available when PY_HAVE_THREAD_NATIVE_ID
      /// is defined.</para>
      /// <para>This function cannot fail, and the caller does not need to hold
      /// an attached thread state.</para>
      /// <para>See also threading.get_native_id()</para>
      /// </summary>
      class function  get_thread_native_id: C_ULong;
      /// <summary>
      /// <para>Return the stack size of the current thread in bytes, or 0 if
      /// the system's default stack size is in use.</para>
      /// <para>The caller does not need to hold an attached thread
      /// state.</para>
      /// </summary>
      class function  get_stacksize: NativeUInt;
      /// <summary>
      /// <para>Set the stack size of the current thread to size bytes.</para>
      /// <para>This function returns 0 on success, -1 if size is invalid, or -2
      /// if the system does not support changing the stack size. This function
      /// does not set exceptions.</para>
      /// <para>The caller does not need to hold an attached thread
      /// state.</para>
      /// </summary>
      class function  set_stacksize(size_: NativeUInt): integer;
      /// <summary>
      /// <para>Get general information about the current thread in the form of
      /// a struct sequence object. This information is accessible as
      /// sys.thread_info in Python.</para>
      /// <para>On success, this returns a new strong reference to the thread
      /// information; on failure, this returns nil with an exception
      /// set.</para>
      /// <para>The caller must hold an attached thread state.</para>
      /// </summary>
      class function  GetInfo: IPyObject;
  end;

implementation

class procedure TPyThread.init_thread;
begin
  if assigned(PyThread_init_thread) then
    PyThread_init_thread();
end;

class function TPyThread.start_new_thread(func_: PyThread_start_new_thread_func; arg: Pointer): C_ULong;
begin
  if assigned(PyThread_start_new_thread) then
    Result := PyThread_start_new_thread(func_, arg)
   else
    Result := PYTHREAD_INVALID_THREAD_ID;
end;

class function TPyThread.get_thread_ident: C_ULong;
begin
  if assigned(PyThread_get_thread_ident) then
    Result := PyThread_get_thread_ident()
   else
    Result := PYTHREAD_INVALID_THREAD_ID;
end;

class function TPyThread.get_thread_native_id: C_ULong;
begin
  if assigned(PyThread_get_thread_native_id) then
    Result := PyThread_get_thread_native_id()
   else
    Result := PYTHREAD_INVALID_THREAD_ID;
end;

class function TPyThread.get_stacksize: NativeUInt;
begin
  if assigned(PyThread_get_stacksize) then
    Result := PyThread_get_stacksize()
   else
    Result := 0;
end;

class function TPyThread.set_stacksize(size_: NativeUInt): integer;
begin
  if assigned(PyThread_set_stacksize) then
    Result := PyThread_set_stacksize(size_)
   else
    Result := -2;
end;

class function TPyThread.GetInfo: IPyObject;
begin
  if assigned(PyThread_GetInfo) then
    Result := TPyObject.Wrap(PyThread_GetInfo())
   else
    Result := nil;
end;

end.
