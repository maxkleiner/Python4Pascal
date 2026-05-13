unit uP4P.PyMem;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces;

type
  TPyMem = class
    public
      class function  Malloc(size: NativeUInt): Pointer;
      class function  Calloc(nelem, elsize: NativeUInt): Pointer;
      class function  Realloc(ptr: Pointer; new_size: NativeUInt): Pointer;
      class procedure Free(ptr: Pointer);
      class function  RawMalloc(size: NativeUInt): Pointer;
      class function  RawCalloc(nelem, elsize: NativeUInt): Pointer;
      class function  RawRealloc(ptr: Pointer; new_size: NativeUInt): Pointer;
      class procedure RawFree(ptr: Pointer);
      class procedure GetAllocator(domain: PyMemAllocatorDomain; out allocator: PyMemAllocatorEx);
      class procedure SetAllocator(domain: PyMemAllocatorDomain; var allocator: PyMemAllocatorEx);
      class procedure SetupDebugHooks;
  end;

implementation

class function TPyMem.Malloc(size: NativeUInt): Pointer;
begin
  if assigned(PyMem_Malloc) then
    Result := PyMem_Malloc(size)
   else
    Result := nil;
end;

class function TPyMem.Calloc(nelem, elsize: NativeUInt): Pointer;
begin
  if assigned(PyMem_Calloc) then
    Result := PyMem_Calloc(nelem, elsize)
   else
    Result := nil;
end;

class function TPyMem.Realloc(ptr: Pointer; new_size: NativeUInt): Pointer;
begin
  if assigned(PyMem_Realloc) then
    Result := PyMem_Realloc(ptr, new_size)
   else
    Result := nil;
end;

class procedure TPyMem.Free(ptr: Pointer);
begin
  if assigned(PyMem_Free) and assigned(ptr) then
    PyMem_Free(ptr);
end;

class function TPyMem.RawMalloc(size: NativeUInt): Pointer;
begin
  if assigned(PyMem_RawMalloc) then
    Result := PyMem_RawMalloc(size)
   else
    Result := nil;
end;

class function TPyMem.RawCalloc(nelem, elsize: NativeUInt): Pointer;
begin
  if assigned(PyMem_RawCalloc) then
    Result := PyMem_RawCalloc(nelem, elsize)
   else
    Result := nil;
end;

class function TPyMem.RawRealloc(ptr: Pointer; new_size: NativeUInt): Pointer;
begin
  if assigned(PyMem_RawRealloc) then
    Result := PyMem_RawRealloc(ptr, new_size)
   else
    Result := nil;
end;

class procedure TPyMem.RawFree(ptr: Pointer);
begin
  if assigned(PyMem_RawFree) and assigned(ptr) then
    PyMem_RawFree(ptr);
end;

class procedure TPyMem.GetAllocator(domain: PyMemAllocatorDomain; out allocator: PyMemAllocatorEx);
begin
  if assigned(PyMem_GetAllocator) then
    PyMem_GetAllocator(domain, allocator);
end;

class procedure TPyMem.SetAllocator(domain: PyMemAllocatorDomain; var allocator: PyMemAllocatorEx);
begin
  if assigned(PyMem_SetAllocator) then
    PyMem_SetAllocator(domain, @allocator);
end;

class procedure TPyMem.SetupDebugHooks;
begin
  if assigned(PyMem_SetupDebugHooks) then
    PyMem_SetupDebugHooks();
end;

end.
