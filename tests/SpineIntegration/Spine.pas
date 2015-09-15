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
    class var ClassInstances: TSpineClass;
    var NextInstance: TSpineClass;
    var PrevInstance: TSpineClass;
    var _Ref: Integer;
  public
    class constructor CreateClass;
    class procedure Report(const FileName: String);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure RefInc;
    procedure RefDec;
    procedure Free; reintroduce;
  end;

  generic TSpineList<T> = class (TSpineClass)
  public
    type TItemPtr = ^T;
  private
    var _Items: array of T;
    var _ItemCount: Integer;
    procedure SetItem(const Index: Integer; const Value: T); inline;
    function GetItem(const Index: Integer): T; inline;
    procedure SetCapacity(const Value: Integer); inline;
    function GetCapacity: Integer; inline;
    function GetFirst: T; inline;
    function GetLast: T; inline;
    function GetData: TItemPtr; inline;
    function GetItemPtr(const Index: Integer): TItemPtr; inline;
  public
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read _ItemCount;
    property Items[const Index: Integer]: T read GetItem write SetItem; default;
    property ItemPtr[const Index: Integer]: TItemPtr read GetItemPtr;
    property First: T read GetFirst;
    property Last: T read GetLast;
    property Data: TItemPtr read GetData;
    constructor Create;
    destructor Destroy; override;
    function Find(const Item: T): Integer;
    function Add(const Item: T): Integer;
    function Insert(const Index: Integer; const Item: T): Integer;
    procedure Delete(const Index: Integer; const ItemCount: Integer = 1);
    procedure Remove(const Item: T);
    procedure FreeItems;
    procedure Clear;
  end;

  TSpineVertexData = packed record
    x, y, u, v, r, g, b, a: Single;
  end;
  PSpineVertexData = ^TSpineVertexData;
  TSpineVertexArray = array[Word] of TSpineVertexData;
  PSpineVertexArray = ^TSpineVertexArray;

  TSpineTexture = class (TSpineClass)
  public
    function GetWidth: Integer; virtual; abstract;
    function GetHeight: Integer; virtual; abstract;
  end;

  TSpineRender = class (TSpineClass)
  public
    procedure RenderQuad(const Texture: TSpineTexture; const Vertices: PSpineVertexArray); virtual; abstract;
    procedure RenderPoly(const Texture: TSpineTexture; const Vertices: PSpineVertexArray; const Triangles: PIntegerArray; const TriangleCount: Integer); virtual; abstract;
  end;

  TSpineDataProvider = class (TSpineClass)
  private
    var _Data: PByteArray;
    var _Size: Integer;
    var _Pos: Integer;
  protected
    procedure Allocate(const DataSize: Integer);
  public
    property Data: PByteArray read _Data;
    property Size: Integer read _Size;
    property Pos: Integer read _Pos write _Pos;
    constructor Create(const DataSize: Integer);
    destructor Destroy; override;
    procedure Read(const Buffer: Pointer; const Count: Integer);
    function ReadByte: Byte; inline;
    class function FetchData(const DataName: String): TSpineDataProvider; virtual;
    class function FetchTexture(const TextureName: String): TSpineTexture; virtual;
  end;
  CSpineDataProvider = class of TSpineDataProvider;

  TSpineStringArray = array of String;
  TSpineFloatArray = array of Single;
  TSpineFloatTable = array of array of Single;
  TSpineIntArray = array of Integer;
  TSpineIntTable = array of array of Integer;
  TSpineAttachmentArray = array of TSpineAttachment;
  TSpineEventArray = array of TSpineEvent;
  TSpineRegionVertices = array[0..7] of Single;
  PSpineFloatArray = ^TSpineFloatArray;
  PSpineIntArray = ^TSpineIntArray;

  TSpineBoneDataList = specialize TSpineList<TSpineBoneData>;
  TSpineSlotDataList = specialize TSpineList<TSpineSlotData>;
  TSpineEventDataList = specialize TSpineList<TSpineEventData>;
  TSpineIKConstraintDataList = specialize TSpineList<TSpineIKConstraintData>;
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
  TSpineEventList = specialize TSpineList<TSpineEvent>;

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
    var _IKConstraints: TSpineIKConstraintDataList;
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
    property DefaultSkin: TSpineSkin read _DefaultSkin write _DefaultSkin;
    property Events: TSpineEventDataList read _Events;
    property Animations: TSpineAnimationList read _Animations;
    property IKConstraints: TSpineIKConstraintDataList read _IKConstraints;
    property Width: Single read _Width write _Width;
    property Height: Single read _Height write _Height;
    property Version: String read _Version write _Version;
    property Hash: String read _Hash write _Hash;
    property ImagePath: String read _ImagePath write _ImagePath;
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
    var _FloatValue: Single;
    var _StringValue: String;
  public
    property Name: String read _Name;
    property IntValue: Integer read _IntValue write _IntValue;
    property FloatValue: Single read _FloatValue write _FloatValue;
    property StringValue: String read _StringValue write _StringValue;
    constructor Create(const AName: String);
  end;

  TSpineIKConstraintData = class (TSpineClass)
  private
    var _Name: String;
    var _Bones: TSpineBoneDataList;
    var _Target: TSpineBoneData;
    var _BendDirection: Integer;
    var _Mix: Single;
  public
    property Name: String read _Name;
    property Bones: TSpineBoneDataList read _Bones;
    property Target: TSpineBoneData read _Target write _Target;
    property BendDirection: Integer read _BendDirection write _BendDirection;
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
    class constructor CreateClass;
    constructor Create(const AData: TSpineBoneData; const ASkeleton: TSpineSkeleton; const AParent: TSpineBone);
    destructor Destroy; override;
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
    var _AttachmentVertexCount: Integer;
    function GetAttachmentVerticesPtr: PSpineFloatArray; inline;
    function GetSkeleton: TSpineSkeleton; inline;
    procedure SetAttachment(const Value: TSpineAttachment); inline;
    function GetAttachmentTime: Single; inline;
    procedure SetAttachmentTime(const Value: Single); inline;
  public
    property Data: TSpineSlotData read _Data;
    property Bone: TSpineBone read _Bone;
    property Skeleton: TSpineSkeleton read GetSkeleton;
    property r: Single read _r write _r;
    property g: Single read _g write _g;
    property b: Single read _b write _b;
    property a: Single read _a write _a;
    property AttachmentVertices: TSpineFloatArray read _AttachmentVertices write _AttachmentVertices;
    property AttachmentVerticesPtr: PSpineFloatArray read GetAttachmentVerticesPtr;
    property AttachmentVertexCount: Integer read _AttachmentVertexCount write _AttachmentVertexCount;
    property Attachment: TSpineAttachment read _Attachment write SetAttachment;
    property AttachmentTime: Single read GetAttachmentTime write SetAttachmentTime;
    constructor Create(const AData: TSpineSlotData; const ABone: TSpineBone);
    destructor Destroy; override;
    procedure SetToSetupPose(const SlotIndex: Integer); overload;
    procedure SetToSetupPose; overload;
  end;

  TSpineBoneCacheList = specialize TSpineList<TSpineBoneList>;

  TSpineSkeleton = class (TSpineClass)
  private
    var _Data: TSpineSkeletonData;
    var _Bones: TSpineBoneList;
    var _Slots: TSpineSlotlist;
    var _DrawOrder: TSpineSlotList;
    var _IKConstraints: TSpineIKConstraintList;
    var _BoneCache: TSpineBoneCacheList;
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
    var _ScaleX: Single;
    var _ScaleY: Single;
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
    property ScaleX: Single read _ScaleX write _ScaleX;
    property ScaleY: Single read _ScaleY write _ScaleY;
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
    procedure Draw(const Render: TSpineRender);
  end;

  TSpinePolygon = class (TSpineClass)
  private
    var _Vertices: TSpineFloatArray;
    var _Count: Integer;
    function GetVerticesPtr: PSpineFloatArray; inline;
  public
    property Vertices: TSpineFloatArray read _Vertices write _Vertices;
    property VerticesPtr: PSpineFloatArray read GetVerticesPtr;
    property Count: Integer read _Count write _Count;
    constructor Create;
  end;

  TSpineAnimationTimeline = class (TSpineClass)
  public
    procedure Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single); virtual; abstract;
  end;

  TSpineAnimationCurveTimeline = class (TSpineAnimationTimeline)
  protected
    const LINEAR: Single = 0;
    const STEPPED: Single = 1;
    const BEZIER: Single = 2;
    const BEZIER_SEGMENTS = 10;
    const BEZIER_SIZE = BEZIER_SEGMENTS * 2 - 1;
  private
    var _Curves: TSpineFloatArray;
    function GetFrameCount: Integer; inline;
  public
    property FrameCount: Integer read GetFrameCount;
    constructor Create(const AFrameCount: Integer); virtual;
    procedure SetLinear(const FrameIndex: Integer); inline;
    procedure SetStepped(const FrameIndex: Integer); inline;
    procedure SetCurve(const FrameIndex: Integer; const cx1, cy1, cx2, cy2: Single);
    function GetCurvePercent(const FrameIndex: Integer; const Percent: Single): Single;
  end;

  TSpineAnimationRotateTimeline = class (TSpineAnimationCurveTimeline)
  protected
    const PREV_FRAME_TIME = -2;
    const FRAME_VALUE = 1;
  private
    var _BoneIndex: Integer;
    var _Frames: TSpineFloatArray;
  public
    property BoneIndex: Integer read _BoneIndex write _BoneIndex;
    property Frames: TSpineFloatArray read _Frames write _Frames;
    constructor Create(const AFrameCount: Integer); override;
    procedure SetFrame(const FrameIndex: Integer; const Time, Angle: Single);
    procedure Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single); override;
  end;

  TSpineAnimationTranslateTimeline = class (TSpineAnimationCurveTimeline)
  protected
    const PREV_FRAME_TIME = -3;
    const FRAME_X = 1;
    const FRAME_Y = 2;
  private
    var _BoneIndex: Integer;
    var _Frames: TSpineFloatArray;
  public
    property BoneIndex: Integer read _BoneIndex write _BoneIndex;
    property Frames: TSpineFloatArray read _Frames write _Frames;
    constructor Create(const AFrameCount: Integer); override;
    procedure SetFrame(const FrameIndex: Integer; const Time, x, y: Single);
    procedure Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single); override;
  end;

  TSpineAnimationScaleTimeline = class (TSpineAnimationTranslateTimeline)
  public
    constructor Create(const AFrameCount: Integer); override;
    procedure Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single); override;
  end;

  TSpineAnimationColorTimeline = class (TSpineAnimationCurveTimeline)
  protected
    const PREV_FRAME_TIME = -5;
    const FRAME_R = 1;
    const FRAME_G = 2;
    const FRAME_B = 3;
    const FRAME_A = 4;
  private
    var _SlotIndex: Integer;
    var _Frames: TSpineFloatArray;
  public
    property SlotIndex: Integer read _SlotIndex write _SlotIndex;
    property Frames: TSpineFloatArray read _Frames write _Frames;
    constructor Create(const AFrameCount: Integer); override;
    procedure SetFrame(const FrameIndex: Integer; const Time, r, g, b, a: Single);
    procedure Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single); override;
  end;

  TSpineAnimationAttachmentTimeline = class (TSpineAnimationTimeline)
  private
    var _SlotIndex: Integer;
    var _Frames: TSpineFloatArray;
    var _AttachmentNames: TSpineStringArray;
    function GetFrameCount: Integer; inline;
  public
    property SlotIndex: Integer read _SlotIndex write _SlotIndex;
    property Frames: TSpineFloatArray read _Frames write _Frames;
    property AttachmentNames: TSpineStringArray read _AttachmentNames write _AttachmentNames;
    property FrameCount: Integer read GetFrameCount;
    constructor Create(const AFrameCount: Integer);
    procedure SetFrame(const FrameIndex: Integer; const Time: Single; const AttachmentName: String);
    procedure Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single); override;
  end;

  TSpineAnimationEventTimeline = class (TSpineAnimationTimeline)
  private
    var _Frames: TSpineFloatArray;
    var _FrameEvents: TSpineEventArray;
    function GetFrameCount: Integer; inline;
  public
    property Frames: TSpineFloatArray read _Frames write _Frames;
    property FrameEvents: TSpineEventArray read _FrameEvents write _FrameEvents;
    property FrameCount: Integer read GetFrameCount;
    constructor Create(const AFrameCount: Integer);
    procedure SetFrame(const FrameIndex: Integer; const Time: Single; const Event: TSpineEvent);
    procedure Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single); override;
  end;

  TSpineAnimationDrawOrderTimeline = class (TSpineAnimationTimeline)
  private
    var _Frames: TSpineFloatArray;
    var _DrawOrder: TSpineIntTable;
    function GetFrameCount: Integer; inline;
  public
    property Frames: TSpineFloatArray read _Frames write _Frames;
    property DrawOrder: TSpineIntTable read _DrawOrder write _DrawOrder;
    property FrameCount: Integer read GetFrameCount;
    constructor Create(const AFrameCount: Integer);
    procedure SetFrame(const FrameIndex: Integer; const Time: Single; const ADrawOrder: TSpineIntArray);
    procedure Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single); override;
  end;

  TSpineAnimationFFDTimeline = class (TSpineAnimationCurveTimeline)
  private
    var _SlotIndex: Integer;
    var _Frames: TSpineFloatArray;
    var _FrameVertices: TSpineFloatTable;
    var _Attachment: TSpineAttachment;
  public
    property SlotIndex: Integer read _SlotIndex write _SlotIndex;
    property Frames: TSpineFloatArray read _Frames write _Frames;
    property Vertices: TSpineFloatTable read _FrameVertices write _FrameVertices;
    property Attachment: TSpineAttachment read _Attachment write _Attachment;
    constructor Create(const AFrameCount: Integer); override;
    procedure SetFrame(const FrameIndex: Integer; const Time: Single; const AVertices: TSpineFloatArray);
    procedure Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single); override;
  end;

  TSpineAnimationIKConstraintTimeline = class (TSpineAnimationCurveTimeline)
  private
    const PREV_FRAME_TIME = -3;
    const PREV_FRAME_MIX = -2;
    const PREV_FRAME_BEND_DIRECTION = -1;
    const FRAME_MIX = 1;
    var _IKConstraintIndex: Integer;
    var _Frames: TSpineFloatArray;
  public
    property IKConstraintIndex: Integer read _IKConstraintIndex write _IKConstraintIndex;
    property Frames: TSpineFloatArray read _Frames write _Frames;
    constructor Create(const AFrameCount: Integer); override;
    procedure SetFrame(const FrameIndex: Integer; const Time, Mix: Single; const BendDirection: Integer);
    procedure Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single); override;
  end;

  TSpineAnimationFlipXTimeline = class (TSpineAnimationTimeline)
  private
    var _BoneIndex: Integer;
    var _Frames: TSpineFloatArray;
    function GetFrameCount: Integer; inline;
    procedure SetFlip(const Bone: TSpineBone; const Flip: Boolean); virtual;
  public
    property BoneIndex: Integer read _BoneIndex write _BoneIndex;
    property Frames: TSpineFloatArray read _Frames write _Frames;
    property FrameCount: Integer read GetFrameCount;
    constructor Create(const AFrameCount: Integer);
    procedure SetFrame(const FrameIndex: Integer; const Time: Single; const Flip: Boolean);
    procedure Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single); override;
  end;

  TSpineAnimationFlipYTimeline = class (TSpineAnimationFlipXTimeline)
  protected
    procedure SetFlip(const Bone: TSpineBone; const Flip: Boolean); override;
  end;

  TSpineTimelineList = specialize TSpineList<TSpineAnimationTimeline>;

  TSpineAnimation = class (TSpineClass)
  private
    var _Timelines: TSpineTimelineList;
    var _Duration: Single;
    var _Name: String;
  public
    property Name: String read _Name;
    property Timelines: TSpineTimelineList read _Timelines;
    property Duration: Single read _Duration write _Duration;
    constructor Create(const AName: String; const ATimelines: TSpineTimelineList; const ADuration: Single);
    procedure Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Loop: Boolean; const Events: TSpineEventList);
    procedure Mix(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Loop: Boolean; const Events: TSpineEventList; const Alpha: Single);
    class function BinarySearch(const Values: TSpineFloatArray; const Target: Single; const Step: Integer): Integer; overload;
    class function BinarySearch(const Values: TSpineFloatArray; const Target: Single): Integer; overload;
    class function LinearSearch(const Values: TSpineFloatArray; const Target: Single; const Step: Integer): Integer;
  end;

  TSpineAnimationStateStartEnd = procedure (const State: TSpineAnimationState; const TrackIndex: Integer) of Object;
  TSpineAnimationStateEvent = procedure (const State: TSpineAnimationState; const TrackIndex: Integer; const Event: TSpineEvent) of Object;
  TSpineAnimationStateComplete = procedure (const State: TSpineAnimationState; const TrackIndex, LoopCount: Integer) of Object;

  TSpineAnimationTrackEntry = class (TSpineClass)
  private
    var _State: TSpineAnimationState;
    var _Next: TSpineAnimationTrackEntry;
    var _Prev: TSpineAnimationTrackEntry;
    var _Animation: TSpineAnimation;
    var _Loop: Boolean;
    var _Delay: Single;
    var _Time: Single;
    var _LastTime: Single;
    var _EndTime: Single;
    var _TimeScale: Single;
    var _MixTime: Single;
    var _MixDuration: Single;
    var _Mix: Single;
    var _OnStart: TSpineAnimationStateStartEnd;
    var _OnEnd: TSpineAnimationStateStartEnd;
    var _OnEvent: TSpineAnimationStateEvent;
    var _OnComplete: TSpineAnimationStateComplete;
    procedure ProcStart(const State: TSpineAnimationState; const Index: Integer);
    procedure ProcEnd(const State: TSpineAnimationState; const Index: Integer);
    procedure ProcEvent(const State: TSpineAnimationState; const Index: Integer; const Event: TSpineEvent);
    procedure ProcComplete(const State: TSpineAnimationState; const Index, LoopCount: Integer);
  protected
    property Prev: TSpineAnimationTrackEntry read _Prev write _Prev;
    property Next: TSpineAnimationTrackEntry read _Next write _Next;
  public
    property Animation: TSpineAnimation read _Animation;
    property Delay: Single read _Delay write _Delay;
    property Time: Single read _Time write _Time;
    property LastTime: Single read _LastTime write _LastTime;
    property EndTime: Single read _EndTime write _EndTime;
    property TimeScale: Single read _TimeScale write _TimeScale;
    property Mix: Single read _Mix write _Mix;
    property MixTime: Single read _MixTime write _MixTime;
    property MixDuration: Single read _MixDuration write _MixDuration;
    property Loop: Boolean read _Loop write _Loop;
    property OnStart: TSpineAnimationStateStartEnd read _OnStart write _OnStart;
    property OnEnd: TSpineAnimationStateStartEnd read _OnEnd write _OnEnd;
    property OnEvent: TSpineAnimationStateEvent read _OnEvent write _OnEvent;
    property OnComplete: TSpineAnimationStateComplete read _OnComplete write _OnComplete;
    constructor Create(const AState: TSpineAnimationState; const AAnimation: TSpineAnimation);
    destructor Destroy; override;
  end;
  TSpineAnimationTrackEntryList = specialize TSpineList<TSpineAnimationTrackEntry>;

  TSpineAnimationState = class (TSpineClass)
  private
    var _Data: TSpineAnimationStateData;
    var _Tracks: TSpineAnimationTrackEntryList;
    var _Events: TSpineEventList;
    var _TimeScale: Single;
    var _OnStart: TSpineAnimationStateStartEnd;
    var _OnEnd: TSpineAnimationStateStartEnd;
    var _OnEvent: TSpineAnimationStateEvent;
    var _OnComplete: TSpineAnimationStateComplete;
    function ExpandToIndex(const Index: Integer): TSpineAnimationTrackEntry;
    procedure SetCurrent(const Index: Integer; const Entry: TSpineAnimationTrackEntry);
  public
    property Data: TSpineAnimationStateData read _Data;
    property TimeScale: Single read _TimeScale write _TimeScale;
    property OnStart: TSpineAnimationStateStartEnd read _OnStart write _OnStart;
    property OnEnd: TSpineAnimationStateStartEnd read _OnEnd write _OnEnd;
    property OnEvent: TSpineAnimationStateEvent read _OnEvent write _OnEvent;
    property OnComplete: TSpineAnimationStateComplete read _OnComplete write _OnComplete;
    constructor Create(const AData: TSpineAnimationStateData);
    destructor Destroy; override;
    procedure Update(const Delta: Single);
    procedure Apply(const Skeleton: TSpineSkeleton);
    procedure ClearTracks;
    procedure ClearTrack(const TrackIndex: Integer);
    function SetAnimation(const TrackIndex: Integer; const AnimationName: String; const Loop: Boolean): TSpineAnimationTrackEntry; overload;
    function SetAnimation(const TrackIndex: Integer; const Animation: TSpineAnimation; const Loop: Boolean): TSpineAnimationTrackEntry; overload;
    function AddAnimation(const TrackIndex: Integer; const AnimationName: String; const Loop: Boolean; const Delay: Single): TSpineAnimationTrackEntry; overload;
    function AddAnimation(const TrackIndex: Integer; const Animation: TSpineAnimation; const Loop: Boolean; const Delay: Single): TSpineAnimationTrackEntry; overload;
    function GetCurrent(const TrackIndex: Integer): TSpineAnimationTrackEntry;
  end;

  TSpineAnimationMix0 = class;
  TSpineAnimationMix1 = class;
  TSpineAnimationMix0List = specialize TSpineList<TSpineAnimationMix0>;
  TSpineAnimationMix1List = specialize TSpineList<TSpineAnimationMix1>;

  TSpineAnimationMix1 = class (TSpineClass)
  public
    var Anim: TSpineAnimation;
    var Duration: Single;
  end;

  TSpineAnimationMix0 = class (TSpineClass)
  public
    var Anim: TSpineAnimation;
    var MixEnties: TSpineAnimationMix1List;
  end;

  TSpineAnimationStateData = class (TSpineClass)
  private
    var _SkeletonData: TSpineSkeletonData;
    var _MixTime: TSpineAnimationMix0List;
    var _DefaultMix: Single;
  public
    property SkeletonData: TSpineSkeletonData read _SkeletonData;
    property DefaultMix: Single read _DefaultMix write _DefaultMix;
    constructor Create(const ASkeletonData: TSpineSkeletonData);
    destructor Destroy; override;
    procedure SetMix(const FromName, ToName: String; const Duration: Single); overload;
    procedure SetMix(const AnimFrom, AnimTo: TSpineAnimation; const Duration: Single); overload;
    function GetMix(const AnimFrom, AnimTo: TSpineAnimation): Single;
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
    property IntValue: Integer read _IntValue write _IntValue;
    property FloatValue: Single read _FloatValue write _FloatValue;
    property StringValue: String read _StringValue write _StringValue;
    constructor Create(const AData: TSpineEventData);
  end;

  TSpineIKConstraint = class (TSpineClass)
  private
    var _Data: TSpineIKConstraintData;
    var _Bones: TSpineBoneList;
    var _Target: TSpineBone;
    var _BendDirection: Integer;
    var _Mix: Single;
    class procedure Apply(var Bone: TSpineBone; const TargetX, TargetY, Alpha: Single); overload;
    class procedure Apply(var Parent, Child: TSpineBone; const TargetX, TargetY, Alpha: Single; const ABendDirection: Integer); overload;
  public
    property Data: TSpineIKConstraintData read _Data;
    property Bones: TSpineBoneList read _Bones;
    property Target: TSpineBone read _Target write _Target;
    property BendDirection: Integer read _BendDirection write _BendDirection;
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
    var Page: TSpineAtlasPage;
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
    property Pages: TSpineAtlasPageList read _Pages;
    property Regions: TSpineAtlasRegionList read _Regions;
    constructor Create(const Path: String);
    destructor Destroy; override;
    procedure Load(const Path: String);
    procedure Clear;
    procedure FlipV;
    function FindRegion(const Name: String): TSpineAtlasRegion;
  end;

  TSpineAttachment = class (TSpineClass)
  private
    var _Name: String;
  public
    property Name: String read _Name write _Name;
    constructor Create(const AName: String); virtual;
    procedure Draw(const Render: TSpineRender; const Slot: TSpineSlot); virtual;
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
    var _Texture: TSpineTexture;
    function GetOffset(const Index: Integer): Single; inline;
    procedure SetTexture(const Value: TSpineTexture); inline;
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
    property Texture: TSpineTexture read _Texture write SetTexture;
    constructor Create(const AName: String); override;
    destructor Destroy; override;
    procedure SetUVs(const u, v, u2, v2: Single; const Rotate: Boolean); inline;
    procedure UpdateOffset;
    procedure ComputeWorldVertices(const Bone: TSpineBone; var OutWorldVertices: TSpineRegionVertices);
    procedure Draw(const Render: TSpineRender; const Slot: TSpineSlot); override;
  end;

  TSpineBoundingBoxAttachment = class (TSpineAttachment)
  private
    var _Vertices: TSpineFloatArray;
  public
    property Vertices: TSpineFloatArray read _Vertices write _Vertices;
    constructor Create(const AName: String); override;
    procedure ComputeWorldVertices(const Bone: TSpineBone; var WorldVertices: TSpineFloatArray);
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
    var _Texture: TSpineTexture;
    var _WorldVertices: TSpineFloatArray;
    var _RenderVertices: array of TSpineVertexData;
    procedure SetTexture(const Value: TSpineTexture);
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
    property Texture: TSpineTexture read _Texture write SetTexture;
    constructor Create(const AName: String); override;
    destructor Destroy; override;
    procedure UpdateUV;
    procedure ComputeWorldVertices(const Slot: TSpineSlot; var WorldVertices: TSpineFloatArray);
    procedure Draw(const Render: TSpineRender; const Slot: TSpineSlot); override;
  end;

  TSpineSkinnedMeshAttachment = class (TSpineAttachment)
  private
    var _Bones: TSpineIntArray;
    var _Weights: TSpineFloatArray;
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
    var _Texture: TSpineTexture;
    var _WorldVertices: TSpineFloatArray;
    var _RenderVertices: array of TSpineVertexData;
    function GetBonesPtr: PSpineIntArray; inline;
    function GetWeightsPtr: PSpineFloatArray; inline;
    procedure SetTexture(const Value: TSpineTexture);
  public
    property HullLength: Integer read _HullLength write _HullLength;
    property Bones: TSpineIntArray read _Bones write _Bones;
    property BonesPtr: PSpineIntArray read GetBonesPtr;
    property Weights: TSpineFloatArray read _Weights write _Weights;
    property WeightsPtr: PSpineFloatArray read GetWeightsPtr;
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
    property Texture: TSpineTexture read _Texture write SetTexture;
    constructor Create(const AName: String); override;
    destructor Destroy; override;
    procedure UpdateUV;
    procedure ComputeWorldVertices(const Slot: TSpineSlot; var WorldVertices: TSpineFloatArray);
    procedure Draw(const Render: TSpineRender; const Slot: TSpineSlot); override;
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
    procedure SetAtlasList(const Value: TSpineAtlasList);
  public
    property AtlasList: TSpineAtlasList read _AtlasList write SetAtlasList;
    constructor Create;
    constructor Create(const AAtlasList: TSpineAtlasList);
    destructor Destroy; override;
    function NewRegionAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineRegionAttachment; override;
    function NewMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineMeshAttachment; override;
    function NewSkinnedMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineSkinnedMeshAttachment; override;
    function NewBoundingBoxAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineBoundingBoxAttachment; override;
    function FindRegion(const Name: String): TSpineAtlasRegion;
  end;

  TSpineSkeletonBinary = class (TSpineClass)
  private
    const TIMELINE_SCALE = 0;
    const TIMELINE_ROTATE = 1;
    const TIMELINE_TRANSLATE = 2;
    const TIMELINE_ATTACHMENT = 3;
    const TIMELINE_COLOR = 4;
    const TIMELINE_FLIPX = 5;
    const TIMELINE_FLIPY = 6;
    const CURVE_LINEAR = 0;
    const CURVE_STEPPED = 1;
    const CURVE_BEZIER = 2;
    var _AttachmentLoader: TSpineAttachmentLoader;
    var _Chars: array of AnsiChar;
    var _Buffer: array[0..3] of Byte;
    var _Scale: Single;
    function ReadInt(const Provider: TSpineDataProvider): Integer;
    function ReadInt(const Provider: TSpineDataProvider; const OptimizePositive: Boolean): Integer;
    function ReadSByte(const Provider: TSpineDataProvider): ShortInt;
    function ReadBool(const Provider: TSpineDataProvider): Boolean;
    function ReadFloat(const Provider: TSpineDataProvider): Single;
    function ReadFloatArray(const Provider: TSpineDataProvider; const ScaleArr: Single): TSpineFloatArray;
    function ReadShortArray(const Provider: TSpineDataProvider): TSpineIntArray;
    function ReadIntArray(const Provider: TSpineDataProvider): TSpineIntArray;
    function ReadString(const Provider: TSpineDataProvider): String;
    procedure ReadUtf8Slow(const Provider: TSpineDataProvider; const CharCount: Integer; var CharIndex, b: Integer);
    procedure ReadCurve(const Provider: TSpineDataProvider; const FrameIndex: Integer; const Timeline: TSpineAnimationCurveTimeline);
    function ReadSkin(const Provider: TSpineDataProvider; const SkinName: String; const NonEssential: Boolean): TSpineSkin;
    function ReadAttachment(const Provider: TSpineDataProvider; const Skin: TSpineSkin; const AttachmentName: String; const NonEssential: Boolean): TSpineAttachment;
    procedure ReadAnimation(const Provider: TSpineDataProvider; const Name: String; const SkeletonData: TSpineSkeletonData);
  public
    property Scale: Single read _Scale write _Scale;
    constructor Create(const AtlasList: TSpineAtlasList);
    constructor Create(const AttachmentLoader: TSpineAttachmentLoader);
    destructor Destroy; override;
    function ReadSkeletonData(const Path: String): TSpineSkeletonData; overload;
    function ReadSkeletonData(const Provider: TSpineDataProvider): TSpineSkeletonData; overload;
  end;

const
  SP_DEG_TO_RAD = Pi / 180;
  SP_RAD_TO_DEG = 180 / Pi;
  SP_RCP_255 = 1 / 255;

var
  SpineDataProvider: CSpineDataProvider = TSpineDataProvider;

implementation

function SpineArcTan2(const y, x: Single): Single;
  const HalfPi = Pi * 0.5;
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

function SpineArcCos(const x: Single): Single;
begin
  Result := SpineArcTan2(Sqrt((1 + x) * (1 - x)), x);
end;

function SpineMin(const v0, v1: Single): Single;
begin
  if v0 < v1 then Result := v0 else Result := v1;
end;

function SpineMax(const v0, v1: Single): Single;
begin
  if v0 > v1 then Result := v0 else Result := v1;
end;

function SpineModFloat(const v0, v1: Single): Single;
begin
  Result := v0 - Trunc(v0 / v1) * v1;
end;

//TSpineDataProvider BEGIN
procedure TSpineDataProvider.Allocate(const DataSize: Integer);
begin
  if Assigned(_Data) then FreeMem(_Data, _Size);
  _Size := DataSize;
  GetMem(_Data, _Size);
  _Pos := 0;
end;

constructor TSpineDataProvider.Create(const DataSize: Integer);
begin
  _Data := nil;
  _Size := 0;
  _Pos := 0;
  Allocate(DataSize);
end;

destructor TSpineDataProvider.Destroy;
begin
  FreeMem(_Data, _Size);
  inherited Destroy;
end;

procedure TSpineDataProvider.Read(const Buffer: Pointer; const Count: Integer);
begin
  Move(_Data^[_Pos], Buffer^, Count);
  Inc(_Pos, Count);
end;

function TSpineDataProvider.ReadByte: Byte;
begin
  Read(@Result, 1);
end;

class function TSpineDataProvider.FetchData(const DataName: String): TSpineDataProvider;
  var FileName: String;
  var fs: TFileStream;
begin
  Result := nil;
  if FileExists(DataName) then FileName := DataName
  else FileName := ExtractFileDir(ParamStr(0)) + DataName;
  if FileExists(FileName) then
  begin
    fs := TFileStream.Create(FileName, fmOpenRead);
    try
      Result := TSpineDataProvider.Create(fs.Size);
      fs.Read(Result.Data^, fs.Size);
    finally
      fs.Free;
    end;
  end;
end;

class function TSpineDataProvider.FetchTexture(const TextureName: String): TSpineTexture;
begin
  Result := nil;
end;
//TSpineDataProvider END

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
  _Events := TSpineEventDataList.Create;
  _Animations := TSpineAnimationList.Create;
  _IKConstraints := TSpineIKConstraintDataList.Create;
end;

destructor TSpineSkeletonData.Destroy;
begin
  _Bones.Free;
  _Slots.Free;
  _Skins.Free;
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
  var i: Integer;
begin
  i := FindIKConstraintIndex(IKConstraintName);
  if i > -1 then Result := _IKConstraints[i] else Result := nil;
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
  _Bones := TSpineBoneDataList.Create;
end;

destructor TSpineIKConstraintData.Destroy;
begin
  _Bones.Free;
  inherited Destroy;
end;
//TSpineIKConstraintData END

//TSpineBone BEGIN
class constructor TSpineBone.CreateClass;
begin
  YDown := True;
end;

constructor TSpineBone.Create(const AData: TSpineBoneData; const ASkeleton: TSpineSkeleton; const AParent: TSpineBone);
begin
  _Children := TSpineBoneList.Create;
  _Data := AData;
  _Data.RefInc;
  _Skeleton := ASkeleton;
  _Skeleton.RefInc;
  _Parent := AParent;
  SetToSetupPose;
end;

destructor TSpineBone.Destroy;
begin
  _Data.RefDec;
  _Skeleton.RefDec;
  _Children.Free;
  inherited Destroy;
end;

procedure TSpineBone.UpdateWorldTransform;
  var Radians, c, s: Single;
begin
  if Assigned(_Parent) then
  begin
    _WorldX := _x * _Parent.m00 + _y * _Parent.m01 + _Parent.WorldX;
    _WorldY := _x * _Parent.m10 + _y * _Parent.m11 + _Parent.WorldY;
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
    _WorldFlipX := _Parent.WorldFlipX xor FlipX;
    _WorldFlipY := _Parent.WorldFlipY xor FlipY;
  end
  else
  begin
    if _Skeleton.FlipX then _WorldX := -x else _WorldX := x;
    if _Skeleton.FlipY <> YDown then _WorldY := -y else _WorldY := y;
    _WorldScaleX := _ScaleX;
    _WorldScaleY := _ScaleY;
    _WorldRotation := _RotationIK;
    _WorldFlipX := _Skeleton.FlipX xor _FlipX;
    _WorldFlipY := _Skeleton.FlipY xor _FlipY;
  end;
  Radians := _WorldRotation * SP_DEG_TO_RAD;
  c := Cos(Radians);
  s := Sin(Radians);
  if _WorldFlipX then
  begin
    _m00 := -c * _WorldScaleX;
    _m01 := s * _WorldScaleY;
  end
  else
  begin
    _m00 := c * _WorldScaleX;
    _m01 := -s * _WorldScaleY;
  end;
  if _WorldFlipY <> YDown then
  begin
    _m10 := -s * _WorldScaleX;
    _m11 := -c * _WorldScaleY;
  end
  else
  begin
    _m10 := s * _WorldScaleX;
    _m11 := c * _WorldScaleY;
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
  var dx, dy, dm00, dm11, RcpDet: Single;
begin
  dx := InWorldX - _WorldX;
  dy := InWorldY - _WorldY;
  dm00 := _m00;
  dm11 := _m11;
  if _WorldFlipX <> (WorldFlipY <> YDown) then
  begin
    dm00 := -dm00;
    dm11 := -dm11;
  end;
  RcpDet := 1 / (dm00 * dm11 - _m01 * _m10);
  OutLocalX := (dx * dm00 * RcpDet - dy * m01 * RcpDet);
  OutLocalY := (dy * dm11 * RcpDet - dx * m10 * RcpDet);
end;

procedure TSpineBone.LocalToWorld(const InLocalX, InLocalY: Single; var OutWorldX, OutWorldY: Single);
begin
  OutWorldX := InLocalX * _m00 + InLocalY * _m01 + _WorldX;
  OutWorldY := InLocalX * _m10 + InLocalY * _m11 + _WorldY;
end;
//TSpineBone END

//TSpineSlot BEGIN
function TSpineSlot.GetSkeleton: TSpineSkeleton;
begin
  Result := _Bone.Skeleton;
end;

function TSpineSlot.GetAttachmentVerticesPtr: PSpineFloatArray;
begin
  Result := @_AttachmentVertices;
end;

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
  _Data.RefInc;
  _Bone := ABone;
  _Bone.RefInc;
  SetToSetupPose;
end;

destructor TSpineSlot.Destroy;
begin
  _Bone.RefDec;
  _Data.RefDec;
  inherited Destroy;
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
  var IKConstraint: TSpineIKConstraint;
begin
  _x := 0;
  _y := 0;
  _ScaleX := 1;
  _ScaleY := 1;
  _BoneCache := TSpineBoneCacheList.Create;
  _Bones := TSpineBoneList.Create;
  _Data := AData;
  _Data.RefInc;
  for i := 0 to _Data.Bones.Count - 1 do
  begin
    BoneData := _Data.Bones[i];
    if Assigned(BoneData.Parent) then
    Parent := _Bones[_Data.Bones.Find(BoneData.Parent)]
    else
    Parent := nil;
    Bone := TSpineBone.Create(BoneData, Self, Parent);
    if Assigned(Parent) then
    Parent.Children.Add(Bone);
    _Bones.Add(Bone);
    Bone.RefDec;
  end;
  _Slots := TSpineSlotList.Create;
  _DrawOrder := TSpineSlotList.Create;
  for i := 0 to _Data.Slots.Count - 1 do
  begin
    SlotData := _Data.Slots[i];
    Bone := _Bones[_Data.Bones.Find(SlotData.BoneData)];
    Slot := TSpineSlot.Create(SlotData, Bone);
    _Slots.Add(Slot);
    Slot.RefDec;
    _DrawOrder.Add(Slot);
  end;
  _IKConstraints := TSpineIKConstraintList.Create;
  for i := 0 to _Data.IKConstraints.Count - 1 do
  begin
    IKConstraint := TSpineIKConstraint.Create(_Data.IKConstraints[i], Self);
    _IKConstraints.Add(IKConstraint);
    IKConstraint.RefDec;
  end;
  UpdateCache;
end;

destructor TSpineSkeleton.Destroy;
begin
  _DrawOrder.Free;
  _BoneCache.Free;
  _Bones.Free;
  _Slots.Free;
  _IKConstraints.Free;
  _Data.RefDec;
  inherited Destroy;
end;

procedure TSpineSkeleton.UpdateCache;
  var i, j, ArrayCount: Integer;
  var List, NonIKBones: TSpineBoneList;
  var Bone, CurBone, Parent, Child: TSpineBone;
  var Constraint: TSpineIKConstraint;
  var Done: Boolean;
begin
  ArrayCount := _IKConstraints.Count + 1;
  if _BoneCache.Count > ArrayCount then
  for i := _BoneCache.Count - 1 downto ArrayCount do
  begin
    _BoneCache.Delete(i);
  end;
  while _BoneCache.Count < ArrayCount do
  begin
    List := TSpineBoneList.Create;
    _BoneCache.Add(List);
    List.Free;
  end;
  NonIKBones := _BoneCache[0];
  for i := 0 to _Bones.Count - 1 do
  begin
    Bone := _Bones[i];
    CurBone := Bone;
    Done := False;
    repeat
      for j := 0 to _IKConstraints.Count - 1 do
      begin
        Constraint := _IKConstraints[j];
        Parent := Constraint.Bones.First;
        Child := Constraint.Bones.Last;
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
      end;
      if Done then Break;
      CurBone := CurBone.Parent;
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
  last := _IKConstraints.Count;
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
    Constraint.BendDirection := Constraint.Data.BendDirection;
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
  if _Bones[i].Data.Name = BoneName then
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
  if _Slots[i].Data.Name = SlotName then
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
  TempSkin := _Data.FindSkin(SkinName);
  if Assigned(TempSkin) then Skin := TempSkin;
end;

function TSpineSkeleton.GetAttachment(const SlotName, AttachmentName: String): TSpineAttachment;
begin
  Result := GetAttachment(_Data.FindSlotIndex(SlotName), AttachmentName);
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

procedure TSpineSkeleton.Draw(const Render: TSpineRender);
  var i: Integer;
  var Slot: TSpineSlot;
  var Attachment: TSpineAttachment;
begin
  for i := 0 to _DrawOrder.Count - 1 do
  begin
    Slot := _DrawOrder[i];
    Attachment := Slot.Attachment;
    if Attachment <> nil then
    Attachment.Draw(Render, Slot);
  end;
end;
//TSpineSkeleton END

//TSpinePolygon BEGIN
function TSpinePolygon.GetVerticesPtr: PSpineFloatArray;
begin
  Result := @_Vertices;
end;

constructor TSpinePolygon.Create;
begin
  _Count := 0;
end;
//TSpinePolygon END

//TSpineAnimationCurveTimeline BEGIN
function TSpineAnimationCurveTimeline.GetFrameCount: Integer;
begin
  Result := Length(_Curves) div BEZIER_SIZE + 1;
end;

constructor TSpineAnimationCurveTimeline.Create(const AFrameCount: Integer);
begin
  SetLength(_Curves, (AFrameCount - 1) * BEZIER_SIZE);
end;

procedure TSpineAnimationCurveTimeline.SetLinear(const FrameIndex: Integer);
begin
  _Curves[FrameIndex * BEZIER_SIZE] := LINEAR;
end;

procedure TSpineAnimationCurveTimeline.SetStepped(const FrameIndex: Integer);
begin
  _Curves[FrameIndex * BEZIER_SIZE] := STEPPED;
end;

procedure TSpineAnimationCurveTimeline.SetCurve(const FrameIndex: Integer; const cx1, cy1, cx2, cy2: Single);
  var subdiv1, subdiv2, subdiv3: Single;
  var pre1, pre2, pre4, pre5: Single;
  var tmp1x, tmp1y, tmp2x, tmp2y: Single;
  var dfx, dfy, ddfx, ddfy, dddfx, dddfy: Single;
  var x, y: Single;
  var i, n: Integer;
begin
  subdiv1 := 1 / BEZIER_SEGMENTS;
  subdiv2 := subdiv1 * subdiv1;
  subdiv3 := subdiv2 * subdiv1;
  pre1 := 3 * subdiv1;
  pre2 := 3 * subdiv2;
  pre4 := 6 * subdiv2;
  pre5 := 6 * subdiv3;
  tmp1x := -cx1 * 2 + cx2;
  tmp1y := -cy1 * 2 + cy2;
  tmp2x := (cx1 - cx2) * 3 + 1;
  tmp2y := (cy1 - cy2) * 3 + 1;
  dfx := cx1 * pre1 + tmp1x * pre2 + tmp2x * subdiv3;
  dfy := cy1 * pre1 + tmp1y * pre2 + tmp2y * subdiv3;
  ddfx := tmp1x * pre4 + tmp2x * pre5;
  ddfy := tmp1y * pre4 + tmp2y * pre5;
  dddfx := tmp2x * pre5;
  dddfy := tmp2y * pre5;
  i := FrameIndex * BEZIER_SIZE;
  _Curves[i] := BEZIER; Inc(i);
  x := dfx;
  y := dfy;
  n := i + BEZIER_SIZE - 1;
  while i < n do
  begin
    _Curves[i] := x;
    _Curves[i + 1] := y;
    dfx += ddfx;
    dfy += ddfy;
    ddfx += dddfx;
    ddfy += dddfy;
    x += dfx;
    y += dfy;
    Inc(i, 2);
  end;
end;

function TSpineAnimationCurveTimeline.GetCurvePercent(const FrameIndex: Integer; const Percent: Single): Single;
  var i, n, start: Integer;
  var dx, x, y, PrevX, PrevY: Single;
begin
  i := FrameIndex * BEZIER_SIZE;
  if _Curves[i] = LINEAR then Exit(Percent);
  if _Curves[i] = STEPPED then Exit(0);
  Inc(i);
  x := 0;
  start := i;
  n := i + BEZIER_SIZE - 1;
  while i < n do
  begin
    x := _Curves[i];
    if x >= Percent then
    begin
      if i = Start then
      begin
	PrevX := 0;
	PrevY := 0;
      end
      else
      begin
	PrevX := _Curves[i - 2];
	PrevY := _Curves[i - 1];
      end;
      dx := x - PrevX;
      if dx = 0 then Exit(0);
      Exit(PrevY + (_Curves[i + 1] - PrevY) * (Percent - PrevX) / dx);
    end;
    Inc(i, 2);
  end;
  y := _Curves[i - 1];
  dx := 1 - x;
  Result := y + (1 - y) * (Percent - x) / dx;
end;
//TSpineAnimationCurveTimeline END

//TSpineAnimationRotateTimeline BEIGN
constructor TSpineAnimationRotateTimeline.Create(const AFrameCount: Integer);
begin
  inherited Create(AFrameCount);
  SetLength(_Frames, AFrameCount shl 1);
end;

procedure TSpineAnimationRotateTimeline.SetFrame(const FrameIndex: Integer; const Time, Angle: Single);
  var i: Integer;
begin
  i := FrameIndex * 2;
  _Frames[i] := Time;
  _Frames[i + 1] := Angle;
end;

procedure TSpineAnimationRotateTimeline.Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single);
  var Bone: TSpineBone;
  var Amount, PrevFrameValue, FrameTime, Percent, dv: Single;
  var FrameIndex: Integer;
begin
  if Time < _Frames[0] then Exit;
  Bone := Skeleton.Bones[_BoneIndex];
  if (Time >= _Frames[Length(_Frames) - 2]) then
  begin
    Amount := Bone.Data.Rotation + _Frames[Length(_Frames) - 1] - Bone.Rotation;
    while Amount > 180 do Amount -= 360;
    while Amount < -180 do amount += 360;
    Bone.Rotation := Bone.Rotation + (Amount * Alpha);
    Exit;
  end;
  FrameIndex := TSpineAnimation.BinarySearch(_Frames, Time, 2);
  PrevFrameValue := _Frames[FrameIndex - 1];
  FrameTime := _Frames[FrameIndex];
  dv := _Frames[FrameIndex + PREV_FRAME_TIME] - FrameTime;
  if dv = 0 then Percent := 0 else Percent := 1 - (Time - FrameTime) / dv;
  if Percent < 0 then Percent := 0 else if Percent > 1 then Percent := 1;
  Percent := GetCurvePercent((FrameIndex shr 1) - 1, Percent);
  Amount := _Frames[FrameIndex + FRAME_VALUE] - PrevFrameValue;
  while Amount > 180 do Amount -= 360;
  while Amount < -180 do Amount += 360;
  Amount := Bone.Data.Rotation + (PrevFrameValue + Amount * Percent) - Bone.Rotation;
  while Amount > 180 do Amount -= 360;
  while Amount < -180 do Amount += 360;
  Bone.Rotation := Bone.Rotation + (Amount * Alpha);
end;
//TSpineAnimationRotateTimeline END

//TSpineAnimationTranslateTimeline BEGIN
constructor TSpineAnimationTranslateTimeline.Create(const AFrameCount: Integer);
begin
  inherited Create(AFrameCount);
  SetLength(_Frames, AFrameCount * 3);
end;

procedure TSpineAnimationTranslateTimeline.SetFrame(const FrameIndex: Integer; const Time, x, y: Single);
  var i: Integer;
begin
  i := FrameIndex * 3;
  _Frames[i] := Time;
  _Frames[i + 1] := x;
  _Frames[i + 2] := y;
end;

procedure TSpineAnimationTranslateTimeline.Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single);
  var Bone: TSpineBone;
  var FrameIndex: Integer;
  var PrevFrameX: Single;
  var PrevFrameY: Single;
  var FrameTime: Single;
  var Percent: Single;
  var dv: Single;
begin
  if Time < _Frames[0] then Exit;
  Bone := Skeleton.Bones[BoneIndex];
  if Time >= _Frames[Length(_Frames) - 3] then
  begin
    Bone.x := Bone.x + ((Bone.Data.x + _Frames[Length(_Frames) - 2] - Bone.x) * Alpha);
    Bone.y := Bone.y + ((Bone.Data.y + _Frames[Length(_Frames) - 1] - Bone.y) * Alpha);
    Exit;
  end;
  FrameIndex := TSpineAnimation.BinarySearch(_Frames, Time, 3);
  PrevFrameX := _Frames[FrameIndex - 2];
  PrevFrameY := _Frames[FrameIndex - 1];
  FrameTime := _Frames[FrameIndex];
  dv := _Frames[FrameIndex + PREV_FRAME_TIME] - FrameTime;
  if dv = 0 then Percent := 0 else Percent := 1 - (Time - FrameTime) / dv;
  if Percent < 0 then Percent := 0 else if Percent > 1 then Percent := 1;
  Percent := GetCurvePercent(FrameIndex div 3 - 1, Percent);
  Bone.x := Bone.x + ((Bone.Data.x + PrevFrameX + (_Frames[FrameIndex + FRAME_X] - PrevFrameX) * Percent - Bone.x) * Alpha);
  Bone.y := Bone.y + ((Bone.Data.y + PrevFrameY + (_Frames[FrameIndex + FRAME_Y] - PrevFrameY) * Percent - Bone.y) * Alpha);
end;
//TSpineAnimationTranslateTimeline END

//TSpineAnimationScaleTimeline BEGIN
constructor TSpineAnimationScaleTimeline.Create(const AFrameCount: Integer);
begin
  inherited Create(AFrameCount);
end;

procedure TSpineAnimationScaleTimeline.Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single);
  var Bone: TSpineBone;
  var FrameIndex: Integer;
  var PrevFrameX: Single;
  var PrevFrameY: Single;
  var FrameTime: Single;
  var Percent: Single;
  var dv: Single;
begin
  if Time < _Frames[0] then Exit;
  Bone := Skeleton.Bones[_BoneIndex];
  if Time >= _Frames[Length(_Frames) - 3] then
  begin
    Bone.ScaleX := Bone.ScaleX + ((Bone.Data.ScaleX * _Frames[Length(_Frames) - 2] - Bone.ScaleX) * Alpha);
    Bone.ScaleY := Bone.ScaleY + ((Bone.Data.ScaleY * _Frames[Length(_Frames) - 1] - Bone.ScaleY) * Alpha);
    Exit;
  end;
  FrameIndex := TSpineAnimation.BinarySearch(_Frames, Time, 3);
  PrevFrameX := _Frames[FrameIndex - 2];
  PrevFrameY := _Frames[FrameIndex - 1];
  FrameTime := _Frames[FrameIndex];
  dv := _Frames[FrameIndex + PREV_FRAME_TIME] - FrameTime;
  if dv = 0 then Percent := 0 else Percent := 1 - (Time - FrameTime) / dv;
  if Percent < 0 then Percent := 0 else if Percent > 1 then Percent := 1;
  Percent := GetCurvePercent(FrameIndex div 3 - 1, Percent);
  Bone.ScaleX := Bone.ScaleX + ((Bone.Data.ScaleX * (PrevFrameX + (_Frames[FrameIndex + FRAME_X] - PrevFrameX) * Percent) - Bone.ScaleX) * Alpha);
  Bone.ScaleY := Bone.ScaleY + ((Bone.Data.ScaleY * (PrevFrameY + (_Frames[FrameIndex + FRAME_Y] - PrevFrameY) * Percent) - Bone.ScaleY) * Alpha);
end;
//TSpineAnimationScaleTimeline END

//TSpineAnimationColorTimeline BEGIN
constructor TSpineAnimationColorTimeline.Create(const AFrameCount: Integer);
begin
  inherited Create(AFrameCount);
  SetLength(_Frames, AFrameCount * 5);
end;

procedure TSpineAnimationColorTimeline.SetFrame(const FrameIndex: Integer; const Time, r, g, b, a: Single);
  var i: Integer;
begin
  i := FrameIndex * 5;
  _Frames[i] := Time;
  _Frames[i + 1] := r;
  _Frames[i + 2] := g;
  _Frames[i + 3] := b;
  _Frames[i + 4] := a;
end;

procedure TSpineAnimationColorTimeline.Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single);
  var r, g, b, a: Single;
  var PrevFrameR, PrevFrameG, PrevFrameB, PrevFrameA: Single;
  var FrameTime, Percent, dv: Single;
  var FrameIndex, i: Integer;
  var Slot: TSpineSlot;
begin
  if Time < _Frames[0] then Exit;
  if Time >= _Frames[Length(_Frames) - 5] then
  begin
    i := High(_Frames);
    r := _Frames[i - 3];
    g := _Frames[i - 2];
    b := _Frames[i - 1];
    a := _Frames[i];
  end
  else
  begin
    FrameIndex := TSpineAnimation.BinarySearch(_Frames, Time, 5);
    PrevFrameR := _Frames[FrameIndex - 4];
    PrevFrameG := _Frames[FrameIndex - 3];
    PrevFrameB := _Frames[FrameIndex - 2];
    PrevFrameA := _Frames[FrameIndex - 1];
    FrameTime := _Frames[FrameIndex];
    dv := _Frames[FrameIndex + PREV_FRAME_TIME] - FrameTime;
    if dv = 0 then Percent := 0 else Percent := 1 - (Time - FrameTime) / dv;
    if Percent < 0 then Percent := 0 else if Percent > 1 then Percent := 1;
    Percent := GetCurvePercent(FrameIndex div 5 - 1, Percent);
    r := PrevFrameR + (_Frames[FrameIndex + FRAME_R] - PrevFrameR) * Percent;
    g := PrevFrameG + (_Frames[FrameIndex + FRAME_G] - PrevFrameG) * Percent;
    b := PrevFrameB + (_Frames[FrameIndex + FRAME_B] - PrevFrameB) * Percent;
    a := PrevFrameA + (_Frames[FrameIndex + FRAME_A] - PrevFrameA) * Percent;
  end;
  Slot := Skeleton.Slots[_SlotIndex];
  if Alpha < 1 then
  begin
    Slot.r := Slot.r + ((r - Slot.r) * Alpha);
    Slot.g := Slot.g + ((g - Slot.g) * Alpha);
    Slot.b := Slot.b + ((b - Slot.b) * Alpha);
    Slot.a := Slot.a + ((a - Slot.a) * Alpha);
  end
  else
  begin
    Slot.r := r;
    Slot.g := g;
    Slot.b := b;
    Slot.a := a;
  end;
end;
//TSpineAnimationColorTimeline END

//TSpineAnimationAttachmentTimeline BEGIN
function TSpineAnimationAttachmentTimeline.GetFrameCount: Integer;
begin
  Result := Length(_Frames);
end;

constructor TSpineAnimationAttachmentTimeline.Create(const AFrameCount: Integer);
begin
  SetLength(_Frames, AFrameCount);
  SetLength(_AttachmentNames, AFrameCount);
end;

procedure TSpineAnimationAttachmentTimeline.SetFrame(const FrameIndex: Integer; const Time: Single; const AttachmentName: String);
begin
  _Frames[FrameIndex] := Time;
  _AttachmentNames[FrameIndex] := AttachmentName;
end;

procedure TSpineAnimationAttachmentTimeline.Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single);
  var FrameIndex: Integer;
  var AttachmentName: String;
  var tl: Single;
begin
  tl := LastTime;
  if Time < _Frames[0] then
  begin
    if (tl > Time) then Apply(Skeleton, tl, 1E+16, nil, 0);
    Exit;
  end
  else if (tl > Time) then
  begin
    tl := -1;
  end;
  if Time >= _Frames[High(_Frames)] then
  FrameIndex := High(_Frames)
  else
  FrameIndex := TSpineAnimation.BinarySearch(_Frames, Time) - 1;
  if (_Frames[FrameIndex] < tl) then Exit;
  AttachmentName := _AttachmentNames[FrameIndex];
  if Length(AttachmentName) > 0 then
  Skeleton.Slots[SlotIndex].Attachment := Skeleton.GetAttachment(SlotIndex, AttachmentName)
  else
  Skeleton.Slots[SlotIndex].Attachment := nil;
end;
//TSpineAnimationAttachmentTimeline END

//TSpineAnimationEventTimeline BEGIN
function TSpineAnimationEventTimeline.GetFrameCount: Integer;
begin
  Result := Length(_Frames);
end;

constructor TSpineAnimationEventTimeline.Create(const AFrameCount: Integer);
begin
  SetLength(_Frames, AFrameCount);
  SetLength(_FrameEvents, AFrameCount);
end;

procedure TSpineAnimationEventTimeline.SetFrame(const FrameIndex: Integer; const Time: Single; const Event: TSpineEvent);
begin
  _Frames[FrameIndex] := Time;
  _FrameEvents[FrameIndex] := Event;
end;

procedure TSpineAnimationEventTimeline.Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single);
  var FrameIndex, fc: Integer;
  var Frame, tl: Single;
begin
  if Events = nil then Exit;
  fc := Length(_Frames);
  tl := LastTime;
  if tl > Time then
  begin
    Apply(Skeleton, tl, 1E+16, Events, Alpha);
    tl := -1;
  end
  else if tl >= _Frames[fc - 1] then Exit;
  if Time < _Frames[0] then Exit;
  if tl < _Frames[0] then
  begin
    FrameIndex := 0;
  end
  else
  begin
    FrameIndex := TSpineAnimation.BinarySearch(_Frames, tl);
    Frame := _Frames[FrameIndex];
    while FrameIndex > 0 do
    begin
      if _Frames[FrameIndex - 1] <> Frame then Break;
      Dec(FrameIndex);
    end;
  end;
  while (FrameIndex < FrameCount) and (Time >= _Frames[FrameIndex]) do
  begin
    Events.Add(_FrameEvents[FrameIndex]);
    Inc(FrameIndex);
  end;
end;
//TSpineAnimationEventTimeline END

//TSpineAnimationDrawOrderTimeline BEGIN
function TSpineAnimationDrawOrderTimeline.GetFrameCount: Integer;
begin
  Result := Length(_Frames);
end;

constructor TSpineAnimationDrawOrderTimeline.Create(const AFrameCount: Integer);
begin
  SetLength(_Frames, AFrameCount);
  SetLength(_DrawOrder, AFrameCount);
end;

procedure TSpineAnimationDrawOrderTimeline.SetFrame(const FrameIndex: Integer; const Time: Single; const ADrawOrder: TSpineIntArray);
begin
  _Frames[FrameIndex] := Time;
  SetLength(_DrawOrder[FrameIndex], Length(ADrawOrder));
  Move(ADrawOrder[0], _DrawOrder[FrameIndex][0], Length(ADrawOrder) * SizeOf(Integer));
end;

procedure TSpineAnimationDrawOrderTimeline.Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single);
  var i, FrameIndex: Integer;
begin
  if Time < _Frames[0] then Exit;
  if Time >= _Frames[High(_Frames)] then FrameIndex := High(_Frames)
  else FrameIndex := TSpineAnimation.BinarySearch(_Frames, Time) - 1;
  if Length(_DrawOrder[FrameIndex]) = 0 then
  begin
    Skeleton.DrawOrder.Clear;
    for i := 0 to Skeleton.Slots.Count - 1 do
    Skeleton.DrawOrder.Add(Skeleton.Slots[i]);
  end
  else
  begin
    for i := 0 to High(_DrawOrder[FrameIndex]) do
    Skeleton.DrawOrder[i] := Skeleton.Slots[_DrawOrder[FrameIndex][i]];
  end;
end;
//TSpineAnimationDrawOrderTimeline END

//TSpineAnimationFFDTimeline BEGIN
constructor TSpineAnimationFFDTimeline.Create(const AFrameCount: Integer);
begin
  inherited Create(AFrameCount);
  SetLength(_Frames, AFrameCount);
  SetLength(_FrameVertices, AFrameCount);
end;

procedure TSpineAnimationFFDTimeline.SetFrame(const FrameIndex: Integer; const Time: Single; const AVertices: TSpineFloatArray);
begin
  _Frames[FrameIndex] := Time;
  SetLength(_FrameVertices[FrameIndex], Length(AVertices));
  Move(AVertices[0], _FrameVertices[FrameIndex][0], Length(AVertices) * SizeOf(Single));
end;

procedure TSpineAnimationFFDTimeline.Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single);
  var Slot: TSpineSlot;
  var i, VertexCount, FrameIndex: Integer;
  var a, f, FrameTime, Percent, pv, v, dv: Single;
  var LastVertices, PrevVertices, NextVertices: PSpineFloatArray;
begin
  Slot := Skeleton.Slots[SlotIndex];
  if Slot.Attachment <> _Attachment then Exit;
  if Time < _Frames[0] then Exit;
  VertexCount := Length(_FrameVertices[0]);
  if Length(Slot.AttachmentVertices) < VertexCount then
  SetLength(Slot.AttachmentVerticesPtr^, VertexCount);
  a := Alpha;
  if Length(Slot.AttachmentVertices) <> VertexCount then a := 1;
  Slot.AttachmentVertexCount := VertexCount;
  if Time >= _Frames[High(_Frames)] then
  begin
    LastVertices := @_FrameVertices[High(_Frames)];
    if a < 1 then
    begin
      for i := 0 to VertexCount - 1 do
      begin
	v := Slot.AttachmentVertices[i];
	Slot.AttachmentVertices[i] := v + (LastVertices^[i] - v) * a;
      end;
    end
    else
    begin
      Move(LastVertices^[0], Slot.AttachmentVerticesPtr^[0], VertexCount * SizeOf(Single));
    end;
    Exit;
  end;
  FrameIndex := TSpineAnimation.BinarySearch(_Frames, Time);
  FrameTime := _Frames[FrameIndex];
  dv := _Frames[FrameIndex - 1] - FrameTime;
  if dv = 0 then Percent := 0 else Percent := 1 - (Time - FrameTime) / dv;
  if Percent < 0 then Percent := 0 else if Percent > 1 then Percent := 1;
  Percent := GetCurvePercent(FrameIndex - 1, Percent);
  PrevVertices := @_FrameVertices[FrameIndex - 1];
  NextVertices := @_FrameVertices[FrameIndex];
  if a < 1 then
  begin
    for i := 0 to VertexCount - 1 do
    begin
      pv := PrevVertices^[i];
      v := Slot.AttachmentVertices[i];
      Slot.AttachmentVertices[i] := v + (pv + (NextVertices^[i] - pv) * Percent - v) * a;
    end;
  end
  else
  begin
    for i := 0 to VertexCount - 1 do
    begin
      pv := PrevVertices^[i];
      Slot.AttachmentVertices[i] := pv + (NextVertices^[i] - pv) * Percent;
    end;
  end;
end;
//TSpineAnimationFFDTimeline END

//TSpineAnimationIKConstraintTimeline BEGIN
constructor TSpineAnimationIKConstraintTimeline.Create(const AFrameCount: Integer);
begin
  inherited Create(AFrameCount);
  SetLength(_Frames, AFrameCount * 3);
end;

procedure TSpineAnimationIKConstraintTimeline.SetFrame(const FrameIndex: Integer; const Time, Mix: Single; const BendDirection: Integer);
  var i: Integer;
begin
  i := FrameIndex * 3;
  _Frames[i] := Time;
  _Frames[i + 1] := Mix;
  _Frames[i + 2] := PSingle(@BendDirection)^;
end;

procedure TSpineAnimationIKConstraintTimeline.Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single);
  var Constraint: TSpineIKConstraint;
  var FrameIndex: Integer;
  var PrevFrameMix, FrameTime, Percent, Mix, dv: Single;
begin
  if Time < _Frames[0] then Exit;
  Constraint := Skeleton.IKConstraints[_IKConstraintIndex];
  if Time >= _Frames[High(_Frames)] then
  begin
    Constraint.Mix := Constraint.Mix + ((_Frames[Length(_Frames) - 2] - Constraint.Mix) * Alpha);
    Constraint.BendDirection := PInteger(@_Frames[Length(_Frames) - 1])^;
    Exit;
  end;
  FrameIndex := TSpineAnimation.BinarySearch(_Frames, Time, 3);
  PrevFrameMix := _Frames[FrameIndex + PREV_FRAME_MIX];
  FrameTime := _Frames[FrameIndex];
  dv := _Frames[FrameIndex + PREV_FRAME_TIME] - FrameTime;
  if dv = 0 then Percent := 0 else Percent := 1 - (Time - FrameTime) / dv;
  if Percent < 0 then Percent := 0 else if Percent > 1 then Percent := 1;
  Percent := GetCurvePercent(FrameIndex div 3 - 1, Percent);
  Mix := PrevFrameMix + (_Frames[FrameIndex + FRAME_MIX] - PrevFrameMix) * Percent;
  Constraint.Mix := Constraint.Mix + ((Mix - Constraint.Mix) * Alpha);
  Constraint.BendDirection := PInteger(@_Frames[FrameIndex + PREV_FRAME_BEND_DIRECTION])^;
end;
//TSpineAnimationIKConstraintTimeline END

//TSpineAnimationFlipXTimeline BEGIN
function TSpineAnimationFlipXTimeline.GetFrameCount: Integer;
begin
  Result := Length(_Frames) shr 1;
end;

procedure TSpineAnimationFlipXTimeline.SetFlip(const Bone: TSpineBone; const Flip: Boolean);
begin
  Bone.FlipX := Flip;
end;

constructor TSpineAnimationFlipXTimeline.Create(const AFrameCount: Integer);
begin
  SetLength(_Frames, AFrameCount shl 1);
end;

procedure TSpineAnimationFlipXTimeline.SetFrame(const FrameIndex: Integer; const Time: Single; const Flip: Boolean);
  var i: Integer;
  var fb: Single;
begin
  i := FrameIndex * 2;
  _Frames[i] := Time;
  if Flip then _Frames[i + 1] := 1
  else _Frames[i + 1] := 0;
end;

procedure TSpineAnimationFlipXTimeline.Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single);
  var tl: Single;
  var FrameIndex: Integer;
begin
  tl := LastTime;
  if Time < _Frames[0] then
  begin
    if tl > Time then Apply(Skeleton, tl, 1E+16, nil, 0);
    Exit;
  end
  else if tl > Time then
  begin
    tl := -1;
  end;
  if Time >= _Frames[Length(_Frames) - 2] then
  FrameIndex := Length(_Frames)
  else
  FrameIndex := TSpineAnimation.BinarySearch(_Frames, Time, 2) - 2;
  if _Frames[FrameIndex] < tl then Exit;
  SetFlip(Skeleton.Bones[BoneIndex], _Frames[FrameIndex + 1] > 0.5);
end;
//TSpineAnimationFlipXTimeline END

//TSpineAnimationFlipYTimeline BEGIN
procedure TSpineAnimationFlipYTimeline.SetFlip(const Bone: TSpineBone; const Flip: Boolean);
begin
  Bone.FlipY := Flip;
end;
//TSpineAnimationFlipYTimeline END

//TSpineAnimation BEGIN
constructor TSpineAnimation.Create(const AName: String; const ATimelines: TSpineTimelineList; const ADuration: Single);
begin
  _Name := AName;
  _Timelines := ATimelines;
  _Duration := ADuration;
end;

procedure TSpineAnimation.Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Loop: Boolean; const Events: TSpineEventList);
  var t, tl: Single;
  var i: Integer;
begin
  t := Time; tl := LastTime;
  if Skeleton = nil then Exit;
  if Loop and (_Duration > 0) then
  begin
    t := SpineModFloat(t, _Duration);
    tl := SpineModFloat(tl, _Duration);
  end;
  for i := 0 to _Timelines.Count - 1 do
  begin
    _Timelines[i].Apply(Skeleton, tl, t, Events, 1);
  end;
end;

procedure TSpineAnimation.Mix(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Loop: Boolean; const Events: TSpineEventList; const Alpha: Single);
  var t, tl: Single;
  var i: Integer;
begin
  if Skeleton = nil then Exit;
  t := Time; tl := LastTime;
  if Loop and (_Duration > 0) then
  begin
    t := SpineModFloat(t, _Duration);
    tl := SpineModFloat(tl, _Duration);
  end;
  for i := 0 to _Timelines.Count - 1 do
  _Timelines[i].Apply(Skeleton, tl, t, Events, Alpha);
end;

class function TSpineAnimation.BinarySearch(const Values: TSpineFloatArray; const Target: Single; const Step: Integer): Integer;
  var l, h, c: Integer;
begin
  l := 0;
  h := Length(Values) div Step - 2;
  if h = 0 then Exit(Step);
  c := h shr 1;
  while True do
  begin
    if (Values[(c + 1) * Step] <= Target) then l := c + 1
    else h := c;
    if (l = h) then Exit((l + 1) * Step);
    c := (l + h) shr 1;
  end;
end;

class function TSpineAnimation.BinarySearch(const Values: TSpineFloatArray; const Target: Single): Integer;
  var l, h, c: Integer;
begin
  l := 0;
  h := Length(Values) - 2;
  if h = 0 then Exit(1);
  c := h shr 1;
  while True do
  begin
    if Values[(c + 1)] <= Target then
    l := c + 1
    else
    h := c;
    if l = h then Exit(l + 1);
    c := (l + h) shr 1;
  end;
end;

class function TSpineAnimation.LinearSearch(const Values: TSpineFloatArray; const Target: Single; const Step: Integer): Integer;
  var i: Integer;
begin
  i := 0;
  while i <= Length(Values) - Step do
  begin
    if Values[i] > Target then Exit(i);
    Inc(i, Step);
  end;
  Result := -1;
end;
//TSpineAnimation END

//TSpineAnimationTrackEntry BEGIN
procedure TSpineAnimationTrackEntry.ProcStart(const State: TSpineAnimationState; const Index: Integer);
begin
  if Assigned(_OnStart) then _OnStart(State, Index);
end;

procedure TSpineAnimationTrackEntry.ProcEnd(const State: TSpineAnimationState; const Index: Integer);
begin
  if Assigned(_OnEnd) then _OnEnd(State, Index);
end;

procedure TSpineAnimationTrackEntry.ProcEvent(const State: TSpineAnimationState; const Index: Integer; const Event: TSpineEvent);
begin
  if Assigned(_OnEvent) then _OnEvent(State, Index, Event);
end;

procedure TSpineAnimationTrackEntry.ProcComplete(const State: TSpineAnimationState; const Index, LoopCount: Integer);
begin
  if Assigned(_OnComplete) then _OnComplete(State, Index, LoopCount);
end;

constructor TSpineAnimationTrackEntry.Create(const AState: TSpineAnimationState; const AAnimation: TSpineAnimation);
begin
  _Prev := nil;
  _Next := nil;
  _State := AState;
  _Animation := AAnimation;
  _Loop := False;
  _Delay := 0;
  _Time := 0;
  _EndTime := 0;
  _LastTime := -1;
  _TimeScale := 1;
  _Mix := 1;
  _MixTime := 0;
  _MixDuration := 0;
end;

destructor TSpineAnimationTrackEntry.Destroy;
begin
  inherited Destroy;
end;
//TSpineAnimationTrackEntry END

//TSpineAnimationState BEGIN
function TSpineAnimationState.ExpandToIndex(const Index: Integer): TSpineAnimationTrackEntry;
begin
  if (Index < _Tracks.Count) then Exit(_Tracks.Items[Index]);
  while (Index >= _Tracks.Count) do _Tracks.Add(nil);
  Result := nil;
end;

procedure TSpineAnimationState.SetCurrent(const Index: Integer; const Entry: TSpineAnimationTrackEntry);
  var Track, Prev: TSpineAnimationTrackEntry;
  var dv: Single;
begin
  Track := ExpandToIndex(Index);
  if Assigned(Track) then
  begin
    Prev := Track.Prev;
    Track.Prev := nil;
    Track.ProcEnd(Self, Index);
    if Assigned(_OnEnd) then _OnEnd(Self, Index);
    Entry.MixDuration := _Data.GetMix(Track.Animation, Entry.Animation);
    if Entry.MixDuration > 0 then
    begin
      Entry.MixTime := 0;
      if Track.MixDuration = 0 then dv := 1 else dv := Track.MixDuration;
      if Assigned(Prev) and (Track.MixTime / dv < 0.5) then
      Entry.Prev := Prev
      else
      Entry.Prev := Track;
    end;
  end;
  _Tracks[Index] := Entry;
  Entry.ProcStart(Self, Index);
  if Assigned(_OnStart) then _OnStart(Self, Index);
end;

constructor TSpineAnimationState.Create(const AData: TSpineAnimationStateData);
begin
  _Tracks := TSpineAnimationTrackEntryList.Create;
  _Events := TSpineEventList.Create;
  _Data := AData;
  _Data.RefInc;
end;

destructor TSpineAnimationState.Destroy;
begin
  _Data.RefDec;
  _Events.Free;
  _Tracks.Free;
  inherited Destroy;
end;

procedure TSpineAnimationState.Update(const Delta: Single);
  var dt, tdt, t, te: Single;
  var i, n: Integer;
  var Track: TSpineAnimationTrackEntry;
begin
  dt := Delta * _TimeScale;
  for i := 0 to _Tracks.Count - 1 do
  begin
    Track := _Tracks[i];
    if Track = nil then Continue;
    tdt := dt * Track.TimeScale;
    t := Track.Time + tdt;
    te := Track.EndTime;
    Track.Time := t;
    if (Track.Prev <> nil) then
    begin
      Track.Prev.Time := Track.Prev.Time + tdt;
      Track.MixTime := Track.MixTime + tdt;
    end;
    if (
      Track.Loop and (SpineModFloat(Track.LastTime, te) > SpineModFloat(t, te))
    ) or (
      not Track.Loop and (Track.LastTime < te) and (t >= te)
    ) then
    begin
      if te = 0 then n := 0 else n := Trunc(t / te);
      Track.ProcComplete(Self, i, n);
      if Assigned(_OnComplete) then _OnComplete(Self, i, n);
    end;
    if Track.Next <> nil then
    begin
      Track.Next.Time := Track.LastTime - Track.Next.Delay;
      if Track.Next.Time >= 0 then SetCurrent(i, Track.Next);
    end
    else
    begin
      if not Track.Loop and (Track.LastTime >= Track.EndTime) then ClearTrack(i);
    end;
  end;
end;

procedure TSpineAnimationState.Apply(const Skeleton: TSpineSkeleton);
  var i, j: Integer;
  var t, pt, a: Single;
  var Track: TSpineAnimationTrackEntry;
begin
  for i := 0 to _Tracks.Count - 1 do
  begin
    Track := _Tracks[i];
    if Track = nil then Continue;
    _Events.Clear;
    t := Track.Time;
    if not Track.Loop and (t > Track.EndTime) then t := Track.EndTime;
    if Track.Prev = nil then
    begin
      if Track.Mix = 1 then
      Track.Animation.Apply(Skeleton, Track.LastTime, t, Track.Loop, _Events)
      else
      Track.Animation.Mix(Skeleton, Track.LastTime, t, Track.Loop, _Events, Track.Mix);
    end
    else
    begin
      pt := Track.Prev.Time;
      if not Track.Prev.Loop and (pt > Track.Prev.EndTime) then pt := Track.Prev.EndTime;
      Track.Animation.Apply(Skeleton, pt, pt, Track.Prev.Loop, nil);
      if Track.MixDuration = 0 then a := 0 else a := Track.MixTime / Track.MixDuration * Track.Mix;
      if a >= 1 then
      begin
        a := 1;
        Track.Prev.RefDec;
        Track.Prev := nil;
      end;
      Track.Animation.Mix(Skeleton, Track.LastTime, t, Track.Loop, _Events, a);
    end;
    for j := 0 to _Events.Count - 1 do
    begin
      Track.ProcEvent(Self, i, _Events[j]);
      if Assigned(_OnEvent) then _OnEvent(Self, i, _Events[j]);
    end;
    Track.LastTime := Track.Time;
  end;
end;

procedure TSpineAnimationState.ClearTracks;
  var i: Integer;
begin
  for i := 0 to _Tracks.Count - 1 do ClearTrack(i);
  _Tracks.Clear;
end;

procedure TSpineAnimationState.ClearTrack(const TrackIndex: Integer);
  var Track: TSpineAnimationTrackEntry;
begin
  if (TrackIndex >= _Tracks.Count) then Exit;
  Track := _Tracks.Items[TrackIndex];
  if (Track = nil) then Exit;
  Track.ProcEnd(Self, TrackIndex);
  if Assigned(_OnEnd) then _OnEnd(Self, TrackIndex);
  _Tracks[TrackIndex] := nil;
end;

function TSpineAnimationState.SetAnimation(const TrackIndex: Integer; const AnimationName: String; const Loop: Boolean): TSpineAnimationTrackEntry;
  var Anim: TSpineAnimation;
begin
  Anim := _Data.SkeletonData.FindAnimation(AnimationName);
  if Assigned(Anim) then
  Result := SetAnimation(TrackIndex, Anim, Loop)
  else
  Result := nil;
end;

function TSpineAnimationState.SetAnimation(const TrackIndex: Integer; const Animation: TSpineAnimation; const Loop: Boolean): TSpineAnimationTrackEntry;
  var Entry: TSpineAnimationTrackEntry;
begin
  if Animation = nil then Exit(nil);
  Entry := TSpineAnimationTrackEntry.Create(Self, Animation);
  Entry.Loop := Loop;
  Entry.Time := 0;
  Entry.EndTime := Animation.Duration;
  SetCurrent(TrackIndex, Entry);
  Entry.RefDec;
  Result := Entry;
end;

function TSpineAnimationState.AddAnimation(const TrackIndex: Integer; const AnimationName: String; const Loop: Boolean; const Delay: Single): TSpineAnimationTrackEntry;
  var Anim: TSpineAnimation;
begin
  Anim := _Data.SkeletonData.FindAnimation(AnimationName);
  if Assigned(Anim) then
  Result := AddAnimation(TrackIndex, Anim, Loop, Delay)
  else
  Result := nil;
end;

function TSpineAnimationState.AddAnimation(const TrackIndex: Integer; const Animation: TSpineAnimation; const Loop: Boolean; const Delay: Single): TSpineAnimationTrackEntry;
  var Entry, Last: TSpineAnimationTrackEntry;
  var d: Single;
begin
  if not Assigned(Animation) then Exit(nil);
  Entry := TSpineAnimationTrackEntry.Create(Self, Animation);
  Entry.Loop := Loop;
  Entry.Time := 0;
  Entry.EndTime := Animation.Duration;
  Last := ExpandToIndex(TrackIndex);
  if Assigned(Last) then
  begin
    while Assigned(Last.Next) do Last := Last.Next;
    Last.Next := Entry;
  end
  else
  begin
    _Tracks[TrackIndex] := Entry;
    Entry.RefDec;
  end;
  d := Delay;
  if (d <= 0) then
  begin
    if Assigned(Last) then
    d += Last.EndTime - _Data.GetMix(Last.Animation, Animation)
    else
    d := 0;
  end;
  Entry.Delay := d;
  Result := Entry;
end;

function TSpineAnimationState.GetCurrent(const TrackIndex: Integer): TSpineAnimationTrackEntry;
begin
  if TrackIndex >= _Tracks.Count then Exit(nil);
  Result := _Tracks[TrackIndex];
end;
//TSpineAnimationState END

//TSpineAnimationStateData BEGIN
constructor TSpineAnimationStateData.Create(const ASkeletonData: TSpineSkeletonData);
begin
  _SkeletonData := ASkeletonData;
  _SkeletonData.RefInc;
  _MixTime := TSpineAnimationMix0List.Create;
end;

destructor TSpineAnimationStateData.Destroy;
  var i, j: Integer;
begin
  for i := 0 to _MixTime.Count - 1 do
  begin
    for j := 0 to _MixTime[i].MixEnties.Count - 1 do
    begin
      _MixTime[i].MixEnties[j].Free;
    end;
    _MixTime[i].MixEnties.Free;
    _MixTime[i].Free;
  end;
  _MixTime.Free;
  _SkeletonData.RefDec;
  inherited Destroy;
end;

procedure TSpineAnimationStateData.SetMix(const FromName, ToName: String; const Duration: Single);
  var AnimFrom, AnimTo: TSpineAnimation;
begin
  AnimFrom := _SkeletonData.FindAnimation(FromName);
  if AnimFrom = nil then Exit;
  AnimTo := _SkeletonData.FindAnimation(ToName);
  if AnimTo = nil then Exit;
  SetMix(AnimFrom, AnimTo, Duration);
end;

procedure TSpineAnimationStateData.SetMix(const AnimFrom, AnimTo: TSpineAnimation; const Duration: Single);
  var Mix0: TSpineAnimationMix0;
  var Mix1: TSpineAnimationMix1;
  var i, j: Integer;
begin
  if (AnimFrom = nil) or (AnimTo = nil) then Exit;
  for i := 0 to _MixTime.Count - 1 do
  if _MixTime[i].Anim = AnimFrom then
  begin
    for j := 0 to _MixTime[i].MixEnties.Count - 1 do
    if _MixTime[i].MixEnties[j].Anim = AnimTo then
    begin
      _MixTime[i].MixEnties[j].Duration := Duration;
      Exit;
    end;
    Mix1 := TSpineAnimationMix1.Create;
    Mix1.Anim := AnimTo;
    Mix1.Duration := Duration;
    _MixTime[i].MixEnties.Add(Mix1);
  end;
  Mix0 := TSpineAnimationMix0.Create;
  Mix0.MixEnties := TSpineAnimationMix1List.Create;
  Mix0.Anim := AnimFrom;
  Mix1 := TSpineAnimationMix1.Create;
  Mix1.Anim := AnimTo;
  Mix1.Duration := Duration;
  _MixTime.Add(Mix0);
end;

function TSpineAnimationStateData.GetMix(const AnimFrom, AnimTo: TSpineAnimation): Single;
  var i, j: Integer;
begin
  for i := 0 to _MixTime.Count - 1 do
  if _MixTime[i].Anim = AnimFrom then
  begin
    for j := 0 to _MixTime[i].MixEnties.Count - 1 do
    if _MixTime[i].MixEnties[j].Anim = AnimTo then
    Exit(_MixTime[i].MixEnties[j].Duration);
  end;
  Result := _DefaultMix;
end;
//TSpineAnimationStateData END

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
  _Polygons.Free;
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
    if _PolygonPool.Count > 0 then
    begin
      Polygon := _PolygonPool.Last;
      _PolygonPool.Delete(_PolygonPool.Count - 1);
    end
    else
    begin
      Polygon := TSpinePolygon.Create;
    end;
    _Polygons.Add(Polygon);
    Polygon.Count := Length(BoundingBox.Vertices);
    if Length(Polygon.Vertices) < Polygon.Count then
    SetLength(Polygon.VerticesPtr^, Polygon.Count);
    BoundingBox.ComputeWorldVertices(Slot.Bone, Polygon.VerticesPtr^);
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
    if ((VertexY < y) and (PrevY >= y) or (PrevY < y) and (VertexY >= y)) then
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
  var w12, h12, w34, h34, det1, det2, det3, x3, y3, x4, y4, x, y: Single;
  var i: Integer;
begin
  w12 := x1 - x2; h12 := y1 - y2;
  det1 := x1 * y2 - y1 * x2;
  x3 := Polygon.Vertices[Polygon.Count - 2];
  y3 := Polygon.Vertices[Polygon.Count - 1];
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
  if (Bone.WorldFlipX <> (Bone.WorldFlipY <> TSpineBone.YDown)) then RotationIK := -RotationIK;
  if Bone.Data.InheritRotation and Assigned(Bone.Parent) then RotationIK -= Bone.Parent.WorldRotation;
  Bone.RotationIK := Rotation + (RotationIK - Rotation) * Alpha;
end;

class procedure TSpineIKConstraint.Apply(var Parent, Child: TSpineBone; const TargetX, TargetY, Alpha: Single; const ABendDirection: Integer);
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
    NewTargetY -= Parent.y;
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
    Child.RotationIK := Child.Rotation + (SpineArcTan2(TargetY, TargetX) * SP_RAD_TO_DEG - Parent.Rotation - Child.Rotation) * Alpha;
    Exit;
  end;
  c := (NewTargetX * NewTargetX + NewTargetY * NewTargetY - Len1 * Len1 - Len2 * Len2) / CosDenom;
  if c < -1 then c := -1
  else if c > 1 then c := 1;
  ChildAngle := SpineArcCos(c) * ABendDirection;
  Adjacent := Len1 + Len2 * c;
  Opposite := Len2 * Sin(ChildAngle);
  ParentAngle := SpineArcTan2(NewTargetY * Adjacent - NewTargetX * Opposite, NewTargetX * Adjacent + NewTargetY * Opposite);
  Rotation := (ParentAngle - Offset) * SP_RAD_TO_DEG - Parent.Rotation;
  if Rotation > 180 then Rotation -= 360
  else if Rotation < -180 then Rotation += 360;
  Parent.RotationIK := Parent.Rotation + Rotation * Alpha;
  Rotation := (ChildAngle + Offset) * SP_RAD_TO_DEG - Child.Rotation;
  if Rotation > 180 then Rotation -= 360
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
  _BendDirection := _Data.BendDirection;
  for i := 0 to _Data.Bones.Count - 1 do
  _Bones.Add(ASkeleton.FindBone(_Data.Bones[i].Name));
  _Target := ASkeleton.FindBone(_Data.Target.Name);
end;

destructor TSpineIKConstraint.Destroy;
begin
  _Bones.Free;
  _Data.RefDec;
  inherited Destroy;
end;

procedure TSpineIKConstraint.Apply;
begin
  case _Bones.Count of
    1: Apply(_Bones.ItemPtr[0]^, _Target.WorldX, _Target.WorldY, _Mix);
    2: Apply(_Bones.ItemPtr[0]^, _Bones.ItemPtr[1]^, _Target.WorldX, _Target.WorldY, _Mix, _BendDirection);
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

//TSpineAtlas BEGIN
constructor TSpineAtlas.Create(const Path: String);
begin
  _Pages := TSpineAtlasPageList.Create;
  _Regions := TSpineAtlasRegionList.Create;
  Load(Path);
end;

destructor TSpineAtlas.Destroy;
begin
  _Regions.Free;
  _Pages.Free;
  inherited Destroy;
end;

procedure TSpineAtlas.Load(const Path: String);
  function Trim(const Str: String): String;
    var i, n: Integer;
  begin
    Result := Str;
    n := 0;
    for i := 1 to Length(Result) do
    if Result[i] <> ' ' then
    begin
      n := i - 1;
      Break;
    end;
    if n > 0 then
    Delete(Result, 1, n);
    for i := Length(Result) downto 1 do
    if Result[i] <> ' ' then
    begin
      n := i + 1;
      Break;
    end;
    if n < Length(Result) then
    Delete(Result, n, Length(Result) - n);
  end;
  var Dir: String;
  var Provider: TSpineDataProvider;
  var Param: String;
  var Value: array[0..3] of String;
  var vn: Integer;
  function IsEOF: Boolean;
  begin
    Result := Provider.Pos >= Provider.Size;
  end;
  function ReadLine: String;
    var i, n: Integer;
  begin
    i := Provider.Pos;
    while (
      (i < Provider.Size)
      and (AnsiChar(Provider.Data^[i]) <> #$D)
      and (AnsiChar(Provider.Data^[i]) <> #$A)
    ) do Inc(i);
    n := i;
    if (
      (AnsiChar(Provider.Data^[i]) = #$D)
      and (i + 1 < Provider.Size)
      and (AnsiChar(Provider.Data^[i + 1]) = #$A)
    ) then Inc(i);
    Inc(i);
    n := n - Provider.Pos;
    if n > 0 then
    begin
      SetLength(Result, n);
      if n > 0 then Provider.Read(@Result[1], n);
    end
    else
    begin
      Result := '';
    end;
    Provider.Pos := i;
  end;
  procedure ReadValue;
    var i, p, n: Integer;
    var Line: String;
  begin
    Line := ReadLine;
    Param := '';
    vn := 0;
    p := 1;
    for i := 1 to Length(Line) do
    if Line[i] = ':' then
    begin
      n := i - p;
      if n > 0 then
      Param := Trim(Copy(Line, p, n));
      p := i + 1;
    end
    else if Line[i] = ',' then
    begin
      n := i - p;
      if n > 0 then
      Value[vn] := Trim(Copy(Line, p, n));
      p := i + 1;
      Inc(vn);
    end;
    n := Length(Line) - p + 1;
    if (n > 0) and (Length(Param) > 0) then
    begin
      Value[vn] := Trim(Copy(Line, p, n));
      Inc(vn);
    end;
    if Length(Param) = 0 then Param := Trim(Line);
  end;
  var Page: TSpineAtlasPage;
  var Region: TSpineAtlasRegion;
  var i: Integer;
begin
  Clear;
  Dir := ExtractFileDir(Path);
  Provider := SpineDataProvider.FetchData(Path);
  if Provider = nil then Exit;
  Page := nil;
  Region := nil;
  while not IsEOF do
  begin
    ReadValue;
    if Length(Param) = 0 then
    begin
      Page := nil;
      Region := nil;
    end
    else
    begin
      if Page = nil then
      begin
        Page := TSpineAtlasPage.Create;
        Page.Name := Param;
        Page.Texture := SpineDataProvider.FetchTexture(Dir + Param);
        _Pages.Add(Page);
        Page.Free;
      end
      else if vn = 0 then
      begin
        Region := TSpineAtlasRegion.Create;
        Region.Name := Param;
        Region.Page := Page;
        _Regions.Add(Region);
        Region.Free;
      end
      else if Assigned(Region) then
      begin
        if Param = 'rotate' then
        begin
          Region.Rotate := LowerCase(Value[0]) = 'true';
        end
        else if Param = 'xy' then
        begin
          Region.x := StrToIntDef(Value[0], 0);
          Region.y := StrToIntDef(Value[1], 0);
        end
        else if Param = 'size' then
        begin
          Region.w := StrToIntDef(Value[0], 0);
          Region.h := StrToIntDef(Value[1], 0);
        end
        else if Param = 'split' then
        begin
          SetLength(Region.Splits, 4);
          Region.Splits[0] := StrToIntDef(Value[0], 0);
          Region.Splits[1] := StrToIntDef(Value[1], 0);
          Region.Splits[2] := StrToIntDef(Value[2], 0);
          Region.Splits[3] := StrToIntDef(Value[3], 0);
        end
        else if Param = 'pad' then
        begin
          SetLength(Region.Pads, 4);
          Region.Pads[0] := StrToIntDef(Value[0], 0);
          Region.Pads[1] := StrToIntDef(Value[1], 0);
          Region.Pads[2] := StrToIntDef(Value[2], 0);
          Region.Pads[3] := StrToIntDef(Value[3], 0);
        end
        else if Param = 'orig' then
        begin
          Region.OriginalWidth := StrToIntDef(Value[0], 0);
          Region.OriginalHeight := StrToIntDef(Value[1], 0);
        end
        else if Param = 'offset' then
        begin
          Region.OffsetX := StrToIntDef(Value[0], 0);
          Region.OffsetY := StrToIntDef(Value[1], 0);
        end
        else if Param = 'index' then
        begin
          Region.Index := StrToIntDef(Value[0], 0);
        end;
      end
      else
      begin
        if Param = 'size' then
        begin
          Page.Width := StrToIntDef(Value[0], 0);
          Page.Height := StrToIntDef(Value[1], 0);
        end
        else if Param = 'format' then
        begin
          if LowerCase(Value[0]) = 'alpha' then
          Page.Format := sp_af_alpha
          else if LowerCase(Value[0]) = 'intensity' then
          Page.Format := sp_af_intensity
          else if LowerCase(Value[0]) = 'luminancealpha' then
          Page.Format := sp_af_luminance_alpha
          else if LowerCase(Value[0]) = 'rgb565' then
          Page.Format := sp_af_rgb565
          else if LowerCase(Value[0]) = 'rgb888' then
          Page.Format := sp_af_rgb888
          else if LowerCase(Value[0]) = 'rgba4444' then
          Page.Format := sp_af_rgba4444
          else
          Page.Format := sp_af_rgba8888;
        end
        else if Param = 'filter' then
        begin
          if LowerCase(Value[0]) = 'nearest' then
          Page.MinFilter := sp_tf_nearest
          else if LowerCase(Value[0]) = 'linear' then
          Page.MinFilter := sp_tf_linear
          else
          Page.MinFilter := sp_tf_mip_map;
          if LowerCase(Value[1]) = 'nearest' then
          Page.MagFilter := sp_tf_nearest
          else if LowerCase(Value[1]) = 'linear' then
          Page.MagFilter := sp_tf_linear
          else
          Page.MagFilter := sp_tf_mip_map;
        end
        else if Param = 'repeat' then
        begin
          if Value[0] = 'xy' then
          begin
            Page.WrapU := sp_apw_repeat;
            Page.WrapV := sp_apw_repeat;
          end
          else if Value[0] = 'x' then
          begin
            Page.WrapU := sp_apw_repeat;
            Page.WrapV := sp_apw_clamp;
          end
          else if Value[0] = 'y' then
          begin
            Page.WrapU := sp_apw_clamp;
            Page.WrapV := sp_apw_repeat;
          end
          else
          begin
            Page.WrapU := sp_apw_clamp;
            Page.WrapV := sp_apw_clamp;
          end;
        end;
      end;
    end;
  end;
  for i := 0 to _Regions.Count - 1 do
  begin
    Region := _Regions[i];
    Region.u := Region.x / Region.Page.Width;
    Region.v := Region.y / Region.Page.Height;
    if Region.Rotate then
    begin
      Region.u2 := (Region.x + Region.h) / Region.Page.Width;
      Region.v2 := (Region.y + Region.w) / Region.Page.Height;
    end
    else
    begin
      Region.u2 := (Region.x + Region.w) / Region.Page.Width;
      Region.v2 := (Region.y + Region.h) / Region.Page.Height;
    end;
    Region.w := Abs(Region.w);
    Region.h := Abs(Region.h);
  end;
  Provider.Free;
end;

procedure TSpineAtlas.Clear;
  var i: Integer;
begin
  for i := 0 to _Regions.Count - 1 do
  _Regions[i].RefDec;
  for i := 0 to _Pages.Count - 1 do
  begin
    if Assigned(_Pages[i].Texture) then
    _Pages[i].Texture.RefDec;
    _Pages[i].RefDec;
  end;
  _Regions.Clear;
  _Pages.Clear;
end;

procedure TSpineAtlas.FlipV;
  var i: Integer;
begin
  for i := 0 to _Regions.Count - 1 do
  begin
    _Regions[i].v := 1 - _Regions[i].v;
    _Regions[i].v2 := 1 - _Regions[i].v2;
  end;
end;

function TSpineAtlas.FindRegion(const Name: String): TSpineAtlasRegion;
  var i: Integer;
begin
  for i := 0 to _Regions.Count - 1 do
  if _Regions[i].Name = Name then Exit(_Regions[i]);
  Result := nil;
end;
//TSpineAtlas END

//TSpineAttachment BEGIN
constructor TSpineAttachment.Create(const AName: String);
begin
  inherited Create;
  _Name := AName;
end;

procedure TSpineAttachment.Draw(const Render: TSpineRender; const Slot: TSpineSlot);
begin

end;
//TSpineAttachment END

//TSpineRegionAttachment BEGIN
function TSpineRegionAttachment.GetOffset(const Index: Integer): Single;
begin
  Result := _Offset[Index];
end;

procedure TSpineRegionAttachment.SetTexture(const Value: TSpineTexture);
begin
  if _Texture = Value then Exit;
  if Assigned(_Texture) then _Texture.RefDec;
  _Texture := Value;
  if Assigned(_Texture) then _Texture.RefInc;
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
  _Texture := nil;
end;

destructor TSpineRegionAttachment.Destroy;
begin
  Texture := nil;
  inherited Destroy;
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
  TempLocalX := -_Width * 0.5 * _ScaleX + _RegionOffsetX * TempRegionScaleX;
  TempLocalY := -_Height * 0.5 * _ScaleY + _RegionOffsetY * TempRegionScaleY;
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
  var tx, ty, sx, sy: Single;
  var m00, m01, m10, m11: Single;
begin
  tx := Bone.Skeleton.x; ty := Bone.Skeleton.y;
  sx := Bone.Skeleton.ScaleX; sy := Bone.Skeleton.ScaleY;
  m00 := Bone.m00;
  m01 := Bone.m01;
  m10 := Bone.m10;
  m11 := Bone.m11;
  OutWorldVertices[SP_VERTEX_X1] := (_Offset[SP_VERTEX_X1] * m00 + _Offset[SP_VERTEX_Y1] * m01 + Bone.WorldX) * sx + tx;
  OutWorldVertices[SP_VERTEX_Y1] := (_Offset[SP_VERTEX_X1] * m10 + _Offset[SP_VERTEX_Y1] * m11 + Bone.WorldY) * sy + ty;
  OutWorldVertices[SP_VERTEX_X2] := (_Offset[SP_VERTEX_X2] * m00 + _Offset[SP_VERTEX_Y2] * m01 + Bone.WorldX) * sx + tx;
  OutWorldVertices[SP_VERTEX_Y2] := (_Offset[SP_VERTEX_X2] * m10 + _Offset[SP_VERTEX_Y2] * m11 + Bone.WorldY) * sy + ty;
  OutWorldVertices[SP_VERTEX_X3] := (_Offset[SP_VERTEX_X3] * m00 + _Offset[SP_VERTEX_Y3] * m01 + Bone.WorldX) * sx + tx;
  OutWorldVertices[SP_VERTEX_Y3] := (_Offset[SP_VERTEX_X3] * m10 + _Offset[SP_VERTEX_Y3] * m11 + Bone.WorldY) * sy + ty;
  OutWorldVertices[SP_VERTEX_X4] := (_Offset[SP_VERTEX_X4] * m00 + _Offset[SP_VERTEX_Y4] * m01 + Bone.WorldX) * sx + tx;
  OutWorldVertices[SP_VERTEX_Y4] := (_Offset[SP_VERTEX_X4] * m10 + _Offset[SP_VERTEX_Y4] * m11 + Bone.WorldY) * sy + ty;
end;

procedure TSpineRegionAttachment.Draw(const Render: TSpineRender; const Slot: TSpineSlot);
  var v: TSpineRegionVertices;
  var rv: array[0..3] of TSpineVertexData;
  var i: Integer;
begin
  ComputeWorldVertices(Slot.Bone, v);
  for i := 0 to 3 do
  begin
    rv[i].x := v[i * 2 + 0];
    rv[i].y := v[i * 2 + 1];
    rv[i].u := _UV[i * 2 + 0];
    rv[i].v := _UV[i * 2 + 1];
    rv[i].r := _r;
    rv[i].g := _g;
    rv[i].b := _b;
    rv[i].a := _a;
  end;
  Render.RenderQuad(_Texture, @rv);
end;
//TSpineRegionAttachment END

//TSpineBoundingBoxAttachment BEGIN
constructor TSpineBoundingBoxAttachment.Create(const AName: String);
begin
  inherited Create(AName);
end;

procedure TSpineBoundingBoxAttachment.ComputeWorldVertices(const Bone: TSpineBone; var WorldVertices: TSpineFloatArray);
  var x, y, m00, m01, m10, m11, px, py, sx, sy: Single;
  var i: Integer;
begin
  if Length(WorldVertices) <> Length(_Vertices) then
  SetLength(WorldVertices, Length(_Vertices));
  x := Bone.Skeleton.x;
  y := Bone.Skeleton.y;
  sx := Bone.Skeleton.ScaleX;
  sy := Bone.Skeleton.ScaleY;
  m00 := Bone.m00;
  m01 := Bone.m01;
  m10 := Bone.m10;
  m11 := Bone.m11;
  i := 0;
  while i < Length(_Vertices) do
  begin
    px := _Vertices[i];
    py := _Vertices[i + 1];
    WorldVertices[i] := (px * m00 + py * m01 + Bone.WorldX) * sx + x;
    WorldVertices[i + 1] := (px * m10 + py * m11 + Bone.WorldY) * sx + x;
    Inc(i, 2);
  end;
end;
//TSpineBoundingBoxAttachment END

//TSpineMeshAttachment BEGIN
procedure TSpineMeshAttachment.SetTexture(const Value: TSpineTexture);
begin
  if _Texture = Value then Exit;
  if Assigned(_Texture) then _Texture.RefDec;
  _Texture := Value;
  if Assigned(_Texture) then _Texture.RefInc;
end;

constructor TSpineMeshAttachment.Create(const AName: String);
begin
  inherited Create(AName);
  _Texture := nil;
end;

destructor TSpineMeshAttachment.Destroy;
begin
  Texture := nil;
  inherited Destroy;
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
    i := 0;
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
  var x, y, m00, m01, m10, m11, vx, vy, sx, sy: Single;
  var v: PSpineFloatArray;
  var i: Integer;
begin
  Bone := Slot.Bone;
  x := Bone.Skeleton.x;
  y := Bone.Skeleton.y;
  sx := Bone.Skeleton.ScaleX;
  sy := Bone.Skeleton.ScaleY;
  m00 := Bone.m00;
  m01 := Bone.m01;
  m10 := Bone.m10;
  m11 := Bone.m11;
  v := @_Vertices;
  if Slot.AttachmentVertexCount = Length(_Vertices) then
  v := @Slot.AttachmentVertices;
  i := 0;
  while i < Length(_Vertices) do
  begin
    vx := v^[i];
    vy := v^[i + 1];
    WorldVertices[i] := (vx * m00 + vy * m01 + Bone.WorldX) * sx + x;
    WorldVertices[i + 1] := (vx * m10 + vy * m11 + Bone.WorldY) * sy + y;
    Inc(i, 2);
  end;
end;

procedure TSpineMeshAttachment.Draw(const Render: TSpineRender; const Slot: TSpineSlot);
  var v: TSpineRegionVertices;
  var i, n: Integer;
begin
  if Length(_WorldVertices) < Length(_Vertices) then
  SetLength(_WorldVertices, Length(_Vertices));
  n := Length(_Vertices) shr 1;
  if Length(_RenderVertices) < n then
  SetLength(_RenderVertices, n);
  ComputeWorldVertices(Slot, _WorldVertices);
  for i := 0 to n - 1 do
  begin
    _RenderVertices[i].x := _WorldVertices[i * 2 + 0];
    _RenderVertices[i].y := _WorldVertices[i * 2 + 1];
    _RenderVertices[i].u := _UV[i * 2 + 0];
    _RenderVertices[i].v := _UV[i * 2 + 1];
    _RenderVertices[i].r := _r;
    _RenderVertices[i].g := _g;
    _RenderVertices[i].b := _b;
    _RenderVertices[i].a := _a;
  end;
  Render.RenderPoly(_Texture, @_RenderVertices[0], @_Triangles[0], Length(_Triangles) div 3);
end;
//TSpineMeshAttachment END

//TSpineSkinnedMeshAttachment BEGIN
function TSpineSkinnedMeshAttachment.GetWeightsPtr: PSpineFloatArray;
begin
  Result := @_Weights;
end;

procedure TSpineSkinnedMeshAttachment.SetTexture(const Value: TSpineTexture);
begin
  if _Texture = Value then Exit;
  if Assigned(_Texture) then _Texture.RefDec;
  _Texture := Value;
  if Assigned(_Texture) then _Texture.RefInc;
end;

function TSpineSkinnedMeshAttachment.GetBonesPtr: PSpineIntArray;
begin
  Result := @_Bones;
end;

constructor TSpineSkinnedMeshAttachment.Create(const AName: String);
begin
  inherited Create(AName);
  _Texture := nil;
end;

destructor TSpineSkinnedMeshAttachment.Destroy;
begin
  Texture := nil;
  inherited Destroy;
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
    i := 0;
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
  var x, y, wx, wy, vx, vy, wt, sx, sy: Single;
  var wi, vi, bi, fi, n, nn: Integer;
  var Bone: TSpineBone;
begin
  Skeleton := Slot.Skeleton;
  x := Skeleton.x;
  y := Skeleton.y;
  sx := Skeleton.ScaleX;
  sy := Skeleton.ScaleY;
  if Slot.AttachmentVertexCount = 0 then
  begin
    wi := 0; vi := 0; bi := 0; n := Length(_Bones);
    while vi < n do
    begin
      wx := 0;
      wy := 0;
      nn := _Bones[vi]; Inc(vi); nn += vi;
      while vi < nn do
      begin
	Bone := Skeleton.Bones[_Bones[vi]];
	vx := _Weights[bi];
        vy := _Weights[bi + 1];
        wt := _Weights[bi + 2];
	wx += (vx * Bone.m00 + vy * Bone.m01 + Bone.WorldX) * wt;
	wy += (vx * Bone.m10 + vy * Bone.m11 + Bone.WorldY) * wt;
        Inc(vi);
        Inc(bi, 3);
      end;
      WorldVertices[wi] := wx * sx + x;
      WorldVertices[wi + 1] := wy * sy + y;
      Inc(wi, 2);
    end;
  end
  else
  begin
    wi := 0; vi := 0; bi := 0; fi := 0; n := Length(_Bones);
    while vi < n do
    begin
      wx := 0;
      wy := 0;
      nn := _Bones[vi]; Inc(vi); nn += vi;
      while vi < nn do
      begin
	Bone := Skeleton.Bones[_Bones[vi]];
	vx := _Weights[bi] + Slot.AttachmentVertices[fi];
        vy := _Weights[bi + 1] + Slot.AttachmentVertices[fi + 1];
        wt := _Weights[bi + 2];
	wx += (vx * Bone.m00 + vy * Bone.m01 + Bone.WorldX) * wt;
	wy += (vx * Bone.m10 + vy * Bone.m11 + Bone.WorldY) * wt;
        Inc(vi);
        Inc(bi, 3);
        Inc(fi, 2);
      end;
      WorldVertices[wi] := wx * sx + x;
      WorldVertices[wi + 1] := wy * sy + y;
      Inc(wi, 2);
    end;
  end;
end;

{
  var Skeleton: TSpineSkeleton;
  var Bone: TSpineBone;
  var x, y, wx, wy, vx, vy, Weight: Single;
  var w, v, bi, f, n: Integer;
begin
  Skeleton := Slot.Bone.Skeleton;
  x := Skeleton.x;
  y := Skeleton.y;
  if Slot.AttachmentVertexCount = 0 then
  begin
    w := 0; v := 0; bi := 0;
    while v < Length(_Bones) do
    begin
      wx := 0; wy := 0;
      n := _Bones[v]; Inc(v); n += v;
      while (v < n) do
      begin
	Bone := Skeleton.Bones[_Bones[v]];
	vx := _Weights[bi];
        vy := _Weights[bi + 1];
        Weight := _Weights[bi + 2];
	wx += (vx * Bone.m00 + vy * Bone.m01 + Bone.WorldX) * Weight;
	wy += (vx * Bone.m10 + vy * Bone.m11 + Bone.WorldY) * Weight;
        Inc(v);
        Inc(bi, 3);
      end;
      WorldVertices[w] := wx + x;
      WorldVertices[w + 1] := wy + y;
      Inc(w, 2);
    end;
  end
  else
  begin
    w := 0; v := 0; bi := 0; f := 0;
    while (v < Length(_Bones)) do
    begin
      wx := 0; wy := 0;
      n := _Bones[v]; Inc(v); n += v;
      while v < n do
      begin
	Bone := Skeleton.Bones[_Bones[v]];
	vx := _Weights[bi] + Slot.AttachmentVertices[f];
        vy := _Weights[bi + 1] + Slot.AttachmentVertices[f + 1];
        Weight := _Weights[bi + 2];
	wx += (vx * Bone.m00 + vy * Bone.m01 + Bone.WorldX) * Weight;
	wy += (vx * Bone.m10 + vy * Bone.m11 + Bone.WorldY) * Weight;
        Inc(v);
        Inc(bi, 3);
        Inc(f, 2);
      end;
      WorldVertices[w] := wx + x;
      WorldVertices[w + 1] := wy + y;
      Inc(w, 2);
    end;
  end;
end;
}

procedure TSpineSkinnedMeshAttachment.Draw(const Render: TSpineRender; const Slot: TSpineSlot);
  var v: TSpineRegionVertices;
  var i, n: Integer;
begin
  if Length(_WorldVertices) < Length(_Bones) * 2 then
  SetLength(_WorldVertices, Length(_Bones) * 2);
  n := Length(_Bones);
  if Length(_RenderVertices) < n then
  SetLength(_RenderVertices, n);
  ComputeWorldVertices(Slot, _WorldVertices);
  for i := 0 to n - 1 do
  begin
    _RenderVertices[i].x := _WorldVertices[i * 2 + 0];
    _RenderVertices[i].y := _WorldVertices[i * 2 + 1];
    _RenderVertices[i].u := _UV[i * 2 + 0];
    _RenderVertices[i].v := _UV[i * 2 + 1];
    _RenderVertices[i].r := _r;
    _RenderVertices[i].g := _g;
    _RenderVertices[i].b := _b;
    _RenderVertices[i].a := _a;
  end;
  Render.RenderPoly(_Texture, @_RenderVertices[0], @_Triangles[0], Length(_Triangles) div 3);
end;
//TSpineSkinnedMeshAttachment END

//TSpineAtlasAttachmentLoader BEGIN
procedure TSpineAtlasAttachmentLoader.SetAtlasList(const Value: TSpineAtlasList);
begin
  if _AtlasList = Value then Exit;
  if Assigned(_AtlasList) then _AtlasList.RefDec;
  _AtlasList := Value;
  if Assigned(_AtlasList) then _AtlasList.RefInc;
end;

constructor TSpineAtlasAttachmentLoader.Create;
begin
  _AtlasList := TSpineAtlasList.Create;
end;

constructor TSpineAtlasAttachmentLoader.Create(const AAtlasList: TSpineAtlasList);
begin
  _AtlasList := nil;
  AtlasList := AAtlasList;
end;

destructor TSpineAtlasAttachmentLoader.Destroy;
begin
  _AtlasList.Free;
  inherited Destroy;
end;

function TSpineAtlasAttachmentLoader.NewRegionAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineRegionAttachment;
  var Region: TSpineAtlasRegion;
begin
  Region := FindRegion(Path);
  Result := TSpineRegionAttachment.Create(Name);
  Result.Texture := Region.Page.Texture;
  Result.SetUVs(Region.u, Region.v, Region.u2, Region.v2, Region.Rotate);
  Result.RegionOffsetX := Region.OffsetX;
  Result.RegionOffsetY := Region.OffsetY;
  Result.RegionWidth := Region.w;
  Result.RegionHeight := Region.h;
  Result.RegionOriginalWidth := Region.OriginalWidth;
  Result.RegionOriginalHeight := Region.OriginalHeight;
end;

function TSpineAtlasAttachmentLoader.NewMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineMeshAttachment;
  var Region: TSpineAtlasRegion;
begin
  Region := FindRegion(Path);
  Result := TSpineMeshAttachment.Create(Name);
  Result.Texture := Region.Page.Texture;
  Result.RegionU := Region.u;
  Result.RegionV := Region.v;
  Result.RegionU2 := Region.u2;
  Result.RegionV2 := Region.v2;
  Result.RegionRotate := Region.Rotate;
  Result.RegionOffsetX := Region.OffsetX;
  Result.RegionOffsetY := Region.OffsetY;
  Result.RegionWidth := Region.w;
  Result.RegionHeight := Region.h;
  Result.RegionOriginalWidth := Region.OriginalWidth;
  Result.RegionOriginalHeight := Region.OriginalHeight;
end;

function TSpineAtlasAttachmentLoader.NewSkinnedMeshAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineSkinnedMeshAttachment;
  var Region: TSpineAtlasRegion;
begin
  Region := FindRegion(Path);
  Result := TSpineSkinnedMeshAttachment.Create(Name);
  Result.Texture := Region.Page.Texture;
  Result.RegionU := Region.u;
  Result.RegionV := Region.v;
  Result.RegionU2 := Region.u2;
  Result.RegionV2 := Region.v2;
  Result.RegionRotate := Region.Rotate;
  Result.regionOffsetX := Region.OffsetX;
  Result.regionOffsetY := Region.OffsetY;
  Result.regionWidth := Region.w;
  Result.regionHeight := Region.h;
  Result.regionOriginalWidth := Region.OriginalWidth;
  Result.regionOriginalHeight := Region.OriginalHeight;
end;

function TSpineAtlasAttachmentLoader.NewBoundingBoxAttachment(const Skin: TSpineSkin; const Name, Path: String): TSpineBoundingBoxAttachment;
begin
  Result := TSpineBoundingBoxAttachment.Create(Name);
end;

function TSpineAtlasAttachmentLoader.FindRegion(const Name: String): TSpineAtlasRegion;
  var i: Integer;
begin
  for i := 0 to _AtlasList.Count - 1 do
  begin
    Result := _AtlasList[i].FindRegion(Name);
    if Assigned(Result) then Exit;
  end;
  Result := nil;
end;
//TSpineAtlasAttachmentLoader END

//TSpineSkeletonBinary BEGIN
function TSpineSkeletonBinary.ReadInt(const Provider: TSpineDataProvider): Integer;
begin
  Result := (Provider.ReadByte shl 24) + (Provider.ReadByte shl 16) + (Provider.ReadByte shl 8) + Provider.ReadByte;
end;

function TSpineSkeletonBinary.ReadInt(const Provider: TSpineDataProvider; const OptimizePositive: Boolean): Integer;
  var b: Integer;
begin
  b := Provider.ReadByte;
  Result := b and $7F;
  if ((b and $80) <> 0) then
  begin
    b := Provider.ReadByte;
    Result := Result or ((b and $7F) shl 7);
    if ((b and $80) <> 0) then
    begin
      b := Provider.ReadByte;
      Result := Result or ((b and $7F) shl 14);
      if ((b and $80) <> 0) then
      begin
	b := Provider.ReadByte;
	Result := Result or ((b and $7F) shl 21);
	if ((b and $80) <> 0) then
        begin
	  b := Provider.ReadByte;
	  Result := Result or ((b and $7F) shl 28);
	end;
      end;
    end;
  end;
  if not OptimizePositive then Result := ((Result shr 1) xor -(Result and 1));
end;

function TSpineSkeletonBinary.ReadSByte(const Provider: TSpineDataProvider): ShortInt;
  var b: Byte;
begin
  b := Provider.ReadByte;
  Result := PShortInt(@b)^;
end;

function TSpineSkeletonBinary.ReadBool(const Provider: TSpineDataProvider): Boolean;
begin
  Result := Provider.ReadByte <> 0;
end;

function TSpineSkeletonBinary.ReadFloat(const Provider: TSpineDataProvider): Single;
begin
  _Buffer[3] := Provider.ReadByte;
  _Buffer[2] := Provider.ReadByte;
  _Buffer[1] := Provider.ReadByte;
  _Buffer[0] := Provider.ReadByte;
  Result := PSingle(@_Buffer[0])^;
end;

function TSpineSkeletonBinary.ReadFloatArray(const Provider: TSpineDataProvider; const ScaleArr: Single): TSpineFloatArray;
  var i, n: Integer;
begin
  n := ReadInt(Provider, True);
  SetLength(Result, n);
  if ScaleArr = 1 then
  begin
    for i := 0 to n - 1 do
    Result[i] := ReadFloat(Provider);
  end
  else
  begin
    for i := 0 to n - 1 do
    Result[i] := ReadFloat(Provider) * ScaleArr;
  end;
end;

function TSpineSkeletonBinary.ReadShortArray(const Provider: TSpineDataProvider): TSpineIntArray;
  var i, n: Integer;
  var b0, b1: Byte;
begin
  n := ReadInt(Provider, True);
  SetLength(Result, n);
  for i := 0 to n - 1 do
  begin
    b0 := Provider.ReadByte;
    b1 := Provider.ReadByte;
    Result[i] := (b0 shl 8) + b1;
  end;
end;

function TSpineSkeletonBinary.ReadIntArray(const Provider: TSpineDataProvider): TSpineIntArray;
  var i, n: Integer;
begin
  n := ReadInt(Provider, True);
  SetLength(Result, n);
  for i := 0 to n - 1 do
  Result[i] := ReadInt(Provider, True);
end;

function TSpineSkeletonBinary.ReadString(const Provider: TSpineDataProvider): String;
  var CharCount, CharIndex, b: Integer;
begin
  CharCount := ReadInt(Provider, True);
  case CharCount of
    0, 1: Exit('');
  end;
  Dec(CharCount);
  if Length(_Chars) < CharCount then SetLength(_Chars, CharCount);
  CharIndex := 0;
  b := 0;
  while CharIndex < CharCount do
  begin
    b := Provider.ReadByte;
    if b > 127 then Break;
    _Chars[CharIndex] := AnsiChar(b);
    Inc(CharIndex);
  end;
  if CharIndex < CharCount then ReadUtf8Slow(Provider, CharCount, CharIndex, b);
  SetLength(Result, CharCount);
  Move(_Chars[0], Result[1], CharCount);
end;

procedure TSpineSkeletonBinary.ReadUtf8Slow(const Provider: TSpineDataProvider; const CharCount: Integer; var CharIndex, b: Integer);
begin
  while True do
  begin
    case (b shr 4) of
      0, 1, 2, 3, 4, 5, 6, 7: _Chars[CharIndex] := AnsiChar(b);
      12, 13: _Chars[CharIndex] := AnsiChar(((b and $1F) shl 6) or (Provider.ReadByte and $3F));
      14: _Chars[CharIndex] := AnsiChar(((LongWord(b) and $0F) shl 12) or ((Provider.ReadByte and $3F) shl 6) or (Provider.ReadByte and $3F));
    end;
    Inc(CharIndex);
    if CharIndex >= CharCount then Break;
    b := Provider.ReadByte and $FF;
  end;
end;

procedure TSpineSkeletonBinary.ReadCurve(const Provider: TSpineDataProvider; const FrameIndex: Integer; const Timeline: TSpineAnimationCurveTimeline);
  var cx1, cy1, cx2, cy2: Single;
begin
  case Provider.ReadByte of
    CURVE_STEPPED: Timeline.SetStepped(FrameIndex);
    CURVE_BEZIER:
    begin
      cx1 := ReadFloat(Provider);
      cy1 := ReadFloat(Provider);
      cx2 := ReadFloat(Provider);
      cy2 := ReadFloat(Provider);
      Timeline.SetCurve(FrameIndex, cx1, cy1, cx2, cy2);
    end;
  end;
end;

function TSpineSkeletonBinary.ReadSkin(const Provider: TSpineDataProvider; const SkinName: String; const NonEssential: Boolean): TSpineSkin;
  var i, j, n, SlotIndex, SlotCount: Integer;
  var Name: String;
begin
  SlotCount := ReadInt(Provider, True);
  if SlotCount = 0 then Exit(nil);
  Result := TSpineSkin.Create(SkinName);
  for i := 0 to SlotCount - 1 do
  begin
    SlotIndex := ReadInt(Provider, True);
    n := ReadInt(Provider, True);
    for j := 0 to n - 1 do
    begin
      Name := ReadString(Provider);
      Result.AddAttachment(SlotIndex, Name, ReadAttachment(Provider, Result, Name, NonEssential));
    end;
  end;
end;

function TSpineSkeletonBinary.ReadAttachment(const Provider: TSpineDataProvider; const Skin: TSpineSkin; const AttachmentName: String; const NonEssential: Boolean): TSpineAttachment;
  var Name, Path: String;
  var at: TSpineAttachmentType;
  var Region: TSpineRegionAttachment absolute Result;
  var Box: TSpineBoundingBoxAttachment absolute Result;
  var Mesh: TSpineMeshAttachment absolute Result;
  var Skinned: TSpineSkinnedMeshAttachment absolute Result;
  var Color, VertexCount, BoneCount, bi, wi, i, j: Integer;
  var f: Single;
  var uvs: TSpineFloatArray;
  var Triangles: TSpineIntArray;
begin
  Name := ReadString(Provider);
  if Length(Name) = 0 then Name := AttachmentName;
  at := TSpineAttachmentType(Provider.ReadByte);
  case at of
    sp_at_region:
    begin
      Path := ReadString(Provider);
      if Length(Path) = 0 then Path := Name;
      Region := _AttachmentLoader.NewRegionAttachment(Skin, Name, Path);
      if not Assigned(Region) then Exit;
      Region.Path := Path;
      Region.x := ReadFloat(Provider) * _Scale;
      Region.y := ReadFloat(Provider) * _Scale;
      Region.ScaleX := ReadFloat(Provider);
      Region.ScaleY := ReadFloat(Provider);
      Region.Rotation := ReadFloat(Provider);
      Region.Width := ReadFloat(Provider) * _Scale;
      Region.Height := ReadFloat(Provider) * _Scale;
      Color := ReadInt(Provider);
      Region.r := ((Color and $ff000000) shr 24) * SP_RCP_255;
      Region.g := ((Color and $00ff0000) shr 16) * SP_RCP_255;
      Region.b := ((Color and $0000ff00) shr 8) * SP_RCP_255;
      Region.a := ((Color and $000000ff)) * SP_RCP_255;
      Region.UpdateOffset();
      Exit;
    end;
    sp_at_bounding_box:
    begin
      Box := _AttachmentLoader.NewBoundingBoxAttachment(Skin, Name, Path);
      if not Assigned(Box) then Exit;
      Box.Vertices := ReadFloatArray(Provider, _Scale);
      Exit;
    end;
    sp_at_mesh:
    begin
      Path := ReadString(Provider);
      if Length(Path) = 0 then Path := Name;
      Mesh := _AttachmentLoader.NewMeshAttachment(Skin, Name, Path);
      if not Assigned(Mesh) then Exit;
      Mesh.Path := Path;
      Mesh.RegionUV := ReadFloatArray(Provider, 1);
      Mesh.Triangles := ReadShortArray(Provider);
      Mesh.Vertices := ReadFloatArray(Provider, _Scale);
      Mesh.UpdateUV;
      Color := ReadInt(Provider);
      Mesh.r := ((Color and $ff000000) shr 24) * SP_RCP_255;
      Mesh.g := ((Color and $00ff0000) shr 16) * SP_RCP_255;
      Mesh.b := ((Color and $0000ff00) shr 8) * SP_RCP_255;
      Mesh.a := ((Color and $000000ff)) * SP_RCP_255;
      Mesh.HullLength := ReadInt(Provider, True) * 2;
      if NonEssential then
      begin
	Mesh.Edges := ReadIntArray(Provider);
	Mesh.Width := ReadFloat(Provider) * _Scale;
	Mesh.Height := ReadFloat(Provider) * _Scale;
      end;
      Exit;
    end;
    sp_at_skinned_mesh:
    begin
      Path := ReadString(Provider);
      if Length(path) = 0 then Path := Name;
      Skinned := _AttachmentLoader.NewSkinnedMeshAttachment(Skin, Name, Path);
      if not Assigned(Skinned) then Exit;
      Skinned.Path := Path;
      Skinned.RegionUV := ReadFloatArray(Provider, 1);
      Skinned.Triangles := ReadShortArray(Provider);
      VertexCount := ReadInt(Provider, True);
      SetLength(Skinned.WeightsPtr^, Length(Skinned.RegionUV) * 3 * 3);
      SetLength(Skinned.BonesPtr^, Length(Skinned.RegionUV) * 3);
      bi := 0; wi := 0; i := 0;
      while i < VertexCount do
      begin
	BoneCount := Round(ReadFloat(Provider));
	Skinned.Bones[bi] := BoneCount; Inc(bi);
        j := i + BoneCount * 4;
        while i < j do
        begin
	  Skinned.Bones[bi] := Round(ReadFloat(Provider)); Inc(bi);
	  Skinned.Weights[wi] := ReadFloat(Provider) * _Scale; Inc(wi);
	  Skinned.Weights[wi] := ReadFloat(Provider) * _Scale; Inc(wi);
	  Skinned.Weights[wi] := ReadFloat(Provider); Inc(wi);
          Inc(i, 4);
	end;
        Inc(i);
      end;
      if Length(Skinned.Bones) <> bi then SetLength(Skinned.BonesPtr^,  bi);
      if Length(Skinned.Weights) <> wi then SetLength(Skinned.WeightsPtr^, wi);
      Skinned.UpdateUV;
      Color := ReadInt(Provider);
      Skinned.r := ((Color and $ff000000) shr 24) * SP_RCP_255;
      Skinned.g := ((Color and $00ff0000) shr 16) * SP_RCP_255;
      Skinned.b := ((Color and $0000ff00) shr 8) * SP_RCP_255;
      Skinned.a := ((Color and $000000ff)) * SP_RCP_255;
      Skinned.HullLength := ReadInt(Provider, True) * 2;
      if NonEssential then
      begin
	Skinned.Edges := ReadIntArray(Provider);
	Skinned.Width := ReadFloat(Provider) * _Scale;
	Skinned.Height := ReadFloat(Provider) * _Scale;
      end;
      Exit;
    end;
  end;
  Result := nil;
end;

procedure TSpineSkeletonBinary.ReadAnimation(const Provider: TSpineDataProvider; const Name: String; const SkeletonData: TSpineSkeletonData);
  var Timelines: TSpineTimelineList;
  var Duration, Time, Angle, r, g, b, a, x, y, Mix, TimelineScale: Single;
  var i, j, l, n, t, m, v, SlotIndex, TimelineType, FrameCount, FrameIndex, BoneIndex: Integer;
  var BendDirection, Color, VertexCount, Start, Count, SlotCount, DrawOrderCount, OffsetCount: Integer;
  var OriginalIndex, UnchangedIndex, EventCount: Integer;
  var ColorTimeline: TSpineAnimationColorTimeline;
  var AttachmentTimeline: TSpineAnimationAttachmentTimeline;
  var RotateTimeline: TSpineAnimationRotateTimeline;
  var TranslateTimeline: TSpineAnimationTranslateTimeline;
  var FlipXTimeline: TSpineAnimationFlipXTimeline;
  var IKConstraintTimeline: TSpineAnimationIKConstraintTimeline;
  var FFDTimeline: TSpineAnimationFFDTimeline;
  var DrawOrderTimeline: TSpineAnimationDrawOrderTimeline;
  var EventTimeline: TSpineAnimationEventTimeline;
  var ConstraintData: TSpineIKConstraintData;
  var EventData: TSpineEventData;
  var Event: TSpineEvent;
  var Attachment: TSpineAttachment;
  var Skin: TSpineSkin;
  var Vertices: PSpineFloatArray;
  var TmpVertices: TSpineFloatArray;
  var DrawOrder, Unchanged: TSpineIntArray;
  var TmpName: String;
  var Flip: Boolean;
begin
  Timelines := TSpineTimelineList.Create;
  Duration := 0;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    SlotIndex := ReadInt(Provider, True);
    t := ReadInt(Provider, True);
    for j := 0 to t - 1 do
    begin
      TimelineType := Provider.ReadByte;
      FrameCount := ReadInt(Provider, True);
      case TimelineType of
        TIMELINE_COLOR:
        begin
	  ColorTimeline := TSpineAnimationColorTimeline.Create(FrameCount);
	  ColorTimeline.SlotIndex := SlotIndex;
	  for FrameIndex := 0 to FrameCount - 1 do
          begin
	    Time := ReadFloat(Provider);
	    Color := ReadInt(Provider);
	    r := ((Color and $ff000000) shr 24) * SP_RCP_255;
	    g := ((Color and $00ff0000) shr 16) * SP_RCP_255;
	    b := ((Color and $0000ff00) shr 8) * SP_RCP_255;
	    a := ((Color and $000000ff)) * SP_RCP_255;
	    ColorTimeline.SetFrame(FrameIndex, Time, r, g, b, a);
	    if (FrameIndex < FrameCount - 1) then ReadCurve(Provider, FrameIndex, ColorTimeline);
	  end;
	  Timelines.Add(ColorTimeline);
	  Duration := SpineMax(Duration, ColorTimeline.Frames[FrameCount * 5 - 5]);
	end;
        TIMELINE_ATTACHMENT:
        begin
	  AttachmentTimeline := TSpineAnimationAttachmentTimeline.Create(FrameCount);
	  AttachmentTimeline.SlotIndex := SlotIndex;
	  for FrameIndex := 0 to FrameCount - 1 do
          begin
            Time := ReadFloat(Provider);
            TmpName := ReadString(Provider);
	    AttachmentTimeline.SetFrame(FrameIndex, Time, TmpName);
          end;
	  Timelines.Add(AttachmentTimeline);
	  Duration := SpineMax(Duration, AttachmentTimeline.Frames[FrameCount - 1]);
	end;
      end;
    end;
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    BoneIndex := ReadInt(Provider, True);
    t := ReadInt(Provider, True);
    for j := 0 to t - 1 do
    begin
      TimelineType := Provider.ReadByte;
      FrameCount := ReadInt(Provider, True);
      case TimelineType of
        TIMELINE_ROTATE:
        begin
	  RotateTimeline := TSpineAnimationRotateTimeline.Create(FrameCount);
	  RotateTimeline.BoneIndex := BoneIndex;
	  for FrameIndex := 0 to FrameCount - 1 do
          begin
            Time := ReadFloat(Provider);
            Angle := ReadFloat(Provider);
	    RotateTimeline.SetFrame(FrameIndex, Time, Angle);
	    if FrameIndex < FrameCount - 1 then ReadCurve(Provider, FrameIndex, RotateTimeline);
	  end;
	  Timelines.Add(RotateTimeline);
	  Duration := SpineMax(Duration, RotateTimeline.Frames[FrameCount * 2 - 2]);
	end;
        TIMELINE_TRANSLATE,
        TIMELINE_SCALE:
        begin
	  if TimelineType = TIMELINE_SCALE then
          begin
            TranslateTimeline := TSpineAnimationScaleTimeline.Create(FrameCount);
            TimelineScale := 1;
          end
	  else
          begin
	    TranslateTimeline := TSpineAnimationTranslateTimeline.Create(FrameCount);
	    TimelineScale := _Scale;
	  end;
	  TranslateTimeline.BoneIndex := BoneIndex;
	  for FrameIndex := 0 to FrameCount - 1 do
          begin
            Time := ReadFloat(Provider);
            x := ReadFloat(Provider) * TimelineScale;
            y := ReadFloat(Provider) * TimelineScale;
	    TranslateTimeline.SetFrame(FrameIndex, Time, x, y);
	    if FrameIndex < FrameCount - 1 then ReadCurve(Provider, FrameIndex, TranslateTimeline);
	  end;
	  Timelines.Add(TranslateTimeline);
	  Duration := SpineMax(Duration, TranslateTimeline.Frames[FrameCount * 3 - 3]);
	end;
        TIMELINE_FLIPX,
        TIMELINE_FLIPY:
        begin
          if TimelineType = TIMELINE_FLIPX then
          begin
            FlipXTimeline := TSpineAnimationFlipXTimeline.Create(FrameCount);
          end
          else
          begin
            FlipXTimeline := TSpineAnimationFlipYTimeline.Create(FrameCount);
          end;
	  FlipXTimeline.BoneIndex := BoneIndex;
	  for FrameIndex := 0 to FrameCount - 1 do
          begin
            Time := ReadFloat(Provider);
            Flip := ReadBool(Provider);
            FlipXTimeline.SetFrame(FrameIndex, Time, Flip);
          end;
	  Timelines.Add(FlipXTimeline);
	  Duration := SpineMax(Duration, FlipXTimeline.Frames[FrameCount * 2 - 2]);
	end;
      end;
    end;
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    ConstraintData := SkeletonData.IKConstraints[ReadInt(Provider, True)];
    FrameCount := ReadInt(Provider, True);
    IKConstraintTimeline := TSpineAnimationIKConstraintTimeline.Create(FrameCount);
    IkConstraintTimeline.IKConstraintIndex := SkeletonData.IKConstraints.Find(ConstraintData);
    for FrameIndex := 0 to FrameCount - 1 do
    begin
      Time := ReadFloat(Provider);
      Mix := ReadFloat(Provider);
      BendDirection := ReadSByte(Provider);
      IkConstraintTimeline.SetFrame(FrameIndex, Time, Mix, BendDirection);
      if FrameIndex < FrameCount - 1 then ReadCurve(Provider, FrameIndex, IkConstraintTimeline);
    end;
    Timelines.Add(IkConstraintTimeline);
    Duration := SpineMax(Duration, IkConstraintTimeline.Frames[FrameCount * 3 - 3]);
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    Skin := SkeletonData.Skins[ReadInt(Provider, True)];
    t := ReadInt(Provider, True);
    for j := 0 to t - 1 do
    begin
      SlotIndex := ReadInt(Provider, true);
      m := ReadInt(Provider, True);
      for l := 0 to m - 1 do
      begin
	Attachment := Skin.GetAttachment(SlotIndex, ReadString(Provider));
	FrameCount := ReadInt(Provider, True);
	FFDTimeline := TSpineAnimationFFDTimeline.Create(FrameCount);
	FFDTimeline.SlotIndex := SlotIndex;
	FFDTimeline.Attachment := Attachment;
	for FrameIndex := 0 to FrameCount - 1 do
        begin
	  Time := ReadFloat(Provider);
	  if Attachment is TSpineMeshAttachment then
	  VertexCount := Length(TSpineMeshAttachment(Attachment).Vertices)
	  else
	  VertexCount := Length(TSpineSkinnedMeshAttachment(attachment).Weights) div 3 * 2;
	  Count := ReadInt(Provider, True);
	  if Count = 0 then
          begin
	    if Attachment is TSpineMeshAttachment then
	    Vertices := @TSpineMeshAttachment(Attachment).Vertices
	    else
            begin
              SetLength(TmpVertices, VertexCount);
	      Vertices := @TmpVertices;
            end;
	  end
          else
          begin
            SetLength(TmpVertices, VertexCount);
	    Vertices := @TmpVertices;
	    Start := ReadInt(Provider, True);
	    Count += Start;
	    if _Scale = 1 then
            begin
	      for v := Start to Count - 1 do
	      Vertices^[v] := ReadFloat(Provider);
	    end
            else
            begin
	      for v := Start to Count - 1 do
	      Vertices^[v] := ReadFloat(Provider) * _Scale;
	    end;
	    if Attachment is TSpineMeshAttachment then
            begin
	      for v := 0 to High(Vertices^) do
	      Vertices^[v] += TSpineMeshAttachment(Attachment).Vertices[v];
	    end;
	  end;
	  FFDTimeline.SetFrame(FrameIndex, Time, Vertices^);
	  if FrameIndex < FrameCount - 1 then ReadCurve(Provider, FrameIndex, FFDTimeline);
	end;
	Timelines.Add(FFDTimeline);
	Duration := SpineMax(Duration, FFDTimeline.Frames[FrameCount - 1]);
      end;
    end;
  end;
  DrawOrderCount := ReadInt(Provider, True);
  if DrawOrderCount > 0 then
  begin
    DrawOrderTimeline := TSpineAnimationDrawOrderTimeline.Create(DrawOrderCount);
    SlotCount := SkeletonData.Slots.Count;
    for i := 0 to DrawOrderCount - 1 do
    begin
      OffsetCount := ReadInt(Provider, True);
      SetLength(DrawOrder, SlotCount);
      for j := SlotCount - 1 downto 0 do
      DrawOrder[j] := -1;
      SetLength(Unchanged, SlotCount - OffsetCount);
      OriginalIndex := 0;
      UnchangedIndex := 0;
      for j := 0 to OffsetCount - 1 do
      begin
	SlotIndex := ReadInt(Provider, True);
	while OriginalIndex <> SlotIndex do
        begin
	  Unchanged[UnchangedIndex] := OriginalIndex;
          Inc(UnchangedIndex);
          Inc(OriginalIndex);
        end;
	DrawOrder[OriginalIndex + ReadInt(Provider, True)] := OriginalIndex;
        Inc(OriginalIndex);
      end;
      while OriginalIndex < SlotCount do
      begin
        Unchanged[UnchangedIndex] := OriginalIndex;
        Inc(UnchangedIndex);
        Inc(OriginalIndex);
      end;
      for j := SlotCount - 1 downto 0 do
      if (DrawOrder[j] = -1) then
      begin
        Dec(UnchangedIndex);
        DrawOrder[j] := Unchanged[UnchangedIndex];
      end;
      DrawOrderTimeline.SetFrame(i, ReadFloat(Provider), DrawOrder);
    end;
    Timelines.Add(DrawOrderTimeline);
    Duration := SpineMax(Duration, DrawOrderTimeline.Frames[DrawOrderCount - 1]);
  end;
  EventCount := ReadInt(Provider, True);
  if EventCount > 0 then
  begin
    EventTimeline := TSpineAnimationEventTimeline.Create(EventCount);
    for i := 0 to EventCount - 1 do
    begin
      Time := ReadFloat(Provider);
      EventData := SkeletonData.Events[ReadInt(Provider, True)];
      Event := TSpineEvent.Create(EventData);
      Event.IntValue := ReadInt(Provider, False);
      Event.FloatValue := ReadFloat(Provider);
      if ReadBool(Provider) then
      Event.StringValue := ReadString(Provider)
      else
      Event.StringValue := EventData.StringValue;
      EventTimeline.SetFrame(i, Time, Event);
    end;
    Timelines.Add(EventTimeline);
    Duration := SpineMax(Duration, EventTimeline.Frames[EventCount - 1]);
  end;
  SkeletonData.Animations.Add(TSpineAnimation.Create(Name, Timelines, Duration));
end;

constructor TSpineSkeletonBinary.Create(const AtlasList: TSpineAtlasList);
begin
  _AttachmentLoader := TSpineAtlasAttachmentLoader.Create(AtlasList);
  _Scale := 1;
end;

constructor TSpineSkeletonBinary.Create(const AttachmentLoader: TSpineAttachmentLoader);
begin
  _AttachmentLoader := AttachmentLoader;
  _AttachmentLoader.RefInc;
  _Scale := 1;
end;

destructor TSpineSkeletonBinary.Destroy;
begin
  _AttachmentLoader.RefDec;
  inherited Destroy;
end;

function TSpineSkeletonBinary.ReadSkeletonData(const Path: String): TSpineSkeletonData;
  var Provider: TSpineDataProvider;
begin
  Provider := SpineDataProvider.FetchData(Path);
  if Provider = nil then Exit;
  try
    Result := ReadSkeletonData(Provider);
  finally
    Provider.Free;
  end;
end;

function TSpineSkeletonBinary.ReadSkeletonData(const Provider: TSpineDataProvider): TSpineSkeletonData;
  var NonEssential: Boolean;
  var i, j, n, t, ParentIndex: Integer;
  var Name: String;
  var BoneData, Parent: TSpineBoneData;
  var ConstraintData: TSpineIKConstraintData;
  var SlotData: TSpineSlotData;
  var EventData: TSpineEventData;
  var DefaultSkin: TSpineSkin;
  var Color: Integer;
begin
  Result := TSpineSkeletonData.Create;
  Result.Hash := ReadString(Provider);
  Result.Version := ReadString(Provider);
  Result.Width := ReadFloat(Provider);
  Result.Height := ReadFloat(Provider);
  NonEssential := ReadBool(Provider);
  if NonEssential then
  Result.ImagePath := ReadString(Provider);
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    Name := ReadString(Provider);
    Parent := nil;
    ParentIndex := ReadInt(Provider, True) - 1;
    if ParentIndex > -1 then Parent := Result.Bones[ParentIndex];
    BoneData := TSpineBoneData.Create(Name, Parent);
    BoneData.x := ReadFloat(Provider) * _Scale;
    BoneData.y := ReadFloat(Provider) * _Scale;
    BoneData.ScaleX := ReadFloat(Provider);
    BoneData.ScaleY := ReadFloat(Provider);
    BoneData.Rotation := ReadFloat(Provider);
    BoneData.BoneLength := ReadFloat(Provider) * _Scale;
    BoneData.FlipX := ReadBool(Provider);
    BoneData.FlipY := ReadBool(Provider);
    BoneData.InheritScale := ReadBool(Provider);
    BoneData.InheritRotation := ReadBool(Provider);
    if NonEssential then ReadInt(Provider);
    Result.Bones.Add(BoneData);
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    ConstraintData := TSpineIKConstraintData.Create(ReadString(Provider));
    t := ReadInt(Provider, True);
    for j := 0 to t - 1 do
    ConstraintData.Bones.Add(Result.Bones[ReadInt(Provider, True)]);
    ConstraintData.Target := Result.Bones[ReadInt(Provider, True)];
    ConstraintData.Mix := ReadFloat(Provider);
    ConstraintData.BendDirection := ReadSByte(Provider);
    Result.IKConstraints.Add(ConstraintData);
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    Name := ReadString(Provider);
    BoneData := Result.Bones[ReadInt(Provider, True)];
    SlotData := TSpineSlotData.Create(Name, BoneData);
    Color := ReadInt(Provider);
    SlotData.r := ((Color and $ff000000) shr 24) * SP_RCP_255;
    SlotData.g := ((Color and $00ff0000) shr 16) * SP_RCP_255;
    SlotData.b := ((Color and $0000ff00) shr 8) * SP_RCP_255;
    SlotData.a := ((Color and $000000ff)) * SP_RCP_255;
    SlotData.AttachmentName := ReadString(Provider);
    SlotData.BlendMode := TSpineBlendMode(ReadInt(Provider, True));
    Result.Slots.Add(SlotData);
  end;
  DefaultSkin := ReadSkin(Provider, 'default', NonEssential);
  if Assigned(DefaultSkin) then
  begin
    Result.DefaultSkin := DefaultSkin;
    Result.Skins.Add(DefaultSkin);
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    Name := ReadString(Provider);
    Result.Skins.Add(ReadSkin(Provider, Name, NonEssential));
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    EventData := TSpineEventData.Create(ReadString(Provider));
    EventData.IntValue := ReadInt(Provider, False);
    EventData.FloatValue := ReadFloat(Provider);
    EventData.StringValue := ReadString(Provider);
    Result.Events.Add(EventData);
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  ReadAnimation(Provider, ReadString(Provider), Result);
end;
//TSpineSkeletonBinary END

//TSpineClass BEGIN
class constructor TSpineClass.CreateClass;
begin
  ClassInstances := nil;
end;

class procedure TSpineClass.Report(const FileName: String);
  var f: TextFile;
  var s: String;
  var n: Integer;
  var c: TSpineClass;
begin
  Assign(f, FileName);
  Rewrite(f);
  n := 0;
  c := ClassInstances;
  while c <> nil do
  begin
    s := 'Allocated object[' + IntToStr(n) + ']: ' + c.ClassName + '; Ref = ' + IntToStr(c._Ref);
    WriteLn(f, s);
    c := c.NextInstance;
    Inc(n);
  end;
  Close(f);
end;

procedure TSpineClass.AfterConstruction;
begin
  _Ref := 1;
  PrevInstance := nil;
  NextInstance := ClassInstances;
  if ClassInstances <> nil then ClassInstances.PrevInstance := Self;
  ClassInstances := Self;
end;

procedure TSpineClass.BeforeDestruction;
begin
  if PrevInstance <> nil then PrevInstance.NextInstance := NextInstance;
  if NextInstance <> nil then NextInstance.PrevInstance := PrevInstance;
  if ClassInstances = Self then ClassInstances := NextInstance;
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
  if _Items[Index] = Value then Exit;
  if _Items[Index] <> nil then _Items[Index].RefDec;
  _Items[Index] := Value;
  if _Items[Index] <> nil then _Items[Index].RefInc;
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

function TSpineList.GetItemPtr(const Index: Integer): TItemPtr;
begin
  Result := @_Items[Index];
end;

constructor TSpineList.Create;
begin
  inherited Create;
  Clear;
end;

destructor TSpineList.Destroy;
begin
  FreeItems;
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
  if Item <> nil then Item.RefInc;
  Inc(_ItemCount);
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
  if Item <> nil then Item.RefInc;
  Inc(_ItemCount);
end;

procedure TSpineList.Delete(const Index: Integer; const ItemCount: Integer);
  var i: Integer;
begin
  for i := Index to Index + ItemCount - 1 do
  if _Items[i] <> nil then _Items[i].RefDec;
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
  Clear;
end;

procedure TSpineList.Clear;
begin
  _ItemCount := 0;
end;
{$Hints on}
//TSpineList END

end.
