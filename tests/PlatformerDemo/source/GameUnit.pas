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
  TActorComponent = class (TG2Scene2DComponent)
  protected
    var _Ready: Boolean;
    var _Character: TG2Scene2DComponentCharacter;
    var _Animation: TG2Scene2DComponentSpineAnimation;
    procedure OnUpdateAnimation(const SpineAnimation: TG2Scene2DComponentSpineAnimation); virtual;
    function VerifyDependencies: Boolean; virtual;
    procedure OnInitialize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnUpdate; virtual;
  public
  end;

  TPlayerComponent = class (TActorComponent)
  private
    var _ShotDelay: TG2Float;
    procedure Shoot;
  protected
    procedure OnUpdateAnimation(const SpineAnimation: TG2Scene2DComponentSpineAnimation); override;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnUpdate; override;
  public
  end;

  TAlienComponent = class (TActorComponent)
  private
    var _DirRight: Boolean;
    var _DirSwitchTime: TG2Float;
    var _FloorRightDetect: Integer;
    var _FloorLeftDetect: Integer;
    var _IsFloorDetectSetup: Boolean;
    procedure OnFloorRightDetectInc(const Data: TG2Scene2DEventData);
    procedure OnFloorRightDetectDec(const Data: TG2Scene2DEventData);
    procedure OnFloorLeftDetectInc(const Data: TG2Scene2DEventData);
    procedure OnFloorLeftDetectDec(const Data: TG2Scene2DEventData);
  protected
    function VerifyDependencies: Boolean; override;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnUpdate; override;
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

//TActorComponent BEGIN
procedure TActorComponent.OnUpdateAnimation(const SpineAnimation: TG2Scene2DComponentSpineAnimation);
begin

end;

function TActorComponent.VerifyDependencies: Boolean;
begin
  if Owner = nil then Exit(False);
  _Character := TG2Scene2DComponentCharacter(Owner.ComponentOfType[TG2Scene2DComponentCharacter]);
  if _Character = nil then Exit(False);
  _Animation := TG2Scene2DComponentSpineAnimation(Owner.ComponentOfType[TG2Scene2DComponentSpineAnimation]);
  if _Animation = nil then Exit(False);
  _Animation.OnUpdateAnimation := @OnUpdateAnimation;
  Result := True;
end;

procedure TActorComponent.OnInitialize;
begin
  inherited OnInitialize;
  _Ready := False;
end;

procedure TActorComponent.OnAttach;
begin
  inherited OnAttach;
  g2.CallbackUpdateAdd(@OnUpdate);
end;

procedure TActorComponent.OnDetach;
begin
  inherited OnDetach;
  g2.CallbackUpdateRemove(@OnUpdate);
end;

procedure TActorComponent.OnUpdate;
begin
  if not _Ready then _Ready := VerifyDependencies;
end;
//TActorComponent END

//TPlayerComponent BEGIN
procedure TPlayerComponent.OnUpdateAnimation(const SpineAnimation: TG2Scene2DComponentSpineAnimation);
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
  inherited OnInitialize;
  _ShotDelay := 0;
end;

procedure TPlayerComponent.OnFinalize;
begin

end;

procedure TPlayerComponent.OnUpdate;
begin
  inherited OnUpdate;
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

//TAlienComponent BEGIN
procedure TAlienComponent.OnFloorRightDetectInc(const Data: TG2Scene2DEventData);
  var EventData: TG2Scene2DEventBeginContactData absolute Data;
begin
  if EventData.Shapes[1] <> nil then Inc(_FloorRightDetect);
end;

procedure TAlienComponent.OnFloorRightDetectDec(const Data: TG2Scene2DEventData);
  var EventData: TG2Scene2DEventEndContactData absolute Data;
begin
  if EventData.Shapes[1] <> nil then Dec(_FloorRightDetect);
end;

procedure TAlienComponent.OnFloorLeftDetectInc(const Data: TG2Scene2DEventData);
  var EventData: TG2Scene2DEventBeginContactData absolute Data;
begin
  if EventData.Shapes[1] <> nil then Inc(_FloorLeftDetect);
end;

procedure TAlienComponent.OnFloorLeftDetectDec(const Data: TG2Scene2DEventData);
  var EventData: TG2Scene2DEventEndContactData absolute Data;
begin
  if EventData.Shapes[1] <> nil then Dec(_FloorLeftDetect);
end;

function TAlienComponent.VerifyDependencies: Boolean;
begin
  Result := inherited VerifyDependencies;
  if not Result then Exit;
  if not _IsFloorDetectSetup then
  begin
    _IsFloorDetectSetup := True;
    Owner.AddEvent('OnFloorRightDetectBegin', @OnFloorRightDetectInc);
    Owner.AddEvent('OnFloorRightDetectEnd', @OnFloorRightDetectDec);
    Owner.AddEvent('OnFloorLeftDetectBegin', @OnFloorLeftDetectInc);
    Owner.AddEvent('OnFloorLeftDetectEnd', @OnFloorLeftDetectDec);
  end;
end;

procedure TAlienComponent.OnInitialize;
begin
  inherited OnInitialize;
  _DirRight := True;
  _DirSwitchTime := 0;
  _FloorRightDetect := 0;
  _FloorLeftDetect := 0;
  _IsFloorDetectSetup := False;
end;

procedure TAlienComponent.OnFinalize;
begin
  inherited OnFinalize;
end;

procedure TAlienComponent.OnUpdate;
  var b, FloorDetect: Boolean;
  var pd: TG2Float;
begin
  inherited OnUpdate;
  if not _Ready then Exit;
  if _DirSwitchTime > 0 then _DirSwitchTime -= g2.DeltaTimeSec;
  pd := (Game.Player.Transform.p - Owner.Transform.p).LenSq;
  if (_DirSwitchTime <= 0)
  and (pd < Sqr(5)) then
  begin
    b := Game.Player.Transform.p.x > Owner.Transform.p.x;
    if b <> _DirRight then
    begin
      _DirRight := b;
      _DirSwitchTime := 0.4;
    end;
  end;
  if pd < 1.5 then
  begin
    _Animation.Animation := 'jump';
    if _Character.Standing
    and (Game.Player.Transform.p.y < Owner.Transform.p.y - 1) then
    begin
      _Character.Jump(G2Vec2(0, -10));
    end;
  end
  else
  begin
    _Animation.Animation := 'run';
  end;
  if _DirRight then FloorDetect := _FloorRightDetect > 0
  else FloorDetect := _FloorLeftDetect > 0;
  if _Character.Standing
  and not FloorDetect
  and (_DirSwitchTime <= 0) then
  begin
    _DirRight := not _DirRight;
    _DirSwitchTime := 0.4;
  end;
  if _DirRight then _Character.Walk(20)
  else _Character.Walk(-20);
  _Animation.FlipX := not _DirRight;
end;
//TAlienComponent END

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
  var Effect: TG2Scene2DComponentEffect;
  var e: TG2Scene2DEntity;
  var rb: TG2Scene2DComponentRigidBody;
begin
  if (EventData.Entities[1] <> nil)
  and (EventData.Entities[1].ComponentOfType[TPlayerComponent] = nil) then
  begin
    Dead := True;
    e := TG2Scene2DEntity.Create(Scene);
    e.Transform := Owner.Transform;
    Effect := TG2Scene2DComponentEffect.Create(Scene);
    Effect.Attach(e);
    Effect.Layer := 20;
    Effect.Effect := TG2Effect2D.SharedAsset('Damage.g2fx');
    Effect.Scale := 0.5;
    Effect.Speed := 2;
    Effect.AutoDestruct := True;
    Effect.Play;
    rb := TG2Scene2DComponentRigidBody(EventData.Entities[1].ComponentOfType[TG2Scene2DComponentRigidBody]);
    if Assigned(rb) then
    begin
      rb.PhysBody^.apply_force(e.Transform.r.AxisX * 100, e.Transform.p, True);
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
  var i: Integer;
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
  for i := 0 to Scene.EntityCount - 1 do
  if Scene.Entities[i].HasTag('alien') then
  begin
    TAlienComponent.Create(Scene).Attach(Scene.Entities[i]);
  end;
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
