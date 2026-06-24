unit uP4P.Thread;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.PyInterpreterState;

type
  TP4PThread = class(TThread)
    protected
      FSavedState        : boolean;
      FUseLegacyInit     : boolean;
      FSharedGIL         : boolean;
      FSharedInterpreter : boolean;
      FErrorMsg          : string;
      FOnExecutePython   : TNotifyEvent;

      function  GetUseLegacyInit: boolean;
      function  GetSharedGIL: boolean;
      function  GetSharedInterpreter: boolean;

      procedure SetSharedGIL(aValue : boolean);
      procedure SetUseLegacyInit(aValue : boolean);
      procedure SetSharedInterpreter(aValue : boolean);

      procedure Execute; override;
      procedure ExecuteLegacyInit;
      procedure ExecuteSharedInterpreter;
      procedure ExecuteSubinterpreter;

      procedure SaveMainThreadState;
      procedure RestoreMainThreadState;

      procedure doOnExecutePython; virtual;

    public
      procedure AfterConstruction; override;

      property  UseLegacyInit     : boolean       read GetUseLegacyInit      write SetUseLegacyInit;
      property  SharedGIL         : boolean       read GetSharedGIL          write SetSharedGIL;
      property  SharedInterpreter : boolean       read GetSharedInterpreter  write SetSharedInterpreter;
      property  ErrorMsg          : string        read FErrorMsg;
      property  OnExecutePython   : TNotifyEvent  read FOnExecutePython      write FOnExecutePython;
  end;

implementation

uses
  uP4P.PyGILState, uP4P.PyThreadState, uP4P.Engine, uP4P.Py, uP4P.PyInterpreterConfig;

procedure TP4PThread.AfterConstruction;
begin
  inherited AfterConstruction;

  FOnExecutePython   := nil;
  FSavedState        := False;
  FUseLegacyInit     := False;
  FSharedGIL         := False;
  FSharedInterpreter := True;
  FErrorMsg          := '';
end;

function TP4PThread.GetUseLegacyInit: boolean;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
    Result := False
   else
    Result := FUseLegacyInit;
end;

function TP4PThread.GetSharedGIL: boolean;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    Result := FSharedGIL
   else
    Result := True;
end;

function TP4PThread.GetSharedInterpreter: boolean;
begin
  Result := FSharedInterpreter;
end;

procedure TP4PThread.SetUseLegacyInit(aValue : boolean);
begin
  if (GlobalP4PEngine <> nil) and not(GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0)) then
    FUseLegacyInit := aValue;
end;

procedure TP4PThread.SetSharedGIL(aValue : boolean);
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    FSharedGIL := aValue;
end;

procedure TP4PThread.SetSharedInterpreter(aValue : boolean);
begin
  FSharedInterpreter := aValue;
end;

procedure TP4PThread.doOnExecutePython;
begin
  if assigned(FOnExecutePython) then
    FOnExecutePython(self);
end;

procedure TP4PThread.ExecuteLegacyInit;
var
  TempGILState : IPyGILState;
begin
  Synchronize(SaveMainThreadState);

  if FSavedState then
    try
      TempGILState := TPyGILState.Ensure;

      if TPyGILState.IsInitialized(TempGILState) then
        try
          doOnExecutePython;
        finally
          TempGILState.Release;
        end
       else
        FErrorMsg := 'There was a problem getting the GIL state.';
    finally
      Synchronize(RestoreMainThreadState);
    end
   else
    FErrorMsg := 'There was a problem saving the main thread state.';
end;

procedure TP4PThread.ExecuteSharedInterpreter;
var
  TempThreadState : IPyThreadState;
begin
  Synchronize(SaveMainThreadState);

  if FSavedState then
    try
      TempThreadState := TPyThreadState.New(GlobalP4PEngine.InterpreterState);

      if TPyThreadState.IsInitialized(TempThreadState) then
        try
          TempThreadState.Swap;
          doOnExecutePython;
        finally
          TempThreadState.Clear;
          TPyThreadState.DeleteCurrent;
        end
       else
        FErrorMsg := 'There was a problem creating the new thread state.';
    finally
      Synchronize(RestoreMainThreadState);
    end
   else
    FErrorMsg := 'There was a problem saving the main thread state.';
end;

procedure TP4PThread.ExecuteSubinterpreter;
var
  TempThreadState : IPyThreadState;
  TempConfig : IPyInterpreterConfig;
  TempStatus : IPyStatus;
begin
  Synchronize(SaveMainThreadState);

  if FSavedState then
    try
      TempConfig := TPyInterpreterConfig.Create;
      TempConfig.Init;

      if SharedGIL then
        TempConfig.gil := gilShared
       else
        TempConfig.gil := gilOwn;

      TempStatus := TPy.NewInterpreterFromConfig(TempThreadState, TempConfig);

      if TempStatus.IsException then
        FErrorMsg := TempStatus.ErrMsg + CRLF +
                     'Exit code: ' + inttostr(TempStatus.ExitCode)
       else
        try
          TempThreadState.Swap;
          doOnExecutePython;
        finally
          TempThreadState.Clear;
          //TempThreadState.Delete;
          TempThreadState := nil;
        end;
    finally
      TempConfig := nil;
      Synchronize(RestoreMainThreadState);
    end
   else
    FErrorMsg := 'There was a problem saving the main thread state.';
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
  if UseLegacyInit then
    ExecuteLegacyInit
   else
    if SharedInterpreter then
      ExecuteSharedInterpreter
     else
      ExecuteSubinterpreter;
end;

end.
