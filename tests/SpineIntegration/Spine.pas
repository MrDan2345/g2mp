unit Spine;

interface

uses
  Classes,
  SysUtils;

type
  TSpineClass = class;
  TSpineBoneData = class;
  TSpineSlotData = class;
  TSpineSkeletonData = class;
  TSpineEventData = class;
  TSpineIKConstraintData = class;
  TSpineBone = class;
  TSpineSlot = class;
  TSpineSkeleton = class;
  TSpineEvent = class;
  TSpineIKConstraint = class;
  TSpineAttachment = class;
  TSpineBoundingBoxAttachment = class;
  TSpineSkin = class;
  TSpinePolygon = class;
  TSpineAnimation = class;
  TSpineAnimationState = class;
  TSpineAnimationStateData = class;
  TSpineAtlasPage = class;
  TSpineAtlasRegion = class;
  TSpineAtlas = class;

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
    procedure FreeItems;
    procedure Clear;
    function Search(const CmpFunc: TCmpFunc; const Item: T): Integer; overload;
    function Search(const CmpFunc: TCmpFuncObj; const Item: T): Integer; overload;
    procedure Sort(const CmpFunc: TCmpFunc; RangeStart, RangeEnd: Integer); overload;
    procedure Sort(const CmpFunc: TCmpFuncObj; RangeStart, RangeEnd: Integer); overload;
    procedure Sort(const CmpFunc: TCmpFunc); overload;
    procedure Sort(const CmpFunc: TCmpFuncObj); overload;
  end;

  TSpineStringArray = array of String;
  TSpineFloatArray = array of Single;
  TSpineIntArray = array of Integer;
  TSpineAttachmentArray = array of TSpineAttachment;
  TSpineRegionVertices = array[0..7] of Single;
  PSpineFloatArray = ^TSpineFloatArray;

  TSpineBoneDataList = specialize TSpineList<TSpineBoneData>;
  TSpineSlotDataList = specialize TSpineList<TSpineSlotData>;
  TSpineEventDataList = specialize TSpineList<TSpineEventData>;
  TSpineBoneList = specialize TSpineList<TSpineBone>;
  TSpineSlotList = specialize TSpineList<TspineSlot>;
  TSpineSkinList = specialize TSpineList<TSpineSkin>;
  TSpineAttachmentList = specialize TSpineList<TSpineAttachment>;
  TSpineBoundingBoxAttachmentList = specialize TSpineList<TSpineBoundingBoxAttachment>;
  TSpineAnimationList = specialize TSpineList<TSpineAnimation>;
  TSpineIKConstraintList = specialize TSpineList<TSpineIKConstraint>;
  TSpineAtlasPageList = specialize TSpineList<TSpineAtlasPage>;
  TSpineAtlasRegionList = specialize TSpineList<TSpineAtlasRegion>;
  TSpineAtlasList = specialize TSpineList<TSpineAtlas>;
  TSpinePolygonList = specialize TSpineList<TSpinePolygon>;

  TSpineBlendMode = (
    sp_bm_normal,
    sp_bm_additive,
    sp_bm_multiply,
    sp_bm_screen
  );

  TSpineAttachmentType = (
    sp_at_region,
    sp_at_bounding_box,
    sp_at_mesh,
    sp_at_skinned_mesh
  );

  TSpineAtlasPageFormat = (
    sp_af_alpha,
    sp_af_intensity,
    sp_af_luminance_alpha,
    sp_af_rgb565,
    sp_af_rgba4444,
    sp_af_rgb888,
    sp_af_rgba8888
  );

  TSpineAtlasPageTextureFilter = (
    sp_tf_nearest,
    sp_tf_linear,
    sp_tf_mip_map
  );

  TSpineAtlasPageWrap = (
    sp_apw_mirror,
    sp_apw_clamp,
    sp_apw_repeat
  );

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

  TSpineSlotData = class (TSpineClass)
  private
    var _Name: String;
    var _BoneData: TSpineBoneData;
    var _AttachmentName: String;
    var _BlendMode: TSpineBlendMode;
    var _r: Single;
    var _g: Single;
    var _b: Single;
    var _a: Single;
  public
    property Name: String read _Name;
    property BoneData: TSpineBoneData read _BoneData;
    property r: Single read _r write _r;
    property g: Single read _g write _g;
    property b: Single read _b write _b;
    property a: Single read _a write _a;
    property AttachmentName: String read _AttachmentName write _AttachmentName;
    property BlendMode: TSpineBlendMode read _BlendMode write _BlendMode;
    constructor Create(const AName: String; const ABoneData: TSpineBoneData);
  end;

  TSpineSkeletonData = class (TSpineClass)
  private
    var _Name: String;
    var _Bones: TSpineBoneDataList;
    var _Slots: TSpineSlotDataList;
    var _Skins: TSpineSkinList;
    var _DefaultSkin: TSpineSkin;
    var _Events: TSpineEventDataList;
    var _Animations: TSpineAnimationList;
    var _IKConstraints: TSpineIKConstraintList;
    var _Width: Single;
    var _Height: Single;
    var _Version: String;
    var _Hash: String;
    var _ImagePath: String;
  public
    property Name: String read _Name write _Name;
    property Bones: TSpineBoneDataList read _Bones;
    property Slots: TSpineSlotDataList read _Slots;
    property Skins: TSpineSkinList read _Skins;
    property DefaultSkin: TSpineSkin read _DefaultSkin;
    property Events: TSpineEventDataList read _Events;
    property Animations: TSpineAnimationList read _Animations;
    property IKConstraints: TSpineIKConstraintList read _IKConstraints;
    property Width: Single read _Width write _Width;
    property Height: Single read _Height write _Height;
    property Version: String read _Version write _Version;
    property Hash: String read _Hash write _Hash;
    constructor Create;
    destructor Destroy; override;
    function FindBone(const BoneName: String): TSpineBoneData;
    function FindBoneIndex(const BoneName: String): Integer;
    function FindSlot(const SlotName: String): TSpineSlotData;
    function FindSlotIndex(const SlotName: String): Integer;
    function FindSkin(const SkinName: String): TSpineSkin;
    function FindSkinIndex(const SkinName: String): Integer;
    function FindEvent(const EventName: String): TSpineEventData;
    function FindEventIndex(const EventName: String): Integer;
    function FindAnimation(const AnimationName: String): TSpineAnimation;
    function FindAnimationIndex(const AnimationName: String): Integer;
    function FindIKConstraint(const IKConstraintName: String): TSpineIKConstraintData;
    function FindIKConstraintIndex(const IKConstraintName: String): Integer;
  end;

  TSpineEventData = class (TSpineClass)
  private
    var _Name: String;
    var _IntValue: Integer;
    var _FloatValie: Single;
    var _StringValue: String;
  public
    property Name: String read _Name;
    constructor Create(const AName: String);
  end;

  TSpineIKConstraintData = class (TSpineClass)
  private
    var _Name: String;
    var _Bones: TSpineBoneDataList;
    var _Target: TSpineBoneData;
    var _BlendDirection: Integer;
    var _Mix: Single;
  public
    property Name: String read _Name;
    property Bones: TSpineBoneDataList read _Bones;
    property Target: TSpineBoneData read _Target write _Target;
    property BlendDirection: Integer read _BlendDirection write _BlendDirection;
    property Mix: Single read _Mix write _Mix;
    constructor Create(const AName: String);
    destructor Destroy; override;
  end;

  TSpineBone = class (TSpineClass)
  public
    class var YDown: Boolean;
  private
    var _FlipX: Boolean;
    var _FlipY: Boolean;
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
    var _WorldFlipX: Boolean;
    var _WorldFlipY: Boolean;
    var _m00: Single;
    var _m01: Single;
    var _m10: Single;
    var _m11: Single;
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
    property m00: Single read _m00;
    property m01: Single read _m01;
    property m10: Single read _m10;
    property m11: Single read _m11;
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

  TSpineSlot = class (TSpineClass)
  private
    var _Data: TSpineSlotData;
    var _Bone: TSpineBone;
    var _r: Single;
    var _g: Single;
    var _b: Single;
    var _a: Single;
    var _Attachment: TSpineAttachment;
    var _AttachmentTime: Single;
    var _AttachmentVertices: TSpineFloatArray;
    procedure SetAttachment(const Value: TSpineAttachment); inline;
    function GetAttachmentTime: Single; inline;
    procedure SetAttachmentTime(const Value: Single); inline;
  public
    property Data: TSpineSlotData read _Data;
    property Bone: TSpineBone read _Bone;
    property Skeleton: TSpineSkeleton read _Bone.Skeleton;
    property r: Single read _r write _r;
    property g: Single read _g write _g;
    property b: Single read _b write _b;
    property a: Single read _a write _a;
    property AttachmentVertices: TSpineFloatArray read _AttachemntVertex write _AttachmentVertex;
    property Attachment: TSpineAttachment read _Attachment write SetAttachment;
    property AttachmentTime: Single read GetAttachmentTime write SetAttachmentTime;
    constructor Create(const AData: TSpineSlotData; const ABone: TSpineBone);
    procedure SetToSetupPose(const SlotIndex: Integer); overload;
    procedure SetToSetupPose; overload;
  end;

  TSpineSkeleton = class (TSpineClass)
  private
    var _Data: TSpineSkeletonData;
    var _Bones: TSpineBoneList;
    var _Slots: TSpineSlotlist;
    var _DrawOrder: TSpineSlotList;
    var _IKConstraints: TSpineIKConstraintList;
    var _BoneCache: specialize TSpineList<TSpineBoneList>;
    var _Skin: TSpineSkin;
    var _r: Single;
    var _g: Single;
    var _b: Single;
    var _a: Single;
    var _Time: Single;
    var _FlipX: Boolean;
    var _FlipY: Boolean;
    var _x: Single;
    var _y: Single;
    procedure SetIKConstraints(const Value: TSpineIKConstraintList); inline;
    procedure SetSkin(const Value: TSpineSkin); inline;
    function GetRootBone: TSpineBone; inline;
  public
    property Data: TSpineSkeletonData read _Data;
    property Bones: TSpineBoneList read _Bones;
    property Slots: TSpineSlotList read _Slots;
    property DrawOrder: TSpineSlotList read _DrawOrder;
    property IKConstraints: TSpineIKConstraintList read _IKConstraints write SetIKConstraints;
    property Skin: TSpineSkin read _Skin write SetSkin;
    property r: Single read _r write _r;
    property g: Single read _g write _g;
    property b: Single read _b write _b;
    property a: Single read _a write _a;
    property Time: Single read _Time write _Time;
    property x: Single read _x write _x;
    property y: Single read _y write _y;
    property FlipX: Boolean read _FlipX write _FlipX;
    property FlipY: Boolean read _FlipY write _FlipY;
    property RootBone: TSpineBone read GetRootBone;
    constructor Create(const AData: TSpineSkeletonData);
    destructor Destroy; override;
    procedure UpdateCache;
    procedure UpdateWorldTransform;
    procedure SetToSetupPose;
    procedure SetBonesToSetupPose;
    procedure SetSlotsToSetupPose;
    function FindBone(const BoneName: String): TSpineBone;
    function FindBoneIndex(const BoneName: String): Integer;
    function FindSlot(const SlotName: String): TSpineSlot;
    function FindSlotIndex(const SlotName: String): Integer;
    function FindIKConstraint(const IKConstraintName: String): TSpineIKConstraint;
    procedure SetSkinByName(const SkinName: String);
    function GetAttachment(const SlotName, AttachmentName: String): TSpineAttachment;
    function GetAttachment(const SlotIndex: Integer; const AttachmentName: String): TSpineAttachment;
    procedure SetAttachment(const SlotName, AttachmentName: String);
    procedure Update(const Delta: Single);
  end;

  TSpinePolygon = class (TSpineClass)
  private
    var _Vertices: TSpineFloatArray;
    var _Count: Integer;
  public
    property Vertices: TSpineFloatArray read _Vertices write _Vertices;
    property Count: Integer read _Count write _Count;
    constructor Create;
  end;

  TSpineAnimation = class (TSpineClass)
  end;

  TSpineAnimationState = class (TSpineClass)
  end;

  TSpineAnimationStateData = class (TSpineClass)
  end;

  TSpineSkeletonBounds = class (TSpineClass)
  private
    var _PolygonPool: TSpinePolygonList;
    var _MinX, _MinY, _MaxX, _MaxY: Single;
    var _BoundingBoxes: TSpineBoundingBoxAttachmentList;
    var _Polygons: TSpinePolygonList;
    function GetWidth: Single; inline;
    function GetHeight: Single; inline;
    procedure ComputeAABB;
  public
    property BoundingBoxes: TSpineBoundingBoxAttachmentList read _BoundingBoxes;
    property Polygons: TSpinePolygonList read _Polygons;
    property MinX: Single read _MinX write _MinX;
    property MinY: Single read _MinY write _MinY;
    property MaxX: Single read _MaxX write _MaxX;
    property MaxY: Single read _MaxY write _MaxY;
    property Width: Single read GetWidth;
    property Height: Single read GetHeight;
    constructor Create;
    destructor Destroy; override;
    procedure Update(const Skeleton: TSpineSkeleton; const UpdateAABB: Boolean);
    function AABBContainsPoint(const x, y: Single): Boolean; inline;
    function AABBIntersectsSegment(const x1, y1, x2, y2: Single): Boolean;
    function AABBIntersectsSkeleton(const Bounds: TSpineSkeletonBounds): Boolean;
    function ContainsPoint(const Polygon: TSpinePolygon; const x, y: Single): Boolean; overload;
    function ContainsPoint(const x, y: Single): TSpineBoundingBoxAttachment; overload;
    function IntersectsSegment(const Polygon: TSpinePolygon; const x1, y1, x2, y2: Single): Boolean; overload;
    function IntersectsSegment(const x1, y1, x2, y2: Single): TSpineBoundingBoxAttachment; overload;
    function GetPolygon(const Attachment: TSpineBoundingBoxAttachment): TSpinePolygon;
  end;

  TSpineEvent = class (TSpineClass)
  private
    var _Data: TSpineEventData;
    var _IntValue: Integer;
    var _FloatValue: Single;
    var _StringValue: String;
  public
    constructor Create(const AData: TSpineEventData);
  end;

  TSpineIKConstraint = class (TSpineClass)
  private
    var _Data: TSpineIKConstraintData;
    var _Bones: TSpineBoneList;
    var _Target: TSpineBone;
    var _BlendDirection: Integer;
    var _Mix: Single;
    class procedure Apply(var Bone: TSpineBone; const TargetX, TargetY, Alpha: Single); overload;
    class procedure Apply(var Parent, Child: TSpineBone; const TargetX, TargetY, Alpha: Single; const ABlendDirection: Integer); overload;
  public
    property Data: TSpineIKConstraintData read _Data;
    property Bones: TSpineBoneList read _Bones;
    property Target: TSpineBone read _Target write _Target;
    property BlendDiretion: Integer read _BlendDirection write _BlendDirection;
    property Mix: Single read _Mix write _Mix;
    constructor Create(const AData: TSpineIKConstraintData; const ASkeleton: TSpineSkeleton);
    destructor Destroy; override;
    procedure Apply;
  end;

  type TSpineSkinKey = class (TSpineClass)
  public
    var SlotIndex: Integer;
    var Name: String;
    var Attachment: TSpineAttachment;
  end;

  TSpineSkinKeyList = specialize TSpineList<TSpineSkinKey>;

  TSpineSkin = class (TSpineClass)
  private
    var _Name: String;
    var _Attachments: TSpineSkinKeyList;
    property Attachments: TSpineSkinKeyList read _Attachments;
    procedure AttachAll(const Skeleton: TSpineSkeleton; const OldSkin: TSpineSkin);
  public
    property Name: String read _Name;
    constructor Create(const AName: String);
    destructor Destroy; override;
    procedure AddAttachment(const SlotIndex: Integer; const KeyName: String; const Attachment: TSpineAttachment);
    function GetAttachment(const SlotIndex: Integer; const KeyName: String): TSpineAttachment;
    procedure FindNamesForSlot(const SlotIndex: Integer; var KeyNames: TSpineStringArray);
    procedure FindAttachmentsForSlot(const SlotIndex: Integer; var KeyAttachments: TSpineAttachmentArray);
  end;

  TSpineAtlasPage = class (TSpineClass)
  public
    var Name: String;
    var Format: TSpineAtlasPageFormat;
    var MinFilter: TSpineAtlasPageTextureFilter;
    var MagFilter: TSpineAtlasPageTextureFilter;
    var WrapU: TSpineAtlasPageWrap;
    var WrapV: TSpineAtlasPageWrap;
    var Texture: TSpineTexture;
    var Width: Integer;
    var Height: Integer;
  end;

  TSpineAtlasRegion = class (TSpineClass)
  public
    var Page: String;
    var Name: String;
    var x: Integer;
    var y: Integer;
    var w: Integer;
    var h: Integer;
    var u: Single;
    var v: Single;
    var u2: Single;
    var v2: Single;
    var OffsetX, OffsetY: Single;
    var OriginalWidth: Integer;
    var OriginalHeight: Integer;
    var Index: Integer;
    var Rotate: Boolean;
    var Splits: array of Integer;
    var Pads: array of Integer;
  end;

  TSpineAtlas = class (TSpineClass)
  private
    var _Pages: TSpineAtlasPageList;
    var _Regions: TSpineAtlasRegionList;
  public
  end;

  TSpineAttachment = class (TSpineClass)
  private
    var _Name: String;
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

  TSpineBoundingBoxAttachment = class (TSpineAttachment)
  private
    var _Vertices: TSpineFloatArray;
  public
    property Vertices: TSpineFloatArray read _Vertices write _Vertices;
    constructor Create(const AName: String); override;
    procedure ComputeWorldVertices(const Bone: TSpineBone; var WorldVerices: TSpineFloatArray);
  end;

  TSpineMeshAttachment = class (TSpineAttachment)
  private
    var _Vertices: TSpineFloatArray;
    var _UV: TSpineFloatArray;
    var _RegionUV: TSpineFloatArray;
    var _Triangles: TSpineIntArray;
    var _Edges: TSpineIntArray;
    var _RegionOffsetX: Single;
    var _RegionOffsetY: Single;
    var _RegionWidth: Single;
    var _RegionHeight: Single;
    var _RegionOriginalWidth: Single;
    var _RegionOriginalHeight: Single;
    var _RegionU: Single;
    var _RegionV: Single;
    var _RegionU2: Single;
    var _RegionV2: Single;
    var _RegionRotate: Boolean;
    var _r: Single;
    var _g: Single;
    var _b: Single;
    var _a: Single;
    var _HullLength: Integer;
    var _Path: String;
    var _Width: Single;
    var _Height: Single;
  public
    property HullLength: Integer read _HullLength write _HullLength;
    property Vertices: TSpineFloatArray read _Vertices write _Vertices;
    property RegionUV: TSpineFloatArray read _RegionUV write _RegionUV;
    property UV: TSpineFloatArray read _UV write _UV;
    property Triangles: TSpineIntArray read _Triangles write _Triangles;
    property Edges: TSpineIntArray read _Edges write _Edges;
    property r: Single read _r write _r;
    property g: Single read _g write _g;
    property b: Single read _b write _b;
    property a: Single read _a write _a;
    property Path: String read _Path write _Path;
    property RegionU: Single read _RegionU write _RegionU;
    property RegionV: Single read _RegionV write _RegionV;
    property RegionU2: Single read _RegionU2 write _RegionU2;
    property RegionV2: Single read _RegionV2 write _RegionV2;
    property RegionRotate: Boolean read _RegionRotate write _RegionRotate;
    property RegionOffsetX: Single read _RegionOffsetX write _RegionOffsetX;
    property RegionOffsetY: Single read _RegionOffsetY write _RegionOffsetY;
    property RegionWidth: Single read _RegionWidth write _RegionWidth;
    property RegionHeight: Single read _RegionHeight write _RegionHeight;
    property RegionOriginalWidth: Single read _RegionOriginalWidth write _RegionOriginalWidth;
    property RegionOriginalHeight: Single read _RegionOriginalHeight write _RegionOriginalHeight;
    property Width: Single read _Width write _Width;
    property Height: Single read _Height write _Height;
    constructor Create(const AName: String); override;
    procedure UpdateUV;
    procedure ComputeWorldVertices(const Slot: TSpineSlot; var WorldVertices: TSpineFloatArray);
  end;

  TSpineSkinnedMeshAttachment = class (TSpineAttachment)
  private
    _Weights: TSpineFloatArray;
    var _Bones: TSpineIntArray;
    var _Wights: TSpineFloatArray;
    var _UV: TSpineFloatArray;
    var _RegionUV: TSpineFloatArray;
    var _Triangles: TSpineIntArray;
    var _Edges: TSpineIntArray;
    var _RegionOffsetX: Single;
    var _RegionOffsetY: Single;
    var _RegionWidth: Single;
    var _RegionHeight: Single;
    var _RegionOriginalWidth: Single;
    var _RegionOriginalHeight: Single;
    var _RegionU: Single;
    var _RegionV: Single;
    var _RegionU2: Single;
    var _RegionV2: Single;
    var _RegionRotate: Boolean;
    var _r: Single;
    var _g: Single;
    var _b: Single;
    var _a: Single;
    var _HullLength: Integer;
    var _Path: String;
    var _Width: Single;
    var _Height: Single;
  public
    property HullLength: Integer read _HullLength write _HullLength;
    property Bones: TSpineIntArray read _Bones write _Bones;
    property Weights: TSpineFloatArray read _Weights write _Weights;
    property RegionUV: TSpineFloatArray read _RegionUV write _RegionUV;
    property UV: TSpineFloatArray read _UV write _UV;
    property Triangles: TSpineIntArray read _Triangles write _Triangles;
    property Edges: TSpineIntArray read _Edges write _Edges;
    property r: Single read _r write _r;
    property g: Single read _g write _g;
    property b: Single read _b write _b;
    property a: Single read _a write _a;
    property Path: String read _Path write _Path;
    property RegionU: Single read _RegionU write _RegionU;
    property RegionV: Single read _RegionV write _RegionV;
    property RegionU2: Single read _RegionU2 write _RegionU2;
    property RegionV2: Single read _RegionV2 write _RegionV2;
    property RegionRotate: Boolean read _RegionRotate write _RegionRotate;
    property RegionOffsetX: Single read _RegionOffsetX write _RegionOffsetX;
    property RegionOffsetY: Single read _RegionOffsetY write _RegionOffsetY;
    property RegionWidth: Single read _RegionWidth write _RegionWidth;
    property RegionHeight: Single read _RegionHeight write _RegionHeight;
    property RegionOriginalWidth: Single read _RegionOriginalWidth write _RegionOriginalWidth;
    property RegionOriginalHeight: Single read _RegionOriginalHeight write _RegionOriginalHeight;
    property Width: Single read _Width write _Width;
    property Height: Single read _Height write _Height;
    constructor Create(const AName: String); override;
    procedure UpdateUV;
    procedure ComputeWorldVertices(const Slot: TSpineSlot; var WorldVertices: TSpineFloatArray);
  end;

  TSpineAttachmentLoader = class (TSpineClass)
  public
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
    function NewRegionAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineRegionAttachment;
    function NewMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineMeshAttachment;
    function NewSkinnedMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineSkinnedMeshAttachment;
    function NewBoundingBoxAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineBoundingBoxAttachment;
    function FindRegion(const Name: String): TSpineAtlasRegion;
  end;

const
  SP_DEG_TO_RAD = Pi / 180;
  SP_RAD_TO_DEG = 180 / Pi;

implementation

function SpineArcTan2(const y, x: Single): Single;
  const HalgPi = Pi * 0.5;
  const TwoPi = Pi * 2;
begin
  if x = 0 then
  begin
    if y = 0 then Result := 0
    else if y > 0 then Result := HalfPi
    else if y < 0 then Result := -HalfPi;
  end
  else
  Result := ArcTan(y / x);
  if x < 0 then
  Result := Result + pi;
  if Result > pi then
  Result := Result - TwoPi;
end;

function SpineMin(const v0, v1: Single): Single;
begin
  if v0 < v1 then Result := v0 else Result := v1;
end;

function SpineMax(const v0, v1: Single): Single;
begin
  if v0 > v1 then Result := v0 else Result := v1;
end;

//TSpineBoneData BEGIN
constructor TSpineBoneData.Create(const AName: String; const AParent: TSpineBoneData);
begin
  _Name := AName;
  _Parent := AParent;
  _ScaleX := 1;
  _ScaleY := 1;
end;
//TSpineBoneData END

//TSpineSlotData BEGIN
constructor TSpineSlotData.Create(const AName: String; const ABoneData: TSpineBoneData);
begin
  _Name := AName;
  _BoneData := ABoneData;
  _r := 1;
  _g := 1;
  _b := 1;
  _a := 1;
end;
//TSpineSlotData END

//TSpineSkeletonData BEGIN
constructor TSpineSkeletonData.Create;
begin
  _Bones := TSpineBoneDataList.Create;
  _Slots := TSpineSlotDataList.Create;
  _Skins := TSpineSkinList.Create;
  _DefaultSkin := TSpineSkin.Create;
  _Events := TSpineEventDataList.Create;
  _Animations := TSpineAnimationList.Create;
  _IKConstraints := TSpineIKConstraintList.Create;
end;

destructor TSpineSkeletonData.Destroy;
begin
  _Bones.Free;
  _Slots.Free;
  _Skins.Free;
  _DefaultSkin.Free;
  _Events.Free;
  _Animations.Free;
  _IKConstraints.Free;
  inherited Destroy;
end;

function TSpineSkeletonData.FindBone(const BoneName: String): TSpineBoneData;
  var i: Integer;
begin
  i := FindBoneIndex(BoneName);
  if i > -1 then Result := _Bones[i] else Result := nil;
end;

function TSpineSkeletonData.FindBoneIndex(const BoneName: String): Integer;
  var i: Integer;
begin
  for i := 0 to _Bones.Count - 1 do
  if _Bones[i].Name = BoneName then
  Exit(i);
  Result := -1;
end;

function TSpineSkeletonData.FindSlot(const SlotName: String): TSpineSlotData;
  var i: Integer;
begin
  i := FindSlotIndex(SlotName);
  if i > -1 then Result := _Slots[i] else Result := nil;
end;

function TSpineSkeletonData.FindSlotIndex(const SlotName: String): Integer;
  var i: Integer;
begin
  for i := 0 to _Slots.Count - 1 do
  if _Slots[i].Name = SlotName then
  Exit(i);
  Result := -1;
end;

function TSpineSkeletonData.FindSkin(const SkinName: String): TSpineSkin;
  var i: Integer;
begin
  i := FindSkinIndex(SkinName);
  if i > -1 then Result := _Skins[i] else Result := nil;
end;

function TSpineSkeletonData.FindSkinIndex(const SkinName: String): Integer;
  var i: Integer;
begin
  for i := 0 to _Skins.Count - 1 do
  if _Skins[i].Name = SkinName then
  Exit(i);
  Result := -1;
end;

function TSpineSkeletonData.FindEvent(const EventName: String): TSpineEventData;
  var i: Integer;
begin
  i := FindEventIndex(EventName);
  if i > -1 then Result := _Events[i] else Result := nil;
end;

function TSpineSkeletonData.FindEventIndex(const EventName: String): Integer;
  var i: Integer;
begin
  for i := 0 to _Events.Count - 1 do
  if _Events[i].Name = EventName then
  Exit(i);
  Result := -1;
end;

function TSpineSkeletonData.FindAnimation(const AnimationName: String): TSpineAnimation;
  var i: Integer;
begin
  i := FindAnimationIndex(AnimationName);
  if i > -1 then Result := _Animations[i] else Result := nil;
end;

function TSpineSkeletonData.FindAnimationIndex(const AnimationName: String): Integer;
  var i: Integer;
begin
  for i := 0 to _Animations.Count - 1 do
  if _Animations[i].Name = AnimationName then
  Exit(i);
  Result := -1;
end;

function TSpineSkeletonData.FindIKConstraint(const IKConstraintName: String): TSpineIKConstraintData;
begin

end;

function TSpineSkeletonData.FindIKConstraintIndex(const IKConstraintName: String): Integer;
  var i: Integer;
begin
  for i := 0 to _IKConstraints.Count - 1 do
  if _IKConstraints[i].Name = IKConstraintName then
  Exit(i);
  Result := -1;
end;
//TSpineSkeletonData END

//TSpineEventData BEGIN
constructor TSpineEventData.Create(const AName: String);
begin
  _Name := AName;
  _IntValue := 0;
  _FloatValue := 0;
  _StringValue := '';
end;
//TSpineEventData END

//TSpineIKConstraintData BEGIN
constructor TSpineIKConstraintData.Create(const AName: String);
begin
  _Name := AName;
  _Bones := TSpineBoneList.Create;
end;

destructor TSpineIKConstraintData.Destroy;
begin
  _Bones.Free;
  inherited Destroy;
end;
//TSpineIKConstraintData END

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

//TSpineSlot BEGIN
procedure TSpineSlot.SetAttachment(const Value: TSpineAttachment);
begin
  _Attachment := Value;
  _AttachmentTime := _Bone.Skeleton.Time;
  SetLength(_AttachmentVertices, 0);
end;

function TSpineSlot.GetAttachmentTime: Single;
begin
  Result := _Bone.Skeleton.Time - _AttachmentTime;
end;

procedure TSpineSlot.SetAttachmentTime(const Value: Single);
begin
  _AttachmentTime := _Bone.Skeleton.Time - Value;
end;

constructor TSpineSlot.Create(const AData: TSpineSlotData; const ABone: TSpineBone);
begin
  _Data := AData;
  _Bone := ABone;
  SetToSetupPose;
end;

procedure TSpineSlot.SetToSetupPose(const SlotIndex: Integer);
begin
  _r := _Data.r;
  _g := _Data.g;
  _b := _Data.b;
  _a := _Data.a;
  if Length(_Data.AttachmentName) > 0 then
  _Attachment := _Bone.Skeleton.GetAttachment(SlotIndex, _Data.AttachmentName)
  else
  _Attachment := nil;
end;

procedure TSpineSlot.SetToSetupPose;
begin
  SetToSetupPose(_Bone.Skeleton.Data.Slots.Find(_Data));
end;
//TSpineSlot END

//TSpineSkeleton BEGIN
procedure TSpineSkeleton.SetIKConstraints(const Value: TSpineIKConstraintList);
begin
  if Assigned(_IKConstraints) then _IKConstraints.RefDec;
  _IKConstraints := Value;
  if Assigned(_IKConstraints) then _IKConstraints.RefInc;
end;

procedure TSpineSkeleton.SetSkin(const Value: TSpineSkin);
  var PrevSkin: TSpineSkin;
  var i: Integer;
  var Slot: TSpineSlot;
  var Attachment: TSpineAttachment;
begin
  if Value = _Skin then Exit;
  PrevSkin := _Skin;
  _Skin := Value;
  if Assigned(_Skin) then
  begin
    _Skin.RefInc;
    if Assigned(PrevSkin) then
    begin
      _Skin.AttachAll(Self, PrevSkin)
    end
    else
    begin
      for i := 0 to _Slots.Count - 1 do
      begin
        Slot := _Slots[i];
        if Length(Slot.Data.AttachmentName) > 0 then
        begin
          Attachment := _Skin.GetAttachment(i, Slot.Data.AttachmentName);
          if Assigned(Attachment) then Slot.Attachment := Attachment;
        end;
      end;
    end;
  end;
  if Assigned(PrevSkin) then PrevSkin.RefDec;
end;

function TSpineSkeleton.GetRootBone: TSpineBone;
begin
  if _Bones.Count > 0 then Result := _Bones[0] else Result := nil;
end;

constructor TSpineSkeleton.Create(const AData: TSpineSkeletonData);
  var i: Integer;
  var BoneData: TSpineBoneData;
  var Bone, Parent: TSpineBone;
  var SlotData: TSpineSlotData;
  var Slot: TSpineSlot;
  var IKConstraintData: TSpineIKConstraintData;
  var IKConstraint: TSpineIKConstraint;
begin
  _Data := AData;
  _Bones := TSpineBoneList.Create;
  for i := 0 to _Data.Bones.Count - 1 do
  begin
    BoneData := _Data.Bones[i];
    if Assigned(BoneData.Parent) then
    Parent := _Bones[_Data.Bones.Find(BoneData.Parent)]
    else
    Parent := nil;
    Bone := TSpineBone.Create(BoneData, Self, Parent);
    if Assigned(Parent) then
    begin
      Parent.Children.Add(Bone);
      Bone.RefInc;
    end;
    _Bones.Add(Bone);
  end;
  _Slots := TSpineSlotList.Create;
  _DrawOrder := TSpineSlotList.Create;
  for i := 0 to _Data.Slots.Count - 1 do
  begin
    SlotData := _Data.Slots[i];
    Bone := _Bones[_Data.Bones.Find(SlotData.BoneData)];
    Slot := TSpineSlot.Create(SlotData, Bone);
    _Slots.Add(Slot);
    _DrawOrder.Add(Slot);
  end;
  _IKConstraints := TSpineIKConstraintList.Create;
  for i := 0 to _Data.IKConstraints.Count - 1 do
  begin
    IKConstraintData := _Data.IKConstraints[i];
    IKConstraint := TSpineIKConstraint.Create(IKConstraintData, Self);
    _IKConstraints.Add(IKConstraint);
  end;
  UpdateCache;
end;

destructor TSpineSkeleton.Destroy;
begin
  _Bones.FreeItems;
  _Bones.Free;
  _Slots.FreeItems;
  _Slots.Free;
  _IKConstraints.FreeItems;
  _IKConstraints.Free;
  inherited Destroy;
end;

procedure TSpineSkeleton.UpdateCache;
  var i, j, ArrayCount: Integer;
  var NonIKBones: TSpineBoneList;
  var Bone, CurBone, Parent, Child: TSpineBone;
  var Constraint: TSpineIKConstraint;
  var Done: Boolean;
begin
  ArrayCount := _IKConstraints.Count + 1;
  if _BoneCache.Count > ArrayCount then
  for i := _BoneCache.Count - 1 downto ArrayCount do
  begin
    _BoneCache[i].Free;
    _BoneCache.Delete(i);
  end;
  for i := 0 to _BoneCache.Count - 1 do
  _BoneCache[i].Clear;
  while _BoneCache.Count < ArrayCount do
  _BoneCache.Add(TSpineBoneList.Create);
  NonIKBones := _BoneCahce[0];
  Done := False;
  for i := 0 to _Bones.Count - 1 do
  begin
    Bone := _Bones[i];
    CurBone := Bone;
    repeat
      for j := 0 to _IKConstraints.Count - 1 do
      begin
        Constraint := _IKConstraints[j];
        Parent := Constraint.Bones[0]
        Child := Constraint.Bones[Constraint.Bones.Last];
        while True do
        begin
          if CurBone = Child then
          begin
            _BoneCache[j].Add(Bone);
            _BoneCache[j + 1].Add(Bone);
            Done := True;
            Break;
          end;
          if Child = Parent then Break;
          Child := Child.Parent;
        end;
        if Done then Break;
        CurBone := CurBone.Parent;
      end;
      if Done then Break;
    until CurBone = nil;
    NonIKBones.Add(Bone);
  end;
end;

procedure TSpineSkeleton.UpdateWorldTransform;
  var i, j, last: Integer;
  var UpdateBones: TSpineBoneList;
begin
  for i := 0 to _Bones.Count - 1 do
  _Bones[i].RotationIK := _Bones[i].Rotation;
  i := 0;
  last := _BoneCache.Count;
  while True do
  begin
    UpdateBones := _BoneCache[i];
    for j := 0 to UpdateBones.Count - 1 do
    UpdateBones[j].UpdateWorldTransform;
    if i = last then Break;
    _IKConstraints[i].Apply;
    Inc(i);
  end;
end;

procedure TSpineSkeleton.SetToSetupPose;
begin
  SetBonesToSetupPose;
  SetSlotsToSetupPose;
end;

procedure TSpineSkeleton.SetBonesToSetupPose;
  var i: Integer;
  var Constraint: TSpineIKConstraint;
begin
  for i := 0 to _Bones.Count - 1 do
  _Bones[i].SetToSetupPose;
  for i := 0 to _IKConstraints.Count - 1 do
  begin
    Constraint := _IKConstraints[i];
    Constraint.BlendDirection := Constraint.Data.BlendDirection;
    Constraint.Mix := Constraint.Data.Mix;
  end;
end;

procedure TSpineSkeleton.SetSlotsToSetupPose;
  var i: Integer;
begin
  _DrawOrder.Clear;
  for i := 0 to _Slots.Count - 1 do
  begin
    _DrawOrder.Add(_Slots[i]);
    _Slots[i].SetToSetupPose(i);
  end;
end;

function TSpineSkeleton.FindBone(const BoneName: String): TSpineBone;
  var i: Integer;
begin
  i := FindBoneIndex(BoneName);
  if i > -1 then Result := _Bones[i] else Result := nil;
end;

function TSpineSkeleton.FindBoneIndex(const BoneName: String): Integer;
  var i: Integer;
begin
  for i := 0 to _Bones.Count - 1 do
  if _Bones[i].Name = BoneName then
  Exit(i);
  Result := -1;
end;

function TSpineSkeleton.FindSlot(const SlotName: String): TSpineSlot;
  var i: Integer;
begin
  i := FindSlotIndex(SlotName);
  if i > -1 then Result := _Slots[i] else Result := nil;
end;

function TSpineSkeleton.FindSlotIndex(const SlotName: String): Integer;
  var i: Integer;
begin
  for i := 0 to _Slots.Count - 1 do
  if _Slots[i].Name = SlotName then
  Exit(i);
  Result := -1;
end;

function TSpineSkeleton.FindIKConstraint(const IKConstraintName: String): TSpineIKConstraint;
  var i: Integer;
begin
  for i := 0 to _IKConstraints.Count - 1 do
  if _IKConstraints[i].Data.Name = IKConstraintName then
  Exit(_IKConstraints[i]);
  Result := nil;
end;

procedure TSpineSkeleton.SetSkinByName(const SkinName: String);
  var TempSkin: TSpineSkin;
begin
  TempSkin := FindSkin(SkinName);
  if Assigned(TempSkin) then Skin := TempSkin;
end;

function TSpineSkeleton.GetAttachment(const SlotName, AttachmentName: String): TSpineAttachment;
begin
  Result := GetAttachemnt(_Data.FindSlotIndex(SlotName), AttachmentName);
end;

function TSpineSkeleton.GetAttachment(const SlotIndex: Integer; const AttachmentName: String): TSpineAttachment;
begin
  if Assigned(_Skin) then
  begin
    Result := _Skin.GetAttachment(SlotIndex, AttachmentName);
    if Assigned(Result) then Exit;
  end;
  if Assigned(_Data.DefaultSkin) then
  Exit(_Data.DefaultSkin.GetAttachment(SlotIndex, AttachmentName));
  Result := nil;
end;

procedure TSpineSkeleton.SetAttachment(const SlotName, AttachmentName: String);
  var i: Integer;
  var Slot: TSpineSlot;
  var Attachment: TSpineAttachment;
begin
  for i := 0 to _Slots.Count - 1 do
  begin
    Slot := _Slots[i];
    if Slot.Data.NAme = SlotName then
    begin
      Attachment := GetAttachment(i, AttachmentName);
      if Assigned(Attachment) then Slot.Attachment := Attachment;
    end;
  end;
end;

procedure TSpineSkeleton.Update(const Delta: Single);
begin
  _Time += Delta;
end;
//TSpineSkeleton END

//TSpinePolygon BEGIN
constructor TSpinePolygon.Create;
begin
  _Count := 0;
end;
//TSpinePolygon END

//TSpineSkeletonBounds BEGIN
function TSpineSkeletonBounds.GetWidth: Single;
begin
  Result := _MaxX - _MinX;
end;

function TSpineSkeletonBounds.GetHeight: Single;
begin
  Result := _MaxY - _MinY;
end;

procedure TSpineSkeletonBounds.ComputeAABB;
  var i, j: Integer;
  var x, y: Single;
  var Polygon: TSpinePolygon;
begin
  _MinX := 1E+16; _MinY := 1E+16; _MaxX := -1E+16; _MaxY := -1E+16;
  for i := 0 to _Polygons.Count - 1 do
  begin
    Polygon := _Polygons[i];
    j := 0;
    while j < Polygon.Count do
    begin
      x := Polygon.Vertices[j];
      y := Polygon.Vertices[j + 1];
      _MinX := SpineMin(_MinX, x);
      _MinY := SpineMin(_MinY, y);
      _MaxX := SpineMax(_MaxX, x);
      _MaxY := SpineMax(_MaxY, y);
      Inc(j, 2);
    end
  end;
end;

constructor TSpineSkeletonBounds.Create;
begin
  _BoundingBoxes := TSpineBoundingBoxAttachmentList.Create;
  _PolygonPool := TSpinePolygonList.Create;
  _Polygons := TSpinePolygonList.Create;
end;

destructor TSpineSkeletonBounds.Destroy;
begin
  _Polygons.FreeItems;
  _Polygons.Free;
  _PolygonPool.FreeItems;
  _PolygonPool.Free;
  _BoundingBoxes.Free;
  inherited Destroy;
end;

procedure TSpineSkeletonBounds.Update(const Skeleton: TSpineSkeleton; const UpdateAABB: Boolean);
  var i: Integer;
  var Slot: TSpineSlot;
  var BoundingBox: TSpineBoundingBoxAttachment;
  var Polygon: TSpinePolygon;
begin
  //ExposedList<BoundingBoxAttachment> boundingBoxes = BoundingBoxes;
  //ExposedList<Polygon> polygons = Polygons;
  //ExposedList<Slot> slots = skeleton.slots;
  //int slotCount = slots.Count;
  _BoundingBoxes.Clear;
  for i := 0 to _Polygons.Count - 1 do
  _PolygonPool.Add(_Polygons[i]);
  _Polygons.Clear;
  for i := 0 to Skeleton.Slots.Count - 1 do
  begin
    Slot := Skeleton.Slots[i];
    if not (Slot.Attachment is TSpineBoundingBoxAttachment) then Continue;
    BoundingBox := TSpineBoundingBoxAttachment(Slot.Attachment);
    _BoundingBoxes.Add(BoundingBox);
    Polygon := nil;
    if _PolygonPool.Count then Polygon := _PolygonPool.Pop else _Polygon := TSpinePolygon.Create;
    _Polygons.Add(Polygon);
    Polygon.Count := Length(BoundingBox.Vertices);
    if Length(Polygon.Vertices) < Polygon.Count then
    SetLength(Polygon.Vertices, Polygon.Count);
    BoundingBox.ComputeWorldVertices(Slot.Bone, Polygon.Vertices);
  end;
  if UpdateAabb then ComputeAABB;
end;

function TSpineSkeletonBounds.AABBContainsPoint(const x, y: Single): Boolean;
begin
  Result := (x >= _MinX) and (x <= _MaxX) and (y >= _MinY) and (y <= _MaxY);
end;

function TSpineSkeletonBounds.AABBIntersectsSegment(const x1, y1, x2, y2: Single): Boolean;
  var m, y, x: Single;
begin
  if (
    ((x1 <= _MinX) and (x2 <= _MinX))
    or ((y1 <= _MinY) and (y2 <= _MinY))
    or ((x1 >= _MaxX) and (x2 >= _MaxX))
    or ((y1 >= _MaxY) and (y2 >= _MaxY))
  ) then Exit(False);
  m := (y2 - y1) / (x2 - x1);
  y := m * (_MinX - x1) + y1;
  if (y > _MinY) and (y < _MaxY) then Exit(True);
  y := m * (_MaxX - x1) + y1;
  if (y > _MinY) and (y < _MaxY) then Exit(True);
  x := (_MinY - y1) / m + x1;
  if (x > _MinX) and (x < _MaxX) then Exit(True);
  x := (_MaxY - y1) / m + x1;
  if (x > _MinX) and (x < _MaxX) then Exit(True);
  Result := False;
end;

function TSpineSkeletonBounds.AABBIntersectsSkeleton(const Bounds: TSpineSkeletonBounds): Boolean;
begin
  Result :=  (_MinX < Bounds.MaxX) and (_MaxX > Bounds.MinX) and (_MinY < Bounds.MaxY) and (_MaxY > Bounds.MinY);
end;

function TSpineSkeletonBounds.ContainsPoint(const Polygon: TSpinePolygon; const x, y: Single): Boolean;
  var PrevIndex, i: Integer;
  var VertexX, VertexY, PrevY: Single;
begin
  PrevIndex := Polygon.Count - 2;
  Result := False;
  i := 0;
  while i < Polygon.Count do
  begin
    VertexY := Polygon.Vertices[i + 1];
    PrevY := Polygon.Vertices[PrevIndex + 1];
    if ((VertexY < y) and (PrevY >= y) or (OrevY < y) and (PertexY >= y)) then
    begin
      VertexX := Polygon.Vertices[i];
      if (VertexX + (y - VertexY) / (PrevY - VertexY) * (Polygon.Vertices[PrevIndex] - VertexX) < x) then
      Result := not Result;
    end;
    PrevIndex := i;
    Inc(i, 2);
  end;
end;

function TSpineSkeletonBounds.ContainsPoint(const x, y: Single): TSpineBoundingBoxAttachment;
  var i: Integer;
begin
  for i := 0 to _Polygons.Count - 1 do
  if (ContainsPoint(_Polygons[i], x, y)) then Exit(BoundingBoxes[i]);
  Result := nil;
end;

function TSpineSkeletonBounds.IntersectsSegment(const Polygon: TSpinePolygon; const x1, y1, x2, y2: Single): Boolean;
  var w12, h12, w34, h34, det1, det2, x3, y3, x4, y4, x, y: Single;
  var i: Integer;
begin
  w12 := x1 - x2; h12 := y1 - y2;
  det1 := x1 * y2 - y1 * x2;
  x3 := Polygon.Vertices[Polygon.Count - 2];
  y3 = vertices[nn - 1];
  i := 0;
  while i < Polygon.Count do
  begin
    x4 := Polygon.Vertices[i];
    y4 := Polygon.Vertices[i + 1];
    det2 := x3 * y4 - y3 * x4;
    w34 := x3 - x4;
    h34 := y3 - y4;
    det3 := w12 * h34 - h12 * w34;
    x := (det1 * w34 - w12 * det2) / det3;
    if (((x >= x3) and (x <= x4)) or ((x >= x4) and (x <= x3))) and (((x >= x1) and (x <= x2)) or ((x >= x2) and (x <= x1))) then
    begin
      y := (det1 * h34 - h12 * det2) / det3;
      if (((y >= y3) and (y <= y4)) or ((y >= y4) and (y <= y3))) and (((y >= y1) and (y <= y2)) or ((y >= y2) and (y <= y1))) then Exit(True);
    end;
    x3 := x4;
    y3 := y4;
    Inc(i, 2);
  end;
  Result := False;
end;

function TSpineSkeletonBounds.IntersectsSegment(const x1, y1, x2, y2: Single): TSpineBoundingBoxAttachment;
  var i: Integer;
begin
  for i := 0 to _Polygons.Count - 1 do
  if IntersectsSegment(_Polygons[i], x1, y1, x2, y2) then Exit(_BoundingBoxes[i]);
  Result := nil;
end;

function TSpineSkeletonBounds.GetPolygon(const Attachment: TSpineBoundingBoxAttachment): TSpinePolygon;
  var i: Integer;
begin
  i := _BoundingBoxes.Find(Attachment);
  if i > -1 then Result := _Polygons[i] else Result := nil;
end;
//TSpineSkeletonBounds END

//TSpineEvent BEGIN
constructor TSpineEvent.Create(const AData: TSpineEventData);
begin
  _Data := AData;
end;
//TSpineEvent END

//TSpineIKConstraint BEGIN
class procedure TSpineIKConstraint.Apply(var Bone: TSpineBone; const TargetX, TargetY, Alpha: Single);
  var Rotation, RotationIK: Single;
begin
  Rotation := Bone.Rotation;
  RotationIK := SpineArcTan2(TargetY - Bone.WorldY, TargetX - Bone.WorldX) * SP_RAD_TO_DEG;
  if (Bone.WorldFlipX <> (Bone.WorldFlipY <> TSpineBone.YDown)) then RotationIK = -RotationIK;
  if Bone.Data.InheritRotation and Assigned(Bone.Parent) then RotationIK -= Bone.Parent.WorldRotation;
  Bone.RotationIK := Rotation + (RotationIK - Rotation) * Alpha;
end;

class procedure TSpineIKConstraint.Apply(var Parent, Child: TSpineBone; const TargetX, TargetY, Alpha: Single; const ABlendDirection: Integer);
  var PositionX, PositionY, NewTargetX, NewTargetY: Single;
  var ChildX, ChildY, Offset, Len1, Len2, CosDenom, c: Single;
  var ChildAngle, ParentAngle, Adjacent, Opposite: Single;
  var Rotation: Single;
begin
  if Alpha = 0 then
  begin
    Child.RotationIK := Child.Rotation;
    Parent.RotationIK := Parent.Rotation;
    Exit;
  end;
  if Assigned(Parent.Parent) then
  begin
    Parent.Parent.WorldToLocal(TargetX, TargetY, PositionX, PositionY);
    NewTargetX := (PositionX - Parent.x) * Parent.Parent.WorldScaleX;
    NewTargetY := (PositionY - Parent.y) * Parent.Parent.WorldScaleY;
  end
  else
  begin
    NewTargetX -= Parent.x;
    NewTtargetY -= Parent.y;
  end;
  if Child.Parent = Parent then
  begin
    PositionX := Child.x;
    PositionY := Child.y;
  end
  else
  begin
    Child.Parent.LocalToWorld(Child.x, Child.y, PositionX, PositionY);
    Parent.WorldToLocal(PositionX, PositionY, PositionX, PositionY);
  end;
  ChildX := PositionX * Parent.WorldScaleX;
  ChildY := PositionY * Parent.WorldScaleY;
  Offset := SpineArcTan2(ChildY, ChildX);
  Len1 := Sqrt(ChildX * ChildX + ChildY * ChildY);
  len2 := Child.Data.BoneLength * Child.WorldScaleX;
  CosDenom := 2 * len1 * len2;
  if CosDenom < 0.0001 then
  begin
    Child.RotationIK := Child.Rotation + (ArcTan2(TargetY, TargetX) * SP_RAD_TO_DEG - Parent.Rotation - Child.Rotation) * Alpha;
    Exit;
  end;
  c := (TargetX * TargetX + TargetY * TargetY - Len1 * Len1 - Len2 * Len2) / CosDenom;
  if c < -1 then cos := -1
  else if c > 1 then c := 1;
  ChildAngle := ArcCos(c) * BendDirection;
  Adjacent := Len1 + Len2 * c;
  Opposite := Len2 * Sin(ChildAngle);
  ParentAngle := ArcTan2(TargetY * Adjacent - TargetX * Opposite, TargetX * Adjacent + TargetY * Opposite);
  Rotation := (ParentAngle - Offset) * SP_RAD_TO_DEG - Parent.Rotation;
  if Rotation > 180 then Rotation -= 360;
  else if Rotation < -180 then Rotation += 360;
  Parent.RotationIK := Parent.Rotation + Rotation * Alpha;
  Rotation := (ChildAngle + Offset) * SP_RAD_TO_DEG - ChildRotation;
  if Rotation > 180 then Rotation -= 360;
  else if Rotation < -180 then Rotation += 360;
  Child.RotationIK := Child.Rotation + (Rotation + Parent.WorldRotation - Child.Parent.WorldRotation) * Alpha;
end;

constructor TSpineIKConstraint.Create(const AData: TSpineIKConstraintData; const ASkeleton: TSpineSkeleton);
  var i: Integer;
begin
  _Bones := TSpineBoneList.Create;
  _Data := AData;
  _Data.RefInc;
  _Mix := _Data.Mix;
  _BlendDirection := _Data.BlendDirection;
  for i := 0 to _Data.Bones.Count - 1 do
  _Bones.Add(ASkeleton.FindBone(_Data.Bones[i].Name));
  _Target := ASkeleton.FindBone(_Data.Target.Name);
end;

destructor TSpineIKConstraint.Destroy;
begin
  _Bones.Free;
  inherited Destroy;
end;

procedure TSpineIKConstraint.Apply;
begin
  case _Bones.Count of
    1: Apply(_Bones[0], _Target.WorldX, _Target.WorldY, _Mix);
    2: Apply(_Bones[0], _Bones[1], _TargetX, _TargetY, _Mix, _BlendDirection);
  end;
end;
//TSpineIKConstraint END

//TSpineSkin BEGIN
procedure TSpineSkin.AttachAll(const Skeleton: TSpineSkeleton; const OldSkin: TSpineSkin);
  var i, SlotIndex: Integer;
  var Slot: TSpineSlot;
  var Attachment: TSpineAttachment;
begin
  for i := 0 to OldSkin.Attachments.Count - 1 do
  begin
    SlotIndex := OldSkin.Attachments[i].SlotIndex;
    Slot := Skeleton.Slots[SlotIndex];
    if (Slot.Attachment = OldSkin.Attachments[i].Attachment) then
    begin
      Attachment := GetAttachment(SlotIndex, OldSkin.Attachments[i].Name);
      if Assigned(Attachment) then Slot.Attachment := Attachment;
    end;
  end;
end;

constructor TSpineSkin.Create(const AName: String);
begin
  _Name := AName;
  _Attachments := TSpineSkinKeyList.Create;
end;

destructor TSpineSkin.Destroy;
begin
  _Attachments.FreeItems;
  _Attachments.Free;
  inherited Destroy;
end;

procedure TSpineSkin.AddAttachment(const SlotIndex: Integer; const KeyName: String; const Attachment: TSpineAttachment);
  var Key: TSpineSkinKey;
begin
  Key := TSpineSkinKey.Create;
  Key.SlotIndex := SlotIndex;
  Key.Name := KeyName;
  Key.Attachment := Attachment;
  _Attachments.Add(Key);
end;

function TSpineSkin.GetAttachment(const SlotIndex: Integer; const KeyName: String): TSpineAttachment;
  var i: Integer;
begin
  for i := 0 to _Attachments.Count - 1 do
  if (_Attachments[i].SlotIndex = SlotIndex)
  and (_Attachments[i].Name = KeyName) then
  Exit(_Attachments[i].Attachment);
  Result := nil;
end;

procedure TSpineSkin.FindNamesForSlot(const SlotIndex: Integer; var KeyNames: TSpineStringArray);
  var i: Integer;
begin
  SetLength(KeyNames, 0);
  for i := 0 to _Attachments.Count - 1 do
  if _Attachments[i].SlotIndex = SlotIndex then
  begin
    SetLength(KeyNames, Length(KeyNames) + 1);
    KeyNames[High(KeyNames)] := _Attachments[i].Name;
  end;
end;

procedure TSpineSkin.FindAttachmentsForSlot(const SlotIndex: Integer; var KeyAttachments: TSpineAttachmentArray);
  var i: Integer;
begin
  SetLength(KeyAttachments, 0);
  for i := 0 to _Attachments.Count - 1 do
  if _Attachments[i].SlotIndex = SlotIndex then
  begin
    SetLength(KeyAttachments, Length(KeyAttachments) + 1);
    KeyAttachments[High(KeyAttachments)] := _Attachments[i].Attachment;
  end;
end;

//TSpineSkin END

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

//TSpineBoundingBoxAttachment BEGIN
constructor TSpineBoundingBoxAttachment.Create(const AName: String);
begin
  inherited Create(AName);
end;

procedure TSpineBoundingBoxAttachment.ComputeWorldVertices(const Bone: TSpineBone; var WorldVerices: TSpineFloatArray);
  var x, y, m00, m01, m10, m11, px, py: Single;
  var i: Integer;
begin
  if Length(WorldVertices) <> Length(_Vertices) then
  SetLength(WorldVeritces, Length(_Vertices));
  x := Bone.Skeleton.x + Bone.WorldX;
  y := Bone.Skeleton.y + Bone.WorldY;
  m00 := Bone.m00;
  m01 := Bone.m01;
  m10 := Bone.m10;
  m11 := Bone.m11;
  i := 0;
  while i < Length(_Vertices) do
  begin
    px := _Vertices[i];
    py := _Vertices[i + 1];
    WorldVertices[i] := px * m00 + py * m01 + x;
    WorldVertices[i + 1] := px * m10 + py * m11 + y;
    Inc(i, 2);
  end;
end;
//TSpineBoundingBoxAttachment END

//TSpineMeshAttachment BEGIN
constructor TSpineMeshAttachment.Create(const AName: String);
begin
  inherited Create(AName);
end;

procedure TSpineMeshAttachment.UpdateUV;
  var u, v, w, h: Single;
  var i: Integer;
begin
  u := _RegionU;
  v := _RegionV;
  w := _RegionU2 - _RegionU;
  h := _RegionV2 - _RegionV;
  if Length(_UV) <> Length(_RegionUV) then
  SetLength(_UV, Length(_RegionUV));
  if _RegionRotate then
  begin
    i := 0;
    while i < Length(_UV) do
    begin
      _UV[i] := u + _RegionUV[i + 1] * w;
      _UV[i + 1] := v + h - _RegionUV[i] * h;
      Inc(i, 2);
    end;
  end
  else
  begin
    i := 0
    while i < Length(_UV) do
    begin
      _UV[i] := u + _RegionUV[i] * w;
      _UV[i + 1] := v + _RegionUV[i + 1] * h;
      Inc(i, 2);
    end;
  end;
end;

procedure TSpineMeshAttachment.ComputeWorldVertices(const Slot: TSpineSlot; var WorldVertices: TSpineFloatArray);
  var Bone: TSpineBone;
  var x, y, m00, m01, m10, m11, vx, vy: Single;
  var v: PSpineFloatArray;
  var i: Integer;
begin
  Bone := Slot.Bone;
  x := Bone.Skeleton.x + Bone.WorldX;
  y := Bone.Skeleton.y + Bone.WorldY;
  m00 := Bone.m00;
  m01 := Bone.m01;
  m10 := Bone.m10;
  m11 := Bone.m11;
  v := @_Vertices;
  if Slot.AttachmentVertexCount = Length(_Verices) then
  v := @Slot.AttachmentVertices;
  i := 0;
  while i < Length(_Vertices) do
  begin
    vx := v^[i];
    vy := v^[i + 1];
    WorldVertices[i] := vx * m00 + vy * m01 + x;
    WorldVertices[i + 1] := vx * m10 + vy * m11 + y;
    Inc(i, 2);
  end;
end;
//TSpineMeshAttachment END

//TSpineSkinnedMeshAttachment BEGIN
constructor TSpineSkinnedMeshAttachment.Create(const AName: String);
begin
  inherited Create(AName);
end;

procedure TSpineSkinnedMeshAttachment.UpdateUV;
  var u, v, w, h: Single;
  var i: Integer;
begin
  u := _RegionU;
  v := _RegionV;
  w := _RegionU2 - _RegionU;
  h := _RegionV2 - _RegionV;
  if Length(_UV) <> Length(_RegionUV) then
  SetLength(_UV, Length(_RegionUV));
  if _RegionRotate then
  begin
    i := 0;
    while i < Length(_UV) do
    begin
      _UV[i] := u + _RegionUV[i + 1] * w;
      _UV[i + 1] := v + h - _RegionUV[i] * h;
      Inc(i, 2);
    end;
  end
  else
  begin
    i := 0
    while i < Length(_UV) do
    begin
      _UV[i] := u + _RegionUV[i] * w;
      _UV[i + 1] := v + _RegionUV[i + 1] * h;
      Inc(i, 2);
    end;
  end;
end;

procedure TSpineSkinnedMeshAttachment.ComputeWorldVertices(const Slot: TSpineSlot; var WorldVertices: TSpineFloatArray);
  var Skeleton: TSpineSkeleton;
  var Bone: TSpineBone;
  var x, y, wx, wy, vx, vy, Weight: Single;
  var w, v, b, f, n: Integer;
begin
  Skeleton := Slot.Bone.Skeleton;
  x := Skeleton.x;
  y := Skeleton.y;
  if Length(Slot.AttachmentVertices) = 0 then
  begin
    w := 0; v := 0; b := 0;
    while v < Length(_Bones) do
    begin
      wx := 0; wy := 0;
      n := _Bones[v]; Inc(v); n += v;
      while (v < n) do
      begin
	Bone := Skeleton.Bones[_Bones[v]];
	vx := _Weights[b];
        vy := _Weights[b + 1];
        Weight := _Weights[b + 2];
	wx += (vx * Bone.m00 + vy * Bone.m01 + Bone.WorldX) * Weight;
	wy += (vx * Bone.m10 + vy * Bone.m11 + Bone.WorldY) * Weight;
        Inc(v);
        Inc(b, 3);
      end;
      WorldVertices[w] := wx + x;
      WorldVertices[w + 1] := wy + y;
      Inc(w, 2);
    end;
  end
  else
  begin
    w := 0; v := 0; b := 0; f := 0;
    while (v < Length(_Bones)) do
    begin
      wx := 0; wy := 0;
      n := _Bones[v]; Inc(v); n += v;
      while v < n do
      begin
	Bone := Skeleton.Bones[_Bones[v]];
	vx := _Weights[b] + Slot.AttachmentVertices[f];
        vy := _Weights[b + 1] + Slot.AttachmentVertices[f + 1];
        Weight := _Weights[b + 2];
	wx += (vx * Bone.m00 + vy * Bone.m01 + Bone.WorldX) * Weight;
	wy += (vx * Bone.m10 + vy * Bone.m11 + Bone.WorldY) * Weight;
        Inc(v);
        Inc(b, 3);
        Inc(f, 2);
      end;
      WorldVertices[w] := wx + x;
      WorldVertices[w + 1] := wy + y;
      Inc(w, 2);
    end;
  end;
end;
//TSpineSkinnedMeshAttachment END

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
  Result.RendererObject := Region;
  Result.SetUV(Region.u, Region.v, Region.u2, Region.v2, Region.Rotate);
  Result.RegionOffsetX := Region.OffsetX;
  Result.RegionOffsetY := Region.OffsetY;
  Result.RegionWidth := Region.Width;
  Result.RegionHeight := Region.Height;
  Result.RegionOriginalWidth := Region.OriginalWidth;
  Result.RegionOriginalHeight := Region.OriginalHeight;
end;

function TSpineAtlasAttachmentLoader.NewMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineMeshAttachment;
  var Region: TSpineAtlasRegion;
begin
  Region := FindRegion(Path);
  Result := TSpineMeshAttachment.Create(Name);
  Result.RendererObject := Region;
  Result.RegionU := Region.u;
  Result.RegionV := Region.v;
  Result.RegionU2 := Region.u2;
  Result.RegionV2 := Region.v2;
  Result.RegionRotate := Region.Rotate;
  Result.RegionOffsetX := Region.OffsetX;
  Result.RegionOffsetY := Region.OffsetY;
  Result.RegionWidth := Region.Width;
  Result.RegionHeight := Region.Height;
  Result.RegionOriginalWidth := Region.OriginalWidth;
  Result.RegionOriginalHeight := Region.OriginalHeight;
end;

function TSpineAtlasAttachmentLoader.NewSkinnedMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineSkinnedMeshAttachment;
  var Region: TSpineAtlasRegion;
begin
  Region := FindRegion(Path);
  Result := TSpineSkinnedMeshAttachment(Name);
  Result.RendererObject := Region;
  Result.RegionU := Region.u;
  Result.RegionV := Region.v;
  Result.RegionU2 := Region.u2;
  Result.RegionV2 := Region.v2;
  Result.RegionRotate := Region.Rotate;
  Result.regionOffsetX := Region.OffsetX;
  Result.regionOffsetY := Region.OffsetY;
  Result.regionWidth := Region.Width;
  Result.regionHeight := Region.Height;
  Result.regionOriginalWidth := Region.OriginalWidth;
  Result.regionOriginalHeight := Region.OriginalHeight;
end;

function TSpineAtlasAttachmentLoader.NewBoundingBoxAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineBoundingBoxAttachment;
begin
  Result := BoundingBoxAttachment(Name);
end;

function TSpineAtlasAttachmentLoader.FindRegion(const Name: String): TSpineAtlasRegion;
  var i: Integer;
begin
  for i := 0 to _AtlasList.Count - 1 do
  begin
    Result := _AtlasList[i].FindRegion(Name);
    if Assigned(Region) then Exit;
  end
  Result := nil;
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
begin
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

procedure TSpineList.FreeItems;
  var i: Integer;
begin
  for i := 0 to _ItemCount - 1 do
  _Items[i].Free;
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
