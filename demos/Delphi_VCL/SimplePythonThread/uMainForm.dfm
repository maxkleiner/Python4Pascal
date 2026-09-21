object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 529
  ClientWidth = 729
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 0
    Top = 405
    Width = 729
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 312
  end
  object LogMem: TMemo
    Left = 0
    Top = 408
    Width = 729
    Height = 121
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 480
    Top = 0
    Width = 249
    Height = 405
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object RunBtn: TButton
      Left = 5
      Top = 5
      Width = 236
      Height = 25
      Caption = 'Run code'
      TabOrder = 0
      OnClick = RunBtnClick
    end
    object ThreadRunModeRg: TRadioGroup
      Left = 5
      Top = 39
      Width = 236
      Height = 138
      Caption = 'Thread run mode '
      ItemIndex = 0
      Items.Strings = (
        'Legacy API'
        'Shared Interpreter'
        'Subinterpreter with shared GIL'
        'Subinterpreter with own GIL')
      TabOrder = 1
    end
  end
  object CodeMem: TMemo
    Left = 0
    Top = 0
    Width = 480
    Height = 405
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
    TabOrder = 2
  end
end
