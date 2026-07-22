program SimplePythonModule;

uses
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  uTestModule in 'uTestModule.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
