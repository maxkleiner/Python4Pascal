object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  TextHeight = 15
  object InitChk: TCheckBox
    Left = 16
    Top = 16
    Width = 145
    Height = 17
    Caption = 'Initialize Python'
    TabOrder = 0
    OnClick = InitChkClick
  end
  object Memo1: TMemo
    Left = 0
    Top = 224
    Width = 624
    Height = 217
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object RunBtn: TButton
    Left = 16
    Top = 111
    Width = 145
    Height = 25
    Caption = 'Run in different thread'
    TabOrder = 2
    OnClick = RunBtnClick
  end
  object CodeEdt: TEdit
    Left = 16
    Top = 72
    Width = 129
    Height = 23
    TabOrder = 3
    Text = 'print(2+2)'
  end
  object Run2Btn: TButton
    Left = 16
    Top = 152
    Width = 145
    Height = 25
    Caption = 'Run in main thread'
    TabOrder = 4
    OnClick = Run2BtnClick
  end
  object LegacyAPIChk: TCheckBox
    Left = 240
    Top = 16
    Width = 200
    Height = 17
    Caption = 'Legacy API'
    TabOrder = 5
  end
  object SharedInterpreterChk: TCheckBox
    Left = 240
    Top = 48
    Width = 200
    Height = 17
    Caption = 'Shared Interpreter'
    TabOrder = 6
  end
  object SharedGILChk: TCheckBox
    Left = 240
    Top = 78
    Width = 200
    Height = 17
    Caption = 'Shared GIL'
    TabOrder = 7
  end
end
