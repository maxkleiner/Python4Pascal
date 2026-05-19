unit uP4P.PyMutex;

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
  TPyMutex = class(TInterfacedObject, IPyMutex)
    protected
      FPyMutex : PyMutex;

      function GetPyMutex: Pointer;

    public
      constructor Create; overload;
      constructor Create(const aPyMutex: PyMutex); overload;
      procedure Lock;
      procedure Unlock;
      function  IsLocked: boolean;

      property PyMutex : Pointer read GetPyMutex;
  end;

implementation

constructor TPyMutex.Create;
begin
  inherited Create;

  FillChar(FPyMutex, SizeOf(FPyMutex), #0);
end;

constructor TPyMutex.Create(const aPyMutex: PyMutex);
begin
  inherited Create;

  FPyMutex := aPyMutex;
end;

procedure TPyMutex.Lock;
begin
  if assigned(PyMutex_Lock) then
    PyMutex_Lock(PyMutex);
end;

procedure TPyMutex.Unlock;
begin
  if assigned(PyMutex_Unlock) then
    PyMutex_Unlock(PyMutex);
end;

function TPyMutex.IsLocked: boolean;
begin
  Result := assigned(PyMutex_IsLocked) and
            (PyMutex_IsLocked(PyMutex) <> 0);
end;

function TPyMutex.GetPyMutex: Pointer;
begin
  Result := @FPyMutex;
end;

end.
