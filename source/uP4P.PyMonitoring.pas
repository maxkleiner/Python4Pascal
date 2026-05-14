unit uP4P.PyMonitoring;

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
  TPyMonitoring = class
    public
      class function EnterScope(state_array: PPyMonitoringState; version: PUint64; const event_types: PByte; length: Py_ssize_t): boolean;
      class function ExitScope: boolean;
  end;

implementation

class function TPyMonitoring.EnterScope(state_array: PPyMonitoringState; version: PUint64; const event_types: PByte; length: Py_ssize_t): boolean;
begin
  Result := assigned(PyMonitoring_EnterScope) and
            (PyMonitoring_EnterScope(state_array, version, event_types, length) = 0);
end;

class function TPyMonitoring.ExitScope: boolean;
begin
  Result := assigned(PyMonitoring_ExitScope) and
            (PyMonitoring_ExitScope() = 0);
end;

end.
