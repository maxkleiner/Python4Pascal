unit uP4P.PyCMethod;

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
  TPyCMethod = class
    public
      class function Check(const aPyObject: IPyObject): boolean;
      class function CheckExact(const aPyObject: IPyObject): boolean;
      class function New(const method: PyMethodDef; const self_, module: IPyObject; const cls: PyTypeObject): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject;

class function TPyCMethod.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.TypeCheck(PyCMethod_Type);
end;

class function TPyCMethod.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyCMethod_Type);
end;

class function TPyCMethod.New(const method: PyMethodDef; const self_, module: IPyObject; const cls: PyTypeObject): IPyObject;
begin
  if assigned(PyCMethod_New) and
     TPyObject.IsInitialized(self_) and
     TPyObject.IsInitialized(module) then
    Result := TPyObject.Wrap(PyCMethod_New(@method, self_.PyObject, module.PyObject, @cls))
   else
    Result := nil;
end;

end.
