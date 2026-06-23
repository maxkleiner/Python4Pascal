unit uP4P.Thread;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.PyInterpreterState;

type
  TP4PThread = class(TThread)
    protected
      FThreadExecMode : TThreadExecMode;
      FSavedState     : boolean;

      procedure Execute; override;
      procedure ExecuteWithPython; virtual; abstract;
      procedure ExecuteNewState;
      procedure ExecuteNewInterpreter;
      procedure ExecuteNewInterpreterOwnGIL;
      procedure SaveMainThreadState;
      procedure RestoreMainThreadState;

    public
      procedure AfterConstruction; override;
  end;

implementation

uses
  uP4P.PyGILState, uP4P.PyThreadState, uP4P.Engine;

procedure TP4PThread.AfterConstruction;
begin
  inherited AfterConstruction;

  FThreadExecMode := emNewInterpreter;
  //FThreadExecMode := emNewState;
  FSavedState     := False;
end;

procedure TP4PThread.ExecuteNewState;
var
  TempGILState : IPyGILState;
begin
  TempGILState := TPyGILState.Ensure;

  if TPyGILState.IsInitialized(TempGILState) then
    try
      ExecuteWithPython;
    finally
      TempGILState.Release;
    end;
end;

procedure TP4PThread.ExecuteNewInterpreter;
var
  TempState : IPyThreadState;
begin
  TempState := TPyThreadState.New(GlobalP4PEngine.InterpreterState);
  TempState.Swap;

  ExecuteWithPython;

  TempState.Clear;
  TPyThreadState.DeleteCurrent;
end;

procedure TP4PThread.ExecuteNewInterpreterOwnGIL;
begin

end;

procedure TP4PThread.SaveMainThreadState;
begin
  FSavedState := GlobalP4PEngine.SaveThreadState;
end;

procedure TP4PThread.RestoreMainThreadState;
begin
  GlobalP4PEngine.RestoreThreadState;
end;

procedure TP4PThread.Execute;
begin
  Synchronize(SaveMainThreadState);

  if FSavedState then
    try
      case FThreadExecMode of
        emNewState       : ExecuteNewState;
        emNewInterpreter : ExecuteNewInterpreter;
        else               ExecuteNewInterpreterOwnGIL;
      end;
    finally
      Synchronize(RestoreMainThreadState);
    end;
end;

end.
