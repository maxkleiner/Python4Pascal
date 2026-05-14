unit uP4P.PyClassMethod;

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
  TPyClassMethod = class
    public
      class function New(const callable: IPyObject): IPyObject;
  end;

implementation

class function TPyClassMethod.New(const callable: IPyObject): IPyObject;
begin
  if assigned(PyClassMethod_New) and
     TPyObject.IsInitialized(callable) then
    Result := TPyObject.Wrap(PyClassMethod_New(callable.PyObject))
   else
    Result := nil;
end;

end.
