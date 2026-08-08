unit uP4P.PyException;

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
  /// <para>Helper class for all the PyException_* methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/exceptions.html#exception-objects">See the Exception Objects article.</see></para>
  /// </remarks>
  TPyException = class
    public
      /// <summary>
      /// <para>Set the traceback associated with the exception to tb.
      /// Use nil to clear it.</para>
      /// </summary>
      class function  SetTraceback(const ex, tb: IPyObject): boolean;
      /// <summary>
      /// <para>Return the traceback associated with the exception as a new
      /// reference, as accessible from Python through the __traceback__
      /// attribute. If there is no traceback associated, this returns
      /// nil.</para>
      /// </summary>
      class function  GetTraceback(const ex: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the cause (either an exception instance, or None,
      /// set by raise ... from ...) associated with the exception as a new
      /// reference, as accessible from Python through the __cause__
      /// attribute.</para>
      /// </summary>
      class function  GetCause(const ex: IPyObject): IPyObject;
      /// <summary>
      /// <para>Set the cause associated with the exception to cause.
      /// Use nil to clear it. There is no type check to make sure that cause
      /// is either an exception instance or None. This "steals" a reference to
      /// cause.</para>
      /// <para>The __suppress_context__ attribute is implicitly set to True by
      /// this function.</para>
      /// </summary>
      class procedure SetCause(const ex, cause: IPyObject);
      /// <summary>
      /// <para>Return the context (another exception instance during whose
      /// handling ex was raised) associated with the exception as a new
      /// reference, as accessible from Python through the __context__
      /// attribute. If there is no context associated, this returns nil.</para>
      /// </summary>
      class function  GetContext(const ex: IPyObject): IPyObject;
      /// <summary>
      /// <para>Set the context associated with the exception to ctx. Use nil
      /// to clear it. There is no type check to make sure that ctx is an
      /// exception instance. This "steals" a reference to ctx.</para>
      /// </summary>
      class procedure SetContext(const ex, ctx: IPyObject);
      /// <summary>
      /// <para>Return args of exception ex.</para>
      /// </summary>
      class function  GetArgs(const ex: IPyObject): IPyObject;
      /// <summary>
      /// <para>Set args of exception ex to args.</para>
      /// </summary>
      class procedure SetArgs(const ex, args: IPyObject);
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyNone;

class function TPyException.SetTraceback(const ex, tb: IPyObject): boolean;
var
  TempNone : IPyObject;
begin
  Result := False;

  if assigned(PyException_SetTraceback) and
     TPyObject.IsInitialized(ex) then
    begin
      if TPyObject.IsInitialized(tb) then
        Result := (PyException_SetTraceback(ex.PyObject, tb.PyObject) <> 0)
       else
        begin
          TempNone := TPyNone.New;
          Result   := (PyException_SetTraceback(ex.PyObject, TempNone.PyObject) <> 0);
          TempNone := nil;
        end;
    end;
end;

class function TPyException.GetTraceback(const ex: IPyObject): IPyObject;
begin
  if assigned(PyException_GetTraceback) then
    Result := TPyObject.Wrap(PyException_GetTraceback(ex.PyObject))
   else
    Result := nil;
end;

class function TPyException.GetCause(const ex: IPyObject): IPyObject;
begin
  if assigned(PyException_GetCause) then
    Result := TPyObject.Wrap(PyException_GetCause(ex.PyObject))
   else
    Result := nil;
end;

class procedure TPyException.SetCause(const ex, cause: IPyObject);
begin
  if assigned(PyException_SetCause) and
     TPyObject.IsInitialized(ex) and
     TPyObject.IsInitialized(cause) then
    PyException_SetCause(ex.PyObject, cause.Unwrap);
end;

class function TPyException.GetContext(const ex: IPyObject): IPyObject;
begin
  if assigned(PyException_GetContext) then
    Result := TPyObject.Wrap(PyException_GetContext(ex.PyObject))
   else
    Result := nil;
end;

class procedure TPyException.SetContext(const ex, ctx: IPyObject);
begin
  if assigned(PyException_SetContext) and
     TPyObject.IsInitialized(ex) and
     TPyObject.IsInitialized(ctx) then
    PyException_SetContext(ex.PyObject, ctx.Unwrap);
end;

class function TPyException.GetArgs(const ex: IPyObject): IPyObject;
begin
  if assigned(PyException_GetArgs) then
    Result := TPyObject.Wrap(PyException_GetArgs(ex.PyObject))
   else
    Result := nil;
end;

class procedure TPyException.SetArgs(const ex, args: IPyObject);
begin
  if assigned(PyException_SetArgs) and
     TPyObject.IsInitialized(ex) and
     TPyObject.IsInitialized(args) then
    PyException_SetArgs(ex.PyObject, args.PyObject);
end;

end.
