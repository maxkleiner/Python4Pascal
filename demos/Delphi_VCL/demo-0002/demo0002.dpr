program demo0002;

uses
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  uCustomThread in 'uCustomThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
