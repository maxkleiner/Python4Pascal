unit uP4P.PyInitConfig;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.Types,
  {$ELSE}
    Classes, SysUtils, Types,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces;

type
  TPyInitConfig = class(TInterfacedObject, IPyInitConfig)
    protected
      FConfig : PPyInitConfig;

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

      function HasOption(const aOption: string): boolean;
      function GetInt(const aName: string; var aValue: int64): boolean;
      function GetStr(const aName: string; var aValue: string): boolean;
      function GetStrList(const aName: string; var aItems: TStringList): boolean; overload;
      function GetStrList(const aName: string; var aItems: TStringDynArray): boolean; overload;
      function SetInt(const aName: string; aValue: int64): boolean;
      function SetStr(const aName, aValue: string): boolean;
      function SetStrList(const aName: string; const aItems: TStringList): boolean; overload;
      function SetStrList(const aName: string; const aItems: TStringDynArray): boolean; overload;
      function AddModule(const aName: string; initfunc_: initfunc): boolean;

      property Initialized     : boolean      read GetInitialized;
      property Config          : Pointer      read GetConfig;

    public
      constructor Create;
      destructor  Destroy; override;

      class function  CreateInitConfig: PPyInitConfig;
      class procedure FreeInitConfig(var config_: PPyInitConfig);
      class function  IsInitialized(const config_: IPyInitConfig): boolean; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}

      property Error                      : string                 read GetError;
      property ExitCode                   : integer                read GetExitCode;

      property allocator                  : PyMemAllocatorName     read Get_allocator                      write Set_allocator;
      property argv                       : TStringDynArray        read Get_argv                           write Set_argv;
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
      {$IFDEF MSWINDOWS}
      property legacy_windows_fs_encoding : boolean                read Get_legacy_windows_fs_encoding     write Set_legacy_windows_fs_encoding;
      property legacy_windows_stdio       : boolean                read Get_legacy_windows_stdio           write Set_legacy_windows_stdio;
      {$ENDIF}
      property malloc_stats               : boolean                read Get_malloc_stats                   write Set_malloc_stats;
      property module_search_paths        : string                 read Get_module_search_paths            write Set_module_search_paths;
      property optimization_level         : TPyOptimizationLevel   read Get_optimization_level             write Set_optimization_level;
      property orig_argv                  : TStringDynArray        read Get_orig_argv                      write Set_orig_argv;
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
      property warnoptions                : TStringDynArray        read Get_warnoptions                    write Set_warnoptions;
      property write_bytecode             : boolean                read Get_write_bytecode                 write Set_write_bytecode;
      property xoptions                   : TStringDynArray        read Get_xoptions                       write Set_xoptions;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyMem;

constructor TPyInitConfig.Create;
begin
  inherited Create;

  FConfig := CreateInitConfig();
end;

destructor TPyInitConfig.Destroy;
begin
  FreeInitConfig(FConfig);

  inherited Destroy;
end;

class function TPyInitConfig.CreateInitConfig: PPyInitConfig;
begin
  if assigned(PyInitConfig_Create) then
    Result := PyInitConfig_Create()
   else
    Result := nil;
end;

class procedure TPyInitConfig.FreeInitConfig(var config_: PPyInitConfig);
begin
  if assigned(PyInitConfig_Free) and
     assigned(config_) then
    begin
      PyInitConfig_Free(config_);
      config_ := nil;
    end;
end;

class function TPyInitConfig.IsInitialized(const config_: IPyInitConfig): boolean;
begin
  Result := assigned(config_) and config_.Initialized;
end;

function TPyInitConfig.GetConfig: Pointer;
begin
  Result := FConfig;
end;

function TPyInitConfig.GetInitialized: boolean;
begin
  Result := assigned(FConfig);
end;

function TPyInitConfig.GetError: string;
var
  TempString : PAnsiChar;
begin
  if Initialized and
     assigned(PyInitConfig_GetError) and
     (PyInitConfig_GetError(FConfig, TempString) <> 0) then
    Result := PyUTF8ToString(TempString)
   else
    Result := '';
end;

function TPyInitConfig.GetExitCode: integer;
var
  TempInt : integer;
begin
  if Initialized and
     assigned(PyInitConfig_GetExitCode) and
     (PyInitConfig_GetExitCode(FConfig, TempInt) = 1) then
    Result := TempInt
   else
    Result := 0;
end;

function TPyInitConfig.HasOption(const aOption: string): boolean;
var
  TempName : AnsiString;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_HasOption) and
     (length(aOption) > 0) then
    begin
      TempName := StringToPyUTF8(aOption);
      Result   := (PyInitConfig_HasOption(FConfig, PAnsiChar(TempName)) <> 0);
    end;
end;

function TPyInitConfig.GetInt(const aName: string; var aValue: int64): boolean;
var
  TempName : AnsiString;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_GetInt) and
     (length(aName) > 0) then
    begin
      TempName := StringToPyUTF8(aName);
      Result   := (PyInitConfig_GetInt(FConfig, PAnsiChar(TempName), aValue) = 0);
    end;
end;

function TPyInitConfig.GetStr(const aName: string; var aValue: string): boolean;
var
  TempName  : AnsiString;
  TempValue : PAnsiChar;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_GetStr) and
     (length(aName) > 0) then
    begin
      TempName  := StringToPyUTF8(aName);
      TempValue := nil;

      if (PyInitConfig_GetStr(FConfig, PAnsiChar(TempName), TempValue) = 0) then
        begin
          Result := True;

          if assigned(TempValue) then
            begin
              aValue := PyUTF8ToString(TempValue);
              TPyMem.Free(TempValue);
            end;
        end;
    end;
end;

function TPyInitConfig.GetStrList(const aName: string; var aItems: TStringList): boolean;
var
  TempName : AnsiString;
  TempItems : PPAnsiChar;
  TempItem : PAnsiChar;
  TempLen, i : NativeUInt;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_GetStrList) and
     assigned(PyInitConfig_FreeStrList) and
     assigned(aItems) and
     (length(aName) > 0) then
    begin
      TempName  := StringToPyUTF8(aName);
      TempLen   := 0;
      TempItems := nil;

      if (PyInitConfig_GetStrList(FConfig, PAnsiChar(TempName), TempLen, TempItems) = 0) then
        begin
          aItems.Clear;
          Result := True;

          if assigned(TempItems) then
            begin
              i := 0;
              while (i < TempLen) do
                begin
                  TempItem := TempItems^;
                  aItems.Add(PyUTF8ToString(TempItem));
                  inc(TempItems);
                  inc(i);
                end;

              Dec(TempItems, aItems.Count);
              PyInitConfig_FreeStrList(TempLen, TempItems);
            end;
        end;
    end;
end;

function TPyInitConfig.GetStrList(const aName: string; var aItems: TStringDynArray): boolean;
var
  TempName : AnsiString;
  TempItems : PPAnsiChar;
  TempItem : PAnsiChar;
  TempLen, i : NativeUInt;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_GetStrList) and
     assigned(PyInitConfig_FreeStrList) and
     assigned(aItems) and
     (length(aName) > 0) then
    begin
      TempName  := StringToPyUTF8(aName);
      TempLen   := 0;
      TempItems := nil;

      if (PyInitConfig_GetStrList(FConfig, PAnsiChar(TempName), TempLen, TempItems) = 0) then
        begin
          Result := True;

          if assigned(TempItems) then
            begin
              SetLength(aItems, TempLen);

              i := 0;
              while (i < TempLen) do
                begin
                  TempItem  := TempItems^;
                  aItems[i] := PyUTF8ToString(TempItem);
                  inc(TempItems);
                  inc(i);
                end;

              Dec(TempItems, TempLen);
              PyInitConfig_FreeStrList(TempLen, TempItems);
            end;
        end;
    end;
end;

function TPyInitConfig.SetInt(const aName: string; aValue: int64): boolean;
var
  TempString : AnsiString;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_SetInt) and
     (length(aName) > 0) then
    begin
      TempString := StringToPyUTF8(aName);
      Result     := (PyInitConfig_SetInt(FConfig, PAnsiChar(TempString), aValue) = 0);
    end;
end;

function TPyInitConfig.SetStr(const aName, aValue: string): boolean;
var
  TempName, TempValue : AnsiString;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_SetStr) and
     (length(aName)  > 0) and
     (length(aValue) > 0) then
    begin
      TempName  := StringToPyUTF8(aName);
      TempValue := StringToPyUTF8(aValue);
      Result    := (PyInitConfig_SetStr(FConfig, PAnsiChar(TempName), PAnsiChar(TempValue)) = 0);
    end;
end;

function TPyInitConfig.SetStrList(const aName: string; const aItems: TStringList): boolean;
var
  TempName : AnsiString;
  TempItems : array of AnsiString;
  TempItemsPtr : array of PAnsiString;
  i : integer;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_SetStrList) and
     (length(aName) > 0) and
     assigned(aItems) and
     (aItems.Count > 0) then
    begin
      TempName := StringToPyUTF8(aName);

      SetLength(TempItems,    aItems.Count);
      SetLength(TempItemsPtr, aItems.Count);

      for i := 0 to pred(aItems.Count) do
        begin
          TempItems[i]    := StringToPyUTF8(aItems[i]);
          TempItemsPtr[i] := PAnsiString(TempItems[i]);
        end;

       Result := (PyInitConfig_SetStrList(FConfig, PAnsiChar(TempName), aItems.Count, @TempItemsPtr[0]) = 0);
    end;
end;

function TPyInitConfig.SetStrList(const aName: string; const aItems: TStringDynArray): boolean;
var
  TempName : AnsiString;
  TempItems : array of AnsiString;
  TempItemsPtr : array of PAnsiString;
  i, TempLen : NativeUInt;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_SetStrList) and
     (length(aName) > 0) and
     assigned(aItems) and
     (length(aItems) > 0) then
    begin
      TempLen  := length(aItems);
      TempName := StringToPyUTF8(aName);

      SetLength(TempItems,    TempLen);
      SetLength(TempItemsPtr, TempLen);

      for i := 0 to pred(TempLen) do
        begin
          TempItems[i]    := StringToPyUTF8(aItems[i]);
          TempItemsPtr[i] := PAnsiString(TempItems[i]);
        end;

       Result := (PyInitConfig_SetStrList(FConfig, PAnsiChar(TempName), TempLen, @TempItemsPtr[0]) = 0);
    end;
end;

function TPyInitConfig.AddModule(const aName: string; initfunc_: initfunc): boolean;
var
  TempString : AnsiString;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_AddModule) and
     (length(aName) > 0) then
    begin
      TempString := StringToPyUTF8(aName);
      Result     := (PyInitConfig_AddModule(FConfig, PAnsiChar(TempString), initfunc_) = 0);
    end;
end;

function TPyInitConfig.Get_allocator: PyMemAllocatorName;
var
  TempResult : int64;
begin
  if GetInt(PYINITCONFIGOPTION_ALLOCATOR, TempResult) then
    Result := PyMemAllocatorName(TempResult)
   else
    Result := PYMEM_ALLOCATOR_NOT_SET;
end;

function TPyInitConfig.Get_argv: TStringDynArray;
begin
  GetStrList(PYINITCONFIGOPTION_ARGV, Result);
end;

function TPyInitConfig.Get_base_exec_prefix: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_BASE_EXEC_PREFIX, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_base_executable: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_BASE_EXECUTABLE, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_base_prefix: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_BASE_PREFIX, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_buffered_stdio: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_BUFFERED_STDIO, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_bytes_warning: int64;
var
  TempResult : int64;
begin
  if GetInt(PYINITCONFIGOPTION_BYTES_WARNING, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_check_hash_pycs_mode: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_CHECK_HASH_PYCS_MODE, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_code_debug_ranges: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_CODE_DEBUG_RANGES, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_coerce_c_locale: integer;
var
  TempResult : int64;
begin
  if GetInt(PYINITCONFIGOPTION_COERCE_C_LOCALE, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_coerce_c_locale_warn: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_COERCE_C_LOCALE_WARN, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_configure_c_stdio: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_CONFIGURE_C_STDIO, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_configure_locale: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_CONFIGURE_LOCALE, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_cpu_count: int64;
var
  TempResult : int64;
begin
  if GetInt(PYINITCONFIGOPTION_CPU_COUNT, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_dev_mode: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_DEV_MODE, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_dump_refs: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_DUMP_REFS, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_dump_refs_file: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_DUMP_REFS_FILE, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_exec_prefix: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_EXEC_PREFIX, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_executable: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_EXECUTABLE, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_faulthandler: int64;
var
  TempResult : int64;
begin
  if GetInt(PYINITCONFIGOPTION_FAULTHANDLER, TempResult) then
    Result := TempResult
   else
    REsult := 0;
end;

function TPyInitConfig.Get_filesystem_encoding: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_FILESYSTEM_ENCODING, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_filesystem_errors: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_FILESYSTEM_ERRORS, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_hash_seed: int64;
var
  TempResult : int64;
begin
  if GetInt(PYINITCONFIGOPTION_HASH_SEED, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_home: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_HOME, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_import_time: int64;
var
  TempResult : int64;
begin
  if GetInt(PYINITCONFIGOPTION_IMPORT_TIME, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_inspect: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_INSPECT, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_install_signal_handlers: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_INSTALL_SIGNAL_HANDLERS, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_int_max_str_digits: int64;
var
  TempResult : int64;
begin
  if GetInt(PYINITCONFIGOPTION_INT_MAX_STR_DIGITS, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_interactive: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_INTERACTIVE, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_isolated: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_ISOLATED, TempResult) and
            (TempResult <> 0);
end;

{$IFDEF MSWINDOWS}
function TPyInitConfig.Get_legacy_windows_fs_encoding: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_LEGACY_WINDOWS_FS_ENCODING, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_legacy_windows_stdio: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_LEGACY_WINDOWS_STDIO, TempResult) and
            (TempResult <> 0);
end;
{$ENDIF}

function TPyInitConfig.Get_malloc_stats: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_MALLOC_STATS, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_module_search_paths: string;
var
  TempSL : TStringList;
  i      : integer;
begin
  TempSL := TStringList.Create;

  if GetStrList(PYINITCONFIGOPTION_MODULE_SEARCH_PATHS, TempSL) then
    begin
      i := 0;
      while (i < TempSL.Count) do
        begin
          if (i = 0) then
            Result := TempSL[i]
           else
            Result := Result + PathSep + TempSL[i];

          inc(i);
        end;
    end
   else
    Result := '';

  TempSL.Free;
end;

function TPyInitConfig.Get_optimization_level: TPyOptimizationLevel;
var
  TempResult : int64;
begin
  if GetInt(PYINITCONFIGOPTION_OPTIMIZATION_LEVEL, TempResult) then
    Result := TPyOptimizationLevel(TempResult)
   else
    Result := polDebug;
end;

function TPyInitConfig.Get_orig_argv: TStringDynArray;
begin
  GetStrList(PYINITCONFIGOPTION_ORIG_ARGV, Result);
end;

function TPyInitConfig.Get_parse_argv: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_PARSE_ARGV, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_parser_debug: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_PARSER_DEBUG, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_pathconfig_warnings: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_PATHCONFIG_WARNINGS, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_perf_profiling: int64;
var
  TempResult : int64;
begin
  if GetInt(PYINITCONFIGOPTION_PERF_PROFILING, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_platlibdir: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_PLATLIBDIR, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_prefix: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_PREFIX, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_program_name: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_PROGRAM_NAME, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_pycache_prefix: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_PYCACHE_PREFIX, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_quiet: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_QUIET, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_run_command: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_RUN_COMMAND, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_run_filename: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_RUN_FILENAME, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_run_module: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_RUN_MODULE, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_run_presite: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_RUN_PRESITE, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_safe_path: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_SAFE_PATH, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_show_ref_count: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_SHOW_REF_COUNT, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_site_import: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_SITE_IMPORT, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_skip_source_first_line: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_SKIP_SOURCE_FIRST_LINE, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_stdio_encoding: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_STDIO_ENCODING, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_stdio_errors: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_STDIO_ERRORS, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_stdlib_dir: string;
var
  TempResult : string;
begin
  if GetStr(PYINITCONFIGOPTION_STDLIB_DIR, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_tracemalloc: int64;
var
  TempResult : int64;
begin
  if GetInt(PYINITCONFIGOPTION_TRACEMALLOC, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_use_environment: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_USE_ENVIRONMENT, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_use_frozen_modules: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_USE_FROZEN_MODULES, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_use_hash_seed: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_USE_HASH_SEED, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_use_system_logger: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_USE_SYSTEM_LOGGER, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_user_site_directory: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_USER_SITE_DIRECTORY, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_utf8_mode: integer;
var
  TempResult : int64;
begin
  if GetInt(PYINITCONFIGOPTION_UTF8_MODE, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_verbose: TPyVerboseMode;
var
  TempResult : int64;
begin
  if GetInt(PYINITCONFIGOPTION_VERBOSE, TempResult) then
    Result := TPyVerboseMode(TempResult)
   else
    Result := pvmDisabled;
end;

function TPyInitConfig.Get_warn_default_encoding: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_WARN_DEFAULT_ENCODING, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_warnoptions: TStringDynArray;
begin
  GetStrList(PYINITCONFIGOPTION_WARNOPTIONS, Result);
end;

function TPyInitConfig.Get_write_bytecode: boolean;
var
  TempResult : int64;
begin
  Result := GetInt(PYINITCONFIGOPTION_WRITE_BYTECODE, TempResult) and
            (TempResult <> 0);
end;

function TPyInitConfig.Get_xoptions: TStringDynArray;
begin
  GetStrList(PYINITCONFIGOPTION_XOPTIONS, Result);
end;

procedure TPyInitConfig.Set_allocator(aValue: PyMemAllocatorName);
begin
  SetInt(PYINITCONFIGOPTION_ALLOCATOR, int64(aValue));
end;

procedure TPyInitConfig.Set_argv(const aValue: TStringDynArray);
begin
  SetStrList(PYINITCONFIGOPTION_ARGV, aValue);
end;

procedure TPyInitConfig.Set_base_exec_prefix(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_BASE_EXEC_PREFIX, aValue);
end;

procedure TPyInitConfig.Set_base_executable(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_BASE_EXECUTABLE, aValue);
end;

procedure TPyInitConfig.Set_base_prefix(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_BASE_PREFIX, aValue);
end;

procedure TPyInitConfig.Set_buffered_stdio(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_BUFFERED_STDIO, ord(aValue));
end;

procedure TPyInitConfig.Set_bytes_warning(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_BYTES_WARNING, aValue);
end;

procedure TPyInitConfig.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_CHECK_HASH_PYCS_MODE, aValue);
end;

procedure TPyInitConfig.Set_code_debug_ranges(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_CODE_DEBUG_RANGES, ord(aValue));
end;

procedure TPyInitConfig.Set_coerce_c_locale(aValue: integer);
begin
  SetInt(PYINITCONFIGOPTION_COERCE_C_LOCALE, aValue);
end;

procedure TPyInitConfig.Set_coerce_c_locale_warn(aValue: boolean);
begin
  if aValue then
    SetInt(PYINITCONFIGOPTION_COERCE_C_LOCALE_WARN, -1)
   else
    SetInt(PYINITCONFIGOPTION_COERCE_C_LOCALE_WARN, 0);
end;

procedure TPyInitConfig.Set_configure_c_stdio(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_CONFIGURE_C_STDIO, ord(aValue));
end;

procedure TPyInitConfig.Set_configure_locale(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_CONFIGURE_LOCALE, ord(aValue));
end;

procedure TPyInitConfig.Set_cpu_count(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_CPU_COUNT, aValue);
end;

procedure TPyInitConfig.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    SetInt(PYINITCONFIGOPTION_DEV_MODE, -1)
   else
    SetInt(PYINITCONFIGOPTION_DEV_MODE, 0);
end;

procedure TPyInitConfig.Set_dump_refs(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_DUMP_REFS, ord(aValue));
end;

procedure TPyInitConfig.Set_dump_refs_file(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_DUMP_REFS_FILE, aValue);
end;

procedure TPyInitConfig.Set_exec_prefix(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_EXEC_PREFIX, aValue);
end;

procedure TPyInitConfig.Set_executable(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_EXECUTABLE, aValue);
end;

procedure TPyInitConfig.Set_faulthandler(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_FAULTHANDLER, aValue);
end;

procedure TPyInitConfig.Set_filesystem_encoding(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_FILESYSTEM_ENCODING, aValue);
end;

procedure TPyInitConfig.Set_filesystem_errors(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_FILESYSTEM_ERRORS, aValue);
end;

procedure TPyInitConfig.Set_hash_seed(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_HASH_SEED, aValue);
end;

procedure TPyInitConfig.Set_home(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_HOME, aValue);
end;

procedure TPyInitConfig.Set_import_time(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_IMPORT_TIME, aValue);
end;

procedure TPyInitConfig.Set_inspect(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_INSPECT, ord(aValue));
end;

procedure TPyInitConfig.Set_install_signal_handlers(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_INSTALL_SIGNAL_HANDLERS, ord(aValue));
end;

procedure TPyInitConfig.Set_int_max_str_digits(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_INT_MAX_STR_DIGITS, aValue);
end;

procedure TPyInitConfig.Set_interactive(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_INTERACTIVE, ord(aValue));
end;

procedure TPyInitConfig.Set_isolated(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_ISOLATED, ord(aValue));
end;

{$IFDEF MSWINDOWS}
procedure TPyInitConfig.Set_legacy_windows_fs_encoding(aValue: boolean);
begin
  if aValue then
    SetInt(PYINITCONFIGOPTION_LEGACY_WINDOWS_FS_ENCODING, -1)
   else
    SetInt(PYINITCONFIGOPTION_LEGACY_WINDOWS_FS_ENCODING, 0);
end;

procedure TPyInitConfig.Set_legacy_windows_stdio(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_LEGACY_WINDOWS_STDIO, ord(aValue));
end;
{$ENDIF}

procedure TPyInitConfig.Set_malloc_stats(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_MALLOC_STATS, ord(aValue));
end;

procedure TPyInitConfig.Set_module_search_paths(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL      := TStringList.Create;
  TempSL.Text := StringReplace(aValue, PathSep, #13, [rfReplaceAll]);
  SetStrList(PYINITCONFIGOPTION_MODULE_SEARCH_PATHS, TempSL);
  TempSL.Free;
end;

procedure TPyInitConfig.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  SetInt(PYINITCONFIGOPTION_OPTIMIZATION_LEVEL, int64(aValue));
end;

procedure TPyInitConfig.Set_orig_argv(const aValue: TStringDynArray);
begin
  SetStrList(PYINITCONFIGOPTION_ORIG_ARGV, aValue);
end;

procedure TPyInitConfig.Set_parse_argv(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_PARSE_ARGV, ord(aValue));
end;

procedure TPyInitConfig.Set_parser_debug(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_PARSER_DEBUG, ord(aValue));
end;

procedure TPyInitConfig.Set_pathconfig_warnings(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_PATHCONFIG_WARNINGS, ord(aValue));
end;

procedure TPyInitConfig.Set_perf_profiling(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_PERF_PROFILING, aValue);
end;

procedure TPyInitConfig.Set_platlibdir(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_PLATLIBDIR, aValue);
end;

procedure TPyInitConfig.Set_prefix(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_PREFIX, aValue);
end;

procedure TPyInitConfig.Set_program_name(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_PROGRAM_NAME, aValue);
end;

procedure TPyInitConfig.Set_pycache_prefix(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_PYCACHE_PREFIX, aValue);
end;

procedure TPyInitConfig.Set_quiet(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_QUIET, ord(aValue));
end;

procedure TPyInitConfig.Set_run_command(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_RUN_COMMAND, aValue);
end;

procedure TPyInitConfig.Set_run_filename(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_RUN_FILENAME, aValue);
end;

procedure TPyInitConfig.Set_run_module(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_RUN_MODULE, aValue);
end;

procedure TPyInitConfig.Set_run_presite(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_RUN_PRESITE, aValue);
end;

procedure TPyInitConfig.Set_safe_path(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_SAFE_PATH, ord(aValue));
end;

procedure TPyInitConfig.Set_show_ref_count(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_SHOW_REF_COUNT, ord(aValue));
end;

procedure TPyInitConfig.Set_site_import(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_SITE_IMPORT, ord(aValue));
end;

procedure TPyInitConfig.Set_skip_source_first_line(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_SKIP_SOURCE_FIRST_LINE, ord(aValue));
end;

procedure TPyInitConfig.Set_stdio_encoding(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_STDIO_ENCODING, aValue);
end;

procedure TPyInitConfig.Set_stdio_errors(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_STDIO_ERRORS, aValue);
end;

procedure TPyInitConfig.Set_stdlib_dir(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_STDLIB_DIR, aValue);
end;

procedure TPyInitConfig.Set_tracemalloc(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_TRACEMALLOC, aValue);
end;

procedure TPyInitConfig.Set_use_environment(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_USE_ENVIRONMENT, ord(aValue));
end;

procedure TPyInitConfig.Set_use_frozen_modules(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_USE_FROZEN_MODULES, ord(aValue));
end;

procedure TPyInitConfig.Set_use_hash_seed(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_USE_HASH_SEED, ord(aValue));
end;

procedure TPyInitConfig.Set_use_system_logger(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_USE_SYSTEM_LOGGER, ord(aValue));
end;

procedure TPyInitConfig.Set_user_site_directory(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_USER_SITE_DIRECTORY, ord(aValue));
end;

procedure TPyInitConfig.Set_utf8_mode(aValue: integer);
begin
  SetInt(PYINITCONFIGOPTION_UTF8_MODE, aValue);
end;

procedure TPyInitConfig.Set_verbose(aValue: TPyVerboseMode);
begin
  SetInt(PYINITCONFIGOPTION_VERBOSE, int64(aValue));
end;

procedure TPyInitConfig.Set_warn_default_encoding(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_WARN_DEFAULT_ENCODING, ord(aValue));
end;

procedure TPyInitConfig.Set_warnoptions(const aValue: TStringDynArray);
begin
  SetStrList(PYINITCONFIGOPTION_WARNOPTIONS, aValue);
end;

procedure TPyInitConfig.Set_write_bytecode(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_WRITE_BYTECODE, ord(aValue));
end;

procedure TPyInitConfig.Set_xoptions(const aValue: TStringDynArray);
begin
  SetStrList(PYINITCONFIGOPTION_XOPTIONS, aValue);
end;

end.
