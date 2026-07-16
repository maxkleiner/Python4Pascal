unit uP4P.Interfaces;

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
  uP4P.Types;

type
  IPyObject = interface;
  IPyStatus = interface;
  IPyInitConfig = interface;
  IPyPreConfig = interface;
  IPyConfig = interface;
  IPyMutex = interface;
  IPyCriticalSection = interface;
  IPyCriticalSection2 = interface;
  IPyLongExport = interface;
  IPyLongWriter = interface;
  IPyInterpreterConfig = interface;
  IPyInterpreterState = interface;
  IPyThreadState = interface;
  IPyGILState = interface;
  IPyThreadLock = interface;
  IPyThreadTSS = interface;

  // custom IPyObject array type
  IPyObjectArray = array of IPyObject;

  IPyObject = interface
    ['{22FC7944-7F88-4638-ADD4-F029A356D81B}']
    function  GetPyObject: PPyObject;
    function  GetInitialized: boolean;
    function  GetRefCnt: integer;
    function  GetObjRefOwner: boolean;
    function  GetPyTypeObject: PPyTypeObject;
    function  GetTypeData(const cls: PyTypeObject): Pointer;
    function  GetAsString: string;
    function  GetAsAnsiString: AnsiString;
    function  GetAsWideString: WideString;
    function  GetAsInteger: C_Long;
    function  GetAsCardinal: C_ULong;
    function  GetAsInt64: Int64;
    function  GetAsUInt64: uint64;
    function  GetAsDouble: double;
    function  GetAsDateTime: TDateTime;
    function  GetAsVariant: Variant;
    function  GetIsCallable: boolean;
    function  GetIsTuple: boolean;
    function  GetIsList: boolean;
    function  GetIsSequence: boolean;
    function  GetIsMapping: boolean;
    function  GetIsFloat: boolean;
    function  GetIsLong: boolean;
    function  GetIsBool: boolean;
    function  GetIsUnicode: boolean;
    function  GetIsBytes: boolean;
    procedure SetObjRefOwner(aValue: boolean);
    procedure SetPyObject(aValue: PPyObject);
    function  IsTrueSingleton: boolean;
    function  IsFalseSingleton: boolean;
    function  IsNoneSingleton: boolean;
    procedure IncRef;
    procedure DecRef;
    function  NewRef: Pointer;
    function  XNewRef: Pointer;
    function  SameAs(const other: IPyObject): boolean; overload;
    function  SameAs(const other: PPyObject): boolean; overload;
    function  IsType(aPyTypeObject: PPyTypeObject): boolean;
    function  TypeCheck(aPyTypeObject: PPyTypeObject): boolean;
    procedure InitPyObject;
    function  IsInstance(const cls: IPyObject): integer;
    function  IsSubclass(const cls: IPyObject): integer;
    function  GenericGetDict(context: Pointer): IPyObject;
    function  CheckBuffer: boolean;
    function  GetBuffer(var view: Py_buffer; flags: Integer): boolean;
    function  CopyData(const src: IPyObject): boolean;
    function  Repr: IPyObject;
    function  Str: IPyObject;
    function  ASCII: IPyObject;
    function  Bytes: IPyObject;
    function  RichCompare(const obj: IPyObject; opid: integer): IPyObject;
    function  RichCompareBool(const obj: IPyObject; opid: integer): integer;
    function  GetAttrString(const attr_name: string): IPyObject;
    function  GetAttrString2(const attr_name: string): Pointer;
    function  SetAttrString(const attr_name: string; const value: IPyObject): boolean;
    function  SetAttrString2(const attr_name: string; value: Pointer): boolean;
    function  DelAttrString(const attr_name: string): boolean;
    function  HasAttrString(const attr_name: string): boolean;
    function  GetAttr(const attr_name: IPyObject): IPyObject;
    function  GetAttr2(const attr_name: IPyObject): Pointer;
    function  GetOptionalAttr(const attr_name: IPyObject; out result_: IPyObject): boolean;
    function  GetOptionalAttr2(const attr_name: IPyObject; out result_: Pointer): boolean;
    function  GetOptionalAttrString(const attr_name: string; out result_: IPyObject): boolean;
    function  GetOptionalAttrString2(const attr_name: string; out result_: Pointer): boolean;
    function  GetAttrAsInteger(const attr_name: string; out result_: integer): boolean;
    function  GetAttrAsString(const attr_name: string; out result_: string): boolean;
    function  SetAttr(const attr_name, value: IPyObject): boolean;
    function  SetAttr2(const attr_name: IPyObject; value: Pointer): boolean;
    function  DelAttr(const attr_name: IPyObject): boolean;
    function  HasAttr(const attr_name: IPyObject): boolean;
    function  HasAttrWithError(const attr_name: IPyObject): integer;
    function  HasAttrStringWithError(const attr_name: string): integer;
    function  SelfIter: IPyObject;
    function  GenericGetAttr(const name_: IPyObject): IPyObject;
    function  GenericGetAttr2(const name_: IPyObject): Pointer;
    function  GenericSetAttr(const name_, value: IPyObject): boolean;
    function  GenericSetAttr2(const name_: IPyObject; value: Pointer): boolean;
    function  GenericSetDict(const value: IPyObject; context: Pointer): boolean;
    function  Hash: Py_hash_t;
    function  HashNotImplemented: Py_hash_t;
    function  IsTrue: integer;
    function  Not_: integer;
    procedure ClearWeakRefs;
    function  Dir: IPyObject;
    function  ReprEnter: boolean;
    procedure ReprLeave;
    function  Print(file_: PFILE; flags: integer): boolean;
    procedure CallFinalizer;
    function  CallFinalizerFromDealloc: boolean;
    function  GetItemData: Pointer;
    function  VisitManagedDict(visit: visitproc; arg: Pointer): integer;
    procedure ClearManagedDict;
    procedure GC_Track;
    procedure GC_UnTrack;
    function  GC_IsTracked: boolean;
    function  GC_IsFinalized: boolean;
    function  IS_GC: boolean;
    function  GenericHash: Py_hash_t;
    function  AsFileDescriptor: integer;
    function  Type_: IPyObject;
    function  Size: Py_ssize_t;
    function  Length: Py_ssize_t;
    function  GetItem(const key: IPyObject): IPyObject; overload;
    function  GetItem(const key: TVarData): IPyObject; overload;
    function  SetItem(const key, v: IPyObject): boolean; overload;
    function  SetItem(const key, v: TVarData): boolean; overload;
    function  DelItemString(const key: string): boolean;
    function  DelItem(const key: IPyObject): boolean; overload;
    function  DelItem(const key: TVarData): boolean; overload;
    function  Format(const format_spec: IPyObject): IPyObject;
    function  GetIter: IPyObject;
    function  GetAIter: IPyObject;
    function  LengthHint(defaultvalue: Py_ssize_t): Py_ssize_t;
    function  CallNoArgs: IPyObject;
    function  Call(const args, kwargs: IPyObject): IPyObject;
    function  CallObject(const args: IPyObject): IPyObject;
    function  Vectorcall(const args: IPyObjectArray; const kwnames: IPyObject): IPyObject;
    function  VectorcallDict(const args: IPyObjectArray; const kwargs: IPyObject): IPyObject;
    function  CallOneArg(const arg: IPyObject): IPyObject;
    function  CastValueAsVariant: Variant;
    function  UnWrap: Pointer;

    property Initialized   : boolean         read GetInitialized;
    property PyObject      : PPyObject       read GetPyObject        write SetPyObject;
    property ObjRefOwner   : boolean         read GetObjRefOwner     write SetObjRefOwner;
    property RefCnt        : integer         read GetRefCnt;
    property PyTypeObject  : PPyTypeObject   read GetPyTypeObject;
    property AsString      : string          read GetAsString;
    property AsAnsiString  : AnsiString      read GetAsAnsiString;
    property AsWideString  : WideString      read GetAsWideString;
    property AsInteger     : C_Long          read GetAsInteger;
    property AsCardinal    : C_ULong         read GetAsCardinal;
    property AsInt64       : int64           read GetAsInt64;
    property AsUInt64      : uint64          read GetAsUInt64;
    property AsDouble      : double          read GetAsDouble;
    property AsDateTime    : TDateTime       read GetAsDateTime;
    property AsVariant     : Variant         read GetAsVariant;
    property IsCallable    : boolean         read GetIsCallable;
    property IsTuple       : boolean         read GetIsTuple;
    property IsList        : boolean         read GetIsList;
    property IsSequence    : boolean         read GetIsSequence;
    property IsMapping     : boolean         read GetIsMapping;
    property IsFloat       : boolean         read GetIsFloat;
    property IsLong        : boolean         read GetIsLong;
    property IsBool        : boolean         read GetIsBool;
    property IsUnicode     : boolean         read GetIsUnicode;
    property IsBytes       : boolean         read GetIsBytes;
  end;

  IPyLongExport = interface
    ['{D4A8D7E9-4297-4363-A17B-A60F892E6DB8}']
    function GetLongExport: PPyLongExport;
    function GetValue: int64;
    function GetNegative: byte;
    function GetNdigits: Py_ssize_t;
    function GetDigits: Pointer;

    property LongExport : PPyLongExport read GetLongExport;
    property Value      : int64         read GetValue;
    property Negative   : byte          read GetNegative;
    property Ndigits    : Py_ssize_t    read GetNdigits;
    property Digits     : Pointer       read GetDigits;
  end;

  IPyLongWriter = interface
    ['{AB597432-E9BD-44E7-A8ED-9ECAAC43C811}']
    function GetInitialized: boolean;
    function Finish: IPyObject;
    procedure Discard;
    property Initialized : boolean read GetInitialized;
  end;

  IPyUnicodeWriter = interface
    ['{BA3439F6-DE14-4561-AAE8-A638BCBEA809}']
    function  GetInitialized: boolean;
    procedure Discard;
    function  Finish: IPyObject;
    function  WriteChar(ch: Py_UCS4): boolean;
    function  WriteUTF8(const str: PAnsiChar; size_: Py_ssize_t): boolean;
    function  WriteASCII(const str: PAnsiChar; size_: Py_ssize_t): boolean;
    function  WriteWideChar(const str: PWCharT; size_: Py_ssize_t): boolean;
    function  WriteUCS4(str: PPy_UCS4; size_: Py_ssize_t): boolean;
    function  WriteStr(const obj: IPyObject): boolean;
    function  WriteRepr(const obj: IPyObject): boolean;
    function  WriteSubstring(str: PPyObject; start, end_: Py_ssize_t): boolean;
    function  DecodeUTF8Stateful(const string_: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): boolean;

    property Initialized  : boolean           read GetInitialized;
  end;

  IPyStatus = interface
    ['{C7582FA6-89AA-49E9-84E3-B100E272D872}']
    function  GetStatus: PyStatus;
    function  GetFunc: string;
    function  GetErrMsg: string;
    function  GetExitCode: integer;
    function  GetIsException: boolean;
    function  GetIsError: boolean;
    function  GetIsExit: boolean;
    procedure ExitStatusException;

    property func        : string    read GetFunc;
    property ErrMsg      : string    read GetErrMsg;
    property ExitCode    : integer   read GetExitCode;
    property IsException : boolean   read GetIsException;
    property IsError     : boolean   read GetIsError;
    property IsExit      : boolean   read GetIsExit;
    property Status      : PyStatus  read GetStatus;
  end;

  /// <summary>
  /// Interface containing most parameters to configure a sub-interpreter. Its values are used only in TPy.NewInterpreterFromConfig() and never modified by the runtime.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/subinterpreters.html">See the Multiple interpreters in a Python process article.</see></para>
  /// <para>Implemented by TPyInterpreterConfig</para>
  /// </remarks>
  IPyInterpreterConfig = interface
    ['{E188197E-2A57-4466-9018-DF0534D96BD1}']
    function GetConfig: Pointer;
    function Get_use_main_obmalloc: boolean;
    function Get_allow_fork: boolean;
    function Get_allow_exec: boolean;
    function Get_allow_threads: boolean;
    function Get_allow_daemon_threads: boolean;
    function Get_check_multi_interp_extensions: boolean;
    function Get_gil: TPyInterpreterCfgGIL;
    procedure Set_use_main_obmalloc(aValue: boolean);
    procedure Set_allow_fork(aValue: boolean);
    procedure Set_allow_exec(aValue: boolean);
    procedure Set_allow_threads(aValue: boolean);
    procedure Set_allow_daemon_threads(aValue: boolean);
    procedure Set_check_multi_interp_extensions(aValue: boolean);
    procedure Set_gil(aValue: TPyInterpreterCfgGIL);
    /// <summary>
    /// Initial configuration values defined by the _PyInterpreterConfig_INIT macro.
    /// </summary>
    procedure Init;
    /// <summary>
    /// Pointer to PyInterpreterConfig.
    /// </summary>
    property Config                        : Pointer                  read GetConfig;
    /// <summary>
    /// If this is False then the sub-interpreter will use its own “object” allocator state.
    /// Otherwise it will use (share) the main interpreter's.
    /// If this is False then check_multi_interp_extensions must be True. If this is True then gil must not be gilOwn.
    /// </summary>
    property use_main_obmalloc             : boolean                  read Get_use_main_obmalloc              write Set_use_main_obmalloc;
    /// <summary>
    /// If this is False then the runtime will not support forking the process in any thread where the sub-interpreter is currently active.
    /// Otherwise fork is unrestricted.
    /// Note that the subprocess module still works when fork is disallowed.
    /// </summary>
    property allow_fork                    : boolean                  read Get_allow_fork                     write Set_allow_fork;
    /// <summary>
    /// If this is False then the runtime will not support replacing the current process via exec (e.g. os.execv()) in any thread where the sub-interpreter is currently active.
    /// Otherwise exec is unrestricted.
    /// Note that the subprocess module still works when exec is disallowed.
    /// </summary>
    property allow_exec                    : boolean                  read Get_allow_exec                     write Set_allow_exec;
    /// <summary>
    /// If this is False then the sub-interpreter's threading module won’t create threads.
    /// Otherwise threads are allowed.
    /// </summary>
    property allow_threads                 : boolean                  read Get_allow_threads                  write Set_allow_threads;
    /// <summary>
    /// If this is False then the sub-interpreter's threading module won’t create daemon threads.
    /// Otherwise daemon threads are allowed (as long as allow_threads is non-zero).
    /// </summary>
    property allow_daemon_threads          : boolean                  read Get_allow_daemon_threads           write Set_allow_daemon_threads;
    /// <summary>
    /// If this is False then all extension modules may be imported, including legacy (single-phase init) modules, in any thread where the sub-interpreter is currently active.
    /// Otherwise only multi-phase init extension modules (see PEP 489) may be imported. (Also see Py_mod_multiple_interpreters.)
    /// This must be True if use_main_obmalloc is True.
    /// </summary>
    property check_multi_interp_extensions : boolean                  read Get_check_multi_interp_extensions  write Set_check_multi_interp_extensions;
    /// <summary>
    /// <para>This determines the operation of the GIL for the sub-interpreter. It may be one of the following:</para>
    /// <code>
    /// - gilDefault: Use the default selection (gilShared).
    /// - gilShared: Use (share) the main interpreter's GIL.
    /// - gilOwn: Use the sub-interpreter's own GIL.
    /// </code>
    /// <para>If this is gilOwn then use_main_obmalloc must be False.</para>
    /// </summary>
    property gil                           : TPyInterpreterCfgGIL     read Get_gil                            write Set_gil;
  end;

  IPyInterpreterState = interface
    ['{26733A3F-135C-4889-BBA0-84B78764EA94}']
    function  GetInitialized: boolean;
    function  GetState: PPyInterpreterState;
    function  GetID: int64;
    function  GetDict: IPyObject;
    procedure SetState(aState: PPyInterpreterState);
    procedure Clear;
    procedure Delete;
    function  Next: IPyInterpreterState;
    function  ThreadHead: IPyThreadState;

    property Initialized  : boolean               read GetInitialized;
    property State        : PPyInterpreterState   read GetState         write SetState;
    property ID           : int64                 read GetID;
    property Dict         : IPyObject             read GetDict;
  end;

  IPyThreadState = interface
    ['{0C8502D8-C0EF-4F8E-A7B3-42AB050BA121}']
    function  GetInitialized: boolean;
    function  GetThreadState: PPyThreadState;
    function  GetID: int64;
    function  GetDict: IPyObject;
    function  GetInterpreter: IPyInterpreterState;
    function  GetFrame: IPyObject;
    procedure SetThreadState(aThreadState: PPyThreadState);
    procedure Clear;
    procedure Delete;
    function  SetAsyncExc(id: C_ULong; const exc: IPyObject): integer;
    procedure EnterTracing;
    procedure LeaveTracing;
    function  Swap: IPyThreadState;
    function  Next: IPyThreadState;
    function  UnWrap: Pointer;

    property Initialized  : boolean               read GetInitialized;
    property ThreadState  : PPyThreadState        read GetThreadState         write SetThreadState;
    property ID           : int64                 read GetID;
    property Dict         : IPyObject             read GetDict;
    property Interpreter  : IPyInterpreterState   read GetInterpreter;
    property Frame        : IPyObject             read GetFrame;
  end;

  IPyGILState = interface
    ['{FA7CC9AD-C157-4070-B577-8C08DFAB41C4}']
    function  GetInitialized: boolean;
    function  GetState: PyGILState_STATE;
    procedure SetInitialized(aValue: boolean);
    procedure SetState(aState: PyGILState_STATE);
    procedure Release;

    property Initialized  : boolean           read GetInitialized   write SetInitialized;
    property State        : PyGILState_STATE  read GetState         write SetState;
  end;

  IPyThreadLock = interface
    ['{A39E9504-264D-4648-92D6-F6FD54F16FA5}']
    function  GetInitialized: boolean;
    function  GetLock: PyThread_type_lock;
    procedure AllocateLock;
    procedure FreeLock;
    function  AcquireLock(waitflag: boolean): PyLockStatus;
    function  AcquireLockTimed(microseconds: PY_TIMEOUT_T; intr_flag: boolean): PyLockStatus;
    procedure ReleaseLock;

    property Initialized : boolean              read GetInitialized;
    property Lock        : PyThread_type_lock   read GetLock;
  end;

  IPyThreadTSS = interface
    ['{5F88B7E1-C685-492E-A829-35EF92288C9E}']
    function  GetInitialized: boolean;
    function  GetKey: PPy_tss_t;
    function  GetIsCreated: boolean;
    function  GetValue: pointer;
    procedure SetValue(value: pointer);
    procedure TSSAlloc;
    procedure TSSFree;
    function  TSSCreate: boolean;
    procedure TSSDelete;

    property Initialized : boolean     read GetInitialized;
    property Key         : PPy_tss_t   read GetKey;
    property IsCreated   : boolean     read GetIsCreated;
    property Value       : pointer     read GetValue        write SetValue;
  end;

  IPyInitConfig = interface
    ['{7978019A-332B-433C-9376-1C35A737B47D}']
    function GetConfig: Pointer;
    function GetInitialized: boolean;
    function GetError: string;
    function GetExitCode: integer;
    function Get_allocator: PyMemAllocatorName;
    function Get_argv: string;
    function Get_base_exec_prefix: string;
    function Get_base_executable: string;
    function Get_base_prefix: string;
    function Get_buffered_stdio: boolean;
    function Get_bytes_warning: int64;
    function Get_check_hash_pycs_mode: string;
    function Get_code_debug_ranges: boolean;
    function Get_coerce_c_locale: integer;
    function Get_coerce_c_locale_warn: boolean;
    function Get_configure_c_stdio: boolean;
    function Get_configure_locale: boolean;
    function Get_cpu_count: int64;
    function Get_dev_mode: boolean;
    function Get_dump_refs: boolean;
    function Get_dump_refs_file: string;
    function Get_exec_prefix: string;
    function Get_executable: string;
    function Get_faulthandler: int64;
    function Get_filesystem_encoding: string;
    function Get_filesystem_errors: string;
    function Get_hash_seed: int64;
    function Get_home: string;
    function Get_import_time: int64;
    function Get_inspect: boolean;
    function Get_install_signal_handlers: boolean;
    function Get_int_max_str_digits: int64;
    function Get_interactive: boolean;
    function Get_isolated: boolean;
    function Get_legacy_windows_fs_encoding: boolean;
    function Get_legacy_windows_stdio: boolean;
    function Get_malloc_stats: boolean;
    function Get_module_search_paths: string;
    function Get_optimization_level: TPyOptimizationLevel;
    function Get_orig_argv: string;
    function Get_parse_argv: boolean;
    function Get_parser_debug: boolean;
    function Get_pathconfig_warnings: boolean;
    function Get_perf_profiling: int64;
    function Get_platlibdir: string;
    function Get_prefix: string;
    function Get_program_name: string;
    function Get_pycache_prefix: string;
    function Get_quiet: boolean;
    function Get_run_command: string;
    function Get_run_filename: string;
    function Get_run_module: string;
    function Get_run_presite: string;
    function Get_safe_path: boolean;
    function Get_show_ref_count: boolean;
    function Get_site_import: boolean;
    function Get_skip_source_first_line: boolean;
    function Get_stdio_encoding: string;
    function Get_stdio_errors: string;
    function Get_stdlib_dir: string;
    function Get_tracemalloc: int64;
    function Get_use_environment: boolean;
    function Get_use_frozen_modules: boolean;
    function Get_use_hash_seed: boolean;
    function Get_use_system_logger: boolean;
    function Get_user_site_directory: boolean;
    function Get_utf8_mode: integer;
    function Get_verbose: TPyVerboseMode;
    function Get_warn_default_encoding: boolean;
    function Get_warnoptions: string;
    function Get_write_bytecode: boolean;
    function Get_xoptions: string;

    procedure Set_allocator(aValue: PyMemAllocatorName);
    procedure Set_argv(const aValue: string);
    procedure Set_base_exec_prefix(const aValue: string);
    procedure Set_base_executable(const aValue: string);
    procedure Set_base_prefix(const aValue: string);
    procedure Set_buffered_stdio(aValue: boolean);
    procedure Set_bytes_warning(aValue: int64);
    procedure Set_check_hash_pycs_mode(const aValue: string);
    procedure Set_code_debug_ranges(aValue: boolean);
    procedure Set_coerce_c_locale(aValue: integer);
    procedure Set_coerce_c_locale_warn(aValue: boolean);
    procedure Set_configure_c_stdio(aValue: boolean);
    procedure Set_configure_locale(aValue: boolean);
    procedure Set_cpu_count(aValue: int64);
    procedure Set_dev_mode(aValue: boolean);
    procedure Set_dump_refs(aValue: boolean);
    procedure Set_dump_refs_file(const aValue: string);
    procedure Set_exec_prefix(const aValue: string);
    procedure Set_executable(const aValue: string);
    procedure Set_faulthandler(aValue: int64);
    procedure Set_filesystem_encoding(const aValue: string);
    procedure Set_filesystem_errors(const aValue: string);
    procedure Set_hash_seed(aValue: int64);
    procedure Set_home(const aValue: string);
    procedure Set_import_time(aValue: int64);
    procedure Set_inspect(aValue: boolean);
    procedure Set_install_signal_handlers(aValue: boolean);
    procedure Set_int_max_str_digits(aValue: int64);
    procedure Set_interactive(aValue: boolean);
    procedure Set_isolated(aValue: boolean);
    procedure Set_legacy_windows_fs_encoding(aValue: boolean);
    procedure Set_legacy_windows_stdio(aValue: boolean);
    procedure Set_malloc_stats(aValue: boolean);
    procedure Set_module_search_paths(const aValue: string);
    procedure Set_optimization_level(aValue: TPyOptimizationLevel);
    procedure Set_orig_argv(const aValue: string);
    procedure Set_parse_argv(aValue: boolean);
    procedure Set_parser_debug(aValue: boolean);
    procedure Set_pathconfig_warnings(aValue: boolean);
    procedure Set_perf_profiling(aValue: int64);
    procedure Set_platlibdir(const aValue: string);
    procedure Set_prefix(const aValue: string);
    procedure Set_program_name(const aValue: string);
    procedure Set_pycache_prefix(const aValue: string);
    procedure Set_quiet(aValue: boolean);
    procedure Set_run_command(const aValue: string);
    procedure Set_run_filename(const aValue: string);
    procedure Set_run_module(const aValue: string);
    procedure Set_run_presite(const aValue: string);
    procedure Set_safe_path(aValue: boolean);
    procedure Set_show_ref_count(aValue: boolean);
    procedure Set_site_import(aValue: boolean);
    procedure Set_skip_source_first_line(aValue: boolean);
    procedure Set_stdio_encoding(const aValue: string);
    procedure Set_stdio_errors(const aValue: string);
    procedure Set_stdlib_dir(const aValue: string);
    procedure Set_tracemalloc(aValue: int64);
    procedure Set_use_environment(aValue: boolean);
    procedure Set_use_frozen_modules(aValue: boolean);
    procedure Set_use_hash_seed(aValue: boolean);
    procedure Set_use_system_logger(aValue: boolean);
    procedure Set_user_site_directory(aValue: boolean);
    procedure Set_utf8_mode(aValue: integer);
    procedure Set_verbose(aValue: TPyVerboseMode);
    procedure Set_warn_default_encoding(aValue: boolean);
    procedure Set_warnoptions(const aValue: string);
    procedure Set_write_bytecode(aValue: boolean);
    procedure Set_xoptions(const aValue: string);

    function HasOption(const aOption: string): boolean;
    function GetInt(const aName: string; var aValue: int64): boolean;
    function GetStr(const aName: string; var aValue: string): boolean;
    function GetStrList(const aName: string; var aItems: TStringList): boolean;
    function SetInt(const aName: string; aValue: int64): boolean;
    function SetStr(const aName, aValue: string): boolean;
    function SetStrList(const aName: string; const aItems: TStringList): boolean;
    function AddModule(const aName: string; initfunc_: initfunc): boolean;

    property Initialized                : boolean                read GetInitialized;
    property Config                     : Pointer                read GetConfig;
    property Error                      : string                 read GetError;
    property ExitCode                   : integer                read GetExitCode;

    property allocator                  : PyMemAllocatorName     read Get_allocator                      write Set_allocator;
    property argv                       : string                 read Get_argv                           write Set_argv;
    property base_exec_prefix           : string                 read Get_base_exec_prefix               write Set_base_exec_prefix;
    property base_executable            : string                 read Get_base_executable                write Set_base_executable;
    property base_prefix                : string                 read Get_base_prefix                    write Set_base_prefix;
    property buffered_stdio             : boolean                read Get_buffered_stdio                 write Set_buffered_stdio;
    property bytes_warning              : int64                  read Get_bytes_warning                  write Set_bytes_warning;
    property check_hash_pycs_mode       : string                 read Get_check_hash_pycs_mode           write Set_check_hash_pycs_mode;
    property code_debug_ranges          : boolean                read Get_code_debug_ranges              write Set_code_debug_ranges;
    property coerce_c_locale            : integer                read Get_coerce_c_locale                write Set_coerce_c_locale;
    property coerce_c_locale_warn       : boolean                read Get_coerce_c_locale_warn           write Set_coerce_c_locale_warn;
    property configure_c_stdio          : boolean                read Get_configure_c_stdio              write Set_configure_c_stdio;
    property configure_locale           : boolean                read Get_configure_locale               write Set_configure_locale;
    property cpu_count                  : int64                  read Get_cpu_count                      write Set_cpu_count;
    property dev_mode                   : boolean                read Get_dev_mode                       write Set_dev_mode;
    property dump_refs                  : boolean                read Get_dump_refs                      write Set_dump_refs;
    property dump_refs_file             : string                 read Get_dump_refs_file                 write Set_dump_refs_file;
    property exec_prefix                : string                 read Get_exec_prefix                    write Set_exec_prefix;
    property executable                 : string                 read Get_executable                     write Set_executable;
    property faulthandler               : int64                  read Get_faulthandler                   write Set_faulthandler;
    property filesystem_encoding        : string                 read Get_filesystem_encoding            write Set_filesystem_encoding;
    property filesystem_errors          : string                 read Get_filesystem_errors              write Set_filesystem_errors;
    property hash_seed                  : int64                  read Get_hash_seed                      write Set_hash_seed;
    property home                       : string                 read Get_home                           write Set_home;
    property import_time                : int64                  read Get_import_time                    write Set_import_time;
    property inspect                    : boolean                read Get_inspect                        write Set_inspect;
    property install_signal_handlers    : boolean                read Get_install_signal_handlers        write Set_install_signal_handlers;
    property int_max_str_digits         : int64                  read Get_int_max_str_digits             write Set_int_max_str_digits;
    property interactive                : boolean                read Get_interactive                    write Set_interactive;
    property isolated                   : boolean                read Get_isolated                       write Set_isolated;
    property legacy_windows_fs_encoding : boolean                read Get_legacy_windows_fs_encoding     write Set_legacy_windows_fs_encoding;
    property legacy_windows_stdio       : boolean                read Get_legacy_windows_stdio           write Set_legacy_windows_stdio;
    property malloc_stats               : boolean                read Get_malloc_stats                   write Set_malloc_stats;
    property module_search_paths        : string                 read Get_module_search_paths            write Set_module_search_paths;
    property optimization_level         : TPyOptimizationLevel   read Get_optimization_level             write Set_optimization_level;
    property orig_argv                  : string                 read Get_orig_argv                      write Set_orig_argv;
    property parse_argv                 : boolean                read Get_parse_argv                     write Set_parse_argv;
    property parser_debug               : boolean                read Get_parser_debug                   write Set_parser_debug;
    property pathconfig_warnings        : boolean                read Get_pathconfig_warnings            write Set_pathconfig_warnings;
    property perf_profiling             : int64                  read Get_perf_profiling                 write Set_perf_profiling;
    property platlibdir                 : string                 read Get_platlibdir                     write Set_platlibdir;
    property prefix                     : string                 read Get_prefix                         write Set_prefix;
    property program_name               : string                 read Get_program_name                   write Set_program_name;
    property pycache_prefix             : string                 read Get_pycache_prefix                 write Set_pycache_prefix;
    property quiet                      : boolean                read Get_quiet                          write Set_quiet;
    property run_command                : string                 read Get_run_command                    write Set_run_command;
    property run_filename               : string                 read Get_run_filename                   write Set_run_filename;
    property run_module                 : string                 read Get_run_module                     write Set_run_module;
    property run_presite                : string                 read Get_run_presite                    write Set_run_presite;
    property safe_path                  : boolean                read Get_safe_path                      write Set_safe_path;
    property show_ref_count             : boolean                read Get_show_ref_count                 write Set_show_ref_count;
    property site_import                : boolean                read Get_site_import                    write Set_site_import;
    property skip_source_first_line     : boolean                read Get_skip_source_first_line         write Set_skip_source_first_line;
    property stdio_encoding             : string                 read Get_stdio_encoding                 write Set_stdio_encoding;
    property stdio_errors               : string                 read Get_stdio_errors                   write Set_stdio_errors;
    property stdlib_dir                 : string                 read Get_stdlib_dir                     write Set_stdlib_dir;
    property tracemalloc                : int64                  read Get_tracemalloc                    write Set_tracemalloc;
    property use_environment            : boolean                read Get_use_environment                write Set_use_environment;
    property use_frozen_modules         : boolean                read Get_use_frozen_modules             write Set_use_frozen_modules;
    property use_hash_seed              : boolean                read Get_use_hash_seed                  write Set_use_hash_seed;
    property use_system_logger          : boolean                read Get_use_system_logger              write Set_use_system_logger;
    property user_site_directory        : boolean                read Get_user_site_directory            write Set_user_site_directory;
    property utf8_mode                  : integer                read Get_utf8_mode                      write Set_utf8_mode;
    property verbose                    : TPyVerboseMode         read Get_verbose                        write Set_verbose;
    property warn_default_encoding      : boolean                read Get_warn_default_encoding          write Set_warn_default_encoding;
    property warnoptions                : string                 read Get_warnoptions                    write Set_warnoptions;
    property write_bytecode             : boolean                read Get_write_bytecode                 write Set_write_bytecode;
    property xoptions                   : string                 read Get_xoptions                       write Set_xoptions;
  end;

  IPyPreConfig = interface
    ['{53194E16-1452-46CF-AA81-11E7D2F179A1}']
    function GetConfig: Pointer;
    function GetInitialized: boolean;
    function Get_parse_argv: boolean;
    function Get_isolated: boolean;
    function Get_use_environment: boolean;
    function Get_configure_locale: boolean;
    function Get_coerce_c_locale: integer;
    function Get_coerce_c_locale_warn: boolean;
    function Get_legacy_windows_fs_encoding: boolean;
    function Get_utf8_mode: integer;
    function Get_dev_mode: boolean;
    function Get_allocator: PyMemAllocatorName;

    procedure InitPythonConfig;
    procedure InitIsolatedConfig;

    property Config                     : Pointer            read GetConfig;
    property Initialized                : boolean            read GetInitialized;
    property parse_argv                 : boolean            read Get_parse_argv;
    property isolated                   : boolean            read Get_isolated;
    property use_environment            : boolean            read Get_use_environment;
    property configure_locale           : boolean            read Get_configure_locale;
    property coerce_c_locale            : integer            read Get_coerce_c_locale;
    property coerce_c_locale_warn       : boolean            read Get_coerce_c_locale_warn;
    property legacy_windows_fs_encoding : boolean            read Get_legacy_windows_fs_encoding;
    property utf8_mode                  : integer            read Get_utf8_mode;
    property dev_mode                   : boolean            read Get_dev_mode;
    property allocator                  : PyMemAllocatorName read Get_allocator;
  end;

  IPyConfig = interface
    ['{1BA914A8-FFF7-4F49-AA5A-95808CCF8AFB}']
    function GetConfig: Pointer;
    function Get_argv: string;
    function Get_base_exec_prefix: string;
    function Get_base_executable: string;
    function Get_base_prefix: string;
    function Get_buffered_stdio: boolean;
    function Get_bytes_warning: integer;
    function Get_check_hash_pycs_mode: string;
    function Get_code_debug_ranges: boolean;
    function Get_configure_c_stdio: boolean;
    function Get_context_aware_warnings: boolean;
    function Get_cpu_count: integer;
    function Get_dev_mode: boolean;
    function Get_dump_refs: boolean;
    function Get_dump_refs_file: string;
    function Get_exec_prefix: string;
    function Get_executable: string;
    function Get_faulthandler: integer;
    function Get_filesystem_encoding: string;
    function Get_filesystem_errors: string;
    function Get_hash_seed: uint64;
    function Get_home: string;
    function Get_import_time: integer;
    function Get_inspect: boolean;
    function Get_install_signal_handlers: boolean;
    function Get_int_max_str_digits: integer;
    function Get_interactive: boolean;
    function Get_isolated: boolean;
    function Get_legacy_windows_stdio: boolean;
    function Get_malloc_stats: boolean;
    function Get_module_search_paths: string;
    function Get_module_search_paths_set: boolean;
    function Get_optimization_level: TPyOptimizationLevel;
    function Get_orig_argv: string;
    function Get_parse_argv: boolean;
    function Get_parser_debug: boolean;
    function Get_pathconfig_warnings: boolean;
    function Get_perf_profiling: integer;
    function Get_platlibdir: string;
    function Get_prefix: string;
    function Get_program_name: string;
    function Get_pycache_prefix: string;
    function Get_pythonpath_env: string;
    function Get_quiet: boolean;
    function Get_remote_debug: integer;
    function Get_run_command: string;
    function Get_run_filename: string;
    function Get_run_module: string;
    function Get_safe_path: boolean;
    function Get_show_ref_count: boolean;
    function Get_site_import: boolean;
    function Get_skip_source_first_line: boolean;
    function Get_stdio_encoding: string;
    function Get_stdio_errors: string;
    function Get_stdlib_dir: string;
    function Get_sys_path_0: string;
    function Get_thread_inherit_context: boolean;
    function Get_tracemalloc: boolean;
    function Get_use_environment: boolean;
    function Get_use_frozen_modules: boolean;
    function Get_use_hash_seed: boolean;
    function Get_user_site_directory: boolean;
    function Get_verbose: TPyVerboseMode;
    function Get_warn_default_encoding: boolean;
    function Get_warnoptions: string;
    function Get_write_bytecode: boolean;
    function Get_xoptions: string;

    procedure Set_argv(const aValue: string);
    procedure Set_base_exec_prefix(const aValue: string);
    procedure Set_base_executable(const aValue: string);
    procedure Set_base_prefix(const aValue: string);
    procedure Set_buffered_stdio(aValue: boolean);
    procedure Set_bytes_warning(aValue: integer);
    procedure Set_check_hash_pycs_mode(const aValue: string);
    procedure Set_code_debug_ranges(aValue: boolean);
    procedure Set_configure_c_stdio(aValue: boolean);
    procedure Set_context_aware_warnings(aValue: boolean);
    procedure Set_cpu_count(aValue: integer);
    procedure Set_dev_mode(aValue: boolean);
    procedure Set_dump_refs(aValue: boolean);
    procedure Set_dump_refs_file(const aValue: string);
    procedure Set_exec_prefix(const aValue: string);
    procedure Set_executable(const aValue: string);
    procedure Set_faulthandler(aValue: integer);
    procedure Set_filesystem_encoding(const aValue: string);
    procedure Set_filesystem_errors(const aValue: string);
    procedure Set_hash_seed(aValue: uint64);
    procedure Set_home(const aValue: string);
    procedure Set_import_time(aValue: integer);
    procedure Set_inspect(aValue: boolean);
    procedure Set_install_signal_handlers(aValue: boolean);
    procedure Set_int_max_str_digits(aValue: integer);
    procedure Set_interactive(aValue: boolean);
    procedure Set_isolated(aValue: boolean);
    procedure Set_legacy_windows_stdio(aValue: boolean);
    procedure Set_malloc_stats(aValue: boolean);
    procedure Set_module_search_paths(const aValue: string);
    procedure Set_module_search_paths_set(aValue: boolean);
    procedure Set_optimization_level(aValue: TPyOptimizationLevel);
    procedure Set_orig_argv(const aValue: string);
    procedure Set_parse_argv(aValue: boolean);
    procedure Set_parser_debug(aValue: boolean);
    procedure Set_pathconfig_warnings(aValue: boolean);
    procedure Set_perf_profiling(aValue: integer);
    procedure Set_platlibdir(const aValue: string);
    procedure Set_prefix(const aValue: string);
    procedure Set_program_name(const aValue: string);
    procedure Set_pycache_prefix(const aValue: string);
    procedure Set_pythonpath_env(const aValue: string);
    procedure Set_quiet(aValue: boolean);
    procedure Set_remote_debug(aValue: integer);
    procedure Set_run_command(const aValue: string);
    procedure Set_run_filename(const aValue: string);
    procedure Set_run_module(const aValue: string);
    procedure Set_safe_path(aValue: boolean);
    procedure Set_show_ref_count(aValue: boolean);
    procedure Set_site_import(aValue: boolean);
    procedure Set_skip_source_first_line(aValue: boolean);
    procedure Set_stdio_encoding(const aValue: string);
    procedure Set_stdio_errors(const aValue: string);
    procedure Set_stdlib_dir(const aValue: string);
    procedure Set_sys_path_0(const aValue: string);
    procedure Set_thread_inherit_context(aValue: boolean);
    procedure Set_tracemalloc(aValue: boolean);
    procedure Set_use_environment(aValue: boolean);
    procedure Set_use_frozen_modules(aValue: boolean);
    procedure Set_use_hash_seed(aValue: boolean);
    procedure Set_user_site_directory(aValue: boolean);
    procedure Set_verbose(aValue: TPyVerboseMode);
    procedure Set_warn_default_encoding(aValue: boolean);
    procedure Set_warnoptions(const aValue: string);
    procedure Set_write_bytecode(aValue: boolean);
    procedure Set_xoptions(const aValue: string);

    function SetWCharT(var DstString: PWCharT; const SrcString: string): boolean;
    function SetString(var DstString: PWCharT; SrcString: WCharTString): IPyStatus;
    function SetBytesString(var DstString: PWCharT; SrcString: AnsiString): IPyStatus;
    function SetArgv(argc: integer; const argv: array of PWCharT): IPyStatus; overload;
    function SetArgv(const items: TStringList): boolean; overload;
    function SetBytesArgv(argc: integer; const argv: array of PAnsiChar): IPyStatus;
    function SetWideStringList(var list: PyWideStringList; length: integer; items: array of PWCharT): IPyStatus; overload;
    function SetWideStringList(var list: PyWideStringList; const items: TStringList): boolean; overload;

    /// <summary>
    /// Initialize configuration with the "Python Configuration".
    /// </summary>
    procedure InitPythonConfig;
    /// <summary>
    /// Initialize configuration with the "Isolated Configuration".
    /// </summary>
    procedure InitIsolatedConfig;
    /// <summary>
    /// Read all Python configuration.
    /// </summary>
    function  Read: IPyStatus;

    property Config                    : Pointer              read GetConfig;
    property argv                      : string               read Get_argv                         write Set_argv;
    property base_exec_prefix          : string               read Get_base_exec_prefix             write Set_base_exec_prefix;
    property base_executable           : string               read Get_base_executable              write Set_base_executable;
    property base_prefix               : string               read Get_base_prefix                  write Set_base_prefix;
    property buffered_stdio            : boolean              read Get_buffered_stdio               write Set_buffered_stdio;
    property bytes_warning             : integer              read Get_bytes_warning                write Set_bytes_warning;
    property check_hash_pycs_mode      : string               read Get_check_hash_pycs_mode         write Set_check_hash_pycs_mode;
    property code_debug_ranges         : boolean              read Get_code_debug_ranges            write Set_code_debug_ranges;
    property configure_c_stdio         : boolean              read Get_configure_c_stdio            write Set_configure_c_stdio;
    property context_aware_warnings    : boolean              read Get_context_aware_warnings       write Set_context_aware_warnings;
    property cpu_count                 : integer              read Get_cpu_count                    write Set_cpu_count;
    property dev_mode                  : boolean              read Get_dev_mode                     write Set_dev_mode;
    property dump_refs                 : boolean              read Get_dump_refs                    write Set_dump_refs;
    property dump_refs_file            : string               read Get_dump_refs_file               write Set_dump_refs_file;
    property exec_prefix               : string               read Get_exec_prefix                  write Set_exec_prefix;
    property executable                : string               read Get_executable                   write Set_executable;
    property faulthandler              : integer              read Get_faulthandler                 write Set_faulthandler;
    property filesystem_encoding       : string               read Get_filesystem_encoding          write Set_filesystem_encoding;
    property filesystem_errors         : string               read Get_filesystem_errors            write Set_filesystem_errors;
    property hash_seed                 : uint64               read Get_hash_seed                    write Set_hash_seed;
    property home                      : string               read Get_home                         write Set_home;
    property import_time               : integer              read Get_import_time                  write Set_import_time;
    property inspect                   : boolean              read Get_inspect                      write Set_inspect;
    property install_signal_handlers   : boolean              read Get_install_signal_handlers      write Set_install_signal_handlers;
    property int_max_str_digits        : integer              read Get_int_max_str_digits           write Set_int_max_str_digits;
    property interactive               : boolean              read Get_interactive                  write Set_interactive;
    property isolated                  : boolean              read Get_isolated                     write Set_isolated;
    property legacy_windows_stdio      : boolean              read Get_legacy_windows_stdio         write Set_legacy_windows_stdio;
    property malloc_stats              : boolean              read Get_malloc_stats                 write Set_malloc_stats;
    property module_search_paths       : string               read Get_module_search_paths          write Set_module_search_paths;
    property module_search_paths_set   : boolean              read Get_module_search_paths_set      write Set_module_search_paths_set;
    property optimization_level        : TPyOptimizationLevel read Get_optimization_level           write Set_optimization_level;
    property orig_argv                 : string               read Get_orig_argv                    write Set_orig_argv;
    property parse_argv                : boolean              read Get_parse_argv                   write Set_parse_argv;
    property parser_debug              : boolean              read Get_parser_debug                 write Set_parser_debug;
    property pathconfig_warnings       : boolean              read Get_pathconfig_warnings          write Set_pathconfig_warnings;
    property perf_profiling            : integer              read Get_perf_profiling               write Set_perf_profiling;
    property platlibdir                : string               read Get_platlibdir                   write Set_platlibdir;
    property prefix                    : string               read Get_prefix                       write Set_prefix;
    property program_name              : string               read Get_program_name                 write Set_program_name;
    property pycache_prefix            : string               read Get_pycache_prefix               write Set_pycache_prefix;
    property pythonpath_env            : string               read Get_pythonpath_env               write Set_pythonpath_env;
    property quiet                     : boolean              read Get_quiet                        write Set_quiet;
    property remote_debug              : integer              read Get_remote_debug                 write Set_remote_debug;
    property run_command               : string               read Get_run_command                  write Set_run_command;
    property run_filename              : string               read Get_run_filename                 write Set_run_filename;
    property run_module                : string               read Get_run_module                   write Set_run_module;
    property safe_path                 : boolean              read Get_safe_path                    write Set_safe_path;
    property show_ref_count            : boolean              read Get_show_ref_count               write Set_show_ref_count;
    property site_import               : boolean              read Get_site_import                  write Set_site_import;
    property skip_source_first_line    : boolean              read Get_skip_source_first_line       write Set_skip_source_first_line;
    property stdio_encoding            : string               read Get_stdio_encoding               write Set_stdio_encoding;
    property stdio_errors              : string               read Get_stdio_errors                 write Set_stdio_errors;
    property stdlib_dir                : string               read Get_stdlib_dir                   write Set_stdlib_dir;
    property sys_path_0                : string               read Get_sys_path_0                   write Set_sys_path_0;
    property thread_inherit_context    : boolean              read Get_thread_inherit_context       write Set_thread_inherit_context;
    property tracemalloc               : boolean              read Get_tracemalloc                  write Set_tracemalloc;
    property use_environment           : boolean              read Get_use_environment              write Set_use_environment;
    property use_frozen_modules        : boolean              read Get_use_frozen_modules           write Set_use_frozen_modules;
    property use_hash_seed             : boolean              read Get_use_hash_seed                write Set_use_hash_seed;
    property user_site_directory       : boolean              read Get_user_site_directory          write Set_user_site_directory;
    property verbose                   : TPyVerboseMode       read Get_verbose                      write Set_verbose;
    property warn_default_encoding     : boolean              read Get_warn_default_encoding        write Set_warn_default_encoding;
    property warnoptions               : string               read Get_warnoptions                  write Set_warnoptions;
    property write_bytecode            : boolean              read Get_write_bytecode               write Set_write_bytecode;
    property xoptions                  : string               read Get_xoptions                     write Set_xoptions;
  end;

  IPyMutex = interface
    ['{FFDECD81-E7B4-4952-97C2-49DA65AB65A6}']
    function GetPyMutex: Pointer;
    procedure Lock;
    procedure Unlock;
    function  IsLocked: boolean;

    property PyMutex : Pointer read GetPyMutex;
  end;

  IPyCriticalSection = interface
    ['{5BDB099E-F443-4A46-BDCD-DBF10BC34811}']
    function GetPyCriticalSection: Pointer;
    procedure Begin_(const op: IPyObject);
    procedure BeginMutex(const m: IPyMutex);
    procedure End_;

    property PyCriticalSection : Pointer read GetPyCriticalSection;
  end;

  IPyCriticalSection2 = interface
    ['{9CE03389-AA78-438B-A1FD-08E9CB14A4DB}']
    function GetPyCriticalSection: Pointer;
    procedure Begin_(const a, b: IPyObject);
    procedure BeginMutex(const m1, m2: IPyMutex);
    procedure End_;

    property PyCriticalSection : Pointer read GetPyCriticalSection;
  end;

implementation

end.
