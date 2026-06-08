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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RunBtnClick(Sender: TObject);
    procedure Run2BtnClick(Sender: TObject);
  private
    { Private declarations }
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

procedure TMainForm.InitChkClick(Sender: TObject);
begin
  if not(assigned(GlobalP4PEngine)) then
    GlobalP4PEngine := TP4PEngine.Create;

  if InitChk.Checked then
    begin
      if not(GlobalP4PEngine.Initialized) then
        begin
          GlobalP4PEngine.SetCurrentDir := True;

          //if GlobalP4PEngine.Load('C:\Users\usuario\AppData\Local\Programs\Python\Python314\python314_d.dll') and
          if GlobalP4PEngine.Load() and
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
  if TPyRun.SimpleString(CodeEdt.Text) then
    Memo1.Lines.Add('Code run correctly.')
   else
    Memo1.Lines.Add('There was an error running the code.');
end;

procedure TMainForm.RunBtnClick(Sender: TObject);
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

end.
