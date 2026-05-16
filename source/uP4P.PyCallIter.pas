unit uP4P.PyCallIter;

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
  TPyCallIter = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function New(const callable, sentinel: IPyObject): IPyObject;
  end;

implementation

class function TPyCallIter.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCallIter_Type);
end;

class function TPyCallIter.New(const callable, sentinel: IPyObject): IPyObject;
begin
  if assigned(PyCallIter_New) and
     TPyObject.IsInitialized(callable) and
     TPyObject.IsInitialized(sentinel) then
    Result := TPyObject.Wrap(PyCallIter_New(callable.PyObject, sentinel.PyObject))
   else
    Result := nil;
end;

end.
