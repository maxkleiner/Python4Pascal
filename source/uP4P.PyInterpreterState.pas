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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  TPyInterpreterState = class(TInterfacedObject, IPyInterpreterState)
    protected
      FPyInterpreterState : PPyInterpreterState;

      function  GetInitialized: boolean;
      function  GetState: PPyInterpreterState;
      function  GetID: int64;
      function  GetDict: IPyObject;

      procedure SetState(aState: PPyInterpreterState);

      procedure Clear;
      procedure Delete;
      function  Next: IPyInterpreterState;
      function  ThreadHead: IPyThreadState;

    public
      constructor Create(aState: PPyInterpreterState);

      class function Wrap(aState: PPyInterpreterState): IPyInterpreterState; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
      class function New: IPyInterpreterState;
      class function Get: IPyInterpreterState;
      class function Main: IPyInterpreterState;
      class function Head: IPyInterpreterState;
      class function IsInitialized(const aPyInterpreterState: IPyInterpreterState): boolean;

      property Initialized  : boolean               read GetInitialized;
      property State        : PPyInterpreterState   read GetState         write SetState;
      property ID           : int64                 read GetID;
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
