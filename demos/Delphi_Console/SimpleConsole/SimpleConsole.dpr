program SimpleConsole;

{$APPTYPE CONSOLE}

{$I ..\..\..\source\p4p.inc}

{$R *.res}

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  uMain in 'uMain.pas',
  uCustomThread in 'uCustomThread.pas';

begin
  try
    CreateGlobalP4PEngine;
    CreateCustomThread;
    WaitForMainAppEvent;
    WaitForEnter;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
