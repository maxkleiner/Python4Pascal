unit uMainForm;

{$I p4p.inc}

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.IOUTils, System.Zip,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.Layouts,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants;

// All FMX applications using Python4Pascal must add the $(FrameworkType) conditional define.
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

uses
  uP4P.MiscFunctions;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyGlobalP4PEngine;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  TempLibPath : string;
  {$IFDEF ANDROID}
  TempZipPath, TempLib, TempSitePckgs : string;
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

      {$IFDEF ANDROID}
      try
        // python.zip is part of the official Python Release Package for Android
        // available at www.python.org, for example "python-3.14.6-aarch64-linux-android.tar.gz",
        // but it only includes the *contents* of the "prefix/lib" directory,
        // including the subdirectories.

        // "python.zip" is deployed to "assets\internal\" and the unit
        // "System.StartUpCopy" will copy that file to the documents directory
        // at startup.

        // Here we decompress "python.zip".
        TempLibPath := TPath.Combine(TPath.GetDocumentsPath, 'python');
        TempZipPath := TPath.Combine(TPath.GetDocumentsPath, 'python.zip');

        TZipFile.ExtractZipFile(TempZipPath, TempLibPath);
      except
        on e : exception do
          if CustomExceptionHandler('TMainForm.FormShow', e) then raise;
      end;

      // Set GlobalP4PEngine.ModuleSearchPaths with the "Lib" and
      // "Lib/site-packages" directories. Python will find the modules in those
      // directories.
      TempLib       := TPath.Combine(TempLibPath, 'Lib');
      TempSitePckgs := TPath.Combine(TempLib, 'site-packages');

      GlobalP4PEngine.ModuleSearchPaths := TempLib + PathSep + TempSitePckgs;

      // TempLibPath is the path to the Python library.
      TempLibPath := TPath.Combine(TempLibPath, 'libpython3.14.so');

      // GlobalP4PEngine is automatically configured to use the isolated settings in Android.
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
