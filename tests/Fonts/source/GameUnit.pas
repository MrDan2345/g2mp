unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  SysUtils,
  CommonUtils,
  MediaUtils,
  Types,
  Classes;

type TGame = class
protected
public
  var Font: TUTrueTypeFontShared;
  constructor Create;
  destructor Destroy; override;
  procedure Initialize;
  procedure Finalize;
  procedure Update;
  procedure Render;
  procedure KeyDown(const Key: Integer);
  procedure KeyUp(const Key: Integer);
  procedure MouseDown(const Button, x, y: Integer);
  procedure MouseUp(const Button, x, y: Integer);
  procedure Scroll(const y: Integer);
  procedure Print(const c: AnsiChar);
  procedure Test1;
end;

var
  Game: TGame;

implementation

//TGame BEGIN
constructor TGame.Create;
begin
  g2.CallbackInitializeAdd(@Initialize);
  g2.CallbackFinalizeAdd(@Finalize);
  g2.CallbackUpdateAdd(@Update);
  g2.CallbackRenderAdd(@Render);
  g2.CallbackKeyDownAdd(@KeyDown);
  g2.CallbackKeyUpAdd(@KeyUp);
  g2.CallbackMouseDownAdd(@MouseDown);
  g2.CallbackMouseUpAdd(@MouseUp);
  g2.CallbackScrollAdd(@Scroll);
  g2.CallbackPrintAdd(@Print);
  g2.Params.MaxFPS := 100;
  g2.Params.Width := 1024;
  g2.Params.Height := 768;
  g2.Params.ScreenMode := smWindow;
end;

destructor TGame.Destroy;
begin
  g2.CallbackInitializeRemove(@Initialize);
  g2.CallbackFinalizeRemove(@Finalize);
  g2.CallbackUpdateRemove(@Update);
  g2.CallbackRenderRemove(@Render);
  g2.CallbackKeyDownRemove(@KeyDown);
  g2.CallbackKeyUpRemove(@KeyUp);
  g2.CallbackMouseDownRemove(@MouseDown);
  g2.CallbackMouseUpRemove(@MouseUp);
  g2.CallbackScrollRemove(@Scroll);
  g2.CallbackPrintRemove(@Print);
  inherited Destroy;
end;

procedure TGame.Initialize;
  var Path: String;
begin
  Path := ExpandFileName(ExtractFileDir(ParamStr(0)) + '/../assets/fonts/FreeSerifBold.ttf');
  Font := TUTrueTypeFont.Create(Path);
end;

procedure TGame.Finalize;
begin
  Free;
end;

procedure TGame.Update;
begin
  g2.Window.Caption := IntToStr(g2.Params.Width) + 'x' + IntToStr(g2.Params.Height);
end;

procedure TGame.Render;
  var i, j, b, Ind, n: Int32;
  var CharId: UInt32;
  var c: TG2Color;
  var r: TG2Float;
  var Glyph: TUTrueTypeFont.TGlyph;
  var p, np, p0, p1, p2: TUVec2;
  var Scale, Offset: TUVec2;
  var Bounds: TUBounds2f;
begin
  g2.Clear($ff8080ff);
  //i := (G2Time div 5000) mod Length(Font.Ptr.Glyphs);
  CharId := UStrUTF8ToUTF32('я', n);
  i := Font.Ptr.FindGlyph(CharId);
  Glyph := Font.Ptr.Glyphs[i];
  Scale := [0.5, 0.5];
  Bounds := [Glyph.Bounds.Min * Scale, Glyph.Bounds.Max * Scale];
  Offset := [100 - Bounds.Min.x, Glyph.Bounds.Size.y * Scale.y + 100 + Bounds.Min.y];
  Scale.y := -Scale.y;
  g2.PrimRect(100, 100, Glyph.Bounds.Size.x * Scale.x, Glyph.Bounds.Size.y * Abs(Scale.y), $ff404040);
  for i := 0 to High(Glyph.Contours) do
  for j := 0 to High(Glyph.Contours[i]) do
  begin
    if not Glyph.Contours[i][j].OnCurve then Continue;
    p0 := Glyph.Contours[i][j].Pos * Scale + Offset;
    Ind := (j + 1) mod Length(Glyph.Contours[i]);
    p1 := Glyph.Contours[i][Ind].Pos * Scale + Offset;
    if Glyph.Contours[i][Ind].OnCurve then
    begin
      g2.PrimLine(p0.x, p0.y, p1.x, p1.y, $ffff0000);
      Continue;
    end;
    Ind := (j + 2) mod Length(Glyph.Contours[i]);
    p2 := Glyph.Contours[i][Ind].Pos * Scale + Offset;
    p := p0;
    for b := 1 to 19 do
    begin
      np := UBezier(p0, p1, p2, b / 19);
      g2.PrimLine(p, np, $ffff0000);
      p := np;
    end;
  end;
  //g2.PrimRect(100, 100, 200, 200, $ff00ff00);
  {g2.PrimRect(
    100, 100,
    (Glyf.Header.XMax - Glyf.Header.XMin) * 0.5,
    (Glyf.Header.YMax - Glyf.Header.YMin) * 0.5,
    $ff404040
  );
  Ind := 0;
  for i := 0 to High(Glyf.ContourEndPoints) do
  begin
    n := Glyf.ContourEndPoints[i] - Ind + 1;
    for j := 0 to n - 1 do
    begin
      g2.PrimLine(
        (Glyf.Points[Ind + j].X - Glyf.Header.XMin) * 0.5 + 100,
        (Glyf.Header.YMax - Glyf.Points[Ind + j].Y) * 0.5 + 100,
        (Glyf.Points[Ind + ((j + 1) mod n)].X - Glyf.Header.XMin) * 0.5 + 100,
        (Glyf.Header.YMax - Glyf.Points[Ind + ((j + 1) mod n)].Y) * 0.5 + 100,
        $ff0000ff
      );
      if Glyf.Points[Ind + j].OnCurve then c := $ffff0000 else c := $ff00ff00;
      if j = 0 then r := 8 else r := 4;
      g2.PrimCircleCol(
        (Glyf.Points[Ind + j].X - Glyf.Header.XMin) * 0.5 + 100,
        (Glyf.Header.YMax - Glyf.Points[Ind + j].Y) * 0.5 + 100,
        r, c, c
      );
    end;
    Ind := Glyf.ContourEndPoints[i] + 1;
  end;
  }
end;

procedure TGame.KeyDown(const Key: Integer);
begin

end;

procedure TGame.KeyUp(const Key: Integer);
begin

end;

procedure TGame.MouseDown(const Button, x, y: Integer);
begin

end;

procedure TGame.MouseUp(const Button, x, y: Integer);
begin

end;

procedure TGame.Scroll(const y: Integer);
begin

end;

procedure TGame.Print(const c: AnsiChar);
begin

end;

procedure TGame.Test1;
var
  Path: String;
  TTFFile: File;
  Version: Cardinal;
begin
  Path := ExpandFileName(ExtractFileDir(ParamStr(0)) + '/../assets/fonts/FreeSerifBold.ttf');
  AssignFile(TTFFile, Path);
  Reset(TTFFile, 1); // Open in binary mode
  BlockRead(TTFFile, Version, SizeOf(Version)); // Read the first 4 bytes

  // If you need to interpret it correctly depending on endianness
  // It depends on your platform's endianness.
  Version := (Version shr 24) or ((Version and $00FF0000) shr 8) or ((Version and $0000FF00) shl 8) or (Version shl 24);

  if Version = $00010000 then
    WriteLn('Version 1.0 detected')
  else
    WriteLn('Version: ', IntToHex(Version, 8));

  CloseFile(TTFFile);
end;

//TGame END

end.
