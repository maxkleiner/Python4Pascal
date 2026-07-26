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

{$IFNDEF FPC}
  {$IFNDEF DELPHI12_UP}
    NativeUInt    = Cardinal;
    PNativeUInt   = ^NativeUInt;
    NativeInt     = Integer;
    uint16        = Word;
    {$IFNDEF DELPHI7_UP}
    uint64        = type int64;
    PPAnsiChar    = array of PChar;
    {$ENDIF}
    PUint64       = ^uint64;
    UnicodeString = type WideString;
  {$ENDIF}
  {$IFNDEF DELPHI15_UP}
    TThreadID     = LongWord;
  {$ENDIF}
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

  /// <summary>
  /// Codec error handling.
  /// </summary>
  TPyCodecErrors = (
    /// <summary>
    /// Equivalent to "strict" error handling.
    /// </summary>
    pceStrict,
    /// <summary>
    /// Equivalent to "replace" error handling.
    /// </summary>
    pceReplace,
    /// <summary>
    /// Equivalent to "ignore" error handling.
    /// </summary>
    pceIgnore,
    /// <summary>
    /// Equivalent to "surrogateescape" error handling.
    /// </summary>
    pceSurrogateEscape
  );

  /// <summary>
  /// Byte order used by decoders.
  /// </summary>
  TPyBiteOrder = (
    /// <summary>
    /// Little endian.
    /// </summary>
    pboLittleEndian = -1,
    /// <summary>
    /// Native order.
    /// </summary>
    pboNativeOrder  = 0,
    /// <summary>
    /// Big endian.
    /// </summary>
    pboBigEndian    = 1
  );

  /// <summary>
  /// Order of the memory chuck.
  /// </summary>
  TPyMemoryViewOrder = (
    /// <summary>
    /// "C" order.
    /// </summary>
    pmvoC,
    /// <summary>
    /// "Fortran" order.
    /// </summary>
    pmvoFortran
  );

  /// <summary>
  /// Order of the buffer.
  /// </summary>
  TPyBufferOrder = (
    /// <summary>
    /// "C" style.
    /// </summary>
    pboC,
    /// <summary>
    /// "Fortran" style.
    /// </summary>
    pboFortran,
    /// <summary>
    /// Either one.
    /// </summary>
    pboEitherOne
  );

  /// <summary>
  /// Format code used to convert a double to a string.
  /// </summary>
  TPyDoubleToStringFormatCode = (
    fc_lowercase_e,
    fc_E,
    fc_lowercase_f,
    fc_F,
    fc_lowercase_g,
    fc_G,
    fc_r
  );

  /// <summary>
  /// GIL mode used by the interpreter.
  /// </summary>
  TPyInterpreterCfgGIL = (
    gilDefault,
    gilShared,
    gilOwn
  );

  /// <summary>
  /// Daylight Saving Time (DST).
  /// </summary>
  TPyDaylightSavingTime = (
    dstUnknown = -1,
    dstWinter  = 0,
    dstSummer  = 1
  );

  /// <summary>
  /// Custom integer open array.
  /// </summary>
  TCustomIntArray = array of integer;

  /// <summary>
  /// Named parameter description.
  /// </summary>
  TNamedParamDesc = record
    Index : Integer;
    Name  : PAnsiChar;
  end;
  /// <summary>
  /// Named parameter description array.
  /// </summary>
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


  /// <summary>
  /// Custom PPyObject open array.
  /// </summary>
  PPyObjectArray = array of PPyObject;


  {* include/pyport.h *}
  Py_uintptr_t       = type NativeUInt;
  Py_intptr_t        = type NativeInt;
  /// <summary>
  /// A signed integral type such that sizeof(Py_ssize_t) == sizeof(size_t).
  /// C99 doesn't define such a thing directly (size_t is an unsigned integral
  /// type). See PEP 353 for details. PY_SSIZE_T_MAX is the largest positive
  /// value of type Py_ssize_t.
  /// </summary>
  Py_ssize_t         = type Py_intptr_t;
  /// <summary>
  /// Hash value type: signed integer.
  /// </summary>
  Py_hash_t          = type Py_ssize_t;
  /// <summary>
  /// Hash value type: unsigned integer.
  /// </summary>
  Py_uhash_t         = type NativeUInt;
  Py_ssize_clean_t   = type Py_ssize_t;

  /// <summary>
  /// Custom Py_ssize_t open array.
  /// </summary>
  Py_ssize_t_array   = array of Py_ssize_t;

  {* include/pymacro.h *}
  {* include/pymath.h *}
  {* include/pymem.h  Include/cpython/pymem.h *}

  /// <summary>
  /// Enum used to identify an allocator domain.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/memory.html#c.PyMemAllocatorDomain">See the article about PyMemAllocatorDomain.</see></para>
  /// </remarks>
  PyMemAllocatorDomain = (
    PYMEM_DOMAIN_RAW,
    PYMEM_DOMAIN_MEM,
    PYMEM_DOMAIN_OBJ
  );

  /// <summary>
  /// Python memory allocators.
  /// </summary>
  PyMemAllocatorName = (
    /// <summary>
    /// don't change memory allocators (use defaults).
    /// </summary>
    PYMEM_ALLOCATOR_NOT_SET        = 0,
    /// <summary>
    /// default memory allocators.
    /// </summary>
    PYMEM_ALLOCATOR_DEFAULT        = 1,
    /// <summary>
    /// default memory allocators with debug hooks.
    /// </summary>
    PYMEM_ALLOCATOR_DEBUG          = 2,
    /// <summary>
    /// use malloc() of the C library.
    /// </summary>
    PYMEM_ALLOCATOR_MALLOC         = 3,
    /// <summary>
    /// force usage of malloc() with debug hooks.
    /// </summary>
    PYMEM_ALLOCATOR_MALLOC_DEBUG   = 4,
    /// <summary>
    /// Python pymalloc memory allocator.
    /// </summary>
    PYMEM_ALLOCATOR_PYMALLOC       = 5,
    /// <summary>
    /// Python pymalloc memory allocator with debug hooks.
    /// </summary>
    PYMEM_ALLOCATOR_PYMALLOC_DEBUG = 6,
    /// <summary>
    /// use mimalloc, a fast malloc replacement.
    /// </summary>
    PYMEM_ALLOCATOR_MIMALLOC       = 7,
    /// <summary>
    /// use mimalloc, a fast malloc replacement with debug hooks.
    /// </summary>
    PYMEM_ALLOCATOR_MIMALLOC_DEBUG = 8
  );

  PyMemAllocatorEx_malloc  = function(ctx: Pointer; size_: NativeUInt): Pointer; cdecl;
  PyMemAllocatorEx_calloc  = function(ctx: Pointer; nelem, elsize: NativeUInt): Pointer; cdecl;
  PyMemAllocatorEx_realloc = function(ctx, ptr: Pointer; new_size: NativeUInt): Pointer; cdecl;
  PyMemAllocatorEx_free    = procedure(ctx, ptr: Pointer); cdecl;

  /// <summary>
  /// Record used to describe a memory block allocator.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/memory.html#c.PyMemAllocatorEx">See the article about PyMemAllocatorEx.</see></para>
  /// </remarks>
  PyMemAllocatorEx = record
    /// <summary>
    /// user context passed as first argument
    /// </summary>
    ctx     : Pointer;
    /// <summary>
    /// allocate a memory block
    /// </summary>
    malloc  : PyMemAllocatorEx_malloc;
    /// <summary>
    /// allocate a memory block initialized with zeros
    /// </summary>
    calloc  : PyMemAllocatorEx_calloc;
    /// <summary>
    /// allocate or resize a memory block
    /// </summary>
    realloc : PyMemAllocatorEx_realloc;
    /// <summary>
    /// free a memory block
    /// </summary>
    free    : PyMemAllocatorEx_free;
  end;

  {* include/pytypedefs.h *}
  {* include/pybuffer.h *}

  /// <summary>
  /// Buffer information
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/buffer.html#c.Py_buffer">See the article about Py_buffer.</see></para>
  /// </remarks>
  Py_buffer = record
    /// <summary>
    /// A pointer to the start of the logical structure described by the buffer
    /// fields. This can be any location within the underlying physical memory
    /// block of the exporter. For example, with negative strides the value may
    /// point to the end of the memory block. For contiguous arrays, the value
    /// points to the beginning of the memory block.
    /// </summary>
    buf        : Pointer;
    /// <summary>
    /// A new reference to the exporting object. The reference is owned by the
    /// consumer and automatically released (i.e. reference count decremented)
    /// and set to NULL by PyBuffer_Release(). The field is the equivalent of
    /// the return value of any standard C-API function. As a special case, for
    /// temporary buffers that are wrapped by PyMemoryView_FromBuffer() or
    /// PyBuffer_FillInfo() this field is NULL. In general, exporting objects
    /// MUST NOT use this scheme.
    /// </summary>
    obj        : PPyObject;
    /// <summary>
    /// product(shape) * itemsize. For contiguous arrays, this is the length of
    /// the underlying memory block. For non-contiguous arrays, it is the length
    /// that the logical structure would have if it were copied to a contiguous
    /// representation. Accessing ((char *)buf)[0] up to ((char *)buf)[len-1]
    /// is only valid if the buffer has been obtained by a request that
    /// guarantees contiguity. In most cases such a request will be
    /// PyBUF_SIMPLE or PyBUF_WRITABLE.
    /// </summary>
    len        : Py_ssize_t;
    /// <summary>
    /// Item size in bytes of a single element. Same as the value of
    /// struct.calcsize() called on non-NULL format values.
    /// Important exception: If a consumer requests a buffer without the
    /// PyBUF_FORMAT flag, format will be set to NULL, but itemsize still has
    /// the value for the original format.
    /// If shape is present, the equality product(shape) * itemsize == len
    /// still holds and the consumer can use itemsize to navigate the buffer.
    /// If shape is NULL as a result of a PyBUF_SIMPLE or a PyBUF_WRITABLE
    /// request, the consumer must disregard itemsize and assume itemsize == 1.
    /// </summary>
    itemsize   : Py_ssize_t;
    /// <summary>
    /// An indicator of whether the buffer is read-only. This field is
    /// controlled by the PyBUF_WRITABLE flag.
    /// </summary>
    readonly   : Integer;
    /// <summary>
    /// The number of dimensions the memory represents as an n-dimensional
    /// array. If it is 0, buf points to a single item representing a scalar.
    /// In this case, shape, strides and suboffsets MUST be NULL. The maximum
    /// number of dimensions is given by PyBUF_MAX_NDIM.
    /// </summary>
    ndim       : Integer;
    /// <summary>
    /// A NULL terminated string in struct module style syntax describing the
    /// contents of a single item. If this is NULL, "B" (unsigned bytes) is
    /// assumed. This field is controlled by the PyBUF_FORMAT flag.
    /// </summary>
    format     : PAnsiChar;
    /// <summary>
    /// An array of Py_ssize_t of length ndim indicating the shape of the
    /// memory as an n-dimensional array. Note that
    /// shape[0] * ... * shape[ndim-1] * itemsize MUST be equal to len.
    /// Shape values are restricted to shape[n] >= 0. The case shape[n] == 0
    /// requires special attention. See complex arrays for further information.
    /// The shape array is read-only for the consumer.
    /// </summary>
    shape      : PPy_ssize_t;
    /// <summary>
    /// An array of Py_ssize_t of length ndim giving the number of bytes to
    /// skip to get to a new element in each dimension.
    /// Stride values can be any integer. For regular arrays, strides are
    /// usually positive, but a consumer MUST be able to handle the case
    /// strides[n] <= 0. See complex arrays for further information.
    /// The strides array is read-only for the consumer.
    /// </summary>
    strides    : PPy_ssize_t;
    /// <summary>
    /// An array of Py_ssize_t of length ndim. If suboffsets[n] >= 0, the
    /// values stored along the nth dimension are pointers and the suboffset
    /// value dictates how many bytes to add to each pointer after
    /// de-referencing. A suboffset value that is negative indicates that no
    /// de-referencing should occur (striding in a contiguous memory block).
    /// If all suboffsets are negative (i.e. no de-referencing is needed), then
    /// this field must be NULL (the default value).
    /// This type of array representation is used by the Python Imaging
    /// Library (PIL). See complex arrays for further information how to access
    /// elements of such an array.
    /// The suboffsets array is read-only for the consumer.
    /// </summary>
    suboffsets : PPy_ssize_t;
    /// <summary>
    /// This is for use internally by the exporting object. For example, this
    /// might be re-cast as an integer by the exporter and used to store flags
    /// about whether or not the shape, strides, and suboffsets arrays must be
    /// freed when the buffer is released. The consumer MUST NOT alter this
    /// value.
    /// </summary>
    internal   : Pointer;
  end;

  getbufferproc                  = function(exporter: PPyObject; view: PPy_buffer; flags: Integer): Integer; cdecl;
  releasebufferproc              = procedure(exporter: PPyObject; view: PPy_buffer); cdecl;

  {* include/pystats.h *}
  {* include/pyatomic.h *}
  {* include/lock.h *}

  /// <summary>
  /// A mutual exclusion lock. The PyMutex should be initialized to zero to
  /// represent the unlocked state.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/synchronization.html#c.PyMutex">See the article about PyMutex.</see></para>
  /// </remarks>
  PyMutex = record
    _bits : byte;
  end;

  {* include/critical_section.h   include/cpython/critical_section.h *}

  /// <summary>
  /// Python critical section
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/synchronization.html#python-critical-section-api">See the article about the Python critical section API.</see></para>
  /// </remarks>
  PyCriticalSection = record
    _cs_prev  : Py_uintptr_t;
    _cs_mutex : PPyMutex;
  end;

  /// <summary>
  /// Python critical section
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/synchronization.html#python-critical-section-api">See the article about the Python critical section API.</see></para>
  /// </remarks>
  PyCriticalSection2 = record
    _cs_base   : PyCriticalSection;
    _cs_mutex2 : PPyMutex;
  end;

  {* include/object.h *}
  /// <summary>
  /// Internal PyObject record.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyObject">See the article about PyObject.</see></para>
  /// </remarks>
  _object = record
    /// <summary>
    /// Reference count.
    /// </summary>
    ob_refcnt : Py_ssize_t;
    /// <summary>
    /// Object type.
    /// </summary>
    ob_type   : PPyTypeObject;
  end;

  /// <summary>
  /// All object types are extensions of this type. This is a type which
  /// contains the information Python needs to treat a pointer to an object as
  /// an object. In a normal "release" build, it contains only the object's
  /// reference count and a pointer to the corresponding type object.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyObject">See the article about PyObject.</see></para>
  /// </remarks>
  PyObject = type _object;

  /// <summary>
  /// An extension of PyObject that adds the ob_size field. This is intended
  /// for objects that have some notion of length.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyVarObject">See the article about PyVarObject.</see></para>
  /// </remarks>
  PyVarObject = record
    ob_base  : PyObject;
    /// <summary>
    /// Number of items in variable part
    /// </summary>
    ob_size  : Py_ssize_t;
  end;

  /// <summary>
  /// The enum value used to represent different results of PyIter_Send().
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/iter.html#c.PySendResult">See the article about PySendResult.</see></para>
  /// </remarks>
  PySendResult = (
    /// <summary>
    /// if iterator has raised and exception. presult is set to NULL.
    /// </summary>
    PYGEN_ERROR  = -1,
    /// <summary>
    /// if iterator returns. Return value is returned via presult.
    /// </summary>
    PYGEN_RETURN = 0,
    /// <summary>
    /// if iterator yields. Yielded value is returned via presult.
    /// </summary>
    PYGEN_NEXT   = 1
  );

  /// <summary>
  /// Multiple interpreter support in a module slot.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/module.html#c.Py_mod_multiple_interpreters">See the article about Py_mod_multiple_interpreters.</see></para>
  /// </remarks>
  TMultIntprSupport = (
    /// <summary>
    /// The module supports being imported in subinterpreters, but only when they share the main interpreter's GIL. (See Isolating Extension Modules.)
    /// </summary>
    miSupported,
    /// <summary>
    /// The module does not support being imported in subinterpreters.
    /// </summary>
    miUnsupported,
    /// <summary>
    /// The module supports being imported in subinterpreters, even when they have their own GIL. (See Isolating Extension Modules.)
    /// </summary>
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

  /// <summary>
  /// Record defining optional functionality of a type, containing a slot ID
  /// and a value pointer.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/type.html#c.PyType_Slot">See the article about PyType_Slot.</see></para>
  /// </remarks>
  PyType_Slot = record
    /// <summary>
    /// A slot ID. Slot IDs are named like the field names of the structures
    /// PyTypeObject, PyNumberMethods, PySequenceMethods, PyMappingMethods and
    /// PyAsyncMethods with an added Py_ prefix.
    /// </summary>
    slot   : integer;
    /// <summary>
    /// The desired value of the slot. In most cases, this is a pointer to a
    /// function.
    /// </summary>
    pfunc  : Pointer;
  end;

  /// <summary>
  /// Record defining a type's behavior.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/type.html#c.PyType_Spec">See the article about PyType_Spec.</see></para>
  /// </remarks>
  PyType_Spec = record
    /// <summary>
    /// Name of the type, used to set PyTypeObject.tp_name.
    /// </summary>
    name      : PAnsiChar;
    /// <summary>
    /// If positive, specifies the size of the instance in bytes. It is used to
    /// set PyTypeObject.tp_basicsize.
    /// If zero, specifies that tp_basicsize should be inherited.
    /// If negative, the absolute value specifies how much space instances of
    /// the class need in addition to the superclass. Use PyObject_GetTypeData()
    /// to get a pointer to subclass-specific memory reserved this way.
    /// For negative basicsize, Python will insert padding when needed to meet
    /// tp_basicsize's alignment requirements.
    /// </summary>
    basicsize : integer;
    /// <summary>
    /// Size of one element of a variable-size type, in bytes. Used to set
    /// PyTypeObject.tp_itemsize. See tp_itemsize documentation for caveats.
    /// </summary>
    itemsize  : integer;
    /// <summary>
    /// Type flags, used to set PyTypeObject.tp_flags.
    /// </summary>
    flags     : cardinal;
    /// <summary>
    /// Array of PyType_Slot structures. Terminated by the special slot
    /// value {0, NULL}.
    /// </summary>
    slots     : PPyType_Slot;
  end;

  /// <summary>
  /// This structure holds pointers to the functions which an object uses to
  /// implement the number protocol.
  /// Each function is used by the function of similar name documented in the
  /// Number Protocol section.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/typeobj.html#c.PyNumberMethods">See the article about PyNumberMethods.</see></para>
  /// </remarks>
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

  /// <summary>
  /// This structure holds pointers to the functions which an object uses to
  /// implement the sequence protocol.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/typeobj.html#c.PySequenceMethods">See the article about PySequenceMethods.</see></para>
  /// </remarks>
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

  /// <summary>
  /// This structure holds pointers to the functions which an object uses to
  /// implement the mapping protocol.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/typeobj.html#c.PyMappingMethods">See the article about PyMappingMethods.</see></para>
  /// </remarks>
  PyMappingMethods = record
    mp_length	       : lenfunc;
    mp_subscript     : binaryfunc;
    mp_ass_subscript : objobjargproc;
  end;

  /// <summary>
  /// This structure holds pointers to the functions required to implement
  /// awaitable and asynchronous iterator objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/typeobj.html#c.PyAsyncMethods">See the article about PyAsyncMethods.</see></para>
  /// </remarks>
  PyAsyncMethods = record
    am_await : unaryfunc;
    am_aiter : unaryfunc;
    am_anext : unaryfunc;
    am_send  : sendfunc;
  end;

  /// <summary>
  /// This structure holds pointers to the functions required by the Buffer
  /// protocol.
  /// The protocol defines how an exporter object can expose its internal data
  /// to consumer objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/typeobj.html#c.PyBufferProcs">See the article about PyBufferProcs.</see></para>
  /// </remarks>
  PyBufferProcs = record
    bf_getbuffer     : getbufferproc;
    bf_releasebuffer : releasebufferproc;
  end;

  /// <summary>
  /// Internal record that represents a PyTypeObject.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/type.html#c.PyTypeObject">See the article about PyTypeObject.</see></para>
  /// </remarks>
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

  /// <summary>
  /// The structure of the objects used to describe built-in types.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/type.html#c.PyTypeObject">See the article about PyTypeObject.</see></para>
  /// </remarks>
  PyTypeObject = type _typeobject;

  /// <summary>
  /// This struct is used by the specializer. It should be treated as an opaque blob by code other than the specializer and interpreter.
  /// </summary>
  _specialization_cache = record
    getitem         : PPyObject;
    getitem_version : cardinal;
    init            : PPyObject;
  end;

  /// <summary>
  /// Layout of a type object when allocated on the heap.
  /// </summary>
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

  /// <summary>
  /// Record used to describe an arena allocator.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/memory.html#c.PyObjectArenaAllocator">See the article about PyObjectArenaAllocator.</see></para>
  /// </remarks>
  PyObjectArenaAllocator = record
    /// <summary>
    /// user context passed as first argument
    /// </summary>
    ctx    : Pointer;
    /// <summary>
    /// allocate an arena of size bytes
    /// </summary>
    alloc_ : PyObjectArenaAllocator_alloc;
    /// <summary>
    /// free an arena
    /// </summary>
    free_  : PyObjectArenaAllocator_free;
  end;

  {* include/typeslots.h *}
  {* include/pyhash.h *}
  PyHash_FuncDef_hash = function(ptr: Pointer; size_: Py_ssize_t): Py_hash_t; cdecl;

  /// <summary>
  /// Hash function definition used by PyHash_GetFuncDef().
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/hash.html#c.PyHash_FuncDef">See the article about PyHash_FuncDef.</see></para>
  /// </remarks>
  PyHash_FuncDef = record
    /// <summary>
    /// Hash function.
    /// </summary>
    hash                : PyHash_FuncDef_hash;
    /// <summary>
    /// Hash function name (UTF-8 encoded string). This corresponds to the sys.hash_info.algorithm constant.
    /// </summary>
    name_               : PAnsiChar;
    /// <summary>
    /// Internal size of the hash value in bits. This corresponds to the sys.hash_info.hash_bits constant.
    /// </summary>
    hash_bits           : integer;
    /// <summary>
    /// Size of seed input in bits. This corresponds to the sys.hash_info.seed_bits constant.
    /// </summary>
    seed_bits           : integer;
  end;

  {* include/cpython/pydebug.h *}
  {* include/bytearrayobject.h *}

  /// <summary>
  /// This subtype of PyObject represents a Python bytearray object.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/bytearray.html#c.PyByteArrayObject">See the article about PyByteArrayObject.</see></para>
  /// </remarks>
  PyByteArrayObject = record
    ob_base              : PyVarObject; // PyObject_VAR_HEAD
    ob_alloc             : Py_ssize_t;
    ob_bytes             : PAnsiChar;
    ob_start             : PAnsiChar;
    ob_exports           : Py_ssize_t;
  end;

  {* include/bytesobject.h *}

  /// <summary>
  /// This subtype of PyObject represents a Python bytes object.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/bytes.html#c.PyBytesObject">See the article about PyBytesObject.</see></para>
  /// </remarks>
  PyBytesObject = record
    ob_base              : PyVarObject; // PyObject_VAR_HEAD
    ob_sval              : array[0..0] of AnsiChar;
  end;

  {* include/unicodeobject.h *}

  /// <summary>
  /// This type is a typedef for unsigned integer types wide enough to contain
  /// characters of 32 bits. When dealing with single Unicode characters,
  /// use Py_UCS4.
  /// </summary>
  Py_UCS4            = type cardinal;
  /// <summary>
  /// This type is a typedef for unsigned integer types wide enough to contain
  /// characters of 16 bits. When dealing with single Unicode characters,
  /// use Py_UCS4.
  /// </summary>
  Py_UCS2            = type word;
  /// <summary>
  /// This type is a typedef for unsigned integer types wide enough to contain
  /// characters of 8 bits. When dealing with single Unicode characters,
  /// use Py_UCS4.
  /// </summary>
  Py_UCS1            = type byte;

  /// <summary>
  /// Return values of PyUnicode_KIND().
  /// "PyUnicode_Kind_Result" is a renamed type for "PyUnicode_Kind"
  /// </summary>
  PyUnicode_Kind_Result = (
    PyUnicode_1BYTE_KIND = 1,
    PyUnicode_2BYTE_KIND = 2,
    PyUnicode_4BYTE_KIND = 4
  );

  {* include/pyerrors.h  include/cpython/pyerrors.h *}
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

  /// <summary>
  /// Layout of an array of "digits" ("limbs" in the GMP terminology), used to
  /// represent absolute value for arbitrary precision integers.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/long.html#c.PyLongLayout">See the article about PyLongLayout.</see></para>
  /// </remarks>
  PyLongLayout = record
    /// <summary>
    /// Bits per digit. For example, a 15 bit digit means that bits 0-14
    /// contain meaningful information.
    /// </summary>
    bits_per_digit   : byte;
    /// <summary>
    /// Digit size in bytes. For example, a 15 bit digit will require at least
    /// 2 bytes.
    /// </summary>
    digit_size       : byte;
    /// <summary>
    /// Digits order: 1 for most significant digit first. -1 for least
    /// significant digit first.
    /// </summary>
    digits_order     : shortint;
    /// <summary>
    /// Digit endianness: 1 for most significant byte first (big endian). -1 for
    /// least significant byte first (little endian).
    /// </summary>
    digit_endianness : shortint;
  end;

  /// <summary>
  /// Export of a Python int object. There are two cases: If digits is NULL,
  /// only use the value member. If digits is not NULL, use negative, ndigits
  /// and digits members.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/long.html#c.PyLongExport">See the article about PyLongExport.</see></para>
  /// </remarks>
  PyLongExport = record
    /// <summary>
    /// The native integer value of the exported int object. Only valid if digits is NULL.
    /// </summary>
    value     : int64;
    /// <summary>
    /// 1 if the number is negative, 0 otherwise. Only valid if digits is not NULL.
    /// </summary>
    negative  : byte;
    /// <summary>
    /// Number of digits in digits array. Only valid if digits is not NULL.
    /// </summary>
    ndigits   : Py_ssize_t;
    /// <summary>
    /// Read-only array of unsigned digits. Can be NULL.
    /// </summary>
    digits    : Pointer;
    /// <summary>
    /// Reserved
    /// </summary>
    _reserved : Py_uintptr_t;
  end;

  {* include/boolobject.h *}
  {* include/floatobject.h *}

  /// <summary>
  /// This subtype of PyObject represents a Python floating-point object.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/float.html#c.PyFloatObject">See the article about PyFloatObject.</see></para>
  /// </remarks>
  PyFloatObject = record
    ob_base    : PyObject; // PyObject_HEAD
    ob_fval    : double;
  end;

  {* include/complexobject.h *}

  /// <summary>
  /// The structure which corresponds to the value portion of a Python complex
  /// number object. Most of the functions for dealing with complex number
  /// objects use structures of this type as input or output values, as
  /// appropriate.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/complex.html#c.Py_complex">See the article about Py_complex.</see></para>
  /// </remarks>
  Py_complex = record
    real : double;
    imag : double;
  end;

  /// <summary>
  /// This subtype of PyObject represents a Python complex number object.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/complex.html#c.PyComplexObject">See the article about PyComplexObject.</see></para>
  /// </remarks>
  PyComplexObject = record
    ob_base    : PyObject; // PyObject_HEAD
    cval       : Py_complex;
  end;

  {* include/rangeobject.h *}
  {* include/memoryobject.h *}
  {* include/tupleobject.h *}
  {* include/listobject.h *}
  {* include/dictobject.h *}

  /// <summary>
  /// This subtype of PyObject represents a Python dictionary object.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/dict.html#c.PyDictObject">See the article about PyDictObject.</see></para>
  /// </remarks>
  PyDictObject = record
    ob_base                : PyObject; // PyObject_HEAD
    /// <summary>
    /// Number of items in the dictionary
    /// </summary>
    ma_used                : Py_ssize_t;
    /// <summary>
    /// This is a private field for CPython's internal use.
    /// * Bits 0-7 are for dict watchers.
    /// * Bits 8-11 are for the watched mutation counter (used by tier2 optimization)
    /// * Bits 12-31 are currently unused
    /// * Bits 32-63 are a unique id in the free threading build (used for per-thread refcounting)
    /// </summary>
    _ma_watcher_tag        : uint64;
    /// <summary>
    ///
    /// </summary>
    ma_keys                : PPyDictKeysObject;
    /// <summary>
    /// If ma_values is NULL, the table is "combined": keys and values are
    /// stored in ma_keys.
    /// If ma_values is not NULL, the table is split: keys are stored in ma_keys
    /// and values are stored in ma_values
    /// </summary>
    ma_values              : PPyDictValues;
  end;

  /// <summary>
  /// Enumeration of possible dictionary watcher events.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/dict.html#c.PyDict_WatchEvent">See the article about PyDict_WatchEvent.</see></para>
  /// </remarks>
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

  /// <summary>
  /// Record used to describe a method of an extension type.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyMethodDef">See the article about PyMethodDef.</see></para>
  /// </remarks>
  PyMethodDef = record
    /// <summary>
    /// Name of the method.
    /// </summary>
     ml_name  : PAnsiChar;
    /// <summary>
    /// Pointer to the C implementation.
    /// </summary>
     ml_meth  : PyCFunction;
    /// <summary>
    /// Flags bits indicating how the call should be constructed.
    /// </summary>
     ml_flags : Integer;
    /// <summary>
    /// Points to the contents of the docstring.
    /// </summary>
     ml_doc   : PAnsiChar;
  end;
  PyMethodDefArray = array of PPyMethodDef;

  PyCFunctionObject = record
    ob_base       : PyObject; // PyObject_HEAD
    /// <summary>
    /// Description of the C function to call
    /// </summary>
    m_ml          : PPyMethodDef;
    /// <summary>
    /// Passed as 'self' arg to the C func, can be NULL
    /// </summary>
    m_self        : PPyObject;
    /// <summary>
    /// The __module__ attribute, can be anything
    /// </summary>
    m_module      : PPyObject;
    /// <summary>
    /// List of weak references
    /// </summary>
    m_weakreflist : PPyObject;
    vectorcall    : vectorcallfunc;
  end;

  PyCMethodObject = record
    func     : PyCFunctionObject;
    /// <summary>
    /// Class that defines this method
    /// </summary>
    mm_class : PPyTypeObject;
  end;

  {* include/moduleobject.h *}
  PyModuleDef_Base_m_init = function(): PPyObject; cdecl;

  PyModuleDef_Base = record
    ob_base    : PyObject; // PyObject_HEAD
    /// <summary>
    /// The function used to re-initialize the module.
    /// This is only set for legacy (single-phase init) extension modules
    /// and only used for those that support multiple initializations
    /// (m_size >= 0).
    /// It is set by _PyImport_LoadDynamicModuleWithSpec()
    /// and _imp.create_builtin().
    /// </summary>
    m_init     : PyModuleDef_Base_m_init;
    /// <summary>
    /// The module's index into its interpreter's modules_by_index cache.
    /// This is set for all extension modules but only used for legacy ones.
    /// (See PyInterpreterState.modules_by_index for more info.)
    /// It is set by PyModuleDef_Init().
    /// </summary>
    m_index    : Py_ssize_t;
    /// <summary>
    /// A copy of the module's __dict__ after the first time it was loaded.
    /// This is only set/used for legacy modules that do not support
    /// multiple initializations.
    /// It is set by fix_up_extension() in import.c.
    /// </summary>
    m_copy     : PPyObject;
  end;

  /// <summary>
  /// Slot definition.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModuleDef_Slot">See the article about PyModuleDef_Slot.</see></para>
  /// </remarks>
  PyModuleDef_Slot = record
    /// <summary>
    /// A slot ID. The possible values are: Py_mod_create, Py_mod_exec,
    /// Py_mod_multiple_interpreters and Py_mod_gil.
    /// </summary>
    slot  : integer;
    /// <summary>
    /// Value of the slot, whose meaning depends on the slot ID.
    /// </summary>
    value : Pointer;
  end;

  /// <summary>
  /// The module definition struct, which holds all information needed to create
  /// a module object. This structure must be statically allocated (or be
  /// otherwise guaranteed to be valid while any modules created from it exist).
  /// Usually, there is only one variable of this type for each extension module.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModuleDef">See the article about PyModuleDef.</see></para>
  /// </remarks>
  PyModuleDef = record
    /// <summary>
    /// Always initialize this member to PyModuleDef_HEAD_INIT.
    /// </summary>
    m_base     : PyModuleDef_Base;
    /// <summary>
    /// Name for the new module.
    /// </summary>
    m_name     : PAnsiChar;
    /// <summary>
    /// Docstring for the module; usually a docstring variable created with
    /// PyDoc_STRVAR is used.
    /// </summary>
    m_doc      : PAnsiChar;
    /// <summary>
    /// Module state may be kept in a per-module memory area that can be
    /// retrieved with PyModule_GetState(), rather than in static globals.
    /// This makes modules safe for use in multiple sub-interpreters.
    /// This memory area is allocated based on m_size on module creation, and
    /// freed when the module object is deallocated, after the m_free function
    /// has been called, if present.
    /// Setting it to a non-negative value means that the module can be
    /// re-initialized and specifies the additional amount of memory it requires
    /// for its state.
    /// Setting m_size to -1 means that the module does not support
    /// sub-interpreters, because it has global state. Negative m_size is only
    /// allowed when using legacy single-phase initialization or when creating
    /// modules dynamically.
    /// See PEP 3121 for more details.
    /// </summary>
    m_size     : Py_ssize_t;
    /// <summary>
    /// A pointer to a table of module-level functions, described by PyMethodDef
    /// values. Can be NULL if no functions are present.
    /// </summary>
    m_methods  : PPyMethodDef;
    /// <summary>
    /// An array of slot definitions for multi-phase initialization, terminated by a {0, NULL} entry. When using legacy single-phase initialization, m_slots must be NULL.
    /// </summary>
    m_slots    : PPyModuleDef_Slot;
    /// <summary>
    /// A traversal function to call during GC traversal of the module object,
    /// or NULL if not needed.
    /// This function is not called if the module state was requested but is not
    /// allocated yet. This is the case immediately after the module is created
    /// and before the module is executed (Py_mod_exec function). More precisely,
    /// this function is not called if m_size is greater than 0 and the module
    /// state (as returned by PyModule_GetState()) is NULL.
    /// Changed in version 3.9: No longer called before the module state is
    /// allocated.
    /// </summary>
    m_traverse : traverseproc;
    /// <summary>
    /// A clear function to call during GC clearing of the module object, or
    /// NULL if not needed.
    /// This function is not called if the module state was requested but is not
    /// allocated yet. This is the case immediately after the module is created
    /// and before the module is executed (Py_mod_exec function). More precisely,
    /// this function is not called if m_size is greater than 0 and the module
    /// state (as returned by PyModule_GetState()) is NULL.
    /// Like PyTypeObject.tp_clear, this function is not always called before a
    /// module is deallocated. For example, when reference counting is enough to
    /// determine that an object is no longer used, the cyclic garbage collector
    /// is not involved and m_free is called directly.
    /// Changed in version 3.9: No longer called before the module state is allocated.
    /// </summary>
    m_clear    : inquiry;
    /// <summary>
    /// A function to call during deallocation of the module object, or NULL if
    /// not needed.
    /// This function is not called if the module state was requested but is not
    /// allocated yet. This is the case immediately after the module is created
    /// and before the module is executed (Py_mod_exec function). More precisely,
    /// this function is not called if m_size is greater than 0 and the module
    /// state (as returned by PyModule_GetState()) is NULL.
    /// Changed in version 3.9: No longer called before the module state is allocated.
    /// </summary>
    m_free     : inquiry;
  end;

  {* include/monitoring.h *}

  /// <summary>
  /// Representation of the state of an event type. It is allocated by the user
  /// while its contents are maintained by the monitoring API functions described
  /// below.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/monitoring.html#c.PyMonitoringState">See the article about PyMonitoringState.</see></para>
  /// </remarks>
  PyMonitoringState = record
    active : byte;
    opaque : byte;
  end;

  {* include/cpython/funcobject.h *}

  /// <summary>
  /// The structure used for functions.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/function.html#c.PyFunctionObject">See the article about PyFunctionObject.</see></para>
  /// </remarks>
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
    /// <summary>
    /// The __doc__ attribute, can be anything
    /// </summary>
    func_doc         : PPyObject;
    /// <summary>
    /// The __dict__ attribute, a dict or NULL
    /// </summary>
    func_dict        : PPyObject;
    /// <summary>
    /// List of weak references
    /// </summary>
    func_weakreflist : PPyObject;
    /// <summary>
    /// The __module__ attribute, can be anything
    /// </summary>
    func_module      : PPyObject;
    /// <summary>
    /// Annotations, a dict or NULL
    /// </summary>
    func_annotations : PPyObject;
    /// <summary>
    /// Callable to fill the annotations dictionary
    /// </summary>
    func_annotate    : PPyObject;
    /// <summary>
    /// Tuple of active type variables or NULL
    /// </summary>
    func_typeparams  : PPyObject;
    /// <summary>
    /// Version number for use by specializer.
    /// Can set to non-zero when we want to specialize.
    /// Will be set to zero if any of these change:
    ///     defaults
    ///     kwdefaults (only if the object changes, not the contents of the dict)
    ///     code
    ///     annotations
    ///     vectorcall function pointer
    /// </summary>
    vectorcall       : vectorcallfunc;
    /// <summary>
    /// Invariant:
    /// func_closure contains the bindings for func_code->co_freevars, so
    /// PyTuple_Size(func_closure) == PyCode_GetNumFree(func_code)
    /// (func_closure may be NULL if PyCode_GetNumFree(func_code) == 0).
    /// </summary>
    func_version     : cardinal;
  end;

  /// <summary>
  /// Enumeration of possible function watcher events
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/function.html#c.PyFunction_WatchEvent">See the article about PyFunction_WatchEvent.</see></para>
  /// </remarks>
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
    /// <summary>
    /// The callable object implementing the method
    /// </summary>
    im_func          : PPyObject;
    /// <summary>
    /// The instance it is bound to
    /// </summary>
    im_self          : PPyObject;
    /// <summary>
    /// List of weak references
    /// </summary>
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

  /// <summary>
  /// The structure of the objects used to describe code objects. The fields of
  /// this type are subject to change at any time.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/code.html#c.PyCodeObject">See the article about PyCodeObject.</see></para>
  /// </remarks>
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

  /// <summary>
  /// Enumeration of possible code object watcher events:
  /// - PY_CODE_EVENT_CREATE
  /// - PY_CODE_EVENT_DESTROY
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/code.html#c.PyCodeEvent">See the article about PyCodeEvent.</see></para>
  /// </remarks>
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

  /// <summary>
  /// A slice object containing start, stop, and step data members (the
  /// names are from range). Py_None stands for omitted values.
  /// </summary>
  PySliceObject = record
    ob_base     : PyObject;           // PyObject_HEAD
    start       : PPyObject;
    stop        : PPyObject;
    step        : PPyObject;
  end;

  {* include/cpython/cellobject.h *}
  {* include/iterobject.h *}
  {* include/cpython/initconfig.h *}

  /// <summary>
  /// _type field values in PyStatus.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#c.PyStatus">See the article about PyStatus.</see></para>
  /// </remarks>
  TPyStatus_Type = (
    _PyStatus_TYPE_OK     = 0,
    _PyStatus_TYPE_ERROR  = 1,
    _PyStatus_TYPE_EXIT   = 2
  );

  /// <summary>
  /// Record to store an initialization function status: success, error or exit. For an error, it can store the function name which created the error.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#c.PyStatus">See the article about PyStatus.</see></para>
  /// </remarks>
  PyStatus = record
    /// <summary>
    /// PyStatus type
    /// </summary>
    _type     : TPyStatus_Type;
    /// <summary>
    /// Name of the function which created an error, can be NULL.
    /// </summary>
    func      : PAnsiChar;
    /// <summary>
    /// Error message.
    /// </summary>
    err_msg   : PAnsiChar;
    /// <summary>
    /// Exit code. Argument passed to exit().
    /// </summary>
    exitcode  : Integer;
  end;

  /// <summary>
  /// List of wchar_t* strings. If length is non-zero, items must be non-NULL and all strings must be non-NULL.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#c.PyWideStringList">See the article about PyWideStringList.</see></para>
  /// </remarks>
  PyWideStringList = record
    /// <summary>
    /// List length.
    /// </summary>
    length : Py_ssize_t;
    /// <summary>
    /// List items.
    /// </summary>
    items  : PPWCharT;
  end;

  /// <summary>
  /// Record used to preinitialize Python.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#pypreconfig">See the article about PyPreConfig.</see></para>
  /// </remarks>
  PyPreConfig = record
    /// <summary>
    /// _PyConfigInitEnum value
    /// </summary>
    _config_init               : integer;
    /// <summary>
    /// If non-zero, Py_PreInitializeFromArgs() and Py_PreInitializeFromBytesArgs()
    /// parse their argv argument the same way the regular Python parses command
    /// line arguments: see Command Line Arguments.
    /// Default: 1 in Python config, 0 in isolated config.
    /// </summary>
    parse_argv                 : integer;
    /// <summary>
    /// Isolated mode: see PyConfig.isolated.
    /// Default: 0 in Python mode, 1 in isolated mode.
    /// </summary>
    isolated                   : integer;
    /// <summary>
    /// Use environment variables? See PyConfig.use_environment.
    /// Default: 1 in Python config and 0 in isolated config.
    /// </summary>
    use_environment            : integer;
    /// <summary>
    /// Set the LC_CTYPE locale to the user preferred locale.
    /// If equals to 0, set coerce_c_locale and coerce_c_locale_warn members to 0.
    /// See the locale encoding.
    /// Default: 1 in Python config, 0 in isolated config.
    /// </summary>
    configure_locale           : integer;
    /// <summary>
    /// If equals to 2, coerce the C locale.
    /// If equals to 1, read the LC_CTYPE locale to decide if it should be coerced.
    /// See the locale encoding.
    /// Default: -1 in Python config, 0 in isolated config.
    /// </summary>
    coerce_c_locale            : integer;
    /// <summary>
    /// If non-zero, emit a warning if the C locale is coerced.
    /// Default: -1 in Python config, 0 in isolated config.
    /// </summary>
    coerce_c_locale_warn       : integer;
    {$IFDEF MSWINDOWS}
    /// <summary>
    /// If non-zero:
    /// - Set PyPreConfig.utf8_mode to 0,
    /// - Set PyConfig.filesystem_encoding to "mbcs",
    /// - Set PyConfig.filesystem_errors to "replace".
    /// Initialized from the PYTHONLEGACYWINDOWSFSENCODING environment variable value.
    /// Only available on Windows.
    /// Default: 0.
    /// </summary>
    legacy_windows_fs_encoding : integer;
    {$ENDIF}
    /// <summary>
    /// If non-zero, enable the Python UTF-8 Mode.
    /// Set to 0 or 1 by the -X utf8 command line option and the PYTHONUTF8 environment variable.
    /// Also set to 1 if the LC_CTYPE locale is C or POSIX.
    /// Default: -1 in Python config and 0 in isolated config.
    /// </summary>
    utf8_mode                  : integer;
    /// <summary>
    /// Python Development Mode: see PyConfig.dev_mode.
    /// Default: -1 in Python mode, 0 in isolated mode.
    /// </summary>
    dev_mode                   : integer;
    /// <summary>
    /// Name of the Python memory allocator. See PyMemAllocatorName.
    /// </summary>
    allocator                  : integer;
  end;

  /// <summary>
  /// Record containing most parameters to configure Python.
  /// When done, the PyConfig_Clear() function must be used to release the configuration memory.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#pyconfig">See the article about PyConfig.</see></para>
  /// </remarks>
  PyConfig314 = record
    /// <summary>
    /// _PyConfigInitEnum value
    /// </summary>
    _config_init             : integer;
    /// <summary>
    /// If greater than 0, enable isolated mode:
    /// - Set safe_path to 1: don't prepend a potentially unsafe path to sys.path at Python startup, such as the current directory, the script's directory or an empty string.
    /// - Set use_environment to 0: ignore PYTHON environment variables.
    /// - Set user_site_directory to 0: don't add the user site directory to sys.path.
    /// - Python REPL doesn't import readline nor enable default readline configuration on interactive prompts.
    /// Set to 1 by the -I command line option.
    /// Default: 0 in Python mode, 1 in isolated mode.
    /// See also the Isolated Configuration and PyPreConfig.isolated.
    /// </summary>
    isolated                 : integer;
    /// <summary>
    /// Use environment variables?
    /// If equals to zero, ignore the environment variables.
    /// Set to 0 by the -E environment variable.
    /// Default: 1 in Python config and 0 in isolated config.
    /// </summary>
    use_environment          : integer;
    /// <summary>
    /// If non-zero, enable the Python Development Mode.
    /// Set to 1 by the -X dev option and the PYTHONDEVMODE environment variable.
    /// Default: -1 in Python mode, 0 in isolated mode.
    /// </summary>
    dev_mode                 : integer;
    /// <summary>
    /// Install Python signal handlers?
    /// Default: 1 in Python mode, 0 in isolated mode.
    /// </summary>
    install_signal_handlers  : integer;
    /// <summary>
    /// Randomized hash function seed.
    /// If use_hash_seed is zero, a seed is chosen randomly at Python startup, and hash_seed is ignored.
    /// Set by the PYTHONHASHSEED environment variable.
    /// Default use_hash_seed value: -1 in Python mode, 0 in isolated mode.
    /// </summary>
    use_hash_seed            : integer;
    /// <summary>
    /// Hash seed
    /// </summary>
    hash_seed                : C_ULong;
    /// <summary>
    /// Enable faulthandler?
    /// If non-zero, call faulthandler.enable() at startup.
    /// Set to 1 by -X faulthandler and the PYTHONFAULTHANDLER environment variable.
    /// Default: -1 in Python mode, 0 in isolated mode.
    /// </summary>
    faulthandler             : integer;
    /// <summary>
    /// Enable tracemalloc?
    /// If non-zero, call tracemalloc.start() at startup.
    /// Set by -X tracemalloc=N command line option and by the PYTHONTRACEMALLOC environment variable.
    /// Default: -1 in Python mode, 0 in isolated mode.
    /// </summary>
    tracemalloc              : integer;
    /// <summary>
    /// Enable the Linux perf profiler support?
    /// If equals to 1, enable support for the Linux perf profiler.
    /// If equals to 2, enable support for the Linux perf profiler with DWARF JIT support.
    /// Set to 1 by -X perf command-line option and the PYTHONPERFSUPPORT environment variable.
    /// Set to 2 by the -X perf_jit command-line option and the PYTHON_PERF_JIT_SUPPORT environment variable.
    /// Default: -1.
    /// See also See Python support for the Linux perf profiler for more information.
    /// Added in version 3.12.
    /// </summary>
    perf_profiling           : integer;
    /// <summary>
    /// Remote debug
    /// </summary>
    remote_debug             : integer;
    /// <summary>
    /// If 1, profile import time. If 2, include additional output that indicates when an imported module has already been loaded.
    /// Set by the -X importtime option and the PYTHONPROFILEIMPORTTIME environment variable.
    /// Default: 0.
    /// Changed in version 3.14: Added support for import_time = 2
    /// </summary>
    import_time              : integer;
    /// <summary>
    /// If equals to 0, disables the inclusion of the end line and column mappings in code objects. Also disables traceback printing carets to specific error locations.
    /// Set to 0 by the PYTHONNODEBUGRANGES environment variable and by the -X no_debug_ranges command line option.
    /// Default: 1.
    /// Added in version 3.11.
    /// </summary>
    code_debug_ranges        : integer;
    /// <summary>
    /// Show total reference count at exit (excluding immortal objects)?
    /// Set to 1 by -X showrefcount command line option.
    /// Needs a debug build of Python (the Py_REF_DEBUG macro must be defined).
    /// Default: 0.
    /// </summary>
    show_ref_count           : integer;
    /// <summary>
    /// Dump Python references?
    /// If non-zero, dump all objects which are still alive at exit.
    /// Set to 1 by the PYTHONDUMPREFS environment variable.
    /// Needs a special build of Python with the Py_TRACE_REFS macro defined: see the configure --with-trace-refs option.
    /// Default: 0.
    /// </summary>
    dump_refs                : integer;
    /// <summary>
    /// Filename where to dump Python references.
    /// Set by the PYTHONDUMPREFSFILE environment variable.
    /// Default: NULL.
    /// Added in version 3.11.
    /// </summary>
    dump_refs_file           : PWCharT;
    /// <summary>
    /// If non-zero, dump statistics on Python pymalloc memory allocator at exit.
    /// Set to 1 by the PYTHONMALLOCSTATS environment variable.
    /// The option is ignored if Python is configured using the --without-pymalloc option.
    /// Default: 0.
    /// </summary>
    malloc_stats             : integer;
    /// <summary>
    /// Filesystem encoding: sys.getfilesystemencoding().
    /// On macOS, Android and VxWorks: use "utf-8" by default.
    /// On Windows: use "utf-8" by default, or "mbcs" if legacy_windows_fs_encoding of PyPreConfig is non-zero.
    /// Default encoding on other platforms:
    /// - "utf-8" if PyPreConfig.utf8_mode is non-zero.
    /// - "ascii" if Python detects that nl_langinfo(CODESET) announces the ASCII encoding, whereas the mbstowcs() function decodes from a different encoding (usually Latin1).
    /// - "utf-8" if nl_langinfo(CODESET) returns an empty string.
    /// Otherwise, use the locale encoding: nl_langinfo(CODESET) result.
    /// At Python startup, the encoding name is normalized to the Python codec name. For example, "ANSI_X3.4-1968" is replaced with "ascii".
    /// See also the filesystem_errors member.
    /// </summary>
    filesystem_encoding      : PWCharT;
    /// <summary>
    /// Filesystem error handler: sys.getfilesystemencodeerrors().
    /// On Windows: use "surrogatepass" by default, or "replace" if legacy_windows_fs_encoding of PyPreConfig is non-zero.
    /// On other platforms: use "surrogateescape" by default.
    /// Supported error handlers:
    /// - "strict"
    /// - "surrogateescape"
    /// - "surrogatepass" (only supported with the UTF-8 encoding)
    /// See also the filesystem_encoding member.
    /// </summary>
    filesystem_errors        : PWCharT;
    /// <summary>
    /// Directory where cached .pyc files are written: sys.pycache_prefix.
    /// Set by the -X pycache_prefix=PATH command line option and the PYTHONPYCACHEPREFIX environment variable. The command-line option takes precedence.
    /// If NULL, sys.pycache_prefix is set to None.
    /// Default: NULL.
    /// </summary>
    pycache_prefix           : PWCharT;
    /// <summary>
    /// Parse command line arguments?
    /// If equals to 1, parse argv the same way the regular Python parses command line arguments, and strip Python arguments from argv.
    /// The PyConfig_Read() function only parses PyConfig.argv arguments once: PyConfig.parse_argv is set to 2 after arguments are parsed. Since Python arguments are stripped from PyConfig.argv, parsing arguments twice would parse the application options as Python options.
    /// Default: 1 in Python mode, 0 in isolated mode.
    /// Changed in version 3.10: The PyConfig.argv arguments are now only parsed if PyConfig.parse_argv equals to 1.
    /// </summary>
    parse_argv               : integer;
    /// <summary>
    /// The list of the original command line arguments passed to the Python executable: sys.orig_argv.
    /// If orig_argv list is empty and argv is not a list only containing an empty string, PyConfig_Read() copies argv into orig_argv before modifying argv (if parse_argv is non-zero).
    /// See also the argv member and the Py_GetArgcArgv() function.
    /// Default: empty list.
    /// Added in version 3.10.
    /// </summary>
    orig_argv                : PyWideStringList;
    /// <summary>
    /// Set sys.argv command line arguments based on argv. These parameters are similar to those passed to the program's main() function with the difference that the first entry should refer to the script file to be executed rather than the executable hosting the Python interpreter. If there isn't a script that will be run, the first entry in argv can be an empty string.
    /// Set parse_argv to 1 to parse argv the same way the regular Python parses Python command line arguments and then to strip Python arguments from argv.
    /// If argv is empty, an empty string is added to ensure that sys.argv always exists and is never empty.
    /// Default: NULL.
    /// See also the orig_argv member.
    /// </summary>
    argv                     : PyWideStringList;
    /// <summary>
    /// Values of the -X command line options: sys._xoptions.
    /// Default: empty list.
    /// </summary>
    xoptions                 : PyWideStringList;
    /// <summary>
    /// Options of the warnings module to build warnings filters, lowest to highest priority: sys.warnoptions.
    /// The warnings module adds sys.warnoptions in the reverse order: the last PyConfig.warnoptions item becomes the first item of warnings.filters which is checked first (highest priority).
    /// The -W command line options adds its value to warnoptions, it can be used multiple times.
    /// The PYTHONWARNINGS environment variable can also be used to add warning options. Multiple options can be specified, separated by commas (,).
    /// Default: empty list.
    /// </summary>
    warnoptions              : PyWideStringList;
    /// <summary>
    /// Import the site module at startup?
    /// If equal to zero, disable the import of the module site and the site-dependent manipulations of sys.path that it entails.
    /// Also disable these manipulations if the site module is explicitly imported later (call site.main() if you want them to be triggered).
    /// Set to 0 by the -S command line option.
    /// sys.flags.no_site is set to the inverted value of site_import.
    /// Default: 1.
    /// </summary>
    site_import              : integer;
    /// <summary>
    /// If equals to 1, issue a warning when comparing bytes or bytearray with str, or comparing bytes with int.
    /// If equal or greater to 2, raise a BytesWarning exception in these cases.
    /// Incremented by the -b command line option.
    /// Default: 0.
    /// </summary>
    bytes_warning            : integer;
    /// <summary>
    /// If non-zero, emit a EncodingWarning warning when io.TextIOWrapper uses its default encoding. See Opt-in EncodingWarning for details.
    /// Default: 0.
    /// Added in version 3.10.
    /// </summary>
    warn_default_encoding    : integer;
    /// <summary>
    /// Enter interactive mode after executing a script or a command.
    /// If greater than 0, enable inspect: when a script is passed as first argument or the -c option is used, enter interactive mode after executing the script or the command, even when sys.stdin does not appear to be a terminal.
    /// Incremented by the -i command line option. Set to 1 if the PYTHONINSPECT environment variable is non-empty.
    /// Default: 0.
    /// </summary>
    inspect                  : integer;
    /// <summary>
    /// If greater than 0, enable the interactive mode (REPL).
    /// Incremented by the -i command line option.
    /// Default: 0.
    /// </summary>
    interactive              : integer;
    /// <summary>
    /// Compilation optimization level:
    /// 0: Peephole optimizer, set __debug__ to True.
    /// 1: Level 0, remove assertions, set __debug__ to False.
    /// 2: Level 1, strip docstrings.
    /// Incremented by the -O command line option. Set to the PYTHONOPTIMIZE environment variable value.
    /// Default: 0.
    /// See TPyOptimizationLevel
    /// </summary>
    optimization_level       : integer;
    /// <summary>
    /// Parser debug mode. If greater than 0, turn on parser debugging output (for expert only, depending on compilation options).
    /// Incremented by the -d command line option. Set to the PYTHONDEBUG environment variable value.
    /// Needs a debug build of Python (the Py_DEBUG macro must be defined).
    /// Default: 0.
    /// </summary>
    parser_debug             : integer;
    /// <summary>
    /// If equal to 0, Python won't try to write .pyc files on the import of source modules.
    /// Set to 0 by the -B command line option and the PYTHONDONTWRITEBYTECODE environment variable.
    /// sys.dont_write_bytecode is initialized to the inverted value of write_bytecode.
    /// Default: 1.
    /// </summary>
    write_bytecode           : integer;
    /// <summary>
    /// Verbose mode. If greater than 0, print a message each time a module is imported, showing the place (filename or built-in module) from which it is loaded.
    /// If greater than or equal to 2, print a message for each file that is checked for when searching for a module. Also provides information on module cleanup at exit.
    /// Incremented by the -v command line option.
    /// Set by the PYTHONVERBOSE environment variable value.
    /// Default: 0.
    /// </summary>
    verbose                  : integer;
    /// <summary>
    /// Quiet mode. If greater than 0, don't display the copyright and version at Python startup in interactive mode.
    /// Incremented by the -q command line option.
    /// Default: 0.
    /// </summary>
    quiet                    : integer;
    /// <summary>
    /// If non-zero, add the user site directory to sys.path.
    /// Set to 0 by the -s and -I command line options.
    /// Set to 0 by the PYTHONNOUSERSITE environment variable.
    /// Default: 1 in Python mode, 0 in isolated mode.
    /// </summary>
    user_site_directory      : integer;
    /// <summary>
    /// If non-zero, configure C standard streams:
    /// On Windows, set the binary mode (O_BINARY) on stdin, stdout and stderr.
    /// If buffered_stdio equals zero, disable buffering of stdin, stdout and stderr streams.
    /// If interactive is non-zero, enable stream buffering on stdin and stdout (only stdout on Windows).
    /// Default: 1 in Python config, 0 in isolated config.
    /// </summary>
    configure_c_stdio        : integer;
    /// <summary>
    /// If equals to 0 and configure_c_stdio is non-zero, disable buffering on the C streams stdout and stderr.
    /// Set to 0 by the -u command line option and the PYTHONUNBUFFERED environment variable.
    /// stdin is always opened in buffered mode.
    /// Default: 1.
    /// </summary>
    buffered_stdio           : integer;
    /// <summary>
    /// Encoding of sys.stdin, sys.stdout and sys.stderr (but sys.stderr always uses "backslashreplace" error handler).
    /// Use the PYTHONIOENCODING environment variable if it is non-empty.
    /// Default encoding:
    /// - "UTF-8" if PyPreConfig.utf8_mode is non-zero.
    /// - Otherwise, use the locale encoding.
    /// See also PyConfig.legacy_windows_stdio.
    /// </summary>
    stdio_encoding           : PWCharT;
    /// <summary>
    /// Encoding errors of sys.stdin, sys.stdout and sys.stderr (but sys.stderr always uses "backslashreplace" error handler).
    /// Use the PYTHONIOENCODING environment variable if it is non-empty.
    /// Default error handler:
    /// - On Windows: use "surrogateescape".
    /// - "surrogateescape" if PyPreConfig.utf8_mode is non-zero, or if the LC_CTYPE locale is "C" or "POSIX".
    /// - "strict" otherwise.
    /// See also PyConfig.legacy_windows_stdio.
    /// </summary>
    stdio_errors             : PWCharT;
    {$IFDEF MSWINDOWS}
    /// <summary>
    /// If non-zero, use io.FileIO instead of io._WindowsConsoleIO for sys.stdin, sys.stdout and sys.stderr.
    /// Set to 1 if the PYTHONLEGACYWINDOWSSTDIO environment variable is set to a non-empty string.
    /// Only available on Windows. #ifdef MS_WINDOWS macro can be used for Windows specific code.
    /// Default: 0.
    /// See also the PEP 528 (Change Windows console encoding to UTF-8).
    /// </summary>
    legacy_windows_stdio     : integer;
    {$ENDIF}
    /// <summary>
    /// Control the validation behavior of hash-based .pyc files: value of the --check-hash-based-pycs command line option.
    /// Valid values:
    /// "always": Hash the source file for invalidation regardless of value of the ‘check_source' flag.
    /// "never": Assume that hash-based pycs always are valid.
    /// "default": The ‘check_source' flag in hash-based pycs determines invalidation.
    /// Default: "default".
    /// See also PEP 552 "Deterministic pycs".
    /// </summary>
    check_hash_pycs_mode     : PWCharT;
    /// <summary>
    /// If non-zero, use frozen modules.
    /// Set by the PYTHON_FROZEN_MODULES environment variable.
    /// Default: 1 in a release build, or 0 in a debug build.
    /// </summary>
    use_frozen_modules       : integer;
    /// <summary>
    /// If equals to zero, Py_RunMain() prepends a potentially unsafe path to sys.path at startup:
    /// If argv[0] is equal to L"-m" (python -m module), prepend the current working directory.
    /// If running a script (python script.py), prepend the script's directory. If it's a symbolic link, resolve symbolic links.
    /// Otherwise (python -c code and python), prepend an empty string, which means the current working directory.
    /// Set to 1 by the -P command line option and the PYTHONSAFEPATH environment variable.
    /// Default: 0 in Python config, 1 in isolated config.
    /// Added in version 3.11.
    /// </summary>
    safe_path                : integer;
    /// <summary>
    /// Configures the integer string conversion length limitation. An initial value of -1 means the value will be taken from the command line or environment or otherwise default to 4300 (sys.int_info.default_max_str_digits). A value of 0 disables the limitation. Values greater than zero but less than 640 (sys.int_info.str_digits_check_threshold) are unsupported and will produce an error.
    /// Configured by the -X int_max_str_digits command line flag or the PYTHONINTMAXSTRDIGITS environment variable.
    /// Default: -1 in Python mode. 4300 (sys.int_info.default_max_str_digits) in isolated mode.
    /// Added in version 3.12.
    /// </summary>
    int_max_str_digits       : integer;
    /// <summary>
    /// Whether the new thread should inherit the current "execution context" from the thread that created it.
    /// If thread_inherit_context is true, the new thread starts with that same context (so things like trace IDs, user IDs, request-scoped metadata, etc. propagate).
    /// If it's false, the new thread runs with a fresh/default context (so context doesn't automatically carry over).
    /// </summary>
    thread_inherit_context   : integer;
    /// <summary>
    /// The `context_aware_warnings` field exists to control whether the `warnings.catch_warnings()` context manager behaves *concurrently safely*.
    /// - When `context_aware_warnings` is **true**, `catch_warnings` uses a `ContextVar` to store the temporarily-established warning filter state, so using it is safe across **threads and asyncio tasks**.
    /// - When `context_aware_warnings` is **false**, `catch_warnings` falls back to modifying **global state** in the `warnings` module, which is **not safe** in concurrent programs (thread/async behavior can become undefined).
    /// It can also be set via the `-X context_aware_warnings` command-line option or the `PYTHON_CONTEXT_AWARE_WARNINGS` environment variable. `<citation src="1"></citation>`
    /// </summary>
    context_aware_warnings   : integer;
    {$IFDEF APPLE}
    /// <summary>
    /// If non-zero, stdout and stderr will be redirected to the system log.
    /// Only available on macOS 10.12 and later, and on iOS.
    /// Default: 0 (don't use the system log) on macOS; 1 on iOS (use the system log).
    /// Added in version 3.14.
    /// </summary>
    use_system_logger        : integer;
    {$ENDIF}
    /// <summary>
    /// If the value of cpu_count is not -1 then it will override the return values of os.cpu_count(), os.process_cpu_count(), and multiprocessing.cpu_count().
    /// Configured by the -X cpu_count=n|default command line flag or the PYTHON_CPU_COUNT environment variable.
    /// Default: -1.
    /// Added in version 3.13.
    /// </summary>
    cpu_count                : integer;
    /// <summary>
    /// If non-zero, calculation of path configuration is allowed to log warnings into stderr. If equals to 0, suppress these warnings.
    /// Default: 1 in Python mode, 0 in isolated mode.
    /// Part of the Python Path Configuration input.
    /// Changed in version 3.11: Now also applies on Windows.
    /// </summary>
    pathconfig_warnings      : integer;
    /// <summary>
    /// Program name used to initialize executable and in early error messages during Python initialization.
    /// On macOS, use PYTHONEXECUTABLE environment variable if set.
    /// If the WITH_NEXT_FRAMEWORK macro is defined, use __PYVENV_LAUNCHER__ environment variable if set.
    /// Use argv[0] of argv if available and non-empty.
    /// Otherwise, use L"python" on Windows, or L"python3" on other platforms.
    /// Default: NULL.
    /// Part of the Python Path Configuration input.
    /// </summary>
    program_name             : PWCharT;
    /// <summary>
    /// Set by the PYTHONPATH environment variable.
    /// Default: NULL.
    /// Part of the Python Path Configuration input.
    /// </summary>
    pythonpath_env           : PWCharT;
    /// <summary>
    /// Set the default Python "home" directory, that is, the location of the standard Python libraries (see PYTHONHOME).
    /// Set by the PYTHONHOME environment variable.
    /// Default: NULL.
    /// Part of the Python Path Configuration input.
    /// </summary>
    home                     : PWCharT;
    /// <summary>
    /// Platform library directory name: sys.platlibdir.
    /// Set by the PYTHONPLATLIBDIR environment variable.
    /// Default: value of the PLATLIBDIR macro which is set by the configure --with-platlibdir option (default: "lib", or "DLLs" on Windows).
    /// Part of the Python Path Configuration input.
    /// Added in version 3.9.
    /// Changed in version 3.11: This macro is now used on Windows to locate the standard library extension modules, typically under DLLs. However, for compatibility, note that this value is ignored for any non-standard layouts, including in-tree builds and virtual environments.
    /// </summary>
    platlibdir               : PWCharT;
    /// <summary>
    /// Module search paths: sys.path.
    /// If module_search_paths_set is equal to 0, Py_InitializeFromConfig() will replace module_search_paths and sets module_search_paths_set to 1.
    /// Default: empty list (module_search_paths) and 0 (module_search_paths_set).
    /// Part of the Python Path Configuration output.
    /// </summary>
    module_search_paths_set  : integer;
    /// <summary>
    /// Module search paths (sys.path) as a string separated by DELIM (os.pathsep).
    /// </summary>
    module_search_paths      : PyWideStringList;
    /// <summary>
    /// Directory of the Python standard library.
    /// Default: NULL.
    /// Added in version 3.11.
    /// </summary>
    stdlib_dir               : PWCharT;
    /// <summary>
    /// The absolute path of the executable binary for the Python interpreter: sys.executable.
    /// Default: NULL.
    /// Part of the Python Path Configuration output.
    /// See also PyConfig.base_executable.
    /// </summary>
    executable               : PWCharT;
    /// <summary>
    /// Python base executable: sys._base_executable.
    /// Set by the __PYVENV_LAUNCHER__ environment variable.
    /// Set from PyConfig.executable if NULL.
    /// Default: NULL.
    /// Part of the Python Path Configuration output.
    /// See also PyConfig.executable.
    /// </summary>
    base_executable          : PWCharT;
    /// <summary>
    /// The site-specific directory prefix where the platform independent Python files are installed: sys.prefix.
    /// Default: NULL.
    /// Part of the Python Path Configuration output.
    /// See also PyConfig.base_prefix.
    /// </summary>
    prefix                   : PWCharT;
    /// <summary>
    /// sys.base_exec_prefix.
    /// Default: NULL.
    /// Part of the Python Path Configuration output.
    /// See also PyConfig.exec_prefix.
    /// </summary>
    base_prefix              : PWCharT;
    /// <summary>
    /// The site-specific directory prefix where the platform-dependent Python files are installed: sys.exec_prefix.
    /// Default: NULL.
    /// Part of the Python Path Configuration output.
    /// See also PyConfig.base_exec_prefix.
    /// </summary>
    exec_prefix              : PWCharT;
    /// <summary>
    /// sys.base_exec_prefix.
    /// Default: NULL.
    /// Part of the Python Path Configuration output.
    /// See also PyConfig.exec_prefix.
    /// </summary>
    base_exec_prefix         : PWCharT;
    /// <summary>
    /// If non-zero, skip the first line of the PyConfig.run_filename source.
    /// It allows the usage of non-Unix forms of #!cmd. This is intended for a DOS specific hack only.
    /// Set to 1 by the -x command line option.
    /// Default: 0.
    /// </summary>
    skip_source_first_line   : integer;
    /// <summary>
    /// Value of the -c command line option.
    /// Used by Py_RunMain().
    /// Default: NULL.
    /// </summary>
    run_command              : PWCharT;
    /// <summary>
    /// Value of the -m command line option.
    /// Used by Py_RunMain().
    /// Default: NULL.
    /// </summary>
    run_module               : PWCharT;
    /// <summary>
    /// Filename passed on the command line: trailing command line argument without -c or -m. It is used by the Py_RunMain() function.
    /// For example, it is set to script.py by the python3 script.py arg command line.
    /// See also the PyConfig.skip_source_first_line option.
    /// Default: NULL.
    /// </summary>
    run_filename             : PWCharT;
    /// <summary>
    /// PyConfig.sys_path_0 is the value that Python uses as the first entry in sys.path (sys.path[0]) when the interpreter runs.
    /// In particular, it determines what sys.path[0] becomes for different invocation styles, for example:
    /// - for python -m module, sys.path[0] is set to include the current working directory,
    /// - for python script.py, it's set to the script's directory,
    /// - for python -c code / plain python, it's set to an "empty string" meaning the current working directory.
    /// So, when embedding Python via the C-API, setting PyConfig.sys_path_0 lets you control that first sys.path entry explicitly (instead of letting Python compute it).
    /// </summary>
    sys_path_0               : PWCharT;
    /// <summary>
    /// Install importlib? If equals to 0, importlib is not initialized at all. Needed by freeze_importlib.
    /// This is needed for some embedding/bootstrapping setups (e.g., "freeze_importlib"), where the embedding application wants to take control of how/when importlib gets installed.
    /// </summary>
    _install_importlib       : integer;
    /// <summary>
    /// If equal to 0, stop Python initialization before the "main" phase.
    /// </summary>
    _init_main               : integer;
    /// <summary>
    /// If non-zero, we believe we're running from a source tree.
    /// </summary>
    _is_python_build         : integer;
  end;

  PyConfig313 = record
    _config_init             : integer;
    isolated                 : integer;
    use_environment          : integer;
    dev_mode                 : integer;
    install_signal_handlers  : integer;
    use_hash_seed            : integer;
    hash_seed                : C_ULong;
    faulthandler             : integer;
    tracemalloc              : integer;
    perf_profiling           : integer;
    import_time              : integer;
    code_debug_ranges        : integer;
    show_ref_count           : integer;
    dump_refs                : integer;
    dump_refs_file           : PWCharT;
    malloc_stats             : integer;
    filesystem_encoding      : PWCharT;
    filesystem_errors        : PWCharT;
    pycache_prefix           : PWCharT;
    parse_argv               : integer;
    orig_argv                : PyWideStringList;
    argv                     : PyWideStringList;
    xoptions                 : PyWideStringList;
    warnoptions              : PyWideStringList;
    site_import              : integer;
    bytes_warning            : integer;
    warn_default_encoding    : integer;
    inspect                  : integer;
    interactive              : integer;
    optimization_level       : integer;
    parser_debug             : integer;
    write_bytecode           : integer;
    verbose                  : integer;
    quiet                    : integer;
    user_site_directory      : integer;
    configure_c_stdio        : integer;
    buffered_stdio           : integer;
    stdio_encoding           : PWCharT;
    stdio_errors             : PWCharT;
    {$IFDEF MSWINDOWS}
    legacy_windows_stdio     : integer;
    {$ENDIF}
    check_hash_pycs_mode     : PWCharT;
    use_frozen_modules       : integer;
    safe_path                : integer;
    int_max_str_digits       : integer;
    cpu_count                : integer;
    pathconfig_warnings      : integer;
    program_name             : PWCharT;
    pythonpath_env           : PWCharT;
    home                     : PWCharT;
    platlibdir               : PWCharT;
    module_search_paths_set  : integer;
    module_search_paths      : PyWideStringList;
    stdlib_dir               : PWCharT;
    executable               : PWCharT;
    base_executable          : PWCharT;
    prefix                   : PWCharT;
    base_prefix              : PWCharT;
    exec_prefix              : PWCharT;
    base_exec_prefix         : PWCharT;
    skip_source_first_line   : integer;
    run_command              : PWCharT;
    run_module               : PWCharT;
    run_filename             : PWCharT;
    sys_path_0               : PWCharT;
    _install_importlib       : integer;
    _init_main               : integer;
    _is_python_build         : integer;
  end;

  PyConfig312 = record
    _config_init             : integer;
    isolated                 : integer;
    use_environment          : integer;
    dev_mode                 : integer;
    install_signal_handlers  : integer;
    use_hash_seed            : integer;
    hash_seed                : C_ULong;
    faulthandler             : integer;
    tracemalloc              : integer;
    perf_profiling           : integer;
    import_time              : integer;
    code_debug_ranges        : integer;
    show_ref_count           : integer;
    dump_refs                : integer;
    dump_refs_file           : PWCharT;
    malloc_stats             : integer;
    filesystem_encoding      : PWCharT;
    filesystem_errors        : PWCharT;
    pycache_prefix           : PWCharT;
    parse_argv               : integer;
    orig_argv                : PyWideStringList;
    argv                     : PyWideStringList;
    xoptions                 : PyWideStringList;
    warnoptions              : PyWideStringList;
    site_import              : integer;
    bytes_warning            : integer;
    warn_default_encoding    : integer;
    inspect                  : integer;
    interactive              : integer;
    optimization_level       : integer;
    parser_debug             : integer;
    write_bytecode           : integer;
    verbose                  : integer;
    quiet                    : integer;
    user_site_directory      : integer;
    configure_c_stdio        : integer;
    buffered_stdio           : integer;
    stdio_encoding           : PWCharT;
    stdio_errors             : PWCharT;
    {$IFDEF MSWINDOWS}
    legacy_windows_stdio     : integer;
    {$ENDIF}
    check_hash_pycs_mode     : PWCharT;
    use_frozen_modules       : integer;
    safe_path                : integer;
    int_max_str_digits       : integer;
    pathconfig_warnings      : integer;
    program_name             : PWCharT;
    pythonpath_env           : PWCharT;
    home                     : PWCharT;
    platlibdir               : PWCharT;
    module_search_paths_set  : integer;
    module_search_paths      : PyWideStringList;
    stdlib_dir               : PWCharT;
    executable               : PWCharT;
    base_executable          : PWCharT;
    prefix                   : PWCharT;
    base_prefix              : PWCharT;
    exec_prefix              : PWCharT;
    base_exec_prefix         : PWCharT;
    skip_source_first_line   : integer;
    run_command              : PWCharT;
    run_module               : PWCharT;
    run_filename             : PWCharT;
    _install_importlib       : integer;
    _init_main               : integer;
    _is_python_build         : integer;
  end;

  PyConfig311 = record
    _config_init             : integer;
    isolated                 : integer;
    use_environment          : integer;
    dev_mode                 : integer;
    install_signal_handlers  : integer;
    use_hash_seed            : integer;
    hash_seed                : C_ULong;
    faulthandler             : integer;
    tracemalloc              : integer;
    import_time              : integer;
    code_debug_ranges        : integer;
    show_ref_count           : integer;
    dump_refs                : integer;
    dump_refs_file           : PWCharT;
    malloc_stats             : integer;
    filesystem_encoding      : PWCharT;
    filesystem_errors        : PWCharT;
    pycache_prefix           : PWCharT;
    parse_argv               : integer;
    orig_argv                : PyWideStringList;
    argv                     : PyWideStringList;
    xoptions                 : PyWideStringList;
    warnoptions              : PyWideStringList;
    site_import              : integer;
    bytes_warning            : integer;
    warn_default_encoding    : integer;
    inspect                  : integer;
    interactive              : integer;
    optimization_level       : integer;
    parser_debug             : integer;
    write_bytecode           : integer;
    verbose                  : integer;
    quiet                    : integer;
    user_site_directory      : integer;
    configure_c_stdio        : integer;
    buffered_stdio           : integer;
    stdio_encoding           : PWCharT;
    stdio_errors             : PWCharT;
    {$IFDEF MSWINDOWS}
    legacy_windows_stdio     : integer;
    {$ENDIF}
    check_hash_pycs_mode     : PWCharT;
    use_frozen_modules       : integer;
    safe_path                : integer;
    pathconfig_warnings      : integer;
    program_name             : PWCharT;
    pythonpath_env           : PWCharT;
    home                     : PWCharT;
    platlibdir               : PWCharT;
    module_search_paths_set  : integer;
    module_search_paths      : PyWideStringList;
    stdlib_dir               : PWCharT;
    executable               : PWCharT;
    base_executable          : PWCharT;
    prefix                   : PWCharT;
    base_prefix              : PWCharT;
    exec_prefix              : PWCharT;
    base_exec_prefix         : PWCharT;
    skip_source_first_line   : integer;
    run_command              : PWCharT;
    run_module               : PWCharT;
    run_filename             : PWCharT;
    _install_importlib       : integer;
    _init_main               : integer;
    _isolated_interpreter    : integer;
    _is_python_build         : integer;
  end;

  PyConfig310 = record
    _config_init             : integer;
    isolated                 : integer;
    use_environment          : integer;
    dev_mode                 : integer;
    install_signal_handlers  : integer;
    use_hash_seed            : integer;
    hash_seed                : C_ULong;
    faulthandler             : integer;
    tracemalloc              : integer;
    import_time              : integer;
    show_ref_count           : integer;
    dump_refs                : integer;
    malloc_stats             : integer;
    filesystem_encoding      : PWCharT;
    filesystem_errors        : PWCharT;
    pycache_prefix           : PWCharT;
    parse_argv               : integer;
    orig_argv                : PyWideStringList;
    argv                     : PyWideStringList;
    xoptions                 : PyWideStringList;
    warnoptions              : PyWideStringList;
    site_import              : integer;
    bytes_warning            : integer;
    warn_default_encoding    : integer;
    inspect                  : integer;
    interactive              : integer;
    optimization_level       : integer;
    parser_debug             : integer;
    write_bytecode           : integer;
    verbose                  : integer;
    quiet                    : integer;
    user_site_directory      : integer;
    configure_c_stdio        : integer;
    buffered_stdio           : integer;
    stdio_encoding           : PWCharT;
    stdio_errors             : PWCharT;
    {$IFDEF MSWINDOWS}
    legacy_windows_stdio     : integer;
    {$ENDIF}
    check_hash_pycs_mode     : PWCharT;
    pathconfig_warnings      : integer;
    program_name             : PWCharT;
    pythonpath_env           : PWCharT;
    home                     : PWCharT;
    platlibdir               : PWCharT;
    module_search_paths_set  : integer;
    module_search_paths      : PyWideStringList;
    executable               : PWCharT;
    base_executable          : PWCharT;
    prefix                   : PWCharT;
    base_prefix              : PWCharT;
    exec_prefix              : PWCharT;
    base_exec_prefix         : PWCharT;
    skip_source_first_line   : integer;
    run_command              : PWCharT;
    run_module               : PWCharT;
    run_filename             : PWCharT;
    _install_importlib       : integer;
    _init_main               : integer;
    _isolated_interpreter    : integer;
  end;


  {* include/pystate.h *}

  /// <summary>
  /// The type of the value returned by PyGILState_Ensure() and passed to
  /// PyGILState_Release().
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/threads.html#c.PyGILState_STATE">See the article about PyGILState_STATE.</see></para>
  /// </remarks>
  PyGILState_STATE = (
    /// <summary>
    /// The GIL was already held when PyGILState_Ensure() was called.
    /// </summary>
    PyGILState_LOCKED,
    /// <summary>
    /// The GIL was not held when PyGILState_Ensure() was called.
    /// </summary>
    PyGILState_UNLOCKED
  );

  Py_tracefunc = function(obj1: PPyObject; frame: PPyFrameObject; i: integer; obj2: PPyObject): integer; cdecl;

  {* include/cpython/genobject.h *}
  {* include/descrobject.h *}
  getter           = function(obj: PPyObject; context: Pointer): PPyObject; cdecl;
  setter           = function(obj, value: PPyObject; context: Pointer): integer; cdecl;
  wrapperfunc      = function(self, args: PPyObject; wrapped: Pointer): PPyObject; cdecl;
  wrapperfunc_kwds = function(self, args: PPyObject; wrapped: Pointer; kwds: PPyObject): PPyObject; cdecl;

  /// <summary>
  /// Record to define property-like access for a type. See also description
  /// of the PyTypeObject.tp_getset slot.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyGetSetDef">See the article about PyGetSetDef.</see></para>
  /// </remarks>
  PyGetSetDef = record
    /// <summary>
    /// attribute name
    /// </summary>
    name    : PAnsiChar;
    /// <summary>
    /// function to get the attribute.
    /// </summary>
    get     : getter;
    /// <summary>
    /// Optional function to set or delete the attribute. If NULL, the attribute
    /// is read-only.
    /// </summary>
    set_    : setter;
    /// <summary>
    /// optional docstring
    /// </summary>
    doc     : PAnsiChar;
    /// <summary>
    /// Optional user data pointer, providing additional data for getter and
    /// setter.
    /// </summary>
    closure : Pointer;
  end;

  /// <summary>
  /// Record which describes an attribute of a type which corresponds to a C
  /// struct member. When defining a class, put a NULL-terminated array of these
  /// structures in the tp_members slot.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyMemberDef">See the article about PyMemberDef.</see></para>
  /// </remarks>
  PyMemberDef = record
    /// <summary>
    /// Name of the member. A NULL value marks the end of a PyMemberDef[] array.
    /// The string should be static, no copy is made of it.
    /// </summary>
    name   : PAnsiChar;
    /// <summary>
    /// The type of the member in the C struct. See Member types for the
    /// possible values.
    /// </summary>
    type_  : integer;
    /// <summary>
    /// The offset in bytes that the member is located on the type's object
    /// struct.
    /// </summary>
    offset : Py_ssize_t;
    /// <summary>
    /// Zero or more of the Member flags, combined using bitwise OR.
    /// </summary>
    flags  : Integer;
    /// <summary>
    /// The docstring, or NULL. The string should be static, no copy is made of
    /// it. Typically, it is defined using PyDoc_STR.
    /// </summary>
    doc    : PAnsiChar;
  end;

  /// <summary>
  /// Describes a slot wrapper used by PyDescr_NewWrapper().
  /// Each wrapperbase record stores the Python-visible name and metadata for a
  /// special method implemented by a type slot, together with the wrapper
  /// function used to adapt that slot to Python's calling convention.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/descriptor.html#c.wrapperbase">See the article about wrapperbase.</see></para>
  /// </remarks>
  wrapperbase = record
    name_       : PAnsiChar;
    offset      : integer;
    function_   : Pointer;
    wrapper     : wrapperfunc;
    doc         : PAnsiChar;
    flags       : integer;
    name_strobj : PPyObject;
  end;

  /// <summary>
  /// Common record used in other descriptor object records.
  /// </summary>
  PyDescrObject = record
    ob_base    : PyObject; // PyObject_HEAD
    d_type     : PPyTypeObject;
    d_name     : PPyObject;
    d_qualname : PPyObject;
  end;

  /// <summary>
  /// Method descriptor object.
  /// </summary>
  PyMethodDescrObject = record
    d_common   : PyDescrObject; // PyDescr_COMMON;
    d_method   : PPyMethodDef;
    vectorcall : vectorcallfunc;
  end;

  /// <summary>
  /// Member descriptor object.
  /// </summary>
  PyMemberDescrObject = record
    d_common   : PyDescrObject; // PyDescr_COMMON;
    d_member   : PPyMemberDef;
  end;

  /// <summary>
  /// GetSet descriptor object.
  /// </summary>
  PyGetSetDescrObject = record
    d_common   : PyDescrObject; // PyDescr_COMMON;
    d_getset   : PPyGetSetDef;
  end;

  /// <summary>
  /// Wrapper descriptor object.
  /// </summary>
  PyWrapperDescrObject = record
    d_common   : PyDescrObject; // PyDescr_COMMON;
    d_base     : Pwrapperbase;
    /// <summary>
    /// This can be any function pointer
    /// </summary>
    d_wrapped  : Pointer;
  end;

  {* include/genericaliasobject.h *}
  {* include/warnings.h *}
  {* include/weakrefobject.h *}

  /// <summary>
  /// PyWeakReference is the base struct for the Python ReferenceType,
  /// ProxyType, and CallableProxyType.
  /// </summary>
  _PyWeakReference = record
    ob_base                : PyObject; // PyObject_HEAD
    /// <summary>
    /// The object to which this is a weak reference, or Py_None if none.
    /// Note that this is a stealth reference:  wr_object's refcount is not
    /// incremented to reflect this pointer.
    /// </summary>
    wr_object              : PPyObject;
    /// <summary>
    /// A callable to invoke when wr_object dies, or NULL if none.
    /// </summary>
    wr_callback            : PPyObject;
    /// <summary>
    /// A cache for wr_object's hash code.  As usual for hashes, this is -1 if
    /// the hash code isn't known yet.
    /// </summary>
    hash                   : Py_hash_t;
    /// <summary>
    /// If wr_object is weakly referenced, wr_object has a doubly-linked NULL-
    /// terminated list of weak references to it.  These are the list pointers.
    /// If wr_object goes away, wr_object is set to Py_None, and these pointers
    /// have no meaning then.
    /// </summary>
    wr_prev                : PPyWeakReference;
    /// <summary>
    /// If wr_object is weakly referenced, wr_object has a doubly-linked NULL-
    /// terminated list of weak references to it.  These are the list pointers.
    /// If wr_object goes away, wr_object is set to Py_None, and these pointers
    /// have no meaning then.
    /// </summary>
    wr_next                : PPyWeakReference;
    /// <summary>
    ///
    /// </summary>
    vectorcall             : vectorcallfunc;
  end;
  /// <summary>
  /// PyWeakReference is the base struct for the Python ReferenceType,
  /// ProxyType, and CallableProxyType.
  /// </summary>
  PyWeakReference = type _PyWeakReference;

  {* include/structseq.h *}
  /// <summary>
  /// Describes a field of a struct sequence. As a struct sequence is modeled as
  /// a tuple, all fields are typed as PyObject*. The index in the fields array
  /// of the PyStructSequence_Desc determines which field of the struct sequence
  /// is described.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/tuple.html#c.PyStructSequence_Field">See the article about PyStructSequence_Field.</see></para>
  /// </remarks>
  PyStructSequence_Field = record
    /// <summary>
    /// Name for the field or NULL to end the list of named fields, set to
    /// PyStructSequence_UnnamedField to leave unnamed.
    /// </summary>
    name_     : PAnsiChar;
    /// <summary>
    /// Field docstring or NULL to omit.
    /// </summary>
    doc       : PAnsiChar;
  end;

  /// <summary>
  /// Contains the meta information of a struct sequence type to create.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/tuple.html#c.PyStructSequence_Desc">See the article about PyStructSequence_Desc.</see></para>
  /// </remarks>
  PyStructSequence_Desc = record
    /// <summary>
    /// Fully qualified name of the type; null-terminated UTF-8 encoded. The
    /// name must contain the module name.
    /// </summary>
    name_         : PAnsiChar;
    /// <summary>
    /// Pointer to docstring for the type or NULL to omit.
    /// </summary>
    doc           : PAnsiChar;
    /// <summary>
    /// Pointer to NULL-terminated array with field names of the new type.
    /// </summary>
    fields        : PPyStructSequence_Field;
    /// <summary>
    /// Number of fields visible to the Python side (if used as tuple).
    /// </summary>
    n_in_sequence : integer;
  end;

  {* include/cpython/picklebufobject.h *}
  {* include/cpython/pytime.h *}

  /// <summary>
  /// A timestamp or duration in nanoseconds, represented as a signed 64-bit integer.
  /// The reference point for timestamps depends on the clock used. For example,
  /// PyTime_Time() returns timestamps relative to the UNIX epoch.
  /// The supported range is around [-292.3 years; +292.3 years]. Using the Unix
  /// epoch (January 1st, 1970) as reference, the supported date range is around
  /// [1677-09-21; 2262-04-11].
  /// </summary>
  PyTime_t           = type int64;

  {* include/codecs.h *}
  {* include/pythread.h *}
  PyThread_start_new_thread_func = procedure(arg: Pointer); cdecl;

  /// <summary>
  /// PY_TIMEOUT_T is the integral type used to specify timeouts when waiting
  /// on a lock (see PyThread_acquire_lock_timed()).
  /// </summary>
  PY_TIMEOUT_T       = type int64;

  /// <summary>
  /// The result of acquiring a lock with a timeout.
  /// Return status codes for Python lock acquisition.
  /// Chosen for maximum backwards compatibility, ie failure -> 0, success -> 1.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/synchronization.html#c.PyLockStatus">See the article about PyLockStatus.</see></para>
  /// </remarks>
  PyLockStatus = (
    /// <summary>
    /// Failed to acquire the lock.
    /// </summary>
    PY_LOCK_FAILURE  = 0,
    /// <summary>
    /// The lock was successfully acquired.
    /// </summary>
    PY_LOCK_ACQUIRED = 1,
    /// <summary>
    /// The lock was interrupted by a signal.
    /// </summary>
    PY_LOCK_INTR
  );

  {* include/cpython/context.h *}

  /// <summary>
  /// Enumeration of possible context object watcher events
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/contextvars.html#c.PyContextEvent">See the article about PyContextEvent.</see></para>
  /// </remarks>
  PyContextEvent = (
    /// <summary>
    /// The current context has switched to a different context. The object
    /// passed to the watch callback is the now-current contextvars. Context
    /// object, or None if no context is current.
    /// </summary>
    Py_CONTEXT_SWITCHED = 1
  );

  PyContext_WatchCallback = function(event: PyContextEvent; obj: PPyObject): integer; cdecl;

  {* include/modsupport.h *}
  {* include/compile.h *}

  /// <summary>
  /// This is the structure used to hold compiler flags. In cases where code is
  /// only being compiled, it is passed as int flags, and in cases where code is
  /// being executed, it is passed as PyCompilerFlags *flags. In this case,
  /// from __future__ import can modify flags.
  /// Whenever PyCompilerFlags *flags is NULL, cf_flags is treated as equal
  /// to 0, and any modification due to from __future__ import is discarded.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/veryhigh.html#c.PyCompilerFlags">See the article about PyCompilerFlags.</see></para>
  /// </remarks>
  PyCompilerFlags = record
    /// <summary>
    /// Compiler flags.
    /// </summary>
    cf_flags           : integer;
    /// <summary>
    /// cf_feature_version is the minor Python version. It should be initialized
    /// to PY_MINOR_VERSION. The field is ignored by default, it is used if and
    /// only if PyCF_ONLY_AST flag is set in cf_flags.
    /// </summary>
    cf_feature_version : integer;
  end;

  {* include/pythonrun.h *}
  {* include/pylifecycle.h *}
  AtExitProc         = procedure(); cdecl;
  PyOS_sighandler_t  = procedure(i: Integer); cdecl;

  /// <summary>
  /// Record containing most parameters to configure a sub-interpreter.
  /// Its values are used only in Py_NewInterpreterFromConfig() and never
  /// modified by the runtime.
  /// Added in version 3.12.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/subinterpreters.html#c.PyInterpreterConfig">See the article about PyInterpreterConfig.</see></para>
  /// </remarks>
  PyInterpreterConfig = record
    /// <summary>
    /// If this is 0 then the sub-interpreter will use its own "object"
    /// allocator state. Otherwise it will use (share) the main interpreter's.
    /// If this is 0 then check_multi_interp_extensions must be 1 (non-zero).
    /// If this is 1 then gil must not be PyInterpreterConfig_OWN_GIL.
    /// </summary>
    use_main_obmalloc             : Integer;
    /// <summary>
    /// If this is 0 then the runtime will not support forking the process in
    /// any thread where the sub-interpreter is currently active. Otherwise
    /// fork is unrestricted.
    /// Note that the subprocess module still works when fork is disallowed.
    /// </summary>
    allow_fork                    : Integer;
    /// <summary>
    /// If this is 0 then the runtime will not support replacing the current
    /// process via exec (e.g. os.execv()) in any thread where the
    /// sub-interpreter is currently active. Otherwise exec is unrestricted.
    /// Note that the subprocess module still works when exec is disallowed.
    /// </summary>
    allow_exec                    : Integer;
    /// <summary>
    /// If this is 0 then the sub-interpreter's threading module won't create
    /// threads. Otherwise threads are allowed.
    /// </summary>
    allow_threads                 : Integer;
    /// <summary>
    /// If this is 0 then the sub-interpreter's threading module won't create
    /// daemon threads. Otherwise daemon threads are allowed (as long as
    /// allow_threads is non-zero).
    /// </summary>
    allow_daemon_threads          : Integer;
    /// <summary>
    /// If this is 0 then all extension modules may be imported, including
    /// legacy (single-phase init) modules, in any thread where the
    /// sub-interpreter is currently active. Otherwise only multi-phase init
    /// extension modules (see PEP 489) may be imported.
    /// (Also see Py_mod_multiple_interpreters.)
    /// This must be 1 (non-zero) if use_main_obmalloc is 0.
    /// </summary>
    check_multi_interp_extensions : Integer;
    /// <summary>
    /// This determines the operation of the GIL for the sub-interpreter.
    /// It may be one of the following: PyInterpreterConfig_DEFAULT_GIL,
    /// PyInterpreterConfig_SHARED_GIL or PyInterpreterConfig_OWN_GIL.
    /// If this is PyInterpreterConfig_OWN_GIL then
    /// PyInterpreterConfig.use_main_obmalloc must be 0.
    /// </summary>
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

  /// <summary>
  /// Record describing a single entry in the list of built-in modules.
  /// Programs which embed Python may use an array of these structures in
  /// conjunction with PyImport_ExtendInittab() to provide additional built-in
  /// modules.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/import.html#c._inittab">See the article about _inittab.</see></para>
  /// </remarks>
  _inittab = record
    /// <summary>
    /// The module name, as an ASCII encoded string.
    /// </summary>
    name_      : PAnsiChar;
    /// <summary>
    /// Initialization function for a module built into the interpreter.
    /// </summary>
    initfunc_  : initfunc;
  end;

  /// <summary>
  /// This is the structure type definition for frozen module descriptors, as
  /// generated by the freeze utility (see Tools/freeze/ in the Python source
  /// distribution).
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/import.html#c._frozen">See the article about _frozen.</see></para>
  /// </remarks>
  _frozen = record
    /// <summary>
    /// This is an ASCII encoded string.
    /// </summary>
    name_      : PAnsiChar;
    code       : PAnsiChar;
    size_      : integer;
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

  /// <summary>
  /// This subtype of PyObject represents the difference between two datetime values.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/datetime.html#c.PyDateTime_Delta">See the article about PyDateTime_Delta.</see></para>
  /// </remarks>
  PyDateTime_Delta = record
    ob_base     : PyObject; // PyObject_HEAD
    /// <summary>
    /// -1 when unknown
    /// </summary>
    hashcode    : Py_hash_t;
    /// <summary>
    /// -MAX_DELTA_DAYS <= days <= MAX_DELTA_DAYS
    /// </summary>
    days        : Integer;
    /// <summary>
    /// 0 <= seconds < 24*3600 is invariant
    /// </summary>
    seconds     : Integer;
    /// <summary>
    /// 0 <= microseconds < 1000000 is invariant
    /// </summary>
    microseconds: Integer;
  end;

  /// <summary>
  /// PyDateTime_TZInfo is a pure abstract base class.
  /// </summary>
  PyDateTime_TZInfo = record
    ob_base     : PyObject; // PyObject_HEAD
  end;

  /// <summary>
  /// No _PyDateTime_BaseTZInfo is allocated; it's just to have something
  /// convenient to cast to, when getting at the hastzinfo member of objects
  /// starting with _PyTZINFO_HEAD.
  /// </summary>
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

  /// <summary>
  /// This subtype of PyObject represents a Python time object.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/datetime.html#c.PyDateTime_Time">See the article about PyDateTime_Time.</see></para>
  /// </remarks>
  PyDateTime_Time = record
    ob_base     : PyObject;            // PyObject_HEAD  // _PyTZINFO_HEAD  // _PyDateTime_TIMEHEAD
    hashcode    : Py_hash_t;                             // _PyTZINFO_HEAD  // _PyDateTime_TIMEHEAD
    hastzinfo   : AnsiChar;                              // _PyTZINFO_HEAD  // _PyDateTime_TIMEHEAD
    data        : array [0..pred(_PyDateTime_TIME_DATASIZE)] of AnsiChar;   // _PyDateTime_TIMEHEAD
    fold        : AnsiChar;
    tzinfo      : PPyObject;
  end;

  /// <summary>
  /// This subtype of PyObject represents a Python date object.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/datetime.html#c.PyDateTime_Date">See the article about PyDateTime_Date.</see></para>
  /// </remarks>
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

  /// <summary>
  /// This subtype of PyObject represents a Python datetime object.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/datetime.html#c.PyDateTime_DateTime">See the article about PyDateTime_DateTime.</see></para>
  /// </remarks>
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

  /// <summary>
  /// Record containing the fields for the datetime C API.
  /// The fields of this structure are private and subject to change.
  /// Do not use this directly; prefer PyDateTime_* APIs instead.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/datetime.html#c.PyDateTime_CAPI">See the article about PyDateTime_CAPI.</see></para>
  /// </remarks>
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
    /// <summary>
    /// previous frame, or NULL
    /// </summary>
    f_back                      : PPyFrameObject;
    /// <summary>
    /// Points to the frame data.
    /// Not implemented. pointer to _PyInterpreterFrame; /Include/internal/pycore_interpframe_structs.h
    /// </summary>
    f_frame                     : Pointer;
    /// <summary>
    /// Trace function
    /// </summary>
    f_trace                     : PPyObject;
    /// <summary>
    /// Current line number. Only valid if non-zero
    /// </summary>
    f_lineno                    : integer;
    /// <summary>
    /// Emit per-line trace events?
    /// </summary>
    f_trace_lines               : AnsiChar;
    /// <summary>
    /// Emit per-opcode trace events?
    /// </summary>
    f_trace_opcodes             : AnsiChar;
    /// <summary>
    /// Dict for locals set by users using f_locals, could be NULL
    /// </summary>
    f_extra_locals              : PPyObject;
    /// <summary>
    /// This is purely for backwards compatibility for PyEval_GetLocals.
    /// PyEval_GetLocals requires a borrowed reference so the actual reference
    /// is stored here
    /// </summary>
    f_locals_cache              : PPyObject;
    /// <summary>
    /// A tuple containing strong references to fast locals that were overwritten
    /// via f_locals. Borrowed references to these locals may exist in frames
    /// closer to the top of the stack. The references in this tuple act as
    /// "support" for the borrowed references, ensuring that they remain valid.
    /// </summary>
    f_overwritten_fast_locals   : PPyObject;
    /// <summary>
    /// The frame data, if this frame object owns the frame
    /// </summary>
    _f_frame_data               : array[0..0] of PPyObject;
  end;
  /// <summary>
  /// Part of the Limited API (as an opaque struct).
  /// The structure of the objects used to describe frame objects.
  /// There are no public members in this structure.
  /// Changed in version 3.11: The members of this structure were removed from
  /// the public C API. Refer to the What's New entry for details.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/frame.html#c.PyFrameObject">See the article about PyFrameObject.</see></para>
  /// </remarks>
  PyFrameObject = type _frame;

implementation

end.
