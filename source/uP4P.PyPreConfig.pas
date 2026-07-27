unit uP4P.PyPreConfig;

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
  /// <summary>
  /// Class used to preinitialize Python.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#pypreconfig">See the article about PyPreConfig.</see></para>
  /// </remarks>
  TPyPreConfig = class(TInterfacedObject, IPyPreConfig)
    protected
      FConfig      : PyPreConfig;
      FInitialized : boolean;

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

    public
      constructor Create;

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
      /// Helper function to check if an IPyPreConfig instance is fully initialized.
      /// </summary>
      class function  IsInitialized(const aPyPreConfig: IPyPreConfig): boolean; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}

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

implementation

constructor TPyPreConfig.Create;
begin
  inherited Create;

  FInitialized := False;
end;

class function TPyPreConfig.IsInitialized(const aPyPreConfig: IPyPreConfig): boolean;
begin
  Result := assigned(aPyPreConfig) and aPyPreConfig.Initialized;
end;

procedure TPyPreConfig.InitPythonConfig;
begin
  if assigned(PyPreConfig_InitPythonConfig) then
    begin
      PyPreConfig_InitPythonConfig(Config);
      FInitialized := True;
    end;
end;

procedure TPyPreConfig.InitIsolatedConfig;
begin
  if assigned(PyPreConfig_InitIsolatedConfig) then
    begin
      PyPreConfig_InitIsolatedConfig(Config);
      FInitialized := True;
    end;
end;

function TPyPreConfig.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyPreConfig.GetInitialized: boolean;
begin
  Result := FInitialized;
end;

function TPyPreConfig.Get_parse_argv: boolean;
begin
  Result := (FConfig.parse_argv <> 0);
end;

function TPyPreConfig.Get_isolated: boolean;
begin
  Result := FConfig.isolated <> 0;
end;

function TPyPreConfig.Get_use_environment: boolean;
begin
  Result := FConfig.use_environment <> 0;
end;

function TPyPreConfig.Get_configure_locale: boolean;
begin
  Result := FConfig.configure_locale <> 0;
end;

function TPyPreConfig.Get_coerce_c_locale: integer;
begin
  Result := FConfig.coerce_c_locale;
end;

function TPyPreConfig.Get_coerce_c_locale_warn: boolean;
begin
  Result := FConfig.coerce_c_locale_warn <> 0;
end;

{$IFDEF MSWINDOWS}
function TPyPreConfig.Get_legacy_windows_fs_encoding: boolean;
begin
  Result := FConfig.legacy_windows_fs_encoding <> 0;
end;
{$ENDIF}

function TPyPreConfig.Get_utf8_mode: integer;
begin
  Result := FConfig.utf8_mode;
end;

function TPyPreConfig.Get_dev_mode: boolean;
begin
  Result := FConfig.dev_mode <> 0;
end;

function TPyPreConfig.Get_allocator: PyMemAllocatorName;
begin
  Result := PyMemAllocatorName(FConfig.allocator);
end;

procedure TPyPreConfig.Set_parse_argv(aValue: boolean);
begin
  FConfig.parse_argv := ord(aValue);
end;

procedure TPyPreConfig.Set_isolated(aValue: boolean);
begin
  FConfig.isolated := ord(aValue);
end;

procedure TPyPreConfig.Set_use_environment(aValue: boolean);
begin
  FConfig.use_environment := ord(aValue);
end;

procedure TPyPreConfig.Set_configure_locale(aValue: boolean);
begin
  FConfig.configure_locale := ord(aValue);
end;

procedure TPyPreConfig.Set_coerce_c_locale(aValue: integer);
begin
  FConfig.coerce_c_locale := aValue;
end;

procedure TPyPreConfig.Set_coerce_c_locale_warn(aValue: boolean);
begin
  if aValue then
    FConfig.coerce_c_locale_warn := -1
   else
    FConfig.coerce_c_locale_warn := 0;
end;

{$IFDEF MSWINDOWS}
procedure TPyPreConfig.Set_legacy_windows_fs_encoding(aValue: boolean);
begin
  if aValue then
    FConfig.legacy_windows_fs_encoding := -1
   else
    FConfig.legacy_windows_fs_encoding := 0;
end;
{$ENDIF}

procedure TPyPreConfig.Set_utf8_mode(aValue: integer);
begin
  FConfig.utf8_mode := aValue;
end;

procedure TPyPreConfig.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    FConfig.dev_mode := -1
   else
    FConfig.dev_mode := 0;
end;

procedure TPyPreConfig.Set_allocator(aValue: PyMemAllocatorName);
begin
  FConfig.allocator := integer(aValue);
end;

end.
