unit uMainForm;

{$I ..\..\..\source\p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  {$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  {$ENDIF}
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants;

type
  TMainForm = class(TForm)
    LogMem: TMemo;
    Run2Btn: TButton;
    Splitter1: TSplitter;
    CodeMem: TMemo;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Run2BtnClick(Sender: TObject);
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

uses
  uP4P.PyObjectVariantType;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyGlobalP4PEngine;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  TempLibPath : string;
  //TempBit : string;
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
      //TempBit := 'win32';
      {$ELSE}
      //TempBit := 'win64';
      {$ENDIF}

      //TempLibPath := 'R:\python-3.14.6-embed-' + TempBit + '\python314.dll';
      //TempLibPath := 'R:\python-3.13.13-embed-' + TempBit + '\python313.dll';
      //TempLibPath := 'R:\python-3.12.10-embed-' + TempBit + '\python312.dll';
      //TempLibPath := 'R:\python-3.11.9-embed-' + TempBit + '\python311.dll';
      //TempLibPath := 'R:\python-3.10.11-embed-' + TempBit + '\python310.dll';

      TempLibPath := '';

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
begin
  LogMem.Lines.Add(message_);
end;

procedure TMainForm.Run2BtnClick(Sender: TObject);
var
  TempMainModObj : IPyObject;
  TempClass, TempMainModVar, TempTuple, TempList, TempDate : Variant;
begin
  if TPyRun.SimpleString(CodeMem.Text) then
    begin
      TempMainModObj := TPyImport.AddModuleRef(MAIN_MODULE_NAME);
      TempMainModVar := TempMainModObj.AsVariant;
      TempClass      := TempMainModVar.MyClass();
      LogMem.Lines.Add('MyClass.x = ' + inttostr(TempClass.x));
      TempClass.x := TempClass.x * TempClass.x;
      LogMem.Lines.Add('MyClass.x * TempClass.x = ' + inttostr(TempClass.x));
      LogMem.Lines.Add('MyClass.boolean_test() = ' + booltostr(TempClass.boolean_test(), True));
      LogMem.Lines.Add('MyClass.integer_test() = ' + inttostr(TempClass.integer_test()));
      LogMem.Lines.Add('MyClass.float_test() = ' + floattostr(TempClass.float_test()));
      LogMem.Lines.Add('MyClass.string_test() = ' + TempClass.string_test());
      TempTuple := TempClass.tuple_test();
      LogMem.Lines.Add('MyClass.tuple_test() = ' + TempTuple);
      TempList :=  TempClass.list_test();
      LogMem.Lines.Add('MyClass.list_test() = ' + TempList);
      TempDate := TempClass.datetime_test();
      LogMem.Lines.Add('MyClass.datetime_test() = ' + TempDate + ' -> ' + DateTimeToStr(TDateTime(TempDate)));
      LogMem.Lines.Add('MyClass.square_test(5) = ' + inttostr(TempClass.square_test(5)));
      LogMem.Lines.Add('MyClass.uppercase_test("test") = ' + TempClass.uppercase_test('test'));
    end;
end;

end.
