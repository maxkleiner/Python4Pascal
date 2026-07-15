program PythonVariants;

{$I ..\..\..\source\p4p.inc}

uses
  //FastMM4,
  {$IFDEF DELPHI16_UP}
  Vcl.Forms,
  {$ELSE}
  Forms,
  {$ENDIF}
  uMainForm in 'uMainForm.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
