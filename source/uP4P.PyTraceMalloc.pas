unit uP4P.PyTraceMalloc;

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
  /// Helper class for all PyTraceMalloc_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/memory.html#tracemalloc-c-api">See the article about the tracemalloc C API.</see></para>
  /// </remarks>
  TPyTraceMalloc = class
    public
      /// <summary>
      /// <para>Track an allocated memory block in the tracemalloc
      /// module.</para>
      /// <para>Return 0 on success, return -1 on error (failed to allocate
      /// memory to store the trace). Return -2 if tracemalloc is
      /// disabled.</para>
      /// <para>If memory block is already tracked, update the existing
      /// trace.</para>
      /// </summary>
      class function Track(domain: cardinal; ptr: Py_uintptr_t; size_: NativeUInt): integer;
      /// <summary>
      /// <para>Untrack an allocated memory block in the tracemalloc module.
      /// Do nothing if the block was not tracked.</para>
      /// <para>Return False if tracemalloc is disabled, otherwise
      /// return True.</para>
      /// </summary>
      class function Untrack(domain: cardinal; ptr: Py_uintptr_t): boolean;
  end;

implementation

class function TPyTraceMalloc.Track(domain: cardinal; ptr: Py_uintptr_t; size_: NativeUInt): integer;
begin
  if assigned(PyTraceMalloc_Track) then
    Result := PyTraceMalloc_Track(domain, ptr, size_)
   else
    Result := -1;
end;

class function TPyTraceMalloc.Untrack(domain: cardinal; ptr: Py_uintptr_t): boolean;
begin
  Result := assigned(PyTraceMalloc_Untrack) and
            (PyTraceMalloc_Untrack(domain, ptr) = 0);
end;

end.
