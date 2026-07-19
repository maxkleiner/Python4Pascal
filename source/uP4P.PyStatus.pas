unit uP4P.PyStatus;

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
  TPyStatus = class(TInterfacedObject, IPyStatus)
    protected
      FStatus : PyStatus;

      function GetStatus: PyStatus;
      function GetFunc: string;
      function GetErrMsg: string;
      function GetExitCode: integer;
      function GetIsException: boolean;
      function GetIsError: boolean;
      function GetIsExit: boolean;

    public
      constructor Create(const aStatus: PyStatus);
      procedure   ExitStatusException;

      class function Ok: IPyStatus;
      class function Error(const err_msg: string): IPyStatus;
      class function NoMemory: IPyStatus;
      class function Exit_(exitcode: integer): IPyStatus;

      property func        : string    read GetFunc;
      property ErrMsg      : string    read GetErrMsg;
      property ExitCode    : integer   read GetExitCode;
      property IsException : boolean   read GetIsException;
      property IsError     : boolean   read GetIsError;
      property IsExit      : boolean   read GetIsExit;
      property Status      : PyStatus  read GetStatus;
  end;

implementation

uses
  uP4P.MiscFunctions;

constructor TPyStatus.Create(const aStatus: PyStatus);
begin
  inherited Create;

  FStatus := aStatus;
end;

class function TPyStatus.Ok: IPyStatus;
begin
  if assigned(PyStatus_Ok) then
    Result := TPyStatus.Create(PyStatus_Ok())
   else
    Result := nil;
end;

class function TPyStatus.Error(const err_msg: string): IPyStatus;
var
  TempErrorMsg : AnsiString;
begin
  if assigned(PyStatus_Error) then
    begin
      TempErrorMsg := StringToPyUTF8(err_msg);
      Result       := TPyStatus.Create(PyStatus_Error(PAnsiChar(TempErrorMsg)));
    end
   else
    Result := nil;
end;

class function TPyStatus.NoMemory: IPyStatus;
begin
  if assigned(PyStatus_NoMemory) then
    Result := TPyStatus.Create(PyStatus_NoMemory())
   else
    Result := nil;
end;

class function TPyStatus.Exit_(exitcode: integer): IPyStatus;
begin
  if assigned(PyStatus_Exit) then
    Result := TPyStatus.Create(PyStatus_Exit(exitcode))
   else
    Result := nil;
end;

function TPyStatus.GetStatus: PyStatus;
begin
  Result := FStatus;
end;

function TPyStatus.GetFunc: string;
begin
  if assigned(FStatus.func) then
    Result := PyUTF8ToString(FStatus.func)
   else
    Result := '';
end;

function TPyStatus.GetErrMsg: string;
begin
  if assigned(FStatus.err_msg) then
    Result := PyUTF8ToString(FStatus.err_msg)
   else
    Result := '';
end;

function TPyStatus.GetExitCode: integer;
begin
  Result := FStatus.exitcode;
end;

function TPyStatus.GetIsException: boolean;
begin
  Result := assigned(PyStatus_Exception) and
            (PyStatus_Exception(FStatus) <> 0);
end;

function TPyStatus.GetIsError: boolean;
begin
  Result := assigned(PyStatus_IsError) and
            (PyStatus_IsError(FStatus) <> 0);
end;

function TPyStatus.GetIsExit: boolean;
begin
  Result := assigned(PyStatus_IsExit) and
            (PyStatus_IsExit(FStatus) <> 0);
end;

procedure TPyStatus.ExitStatusException;
begin
  if assigned(Py_ExitStatusException) then
    Py_ExitStatusException(FStatus);
end;

end.
