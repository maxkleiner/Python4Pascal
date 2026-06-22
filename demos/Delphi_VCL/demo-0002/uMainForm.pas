unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants;

type
  TMainForm = class(TForm)
    InitChk: TCheckBox;
    Memo1: TMemo;
    RunBtn: TButton;
    CodeEdt: TEdit;
    procedure InitChkClick(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uCustomThread;

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      Memo1.Lines.Add(message_);
    end
  );
end;

procedure TMainForm.InitChkClick(Sender: TObject);
var
  TempLibPath : string;
begin
  if not(assigned(GlobalP4PEngine)) then
    begin
      GlobalP4PEngine                 := TP4PEngine.Create;
      GlobalP4PEngine.OnOutputMessage := GlobalP4PEngine_OnOutputMessage;
    end;

  if InitChk.Checked then
    begin
      if not(GlobalP4PEngine.Initialized) then
        begin
          GlobalP4PEngine.SetCurrentDir := True;

          //TempLibPath := 'C:\Users\usuario\Desktop\python-3.14.5-embed-win32\python314.dll';
          //TempLibPath := 'C:\Users\usuario\AppData\Local\Programs\Python\Python314\python314_d.dll';
          TempLibPath := '';

          if GlobalP4PEngine.Load(TempLibPath) and
             GlobalP4PEngine.Initialize then
            Memo1.Lines.Add('Python initialized. ' + GlobalP4PEngine.buildinfo)
           else
            begin
              Memo1.Lines.Add('There was an error initializing Python!');
              Memo1.Lines.Add(GlobalP4PEngine.LastErrorMessage);
            end;
        end;
    end
   else
    begin
      DestroyGlobalP4PEngine;
      Memo1.Lines.Add('Python uninitialized');
    end;
end;

procedure TMainForm.RunBtnClick(Sender: TObject);
var
  TempThread : TCustomThread;
begin
  TempThread                 := TCustomThread.Create(True);
  TempThread.Code            := CodeEdt.Text;
  TempThread.FreeOnTerminate := True;
  TempThread.Start;
end;

end.
