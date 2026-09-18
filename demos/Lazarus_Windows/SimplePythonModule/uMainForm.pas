unit uMainForm;

{$MODE Delphi}

{$I ..\..\..\source\p4p.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants,
  uTestModule;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    RunBtn: TButton;
    LogMem: TMemo;
    Splitter1: TSplitter;
    CodeMem: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
  private
    FTestModule  : TTestModule;
    FCustomValue : string;

    function  CreateModule: boolean;
    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
  public
    property CustomValue : string read FCustomValue write FCustomValue;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if assigned(FTestModule) then
    FreeAndNil(FTestModule);

  DestroyGlobalP4PEngine;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  TempLibPath : string;
  TempBit : string;
begin
  if not(assigned(GlobalP4PEngine)) then
    begin
      GlobalP4PEngine                 := TP4PEngine.Create;
      GlobalP4PEngine.OnOutputMessage := GlobalP4PEngine_OnOutputMessage;
    end;

  if not(GlobalP4PEngine.Initialized) then
    begin
      GlobalP4PEngine.SetCurrentDir := True;

      {$IFDEF TARGET_32BITS}
      TempBit := 'win32';
      {$ELSE}
      TempBit := 'amd64';
      {$ENDIF}

      TempLibPath := 'Q:\python-3.15.0rc2-embed-' + TempBit + '\python315.dll';
      //TempLibPath := 'Q:\python-3.14.6-embed-' + TempBit + '\python314.dll';
      //TempLibPath := 'Q:\python-3.13.13-embed-' + TempBit + '\python313.dll';
      //TempLibPath := 'Q:\python-3.12.10-embed-' + TempBit + '\python312.dll';
      //TempLibPath := 'Q:\python-3.11.9-embed-' + TempBit + '\python311.dll';
      //TempLibPath := 'Q:\python-3.10.11-embed-' + TempBit + '\python310.dll';
      //TempLibPath := '';

      if GlobalP4PEngine.Load(TempLibPath) and
         GlobalP4PEngine.Initialize and
         CreateModule then
        LogMem.Lines.Add('Python initialized. ' + GlobalP4PEngine.buildinfo)
       else
        begin
          LogMem.Lines.Add('There was an error initializing Python!');
          LogMem.Lines.Add(GlobalP4PEngine.LastErrorMessage);
        end;
    end;
end;

function TMainForm.CreateModule: boolean;
begin
  FTestModule          := TTestModule.Create(TEST_MODULE_NAME);
  FTestModule.MainForm := self;
  Result               := FTestModule.Initialize;
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

end.
