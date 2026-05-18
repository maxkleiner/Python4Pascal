unit uP4P.PyWrapper;

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
  TPyWrapper = class
    public
      class function New(const obj1, obj2: IPyObject): IPyObject;
  end;

implementation

class function TPyWrapper.New(const obj1, obj2: IPyObject): IPyObject;
begin
  if assigned(PyWrapper_New) and
     TPyObject.IsInitialized(obj1) and
     TPyObject.IsInitialized(obj2) then
    Result := TPyObject.Wrap(PyWrapper_New(obj1.PyObject, obj2.PyObject))
   else
    Result := nil;
end;

end.
