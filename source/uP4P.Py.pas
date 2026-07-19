unit uP4P.Py;

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
  TPy = class
    public
      class procedure FatalError(const message_: string);
      class function  UniversalNewlineFgets(buf: PByte; n: integer; stream: PFILE): PByte;
      class function  GetArgcArgv(var argc: integer; var argv: TStringList): boolean; overload;
      class function  GetArgcArgv(out argc: integer; out argv: PPWCharT): boolean; overload;
      class function  InitializeFromInitConfig(const initconfig: IPyInitConfig): boolean;
      class function  InitializeFromConfig(config: PPyConfig): IPyStatus;
      class function  IsIntialized: boolean;
      class function  GenericAlias(const origin, args: IPyObject): IPyObject;
      class function  IsTrue(const aPyObject: IPyObject): boolean;
      class function  IsFalse(const aPyObject: IPyObject): boolean;
      class function  IsNone(const aPyObject: IPyObject): boolean;
      class function  Type_(const aPyObject: IPyObject): PPyTypeObject;
      class function  IsType(const aPyObject: IPyObject; aPyTypeObject: PPyTypeObject): boolean;
      class function  RefCnt(const aPyObject: IPyObject): integer;
      class procedure IncRef(const aPyObject: IPyObject); overload;
      class procedure IncRef(const aPyObject: PPyObject); overload;
      class procedure DecRef(const aPyObject: IPyObject); overload;
      class procedure DecRef(const aPyObject: PPyObject); overload;
      class function  NewRef(const aPyObject: IPyObject): PPyObject; overload;
      class function  NewRef(aPyObject: PPyConfig): PPyObject; overload;
      class function  XNewRef(const aPyObject: IPyObject): PPyObject; overload;
      class function  XNewRef(aPyObject: PPyConfig): PPyObject; overload;
      class function  Is_(const x, y: IPyObject): boolean; overload;
      class function  Is_(const x, y: PPyObject): boolean; overload;
      class function  GetConstant(constant_id: cardinal): IPyObject;
      class function  GetConstantBorrowed(constant_id: cardinal): IPyObject;
      class function  ReprEnter(const aPyObject: IPyObject): boolean;
      class procedure ReprLeave(const aPyObject: IPyObject);
      class function  CompileString(const str: string; const filename: string = DEFAULT_COMPILE_FILENAME; start: TPyStartSymbols = ssFile): IPyObject;
      class function  CompileStringExFlags(const str, filename: string; start: TPyStartSymbols; flags: PPyCompilerFlags; optimize: integer): IPyObject;
      class function  CompileStringObject(const str: string; const filename: IPyObject; start: TPyStartSymbols; flags: PPyCompilerFlags; optimize: integer): IPyObject;
      class function  CompileStringFlags(const str, filename: string; start: TPyStartSymbols; flags: PPyCompilerFlags): IPyObject;
      class procedure Initialize;
      class procedure InitializeEx(initsigs: integer);
      class procedure Finalize;
      class function  FinalizeEx: boolean;
      class function  NewInterpreter: IPyThreadState;
      class procedure EndInterpreter(const tstate: IPyThreadState);
      class function  AtExit(proc: AtExitProc): boolean;
      class procedure Exit(status: Integer);
      class function  Main(argc: integer; argv: PPWCharT): integer;
      class function  BytesMain(argc: integer; argv: PPAnsiChar): integer;

      class function  SetProgramName(const name_: string): boolean;
      class function  GetProgramName: string;
      class function  SetPythonHome(const home: string): boolean;
      class function  GetPythonHome: string;
      class function  GetProgramFullPath: string;
      class function  GetPrefix: string;
      class function  GetExecPrefix: string;
      class function  GetPath: string;

      class function  GetVersion: string;
      class function  GetPlatform: string;
      class function  GetCopyright: string;
      class function  GetCompiler: string;
      class function  GetBuildInfo: string;
      class function  IsFinalizing: boolean;
      class function  PreInitialize(const src_config: IPyPreConfig): IPyStatus;
      class function  PreInitializeFromBytesArgs(const src_config: IPyPreConfig; argc: Py_ssize_t; argv: PPAnsiChar): IPyStatus;
      class function  PreInitializeFromArgs(const src_config: IPyPreConfig; argc: Py_ssize_t; argv: PPWCharT): IPyStatus;
      class function  RunMain: integer;
      class procedure ExitStatusException(const status: IPyStatus);
      class function  FdIsInteractive(file_: PFILE; const filename: string): boolean;
      class function  NewInterpreterFromConfig(out tstate: IPyThreadState; const config: IPyInterpreterConfig): IPyStatus;
      class function  AddPendingCall(func: Py_AddPendingCall_func; arg: pointer): boolean;
      class function  MakePendingCalls: boolean;
      class procedure SetRecursionLimit(new_limit: Integer);
      class function  GetRecursionLimit: integer;
      class function  EnterRecursiveCall(const where_: string): boolean;
      class procedure LeaveRecursiveCall;
      class function  DecodeLocale(const arg: PAnsiChar; size_: NativeUInt): PWCharT;
      class function  EncodeLocale(const text: PWCharT; error_pos: NativeUInt): PAnsiChar;
      class function  fopen(const path: IPyObject; const mode: string): PFILE;
      class function  fclose(file_: PFILE): integer;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyStatus, uP4P.PyThreadState,
  uP4P.PyInitConfig, uP4P.PyPreConfig;

class procedure TPy.FatalError(const message_: string);
var
  TempMessage : AnsiString;
begin
  if assigned(Py_FatalError) then
    begin
      TempMessage := StringToPyUTF8(message_);
      Py_FatalError(PAnsiChar(TempMessage));
    end;
end;

class function TPy.UniversalNewlineFgets(buf: PByte; n: integer; stream: PFILE): PByte;
begin
  // The fobj parameter exists solely for legacy reasons and must be NULL.
  if assigned(Py_UniversalNewlineFgets) then
    Result := PByte(Py_UniversalNewlineFgets(PAnsiChar(buf), n, stream, nil))
   else
    Result := nil;
end;

class function TPy.GetArgcArgv(out argc: integer; out argv: PPWCharT): boolean;
begin
  if assigned(Py_GetArgcArgv) then
    begin
      Py_GetArgcArgv(argc, argv);
      Result := True;
    end
   else
    Result := False;
end;

class function TPy.GetArgcArgv(var argc: integer; var argv: TStringList): boolean;
var
  TempArgv : PPWCharT;
begin
  Result := GetArgcArgv(argc, TempArgv) and
            WCharTArrayToStringList(TempArgv, argc, argv);
end;

class function TPy.InitializeFromInitConfig(const initconfig: IPyInitConfig): boolean;
begin
  Result := assigned(Py_InitializeFromInitConfig) and
            TPyInitConfig.IsInitialized(initconfig) and
            (Py_InitializeFromInitConfig(initconfig.config) = 0);
end;

class function TPy.InitializeFromConfig(config: PPyConfig): IPyStatus;
begin
  if assigned(Py_InitializeFromConfig) then
    Result := TPyStatus.Create(Py_InitializeFromConfig(config))
   else
    Result := nil;
end;

class function TPy.IsIntialized: boolean;
begin
  Result := assigned(Py_IsInitialized) and
            (Py_IsInitialized() <> 0);
end;

class function TPy.GenericAlias(const origin, args: IPyObject): IPyObject;
begin
  if assigned(Py_GenericAlias) and
     TPyObject.IsInitialized(origin) and
     TPyObject.IsInitialized(args) then
    Result := TPyObject.Wrap(Py_GenericAlias(origin.PyObject, args.PyObject))
   else
    Result := nil;
end;

class function TPy.IsTrue(const aPyObject: IPyObject): boolean;
begin
  Result := assigned(Py_IsTrue) and
            TPyObject.IsInitialized(aPyObject)  and
            (Py_IsTrue(aPyObject.PyObject) <> 0);
end;

class function TPy.IsFalse(const aPyObject: IPyObject): boolean;
begin
  Result := assigned(Py_IsFalse) and
            TPyObject.IsInitialized(aPyObject)  and
            (Py_IsFalse(aPyObject.PyObject) <> 0);
end;

class function TPy.IsNone(const aPyObject: IPyObject): boolean;
begin
  Result := assigned(Py_IsNone) and
            TPyObject.IsInitialized(aPyObject)  and
            (Py_IsNone(aPyObject.PyObject) <> 0);
end;

class function TPy.Type_(const aPyObject: IPyObject): PPyTypeObject;
begin
  Result := nil;

  if TPyObject.IsInitialized(aPyObject) then
    begin
      if assigned(Py_TYPE) then
        Result := Py_TYPE(aPyObject.PyObject)
       else
        Result := aPyObject.PyObject^.ob_type;
    end;
end;

class function TPy.IsType(const aPyObject: IPyObject; aPyTypeObject: PPyTypeObject): boolean;
begin
  Result := assigned(aPyTypeObject) and (Type_(aPyObject) = aPyTypeObject);
end;

class function TPy.RefCnt(const aPyObject: IPyObject): integer;
begin
  Result := 0;

  if TPyObject.IsInitialized(aPyObject) then
    begin
      if assigned(Py_REFCNT) then
        Result := Py_REFCNT(aPyObject.PyObject)
       else
        Result := aPyObject.PyObject^.ob_refcnt;
    end;
end;

class procedure TPy.IncRef(const aPyObject: IPyObject);
begin
  if assigned(aPyObject) then
    IncRef(aPyObject.PyObject);
end;

class procedure TPy.IncRef(const aPyObject: PPyObject);
begin
  if assigned(Py_IncRef) and
     assigned(aPyObject) then
    Py_IncRef(aPyObject);
end;

class procedure TPy.DecRef(const aPyObject: IPyObject);
begin
  if assigned(aPyObject) then
    DecRef(aPyObject.PyObject);
end;

class procedure TPy.DecRef(const aPyObject: PPyObject);
begin
  if assigned(Py_DecRef) and
     assigned(aPyObject) then
    Py_DecRef(aPyObject);
end;

class function TPy.NewRef(aPyObject: PPyConfig): PPyObject;
begin
  if assigned(Py_NewRef) and assigned(aPyObject) then
    Result := Py_NewRef(aPyObject)
   else
    Result := nil;
end;

class function TPy.NewRef(const aPyObject: IPyObject): PPyObject;
begin
  if assigned(aPyObject) then
    Result := NewRef(aPyObject.PyObject)
   else
    Result := nil;
end;

class function TPy.XNewRef(aPyObject: PPyConfig): PPyObject;
begin
  if assigned(Py_XNewRef) then
    Result := Py_XNewRef(aPyObject)
   else
    Result := nil;
end;

class function TPy.XNewRef(const aPyObject: IPyObject): PPyObject;
begin
  if assigned(aPyObject) then
    Result := XNewRef(aPyObject.PyObject)
   else
    Result := nil;
end;

class function TPy.Is_(const x, y: IPyObject): boolean;
begin
  Result := assigned(Py_Is) and
            assigned(x) and
            assigned(y) and
            TPy.Is_(x.PyObject, y.PyObject);
end;

class function TPy.Is_(const x, y: PPyObject): boolean;
begin
  Result := assigned(Py_Is) and
            assigned(x) and
            assigned(y) and
            (Py_Is(x, y) <> 0);
end;

class function TPy.GetConstant(constant_id: cardinal): IPyObject;
begin
  if assigned(Py_GetConstant) and
     (constant_id in [Py_CONSTANT_FIRST..Py_CONSTANT_LAST]) then
    Result := TPyObject.Wrap(Py_GetConstant(constant_id))
   else
    Result := nil;
end;

class function TPy.GetConstantBorrowed(constant_id: cardinal): IPyObject;
begin
  if assigned(Py_GetConstantBorrowed) and
     (constant_id in [Py_CONSTANT_FIRST..Py_CONSTANT_LAST]) then
    Result := TPyObject.Wrap(Py_GetConstantBorrowed(constant_id), False)
   else
    Result := nil;
end;

class function TPy.ReprEnter(const aPyObject: IPyObject): boolean;
begin
  Result := assigned(Py_ReprEnter) and
            TPyObject.IsInitialized(aPyObject) and
            (Py_ReprEnter(aPyObject.PyObject) = 0);
end;

class procedure TPy.ReprLeave(const aPyObject: IPyObject);
begin
  if assigned(Py_ReprLeave) and
     TPyObject.IsInitialized(aPyObject) then
    Py_ReprLeave(aPyObject.PyObject);
end;

class function TPy.CompileString(const str, filename: string; start: TPyStartSymbols): IPyObject;
var
  TempString, TempFilename : AnsiString;
begin
  if assigned(Py_CompileString) then
    begin
      TempString   := StringToPyUTF8(str);
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(Py_CompileString(PAnsiChar(TempString), PAnsiChar(TempFilename), PyStartSymbolToInt(start)));
    end
   else
    Result := nil;
end;

class function TPy.CompileStringExFlags(const str, filename: string; start: TPyStartSymbols; flags: PPyCompilerFlags; optimize: integer): IPyObject;
var
  TempString, TempFilename : AnsiString;
begin
  if assigned(Py_CompileStringExFlags) then
    begin
      TempString   := StringToPyUTF8(str);
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(Py_CompileStringExFlags(PAnsiChar(TempString), PAnsiChar(TempFilename), PyStartSymbolToInt(start), flags, optimize));
    end
   else
    Result := nil;
end;

class function TPy.CompileStringObject(const str: string; const filename: IPyObject; start: TPyStartSymbols; flags: PPyCompilerFlags; optimize: integer): IPyObject;
var
  TempString : AnsiString;
begin
  if assigned(Py_CompileStringObject) and
     TPyObject.IsInitialized(filename) then
    begin
      TempString := StringToPyUTF8(str);
      Result     := TPyObject.Wrap(Py_CompileStringObject(PAnsiChar(TempString), filename.PyObject, PyStartSymbolToInt(start), flags, optimize));
    end
   else
    Result := nil;
end;

class function TPy.CompileStringFlags(const str, filename: string; start: TPyStartSymbols; flags: PPyCompilerFlags): IPyObject;
begin
  Result := TPy.CompileStringExFlags(str, filename, start, flags, -1);
end;

class procedure TPy.Initialize;
begin
  if assigned(Py_Initialize) then
    Py_Initialize();
end;

class procedure TPy.InitializeEx(initsigs: integer);
begin
  if assigned(Py_InitializeEx) then
    Py_InitializeEx(initsigs);
end;

class procedure TPy.Finalize;
begin
  if assigned(Py_Finalize) then
    Py_Finalize();
end;

class function TPy.FinalizeEx: boolean;
begin
  Result := assigned(Py_FinalizeEx) and
            (Py_FinalizeEx() = 0);
end;

class function TPy.NewInterpreter: IPyThreadState;
begin
  if assigned(Py_NewInterpreter) then
    Result := TPyThreadState.Wrap(Py_NewInterpreter())
   else
    Result := nil;
end;

class procedure TPy.EndInterpreter(const tstate: IPyThreadState);
begin
  if assigned(Py_EndInterpreter) and
     TPyThreadState.IsInitialized(tstate) then
    Py_EndInterpreter(tstate.UnWrap);
end;

class function TPy.AtExit(proc: AtExitProc): boolean;
begin
  Result := assigned(Py_AtExit) and
            assigned(proc) and
            (Py_AtExit(proc) = 0);
end;

class procedure TPy.Exit(status: Integer);
begin
  if assigned(Py_Exit) then
    Py_Exit(status);
end;

class function TPy.Main(argc: integer; argv: PPWCharT): integer;
begin
  if assigned(Py_Main) then
    Result := Py_Main(argc, argv)
   else
    Result := 0;
end;

class function TPy.BytesMain(argc: integer; argv: PPAnsiChar): integer;
begin
  if assigned(Py_BytesMain) then
    Result := Py_BytesMain(argc, argv)
   else
    Result := 0;
end;

class function TPy.SetProgramName(const name_: string): boolean;
var
  TempName : WCharTString;
begin
  Result := False;
  if assigned(Py_SetProgramName) then
    begin
      TempName := StringToPyWCharTString(name_);
      Py_SetProgramName(PWCharT(TempName));
      Result := True;
    end;
end;

class function TPy.GetProgramName: string;
begin
  if assigned(Py_GetProgramName) then
    Result := PyWCharTStringToString(WCharTString(Py_GetProgramName()))
   else
    Result := '';
end;

class function TPy.SetPythonHome(const home: string): boolean;
var
  TempHome : WCharTString;
begin
  Result := False;
  if assigned(Py_SetPythonHome) then
    begin
      TempHome := StringToPyWCharTString(home);
      Py_SetPythonHome(PWCharT(TempHome));
      Result := True;
    end;
end;

class function TPy.GetPythonHome: string;
begin
  if assigned(Py_GetPythonHome) then
    Result := PyWCharTStringToString(WCharTString(Py_GetPythonHome()))
   else
    Result := '';
end;

class function TPy.GetProgramFullPath: string;
begin
  if assigned(Py_GetProgramFullPath) then
    Result := PyWCharTStringToString(WCharTString(Py_GetProgramFullPath()))
   else
    Result := '';
end;

class function TPy.GetPrefix: string;
begin
  if assigned(Py_GetPrefix) then
    Result := PyWCharTStringToString(WCharTString(Py_GetPrefix()))
   else
    Result := '';
end;

class function TPy.GetExecPrefix: string;
begin
  if assigned(Py_GetExecPrefix) then
    Result := PyWCharTStringToString(WCharTString(Py_GetExecPrefix()))
   else
    Result := '';
end;

class function TPy.GetPath: string;
begin
  if assigned(Py_GetPath) then
    Result := PyWCharTStringToString(WCharTString(Py_GetPath()))
   else
    Result := '';
end;

class function TPy.GetVersion: string;
begin
  if assigned(Py_GetVersion) then
    Result := PyUTF8ToString(Py_GetVersion())
   else
    Result := '';
end;

class function TPy.GetPlatform: string;
begin
  if assigned(Py_GetPlatform) then
    Result := PyUTF8ToString(Py_GetPlatform())
   else
    Result := '';
end;

class function TPy.GetCopyright: string;
begin
  if assigned(Py_GetCopyright) then
    Result := PyUTF8ToString(Py_GetCopyright())
   else
    Result := '';
end;

class function TPy.GetCompiler: string;
begin
  if assigned(Py_GetCompiler) then
    Result := PyUTF8ToString(Py_GetCompiler())
   else
    Result := '';
end;

class function TPy.GetBuildInfo: string;
begin
  if assigned(Py_GetBuildInfo) then
    Result := PyUTF8ToString(Py_GetBuildInfo())
   else
    Result := '';
end;

class function TPy.IsFinalizing: boolean;
begin
  Result := assigned(Py_IsFinalizing) and (Py_IsFinalizing() <> 0);
end;

class function TPy.PreInitialize(const src_config: IPyPreConfig): IPyStatus;
begin
  if assigned(Py_PreInitialize) and
     TPyPreConfig.IsInitialized(src_config) then
    Result := TPyStatus.Create(Py_PreInitialize(src_config.Config))
   else
    Result := nil;
end;

class function TPy.PreInitializeFromBytesArgs(const src_config: IPyPreConfig; argc: Py_ssize_t; argv: PPAnsiChar): IPyStatus;
begin
  if assigned(Py_PreInitializeFromBytesArgs) and
     TPyPreConfig.IsInitialized(src_config) then
    Result := TPyStatus.Create(Py_PreInitializeFromBytesArgs(src_config.Config, argc, argv))
   else
    Result := nil;
end;

class function TPy.PreInitializeFromArgs(const src_config: IPyPreConfig; argc: Py_ssize_t; argv: PPWCharT): IPyStatus;
begin
  if assigned(Py_PreInitializeFromArgs) and
     TPyPreConfig.IsInitialized(src_config) then
    Result := TPyStatus.Create(Py_PreInitializeFromArgs(src_config.Config, argc, argv))
   else
    Result := nil;
end;

class function TPy.RunMain: integer;
begin
  if assigned(Py_RunMain) then
    Result := Py_RunMain()
   else
    REsult := 0;
end;

class procedure TPy.ExitStatusException(const status: IPyStatus);
begin
  if assigned(Py_ExitStatusException) and
     assigned(status) then
    Py_ExitStatusException(status.Status)
end;

class function TPy.FdIsInteractive(file_: PFILE; const filename: string): boolean;
var
  TempFilename : AnsiString;
  TempFilenamePtr : PAnsiChar;
begin
  Result := False;

  if assigned(Py_FdIsInteractive) then
    begin
      if (length(filename) > 0) then
        begin
          TempFilename    := StringToPyUTF8(filename);
          TempFilenamePtr := PAnsiChar(TempFilename);
        end
       else
        TempFilenamePtr := nil;

      Result := (Py_FdIsInteractive(file_, TempFilenamePtr) <> 0);
    end;
end;

class function TPy.NewInterpreterFromConfig(out tstate: IPyThreadState; const config: IPyInterpreterConfig): IPyStatus;
var
  TempTState : PPyThreadState;
begin
  if assigned(Py_NewInterpreterFromConfig) and
     assigned(config) then
    begin
      TempTState := nil;
      Result     := TPyStatus.Create(Py_NewInterpreterFromConfig(TempTState, config.Config));
      tstate     := TPyThreadState.Wrap(TempTState);
    end
   else
    Result := nil;
end;

class function TPy.AddPendingCall(func: Py_AddPendingCall_func; arg: pointer): boolean;
begin
  Result := assigned(Py_AddPendingCall) and
            (Py_AddPendingCall(func, arg) = 0);
end;

class function TPy.MakePendingCalls: boolean;
begin
  Result := assigned(Py_MakePendingCalls) and
            (Py_MakePendingCalls() = 0);
end;

class procedure TPy.SetRecursionLimit(new_limit: Integer);
begin
  if assigned(Py_SetRecursionLimit) then
    Py_SetRecursionLimit(new_limit);
end;

class function TPy.GetRecursionLimit: integer;
begin
  if assigned(Py_GetRecursionLimit) then
    Result := Py_GetRecursionLimit()
   else
    Result := 0;
end;

class function TPy.EnterRecursiveCall(const where_: string): boolean;
var
  TempWhere : AnsiString;
begin
  if assigned(Py_EnterRecursiveCall) then
    begin
      TempWhere := StringToPyUTF8(where_);
      Result    := (Py_EnterRecursiveCall(PAnsiChar(TempWhere)) = 0);
    end
   else
    Result := False;
end;

class procedure TPy.LeaveRecursiveCall;
begin
  if assigned(Py_LeaveRecursiveCall) then
    Py_LeaveRecursiveCall();
end;

class function TPy.DecodeLocale(const arg: PAnsiChar; size_: NativeUInt): PWCharT;
begin
  if assigned(Py_DecodeLocale) then
    Result := Py_DecodeLocale(arg, size_)
   else
    Result := nil;
end;

class function TPy.EncodeLocale(const text: PWCharT; error_pos: NativeUInt): PAnsiChar;
begin
  if assigned(Py_EncodeLocale) then
    Result := Py_EncodeLocale(text, error_pos)
   else
    Result := nil;
end;

class function TPy.fopen(const path: IPyObject; const mode: string): PFILE;
var
  TempMode : AnsiString;
begin
  if assigned(Py_fopen) and
     TPyObject.IsInitialized(path) then
    begin
      TempMode := StringToPyUTF8(mode);
      Result   := Py_fopen(path.PyObject, PAnsiChar(TempMode));
    end
   else
    Result := nil;
end;

class function TPy.fclose(file_: PFILE): integer;
begin
  if assigned(Py_fclose) and
     assigned(file_) then
    Result := Py_fclose(file_)
   else
    Result := 0;
end;

end.
