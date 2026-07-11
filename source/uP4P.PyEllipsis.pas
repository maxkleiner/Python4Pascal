unit uP4P.PyEllipsis;

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
  TPyEllipsis = class
    public
      class function New: IPyObject;
      class function Check(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.Engine;

class function TPyEllipsis.New: IPyObject;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    Result := TPyObject.Wrap(Py_Ellipsis, False)
   else
    Result := TPyObject.Wrap(Py_Ellipsis, True, True);
end;

class function TPyEllipsis.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyEllipsis_Type);
end;

end.
