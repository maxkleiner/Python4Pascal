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
  uP4P.LibFunctions, uP4P.Types;

type
  /// <summary>
  /// Helper class for all PyGC_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/gcsupport.html#controlling-the-garbage-collector-state">See the article about Controlling the Garbage Collector State.</see></para>
  /// </remarks>
  TPyGC = class
    public
      /// <summary>
      /// <para>Perform a full garbage collection, if the garbage collector is
      /// enabled. (Note that gc.collect() runs it unconditionally.)</para>
      /// <para>Returns the number of collected + unreachable objects which
      /// cannot be collected. If the garbage collector is disabled or already
      /// collecting, returns 0 immediately. Errors during garbage collection
      /// are passed to sys.unraisablehook. This function does not raise
      /// exceptions.</para>
      /// </summary>
      class function Collect: Py_ssize_t;
      /// <summary>
      /// <para>Enable the garbage collector: similar to gc.enable().
      /// Returns the previous state, False for disabled and True for
      /// enabled.</para>
      /// </summary>
      class function Enable: boolean;
      /// <summary>
      /// <para>Disable the garbage collector: similar to gc.disable().
      /// Returns the previous state, False for disabled and True for
      /// enabled.</para>
      /// </summary>
      class function Disable: boolean;
      /// <summary>
      /// <para>Query the state of the garbage collector: similar to
      /// gc.isenabled(). Returns the current state, False for disabled and
      /// True for enabled.</para>
      /// </summary>
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
