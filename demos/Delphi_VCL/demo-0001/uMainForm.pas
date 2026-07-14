unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants, Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    InitChk: TCheckBox;
    Memo1: TMemo;
    EvaluateBtn: TButton;
    Run2Btn: TButton;
    Splitter1: TSplitter;
    CodeMem: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    procedure InitChkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Run2BtnClick(Sender: TObject);
    procedure EvaluateBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyGlobalP4PEngine;
end;

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
begin
  Memo1.Lines.Add(message_);
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
          //TempLibPath := 'C:\Users\usuario\Desktop\python-3.10.11-embed-win32\python310.dll';
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

procedure TMainForm.Run2BtnClick(Sender: TObject);
begin
  if TPyRun.SimpleString(CodeMem.Text) then
    Memo1.Lines.Add('Code run correctly.')
   else
    Memo1.Lines.Add('There was an error running the code.');
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  TempMainModObj : IPyObject;
  TempClass, TempMainModVar : Variant;
begin
  TempMainModObj := TPyImport.AddModuleRef(MAIN_MODULE_NAME);
  TempMainModVar := TempMainModObj.AsVariant;
  TempClass      := TempMainModVar.MyClass();
  Memo1.Lines.Add(inttostr(TempClass.x));
end;

procedure TMainForm.EvaluateBtnClick(Sender: TObject);
var
  TempResult : IPyObject;
begin
  TempResult := TPyEval.EvalString(CodeMem.Text);

  if TPyObject.IsInitialized(TempResult) then
    Memo1.Lines.Add('Code evaluated correctly. Result: ' + quotedstr(TempResult.AsString))
   else
    Memo1.Lines.Add('There was an error evaluating the code.')
end;

end.
