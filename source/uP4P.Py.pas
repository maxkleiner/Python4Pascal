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
  /// <summary>
  /// <para>Helper for all the Py_* functions.</para>
  /// </summary>
  TPy = class
    public
      /// <summary>
      /// <para>Print a fatal error message and kill the process. No cleanup is
      /// performed. This function should only be invoked when a condition is
      /// detected that would make it dangerous to continue using the Python
      /// interpreter; e.g., when the object administration appears to be
      /// corrupted. On Unix, the standard C library function abort() is called
      /// which will attempt to produce a core file.</para>
      /// <para>The TPy.FatalError() function is replaced with a macro which
      /// logs automatically the name of the current function, unless the
      /// Py_LIMITED_API macro is defined.</para>
      /// <para>Changed in version 3.9: Log the function name automatically.</para>
      /// </summary>
      class procedure FatalError(const message_: string);
      /// <summary>
      /// <para>Py_UniversalNewlineFgets is an fgets variation that understands
      /// all of \r, \n and \r\n conventions.</para>
      /// <para>The stream should be opened in binary mode.</para>
      /// <para>Note that we need no error handling: fgets() treats error and
      /// eof identically.</para>
      /// </summary>
      class function  UniversalNewlineFgets(buf: PByte; n: integer; stream: PFILE): PByte;
      /// <summary>
      /// <para>Get the original command line arguments, before Python modified
      /// them.</para>
      /// <para>See also PyConfig.orig_argv member.</para>
      /// </summary>
      class function  GetArgcArgv(var argc: integer; var argv: TStringList): boolean; overload;
      /// <summary>
      /// <para>Get the original command line arguments, before Python modified
      /// them.</para>
      /// <para>See also PyConfig.orig_argv member.</para>
      /// </summary>
      class function  GetArgcArgv(out argc: integer; out argv: PPWCharT): boolean; overload;
      /// <summary>
      /// <para>Initialize Python from the initialization configuration.</para>
      /// <para>Return True on success.</para>
      /// <para>Set an error in config and return False on error.</para>
      /// <para>Set an exit code in config and return False if Python wants to
      /// exit.</para>
      /// <para>See IPyInitConfig.Exitcode for the exit code case.</para>
      /// </summary>
      class function  InitializeFromInitConfig(const initconfig: IPyInitConfig): boolean;
      /// <summary>
      /// <para>Initialize Python from config configuration, as described in
      /// Initialization with PyConfig.</para>
      /// <para>See the Python Initialization Configuration section for details
      /// on pre-initializing the interpreter, populating the runtime
      /// configuration structure, and querying the returned status
      /// structure.</para>
      /// </summary>
      class function  InitializeFromConfig(config: PPyConfig): IPyStatus;
      /// <summary>
      /// <para>Return True when the Python interpreter has been initialized,
      /// False if not. After TPy.FinalizeEx() is called, this returns False
      /// until TPy.Initialize() is called again.</para>
      /// </summary>
      class function  IsIntialized: boolean;
      /// <summary>
      /// <para>Create a GenericAlias object. Equivalent to calling the Python
      /// class types.GenericAlias. The origin and args arguments set the
      /// GenericAlias‘s __origin__ and __args__ attributes respectively.
      /// origin should be a PyTypeObject*, and args can be a PyTupleObject* or
      /// any PyObject*. If args passed is not a tuple, a 1-tuple is
      /// automatically constructed and __args__ is set to (args,).
      /// Minimal checking is done for the arguments, so the function will
      /// succeed even if origin is not a type. The GenericAlias‘s
      /// __parameters__ attribute is constructed lazily from __args__.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/library/stdtypes.html#generic-alias-type">See the article about Generic Alias Type.</see></para>
      /// <para>See the TPyGenericAlias class.</para>
      /// </remarks>
      class function  GenericAlias(const origin, args: IPyObject): IPyObject;
      /// <summary>
      /// <para>Test if an object is the True singleton, the same as x is True
      /// in Python.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  IsTrue(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Test if an object is the False singleton, the same as x is False
      /// in Python.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  IsFalse(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Test if an object is the None singleton, the same as x is None
      /// in Python.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  IsNone(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Get the type of the Python object aPyObject.</para>
      /// <para>The returned reference is borrowed from aPyObject.</para>
      /// <para>Do not release it with Py_DECREF() or similar.</para>
      /// <para>Changed in version 3.11: Py_TYPE() is changed to an inline
      /// static function. The parameter type is no longer const PyObject*.</para>
      /// </summary>
      class function  Type_(const aPyObject: IPyObject): PPyTypeObject;
      /// <summary>
      /// <para>Return True if aPyObject's type is aPyTypeObject.</para>
      /// </summary>
      class function  IsType(const aPyObject: IPyObject; aPyTypeObject: PPyTypeObject): boolean;
      /// <summary>
      /// <para>Get the reference count of the Python object aPyObject.</para>
      /// <para>Note that the returned value may not actually reflect how many
      /// references to the object are actually held. For example, some objects
      /// are immortal and have a very high refcount that does not reflect the
      /// actual number of references. Consequently, do not rely on the returned
      /// value to be accurate, other than a value of 0 or 1.</para>
      /// <para>Use the Py_SET_REFCNT() function to set an object reference
      /// count.</para>
      /// <para>Note On free-threaded builds of Python, returning 1 isn’t
      /// sufficient to determine if it’s safe to treat o as having no access
      /// by other threads. Use PyUnstable_Object_IsUniquelyReferenced() for
      /// that instead.</para>
      /// <para>See also the function
      /// PyUnstable_Object_IsUniqueReferencedTemporary().</para>
      /// <para>Changed in version 3.10: Py_REFCNT() is changed to the inline
      /// static function.</para>
      /// <para>Changed in version 3.11: The parameter type is no longer const
      /// PyObject*.</para>
      /// </summary>
      class function  RefCnt(const aPyObject: IPyObject): integer;
      /// <summary>
      /// <para>Indicate taking a new strong reference to object aPyObject,
      /// indicating it is in use and should not be destroyed.</para>
      /// <para>This function has no effect on immortal objects.</para>
      /// <para>This function is usually used to convert a borrowed reference
      /// to a strong reference in-place. The Py_NewRef() function can be used
      /// to create a new strong reference.</para>
      /// <para>When done using the object, release is by calling
      /// Py_DECREF().</para>
      /// <para>The object must not be NULL; if you aren’t sure that it isn’t
      /// nil, use Py_XINCREF().</para>
      /// <para>Do not expect this function to actually modify aPyObject in any
      /// way. For at least some objects, this function has no effect.</para>
      /// <para>Changed in version 3.12: Immortal objects are not
      /// modified.</para>
      /// </summary>
      class procedure IncRef(const aPyObject: IPyObject); overload;
      /// <summary>
      /// <para>Indicate taking a new strong reference to object aPyObject,
      /// indicating it is in use and should not be destroyed.</para>
      /// <para>This function has no effect on immortal objects.</para>
      /// <para>This function is usually used to convert a borrowed reference
      /// to a strong reference in-place. The Py_NewRef() function can be used
      /// to create a new strong reference.</para>
      /// <para>When done using the object, release is by calling
      /// Py_DECREF().</para>
      /// <para>The object must not be NULL; if you aren’t sure that it isn’t
      /// nil, use Py_XINCREF().</para>
      /// <para>Do not expect this function to actually modify aPyObject in any
      /// way. For at least some objects, this function has no effect.</para>
      /// <para>Changed in version 3.12: Immortal objects are not
      /// modified.</para>
      /// </summary>
      class procedure IncRef(const aPyObject: PPyObject); overload;
      /// <summary>
      /// <para>Release a strong reference to object aPyObject, indicating the
      /// reference is no longer used.</para>
      /// <para>This function has no effect on immortal objects.</para>
      /// <para>Once the last strong reference is released (i.e. the object’s
      /// reference count reaches 0), the object’s type’s deallocation function
      /// (which must not be nil) is invoked.</para>
      /// <para>This function is usually used to delete a strong reference
      /// before exiting its scope.</para>
      /// <para>The object must not be NULL; if you aren’t sure that it isn’t
      /// nil, use Py_XDECREF().</para>
      /// <para>Do not expect this function to actually modify aPyObject in any
      /// way. For at least some objects, this function has no effect.</para>
      /// <para>Warning The deallocation function can cause arbitrary Python
      /// code to be invoked (e.g. when a class instance with a __del__() method
      /// is deallocated). While exceptions in such code are not propagated, the
      /// executed code has free access to all Python global variables. This
      /// means that any object that is reachable from a global variable should
      /// be in a consistent state before Py_DECREF() is invoked. For example,
      /// code to delete an object from a list should copy a reference to the
      /// deleted object in a temporary variable, update the list data
      /// structure, and then call Py_DECREF() for the temporary variable.</para>
      /// <para>Changed in version 3.12: Immortal objects are not modified.</para>
      /// </summary>
      class procedure DecRef(const aPyObject: IPyObject); overload;
      /// <summary>
      /// <para>Release a strong reference to object aPyObject, indicating the
      /// reference is no longer used.</para>
      /// <para>This function has no effect on immortal objects.</para>
      /// <para>Once the last strong reference is released (i.e. the object’s
      /// reference count reaches 0), the object’s type’s deallocation function
      /// (which must not be nil) is invoked.</para>
      /// <para>This function is usually used to delete a strong reference
      /// before exiting its scope.</para>
      /// <para>The object must not be NULL; if you aren’t sure that it isn’t
      /// nil, use Py_XDECREF().</para>
      /// <para>Do not expect this function to actually modify aPyObject in any
      /// way. For at least some objects, this function has no effect.</para>
      /// <para>Warning The deallocation function can cause arbitrary Python
      /// code to be invoked (e.g. when a class instance with a __del__() method
      /// is deallocated). While exceptions in such code are not propagated, the
      /// executed code has free access to all Python global variables. This
      /// means that any object that is reachable from a global variable should
      /// be in a consistent state before Py_DECREF() is invoked. For example,
      /// code to delete an object from a list should copy a reference to the
      /// deleted object in a temporary variable, update the list data
      /// structure, and then call Py_DECREF() for the temporary variable.</para>
      /// <para>Changed in version 3.12: Immortal objects are not modified.</para>
      /// </summary>
      class procedure DecRef(const aPyObject: PPyObject); overload;
      /// <summary>
      /// <para>Create a new strong reference to an object: call Py_INCREF() on
      /// aPyObject and return the object aPyObject.</para>
      /// <para>When the strong reference is no longer needed, Py_DECREF()
      /// should be called on it to release the reference.</para>
      /// <para>The object aPyObject must not be NULL; use XNewRef() if
      /// aPyObject can be nil.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  NewRef(const aPyObject: IPyObject): PPyObject; overload;
      /// <summary>
      /// <para>Create a new strong reference to an object: call Py_INCREF() on
      /// aPyObject and return the object aPyObject.</para>
      /// <para>When the strong reference is no longer needed, Py_DECREF()
      /// should be called on it to release the reference.</para>
      /// <para>The object aPyObject must not be NULL; use XNewRef() if
      /// aPyObject can be nil.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  NewRef(aPyObject: PPyConfig): PPyObject; overload;
      /// <summary>
      /// <para>Similar to NewRef(), but the object aPyObject can be nil.</para>
      /// <para>If the object aPyObject is nil, the function just returns
      /// nil.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  XNewRef(const aPyObject: IPyObject): PPyObject; overload;
      /// <summary>
      /// <para>Similar to NewRef(), but the object aPyObject can be nil.</para>
      /// <para>If the object aPyObject is nil, the function just returns
      /// nil.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  XNewRef(aPyObject: PPyConfig): PPyObject; overload;
      /// <summary>
      /// <para>Test if the x object is the y object, the same as x is y in
      /// Python.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  Is_(const x, y: IPyObject): boolean; overload;
      /// <summary>
      /// <para>Test if the x object is the y object, the same as x is y in
      /// Python.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  Is_(const x, y: PPyObject): boolean; overload;
      /// <summary>
      /// <para>Get a strong reference to a constant.</para>
      /// <para>Set an exception and return nil if constant_id is invalid.</para>
      /// <para>constant_id must be one of the Py_CONSTANT_* constant
      /// identifiers.</para>
      /// <para>Added in version 3.13.</para>
      /// <para>CPython implementation detail: In CPython, all of these
      /// constants are immortal.</para>
      /// </summary>
      class function  GetConstant(constant_id: cardinal): IPyObject;
      /// <summary>
      /// <para>Similar to GetConstant(), but return a borrowed reference.</para>
      /// <para>This function is primarily intended for backwards
      /// compatibility: using GetConstant() is recommended for new code.</para>
      /// <para>The reference is borrowed from the interpreter, and is valid
      /// until the interpreter finalization.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function  GetConstantBorrowed(constant_id: cardinal): IPyObject;
      /// <summary>
      /// <para>Called at the beginning of the tp_repr implementation to detect
      /// cycles.</para>
      /// <para>If the object has already been processed, the function returns
      /// a positive integer. In that case the tp_repr implementation should
      /// return a string object indicating a cycle. As examples, dict objects
      /// return {...} and list objects return [...].</para>
      /// <para>The function will return a negative integer if the recursion
      /// limit is reached. In that case the tp_repr implementation should
      /// typically return nil.</para>
      /// <para>Otherwise, the function returns zero and the tp_repr
      /// implementation can continue normally.</para>
      /// </summary>
      class function  ReprEnter(const aPyObject: IPyObject): Integer;
      /// <summary>
      /// <para>Ends a ReprEnter(). Must be called once for each invocation of
      /// ReprEnter() that returns zero.</para>
      /// </summary>
      class procedure ReprLeave(const aPyObject: IPyObject);
      /// <summary>
      /// <para>This is a simplified interface to CompileStringFlags(),
      /// leaving flags set to nil.</para>
      /// </summary>
      class function  CompileString(const str: string; const filename: string = DEFAULT_COMPILE_FILENAME; start: TPyStartSymbols = ssFile): IPyObject;
      /// <summary>
      /// <para>Like CompileStringObject(), but filename is a byte string
      /// decoded from the filesystem encoding and error handler.</para>
      /// </summary>
      class function  CompileStringExFlags(const str, filename: string; start: TPyStartSymbols; flags: PPyCompilerFlags; optimize: integer): IPyObject;
      /// <summary>
      /// <para>Parse and compile the Python source code in str, returning the
      /// resulting code object. The start symbol is given by start; this can
      /// be used to constrain the code which can be compiled and should be
      /// available start symbols. The filename specified by filename is used
      /// to construct the code object and may appear in tracebacks or
      /// SyntaxError exception messages. This returns nil if the code cannot
      /// be parsed or compiled.</para>
      /// <para>The integer optimize specifies the optimization level of the
      /// compiler; a value of -1 selects the optimization level of the
      /// interpreter as given by -O options.</para>
      /// <para>Explicit levels are 0 (no optimization; __debug__ is true),
      /// 1 (asserts are removed, __debug__ is false) or
      /// 2 (docstrings are removed too).</para>
      /// </summary>
      class function  CompileStringObject(const str: string; const filename: IPyObject; start: TPyStartSymbols; flags: PPyCompilerFlags; optimize: integer): IPyObject;
      /// <summary>
      /// <para>This is a simplified interface to CompileStringExFlags(),
      /// with optimize set to -1.</para>
      /// </summary>
      class function  CompileStringFlags(const str, filename: string; start: TPyStartSymbols; flags: PPyCompilerFlags): IPyObject;
      /// <summary>
      /// <para>Initialize the Python interpreter. In an application embedding
      /// Python, this should be called before using any other Python/C API
      /// functions; see Before Python Initialization for the few
      /// exceptions.</para>
      /// <para>This initializes the table of loaded modules (sys.modules), and
      /// creates the fundamental modules builtins, __main__ and sys. It also
      /// initializes the module search path (sys.path). It does not set
      /// sys.argv; use the Python Initialization Configuration API for that.
      /// This is a no-op when called for a second time (without calling
      /// FinalizeEx() first). There is no return value; it is a fatal error if
      /// the initialization fails.</para>
      /// <para>Use InitializeFromConfig() to customize the Python
      /// Initialization Configuration.</para>
      /// <para>Note On Windows, changes the console mode from O_TEXT to
      /// O_BINARY, which will also affect non-Python uses of the console using
      /// the C Runtime.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-config">See the Python Initialization Configuration article.</see></para>
      /// <para><see href="https://docs.python.org/3/c-api/interp-lifecycle.html#pre-init-safe">See the Before Python Initialization article.</see></para>
      /// </remarks>
      class procedure Initialize;
      /// <summary>
      /// <para>This function works like Py_Initialize() if initsigs is 1. If
      /// initsigs is 0, it skips initialization registration of signal
      /// handlers, which may be useful when CPython is embedded as part of a
      /// larger application.</para>
      /// <para>Use InitializeFromConfig() to customize the Python
      /// Initialization Configuration.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-config">See the Python Initialization Configuration article.</see></para>
      /// <para><see href="https://docs.python.org/3/c-api/interp-lifecycle.html#pre-init-safe">See the Before Python Initialization article.</see></para>
      /// </remarks>
      class procedure InitializeEx(initsigs: integer);
      /// <summary>
      /// <para>This is a backwards-compatible version of FinalizeEx() that
      /// disregards the return value.</para>
      /// </summary>
      class procedure Finalize;
      /// <summary>
      /// <para>Undo all initializations made by Initialize() and subsequent use
      /// of Python/C API functions, and destroy all sub-interpreters
      /// (see NewInterpreter()) that were created and not yet destroyed since
      /// the last call to Initialize(). This is a no-op when called for a
      /// second time (without calling Initialize() again first).</para>
      /// <para>Since this is the reverse of Initialize(), it should be called
      /// in the same thread with the same interpreter active. That means the
      /// main thread and the main interpreter. This should never be called
      /// while RunMain() is running.</para>
      /// <para>Normally the return value is True. If there were errors during
      /// finalization (flushing buffered data), False is returned.</para>
      /// <para>Note that Python will do a best effort at freeing all memory
      /// allocated by the Python interpreter. Therefore, any C-Extension should
      /// make sure to correctly clean up all of the previously allocated
      /// PyObjects before using them in subsequent calls to Initialize().
      /// Otherwise it could introduce vulnerabilities and incorrect
      /// behavior.</para>
      /// <para>This function is provided for a number of reasons. An embedding
      /// application might want to restart Python without having to restart the
      /// application itself. An application that has loaded the Python
      /// interpreter from a dynamically loadable library (or DLL) might want to
      /// free all memory allocated by Python before unloading the DLL. During a
      /// hunt for memory leaks in an application a developer might want to free
      /// all memory allocated by Python before exiting from the
      /// application.</para>
      /// <para>Bugs and caveats: The destruction of modules and objects in
      /// modules is done in random order; this may cause destructors
      /// (__del__() methods) to fail when they depend on other objects
      /// (even functions) or modules. Dynamically loaded extension modules
      /// loaded by Python are not unloaded. Small amounts of memory allocated
      /// by the Python interpreter may not be freed (if you find a leak, please
      /// report it). Memory tied up in circular references between objects is
      /// not freed. Interned strings will all be deallocated regardless of
      /// their reference count. Some memory allocated by extension modules may
      /// not be freed. Some extensions may not work properly if their
      /// initialization routine is called more than once; this can happen if an
      /// application calls Initialize() and FinalizeEx() more than once.
      /// FinalizeEx() must not be called recursively from within itself.
      /// Therefore, it must not be called by any code that may be run as part
      /// of the interpreter shutdown process, such as atexit handlers, object
      /// finalizers, or any code that may be run while flushing the stdout and
      /// stderr files.</para>
      /// <para>Raises an auditing event cpython._PySys_ClearAuditHooks with no
      /// arguments.</para>
      /// <para>Added in version 3.6.</para>
      /// </summary>
      class function  FinalizeEx: boolean;
      /// <summary>
      /// <para>Create a new sub-interpreter. This is essentially just a wrapper
      /// around NewInterpreterFromConfig() with a config that preserves the
      /// existing behavior. The result is an unisolated sub-interpreter that
      /// shares the main interpreter’s GIL, allows fork/exec, allows daemon
      /// threads, and allows single-phase init modules.</para>
      /// </summary>
      class function  NewInterpreter: IPyThreadState;
      /// <summary>
      /// <para>Destroy the (sub-)interpreter represented by the given thread
      /// state. The given thread state must be attached. When the call returns,
      /// there will be no attached thread state. All thread states associated
      /// with this interpreter are destroyed.</para>
      /// <para>FinalizeEx() will destroy all sub-interpreters that haven’t been
      /// explicitly destroyed at that point.</para>
      /// </summary>
      class procedure EndInterpreter(const tstate: IPyThreadState);
      /// <summary>
      /// <para>Register a cleanup function to be called by FinalizeEx().
      /// The cleanup function will be called with no arguments and should
      /// return no value. At most 32 cleanup functions can be registered. When
      /// the registration is successful, AtExit() returns True; on failure, it
      /// returns False. The cleanup function registered last is called first.
      /// Each cleanup function will be called at most once. Since Python’s
      /// internal finalization will have completed before the cleanup function,
      /// no Python APIs should be called by func.</para>
      /// </summary>
      class function  AtExit(proc: AtExitProc): boolean;
      /// <summary>
      /// <para>Exit the current process. This calls FinalizeEx() and then calls
      /// the standard C library function exit(status). If FinalizeEx()
      /// indicates an error, the exit status is set to 120.</para>
      /// <para>Changed in version 3.6: Errors from finalization no longer
      /// ignored.</para>
      /// </summary>
      class procedure Exit(status: Integer);
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  Main(argc: integer; argv: PPWCharT): integer;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  BytesMain(argc: integer; argv: PPAnsiChar): integer;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  SetProgramName(const name_: string): boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  GetProgramName: string;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  SetPythonHome(const home: string): boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  GetPythonHome: string;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  GetProgramFullPath: string;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  GetPrefix: string;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  GetExecPrefix: string;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  GetPath: string;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  GetVersion: string;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  GetPlatform: string;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  GetCopyright: string;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  GetCompiler: string;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  GetBuildInfo: string;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  IsFinalizing: boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  PreInitialize(const src_config: IPyPreConfig): IPyStatus;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  PreInitializeFromBytesArgs(const src_config: IPyPreConfig; argc: Py_ssize_t; argv: PPAnsiChar): IPyStatus;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  PreInitializeFromArgs(const src_config: IPyPreConfig; argc: Py_ssize_t; argv: PPWCharT): IPyStatus;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  RunMain: integer;
      /// <summary>
      /// <para></para>
      /// </summary>
      class procedure ExitStatusException(const status: IPyStatus);
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  FdIsInteractive(file_: PFILE; const filename: string): boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  NewInterpreterFromConfig(out tstate: IPyThreadState; const config: IPyInterpreterConfig): IPyStatus;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  AddPendingCall(func: Py_AddPendingCall_func; arg: pointer): boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  MakePendingCalls: boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class procedure SetRecursionLimit(new_limit: Integer);
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  GetRecursionLimit: integer;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  EnterRecursiveCall(const where_: string): boolean;
      /// <summary>
      /// <para></para>
      /// </summary>
      class procedure LeaveRecursiveCall;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  DecodeLocale(const arg: PAnsiChar; size_: NativeUInt): PWCharT;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  EncodeLocale(const text: PWCharT; error_pos: NativeUInt): PAnsiChar;
      /// <summary>
      /// <para></para>
      /// </summary>
      class function  fopen(const path: IPyObject; const mode: string): PFILE;
      /// <summary>
      /// <para></para>
      /// </summary>
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

class function TPy.ReprEnter(const aPyObject: IPyObject): Integer;
begin
  if assigned(Py_ReprEnter) and
     TPyObject.IsInitialized(aPyObject) then
    Result := Py_ReprEnter(aPyObject.PyObject)
   else
    Result := 0;
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
