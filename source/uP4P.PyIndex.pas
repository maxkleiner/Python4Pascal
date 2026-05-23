unit uP4P.PyIndex;

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
  TPyIndex = class
    public
      class function Check(const o: IPyObject): boolean;
  end;

implementation

class function TPyIndex.Check(const o: IPyObject): boolean;
begin
  Result := assigned(PyIndex_Check) and
            TPyObject.IsInitialized(o) and
            (PyIndex_Check(o.PyObject) <> 0);
end;

end.
