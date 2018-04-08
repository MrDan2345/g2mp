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
  Classes,
  SysUtils,
  box2d;

type
  TGameBase = class;
  CGameBase = class of TGameBase;
  TRequest = class;

  TPlayer = class
  private
    var _ChargeTime: TG2Float;
    var _Power: Integer;
    var _PowerMax: Integer;
    function GetPowerRatio: TG2Float; inline;
  public
    property Power: Integer read _Power write _Power;
    property PowerMax: Integer read _PowerMax write _PowerMax;
    property PowerRatio: TG2Float read GetPowerRatio;
    constructor Create;
    destructor Destroy; override;
    procedure Update;
    procedure Charge;
    function Drain(const Amount: Integer): Boolean;
  end;

  TColorComponent = class (TG2Scene2DComponent)
  public
    procedure SetColor(const Value: TG2Color);
  end;

  TUIWidget = class (TG2GameState)
  private
    function GetWidget: TUIWidget; inline;
    procedure SetWidget(const Value: TUIWidget); inline;
  public
    class var Atlas: TG2Atlas;
    property Widget: TUIWidget read GetWidget write SetWidget;
  end;

  TUIManager = class (TUIWidget)
  public
    procedure OnInitialize; override;
    procedure OnFinalize; override;
  end;

  TUIActionMenu = class (TUIWidget)
  public
    type TButton = class
    public
      FrameN: TG2AtlasFrame;
      FrameH: TG2AtlasFrame;
      OnClick: TG2ProcObj;
      Enabled: Boolean;
    end;
    var Buttons: array of TButton;
    var Position: TG2Vec2;
    function AddButton(const FrameName: String; const OnClick: TG2ProcObj): TButton;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnRender; override;
    procedure OnMouseDown(const Button, x, y: Integer); override;
  end;

  TUIGameplay = class (TUIWidget)
  private
    var _QueryList: TG2Scene2DEntityList;
    var FramePower: TG2AtlasFrame;
  public
    procedure OnInitialize; override;
    procedure OnMouseDown(const Button, x, y: Integer); override;
    procedure OnRender; override;
  end;

  TGameObject = class (TG2Scene2DEntity)
  private
    var _ActionMenu: TUIActionMenu;
  public
    property ActionMenu: TUIActionMenu read _ActionMenu write _ActionMenu;
    constructor Create(const OwnerScene: TG2Scene2D); override;
  end;

  TPacket = class
  private
    var _Time: TG2Float;
    var _Request: TRequest;
  public
    property Time: TG2Float read _Time write _Time;
    property Request: TRequest read _Request write _Request;
    constructor Create;
    destructor Destroy; override;
    function CheckTarget(const Target: TGameBase): Boolean; virtual;
  end;
  TPacketList = specialize TG2QuickListG<TPacket>;

  TPacketResource = class (TPacket)
  public
    function CheckTarget(const Target: TGameBase): Boolean; override;
  end;

  TPacketPower = class (TPacket)
  private
    var _Target: String;
  public
    constructor Create(const Target: String);
    function CheckTarget(const Target: TGameBase): Boolean; override;
  end;

  TRequest = class
  private
    var _Source: TGameBase;
    var _Packet: TPacket;
  public
    property Source: TGameBase read _Source;
    property Packet: TPacket read _Packet write _Packet;
    constructor Create(const ASource: TGameBase);
    destructor Destroy; override;
    function CheckTarget(const Target: TGameBase): Boolean; virtual;
  end;
  TRequestList = specialize TG2QuickListG<TRequest>;

  TBaseLink = class
  private
    type TLinkSide = class
      Other: TLinkSide;
      Base: TGameBase;
      Packets: TPacketList;
      constructor Create(const ABase: TGameBase);
      destructor Destroy; override;
    end;
    class var List: TBaseLink;
    var Prev: TBaseLink;
    var Next: TBaseLink;
    var _RenderHook: TG2Scene2DRenderHook;
  public
    var SideA: TLinkSide;
    var SideB: TLinkSide;
    var Connected: Integer;
    class constructor CreateClass;
    class procedure CheckLinks;
    class procedure ClearLinks;
    constructor Create(const NewBaseA, NewBaseB: TGameBase);
    destructor Destroy; override;
    procedure Update;
    procedure OnRender(const Display: TG2Display2D);
    function Compare(const OtherBaseA, OtherBaseB: TGameBase): Boolean;
    procedure TransferPacket(const Source: TGameBase; const Packet: TPacket);
    function CheckBase(const Base: TGameBase): Boolean;
  end;
  TBaseLinkList = specialize TG2QuickListG<TBaseLink>;

  TEntityProc = procedure (const Entity: TG2Scene2DEntity) of object;
  TEntityDetector = class (TG2Scene2DEntity)
  private
    var _RigidBody: TG2Scene2DComponentRigidBody;
    var _Shape: TG2Scene2DComponentCollisionShapeCircle;
    var _Filter: array of CG2Scene2DEntity;
    function GetRadius: TG2Float;
    procedure SetRadius(const Value: TG2Float);
  protected
    procedure OnEnable; override;
    procedure OnDisable; override;
  public
    var Detected: TG2Scene2DEntityList;
    property Radius: TG2Float read GetRadius write SetRadius;
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
    procedure SetFilter(const FilterTypes: array of CG2Scene2DEntity);
    procedure AddFilter(const FilterTypes: array of CG2Scene2DEntity);
    function CheckFilter(const Entity: TG2Scene2DEntity): Boolean;
    procedure Update;
  end;

  TPath = array of TGameBase;
  TPathCheck = function (const Base: TGameBase): Boolean of object;
  TGameBase = class (TGameObject)
  public
    type TGameBaseList = specialize TG2QuickListG<TGameBase>;
  private
    function PathSearchCmp(const a, b: TGameBase): Integer;
    class var _SearchID: Integer;
    var _PathSearchID: Integer;
    var _PathSearchDist: TG2Float;
    var _PathSearchList: TGameBaseList;
    var _PathSearchSrc: TGameBase;
    var _Detector: TEntityDetector;
    var _Built: Boolean;
    var _BuildTotal: Integer;
    var _BuildAmount: Integer;
    var _BuildTime: TG2Float;
    var _Requests: TRequestList;
  protected
    var _Color: TColorComponent;
    procedure SetBuildAmount(const Value: Integer);
    procedure CancelRequest(const Request: TRequest); virtual;
  public
    var Links: TBaseLinkList;
    property IsBuilt: Boolean read _Built;
    property BaseDetector: TEntityDetector read _Detector;
    class function MakeObject(const NewTransform: TG2Transform2): TGameBase; virtual; abstract;
    class function MakeBuildObject: TG2Scene2DEntity; virtual; abstract;
    class constructor CreateClass;
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
    procedure OnUpdate; virtual;
    procedure OnRender(const Display: TG2Display2D); override;
    function LinkDistance: TG2Float; virtual;
    procedure TransferPacket(const Packet: TPacket);
    procedure ReceivePacket(const Packet: TPacket); virtual;
    procedure SendRequest(const Request: TRequest);
    procedure ReceiveRequest(const Request: TRequest); virtual;
    function FindPath(const PathCheck: TPathCheck): TPath;
  end;

  TGameAsteroid = class (TGameObject)
  public
    class function MakeObject(const NewTransform: TG2Transform2): TGameAsteroid;
  end;

  TGameBaseMothership = class (TGameBase)
  private
    var _RequestQueue: TRequestList;
  public
    class function MakeObject(const NewTransform: TG2Transform2): TGameBase; override;
    class function MakeBuildObject: TG2Scene2DEntity; override;
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
    procedure OnUpdate; override;
    procedure ReceivePacket(const Packet: TPacket); override;
    procedure ReceiveRequest(const Request: TRequest); override;
  end;

  TGameBaseRelay = class (TGameBase)
  public
    class function MakeObject(const NewTransform: TG2Transform2): TGameBase; override;
    class function MakeBuildObject: TG2Scene2DEntity; override;
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
  end;

  TGameBaseCollector = class (TGameBase)
  private
    type TResource = class
      var Source: String;
      var Pos: TG2Vec2;
      var Time: TG2Float;
      var Dur: TG2Float;
    end;
    var _Resources: TG2QuickList;
    var _Collected: Integer;
  public
    class function MakeObject(const NewTransform: TG2Transform2): TGameBase; override;
    class function MakeBuildObject: TG2Scene2DEntity; override;
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
    procedure OnUpdate; override;
    procedure OnRender(const Display: TG2Display2D); override;
  end;

  TUIBuildPlacement = class (TUIWidget)
  private
    var _BuildClass: CGameBase;
    var _BuildObject: TG2Scene2DEntity;
    procedure SetBuildClass(const Value: CGameBase);
    function CheckOverlap: Boolean;
  public
    property BuildClass: CGameBase read _BuildClass write SetBuildClass;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnRender; override;
    procedure OnUpdate; override;
    procedure OnMouseDown(const Button, x, y: Integer); override;
    procedure OnEnter(const PrevState: TG2GameState); override;
    procedure OnLeave(const NextState: TG2GameState); override;
  end;

  TBackground = class (TG2Scene2DComponent)
  protected
    var Layers: array of TG2Scene2DEntity;
    procedure OnInitialize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnUpdate;
  public
  end;

  TGame = class
  public
    var Font1: TG2Font;
    var Scene: TG2Scene2D;
    var Display: TG2Display2D;
    var Background: TBackground;
    var TargetZoom: Single;
    var UIManager: TUIManager;
    var UIBuildPlacement: TUIBuildPlacement;
    var UIGameplay: TUIGameplay;
    var Player: TPlayer;
    var DebugDrawEnabled: Boolean;
    var MouseDrag: TG2Vec2;
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
    procedure MoveCamera;
    procedure BuildRelay;
    procedure BuildCollector;
  end;

var
  Game: TGame;

implementation

procedure TColorComponent.SetColor(const Value: TG2Color);
  var i: Integer;
begin
  if Assigned(Owner) then
  for i := 0 to Owner.ComponentCount - 1 do
  begin
    if Owner.Components[i] is TG2Scene2DComponentSprite then
    begin
      TG2Scene2DComponentSprite(Owner.Components[i]).Color := Value;
    end;
  end;
end;

constructor TPacketPower.Create(const Target: String);
begin
  inherited Create;
  _Target := Target;
end;

function TPacketPower.CheckTarget(const Target: TGameBase): Boolean;
begin
  Result := Target.GUID = _Target;
end;

function TPacketResource.CheckTarget(const Target: TGameBase): Boolean;
begin
  Result := Target is TGameBaseMothership;
end;

constructor TRequest.Create(const ASource: TGameBase);
begin
  _Source := ASource;
  _Packet := nil;
  _Source._Requests.Add(Self);
end;

destructor TRequest.Destroy;
begin
  if Assigned(_Source) then _Source._Requests.Remove(Self);
  if Assigned(_Packet) then _Packet.Request := nil;
  inherited Destroy;
end;

function TRequest.CheckTarget(const Target: TGameBase): Boolean;
begin
  Result := Target is TGameBaseMothership;
end;

function TPlayer.GetPowerRatio: TG2Float;
begin
  Result := _Power / _PowerMax;
end;

constructor TPlayer.Create;
begin
  _Power := 0;
  _PowerMax := 30;
  _ChargeTime := 0;
  g2.CallbackUpdateAdd(@Update);
end;

destructor TPlayer.Destroy;
begin
  g2.CallbackUpdateRemove(@Update);
  inherited Destroy;
end;

procedure TPlayer.Update;
begin
  _ChargeTime += g2.DeltaTimeSec;
  if _ChargeTime >= 3 then
  begin
    Charge;
    _ChargeTime := 0;
  end;
end;

procedure TPlayer.Charge;
begin
  if _Power < _PowerMax then Inc(_Power);
end;

function TPlayer.Drain(const Amount: Integer): Boolean;
begin
  if _Power >= Amount then
  begin
    Result := True;
    _Power -= Amount;
    Exit;
  end;
  Result := False;
end;

constructor TBaseLink.TLinkSide.Create(const ABase: TGameBase);
begin
  Base := ABase;
  Packets.Clear;
end;

destructor TBaseLink.TLinkSide.Destroy;
begin
  while Packets.Count > 0 do Packets.Pop.Free;
  inherited Destroy;
end;

constructor TPacket.Create;
begin
  _Time := 0;
  _Request := nil;
end;

destructor TPacket.Destroy;
begin
  if Assigned(_Request) then _Request.Free;
  inherited Destroy;
end;

function TPacket.CheckTarget(const Target: TGameBase): Boolean;
begin
  Result := False;
end;

procedure TEntityDetector.OnEnable;
begin
  inherited OnEnable;
  if Assigned(_RigidBody) then _RigidBody.Enabled := True;
end;

procedure TEntityDetector.OnDisable;
begin
  inherited OnDisable;
  if Assigned(_RigidBody) then _RigidBody.Enabled := False;
end;

procedure TEntityDetector.Update;
  var i: Integer;
  var contact: pb2_contact_edge;
  var Obj: TObject;
  var Entity: TG2Scene2DEntity;
  var f: pb2_fixture;
begin
  Detected.Clear;
  if not _Enabled then Exit;
  if Assigned(_Shape.PhysFixture)
  and Assigned(_Shape.PhysFixture^.get_body)then
  begin
    contact := _Shape.PhysFixture^.get_body^.get_contact_list;
    while Assigned(contact) do
    begin
      if contact^.contact^.is_touching then
      begin
        if contact^.contact^.get_fixture_a = _Shape.PhysFixture then
        begin
          f := contact^.contact^.get_fixture_b;
        end
        else
        begin
          f := contact^.contact^.get_fixture_a;
        end;
        if not f^.is_sensor then
        begin
          Obj := TObject(contact^.other^.get_user_data);
          if Obj is TG2Scene2DComponentRigidBody then
          begin
            Entity := TG2Scene2DComponentRigidBody(Obj).Owner;
            if (Entity <> Self)
            and (not Assigned(Self.Parent) or (Entity <> Self.Parent))
            and (CheckFilter(TGameBase(Entity))) then
            begin
              Detected.Add(Entity);
            end;
          end;
        end;
      end;
      contact := contact^.next;
    end;
  end;
end;

function TEntityDetector.GetRadius: TG2Float;
begin
  Result := _Shape.Radius;
end;

procedure TEntityDetector.SetRadius(const Value: TG2Float);
begin
  if Abs(_Shape.Radius - Value) > G2EPS3 then
  begin
    _Shape.Radius := Value;
  end;
end;

constructor TEntityDetector.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create(OwnerScene);
  _Enabled := False;
  _RigidBody := TG2Scene2DComponentRigidBody.Create(Scene);
  _RigidBody.Attach(Self);
  _RigidBody.BodyType := g2_s2d_rbt_dynamic_body;
  _RigidBody.GravityScale := 0;
  _Shape := TG2Scene2DComponentCollisionShapeCircle.Create(Scene);
  _Shape.Attach(Self);
  _Shape.Radius := 1;
  _Shape.IsSensor := True;
  Detected.Clear;
end;

destructor TEntityDetector.Destroy;
begin
  inherited Destroy;
end;

procedure TEntityDetector.SetFilter(const FilterTypes: array of CG2Scene2DEntity);
  var i: Integer;
begin
  SetLength(_Filter, Length(FilterTypes));
  for i := 0 to High(FilterTypes) do
  begin
    _Filter[i] := FilterTypes[i];
  end;
end;

procedure TEntityDetector.AddFilter(const FilterTypes: array of CG2Scene2DEntity);
  var i, n: Integer;
begin
  n := Length(_Filter);
  SetLength(_Filter, n + Length(FilterTypes));
  for i := 0 to High(FilterTypes) do
  begin
    _Filter[n + i] := FilterTypes[i];
  end;
end;

function TEntityDetector.CheckFilter(const Entity: TG2Scene2DEntity): Boolean;
  var i: Integer;
begin
  for i := 0 to High(_Filter) do
  if Entity is _Filter[i] then
  begin
    Result := True;
    Exit;
  end;
  Result := False;
end;

constructor TGameObject.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create(OwnerScene);
  _ActionMenu := nil;
end;

class constructor TBaseLink.CreateClass;
begin
  List := nil;
end;

class procedure TBaseLink.CheckLinks;
  var Iter, Link: TBaseLink;
begin
  Iter := List;
  while Assigned(Iter) do
  begin
    Link := Iter;
    Iter := Iter.Next;
    if Link.Connected <= 0 then Link.Free else Link.Connected := 0;
  end;
end;

class procedure TBaseLink.ClearLinks;
begin
  while List <> nil do List.Free;
end;

constructor TBaseLink.Create(const NewBaseA, NewBaseB: TGameBase);
begin
  Prev := nil;
  Next := List;
  if List <> nil then List.Prev := Self;
  List := Self;
  Connected := 1;
  SideA := TLinkSide.Create(NewBaseA);
  SideB := TLinkSide.Create(NewBaseB);
  SideA.Other := SideB;
  SideB.Other := SideA;
  SideA.Base.Links.Add(Self);
  SideB.Base.Links.Add(Self);
  _RenderHook := Game.Scene.RenderHookAdd(@OnRender, -1);
  g2.CallbackUpdateAdd(@Update);
end;

destructor TBaseLink.Destroy;
begin
  g2.CallbackUpdateRemove(@Update);
  Game.Scene.RenderHookRemove(_RenderHook);
  SideA.Base.Links.Remove(Self);
  SideB.Base.Links.Remove(Self);
  SideA.Free;
  SideB.Free;
  if Prev <> nil then Prev.Next := Next;
  if Next <> nil then Next.Prev := Prev;
  if List = Self then List := Next;
  inherited Destroy;
end;

procedure TBaseLink.Update;
  var len: TG2Float;
  procedure UpdateSide(const Side: TLinkSide);
    var i: Integer;
  begin
    for i := Side.Packets.Count - 1 downto 0 do
    begin
      Side.Packets[i].Time := Side.Packets[i].Time + g2.DeltaTimeSec;
      if Side.Packets[i].Time >= len then
      begin
        if Side.Packets[i].CheckTarget(Side.Other.Base) then
        begin
          Side.Other.Base.ReceivePacket(Side.Packets[i]);
        end
        else
        begin
          Side.Other.Base.TransferPacket(Side.Packets[i]);
        end;
        Side.Packets.Delete(i);
      end;
    end;
  end;
begin
  len := (SideA.Base.Position - SideB.Base.Position).Len;
  UpdateSide(SideA);
  UpdateSide(SideB);
end;

procedure TBaseLink.OnRender(const Display: TG2Display2D);
  var len: TG2Float;
  procedure RenderSide(const Side: TLinkSide);
    var i: Integer;
    var t: TG2Float;
    var p: TG2Vec2;
  begin
    for i := 0 to Side.Packets.Count - 1 do
    begin
      t := Side.Packets[i].Time / len;
      p := G2LerpVec2(Side.Base.Position, Side.Other.Base.Position, t);
      Display.PrimCircleCol(p, 0.1, $ffffffff, $00ffffff);
    end;
  end;
  var p0, p1, n0, n1: TG2Vec2;
  var c0, c1: TG2Color;
begin
  p0 := SideA.Base.Position;
  p1 := SideB.Base.Position;
  if (p1 - p0).LenSq < G2EPS3 then Exit;
  n0 := (p1 - p0).Norm * 0.05;
  n1 := n0.Perp;
  c0 := $80ffffff;
  c1 := $00ffffff;
  Display.PrimBegin(ptTriangles, bmNormal);
  Display.PrimAdd(p0, c1); Display.PrimAdd(p0 + n0, c0); Display.PrimAdd(p0 + n0 + n1, c1);
  Display.PrimAdd(p0, c1); Display.PrimAdd(p0 + n0, c0); Display.PrimAdd(p0 + n0 - n1, c1);
  Display.PrimAdd(p0 + n0, c0); Display.PrimAdd(p0 + n0 + n1, c1); Display.PrimAdd(p1 - n0, c0);
  Display.PrimAdd(p0 + n0 + n1, c1); Display.PrimAdd(p1 - n0, c0); Display.PrimAdd(p1 - n0 + n1, c1);
  Display.PrimAdd(p0 + n0, c0); Display.PrimAdd(p0 + n0 - n1, c1); Display.PrimAdd(p1 - n0, c0);
  Display.PrimAdd(p0 + n0 - n1, c1); Display.PrimAdd(p1 - n0, c0); Display.PrimAdd(p1 - n0 - n1, c1);
  Display.PrimAdd(p1, c1); Display.PrimAdd(p1 - n0, c0); Display.PrimAdd(p1 - n0 + n1, c1);
  Display.PrimAdd(p1, c1); Display.PrimAdd(p1 - n0, c0); Display.PrimAdd(p1 - n0 - n1, c1);
  Display.PrimEnd;
  len := (SideA.Base.Position - SideB.Base.Position).Len;
  RenderSide(SideA);
  RenderSide(SideB);
end;

function TBaseLink.Compare(const OtherBaseA, OtherBaseB: TGameBase): Boolean;
begin
  Result := (
    ((SideA.Base = OtherBaseA) and (SideB.Base = OtherBaseB))
    or ((SideA.Base = OtherBaseB) and (SideB.Base = OtherBaseA))
  );
end;

procedure TBaseLink.TransferPacket(const Source: TGameBase; const Packet: TPacket);
begin
  Packet.Time := 0;
  if SideA.Base = Source then SideA.Packets.Add(Packet)
  else if SideB.Base = Source then SideB.Packets.Add(Packet)
  else Packet.Free;
end;

function TBaseLink.CheckBase(const Base: TGameBase): Boolean;
begin
  Result := (SideA.Base = Base) or (SideB.Base = Base);
end;

function TGameBase.PathSearchCmp(const a, b: TGameBase): Integer;
begin
  Result := Integer(a._PathSearchDist < b._PathSearchDist);
end;

procedure TGameBase.SetBuildAmount(const Value: Integer);
begin
  _BuildTotal := Value;
  _BuildAmount := _BuildTotal;
end;

procedure TGameBase.CancelRequest(const Request: TRequest);
begin
  _Requests.Remove(Request);
end;

class constructor TGameBase.CreateClass;
begin
  _SearchID := 0;
end;

constructor TGameBase.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create(OwnerScene);
  _Color := TColorComponent.Create(Scene);
  _Color.Attach(Self);
  g2.CallbackUpdateAdd(@OnUpdate);
  _Detector := TEntityDetector.Create(Scene);
  _Detector.Parent := Self;
  _Detector.SetFilter([TGameBaseMothership, TGameBaseRelay]);
  _Detector.Radius := LinkDistance;
  _PathSearchID := 0;
  _Built := False;
  _BuildTime := 0;
  _Requests.Clear;
  SetBuildAmount(5);
end;

destructor TGameBase.Destroy;
begin
  while Links.Count > 0 do Links.Pop.Free;
  g2.CallbackUpdateRemove(@OnUpdate);
  inherited Destroy;
end;

procedure TGameBase.OnUpdate;
  var NewLink: Boolean;
  var Entity: TG2Scene2DEntity;
  var i, j: Integer;
begin
  if not _Built then
  begin
    _BuildTime += g2.DeltaTimeSec;
    if _BuildTime > 2 then
    begin
      if (_BuildAmount - _Requests.Count > 0) then
      begin
        SendRequest(TRequest.Create(Self));
      end;
      _BuildTime := 0;
    end;
    _Color.SetColor($80ffffff);
  end
  else
  begin
    _Color.SetColor($ffffffff);
  end;
  _Detector.Radius := LinkDistance;
  if Assigned(ActionMenu) then ActionMenu.Position := Position;
  _Detector.Update;
  for j := 0 to _Detector.Detected.Count - 1 do
  begin
    Entity := _Detector.Detected[j];
    if Entity is TGameBase then
    begin
      NewLink := True;
      for i := 0 to Links.Count - 1 do
      if Links[i].Compare(Self, TGameBase(Entity)) then
      begin
        Links[i].Connected += 1;
        NewLink := False;
      end;
      if NewLink then
      begin
        TBaseLink.Create(Self, TGameBase(Entity));
      end;
    end;
  end;
end;

procedure TGameBase.OnRender(const Display: TG2Display2D);
  procedure AddQuad(const v0, v1, v2, v3: TG2Vec2; const c0, c1: TG2Color);
  begin
    Display.PrimAdd(v0, c0);
    Display.PrimAdd(v1, c0);
    Display.PrimAdd(v2, c1);
    Display.PrimAdd(v2, c1);
    Display.PrimAdd(v1, c0);
    Display.PrimAdd(v3, c1);
  end;
  var p, v0, v1: TG2Vec2;
  var r: TG2Rotation2;
  var t: TG2Float;
  var s, i: Integer;
  var c0, c1: TG2Color;
  const d0 = 0.25;
  const d1 = 0.03;
begin
  inherited OnRender(Display);
  if not _Built then
  begin
    c0 := $cc0044ff;
    c1 := $000044ff;
    p := Position;
    t := 1 - (_BuildAmount / _BuildTotal);
    s := Round(t * 32);
    if s < 1 then s := 1;
    r := G2Rotation2(t * G2TwoPi / s);
    v0 := G2Vec2(0, -1);
    Display.PrimBegin(ptTriangles, bmNormal);
    for i := 0 to s - 1 do
    begin
      v1 := r.Transform(v0);
      AddQuad(
        p + v0 * d0 + v0 * d1, p + v1 * d0 + v1 * d1,
        p + v0 * d0, p + v1 * d0,
        c1, c0
      );
      AddQuad(
        p + v0 * d0, p + v1 * d0,
        p + v0 * d0 - v0 * d1, p + v1 * d0 - v1 * d1,
        c0, c1
      );
      v0 := v1;
    end;
    Display.PrimEnd;
  end;
end;

function TGameBase.LinkDistance: TG2Float;
begin
  Result := 3;
end;

procedure TGameBase.TransferPacket(const Packet: TPacket);
  var Path: TPath;
  var b: TGameBase;
  var i: Integer;
begin
  Path := FindPath(@Packet.CheckTarget);
  if Length(Path) > 0 then
  begin
    b := Path[0];
    for i := 0 to Links.Count - 1 do
    begin
      if Links[i].CheckBase(b) then
      begin
        Links[i].TransferPacket(Self, Packet);
        Exit;
      end;
    end;
  end;
  Packet.Free;
end;

procedure TGameBase.ReceivePacket(const Packet: TPacket);
begin
  if Packet is TPacketPower then
  begin
    if not _Built then
    begin
      Dec(_BuildAmount);
      if _BuildAmount <= 0 then _Built := True;
    end;
  end;
  Packet.Free;
end;

procedure TGameBase.SendRequest(const Request: TRequest);
  var Path: TPath;
begin
  Path := FindPath(@Request.CheckTarget);
  if Length(Path) > 0 then
  begin
    if Request.CheckTarget(Path[High(Path)]) then
    begin
      Path[High(Path)].ReceiveRequest(Request);
      Exit;
    end;
  end;
  Request.Free;
end;

procedure TGameBase.ReceiveRequest(const Request: TRequest);
begin
  Request.Free;
end;

function TGameBase.FindPath(const PathCheck: TPathCheck): TPath;
  var b, bo: TGameBase;
  var d: TG2Float;
  var i: Integer;
begin
  Inc(_SearchID);
  _PathSearchList.Clear;
  _PathSearchID := _SearchID;
  _PathSearchDist := 0;
  _PathSearchSrc := nil;
  _PathSearchList.Add(Self);
  while _PathSearchList.Count > 0 do
  begin
    b := _PathSearchList.Pop;
    if PathCheck(b) then
    begin
      i := 0;
      bo := b;
      while bo <> Self do
      begin
        Inc(i);
        bo := bo._PathSearchSrc;
      end;
      SetLength(Result, i);
      while b <> Self do
      begin
        Dec(i);
        Result[i] := b;
        b := b._PathSearchSrc;
      end;
      Exit;
    end
    else
    if (b = Self) or b.IsBuilt then
    begin
      for i := 0 to b.Links.Count - 1 do
      begin
        if b.Links[i].SideA.Base <> b then bo := b.Links[i].SideA.Base
        else bo := b.Links[i].SideB.Base;
        d := b._PathSearchDist + (b.Position - bo.Position).Len;
        if (bo._PathSearchID < _SearchID) then// or (d < bo._PathSearchDist) then
        begin
          bo._PathSearchDist := d;
          bo._PathSearchID := _SearchID;
          bo._PathSearchSrc := b;
          _PathSearchList.Add(bo);
        end;
      end;
      _PathSearchList.Sort(@PathSearchCmp);
    end;
  end;
end;

class function TGameAsteroid.MakeObject(const NewTransform: TG2Transform2): TGameAsteroid;
  var rb: TG2Scene2DComponentRigidBody;
begin
  Result := TGameAsteroid(Game.Scene.CreatePrefab('asteroid.g2prefab2d', NewTransform, TGameAsteroid));
  rb := TG2Scene2DComponentRigidBody(Result.ComponentOfType[TG2Scene2DComponentRigidBody]);
  if Assigned(rb) then rb.Enabled := True;
end;

class function TGameBaseRelay.MakeObject(const NewTransform: TG2Transform2): TGameBase;
  var rb: TG2Scene2DComponentRigidBody;
begin
  Result := TGameBase(Game.Scene.CreatePrefab('relay.g2prefab2d', NewTransform, TGameBaseRelay));
  rb := TG2Scene2DComponentRigidBody(Result.ComponentOfType[TG2Scene2DComponentRigidBody]);
  if Assigned(rb) then rb.Enabled := True;
  Result.BaseDetector.Enabled := True;
end;

class function TGameBaseRelay.MakeBuildObject: TG2Scene2DEntity;
begin
  Result := Game.Scene.CreatePrefab('relay.g2prefab2d', G2Transform2);
end;

constructor TGameBaseRelay.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create(OwnerScene);
  ActionMenu := TUIActionMenu.Create;
  ActionMenu.AddButton('button_delete', @Free);
end;

destructor TGameBaseRelay.Destroy;
begin
  ActionMenu.Free;
  inherited Destroy;
end;

class function TGameBaseCollector.MakeObject(const NewTransform: TG2Transform2): TGameBase;
  var rb: TG2Scene2DComponentRigidBody;
begin
  Result := TGameBase(Game.Scene.CreatePrefab('collector.g2prefab2d', NewTransform, TGameBaseCollector));
  rb := TG2Scene2DComponentRigidBody(Result.ComponentOfType[TG2Scene2DComponentRigidBody]);
  if Assigned(rb) then rb.Enabled := True;
  Result.BaseDetector.Enabled := True;
end;

class function TGameBaseCollector.MakeBuildObject: TG2Scene2DEntity;
begin
  Result := Game.Scene.CreatePrefab('collector.g2prefab2d', G2Transform2);
end;

constructor TGameBaseCollector.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create(OwnerScene);
  ActionMenu := TUIActionMenu.Create;
  ActionMenu.AddButton('button_delete', @Free);
  _Detector.AddFilter([TGameAsteroid]);
  _Resources.Clear;
  _Collected := 0;
end;

destructor TGameBaseCollector.Destroy;
begin
  while _Resources.Count > 0 do TResource(_Resources.Pop).Free;
  ActionMenu.Free;
  inherited Destroy;
end;

procedure TGameBaseCollector.OnUpdate;
  var i, j: Integer;
  var r: TResource;
  var b: Boolean;
begin
  inherited OnUpdate;
  if not IsBuilt then Exit;
  if _Collected + _Resources.Count < 5 then
  begin
    for i := 0 to _Detector.Detected.Count - 1 do
    if _Detector.Detected[i] is TGameAsteroid then
    begin
      b := True;
      for j := 0 to _Resources.Count - 1 do
      if TResource(_Resources[j]).Source = _Detector.Detected[i].GUID then
      begin
        b := False;
        Break;
      end;
      if b then
      begin
        r := TResource.Create;
        r.Source := _Detector.Detected[i].GUID;
        r.Pos := _Detector.Detected[i].Position;
        r.Time := 0;
        r.Dur := (r.Pos - Position).Len;
        _Resources.Add(r);
      end;
    end;
  end;
  for i := _Resources.Count - 1 downto 0 do
  begin
    r := TResource(_Resources[i]);
    r.Time += g2.DeltaTimeSec;
    if r.Time >= r.Dur then
    begin
      r.Free;
      _Resources.Delete(i);
      Inc(_Collected);
    end;
  end;
  if _Collected > 0 then
  begin
    TransferPacket(TPacketResource.Create);
    Dec(_Collected);
  end;
end;

procedure TGameBaseCollector.OnRender(const Display: TG2Display2D);
  var i: Integer;
  var p: TG2Vec2;
  var r: TResource;
begin
  inherited OnRender(Display);
  for i := 0 to _Resources.Count - 1 do
  begin
    r := TResource(_Resources[i]);
    p := G2LerpVec2(r.Pos, Position, r.Time / r.Dur);
    Display.PrimCircleCol(p, 0.1, $ffffffff, $00ffffff);
  end;
end;

procedure TUIBuildPlacement.SetBuildClass(const Value: CGameBase);
  var i: Integer;
  var c: TG2Scene2DComponentCollisionShape;
  var rb: TG2Scene2DComponentRigidBody;
begin
  _BuildClass := Value;
  if Assigned(_BuildObject) then
  begin
    _BuildObject.Free;
    _BuildObject := nil;
  end;
  if Assigned(_BuildClass) then
  begin
    _BuildObject := _BuildClass.MakeBuildObject;
    _BuildObject.StripComponents([
      TG2Scene2DComponentSprite,
      TG2Scene2DComponentRigidBody,
      TG2Scene2DComponentCollisionShape
    ]);
    rb := TG2Scene2DComponentRigidBody(_BuildObject.ComponentOfType[TG2Scene2DComponentRigidBody]);
    if Assigned(rb) then
    begin
      rb.BodyType := g2_s2d_rbt_dynamic_body;
      rb.GravityScale := 0;
    end;
    for i := 0 to _BuildObject.ComponentCount - 1 do
    if _BuildObject.Components[i] is TG2Scene2DComponentCollisionShape then
    begin
      c := TG2Scene2DComponentCollisionShape(_BuildObject.Components[i]);
      c.IsSensor := True;
    end;
  end;
end;

function TUIBuildPlacement.CheckOverlap: Boolean;
  var i: Integer;
  var c: TG2Scene2DComponentCollisionShape;
  var contact: pb2_contact_edge;
  var other_fixture: pb2_fixture;
begin
  if Assigned(_BuildObject) then
  for i := 0 to _BuildObject.ComponentCount - 1 do
  if _BuildObject.Components[i] is TG2Scene2DComponentCollisionShape then
  begin
    c := TG2Scene2DComponentCollisionShape(_BuildObject.Components[i]);
    if Assigned(c.PhysFixture)
    and Assigned(c.PhysFixture^.get_body) then
    begin
      contact := c.PhysFixture^.get_body^.get_contact_list;
      while Assigned(contact) do
      begin
        if contact^.contact^.get_fixture_a = c.PhysFixture then
        begin
          other_fixture := contact^.contact^.get_fixture_b;
        end
        else
        begin
          other_fixture := contact^.contact^.get_fixture_a;
        end;
        if contact^.contact^.is_touching
        and not other_fixture^.is_sensor then
        begin
          Result := True;
          Exit;
        end;
        contact := contact^.next;
      end;
    end;
  end;
  Result := False;
end;

procedure TUIBuildPlacement.OnInitialize;
begin
  inherited OnInitialize;
  RenderOrder := 1000;
  _BuildClass := nil;
  _BuildObject := nil;
end;

procedure TUIBuildPlacement.OnFinalize;
begin
  inherited OnFinalize;
end;

procedure TUIBuildPlacement.OnRender;
begin
  inherited OnRender;
  if not Assigned(_BuildObject) then Exit;
end;

procedure TUIBuildPlacement.OnUpdate;
  var i: Integer;
  var IsOvelapped: Boolean;
  var rb: TG2Scene2DComponentRigidBody;
begin
  inherited OnUpdate;
  if not Assigned(_BuildObject) then Exit;
  _BuildObject.Position := Game.Display.CoordToDisplay(g2.MousePos);
  rb := TG2Scene2DComponentRigidBody(_BuildObject.ComponentOfType[TG2Scene2DComponentRigidBody]);
  if Assigned(rb) then
  begin
    rb.Enabled := True;
    rb.UpdateFromOwner;
  end;
  IsOvelapped := CheckOverlap;
  for i := 0 to _BuildObject.ComponentCount - 1 do
  begin
    if _BuildObject.Components[i] is TG2Scene2DComponentSprite then
    begin
      TG2Scene2DComponentSprite(_BuildObject.Components[i]).Visible := not IsOvelapped;
    end;
  end;
end;

procedure TUIBuildPlacement.OnMouseDown(const Button, x, y: Integer);
begin
  inherited OnMouseDown(Button, x, y);
  case Button of
    G2MB_Left:
    begin
      if not CheckOverlap then
      begin
        if Assigned(BuildClass) then
        begin
          BuildClass.MakeObject(G2Transform2(Game.Display.CoordToDisplay(G2Vec2(x, y)), G2Rotation2));
        end;
        Game.UIManager.Widget := Game.UIGameplay;
      end;
    end;
    G2MB_Right:
    begin
      Game.UIManager.Widget := Game.UIGameplay;
    end;
  end;
end;

procedure TUIBuildPlacement.OnEnter(const PrevState: TG2GameState);
begin
  inherited OnEnter(PrevState);
end;

procedure TUIBuildPlacement.OnLeave(const NextState: TG2GameState);
begin
  inherited OnLeave(NextState);
  BuildClass := nil;
end;

class function TGameBaseMothership.MakeObject(const NewTransform: TG2Transform2): TGameBase;
  var rb: TG2Scene2DComponentRigidBody;
begin
  Result := TGameBase(Game.Scene.CreatePrefab('base0.g2prefab2d', NewTransform, TGameBaseMothership));
  rb := TG2Scene2DComponentRigidBody(Result.ComponentOfType[TG2Scene2DComponentRigidBody]);
  if Assigned(rb) then rb.Enabled := True;
  Result.BaseDetector.Enabled := True;
end;

class function TGameBaseMothership.MakeBuildObject: TG2Scene2DEntity;
begin
  Result := Game.Scene.CreatePrefab('base0.g2prefab2d', G2Transform2);
end;

constructor TGameBaseMothership.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create(OwnerScene);
  _Built := True;
  _RequestQueue.Clear;
  ActionMenu := TUIActionMenu.Create;
  ActionMenu.AddButton('button_relay', @Game.BuildRelay);
  ActionMenu.AddButton('button_collector', @Game.BuildCollector);
end;

destructor TGameBaseMothership.Destroy;
begin
  while _RequestQueue.Count > 0 do _RequestQueue.Pop.Free;
  ActionMenu.Free;
  inherited Destroy;
end;

procedure TGameBaseMothership.OnUpdate;
  var p: TPacketPower;
  var r: TRequest;
begin
  inherited OnUpdate;
  if _RequestQueue.Count > 0 then
  begin
    if Game.Player.Drain(1) then
    begin
      r := _RequestQueue[0];
      _RequestQueue.Delete(0);
      p := TPacketPower.Create(r.Source.GUID);
      p.Request := r;
      TransferPacket(p);
    end;
  end;
end;

procedure TGameBaseMothership.ReceivePacket(const Packet: TPacket);
begin
  inherited ReceivePacket(Packet);
  Game.Player.Charge;
end;

procedure TGameBaseMothership.ReceiveRequest(const Request: TRequest);
begin
  _RequestQueue.Add(Request);
end;

function TUIActionMenu.AddButton(const FrameName: String;
  const OnClick: TG2ProcObj): TButton;
begin
  Result := TButton.Create;
  SetLength(Buttons, Length(Buttons) + 1);
  Result.FrameN := Atlas.FindFrame(FrameName + '_n.png');
  Result.FrameH := Atlas.FindFrame(FrameName + '_h.png');
  Result.OnClick := OnClick;
  Result.Enabled := True;
  Buttons[High(Buttons)] := Result;
end;

procedure TUIActionMenu.OnInitialize;
begin
  inherited OnInitialize;
  RenderOrder := 10;
  Position := G2Vec2;
end;

procedure TUIActionMenu.OnFinalize;
  var i: Integer;
begin
  for i := 0 to High(Buttons) do
  begin
    Buttons[i].Free;
  end;
  inherited OnFinalize;
end;

procedure TUIActionMenu.OnRender;
  var i, n: Integer;
  var v, p: TG2Vec2;
  var r: TG2Rotation2;
  var Frame: TG2AtlasFrame;
begin
  inherited OnRender;
  n := 0;
  for i := 0 to High(Buttons) do
  if Buttons[i].Enabled then
  begin
    Inc(n);
  end;
  r := G2Rotation2(G2TwoPi / n);
  v := G2Vec2(0, -50);
  p := Game.Display.CoordToScreen(Position);
  for i := 0 to n - 1 do
  if Buttons[i].Enabled then
  begin
    if ((p + v) - g2.MousePos).Len < 30 then
    begin
      Frame := Buttons[i].FrameH;
    end
    else
    begin
      Frame := Buttons[i].FrameN;
    end;
    g2.PicRect(
      p.x + v.x - 32,
      p.y + v.y - 32,
      64, 64,
      Frame.TexCoords.l,
      Frame.TexCoords.t,
      Frame.TexCoords.r,
      Frame.TexCoords.b,
      $ffffffff,
      Frame.Texture
    );
    v := r.Transform(v);
  end;
end;

procedure TUIActionMenu.OnMouseDown(const Button, x, y: Integer);
  var i, n: Integer;
  var r: TG2Rotation2;
  var p, v: TG2Vec2;
begin
  inherited OnMouseDown(Button, x, y);
  case Button of
    G2MB_Left:
    begin
      Game.UIManager.Widget := Game.UIGameplay;
      n := 0;
      for i := 0 to High(Buttons) do
      if Buttons[i].Enabled then
      begin
        Inc(n);
      end;
      r := G2Rotation2(G2TwoPi / n);
      v := G2Vec2(0, -50);
      p := Game.Display.CoordToScreen(Position);
      for i := 0 to n - 1 do
      begin
        if Buttons[i].Enabled
        and (((p + v) - G2Vec2(x, y)).Len < 30) then
        begin
          if Assigned(Buttons[i].OnClick) then Buttons[i].OnClick;
          Break;
        end;
        v := r.Transform(v);
      end;
    end;
    G2MB_Right:
    begin
      Game.UIManager.Widget := Game.UIGameplay;
    end;
  end;
end;

procedure TUIGameplay.OnInitialize;
begin
  inherited OnInitialize;
  RenderOrder := 100;
  FramePower := Atlas.FindFrame('power.png');
end;

procedure TUIGameplay.OnMouseDown(const Button, x, y: Integer);
  var p: TG2Vec2;
  var i: Integer;
begin
  inherited OnMouseDown(Button, x, y);
  case Button of
    G2MB_Left:
    begin
      _QueryList.Clear;
      p := Game.Display.CoordToDisplay(G2Vec2(x, y));
      Game.Scene.QueryPoint(p, _QueryList);
      for i := 0 to _QueryList.Count - 1 do
      if (_QueryList[i] is TGameBase)
      and Assigned(TGameBase(_QueryList[i]).ActionMenu) then
      begin
        Game.UIManager.Widget := TGameBase(_QueryList[i]).ActionMenu;
        Break;
      end;
    end;
  end;
end;

procedure TUIGameplay.OnRender;
  var r: TG2Rect;
begin
  inherited OnRender;
  g2.PicRect(
    0, g2.Params.Height - 64, 64, 64,
    FramePower.TexCoords.l,
    FramePower.TexCoords.t,
    FramePower.TexCoords.r,
    FramePower.TexCoords.b,
    $ffffff00, FramePower.Texture
  );
  r := G2Rect(68, g2.Params.Height - 40, 200, 20);
  g2.PrimRect(r.l, r.t, r.w, r.h, $ff808080);
  r := r.Expand(-2, -2);
  r.w := r.w * (Game.Player.PowerRatio);
  g2.PrimRect(r.l, r.t, r.w, r.h, $ff00cc00);
end;

function TUIWidget.GetWidget: TUIWidget;
begin
  Result := TUIWidget(State);
end;

procedure TUIWidget.SetWidget(const Value: TUIWidget);
begin
  State := Value;
end;

procedure TUIManager.OnInitialize;
begin
  inherited OnInitialize;
  Atlas := TG2Atlas.SharedAsset('ui.g2atlas');
  Atlas.RefInc;
end;

procedure TUIManager.OnFinalize;
begin
  Atlas.RefDec;
  Atlas := nil;
  inherited OnFinalize;
end;

procedure TBackground.OnInitialize;
  var bg: TG2Scene2DEntity;
begin
  bg := Scene.FindEntityByName('Background');
  if Assigned(bg) then
  begin
    Attach(bg);
  end;
end;

procedure TBackground.OnAttach;
  var n: Integer;
  var e: TG2Scene2DEntity;
begin
  inherited OnAttach;
  n := 1;
  repeat
    e := Owner.FindChildByName('Background' + IntToStr(n));
    if Assigned(e) then
    begin
      SetLength(Layers, Length(Layers) + 1);
      Layers[High(Layers)] := e;
      Inc(n);
    end;
  until e = nil;
  g2.CallbackUpdateAdd(@OnUpdate);
end;

procedure TBackground.OnDetach;
begin
  inherited OnDetach;
  g2.CallbackUpdateRemove(@OnUpdate);
end;

procedure TBackground.OnUpdate;
  var i: Integer;
begin
  for i := 0 to High(Layers) do
  begin
    Layers[i].Position := Game.Display.Position * (1 / (0.5 + (i + 1) * 0.5));
  end;
end;

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
  g2.Params.Width := 1000;
  g2.Params.Height := 600;
  g2.Params.ScreenMode := smWindow;
  DebugDrawEnabled := False;
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
  Font1 := TG2Font.Create;
  Font1.Load('font1.g2f');
  Scene := TG2Scene2D.Create;
  Display := TG2Display2D.Create;
  UIManager := TUIManager.Create;
  UIBuildPlacement := TUIBuildPlacement.Create;
  UIGameplay := TUIGameplay.Create;
  Display.Width := 10;
  Display.Height := 10;
  Scene.Load('scene.g2s2d');
  Background := TBackground.Create(Scene);
  if not Assigned(Background.Owner) then
  begin
    Background.Free;
    Background := nil;
  end;
  Scene.Simulate := True;
  Scene.Gravity := G2Vec2;
  Player := TPlayer.Create;
  TGameBaseMothership.MakeObject(G2Transform2);
  TGameAsteroid.MakeObject(G2Transform2(G2Vec2(1, 1), G2Rotation2));
  TargetZoom := Display.Zoom;
  Display.Position := G2Vec2;
  UIManager.Widget := UIGameplay;
end;

procedure TGame.Finalize;
begin
  Player.Free;
  UIGameplay.Free;
  UIBuildPlacement.Free;
  UIManager.Free;
  Display.Free;
  Scene.Free;
  Font1.Free;
  Free;
end;

procedure TGame.Update;
begin
  TBaseLink.CheckLinks;
  Display.Zoom := G2LerpFloat(Display.Zoom, TargetZoom, 0.2);
  MoveCamera;
end;

procedure TGame.Render;
begin
  Scene.Render(Display);
  if DebugDrawEnabled then Scene.DebugDraw(Display);
  Font1.Print(10, 10, 'FPS: ' + IntToStr(g2.FPS));
end;

procedure TGame.KeyDown(const Key: Integer);
begin
  case Key of
    G2K_G: DebugDrawEnabled := not DebugDrawEnabled;
  end;
end;

procedure TGame.KeyUp(const Key: Integer);
begin

end;

procedure TGame.MouseDown(const Button, x, y: Integer);
begin
  case Button of
    G2MB_Middle:
    begin
      MouseDrag := Display.CoordToDisplay(G2Vec2(x, y));
    end;
  end;
end;

procedure TGame.MouseUp(const Button, x, y: Integer);
begin

end;

procedure TGame.Scroll(const y: Integer);
begin
  if (y < 0) and (TargetZoom > 0.5) then
  begin
    TargetZoom *= (1 / 1.1);
  end;
  if (y > 0) and (TargetZoom < 3) then
  begin
    TargetZoom *= 1.1;
  end;
end;

procedure TGame.Print(const c: AnsiChar);
begin

end;

procedure TGame.MoveCamera;
  var Pos: TG2Vec2;
  var MoveDir: TG2Vec2;
begin
  Pos := Display.Position;
  if g2.MouseDown[G2MB_Middle] then
  begin
    MoveDir := Display.CoordToDisplay(G2Vec2(g2.MousePos)) - MouseDrag;
    Pos := Pos - MoveDir;
  end
  else
  begin
    MoveDir := G2Vec2;
    if g2.KeyDown[G2K_W] then MoveDir.y := MoveDir.y - 1;
    if g2.KeyDown[G2K_A] then MoveDir.x := MoveDir.x - 1;
    if g2.KeyDown[G2K_S] then MoveDir.y := MoveDir.y + 1;
    if g2.KeyDown[G2K_D] then MoveDir.x := MoveDir.x + 1;
    Pos := Pos + MoveDir * 0.1;
  end;
  if Pos.x < 0 then Pos.x := 0;
  if Pos.x > 50 then Pos.x := 50;
  if Pos.y < 0 then Pos.y := 0;
  if Pos.y > 50 then Pos.y := 50;
  Display.Position := Pos;
  if g2.MouseDown[G2MB_Middle] then
  begin
    MouseDrag := Display.CoordToDisplay(G2Vec2(g2.MousePos));
  end;
end;

procedure TGame.BuildRelay;
begin
  Game.UIBuildPlacement.BuildClass := TGameBaseRelay;
  Game.UIManager.Widget := Game.UIBuildPlacement;
end;

procedure TGame.BuildCollector;
begin
  Game.UIBuildPlacement.BuildClass := TGameBaseCollector;
  Game.UIManager.Widget := Game.UIBuildPlacement;
end;

//TGame END

end.
