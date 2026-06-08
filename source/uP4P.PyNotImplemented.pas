unit uP4P.PyNotImplemented;

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
  TPyNotImplemented = class
    public
      class function New: IPyObject;
  end;

implementation

uses
  uP4P.Engine;

class function TPyNotImplemented.New: IPyObject;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    Result := TPyObject.Wrap(Py_NotImplemented, False)
   else
    Result := TPyObject.Wrap(Py_NotImplemented, True, True);
end;

end.
