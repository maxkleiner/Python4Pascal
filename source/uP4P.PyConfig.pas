unit uP4P.PyConfig;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces;

type
  TPyConfig = class
    public
      class function Names: IPyObject;
      class function GetInt(const name_: string; var value: integer): boolean;
      class function GetBoolean(const name_: string; var value: boolean): boolean;
      class function Get(const name_: string): IPyObject;
      class function Set_(const name_: string; const value: IPyObject): boolean;
  end;

  TPyConfigBase = class(TInterfacedObject, IPyConfig)
    protected
      function GetConfig: Pointer; virtual;
      function Get_argv: string; virtual;
      function Get_base_exec_prefix: string; virtual;
      function Get_base_executable: string; virtual;
      function Get_base_prefix: string; virtual;
      function Get_buffered_stdio: boolean; virtual;
      function Get_bytes_warning: integer; virtual;
      function Get_check_hash_pycs_mode: string; virtual;
      function Get_code_debug_ranges: boolean; virtual;
      function Get_configure_c_stdio: boolean; virtual;
      function Get_context_aware_warnings: boolean; virtual;
      function Get_cpu_count: integer; virtual;
      function Get_dev_mode: boolean; virtual;
      function Get_dump_refs: boolean; virtual;
      function Get_dump_refs_file: string; virtual;
      function Get_exec_prefix: string; virtual;
      function Get_executable: string; virtual;
      function Get_faulthandler: integer; virtual;
      function Get_filesystem_encoding: string; virtual;
      function Get_filesystem_errors: string; virtual;
      function Get_hash_seed: uint64; virtual;
      function Get_home: string; virtual;
      function Get_import_time: integer; virtual;
      function Get_inspect: boolean; virtual;
      function Get_install_signal_handlers: boolean; virtual;
      function Get_int_max_str_digits: integer; virtual;
      function Get_interactive: boolean; virtual;
      function Get_isolated: boolean; virtual;
      function Get_legacy_windows_stdio: boolean; virtual;
      function Get_malloc_stats: boolean; virtual;
      function Get_module_search_paths: string; virtual;
      function Get_module_search_paths_set: boolean; virtual;
      function Get_optimization_level: TPyOptimizationLevel; virtual;
      function Get_orig_argv: string; virtual;
      function Get_parse_argv: boolean; virtual;
      function Get_parser_debug: boolean; virtual;
      function Get_pathconfig_warnings: boolean; virtual;
      function Get_perf_profiling: integer; virtual;
      function Get_platlibdir: string; virtual;
      function Get_prefix: string; virtual;
      function Get_program_name: string; virtual;
      function Get_pycache_prefix: string; virtual;
      function Get_pythonpath_env: string; virtual;
      function Get_quiet: boolean; virtual;
      function Get_remote_debug: integer; virtual;
      function Get_run_command: string; virtual;
      function Get_run_filename: string; virtual;
      function Get_run_module: string; virtual;
      function Get_safe_path: boolean; virtual;
      function Get_show_ref_count: boolean; virtual;
      function Get_site_import: boolean; virtual;
      function Get_skip_source_first_line: boolean; virtual;
      function Get_stdio_encoding: string; virtual;
      function Get_stdio_errors: string; virtual;
      function Get_stdlib_dir: string; virtual;
      function Get_sys_path_0: string; virtual;
      function Get_thread_inherit_context: boolean; virtual;
      function Get_tracemalloc: boolean; virtual;
      function Get_use_environment: boolean; virtual;
      function Get_use_frozen_modules: boolean; virtual;
      function Get_use_hash_seed: boolean; virtual;
      function Get_user_site_directory: boolean; virtual;
      function Get_verbose: TPyVerboseMode; virtual;
      function Get_warn_default_encoding: boolean; virtual;
      function Get_warnoptions: string; virtual;
      function Get_write_bytecode: boolean; virtual;
      function Get_xoptions: string; virtual;

      procedure Set_argv(const aValue: string); virtual;
      procedure Set_base_exec_prefix(const aValue: string); virtual;
      procedure Set_base_executable(const aValue: string); virtual;
      procedure Set_base_prefix(const aValue: string); virtual;
      procedure Set_buffered_stdio(aValue: boolean); virtual;
      procedure Set_bytes_warning(aValue: integer); virtual;
      procedure Set_check_hash_pycs_mode(const aValue: string); virtual;
      procedure Set_code_debug_ranges(aValue: boolean); virtual;
      procedure Set_configure_c_stdio(aValue: boolean); virtual;
      procedure Set_context_aware_warnings(aValue: boolean); virtual;
      procedure Set_cpu_count(aValue: integer); virtual;
      procedure Set_dev_mode(aValue: boolean); virtual;
      procedure Set_dump_refs(aValue: boolean); virtual;
      procedure Set_dump_refs_file(const aValue: string); virtual;
      procedure Set_exec_prefix(const aValue: string); virtual;
      procedure Set_executable(const aValue: string); virtual;
      procedure Set_faulthandler(aValue: integer); virtual;
      procedure Set_filesystem_encoding(const aValue: string); virtual;
      procedure Set_filesystem_errors(const aValue: string); virtual;
      procedure Set_hash_seed(aValue: uint64); virtual;
      procedure Set_home(const aValue: string); virtual;
      procedure Set_import_time(aValue: integer); virtual;
      procedure Set_inspect(aValue: boolean); virtual;
      procedure Set_install_signal_handlers(aValue: boolean); virtual;
      procedure Set_int_max_str_digits(aValue: integer); virtual;
      procedure Set_interactive(aValue: boolean); virtual;
      procedure Set_isolated(aValue: boolean); virtual;
      procedure Set_legacy_windows_stdio(aValue: boolean); virtual;
      procedure Set_malloc_stats(aValue: boolean); virtual;
      procedure Set_module_search_paths(const aValue: string); virtual;
      procedure Set_module_search_paths_set(aValue: boolean); virtual;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); virtual;
      procedure Set_orig_argv(const aValue: string); virtual;
      procedure Set_parse_argv(aValue: boolean); virtual;
      procedure Set_parser_debug(aValue: boolean); virtual;
      procedure Set_pathconfig_warnings(aValue: boolean); virtual;
      procedure Set_perf_profiling(aValue: integer); virtual;
      procedure Set_platlibdir(const aValue: string); virtual;
      procedure Set_prefix(const aValue: string); virtual;
      procedure Set_program_name(const aValue: string); virtual;
      procedure Set_pycache_prefix(const aValue: string); virtual;
      procedure Set_pythonpath_env(const aValue: string); virtual;
      procedure Set_quiet(aValue: boolean); virtual;
      procedure Set_remote_debug(aValue: integer); virtual;
      procedure Set_run_command(const aValue: string); virtual;
      procedure Set_run_filename(const aValue: string); virtual;
      procedure Set_run_module(const aValue: string); virtual;
      procedure Set_safe_path(aValue: boolean); virtual;
      procedure Set_show_ref_count(aValue: boolean); virtual;
      procedure Set_site_import(aValue: boolean); virtual;
      procedure Set_skip_source_first_line(aValue: boolean); virtual;
      procedure Set_stdio_encoding(const aValue: string); virtual;
      procedure Set_stdio_errors(const aValue: string); virtual;
      procedure Set_stdlib_dir(const aValue: string); virtual;
      procedure Set_sys_path_0(const aValue: string); virtual;
      procedure Set_thread_inherit_context(aValue: boolean); virtual;
      procedure Set_tracemalloc(aValue: boolean); virtual;
      procedure Set_use_environment(aValue: boolean); virtual;
      procedure Set_use_frozen_modules(aValue: boolean); virtual;
      procedure Set_use_hash_seed(aValue: boolean); virtual;
      procedure Set_user_site_directory(aValue: boolean); virtual;
      procedure Set_verbose(aValue: TPyVerboseMode); virtual;
      procedure Set_warn_default_encoding(aValue: boolean); virtual;
      procedure Set_warnoptions(const aValue: string); virtual;
      procedure Set_write_bytecode(aValue: boolean); virtual;
      procedure Set_xoptions(const aValue: string); virtual;

      function SetWCharT(var DstString: PWCharT; const SrcString: string): boolean;
      function SetString(var DstString: PWCharT; SrcString: WCharTString): IPyStatus;
      function SetBytesString(var DstString: PWCharT; SrcString: AnsiString): IPyStatus;
      function SetArgv(argc: integer; const argv: array of PWCharT): IPyStatus; overload;
      function SetArgv(const items: TStringList): boolean; overload;
      function SetBytesArgv(argc: integer; const argv: array of PAnsiChar): IPyStatus;
      function SetWideStringList(var list: PyWideStringList; length: integer; items: array of PWCharT): IPyStatus; overload;
      function SetWideStringList(var list: PyWideStringList; const items: TStringList): boolean; overload;

      property Config     : Pointer    read GetConfig;

    public
      destructor  Destroy; override;
      /// <summary>
      /// Initialize configuration with the "Python Configuration".
      /// </summary>
      procedure   InitPythonConfig;
      /// <summary>
      /// Initialize configuration with the "Isolated Configuration".
      /// </summary>
      procedure   InitIsolatedConfig;
      /// <summary>
      /// Read all Python configuration.
      /// </summary>
      function    Read: IPyStatus;
  end;

  TPyConfig314 = class(TPyConfigBase)
    private
      type PyConfig = record
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
        remote_debug             : integer;
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
        thread_inherit_context   : integer;
        context_aware_warnings   : integer;
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
    protected
      FConfig : PyConfig;
      function GetConfig: Pointer; override;
      function Get_argv: string; override;
      function Get_base_exec_prefix: string; override;
      function Get_base_executable: string; override;
      function Get_base_prefix: string; override;
      function Get_buffered_stdio: boolean; override;
      function Get_bytes_warning: integer; override;
      function Get_check_hash_pycs_mode: string; override;
      function Get_code_debug_ranges: boolean; override;
      function Get_configure_c_stdio: boolean; override;
      function Get_context_aware_warnings: boolean; override;
      function Get_cpu_count: integer; override;
      function Get_dev_mode: boolean; override;
      function Get_dump_refs: boolean; override;
      function Get_dump_refs_file: string; override;
      function Get_exec_prefix: string; override;
      function Get_executable: string; override;
      function Get_faulthandler: integer; override;
      function Get_filesystem_encoding: string; override;
      function Get_filesystem_errors: string; override;
      function Get_hash_seed: uint64; override;
      function Get_home: string; override;
      function Get_import_time: integer; override;
      function Get_inspect: boolean; override;
      function Get_install_signal_handlers: boolean; override;
      function Get_int_max_str_digits: integer; override;
      function Get_interactive: boolean; override;
      function Get_isolated: boolean; override;
      function Get_legacy_windows_stdio: boolean; override;
      function Get_malloc_stats: boolean; override;
      function Get_module_search_paths: string; override;
      function Get_module_search_paths_set: boolean; override;
      function Get_optimization_level: TPyOptimizationLevel; override;
      function Get_orig_argv: string; override;
      function Get_parse_argv: boolean; override;
      function Get_parser_debug: boolean; override;
      function Get_pathconfig_warnings: boolean; override;
      function Get_perf_profiling: integer; override;
      function Get_platlibdir: string; override;
      function Get_prefix: string; override;
      function Get_program_name: string; override;
      function Get_pycache_prefix: string; override;
      function Get_pythonpath_env: string; override;
      function Get_quiet: boolean; override;
      function Get_remote_debug: integer; override;
      function Get_run_command: string; override;
      function Get_run_filename: string; override;
      function Get_run_module: string; override;
      function Get_safe_path: boolean; override;
      function Get_show_ref_count: boolean; override;
      function Get_site_import: boolean; override;
      function Get_skip_source_first_line: boolean; override;
      function Get_stdio_encoding: string; override;
      function Get_stdio_errors: string; override;
      function Get_stdlib_dir: string; override;
      function Get_sys_path_0: string; override;
      function Get_thread_inherit_context: boolean; override;
      function Get_tracemalloc: boolean; override;
      function Get_use_environment: boolean; override;
      function Get_use_frozen_modules: boolean; override;
      function Get_use_hash_seed: boolean; override;
      function Get_user_site_directory: boolean; override;
      function Get_verbose: TPyVerboseMode; override;
      function Get_warn_default_encoding: boolean; override;
      function Get_warnoptions: string; override;
      function Get_write_bytecode: boolean; override;
      function Get_xoptions: string; override;

      procedure Set_argv(const aValue: string); override;
      procedure Set_base_exec_prefix(const aValue: string); override;
      procedure Set_base_executable(const aValue: string); override;
      procedure Set_base_prefix(const aValue: string); override;
      procedure Set_buffered_stdio(aValue: boolean); override;
      procedure Set_bytes_warning(aValue: integer); override;
      procedure Set_check_hash_pycs_mode(const aValue: string); override;
      procedure Set_code_debug_ranges(aValue: boolean); override;
      procedure Set_configure_c_stdio(aValue: boolean); override;
      procedure Set_context_aware_warnings(aValue: boolean); override;
      procedure Set_cpu_count(aValue: integer); override;
      procedure Set_dev_mode(aValue: boolean); override;
      procedure Set_dump_refs(aValue: boolean); override;
      procedure Set_dump_refs_file(const aValue: string); override;
      procedure Set_exec_prefix(const aValue: string); override;
      procedure Set_executable(const aValue: string); override;
      procedure Set_faulthandler(aValue: integer); override;
      procedure Set_filesystem_encoding(const aValue: string); override;
      procedure Set_filesystem_errors(const aValue: string); override;
      procedure Set_hash_seed(aValue: uint64); override;
      procedure Set_home(const aValue: string); override;
      procedure Set_import_time(aValue: integer); override;
      procedure Set_inspect(aValue: boolean); override;
      procedure Set_install_signal_handlers(aValue: boolean); override;
      procedure Set_int_max_str_digits(aValue: integer); override;
      procedure Set_interactive(aValue: boolean); override;
      procedure Set_isolated(aValue: boolean); override;
      procedure Set_legacy_windows_stdio(aValue: boolean); override;
      procedure Set_malloc_stats(aValue: boolean); override;
      procedure Set_module_search_paths(const aValue: string); override;
      procedure Set_module_search_paths_set(aValue: boolean); override;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); override;
      procedure Set_orig_argv(const aValue: string); override;
      procedure Set_parse_argv(aValue: boolean); override;
      procedure Set_parser_debug(aValue: boolean); override;
      procedure Set_pathconfig_warnings(aValue: boolean); override;
      procedure Set_perf_profiling(aValue: integer); override;
      procedure Set_platlibdir(const aValue: string); override;
      procedure Set_prefix(const aValue: string); override;
      procedure Set_program_name(const aValue: string); override;
      procedure Set_pycache_prefix(const aValue: string); override;
      procedure Set_pythonpath_env(const aValue: string); override;
      procedure Set_quiet(aValue: boolean); override;
      procedure Set_remote_debug(aValue: integer); override;
      procedure Set_run_command(const aValue: string); override;
      procedure Set_run_filename(const aValue: string); override;
      procedure Set_run_module(const aValue: string); override;
      procedure Set_safe_path(aValue: boolean); override;
      procedure Set_show_ref_count(aValue: boolean); override;
      procedure Set_site_import(aValue: boolean); override;
      procedure Set_skip_source_first_line(aValue: boolean); override;
      procedure Set_stdio_encoding(const aValue: string); override;
      procedure Set_stdio_errors(const aValue: string); override;
      procedure Set_stdlib_dir(const aValue: string); override;
      procedure Set_sys_path_0(const aValue: string); override;
      procedure Set_thread_inherit_context(aValue: boolean); override;
      procedure Set_tracemalloc(aValue: boolean); override;
      procedure Set_use_environment(aValue: boolean); override;
      procedure Set_use_frozen_modules(aValue: boolean); override;
      procedure Set_use_hash_seed(aValue: boolean); override;
      procedure Set_user_site_directory(aValue: boolean); override;
      procedure Set_verbose(aValue: TPyVerboseMode); override;
      procedure Set_warn_default_encoding(aValue: boolean); override;
      procedure Set_warnoptions(const aValue: string); override;
      procedure Set_write_bytecode(aValue: boolean); override;
      procedure Set_xoptions(const aValue: string); override;
  end;

  TPyConfig313 = class(TPyConfigBase)
    private
      type PyConfig = record
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
    protected
      FConfig : PyConfig;
      function GetConfig: Pointer; override;
      function Get_argv: string; override;
      function Get_base_exec_prefix: string; override;
      function Get_base_executable: string; override;
      function Get_base_prefix: string; override;
      function Get_buffered_stdio: boolean; override;
      function Get_bytes_warning: integer; override;
      function Get_check_hash_pycs_mode: string; override;
      function Get_code_debug_ranges: boolean; override;
      function Get_configure_c_stdio: boolean; override;
      function Get_cpu_count: integer; override;
      function Get_dev_mode: boolean; override;
      function Get_dump_refs: boolean; override;
      function Get_dump_refs_file: string; override;
      function Get_exec_prefix: string; override;
      function Get_executable: string; override;
      function Get_faulthandler: integer; override;
      function Get_filesystem_encoding: string; override;
      function Get_filesystem_errors: string; override;
      function Get_hash_seed: uint64; override;
      function Get_home: string; override;
      function Get_import_time: integer; override;
      function Get_inspect: boolean; override;
      function Get_install_signal_handlers: boolean; override;
      function Get_int_max_str_digits: integer; override;
      function Get_interactive: boolean; override;
      function Get_isolated: boolean; override;
      function Get_legacy_windows_stdio: boolean; override;
      function Get_malloc_stats: boolean; override;
      function Get_module_search_paths: string; override;
      function Get_module_search_paths_set: boolean; override;
      function Get_optimization_level: TPyOptimizationLevel; override;
      function Get_orig_argv: string; override;
      function Get_parse_argv: boolean; override;
      function Get_parser_debug: boolean; override;
      function Get_pathconfig_warnings: boolean; override;
      function Get_perf_profiling: integer; override;
      function Get_platlibdir: string; override;
      function Get_prefix: string; override;
      function Get_program_name: string; override;
      function Get_pycache_prefix: string; override;
      function Get_pythonpath_env: string; override;
      function Get_quiet: boolean; override;
      function Get_run_command: string; override;
      function Get_run_filename: string; override;
      function Get_run_module: string; override;
      function Get_safe_path: boolean; override;
      function Get_show_ref_count: boolean; override;
      function Get_site_import: boolean; override;
      function Get_skip_source_first_line: boolean; override;
      function Get_stdio_encoding: string; override;
      function Get_stdio_errors: string; override;
      function Get_stdlib_dir: string; override;
      function Get_sys_path_0: string; override;
      function Get_tracemalloc: boolean; override;
      function Get_use_environment: boolean; override;
      function Get_use_frozen_modules: boolean; override;
      function Get_use_hash_seed: boolean; override;
      function Get_user_site_directory: boolean; override;
      function Get_verbose: TPyVerboseMode; override;
      function Get_warn_default_encoding: boolean; override;
      function Get_warnoptions: string; override;
      function Get_write_bytecode: boolean; override;
      function Get_xoptions: string; override;

      procedure Set_argv(const aValue: string); override;
      procedure Set_base_exec_prefix(const aValue: string); override;
      procedure Set_base_executable(const aValue: string); override;
      procedure Set_base_prefix(const aValue: string); override;
      procedure Set_buffered_stdio(aValue: boolean); override;
      procedure Set_bytes_warning(aValue: integer); override;
      procedure Set_check_hash_pycs_mode(const aValue: string); override;
      procedure Set_code_debug_ranges(aValue: boolean); override;
      procedure Set_configure_c_stdio(aValue: boolean); override;
      procedure Set_cpu_count(aValue: integer); override;
      procedure Set_dev_mode(aValue: boolean); override;
      procedure Set_dump_refs(aValue: boolean); override;
      procedure Set_dump_refs_file(const aValue: string); override;
      procedure Set_exec_prefix(const aValue: string); override;
      procedure Set_executable(const aValue: string); override;
      procedure Set_faulthandler(aValue: integer); override;
      procedure Set_filesystem_encoding(const aValue: string); override;
      procedure Set_filesystem_errors(const aValue: string); override;
      procedure Set_hash_seed(aValue: uint64); override;
      procedure Set_home(const aValue: string); override;
      procedure Set_import_time(aValue: integer); override;
      procedure Set_inspect(aValue: boolean); override;
      procedure Set_install_signal_handlers(aValue: boolean); override;
      procedure Set_int_max_str_digits(aValue: integer); override;
      procedure Set_interactive(aValue: boolean); override;
      procedure Set_isolated(aValue: boolean); override;
      procedure Set_legacy_windows_stdio(aValue: boolean); override;
      procedure Set_malloc_stats(aValue: boolean); override;
      procedure Set_module_search_paths(const aValue: string); override;
      procedure Set_module_search_paths_set(aValue: boolean); override;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); override;
      procedure Set_orig_argv(const aValue: string); override;
      procedure Set_parse_argv(aValue: boolean); override;
      procedure Set_parser_debug(aValue: boolean); override;
      procedure Set_pathconfig_warnings(aValue: boolean); override;
      procedure Set_perf_profiling(aValue: integer); override;
      procedure Set_platlibdir(const aValue: string); override;
      procedure Set_prefix(const aValue: string); override;
      procedure Set_program_name(const aValue: string); override;
      procedure Set_pycache_prefix(const aValue: string); override;
      procedure Set_pythonpath_env(const aValue: string); override;
      procedure Set_quiet(aValue: boolean); override;
      procedure Set_run_command(const aValue: string); override;
      procedure Set_run_filename(const aValue: string); override;
      procedure Set_run_module(const aValue: string); override;
      procedure Set_safe_path(aValue: boolean); override;
      procedure Set_show_ref_count(aValue: boolean); override;
      procedure Set_site_import(aValue: boolean); override;
      procedure Set_skip_source_first_line(aValue: boolean); override;
      procedure Set_stdio_encoding(const aValue: string); override;
      procedure Set_stdio_errors(const aValue: string); override;
      procedure Set_stdlib_dir(const aValue: string); override;
      procedure Set_sys_path_0(const aValue: string); override;
      procedure Set_tracemalloc(aValue: boolean); override;
      procedure Set_use_environment(aValue: boolean); override;
      procedure Set_use_frozen_modules(aValue: boolean); override;
      procedure Set_use_hash_seed(aValue: boolean); override;
      procedure Set_user_site_directory(aValue: boolean); override;
      procedure Set_verbose(aValue: TPyVerboseMode); override;
      procedure Set_warn_default_encoding(aValue: boolean); override;
      procedure Set_warnoptions(const aValue: string); override;
      procedure Set_write_bytecode(aValue: boolean); override;
      procedure Set_xoptions(const aValue: string); override;
  end;

  TPyConfig312 = class(TPyConfigBase)
    private
      type PyConfig = record
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
    protected
      FConfig : PyConfig;
      function GetConfig: Pointer; override;
      function Get_argv: string; override;
      function Get_base_exec_prefix: string; override;
      function Get_base_executable: string; override;
      function Get_base_prefix: string; override;
      function Get_buffered_stdio: boolean; override;
      function Get_bytes_warning: integer; override;
      function Get_check_hash_pycs_mode: string; override;
      function Get_code_debug_ranges: boolean; override;
      function Get_configure_c_stdio: boolean; override;
      function Get_dev_mode: boolean; override;
      function Get_dump_refs: boolean; override;
      function Get_dump_refs_file: string; override;
      function Get_exec_prefix: string; override;
      function Get_executable: string; override;
      function Get_faulthandler: integer; override;
      function Get_filesystem_encoding: string; override;
      function Get_filesystem_errors: string; override;
      function Get_hash_seed: uint64; override;
      function Get_home: string; override;
      function Get_import_time: integer; override;
      function Get_inspect: boolean; override;
      function Get_install_signal_handlers: boolean; override;
      function Get_int_max_str_digits: integer; override;
      function Get_interactive: boolean; override;
      function Get_isolated: boolean; override;
      function Get_legacy_windows_stdio: boolean; override;
      function Get_malloc_stats: boolean; override;
      function Get_module_search_paths: string; override;
      function Get_module_search_paths_set: boolean; override;
      function Get_optimization_level: TPyOptimizationLevel; override;
      function Get_orig_argv: string; override;
      function Get_parse_argv: boolean; override;
      function Get_parser_debug: boolean; override;
      function Get_pathconfig_warnings: boolean; override;
      function Get_perf_profiling: integer; override;
      function Get_platlibdir: string; override;
      function Get_prefix: string; override;
      function Get_program_name: string; override;
      function Get_pycache_prefix: string; override;
      function Get_pythonpath_env: string; override;
      function Get_quiet: boolean; override;
      function Get_run_command: string; override;
      function Get_run_filename: string; override;
      function Get_run_module: string; override;
      function Get_safe_path: boolean; override;
      function Get_show_ref_count: boolean; override;
      function Get_site_import: boolean; override;
      function Get_skip_source_first_line: boolean; override;
      function Get_stdio_encoding: string; override;
      function Get_stdio_errors: string; override;
      function Get_stdlib_dir: string; override;
      function Get_tracemalloc: boolean; override;
      function Get_use_environment: boolean; override;
      function Get_use_frozen_modules: boolean; override;
      function Get_use_hash_seed: boolean; override;
      function Get_user_site_directory: boolean; override;
      function Get_verbose: TPyVerboseMode; override;
      function Get_warn_default_encoding: boolean; override;
      function Get_warnoptions: string; override;
      function Get_write_bytecode: boolean; override;
      function Get_xoptions: string; override;

      procedure Set_argv(const aValue: string); override;
      procedure Set_base_exec_prefix(const aValue: string); override;
      procedure Set_base_executable(const aValue: string); override;
      procedure Set_base_prefix(const aValue: string); override;
      procedure Set_buffered_stdio(aValue: boolean); override;
      procedure Set_bytes_warning(aValue: integer); override;
      procedure Set_check_hash_pycs_mode(const aValue: string); override;
      procedure Set_code_debug_ranges(aValue: boolean); override;
      procedure Set_configure_c_stdio(aValue: boolean); override;
      procedure Set_dev_mode(aValue: boolean); override;
      procedure Set_dump_refs(aValue: boolean); override;
      procedure Set_dump_refs_file(const aValue: string); override;
      procedure Set_exec_prefix(const aValue: string); override;
      procedure Set_executable(const aValue: string); override;
      procedure Set_faulthandler(aValue: integer); override;
      procedure Set_filesystem_encoding(const aValue: string); override;
      procedure Set_filesystem_errors(const aValue: string); override;
      procedure Set_hash_seed(aValue: uint64); override;
      procedure Set_home(const aValue: string); override;
      procedure Set_import_time(aValue: integer); override;
      procedure Set_inspect(aValue: boolean); override;
      procedure Set_install_signal_handlers(aValue: boolean); override;
      procedure Set_int_max_str_digits(aValue: integer); override;
      procedure Set_interactive(aValue: boolean); override;
      procedure Set_isolated(aValue: boolean); override;
      procedure Set_legacy_windows_stdio(aValue: boolean); override;
      procedure Set_malloc_stats(aValue: boolean); override;
      procedure Set_module_search_paths(const aValue: string); override;
      procedure Set_module_search_paths_set(aValue: boolean); override;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); override;
      procedure Set_orig_argv(const aValue: string); override;
      procedure Set_parse_argv(aValue: boolean); override;
      procedure Set_parser_debug(aValue: boolean); override;
      procedure Set_pathconfig_warnings(aValue: boolean); override;
      procedure Set_perf_profiling(aValue: integer); override;
      procedure Set_platlibdir(const aValue: string); override;
      procedure Set_prefix(const aValue: string); override;
      procedure Set_program_name(const aValue: string); override;
      procedure Set_pycache_prefix(const aValue: string); override;
      procedure Set_pythonpath_env(const aValue: string); override;
      procedure Set_quiet(aValue: boolean); override;
      procedure Set_run_command(const aValue: string); override;
      procedure Set_run_filename(const aValue: string); override;
      procedure Set_run_module(const aValue: string); override;
      procedure Set_safe_path(aValue: boolean); override;
      procedure Set_show_ref_count(aValue: boolean); override;
      procedure Set_site_import(aValue: boolean); override;
      procedure Set_skip_source_first_line(aValue: boolean); override;
      procedure Set_stdio_encoding(const aValue: string); override;
      procedure Set_stdio_errors(const aValue: string); override;
      procedure Set_stdlib_dir(const aValue: string); override;
      procedure Set_tracemalloc(aValue: boolean); override;
      procedure Set_use_environment(aValue: boolean); override;
      procedure Set_use_frozen_modules(aValue: boolean); override;
      procedure Set_use_hash_seed(aValue: boolean); override;
      procedure Set_user_site_directory(aValue: boolean); override;
      procedure Set_verbose(aValue: TPyVerboseMode); override;
      procedure Set_warn_default_encoding(aValue: boolean); override;
      procedure Set_warnoptions(const aValue: string); override;
      procedure Set_write_bytecode(aValue: boolean); override;
      procedure Set_xoptions(const aValue: string); override;
  end;

  TPyConfig311 = class(TPyConfigBase)
    private
      type PyConfig = record
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
    protected
      FConfig : PyConfig;
      function GetConfig: Pointer; override;
      function Get_argv: string; override;
      function Get_base_exec_prefix: string; override;
      function Get_base_executable: string; override;
      function Get_base_prefix: string; override;
      function Get_buffered_stdio: boolean; override;
      function Get_bytes_warning: integer; override;
      function Get_check_hash_pycs_mode: string; override;
      function Get_code_debug_ranges: boolean; override;
      function Get_configure_c_stdio: boolean; override;
      function Get_dev_mode: boolean; override;
      function Get_dump_refs: boolean; override;
      function Get_dump_refs_file: string; override;
      function Get_exec_prefix: string; override;
      function Get_executable: string; override;
      function Get_faulthandler: integer; override;
      function Get_filesystem_encoding: string; override;
      function Get_filesystem_errors: string; override;
      function Get_hash_seed: uint64; override;
      function Get_home: string; override;
      function Get_import_time: integer; override;
      function Get_inspect: boolean; override;
      function Get_install_signal_handlers: boolean; override;
      function Get_interactive: boolean; override;
      function Get_isolated: boolean; override;
      function Get_legacy_windows_stdio: boolean; override;
      function Get_malloc_stats: boolean; override;
      function Get_module_search_paths: string; override;
      function Get_module_search_paths_set: boolean; override;
      function Get_optimization_level: TPyOptimizationLevel; override;
      function Get_orig_argv: string; override;
      function Get_parse_argv: boolean; override;
      function Get_parser_debug: boolean; override;
      function Get_pathconfig_warnings: boolean; override;
      function Get_platlibdir: string; override;
      function Get_prefix: string; override;
      function Get_program_name: string; override;
      function Get_pycache_prefix: string; override;
      function Get_pythonpath_env: string; override;
      function Get_quiet: boolean; override;
      function Get_run_command: string; override;
      function Get_run_filename: string; override;
      function Get_run_module: string; override;
      function Get_safe_path: boolean; override;
      function Get_show_ref_count: boolean; override;
      function Get_site_import: boolean; override;
      function Get_skip_source_first_line: boolean; override;
      function Get_stdio_encoding: string; override;
      function Get_stdio_errors: string; override;
      function Get_stdlib_dir: string; override;
      function Get_tracemalloc: boolean; override;
      function Get_use_environment: boolean; override;
      function Get_use_frozen_modules: boolean; override;
      function Get_use_hash_seed: boolean; override;
      function Get_user_site_directory: boolean; override;
      function Get_verbose: TPyVerboseMode; override;
      function Get_warn_default_encoding: boolean; override;
      function Get_warnoptions: string; override;
      function Get_write_bytecode: boolean; override;
      function Get_xoptions: string; override;

      procedure Set_argv(const aValue: string); override;
      procedure Set_base_exec_prefix(const aValue: string); override;
      procedure Set_base_executable(const aValue: string); override;
      procedure Set_base_prefix(const aValue: string); override;
      procedure Set_buffered_stdio(aValue: boolean); override;
      procedure Set_bytes_warning(aValue: integer); override;
      procedure Set_check_hash_pycs_mode(const aValue: string); override;
      procedure Set_code_debug_ranges(aValue: boolean); override;
      procedure Set_configure_c_stdio(aValue: boolean); override;
      procedure Set_dev_mode(aValue: boolean); override;
      procedure Set_dump_refs(aValue: boolean); override;
      procedure Set_dump_refs_file(const aValue: string); override;
      procedure Set_exec_prefix(const aValue: string); override;
      procedure Set_executable(const aValue: string); override;
      procedure Set_faulthandler(aValue: integer); override;
      procedure Set_filesystem_encoding(const aValue: string); override;
      procedure Set_filesystem_errors(const aValue: string); override;
      procedure Set_hash_seed(aValue: uint64); override;
      procedure Set_home(const aValue: string); override;
      procedure Set_import_time(aValue: integer); override;
      procedure Set_inspect(aValue: boolean); override;
      procedure Set_install_signal_handlers(aValue: boolean); override;
      procedure Set_interactive(aValue: boolean); override;
      procedure Set_isolated(aValue: boolean); override;
      procedure Set_legacy_windows_stdio(aValue: boolean); override;
      procedure Set_malloc_stats(aValue: boolean); override;
      procedure Set_module_search_paths(const aValue: string); override;
      procedure Set_module_search_paths_set(aValue: boolean); override;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); override;
      procedure Set_orig_argv(const aValue: string); override;
      procedure Set_parse_argv(aValue: boolean); override;
      procedure Set_parser_debug(aValue: boolean); override;
      procedure Set_pathconfig_warnings(aValue: boolean); override;
      procedure Set_platlibdir(const aValue: string); override;
      procedure Set_prefix(const aValue: string); override;
      procedure Set_program_name(const aValue: string); override;
      procedure Set_pycache_prefix(const aValue: string); override;
      procedure Set_pythonpath_env(const aValue: string); override;
      procedure Set_quiet(aValue: boolean); override;
      procedure Set_run_command(const aValue: string); override;
      procedure Set_run_filename(const aValue: string); override;
      procedure Set_run_module(const aValue: string); override;
      procedure Set_safe_path(aValue: boolean); override;
      procedure Set_show_ref_count(aValue: boolean); override;
      procedure Set_site_import(aValue: boolean); override;
      procedure Set_skip_source_first_line(aValue: boolean); override;
      procedure Set_stdio_encoding(const aValue: string); override;
      procedure Set_stdio_errors(const aValue: string); override;
      procedure Set_stdlib_dir(const aValue: string); override;
      procedure Set_tracemalloc(aValue: boolean); override;
      procedure Set_use_environment(aValue: boolean); override;
      procedure Set_use_frozen_modules(aValue: boolean); override;
      procedure Set_use_hash_seed(aValue: boolean); override;
      procedure Set_user_site_directory(aValue: boolean); override;
      procedure Set_verbose(aValue: TPyVerboseMode); override;
      procedure Set_warn_default_encoding(aValue: boolean); override;
      procedure Set_warnoptions(const aValue: string); override;
      procedure Set_write_bytecode(aValue: boolean); override;
      procedure Set_xoptions(const aValue: string); override;
  end;

  TPyConfig310 = class(TPyConfigBase)
    private
      type PyConfig = record
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
    protected
      FConfig : PyConfig;
      function GetConfig: Pointer; override;
      function Get_argv: string; override;
      function Get_base_exec_prefix: string; override;
      function Get_base_executable: string; override;
      function Get_base_prefix: string; override;
      function Get_buffered_stdio: boolean; override;
      function Get_bytes_warning: integer; override;
      function Get_check_hash_pycs_mode: string; override;
      function Get_configure_c_stdio: boolean; override;
      function Get_dev_mode: boolean; override;
      function Get_dump_refs: boolean; override;
      function Get_exec_prefix: string; override;
      function Get_executable: string; override;
      function Get_faulthandler: integer; override;
      function Get_filesystem_encoding: string; override;
      function Get_filesystem_errors: string; override;
      function Get_hash_seed: uint64; override;
      function Get_home: string; override;
      function Get_import_time: integer; override;
      function Get_inspect: boolean; override;
      function Get_install_signal_handlers: boolean; override;
      function Get_interactive: boolean; override;
      function Get_isolated: boolean; override;
      function Get_legacy_windows_stdio: boolean; override;
      function Get_malloc_stats: boolean; override;
      function Get_module_search_paths: string; override;
      function Get_module_search_paths_set: boolean; override;
      function Get_optimization_level: TPyOptimizationLevel; override;
      function Get_orig_argv: string; override;
      function Get_parse_argv: boolean; override;
      function Get_parser_debug: boolean; override;
      function Get_pathconfig_warnings: boolean; override;
      function Get_platlibdir: string; override;
      function Get_prefix: string; override;
      function Get_program_name: string; override;
      function Get_pycache_prefix: string; override;
      function Get_pythonpath_env: string; override;
      function Get_quiet: boolean; override;
      function Get_run_command: string; override;
      function Get_run_filename: string; override;
      function Get_run_module: string; override;
      function Get_show_ref_count: boolean; override;
      function Get_site_import: boolean; override;
      function Get_skip_source_first_line: boolean; override;
      function Get_stdio_encoding: string; override;
      function Get_stdio_errors: string; override;
      function Get_tracemalloc: boolean; override;
      function Get_use_environment: boolean; override;
      function Get_use_hash_seed: boolean; override;
      function Get_user_site_directory: boolean; override;
      function Get_verbose: TPyVerboseMode; override;
      function Get_warn_default_encoding: boolean; override;
      function Get_warnoptions: string; override;
      function Get_write_bytecode: boolean; override;
      function Get_xoptions: string; override;

      procedure Set_argv(const aValue: string); override;
      procedure Set_base_exec_prefix(const aValue: string); override;
      procedure Set_base_executable(const aValue: string); override;
      procedure Set_base_prefix(const aValue: string); override;
      procedure Set_buffered_stdio(aValue: boolean); override;
      procedure Set_bytes_warning(aValue: integer); override;
      procedure Set_check_hash_pycs_mode(const aValue: string); override;
      procedure Set_configure_c_stdio(aValue: boolean); override;
      procedure Set_dev_mode(aValue: boolean); override;
      procedure Set_dump_refs(aValue: boolean); override;
      procedure Set_exec_prefix(const aValue: string); override;
      procedure Set_executable(const aValue: string); override;
      procedure Set_faulthandler(aValue: integer); override;
      procedure Set_filesystem_encoding(const aValue: string); override;
      procedure Set_filesystem_errors(const aValue: string); override;
      procedure Set_hash_seed(aValue: uint64); override;
      procedure Set_home(const aValue: string); override;
      procedure Set_import_time(aValue: integer); override;
      procedure Set_inspect(aValue: boolean); override;
      procedure Set_install_signal_handlers(aValue: boolean); override;
      procedure Set_interactive(aValue: boolean); override;
      procedure Set_isolated(aValue: boolean); override;
      procedure Set_legacy_windows_stdio(aValue: boolean); override;
      procedure Set_malloc_stats(aValue: boolean); override;
      procedure Set_module_search_paths(const aValue: string); override;
      procedure Set_module_search_paths_set(aValue: boolean); override;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); override;
      procedure Set_orig_argv(const aValue: string); override;
      procedure Set_parse_argv(aValue: boolean); override;
      procedure Set_parser_debug(aValue: boolean); override;
      procedure Set_pathconfig_warnings(aValue: boolean); override;
      procedure Set_platlibdir(const aValue: string); override;
      procedure Set_prefix(const aValue: string); override;
      procedure Set_program_name(const aValue: string); override;
      procedure Set_pycache_prefix(const aValue: string); override;
      procedure Set_pythonpath_env(const aValue: string); override;
      procedure Set_quiet(aValue: boolean); override;
      procedure Set_run_command(const aValue: string); override;
      procedure Set_run_filename(const aValue: string); override;
      procedure Set_run_module(const aValue: string); override;
      procedure Set_show_ref_count(aValue: boolean); override;
      procedure Set_site_import(aValue: boolean); override;
      procedure Set_skip_source_first_line(aValue: boolean); override;
      procedure Set_stdio_encoding(const aValue: string); override;
      procedure Set_stdio_errors(const aValue: string); override;
      procedure Set_tracemalloc(aValue: boolean); override;
      procedure Set_use_environment(aValue: boolean); override;
      procedure Set_use_hash_seed(aValue: boolean); override;
      procedure Set_user_site_directory(aValue: boolean); override;
      procedure Set_verbose(aValue: TPyVerboseMode); override;
      procedure Set_warn_default_encoding(aValue: boolean); override;
      procedure Set_warnoptions(const aValue: string); override;
      procedure Set_write_bytecode(aValue: boolean); override;
      procedure Set_xoptions(const aValue: string); override;
  end;

  TPyConfigBuilder = class
    public
      class function New(aMajor, aMinor: integer): IPyConfig;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyObject, uP4P.PyStatus;

{$REGION 'TPyConfig'}
class function TPyConfig.Names: IPyObject;
begin
  if assigned(PyConfig_Names) then
    Result := TPyObject.Wrap(PyConfig_Names())
   else
    Result := nil;
end;

class function TPyConfig.GetInt(const name_: string; var value: integer): boolean;
var
  TempName : AnsiString;
begin
  Result := False;

  if assigned(PyConfig_GetInt) and
     (length(name_) > 0) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyConfig_GetInt(PAnsiChar(TempName), value) = 0);
    end;
end;

class function TPyConfig.GetBoolean(const name_: string; var value: boolean): boolean;
var
  TempValue: integer;
begin
  Result := False;

  if GetInt(name_, TempValue) then
    begin
      value  := (TempValue <> 0);
      Result := True;
    end;
end;

class function TPyConfig.Get(const name_: string): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PyConfig_Get) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PyConfig_Get(PAnsiChar(TempName)));
    end
   else
    Result := nil;
end;

class function TPyConfig.Set_(const name_: string; const value: IPyObject): boolean;
var
  TempName : AnsiString;
begin
  if assigned(PyConfig_Set) and
     TPyObject.IsInitialized(value) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyConfig_Set(PAnsiChar(TempName), value.PyObject) = 0);
    end
   else
    Result := False;
end;
{$ENDREGION}

{$REGION 'TPyConfigBase'}
destructor TPyConfigBase.Destroy;
begin
  if assigned(PyConfig_Clear) then
    PyConfig_Clear(Config);

  inherited Destroy;
end;

procedure TPyConfigBase.InitPythonConfig;
begin
  if assigned(PyConfig_InitPythonConfig) then
    PyConfig_InitPythonConfig(Config);
end;

procedure TPyConfigBase.InitIsolatedConfig;
begin
  if assigned(PyConfig_InitIsolatedConfig) then
    PyConfig_InitIsolatedConfig(Config);
end;

function TPyConfigBase.Read: IPyStatus;
begin
  if assigned(PyConfig_Read) then
    Result := TPyStatus.Create(PyConfig_Read(Config))
   else
    Result := nil;
end;

function TPyConfigBase.GetConfig: Pointer;
begin
  Result := nil;
end;

function TPyConfigBase.Get_argv: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_base_exec_prefix: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_base_executable: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_base_prefix: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_buffered_stdio: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_bytes_warning: integer;
begin
  Result := 0;
end;

function TPyConfigBase.Get_check_hash_pycs_mode: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_code_debug_ranges: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_configure_c_stdio: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_context_aware_warnings: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_cpu_count: integer;
begin
  Result := 0;
end;

function TPyConfigBase.Get_dev_mode: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_dump_refs: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_dump_refs_file: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_exec_prefix: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_executable: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_faulthandler: integer;
begin
  Result := 0;
end;

function TPyConfigBase.Get_filesystem_encoding: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_filesystem_errors: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_hash_seed: uint64;
begin
  Result := 0;
end;

function TPyConfigBase.Get_home: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_import_time: integer;
begin
  Result := 0;
end;

function TPyConfigBase.Get_inspect: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_install_signal_handlers: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_int_max_str_digits: integer;
begin
  Result := 0;
end;

function TPyConfigBase.Get_interactive: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_isolated: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_legacy_windows_stdio: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_malloc_stats: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_module_search_paths: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_module_search_paths_set: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := polDebug;
end;

function TPyConfigBase.Get_orig_argv: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_parse_argv: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_parser_debug: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_pathconfig_warnings: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_perf_profiling: integer;
begin
  Result := 0;
end;

function TPyConfigBase.Get_platlibdir: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_prefix: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_program_name: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_pycache_prefix: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_pythonpath_env: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_quiet: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_remote_debug: integer;
begin
  Result := 0;
end;

function TPyConfigBase.Get_run_command: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_run_filename: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_run_module: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_safe_path: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_show_ref_count: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_site_import: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_skip_source_first_line: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_stdio_encoding: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_stdio_errors: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_stdlib_dir: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_sys_path_0: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_thread_inherit_context: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_tracemalloc: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_use_environment: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_use_frozen_modules: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_use_hash_seed: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_user_site_directory: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_verbose: TPyVerboseMode;
begin
  Result := pvmDisabled;
end;

function TPyConfigBase.Get_warn_default_encoding: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_warnoptions: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_write_bytecode: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_xoptions: string;
begin
  Result := '';
end;

function TPyConfigBase.SetWCharT(var DstString: PWCharT; const SrcString: string): boolean;
var
  TempStatus : IPyStatus;
begin
  TempStatus := SetString(DstString, StringToPyWCharTString(SrcString));
  Result     := assigned(TempStatus) and not(TempStatus.IsException);
end;

function TPyConfigBase.SetString(var DstString: PWCharT; SrcString: WCharTString): IPyStatus;
begin
  if assigned(PyConfig_SetString) then
    Result := TPyStatus.Create(PyConfig_SetString(Config, DstString, PWCharT(SrcString)))
   else
    Result := nil;
end;

function TPyConfigBase.SetBytesString(var DstString: PWCharT; SrcString: AnsiString): IPyStatus;
begin
  if assigned(PyConfig_SetBytesString) then
    Result := TPyStatus.Create(PyConfig_SetBytesString(Config, DstString, PAnsiChar(SrcString)))
   else
    Result := nil;
end;

function TPyConfigBase.SetArgv(argc: integer; const argv: array of PWCharT): IPyStatus;
begin
  if assigned(PyConfig_SetArgv) then
    begin
      if (argc > 0) then
        Result := TPyStatus.Create(PyConfig_SetArgv(Config, argc, @argv[0]))
       else
        Result := TPyStatus.Create(PyConfig_SetArgv(Config, 0, nil));
    end
   else
    Result := nil;
end;

function TPyConfigBase.SetArgv(const items: TStringList): boolean;
var
  TempStatus : IPyStatus;
  TempItems : array of WCharTString;
  TempItemsPtr : array of PWCharT;
  i : integer;
begin
  Result := False;
  if not(assigned(items)) then exit;

  if (items.count > 0) then
    begin
      SetLength(TempItems,    items.count);
      SetLength(TempItemsPtr, items.count);

      for i := 0 to pred(items.count) do
        begin
          TempItems[i]    := StringToPyWCharTString(items[i]);
          TempItemsPtr[i] := PWCharT(TempItems[i]);
        end;
    end;

  TempStatus := SetArgv(items.count, TempItemsPtr);
  Result     := assigned(TempStatus) and not(TempStatus.IsException);
end;

function TPyConfigBase.SetBytesArgv(argc: integer; const argv: array of PAnsiChar): IPyStatus;
begin
  if assigned(PyConfig_SetBytesArgv) then
    begin
      if (argc > 0) then
        Result := TPyStatus.Create(PyConfig_SetBytesArgv(Config, argc, @argv[0]))
       else
        Result := TPyStatus.Create(PyConfig_SetBytesArgv(Config, 0, nil));
    end
   else
    Result := nil;
end;

function TPyConfigBase.SetWideStringList(var list: PyWideStringList; length: integer; items: array of PWCharT): IPyStatus;
begin
  if assigned(PyConfig_SetWideStringList) then
    begin
      if (length > 0) then
        Result := TPyStatus.Create(PyConfig_SetWideStringList(Config, @list, length, @items[0]))
       else
        Result := TPyStatus.Create(PyConfig_SetWideStringList(Config, @list, 0, nil));
    end
   else
    Result := nil;
end;

function TPyConfigBase.SetWideStringList(var list: PyWideStringList; const items: TStringList): boolean;
var
  TempStatus : IPyStatus;
  TempItems : array of WCharTString;
  TempItemsPtr : array of PWCharT;
  i : integer;
begin
  Result := False;
  if not(assigned(items)) then exit;

  if (items.count > 0) then
    begin
      SetLength(TempItems,    items.count);
      SetLength(TempItemsPtr, items.count);

      for i := 0 to pred(items.count) do
        begin
          TempItems[i]    := StringToPyWCharTString(items[i]);
          TempItemsPtr[i] := PWCharT(TempItems[i]);
        end;
    end;

  TempStatus := SetWideStringList(list, items.count, TempItemsPtr);
  Result     := assigned(TempStatus) and not(TempStatus.IsException);
end;

procedure TPyConfigBase.Set_argv(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetArgv(TempSL);
  TempSL.Free;
end;

procedure TPyConfigBase.Set_base_exec_prefix(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_base_executable(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_base_prefix(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_buffered_stdio(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_bytes_warning(aValue: integer);
begin
  //
end;

procedure TPyConfigBase.Set_check_hash_pycs_mode(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_code_debug_ranges(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_configure_c_stdio(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_context_aware_warnings(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_cpu_count(aValue: integer);
begin
  //
end;

procedure TPyConfigBase.Set_dev_mode(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_dump_refs(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_dump_refs_file(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_exec_prefix(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_executable(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_faulthandler(aValue: integer);
begin
  //
end;

procedure TPyConfigBase.Set_filesystem_encoding(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_filesystem_errors(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_hash_seed(aValue: uint64);
begin
  //
end;

procedure TPyConfigBase.Set_home(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_import_time(aValue: integer);
begin
  //
end;

procedure TPyConfigBase.Set_inspect(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_install_signal_handlers(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_int_max_str_digits(aValue: integer);
begin
  //
end;

procedure TPyConfigBase.Set_interactive(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_isolated(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_legacy_windows_stdio(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_malloc_stats(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_module_search_paths(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_module_search_paths_set(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  //
end;

procedure TPyConfigBase.Set_orig_argv(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_parse_argv(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_parser_debug(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_pathconfig_warnings(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_perf_profiling(aValue: integer);
begin
  //
end;

procedure TPyConfigBase.Set_platlibdir(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_prefix(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_program_name(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_pycache_prefix(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_pythonpath_env(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_quiet(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_remote_debug(aValue: integer);
begin
  //
end;

procedure TPyConfigBase.Set_run_command(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_run_filename(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_run_module(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_safe_path(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_show_ref_count(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_site_import(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_skip_source_first_line(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_stdio_encoding(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_stdio_errors(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_stdlib_dir(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_sys_path_0(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_thread_inherit_context(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_tracemalloc(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_use_environment(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_use_frozen_modules(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_use_hash_seed(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_user_site_directory(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_verbose(aValue: TPyVerboseMode);
begin
  //
end;

procedure TPyConfigBase.Set_warn_default_encoding(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_warnoptions(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_write_bytecode(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_xoptions(const aValue: string);
begin
  //
end;
{$ENDREGION}

{$REGION 'TPyConfig314'}
function TPyConfig314.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyConfig314.Get_argv: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.argv, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig314.Get_base_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_exec_prefix));
end;

function TPyConfig314.Get_base_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_executable));
end;

function TPyConfig314.Get_base_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_prefix));
end;

function TPyConfig314.Get_buffered_stdio: boolean;
begin
  Result := (FConfig.buffered_stdio <> 0);
end;

function TPyConfig314.Get_bytes_warning: integer;
begin
  Result := FConfig.bytes_warning;
end;

function TPyConfig314.Get_check_hash_pycs_mode: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.check_hash_pycs_mode));
end;

function TPyConfig314.Get_code_debug_ranges: boolean;
begin
  Result := (FConfig.code_debug_ranges <> 0);
end;

function TPyConfig314.Get_configure_c_stdio: boolean;
begin
  Result := (FConfig.configure_c_stdio <> 0);
end;

function TPyConfig314.Get_context_aware_warnings: boolean;
begin
  Result := (FConfig.context_aware_warnings <> 0);
end;

function TPyConfig314.Get_cpu_count: integer;
begin
  Result := FConfig.cpu_count;
end;

function TPyConfig314.Get_dev_mode: boolean;
begin
  Result := (FConfig.dev_mode <> 0);
end;

function TPyConfig314.Get_dump_refs: boolean;
begin
  Result := (FConfig.dump_refs <> 0);
end;

function TPyConfig314.Get_dump_refs_file: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.dump_refs_file));
end;

function TPyConfig314.Get_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.exec_prefix));
end;

function TPyConfig314.Get_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.executable));
end;

function TPyConfig314.Get_faulthandler: integer;
begin
  Result := FConfig.faulthandler;
end;

function TPyConfig314.Get_filesystem_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_encoding));
end;

function TPyConfig314.Get_filesystem_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_errors));
end;

function TPyConfig314.Get_hash_seed: uint64;
begin
  Result := FConfig.hash_seed;
end;

function TPyConfig314.Get_home: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.home));
end;

function TPyConfig314.Get_import_time: integer;
begin
  Result := FConfig.import_time;
end;

function TPyConfig314.Get_inspect: boolean;
begin
  Result := (FConfig.inspect <> 0);
end;

function TPyConfig314.Get_install_signal_handlers: boolean;
begin
  Result := (FConfig.install_signal_handlers <> 0);
end;

function TPyConfig314.Get_int_max_str_digits: integer;
begin
  Result := FConfig.int_max_str_digits;
end;

function TPyConfig314.Get_interactive: boolean;
begin
  Result := (FConfig.interactive <> 0);
end;

function TPyConfig314.Get_isolated: boolean;
begin
  Result := (FConfig.isolated <> 0);
end;

function TPyConfig314.Get_legacy_windows_stdio: boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := (FConfig.legacy_windows_stdio <> 0);
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

function TPyConfig314.Get_malloc_stats: boolean;
begin
  Result := (FConfig.malloc_stats <> 0);
end;

function TPyConfig314.Get_module_search_paths: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.module_search_paths, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig314.Get_module_search_paths_set: boolean;
begin
  Result := (FConfig.module_search_paths_set <> 0);
end;

function TPyConfig314.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := TPyOptimizationLevel(FConfig.optimization_level);
end;

function TPyConfig314.Get_orig_argv: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.orig_argv, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig314.Get_parse_argv: boolean;
begin
  Result := (FConfig.parse_argv <> 0);
end;

function TPyConfig314.Get_parser_debug: boolean;
begin
  Result := (FConfig.parser_debug <> 0);
end;

function TPyConfig314.Get_pathconfig_warnings: boolean;
begin
  Result := (FConfig.pathconfig_warnings <> 0);
end;

function TPyConfig314.Get_perf_profiling: integer;
begin
  Result := FConfig.perf_profiling;
end;

function TPyConfig314.Get_platlibdir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.platlibdir));
end;

function TPyConfig314.Get_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.prefix));
end;

function TPyConfig314.Get_program_name: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.program_name));
end;

function TPyConfig314.Get_pycache_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pycache_prefix));
end;

function TPyConfig314.Get_pythonpath_env: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pythonpath_env));
end;

function TPyConfig314.Get_quiet: boolean;
begin
  Result := (FConfig.quiet <> 0);
end;

function TPyConfig314.Get_remote_debug: integer;
begin
  Result := FConfig.remote_debug;
end;

function TPyConfig314.Get_run_command: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_command));
end;

function TPyConfig314.Get_run_filename: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_filename));
end;

function TPyConfig314.Get_run_module: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_module));
end;

function TPyConfig314.Get_safe_path: boolean;
begin
  Result := (FConfig.safe_path <> 0);
end;

function TPyConfig314.Get_show_ref_count: boolean;
begin
  Result := (FConfig.show_ref_count <> 0);
end;

function TPyConfig314.Get_site_import: boolean;
begin
  Result := (FConfig.site_import <> 0);
end;

function TPyConfig314.Get_skip_source_first_line: boolean;
begin
  Result := (FConfig.skip_source_first_line <> 0);
end;

function TPyConfig314.Get_stdio_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_encoding));
end;

function TPyConfig314.Get_stdio_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_errors));
end;

function TPyConfig314.Get_stdlib_dir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdlib_dir));
end;

function TPyConfig314.Get_sys_path_0: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.sys_path_0));
end;

function TPyConfig314.Get_thread_inherit_context: boolean;
begin
  Result := (FConfig.thread_inherit_context <> 0);
end;

function TPyConfig314.Get_tracemalloc: boolean;
begin
  Result := (FConfig.tracemalloc <> 0);
end;

function TPyConfig314.Get_use_environment: boolean;
begin
  Result := (FConfig.use_environment <> 0);
end;

function TPyConfig314.Get_use_frozen_modules: boolean;
begin
  Result := (FConfig.use_frozen_modules <> 0);
end;

function TPyConfig314.Get_use_hash_seed: boolean;
begin
  Result := (FConfig.use_hash_seed <> 0);
end;

function TPyConfig314.Get_user_site_directory: boolean;
begin
  Result := (FConfig.user_site_directory <> 0);
end;

function TPyConfig314.Get_verbose: TPyVerboseMode;
begin
  Result := TPyVerboseMode(FConfig.verbose);
end;

function TPyConfig314.Get_warn_default_encoding: boolean;
begin
  Result := (FConfig.warn_default_encoding <> 0);
end;

function TPyConfig314.Get_warnoptions: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.warnoptions, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig314.Get_write_bytecode: boolean;
begin
  Result := (FConfig.write_bytecode <> 0);
end;

function TPyConfig314.Get_xoptions: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.xoptions, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

procedure TPyConfig314.Set_argv(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetArgv(TempSL);
  TempSL.Free;
end;

procedure TPyConfig314.Set_base_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_exec_prefix, aValue);
end;

procedure TPyConfig314.Set_base_executable(const aValue: string);
begin
  SetWCharT(FConfig.base_executable, aValue);
end;

procedure TPyConfig314.Set_base_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_prefix, aValue);
end;

procedure TPyConfig314.Set_buffered_stdio(aValue: boolean);
begin
  FConfig.buffered_stdio := ord(aValue);
end;

procedure TPyConfig314.Set_bytes_warning(aValue: integer);
begin
  FConfig.bytes_warning := aValue;
end;

procedure TPyConfig314.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetWCharT(FConfig.check_hash_pycs_mode, aValue);
end;

procedure TPyConfig314.Set_code_debug_ranges(aValue: boolean);
begin
  FConfig.code_debug_ranges := ord(aValue);
end;

procedure TPyConfig314.Set_configure_c_stdio(aValue: boolean);
begin
  FConfig.configure_c_stdio := ord(aValue);
end;

procedure TPyConfig314.Set_context_aware_warnings(aValue: boolean);
begin
  FConfig.context_aware_warnings := ord(aValue);
end;

procedure TPyConfig314.Set_cpu_count(aValue: integer);
begin
  FConfig.cpu_count := aValue;
end;

procedure TPyConfig314.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    FConfig.dev_mode := -1
   else
    FConfig.dev_mode := 0;
end;

procedure TPyConfig314.Set_dump_refs(aValue: boolean);
begin
  FConfig.dump_refs := ord(aValue);
end;

procedure TPyConfig314.Set_dump_refs_file(const aValue: string);
begin
  SetWCharT(FConfig.dump_refs_file, aValue);
end;

procedure TPyConfig314.Set_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.exec_prefix, aValue);
end;

procedure TPyConfig314.Set_executable(const aValue: string);
begin
  SetWCharT(FConfig.executable, aValue);
end;

procedure TPyConfig314.Set_faulthandler(aValue: integer);
begin
  FConfig.faulthandler := aValue;
end;

procedure TPyConfig314.Set_filesystem_encoding(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_encoding, aValue);
end;

procedure TPyConfig314.Set_filesystem_errors(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_errors, aValue);
end;

procedure TPyConfig314.Set_hash_seed(aValue: uint64);
begin
  FConfig.hash_seed := aValue;
end;

procedure TPyConfig314.Set_home(const aValue: string);
begin
  SetWCharT(FConfig.home, aValue);
end;

procedure TPyConfig314.Set_import_time(aValue: integer);
begin
  FConfig.import_time := aValue;
end;

procedure TPyConfig314.Set_inspect(aValue: boolean);
begin
  FConfig.inspect := ord(aValue);
end;

procedure TPyConfig314.Set_install_signal_handlers(aValue: boolean);
begin
  FConfig.install_signal_handlers := ord(aValue);
end;

procedure TPyConfig314.Set_int_max_str_digits(aValue: integer);
begin
  FConfig.int_max_str_digits := aValue;
end;

procedure TPyConfig314.Set_interactive(aValue: boolean);
begin
  FConfig.interactive := ord(aValue);
end;

procedure TPyConfig314.Set_isolated(aValue: boolean);
begin
  FConfig.isolated := ord(aValue);
end;

procedure TPyConfig314.Set_legacy_windows_stdio(aValue: boolean);
begin
  {$IFDEF MSWINDOWS}
  FConfig.legacy_windows_stdio := ord(aValue);
  {$ENDIF}
end;

procedure TPyConfig314.Set_malloc_stats(aValue: boolean);
begin
  FConfig.malloc_stats := ord(aValue);
end;

procedure TPyConfig314.Set_module_search_paths(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.module_search_paths, TempSL);
  TempSL.Free;
end;

procedure TPyConfig314.Set_module_search_paths_set(aValue: boolean);
begin
  FConfig.module_search_paths_set := ord(aValue);
end;

procedure TPyConfig314.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  FConfig.optimization_level := integer(aValue);
end;

procedure TPyConfig314.Set_orig_argv(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.orig_argv, TempSL);
  TempSL.Free;
end;

procedure TPyConfig314.Set_parse_argv(aValue: boolean);
begin
  FConfig.parse_argv := ord(aValue);
end;

procedure TPyConfig314.Set_parser_debug(aValue: boolean);
begin
  FConfig.parser_debug := ord(aValue);
end;

procedure TPyConfig314.Set_pathconfig_warnings(aValue: boolean);
begin
  FConfig.pathconfig_warnings := ord(aValue);
end;

procedure TPyConfig314.Set_perf_profiling(aValue: integer);
begin
  FConfig.perf_profiling := aValue;
end;

procedure TPyConfig314.Set_platlibdir(const aValue: string);
begin
  SetWCharT(FConfig.platlibdir, aValue);
end;

procedure TPyConfig314.Set_prefix(const aValue: string);
begin
  SetWCharT(FConfig.prefix, aValue);
end;

procedure TPyConfig314.Set_program_name(const aValue: string);
begin
  SetWCharT(FConfig.program_name, aValue);
end;

procedure TPyConfig314.Set_pycache_prefix(const aValue: string);
begin
  SetWCharT(FConfig.pycache_prefix, aValue);
end;

procedure TPyConfig314.Set_pythonpath_env(const aValue: string);
begin
  SetWCharT(FConfig.pythonpath_env, aValue);
end;

procedure TPyConfig314.Set_quiet(aValue: boolean);
begin
  FConfig.quiet := ord(aValue);
end;

procedure TPyConfig314.Set_remote_debug(aValue: integer);
begin
  FConfig.remote_debug := ord(aValue);
end;

procedure TPyConfig314.Set_run_command(const aValue: string);
begin
  SetWCharT(FConfig.run_command, aValue);
end;

procedure TPyConfig314.Set_run_filename(const aValue: string);
begin
  SetWCharT(FConfig.run_filename, aValue);
end;

procedure TPyConfig314.Set_run_module(const aValue: string);
begin
  SetWCharT(FConfig.run_module, aValue);
end;

procedure TPyConfig314.Set_safe_path(aValue: boolean);
begin
  FConfig.safe_path := ord(aValue);
end;

procedure TPyConfig314.Set_show_ref_count(aValue: boolean);
begin
  FConfig.show_ref_count := ord(aValue);
end;

procedure TPyConfig314.Set_site_import(aValue: boolean);
begin
  FConfig.site_import := ord(aValue);
end;

procedure TPyConfig314.Set_skip_source_first_line(aValue: boolean);
begin
  FConfig.skip_source_first_line := ord(aValue);
end;

procedure TPyConfig314.Set_stdio_encoding(const aValue: string);
begin
  SetWCharT(FConfig.stdio_encoding, aValue);
end;

procedure TPyConfig314.Set_stdio_errors(const aValue: string);
begin
  SetWCharT(FConfig.stdio_errors, aValue);
end;

procedure TPyConfig314.Set_stdlib_dir(const aValue: string);
begin
  SetWCharT(FConfig.stdlib_dir, aValue);
end;

procedure TPyConfig314.Set_sys_path_0(const aValue: string);
begin
  SetWCharT(FConfig.sys_path_0, aValue);
end;

procedure TPyConfig314.Set_thread_inherit_context(aValue: boolean);
begin
  FConfig.thread_inherit_context := ord(aValue);
end;

procedure TPyConfig314.Set_tracemalloc(aValue: boolean);
begin
  if aValue then
    FConfig.tracemalloc := -1
   else
    FConfig.tracemalloc := 0;
end;

procedure TPyConfig314.Set_use_environment(aValue: boolean);
begin
  FConfig.use_environment := ord(aValue);
end;

procedure TPyConfig314.Set_use_frozen_modules(aValue: boolean);
begin
  FConfig.use_frozen_modules := ord(aValue);
end;

procedure TPyConfig314.Set_use_hash_seed(aValue: boolean);
begin
  FConfig.use_hash_seed := ord(aValue);
end;

procedure TPyConfig314.Set_user_site_directory(aValue: boolean);
begin
  FConfig.user_site_directory := ord(aValue);
end;

procedure TPyConfig314.Set_verbose(aValue: TPyVerboseMode);
begin
  FConfig.verbose := integer(aValue);
end;

procedure TPyConfig314.Set_warn_default_encoding(aValue: boolean);
begin
  FConfig.warn_default_encoding := ord(aValue);
end;

procedure TPyConfig314.Set_warnoptions(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.warnoptions, TempSL);
  TempSL.Free;
end;

procedure TPyConfig314.Set_write_bytecode(aValue: boolean);
begin
  FConfig.write_bytecode := ord(aValue);
end;

procedure TPyConfig314.Set_xoptions(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.xoptions, TempSL);
  TempSL.Free;
end;
{$ENDREGION}

{$REGION 'TPyConfig313'}
function TPyConfig313.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyConfig313.Get_argv: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.argv, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig313.Get_base_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_exec_prefix));
end;

function TPyConfig313.Get_base_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_executable));
end;

function TPyConfig313.Get_base_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_prefix));
end;

function TPyConfig313.Get_buffered_stdio: boolean;
begin
  Result := (FConfig.buffered_stdio <> 0);
end;

function TPyConfig313.Get_bytes_warning: integer;
begin
  Result := FConfig.bytes_warning;
end;

function TPyConfig313.Get_check_hash_pycs_mode: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.check_hash_pycs_mode));
end;

function TPyConfig313.Get_code_debug_ranges: boolean;
begin
  Result := (FConfig.code_debug_ranges <> 0);
end;

function TPyConfig313.Get_configure_c_stdio: boolean;
begin
  Result := (FConfig.configure_c_stdio <> 0);
end;

function TPyConfig313.Get_cpu_count: integer;
begin
  Result := FConfig.cpu_count;
end;

function TPyConfig313.Get_dev_mode: boolean;
begin
  Result := (FConfig.dev_mode <> 0);
end;

function TPyConfig313.Get_dump_refs: boolean;
begin
  Result := (FConfig.dump_refs <> 0);
end;

function TPyConfig313.Get_dump_refs_file: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.dump_refs_file));
end;

function TPyConfig313.Get_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.exec_prefix));
end;

function TPyConfig313.Get_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.executable));
end;

function TPyConfig313.Get_faulthandler: integer;
begin
  Result := FConfig.faulthandler;
end;

function TPyConfig313.Get_filesystem_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_encoding));
end;

function TPyConfig313.Get_filesystem_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_errors));
end;

function TPyConfig313.Get_hash_seed: uint64;
begin
  Result := FConfig.hash_seed;
end;

function TPyConfig313.Get_home: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.home));
end;

function TPyConfig313.Get_import_time: integer;
begin
  Result := FConfig.import_time;
end;

function TPyConfig313.Get_inspect: boolean;
begin
  Result := (FConfig.inspect <> 0);
end;

function TPyConfig313.Get_install_signal_handlers: boolean;
begin
  Result := (FConfig.install_signal_handlers <> 0);
end;

function TPyConfig313.Get_int_max_str_digits: integer;
begin
  Result := FConfig.int_max_str_digits;
end;

function TPyConfig313.Get_interactive: boolean;
begin
  Result := (FConfig.interactive <> 0);
end;

function TPyConfig313.Get_isolated: boolean;
begin
  Result := (FConfig.isolated <> 0);
end;

function TPyConfig313.Get_legacy_windows_stdio: boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := (FConfig.legacy_windows_stdio <> 0);
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

function TPyConfig313.Get_malloc_stats: boolean;
begin
  Result := (FConfig.malloc_stats <> 0);
end;

function TPyConfig313.Get_module_search_paths: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.module_search_paths, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig313.Get_module_search_paths_set: boolean;
begin
  Result := (FConfig.module_search_paths_set <> 0);
end;

function TPyConfig313.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := TPyOptimizationLevel(FConfig.optimization_level);
end;

function TPyConfig313.Get_orig_argv: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.orig_argv, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig313.Get_parse_argv: boolean;
begin
  Result := (FConfig.parse_argv <> 0);
end;

function TPyConfig313.Get_parser_debug: boolean;
begin
  Result := (FConfig.parser_debug <> 0);
end;

function TPyConfig313.Get_pathconfig_warnings: boolean;
begin
  Result := (FConfig.pathconfig_warnings <> 0);
end;

function TPyConfig313.Get_perf_profiling: integer;
begin
  Result := FConfig.perf_profiling;
end;

function TPyConfig313.Get_platlibdir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.platlibdir));
end;

function TPyConfig313.Get_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.prefix));
end;

function TPyConfig313.Get_program_name: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.program_name));
end;

function TPyConfig313.Get_pycache_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pycache_prefix));
end;

function TPyConfig313.Get_pythonpath_env: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pythonpath_env));
end;

function TPyConfig313.Get_quiet: boolean;
begin
  Result := (FConfig.quiet <> 0);
end;

function TPyConfig313.Get_run_command: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_command));
end;

function TPyConfig313.Get_run_filename: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_filename));
end;

function TPyConfig313.Get_run_module: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_module));
end;

function TPyConfig313.Get_safe_path: boolean;
begin
  Result := (FConfig.safe_path <> 0);
end;

function TPyConfig313.Get_show_ref_count: boolean;
begin
  Result := (FConfig.show_ref_count <> 0);
end;

function TPyConfig313.Get_site_import: boolean;
begin
  Result := (FConfig.site_import <> 0);
end;

function TPyConfig313.Get_skip_source_first_line: boolean;
begin
  Result := (FConfig.skip_source_first_line <> 0);
end;

function TPyConfig313.Get_stdio_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_encoding));
end;

function TPyConfig313.Get_stdio_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_errors));
end;

function TPyConfig313.Get_stdlib_dir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdlib_dir));
end;

function TPyConfig313.Get_sys_path_0: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.sys_path_0));
end;

function TPyConfig313.Get_tracemalloc: boolean;
begin
  Result := (FConfig.tracemalloc <> 0);
end;

function TPyConfig313.Get_use_environment: boolean;
begin
  Result := (FConfig.use_environment <> 0);
end;

function TPyConfig313.Get_use_frozen_modules: boolean;
begin
  Result := (FConfig.use_frozen_modules <> 0);
end;

function TPyConfig313.Get_use_hash_seed: boolean;
begin
  Result := (FConfig.use_hash_seed <> 0);
end;

function TPyConfig313.Get_user_site_directory: boolean;
begin
  Result := (FConfig.user_site_directory <> 0);
end;

function TPyConfig313.Get_verbose: TPyVerboseMode;
begin
  Result := TPyVerboseMode(FConfig.verbose);
end;

function TPyConfig313.Get_warn_default_encoding: boolean;
begin
  Result := (FConfig.warn_default_encoding <> 0);
end;

function TPyConfig313.Get_warnoptions: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.warnoptions, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig313.Get_write_bytecode: boolean;
begin
  Result := (FConfig.write_bytecode <> 0);
end;

function TPyConfig313.Get_xoptions: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.xoptions, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

procedure TPyConfig313.Set_argv(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetArgv(TempSL);
  TempSL.Free;
end;

procedure TPyConfig313.Set_base_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_exec_prefix, aValue);
end;

procedure TPyConfig313.Set_base_executable(const aValue: string);
begin
  SetWCharT(FConfig.base_executable, aValue);
end;

procedure TPyConfig313.Set_base_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_prefix, aValue);
end;

procedure TPyConfig313.Set_buffered_stdio(aValue: boolean);
begin
  FConfig.buffered_stdio := ord(aValue);
end;

procedure TPyConfig313.Set_bytes_warning(aValue: integer);
begin
  FConfig.bytes_warning := aValue;
end;

procedure TPyConfig313.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetWCharT(FConfig.check_hash_pycs_mode, aValue);
end;

procedure TPyConfig313.Set_code_debug_ranges(aValue: boolean);
begin
  FConfig.code_debug_ranges := ord(aValue);
end;

procedure TPyConfig313.Set_configure_c_stdio(aValue: boolean);
begin
  FConfig.configure_c_stdio := ord(aValue);
end;

procedure TPyConfig313.Set_cpu_count(aValue: integer);
begin
  FConfig.cpu_count := aValue;
end;

procedure TPyConfig313.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    FConfig.dev_mode := -1
   else
    FConfig.dev_mode := 0;
end;

procedure TPyConfig313.Set_dump_refs(aValue: boolean);
begin
  FConfig.dump_refs := ord(aValue);
end;

procedure TPyConfig313.Set_dump_refs_file(const aValue: string);
begin
  SetWCharT(FConfig.dump_refs_file, aValue);
end;

procedure TPyConfig313.Set_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.exec_prefix, aValue);
end;

procedure TPyConfig313.Set_executable(const aValue: string);
begin
  SetWCharT(FConfig.executable, aValue);
end;

procedure TPyConfig313.Set_faulthandler(aValue: integer);
begin
  FConfig.faulthandler := aValue;
end;

procedure TPyConfig313.Set_filesystem_encoding(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_encoding, aValue);
end;

procedure TPyConfig313.Set_filesystem_errors(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_errors, aValue);
end;

procedure TPyConfig313.Set_hash_seed(aValue: uint64);
begin
  FConfig.hash_seed := aValue;
end;

procedure TPyConfig313.Set_home(const aValue: string);
begin
  SetWCharT(FConfig.home, aValue);
end;

procedure TPyConfig313.Set_import_time(aValue: integer);
begin
  FConfig.import_time := aValue;
end;

procedure TPyConfig313.Set_inspect(aValue: boolean);
begin
  FConfig.inspect := ord(aValue);
end;

procedure TPyConfig313.Set_install_signal_handlers(aValue: boolean);
begin
  FConfig.install_signal_handlers := ord(aValue);
end;

procedure TPyConfig313.Set_int_max_str_digits(aValue: integer);
begin
  FConfig.int_max_str_digits := aValue;
end;

procedure TPyConfig313.Set_interactive(aValue: boolean);
begin
  FConfig.interactive := ord(aValue);
end;

procedure TPyConfig313.Set_isolated(aValue: boolean);
begin
  FConfig.isolated := ord(aValue);
end;

procedure TPyConfig313.Set_legacy_windows_stdio(aValue: boolean);
begin
  {$IFDEF MSWINDOWS}
  FConfig.legacy_windows_stdio := ord(aValue);
  {$ENDIF}
end;

procedure TPyConfig313.Set_malloc_stats(aValue: boolean);
begin
  FConfig.malloc_stats := ord(aValue);
end;

procedure TPyConfig313.Set_module_search_paths(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.module_search_paths, TempSL);
  TempSL.Free;
end;

procedure TPyConfig313.Set_module_search_paths_set(aValue: boolean);
begin
  FConfig.module_search_paths_set := ord(aValue);
end;

procedure TPyConfig313.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  FConfig.optimization_level := integer(aValue);
end;

procedure TPyConfig313.Set_orig_argv(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.orig_argv, TempSL);
  TempSL.Free;
end;

procedure TPyConfig313.Set_parse_argv(aValue: boolean);
begin
  FConfig.parse_argv := ord(aValue);
end;

procedure TPyConfig313.Set_parser_debug(aValue: boolean);
begin
  FConfig.parser_debug := ord(aValue);
end;

procedure TPyConfig313.Set_pathconfig_warnings(aValue: boolean);
begin
  FConfig.pathconfig_warnings := ord(aValue);
end;

procedure TPyConfig313.Set_perf_profiling(aValue: integer);
begin
  FConfig.perf_profiling := aValue;
end;

procedure TPyConfig313.Set_platlibdir(const aValue: string);
begin
  SetWCharT(FConfig.platlibdir, aValue);
end;

procedure TPyConfig313.Set_prefix(const aValue: string);
begin
  SetWCharT(FConfig.prefix, aValue);
end;

procedure TPyConfig313.Set_program_name(const aValue: string);
begin
  SetWCharT(FConfig.program_name, aValue);
end;

procedure TPyConfig313.Set_pycache_prefix(const aValue: string);
begin
  SetWCharT(FConfig.pycache_prefix, aValue);
end;

procedure TPyConfig313.Set_pythonpath_env(const aValue: string);
begin
  SetWCharT(FConfig.pythonpath_env, aValue);
end;

procedure TPyConfig313.Set_quiet(aValue: boolean);
begin
  FConfig.quiet := ord(aValue);
end;

procedure TPyConfig313.Set_run_command(const aValue: string);
begin
  SetWCharT(FConfig.run_command, aValue);
end;

procedure TPyConfig313.Set_run_filename(const aValue: string);
begin
  SetWCharT(FConfig.run_filename, aValue);
end;

procedure TPyConfig313.Set_run_module(const aValue: string);
begin
  SetWCharT(FConfig.run_module, aValue);
end;

procedure TPyConfig313.Set_safe_path(aValue: boolean);
begin
  FConfig.safe_path := ord(aValue);
end;

procedure TPyConfig313.Set_show_ref_count(aValue: boolean);
begin
  FConfig.show_ref_count := ord(aValue);
end;

procedure TPyConfig313.Set_site_import(aValue: boolean);
begin
  FConfig.site_import := ord(aValue);
end;

procedure TPyConfig313.Set_skip_source_first_line(aValue: boolean);
begin
  FConfig.skip_source_first_line := ord(aValue);
end;

procedure TPyConfig313.Set_stdio_encoding(const aValue: string);
begin
  SetWCharT(FConfig.stdio_encoding, aValue);
end;

procedure TPyConfig313.Set_stdio_errors(const aValue: string);
begin
  SetWCharT(FConfig.stdio_errors, aValue);
end;

procedure TPyConfig313.Set_stdlib_dir(const aValue: string);
begin
  SetWCharT(FConfig.stdlib_dir, aValue);
end;

procedure TPyConfig313.Set_sys_path_0(const aValue: string);
begin
  SetWCharT(FConfig.sys_path_0, aValue);
end;

procedure TPyConfig313.Set_tracemalloc(aValue: boolean);
begin
  if aValue then
    FConfig.tracemalloc := -1
   else
    FConfig.tracemalloc := 0;
end;

procedure TPyConfig313.Set_use_environment(aValue: boolean);
begin
  FConfig.use_environment := ord(aValue);
end;

procedure TPyConfig313.Set_use_frozen_modules(aValue: boolean);
begin
  FConfig.use_frozen_modules := ord(aValue);
end;

procedure TPyConfig313.Set_use_hash_seed(aValue: boolean);
begin
  FConfig.use_hash_seed := ord(aValue);
end;

procedure TPyConfig313.Set_user_site_directory(aValue: boolean);
begin
  FConfig.user_site_directory := ord(aValue);
end;

procedure TPyConfig313.Set_verbose(aValue: TPyVerboseMode);
begin
  FConfig.verbose := integer(aValue);
end;

procedure TPyConfig313.Set_warn_default_encoding(aValue: boolean);
begin
  FConfig.warn_default_encoding := ord(aValue);
end;

procedure TPyConfig313.Set_warnoptions(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.warnoptions, TempSL);
  TempSL.Free;
end;

procedure TPyConfig313.Set_write_bytecode(aValue: boolean);
begin
  FConfig.write_bytecode := ord(aValue);
end;

procedure TPyConfig313.Set_xoptions(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.xoptions, TempSL);
  TempSL.Free;
end;
{$ENDREGION}

{$REGION 'TPyConfig312'}
function TPyConfig312.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyConfig312.Get_argv: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.argv, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig312.Get_base_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_exec_prefix));
end;

function TPyConfig312.Get_base_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_executable));
end;

function TPyConfig312.Get_base_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_prefix));
end;

function TPyConfig312.Get_buffered_stdio: boolean;
begin
  Result := (FConfig.buffered_stdio <> 0);
end;

function TPyConfig312.Get_bytes_warning: integer;
begin
  Result := FConfig.bytes_warning;
end;

function TPyConfig312.Get_check_hash_pycs_mode: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.check_hash_pycs_mode));
end;

function TPyConfig312.Get_code_debug_ranges: boolean;
begin
  Result := (FConfig.code_debug_ranges <> 0);
end;

function TPyConfig312.Get_configure_c_stdio: boolean;
begin
  Result := (FConfig.configure_c_stdio <> 0);
end;

function TPyConfig312.Get_dev_mode: boolean;
begin
  Result := (FConfig.dev_mode <> 0);
end;

function TPyConfig312.Get_dump_refs: boolean;
begin
  Result := (FConfig.dump_refs <> 0);
end;

function TPyConfig312.Get_dump_refs_file: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.dump_refs_file));
end;

function TPyConfig312.Get_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.exec_prefix));
end;

function TPyConfig312.Get_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.executable));
end;

function TPyConfig312.Get_faulthandler: integer;
begin
  Result := FConfig.faulthandler;
end;

function TPyConfig312.Get_filesystem_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_encoding));
end;

function TPyConfig312.Get_filesystem_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_errors));
end;

function TPyConfig312.Get_hash_seed: uint64;
begin
  Result := FConfig.hash_seed;
end;

function TPyConfig312.Get_home: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.home));
end;

function TPyConfig312.Get_import_time: integer;
begin
  Result := FConfig.import_time;
end;

function TPyConfig312.Get_inspect: boolean;
begin
  Result := (FConfig.inspect <> 0);
end;

function TPyConfig312.Get_install_signal_handlers: boolean;
begin
  Result := (FConfig.install_signal_handlers <> 0);
end;

function TPyConfig312.Get_int_max_str_digits: integer;
begin
  Result := FConfig.int_max_str_digits;
end;

function TPyConfig312.Get_interactive: boolean;
begin
  Result := (FConfig.interactive <> 0);
end;

function TPyConfig312.Get_isolated: boolean;
begin
  Result := (FConfig.isolated <> 0);
end;

function TPyConfig312.Get_legacy_windows_stdio: boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := (FConfig.legacy_windows_stdio <> 0);
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

function TPyConfig312.Get_malloc_stats: boolean;
begin
  Result := (FConfig.malloc_stats <> 0);
end;

function TPyConfig312.Get_module_search_paths: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.module_search_paths, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig312.Get_module_search_paths_set: boolean;
begin
  Result := (FConfig.module_search_paths_set <> 0);
end;

function TPyConfig312.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := TPyOptimizationLevel(FConfig.optimization_level);
end;

function TPyConfig312.Get_orig_argv: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.orig_argv, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig312.Get_parse_argv: boolean;
begin
  Result := (FConfig.parse_argv <> 0);
end;

function TPyConfig312.Get_parser_debug: boolean;
begin
  Result := (FConfig.parser_debug <> 0);
end;

function TPyConfig312.Get_pathconfig_warnings: boolean;
begin
  Result := (FConfig.pathconfig_warnings <> 0);
end;

function TPyConfig312.Get_perf_profiling: integer;
begin
  Result := FConfig.perf_profiling;
end;

function TPyConfig312.Get_platlibdir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.platlibdir));
end;

function TPyConfig312.Get_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.prefix));
end;

function TPyConfig312.Get_program_name: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.program_name));
end;

function TPyConfig312.Get_pycache_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pycache_prefix));
end;

function TPyConfig312.Get_pythonpath_env: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pythonpath_env));
end;

function TPyConfig312.Get_quiet: boolean;
begin
  Result := (FConfig.quiet <> 0);
end;

function TPyConfig312.Get_run_command: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_command));
end;

function TPyConfig312.Get_run_filename: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_filename));
end;

function TPyConfig312.Get_run_module: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_module));
end;

function TPyConfig312.Get_safe_path: boolean;
begin
  Result := (FConfig.safe_path <> 0);
end;

function TPyConfig312.Get_show_ref_count: boolean;
begin
  Result := (FConfig.show_ref_count <> 0);
end;

function TPyConfig312.Get_site_import: boolean;
begin
  Result := (FConfig.site_import <> 0);
end;

function TPyConfig312.Get_skip_source_first_line: boolean;
begin
  Result := (FConfig.skip_source_first_line <> 0);
end;

function TPyConfig312.Get_stdio_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_encoding));
end;

function TPyConfig312.Get_stdio_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_errors));
end;

function TPyConfig312.Get_stdlib_dir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdlib_dir));
end;

function TPyConfig312.Get_tracemalloc: boolean;
begin
  Result := (FConfig.tracemalloc <> 0);
end;

function TPyConfig312.Get_use_environment: boolean;
begin
  Result := (FConfig.use_environment <> 0);
end;

function TPyConfig312.Get_use_frozen_modules: boolean;
begin
  Result := (FConfig.use_frozen_modules <> 0);
end;

function TPyConfig312.Get_use_hash_seed: boolean;
begin
  Result := (FConfig.use_hash_seed <> 0);
end;

function TPyConfig312.Get_user_site_directory: boolean;
begin
  Result := (FConfig.user_site_directory <> 0);
end;

function TPyConfig312.Get_verbose: TPyVerboseMode;
begin
  Result := TPyVerboseMode(FConfig.verbose);
end;

function TPyConfig312.Get_warn_default_encoding: boolean;
begin
  Result := (FConfig.warn_default_encoding <> 0);
end;

function TPyConfig312.Get_warnoptions: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.warnoptions, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig312.Get_write_bytecode: boolean;
begin
  Result := (FConfig.write_bytecode <> 0);
end;

function TPyConfig312.Get_xoptions: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.xoptions, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

procedure TPyConfig312.Set_argv(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetArgv(TempSL);
  TempSL.Free;
end;

procedure TPyConfig312.Set_base_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_exec_prefix, aValue);
end;

procedure TPyConfig312.Set_base_executable(const aValue: string);
begin
  SetWCharT(FConfig.base_executable, aValue);
end;

procedure TPyConfig312.Set_base_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_prefix, aValue);
end;

procedure TPyConfig312.Set_buffered_stdio(aValue: boolean);
begin
  FConfig.buffered_stdio := ord(aValue);
end;

procedure TPyConfig312.Set_bytes_warning(aValue: integer);
begin
  FConfig.bytes_warning := aValue;
end;

procedure TPyConfig312.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetWCharT(FConfig.check_hash_pycs_mode, aValue);
end;

procedure TPyConfig312.Set_code_debug_ranges(aValue: boolean);
begin
  FConfig.code_debug_ranges := ord(aValue);
end;

procedure TPyConfig312.Set_configure_c_stdio(aValue: boolean);
begin
  FConfig.configure_c_stdio := ord(aValue);
end;

procedure TPyConfig312.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    FConfig.dev_mode := -1
   else
    FConfig.dev_mode := 0;
end;

procedure TPyConfig312.Set_dump_refs(aValue: boolean);
begin
  FConfig.dump_refs := ord(aValue);
end;

procedure TPyConfig312.Set_dump_refs_file(const aValue: string);
begin
  SetWCharT(FConfig.dump_refs_file, aValue);
end;

procedure TPyConfig312.Set_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.exec_prefix, aValue);
end;

procedure TPyConfig312.Set_executable(const aValue: string);
begin
  SetWCharT(FConfig.executable, aValue);
end;

procedure TPyConfig312.Set_faulthandler(aValue: integer);
begin
  FConfig.faulthandler := aValue;
end;

procedure TPyConfig312.Set_filesystem_encoding(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_encoding, aValue);
end;

procedure TPyConfig312.Set_filesystem_errors(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_errors, aValue);
end;

procedure TPyConfig312.Set_hash_seed(aValue: uint64);
begin
  FConfig.hash_seed := aValue;
end;

procedure TPyConfig312.Set_home(const aValue: string);
begin
  SetWCharT(FConfig.home, aValue);
end;

procedure TPyConfig312.Set_import_time(aValue: integer);
begin
  FConfig.import_time := aValue;
end;

procedure TPyConfig312.Set_inspect(aValue: boolean);
begin
  FConfig.inspect := ord(aValue);
end;

procedure TPyConfig312.Set_install_signal_handlers(aValue: boolean);
begin
  FConfig.install_signal_handlers := ord(aValue);
end;

procedure TPyConfig312.Set_int_max_str_digits(aValue: integer);
begin
  FConfig.int_max_str_digits := aValue;
end;

procedure TPyConfig312.Set_interactive(aValue: boolean);
begin
  FConfig.interactive := ord(aValue);
end;

procedure TPyConfig312.Set_isolated(aValue: boolean);
begin
  FConfig.isolated := ord(aValue);
end;

procedure TPyConfig312.Set_legacy_windows_stdio(aValue: boolean);
begin
  {$IFDEF MSWINDOWS}
  FConfig.legacy_windows_stdio := ord(aValue);
  {$ENDIF}
end;

procedure TPyConfig312.Set_malloc_stats(aValue: boolean);
begin
  FConfig.malloc_stats := ord(aValue);
end;

procedure TPyConfig312.Set_module_search_paths(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.module_search_paths, TempSL);
  TempSL.Free;
end;

procedure TPyConfig312.Set_module_search_paths_set(aValue: boolean);
begin
  FConfig.module_search_paths_set := ord(aValue);
end;

procedure TPyConfig312.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  FConfig.optimization_level := integer(aValue);
end;

procedure TPyConfig312.Set_orig_argv(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.orig_argv, TempSL);
  TempSL.Free;
end;

procedure TPyConfig312.Set_parse_argv(aValue: boolean);
begin
  FConfig.parse_argv := ord(aValue);
end;

procedure TPyConfig312.Set_parser_debug(aValue: boolean);
begin
  FConfig.parser_debug := ord(aValue);
end;

procedure TPyConfig312.Set_pathconfig_warnings(aValue: boolean);
begin
  FConfig.pathconfig_warnings := ord(aValue);
end;

procedure TPyConfig312.Set_perf_profiling(aValue: integer);
begin
  FConfig.perf_profiling := aValue;
end;

procedure TPyConfig312.Set_platlibdir(const aValue: string);
begin
  SetWCharT(FConfig.platlibdir, aValue);
end;

procedure TPyConfig312.Set_prefix(const aValue: string);
begin
  SetWCharT(FConfig.prefix, aValue);
end;

procedure TPyConfig312.Set_program_name(const aValue: string);
begin
  SetWCharT(FConfig.program_name, aValue);
end;

procedure TPyConfig312.Set_pycache_prefix(const aValue: string);
begin
  SetWCharT(FConfig.pycache_prefix, aValue);
end;

procedure TPyConfig312.Set_pythonpath_env(const aValue: string);
begin
  SetWCharT(FConfig.pythonpath_env, aValue);
end;

procedure TPyConfig312.Set_quiet(aValue: boolean);
begin
  FConfig.quiet := ord(aValue);
end;

procedure TPyConfig312.Set_run_command(const aValue: string);
begin
  SetWCharT(FConfig.run_command, aValue);
end;

procedure TPyConfig312.Set_run_filename(const aValue: string);
begin
  SetWCharT(FConfig.run_filename, aValue);
end;

procedure TPyConfig312.Set_run_module(const aValue: string);
begin
  SetWCharT(FConfig.run_module, aValue);
end;

procedure TPyConfig312.Set_safe_path(aValue: boolean);
begin
  FConfig.safe_path := ord(aValue);
end;

procedure TPyConfig312.Set_show_ref_count(aValue: boolean);
begin
  FConfig.show_ref_count := ord(aValue);
end;

procedure TPyConfig312.Set_site_import(aValue: boolean);
begin
  FConfig.site_import := ord(aValue);
end;

procedure TPyConfig312.Set_skip_source_first_line(aValue: boolean);
begin
  FConfig.skip_source_first_line := ord(aValue);
end;

procedure TPyConfig312.Set_stdio_encoding(const aValue: string);
begin
  SetWCharT(FConfig.stdio_encoding, aValue);
end;

procedure TPyConfig312.Set_stdio_errors(const aValue: string);
begin
  SetWCharT(FConfig.stdio_errors, aValue);
end;

procedure TPyConfig312.Set_stdlib_dir(const aValue: string);
begin
  SetWCharT(FConfig.stdlib_dir, aValue);
end;

procedure TPyConfig312.Set_tracemalloc(aValue: boolean);
begin
  if aValue then
    FConfig.tracemalloc := -1
   else
    FConfig.tracemalloc := 0;
end;

procedure TPyConfig312.Set_use_environment(aValue: boolean);
begin
  FConfig.use_environment := ord(aValue);
end;

procedure TPyConfig312.Set_use_frozen_modules(aValue: boolean);
begin
  FConfig.use_frozen_modules := ord(aValue);
end;

procedure TPyConfig312.Set_use_hash_seed(aValue: boolean);
begin
  FConfig.use_hash_seed := ord(aValue);
end;

procedure TPyConfig312.Set_user_site_directory(aValue: boolean);
begin
  FConfig.user_site_directory := ord(aValue);
end;

procedure TPyConfig312.Set_verbose(aValue: TPyVerboseMode);
begin
  FConfig.verbose := integer(aValue);
end;

procedure TPyConfig312.Set_warn_default_encoding(aValue: boolean);
begin
  FConfig.warn_default_encoding := ord(aValue);
end;

procedure TPyConfig312.Set_warnoptions(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.warnoptions, TempSL);
  TempSL.Free;
end;

procedure TPyConfig312.Set_write_bytecode(aValue: boolean);
begin
  FConfig.write_bytecode := ord(aValue);
end;

procedure TPyConfig312.Set_xoptions(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.xoptions, TempSL);
  TempSL.Free;
end;
{$ENDREGION}

{$REGION 'TPyConfig311'}
function TPyConfig311.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyConfig311.Get_argv: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.argv, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig311.Get_base_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_exec_prefix));
end;

function TPyConfig311.Get_base_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_executable));
end;

function TPyConfig311.Get_base_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_prefix));
end;

function TPyConfig311.Get_buffered_stdio: boolean;
begin
  Result := (FConfig.buffered_stdio <> 0);
end;

function TPyConfig311.Get_bytes_warning: integer;
begin
  Result := FConfig.bytes_warning;
end;

function TPyConfig311.Get_check_hash_pycs_mode: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.check_hash_pycs_mode));
end;

function TPyConfig311.Get_code_debug_ranges: boolean;
begin
  Result := (FConfig.code_debug_ranges <> 0);
end;

function TPyConfig311.Get_configure_c_stdio: boolean;
begin
  Result := (FConfig.configure_c_stdio <> 0);
end;

function TPyConfig311.Get_dev_mode: boolean;
begin
  Result := (FConfig.dev_mode <> 0);
end;

function TPyConfig311.Get_dump_refs: boolean;
begin
  Result := (FConfig.dump_refs <> 0);
end;

function TPyConfig311.Get_dump_refs_file: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.dump_refs_file));
end;

function TPyConfig311.Get_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.exec_prefix));
end;

function TPyConfig311.Get_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.executable));
end;

function TPyConfig311.Get_faulthandler: integer;
begin
  Result := FConfig.faulthandler;
end;

function TPyConfig311.Get_filesystem_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_encoding));
end;

function TPyConfig311.Get_filesystem_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_errors));
end;

function TPyConfig311.Get_hash_seed: uint64;
begin
  Result := FConfig.hash_seed;
end;

function TPyConfig311.Get_home: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.home));
end;

function TPyConfig311.Get_import_time: integer;
begin
  Result := FConfig.import_time;
end;

function TPyConfig311.Get_inspect: boolean;
begin
  Result := (FConfig.inspect <> 0);
end;

function TPyConfig311.Get_install_signal_handlers: boolean;
begin
  Result := (FConfig.install_signal_handlers <> 0);
end;

function TPyConfig311.Get_interactive: boolean;
begin
  Result := (FConfig.interactive <> 0);
end;

function TPyConfig311.Get_isolated: boolean;
begin
  Result := (FConfig.isolated <> 0);
end;

function TPyConfig311.Get_legacy_windows_stdio: boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := (FConfig.legacy_windows_stdio <> 0);
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

function TPyConfig311.Get_malloc_stats: boolean;
begin
  Result := (FConfig.malloc_stats <> 0);
end;

function TPyConfig311.Get_module_search_paths: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.module_search_paths, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig311.Get_module_search_paths_set: boolean;
begin
  Result := (FConfig.module_search_paths_set <> 0);
end;

function TPyConfig311.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := TPyOptimizationLevel(FConfig.optimization_level);
end;

function TPyConfig311.Get_orig_argv: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.orig_argv, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig311.Get_parse_argv: boolean;
begin
  Result := (FConfig.parse_argv <> 0);
end;

function TPyConfig311.Get_parser_debug: boolean;
begin
  Result := (FConfig.parser_debug <> 0);
end;

function TPyConfig311.Get_pathconfig_warnings: boolean;
begin
  Result := (FConfig.pathconfig_warnings <> 0);
end;

function TPyConfig311.Get_platlibdir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.platlibdir));
end;

function TPyConfig311.Get_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.prefix));
end;

function TPyConfig311.Get_program_name: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.program_name));
end;

function TPyConfig311.Get_pycache_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pycache_prefix));
end;

function TPyConfig311.Get_pythonpath_env: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pythonpath_env));
end;

function TPyConfig311.Get_quiet: boolean;
begin
  Result := (FConfig.quiet <> 0);
end;

function TPyConfig311.Get_run_command: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_command));
end;

function TPyConfig311.Get_run_filename: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_filename));
end;

function TPyConfig311.Get_run_module: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_module));
end;

function TPyConfig311.Get_safe_path: boolean;
begin
  Result := (FConfig.safe_path <> 0);
end;

function TPyConfig311.Get_show_ref_count: boolean;
begin
  Result := (FConfig.show_ref_count <> 0);
end;

function TPyConfig311.Get_site_import: boolean;
begin
  Result := (FConfig.site_import <> 0);
end;

function TPyConfig311.Get_skip_source_first_line: boolean;
begin
  Result := (FConfig.skip_source_first_line <> 0);
end;

function TPyConfig311.Get_stdio_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_encoding));
end;

function TPyConfig311.Get_stdio_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_errors));
end;

function TPyConfig311.Get_stdlib_dir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdlib_dir));
end;

function TPyConfig311.Get_tracemalloc: boolean;
begin
  Result := (FConfig.tracemalloc <> 0);
end;

function TPyConfig311.Get_use_environment: boolean;
begin
  Result := (FConfig.use_environment <> 0);
end;

function TPyConfig311.Get_use_frozen_modules: boolean;
begin
  Result := (FConfig.use_frozen_modules <> 0);
end;

function TPyConfig311.Get_use_hash_seed: boolean;
begin
  Result := (FConfig.use_hash_seed <> 0);
end;

function TPyConfig311.Get_user_site_directory: boolean;
begin
  Result := (FConfig.user_site_directory <> 0);
end;

function TPyConfig311.Get_verbose: TPyVerboseMode;
begin
  Result := TPyVerboseMode(FConfig.verbose);
end;

function TPyConfig311.Get_warn_default_encoding: boolean;
begin
  Result := (FConfig.warn_default_encoding <> 0);
end;

function TPyConfig311.Get_warnoptions: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.warnoptions, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig311.Get_write_bytecode: boolean;
begin
  Result := (FConfig.write_bytecode <> 0);
end;

function TPyConfig311.Get_xoptions: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.xoptions, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

procedure TPyConfig311.Set_argv(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetArgv(TempSL);
  TempSL.Free;
end;

procedure TPyConfig311.Set_base_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_exec_prefix, aValue);
end;

procedure TPyConfig311.Set_base_executable(const aValue: string);
begin
  SetWCharT(FConfig.base_executable, aValue);
end;

procedure TPyConfig311.Set_base_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_prefix, aValue);
end;

procedure TPyConfig311.Set_buffered_stdio(aValue: boolean);
begin
  FConfig.buffered_stdio := ord(aValue);
end;

procedure TPyConfig311.Set_bytes_warning(aValue: integer);
begin
  FConfig.bytes_warning := aValue;
end;

procedure TPyConfig311.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetWCharT(FConfig.check_hash_pycs_mode, aValue);
end;

procedure TPyConfig311.Set_code_debug_ranges(aValue: boolean);
begin
  FConfig.code_debug_ranges := ord(aValue);
end;

procedure TPyConfig311.Set_configure_c_stdio(aValue: boolean);
begin
  FConfig.configure_c_stdio := ord(aValue);
end;

procedure TPyConfig311.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    FConfig.dev_mode := -1
   else
    FConfig.dev_mode := 0;
end;

procedure TPyConfig311.Set_dump_refs(aValue: boolean);
begin
  FConfig.dump_refs := ord(aValue);
end;

procedure TPyConfig311.Set_dump_refs_file(const aValue: string);
begin
  SetWCharT(FConfig.dump_refs_file, aValue);
end;

procedure TPyConfig311.Set_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.exec_prefix, aValue);
end;

procedure TPyConfig311.Set_executable(const aValue: string);
begin
  SetWCharT(FConfig.executable, aValue);
end;

procedure TPyConfig311.Set_faulthandler(aValue: integer);
begin
  FConfig.faulthandler := aValue;
end;

procedure TPyConfig311.Set_filesystem_encoding(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_encoding, aValue);
end;

procedure TPyConfig311.Set_filesystem_errors(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_errors, aValue);
end;

procedure TPyConfig311.Set_hash_seed(aValue: uint64);
begin
  FConfig.hash_seed := aValue;
end;

procedure TPyConfig311.Set_home(const aValue: string);
begin
  SetWCharT(FConfig.home, aValue);
end;

procedure TPyConfig311.Set_import_time(aValue: integer);
begin
  FConfig.import_time := aValue;
end;

procedure TPyConfig311.Set_inspect(aValue: boolean);
begin
  FConfig.inspect := ord(aValue);
end;

procedure TPyConfig311.Set_install_signal_handlers(aValue: boolean);
begin
  FConfig.install_signal_handlers := ord(aValue);
end;

procedure TPyConfig311.Set_interactive(aValue: boolean);
begin
  FConfig.interactive := ord(aValue);
end;

procedure TPyConfig311.Set_isolated(aValue: boolean);
begin
  FConfig.isolated := ord(aValue);
end;

procedure TPyConfig311.Set_legacy_windows_stdio(aValue: boolean);
begin
  {$IFDEF MSWINDOWS}
  FConfig.legacy_windows_stdio := ord(aValue);
  {$ENDIF}
end;

procedure TPyConfig311.Set_malloc_stats(aValue: boolean);
begin
  FConfig.malloc_stats := ord(aValue);
end;

procedure TPyConfig311.Set_module_search_paths(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.module_search_paths, TempSL);
  TempSL.Free;
end;

procedure TPyConfig311.Set_module_search_paths_set(aValue: boolean);
begin
  FConfig.module_search_paths_set := ord(aValue);
end;

procedure TPyConfig311.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  FConfig.optimization_level := integer(aValue);
end;

procedure TPyConfig311.Set_orig_argv(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.orig_argv, TempSL);
  TempSL.Free;
end;

procedure TPyConfig311.Set_parse_argv(aValue: boolean);
begin
  FConfig.parse_argv := ord(aValue);
end;

procedure TPyConfig311.Set_parser_debug(aValue: boolean);
begin
  FConfig.parser_debug := ord(aValue);
end;

procedure TPyConfig311.Set_pathconfig_warnings(aValue: boolean);
begin
  FConfig.pathconfig_warnings := ord(aValue);
end;

procedure TPyConfig311.Set_platlibdir(const aValue: string);
begin
  SetWCharT(FConfig.platlibdir, aValue);
end;

procedure TPyConfig311.Set_prefix(const aValue: string);
begin
  SetWCharT(FConfig.prefix, aValue);
end;

procedure TPyConfig311.Set_program_name(const aValue: string);
begin
  SetWCharT(FConfig.program_name, aValue);
end;

procedure TPyConfig311.Set_pycache_prefix(const aValue: string);
begin
  SetWCharT(FConfig.pycache_prefix, aValue);
end;

procedure TPyConfig311.Set_pythonpath_env(const aValue: string);
begin
  SetWCharT(FConfig.pythonpath_env, aValue);
end;

procedure TPyConfig311.Set_quiet(aValue: boolean);
begin
  FConfig.quiet := ord(aValue);
end;

procedure TPyConfig311.Set_run_command(const aValue: string);
begin
  SetWCharT(FConfig.run_command, aValue);
end;

procedure TPyConfig311.Set_run_filename(const aValue: string);
begin
  SetWCharT(FConfig.run_filename, aValue);
end;

procedure TPyConfig311.Set_run_module(const aValue: string);
begin
  SetWCharT(FConfig.run_module, aValue);
end;

procedure TPyConfig311.Set_safe_path(aValue: boolean);
begin
  FConfig.safe_path := ord(aValue);
end;

procedure TPyConfig311.Set_show_ref_count(aValue: boolean);
begin
  FConfig.show_ref_count := ord(aValue);
end;

procedure TPyConfig311.Set_site_import(aValue: boolean);
begin
  FConfig.site_import := ord(aValue);
end;

procedure TPyConfig311.Set_skip_source_first_line(aValue: boolean);
begin
  FConfig.skip_source_first_line := ord(aValue);
end;

procedure TPyConfig311.Set_stdio_encoding(const aValue: string);
begin
  SetWCharT(FConfig.stdio_encoding, aValue);
end;

procedure TPyConfig311.Set_stdio_errors(const aValue: string);
begin
  SetWCharT(FConfig.stdio_errors, aValue);
end;

procedure TPyConfig311.Set_stdlib_dir(const aValue: string);
begin
  SetWCharT(FConfig.stdlib_dir, aValue);
end;

procedure TPyConfig311.Set_tracemalloc(aValue: boolean);
begin
  if aValue then
    FConfig.tracemalloc := -1
   else
    FConfig.tracemalloc := 0;
end;

procedure TPyConfig311.Set_use_environment(aValue: boolean);
begin
  FConfig.use_environment := ord(aValue);
end;

procedure TPyConfig311.Set_use_frozen_modules(aValue: boolean);
begin
  FConfig.use_frozen_modules := ord(aValue);
end;

procedure TPyConfig311.Set_use_hash_seed(aValue: boolean);
begin
  FConfig.use_hash_seed := ord(aValue);
end;

procedure TPyConfig311.Set_user_site_directory(aValue: boolean);
begin
  FConfig.user_site_directory := ord(aValue);
end;

procedure TPyConfig311.Set_verbose(aValue: TPyVerboseMode);
begin
  FConfig.verbose := integer(aValue);
end;

procedure TPyConfig311.Set_warn_default_encoding(aValue: boolean);
begin
  FConfig.warn_default_encoding := ord(aValue);
end;

procedure TPyConfig311.Set_warnoptions(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.warnoptions, TempSL);
  TempSL.Free;
end;

procedure TPyConfig311.Set_write_bytecode(aValue: boolean);
begin
  FConfig.write_bytecode := ord(aValue);
end;

procedure TPyConfig311.Set_xoptions(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.xoptions, TempSL);
  TempSL.Free;
end;
{$ENDREGION}

{$REGION 'TPyConfig310'}
function TPyConfig310.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyConfig310.Get_argv: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.argv, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig310.Get_base_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_exec_prefix));
end;

function TPyConfig310.Get_base_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_executable));
end;

function TPyConfig310.Get_base_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_prefix));
end;

function TPyConfig310.Get_buffered_stdio: boolean;
begin
  Result := (FConfig.buffered_stdio <> 0);
end;

function TPyConfig310.Get_bytes_warning: integer;
begin
  Result := FConfig.bytes_warning;
end;

function TPyConfig310.Get_check_hash_pycs_mode: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.check_hash_pycs_mode));
end;

function TPyConfig310.Get_configure_c_stdio: boolean;
begin
  Result := (FConfig.configure_c_stdio <> 0);
end;

function TPyConfig310.Get_dev_mode: boolean;
begin
  Result := (FConfig.dev_mode <> 0);
end;

function TPyConfig310.Get_dump_refs: boolean;
begin
  Result := (FConfig.dump_refs <> 0);
end;

function TPyConfig310.Get_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.exec_prefix));
end;

function TPyConfig310.Get_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.executable));
end;

function TPyConfig310.Get_faulthandler: integer;
begin
  Result := FConfig.faulthandler;
end;

function TPyConfig310.Get_filesystem_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_encoding));
end;

function TPyConfig310.Get_filesystem_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_errors));
end;

function TPyConfig310.Get_hash_seed: uint64;
begin
  Result := FConfig.hash_seed;
end;

function TPyConfig310.Get_home: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.home));
end;

function TPyConfig310.Get_import_time: integer;
begin
  Result := FConfig.import_time;
end;

function TPyConfig310.Get_inspect: boolean;
begin
  Result := (FConfig.inspect <> 0);
end;

function TPyConfig310.Get_install_signal_handlers: boolean;
begin
  Result := (FConfig.install_signal_handlers <> 0);
end;

function TPyConfig310.Get_interactive: boolean;
begin
  Result := (FConfig.interactive <> 0);
end;

function TPyConfig310.Get_isolated: boolean;
begin
  Result := (FConfig.isolated <> 0);
end;

function TPyConfig310.Get_legacy_windows_stdio: boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := (FConfig.legacy_windows_stdio <> 0);
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

function TPyConfig310.Get_malloc_stats: boolean;
begin
  Result := (FConfig.malloc_stats <> 0);
end;

function TPyConfig310.Get_module_search_paths: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.module_search_paths, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig310.Get_module_search_paths_set: boolean;
begin
  Result := (FConfig.module_search_paths_set <> 0);
end;

function TPyConfig310.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := TPyOptimizationLevel(FConfig.optimization_level);
end;

function TPyConfig310.Get_orig_argv: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.orig_argv, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig310.Get_parse_argv: boolean;
begin
  Result := (FConfig.parse_argv <> 0);
end;

function TPyConfig310.Get_parser_debug: boolean;
begin
  Result := (FConfig.parser_debug <> 0);
end;

function TPyConfig310.Get_pathconfig_warnings: boolean;
begin
  Result := (FConfig.pathconfig_warnings <> 0);
end;

function TPyConfig310.Get_platlibdir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.platlibdir));
end;

function TPyConfig310.Get_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.prefix));
end;

function TPyConfig310.Get_program_name: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.program_name));
end;

function TPyConfig310.Get_pycache_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pycache_prefix));
end;

function TPyConfig310.Get_pythonpath_env: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pythonpath_env));
end;

function TPyConfig310.Get_quiet: boolean;
begin
  Result := (FConfig.quiet <> 0);
end;

function TPyConfig310.Get_run_command: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_command));
end;

function TPyConfig310.Get_run_filename: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_filename));
end;

function TPyConfig310.Get_run_module: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_module));
end;

function TPyConfig310.Get_show_ref_count: boolean;
begin
  Result := (FConfig.show_ref_count <> 0);
end;

function TPyConfig310.Get_site_import: boolean;
begin
  Result := (FConfig.site_import <> 0);
end;

function TPyConfig310.Get_skip_source_first_line: boolean;
begin
  Result := (FConfig.skip_source_first_line <> 0);
end;

function TPyConfig310.Get_stdio_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_encoding));
end;

function TPyConfig310.Get_stdio_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_errors));
end;

function TPyConfig310.Get_tracemalloc: boolean;
begin
  Result := (FConfig.tracemalloc <> 0);
end;

function TPyConfig310.Get_use_environment: boolean;
begin
  Result := (FConfig.use_environment <> 0);
end;

function TPyConfig310.Get_use_hash_seed: boolean;
begin
  Result := (FConfig.use_hash_seed <> 0);
end;

function TPyConfig310.Get_user_site_directory: boolean;
begin
  Result := (FConfig.user_site_directory <> 0);
end;

function TPyConfig310.Get_verbose: TPyVerboseMode;
begin
  Result := TPyVerboseMode(FConfig.verbose);
end;

function TPyConfig310.Get_warn_default_encoding: boolean;
begin
  Result := (FConfig.warn_default_encoding <> 0);
end;

function TPyConfig310.Get_warnoptions: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.warnoptions, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig310.Get_write_bytecode: boolean;
begin
  Result := (FConfig.write_bytecode <> 0);
end;

function TPyConfig310.Get_xoptions: string;
var
  TempSL : TStringList;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.xoptions, TempSL) then
    Result := TempSL.CommaText
   else
    Result := '';

  TempSL.Free;
end;

procedure TPyConfig310.Set_argv(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetArgv(TempSL);
  TempSL.Free;
end;

procedure TPyConfig310.Set_base_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_exec_prefix, aValue);
end;

procedure TPyConfig310.Set_base_executable(const aValue: string);
begin
  SetWCharT(FConfig.base_executable, aValue);
end;

procedure TPyConfig310.Set_base_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_prefix, aValue);
end;

procedure TPyConfig310.Set_buffered_stdio(aValue: boolean);
begin
  FConfig.buffered_stdio := ord(aValue);
end;

procedure TPyConfig310.Set_bytes_warning(aValue: integer);
begin
  FConfig.bytes_warning := aValue;
end;

procedure TPyConfig310.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetWCharT(FConfig.check_hash_pycs_mode, aValue);
end;

procedure TPyConfig310.Set_configure_c_stdio(aValue: boolean);
begin
  FConfig.configure_c_stdio := ord(aValue);
end;

procedure TPyConfig310.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    FConfig.dev_mode := -1
   else
    FConfig.dev_mode := 0;
end;

procedure TPyConfig310.Set_dump_refs(aValue: boolean);
begin
  FConfig.dump_refs := ord(aValue);
end;

procedure TPyConfig310.Set_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.exec_prefix, aValue);
end;

procedure TPyConfig310.Set_executable(const aValue: string);
begin
  SetWCharT(FConfig.executable, aValue);
end;

procedure TPyConfig310.Set_faulthandler(aValue: integer);
begin
  FConfig.faulthandler := aValue;
end;

procedure TPyConfig310.Set_filesystem_encoding(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_encoding, aValue);
end;

procedure TPyConfig310.Set_filesystem_errors(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_errors, aValue);
end;

procedure TPyConfig310.Set_hash_seed(aValue: uint64);
begin
  FConfig.hash_seed := aValue;
end;

procedure TPyConfig310.Set_home(const aValue: string);
begin
  SetWCharT(FConfig.home, aValue);
end;

procedure TPyConfig310.Set_import_time(aValue: integer);
begin
  FConfig.import_time := aValue;
end;

procedure TPyConfig310.Set_inspect(aValue: boolean);
begin
  FConfig.inspect := ord(aValue);
end;

procedure TPyConfig310.Set_install_signal_handlers(aValue: boolean);
begin
  FConfig.install_signal_handlers := ord(aValue);
end;

procedure TPyConfig310.Set_interactive(aValue: boolean);
begin
  FConfig.interactive := ord(aValue);
end;

procedure TPyConfig310.Set_isolated(aValue: boolean);
begin
  FConfig.isolated := ord(aValue);
end;

procedure TPyConfig310.Set_legacy_windows_stdio(aValue: boolean);
begin
  {$IFDEF MSWINDOWS}
  FConfig.legacy_windows_stdio := ord(aValue);
  {$ENDIF}
end;

procedure TPyConfig310.Set_malloc_stats(aValue: boolean);
begin
  FConfig.malloc_stats := ord(aValue);
end;

procedure TPyConfig310.Set_module_search_paths(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.module_search_paths, TempSL);
  TempSL.Free;
end;

procedure TPyConfig310.Set_module_search_paths_set(aValue: boolean);
begin
  FConfig.module_search_paths_set := ord(aValue);
end;

procedure TPyConfig310.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  FConfig.optimization_level := integer(aValue);
end;

procedure TPyConfig310.Set_orig_argv(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.orig_argv, TempSL);
  TempSL.Free;
end;

procedure TPyConfig310.Set_parse_argv(aValue: boolean);
begin
  FConfig.parse_argv := ord(aValue);
end;

procedure TPyConfig310.Set_parser_debug(aValue: boolean);
begin
  FConfig.parser_debug := ord(aValue);
end;

procedure TPyConfig310.Set_pathconfig_warnings(aValue: boolean);
begin
  FConfig.pathconfig_warnings := ord(aValue);
end;

procedure TPyConfig310.Set_platlibdir(const aValue: string);
begin
  SetWCharT(FConfig.platlibdir, aValue);
end;

procedure TPyConfig310.Set_prefix(const aValue: string);
begin
  SetWCharT(FConfig.prefix, aValue);
end;

procedure TPyConfig310.Set_program_name(const aValue: string);
begin
  SetWCharT(FConfig.program_name, aValue);
end;

procedure TPyConfig310.Set_pycache_prefix(const aValue: string);
begin
  SetWCharT(FConfig.pycache_prefix, aValue);
end;

procedure TPyConfig310.Set_pythonpath_env(const aValue: string);
begin
  SetWCharT(FConfig.pythonpath_env, aValue);
end;

procedure TPyConfig310.Set_quiet(aValue: boolean);
begin
  FConfig.quiet := ord(aValue);
end;

procedure TPyConfig310.Set_run_command(const aValue: string);
begin
  SetWCharT(FConfig.run_command, aValue);
end;

procedure TPyConfig310.Set_run_filename(const aValue: string);
begin
  SetWCharT(FConfig.run_filename, aValue);
end;

procedure TPyConfig310.Set_run_module(const aValue: string);
begin
  SetWCharT(FConfig.run_module, aValue);
end;

procedure TPyConfig310.Set_show_ref_count(aValue: boolean);
begin
  FConfig.show_ref_count := ord(aValue);
end;

procedure TPyConfig310.Set_site_import(aValue: boolean);
begin
  FConfig.site_import := ord(aValue);
end;

procedure TPyConfig310.Set_skip_source_first_line(aValue: boolean);
begin
  FConfig.skip_source_first_line := ord(aValue);
end;

procedure TPyConfig310.Set_stdio_encoding(const aValue: string);
begin
  SetWCharT(FConfig.stdio_encoding, aValue);
end;

procedure TPyConfig310.Set_stdio_errors(const aValue: string);
begin
  SetWCharT(FConfig.stdio_errors, aValue);
end;

procedure TPyConfig310.Set_tracemalloc(aValue: boolean);
begin
  if aValue then
    FConfig.tracemalloc := -1
   else
    FConfig.tracemalloc := 0;
end;

procedure TPyConfig310.Set_use_environment(aValue: boolean);
begin
  FConfig.use_environment := ord(aValue);
end;

procedure TPyConfig310.Set_use_hash_seed(aValue: boolean);
begin
  FConfig.use_hash_seed := ord(aValue);
end;

procedure TPyConfig310.Set_user_site_directory(aValue: boolean);
begin
  FConfig.user_site_directory := ord(aValue);
end;

procedure TPyConfig310.Set_verbose(aValue: TPyVerboseMode);
begin
  FConfig.verbose := integer(aValue);
end;

procedure TPyConfig310.Set_warn_default_encoding(aValue: boolean);
begin
  FConfig.warn_default_encoding := ord(aValue);
end;

procedure TPyConfig310.Set_warnoptions(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.warnoptions, TempSL);
  TempSL.Free;
end;

procedure TPyConfig310.Set_write_bytecode(aValue: boolean);
begin
  FConfig.write_bytecode := ord(aValue);
end;

procedure TPyConfig310.Set_xoptions(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL           := TStringList.Create;
  TempSL.CommaText := aValue;
  SetWideStringList(FConfig.xoptions, TempSL);
  TempSL.Free;
end;
{$ENDREGION}

{$REGION 'TPyConfigBuilder'}
class function TPyConfigBuilder.New(aMajor, aMinor: integer): IPyConfig;
begin
  Result := nil;
  case aMajor of
    3:
      case aMinor of
        14: Result := TPyConfig314.Create;
        13: Result := TPyConfig313.Create;
        12: Result := TPyConfig312.Create;
        11: Result := TPyConfig311.Create;
        10: Result := TPyConfig310.Create;
      end;
  end;
end;
{$ENDREGION}


end.
