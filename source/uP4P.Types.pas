unit uP4P.Types;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

{$IFNDEF TARGET_64BITS}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF}
  uP4P.Constants;

type
  {* Custom types *}
  PFILE   = Pointer;
{$IFDEF MSWINDOWS}
  C_Long  = type Integer;
  C_ULong = type Cardinal;
{$ELSE}
  C_Long  = type NativeInt;
  C_ULong = type NativeUInt;
{$ENDIF}
{$IFDEF POSIX}
  PWCharT       = type PUCS4Char;
  PPWCharT      = ^PUCS4Char;
  WCharTString  = type UCS4String;
{$ELSE}
  PWCharT       = type PWideChar;
  PPWCharT      = type PPWideChar;
  WCharTString  = type UnicodeString;
{$ENDIF}

  /// <summary>
  /// Status of TP4PLoader
  /// </summary>
  TP4PLoaderStatus = (plsUnloaded,
                      plsLoaded,
                      plsInitialized,
                      plsFinalized,
                      plsErrorDLLVersion,
                      plsErrorLoadingLibrary,
                      plsErrorInitializingLibrary);

  /// <summary>
  /// Python library version information
  /// </summary>
  TFileVersionInfo = record
    Major : uint16;
    Minor : uint16;
    Micro : uint16;
  end;

  /// <summary>
  /// Python verbose mode
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#c.PyConfig.verbose">See the article about Python Initialization Configuration.</see></para>
  /// </remarks>
  TPyVerboseMode = (
    /// <summary>
    /// Verbose mode disabled.
    /// </summary>
    pvmDisabled = 0,
    /// <summary>
    /// Print a message each time a module is imported, showing the place (filename or built-in module) from which it is loaded.
    /// </summary>
    pvmModule = 1,
    /// <summary>
    /// Print a message for each file that is checked for when searching for a module. Also provides information on module cleanup at exit.
    /// </summary>
    pvmFull = 2
  );

  /// <summary>
  /// Compilation optimization level.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#c.PyConfig.optimization_level">See the article about Python Initialization Configuration.</see></para>
  /// </remarks>
  TPyOptimizationLevel = (
    /// <summary>
    /// Peephole optimizer, set __debug__ to True.
    /// </summary>
    polDebug = 0,
    /// <summary>
    /// Level 0, remove assertions, set __debug__ to False.
    /// </summary>
    polRelease = 1,
    /// <summary>
    /// Level 1, strip docstrings.
    /// </summary>
    polReleaseNoDocStrings = 2
  );

  TPyCodecErrors = (
    pceStrict,
    pceReplace,
    pceIgnore,
    pceSurrogateEscape
  );

  TPyBiteOrder = (
    pboLittleEndian = -1,
    pboNativeOrder  = 0,
    pboBigEndian    = 1
  );

  TPyMemoryViewOrder = (
    pmvoC,
    pmvoFortran
  );

  TPyBufferOrder = (
    pboC,
    pboFortran,
    pboEitherOne
  );

  TPyBufferFort = (
    pbfC,
    pbfFortran
  );

  TPyDoubleToStringFormatCode = (
    fc_lowercase_e,
    fc_E,
    fc_lowercase_f,
    fc_F,
    fc_lowercase_g,
    fc_G,
    fc_r
  );

  TPyInterpreterCfgGIL = (
    gilDefault,
    gilShared,
    gilOwn
  );

  TPyDaylightSavingTime = (
    dstUnknown = -1,
    dstWinter  = 0,
    dstSummer  = 1
  );

  TCustomIntArray = array of integer;

  TNamedParamDesc = record
    Index : Integer;
    Name  : PAnsiChar;
  end;
  TNamedParamArray = array of TNamedParamDesc;

  /// <summary>
  /// Custom type to avoid invalid "start" values in TPy.Compile*.
  /// These values are converted to Py_single_input, Py_file_input,
  /// Py_eval_input or Py_func_type_input.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/veryhigh.html#available-start-symbols">See the article about Start Symbols.</see></para>
  /// </remarks>
  TPyStartSymbols = (
    ssSingle,
    ssFile,
    ssEval,
    ssFuncType
  );

  PPy_ssize_t                     = ^Py_ssize_t;
  PPyTypeObject                   = ^PyTypeObject;
  PPPyTypeObject                  = ^PPyTypeObject;
  PPyModuleDef_Base               = ^PyModuleDef_Base;
  PPyObject                       = ^PyObject;
  PPPyObject                      = ^PPyObject;
  PPyModuleDef_Slot               = ^PyModuleDef_Slot;
  PPyModuleDef                    = ^PyModuleDef;
  PPyVarObject                    = ^PyVarObject;
  PPyAsyncMethods                 = ^PyAsyncMethods;
  PPyType_Slot                    = ^PyType_Slot;
  PPyNumberMethods                = ^PyNumberMethods;
  PPySequenceMethods              = ^PySequenceMethods;
  PPyMappingMethods               = ^PyMappingMethods;
  PPyBufferProcs                  = ^PyBufferProcs;
  PPy_buffer                      = ^Py_Buffer;
  PPyMethodDef                    = ^PyMethodDef;
  PPyMemberDef                    = ^PyMemberDef;
  PPyGetSetDef                    = ^PyGetSetDef;
  P_PyCoCached                    = ^_PyCoCached;
  P_PyExecutorArray               = ^_PyExecutorArray;
  PPyFrameObject                  = ^PyFrameObject;
  PPyInterpreterState             = type Pointer; // opaque
  PPyThreadState                  = type Pointer; // opaque
  PPyType_Spec                    = ^PyType_Spec;
  PPy_UCS4                        = ^Py_UCS4;
  PPy_UCS2                        = ^Py_UCS2;
  PPy_UCS1                        = ^Py_UCS1;
  PPyLongLayout                   = ^PyLongLayout;
  PPyLongExport                   = ^PyLongExport;
  PPyLongWriter                   = type Pointer; // opaque
  PPyFunctionObject               = ^PyFunctionObject;
  PPyMethodObject                 = ^PyMethodObject;
  PPyInstanceMethodObject         = ^PyInstanceMethodObject;
  PPyCodeObject                   = ^PyCodeObject;
  PPyStatus                       = ^PyStatus;
  PPyWideStringList               = ^PyWideStringList;
  PPyPreConfig                    = type Pointer; // opaque
  PPyConfig                       = type Pointer; // opaque
  PPyInitConfig                   = type Pointer; // opaque
  PPyGenObject                    = type Pointer; // opaque
  PPyCoroObject                   = type Pointer; // opaque
  PPyAsyncGenObject               = type Pointer; // opaque
  PPyWeakReference                = ^PyWeakReference;
  PPyStructSequence_Field         = ^PyStructSequence_Field;
  PPyStructSequence_Desc          = ^PyStructSequence_Desc;
  PPyTime_t                       = ^PyTime_t;
  PyThread_type_lock              = type Pointer;
  PPy_tss_t                       = type Pointer; // opaque
  PPyContext                      = type Pointer; // opaque
  PPyContextVar                   = type Pointer; // opaque
  PPyContextToken                 = type Pointer; // opaque
  PPyODictObject                  = type Pointer; // opaque
  PPyDictObject                   = ^PyDictObject;
  PPyDictKeysObject               = type Pointer; // opaque
  PPyDictValues                   = type Pointer; // opaque
  PPyMutex                        = ^PyMutex;
  PPyCriticalSection              = ^PyCriticalSection;
  PPyCriticalSection2             = ^PyCriticalSection2;
  PPyMonitoringState              = ^PyMonitoringState;
  PPyBytesObject                  = ^PyBytesObject;
  PPyCompilerFlags                = ^PyCompilerFlags;
  PPy_complex                     = ^Py_complex;
  PPyComplexObject                = ^PyComplexObject;
  PPyDescrObject                  = ^PyDescrObject;
  PPyMethodDescrObject            = ^PyMethodDescrObject;
  PPyMemberDescrObject            = ^PyMemberDescrObject;
  PPyGetSetDescrObject            = ^PyGetSetDescrObject;
  Pwrapperbase                    = ^wrapperbase;
  PPyWrapperDescrObject           = ^PyWrapperDescrObject;
  PPyFloatObject                  = ^PyFloatObject;
  PPyFrameLocalsProxyObject       = ^PyFrameLocalsProxyObject;
  P_inittab                       = ^_inittab;
  P_frozen                        = ^_frozen;
  PPyCFunctionObject              = ^PyCFunctionObject;
  PPyCMethodObject                = ^PyCMethodObject;
  PPyHeapTypeObject               = ^PyHeapTypeObject;
  PPyObjectArenaAllocator         = ^PyObjectArenaAllocator;
  PPyBaseExceptionObject          = ^PyBaseExceptionObject;
  PPyBaseExceptionGroupObject     = ^PyBaseExceptionGroupObject;
  PPySyntaxErrorObject            = ^PySyntaxErrorObject;
  PPyImportErrorObject            = ^PyImportErrorObject;
  PPyUnicodeErrorObject           = ^PyUnicodeErrorObject;
  PPySystemExitObject             = ^PySystemExitObject;
  PPyOSErrorObject                = ^PyOSErrorObject;
  PPyStopIterationObject          = ^PyStopIterationObject;
  PPyNameErrorObject              = ^PyNameErrorObject;
  PPyAttributeErrorObject         = ^PyAttributeErrorObject;
  PPyHash_FuncDef                 = ^PyHash_FuncDef;
  PPyInterpreterConfig            = ^PyInterpreterConfig;
  PPyUnicodeWriter                = type Pointer; // opaque
  PPyByteArrayObject              = ^PyByteArrayObject;
  PPyDateTime_Delta               = ^PyDateTime_Delta;
  PPyDateTime_TZInfo              = ^PyDateTime_TZInfo;
  P_PyDateTime_BaseTZInfo         = ^_PyDateTime_BaseTZInfo;
  P_PyDateTime_BaseTime           = ^_PyDateTime_BaseTime;
  PPyDateTime_Time                = ^PyDateTime_Time;
  PPyDateTime_Date                = ^PyDateTime_Date;
  P_PyDateTime_BaseDateTime       = ^_PyDateTime_BaseDateTime;
  PPyDateTime_DateTime            = ^PyDateTime_DateTime;
  PPyDateTime_CAPI                = ^PyDateTime_CAPI;
  PPySliceObject                  = ^PySliceObject;
  PPyLongObject                   = ^PyLongObject;
  PPyMemAllocatorEx               = ^PyMemAllocatorEx;
  PC_ULong                        = ^C_ULong;
  PPyBiteOrder                    = ^TPyBiteOrder;
  PPyTracebackObject              = ^PyTracebackObject;


  // custom PPyObject array type
  PPyObjectArray = array of PPyObject;


  {* include/pyport.h *}
  Py_uintptr_t       = type NativeUInt;
  Py_intptr_t        = type NativeInt;
  Py_ssize_t         = type Py_intptr_t;
  Py_hash_t          = type Py_ssize_t;
  Py_uhash_t         = type NativeUInt;
  Py_ssize_clean_t   = type Py_ssize_t;

  // custom Py_ssize_t array type
  Py_ssize_t_array   = array of Py_ssize_t;

  {* include/pymacro.h *}
  {* include/pymath.h *}
  {* include/pymem.h  Include/cpython/pymem.h *}
  PyMemAllocatorDomain = (
    PYMEM_DOMAIN_RAW,
    PYMEM_DOMAIN_MEM,
    PYMEM_DOMAIN_OBJ
  );

  PyMemAllocatorName = (
    PYMEM_ALLOCATOR_NOT_SET        = 0,
    PYMEM_ALLOCATOR_DEFAULT        = 1,
    PYMEM_ALLOCATOR_DEBUG          = 2,
    PYMEM_ALLOCATOR_MALLOC         = 3,
    PYMEM_ALLOCATOR_MALLOC_DEBUG   = 4,
    PYMEM_ALLOCATOR_PYMALLOC       = 5,
    PYMEM_ALLOCATOR_PYMALLOC_DEBUG = 6,
    PYMEM_ALLOCATOR_MIMALLOC       = 7,
    PYMEM_ALLOCATOR_MIMALLOC_DEBUG = 8
  );

  PyMemAllocatorEx_malloc  = function(ctx: Pointer; size_: NativeUInt): Pointer; cdecl;
  PyMemAllocatorEx_calloc  = function(ctx: Pointer; nelem, elsize: NativeUInt): Pointer; cdecl;
  PyMemAllocatorEx_realloc = function(ctx, ptr: Pointer; new_size: NativeUInt): Pointer; cdecl;
  PyMemAllocatorEx_free    = procedure(ctx, ptr: Pointer); cdecl;

  PyMemAllocatorEx = record
    ctx     : Pointer;
    malloc  : PyMemAllocatorEx_malloc;
    calloc  : PyMemAllocatorEx_calloc;
    realloc : PyMemAllocatorEx_realloc;
    free    : PyMemAllocatorEx_free;
  end;

  {* include/pytypedefs.h *}
  {* include/pybuffer.h *}
  Py_buffer = record
    buf        : Pointer;
    obj        : PPyObject;
    len        : Py_ssize_t;
    itemsize   : Py_ssize_t;
    readonly   : Integer;
    ndim       : Integer;
    format     : PAnsiChar;
    shape      : PPy_ssize_t;
    strides    : PPy_ssize_t;
    suboffsets : PPy_ssize_t;
    internal   : Pointer;
  end;

  getbufferproc                  = function(exporter: PPyObject; view: PPy_buffer; flags: Integer): Integer; cdecl;
  releasebufferproc              = procedure(exporter: PPyObject; view: PPy_buffer); cdecl;

  {* include/pystats.h *}
  {* include/pyatomic.h *}
  {* include/lock.h *}
  PyMutex = record
    _bits : byte;
  end;

  {* include/critical_section.h *}
  PyCriticalSection = record
    _cs_prev  : Py_uintptr_t;
    _cs_mutex : PPyMutex;
  end;

  PyCriticalSection2 = record
    _cs_base   : PyCriticalSection;
    _cs_mutex2 : PPyMutex;
  end;

  {* include/object.h *}
  _object = record
    ob_refcnt : Py_ssize_t;
    ob_type   : PPyTypeObject;
  end;
  PyObject = type _object;

  PyVarObject = record
    ob_base  : PyObject;
    ob_size  : Py_ssize_t;
  end;

  PySendResult = (   
    PYGEN_ERROR  = -1,
    PYGEN_RETURN = 0,
    PYGEN_NEXT   = 1
  );

  TMultIntprSupport = (
    miSupported,
    miUnsupported,
    piGilSupported
  );

  unaryfunc                      = function(ob1: PPyObject): PPyObject; cdecl;
  binaryfunc                     = function(ob1, ob2: PPyObject): PPyObject; cdecl;
  ternaryfunc                    = function(ob1, ob2, ob3: PPyObject): PPyObject; cdecl;
  inquiry                        = function(ob1: PPyObject): integer; cdecl;
  lenfunc                        = function(ob1: PPyObject): Py_ssize_t; cdecl;
  ssizeargfunc                   = function(ob1: PPyObject; i: Py_ssize_t): PPyObject; cdecl;
  ssizessizeargfunc              = function(ob1: PPyObject; i, j: Py_ssize_t): PPyObject; cdecl;
  ssizeobjargproc                = function(ob1: PPyObject; i: NativeInt; ob2 : PPyObject): integer; cdecl;
  ssizessizeobjargproc           = function(ob1: PPyObject; i, j: NativeInt; ob2 : PPyObject): integer; cdecl;
  objobjargproc                  = function(ob1, ob2, ob3 : PPyObject): integer; cdecl;
  objobjproc                     = function(ob1, ob2 : PPyObject): integer; cdecl;
  visitproc                      = function(ob: PPyObject; p: Pointer): integer; cdecl;
  traverseproc                   = function(ob: PPyObject; v: visitproc; p: Pointer): integer; cdecl;
  freefunc                       = procedure(p: Pointer); cdecl;
  destructor_                    = procedure(ob: PPyObject); cdecl;
  getattrfunc                    = function(ob1: PPyObject; name: PAnsiChar): PPyObject; cdecl;
  getattrofunc                   = function(ob1, ob2: PPyObject): PPyObject; cdecl;
  setattrfunc                    = function(ob1: PPyObject; name: PAnsiChar; ob2: PPyObject): integer; cdecl;
  setattrofunc                   = function(ob1, ob2, ob3: PPyObject): integer; cdecl;
  reprfunc                       = function(ob: PPyObject): PPyObject; cdecl;
  hashfunc                       = function(ob: PPyObject): Py_hash_t; cdecl;
  richcmpfunc                    = function(ob1, ob2: PPyObject; i: Integer): PPyObject; cdecl;
  getiterfunc                    = function(ob1: PPyObject) : PPyObject; cdecl;
  iternextfunc                   = function(ob1: PPyObject): PPyObject; cdecl;
  descrgetfunc                   = function(ob1, ob2, ob3: PPyObject): PPyObject; cdecl;
  descrsetfunc                   = function(ob1, ob2, ob3: PPyObject): Integer; cdecl;
  initproc                       = function(self, args, kwds: PPyObject): Integer; cdecl;
  newfunc                        = function(subtype: PPyTypeObject; args, kwds: PPyObject): PPyObject; cdecl;
  allocfunc                      = function(self: PPyTypeObject; nitems: Py_ssize_t): PPyObject; cdecl;
  vectorcallfunc                 = function(callable, args: PPyObject; nargsf: NativeUInt; kwnames: PPyObject): PPyObject; cdecl;
  sendfunc                       = function(iter, value: PPyObject; result: PPPyObject): PySendResult; cdecl;
  create_modulefunc              = function(spec: PPyObject; def: PPyModuleDef): PPyObject; cdecl;
  exec_modulefunc                = function(module: PPyObject): integer; cdecl;

  PyType_Slot = record
    slot   : integer;
    pfunc  : Pointer;
  end;

  PyType_Spec = record
    name      : PAnsiChar;
    basicsize : integer;
    itemsize  : integer;
    flags     : cardinal;
    slots     : PPyType_Slot;
  end;

  PyNumberMethods = record
    nb_add                     : binaryfunc;
    nb_subtract                : binaryfunc;
    nb_multiply                : binaryfunc;
    nb_remainder               : binaryfunc;
    nb_divmod                  : binaryfunc;
    nb_power                   : ternaryfunc;
    nb_negative                : unaryfunc;
    nb_positive                : unaryfunc;
    nb_absolute                : unaryfunc;
    nb_bool                    : inquiry;
    nb_invert                  : unaryfunc;
    nb_lshift                  : binaryfunc;
    nb_rshift                  : binaryfunc;
    nb_and                     : binaryfunc;
    nb_xor                     : binaryfunc;
    nb_or                      : binaryfunc;
    nb_int                     : unaryfunc;
    nb_reserved                : Pointer;
    nb_float                   : unaryfunc;
    nb_inplace_add             : binaryfunc;
    nb_inplace_subtract        : binaryfunc;
    nb_inplace_multiply        : binaryfunc;
    nb_inplace_remainder       : binaryfunc;
    nb_inplace_power           : ternaryfunc;
    nb_inplace_lshift          : binaryfunc;
    nb_inplace_rshift          : binaryfunc;
    nb_inplace_and             : binaryfunc;
    nb_inplace_xor             : binaryfunc;
    nb_inplace_or              : binaryfunc;
    nb_floor_divide            : binaryfunc;
    nb_true_divide             : binaryfunc;
    nb_inplace_floor_divide    : binaryfunc;
    nb_inplace_true_divide     : binaryfunc;
    nb_index                   : unaryfunc;
    nb_matrix_multiply         : binaryfunc;
    nb_inplace_matrix_multiply : binaryfunc;
  end;

  PySequenceMethods = record
    sq_length         : lenfunc;
    sq_concat         : binaryfunc;
    sq_repeat         : ssizeargfunc;
    sq_item           : ssizeargfunc;
    was_sq_slice      : Pointer;
    sq_ass_item       : ssizeobjargproc;
    was_sq_ass_slice  : Pointer;
    sq_contains       : objobjproc;
    sq_inplace_concat : binaryfunc;
    sq_inplace_repeat : ssizeargfunc;
  end;

  PyMappingMethods = record
    mp_length	       : lenfunc;
    mp_subscript     : binaryfunc;
    mp_ass_subscript : objobjargproc;
  end;

  PyAsyncMethods = record
    am_await : unaryfunc;
    am_aiter : unaryfunc;
    am_anext : unaryfunc;
    am_send  : sendfunc;
  end;

  PyBufferProcs = record
    bf_getbuffer     : getbufferproc;
    bf_releasebuffer : releasebufferproc;
  end;

  _typeobject = record
    ob_base              : PyVarObject; // PyObject_VAR_HEAD
    tp_name              : PAnsiChar;
    tp_basicsize         : Py_ssize_t;
    tp_itemsize          : Py_ssize_t;
    tp_dealloc           : destructor_;
    tp_vectorcall_offset : Py_ssize_t;
    tp_getattr           : getattrfunc;
    tp_setattr           : setattrfunc;
    tp_as_async          : PPyAsyncMethods;
    tp_repr              : reprfunc;
    tp_as_number         : PPyNumberMethods;
    tp_as_sequence       : PPySequenceMethods;
    tp_as_mapping        : PPyMappingMethods;
    tp_hash              : hashfunc;
    tp_call              : ternaryfunc;
    tp_str               : reprfunc;
    tp_getattro          : getattrofunc;
    tp_setattro          : setattrofunc;
    tp_as_buffer         : PPyBufferProcs;
    tp_flags             : NativeUInt;
    tp_doc               : PAnsiChar;
    tp_traverse          : traverseproc;
    tp_clear             : inquiry;
    tp_richcompare       : richcmpfunc;
    tp_weaklistoffset    : Py_ssize_t;
    tp_iter              : getiterfunc;
    tp_iternext          : iternextfunc;
    tp_methods           : PPyMethodDef;
    tp_members           : PPyMemberDef;
    tp_getset            : PPyGetSetDef;
    tp_base              : PPyTypeObject;
    tp_dict              : PPyObject;
    tp_descr_get         : descrgetfunc;
    tp_descr_set         : descrsetfunc;
    tp_dictoffset        : Py_ssize_t;
    tp_init              : initproc;
    tp_alloc             : allocfunc;
    tp_new               : newfunc;
    tp_free              : freefunc;
    tp_is_gc             : inquiry;
    tp_bases             : PPyObject;
    tp_mro               : PPyObject;
    tp_cache             : PPyObject;
    tp_subclasses        : Pointer;
    tp_weaklist          : PPyObject;
    tp_del               : destructor_;
    tp_version_tag       : cardinal;
    tp_finalize          : destructor_;
    tp_vectorcall        : vectorcallfunc;
    tp_watched           : byte;
    tp_versions_used     : word;
  end;
  PyTypeObject = type _typeobject;

  _specialization_cache = record
    getitem         : PPyObject;
    getitem_version : cardinal;
    init            : PPyObject;
  end;

  PyHeapTypeObject = record
    ht_type           : PyTypeObject;
    as_async          : PyAsyncMethods;
    as_number         : PyNumberMethods;
    as_mapping        : PyMappingMethods;
    as_sequence       : PySequenceMethods;
    as_buffer         : PyBufferProcs;
    ht_name           : PPyObject;
    ht_slots          : PPyObject;
    ht_qualname       : PPyObject;
    ht_cached_keys    : PPyDictKeysObject;
    ht_module         : PPyObject;
    _ht_tpname        : PAnsiChar;
    ht_token          : Pointer;
    _spec_cache       : _specialization_cache;
  end;

  PyRefTracerEvent = (
    PyRefTracer_CREATE  = 0,
    PyRefTracer_DESTROY = 1
  );

  PyType_WatchCallback = function(type_: PPyTypeObject): integer; cdecl;
  PyRefTracer          = function(obj: PPyObject; event: PyRefTracerEvent; ptr: Pointer): integer; cdecl;

  {* include/refcount.h *}
  {* include/objimpl.h *}
  PyObjectArenaAllocator_alloc   = function(ctx: Pointer; size_: NativeUInt): Pointer; cdecl;
  PyObjectArenaAllocator_free    = procedure(ctx, ptr: Pointer; size_: NativeUInt); cdecl;

  PyObjectArenaAllocator = record
    ctx    : Pointer;
    alloc_ : PyObjectArenaAllocator_alloc;
    free_  : PyObjectArenaAllocator_free;
  end;

  {* include/typeslots.h *}
  {* include/pyhash.h *}
  PyHash_FuncDef_hash = function(ptr: Pointer; size_: Py_ssize_t): Py_hash_t; cdecl;

  PyHash_FuncDef = record
    hash                : PyHash_FuncDef_hash;
    name_               : PAnsiChar;
    hash_bits           : integer;
    seed_bits           : integer;
  end;

  {* include/cpython/pydebug.h *}
  {* include/bytearrayobject.h *}
  PyByteArrayObject = record
    ob_base              : PyVarObject; // PyObject_VAR_HEAD
    ob_alloc             : Py_ssize_t;
    ob_bytes             : PAnsiChar;
    ob_start             : PAnsiChar;
    ob_exports           : Py_ssize_t;
  end;

  {* include/bytesobject.h *}
  PyBytesObject = record
    ob_base              : PyVarObject; // PyObject_VAR_HEAD
    ob_sval              : array[0..0] of AnsiChar;
  end;

  {* include/unicodeobject.h *}
  Py_UCS4            = type cardinal;
  Py_UCS2            = type word;
  Py_UCS1            = type byte;

  // "PyUnicode_Kind_Result" is a renamed type for "PyUnicode_Kind"
  PyUnicode_Kind_Result = (
    PyUnicode_1BYTE_KIND = 1,
    PyUnicode_2BYTE_KIND = 2,
    PyUnicode_4BYTE_KIND = 4
  );

  {* include/pyerrors.h *}
  PyBaseExceptionObject = record
    ob_base           : PyObject; // PyObject_HEAD  // PyException_HEAD
    dict              : PPyObject;                  // PyException_HEAD
    args              : PPyObject;                  // PyException_HEAD
    notes             : PPyObject;                  // PyException_HEAD
    traceback         : PPyObject;                  // PyException_HEAD
    context           : PPyObject;                  // PyException_HEAD
    cause             : PPyObject;                  // PyException_HEAD
    suppress_context  : AnsiChar;                   // PyException_HEAD
  end;

  PyBaseExceptionGroupObject = record
    ob_base           : PyObject; // PyObject_HEAD  // PyException_HEAD
    dict              : PPyObject;                  // PyException_HEAD
    args              : PPyObject;                  // PyException_HEAD
    notes             : PPyObject;                  // PyException_HEAD
    traceback         : PPyObject;                  // PyException_HEAD
    context           : PPyObject;                  // PyException_HEAD
    cause             : PPyObject;                  // PyException_HEAD
    suppress_context  : AnsiChar;                   // PyException_HEAD
    msg               : PPyObject;
    excs              : PPyObject;
  end;

  PySyntaxErrorObject = record
    ob_base             : PyObject; // PyObject_HEAD  // PyException_HEAD
    dict                : PPyObject;                  // PyException_HEAD
    args                : PPyObject;                  // PyException_HEAD
    notes               : PPyObject;                  // PyException_HEAD
    traceback           : PPyObject;                  // PyException_HEAD
    context             : PPyObject;                  // PyException_HEAD
    cause               : PPyObject;                  // PyException_HEAD
    suppress_context    : AnsiChar;                   // PyException_HEAD
    msg                 : PPyObject;
    filename            : PPyObject;
    lineno              : PPyObject;
    offset              : PPyObject;
    end_lineno          : PPyObject;
    end_offset          : PPyObject;
    text                : PPyObject;
    print_file_and_line : PPyObject;
    metadata            : PPyObject;
  end;

  PyImportErrorObject = record
    ob_base             : PyObject; // PyObject_HEAD  // PyException_HEAD
    dict                : PPyObject;                  // PyException_HEAD
    args                : PPyObject;                  // PyException_HEAD
    notes               : PPyObject;                  // PyException_HEAD
    traceback           : PPyObject;                  // PyException_HEAD
    context             : PPyObject;                  // PyException_HEAD
    cause               : PPyObject;                  // PyException_HEAD
    suppress_context    : AnsiChar;                   // PyException_HEAD
    msg                 : PPyObject;
    name                : PPyObject;
    path                : PPyObject;
    name_from           : PPyObject;
  end;

  PyUnicodeErrorObject = record
    ob_base             : PyObject; // PyObject_HEAD  // PyException_HEAD
    dict                : PPyObject;                  // PyException_HEAD
    args                : PPyObject;                  // PyException_HEAD
    notes               : PPyObject;                  // PyException_HEAD
    traceback           : PPyObject;                  // PyException_HEAD
    context             : PPyObject;                  // PyException_HEAD
    cause               : PPyObject;                  // PyException_HEAD
    suppress_context    : AnsiChar;                   // PyException_HEAD
    encoding            : PPyObject;
    object_             : PPyObject;
    start               : Py_ssize_t;
    end_                : Py_ssize_t;
    reason              : PPyObject;
  end;

  PySystemExitObject = record
    ob_base             : PyObject; // PyObject_HEAD  // PyException_HEAD
    dict                : PPyObject;                  // PyException_HEAD
    args                : PPyObject;                  // PyException_HEAD
    notes               : PPyObject;                  // PyException_HEAD
    traceback           : PPyObject;                  // PyException_HEAD
    context             : PPyObject;                  // PyException_HEAD
    cause               : PPyObject;                  // PyException_HEAD
    suppress_context    : AnsiChar;                   // PyException_HEAD
    code                : PPyObject;
  end;

  PyOSErrorObject = record
    ob_base             : PyObject; // PyObject_HEAD  // PyException_HEAD
    dict                : PPyObject;                  // PyException_HEAD
    args                : PPyObject;                  // PyException_HEAD
    notes               : PPyObject;                  // PyException_HEAD
    traceback           : PPyObject;                  // PyException_HEAD
    context             : PPyObject;                  // PyException_HEAD
    cause               : PPyObject;                  // PyException_HEAD
    suppress_context    : AnsiChar;                   // PyException_HEAD
    myerrno             : PPyObject;
    strerror            : PPyObject;
    filename            : PPyObject;
    filename2           : PPyObject;
    {$IFDEF MSWINDOWS}
    winerror            : PPyObject;
    {$ENDIF}
    written             : Py_ssize_t;
  end;
  PyEnvironmentErrorObject = type PyOSErrorObject;
  {$IFDEF MSWINDOWS}
  PyWindowsErrorObject     = type PyOSErrorObject;
  {$ENDIF}

  PyStopIterationObject = record
    ob_base             : PyObject; // PyObject_HEAD  // PyException_HEAD
    dict                : PPyObject;                  // PyException_HEAD
    args                : PPyObject;                  // PyException_HEAD
    notes               : PPyObject;                  // PyException_HEAD
    traceback           : PPyObject;                  // PyException_HEAD
    context             : PPyObject;                  // PyException_HEAD
    cause               : PPyObject;                  // PyException_HEAD
    suppress_context    : AnsiChar;                   // PyException_HEAD
    value               : PPyObject;
  end;

  PyNameErrorObject = record
    ob_base             : PyObject; // PyObject_HEAD  // PyException_HEAD
    dict                : PPyObject;                  // PyException_HEAD
    args                : PPyObject;                  // PyException_HEAD
    notes               : PPyObject;                  // PyException_HEAD
    traceback           : PPyObject;                  // PyException_HEAD
    context             : PPyObject;                  // PyException_HEAD
    cause               : PPyObject;                  // PyException_HEAD
    suppress_context    : AnsiChar;                   // PyException_HEAD
    name                : PPyObject;
  end;

  PyAttributeErrorObject = record
    ob_base             : PyObject; // PyObject_HEAD  // PyException_HEAD
    dict                : PPyObject;                  // PyException_HEAD
    args                : PPyObject;                  // PyException_HEAD
    notes               : PPyObject;                  // PyException_HEAD
    traceback           : PPyObject;                  // PyException_HEAD
    context             : PPyObject;                  // PyException_HEAD
    cause               : PPyObject;                  // PyException_HEAD
    suppress_context    : AnsiChar;                   // PyException_HEAD
    obj                 : PPyObject;
    name                : PPyObject;
  end;

  {* include/longobject.h *}
  {* include/cpython/longintrepr.h *}
  digit              = type cardinal;
  sdigit             = type integer;
  twodigits          = type uint64;
  stwodigits         = type int64;

  _PyLongValue = record
    lv_tag     : NativeUInt;
    ob_digit   : array[0..0] of digit;
  end;

  _longobject = record
    ob_base    : PyObject; // PyObject_HEAD
    long_value : _PyLongValue;
  end;
  PyLongObject = type _longobject;

  PyLongLayout = record
    bits_per_digit   : byte;
    digit_size       : byte;
    digits_order     : shortint;
    digit_endianness : shortint;
  end;

  PyLongExport = record
    value     : int64;
    negative  : byte;
    ndigits   : Py_ssize_t;
    digits    : Pointer;
    _reserved : Py_uintptr_t;
  end;

  {* include/boolobject.h *}
  {* include/floatobject.h *}
  PyFloatObject = record
    ob_base    : PyObject; // PyObject_HEAD
    ob_fval    : double;
  end;

  {* include/complexobject.h *}
  Py_complex = record
    real : double;
    imag : double;
  end;

  PyComplexObject = record
    ob_base    : PyObject; // PyObject_HEAD
    cval       : Py_complex;
  end;

  {* include/rangeobject.h *}
  {* include/memoryobject.h *}
  {* include/tupleobject.h *}
  {* include/listobject.h *}
  {* include/dictobject.h *}
  PyDictObject = record
    ob_base                : PyObject; // PyObject_HEAD
    ma_used                : Py_ssize_t;
    _ma_watcher_tag        : uint64;
    ma_keys                : PPyDictKeysObject;
    ma_values              : PPyDictValues;
  end;

  PyDict_WatchEvent = (
    PyDict_EVENT_ADDED,
    PyDict_EVENT_MODIFIED,
    PyDict_EVENT_DELETED,
    PyDict_EVENT_CLONED,
    PyDict_EVENT_CLEARED,
    PyDict_EVENT_DEALLOCATED
  );

  PyDict_WatchCallback = function(event: PyDict_WatchEvent; dict, key, new_value: PPyObject): integer; cdecl;

  {* include/cpython/odictobject.h *}
  {* include/enumobject.h *}
  {* include/setobject.h *}
  {* include/methodobject.h  include/cpython/methodobject.h *}
  PyCFunction                    = function(self, args: PPyObject): PPyObject; cdecl;
  PyCFunctionFast                = function(self: PPyObject; const args: PPPyObject; nargs: Py_ssize_t): PPyObject; cdecl;
  PyCFunctionWithKeywords        = function(self, args, kwargs: PPyObject): PPyObject; cdecl;
  PyCFunctionFastWithKeywords    = function(self: PPyObject; const args : PPPyObject; nargs: Py_ssize_t; kwnames: PPyObject): PPyObject; cdecl;
  PyCMethod                      = function(self: PPyObject; defining_class: PPyTypeObject; const args: PPPyObject; nargs: Py_ssize_t; kwnames: PPyObject): PPyObject; cdecl;

  PyMethodDef = record
     ml_name  : PAnsiChar;
     ml_meth  : PyCFunction;
     ml_flags : Integer;
     ml_doc   : PAnsiChar;
  end;
  PyMethodDefArray = array of PPyMethodDef;

  PyCFunctionObject = record
    ob_base       : PyObject; // PyObject_HEAD
    m_ml          : PPyMethodDef;
    m_self        : PPyObject;
    m_module      : PPyObject;
    m_weakreflist : PPyObject;
    vectorcall    : vectorcallfunc;
  end;

  PyCMethodObject = record
    func     : PyCFunctionObject;
    mm_class : PPyTypeObject;
  end;

  {* include/moduleobject.h *}
  PyModuleDef_Base_m_init = function(): PPyObject; cdecl;

  PyModuleDef_Base = record
    ob_base    : PyObject; // PyObject_HEAD
    m_init     : PyModuleDef_Base_m_init;
    m_index    : Py_ssize_t;
    m_copy     : PPyObject;
  end;

  PyModuleDef_Slot = record
    slot  : integer;
    value : Pointer;
  end;

  PyModuleDef = record
    m_base     : PyModuleDef_Base;
    m_name     : PAnsiChar;
    m_doc      : PAnsiChar;
    m_size     : Py_ssize_t;
    m_methods  : PPyMethodDef;
    m_slots    : PPyModuleDef_Slot;
    m_traverse : traverseproc;
    m_clear    : inquiry;
    m_free     : inquiry;
  end;

  {* include/monitoring.h *}
  PyMonitoringState = record
    active : byte;
    opaque : byte;
  end;

  {* include/cpython/funcobject.h *}
  PyFunctionObject = record
    ob_base          : PyObject;  // PyObject_HEAD
    func_globals     : PPyObject; //_Py_COMMON_FIELDS(func_)
    func_builtins    : PPyObject; //_Py_COMMON_FIELDS(func_)
    func_name        : PPyObject; //_Py_COMMON_FIELDS(func_)
    func_qualname    : PPyObject; //_Py_COMMON_FIELDS(func_)
    func_code        : PPyObject; //_Py_COMMON_FIELDS(func_)
    func_defaults    : PPyObject; //_Py_COMMON_FIELDS(func_)
    func_kwdefaults  : PPyObject; //_Py_COMMON_FIELDS(func_)
    func_closure     : PPyObject; //_Py_COMMON_FIELDS(func_)
    func_doc         : PPyObject;
    func_dict        : PPyObject;
    func_weakreflist : PPyObject;
    func_module      : PPyObject;
    func_annotations : PPyObject;
    func_annotate    : PPyObject;
    func_typeparams  : PPyObject;
    vectorcall       : vectorcallfunc;
    func_version     : cardinal;
  end;

  PyFunction_WatchEvent = (
    PyFunction_EVENT_CREATE,
    PyFunction_EVENT_DESTROY,
    PyFunction_EVENT_MODIFY_CODE,
    PyFunction_EVENT_MODIFY_DEFAULTS,
    PyFunction_EVENT_MODIFY_KWDEFAULTS
  );

  PyFunction_WatchCallback       = function(event: PyFunction_WatchEvent; func: PPyFunctionObject; new_value: PPyObject): integer; cdecl;

  {* include/cpython/classobject.h *}
  PyMethodObject = record
    ob_base          : PyObject;  // PyObject_HEAD
    im_func          : PPyObject;
    im_self          : PPyObject;
    im_weakreflist   : PPyObject;
    vectorcall       : vectorcallfunc;
  end;

  PyInstanceMethodObject = record
    ob_base          : PyObject;  // PyObject_HEAD
    func             : PPyObject;
  end;

  {* include/fileobject.h *}
  Py_OpenCodeHookFunction        = function(obj: PPyObject; ptr: Pointer): PPyObject; cdecl;

  {* include/pycapsule.h *}
  PyCapsule_Destructor           = procedure(obj: PPyObject); cdecl;

  {* include/cpython/code.h *}
  _PyCoCached = record
    _co_code : PPyObject;
    _co_varnames : PPyObject;
    _co_cellvars : PPyObject;
    _co_freevars : PPyObject;
  end;

  _PyExecutorArray = record
    size_     : integer;
    capacity  : integer;
    executors : Pointer; // not implemented
  end;

  PyCodeObject = record
    ob_base                     : PyVarObject; // PyObject_VAR_HEAD
    co_consts                   : PPyObject;
    co_names                    : PPyObject;
    co_exceptiontable           : PPyObject;
    co_flags                    : integer;
    co_argcount                 : integer;
    co_posonlyargcount          : integer;
    co_kwonlyargcount           : integer;
    co_stacksize                : integer;
    co_firstlineno              : integer;
    co_nlocalsplus              : integer;
    co_framesize                : integer;
    co_nlocals                  : integer;
    co_ncellvars                : integer;
    co_nfreevars                : integer;
    co_version                  : cardinal;
    co_localsplusnames          : PPyObject;
    co_localspluskinds          : PPyObject;
    co_filename                 : PPyObject;
    co_name                     : PPyObject;
    co_qualname                 : PPyObject;
    co_linetable                : PPyObject;
    co_weakreflist              : PPyObject;
    co_executors                : P_PyExecutorArray;
    _co_cached                  : P_PyCoCached;
    _co_instrumentation_version : NativeUInt;
    _co_monitoring              : Pointer; // not implemented
    _co_unique_id               : Py_ssize_t;
    _co_firsttraceable          : integer;
    co_extra                    : Pointer;
    co_code_adaptive            : array[0..0] of AnsiChar;
  end;

  PyCodeEvent = (
    PY_CODE_EVENT_CREATE,
    PY_CODE_EVENT_DESTROY
  );

  PyCode_WatchCallback           = function(event: PyCodeEvent; co: PPyCodeObject): integer; cdecl;

  {* include/pyframe.h *}
  {* include/traceback.h   include/cpython/traceback.h *}
  _traceback = record
    ob_base     : PyObject;           // PyObject_HEAD
    tb_next     : PPyTracebackObject;
    tb_frame    : PPyFrameObject;
    tb_lasti    : integer;
    tb_lineno   : integer;
  end;
  PyTracebackObject = type _traceback;

  {* include/sliceobject.h *}
  PySliceObject = record
    ob_base     : PyObject;           // PyObject_HEAD
    start       : PPyObject;
    stop        : PPyObject;
    step        : PPyObject;
  end;

  {* include/cpython/cellobject.h *}
  {* include/iterobject.h *}
  {* include/cpython/initconfig.h *}
  TPyStatus_Type = (
    _PyStatus_TYPE_OK     = 0,
    _PyStatus_TYPE_ERROR  = 1,
    _PyStatus_TYPE_EXIT   = 2
  );

  PyStatus = record
    _type     : TPyStatus_Type;
    func      : PAnsiChar;
    err_msg   : PAnsiChar;
    exitcode  : Integer;
  end;

  PyWideStringList = record
    length : Py_ssize_t;
    items  : PPWCharT;
  end;

  PyPreConfig = record
    _config_init               : integer;
    parse_argv                 : integer;
    isolated                   : integer;
    use_environment            : integer;
    configure_locale           : integer;
    coerce_c_locale            : integer;
    coerce_c_locale_warn       : integer;
    {$IFDEF MSWINDOWS}
    legacy_windows_fs_encoding : integer;
    {$ENDIF}
    utf8_mode                  : integer;
    dev_mode                   : integer;
    allocator                  : integer;
  end;

  {* include/pystate.h *}
  PyGILState_STATE = (
    PyGILState_LOCKED,
    PyGILState_UNLOCKED
  );

  Py_tracefunc = function(obj1: PPyObject; frame: PPyFrameObject; i: integer; obj2: PPyObject): integer; cdecl;

  {* include/cpython/genobject.h *}
  {* include/descrobject.h *}
  getter           = function(obj: PPyObject; context: Pointer): PPyObject; cdecl;
  setter           = function(obj, value: PPyObject; context: Pointer): integer; cdecl;
  wrapperfunc      = function(self, args: PPyObject; wrapped: Pointer): PPyObject; cdecl;
  wrapperfunc_kwds = function(self, args: PPyObject; wrapped: Pointer; kwds: PPyObject): PPyObject; cdecl;

  PyGetSetDef = record
    name    : PAnsiChar;
    get     : getter;
    set_    : setter;
    doc     : PAnsiChar;
    closure : Pointer;
  end;

  PyMemberDef = record
    name   : PAnsiChar;
    type_  : integer;
    offset : Py_ssize_t;
    flags  : Integer;
    doc    : PAnsiChar;
  end;

  wrapperbase = record
    name_       : PAnsiChar;
    offset      : integer;
    function_   : Pointer;
    wrapper     : wrapperfunc;
    doc         : PAnsiChar;
    flags       : integer;
    name_strobj : PPyObject;
  end;

  PyDescrObject = record
    ob_base    : PyObject; // PyObject_HEAD
    d_type     : PPyTypeObject;
    d_name     : PPyObject;
    d_qualname : PPyObject;
  end;

  PyMethodDescrObject = record
    d_common   : PyDescrObject; // PyDescr_COMMON;
    d_method   : PPyMethodDef;
    vectorcall : vectorcallfunc;
  end;

  PyMemberDescrObject = record
    d_common   : PyDescrObject; // PyDescr_COMMON;
    d_member   : PPyMemberDef;
  end;

  PyGetSetDescrObject = record
    d_common   : PyDescrObject; // PyDescr_COMMON;
    d_getset   : PPyGetSetDef;
  end;

  PyWrapperDescrObject = record
    d_common   : PyDescrObject; // PyDescr_COMMON;
    d_base     : Pwrapperbase;
    d_wrapped  : Pointer;
  end;

  {* include/genericaliasobject.h *}
  {* include/warnings.h *}
  {* include/weakrefobject.h *}
  _PyWeakReference = record
    ob_base                : PyObject; // PyObject_HEAD
    wr_object              : PPyObject;
    wr_callback            : PPyObject;
    hash                   : Py_hash_t;
    wr_prev                : PPyWeakReference;
    wr_next                : PPyWeakReference;
    vectorcall             : vectorcallfunc;
  end;
  PyWeakReference = type _PyWeakReference;

  {* include/structseq.h *}
  PyStructSequence_Field = record
    name_     : PAnsiChar;
    doc       : PAnsiChar;
  end;

  PyStructSequence_Desc = record
    name_         : PAnsiChar;
    doc           : PAnsiChar;
    fields        : PPyStructSequence_Field;
    n_in_sequence : integer;
  end;

  {* include/cpython/picklebufobject.h *}
  {* include/cpython/pytime.h *}
  PyTime_t           = type int64;

  {* include/codecs.h *}
  {* include/pythread.h *}
  PyThread_start_new_thread_func = procedure(arg: Pointer); cdecl;

  PY_TIMEOUT_T       = type int64;

  PyLockStatus = (
    PY_LOCK_FAILURE  = 0,
    PY_LOCK_ACQUIRED = 1,
    PY_LOCK_INTR
  );

  {* include/cpython/context.h *}
  PyContextEvent = (
    Py_CONTEXT_SWITCHED = 1
  );

  PyContext_WatchCallback = function(event: PyContextEvent; obj: PPyObject): integer; cdecl;

  {* include/modsupport.h *}
  {* include/compile.h *}
  PyCompilerFlags = record
    cf_flags           : integer;
    cf_feature_version : integer;
  end;

  {* include/pythonrun.h *}
  {* include/pylifecycle.h *}
  AtExitProc         = procedure(); cdecl;
  PyOS_sighandler_t  = procedure(i: Integer); cdecl;

  PyInterpreterConfig = record
    use_main_obmalloc             : Integer;
    allow_fork                    : Integer;
    allow_exec                    : Integer;
    allow_threads                 : Integer;
    allow_daemon_threads          : Integer;
    check_multi_interp_extensions : Integer;
    gil                           : Integer;
  end;

  {* include/ceval.h *}
  Py_AddPendingCall_func = function(ptr: pointer): integer; cdecl;

  {* include/sysmodule.h *}
  {* include/audit.h *}
  Py_AuditHookFunction = function(const str: PAnsiChar; obj: PPyObject; ptr: Pointer): integer; cdecl;

  {* include/osmodule.h *}
  {* include/intrcheck.h *}
  {* include/import.h *}
  initfunc = function(): PPyObject; cdecl;

  _inittab = record
    name_      : PAnsiChar;
    initfunc_  : initfunc;
  end;

  _frozen = record
    name_      : PAnsiChar;
    code       : PAnsiChar;
    size_       : integer;
    is_package : integer;
  end;

  {* include/abstract.h *}
  {* include/bltinmodule.h *}
  {* include/cpython/pyctype.h *}
  {* include/pystrtod.h *}
  {* include/pystrcmp.h *}
  {* include/fileutils.h *}
  {* include/cpython/pyfpe.h *}
  {* include/cpython/tracemalloc.h *}
  {* include/frameobject.h  include/cpython/frameobject.h *}
  PyFrameLocalsProxyObject = record
    ob_base    : PyObject; // PyObject_HEAD
    frame      : PPyFrameObject;
  end;

  {* include/datetime.h *}
  PyDateTime_Delta = record
    ob_base     : PyObject; // PyObject_HEAD
    hashcode    : Py_hash_t;
    days        : Integer;
    seconds     : Integer;
    microseconds: Integer;
  end;

  PyDateTime_TZInfo = record
    ob_base     : PyObject; // PyObject_HEAD
  end;

  _PyDateTime_BaseTZInfo = record
    ob_base     : PyObject; // PyObject_HEAD  // _PyTZINFO_HEAD
    hashcode    : Py_hash_t;                  // _PyTZINFO_HEAD
    hastzinfo   : AnsiChar;                   // _PyTZINFO_HEAD
  end;

  _PyDateTime_BaseTime = record
    ob_base     : PyObject;            // PyObject_HEAD  // _PyTZINFO_HEAD  // _PyDateTime_TIMEHEAD
    hashcode    : Py_hash_t;                             // _PyTZINFO_HEAD  // _PyDateTime_TIMEHEAD
    hastzinfo   : AnsiChar;                              // _PyTZINFO_HEAD  // _PyDateTime_TIMEHEAD
    data        : array [0..pred(_PyDateTime_TIME_DATASIZE)] of AnsiChar;   // _PyDateTime_TIMEHEAD
  end;

  PyDateTime_Time = record
    ob_base     : PyObject;            // PyObject_HEAD  // _PyTZINFO_HEAD  // _PyDateTime_TIMEHEAD
    hashcode    : Py_hash_t;                             // _PyTZINFO_HEAD  // _PyDateTime_TIMEHEAD
    hastzinfo   : AnsiChar;                              // _PyTZINFO_HEAD  // _PyDateTime_TIMEHEAD
    data        : array [0..pred(_PyDateTime_TIME_DATASIZE)] of AnsiChar;   // _PyDateTime_TIMEHEAD
    fold        : AnsiChar;
    tzinfo      : PPyObject;
  end;

  PyDateTime_Date = record
    ob_base     : PyObject; // PyObject_HEAD  // _PyTZINFO_HEAD
    hashcode    : Py_hash_t;                  // _PyTZINFO_HEAD
    hastzinfo   : AnsiChar;                   // _PyTZINFO_HEAD
    data        : array [0..pred(_PyDateTime_DATE_DATASIZE)] of AnsiChar;
  end;

  _PyDateTime_BaseDateTime = record
    ob_base     : PyObject;           // PyObject_HEAD  // _PyTZINFO_HEAD  // _PyDateTime_DATETIMEHEAD
    hashcode    : Py_hash_t;                            // _PyTZINFO_HEAD  // _PyDateTime_DATETIMEHEAD
    hastzinfo   : AnsiChar;                             // _PyTZINFO_HEAD  // _PyDateTime_DATETIMEHEAD
    data        : array [0..pred(_PyDateTime_DATE_DATASIZE)] of AnsiChar;  // _PyDateTime_DATETIMEHEAD
  end;

  PyDateTime_DateTime = record
    ob_base     : PyObject;           // PyObject_HEAD  // _PyTZINFO_HEAD  // _PyDateTime_DATETIMEHEAD
    hashcode    : Py_hash_t;                            // _PyTZINFO_HEAD  // _PyDateTime_DATETIMEHEAD
    hastzinfo   : AnsiChar;                             // _PyTZINFO_HEAD  // _PyDateTime_DATETIMEHEAD
    data        : array [0..pred(_PyDateTime_DATE_DATASIZE)] of AnsiChar;  // _PyDateTime_DATETIMEHEAD
    fold        : AnsiChar;
    tzinfo      : PPyObject;
  end;

  PyDateTime_CAPI_Date_FromDate_func                   = function(i1, i2, i3: integer; type_: PPyTypeObject): PPyObject; cdecl;
  PyDateTime_CAPI_DateTime_FromDateAndTime_func        = function(i1, i2, i3, i4, i5, i6, i7: integer; obj: PPyObject; type_: PPyTypeObject): PPyObject; cdecl;
  PyDateTime_CAPI_Time_FromTime_func                   = function(i1, i2, i3, i4: integer; obj: PPyObject; type_: PPyTypeObject): PPyObject; cdecl;
  PyDateTime_CAPI_Delta_FromDelta_func                 = function(i1, i2, i3, i4: integer; type_: PPyTypeObject): PPyObject; cdecl;
  PyDateTime_CAPI_TimeZone_FromTimeZone_func           = function(offset, name_: PPyObject): PPyObject; cdecl;
  PyDateTime_CAPI_DateTime_FromTimestamp_func          = function(obj1, obj2, obj3: PPyObject): PPyObject; cdecl;
  PyDateTime_CAPI_Date_FromTimestamp_func              = function(obj1, obj2: PPyObject): PPyObject; cdecl;
  PyDateTime_CAPI_DateTime_FromDateAndTimeAndFold_func = function(i1, i2, i3, i4, i5, i6, i7: integer; obj: PPyObject; i8: integer; type_: PPyTypeObject): PPyObject; cdecl;
  PyDateTime_CAPI_Time_FromTimeAndFold_func            = function(i1, i2, i3, i4: integer; obj: PPyObject; i5: integer; type_: PPyTypeObject): PPyObject; cdecl;

  PyDateTime_CAPI = record
    DateType                        : PPyTypeObject;
    DateTimeType                    : PPyTypeObject;
    TimeType                        : PPyTypeObject;
    DeltaType                       : PPyTypeObject;
    TZInfoType                      : PPyTypeObject;
    TimeZone_UTC                    : PPyObject;
    Date_FromDate                   : PyDateTime_CAPI_Date_FromDate_func;
    DateTime_FromDateAndTime        : PyDateTime_CAPI_DateTime_FromDateAndTime_func;
    Time_FromTime                   : PyDateTime_CAPI_Time_FromTime_func;
    Delta_FromDelta                 : PyDateTime_CAPI_Delta_FromDelta_func;
    TimeZone_FromTimeZone           : PyDateTime_CAPI_TimeZone_FromTimeZone_func;
    DateTime_FromTimestamp          : PyDateTime_CAPI_DateTime_FromTimestamp_func;
    Date_FromTimestamp              : PyDateTime_CAPI_Date_FromTimestamp_func;
    DateTime_FromDateAndTimeAndFold : PyDateTime_CAPI_DateTime_FromDateAndTimeAndFold_func;
    Time_FromTimeAndFold            : PyDateTime_CAPI_Time_FromTimeAndFold_func;
  end;


  {* Include/internal/pycore_frame.h *}
  _frame  = record
    ob_base                     : PyObject; // PyObject_HEAD
    f_back                      : PPyFrameObject;
    f_frame                     : Pointer; // not implemented. pointer to _PyInterpreterFrame; /Include/internal/pycore_interpframe_structs.h
    f_trace                     : PPyObject;
    f_lineno                    : integer;
    f_trace_lines               : AnsiChar;
    f_trace_opcodes             : AnsiChar;
    f_extra_locals              : PPyObject;
    f_locals_cache              : PPyObject;
    f_overwritten_fast_locals   : PPyObject;
    _f_frame_data               : array[0..0] of PPyObject;
  end;
  PyFrameObject = type _frame;

implementation

end.
