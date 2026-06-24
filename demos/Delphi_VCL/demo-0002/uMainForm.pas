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
    Run2Btn: TButton;
    procedure InitChkClick(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
    procedure Run2BtnClick(Sender: TObject);
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

procedure TMainForm.Run2BtnClick(Sender: TObject);
var
  TempBytecode, TempGlobals, TempLocals, TempResult, TempMainModule : IPyObject;
begin
  TempMainModule := TPyImport.AddModuleRef(MAIN_MODULE_NAME);

  if TPyObject.IsInitialized(TempMainModule) then
    begin
      try
        Memo1.Lines.Add(MAIN_MODULE_NAME + ' module obtained correctly.');

        TempLocals  := TPyModule.GetDict(TempMainModule);
        TempGlobals := TempLocals;

        TempBytecode := TPy.CompileString(CodeEdt.Text);

        if TPyObject.IsInitialized(TempBytecode) then
          begin
            Memo1.Lines.Add('Code compiled correctly.');

            TempResult  := TPyEval.EvalCode(TempBytecode, TempGlobals, TempLocals);

            if TPyObject.IsInitialized(TempResult) then
              Memo1.Lines.Add('Bytecode evaluated correctly.')
             else
              Memo1.Lines.Add('There was an error evaluating the bytecode.')
          end
         else
          Memo1.Lines.Add('There was an error compiling the code.');
      finally
        TempMainModule := nil;
      end;
    end
   else
    Memo1.Lines.Add('There was an error getting the __main__ module.');
end;

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
begin
  TThread.ForceQueue(nil,
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
  TempThread.SharedInterpreter := False;
  TempThread.Start;
end;

end.
