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
      FConfig : PyPreConfig;

      function GetConfig: Pointer;
      function Get_parse_argv: boolean;
      function Get_isolated: boolean;
      function Get_use_environment: boolean;
      function Get_configure_locale: boolean;
      function Get_coerce_c_locale: integer;
      function Get_coerce_c_locale_warn: boolean;
      function Get_legacy_windows_fs_encoding: boolean;
      function Get_utf8_mode: integer;
      function Get_dev_mode: boolean;
      function Get_allocator: PyMemAllocatorName;

    public
      procedure InitPythonConfig;
      procedure InitIsolatedConfig;

      property Config                     : Pointer            read GetConfig;
      property parse_argv                 : boolean            read Get_parse_argv;
      property isolated                   : boolean            read Get_isolated;
      property use_environment            : boolean            read Get_use_environment;
      property configure_locale           : boolean            read Get_configure_locale;
      property coerce_c_locale            : integer            read Get_coerce_c_locale;
      property coerce_c_locale_warn       : boolean            read Get_coerce_c_locale_warn;
      property legacy_windows_fs_encoding : boolean            read Get_legacy_windows_fs_encoding;
      property utf8_mode                  : integer            read Get_utf8_mode;
      property dev_mode                   : boolean            read Get_dev_mode;
      property allocator                  : PyMemAllocatorName read Get_allocator;
  end;

implementation

procedure TPyPreConfig.InitPythonConfig;
begin
  if assigned(PyPreConfig_InitPythonConfig) then
    PyPreConfig_InitPythonConfig(Config);
end;

procedure TPyPreConfig.InitIsolatedConfig;
begin
  if assigned(PyPreConfig_InitIsolatedConfig) then
    PyPreConfig_InitIsolatedConfig(Config);
end;

function TPyPreConfig.GetConfig: Pointer;
begin
  Result := @FConfig;
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

function TPyPreConfig.Get_legacy_windows_fs_encoding: boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := FConfig.legacy_windows_fs_encoding <> 0;
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

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

end.
