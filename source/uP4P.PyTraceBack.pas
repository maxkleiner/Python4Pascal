unit uP4P.PyTraceBack;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyTraceBack_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/exceptions.html#tracebacks">See the article about Tracebacks.</see></para>
  /// </remarks>
  TPyTraceBack = class
    public
      /// <summary>
      /// <para>Replace the __traceback__ attribute on the current exception
      /// with a new traceback prepending f to the existing chain.</para>
      /// <para>Calling this function without an exception set is undefined
      /// behavior.</para>
      /// <para>This function returns True on success, and returns False with
      /// an exception set on failure.</para>
      /// </summary>
      class function Here(const frame: IPyObject): boolean;
      /// <summary>
      /// <para>Write the traceback tb into the file f.</para>
      /// <para>This function returns True on success, and returns False with
      /// an exception set on failure.</para>
      /// </summary>
      class function Print(const tb, f: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if op is a traceback object, false otherwise.
      /// This function does not account for subtypes.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
  end;

implementation

class function TPyTraceBack.Here(const frame: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(frame) and
            assigned(PyTraceBack_Here) and
            (PyTraceBack_Here(PPyFrameObject(frame.PyObject)) = 0);
end;

class function TPyTraceBack.Print(const tb, f: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(tb) and
            TPyObject.IsInitialized(f) and
            assigned(PyTraceBack_Print) and
            (PyTraceBack_Print(tb.PyObject, f.PyObject) = 0);
end;

class function TPyTraceBack.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyTraceBack_Type);
end;

end.
