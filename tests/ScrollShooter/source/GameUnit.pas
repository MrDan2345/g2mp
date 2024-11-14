unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  G2Scene2D,
  Types,
  SysUtils,
  Classes;

type
  TAsteroid = class (TG2Scene2DComponent)
  private
    var Duration: TG2Float;
    var Health: Integer;
    procedure OnHitEvent(const EventData: TG2Scene2DEventData);
  protected
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnUpdate;
  public
    procedure Damage(const Amount: Integer);
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
  end;

  TShot = class (TG2Scene2DComponent)
  private
    var Duration: TG2Float;
    procedure OnHitEvent(const EventData: TG2Scene2DEventData);
  protected
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnUpdate;
  public
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
  end;

  TPlayer = class (TG2Scene2DComponent)
  protected
    var GunIndex: Integer;
    var ShotDelay: TG2Float;
    var Guns: array[0..1] of TG2Scene2DEntity;
    var Engine: TG2Scene2DComponentEffect;
    var SpriteFrames: array[0..3] of TG2Picture;
    var RigidBody: TG2Scene2DComponentRigidBody;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnUpdate;
  public
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
  end;

  TGameRule = class
  private
    class var List: TGameRule;
    var Next: TGameRule;
    var Prev: TGameRule;
  public
    class constructor CreateClass;
    class procedure FreeAll;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TAsteroidGenerator = class (TGameRule)
  private
    var Duration: TG2Float;
  public
    function Work(const Interval: Integer): Integer;
    constructor Create; override;
  end;

  TGame = class
  protected
  public
    var Display: TG2Display2D;
    var Scene: TG2Scene2D;
    var Player: TPlayer;
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
    procedure CreateEffect(const Name: String; const Transform: TG2Transform2; const Scale: TG2Float = 1; const Speed: TG2Float = 1);
  end;

var
  Game: TGame;

implementation

//TAsteroid BEGIN
procedure TAsteroid.OnHitEvent(const EventData: TG2Scene2DEventData);
  var Data: TG2Scene2DEventBeginContactData absolute EventData;
  var EffectEntity: TG2Scene2DEntity;
  var Effect: TG2Scene2DComponentEffect;
begin
  EffectEntity := TG2Scene2DEntity.Create(Scene);
  EffectEntity.Position := Data.GetContactPoint;
  Effect := TG2Scene2DComponentEffect.Create(Scene);
  Effect.Attach(EffectEntity);
  Effect.Effect := TG2Effect2D.SharedAsset('Dust.g2fx');
  Effect.AutoDestruct := True;
  Effect.Layer := 14;
  Effect.Scale := 0.5;
  Effect.Speed := 1.4;
  Effect.Play;
end;

procedure TAsteroid.OnAttach;
  var Sprite: TG2Scene2DComponentSprite;
  var Shape: TG2Scene2DComponentCollisionShapeCircle;
  var rb: TG2Scene2DComponentRigidBody;
  var Scale: TG2Float;
begin
  inherited OnAttach;
  Duration := 10;
  Health := 30;
  Scale := 1 + Random * 1;
  Shape := TG2Scene2DComponentCollisionShapeCircle(Owner.ComponentOfType[TG2Scene2DComponentCollisionShapeCircle]);
  if Assigned(Shape) then
  begin
    Shape.Radius := Shape.Radius * Scale;
  end;
  Sprite := TG2Scene2DComponentSprite(Owner.ComponentOfType[TG2Scene2DComponentSprite]);
  if Assigned(Sprite) then
  begin
    Sprite.Picture := TG2Picture.SharedAsset(
      'asteroids.g2atlas#0' + IntToStr(Random(8) + 1) + '.png', tu2D
    );
    Sprite.Scale := Sprite.Scale * Scale;
  end;
  rb := TG2Scene2DComponentRigidBody(Owner.ComponentOfType[TG2Scene2DComponentRigidBody]);
  rb.Enabled := True;
  rb.LinearVelocity := G2Vec2(Random * 2 - 1, 2 + Random);
  rb.AngularVelocity := (G2Random2Pi - Pi) * 0.5;
  Owner.AddEvent('OnBeginContact', @OnHitEvent);
  g2.CallbackUpdateAdd(@OnUpdate);
end;

procedure TAsteroid.OnDetach;
begin
  g2.CallbackUpdateRemove(@OnUpdate);
  inherited OnDetach;
end;

procedure TAsteroid.OnUpdate;
  var EffectEntity: TG2Scene2DEntity;
  var Effect: TG2Scene2DComponentEffect;
  var Sprite: TG2Scene2DComponentSprite;
begin
  Duration -= g2.DeltaTimeSec;
  if Duration <= 0 then
  begin
    if Health <= 0 then
    begin
      EffectEntity := TG2Scene2DEntity.Create(Scene);
      EffectEntity.Position := Owner.Position;
      Effect := TG2Scene2DComponentEffect.Create(Scene);
      Effect.Attach(EffectEntity);
      Effect.Layer := 1;
      Sprite := TG2Scene2DComponentSprite(Owner.ComponentOfType[TG2Scene2DComponentSprite]);
      if Assigned(Sprite) then
      begin
        Effect.Scale := Sprite.Scale;
      end;
      Effect.Effect := TG2Effect2D.SharedAsset('AsteroidBreak.g2fx');
      Effect.AutoDestruct := True;
      Effect.Play;
    end;
    Owner.Free;
  end;
end;

procedure TAsteroid.Damage(const Amount: Integer);
begin
  Health -= Amount;
  if Health <= 0 then Duration := 0;
end;

constructor TAsteroid.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create(OwnerScene);
end;

destructor TAsteroid.Destroy;
begin
  inherited Destroy;
end;
//TAsteroid END

//TAsteroidGenerator BEGIN
function TAsteroidGenerator.Work(const Interval: Integer): Integer;
  var AsteroidEntity: TG2Scene2DEntity;
  var Asteroid: TAsteroid;
begin
  AsteroidEntity := Game.Scene.CreatePrefab(
    'asteroid.g2prefab2d',
    G2Transform2(G2Vec2(Random * 10 - 5, -7), G2Rotation2(G2Random2Pi))
  );
  if Assigned(AsteroidEntity) then
  begin
    Asteroid := TAsteroid.Create(Game.Scene);
    Asteroid.Attach(AsteroidEntity);
  end;
  Result := 50 + Random(150);
end;

constructor TAsteroidGenerator.Create;
begin
  inherited Create;
  Duration := 0;
  g2.CustomTimer(@Work, 5000);
end;
//TAsteroidGenerator END

//TShot BEGIN
procedure TShot.OnHitEvent(const EventData: TG2Scene2DEventData);
  var EffectEntity: TG2Scene2DEntity;
  var Effect: TG2Scene2DComponentEffect;
  var Data: TG2Scene2DEventBeginContactData absolute EventData;
  var Asteroid: TAsteroid;
begin
  Asteroid := TAsteroid(Data.Entities[1].ComponentOfType[TAsteroid]);
  if Assigned(Asteroid) then
  begin
    Asteroid.Damage(5);
  end;
  EffectEntity := TG2Scene2DEntity.Create(Scene);
  EffectEntity.Transform := Owner.Transform;
  Effect := TG2Scene2DComponentEffect.Create(Scene);
  Effect.Attach(EffectEntity);
  Effect.Effect := TG2Effect2D.SharedAsset('ShotHit.g2fx');
  Effect.Layer := 15;
  Effect.Speed := 2.5;
  Effect.Scale := 0.8;
  Effect.AutoDestruct := True;
  Effect.Play;
  Duration := 0;
end;

procedure TShot.OnAttach;
begin
  inherited OnAttach;
  Duration := 3;
  Owner.AddEvent('OnBeginContact', @OnHitEvent);
  g2.CallbackUpdateAdd(@OnUpdate);
end;

procedure TShot.OnDetach;
begin
  g2.CallbackUpdateRemove(@OnUpdate);
  inherited OnDetach;
end;

procedure TShot.OnUpdate;
begin
  Duration -= g2.DeltaTimeSec;
  if Duration <= 0 then
  begin
    Owner.Free;
  end;
end;

constructor TShot.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create(OwnerScene);
end;

destructor TShot.Destroy;
begin
  inherited Destroy;
end;
//TShot END

//TPlayer BEGIN
procedure TPlayer.OnAttach;
  var i: Integer;
begin
  inherited OnAttach;
  Game.Player := Self;
  RigidBody := TG2Scene2DComponentRigidBody(Owner.ComponentOfType[TG2Scene2DComponentRigidBody]);
  RigidBody.Enabled := True;
  for i := 0 to Owner.ChildCount - 1 do
  begin
    if Owner.Children[i].HasTag('gun0') then Guns[0] := Owner.Children[i]
    else if Owner.Children[i].HasTag('gun1') then Guns[1] := Owner.Children[i]
    else if Owner.Children[i].HasTag('engine') then
    begin
      Engine := TG2Scene2DComponentEffect(Owner.Children[i].ComponentOfType[TG2Scene2DComponentEffect]);
    end;
  end;
  g2.CallbackUpdateAdd(@OnUpdate);
  GunIndex := 0;
  ShotDelay := 0;
end;

procedure TPlayer.OnDetach;
begin
  RigidBody := nil;
  Guns[0] := nil;
  Guns[1] := nil;
  Engine := nil;
  g2.CallbackUpdateRemove(@OnUpdate);
  if Game.Player = Self then Game.Player := nil;
  inherited OnDetach;
end;

procedure TPlayer.OnUpdate;
  var Target: TG2Vec2;
  var Shot: TG2Scene2DEntity;
  var rb: TG2Scene2DComponentRigidBody;
  var ShotComponent: TShot;
  var Sprite: TG2Scene2DComponentSprite;
  var dv: TG2Vec2;
begin
  if ShotDelay > 0 then ShotDelay -= g2.DeltaTimeSec;
  if g2.MouseDown[G2MB_Left] and (ShotDelay <= 0) then
  begin
    ShotDelay := 0.06;
    if Assigned(Guns[GunIndex]) then
    begin
      Shot := Scene.CreatePrefab('shot.g2prefab2d', Guns[GunIndex].Transform);
      if Assigned(Shot) then
      begin
        ShotComponent := TShot.Create(Scene);
        ShotComponent.Attach(Shot);
        rb := TG2Scene2DComponentRigidBody(Shot.ComponentOfType[TG2Scene2DComponentRigidBody]);
        if Assigned(rb) then
        begin
          rb.IsBullet := True;
          rb.Enabled := True;
          rb.LinearVelocity := G2Vec2(0, -15);
        end;
      end;
    end;
    GunIndex := (GunIndex + 1) mod Length(Guns);
  end;
  Target := Game.Display.CoordToDisplay(g2.MousePos);
  dv := Target - Owner.Transform.p;
  Sprite := TG2Scene2DComponentSprite(Owner.ComponentOfType[TG2Scene2DComponentSprite]);
  if Assigned(Sprite) then
  begin
    Sprite.FlipX := dv.x < 0;
    Sprite.Picture := SpriteFrames[G2Min(Round(Abs(dv.x) * 5), High(SpriteFrames))];
  end;
  if Assigned(Engine) then
  begin
    if dv.y < -0.01 then
    begin
      Engine.Play;
    end
    else
    begin
      Engine.Stop;
    end;
  end;
  RigidBody.LinearVelocity := dv * 15;
end;

constructor TPlayer.Create(const OwnerScene: TG2Scene2D);
  var i: Integer;
begin
  inherited Create(OwnerScene);
  RigidBody := nil;
  Guns[0] := nil;
  Guns[1] := nil;
  Engine := nil;
  for i := 0 to High(SpriteFrames) do
  begin
    SpriteFrames[i] := TG2Picture.SharedAsset('ship01.g2atlas#0' + IntToStr(1 + i) + '.png', tu2D);
    SpriteFrames[i].RefInc;
  end;
end;

destructor TPlayer.Destroy;
  var i: Integer;
begin
  for i := 0 to High(SpriteFrames) do
  begin
    SpriteFrames[i].RefDec;
  end;
  inherited Destroy;
end;
//TPlayer END

//TGameRule BEGIN
class constructor TGameRule.CreateClass;
begin
  List := nil;
end;

class procedure TGameRule.FreeAll;
begin
  while Assigned(List) do List.Free;
end;

constructor TGameRule.Create;
begin
  if Assigned(List) then List.Prev := Self;
  Prev := nil;
  Next := List;
  List := Self;
end;

destructor TGameRule.Destroy;
begin
  if Assigned(Prev) then Prev.Next := Next;
  if Assigned(Next) then Next.Prev := Prev;
  if List = Self then List := Next;
  inherited Destroy;
end;
//TGameRule END

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
  g2.Params.MaxFPS := 200;
  g2.Params.TargetUPS := 200;
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
  TG2Effect2D.SharedAsset('ShotHit.g2fx').RefInc;
  TG2Effect2D.SharedAsset('Dust.g2fx').RefInc;
  TG2Effect2D.SharedAsset('AsteroidBreak.g2fx').RefInc;
  Display := TG2Display2D.Create;
  Display.Width := 10;
  Display.Height := 10;
  Display.Position := G2Vec2(0, 0);
  Scene := TG2Scene2D.Create;
  Scene.Load('scene1.g2s2d');
  Scene.Simulate := True;
  Scene.EnablePhysics;
  Player := nil;
  for i := 0 to Scene.EntityCount - 1 do
  if Scene.Entities[i].HasTag('player') then
  begin
    TPlayer.Create(Scene).Attach(Scene.Entities[i]);
    Break;
  end;
  TAsteroidGenerator.Create;
end;

procedure TGame.Finalize;
begin
  TG2Effect2D.SharedAsset('ShotHit.g2fx').RefDec;
  TG2Effect2D.SharedAsset('Dust.g2fx').RefDec;
  TG2Effect2D.SharedAsset('AsteroidBreak.g2fx').RefDec;
  TGameRule.FreeAll;
  Scene.Free;
  Display.Free;
  Free;
end;

procedure TGame.Update;
begin

end;

procedure TGame.Render;
begin
  g2.Clear($ff000000);
  Scene.Render(Display);
  //Scene.DebugDraw(Display);
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

procedure TGame.CreateEffect(const Name: String; const Transform: TG2Transform2; const Scale: TG2Float; const Speed: TG2Float);
  var Entity: TG2Scene2DEntity;
  var Effect: TG2Scene2DComponentEffect;
begin
  Entity := TG2Scene2DEntity.Create(Scene);
  Entity.Transform := Transform;
  Effect.Create(Scene);
  Effect.Attach(Entity);
  Effect.Effect := TG2Effect2D.SharedAsset('ShotHit.g2fx');
  Effect.Scale := Scale;
  Effect.Speed := Speed;
  Effect.Play;
  Effect.AutoDestruct := True;
end;

//TGame END

end.
