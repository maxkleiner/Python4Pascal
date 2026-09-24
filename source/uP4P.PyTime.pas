unit uP4P.PyTime;

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
  uP4P.LibFunctions, uP4P.Types;

type
  /// <summary>
  /// Helper class for all PyTime_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/time.html#pytime-c-api">See the article about the PyTime C API.</see></para>
  /// </remarks>
  TPyTime = class
    public
      /// <summary>
      /// <para>Convert a timestamp to a number of seconds as a double.</para>
      /// <para>The function cannot fail, but note that double has limited
      /// accuracy for large values.</para>
      /// </summary>
      class function AsSecondsDouble(t: PyTime_t): double;
      /// <summary>
      /// <para>Read the monotonic clock. See time.monotonic() for important
      /// details on this clock.</para>
      /// </summary>
      class function Monotonic(out result_: PyTime_t): boolean;
      /// <summary>
      /// <para>Read the performance counter. See time.perf_counter() for
      /// important details on this clock.</para>
      /// </summary>
      class function PerfCounter(out result_: PyTime_t): boolean;
      /// <summary>
      /// <para>Read the "wall clock" time. See time.time() for details
      /// important on this clock.</para>
      /// </summary>
      class function Time(out result_: PyTime_t): boolean;
      /// <summary>
      /// <para>Similar to TPyTime.Monotonic(), but don't set an exception on
      /// error and don't require an attached thread state.</para>
      /// </summary>
      class function MonotonicRaw(out result_: PyTime_t): boolean;
      /// <summary>
      /// <para>Similar to TPyTime.PerfCounter(), but don't set an exception on
      /// error and don't require an attached thread state.</para>
      /// </summary>
      class function PerfCounterRaw(out result_: PyTime_t): boolean;
      /// <summary>
      /// <para>Similar to TPyTime.Time(), but don't set an exception on error
      /// and don't require an attached thread state.</para>
      /// </summary>
      class function TimeRaw(out result_: PyTime_t): boolean;
  end;

implementation

class function TPyTime.AsSecondsDouble(t: PyTime_t): double;
begin
  if assigned(PyTime_AsSecondsDouble) then
    Result := PyTime_AsSecondsDouble(t)
   else
    Result := 0;
end;

class function TPyTime.Monotonic(out result_: PyTime_t): boolean;
begin
  Result := assigned(PyTime_Monotonic) and
            (PyTime_Monotonic(@result_) = 0);
end;

class function TPyTime.PerfCounter(out result_: PyTime_t): boolean;
begin
  Result := assigned(PyTime_PerfCounter) and
            (PyTime_PerfCounter(@result_) = 0);
end;

class function TPyTime.Time(out result_: PyTime_t): boolean;
begin
  Result := assigned(PyTime_Time) and
            (PyTime_Time(@result_) = 0);
end;

class function TPyTime.MonotonicRaw(out result_: PyTime_t): boolean;
begin
  Result := assigned(PyTime_MonotonicRaw) and
            (PyTime_MonotonicRaw(@result_) = 0);
end;

class function TPyTime.PerfCounterRaw(out result_: PyTime_t): boolean;
begin
  Result := assigned(PyTime_PerfCounterRaw) and
            (PyTime_PerfCounterRaw(@result_) = 0);
end;

class function TPyTime.TimeRaw(out result_: PyTime_t): boolean;
begin
  Result := assigned(PyTime_TimeRaw) and
            (PyTime_TimeRaw(@result_) = 0);
end;

end.
