object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Simple Python Code Runner'
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
  OnShow = FormShow
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
  object LogMem: TMemo
    Left = 0
    Top = 432
    Width = 624
    Height = 129
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object CodeMem: TMemo
    Left = 0
    Top = 34
    Width = 624
    Height = 395
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'print("Hello world!")'
      '')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      624
      34)
    object EvaluateBtn: TButton
      Left = 353
      Top = 5
      Width = 129
      Height = 24
      Anchors = [akTop, akRight]
      Caption = 'Evaluate code'
      TabOrder = 0
      OnClick = EvaluateBtnClick
    end
    object Run2Btn: TButton
      Left = 488
      Top = 5
      Width = 129
      Height = 24
      Anchors = [akTop, akRight]
      Caption = 'Run code'
      TabOrder = 1
      OnClick = Run2BtnClick
    end
  end
end
