unit uP4P.PyThreadState;

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
  /// This class represents the state of a single thread.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/threads.html#c.PyThreadState">See the article about PyThreadState.</see></para>
  /// </remarks>
  TPyThreadState = class(TInterfacedObject, IPyThreadState)
    protected
      FPyThreadState : PPyThreadState;

      function  GetInitialized: boolean;
      function  GetThreadState: PPyThreadState;
      function  GetID: int64;
      function  GetDict: IPyObject;
      function  GetInterpreter: IPyInterpreterState;
      function  GetFrame: IPyObject;

      procedure SetThreadState(aThreadState: PPyThreadState);

      /// <summary>
      /// <para>Reset all information in a thread state object.
      /// IPyThreadState.ThreadState must be attached</para>
      /// <para>Changed in version 3.9: This function now calls the
      /// PyThreadState.on_delete callback. Previously, that happened in
      /// TPyThreadState.Delete().</para>
      /// <para>Changed in version 3.13: The PyThreadState.on_delete callback
      /// was removed.</para>
      /// </summary>
      procedure Clear;
      /// <summary>
      /// <para>Destroy a thread state object. IPyThreadState.ThreadState should
      /// not be attached to any thread. IPyThreadState.ThreadState must have
      /// been reset with a previous call to TPyThreadState.Clear().</para>
      /// </summary>
      procedure Delete;
      /// <summary>
      /// <para>Schedule an exception to be raised asynchronously in a thread.
      /// If the thread has a previously scheduled exception, it is
      /// overwritten.</para>
      /// <para>The id argument is the thread id of the target thread, as
      /// returned by TPyThread.get_thread_ident(). exc is the class of the
      /// exception to be raised, or NULL to clear the pending exception
      /// (if any).</para>
      /// <para>Return the number of affected thread states. This is normally 1
      /// if id is found, even when no change was made (the given exc was
      /// already pending, or exc is nil but no exception is pending). If the
      /// thread id isn't found, return 0. This raises no exceptions.</para>
      /// <para>To prevent naive misuse, you must write your own C extension
      /// to call this. This function must be called with an attached thread
      /// state. This function does not steal any references to exc.
      /// This function does not necessarily interrupt system calls such as
      /// sleep().</para>
      /// <para>Changed in version 3.7: The type of the id parameter changed
      /// from long to unsigned long.</para>
      /// </summary>
      function  SetAsyncExc(id: C_ULong; const exc: IPyObject): integer;
      /// <summary>
      /// <para>Suspend tracing and profiling in the Python thread state
      /// IPyThreadState.ThreadState.</para>
      /// <para>Resume them using the TPyThreadState.LeaveTracing()
      /// function.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      procedure EnterTracing;
      /// <summary>
      /// <para>Resume tracing and profiling in the Python thread state
      /// IPyThreadState.ThreadState suspended by the
      /// TPyThreadState.EnterTracing() function.</para>
      /// <para>See also TPyEval.SetTrace() and TPyEval.SetProfile()
      /// functions.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      procedure LeaveTracing;
      /// <summary>
      /// <para>Set the attached thread state to IPyThreadState.ThreadState,
      /// and return the thread state that was attached prior to calling.</para>
      /// <para>This function is safe to call without an attached thread state;
      /// it will simply return nil indicating that there was no prior thread
      /// state.</para>
      /// <para>See also TPyEval.ReleaseThread()</para>
      /// <para>Note Similar to TPyGILState.Ensure(), this function will hang
      /// the thread if the runtime is finalizing.</para>
      /// </summary>
      function  Swap: IPyThreadState; overload;
      /// <summary>
      /// <para>Return the next thread state object after
      /// IPyThreadState.ThreadState from the list of all such objects belonging
      /// to the same PyInterpreterState object.</para>
      /// </summary>
      function  Next: IPyThreadState;

    public
      constructor Create(aPyThreadState: PPyThreadState);
      /// <summary>
      /// <para>Return the PyThreadState pointer that was handled by this
      /// TPyThreadState instance.</para>
      /// <para>This function must be used when passing a PyThreadState pointer
      /// to a function that steals the PyThreadState reference.</para>
      /// </summary>
      function    UnWrap: Pointer;
      /// <summary>
      /// <para>Wrap an existing PyThreadState pointer in a TPyThreadState
      /// instance.</para>
      /// </summary>
      class function  Wrap(aPyThreadState: PPyThreadState): IPyThreadState; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
      /// <summary>
      /// <para>Create a new thread state object belonging to the given
      /// interpreter object. An attached thread state is not needed.</para>
      /// </summary>
      class function  New(const state: IPyInterpreterState): IPyThreadState;
      /// <summary>
      /// <para>Return the attached thread state. If the thread has no attached
      /// thread state, (such as when inside of Py_BEGIN_ALLOW_THREADS block),
      /// then this issues a fatal error (so that the caller needn't check for
      /// nil).</para>
      /// <para>See also TPyThreadState.GetUnchecked().</para>
      /// </summary>
      class function  Get: IPyThreadState;
      /// <summary>
      /// <para>Similar to TPyThreadState.Get(), but don't kill the process with
      /// a fatal error if it is nil. The caller is responsible to check if the
      /// result is nil.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function  GetUnchecked: IPyThreadState;
      /// <summary>
      /// <para>Return true if the curent thread has an attached thread
      /// state.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function  AttachedThreadState: boolean;
      /// <summary>
      /// <para>Set the attached thread state to tstate, and return the thread
      /// state that was attached prior to calling.</para>
      /// <para>This function is safe to call without an attached thread state;
      /// it will simply return nil indicating that there was no prior thread
      /// state.</para>
      /// <para>See also TPyEval.ReleaseThread()</para>
      /// <para>Note Similar to TPyGILState.Ensure(), this function will hang
      /// the thread if the runtime is finalizing.</para>
      /// </summary>
      class function  Swap(const tstate: IPyThreadState): IPyThreadState; overload;
      /// <summary>
      /// Helper function to check if an IPyThreadState instance is fully
      /// initialized.
      /// </summary>
      class function  IsInitialized(const tstate: IPyThreadState): boolean;
      /// <summary>
      /// <para>Detach the attached thread state (which must have been reset
      /// with a previous call to TPyThreadState.Clear()) and then destroy
      /// it.</para>
      /// <para>No thread state will be attached upon returning.</para>
      /// </summary>
      class procedure DeleteCurrent;
      /// <summary>
      /// <para>Ensure that the thread has an attached thread state for the
      /// interpreter protected by guard, and thus can safely invoke that
      /// interpreter.</para>
      /// <para>It is OK to call this function if the thread already has an
      /// attached thread state, as long as there is a subsequent call to
      /// TPyThreadState.Release() that matches this one (meaning that "nested"
      /// calls to this function are permitted).</para>
      /// <para>The function's effect (if any) will be reversed by the matching
      /// call to TPyThreadState.Release().</para>
      /// <para>On error, this function returns NULL without an exception set.
      /// Do not call TPyThreadState.Release() in this case.</para>
      /// <para>On success, this function returns a pointer value that must be
      /// passed to the matching call to TPyThreadState.Release().</para>
      /// <para>The conditions in which this function creates a new thread
      /// state are considered unstable and implementation-dependent. If you
      /// need to control the exact lifetime of a thread state, consider using
      /// TPyThreadState.New(). However, do not avoid this function solely on
      /// the basis that the lifetime of the thread state may be inconsistent
      /// across versions; changes to this function will be done with caution
      /// and in a backwards-compatible manner. In particular, the saving of
      /// thread-local variables and similar state will be retained across
      /// Python versions.</para>
      /// <para>CPython implementation detail: The exact behavior of whether
      /// this function creates a new thread state is described below, but be
      /// aware that this may change in the future.</para>
      /// <para>First, this function checks if an attached thread state is
      /// present. If there is, this function then checks if the interpreter of
      /// that thread state matches the interpreter guarded by guard. If that
      /// is the case, this function simply marks the thread state as being
      /// used by a TPyThreadState.Ensure call and returns.</para>
      /// <para>If there is no attached thread state, then this function checks
      /// if any thread state has been used by the current OS thread. (This is
      /// returned by TPyGILState.GetThisThreadState().) If there was, then
      /// this function checks if that thread state's interpreter matches guard.
      /// If it does, it is re-attached and marked as used.</para>
      /// <para>Otherwise, if both of the above cases fail, a new thread state
      /// is created for guard. It is then attached and marked as owned by
      /// TPyThreadState.Ensure.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function Ensure(const aGuard: IPyInterpreterGuard): PPyThreadStateToken;
      /// <summary>
      /// <para>Get an attached thread state for the interpreter referenced by
      /// view.</para>
      /// <para>The behavior and return value are the same as for
      /// TPyThreadState.Ensure(); additionally, if the function succeeds, the
      /// interpreter referenced by view will be implicitly guarded. The guard
      /// will be released upon the corresponding TPyThreadState.Release()
      /// call.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class function EnsureFromView(const aView: IPyInterpreterView): PPyThreadStateToken;
      /// <summary>
      /// <para>Undo a TPyThreadState.Ensure() or
      /// TPyThreadState.EnsureFromView() call.</para>
      /// <para>This must be called exactly once for each successful Ensure
      /// call, with token set to that call's return value.</para>
      /// <para>The state that was attached before the corresponding Ensure
      /// call (if any) will be attached when TPyThreadState.Release()
      /// returns.</para>
      /// <para>The exact behavior of whether this function deletes a thread
      /// state is considered unstable and implementation-dependent.</para>
      /// <para>CPython implementation detail: Currently, this function will
      /// decrement an internal counter on the attached thread state. If this
      /// counter ever reaches below zero, this function emits a fatal error
      /// (via TPy.FatalError()).</para>
      /// <para>If the attached thread state is owned by TPyThreadState.Ensure,
      /// then the attached thread state will be deallocated and deleted upon
      /// the internal counter reaching zero. Otherwise, nothing happens when
      /// the counter reaches zero.</para>
      /// <para>Added in version 3.15.</para>
      /// </summary>
      class procedure Release(tstate: PPyThreadStateToken);

      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      property Initialized  : boolean               read GetInitialized;
      /// <summary>
      /// <para>Pointer to PyThreadState</para>
      /// </summary>
      property ThreadState  : PPyThreadState        read GetThreadState         write SetThreadState;
      /// <summary>
      /// <para>Get the unique thread state identifier of the Python thread
      /// state tstate.</para>
      /// <para>tstate must not be nil, and must be attached.</para>
      /// <para>Added in version 3.9.</para>
      /// </summary>
      property ID           : int64                 read GetID;
      /// <summary>
      /// <para>Return a dictionary in which extensions can store
      /// thread-specific state information. Each extension should use a unique
      /// key to use to store state in the dictionary. It is okay to call this
      /// function when no thread state is attached. If this function returns
      /// nil, no exception has been raised and the caller should assume no
      /// thread state is attached.</para>
      /// </summary>
      property Dict         : IPyObject             read GetDict;
      /// <summary>
      /// <para>Get the interpreter of the Python thread state tstate.</para>
      /// <para>tstate must not be nil, and must be attached.</para>
      /// </summary>
      property Interpreter  : IPyInterpreterState   read GetInterpreter;
      /// <para>Get the current frame of the Python thread state tstate.</para>
      /// <para>Return a strong reference. Return nil if no frame is currently
      /// executing.</para>
      /// <para>See also TPyEval.GetFrame().</para>
      /// <para>tstate must not be nil, and must be attached.</para>
      /// <para>Added in version 3.9.</para>
      /// </summary>
      property Frame        : IPyObject             read GetFrame;
  end;

implementation

uses
  uP4P.PyInterpreterState, uP4P.PyInterpreterGuard, uP4P.PyInterpreterView;

constructor TPyThreadState.Create(aPyThreadState: PPyThreadState);
begin
  inherited Create;

  FPyThreadState := aPyThreadState;
end;

function TPyThreadState.UnWrap: Pointer;
begin
  Result         := FPyThreadState;
  FPyThreadState := nil;
end;

class function TPyThreadState.Wrap(aPyThreadState: PPyThreadState): IPyThreadState;
begin
  if assigned(aPyThreadState) then
    Result := TPyThreadState.Create(aPyThreadState)
   else
    Result := nil;
end;

class function TPyThreadState.New(const state: IPyInterpreterState): IPyThreadState;
begin
  if assigned(PyThreadState_New) and
     TPyInterpreterState.IsInitialized(state) then
    Result := TPyThreadState.Wrap(PyThreadState_New(state.State))
   else
    Result := nil;
end;

class function TPyThreadState.Get: IPyThreadState;
begin
  if assigned(PyThreadState_Get) then
    Result := TPyThreadState.Wrap(PyThreadState_Get())
   else
    Result := nil;
end;

class function TPyThreadState.GetUnchecked: IPyThreadState;
begin
  if assigned(PyThreadState_GetUnchecked) then
    Result := TPyThreadState.Wrap(PyThreadState_GetUnchecked())
   else
    Result := nil;
end;

class function TPyThreadState.AttachedThreadState: boolean;
begin
  Result := assigned(PyThreadState_GetUnchecked) and
            (PyThreadState_GetUnchecked() <> nil);
end;

function TPyThreadState.Swap: IPyThreadState;
begin
  if Initialized and assigned(PyThreadState_Swap) then
    Result := TPyThreadState.Wrap(PyThreadState_Swap(FPyThreadState))
   else
    Result := nil;
end;

class function TPyThreadState.Swap(const tstate: IPyThreadState): IPyThreadState;
begin
  if assigned(PyThreadState_Swap) and
     TPyThreadState.IsInitialized(tstate) then
    Result := TPyThreadState.Wrap(PyThreadState_Swap(tstate.ThreadState))
   else
    Result := nil;
end;

class function TPyThreadState.IsInitialized(const tstate: IPyThreadState): boolean;
begin
  Result := assigned(tstate) and tstate.Initialized;
end;

function TPyThreadState.GetInitialized: boolean;
begin
  Result := (ThreadState <> nil);
end;

function TPyThreadState.GetThreadState: PPyThreadState;
begin
  Result := FPyThreadState;
end;

function TPyThreadState.GetID: int64;
begin
  if Initialized and assigned(PyThreadState_GetID) then
    Result := PyThreadState_GetID(ThreadState)
   else
    Result := -1;
end;

function TPyThreadState.GetDict: IPyObject;
begin
  if Initialized and assigned(PyThreadState_GetDict) then
    Result := TPyObject.Wrap(PyThreadState_GetDict(), False)
   else
    Result := nil;
end;

function TPyThreadState.GetInterpreter: IPyInterpreterState;
begin
  if Initialized and assigned(PyThreadState_GetInterpreter) then
    Result := TPyInterpreterState.Wrap(PyThreadState_GetInterpreter(ThreadState))
   else
    Result := nil;
end;

function TPyThreadState.GetFrame: IPyObject;
begin
  if Initialized and assigned(PyThreadState_GetFrame) then
    Result := TPyObject.Wrap(PyThreadState_GetFrame(ThreadState))
   else
    Result := nil;
end;

procedure TPyThreadState.SetThreadState(aThreadState: PPyThreadState);
begin
  FPyThreadState := aThreadState;
end;

procedure TPyThreadState.Clear;
begin
  if Initialized and assigned(PyThreadState_Clear) then
    PyThreadState_Clear(ThreadState);
end;

procedure TPyThreadState.Delete;
begin
  if Initialized and assigned(PyThreadState_Delete) then
    begin
      PyThreadState_Delete(ThreadState);
      ThreadState := nil;
    end;
end;

function TPyThreadState.SetAsyncExc(id: C_ULong; const exc: IPyObject): integer;
begin
  if Initialized and
     assigned(PyThreadState_SetAsyncExc) then
    begin
      if TPyObject.IsInitialized(exc) then
        Result := PyThreadState_SetAsyncExc(id, exc.PyObject)
       else
        Result := PyThreadState_SetAsyncExc(id, nil);
    end
   else
    Result := 0;
end;

procedure TPyThreadState.EnterTracing;
begin
  if Initialized and assigned(PyThreadState_EnterTracing) then
    PyThreadState_EnterTracing(ThreadState);
end;

procedure TPyThreadState.LeaveTracing;
begin
  if Initialized and assigned(PyThreadState_LeaveTracing) then
    PyThreadState_LeaveTracing(ThreadState);
end;

function TPyThreadState.Next: IPyThreadState;
begin
  if Initialized and assigned(PyThreadState_Next) then
    Result := TPyThreadState.Wrap(PyThreadState_Next(ThreadState))
   else
    Result := nil;
end;

class procedure TPyThreadState.DeleteCurrent;
begin
  if assigned(PyThreadState_DeleteCurrent) then
    PyThreadState_DeleteCurrent();
end;

class function TPyThreadState.Ensure(const aGuard: IPyInterpreterGuard): PPyThreadStateToken;
begin
  if assigned(PyThreadState_Ensure) and
     TPyInterpreterGuard.IsInitialized(aGuard) then
    Result := PyThreadState_Ensure(aGuard.Guard)
   else
    Result := nil;
end;

class function TPyThreadState.EnsureFromView(const aView: IPyInterpreterView): PPyThreadStateToken;
begin
  if assigned(PyThreadState_EnsureFromView) and
     TPyInterpreterView.IsInitialized(aView) then
    Result := PyThreadState_EnsureFromView(aView.View)
   else
    Result := nil;
end;

class procedure TPyThreadState.Release(tstate: PPyThreadStateToken);
begin
  if assigned(PyThreadState_Release) and
     assigned(tstate) then
    PyThreadState_Release(tstate);
end;

end.
