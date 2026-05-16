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
  end;

implementation

uses
  uP4P.Loader;

class function TPyEllipsis.New: IPyObject;
begin
  if GlobalP4PLoader.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    Result := TPyObject.Wrap(Py_Ellipsis, False, False)
   else
    Result := TPyObject.Wrap(Py_Ellipsis, True, True);
end;

end.
