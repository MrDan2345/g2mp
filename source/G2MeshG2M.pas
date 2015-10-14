unit G2MeshG2M;

{-------------------------------------------------------------------------------
G2Mesh Format:
  Header: AnsiString4 = "G2M "

  Blocks:
    Block Name: AnsiString4
    Block Size: Int4

  Block "NMAP":
    NodeCount: Int4
    NodeOffsets[NodeCount]: Int4

  Block "NDAT":
    Nodes[NodeCount]:
      OwnerID: Int4
      NodeName: AnsiStringNT
      NodeTransform: Mat4x3

  Block "GMAP":
    GeomCount: Int4
    GeomOffsets[GeomCount]: Int4

  Block "GDAT":
    Geoms[GeomCount]:
      NodeID: Int4
      VCount: Int4
      CCount: Int4
      FCount: Int4
      MCount: Int4
      TCount: Int4
      Positions[VCount]: Vec3f
      Colors[CCount]: Col3
      TexChannels[TCount]:
        TVCount: Int4
        TexCoords[TVCount]: Vec2f
      Materials[MCount]: Int4
      Faces[FCount]:
        FaceVertices: Vec3i
        FaceColors: Vec3i
        FaceTexCoords[TCount]: Vec3i
        FaceGroup: Int4
        FaceMaterial: Int4

  Block "AMAP":
    AnimCount: Int4
    AnimOffsets[AnimCount]: Int4

  Block "ADAT":
    Animations[AnimCount]:
      Name: AnsiStringNT
      FrameCount: Int4
      FPS: Int4
      AnimNodeCount: Int4
      AnimNodes[AnimNodeCount]:
        NodeID: Int4
        Frames[FrameCount]:
          FrameTransform: Mat4x3

  Block "SMAP":
    SkinCount: Int4
    SkinOffsets[SkinCount]: Int4

  Block "SDAT":
    Skins[SkinCount]:
      GeomID: Int4
      BoneCount: Int4
      Bones[BoneCount]:
        NodeID: Int4
        Bind: Mat4x3
      Vertices[Geoms[GeomID].VCount]:
        WeightCount: Int4
        Weights[WeightCount]:
          BoneID: Int4
          Weight: Float4

  Block "MMAP":
    MaterialCount: Int4
    MaterialOffsets[MaterialCount]: Int4

  Block "MDAT":
    Materials[MaterialCount]:
      ChannelCount: Int4
      Channels[ChannelCount]:
        MatName: AnsiStringNT
        TwoSided: Bool
        AmbientColor: Byte[3]
        DiffuseColor: Byte[3]
        SpecularColor: Byte[3]
        SpecularColorAmount: Float4
        SpecularPower: Float4
        EmmissiveColor: Byte[3]
        EmmissiveColorAmount: Float4
        AmbientMapEnable: Bool
        AmbientMap: AnsiStringNT
        AmbientMapAmount: Float4
        DiffuseMapEnable: Bool
        DiffuseMap: AnsiStringNT
        DiffuseMapAmount: Float4
        SpecularMapEnable: Bool
        SpecularMap: AnsiStringNT
        SpecularMapAmount: Float4
        OpacityMapEnable: Bool
        OpacityMap: AnsiStringNT
        OpacityMapAmount: Float4
        IlluminationMapEnable: Bool
        IlluminationMap: AnsiStringNT
        IlluminationMapAmount: Float4
        BumpMapEnable: Bool
        BumpMap: AnsiStringNT
        BumpMapAmount: Float4

  Block "LMAP":
    LightCount: Int4
    LightOffsets[LightCount]: Int4

  Block "LDAT":
    NodeID: Int4
    LightType: UInt1
    Enabled: Bool
    Color: UInt3
    AttStart: Float4
    AttEnd: Float4
    SpotInner: Float4
    SpotOutter: Float4
    WidthInner: Float4
    WidthOutter: Float4
    HeightInner: Float4
    HeightOutter: Float4

  Block "RGDL":
    RagdollCount: Int4
      Ragdolls[RagdollCount]:
        NodeID: Int4
        Head: RagdollObject
        Neck: RagdollObject
        Pelvis: RagdollObject
        BodyNodeCount: Int4
        BodyNodes[BodyNodeCount]: RagdollObject
        ArmRNodeCount: Int4
        ArmRNodes[ArmRNodeCount]: RagdollObject
        ArmLNodeCount: Int4
        ArmLNodes[ArmLNodeCount]: RagdollObject
        LegRNodeCount: Int4
        LegRNodes[LegRNodeCount]: RagdollObject
        LegLNodeCount: Int4
        LegLNodes[LegLNodeCount]: RagdollObject
--------------------------------------------------------------------------------
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
  SysUtils,
  G2Types,
  G2Utils,
  G2Math,
  G2MeshData,
  G2DataManager;

type
  TG2MeshLoaderG2M = class (TG2MeshLoader)
  public
    NodeCount: TG2IntS32;
    Nodes: array of record
      OwnerID: TG2IntS32;
      Name: AnsiString;
      Transform: TG2Mat;
    end;
    GeomCount: TG2IntS32;
    Geoms: array of record
      NodeID: TG2IntS32;
      VCount: TG2IntS32;
      CCount: TG2IntS32;
      FCount: TG2IntS32;
      MCount: TG2IntS32;
      TCount: TG2IntS32;
      Vertices: array of TG2Vec3;
      Colors: array of TG2Color;
      TexChannels: array of record
        TVCount: TG2IntS32;
        TexCoords: array of TG2Vec2;
      end;
      Materials: array of TG2IntS32;
      Faces: array of record
        FaceVertices: array[0..2] of TG2IntS32;
        FaceColors: array[0..2] of TG2IntS32;
        FaceTexCoords: array of array[0..2] of TG2IntS32;
        FaceGroup: TG2IntS32;
        FaceMaterial: TG2IntS32;
      end;
    end;
    AnimCount: TG2IntS32;
    Anims: array of record
      Name: AnsiString;
      FrameCount: TG2IntS32;
      FPS: TG2IntS32;
      AnimNodeCount: TG2IntS32;
      AnimNodes: array of record
        NodeID: TG2IntS32;
        Frames: array of TG2Mat;
      end;
    end;
    SkinCount: TG2IntS32;
    Skins: array of record
      GeomID: TG2IntS32;
      BoneCount: TG2IntS32;
      Bones: array of record
        NodeID: TG2IntS32;
        Bind: TG2Mat;
      end;
      Vertices: array of record
        WeightCount: TG2IntS32;
        Weights: array of record
          BoneID: TG2IntS32;
          Weight: TG2Float;
        end;
      end;
    end;
    MaterialCount: TG2IntS32;
    Materials: array of record
      ChannelCount: TG2IntS32;
      Channels: array of record
        MatName: AnsiString;
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
    LightCount: TG2IntS32;
    Lights: array of record
      NodeID: TG2IntS32;
      LightType: TG2IntU8;
      Enabled: Boolean;
      Color: TG2Color;
      AttStart: TG2Float;
      AttEnd: TG2Float;
      SpotInner: TG2Float;
      SpotOutter: TG2Float;
      WidthInner: TG2Float;
      WidthOutter: TG2Float;
      HeightInner: TG2Float;
      HeightOutter: TG2Float;
    end;
    RagDollCount: TG2IntS32;
    RagDolls: array of record
      NodeID: TG2IntS32;
      Head: TG2RagdollObject;
      Neck: TG2RagdollObject;
      Pelvis: TG2RagdollObject;
      BodyNodeCount: TG2IntS32;
      BodyNodes: array of TG2RagdollObject;
      ArmRNodeCount: TG2IntS32;
      ArmRNodes: array of TG2RagdollObject;
      ArmLNodeCount: TG2IntS32;
      ArmLNodes: array of TG2RagdollObject;
      LegRNodeCount: TG2IntS32;
      LegRNodes: array of TG2RagdollObject;
      LegLNodeCount: TG2IntS32;
      LegLNodes: array of TG2RagdollObject;
    end;
    class function CanLoad(const DataManager: TG2DataManager): Boolean; override;
    procedure Load(const DataManager: TG2DataManager); override;
    procedure ExportMeshData(const MeshData: PG2MeshData); override;
  end;

implementation

uses
  Gen2MP;

//TG2MeshLoaderG2M BEGIN
class function TG2MeshLoaderG2M.CanLoad(const DataManager: TG2DataManager): Boolean;
begin
  Result := CheckDataHeader(DataManager, 'G2M ');
end;

procedure TG2MeshLoaderG2M.Load(const DataManager: TG2DataManager);
  type TBlockName = array[0..3] of AnsiChar;
  var StartPos: TG2IntS64;
  function FindBlock(const BlockName: TBlockName): Boolean;
    type TBlock = packed record
      BlockName: TBlockName;
      BlockSize: TG2IntS32;
    end;
    var Block: TBlock;
  begin
    DataManager.Position := StartPos;
    while DataManager.Position < DataManager.Size - SizeOf(TBlock) do
    begin
      DataManager.ReadBuffer(@Block, SizeOf(TBlock));
      if Block.BlockName = BlockName then
      begin
        Result := True;
        Exit;
      end
      else
      begin
        DataManager.Position := DataManager.Position + Block.BlockSize;
      end;
    end;
    Result := False;
  end;
  procedure LoadRagdollObject(const ro: PG2RagdollObject);
    var i: Integer;
  begin
    ro^.NodeID := DataManager.ReadIntS32;
    ro^.MinV := DataManager.ReadVec3;
    ro^.MaxV := DataManager.ReadVec3;
    ro^.Transform := DataManager.ReadMat4x3;
    ro^.DependantCount := DataManager.ReadIntS32;
    SetLength(ro^.Dependants, ro^.DependantCount);
    for i := 0 to ro^.DependantCount - 1 do
    begin
      ro^.Dependants[i].NodeID := DataManager.ReadIntS32;
      ro^.Dependants[i].Offset := DataManager.ReadMat4x3;
    end;
  end;
  var Header: array[0..3] of AnsiChar;
  var i, j, n: TG2IntS32;
begin
  DataManager.ReadBuffer(@Header, 4);
  if Header <> 'G2M ' then Exit;
  StartPos := DataManager.Position;
  if not FindBlock('NMAP') then Exit;
  NodeCount := DataManager.ReadIntS32;
  SetLength(Nodes, NodeCount);
  if not FindBlock('NDAT') then Exit;
  for i := 0 to NodeCount - 1 do
  begin
    Nodes[i].OwnerID := DataManager.ReadIntS32;
    Nodes[i].Name := DataManager.ReadStringANT;
    Nodes[i].Transform := DataManager.ReadMat4x3;
  end;
  if FindBlock('GMAP') then
  begin
    GeomCount := DataManager.ReadIntS32;
    SetLength(Geoms, GeomCount);
    if FindBlock('GDAT') then
    for i := 0 to GeomCount - 1 do
    begin
      Geoms[i].NodeID := DataManager.ReadIntS32;
      Geoms[i].VCount := DataManager.ReadIntS32;
      Geoms[i].CCount := DataManager.ReadIntS32;
      Geoms[i].FCount := DataManager.ReadIntS32;
      Geoms[i].MCount := DataManager.ReadIntS32;
      Geoms[i].TCount := DataManager.ReadIntS32;
      SetLength(Geoms[i].Vertices, Geoms[i].VCount);
      DataManager.ReadBuffer(@Geoms[i].Vertices[0], TG2IntS64(Geoms[i].VCount) * 12);
      SetLength(Geoms[i].Colors, Geoms[i].CCount);
      for j := 0 to Geoms[i].CCount - 1 do
      begin
        Geoms[i].Colors[j].r := DataManager.ReadIntU8;
        Geoms[i].Colors[j].g := DataManager.ReadIntU8;
        Geoms[i].Colors[j].b := DataManager.ReadIntU8;
        Geoms[i].Colors[j].a := $ff;
      end;
      SetLength(Geoms[i].TexChannels, Geoms[i].TCount);
      for j := 0 to Geoms[i].TCount - 1 do
      begin
        Geoms[i].TexChannels[j].TVCount := DataManager.ReadIntS32;
        SetLength(Geoms[i].TexChannels[j].TexCoords, Geoms[i].TexChannels[j].TVCount);
        for n := 0 to Geoms[i].TexChannels[j].TVCount - 1 do
        Geoms[i].TexChannels[j].TexCoords[n] := DataManager.ReadVec2;
      end;
      SetLength(Geoms[i].Materials, Geoms[i].MCount);
      DataManager.ReadBuffer(@Geoms[i].Materials[0], TG2IntS64(Geoms[i].MCount) * 4);
      SetLength(Geoms[i].Faces, Geoms[i].FCount);
      for j := 0 to Geoms[i].FCount - 1 do
      begin
        SetLength(Geoms[i].Faces[j].FaceTexCoords, Geoms[i].TCount);
        DataManager.ReadBuffer(@Geoms[i].Faces[j].FaceVertices, 12);
        DataManager.ReadBuffer(@Geoms[i].Faces[j].FaceColors, 12);
        DataManager.ReadBuffer(@Geoms[i].Faces[j].FaceTexCoords[0], TG2IntS64(Geoms[i].TCount) * 12);
        Geoms[i].Faces[j].FaceGroup := DataManager.ReadIntS32;
        Geoms[i].Faces[j].FaceMaterial := DataManager.ReadIntS32;
      end;
    end;
  end;
  if FindBlock('AMAP') then
  begin
    AnimCount := DataManager.ReadIntS32;
    SetLength(Anims, AnimCount);
    if FindBlock('ADAT') then
    for i := 0 to AnimCount - 1 do
    begin
      Anims[i].Name := DataManager.ReadStringANT;
      Anims[i].FrameCount := DataManager.ReadIntS32;
      Anims[i].FPS := DataManager.ReadIntS32;
      Anims[i].AnimNodeCount := DataManager.ReadIntS32;
      SetLength(Anims[i].AnimNodes, Anims[i].AnimNodeCount);
      for j := 0 to Anims[i].AnimNodeCount - 1 do
      begin
        Anims[i].AnimNodes[j].NodeID := DataManager.ReadIntS32;
        SetLength(Anims[i].AnimNodes[j].Frames, Anims[i].FrameCount);
        for n := 0 to Anims[i].FrameCount - 1 do
        Anims[i].AnimNodes[j].Frames[n] := DataManager.ReadMat4x3;
      end;
    end;
  end;
  if FindBlock('SMAP') then
  begin
    SkinCount := DataManager.ReadIntS32;
    SetLength(Skins, SkinCount);
    if FindBlock('SDAT') then
    for i := 0 to SkinCount - 1 do
    begin
      Skins[i].GeomID := DataManager.ReadIntS32;
      Skins[i].BoneCount := DataManager.ReadIntS32;
      SetLength(Skins[i].Bones, Skins[i].BoneCount);
      for j := 0 to Skins[i].BoneCount - 1 do
      begin
        Skins[i].Bones[j].NodeID := DataManager.ReadIntS32;
        Skins[i].Bones[j].Bind := DataManager.ReadMat4x3;
      end;
      SetLength(Skins[i].Vertices, Geoms[Skins[i].GeomID].VCount);
      for j := 0 to Geoms[Skins[i].GeomID].VCount - 1 do
      begin
        Skins[i].Vertices[j].WeightCount := DataManager.ReadIntS32;
        SetLength(Skins[i].Vertices[j].Weights, Skins[i].Vertices[j].WeightCount);
        for n := 0 to Skins[i].Vertices[j].WeightCount - 1 do
        begin
          Skins[i].Vertices[j].Weights[n].BoneID := DataManager.ReadIntS32;
          Skins[i].Vertices[j].Weights[n].Weight := DataManager.ReadFloat;
        end;
      end;
    end;
  end;
  if FindBlock('MMAP') then
  begin
    MaterialCount := DataManager.ReadIntS32;
    SetLength(Materials, MaterialCount);
    if FindBlock('MDAT') then
    for i := 0 to MaterialCount - 1 do
    begin
      Materials[i].ChannelCount := DataManager.ReadIntS32;
      SetLength(Materials[i].Channels, Materials[i].ChannelCount);
      for j := 0 to Materials[i].ChannelCount - 1 do
      begin
        Materials[i].Channels[j].MatName := DataManager.ReadStringANT;
        Materials[i].Channels[j].TwoSided := DataManager.ReadBool;
        Materials[i].Channels[j].AmbientColor.r := DataManager.ReadIntU8;
        Materials[i].Channels[j].AmbientColor.g := DataManager.ReadIntU8;
        Materials[i].Channels[j].AmbientColor.b := DataManager.ReadIntU8;
        Materials[i].Channels[j].AmbientColor.a := $ff;
        Materials[i].Channels[j].DiffuseColor.r := DataManager.ReadIntU8;
        Materials[i].Channels[j].DiffuseColor.g := DataManager.ReadIntU8;
        Materials[i].Channels[j].DiffuseColor.b := DataManager.ReadIntU8;
        Materials[i].Channels[j].DiffuseColor.a := $ff;
        Materials[i].Channels[j].SpecularColor.r := DataManager.ReadIntU8;
        Materials[i].Channels[j].SpecularColor.g := DataManager.ReadIntU8;
        Materials[i].Channels[j].SpecularColor.b := DataManager.ReadIntU8;
        Materials[i].Channels[j].SpecularColor.a := $ff;
        Materials[i].Channels[j].SpecularColorAmount := DataManager.ReadFloat;
        Materials[i].Channels[j].SpecularPower := DataManager.ReadFloat;
        Materials[i].Channels[j].EmmissiveColor.r := DataManager.ReadIntU8;
        Materials[i].Channels[j].EmmissiveColor.g := DataManager.ReadIntU8;
        Materials[i].Channels[j].EmmissiveColor.b := DataManager.ReadIntU8;
        Materials[i].Channels[j].EmmissiveColor.a := $ff;
        Materials[i].Channels[j].EmmissiveColorAmount := DataManager.ReadFloat;
        Materials[i].Channels[j].AmbientMapEnable := DataManager.ReadBool;
        Materials[i].Channels[j].AmbientMap := DataManager.ReadStringANT;
        Materials[i].Channels[j].AmbientMapAmount := DataManager.ReadFloat;
        Materials[i].Channels[j].DiffuseMapEnable := DataManager.ReadBool;
        Materials[i].Channels[j].DiffuseMap := DataManager.ReadStringANT;
        Materials[i].Channels[j].DiffuseMapAmount := DataManager.ReadFloat;
        Materials[i].Channels[j].SpecularMapEnable := DataManager.ReadBool;
        Materials[i].Channels[j].SpecularMap := DataManager.ReadStringANT;
        Materials[i].Channels[j].SpecularMapAmount := DataManager.ReadFloat;
        Materials[i].Channels[j].OpacityMapEnable := DataManager.ReadBool;
        Materials[i].Channels[j].OpacityMap := DataManager.ReadStringANT;
        Materials[i].Channels[j].OpacityMapAmount := DataManager.ReadFloat;
        Materials[i].Channels[j].IlluminationMapEnable := DataManager.ReadBool;
        Materials[i].Channels[j].IlluminationMap := DataManager.ReadStringANT;
        Materials[i].Channels[j].IlluminationMapAmount := DataManager.ReadFloat;
        Materials[i].Channels[j].BumpMapEnable := DataManager.ReadBool;
        Materials[i].Channels[j].BumpMap := DataManager.ReadStringANT;
        Materials[i].Channels[j].BumpMapAmount := DataManager.ReadFloat;
      end;
    end;
  end;
  if FindBlock('LMAP') then
  begin
    LightCount := DataManager.ReadIntS32;
    SetLength(Lights, LightCount);
    if FindBlock('LDAT') then
    for i := 0 to LightCount - 1 do
    begin
      Lights[i].NodeID := DataManager.ReadIntS32;
      Lights[i].LightType := DataManager.ReadIntU8;
      Lights[i].Enabled := DataManager.ReadBool;
      Lights[i].Color.r := DataManager.ReadIntU8;
      Lights[i].Color.g := DataManager.ReadIntU8;
      Lights[i].Color.b := DataManager.ReadIntU8;
      Lights[i].Color.a := $ff;
      Lights[i].AttStart := DataManager.ReadFloat;
      Lights[i].AttEnd := DataManager.ReadFloat;
      Lights[i].SpotInner := DataManager.ReadFloat;
      Lights[i].SpotOutter := DataManager.ReadFloat;
      Lights[i].WidthInner := DataManager.ReadFloat;
      Lights[i].WidthOutter := DataManager.ReadFloat;
      Lights[i].HeightInner := DataManager.ReadFloat;
      Lights[i].HeightOutter := DataManager.ReadFloat;
    end;
  end;
  if FindBlock('RGDL') then
  begin
    RagDollCount := DataManager.ReadIntS32;
    SetLength(RagDolls, RagDollCount);
    for i := 0 to RagDollCount - 1 do
    begin
      RagDolls[i].NodeID := DataManager.ReadIntS32;
      LoadRagdollObject(@RagDolls[i].Head);
      LoadRagdollObject(@RagDolls[i].Neck);
      LoadRagdollObject(@RagDolls[i].Pelvis);
      RagDolls[i].BodyNodeCount := DataManager.ReadIntS32;
      SetLength(RagDolls[i].BodyNodes, RagDolls[i].BodyNodeCount);
      for j := 0 to RagDolls[i].BodyNodeCount - 1 do
      LoadRagdollObject(@RagDolls[i].BodyNodes[j]);
      RagDolls[i].ArmRNodeCount := DataManager.ReadIntS32;
      SetLength(RagDolls[i].ArmRNodes, RagDolls[i].ArmRNodeCount);
      for j := 0 to RagDolls[i].ArmRNodeCount - 1 do
      LoadRagdollObject(@RagDolls[i].ArmRNodes[j]);
      RagDolls[i].ArmLNodeCount := DataManager.ReadIntS32;
      SetLength(RagDolls[i].ArmLNodes, RagDolls[i].ArmLNodeCount);
      for j := 0 to RagDolls[i].ArmLNodeCount - 1 do
      LoadRagdollObject(@RagDolls[i].ArmLNodes[j]);
      RagDolls[i].LegRNodeCount := DataManager.ReadIntS32;
      SetLength(RagDolls[i].LegRNodes, RagDolls[i].LegRNodeCount);
      for j := 0 to RagDolls[i].LegRNodeCount - 1 do
      LoadRagdollObject(@RagDolls[i].LegRNodes[j]);
      RagDolls[i].LegLNodeCount := DataManager.ReadIntS32;
      SetLength(RagDolls[i].LegLNodes, RagDolls[i].LegLNodeCount);
      for j := 0 to RagDolls[i].LegLNodeCount - 1 do
      LoadRagdollObject(@RagDolls[i].LegLNodes[j]);
    end;
  end;
end;

procedure TG2MeshLoaderG2M.ExportMeshData(const MeshData: PG2MeshData);
  type TVertex = record
    PosID: TG2IntS32;
    ColorID: TG2IntS32;
    TexCoordID: array of TG2IntS32;
    GroupID: TG2IntS32;
    MaterialID: TG2IntS32;
    Normal: TG2Vec3;
    Mapped: Boolean;
    Remap: TG2IntU32;
  end;
  type TFace = record
    Material: TG2IntS32;
    Indices: array[0..2] of TG2IntU16;
    Mapped: Boolean;
  end;
  type TGroup = record
    Material: TG2IntS32;
    VertexStart: TG2IntS32;
    VertexCount: TG2IntS32;
    FaceStart: TG2IntS32;
    FaceCount: TG2IntS32;
  end;
  var VCount: TG2IntS32;
  var Vertices: array of TVertex;
  var FCount: TG2IntS32;
  var Faces: array of TFace;
  var GCount: TG2IntS32;
  var Groups: array of TGroup;
  var TmpFaces: array of TFace;
  var TmpVertices: array of TVertex;
  function AddVertex(
    const PosID, ColorID, GroupID, MaterialID, TexCount: TG2IntS32;
    const TexCoordID: PG2IntS32Arr; const Normal: TG2Vec3
  ): TG2IntS32;
    var i, j: TG2IntS32;
  begin
    Result := -1;
    for i := 0 to VCount - 1 do
    begin
      if (TmpVertices[i].PosID = PosID)
      and (TmpVertices[i].ColorID = ColorID)
      and (TmpVertices[i].GroupID = GroupID)
      and (TmpVertices[i].MaterialID = MaterialID) then
      begin
        Result := i;
        for j := 0 to TexCount - 1 do
        if TmpVertices[i].TexCoordID[j] <> TexCoordID^[j * 3] then
        begin
          Result := -1;
          Break;
        end;
        if Result > -1 then
        begin
          TmpVertices[Result].Normal := TmpVertices[Result].Normal + Normal;
          Break;
        end;
      end;
    end;
    if Result = -1 then
    begin
      if VCount >= High(TmpVertices) then
      SetLength(TmpVertices, Length(TmpVertices) + 1024);
      Result := VCount;
      SetLength(TmpVertices[Result].TexCoordID, TexCount);
      TmpVertices[Result].PosID := PosID;
      TmpVertices[Result].ColorID := ColorID;
      TmpVertices[Result].GroupID := GroupID;
      TmpVertices[Result].MaterialID := MaterialID;
      for i := 0 to TexCount - 1 do
      TmpVertices[Result].TexCoordID[i] := TexCoordID^[i * 3];
      TmpVertices[Result].Normal := Normal;
      Inc(VCount);
    end;
  end;
  procedure AddFace(const GeomID, FaceID: Integer);
    var Normal, v0, v1, v2: TG2Vec3;
  begin
    if FCount >= High(TmpFaces) then
    SetLength(TmpFaces, Length(TmpFaces) + 1024);
    v0 := Geoms[GeomID].Vertices[Geoms[GeomID].Faces[FaceID].FaceVertices[0]];
    v1 := Geoms[GeomID].Vertices[Geoms[GeomID].Faces[FaceID].FaceVertices[1]];
    v2 := Geoms[GeomID].Vertices[Geoms[GeomID].Faces[FaceID].FaceVertices[2]];
    Normal := G2TriangleNormal(
      Geoms[GeomID].Vertices[Geoms[GeomID].Faces[FaceID].FaceVertices[0]],
      Geoms[GeomID].Vertices[Geoms[GeomID].Faces[FaceID].FaceVertices[1]],
      Geoms[GeomID].Vertices[Geoms[GeomID].Faces[FaceID].FaceVertices[2]]
    );
    TmpFaces[FCount].Indices[0] := AddVertex(
      Geoms[GeomID].Faces[FaceID].FaceVertices[0],
      Geoms[GeomID].Faces[FaceID].FaceColors[0],
      Geoms[GeomID].Faces[FaceID].FaceGroup,
      Geoms[GeomID].Faces[FaceID].FaceMaterial,
      Geoms[GeomID].TCount,
      @Geoms[GeomID].Faces[FaceID].FaceTexCoords[0][0],
      Normal
    );
    TmpFaces[FCount].Indices[1] := AddVertex(
      Geoms[GeomID].Faces[FaceID].FaceVertices[1],
      Geoms[GeomID].Faces[FaceID].FaceColors[1],
      Geoms[GeomID].Faces[FaceID].FaceGroup,
      Geoms[GeomID].Faces[FaceID].FaceMaterial,
      Geoms[GeomID].TCount,
      @Geoms[GeomID].Faces[FaceID].FaceTexCoords[0][1],
      Normal
    );
    TmpFaces[FCount].Indices[2] := AddVertex(
      Geoms[GeomID].Faces[FaceID].FaceVertices[2],
      Geoms[GeomID].Faces[FaceID].FaceColors[2],
      Geoms[GeomID].Faces[FaceID].FaceGroup,
      Geoms[GeomID].Faces[FaceID].FaceMaterial,
      Geoms[GeomID].TCount,
      @Geoms[GeomID].Faces[FaceID].FaceTexCoords[0][2],
      Normal
    );
    TmpFaces[FCount].Material := Geoms[GeomID].Faces[FaceID].FaceMaterial;
    Inc(FCount);
  end;
  var Adj: array of TG2IntS32;
  procedure GenerateAdjacency;
    function CompareEdges(const e0i0, e0i1, e1i0, e1i1: TG2IntU16): Boolean;
    begin
      Result := (
        ((e0i0 = e1i0) and (e0i1 = e1i1))
        or
        ((e0i1 = e1i0) and (e0i0 = e1i1))
      );
    end;
    var i, j, e0, e1, e0i0, e0i1, e1i0, e1i1: Integer;
    var r: Boolean;
  begin
    if Length(Adj) < FCount * 3 then
    SetLength(Adj, FCount * 3);
    for i := 0 to FCount * 3 - 1 do
    Adj[i] := -1;
    for i := 0 to FCount - 1 do
    for j := i + 1 to FCount - 1 do
    begin
      r := False;
      for e0 := 0 to 2 do
      begin
        for e1 := 0 to 2 do
        begin
          e0i0 := e0;
          e0i1 := (e0 + 1) mod 3;
          e1i0 := e1;
          e1i1 := (e1 + 1) mod 3;
          if CompareEdges(
            TmpFaces[i].Indices[e0i0], TmpFaces[i].Indices[e0i1],
            TmpFaces[j].Indices[e1i0], TmpFaces[j].Indices[e1i1]
          ) then
          begin
            Adj[i * 3 + e0] := j;
            Adj[j * 3 + e1] := i;
          end;
        end;
        if r then Break;
      end;
    end;
  end;
  var FaceRemap0: TG2QuickSortListIntS32;
  var FaceRemap1: TG2QuickListIntS32;
  var VertexRemap0: TG2QuickListIntU16;
  procedure Optimize;
    procedure MapFace(const f: TG2IntS32);
      var i, af: TG2IntS32;
    begin
      TmpFaces[f].Mapped := True;
      FaceRemap1.Add(f);
      for i := 0 to 2 do
      begin
        if Adj[f * 3 + i] > -1 then
        begin
          af := Adj[f * 3 + i];
          if not TmpFaces[af].Mapped then
          begin
            FaceRemap0.Remove(af);
            MapFace(af);
          end;
        end;
      end;
    end;
    var i, j, f: Integer;
  begin
    GenerateAdjacency;
    FaceRemap0.Clear;
    if FaceRemap0.Capacity < FCount then
    FaceRemap0.Capacity := FCount;
    for i := 0 to FCount - 1 do
    begin
      TmpFaces[i].Mapped := False;
      FaceRemap0.Add(i, TmpFaces[i].Material);
    end;
    FaceRemap1.Clear;
    if FaceRemap1.Capacity < FCount then
    FaceRemap1.Capacity := FCount;
    while FaceRemap0.Count > 0 do
    begin
      f := FaceRemap0.Pop;
      MapFace(f);
    end;
    if Length(Faces) < FCount then
    SetLength(Faces, FCount);
    for i := 0 to VCount - 1 do
    TmpVertices[i].Mapped := False;
    VertexRemap0.Clear;
    if VertexRemap0.Capacity < VCount then
    VertexRemap0.Capacity := VCount;
    for i := 0 to FCount - 1 do
    begin
      Faces[i] := TmpFaces[FaceRemap1[i]];
      for j := 0 to 2 do
      begin
        f := Faces[i].Indices[j];
        if TmpVertices[f].Mapped then
        Faces[i].Indices[j] := TmpVertices[f].Remap
        else
        begin
          TmpVertices[f].Mapped := True;
          TmpVertices[f].Remap := VertexRemap0.Count;
          VertexRemap0.Add(f);
          Faces[i].Indices[j] := TmpVertices[f].Remap;
        end;
      end;
    end;
    if Length(Vertices) < VCount then
    SetLength(Vertices, VCount);
    for i := 0 to VCount - 1 do
    Vertices[i] := TmpVertices[VertexRemap0[i]];
  end;
  procedure GenerateGroups;
    var i, j, MaxV, MinV, MaxF, MinF: Integer;
  begin
    if FCount <= 0 then Exit;
    GCount := 0;
    MinF := 0; MaxF := 0;
    MinV := Faces[0].Indices[0]; MaxV := MinV;
    for i := 1 to 2 do
    begin
      if Faces[0].Indices[i] < MinV then MinV := Faces[0].Indices[i];
      if Faces[0].Indices[i] > MaxV then MaxV := Faces[0].Indices[i];
    end;
    Groups[GCount].Material := Faces[0].Material;
    for i := 1 to FCount - 1 do
    begin
      if Faces[i].Material <> Groups[GCount].Material then
      begin
        Groups[GCount].VertexStart := MinV;
        Groups[GCount].VertexCount := MaxV + 1 - MinV;
        Groups[GCount].FaceStart := MinF;
        Groups[GCount].FaceCount := MaxF + 1 - MinF;
        Inc(GCount);
        Groups[GCount].Material := Faces[i].Material;
        MinF := i; MaxF := i;
        MinV := Faces[i].Indices[0]; MaxV := MinV;
        for j := 1 to 2 do
        begin
          if Faces[i].Indices[j] < MinV then MinV := Faces[i].Indices[j];
          if Faces[i].Indices[j] > MaxV then MaxV := Faces[i].Indices[j];
        end;
      end
      else
      begin
        MaxF := i;
        for j := 0 to 2 do
        begin
          if Faces[i].Indices[j] < MinV then MinV := Faces[i].Indices[j];
          if Faces[i].Indices[j] > MaxV then MaxV := Faces[i].Indices[j];
        end;
      end;
    end;
    Groups[GCount].VertexStart := MinV;
    Groups[GCount].VertexCount := MaxV + 1 - MinV;
    Groups[GCount].FaceStart := MinF;
    Groups[GCount].FaceCount := MaxF + 1 - MinF;
    Inc(GCount);
  end;
  var VertexRemap: array of array of TG2IntS32;
  var BoneBounds: array of TG2AABox;
  var i, j, n: Integer;
begin
  VertexRemap := nil;
  BoneBounds := nil;
  TmpFaces := nil;
  MeshData^.NodeCount := NodeCount;
  SetLength(MeshData^.Nodes, MeshData^.NodeCount);
  for i := 0 to NodeCount - 1 do
  begin
    MeshData^.Nodes[i].OwnerID := Nodes[i].OwnerID;
    MeshData^.Nodes[i].Name := Nodes[i].Name;
    MeshData^.Nodes[i].Transform := Nodes[i].Transform;
  end;
  MeshData^.GeomCount := GeomCount;
  SetLength(MeshData^.Geoms, MeshData^.GeomCount);
  SetLength(VertexRemap, GeomCount);
  for i := 0 to GeomCount - 1 do
  begin
    MeshData^.Geoms[i].NodeID := Geoms[i].NodeID;
    MeshData^.Geoms[i].TCount := Geoms[i].TCount;
    MeshData^.Geoms[i].MCount := Geoms[i].MCount;
    VCount := 0;
    FCount := 0;
    for j := 0 to Geoms[i].FCount - 1 do
    AddFace(i, j);
    Optimize;
    SetLength(VertexRemap[i], VCount);
    for j := 0 to VCount - 1 do
    VertexRemap[i][j] := Vertices[j].PosID;
    if Length(Groups) < Geoms[i].MCount then
    SetLength(Groups, Geoms[i].MCount);
    GenerateGroups;
    MeshData^.Geoms[i].VCount := VCount;
    MeshData^.Geoms[i].FCount := FCount;
    SetLength(MeshData^.Geoms[i].Vertices, VCount);
    for j := 0 to VCount - 1 do
    begin
      SetLength(MeshData^.Geoms[i].Vertices[j].TexCoords, Geoms[i].TCount);
      MeshData^.Geoms[i].Vertices[j].Position := Geoms[i].Vertices[Vertices[j].PosID];
      MeshData^.Geoms[i].Vertices[j].Color := Geoms[i].Colors[Vertices[j].ColorID];
      MeshData^.Geoms[i].Vertices[j].Normal := Vertices[j].Normal.Norm;
      MeshData^.Geoms[i].Vertices[j].Binormal.SetValue(0, 0, 0);
      MeshData^.Geoms[i].Vertices[j].Tangent.SetValue(0, 0, 0);
      for n := 0 to Geoms[i].TCount - 1 do
      MeshData^.Geoms[i].Vertices[j].TexCoords[n] := Geoms[i].TexChannels[n].TexCoords[Vertices[j].TexCoordID[n]];
    end;
    SetLength(MeshData^.Geoms[i].Faces, FCount);
    for j := 0 to FCount - 1 do
    begin
      MeshData^.Geoms[i].Faces[j][0] := Faces[j].Indices[0];
      MeshData^.Geoms[i].Faces[j][1] := Faces[j].Indices[1];
      MeshData^.Geoms[i].Faces[j][2] := Faces[j].Indices[2];
    end;
    SetLength(MeshData^.Geoms[i].Groups, GCount);
    for j := 0 to GCount - 1 do
    begin
      MeshData^.Geoms[i].Groups[j].MaterialID := Geoms[i].Materials[Groups[j].Material];
      MeshData^.Geoms[i].Groups[j].VertexStart := Groups[j].VertexStart;
      MeshData^.Geoms[i].Groups[j].VertexCount := Groups[j].VertexCount;
      MeshData^.Geoms[i].Groups[j].FaceStart := Groups[j].FaceStart;
      MeshData^.Geoms[i].Groups[j].FaceCount := Groups[j].FaceCount;
    end;
    MeshData^.Geoms[i].SkinID := -1;
  end;
  MeshData^.SkinCount := SkinCount;
  SetLength(MeshData^.Skins, SkinCount);
  for i := 0 to SkinCount - 1 do
  begin
    MeshData^.Skins[i].GeomID := Skins[i].GeomID;
    MeshData^.Geoms[MeshData^.Skins[i].GeomID].SkinID := i;
    MeshData^.Skins[i].MaxWeights := 0;
    MeshData^.Skins[i].BoneCount := Skins[i].BoneCount;
    SetLength(MeshData^.Skins[i].Bones, Skins[i].BoneCount);
    if Length(BoneBounds) < Skins[i].BoneCount then
    SetLength(BoneBounds, Skins[i].BoneCount);
    for j := 0 to Skins[i].BoneCount - 1 do
    begin
      MeshData^.Skins[i].Bones[j].NodeID := Skins[i].Bones[j].NodeID;
      MeshData^.Skins[i].Bones[j].Bind := Skins[i].Bones[j].Bind;
      MeshData^.Skins[i].Bones[j].VCount := 0;
    end;
    SetLength(MeshData^.Skins[i].Vertices, MeshData^.Geoms[Skins[i].GeomID].VCount);
    for j := 0 to MeshData^.Geoms[Skins[i].GeomID].VCount - 1 do
    begin
      MeshData^.Skins[i].Vertices[j].WeightCount := Skins[i].Vertices[VertexRemap[Skins[i].GeomID][j]].WeightCount;
      SetLength(MeshData^.Skins[i].Vertices[j].Weights, MeshData^.Skins[i].Vertices[j].WeightCount);
      if MeshData^.Skins[i].Vertices[j].WeightCount > MeshData^.Skins[i].MaxWeights then
      MeshData^.Skins[i].MaxWeights := MeshData^.Skins[i].Vertices[j].WeightCount;
      for n := 0 to MeshData^.Skins[i].Vertices[j].WeightCount - 1 do
      begin
        MeshData^.Skins[i].Vertices[j].Weights[n].BoneID := Skins[i].Vertices[VertexRemap[Skins[i].GeomID][j]].Weights[n].BoneID;
        MeshData^.Skins[i].Vertices[j].Weights[n].Weight := Skins[i].Vertices[VertexRemap[Skins[i].GeomID][j]].Weights[n].Weight;
        if MeshData^.Skins[i].Bones[MeshData^.Skins[i].Vertices[j].Weights[n].BoneID].VCount = 0 then
        BoneBounds[MeshData^.Skins[i].Vertices[j].Weights[n].BoneID].SetValue(
          MeshData^.Geoms[Skins[i].GeomID].Vertices[VertexRemap[Skins[i].GeomID][j]].Position
        )
        else
        BoneBounds[MeshData^.Skins[i].Vertices[j].Weights[n].BoneID].Include(
          MeshData^.Geoms[Skins[i].GeomID].Vertices[VertexRemap[Skins[i].GeomID][j]].Position
        );
        Inc(MeshData^.Skins[i].Bones[MeshData^.Skins[i].Vertices[j].Weights[n].BoneID].VCount);
      end;
    end;
    for j := 0 to Skins[i].BoneCount - 1 do
    MeshData^.Skins[i].Bones[j].BBox := BoneBounds[j];
  end;
  MeshData^.AnimCount := AnimCount;
  SetLength(MeshData^.Anims, MeshData^.AnimCount);
  for i := 0 to AnimCount - 1 do
  begin
    MeshData^.Anims[i].Name := Anims[i].Name;
    MeshData^.Anims[i].FrameCount := Anims[i].FrameCount;
    MeshData^.Anims[i].FrameRate := Anims[i].FPS;
    MeshData^.Anims[i].NodeCount := Anims[i].AnimNodeCount;
    SetLength(MeshData^.Anims[i].Nodes, MeshData^.Anims[i].NodeCount);
    for j := 0 to MeshData^.Anims[i].NodeCount - 1 do
    begin
      MeshData^.Anims[i].Nodes[j].NodeID := Anims[i].AnimNodes[j].NodeID;
      SetLength(MeshData^.Anims[i].Nodes[j].Frames, MeshData^.Anims[i].FrameCount);
      for n := 0 to MeshData^.Anims[i].FrameCount - 1 do
      begin
        G2MatDecompose(
          @MeshData^.Anims[i].Nodes[j].Frames[n].Scaling,
          @MeshData^.Anims[i].Nodes[j].Frames[n].Rotation,
          @MeshData^.Anims[i].Nodes[j].Frames[n].Translation,
          Anims[i].AnimNodes[j].Frames[n]
        );
      end;
    end;
  end;
  MeshData^.MaterialCount := MaterialCount;
  SetLength(MeshData^.Materials, MeshData^.MaterialCount);
  for i := 0 to MaterialCount - 1 do
  begin
    MeshData^.Materials[i].ChannelCount := Materials[i].ChannelCount;
    SetLength(MeshData^.Materials[i].Channels, MeshData^.Materials[i].ChannelCount);
    for j := 0 to Materials[i].ChannelCount - 1 do
    begin
      MeshData^.Materials[i].Channels[j].Name := Materials[i].Channels[j].MatName;
      MeshData^.Materials[i].Channels[j].TwoSided := Materials[i].Channels[j].TwoSided;
      MeshData^.Materials[i].Channels[j].AmbientColor := Materials[i].Channels[j].AmbientColor;
      MeshData^.Materials[i].Channels[j].DiffuseColor := Materials[i].Channels[j].DiffuseColor;
      MeshData^.Materials[i].Channels[j].SpecularColor := Materials[i].Channels[j].SpecularColor;
      MeshData^.Materials[i].Channels[j].SpecularColorAmount := Materials[i].Channels[j].SpecularColorAmount;
      MeshData^.Materials[i].Channels[j].SpecularPower := Materials[i].Channels[j].SpecularPower;
      MeshData^.Materials[i].Channels[j].EmmissiveColor := Materials[i].Channels[j].EmmissiveColor;
      MeshData^.Materials[i].Channels[j].EmmissiveColorAmount := Materials[i].Channels[j].EmmissiveColorAmount;
      MeshData^.Materials[i].Channels[j].AmbientMapEnable := Materials[i].Channels[j].AmbientMapEnable;
      MeshData^.Materials[i].Channels[j].AmbientMap := Materials[i].Channels[j].AmbientMap;
      MeshData^.Materials[i].Channels[j].AmbientMapAmount := Materials[i].Channels[j].AmbientMapAmount;
      MeshData^.Materials[i].Channels[j].DiffuseMapEnable := Materials[i].Channels[j].DiffuseMapEnable;
      MeshData^.Materials[i].Channels[j].DiffuseMap := Materials[i].Channels[j].DiffuseMap;
      MeshData^.Materials[i].Channels[j].DiffuseMapAmount := Materials[i].Channels[j].DiffuseMapAmount;
      MeshData^.Materials[i].Channels[j].SpecularMapEnable := Materials[i].Channels[j].SpecularMapEnable;
      MeshData^.Materials[i].Channels[j].SpecularMap := Materials[i].Channels[j].SpecularMap;
      MeshData^.Materials[i].Channels[j].SpecularMapAmount := Materials[i].Channels[j].SpecularMapAmount;
      MeshData^.Materials[i].Channels[j].OpacityMapEnable := Materials[i].Channels[j].OpacityMapEnable;
      MeshData^.Materials[i].Channels[j].OpacityMap := Materials[i].Channels[j].OpacityMap;
      MeshData^.Materials[i].Channels[j].OpacityMapAmount := Materials[i].Channels[j].OpacityMapAmount;
      MeshData^.Materials[i].Channels[j].LightMapEnable := Materials[i].Channels[j].IlluminationMapEnable;
      MeshData^.Materials[i].Channels[j].LightMap := Materials[i].Channels[j].IlluminationMap;
      MeshData^.Materials[i].Channels[j].LightMapAmount := Materials[i].Channels[j].IlluminationMapAmount;
      MeshData^.Materials[i].Channels[j].NormalMapEnable := Materials[i].Channels[j].BumpMapEnable;
      MeshData^.Materials[i].Channels[j].NormalMap := Materials[i].Channels[j].BumpMap;
      MeshData^.Materials[i].Channels[j].NormalMapAmount := Materials[i].Channels[j].BumpMapAmount;
    end;
  end;
  MeshData^.RagDollCount := 0;
  MeshData^.LimitSkins(4);
end;
//TG2MeshLoaderG2M END

initialization
begin
  G2AddMeshLoader(TG2MeshLoaderG2M);
end;

end.
