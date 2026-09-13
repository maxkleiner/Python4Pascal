unit uMainForm;

{$I ..\..\..\source\p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.SyncObjs,
  {$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, SyncObjs,
  {$ENDIF}
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants;

type
  TMainForm = class(TForm)
    LogMem: TMemo;
    RunBtn: TButton;
    Splitter1: TSplitter;
    Panel1: TPanel;
    ThreadRunModeRg: TRadioGroup;
    CodeMem: TMemo;
    procedure RunBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    FPendingMsg : TStringList;
    FPendingCS  : TCriticalSection;

    function  AppendMessage(const aMessage: string): boolean;
    procedure ShowPendingMessages;
    function  Lock: boolean;
    procedure Unlock;
    procedure Thread_OnTerminate(Sender: TObject);

  public
    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  uCustomThread;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyGlobalP4PEngine;
  FreeAndNil(FPendingCS);
  FreeAndNil(FPendingMsg);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FPendingCS  := TCriticalSection.Create;
  FPendingMsg := TStringList.Create;
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
      //TempLibPath := 'Q:\python-3.14.7-embed-' + TempBit + '\python314.dll';
      //TempLibPath := 'Q:\python-3.13.13-embed-' + TempBit + '\python313.dll';
      //TempLibPath := 'Q:\python-3.12.10-embed-' + TempBit + '\python312.dll';
      //TempLibPath := 'Q:\python-3.11.9-embed-' + TempBit + '\python311.dll';
      //TempLibPath := 'Q:\python-3.10.11-embed-' + TempBit + '\python310.dll';
      //TempLibPath := '';

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

function TMainForm.Lock: boolean;
begin
  Result := False;

  if assigned(FPendingCS) then
    begin
      FPendingCS.Acquire;
      Result := True;
    end;
end;

procedure TMainForm.Unlock;
begin
  if assigned(FPendingCS) then
    FPendingCS.Release;
end;

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
begin
  if AppendMessage(message_) then
    TThread.Synchronize(nil, ShowPendingMessages);
end;

procedure TMainForm.RunBtnClick(Sender: TObject);
var
  TempThread : TCustomThread;
begin
  if not(assigned(GlobalP4PEngine)) then exit;

  GlobalP4PEngine.SaveThreadState;

  TempThread                   := TCustomThread.Create(True);
  TempThread.Code              := CodeMem.Text;
  TempThread.FreeOnTerminate   := True;
  TempThread.UseLegacyInit     := (ThreadRunModeRg.ItemIndex = 0);
  TempThread.SharedInterpreter := (ThreadRunModeRg.ItemIndex = 1);
  TempThread.SharedGIL         := (ThreadRunModeRg.ItemIndex = 2);
  TempThread.OnTerminate       := Thread_OnTerminate;
  TempThread.Start;
end;

procedure TMainForm.Thread_OnTerminate(Sender: TObject);
begin
  GlobalP4PEngine.RestoreThreadState;
end;

function TMainForm.AppendMessage(const aMessage: string): boolean;
var
  TempMsg : string;
begin
  Result := False;
  if Lock then
    try
      TempMsg := trim(aMessage);

      if (length(TempMsg) > 0) then
        begin
          FPendingMsg.Add(TempMsg);
          Result := True;
        end;
    finally
      Unlock;
    end;
end;

procedure TMainForm.ShowPendingMessages;
begin
  if Lock then
    try
      if (FPendingMsg.Count > 0) then
        begin
          LogMem.Lines.AddStrings(FPendingMsg);
          FPendingMsg.Clear;
        end;
    finally
      Unlock;
    end;
end;

end.
