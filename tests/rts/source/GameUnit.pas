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
  SysUtils;

type
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

  TUIBuildMenu = class (TUIWidget)
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
  end;

  TGameObject = class (TG2Scene2DEntity)

  end;

  TGameBase = class (TGameObject)

  end;

  TGameAsteroid = class (TGameObject)

  end;

  TGameMothership = class (TGameBase)
  public
    var BuildMenu: TUIBuildMenu;
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
    procedure OnUpdate;
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
    var Scene: TG2Scene2D;
    var Display: TG2Display2D;
    var Background: TBackground;
    var TargetZoom: Single;
    var UIManager: TUIManager;
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
  end;

var
  Game: TGame;

implementation

constructor TGameMothership.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create(OwnerScene);
  g2.CallbackUpdateAdd(@OnUpdate);
  BuildMenu := TUIBuildMenu.Create;
  BuildMenu.AddButton('button_relay', nil);
  BuildMenu.AddButton('button_relay', nil);
  BuildMenu.AddButton('button_relay', nil);
end;

destructor TGameMothership.Destroy;
begin
  BuildMenu.Free;
  g2.CallbackUpdateRemove(@OnUpdate);
  inherited Destroy;
end;

procedure TGameMothership.OnUpdate;
begin
  BuildMenu.Position := Position;
end;

function TUIBuildMenu.AddButton(
  const FrameName: String;
  const OnClick: TG2ProcObj
): TUIBuildMenu.TButton;
begin
  Result := TButton.Create;
  SetLength(Buttons, Length(Buttons) + 1);
  Result.FrameN := Atlas.FindFrame(FrameName + '_n.png');
  Result.FrameH := Atlas.FindFrame(FrameName + '_h.png');
  Result.OnClick := OnClick;
  Result.Enabled := True;
  Buttons[High(Buttons)] := Result;
end;

procedure TUIBuildMenu.OnInitialize;
begin
  inherited OnInitialize;
  RenderOrder := 10;
  Position := G2Vec2;
end;

procedure TUIBuildMenu.OnFinalize;
  var i: Integer;
begin
  for i := 0 to High(Buttons) do
  begin
    Buttons[i].Free;
  end;
  inherited OnFinalize;
end;

procedure TUIBuildMenu.OnRender;
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
  v := G2Vec2(0, -100);
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
      p.x + v.x - Frame.Width * 0.5,
      p.y + v.y - Frame.Height * 0.5,
      Frame.Width, Frame.Height,
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
  Atlas := TG2Atlas.Create;
  Atlas.Load('ui.g2af');
end;

procedure TUIManager.OnFinalize;
begin
  Atlas.Free;
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
    Layers[i].Position := Game.Display.Position * (1 / (0.9 + (i + 1) * 0.1));
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
  Scene := TG2Scene2D.Create;
  Display := TG2Display2D.Create;
  UIManager := TUIManager.Create;
  Display.Width := 10;
  Display.Height := 10;
  Scene.Load('scene.g2s2d');
  Background := TBackground.Create(Scene);
  if not Assigned(Background.Owner) then
  begin
    Background.Free;
    Background := nil;
  end;
  Scene.EnablePhysics;
  UIManager.Widget := TGameMothership(Scene.CreatePrefab('base0.g2prefab2d', G2Transform2, TGameMothership)).BuildMenu;
  Scene.CreatePrefab('asteroid.g2prefab2d', G2Transform2(G2Vec2(1, 1), G2Rotation2), TGameAsteroid);
  TargetZoom := Display.Zoom;
  Display.Position := G2Vec2;
end;

procedure TGame.Finalize;
begin
  UIManager.Free;
  Display.Free;
  Scene.Free;
  Free;
end;

procedure TGame.Update;
begin
  Display.Zoom := G2LerpFloat(Display.Zoom, TargetZoom, 0.2);
  MoveCamera;
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
  if (y > 0) and (TargetZoom > 0.5) then
  begin
    TargetZoom *= (1 / 1.1);
  end;
  if (y < 0) and (TargetZoom < 3) then
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
  MoveDir := G2Vec2;
  if g2.KeyDown[G2K_W] then MoveDir.y := MoveDir.y - 1;
  if g2.KeyDown[G2K_A] then MoveDir.x := MoveDir.x - 1;
  if g2.KeyDown[G2K_S] then MoveDir.y := MoveDir.y + 1;
  if g2.KeyDown[G2K_D] then MoveDir.x := MoveDir.x + 1;
  Pos := Pos + MoveDir * 0.1;
  if Pos.x < 0 then Pos.x := 0;
  if Pos.x > 50 then Pos.x := 50;
  if Pos.y < 0 then Pos.y := 0;
  if Pos.y > 50 then Pos.y := 50;
  Display.Position := Pos;
end;

//TGame END

end.
