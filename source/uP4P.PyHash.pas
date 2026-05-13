unit uP4P.PyHash;

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
  TPyHash = class
    public
      class function GetFuncDef: PPyHash_FuncDef;
      class function HashPointer(const ptr: Pointer): Py_hash_t;
      class function HashBuffer(const ptr: Pointer; len: Py_ssize_t): Py_hash_t;
  end;

implementation

class function TPyHash.GetFuncDef: PPyHash_FuncDef;
begin
  if assigned(PyHash_GetFuncDef) then
    Result := PyHash_GetFuncDef()
   else
    Result := nil;
end;

class function TPyHash.HashPointer(const ptr: Pointer): Py_hash_t;
begin
  if assigned(Py_HashPointer) then
    Result := Py_HashPointer(ptr)
   else
    Result := -1;
end;

class function TPyHash.HashBuffer(const ptr: Pointer; len: Py_ssize_t): Py_hash_t;
begin
  if assigned(Py_HashBuffer) then
    Result := Py_HashBuffer(ptr, len)
   else
    Result := -1;
end;


end.
