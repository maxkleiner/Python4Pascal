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
  /// <summary>
  /// Export of a Python int object. There are two cases: If digits is nil,
  /// only use the value member. If digits is not nil, use negative, ndigits
  /// and digits members.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/long.html#c.PyLongExport">See the article about PyLongExport.</see></para>
  /// </remarks>
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
      /// <summary>
      /// Pointer to the PyLongExport record.
      /// </summary>
      property LongExport : PPyLongExport read GetLongExport;
      /// <summary>
      /// The native integer value of the exported int object. Only valid if digits is nil.
      /// </summary>
      property Value      : int64         read GetValue;
      /// <summary>
      /// 1 if the number is negative, 0 otherwise. Only valid if digits is not nil.
      /// </summary>
      property Negative   : byte          read GetNegative;
      /// <summary>
      ///  Number of digits in digits array. Only valid if digits is not nil.
      /// </summary>
      property Ndigits    : Py_ssize_t    read GetNdigits;
      /// <summary>
      /// Read-only array of unsigned digits. Can be nil.
      /// </summary>
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
