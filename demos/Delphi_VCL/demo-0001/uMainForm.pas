unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Loader, uP4P.Py, uP4P.PyImport, uP4P.PyModule, uP4P.PyEval, uP4P.PyRun;

type
  TMainForm = class(TForm)
    InitChk: TCheckBox;
    Memo1: TMemo;
    RunBtn: TButton;
    CodeEdt: TEdit;
    procedure InitChkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RunBtnClick(Sender: TObject);
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
  DestroyGlobalP4PLoader;
end;

procedure TMainForm.InitChkClick(Sender: TObject);
const
  PYTHON_LIB = 'python314.dll';
var
  TempPythonPath, TempPythonLibPath, TempPythonPackagesPath  : string;
begin
  //TempPythonPath         := 'C:\Users\usuario\Desktop\python-3.14.5-embed-win32';
  TempPythonPath         := 'C:\Users\usuario\AppData\Local\Python\pythoncore-3.14-64';
  TempPythonLibPath      := TempPythonPath + '\Lib';
  //TempPythonLibPath      := 'C:\Users\usuario\AppData\Local\Python\pythoncore-3.14-64\Lib';
  TempPythonPackagesPath := TempPythonLibPath + '\site-packages';

  if not(assigned(GlobalP4PLoader)) then
    GlobalP4PLoader := TP4PLoader.Create;

  if InitChk.Checked then
    begin
      if not(GlobalP4PLoader.Initialized) then
        begin
          GlobalP4PLoader.SetCurrentDir := True;
          GlobalP4PLoader.Home := TempPythonLibPath;
          GlobalP4PLoader.ModuleSearchPaths := TempPythonLibPath + ',' + TempPythonPackagesPath;

          if GlobalP4PLoader.Load(TempPythonPath + '\' + PYTHON_LIB) and
             GlobalP4PLoader.Initialize then
            Memo1.Lines.Add('Python initialized. ' + GlobalP4PLoader.buildinfo)
           else
            begin
              Memo1.Lines.Add('There was an error initializing Python!');
              Memo1.Lines.Add(GlobalP4PLoader.LastErrorMessage);
            end;
        end;
    end
   else
    begin
      DestroyGlobalP4PLoader;
      Memo1.Lines.Add('Python uninitialized');
    end;
end;
{
procedure TMainForm.RunBtnClick(Sender: TObject);
begin
  if TPyRun.SimpleString(CodeEdt.Text) then
    Memo1.Lines.Add('Code run correctly.')
   else
    Memo1.Lines.Add('There was an error running the code.');
end;
}

procedure TMainForm.RunBtnClick(Sender: TObject);
var
  TempBytecode, TempGlobals, TempLocals, TempResult, TempMainModule: IPyObject;
begin
  TempMainModule := TPyImport.AddModule('__main__');

  if TPyObject.IsInitialized(TempMainModule) then
    begin
      Memo1.Lines.Add('__main__ module obtained correctly.');

      TempLocals  := TPyModule.GetDict(TempMainModule);
      TempGlobals := TempLocals;

      //TempBytecode := TPy.CompileStringExFlags(CodeEdt.Text, '<string>', 1, nil, -1);
      TempBytecode := TPy.CompileString(CodeEdt.Text, '<string>', 1);

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
    end
   else
    Memo1.Lines.Add('There was an error getting the __main__ module.');
end;

end.
