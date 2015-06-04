object Form4: TForm4
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Color Edit'
  ClientHeight = 145
  ClientWidth = 209
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 209
    Height = 145
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 7
    Height = 13
    Caption = 'R'
  end
  object Label2: TLabel
    Left = 8
    Top = 36
    Width = 7
    Height = 13
    Caption = 'G'
  end
  object Label3: TLabel
    Left = 8
    Top = 60
    Width = 6
    Height = 13
    Caption = 'B'
  end
  object Label4: TLabel
    Left = 8
    Top = 84
    Width = 7
    Height = 13
    Caption = 'A'
  end
  object SpinEdit1: TSpinEdit
    Left = 24
    Top = 8
    Width = 73
    Height = 22
    MaxValue = 255
    MinValue = 0
    TabOrder = 0
    Value = 0
    OnChange = SpinEdit1Change
  end
  object SpinEdit2: TSpinEdit
    Left = 24
    Top = 32
    Width = 73
    Height = 22
    MaxValue = 255
    MinValue = 0
    TabOrder = 1
    Value = 0
    OnChange = SpinEdit2Change
  end
  object SpinEdit3: TSpinEdit
    Left = 24
    Top = 56
    Width = 73
    Height = 22
    MaxValue = 255
    MinValue = 0
    TabOrder = 2
    Value = 0
    OnChange = SpinEdit3Change
  end
  object SpinEdit4: TSpinEdit
    Left = 24
    Top = 80
    Width = 73
    Height = 22
    MaxValue = 255
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
  object Panel1: TPanel
    Left = 104
    Top = 8
    Width = 97
    Height = 97
    TabOrder = 4
    OnClick = Panel1Click
  end
  object Button1: TButton
    Left = 8
    Top = 112
    Width = 193
    Height = 25
    Caption = 'OK'
    TabOrder = 5
    OnClick = Button1Click
  end
  object ColorDialog1: TColorDialog
    Left = 168
    Top = 8
  end
end
