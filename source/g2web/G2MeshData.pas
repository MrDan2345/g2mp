unit G2MeshData;

//The contents of this software are used with permission, subject to
//the Mozilla Public License Version 1.1 (the "License"); you may
//not use this software except in compliance with the License. You may
//obtain a copy of the License at
//http://www.mozilla.org/MPL/MPL-1.1.html
//
//Software distributed under the License is distributed on an
//"AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
//implied. See the License for the specific language governing
//rights and limitations under the License.
//
//This module is a part of g2mp game development framework.

interface

uses
  G2Types,
  G2Math,
  G2DataManager;

type
  TG2RagdollObject = class
  public
    NodeID: Integer;
    MinV, MaxV: TG2Vec3;
    Transform: TG2Mat;
    DependantCount: Integer;
    Dependants: array of record
      NodeID: Integer;
      Offset: TG2Mat;
    end;
  end;

  TG2MeshData = class
  public
    NodeCount: Integer;
    Nodes: array of record
      OwnerID: Integer;
      Name: String;
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
        Color: TG2Vec4;
      end;
      Faces: array of array[0..2] of Integer;
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
          Weight: TG2Float;
        end;
      end;
    end;
    AnimCount: Integer;
    Anims: array of record
      Name: String;
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
        Name: String;
        TwoSided: Boolean;
        AmbientColor: TG2Vec4;
        DiffuseColor: TG2Vec4;
        SpecularColor: TG2Vec4;
        SpecularColorAmount: TG2Float;
        SpecularPower: TG2Float;
        EmmissiveColor: TG2Vec4;
        EmmissiveColorAmount: TG2Float;
        AmbientMapEnable: Boolean;
        AmbientMap: String;
        AmbientMapAmount: TG2Float;
        DiffuseMapEnable: Boolean;
        DiffuseMap: String;
        DiffuseMapAmount: TG2Float;
        SpecularMapEnable: Boolean;
        SpecularMap: String;
        SpecularMapAmount: TG2Float;
        OpacityMapEnable: Boolean;
        OpacityMap: String;
        OpacityMapAmount: TG2Float;
        LightMapEnable: Boolean;
        LightMap: String;
        LightMapAmount: TG2Float;
        NormalMapEnable: Boolean;
        NormalMap: String;
        NormalMapAmount: TG2Float;
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
    constructor Create;
    destructor Destroy; override;
    procedure LimitSkins(MaxWeights: Integer = 4);
  end;

  TG2MeshLoader = class
  protected
    class function CheckDataHeader(const DataManager: TG2DataManager; const Header: String): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    class function CanLoad(const DataManager: TG2DataManager): Boolean; virtual;
    procedure Load(const DataManager: TG2DataManager); virtual; abstract;
    function ExportMeshData: TG2MeshData; virtual; abstract;
  end;

  CG2MeshLoader = class of TG2MeshLoader;

var G2MeshLoaders: array of CG2MeshLoader;

procedure G2AddMeshLoader(const MeshLoaderClass: CG2MeshLoader);

implementation

//TG2MeshData BEGIN
constructor TG2MeshData.Create;
begin
  inherited Create;
  NodeCount := 0;
  GeomCount := 0;
  SkinCount := 0;
  AnimCount := 0;
  MaterialCount := 0;
  RagDollCount := 0;
end;

destructor TG2MeshData.Destroy;
  var i, j: Integer;
begin
  for i := 0 to RagDollCount - 1 do
  begin
    RagDolls[i].Head.Free;
    RagDolls[i].Neck.Free;
    RagDolls[i].Pelvis.Free;
    for j := 0 to RagDolls[i].BodyNodeCount - 1 do
    RagDolls[i].BodyNodes[j].Free;
    for j := 0 to RagDolls[i].ArmLNodeCount - 1 do
    RagDolls[i].ArmLNodes[j].Free;
    for j := 0 to RagDolls[i].ArmRNodeCount - 1 do
    RagDolls[i].ArmRNodes[j].Free;
    for j := 0 to RagDolls[i].LegLNodeCount - 1 do
    RagDolls[i].LegLNodes[j].Free;
    for j := 0 to RagDolls[i].LegRNodeCount - 1 do
    RagDolls[i].LegRNodes[j].Free;
  end;
  inherited Destroy;
end;

procedure TG2MeshData.LimitSkins(MaxWeights: Integer = 4);
  var s, v, w, n, i, j, m, CurWeights: Integer;
  var TotalWeight: TG2Float;
  var WeightsRemap: array of record
    Weight: TG2Float;
    Index: Integer;
  end;
begin
  WeightsRemap.SetLength(0);
  for s := 0 to SkinCount - 1 do
  begin
    for v := 0 to High(Skins[s].Vertices) do
    begin
      if Skins[s].Vertices[v].WeightCount > MaxWeights then
      begin
        if Skins[s].Vertices[v].WeightCount > Length(WeightsRemap) then
        WeightsRemap.SetLength(Skins[s].Vertices[v].WeightCount);
        CurWeights := 0;
        for w := 0 to Skins[s].Vertices[v].WeightCount - 1 do
        begin
          n := CurWeights;
          for i := 0 to CurWeights - 1 do
          if WeightsRemap[i].Weight < Skins[s].Vertices[v].Weights[w].Weight then
          begin
            n := i;
            for m := 0 to CurWeights - i do
            WeightsRemap[i + 1] := WeightsRemap[i];
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
        Skins[s].Vertices[v].Weights.SetLength(MaxWeights);
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
        Skins[s].Vertices[v].Weights.SetLength(n);
        Skins[s].Vertices[v].WeightCount := n;
      end;
    end;
    if Skins[s].MaxWeights > MaxWeights then
    Skins[s].MaxWeights := MaxWeights;
  end;
end;
//TG2MeshData END

//TG2MeshLoader BEGIN
class function TG2MeshLoader.CheckDataHeader(const DataManager: TG2DataManager; const Header: String): Boolean;
  var Pos: Integer;
  var DataHeader: String;
begin
  Pos := DataManager.Position;
  DataHeader := DataManager.ReadString(Length(Header));
  DataManager.Position := Pos;
  Result := Header = DataHeader;
end;

constructor TG2MeshLoader.Create;
begin
  inherited Create;
end;

destructor TG2MeshLoader.Destroy;
begin
  inherited Destroy;
end;

class function TG2MeshLoader.CanLoad(const DataManager: TG2DataManager): Boolean;
begin
  Result := False;
end;
//TG2MeshLoader END

procedure G2AddMeshLoader(const MeshLoaderClass: CG2MeshLoader);
begin
  G2MeshLoaders.SetLength(Length(G2MeshLoaders) + 1);
  G2MeshLoaders[High(G2MeshLoaders)] := MeshLoaderClass;
end;

end.
