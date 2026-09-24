unit uP4P.PyInterpreterState;

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
  /// <para>This class represents the state shared by a number of
  /// cooperating threads. Threads belonging to the same interpreter share
  /// their module administration and a few other internal items. There are no
  /// public members in this structure.</para>
  /// <para>Threads belonging to different interpreters initially share nothing,
  /// except process state like available memory, open file descriptors and
  /// such. The global interpreter lock is also shared by all threads,
  /// regardless of to which interpreter they belong.</para>
  /// <para>Changed in version 3.12: PEP 684 introduced the possibility of a
  /// per-interpreter GIL. See TPy.NewInterpreterFromConfig().</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/subinterpreters.html">See the Multiple interpreters in a Python process article.</see></para>
  /// </remarks>
  TPyInterpreterState = class(TInterfacedObject, IPyInterpreterState)
    protected
      FPyInterpreterState : PPyInterpreterState;

      function  GetInitialized: boolean;
      function  GetState: PPyInterpreterState;
      function  GetID: int64;
      function  GetDict: IPyObject;

      procedure SetState(aState: PPyInterpreterState);

      /// <summary>
      /// <para>Reset all information in an interpreter state object. There must
      /// be an attached thread state for the interpreter.</para>
      /// <para>Raises an auditing event cpython.PyInterpreterState_Clear with
      /// no arguments.</para>
      /// </summary>
      procedure Clear;
      /// <summary>
      /// <para>Destroy an interpreter state object. There should not be an
      /// attached thread state for the target interpreter. The interpreter
      /// state must have been reset with a previous call to Clear().</para>
      /// </summary>
      procedure Delete;
      /// <summary>
      /// <para>Return the next interpreter state object after interp from the
      /// list of all such objects.</para>
      /// </summary>
      function  Next: IPyInterpreterState;
      /// <summary>
      /// <para>Return the pointer to the first PyThreadState object in the list
      /// of threads associated with the interpreter interp.</para>
      /// </summary>
      function  ThreadHead: IPyThreadState;

    public
      constructor Create(aState: PPyInterpreterState);

      /// <summary>
      /// <para>Helper function used to wrap a PyInterpreterState pointer with a
      /// TPyInterpreterState instance.</para>
      /// </summary>
      class function Wrap(aState: PPyInterpreterState): IPyInterpreterState; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
      /// <summary>
      /// <para>Create a new interpreter state object. An attached thread state
      /// is not needed, but may optionally exist if it is necessary to
      /// serialize calls to this function.</para>
      /// <para>Raises an auditing event cpython.PyInterpreterState_New with no
      /// arguments.</para>
      /// </summary>
      class function New: IPyInterpreterState;
      /// <summary>
      /// <para>Get the current interpreter.</para>
      /// <para>Issue a fatal error if there is no attached thread state. It
      /// cannot return nil.</para>
      /// <para>Added in version 3.9.</para>
      /// </summary>
      class function Get: IPyInterpreterState;
      /// <summary>
      /// <para>Return the main interpreter state object.</para>
      /// </summary>
      class function Main: IPyInterpreterState;
      /// <summary>
      /// <para>Return the interpreter state object at the head of the list of
      /// all such objects.</para>
      /// </summary>
      class function Head: IPyInterpreterState;
      /// <summary>
      /// <para>Helper function to check if an IPyInterpreterState instance is
      /// fully initialized.</para>
      /// </summary>
      class function IsInitialized(const aPyInterpreterState: IPyInterpreterState): boolean;

      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      property Initialized  : boolean               read GetInitialized;
      /// <summary>
      /// <para>Pointer to PyInterpreterState</para>
      /// </summary>
      property State        : PPyInterpreterState   read GetState         write SetState;
      /// <summary>
      /// <para>Return the interpreter's unique ID. If there was any error in
      /// doing so then -1 is returned and an error is set.</para>
      /// <para>The caller must have an attached thread state.</para>
      /// <para>Added in version 3.7.</para>
      /// </summary>
      property ID           : int64                 read GetID;
      /// <summary>
      /// <para>Return a dictionary in which interpreter-specific data may be
      /// stored. If this function returns nil then no exception has been
      /// raised and the caller should assume no interpreter-specific dict is
      /// available.</para>
      /// <para>This is not a replacement for TPyModule.GetState(), which
      /// extensions should use to store interpreter-specific state
      /// information.</para>
      /// <para>The returned dictionary is borrowed from the interpreter and is
      /// valid until interpreter shutdown.</para>
      /// <para>Added in version 3.8.</para>
      /// </summary>
      property Dict         : IPyObject             read GetDict;
  end;

implementation

uses
  uP4P.PyThreadState;

constructor TPyInterpreterState.Create(aState: PPyInterpreterState);
begin
  inherited Create;

  State := aState;
end;

class function TPyInterpreterState.Wrap(aState: PPyInterpreterState): IPyInterpreterState;
begin
  if assigned(aState) then
    Result := TPyInterpreterState.Create(aState)
   else
    Result := nil;
end;

class function TPyInterpreterState.New: IPyInterpreterState;
begin
  if assigned(PyInterpreterState_New) then
    Result := TPyInterpreterState.Wrap(PyInterpreterState_New())
   else
    Result := nil;
end;

class function TPyInterpreterState.Get: IPyInterpreterState;
begin
  if assigned(PyInterpreterState_Get) then
    Result := TPyInterpreterState.Wrap(PyInterpreterState_Get())
   else
    Result := nil;
end;

class function TPyInterpreterState.Main: IPyInterpreterState;
begin
  if assigned(PyInterpreterState_Main) then
    Result := TPyInterpreterState.Wrap(PyInterpreterState_Main())
   else
    Result := nil;
end;

class function TPyInterpreterState.Head: IPyInterpreterState;
begin
  if assigned(PyInterpreterState_Head) then
    Result := TPyInterpreterState.Wrap(PyInterpreterState_Head())
   else
    Result := nil;
end;

class function TPyInterpreterState.IsInitialized(const aPyInterpreterState: IPyInterpreterState): boolean;
begin
  Result := assigned(aPyInterpreterState) and aPyInterpreterState.Initialized;
end;

function TPyInterpreterState.GetInitialized: boolean;
begin
  Result := (State <> nil);
end;

function TPyInterpreterState.GetState: PPyInterpreterState;
begin
  Result := FPyInterpreterState;
end;

function TPyInterpreterState.GetID: int64;
begin
  if Initialized and assigned(PyInterpreterState_GetID) then
    Result := PyInterpreterState_GetID(State)
   else
    Result := -1;
end;

function TPyInterpreterState.GetDict: IPyObject;
begin
  if Initialized and assigned(PyInterpreterState_GetDict) then
    Result := TPyObject.Wrap(PyInterpreterState_GetDict(State), False)
   else
    Result := nil;
end;

procedure TPyInterpreterState.SetState(aState: PPyInterpreterState);
begin
  FPyInterpreterState := aState;
end;

procedure TPyInterpreterState.Clear;
begin
  if Initialized and assigned(PyInterpreterState_Clear) then
    PyInterpreterState_Clear(State);
end;

procedure TPyInterpreterState.Delete;
begin
  if Initialized and assigned(PyInterpreterState_Delete) then
    begin
      PyInterpreterState_Delete(State);
      State := nil;
    end;
end;

function TPyInterpreterState.Next: IPyInterpreterState;
begin
  if Initialized and assigned(PyInterpreterState_Next) then
    Result := TPyInterpreterState.Wrap(PyInterpreterState_Next(State))
   else
    Result := nil;
end;

function TPyInterpreterState.ThreadHead: IPyThreadState;
begin
  if Initialized and assigned(PyInterpreterState_ThreadHead) then
    Result := TPyThreadState.Wrap(PyInterpreterState_ThreadHead(State))
   else
    Result := nil;
end;

end.
