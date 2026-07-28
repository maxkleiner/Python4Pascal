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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

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
      /// <para>Reset all information in a thread state object. tstate must be
      /// attached</para>
      /// <para>Changed in version 3.9: This function now calls the
      /// PyThreadState.on_delete callback. Previously, that happened in
      /// TPyThreadState.Delete().</para>
      /// <para>Changed in version 3.13: The PyThreadState.on_delete callback
      /// was removed.</para>
      /// </summary>
      procedure Clear;
      /// <summary>
      /// <para>Destroy a thread state object. tstate should not be attached to
      /// any thread. tstate must have been reset with a previous call to
      /// TPyThreadState.Clear().</para>
      /// </summary>
      procedure Delete;
      /// <summary>
      /// <para>Asynchronously raise an exception in a thread. The id argument
      /// is the thread id of the target thread; exc is the exception object to
      /// be raised. This function does not steal any references to exc.
      /// To prevent naive misuse, you must write your own C extension to call
      /// this. Must be called with an attached thread state. Returns the number
      /// of thread states modified; this is normally one, but will be zero if
      /// the thread id isn’t found. If exc is nil, the pending exception
      /// (if any) for the thread is cleared. This raises no exceptions.</para>
      /// <para>Changed in version 3.7: The type of the id parameter changed
      /// from long to unsigned long.</para>
      /// </summary>
      function  SetAsyncExc(id: C_ULong; const exc: IPyObject): integer;
      /// <summary>
      /// <para>Suspend tracing and profiling in the Python thread state
      /// tstate.</para>
      /// <para>Resume them using the TPyThreadState.LeaveTracing()
      /// function.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      procedure EnterTracing;
      /// <summary>
      /// <para>Resume tracing and profiling in the Python thread state tstate
      /// suspended by the TPyThreadState.EnterTracing() function.</para>
      /// <para>See also TPyEval.SetTrace() and TPyEval.SetProfile()
      /// functions.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      procedure LeaveTracing;
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
      function  Swap: IPyThreadState; overload;
      /// <summary>
      /// <para>Return the next thread state object after tstate from the list
      /// of all such objects belonging to the same PyInterpreterState
      /// object.</para>
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
      /// then this issues a fatal error (so that the caller needn’t check for
      /// nil).</para>
      /// <para>See also TPyThreadState.GetUnchecked().</para>
      /// </summary>
      class function  Get: IPyThreadState;
      /// <summary>
      /// <para>Similar to TPyThreadState.Get(), but don’t kill the process with
      /// a fatal error if it is nil. The caller is responsible to check if the
      /// result is nil.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function  GetUnchecked: IPyThreadState;
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
      /// <para></para>
      /// </summary>
      class procedure DeleteCurrent;

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
  uP4P.PyInterpreterState;

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

function TPyThreadState.Swap: IPyThreadState;
begin
  if Initialized and assigned(PyThreadState_Swap) then
    Result := TPyThreadState.Wrap(PyThreadState_Swap(FPyThreadState))
   else
    Result := nil;
end;

class function TPyThreadState.Swap(const tstate: IPyThreadState): IPyThreadState;
begin
  if assigned(PyThreadState_Swap) then
    begin
      if assigned(tstate) and tstate.Initialized then
        Result := TPyThreadState.Wrap(PyThreadState_Swap(tstate.ThreadState))
       else
        Result := TPyThreadState.Wrap(PyThreadState_Swap(nil));
    end
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

end.
