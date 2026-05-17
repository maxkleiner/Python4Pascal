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
  TPyGILState = class(TInterfacedObject, IPyGILState)
    protected
      FInitialized : boolean;
      FState       : PyGILState_STATE;

      function  GetInitialized: boolean;
      function  GetState: PyGILState_STATE;

      procedure SetInitialized(aValue: boolean);
      procedure SetState(aState: PyGILState_STATE);

      procedure Release;

    public
      constructor Create(aState: PyGILState_STATE);
      destructor  Destroy; override;

      class function Ensure: IPyGILState;
      class function GetThisThreadState: IPyThreadState;
      class function Check: boolean;

      property Initialized  : boolean           read GetInitialized   write SetInitialized;
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
