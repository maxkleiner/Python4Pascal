object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'P4P demo 0001'
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
    Left = 160
    Top = 71
    Width = 75
    Height = 25
    Caption = 'Run'
    TabOrder = 2
    OnClick = RunBtnClick
  end
  object CodeEdt: TEdit
    Left = 24
    Top = 72
    Width = 121
    Height = 23
    TabOrder = 3
    Text = 'print(2+2)'
  end
  object Run2Btn: TButton
    Left = 160
    Top = 102
    Width = 75
    Height = 25
    Caption = 'Run 2'
    TabOrder = 4
    OnClick = Run2BtnClick
  end
end
