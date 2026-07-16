object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Python Variants'
  ClientHeight = 601
  ClientWidth = 632
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
    Top = 357
    Width = 632
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 312
  end
  object LogMem: TMemo
    Left = 0
    Top = 360
    Width = 632
    Height = 241
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    ExplicitTop = 320
    ExplicitWidth = 624
  end
  object CodeMem: TMemo
    Left = 0
    Top = 34
    Width = 632
    Height = 323
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'import datetime'
      ''
      'class MyClass:'
      '    x = 5'
      '    def boolean_test(self):'
      '        return True'
      '    def integer_test(self):'
      '        return 9'
      '    def float_test(self):'
      '        return 3.7'
      '    def string_test(self):'
      '        return "test result"'
      '    def tuple_test(self):'
      '        return (1, 2, 3)'
      '    def list_test(self):'
      '        return [1, 2, 3, 4, 5]'
      '    def datetime_test(self):'
      '        return datetime.datetime.now()')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
    ExplicitWidth = 624
    ExplicitHeight = 283
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 632
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    Padding.Left = 5
    Padding.Top = 5
    Padding.Right = 5
    Padding.Bottom = 5
    TabOrder = 2
    ExplicitWidth = 624
    object Run2Btn: TButton
      Left = 390
      Top = 5
      Width = 227
      Height = 24
      Caption = 'Run code'
      TabOrder = 0
      OnClick = Run2BtnClick
    end
  end
end
