unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, Buttons, Math, Grids, DJX, DJXClasses,
  DJXTextures, Menus, PNGImage, D3DX9, Direct3D9, DXTypes, ExtDlgs, ComCtrls,
  Gen2;

type
  TForm1 = class(TForm)
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    fm_FontList1: TComboBox;
    Button1: TButton;
    fm_FontSize1: TSpinEdit;
    fm_FontBold1: TSpeedButton;
    fm_FontItalic1: TSpeedButton;
    fm_FontPreview: TImage;
    fd1: TFontDialog;
    GroupBox2: TGroupBox;
    fm_VSpacing: TSpinEdit;
    Label1: TLabel;
    fm_HSpacing: TSpinEdit;
    Label2: TLabel;
    GroupBox3: TGroupBox;
    fm_Preview1: TPanel;
    GroupBox4: TGroupBox;
    fm_Effects1: TStringGrid;
    DanJetX1: TDanJetX;
    Timer1: TTimer;
    GroupBox5: TGroupBox;
    Button2: TButton;
    DJXTextureList1: TDJXTextureList;
    fm_Input1: TPopupMenu;
    fm_Operation1: TPopupMenu;
    fm_Output1: TPopupMenu;
    Input1: TMenuItem;
    emp11: TMenuItem;
    emp21: TMenuItem;
    Output1: TMenuItem;
    emp12: TMenuItem;
    emp22: TMenuItem;
    Copy1: TMenuItem;
    fm_EffectsOptions1: TPopupMenu;
    AddEffect1: TMenuItem;
    RemoveEffect1: TMenuItem;
    MoveUp1: TMenuItem;
    MoveDown1: TMenuItem;
    None1: TMenuItem;
    BlurH1: TMenuItem;
    BlurV1: TMenuItem;
    CopyRef: TMenuItem;
    Normals1: TMenuItem;
    Image1: TMenuItem;
    opd1: TOpenPictureDialog;
    DJXTextureList2: TDJXTextureList;
    Reflect1: TMenuItem;
    ProgressBar1: TProgressBar;
    fm_CurEffect: TLabel;
    Overlay1: TMenuItem;
    emp31: TMenuItem;
    emp32: TMenuItem;
    fm_TextureSize: TLabel;
    GroupBox6: TGroupBox;
    Button3: TButton;
    Button4: TButton;
    od1: TOpenDialog;
    sd1: TSaveDialog;
    Light1: TMenuItem;
    Modulate1: TMenuItem;
    ModulateRef1: TMenuItem;
    AddRef1: TMenuItem;
    AddSigned1: TMenuItem;
    Specular1: TMenuItem;
    Combined1: TMenuItem;
    Color1: TMenuItem;
    Alpha1: TMenuItem;
    Combined2: TMenuItem;
    Color2: TMenuItem;
    Alpha2: TMenuItem;
    Combined3: TMenuItem;
    Color3: TMenuItem;
    Alpha3: TMenuItem;
    Combined4: TMenuItem;
    Color4: TMenuItem;
    Alpha4: TMenuItem;
    Combined5: TMenuItem;
    Color5: TMenuItem;
    Alpha5: TMenuItem;
    Combined6: TMenuItem;
    Color6: TMenuItem;
    Alpha6: TMenuItem;
    Combined7: TMenuItem;
    Color7: TMenuItem;
    Alpha7: TMenuItem;
    Combined8: TMenuItem;
    Color8: TMenuItem;
    Alpha8: TMenuItem;
    Combined9: TMenuItem;
    Color9: TMenuItem;
    Alpha9: TMenuItem;
    ArithmeticOperations1: TMenuItem;
    Add1: TMenuItem;
    NormalOperations1: TMenuItem;
    BasicOperations1: TMenuItem;
    BlurOperations1: TMenuItem;
    emp41: TMenuItem;
    Combined10: TMenuItem;
    Color10: TMenuItem;
    Alpha10: TMenuItem;
    emp42: TMenuItem;
    Combined11: TMenuItem;
    Color11: TMenuItem;
    Alpha11: TMenuItem;
    Saturate1: TMenuItem;
    fm_PreviewTexture: TRadioButton;
    fm_PreviewSample: TRadioButton;
    fm_PreviewScale: TLabel;
    Button5: TButton;
    spd1: TSavePictureDialog;
    Bevel2: TBevel;
    fm_EffectsStatus: TLabel;
    Scale1: TMenuItem;
    Difference1: TMenuItem;
    Invert1: TMenuItem;
    Clear1: TMenuItem;
    Button6: TButton;
    sd2: TSaveDialog;
    CheckBox1: TCheckBox;
    Button7: TButton;
    sd3: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure fm_FontBold1Click(Sender: TObject);
    procedure fm_FontItalic1Click(Sender: TObject);
    procedure fm_FontSize1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure fm_FontList1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure fm_Effects1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Copy1Click(Sender: TObject);
    procedure AddEffect1Click(Sender: TObject);
    procedure RemoveEffect1Click(Sender: TObject);
    procedure MoveUp1Click(Sender: TObject);
    procedure MoveDown1Click(Sender: TObject);
    procedure BlurH1Click(Sender: TObject);
    procedure BlurV1Click(Sender: TObject);
    procedure CopyRefClick(Sender: TObject);
    procedure Normals1Click(Sender: TObject);
    procedure Reflect1Click(Sender: TObject);
    procedure Overlay1Click(Sender: TObject);
    procedure emp3Alpha1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Light1Click(Sender: TObject);
    procedure Modulate1Click(Sender: TObject);
    procedure ModulateRef1Click(Sender: TObject);
    procedure AddRef1Click(Sender: TObject);
    procedure AddSigned1Click(Sender: TObject);
    procedure Specular1Click(Sender: TObject);
    procedure Combined1Click(Sender: TObject);
    procedure Color1Click(Sender: TObject);
    procedure Alpha1Click(Sender: TObject);
    procedure Combined2Click(Sender: TObject);
    procedure Color2Click(Sender: TObject);
    procedure Alpha2Click(Sender: TObject);
    procedure Combined3Click(Sender: TObject);
    procedure Color3Click(Sender: TObject);
    procedure Alpha3Click(Sender: TObject);
    procedure Combined4Click(Sender: TObject);
    procedure Color4Click(Sender: TObject);
    procedure Alpha4Click(Sender: TObject);
    procedure Combined5Click(Sender: TObject);
    procedure Color5Click(Sender: TObject);
    procedure Alpha5Click(Sender: TObject);
    procedure None1Click(Sender: TObject);
    procedure Combined6Click(Sender: TObject);
    procedure Color6Click(Sender: TObject);
    procedure Alpha6Click(Sender: TObject);
    procedure Combined7Click(Sender: TObject);
    procedure Color7Click(Sender: TObject);
    procedure Alpha7Click(Sender: TObject);
    procedure Combined8Click(Sender: TObject);
    procedure Color8Click(Sender: TObject);
    procedure Alpha8Click(Sender: TObject);
    procedure Combined9Click(Sender: TObject);
    procedure Color9Click(Sender: TObject);
    procedure Alpha9Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Combined10Click(Sender: TObject);
    procedure Color10Click(Sender: TObject);
    procedure Alpha10Click(Sender: TObject);
    procedure Combined11Click(Sender: TObject);
    procedure Color11Click(Sender: TObject);
    procedure Alpha11Click(Sender: TObject);
    procedure Saturate1Click(Sender: TObject);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure fm_Preview1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure fm_Preview1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure fm_Preview1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button5Click(Sender: TObject);
    procedure fm_Effects1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure fm_Effects1MouseLeave(Sender: TObject);
    procedure fm_PreviewSampleClick(Sender: TObject);
    procedure fm_PreviewTextureClick(Sender: TObject);
    procedure fm_Preview1Click(Sender: TObject);
    procedure Scale1Click(Sender: TObject);
    procedure Difference1Click(Sender: TObject);
    procedure Invert1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    TexGenTopFromBottom: Integer;
    ExpImpTopFromBottom: Integer;
    EffBottomFromBottom: Integer;
    Bevel2Top: Integer;
    EffListBottomFromBottom: Integer;
    PrevBottomFromBottom: Integer;
    PrevRightFromRight: Integer;
    PrevPnlBottomFromBottom: Integer;
    PrevPnlRightFromRight: Integer;
    PrevScRightFromRight: Integer;
  end;

  TEffect = record
    Input1: AnsiString;
    Input2: AnsiString;
    Operation: AnsiString;
    Output: AnsiString;
    Reference: AnsiString;
  end;

  TTextureMask = (
    tmCombined,
    tmColor,
    tmAlpha
  );

  TEffectHeader = packed record
    Definition: string[4];
    Version: DWORD;
    EffectCount: DWORD;
  end;
  TFileEffect = packed record
    Input1: string[128];
    Input2: string[128];
    Operation: string[16];
    Output: string[16];
    Reference: string[16];
  end;

  TCharProp = packed record
    Width: Byte;
    Height: Byte;
  end;

  TG2FontFile = packed record
    Definition: array[0..3] of AnsiChar;
    Version: DWord;
    FontFace: AnsiString;
    FontSize: Integer;
    DataSize: Int64;
    Chars: array[0..255] of TCharProp;
  end;

  procedure Initialize;
  procedure Finalize;
  procedure ChangeFont;
  procedure RenderFont;
  procedure GenerateFont;
  function GetParam(Str: AnsiString; SubStr: AnsiString; Param: integer): AnsiString;
  procedure ApplyEffects;
  function GetMaxCharWidth: integer;
  function GetMaxCharHeight: integer;
  function GetTextureWidth: integer;
  function GetTextureHeight: integer;
  function PointToStr(Pt: TPoint): AnsiString;
  function StrToPoint(Str: AnsiString): TPoint;
  function ColToStr(Col: TDJXColor): AnsiString;
  function StrToCol(Str: AnsiString): TDJXColor;
  procedure UpdateEffects;

var
  Form1: TForm1;
  CurFont: TFont;
  GeneratedFont: TFont;
  TestText: AnsiString = 'ABCDabcd1234';
  tex_Input: TDJXTexture;
  tex_Output: TDJXTexture;
  tex_Temp1: TDJXTexture;
  tex_Temp2: TDJXTexture;
  tex_Temp3: TDJXTexture;
  tex_Temp4: TDJXTexture;
  Effects: array of TEffect;
  CurCell: TPoint;
  g_CharWidth: integer;
  g_CharHeight: integer;
  g_Scale: single = 1;
  md: boolean = false;
  mc: TPoint;
  TexShift: TPoint;

const
  EffectsVersion = $00010000;
  EffectsDefinition = 'FFX ';

implementation

uses Unit2, Unit3, Unit4;

{$R *.dfm}

procedure ExportEffects(f: String);
var
  Header: TEffectHeader;
  FileEffect: TFileEffect;
  i: integer;
  fs: TFileStream;
begin
  fs := TFileStream.Create(f, fmCreate);
  Header.Definition := EffectsDefinition;
  Header.Version := EffectsVersion;
  Header.EffectCount := Length(Effects);
  fs.WriteBuffer(Header, SizeOf(Header));
  for i := 0 to High(Effects) do
  begin
    FileEffect.Input1 := Effects[i].Input1;
    FileEffect.Input2 := Effects[i].Input2;
    FileEffect.Operation := Effects[i].Operation;
    FileEffect.Output := Effects[i].Output;
    FileEffect.Reference := Effects[i].Reference;
    fs.WriteBuffer(FileEffect, SizeOf(FileEffect));
  end;
  fs.Free;
end;

procedure ImportEffects(f: string);
var
  Header: TEffectHeader;
  FileEffect: TFileEffect;
  i: integer;
  fs: TFileStream;
begin
  fs := TFileStream.Create(f, fmOpenRead);
  if fs.Size < SizeOf(Header) then
  begin
    fs.Free;
    Exit;
  end;
  fs.ReadBuffer(Header, SizeOf(Header));
  if (Header.Definition <> EffectsDefinition)
  or (Header.Version <> EffectsVersion) then
  begin
    fs.Free;
    Exit;
  end;
  SetLength(Effects, Header.EffectCount);
  for i := 0 to Header.EffectCount - 1 do
  begin
    fs.ReadBuffer(FileEffect, SizeOf(FileEffect));
    Effects[i].Input1 := FileEffect.Input1;
    Effects[i].Input2 := FileEffect.Input2;
    Effects[i].Operation := FileEffect.Operation;
    Effects[i].Output := FileEffect.Output;
    Effects[i].Reference := FileEffect.Reference;
  end;
  fs.Free;
  UpdateEffects;
end;

function MakePNG: TPNGObject;
type
  TCol = record
    b, g, r: byte;
  end;
  TColArray = array[0..0] of TCol;
  PColArray = ^TColArray;
var
  png: TPNGObject;
  bmp: TBitmap;
  i, j: integer;
  Col: TDJXColor;
  PBColor: PColArray;
  PBAlpha: PByteArray;
begin
  if tex_Output = nil then
  begin
    Result := nil;
    Exit;
  end;
  bmp := TBitmap.Create;
  bmp.Width := GetTextureWidth;
  bmp.Height := GetTextureHeight;
  bmp.PixelFormat := pf24bit;
  png := TPNGObject.Create;
  png.Assign(bmp);
  bmp.Free;
  png.CreateAlpha;
  tex_Output.TexLock;
  for j := 0 to png.Height - 1 do
  begin
    PBColor := png.Scanline[j];
    PBAlpha := png.AlphaScanline[j];
    for i := 0 to png.Width - 1 do
    begin
      Col := tex_Output.Pixels[i, j];
      PBColor^[i].r := DJXColorR(Col);
      PBColor^[i].g := DJXColorG(Col);
      PBColor^[i].b := DJXColorB(Col);
      PBAlpha^[i] := DJXColorA(Col);
    end;
  end;
  tex_Output.TexUnLock;
  Result := png;
end;

procedure ExportPNG(f: string);
var
  png: TPNGObject;
begin
  png := MakePNG;
  png.SaveToFile(f);
  png.Free;
end;

procedure ExportG2F(f: string);
var
  FontFile: TG2FontFile;
  png: TPNGObject;
  fs: TG2FileRW;
  ms: TMemoryStream;
  PrevFont: TFont;
  i: integer;
const
  Definition = 'G2F ';
  Version = $00010001;
begin
  FontFile.Definition := Definition;
  FontFile.Version := Version;
  PrevFont := TFont.Create;
  PrevFont.Assign(Form1.Canvas.Font);
  FontFile.FontFace := GeneratedFont.Name;
  FontFile.FontSize := GeneratedFont.Size;
  Form1.Canvas.Font.Assign(GeneratedFont);
  for i := 0 to 255 do
  begin
    FontFile.Chars[i].Width := Form1.Canvas.TextWidth(Chr(i));
    FontFile.Chars[i].Height := Form1.Canvas.TextHeight(Chr(i));
  end;
  Form1.Canvas.Font.Assign(PrevFont);
  PrevFont.Free;
  ms := TMemoryStream.Create;
  png := MakePNG;
  png.SaveToStream(ms);
  png.Free;
  FontFile.DataSize := ms.Size;
  fs := TG2FileRW.Create;
  fs.OpenWrite(f);
  fs.Compression := False;
  fs.WriteBuffer(FontFile.Definition, 4);
  fs.Write(FontFile.Version);
  fs.Write(FontFile.FontFace);
  fs.Write(FontFile.FontSize);
  fs.Write(FontFile.DataSize);
  fs.WriteBuffer(FontFile.Chars, SizeOf(FontFile.Chars));
  ms.SaveToStream(fs.Stream);
  ms.Free;
  fs.Free;
end;

procedure ExportG2FH(f: string);
var
  FontFile: TG2FontFile;
  png: TPNGObject;
  fs: TG2FileRW;
  ms: TMemoryStream;
  PrevFont: TFont;
  i: integer;
const
  Definition = 'G2FH';
  Version = $00010000;
begin
  FontFile.Definition := Definition;
  FontFile.Version := Version;
  PrevFont := TFont.Create;
  PrevFont.Assign(Form1.Canvas.Font);
  FontFile.FontFace := GeneratedFont.Name;
  FontFile.FontSize := GeneratedFont.Size;
  FontFile.DataSize := 0;
  Form1.Canvas.Font.Assign(GeneratedFont);
  for i := 0 to 255 do
  begin
    FontFile.Chars[i].Width := Form1.Canvas.TextWidth(Chr(i));
    FontFile.Chars[i].Height := Form1.Canvas.TextHeight(Chr(i));
  end;
  Form1.Canvas.Font.Assign(PrevFont);
  PrevFont.Free;
  fs := TG2FileRW.Create;
  fs.OpenWrite(f);
  fs.Compression := False;
  fs.WriteBuffer(FontFile.Definition, 4);
  fs.Write(FontFile.Version);
  fs.Write(FontFile.FontFace);
  fs.Write(FontFile.FontSize);
  fs.Write(FontFile.DataSize);
  fs.WriteBuffer(FontFile.Chars, SizeOf(FontFile.Chars));
  fs.Free;
end;

procedure Initialize;
var
  i: integer;
begin
  with Form1 do
  begin
    ReportMemoryLeaksOnShutdown := True;
    od1.InitialDir := GetCurrentDir;
    opd1.InitialDir := GetCurrentDir;
    DanJetX1.Width := fm_Preview1.ClientWidth;
    DanJetX1.Height := fm_Preview1.ClientHeight;
    DanJetX1.Start(fm_Preview1.Handle);
    Timer1.Enabled := true;
    CurFont := TFont.Create;
    GeneratedFont := TFont.Create;
    fm_FontList1.Items.Assign(Screen.Fonts);
    fm_FontList1.ItemIndex := 0;
    fm_FontSize1.Value := 16;
    for i := 0 to fm_Effects1.ColCount - 1 do
    fm_Effects1.ColWidths[i] := fm_Effects1.Width div fm_Effects1.ColCount - 6;
    fm_Effects1.Cells[0, 0] := 'Input1';
    fm_Effects1.Cells[1, 0] := 'Input2';
    fm_Effects1.Cells[2, 0] := 'Operation';
    fm_Effects1.Cells[3, 0] := 'Output';
    fm_Effects1.Cells[4, 0] := 'Reference';
    ChangeFont;
    SetLength(Effects, 1);
    Effects[0].Input1 := 'Input';
    Effects[0].Input2 := 'None';
    Effects[0].Operation := 'Copy';
    Effects[0].Output := 'Output';
    Effects[0].Reference := '0,0';
    UpdateEffects;
  end;
end;

procedure Finalize;
begin
  CurFont.Free;
  GeneratedFont.Free;
end;

procedure Render;
var
  i, j, xc, yc: integer;
  x, y: single;
  CharWidth: integer;
  CharHeight: integer;
begin
  with Form1 do
  begin
    DanJetX1.ClearScreen($ff999999);
    DanJetX1.BeginRender;

    xc := fm_Preview1.Width div 16 + 1;
    yc := fm_Preview1.Height div 16 + 1;
    for j := 0 to yc do
    for i := 0 to xc do
    begin
      if Odd(i) = Odd(j) then
      DanJetX1.Primitives2D.Rectangle(
        i * 16, j * 16,
        16, 16,
        $ff777777
      );
    end;

    if CheckBox1.Checked then
    DanJetX1.Filtering := True;
    if tex_Output <> nil then
    begin
      CharWidth := g_CharWidth;
      CharHeight := g_CharHeight;
      if fm_PreviewTexture.Checked then
      begin
        tex_Output.Draw(
          TexShift.X, TexShift.Y, $ffffffff,
          0, 0, 0, g_Scale, g_Scale
        );
      end;
      if fm_PreviewSample.Checked then
      begin
        for i := 1 to Length(TestText) do
        begin
          x := TexShift.X + (DanJetX1.Width - Length(TestText) * CharWidth) / 2 + CharWidth * (i - 1);
          y := TexShift.Y + (DanJetX1.Height - CharHeight * 4) / 2;
          tex_Output.Draw(
            x,
            y,
            $ffffffff,
            Ord(TestText[i]),
            CharWidth, CharHeight
          );
          tex_Output.Draw4Col(
            x, y + CharHeight * 1,
            x + CharWidth, y + CharHeight * 1,
            x + CharWidth, y + CharHeight + CharHeight * 1,
            x, y + CharHeight + CharHeight * 1,
            $ffffffff, $ffffffff, $ffff0000, $ffff0000,
            Ord(TestText[i]),
            CharWidth, CharHeight
          );
          tex_Output.Draw4Col(
            x, y + CharHeight * 2,
            x + CharWidth, y + CharHeight * 2,
            x + CharWidth, y + CharHeight + CharHeight * 2,
            x, y + CharHeight + CharHeight * 2,
            $ffffffff, $ffffffff, $ff00ff00, $ff00ff00,
            Ord(TestText[i]),
            CharWidth, CharHeight
          );
          tex_Output.Draw4Col(
            x, y + CharHeight * 3,
            x + CharWidth, y + CharHeight * 3,
            x + CharWidth, y + CharHeight + CharHeight * 3,
            x, y + CharHeight + CharHeight * 3,
            $ffffffff, $ffffffff, $ff0000ff, $ff0000ff,
            Ord(TestText[i]),
            CharWidth, CharHeight
          );
        end;
      end;
    end;
    if CheckBox1.Checked then
    DanJetX1.Filtering := False;

    DanJetX1.Primitives2D.Filled := false;
    DanJetX1.Primitives2D.Rectangle(
      0, 0,
      fm_Preview1.ClientWidth - 1,
      fm_Preview1.ClientHeight - 1,
      $ff000000
    );
    DanJetX1.Primitives2D.Filled := true;

    DanJetX1.EndRender;
  end;
end;

procedure ChangeFont;
begin
  with Form1 do
  begin
    CurFont.Style := [];
    CurFont.Name := fm_FontList1.Text;
    CurFont.Size := fm_FontSize1.Value;
    if fm_FontBold1.Down then CurFont.Style := CurFont.Style + [fsBold];
    if fm_FontItalic1.Down then CurFont.Style := CurFont.Style + [fsItalic];
  end;
  RenderFont;
end;

procedure RenderFont;
var
  Pos: TPoint;
begin
  with Form1 do
  begin
    fm_FontPreview.Canvas.Pen.Width := 1;
    fm_FontPreview.Canvas.Pen.Color := clBlack;
    fm_FontPreview.Canvas.Brush.Color := clWhite;
    fm_FontPreview.Canvas.Brush.Style := bsSolid;
    fm_FontPreview.Canvas.Rectangle(fm_FontPreview.ClientRect);

    fm_FontPreview.Canvas.Font.Assign(CurFont);
    fm_FontPreview.Canvas.Font.Color := clBlack;
    Pos := Point(
      (fm_FontPreview.Width - fm_FontPreview.Canvas.TextWidth(TestText)) div 2,
      (fm_FontPreview.Height - fm_FontPreview.Canvas.TextHeight(TestText)) div 2
    );
    fm_FontPreview.Canvas.TextOut(Pos.X, Pos.Y, TestText);

    fm_FontPreview.Canvas.Pen.Width := 1;
    fm_FontPreview.Canvas.Pen.Color := clBlack;
    fm_FontPreview.Canvas.Brush.Color := clNone;
    fm_FontPreview.Canvas.Brush.Style := bsClear;
    fm_FontPreview.Canvas.Rectangle(fm_FontPreview.ClientRect);
  end;
end;

procedure GenerateFont;
type
  TCol = record
    b, g, r: byte;
  end;
  TColArr = array[0..0] of TCol;
  PColArr = ^TColArr;
var
  TexWidth, TexHeight: integer;
  CWidth, CHeight: integer;
  SWidth, SHeight: integer;
  bmp: TBitmap;
  png: TPNGObject;
  i, j: integer;
  pb: PByteArray;
  pc: PColArr;
begin
  with Form1 do
  begin
    GeneratedFont.Assign(CurFont); 
    TexWidth := GetTextureWidth;
    TexHeight := GetTextureHeight;
    g_Scale := 1;
    fm_PreviewScale.Caption := IntToStr(Round(g_Scale * 100)) + '%';
    TexShift := Point(0, 0);
    if Max(TexWidth, TexHeight) > 1024 then
    fm_TextureSize.Font.Color := clRed
    else
    fm_TextureSize.Font.Color := clBlack;
    fm_TextureSize.Caption := IntToStr(TexWidth) + 'x' + IntToStr(TexHeight);
    DJXTextureList1.FreeTextures;
    tex_Temp1 := DJXTextureList1.CreateTexture(TexWidth, TexHeight, 'Temp1');
    tex_Temp2 := DJXTextureList1.CreateTexture(TexWidth, TexHeight, 'Temp2');
    tex_Temp3 := DJXTextureList1.CreateTexture(TexWidth, TexHeight, 'Temp3');
    tex_Temp4 := DJXTextureList1.CreateTexture(TexWidth, TexHeight, 'Temp4');
    tex_Output := DJXTextureList1.CreateTexture(TexWidth, TexHeight, 'Output');
    bmp := TBitmap.Create;
    bmp.PixelFormat := pf24bit;
    bmp.Width := TexWidth;
    bmp.Height := TexHeight;
    bmp.Canvas.Pen.Color := clBlack;
    bmp.Canvas.Brush.Color := clBlack;
    bmp.Canvas.Rectangle(
      bmp.Canvas.ClipRect
    );
    bmp.Canvas.Font.Assign(CurFont);
    bmp.Canvas.Font.Color := clWhite;
    SWidth := Trunc(TexWidth / 16);
    SHeight := Trunc(TexHeight / 16);
    for j := 0 to 15 do
    for i := 0 to 15 do
    begin
      CWidth := bmp.Canvas.TextWidth(Chr(j * 16 + i));
      CHeight := bmp.Canvas.TextHeight(Chr(j * 16 + i));
      bmp.Canvas.TextOut(
        i * SWidth + (SWidth - CWidth) div 2,
        j * SHeight + (SHeight - CHeight) div 2,
        Chr(j * 16 + i)
      );
    end;
    png := TPNGObject.Create;
    png.Assign(bmp);
    png.CreateAlpha;
    for j := 0 to png.Height - 1 do
    begin
      pb := png.AlphaScanline[j];
      pc := bmp.ScanLine[j];
      for i := 0 to png.Width - 1 do
      pb^[i] := trunc((pc^[i].b + pc^[i].g + pc^[i].r) / 3);
    end;
    bmp.Free;
    tex_Input := DJXTextureList1.CreateTextureFromGraphic(png, 'Input');
    png.Free;
    ApplyEffects;
  end;
end;

function GetParam(Str: AnsiString; SubStr: AnsiString; Param: integer): AnsiString;
var
  i: integer;
  j: integer;
  CurParam: integer;
  PrevParamIndex: integer;
  b: boolean;
begin
  Result := '';
  b := false;
  CurParam := 0;
  PrevParamIndex := 1;
  for i := 1 to Length(Str) do
  begin
    for j := 1 to Length(SubStr) do
    begin
      if Str[i + j] <> SubStr[j] then
      break
      else
      begin
        if j = length(SubStr) then
        begin
          if CurParam = Param then
          begin
            b := true;
            SetLength(Result, i - PrevParamIndex + 1);
            move(Str[PrevParamIndex], Result[1], Length(Result));
          end
          else
          begin
            CurParam := CurParam + 1;
            PrevParamIndex := i + Length(SubStr) + 1;
          end;
        end;
      end;
    end;
    if b then break;
    if (i = Length(Str)) and (CurParam = Param) then
    begin
      SetLength(Result, i - PrevParamIndex + 1);
      move(Str[PrevParamIndex], Result[1], Length(Result));
    end;
  end;
end;

procedure AssignColorMask(var Col: TD3DXVector4; Mask: TTextureMask);
begin
  if Mask = tmAlpha then
  begin
    Col.x := Col.w;
    Col.y := Col.w;
    Col.z := Col.w;
  end;
  if Mask = tmColor then
  begin
    Col.w := (Min(Max(Col.x, 0), 1) + Min(Max(Col.y, 0), 1) + Min(Max(Col.z, 0), 1)) / 3;
  end;
end;

procedure WriteColorMask(
      var DstCol: TD3DXVector4;
      const SrcCol: TD3DXVector4;
      Mask: TTextureMask
    );
begin
  case Mask of
    tmAlpha: DstCol.w := SrcCol.w;
    tmColor:
    begin
      DstCol.x := SrcCol.x;
      DstCol.y := SrcCol.y;
      DstCol.z := SrcCol.z;
    end;
    else
    begin
      DstCol.x := SrcCol.x;
      DstCol.y := SrcCol.y;
      DstCol.z := SrcCol.z;
      DstCol.w := SrcCol.w;
    end;
  end;
end;

procedure SampleTexture(
      Texture: TDJXTexture;
      x, y: integer;
      var OutCol: TD3DXVector4;
      IgnoreTexType: boolean = false
    ); inline;
var
  col: TDJXColor;
  sx, sy: integer;
  Width, Height: integer;
  PerChar: boolean;
begin
  Width := Texture.Width;
  Height := Texture.Height;
  if not IgnoreTexType and
  (
    Texture.Name[1] +
    Texture.Name[2] +
    Texture.Name[3] +
    Texture.Name[4] +
    Texture.Name[5] = 'Image'
  ) then
  begin
    PerChar := true;
    Width := g_CharWidth;
    Height := g_CharHeight;
  end
  else
  begin
    PerChar := false;
  end;
  if x < 0 then sx := Width - (abs(x) mod Width)
  else sx := x mod Width;
  if y < 0 then sy := Height - (abs(y) mod Height)
  else sy := y mod Height;
  if PerChar then
  begin
    sx := trunc((sx / Width) * Texture.Width);
    sy := trunc((sy / Height) * Texture.Height);
  end;
  col := Texture.Pixels[sx, sy];
  OutCol.x := DJXColorR(col) / 255;
  OutCol.y := DJXColorG(col) / 255;
  OutCol.z := DJXColorB(col) / 255;
  OutCol.w := DJXColorA(col) / 255;
end;

procedure WriteTexture(
      Texture: TDJXTexture;
      x, y: integer;
      InCol: TD3DXVector4
    ); inline;
begin
  Texture.Pixels[x, y] := DJXColor(
    trunc(Max(Min(InCol.x, 1), 0) * 255),
    trunc(Max(Min(InCol.y, 1), 0) * 255),
    trunc(Max(Min(InCol.z, 1), 0) * 255),
    trunc(Max(Min(InCol.w, 1), 0) * 255)
  );
end;

procedure EffectCopy(
      Input, Output: TDJXTexture;
      Shift: TPoint;
      InputMask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol: TD3DXVector4;
  OutCol: TD3DXVector4;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    SampleTexture(Input, i - Shift.X, j - Shift.Y, InCol);
    SampleTexture(Output, i, j, OutCol);
    AssignColorMask(InCol, InputMask);
    WriteColorMask(OutCol, InCol, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectCopyRef(
      Output: TDJXTexture;
      Ref: TDJXColor;
      OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol: TD3DXVector4;
  OutCol: TD3DXVector4;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    InCol := D3DXVector4(
      DJXColorR(Ref) / 255,
      DJXColorG(Ref) / 255,
      DJXColorB(Ref) / 255,
      DJXColorA(Ref) / 255
    );
    SampleTexture(Output, i, j, OutCol);
    WriteColorMask(OutCol, InCol, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectScale(
      Input: TDJXTexture;
      Output: TDJXTexture;
      Ref: integer;
      InputMask: TTextureMask;
      OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol: TD3DXVector4;
  OutCol: TD3DXVector4;
  s: single;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    SampleTexture(Input, i, j, InCol);
    SampleTexture(Output, i, j, OutCol);
    AssignColorMask(InCol, InputMask);
    s := Ref / 100;
    D3DXVec4Scale(InCol, InCol, s);
    WriteColorMask(OutCol, InCol, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectAdd(
      Input1, Input2, Output: TDJXTexture;
      Input1Mask, Input2Mask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol1: TD3DXVector4;
  InCol2: TD3DXVector4;
  OutCol: TD3DXVector4;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    SampleTexture(Input1, i, j, InCol1);
    SampleTexture(Input2, i, j, InCol2);
    SampleTexture(Output, i, j, OutCol);
    AssignColorMask(InCol1, Input1Mask);
    AssignColorMask(InCol2, Input2Mask);
    D3DXVec4Add(InCol1, InCol1, InCol2);
    WriteColorMask(OutCol, InCol1, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectAddRef(
      Input: TDJXTexture;
      Output: TDJXTexture;
      Ref: TDJXColor;
      InputMask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol1: TD3DXVector4;
  InCol2: TD3DXVector4;
  OutCol: TD3DXVector4;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    InCol1 := D3DXVector4(
      DJXColorR(Ref) / 255,
      DJXColorG(Ref) / 255,
      DJXColorB(Ref) / 255,
      DJXColorA(Ref) / 255
    );
    SampleTexture(Input, i, j, InCol2);
    SampleTexture(Output, i, j, OutCol);
    AssignColorMask(InCol2, InputMask);
    D3DXVec4Add(InCol1, InCol1, InCol2);
    WriteColorMask(OutCol, InCol1, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectAddSigned(
      Input1, Input2, Output: TDJXTexture;
      Input1Mask, Input2Mask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol1: TD3DXVector4;
  InCol2: TD3DXVector4;
  OutCol: TD3DXVector4;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    SampleTexture(Input1, i, j, InCol1);
    SampleTexture(Input2, i, j, InCol2);
    SampleTexture(Output, i, j, OutCol);
    AssignColorMask(InCol1, Input1Mask);
    AssignColorMask(InCol2, Input2Mask);
    InCol1.x := InCol1.x * 2 - 1;
    InCol1.y := InCol1.y * 2 - 1;
    InCol1.z := InCol1.z * 2 - 1;
    InCol1.w := InCol1.w * 2 - 1;
    InCol2.x := InCol2.x * 2 - 1;
    InCol2.y := InCol2.y * 2 - 1;
    InCol2.z := InCol2.z * 2 - 1;
    InCol2.w := InCol2.w * 2 - 1;
    D3DXVec4Add(InCol1, InCol1, InCol2);
    InCol1.x := InCol1.x * 0.5 + 0.5;
    InCol1.y := InCol1.y * 0.5 + 0.5;
    InCol1.z := InCol1.z * 0.5 + 0.5;
    InCol1.w := InCol1.w * 0.5 + 0.5;
    WriteColorMask(OutCol, InCol1, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectModulate(
      Input1, Input2, Output: TDJXTexture;
      Input1Mask, Input2Mask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol1: TD3DXVector4;
  InCol2: TD3DXVector4;
  OutCol: TD3DXVector4;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    SampleTexture(Input1, i, j, InCol1);
    SampleTexture(Input2, i, j, InCol2);
    SampleTexture(Output, i, j, OutCol);
    AssignColorMask(InCol1, Input1Mask);
    AssignColorMask(InCol2, Input2Mask);
    InCol1.x := InCol1.x * InCol2.x;
    InCol1.y := InCol1.y * InCol2.y;
    InCol1.z := InCol1.z * InCol2.z;
    InCol1.w := InCol1.w * InCol2.w;
    WriteColorMask(OutCol, InCol1, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectModulateRef(
      Input: TDJXTexture;
      Output: TDJXTexture;
      Ref: TDJXColor;
      InputMask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol1: TD3DXVector4;
  InCol2: TD3DXVector4;
  OutCol: TD3DXVector4;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    InCol1 := D3DXVector4(
      DJXColorR(Ref) / 255,
      DJXColorG(Ref) / 255,
      DJXColorB(Ref) / 255,
      DJXColorA(Ref) / 255
    );
    SampleTexture(Input, i, j, InCol2);
    SampleTexture(Output, i, j, OutCol);
    AssignColorMask(InCol2, InputMask);
    InCol1.x := InCol1.x * InCol2.x;
    InCol1.y := InCol1.y * InCol2.y;
    InCol1.z := InCol1.z * InCol2.z;
    InCol1.w := InCol1.w * InCol2.w;
    WriteColorMask(OutCol, InCol1, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectSaturate(
      Input1, Output: TDJXTexture;
      Ref: TDJXColor;
      Input1Mask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol1: TD3DXVector4;
  InCol2: TD3DXVector4;
  OutCol: TD3DXVector4;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    InCol1 := D3DXVector4(
      DJXColorR(Ref) / 255,
      DJXColorG(Ref) / 255,
      DJXColorB(Ref) / 255,
      DJXColorA(Ref) / 255
    );
    SampleTexture(Input1, i, j, InCol2);
    SampleTexture(Output, i, j, OutCol);
    AssignColorMask(InCol2, Input1Mask);
    InCol2.x := InCol2.x * 2 - 1;
    InCol2.y := InCol2.y * 2 - 1;
    InCol2.z := InCol2.z * 2 - 1;
    InCol2.w := InCol2.w * 2 - 1;
    InCol1.x := InCol1.x * InCol2.x;
    InCol1.y := InCol1.y * InCol2.y;
    InCol1.z := InCol1.z * InCol2.z;
    InCol1.w := InCol1.w * InCol2.w;
    InCol1.x := InCol1.x * 0.5 + 0.5;
    InCol1.y := InCol1.y * 0.5 + 0.5;
    InCol1.z := InCol1.z * 0.5 + 0.5;
    InCol1.w := InCol1.w * 0.5 + 0.5;
    WriteColorMask(OutCol, InCol1, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectDifference(
      Input1, Input2, Output: TDJXTexture;
      Input1Mask, Input2Mask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol1: TD3DXVector4;
  InCol2: TD3DXVector4;
  OutCol: TD3DXVector4;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    SampleTexture(Input1, i, j, InCol1);
    SampleTexture(Input2, i, j, InCol2);
    SampleTexture(Output, i, j, OutCol);
    AssignColorMask(InCol1, Input1Mask);
    AssignColorMask(InCol2, Input2Mask);
    InCol1.x := Abs(InCol1.x - InCol2.x);
    InCol1.y := Abs(InCol1.y - InCol2.y);
    InCol1.z := Abs(InCol1.z - InCol2.z);
    InCol1.w := Abs(InCol1.w - InCol2.w);
    WriteColorMask(OutCol, InCol1, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectInvert(
      Input, Output: TDJXTexture;
      InputMask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol: TD3DXVector4;
  OutCol: TD3DXVector4;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    SampleTexture(Input, i, j, InCol);
    SampleTexture(Output, i, j, OutCol);
    AssignColorMask(InCol, InputMask);
    InCol.x := 1 - InCol.x;
    InCol.y := 1 - InCol.y;
    InCol.z := 1 - InCol.z;
    InCol.w := 1 - InCol.w;
    WriteColorMask(OutCol, InCol, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectOverlay(
      Input1, Input2, Output: TDJXTexture;
      Shift: TPoint;
      Input1Mask, Input2Mask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol1: TD3DXVector4;
  InCol2: TD3DXVector4;
  InCol: TD3DXVector4;
  OutCol: TD3DXVector4;
  c1, c2, c3, k: single;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    SampleTexture(Input1, i - Shift.X, j - Shift.Y, InCol1);
    SampleTexture(Input2, i, j, InCol2);
    SampleTexture(Output, i, j, OutCol);
    AssignColorMask(InCol1, Input1Mask);
    AssignColorMask(InCol2, Input2Mask);
    c3 := InCol1.w + InCol2.w;
    c1 := InCol1.w;
    c2 := Min(1 - InCol1.w, InCol2.w);
    k := 1 / (c1 + c2);
    c1 := c1 * k;
    c2 := c2 * k;
    InCol := D3DXVector4(
      InCol1.x * c1 + InCol2.x * c2,
      InCol1.y * c1 + InCol2.y * c2,
      InCol1.z * c1 + InCol2.z * c2,
      c3
    );
    WriteColorMask(OutCol, InCol, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectNormals(
      Input, Output: TDJXTexture;
      InputMask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  x, y, t: integer;
  InCol: TD3DXVector4;
  OutCol: TD3DXVector4;
  TexCol: array[0..2, 0..2] of TD3DXVector4;
  v3: TD3DXVector3;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    for y := -1 to 1 do
    for x := -1 to 1 do
    begin
      SampleTexture(Input, i + x, j + y, TexCol[x + 1, y + 1]);
      AssignColorMask(TexCol[x + 1, y + 1], InputMask);
    end;
    InCol := D3DXVector4(0, 0, 1, TexCol[1, 1].w);
    for t := 0 to 2 do
    begin
      InCol.x := InCol.x + (TexCol[0, t].x - TexCol[1, t].x) + (TexCol[1, t].x - TexCol[2, t].x);
      InCol.y := InCol.y + (TexCol[t, 0].y - TexCol[t, 1].y) + (TexCol[t, 1].y - TexCol[t, 2].y);
    end;
    Move(InCol, v3, SizeOf(v3));
    D3DXVec3Normalize(v3, v3);
    Move(v3, InCol, SizeOf(v3));
    InCol.x := InCol.x * 0.5 + 0.5;
    InCol.y := InCol.y * 0.5 + 0.5;
    InCol.z := InCol.z * 0.5 + 0.5;
    SampleTexture(Output, i, j, OutCol);
    WriteColorMask(OutCol, InCol, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectReflect(
      Input1, Input2, Output: TDJXTexture;
      Input1Mask, Input2Mask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol1: TD3DXVector4;
  InCol2: TD3DXVector4;
  OutCol: TD3DXVector4;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    SampleTexture(Input1, i, j, InCol1);
    AssignColorMask(InCol1, Input1Mask);
    InCol1.x := InCol1.x * 2 - 1;
    InCol1.y := InCol1.y * 2 - 1;
    InCol1.z := InCol1.z * 2 - 1;
    SampleTexture(
      Input2,
      trunc((Input2.Width div 2) + (Input2.Width div 2) * InCol1.x),
      trunc((Input2.Height div 2) + (Input2.Height div 2) * InCol1.y),
      InCol2,
      true
    );
    AssignColorMask(InCol2, Input2Mask);
    SampleTexture(Output, i, j, OutCol);
    WriteColorMask(OutCol, InCol2, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectLight(
      Input, Output: TDJXTexture;
      InputMask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol: TD3DXVector4;
  OutCol: TD3DXVector4;
  Normal: TD3DXVector3;
  LightDir: TD3DXVector3;
  dp: single;
begin
  LightDir := D3DXVector3(-1, -1, 1);
  D3DXVec3Normalize(LightDir, LightDir);
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    SampleTexture(Input, i, j, InCol);
    AssignColorMask(InCol, InputMask);
    Normal := D3DXVector3(InCol.x, InCol.y, InCol.z);
    Normal.x := Normal.x * 2 - 1;
    Normal.y := Normal.y * 2 - 1;
    Normal.z := Normal.z * 2 - 1;
    D3DXVec3Normalize(Normal, Normal);
    dp := D3DXVec3Dot(Normal, LightDir);
    InCol.x := dp;
    InCol.y := dp;
    InCol.z := dp;
    InCol.w := dp;
    SampleTexture(Output, i, j, OutCol);
    WriteColorMask(OutCol, InCol, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectSpecular(
      Input, Output: TDJXTexture;
      Pow: integer;
      InputMask, OutputMask: TTextureMask
    );
var
  i, j: integer;
  InCol: TD3DXVector4;
  OutCol: TD3DXVector4;
  Normal: TD3DXVector3;
  LightDir: TD3DXVector3;
  EyeDir: TD3DXVector3;
  TmpVec: TD3DXVector3;
  Reflection: TD3DXVector3;
  Tmp, dp: single;
begin
  LightDir := D3DXVector3(-1, -1, 1);
  D3DXVec3Normalize(LightDir, LightDir);
  EyeDir := D3DXVector3(0, 0, -1);
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    SampleTexture(Input, i, j, InCol);
    AssignColorMask(InCol, InputMask);
    Normal := D3DXVector3(InCol.x, InCol.y, InCol.z);
    Normal.x := Normal.x * 2 - 1;
    Normal.y := Normal.y * 2 - 1;
    Normal.z := Normal.z * 2 - 1;
    D3DXVec3Normalize(Normal, Normal);
    Tmp := D3DXVec3Dot(Normal, EyeDir);
    D3DXVec3Scale(TmpVec, Normal, 2 * Tmp);
    D3DXVec3Subtract(Reflection, EyeDir, TmpVec);
    D3DXVec3Normalize(Reflection, Reflection);
    dp := D3DXVec3Dot(Reflection, LightDir);
    dp := Min(Max(dp, 0), 1);
    dp := Power(dp, Pow);
    InCol.x := dp;
    InCol.y := dp;
    InCol.z := dp;
    InCol.w := dp;
    SampleTexture(Output, i, j, OutCol);
    WriteColorMask(OutCol, InCol, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure EffectBlur(
      Input, Output: TDJXTexture;
      Shift: integer;
      InputMask, OutputMask: TTextureMask;
      MoveH, MoveV: integer
    );
var
  i, j, t: integer;
  InCol: TD3DXVector4;
  TmpCol: TD3DXVector4;
  OutCol: TD3DXVector4;
begin
  for j := 0 to Output.Height - 1 do
  for i := 0 to Output.Width - 1 do
  begin
    InCol := D3DXVector4(0, 0, 0, 0);
    for t := -(Shift + 1) to (Shift + 1) do
    begin
      SampleTexture(Input, i + t * MoveH, j + t * MoveV, TmpCol);
      D3DXVec4Scale(TmpCol, TmpCol, ((Shift + 1) - Abs(t)) / (Shift + 1));
      D3DXVec4Add(InCol, InCol, TmpCol);
    end;
    D3DXVec4Scale(InCol, InCol, 1 / (Shift + 1));
    AssignColorMask(InCol, InputMask);
    SampleTexture(Output, i, j, OutCol);
    WriteColorMask(OutCol, InCol, OutputMask);
    WriteTexture(Output, i, j, OutCol);
  end;
end;

procedure SetEffectStr(Str: AnsiString);
begin
  if CurCell.X = 0 then Effects[CurCell.Y - 1].Input1 := Str;
  if CurCell.X = 1 then Effects[CurCell.Y - 1].Input2 := Str;
  if CurCell.X = 3 then Effects[CurCell.Y - 1].Output := Str;
  if CurCell.X = 4 then Effects[CurCell.Y - 1].Reference := Str;
  if CurCell.X = 2 then
  if Effects[CurCell.Y - 1].Operation <> Str then
  begin
    Effects[CurCell.Y - 1].Operation := Str;
    if Str = 'Copy' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := '0,0';
    end;
    if Str = 'Blur H' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := '1';
    end;
    if Str = 'Blur V' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := '1';
    end;
    if Str = 'Copy Ref' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := '$FFFFFFFF';
    end;
    if Str = 'Normals' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := 'N/A';
    end;
    if Str = 'Reflect' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := 'N/A';
    end;
    if Str = 'Overlay' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := '0,0';
    end;
    if Str = 'Light' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := 'N/A';
    end;
    if Str = 'Modulate' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := 'N/A';
    end;
    if Str = 'Modulate Ref' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := '$FFFFFFFF';
    end;
    if Str = 'Add' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := 'N/A';
    end;
    if Str = 'Add Ref' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := '$FFFFFFFF';
    end;
    if Str = 'Add Signed' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := 'N/A';
    end;
    if Str = 'Specular' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := '10';
    end;
    if Str = 'Saturate' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := '$FFFFFFFF';
    end;
    if Str = 'Scale' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := '100';
    end;
    if Str = 'Difference' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := 'N/A';
    end;
    if Str = 'Invert' then
    begin
      Effects[CurCell.Y - 1].Input1 := 'None';
      Effects[CurCell.Y - 1].Input2 := 'None';
      Effects[CurCell.Y - 1].Output := 'Output';
      Effects[CurCell.Y - 1].Reference := 'N/A';
    end;
  end;
  UpdateEffects;
end;

function GetTextureFromStr(Str: AnsiString): TDJXTexture;
var
  Tex, Img0, Img1: AnsiString;
begin
  Result := nil;
  Tex := GetParam(Str, ' ', 0);
  Img0 := GetParam(Tex, '|', 0);
  Img1 := GetParam(Tex, '|', 1);
  if (Length(Img1) >= 1)
  and (Img1[1] = '.') then
  Img1 := AppPath + Img1;
  if Tex = 'Input' then Result := tex_Input;
  if Tex = 'Temp1' then Result := tex_Temp1;
  if Tex = 'Temp2' then Result := tex_Temp2;
  if Tex = 'Temp3' then Result := tex_Temp3;
  if Tex = 'Temp4' then Result := tex_Temp4;
  if Tex = 'Output' then Result := tex_Output;
  if (Img0 = 'Img') and FileExists(Img1) then
  begin
    Result := Form1.DJXTextureList2.CreateTextureFromFile(
      Img1,
      'Image' + IntToStr(Form1.DJXTextureList2.Count)
    );
    Result.TexLock;
  end;
end;

function GetTextureMaskFromStr(Str: AnsiString): TTextureMask;
begin
  Result := tmCombined;
  if GetParam(Str, ' ', 1) = 'Alpha' then Result := tmAlpha;
  if GetParam(Str, ' ', 1) = 'Color' then Result := tmColor;
end;

procedure ApplyEffects;
var
  i: integer;
  Input1, Input2, Output: TDJXTexture;
  Input1Mask, Input2Mask, OutputMask: TTextureMask;
begin
  Form1.Timer1.Enabled := false;
  g_CharWidth := trunc(GetTextureWidth / 16);
  g_CharHeight := trunc(GetTextureHeight / 16);
  tex_Input.TexLock(0);
  tex_Temp1.TexLock(0);
  tex_Temp2.TexLock(0);
  tex_Temp3.TexLock(0);
  tex_Temp4.TexLock(0);
  tex_Output.TexLock(0);
  try
    for i := 0 to high(Effects) do
    begin
      Form1.fm_CurEffect.Caption := Effects[i].Operation;
      Form1.ProgressBar1.Position := trunc((i / Length(Effects)) * 100);
      Application.ProcessMessages;
      Input1 := GetTextureFromStr(Effects[i].Input1);
      Input2 := GetTextureFromStr(Effects[i].Input2);
      Output := GetTextureFromStr(Effects[i].Output);
      Input1Mask := GetTextureMaskFromStr(Effects[i].Input1);
      Input2Mask := GetTextureMaskFromStr(Effects[i].Input2);
      OutputMask := GetTextureMaskFromStr(Effects[i].Output);
      if Effects[i].Operation = 'Copy' then
      begin
        if (Input1 <> nil) and (Output <> nil) then
        EffectCopy(
          Input1,
          Output,
          StrToPoint(Effects[i].Reference),
          Input1Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Blur H' then
      begin
        if (Input1 <> nil) and (Output <> nil) then
        EffectBlur(
          Input1,
          Output,
          StrToInt(Effects[i].Reference),
          Input1Mask,
          OutputMask,
          1, 0
        );
      end;
      if Effects[i].Operation = 'Blur V' then
      begin
        if (Input1 <> nil) and (Output <> nil) then
        EffectBlur(
          Input1,
          Output,
          StrToInt(Effects[i].Reference),
          Input1Mask,
          OutputMask,
          0, 1
        );
      end;
      if Effects[i].Operation = 'Copy Ref' then
      begin
        if (Output <> nil) then
        EffectCopyRef(
          Output,
          StrToCol(Effects[i].Reference),
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Normals' then
      begin
        if (Input1 <> nil) and (Output <> nil) then
        EffectNormals(
          Input1,
          Output,
          Input1Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Reflect' then
      begin
        if (Input1 <> nil)
        and (Input2 <> nil)
        and (Output <> nil) then
        EffectReflect(
          Input1,
          Input2,
          Output,
          Input1Mask,
          Input2Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Overlay' then
      begin
        if (Input1 <> nil)
        and (Input2 <> nil)
        and (Output <> nil) then
        EffectOverlay(
          Input1,
          Input2,
          Output,
          StrToPoint(Effects[i].Reference),
          Input1Mask,
          Input2Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Light' then
      begin
        if (Input1 <> nil)
        and (Output <> nil) then
        EffectLight(
          Input1,
          Output,
          Input1Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Modulate' then
      begin
        if (Input1 <> nil)
        and (Input2 <> nil)
        and (Output <> nil) then
        EffectModulate(
          Input1,
          Input2,
          Output,
          Input1Mask,
          Input2Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Modulate Ref' then
      begin
        if (Input1 <> nil)
        and (Output <> nil) then
        EffectModulateRef(
          Input1,
          Output,
          StrToCol(Effects[i].Reference),
          Input1Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Add' then
      begin
        if (Input1 <> nil)
        and (Input2 <> nil)
        and (Output <> nil) then
        EffectAdd(
          Input1,
          Input2,
          Output,
          Input1Mask,
          Input2Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Add Ref' then
      begin
        if (Input1 <> nil)
        and (Output <> nil) then
        EffectAddRef(
          Input1,
          Output,
          StrToCol(Effects[i].Reference),
          Input1Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Add Signed' then
      begin
        if (Input1 <> nil)
        and (Input2 <> nil)
        and (Output <> nil) then
        EffectAddSigned(
          Input1,
          Input2,
          Output,
          Input1Mask,
          Input2Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Specular' then
      begin
        if (Input1 <> nil)
        and (Output <> nil) then
        EffectSpecular(
          Input1,
          Output,
          StrToInt(Effects[i].Reference),
          Input1Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Saturate' then
      begin
        if (Input1 <> nil)
        and (Output <> nil) then
        EffectSaturate(
          Input1,
          Output,
          StrToInt(Effects[i].Reference),
          Input1Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Scale' then
      begin
        if (Input1 <> nil)
        and (Output <> nil) then
        EffectScale(
          Input1,
          Output,
          StrToInt(Effects[i].Reference),
          Input1Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Difference' then
      begin
        if (Input1 <> nil)
        and (Input2 <> nil)
        and (Output <> nil) then
        EffectDifference(
          Input1,
          Input2,
          Output,
          Input1Mask,
          Input2Mask,
          OutputMask
        );
      end;
      if Effects[i].Operation = 'Invert' then
      begin
        if (Input1 <> nil)
        and (Output <> nil) then
        EffectInvert(
          Input1,
          Output,
          Input1Mask,
          OutputMask
        );
      end;
    end;
  finally
    tex_Input.TexUnLock(0);
    tex_Temp1.TexUnLock(0);
    tex_Temp2.TexUnLock(0);
    tex_Temp3.TexUnLock(0);
    tex_Temp4.TexUnLock(0);
    tex_Output.TexUnLock(0);
    for i := 0 to Form1.DJXTextureList2.Count - 1 do
    Form1.DJXTextureList2.Textures[i].TexUnLock;
    Form1.DJXTextureList2.FreeTextures;
    Form1.Timer1.Enabled := true;
    Form1.ProgressBar1.Position := 100;
  end;
end;

function GetMaxCharWidth: integer;
begin
  Result := Form1.fm_FontPreview.Canvas.TextWidth('W');
end;

function GetMaxCharHeight: integer;
begin
  Result := Form1.fm_FontPreview.Canvas.TextHeight('A');
end;

function GetTextureWidth: integer;
var
  i: integer;
begin
  i := (GetMaxCharWidth + Form1.fm_HSpacing.Value) * 16;
  Result := 1;
  while Result < i do Result := Result shl 1;
end;

function GetTextureHeight: integer;
var
  i: integer;
begin
  i := (GetMaxCharHeight + Form1.fm_VSpacing.Value) * 16;
  Result := 1;
  while Result < i do Result := Result shl 1;
end;

function PointToStr(Pt: TPoint): AnsiString;
begin
  Result := IntToStr(Pt.X) + ',' + IntToStr(Pt.Y);
end;

function StrToPoint(Str: AnsiString): TPoint;
begin
  Result := Point(
    StrToInt(GetParam(Str, ',', 0)),
    StrToInt(GetParam(Str, ',', 1))
  );
end;

function ColToStr(Col: TDJXColor): AnsiString;
begin
  Result := '$' +
  IntToHex(DJXColorA(Col), 2) +
  IntToHex(DJXColorR(Col), 2) +
  IntToHex(DJXColorG(Col), 2) +
  IntToHex(DJXColorB(Col), 2);
end;

function StrToCol(Str: AnsiString): TDJXColor;
begin
  Result := StrToInt(Str);
end;

procedure UpdateEffects;
var
  i: integer;
begin
  with Form1 do
  begin
    fm_Effects1.RowCount := Length(Effects) + 1;
    for i := 0 to high(Effects) do
    begin
      fm_Effects1.Cells[0, 1 + i] := Effects[i].Input1;
      fm_Effects1.Cells[1, 1 + i] := Effects[i].Input2;
      fm_Effects1.Cells[2, 1 + i] := Effects[i].Operation;
      fm_Effects1.Cells[3, 1 + i] := Effects[i].Output;
      fm_Effects1.Cells[4, 1 + i] := Effects[i].Reference;
    end;
  end;
end;

procedure TForm1.Add1Click(Sender: TObject);
begin
  SetEffectStr('Add');
end;

procedure TForm1.AddEffect1Click(Sender: TObject);
begin
  SetLength(Effects, Length(Effects) + 1);
  Effects[High(Effects)].Input1 := 'None';
  Effects[High(Effects)].Input2 := 'None';
  Effects[High(Effects)].Operation := 'Copy';
  Effects[High(Effects)].Output := 'Output';
  Effects[High(Effects)].Reference := '0,0';
  UpdateEffects;
end;

procedure TForm1.AddRef1Click(Sender: TObject);
begin
  SetEffectStr('Add Ref');
end;

procedure TForm1.AddSigned1Click(Sender: TObject);
begin
  SetEffectStr('Add Signed');
end;

procedure TForm1.Alpha10Click(Sender: TObject);
begin
  SetEffectStr('Temp4 Alpha');
end;

procedure TForm1.Alpha11Click(Sender: TObject);
begin
  SetEffectStr('Temp4 Alpha');
end;

procedure TForm1.Alpha1Click(Sender: TObject);
begin
  SetEffectStr('Input Alpha');
end;

procedure TForm1.Alpha2Click(Sender: TObject);
begin
  SetEffectStr('Temp1 Alpha');
end;

procedure TForm1.Alpha3Click(Sender: TObject);
begin
  SetEffectStr('Temp2 Alpha');
end;

procedure TForm1.Alpha4Click(Sender: TObject);
begin
  SetEffectStr('Temp3 Alpha');
end;

procedure TForm1.Alpha5Click(Sender: TObject);
var
  Str: AnsiString;
begin
  if not opd1.Execute then Exit;
  Str := StringReplace(opd1.FileName, ExtractFilePath(ParamStr(0)), '.\', [rfReplaceAll]);
  SetEffectStr('Img|' + Str + ' Alpha');
end;

procedure TForm1.Alpha6Click(Sender: TObject);
begin
  SetEffectStr('Output Alpha');
end;

procedure TForm1.Alpha7Click(Sender: TObject);
begin
  SetEffectStr('Temp1 Alpha');
end;

procedure TForm1.Alpha8Click(Sender: TObject);
begin
  SetEffectStr('Temp2 Alpha');
end;

procedure TForm1.Alpha9Click(Sender: TObject);
begin
  SetEffectStr('Temp3 Alpha');
end;

procedure TForm1.BlurH1Click(Sender: TObject);
begin
  SetEffectStr('Blur H');
end;

procedure TForm1.BlurV1Click(Sender: TObject);
begin
  SetEffectStr('Blur V');
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
begin
  if not fd1.Execute then exit;
  for i := 0 to fm_FontList1.Items.Count - 1 do
  if LowerCase(fm_FontList1.Items.Strings[i]) = LowerCase(fd1.Font.Name) then
  begin
    fm_FontList1.ItemIndex := i;
    fm_FontBold1.Down := fsBold in fd1.Font.Style;
    fm_FontItalic1.Down := fsItalic in fd1.Font.Style;
    fm_FontSize1.Value := Max(Min(fd1.Font.Size, 64), 8);
    break;
  end;
  ChangeFont;
end;

procedure TForm1.fm_FontList1Change(Sender: TObject);
begin
  ChangeFont;
end;

procedure TForm1.fm_FontSize1Change(Sender: TObject);
begin
  if StrToIntDef(fm_FontSize1.Text, 0) = StrToIntDef(fm_FontSize1.Text, 1) then
  ChangeFont;
end;

procedure TForm1.fm_Preview1Click(Sender: TObject);
begin
  fm_Preview1.SetFocus;
end;

procedure TForm1.fm_Preview1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  md := true;
  mc := Point(X, Y);
end;

procedure TForm1.fm_Preview1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if md then
  begin
    TexShift := Point(TexShift.X + (X - mc.X), TexShift.Y + (Y - mc.Y));
    mc := Point(X, Y);
  end;
end;

procedure TForm1.fm_Preview1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  md := false;
end;

procedure TForm1.fm_PreviewSampleClick(Sender: TObject);
begin
  g_Scale := 1;
  TexShift := Point(0, 0);
  fm_PreviewScale.Caption := IntToStr(Round(g_Scale * 100)) + '%';
end;

procedure TForm1.fm_PreviewTextureClick(Sender: TObject);
begin
  g_Scale := 1;
  TexShift := Point(0, 0);
  fm_PreviewScale.Caption := IntToStr(Round(g_Scale * 100)) + '%';
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Finalize;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TexGenTopFromBottom := Form1.Height - GroupBox5.Top;
  ExpImpTopFromBottom := Form1.Height - GroupBox6.Top;
  EffBottomFromBottom := Form1.Height - (GroupBox4.Top + GroupBox4.Height);
  Bevel2Top := GroupBox4.Height - Bevel2.Top;
  EffListBottomFromBottom := GroupBox4.Height - (fm_Effects1.Top + fm_Effects1.Height);
  PrevBottomFromBottom := Form1.Height - (GroupBox3.Top + GroupBox3.Height);
  PrevRightFromRight := Form1.Width - (GroupBox3.Left + GroupBox3.Width);
  PrevPnlBottomFromBottom := GroupBox3.Height - (fm_Preview1.Top + fm_Preview1.Height);
  PrevPnlRightFromRight := GroupBox3.Width - (fm_Preview1.Left + fm_Preview1.Width);
  PrevScRightFromRight := GroupBox3.Width - (fm_PreviewScale.Left + fm_PreviewScale.Width);
  Form1.Constraints.MinHeight := Form1.Height;
  Form1.Constraints.MinWidth := Form1.Width;
  Initialize;
  DecimalSeparator := '.';
end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  TexPos: TPoint;
  McPos: TPoint;
  Dif: TD3DXVector3;
begin
  if fm_PreviewTexture.Checked then
  begin
    TexPos := Point(
      (GroupBox3.Left + fm_Preview1.Left) + TexShift.X,
      (GroupBox3.Top + fm_Preview1.Top) + TexShift.Y
    );
    McPos := Point(Mouse.CursorPos.X - Form1.Left, Mouse.CursorPos.Y - Form1.Top);
    Dif := D3DXVector3(TexPos.X - McPos.X, TexPos.Y - McPos.Y, 0);
    D3DXVec3Scale(Dif, Dif, 1 / 1.02);
    TexPos := Point(Round(McPos.X + Dif.x), Round(McPos.Y + Dif.y));
    TexShift := Point(
      TexPos.X - (GroupBox3.Left + fm_Preview1.Left),
      TexPos.Y - (GroupBox3.Top + fm_Preview1.Top)
    );
    g_Scale := g_Scale / 1.02;
  end;
  fm_PreviewScale.Caption := IntToStr(Round(g_Scale * 100)) + '%';
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  TexPos: TPoint;
  McPos: TPoint;
  Dif: TD3DXVector3;
begin
  if fm_PreviewTexture.Checked then
  begin
    TexPos := Point(
      (GroupBox3.Left + fm_Preview1.Left) + TexShift.X,
      (GroupBox3.Top + fm_Preview1.Top) + TexShift.Y
    );
    McPos := Point(Mouse.CursorPos.X - Form1.Left, Mouse.CursorPos.Y - Form1.Top);
    Dif := D3DXVector3(TexPos.X - McPos.X, TexPos.Y - McPos.Y, 0);
    D3DXVec3Scale(Dif, Dif, 1.02);
    TexPos := Point(Round(McPos.X + Dif.x), Round(McPos.Y + Dif.y));
    TexShift := Point(
      TexPos.X - (GroupBox3.Left + fm_Preview1.Left),
      TexPos.Y - (GroupBox3.Top + fm_Preview1.Top)
    );
    g_Scale := g_Scale * 1.02;
  end;
  fm_PreviewScale.Caption := IntToStr(Round(g_Scale * 100)) + '%';
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  GroupBox5.Top := Form1.Height - TexGenTopFromBottom;
  GroupBox6.Top := Form1.Height - ExpImpTopFromBottom;
  GroupBox4.Height := Form1.Height - GroupBox4.Top - EffBottomFromBottom;
  Bevel2.Top := GroupBox4.Height - Bevel2Top;
  fm_Effects1.Height := GroupBox4.Height - fm_Effects1.Top - EffListBottomFromBottom;
  GroupBox3.Height := Form1.Height - GroupBox3.Top - PrevBottomFromBottom;
  GroupBox3.Width := Form1.Width - GroupBox3.Left - PrevRightFromRight;
  fm_Preview1.Height := GroupBox3.Height - fm_Preview1.Top - PrevPnlBottomFromBottom;
  fm_Preview1.Width := GroupBox3.Width - fm_Preview1.Left - PrevPnlRightFromRight;
  fm_PreviewScale.Width := GroupBox3.Width - fm_PreviewScale.Left - PrevScRightFromRight;
  if (DanJetX1.Width <> fm_Preview1.Width)
  or (DanJetX1.Height <> fm_Preview1.Height) then
  begin
    DanJetX1.ResizeDepthStencil(fm_Preview1.Width, fm_Preview1.Height);
    DanJetX1.ResizeBackBuffer(fm_Preview1.Width, fm_Preview1.Height);
  end;
end;

procedure TForm1.Invert1Click(Sender: TObject);
begin
  SetEffectStr('Invert');
end;

procedure TForm1.Light1Click(Sender: TObject);
begin
  SetEffectStr('Light');
end;

procedure TForm1.Modulate1Click(Sender: TObject);
begin
  SetEffectStr('Modulate');
end;

procedure TForm1.ModulateRef1Click(Sender: TObject);
begin
  SetEffectStr('Modulate Ref');
end;

procedure TForm1.MoveDown1Click(Sender: TObject);
var
  TmpEffect: TEffect;
begin
  if fm_Effects1.Row >= fm_Effects1.RowCount - 1 then exit;
  TmpEffect.Input1 := Effects[fm_Effects1.Row - 1].Input1;
  TmpEffect.Input2 := Effects[fm_Effects1.Row - 1].Input2;
  TmpEffect.Operation := Effects[fm_Effects1.Row - 1].Operation;
  TmpEffect.Output := Effects[fm_Effects1.Row - 1].Output;
  TmpEffect.Reference := Effects[fm_Effects1.Row - 1].Reference;
  Effects[fm_Effects1.Row - 1].Input1 := Effects[fm_Effects1.Row].Input1;
  Effects[fm_Effects1.Row - 1].Input2 := Effects[fm_Effects1.Row].Input2;
  Effects[fm_Effects1.Row - 1].Operation := Effects[fm_Effects1.Row].Operation;
  Effects[fm_Effects1.Row - 1].Output := Effects[fm_Effects1.Row].Output;
  Effects[fm_Effects1.Row - 1].Reference := Effects[fm_Effects1.Row].Reference;
  Effects[fm_Effects1.Row].Input1 := TmpEffect.Input1;
  Effects[fm_Effects1.Row].Input2 := TmpEffect.Input2;
  Effects[fm_Effects1.Row].Operation := TmpEffect.Operation;
  Effects[fm_Effects1.Row].Output := TmpEffect.Output;
  Effects[fm_Effects1.Row].Reference := TmpEffect.Reference;
  UpdateEffects;
end;

procedure TForm1.MoveUp1Click(Sender: TObject);
var
  TmpEffect: TEffect;
begin
  if fm_Effects1.Row <= 1 then exit;
  TmpEffect.Input1 := Effects[fm_Effects1.Row - 2].Input1;
  TmpEffect.Input2 := Effects[fm_Effects1.Row - 2].Input2;
  TmpEffect.Operation := Effects[fm_Effects1.Row - 2].Operation;
  TmpEffect.Output := Effects[fm_Effects1.Row - 2].Output;
  TmpEffect.Reference := Effects[fm_Effects1.Row - 2].Reference;
  Effects[fm_Effects1.Row - 2].Input1 := Effects[fm_Effects1.Row - 1].Input1;
  Effects[fm_Effects1.Row - 2].Input2 := Effects[fm_Effects1.Row - 1].Input2;
  Effects[fm_Effects1.Row - 2].Operation := Effects[fm_Effects1.Row - 1].Operation;
  Effects[fm_Effects1.Row - 2].Output := Effects[fm_Effects1.Row - 1].Output;
  Effects[fm_Effects1.Row - 2].Reference := Effects[fm_Effects1.Row - 1].Reference;
  Effects[fm_Effects1.Row - 1].Input1 := TmpEffect.Input1;
  Effects[fm_Effects1.Row - 1].Input2 := TmpEffect.Input2;
  Effects[fm_Effects1.Row - 1].Operation := TmpEffect.Operation;
  Effects[fm_Effects1.Row - 1].Output := TmpEffect.Output;
  Effects[fm_Effects1.Row - 1].Reference := TmpEffect.Reference;
  UpdateEffects;
end;

procedure TForm1.None1Click(Sender: TObject);
begin
  SetEffectStr('None');
end;

procedure TForm1.Normals1Click(Sender: TObject);
begin
  SetEffectStr('Normals');
end;

procedure TForm1.Overlay1Click(Sender: TObject);
begin
  SetEffectStr('Overlay');
end;

procedure TForm1.Reflect1Click(Sender: TObject);
begin
  SetEffectStr('Reflect');
end;

procedure TForm1.RemoveEffect1Click(Sender: TObject);
var
  i: integer;
  r: integer;
begin
  r := fm_Effects1.Row - 1;
  if (r < 0)
  or (r > High(Effects))
  or (Length(Effects) = 1) then Exit;
  if r < High(Effects) then
  begin
    for i := r to High(Effects) - 1 do
    begin
      Effects[i].Input1 := Effects[i + 1].Input1;
      Effects[i].Input2 := Effects[i + 1].Input2;
      Effects[i].Operation := Effects[i + 1].Operation;
      Effects[i].Output := Effects[i + 1].Output;
      Effects[i].Reference := Effects[i + 1].Reference;
    end;
  end;
  SetLength(Effects, Length(Effects) - 1);
  UpdateEffects;
end;

procedure TForm1.Saturate1Click(Sender: TObject);
begin
  SetEffectStr('Saturate');
end;

procedure TForm1.Scale1Click(Sender: TObject);
begin
  SetEffectStr('Scale');
end;

procedure TForm1.Specular1Click(Sender: TObject);
begin
  SetEffectStr('Specular');
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Render;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Button2.Enabled := False;
  fm_Effects1.Enabled := False;
  fm_FontList1.Enabled := False;
  Button1.Enabled := False;
  fm_FontSize1.Enabled := False;
  fm_FontBold1.Enabled := False;
  fm_FontItalic1.Enabled := False;
  fm_VSpacing.Enabled := False;
  fm_HSpacing.Enabled := False;
  Button3.Enabled := False;
  Button4.Enabled := False;
  Button5.Enabled := False;
  Button6.Enabled := False;
  Form1.BorderIcons := Form1.BorderIcons - [biMaximize];
  GenerateFont;
  Form1.BorderIcons := Form1.BorderIcons + [biMaximize];
  Button3.Enabled := True;
  Button4.Enabled := True;
  Button5.Enabled := True;
  Button6.Enabled := True;
  fm_HSpacing.Enabled := True;
  fm_VSpacing.Enabled := True;
  fm_FontItalic1.Enabled := True;
  fm_FontBold1.Enabled := True;
  fm_FontSize1.Enabled := True;
  Button1.Enabled := True;
  fm_FontList1.Enabled := True;
  fm_Effects1.Enabled := True;
  Button2.Enabled := True;
  ProgressBar1.Position := 0;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if not sd1.Execute then exit;
  ExportEffects(sd1.FileName);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if not od1.Execute then exit;
  ImportEffects(od1.FileName);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if not spd1.Execute or (tex_Output = nil) then Exit;
  ExportPNG(spd1.FileName);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  if not sd2.Execute or (tex_Output = nil) then Exit;
  ExportG2F(sd2.FileName);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  if not sd3.Execute or (tex_Output = nil) then Exit;
  ExportG2FH(sd3.FileName);
end;

procedure TForm1.Clear1Click(Sender: TObject);
begin
  SetLength(Effects, 1);
  Effects[0].Input1 := 'Input';
  Effects[0].Input2 := 'None';
  Effects[0].Operation := 'Copy';
  Effects[0].Output := 'Output';
  Effects[0].Reference := '0,0';
  UpdateEffects;
end;

procedure TForm1.Color10Click(Sender: TObject);
begin
  SetEffectStr('Temp4 Color');
end;

procedure TForm1.Color11Click(Sender: TObject);
begin
  SetEffectStr('Temp4 Color');
end;

procedure TForm1.Color1Click(Sender: TObject);
begin
  SetEffectStr('Input Color');
end;

procedure TForm1.Color2Click(Sender: TObject);
begin
  SetEffectStr('Temp1 Color');
end;

procedure TForm1.Color3Click(Sender: TObject);
begin
  SetEffectStr('Temp2 Color');
end;

procedure TForm1.Color4Click(Sender: TObject);
begin
  SetEffectStr('Temp3 Color');
end;

procedure TForm1.Color5Click(Sender: TObject);
var
  Str: AnsiString;
begin
  if not opd1.Execute then Exit;
  Str := StringReplace(opd1.FileName, ExtractFilePath(ParamStr(0)), '.\', [rfReplaceAll]);
  SetEffectStr('Img|' + Str + ' Color');
end;

procedure TForm1.Color6Click(Sender: TObject);
begin
  SetEffectStr('Output Color');
end;

procedure TForm1.Color7Click(Sender: TObject);
begin
  SetEffectStr('Temp1 Color');
end;

procedure TForm1.Color8Click(Sender: TObject);
begin
  SetEffectStr('Temp2 Color');
end;

procedure TForm1.Color9Click(Sender: TObject);
begin
  SetEffectStr('Temp3 Color');
end;

procedure TForm1.Combined10Click(Sender: TObject);
begin
  SetEffectStr('Temp4');
end;

procedure TForm1.Combined11Click(Sender: TObject);
begin
  SetEffectStr('Temp4');
end;

procedure TForm1.Combined1Click(Sender: TObject);
begin
  SetEffectStr('Input');
end;

procedure TForm1.Combined2Click(Sender: TObject);
begin
  SetEffectStr('Temp1');
end;

procedure TForm1.Combined3Click(Sender: TObject);
begin
  SetEffectStr('Temp2');
end;

procedure TForm1.Combined4Click(Sender: TObject);
begin
  SetEffectStr('Temp3');
end;

procedure TForm1.Combined5Click(Sender: TObject);
var
  Str: AnsiString;
begin
  if not opd1.Execute then Exit;
  Str := StringReplace(opd1.FileName, ExtractFilePath(ParamStr(0)), '.\', [rfReplaceAll]);
  SetEffectStr('Img|' + Str);
end;

procedure TForm1.Combined6Click(Sender: TObject);
begin
  SetEffectStr('Output');
end;

procedure TForm1.Combined7Click(Sender: TObject);
begin
  SetEffectStr('Temp1');
end;

procedure TForm1.Combined8Click(Sender: TObject);
begin
  SetEffectStr('Temp2');
end;

procedure TForm1.Combined9Click(Sender: TObject);
begin
  SetEffectStr('Temp3');
end;

procedure TForm1.Copy1Click(Sender: TObject);
begin
  SetEffectStr('Copy');
end;

procedure TForm1.CopyRefClick(Sender: TObject);
begin
  SetEffectStr('Copy Ref');
end;

procedure TForm1.Difference1Click(Sender: TObject);
begin
  SetEffectStr('Difference');
end;

procedure TForm1.emp3Alpha1Click(Sender: TObject);
begin
  SetEffectStr('Temp3 Alpha');
end;

procedure TForm1.fm_Effects1MouseLeave(Sender: TObject);
begin
  fm_EffectsStatus.Caption := '';
end;

procedure TForm1.fm_Effects1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  MouseCell: TPoint;
begin
  fm_Effects1.MouseToCell(
    X, Y,
    MouseCell.X, MouseCell.Y
  );
  if (MouseCell.X > -1) and (MouseCell.Y > 0) then
  fm_EffectsStatus.Caption := fm_Effects1.Cells[MouseCell.X, MouseCell.Y]
  else
  fm_EffectsStatus.Caption := '';
end;

procedure TForm1.fm_Effects1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  MouseCell: TPoint;
  Operation: AnsiString;
  Reference: AnsiString;
begin
  fm_Effects1.MouseToCell(
    X, Y,
    MouseCell.X, MouseCell.Y
  );
  if (Button = mbLeft) and (fm_Effects1.Row > 0)
  and (MouseCell.X = fm_Effects1.Col)
  and (MouseCell.Y = fm_Effects1.Row) then
  begin
    Move(MouseCell, CurCell, SizeOf(TPoint));
    Operation := fm_Effects1.Cells[2, CurCell.Y];
    Reference := fm_Effects1.Cells[4, CurCell.Y];
    //Input1
    if (fm_Effects1.Col = 0)
    and (
      (Operation = 'Add')
      or (Operation = 'Add Ref')
      or (Operation = 'Add Signed')
      or (Operation = 'Blur H')
      or (Operation = 'Blur V')
      or (Operation = 'Copy')
      or (Operation = 'Difference')
      or (Operation = 'Invert')
      or (Operation = 'Light')
      or (Operation = 'Modulate')
      or (Operation = 'Modulate Ref')
      or (Operation = 'Normals')
      or (Operation = 'Overlay')
      or (Operation = 'Reflect')
      or (Operation = 'Saturate')
      or (Operation = 'Scale')
      or (Operation = 'Specular')
    ) then
    begin
      fm_Input1.Popup(
        Mouse.CursorPos.X,
        Mouse.CursorPos.Y
      );
    end;
    //Input2
    if (fm_Effects1.Col = 1)
    and (
      (Operation = 'Add')
      or (Operation = 'Add Signed')
      or (Operation = 'Difference')
      or (Operation = 'Modulate')
      or (Operation = 'Overlay')
      or (Operation = 'Reflect')
    ) then
    begin
      fm_Input1.Popup(
        Mouse.CursorPos.X,
        Mouse.CursorPos.Y
      );
    end;
    //Operation
    if (fm_Effects1.Col = 2) then
    begin
      fm_Operation1.Popup(
        Mouse.CursorPos.X,
        Mouse.CursorPos.Y
      );
    end;
    //Output
    if (fm_Effects1.Col = 3) then
    begin
      fm_Output1.Popup(
        Mouse.CursorPos.X,
        Mouse.CursorPos.Y
      );
    end;
    //Reference
    if (fm_Effects1.Col = 4) then
    begin
      if (Operation = 'Copy')
      or (Operation = 'Overlay') then
      begin //Point Edit
        Form2.SpinEdit1.Value := StrToInt(GetParam(Reference, ',', 0));
        Form2.SpinEdit2.Value := StrToInt(GetParam(Reference, ',', 1));
        Form2.ShowModal;
        SetEffectStr(
          PointToStr(
            Point(Form2.SpinEdit1.Value, Form2.SpinEdit2.Value)
          )
        );
      end;
      if (Operation = 'Blur H')
      or (Operation = 'Blur V')
      or (Operation = 'Specular')
      or (Operation = 'Scale') then
      begin //Value Edit
        Form3.SpinEdit1.Value := StrToInt(Reference);
        Form3.ShowModal;
        SetEffectStr(IntToStr(Form3.SpinEdit1.Value));
      end;
      if (Operation = 'Copy Ref')
      or (Operation = 'Modulate Ref')
      or (Operation = 'Add Ref')
      or (Operation = 'Saturate') then
      begin //Color Edit
        Form4.ColorDialog1.Color := rgb(
          StrToInt('$' + Reference[4] + Reference[5]),
          StrToInt('$' + Reference[6] + Reference[7]),
          StrToInt('$' + Reference[8] + Reference[9])
        );
        Form4.SpinEdit4.Value := DJXColorA(StrToCol(Reference));
        Form4.ShowModal;
        SetEffectStr(
          ColToStr(
            DJXColor(
              Form4.SpinEdit1.Value,
              Form4.SpinEdit2.Value,
              Form4.SpinEdit3.Value,
              Form4.SpinEdit4.Value
            )
          )
        );
      end;
    end;
  end;
  if (Button = mbRight) then
  begin
    fm_EffectsOptions1.Popup(
      Mouse.CursorPos.X,
      Mouse.CursorPos.Y
    );
  end;
end;

procedure TForm1.fm_FontBold1Click(Sender: TObject);
begin
  ChangeFont;
end;

procedure TForm1.fm_FontItalic1Click(Sender: TObject);
begin
  ChangeFont;
end;

end.
