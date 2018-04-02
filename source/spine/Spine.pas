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
  TSpineTransformConstraintData = class;
  TSpinePathConstraintData = class;
  TSpineBone = class;
  TSpineSlot = class;
  TSpineSkeleton = class;
  TSpineEvent = class;
  TSpineIKConstraint = class;
  TSpineAttachment = class;
  TSpineBoundingBoxAttachment = class;
  TSpinePathAttachment = class;
  TSpineSkin = class;
  TSpinePolygon = class;
  TSpineAnimation = class;
  TSpineAnimationState = class;
  TSpineAnimationStateData = class;
  TSpineAtlasPage = class;
  TSpineAtlasRegion = class;
  TSpineAtlas = class;

  TSpineMatrix3 = array[0..8] of Single;
  TSpineVector2 = array[0..1] of Single;
  TSpineColor = array[0..3] of Single;

  TSpineClass = class
  private
    class var ClassInstances: TSpineClass;
    var NextInstance: TSpineClass;
    var PrevInstance: TSpineClass;
    var _Ref: Integer;
  public
    class constructor CreateClass;
    class procedure Report(const FileName: AnsiString);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure RefInc;
    procedure RefDec;
    procedure Free; reintroduce;
  end;

  {$ifdef fpc}generic {$endif}TSpineList<T{$ifndef fpc}: class{$endif}> = class (TSpineClass)
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
  end;

  TSpineRender = class (TSpineClass)
  public
    procedure RenderQuad(const Texture: TSpineTexture; const Vertices: PSpineVertexArray); virtual; abstract;
    procedure RenderPoly(const Texture: TSpineTexture; const Vertices: PSpineVertexArray; const Triangles: PIntegerArray; const TriangleCount: Integer); virtual; abstract;
  end;

  TSpineDataProvider = class (TSpineClass)
  private
    var _Name: AnsiString;
    var _Data: PByteArray;
    var _Size: Integer;
    var _Pos: Integer;
  protected
    procedure Allocate(const DataSize: Integer);
  public
    property Name: AnsiString read _Name;
    property Data: PByteArray read _Data;
    property Size: Integer read _Size;
    property Pos: Integer read _Pos write _Pos;
    constructor Create(const AName: AnsiString; const DataSize: Integer);
    destructor Destroy; override;
    procedure Read(const Buffer: Pointer; const Count: Integer);
    function ReadByte: Byte; inline;
    class function FetchData(const DataName: AnsiString): TSpineDataProvider; virtual;
    class function FetchTexture(const TextureName: AnsiString): TSpineTexture; virtual;
  end;
  CSpineDataProvider = class of TSpineDataProvider;

  TSpineStringArray = array of AnsiString;
  TSpineFloatArray = array of Single;
  TSpineFloatTable = array of array of Single;
  TSpineIntArray = array of Integer;
  TSpineIntTable = array of array of Integer;
  TSpineAttachmentArray = array of TSpineAttachment;
  TSpineEventArray = array of TSpineEvent;
  TSpineRegionVertices = array[0..7] of Single;
  PSpineFloatArray = ^TSpineFloatArray;
  PSpineIntArray = ^TSpineIntArray;

  TSpineBoneDataList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineBoneData>;
  TSpineSlotDataList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineSlotData>;
  TSpineEventDataList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineEventData>;
  TSpineIKConstraintDataList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineIKConstraintData>;
  TSpineTransformConstraintDataList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineTransformConstraintData>;
  TSpinePathConstraintDataList = {$ifdef fpc}specialize {$endif}TSpineList<TSpinePathConstraintData>;
  TSpineBoneList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineBone>;
  TSpineSlotList = {$ifdef fpc}specialize {$endif}TSpineList<TspineSlot>;
  TSpineSkinList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineSkin>;
  TSpineAttachmentList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineAttachment>;
  TSpineBoundingBoxAttachmentList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineBoundingBoxAttachment>;
  TSpineAnimationList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineAnimation>;
  TSpineIKConstraintList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineIKConstraint>;
  TSpineAtlasPageList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineAtlasPage>;
  TSpineAtlasRegionList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineAtlasRegion>;
  TSpineAtlasList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineAtlas>;
  TSpinePolygonList = {$ifdef fpc}specialize {$endif}TSpineList<TSpinePolygon>;
  TSpineEventList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineEvent>;

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
  public
    type TTransformMode = (
      tm_normal,
      tm_only_translation,
      tm_no_rotation_or_reflection,
      tm_no_scale,
      tm_no_scale_or_reflection
    );
  private
    var _Index: Integer;
    var _Parent: TSpineBoneData;
    var _Name: AnsiString;
    var _BoneLength: Single;
    var _x: Single;
    var _y: Single;
    var _Rotation: Single;
    var _ScaleX: Single;
    var _ScaleY: Single;
    var _ShearX: Single;
    var _ShearY: Single;
    var _TransformMode: TTransformMode;
  public
    property Index: Integer read _Index;
    property Parent: TSpineBoneData read _Parent;
    property Name: AnsiString read _Name;
    property BoneLength: Single read _BoneLength write _BoneLength;
    property x: Single read _x write _x;
    property y: Single read _y write _y;
    property Rotation: Single read _Rotation write _Rotation;
    property ScaleX: Single read _ScaleX write _ScaleX;
    property ScaleY: Single read _ScaleY write _ScaleY;
    property ShearX: Single read _ShearX write _ShearX;
    property ShearY: Single read _ShearY write _ShearY;
    property TransformMode: TTransformMode read _TransformMode write _TransformMode;
    constructor Create(const AIndex: Integer; const AName: AnsiString; const AParent: TSpineBoneData);
    constructor Create(const ABoneData: TSpineBoneData; const AParentBoneData: TSpineBoneData);
  end;

  TSpineSlotData = class (TSpineClass)
  private
    var _Index: Integer;
    var _Name: AnsiString;
    var _BoneData: TSpineBoneData;
    var _AttachmentName: AnsiString;
    var _BlendMode: TSpineBlendMode;
    var _r: Single;
    var _g: Single;
    var _b: Single;
    var _a: Single;
  public
    property Index: Integer read _Index;
    property Name: AnsiString read _Name;
    property BoneData: TSpineBoneData read _BoneData;
    property r: Single read _r write _r;
    property g: Single read _g write _g;
    property b: Single read _b write _b;
    property a: Single read _a write _a;
    property AttachmentName: AnsiString read _AttachmentName write _AttachmentName;
    property BlendMode: TSpineBlendMode read _BlendMode write _BlendMode;
    constructor Create(const AIndex: Integer; const AName: AnsiString; const ABoneData: TSpineBoneData);
  end;

  TSpineSkeletonData = class (TSpineClass)
  private
    var _Name: AnsiString;
    var _Bones: TSpineBoneDataList;
    var _Slots: TSpineSlotDataList;
    var _Skins: TSpineSkinList;
    var _DefaultSkin: TSpineSkin;
    var _Events: TSpineEventDataList;
    var _Animations: TSpineAnimationList;
    var _IKConstraints: TSpineIKConstraintDataList;
    var _TransformConstraints: TSpineTransformConstraintDataList;
    var _PathConstraints: TSpinePathConstraintDataList;
    var _Width: Single;
    var _Height: Single;
    var _Version: AnsiString;
    var _Hash: AnsiString;
    var _ImagePath: AnsiString;
    var _FPS: Single;
  public
    property Name: AnsiString read _Name write _Name;
    property Bones: TSpineBoneDataList read _Bones;
    property Slots: TSpineSlotDataList read _Slots;
    property Skins: TSpineSkinList read _Skins;
    property DefaultSkin: TSpineSkin read _DefaultSkin write _DefaultSkin;
    property Events: TSpineEventDataList read _Events;
    property Animations: TSpineAnimationList read _Animations;
    property IKConstraints: TSpineIKConstraintDataList read _IKConstraints;
    property TransformConstraints: TSpineTransformConstraintDataList read _TransformConstraints;
    property PathConstraints: TSpinePathConstraintDataList read _PathConstraints;
    property Width: Single read _Width write _Width;
    property Height: Single read _Height write _Height;
    property Version: AnsiString read _Version write _Version;
    property Hash: AnsiString read _Hash write _Hash;
    property ImagePath: AnsiString read _ImagePath write _ImagePath;
    property FPS: Single read _FPS write _FPS;
    constructor Create;
    destructor Destroy; override;
    function FindBone(const BoneName: AnsiString): TSpineBoneData;
    function FindBoneIndex(const BoneName: AnsiString): Integer;
    function FindSlot(const SlotName: AnsiString): TSpineSlotData;
    function FindSlotIndex(const SlotName: AnsiString): Integer;
    function FindSkin(const SkinName: AnsiString): TSpineSkin;
    function FindSkinIndex(const SkinName: AnsiString): Integer;
    function FindEvent(const EventName: AnsiString): TSpineEventData;
    function FindEventIndex(const EventName: AnsiString): Integer;
    function FindAnimation(const AnimationName: AnsiString): TSpineAnimation;
    function FindAnimationIndex(const AnimationName: AnsiString): Integer;
    function FindIKConstraint(const IKConstraintName: AnsiString): TSpineIKConstraintData;
    function FindIKConstraintIndex(const IKConstraintName: AnsiString): Integer;
    function FindTransformConstraint(const TransformConstraintName: AnsiString): TSpineTransformConstraintData;
    function FindTransformConstraintIndex(const TransformConstraintName: AnsiString): Integer;
  end;

  TSpineEventData = class (TSpineClass)
  private
    var _Name: AnsiString;
    var _IntValue: Integer;
    var _FloatValue: Single;
    var _StringValue: AnsiString;
  public
    property Name: AnsiString read _Name;
    property IntValue: Integer read _IntValue write _IntValue;
    property FloatValue: Single read _FloatValue write _FloatValue;
    property StringValue: AnsiString read _StringValue write _StringValue;
    constructor Create(const AName: AnsiString);
  end;

  TSpineIKConstraintData = class (TSpineClass)
  private
    var _Name: AnsiString;
    var _Order: Integer;
    var _Bones: TSpineBoneDataList;
    var _Target: TSpineBoneData;
    var _BendDirection: Integer;
    var _Mix: Single;
  public
    property Name: AnsiString read _Name;
    property Order: Integer read _Order write _Order;
    property Bones: TSpineBoneDataList read _Bones;
    property Target: TSpineBoneData read _Target write _Target;
    property BendDirection: Integer read _BendDirection write _BendDirection;
    property Mix: Single read _Mix write _Mix;
    constructor Create(const AName: AnsiString);
    destructor Destroy; override;
  end;

  TSpineTransformConstraintData = class (TSpineClass)
  private
    var _Name: AnsiString;
    var _Order: Integer;
    var _Bones: TSpineBoneDataList;
    var _Target: TSpineBoneData;
    var _RotateMix: Single;
    var _TranslateMix: Single;
    var _ScaleMix: Single;
    var _ShearMix: Single;
    var _OffsetRotation: Single;
    var _OffsetX: Single;
    var _OffsetY: Single;
    var _OffsetScaleX: Single;
    var _OffsetScaleY: Single;
    var _OffsetShearY: Single;
  public
    property Name: AnsiString read _Name;
    property Order: Integer read _Order write _Order;
    property Bones: TSpineBoneDataList read _Bones;
    property Target: TSpineBoneData read _Target write _Target;
    property RotateMix: Single read _RotateMix write _RotateMix;
    property TranslateMix: Single read _TranslateMix write _TranslateMix;
    property ScaleMix: Single read _ScaleMix write _ScaleMix;
    property ShearMix: Single read _ShearMix write _ShearMix;
    property OffsetRotation: Single read _OffsetRotation write _OffsetRotation;
    property OffsetX: Single read _OffsetX write _OffsetX;
    property OffsetY: Single read _OffsetY write _OffsetY;
    property OffsetScaleX: Single read _OffsetScaleX write _OffsetScaleX;
    property OffsetScaleY: Single read _OffsetScaleY write _OffsetScaleY;
    property OffsetShearY: Single read _OffsetShearY write _OffsetShearY;
    constructor Create(const AName: AnsiString);
    destructor Destroy; override;
  end;

  TSpinePathConstraintData = class (TSpineClass)
  public
    type TPositionMode = (
      pm_fixed,
      pm_percent
    );
    type TSpacingMode = (
      sm_length,
      sm_fixed,
      sm_percent
    );
    type TRotateMode = (
      rm_tangent,
      rm_chain,
      rm_chain_scale
    );
  private
    var _Name: AnsiString;
    var _Order: Integer;
    var _Bones: TSpineBoneDataList;
    var _Target: TSpineSlotData;
    var _PositionMode: TPositionMode;
    var _SpacingMode: TSpacingMode;
    var _RotateMode: TRotateMode;
    var _OffsetRotation: Single;
    var _Position: Single;
    var _Spacing: Single;
    var _RotateMix: Single;
    var _TranslateMix: Single;
  public
    property Name: AnsiString read _Name;
    property Order: Integer read _Order write _Order;
    property Bones: TSpineBoneDataList read _Bones;
    property Target: TSpineSlotData read _Target write _Target;
    property PositionMode: TPositionMode read _PositionMode write _PositionMode;
    property SpacingMode: TSpacingMode read _SpacingMode write _SpacingMode;
    property RotateMode: TRotateMode read _RotateMode write _RotateMode;
    property OffsetRotation: Single read _OffsetRotation write _OffsetRotation;
    property Position: Single read _Position write _Position;
    property Spacing: Single read _Spacing write _Spacing;
    property RotateMix: Single read _RotateMix write _RotateMix;
    property TranslateMix: Single read _TranslateMix write _TranslateMix;
    constructor Create(const AName: AnsiString);
    destructor Destroy; override;
  end;

  TSpineBone = class (TSpineClass)
  private
    var _Data: TSpineBoneData;
    var _Skeleton: TSpineSkeleton;
    var _Parent: TSpineBone;
    var _Children: TSpineBoneList;
    var _x: Single;
    var _y: Single;
    var _Rotation: Single;
    var _ScaleX: Single;
    var _ScaleY: Single;
    var _ShearX: Single;
    var _ShearY: Single;
    var _ax: Single;
    var _ay: Single;
    var _ARotation: Single;
    var _AScaleX: Single;
    var _AScaleY: Single;
    var _AShearX: Single;
    var _AShearY: Single;
    var _AppliedValid: Boolean;
    var _a: Single;
    var _b: Single;
    var _WorldX: Single;
    var _c: Single;
    var _d: Single;
    var _WorldY: Single;
    var _Sorted: Boolean;
    function GetWorldRotationX: Single; inline;
    function GetWorldRotationY: Single; inline;
    function GetWorldScaleX: Single; inline;
    function GetWorldScaleY: Single; inline;
    function GetWorldToLocalRotationX: Single; inline;
    function GetWorldToLocalRotationY: Single; inline;
  public
    property Data: TSpineBoneData read _Data;
    property Skeleton: TSpineSkeleton read _Skeleton;
    property Parent: TSpineBone read _Parent;
    property Children: TSpineBoneList read _Children;
    property x: Single read _x write _x;
    property y: Single read _y write _y;
    property Rotation: Single read _Rotation write _Rotation;
    property ScaleX: Single read _ScaleX write _ScaleX;
    property ScaleY: Single read _ScaleY write _ScaleY;
    property ShearX: Single read _ShearX write _ShearX;
    property ShearY: Single read _ShearY write _ShearY;
    property a: Single read _a write _a;
    property b: Single read _b write _b;
    property WorldX: Single read _WorldX write _WorldX;
    property c: Single read _c write _c;
    property d: Single read _d write _d;
    property WorldY: Single read _WorldY write _WorldY;
    property WorldRotationX: Single read GetWorldRotationX;
    property WorldRotationY: Single read GetWorldRotationY;
    property WorldScaleX: Single read GetWorldScaleX;
    property WorldScaleY: Single read GetWorldScaleY;
    property WorldToLocalRotationX: Single read GetWorldToLocalRotationX;
    property WorldToLocalRotationY: Single read GetWorldToLocalRotationY;
    property AppliedValid: Boolean read _AppliedValid write _AppliedValid;
    constructor Create(const AData: TSpineBoneData; const ASkeleton: TSpineSkeleton; const AParent: TSpineBone);
    constructor Create(const ABone: TSpineBone; const ASkeleton: TSpineSkeleton; const AParent: TSpineBone);
    destructor Destroy; override;
    procedure Update; inline;
    procedure UpdateWorldTransform;
    procedure UpdateWorldTransform(const nx, ny, NewRotation, NewScaleX, NewScaleY, NewShearX, NewShearY: Single); overload;
    procedure SetToSetupPose;
    procedure RotateWorld(const Degrees: Single);
    procedure UpdateAppliedTransform;
    function GetWorldTransform(const WorldTransform: TSpineMatrix3): TSpineMatrix3;
    function WorldToLocal(const World: TSpineVector2): TSpineVector2;
    function LocalToWorld(const Local: TSpineVector2): TSpineVector2;
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

  TSpineTransformConstraint = class (TSpineClass)
  private
    var _Data: TSpineTransformConstraintData;
    var _Bones: TSpineBoneList;
    var _Target: TSpineBone;
    var _RotateMix: Single;
    var _TranslateMix: Single;
    var _ScaleMix: Single;
    var _ShearMix: Single;
    var _Temp: TSpineVector2;
  public
    property Data: TSpineTransformConstraintData read _Data;
    property Bones: TSpineBoneList read _Bones;
    property Target: TSpineBone read _Target write _Target;
    property RotateMix: Single read _RotateMix write _RotateMix;
    property TranslateMix: Single read _TranslateMix write _TranslateMix;
    property ScaleMix: Single read _ScaleMix write _ScaleMix;
    property ShearMix: Single read _ShearMix write _ShearMix;
    constructor Create(const AData: TSpineTransformConstraintData; const Skeleton: TSpineSkeleton); overload;
    constructor Create(const AConstraint: TSpineTransformConstraint; const Skeleton: TSpineSkeleton); overload;
    destructor Destroy; override;
    procedure Apply; inline;
    procedure Update;
  end;

  TSpinePathConstraint = class (TSpineClass)
  private
    const NONE = -1;
    const BEFORE = -2;
    const AFTER = -3;
    var _Data: TSpinePathConstraintData;
    var _Bones: TSpineBoneList;
    var _Target: TSpineSlot;
    var _Position: Single;
    var _Spacing: Single;
    var _RotateMix: Single;
    var _TranslateMix: Single;
    var _Spaces: TSpineFloatArray;
    var _Positions: TSpineFloatArray;
    var _World: TSpineFloatArray;
    var _Curves: TSpineFloatArray;
    var _Lengths: TSpineFloatArray;
    var _Segments: array[0..9] of Single;
    function GetOrder: Integer; inline;
    procedure AddBeforePosition(
      const p: Single;
      const temp: TSpineFloatArray;
      const i: Integer;
      var OutVar: TSpineFloatArray;
      const o: Integer
    );
    procedure AddAfterPosition(
      const p: Single;
      const temp: TSpineFloatArray;
      const i: Integer;
      var OutVar: TSpineFloatArray;
      const o: Integer
    );
    procedure AddCurvePosition(
      const p: Single;
      const x1, y1, cx1, cy1, cx2, cy2, x2, y2: Single;
      var OutVar: TSpineFloatArray;
      const o: Integer;
      const Tangents: Boolean
    );
  public
    property Data: TSpinePathConstraintData read _Data;
    property Order: Integer read GetOrder;
    property Position: Single read _Position write _Position;
    property Spacing: Single read _Spacing write _Spacing;
    property RotateMix: Single read _RotateMix write _RotateMix;
    property TranslateMix: Single read _TranslateMix write _TranslateMix;
    property Bones: TSpineBoneList read _Bones;
    property Target: TSpineSlot read _Target;
    constructor Create(const AData: TSpinePathConstraintData; const ASkeleton: TSpineSkeleton); overload;
    constructor Create(const APathConstraint: TSpinePathConstraint; const ASkeleton: TSpineSkeleton); overload;
    destructor Destroy; override;
    procedure Apply; inline;
    procedure Update;
    function ComputeWorldPositions(
      const PathAttachment: TSpinePathAttachment;
      const SpacesCount: Integer;
      const Tangents: Boolean;
      const PercentPosition: Boolean;
      const PercentSpacing: Boolean
    ): TSpineFloatArray;
  end;

  TSpineBoneCacheList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineBoneList>;

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
    var _Rotation: Single;
    var _RotX: Single;
    var _RotY: Single;
    procedure SetIKConstraints(const Value: TSpineIKConstraintList); inline;
    procedure SetRotation(const Value: Single);
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
    property Rotation: Single read _Rotation write SetRotation;
    property rx: Single read _RotX;
    property ry: Single read _RotY;
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
    function FindBone(const BoneName: AnsiString): TSpineBone;
    function FindBoneIndex(const BoneName: AnsiString): Integer;
    function FindSlot(const SlotName: AnsiString): TSpineSlot;
    function FindSlotIndex(const SlotName: AnsiString): Integer;
    function FindIKConstraint(const IKConstraintName: AnsiString): TSpineIKConstraint;
    procedure SetSkinByName(const SkinName: AnsiString);
    function GetAttachment(const SlotName, AttachmentName: AnsiString): TSpineAttachment; overload;
    function GetAttachment(const SlotIndex: Integer; const AttachmentName: AnsiString): TSpineAttachment; overload;
    procedure SetAttachment(const SlotName, AttachmentName: AnsiString);
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
    procedure SetFrame(const FrameIndex: Integer; const Time: Single; const AttachmentName: AnsiString);
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
    destructor Destroy; override;
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

  TSpineTimelineList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineAnimationTimeline>;

  TSpineAnimation = class (TSpineClass)
  private
    var _Timelines: TSpineTimelineList;
    var _Duration: Single;
    var _Name: AnsiString;
  public
    property Name: AnsiString read _Name;
    property Timelines: TSpineTimelineList read _Timelines;
    property Duration: Single read _Duration write _Duration;
    constructor Create(const AName: AnsiString; const ATimelines: TSpineTimelineList; const ADuration: Single);
    destructor Destroy; override;
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
  TSpineAnimationTrackEntryList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineAnimationTrackEntry>;

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
    function SetAnimation(const TrackIndex: Integer; const AnimationName: AnsiString; const Loop: Boolean): TSpineAnimationTrackEntry; overload;
    function SetAnimation(const TrackIndex: Integer; const Animation: TSpineAnimation; const Loop: Boolean): TSpineAnimationTrackEntry; overload;
    function AddAnimation(const TrackIndex: Integer; const AnimationName: AnsiString; const Loop: Boolean; const Delay: Single): TSpineAnimationTrackEntry; overload;
    function AddAnimation(const TrackIndex: Integer; const Animation: TSpineAnimation; const Loop: Boolean; const Delay: Single): TSpineAnimationTrackEntry; overload;
    function GetCurrent(const TrackIndex: Integer): TSpineAnimationTrackEntry;
  end;

  TSpineAnimationMix0 = class;
  TSpineAnimationMix1 = class;
  TSpineAnimationMix0List = {$ifdef fpc}specialize {$endif}TSpineList<TSpineAnimationMix0>;
  TSpineAnimationMix1List = {$ifdef fpc}specialize {$endif}TSpineList<TSpineAnimationMix1>;

  TSpineAnimationMix1 = class (TSpineClass)
  public
    var Anim: TSpineAnimation;
    var Duration: Single;
  end;

  TSpineAnimationMix0 = class (TSpineClass)
  public
    var Anim: TSpineAnimation;
    var MixEntries: TSpineAnimationMix1List;
    constructor Create;
    destructor Destroy; override;
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
    procedure SetMix(const FromName, ToName: AnsiString; const Duration: Single); overload;
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
    var _StringValue: AnsiString;
    function GetName: AnsiString; inline;
  public
    property Name: AnsiString read GetName;
    property IntValue: Integer read _IntValue write _IntValue;
    property FloatValue: Single read _FloatValue write _FloatValue;
    property StringValue: AnsiString read _StringValue write _StringValue;
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
    procedure Apply; overload;
  end;

  TSpineSkinKey = class (TSpineClass)
  private
    var _Attachment: TSpineAttachment;
    procedure SetAttachment(const Value: TSpineAttachment);
  public
    var SlotIndex: Integer;
    var Name: AnsiString;
    constructor Create;
    destructor Destroy; override;
    property Attachment: TSpineAttachment read _Attachment write SetAttachment;
  end;

  TSpineSkinKeyList = {$ifdef fpc}specialize {$endif}TSpineList<TSpineSkinKey>;

  TSpineSkin = class (TSpineClass)
  private
    var _Name: AnsiString;
    var _Attachments: TSpineSkinKeyList;
    property Attachments: TSpineSkinKeyList read _Attachments;
    procedure AttachAll(const Skeleton: TSpineSkeleton; const OldSkin: TSpineSkin);
  public
    property Name: AnsiString read _Name;
    constructor Create(const AName: AnsiString);
    destructor Destroy; override;
    procedure AddAttachment(const SlotIndex: Integer; const KeyName: AnsiString; const Attachment: TSpineAttachment);
    function GetAttachment(const SlotIndex: Integer; const KeyName: AnsiString): TSpineAttachment;
    procedure FindNamesForSlot(const SlotIndex: Integer; var KeyNames: TSpineStringArray);
    procedure FindAttachmentsForSlot(const SlotIndex: Integer; var KeyAttachments: TSpineAttachmentArray);
  end;

  TSpineAtlasPage = class (TSpineClass)
  private
    var _Texture: TSpineTexture;
    procedure SetTexture(const Value: TSpineTexture);
  public
    var Name: AnsiString;
    var Format: TSpineAtlasPageFormat;
    var MinFilter: TSpineAtlasPageTextureFilter;
    var MagFilter: TSpineAtlasPageTextureFilter;
    var WrapU: TSpineAtlasPageWrap;
    var WrapV: TSpineAtlasPageWrap;
    var Width: Integer;
    var Height: Integer;
    property Texture: TSpineTexture read _Texture write SetTexture;
    constructor Create;
    destructor Destroy; override;
  end;

  TSpineAtlasRegion = class (TSpineClass)
  public
    var Page: TSpineAtlasPage;
    var Name: AnsiString;
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
    constructor Create(const Path: AnsiString);
    destructor Destroy; override;
    procedure Load(const Path: AnsiString);
    procedure Clear;
    procedure FlipV;
    function FindRegion(const Name: AnsiString): TSpineAtlasRegion;
  end;

  TSpineAttachment = class (TSpineClass)
  private
    var _Name: AnsiString;
  public
    property Name: AnsiString read _Name write _Name;
    constructor Create(const AName: AnsiString); virtual;
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
    var _Path: AnsiString;
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
    property Path: AnsiString read _Path write _Path;
    property Texture: TSpineTexture read _Texture write SetTexture;
    constructor Create(const AName: AnsiString); override;
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
    constructor Create(const AName: AnsiString); override;
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
    var _Path: AnsiString;
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
    property Path: AnsiString read _Path write _Path;
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
    constructor Create(const AName: AnsiString); override;
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
    var _Path: AnsiString;
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
    property Path: AnsiString read _Path write _Path;
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
    constructor Create(const AName: AnsiString); override;
    destructor Destroy; override;
    procedure UpdateUV;
    procedure ComputeWorldVertices(const Slot: TSpineSlot; var WorldVertices: TSpineFloatArray);
    procedure Draw(const Render: TSpineRender; const Slot: TSpineSlot); override;
  end;

  TSpineVertexAttachment = class (TSpineAttachment)
  private
    var _ID: Integer;
    var _Bones: TSpineIntArray;
    var _Vertices: TSpineFloatArray;
    var _WorldVerticesLength: Integer;
    class var _NextID: Integer;
    class function GetNextID: Integer;
  public
    class constructor CreateClass;
    property ID: Integer read _ID;
    property Bones: TSpineIntArray read _Bones;
    property Vertices: TSpineFloatArray read _Vertices;
    property WorldVerticesLength: Integer read _WorldVerticesLength write _WorldVerticesLength;
    constructor Create(const AName: AnsiString); override;
    procedure ComputeWorldVertices(
      const Slot: TSpineSlot;
      const Start, Count: Integer;
      var WorldVertices: TSpineFloatArray;
      const Offset, Stride: Integer
    );
    function ApplyDeform(const SourceAttachment: TSpineVertexAttachment): Boolean;
    procedure SetBones(const NewBones: array of Integer);
    procedure SetVertices(const NewVertices: array of Single);
  end;

  TSpinePathAttachment = class (TSpineVertexAttachment)
  private
    var _Lengths: TSpineFloatArray;
    var _Closed: Boolean;
    var _ConstantSpeed: Boolean;
    var _Color: TSpineColor;
  public
    property Closed: Boolean read _Closed write _Closed;
    property ConstantSpeed: Boolean read _ConstantSpeed write _ConstantSpeed;
    property Lengths: TSpineFloatArray read _Lengths write _Lengths;
    property Color: TSpineColor read _Color;
    constructor Create(const AName: AnsiString); override;
  end;

  TSpineAttachmentLoader = class (TSpineClass)
  public
    function NewRegionAttachment(const Skin: TSpineSkin; const Name, Path: AnsiString): TSpineRegionAttachment; virtual; abstract;
    function NewMeshAttachment(const Skin: TSpineSkin; const Name, Path: AnsiString): TSpineMeshAttachment; virtual; abstract;
    function NewSkinnedMeshAttachment(const Skin: TSpineSkin; const Name, Path: AnsiString): TSpineSkinnedMeshAttachment; virtual; abstract;
    function NewBoundingBoxAttachment(const Skin: TSpineSkin; const Name, Path: AnsiString): TSpineBoundingBoxAttachment; virtual; abstract;
  end;

  TSpineAtlasAttachmentLoader = class (TSpineAttachmentLoader)
  private
    var _AtlasList: TSpineAtlasList;
    procedure SetAtlasList(const Value: TSpineAtlasList);
  public
    property AtlasList: TSpineAtlasList read _AtlasList write SetAtlasList;
    constructor Create; overload;
    constructor Create(const AAtlasList: TSpineAtlasList); overload;
    destructor Destroy; override;
    function NewRegionAttachment(const Skin: TSpineSkin; const Name, Path: AnsiString): TSpineRegionAttachment; override;
    function NewMeshAttachment(const Skin: TSpineSkin; const Name, Path: AnsiString): TSpineMeshAttachment; override;
    function NewSkinnedMeshAttachment(const Skin: TSpineSkin; const Name, Path: AnsiString): TSpineSkinnedMeshAttachment; override;
    function NewBoundingBoxAttachment(const Skin: TSpineSkin; const Name, Path: AnsiString): TSpineBoundingBoxAttachment; override;
    function FindRegion(const Name: AnsiString): TSpineAtlasRegion;
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
    //const CURVE_LINEAR = 0;
    const CURVE_STEPPED = 1;
    const CURVE_BEZIER = 2;
    var _AttachmentLoader: TSpineAttachmentLoader;
    var _Chars: array of AnsiChar;
    var _Buffer: array[0..3] of Byte;
    var _Scale: Single;
    function ReadInt(const Provider: TSpineDataProvider): Integer; overload;
    function ReadInt(const Provider: TSpineDataProvider; const OptimizePositive: Boolean): Integer; overload;
    function ReadSByte(const Provider: TSpineDataProvider): ShortInt;
    function ReadBool(const Provider: TSpineDataProvider): Boolean;
    function ReadFloat(const Provider: TSpineDataProvider): Single;
    function ReadFloatArray(const Provider: TSpineDataProvider; const ScaleArr: Single): TSpineFloatArray;
    function ReadShortArray(const Provider: TSpineDataProvider): TSpineIntArray;
    function ReadIntArray(const Provider: TSpineDataProvider): TSpineIntArray;
    function ReadString(const Provider: TSpineDataProvider): AnsiString;
    procedure ReadUtf8Slow(const Provider: TSpineDataProvider; const CharCount: Integer; var CharIndex, b: Integer);
    procedure ReadCurve(const Provider: TSpineDataProvider; const FrameIndex: Integer; const Timeline: TSpineAnimationCurveTimeline);
    function ReadSkin(const Provider: TSpineDataProvider; const SkinName: AnsiString; const NonEssential: Boolean): TSpineSkin;
    function ReadAttachment(const Provider: TSpineDataProvider; const Skin: TSpineSkin; const AttachmentName: AnsiString; const NonEssential: Boolean): TSpineAttachment;
    procedure ReadAnimation(const Provider: TSpineDataProvider; const Name: AnsiString; const SkeletonData: TSpineSkeletonData);
  public
    property Scale: Single read _Scale write _Scale;
    constructor Create(const AtlasList: TSpineAtlasList); overload;
    constructor Create(const AttachmentLoader: TSpineAttachmentLoader); overload;
    destructor Destroy; override;
    function ReadSkeletonData(const Path: AnsiString): TSpineSkeletonData; overload;
    function ReadSkeletonData(const Provider: TSpineDataProvider): TSpineSkeletonData; overload;
  end;

function SpineColor(const r, g, b, a: Single): TSpineColor; inline;
function SpineIsNan(const v: Single): Boolean; inline;

const
  SP_DEG_TO_RAD = Pi / 180;
  SP_RAD_TO_DEG = 180 / Pi;
  SP_RCP_255 = 1 / 255;
  SP_M00 = 0;
  SP_M01 = 1;
  SP_M02 = 2;
  SP_M10 = 3;
  SP_M11 = 4;
  SP_M12 = 5;
  SP_M20 = 6;
  SP_M21 = 7;
  SP_M22 = 8;
  SP_EPS = 1E-6;

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
    else Result := -HalfPi;
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

constructor TSpineDataProvider.Create(const AName: AnsiString; const DataSize: Integer);
begin
  _Name := AName;
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

class function TSpineDataProvider.FetchData(const DataName: AnsiString): TSpineDataProvider;
  var FileName: AnsiString;
  var fs: TFileStream;
begin
  Result := nil;
  if FileExists(DataName) then FileName := DataName
  else FileName := ExtractFileDir(ParamStr(0)) + DataName;
  if FileExists(FileName) then
  begin
    fs := TFileStream.Create(FileName, fmOpenRead);
    try
      Result := TSpineDataProvider.Create(DataName, fs.Size);
      fs.Read(Result.Data^, fs.Size);
    finally
      fs.Free;
    end;
  end;
end;

{$Hints off}
class function TSpineDataProvider.FetchTexture(const TextureName: AnsiString): TSpineTexture;
begin
  Result := nil;
end;
{$Hints on}
//TSpineDataProvider END

//TSpineBoneData BEGIN
constructor TSpineBoneData.Create(const AIndex: Integer; const AName: AnsiString; const AParent: TSpineBoneData);
begin
  inherited Create;
  _Index := AIndex;
  _Name := AName;
  _Parent := AParent;
  _ScaleX := 1;
  _ScaleY := 1;
end;

constructor TSpineBoneData.Create(const ABoneData: TSpineBoneData; const AParentBoneData: TSpineBoneData);
begin
  inherited Create;
  _Index := ABoneData.Index;
  _Name := ABoneData.Name;
  _Parent := AParentBoneData;
  _BoneLength := ABoneData.BoneLength;
  _x := ABoneData.x;
  _y := ABoneData.y;
  _Rotation := ABoneData.Rotation;
  _ScaleX := ABoneData.ScaleX;
  _ScaleY := ABoneData.ScaleY;
  _ShearX := ABoneData.ShearX;
  _ShearY := ABoneData.ShearY;
end;
//TSpineBoneData END

//TSpineSlotData BEGIN
constructor TSpineSlotData.Create(const AIndex: Integer; const AName: AnsiString; const ABoneData: TSpineBoneData);
begin
  _Index := AIndex;
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
  _TransformConstraints := TSpineTransformConstraintDataList.Create;
  _PathConstraints := TSpinePathConstraintDataList.Create;
end;

destructor TSpineSkeletonData.Destroy;
begin
  _Bones.Free;
  _Slots.Free;
  _Skins.Free;
  _Events.Free;
  _Animations.Free;
  _IKConstraints.Free;
  _TransformConstraints.Free;
  _PathConstraints.Free;
  inherited Destroy;
end;

function TSpineSkeletonData.FindBone(const BoneName: AnsiString): TSpineBoneData;
  var i: Integer;
begin
  i := FindBoneIndex(BoneName);
  if i > -1 then Result := _Bones[i] else Result := nil;
end;

function TSpineSkeletonData.FindBoneIndex(const BoneName: AnsiString): Integer;
  var i: Integer;
begin
  for i := 0 to _Bones.Count - 1 do
  if _Bones[i].Name = BoneName then Exit(i);
  Result := -1;
end;

function TSpineSkeletonData.FindSlot(const SlotName: AnsiString): TSpineSlotData;
  var i: Integer;
begin
  i := FindSlotIndex(SlotName);
  if i > -1 then Result := _Slots[i] else Result := nil;
end;

function TSpineSkeletonData.FindSlotIndex(const SlotName: AnsiString): Integer;
  var i: Integer;
begin
  for i := 0 to _Slots.Count - 1 do
  if _Slots[i].Name = SlotName then Exit(i);
  Result := -1;
end;

function TSpineSkeletonData.FindSkin(const SkinName: AnsiString): TSpineSkin;
  var i: Integer;
begin
  i := FindSkinIndex(SkinName);
  if i > -1 then Result := _Skins[i] else Result := nil;
end;

function TSpineSkeletonData.FindSkinIndex(const SkinName: AnsiString): Integer;
  var i: Integer;
begin
  for i := 0 to _Skins.Count - 1 do
  if _Skins[i].Name = SkinName then Exit(i);
  Result := -1;
end;

function TSpineSkeletonData.FindEvent(const EventName: AnsiString): TSpineEventData;
  var i: Integer;
begin
  i := FindEventIndex(EventName);
  if i > -1 then Result := _Events[i] else Result := nil;
end;

function TSpineSkeletonData.FindEventIndex(const EventName: AnsiString): Integer;
  var i: Integer;
begin
  for i := 0 to _Events.Count - 1 do
  if _Events[i].Name = EventName then Exit(i);
  Result := -1;
end;

function TSpineSkeletonData.FindAnimation(const AnimationName: AnsiString): TSpineAnimation;
  var i: Integer;
begin
  i := FindAnimationIndex(AnimationName);
  if i > -1 then Result := _Animations[i] else Result := nil;
end;

function TSpineSkeletonData.FindAnimationIndex(const AnimationName: AnsiString): Integer;
  var i: Integer;
begin
  for i := 0 to _Animations.Count - 1 do
  if _Animations[i].Name = AnimationName then Exit(i);
  Result := -1;
end;

function TSpineSkeletonData.FindIKConstraint(const IKConstraintName: AnsiString): TSpineIKConstraintData;
  var i: Integer;
begin
  i := FindIKConstraintIndex(IKConstraintName);
  if i > -1 then Result := _IKConstraints[i] else Result := nil;
end;

function TSpineSkeletonData.FindIKConstraintIndex(const IKConstraintName: AnsiString): Integer;
  var i: Integer;
begin
  for i := 0 to _IKConstraints.Count - 1 do
  if _IKConstraints[i].Name = IKConstraintName then Exit(i);
  Result := -1;
end;

function TSpineSkeletonData.FindTransformConstraint(const TransformConstraintName: AnsiString): TSpineTransformConstraintData;
  var i: Integer;
begin
  i := FindTransformConstraintIndex(TransformConstraintName);
  if i > -1 then Result := _TransformConstraints[i] else Result := nil;
end;

function TSpineSkeletonData.FindTransformConstraintIndex(const TransformConstraintName: AnsiString): Integer;
  var i: Integer;
begin
  for i := 0 to _TransformConstraints.Count - 1 do
  if _TransformConstraints[i].Name = TransformConstraintName then Exit(i);
  Result := -1;
end;
//TSpineSkeletonData END

//TSpineEventData BEGIN
constructor TSpineEventData.Create(const AName: AnsiString);
begin
  inherited Create;
  _Name := AName;
  _IntValue := 0;
  _FloatValue := 0;
  _StringValue := '';
end;
//TSpineEventData END

//TSpineIKConstraintData BEGIN
constructor TSpineIKConstraintData.Create(const AName: AnsiString);
begin
  inherited Create;
  _Bones := TSpineBoneDataList.Create;
  _Name := AName;
end;

destructor TSpineIKConstraintData.Destroy;
begin
  _Bones.Free;
  inherited Destroy;
end;
//TSpineIKConstraintData END

//TSpineTransformConstraintData BEGIN
constructor TSpineTransformConstraintData.Create(const AName: AnsiString);
begin
  inherited Create;
  _Bones := TSpineBoneDataList.Create;
  _Name := AName;
end;

destructor TSpineTransformConstraintData.Destroy;
begin
  _Bones.Free;
  inherited Destroy;
end;
//TSpineTransformConstraintData END

//TSpinePathConstraintData BEIGN
constructor TSpinePathConstraintData.Create(const AName: AnsiString);
begin
  inherited Create;
  _Bones := TSpineBoneDataList.Create;
  _Name := AName;
end;

destructor TSpinePathConstraintData.Destroy;
begin
  _Bones.Free;
  inherited Destroy;
end;
//TSpinePathConstraintData END

//TSpineBone BEGIN
function TSpineBone.GetWorldRotationX: Single;
begin
  Result := SpineArcTan2(_c, _a) * SP_RAD_TO_DEG;
end;

function TSpineBone.GetWorldRotationY: Single;
begin
  Result := SpineArcTan2(_d, _b) * SP_RAD_TO_DEG;
end;

function TSpineBone.GetWorldScaleX: Single;
begin
  Result := sqrt(_a * _a + _c * _c);
end;

function TSpineBone.GetWorldScaleY: Single;
begin
  Result := sqrt(_b * _b + _d * _d);
end;

function TSpineBone.GetWorldToLocalRotationX: Single;
begin
  if not Assigned(_Parent) then Exit(_ARotation);
  Result := SpineArcTan2(_Parent.a * _c - _Parent.c * _a, _Parent.d * _a - _Parent.b * _c) * SP_RAD_TO_DEG;
end;

function TSpineBone.GetWorldToLocalRotationY: Single;
begin
  if not Assigned(_Parent) then Exit(_ARotation);
  Result := SpineArcTan2(_Parent.a * _d - _Parent.c * _b, _Parent.d * _b - _Parent.b * _d) * SP_RAD_TO_DEG;
end;

constructor TSpineBone.Create(const AData: TSpineBoneData; const ASkeleton: TSpineSkeleton; const AParent: TSpineBone);
begin
  inherited Create;
  _Children := TSpineBoneList.Create;
  _Data := AData;
  _Data.RefInc;
  _Skeleton := ASkeleton;
  _Skeleton.RefInc;
  _Parent := AParent;
  SetToSetupPose;
end;

constructor TSpineBone.Create(const ABone: TSpineBone; const ASkeleton: TSpineSkeleton; const AParent: TSpineBone);
begin
  inherited Create;
  _Children := TSpineBoneList.Create;
  _Data := ABone.Data;
  _Data.RefInc;
  _Skeleton := ASkeleton;
  _Skeleton.RefInc;
  _Parent := AParent;
  _x := ABone.x;
  _y := ABone.y;
  _Rotation := ABone.Rotation;
  _ScaleX := ABone.ScaleX;
  _ScaleY := ABone.ScaleY;
  _ShearX := ABone.ShearX;
  _ShearY := ABone.ShearY;
end;

destructor TSpineBone.Destroy;
begin
  _Data.RefDec;
  _Skeleton.RefDec;
  _Children.Free;
  inherited Destroy;
end;

procedure TSpineBone.Update;
begin
  UpdateWorldTransform(_x, _y, _Rotation, _ScaleX, _ScaleY, _ShearX, _ShearY);
end;

procedure TSpineBone.UpdateWorldTransform;
begin
  UpdateWorldTransform(_x, _y, _Rotation, _ScaleX, _ScaleY, _ShearX, _ShearY);
end;

procedure TSpineBone.UpdateWorldTransform(const nx, ny, NewRotation, NewScaleX, NewScaleY, NewShearX, NewShearY: Single);
  var rotation_y, prx, rx, ry, s, r, cc, ss: Single;
  var la, lb, lc, ld: Single;
  var pa, pb, pc, pd: Single;
  var za, zb, zc, zd: Single;
begin
  _ax := nx;
  _ay := ny;
  _ARotation := NewRotation;
  _AScaleX := NewScaleX;
  _AScaleY := NewScaleY;
  _AShearX := NewShearX;
  _AShearY := NewShearY;
  _AppliedValid := true;
  if not Assigned(_Parent) then
  begin
    rotation_y := NewRotation + 90 + NewShearY;
    la := cos((NewRotation + NewShearX) * SP_DEG_TO_RAD) * NewScaleX;
    lb := cos(rotation_y * SP_DEG_TO_RAD) * NewScaleY;
    lc := sin((NewRotation + NewShearX) * SP_DEG_TO_RAD) * NewScaleX;
    ld := sin(rotation_y * SP_DEG_TO_RAD) * NewScaleY;
    if _Skeleton.FlipX then
    begin
      _WorldX := _Skeleton.x - nx;
      la := -la;
      lb := -lb;
    end
    else
    begin
      _WorldX := _Skeleton.x + nx;
    end;
    if _Skeleton.FlipY then
    begin
      _WorldY := _Skeleton.y - ny;
      lc := -lc;
      ld := -ld;
    end
    else
    begin
      _WorldY := _Skeleton.y + ny;
    end;
    _a := la;
    _b := lb;
    _c := lc;
    _d := ld;
    Exit;
  end;
  pa := _Parent.a; pb := _Parent.b; pc := _Parent.c; pd := _Parent.d;
  _WorldX := pa * nx + pb * ny + _Parent.worldX;
  _WorldY := pc * nx + pd * ny + _Parent.worldY;
  case _Data.TransformMode of
    tm_normal:
    begin
      rotation_y := NewRotation + 90 + NewShearY;
      la := cos((NewRotation + NewShearX) * SP_DEG_TO_RAD) * NewScaleX;
      lb := cos(rotation_y * SP_DEG_TO_RAD) * NewScaleY;
      lc := sin((NewRotation + NewShearX) * SP_DEG_TO_RAD) * NewScaleX;
      ld := sin(rotation_y) * NewScaleY;
      _a := pa * la + pb * lc;
      _b := pa * lb + pb * ld;
      _c := pc * la + pd * lc;
      _d := pc * lb + pd * ld;
      Exit;
    end;
    tm_only_translation:
    begin
      rotation_y := NewRotation + 90 + NewShearY;
      _a := cos((NewRotation + NewShearX) * SP_DEG_TO_RAD) * NewScaleX;
      _b := cos(rotation_y * SP_DEG_TO_RAD) * NewScaleY;
      _c := sin((NewRotation + NewShearX) * SP_DEG_TO_RAD) * NewScaleX;
      _d := sin(rotation_y * SP_DEG_TO_RAD) * NewScaleY;
    end;
    tm_no_rotation_or_reflection:
    begin
      s := pa * pa + pc * pc;
      if s > 0.0001 then
      begin
	s := abs(pa * pd - pb * pc) / s;
	pb := pc * s;
	pd := pa * s;
	prx := SpineArcTan2(pc, pa) * SP_RAD_TO_DEG;
      end
      else
      begin
	pa := 0;
	pc := 0;
	prx := 90 - SpineArcTan2(pd, pb) * SP_RAD_TO_DEG;
      end;
      rx := NewRotation + NewShearX - prx;
      ry := NewRotation + NewShearY - prx + 90;
      la := cos(rx * SP_DEG_TO_RAD) * NewScaleX;
      lb := cos(ry * SP_DEG_TO_RAD) * NewScaleY;
      lc := sin(rx * SP_DEG_TO_RAD) * NewScaleX;
      ld := sin(ry * SP_DEG_TO_RAD) * NewScaleY;
      _a := pa * la - pb * lc;
      _b := pa * lb - pb * ld;
      _c := pc * la + pd * lc;
      _d := pc * lb + pd * ld;
    end;
    tm_no_scale, tm_no_scale_or_reflection:
    begin
      cc := cos(NewRotation * SP_DEG_TO_RAD);
      ss := sin(NewRotation * SP_DEG_TO_RAD);
      za := pa * cc + pb * ss;
      zc := pc * cc + pd * ss;
      s := sqrt(za * za + zc * zc);
      if s > 0.00001 then s := 1 / s;
      za *= s;
      zc *= s;
      s := sqrt(za * za + zc * zc);
      r := Pi / 2 + SpineArcTan2(zc, za);
      zb := cos(r) * s;
      zd := sin(r) * s;
      la := cos(NewShearX * SP_DEG_TO_RAD) * NewScaleX;
      lb := cos((90 + NewShearY) * SP_DEG_TO_RAD) * NewScaleY;
      lc := sin(NewShearX * SP_DEG_TO_RAD) * NewScaleX;
      ld := sin((90 + NewShearY) * SP_DEG_TO_RAD) * NewScaleY;
      _a := za * la + zb * lc;
      _b := za * lb + zb * ld;
      _c := zc * la + zd * lc;
      _d := zc * lb + zd * ld;
      if ((_Data.TransformMode = tm_no_scale_or_reflection) and (_Skeleton.FlipX <> _Skeleton.FlipY))
      or ((_Data.TransformMode <> tm_no_scale_or_reflection) and (pa * pd - pb * pc < 0)) then
      begin
	_b := -_b;
	_d := -_d;
      end;
      Exit;
    end;
  end;
  if _Skeleton.FlipX then
  begin
    _a := -_a;
    _b := -_b;
  end;
  if _Skeleton.FlipY then
  begin
    _c := -_c;
    _d := -_d;
  end;
end;

procedure TSpineBone.SetToSetupPose;
begin
  _x := _Data.x;
  _y := _Data.y;
  _Rotation := _Data.Rotation;
  _ScaleX := _Data.ScaleX;
  _ScaleY := _Data.ScaleY;
  _ShearX := _Data.ShearX;
  _ShearY := _Data.ShearY;
end;

procedure TSpineBone.RotateWorld(const Degrees: Single);
  var cc, ss: Single;
begin
  cc := cos(Degrees * SP_DEG_TO_RAD);
  ss := sin(Degrees * SP_DEG_TO_RAD);
  _a := cc * _a - ss * _c;
  _b := cc * _b - ss * _d;
  _c := ss * _a + cc * _c;
  _d := ss * _b + cc * _d;
  _AppliedValid := False;
end;

procedure TSpineBone.UpdateAppliedTransform;
  var pid, dx, dy, det: Single;
  var pa, pb, pc, pd: Single;
  var ia, ib, ic, id: Single;
  var ra, rb, rc, rd: Single;
begin
  _AppliedValid := True;
  if not Assigned(_Parent) then
  begin
    _ax := _WorldX;
    _ay := _WorldY;
    _ARotation := SpineArcTan2(_c, _a) * SP_RAD_TO_DEG;
    _AScaleX := sqrt(_a * _a + _c * _c);
    _AScaleY := sqrt(_b * _b + _d * _d);
    _AShearX := 0;
    _AShearY := SpineArcTan2(_a * _b + _c * _d, _a * _d - _b * _c) * SP_RAD_TO_DEG;
    Exit;
  end;
  pa := _Parent.a; pb := _Parent.b; pc := _Parent.c; pd := _Parent.d;
  pid := 1 / (pa * pd - pb * pc);
  dx := _WorldX - _Parent.WorldX; dy := _WorldY - _Parent.WorldY;
  _ax := (dx * pd * pid - dy * pb * pid);
  _ay := (dy * pa * pid - dx * pc * pid);
  ia := pid * pd;
  id := pid * pa;
  ib := pid * pb;
  ic := pid * pc;
  ra := ia * a - ib * c;
  rb := ia * b - ib * d;
  rc := id * c - ic * a;
  rd := id * d - ic * b;
  _AShearX := 0;
  _AScaleX := sqrt(ra * ra + rc * rc);
  if _AScaleX > 0.0001 then
  begin
    det := ra * rd - rb * rc;
    _AScaleY := det / _AScaleX;
    _AShearY := SpineArcTan2(ra * rb + rc * rd, det) * SP_RAD_TO_DEG;
    _ARotation := SpineArcTan2(rc, ra) * SP_RAD_TO_DEG;
  end
  else
  begin
    _AScaleX := 0;
    _AScaleY := sqrt(rb * rb + rd * rd);
    _AShearY := 0;
    _ARotation := 90 - SpineArcTan2(rd, rb) * SP_RAD_TO_DEG;
  end;
end;

function TSpineBone.GetWorldTransform(const WorldTransform: TSpineMatrix3): TSpineMatrix3;
begin
  Result[SP_M00] := _a;
  Result[SP_M01] := _b;
  Result[SP_M10] := _c;
  Result[SP_M11] := _d;
  Result[SP_M02] := _WorldX;
  Result[SP_M12] := _WorldY;
  Result[SP_M20] := 0;
  Result[SP_M21] := 0;
  Result[SP_M22] := 1;
end;

function TSpineBone.WorldToLocal(const World: TSpineVector2): TSpineVector2;
  var det_rcp: Single;
  var wx, wy: Single;
begin
  det_rcp := 1 / (_a * _d - _b * _c);
  wx := World[0] - _WorldX; wy := World[1] - _WorldY;
  Result[0] := wx * _d * det_rcp - _y * _b * det_rcp;
  Result[1] := wy * _a * det_rcp - _x * _c * det_rcp;
end;

function TSpineBone.LocalToWorld(const Local: TSpineVector2): TSpineVector2;
begin
  Result[0] := Local[0] * _a + Local[1] * _b + _WorldX;
  Result[1] := Local[0] * _c + Local[1] * _d + _WorldY;
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

//TSpineTransformConstraint BEGIN
constructor TSpineTransformConstraint.Create(const AData: TSpineTransformConstraintData; const Skeleton: TSpineSkeleton);
  var i: Integer;
begin
  inherited Create;
  _Bones := TSpineBoneList.Create;
  _Data := AData;
  _Data.RefInc;
  _RotateMix := _Data.RotateMix;
  _TranslateMix := _Data.translateMix;
  _ScaleMix := _Data.ScaleMix;
  _ShearMix := _Data._ShearMix;
  for i := 0 to _Data.Bones.Count - 1 do
  begin
    _Bones.Add(Skeleton.FindBone(_Data.Bones[i].Name));
  end;
  _Target := Skeleton.FindBone(_Data.Target.Name);
end;

constructor TSpineTransformConstraint.Create(const AConstraint: TSpineTransformConstraint; const Skeleton: TSpineSkeleton);
  var i: Integer;
begin
  inherited Create;
  _Bones := TSpineBoneList.Create;
  _Data := AConstraint.Data;
  _Data.RefInc;
  for i := 0 to AConstraint.Bones.Count - 1 do
  begin
    _Bones.Add(Skeleton.Bones[AConstraint.Bones[i].Data.Index]);
  end;
  _Target := Skeleton.Bones[AConstraint.Target.Data.Index];
  _RotateMix := AConstraint.RotateMix;
  _TranslateMix := AConstraint.TranslateMix;
  _ScaleMix := AConstraint.ScaleMix;
  _ShearMix := AConstraint.ShearMix;
end;

destructor TSpineTransformConstraint.Destroy;
begin
  inherited Destroy;
  _Data.RefDec;
  _Bones.Free;
end;

procedure TSpineTransformConstraint.Apply;
begin
  Update();
end;

procedure TSpineTransformConstraint.Update;
  var ta, tb, tc, td: Single;
  var ba, bb, bc, bd: Single;
  var r, ss, cc, s, ts, by: Single;
  var deg_rad_reflect, offset_rotation, offset_shear_y: Single;
  var i: Integer;
  var bone: TSpineBone;
  var modified: Boolean;
begin
  ta := _Target.a; tb := _Target.b; tc := _Target.c; td := _Target.d;
  if ta * td - tb * tc > 0 then deg_rad_reflect := SP_DEG_TO_RAD else deg_rad_reflect := -SP_DEG_TO_RAD;
  offset_rotation := _Data.OffsetRotation * deg_rad_reflect; offset_shear_y := _Data.OffsetShearY * deg_rad_reflect;
  for i := 0 to _Bones.Count - 1 do
  begin
    bone := _Bones[i];
    modified := False;
    if _RotateMix <> 0 then
    begin
      ba := bone.a; bb := bone.b; bc := bone.c; bd := bone.d;
      r := SpineArcTan2(tc, ta) - SpineArcTan2(bc, ba) + offset_rotation;
      if (r > Pi) then r -= Pi * 2
      else if (r < -Pi) then r += Pi * 2;
      r *= _RotateMix;
      cc := cos(r); ss := sin(r);
      bone.a := cc * ba - ss * bc;
      bone.b := cc * bb - ss * bd;
      bone.c := ss * ba + cc * bc;
      bone.d := ss * bb + cc * bd;
      modified := True;
    end;
    if _TranslateMix <> 0 then
    begin
      _Temp[0] := _Data.OffsetX; _Temp[1] := _Data.OffsetY;
      _Temp := _Target.LocalToWorld(_Temp);
      bone.WorldX := bone.WorldX + (_Temp[0] - bone.WorldX) * _TranslateMix;
      bone.WorldY := bone.WorldY + (_Temp[1] - bone.WorldY) * _TranslateMix;
      modified := True;
    end;
    if _ScaleMix > 0 then
    begin
      s := sqrt(bone.a * bone.a + bone.c * bone.c);
      ts := sqrt(ta * ta + tc * tc);
      if s > 0.00001 then s := (s + (ts - s + _Data.OffsetScaleX) * _ScaleMix) / s;
      bone.a := bone.a * s;
      bone.c := bone.c * s;
      s := sqrt(bone.b * bone.b + bone.d * bone.d);
      ts := sqrt(tb * tb + td * td);
      if s > 0.00001 then s := (s + (ts - s + _Data.OffsetScaleY) * _ScaleMix) / s;
      bone.b := bone.b * s;
      bone.d := bone.d * s;
      modified := True;
    end;
    if _ShearMix > 0 then
    begin
      bb := bone.b; bd := bone.d;
      by := SpineArcTan2(bd, bb);
      r := SpineArcTan2(td, tb) - SpineArcTan2(tc, ta) - (by - SpineArcTan2(bone.c, bone.a));
      if r > Pi then r -= Pi * 2
      else if r < -Pi then r += Pi * 2;
      r := by + (r + offset_shear_y) * _ShearMix;
      s := sqrt(bb * bb + bd * bd);
      bone.b := cos(r) * s;
      bone.d := sin(r) * s;
      modified := true;
    end;
    if (modified) then bone.AppliedValid := False;
  end;
end;
//TSpineTransformConstraint END

//TSpinePathConstraint BEGIN
function TSpinePathConstraint.GetOrder: Integer;
begin
  Result := _Data.Order;
end;

procedure TSpinePathConstraint.AddBeforePosition(
  const p: Single;
  const temp: TSpineFloatArray;
  const i: Integer;
  var OutVar: TSpineFloatArray;
  const o: Integer
);
  var x1, y1, dx, dy, r: Single;
begin
  x1 := temp[i]; y1 := temp[i + 1];
  dx := temp[i + 2] - x1;
  dy := temp[i + 3] - y1;
  r := SpineArcTan2(dy, dx);
  OutVar[o] := x1 + p * Cos(r);
  OutVar[o + 1] := y1 + p * Sin(r);
  OutVar[o + 2] := r;
end;

procedure TSpinePathConstraint.AddAfterPosition(
  const p: Single;
  const temp: TSpineFloatArray;
  const i: Integer;
  var OutVar: TSpineFloatArray;
  const o: Integer
);
  var x1, y1, dx, dy, r: Single;
begin
  x1 := temp[i + 2];
  y1 := temp[i + 3];
  dx := x1 - temp[i];
  dy := y1 - temp[i + 1];
  r := SpineArcTan2(dy, dx);
  OutVar[o] := x1 + p * Cos(r);
  OutVar[o + 1] := y1 + p * Sin(r);
  OutVar[o + 2] := r;
end;

procedure TSpinePathConstraint.AddCurvePosition(
  const p: Single; const x1, y1, cx1, cy1, cx2, cy2, x2, y2: Single;
  var OutVar: TSpineFloatArray;
  const o: Integer;
  const Tangents: Boolean
);
  var vp: Single;
  var tt, ttt, u, uu, uuu, ut, ut3, uut3, utt3, x, y: Single;
begin
  vp := p;
  if (vp < SP_EPS) or SpineIsNan(vp) then vp := SP_EPS;
  tt := vp * vp; ttt := tt * vp; u := 1 - vp; uu := u * u; uuu := uu * u;
  ut := u * vp; ut3 := ut * 3; uut3 := u * ut3; utt3 := ut3 * vp;
  x := x1 * uuu + cx1 * uut3 + cx2 * utt3 + x2 * ttt;
  y := y1 * uuu + cy1 * uut3 + cy2 * utt3 + y2 * ttt;
  OutVar[o] := x;
  OutVar[o + 1] := y;
  if Tangents then
  begin
    OutVar[o + 2] := SpineArcTan2(
      y - (y1 * uu + cy1 * ut * 2 + cy2 * tt),
      x - (x1 * uu + cx1 * ut * 2 + cx2 * tt)
    );
  end;
end;

constructor TSpinePathConstraint.Create(const AData: TSpinePathConstraintData; const ASkeleton: TSpineSkeleton);
  var i: Integer;
begin
  inherited Create;
  _Bones := TSpineBoneList.Create;
  _Data := AData;
  _Data.RefInc;
  for i := 0 to _Data.Bones.Count - 1 do
  begin
    _Bones.Add(ASkeleton.FindBone(_Data.Bones[i].Name));
  end;
  _Target := ASkeleton.FindSlot(_Data.Target.Name);
  _Position := _Data.Position;
  _Spacing := _Data.Spacing;
  _RotateMix := _Data.RotateMix;
  _TranslateMix := _Data.TranslateMix;
end;

constructor TSpinePathConstraint.Create(const APathConstraint: TSpinePathConstraint; const ASkeleton: TSpineSkeleton);
  var i: Integer;
begin
  inherited Create;
  _Bones := TSpineBoneList.Create;
  _Data := APathConstraint.Data;
  _Data.RefInc;
  for i := 0 to APathConstraint.Bones.Count - 1 do
  begin
    _Bones.Add(ASkeleton.Bones[APathConstraint.Bones[i].Data.Index]);
  end;
  _Target := ASkeleton.Slots[APathConstraint.Target.Data.Index];
  _Position := APathConstraint.Position;
  _Spacing := APathConstraint.Spacing;
  _RotateMix := APathConstraint.RotateMix;
  _TranslateMix := APathConstraint.TranslateMix;
end;

destructor TSpinePathConstraint.Destroy;
begin
  _Data.RefDec;
  _Bones.Free;
  inherited Destroy;
end;

procedure TSpinePathConstraint.Apply;
begin
  Update;
end;

procedure TSpinePathConstraint.Update;
  var attachment: TSpineAttachment;
  var bone: TSpineBone;
  var translate, rotate, length_spacing, tangents, scale, tip: Boolean;
  var i, p, spaces_count: Integer;
  var s, l, x, y, dx, dy, bone_x, bone_y, offset_rotation, ba, bb, bc, bd, r, ss, cc: Single;
  var world_positions: TSpineFloatArray;
begin
  attachment := _Target.Attachment;
  if not (attachment is TSpinePathAttachment) then Exit;
  translate := _TranslateMix > 0;
  rotate := _RotateMix > 0;
  if not (translate or rotate) then Exit;
  //SpacingMode spacingMode = data.spacingMode;
  length_spacing := _Data.SpacingMode = TSpinePathConstraintData.TSpacingMode.sm_length;
  //RotateMode rotateMode = data.rotateMode;
  tangents := _Data.RotateMode = TSpinePathConstraintData.TRotateMode.rm_tangent;
  scale := _Data.RotateMode = TSpinePathConstraintData.TRotateMode.rm_chain_scale;
  //int boneCount = this.bones.size;
  if tangents then spaces_count := _Bones.Count else spaces_count := _Bones.Count + 1;
  //Object[] bones = this.bones.items;
  if Length(_Spaces) <> spaces_count then SetLength(_Spaces, spaces_count);
  //float[] spaces = this.spaces.setSize(spacesCount), lengths = null;
  //float spacing = this.spacing;
  if scale or length_spacing then
  begin
    if scale and (Length(_Lengths) <> _Bones.Count) then
    begin
      SetLength(_Lengths, _Bones.Count);
    end;
    for i := 0 to spaces_count - 2 do
    begin
      l := _Bones[i].Data.BoneLength;
      x := l * _Bones[i].a;
      y := l * _Bones[i].c;
      l := sqrt(x * x + y * y);
      if (scale) then _Lengths[i] := l;
      if length_spacing then _Spaces[i + 1] := SpineMax(0, l + _Spacing) else _Spaces[i + 1] := _Spacing;
    end;
  end
  else
  begin
    for i := 1 to spaces_count - 1 do _Spaces[i] := _Spacing;
  end;
  world_positions := ComputeWorldPositions(
    TSpinePathAttachment(attachment),
    spaces_count,
    tangents,
    _Data.PositionMode = TSpinePathConstraintData.TPositionMode.pm_percent,
    _Data.SpacingMode = TSpinePathConstraintData.TSpacingMode.sm_percent
  );
  //float[] positions = computeWorldPositions((PathAttachment)attachment, spacesCount, tangents,
  //	  data.positionMode == PositionMode.percent, spacingMode == SpacingMode.percent);
  bone_x := world_positions[0];
  bone_y := world_positions[1];
  offset_rotation := _Data.OffsetRotation;
  if _Data.OffsetRotation = 0 then
  begin
    tip := _Data.RotateMode = TSpinePathConstraintData.TRotateMode.rm_chain;
  end
  else
  begin
    tip := False;
    if _Target.Bone.a * _Target.Bone.d - _Target.Bone.b * _Target.Bone.c > 0 then
    begin
      offset_rotation *= SP_DEG_TO_RAD;
    end
    else
    begin
      offset_rotation *= -SP_DEG_TO_RAD;
    end;
  end;
  p := 3;
  for i := 0 to _Bones.Count - 1 do
  begin
    bone := _Bones[i];
    bone.WorldX := bone.WorldX + (bone_x - bone.WorldX) * _TranslateMix;
    bone.WorldY := bone.WorldY + (bone_y - bone.WorldY) * _TranslateMix;
    x := world_positions[p];
    y := world_positions[p + 1];
    dx := x - bone_x;
    dy := y - bone_y;
    if scale then
    begin
      l := _Lengths[i];
      if l <> 0 then
      begin
	s := (sqrt(dx * dx + dy * dy) / l - 1) * _RotateMix + 1;
	bone.a := bone.a * s;
	bone.c := bone.c * s;
      end;
    end;
    bone_x := x;
    bone_y := y;
    if rotate then
    begin
      ba := bone.a; bb := bone.b; bc := bone.c; bd := bone.d;
      if tangents then
      begin
        r := world_positions[p - 1];
      end
      else if _Spaces[i + 1] = 0 then
      begin
        r := world_positions[p + 2];
      end
      else
      begin
        r := SpineArcTan2(dy, dx);
      end;
      r -= SpineArcTan2(bc, ba);
      if tip then
      begin
	cc := cos(r);
	ss := sin(r);
	l := bone.Data.BoneLength;
	bone_x += (l * (cc * ba - ss * bc) - dx) * _RotateMix;
	bone_y += (l * (ss * ba + cc * bc) - dy) * _RotateMix;
      end
      else
      begin
        r += offset_rotation;
      end;
      if r > Pi then r -= Pi * 2
      else if r < -Pi then r += Pi * 2;
      r *= _RotateMix;
      cc := cos(r);
      ss := sin(r);
      bone.a := cc * ba - ss * bc;
      bone.b := cc * bb - ss * bd;
      bone.c := ss * ba + cc * bc;
      bone.d := ss * bb + cc * bd;
    end;
    bone.AppliedValid := False;
    Inc(p, 3);
  end;
end;

function TSpinePathConstraint.ComputeWorldPositions(
  const PathAttachment: TSpinePathAttachment;
  const SpacesCount: Integer;
  const Tangents: Boolean;
  const PercentPosition: Boolean;
  const PercentSpacing: Boolean
): TSpineFloatArray;
  var closed: Boolean;
  var i, o, curve, segment, vertices_length, curve_count, prev_curve, w: Integer;
  var ii: Integer;
  var lengths: TSpineFloatArray;
  var path_length, curve_length, l, prev: Single;
  var pos, space, p: Single;
  var x1, y1, x2, y2, cx1, cy1, cx2, cy2: Single;
  var tmpx, tmpy, dddfx, dddfy, ddfx, ddfy, dfx, dfy: Single;
begin
  //Slot target = this.target;
  pos := _Position;
  //float[] spaces = this.spaces.items,
  if (Length(_Positions) <> SpacesCount * 3 + 2) then SetLength(_Positions, SpacesCount * 3 + 2);
  //float[] world;
  closed := PathAttachment.Closed;
  vertices_length := PathAttachment.WorldVerticesLength;
  curve_count := vertices_length div 6;
  prev_curve := NONE;
  if not PathAttachment.ConstantSpeed then
  begin
    lengths := PathAttachment.Lengths;
    if closed then curve_count -= 1 else curve_count -= 2;
    path_length := lengths[curve_count];
    if PercentPosition then pos *= path_length;
    if PercentSpacing then
    begin
      for i := 0 to SpacesCount - 1 do _Spaces[i] *= path_length;
    end;
    if Length(_World) <> 8 then SetLength(_World, 8);
    curve := 0;
    for i := 0 to SpacesCount - 1 do
    begin
      o := i * 3;
      space := _Spaces[i];
      pos += space;
      p := pos;
      if closed then
      begin
	p := SpineModFloat(p, path_length);
	if p < 0 then p += path_length;
	curve := 0;
      end
      else if p < 0 then
      begin
	if prev_curve <> BEFORE then
        begin
	  prev_curve := BEFORE;
	  PathAttachment.ComputeWorldVertices(_Target, 2, 4, _World, 0, 2);
	end;
	AddBeforePosition(p, _World, 0, _Positions, o);
	Continue;
      end
      else if p > path_length then
      begin
	if prev_curve <> AFTER then
        begin
	  prev_curve := AFTER;
	  PathAttachment.ComputeWorldVertices(_Target, vertices_length - 6, 4, _World, 0, 2);
	end;
	AddAfterPosition(p - path_length, _World, 0, _Positions, o);
	Continue;
      end;
      while True do
      begin
	l := lengths[curve];
	if p > l then Continue;
	if curve = 0 then
        begin
          p := p / l;
        end
	else
        begin
	  prev := lengths[curve - 1];
	  p := (p - prev) / (l - prev);
	end;
	Break;
        Inc(curve);
      end;
      if curve <> prev_curve then
      begin
	prev_curve := curve;
	if closed and (curve = curve_count) then
        begin
	  PathAttachment.ComputeWorldVertices(_Target, vertices_length - 4, 4, _World, 0, 2);
	  PathAttachment.ComputeWorldVertices(_Target, 0, 4, _World, 4, 2);
	end
        else
        begin
	  PathAttachment.ComputeWorldVertices(_Target, curve * 6 + 2, 8, _World, 0, 2);
        end;
      end;
      AddCurvePosition(
        p, _World[0], _World[1], _World[2], _World[3], _World[4], _World[5], _World[6], _World[7],
        _Positions, o, tangents or ((i > 0) and (space = 0))
      );
    end;
    Exit(_Positions);
  end;

  // World vertices.
  if closed then
  begin
    vertices_length += 2;
    SetLength(_World, vertices_length);
    PathAttachment.ComputeWorldVertices(_Target, 2, vertices_length - 4, _World, 0, 2);
    PathAttachment.computeWorldVertices(_Target, 0, 2, _World, vertices_length - 4, 2);
    _World[vertices_length - 2] := _World[0];
    _World[vertices_length - 1] := _World[1];
  end
  else
  begin
    curve_count -= 1;
    vertices_length -= 4;
    SetLength(_World, vertices_length);
    PathAttachment.ComputeWorldVertices(_Target, 2, vertices_length, _World, 0, 2);
  end;

  // Curve lengths.
  SetLength(_Curves, curve_count);
  path_length := 0;
  x1 := _World[0]; y1 := _World[1];
  cx1 := 0; cy1 := 0; cx2 := 0; cy2 := 0; x2 := 0; y2 := 0;
  w := 2;
  for i := 0 to curve_count - 1 do
  begin
    cx1 := _World[w];
    cy1 := _World[w + 1];
    cx2 := _World[w + 2];
    cy2 := _World[w + 3];
    x2 := _World[w + 4];
    y2 := _World[w + 5];
    tmpx := (x1 - cx1 * 2 + cx2) * 0.1875;
    tmpy := (y1 - cy1 * 2 + cy2) * 0.1875;
    dddfx := ((cx1 - cx2) * 3 - x1 + x2) * 0.09375;
    dddfy := ((cy1 - cy2) * 3 - y1 + y2) * 0.09375;
    ddfx := tmpx * 2 + dddfx;
    ddfy := tmpy * 2 + dddfy;
    dfx := (cx1 - x1) * 0.75 + tmpx + dddfx * 0.16666667;
    dfy := (cy1 - y1) * 0.75 + tmpy + dddfy * 0.16666667;
    path_length += sqrt(dfx * dfx + dfy * dfy);
    dfx += ddfx;
    dfy += ddfy;
    ddfx += dddfx;
    ddfy += dddfy;
    path_length += sqrt(dfx * dfx + dfy * dfy);
    dfx += ddfx;
    dfy += ddfy;
    path_length += sqrt(dfx * dfx + dfy * dfy);
    dfx += ddfx + dddfx;
    dfy += ddfy + dddfy;
    path_length += sqrt(dfx * dfx + dfy * dfy);
    _Curves[i] := path_length;
    x1 := x2;
    y1 := y2;
    w += 6;
  end;
  if (PercentPosition) then _Position *= path_length;
  if (PercentSpacing) then
  begin
    for i := 0 to SpacesCount - 1 do _Spaces[i] *= path_length;
  end;

  curve_length := 0;
  o := 0;
  curve := 0;
  segment := 0;
  //for (int i = 0, o = 0, curve = 0, segment = 0; i < spacesCount; i++, o += 3) {
  for i := 0 to SpacesCount - 1 do
  begin
    space := _Spaces[i];
    _Position += space;
    p := _Position;
    if (closed) then
    begin
      p := SpineModFloat(p, path_length);
      if (p < 0) then p += path_length;
      curve := 0;
    end
    else if (p < 0) then
    begin
      AddBeforePosition(p, _World, 0, _Positions, o);
      Continue;
    end
    else if (p > path_length) then
    begin
      AddAfterPosition(p - path_length, _World, vertices_length - 4, _Positions, o);
      Continue;
    end;

    // Determine curve containing position.
    //for (;; curve++) {
    while True do
    begin
      l := _Curves[curve];
      if (p > l) then Continue;
      if (curve = 0) then p := p / l
      else
      begin
	prev := _Curves[curve - 1];
	p := (p - prev) / (l - prev);
      end;
      Break;
      curve += 1;
    end;

    // Curve segment lengths.
    if (curve <> prev_curve) then
    begin
      prev_curve := curve;
      ii := curve * 6;
      x1 := _World[ii];
      y1 := _World[ii + 1];
      cx1 := _World[ii + 2];
      cy1 := _World[ii + 3];
      cx2 := _World[ii + 4];
      cy2 := _World[ii + 5];
      x2 := _World[ii + 6];
      y2 := _World[ii + 7];
      tmpx := (x1 - cx1 * 2 + cx2) * 0.03;
      tmpy := (y1 - cy1 * 2 + cy2) * 0.03;
      dddfx := ((cx1 - cx2) * 3 - x1 + x2) * 0.006;
      dddfy := ((cy1 - cy2) * 3 - y1 + y2) * 0.006;
      ddfx := tmpx * 2 + dddfx;
      ddfy := tmpy * 2 + dddfy;
      dfx := (cx1 - x1) * 0.3 + tmpx + dddfx * 0.16666667;
      dfy := (cy1 - y1) * 0.3 + tmpy + dddfy * 0.16666667;
      curve_length := sqrt(dfx * dfx + dfy * dfy);
      _Segments[0] := curve_length;
      for ii := 1 to 7 do
      begin
	dfx += ddfx;
	dfy += ddfy;
	ddfx += dddfx;
	ddfy += dddfy;
	curve_length += sqrt(dfx * dfx + dfy * dfy);
	_Segments[ii] := curve_length;
      end;
      dfx += ddfx;
      dfy += ddfy;
      curve_length += sqrt(dfx * dfx + dfy * dfy);
      _Segments[8] := curve_length;
      dfx += ddfx + dddfx;
      dfy += ddfy + dddfy;
      curve_length += sqrt(dfx * dfx + dfy * dfy);
      _Segments[9] := curve_length;
      segment := 0;
    end;

    // Weight by segment length.
    p *= curve_length;
    //for (;; segment++) {
    while True do
    begin
      l := _Segments[segment];
      if (p > l) then
      begin
        segment += 1;
        Continue;
      end;
      if (segment = 0) then p := p / l
      else
      begin
	prev := _Segments[segment - 1];
	p := segment + (p - prev) / (l - prev);
      end;
      Break;
    end;
    AddCurvePosition(p * 0.1, x1, y1, cx1, cy1, cx2, cy2, x2, y2, _Positions, o, Tangents or ((i > 0) and (space < SP_EPS)));
    o += 3;
  end;
  Result := _Positions;
end;
//TSpinePathConstraint END

//TSpineSkeleton BEGIN
procedure TSpineSkeleton.SetIKConstraints(const Value: TSpineIKConstraintList);
begin
  if Assigned(_IKConstraints) then _IKConstraints.RefDec;
  _IKConstraints := Value;
  if Assigned(_IKConstraints) then _IKConstraints.RefInc;
end;

procedure TSpineSkeleton.SetRotation(const Value: Single);
begin
  if _Rotation = Value then Exit;
  _Rotation := Value;
  _RotX := Cos(SP_DEG_TO_RAD * _Rotation);
  _RotY := -Sin(SP_DEG_TO_RAD * _Rotation);
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
  _Rotation := 0;
  _RotX := 1;
  _RotY := 0;
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
  //for i := 0 to _Bones.Count - 1 do
  //_Bones[i].RotationIK := _Bones[i].Rotation;
  //i := 0;
  //last := _IKConstraints.Count;
  //while True do
  //begin
  //  UpdateBones := _BoneCache[i];
  //  for j := 0 to UpdateBones.Count - 1 do
  //  UpdateBones[j].UpdateWorldTransform;
  //  if i = last then Break;
  //  _IKConstraints[i].Apply;
  //  Inc(i);
  //end;
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

function TSpineSkeleton.FindBone(const BoneName: AnsiString): TSpineBone;
  var i: Integer;
begin
  i := FindBoneIndex(BoneName);
  if i > -1 then Result := _Bones[i] else Result := nil;
end;

function TSpineSkeleton.FindBoneIndex(const BoneName: AnsiString): Integer;
  var i: Integer;
begin
  for i := 0 to _Bones.Count - 1 do
  if _Bones[i].Data.Name = BoneName then
  Exit(i);
  Result := -1;
end;

function TSpineSkeleton.FindSlot(const SlotName: AnsiString): TSpineSlot;
  var i: Integer;
begin
  i := FindSlotIndex(SlotName);
  if i > -1 then Result := _Slots[i] else Result := nil;
end;

function TSpineSkeleton.FindSlotIndex(const SlotName: AnsiString): Integer;
  var i: Integer;
begin
  for i := 0 to _Slots.Count - 1 do
  if _Slots[i].Data.Name = SlotName then
  Exit(i);
  Result := -1;
end;

function TSpineSkeleton.FindIKConstraint(const IKConstraintName: AnsiString): TSpineIKConstraint;
  var i: Integer;
begin
  for i := 0 to _IKConstraints.Count - 1 do
  if _IKConstraints[i].Data.Name = IKConstraintName then
  Exit(_IKConstraints[i]);
  Result := nil;
end;

procedure TSpineSkeleton.SetSkinByName(const SkinName: AnsiString);
  var TempSkin: TSpineSkin;
begin
  TempSkin := _Data.FindSkin(SkinName);
  if Assigned(TempSkin) then Skin := TempSkin;
end;

function TSpineSkeleton.GetAttachment(const SlotName, AttachmentName: AnsiString): TSpineAttachment;
begin
  Result := GetAttachment(_Data.FindSlotIndex(SlotName), AttachmentName);
end;

function TSpineSkeleton.GetAttachment(const SlotIndex: Integer; const AttachmentName: AnsiString): TSpineAttachment;
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

procedure TSpineSkeleton.SetAttachment(const SlotName, AttachmentName: AnsiString);
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
  _Time := _Time + Delta;
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
    dfx := dfx + ddfx;
    dfy := dfy + ddfy;
    ddfx := ddfx + dddfx;
    ddfy := ddfy + dddfy;
    x := x + dfx;
    y := y + dfy;
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

{$Hints off}
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
    while Amount > 180 do Amount := Amount - 360;
    while Amount < -180 do Amount := Amount + 360;
    Bone.Rotation := Bone.Rotation + (Amount * Alpha);
    Exit;
  end;
  FrameIndex := TSpineAnimation.BinarySearch(_Frames, Time, 2);
  PrevFrameValue := _Frames[FrameIndex - 1];
  FrameTime := _Frames[FrameIndex];
  dv := _Frames[FrameIndex + PREV_FRAME_TIME] - FrameTime; Assert(dv <> 0);
  if dv = 0 then Percent := 0 else Percent := 1 - (Time - FrameTime) / dv;
  if Percent < 0 then Percent := 0 else if Percent > 1 then Percent := 1;
  Percent := GetCurvePercent((FrameIndex shr 1) - 1, Percent);
  Amount := _Frames[FrameIndex + FRAME_VALUE] - PrevFrameValue;
  while Amount > 180 do Amount := Amount - 360;
  while Amount < -180 do Amount := Amount + 360;
  Amount := Bone.Data.Rotation + (PrevFrameValue + Amount * Percent) - Bone.Rotation;
  while Amount > 180 do Amount := Amount - 360;
  while Amount < -180 do Amount := Amount + 360;
  Bone.Rotation := Bone.Rotation + (Amount * Alpha);
end;
{$Hints on}
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

{$Hints off}
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
  dv := _Frames[FrameIndex + PREV_FRAME_TIME] - FrameTime; Assert(dv <> 0);
  if dv = 0 then Percent := 0 else Percent := 1 - (Time - FrameTime) / dv;
  if Percent < 0 then Percent := 0 else if Percent > 1 then Percent := 1;
  Percent := GetCurvePercent(FrameIndex div 3 - 1, Percent);
  Bone.x := Bone.x + ((Bone.Data.x + PrevFrameX + (_Frames[FrameIndex + FRAME_X] - PrevFrameX) * Percent - Bone.x) * Alpha);
  Bone.y := Bone.y + ((Bone.Data.y + PrevFrameY + (_Frames[FrameIndex + FRAME_Y] - PrevFrameY) * Percent - Bone.y) * Alpha);
end;
{$Hints on}
//TSpineAnimationTranslateTimeline END

//TSpineAnimationScaleTimeline BEGIN
constructor TSpineAnimationScaleTimeline.Create(const AFrameCount: Integer);
begin
  inherited Create(AFrameCount);
end;

{$Hints off}
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
  dv := _Frames[FrameIndex + PREV_FRAME_TIME] - FrameTime; Assert(dv <> 0);
  if dv = 0 then Percent := 0 else Percent := 1 - (Time - FrameTime) / dv;
  if Percent < 0 then Percent := 0 else if Percent > 1 then Percent := 1;
  Percent := GetCurvePercent(FrameIndex div 3 - 1, Percent);
  Bone.ScaleX := Bone.ScaleX + ((Bone.Data.ScaleX * (PrevFrameX + (_Frames[FrameIndex + FRAME_X] - PrevFrameX) * Percent) - Bone.ScaleX) * Alpha);
  Bone.ScaleY := Bone.ScaleY + ((Bone.Data.ScaleY * (PrevFrameY + (_Frames[FrameIndex + FRAME_Y] - PrevFrameY) * Percent) - Bone.ScaleY) * Alpha);
end;
{$Hints on}
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

{$Hints off}
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
    dv := _Frames[FrameIndex + PREV_FRAME_TIME] - FrameTime; Assert(dv <> 0);
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
{$Hints on}
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

procedure TSpineAnimationAttachmentTimeline.SetFrame(const FrameIndex: Integer; const Time: Single; const AttachmentName: AnsiString);
begin
  _Frames[FrameIndex] := Time;
  _AttachmentNames[FrameIndex] := AttachmentName;
end;

{$Hints off}
procedure TSpineAnimationAttachmentTimeline.Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single);
  var FrameIndex: Integer;
  var AttachmentName: AnsiString;
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
{$Hints on}
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

destructor TSpineAnimationEventTimeline.Destroy;
  var i: Integer;
begin
  for i := 0 to High(_FrameEvents) do
  if Assigned(_FrameEvents[i]) then _FrameEvents[i].RefDec;
  inherited Destroy;
end;

procedure TSpineAnimationEventTimeline.SetFrame(const FrameIndex: Integer; const Time: Single; const Event: TSpineEvent);
begin
  _Frames[FrameIndex] := Time;
  _FrameEvents[FrameIndex] := Event;
  Event.RefInc;
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

{$Hints off}
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
{$Hints on}
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

{$Hints off}
procedure TSpineAnimationFFDTimeline.Apply(const Skeleton: TSpineSkeleton; const LastTime, Time: Single; const Events: TSpineEventList; const Alpha: Single);
  var Slot: TSpineSlot;
  var i, VertexCount, FrameIndex: Integer;
  var a, FrameTime, Percent, pv, v, dv: Single;
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
  dv := _Frames[FrameIndex - 1] - FrameTime; Assert(dv <> 0);
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
{$Hints on}
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

{$Hints off}
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
  dv := _Frames[FrameIndex + PREV_FRAME_TIME] - FrameTime; Assert(dv <> 0);
  if dv = 0 then Percent := 0 else Percent := 1 - (Time - FrameTime) / dv;
  if Percent < 0 then Percent := 0 else if Percent > 1 then Percent := 1;
  Percent := GetCurvePercent(FrameIndex div 3 - 1, Percent);
  Mix := PrevFrameMix + (_Frames[FrameIndex + FRAME_MIX] - PrevFrameMix) * Percent;
  Constraint.Mix := Constraint.Mix + ((Mix - Constraint.Mix) * Alpha);
  Constraint.BendDirection := PInteger(@_Frames[FrameIndex + PREV_FRAME_BEND_DIRECTION])^;
end;
{$Hints on}
//TSpineAnimationIKConstraintTimeline END

//TSpineAnimationFlipXTimeline BEGIN
function TSpineAnimationFlipXTimeline.GetFrameCount: Integer;
begin
  Result := Length(_Frames) shr 1;
end;

procedure TSpineAnimationFlipXTimeline.SetFlip(const Bone: TSpineBone; const Flip: Boolean);
begin
  //Bone.FlipX := Flip;
end;

constructor TSpineAnimationFlipXTimeline.Create(const AFrameCount: Integer);
begin
  SetLength(_Frames, AFrameCount shl 1);
end;

procedure TSpineAnimationFlipXTimeline.SetFrame(const FrameIndex: Integer; const Time: Single; const Flip: Boolean);
  var i: Integer;
begin
  i := FrameIndex * 2;
  _Frames[i] := Time;
  if Flip then _Frames[i + 1] := 1
  else _Frames[i + 1] := 0;
end;

{$Hints off}
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
{$Hints on}
//TSpineAnimationFlipXTimeline END

//TSpineAnimationFlipYTimeline BEGIN
procedure TSpineAnimationFlipYTimeline.SetFlip(const Bone: TSpineBone; const Flip: Boolean);
begin
  //Bone.FlipY := Flip;
end;
//TSpineAnimationFlipYTimeline END

//TSpineAnimation BEGIN
constructor TSpineAnimation.Create(const AName: AnsiString; const ATimelines: TSpineTimelineList; const ADuration: Single);
begin
  _Name := AName;
  _Timelines := ATimelines;
  _Timelines.RefInc;
  _Duration := ADuration;
end;

destructor TSpineAnimation.Destroy;
begin
  _Timelines.RefDec;
  inherited Destroy;
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
    if Assigned(Prev) then Prev.RefInc;
    if Assigned(Track.Prev) then Track.Prev.RefDec;
    Track.Prev := nil;
    Track.ProcEnd(Self, Index);
    if Assigned(_OnEnd) then _OnEnd(Self, Index);
    Entry.MixDuration := _Data.GetMix(Track.Animation, Entry.Animation);
    if Entry.MixDuration > 0 then
    begin
      Entry.MixTime := 0;
      if Track.MixDuration = 0 then dv := 1 else dv := Track.MixDuration; Assert(dv <> 0);
      if Assigned(Prev) and (Track.MixTime / dv < 0.5) then
      begin
        Entry.Prev := Prev;
        Prev.RefInc;
      end
      else
      begin
        Entry.Prev := Track;
        Track.RefInc;
      end;
    end;
    if Assigned(Prev) then Prev.RefDec;
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
  _TimeScale := 1;
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
      if Track.Next.Time >= 0 then
      begin
        SetCurrent(i, Track.Next);
        Track.Next.RefDec;
      end;
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
      Track.Prev.Animation.Apply(Skeleton, pt, pt, Track.Prev.Loop, nil);
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

function TSpineAnimationState.SetAnimation(const TrackIndex: Integer; const AnimationName: AnsiString; const Loop: Boolean): TSpineAnimationTrackEntry;
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

function TSpineAnimationState.AddAnimation(const TrackIndex: Integer; const AnimationName: AnsiString; const Loop: Boolean; const Delay: Single): TSpineAnimationTrackEntry;
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
    d := d + (Last.EndTime - _Data.GetMix(Last.Animation, Animation))
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

//TSpineAnimationMix0 BEGIN
constructor TSpineAnimationMix0.Create;
begin
  MixEntries := TSpineAnimationMix1List.Create;
end;

destructor TSpineAnimationMix0.Destroy;
begin
  MixEntries.Free;
  inherited Destroy;
end;
//TSpineAnimationMix0 END

//TSpineAnimationStateData BEGIN
constructor TSpineAnimationStateData.Create(const ASkeletonData: TSpineSkeletonData);
begin
  _SkeletonData := ASkeletonData;
  _SkeletonData.RefInc;
  _MixTime := TSpineAnimationMix0List.Create;
end;

destructor TSpineAnimationStateData.Destroy;
begin
  _MixTime.Free;
  _SkeletonData.RefDec;
  inherited Destroy;
end;

procedure TSpineAnimationStateData.SetMix(const FromName, ToName: AnsiString; const Duration: Single);
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
    for j := 0 to _MixTime[i].MixEntries.Count - 1 do
    if _MixTime[i].MixEntries[j].Anim = AnimTo then
    begin
      _MixTime[i].MixEntries[j].Duration := Duration;
      Exit;
    end;
    Mix1 := TSpineAnimationMix1.Create;
    Mix1.Anim := AnimTo;
    Mix1.Duration := Duration;
    _MixTime[i].MixEntries.Add(Mix1);
    Mix1.Free;
  end;
  Mix0 := TSpineAnimationMix0.Create;
  Mix0.Anim := AnimFrom;
  Mix1 := TSpineAnimationMix1.Create;
  Mix1.Anim := AnimTo;
  Mix1.Duration := Duration;
  Mix0.MixEntries.Add(Mix1);
  Mix1.Free;
  _MixTime.Add(Mix0);
  Mix0.Free;
end;

function TSpineAnimationStateData.GetMix(const AnimFrom, AnimTo: TSpineAnimation): Single;
  var i, j: Integer;
begin
  for i := 0 to _MixTime.Count - 1 do
  if _MixTime[i].Anim = AnimFrom then
  begin
    for j := 0 to _MixTime[i].MixEntries.Count - 1 do
    if _MixTime[i].MixEntries[j].Anim = AnimTo then
    Exit(_MixTime[i].MixEntries[j].Duration);
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
function TSpineEvent.GetName: AnsiString;
begin
  Result := _Data.Name;
end;

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
  //if (Bone.WorldFlipX <> (Bone.WorldFlipY <> TSpineBone.YDown)) then RotationIK := -RotationIK;
  //if Bone.Data.InheritRotation and Assigned(Bone.Parent) then RotationIK := RotationIK - Bone.Parent.WorldRotation;
  //Bone.RotationIK := Rotation + (RotationIK - Rotation) * Alpha;
end;

class procedure TSpineIKConstraint.Apply(var Parent, Child: TSpineBone; const TargetX, TargetY, Alpha: Single; const ABendDirection: Integer);
  var PositionX, PositionY, NewTargetX, NewTargetY: Single;
  var ChildX, ChildY, Offset, Len1, Len2, CosDenom, c: Single;
  var ChildAngle, ParentAngle, Adjacent, Opposite: Single;
  var Rotation: Single;
begin
  {
  if Alpha = 0 then
  begin
    //Child.RotationIK := Child.Rotation;
    //Parent.RotationIK := Parent.Rotation;
    Exit;
  end;
  if Assigned(Parent.Parent) then
  begin
    {$Hints off}
    Parent.Parent.WorldToLocal(TargetX, TargetY, PositionX, PositionY);
    {$Hints on}
    NewTargetX := (PositionX - Parent.x) * Parent.Parent.WorldScaleX;
    NewTargetY := (PositionY - Parent.y) * Parent.Parent.WorldScaleY;
  end
  else
  begin
    NewTargetX := TargetX - Parent.x;
    NewTargetY := TargetY - Parent.y;
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
  if Rotation > 180 then Rotation := Rotation - 360
  else if Rotation < -180 then Rotation := Rotation + 360;
  Parent.RotationIK := Parent.Rotation + Rotation * Alpha;
  Rotation := (ChildAngle + Offset) * SP_RAD_TO_DEG - Child.Rotation;
  if Rotation > 180 then Rotation := Rotation - 360
  else if Rotation < -180 then Rotation := Rotation + 360;
  Child.RotationIK := Child.Rotation + (Rotation + Parent.WorldRotation - Child.Parent.WorldRotation) * Alpha;
  }
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

//TSpineSkinKey BEGIN
procedure TSpineSkinKey.SetAttachment(const Value: TSpineAttachment);
begin
  if _Attachment = Value then Exit;
  if Assigned(_Attachment) then _Attachment.RefDec;
  _Attachment := Value;
  if Assigned(_Attachment) then _Attachment.RefInc;
end;

constructor TSpineSkinKey.Create;
begin
  _Attachment := nil;
end;

destructor TSpineSkinKey.Destroy;
begin
  Attachment := nil;
  inherited Destroy;
end;
//TSpineSkinKey END

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

constructor TSpineSkin.Create(const AName: AnsiString);
begin
  _Name := AName;
  _Attachments := TSpineSkinKeyList.Create;
end;

destructor TSpineSkin.Destroy;
begin
  _Attachments.Free;
  inherited Destroy;
end;

procedure TSpineSkin.AddAttachment(const SlotIndex: Integer; const KeyName: AnsiString; const Attachment: TSpineAttachment);
  var Key: TSpineSkinKey;
begin
  Key := TSpineSkinKey.Create;
  Key.SlotIndex := SlotIndex;
  Key.Name := KeyName;
  Key.Attachment := Attachment;
  _Attachments.Add(Key);
  Key.Free;
end;

function TSpineSkin.GetAttachment(const SlotIndex: Integer; const KeyName: AnsiString): TSpineAttachment;
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

//TSpineAtlasPage BEGIN
procedure TSpineAtlasPage.SetTexture(const Value: TSpineTexture);
begin
  if _Texture = Value then Exit;
  if Assigned(_Texture) then _Texture.RefDec;
  _Texture := Value;
  if Assigned(_Texture) then _Texture.RefInc;
end;

constructor TSpineAtlasPage.Create;
begin
  _Texture := nil;
end;

destructor TSpineAtlasPage.Destroy;
begin
  Texture := nil;
  inherited Destroy;
end;
//TSpineAtlasPage END

//TSpineAtlas BEGIN
constructor TSpineAtlas.Create(const Path: AnsiString);
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

procedure TSpineAtlas.Load(const Path: AnsiString);
  function Trim(const Str: AnsiString): AnsiString;
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
  var Dir: AnsiString;
  var Provider: TSpineDataProvider;
  var Param: AnsiString;
  var Value: array[0..3] of AnsiString;
  var vn: Integer;
  function IsEOF: Boolean;
  begin
    Result := Provider.Pos >= Provider.Size;
  end;
  function ReadLine: AnsiString;
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
    var Line: AnsiString;
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
        Page.Texture.RefDec;
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

function TSpineAtlas.FindRegion(const Name: AnsiString): TSpineAtlasRegion;
  var i: Integer;
begin
  for i := 0 to _Regions.Count - 1 do
  if _Regions[i].Name = Name then Exit(_Regions[i]);
  Result := nil;
end;
//TSpineAtlas END

//TSpineAttachment BEGIN
constructor TSpineAttachment.Create(const AName: AnsiString);
begin
  inherited Create;
  _Name := AName;
end;

{$Hints off}
procedure TSpineAttachment.Draw(const Render: TSpineRender; const Slot: TSpineSlot);
begin
end;
{$Hints on}
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

constructor TSpineRegionAttachment.Create(const AName: AnsiString);
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
  var tx, ty, sx, sy, rx0, ry0, rx1, ry1: Single;
  var m00, m01, m10, m11: Single;
  var v: TSpineRegionVertices;
begin
  {
  tx := Bone.Skeleton.x; ty := Bone.Skeleton.y;
  sx := Bone.Skeleton.ScaleX; sy := Bone.Skeleton.ScaleY;
  rx0 := Bone.Skeleton._RotX; ry0 := Bone.Skeleton._RotY;
  rx1 := -Bone.Skeleton._RotY; ry1 := Bone.Skeleton._RotX;
  m00 := Bone.m00;
  m01 := Bone.m01;
  m10 := Bone.m10;
  m11 := Bone.m11;
  v[SP_VERTEX_X1] := (_Offset[SP_VERTEX_X1] * m00 + _Offset[SP_VERTEX_Y1] * m01 + Bone.WorldX) * sx;
  v[SP_VERTEX_Y1] := (_Offset[SP_VERTEX_X1] * m10 + _Offset[SP_VERTEX_Y1] * m11 + Bone.WorldY) * sy;
  v[SP_VERTEX_X2] := (_Offset[SP_VERTEX_X2] * m00 + _Offset[SP_VERTEX_Y2] * m01 + Bone.WorldX) * sx;
  v[SP_VERTEX_Y2] := (_Offset[SP_VERTEX_X2] * m10 + _Offset[SP_VERTEX_Y2] * m11 + Bone.WorldY) * sy;
  v[SP_VERTEX_X3] := (_Offset[SP_VERTEX_X3] * m00 + _Offset[SP_VERTEX_Y3] * m01 + Bone.WorldX) * sx;
  v[SP_VERTEX_Y3] := (_Offset[SP_VERTEX_X3] * m10 + _Offset[SP_VERTEX_Y3] * m11 + Bone.WorldY) * sy;
  v[SP_VERTEX_X4] := (_Offset[SP_VERTEX_X4] * m00 + _Offset[SP_VERTEX_Y4] * m01 + Bone.WorldX) * sx;
  v[SP_VERTEX_Y4] := (_Offset[SP_VERTEX_X4] * m10 + _Offset[SP_VERTEX_Y4] * m11 + Bone.WorldY) * sy;
  OutWorldVertices[SP_VERTEX_X1] := v[SP_VERTEX_X1] * rx0 + v[SP_VERTEX_Y1] * ry0 + tx;
  OutWorldVertices[SP_VERTEX_Y1] := v[SP_VERTEX_X1] * rx1 + v[SP_VERTEX_Y1] * ry1 + ty;
  OutWorldVertices[SP_VERTEX_X2] := v[SP_VERTEX_X2] * rx0 + v[SP_VERTEX_Y2] * ry0 + tx;
  OutWorldVertices[SP_VERTEX_Y2] := v[SP_VERTEX_X2] * rx1 + v[SP_VERTEX_Y2] * ry1 + ty;
  OutWorldVertices[SP_VERTEX_X3] := v[SP_VERTEX_X3] * rx0 + v[SP_VERTEX_Y3] * ry0 + tx;
  OutWorldVertices[SP_VERTEX_Y3] := v[SP_VERTEX_X3] * rx1 + v[SP_VERTEX_Y3] * ry1 + ty;
  OutWorldVertices[SP_VERTEX_X4] := v[SP_VERTEX_X4] * rx0 + v[SP_VERTEX_Y4] * ry0 + tx;
  OutWorldVertices[SP_VERTEX_Y4] := v[SP_VERTEX_X4] * rx1 + v[SP_VERTEX_Y4] * ry1 + ty;
  }
end;

procedure TSpineRegionAttachment.Draw(const Render: TSpineRender; const Slot: TSpineSlot);
  var v: TSpineRegionVertices;
  var rv: array[0..3] of TSpineVertexData;
  var i: Integer;
begin
  {$Hints off}
  ComputeWorldVertices(Slot.Bone, v);
  {$Hints on}
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
constructor TSpineBoundingBoxAttachment.Create(const AName: AnsiString);
begin
  inherited Create(AName);
end;

procedure TSpineBoundingBoxAttachment.ComputeWorldVertices(const Bone: TSpineBone; var WorldVertices: TSpineFloatArray);
  var x, y, m00, m01, m10, m11, px, py, sx, sy, rx0, ry0, rx1, ry1, wx, wy: Single;
  var i: Integer;
begin
  {
  if Length(WorldVertices) <> Length(_Vertices) then
  SetLength(WorldVertices, Length(_Vertices));
  x := Bone.Skeleton.x;
  y := Bone.Skeleton.y;
  sx := Bone.Skeleton.ScaleX;
  sy := Bone.Skeleton.ScaleY;
  rx0 := Bone.Skeleton._RotX; ry0 := Bone.Skeleton._RotY;
  rx1 := -Bone.Skeleton._RotY; ry1 := Bone.Skeleton._RotX;
  m00 := Bone.m00;
  m01 := Bone.m01;
  m10 := Bone.m10;
  m11 := Bone.m11;
  i := 0;
  while i < Length(_Vertices) do
  begin
    px := _Vertices[i];
    py := _Vertices[i + 1];
    wx := (px * m00 + py * m01 + Bone.WorldX) * sx;
    wy := (px * m10 + py * m11 + Bone.WorldY) * sy;
    WorldVertices[i] := wx * rx0 + wy * ry0 + x;
    WorldVertices[i + 1] := wx * rx1 + wy * ry1 + y;
    Inc(i, 2);
  end;
  }
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

constructor TSpineMeshAttachment.Create(const AName: AnsiString);
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
  var x, y, m00, m01, m10, m11, vx, vy, wx, wy, sx, sy, rx0, ry0, rx1, ry1: Single;
  var v: PSpineFloatArray;
  var i: Integer;
begin
  {
  Bone := Slot.Bone;
  x := Bone.Skeleton.x;
  y := Bone.Skeleton.y;
  sx := Bone.Skeleton.ScaleX;
  sy := Bone.Skeleton.ScaleY;
  rx0 := Bone.Skeleton._RotX; ry0 := Bone.Skeleton._RotY;
  rx1 := -Bone.Skeleton._RotY; ry1 := Bone.Skeleton._RotX;
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
    wx := (vx * m00 + vy * m01 + Bone.WorldX) * sx;
    wy := (vx * m10 + vy * m11 + Bone.WorldY) * sy;
    WorldVertices[i] := wx * rx0 + wy * ry0 + x;
    WorldVertices[i + 1] := wx * rx1 + wy * ry1 + y;
    Inc(i, 2);
  end;
  }
end;

procedure TSpineMeshAttachment.Draw(const Render: TSpineRender; const Slot: TSpineSlot);
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

constructor TSpineSkinnedMeshAttachment.Create(const AName: AnsiString);
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
  var x, y, wx, wy, vx, vy, wt, sx, sy, rx0, ry0, rx1, ry1: Single;
  var wi, vi, bi, fi, n, nn: Integer;
  var Bone: TSpineBone;
begin
  {
  Skeleton := Slot.Skeleton;
  x := Skeleton.x;
  y := Skeleton.y;
  sx := Skeleton.ScaleX;
  sy := Skeleton.ScaleY;
  rx0 := Skeleton._RotX; ry0 := Skeleton._RotY;
  rx1 := -Skeleton._RotY; ry1 := Skeleton._RotX;
  if Slot.AttachmentVertexCount = 0 then
  begin
    wi := 0; vi := 0; bi := 0; n := Length(_Bones);
    while vi < n do
    begin
      wx := 0;
      wy := 0;
      nn := _Bones[vi]; Inc(vi); nn := nn + vi;
      while vi < nn do
      begin
	      Bone := Skeleton.Bones[_Bones[vi]];
	      vx := _Weights[bi];
        vy := _Weights[bi + 1];
        wt := _Weights[bi + 2];
	      wx := wx + (vx * Bone.m00 + vy * Bone.m01 + Bone.WorldX) * wt;
	      wy := wy + (vx * Bone.m10 + vy * Bone.m11 + Bone.WorldY) * wt;
        Inc(vi);
        Inc(bi, 3);
      end;
      wx := wx * sx; wy := wy * sy;
      WorldVertices[wi] := wx * rx0 + wy * ry0 + x;
      WorldVertices[wi + 1] := wx * rx1 + wy * ry1 + y;
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
      nn := _Bones[vi]; Inc(vi); nn := nn + vi;
      while vi < nn do
      begin
	      Bone := Skeleton.Bones[_Bones[vi]];
	      vx := _Weights[bi] + Slot.AttachmentVertices[fi];
        vy := _Weights[bi + 1] + Slot.AttachmentVertices[fi + 1];
        wt := _Weights[bi + 2];
	      wx := wx + (vx * Bone.m00 + vy * Bone.m01 + Bone.WorldX) * wt;
        wy := wy + (vx * Bone.m10 + vy * Bone.m11 + Bone.WorldY) * wt;
        Inc(vi);
        Inc(bi, 3);
        Inc(fi, 2);
      end;
      wx := wx * sx; wy := wy * sy;
      WorldVertices[wi] := wx * rx0 + wy * ry0 + x;
      WorldVertices[wi + 1] := wx * rx1 + wy * ry1 + y;
      Inc(wi, 2);
    end;
  end;
  }
end;

procedure TSpineSkinnedMeshAttachment.Draw(const Render: TSpineRender; const Slot: TSpineSlot);
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

//TSpineVertexAttachment BEGIN
class function TSpineVertexAttachment.GetNextID: Integer;
begin
  Result := InterLockedIncrement(_NextID);
end;

class constructor TSpineVertexAttachment.CreateClass;
begin
  _NextID := 0;
end;

constructor TSpineVertexAttachment.Create(const AName: AnsiString);
begin
  inherited Create(AName);
  _ID := (GetNextID and 65535) shl 11;
end;

procedure TSpineVertexAttachment.ComputeWorldVertices(
  const Slot: TSpineSlot;
  const Start, Count: Integer;
  var WorldVertices: TSpineFloatArray;
  const Offset, Stride: Integer
);
  var Skeleton: TSpineSkeleton;
  var DeformArray: TSpineFloatArray;
  var Bone: TSpineBone;
  var x, y, a, b, c, d, vx, vy, wx, wy, weight: Single;
  var i, cnt, v, w, skip, bi, n, f: Integer;
begin
  cnt := Offset + (Count shr 1) * Stride;
  Skeleton := Slot.GetSkeleton;
  DeformArray := Slot.GetAttachmentVerticesPtr^;
  if (Length(_Bones) = 0) then
  begin
    if Length(DeformArray) > 0 then _Vertices := DeformArray;
    Bone := Slot.Bone;
    x := Bone.WorldX;
    y := Bone.WorldY;
    a := Bone.a;
    b := Bone.b;
    c := Bone.c;
    d := Bone.d;
    v := Start;
    w := Offset;
    while w < cnt do
    begin
      vx := _Vertices[v];
      vy := _Vertices[v + 1];
      WorldVertices[w] := vx * a + vy * b + x;
      WorldVertices[w + 1] := vx * c + vy * d + y;
      v += 2;
      w += Stride;
    end;
    Exit;
  end;
  v := 0;
  skip := 0;
  i := 0;
  while i < start do
  begin
    n := _Bones[v];
    v += n + 1;
    skip += n;
    i += 2;
  end;
  if Length(DeformArray) = 0 then
  begin
    w := Offset;
    bi := skip * 3;
    while w < cnt do
    begin
      wx := 0;
      wy := 0;
      n := _Bones[v];
      Inc(v);
      n += v;
      while v < n do
      begin
        Bone := Skeleton.Bones[_Bones[v]];
	vx := _Vertices[bi];
        vy := _Vertices[bi + 1];
        weight := _Vertices[bi + 2];
	wx += (vx * Bone.A + vy * Bone.B + Bone.WorldX) * weight;
	wy += (vx * Bone.C + vy * Bone.D + Bone.WorldY) * weight;
        Inc(v);
        bi += 3;
      end;
      WorldVertices[w] := wx;
      WorldVertices[w + 1] := wy;
      w += Stride;
    end;
  end
  else
  begin
    w := Offset;
    bi := skip * 3;
    f := skip shl 1;
    while w < cnt do
    begin
      wx := 0;
      wy := 0;
      n := _Bones[v];
      Inc(v);
      n += v;
      while v < n do
      begin
	Bone := Skeleton.Bones[_Bones[v]];
	vx := _Vertices[bi] + DeformArray[f];
        vy := _Vertices[bi + 1] + DeformArray[f + 1];
        weight := _Vertices[bi + 2];
	wx += (vx * Bone.A + vy * Bone.B + Bone.WorldX) * weight;
	wy += (vx * Bone.C + vy * Bone.D + Bone.WorldY) * weight;
        Inc(v);
        bi += 3;
        f += 2;
      end;
      WorldVertices[w] := wx;
      WorldVertices[w + 1] := wy;
      w += Stride;
    end;
  end;
end;

function TSpineVertexAttachment.ApplyDeform(
  const SourceAttachment: TSpineVertexAttachment
): Boolean;
begin
  Result := Self = SourceAttachment;
end;

procedure TSpineVertexAttachment.SetBones(const NewBones: array of Integer);
begin
  SetLength(_Bones, Length(NewBones));
  Move(NewBones[0], _Bones[0], Length(_Bones) * SizeOf(Integer));
end;

procedure TSpineVertexAttachment.SetVertices(const NewVertices: array of Single);
begin
  SetLength(_Vertices, Length(NewVertices));
  Move(NewVertices[0], _Vertices[0], Length(_Vertices) * SizeOf(Single));
end;
//TSpineVertexAttachment END

//TSpinePathAttachment BEGIN
constructor TSpinePathAttachment.Create(const AName: AnsiString);
begin
  inherited Create(AName);
  _Color := SpineColor(1, 0.5, 0, 1);
end;
//TSpinePathAttachment END

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

{$Hints off}
function TSpineAtlasAttachmentLoader.NewRegionAttachment(const Skin: TSpineSkin; const Name, Path: AnsiString): TSpineRegionAttachment;
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
{$Hints on}

{$Hints off}
function TSpineAtlasAttachmentLoader.NewMeshAttachment(const Skin: TSpineSkin; const Name, Path: AnsiString): TSpineMeshAttachment;
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
{$Hints on}

{$Hints off}
function TSpineAtlasAttachmentLoader.NewSkinnedMeshAttachment(const Skin: TSpineSkin; const Name, Path: AnsiString): TSpineSkinnedMeshAttachment;
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
{$Hints on}

{$Hints off}
function TSpineAtlasAttachmentLoader.NewBoundingBoxAttachment(const Skin: TSpineSkin; const Name, Path: AnsiString): TSpineBoundingBoxAttachment;
begin
  Result := TSpineBoundingBoxAttachment.Create(Name);
end;
{$Hints on}

function TSpineAtlasAttachmentLoader.FindRegion(const Name: AnsiString): TSpineAtlasRegion;
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

function TSpineSkeletonBinary.ReadString(const Provider: TSpineDataProvider): AnsiString;
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
  var bi: LongWord;
begin
  while True do
  begin
    case (b shr 4) of
      0, 1, 2, 3, 4, 5, 6, 7: _Chars[CharIndex] := AnsiChar(b);
      12, 13: _Chars[CharIndex] := AnsiChar(((b and $1F) shl 6) or (Provider.ReadByte and $3F));
      14:
      begin
        bi := ((LongWord(b) and $0F) shl 12) or ((LongWord(Provider.ReadByte) and $3F) shl 6) or (LongWord(Provider.ReadByte) and $3F);
        _Chars[CharIndex] := AnsiChar(bi);
      end;
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

function TSpineSkeletonBinary.ReadSkin(const Provider: TSpineDataProvider; const SkinName: AnsiString; const NonEssential: Boolean): TSpineSkin;
  var i, j, n, SlotIndex, SlotCount: Integer;
  var Name: AnsiString;
  var Attachment: TSpineAttachment;
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
      Attachment := ReadAttachment(Provider, Result, Name, NonEssential);
      Result.AddAttachment(SlotIndex, Name, Attachment);
      Attachment.Free;
    end;
  end;
end;

function TSpineSkeletonBinary.ReadAttachment(const Provider: TSpineDataProvider; const Skin: TSpineSkin; const AttachmentName: AnsiString; const NonEssential: Boolean): TSpineAttachment;
  var Name, Path: AnsiString;
  var at: TSpineAttachmentType;
  var Region: TSpineRegionAttachment absolute Result;
  var Box: TSpineBoundingBoxAttachment absolute Result;
  var Mesh: TSpineMeshAttachment absolute Result;
  var Skinned: TSpineSkinnedMeshAttachment absolute Result;
  var Color, VertexCount, BoneCount, bi, wi, i, j: Integer;
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

procedure TSpineSkeletonBinary.ReadAnimation(const Provider: TSpineDataProvider; const Name: AnsiString; const SkeletonData: TSpineSkeletonData);
  var Animation: TSpineAnimation;
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
  var TmpName: AnsiString;
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
          ColorTimeline.Free;
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
          AttachmentTimeline.Free;
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
          RotateTimeline.Free;
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
          TranslateTimeline.Free;
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
          FlipXTimeline.Free;
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
    IkConstraintTimeline.Free;
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
            Count := Count + Start;
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
              Vertices^[v] := Vertices^[v] + TSpineMeshAttachment(Attachment).Vertices[v];
            end;
          end;
          FFDTimeline.SetFrame(FrameIndex, Time, Vertices^);
          if FrameIndex < FrameCount - 1 then ReadCurve(Provider, FrameIndex, FFDTimeline);
        end;
        Timelines.Add(FFDTimeline);
        FFDTimeline.Free;
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
    DrawOrderTimeline.Free;
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
      Event.Free;
    end;
    Timelines.Add(EventTimeline);
    EventTimeline.Free;
    Duration := SpineMax(Duration, EventTimeline.Frames[EventCount - 1]);
  end;
  Animation := TSpineAnimation.Create(Name, Timelines, Duration);
  Timelines.Free;
  SkeletonData.Animations.Add(Animation);
  Animation.Free;
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

function TSpineSkeletonBinary.ReadSkeletonData(const Path: AnsiString): TSpineSkeletonData;
  var Provider: TSpineDataProvider;
begin
  Provider := SpineDataProvider.FetchData(Path);
  if Provider = nil then Exit(nil);
  try
    Result := ReadSkeletonData(Provider);
  finally
    Provider.Free;
  end;
end;

function TSpineSkeletonBinary.ReadSkeletonData(const Provider: TSpineDataProvider): TSpineSkeletonData;
  var NonEssential: Boolean;
  var i, j, n, t, ParentIndex: Integer;
  var Name: AnsiString;
  var BoneData, Parent: TSpineBoneData;
  var ConstraintData: TSpineIKConstraintData;
  var TransformConstraintData: TSpineTransformConstraintData;
  var PathConstraintData: TSpinePathConstraintData;
  var SlotData: TSpineSlotData;
  var EventData: TSpineEventData;
  var DefaultSkin, Skin: TSpineSkin;
  var Color: Integer;
begin
  Result := TSpineSkeletonData.Create;
  Result.Name := Provider.Name;
  Result.Hash := ReadString(Provider);
  Result.Version := ReadString(Provider);
  Result.Width := ReadFloat(Provider);
  Result.Height := ReadFloat(Provider);
  NonEssential := ReadBool(Provider);
  if NonEssential then
  begin
    Result.FPS := ReadFloat(Provider);
    Result.ImagePath := ReadString(Provider);
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    Name := ReadString(Provider);
    Parent := nil;
    if i > 0 then
    begin
      ParentIndex := ReadInt(Provider, True) - 1;
      if ParentIndex > -1 then Parent := Result.Bones[ParentIndex];
    end;
    BoneData := TSpineBoneData.Create(i, Name, Parent);
    BoneData.Rotation := ReadFloat(Provider);
    BoneData.x := ReadFloat(Provider) * _Scale;
    BoneData.y := ReadFloat(Provider) * _Scale;
    BoneData.ScaleX := ReadFloat(Provider);
    BoneData.ScaleY := ReadFloat(Provider);
    BoneData.ShearX := ReadFloat(Provider);
    BoneData.ShearY := ReadFloat(Provider);
    BoneData.BoneLength := ReadFloat(Provider) * _Scale;
    BoneData.TransformMode := TSpineBoneData.TTransformMode(ReadInt(Provider, True));
    if NonEssential then ReadInt(Provider);
    Result.Bones.Add(BoneData);
    BoneData.Free;
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    Name := ReadString(Provider);
    BoneData := Result.Bones[ReadInt(Provider, True)];
    SlotData := TSpineSlotData.Create(i, Name, BoneData);
    Color := ReadInt(Provider);
    SlotData.r := ((Color and $ff000000) shr 24) * SP_RCP_255;
    SlotData.g := ((Color and $00ff0000) shr 16) * SP_RCP_255;
    SlotData.b := ((Color and $0000ff00) shr 8) * SP_RCP_255;
    SlotData.a := ((Color and $000000ff)) * SP_RCP_255;
    SlotData.AttachmentName := ReadString(Provider);
    SlotData.BlendMode := TSpineBlendMode(ReadInt(Provider, True));
    Result.Slots.Add(SlotData);
    SlotData.Free;
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    ConstraintData := TSpineIKConstraintData.Create(ReadString(Provider));
    ConstraintData.Order := ReadInt(Provider, True);
    t := ReadInt(Provider, True);
    for j := 0 to t - 1 do
    begin
      ConstraintData.Bones.Add(Result.Bones[ReadInt(Provider, True)]);
    end;
    ConstraintData.Target := Result.Bones[ReadInt(Provider, True)];
    ConstraintData.Mix := ReadFloat(Provider);
    ConstraintData.BendDirection := ReadSByte(Provider);
    Result.IKConstraints.Add(ConstraintData);
    ConstraintData.Free;
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    TransformConstraintData := TSpineTransformConstraintData.Create(ReadString(Provider));
    TransformConstraintData.Order := ReadInt(Provider, True);
    t := ReadInt(Provider, True);
    for j := 0 to t - 1 do
    begin
      TransformConstraintData.Bones.Add(Result.Bones[ReadInt(Provider, True)]);
    end;
    TransformConstraintData.Target := Result.Bones[ReadInt(Provider, True)];
    TransformConstraintData.OffsetRotation := ReadFloat(Provider);
    TransformConstraintData.OffsetX := ReadFloat(Provider) * _Scale;
    TransformConstraintData.OffsetY := ReadFloat(Provider) * _Scale;
    TransformConstraintData.OffsetScaleX := ReadFloat(Provider);
    TransformConstraintData.OffsetScaleY := ReadFloat(Provider);
    TransformConstraintData.OffsetShearY := ReadFloat(Provider);
    TransformConstraintData.RotateMix := ReadFloat(Provider);
    TransformConstraintData.TranslateMix := ReadFloat(Provider);
    TransformConstraintData.ScaleMix := ReadFloat(Provider);
    TransformConstraintData.ShearMix := ReadFloat(Provider);
    Result.TransformConstraints.Add(TransformConstraintData);
    TransformConstraintData.Free;
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    PathConstraintData := TSpinePathConstraintData.Create(ReadString(Provider));
    PathConstraintData.Order := ReadInt(Provider, True);
    t := ReadInt(Provider, True);
    for j := 0 to t - 1 do
    begin
      PathConstraintData.Bones.Add(Result.Bones[ReadInt(Provider, True)]);
    end;
    PathConstraintData.Target := Result.Slots[ReadInt(Provider, True)];
    PathConstraintData.PositionMode := TSpinePathConstraintData.TPositionMode(ReadInt(Provider, True));
    PathConstraintData.SpacingMode := TSpinePathConstraintData.TSpacingMode(ReadInt(Provider, True));
    PathConstraintData.RotateMode := TSpinePathConstraintData.TRotateMode(ReadInt(Provider, True));
    PathConstraintData.OffsetRotation := ReadFloat(Provider);
    PathConstraintData.Position := ReadFloat(Provider);
    if PathConstraintData.PositionMode = pm_fixed then
    begin
      PathConstraintData.Position := PathConstraintData.Position * _Scale;
    end;
    PathConstraintData.Spacing := ReadFloat(Provider);
    if (PathConstraintData.SpacingMode = sm_length)
    or (PathConstraintData.SpacingMode = sm_fixed) then
    begin
      PathConstraintData.Spacing := PathConstraintData.Spacing * _Scale;
    end;
    PathConstraintData.RotateMix := ReadFloat(Provider);
    PathConstraintData.TranslateMix := ReadFloat(Provider);
    Result.PathConstraints.Add(PathConstraintData);
    PathConstraintData.Free;
  end;
  DefaultSkin := ReadSkin(Provider, 'default', NonEssential);
  if Assigned(DefaultSkin) then
  begin
    Result.DefaultSkin := DefaultSkin;
    Result.Skins.Add(DefaultSkin);
    DefaultSkin.Free;
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    Name := ReadString(Provider);
    Skin := ReadSkin(Provider, Name, NonEssential);
    Result.Skins.Add(Skin);
    Skin.Free;
  end;
  n := ReadInt(Provider, True);
  for i := 0 to n - 1 do
  begin
    EventData := TSpineEventData.Create(ReadString(Provider));
    EventData.IntValue := ReadInt(Provider, False);
    EventData.FloatValue := ReadFloat(Provider);
    EventData.StringValue := ReadString(Provider);
    Result.Events.Add(EventData);
    EventData.Free;
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

class procedure TSpineClass.Report(const FileName: AnsiString);
  var f: TextFile;
  var s: AnsiString;
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
  if n = 0 then WriteLn(f, 'No objects allocated');
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
  Assert(_Ref > 0);
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
procedure TSpineList{$ifndef fpc}<T>{$endif}.SetItem(const Index: Integer; const Value: T);
begin
  if _Items[Index] = Value then Exit;
  if _Items[Index] <> nil then {$ifdef fpc}_Items[Index].RefDec{$else}TSpineClass(_Items[Index]).RefDec{$endif};
  _Items[Index] := Value;
  if _Items[Index] <> nil then {$ifdef fpc}_Items[Index].RefInc{$else}TSpineClass(_Items[Index]).RefInc{$endif};
end;

function TSpineList{$ifndef fpc}<T>{$endif}.GetItem(const Index: Integer): T;
begin
  Result := _Items[Index];
end;

procedure TSpineList{$ifndef fpc}<T>{$endif}.SetCapacity(const Value: Integer);
begin
  SetLength(_Items, Value);
end;

function TSpineList{$ifndef fpc}<T>{$endif}.GetCapacity: Integer;
begin
  Result := Length(_Items);
end;

function TSpineList{$ifndef fpc}<T>{$endif}.GetFirst: T;
begin
  if _ItemCount > 0 then Result := _Items[0];
end;

function TSpineList{$ifndef fpc}<T>{$endif}.GetLast: T;
begin
  Result := _Items[_ItemCount - 1];
end;

function TSpineList{$ifndef fpc}<T>{$endif}.GetData: TItemPtr;
begin
  if _ItemCount > 0 then
  Result := @_Items[0]
  else
  Result := nil;
end;

function TSpineList{$ifndef fpc}<T>{$endif}.GetItemPtr(const Index: Integer): TItemPtr;
begin
  Result := @_Items[Index];
end;

constructor TSpineList{$ifndef fpc}<T>{$endif}.Create;
begin
  inherited Create;
  _ItemCount := 0;
end;

destructor TSpineList{$ifndef fpc}<T>{$endif}.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TSpineList{$ifndef fpc}<T>{$endif}.Find(const Item: T): Integer;
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

function TSpineList{$ifndef fpc}<T>{$endif}.Add(const Item: T): Integer;
begin
  if Length(_Items) <= _ItemCount then
  SetLength(_Items, Length(_Items) + 256);
  _Items[_ItemCount] := Item;
  Result := _ItemCount;
  if Item <> nil then {$ifdef fpc}Item.RefInc{$else}TSpineClass(Item).RefInc{$endif};
  Inc(_ItemCount);
end;

function TSpineList{$ifndef fpc}<T>{$endif}.Insert(const Index: Integer; const Item: T): Integer;
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
  if Item <> nil then {$ifdef fpc}Item.RefInc{$else}TSpineClass(Item).RefInc{$endif};
  Inc(_ItemCount);
end;

procedure TSpineList{$ifndef fpc}<T>{$endif}.Delete(const Index: Integer; const ItemCount: Integer);
  var i: Integer;
begin
  for i := Index to Index + ItemCount - 1 do
  if _Items[i] <> nil then {$ifdef fpc}_Items[i].RefDec{$else}TSpineClass(_Items[i]).RefDec{$endif};
  for i := Index to _ItemCount - (1 + ItemCount) do
  _Items[i] := _Items[i + ItemCount];
  Dec(_ItemCount, ItemCount);
end;

procedure TSpineList{$ifndef fpc}<T>{$endif}.Remove(const Item: T);
  var i: Integer;
begin
  i := Find(Item);
  if i > -1 then
  Delete(i);
end;

procedure TSpineList{$ifndef fpc}<T>{$endif}.Clear;
  var i: Integer;
begin
  for i := 0 to _ItemCount - 1 do
  TSpineClass(_Items[i]).Free;
  _ItemCount := 0;
end;
{$Hints on}
//TSpineList END

function SpineColor(const r, g, b, a: Single): TSpineColor;
begin
  Result[0] := r;
  Result[1] := g;
  Result[2] := b;
  Result[3] := a;
end;

function SpineIsNan(const v: Single): Boolean;
begin
  Result := v <> v;
end;

end.
