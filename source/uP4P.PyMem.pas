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
  /// <summary>
  /// Helper class for all PyMem_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/memory.html#memory-interface">See the article about Memory Interface.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/memory.html#raw-memory-interface">See the article about Raw Memory Interface.</see></para>
  /// </remarks>
  TPyMem = class
    public
      /// <summary>
      /// <para>Allocates n bytes and returns a pointer to the allocated memory,
      /// or nil if the request fails.</para>
      /// <para>Requesting zero bytes returns a distinct non-nil pointer if
      /// possible, as if TPyMem.Malloc(1) had been called instead. The memory
      /// will not have been initialized in any way.</para>
      /// </summary>
      class function  Malloc(n: NativeUInt): Pointer;
      /// <summary>
      /// <para>Allocates nelem elements each of size elsize bytes and returns
      /// a pointer to the allocated memory, or nil if the request fails. The
      /// memory is initialized to zeros.</para>
      /// <para>Requesting zero elements or elements of size zero bytes returns
      /// a distinct non-nil pointer if possible, as if TPyMem.Calloc(1, 1) had
      /// been called instead.</para>
      /// </summary>
      class function  Calloc(nelem, elsize: NativeUInt): Pointer;
      /// <summary>
      /// <para>Resizes the memory block pointed to by p to n bytes. The
      /// contents will be unchanged to the minimum of the old and the new
      /// sizes.</para>
      /// <para>If p is nil, the call is equivalent to TPyMem.Malloc(n); else
      /// if n is equal to zero, the memory block is resized but is not freed,
      /// and the returned pointer is non-nil.</para>
      /// <para>Unless p is nil, it must have been returned by a previous call
      /// to TPyMem.Malloc(), TPyMem.Realloc() or TPyMem.Calloc().</para>
      /// <para>If the request fails, TPyMem.Realloc() returns nil and p
      /// remains a valid pointer to the previous memory area.</para>
      /// </summary>
      class function  Realloc(p: Pointer; n: NativeUInt): Pointer;
      /// <summary>
      /// <para>Frees the memory block pointed to by p, which must have been
      /// returned by a previous call to TPyMem.Malloc(), TPyMem.Realloc() or
      /// TPyMem.Calloc(). Otherwise, or if TPyMem.Free(p) has been called
      /// before, undefined behavior occurs.</para>
      /// <para>If p is nil, no operation is performed.</para>
      /// </summary>
      class procedure Free(p: Pointer);
      /// <summary>
      /// <para>Allocates n bytes and returns a pointer to the allocated memory,
      /// or nil if the request fails.</para>
      /// <para>Requesting zero bytes returns a distinct non-nil pointer if
      /// possible, as if TPyMem.RawMalloc(1) had been called instead. The
      /// memory will not have been initialized in any way.</para>
      /// </summary>
      class function  RawMalloc(n: NativeUInt): Pointer;
      /// <summary>
      /// <para>Allocates nelem elements each of size elsize bytes and returns
      /// a pointer to the allocated memory, or nil if the request fails. The
      /// memory is initialized to zeros.</para>
      /// <para>Requesting zero elements or elements of size zero bytes returns
      /// a distinct non-nil pointer if possible, as if TPyMem.RawCalloc(1, 1)
      /// had been called instead.</para>
      /// </summary>
      class function  RawCalloc(nelem, elsize: NativeUInt): Pointer;
      /// <summary>
      /// <para>Resizes the memory block pointed to by p to n bytes. The
      /// contents will be unchanged to the minimum of the old and the new
      /// sizes.</para>
      /// <para>If p is nil, the call is equivalent to TPyMem.RawMalloc(n);
      /// else if n is equal to zero, the memory block is resized but is not
      /// freed, and the returned pointer is non-nil.</para>
      /// <para>Unless p is nil, it must have been returned by a previous
      /// call to TPyMem.RawMalloc(), TPyMem.RawRealloc() or
      /// TPyMem.RawCalloc().</para>
      /// <para>If the request fails, TPyMem.RawRealloc() returns nil and p
      /// remains a valid pointer to the previous memory area.</para>
      /// </summary>
      class function  RawRealloc(p: Pointer; n: NativeUInt): Pointer;
      /// <summary>
      /// <para>Frees the memory block pointed to by p, which must have been
      /// returned by a previous call to TPyMem.RawMalloc(), TPyMem.RawRealloc()
      /// or TPyMem.RawCalloc(). Otherwise, or if TPyMem.RawFree(p) has been
      /// called before, undefined behavior occurs.</para>
      /// <para>If p is nil, no operation is performed.</para>
      /// </summary>
      class procedure RawFree(p: Pointer);
      /// <summary>
      /// <para>Get the memory block allocator of the specified domain.</para>
      /// </summary>
      class procedure GetAllocator(domain: PyMemAllocatorDomain; out allocator: PyMemAllocatorEx);
      /// <summary>
      /// <para>Set the memory block allocator of the specified domain.</para>
      /// <para>The new allocator must return a distinct non-nil pointer when
      /// requesting zero bytes.</para>
      /// <para>For the PYMEM_DOMAIN_RAW domain, the allocator must be
      /// thread-safe: a thread state is not attached when the allocator is
      /// called.</para>
      /// <para>For the remaining domains, the allocator must also be
      /// thread-safe: the allocator may be called in different interpreters
      /// that do not share a GIL.</para>
      /// <para>If the new allocator is not a hook (does not call the previous
      /// allocator), the TPyMem.SetupDebugHooks() function must be called to
      /// reinstall the debug hooks on top on the new allocator.</para>
      /// <para>See also PyPreConfig.allocator and Preinitialize Python with
      /// PyPreConfig.</para>
      /// <para>Warning TPyMem.SetAllocator() does have the following
      /// contract:</para>
      /// <code>
      /// - It can be called after TPy.PreInitialize() and before
      ///   TPy.InitializeFromConfig() to install a custom memory allocator.
      ///   There are no restrictions over the installed allocator other than
      ///   the ones imposed by the domain (for instance, the Raw Domain allows
      ///   the allocator to be called without an attached thread state). See
      ///   the section on allocator domains for more information.
      /// - If called after Python has finish initializing (after
      ///   TPy.InitializeFromConfig() has been called) the allocator must wrap
      ///   the existing allocator. Substituting the current allocator for some
      ///   other arbitrary one is not supported.
      /// </code>
      /// <para>Changed in version 3.12: All allocators must be
      /// thread-safe.</para>
      /// </summary>
      class procedure SetAllocator(domain: PyMemAllocatorDomain; var allocator: PyMemAllocatorEx);
      /// <summary>
      /// <para>Setup debug hooks in the Python memory allocators to detect
      /// memory errors.</para>
      /// </summary>
      class procedure SetupDebugHooks;
  end;

implementation

class function TPyMem.Malloc(n: NativeUInt): Pointer;
begin
  if assigned(PyMem_Malloc) then
    Result := PyMem_Malloc(n)
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

class function TPyMem.Realloc(p: Pointer; n: NativeUInt): Pointer;
begin
  if assigned(PyMem_Realloc) then
    Result := PyMem_Realloc(p, n)
   else
    Result := nil;
end;

class procedure TPyMem.Free(p: Pointer);
begin
  if assigned(PyMem_Free) and assigned(p) then
    PyMem_Free(p);
end;

class function TPyMem.RawMalloc(n: NativeUInt): Pointer;
begin
  if assigned(PyMem_RawMalloc) then
    Result := PyMem_RawMalloc(n)
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

class function TPyMem.RawRealloc(p: Pointer; n: NativeUInt): Pointer;
begin
  if assigned(PyMem_RawRealloc) then
    Result := PyMem_RawRealloc(p, n)
   else
    Result := nil;
end;

class procedure TPyMem.RawFree(p: Pointer);
begin
  if assigned(PyMem_RawFree) and assigned(p) then
    PyMem_RawFree(p);
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
