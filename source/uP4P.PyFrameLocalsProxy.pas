unit uP4P.PyFrameLocalsProxy;

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
  TPyFrameLocalsProxy = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
  end;

implementation

class function TPyFrameLocalsProxy.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyFrameLocalsProxy_Type);
end;

end.
