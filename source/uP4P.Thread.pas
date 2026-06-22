unit uP4P.Thread;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.PyInterpreterState;

type
  TP4PThread = class(TThread)
    protected
      FInterpreter : IPyInterpreterState;

      procedure Execute; override;
      procedure ExecuteWithPython; virtual; abstract;

    public
      procedure AfterConstruction; override;
      procedure BeforeDestruction; override;
  end;

implementation

uses
  uP4P.PyThreadState;

procedure TP4PThread.AfterConstruction;
begin
  inherited AfterConstruction;

  FInterpreter := TPyInterpreterState.Get;
end;

procedure TP4PThread.BeforeDestruction;
begin
  FInterpreter := nil;

  inherited BeforeDestruction;
end;

procedure TP4PThread.Execute;
var
  TempState : IPyThreadState;
begin
  TempState := TPyThreadState.New(FInterpreter);
  TempState.Swap;

  ExecuteWithPython;

  TempState.Clear;
  TPyThreadState.DeleteCurrent;
end;

end.
