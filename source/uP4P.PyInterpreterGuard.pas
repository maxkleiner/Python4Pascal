unit uP4P.PyInterpreterGuard;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces;

type
  /// <summary>
  /// <para>An interpreter guard class.</para>
  /// <para>By holding an interpreter guard, the caller can ensure that the
  /// interpreter will not finalize until the guard is closed (through
  /// TPyInterpreterGuard.Close()).</para>
  /// <para>When a guard is held, a thread attempting to finalize the
  /// interpreter will block until the guard is closed before starting
  /// finalization. After finalization has started, threads are forever unable
  /// to acquire guards for that interpreter. This means that if you forget to
  /// close an interpreter guard, the process will permanently hang during
  /// finalization!</para>
  /// <para>Holding a guard for an interpreter is similar to holding a strong reference to a Python object, except finalization does not happen automatically after all guards are released: it requires an explicit Py_EndInterpreter() call.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/interp-lifecycle.html#cautions-regarding-interpreter-finalization">See the Python article about Cautions regarding interpreter finalization.</see></para>
  /// <para>Added in version 3.15.</para>
  /// </remarks>
  TPyInterpreterGuard = class(TInterfacedObject, IPyInterpreterGuard)
    protected
      FPyInterpreterGuard : PPyInterpreterGuard;

      function  GetInitialized: boolean;
      function  GetGuard: PPyInterpreterGuard;
      procedure SetGuard(aValue: PPyInterpreterGuard);
      /// <summary>
      /// <para>Close an interpreter guard, allowing the interpreter to start
      /// finalization if no other guards remain. If an interpreter guard is
      /// never closed, the interpreter will infinitely wait when trying to
      /// enter finalization!</para>
      /// <para>After an interpreter guard is closed, it may not be used in
      /// TPyThreadState.Ensure(). Doing so will result in undefined
      /// behavior.</para>
      /// <para>This function cannot fail, and the caller doesn't need to hold
      /// an attached thread state.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      procedure Close;

    public
      constructor Create(aGuard: PPyInterpreterGuard);
      destructor  Destroy; override;
      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      class function IsInitialized(const aGuard: IPyInterpreterGuard): boolean; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
      /// <summary>
      /// <para>Helper function used to wrap a PyInterpreterGuard pointer with a
      /// TPyInterpreterGuard instance.</para>
      /// </summary>
      class function Wrap(aGuard: PPyInterpreterGuard): IPyInterpreterGuard; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
      /// <summary>
      /// <para>Create a finalization guard for the current interpreter.
      /// This will prevent finalization until the guard is closed.</para>
      /// <para>For example:</para>
      /// <code>
      /// // Temporarily prevent finalization.
      /// PyInterpreterGuard *guard = PyInterpreterGuard_FromCurrent();
      /// if (guard == NULL) {
      ///    // Finalization has already started or we're out of memory.
      ///    return NULL;
      /// }
      ///
      /// Py_BEGIN_ALLOW_THREADS;
      /// // Do some critical processing here. For example, we can safely acquire
      /// // locks that might be acquired by the finalization thread.
      /// Py_END_ALLOW_THREADS;
      ///
      /// // Now that we're done with our critical processing, the interpreter is
      /// // allowed to finalize again.
      /// PyInterpreterGuard_Close(guard);
      /// </code>
      /// <para>On success, this function returns a guard for the current
      /// interpreter; on failure, it returns nil with an exception set.</para>
      /// <para>This function will fail only if the current interpreter has
      /// already started finalizing, or if the process is out of memory.</para>
      /// <para>The guard pointer returned by this function must be eventually
      /// closed with TPyInterpreterGuard.Close(); failing to do so will result
      /// in the Python process infinitely hanging.</para>
      /// <para>The caller must hold an attached thread state.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function FromCurrent(): IPyInterpreterGuard;
      /// <summary>
      /// <para>Create a finalization guard for an interpreter through a
      /// view.</para>
      /// <para>On success, this function returns a guard to the interpreter
      /// represented by view. The view is still valid after calling this
      /// function. The guard must eventually be closed with
      /// TPyInterpreterGuard.Close().</para>
      /// <para>If the interpreter no longer exists, is already finalizing, or
      /// out of memory, then this function returns NULL without setting an
      /// exception.</para>
      /// <para>The caller does not need to hold an attached thread state.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function FromView(const aView: IPyInterpreterView): IPyInterpreterGuard;
      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      property Initialized  : boolean               read GetInitialized;
      /// <summary>
      /// <para>Pointer to PyInterpreterGuard</para>
      /// </summary>
      property Guard        : PPyInterpreterGuard   read GetGuard         write SetGuard;
  end;

implementation

{ TPyInterpreterGuard }

constructor TPyInterpreterGuard.Create(aGuard: PPyInterpreterGuard);
begin
  inherited Create;

  Guard := aGuard;
end;

destructor TPyInterpreterGuard.Destroy;
begin
  Close;

  inherited Destroy;
end;

procedure TPyInterpreterGuard.Close;
begin
  if Initialized and
     assigned(PyInterpreterGuard_Close) then
    begin
      PyInterpreterGuard_Close(FPyInterpreterGuard);
      FPyInterpreterGuard := nil;
    end;
end;

class function TPyInterpreterGuard.IsInitialized(const aGuard: IPyInterpreterGuard): boolean;
begin
  Result := (aGuard <> nil) and aGuard.Initialized;
end;

class function TPyInterpreterGuard.Wrap(aGuard: PPyInterpreterGuard): IPyInterpreterGuard;
begin
  if assigned(aGuard) then
    Result := TPyInterpreterGuard.Create(aGuard)
   else
    Result := nil;
end;

class function TPyInterpreterGuard.FromCurrent: IPyInterpreterGuard;
begin
  if assigned(PyInterpreterGuard_FromCurrent) then
    Result := TPyInterpreterGuard.Wrap(PyInterpreterGuard_FromCurrent())
   else
    Result := nil;
end;

class function TPyInterpreterGuard.FromView(const aView: IPyInterpreterView): IPyInterpreterGuard;
begin
  if assigned(PyInterpreterGuard_FromView) and
     assigned(aView) then
    Result := TPyInterpreterGuard.Wrap(PyInterpreterGuard_FromView(aView.View))
   else
    Result := nil;
end;

function TPyInterpreterGuard.GetGuard: PPyInterpreterGuard;
begin
  Result := FPyInterpreterGuard;
end;

function TPyInterpreterGuard.GetInitialized: boolean;
begin
  Result := assigned(FPyInterpreterGuard);
end;

procedure TPyInterpreterGuard.SetGuard(aValue: PPyInterpreterGuard);
begin
  FPyInterpreterGuard := aValue;
end;

end.
