unit uP4P.Constants;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

{$IFNDEF TARGET_64BITS}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.Math;
  {$ELSE}
    Classes, Math;
  {$ENDIF}

const
  {* include/patchlevel.h *}
  PY_RELEASE_LEVEL_ALPHA = $0A;
  PY_RELEASE_LEVEL_BETA  = $0B;
  PY_RELEASE_LEVEL_GAMMA = $0C; // For release candidates
  PY_RELEASE_LEVEL_FINAL = $0F;

  PY_MAJOR_VERSION       = 3;
  PY_MINOR_VERSION       = 15;
  PY_MICRO_VERSION       = 0;
  PY_RELEASE_LEVEL       = PY_RELEASE_LEVEL_GAMMA;
  PY_RELEASE_SERIAL      = 2;

  PYTHON_API_VERSION   = 1013;
  PYTHON_API_STRING    = '1013';
  PYTHON_ABI_VERSION   = 3;
  PYTHON_ABI_STRING    = '3';


  {* Custom constants *}
  CR              = #13;
  LF              = #10;
  TAB             = #09;
  CRLF            = CR+LF;

  SUPPORTED_MAJOR_VERSION     = PY_MAJOR_VERSION;
  MAX_SUPPORTED_MINOR_VERSION = PY_MINOR_VERSION;
  MIN_SUPPORTED_MINOR_VERSION = 10;

  HOURS_IN_A_DAY        = 24;
  MINUTES_IN_AN_HOUR    = 60;
  SECONDS_IN_A_MINUTE   = 60;
  SECONDS_IN_AN_HOUR    = SECONDS_IN_A_MINUTE * MINUTES_IN_AN_HOUR;
  SECONDS_IN_A_DAY      = SECONDS_IN_AN_HOUR * HOURS_IN_A_DAY;
  MILLISECONDS_IN_A_DAY = SECONDS_IN_A_DAY * 1000;

  MAIN_MODULE_NAME         = '__main__';
  DEFAULT_COMPILE_FILENAME = '<string>';

  {$IFDEF MSWINDOWS}
  PYTHON_LIB_EXT = 'dll';
  {$ELSE}
    {$IFDEF APPLE}
    PYTHON_LIB_EXT = 'dylib';
    {$ELSE}
    PYTHON_LIB_EXT = 'so';
    {$ENDIF}
  {$ENDIF}

  /// <summary>
  /// These contants are declared in the "Windows" unit but
  /// some old Delphi versions don't have them.
  /// We have to add "P4P_" to be compatible with C++ Builder.
  /// </summary>
  P4P_IMAGE_FILE_MACHINE_I386  = $014C;
  P4P_IMAGE_FILE_MACHINE_AMD64 = $8664;

  /// <summary>
  /// Names of configuration options used by TPyInitConfig
  /// </summary>
  PYINITCONFIGOPTION_ALLOCATOR                  = 'allocator';
  PYINITCONFIGOPTION_ARGV                       = 'argv';
  PYINITCONFIGOPTION_BASE_EXEC_PREFIX           = 'base_exec_prefix';
  PYINITCONFIGOPTION_BASE_EXECUTABLE            = 'base_executable';
  PYINITCONFIGOPTION_BASE_PREFIX                = 'base_prefix';
  PYINITCONFIGOPTION_BUFFERED_STDIO             = 'buffered_stdio';
  PYINITCONFIGOPTION_BYTES_WARNING              = 'bytes_warning';
  PYINITCONFIGOPTION_CHECK_HASH_PYCS_MODE       = 'check_hash_pycs_mode';
  PYINITCONFIGOPTION_CODE_DEBUG_RANGES          = 'code_debug_ranges';
  PYINITCONFIGOPTION_COERCE_C_LOCALE            = 'coerce_c_locale';
  PYINITCONFIGOPTION_COERCE_C_LOCALE_WARN       = 'coerce_c_locale_warn';
  PYINITCONFIGOPTION_CONFIGURE_C_STDIO          = 'configure_c_stdio';
  PYINITCONFIGOPTION_CONFIGURE_LOCALE           = 'configure_locale';
  PYINITCONFIGOPTION_CPU_COUNT                  = 'cpu_count';
  PYINITCONFIGOPTION_DEV_MODE                   = 'dev_mode';
  PYINITCONFIGOPTION_DUMP_REFS                  = 'dump_refs';
  PYINITCONFIGOPTION_DUMP_REFS_FILE             = 'dump_refs_file';
  PYINITCONFIGOPTION_EXEC_PREFIX                = 'exec_prefix';
  PYINITCONFIGOPTION_EXECUTABLE                 = 'executable';
  PYINITCONFIGOPTION_FAULTHANDLER               = 'faulthandler';
  PYINITCONFIGOPTION_FILESYSTEM_ENCODING        = 'filesystem_encoding';
  PYINITCONFIGOPTION_FILESYSTEM_ERRORS          = 'filesystem_errors';
  PYINITCONFIGOPTION_HASH_SEED                  = 'hash_seed';
  PYINITCONFIGOPTION_HOME                       = 'home';
  PYINITCONFIGOPTION_IMPORT_TIME                = 'import_time';
  PYINITCONFIGOPTION_INSPECT                    = 'inspect';
  PYINITCONFIGOPTION_INSTALL_SIGNAL_HANDLERS    = 'install_signal_handlers';
  PYINITCONFIGOPTION_INT_MAX_STR_DIGITS         = 'int_max_str_digits';
  PYINITCONFIGOPTION_INTERACTIVE                = 'interactive';
  PYINITCONFIGOPTION_ISOLATED                   = 'isolated';
  PYINITCONFIGOPTION_LAZY_IMPORTS               = 'lazy_imports';           //****** 3.15.0
  {$IFDEF MSWINDOWS}
  PYINITCONFIGOPTION_LEGACY_WINDOWS_FS_ENCODING = 'legacy_windows_fs_encoding';
  PYINITCONFIGOPTION_LEGACY_WINDOWS_STDIO       = 'legacy_windows_stdio';
  {$ENDIF}
  PYINITCONFIGOPTION_MALLOC_STATS               = 'malloc_stats';
  PYINITCONFIGOPTION_MODULE_SEARCH_PATHS        = 'module_search_paths';
  PYINITCONFIGOPTION_OPTIMIZATION_LEVEL         = 'optimization_level';
  PYINITCONFIGOPTION_ORIG_ARGV                  = 'orig_argv';
  PYINITCONFIGOPTION_PARSE_ARGV                 = 'parse_argv';
  PYINITCONFIGOPTION_PARSER_DEBUG               = 'parser_debug';
  PYINITCONFIGOPTION_PATHCONFIG_WARNINGS        = 'pathconfig_warnings';
  PYINITCONFIGOPTION_PERF_PROFILING             = 'perf_profiling';
  PYINITCONFIGOPTION_PLATLIBDIR                 = 'platlibdir';
  PYINITCONFIGOPTION_PREFIX                     = 'prefix';
  PYINITCONFIGOPTION_PROGRAM_NAME               = 'program_name';
  PYINITCONFIGOPTION_PYCACHE_PREFIX             = 'pycache_prefix';
  PYINITCONFIGOPTION_PYMALLOC_HUGEPAGES         = 'pymalloc_hugepages';     //****** 3.15.0
  PYINITCONFIGOPTION_QUIET                      = 'quiet';
  PYINITCONFIGOPTION_RUN_COMMAND                = 'run_command';
  PYINITCONFIGOPTION_RUN_FILENAME               = 'run_filename';
  PYINITCONFIGOPTION_RUN_MODULE                 = 'run_module';
  PYINITCONFIGOPTION_RUN_PRESITE                = 'run_presite';
  PYINITCONFIGOPTION_SAFE_PATH                  = 'safe_path';
  PYINITCONFIGOPTION_SHOW_REF_COUNT             = 'show_ref_count';
  PYINITCONFIGOPTION_SITE_IMPORT                = 'site_import';
  PYINITCONFIGOPTION_SKIP_SOURCE_FIRST_LINE     = 'skip_source_first_line';
  PYINITCONFIGOPTION_STDIO_ENCODING             = 'stdio_encoding';
  PYINITCONFIGOPTION_STDIO_ERRORS               = 'stdio_errors';
  PYINITCONFIGOPTION_STDLIB_DIR                 = 'stdlib_dir';
  PYINITCONFIGOPTION_TRACEMALLOC                = 'tracemalloc';
  PYINITCONFIGOPTION_USE_ENVIRONMENT            = 'use_environment';
  PYINITCONFIGOPTION_USE_FROZEN_MODULES         = 'use_frozen_modules';
  PYINITCONFIGOPTION_USE_HASH_SEED              = 'use_hash_seed';
  PYINITCONFIGOPTION_USE_SYSTEM_LOGGER          = 'use_system_logger';
  PYINITCONFIGOPTION_USER_SITE_DIRECTORY        = 'user_site_directory';
  PYINITCONFIGOPTION_UTF8_MODE                  = 'utf8_mode';
  PYINITCONFIGOPTION_VERBOSE                    = 'verbose';
  PYINITCONFIGOPTION_WARN_DEFAULT_ENCODING      = 'warn_default_encoding';
  PYINITCONFIGOPTION_WARNOPTIONS                = 'warnoptions';
  PYINITCONFIGOPTION_WRITE_BYTECODE             = 'write_bytecode';
  PYINITCONFIGOPTION_XOPTIONS                   = 'xoptions';


  {* include/pyport.h *}
  {* include/exports.h *}
  {* include/pymacro.h *}
  {* include/pymath.h *}

  /// <summary>
  /// High precision (long double) definition of pi constant.
  /// </summary>
  Py_MATH_PIl = 3.1415926535897932384626433832795029;
  /// <summary>
  /// The definition (accurate for a double type) of the math.pi constant.
  /// </summary>
  Py_MATH_PI  = 3.14159265358979323846;
  /// <summary>
  /// High precision (long double) definition of e constant.
  /// </summary>
  Py_MATH_El  = 2.7182818284590452353602874713526625;
  /// <summary>
  /// The definition (accurate for a double type) of the math.e constant.
  /// </summary>
  Py_MATH_E   = 2.7182818284590452354;
  /// <summary>
  /// The definition (accurate for a double type) of the math.tau constant.
  /// </summary>
  Py_MATH_TAU = 6.2831853071795864769252867665590057683943;
  /// <summary>
  /// This constant represents the positive infinity. On most platforms,
  /// this is equivalent to the INFINITY macro from the C11 standard <math.h>
  /// header.
  /// </summary>
  Py_INFINITY = INFINITY;
  /// <summary>
  /// Equivalent to INFINITY. Deprecated since version 3.14: This is soft
  /// deprecated.
  /// </summary>
  Py_HUGE_VAL = Py_INFINITY;
  /// <summary>
  /// This constant represents a quiet not-a-number (qNaN) value. On most
  /// platforms, this is equivalent to the NAN macro from the C11 standard
  /// <math.h> header.
  /// </summary>
  Py_NAN      = NAN;

  {* include/pymem.h *}
  {* include/pytypedefs.h *}
  {* include/pybuffer.h *}

  /// <summary>
  /// The maximum number of dimensions the memory represents. Exporters MUST
  /// respect this limit, consumers of multi-dimensional buffers SHOULD be able
  /// to handle up to PyBUF_MAX_NDIM dimensions. Currently set to 64.
  /// </summary>
  PyBUF_MAX_NDIM = 64;

  /// <summary>
  /// Flags for getting buffers.
  /// </summary>
  PyBUF_SIMPLE   = 0;
  /// <summary>
  /// Flags for getting buffers.
  /// </summary>
  PyBUF_WRITABLE = 1;

  PyBUF_FORMAT         = $0004;
  PyBUF_ND             = $0008;
  PyBUF_STRIDES        = $0010 or PyBUF_ND;
  PyBUF_C_CONTIGUOUS   = $0020 or PyBUF_STRIDES;
  PyBUF_F_CONTIGUOUS   = $0040 or PyBUF_STRIDES;
  PyBUF_ANY_CONTIGUOUS = $0080 or PyBUF_STRIDES;
  PyBUF_INDIRECT       = $0100 or PyBUF_STRIDES;

  PyBUF_CONTIG     = PyBUF_ND or PyBUF_WRITABLE;
  PyBUF_CONTIG_RO  = PyBUF_ND;

  PyBUF_STRIDED    = PyBUF_STRIDES or PyBUF_WRITABLE;
  PyBUF_STRIDED_RO = PyBUF_STRIDES;

  PyBUF_RECORDS    = PyBUF_STRIDES or PyBUF_WRITABLE or PyBUF_FORMAT;
  PyBUF_RECORDS_RO = PyBUF_STRIDES or PyBUF_FORMAT;

  PyBUF_FULL       = PyBUF_INDIRECT or PyBUF_WRITABLE or PyBUF_FORMAT;
  PyBUF_FULL_RO    = PyBUF_INDIRECT or PyBUF_FORMAT;

  PyBUF_READ       = $100;
  PyBUF_WRITE      = $200;

  {* include/pystats.h *}
  {* include/pyatomic.h *}
  {* include/lock.h  include/cpython/lock.h  include/cpython/pylock.h *}
  {* include/critical_section.h *}
  {* include/object.h  include/cpython/object.h *}
  Py_PRINT_RAW    = 1;

  _Py_TPFLAGS_STATIC_BUILTIN          = 1 shl 1;
  Py_TPFLAGS_INLINE_VALUES            = 1 shl 2;
  Py_TPFLAGS_MANAGED_WEAKREF          = 1 shl 3;
  Py_TPFLAGS_MANAGED_DICT             = 1 shl 4;
  Py_TPFLAGS_PREHEADER                = Py_TPFLAGS_MANAGED_WEAKREF or Py_TPFLAGS_MANAGED_DICT;
  Py_TPFLAGS_SEQUENCE                 = 1 shl 5;
  Py_TPFLAGS_MAPPING                  = 1 shl 6;
  Py_TPFLAGS_DISALLOW_INSTANTIATION   = 1 shl 7;
  Py_TPFLAGS_IMMUTABLETYPE            = 1 shl 8;
  Py_TPFLAGS_HEAPTYPE                 = 1 shl 9;
  Py_TPFLAGS_BASETYPE                 = 1 shl 10;
  Py_TPFLAGS_HAVE_VECTORCALL          = 1 shl 11;
  Py_TPFLAGS_READY                    = 1 shl 12;
  Py_TPFLAGS_READYING                 = 1 shl 13;
  Py_TPFLAGS_HAVE_GC                  = 1 shl 14;
  Py_TPFLAGS_HAVE_STACKLESS_EXTENSION = 0;
  Py_TPFLAGS_METHOD_DESCRIPTOR        = 1 shl 17;
  Py_TPFLAGS_VALID_VERSION_TAG        = 1 shl 19;
  Py_TPFLAGS_IS_ABSTRACT              = 1 shl 20;
  _Py_TPFLAGS_MATCH_SELF              = 1 shl 22;
  Py_TPFLAGS_ITEMS_AT_END             = 1 shl 23;
  Py_TPFLAGS_LONG_SUBCLASS            = 1 shl 24;
  Py_TPFLAGS_LIST_SUBCLASS            = 1 shl 25;
  Py_TPFLAGS_TUPLE_SUBCLASS           = 1 shl 26;
  Py_TPFLAGS_BYTES_SUBCLASS           = 1 shl 27;
  Py_TPFLAGS_UNICODE_SUBCLASS         = 1 shl 28;
  Py_TPFLAGS_DICT_SUBCLASS            = 1 shl 29;
  Py_TPFLAGS_BASE_EXC_SUBCLASS        = 1 shl 30;
  Py_TPFLAGS_TYPE_SUBCLASS            = 1 shl 31;
  Py_TPFLAGS_HAVE_FINALIZE            = 1 shl  0;
  Py_TPFLAGS_HAVE_VERSION_TAG         = 1 shl 18;

  Py_CONSTANT_NONE             = 0;
  Py_CONSTANT_FALSE            = 1;
  Py_CONSTANT_TRUE             = 2;
  Py_CONSTANT_ELLIPSIS         = 3;
  Py_CONSTANT_NOT_IMPLEMENTED  = 4;
  Py_CONSTANT_ZERO             = 5;
  Py_CONSTANT_ONE              = 6;
  Py_CONSTANT_EMPTY_STR        = 7;
  Py_CONSTANT_EMPTY_BYTES      = 8;
  Py_CONSTANT_EMPTY_TUPLE      = 9;
  Py_CONSTANT_FIRST            = Py_CONSTANT_NONE;
  Py_CONSTANT_LAST             = Py_CONSTANT_EMPTY_TUPLE;

  Py_LT = 0;
  Py_LE = 1;
  Py_EQ = 2;
  Py_NE = 3;
  Py_GT = 4;
  Py_GE = 5;

  {* include/refcount.h *}
  {* include/objimpl.h *}
  {* include/typeslots.h  include/slots.h  include/slots_generated.h *}

  /// <summary>
  /// <para>If the slot ID is unknown, the interpreter should ignore the slot
  /// entirely. (For example, if nb_matrix_multiply was being added to CPython
  /// now, your type could use this.)</para>
  /// </summary>
  PySlot_OPTIONAL  = $0001;
  /// <summary>
  /// <para>All data the slot points to is statically allocated and constant.
  /// Thus, the interpreter does not need to copy the information. This flag
  /// is implied for function pointers.</para>
  /// <para>The flag applies even to data the slot points to "indirectly",
  /// except for nested slots - see Nested slot tables below - which can have
  /// their own PySlot_STATIC flag. For example, if applied to a Py_tp_members
  /// slot that points to an array of PyMemberDef structures, then the entire
  /// array, as well as the name and doc strings in its elements, must be
  /// static and constant.</para>
  /// <para>This flag will be required for slots that need static data
  /// (Py_mod_methods, Py_tp_methods, Py_tp_members, Py_tp_getset).</para>
  /// </summary>
  PySlot_STATIC    = $0002;
  /// <summary>
  /// <para>The data is stored in sl_ptr, and must be cast to the appropriate
  /// type.</para>
  /// <para>This flag simplifies porting from the existing PyType_Slot and
  /// PyModuleDef_Slot, where all slots work this way.</para>
  /// </summary>
  PySlot_INTPTR    = $0004;
  /// <summary>
  /// <para>Reserved; will always be treated as an unknown slot ID. Defined as
  /// UINT16_MAX (0xFFFF).</para>
  /// <para>When used with the PySlot_OPTIONAL flag, defines a slot with no
  /// effect. Without the flag, processing a slot with this ID will fail.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_slot_invalid  = $FFFF;

  {*
     WARNING:
     --------
     Due to changes in recent Python versions the Py_mp_*, Py_bf_*
     and Py_mod_* constants are defined by the TPy_mp, TPy_bf and TPy_mod
     class helpers.
  *}
  /// <summary>
  /// <para>Marks the end of a slots array. Defined as zero.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_slot_end = 0;
  Py_nb_absolute = 6;
  Py_nb_add = 7;
  Py_nb_and = 8;
  Py_nb_bool = 9;
  Py_nb_divmod = 10;
  Py_nb_float = 11;
  Py_nb_floor_divide = 12;
  Py_nb_index = 13;
  Py_nb_inplace_add = 14;
  Py_nb_inplace_and = 15;
  Py_nb_inplace_floor_divide = 16;
  Py_nb_inplace_lshift = 17;
  Py_nb_inplace_multiply = 18;
  Py_nb_inplace_or = 19;
  Py_nb_inplace_power = 20;
  Py_nb_inplace_remainder = 21;
  Py_nb_inplace_rshift = 22;
  Py_nb_inplace_subtract = 23;
  Py_nb_inplace_true_divide = 24;
  Py_nb_inplace_xor = 25;
  Py_nb_int = 26;
  Py_nb_invert = 27;
  Py_nb_lshift = 28;
  Py_nb_multiply = 29;
  Py_nb_negative = 30;
  Py_nb_or = 31;
  Py_nb_positive = 32;
  Py_nb_power = 33;
  Py_nb_remainder = 34;
  Py_nb_rshift = 35;
  Py_nb_subtract = 36;
  Py_nb_true_divide = 37;
  Py_nb_xor = 38;
  Py_sq_ass_item = 39;
  Py_sq_concat = 40;
  Py_sq_contains = 41;
  Py_sq_inplace_concat = 42;
  Py_sq_inplace_repeat = 43;
  Py_sq_item = 44;
  Py_sq_length = 45;
  Py_sq_repeat = 46;
  Py_tp_alloc = 47;
  /// <summary>
  /// <para>Equivalent to Py_tp_bases (with s at the end). If both are
  /// specified, Py_tp_bases takes priority and this slot is ignored.</para>
  /// <para>Changed in version 3.15: Previously, Py_tp_base required a single
  /// type, not a tuple.</para>
  /// <para>Soft deprecated since version 3.15: When not targeting older Python
  /// versions, prefer Py_tp_bases.</para>
  /// </summary>
  Py_tp_base = 48;
  /// <summary>
  /// <para>Slot ID for type flags, used to set PyTypeObject.tp_bases.</para>
  /// <para>The slot can be set to a tuple of type objects which the newly
  /// created type should inherit from, like the "positional arguments" of a
  /// Python class definition.</para>
  /// <para>Alternately, the slot can be set to a single type object to specify
  /// a single base. The effect is the same as specifying a one-element
  /// tuple.</para>
  /// <para>Changed in version 3.15: Previously, Py_tp_bases required a tuple
  /// of types.</para>
  /// </summary>
  Py_tp_bases = 49;
  Py_tp_call = 50;
  Py_tp_clear = 51;
  Py_tp_dealloc = 52;
  Py_tp_del = 53;
  Py_tp_descr_get = 54;
  Py_tp_descr_set = 55;
  Py_tp_doc = 56;
  Py_tp_getattr = 57;
  Py_tp_getattro = 58;
  Py_tp_hash = 59;
  Py_tp_init = 60;
  Py_tp_is_gc = 61;
  Py_tp_iter = 62;
  Py_tp_iternext = 63;
  Py_tp_methods = 64;
  Py_tp_new = 65;
  Py_tp_repr = 66;
  Py_tp_richcompare = 67;
  Py_tp_setattr = 68;
  Py_tp_setattro = 69;
  Py_tp_str = 70;
  Py_tp_traverse = 71;
  Py_tp_members = 72;
  Py_tp_getset = 73;
  Py_tp_free = 74;
  Py_nb_matrix_multiply = 75;
  Py_nb_inplace_matrix_multiply = 76;
  Py_am_await = 77;
  Py_am_aiter = 78;
  Py_am_anext = 79;
  Py_tp_finalize = 80;
  Py_am_send = 81;
  Py_tp_vectorcall = 82;
  /// <summary>
  /// <para>Slot ID for recording a static memory layout ID for a class.</para>
  /// <para>If the class is defined using a PyType_Spec, and that spec is
  /// statically allocated, the token can be set to the spec using the special
  /// value Py_TP_USE_SPEC:</para>
  /// <code>
  /// static PyType_Slot foo_slots[] = {
  ///    {Py_tp_token, Py_TP_USE_SPEC},
  /// </code>
  /// <para>It can also be set to an arbitrary pointer, but you must ensure
  /// that:</para>
  /// <code>
  /// - The pointer outlives the class, so it's not reused for something else
  ///   while the class exists.
  /// - It "belongs" to the extension module where the class lives, so it will
  ///   not clash with other extensions.
  /// </code>
  /// <para>Use TPyType.GetBaseByToken() to check if a class's superclass has
  /// a given token - that is, check whether the memory layout is
  /// compatible.</para>
  /// <para>To get the token for a given class (without considering
  /// superclasses), use TPyType.GetSlot() with Py_tp_token.</para>
  /// <para>Added in version 3.14.</para>
  /// </summary>
  Py_tp_token = 83;
  /// <summary>
  /// <para>Nested slots array.</para>
  /// <para>The value (sl_ptr) should point to an array of PySlot structures.
  /// The slots in the array (up to but not including the zero-ID terminator)
  /// will be treated as if they were inserted if the current slot array, at
  /// the point Py_slot_subslots appears.</para>
  /// <para>Slot nesting depth is limited to 5 levels. This restriction may be
  /// lifted in the future.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_slot_subslots = 92;
  /// <summary>
  /// <para>Slot ID that works like Py_slot_subslots, except it specifies an
  /// array of PyType_Slot structures.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_slots = 93;
  /// <summary>
  /// <para>Slot ID for the name of the type, used to set
  /// PyTypeObject.tp_name.</para>
  /// <para>This slot (or PyType_Spec.name) is required to create a type.</para>
  /// <para>This may not be used in PyType_Spec.slots. Use PyType_Spec.name
  /// instead.</para>
  /// <para>CPython implementation detail: CPython processes slots in order.
  /// It is recommended to put Py_tp_name at the beginning of the slots array,
  /// so that if processing of a later slots fails, error messages can include
  /// the name.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_name = 95;
  /// <summary>
  /// <para>Slot ID for the size of the instance in bytes. It is used to set
  /// PyTypeObject.tp_basicsize.</para>
  /// <para>The value must be positive.</para>
  /// <para>This may not be used in PyType_Spec.slots. Use
  /// PyType_Spec.basicsize instead.</para>
  /// <para>This slot may not be used with TPyType.GetSlot(). Use
  /// PyTypeObject.tp_basicsize instead if needed, but be aware that a type's
  /// size is often considered an implementation detail.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_basicsize = 96;
  /// <summary>
  /// <para>Slot ID for type data size in bytes, that is, how much space
  /// instances of the class need in addition to space needed for
  /// superclasses.</para>
  /// <para>The value is used, together with the size of superclasses, to set
  /// PyTypeObject.tp_basicsize. Python will insert padding as needed to meet
  /// tp_basicsize's alignment requirements.</para>
  /// <para>Use TPyObject.GetTypeData() to get a pointer to subclass-specific
  /// memory reserved this way.</para>
  /// <para>The value must be positive. To specify that instances need no
  /// additional size (that is, size should be inherited), omit the
  /// Py_tp_extra_basicsize slot rather than set it to zero.</para>
  /// <para>Specifying both Py_tp_basicsize and Py_tp_extra_basicsize is an
  /// error.</para>
  /// <para>This may not be used in PyType_Spec.slots. Use negative
  /// PyType_Spec.basicsize instead.</para>
  /// <para>This slot may not be used with TPyType.GetSlot().</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_extra_basicsize = 97;
  /// <summary>
  /// <para>Slot ID for the size of one element of a variable-size type, in
  /// bytes. Used to set PyTypeObject.tp_itemsize. See tp_itemsize
  /// documentation for caveats.</para>
  /// <para>The value must be positive.</para>
  /// <para>If this slot is missing, tp_itemsize is inherited. Extending
  /// arbitrary variable-sized classes is dangerous, since some types use a
  /// fixed offset for variable-sized memory, which can then overlap
  /// fixed-sized memory used by a subclass. To help prevent mistakes,
  /// inheriting itemsize is only possible in the following situations:</para>
  /// <code>
  /// - The base is not variable-sized (its tp_itemsize is zero).
  /// - The requested PyType_Spec.basicsize is positive, suggesting that the
  ///   memory layout of the base class is known.
  /// - The requested PyType_Spec.basicsize is zero, suggesting that the
  ///   subclass does not access the instance's memory directly.
  /// - With the Py_TPFLAGS_ITEMS_AT_END flag.
  /// </code>
  /// <para>This may not be used in PyType_Spec.slots. Use PyType_Spec.itemsize
  /// instead.</para>
  /// <para>This slot may not be used with TPyType.GetSlot().</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_itemsize = 98;
  /// <summary>
  /// <para>Slot ID for type flags, used to set PyTypeObject.tp_flags.</para>
  /// <para>The Py_TPFLAGS_HEAPTYPE flag is not set, TPyType.FromSpecWithBases()
  /// sets it automatically.</para>
  /// <para>This may not be used in PyType_Spec.slots. Use negative
  /// PyType_Spec.basicsize instead.</para>
  /// <para>This slot may not be used with PyType_GetSlot(). Use
  /// TPyType.GetFlags() instead.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_flags = 99;
  /// <summary>
  /// <para>Slot ID for the metaclass used to construct the resulting type
  /// object. When omitted the metaclass is derived from bases (Py_tp_bases or
  /// the bases argument of TPyType.FromMetaclass()).</para>
  /// <para>Metaclasses that override tp_new are not supported, except if
  /// tp_new is nil.</para>
  /// <para>This may not be used in PyType_Spec.slots. Use
  /// TPyType.FromMetaclass() to specify a metaclass with PyType_Spec.</para>
  /// <para>This slot may not be used with TPyType.GetSlot(). Use TPy.TYPE_()
  /// on the type object instead.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_metaclass = 107;
  /// <summary>
  /// <para>Slot ID for recording the module in which the new class is
  /// defined.</para>
  /// <para>The value must be a module object. The module is associated with
  /// the new type and can later be retrieved with TPyType.GetModule().
  /// The associated module is not inherited by subclasses; it must be
  /// specified for each class individually.</para>
  /// <para>This may not be used in PyType_Spec.slots. Use
  /// TPyType.FromMetaclass() to specify a module with PyType_Spec.</para>
  /// <para>This slot may not be used with TPyType.GetSlot(). Use
  /// TPyType.GetModule() instead.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_module = 108;


  {* include/pyhash.h *}
  Py_HASH_CUTOFF    = 0;
  Py_HASH_EXTERNAL  = 0;
  Py_HASH_SIPHASH24 = 1;
  Py_HASH_FNV       = 2;
  Py_HASH_SIPHASH13 = 3;

  {* include/cpython/pydebug.h *}
  {* include/bytearrayobject.h *}
  {* include/bytesobject.h  include/cpython/bytesobject.h  include/internal/pycore_bytesobject.h  *}
  {* include/unicodeobject.h *}
  {* include/pyerrors.h  include/cpython/pyerrors.h *}
  {* include/longobject.h *}
  Py_ASNATIVEBYTES_DEFAULTS        = -1;
  Py_ASNATIVEBYTES_BIG_ENDIAN      = 0;
  Py_ASNATIVEBYTES_LITTLE_ENDIAN   = 1;
  Py_ASNATIVEBYTES_NATIVE_ENDIAN   = 3;
  Py_ASNATIVEBYTES_UNSIGNED_BUFFER = 4;
  Py_ASNATIVEBYTES_REJECT_NEGATIVE = 8;
  Py_ASNATIVEBYTES_ALLOW_INDEX     = 16;

  {* include/cpython/longintrepr.h *}
  {* include/boolobject.h *}
  {* include/floatobject.h *}
  {* include/complexobject.h *}
  {* include/rangeobject.h *}
  {* include/memoryobject.h *}
  {* include/tupleobject.h *}
  {* include/listobject.h *}
  {* include/dictobject.h *}
  {* include/cpython/odictobject.h *}
  {* include/enumobject.h *}
  {* include/setobject.h *}
  {* include/methodobject.h  include/cpython/methodobject.h *}
  METH_VARARGS   = $0001;
  METH_KEYWORDS  = $0002;
  METH_NOARGS    = $0004;
  METH_O         = $0008;
  METH_CLASS     = $0010;
  METH_STATIC    = $0020;
  METH_COEXIST   = $0040;
  METH_FASTCALL  = $0080;
  METH_STACKLESS = $0000; // $0100;
  METH_METHOD    = $0200;


  {* include/moduleobject.h *}

  /// <summary>
  /// <para>The module does not support being imported in
  /// subinterpreters.</para>
  /// </summary>
  Py_MOD_MULTIPLE_INTERPRETERS_NOT_SUPPORTED  : Pointer = Pointer(0);
  /// <summary>
  /// <para>The module supports being imported in subinterpreters, but only when
  /// they share the main interpreter's GIL.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/howto/isolating-extensions.html#isolating-extensions-howto">See the article about Isolating Extension Modules.</see></para>
  /// </remarks>
  Py_MOD_MULTIPLE_INTERPRETERS_SUPPORTED      : Pointer = Pointer(1);
  /// <summary>
  /// <para>The module supports being imported in subinterpreters, even when
  /// they have their own GIL.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/howto/isolating-extensions.html#isolating-extensions-howto">See the article about Isolating Extension Modules.</see></para>
  /// </remarks>
  Py_MOD_PER_INTERPRETER_GIL_SUPPORTED        : Pointer = Pointer(2);

  /// <summary>
  /// <para>The module depends on the presence of the global interpreter lock
  /// (GIL), and may access global state without synchronization.</para>
  /// </summary>
  Py_MOD_GIL_USED                             : Pointer = Pointer(0);
  /// <summary>
  /// <para>The module is safe to run without an active GIL.</para>
  /// </summary>
  Py_MOD_GIL_NOT_USED                         : Pointer = Pointer(1);

  {* include/monitoring.h  include/cpython/monitoring.h *}
  PY_MONITORING_EVENT_PY_START          = 0;
  PY_MONITORING_EVENT_PY_RESUME         = 1;
  PY_MONITORING_EVENT_PY_RETURN         = 2;
  PY_MONITORING_EVENT_PY_YIELD          = 3;
  PY_MONITORING_EVENT_CALL              = 4;
  PY_MONITORING_EVENT_LINE              = 5;
  PY_MONITORING_EVENT_INSTRUCTION       = 6;
  PY_MONITORING_EVENT_JUMP              = 7;
  PY_MONITORING_EVENT_BRANCH_LEFT       = 8;
  PY_MONITORING_EVENT_BRANCH_RIGHT      = 9;
  PY_MONITORING_EVENT_STOP_ITERATION    = 10;
  PY_MONITORING_EVENT_RAISE             = 11;
  PY_MONITORING_EVENT_EXCEPTION_HANDLED = 12;
  PY_MONITORING_EVENT_PY_UNWIND         = 13;
  PY_MONITORING_EVENT_PY_THROW          = 14;
  PY_MONITORING_EVENT_RERAISE           = 15;
  PY_MONITORING_EVENT_C_RETURN          = 16;
  PY_MONITORING_EVENT_C_RAISE           = 17;
  PY_MONITORING_EVENT_BRANCH            = 18;

  {* include/cpython/funcobject.h *}
  {* include/cpython/classobject.h *}
  {* include/fileobject.h *}
  {* include/pycapsule.h *}
  {* include/cpython/code.h *}
  CO_OPTIMIZED    = $0001;
  CO_NEWLOCALS    = $0002;
  CO_VARARGS      = $0004;
  CO_VARKEYWORDS  = $0008;
  CO_NESTED       = $0010;
  CO_GENERATOR    = $0020;

  CO_COROUTINE            = $0080;
  CO_ITERABLE_COROUTINE   = $0100;
  CO_ASYNC_GENERATOR      = $0200;

  CO_FUTURE_DIVISION         = $0020000;
  CO_FUTURE_ABSOLUTE_IMPORT  = $0040000;
  CO_FUTURE_WITH_STATEMENT   = $0080000;
  CO_FUTURE_PRINT_FUNCTION   = $0100000;
  CO_FUTURE_UNICODE_LITERALS = $0200000;

  CO_FUTURE_BARRY_AS_BDFL    = $0400000;
  CO_FUTURE_GENERATOR_STOP   = $0800000;
  CO_FUTURE_ANNOTATIONS      = $1000000;

  CO_NO_MONITORING_EVENTS    = $2000000;

  CO_HAS_DOCSTRING           = $4000000;

  CO_METHOD                  = $8000000;

  CO_MAXBLOCKS               = 21;

  {* include/pyframe.h *}
  {* include/traceback.h *}
  {* include/sliceobject.h  include/cpython/sliceobject.h *}
  {* include/cpython/cellobject.h *}
  {* include/iterobject.h *}
  {* include/cpython/initconfig.h *}
  {* include/pystate.h *}
  PyTrace_CALL        = 0;
  PyTrace_EXCEPTION   = 1;
  PyTrace_LINE        = 2;
  PyTrace_RETURN      = 3;
  PyTrace_C_CALL      = 4;
  PyTrace_C_EXCEPTION = 5;
  PyTrace_C_RETURN    = 6;
  PyTrace_OPCODE      = 7;

  {* include/cpython/genobject.h *}
  {* include/descrobject.h *}
  Py_T_SHORT            = 0;
  Py_T_INT              = 1;
  Py_T_LONG             = 2;
  Py_T_FLOAT            = 3;
  Py_T_DOUBLE           = 4;
  Py_T_STRING           = 5;
  _Py_T_OBJECT          = 6;  // Deprecated, use Py_T_OBJECT_EX instead
  Py_T_CHAR             = 7;
  Py_T_BYTE             = 8;
  Py_T_UBYTE            = 9;
  Py_T_USHORT           = 10;
  Py_T_UINT             = 11;
  Py_T_ULONG            = 12;
  Py_T_STRING_INPLACE   = 13;
  Py_T_BOOL             = 14;
  Py_T_OBJECT_EX        = 16;
  Py_T_LONGLONG         = 17;
  Py_T_ULONGLONG        = 18;
  Py_T_PYSSIZET         = 19;
  _Py_T_NONE            = 20; // Deprecated. Value is always None.

  Py_READONLY           = 1 shl 0;
  Py_AUDIT_READ         = 1 shl 1; // Added in 3.10, harmless no-op before that
  _Py_WRITE_RESTRICTED  = 1 shl 2; // Deprecated, no-op. Do not reuse the value.
  Py_RELATIVE_OFFSET    = 1 shl 3;
  _Py_AFTER_ITEMS       = 1 shl 4;

  /// <summary>
  /// Flag for wrapperbase.
  /// The wrapper function takes keyword args.
  /// </summary>
  PyWrapperFlag_KEYWORDS = 1;

  {* include/genericaliasobject.h *}
  {* include/cpython/sentinelobject.h *}
  {* include/warnings.h *}
  {* include/weakrefobject.h *}
  {* include/structseq.h  include/cpython/structseq.h *}
  {* include/cpython/picklebufobject.h *}
  {* include/cpython/pytime.h *}

  /// <summary>
  /// Minimum value of PyTime_t.
  /// </summary>
  PyTime_MIN = low(int64);
  /// <summary>
  /// Maximum value of PyTime_t.
  /// </summary>
  PyTime_MAX = high(int64);

  {* include/codecs.h *}
  {* include/pythread.h *}
  WAIT_LOCK             = 1;
  NOWAIT_LOCK           = 0;

  LLONG_MAX             = high(int64);
  {$IFDEF POSIX}
  PY_TIMEOUT_MAX_VALUE  = LLONG_MAX / 1000;
  {$ELSE}
    {$IFDEF MSWINDOWS}
    PY_TIMEOUT_MAX_VALUE = $3E7FFFFF830; // int64($FFFFFFFE) * 1000;
    {$ELSE}
    PY_TIMEOUT_MAX_VALUE = LLONG_MAX;
    {$ENDIF}
  {$ENDIF}
  PY_TIMEOUT_MAX        = PY_TIMEOUT_MAX_VALUE;


{* #define PYTHREAD_INVALID_THREAD_ID ((unsigned long)-1) *}
{$IFDEF MSWINDOWS}
  PYTHREAD_INVALID_THREAD_ID = Cardinal(-1);
{$ELSE}
  PYTHREAD_INVALID_THREAD_ID = NativeUInt(-1);
{$ENDIF}

  {* include/cpython/context.h *}
  {* include/modsupport.h  include/cpython/modsupport.h *}
  Py_CLEANUP_SUPPORTED = $20000;

  /// <summary>
  /// Specifies that Stable ABI is used.
  /// </summary>
  PyABIInfo_STABLE                 = $0001;
  /// <summary>
  /// Specifies ABI compatible with non-free-threaded builds of CPython
  /// (ones compiled without --disable-gil).
  /// </summary>
  PyABIInfo_GIL                    = $0002;
  /// <summary>
  /// Specifies ABI compatible with free-threaded builds of CPython.
  /// (That is, ones compiled with --disable-gil; with t in sys.abiflags).
  /// </summary>
  PyABIInfo_FREETHREADED           = $0004;
  /// <summary>
  /// Specifies ABI specific to a particular build of CPython. Internal use only.
  /// </summary>
  PyABIInfo_INTERNAL               = $0008;
  /// <summary>
  /// Specifies ABI compatible with both free-threaded and non-free-threaded
  /// builds of CPython, that is, both abi3 and abi3t.
  /// </summary>
  PyABIInfo_FREETHREADING_AGNOSTIC = PyABIInfo_GIL or PyABIInfo_FREETHREADED;


  {* include/compile.h  include/cpython/compile.h *}
  Py_single_input    = 256;
  Py_file_input      = 257;
  Py_eval_input      = 258;
  Py_func_type_input = 345;

  PyCF_MASK = CO_FUTURE_DIVISION or
              CO_FUTURE_ABSOLUTE_IMPORT or
              CO_FUTURE_WITH_STATEMENT or
              CO_FUTURE_PRINT_FUNCTION or
              CO_FUTURE_UNICODE_LITERALS or
              CO_FUTURE_BARRY_AS_BDFL or
              CO_FUTURE_GENERATOR_STOP or
              CO_FUTURE_ANNOTATIONS;

  PyCF_SOURCE_IS_UTF8         = $0100;
  PyCF_DONT_IMPLY_DEDENT      = $0200;
  PyCF_ONLY_AST               = $0400;
  PyCF_IGNORE_COOKIE          = $0800;
  PyCF_TYPE_COMMENTS          = $1000;
  PyCF_ALLOW_TOP_LEVEL_AWAIT  = $2000;
  PyCF_ALLOW_INCOMPLETE_INPUT = $4000;
  PyCF_OPTIMIZED_AST          = $8000 or PyCF_ONLY_AST;
  PyCF_COMPILE_MASK           = PyCF_ONLY_AST or
                                PyCF_ALLOW_TOP_LEVEL_AWAIT or
                                PyCF_TYPE_COMMENTS or
                                PyCF_DONT_IMPLY_DEDENT or
                                PyCF_ALLOW_INCOMPLETE_INPUT or
                                PyCF_OPTIMIZED_AST;

  FUTURE_NESTED_SCOPES    = 'nested_scopes';
  FUTURE_GENERATORS       = 'generators';
  FUTURE_DIVISION         = 'division';
  FUTURE_ABSOLUTE_IMPORT  = 'absolute_import';
  FUTURE_WITH_STATEMENT   = 'with_statement';
  FUTURE_PRINT_FUNCTION   = 'print_function';
  FUTURE_UNICODE_LITERALS = 'unicode_literals';
  FUTURE_BARRY_AS_BDFL    = 'barry_as_FLUFL';
  FUTURE_GENERATOR_STOP   = 'generator_stop';
  FUTURE_ANNOTATIONS      = 'annotations';

  PY_INVALID_STACK_EFFECT = high(integer);

  {* include/pythonrun.h *}
  {* include/pylifecycle.h *}

  /// <summary>
  /// Use the default selection (PyInterpreterConfig_SHARED_GIL).
  /// Used in PyInterpreterConfig.gil
  /// </summary>
  PyInterpreterConfig_DEFAULT_GIL = 0;
  /// <summary>
  /// Use (share) the main interpreter's GIL.
  /// Used in PyInterpreterConfig.gil
  /// </summary>
  PyInterpreterConfig_SHARED_GIL  = 1;
  /// <summary>
  /// Use the sub-interpreter's own GIL.
  /// Used in PyInterpreterConfig.gil
  /// </summary>
  PyInterpreterConfig_OWN_GIL     = 2;

  {* include/ceval.h *}
  FVC_MASK      = $3;
  FVC_NONE      = $0;
  FVC_STR       = $1;
  FVC_REPR      = $2;
  FVC_ASCII     = $3;
  FVS_MASK      = $4;
  FVS_HAVE_SPEC = $4;

  {* include/sysmodule.h *}
  {* include/audit.h *}
  {* include/osmodule.h *}
  {* include/intrcheck.h *}
  {* include/import.h *}
  {* include/abstract.h *}
  {* include/bltinmodule.h *}
  {* include/cpython/pyctype.h *}
  {* include/pystrtod.h *}

  /// <summary>
  /// <para>Always precede the returned string with a sign character, even if
  /// val is non-negative.</para>
  /// </summary>
  Py_DTSF_SIGN      = $01;
  /// <summary>
  /// <para>Ensure that the returned string will not look like an
  /// integer.</para>
  /// </summary>
  Py_DTSF_ADD_DOT_0 = $02;
  /// <summary>
  /// <para>Apply "alternate" formatting rules. See the documentation for the
  /// TPyOS.snprintf() '#' specifier for details.</para>
  /// </summary>
  Py_DTSF_ALT       = $04;
  /// <summary>
  /// <para>Negative zero is converted to positive zero.
  /// Added in version 3.11.</para>
  /// </summary>
  Py_DTSF_NO_NEG_0  = $08;

  /// <summary>
  /// <para>finite number</para>
  /// </summary>
  Py_DTST_FINITE    = 0;
  /// <summary>
  /// <para>infinite number</para>
  /// </summary>
  Py_DTST_INFINITE  = 1;
  /// <summary>
  /// <para>not a number</para>
  /// </summary>
  Py_DTST_NAN       = 2;

  {* include/pystrcmp.h *}
  {* include/fileutils.h *}
  {* include/cpython/pyfpe.h *}
  {* include/cpython/tracemalloc.h *}
  {* include/frameobject.h  include/cpython/frameobject.h *}
  {* include/datetime.h *}

  /// <summary>
  /// # of bytes for year, month, and day.
  /// </summary>
  _PyDateTime_DATE_DATASIZE      = 4;
  /// <summary>
  ///  of bytes for hour, minute, second, and usecond.
  /// </summary>
  _PyDateTime_TIME_DATASIZE      = 6;
  /// <summary>
  /// # of bytes for year, month, day, hour, minute, second, and usecond.
  /// </summary>
  _PyDateTime_DATETIME_DATASIZE  = 10;

implementation

end.
