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

      procedure Clear;
      procedure Delete;
      function  SetAsyncExc(id: C_ULong; const exc: IPyObject): integer;
      procedure EnterTracing;
      procedure LeaveTracing;
      function  Swap: IPyThreadState; overload;
      function  Next: IPyThreadState;

    public
      constructor Create(aPyThreadState: PPyThreadState);
      function    UnWrap: Pointer;

      class function  Wrap(aPyThreadState: PPyThreadState): IPyThreadState; inline;
      class function  New(const state: IPyInterpreterState): IPyThreadState;
      class function  Get: IPyThreadState;
      class function  GetUnchecked: IPyThreadState;
      class function  Swap(const tstate: IPyThreadState): IPyThreadState; overload;
      class function  IsInitialized(const tstate: IPyThreadState): boolean;
      class procedure DeleteCurrent;

      property Initialized  : boolean               read GetInitialized;
      property ThreadState  : PPyThreadState        read GetThreadState         write SetThreadState;
      property ID           : int64                 read GetID;
      property Dict         : IPyObject             read GetDict;
      property Interpreter  : IPyInterpreterState   read GetInterpreter;
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
