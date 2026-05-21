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
      function Get_gil: Integer;

      procedure Set_use_main_obmalloc(aValue: boolean);
      procedure Set_allow_fork(aValue: boolean);
      procedure Set_allow_exec(aValue: boolean);
      procedure Set_allow_threads(aValue: boolean);
      procedure Set_allow_daemon_threads(aValue: boolean);
      procedure Set_check_multi_interp_extensions(aValue: boolean);
      procedure Set_gil(aValue: Integer);

    public
      constructor Create;

      property Config                        : Pointer     read GetConfig;
      property use_main_obmalloc             : boolean     read Get_use_main_obmalloc              write Set_use_main_obmalloc;
      property allow_fork                    : boolean     read Get_allow_fork                     write Set_allow_fork;
      property allow_exec                    : boolean     read Get_allow_exec                     write Set_allow_exec;
      property allow_threads                 : boolean     read Get_allow_threads                  write Set_allow_threads;
      property allow_daemon_threads          : boolean     read Get_allow_daemon_threads           write Set_allow_daemon_threads;
      property check_multi_interp_extensions : boolean     read Get_check_multi_interp_extensions  write Set_check_multi_interp_extensions;
      property gil                           : Integer     read Get_gil                            write Set_gil;
  end;

implementation

constructor TPyInterpreterConfig.Create;
begin
  inherited Create;

  FillChar(FConfig, SizeOf(PyInterpreterConfig), #0);
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

function TPyInterpreterConfig.Get_gil: Integer;
begin
  Result := FConfig.gil;
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

procedure TPyInterpreterConfig.Set_gil(aValue: Integer);
begin
  if (aValue in [PyInterpreterConfig_DEFAULT_GIL..PyInterpreterConfig_OWN_GIL]) then
    FConfig.gil := aValue;
end;

end.
