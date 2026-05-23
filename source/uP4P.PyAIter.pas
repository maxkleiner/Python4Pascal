unit uP4P.PyAIter;

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
  TPyAIter = class
    public
      class function Check(const o: IPyObject): boolean;
  end;

implementation

class function TPyAIter.Check(const o: IPyObject): boolean;
begin
  Result := assigned(PyAIter_Check) and
            TPyObject.IsInitialized(o) and
            (PyAIter_Check(o.PyObject) <> 0);
end;

end.
