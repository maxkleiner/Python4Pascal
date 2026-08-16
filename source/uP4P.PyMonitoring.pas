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
  /// <summary>
  /// Helper class for all PyMonitoring_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/monitoring.html#managing-the-monitoring-state">See the article about Managing the Monitoring State.</see></para>
  /// </remarks>
  TPyMonitoring = class
    public
      /// <summary>
      /// <para>Enter a monitored scope. event_types is an array of the event
      /// IDs for events that may be fired from the scope. For example, the ID
      /// of a PY_START event is the value PY_MONITORING_EVENT_PY_START, which
      /// is numerically equal to the base-2 logarithm of
      /// sys.monitoring.events.PY_START. state_array is an array with a
      /// monitoring state entry for each event in event_types, it is allocated
      /// by the user but populated by TPyMonitoring.EnterScope() with
      /// information about the activation state of the event. The size of
      /// event_types (and hence also of state_array) is given in length.</para>
      /// <para>The version argument is a pointer to a value which should be
      /// allocated by the user together with state_array and initialized to 0,
      /// and then set only by TPyMonitoring.EnterScope() itself. It allows this
      /// function to determine whether event states have changed since the
      /// previous call, and to return quickly if they have not.</para>
      /// <para>The scopes referred to here are lexical scopes: a function,
      /// class or method. TPyMonitoring.EnterScope() should be called whenever
      /// the lexical scope is entered. Scopes can be reentered, reusing the
      /// same state_array and version, in situations like when emulating a
      /// recursive Python function. When a code-like's execution is paused,
      /// such as when emulating a generator, the scope needs to be exited and
      /// re-entered.</para>
      /// </summary>
      class function EnterScope(state_array: PPyMonitoringState; version: PUint64; const event_types: PByte; length: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Exit the last scope that was entered with
      /// TPyMonitoring.EnterScope().</para>
      /// </summary>
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
