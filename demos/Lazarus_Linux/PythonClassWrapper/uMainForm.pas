unit uMainForm;

{$MODE Delphi}

interface

uses
  Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants,
  uMyClass;

type
  TMainForm = class(TForm)
    CodeMem: TMemo;
    LogMem: TMemo;
    ButtonPnl: TPanel;
    RunBtn: TButton;
    Splitter1: TSplitter;
    WrapClassBtn: TButton;
    TestMyClassBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RunBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WrapClassBtnClick(Sender: TObject);
    procedure TestMyClassBtnClick(Sender: TObject);

  private
    FMyClass : TMyClass;

    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
begin
  LogMem.Lines.Add(message_);
end;

procedure TMainForm.RunBtnClick(Sender: TObject);
begin
  if assigned(FMyClass) then exit;

  if TPyRun.SimpleString(CodeMem.Text) then
    LogMem.Lines.Add('Code run correctly.')
   else
    LogMem.Lines.Add('There was an issue running the code.');
end;

procedure TMainForm.TestMyClassBtnClick(Sender: TObject);
begin
  if not(assigned(FMyClass)) then exit;

  LogMem.Lines.Add('FMyClass.x = ' + inttostr(FMyClass.x));
  FMyClass.x := FMyClass.x * FMyClass.x;
  LogMem.Lines.Add('FMyClass.x * FMyClass.x = ' + inttostr(FMyClass.x));
  LogMem.Lines.Add('MyClass.boolean_test() = ' + booltostr(FMyClass.boolean_test, True));
  LogMem.Lines.Add('MyClass.integer_test() = ' + inttostr(FMyClass.integer_test));
  LogMem.Lines.Add('MyClass.float_test() = ' + floattostr(FMyClass.float_test));
  LogMem.Lines.Add('MyClass.string_test() = ' + FMyClass.string_test);
  LogMem.Lines.Add('MyClass.tuple_test() = ' + FMyClass.tuple_test);
  LogMem.Lines.Add('MyClass.list_test() = ' + FMyClass.list_test);
  LogMem.Lines.Add('MyClass.datetime_test() = ' + DateTimeToStr(FMyClass.datetime_test));
  LogMem.Lines.Add('MyClass.square_test(3) = ' + inttostr(FMyClass.square_test(3)));
  LogMem.Lines.Add('MyClass.uppercase_test("test") = ' + FMyClass.uppercase_test('test'));
end;

procedure TMainForm.WrapClassBtnClick(Sender: TObject);
begin
  if not(assigned(FMyClass)) then
    begin
      FMyClass := TMyClass.Create;

      if FMyClass.Initialized then
        LogMem.Lines.Add('FMyClass is initialized.')
       else
        LogMem.Lines.Add('There was an issue initializing FMyClass.');
    end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if assigned(FMyClass) then
    FreeAndNil(FMyClass);

  DestroyGlobalP4PEngine;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FMyClass := nil;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  TempBit, TempDrive, TempLibPath : string;
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

      TempDrive := 'Q';
      //TempDrive := 'S';

      TempLibPath := TempDrive + ':\python-3.15.0rc2-embed-' + TempBit + '\python315.dll';
      //TempLibPath := TempDrive + ':\python-3.14.8-embed-' + TempBit + '\python314.dll';
      //TempLibPath := TempDrive + ':\python-3.13.16-embed-' + TempBit + '\python313.dll';
      //TempLibPath := TempDrive + ':\python-3.12.10-embed-' + TempBit + '\python312.dll';
      //TempLibPath := TempDrive + ':\python-3.11.9-embed-' + TempBit + '\python311.dll';
      //TempLibPath := TempDrive + ':\python-3.10.11-embed-' + TempBit + '\python310.dll';
      //TempLibPath := '';

      if GlobalP4PEngine.Load(TempLibPath) and
         GlobalP4PEngine.Initialize then
        begin
          LogMem.Lines.Add('Python initialized. ' + GlobalP4PEngine.buildinfo);
          ButtonPnl.Enabled := True;
        end
       else
        begin
          LogMem.Lines.Add('There was an error initializing Python!');
          LogMem.Lines.Add(GlobalP4PEngine.LastErrorMessage);
        end;
    end;
end;

end.
