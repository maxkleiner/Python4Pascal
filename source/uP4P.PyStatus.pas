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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces;

type
  TPyStatus = class(TInterfacedObject, IPyStatus)
    protected
      FStatus : PyStatus;

      function GetFunc: string;
      function GetErrMsg: string;
      function GetExitCode: integer;
      function GetIsException: boolean;
      function GetIsError: boolean;
      function GetIsExit: boolean;

    public
      constructor Create(const aStatus: PyStatus); overload;
      constructor Create(aStatusType: TPyStatusType; const aErrorMessage: string; aExitCode: integer); overload;
      procedure   ExitStatusException;

      property func        : string    read GetFunc;
      property ErrMsg      : string    read GetErrMsg;
      property ExitCode    : integer   read GetExitCode;
      property IsException : boolean   read GetIsException;
      property IsError     : boolean   read GetIsError;
      property IsExit      : boolean   read GetIsExit;
  end;

implementation

uses
  uP4P.MiscFunctions;

constructor TPyStatus.Create(const aStatus: PyStatus);
begin
  inherited Create;

  FStatus := aStatus;
end;

constructor TPyStatus.Create(aStatusType: TPyStatusType; const aErrorMessage: string; aExitCode: integer);
var
  TempMsg : AnsiString;
begin
  inherited Create;

  case aStatusType of
    CustomPyStatusOk       : if assigned(PyStatus_Ok)       then FStatus := PyStatus_Ok();
    CustomPyStatusNoMemory : if assigned(PyStatus_NoMemory) then FStatus := PyStatus_NoMemory();
    CustomPyStatusExit     : if assigned(PyStatus_Exit)     then FStatus := PyStatus_Exit(aExitCode);
    CustomPyStatusError    :
      if assigned(PyStatus_Error) then
        begin
          TempMsg := StringToPyUTF8(aErrorMessage);
          FStatus := PyStatus_Error(PAnsiChar(TempMsg));
        end;
  end;
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
