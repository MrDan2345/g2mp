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
    Wheel0: TG2Scene2DEntity;
    Wheel1: TG2Scene2DEntity;
    rt: TG2Texture2DRT;
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

 const EnginePower = 5;

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
  g2.Params.Width := 768;
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
  var i: Integer;
begin
  Font := TG2Font.Create;
  Font.Make(32);
  Display := TG2Display2D.Create;
  Display.Width := 10;
  Display.Height := 10;
  Display.Position := G2Vec2(0, 0);
  Scene := TG2Scene2D.Create;
  Scene.Load('../assets/scene1.g2s2d');
  Scene.Gravity := G2Vec2(0, 9.8);
  Scene.Simulate := True;
  Scene.EnablePhysics;
  PlayerEntity := Scene.FindEntityByName('Car');
  Wheel0 := Scene.FindEntityByName('Wheel0');
  Wheel1 := Scene.FindEntityByName('Wheel1');
  rt := TG2Texture2DRT.Create;
  rt.Make(64, 64);
end;

procedure TGame.Finalize;
begin
  rt.Free;
  Scene.Free;
  Display.Free;
  Font.Free;
end;

procedure TGame.Update;
  var rb: TG2Scene2DComponentRigidBody;
begin
  if PlayerEntity <> nil then
  Display.Position := PlayerEntity.Transform.p;
  if g2.KeyDown[G2K_Right] then
  begin
    rb := TG2Scene2DComponentRigidBody(Wheel0.ComponentOfType[TG2Scene2DComponentRigidBody]);
    rb.PhysBody^.apply_torque(EnginePower, true);
    rb := TG2Scene2DComponentRigidBody(Wheel1.ComponentOfType[TG2Scene2DComponentRigidBody]);
    rb.PhysBody^.apply_torque(EnginePower, true);
  end
  else if g2.KeyDown[G2K_Left] then
  begin
    rb := TG2Scene2DComponentRigidBody(Wheel0.ComponentOfType[TG2Scene2DComponentRigidBody]);
    rb.PhysBody^.apply_torque(-EnginePower, true);
    rb := TG2Scene2DComponentRigidBody(Wheel1.ComponentOfType[TG2Scene2DComponentRigidBody]);
    rb.PhysBody^.apply_torque(-EnginePower, true);
  end;
end;

procedure TGame.Render;
begin
  g2.RenderTarget := rt;
  Display.ViewPort := Rect(0, 0, 64, 64);
  Scene.Render(Display);
  g2.RenderTarget := nil;
  g2.PicRect(0, 0, 768, 768, $ffffffff, rt, bmNormal, tfPoint);
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
