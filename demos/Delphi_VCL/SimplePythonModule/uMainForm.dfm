object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Simple Python Module'
  ClientHeight = 699
  ClientWidth = 736
  Color = clBtnFace
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
    Top = 333
    Width = 736
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 35
    ExplicitWidth = 317
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 736
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object RunBtn: TButton
      Left = 5
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Run'
      TabOrder = 0
      OnClick = RunBtnClick
    end
  end
  object LogMem: TMemo
    Left = 0
    Top = 336
    Width = 736
    Height = 363
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object CodeMem: TMemo
    Left = 0
    Top = 35
    Width = 736
    Height = 298
    Align = alClient
    Lines.Strings = (
      'import mytest'
      ''
      'print("Saving the sample string in the Delphi form...")'
      'mytest.write("sample")'
      ''
      
        'print("Reading the previously saved value from the Delphi form..' +
        '.")'
      'print(mytest.read())'
      ''
      'print("Check if 42 is even...")'
      'print(mytest.is_even(42))'
      ''
      'print("Check if 45 is even...")'
      'print(mytest.is_even(45))'
      ''
      'obj = mytest.mytype()'
      'print(type(obj))'
      'print(isinstance(obj, mytest.mytype))'
      'print(obj.getid())'
      'print(repr(obj))')
    TabOrder = 2
  end
end
