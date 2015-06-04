object Form3: TForm3
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Value Editor'
  ClientHeight = 65
  ClientWidth = 129
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 129
    Height = 65
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 26
    Height = 13
    Caption = 'Value'
  end
  object SpinEdit1: TSpinEdit
    Left = 40
    Top = 8
    Width = 81
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 0
  end
  object Button1: TButton
    Left = 8
    Top = 32
    Width = 113
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
end
