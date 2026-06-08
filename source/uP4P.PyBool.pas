unit uP4P.PyBool;

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
  TPyBool = class
    public
      class function FromLong(aValue: C_Long): IPyObject;
      class function ReturnFalse: IPyObject;
      class function ReturnTrue: IPyObject;
      class function Check(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.Engine;

class function TPyBool.FromLong(aValue: C_Long): IPyObject;
begin
  if assigned(PyBool_FromLong) then
    Result := TPyObject.Wrap(PyBool_FromLong(aValue))
   else
    Result := nil;
end;

class function TPyBool.ReturnFalse: IPyObject;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    Result := TPyObject.Wrap(Py_False, False)
   else
    Result := TPyObject.Wrap(Py_NewRef(PPyObject(Py_False)), True);
end;

class function TPyBool.ReturnTrue: IPyObject;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    Result := TPyObject.Wrap(Py_True, False)
   else
    Result := TPyObject.Wrap(Py_NewRef(PPyObject(Py_True)), True);
end;

class function TPyBool.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and aPyObject.IsType(PyBool_Type);
end;

end.
