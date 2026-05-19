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
  TPyThread = class
    public
      class procedure init_thread;
      class function  start_new_thread(func_: PyThread_start_new_thread_func; arg: Pointer): C_ULong;
      class function  get_thread_ident: C_ULong;
      class function  get_thread_native_id: C_ULong;
      class function  get_stacksize: NativeUInt;
      class function  set_stacksize(size: NativeUInt): integer;
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

class function TPyThread.set_stacksize(size: NativeUInt): integer;
begin
  if assigned(PyThread_set_stacksize) then
    Result := PyThread_set_stacksize(size)
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
