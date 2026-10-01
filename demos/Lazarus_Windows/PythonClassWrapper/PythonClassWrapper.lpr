program PythonClassWrapper;

{$MODE Delphi}

uses
  //FastMM4,
  Forms, Interfaces,
  uMainForm in 'uMainForm.pas' {MainForm},
  uMyClass in 'uMyClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
