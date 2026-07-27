unit uP4P.PyInterpreterConfig;

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
  /// <para>Interface containing most parameters to configure a
  /// sub-interpreter.</para>
  /// <para>Its values are used only in TPy.NewInterpreterFromConfig() and never
  /// modified by the runtime.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/subinterpreters.html">See the Multiple interpreters in a Python process article.</see></para>
  /// </remarks>
  TPyInterpreterConfig = class(TInterfacedObject, IPyInterpreterConfig)
    protected
      FConfig : PyInterpreterConfig;

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

    public
      constructor Create;
      /// <summary>
      /// <para>Initial configuration values defined by the
      /// _PyInterpreterConfig_INIT macro.</para>
      /// </summary>
      procedure Init;
      /// <summary>
      /// <para>Pointer to PyInterpreterConfig.</para>
      /// </summary>
      property Config                        : Pointer                  read GetConfig;
      /// <summary>
      /// <para>If this is False then the sub-interpreter will use its own
      /// “object” allocator state.</para>
      /// <para>Otherwise it will use (share) the main interpreter's.</para>
      /// <para>If this is False then check_multi_interp_extensions must be True.
      /// If this is True then gil must not be gilOwn.</para>
      /// </summary>
      property use_main_obmalloc             : boolean                  read Get_use_main_obmalloc              write Set_use_main_obmalloc;
      /// <summary>
      /// <para>If this is False then the runtime will not support forking the
      /// process in any thread where the sub-interpreter is currently
      /// active.</para>
      /// <para>Otherwise fork is unrestricted.</para>
      /// <para>Note that the subprocess module still works when fork is
      /// disallowed.</para>
      /// </summary>
      property allow_fork                    : boolean                  read Get_allow_fork                     write Set_allow_fork;
      /// <summary>
      /// <para>If this is False then the runtime will not support replacing the
      /// current process via exec (e.g. os.execv()) in any thread where the
      /// sub-interpreter is currently active.</para>
      /// <para>Otherwise exec is unrestricted.</para>
      /// <para>Note that the subprocess module still works when exec is
      /// disallowed.</para>
      /// </summary>
      property allow_exec                    : boolean                  read Get_allow_exec                     write Set_allow_exec;
      /// <summary>
      /// <para>If this is False then the sub-interpreter's threading module won't
      /// create threads.</para>
      /// <para>Otherwise threads are allowed.</para>
      /// </summary>
      property allow_threads                 : boolean                  read Get_allow_threads                  write Set_allow_threads;
      /// <summary>
      /// <para>If this is False then the sub-interpreter's threading module won't
      /// create daemon threads.</para>
      /// <para>Otherwise daemon threads are allowed (as long as allow_threads is
      /// non-zero).</para>
      /// </summary>
      property allow_daemon_threads          : boolean                  read Get_allow_daemon_threads           write Set_allow_daemon_threads;
      /// <summary>
      /// <para>If this is False then all extension modules may be imported,
      /// including legacy (single-phase init) modules, in any thread where the
      /// sub-interpreter is currently active.</para>
      /// <para>Otherwise only multi-phase init extension modules (see PEP 489)
      /// may be imported. (Also see Py_mod_multiple_interpreters.)</para>
      /// <para>This must be True if use_main_obmalloc is True.</para>
      /// </summary>
      property check_multi_interp_extensions : boolean                  read Get_check_multi_interp_extensions  write Set_check_multi_interp_extensions;
      /// <summary>
      /// <para>This determines the operation of the GIL for the sub-interpreter.
      /// It may be one of the following:</para>
      /// <code>
      /// - gilDefault: Use the default selection (gilShared).
      /// - gilShared: Use (share) the main interpreter's GIL.
      /// - gilOwn: Use the sub-interpreter's own GIL.
      /// </code>
      /// <para>If this is gilOwn then use_main_obmalloc must be False.</para>
      /// </summary>
      property gil                           : TPyInterpreterCfgGIL     read Get_gil                            write Set_gil;
  end;

implementation

constructor TPyInterpreterConfig.Create;
begin
  inherited Create;

  FillChar(FConfig, SizeOf(PyInterpreterConfig), #0);
end;

procedure TPyInterpreterConfig.Init;
begin
  use_main_obmalloc             := False;
  allow_fork                    := False;
  allow_exec                    := False;
  allow_threads                 := True;
  allow_daemon_threads          := False;
  check_multi_interp_extensions := True;
  gil                           := gilOwn;
end;

function TPyInterpreterConfig.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyInterpreterConfig.Get_use_main_obmalloc: boolean;
begin
  Result := FConfig.use_main_obmalloc <> 0;
end;

function TPyInterpreterConfig.Get_allow_fork: boolean;
begin
  Result := FConfig.allow_fork <> 0;
end;

function TPyInterpreterConfig.Get_allow_exec: boolean;
begin
  Result := FConfig.allow_exec <> 0;
end;

function TPyInterpreterConfig.Get_allow_threads: boolean;
begin
  Result := FConfig.allow_threads <> 0;
end;

function TPyInterpreterConfig.Get_allow_daemon_threads: boolean;
begin
  Result := FConfig.allow_daemon_threads <> 0;
end;

function TPyInterpreterConfig.Get_check_multi_interp_extensions: boolean;
begin
  Result := FConfig.check_multi_interp_extensions <> 0;
end;

function TPyInterpreterConfig.Get_gil: TPyInterpreterCfgGIL;
begin
  case FConfig.gil of
    PyInterpreterConfig_SHARED_GIL  : Result := gilShared;
    PyInterpreterConfig_OWN_GIL     : Result := gilOwn;
    else                              Result := gilDefault;
  end;
end;

procedure TPyInterpreterConfig.Set_use_main_obmalloc(aValue: boolean);
begin
  FConfig.use_main_obmalloc := ord(aValue);
end;

procedure TPyInterpreterConfig.Set_allow_fork(aValue: boolean);
begin
  FConfig.allow_fork := ord(aValue);
end;

procedure TPyInterpreterConfig.Set_allow_exec(aValue: boolean);
begin
  FConfig.allow_exec := ord(aValue);
end;

procedure TPyInterpreterConfig.Set_allow_threads(aValue: boolean);
begin
  FConfig.allow_threads := ord(aValue);
end;

procedure TPyInterpreterConfig.Set_allow_daemon_threads(aValue: boolean);
begin
  FConfig.allow_daemon_threads := ord(aValue);
end;

procedure TPyInterpreterConfig.Set_check_multi_interp_extensions(aValue: boolean);
begin
  FConfig.check_multi_interp_extensions := ord(aValue);
end;

procedure TPyInterpreterConfig.Set_gil(aValue: TPyInterpreterCfgGIL);
begin
  case aValue of
    gilShared : FConfig.gil := PyInterpreterConfig_SHARED_GIL;
    gilOwn    : FConfig.gil := PyInterpreterConfig_OWN_GIL;
    else        FConfig.gil := PyInterpreterConfig_DEFAULT_GIL;
  end;
end;

end.
