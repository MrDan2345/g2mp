unit GameUnit;

interface

uses
  Gen2MP,
  G2Math,
  G2Utils,
  G2Types;

type
  TSprite = class
  public
    Pos: TG2Vec2;
    Vel: TG2Vec2;
    Size: TG2Float;
    Angle: TG2Float;
    AngVel: TG2Float;
    constructor Create;
    procedure Update;
    procedure Render;
  end;

  TGame = class
  protected
  public
    Sprites: array[0..10000 - 1] of TSprite;
    TexSprite: TG2Texture2D;
    Font0: TG2Font;
    Initialized: Boolean;
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
  end;

var
  Game: TGame;

implementation

procedure ShowMessage(const Text: String);
begin
  asm
    alert(@Text);
  end;
end;

constructor TSprite.Create;
begin
  Size := 20 + Random * 40;
  Pos.x := Random * (g2.Params.Width - Size * 2) + Size;
  Pos.y := Random * (g2.Params.Height - Size * 2) + Size;
  Vel := G2RandomCirclePoint * (Random * 5 + 2);
  Angle := G2Random2Pi;
  AngVel := (Random * 2 - 1) * 0.2;
end;

procedure TSprite.Update;
begin
  Pos := Pos + Vel;
  Angle := Angle + AngVel;
  if Pos.x - Size < 0 then
  begin
    Pos.x := Size;
    Vel.x := -Vel.x;
  end
  else if Pos.x + Size > g2.Params.Width then
  begin
    Pos.x := g2.Params.Width - Size;
    Vel.x := -Vel.x;
  end;
  if Pos.y - Size < 0 then
  begin
    Pos.y := Size;
    Vel.y := -Vel.y;
  end
  else if Pos.y + Size > g2.Params.Height then
  begin
    Pos.y := g2.Params.Height - Size;
    Vel.y := -Vel.y;
  end;
end;

procedure TSprite.Render;
begin
  g2.PicRect(
    Pos.x - Size, Pos.y - Size,
    Size * 2, Size * 2, G2Vec4(1, 1, 1, 1),
    Game.TexSprite
  );
//  g2.PicRect(
//    Pos.x, Pos.y,
//    Size * 2, Size * 2, G2Vec4(1, 1, 1, 1),
//    0.5, 0.5, 1, 1, Angle,
//    False, False,
//    Game.TexSprite,
//    Game.TexSprite.Width, Game.TexSprite.Height, 0
//  );
end;

//TGame BEGIN
constructor TGame.Create;
begin
  inherited Create;
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
  g2.TargetUPS := 45;
  Initialized := False;
//  g2.Params.MaxFPS := 100;
//  g2.Params.Width := 1024;
//  g2.Params.Height := 768;
//  g2.Params.ScreenMode := smMaximized;
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
  var i: Integer;
begin
  //g2.ClearColor.SetValue(1, 1, 1, 1);
  TexSprite := TG2Texture2D.Create;
  TexSprite.Load('sprite.png');
  Font0 := TG2Font.Create;
  Font0.Load('Font0.g2fh', 'Font0.png');
  Initialized := True;
  for i := 0 to High(Sprites) do
  Sprites[i] := TSprite.Create; ;
end;

procedure TGame.Finalize;
begin

end;

procedure TGame.Update;
  var i: Integer;
begin
  if Initialized
  and (TexSprite.State = asLoaded) then
  //and (Font0.State = asLoaded) then
  begin
    for i := 0 to High(Sprites) do
    Sprites[i].Update;
  end;
end;

procedure TGame.Render;
  var i: Integer;
  procedure PrintText(const x, y: Integer; const Color: TG2Vec4; const Str: String);
    var InvColor: TG2Vec4;
  begin
    InvColor := G2Vec4(1, 1, 1, 1) - Color;
    InvColor.w := 1;
    Font0.Print(x - 1, y - 1, 1, 1, InvColor, Str, bmNormal, tfPoint);
    Font0.Print(x + 1, y + 1, 1, 1, InvColor, Str, bmNormal, tfPoint);
    Font0.Print(x, y, 1, 1, Color, Str, bmNormal, tfPoint);
  end;
begin
  if Initialized then
  begin
    //g2.ClearColor.SetValue(1, 1, 1, 1);
    //g2.PrimRect(10, 10, 300, 300, G2Vec4(0, 0, 0, 1));
    if TexSprite.State = asLoaded then
    begin
      //g2.PicRect(10, 10, G2Vec4(1, 1, 1, 1), TexSprite);
      for i := 0 to High(Sprites) do
      Sprites[i].Render;
    end;
    if Font0.State = asLoaded then
    begin
      PrintText(10, 10, G2Vec4(1, 1, 1, 1), 'FPS: ' + IntToStr(g2.FPS));
      PrintText(10, 40, G2Vec4(1, 1, 1, 1), 'Sprites: ' + IntToStr(Length(Sprites)));
      Font0.Print(10, 10, 'FPS: ' + IntToStr(g2.FPS));
      Font0.Print(10, 40, 'Sprites: ' + IntToStr(Length(Sprites)));
    end;
    //g2.PrimLine(10, 10, 100, 100, G2Color(0, 0, 0, 1));
  end;
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
//TGame END

end.
