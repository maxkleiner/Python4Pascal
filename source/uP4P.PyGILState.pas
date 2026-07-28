unit uP4P.PyGILState;

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
  /// The class represents the GIL state.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/threads.html#c.PyGILState_STATE">See the article about PyGILState_STATE.</see></para>
  /// </remarks>
  TPyGILState = class(TInterfacedObject, IPyGILState)
    protected
      FInitialized : boolean;
      FState       : PyGILState_STATE;

      function  GetInitialized: boolean;
      function  GetState: PyGILState_STATE;

      procedure SetInitialized(aValue: boolean);
      procedure SetState(aState: PyGILState_STATE);

      /// <summary>
      /// <para>Release any resources previously acquired. After this call,
      /// Python’s state will be the same as it was prior to the corresponding
      /// TPyGILState.Ensure() call (but generally this state will be unknown
      /// to the caller, hence the use of the GILState API).</para>
      /// <para>Every call to TPyGILState.Ensure() must be matched by a call to
      /// TPyGILState.Release() on the same thread.</para>
      /// </summary>
      procedure Release;

    public
      constructor Create(aState: PyGILState_STATE);
      destructor  Destroy; override;

      /// <summary>
      /// <para>Ensure that the current thread is ready to call the Python C API
      /// regardless of the current state of Python, or of the attached thread
      /// state. This may be called as many times as desired by a thread as long
      /// as each call is matched with a call to TPyGILState.Release().
      /// In general, other thread-related APIs may be used between
      /// TPyGILState.Ensure() and TPyGILState.Release() calls as long as the
      /// thread state is restored to its previous state before the Release().
      /// For example, normal usage of the Py_BEGIN_ALLOW_THREADS and
      /// Py_END_ALLOW_THREADS macros is acceptable.</para>
      /// <para>The return value is an opaque “handle” to the attached thread
      /// state when TPyGILState.Ensure() was called, and must be passed to
      /// TPyGILState.Release() to ensure Python is left in the same state.
      /// Even though recursive calls are allowed, these handles cannot be
      /// shared - each unique call to TPyGILState.Ensure() must save the
      /// handle for its call to TPyGILState.Release().</para>
      /// <para>When the function returns, there will be an attached thread
      /// state and the thread will be able to call arbitrary Python code.
      /// Failure is a fatal error.</para>
      /// <para>Warning Calling this function when the runtime is finalizing is
      /// unsafe. Doing so will either hang the thread until the program ends,
      /// or fully crash the interpreter in rare cases. Refer to Cautions
      /// regarding runtime finalization for more details.</para>
      /// <para>Changed in version 3.14: Hangs the current thread, rather than
      /// terminating it, if called while the interpreter is finalizing.</para>
      /// </summary>
      class function Ensure: IPyGILState;
      /// <summary>
      /// <para>Get the attached thread state for this thread. May return nil
      /// if no GILState API has been used on the current thread. Note that the
      /// main thread always has such a thread-state, even if no
      /// auto-thread-state call has been made on the main thread. This is
      /// mainly a helper/diagnostic function.</para>
      /// <para>Note This function may return non-nil even when the thread state
      /// is detached. Prefer TPyThreadState.Get() or
      /// TPyThreadState.GetUnchecked() for most cases.</para>
      /// <para>See also TPyThreadState.Get()</para>
      /// </summary>
      class function GetThisThreadState: IPyThreadState;
      /// <summary>
      /// <para>Return True if the current thread is holding the GIL and False
      /// otherwise. This function can be called from any thread at any time.
      /// Only if it has had its thread state initialized via
      /// TPyGILState.Ensure() will it return True. This is mainly a
      /// helper/diagnostic function. It can be useful for example in callback
      /// contexts or memory allocation functions when knowing that the GIL is
      /// locked can allow the caller to perform sensitive actions or otherwise
      /// behave differently.</para>
      /// <para>Note If the current Python process has ever created a
      /// subinterpreter, this function will always return True. Prefer
      /// TPyThreadState.GetUnchecked() for most cases.</para>
      /// </summary>
      class function Check: boolean;
      /// <summary>
      /// Helper function to check if an IPyGILState instance is fully
      /// initialized.
      /// </summary>
      class function IsInitialized(const aPyGILState: IPyGILState): boolean; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}

      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      property Initialized  : boolean           read GetInitialized   write SetInitialized;
      /// <summary>
      /// <para>GIL state</para>
      /// </summary>
      property State        : PyGILState_STATE  read GetState         write SetState;
  end;

implementation

uses
  uP4P.PyThreadState;

constructor TPyGILState.Create(aState: PyGILState_STATE);
begin
  inherited Create;

  FState       := aState;
  FInitialized := True;
end;

destructor TPyGILState.Destroy;
begin
  try
    Release;
  finally
    inherited Destroy;
  end;
end;

class function TPyGILState.Ensure: IPyGILState;
begin
  if assigned(PyGILState_Ensure) then
    Result := TPyGILState.Create(PyGILState_Ensure())
   else
    Result := nil;
end;

class function TPyGILState.GetThisThreadState: IPyThreadState;
begin
  if assigned(PyGILState_GetThisThreadState) then
    Result := TPyThreadState.Wrap(PyGILState_GetThisThreadState())
   else
    Result := nil;
end;

class function TPyGILState.Check: boolean;
begin
  Result := assigned(PyGILState_Check) and
            (PyGILState_Check() <> 0);
end;

class function TPyGILState.IsInitialized(const aPyGILState: IPyGILState): boolean;
begin
  Result := assigned(aPyGILState) and aPyGILState.Initialized;
end;

procedure TPyGILState.Release;
begin
  if Initialized and assigned(PyGILState_Release) then
    begin
      PyGILState_Release(State);
      Initialized := False;
    end;
end;

function TPyGILState.GetInitialized: boolean;
begin
  Result := FInitialized;
end;

function TPyGILState.GetState: PyGILState_STATE;
begin
  Result := FState;
end;

procedure TPyGILState.SetInitialized(aValue: boolean);
begin
  FInitialized := aValue;
end;

procedure TPyGILState.SetState(aState: PyGILState_STATE);
begin
  FState := aState;
end;

end.
