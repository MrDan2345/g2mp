unit G2MeshData;
{$include Gen2MP.inc}

interface

uses
  Types,
  Classes,
  G2Types,
  G2Math,
  G2DataManager;

type
  TG2RagdollObject = record
    NodeID: Integer;
    MinV, MaxV: TG2Vec3;
    Transform: TG2Mat;
    DependantCount: Integer;
    Dependants: array of record
      NodeID: Integer;
      Offset: TG2Mat;
    end;
  end;
  PG2RagdollObject = ^TG2RagdollObject;

  PG2MeshData = ^TG2MeshData;
  TG2MeshData = object
    NodeCount: Integer;
    Nodes: array of record
      OwnerID: Integer;
      Name: AnsiString;
      Transform: TG2Mat;
    end;
    GeomCount: Integer;
    Geoms: array of record
      NodeID: Integer;
      SkinID: Integer;
      VCount: Integer;
      FCount: Integer;
      TCount: Integer;
      MCount: Integer;
      Vertices: array of record
        Position: TG2Vec3;
        Tangent: TG2Vec3;
        Binormal: TG2Vec3;
        Normal: TG2Vec3;
        TexCoords: array of TG2Vec2;
        Color: DWord;
      end;
      Faces: array of array[0..2] of TG2IntU16;
      Groups: array of record
        MaterialID: Integer;
        VertexStart: Integer;
        VertexCount: Integer;
        FaceStart: Integer;
        FaceCount: Integer;
      end;
    end;
    SkinCount: Integer;
    Skins: array of record
      GeomID: Integer;
      MaxWeights: Integer;
      BoneCount: Integer;
      Bones: array of record
        NodeID: Integer;
        Bind: TG2Mat;
        BBox: TG2Box;
        VCount: Integer;
      end;
      Vertices: array of record
        WeightCount: Integer;
        Weights: array of record
          BoneID: Integer;
          Weight: Single;
        end;
      end;
    end;
    AnimCount: Integer;
    Anims: array of record
      Name: AnsiString;
      FrameRate: Integer;
      FrameCount: Integer;
      NodeCount: Integer;
      Nodes: array of record
        NodeID: Integer;
        Frames: array of record
          Scaling: TG2Vec3;
          Rotation: TG2Quat;
          Translation: TG2Vec3;
        end;
      end;
    end;
    MaterialCount: Integer;
    Materials: array of record
      ChannelCount: Integer;
      Channels: array of record
        Name: AnsiString;
        TwoSided: Boolean;
        AmbientColor: DWord;
        DiffuseColor: DWord;
        SpecularColor: DWord;
        SpecularColorAmount: Single;
        SpecularPower: Single;
        EmmissiveColor: DWord;
        EmmissiveColorAmount: Single;
        AmbientMapEnable: Boolean;
        AmbientMap: AnsiString;
        AmbientMapAmount: Single;
        DiffuseMapEnable: Boolean;
        DiffuseMap: AnsiString;
        DiffuseMapAmount: Single;
        SpecularMapEnable: Boolean;
        SpecularMap: AnsiString;
        SpecularMapAmount: Single;
        OpacityMapEnable: Boolean;
        OpacityMap: AnsiString;
        OpacityMapAmount: Single;
        LightMapEnable: Boolean;
        LightMap: AnsiString;
        LightMapAmount: Single;
        NormalMapEnable: Boolean;
        NormalMap: AnsiString;
        NormalMapAmount: Single;
      end;
    end;
    RagDollCount: Integer;
    RagDolls: array of record
      NodeID: Integer;
      Head: TG2RagdollObject;
      Neck: TG2RagdollObject;
      Pelvis: TG2RagdollObject;
      BodyNodeCount: Integer;
      BodyNodes: array of TG2RagdollObject;
      ArmRNodeCount: Integer;
      ArmRNodes: array of TG2RagdollObject;
      ArmLNodeCount: Integer;
      ArmLNodes: array of TG2RagdollObject;
      LegRNodeCount: Integer;
      LegRNodes: array of TG2RagdollObject;
      LegLNodeCount: Integer;
      LegLNodes: array of TG2RagdollObject;
    end;
    procedure LimitSkins(const MaxWeights: Integer = 4);
  end;

  TG2MeshLoader = class
  protected
    class function CheckDataHeader(const DataManager: TG2DataManager; const Header: AnsiString): Boolean;
  public
    class function CanLoad(const DataManager: TG2DataManager): Boolean; virtual; overload;
    class function CanLoad(const Stream: TStream): Boolean; virtual; overload;
    class function CanLoad(const FileName: String): Boolean; virtual; overload;
    class function CanLoad(const Buffer: Pointer; const Size: TG2IntS64): Boolean; virtual; overload;
    procedure Load(const DataManager: TG2DataManager); virtual; overload;
    procedure Load(const Stream: TStream); virtual; overload;
    procedure Load(const FileName: String); virtual; overload;
    procedure Load(const Buffer: Pointer; const Size: TG2IntS64); virtual; overload;
    procedure ExportMeshData(const MeshData: PG2MeshData); virtual; abstract;
  end;

  CG2MeshLoader = class of TG2MeshLoader;

procedure G2AddMeshLoader(const Loader: CG2MeshLoader);

var G2MeshLoaders: array of CG2MeshLoader;

implementation

//TG2MeshData BEGIN
procedure TG2MeshData.LimitSkins(const MaxWeights: Integer = 4);
  var s, v, w, n, i, j, CurWeights: Integer;
  var TotalWeight: Single;
  var WeightsRemap: array of record
    Weight: Single;
    Index: Integer;
  end;
begin
  WeightsRemap := nil;
  for s := 0 to SkinCount - 1 do
  begin
    for v := 0 to High(Skins[s].Vertices) do
    begin
      if Skins[s].Vertices[v].WeightCount > MaxWeights then
      begin
        if Skins[s].Vertices[v].WeightCount > Length(WeightsRemap) then
        SetLength(WeightsRemap, Skins[s].Vertices[v].WeightCount);
        CurWeights := 0;
        for w := 0 to Skins[s].Vertices[v].WeightCount - 1 do
        begin
          n := CurWeights;
          for i := 0 to CurWeights - 1 do
          if WeightsRemap[i].Weight < Skins[s].Vertices[v].Weights[w].Weight then
          begin
            n := i;
            Move(WeightsRemap[i], WeightsRemap[i + 1], 8 * (CurWeights - i));
            Break;
          end;
          WeightsRemap[n].Weight := Skins[s].Vertices[v].Weights[w].Weight;
          WeightsRemap[n].Index := Skins[s].Vertices[v].Weights[w].BoneID;
          Inc(CurWeights);
        end;
        TotalWeight := WeightsRemap[0].Weight;
        for w := 1 to MaxWeights - 1 do
        TotalWeight := TotalWeight + WeightsRemap[w].Weight;
        TotalWeight := 1 / TotalWeight;
        SetLength(Skins[s].Vertices[v].Weights, MaxWeights);
        for w := 0 to MaxWeights - 1 do
        begin
          Skins[s].Vertices[v].Weights[w].BoneID := WeightsRemap[w].Index;
          Skins[s].Vertices[v].Weights[w].Weight := WeightsRemap[w].Weight * TotalWeight;
        end;
        Skins[s].Vertices[v].WeightCount := MaxWeights;
      end;
      n := Skins[s].Vertices[v].WeightCount;
      w := 0;
      while w < n do
      begin
        if Skins[s].Vertices[v].Weights[w].Weight < G2EPS then
        begin
          for j := w to n - 2 do
          begin
            Skins[s].Vertices[v].Weights[j].Weight := Skins[s].Vertices[v].Weights[j + 1].Weight;
            Skins[s].Vertices[v].Weights[j].BoneID := Skins[s].Vertices[v].Weights[j + 1].BoneID;
          end;
          Dec(n);
        end
        else
        Inc(w);
      end;
      if n < Skins[s].Vertices[v].WeightCount then
      begin
        SetLength(Skins[s].Vertices[v].Weights, n);
        Skins[s].Vertices[v].WeightCount := n;
      end;
    end;
    if Skins[s].MaxWeights > MaxWeights then
    Skins[s].MaxWeights := MaxWeights;
  end;
end;
//TG2MeshData END

//TG2MeshLoader BEGIN
class function TG2MeshLoader.CheckDataHeader(const DataManager: TG2DataManager; const Header: AnsiString): Boolean;
  var Pos: TG2IntS64;
  var DataHeader: AnsiString;
begin
  SetLength(DataHeader, Length(Header));
  Pos := DataManager.Position;
  DataManager.ReadBuffer(@DataHeader[1], Length(DataHeader));
  DataManager.Position := Pos;
  Result := Header = DataHeader;
end;

{$Hints off}
class function TG2MeshLoader.CanLoad(const DataManager: TG2DataManager): Boolean;
begin
  Result := False;
end;
{$Hints on}

class function TG2MeshLoader.CanLoad(const Stream: TStream): Boolean;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Stream);
  try
    Result := CanLoad(dm);
  finally
    dm.Free;
  end;
end;

class function TG2MeshLoader.CanLoad(const FileName: String): Boolean;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName);
  try
    Result := CanLoad(dm);
  finally
    dm.Free;
  end;
end;

class function TG2MeshLoader.CanLoad(const Buffer: Pointer; const Size: TG2IntS64): Boolean;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Buffer, Size);
  try
    Result := CanLoad(dm);
  finally
    dm.Free;
  end;
end;

{$Hints off}
procedure TG2MeshLoader.Load(const DataManager: TG2DataManager);
begin

end;
{$Hints on}

procedure TG2MeshLoader.Load(const Stream: TStream);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Stream);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2MeshLoader.Load(const FileName: String);
  var dm: TG2DataManager;
  var Buffer: Pointer;
  var Size: TG2IntS64;
begin
  dm := TG2DataManager.Create(FileName);
  Size := dm.Size;
  GetMem(Buffer, Size);
  dm.ReadBuffer(Buffer, Size);
  dm.Free;
  try
    Load(Buffer, Size);
  finally
    FreeMem(Buffer, Size);
  end;
end;

procedure TG2MeshLoader.Load(const Buffer: Pointer; const Size: TG2IntS64);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Buffer, Size);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;
//TG2MeshLoader END

procedure G2AddMeshLoader(const Loader: CG2MeshLoader);
begin
  SetLength(G2MeshLoaders, Length(G2MeshLoaders) + 1);
  G2MeshLoaders[High(G2MeshLoaders)] := Loader;
end;

end.
