unit uP4P.PyStaticMethod;

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
  TPyStaticMethod = class
    public
      class function New(const callable: IPyObject): IPyObject;
  end;

implementation

class function TPyStaticMethod.New(const callable: IPyObject): IPyObject;
begin
  if assigned(PyStaticMethod_New) and
     TPyObject.IsInitialized(callable) then
    Result := TPyObject.Wrap(PyStaticMethod_New(callable.PyObject))
   else
    Result := nil;
end;

end.
