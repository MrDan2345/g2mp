unit G2Spine;

interface

uses
  G2Types,
  G2DataManager,
  Gen2MP,
  Spine;

type
  TG2SpineTexture = class (TSpineTexture)
  public
    Texture: TG2Texture2D;
    constructor Create(const TextureName: AnsiString);
    destructor Destroy; override;
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

implementation

//TG2SpineDataProvider BEGIN
class function TG2SpineDataProvider.FetchData(const DataName: String): TSpineDataProvider;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(DataName, dmAsset);
  Result := TSpineDataProvider.Create(DataName, dm.Size);
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
  var v: PSpineVertexData;
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

initialization
begin
  SpineDataProvider := TG2SpineDataProvider;
end;

end.
