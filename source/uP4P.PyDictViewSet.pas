unit uP4P.PyDictViewSet;

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
  TPyDictViewSet = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.PyDictKeys, uP4P.PyDictItems;

class function TPyDictViewSet.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyDictKeys.Check(aPyObject) or
            TPyDictItems.Check(aPyObject);
end;

end.
