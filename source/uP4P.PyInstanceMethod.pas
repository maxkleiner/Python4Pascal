unit uP4P.PyInstanceMethod;

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
  TPyInstanceMethod = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function New(const func: IPyObject): IPyObject;
      class function Function_(const im: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyInstanceMethod.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyInstanceMethod_Type);
end;

class function TPyInstanceMethod.New(const func: IPyObject): IPyObject;
begin
  if assigned(PyInstanceMethod_New) and
     TPyObject.IsInitialized(func) then
    Result := TPyObject.Wrap(PyInstanceMethod_New(func.PyObject))
   else
    Result := nil;
end;

class function TPyInstanceMethod.Function_(const im: IPyObject): IPyObject;
begin
  if assigned(PyInstanceMethod_Function) and
     TPyObject.IsInitialized(im) then
    Result := TPyObject.Wrap(PyInstanceMethod_Function(im.PyObject), False)
   else
    Result := nil;
end;

end.
