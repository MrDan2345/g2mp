unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  Types,
  Classes;

type
  TGame = class
  protected
  public
    var VB: TG2VertexBuffer;
    var IB: TG2IndexBuffer;
    var Shader: TG2ShaderGroup;
    var Tex: TG2Texture2D;
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
  type TVertex = packed record
    Position: TG2Vec3;
    //Normal: TG2Vec3;
    //Color: TG2Vec4;
    TexCoord: TG2Vec2;
  end;
  var Verts: packed array[0..3] of TVertex = (
    (Position: (x: -1; y: 1; z: 0); {Normal: (x: 0; y: 0; z: 0); Color: (x: 1; y: 0; z: 0; w: 1);} TexCoord: (x: 0; y: 0)),
    (Position: (x: 1; y: 1; z: 0); {Normal: (x: 0; y: 0; z: 0); Color: (x: 0; y: 1; z: 0; w: 1);} TexCoord: (x: 1; y: 0)),
    (Position: (x: -1; y: -1; z: 0); {Normal: (x: 0; y: 0; z: 0); Color: (x: 0; y: 0; z: 1; w: 1);} TexCoord: (x: 0; y: 1)),
    (Position: (x: 1; y: -1; z: 0); {Normal: (x: 0; y: 0; z: 0); Color: (x: 1; y: 1; z: 0; w: 1);} TexCoord: (x: 1; y: 1))
  );
  var Decl: TG2VBDecl;
begin
  Shader := g2.Gfx.RequestShader('StandardShaders');
  Tex := TG2Texture2D.SharedAsset('Box.png', tu3D);
  Tex.RefInc;
  SetLength(Decl, 2);
  Decl[0].Element := vbPosition; Decl[0].Count := 3;
  //Decl[1].Element := vbNormal; Decl[1].Count := 3;
  //Decl[2].Element := vbDiffuse; Decl[2].Count := 4;
  Decl[1].Element := vbTexCoord; Decl[1].Count := 2;
  VB := TG2VertexBuffer.Create(Decl, 4);
  VB.Lock;
  Move(Verts, VB.Data^, SizeOf(Verts));
  VB.UnLock;
  IB := TG2IndexBuffer.Create(6);
  IB.Lock;
  PG2IntU16Arr(IB.Data)^[0] := 0;
  PG2IntU16Arr(IB.Data)^[1] := 1;
  PG2IntU16Arr(IB.Data)^[2] := 2;
  PG2IntU16Arr(IB.Data)^[3] := 2;
  PG2IntU16Arr(IB.Data)^[4] := 1;
  PG2IntU16Arr(IB.Data)^[5] := 3;
  IB.UnLock;
end;

procedure TGame.Finalize;
begin
  Tex.RefDec;
  IB.Free;
  VB.Free;
  Free;
end;

procedure TGame.Update;
begin

end;

procedure TGame.Render;
  var W, V, P, WVP: TG2Mat;
begin
  g2.Gfx.StateChange.StateDepthEnable := True;
  g2.Clear(True, $ff0080ff);
  W := G2MatRotationY(G2PiTime());
  V := G2MatView(G2Vec3(0, 0, -5), G2Vec3(0, 0, 0), G2Vec3(0, 1, 0));
  P := G2MatProj(Pi * 0.4, g2.Params.Width / g2.Params.Height, 0.1, 100);
  WVP := W * V * P;
  g2.Gfx.Buffer.BufferBegin(ptTriangleList, VB, IB, Shader, 'SceneB0', 0, 4, 0, 2);
  g2.Gfx.Buffer.ParamMat4x4('WVP', WVP);
  g2.Gfx.Buffer.ParamVec4('LightAmbient', G2Vec4(1, 1, 1, 1));
  g2.Gfx.Buffer.Sampler('Tex0', Tex);
  g2.Gfx.Buffer.BufferEnd;
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
