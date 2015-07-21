unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  G2Scene2D,
  box2d,
  Types,
  SysUtils,
  Classes;

type
  TGame = class
  public
    Font: TG2Font;
    Scene: TG2Scene2D;
    Display: TG2Display2D;
    PlayerEntity: TG2Scene2DEntity;
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
  g2.Params.ScreenMode := smMaximized;
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
  Font := TG2Font.Create;
  Font.Make(32);
  Display := TG2Display2D.Create;
  Display.Width := 10;
  Display.Height := 10;
  Display.Position := G2Vec2(0, 0);
  Scene := TG2Scene2D.Create;
  Scene.Load('../assets/scene2.g2s2d');
  Scene.Gravity := G2Vec2(0, 9.8);
  Scene.Simulate := True;
  Scene.EnablePhysics;
  PlayerEntity := Scene.FindEntityByName('Player');
end;

procedure TGame.Finalize;
begin
  Scene.Free;
  Display.Free;
  Font.Free;
end;

procedure TGame.Update;
begin
  if PlayerEntity <> nil then
  Display.Position := PlayerEntity.Transform.p;
end;

procedure TGame.Render;
begin
  Scene.Render(Display);
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
  if y > 0 then Display.Zoom := Display.Zoom * 1.1
  else Display.Zoom := Display.Zoom / 1.1;
end;

procedure TGame.Print(const c: AnsiChar);
begin

end;
//TGame END

end.
