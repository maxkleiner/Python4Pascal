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
      procedure InitPythonConfig;
      procedure InitIsolatedConfig;

      class function  IsInitialized(const aPyPreConfig: IPyPreConfig): boolean; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}

      property Config                      : Pointer            read GetConfig;
      property Initialized                 : boolean            read GetInitialized;
      property parse_argv                  : boolean            read Get_parse_argv                           write Set_parse_argv;
      property isolated                    : boolean            read Get_isolated                             write Set_isolated;
      property use_environment             : boolean            read Get_use_environment                      write Set_use_environment;
      property configure_locale            : boolean            read Get_configure_locale                     write Set_configure_locale;
      property coerce_c_locale             : integer            read Get_coerce_c_locale                      write Set_coerce_c_locale;
      property coerce_c_locale_warn        : boolean            read Get_coerce_c_locale_warn                 write Set_coerce_c_locale_warn;
      {$IFDEF MSWINDOWS}
      property legacy_windows_fs_encoding  : boolean            read Get_legacy_windows_fs_encoding           write Set_legacy_windows_fs_encoding;
      {$ENDIF}
      property utf8_mode                   : integer            read Get_utf8_mode                            write Set_utf8_mode;
      property dev_mode                    : boolean            read Get_dev_mode                             write Set_dev_mode;
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
