object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'P4P demo 0001'
  ClientHeight = 561
  ClientWidth = 624
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 0
    Top = 429
    Width = 624
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 312
  end
  object Memo1: TMemo
    Left = 0
    Top = 432
    Width = 624
    Height = 129
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    ExplicitTop = 312
  end
  object CodeMem: TMemo
    Left = 0
    Top = 34
    Width = 624
    Height = 395
    Align = alClient
    Lines.Strings = (
      'class MyClass:'
      '  x = 5')
    ScrollBars = ssBoth
    TabOrder = 1
    ExplicitTop = 41
    ExplicitHeight = 268
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    Padding.Left = 5
    Padding.Top = 5
    Padding.Right = 5
    Padding.Bottom = 5
    TabOrder = 2
    DesignSize = (
      624
      34)
    object InitChk: TCheckBox
      Left = 5
      Top = 5
      Width = 145
      Height = 24
      Align = alLeft
      Caption = 'Initialize Python'
      TabOrder = 0
      OnClick = InitChkClick
      ExplicitLeft = 9
      ExplicitTop = 13
      ExplicitHeight = 17
    end
    object EvaluateBtn: TButton
      Left = 355
      Top = 5
      Width = 129
      Height = 24
      Anchors = [akTop, akRight]
      Caption = 'Evaluate code'
      TabOrder = 1
      OnClick = EvaluateBtnClick
    end
    object Run2Btn: TButton
      Left = 490
      Top = 5
      Width = 129
      Height = 24
      Align = alRight
      Caption = 'Run code'
      TabOrder = 2
      OnClick = Run2BtnClick
      ExplicitLeft = 392
      ExplicitTop = 10
      ExplicitHeight = 25
    end
    object Button1: TButton
      Left = 232
      Top = 3
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 3
      OnClick = Button1Click
    end
  end
end
