unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2ImagePNG,
  G2DataManager,
  G2Scene2D,
  box2d,
  Spine,
  Types,
  SysUtils,
  Classes;

type
  TShotComponent = class (TG2Scene2DComponent)
  private
    var _Dead: Boolean;
    var _Duration: TG2Float;
  public
    property Dead: Boolean read _Dead write _Dead;
    procedure OnInitialize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnUpdate;
  end;

  TGameState0 = class (TG2GameState)
  public
    var Display: TG2Display2D;
    var Scene: TG2Scene2D;
    var PlayerEntity: TG2Scene2DEntity;
    var BackgroundEntity: TG2Scene2DEntity;
    var ShotDelay: TG2Float;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnRender; override;
    procedure OnUpdate; override;
    procedure OnScroll(const y: Integer); override;
    procedure OnBulletHit(const Data: TG2Scene2DEventData);
    procedure OnUpdatePlayerAnimation(const SpineAnimation: TG2Scene2DComponentSpineAnimation);
  end;

  TGameState1 = class (TG2GameState)
  public
    var Display: TG2Display2D;
    var Scene: TG2Scene2D;
    var PullJoint: TG2Scene2DPullJoint;
    var PullEntityList: TG2Scene2DEntityList;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnRender; override;
    procedure OnUpdate; override;
    procedure OnMouseDown(const Button, x, y: Integer); override;
    procedure OnMouseUp(const Button, x, y: Integer); override;
    procedure OnScroll(const y: Integer); override;
  end;

  TGame = class
  public
    var Font: TG2Font;
    var State: TG2GameState;
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

//TGameState0 BEGIN
procedure TGameState0.OnInitialize;
  var Character: TG2Scene2DComponentCharacter;
  var Animation: TG2Scene2DComponentSpineAnimation;
begin
  inherited OnInitialize;
  Display := TG2Display2D.Create;
  Display.Width := 10;
  Display.Height := 10;
  Display.Position := G2Vec2(0, 0);
  Display.Zoom := 1.3;
  Scene := TG2Scene2D.Create;
  Scene.Load('scene.g2s2d');
  //Scene.Gravity := G2Vec2(0, 9.8);
  Scene.Simulate := True;
  Scene.EnablePhysics;
  PlayerEntity := Scene.FindEntityByName('Player');
  BackgroundEntity := Scene.FindEntityByName('Background');
  Character := TG2Scene2DComponentCharacter(PlayerEntity.ComponentOfType[TG2Scene2DComponentCharacter]);
  Character.Enabled := True;
  Character.MaxGlideSpeed := 3;
  Animation := TG2Scene2DComponentSpineAnimation(PlayerEntity.ComponentOfType[TG2Scene2DComponentSpineAnimation]);
  if Assigned(Animation) then
  begin
    Animation.OnUpdateAnimation := @OnUpdatePlayerAnimation;
  end;
  ShotDelay := 0;
  Enabled := True;
end;

procedure TGameState0.OnFinalize;
begin
  Scene.Free;
  Display.Free;
  inherited OnFinalize;
end;

procedure TGameState0.OnRender;
begin
  Scene.Render(Display);
end;

procedure TGameState0.OnUpdate;
  var rb: TG2Scene2DComponentRigidBody;
  var Character: TG2Scene2DComponentCharacter;
  var Animation: TG2Scene2DComponentSpineAnimation;
  var Sprite: TG2Scene2DComponentSprite;
  var GunBone: TSpineBone;
  var xf, gxf: TG2Transform2;
  var Shot: TG2Scene2DEntity;
  var sc: TG2Scene2DComponentCollisionShapeCircle;
  var ShotComponent: TShotComponent;
begin
  if Assigned(BackgroundEntity) then
  begin
    xf := BackgroundEntity.Transform;
    xf.p := Display.Position;
    BackgroundEntity.Transform := xf;
  end;
  if PlayerEntity <> nil then
  begin
    Display.Position := G2LerpVec2(Display.Position, PlayerEntity.Transform.p, 0.1);
    Character := TG2Scene2DComponentCharacter(PlayerEntity.ComponentOfType[TG2Scene2DComponentCharacter]);
    Animation := TG2Scene2DComponentSpineAnimation(PlayerEntity.ComponentOfType[TG2Scene2DComponentSpineAnimation]);
    if Character.Standing then
    begin
      if g2.KeyDown[G2K_D] then
      begin
        Character.Walk(15);
        if Assigned(Animation) then
        begin
          Animation.Animation := 'run';
          Animation.FlipX := False;
          //Animation.Scale := G2Vec2(0.0016, 0.0016);
        end;
      end
      else if g2.KeyDown[G2K_A] then
      begin
        Character.Walk(-15);
        if Assigned(Animation) then
        begin
          Animation.Animation := 'run';
          Animation.FlipX := True;
          //Animation.Scale := G2Vec2(-0.0016, 0.0016);
        end;
      end
      else
      begin
        if Assigned(Animation) then
        begin
          Animation.Animation := 'idle';
        end;
      end;
      if g2.KeyDown[G2K_Space] then
      begin
        Character.Jump(G2Vec2(0, -10));
        if Assigned(Animation) then
        begin
          Animation.Animation := '';
          Animation.AnimationState.SetAnimation(0, 'jump', False).EndTime := 1;
        end;
      end;
    end
    else
    begin
      if g2.KeyDown[G2K_D] then
      begin
        Character.Glide(G2Vec2(0.25, 0));
      end
      else if g2.KeyDown[G2K_A] then
      begin
        Character.Glide(G2Vec2(-0.25, 0));
      end;
      if Assigned(Animation)
      and (Animation.Animation <> '') then
      begin
        Animation.Animation := '';
        with Animation.AnimationState.SetAnimation(0, 'jump', False) do
        begin
          Time := 0.5;
          EndTime := 1;
        end;
      end;
    end;
    if ShotDelay > 0 then ShotDelay -= g2.DeltaTimeSec;
    if g2.KeyDown[G2K_Ctrl] and (ShotDelay <= 0) then
    begin
      ShotDelay := 0.1;
      if Assigned(Animation.AnimationState.GetCurrent(1)) then
      begin
        Animation.AnimationState.GetCurrent(1).Time := 0;
      end
      else
      begin
        Animation.AnimationState.SetAnimation(1, 'shoot', False).TimeScale := 2;
      end;
      Animation.UpdateAnimation(0);
      GunBone := Animation.Skeleton.FindBone('gun');
      gxf := Animation.BoneTransform[GunBone];
      if Animation.FlipX then
      gxf.r.Angle := gxf.r.Angle - 0.6
      else
      gxf.r.Angle := gxf.r.Angle + 0.6;
      gxf.p := gxf.p + gxf.r.AxisX * 0.25;
      Shot := TG2Scene2DEntity.Create(Scene);
      Sprite := TG2Scene2DComponentSprite.Create(Scene);
      Sprite.Layer := 20;
      Sprite.Attach(Shot);
      Sprite.Picture := TG2Picture.SharedAsset('bullet.png', tu2D);
      Sprite.Height := 0.5;
      Shot.Transform := gxf;
      rb := TG2Scene2DComponentRigidBody.Create(Scene);
      rb.Attach(Shot);
      sc := TG2Scene2DComponentCollisionShapeCircle.Create(Scene);
      sc.Radius := 0.2;
      sc.IsSensor := True;
      sc.EventBeginContact.AddEvent(@OnBulletHit);
      sc.Attach(Shot);
      rb.BodyType := g2_s2d_rbt_dynamic_body;
      rb.FixedRotation := True;
      rb.GravityScale := 0;
      rb.Enabled := True;
      rb.PhysBody^.set_linear_velocity(Shot.Transform.r.AxisX * 15);
      ShotComponent := TShotComponent.Create(Scene);
      ShotComponent.Attach(Shot);
    end;
  end;
end;

procedure TGameState0.OnScroll(const y: Integer);
begin
  if y > 0 then Display.Zoom := Display.Zoom * 1.1
  else Display.Zoom := Display.Zoom / 1.1;
end;

procedure TGameState0.OnBulletHit(const Data: TG2Scene2DEventData);
  var EventData: TG2Scene2DEventBeginContactData absolute Data;
  var Shot: TShotComponent;
  var Effect: TG2Scene2DComponentEffect;
  var e: TG2Scene2DEntity;
  var rb: TG2Scene2DComponentRigidBody;
begin
  if EventData.Shapes[1] <> nil then
  begin
    Shot := TShotComponent(EventData.Shapes[0].Owner.ComponentOfType[TShotComponent]);
    if Assigned(Shot) then
    begin
      Shot.Dead := True;
      e := TG2Scene2DEntity.Create(Scene);
      e.Transform := Shot.Owner.Transform;
      Effect := TG2Scene2DComponentEffect.Create(Scene);
      Effect.Attach(e);
      Effect.Layer := 20;
      Effect.Effect := TG2Effect2D.SharedAsset('Damage.g2fx');
      Effect.Scale := 0.5;
      Effect.Speed := 2;
      Effect.AutoDestruct := True;
      Effect.Play;
      rb := TG2Scene2DComponentRigidBody(EventData.Shapes[1].Owner.ComponentOfType[TG2Scene2DComponentRigidBody]);
      if Assigned(rb) then
      begin
        rb.PhysBody^.apply_force(e.Transform.r.AxisX * 100, e.Transform.p, True);
      end;
    end;
  end;
end;

procedure TGameState0.OnUpdatePlayerAnimation(const SpineAnimation: TG2Scene2DComponentSpineAnimation);
  var Bone: TSpineBone;
begin
  if (SpineAnimation.Animation = 'run')
  and Assigned(SpineAnimation.AnimationState.GetCurrent(1)) then
  begin
    Bone := SpineAnimation.Skeleton.FindBone('rear_upper_arm');
    Bone.Rotation := Bone.Rotation + 45;
    Bone.RotationIK := Bone.Rotation;
  end;
end;
//TGameState0 END

//TGameState1 BEGIN
procedure TGameState1.OnInitialize;
  var Background: TG2Scene2DEntity;
begin
  inherited OnInitialize;
  Display := TG2Display2D.Create;
  Display.Width := 10;
  Display.Height := 10;
  Display.Position := G2Vec2(0, 0);
  Display.Zoom := 1.3;
  Scene := TG2Scene2D.Create;
  Scene.Load('scene1.g2s2d');
  Scene.Simulate := True;
  Scene.EnablePhysics;
  Background := Scene.FindEntityByName('Background');
  if Assigned(Background) then
  begin
    Display.Position := Background.Position;
  end;
  PullJoint := nil;
end;

procedure TGameState1.OnFinalize;
begin
  if Assigned(PullJoint) then FreeAndNil(PullJoint);
  Scene.Free;
  Display.Free;
  inherited OnFinalize;
end;

procedure TGameState1.OnRender;
begin
  Scene.Render(Display);
end;

procedure TGameState1.OnUpdate;
begin
  if Assigned(PullJoint) then
  begin
    PullJoint.Target := Display.CoordToDisplay(g2.MousePos);
  end;
end;

procedure TGameState1.OnMouseDown(const Button, x, y: Integer);
  var p: TG2Vec2;
begin
  inherited OnMouseDown(Button, x, y);
  if not Assigned(PullJoint)
  and (Button = G2MB_Left) then
  begin
    p := Display.CoordToDisplay(G2Vec2(x, y));
    PullEntityList.Clear;
    Scene.QueryPoint(p, PullEntityList);
    if PullEntityList.Count > 0 then
    begin
      PullJoint := TG2Scene2DPullJoint.Create(Scene);
      PullJoint.RigidBody := TG2Scene2DComponentRigidBody(PullEntityList[0].ComponentOfType[TG2Scene2DComponentRigidBody]);
      PullJoint.Target := p;
      PullJoint.Enabled := True;
    end;
  end;
end;

procedure TGameState1.OnMouseUp(const Button, x, y: Integer);
begin
  inherited OnMouseUp(Button, x, y);
  if Assigned(PullJoint)
  and (Button = G2MB_Left) then
  begin
    FreeAndNil(PullJoint);
  end;
end;

procedure TGameState1.OnScroll(const y: Integer);
begin
  if y > 0 then Display.Zoom := Display.Zoom * 1.1
  else Display.Zoom := Display.Zoom / 1.1;
end;
//TGameState1 END

//TShotComponent BEGIN
procedure TShotComponent.OnInitialize;
begin
  inherited OnInitialize;
  _Dead := False;
  _Duration := 5;
end;

procedure TShotComponent.OnAttach;
begin
  inherited OnAttach;
  g2.CallbackUpdateAdd(@OnUpdate);
end;

procedure TShotComponent.OnDetach;
begin
  g2.CallbackUpdateRemove(@OnUpdate);
  inherited OnDetach;
end;

procedure TShotComponent.OnUpdate;
begin
  _Duration -= g2.DeltaTimeSec;
  if _Duration <= 0 then Dead := True;
  if Dead then Owner.Free;
end;
//TShotComponent END

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
  g2.Params.TargetUPS := 30;
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
begin
  Font := TG2Font.Create;
  Font.Make(32);
  State := TGameState1.Create;
end;

procedure TGame.Finalize;
begin
  State.Free;
  Font.Free;
  Free;
end;

procedure TGame.Update;
begin

end;

procedure TGame.Render;
begin

end;

procedure TGame.KeyDown(const Key: Integer);
begin
  if Key = G2K_P then
  begin
    if g2.Params.ScreenMode = smWindow then
    g2.Params.ScreenMode := smFullscreen
    else
    begin
      g2.Params.ScreenMode := smWindow;
      g2.Params.Width := 768;
      g2.Params.Height := 768;
    end;
    g2.Params.Apply;
  end;
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
