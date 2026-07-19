unit uP4P.PyCFunction;

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
  TPyCFunction = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function GetFunction(const func: IPyObject): PyCFunction;
      class function GetSelf(const func: IPyObject): IPyObject;
      class function GetFlags(const func: IPyObject): integer;
      class function New(const method: PyMethodDef; const self_: IPyObject): IPyObject;
      class function NewEx(const method: PyMethodDef; const self_, module: IPyObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyCFunction.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyCFunction_Type);
end;

class function TPyCFunction.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCFunction_Type);
end;

class function TPyCFunction.GetFunction(const func: IPyObject): PyCFunction;
begin
  if assigned(PyCFunction_GetFunction) and
     TPyObject.IsInitialized(func) then
    Result := PyCFunction_GetFunction(func.PyObject)
   else
    Result := nil;
end;

class function TPyCFunction.GetSelf(const func: IPyObject): IPyObject;
begin
  if assigned(PyCFunction_GetSelf) and
     TPyObject.IsInitialized(func) then
    Result := TPyObject.Wrap(PyCFunction_GetSelf(func.PyObject))
   else
    Result := nil;
end;

class function TPyCFunction.GetFlags(const func: IPyObject): integer;
begin
  if assigned(PyCFunction_GetFlags) and
     TPyObject.IsInitialized(func) then
    Result := PyCFunction_GetFlags(func.PyObject)
   else
    Result := -1;
end;

class function TPyCFunction.New(const method: PyMethodDef; const self_: IPyObject): IPyObject;
begin
  if assigned(PyCFunction_New) and
     TPyObject.IsInitialized(self_) then
    Result := TPyObject.Wrap(PyCFunction_New(@method, self_.PyObject))
   else
    Result := nil;
end;

class function TPyCFunction.NewEx(const method: PyMethodDef; const self_, module: IPyObject): IPyObject;
begin
  if assigned(PyCFunction_NewEx) and
     TPyObject.IsInitialized(self_) and
     TPyObject.IsInitialized(module) then
    Result := TPyObject.Wrap(PyCFunction_NewEx(@method, self_.PyObject, module.PyObject))
   else
    Result := nil;
end;

end.
