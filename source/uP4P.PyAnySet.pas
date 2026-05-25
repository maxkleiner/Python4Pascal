unit uP4P.PyAnySet;

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
  TPyAnySet = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.PySet, uP4P.PyFrozenSet;

class function TPyAnySet.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPySet.Check(aPyObject) or
            TPyFrozenSet.Check(aPyObject);
end;

class function TPyAnySet.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPySet.CheckExact(aPyObject) or
            TPyFrozenSet.CheckExact(aPyObject);
end;

end.
