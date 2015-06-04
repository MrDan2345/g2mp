object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Gen2 Pack Editor'
  ClientHeight = 473
  ClientWidth = 792
  Color = clWhite
  Constraints.MinHeight = 500
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object od1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Top = 32
  end
  object sd2: TSaveDialog
    DefaultExt = 'g2pk'
    Filter = 'Gen2 Pack|*.g2pk'
    Left = 32
  end
  object od2: TOpenDialog
    DefaultExt = 'g2pk'
    Filter = 'Gen2 Pack|*.g2pk'
    Left = 32
    Top = 32
  end
  object sd1: TSaveDialog
  end
  object ApplicationEvents1: TApplicationEvents
    OnActivate = ApplicationEvents1Activate
    OnDeactivate = ApplicationEvents1Deactivate
    Left = 64
  end
end
