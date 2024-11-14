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
    Player: TG2Scene2DEntity;
    Wheel0: TG2Scene2DEntity;
    Wheel1: TG2Scene2DEntity;
    Jet0: TG2Scene2DEntity;
    Jet1: TG2Scene2DEntity;
    jp0, jp1: TG2Float;
    rt, rt1: TG2Texture2DRT;
    Recover: Boolean;
    RecoverTime: TG2Float;
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
    procedure OnArmHit(const EventData: TG2Scene2DEventData);
  end;

var
  Game: TGame;

 const EnginePower = 1;
 const JetPower = 14.5;

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
  Scene.Load('../assets/scene2.g2s2d');
  Scene.Gravity := G2Vec2(0, 6);
  Scene.Simulate := True;
  Scene.EnablePhysics;
  Player := Scene.FindEntityByName('Object');
  Wheel0 := Scene.FindEntityByName('Wheel0');
  Wheel1 := Scene.FindEntityByName('Wheel1');
  Jet0 := Scene.FindEntityByName('Jet0');
  Jet1 := Scene.FindEntityByName('Jet1');
  Player.AddEvent('OnArmHit', @OnArmHit);
  rt := TG2Texture2DRT.Create;
  rt.Make(128, 128);
  rt1 := TG2Texture2DRT.Create;
  rt1.Make(64, 64);
  jp0 := 0;
  jp1 := 0;
end;

procedure TGame.Finalize;
begin
  rt.Free;
  rt1.Free;
  Scene.Free;
  Display.Free;
  Font.Free;
end;

procedure TGame.Update;
  var rb: TG2Scene2DComponentRigidBody;
  var fx: TG2Scene2DComponentEffect;
begin
  if Player <> nil then
  Display.Position := Player.Transform.p;
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
  if Assigned(Jet0) then
  begin
    fx := TG2Scene2DComponentEffect(Jet0.ComponentOfType[TG2Scene2DComponentEffect]);
    if Assigned(fx) then
    begin
      if g2.KeyDown[G2K_D] then
      begin
        fx.Play;
        rb := TG2Scene2DComponentRigidBody(Player.ComponentOfType[TG2Scene2DComponentRigidBody]);
        if Assigned(rb) then
        begin
          jp0 := G2LerpFloat(jp0, JetPower, 0.1);
          rb.PhysBody^.apply_force(-Jet0.Transform.r.AxisX * jp0, Jet0.Transform.p, true);
        end;
      end
      else
      begin
        jp0 := 0;
        fx.Stop;
      end;
    end;
  end;
  if Assigned(Jet1) then
  begin
    fx := TG2Scene2DComponentEffect(Jet1.ComponentOfType[TG2Scene2DComponentEffect]);
    if Assigned(fx) then
    begin
      if g2.KeyDown[G2K_A] then
      begin
        fx.Play;
        rb := TG2Scene2DComponentRigidBody(Player.ComponentOfType[TG2Scene2DComponentRigidBody]);
        if Assigned(rb) then
        begin
          jp1 := G2LerpFloat(jp1, JetPower, 0.1);
          rb.PhysBody^.apply_force(-Jet1.Transform.r.AxisX * jp1, Jet1.Transform.p, true);
        end;
      end
      else
      begin
        jp1 := 0;
        fx.Stop;
      end;
    end;
  end;
  Recover := g2.KeyDown[G2K_Space];
  if Recover then
  begin
    if RecoverTime > 0 then
    begin
      rb := TG2Scene2DComponentRigidBody(Player.ComponentOfType[TG2Scene2DComponentRigidBody]);
      if Assigned(rb) then
      begin
        rb.PhysBody^.apply_force_to_center(b2_vec2(0, -25), True);
        rb.PhysBody^.apply_torque(3, True);
      end;
      fx := TG2Scene2DComponentEffect(Player.ComponentOfType[TG2Scene2DComponentEffect]);
      if Assigned(fx) then
      begin
        fx.Play;
      end;
    end;
    RecoverTime -= g2.DeltaTimeSec;
    if RecoverTime < 0 then RecoverTime := 0;
  end
  else
  begin
    RecoverTime += g2.DeltaTimeSec;
    if RecoverTime > 1 then RecoverTime := 1;
  end;
end;

procedure TGame.Render;
begin
  g2.Gfx.StateChange.StateRenderTarget := rt;
  Display.ViewPort := Rect(0, 0, 128, 128);
  Scene.Render(Display);
  g2.Gfx.StateChange.StateRenderTarget := rt1;
  g2.PicRect(0, 0, 64, 64, $ffffffff, rt, bmNormal, tfPoint);
  g2.Gfx.StateChange.StateRenderTarget := nil;
  g2.PicRect(0, 0, 768, 768, $ffffffff, rt1, bmNormal, tfPoint);
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

procedure TGame.OnArmHit(const EventData: TG2Scene2DEventData);
  var Data: TG2Scene2DEventBeginContactData absolute EventData;
  var wm: tb2_world_manifold;
  var fxe: TG2Scene2DEntity;
  var fx: TG2Scene2DComponentEffect;
begin
  if EventData is TG2Scene2DEventBeginContactData then
  begin
    fxe := Scene.FindEntityByName('fx');
    if Assigned(fxe) then
    begin
      fx := TG2Scene2DComponentEffect(fxe.ComponentOfType[TG2Scene2DComponentEffect]);
      if Assigned(fx) then
      begin
        fx.Play;
      end;
    end;
  end;
end;

//TGame END

end.
