unit uP4P.PyContext;

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
  /// Helper class for all PyContext_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/contextvars.html#context-variables-objects">See the article about the Context Variables Objects.</see></para>
  /// </remarks>
  TPyContext = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is of type PyContext_Type.
      /// aPyObject must not be nil. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Create a new empty context object. Returns nil if an error has
      /// occurred.</para>
      /// </summary>
      class function New(): IPyObject;
      /// <summary>
      /// <para>Create a shallow copy of the passed ctx context object.
      /// Returns nil if an error has occurred.</para>
      /// </summary>
      class function Copy(const ctx: IPyObject): IPyObject;
      /// <summary>
      /// <para>Create a shallow copy of the current thread context.
      /// Returns nil if an error has occurred.</para>
      /// </summary>
      class function CopyCurrent(): IPyObject;
      /// <summary>
      /// <para>Set ctx as the current context for the current thread.
      /// Returns True on success, and False on error.</para>
      /// </summary>
      class function Enter(const ctx: IPyObject): boolean;
      /// <summary>
      /// <para>Deactivate the ctx context and restore the previous context as
      /// the current context for the current thread.
      /// Returns True on success, and False on error.</para>
      /// </summary>
      class function Exit(const ctx: IPyObject): boolean;
      /// <summary>
      /// <para>Register callback as a context object watcher for the current
      /// interpreter. Return an ID which may be passed to
      /// TPyContext.ClearWatcher(). In case of error (e.g. no more watcher
      /// IDs available), return -1 and set an exception.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function AddWatcher(callback: PyContext_WatchCallback): integer;
      /// <summary>
      /// <para>Clear watcher identified by watcher_id previously returned from
      /// TPyContext.AddWatcher() for the current interpreter.
      /// Return True on success, or False and set an exception on error
      /// (e.g. if the given watcher_id was never registered.)</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function ClearWatcher(watcher_id: integer): boolean;
  end;

implementation

class function TPyContext.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyContext_Type);
end;

class function TPyContext.New(): IPyObject;
begin
  if assigned(PyContext_New) then
    Result := TPyObject.Wrap(PyContext_New())
   else
    Result := nil;
end;

class function TPyContext.Copy(const ctx: IPyObject): IPyObject;
begin
  if assigned(PyContext_Copy) and
     TPyObject.IsInitialized(ctx) then
    Result := TPyObject.Wrap(PyContext_Copy(ctx.PyObject))
   else
    Result := nil;
end;

class function TPyContext.CopyCurrent(): IPyObject;
begin
  if assigned(PyContext_CopyCurrent) then
    Result := TPyObject.Wrap(PyContext_CopyCurrent())
   else
    Result := nil;
end;

class function TPyContext.Enter(const ctx: IPyObject): boolean;
begin
  Result := assigned(PyContext_Enter) and
            TPyObject.IsInitialized(ctx) and
            (PyContext_Enter(ctx.PyObject) = 0);
end;

class function TPyContext.Exit(const ctx: IPyObject): boolean;
begin
  Result := assigned(PyContext_Exit) and
            TPyObject.IsInitialized(ctx) and
            (PyContext_Exit(ctx.PyObject) = 0);
end;

class function TPyContext.AddWatcher(callback: PyContext_WatchCallback): integer;
begin
  if assigned(PyContext_AddWatcher) then
    Result := PyContext_AddWatcher(callback)
   else
    Result := -1;
end;

class function TPyContext.ClearWatcher(watcher_id: integer): boolean;
begin
  Result := assigned(PyContext_ClearWatcher) and
            (PyContext_ClearWatcher(watcher_id) = 0);
end;

end.
