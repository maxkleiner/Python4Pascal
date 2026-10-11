program SimpleConsole;

{$mode ObjFPC}{$H+}

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
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
