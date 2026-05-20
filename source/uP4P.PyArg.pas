unit uP4P.PyArg;

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
  TPyArg = class
    public
      class function ValidateKeywordArguments(const kwargs: IPyObject): boolean;
  end;

implementation

class function TPyArg.ValidateKeywordArguments(const kwargs: IPyObject): boolean;
begin
  Result := assigned(PyArg_ValidateKeywordArguments) and
            TPyObject.IsInitialized(kwargs) and
            (PyArg_ValidateKeywordArguments(kwargs.PyObject) <> 0);
end;

end.
