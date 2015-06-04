unit G2MeshG2M;

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
  w3system,
  G2Types,
  G2Utils,
  G2DataManager,
  G2Math,
  G2MeshData;

type
  TG2MeshLoaderG2M = class (TG2MeshLoader)
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
      VCount: Integer;
      CCount: Integer;
      FCount: Integer;
      MCount: Integer;
      TCount: Integer;
      Vertices: array of TG2Vec3;
      Colors: array of TG2Vec4;
      TexChannels: array of record
        TVCount: Integer;
        TexCoords: array of TG2Vec2;
      end;
      Materials: array of Integer;
      Faces: array of record
        FaceVertices: array[0..2] of Integer;
        FaceColors: array[0..2] of Integer;
        FaceTexCoords: array of array[0..2] of Integer;
        FaceGroup: Integer;
        FaceMaterial: Integer;
      end;
    end;
    AnimCount: Integer;
    Anims: array of record
      Name: String;
      FrameCount: Integer;
      FPS: Integer;
      AnimNodeCount: Integer;
      AnimNodes: array of record
        NodeID: Integer;
        Frames: array of TG2Mat;
      end;
    end;
    SkinCount: Integer;
    Skins: array of record
      GeomID: Integer;
      BoneCount: Integer;
      Bones: array of record
        NodeID: Integer;
        Bind: TG2Mat;
      end;
      Vertices: array of record
        WeightCount: Integer;
        Weights: array of record
          BoneID: Integer;
          Weight: TG2Float;
        end;
      end;
    end;
    MaterialCount: Integer;
    Materials: array of record
      ChannelCount: Integer;
      Channels: array of record
        MatName: String;
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
        IlluminationMapEnable: Boolean;
        IlluminationMap: String;
        IlluminationMapAmount: TG2Float;
        BumpMapEnable: Boolean;
        BumpMap: String;
        BumpMapAmount: TG2Float;
      end;
    end;
    LightCount: Integer;
    Lights: array of record
      NodeID: Integer;
      LightType: Integer;
      Enabled: Boolean;
      Color: TG2Vec4;
      AttStart: TG2Float;
      AttEnd: TG2Float;
      SpotInner: TG2Float;
      SpotOutter: TG2Float;
      WidthInner: TG2Float;
      WidthOutter: TG2Float;
      HeightInner: TG2Float;
      HeightOutter: TG2Float;
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
    class function CanLoad(const DataManager: TG2DataManager): Boolean; override;
    procedure Load(const DataManager: TG2DataManager); override;
    function ExportMeshData: TG2MeshData; override;
  end;

implementation

//TG2MeshLoaderG2M BEGIN
class function TG2MeshLoaderG2M.CanLoad(const DataManager: TG2DataManager): Boolean;
begin
  Result := CheckDataHeader(DataManager, 'G2M ');
end;

procedure TG2MeshLoaderG2M.Load(const DataManager: TG2DataManager);
  var StartPos: Integer;
  function FindBlock(const BlockName: String): Boolean;
    var BName: String;
    var BSize: Integer;
  begin
    DataManager.Position := StartPos;
    while DataManager.Position < DataManager.Size - 8 do
    begin
      BName := DataManager.ReadString(4);
      BSize := DataManager.ReadIntS32;
      if BName = BlockName then
      begin
        Result := True;
        Exit;
      end
      else
      begin
        DataManager.Position := DataManager.Position + BSize;
      end;
    end;
    Result := False;
  end;
  function LoadRagdollObject: TG2RagdollObject;
    var i: Integer;
  begin
    Result := TG2RagdollObject.Create;
    Result.NodeID := DataManager.ReadIntS32;
    Result.MinV := DataManager.ReadVec3;
    Result.MaxV := DataManager.ReadVec3;
    Result.Transform := DataManager.ReadMat4x3;
    Result.DependantCount := DataManager.ReadIntS32;
    Result.Dependants.SetLength(Result.DependantCount);
    for i := 0 to Result.DependantCount - 1 do
    begin
      Result.Dependants[i].NodeID := DataManager.ReadIntS32;
      Result.Dependants[i].Offset := DataManager.ReadMat4x3;
    end;
  end;
  var Header: String;
  var i, j, n, t: Integer;
begin
  Header := DataManager.ReadString(4);
  if Header <> 'G2M ' then Exit;
  StartPos := DataManager.Position;
  if not FindBlock('NMAP') then Exit;
  NodeCount := DataManager.ReadIntS32;
  Nodes.SetLength(NodeCount);
  if not FindBlock('NDAT') then Exit;
  for i := 0 to NodeCount - 1 do
  begin
    Nodes[i].OwnerID := DataManager.ReadIntS32;
    Nodes[i].Name := DataManager.ReadStringNT;
    Nodes[i].Transform := DataManager.ReadMat4x3;
  end;
  if FindBlock('GMAP') then
  begin
    GeomCount := DataManager.ReadIntS32;
    Geoms.SetLength(GeomCount);
    if FindBlock('GDAT') then
    for i := 0 to GeomCount - 1 do
    begin
      Geoms[i].NodeID := DataManager.ReadIntS32;
      Geoms[i].VCount := DataManager.ReadIntS32;
      Geoms[i].CCount := DataManager.ReadIntS32;
      Geoms[i].FCount := DataManager.ReadIntS32;
      Geoms[i].MCount := DataManager.ReadIntS32;
      Geoms[i].TCount := DataManager.ReadIntS32;
      Geoms[i].Vertices.SetLength(Geoms[i].VCount);
      for j := 0 to Geoms[i].VCount - 1 do
      Geoms[i].Vertices[j] := DataManager.ReadVec3;
      Geoms[i].Colors.SetLength(Geoms[i].CCount);
      for j := 0 to Geoms[i].CCount - 1 do
      begin
        Geoms[i].Colors[j].x := DataManager.ReadIntU8 / $ff;
        Geoms[i].Colors[j].y := DataManager.ReadIntU8 / $ff;
        Geoms[i].Colors[j].z := DataManager.ReadIntU8 / $ff;
        Geoms[i].Colors[j].w := 1;
      end;
      Geoms[i].TexChannels.SetLength(Geoms[i].TCount);
      for j := 0 to Geoms[i].TCount - 1 do
      begin
        Geoms[i].TexChannels[j].TVCount := DataManager.ReadIntS32;
        Geoms[i].TexChannels[j].TexCoords.SetLength(Geoms[i].TexChannels[j].TVCount);
        for n := 0 to Geoms[i].TexChannels[j].TVCount - 1 do
        Geoms[i].TexChannels[j].TexCoords[n] := DataManager.ReadVec2;
      end;
      Geoms[i].Materials.SetLength(Geoms[i].MCount);
      for j := 0 to Geoms[i].MCount - 1 do
      Geoms[i].Materials[j] := DataManager.ReadIntS32;
      Geoms[i].Faces.SetLength(Geoms[i].FCount);
      for j := 0 to Geoms[i].FCount - 1 do
      begin
        Geoms[i].Faces[j].FaceTexCoords.SetLength(Geoms[i].TCount);
        for n := 0 to 2 do
        Geoms[i].Faces[j].FaceVertices[n] := DataManager.ReadIntS32;
        for n := 0 to 2 do
        Geoms[i].Faces[j].FaceColors[n] := DataManager.ReadIntS32;
        for t := 0 to Geoms[i].TCount - 1 do
        begin
          for n := 0 to 2 do
          Geoms[i].Faces[j].FaceTexCoords[t][n] := DataManager.ReadIntS32;
        end;
        Geoms[i].Faces[j].FaceGroup := DataManager.ReadIntS32;
        Geoms[i].Faces[j].FaceMaterial := DataManager.ReadIntS32;
      end;
    end;
  end;
  if FindBlock('AMAP') then
  begin
    AnimCount := DataManager.ReadIntS32;
    Anims.SetLength(AnimCount);
    if FindBlock('ADAT') then
    for i := 0 to AnimCount - 1 do
    begin
      Anims[i].Name := DataManager.ReadStringNT;
      Anims[i].FrameCount := DataManager.ReadIntS32;
      Anims[i].FPS := DataManager.ReadIntS32;
      Anims[i].AnimNodeCount := DataManager.ReadIntS32;
      Anims[i].AnimNodes.SetLength(Anims[i].AnimNodeCount);
      for j := 0 to Anims[i].AnimNodeCount - 1 do
      begin
        Anims[i].AnimNodes[j].NodeID := DataManager.ReadIntS32;
        Anims[i].AnimNodes[j].Frames.SetLength(Anims[i].FrameCount);
        for n := 0 to Anims[i].FrameCount - 1 do
        Anims[i].AnimNodes[j].Frames[n] := DataManager.ReadMat4x3;
      end;
    end;
  end;
  if FindBlock('SMAP') then
  begin
    SkinCount := DataManager.ReadIntS32;
    Skins.SetLength(SkinCount);
    if FindBlock('SDAT') then
    for i := 0 to SkinCount - 1 do
    begin
      Skins[i].GeomID := DataManager.ReadIntS32;
      Skins[i].BoneCount := DataManager.ReadIntS32;
      Skins[i].Bones.SetLength(Skins[i].BoneCount);
      for j := 0 to Skins[i].BoneCount - 1 do
      begin
        Skins[i].Bones[j].NodeID := DataManager.ReadIntS32;
        Skins[i].Bones[j].Bind := DataManager.ReadMat4x3;
      end;
      Skins[i].Vertices.SetLength(Geoms[Skins[i].GeomID].VCount);
      for j := 0 to Geoms[Skins[i].GeomID].VCount - 1 do
      begin
        Skins[i].Vertices[j].WeightCount := DataManager.ReadIntS32;
        Skins[i].Vertices[j].Weights.SetLength(Skins[i].Vertices[j].WeightCount);
        for n := 0 to Skins[i].Vertices[j].WeightCount - 1 do
        begin
          Skins[i].Vertices[j].Weights[n].BoneID := DataManager.ReadIntS32;
          Skins[i].Vertices[j].Weights[n].Weight := DataManager.ReadFloat32;
        end;
      end;
    end;
  end;
  if FindBlock('MMAP') then
  begin
    MaterialCount := DataManager.ReadIntS32;
    Materials.SetLength(MaterialCount);
    if FindBlock('MDAT') then
    for i := 0 to MaterialCount - 1 do
    begin
      Materials[i].ChannelCount := DataManager.ReadIntS32;
      Materials[i].Channels.SetLength(Materials[i].ChannelCount);
      for j := 0 to Materials[i].ChannelCount - 1 do
      begin
        Materials[i].Channels[j].MatName := DataManager.ReadStringNT;
        Materials[i].Channels[j].TwoSided := DataManager.ReadBool;
        Materials[i].Channels[j].AmbientColor.x := DataManager.ReadIntU8 / $ff;
        Materials[i].Channels[j].AmbientColor.y := DataManager.ReadIntU8 / $ff;
        Materials[i].Channels[j].AmbientColor.z := DataManager.ReadIntU8 / $ff;
        Materials[i].Channels[j].AmbientColor.w := 1;
        Materials[i].Channels[j].DiffuseColor.x := DataManager.ReadIntU8 / $ff;
        Materials[i].Channels[j].DiffuseColor.y := DataManager.ReadIntU8 / $ff;
        Materials[i].Channels[j].DiffuseColor.z := DataManager.ReadIntU8 / $ff;
        Materials[i].Channels[j].DiffuseColor.w := 1;
        Materials[i].Channels[j].SpecularColor.x := DataManager.ReadIntU8 / $ff;
        Materials[i].Channels[j].SpecularColor.y := DataManager.ReadIntU8 / $ff;
        Materials[i].Channels[j].SpecularColor.z := DataManager.ReadIntU8 / $ff;
        Materials[i].Channels[j].SpecularColor.w := 1;
        Materials[i].Channels[j].SpecularColorAmount := DataManager.ReadFloat32;
        Materials[i].Channels[j].SpecularPower := DataManager.ReadFloat32;
        Materials[i].Channels[j].EmmissiveColor.x := DataManager.ReadIntU8 / $ff;
        Materials[i].Channels[j].EmmissiveColor.y := DataManager.ReadIntU8 / $ff;
        Materials[i].Channels[j].EmmissiveColor.z := DataManager.ReadIntU8 / $ff;
        Materials[i].Channels[j].EmmissiveColor.w := 1;
        Materials[i].Channels[j].EmmissiveColorAmount := DataManager.ReadFloat32;
        Materials[i].Channels[j].AmbientMapEnable := DataManager.ReadBool;
        Materials[i].Channels[j].AmbientMap := DataManager.ReadStringNT;
        Materials[i].Channels[j].AmbientMapAmount := DataManager.ReadFloat32;
        Materials[i].Channels[j].DiffuseMapEnable := DataManager.ReadBool;
        Materials[i].Channels[j].DiffuseMap := DataManager.ReadStringNT;
        Materials[i].Channels[j].DiffuseMapAmount := DataManager.ReadFloat32;
        Materials[i].Channels[j].SpecularMapEnable := DataManager.ReadBool;
        Materials[i].Channels[j].SpecularMap := DataManager.ReadStringNT;
        Materials[i].Channels[j].SpecularMapAmount := DataManager.ReadFloat32;
        Materials[i].Channels[j].OpacityMapEnable := DataManager.ReadBool;
        Materials[i].Channels[j].OpacityMap := DataManager.ReadStringNT;
        Materials[i].Channels[j].OpacityMapAmount := DataManager.ReadFloat32;
        Materials[i].Channels[j].IlluminationMapEnable := DataManager.ReadBool;
        Materials[i].Channels[j].IlluminationMap := DataManager.ReadStringNT;
        Materials[i].Channels[j].IlluminationMapAmount := DataManager.ReadFloat32;
        Materials[i].Channels[j].BumpMapEnable := DataManager.ReadBool;
        Materials[i].Channels[j].BumpMap := DataManager.ReadStringNT;
        Materials[i].Channels[j].BumpMapAmount := DataManager.ReadFloat32;
      end;
    end;
  end;
  if FindBlock('LMAP') then
  begin
    LightCount := DataManager.ReadIntS32;
    Lights.SetLength(LightCount);
    if FindBlock('LDAT') then
    for i := 0 to LightCount - 1 do
    begin
      Lights[i].NodeID := DataManager.ReadIntS32;
      Lights[i].LightType := DataManager.ReadIntU8;
      Lights[i].Enabled := DataManager.ReadBool;
      Lights[i].Color.x := DataManager.ReadIntU8 / $ff;
      Lights[i].Color.y := DataManager.ReadIntU8 / $ff;
      Lights[i].Color.z := DataManager.ReadIntU8 / $ff;
      Lights[i].Color.w := 1;
      Lights[i].AttStart := DataManager.ReadFloat32;
      Lights[i].AttEnd := DataManager.ReadFloat32;
      Lights[i].SpotInner := DataManager.ReadFloat32;
      Lights[i].SpotOutter := DataManager.ReadFloat32;
      Lights[i].WidthInner := DataManager.ReadFloat32;
      Lights[i].WidthOutter := DataManager.ReadFloat32;
      Lights[i].HeightInner := DataManager.ReadFloat32;
      Lights[i].HeightOutter := DataManager.ReadFloat32;
    end;
  end;
  if FindBlock('RGDL') then
  begin
    RagDollCount := DataManager.ReadIntS32;
    RagDolls.SetLength(RagDollCount);
    for i := 0 to RagDollCount - 1 do
    begin
      RagDolls[i].NodeID := DataManager.ReadIntS32;
      RagDolls[i].Head := LoadRagdollObject;
      RagDolls[i].Neck := LoadRagdollObject;
      RagDolls[i].Pelvis := LoadRagdollObject;
      RagDolls[i].BodyNodeCount := DataManager.ReadIntS32;
      RagDolls[i].BodyNodes.SetLength(RagDolls[i].BodyNodeCount);
      for j := 0 to RagDolls[i].BodyNodeCount - 1 do
      RagDolls[i].BodyNodes[j] := LoadRagdollObject;
      RagDolls[i].ArmRNodeCount := DataManager.ReadIntS32;
      RagDolls[i].ArmRNodes.SetLength(RagDolls[i].ArmRNodeCount);
      for j := 0 to RagDolls[i].ArmRNodeCount - 1 do
      RagDolls[i].ArmRNodes[j] := LoadRagdollObject;
      RagDolls[i].ArmLNodeCount := DataManager.ReadIntS32;
      RagDolls[i].ArmLNodes.SetLength(RagDolls[i].ArmLNodeCount);
      for j := 0 to RagDolls[i].ArmLNodeCount - 1 do
      RagDolls[i].ArmLNodes[j] := LoadRagdollObject;
      RagDolls[i].LegRNodeCount := DataManager.ReadIntS32;
      RagDolls[i].LegRNodes.SetLength(RagDolls[i].LegRNodeCount);
      for j := 0 to RagDolls[i].LegRNodeCount - 1 do
      RagDolls[i].LegRNodes[j] := LoadRagdollObject;
      RagDolls[i].LegLNodeCount := DataManager.ReadIntS32;
      RagDolls[i].LegLNodes.SetLength(RagDolls[i].LegLNodeCount);
      for j := 0 to RagDolls[i].LegLNodeCount - 1 do
      RagDolls[i].LegLNodes[j] := LoadRagdollObject;
    end;
  end;
end;

type TVertex = record
  PosID: Integer;
  ColorID: Integer;
  TexCoordID: array of Integer;
  GroupID: Integer;
  MaterialID: Integer;
  Normal: TG2Vec3;
  Mapped: Boolean;
  Remap: Integer;
end;

type TFace = record
  Material: Integer;
  Indices: array[0..2] of Integer;
  Mapped: Boolean;
end;

type TGroup = record
  Material: Integer;
  VertexStart: Integer;
  VertexCount: Integer;
  FaceStart: Integer;
  FaceCount: Integer;
end;

function TG2MeshLoaderG2M.ExportMeshData: TG2MeshData;
  var VCount: Integer;
  var Vertices: array of TVertex;
  var FCount: Integer;
  var Faces: array of TFace;
  var GCount: Integer;
  var Groups: array of TGroup;
  var TmpFaces: array of TFace;
  var TmpVertices: array of TVertex;
  function AddVertex(
    const PosID, ColorID, GroupID, MaterialID, TexCount: Integer;
    const TexCoordID: array of array[0..2] of Integer; const TexInd: Integer; const Normal: TG2Vec3
  ): Integer;
    var i, j: Integer;
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
        if TmpVertices[i].TexCoordID[j] <> TexCoordID[j][TexInd] then
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
      TmpVertices.SetLength(Length(TmpVertices) + 1024);
      Result := VCount;
      TmpVertices[Result].TexCoordID.SetLength(TexCount);
      TmpVertices[Result].PosID := PosID;
      TmpVertices[Result].ColorID := ColorID;
      TmpVertices[Result].GroupID := GroupID;
      TmpVertices[Result].MaterialID := MaterialID;
      for i := 0 to TexCount - 1 do
      TmpVertices[Result].TexCoordID[i] := TexCoordID[i][TexInd];
      TmpVertices[Result].Normal := Normal;
      Inc(VCount);
    end;
  end;
  procedure AddFace(const GeomID, FaceID: Integer);
    var Normal, v0, v1, v2: TG2Vec3;
  begin
    if FCount >= High(TmpFaces) then
    TmpFaces.SetLength(Length(TmpFaces) + 1024);
    v0 := Geoms[GeomID].Vertices[Geoms[GeomID].Faces[FaceID].FaceVertices[0]];
    v1 := Geoms[GeomID].Vertices[Geoms[GeomID].Faces[FaceID].FaceVertices[1]];
    v2 := Geoms[GeomID].Vertices[Geoms[GeomID].Faces[FaceID].FaceVertices[2]];
    Normal := G2TriangleNormal(
      Geoms[GeomID].Vertices[Geoms[GeomID].Faces[FaceID].FaceVertices[0]],
      Geoms[GeomID].Vertices[Geoms[GeomID].Faces[FaceID].FaceVertices[1]],
      Geoms[GeomID].Vertices[Geoms[GeomID].Faces[FaceID].FaceVertices[2]]
    );
    TmpFaces[FCount].Material := Geoms[GeomID].Faces[FaceID].FaceMaterial;
    TmpFaces[FCount].Indices[0] := AddVertex(
      Geoms[GeomID].Faces[FaceID].FaceVertices[0],
      Geoms[GeomID].Faces[FaceID].FaceColors[0],
      Geoms[GeomID].Faces[FaceID].FaceGroup,
      TmpFaces[FCount].Material,
      Geoms[GeomID].TCount,
      Geoms[GeomID].Faces[FaceID].FaceTexCoords, 0,
      Normal
    );
    TmpFaces[FCount].Indices[1] := AddVertex(
      Geoms[GeomID].Faces[FaceID].FaceVertices[1],
      Geoms[GeomID].Faces[FaceID].FaceColors[1],
      Geoms[GeomID].Faces[FaceID].FaceGroup,
      TmpFaces[FCount].Material,
      Geoms[GeomID].TCount,
      Geoms[GeomID].Faces[FaceID].FaceTexCoords, 1,
      Normal
    );
    TmpFaces[FCount].Indices[2] := AddVertex(
      Geoms[GeomID].Faces[FaceID].FaceVertices[2],
      Geoms[GeomID].Faces[FaceID].FaceColors[2],
      Geoms[GeomID].Faces[FaceID].FaceGroup,
      TmpFaces[FCount].Material,
      Geoms[GeomID].TCount,
      Geoms[GeomID].Faces[FaceID].FaceTexCoords, 2,
      Normal
    );
    Inc(FCount);
  end;
  var Adj: array of Integer;
  procedure GenerateAdjacency;
    function CompareEdges(const e0i0, e0i1, e1i0, e1i1: Integer): Boolean;
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
    Adj.SetLength(FCount * 3);
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
  var FaceRemap0: TG2QuickSortListInt;
  var FaceRemap1: TG2QuickListInt;
  var VertexRemap0: TG2QuickListInt;
  procedure Optimize;
    procedure MapFace(const f: Integer);
      var i, af: Integer;
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
    Faces.SetLength(FCount);
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
    Vertices.SetLength(VCount);
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
  var VertexRemap: array of array of Integer;
  var BoneBounds: array of TG2AABox;
  var i, j, n: Integer;
begin
  Result := TG2MeshData.Create;
  VertexRemap.SetLength(0);
  BoneBounds.SetLength(0);
  TmpFaces.SetLength(0);
  Result.NodeCount := NodeCount;
  Result.Nodes.SetLength(Result.NodeCount);
  for i := 0 to NodeCount - 1 do
  begin
    Result.Nodes[i].OwnerID := Nodes[i].OwnerID;
    Result.Nodes[i].Name := Nodes[i].Name;
    Result.Nodes[i].Transform := Nodes[i].Transform;
  end;
  Result.GeomCount := GeomCount;
  Result.Geoms.SetLength(Result.GeomCount);
  VertexRemap.SetLength(GeomCount);
  for i := 0 to GeomCount - 1 do
  begin
    Result.Geoms[i].NodeID := Geoms[i].NodeID;
    Result.Geoms[i].TCount := Geoms[i].TCount;
    Result.Geoms[i].MCount := Geoms[i].MCount;
    VCount := 0;
    FCount := 0;
    for j := 0 to Geoms[i].FCount - 1 do
    AddFace(i, j);
    Optimize;
    VertexRemap[i].SetLength(VCount);
    for j := 0 to VCount - 1 do
    VertexRemap[i][j] := Vertices[j].PosID;
    if Length(Groups) < Geoms[i].MCount then
    Groups.SetLength(Geoms[i].MCount);
    GenerateGroups;
    Result.Geoms[i].VCount := VCount;
    Result.Geoms[i].FCount := FCount;
    Result.Geoms[i].Vertices.SetLength(VCount);
    for j := 0 to VCount - 1 do
    begin
      Result.Geoms[i].Vertices[j].TexCoords.SetLength(Geoms[i].TCount);
      Result.Geoms[i].Vertices[j].Position := Geoms[i].Vertices[Vertices[j].PosID];
      Result.Geoms[i].Vertices[j].Color := Geoms[i].Colors[Vertices[j].ColorID];
      Result.Geoms[i].Vertices[j].Normal := Vertices[j].Normal.Norm;
      Result.Geoms[i].Vertices[j].Binormal.SetValue(0, 0, 0);
      Result.Geoms[i].Vertices[j].Tangent.SetValue(0, 0, 0);
      for n := 0 to Geoms[i].TCount - 1 do
      Result.Geoms[i].Vertices[j].TexCoords[n] := Geoms[i].TexChannels[n].TexCoords[Vertices[j].TexCoordID[n]];
    end;
    Result.Geoms[i].Faces.SetLength(FCount);
    for j := 0 to FCount - 1 do
    begin
      Result.Geoms[i].Faces[j][0] := Faces[j].Indices[0];
      Result.Geoms[i].Faces[j][1] := Faces[j].Indices[1];
      Result.Geoms[i].Faces[j][2] := Faces[j].Indices[2];
    end;
    Result.Geoms[i].Groups.SetLength(GCount);
    for j := 0 to GCount - 1 do
    begin
      Result.Geoms[i].Groups[j].MaterialID := Geoms[i].Materials[Groups[j].Material];
      Result.Geoms[i].Groups[j].VertexStart := Groups[j].VertexStart;
      Result.Geoms[i].Groups[j].VertexCount := Groups[j].VertexCount;
      Result.Geoms[i].Groups[j].FaceStart := Groups[j].FaceStart;
      Result.Geoms[i].Groups[j].FaceCount := Groups[j].FaceCount;
    end;
    Result.Geoms[i].SkinID := -1;
  end;
  Result.SkinCount := SkinCount;
  Result.Skins.SetLength(SkinCount);
  for i := 0 to SkinCount - 1 do
  begin
    Result.Skins[i].GeomID := Skins[i].GeomID;
    Result.Geoms[Result.Skins[i].GeomID].SkinID := i;
    Result.Skins[i].MaxWeights := 0;
    Result.Skins[i].BoneCount := Skins[i].BoneCount;
    Result.Skins[i].Bones.SetLength(Skins[i].BoneCount);
    if Length(BoneBounds) < Skins[i].BoneCount then
    BoneBounds.SetLength(Skins[i].BoneCount);
    for j := 0 to Skins[i].BoneCount - 1 do
    begin
      Result.Skins[i].Bones[j].NodeID := Skins[i].Bones[j].NodeID;
      Result.Skins[i].Bones[j].Bind := Skins[i].Bones[j].Bind;
      Result.Skins[i].Bones[j].VCount := 0;
    end;
    Result.Skins[i].Vertices.SetLength(Result.Geoms[Skins[i].GeomID].VCount);
    for j := 0 to Result.Geoms[Skins[i].GeomID].VCount - 1 do
    begin
      Result.Skins[i].Vertices[j].WeightCount := Skins[i].Vertices[VertexRemap[Skins[i].GeomID][j]].WeightCount;
      Result.Skins[i].Vertices[j].Weights.SetLength(Result.Skins[i].Vertices[j].WeightCount);
      if Result.Skins[i].Vertices[j].WeightCount > Result.Skins[i].MaxWeights then
      Result.Skins[i].MaxWeights := Result.Skins[i].Vertices[j].WeightCount;
      for n := 0 to Result.Skins[i].Vertices[j].WeightCount - 1 do
      begin
        Result.Skins[i].Vertices[j].Weights[n].BoneID := Skins[i].Vertices[VertexRemap[Skins[i].GeomID][j]].Weights[n].BoneID;
        Result.Skins[i].Vertices[j].Weights[n].Weight := Skins[i].Vertices[VertexRemap[Skins[i].GeomID][j]].Weights[n].Weight;
        if Result.Skins[i].Bones[Result.Skins[i].Vertices[j].Weights[n].BoneID].VCount = 0 then
        BoneBounds[Result.Skins[i].Vertices[j].Weights[n].BoneID].SetValue(
          Result.Geoms[Skins[i].GeomID].Vertices[VertexRemap[Skins[i].GeomID][j]].Position
        )
        else
        BoneBounds[Result.Skins[i].Vertices[j].Weights[n].BoneID].Include(
          Result.Geoms[Skins[i].GeomID].Vertices[VertexRemap[Skins[i].GeomID][j]].Position
        );
        Inc(Result.Skins[i].Bones[Result.Skins[i].Vertices[j].Weights[n].BoneID].VCount);
      end;
    end;
    for j := 0 to Skins[i].BoneCount - 1 do
    Result.Skins[i].Bones[j].BBox := G2AABoxToBox(BoneBounds[j]);
  end;
  Result.AnimCount := AnimCount;
  Result.Anims.SetLength(Result.AnimCount);
  for i := 0 to AnimCount - 1 do
  begin
    Result.Anims[i].Name := Anims[i].Name;
    Result.Anims[i].FrameCount := Anims[i].FrameCount;
    Result.Anims[i].FrameRate := Anims[i].FPS;
    Result.Anims[i].NodeCount := Anims[i].AnimNodeCount;
    Result.Anims[i].Nodes.SetLength(Result.Anims[i].NodeCount);
    for j := 0 to Result.Anims[i].NodeCount - 1 do
    begin
      Result.Anims[i].Nodes[j].NodeID := Anims[i].AnimNodes[j].NodeID;
      Result.Anims[i].Nodes[j].Frames.SetLength(Result.Anims[i].FrameCount);
      for n := 0 to Result.Anims[i].FrameCount - 1 do
      begin
        G2MatDecompose(
          Result.Anims[i].Nodes[j].Frames[n].Scaling,
          Result.Anims[i].Nodes[j].Frames[n].Rotation,
          Result.Anims[i].Nodes[j].Frames[n].Translation,
          Anims[i].AnimNodes[j].Frames[n]
        );
      end;
    end;
  end;
  Result.MaterialCount := MaterialCount;
  Result.Materials.SetLength(Result.MaterialCount);
  for i := 0 to MaterialCount - 1 do
  begin
    Result.Materials[i].ChannelCount := Materials[i].ChannelCount;
    Result.Materials[i].Channels.SetLength(Result.Materials[i].ChannelCount);
    for j := 0 to Materials[i].ChannelCount - 1 do
    begin
      Result.Materials[i].Channels[j].Name := Materials[i].Channels[j].MatName;
      Result.Materials[i].Channels[j].TwoSided := Materials[i].Channels[j].TwoSided;
      Result.Materials[i].Channels[j].AmbientColor := Materials[i].Channels[j].AmbientColor;
      Result.Materials[i].Channels[j].DiffuseColor := Materials[i].Channels[j].DiffuseColor;
      Result.Materials[i].Channels[j].SpecularColor := Materials[i].Channels[j].SpecularColor;
      Result.Materials[i].Channels[j].SpecularColorAmount := Materials[i].Channels[j].SpecularColorAmount;
      Result.Materials[i].Channels[j].SpecularPower := Materials[i].Channels[j].SpecularPower;
      Result.Materials[i].Channels[j].EmmissiveColor := Materials[i].Channels[j].EmmissiveColor;
      Result.Materials[i].Channels[j].EmmissiveColorAmount := Materials[i].Channels[j].EmmissiveColorAmount;
      Result.Materials[i].Channels[j].AmbientMapEnable := Materials[i].Channels[j].AmbientMapEnable;
      Result.Materials[i].Channels[j].AmbientMap := Materials[i].Channels[j].AmbientMap;
      Result.Materials[i].Channels[j].AmbientMapAmount := Materials[i].Channels[j].AmbientMapAmount;
      Result.Materials[i].Channels[j].DiffuseMapEnable := Materials[i].Channels[j].DiffuseMapEnable;
      Result.Materials[i].Channels[j].DiffuseMap := Materials[i].Channels[j].DiffuseMap;
      Result.Materials[i].Channels[j].DiffuseMapAmount := Materials[i].Channels[j].DiffuseMapAmount;
      Result.Materials[i].Channels[j].SpecularMapEnable := Materials[i].Channels[j].SpecularMapEnable;
      Result.Materials[i].Channels[j].SpecularMap := Materials[i].Channels[j].SpecularMap;
      Result.Materials[i].Channels[j].SpecularMapAmount := Materials[i].Channels[j].SpecularMapAmount;
      Result.Materials[i].Channels[j].OpacityMapEnable := Materials[i].Channels[j].OpacityMapEnable;
      Result.Materials[i].Channels[j].OpacityMap := Materials[i].Channels[j].OpacityMap;
      Result.Materials[i].Channels[j].OpacityMapAmount := Materials[i].Channels[j].OpacityMapAmount;
      Result.Materials[i].Channels[j].LightMapEnable := Materials[i].Channels[j].IlluminationMapEnable;
      Result.Materials[i].Channels[j].LightMap := Materials[i].Channels[j].IlluminationMap;
      Result.Materials[i].Channels[j].LightMapAmount := Materials[i].Channels[j].IlluminationMapAmount;
      Result.Materials[i].Channels[j].NormalMapEnable := Materials[i].Channels[j].BumpMapEnable;
      Result.Materials[i].Channels[j].NormalMap := Materials[i].Channels[j].BumpMap;
      Result.Materials[i].Channels[j].NormalMapAmount := Materials[i].Channels[j].BumpMapAmount;
    end;
  end;
  Result.RagDollCount := 0;
  Result.LimitSkins(4);
end;
//TG2MeshLoaderG2M END

initialization
begin
  G2AddMeshLoader(TG2MeshLoaderG2M);
end;

end.
