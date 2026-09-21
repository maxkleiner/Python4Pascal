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
  /// <summary>
  /// Custom thread class used to simplify running Python code in a thread.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/threads.html">See the article about Thread states and the global interpreter lock.</see></para>
  /// </remarks>
  TP4PThread = class(TThread)
    protected
      FThreadInit        : TP4PThreadInit;
      FErrorMsg          : string;
      FOnExecutePython   : TNotifyEvent;

      procedure Execute; override;
      procedure ExecuteLegacyInit;
      procedure ExecuteSharedInterpreter;
      procedure ExecuteSubinterpreterSharedGIL;
      procedure ExecuteSubinterpreterOwnGIL;

      procedure doOnExecutePython; virtual;

    public
      procedure AfterConstruction; override;
      /// <summary>
      /// Thread initialization method.
      /// </summary>
      property  ThreadInit        : TP4PThreadInit    read FThreadInit           write FThreadInit;
      /// <summary>
      /// Last error message.
      /// </summary>
      property  ErrorMsg          : string            read FErrorMsg;
      /// <summary>
      /// Event triggered when the thread is initialized. Use it to execute the
      /// Python code.
      /// </summary>
      property  OnExecutePython   : TNotifyEvent      read FOnExecutePython      write FOnExecutePython;
  end;

implementation

uses
  uP4P.PyGILState, uP4P.PyThreadState, uP4P.Engine, uP4P.Py,
  uP4P.PyInterpreterConfig, uP4P.IOPyModule;

procedure TP4PThread.AfterConstruction;
begin
  inherited AfterConstruction;

  FOnExecutePython   := nil;
  FThreadInit        := ti_LegacyAPI;
  FErrorMsg          := '';
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
  if GlobalP4PEngine.SavedThreadState and not(Terminated) then
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
  TempModule      : TIOPyModule;
begin
  if GlobalP4PEngine.SavedThreadState and not(Terminated) then
    begin
      TempModule      := nil;
      TempThreadState := TPy.NewInterpreter();

      if TPyThreadState.IsInitialized(TempThreadState) then
        try
          TempThreadState.Swap;
          TempModule := TIOPyModule.Create(IOPyModuleName);

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
  TempConfig      : IPyInterpreterConfig;
  TempStatus      : IPyStatus;
  TempModule      : TIOPyModule;
begin
  if GlobalP4PEngine.SavedThreadState and not(Terminated) then
    try
      TempModule := nil;
      TempConfig := TPyInterpreterConfig.Create;
      TempConfig.Init;

      TempStatus := TPy.NewInterpreterFromConfig(TempThreadState, TempConfig);

      if not(assigned(TempStatus)) then
        FErrorMsg := 'There was a problem creating the new sub-interpreter.'
       else
        if not(TPyThreadState.IsInitialized(TempThreadState)) then
          FErrorMsg := 'There was a problem creating the new thread state.'
         else
          if TempStatus.IsException then
            FErrorMsg := TempStatus.ErrMsg + CRLF +
                         'Exit code: ' + inttostr(TempStatus.ExitCode)
           else
            try
              TempThreadState.Swap;

              TempModule                  := TIOPyModule.Create(IOPyModuleName);
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
  if assigned(GlobalP4PEngine) then
    case FThreadInit of
      ti_LegacyAPI                : ExecuteLegacyInit;
      ti_SharedInterpreter        : ExecuteSharedInterpreter;
      ti_SubinterpreterSharedGIL  : ExecuteSubinterpreterSharedGIL;
      else                          ExecuteSubinterpreterOwnGIL;     // ti_SubinterpreterOwnGIL
    end;
end;

end.
