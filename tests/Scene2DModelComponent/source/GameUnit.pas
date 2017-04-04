unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  G2Scene2D,
  G2MeshG2M,
  Types,
  Classes;

type
  TGame = class
  protected
  public
    var Mesh: TG2LegacyMesh;
    var Inst: TG2LegacyMeshInst;
    var Display: TG2Display2D;
    var Scene: TG2Scene2D;
    var Entity: TG2Scene2DEntity;
    var Component: TG2Scene2DComponentModel3D;
    var Sprite: TG2Scene2DComponentSprite;
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
  Mesh := TG2LegacyMesh.Create;
  Mesh.Load('Zombie.g2m');
  Inst := TG2LegacyMeshInst.Create(Mesh);
  Display := TG2Display2D.Create;
  Scene := TG2Scene2D.Create;
  Display.Position := G2Vec2(0, 0);
  Display.Width := 10;
  Display.Height := 10;
  Entity := TG2Scene2DEntity.Create(Scene);
  Component := TG2Scene2DComponentModel3D.Create(Scene);
  Component.Attach(Entity);
  Component.Layer := 10;
  Component.Mesh := TG2LegacyMesh.SharedAsset('Zombie.g2m');
  Component.AnimLoop := True;
  Component.AnimName := 'Walk';
  //Sprite := TG2Scene2DComponentSprite.Create(Scene);
  //Sprite.Attach(Entity);
  //Sprite.Layer := 0;
  //Sprite.Picture := TG2Picture.SharedAsset('Zp.png', tu2D);
  //Sprite.Scale := 1;
end;

procedure TGame.Finalize;
begin
  Inst.Free;
  Mesh.Free;
  Entity.Free;
  Scene.Free;
  Display.Free;
  Free;
end;

procedure TGame.Update;
begin
  //Inst.FrameSet('Walk', G2TimeInterval() * Inst.Mesh.Anims[Inst.Mesh.AnimIndex('Walk')]^.FrameCount);
end;

procedure TGame.Render;
  var W, V, P: TG2Mat;
  var Tex: TG2Picture;
begin
  g2.Clear(True, $ff808080);
  W := G2MatRotationY(G2PiTime());
  V := G2MatView(G2Vec3(-30, 30, -30), G2Vec3(0, 0, 0), G2Vec3(0, 1, 0));
  P := G2MatProj(Pi * 0.5, g2.Params.Width / g2.Params.Height, 0.1, 1000);
  //Inst.Render(W, V, P);
  Scene.Render(Display);
  Tex := TG2Picture.SharedAsset('Zp.png', tu2D);
  Tex.RefInc;
  g2.PicRect(0, 0, $ffffffff, Tex.Texture);
  Tex.RefDec;
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
