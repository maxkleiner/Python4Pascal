unit uP4P.PyRefTracer;

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
  /// Helper class for all PyRefTracer_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/profiling.html#reference-tracing">See the article about Reference tracing.</see></para>
  /// </remarks>
  TPyRefTracer = class
    public
      /// <summary>
      /// <para>Register a reference tracer function. The function will be
      /// called when a new Python object has been created or when an object is
      /// going to be destroyed. If data is provided it must be an opaque
      /// pointer that will be provided when the tracer function is called.
      /// Return 0 on success. Set an exception and return -1 on error.</para>
      /// <para>Note that tracer functions must not create Python objects inside
      /// or otherwise the call will be re-entrant. The tracer also must not
      /// clear any existing exception or set an exception. A thread state will
      /// be active every time the tracer function is called.</para>
      /// <para>There must be an attached thread state when calling this
      /// function.</para>
      /// <para>If another tracer function was already registered, the old
      /// function will be called with event set to PyRefTracer_TRACKER_REMOVED
      /// just before the new function is registered.</para>
      /// </summary>
      class function SetTracer(tracer: PyRefTracer; data: Pointer): integer;
      /// <summary>
      /// <para>Get the registered reference tracer function and the value of
      /// the opaque data pointer that was registered when
      /// TPyRefTracer.SetTracer() was called. If no tracer was registered this
      /// function will return nil and will set the data pointer to nil.</para>
      /// <para>There must be an attached thread state when calling this
      /// function.</para>
      /// </summary>
      class function GetTracer(var data: Pointer): PyRefTracer;
  end;

implementation

class function TPyRefTracer.SetTracer(tracer: PyRefTracer; data: Pointer): integer;
begin
  if assigned(PyRefTracer_SetTracer) then
    Result := PyRefTracer_SetTracer(tracer, data)
   else
    Result := 0;
end;

class function TPyRefTracer.GetTracer(var data: Pointer): PyRefTracer;
begin
  if assigned(PyRefTracer_GetTracer) then
    Result := PyRefTracer_GetTracer(data)
   else
    Result := nil;
end;

end.
