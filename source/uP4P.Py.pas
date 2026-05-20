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
      class function  GetArgcArgv(var argc: integer; var argv: TStringList): boolean;
      class function  InitializeFromInitConfig(config: PPyInitConfig): boolean;
      class function  InitializeFromConfig(config: PPyConfig): IPyStatus;
      class function  IsIntialized: boolean;
      class function  GenericAlias(const origin, args: IPyObject): IPyObject;
      class function  IsTrue(const aPyObject: IPyObject): boolean;
      class function  IsFalse(const aPyObject: IPyObject): boolean;
      class function  IsNone(const aPyObject: IPyObject): boolean;
      class function  Type_(const aPyObject: IPyObject): PPyTypeObject;
      class function  RefCnt(const aPyObject: IPyObject): integer;
      class procedure IncRef(const aPyObject: IPyObject);
      class procedure DecRef(const aPyObject: IPyObject);
      class function  NewRef(const aPyObject: IPyObject): PPyConfig; overload;
      class function  NewRef(aPyObject: PPyConfig): PPyConfig; overload;
      class function  XNewRef(const aPyObject: IPyObject): PPyConfig;
      class function  Is_(const x, y: IPyObject): boolean;
      class function  GetConstant(constant_id: cardinal): PPyConfig;
      class function  GetConstantBorrowed(constant_id: cardinal): PPyConfig;
      class function  ReprEnter(const aPyObject: IPyObject): boolean;
      class procedure ReprLeave(const aPyObject: IPyObject);
      class function  CompileString(const str, filename: string; start: integer): IPyObject;
      class function  CompileStringExFlags(const str, filename: string; start: integer; flags: PPyCompilerFlags; optimize: integer): IPyObject;
      class function  CompileStringObject(const str: string; const filename: IPyObject; start: integer; flags: PPyCompilerFlags; optimize: integer): IPyObject;
      class function  CompileStringFlags(const str, filename: string; start: integer; flags: PPyCompilerFlags): IPyObject;
      class procedure Initialize;
      class procedure InitializeEx(initsigs: integer);
      class procedure Finalize;
      class function  FinalizeEx: boolean;
      class function  NewInterpreter: PPyThreadState;
      class procedure EndInterpreter(threadstate: PPyThreadState);
      class function  AtExit(proc: AtExitProc): boolean;
      class procedure Exit(i: Integer);
      class function  Main(argc: integer; argv: PPWCharT): integer;
      class function  BytesMain(argc: integer; argv: PPAnsiChar): integer;
      class function  GetVersion: string;
      class function  GetPlatform: string;
      class function  GetCopyright: string;
      class function  GetCompiler: string;
      class function  GetBuildInfo: string;
      class function  IsFinalizing: boolean;
      class function  PreInitialize(src_config: PPyPreConfig): PyStatus;
      class function  PreInitializeFromBytesArgs(src_config: PPyPreConfig; argc: Py_ssize_t; argv: PPAnsiChar): PyStatus;
      class function  PreInitializeFromArgs(src_config: PPyPreConfig; argc: Py_ssize_t; argv: PPWCharT): PyStatus;
      class function  RunMain: integer;
      class procedure ExitStatusException(err: PyStatus);
      class function  FdIsInteractive(file_: PFILE; const str: string): boolean;
      class function  NewInterpreterFromConfig(var tstate: PPyThreadState; config: PPyInterpreterConfig): PyStatus;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyTypeObject, uP4P.PyStatus;

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

class function TPy.GetArgcArgv(var argc: integer; var argv: TStringList): boolean;
var
  TempArgv : PPWCharT;
begin
  Result := False;

  if assigned(Py_GetArgcArgv) then
    begin
      Py_GetArgcArgv(argc, TempArgv);
      Result := WCharTArrayToStringList(TempArgv, argc, argv);
    end;
end;

class function TPy.InitializeFromInitConfig(config: PPyInitConfig): boolean;
begin
  Result := assigned(Py_InitializeFromInitConfig) and
            (Py_InitializeFromInitConfig(config) = 0);
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
  if assigned(Py_TYPE) and
     TPyObject.IsInitialized(aPyObject) then
    Result := Py_TYPE(aPyObject.PyObject)
   else
    Result := nil;
end;

class function TPy.RefCnt(const aPyObject: IPyObject): integer;
begin
  if assigned(Py_REFCNT) and
     TPyObject.IsInitialized(aPyObject) then
    Result := Py_REFCNT(aPyObject.PyObject)
   else
    Result := 0;
end;

class procedure TPy.IncRef(const aPyObject: IPyObject);
begin
  if assigned(Py_IncRef) and
     TPyObject.IsInitialized(aPyObject) then
    Py_IncRef(aPyObject.PyObject);
end;

class procedure TPy.DecRef(const aPyObject: IPyObject);
begin
  if assigned(Py_DecRef) and
     TPyObject.IsInitialized(aPyObject) then
    Py_DecRef(aPyObject.PyObject);
end;

class function TPy.NewRef(aPyObject: PPyConfig): PPyConfig;
begin
  if assigned(Py_NewRef) then
    Result := Py_NewRef(aPyObject)
   else
    Result := nil;
end;

class function TPy.NewRef(const aPyObject: IPyObject): PPyConfig;
begin
  if TPyObject.IsInitialized(aPyObject) then
    Result := NewRef(aPyObject.PyObject)
   else
    Result := nil;
end;

class function TPy.XNewRef(const aPyObject: IPyObject): PPyConfig;
begin
  if assigned(Py_XNewRef) and
     TPyObject.IsInitialized(aPyObject) then
    Result := Py_XNewRef(aPyObject.PyObject)
   else
    Result := nil;
end;

class function TPy.Is_(const x, y: IPyObject): boolean;
begin
  Result := assigned(Py_Is) and
            TPyObject.IsInitialized(x) and
            TPyObject.IsInitialized(y) and
            (Py_Is(x.PyObject, y.PyObject) <> 0);
end;

class function TPy.GetConstant(constant_id: cardinal): PPyConfig;
begin
  if assigned(Py_GetConstant) and
     (constant_id in [Py_CONSTANT_NONE..Py_CONSTANT_EMPTY_TUPLE]) then
    Result := Py_GetConstant(constant_id)
   else
    Result := nil;
end;

class function TPy.GetConstantBorrowed(constant_id: cardinal): PPyConfig;
begin
  if assigned(Py_GetConstantBorrowed) and
     (constant_id in [Py_CONSTANT_NONE..Py_CONSTANT_EMPTY_TUPLE]) then
    Result := Py_GetConstantBorrowed(constant_id)
   else
    Result := nil;
end;

class function TPy.ReprEnter(const aPyObject: IPyObject): boolean;
begin
  Result := assigned(Py_ReprEnter) and
            TPyObject.IsInitialized(aPyObject)  and
            (Py_ReprEnter(aPyObject.PyObject) = 0);
end;

class procedure TPy.ReprLeave(const aPyObject: IPyObject);
begin
  if assigned(Py_ReprLeave) and
     TPyObject.IsInitialized(aPyObject) then
    Py_ReprLeave(aPyObject.PyObject);
end;

class function TPy.CompileString(const str, filename: string; start: integer): IPyObject;
var
  TempString, TempFilename : AnsiString;
begin
  if assigned(Py_CompileString) then
    begin
      TempString   := StringToPyUTF8(str);
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(Py_CompileString(PAnsiChar(TempString), PAnsiChar(TempFilename), start));
    end
   else
    Result := nil;
end;

class function TPy.CompileStringExFlags(const str, filename: string; start: integer; flags: PPyCompilerFlags; optimize: integer): IPyObject;
var
  TempString, TempFilename : AnsiString;
begin
  if assigned(Py_CompileStringExFlags) then
    begin
      TempString   := StringToPyUTF8(str);
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(Py_CompileStringExFlags(PAnsiChar(TempString), PAnsiChar(TempFilename), start, flags, optimize));
    end
   else
    Result := nil;
end;

class function TPy.CompileStringObject(const str: string; const filename: IPyObject; start: integer; flags: PPyCompilerFlags; optimize: integer): IPyObject;
var
  TempString : AnsiString;
begin
  if assigned(Py_CompileStringObject) and
     TPyObject.IsInitialized(filename) then
    begin
      TempString := StringToPyUTF8(str);
      Result     := TPyObject.Wrap(Py_CompileStringObject(PAnsiChar(TempString), filename.PyObject, start, flags, optimize));
    end
   else
    Result := nil;
end;

class function TPy.CompileStringFlags(const str, filename: string; start: integer; flags: PPyCompilerFlags): IPyObject;
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

class function TPy.NewInterpreter: PPyThreadState;
class procedure TPy.EndInterpreter(threadstate: PPyThreadState);
class function TPy.AtExit(proc: AtExitProc): boolean;
class procedure TPy.Exit(i: Integer);
class function TPy.Main(argc: integer; argv: PPWCharT): integer;
class function TPy.BytesMain(argc: integer; argv: PPAnsiChar): integer;

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

class function TPy.PreInitialize(src_config: PPyPreConfig): PyStatus;
class function TPy.PreInitializeFromBytesArgs(src_config: PPyPreConfig; argc: Py_ssize_t; argv: PPAnsiChar): PyStatus;
class function TPy.PreInitializeFromArgs(src_config: PPyPreConfig; argc: Py_ssize_t; argv: PPWCharT): PyStatus;
class function TPy.RunMain: integer;
class procedure TPy.ExitStatusException(err: PyStatus);
class function TPy.FdIsInteractive(file_: PFILE; const str: string): boolean;
class function TPy.NewInterpreterFromConfig(var tstate: PPyThreadState; config: PPyInterpreterConfig): PyStatus;

  Py_NewInterpreter                              : function(): PPyThreadState; cdecl;
  Py_EndInterpreter                              : procedure(threadstate: PPyThreadState); cdecl;
  Py_AtExit                                      : function(proc: AtExitProc): integer; cdecl;
  Py_Exit                                        : procedure(i: Integer); cdecl;
  Py_Main                                        : function(argc: integer; argv: PPWCharT): integer; cdecl;
  Py_BytesMain                                   : function(argc: integer; argv: PPAnsiChar): integer; cdecl;
  Py_PreInitialize                               : function(src_config: PPyPreConfig): PyStatus; cdecl;
  Py_PreInitializeFromBytesArgs                  : function(src_config: PPyPreConfig; argc: Py_ssize_t; argv: PPAnsiChar): PyStatus; cdecl;
  Py_PreInitializeFromArgs                       : function(src_config: PPyPreConfig; argc: Py_ssize_t; argv: PPWCharT): PyStatus; cdecl;
  Py_RunMain                                     : function(): integer; cdecl;
  Py_ExitStatusException                         : procedure(err: PyStatus); cdecl;
  Py_FdIsInteractive                             : function(file_: PFILE; const str: PAnsiChar): integer; cdecl;
  Py_NewInterpreterFromConfig                    : function(var tstate: PPyThreadState; config: PPyInterpreterConfig): PyStatus; cdecl;

end.
