unit uP4P.PyGC;

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
  TPyGC = class
    public
      class function Collect: Py_ssize_t;
      class function Enable: boolean;
      class function Disable: boolean;
      class function IsEnabled: boolean;
  end;

implementation

class function TPyGC.Collect: Py_ssize_t;
begin
  if assigned(PyGC_Collect) then
    Result := PyGC_Collect()
   else
    Result := 0;
end;

class function TPyGC.Enable: boolean;
begin
  Result := assigned(PyGC_Enable) and (PyGC_Enable() <> 0);
end;

class function TPyGC.Disable: boolean;
begin
  Result := assigned(PyGC_Disable) and (PyGC_Disable() <> 0);
end;

class function TPyGC.IsEnabled: boolean;
begin
  Result := assigned(PyGC_IsEnabled) and (PyGC_IsEnabled() <> 0);
end;

end.
