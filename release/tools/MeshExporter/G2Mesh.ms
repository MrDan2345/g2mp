/*-----------------------------------------------------------------------------*\
Gen2 Mesh Exporter
		G2Mesh Format:
			Header: String4 = "G2M "
			
			Blocks:
				Block Name: String4
				Block Size: Int4
			
			Block "NMAP":
				NodeCount: Int4
				NodeOffsets[NodeCount]: Int4
			
			Block "NDAT":
				Nodes[NodeCount]:
					OwnerID: Int4
					NodeName: StringNT
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
					Vertices[VCount]: Vec3f
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
					Name: StringNT
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
						MatName: StringNT
						TwoSided: Bool
						AmbientColor: Byte[3]
						DiffuseColor: Byte[3]
						SpecularColor: Byte[3]
						SpecularColorAmount: Float4
						SpecularPower: Float4
						EmmissiveColor: Byte[3]
						EmmissiveColorAmount: Float4
						AmbientMapEnable: Bool
						AmbientMap: StringNT
						AmbientMapAmount: Float4
						DiffuseMapEnable: Bool
						DiffuseMap: StringNT
						DiffuseMapAmount: Float4
						SpecularMapEnable: Bool
						SpecularMap: StringNT
						SpecularMapAmount: Float4
						OpacityMapEnable: Bool
						OpacityMap: StringNT
						OpacityMapAmount: Float4
						IlluminationMapEnable: Bool
						IlluminationMap: StringNT
						IlluminationMapAmount: Float4
						BumpMapEnable: Bool
						BumpMap: StringNT
						BumpMapAmount: Float4
			
			Block "LMAP":
				LightCount: Int4
				LightOffsets[LightCount]: Int4
			
			Block "LDAT":
				Lights[LightCount]:
					NodeID: Int4
					Type: Byte
					Enabled: Bool
					Color: Byte[3]
					AttStart: Float4
					AttEnd: Float4
					SpotInner: Float4
					SpotOutter: Float4
					DirWidthInner: Float4
					DirWidthOutter: Float4
					DirHeightInner: Float4
					DirHeightOutter: Float4
\*-----------------------------------------------------------------------------*/
MacroScript Gen2ExportMacro
	category: "Gen2 Export"
	tooltip: "Gen2 Exporter"
	buttontext: "Gen2 Export..."
(
	global CreateRollout;
	global ExportRollout;
	global ExportFloater;
	global TNode;
	global TSkin;
	global ExportMacro;

	--Functions BEGIN
	global GetScope;
	global GetFrames;
	global WriteHeader;
	global WriteGeom;
	global WriteVector2f;
	global WriteVector3f;
	global WriteVector3i;
	global WriteMatrix4x3;
	global WriteColor3;
	global WriteColor4;
	global WriteBool;
	global WriteRagdollObject;
	global WriteMaterial;
	global ExtractBitmapFileName;
	global WriteOffset;
	global BlockBegin;
	global BlockEnd;
	global Export;
	global NodeListFindIDByName;
	global NodeListFindIDByObject;
	global NodeGetBounds;
	global RagdollObjectFromNode;
	global AnimListAdd;
	global AnimListRemove;
	global AnimListUpdate;
	global AnimListSelect;
	global AnimListFind;
	global MatListAdd;
	global MatListFindSingle;
	global MatListFindArray;
	global PropertiesSave;
	global PropertiesLoad;
	global PropertiesClear;
	global TransformLH;
	global RecursiveDependantSearch;
	global CompileRagdollDependants;
	global UninstallExporter;
	--Functions END

	--Variables BEGIN
	global BlockOffset;
	global NodeList = #();
	global GeomList = #();
	global AnimList = #();
	global SkinList = #();
	global MatList = #();
	global LightList = #();
	global RagdollList = #();
	global PhysiqueExposed = (physiqueOps != undefined);
	global MinV = point3 0 0 0;
	global MaxV = point3 0 0 0;
	--Variables END

	struct TNode (
		OwnerID = 0,
		NodeObj = undefined,
		KeyFrames = #()
	);

	struct TSkin (
		GeomID = 0,
		SkinMod = undefined
	);
	
	struct TGeom (
		NodeID = 0,
		GeomMesh = undefined,
		GeomChannels = #(),
		GeomMaterials = #()
	);
	
	struct TAnim (
		AnimName = "",
		AnimStart = 0,
		AnimEnd = 0,
		AnimKeysOnly = false,
		AnimFPS = 30
	);
	
	struct TLight (
		NodeID = 0,
		Type = 0,
		Enabled = false,
		Col = (color 0 0 0),
		AttStart = 0,
		AttEnd = 1,
		SpotInner = 1.5,
		SpotOutter = 2,
		DirWidthInner = 0.5,
		DirWidthOutter = 1,
		DirHeightInner = 0.5,
		DirHeightOutter = 1
	);
	
	struct TRagdollDependant (
		NodeID = 0,
		OffsetMat = (matrix3 1)
	);
	
	struct TRagdollObject (
		NodeID = 0,
		MinV = (point3 0 0 0),
		MaxV = (point3 0 0 0),
		TransformMat = (matrix3 1),
		Dependants = #()
	);
	
	struct TRagdoll (
		NodeID = 0,
		Head = undefined,
		Neck = undefined,
		Pelvis = undefined,
		Body = #(),
		ArmR = #(),
		ArmL = #(),
		LegR = #(),
		LegL = #(),
		ActiveNodes = #()
	);

	function Export = (
		FileName = GetSaveFileName types: "G2Mesh (*.g2m)|*.g2m|";
		if (FileName == undefined) then return OK;
		
		PrevSelection = #();
		for obj in selection do
		append PrevSelection obj;
		
		AnimBase = ExportRollout.spn1.value as integer;
		ExportGeometry = ExportRollout.chk5.checked;
		ExportAnimation = ExportRollout.chk6.checked;
		ExportLights = ExportRollout.chk7.checked;
		ExportSkinning = ExportRollout.chk26.checked;
		ExportMaterials = ExportRollout.chk25.checked;
		ExportRagdolls = ExportRollout.chk12.checked;
		
		at time AnimBase (
			Scope = GetScope();
			for obj in Scope do (
				n = (TNode NodeObj:obj);
				append NodeList n;
				NodeNameArr = filterString obj.Name ".";
				NodeName = "";
				for sn = 1 to NodeNameArr.Count do (
					append NodeName NodeNameArr[sn];
				);
				obj.Name = NodeName;
				if (obj.Material != undefined) then MatListAdd obj.Material;
			);
			for n = 1 to NodeList.Count do (
				NodeList[n].OwnerID = NodeListFindIDByObject NodeList[n].NodeObj.Parent;
				KeyFrames = #();
				if (classof(NodeList[n].NodeObj.controller) == prs) then (
					append KeyFrames NodeList[n].NodeObj.position.controller.keys;
					append KeyFrames NodeList[n].NodeObj.rotation.controller.keys;
					append KeyFrames NodeList[n].NodeObj.scale.controller.keys;
				);
				if (classof(NodeList[n].NodeObj.controller) == Vertical_Horizontal_Turn) then (
					append KeyFrames NodeList[n].NodeObj.controller.vertical.controller.keys;
						append KeyFrames NodeList[n].NodeObj.controller.horizontal.controller.keys;
						append KeyFrames NodeList[n].NodeObj.controller.turning.controller.keys;
				);
				if (classof(NodeList[n].NodeObj.controller) == BipSlave_Control) then (
					append KeyFrames NodeList[n].NodeObj.controller.keys;
				);
				for Keys in KeyFrames do (
					for Key in Keys do (
						FrameTime = Int(Key.time);
						AddFrame = True;
						for f in NodeList[n].KeyFrames do (
							if (f == FrameTime) then (
								AddFrame = False;
								Break;
							);
						);
						if (AddFrame) then (
							append NodeList[n].KeyFrames FrameTime;
						);
					);
				);
				if (SuperClassOf NodeList[n].NodeObj == Light)\
					and (
						(ClassOf NodeList[n].NodeObj == Directionallight)\
						or
						(ClassOf NodeList[n].NodeObj == TargetDirectionallight)\
						or
						(ClassOf NodeList[n].NodeObj == TargetSpot)\
						or
						(ClassOf NodeList[n].NodeObj == FreeSpot)\
						or
						(ClassOf NodeList[n].NodeObj == Omnilight)\
					) then (
					l = (TLight NodeID: n);
					if (
						(ClassOf NodeList[n].NodeObj == Directionallight)\
						or
						(ClassOf NodeList[n].NodeObj == TargetDirectionallight)\
					) then (
						l.Type = 2;
						l.DirWidthInner = NodeList[n].NodeObj.Hotspot;
						l.DirWidthOutter = NodeList[n].NodeObj.Falloff;
						l.DirHeightInner = l.DirWidthInner / NodeList[n].NodeObj.Aspect;
						l.DirHeightOutter = l.DirWidthOutter / NodeList[n].NodeObj.Aspect;
					)
					else if (
						(ClassOf NodeList[n].NodeObj == TargetSpot)\
						or
						(ClassOf NodeList[n].NodeObj == FreeSpot)\
					) then (
						l.Type = 1;
						l.SpotInner = DegToRad NodeList[n].NodeObj.Hotspot;
						l.SpotOutter = DegToRad NodeList[n].NodeObj.Falloff;
					)
					else (
						l.Type = 0;
					);
					l.Enabled = NodeList[n].NodeObj.Enabled;
					l.Col = NodeList[n].NodeObj.Color;
					l.AttStart = NodeList[n].NodeObj.Attenuation_Far_Start;
					l.AttEnd = NodeList[n].NodeObj.Attenuation_Far_End;
					append LightList l;
				)
				else if (
					(ClassOf(NodeList[n].NodeObj) == Biped_Object)\
					and
					(ClassOf(NodeList[n].NodeObj.Parent) != Biped_Object)\
					and
					(ClassOf(NodeList[n].NodeObj.Controller) != Footsteps)\
					and
					(CanConvertTo NodeList[n].NodeObj TriMeshGeometry)\
				) then (
					r = (TRagdoll NodeID: n);
					rn = NodeList[n].NodeObj;
					r.Head = RagdollObjectFromNode (biped.getNode rn #Head link:1);
					r.Neck = RagdollObjectFromNode (biped.getNode rn #Neck link:1);
					r.Pelvis = RagdollObjectFromNode (biped.getNode rn #Pelvis link:1);
					append r.ActiveNodes r.Head;
					append r.ActiveNodes r.Neck;
					append r.ActiveNodes r.Pelvis;
					bn = 1;
					cn = biped.getNode rn #Spine link:bn;
					while cn != undefined do (
						ro = (RagdollObjectFromNode cn);
						append r.Body ro;
						append r.ActiveNodes ro;
						bn = bn + 1;
						cn = biped.getNode rn #Spine link:bn;
					);
					bn = 2;
					cn = biped.getNode rn #RArm link:bn;
					while cn != undefined do (
						ro = (RagdollObjectFromNode cn);
						append r.ArmR ro;
						append r.ActiveNodes ro;
						bn = bn + 1;
						cn = biped.getNode rn #RArm link:bn;
					);
					bn = 2;
					cn = biped.getNode rn #LArm link:bn;
					while cn != undefined do (
						ro = (RagdollObjectFromNode cn);
						append r.ArmL ro;
						append r.ActiveNodes ro;
						bn = bn + 1;
						cn = biped.getNode rn #LArm link:bn;
					);
					bn = 1;
					cn = biped.getNode rn #RLeg link:bn;
					while cn != undefined do (
						ro = (RagdollObjectFromNode cn);
						append r.LegR ro;
						append r.ActiveNodes ro;
						bn = bn + 1;
						cn = biped.getNode rn #RLeg link:bn;
					);
					bn = 1;
					cn = biped.getNode rn #LLeg link:bn;
					while cn != undefined do (
						ro = (RagdollObjectFromNode cn);
						append r.LegL ro;
						append r.ActiveNodes ro;
						bn = bn + 1;
						cn = biped.getNode rn #LLeg link:bn;
					);
					CompileRagdollDependants r;
					append RagdollList r;
				)
				else if (
					(CanConvertTo NodeList[n].NodeObj TriMeshGeometry)\
					and
					(ClassOf(NodeList[n].NodeObj) != BoneGeometry)\
					and
					(ClassOf(NodeList[n].NodeObj) != Biped_Object)\
					and
					(ClassOf(NodeList[n].NodeObj) != Dummy)\
					and
					(NodeList[n].NodeObj.Renderable)\
					and
					(SuperClassOf(NodeList[n].NodeObj) != Shape)
				) then (
					t = NodeList[n].NodeObj.Transform;
					NodeList[n].NodeObj.Transform = matrix3 1;
					g = (TGeom GeomMesh: (SnapshotAsMesh NodeList[n].NodeObj) NodeID: n);
					NodeList[n].NodeObj.Transform = t;
					g.GeomChannels = #();
					for i = 1 to 99 do (
						if (\
							(meshop.getMapSupport g.GeomMesh i)\
							and	(meshop.getNumMapVerts g.GeomMesh i > 0)
						) then (
							append g.GeomChannels i;
						);
					);
					g.GeomMaterials = MatListFindArray NodeList[n].NodeObj.Material;
					append GeomList g;
					for m in NodeList[n].NodeObj.Modifiers do
					if (
						(ClassOf(m) == Skin)\
						or
						(
							(ClassOf(m) == Physique)\
							and
							(PhysiqueExposed)\
						)
					) then (
						Append SkinList (TSkin GeomID: GeomList.Count SkinMod: m);
						Break;
					);
				);
			);
		);
		
		File = fopen FileName "wb";
		
		try (
			--Write Header BEGIN
			WriteHeader File "G2M ";
			--Write Header END
			
			--Write Node Map BEGIN
			BlockBegin File "NMAP";
			
			WriteLong File NodeList.Count;
			NodeOffsets = #();
			for n in NodeList do (
				append NodeOffsets (ftell File);
				WriteLong File 0;
			);
			
			BlockEnd File;
			--Write Node Map END

			--Write Node Data BEGIN
			BlockBegin File "NDAT";
			
			for n = 1 to NodeList.Count do (
				WriteOffset File NodeOffsets[n];
				WriteLong File (NodeList[n].OwnerID - 1);
				WriteString File NodeList[n].NodeObj.Name;
				at time AnimBase (
					ws = TransformLH NodeList[n].NodeObj.Transform;
					if (NodeList[n].OwnerID > 0) then (
						os = ws * (inverse (TransformLH NodeList[NodeList[n].OwnerID].NodeObj.Transform));
					)
					else (
						os = ws;
					);
					WriteMatrix4x3 File os;
				);
			);
			
			BlockEnd File;
			--Write Node Data END
			
			if (ExportGeometry) then (
				--Write Geom Map BEGIN
				BlockBegin File "GMAP";
				
				WriteLong File GeomList.Count;
				GeomOffsets = #();
				for g in GeomList do (
					append GeomOffsets (ftell File);
					WriteLong File 0;
				);
				
				BlockEnd File;
				--Write Geom Map END	
				
				--Write Geom Data BEGIN
				BlockBegin File "GDAT";
				
				for g = 1 to GeomList.Count do (
					WriteOffset File GeomOffsets[g];
					Geom = GeomList[g];
					WriteLong File (Geom.NodeID - 1);
					VCount = Geom.GeomMesh.numVerts;
					CCount = Geom.GeomMesh.numCPVVerts;
					FCount = Geom.GeomMesh.numFaces;
					MCount = Geom.GeomMaterials.Count;
					TCount = Geom.GeomChannels.Count;
					WriteLong File VCount;
					if (CCount > 0) then (
						WriteLong File CCount;
					);
					else (
						WriteLong File 1;
					);
					WriteLong File FCount;
					WriteLong File MCount;
					WriteLong File TCount;
					for v = 1 to VCount do (
						Pos = getVert Geom.GeomMesh v;
						WriteVector3f File [Pos.x, Pos.z, Pos.y];
					);
					if (CCount > 0) then (
						for v = 1 to CCount do (
							Col = getVertColor Geom.GeomMesh v;
							WriteColor3 File Col;
						);
					);
					else (
						Col = color 255 255 255;
						WriteColor3 File Col;
					);
					for t = 1 to TCount do (
						TVCount = meshop.getNumMapVerts Geom.GeomMesh Geom.GeomChannels[t];
						WriteLong File TVCount;
						for i = 1 to TVCount do (
							Tex = meshop.getMapVert Geom.GeomMesh Geom.GeomChannels[t] i;
							WriteVector2f File [Tex.x, 1 - Tex.y];
						);
					);
					for m = 1 to MCount do (
						WriteLong File (Geom.GeomMaterials[m] - 1);
					);
					for f = 1 to FCount do (
						Pos = getFace Geom.GeomMesh f;
						WriteVector3i File [Pos.x, Pos.z, Pos.y];
						if (CCount > 0) then (
							Col = meshop.getMapFace Geom.GeomMesh 0 f;
							WriteVector3i File [Col.x, Col.z, Col.y];
						);
						else (
							WriteVector3i File [1, 1, 1];
						);
						for t = 1 to TCount do (
							Tex = meshop.getMapFace Geom.GeomMesh Geom.GeomChannels[t] f;
							WriteVector3i File [Tex.x, Tex.z, Tex.y];
						);
						WriteLong File ((getFaceSmoothGroup Geom.GeomMesh f) - 1);
						if (Geom.GeomMaterials.Count == 0) then (
						WriteLong File -1;
						) else if (Geom.GeomMaterials.Count == 1) then (
							WriteLong File 0;
						) else (
							WriteLong File ((getFaceMatId Geom.GeomMesh f) - 1);
						);
					);
				);
				
				BlockEnd File;
				--Write Geom Data END
			);

			if (ExportAnimation) then (
				--Write Animation Map BEGIN
				BlockBegin File "AMAP";
				
				WriteLong File AnimList.Count;
				AnimOffsets = #();
				for a in AnimList do (
					append AnimOffsets (ftell File);
					WriteLong File 0;
				);
				
				BlockEnd File;
				--Write Animation Map END
				
				--Write Animation Data BEGIN
				BlockBegin File "ADAT";
				
				for a = 1 to AnimList.Count do (
					WriteOffset File AnimOffsets[a];
					Anim = AnimList[a];
					WriteString File Anim.AnimName;
					WriteLong File (Anim.AnimEnd - Anim.AnimStart + 1);
					WriteLong File Anim.AnimFPS;
					AnimNodes = #();
					for n = 1 to NodeList.Count do (
						AddNode = False;
						if (ClassOf(NodeList[n].NodeObj.Controller) == Link_Constraint) then (
							AddNode = True;
						) else (
							NObj = NodeList[n];
							while (NObj != undefined) do (
								for f in NObj.KeyFrames do (
									if ((f >= Anim.AnimStart) and (f <= Anim.AnimEnd)) then (
										AddNode = True;
										Break;
									);
								);
								if (NObj.OwnerID > 0) then (
									NObj = NodeList[NObj.OwnerID];
								) else (
									NObj = undefined;
								);
							);
						);
						if (AddNode) then (
							append AnimNodes n;
						);
					);
					WriteLong File AnimNodes.Count;
					for n in AnimNodes do (
						WriteLong File (n - 1);
						for f = Anim.AnimStart to Anim.AnimEnd do (
							at time f (
								if NodeList[n].OwnerID > 0 then (
									OwnerWS = TransformLH NodeList[NodeList[n].OwnerID].NodeObj.Transform;
									WS = TransformLH NodeList[n].NodeObj.Transform;
									AnimTransform = WS * (inverse OwnerWS);
								) else (
									AnimTransform = TransformLH NodeList[n].NodeObj.Transform;
								);
								WriteMatrix4x3 File AnimTransform;
							);
						);
					);
				);
				
				BlockEnd File;
				--Write Animation Data END
			);

			if (ExportSkinning) then (
				--Write Skin Map BEGIN
				BlockBegin File "SMAP";
				
				WriteLong File SkinList.Count;
				SkinsOffsets = #();
				for s in SkinList do (
					append SkinsOffsets (ftell File);
					WriteLong File 0;
				);
				
				BlockEnd File;
				--Write Skin Map END
				
				--Write Skin Data BEGIN
				BlockBegin File "SDAT";
				
				for s = 1 to SkinList.Count do (
					WriteOffset File SkinsOffsets[s];
					WriteLong File (SkinList[s].GeomID - 1);
					g = GeomList[SkinList[s].GeomID];
					n = NodeList[g.NodeID];
					m = SkinList[s].SkinMod;
					if (ClassOf(m) == Skin) then (
						max modify mode;
						modPanel.setCurrentObject m;
						BCount = skinOps.GetNumberBones m;
						WriteLong File BCount;
						CurBones = #();
						at time AnimBase (
							for b = 1 to BCount do (
								BName = (skinOps.GetBoneName m b 1);
								NodeID = NodeListFindIDByName BName;
								WriteLong File (NodeID - 1);
								Bind = (TransformLH n.NodeObj.Transform) * inverse (TransformLH NodeList[NodeID].NodeObj.Transform);
								WriteMatrix4x3 File Bind;
								append CurBones NodeID;
							);
						);
						for p = 1 to g.GeomMesh.numVerts do (
							BCount = skinOps.getVertexWeightCount m p;
							WriteLong File BCount;
							for b = 1 to BCount do (
								BName = (skinOps.GetBoneName m (skinOps.getVertexWeightBoneID m p b) 1);
								NodeID = NodeListFindIDByName BName;
								NodeW = skinOps.getVertexWeight m p b;
								BoneID = 0;
								for n = 1 to CurBones.Count do (
									if (NodeID == CurBones[n]) then (
										BoneID = n;
										Break;
									);
								);
								WriteLong File (BoneID - 1);
								WriteFloat File NodeW;
							);
						);
					) else if (ClassOf(m) == Physique) then (
						BCount = physiqueOps.GetBoneCount n;
						SkinBones = physiqueOps.GetBones n;
						WriteLong File BCount;
						CurBones = #();
						at time AnimBase (
							for b = 1 to BCount do (
								BoneNode = SkinBones[b];
								NodeID = NodeListFindIDByObject Nodes BoneNode;
								WriteLong File (NodeID - 1);
								Bind = (TransformLH n.NodeObj.Transform) * inverse (TransformLH NodeList[NodeID].NodeObj.Transform);
								WriteMatrix4x3 File Bind;
								append CurBones NodeID;
							);
						);
						for p = 1 to g.GeomMesh.numVerts do (
							BCount = physiqueOps.getVertexBoneCount Geoms[s.Geom] p;
							WriteLong File BCount;
							for b = 1 to BCount do (
								BoneNode = physiqueOps.getVertexBone Geoms[s.Geom] p b;
								NodeID = NodeListFindIDByObject Nodes BoneNode;
								NodeW = (physiqueOps.getVertexWeight Geoms[s.Geom] p b);
								BoneID = 0;
								for n = 1 to CurBones.Count do (
									if (NodeID == CurBones[n]) then (
										BoneID = n;
										Break;
									);
								);
								WriteLong File (BoneID - 1);
								WriteFloat File NodeW;
							);
						);
					);
				);
				
				BlockEnd File;
				--Write Skin Data END
			);
			
			if (ExportMaterials) then (
				--Write Material Map BEGIN
				BlockBegin File "MMAP";
				
				WriteLong File MatList.Count;
				MatOffsets = #();
				for m in MatList do (
					append MatOffsets (ftell File);
					WriteLong File 0;
				);
				
				BlockEnd File;
				--Write Material Map END
				
				--Write Material Data BEGIN
				BlockBegin File "MDAT";

				for i = 1 to MatList.Count do (
					WriteOffset File MatOffsets[i];
					m = MatList[i];
					if (ClassOf(m) == CompositeMaterial) then (
						matarr = #();
						for j = 1 to m.MaterialList.Count do (
							if (m.MaterialList[j] != undefined) then (
								append matarr m.MaterialList[j];
							);
						);
						WriteLong File matarr.Count;
						for j = 1 to matarr.Count do (
							if (ClassOf(matarr[j]) == Standard) then (
								WriteMaterial File matarr[j];
							);
							else (
								WriteMaterial File undefined;
							);
						);
					)
					else if (ClassOf(m) == Standard) then (
						WriteLong File 1;
						WriteMaterial File m;
					)
					else (
						WriteLong File 1;
						WriteMaterial File undefined;
					);
				);
				
				BlockEnd File;
				--Write Material Data END
			);
			
			if (ExportLights) then (
				--Write Light Map BEGIN
				BlockBegin File "LMAP";
				
				WriteLong File LightList.Count;
				LightOffsets = #();
				for l in LightList do (
					append LightOffsets (ftell File);
					WriteLong File 0;
				);
				
				BlockEnd File;
				--Write Light Map END
				
				--Write Light Data BEGIN
				BlockBegin File "LDAT";
				
				for i = 1 to LightList.Count do (
					WriteOffset File LightOffsets[i];
					l = LightList[i];
					WriteLong File (l.NodeID - 1);
					WriteByte File l.Type;
					WriteBool File l.Enabled;
					WriteColor3 File l.Col;
					WriteFloat File l.AttStart;
					WriteFloat File l.AttEnd;
					WriteFloat File l.SpotInner;
					WriteFloat File l.SpotOutter;
					WriteFloat File l.DirWidthInner;
					WriteFloat File l.DirWidthOutter;
					WriteFloat File l.DirHeightInner;
					WriteFloat File l.DirHeightOutter;
				);
				
				BlockEnd File;
				--Write Light Data END
			);
			
			if (ExportRagdolls) then (
				--Write Ragdolls BEGIN
				BlockBegin File "RGDL";
				
				WriteLong File RagdollList.Count;
				for r in RagdollList do (
					WriteLong File (r.NodeID - 1);
					WriteRagdollObject File r.Head;
					WriteRagdollObject File r.Neck;
					WriteRagdollObject File r.Pelvis;
					WriteLong File r.Body.Count;
					for i = 1 to r.Body.Count do
					WriteRagdollObject File r.Body[i];
					WriteLong File r.ArmR.Count;
					for i = 1 to r.ArmR.Count do
					WriteRagdollObject File r.ArmR[i];
					WriteLong File r.ArmL.Count;
					for i = 1 to r.ArmL.Count do
					WriteRagdollObject File r.ArmL[i];
					WriteLong File r.LegR.Count;
					for i = 1 to r.LegR.Count do
					WriteRagdollObject File r.LegR[i];
					WriteLong File r.LegL.Count;
					for i = 1 to r.LegL.Count do
					WriteRagdollObject File r.LegL[i];
				);
				
				BlockEnd File;
			);
		)
		catch (
			MessageBox (getCurrentException());
		);
		fclose File;
		if ExportRollout.chk87.checked then (
			ObjLog = "";
			for obj in NodeList do (
				append ObjLog ((classof(obj.NodeObj) as string) + ": " + obj.NodeObj.Name + "\r\n");
			);
			MessageBox(ObjLog);
		);
		Select PrevSelection;
	);
	
	function GetScope = (
		Scope = #();
		for obj in objects do (
			if (
				(
					(ExportRollout.rdo3.state == 1)\
					or (
						(ExportRollout.chk1.checked or obj.isSelected)\
						and (ExportRollout.chk2.checked or not obj.isHidden)\
						and (ExportRollout.chk3.checked or not obj.isFrozen)\
						and (ExportRollout.chk4.checked or obj.renderable)\
					)
				) and (
					not (
						(classof(obj) == Dummy)\
						and (classof(obj.controller) == BipSlave_Control)\
					)\
					and not (classof(obj.controller) == Footsteps)\
				)
			) then (
				append Scope obj;
			);
		);
		return Scope;
	);
	
	--File Writing BEGIN
	function WriteHeader f s = (
		Ret = WriteString f s;
		fseek f -1 #seek_cur;
		return Ret;
	);

	function WriteOffset f Offset = (
		CurOffset = ftell f;
		fseek f Offset #seek_set;
		WriteLong f CurOffset;
		fseek f CurOffset #seek_set;
	);

	function WriteVector2f f v = (
		WriteFloat f v.x;
		WriteFloat f v.y;
	);
	
	function WriteVector3f f v = (
		WriteFloat f v.x;
		WriteFloat f v.y;
		WriteFloat f v.z;
	);

	function WriteVector3i f v = (
		WriteLong f (v.x - 1);
		WriteLong f (v.y - 1);
		WriteLong f (v.z - 1);
	);

	function WriteMatrix4x3 f m = (
		for i = 1 to 4 do
		for j = 1 to 3 do
		WriteFloat f m[i][j];
	);
	
	function WriteColor3 f c = (
		WriteByte f c.Red;
		WriteByte f c.Green;
		WriteByte f c.Blue;
	);

	function WriteColor4 f c a = (
		WriteByte f c.Red;
		WriteByte f c.Green;
		WriteByte f c.Blue;
		WriteByte f a;
	);
	
	function WriteBool f b = (
		if (b) then
		WriteByte f 1;
		else
		WriteByte f 0;
	);
	
	function WriteRagdollObject f ro = (
		WriteLong f (ro.NodeID - 1);
		WriteVector3f f [ro.MinV.x, ro.MinV.z, ro.MinV.y];
		WriteVector3f f [ro.MaxV.x, ro.MaxV.z, ro.MaxV.y];
		WriteMatrix4x3 f (ro.TransformMat);
		WriteLong f ro.Dependants.Count;
		for i = 1 to ro.Dependants.Count do (
			WriteLong f (ro.Dependants[i].NodeID - 1);
			WriteMatrix4x3 f ro.Dependants[i].OffsetMat;
		);
	);
	
	function WriteMaterial f m = (
		if (m != undefined) then (
			MatName = m.Name;
			MatTwoSided = m.TwoSided;
			MatAmbientColor = m.Ambient;
			MatDiffuseColor = m.Diffuse;
			MatSpecularColor = m.Specular;
			MatSpecularColorAmount = m.SpecularLevel;
			MatSpecularPower = m.Glossiness;
			MatEmmissiveColor = m.SelfIllumColor;
			MatEmmissiveColorAmount = m.SelfIllumAmount;
			MatAmbientMapEnable = (\
				(m.AmbientMapEnable and (m.AmbientMap != undefined))\
				and
				(ClassOf(m.AmbientMap) == Bitmaptexture)\
			);
			if (MatAmbientMapEnable) then
			MatAmbientMap = ExtractBitmapFileName m.AmbientMap;
			else
			MatAmbientMap = "";
			MatAmbientMapAmount = m.AmbientMapAmount;
			MatDiffuseMapEnable = (\
				(m.DiffuseMapEnable and (m.DiffuseMap != undefined))\
				and
				(ClassOf(m.DiffuseMap) == Bitmaptexture)\
			);
			if (MatDiffuseMapEnable) then
			MatDiffuseMap = ExtractBitmapFileName m.DiffuseMap;
			else
			MatDiffuseMap = "";
			MatDiffuseMapAmount = m.DiffuseMapAmount;
			MatSpecularMapEnable = m.SpecularMapEnable;
			if (\
				(m.SpecularMap != undefined)\
				and
				(ClassOf(m.SpecularMap) == Bitmaptexture)\
			) then 
			MatSpecularMap = ExtractBitmapFileName m.SpecularMap;
			else
			MatSpecularMap = "";
			MatSpecularMapAmount = m.SpecularMapAmount;
			MatOpacityMapEnable = m.OpacityMapEnable;
			if (\
				(m.OpacityMap != undefined)\
				and
				(ClassOf(m.OpacityMap) == Bitmaptexture)\
			) then
			MatOpacityMap = ExtractBitmapFileName m.OpacityMap;
			else
			MatOpacityMap = "";
			MatOpacityMapAmount = m.OpacityMapAmount;
			MatIlluminationMapEnable = m.SelfIllumMapEnable;
			if (\
				(m.SelfIllumMap != undefined)\
				and
				(ClassOf(m.SelfIllumMap) == Bitmaptexture)\
			) then
			MatIlluminationMap = ExtractBitmapFileName m.SelfIllumMap;
			else
			MatIlluminationMap = "";
			MatIlluminationMapAmount = m.SelfIllumMapAmount;
			MatBumpMapEnable = m.BumpMapEnable;
			if (\
				(m.BumpMap != undefined)\
				and
				(\
					(ClassOf(m.BumpMap) == Bitmaptexture)\
					or
					(ClassOf(m.BumpMap) == Normal_Bump)\
				)\
			) then (
				if (ClassOf(m.BumpMap) == Normal_Bump) then
				MatBumpMap = ExtractBitmapFileName m.BumpMap.normal_map;
				else
				MatBumpMap = ExtractBitmapFileName m.BumpMap;
			)
			else
			MatBumpMap = "";
			MatBumpMapAmount = m.BumpMapAmount;
		)
		else (
			MatName = "Undefined";
			MatTwoSided = False;
			MatAmbientColor = color 1 1 1;
			MatDiffuseColor = color 1 1 1;
			MatSpecularColor = color 0 0 0;
			MatSpecularColorAmount = 0;
			MatSpecularPower = 1;
			MatEmmissiveColor = color 0 0 0;
			MatEmmissiveColorAmount = 0;
			MatAmbientMapEnable = False;
			MatAmbientMap = "";
			MatAmbientMapAmount = 0;
			MatDiffuseMapEnable = False;
			MatDiffuseMap = "";
			MatDiffuseMapAmount = 0;
			MatSpecularMapEnable = False;
			MatSpecularMap = "";
			MatSpecularMapAmount = 0;
			MatOpacityMapEnable = False;
			MatOpacityMap = "";
			MatOpacityMapAmount = 0;
			MatIlluminationMapEnable = False;
			MatIlluminationMap = "";
			MatIlluminationMapAmount = 0;
			MatBumpMapEnable = False;
			MatBumpMap = ""
			MatBumpMapAmount = 0;
		);
		WriteString f MatName;
		WriteBool f MatTwoSided;
		WriteColor3 f MatAmbientColor;
		WriteColor3 f MatDiffuseColor;
		WriteColor3 f MatSpecularColor;
		WriteFloat f MatSpecularColorAmount;
		WriteFloat f MatSpecularPower;
		WriteColor3 f MatEmmissiveColor;
		WriteFloat f MatEmmissiveColorAmount;
		WriteBool f MatAmbientMapEnable;
		WriteString f MatAmbientMap;
		WriteFloat f MatAmbientMapAmount;
		WriteBool f MatDiffuseMapEnable;
		WriteString f MatDiffuseMap;
		WriteFloat f MatDiffuseMapAmount;
		WriteBool f MatSpecularMapEnable;
		WriteString f MatSpecularMap;
		WriteFloat f MatSpecularMapAmount;
		WriteBool f MatOpacityMapEnable;
		WriteString f MatOpacityMap;
		WriteFloat f MatOpacityMapAmount;
		WriteBool f MatIlluminationMapEnable;
		WriteString f MatIlluminationMap;
		WriteFloat f MatIlluminationMapAmount;
		WriteBool f MatBumpMapEnable;
		WriteString f MatBumpMap;
		WriteFloat f MatBumpMapAmount;
	);
	
	function ExtractBitmapFileName b = (
		BNameArr = filterString b.FileName "\\";
		return BNameArr[BNameArr.Count];	
	);
	
	function BlockBegin f s = (
		WriteHeader f s;
		BlockOffset = ftell f;
		WriteLong f 0;
	);

	function BlockEnd f = (
		OffsetEnd = ftell f;
		fseek f BlockOffset #seek_set;
		WriteLong f (OffsetEnd - BlockOffset - 4);
		fseek f OffsetEnd #seek_set;
	);
	--File Writing END
	
	--NodeList Controls BEGIN
	function NodeListFindIDByObject Obj = (
		for n = 1 to NodeList.Count do (
			if (NodeList[n].NodeObj == Obj) then
			return n;
		);
		return 0;
	);
	
	function NodeListFindIDByName NodeName = (
		NNameArr = filterString NodeName " ";
		NName = "";
		for sn = 1 to NNameArr.Count do (
			if (sn > 1) then append NName "_";
			append NName NNameArr[sn];
		);
		NodeObj = execute ("$" + NName);
		return NodeListFindIDByObject NodeObj;
	);
	
	function NodeGetBounds Obj = (
		t = Obj.Transform;
		ti = inverse t;
		m = SnapshotAsMesh Obj;
		VCount = m.NumVerts;
		MinV = point3 0 0 0;
		MaxV = point3 0 0 0;
		if (VCount > 0) then (
			MinV = (getVert m 1) * ti;
			MaxV = (getVert m 1) * ti;
			for i = 2 to VCount do (
				v = (getVert m i) * ti;
				if (v.x < MinV.x) then MinV.x = v.x;
				if (v.y < MinV.y) then MinV.y = v.y;
				if (v.z < MinV.z) then MinV.z = v.z;
				if (v.x > MaxV.x) then MaxV.x = v.x;
				if (v.y > MaxV.y) then MaxV.y = v.y;
				if (v.z > MaxV.z) then MaxV.z = v.z;
			);
		);
	);
	
	function RagdollObjectFromNode n = (
		NodeGetBounds n;
		ro = (TRagdollObject NodeID: (NodeListFindIDByObject n));
		ro.MinV = MinV;
		ro.MaxV = MaxV;
		ro.TransformMat = TransformLH n.Transform;
		return ro;
	);
	
	function RecursiveDependantSearch DRagdoll DRagdollNode DSceneNode = (
		rdpnt = DRagdollNode.TransformMat;
		for dn in DSceneNode.Children do (
			AddDep = True;
			for i = 1 to DRagdoll.ActiveNodes.Count do (
				if (dn == NodeList[DRagdoll.ActiveNodes[i].NodeID].NodeObj) then (
					AddDep = False;
					Break;
				);
			);
			if (AddDep) then (
				Ind = NodeListFindIDByObject dn;
				if (Ind > 0) then (
					d = (TRagdollDependant NodeID: Ind);
					d.OffsetMat = (TransformLH dn.Transform) * (inverse rdpnt);
					append DRagdollNode.Dependants d;
				);
				if (dn.Children.Count > 0) then
				RecursiveDependantSearch DRagdoll DRagdollNode dn;
			);
		);
	);
	
	function CompileRagdollDependants r = (
		for rn in r.ActiveNodes do (
			n = NodeList[rn.NodeID].NodeObj;
			if (n.Children.Count > 0) then
			RecursiveDependantSearch r rn n;
		);
	);
	--NodeList Controls END
	
	--AnimList Controls BEGIN
	function AnimListFind AnimName = (
		for i = 1 to AnimList.Count do (
			if (AnimList[i].AnimName == AnimName) then return i;
		);
		return 0;
	);
	
	function AnimListAdd NewName NewStart NewEnd = (
		if (NewName == unsupplied or NewName == undefined or NewName == "") then (
			AnimName = "Animation";
			AnimInd = 1;
			TmpName = AnimName + (AnimInd as string);
			while ((AnimListFind TmpName) > 0) do (
				AnimInd += 1;
				TmpName = AnimName + (AnimInd as string);
			);
			AnimName = TmpName;
		)
		else (
			AnimName = NewName;
		);
		if (NewStart == unsupplied or NewStart == undefined) then (
			AnimStart = AnimationRange.Start.Frame as integer;
		)
		else (
			AnimStart = NewStart;
		);
		if (NewEnd == unsupplied or NewEnd == undefined) then (
			AnimEnd = AnimationRange.End.Frame as integer;
		)
		else (
			AnimEnd = NewEnd;
		);
		append AnimList (TAnim AnimName:AnimName AnimStart:AnimStart AnimEnd:AnimEnd);
		AnimListUpdate();
	);
	
	function AnimListRemove = (
		RemoveID = ExportRollout.lbx1.selection;
		if (AnimList.Count <= 1) then return OK;
		deleteItem AnimList RemoveID;
		AnimListUpdate();
	);
	
	function AnimListUpdate = (
		PrevSelection = ExportRollout.lbx1.selection;
		TmpArr = #();
		for Anim in AnimList do (
			append TmpArr Anim.AnimName;
		);
		ExportRollout.lbx1.items = TmpArr;
		if (PrevSelection > ExportRollout.lbx1.items.count) then (
			ExportRollout.lbx1.selection = ExportRollout.lbx1.items.count;
		);
		AnimListSelect();
	);
	
	function AnimListSelect = (
		Sel = ExportRollout.lbx1.selection;
		ExportRollout.edt1.text = AnimList[Sel].AnimName;
		ExportRollout.spn2.value = AnimList[Sel].AnimStart;
		ExportRollout.spn3.value = AnimList[Sel].AnimEnd;
		ExportRollout.chk8.checked = AnimList[Sel].AnimKeysOnly;
		ExportRollout.spn4.value = AnimList[Sel].AnimFPS;
	);
	--AnimList Controls END
	
	--Material List Controls BEGIN
	function MatListAdd Mat = (
		if (ClassOf(Mat) == Shell_Material) then (
			MatListAdd Mat[1];
			MatListAdd Mat[2];
		) else if (ClassOf(Mat) == Multimaterial) then (
			for m = 1 to Mat.NumSubs do (
				MatListAdd Mat.MaterialList[m];
			);
		) else if (\
			(ClassOf(Mat) == Standard)\
			or
			(ClassOf(Mat) == CompositeMaterial)\
		) then (\
			Ind = 0;
			for i = 1 to MatList.Count do (
				if (MatList[i] == Mat) then (
					Ind = i;
				);
			);
			if (Ind == 0) then (
				append MatList Mat;
			)
		);
	);
	
	function MatListFindSingle Mat = (
		if (\
			(Classof(Mat) != Standard)\
			and
			(Classof(Mat) != StandardMaterial)\
			and
			(Classof(Mat) != Shell_Material)\
			and
			(Classof(Mat) != Multimaterial)\
			and
			(Classof(Mat) != CompositeMaterial)\
		) then (
			return 0;
		);
		m = Mat;
		if (ClassOf(m) == Shell_Material) then (
			if (m.viewportMtlIndex == 0) then m = m.originalMaterial;
			else m = m.bakedMaterial;
		) else (
			while (ClassOf(m) == Multimaterial) do (
				if (m.NumSubs > 0) then (
					m = m.MaterialList[1];
				) else (
					return 0;
				);
			);
		);
		Ind = 0;
		for i = 1 to MatList.Count do (
			if (MatList[i] == m) then (
				Ind = i;
				Break;
			);
		);
		if (Ind == 0) then (
			MatListAdd m;
			Ind = MatListFindSingle m;
			if (Ind == 0) then (
				return 0;
			);
		);
		return Ind;
	);
	
	function MatListFindArray Mat = (
		Res = #();
		if (ClassOf(Mat) == Multimaterial) then (
			for m = 1 to Mat.NumSubs do (
				append Res (MatListFindSingle (Mat.MaterialList[m]));
			);
		) else if (
			(ClassOf(Mat) == Shell_Material)\
			and
			(ClassOf(Mat.originalMaterial) == Multimaterial)\
		) then (
			if (Mat.viewportMtlIndex == 0) then sm = Mat.originalMaterial;
			else sm = Mat.bakedMaterial;
			for m = 1 to sm.NumSubs do (
				append Res (MatListFindSingle (sm.MaterialList[m]));
			);
		) else if (
			(ClassOf(Mat) == Standard)\
			or
			(Classof(Mat) == StandardMaterial)\
			or 
			(ClassOf(Mat) == Shell_Material)\
			or 
			(ClassOf(Mat) == CompositeMaterial)\
		) then (
			append Res (MatListFindSingle Mat);
		);
		return Res;
	);
	--Material List Controls END

	--MAX File Properties BEGIN
	function PropertiesSave = (
		Props = (ExportRollout.rdo3.state as String) + ";";
		Props += (ExportRollout.chk1.checked as String) + ";";
		Props += (ExportRollout.chk2.checked as String) + ";";
		Props += (ExportRollout.chk3.checked as String) + ";";
		Props += (ExportRollout.chk4.checked as String) + ";";
		Props += (ExportRollout.chk5.checked as String) + ";";
		Props += (ExportRollout.chk6.checked as String) + ";";
		Props += (ExportRollout.chk7.checked as String) + ";";
		Props += (ExportRollout.chk12.checked as String) + ";";
		Props += (ExportRollout.chk25.checked as String) + ";";
		Props += (ExportRollout.chk26.checked as String) + ";";
		Props += (ExportRollout.chk87.checked as String) + ";";
		Props += (ExportRollout.spn1.value as String) + ";";
		Props += (AnimList.Count as String) + ";";
		for a in AnimList do (
			Props += (a.AnimName) + ";";
			Props += (a.AnimStart as String) + ";";
			Props += (a.AnimEnd as String) + ";";
			Props += (a.AnimFPS as String) + ";";
			Props += (a.AnimKeysOnly as String) + ";";
		);
		FileProperties.AddProperty #custom "Gen2_Exporter_Props_v2" Props;
	);
	
	function PropertiesLoad = (
		PropID = FileProperties.findProperty #custom "Gen2_Exporter_Props_v2";
		if (PropID > 0) then (
			Props = FileProperties.getPropertyValue #custom PropID;
			Props = FilterString Props ";";
			ExportRollout.rdo3.state = Props[1] as Integer;
			ExportRollout.chk1.checked = Props[2] as BooleanClass;
			ExportRollout.chk2.checked = Props[3] as BooleanClass;
			ExportRollout.chk3.checked = Props[4] as BooleanClass;
			ExportRollout.chk4.checked = Props[5] as BooleanClass;
			ExportRollout.chk5.checked = Props[6] as BooleanClass;
			ExportRollout.chk6.checked = Props[7] as BooleanClass;
			ExportRollout.chk7.checked = Props[8] as BooleanClass;
			ExportRollout.chk12.checked = Props[9] as BooleanClass;
			ExportRollout.chk25.checked = Props[10] as BooleanClass;
			ExportRollout.chk26.checked = Props[11] as BooleanClass;
			ExportRollout.chk87.checked = Props[12] as BooleanClass;
			ExportRollout.spn1.value = Props[13] as Integer;
			AnimCount = Props[14] as Integer;
			AnimList = #();
			for i = 1 to AnimCount do (
				AnimName = Props[15 + (i - 1) * 5 + 0];
				AnimStart = Props[15 + (i - 1) * 5 + 1] as Integer;
				AnimEnd = Props[15 + (i - 1) * 5 + 2] as Integer;
				AnimFPS = Props[15 + (i - 1) * 5 + 3] as Integer;
				AnimKeysOnly = Props[15 + (i - 1) * 5 + 4] as BooleanClass;
				append AnimList (TAnim AnimName:AnimName AnimStart:AnimStart AnimEnd:AnimEnd AnimFPS:AnimFPS AnimKeysOnly:AnimKeysOnly);
			);
			if (ExportRollout.chk6.checked) then (
				ExportRollout.spn2.enabled = true;
				ExportRollout.spn3.enabled = true;
				ExportRollout.edt1.enabled = true;
				ExportRollout.btn5.enabled = true;
				ExportRollout.btn6.enabled = true;
				ExportRollout.lbx1.enabled = true;
				ExportRollout.chk8.enabled = true;
				ExportRollout.spn4.enabled = true;
			)
			else (
				ExportRollout.spn2.enabled = false;
				ExportRollout.spn3.enabled = false;
				ExportRollout.edt1.enabled = false;
				ExportRollout.btn5.enabled = false;
				ExportRollout.btn6.enabled = false;
				ExportRollout.lbx1.enabled = false;
				ExportRollout.chk8.enabled = false;
				ExportRollout.spn4.enabled = false;
			);
			AnimListUpdate();
		);
	);
	
	function PropertiesClear = (
		FileProperties.DeleteProperty #custom "Gen2_Exporter_Props_v2";
	);
	--MAX File Properties END

	function TransformLH m = (
		s = m.Scale; s = point3 s.x s.z s.y;
		r = m.Rotation; r = quat -r.x -r.z -r.y r.w;
		p = m.Position; p = point3 p.x p.z p.y;
		ms = ScaleMatrix s;
		mr = matrix3 1; mr = rotate mr r;
		mp = TransMatrix p;
		return (ms * mr * mp);
	);

	function CreateRollout = (
		rollout ExportRollout "Gen2 Mesh Exporter" width:440 height:336
		(
			GroupBox grp1 "Options" pos:[8,8] width:424 height:288
			button btn1 "Export" pos:[8,304] width:136 height:24
			button btn2 "Cancel" pos:[152,304] width:136 height:24
			GroupBox grp2 "Export Data" pos:[16,24] width:168 height:128
			GroupBox grp3 "Export Scope" pos:[16,160] width:168 height:128
			radiobuttons rdo3 "" pos:[24,176] width:111 height:16 labels:#("All", "Custom") default:1 columns:2
			checkbox chk1 "Unselected" pos:[24,192] width:104 height:16 enabled:false
			checkbox chk2 "Hidden" pos:[24,208] width:104 height:16 enabled:false
			checkbox chk3 "Frozen" pos:[24,224] width:104 height:16 enabled:false
			checkbox chk4 "Non-renderable" pos:[24,240] width:104 height:16 enabled:false checked:true
			checkbox chk5 "Geometry" pos:[24,40] width:72 height:14 enabled:true checked:true
			checkbox chk6 "Animation" pos:[24,56] width:152 height:16 checked:true
			checkbox chk7 "Lights" pos:[24,104] width:152 height:16 enabled:true
			GroupBox grp4 "Animation Options" pos:[192,24] width:232 height:264
			spinner spn1 "Base Frame " pos:[56,128] width:120 height:16 range:[0,100,0] type:#integer scale:1
			spinner spn2 "Anim Start" pos:[232,240] width:80 height:16 enabled:true range:[0,100,0] type:#integer scale:1
			spinner spn3 "Anim End " pos:[232,264] width:80 height:16 enabled:true range:[0,100,0] type:#integer scale:1
			edittext edt1 "Animation Name" pos:[200,216] width:216 height:16 enabled:true
			button btn4 "UnInstall" pos:[296,304] width:136 height:24
			listbox lbx1 "Animations" pos:[200,40] width:216 height:9
			button btn5 "Add" pos:[200,184] width:104 height:24
			button btn6 "Remove" pos:[312,184] width:104 height:24
			checkbox chk8 "Key frames only" pos:[320,240] width:96 height:16
			spinner spn4 "FPS: " pos:[352,264] width:64 height:16 range:[1,100000,30] type:#integer scale:1
			checkbox chk25 "Materials" pos:[24,72] width:152 height:16 enabled:true checked:true
			checkbox chk26 "Skinning" pos:[24,88] width:152 height:16 enabled:true checked:true
			checkbox chk87 "Show exported nodes" pos:[24,264] width:152 height:16
			checkbox chk12 "Ragdoll" pos:[104,40] width:74 height:20
			on ExportRollout open do
			(
				AnimRStart = AnimationRange.Start.Frame as integer;
				AnimREnd = AnimationRange.End.Frame as integer;
				if (AnimRStart < 0) then
				BaseFrame = AnimRStart;
				else
				BaseFrame = 0;
				spn1.range = [BaseFrame, AnimREnd, BaseFrame];
				spn2.range = [AnimRStart, AnimREnd, AnimRStart];
				spn3.range = [AnimRStart, AnimREnd, AnimREnd];
				spn1.value = BaseFrame;
				spn2.value = AnimRStart;
				spn3.value = AnimREnd;
				AnimListAdd undefined undefined undefined;
				PropertiesLoad();
			)
			on btn1 pressed do
			(
				PropertiesSave();
				Export();
				messageBox "Export complete.";
				closeRolloutFloater ExportFloater;
			)
			on btn2 pressed do
			(
				closeRolloutFloater ExportFloater;
			)
			on rdo3 changed stat do
			(
				case rdo3.state of (
					1: (
						chk1.enabled = false;
						chk2.enabled = false;
						chk3.enabled = false;
						chk4.enabled = false;
					);
					2: (
						chk1.enabled = true;
						chk2.enabled = true;
						chk3.enabled = true;
						chk4.enabled = true;
					);
				);
			)
			on chk6 changed state do
			(
				if (chk6.checked) then (
					spn2.enabled = true;
					spn3.enabled = true;
					edt1.enabled = true;
					btn5.enabled = true;
					btn6.enabled = true;
					lbx1.enabled = true;
					chk8.enabled = true;
					spn4.enabled = true;
				)
				else (
					spn2.enabled = false;
					spn3.enabled = false;
					edt1.enabled = false;
					btn5.enabled = false;
					btn6.enabled = false;
					lbx1.enabled = false;
					chk8.enabled = false;
					spn4.enabled = false;
				);
			)
			on spn2 changed val do
			(
				AnimInd = ExportRollout.lbx1.selection;
				AnimList[AnimInd].AnimStart = val;
			)
			on spn3 changed val do
			(
				AnimInd = ExportRollout.lbx1.selection;
				AnimList[AnimInd].AnimEnd = val;
			)
			on edt1 entered text do
			(
				AnimInd = ExportRollout.lbx1.selection;
				AnimList[AnimInd].AnimName = text;
				AnimListUpdate();
			)
			on btn4 pressed do
			(
				UninstallExporter();
			)
			on lbx1 selected sel do
			(
				AnimListSelect();
			)
			on btn5 pressed do
			(
				AnimListAdd undefined undefined undefined;
			)
			on btn6 pressed do
			(
				AnimListRemove();
			)
			on chk8 changed state do
			(
				AnimInd = ExportRollout.lbx1.selection;
				AnimList[AnimInd].AnimKeysOnly = state;
			)
			on spn4 changed val do
			(
				AnimInd = ExportRollout.lbx1.selection;
				AnimList[AnimInd].AnimFPS = val;
			)
		)

		scrSize = sysInfo.desktopSize;
		scrWidth = scrSize.x;
		scrHeight = scrSize.y;

		ExportFloater = (
			NewRolloutFloater "G2Mesh Export" \
			(ExportRollout.width + 12) (ExportRollout.height + 32) \
			((scrWidth - ExportRollout.width) / 2) ((scrHeight - ExportRollout.height) / 2)
		);

		AddRollout ExportRollout ExportFloater;
	);
	
	function UninstallExporter = (
		if ((maxVersion())[1] >= 12000) then (
			MainMenu = menuMan.getMainMenuBar();
			if (MainMenu != undefined) then (
				ItemCount = MainMenu.NumItems();
				Gen2ID = 0;
				for i = 1 to ItemCount do (
					Item = MainMenu.GetItem i;
					ItemTitle = Item.GetTitle();
					if (ItemTitle == "Gen2") then (
						Gen2ID = i;
						Break;
					);
				);
				if (Gen2ID > 0) then (
					Item = MainMenu.GetItem Gen2ID;
					G2Menu = Item.getSubMenu();
					if (G2Menu != undefined) then (
						n = G2Menu.numItems();
						while n > 0 do (
							G2Menu.removeItemByPosition 1;
							n = G2Menu.numItems();
						);
						menuMan.unRegisterMenu G2Menu;
					);
					MainMenu.removeItem Item;
					menuMan.updateMenuBar();
					PropertiesClear();
					MessageBox "Gen2 Exporter uninstalled successfully.";
				);
			);
		)
		else (
			MainMenu = menuMan.GetMainMenuBar();
			FileMenuItem = mainMenu.GetItem 1;
			FileMenu = FileMenuItem.GetSubMenu();
			MenuCount = FileMenu.NumItems();
			Num = 0;
			for i = 1 to MenuCount do (
				MItem = FileMenu.GetItem i;
				MTitle = MItem.getTitle();
				if (MTitle == "Gen2 Export...") then (
					Num = i;
					Break;
				);
			);
			if (Num > 0) then (
				ExportMenuItem = FileMenu.GetItem Num;
				FileMenu.RemoveItem ExportMenuItem;
			);
			Num = 0;
			for i = 1 to MenuCount do (
				MItem = FileMenu.GetItem i;
				MTitle = MItem.getTitle();
				if (MTitle == "Gen2 Import...") then (
					Num = i;
					Break;
				);
			);
			if (Num > 0) then (
				ImportMenuItem = FileMenu.GetItem Num;
				FileMenu.RemoveItem ImportMenuItem;
			);
			menuMan.updateMenuBar();
			PropertiesClear();
			MessageBox "Gen2 Exporter uninstalled successfully.";
		);
		closeRolloutFloater ExportFloater;
	);
	
	CreateRollout();
);

MacroScript Gen2ImportMacro
	category: "Gen2 Import"
	tooltip: "Gen2 Importer"
	buttontext: "Gen2 Import..."
(
	global FileEOF;
	global FileInit;
	global Nodes = #();
	
	global ReadHeader;
	global ReadBlock;
	global FindBlock;
	global ReadNode;
	global ReadGeom;
	global ReadVector2f;
	global ReadVector3f;
	global ReadVector3i;
	global ReadMatrix4x3;
	global TransformLH;
	
	struct TNode (
		OwnerID = 0,
		NodeName = "",
		NodeTransform = matrix3 1,
		Obj
	);
	
	function Import = (
		FileName = GetOpenFileName types: "G2Mesh (*.g2m)|*.g2m|";
		if (FileName == undefined) then return OK;
		
		f = fopen FileName "rb";
		
		Header = ReadHeader f;
		if (Header == "G2M ") then (
			FileInit = ftell f;
			fseek f 0 #seek_end;
			FileEOF = ftell f;
			fseek f FileInit #seek_set;
			if (FindBlock f "NMAP") then (
				Nodes = #();
				NodeCount = ReadLong f;
				NodeTransforms = #();
				for i = 0 to NodeCount - 1 do (
					Pos = ReadLong f;
					CurPos = ftell f;
					fseek f Pos #seek_set;
					n = ReadNode f;
					append Nodes n;
					append NodeTransforms n.NodeTransform;
					fseek f CurPos #seek_set;
				);
				for i = 1 to NodeCount do (
					n = i;
					Nodes[i].NodeTransform = NodeTransforms[i];
					while (Nodes[n].OwnerID > 0) do (
						n = Nodes[n].OwnerID;
						Nodes[i].NodeTransform = Nodes[i].NodeTransform * NodeTransforms[n];
					);
					Nodes[i].NodeTransform = TransformLH Nodes[i].NodeTransform;
				);
				if (FindBlock f "GMAP") then (
					Geoms = #();
					GeomCount = ReadLong f;
					for i = 0 to GeomCount - 1 do (
						Pos = ReadLong f;
						CurPos = ftell f;
						fseek f Pos #seek_set;
						append Geoms (ReadGeom f);
						fseek f CurPos #seek_set;
					);
				);
			);
		);
		
		fclose f;
	);
	
	--File Reading BEGIN
	function ReadChr f = (
		return execute ("\"\\x" + (bit.intAsHex (ReadByte f)) + "\"");
	);
	function ReadHeader f = (
		s = "    ";
		s[1] = ReadChr f;
		s[2] = ReadChr f;
		s[3] = ReadChr f;
		s[4] = ReadChr f;
		return s;
	);
	
	function FindBlock f BlockName = (
		fseek f FileInit #seek_set;
		CurPos = ftell f;
		TmpName = ReadHeader f;
		TmpSize = ReadLong f;
		while (
			(TmpName != BlockName)\
			or
			(CurPos >= FileEOF)
		) do (
			fseek f TmpSize #seek_cur;
			CurPos = ftell f;
			if (CurPos < FileEOF) then (
				TmpName = ReadHeader f;
				TmpSize = ReadLong f;
			);
		);
		if (TmpName == BlockName) then
		return True; else return False;		
	);
	
	function ReadNode f = (
		Result = (TNode OwnerID: ((ReadLong f) + 1));
		Result.NodeName = ReadString f;
		Result.NodeTransform = ReadMatrix4x3 f;
		return Result;
	);
	
	function ReadGeom f = (
		/*
		NodeID: Int4
		VCount: Int4
		CCount: Int4
		FCount: Int4
		MCount: Int4
		TCount: Int4
		Vertices[VCount]: Vec3f
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
		*/
		NodeID = (ReadLong f) + 1;
		VCount = ReadLong f;
		CCount = ReadLong f;
		FCount = ReadLong f;
		MCount = ReadLong f;
		TCount = ReadLong f;
		Result = Mesh numverts: VCount numfaces: FCount;
		for i = 1 to VCount do (
			v = ReadVector3f f;
			setVert Result i [v.x, v.z, v.y];
		);
		p = CCount * 3;
		fseek f p #seek_cur;
		if (TCount < 1) then
		meshop.setNumMaps Result 2;
		else
		meshop.setNumMaps Result (TCount + 1);
		for i = 1 to TCount do (
			meshop.setMapSupport Result i True;
			TVCount = ReadLong f;
			meshop.setNumMapVerts Result i TVCount;
			for j = 1 to TVCount do (
				v2 = ReadVector2f f;
				v = [v2.x, 1 - v2.y, 0];
				meshop.setMapVert Result i j v;
			);
		);
		p = MCount * 4;
		fseek f p #seek_cur;
		for i = 1 to FCount do (
			v = (ReadVector3i f);
			setFace Result i v;
			p = 12;
			fseek f p #seek_cur;
			for j = 1 to TCount do (
				v = ReadVector3i f;
				meshop.setMapFace Result j i v;
			);
			p = 4 + 4;
			fseek f p #seek_cur;
		);
		Result.Name = Nodes[NodeID].NodeName;
		Nodes[NodeID].Obj = Result;
		n = NodeID;
		Result.Transform = Nodes[NodeID].NodeTransform;
		/*while (Nodes[n].OwnerID > 0) do (
			n = Nodes[n].OwnerID;
			Result.Transform = Result.Transform * Nodes[n].NodeTransform;
		);
		Result.Transform = TransformLH Result.Transform;*/
		update Result;
		return Result;
	);
	
	function ReadVector2f f = (
		v = [0, 0];
		v.x = ReadFloat f;
		v.y = ReadFloat f;
		return v;
	);
	
	function ReadVector3f f = (
		v = [0, 0, 0];
		v.x = ReadFloat f;
		v.y = ReadFloat f;
		v.z = ReadFloat f;
		return v;
	);
	
	function ReadVector3i f = (
		v = Point3 0 0 0;
		v.x = (ReadLong f) + 1;
		v.y = (ReadLong f) + 1;
		v.z = (ReadLong f) + 1;
		return v;
	);
	
	function ReadMatrix4x3 f = (
		m = matrix3 (ReadVector3f f) (ReadVector3f f) (ReadVector3f f) (ReadVector3f f);
		/*for i = 1 to 4 do (
			for j = 1 to 3 do (
				v = ReadFloat f;
				MessageBox (v as string);
				m[i][j] = v;
			);
		);*/
		return m;
	);
	--File Reading END
	
	function TransformLH m = (
		s = m.Scale; s = point3 s.x s.z s.y;
		r = m.Rotation; r = quat -r.x -r.z -r.y r.w;
		p = m.Position; p = point3 p.x p.z p.y;
		ms = ScaleMatrix s;
		mr = matrix3 1; mr = rotate mr r;
		mp = TransMatrix p;
		return (ms * mr * mp);
	);
	
	Import();
);

function InstallExporter = (
	if ((maxVersion())[1] >= 12000) then (
		MainMenu = menuMan.getMainMenuBar();
		if (MainMenu != undefined) then (
			ItemCount = MainMenu.NumItems();
			InsertID = -1;
			Gen2ID = 0;
			for i = 1 to ItemCount do (
				ItemTitle = (MainMenu.GetItem i).GetTitle();
				if (
					(ItemTitle == "&Help")\
					or
					(ItemTitle == "Help")\
				) then (
					InsertID = i;
				);
				if (ItemTitle == "Gen2") then (
					Gen2ID = i;
				);
			);
			if (Gen2ID == 0) then (
				G2Menu = menuMan.createMenu "Gen2";
				G2MenuItem = menuMan.createSubMenuItem "Gen2" G2Menu;
				G2ActionItemExport = menuMan.createActionItem "Gen2ExportMacro" "Gen2 Export";
				G2ActionItemImport = menuMan.createActionItem "Gen2ImportMacro" "Gen2 Import";
				G2Menu.AddItem G2ActionItemExport -1;
				G2Menu.AddItem G2ActionItemImport -1;
				MainMenu.AddItem G2MenuItem InsertID;
				menuMan.updateMenuBar();
				MessageBox "Gen2 Exporter installed successfully.";
			);
		)
		else (
			MessageBox "Gen2 Exporter failed to install";
		);
	)
	else (
		MainMenu = menuMan.GetMainMenuBar();
		FileMenuItem = mainMenu.GetItem 1;
		FileMenu = FileMenuItem.GetSubMenu();
		MenuCount = FileMenu.NumItems();
		Num = 0;
		for i = 1 to MenuCount do (
			MItem = FileMenu.GetItem i;
			MTitle = MItem.getTitle();
			if (MTitle == "Gen2 Export...") then (
				Num = i;
				Break;
			);
		);
		if (Num == 0) then (
			NewMenuItemExport = menuMan.createActionItem "Gen2ExportMacro" "Gen2 Export";
			NewMenuItemImport = menuMan.createActionItem "Gen2ImportMacro" "Gen2 Import";
			Num = 8;
			for i = 1 to MenuCount do (
				if ((FileMenu.GetItem i).getTitle() == "Export Selected...") then (
					Num = i + 1;
					Break;
				);
			);
			FileMenu.AddItem NewMenuItemExport Num;
			FileMenu.AddItem NewMenuItemImport (Num + 1);
			menuMan.updateMenuBar();
			MessageBox "Gen2 Exporter installed successfully.";
		);
	);
);

InstallExporter();