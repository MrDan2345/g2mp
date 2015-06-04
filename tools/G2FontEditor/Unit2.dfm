object Form2: TForm2
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Point Edit'
  ClientHeight = 65
  ClientWidth = 177
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
    Width = 177
    Height = 65
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 6
    Height = 13
    Caption = 'X'
  end
  object Label2: TLabel
    Left = 96
    Top = 12
    Width = 6
    Height = 13
    Caption = 'Y'
  end
  object SpinEdit1: TSpinEdit
    Left = 16
    Top = 8
    Width = 65
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 0
  end
  object SpinEdit2: TSpinEdit
    Left = 104
    Top = 8
    Width = 65
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object Button1: TButton
    Left = 8
    Top = 32
    Width = 161
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button1Click
  end
end
