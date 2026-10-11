program SimpleConsole;

{$mode ObjFPC}{$H+}

uses            
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
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
