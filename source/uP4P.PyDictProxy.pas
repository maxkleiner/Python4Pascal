unit uP4P.PyDictProxy;

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
  TPyDictProxy = class
    public
      class function New(const mapping: IPyObject): IPyObject;
  end;

implementation

class function TPyDictProxy.New(const mapping: IPyObject): IPyObject;
begin
  if assigned(PyDictProxy_New) and
     TPyObject.IsInitialized(mapping) then
    Result := TPyObject.Wrap(PyDictProxy_New(mapping.PyObject))
   else
    Result := nil;
end;

end.
