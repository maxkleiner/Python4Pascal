unit uP4P.Interfaces;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.Types,
  {$ELSE}
    Classes, Types,
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
    /// If this is False then the sub-interpreter's threading module won't create threads.
    /// Otherwise threads are allowed.
    /// </summary>
    property allow_threads                 : boolean                  read Get_allow_threads                  write Set_allow_threads;
    /// <summary>
    /// If this is False then the sub-interpreter's threading module won't create daemon threads.
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
    function Get_argv: TStringDynArray;
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
    function Get_faulthandler: boolean;
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
    {$IFDEF MSWINDOWS}
    function Get_legacy_windows_fs_encoding: boolean;
    function Get_legacy_windows_stdio: boolean;
    {$ENDIF}
    function Get_malloc_stats: boolean;
    function Get_module_search_paths: string;
    function Get_optimization_level: TPyOptimizationLevel;
    function Get_orig_argv: TStringDynArray;
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
    function Get_warnoptions: TStringDynArray;
    function Get_write_bytecode: boolean;
    function Get_xoptions: TStringDynArray;

    procedure Set_allocator(aValue: PyMemAllocatorName);
    procedure Set_argv(const aValue: TStringDynArray);
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
    procedure Set_faulthandler(aValue: boolean);
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
    {$IFDEF MSWINDOWS}
    procedure Set_legacy_windows_fs_encoding(aValue: boolean);
    procedure Set_legacy_windows_stdio(aValue: boolean);
    {$ENDIF}
    procedure Set_malloc_stats(aValue: boolean);
    procedure Set_module_search_paths(const aValue: string);
    procedure Set_optimization_level(aValue: TPyOptimizationLevel);
    procedure Set_orig_argv(const aValue: TStringDynArray);
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
    procedure Set_warnoptions(const aValue: TStringDynArray);
    procedure Set_write_bytecode(aValue: boolean);
    procedure Set_xoptions(const aValue: TStringDynArray);

    /// <summary>
    /// <para>Test if the configuration has an option called name.</para>
    /// <para>Return True if the option exists, or return False otherwise.</para>
    /// </summary>
    function HasOption(const aOption: string): boolean;
    /// <summary>
    /// <para>Get an integer configuration option.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function GetInt(const aName: string; var aValue: int64): boolean;
    /// <summary>
    /// <para>Get a string configuration option as string.</para>
    /// <para>Set aValue, and return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function GetStr(const aName: string; var aValue: string): boolean;
    /// <summary>
    /// <para>Get a string list configuration option as a TStringList.</para>
    /// <para>Set aValue, and return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function GetStrList(const aName: string; var aItems: TStringList): boolean; overload;
    /// <summary>
    /// <para>Get a string list configuration option as a TStringDynArray.</para>
    /// <para>Set aValue, and return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function GetStrList(const aName: string; var aItems: TStringDynArray): boolean; overload;
    /// <summary>
    /// <para>Set an integer configuration option.</para>
    /// <para>Return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function SetInt(const aName: string; aValue: int64): boolean;
    /// <summary>
    /// <para>Set a string configuration option.</para>
    /// <para>Return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function SetStr(const aName, aValue: string): boolean;
    /// <summary>
    /// <para>Set a string list configuration option from a TStringList.</para>
    /// <para>Return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function SetStrList(const aName: string; const aItems: TStringList): boolean; overload;
    /// <summary>
    /// <para>Set a string list configuration option from a TStringDynArray.</para>
    /// <para>Return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function SetStrList(const aName: string; const aItems: TStringDynArray): boolean; overload;
    /// <summary>
    /// <para>Add a built-in extension module to the table of built-in
    /// modules.</para>
    /// <para>The new module can be imported by the name name, and uses the
    /// function initfunc as the initialization function called on the first
    /// attempted import.</para>
    /// <para>Return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// <para>If Python is initialized multiple times,
    /// AddModule() must be called at each Python initialization.</para>
    /// <para>Similar to the TPyImport.AppendInittab() function.</para>
    /// </summary>
    function AddModule(const aName: string; initfunc_: initfunc): boolean;

    /// <summary>
    /// Returns true if this class is fully initialized.
    /// </summary>
    property Initialized     : boolean      read GetInitialized;
    /// <summary>
    /// Pointer to the PyInitConfig record.
    /// </summary>
    property Config          : Pointer      read GetConfig;
    /// <summary>
    /// <para>Get the config error message.</para>
    /// <para>If config has an exit code, format the exit code as an error
    /// message.</para>
    /// <para>The error message remains valid until another PyInitConfig
    /// function is called with config. The caller doesn't have to free the
    /// error message.</para>
    /// </summary>
    property Error                      : string                 read GetError;
    /// <summary>
    /// <para>Get the config exit code.</para>
    /// <para>Set *exitcode and return 1 if config has an exit code set.</para>
    /// <para>Return 0 if config has no exit code set.</para>
    /// <para>Only the Py_InitializeFromInitConfig() function can set an exit
    /// code if the parse_argv option is non-zero.</para>
    /// <para>An exit code can be set when parsing the command line failed
    /// (exit code 2) or when a command line option asks to display the
    /// command line help (exit code 0).</para>
    /// </summary>
    property ExitCode                   : integer                read GetExitCode;
    /// <summary>
    /// Name of the Python memory allocator.
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/memory.html#memory">See the Memory Management article.</see></para>
    /// <para>See PyMemAllocatorName.</para>
    /// </remarks>
    property allocator                  : PyMemAllocatorName     read Get_allocator                      write Set_allocator;
    /// <summary>
    /// <para>Set sys.argv command line arguments based on argv. These
    /// parameters are similar to those passed to the program's main()
    /// function with the difference that the first entry should refer to the
    /// script file to be executed rather than the executable hosting the
    /// Python interpreter. If there isn't a script that will be run, the
    /// first entry in argv can be an empty string.</para>
    /// <para>Set parse_argv to True to parse argv the same way the regular
    /// Python parses Python command line arguments and then to strip Python
    /// arguments from argv.</para>
    /// <para>If argv is empty, an empty string is added to ensure that
    /// sys.argv always exists and is never empty.</para>
    /// </summary>
    /// <remarks>
    /// <para>See also the orig_argv member.</para>
    /// </remarks>
    property argv                       : TStringDynArray        read Get_argv                           write Set_argv;
    /// <summary>
    /// <para>Equivalent to exec_prefix, but referring to the base Python
    /// installation.</para>
    /// <para>When running under Virtual Environments, exec_prefix gets
    /// overwritten to the virtual environment prefix. base_exec_prefix,
    /// conversely, does not change, and always points to the base Python
    /// installation.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys_path_init.html#sys-path-init-virtual-environments">Refer to Virtual Environments for more information.</see></para>
    /// <para>See also PyConfig.exec_prefix.</para>
    /// </remarks>
    property base_exec_prefix           : string                 read Get_base_exec_prefix               write Set_base_exec_prefix;
    /// <summary>
    /// <para>Python base executable: sys._base_executable.</para>
    /// <para>Set by the __PYVENV_LAUNCHER__ environment variable.</para>
    /// <para>Set from PyConfig.executable if empty.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para>See also PyConfig.executable.</para>
    /// </remarks>
    property base_executable            : string                 read Get_base_executable                write Set_base_executable;
    /// <summary>
    /// <para>Equivalent to prefix, but referring to the base Python
    /// installation.</para>
    /// <para>When running under virtual environment, prefix gets overwritten
    /// to the virtual environment prefix. base_prefix, conversely, does not
    /// change, and always points to the base Python installation.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys_path_init.html#sys-path-init-virtual-environments">Refer to Virtual Environments for more information.</see></para>
    /// <para>See also PyConfig.prefix.</para>
    /// </remarks>
    property base_prefix                : string                 read Get_base_prefix                    write Set_base_prefix;
    /// <summary>
    /// <para>If equals to False and configure_c_stdio is True, disable
    /// buffering on the C streams stdout and stderr.</para>
    /// <para>Set to False by the -u command line option and the
    /// PYTHONUNBUFFERED environment variable.</para>
    /// <para>stdin is always opened in buffered mode.</para>
    /// <para>Default: True.</para>
    /// </summary>
    property buffered_stdio             : boolean                read Get_buffered_stdio                 write Set_buffered_stdio;
    /// <summary>
    /// <para>If equals to 1, issue a warning when comparing bytes or
    /// bytearray with str, or comparing bytes with int.</para>
    /// <para>If equal or greater to 2, raise a BytesWarning exception in
    /// these cases.</para>
    /// <para>Incremented by the -b command line option.</para>
    /// <para>Default: 0.</para>
    /// </summary>
    property bytes_warning              : int64                  read Get_bytes_warning                  write Set_bytes_warning;
    /// <summary>
    /// <para>Control the validation behavior of hash-based .pyc files: value
    /// of the --check-hash-based-pycs command line option.</para>
    /// <para>Valid values:</para>
    /// <code>
    /// - "always": Hash the source file for invalidation regardless of value
    ///   of the 'check_source' flag.
    /// - "never": Assume that hash-based pycs always are valid.
    /// - "default": The 'check_source' flag in hash-based pycs determines
    ///   invalidation.
    /// </code>
    /// <para>Default: "default".</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://peps.python.org/pep-0552/">See also PEP 552 "Deterministic pycs".</see></para>
    /// </remarks>
    property check_hash_pycs_mode       : string                 read Get_check_hash_pycs_mode           write Set_check_hash_pycs_mode;
    /// <summary>
    /// <para>If equals to False, disables the inclusion of the end line and
    /// column mappings in code objects. Also disables traceback printing
    /// carets to specific error locations.</para>
    /// <para>Set to False by the PYTHONNODEBUGRANGES environment variable
    /// and by the -X no_debug_ranges command line option.</para>
    /// <para>Default: True.</para>
    /// </summary>
    property code_debug_ranges          : boolean                read Get_code_debug_ranges              write Set_code_debug_ranges;
    /// <summary>
    /// <para>If equals to 2, coerce the C locale.</para>
    /// <para>If equals to 1, read the LC_CTYPE locale to decide if it should
    /// be coerced.</para>
    /// <para>See the locale encoding.</para>
    /// <para>Default: -1 in Python config, 0 in isolated config.</para>
    /// </summary>
    property coerce_c_locale            : integer                read Get_coerce_c_locale                write Set_coerce_c_locale;
    /// <summary>
    /// <para>If True, emit a warning if the C locale is coerced.</para>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property coerce_c_locale_warn       : boolean                read Get_coerce_c_locale_warn           write Set_coerce_c_locale_warn;
    /// <summary>
    /// <para>If True, configure C standard streams:</para>
    /// <code>
    /// - On Windows, set the binary mode (O_BINARY) on stdin, stdout and
    ///   stderr.
    /// - If buffered_stdio equals zero, disable buffering of stdin, stdout
    ///   and stderr streams.
    /// - If interactive is non-zero, enable stream buffering on stdin and
    ///   stdout (only stdout on Windows).
    /// </code>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property configure_c_stdio          : boolean                read Get_configure_c_stdio              write Set_configure_c_stdio;
    /// <summary>
    /// <para>Set the LC_CTYPE locale to the user preferred locale.</para>
    /// <para>If equals to False, set coerce_c_locale and coerce_c_locale_warn
    /// members to 0 and False.</para>
    /// <para>See the locale encoding.</para>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property configure_locale           : boolean                read Get_configure_locale               write Set_configure_locale;
    /// <summary>
    /// <para>If the value of cpu_count is not -1 then it will override the
    /// return values of os.cpu_count(), os.process_cpu_count(), and
    /// multiprocessing.cpu_count().</para>
    /// <para>Configured by the -X cpu_count=n|default command line flag or
    /// the PYTHON_CPU_COUNT environment variable.</para>
    /// <para>Default: -1.</para>
    /// </summary>
    property cpu_count                  : int64                  read Get_cpu_count                      write Set_cpu_count;
    /// <summary>
    /// <para>If True, enable the Python Development Mode.</para>
    /// <para>Set to True by the -X dev option and the PYTHONDEVMODE
    /// environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/devmode.html#devmode">See the article about Python Development Mode.</see></para>
    /// </remarks>
    property dev_mode                   : boolean                read Get_dev_mode                       write Set_dev_mode;
    /// <summary>
    /// <para>Dump Python references?</para>
    /// <para>If True, dump all objects which are still alive at exit.</para>
    /// <para>Set to True by the PYTHONDUMPREFS environment variable.</para>
    /// <para>Needs a special build of Python with the Py_TRACE_REFS macro
    /// defined: see the configure --with-trace-refs option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property dump_refs                  : boolean                read Get_dump_refs                      write Set_dump_refs;
    /// <summary>
    /// <para>Filename where to dump Python references. Set by the
    /// PYTHONDUMPREFSFILE environment variable.</para>
    /// </summary>
    property dump_refs_file             : string                 read Get_dump_refs_file                 write Set_dump_refs_file;
    /// <summary>
    /// <para>The site-specific directory prefix where the platform-dependent
    /// Python files are installed: sys.exec_prefix.</para>
    /// <para>Part of the Python Path Configuration output.</para>
    /// <para>See also PyConfig.base_exec_prefix.</para>
    /// </summary>
    property exec_prefix                : string                 read Get_exec_prefix                    write Set_exec_prefix;
    /// <summary>
    /// <para>The absolute path of the executable binary for the Python
    /// interpreter: sys.executable.</para>
    /// <para>Part of the Python Path Configuration output.</para>
    /// <para>See also PyConfig.base_executable.</para>
    /// </summary>
    property executable                 : string                 read Get_executable                     write Set_executable;
    /// <summary>
    /// <para>Enable faulthandler?</para>
    /// <para>If True, call faulthandler.enable() at startup.</para>
    /// <para>Set to True by -X faulthandler and the PYTHONFAULTHANDLER
    /// environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    property faulthandler               : boolean                read Get_faulthandler                   write Set_faulthandler;
    /// <summary>
    /// <para>Filesystem encoding: sys.getfilesystemencoding().</para>
    /// <para>On macOS, Android and VxWorks: use "utf-8" by default.</para>
    /// <para>On Windows: use "utf-8" by default, or "mbcs" if
    /// legacy_windows_fs_encoding of PyPreConfig is non-zero.</para>
    /// <para>Default encoding on other platforms:</para>
    /// <code>
    /// - "utf-8" if PyPreConfig.utf8_mode is non-zero.
    /// - "ascii" if Python detects that nl_langinfo(CODESET) announces the
    ///   ASCII encoding, whereas the mbstowcs() function decodes from a
    ///   different encoding (usually Latin1).
    /// - "utf-8" if nl_langinfo(CODESET) returns an empty string.
    /// </code>
    /// <para>Otherwise, use the locale encoding: nl_langinfo(CODESET)
    /// result.</para>
    /// <para>At Python startup, the encoding name is normalized to the Python
    /// codec name. For example, "ANSI_X3.4-1968" is replaced with
    /// "ascii".</para>
    /// <para>See also the filesystem_errors member.</para>
    /// </summary>
    property filesystem_encoding        : string                 read Get_filesystem_encoding            write Set_filesystem_encoding;
    /// <summary>
    /// <para>Filesystem error handler: sys.getfilesystemencodeerrors().</para>
    /// <para>On Windows: use "surrogatepass" by default, or "replace" if
    /// legacy_windows_fs_encoding of PyPreConfig is non-zero.</para>
    /// <para>On other platforms: use "surrogateescape" by default.</para>
    /// <para>Supported error handlers:</para>
    /// <code>
    /// - "strict"
    /// - "surrogateescape"
    /// - "surrogatepass" (only supported with the UTF-8 encoding)
    /// </code>
    /// <para>See also the filesystem_encoding member.</para>
    /// </summary>
    property filesystem_errors          : string                 read Get_filesystem_errors              write Set_filesystem_errors;
    /// <summary>
    /// <para>Hash seed</para>
    /// </summary>
    property hash_seed                  : int64                  read Get_hash_seed                      write Set_hash_seed;
    /// <summary>
    /// <para>Set the default Python "home" directory, that is, the location
    /// of the standard Python libraries.</para>
    /// <para>Set by the PYTHONHOME environment variable.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONHOME">See the article about PYTHONHOME.</see></para>
    /// </remarks>
    property home                       : string                 read Get_home                           write Set_home;
    /// <summary>
    /// <para>If 1, profile import time. If 2, include additional output that
    /// indicates when an imported module has already been loaded.</para>
    /// <para>Set by the -X importtime option and the PYTHONPROFILEIMPORTTIME
    /// environment variable.</para>
    /// <para>Default: 0.</para>
    /// <para>Changed in version 3.14: Added support for import_time = 2</para>
    /// </summary>
    property import_time                : int64                  read Get_import_time                    write Set_import_time;
    /// <summary>
    /// <para>Enter interactive mode after executing a script or a
    /// command.</para>
    /// <para>If True, enable inspect: when a script is passed as first
    /// argument or the -c option is used, enter interactive mode after
    /// executing the script or the command, even when sys.stdin does not
    /// appear to be a terminal.</para>
    /// <para>Enabled by the -i command line option. Set to True if the
    /// PYTHONINSPECT environment variable is non-empty.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property inspect                    : boolean                read Get_inspect                        write Set_inspect;
    /// <summary>
    /// <para>Install Python signal handlers?</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    property install_signal_handlers    : boolean                read Get_install_signal_handlers        write Set_install_signal_handlers;
    /// <summary>
    /// <para>Configures the integer string conversion length limitation. An
    /// initial value of -1 means the value will be taken from the command
    /// line or environment or otherwise default to 4300
    /// (sys.int_info.default_max_str_digits). A value of 0 disables the
    /// limitation. Values greater than zero but less than 640
    /// (sys.int_info.str_digits_check_threshold) are unsupported and will
    /// produce an error.</para>
    /// <para>Configured by the -X int_max_str_digits command line flag or the
    /// PYTHONINTMAXSTRDIGITS environment variable.</para>
    /// <para>Default: -1 in Python mode. 4300
    /// (sys.int_info.default_max_str_digits) in isolated mode.</para>
    /// <para>Added in version 3.12.</para>
    /// </summary>
    property int_max_str_digits         : int64                  read Get_int_max_str_digits             write Set_int_max_str_digits;
    /// <summary>
    /// <para>If True, enable the interactive mode (REPL).</para>
    /// <para>Enabled by the -i command line option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property interactive                : boolean                read Get_interactive                    write Set_interactive;
    /// <summary>
    /// <para>If True, enable isolated mode:</para>
    /// <code>
    /// - Set safe_path to True: don't prepend a potentially unsafe path to
    ///   sys.path at Python startup, such as the current directory, the
    ///   script's directory or an empty string.
    /// - Set use_environment to False: ignore PYTHON environment variables.
    /// - Set user_site_directory to False: don't add the user site directory
    ///   to sys.path.
    /// - Python REPL doesn't import readline nor enable default readline
    ///   configuration on interactive prompts.
    /// </code>
    /// <para>Set to True by the -I command line option.</para>
    /// <para>Default: False in Python mode, True in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#isolated-configuration">See the article about Isolated Configuration.</see></para>
    /// </remarks>
    property isolated                   : boolean                read Get_isolated                       write Set_isolated;
    {$IFDEF MSWINDOWS}
    /// <summary>
    /// <para>If True:</para>
    /// <code>
    /// - Set PyPreConfig.utf8_mode to False,
    /// - Set PyConfig.filesystem_encoding to "mbcs",
    /// - Set PyConfig.filesystem_errors to "replace".
    /// </code>
    /// <para>Initialized from the PYTHONLEGACYWINDOWSFSENCODING environment
    /// variable value. Only available on Windows.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property legacy_windows_fs_encoding : boolean                read Get_legacy_windows_fs_encoding     write Set_legacy_windows_fs_encoding;
    /// <summary>
    /// <para>If True, use io.FileIO instead of io._WindowsConsoleIO for
    /// sys.stdin, sys.stdout and sys.stderr.</para>
    /// <para>Set to True if the PYTHONLEGACYWINDOWSSTDIO environment variable
    /// is set to a non-empty string.</para>
    /// <para>Only available on Windows. #ifdef MS_WINDOWS macro can be used
    /// for Windows specific code.</para>
    /// <para>Default: False.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://peps.python.org/pep-0528/">See also the PEP 528 (Change Windows console encoding to UTF-8).</see></para>
    /// </remarks>
    property legacy_windows_stdio       : boolean                read Get_legacy_windows_stdio           write Set_legacy_windows_stdio;
    {$ENDIF}
    /// <summary>
    /// <para>If True, dump statistics on Python pymalloc memory allocator at
    /// exit.</para>
    /// <para>Set to True by the PYTHONMALLOCSTATS environment variable.</para>
    /// <para>The option is ignored if Python is configured using the
    /// --without-pymalloc option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property malloc_stats               : boolean                read Get_malloc_stats                   write Set_malloc_stats;
    /// <summary>
    /// <para>A list of strings that specifies the search path for
    /// modules.</para>
    /// <para>Initialized from the environment variable PYTHONPATH, plus an
    /// installation-dependent default.</para>
    /// <para>If module_search_paths_set is False, Py_InitializeFromConfig()
    /// will replace module_search_paths and sets module_search_paths_set to
    /// True.</para>
    /// <para>Default: empty list (module_search_paths) and False
    /// (module_search_paths_set).</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys.path">See the article about sys.path.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH">See the article about PYTHONPATH.</see></para>
    /// </remarks>
    property module_search_paths        : string                 read Get_module_search_paths            write Set_module_search_paths;
    /// <summary>
    /// <para>Compilation optimization level:</para>
    /// <code>
    /// - polDebug (0) : Peephole optimizer, set __debug__ to True.
    /// - polRelease (1) : Level 0, remove assertions, set __debug__ to False.
    /// - polReleaseNoDocStrings (2) : Level 1, strip docstrings.
    /// </code>
    /// <para>Incremented by the -O command line option. Set to the
    /// PYTHONOPTIMIZE environment variable value.</para>
    /// <para>Default: polDebug (0).</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONOPTIMIZE">See the article about PYTHONOPTIMIZE.</see></para>
    /// </remarks>
    property optimization_level         : TPyOptimizationLevel   read Get_optimization_level             write Set_optimization_level;
    /// <summary>
    /// <para>The list of the original command line arguments passed to the
    /// Python executable: sys.orig_argv.</para>
    /// <para>If orig_argv list is empty and argv is not a list only
    /// containing an empty string, PyConfig_Read() copies argv into orig_argv
    /// before modifying argv (if parse_argv is non-zero).</para>
    /// <para>See also the argv member and the Py_GetArgcArgv()
    /// function.</para>
    /// <para>Default: empty list.</para>
    /// <para>Added in version 3.10.</para>
    /// </summary>
    property orig_argv                  : TStringDynArray        read Get_orig_argv                      write Set_orig_argv;
    /// <summary>
    /// <para>Parse command line arguments?</para>
    /// <para>If True, parse argv the same way the regular Python parses
    /// command line arguments, and strip Python arguments from argv.</para>
    /// <para>The PyConfig_Read() function only parses PyConfig.argv arguments
    /// once: PyConfig.parse_argv is set to True after arguments are parsed.
    /// Since Python arguments are stripped from PyConfig.argv, parsing
    /// arguments twice would parse the application options as Python
    /// options.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// <para>Changed in version 3.10: The PyConfig.argv arguments are now
    /// only parsed once.</para>
    /// </summary>
    property parse_argv                 : boolean                read Get_parse_argv                     write Set_parse_argv;
    /// <summary>
    /// <para>Parser debug mode. If True, turn on parser debugging output
    /// (for expert only, depending on compilation options).</para>
    /// <para>Enabled by the -d command line option. Set to the PYTHONDEBUG
    /// environment variable value.</para>
    /// <para>Needs a debug build of Python (the Py_DEBUG macro must be
    /// defined).</para>
    /// <para>Default: False.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONDEBUG">See the article about PYTHONDEBUG.</see></para>
    /// </remarks>
    property parser_debug               : boolean                read Get_parser_debug                   write Set_parser_debug;
    /// <summary>
    /// <para>If True, calculation of path configuration is allowed to log
    /// warnings into stderr. If False, suppress these warnings.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// <para>Changed in version 3.11: Now also applies on Windows.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// </remarks>
    property pathconfig_warnings        : boolean                read Get_pathconfig_warnings            write Set_pathconfig_warnings;
    /// <summary>
    /// <para>Enable the Linux perf profiler support?</para>
    /// <para>If equals to 1, enable support for the Linux perf
    /// profiler.</para>
    /// <para>If equals to 2, enable support for the Linux perf profiler with
    /// DWARF JIT support.</para>
    /// <para>Set to 1 by -X perf command-line option and the
    /// PYTHONPERFSUPPORT environment variable.</para>
    /// <para>Set to 2 by the -X perf_jit command-line option and the
    /// PYTHON_PERF_JIT_SUPPORT environment variable.</para>
    /// <para>Default: -1.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/howto/perf_profiling.html#perf-profiling">See Python support for the Linux perf profiler for more information.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPERFSUPPORT">See the article about PYTHONPERFSUPPORT.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHON_PERF_JIT_SUPPORT">See the article about PYTHON_PERF_JIT_SUPPORT.</see></para>
    /// </remarks>
    property perf_profiling             : int64                  read Get_perf_profiling                 write Set_perf_profiling;
    /// <summary>
    /// <para>Platform library directory name: sys.platlibdir.</para>
    /// <para>Name of the platform-specific library directory. It is used to
    /// build the path of standard library and the paths of installed
    /// extension modules.</para>
    /// <para>Set by the PYTHONPLATLIBDIR environment variable.</para>
    /// <para>Default: value of the PLATLIBDIR macro which is set by the
    /// configure --with-platlibdir option (default: "lib", or "DLLs" on
    /// Windows).</para>
    /// <para>Added in version 3.9.</para>
    /// <para>Changed in version 3.11: This macro is now used on Windows to
    /// locate the standard library extension modules, typically under DLLs.
    /// However, for compatibility, note that this value is ignored for any
    /// non-standard layouts, including in-tree builds and virtual
    /// environments.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPLATLIBDIR">See the article about PYTHONPLATLIBDIR.</see></para>
    /// </remarks>
    property platlibdir                 : string                 read Get_platlibdir                     write Set_platlibdir;
    /// <summary>
    /// <para>The site-specific directory prefix where the platform
    /// independent Python files are installed: sys.prefix.</para>
    /// <para>A string giving the site-specific directory prefix where the
    /// platform independent Python files are installed; on Unix, the default
    /// is /usr/local. This can be set at build time with the --prefix
    /// argument to the configure script.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para>See also PyConfig.base_prefix.</para>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys.prefix">See the article about sys.prefix.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sysconfig.html#installation-paths">See Installation paths for derived paths.</see></para>
    /// </remarks>
    property prefix                     : string                 read Get_prefix                         write Set_prefix;
    /// <summary>
    /// <para>Program name used to initialize executable and in early error
    /// messages during Python initialization.</para>
    /// <para>On macOS, use PYTHONEXECUTABLE environment variable if
    /// set.</para>
    /// <para>If the WITH_NEXT_FRAMEWORK macro is defined, use
    /// __PYVENV_LAUNCHER__ environment variable if set.</para>
    /// <para>Use argv[0] of argv if available and non-empty.</para>
    /// <para>Otherwise, use "python" on Windows, or "python3" on other
    /// platforms.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONEXECUTABLE">See the article about PYTHONEXECUTABLE.</see></para>
    /// <para>See PyConfig.executable and PyConfig.base_executable.</para>
    /// </remarks>
    property program_name               : string                 read Get_program_name                   write Set_program_name;
    /// <summary>
    /// <para>Directory where cached .pyc files are written:
    /// sys.pycache_prefix.</para>
    /// <para>Set by the -X pycache_prefix=PATH command line option and the
    /// PYTHONPYCACHEPREFIX environment variable. The command-line option
    /// takes precedence.</para>
    /// <para>If empty, sys.pycache_prefix is set to None.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPYCACHEPREFIX">See the article about PYTHONPYCACHEPREFIX.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys.pycache_prefix">See the article about sys.pycache_prefix.</see></para>
    /// </remarks>
    property pycache_prefix             : string                 read Get_pycache_prefix                 write Set_pycache_prefix;
    /// <summary>
    /// <para>Quiet mode. If True, don't display the copyright and version at
    /// Python startup in interactive mode.</para>
    /// <para>Enabled by the -q command line option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property quiet                      : boolean                read Get_quiet                          write Set_quiet;
    /// <summary>
    /// <para>Value of the -c command line option.</para>
    /// <para>Used by Py_RunMain().</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    property run_command                : string                 read Get_run_command                    write Set_run_command;
    /// <summary>
    /// <para>Filename passed on the command line: trailing command line
    /// argument without -c or -m. It is used by the Py_RunMain()
    /// function.</para>
    /// <para>For example, it is set to script.py by the python3 script.py
    /// arg command line.</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#c.PyConfig.skip_source_first_line">See also the PyConfig.skip_source_first_line option.</see></para>
    /// </remarks>
    property run_filename               : string                 read Get_run_filename                   write Set_run_filename;
    /// <summary>
    /// <para>Value of the -m command line option.</para>
    /// <para>Used by Py_RunMain().</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    property run_module                 : string                 read Get_run_module                     write Set_run_module;
    /// <summary>
    /// <para>package.module path to module that should be imported before
    /// site.py is run.</para>
    /// <para>Set by the -X presite=package.module command-line option and the
    /// PYTHON_PRESITE environment variable. The command-line option takes
    /// precedence.</para>
    /// <para>Needs a debug build of Python (the Py_DEBUG macro must be
    /// defined).</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    property run_presite                : string                 read Get_run_presite                    write Set_run_presite;
    /// <summary>
    /// <para>If equals to zero, Py_RunMain() prepends a potentially unsafe
    /// path to sys.path at startup:</para>
    /// <code>
    /// - If argv[0] is equal to "-m" (python -m module), prepend the current
    ///   working directory.
    /// - If running a script (python script.py), prepend the script's
    ///   directory. If it's a symbolic link, resolve symbolic links.
    /// - Otherwise (python -c code and python), prepend an empty string,
    ///   which means the current working directory.
    /// </code>
    /// <para>Set to 1 by the -P command line option and the PYTHONSAFEPATH
    /// environment variable.</para>
    /// <para>Default: False in Python config, True in isolated config.</para>
    /// <para>Added in version 3.11.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSAFEPATH">See the article about PYTHONSAFEPATH.</see></para>
    /// </remarks>
    property safe_path                  : boolean                read Get_safe_path                      write Set_safe_path;
    /// <summary>
    /// <para>Show total reference count at exit (excluding immortal
    /// objects)?</para>
    /// <para>Set to True by -X showrefcount command line option.</para>
    /// <para>Needs a debug build of Python (the Py_REF_DEBUG macro must be
    /// defined).</para>
    /// <para>Default: False.</para>
    /// </summary>
    property show_ref_count             : boolean                read Get_show_ref_count                 write Set_show_ref_count;
    /// <summary>
    /// <para>Import the site module at startup?</para>
    /// <para>If equal to zero, disable the import of the module site and the
    /// site-dependent manipulations of sys.path that it entails.</para>
    /// <para>Also disable these manipulations if the site module is
    /// explicitly imported later (call site.main() if you want them to be
    /// triggered).</para>
    /// <para>Set to False by the -S command line option.</para>
    /// <para>sys.flags.no_site is set to the inverted value of
    /// site_import.</para>
    /// <para>Default: True.</para>
    /// </summary>
    property site_import                : boolean                read Get_site_import                    write Set_site_import;
    /// <summary>
    /// <para>If non-zero, skip the first line of the PyConfig.run_filename
    /// source.</para>
    /// <para>It allows the usage of non-Unix forms of #!cmd. This is intended
    /// for a DOS specific hack only.</para>
    /// <para>Set to True by the -x command line option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property skip_source_first_line     : boolean                read Get_skip_source_first_line         write Set_skip_source_first_line;
    /// <summary>
    /// <para>Encoding of sys.stdin, sys.stdout and sys.stderr (but sys.stderr
    /// always uses "backslashreplace" error handler).</para>
    /// <para>Use the PYTHONIOENCODING environment variable if it is
    /// non-empty.</para>
    /// <para>Default encoding:</para>
    /// <code>
    /// - "UTF-8" if PyPreConfig.utf8_mode is non-zero.
    /// - Otherwise, use the locale encoding.
    /// </code>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONIOENCODING">See the article about PYTHONIOENCODING.</see></para>
    /// <para>See also PyConfig.legacy_windows_stdio.</para>
    /// </remarks>
    property stdio_encoding             : string                 read Get_stdio_encoding                 write Set_stdio_encoding;
    /// <summary>
    /// <para>Encoding errors of sys.stdin, sys.stdout and sys.stderr (but
    /// sys.stderr always uses "backslashreplace" error handler).</para>
    /// <para>Use the PYTHONIOENCODING environment variable if it is
    /// non-empty.</para>
    /// <para>Default error handler:</para>
    /// <code>
    /// - On Windows: use "surrogateescape".
    /// - "surrogateescape" if PyPreConfig.utf8_mode is non-zero, or if the
    ///   LC_CTYPE locale is "C" or "POSIX".
    /// - "strict" otherwise.
    /// </code>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONIOENCODING">See the article about PYTHONIOENCODING.</see></para>
    /// <para>See also PyConfig.legacy_windows_stdio.</para>
    /// </remarks>
    property stdio_errors               : string                 read Get_stdio_errors                   write Set_stdio_errors;
    /// <summary>
    /// <para>Directory of the Python standard library.</para>
    /// <para>Default: Empty.</para>
    /// <para>Added in version 3.11.</para>
    /// </summary>
    property stdlib_dir                 : string                 read Get_stdlib_dir                     write Set_stdlib_dir;
    /// <summary>
    /// <para>Enable tracemalloc?</para>
    /// <para>If True, call tracemalloc.start() at startup.</para>
    /// <para>Set by -X tracemalloc=N command line option and by the
    /// PYTHONTRACEMALLOC environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONTRACEMALLOC">See the article about PYTHONTRACEMALLOC.</see></para>
    /// <para>See also PyConfig.legacy_windows_stdio.</para>
    /// </remarks>
    property tracemalloc                : int64                  read Get_tracemalloc                    write Set_tracemalloc;
    /// <summary>
    /// <para>Use environment variables?</para>
    /// <para>If False, ignore the environment variables.</para>
    /// <para>Set to False by the -E environment variable.</para>
    /// <para>Default: True in Python config and False in isolated
    /// config.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#using-on-envvars">See the article about environment variables.</see></para>
    /// </remarks>
    property use_environment            : boolean                read Get_use_environment                write Set_use_environment;
    /// <summary>
    /// <para>If True, use frozen modules.</para>
    /// <para>Set by the PYTHON_FROZEN_MODULES environment variable.</para>
    /// <para>Default: True in a release build, or False in a debug
    /// build.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHON_FROZEN_MODULES">See the article about PYTHON_FROZEN_MODULES.</see></para>
    /// </remarks>
    property use_frozen_modules         : boolean                read Get_use_frozen_modules             write Set_use_frozen_modules;
    /// <summary>
    /// <para>Randomized hash function seed.</para>
    /// <para>If use_hash_seed is zero, a seed is chosen randomly at Python
    /// startup, and hash_seed is ignored.</para>
    /// <para>Set by the PYTHONHASHSEED environment variable.</para>
    /// <para>Default use_hash_seed value: True in Python mode, False in
    /// isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONHASHSEED">See the article about PYTHONHASHSEED.</see></para>
    /// </remarks>
    property use_hash_seed              : boolean                read Get_use_hash_seed                  write Set_use_hash_seed;
    /// <summary>
    /// <para>If non-zero, stdout and stderr will be redirected to the system
    /// log.</para>
    /// <para>Only available on macOS 10.12 and later, and on iOS.</para>
    /// <para>Default: False (don't use the system log) on macOS; True on iOS
    /// (use the system log).</para>
    /// <para>Added in version 3.14.</para>
    /// </summary>
    property use_system_logger          : boolean                read Get_use_system_logger              write Set_use_system_logger;
    /// <summary>
    /// <para>If True, add the user site directory to sys.path.</para>
    /// <para>Set to False by the -s and -I command line options.</para>
    /// <para>Set to False by the PYTHONNOUSERSITE environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONNOUSERSITE">See the article about PYTHONNOUSERSITE.</see></para>
    /// </remarks>
    property user_site_directory        : boolean                read Get_user_site_directory            write Set_user_site_directory;
    /// <summary>
    /// <para>If True, enable the Python UTF-8 Mode.</para>
    /// <para>Set to False or True by the -X utf8 command line option and the
    /// PYTHONUTF8 environment variable.</para>
    /// <para>Also set to True if the LC_CTYPE locale is C or POSIX.</para>
    /// <para>Default: True in Python config and False in isolated
    /// config.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONUTF8">See the article about PYTHONUTF8.</see></para>
    /// <para><see href="https://docs.python.org/3/library/os.html#utf8-mode">See the article about Python UTF-8 Mode.</see></para>
    /// </remarks>
    property utf8_mode                  : integer                read Get_utf8_mode                      write Set_utf8_mode;
    /// <summary>
    /// <para>Verbose mode. If pvmModule or pvmFull, print a message each time
    /// a module is imported, showing the place (filename or built-in module)
    /// from which it is loaded.</para>
    /// <para>If pvmFull, print a message for each file
    /// that is checked for when searching for a module. Also provides
    /// information on module cleanup at exit.</para>
    /// <para>Enabled by the -v command line option.</para>
    /// <para>Set by the PYTHONVERBOSE environment variable value.</para>
    /// <para>Default: pvmDisabled.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONVERBOSE">See the article about PYTHONVERBOSE.</see></para>
    /// </remarks>
    property verbose                    : TPyVerboseMode         read Get_verbose                        write Set_verbose;
    /// <summary>
    /// <para>If non-zero, emit a EncodingWarning warning when
    /// io.TextIOWrapper uses its default encoding.</para>
    /// <para>Default: False.</para>
    /// <para>Added in version 3.10.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/io.html#io-encoding-warning">See Opt-in EncodingWarning for details.</see></para>
    /// </remarks>
    property warn_default_encoding      : boolean                read Get_warn_default_encoding          write Set_warn_default_encoding;
    /// <summary>
    /// <para>Options of the warnings module to build warnings filters, lowest
    /// to highest priority: sys.warnoptions.</para>
    /// <para>The warnings module adds sys.warnoptions in the reverse order:
    /// the last PyConfig.warnoptions item becomes the first item of
    /// warnings.filters which is checked first (highest priority).</para>
    /// <para>The -W command line options adds its value to warnoptions, it
    /// can be used multiple times.</para>
    /// <para>The PYTHONWARNINGS environment variable can also be used to add
    /// warning options. Multiple options can be specified, separated by
    /// commas (,).</para>
    /// <para>Default: empty list.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONWARNINGS">See the article about PYTHONWARNINGS.</see></para>
    /// </remarks>
    property warnoptions                : TStringDynArray        read Get_warnoptions                    write Set_warnoptions;
    /// <summary>
    /// <para>If False, Python won't try to write .pyc files on the import of
    /// source modules.</para>
    /// <para>Set to False by the -B command line option and the
    /// PYTHONDONTWRITEBYTECODE environment variable.</para>
    /// <para>sys.dont_write_bytecode is initialized to the inverted value of
    /// write_bytecode.</para>
    /// <para>Default: True.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONDONTWRITEBYTECODE">See the article about PYTHONDONTWRITEBYTECODE.</see></para>
    /// </remarks>
    property write_bytecode             : boolean                read Get_write_bytecode                 write Set_write_bytecode;
    /// <summary>
    /// <para>Values of the -X command line options: sys._xoptions.</para>
    /// <para>Default: empty list.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys._xoptions">See the article about sys._xoptions.</see></para>
    /// </remarks>
    property xoptions                   : TStringDynArray        read Get_xoptions                       write Set_xoptions;
  end;

  /// <summary>
  /// Interface used to preinitialize Python.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#pypreconfig">See the article about PyPreConfig.</see></para>
  /// </remarks>
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
    {$IFDEF MSWINDOWS}
    function Get_legacy_windows_fs_encoding: boolean;
    {$ENDIF}
    function Get_utf8_mode: integer;
    function Get_dev_mode: boolean;
    function Get_allocator: PyMemAllocatorName;

    procedure Set_parse_argv(aValue: boolean);
    procedure Set_isolated(aValue: boolean);
    procedure Set_use_environment(aValue: boolean);
    procedure Set_configure_locale(aValue: boolean);
    procedure Set_coerce_c_locale(aValue: integer);
    procedure Set_coerce_c_locale_warn(aValue: boolean);
    {$IFDEF MSWINDOWS}
    procedure Set_legacy_windows_fs_encoding(aValue: boolean);
    {$ENDIF}
    procedure Set_utf8_mode(aValue: integer);
    procedure Set_dev_mode(aValue: boolean);
    procedure Set_allocator(aValue: PyMemAllocatorName);

    /// <summary>
    /// Initialize the preconfiguration with Python Configuration.
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-python-config">See the Python Configuration article.</see></para>
    /// </remarks>
    procedure InitPythonConfig;
    /// <summary>
    /// Initialize the preconfiguration with Isolated Configuration.
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-isolated-conf">See the Isolated Configuration article.</see></para>
    /// </remarks>
    procedure InitIsolatedConfig;
    /// <summary>
    /// Pointer to the PyPreConfig record.
    /// </summary>
    property Config                      : Pointer            read GetConfig;
    /// <summary>
    /// Returns true if this class is fully initialized.
    /// </summary>
    property Initialized                 : boolean            read GetInitialized;
    /// <summary>
    /// <para>If True, Py_PreInitializeFromArgs() and
    /// Py_PreInitializeFromBytesArgs() parse their argv argument the same way
    /// the regular Python parses command line arguments: see Command Line
    /// Arguments.</para>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property parse_argv                  : boolean            read Get_parse_argv                           write Set_parse_argv;
    /// <summary>
    /// <para>If True, enable isolated mode:</para>
    /// <code>
    /// - Set safe_path to True: don't prepend a potentially unsafe path to
    ///   sys.path at Python startup, such as the current directory, the
    ///   script's directory or an empty string.
    /// - Set use_environment to False: ignore PYTHON environment variables.
    /// - Set user_site_directory to False: don't add the user site directory
    ///   to sys.path.
    /// - Python REPL doesn't import readline nor enable default readline
    ///   configuration on interactive prompts.
    /// </code>
    /// <para>Set to True by the -I command line option.</para>
    /// <para>Default: False in Python mode, True in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#isolated-configuration">See the article about Isolated Configuration.</see></para>
    /// </remarks>
    property isolated                    : boolean            read Get_isolated                             write Set_isolated;
    /// <summary>
    /// <para>Use environment variables?</para>
    /// <para>If False, ignore the environment variables.</para>
    /// <para>Set to False by the -E environment variable.</para>
    /// <para>Default: True in Python config and False in isolated
    /// config.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#using-on-envvars">See the article about environment variables.</see></para>
    /// </remarks>
    property use_environment             : boolean            read Get_use_environment                      write Set_use_environment;
    /// <summary>
    /// <para>Set the LC_CTYPE locale to the user preferred locale.</para>
    /// <para>If False, set coerce_c_locale and coerce_c_locale_warn members
    /// to False.</para>
    /// <para>See the locale encoding.</para>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property configure_locale            : boolean            read Get_configure_locale                     write Set_configure_locale;
    /// <summary>
    /// <para>If equals to 2, coerce the C locale.</para>
    /// <para>If equals to 1, read the LC_CTYPE locale to decide if it should
    /// be coerced.</para>
    /// <para>See the locale encoding.</para>
    /// <para>Default: -1 in Python config, 0 in isolated config.</para>
    /// </summary>
    property coerce_c_locale             : integer            read Get_coerce_c_locale                      write Set_coerce_c_locale;
    /// <summary>
    /// <para>If True, emit a warning if the C locale is coerced.</para>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property coerce_c_locale_warn        : boolean            read Get_coerce_c_locale_warn                 write Set_coerce_c_locale_warn;
    {$IFDEF MSWINDOWS}
    /// <summary>
    /// <para>If True:</para>
    /// <code>
    /// - Set PyPreConfig.utf8_mode to False,
    /// - Set PyConfig.filesystem_encoding to "mbcs",
    /// - Set PyConfig.filesystem_errors to "replace".
    /// </code>
    /// <para>Initialized from the PYTHONLEGACYWINDOWSFSENCODING environment
    /// variable value. Only available on Windows.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property legacy_windows_fs_encoding  : boolean            read Get_legacy_windows_fs_encoding           write Set_legacy_windows_fs_encoding;
    {$ENDIF}
    /// <summary>
    /// <para>If True, enable the Python UTF-8 Mode.</para>
    /// <para>Set to False or True by the -X utf8 command line option and the
    /// PYTHONUTF8 environment variable.</para>
    /// <para>Also set to True if the LC_CTYPE locale is C or POSIX.</para>
    /// <para>Default: True in Python config and False in isolated
    /// config.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONUTF8">See the article about PYTHONUTF8.</see></para>
    /// <para><see href="https://docs.python.org/3/library/os.html#utf8-mode">See the article about Python UTF-8 Mode.</see></para>
    /// </remarks>
    property utf8_mode                   : integer            read Get_utf8_mode                            write Set_utf8_mode;
    /// <summary>
    /// <para>If True, enable the Python Development Mode.</para>
    /// <para>Set to True by the -X dev option and the PYTHONDEVMODE environment
    /// variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/devmode.html#devmode">See the article about Python Development Mode.</see></para>
    /// </remarks>
    property dev_mode                    : boolean            read Get_dev_mode                             write Set_dev_mode;
    /// <summary>
    /// Name of the Python memory allocator.
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/memory.html#memory">See the Memory Management article.</see></para>
    /// <para>See PyMemAllocatorName.</para>
    /// </remarks>
    property allocator                   : PyMemAllocatorName read Get_allocator                            write Set_allocator;
  end;

  IPyConfig = interface
    ['{1BA914A8-FFF7-4F49-AA5A-95808CCF8AFB}']
    function GetConfig: Pointer;
    function Get_argv: TStringDynArray;
    function Get_base_exec_prefix: string;
    function Get_base_executable: string;
    function Get_base_prefix: string;
    function Get_buffered_stdio: boolean;
    function Get_bytes_warning: integer;
    function Get_check_hash_pycs_mode: string;
    function Get_code_debug_ranges: boolean;
    function Get_configure_c_stdio: boolean;
    function Get_context_aware_warnings: boolean;
    {$IFDEF APPLE}
    function Get_use_system_logger: boolean;
    {$ENDIF}
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
    {$IFDEF MSWINDOWS}
    function Get_legacy_windows_stdio: boolean;
    {$ENDIF}
    function Get_malloc_stats: boolean;
    function Get_module_search_paths: string;
    function Get_module_search_paths_set: boolean;
    function Get_optimization_level: TPyOptimizationLevel;
    function Get_orig_argv: TStringDynArray;
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
    function Get_remote_debug: boolean;
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
    function Get_warnoptions: TStringDynArray;
    function Get_write_bytecode: boolean;
    function Get_xoptions: TStringDynArray;

    procedure Set_argv(const aValue: TStringDynArray);
    procedure Set_base_exec_prefix(const aValue: string);
    procedure Set_base_executable(const aValue: string);
    procedure Set_base_prefix(const aValue: string);
    procedure Set_buffered_stdio(aValue: boolean);
    procedure Set_bytes_warning(aValue: integer);
    procedure Set_check_hash_pycs_mode(const aValue: string);
    procedure Set_code_debug_ranges(aValue: boolean);
    procedure Set_configure_c_stdio(aValue: boolean);
    procedure Set_context_aware_warnings(aValue: boolean);
    {$IFDEF APPLE}
    procedure Set_use_system_logger(aValue: boolean);
    {$ENDIF}
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
    {$IFDEF MSWINDOWS}
    procedure Set_legacy_windows_stdio(aValue: boolean);
    {$ENDIF}
    procedure Set_malloc_stats(aValue: boolean);
    procedure Set_module_search_paths(const aValue: string);
    procedure Set_module_search_paths_set(aValue: boolean);
    procedure Set_optimization_level(aValue: TPyOptimizationLevel);
    procedure Set_orig_argv(const aValue: TStringDynArray);
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
    procedure Set_remote_debug(aValue: boolean);
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
    procedure Set_warnoptions(const aValue: TStringDynArray);
    procedure Set_write_bytecode(aValue: boolean);
    procedure Set_xoptions(const aValue: TStringDynArray);

    /// <summary>
    /// Copy the string SrcString into DstString.
    /// </summary>
    function SetWCharT(var DstString: PWCharT; const SrcString: string): boolean;
    /// <summary>
    /// Copy the wide character string SrcString into DstString.
    /// </summary>
    function SetString(var DstString: PWCharT; SrcString: WCharTString): IPyStatus;
    /// <summary>
    /// Decode SrcString using Py_DecodeLocale() and set the result into
    /// DstString.
    /// </summary>
    function SetBytesString(var DstString: PWCharT; SrcString: AnsiString): IPyStatus;
    /// <summary>
    /// Set command line arguments (argv member of config) from the argv array
    /// of wide character strings.
    /// </summary>
    function SetArgv(argc: integer; const argv: array of PWCharT): IPyStatus; overload;
    /// <summary>
    /// Set command line arguments (argv member of config) from a TStringList.
    /// </summary>
    function SetArgv(const items: TStringList): boolean; overload;
    /// <summary>
    /// Set command line arguments (argv member of config) from a
    /// TStringDynArray.
    /// </summary>
    function SetArgv(const items: TStringDynArray): boolean; overload;
    /// <summary>
    /// Set command line arguments (argv member of config) from the argv array
    /// of bytes strings. Decode bytes using Py_DecodeLocale().
    /// </summary>
    function SetBytesArgv(argc: integer; const argv: array of PAnsiChar): IPyStatus;
    /// <summary>
    /// Set the list of wide strings "list" to "length" and "items".
    /// </summary>
    function SetWideStringList(var list: PyWideStringList; length: integer; items: array of PWCharT): IPyStatus; overload;
    /// <summary>
    /// Set the list of wide strings "list" to the "items" TStringList.
    /// </summary>
    function SetWideStringList(var list: PyWideStringList; const items: TStringList): boolean; overload;
    /// <summary>
    /// Set the list of wide strings "list" to the "items" TStringDynArray.
    /// </summary>
    function SetWideStringList(var list: PyWideStringList; const items: TStringDynArray): boolean; overload;

    /// <summary>
    /// Initialize configuration with the "Python Configuration".
    /// </summary>
    procedure   InitPythonConfig;
    /// <summary>
    /// Initialize configuration with the "Isolated Configuration".
    /// </summary>
    procedure   InitIsolatedConfig;
    /// <summary>
    /// <para>Read all Python configuration.</para>
    /// <para>Fields which are already initialized are left unchanged.</para>
    /// <para>Fields for path configuration are no longer calculated or modified
    /// when calling this function, as of Python 3.11.</para>
    /// <para>The PyConfig_Read() function only parses PyConfig.argv arguments
    /// once: PyConfig.parse_argv is set to 2 after arguments are parsed. Since
    /// Python arguments are stripped from PyConfig.argv, parsing arguments
    /// twice would parse the application options as Python options.</para>
    /// <para>Changed in version 3.10: The PyConfig.argv arguments are now only
    /// parsed once, PyConfig.parse_argv is set to 2 after arguments are parsed,
    /// and arguments are only parsed if PyConfig.parse_argv equals 1.</para>
    /// <para>Changed in version 3.11: PyConfig_Read() no longer calculates all
    /// paths, and so fields listed under Python Path Configuration may no
    /// longer be updated until Py_InitializeFromConfig() is called.</para>
    /// </summary>
    function    Read: IPyStatus;
    /// <summary>
    /// Pointer to the PyConfig record.
    /// </summary>
    property Config                    : Pointer              read GetConfig;
    /// <summary>
    /// <para>Set sys.argv command line arguments based on argv. These
    /// parameters are similar to those passed to the program's main()
    /// function with the difference that the first entry should refer to the
    /// script file to be executed rather than the executable hosting the
    /// Python interpreter. If there isn't a script that will be run, the
    /// first entry in argv can be an empty string.</para>
    /// <para>Set parse_argv to True to parse argv the same way the regular
    /// Python parses Python command line arguments and then to strip Python
    /// arguments from argv.</para>
    /// <para>If argv is empty, an empty string is added to ensure that
    /// sys.argv always exists and is never empty.</para>
    /// </summary>
    /// <remarks>
    /// <para>See also the orig_argv member.</para>
    /// </remarks>
    property argv                      : TStringDynArray      read Get_argv                         write Set_argv;
    /// <summary>
    /// <para>Equivalent to exec_prefix, but referring to the base Python
    /// installation.</para>
    /// <para>When running under Virtual Environments, exec_prefix gets
    /// overwritten to the virtual environment prefix. base_exec_prefix,
    /// conversely, does not change, and always points to the base Python
    /// installation.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys_path_init.html#sys-path-init-virtual-environments">Refer to Virtual Environments for more information.</see></para>
    /// <para>See also PyConfig.exec_prefix.</para>
    /// </remarks>
    property base_exec_prefix          : string               read Get_base_exec_prefix             write Set_base_exec_prefix;
    /// <summary>
    /// <para>Python base executable: sys._base_executable.</para>
    /// <para>Set by the __PYVENV_LAUNCHER__ environment variable.</para>
    /// <para>Set from PyConfig.executable if empty.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para>See also PyConfig.executable.</para>
    /// </remarks>
    property base_executable           : string               read Get_base_executable              write Set_base_executable;
    /// <summary>
    /// <para>Equivalent to prefix, but referring to the base Python
    /// installation.</para>
    /// <para>When running under virtual environment, prefix gets overwritten
    /// to the virtual environment prefix. base_prefix, conversely, does not
    /// change, and always points to the base Python installation.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys_path_init.html#sys-path-init-virtual-environments">Refer to Virtual Environments for more information.</see></para>
    /// <para>See also PyConfig.prefix.</para>
    /// </remarks>
    property base_prefix               : string               read Get_base_prefix                  write Set_base_prefix;
    /// <summary>
    /// <para>If equals to False and configure_c_stdio is True, disable
    /// buffering on the C streams stdout and stderr.</para>
    /// <para>Set to False by the -u command line option and the
    /// PYTHONUNBUFFERED environment variable.</para>
    /// <para>stdin is always opened in buffered mode.</para>
    /// <para>Default: True.</para>
    /// </summary>
    property buffered_stdio            : boolean              read Get_buffered_stdio               write Set_buffered_stdio;
    /// <summary>
    /// <para>If equals to 1, issue a warning when comparing bytes or
    /// bytearray with str, or comparing bytes with int.</para>
    /// <para>If equal or greater to 2, raise a BytesWarning exception in
    /// these cases.</para>
    /// <para>Incremented by the -b command line option.</para>
    /// <para>Default: 0.</para>
    /// </summary>
    property bytes_warning             : integer              read Get_bytes_warning                write Set_bytes_warning;
    /// <summary>
    /// <para>Control the validation behavior of hash-based .pyc files: value
    /// of the --check-hash-based-pycs command line option.</para>
    /// <para>Valid values:</para>
    /// <code>
    /// - "always": Hash the source file for invalidation regardless of value
    ///   of the 'check_source' flag.
    /// - "never": Assume that hash-based pycs always are valid.
    /// - "default": The 'check_source' flag in hash-based pycs determines
    ///   invalidation.
    /// </code>
    /// <para>Default: "default".</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://peps.python.org/pep-0552/">See also PEP 552 "Deterministic pycs".</see></para>
    /// </remarks>
    property check_hash_pycs_mode      : string               read Get_check_hash_pycs_mode         write Set_check_hash_pycs_mode;
    /// <summary>
    /// <para>If equals to False, disables the inclusion of the end line and
    /// column mappings in code objects. Also disables traceback printing
    /// carets to specific error locations.</para>
    /// <para>Set to False by the PYTHONNODEBUGRANGES environment variable
    /// and by the -X no_debug_ranges command line option.</para>
    /// <para>Default: True.</para>
    /// </summary>
    property code_debug_ranges         : boolean              read Get_code_debug_ranges            write Set_code_debug_ranges;
    /// <summary>
    /// <para>If True, configure C standard streams:</para>
    /// <code>
    /// - On Windows, set the binary mode (O_BINARY) on stdin, stdout and
    ///   stderr.
    /// - If buffered_stdio equals zero, disable buffering of stdin, stdout
    ///   and stderr streams.
    /// - If interactive is non-zero, enable stream buffering on stdin and
    ///   stdout (only stdout on Windows).
    /// </code>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property configure_c_stdio         : boolean              read Get_configure_c_stdio            write Set_configure_c_stdio;
    /// <summary>
    /// <para>The 'context_aware_warnings' field exists to control whether the
    /// 'warnings.catch_warnings()' context manager behaves
    /// *concurrently safely*.</para>
    /// <code>
    /// - When 'context_aware_warnings' is **true**, 'catch_warnings' uses a
    ///   'ContextVar' to store the temporarily-established warning filter
    ///   state, so using it is safe across **threads and asyncio tasks**.
    /// - When 'context_aware_warnings' is **false**, 'catch_warnings' falls
    ///   back to modifying **global state** in the 'warnings' module, which
    ///   is **not safe** in concurrent programs (thread/async behavior can
    ///   become undefined).
    /// </code>
    /// <para>It can also be set via the '-X context_aware_warnings'
    /// command-line option or the 'PYTHON_CONTEXT_AWARE_WARNINGS' environment
    /// variable. '<citation src="1"></citation>'</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHON_CONTEXT_AWARE_WARNINGS">See the article about PYTHON_CONTEXT_AWARE_WARNINGS.</see></para>
    /// </remarks>
    property context_aware_warnings    : boolean              read Get_context_aware_warnings       write Set_context_aware_warnings;
    {$IFDEF APPLE}
    /// <summary>
    /// <para>If non-zero, stdout and stderr will be redirected to the system
    /// log.</para>
    /// <para>Only available on macOS 10.12 and later, and on iOS.</para>
    /// <para>Default: False (don't use the system log) on macOS; True on iOS
    /// (use the system log).</para>
    /// <para>Added in version 3.14.</para>
    /// </summary>
    property use_system_logger         : boolean              read Get_use_system_logger            write Set_use_system_logger;
    {$ENDIF}
    /// <summary>
    /// <para>If the value of cpu_count is not -1 then it will override the
    /// return values of os.cpu_count(), os.process_cpu_count(), and
    /// multiprocessing.cpu_count().</para>
    /// <para>Configured by the -X cpu_count=n|default command line flag or
    /// the PYTHON_CPU_COUNT environment variable.</para>
    /// <para>Default: -1.</para>
    /// </summary>
    property cpu_count                 : integer              read Get_cpu_count                    write Set_cpu_count;
    /// <summary>
    /// <para>If True, enable the Python Development Mode.</para>
    /// <para>Set to True by the -X dev option and the PYTHONDEVMODE
    /// environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/devmode.html#devmode">See the article about Python Development Mode.</see></para>
    /// </remarks>
    property dev_mode                  : boolean              read Get_dev_mode                     write Set_dev_mode;
    /// <summary>
    /// <para>Dump Python references?</para>
    /// <para>If True, dump all objects which are still alive at exit.</para>
    /// <para>Set to True by the PYTHONDUMPREFS environment variable.</para>
    /// <para>Needs a special build of Python with the Py_TRACE_REFS macro
    /// defined: see the configure --with-trace-refs option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property dump_refs                 : boolean              read Get_dump_refs                    write Set_dump_refs;
    /// <summary>
    /// <para>Filename where to dump Python references. Set by the
    /// PYTHONDUMPREFSFILE environment variable.</para>
    /// </summary>
    property dump_refs_file            : string               read Get_dump_refs_file               write Set_dump_refs_file;
    /// <summary>
    /// <para>The site-specific directory prefix where the platform-dependent
    /// Python files are installed: sys.exec_prefix.</para>
    /// <para>Part of the Python Path Configuration output.</para>
    /// <para>See also PyConfig.base_exec_prefix.</para>
    /// </summary>
    property exec_prefix               : string               read Get_exec_prefix                  write Set_exec_prefix;
    /// <summary>
    /// <para>The absolute path of the executable binary for the Python
    /// interpreter: sys.executable.</para>
    /// <para>Part of the Python Path Configuration output.</para>
    /// <para>See also PyConfig.base_executable.</para>
    /// </summary>
    property executable                : string               read Get_executable                   write Set_executable;
    /// <summary>
    /// <para>Enable faulthandler?</para>
    /// <para>If True, call faulthandler.enable() at startup.</para>
    /// <para>Set to True by -X faulthandler and the PYTHONFAULTHANDLER
    /// environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    property faulthandler              : integer              read Get_faulthandler                 write Set_faulthandler;
    /// <summary>
    /// <para>Filesystem encoding: sys.getfilesystemencoding().</para>
    /// <para>On macOS, Android and VxWorks: use "utf-8" by default.</para>
    /// <para>On Windows: use "utf-8" by default, or "mbcs" if
    /// legacy_windows_fs_encoding of PyPreConfig is non-zero.</para>
    /// <para>Default encoding on other platforms:</para>
    /// <code>
    /// - "utf-8" if PyPreConfig.utf8_mode is non-zero.
    /// - "ascii" if Python detects that nl_langinfo(CODESET) announces the
    ///   ASCII encoding, whereas the mbstowcs() function decodes from a
    ///   different encoding (usually Latin1).
    /// - "utf-8" if nl_langinfo(CODESET) returns an empty string.
    /// </code>
    /// <para>Otherwise, use the locale encoding: nl_langinfo(CODESET)
    /// result.</para>
    /// <para>At Python startup, the encoding name is normalized to the Python
    /// codec name. For example, "ANSI_X3.4-1968" is replaced with
    /// "ascii".</para>
    /// <para>See also the filesystem_errors member.</para>
    /// </summary>
    property filesystem_encoding       : string               read Get_filesystem_encoding          write Set_filesystem_encoding;
    /// <summary>
    /// <para>Filesystem error handler: sys.getfilesystemencodeerrors().</para>
    /// <para>On Windows: use "surrogatepass" by default, or "replace" if
    /// legacy_windows_fs_encoding of PyPreConfig is non-zero.</para>
    /// <para>On other platforms: use "surrogateescape" by default.</para>
    /// <para>Supported error handlers:</para>
    /// <code>
    /// - "strict"
    /// - "surrogateescape"
    /// - "surrogatepass" (only supported with the UTF-8 encoding)
    /// </code>
    /// <para>See also the filesystem_encoding member.</para>
    /// </summary>
    property filesystem_errors         : string               read Get_filesystem_errors            write Set_filesystem_errors;
    /// <summary>
    /// <para>Hash seed</para>
    /// </summary>
    property hash_seed                 : uint64               read Get_hash_seed                    write Set_hash_seed;
    /// <summary>
    /// <para>Set the default Python "home" directory, that is, the location
    /// of the standard Python libraries.</para>
    /// <para>Set by the PYTHONHOME environment variable.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONHOME">See the article about PYTHONHOME.</see></para>
    /// </remarks>
    property home                      : string               read Get_home                         write Set_home;
    /// <summary>
    /// <para>If 1, profile import time. If 2, include additional output that
    /// indicates when an imported module has already been loaded.</para>
    /// <para>Set by the -X importtime option and the PYTHONPROFILEIMPORTTIME
    /// environment variable.</para>
    /// <para>Default: 0.</para>
    /// <para>Changed in version 3.14: Added support for import_time = 2</para>
    /// </summary>
    property import_time               : integer              read Get_import_time                  write Set_import_time;
    /// <summary>
    /// <para>Enter interactive mode after executing a script or a
    /// command.</para>
    /// <para>If True, enable inspect: when a script is passed as first
    /// argument or the -c option is used, enter interactive mode after
    /// executing the script or the command, even when sys.stdin does not
    /// appear to be a terminal.</para>
    /// <para>Enabled by the -i command line option. Set to True if the
    /// PYTHONINSPECT environment variable is non-empty.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property inspect                   : boolean              read Get_inspect                      write Set_inspect;
    /// <summary>
    /// <para>Install Python signal handlers?</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    property install_signal_handlers   : boolean              read Get_install_signal_handlers      write Set_install_signal_handlers;
    /// <summary>
    /// <para>Configures the integer string conversion length limitation. An
    /// initial value of -1 means the value will be taken from the command
    /// line or environment or otherwise default to 4300
    /// (sys.int_info.default_max_str_digits). A value of 0 disables the
    /// limitation. Values greater than zero but less than 640
    /// (sys.int_info.str_digits_check_threshold) are unsupported and will
    /// produce an error.</para>
    /// <para>Configured by the -X int_max_str_digits command line flag or the
    /// PYTHONINTMAXSTRDIGITS environment variable.</para>
    /// <para>Default: -1 in Python mode. 4300
    /// (sys.int_info.default_max_str_digits) in isolated mode.</para>
    /// <para>Added in version 3.12.</para>
    /// </summary>
    property int_max_str_digits        : integer              read Get_int_max_str_digits           write Set_int_max_str_digits;
    /// <summary>
    /// <para>If True, enable the interactive mode (REPL).</para>
    /// <para>Enabled by the -i command line option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property interactive               : boolean              read Get_interactive                  write Set_interactive;
    /// <summary>
    /// <para>If True, enable isolated mode:</para>
    /// <code>
    /// - Set safe_path to True: don't prepend a potentially unsafe path to
    ///   sys.path at Python startup, such as the current directory, the
    ///   script's directory or an empty string.
    /// - Set use_environment to False: ignore PYTHON environment variables.
    /// - Set user_site_directory to False: don't add the user site directory
    ///   to sys.path.
    /// - Python REPL doesn't import readline nor enable default readline
    ///   configuration on interactive prompts.
    /// </code>
    /// <para>Set to True by the -I command line option.</para>
    /// <para>Default: False in Python mode, True in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#isolated-configuration">See the article about Isolated Configuration.</see></para>
    /// </remarks>
    property isolated                  : boolean              read Get_isolated                     write Set_isolated;
    {$IFDEF MSWINDOWS}
    /// <summary>
    /// <para>If True, use io.FileIO instead of io._WindowsConsoleIO for
    /// sys.stdin, sys.stdout and sys.stderr.</para>
    /// <para>Set to True if the PYTHONLEGACYWINDOWSSTDIO environment variable
    /// is set to a non-empty string.</para>
    /// <para>Only available on Windows. #ifdef MS_WINDOWS macro can be used
    /// for Windows specific code.</para>
    /// <para>Default: False.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://peps.python.org/pep-0528/">See also the PEP 528 (Change Windows console encoding to UTF-8).</see></para>
    /// </remarks>
    property legacy_windows_stdio      : boolean              read Get_legacy_windows_stdio         write Set_legacy_windows_stdio;
    {$ENDIF}
    /// <summary>
    /// <para>If True, dump statistics on Python pymalloc memory allocator at
    /// exit.</para>
    /// <para>Set to True by the PYTHONMALLOCSTATS environment variable.</para>
    /// <para>The option is ignored if Python is configured using the
    /// --without-pymalloc option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property malloc_stats              : boolean              read Get_malloc_stats                 write Set_malloc_stats;
    /// <summary>
    /// <para>A list of strings that specifies the search path for
    /// modules.</para>
    /// <para>Initialized from the environment variable PYTHONPATH, plus an
    /// installation-dependent default.</para>
    /// <para>If module_search_paths_set is False, Py_InitializeFromConfig()
    /// will replace module_search_paths and sets module_search_paths_set to
    /// True.</para>
    /// <para>Default: empty list.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys.path">See the article about sys.path.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH">See the article about PYTHONPATH.</see></para>
    /// </remarks>
    property module_search_paths       : string               read Get_module_search_paths          write Set_module_search_paths;
    /// <summary>
    /// <para>If module_search_paths_set is False, Py_InitializeFromConfig()
    /// will replace module_search_paths and sets module_search_paths_set to
    /// True.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property module_search_paths_set   : boolean              read Get_module_search_paths_set      write Set_module_search_paths_set;
    /// <summary>
    /// <para>Compilation optimization level:</para>
    /// <code>
    /// - polDebug (0) : Peephole optimizer, set __debug__ to True.
    /// - polRelease (1) : Level 0, remove assertions, set __debug__ to False.
    /// - polReleaseNoDocStrings (2) : Level 1, strip docstrings.
    /// </code>
    /// <para>Incremented by the -O command line option. Set to the
    /// PYTHONOPTIMIZE environment variable value.</para>
    /// <para>Default: polDebug (0).</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONOPTIMIZE">See the article about PYTHONOPTIMIZE.</see></para>
    /// </remarks>
    property optimization_level        : TPyOptimizationLevel read Get_optimization_level           write Set_optimization_level;
    /// <summary>
    /// <para>The list of the original command line arguments passed to the
    /// Python executable: sys.orig_argv.</para>
    /// <para>If orig_argv list is empty and argv is not a list only
    /// containing an empty string, PyConfig_Read() copies argv into orig_argv
    /// before modifying argv (if parse_argv is non-zero).</para>
    /// <para>See also the argv member and the Py_GetArgcArgv()
    /// function.</para>
    /// <para>Default: empty list.</para>
    /// <para>Added in version 3.10.</para>
    /// </summary>
    property orig_argv                 : TStringDynArray      read Get_orig_argv                    write Set_orig_argv;
    /// <summary>
    /// <para>Parse command line arguments?</para>
    /// <para>If True, parse argv the same way the regular Python parses
    /// command line arguments, and strip Python arguments from argv.</para>
    /// <para>The PyConfig_Read() function only parses PyConfig.argv arguments
    /// once: PyConfig.parse_argv is set to True after arguments are parsed.
    /// Since Python arguments are stripped from PyConfig.argv, parsing
    /// arguments twice would parse the application options as Python
    /// options.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// <para>Changed in version 3.10: The PyConfig.argv arguments are now
    /// only parsed once.</para>
    /// </summary>
    property parse_argv                : boolean              read Get_parse_argv                   write Set_parse_argv;
    /// <summary>
    /// <para>Parser debug mode. If True, turn on parser debugging output
    /// (for expert only, depending on compilation options).</para>
    /// <para>Enabled by the -d command line option. Set to the PYTHONDEBUG
    /// environment variable value.</para>
    /// <para>Needs a debug build of Python (the Py_DEBUG macro must be
    /// defined).</para>
    /// <para>Default: False.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONDEBUG">See the article about PYTHONDEBUG.</see></para>
    /// </remarks>
    property parser_debug              : boolean              read Get_parser_debug                 write Set_parser_debug;
    /// <summary>
    /// <para>If True, calculation of path configuration is allowed to log
    /// warnings into stderr. If False, suppress these warnings.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// <para>Changed in version 3.11: Now also applies on Windows.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// </remarks>
    property pathconfig_warnings       : boolean              read Get_pathconfig_warnings          write Set_pathconfig_warnings;
    /// <summary>
    /// <para>Enable the Linux perf profiler support?</para>
    /// <para>If equals to 1, enable support for the Linux perf
    /// profiler.</para>
    /// <para>If equals to 2, enable support for the Linux perf profiler with
    /// DWARF JIT support.</para>
    /// <para>Set to 1 by -X perf command-line option and the
    /// PYTHONPERFSUPPORT environment variable.</para>
    /// <para>Set to 2 by the -X perf_jit command-line option and the
    /// PYTHON_PERF_JIT_SUPPORT environment variable.</para>
    /// <para>Default: -1.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/howto/perf_profiling.html#perf-profiling">See Python support for the Linux perf profiler for more information.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPERFSUPPORT">See the article about PYTHONPERFSUPPORT.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHON_PERF_JIT_SUPPORT">See the article about PYTHON_PERF_JIT_SUPPORT.</see></para>
    /// </remarks>
    property perf_profiling            : integer              read Get_perf_profiling               write Set_perf_profiling;
    /// <summary>
    /// <para>Platform library directory name: sys.platlibdir.</para>
    /// <para>Name of the platform-specific library directory. It is used to
    /// build the path of standard library and the paths of installed
    /// extension modules.</para>
    /// <para>Set by the PYTHONPLATLIBDIR environment variable.</para>
    /// <para>Default: value of the PLATLIBDIR macro which is set by the
    /// configure --with-platlibdir option (default: "lib", or "DLLs" on
    /// Windows).</para>
    /// <para>Added in version 3.9.</para>
    /// <para>Changed in version 3.11: This macro is now used on Windows to
    /// locate the standard library extension modules, typically under DLLs.
    /// However, for compatibility, note that this value is ignored for any
    /// non-standard layouts, including in-tree builds and virtual
    /// environments.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPLATLIBDIR">See the article about PYTHONPLATLIBDIR.</see></para>
    /// </remarks>
    property platlibdir                : string               read Get_platlibdir                   write Set_platlibdir;
    /// <summary>
    /// <para>The site-specific directory prefix where the platform
    /// independent Python files are installed: sys.prefix.</para>
    /// <para>A string giving the site-specific directory prefix where the
    /// platform independent Python files are installed; on Unix, the default
    /// is /usr/local. This can be set at build time with the --prefix
    /// argument to the configure script.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para>See also PyConfig.base_prefix.</para>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys.prefix">See the article about sys.prefix.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sysconfig.html#installation-paths">See Installation paths for derived paths.</see></para>
    /// </remarks>
    property prefix                    : string               read Get_prefix                       write Set_prefix;
    /// <summary>
    /// <para>Program name used to initialize executable and in early error
    /// messages during Python initialization.</para>
    /// <para>On macOS, use PYTHONEXECUTABLE environment variable if
    /// set.</para>
    /// <para>If the WITH_NEXT_FRAMEWORK macro is defined, use
    /// __PYVENV_LAUNCHER__ environment variable if set.</para>
    /// <para>Use argv[0] of argv if available and non-empty.</para>
    /// <para>Otherwise, use "python" on Windows, or "python3" on other
    /// platforms.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONEXECUTABLE">See the article about PYTHONEXECUTABLE.</see></para>
    /// <para>See PyConfig.executable and PyConfig.base_executable.</para>
    /// </remarks>
    property program_name              : string               read Get_program_name                 write Set_program_name;
    /// <summary>
    /// <para>Directory where cached .pyc files are written:
    /// sys.pycache_prefix.</para>
    /// <para>Set by the -X pycache_prefix=PATH command line option and the
    /// PYTHONPYCACHEPREFIX environment variable. The command-line option
    /// takes precedence.</para>
    /// <para>If empty, sys.pycache_prefix is set to None.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPYCACHEPREFIX">See the article about PYTHONPYCACHEPREFIX.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys.pycache_prefix">See the article about sys.pycache_prefix.</see></para>
    /// </remarks>
    property pycache_prefix            : string               read Get_pycache_prefix               write Set_pycache_prefix;
    /// <summary>
    /// <para>Set by the PYTHONPATH environment variable.</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH">See the article about PYTHONPATH.</see></para>
    /// </remarks>
    property pythonpath_env            : string               read Get_pythonpath_env               write Set_pythonpath_env;
    /// <summary>
    /// <para>Quiet mode. If True, don't display the copyright and version at
    /// Python startup in interactive mode.</para>
    /// <para>Enabled by the -q command line option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property quiet                     : boolean              read Get_quiet                        write Set_quiet;
    /// <summary>
    /// <para>Safe external debugger interface for CPython.</para>
    /// <para>Default: True.</para>
    /// <para>Added in version 3.14.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/configure.html#cmdoption-without-remote-debug">See the article about --without-remote-debug</see></para>
    /// <para><see href="https://peps.python.org/pep-0768/">See the PEP 768.</see></para>
    /// </remarks>
    property remote_debug              : boolean              read Get_remote_debug                 write Set_remote_debug;
    /// <summary>
    /// <para>Value of the -c command line option.</para>
    /// <para>Used by Py_RunMain().</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    property run_command               : string               read Get_run_command                  write Set_run_command;
    /// <summary>
    /// <para>Filename passed on the command line: trailing command line
    /// argument without -c or -m. It is used by the Py_RunMain()
    /// function.</para>
    /// <para>For example, it is set to script.py by the python3 script.py
    /// arg command line.</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#c.PyConfig.skip_source_first_line">See also the PyConfig.skip_source_first_line option.</see></para>
    /// </remarks>
    property run_filename              : string               read Get_run_filename                 write Set_run_filename;
    /// <summary>
    /// <para>Value of the -m command line option.</para>
    /// <para>Used by Py_RunMain().</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    property run_module                : string               read Get_run_module                   write Set_run_module;
    /// <summary>
    /// <para>If equals to zero, Py_RunMain() prepends a potentially unsafe
    /// path to sys.path at startup:</para>
    /// <code>
    /// - If argv[0] is equal to "-m" (python -m module), prepend the current
    ///   working directory.
    /// - If running a script (python script.py), prepend the script's
    ///   directory. If it's a symbolic link, resolve symbolic links.
    /// - Otherwise (python -c code and python), prepend an empty string,
    ///   which means the current working directory.
    /// </code>
    /// <para>Set to 1 by the -P command line option and the PYTHONSAFEPATH
    /// environment variable.</para>
    /// <para>Default: False in Python config, True in isolated config.</para>
    /// <para>Added in version 3.11.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSAFEPATH">See the article about PYTHONSAFEPATH.</see></para>
    /// </remarks>
    property safe_path                 : boolean              read Get_safe_path                    write Set_safe_path;
    /// <summary>
    /// <para>Show total reference count at exit (excluding immortal
    /// objects)?</para>
    /// <para>Set to True by -X showrefcount command line option.</para>
    /// <para>Needs a debug build of Python (the Py_REF_DEBUG macro must be
    /// defined).</para>
    /// <para>Default: False.</para>
    /// </summary>
    property show_ref_count            : boolean              read Get_show_ref_count               write Set_show_ref_count;
    /// <summary>
    /// <para>Import the site module at startup?</para>
    /// <para>If equal to zero, disable the import of the module site and the
    /// site-dependent manipulations of sys.path that it entails.</para>
    /// <para>Also disable these manipulations if the site module is
    /// explicitly imported later (call site.main() if you want them to be
    /// triggered).</para>
    /// <para>Set to False by the -S command line option.</para>
    /// <para>sys.flags.no_site is set to the inverted value of
    /// site_import.</para>
    /// <para>Default: True.</para>
    /// </summary>
    property site_import               : boolean              read Get_site_import                  write Set_site_import;
    /// <summary>
    /// <para>If non-zero, skip the first line of the PyConfig.run_filename
    /// source.</para>
    /// <para>It allows the usage of non-Unix forms of #!cmd. This is intended
    /// for a DOS specific hack only.</para>
    /// <para>Set to True by the -x command line option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property skip_source_first_line    : boolean              read Get_skip_source_first_line       write Set_skip_source_first_line;
    /// <summary>
    /// <para>Encoding of sys.stdin, sys.stdout and sys.stderr (but sys.stderr
    /// always uses "backslashreplace" error handler).</para>
    /// <para>Use the PYTHONIOENCODING environment variable if it is
    /// non-empty.</para>
    /// <para>Default encoding:</para>
    /// <code>
    /// - "UTF-8" if PyPreConfig.utf8_mode is non-zero.
    /// - Otherwise, use the locale encoding.
    /// </code>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONIOENCODING">See the article about PYTHONIOENCODING.</see></para>
    /// <para>See also PyConfig.legacy_windows_stdio.</para>
    /// </remarks>
    property stdio_encoding            : string               read Get_stdio_encoding               write Set_stdio_encoding;
    /// <summary>
    /// <para>Encoding errors of sys.stdin, sys.stdout and sys.stderr (but
    /// sys.stderr always uses "backslashreplace" error handler).</para>
    /// <para>Use the PYTHONIOENCODING environment variable if it is
    /// non-empty.</para>
    /// <para>Default error handler:</para>
    /// <code>
    /// - On Windows: use "surrogateescape".
    /// - "surrogateescape" if PyPreConfig.utf8_mode is non-zero, or if the
    ///   LC_CTYPE locale is "C" or "POSIX".
    /// - "strict" otherwise.
    /// </code>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONIOENCODING">See the article about PYTHONIOENCODING.</see></para>
    /// <para>See also PyConfig.legacy_windows_stdio.</para>
    /// </remarks>
    property stdio_errors              : string               read Get_stdio_errors                 write Set_stdio_errors;
    /// <summary>
    /// <para>Directory of the Python standard library.</para>
    /// <para>Default: Empty.</para>
    /// <para>Added in version 3.11.</para>
    /// </summary>
    property stdlib_dir                : string               read Get_stdlib_dir                   write Set_stdlib_dir;
    /// <summary>
    /// <para>PyConfig.sys_path_0 is the value that Python uses as the first
    /// entry in sys.path (sys.path[0]) when the interpreter runs.</para>
    /// <para>In particular, it determines what sys.path[0] becomes for
    /// different invocation styles, for example:</para>
    /// <code>
    /// - for python -m module, sys.path[0] is set to include the current
    ///   working directory,
    /// - for python script.py, it's set to the script's directory,
    /// - for python -c code / plain python, it's set to an "empty string"
    ///   meaning the current working directory.
    /// </code>
    /// <para>So, when embedding Python via the C-API, setting
    /// PyConfig.sys_path_0 lets you control that first sys.path entry
    /// explicitly (instead of letting Python compute it).</para>
    /// </summary>
    property sys_path_0                : string               read Get_sys_path_0                   write Set_sys_path_0;
    /// <summary>
    /// <para>Whether the new thread should inherit the current "execution
    /// context" from the thread that created it.</para>
    /// <para>If thread_inherit_context is true, the new thread starts with
    /// that same context (so things like trace IDs, user IDs, request-scoped
    /// metadata, etc. propagate).</para>
    /// <para>If it's false, the new thread runs with a fresh/default context
    /// (so context doesn't automatically carry over).</para>
    /// </summary>
    property thread_inherit_context    : boolean              read Get_thread_inherit_context       write Set_thread_inherit_context;
    /// <summary>
    /// <para>Enable tracemalloc?</para>
    /// <para>If True, call tracemalloc.start() at startup.</para>
    /// <para>Set by -X tracemalloc=N command line option and by the
    /// PYTHONTRACEMALLOC environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONTRACEMALLOC">See the article about PYTHONTRACEMALLOC.</see></para>
    /// <para>See also PyConfig.legacy_windows_stdio.</para>
    /// </remarks>
    property tracemalloc               : boolean              read Get_tracemalloc                  write Set_tracemalloc;
    /// <summary>
    /// <para>Use environment variables?</para>
    /// <para>If False, ignore the environment variables.</para>
    /// <para>Set to False by the -E environment variable.</para>
    /// <para>Default: True in Python config and False in isolated
    /// config.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#using-on-envvars">See the article about environment variables.</see></para>
    /// </remarks>
    property use_environment           : boolean              read Get_use_environment              write Set_use_environment;
    /// <summary>
    /// <para>If True, use frozen modules.</para>
    /// <para>Set by the PYTHON_FROZEN_MODULES environment variable.</para>
    /// <para>Default: True in a release build, or False in a debug
    /// build.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHON_FROZEN_MODULES">See the article about PYTHON_FROZEN_MODULES.</see></para>
    /// </remarks>
    property use_frozen_modules        : boolean              read Get_use_frozen_modules           write Set_use_frozen_modules;
    /// <summary>
    /// <para>Randomized hash function seed.</para>
    /// <para>If use_hash_seed is zero, a seed is chosen randomly at Python
    /// startup, and hash_seed is ignored.</para>
    /// <para>Set by the PYTHONHASHSEED environment variable.</para>
    /// <para>Default use_hash_seed value: True in Python mode, False in
    /// isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONHASHSEED">See the article about PYTHONHASHSEED.</see></para>
    /// </remarks>
    property use_hash_seed             : boolean              read Get_use_hash_seed                write Set_use_hash_seed;
    /// <summary>
    /// <para>If True, add the user site directory to sys.path.</para>
    /// <para>Set to False by the -s and -I command line options.</para>
    /// <para>Set to False by the PYTHONNOUSERSITE environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONNOUSERSITE">See the article about PYTHONNOUSERSITE.</see></para>
    /// </remarks>
    property user_site_directory       : boolean              read Get_user_site_directory          write Set_user_site_directory;
    /// <summary>
    /// <para>Verbose mode. If pvmModule or pvmFull, print a message each time
    /// a module is imported, showing the place (filename or built-in module)
    /// from which it is loaded.</para>
    /// <para>If pvmFull, print a message for each file
    /// that is checked for when searching for a module. Also provides
    /// information on module cleanup at exit.</para>
    /// <para>Enabled by the -v command line option.</para>
    /// <para>Set by the PYTHONVERBOSE environment variable value.</para>
    /// <para>Default: pvmDisabled.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONVERBOSE">See the article about PYTHONVERBOSE.</see></para>
    /// </remarks>
    property verbose                   : TPyVerboseMode       read Get_verbose                      write Set_verbose;
    /// <summary>
    /// <para>If non-zero, emit a EncodingWarning warning when
    /// io.TextIOWrapper uses its default encoding.</para>
    /// <para>Default: False.</para>
    /// <para>Added in version 3.10.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/io.html#io-encoding-warning">See Opt-in EncodingWarning for details.</see></para>
    /// </remarks>
    property warn_default_encoding     : boolean              read Get_warn_default_encoding        write Set_warn_default_encoding;
    /// <summary>
    /// <para>Options of the warnings module to build warnings filters, lowest
    /// to highest priority: sys.warnoptions.</para>
    /// <para>The warnings module adds sys.warnoptions in the reverse order:
    /// the last PyConfig.warnoptions item becomes the first item of
    /// warnings.filters which is checked first (highest priority).</para>
    /// <para>The -W command line options adds its value to warnoptions, it
    /// can be used multiple times.</para>
    /// <para>The PYTHONWARNINGS environment variable can also be used to add
    /// warning options. Multiple options can be specified, separated by
    /// commas (,).</para>
    /// <para>Default: empty list.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONWARNINGS">See the article about PYTHONWARNINGS.</see></para>
    /// </remarks>
    property warnoptions               : TStringDynArray      read Get_warnoptions                  write Set_warnoptions;
    /// <summary>
    /// <para>If False, Python won't try to write .pyc files on the import of
    /// source modules.</para>
    /// <para>Set to False by the -B command line option and the
    /// PYTHONDONTWRITEBYTECODE environment variable.</para>
    /// <para>sys.dont_write_bytecode is initialized to the inverted value of
    /// write_bytecode.</para>
    /// <para>Default: True.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONDONTWRITEBYTECODE">See the article about PYTHONDONTWRITEBYTECODE.</see></para>
    /// </remarks>
    property write_bytecode            : boolean              read Get_write_bytecode               write Set_write_bytecode;
    /// <summary>
    /// <para>Values of the -X command line options: sys._xoptions.</para>
    /// <para>Default: empty list.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys._xoptions">See the article about sys._xoptions.</see></para>
    /// </remarks>
    property xoptions                  : TStringDynArray      read Get_xoptions                     write Set_xoptions;
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
