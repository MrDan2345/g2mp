//G2PerlinNoise v1.0
unit G2PerlinNoise;

interface

uses
  G2Types,
  G2Math;

type
  TG2PerlinProc2D = function (const x, y: IntS32): G2Float of Object;
  TG2PerlinProc3D = function (const x, y, z: IntS32): G2Float of Object;

  TG2PerlinNoise = class
  private
    _Seamless: Boolean;
    _PatternWidth: IntS32;
    _PatternHeight: IntS32;
    _PatternDepth: IntS32;
    _CurPW: IntS32;
    _CurPH: IntS32;
    _CurPD: IntS32;
    _RandFactor: IntS32;
    _ProcNoise2D: TG2PerlinProc2D;
    _ProcNoise3D: TG2PerlinProc3D;
    function Noise2DStandard(const x, y: IntS32): G2Float;
    function Noise2DSeamless(const x, y: IntS32): G2Float;
    function Noise2DSmooth(const x, y: IntS32): G2Float;
    function Noise2DInterpolated(const x, y: G2Float): G2Float;
    function Noise3DStandard(const x, y, z: IntS32): G2Float;
    function Noise3DSeamless(const x, y, z: IntS32): G2Float;
    function Noise3DSmooth(const x, y, z: IntS32): G2Float;
    function Noise3DInterpolated(const x, y, z: G2Float): G2Float;
    procedure SetSeamless(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    property Seamless: Boolean read _Seamless write SetSeamless;
    property PatternWidth: IntS32 read _PatternWidth write _PatternWidth;
    property PatternHeight: IntS32 read _PatternHeight write _PatternHeight;
    property PatternDepth: IntS32 read _PatternDepth write _PatternDepth;
    function PerlinNoise2D(
      const x, y: G2Float;
      const Octaves: IntS32;
      const Persistence: G2Float = 0.5;
      const Frequency: G2Float = 0.25;
      const Amplitude: G2Float = 1;
      const RandFactor: IntS32 = 0
    ): G2Float;
    function PerlinNoise3D(
      const x, y, z: G2Float;
      const Octaves: IntS32;
      const Persistence: G2Float = 0.5;
      const Frequency: G2Float = 0.25;
      const Amplitude: G2Float = 1;
      const RandFactor: IntS32 = 0
    ): G2Float;
  end;

implementation

//TG2PerlinNoise BEGIN
constructor TG2PerlinNoise.Create;
begin
  inherited Create;
  _Seamless := False;
  _ProcNoise2D := @Noise2DStandard;
  _ProcNoise3D := @Noise3DStandard;
  _PatternWidth := 256;
  _PatternHeight := 256;
  _PatternDepth := 256;
end;

destructor TG2PerlinNoise.Destroy;
begin
  inherited Destroy;
end;

function TG2PerlinNoise.Noise2DStandard(const x, y: IntS32): G2Float;
var
  n: IntS32;
  l_x, l_y: IntS32;
const
  c1 = 1 / 1073741824;
begin
  l_x := x + _RandFactor;
  l_y := y + _RandFactor;
  n := l_x + l_y * 57;
  n := (n shl 13) xor n;
  Result := (1.0 - ( (n * (n * n * 15731 + 789221) + 1376312589) and $7fffffff) * c1);
end;

function TG2PerlinNoise.Noise2DSeamless(const x, y: IntS32): G2Float;
var
  n: IntS32;
  l_x, l_y: IntS32;
const
  c1 = 1 / 1073741824;
begin
  if x >= 0 then
  l_x := (x mod _CurPW) + _RandFactor
  else
  l_x := (_CurPW - (Abs(x) mod _CurPW)) + _RandFactor;
  if y >= 0 then
  l_y := (y mod _CurPH) + _RandFactor
  else
  l_y := (_CurPH - (Abs(y) mod _CurPH)) + _RandFactor;
  n := l_x + l_y * 57;
  n := (n shl 13) xor n;
  Result := (1.0 - ( (n * (n * n * 15731 + 789221) + 1376312589) and $7fffffff) * c1);
end;

function TG2PerlinNoise.Noise2DSmooth(const x, y: IntS32): G2Float;
var
  Corners, Sides, Center: G2Float;
const
  c1 = 1 / 16;
  c2 = 1 / 8;
  c3 = 1 / 4;
begin
  Corners := (_ProcNoise2D(x - 1, y - 1) + _ProcNoise2D(x + 1, y - 1) + _ProcNoise2D(x - 1, y + 1) + _ProcNoise2D(x + 1, y + 1)) * c1;
  Sides := (_ProcNoise2D(x - 1, y) + _ProcNoise2D(x + 1, y) + _ProcNoise2D(x, y - 1) + _ProcNoise2D(x, y + 1)) * c2;
  Center :=  _ProcNoise2D(x, y) * c3;
  Result := Corners + Sides + Center;
end;

function TG2PerlinNoise.Noise2DInterpolated(const x, y: G2Float): G2Float;
var
  IntX, IntY: IntS32;
  FracX, FracY: G2Float;
  v1, v2, v3, v4, i1, i2: G2Float;
begin
  IntX := Trunc(x);
  FracX := x - IntX;
  IntY := Trunc(y);
  FracY := y - IntY;
  v1 := Noise2DSmooth(IntX, IntY);
  v2 := Noise2DSmooth(IntX + 1, IntY);
  v3 := Noise2DSmooth(IntX, IntY + 1);
  v4 := Noise2DSmooth(IntX + 1, IntY + 1);
  i1 := G2CosrpFloat(v1, v2, FracX);
  i2 := G2CosrpFloat(v3, v4, FracX);
  Result := G2CosrpFloat(i1, i2, FracY);
end;

function TG2PerlinNoise.Noise3DStandard(const x, y, z: IntS32): G2Float;
var
  n: IntS32;
  l_x, l_y, l_z: IntS32;
const
  c1 = 1 / 1073741824;
begin
  l_x := x + _RandFactor;
  l_y := y + _RandFactor;
  l_z := z + _RandFactor;
  n := l_x + l_y * 57 + l_z * 113;
  n := (n shl 13) xor n;
  Result := (1 - ( (n * (n * n * 15731 + 789221) + 1376312589) and $7fffffff) * c1);
end;

function TG2PerlinNoise.Noise3DSeamless(const x, y, z: IntS32): G2Float;
var
  n: IntS32;
  l_x, l_y, l_z: IntS32;
const
  c1 = 1 / 1073741824;
begin
  if x >= 0 then
  l_x := (x mod _CurPW) + _RandFactor
  else
  l_x := (_CurPW - (Abs(x) mod _CurPW)) + _RandFactor;
  if y >= 0 then
  l_y := (y mod _CurPH) + _RandFactor
  else
  l_y := (_CurPH - (Abs(y) mod _CurPH)) + _RandFactor;
  if z >= 0 then
  l_z := (z mod _CurPD) + _RandFactor
  else
  l_z := (_CurPD - (Abs(z) mod _CurPD)) + _RandFactor;
  n := l_x + l_y * 57 + l_z * 113;
  n := (n shl 13) xor n;
  Result := (1 - ( (n * (n * n * 15731 + 789221) + 1376312589) and $7fffffff) * c1);
end;

function TG2PerlinNoise.Noise3DSmooth(const x, y, z: IntS32): G2Float;
var
  Corners, Sides, Center: G2Float;
const
  c1 = 1 / 32;
  c2 = 1 / 24;
  c3 = 1 / 4;
begin
  Corners := (
    _ProcNoise3D(x - 1, y - 1, z - 1) +
    _ProcNoise3D(x + 1, y - 1, z - 1) +
    _ProcNoise3D(x - 1, y + 1, z - 1) +
    _ProcNoise3D(x + 1, y + 1, z - 1) +
    _ProcNoise3D(x - 1, y - 1, z + 1) +
    _ProcNoise3D(x + 1, y - 1, z + 1) +
    _ProcNoise3D(x - 1, y + 1, z + 1) +
    _ProcNoise3D(x + 1, y + 1, z + 1)
  ) * c1;
  Sides := (
    _ProcNoise3D(x - 1, y, z - 1) +
    _ProcNoise3D(x + 1, y, z - 1) +
    _ProcNoise3D(x, y - 1, z - 1) +
    _ProcNoise3D(x, y + 1, z - 1) +
    _ProcNoise3D(x - 1, y, z) +
    _ProcNoise3D(x + 1, y, z) +
    _ProcNoise3D(x, y - 1, z) +
    _ProcNoise3D(x, y + 1, z) +
    _ProcNoise3D(x - 1, y, z + 1) +
    _ProcNoise3D(x + 1, y, z + 1) +
    _ProcNoise3D(x, y - 1, z + 1) +
    _ProcNoise3D(x, y + 1, z + 1)
  ) * c2;
  Center :=  _ProcNoise3D(x, y, z) * c3;
  Result := Corners + Sides + Center;
end;

function TG2PerlinNoise.Noise3DInterpolated(const x, y, z: G2Float): G2Float;
var
  IntX, IntY, IntZ: IntS32;
  FracX, FracY, FracZ: G2Float;
  v: array[0..3, 0..1] of G2Float;
  s1, s2, n1, n2: G2Float;
begin
  IntX := Trunc(x);
  FracX := x - IntX;
  IntY := Trunc(y);
  FracY := y - IntY;
  IntZ := Trunc(z);
  FracZ := z - IntZ;
  v[0, 0] := Noise3DSmooth(IntX, IntY, IntZ);
  v[1, 0] := Noise3DSmooth(IntX + 1, IntY, IntZ);
  v[2, 0] := Noise3DSmooth(IntX, IntY + 1, IntZ);
  v[3, 0] := Noise3DSmooth(IntX + 1, IntY + 1, IntZ);
  v[0, 1] := Noise3DSmooth(IntX, IntY, IntZ + 1);
  v[1, 1] := Noise3DSmooth(IntX + 1, IntY, IntZ + 1);
  v[2, 1] := Noise3DSmooth(IntX, IntY + 1, IntZ + 1);
  v[3, 1] := Noise3DSmooth(IntX + 1, IntY + 1, IntZ + 1);
  s1 := G2CosrpFloat(v[0, 0], v[1, 0], FracX);
  s2 := G2CosrpFloat(v[2, 0], v[3, 0], FracX);
  n1 := G2CosrpFloat(s1, s2, FracY);
  s1 := G2CosrpFloat(v[0, 1], v[1, 1], FracX);
  s2 := G2CosrpFloat(v[2, 1], v[3, 1], FracX);
  n2 := G2CosrpFloat(s1, s2, FracY);
  Result := G2CosrpFloat(n1, n2, FracZ);
end;

procedure TG2PerlinNoise.SetSeamless(const Value: Boolean);
begin
  _Seamless := Value;
  if _Seamless then
  begin
    _ProcNoise2D := @Noise2DSeamless;
    _ProcNoise3D := @Noise3DSeamless;
  end
  else
  begin
    _ProcNoise2D := @Noise2DStandard;
    _ProcNoise3D := @Noise3DStandard;
  end;
end;

function TG2PerlinNoise.PerlinNoise2D(
      const x, y: G2Float;
      const Octaves: IntS32;
      const Persistence: G2Float = 0.5;
      const Frequency: G2Float = 0.25;
      const Amplitude: G2Float = 1;
      const RandFactor: IntS32 = 0
    ): G2Float;
var
  i: IntS32;
  Total: G2Float;
  l_Persistence: G2Float;
  l_Frequency: G2Float;
  l_Amplitude: G2Float;
begin
  if Octaves <= 0 then
  begin
    Result := 0;
    Exit;
  end;
  
  Total := 0;
  l_Persistence := Persistence;

  l_Frequency := Frequency;
  l_Amplitude := Amplitude;

  _RandFactor := RandFactor;

  for i := 0 to Octaves - 1 do
  begin
    _CurPW := Trunc(_PatternWidth * l_Frequency);
    _CurPH := Trunc(_PatternHeight * l_Frequency);
    Total := Total + Noise2DInterpolated(x * l_Frequency, y * l_Frequency) * l_Amplitude;
    l_Amplitude := l_Amplitude * l_Persistence;
    l_Frequency := l_Frequency * 2;
  end;
  //if Total > 1 then Total := 1 else if Total < 0 then Total := 0;
  Result := Total;
end;

function TG2PerlinNoise.PerlinNoise3D(
      const x, y, z: G2Float;
      const Octaves: IntS32;
      const Persistence: G2Float = 0.5;
      const Frequency: G2Float = 0.25;
      const Amplitude: G2Float = 1;
      const RandFactor: IntS32 = 0
    ): G2Float;
var
  i: IntS32;
  Total: G2Float;
  l_Persistence: G2Float;
  l_Frequency: G2Float;
  l_Amplitude: G2Float;
begin
  if Octaves <= 0 then
  begin
    Result := 0;
    Exit;
  end;
  
  Total := 0;
  l_Persistence := Persistence;

  l_Frequency := Frequency;
  l_Amplitude := Amplitude;

  _RandFactor := RandFactor;

  for i := 0 to Octaves - 1 do
  begin
    _CurPW := Trunc(_PatternWidth * l_Frequency);
    _CurPH := Trunc(_PatternHeight * l_Frequency);
    _CurPD := Trunc(_PatternDepth * l_Frequency);
    Total := Total + Noise3DInterpolated(
      x * l_Frequency,
      y * l_Frequency,
      z * l_Frequency
    ) * l_Amplitude;
    l_Amplitude := l_Amplitude * l_Persistence;
    l_Frequency := l_Frequency * 2;
  end;
  Result := Total;   
end;
//TG2PerlinNoise END

end.
