unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  Types,
  Classes,
  SysUtils;

type
  TGame = class
  protected
    var Mesh: TG2Mesh;
    var MeshInst: TG2MeshInst;
    var Shader: TG2ShaderGroup;
    var Tex: TG2Texture2D;
  public
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
begin
  Mesh := TG2Mesh.SharedAsset('test.g2m');
  Mesh.RefInc;
  MeshInst := Mesh.NewInst;
  MeshInst.RefInc;
  Shader := g2.Gfx.RequestShader('StandardShaders');
  //Shader := TG2ShaderGroup.Create;
  //Shader.Load('GlitterShaders.g2sg');
  Tex := TG2Texture2D.SharedAsset('Box.png', tu3D);
  Tex.RefInc;
end;

procedure TGame.Finalize;
begin
  //Shader.Free;
  Tex.RefDec;
  MeshInst.RefDec;
  Mesh.RefDec;
end;

procedure TGame.Update;
begin

end;

procedure TGame.Render;
  var gi, mi: Integer;
  var WVP, WL, W, V, P: TG2Mat;
  var DataStatic: PG2GeomDataStatic;
  var DataSkinned: PG2GeomDataSkinned;
  var EyePos: TG2Vec3;
begin
  g2.Clear(True, $ff808080);
  EyePos := G2Vec3(-7, 7, -7);
  //W := G2MatRotationY(Pi);
  W := G2MatRotationY(G2PiTime);
  V := G2MatView(EyePos, G2Vec3(0, 4, 0), G2Vec3(0, 1, 0));
  P := G2MatProj(Pi * 0.4, g2.Params.Width / g2.Params.Height, 1, 100);
  WVP := W * V * P;
  g2.Gfx.StateChange.StateDepthEnable := True;
  for gi := 0 to Mesh.Geoms.Count - 1 do
  begin
    if Mesh.Geoms[gi]^.Skinned then Continue;
    DataStatic := PG2GeomDataStatic(Mesh.Geoms[gi]^.Data);
    WL := Mesh.Nodes[Mesh.Geoms[gi]^.NodeID]^.Transform * W;
    WVP := WL * V * P;
    for mi := 0 to Mesh.Geoms[gi]^.GCount - 1 do
    begin
      g2.Gfx.Buffer.BufferBegin(
        ptTriangleList, DataStatic^.VB, Mesh.Geoms[gi]^.IB, Shader, 'SceneB0',
        Mesh.Geoms[gi]^.Groups[mi].VertexStart,
        Mesh.Geoms[gi]^.Groups[mi].VertexCount,
        Mesh.Geoms[gi]^.Groups[mi].FaceStart * 3,
        Mesh.Geoms[gi]^.Groups[mi].FaceCount
      );
      g2.Gfx.Buffer.ParamMat4x4('W', WL);
      g2.Gfx.Buffer.ParamMat4x4('WVP', WVP);
      //g2.Gfx.Buffer.ParamVec3('EyePos', EyePos);
      g2.Gfx.Buffer.ParamVec4('LightAmbient', G2Vec4(1, 1, 1, 1));
      g2.Gfx.Buffer.Sampler('Tex0', Tex);//Mesh.Materials[Mesh.Geoms[gi]^.Groups[mi].Material]^.Channels[0].MapDiffuse);
      g2.Gfx.Buffer.BufferEnd;
    end;
  end;
  g2.Gfx.StateChange.StateDepthEnable := False;
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
