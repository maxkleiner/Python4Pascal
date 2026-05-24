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
  TPyTraceMalloc = class
    public
      class function Track(domain: cardinal; ptr: Py_uintptr_t; size: NativeUInt): integer;
      class function Untrack(domain: cardinal; ptr: Py_uintptr_t): boolean;
  end;

implementation

class function TPyTraceMalloc.Track(domain: cardinal; ptr: Py_uintptr_t; size: NativeUInt): integer;
begin
  if assigned(PyTraceMalloc_Track) then
    Result := PyTraceMalloc_Track(domain, ptr, size)
   else
    Result := -1;
end;

class function TPyTraceMalloc.Untrack(domain: cardinal; ptr: Py_uintptr_t): boolean;
begin
  Result := assigned(PyTraceMalloc_Untrack) and
            (PyTraceMalloc_Untrack(domain, ptr) = 0);
end;

end.
