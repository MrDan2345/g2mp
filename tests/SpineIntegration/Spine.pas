unit Spine;

interface

uses
  Classes,
  SysUtils;

type
  TSpineClass = class;
  TSpineBoneData = class;
  TSpineBone = class;
  TSpineSkin = class;
  TSpineSkeletonData = class;

  TSpineClass = class
  private
    var _Ref: Integer;
  public
    procedure AfterConstruction; override;
    procedure RefInc;
    procedure RefDec;
    procedure Free; reintroduce;
  end;

  generic TSpineList<T> = class (TSpineClass)
  public
    type TItemPtr = ^T;
    type TCmpFunc = function (const Item0, Item1: T): Integer;
    type TCmpFuncObj = function (const Item0, Item1: T): Integer of object;
  private
    var _ItemCount: Integer;
    procedure SetItem(const Index: Integer; const Value: T); inline;
    function GetItem(const Index: Integer): T; inline;
    procedure SetCapacity(const Value: Integer); inline;
    function GetCapacity: Integer; inline;
    function GetFirst: T; inline;
    function GetLast: T; inline;
    function GetData: TItemPtr; inline;
  public
    var _Items: array of T;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read _ItemCount;
    property Items[const Index: Integer]: T read GetItem write SetItem; default;
    property First: T read GetFirst;
    property Last: T read GetLast;
    property Data: TItemPtr read GetData;
    constructor Create;
    destructor Destroy; override;
    function Find(const Item: T): Integer;
    function Add(const Item: T): Integer;
    function Pop: T;
    function Extract(const Index: Integer): T;
    function Insert(const Index: Integer; const Item: T): Integer;
    procedure Delete(const Index: Integer; const ItemCount: Integer = 1);
    procedure Remove(const Item: T);
    procedure Clear;
    function Search(const CmpFunc: TCmpFunc; const Item: T): Integer; overload;
    function Search(const CmpFunc: TCmpFuncObj; const Item: T): Integer; overload;
    procedure Sort(const CmpFunc: TCmpFunc; RangeStart, RangeEnd: Integer); overload;
    procedure Sort(const CmpFunc: TCmpFuncObj; RangeStart, RangeEnd: Integer); overload;
    procedure Sort(const CmpFunc: TCmpFunc); overload;
    procedure Sort(const CmpFunc: TCmpFuncObj); overload;
  end;

  TSpineBoneDataList = specialize TSpineList<TSpineBoneData>;
  TSpineBoneList = specialize TSpineList<TSpineBone>;
  TSpineAtlasList = specialize TSpineList<TSpineAtlas>;

  TSpineRegionVertices = array[0..7] of Single;
  TSpineMat = array[0..1, 0..1] of Single;

  TSpineBoneData = class (TSpineClass)
  private
    var _Length: Single;
    var _Parent: TSpineBoneData;
    var _Name: String;
    var _BoneLength: Single;
    var _x: Single;
    var _y: Single;
    var _Rotation: Single;
    var _ScaleX: Single;
    var _ScaleY: Single;
    var _FlipX: Boolean;
    var _FlipY: Boolean;
    var _InheritScale: Boolean;
    var _InheritRotation: Boolean;
  public
    property Parent: TSpineBoneData read _Parent;
    property Name: String read _Name;
    property BoneLength: Single read _Length write _Length;
    property x: Single read _x write _x;
    property y: Single read _y write _y;
    property Rotation: Single read _Rotation write _Rotation;
    property ScaleX: Single read _ScaleX write _ScaleX;
    property ScaleY: Single read _ScaleY write _ScaleY;
    property FlipX: Boolean read _FlipX write _FlipX;
    property FlipY: Boolean read _FlipY write _FlipY;
    property InheritScale: Boolean read _InheritScale write _InheritScale;
    property InheritRotation: Boolean read _InheritRotation write _InheritRotation;
    constructor Create(const AName: String; const AParent: TSpineBoneData);
  end;

  TSpineBone = class (TSpineClass)
  public
    class var YDown: Boolean;
  private
    _FlipX: Boolean;
    _FlipY: Boolean;
    var _Data: TSpineBoneData;
    var _Skeleton: TSpineSkeleton;
    var _Parent: TSpineBone;
    var _Children: TSpineBoneList;
    var _x: Single;
    var _y: Single;
    var _Rotation: Single;
    var _RotationIK: Single;
    var _ScaleX: Single;
    var _ScaleY: Single;
    var _WorldX: Single;
    var _WorldY: Single;
    var _WorldRotation: Single;
    var _WorldScaleX: Single;
    var _WorldScaleY: Single;
    var _WorldFlipX: Single;
    var _WorldFlipY: Single;
    var _m: TSpineMat;
  public
    property Data: TSpineBoneData read _Data;
    property Skeleton: TSpineSkeleton read _Skeleton;
    property Parent: TSpineBone read _Parent;
    property Children: TSpineBoneList read _Children;
    property x: Single read _x write _x;
    property y: Single read _y write _y;
    property Rotation: Single read _Rotation write _Rotation;
    property RotationIK: Single read _RotationIK write _RotationIK;
    property ScaleX: Single read _ScaleX write _ScaleX;
    property ScaleY: Single read _ScaleY write _ScaleY;
    property FlipX: Boolean read _FlipX write _FlipX;
    property FlipY: Boolean read _FlipY write _FlipY;
    property m: TSpineMat read _m;
    property WorldX: Single read _WorldX;
    property WorldY: Single read _WorldY;
    property WorldRotation: Single read _WorldRotation;
    property WorldScaleX: Single read _WorldScaleX;
    property WorldScaleY: Single read _WorldScaleY;
    property WorldFlipX: Boolean read _WorldFlipX write _WorldFlipX;
    property WorldFlipY: Boolean read _WorldFlipY write _WorldFlipY;
    constructor Create(const AData: TSpineBoneData; const ASkeleton: TSpineSkeleton; const AParent: TSpineBone);
    procedure UpdateWorldTransform;
    procedure SetToSetupPose;
    procedure WorldToLocal(const InWorldX, InWorldY: Single; var OutLocalX, OutLocalY: Single);
    procedure LocalToWorld(const InLocalX, InLocalY: Single; var OutWorldX, OutWorldY: Single);
  end;

  TSpineAttachmentType = (
    sp_at_region,
    sp_at_bounding_box,
    sp_at_mesh,
    sp_at_skinned_mesh
  );

  TSpineAttachment = class (TSpineClass)
  private
    _Name: String;
  public
    property Name: String read _Name write _Name;
    constructor Create(const AName: String); virtual;
  end;

  TSpineRegionAttachment = class (TSpineAttachment)
  private
    const SP_VERTEX_X1 = 0;
    const SP_VERTEX_Y1 = 1;
    const SP_VERTEX_X2 = 2;
    const SP_VERTEX_Y2 = 3;
    const SP_VERTEX_X3 = 4;
    const SP_VERTEX_Y3 = 5;
    const SP_VERTEX_X4 = 6;
    const SP_VERTEX_Y4 = 7;
    var _x: Single;
    var _y: Single;
    var _Rotation: Single;
    var _ScaleX: Single;
    var _ScaleY: Single;
    var _Width: Single;
    var _Height: Single;
    var _RegionOffsetX: Single;
    var _RegionOffsetY: Single;
    var _RegionWidth: Single;
    var _RegionHeight: Single;
    var _RegionOriginalWidth: Single;
    var _RegionOriginalHeight: Single;
    var _r: Single;
    var _g: Single;
    var _b: Single;
    var _a: Single;
    var _Offset: TSpineRegionVertices;
    var _UV: TSpineRegionVertices;
    var _Path: String;
    function GetOffset(const Index: Integer): Single; inline;
    procedure SetOffset(const Index: Integer; const Value: Single); inline;
    function GetUV(const Index: Integer): Single; inline;
    procedure SetUV(const Index: Integer; const Value: Single); inline;
  public
    property x: Single read _x write _x;
    property y: Single read _y write _y;
    property Rotation: Single read _Rotation write _Rotation;
    property ScaleX: Single read _ScaleX write _ScaleX;
    property ScaleY: Single read _ScaleY write _ScaleY;
    property Width: Single read _Width write _Width;
    property Height: Single read _Height write _Height;
    property r: Single read _r write _r;
    property g: Single read _g write _g;
    property b: Single read _b write _b;
    property a: Single read _a write _a;
    property RegionOffsetX: Single read _RegionOffsetX write _RegionOffsetX;
    property RegionOffsetY: Single read _RegionOffsetY write _RegionOffsetY;
    property RegionWidth: Single read _RegionWidth write _RegionWidth;
    property RegionHeight: Single read _RegionHeight write _RegionHeight;
    property RegionOriginalWidth: Single read _RegionOriginalWidth write _RegionOriginalWidth;
    property RegionOriginalHeight: Single read _RegionOriginalHeight write _RegionOriginalHeight;
    property Offset[const Index: Integer]: Single read GetOffset write SetOffset;
    property UV[const Index: Integer]: Single read GetUV write SetUV;
    property Path: String read _Path write _Path;
    constructor Create(const AName: String); override;
    procedure SetUVs(const u, v, u2, v2: Single; const Rotate: Boolean); inline;
    procedure UpdateOffset;
    procedure ComputeWorldVertices(const Bone: TSpineBone; var OutWorldVertices: TSpineRegionVertices);
  end;

  TSpineAttachmentLoader = class (TSpineClass)
    function NewRegionAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineRegionAttachment; virtual; abstract;
    function NewMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineMeshAttachment; virtual; abstract;
    function NewSkinnedMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineSkinnedMeshAttachment; virtual; abstract;
    function NewBoundingBoxAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineBoundingBoxAttachment; virtual; abstract;
  end;

  TSpineAtlasAttachmentLoader = class (TSpineAttachmentLoader)
  private
    var _AtlasList: TSpineAtlasList;
  public
    constructor Create(const AAtlasList: TSpineAtlasList);
    function NewRegionAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineRegionAttachment; {
			AtlasRegion region = FindRegion(path);
			if (region == null) throw new Exception("Region not found in atlas: " + path + " (region attachment: " + name + ")");
			RegionAttachment attachment = new RegionAttachment(name);
			attachment.RendererObject = region;
			attachment.SetUVs(region.u, region.v, region.u2, region.v2, region.rotate);
			attachment.regionOffsetX = region.offsetX;
			attachment.regionOffsetY = region.offsetY;
			attachment.regionWidth = region.width;
			attachment.regionHeight = region.height;
			attachment.regionOriginalWidth = region.originalWidth;
			attachment.regionOriginalHeight = region.originalHeight;
			return attachment;
		}

    function NewMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineMeshAttachment; {
			AtlasRegion region = FindRegion(path);
			if (region == null) throw new Exception("Region not found in atlas: " + path + " (mesh attachment: " + name + ")");
			MeshAttachment attachment = new MeshAttachment(name);
			attachment.RendererObject = region;
			attachment.RegionU = region.u;
			attachment.RegionV = region.v;
			attachment.RegionU2 = region.u2;
			attachment.RegionV2 = region.v2;
			attachment.RegionRotate = region.rotate;
			attachment.regionOffsetX = region.offsetX;
			attachment.regionOffsetY = region.offsetY;
			attachment.regionWidth = region.width;
			attachment.regionHeight = region.height;
			attachment.regionOriginalWidth = region.originalWidth;
			attachment.regionOriginalHeight = region.originalHeight;
			return attachment;
		}

    function NewSkinnedMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineSkinnedMeshAttachment; {
			AtlasRegion region = FindRegion(path);
			if (region == null) throw new Exception("Region not found in atlas: " + path + " (skinned mesh attachment: " + name + ")");
			SkinnedMeshAttachment attachment = new SkinnedMeshAttachment(name);
			attachment.RendererObject = region;
			attachment.RegionU = region.u;
			attachment.RegionV = region.v;
			attachment.RegionU2 = region.u2;
			attachment.RegionV2 = region.v2;
			attachment.RegionRotate = region.rotate;
			attachment.regionOffsetX = region.offsetX;
			attachment.regionOffsetY = region.offsetY;
			attachment.regionWidth = region.width;
			attachment.regionHeight = region.height;
			attachment.regionOriginalWidth = region.originalWidth;
			attachment.regionOriginalHeight = region.originalHeight;
			return attachment;
		}

    function NewBoundingBoxAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineBoundingBoxAttachment; {
			return new BoundingBoxAttachment(name);
		}

    function FindRegion(const Name: String): TSpineAtlasRegion; {
			AtlasRegion region;

			for (int i = 0; i < atlasArray.Length; i++) {
				region = atlasArray[i].FindRegion(name);
				if (region != null)
					return region;
			}

			return null;
		}
  end;

  TSpineSkin = class (TSpineClass)
  private
    var _Name: String;
  public
    property Name: String read _Name;
  end;

  TSpineSkeletonData = class (TSpineClass)
  private
    var _Name: String;
    var _Bones: TSpineBoneDataList;
    var _Slots: TSpineSlotDataList;
  public
    property Name: String read _Name write _Name;
  end;

  TSpineSkeleton = class (TSpineClass)
  private
  public
  end;

const
  SP_DEG_TO_RAD = Pi / 180;

implementation

//TSpineBoneData BEGIN
constructor TSpineBoneData.Create(const AName: String; const AParent: TSpineBoneData);
begin
  _Name := AName;
  _Parent := AParent;
  _ScaleX := 1;
  _ScaleY := 1;
end;
//TSpineBoneData END

//TSpineBone BEGIN
constructor TSpineBone.Create(const AData: TSpineBoneData; const ASkeleton: TSpineSkeleton; const AParent: TSpineBone);
begin
  _Data := AData;
  _Skeleton := ASkeleton;
  _Parent := AParent;
  SetToSetupPose;
end;

procedure TSpineBone.UpdateWorldTransform;
  var Radians, c, s: Single;
begin
  if Assigned(_Parent) then
  begin
    _WorldX := _x * _Parent.m[0, 0] + _y * _Parent.m[0, 1] + _Parent.WorldX;
    _WorldY := _x * _Parent.m[1, 0] + _y * _Parent.m[1, 1] + _Parent.WorldY;
    if _Data.InheritScale then
    begin
      _WorldScaleX := _Parent.WorldScaleX * _ScaleX;
      _WorldScaleY := _Parent.WorldScaleY * _ScaleY;
    end
    else
    begin
      _WorldScaleX := _ScaleX;
      _WorldScaleY := _ScaleY;
    end;
    if _Data.InheritRotation then
    _WorldRotation := _Parent.WorldRotation + _RotationIK
    else
    _WorldRotation := _RotationIK;
    _WorldFlipX := _Parent.WorldFlipX <> FlipX;
    _WorldFlipY := _Parent.WorldFlipY <> FlipY;
  end
  else
  begin
    if _Skeleton.FlipX then _WorldX := -x else _WorldX := x;
    if _Skeleton.FlipY <> YDown then _WorldY := -y else _WorldY := y;
    _WorldScaleX := _ScaleX;
    _WorldScaleY := _ScaleY;
    _WorldRotation := _RotationIK;
    _WorldFlipX := _Skeleton.FlipX <> _FlipX;
    _WorldFlipY := _Skeleton.FlipY <> _FlipY;
  end;
  Radians := _WorldRotation * SP_DEG_TO_RAD;
  c := Cos(Radians);
  s := Sin(Radians);
  if _WorldFlipX then
  begin
    m[0, 0] := -c * _WorldScaleX;
    m[0, 1] := s * _WorldScaleY;
  end
  else
  begin
    m[0, 0] := c * _WorldScaleX;
    m[0, 1] := -s * _WorldScaleY;
  end;
  if _WorldFlipY <> YDown then
  begin
    m[1, 0] := -s * _WorldScaleX;
    m[1, 1] := -c * _WorldScaleY;
  end
  else
  begin
    m[1, 0] := s * _WorldScaleX;
    m[1, 1] := c * _WorldScaleY;
  end;
end;

procedure TSpineBone.SetToSetupPose;
begin
  _x := _Data.x;
  _y := _Data.y;
  _Rotation := _Data.Rotation;
  _RotationIK := _Rotation;
  _ScaleX := _Data.ScaleX;
  _ScaleY := _Data.ScaleY;
  _FlipX := _Data.FlipX;
  _FlipY := _Data.FlipY;
end;

procedure TSpineBone.WorldToLocal(const InWorldX, InWorldY: Single; var OutLocalX, OutLocalY: Single);
  var dx, dy, m00, m11, RcpDet: Single;
begin
  dx := InWorldX - _WorldX;
  dy := InWorldY - _WorldY;
  m00 := _m[0, 0];
  m11 := _m[1, 1];
  if _WorldFlipX <> (WorldFlipY <> YDown)) then
  begin
    m00 := -m00;
    m11 := -m11;
  end;
  RcpDet := 1 / (m00 * m11 - _m[0, 1] * _m[1, 0]);
  OutLocalX := (dx * m00 * RcpDet - dy * m[0, 1] * RcpDet);
  OutLocalY := (dy * m11 * RcpDet - dx * m[1, 0] * RcpDet);
end;

procedure TSpineBone.LocalToWorld(const InLocalX, InLocalY: Single; var OutWorldX, OutWorldY: Single);
begin
  OutWorldX := InLocalX * m[0, 0] + InLocalY * m[0, 1] + _WorldX;
  OutWorldY := InLocalX * m[1, 0] + InLocalY * m[1, 1] + _WorldY;
end;
//TSpineBone END

//TSpineAttachment BEGIN
constructor TSpineAttachment.Create(const AName: String);
begin
  inherited Create;
  _Name := AName;
end;
//TSpineAttachment END

//TSpineRegionAttachment BEGIN
function TSpineRegionAttachment.GetOffset(const Index: Integer): Single;
begin
  Result := _Offset[Index];
end;

procedure TSpineRegionAttachment.SetOffset(const Index: Integer; const Value: Single);
begin
  _Offset[Index] := Value;
end;

function TSpineRegionAttachment.GetUV(const Index: Integer): Single;
begin
  Result := _UV[Index];
end;

procedure TSpineRegionAttachment.SetUV(const Index: Integer; const Value: Single);
begin
  _UV[Index] := Value;
end;

constructor TSpineRegionAttachment.Create(const AName: String);
begin
  inherited Create(AName);
end;

procedure TSpineRegionAttachment.SetUVs(const u, v, u2, v2: Single; const Rotate: Boolean);
begin
  if Rotate then
  begin
    _UV[SP_VERTEX_X2] := u;
    _UV[SP_VERTEX_Y2] := v2;
    _UV[SP_VERTEX_X3] := u;
    _UV[SP_VERTEX_Y3] := v;
    _UV[SP_VERTEX_X4] := u2;
    _UV[SP_VERTEX_Y4] := v;
    _UV[SP_VERTEX_X1] := u2;
    _UV[SP_VERTEX_Y1] := v2;
  end
  else
  begin
    _UV[SP_VERTEX_X1] := u;
    _UV[SP_VERTEX_Y1] := v2;
    _UV[SP_VERTEX_X2] := u;
    _UV[SP_VERTEX_Y2] := v;
    _UV[SP_VERTEX_X3] := u2;
    _UV[SP_VERTEX_Y3] := v;
    _UV[SP_VERTEX_X4] := u2;
    _UV[SP_VERTEX_Y4] := v2;
  end;
end;

procedure TSpineRegionAttachment.UpdateOffset;
  var TempRegionScaleX, TempRegionScaleY: Single;
  var TempLocalX, TempLocalY, TempLocalX2, TempLocalY2: Single;
  var Radians, c, s: Single;
  var TempLocalXCos, TempLocalXSin, TempLocalYCos, TempLocalYSin: Single;
  var TempLocalX2Cos, TempLocalX2Sin, TempLocalY2Cos, TempLocalY2Sin: Single;
begin
  TempRegionScaleX := _Width / _RegionOriginalWidth * _ScaleX;
  TempRegionScaleY := _Height / _RegionOriginalHeight * _ScaleY;
  TempLocalX := -_Width * 0.5 * _ScaleX + _RegionOffsetX * _RegionScaleX;
  TempLocalY := -_Height * 0.5 * _ScaleY + _RegionOffsetY * _RegionScaleY;
  TempLocalX2 := TempLocalX + _RegionWidth * TempRegionScaleX;
  TempLocalY2 := TempLocalY + _RegionHeight * TempRegionScaleY;
  Radians := _Rotation * SP_DEG_TO_RAD;
  c := Cos(Radians);
  s := Sin(Radians);
  TempLocalXCos := TempLocalX * c + _x;
  TempLocalXSin := TempLocalX * s;
  TempLocalYCos := TempLocalY * c + _y;
  TempLocalYSin := TempLocalY * s;
  TempLocalX2Cos := TempLocalX2 * c + _x;
  TempLocalX2Sin := TempLocalX2 * s;
  TempLocalY2Cos := TempLocalY2 * c + _y;
  TempLocalY2Sin := TempLocalY2 * s;
  _Offset[SP_VERTEX_X1] := TempLocalXCos - TempLocalYSin;
  _Offset[SP_VERTEX_Y1] := TempLocalYCos + TempLocalXSin;
  _Offset[SP_VERTEX_X2] := TempLocalXCos - TempLocalY2Sin;
  _Offset[SP_VERTEX_Y2] := TempLocalY2Cos + TempLocalXSin;
  _Offset[SP_VERTEX_X3] := TempLocalX2Cos - TempLocalY2Sin;
  _Offset[SP_VERTEX_Y3] := TempLocalY2Cos + TempLocalX2Sin;
  _Offset[SP_VERTEX_X4] := TempLocalX2Cos - TempLocalYSin;
  _Offset[SP_VERTEX_Y4] := TempLocalYCos + TempLocalX2Sin;
end;

procedure TSpineRegionAttachment.ComputeWorldVertices(const Bone: TSpineBone; var OutWorldVertices: TSpineRegionVertices);
  var bx, by: Single;
  var m: TSpineMat;
begin
  bx := Bone.Skeleton.x + Bone.WorldX; by := Bone.Skeleton.y + Bone.WorldY;
  m := Bone.m;
  OutWorldVertices[SP_VERTEX_X1] := _Offset[SP_VERTEX_X1] * m[0, 0] + _Offset[SP_VERTEX_Y1] * m[0, 1] + bx;
  OutWorldVertices[SP_VERTEX_Y1] := _Offset[SP_VERTEX_X1] * m[1, 0] + _Offset[SP_VERTEX_Y1] * m[1, 1] + by;
  OutWorldVertices[SP_VERTEX_X2] := _Offset[SP_VERTEX_X2] * m[0, 0] + _Offset[SP_VERTEX_Y2] * m[0, 1] + bx;
  OutWorldVertices[SP_VERTEX_Y2] := _Offset[SP_VERTEX_X2] * m[1, 0] + _Offset[SP_VERTEX_Y2] * m[1, 1] + by;
  OutWorldVertices[SP_VERTEX_X3] := _Offset[SP_VERTEX_X3] * m[0, 0] + _Offset[SP_VERTEX_Y3] * m[0, 1] + bx;
  OutWorldVertices[SP_VERTEX_Y3] := _Offset[SP_VERTEX_X3] * m[1, 0] + _Offset[SP_VERTEX_Y3] * m[1, 1] + by;
  OutWorldVertices[SP_VERTEX_X4] := _Offset[SP_VERTEX_X4] * m[0, 0] + _Offset[SP_VERTEX_Y4] * m[0, 1] + bx;
  OutWorldVertices[SP_VERTEX_Y4] := _Offset[SP_VERTEX_X4] * m[1, 0] + _Offset[SP_VERTEX_Y4] * m[1, 1] + by;
end;
//TSpineRegionAttachment END

//TSpineAtlasAttachmentLoader BEGIN
constructor TSpineAtlasAttachmentLoader.Create(const AAtlasList: TSpineAtlasList);
begin
  inherited Create;
  _AtlasList := AAtlasList;
  _AtlasList.RefInc;
end;

function TSpineAtlasAttachmentLoader.NewRegionAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineRegionAttachment;
  var Region: TSpineAtlasRegion;
begin
  Region := FindRegion(Path);
  Result := TSpineRegionAttachment.Create(Name);
  Result.RendererObject = Region;
  Result.SetUV(Region.u, Region.v, Region.u2, Region.v2, Region.Rotate);
  Result.RegionOffsetX = Region.OffsetX;
  Result.RegionOffsetY = Region.OffsetY;
  Result.RegionWidth = Region.Width;
  Result.RegionHeight = Region.Height;
  Result.RegionOriginalWidth = Region.OriginalWidth;
  Result.RegionOriginalHeight = Region.OriginalHeight;
end;

function TSpineAtlasAttachmentLoader.NewMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineMeshAttachment;
begin

end;

function TSpineAtlasAttachmentLoader.NewSkinnedMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineSkinnedMeshAttachment;
begin

end;

function TSpineAtlasAttachmentLoader.NewBoundingBoxAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineBoundingBoxAttachment;
begin

end;

function TSpineAtlasAttachmentLoader.FindRegion(const Name: String): TSpineAtlasRegion;
begin

end;
//TSpineAtlasAttachmentLoader END

//TSpineClass BEGIN
procedure TSpineClass.AfterConstruction;
begin
  _Ref := 1;
end;

procedure TSpineClass.RefInc;
begin
  Inc(_Ref);
end;

procedure TSpineClass.RefDec;
begin
  if Self = nil then Exit;
  Dec(_Ref);
  if _Ref <= 0 then Self.Destroy;
end;

procedure TSpineClass.Free;
begin
  RefDec;
end;
//TSpineClass END

//TG2QuickListG BEGIN
{$Hints off}
procedure TSpineList.SetItem(const Index: Integer; const Value: T);
begin
  _Items[Index] := Value;
end;

function TSpineList.GetItem(const Index: Integer): T;
begin
  Result := _Items[Index];
end;

procedure TSpineList.SetCapacity(const Value: Integer);
begin
  SetLength(_Items, Value);
end;

function TSpineList.GetCapacity: Integer;
begin
  Result := Length(_Items);
end;

function TSpineList.GetFirst: T;
begin
  if _ItemCount > 0 then Result := _Items[0];
end;

function TSpineList.GetLast: T;
begin
  Result := _Items[_ItemCount - 1];
end;

function TSpineList.GetData: TItemPtr;
begin
  if _ItemCount > 0 then
  Result := @_Items[0]
  else
  Result := nil;
end;

constructor TSpineList.Create;
begin
  inherited Create;
  Clear;
end;

destructor TSpineList.Destroy;
  var i: Integer;
begin
  for i := 0 to _ItemCount - 1 do
  _Items[i].Free;
  Clear;
  inherited Destroy;
end;

function TSpineList.Find(const Item: T): Integer;
  var i: Integer;
begin
  for i := 0 to _ItemCount - 1 do
  if _Items[i] = Item then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;

function TSpineList.Add(const Item: T): Integer;
begin
  if Length(_Items) <= _ItemCount then
  SetLength(_Items, Length(_Items) + 256);
  _Items[_ItemCount] := Item;
  Result := _ItemCount;
  Inc(_ItemCount);
end;

function TSpineList.Pop: T;
begin
  if _ItemCount > 0 then Result := Extract(_ItemCount - 1);
end;

function TSpineList.Extract(const Index: Integer): T;
begin
  Result := _Items[Index];
  Delete(Index);
end;

function TSpineList.Insert(const Index: Integer; const Item: T): Integer;
  var i: Integer;
begin
  if Length(_Items) <= _ItemCount then
  SetLength(_Items, Length(_Items) + 256);
  if Index < _ItemCount then
  begin
    for i := _ItemCount - 1 downto Index do
    _Items[i + 1] := _Items[i];
    _Items[Index] := Item;
    Result := Index;
  end
  else
  begin
    _Items[_ItemCount] := Item;
    Result := _ItemCount;
  end;
  Inc(_ItemCount);
end;

procedure TSpineList.Delete(const Index: Integer; const ItemCount: Integer);
  var i: Integer;
begin
  for i := Index to _ItemCount - (1 + ItemCount) do
  _Items[i] := _Items[i + ItemCount];
  Dec(_ItemCount, ItemCount);
end;

procedure TSpineList.Remove(const Item: T);
  var i: Integer;
begin
  i := Find(Item);
  if i > -1 then
  Delete(i);
end;

procedure TSpineList.Clear;
begin
  _ItemCount := 0;
end;

function TSpineList.Search(const CmpFunc: TCmpFunc; const Item: T): Integer;
  var l, h, m, r: Integer;
begin
  l := 0;
  h := _ItemCount - 1;
  while l <= h do
  begin
    m := (l + h) shr 1;
    r := CmpFunc(_Items[m], Item);
    if r = 0 then Exit(m)
    else if r < 0 then l := m + 1
    else h := m - 1;
  end;
  if (l < _ItemCount) and (CmpFunc(_Items[l], Item) = 0) then Exit(l) else Exit(-1);
end;

function TSpineList.Search(const CmpFunc: TCmpFuncObj; const Item: T): Integer;
  var l, h, m, r: Integer;
begin
  l := 0;
  h := _ItemCount - 1;
  while l <= h do
  begin
    m := (l + h) shr 1;
    r := CmpFunc(_Items[m], Item);
    if r = 0 then Exit(m)
    else if r < 0 then l := m + 1
    else h := m - 1;
  end;
  if (l < _ItemCount) and (CmpFunc(_Items[l], Item) = 0) then Exit(l) else Exit(-1);
end;

procedure TSpineList.Sort(
  const CmpFunc: TCmpFunc;
  RangeStart, RangeEnd: Integer
);
  var i, j : LongInt;
  var tmp, pivot: T;
begin
  if RangeEnd < RangeStart then Exit;
  i := RangeStart;
  j := RangeEnd;
  pivot := _Items[(RangeStart + RangeEnd) shr 1];
  repeat
    while CmpFunc(pivot, _Items[i]) > 0 do i := i + 1;
    while CmpFunc(pivot, _Items[j]) < 0 do j := j - 1;
    if i <= j then
    begin
      tmp := _Items[i];
      _Items[i] := _Items[j];
      _Items[j] := tmp;
      j := j - 1;
      i := i + 1;
    end;
  until i > j;
  if RangeStart < j then Sort(CmpFunc, RangeStart, j);
  if i < RangeEnd then Sort(CmpFunc, i, RangeEnd);
end;

procedure TSpineList.Sort(
  const CmpFunc: TCmpFuncObj;
  RangeStart, RangeEnd: Integer
);
  var i, j : LongInt;
  var tmp, pivot: T;
begin
  i := RangeStart;
  j := RangeEnd;
  pivot := _Items[(RangeStart + RangeEnd) shr 1];
  repeat
    while CmpFunc(pivot, _Items[i]) > 0 do i := i + 1;
    while CmpFunc(pivot, _Items[j]) < 0 do j := j - 1;
    if i <= j then
    begin
      tmp := _Items[i];
      _Items[i] := _Items[j];
      _Items[j] := tmp;
      j := j - 1;
      i := i + 1;
    end;
  until i > j;
  if RangeStart < j then Sort(CmpFunc, RangeStart, j);
  if i < RangeEnd then Sort(CmpFunc, i, RangeEnd);
end;

procedure TSpineList.Sort(const CmpFunc: TCmpFunc);
begin
  Sort(CmpFunc, 0, _ItemCount - 1);
end;

procedure TSpineList.Sort(const CmpFunc: TCmpFuncObj);
begin
  Sort(CmpFunc, 0, _ItemCount - 1);
end;
{$Hints on}
//TSpineList END

end.
