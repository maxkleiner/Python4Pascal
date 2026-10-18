program SimplePythonModule;

{$MODE Delphi}

uses
  Forms, Interfaces,
  uMainForm in 'uMainForm.pas' {MainForm},
  uTestModule in 'uTestModule.pas', uTestHeapType;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
