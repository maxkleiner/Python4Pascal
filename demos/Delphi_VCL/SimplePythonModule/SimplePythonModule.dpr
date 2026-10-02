program SimplePythonModule;

{$I ..\..\..\source\p4p.inc}

uses
  //FastMM4,
  //FastMM5,
  {$IFDEF DELPHI16_UP}
  Vcl.Forms,
  {$ELSE}
  Forms,
  {$ENDIF}
  uMainForm in 'uMainForm.pas' {MainForm},
  uTestModule in 'uTestModule.pas';

{$R *.res}

begin
  Application.Initialize;
  {$IFDEF DELPHI11_UP}
  Application.MainFormOnTaskbar := True;
  {$ENDIF}
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
