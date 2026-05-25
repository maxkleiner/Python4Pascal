unit uP4P.PyMethod;

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
  TPyMethod = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function New(const func, selfobj: IPyObject): IPyObject;
      class function Function_(const meth: IPyObject): IPyObject;
      class function Self_(const meth: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyMethod.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyMethod_Type);
end;

class function TPyMethod.New(const func, selfobj: IPyObject): IPyObject;
begin
  if assigned(PyMethod_New) and
     TPyObject.IsInitialized(func) and
     TPyObject.IsInitialized(selfobj) then
    Result := TPyObject.Wrap(PyMethod_New(func.PyObject, selfobj.PyObject))
   else
    Result := nil;
end;

class function TPyMethod.Function_(const meth: IPyObject): IPyObject;
begin
  if assigned(PyMethod_Function) and
     TPyObject.IsInitialized(meth) then
    Result := TPyObject.Wrap(PyMethod_Function(meth.PyObject), False)
   else
    Result := nil;
end;

class function TPyMethod.Self_(const meth: IPyObject): IPyObject;
begin
  if assigned(PyMethod_Self) and
     TPyObject.IsInitialized(meth) then
    Result := TPyObject.Wrap(PyMethod_Self(meth.PyObject), False)
   else
    Result := nil;
end;

end.
