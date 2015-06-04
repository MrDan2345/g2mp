unit G2MeshG2MX;

{-------------------------------------------------------------------------------
G2Mesh Extended Format:
  Header: AnsiString4 = "G2MX"
  Compression: UInt1 (0 - No Compression; 1 - ZLib)
  NodeCount: Int4
  GeomCount: Int4
  SkinCount: Int4
  AnimCount: Int4
  MaterialCount: Int4
  RagDollCount: Int4
  Nodes[NodeCount]:
    OwnerID: Int4
    Name: AnsiString
    Transform: Mat4x3
  Geoms[GeomCount]:
    NodeID: Int4
    SkinID: Int4
    VCount: Int4
    FCount: Int4
    TCount: Int4
    Vertices[VCount]:
      Position: Vec3
      Tangent: Vec3
      Binormal: Vec3
      Normal: Vec3
      TexCoords[TCount]: Vec2
      Color: UInt4
    Faces[FCount]:
      Indices[3]: UInt2
    Groups[MCount]:
      MaterialID: Int4
      VertexStart: Int4
      VertexCount: Int4
      FaceStart: Int4
      FaceCount: Int4
  Skins[SkinCount]:
    GeomID: Int4
    MaxWeights: Int4
    BoneCount: Int4
    Bones[BoneCount]:
      NodeID: Int4
      Bind: Mat4x3
    Vertices[Geoms[GeomID].VCount]:
      WeightCount: Int4
      Weights[WeightCount]:
        BoneID: Int4
        Weight: Int4
  Anims[AnimCount]:
    Name: AnsiString
    FrameRate: Int4
    FrameCount: Int4
    NodeCount: Int4
    Nodes[NodeCount]:
      NodeID: Int4
      Frames[FrameCount]:
        Scaling: Vec3
        Rotation: Quat
        Translation: Vec3
  Materials[MaterialCount]:
    ChannelCount: Int4
    Channels[ChannelCount]:
      Name: AnsiString
      TwoSided: Bool
      AmbientColor: UInt4
      DiffuseColor: UInt4
      SpecularColor: UInt4
      SpecularColorAmount: Float4
      SpecularPower: Float4
      EmmissiveColor: UInt4
      EmmissiveColorAmount: Float4
      AmbientMapEnable: Bool
      AmbientMap: AnsiString
      AmbientMapAmount: Float4
      DiffuseMapEnable: Bool
      DiffuseMap: AnsiString
      DiffuseMapAmount: Float4
      SpecularMapEnable: Bool
      SpecularMap: AnsiString
      SpecularMapAmount: Float4
      OpacityMapEnable: Bool
      OpacityMap: AnsiString
      OpacityMapAmount: Float4
      IlluminationMapEnable: Bool
      IlluminationMap: AnsiString
      IlluminationMapAmount: Float4
      BumpMapEnable: Bool
      BumpMap: AnsiString
      BumpMapAmount: Float4
  RagDolls[RagDollCount]:
    NodeID: Int4
    Head: RagDollObject
    Neck: RagDollObject
    Pelvis: RagDollObject
    BodyNodeCount: Int4
    BodyNodes[BodyNodeCount]: RagDollObject
    ArmRNodeCount: Int4
    ArmRNodes[ArmRNodeCount]: RagDollObject
    ArmLNodeCount: Int4
    ArmLNodes[ArmLNodeCount]: RagDollObject
    LegRNodeCount: Int4
    LegRNodes[LegRNodeCount]: RagDollObject
    LegLNodeCount: Int4
    LegLNodes[LegLNodeCount]: RagDollObject

RagDollObject:
  NodeID: Int4
  MinV: Vec3
  MaxV: Vec3
  Transform: Mat4x3
  DependantCount: Int4
  Dependants[DependantCount]:
    NodeID: Int4
    Offset: Mat4x3
-------------------------------------------------------------------------------}

interface

uses
  G2Types,
  G2Math,
  G2MeshData,
  G2DataManager;

type
  TG2MeshLoaderG2MX = class (TG2MeshLoader)
  public
    NodeCount: Integer;
    GeomCount: Integer;
    SkinCount: Integer;
    AnimCount: Integer;
    MaterialCount: Integer;
    RagDollCount: Integer;
    Nodes: array of record
      OwnerID: Integer;
      Name: AnsiString;
      Transform: TG2Mat;
    end;
    Geoms: array of record
      NodeID: Integer;
      SkinID: Integer;
      VCount: Integer;
      FCount: Integer;
      TCount: Integer;
      Vertices: array of record
        Position: TG2Vec3;
        Tangent: TG2Vec3;
        Binormal: TG2Vec3;
        Normal: TG2Vec3;
        TexCoords: array of TG2Vec2;
        Color: TG2Color;
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
    Skins: array of record
      GeomID: Integer;
      MaxWeights: Integer;
      BoneCount: Integer;
      Bones: array of record
        NodeID: Integer;
        Bind: TG2Mat;
        BBox: TG2Box;
      end;
      Vertices: array of record
        WeightCount: Integer;
        Weights: array of record
          BoneID: Integer;
          Weight: Integer;
        end;
      end;
    end;
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
    Materials: array of record
      ChannelCount: Integer;
      Channels: array of record
        Name: AnsiString;
        TwoSided: Boolean;
        AmbientColor: TG2Color;
        DiffuseColor: TG2Color;
        SpecularColor: TG2Color;
        SpecularColorAmount: TG2Float;
        SpecularPower: TG2Float;
        EmmissiveColor: TG2Color;
        EmmissiveColorAmount: TG2Float;
        AmbientMapEnable: Boolean;
        AmbientMap: AnsiString;
        AmbientMapAmount: TG2Float;
        DiffuseMapEnable: Boolean;
        DiffuseMap: AnsiString;
        DiffuseMapAmount: TG2Float;
        SpecularMapEnable: Boolean;
        SpecularMap: AnsiString;
        SpecularMapAmount: TG2Float;
        OpacityMapEnable: Boolean;
        OpacityMap: AnsiString;
        OpacityMapAmount: TG2Float;
        IlluminationMapEnable: Boolean;
        IlluminationMap: AnsiString;
        IlluminationMapAmount: TG2Float;
        BumpMapEnable: Boolean;
        BumpMap: AnsiString;
        BumpMapAmount: TG2Float;
      end;
    end;
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
    function CanLoad(const DataManager: TG2DataManager): Boolean; override;
    procedure Load(const DataManager: TG2DataManager); override;
    procedure ExportMeshData(const MeshData: PG2MeshData); override;
  end;

implementation

//TG2MeshLoaderG2MX BEGIN
function TG2MeshLoaderG2MX.CanLoad(const DataManager: TG2DataManager): Boolean;
begin
  Result := CheckDataHeader(DataManager, 'G2MX');
end;

{$Hints off}
procedure TG2MeshLoaderG2MX.Load(const DataManager: TG2DataManager);
begin

end;
{$Hints on}

{$Hints off}
procedure TG2MeshLoaderG2MX.ExportMeshData(const MeshData: PG2MeshData);
begin

end;
{$Hints on}
//TG2MeshLoaderG2MX END

end.
