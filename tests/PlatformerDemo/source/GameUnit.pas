unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  G2Scene2D,
  Spine,
  Types,
  Classes;

type
  TPlayerComponent = class (TG2Scene2DComponent)
  private
    var _Ready: Boolean;
    var _ShotDelay: TG2Float;
    var _Character: TG2Scene2DComponentCharacter;
    var _Animation: TG2Scene2DComponentSpineAnimation;
    function VerifyDependencies: Boolean;
    procedure OnUpdatePlayerAnimation(const SpineAnimation: TG2Scene2DComponentSpineAnimation);
    procedure Shoot;
  protected
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnUpdate;
  public
  end;

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
    procedure OnHit(const Data: TG2Scene2DEventData);
  end;

  TGame = class
  protected
  public
    var Scene: TG2Scene2D;
    var Display: TG2Display2D;
    var Player: TG2Scene2DEntity;
    var Background: TG2Scene2DEntity;
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

//TPlayerComponent BEGIN
function TPlayerComponent.VerifyDependencies: Boolean;
begin
  if Owner = nil then Exit(False);
  _Character := TG2Scene2DComponentCharacter(Owner.ComponentOfType[TG2Scene2DComponentCharacter]);
  if _Character = nil then Exit(False);
  _Animation := TG2Scene2DComponentSpineAnimation(Owner.ComponentOfType[TG2Scene2DComponentSpineAnimation]);
  if _Animation = nil then Exit(False);
  _Animation.OnUpdateAnimation := @OnUpdatePlayerAnimation;
  Result := True;
end;

procedure TPlayerComponent.OnUpdatePlayerAnimation(const SpineAnimation: TG2Scene2DComponentSpineAnimation);
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

procedure TPlayerComponent.Shoot;
  var gxf: TG2Transform2;
  var GunBone: TSpineBone;
  var Shot: TG2Scene2DEntity;
  var ShotComponent: TShotComponent;
begin
  _ShotDelay := 0.1;
  if Assigned(_Animation.AnimationState.GetCurrent(1)) then
  begin
    _Animation.AnimationState.GetCurrent(1).Time := 0;
  end
  else
  begin
    _Animation.AnimationState.SetAnimation(1, 'shoot', False).TimeScale := 2;
  end;
  _Animation.UpdateAnimation(0);
  GunBone := _Animation.Skeleton.FindBone('gun');
  gxf := _Animation.BoneTransform[GunBone];
  if _Animation.FlipX then
  gxf.r.Angle := gxf.r.Angle - 0.6
  else
  gxf.r.Angle := gxf.r.Angle + 0.6;
  gxf.p := gxf.p + gxf.r.AxisX * 0.25;
  Shot := TG2Scene2DEntity.Create(Scene);
  Shot.Transform := gxf;
  ShotComponent := TShotComponent.Create(Scene);
  ShotComponent.Attach(Shot);
end;

procedure TPlayerComponent.OnInitialize;
begin
  _Ready := False;
  _ShotDelay := 0;
end;

procedure TPlayerComponent.OnFinalize;
begin

end;

procedure TPlayerComponent.OnAttach;
begin
  g2.CallbackUpdateAdd(@OnUpdate);
end;

procedure TPlayerComponent.OnDetach;
begin
  g2.CallbackUpdateRemove(@OnUpdate);
end;

procedure TPlayerComponent.OnUpdate;
begin
  if not _Ready then _Ready := VerifyDependencies;
  if not _Ready then Exit;
  if _Character.Standing then
  begin
    if g2.KeyDown[G2K_D] then
    begin
      _Character.Walk(15);
      _Animation.Animation := 'run';
      _Animation.FlipX := False;
    end
    else if g2.KeyDown[G2K_A] then
    begin
      _Character.Walk(-15);
      _Animation.Animation := 'run';
      _Animation.FlipX := True;
    end
    else
    begin
      _Animation.Animation := 'idle';
    end;
    if g2.KeyDown[G2K_Space] then
    begin
      _Character.Jump(G2Vec2(0, -10));
      _Animation.Animation := '';
      _Animation.AnimationState.SetAnimation(0, 'jump', False).EndTime := 1;
    end;
  end
  else
  begin
    if g2.KeyDown[G2K_D] then
    begin
      _Character.Glide(G2Vec2(0.25, 0));
    end
    else if g2.KeyDown[G2K_A] then
    begin
      _Character.Glide(G2Vec2(-0.25, 0));
    end;
    if (_Animation.Animation <> '') then
    begin
      _Animation.Animation := '';
      with _Animation.AnimationState.SetAnimation(0, 'jump', False) do
      begin
        Time := 0.5;
        EndTime := 1;
      end;
    end;
  end;
  if _ShotDelay > 0 then _ShotDelay -= g2.DeltaTimeSec;
  if g2.KeyDown[G2K_Ctrl] and (_ShotDelay <= 0) then
  begin
    Shoot;
  end;
end;
//TPlayerComponent END

//TShotComponent BEGIN
procedure TShotComponent.OnInitialize;
begin
  inherited OnInitialize;
  _Dead := False;
  _Duration := 5;
end;

procedure TShotComponent.OnAttach;
  var Sprite: TG2Scene2DComponentSprite;
  var rb: TG2Scene2DComponentRigidBody;
  var sc: TG2Scene2DComponentCollisionShapeCircle;
begin
  inherited OnAttach;
  g2.CallbackUpdateAdd(@OnUpdate);
  Sprite := TG2Scene2DComponentSprite.Create(Scene);
  Sprite.Layer := 20;
  Sprite.Attach(Owner);
  Sprite.Picture := TG2Picture.SharedAsset('bullet.png', tu2D);
  Sprite.Height := 0.5;
  rb := TG2Scene2DComponentRigidBody.Create(Scene);
  rb.Attach(Owner);
  sc := TG2Scene2DComponentCollisionShapeCircle.Create(Scene);
  sc.Radius := 0.2;
  sc.IsSensor := True;
  sc.EventBeginContact.AddEvent(@OnHit);
  sc.Attach(Owner);
  rb.BodyType := g2_s2d_rbt_dynamic_body;
  rb.FixedRotation := True;
  rb.GravityScale := 0;
  rb.Enabled := True;
  rb.PhysBody^.set_linear_velocity(Owner.Transform.r.AxisX * 15);
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

procedure TShotComponent.OnHit(const Data: TG2Scene2DEventData);
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
begin
  Display := TG2Display2D.Create;
  Display.Width := 10;
  Display.Height := 10;
  Display.Position := G2Vec2(0, 0);
  Display.Zoom := 1.3;
  Scene := TG2Scene2D.Create;
  Scene.Load('Map1.g2s2d');
  Scene.Simulate := True;
  Scene.EnablePhysics;
  Player := Scene.FindEntityByName('Player');
  TPlayerComponent.Create(Scene).Attach(Player);
  Background := Scene.FindEntityByName('Background');
end;

procedure TGame.Finalize;
begin
  Scene.Free;
  Display.Free;
  Free;
end;

procedure TGame.Update;
begin
  if Assigned(Player) then
  begin
    Display.Position := Player.Transform.p;
  end;
  if Assigned(Background) then
  begin
    Background.Transform := G2Transform2(Display.Position, Background.Transform.r);
  end;
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

end;

procedure TGame.Print(const c: AnsiChar);
begin

end;
//TGame END

end.
