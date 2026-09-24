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
  uP4P.PyInterpreterState, uP4P.IOPyModule;

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
      procedure ExecuteGILState;
      procedure ExecuteSharedInterpreter;
      procedure ExecuteSharedInterpreterWithView;
      procedure ExecuteSubinterpreterSharedGIL;
      procedure ExecuteSubinterpreterSharedGILWithGuard;
      procedure ExecuteSubinterpreterOwnGIL;
      procedure ExecuteSubinterpreterOwnGILWithGuard;

      procedure CreateModuleAndExecute(var aModule: TIOPyModule; aGILSupport: boolean = False);

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
  uP4P.PyInterpreterConfig, uP4P.PyEval,
  uP4P.PyInterpreterGuard, uP4P.PyInterpreterView;

procedure TP4PThread.AfterConstruction;
begin
  inherited AfterConstruction;

  FOnExecutePython   := nil;
  FThreadInit        := ti_GILState;
  FErrorMsg          := '';
end;

procedure TP4PThread.doOnExecutePython;
begin
  if assigned(FOnExecutePython) then
    FOnExecutePython(self);
end;

procedure TP4PThread.ExecuteGILState;
var
  TempGILState : IPyGILState;
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
end;

procedure TP4PThread.ExecuteSharedInterpreter;
var
  TempThreadState : IPyThreadState;
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
end;

procedure TP4PThread.ExecuteSharedInterpreterWithView;
var
  TempView  : IPyInterpreterView;
  TempToken : PPyThreadStateToken;
begin
  try
    TempView  := TPyInterpreterView.FromMain();
    TempToken := TPyThreadState.EnsureFromView(TempView);

    if assigned(TempToken) then
      try
        doOnExecutePython;
      finally
        TPyThreadState.Release(TempToken);
      end
     else
      FErrorMsg := 'There was a problem getting the thread state token.';
  finally
    TempView := nil;
  end;
end;

procedure TP4PThread.ExecuteSubinterpreterSharedGIL;
var
  TempThreadState : IPyThreadState;
  TempModule      : TIOPyModule;
begin
  TempModule      := nil;
  TempThreadState := TPy.NewInterpreter();

  if TPyThreadState.IsInitialized(TempThreadState) then
    try
      TempThreadState.Swap;
      CreateModuleAndExecute(TempModule);
    finally
      if assigned(TempModule) then
        TempModule.Finalize;

      TPy.EndInterpreter(TempThreadState);
      TempThreadState := nil;

      if assigned(TempModule) then
        FreeAndNil(TempModule);
    end
   else
    FErrorMsg := 'There was a problem creating the new thread state.';
end;

procedure TP4PThread.ExecuteSubinterpreterSharedGILWithGuard;
var
  TempGuard       : IPyInterpreterGuard;
  TempThreadState : IPyThreadState;
  TempModule      : TIOPyModule;
  TempToken       : PPyThreadStateToken;
begin
  TempModule      := nil;
  TempThreadState := TPy.NewInterpreter();

  if TPyThreadState.IsInitialized(TempThreadState) then
    try
      TempThreadState.Swap;
      TempGuard := TPyInterpreterGuard.FromCurrent;
      TempToken := TPyThreadState.Ensure(TempGuard);

      if assigned(TempToken) then
        try
          CreateModuleAndExecute(TempModule);
        finally
          TPyThreadState.Release(TempToken);
        end
       else
        FErrorMsg := 'There was a problem getting the thread state token.';
    finally
      TempGuard := nil;

      if assigned(TempModule) then
        TempModule.Finalize;

      TPy.EndInterpreter(TempThreadState);
      TempThreadState := nil;

      if assigned(TempModule) then
        FreeAndNil(TempModule);
    end
   else
    FErrorMsg := 'There was a problem creating the new thread state.';
end;

procedure TP4PThread.ExecuteSubinterpreterOwnGIL;
var
  TempThreadState : IPyThreadState;
  TempConfig      : IPyInterpreterConfig;
  TempStatus      : IPyStatus;
  TempModule      : TIOPyModule;
begin
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
            CreateModuleAndExecute(TempModule, True);
          finally
            if assigned(TempModule) then
              TempModule.Finalize;

            TPy.EndInterpreter(TempThreadState);
            TempThreadState := nil;

            if assigned(TempModule) then
              FreeAndNil(TempModule);
          end;
  finally
    TempConfig := nil;
  end;
end;

procedure TP4PThread.ExecuteSubinterpreterOwnGILWithGuard;
var
  TempThreadState : IPyThreadState;
  TempConfig      : IPyInterpreterConfig;
  TempStatus      : IPyStatus;
  TempModule      : TIOPyModule;
  TempGuard       : IPyInterpreterGuard;
  TempToken       : PPyThreadStateToken;
begin
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
            TempGuard := TPyInterpreterGuard.FromCurrent;
            TempToken := TPyThreadState.Ensure(TempGuard);

            if assigned(TempToken) then
              try
                CreateModuleAndExecute(TempModule, True);
              finally
                TPyThreadState.Release(TempToken);
              end
             else
              FErrorMsg := 'There was a problem getting the thread state token.';
          finally
            TempGuard := nil;

            if assigned(TempModule) then
              TempModule.Finalize;

            TPy.EndInterpreter(TempThreadState);
            TempThreadState := nil;

            if assigned(TempModule) then
              FreeAndNil(TempModule);
          end;
  finally
    TempConfig := nil;
  end;
end;

procedure TP4PThread.CreateModuleAndExecute(var aModule: TIOPyModule; aGILSupport: boolean = False);
begin
  aModule := TIOPyModule.Create(IOPyModuleName);

  if aGILSupport then
    aModule.MultIntprSupport := piGilSupported;

  if aModule.Initialize and TIOPyModule.RunInitCode then
    begin
      doOnExecutePython;
      TIOPyModule.RunRestoreCode;
    end;
end;

procedure TP4PThread.Execute;
begin
  if not(assigned(GlobalP4PEngine)) or
     not(GlobalP4PEngine.SavedThreadState) then
    begin
      FErrorMsg := 'There was a problem saving the main thread state.';
      exit;
    end;

  if GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 15, 0) then
    case FThreadInit of
      ti_GILState                 : ExecuteGILState;
      ti_SharedInterpreter        : ExecuteSharedInterpreterWithView;
      ti_SubinterpreterSharedGIL  : ExecuteSubinterpreterSharedGILWithGuard;
      ti_SubinterpreterOwnGIL     : ExecuteSubinterpreterOwnGILWithGuard;
    end
   else
    case FThreadInit of
      ti_GILState                 : ExecuteGILState;
      ti_SharedInterpreter        : ExecuteSharedInterpreter;
      ti_SubinterpreterSharedGIL  : ExecuteSubinterpreterSharedGIL;
      ti_SubinterpreterOwnGIL     : ExecuteSubinterpreterOwnGIL;
    end;
end;

end.
