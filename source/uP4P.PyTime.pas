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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  TPyTime = class
    public
      class function AsSecondsDouble(t: PyTime_t): double;
      class function Monotonic(out result_: PyTime_t): boolean;
      class function PerfCounter(out result_: PyTime_t): boolean;
      class function Time(out result_: PyTime_t): boolean;
      class function MonotonicRaw(out result_: PyTime_t): boolean;
      class function PerfCounterRaw(out result_: PyTime_t): boolean;
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
