unit G2Landscape2D;

interface

uses
  Gen2MP,
  G2Types,
  G2Utils,
  G2Math;

type
  TG2Landscape2D = class;

  TG2Landscape2DLayer = object
  private
    _Landscape: TG2Landscape2D;
    _Order: TG2Float;
    procedure SetOrder(const Value: TG2Float);
  public
    Texture: TG2Texture2D;
    Grid: array of array of TG2Float;
    property Order: TG2Float read _Order write SetOrder;
  end;
  PG2Landscape2DLayer = ^TG2Landscape2DLayer;

  TG2Landscape2D = class
  private
    _GridX: TG2IntS32;
    _GridY: TG2IntS32;
    _CellSize: TG2Float;
    _Layers: TG2QuickSortList;
    _Heights: array of array of TG2Float;
    _Rotation: TG2Vec2;
    _Dir: TG2Float;
    _Angle: TG2Float;
    _VMod: TG2Float;
    _CoordT: array of array of TG2Vec2;
    procedure SetDir(const Value: TG2Float); inline;
    procedure SetAngle(const Value: TG2Float); inline;
    function GetHeight(const x, y: TG2IntS32): TG2Float; inline;
    procedure SetHeight(const x, y: TG2IntS32; const Value: TG2Float); inline;
    function TransformCoord(const Coord: TG2Vec3): TG2Vec2; inline;
  public
    ViewPos: TG2Vec2;
    property ViewDir: TG2Float read _Dir write SetDir;
    property ViewAngle: TG2Float read _Angle write SetAngle;
    property Heights[const x, y: TG2IntS32]: TG2Float read GetHeight write SetHeight;
    constructor Create(const GridX, GridY: TG2IntS32; const CellSize: TG2Float);
    destructor Destroy; override;
    function AddLayer(const Texture: TG2Texture2D; const Order: TG2Float): PG2Landscape2DLayer;
    procedure ClearLayers;
    procedure Render(const Display: TG2Display2D);
  end;

implementation

//TG2Landscape2DLayer BEGIN
procedure TG2Landscape2DLayer.SetOrder(const Value: TG2Float);
begin
  _Order := Value;
  _Landscape._Layers.Remove(@Self);
  _Landscape._Layers.Add(@Self, _Order);
end;
//TG2Landscape2DLayer END

//TG2Landscape2D BEGIN
procedure TG2Landscape2D.SetDir(const Value: TG2Float);
begin
  _Dir := Value;
  G2SinCos(_Dir, _Rotation.y, _Rotation.x);
end;

procedure TG2Landscape2D.SetAngle(const Value: TG2Float);
begin
  _Angle := Value;
  _VMod := Sin(_Angle);
end;

function TG2Landscape2D.GetHeight(const x, y: TG2IntS32): TG2Float;
begin
  Result := _Heights[x, y];
end;

procedure TG2Landscape2D.SetHeight(const x, y: TG2IntS32; const Value: TG2Float);
begin
  _Heights[x, y] := Value;
end;

function TG2Landscape2D.TransformCoord(const Coord: TG2Vec3): TG2Vec2;
  var v: TG2Vec2;
begin
  v.x := (Coord.x - ViewPos.x); v.y := (Coord.y - ViewPos.y);
  Result.x := (_Rotation.x * v.x - _Rotation.y * v.y);
  Result.y := (_Rotation.y * v.x + _Rotation.x * v.y) * _VMod - Coord.z;
end;

constructor TG2Landscape2D.Create(const GridX, GridY: TG2IntS32; const CellSize: TG2Float);
  var i, j: TG2IntS32;
begin
  inherited Create;
  _GridX := GridX; _GridY := GridY; _CellSize := CellSize;
  SetLength(_Heights, _GridX + 1, _GridY + 1);
  for j := 0 to _GridY do
  for i := 0 to _GridX do
  _Heights[i, j] := 0;
  ViewPos.SetValue(0, 0);
  _Dir := 0;
  _Rotation.SetValue(1, 0);
  _Angle := HalfPi;
  _VMod := 1;
end;

destructor TG2Landscape2D.Destroy;
begin
  ClearLayers;
  inherited Destroy;
end;

function TG2Landscape2D.AddLayer(const Texture: TG2Texture2D; const Order: TG2Float): PG2Landscape2DLayer;
  var i, j: TG2IntS32;
begin
  New(Result);
  Result^.Texture := Texture;
  Result^._Order := Order;
  SetLength(Result^.Grid, _GridX + 1, _GridY + 1);
  for j := 0 to _GridY do
  for i := 0 to _GridX do
  Result^.Grid[i, j] := 0;
  _Layers.Add(Result, Order);
end;

procedure TG2Landscape2D.ClearLayers;
begin
  while _Layers.Count > 0 do
  Dispose(PG2Landscape2DLayer(_Layers.Pop));
end;

procedure TG2Landscape2D.Render(const Display: TG2Display2D);
  var i, j: Integer;
  var sw, sh: TG2Float;
  var rvx, rvy: TG2Vec2;
  var v: array[0..3] of TG2Vec2;
  var slx, shx, sly, shy: TG2Float;
  var clx, cly, chx, chy: TG2IntS32;
begin
  sw := Display.WidthScr;
  sh := Display.HeightScr / _VMod;
  rvx := Display.RotationVector;
  rvy := rvx.Perp;
  rvx := rvx * sw; rvy := rvy * sh;
  v[0] := ViewPos - rvx - rvy;
  v[1] := ViewPos + rvx - rvy;
  v[2] := ViewPos - rvx + rvy;
  v[3] := ViewPos + rvx + rvy;
  slx := v[0].x;
  shx := v[0].x;
  sly := v[0].y;
  shy := v[0].y;
  for i := 1 to 3 do
  begin
    if slx > v[i].x then slx := v[i].x;
    if shx < v[i].x then shx := v[i].x;
    if sly > v[i].y then sly := v[i].y;
    if shy < v[i].y then shy := v[i].y;
  end;
  clx := G2Max(0, Round(slx / _CellSize) - 1);
  chx := G2Min(_GridX - 1, Round(shx / _CellSize) + 1);
  cly := G2Max(0, Round(sly / _CellSize) - 1);
  chy := G2Min(_GridY - 1, Round(shy / _CellSize) + 1);
  if (Length(_CoordT) < chx - clx + 2)
  or (Length(_CoordT[0]) < chy - cly + 2) then
  SetLength(_CoordT, chx - clx + 2, chy - cly + 2);
  for j := cly to chy + 1 do
  for i := clx to chx + 1 do
  _CoordT[i - clx, j - cly] := TransformCoord(G2Vec3(i * _CellSize, j * _CellSize, _Heights[i ,j]));
  for j := cly to chy do
  for i := clx to chx do
  begin
    Display.PicQuadCol(
      _CoordT[i - clx, j - cly], _CoordT[i - clx + 1, j - cly],
      _CoordT[i - clx, j - cly + 1], _CoordT[i - clx + 1, j - cly + 1],
      G2Vec2(0, 0), G2Vec2(1, 0),
      G2Vec2(0, 1), G2Vec2(1, 1),
      $ffffffff, $ffffffff, $ffffffff, $ffffffff,
      PG2Landscape2DLayer(_Layers[0])^.Texture,
      bmNormal, tfLinear
    );
  end;
end;
//TG2Landscape2D END

end.
