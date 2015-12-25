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
    class function FetchData(const DataName: AnsiString): TSpineDataProvider; override;
    class function FetchTexture(const TextureName: AnsiString): TSpineTexture; override;
  end;

  TG2SpineRender = class (TSpineRender)
  private
    var _Display: TG2Display2D;
    var _r: TG2Float;
    var _g: TG2Float;
    var _b: TG2Float;
    var _a: TG2Float;
  public
    property Display: TG2Display2D read _Display write _Display;
    property r: TG2Float read _r write _r;
    property g: TG2Float read _g write _g;
    property b: TG2Float read _b write _b;
    property a: TG2Float read _a write _a;
    constructor Create;
    procedure RenderQuad(const Texture: TSpineTexture; const Vertices: PSpineVertexArray); override;
    procedure RenderPoly(const Texture: TSpineTexture; const Vertices: PSpineVertexArray; const Triangles: PIntegerArray; const TriangleCount: Integer); override;
  end;

implementation

//TG2SpineDataProvider BEGIN
class function TG2SpineDataProvider.FetchData(const DataName: AnsiString): TSpineDataProvider;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(DataName, dmAsset);
  Result := TSpineDataProvider.Create(DataName, dm.Size);
  dm.ReadBuffer(Result.Data, dm.Size);
  dm.Free;
end;

class function TG2SpineDataProvider.FetchTexture(const TextureName: AnsiString): TSpineTexture;
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
  _r := 1;
  _g := 1;
  _b := 1;
  _a := 1;
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
      G2Color(Round(pv^[0].r * _r * $ff), Round(pv^[0].g * _g * $ff), Round(pv^[0].b * _b * $ff), Round(pv^[0].a * _a * $ff)),
      G2Color(Round(pv^[1].r * _r * $ff), Round(pv^[1].g * _g * $ff), Round(pv^[1].b * _b * $ff), Round(pv^[1].a * _a * $ff)),
      G2Color(Round(pv^[3].r * _r * $ff), Round(pv^[3].g * _g * $ff), Round(pv^[3].b * _b * $ff), Round(pv^[3].a * _a * $ff)),
      G2Color(Round(pv^[2].r * _r * $ff), Round(pv^[2].g * _g * $ff), Round(pv^[2].b * _b * $ff), Round(pv^[2].a * _a * $ff)),
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
      G2Color(Round(pv^[0].r * _r * $ff), Round(pv^[0].g * _g * $ff), Round(pv^[0].b * _b * $ff), Round(pv^[0].a * _a * $ff)),
      G2Color(Round(pv^[1].r * _r * $ff), Round(pv^[1].g * _g * $ff), Round(pv^[1].b * _b * $ff), Round(pv^[1].a * _a * $ff)),
      G2Color(Round(pv^[3].r * _r * $ff), Round(pv^[3].g * _g * $ff), Round(pv^[3].b * _b * $ff), Round(pv^[3].a * _a * $ff)),
      G2Color(Round(pv^[2].r * _r * $ff), Round(pv^[2].g * _g * $ff), Round(pv^[2].b * _b * $ff), Round(pv^[2].a * _a * $ff)),
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
        G2Color(Round(v^.r * _r * $ff), Round(v^.g * _g * $ff), Round(v^.b * _b * $ff), Round(v^.a * _a * $ff))
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
        G2Color(Round(v^.r * _r * $ff), Round(v^.g * _g * $ff), Round(v^.b * _b * $ff), Round(v^.a * _a * $ff))
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
