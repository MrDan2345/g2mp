object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Increment = 56
  BorderStyle = bsSingle
  Caption = 'Gen2 Font Editor v1.0'
  ClientHeight = 633
  ClientWidth = 969
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 969
    Height = 633
    Align = alClient
    Shape = bsFrame
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 337
    Height = 129
    Caption = 'Font Setup'
    TabOrder = 0
    object fm_FontBold1: TSpeedButton
      Left = 280
      Top = 16
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 1
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF000000000000000000000000000000000000000000000000FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FF
        FFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF000000000000000000FFFFFFFFFFFF000000000000000000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FF
        FFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF000000000000000000000000000000000000000000FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FF
        FFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF000000000000000000FFFFFFFFFFFF000000000000000000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FF
        FFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF000000000000000000000000000000000000000000000000FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      OnClick = fm_FontBold1Click
    end
    object fm_FontItalic1: TSpeedButton
      Left = 304
      Top = 16
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 2
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000
        0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF000000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80808000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF000000000000808080FFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80808000
        0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000808080FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80
        8080000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000808080FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
        0000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      OnClick = fm_FontItalic1Click
    end
    object fm_FontPreview: TImage
      Left = 8
      Top = 40
      Width = 321
      Height = 81
    end
    object fm_FontList1: TComboBox
      Left = 8
      Top = 16
      Width = 153
      Height = 21
      Style = csDropDownList
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      OnChange = fm_FontList1Change
    end
    object Button1: TButton
      Left = 168
      Top = 16
      Width = 57
      Height = 21
      Caption = 'browse'
      TabOrder = 1
      OnClick = Button1Click
    end
    object fm_FontSize1: TSpinEdit
      Left = 232
      Top = 16
      Width = 41
      Height = 22
      Ctl3D = True
      MaxValue = 64
      MinValue = 8
      ParentCtl3D = False
      TabOrder = 2
      Value = 8
      OnChange = fm_FontSize1Change
    end
  end
  object GroupBox2: TGroupBox
    Left = 352
    Top = 8
    Width = 105
    Height = 129
    Caption = 'Character Position'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 75
      Height = 13
      Caption = 'Vertical Spacing'
    end
    object Label2: TLabel
      Left = 8
      Top = 64
      Width = 88
      Height = 13
      Caption = 'Horizontal Spacing'
    end
    object fm_VSpacing: TSpinEdit
      Left = 8
      Top = 32
      Width = 89
      Height = 22
      MaxValue = 2048
      MinValue = -2048
      TabOrder = 0
      Value = 0
    end
    object fm_HSpacing: TSpinEdit
      Left = 8
      Top = 80
      Width = 89
      Height = 22
      MaxValue = 2048
      MinValue = -2048
      TabOrder = 1
      Value = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 464
    Top = 8
    Width = 497
    Height = 529
    Caption = 'Preview'
    TabOrder = 2
    object fm_PreviewScale: TLabel
      Left = 458
      Top = 24
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = '100%'
    end
    object fm_Preview1: TPanel
      Left = 8
      Top = 40
      Width = 481
      Height = 481
      TabOrder = 0
      OnClick = fm_Preview1Click
      OnMouseDown = fm_Preview1MouseDown
      OnMouseMove = fm_Preview1MouseMove
      OnMouseUp = fm_Preview1MouseUp
    end
    object fm_PreviewTexture: TRadioButton
      Left = 8
      Top = 16
      Width = 65
      Height = 17
      Caption = 'Texture'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = fm_PreviewTextureClick
    end
    object fm_PreviewSample: TRadioButton
      Left = 88
      Top = 16
      Width = 65
      Height = 17
      Caption = 'Sample'
      TabOrder = 2
      OnClick = fm_PreviewSampleClick
    end
    object CheckBox1: TCheckBox
      Left = 168
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Filtering'
      TabOrder = 3
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 144
    Width = 449
    Height = 425
    Caption = 'Effects'
    TabOrder = 3
    object Bevel2: TBevel
      Left = 8
      Top = 400
      Width = 433
      Height = 18
    end
    object fm_EffectsStatus: TLabel
      Left = 16
      Top = 402
      Width = 3
      Height = 13
    end
    object fm_Effects1: TStringGrid
      Left = 8
      Top = 16
      Width = 433
      Height = 384
      BevelEdges = []
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
      ScrollBars = ssVertical
      TabOrder = 0
      OnMouseLeave = fm_Effects1MouseLeave
      OnMouseMove = fm_Effects1MouseMove
      OnMouseUp = fm_Effects1MouseUp
      ColWidths = (
        75
        72
        73
        70
        64)
    end
  end
  object GroupBox5: TGroupBox
    Left = 8
    Top = 576
    Width = 449
    Height = 49
    Caption = 'Texture Generation'
    TabOrder = 4
    object fm_CurEffect: TLabel
      Left = 112
      Top = 8
      Width = 3
      Height = 13
    end
    object fm_TextureSize: TLabel
      Left = 436
      Top = 8
      Width = 3
      Height = 13
      Alignment = taRightJustify
    end
    object Button2: TButton
      Left = 8
      Top = 16
      Width = 89
      Height = 25
      Caption = 'Generate Font'
      TabOrder = 0
      OnClick = Button2Click
    end
    object ProgressBar1: TProgressBar
      Left = 104
      Top = 24
      Width = 337
      Height = 16
      TabOrder = 1
    end
  end
  object GroupBox6: TGroupBox
    Left = 464
    Top = 544
    Width = 345
    Height = 81
    Caption = 'Export / Import'
    TabOrder = 5
    object Button3: TButton
      Left = 8
      Top = 16
      Width = 105
      Height = 25
      Caption = 'Export Effects'
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 8
      Top = 48
      Width = 105
      Height = 25
      Caption = 'Import Effects'
      TabOrder = 1
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 120
      Top = 16
      Width = 105
      Height = 25
      Caption = 'Export PNG'
      TabOrder = 2
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 120
      Top = 48
      Width = 105
      Height = 25
      Caption = 'Export G2F'
      TabOrder = 3
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 231
      Top = 16
      Width = 105
      Height = 25
      Caption = 'Export Header'
      TabOrder = 4
      OnClick = Button7Click
    end
  end
  object fd1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 176
    Top = 24
  end
  object DanJetX1: TDanJetX
    Vsync = True
    States.RenderStates.ZEnable = 0
    States.RenderStates.ZWriteEnable = True
    States.RenderStates.ZFunc = 4
    States.RenderStates.AlphaBlendEnable = True
    States.RenderStates.AlphaTestEnable = True
    States.RenderStates.AlphaRef = 1
    States.RenderStates.AlphaFunc = 7
    States.RenderStates.SrcBlend = 2
    States.RenderStates.DestBlend = 1
    States.RenderStates.SeparateAlphaBlendEnable = False
    States.RenderStates.SrcBlendAlpha = 2
    States.RenderStates.DestBlendAlpha = 1
    States.RenderStates.DiffuseMaterialSource = 1
    States.RenderStates.AmbientMaterialSource = 0
    States.RenderStates.SpecularMaterialSource = 2
    States.RenderStates.EmissiveMaterialSource = 0
    States.RenderStates.ColorVertex = False
    States.RenderStates.StencilEnable = False
    States.RenderStates.StencilFunc = 8
    States.RenderStates.StencilRef = 0
    States.RenderStates.StencilFail = 1
    States.RenderStates.StencilZFail = 1
    States.RenderStates.StencilPass = 1
    States.RenderStates.StencilMask = -1
    States.RenderStates.StencilWriteMask = -1
    States.RenderStates.TwoSidedStencilMode = False
    States.RenderStates.CCW_StencilFail = 1
    States.RenderStates.CCW_StencilZFail = 1
    States.RenderStates.CCW_StencilPass = 1
    States.RenderStates.CCW_StencilFunc = 8
    States.RenderStates.FogEnable = False
    States.RenderStates.FogColor = -16777216
    States.RenderStates.FogTableMode = 0
    States.RenderStates.FogVertexMode = 0
    States.RenderStates.FogEnd = 1.000000000000000000
    States.RenderStates.RangeFogEnable = False
    States.RenderStates.FillMode = 3
    States.RenderStates.ShadeMode = 2
    States.RenderStates.CullMode = 3
    States.RenderStates.DitherEnable = False
    States.RenderStates.SpecularEnable = False
    States.RenderStates.Lighting = False
    States.RenderStates.Ambient = -16777216
    States.RenderStates.NormalizeNormals = True
    States.RenderStates.MultiSampleAntialias = True
    States.RenderStates.MultiSampleMask = -1
    States.RenderStates.ScissorTestEnable = False
    States.RenderStates.ClipPlaneEnbale = False
    States.RenderStates.AntialiasedLineEnable = False
    States.RenderStates.ColorWriteEnable = 0
    InitParams.BBufferFormat = bbX8R8G8B8
    InitParams.AAQuality = 0
    InitParams.MultiThreaded = True
    Left = 472
    Top = 48
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 504
    Top = 48
  end
  object DJXTextureList1: TDJXTextureList
    Left = 472
    Top = 80
  end
  object fm_Input1: TPopupMenu
    Left = 16
    Top = 168
    object None1: TMenuItem
      Caption = 'None'
      OnClick = None1Click
    end
    object Input1: TMenuItem
      Caption = 'Input'
      object Combined1: TMenuItem
        Caption = 'Combined'
        OnClick = Combined1Click
      end
      object Color1: TMenuItem
        Caption = 'Color'
        OnClick = Color1Click
      end
      object Alpha1: TMenuItem
        Caption = 'Alpha'
        OnClick = Alpha1Click
      end
    end
    object emp11: TMenuItem
      Caption = 'Temp1'
      object Combined2: TMenuItem
        Caption = 'Combined'
        OnClick = Combined2Click
      end
      object Color2: TMenuItem
        Caption = 'Color'
        OnClick = Color2Click
      end
      object Alpha2: TMenuItem
        Caption = 'Alpha'
        OnClick = Alpha2Click
      end
    end
    object emp21: TMenuItem
      Caption = 'Temp2'
      object Combined3: TMenuItem
        Caption = 'Combined'
        OnClick = Combined3Click
      end
      object Color3: TMenuItem
        Caption = 'Color'
        OnClick = Color3Click
      end
      object Alpha3: TMenuItem
        Caption = 'Alpha'
        OnClick = Alpha3Click
      end
    end
    object emp31: TMenuItem
      Caption = 'Temp3'
      object Combined4: TMenuItem
        Caption = 'Combined'
        OnClick = Combined4Click
      end
      object Color4: TMenuItem
        Caption = 'Color'
        OnClick = Color4Click
      end
      object Alpha4: TMenuItem
        Caption = 'Alpha'
        OnClick = Alpha4Click
      end
    end
    object emp41: TMenuItem
      Caption = 'Temp4'
      object Combined10: TMenuItem
        Caption = 'Combined'
        OnClick = Combined10Click
      end
      object Color10: TMenuItem
        Caption = 'Color'
        OnClick = Color10Click
      end
      object Alpha10: TMenuItem
        Caption = 'Alpha'
        OnClick = Alpha10Click
      end
    end
    object Image1: TMenuItem
      Caption = 'Image'
      object Combined5: TMenuItem
        Caption = 'Combined'
        OnClick = Combined5Click
      end
      object Color5: TMenuItem
        Caption = 'Color'
        OnClick = Color5Click
      end
      object Alpha5: TMenuItem
        Caption = 'Alpha'
        OnClick = Alpha5Click
      end
    end
  end
  object fm_Operation1: TPopupMenu
    Left = 168
    Top = 168
    object BasicOperations1: TMenuItem
      Caption = 'Basic Operations'
      GroupIndex = 1
      object Copy1: TMenuItem
        Caption = 'Copy'
        GroupIndex = 1
        OnClick = Copy1Click
      end
      object CopyRef: TMenuItem
        Caption = 'Copy Ref'
        GroupIndex = 1
        OnClick = CopyRefClick
      end
      object Overlay1: TMenuItem
        Caption = 'Overlay'
        GroupIndex = 1
        OnClick = Overlay1Click
      end
    end
    object ArithmeticOperations1: TMenuItem
      Caption = 'Arithmetic Operations'
      GroupIndex = 1
      object Add1: TMenuItem
        Caption = 'Add'
        OnClick = Add1Click
      end
      object AddRef1: TMenuItem
        Caption = 'Add Ref'
        GroupIndex = 1
        OnClick = AddRef1Click
      end
      object AddSigned1: TMenuItem
        Caption = 'Add Signed'
        GroupIndex = 1
        OnClick = AddSigned1Click
      end
      object Modulate1: TMenuItem
        Caption = 'Modulate'
        GroupIndex = 1
        OnClick = Modulate1Click
      end
      object ModulateRef1: TMenuItem
        Caption = 'Modulate Ref'
        GroupIndex = 1
        OnClick = ModulateRef1Click
      end
      object Saturate1: TMenuItem
        Caption = 'Saturate'
        GroupIndex = 1
        OnClick = Saturate1Click
      end
      object Scale1: TMenuItem
        Caption = 'Scale'
        GroupIndex = 1
        OnClick = Scale1Click
      end
      object Difference1: TMenuItem
        Caption = 'Difference'
        GroupIndex = 1
        OnClick = Difference1Click
      end
      object Invert1: TMenuItem
        Caption = 'Invert'
        GroupIndex = 1
        OnClick = Invert1Click
      end
    end
    object BlurOperations1: TMenuItem
      Caption = 'Blur Operations'
      GroupIndex = 1
      object BlurH1: TMenuItem
        Caption = 'Blur H'
        GroupIndex = 1
        OnClick = BlurH1Click
      end
      object BlurV1: TMenuItem
        Caption = 'Blur V'
        GroupIndex = 1
        OnClick = BlurV1Click
      end
    end
    object NormalOperations1: TMenuItem
      Caption = 'Normal Operations'
      GroupIndex = 1
      object Normals1: TMenuItem
        Caption = 'Normals'
        GroupIndex = 1
        OnClick = Normals1Click
      end
      object Light1: TMenuItem
        Caption = 'Light'
        GroupIndex = 1
        OnClick = Light1Click
      end
      object Specular1: TMenuItem
        Caption = 'Specular'
        GroupIndex = 1
        OnClick = Specular1Click
      end
      object Reflect1: TMenuItem
        Caption = 'Reflect'
        GroupIndex = 1
        OnClick = Reflect1Click
      end
    end
  end
  object fm_Output1: TPopupMenu
    Left = 240
    Top = 168
    object Output1: TMenuItem
      Caption = 'Output'
      object Combined6: TMenuItem
        Caption = 'Combined'
        OnClick = Combined6Click
      end
      object Color6: TMenuItem
        Caption = 'Color'
        OnClick = Color6Click
      end
      object Alpha6: TMenuItem
        Caption = 'Alpha'
        OnClick = Alpha6Click
      end
    end
    object emp12: TMenuItem
      Caption = 'Temp1'
      object Combined7: TMenuItem
        Caption = 'Combined'
        OnClick = Combined7Click
      end
      object Color7: TMenuItem
        Caption = 'Color'
        OnClick = Color7Click
      end
      object Alpha7: TMenuItem
        Caption = 'Alpha'
        OnClick = Alpha7Click
      end
    end
    object emp22: TMenuItem
      Caption = 'Temp2'
      object Combined8: TMenuItem
        Caption = 'Combined'
        OnClick = Combined8Click
      end
      object Color8: TMenuItem
        Caption = 'Color'
        OnClick = Color8Click
      end
      object Alpha8: TMenuItem
        Caption = 'Alpha'
        OnClick = Alpha8Click
      end
    end
    object emp32: TMenuItem
      Caption = 'Temp3'
      object Combined9: TMenuItem
        Caption = 'Combined'
        OnClick = Combined9Click
      end
      object Color9: TMenuItem
        Caption = 'Color'
        OnClick = Color9Click
      end
      object Alpha9: TMenuItem
        Caption = 'Alpha'
        OnClick = Alpha9Click
      end
    end
    object emp42: TMenuItem
      Caption = 'Temp4'
      object Combined11: TMenuItem
        Caption = 'Combined'
        OnClick = Combined11Click
      end
      object Color11: TMenuItem
        Caption = 'Color'
        OnClick = Color11Click
      end
      object Alpha11: TMenuItem
        Caption = 'Alpha'
        OnClick = Alpha11Click
      end
    end
  end
  object fm_EffectsOptions1: TPopupMenu
    Left = 16
    Top = 512
    object AddEffect1: TMenuItem
      Caption = 'AddEffect'
      OnClick = AddEffect1Click
    end
    object RemoveEffect1: TMenuItem
      Caption = 'RemoveEffect'
      OnClick = RemoveEffect1Click
    end
    object MoveUp1: TMenuItem
      Caption = 'MoveUp'
      OnClick = MoveUp1Click
    end
    object MoveDown1: TMenuItem
      Caption = 'MoveDown'
      OnClick = MoveDown1Click
    end
    object Clear1: TMenuItem
      Caption = 'Clear'
      OnClick = Clear1Click
    end
  end
  object opd1: TOpenPictureDialog
    Filter = 
      'All (*.png;*.jpg;*.jpeg;*.bmp)|*.png;*.jpg;*.jpeg;*.bmp|Portable' +
      ' Network Graphics (*.png)|*.png|JPEG Image File (*.jpg)|*.jpg|JP' +
      'EG Image File (*.jpeg)|*.jpeg|Bitmaps (*.bmp)|*.bmp'
    Left = 16
    Top = 200
  end
  object DJXTextureList2: TDJXTextureList
    Left = 472
    Top = 112
  end
  object od1: TOpenDialog
    DefaultExt = 'ffx'
    Filter = 'DanJetX Texture Font Effects (*.ffx)|*.ffx'
    Left = 472
    Top = 592
  end
  object sd1: TSaveDialog
    DefaultExt = 'ffx'
    Filter = 'DanJetX Texture Font Effects (*.ffx)|*.ffx'
    Left = 472
    Top = 560
  end
  object spd1: TSavePictureDialog
    DefaultExt = 'png'
    Filter = 'Portable Network Graphics (*.png)|*.png'
    Left = 584
    Top = 560
  end
  object sd2: TSaveDialog
    DefaultExt = 'g2f'
    Filter = 'Gen2 Texture Font (*.g2f)|*.g2f'
    Left = 584
    Top = 592
  end
  object sd3: TSaveDialog
    DefaultExt = 'g2fh'
    Filter = 'Gen2 Texture Font Header (*.g2fh)|*.g2fh'
    Left = 696
    Top = 560
  end
end
