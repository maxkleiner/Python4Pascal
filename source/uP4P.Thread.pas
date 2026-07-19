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
      procedure ExecuteSubinterpreterSharedGIL;
      procedure ExecuteSubinterpreterOwnGIL;

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
  uP4P.PyGILState, uP4P.PyThreadState, uP4P.Engine, uP4P.Py,
  uP4P.PyInterpreterConfig, uP4P.IOPyModule;

procedure TP4PThread.AfterConstruction;
begin
  inherited AfterConstruction;

  FOnExecutePython   := nil;
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
  if GlobalP4PEngine.SavedThreadState then
    begin
      TempGILState := TPyGILState.Ensure;

      if TPyGILState.IsInitialized(TempGILState) then
        try
          doOnExecutePython;
        finally
          TempGILState.Release;
        end
       else
        FErrorMsg := 'There was a problem getting the GIL state.';
    end
   else
    FErrorMsg := 'There was a problem saving the main thread state.';
end;

procedure TP4PThread.ExecuteSharedInterpreter;
var
  TempThreadState : IPyThreadState;
begin
  if GlobalP4PEngine.SavedThreadState then
    begin
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
    end
   else
    FErrorMsg := 'There was a problem saving the main thread state.';
end;

procedure TP4PThread.ExecuteSubinterpreterSharedGIL;
var
  TempThreadState : IPyThreadState;
  TempModule : TIOPyModule;
begin
  if GlobalP4PEngine.SavedThreadState then
    begin
      TempModule      := nil;
      TempThreadState := TPy.NewInterpreter();

      if TPyThreadState.IsInitialized(TempThreadState) then
        try
          TempThreadState.Swap;
          TempModule := TIOPyModule.Create(ModuleName);

          if TempModule.Initialize and TIOPyModule.RunInitCode then
            begin
              doOnExecutePython;
              TIOPyModule.RunRestoreCode;
            end;
        finally
          if assigned(TempModule) then
            FreeAndNil(TempModule);

          TPy.EndInterpreter(TempThreadState);
          TempThreadState := nil;
        end
       else
        FErrorMsg := 'There was a problem creating the new thread state.';
    end
   else
    FErrorMsg := 'There was a problem saving the main thread state.';
end;

procedure TP4PThread.ExecuteSubinterpreterOwnGIL;
var
  TempThreadState : IPyThreadState;
  TempConfig : IPyInterpreterConfig;
  TempStatus : IPyStatus;
  TempModule : TIOPyModule;
begin
  if GlobalP4PEngine.SavedThreadState then
    try
      TempModule := nil;
      TempConfig := TPyInterpreterConfig.Create;
      TempConfig.Init;

      TempStatus := TPy.NewInterpreterFromConfig(TempThreadState, TempConfig);

      if TempStatus.IsException then
        FErrorMsg := TempStatus.ErrMsg + CRLF +
                     'Exit code: ' + inttostr(TempStatus.ExitCode)
       else
        try
          TempThreadState.Swap;

          TempModule                  := TIOPyModule.Create(ModuleName);
          TempModule.MultIntprSupport := piGilSupported;

          if TempModule.Initialize and TIOPyModule.RunInitCode then
            begin
              doOnExecutePython;
              TIOPyModule.RunRestoreCode;
            end;
        finally
          if assigned(TempModule) then
            FreeAndNil(TempModule);

          TPy.EndInterpreter(TempThreadState);
          TempThreadState := nil;
        end;
    finally
      TempConfig := nil;
    end
   else
    FErrorMsg := 'There was a problem saving the main thread state.';
end;

procedure TP4PThread.Execute;
begin
  if not(assigned(GlobalP4PEngine)) then exit;

  if UseLegacyInit or
     not(GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0)) then
    ExecuteLegacyInit
   else
    if SharedInterpreter then
      ExecuteSharedInterpreter
     else
      if SharedGIL then
        ExecuteSubinterpreterSharedGIL
       else
        ExecuteSubinterpreterOwnGIL;
end;

end.
