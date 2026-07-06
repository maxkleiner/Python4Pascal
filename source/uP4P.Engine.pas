unit uP4P.Engine;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.SyncObjs, System.Types,
  {$ELSE}
    Classes, SysUtils, SyncObjs, Types,
  {$ENDIF}
  uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject, uP4P.Loader,
  uP4P.CustomPyModule, uP4P.IOPyModule;

type
  TOnOutputMessageEvent = procedure(Sender: TObject; const message_: string) of object;
  TOnInputMessageEvent  = procedure(Sender: TObject; var message_: string) of object;

  TP4PEngine = class(TP4PLoader)
    protected
      FModules                   : TList;
      FSyncObj                   : TCriticalSection;
      FIOModule                  : TIOPyModule;
      FInterpreterState          : IPyInterpreterState;
      FThreadState               : IPyThreadState;
      FMainThreadID              : TThreadID;
      FSavedThreadState          : boolean;
      FTimeStruct                : IPyObject;
      FPyDateTime_DateType       : IPyObject;
      FPyDateTime_DateTimeType   : IPyObject;
      FPyDateTime_DeltaType      : IPyObject;
      FPyDateTime_TimeType       : IPyObject;
      FPyDateTime_TZInfoType     : IPyObject;
      FPyDateTime_TimeTZType     : IPyObject;
      FPyDateTime_DateTimeTZType : IPyObject;
      FOnOutputMessage           : TOnOutputMessageEvent;
      FOnInputMessage            : TOnInputMessageEvent;

      function  GetIsMainThread: boolean;
      function  GetSavedThreadState: boolean;

      procedure SetSavedThreadState(aValue: boolean);

      function  Lock: boolean;
      procedure UnLock;
      procedure DestroyIOModule;
      procedure DestroyModules;
      function  RedirectIO: boolean;
      procedure GetTimeStructType;
      procedure GetDateTimeTypes;

    public
      constructor Create; override;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      procedure   BeforeDestruction; override;
      function    AddModuleToSys(const aModule: TCustomPyModule): boolean;
      procedure   AddModule(const aModule: TCustomPyModule);
      procedure   RemoveModule(const aModule: TCustomPyModule);
      function    SearchModule(module: PPyObject; var aResult: TCustomPyModule): boolean;
      function    IsIOModule(module: PPyObject): boolean;
      procedure   doOnOutputMessage(const aMessage: string);
      function    doOnInputMessage(var aResultObj: IPyObject): boolean;
      /// <summary>
      /// Initialize the Python interpreter.
      /// </summary>
      function    Initialize: boolean; override;
      procedure   SaveThreadState;
      procedure   RestoreThreadState;

      function    GetRaisedException: boolean;


      property IOModule         : TIOPyModule              read FIOModule;
      property InterpreterState : IPyInterpreterState      read FInterpreterState;
      property IsMainThread     : boolean                  read GetIsMainThread;
      property SavedThreadState : boolean                  read GetSavedThreadState   write SetSavedThreadState;
      property OnOutputMessage  : TOnOutputMessageEvent    read FOnOutputMessage      write FOnOutputMessage;
      property OnInputMessage   : TOnInputMessageEvent     read FOnInputMessage       write FOnInputMessage;
  end;

var
  /// <summary>
  /// Global instance of TP4PEngine used to simplify the initialization and destruction.
  /// </summary>
  GlobalP4PEngine : TP4PEngine = nil;

procedure DestroyGlobalP4PEngine;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyModule, uP4P.PyImport, uP4P.PyDict, uP4P.PyRun,
  uP4P.PyErr, uP4P.PyUnicode, uP4P.PyBytes, uP4P.PyNone, uP4P.PyInterpreterState,
  uP4P.PyEval, uP4P.PyThreadState;

procedure DestroyGlobalP4PEngine;
begin
  if assigned(GlobalP4PEngine) then
    FreeAndNil(GlobalP4PEngine);
end;

constructor TP4PEngine.Create;
begin
  inherited Create;

  FMainThreadID              := 0;
  FSavedThreadState          := False;
  FModules                   := nil;
  FSyncObj                   := nil;
  FIOModule                  := nil;
  FInterpreterState          := nil;
  FThreadState               := nil;
  FTimeStruct                := nil;
  FPyDateTime_DateType       := nil;
  FPyDateTime_DateTimeType   := nil;
  FPyDateTime_DeltaType      := nil;
  FPyDateTime_TimeType       := nil;
  FPyDateTime_TZInfoType     := nil;
  FPyDateTime_TimeTZType     := nil;
  FPyDateTime_DateTimeTZType := nil;
  FOnOutputMessage           := nil;
  FOnInputMessage            := nil;
end;

destructor TP4PEngine.Destroy;
begin
  try
    DestroyModules;

    if assigned(FSyncObj) then
      FreeAndNil(FSyncObj);
  finally
    inherited Destroy;
  end;
end;

procedure TP4PEngine.AfterConstruction;
begin
  inherited AfterConstruction;
  
  FMainThreadID := TThread.CurrentThread.ThreadID;
  FModules      := TList.Create;
  FSyncObj      := TCriticalSection.Create;
end;

procedure TP4PEngine.BeforeDestruction;
begin
  try
    DestroyIOModule;

    FInterpreterState          := nil;
    FThreadState               := nil;
    FTimeStruct                := nil;
    FPyDateTime_DateType       := nil;
    FPyDateTime_DateTimeType   := nil;
    FPyDateTime_DeltaType      := nil;
    FPyDateTime_TimeType       := nil;
    FPyDateTime_TZInfoType     := nil;
    FPyDateTime_TimeTZType     := nil;
    FPyDateTime_DateTimeTZType := nil;
  finally
    inherited BeforeDestruction;
  end;
end;

procedure TP4PEngine.DestroyModules;
begin
  if Lock then
    try
      if assigned(FModules) then
        FreeAndNil(FModules);
    finally
      UnLock;
    end;
end;

procedure TP4PEngine.DestroyIOModule;
begin
  if assigned(FIOModule) then
    FreeAndNil(FIOModule);
end;

function TP4PEngine.GetIsMainThread: boolean;
begin
  Result := assigned(TThread.Current) and (FMainThreadID = TThread.Current.ThreadID);
end;

function TP4PEngine.GetSavedThreadState: boolean;
begin
  Result := False;

  if Lock then
    try
      Result := FSavedThreadState;
    finally
      Unlock;
    end;
end;

procedure TP4PEngine.SetSavedThreadState(aValue: boolean);
begin
  if Lock then
    try
      FSavedThreadState := aValue;
    finally
      Unlock;
    end;
end;

function TP4PEngine.Lock: boolean;
begin
  if assigned(FSyncObj) then
    begin
      FSyncObj.Acquire;
      Result := True;
    end
   else
    Result := False;
end;

procedure TP4PEngine.UnLock;
begin
  if assigned(FSyncObj) then
    FSyncObj.Release;
end;

function TP4PEngine.AddModuleToSys(const aModule: TCustomPyModule): boolean;
var
  TempModuleDict : IPyObject;
begin
  // add the module to sys.modules
  TempModuleDict := TPyImport.GetModuleDict;
  Result         := TPyDict.SetItemString(TempModuleDict, aModule.Name_, aModule.Module);
  TempModuleDict := nil;
end;

procedure TP4PEngine.AddModule(const aModule: TCustomPyModule);
begin
  if Lock then
    try
      if assigned(FModules) then
        FModules.Add(aModule);
    finally
      UnLock;
    end;
end;

procedure TP4PEngine.RemoveModule(const aModule: TCustomPyModule);
begin
  if Lock then
    try
      if assigned(FModules) then
        FModules.Remove(aModule);
    finally
      UnLock;
    end;
end;

function TP4PEngine.SearchModule(module: PPyObject; var aResult: TCustomPyModule): boolean;
var
  i: integer;
  TempModule : TCustomPyModule;
begin
  Result  := False;
  aResult := nil;

  if Lock then
    try
      if assigned(FModules) then
        for i := 0 to pred(FModules.Count) do
          begin
            TempModule := TCustomPyModule(FModules[i]);

            if TempModule.SameAs(module) then
              begin
                aResult := TempModule;
                Result  := True;
                break;
              end;
          end;
    finally
      UnLock;
    end;
end;

function TP4PEngine.IsIOModule(module: PPyObject): boolean;
begin
  Result := assigned(FIOModule) and
            TPyObject.IsInitialized(FIOModule.Module) and
            FIOModule.Module.SameAs(module);
end;

procedure TP4PEngine.doOnOutputMessage(const aMessage: string);
begin
  if assigned(FOnOutputMessage) then
    FOnOutputMessage(self, aMessage);
end;

function TP4PEngine.doOnInputMessage(var aResultObj: IPyObject): boolean;
var
  TempMessage: string;
begin
  if assigned(FOnInputMessage) then
    begin
      FOnInputMessage(self, TempMessage);
      aResultObj := TPyUnicode.FromString(TempMessage);
      Result     := True;
    end
   else
    Result := False;
end;

function TP4PEngine.RedirectIO: boolean;
begin
  Result := False;

  if not(assigned(FIOModule)) then
    begin
      FIOModule := TIOPyModule.Create(TIOPyModule.ModuleName);
      if not(FIOModule.Initialize) then exit;
    end;

  Result := TIOPyModule.RunInitCode;
end;

procedure TP4PEngine.GetTimeStructType;
var
  TempModule : IPyObject;
begin
  TempModule := TPyImport.ImportModule('time');

  if TPyObject.IsInitialized(TempModule) and
     TempModule.HasAttrString('struct_time') then
    FTimeStruct := TempModule.GetAttrString('struct_time');
end;

procedure TP4PEngine.GetDateTimeTypes;
var
  TempModule : IPyObject;
begin
  TempModule := TPyImport.ImportModule('datetime');

  if TPyObject.IsInitialized(TempModule) then
    begin
      if TempModule.HasAttrString('date') then
        FPyDateTime_DateType := TempModule.GetAttrString('date');

      if TempModule.HasAttrString('datetime') then
        FPyDateTime_DateTimeType := TempModule.GetAttrString('datetime');

      if TempModule.HasAttrString('timedelta') then
        FPyDateTime_DeltaType := TempModule.GetAttrString('timedelta');

      if TempModule.HasAttrString('time') then
        FPyDateTime_TimeType := TempModule.GetAttrString('time');

      if TempModule.HasAttrString('tzinfo') then
        FPyDateTime_TZInfoType := TempModule.GetAttrString('tzinfo');

      if TempModule.HasAttrString('timetz') then
        FPyDateTime_TimeTZType := TempModule.GetAttrString('timetz');

      if TempModule.HasAttrString('datetimetz') then
        FPyDateTime_DateTimeTZType := TempModule.GetAttrString('datetimetz');
    end;
end;

function TP4PEngine.Initialize: boolean;
begin
  Result := False;

  if inherited Initialize and RedirectIO then
    begin
      FInterpreterState := TPyInterpreterState.Get();

      GetTimeStructType;
      GetDateTimeTypes;

      Result := True;
    end;
end;

procedure TP4PEngine.SaveThreadState;
begin
  if IsMainThread and
     not(TPyThreadState.IsInitialized(FThreadState)) then
    begin
      FThreadState     := TPyEval.SaveThread();
      SavedThreadState := TPyThreadState.IsInitialized(FThreadState);
    end;
end;

procedure TP4PEngine.RestoreThreadState;
begin
  if IsMainThread then
    begin
      TPyEval.RestoreThread(FThreadState);
      FThreadState     := nil;
      SavedThreadState := False;
    end;
end;

function TP4PEngine.GetRaisedException: boolean;
var
  TempType, TempValue, TempTraceback : IPyObject;
begin
  if PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    TempValue := TPyErr.GetRaisedException()
   else
    TPyErr.Fetch(TempType, TempValue, TempTraceback);

  FLastErrorMessage := TempValue.AsString;
  Result            := (length(FLastErrorMessage) > 0);

  if TPyObject.IsInitialized(TempValue) then
    begin
      if PythonLibIsGreaterOrEqualThan(3, 12, 0) then
        TPyErr.SetRaisedException(TempValue)
       else
        TPyErr.Restore(TempType, TempValue, TempTraceback);
    end;
end;

end.
