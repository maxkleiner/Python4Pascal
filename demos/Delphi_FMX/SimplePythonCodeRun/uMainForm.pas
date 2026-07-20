unit uMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.IOUTils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.Layouts,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants;

// All FMX applications using Python4Pascal must add the $(FrameworkType) conditional define
// in the project options to avoid duplicated resources.
// This demo has that define in the menu option :
// Project -> Options -> Building -> Delphi compiler -> Conditional defines (All configurations)

type
  TMainForm = class(TForm)
    Layout1: TLayout;
    RunBtn: TButton;
    EvaluateBtn: TButton;
    CodeMem: TMemo;
    LogMem: TMemo;
    Splitter1: TSplitter;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure EvaluateBtnClick(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyGlobalP4PEngine;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  TempLibPath : string;
  {$IFDEF MSWINDOWS}
  //TempBit : string;
  {$ENDIF}
begin
  if not(assigned(GlobalP4PEngine)) then
    begin
      GlobalP4PEngine                 := TP4PEngine.Create;
      GlobalP4PEngine.OnOutputMessage := GlobalP4PEngine_OnOutputMessage;
    end;

  if not(GlobalP4PEngine.Initialized) then
    begin
      TempLibPath := '';
      {$IFDEF MSWINDOWS}
      {$IFDEF TARGET_32BITS}
      //TempBit := 'win32';
      {$ELSE}
      //TempBit := 'win64';
      {$ENDIF}

      //TempLibPath := 'R:\python-3.14.6-embed-' + TempBit + '\python314.dll';
      //TempLibPath := 'R:\python-3.13.13-embed-' + TempBit + '\python313.dll';
      //TempLibPath := 'R:\python-3.12.10-embed-' + TempBit + '\python312.dll';
      //TempLibPath := 'R:\python-3.11.9-embed-' + TempBit + '\python311.dll';
      //TempLibPath := 'R:\python-3.10.11-embed-' + TempBit + '\python310.dll';
      {$ENDIF}
      {$IFDEF ANDROID}
      TempLibPath := TPath.Combine(TPath.GetDocumentsPath, 'libpython3.14.so');
      {$ENDIF}

      if GlobalP4PEngine.Load(TempLibPath) and
         GlobalP4PEngine.Initialize then
        LogMem.Lines.Add('Python initialized. ' + GlobalP4PEngine.buildinfo)
       else
        begin
          LogMem.Lines.Add('There was an error initializing Python!');
          LogMem.Lines.Add(GlobalP4PEngine.LastErrorMessage);
        end;
    end;
end;

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
var
  TempMsg : string;
begin
  // We ignore empty messages in this demo.
  TempMsg := trim(message_);

  if (length(TempMsg) > 0) then
    LogMem.Lines.Add(TempMsg);
end;

procedure TMainForm.RunBtnClick(Sender: TObject);
begin
  if TPyRun.SimpleString(CodeMem.Text) then
    LogMem.Lines.Add('Code run correctly.')
   else
    LogMem.Lines.Add('There was an error running the code.');
end;

procedure TMainForm.EvaluateBtnClick(Sender: TObject);
var
  TempResult : IPyObject;
begin
  TempResult := TPyEval.EvalString(CodeMem.Text);

  if TPyObject.IsInitialized(TempResult) then
    LogMem.Lines.Add('Code evaluated correctly. Result: ' + quotedstr(TempResult.AsString))
   else
    LogMem.Lines.Add('There was an error evaluating the code.');
end;

end.
