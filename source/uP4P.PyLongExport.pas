unit uP4P.PyLongExport;

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
  TPyLongExport = class(TInterfacedObject, IPyLongExport)
    protected
      FLongExport : PyLongExport;

      function GetLongExport: PPyLongExport;
      function GetValue: int64;
      function GetNegative: byte;
      function GetNdigits: Py_ssize_t;
      function GetDigits: Pointer;

    public
      destructor Destroy; override;
      property LongExport : PPyLongExport read GetLongExport;
      property Value      : int64         read GetValue;
      property Negative   : byte          read GetNegative;
      property Ndigits    : Py_ssize_t    read GetNdigits;
      property Digits     : Pointer       read GetDigits;
  end;


implementation

destructor TPyLongExport.Destroy;
begin
  if assigned(PyLong_FreeExport) then
    PyLong_FreeExport(LongExport);

  inherited Destroy;
end;

function TPyLongExport.GetLongExport: PPyLongExport;
begin
  Result := @FLongExport;
end;

function TPyLongExport.GetValue: int64;
begin
  Result := FLongExport.value;
end;

function TPyLongExport.GetNegative: byte;
begin
  Result := FLongExport.negative;
end;

function TPyLongExport.GetNdigits: Py_ssize_t;
begin
  Result := FLongExport.ndigits;
end;

function TPyLongExport.GetDigits: Pointer;
begin
  Result := FLongExport.digits;
end;

end.
