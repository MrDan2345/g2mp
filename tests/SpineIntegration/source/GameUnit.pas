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
  Spine;

type
  TG2SpineTexture = class (TSpineTexture)
  public
    Texture: TG2Texture2D;
    constructor Create(const TextureName: AnsiString);
    destructor Destroy; override;
    function GetWidth: Integer; override;
    function GetHeight: Integer; override;
  end;

  TG2SpineDataProvider = class (TSpineDataProvider)
  public
    class function FetchData(const DataName: String): TSpineDataProvider; override;
    class function FetchTexture(const TextureName: String): TSpineTexture; override;
  end;

  TG2SpineRender = class (TSpineRender)
  private
    var _Display: TG2Display2D;
  public
    property Display: TG2Display2D read _Display write _Display;
    constructor Create;
    procedure RenderQuad(const Texture: TSpineTexture; const Vertices: PSpineVertexArray); override;
    procedure RenderPoly(const Texture: TSpineTexture; const Vertices: PSpineVertexArray; const Triangles: PIntegerArray; const TriangleCount: Integer); override;
  end;

  TGame = class
  protected
    Display: TG2Display2D;
    SpineRender: TG2SpineRender;
    Time: Single;
    Skeleton: TSpineSkeleton;
    State: TSpineAnimationState;
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

//TG2SpineDataProvider BEGIN
class function TG2SpineDataProvider.FetchData(const DataName: String): TSpineDataProvider;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(DataName, dmAsset);
  Result := TSpineDataProvider.Create(dm.Size);
  dm.ReadBuffer(Result.Data, dm.Size);
  dm.Free;
end;

class function TG2SpineDataProvider.FetchTexture(const TextureName: String): TSpineTexture;
begin
  Result := TG2SpineTexture.Create(TextureName);
end;
//TG2SpineDataProvider END

//TG2SpineTexture BEGIN
constructor TG2SpineTexture.Create(const TextureName: AnsiString);
begin
  inherited Create;
  Texture := TG2Texture2D.SharedAsset(TextureName);
  Texture.RefInc;
end;

destructor TG2SpineTexture.Destroy;
begin
  Texture.RefDec;
  inherited Destroy;
end;

function TG2SpineTexture.GetWidth: Integer;
begin
  Result := Texture.RealWidth;
end;

function TG2SpineTexture.GetHeight: Integer;
begin
  Result := Texture.RealHeight;
end;
//TG2SpineTexture END

//TG2SpineRender BEGIN
constructor TG2SpineRender.Create;
begin
  _Display := nil;
end;

procedure TG2SpineRender.RenderQuad(const Texture: TSpineTexture; const Vertices: PSpineVertexArray);
  var pv: PSpineVertexArray absolute Vertices;
begin
  if Assigned(_Display) then
  begin
    _Display.PicQuadCol(
      pv^[0].x, pv^[0].y, pv^[1].x, pv^[1].y,
      pv^[3].x, pv^[3].y, pv^[2].x, pv^[2].y,
      pv^[0].u, pv^[0].v, pv^[1].u, pv^[1].v,
      pv^[3].u, pv^[3].v, pv^[2].u, pv^[2].v,
      G2Color(Round(pv^[0].r * $ff), Round(pv^[0].g * $ff), Round(pv^[0].b * $ff), Round(pv^[0].a * $ff)),
      G2Color(Round(pv^[1].r * $ff), Round(pv^[1].g * $ff), Round(pv^[1].b * $ff), Round(pv^[1].a * $ff)),
      G2Color(Round(pv^[3].r * $ff), Round(pv^[3].g * $ff), Round(pv^[3].b * $ff), Round(pv^[3].a * $ff)),
      G2Color(Round(pv^[2].r * $ff), Round(pv^[2].g * $ff), Round(pv^[2].b * $ff), Round(pv^[2].a * $ff)),
      TG2SpineTexture(Texture).Texture, bmNormal, tfLinear
    );
  end
  else
  begin
    g2.PicQuadCol(
      pv^[0].x, pv^[0].y, pv^[1].x, pv^[1].y,
      pv^[3].x, pv^[3].y, pv^[2].x, pv^[2].y,
      pv^[0].u, pv^[0].v, pv^[1].u, pv^[1].v,
      pv^[3].u, pv^[3].v, pv^[2].u, pv^[2].v,
      G2Color(Round(pv^[0].r * $ff), Round(pv^[0].g * $ff), Round(pv^[0].b * $ff), Round(pv^[0].a * $ff)),
      G2Color(Round(pv^[1].r * $ff), Round(pv^[1].g * $ff), Round(pv^[1].b * $ff), Round(pv^[1].a * $ff)),
      G2Color(Round(pv^[3].r * $ff), Round(pv^[3].g * $ff), Round(pv^[3].b * $ff), Round(pv^[3].a * $ff)),
      G2Color(Round(pv^[2].r * $ff), Round(pv^[2].g * $ff), Round(pv^[2].b * $ff), Round(pv^[2].a * $ff)),
      TG2SpineTexture(Texture).Texture, bmNormal, tfLinear
    );
  end;
end;

procedure TG2SpineRender.RenderPoly(const Texture: TSpineTexture; const Vertices: PSpineVertexArray; const Triangles: PIntegerArray; const TriangleCount: Integer);
  var i: Integer;
  var v, v1, v2, v3: PSpineVertexData;
begin
  if Assigned(_Display) then
  begin
    _Display.PolyBegin(ptTriangles, TG2SpineTexture(Texture).Texture, bmNormal, tfLinear);
    for i := 0 to TriangleCount * 3 - 1 do
    begin
      v := @Vertices^[Triangles^[i]];
      _Display.PolyAdd(
        v^.x, v^.y, v^.u, v^.v,
        G2Color(Round(v^.r * $ff), Round(v^.g * $ff), Round(v^.b * $ff), Round(v^.a * $ff))
      );
    end;
    _Display.PolyEnd;
  end
  else
  begin
    g2.PolyBegin(ptTriangles, TG2SpineTexture(Texture).Texture, bmNormal, tfLinear);
    for i := 0 to TriangleCount * 3 - 1 do
    begin
      v := @Vertices^[Triangles^[i]];
      g2.PolyAdd(
        v^.x, v^.y, v^.u, v^.v,
        G2Color(Round(v^.r * $ff), Round(v^.g * $ff), Round(v^.b * $ff), Round(v^.a * $ff))
      );
    end;
    g2.PolyEnd;
  end;
end;
//TG2SpineRender END

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
  //const CharacterName = 'spineboy';
  const CharacterName = 'raptor';
  var sb: TSpineSkeletonBinary;
  var sd: TSpineSkeletonData;
  var al: TSpineAtlasList;
  var ad: TSpineAnimationStateData;
  var Atlas: TSpineAtlas;
begin
  Display := TG2Display2D.Create;
  SpineDataProvider := TG2SpineDataProvider;
  SpineRender := TG2SpineRender.Create;
  Atlas := TSpineAtlas.Create(CharacterName + '.atlas');
  al := TSpineAtlasList.Create;
  al.Add(Atlas);
  sb := TSpineSkeletonBinary.Create(al);
  sb.Scale := 0.5;
  sd := sb.ReadSkeletonData(CharacterName + '.skel');
  Skeleton := TSpineSkeleton.Create(sd);
  Skeleton.x := 800;
  Skeleton.y := 800;
  Skeleton.ScaleX := 2;
  Skeleton.ScaleY := 2;
  ad := TSpineAnimationStateData.Create(sd);
  //ad.SetMix('run', 'jump', 0.2);
  //ad.SetMix('jump', 'run', 0.2);
  State := TSpineAnimationState.Create(ad);
  State.TimeScale := 1;
  State.SetAnimation(0, 'walk', True);
  //State.AddAnimation(0, 'run', False, 0);
  //State.AddAnimation(0, 'jump', False, 1);
  //State.SetAnimation(0, 'run', True);
  ad.Free;
  sd.Free;
  sb.Free;
  al.Free;
  Atlas.Free;
  Time := 0;
end;

procedure TGame.Finalize;
begin
  State.Free;
  Skeleton.Free;
  SpineRender.Free;
  TSpineClass.Report('SpineReport.txt');
  Display.Free;
end;

procedure TGame.Update;
begin
  State.TimeScale := (Sin(G2PiTime()) + 1) * 0.25 + 0.5;
  State.Update(g2.DeltaTimeSec);
end;

procedure TGame.Render;
begin
  g2.Clear($ff80c0c0);
  State.Apply(Skeleton);
  Skeleton.UpdateWorldTransform;
  Skeleton.Draw(SpineRender);
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
