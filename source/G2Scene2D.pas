unit G2Scene2D;

interface

uses
  Classes,
  SysUtils,
  G2Types,
  G2Utils,
  Gen2MP,
  G2Math,
  G2DataManager,
  G2MeshG2M,
  box2d,
  Spine,
  G2Spine;

type
  TG2Scene2DComponent = class;
  TG2Scene2DEntity = class;
  TG2Scene2DJoint = class;
  TG2Scene2DRenderHook = class;
  TG2Scene2D = class;
  TG2Scene2DComponentRigidBody = class;
  TG2Scene2DComponentCollisionShape = class;
  TG2Scene2DComponentSpineAnimation = class;

  CG2Scene2DComponent = class of TG2Scene2DComponent;

  TG2Scene2DComponentCallbackObj = procedure (const Component: TG2Scene2DComponent) of Object;

  TG2Scene2DEventData = class
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TG2Scene2DEvent = procedure (const EventData: TG2Scene2DEventData) of object;

  TG2Scene2DEventDispatcher = class
  private
    var _Events: specialize TG2QuickListG<TG2Scene2DEvent>;
    var _Name: String;
  public
    property Name: String read _Name write _Name;
    constructor Create(const NewName: String);
    destructor Destroy; override;
    procedure AddEvent(const Event: TG2Scene2DEvent);
    procedure RemoveEvent(const Event: TG2Scene2DEvent);
    procedure DispatchEvent(const EventData: TG2Scene2DEventData);
  end;

  TG2Scene2DComponent = class
  private
    class var ComponentList: array of CG2Scene2DComponent;
    var _Scene: TG2Scene2D;
    var _Owner: TG2Scene2DEntity;
    var _UserData: Pointer;
    var _Tags: TG2QuickListAnsiString;
    var _ProcOnAttach: TG2Scene2DComponentCallbackObj;
    var _ProcOnDetach: TG2Scene2DComponentCallbackObj;
    var _ProcOnFinalize: TG2Scene2DComponentCallbackObj;
    procedure SetOwner(const Value: TG2Scene2DEntity); inline;
    function GetTag(const Index: TG2IntS32): AnsiString; inline;
    function GetTagCount: TG2IntS32; inline;
  protected
    var _EventDispatchers: specialize TG2QuickListG<TG2Scene2DEventDispatcher>;
    function GetCurrentVersion: TG2IntU16; virtual;
    procedure OnInitialize; virtual;
    procedure OnFinalize; virtual;
    procedure OnAttach; virtual;
    procedure OnDetach; virtual;
    procedure SaveClassType(const dm: TG2DataManager);
    procedure SaveTags(const dm: TG2DataManager);
    procedure SaveVersion(const dm: TG2DataManager);
    function LoadVersion(const dm: TG2DataManager): TG2IntU16;
    procedure LoadTags(const dm: TG2DataManager);
  public
    class constructor CreateClass;
    class function GetName: String; virtual;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; virtual;
    property UserData: Pointer read _UserData write _UserData;
    property Scene: TG2Scene2D read _Scene;
    property Owner: TG2Scene2DEntity read _Owner write SetOwner;
    property Tags[const Index: TG2IntS32]: AnsiString read GetTag;
    property TagCount: TG2IntS32 read GetTagCount;
    property CallbackOnAttach: TG2Scene2DComponentCallbackObj read _ProcOnAttach write _ProcOnAttach;
    property CallbackOnDetach: TG2Scene2DComponentCallbackObj read _ProcOnDetach write _ProcOnDetach;
    property CallbackOnFinalize: TG2Scene2DComponentCallbackObj read _ProcOnFinalize write _ProcOnFinalize;
    constructor Create(const OwnerScene: TG2Scene2D); virtual;
    destructor Destroy; override;
    function HasTag(const Tag: AnsiString): Boolean;
    procedure AddTag(const Tag: AnsiString);
    procedure RemoveTag(const Tag: AnsiString);
    procedure ParseTags(const TagsString: AnsiString);
    procedure Attach(const Entity: TG2Scene2DEntity);
    procedure Detach;
    procedure AddEvent(const EventName: String; const Event: TG2Scene2DEvent);
    procedure RemoveEvent(const EventName: String; const Event: TG2Scene2DEvent);
    procedure Save(const dm: TG2DataManager); virtual;
    procedure Load(const dm: TG2DataManager); virtual;
  end;

  TG2Scene2DComponentList = specialize TG2QuickListG<TG2Scene2DComponent>;
  TG2Scene2DEntityList = specialize TG2QuickListG<TG2Scene2DEntity>;
  PG2Scene2DEntityList = ^TG2Scene2DEntityList;

  TG2Scene2DEntity = class
  private
    var _UserData: Pointer;
    var _GUID: String;
    var _Tags: TG2QuickListAnsiString;
    var _EventDispatchers: specialize TG2QuickListG<TG2Scene2DEventDispatcher>;
    function GetChild(const Index: TG2IntS32): TG2Scene2DEntity; inline;
    function GetChildCount: TG2IntS32; inline;
    function GetComponent(const Index: TG2IntS32): TG2Scene2DComponent; inline;
    function GetComponentCount: TG2IntS32; inline;
    function GetComponentOfType(const ComponentType: CG2Scene2DComponent): TG2Scene2DComponent; inline;
    procedure SetEnabled(const Value: Boolean); inline;
    procedure SetTransformIsolated(const Value: TG2Transform2); inline;
    procedure SetParent(const Value: TG2Scene2DEntity); inline;
    procedure AddComponent(const Component: TG2Scene2DComponent); inline;
    procedure RemoveComponent(const Component: TG2Scene2DComponent); inline;
    function GetTag(const Index: TG2IntS32): AnsiString; inline;
    function GetTagCount: TG2IntS32; inline;
    function GetPosition: TG2Vec2; inline;
    procedure SetPosition(const Value: TG2Vec2); inline;
    function GetRotation: TG2Rotation2; inline;
    procedure SetRotation(const Value: TG2Rotation2); inline;
  protected
    var _Scene: TG2Scene2D;
    var _Parent: TG2Scene2DEntity;
    var _Children: TG2Scene2DEntityList;
    var _Components: TG2Scene2DComponentList;
    var _Transform: TG2Transform2;
    var _Name: AnsiString;
    var _Enabled: Boolean;
    function GetCurrentVersion: TG2IntU16; virtual;
    procedure SetTransform(const Value: TG2Transform2); virtual;
    procedure AddChild(const Child: TG2Scene2DEntity); virtual;
    procedure RemoveChild(const Child: TG2Scene2DEntity); virtual;
    procedure OnDebugDraw(const Display: TG2Display2D); virtual;
    procedure OnRender(const Display: TG2Display2D); virtual;
    procedure OnEnable; virtual;
    procedure OnDisable; virtual;
  public
    property UserData: Pointer read _UserData write _UserData;
    property GUID: String read _GUID write _GUID;
    property Scene: TG2Scene2D read _Scene;
    property Parent: TG2Scene2DEntity read _Parent write SetParent;
    property Children[const Index: TG2IntS32]: TG2Scene2DEntity read GetChild;
    property ChildCount: TG2IntS32 read GetChildCount;
    property Components[const Index: TG2IntS32]: TG2Scene2DComponent read GetComponent;
    property ComponentCount: TG2IntS32 read GetComponentCount;
    property ComponentOfType[const ComponentType: CG2Scene2DComponent]: TG2Scene2DComponent read GetComponentOfType;
    property Tags[const Index: TG2IntS32]: AnsiString read GetTag;
    property TagCount: TG2IntS32 read GetTagCount;
    property Enabled: Boolean read _Enabled write SetEnabled;
    property Name: AnsiString read _Name write _Name;
    property Transform: TG2Transform2 read _Transform write SetTransform;
    property Position: TG2Vec2 read GetPosition write SetPosition;
    property Rotation: TG2Rotation2 read GetRotation write SetRotation;
    constructor Create(const OwnerScene: TG2Scene2D); virtual;
    destructor Destroy; override;
    procedure NewGUID;
    function FindChildByName(const ChildName: String): TG2Scene2DEntity;
    function HasTag(const Tag: AnsiString): Boolean;
    procedure AddTag(const Tag: AnsiString);
    procedure RemoveTag(const Tag: AnsiString);
    procedure ParseTags(const TagsString: AnsiString);
    procedure DebugDraw(const Display: TG2Display2D);
    procedure Render(const Display: TG2Display2D);
    procedure AddEvent(const EventName: String; const Event: TG2Scene2DEvent);
    procedure RemoveEvent(const EventName: String; const Event: TG2Scene2DEvent);
    procedure StripComponents(const AllowedComponents: array of CG2Scene2DComponent);
    procedure Save(const dm: TG2DataManager); virtual;
    procedure Load(const dm: TG2DataManager); virtual;
  end;
  CG2Scene2DEntity = class of TG2Scene2DEntity;

  TG2Scene2DJointList = specialize TG2QuickListG<TG2Scene2DJoint>;

  CG2Scene2DJoint = class of TG2Scene2DJoint;

  TG2Scene2DJoint = class
  private
    class var JointList: array of CG2Scene2DJoint;
    var _UserData: Pointer;
    var _Scene: TG2Scene2D;
    var _Enabled: Boolean;
  protected
    var _Joint: pb2_joint;
    function GetCurrentVersion: TG2IntU16; virtual;
    procedure SetEnabled(const Value: Boolean); virtual;
    procedure SaveClassType(const dm: TG2DataManager);
    procedure SaveVersion(const dm: TG2DataManager);
    function LoadVersion(const dm: TG2DataManager): TG2IntU16;
  public
    property UserData: Pointer read _UserData write _UserData;
    property Scene: TG2Scene2D read _Scene;
    property Enabled: Boolean read _Enabled write SetEnabled;
    class constructor ClassCreate;
    class function LoadClass(const dm: TG2DataManager; const OwnerScene: TG2Scene2D): TG2Scene2DJoint;
    constructor Create(const OwnerScene: TG2Scene2D); virtual;
    destructor Destroy; override;
    procedure Save(const dm: TG2DataManager); virtual;
    procedure Load(const dm: TG2DataManager); virtual;
  end;

  TG2Scene2DDistanceJoint = class (TG2Scene2DJoint)
  private
    var _RigidBodyA: TG2Scene2DComponentRigidBody;
    var _RigidBodyB: TG2Scene2DComponentRigidBody;
    var _AnchorA: TG2Vec2;
    var _AnchorB: TG2Vec2;
    var _Distance: TG2Float;
    function Valid: Boolean; inline;
  protected
    procedure SetEnabled(const Value: Boolean); override;
  public
    property RigidBodyA: TG2Scene2DComponentRigidBody read _RigidBodyA write _RigidBodyA;
    property RigidBodyB: TG2Scene2DComponentRigidBody read _RigidBodyB write _RigidBodyB;
    property AnchorA: TG2Vec2 read _AnchorA write _AnchorA;
    property AnchorB: TG2Vec2 read _AnchorB write _AnchorB;
    property Distnace: TG2Float read _Distance write _Distance;
    class constructor CreateClass;
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2Scene2DRevoluteJoint = class (TG2Scene2DJoint)
  private
    var _RigidBodyA: TG2Scene2DComponentRigidBody;
    var _RigidBodyB: TG2Scene2DComponentRigidBody;
    var _Anchor: TG2Vec2;
    var _OffsetA: TG2Vec2;
    var _OffsetB: TG2Vec2;
    var _EnableLimits: Boolean;
    var _LimitMin: TG2Float;
    var _LimitMax: TG2Float;
    procedure SetEnableLimits(const Value: Boolean);
    procedure SetLimitMax(const Value: TG2Float);
    procedure SetLimitMin(const Value: TG2Float);
    function Valid: Boolean; inline;
    function GetAnchor: TG2Vec2;
    procedure SetAnchor(const Value: TG2Vec2);
  protected
    function GetCurrentVersion: TG2IntU16; override;
    procedure SetEnabled(const Value: Boolean); override;
  public
    property RigidBodyA: TG2Scene2DComponentRigidBody read _RigidBodyA write _RigidBodyA;
    property RigidBodyB: TG2Scene2DComponentRigidBody read _RigidBodyB write _RigidBodyB;
    property Anchor: TG2Vec2 read GetAnchor write SetAnchor;
    property EnableLimits: Boolean read _EnableLimits write SetEnableLimits;
    property LimitMin: TG2Float read _LimitMin write SetLimitMin;
    property LimitMax: TG2Float read _LimitMax write SetLimitMax;
    class constructor CreateClass;
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2Scene2DPullJoint = class (TG2Scene2DJoint)
  private
    var _RigidBody: TG2Scene2DComponentRigidBody;
    var _Target: TG2Vec2;
    var _MaxForce: TG2Float;
    function Valid: Boolean; inline;
    procedure SetRigidBody(const Value: TG2Scene2DComponentRigidBody);
    procedure SetTarget(const Value: TG2Vec2);
    procedure SetMaxForce(const Value: TG2Float);
    function GetAnchor: TG2Vec2; inline;
  protected
    procedure SetEnabled(const Value: Boolean); override;
  public
    property RigidBody: TG2Scene2DComponentRigidBody read _RigidBody write SetRigidBody;
    property Target: TG2Vec2 read _Target write SetTarget;
    property MaxForce: TG2Float read _MaxForce write SetMaxForce;
    property Anchor: TG2Vec2 read GetAnchor;
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
  end;

  TG2Scene2DRenderHookProc = procedure (const Display: TG2Display2D) of object;

  TG2Scene2DRenderHook = class
  private
    var _Scene: TG2Scene2D;
    var _Layer: TG2IntS32;
    var _Hook: TG2Scene2DRenderHookProc;
    procedure SetLayer(const Value: TG2IntS32); inline;
  public
    property Hook: TG2Scene2DRenderHookProc read _Hook;
    property Layer: TG2IntS32 read _Layer write SetLayer;
    constructor Create(const OwnerScene: TG2Scene2D; const HookProc: TG2Scene2DRenderHookProc; const RenderLayer: TG2IntS32);
    destructor Destroy; override;
  end;

  TG2Scene2D = class
  private
    type TRenderHookList = specialize TG2QuickListG<TG2Scene2DRenderHook>;
    type TPhysDraw = class (tb2_draw)
    public
      var Disp: TG2Display2D;
      procedure draw_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color); override;
      procedure draw_solid_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color); override;
      procedure draw_circle(const center: tb2_vec2; const radius: tb2_float32; const color: tb2_color); override;
      procedure draw_solid_circle(const center: tb2_vec2; const radius: tb2_float32; const axis: tb2_vec2; const color: tb2_color); override;
      procedure draw_segment(const p0, p1: tb2_vec2; const color: tb2_color); override;
      procedure draw_transform(const xf: tb2_transform); override;
    end;
    type TPhysContactListener = class (tb2_contact_listener)
    public
      procedure begin_contact(const contact: pb2_contact); override;
      procedure end_contact(const contact: pb2_contact); override;
      procedure pre_solve(const contact: pb2_contact; const old_manifold: pb2_manifold); override;
      procedure post_solve(const contact: pb2_contact; const impulse: pb2_contact_impulse); override;
    end;
    const CurrentVersion = $0001;
    var _Entities: TG2Scene2DEntityList;
    var _Joints: TG2Scene2DJointList;
    var _RenderHooks: TRenderHookList;
    var _SortRenderHooks: Boolean;
    var _Gravity: TG2Vec2;
    var _PhysWorld: tb2_world;
    var _ContactListener: TPhysContactListener;
    var _PhysDraw: TPhysDraw;
    var _Simulate: Boolean;
    var _GridEnable: Boolean;
    var _GridSizeX: TG2Float;
    var _GridSizeY: TG2Float;
    var _GridSizeXRcp: TG2Float;
    var _GridSizeYRcp: TG2Float;
    var _GridOffsetX: TG2Float;
    var _GridOffsetY: TG2Float;
    var _QueryPoint: tb2_vec2;
    var _QueryTarget: PG2Scene2DEntityList;
    var _FixedBody: pb2_body;
    function ProcessQuery(const fixture: pb2_fixture): Boolean;
    procedure Update;
    function GetEntity(const Index: TG2IntS32): TG2Scene2DEntity; inline;
    function GetEntityCount: TG2IntS32; inline;
    function GetJoint(const Index: TG2IntS32): TG2Scene2DJoint; inline;
    function GetJointCount: TG2IntS32; inline;
    procedure EntityAdd(const Entity: TG2Scene2DEntity); inline;
    procedure EntityRemove(const Entity: TG2Scene2DEntity); inline;
    procedure JointAdd(const Joint: TG2Scene2DJoint); inline;
    procedure JointRemove(const Joint: TG2Scene2DJoint); inline;
    procedure SortRenderHooks; inline;
    function CompRenderHooks(const Item0, Item1: TG2Scene2DRenderHook): TG2IntS32;
    function GetGravity: TG2Vec2; inline;
    procedure SetGravity(const Value: TG2Vec2); inline;
    procedure SetGridSizeX(const Value: TG2Float); inline;
    procedure SetGridSizeY(const Value: TG2Float); inline;
    procedure VerifyEntityName(const Entity: TG2Scene2DEntity);
  protected
    property FixedBody: pb2_body read _FixedBody;
  public
    property Entities[const Index: TG2IntS32]: TG2Scene2DEntity read GetEntity;
    property EntityCount: TG2IntS32 read GetEntityCount;
    property Joints[const Index: TG2IntS32]: TG2Scene2DJoint read GetJoint;
    property JointCount: TG2IntS32 read GetJointCount;
    property Gravity: TG2Vec2 read GetGravity write SetGravity;
    property Simulate: Boolean read _Simulate write _Simulate;
    property PhysWorld: tb2_world read _PhysWorld;
    property GridEnable: Boolean read _GridEnable write _GridEnable;
    property GridSizeX: TG2Float read _GridSizeX write SetGridSizeX;
    property GridSizeY: TG2Float read _GridSizeY write SetGridSizeY;
    property GridOffsetX: TG2Float read _GridOffsetX write _GridOffsetX;
    property GridOffsetY: TG2Float read _GridOffsetY write _GridOffsetY;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure DebugDraw(const Display: TG2Display2D);
    procedure Render(const Display: TG2Display2D);
    procedure EnablePhysics;
    procedure DisablePhysics;
    function RenderHookAdd(const HookProc: TG2Scene2DRenderHookProc; const Layer: TG2IntS32): TG2Scene2DRenderHook;
    procedure RenderHookRemove(var Hook: TG2Scene2DRenderHook);
    function FindEntity(const GUID: String): TG2Scene2DEntity;
    function FindEntityByName(const EntityName: String): TG2Scene2DEntity;
    procedure QueryPoint(const p: TG2Vec2; var EntityList: TG2Scene2DEntityList);
    function AdjustToGrid(const v: TG2Vec2): TG2Vec2;
    function GridPos(const v: TG2Vec2): TPoint;
    function CreatePrefab(const dm: TG2DataManager; const Transform: TG2Transform2; const EntityClass: CG2Scene2DEntity = nil): TG2Scene2DEntity;
    function CreatePrefab(const PrefabName: String; const Transform: TG2Transform2; const EntityClass: CG2Scene2DEntity = nil): TG2Scene2DEntity;
    procedure Save(const dm: TG2DataManager);
    procedure Load(const dm: TG2DataManager);
    procedure Load(const FileName: String);
  end;

  TG2Scene2DComponentSprite = class (TG2Scene2DComponent)
  private
    var _Picture: TG2Picture;
    var _RenderHook: TG2Scene2DRenderHook;
    var _Width: TG2Float;
    var _Height: TG2Float;
    var _Scale: TG2Float;
    var _FlipX: Boolean;
    var _FlipY: Boolean;
    var _Transform: TG2Transform2;
    var _Filter: TG2Filter;
    var _Layer: TG2IntS32;
    var _Color: TG2Color;
    var _BlendMode: TG2BlendMode;
    var _Visible: Boolean;
    procedure SetLayer(const Value: TG2IntS32); inline;
    procedure SetPicture(const Value: TG2Picture); inline;
    procedure SetPosition(const Value: TG2Vec2); inline;
    function GetPosition: TG2Vec2; inline;
    procedure SetRotation(const Value: TG2Rotation2); inline;
    function GetRotation: TG2Rotation2; inline;
  protected
    function GetCurrentVersion: TG2IntU16; override;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnRender(const Display: TG2Display2D);
  public
    class constructor CreateClass;
    class function GetName: String; override;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; override;
    property Layer: TG2IntS32 read _Layer write SetLayer;
    property Picture: TG2Picture read _Picture write SetPicture;
    property Width: TG2Float read _Width write _Width;
    property Height: TG2Float read _Height write _Height;
    property Scale: TG2Float read _Scale write _Scale;
    property FlipX: Boolean read _FlipX write _FlipX;
    property FlipY: Boolean read _FlipY write _FlipY;
    property Filter: TG2Filter read _Filter write _Filter;
    property Color: TG2Color read _Color write _Color;
    property BlendMode: TG2BlendMode read _BlendMode write _BlendMode;
    property Visible: Boolean read _Visible write _Visible;
    property Transform: TG2Transform2 read _Transform write _Transform;
    property Position: TG2Vec2 read GetPosition write SetPosition;
    property Rotation: TG2Rotation2 read GetRotation write SetRotation;
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2Scene2DComponentModel3D = class (TG2Scene2DComponent)
  private
    var _Mesh: TG2LegacyMesh;
    var _Inst: TG2LegacyMeshInst;
    var _RenderHook: TG2Scene2DRenderHook;
    var _Scale: TG2Float;
    var _Color: TG2Color;
    var _CameraPitch: TG2Float;
    var _CameraYaw: TG2Float;
    var _CameraRoll: TG2Float;
    var _CameraDistance: TG2Float;
    var _CameraFOV: TG2Float;
    var _CameraNear: TG2Float;
    var _CameraFar: TG2Float;
    var _CameraOrtho: Boolean;
    var _CameraTarget: TG2Vec3;
    var _Layer: TG2IntS32;
    var _AnimName: String;
    var _AnimFrame: TG2Float;
    var _AnimIndex: TG2IntS32;
    var _AnimSpeed: TG2Float;
    var _AnimLoop: Boolean;
    procedure SetMesh(const Value: TG2LegacyMesh);
    procedure SetLayer(const Value: TG2IntS32); inline;
    procedure SetAnimName(const Value: String);
  protected
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnRender(const Display: TG2Display2D);
    procedure OnUpdate;
  public
    class constructor CreateClass;
    class function GetName: String; override;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; override;
    property Mesh: TG2LegacyMesh read _Mesh write SetMesh;
    property Instance: TG2LegacyMeshInst read _Inst;
    property Layer: TG2IntS32 read _Layer write SetLayer;
    property Scale: TG2Float read _Scale write _Scale;
    property Color: TG2Color read _Color write _Color;
    property CameraPitch: TG2Float read _CameraPitch write _CameraPitch;
    property CameraYaw: TG2Float read _CameraYaw write _CameraYaw;
    property CameraRoll: TG2Float read _CameraRoll write _CameraRoll;
    property CameraDistance: TG2Float read _CameraDistance write _CameraDistance;
    property CameraFOV: TG2Float read _CameraFOV write _CameraFOV;
    property CameraNear: TG2Float read _CameraNear write _CameraNear;
    property CameraFar: TG2Float read _CameraFar write _CameraFar;
    property CameraOrtho: Boolean read _CameraOrtho write _CameraOrtho;
    property CameraTarget: TG2Vec3 read _CameraTarget write _CameraTarget;
    property AnimName: String read _AnimName write SetAnimName;
    property AnimSpeed: TG2Float read _AnimSpeed write _AnimSpeed;
    property AnimFrame: TG2Float read _AnimFrame write _AnimFrame;
    property AnimLoop: Boolean read _AnimLoop write _AnimLoop;
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2Scene2DAlignH = (g2al_left, g2al_center, g2al_right);
  TG2Scene2DAlignV = (g2al_top, g2al_middle, g2al_bottom);

  TG2Scene2DComponentText = class (TG2Scene2DComponent)
  private
    var _Font: TG2Font;
    var _Text: String;
    var _AlignH: TG2Scene2DAlignH;
    var _AlignV: TG2Scene2DAlignV;
    var _RenderHook: TG2Scene2DRenderHook;
    var _ScaleX: TG2Float;
    var _ScaleY: TG2Float;
    var _Transform: TG2Transform2;
    var _Filter: TG2Filter;
    var _Layer: TG2IntS32;
    var _Color: TG2Color;
    var _BlendMode: TG2BlendMode;
    var _Visible: Boolean;
    function GetLayer: TG2IntS32; inline;
    procedure SetLayer(const Value: TG2IntS32); inline;
    procedure SetFont(const Value: TG2Font); inline;
    function GetWidth: TG2Float; inline;
    function GetHeight: TG2Float; inline;
    procedure SetPosition(const Value: TG2Vec2); inline;
    function GetPosition: TG2Vec2; inline;
    procedure SetRotation(const Value: TG2Rotation2); inline;
    function GetRotation: TG2Rotation2; inline;
  protected
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnRender(const Display: TG2Display2D);
  public
    class constructor CreateClass;
    class function GetName: String; override;
    class function CanAttach(const {%H-}Node: TG2Scene2DEntity): Boolean; override;
    property Layer: TG2IntS32 read GetLayer write SetLayer;
    property Font: TG2Font read _Font write SetFont;
    property Text: String read _Text write _Text;
    property AlignH: TG2Scene2DAlignH read _AlignH write _AlignH;
    property AlignV: TG2Scene2DAlignV read _AlignV write _AlignV;
    property Width: TG2Float read GetWidth;
    property Height: TG2Float read GetHeight;
    property ScaleX: TG2Float read _ScaleX write _ScaleX;
    property ScaleY: TG2Float read _ScaleY write _ScaleY;
    property Filter: TG2Filter read _Filter write _Filter;
    property Color: TG2Color read _Color write _Color;
    property BlendMode: TG2BlendMode read _BlendMode write _BlendMode;
    property Visible: Boolean read _Visible write _Visible;
    property Transform: TG2Transform2 read _Transform write _Transform;
    property Position: TG2Vec2 read GetPosition write SetPosition;
    property Rotation: TG2Rotation2 read GetRotation write SetRotation;
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2Scene2DComponentEffect = class (TG2Scene2DComponent)
  private
    var _EffectInst: TG2Effect2DInst;
    var _RenderHook: TG2Scene2DRenderHook;
    var _Layer: TG2IntS32;
    var _Scale: TG2Float;
    var _Speed: TG2Float;
    var _Repeating: Boolean;
    var _AutoPlay: Boolean;
    var _AutoDestruct: Boolean;
    var _LocalSpace: Boolean;
    var _FixedOrientation: Boolean;
    procedure OnEffectFinish(const Inst: Pointer);
    function GetEffect: TG2Effect2D; inline;
    procedure SetEffect(const Value: TG2Effect2D);
    procedure SetLayer(const Value: TG2IntS32); inline;
    procedure SetScale(const Value: TG2Float); inline;
    function GetScale: TG2Float; inline;
    procedure SetSpeed(const Value: TG2Float); inline;
    function GetSpeed: TG2Float; inline;
    procedure SetRepeating(const Value: Boolean); inline;
    function GetRepeating: Boolean; inline;
    function GetPlaying: Boolean; inline;
    function GetLocalSpace: Boolean; inline;
    procedure SetLocalSpace(const Value: Boolean);
    function GetFixedOrientation: Boolean; inline;
    procedure SetFixedOrientation(const Value: Boolean); inline;
  protected
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnRender(const Display: TG2Display2D);
  public
    property EffectInst: TG2Effect2DInst read _EffectInst;
    property Effect: TG2Effect2D read GetEffect write SetEffect;
    property Layer: TG2IntS32 read _Layer write SetLayer;
    property Scale: TG2Float read GetScale write SetScale;
    property Speed: TG2Float read GetSpeed write SetSpeed;
    property Repeating: Boolean read GetRepeating write SetRepeating;
    property Playing: Boolean read GetPlaying;
    property AutoPlay: Boolean read _AutoPlay write _AutoPlay;
    property AutoDestruct: Boolean read _AutoDestruct write _AutoDestruct;
    property LocalSpace: Boolean read GetLocalSpace write SetLocalSpace;
    property FixedOrientation: Boolean read GetFixedOrientation write SetFixedOrientation;
    class constructor CreateClass;
    class function GetName: String; override;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; override;
    procedure Play;
    procedure Stop;
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2Scene2DComponentBackground = class (TG2Scene2DComponent)
  private
    var _Layer: TG2IntS32;
    var _Texture: TG2Texture2DBase;
    var _RenderHook: TG2Scene2DRenderHook;
    var _Scale: TG2Vec2;
    var _ScrollSpeed: TG2Vec2;
    var _ScrollPos: TG2Vec2;
    var _FlipX: Boolean;
    var _FlipY: Boolean;
    var _RepeatX: Boolean;
    var _RepeatY: Boolean;
    var _Color: TG2Color;
    var _Filter: TG2Filter;
    var _BlendMode: TG2BlendMode;
    var _RefTexture: Boolean;
    procedure SetLayer(const Value: TG2IntS32); inline;
    procedure SetTexture(const Value: TG2Texture2DBase); inline;
  protected
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnRender(const Display: TG2Display2D);
    procedure OnUpdate;
  public
    class constructor CreateClass;
    class function GetName: String; override;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; override;
    property Layer: TG2IntS32 read _Layer write SetLayer;
    property Texture: TG2Texture2DBase read _Texture write SetTexture;
    property Scale: TG2Vec2 read _Scale write _Scale;
    property ScrollSpeed: TG2Vec2 read _ScrollSpeed write _ScrollSpeed;
    property FlipX: Boolean read _FlipX write _FlipX;
    property FlipY: Boolean read _FlipY write _FlipY;
    property RepeatX: Boolean read _RepeatX write _RepeatX;
    property RepeatY: Boolean read _RepeatY write _RepeatY;
    property Color: TG2Color read _Color write _Color;
    property Filter: TG2Filter read _Filter write _Filter;
    property BlendMode: TG2BlendMode read _BlendMode write _BlendMode;
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2SpineAnimationComponentProc = procedure (const SpineAnimation: TG2Scene2DComponentSpineAnimation);
  TG2SpineAnimationComponentProcObj = procedure (const SpineAnimation: TG2Scene2DComponentSpineAnimation) of object;

  TG2Scene2DComponentSpineAnimation = class (TG2Scene2DComponent)
  private
    var _Layer: TG2IntS32;
    var _RenderHook: TG2Scene2DRenderHook;
    var _SpineRender: TG2SpineRender;
    var _Skeleton: TSpineSkeleton;
    var _State: TSpineAnimationState;
    var _Offset: TG2Vec2;
    var _Scale: TG2Vec2;
    var _Animation: String;
    var _Loop: Boolean;
    var _FlipX: Boolean;
    var _FlipY: Boolean;
    var _TimeScale: TG2Float;
    var _Color: TG2Color;
    var _OnUpdateAnimation: TG2SpineAnimationComponentProcObj;
    procedure SetAnimation(const Value: String);
    procedure SetLayer(const Value: TG2IntS32);
    procedure SetLoop(const Value: Boolean);
    procedure SetFlipX(const Value: Boolean);
    procedure SetFlipY(const Value: Boolean);
    procedure SetScale(const Value: TG2Vec2);
    procedure SetSkeleton(const Value: TSpineSkeleton);
    procedure SetTimeScale(const Value: TG2Float);
    procedure SetColor(const Value: TG2Color);
    function GetBoneTransform(const Bone: TSpineBone): TG2Transform2;
  protected
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnRender(const Display: TG2Display2D);
    procedure OnUpdate;
  public
    class constructor CreateClass;
    class function GetName: String; override;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; override;
    property Skeleton: TSpineSkeleton read _Skeleton write SetSkeleton;
    property Layer: TG2IntS32 read _Layer write SetLayer;
    property Offset: TG2Vec2 read _Offset write _Offset;
    property Scale: TG2Vec2 read _Scale write SetScale;
    property Animation: String read _Animation write SetAnimation;
    property AnimationState: TSpineAnimationState read _State;
    property Loop: Boolean read _Loop write SetLoop;
    property FlipX: Boolean read _FlipX write SetFlipX;
    property FlipY: Boolean read _FlipY write SetFlipY;
    property TimeScale: TG2Float read _TimeScale write SetTimeScale;
    property Color: TG2Color read _Color write SetColor;
    property BoneTransform[const Bone: TSpineBone]: TG2Transform2 read GetBoneTransform;
    property OnUpdateAnimation: TG2SpineAnimationComponentProcObj read _OnUpdateAnimation write _OnUpdateAnimation;
    procedure UpdateAnimation(const DeltaTime: TG2Float);
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  type TG2Scene2DComponentRigidBodyType = (
    g2_s2d_rbt_static_body,
    g2_s2d_rbt_kinematic_body,
    g2_s2d_rbt_dynamic_body
  );

  TG2Scene2DComponentRigidBody = class (TG2Scene2DComponent)
  private
    var _Enabled: Boolean;
    var _BodyDef: tb2_body_def;
    var _Body: pb2_body;
    procedure SetEnabled(const Value: Boolean); virtual;
    procedure SetBodyType(const Value: TG2Scene2DComponentRigidBodyType); inline;
    function GetBodyType: TG2Scene2DComponentRigidBodyType; inline;
    procedure SetPosition(const Value: TG2Vec2); inline;
    function GetPosition: TG2Vec2; inline;
    procedure SetRotation(const Value: TG2Float); inline;
    function GetRotation: TG2Float; inline;
    procedure SetFixedRotation(const Value: Boolean); inline;
    function GetFixedRotation: Boolean; inline;
    procedure SetTransform(const Value: TG2Transform2); inline;
    function GetTransform: TG2Transform2; inline;
    procedure SetGravityScale(const Value: TG2Float); inline;
    function GetGravityScale: TG2Float; inline;
    procedure SetLinearDamping(const Value: TG2Float); inline;
    function GetLinearDamping: TG2Float; inline;
    procedure SetAngularDamping(const Value: TG2Float); inline;
    function GetAngularDamping: TG2Float; inline;
    procedure SetLinearVelocity(const Value: TG2Vec2); inline;
    function GetLinearVelocity: TG2Vec2; inline;
    procedure SetAngularVelocity(const Value: TG2Float); inline;
    function GetAngularVelocity: TG2Float; inline;
    procedure SetIsBullet(const Value: Boolean); inline;
    function GetIsBullet: Boolean; inline;
  protected
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnUpdate; virtual;
    procedure AddShape(const Shape: TG2Scene2DComponentCollisionShape);
    procedure RemoveShape(const Shape: TG2Scene2DComponentCollisionShape);
  public
    class constructor CreateClass;
    class function GetName: String; override;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; override;
    property Transform: TG2Transform2 read GetTransform write SetTransform;
    property BodyType: TG2Scene2DComponentRigidBodyType read GetBodyType write SetBodyType;
    property Position: TG2Vec2 read GetPosition write SetPosition;
    property Rotation: TG2Float read GetRotation write SetRotation;
    property FixedRotation: Boolean read GetFixedRotation write SetFixedRotation;
    property GravityScale: TG2Float read GetGravityScale write SetGravityScale;
    property LinearDamping: TG2Float read GetLinearDamping write SetLinearDamping;
    property AngularDamping: TG2Float read GetAngularDamping write SetAngularDamping;
    property LinearVelocity: TG2Vec2 read GetLinearVelocity write SetLinearVelocity;
    property IsBullet: Boolean read GetIsBullet write SetIsBullet;
    property AngularVelocity: TG2Float read GetAngularVelocity write SetAngularVelocity;
    property Enabled: Boolean read _Enabled write SetEnabled;
    property PhysBody: pb2_body read _Body;
    procedure MakeStatic; inline;
    procedure MakeKinematic; inline;
    procedure MakeDynamic; inline;
    procedure UpdateFromOwner; inline;
    procedure ApplyToOwner; inline;
    procedure ApplyLinearImpulse(const Impulse, Point: TG2Vec2; const Wake: Boolean = True); inline;
    procedure ApplyAngularImpulse(const Impulse: TG2Float; const Wake: Boolean = True); inline;
    procedure ApplyForce(const Force, Point: TG2Vec2; const Wake: Boolean = True);
    procedure ApplyForceToCenter(const Force: TG2Vec2; const Wake: Boolean = True);
    procedure ApplyTorque(const Torque: TG2Float; const Wake: Boolean = True);
    procedure Wake;
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2Scene2DEventBeginContactData = class (TG2Scene2DEventData)
  public
    var PhysContact: pb2_contact;
    var Shapes: array[0..1] of TG2Scene2DComponentCollisionShape;
    var Entities: array[0..1] of TG2Scene2DEntity;
    constructor Create; override;
    function GetContactPoint: TG2Vec2;
  end;

  TG2Scene2DEventEndContactData = class (TG2Scene2DEventData)
  public
    var PhysContact: pb2_contact;
    var Shapes: array[0..1] of TG2Scene2DComponentCollisionShape;
    var Entities: array[0..1] of TG2Scene2DEntity;
    constructor Create; override;
  end;

  TG2Scene2DEventBeforeContactSolveData = class (TG2Scene2DEventData)
  public
    var PhysContact: pb2_contact;
    var Shapes: array[0..1] of TG2Scene2DComponentCollisionShape;
    var Entities: array[0..1] of TG2Scene2DEntity;
    constructor Create; override;
  end;

  TG2Scene2DEventAfterContactSolveData = class (TG2Scene2DEventData)
  public
    var PhysContact: pb2_contact;
    var Shapes: array[0..1] of TG2Scene2DComponentCollisionShape;
    var Entities: array[0..1] of TG2Scene2DEntity;
    constructor Create; override;
  end;

  TG2Scene2DCollisionFilter = record
    CategoryBits: TG2IntU16;
    MaskBits: TG2IntU16;
    GroupIndex: TG2IntS16;
  end;

  TG2Scene2DComponentCollisionShape = class (TG2Scene2DComponent)
  private
    var _EventBeginContactData: TG2Scene2DEventBeginContactData;
    var _EventEndContactData: TG2Scene2DEventEndContactData;
    var _EventBeforeContactSolveData: TG2Scene2DEventBeforeContactSolveData;
    var _EventAfterContactSolveData: TG2Scene2DEventAfterContactSolveData;
    procedure SetFilterCategoryMask(const Value: TG2IntU16); inline;
    function GetFilterCategoryMask: TG2IntU16; inline;
    procedure SetFilterMask(const Value: TG2IntU16); inline;
    function GetFilterMask: TG2IntU16; inline;
    procedure SetFilterGroup(const Value: TG2IntS16); inline;
    function GetFilterGroup: TG2IntS16; inline;
  protected
    var _FixtureDef: tb2_fixture_def;
    var _Fixture: pb2_fixture;
    var _EventBeginContact: TG2Scene2DEventDispatcher;
    var _EventEndContact: TG2Scene2DEventDispatcher;
    var _EventBeforeContactSolve: TG2Scene2DEventDispatcher;
    var _EventAfterContactSolve: TG2Scene2DEventDispatcher;
    property Fixture: pb2_fixture read _Fixture write _Fixture;
    property FixtureDef: tb2_fixture_def read _FixtureDef;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure Reattach;
    function GetFriction: TG2Float; inline;
    procedure SetFriction(const Value: TG2Float); inline;
    function GetDensity: TG2Float; inline;
    procedure SetDensity(const Value: TG2Float); inline;
    function GetRestitution: TG2Float; inline;
    procedure SetRestitution(const Value: TG2Float); inline;
    function GetIsSensor: Boolean; inline;
    procedure SetIsSensor(const Value: Boolean); inline;
    procedure OnBeginContact(
      const OtherEntity: TG2Scene2DEntity;
      const OtherShape: TG2Scene2DComponentCollisionShape;
      const Contact: pb2_contact
    ); inline;
    procedure OnEndContact(
      const OtherEntity: TG2Scene2DEntity;
      const OtherShape: TG2Scene2DComponentCollisionShape;
      const Contact: pb2_contact
    ); inline;
    procedure OnBeforeContactSolve(
      const OtherEntity: TG2Scene2DEntity;
      const OtherShape: TG2Scene2DComponentCollisionShape;
      const Contact: pb2_contact
    ); inline;
    procedure OnAfterContactSolve(
      const OtherEntity: TG2Scene2DEntity;
      const OtherShape: TG2Scene2DComponentCollisionShape;
      const Contact: pb2_contact
    ); inline;
  public
    class constructor CreateClass;
    class function GetName: String; override;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; override;
    property Fricton: TG2Float read GetFriction write SetFriction;
    property Density: TG2Float read GetDensity write SetDensity;
    property Restitution: TG2Float read GetRestitution write SetRestitution;
    property IsSensor: Boolean read GetIsSensor write SetIsSensor;
    property FilterCatergoryMask: TG2IntU16 read GetFilterCategoryMask write SetFilterCategoryMask;
    property FilterMask: TG2IntU16 read GetFilterMask write SetFilterMask;
    property FilterGroup: TG2IntS16 read GetFilterGroup write SetFilterGroup;
    property PhysFixture: pb2_fixture read _Fixture;
    property EventBeginContact: TG2Scene2DEventDispatcher read _EventBeginContact;
    property EventEndContact: TG2Scene2DEventDispatcher read _EventEndContact;
    property EventBeforeContactSolve: TG2Scene2DEventDispatcher read _EventBeforeContactSolve;
    property EventAfterContactSolve: TG2Scene2DEventDispatcher read _EventAfterContactSolve;
  end;

  TG2Scene2DComponentCollisionShapeEdge = class (TG2Scene2DComponentCollisionShape)
  private
    function GetHasVertex0: Boolean; inline;
    function GetHasVertex3: Boolean; inline;
    function GetVertex0: TG2Vec2; inline;
    function GetVertex1: TG2Vec2; inline;
    function GetVertex2: TG2Vec2; inline;
    function GetVertex3: TG2Vec2; inline;
    procedure SetHasVertex0(const Value: Boolean); inline;
    procedure SetHasVertex3(const Value: Boolean); inline;
    procedure SetVertex0(const Value: TG2Vec2); inline;
    procedure SetVertex1(const Value: TG2Vec2); inline;
    procedure SetVertex2(const Value: TG2Vec2); inline;
    procedure SetVertex3(const Value: TG2Vec2); inline;
  protected
    var _EdgeShape: tb2_edge_shape;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
  public
    class constructor CreateClass;
    class function GetName: String; override;
    property Vertex0: TG2Vec2 read GetVertex0 write SetVertex0;
    property Vertex1: TG2Vec2 read GetVertex1 write SetVertex1;
    property Vertex2: TG2Vec2 read GetVertex2 write SetVertex2;
    property Vertex3: TG2Vec2 read GetVertex3 write SetVertex3;
    property HasVertex0: Boolean read GetHasVertex0 write SetHasVertex0;
    property HasVertex3: Boolean read GetHasVertex3 write SetHasVertex3;
    procedure SetUp(const v0, v1: TG2Vec2);
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2Scene2DComponentCollisionShapePoly = class (TG2Scene2DComponentCollisionShape)
  private
    function GetVertices: PG2Vec2Arr; inline;
    function GetVertexCount: TG2IntS32; inline;
  protected
    var _PolyShape: tb2_polygon_shape;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
  public
    class constructor CreateClass;
    class function GetName: String; override;
    property Vertices: PG2Vec2Arr read GetVertices;
    property VertexCount: TG2IntS32 read GetVertexCount;
    procedure SetUpBox(const w, h: TG2Float); overload; virtual;
    procedure SetUpBox(const w, h: TG2Float; const c: TG2Vec2; const r: TG2Float); overload; virtual;
    procedure SetUp(const v: PG2Vec2Arr; const vc: TG2IntS32); virtual;
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  {$Notes off}
  TG2Scene2DComponentCollisionShapeBox = class (TG2Scene2DComponentCollisionShapePoly)
  private
    var _Width: TG2Float;
    var _Height: TG2Float;
    var _Offset: TG2Vec2;
    var _Angle: TG2Float;
    procedure UpdateProperties;
    procedure SetWidth(const Value: TG2Float); inline;
    procedure SetHeight(const Value: TG2Float); inline;
    procedure SetOffset(const Value: TG2Vec2); inline;
    procedure SetAngle(const Value: TG2Float); inline;
  protected
    procedure SetUp(const v: PG2Vec2Arr; const vc: TG2IntS32); override;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
  public
    class constructor CreateClass;
    class function GetName: String; override;
    property Width: TG2Float read _Width write SetWidth;
    property Height: TG2Float read _Height write SetHeight;
    property Offset: TG2Vec2 read _Offset write SetOffset;
    property Angle: TG2Float read _Angle write SetAngle;
    procedure SetUpBox(const w, h: TG2Float); overload; override;
    procedure SetUpBox(const w, h: TG2Float; const c: TG2Vec2; const r: TG2Float); overload; override;
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;
  {$Notes on}

  TG2Scene2DComponentCollisionShapeCircle = class (TG2Scene2DComponentCollisionShape)
  private
    function GetCenter: TG2Vec2; inline;
    procedure SetCenter(const Value: TG2Vec2); inline;
    function GetRadius: TG2Float; inline;
    procedure SetRadius(const Value: TG2Float); inline;
  protected
    var _CircleShape: tb2_circle_shape;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
  public
    class constructor CreateClass;
    class function GetName: String; override;
    property Center: TG2Vec2 read GetCenter write SetCenter;
    property Radius: TG2Float read GetRadius write SetRadius;
    procedure SetUp(const c: TG2Vec2; const r: TG2Float);
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2Scene2DComponentCollisionShapeChain = class (TG2Scene2DComponentCollisionShape)
  private
    function GetVertexCount: TG2IntS32; inline;
    function GetVertexNext: TG2Vec2; inline;
    function GetVertexPrev: TG2Vec2; inline;
    function GetVertices: PG2Vec2Arr; inline;
    procedure SetVertexNext(const Value: TG2Vec2); inline;
    procedure SetVertexPrev(const Value: TG2Vec2); inline;
  protected
    var _ChainShape: tb2_chain_shape;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
  public
    class constructor CreateClass;
    class function GetName: String; override;
    property Vertices: PG2Vec2Arr read GetVertices;
    property VertexCount: TG2IntS32 read GetVertexCount;
    property VertexPrev: TG2Vec2 read GetVertexPrev write SetVertexPrev;
    property VertexNext: TG2Vec2 read GetVertexNext write SetVertexNext;
    property HasVertexPrev: Boolean read _ChainShape.has_prev_vertex write _ChainShape.has_prev_vertex;
    property HasVertexNext: Boolean read _ChainShape.has_next_vertex write _ChainShape.has_next_vertex;
    procedure SetUp(const v: PG2Vec2Arr; const vc: TG2IntS32);
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2Scene2DComponentCharacter = class (TG2Scene2DComponentRigidBody)
  protected
    var _FixtureFeetDef: tb2_fixture_def;
    var _FixtureFeet: pb2_fixture;
    var _ShapeFeet: tb2_circle_shape;
    var _FixtureBodyDef: tb2_fixture_def;
    var _FixtureBody: pb2_fixture;
    var _ShapeBody: tb2_polygon_shape;
    var _BodyFeetDef: tb2_body_def;
    var _BodyFeet: pb2_body;
    var _ShapeGroundCheck: tb2_polygon_shape;
    var _FixtureGroundCheck: pb2_fixture;
    var _ShapeDuckCheck: tb2_polygon_shape;
    var _FixtureDuckCheck: pb2_fixture;
    var _Joint: pb2_joint;
    var _BodyMassData: tb2_mass_data;
    var _BodyVerts: array[0..6] of tb2_vec2;
    var _GroundCheckVerts: array[0..3] of tb2_vec2;
    var _DuckCheckVerts: array[0..3] of tb2_vec2;
    var _DuckCheckContacts: TG2IntS32;
    var _Width: TG2Float;
    var _Height: TG2Float;
    var _WalkSpeed: TG2Float;
    var _JumpSpeed: TG2Vec2;
    var _JumpDelay: TG2Float;
    var _GlideSpeed: TG2Vec2;
    var _MaxGlideSpeed: TG2Float;
    var _Standing: Boolean;
    var _Duck: TG2Float;
    var _FootContactCount: TG2IntS32;
    procedure SetupShapes;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnUpdate; override;
    procedure SetEnabled(const Value: Boolean); override;
    procedure SetWidth(const Value: TG2Float); inline;
    procedure SetHeight(const Value: TG2Float); inline;
    procedure SetDuck(const Value: TG2Float); inline;
    procedure OnBeginContact(
      const OtherEntity: TG2Scene2DEntity;
      const OtherShape: TG2Scene2DComponentCollisionShape;
      const SelfFixture: pb2_fixture;
      const Contact: pb2_contact
    ); inline;
    procedure OnEndContact(
      const OtherEntity: TG2Scene2DEntity;
      const OtherShape: TG2Scene2DComponentCollisionShape;
      const SelfFixture: pb2_fixture;
      const Contact: pb2_contact
    ); inline;
    procedure OnBeforeContactSolve(
      const OtherEntity: TG2Scene2DEntity;
      const OtherShape: TG2Scene2DComponentCollisionShape;
      const SelfFixture: pb2_fixture;
      const Contact: pb2_contact
    ); inline;
    procedure OnAfterContactSolve(
      const OtherEntity: TG2Scene2DEntity;
      const OtherShape: TG2Scene2DComponentCollisionShape;
      const SelfFixture: pb2_fixture;
      const Contact: pb2_contact
    ); inline;
  public
    class constructor CreateClass;
    class function GetName: String; override;
    property Width: TG2Float read _Width write SetWidth;
    property Height: TG2Float read _Height write SetHeight;
    property Duck: TG2Float read _Duck write SetDuck;
    property Standing: Boolean read _Standing;
    property MaxGlideSpeed: TG2Float read _MaxGlideSpeed write _MaxGlideSpeed;
    procedure Walk(const Speed: TG2Float);
    procedure Jump(const Speed: TG2Vec2);
    procedure Glide(const Speed: TG2Vec2);
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2Scene2DComponentPoly = class (TG2Scene2DComponent)
  public
    type TG2Scene2DComponentPolyVertex = record
      x, y: TG2Float;
      u, v: TG2Float;
    end;
    type PG2Scene2DComponentPolyVertex = ^TG2Scene2DComponentPolyVertex;
    type TG2Scene2DComponentPolyLayer = class
    private
      var _Owner: TG2Scene2DComponentPoly;
      var _Hook: TG2Scene2DRenderHook;
      var _Layer: TG2IntS32;
      var _Texture: TG2Texture2DBase;
      var _Scale: TG2Vec2;
      function GetVisible: Boolean; inline;
      procedure SetVisible(const Value: Boolean); inline;
      procedure SetLayer(const Value: TG2IntS32); inline;
      procedure OnRender(const Display: TG2Display2D);
      procedure SetTexture(const Value: TG2Texture2DBase);
      function GetScale: TG2Vec2;
      procedure SetScale(const Value: TG2Vec2);
    public
      Color: array of TG2Color;
      property Scale: TG2Vec2 read GetScale write SetScale;
      property ScaleRcp: TG2Vec2 read _Scale write _Scale;
      property Texture: TG2Texture2DBase read _Texture write SetTexture;
      property Visible: Boolean read GetVisible write SetVisible;
      property Layer: TG2IntS32 read _Layer write SetLayer;
      constructor Create(const Component: TG2Scene2DComponentPoly);
      destructor Destroy; override;
    end;
  private
    var _Vertices: array of TG2Scene2DComponentPolyVertex;
    var _Faces: array of array[0..2] of TG2IntU16;
    var _Layers: array of TG2Scene2DComponentPolyLayer;
    var _DebugRenderHook: TG2Scene2DRenderHook;
    var _DebugLayer: TG2IntS32;
    var _DebugRender: Boolean;
    var _Visible: Boolean;
    procedure ClearLayers;
    procedure CreateLayers;
    procedure SetDebugLayer(const Value: TG2IntS32); inline;
    procedure SetDebugRender(const Value: Boolean); inline;
    function GetLayerCount: TG2IntS32; inline;
    procedure SetLayerCount(const Value: TG2IntS32); inline;
    function GetLayer(const Index: TG2IntS32): TG2Scene2DComponentPolyLayer; inline;
    procedure RenderLayer(const Layer: TG2Scene2DComponentPolyLayer; const Display: TG2Display2D);
    function GetVertexCount: TG2IntS32; inline;
    function GetVertex(const Index: TG2IntS32): PG2Scene2DComponentPolyVertex; inline;
    function GetFaceCount: TG2IntS32; inline;
    function GetFace(const Index: TG2IntS32): PG2IntU16Arr; inline;
  protected
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnDebugRender(const Display: TG2Display2D);
    procedure OnRender(const Display: TG2Display2D);
  public
    property DebugLayer: TG2IntS32 read _DebugLayer write SetDebugLayer;
    property DebugRender: Boolean read _DebugRender write SetDebugRender;
    property Visible: Boolean read _Visible write _Visible;
    property LayerCount: TG2IntS32 read GetLayerCount write SetLayerCount;
    property Layers[const Index: TG2IntS32]: TG2Scene2DComponentPolyLayer read GetLayer;
    property VertexCount: TG2IntS32 read GetVertexCount;
    property Vertices[const Index: TG2IntS32]: PG2Scene2DComponentPolyVertex read GetVertex;
    property FaceCount: TG2IntS32 read GetFaceCount;
    property Faces[const Index: TG2IntS32]: PG2IntU16Arr read GetFace;
    class constructor CreateClass;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; override;
    class function GetName: String; override;
    procedure SetUp(const Triangles: PG2Vec2Arr; const TriangleCount: TG2IntS32); overload;
    procedure SetUp(
      const NewVertices: PG2Vec2; const NewVertexCount, VertexStride: TG2IntS32;
      const NewIndices: PG2IntU16; const NewIndexCount, IndexStride: TG2IntS32;
      const NewTexCoords: PG2Vec2; const TexCoordStride: TG2IntS32
    ); overload;
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2Scene2DComponentProperties = class (TG2Scene2DComponent)
  public
    type TProp = object
      Name: String;
      Value: String;
      function IsInt: Boolean;
      function IsFloat: Boolean;
      function AsInt: TG2IntS32;
      function AsFloat: TG2Float;
    end;
    PProp = ^TProp;
  private
    function GetCount: TG2IntS32; inline;
    function GetProp(const Index: TG2IntS32): PProp; inline;
  protected
    var _Props: array of PProp;
  public
    property Count: TG2IntS32 read GetCount;
    property Items[const Index: TG2IntS32]: PProp read GetProp;
    class constructor CreateClass;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; override;
    function FindIndex(const Name: String): TG2IntS32;
    function Find(const Name: String): PProp;
    procedure Add(const Name: String; const Value: String);
    procedure Delete(const Index: TG2IntS32); overload;
    procedure Delete(const Name: String); overload;
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  TG2Scene2DComponentStrings = class (TG2Scene2DComponent)
  private
    var _Text: TG2TextAsset;
    procedure SetText(const Value: TG2TextAsset);
  protected
    procedure OnInitialize; override;
    procedure OnFinalize; override;
  public
    property Text: TG2TextAsset read _Text write SetText;
    class constructor CreateClass;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; override;
    class function GetName: String; override;
    procedure Save(const dm: TG2DataManager); override;
    procedure Load(const dm: TG2DataManager); override;
  end;

  operator := (v: tb2_vec2): TG2Vec2; inline;
  operator := (v: TG2Vec2): tb2_vec2; inline;
  operator := (r: tb2_rot): TG2Rotation2; inline;
  operator := (r: TG2Rotation2): tb2_rot; inline;
  operator := (t: tb2_transform): TG2Transform2; inline;
  operator := (t: TG2Transform2): tb2_transform; inline;
  operator := (varr: pb2_vec2_arr): PG2Vec2Arr; inline;
  operator := (varr: PG2Vec2Arr): pb2_vec2_arr; inline;

implementation

//TG2Scene2DEventData BEGIN
constructor TG2Scene2DEventData.Create;
begin
  inherited Create;
end;

destructor TG2Scene2DEventData.Destroy;
begin
  inherited Destroy;
end;
//TG2Scene2DEventData END

//TG2Scene2DEventDispatcher BEGIN
constructor TG2Scene2DEventDispatcher.Create(const NewName: String);
begin
  inherited Create;
  _Name := NewName;
  _Events.Clear;
end;

destructor TG2Scene2DEventDispatcher.Destroy;
begin
  inherited Destroy;
end;

procedure TG2Scene2DEventDispatcher.AddEvent(const Event: TG2Scene2DEvent);
  var i: TG2IntS32;
begin
  for i := 0 to _Events.Count - 1 do
  if G2CmpObjFuncPtr(@_Events, @Event) then Exit;
  _Events.Add(Event);
end;

procedure TG2Scene2DEventDispatcher.RemoveEvent(const Event: TG2Scene2DEvent);
  var i: TG2IntS32;
begin
  for i := 0 to _Events.Count - 1 do
  if G2CmpObjFuncPtr(@_Events, @Event) then
  begin
    _Events.Delete(i);
    Exit;
  end;
end;

procedure TG2Scene2DEventDispatcher.DispatchEvent(const EventData: TG2Scene2DEventData);
  var i: TG2IntS32;
begin
  for i := 0 to _Events.Count - 1 do
  _Events[i](EventData);
end;
//TG2Scene2DEventDispatcher END

//TG2Scene2DComponent BEGIN
procedure TG2Scene2DComponent.SetOwner(const Value: TG2Scene2DEntity);
begin
  if _Owner = Value then Exit;
  if _Owner <> nil then
  begin
    OnDetach;
    if Assigned(_ProcOnDetach) then _ProcOnDetach(Self);
    _Owner.RemoveComponent(Self);
    _Owner := nil;
  end;
  _Owner := Value;
  if _Owner <> nil then
  begin
    _Owner.AddComponent(Self);
    OnAttach;
    if Assigned(_ProcOnAttach) then _ProcOnAttach(Self);
  end;
end;

function TG2Scene2DComponent.GetTag(const Index: TG2IntS32): AnsiString;
begin
  Result := _Tags[Index];
end;

function TG2Scene2DComponent.GetTagCount: TG2IntS32;
begin
  Result := _Tags.Count;
end;

function TG2Scene2DComponent.GetCurrentVersion: TG2IntU16;
begin
  Result := $0001;
end;

procedure TG2Scene2DComponent.OnInitialize;
begin

end;

procedure TG2Scene2DComponent.OnFinalize;
begin

end;

procedure TG2Scene2DComponent.OnAttach;
begin

end;

procedure TG2Scene2DComponent.OnDetach;
begin

end;

procedure TG2Scene2DComponent.SaveClassType(const dm: TG2DataManager);
begin
  dm.WriteStringA(ClassName);
end;

procedure TG2Scene2DComponent.SaveTags(const dm: TG2DataManager);
  var i: TG2IntS32;
begin
  dm.WriteIntS32(_Tags.Count);
  for i := 0 to _Tags.Count - 1 do
  begin
    dm.WriteStringA(_Tags[i]);
  end;
end;

procedure TG2Scene2DComponent.SaveVersion(const dm: TG2DataManager);
begin
  dm.WriteIntU16(GetCurrentVersion);
end;

function TG2Scene2DComponent.LoadVersion(const dm: TG2DataManager): TG2IntU16;
begin
  Result := dm.ReadIntU16;
end;

procedure TG2Scene2DComponent.LoadTags(const dm: TG2DataManager);
  var i, n: TG2IntS32;
begin
  n := dm.ReadIntS32;
  _Tags.Clear;
  for i := 0 to n - 1 do
  begin
    _Tags.Add(dm.ReadStringA);
  end;
end;

class constructor TG2Scene2DComponent.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponent.GetName: String;
begin
  Result := 'Component';
end;

{$Hints off}
class function TG2Scene2DComponent.CanAttach(const Node: TG2Scene2DEntity): Boolean;
begin
  Result := False;
end;
{$Hints on}

constructor TG2Scene2DComponent.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create;
  _Scene := OwnerScene;
  _ProcOnAttach := nil;
  _ProcOnDetach := nil;
  _ProcOnFinalize := nil;
  _EventDispatchers.Clear;
  _Tags.Clear;
  OnInitialize;
end;

destructor TG2Scene2DComponent.Destroy;
begin
  OnFinalize;
  if Assigned(_ProcOnFinalize) then _ProcOnFinalize(Self);
  inherited Destroy;
end;

function TG2Scene2DComponent.HasTag(const Tag: AnsiString): Boolean;
  var i: TG2IntS32;
begin
  for i := 0 to _Tags.Count - 1 do
  if _Tags[i] = Tag then
  begin
    Result := True;
    Exit;
  end;
  Result := False;
end;

procedure TG2Scene2DComponent.AddTag(const Tag: AnsiString);
  var CurTag: AnsiString;
begin
  if HasTag(Tag) then Exit;
  CurTag := G2StrTrim(LowerCase(Tag));
  if Length(CurTag) > 0 then _Tags.Add(CurTag);
end;

procedure TG2Scene2DComponent.RemoveTag(const Tag: AnsiString);
begin
  _Tags.Remove(Tag);
end;

procedure TG2Scene2DComponent.ParseTags(const TagsString: AnsiString);
  var StrArr: TG2StrArrA;
  var CurTag: AnsiString;
  var i: TG2IntS32;
begin
  _Tags.Clear;
  StrArr := G2StrExplode(LowerCase(TagsString), ',');
  for i := 0 to High(StrArr) do
  begin
    CurTag := G2StrTrim(StrArr[i]);
    if Length(CurTag) > 0 then _Tags.Add(CurTag);
  end;
end;

procedure TG2Scene2DComponent.Attach(const Entity: TG2Scene2DEntity);
begin
  Owner := Entity;
end;

procedure TG2Scene2DComponent.Detach;
begin
  Owner := nil;
end;

procedure TG2Scene2DComponent.AddEvent(const EventName: String; const Event: TG2Scene2DEvent);
  var i: TG2IntS32;
begin
  for i := 0 to _EventDispatchers.Count - 1 do
  if _EventDispatchers[i].Name = EventName then
  begin
    _EventDispatchers[i].AddEvent(Event);
    Exit;
  end;
end;

procedure TG2Scene2DComponent.RemoveEvent(const EventName: String; const Event: TG2Scene2DEvent);
  var i: TG2IntS32;
begin
  for i := 0 to _EventDispatchers.Count - 1 do
  if _EventDispatchers[i].Name = EventName then
  begin
    _EventDispatchers[i].RemoveEvent(Event);
    Exit;
  end;
end;

{$Hints off}
procedure TG2Scene2DComponent.Save(const dm: TG2DataManager);
begin
end;
{$Hints on}

{$Hints off}
procedure TG2Scene2DComponent.Load(const dm: TG2DataManager);
begin
end;
{$Hints on}
//TG2Scene2DComponent END

//TG2Scene2DEntity BEGIN
function TG2Scene2DEntity.GetChild(const Index: TG2IntS32): TG2Scene2DEntity;
begin
  Result := _Children[Index];
end;

function TG2Scene2DEntity.GetChildCount: TG2IntS32;
begin
  Result := _Children.Count;
end;

function TG2Scene2DEntity.GetComponent(
  const Index: TG2IntS32
): TG2Scene2DComponent;
begin
  Result := _Components[Index];
end;

function TG2Scene2DEntity.GetComponentCount: TG2IntS32;
begin
  Result := _Components.Count;
end;

function TG2Scene2DEntity.GetComponentOfType(
  const ComponentType: CG2Scene2DComponent
): TG2Scene2DComponent;
  var i: TG2IntS32;
begin
  for i := 0 to _Components.Count - 1 do
  if _Components[i] is ComponentType then
  begin
    Result := _Components[i];
    Exit;
  end;
  Result := nil;
end;

procedure TG2Scene2DEntity.SetEnabled(const Value: Boolean);
begin
  if _Enabled = Value then Exit;
  _Enabled := Value;
  if _Enabled then OnEnable else OnDisable;
end;

procedure TG2Scene2DEntity.SetTransformIsolated(const Value: TG2Transform2);
begin
  _Transform := Value;
end;

procedure TG2Scene2DEntity.SetParent(const Value: TG2Scene2DEntity);
begin
  if _Parent = Value then Exit;
  if _Parent <> nil then
  _Parent.RemoveChild(Self);
  _Parent := Value;
  if _Parent <> nil then
  _Parent.AddChild(Self);
end;

procedure TG2Scene2DEntity.AddComponent(const Component: TG2Scene2DComponent);
begin
  _Components.Add(Component);
end;

procedure TG2Scene2DEntity.RemoveComponent(const Component: TG2Scene2DComponent);
begin
  _Components.Remove(Component);
end;

function TG2Scene2DEntity.GetTag(const Index: TG2IntS32): AnsiString;
begin
  Result := _Tags[Index];
end;

function TG2Scene2DEntity.GetTagCount: TG2IntS32;
begin
  Result := _Tags.Count;
end;

function TG2Scene2DEntity.GetPosition: TG2Vec2;
begin
  Result := _Transform.p;
end;

procedure TG2Scene2DEntity.SetPosition(const Value: TG2Vec2);
begin
  SetTransform(G2Transform2(Value, _Transform.r));
end;

function TG2Scene2DEntity.GetRotation: TG2Rotation2;
begin
  Result := _Transform.r;
end;

procedure TG2Scene2DEntity.SetRotation(const Value: TG2Rotation2);
begin
  SetTransform(G2Transform2(_Transform.p, Value));
end;

function TG2Scene2DEntity.GetCurrentVersion: TG2IntU16;
begin
  Result := $0001;
end;

procedure TG2Scene2DEntity.SetTransform(const Value: TG2Transform2);
  var Origin: TG2Vec2;
  var xfm: TG2Transform2;
  procedure ApplyTransform(const Node: TG2Scene2DEntity);
    var i: TG2IntS32;
    var xfc: TG2Transform2;
  begin
    xfc := Node.Transform;
    xfc.p -= Origin;
    G2Transform2Mul(@xfc, @xfc, @xfm);
    xfc.p += Origin;
    Node.SetTransformIsolated(xfc);
    for i := 0 to Node.ChildCount - 1 do
    ApplyTransform(Node.Children[i]);
  end;
begin
  if _Children.Count > 0 then
  begin
    xfm.r.Angle := Value.r.Angle - _Transform.r.Angle;
    xfm.p := Value.p - _Transform.p;
    Origin := _Transform.p;
    ApplyTransform(Self);
  end
  else
  begin
    _Transform := Value;
  end;
end;

procedure TG2Scene2DEntity.AddChild(const Child: TG2Scene2DEntity);
begin
  _Children.Add(Child);
end;

procedure TG2Scene2DEntity.RemoveChild(const Child: TG2Scene2DEntity);
begin
  _Children.Remove(Child);
end;

procedure TG2Scene2DEntity.OnDebugDraw(const Display: TG2Display2D);
begin
  Display.PrimLine(_Transform.p, _Transform.p + _Transform.r.AxisX, $ffff0000);
  Display.PrimLine(_Transform.p, _Transform.p + _Transform.r.AxisY, $ff0000ff);
end;

{$Hints off}
procedure TG2Scene2DEntity.OnRender(const Display: TG2Display2D);
begin

end;

procedure TG2Scene2DEntity.OnEnable;
begin

end;

procedure TG2Scene2DEntity.OnDisable;
begin

end;

{$Hints on}

constructor TG2Scene2DEntity.Create(const OwnerScene: TG2Scene2D);
begin
  _Parent := nil;
  _Children.Clear;
  _Transform.SetIdentity;
  _Name := 'Entity';
  _Scene := OwnerScene;
  _EventDispatchers.Clear;
  _Tags.Clear;
  _Enabled := False;
  NewGUID;
  _Scene.EntityAdd(Self);
  Enabled := True;
end;

destructor TG2Scene2DEntity.Destroy;
  var n: TG2Scene2DEntity;
  var c: TG2Scene2DComponent;
begin
  while _Components.Count > 0 do
  begin
    c := _Components.Last;
    c.Detach;
    c.Free;
  end;
  Parent := nil;
  while _Children.Count > 0 do
  begin
    n := _Children.Pop;
    n._Parent := nil;
    n.Free;
  end;
  _Scene.EntityRemove(Self);
end;

procedure TG2Scene2DEntity.NewGUID;
  var new_guid: TGUID;
begin
  CreateGUID(new_guid);
  _GUID := GUIDToString(new_guid);
end;

function TG2Scene2DEntity.FindChildByName(const ChildName: String): TG2Scene2DEntity;
  var i: TG2IntS32;
begin
  for i := 0 to _Children.Count - 1 do
  if _Children[i].Name = ChildName then
  begin
    Result := _Children[i];
    Exit;
  end;
  Result := nil;
end;

function TG2Scene2DEntity.HasTag(const Tag: AnsiString): Boolean;
  var i: TG2IntS32;
begin
  for i := 0 to _Tags.Count - 1 do
  if _Tags[i] = Tag then
  begin
    Result := True;
    Exit;
  end;
  Result := False;
end;

procedure TG2Scene2DEntity.AddTag(const Tag: AnsiString);
  var CurTag: AnsiString;
begin
  if HasTag(Tag) then Exit;
  CurTag := G2StrTrim(LowerCase(Tag));
  if Length(CurTag) > 0 then _Tags.Add(CurTag);
end;

procedure TG2Scene2DEntity.RemoveTag(const Tag: AnsiString);
begin
  _Tags.Remove(Tag);
end;

procedure TG2Scene2DEntity.ParseTags(const TagsString: AnsiString);
  var StrArr: TG2StrArrA;
  var CurTag: AnsiString;
  var i: TG2IntS32;
begin
  _Tags.Clear;
  StrArr := G2StrExplode(LowerCase(TagsString), ',');
  for i := 0 to High(StrArr) do
  begin
    CurTag := G2StrTrim(StrArr[i]);
    if Length(CurTag) > 0 then _Tags.Add(CurTag);
  end;
end;

procedure TG2Scene2DEntity.DebugDraw(const Display: TG2Display2D);
  var i: TG2IntS32;
begin
  for i := 0 to _Children.Count - 1 do
  _Children[i].DebugDraw(Display);
  OnDebugDraw(Display);
end;

procedure TG2Scene2DEntity.Render(const Display: TG2Display2D);
  var i: TG2IntS32;
begin
  for i := 0 to _Children.Count - 1 do
  _Children[i].Render(Display);
  OnRender(Display);
end;

procedure TG2Scene2DEntity.AddEvent(const EventName: String; const Event: TG2Scene2DEvent);
  var i: TG2IntS32;
begin
  for i := 0 to _EventDispatchers.Count - 1 do
  if _EventDispatchers[i].Name = EventName then
  begin
    _EventDispatchers[i].AddEvent(Event);
    Break;
  end;
  for i := 0 to _Components.Count - 1 do
  _Components[i].AddEvent(EventName, Event);
end;

procedure TG2Scene2DEntity.RemoveEvent(const EventName: String; const Event: TG2Scene2DEvent);
  var i: TG2IntS32;
begin
  for i := 0 to _EventDispatchers.Count - 1 do
  if _EventDispatchers[i].Name = EventName then
  begin
    _EventDispatchers[i].RemoveEvent(Event);
    Break;
  end;
  for i := 0 to _Components.Count - 1 do
  _Components[i].RemoveEvent(EventName, Event);
end;

procedure TG2Scene2DEntity.StripComponents(
  const AllowedComponents: array of CG2Scene2DComponent
);
  var IsAllowed: Boolean;
  var i, j: TG2IntS32;
  var c: TG2Scene2DComponent;
begin
  for i := _Components.Count - 1 downto 0 do
  begin
    IsAllowed := False;
    c := _Components[i];
    for j := 0 to High(AllowedComponents) do
    if (c is AllowedComponents[j]) then
    begin
      IsAllowed := True;
      Break;
    end;
    if not IsAllowed then
    begin
      c.Detach;
      c.Free;
    end;
  end;
end;

procedure TG2Scene2DEntity.Save(const dm: TG2DataManager);
  var i: TG2IntS32;
begin
  dm.WriteIntU16(GetCurrentVersion);
  dm.WriteBuffer(@_Transform, SizeOf(_Transform));
  dm.WriteStringA(_Name);
  dm.WriteStringA(_GUID);
  dm.WriteIntS32(_Tags.Count);
  for i := 0 to _Tags.Count - 1 do
  begin
    dm.WriteStringA(_Tags[i]);
  end;
  dm.WriteIntS32(_Children.Count);
  for i := 0 to _Children.Count - 1 do
  begin
    _Children[i].Save(dm);
  end;
  dm.WriteIntS32(_Components.Count);
  for i := 0 to _Components.Count - 1 do
  begin
    _Components[i].Save(dm);
  end;
end;

procedure TG2Scene2DEntity.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
  var i, j, tc, ec, cc: TG2IntS32;
  var e: TG2Scene2DEntity;
  var c: TG2Scene2DComponent;
  var CName: String;
begin
  Version := dm.ReadIntU16;
  dm.ReadBuffer(@_Transform, SizeOf(_Transform));
  _Name := dm.ReadStringA;
  _GUID := dm.ReadStringA;
  tc := dm.ReadIntS32;
  _Tags.Clear;
  for i := 0 to tc - 1 do
  begin
    _Tags.Add(dm.ReadStringA);
  end;
  ec := dm.ReadIntS32;
  for i := 0 to ec - 1 do
  begin
    e := TG2Scene2DEntity.Create(Scene);
    e.Parent := Self;
    e.Load(dm);
  end;
  cc := dm.ReadIntS32;
  for i := 0 to cc - 1 do
  begin
    CName := dm.ReadStringA;
    for j := 0 to High(TG2Scene2DComponent.ComponentList) do
    if TG2Scene2DComponent.ComponentList[j].ClassName = CName then
    begin
      c := TG2Scene2DComponent.ComponentList[j].Create(Scene);
      c.Attach(Self);
      c.Load(dm);
      Break;
    end;
  end;
end;
//TG2Scene2DEntity END

//TG2Scene2DJoint BEGIN
function TG2Scene2DJoint.GetCurrentVersion: TG2IntU16;
begin
  Result := $0001;
end;

procedure TG2Scene2DJoint.SetEnabled(const Value: Boolean);
begin
  _Enabled := Value;
end;

procedure TG2Scene2DJoint.SaveClassType(const dm: TG2DataManager);
begin
  dm.WriteStringA(ClassName);
end;

procedure TG2Scene2DJoint.SaveVersion(const dm: TG2DataManager);
begin
  dm.WriteIntU16(GetCurrentVersion);
end;

function TG2Scene2DJoint.LoadVersion(const dm: TG2DataManager): TG2IntU16;
begin
  Result := dm.ReadIntU16;
end;

class constructor TG2Scene2DJoint.ClassCreate;
begin
  SetLength(JointList, Length(JointList) + 1);
  JointList[High(JointList)] := CG2Scene2DJoint(ClassType);
end;

class function TG2Scene2DJoint.LoadClass(const dm: TG2DataManager; const OwnerScene: TG2Scene2D): TG2Scene2DJoint;
  var cn: String;
  var i: TG2IntS32;
begin
  cn := dm.ReadStringA;
  for i := 0 to High(JointList) do
  if JointList[i].ClassName = cn then
  begin
    Result := JointList[i].Create(OwnerScene);
    Result.Load(dm);
    Exit;
  end;
  Result := nil;
end;

constructor TG2Scene2DJoint.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create;
  _Scene := OwnerScene;
  _UserData := nil;
  _Joint := nil;
  _Scene.JointAdd(Self);
end;

destructor TG2Scene2DJoint.Destroy;
begin
  Enabled := False;
  if _Joint <> nil then
  _Scene.PhysWorld.destroy_joint(_Joint);
  _Scene.JointRemove(Self);
  inherited Destroy;
end;

{$Hints off}
procedure TG2Scene2DJoint.Save(const dm: TG2DataManager);
begin

end;
{$Hints on}

{$Hints off}
procedure TG2Scene2DJoint.Load(const dm: TG2DataManager);
begin

end;
{$Hints on}
//TG2Scene2DJoint END

//TG2Scene2DDistanceJoint BEIGN
function TG2Scene2DDistanceJoint.Valid: Boolean;
begin
  Result := (
    (_RigidBodyA <> nil)
    and (_RigidBodyB <> nil)
  );
end;

procedure TG2Scene2DDistanceJoint.SetEnabled(const Value: Boolean);
  var def: tb2_distance_joint_def;
begin
  if _Enabled = Value then Exit;
  _Enabled := Value;
  if _Enabled then
  begin
    if not Valid then
    begin
      _Enabled := False;
      Exit;
    end;
    def := b2_distance_joint_def;
    def.frequency_hz := 0;
    def.damping_ratio := 0;
    def.body_a := _RigidBodyA.PhysBody;
    def.body_b := _RigidBodyB.PhysBody;
    def.local_anchor_a := _AnchorA;
    def.local_anchor_b := _AnchorB;
    if _Distance < 0 then
    def.len := (def.body_a^.get_world_point(def.local_anchor_a) - def.body_b^.get_world_point(def.local_anchor_b)).len
    else
    def.len := _Distance;
    _Joint := _Scene.PhysWorld.create_joint(def);
  end
  else
  begin
    _Scene.PhysWorld.destroy_joint(_Joint);
    _Joint := nil;
  end;
end;

class constructor TG2Scene2DDistanceJoint.CreateClass;
begin
  SetLength(JointList, Length(JointList) + 1);
  JointList[High(JointList)] := CG2Scene2DJoint(ClassType);
end;

constructor TG2Scene2DDistanceJoint.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create(OwnerScene);
  _Enabled := False;
  _RigidBodyA := nil;
  _RigidBodyB := nil;
  _AnchorA.SetZero;
  _AnchorB.SetZero;
  _Distance := -1;
end;

destructor TG2Scene2DDistanceJoint.Destroy;
begin
  inherited Destroy;
end;

procedure TG2Scene2DDistanceJoint.Save(const dm: TG2DataManager);
begin
  SaveClassType(dm);
  SaveVersion(dm);
  if _RigidBodyA = nil then
  begin
    dm.WriteIntS32(0);
  end
  else
  begin
    dm.WriteStringA(_RigidBodyA.Owner.GUID);
  end;
  if _RigidBodyB = nil then
  begin
    dm.WriteIntS32(0);
  end
  else
  begin
    dm.WriteStringA(_RigidBodyB.Owner.GUID);
  end;
  dm.WriteBuffer(@_AnchorA, SizeOf(_AnchorA));
  dm.WriteBuffer(@_AnchorB, SizeOf(_AnchorB));
  dm.WriteFloat(_Distance);
  dm.WriteBool(_Enabled);
end;

procedure TG2Scene2DDistanceJoint.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
  var GUID: String;
  var e: TG2Scene2DEntity;
begin
  Version := LoadVersion(dm);
  GUID := dm.ReadStringA;
  e := _Scene.FindEntity(GUID);
  if e <> nil then
  _RigidBodyA := TG2Scene2DComponentRigidBody(e.ComponentOfType[TG2Scene2DComponentRigidBody])
  else
  _RigidBodyA := nil;
  GUID := dm.ReadStringA;
  e := _Scene.FindEntity(GUID);
  if e <> nil then
  _RigidBodyB := TG2Scene2DComponentRigidBody(e.ComponentOfType[TG2Scene2DComponentRigidBody])
  else
  _RigidBodyB := nil;
  dm.ReadBuffer(@_AnchorA, SizeOf(_AnchorA));
  dm.ReadBuffer(@_AnchorB, SizeOf(_AnchorB));
  _Distance := dm.ReadFloat;
  Enabled := dm.ReadBool;
end;
//TG2Scene2DDistanceJoint END

//TG2Scene2DRevoluteJoint BEGIN
function TG2Scene2DRevoluteJoint.Valid: Boolean;
begin
  Result := (
    (_RigidBodyA <> nil)
    and (_RigidBodyB <> nil)
  );
end;

procedure TG2Scene2DRevoluteJoint.SetEnableLimits(const Value: Boolean);
begin
  if _EnableLimits = Value then Exit;
  _EnableLimits := Value;
  if _Enabled then
  begin
    pb2_revolute_joint(_Joint)^.enable_limit(_EnableLimits);
  end;
end;

procedure TG2Scene2DRevoluteJoint.SetLimitMax(const Value: TG2Float);
begin
  if _LimitMax = Value then Exit;
  _LimitMax := Value;
  if _Enabled then
  begin
    pb2_revolute_joint(_Joint)^.set_limits(_LimitMin, _LimitMax);
  end;
end;

procedure TG2Scene2DRevoluteJoint.SetLimitMin(const Value: TG2Float);
begin
  if _LimitMin = Value then Exit;
  _LimitMin := Value;
  if _Enabled then
  begin
    pb2_revolute_joint(_Joint)^.set_limits(_LimitMin, _LimitMax);
  end;
end;

function TG2Scene2DRevoluteJoint.GetAnchor: TG2Vec2;
begin
  if Valid then Result := (_RigidBodyA.Owner.Transform.p + _OffsetA + _RigidBodyB.Owner.Transform.p + _OffsetB) * 0.5
  else Result := _Anchor;
end;

procedure TG2Scene2DRevoluteJoint.SetAnchor(const Value: TG2Vec2);
begin
  _Anchor := Value;
  if Valid then
  begin
    _OffsetA := _Anchor - _RigidBodyA.Owner.Transform.p;
    _OffsetB := _Anchor - _RigidBodyB.Owner.Transform.p;
  end;
end;

function TG2Scene2DRevoluteJoint.GetCurrentVersion: TG2IntU16;
begin
  Result := $0002;
end;

procedure TG2Scene2DRevoluteJoint.SetEnabled(const Value: Boolean);
  var def: tb2_revolute_joint_def;
begin
  if _Enabled = Value then Exit;
  _Enabled := Value;
  if _Enabled then
  begin
    if not Valid then
    begin
      _Enabled := False;
      Exit;
    end;
    def := b2_revolute_joint_def;
    def.initialize(
      _RigidBodyA.PhysBody,
      _RigidBodyB.PhysBody,
      Anchor
    );
    def.enable_limit := _EnableLimits;
    def.lower_angle := _LimitMin;
    def.upper_angle := _LimitMax;
    _Joint := _Scene.PhysWorld.create_joint(def);
  end
  else
  begin
    _Scene.PhysWorld.destroy_joint(_Joint);
    _Joint := nil;
  end;
end;

class constructor TG2Scene2DRevoluteJoint.CreateClass;
begin
  SetLength(JointList, Length(JointList) + 1);
  JointList[High(JointList)] := CG2Scene2DJoint(ClassType);
end;

constructor TG2Scene2DRevoluteJoint.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create(OwnerScene);
  _Enabled := False;
  _RigidBodyA := nil;
  _RigidBodyB := nil;
  _Anchor.SetZero;
  _EnableLimits := False;
  _LimitMin := 0;
  _LimitMax := 0;
end;

destructor TG2Scene2DRevoluteJoint.Destroy;
begin
  inherited Destroy;
end;

procedure TG2Scene2DRevoluteJoint.Save(const dm: TG2DataManager);
begin
  SaveClassType(dm);
  SaveVersion(dm);
  if _RigidBodyA = nil then
  begin
    dm.WriteIntS32(0);
  end
  else
  begin
    dm.WriteStringA(_RigidBodyA.Owner.GUID);
  end;
  if _RigidBodyB = nil then
  begin
    dm.WriteIntS32(0);
  end
  else
  begin
    dm.WriteStringA(_RigidBodyB.Owner.GUID);
  end;
  dm.WriteVec2(Anchor);
  //Version $0002 BEGIN
  dm.WriteBool(_EnableLimits);
  dm.WriteFloat(_LimitMin);
  dm.WriteFloat(_LimitMax);
  //Vertsion $0002 END
  dm.WriteBool(_Enabled);
end;

procedure TG2Scene2DRevoluteJoint.Load(const dm: TG2DataManager);
  var Version: TG2IntU16;
  var GUID: String;
  var e: TG2Scene2DEntity;
begin
  Version := LoadVersion(dm);
  GUID := dm.ReadStringA;
  e := _Scene.FindEntity(GUID);
  if e <> nil then
  _RigidBodyA := TG2Scene2DComponentRigidBody(e.ComponentOfType[TG2Scene2DComponentRigidBody])
  else
  _RigidBodyA := nil;
  GUID := dm.ReadStringA;
  e := _Scene.FindEntity(GUID);
  if e <> nil then
  _RigidBodyB := TG2Scene2DComponentRigidBody(e.ComponentOfType[TG2Scene2DComponentRigidBody])
  else
  _RigidBodyB := nil;
  _Anchor := dm.ReadVec2;
  SetAnchor(_Anchor);
  if Version >= $0002 then
  begin
    _EnableLimits := dm.ReadBool;
    _LimitMin := dm.ReadFloat;
    _LimitMax := dm.ReadFloat;
  end;
  Enabled := dm.ReadBool;
end;
//TG2Scene2DRevoluteJoint END

//TG2Scene2DPullJoint BEGIN
function TG2Scene2DPullJoint.Valid: Boolean;
begin
  Result := _RigidBody <> nil;
end;

procedure TG2Scene2DPullJoint.SetRigidBody(const Value: TG2Scene2DComponentRigidBody);
begin
  if Value = _RigidBody then Exit;
  _RigidBody := Value;
  if Enabled and Valid then
  begin
    Enabled := False;
    Enabled := True;
  end;
end;

procedure TG2Scene2DPullJoint.SetTarget(const Value: TG2Vec2);
begin
  _Target := Value;
  if Enabled then
  begin
    pb2_mouse_joint(_Joint)^.set_target(_Target);
  end;
end;

procedure TG2Scene2DPullJoint.SetMaxForce(const Value: TG2Float);
begin
  _MaxForce := Value;
  if Enabled then
  begin
    pb2_mouse_joint(_Joint)^.set_max_force(_MaxForce);
  end;
end;

function TG2Scene2DPullJoint.GetAnchor: TG2Vec2;
begin
  if Enabled then
  begin
    Result := pb2_mouse_joint(_Joint)^.get_anchor_a;
  end
  else
  begin
    Result := G2Vec2;
  end;
end;

procedure TG2Scene2DPullJoint.SetEnabled(const Value: Boolean);
  var def: tb2_mouse_joint_def;
begin
  if _Enabled = Value then Exit;
  _Enabled := Value;
  if _Enabled then
  begin
    if not Valid then
    begin
      _Enabled := False;
      Exit;
    end;
    def := b2_mouse_joint_def;
    def.body_a := _Scene.FixedBody;
    def.body_b := _RigidBody.PhysBody;
    def.target := _Target;
    def.max_force := _MaxForce;
    _Joint := _Scene.PhysWorld.create_joint(def);
    _RigidBody.PhysBody^.set_awake(True);
  end
  else
  begin
    _Scene.PhysWorld.destroy_joint(_Joint);
    _Joint := nil;
  end;
end;

constructor TG2Scene2DPullJoint.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create(OwnerScene);
  _RigidBody := nil;
  _Target := G2Vec2;
  _MaxForce := 1000;
end;

destructor TG2Scene2DPullJoint.Destroy;
begin
  inherited Destroy;
end;
//TG2Scene2DPullJoint END

//TG2Scene2DRenderHook BEGIN
procedure TG2Scene2DRenderHook.SetLayer(const Value: TG2IntS32);
begin
  if _Layer = Value then Exit;
  _Layer := Value;
  _Scene.SortRenderHooks;
end;

constructor TG2Scene2DRenderHook.Create(const OwnerScene: TG2Scene2D;
  const HookProc: TG2Scene2DRenderHookProc; const RenderLayer: TG2IntS32);
begin
  inherited Create;
  _Scene := OwnerScene;
  _Hook := HookProc;
  _Layer := RenderLayer;
  _Scene.SortRenderHooks;
end;

destructor TG2Scene2DRenderHook.Destroy;
begin
  inherited Destroy;
end;
//TG2Scene2DRenderHook END

//TG2Scene2D BEGIN
procedure TG2Scene2D.TPhysDraw.draw_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color);
  var i, i1: integer;
  var c: TG2Color;
  var v: pb2_vec2_arr absolute vertices;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $ff));
  for i := 0 to vertex_count - 1 do
  begin
    i1 := (i + 1) mod vertex_count;
    Disp.PrimLine(v^[i].x, v^[i].y, v^[i1].x, v^[i1].y, c);
  end;
end;

procedure TG2Scene2D.TPhysDraw.draw_solid_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color);
  var i, i1, i2: integer;
  var c: TG2Color;
  var v: pb2_vec2_arr absolute vertices;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $80));
  for i := 0 to vertex_count - 2 do
  begin
    i1 := (i + 1) mod vertex_count;
    i2 := (i + 2) mod vertex_count;
    Disp.PrimTriCol(
      v^[0].x, v^[0].y,
      v^[i1].x, v^[i1].y,
      v^[i2].x, v^[i2].y,
      c, c, c
    );
  end;
  draw_polygon(vertices, vertex_count, color);
end;

procedure TG2Scene2D.TPhysDraw.draw_circle(const center: tb2_vec2; const radius: tb2_float32; const color: tb2_color);
  var c: TG2Color;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $ff));
  Disp.PrimCircleHollow(center.x, center.y, radius, c, 32);
end;

procedure TG2Scene2D.TPhysDraw.draw_solid_circle(const center: tb2_vec2; const radius: tb2_float32; const axis: tb2_vec2; const color: tb2_color);
  var c: TG2Color;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $80));
  Disp.PrimCircleCol(center.x, center.y, radius, c, c, 32);
  Disp.PrimLine(center.x, center.y, center.x + axis.x * radius, center.y + axis.y * radius, $ff000000);
  c.a := $ff;
  Disp.PrimCircleHollow(center.x, center.y, radius, c, 32);
end;

procedure TG2Scene2D.TPhysDraw.draw_segment(const p0, p1: tb2_vec2; const color: tb2_color);
  var c: TG2Color;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $ff));
  Disp.PrimLine(p0.x, p0.y, p1.x, p1.y, c);
end;

procedure TG2Scene2D.TPhysDraw.draw_transform(const xf: tb2_transform);
  var v0, v1: TG2Vec2;
begin
  v0.SetValue(xf.p.x, xf.p.y);
  v1.SetValue(xf.p.x + xf.q.get_x_axis.x, xf.p.y + xf.q.get_x_axis.y);
  Disp.PrimLine(v0, v1, $ffff0000);
  v1.SetValue(xf.p.x + xf.q.get_y_axis.x, xf.p.y + xf.q.get_y_axis.y);
  Disp.PrimLine(v0, v1, $ff00ff00);
end;

procedure TG2Scene2D.TPhysContactListener.begin_contact(const contact: pb2_contact);
  var Obj0, Obj1: TObject;
  var Shape0, Shape1: TG2Scene2DComponentCollisionShape;
  var Character0, Character1: TG2Scene2DComponentCharacter;
  var Entity0, Entity1: TG2Scene2DEntity;
begin
  Obj0 := TObject(contact^.get_fixture_a^.get_user_data);
  Obj1 := TObject(contact^.get_fixture_b^.get_user_data);
  if (Obj0 <> nil) and (Obj1 <> nil) then
  begin
    if Obj0 is TG2Scene2DComponentCollisionShape then
    begin
      Shape0 := TG2Scene2DComponentCollisionShape(Obj0);
      Character0 := nil;
      Entity0 := Shape0.Owner;
    end
    else if Obj0 is TG2Scene2DComponentCharacter then
    begin
      Shape0 := nil;
      Character0 := TG2Scene2DComponentCharacter(Obj0);
      Entity0 := Character0.Owner;
    end;
    if Obj1 is TG2Scene2DComponentCollisionShape then
    begin
      Shape1 := TG2Scene2DComponentCollisionShape(Obj1);
      Character1 := nil;
      Entity1 := Shape1.Owner;
    end
    else if Obj1 is TG2Scene2DComponentCharacter then
    begin
      Shape1 := nil;
      Character1 := TG2Scene2DComponentCharacter(Obj1);
      Entity1 := Character1.Owner;
    end;
    if not contact^.get_fixture_b^.is_sensor then
    begin
      if Assigned(Shape0) then Shape0.OnBeginContact(Entity1, Shape1, contact)
      else if Assigned(Character0) then Character0.OnBeginContact(Entity1, Shape1, contact^.get_fixture_a, contact);
    end;
    if not contact^.get_fixture_a^.is_sensor then
    begin
      if Assigned(Shape1) then Shape1.OnBeginContact(Entity0, Shape0, contact)
      else if Assigned(Character1) then Character1.OnBeginContact(Entity0, Shape0, contact^.get_fixture_b, contact);
    end;
  end;
end;

procedure TG2Scene2D.TPhysContactListener.end_contact(const contact: pb2_contact);
  var Obj0, Obj1: TObject;
  var Shape0, Shape1: TG2Scene2DComponentCollisionShape;
  var Character0, Character1: TG2Scene2DComponentCharacter;
  var Entity0, Entity1: TG2Scene2DEntity;
begin
  Obj0 := TObject(contact^.get_fixture_a^.get_user_data);
  Obj1 := TObject(contact^.get_fixture_b^.get_user_data);
  if (Obj0 <> nil) and (Obj1 <> nil) then
  begin
    if Obj0 is TG2Scene2DComponentCollisionShape then
    begin
      Shape0 := TG2Scene2DComponentCollisionShape(Obj0);
      Character0 := nil;
      Entity0 := Shape0.Owner;
    end
    else if Obj0 is TG2Scene2DComponentCharacter then
    begin
      Shape0 := nil;
      Character0 := TG2Scene2DComponentCharacter(Obj0);
      Entity0 := Character0.Owner;
    end;
    if Obj1 is TG2Scene2DComponentCollisionShape then
    begin
      Shape1 := TG2Scene2DComponentCollisionShape(Obj1);
      Character1 := nil;
      Entity1 := Shape1.Owner;
    end
    else if Obj1 is TG2Scene2DComponentCharacter then
    begin
      Shape1 := nil;
      Character1 := TG2Scene2DComponentCharacter(Obj1);
      Entity1 := Character1.Owner;
    end;
    if not contact^.get_fixture_b^.is_sensor then
    begin
      if Assigned(Shape0) then Shape0.OnEndContact(Entity1, Shape1, contact)
      else if Assigned(Character0) then Character0.OnEndContact(Entity1, Shape1, contact^.get_fixture_a, contact);
    end;
    if not contact^.get_fixture_a^.is_sensor then
    begin
      if Assigned(Shape1) then Shape1.OnEndContact(Entity0, Shape0, contact)
      else if Assigned(Character1) then Character1.OnEndContact(Entity0, Shape0, contact^.get_fixture_b, contact);
    end;
  end;
end;

{$Hints off}
procedure TG2Scene2D.TPhysContactListener.pre_solve(const contact: pb2_contact; const old_manifold: pb2_manifold);
  var Obj0, Obj1: TObject;
  var Shape0, Shape1: TG2Scene2DComponentCollisionShape;
  var Character0, Character1: TG2Scene2DComponentCharacter;
  var Entity0, Entity1: TG2Scene2DEntity;
begin
  Obj0 := TObject(contact^.get_fixture_a^.get_user_data);
  Obj1 := TObject(contact^.get_fixture_b^.get_user_data);
  if (Obj0 <> nil) and (Obj1 <> nil) then
  begin
    if Obj0 is TG2Scene2DComponentCollisionShape then
    begin
      Shape0 := TG2Scene2DComponentCollisionShape(Obj0);
      Character0 := nil;
      Entity0 := Shape0.Owner;
    end
    else if Obj0 is TG2Scene2DComponentCharacter then
    begin
      Shape0 := nil;
      Character0 := TG2Scene2DComponentCharacter(Obj0);
      Entity0 := Character0.Owner;
    end;
    if Obj1 is TG2Scene2DComponentCollisionShape then
    begin
      Shape1 := TG2Scene2DComponentCollisionShape(Obj1);
      Character1 := nil;
      Entity1 := Shape1.Owner;
    end
    else if Obj1 is TG2Scene2DComponentCharacter then
    begin
      Shape1 := nil;
      Character1 := TG2Scene2DComponentCharacter(Obj1);
      Entity1 := Character1.Owner;
    end;
    if Assigned(Shape0) then Shape0.OnBeforeContactSolve(Entity1, Shape1, contact)
    else if Assigned(Character0) then Character0.OnBeforeContactSolve(Entity1, Shape1, contact^.get_fixture_a, contact);
    if Assigned(Shape1) then Shape1.OnBeforeContactSolve(Entity0, Shape0, contact)
    else if Assigned(Character1) then Character1.OnBeforeContactSolve(Entity0, Shape0, contact^.get_fixture_b, contact);
  end;
end;
{$Hints on}

{$Hints off}
procedure TG2Scene2D.TPhysContactListener.post_solve(const contact: pb2_contact; const impulse: pb2_contact_impulse);
  var Obj0, Obj1: TObject;
  var Shape0, Shape1: TG2Scene2DComponentCollisionShape;
  var Character0, Character1: TG2Scene2DComponentCharacter;
  var Entity0, Entity1: TG2Scene2DEntity;
begin
  Obj0 := TObject(contact^.get_fixture_a^.get_user_data);
  Obj1 := TObject(contact^.get_fixture_b^.get_user_data);
  if (Obj0 <> nil) and (Obj1 <> nil) then
  begin
    if Obj0 is TG2Scene2DComponentCollisionShape then
    begin
      Shape0 := TG2Scene2DComponentCollisionShape(Obj0);
      Character0 := nil;
      Entity0 := Shape0.Owner;
    end
    else if Obj0 is TG2Scene2DComponentCharacter then
    begin
      Shape0 := nil;
      Character0 := TG2Scene2DComponentCharacter(Obj0);
      Entity0 := Character0.Owner;
    end;
    if Obj1 is TG2Scene2DComponentCollisionShape then
    begin
      Shape1 := TG2Scene2DComponentCollisionShape(Obj1);
      Character1 := nil;
      Entity1 := Shape1.Owner;
    end
    else if Obj1 is TG2Scene2DComponentCharacter then
    begin
      Shape1 := nil;
      Character1 := TG2Scene2DComponentCharacter(Obj1);
      Entity1 := Character1.Owner;
    end;
    if Assigned(Shape0) then Shape0.OnAfterContactSolve(Entity1, Shape1, contact)
    else if Assigned(Character0) then Character0.OnAfterContactSolve(Entity1, Shape1, contact^.get_fixture_a, contact);
    if Assigned(Shape1) then Shape1.OnAfterContactSolve(Entity0, Shape0, contact)
    else if Assigned(Character1) then Character1.OnAfterContactSolve(Entity0, Shape0, contact^.get_fixture_b, contact);
  end;
end;
{$Hints on}

function TG2Scene2D.ProcessQuery(const fixture: pb2_fixture): Boolean;
  var rb: TG2Scene2DComponentRigidBody;
begin
  Result := True;
  if fixture^.get_body^.get_user_data = nil then Exit;
  if not fixture^.test_point(_QueryPoint) then Exit;
  rb := TG2Scene2DComponentRigidBody(fixture^.get_body^.get_user_data);
  _QueryTarget^.Add(rb.Owner);
end;

procedure TG2Scene2D.Update;
begin
  if _Simulate then
  _PhysWorld.step(g2.DeltaTimeSec, 6, 4);
end;

function TG2Scene2D.GetEntity(const Index: TG2IntS32): TG2Scene2DEntity;
begin
  Result := _Entities[Index];
end;

function TG2Scene2D.GetEntityCount: TG2IntS32;
begin
  Result := _Entities.Count;
end;

function TG2Scene2D.GetJoint(const Index: TG2IntS32): TG2Scene2DJoint;
begin
  Result := _Joints[Index];
end;

function TG2Scene2D.GetJointCount: TG2IntS32;
begin
  Result := _Joints.Count;
end;

procedure TG2Scene2D.EntityAdd(const Entity: TG2Scene2DEntity);
begin
  _Entities.Add(Entity);
end;

procedure TG2Scene2D.EntityRemove(const Entity: TG2Scene2DEntity);
begin
  _Entities.Remove(Entity);
end;

procedure TG2Scene2D.JointAdd(const Joint: TG2Scene2DJoint);
begin
  _Joints.Add(Joint);
end;

procedure TG2Scene2D.JointRemove(const Joint: TG2Scene2DJoint);
begin
  _Joints.Remove(Joint);
end;

procedure TG2Scene2D.SortRenderHooks;
begin
  _SortRenderHooks := True;
end;

function TG2Scene2D.CompRenderHooks(const Item0, Item1: TG2Scene2DRenderHook): TG2IntS32;
begin
  Result := Item0.Layer - Item1.Layer;
  if Result = 0 then Result := PtrInt(Item0) - PtrInt(Item1);
end;

function TG2Scene2D.GetGravity: TG2Vec2;
begin
  Result := _Gravity;
end;

procedure TG2Scene2D.SetGravity(const Value: TG2Vec2);
begin
  _Gravity := Value;
  _PhysWorld.set_gravity(_Gravity);
end;

procedure TG2Scene2D.SetGridSizeX(const Value: TG2Float);
begin
  _GridSizeX := Value;
  _GridSizeXRcp := 1 / _GridSizeX;
end;

procedure TG2Scene2D.SetGridSizeY(const Value: TG2Float);
begin
  _GridSizeY := Value;
  _GridSizeYRcp := 1 / _GridSizeY;
end;

procedure TG2Scene2D.VerifyEntityName(const Entity: TG2Scene2DEntity);
  var NameBase, EntityName, str: String;
  var NameIndex, n, i: Integer;
begin
  if FindEntityByName(Entity.Name) = nil then Exit;
  if Entity.Name <> '' then
  NameBase := Entity.Name
  else
  NameBase := 'Entity';
  n := Length(NameBase);
  while (n > 0) and (StrToIntDef(NameBase[n], 0) = StrToIntDef(NameBase[n], 1)) do Dec(n);
  if n < Length(NameBase) then
  begin
    str := '';
    for i := n + 1 to Length(NameBase) do
    str += NameBase[i];
    NameIndex := StrToIntDef(str, 0) + 1;
    Delete(NameBase, n + 1, Length(NameBase) - n);
  end
  else
  NameIndex := 0;
  EntityName := NameBase;
  while FindEntityByName(EntityName) <> nil do
  begin
    Inc(NameIndex);
    EntityName := NameBase + IntToStr(NameIndex);
  end;
  Entity.Name := EntityName;
end;

constructor TG2Scene2D.Create;
  var FixedBodyDef: tb2_body_def;
begin
  _Entities.Clear;
  _Joints.Clear;
  _RenderHooks.Clear;
  _SortRenderHooks := False;
  _Gravity.SetValue(0, 10);
  _PhysDraw := TPhysDraw.create;
  _PhysDraw.Disp := nil;
  _PhysDraw.draw_flags := [b2_df_center_of_mass, b2_df_joint, b2_df_shape];
  _ContactListener := TPhysContactListener.Create;
  _PhysWorld.create(_Gravity);
  _PhysWorld.set_debug_draw(_PhysDraw);
  _PhysWorld.set_allow_sleeping(true);
  _PhysWorld.set_continuous_physics(true);
  _PhysWorld.set_warm_starting(true);
  _PhysWorld.set_contact_listener(_ContactListener);
  FixedBodyDef := b2_body_def;
  FixedBodyDef.active := true;
  _FixedBody := _PhysWorld.create_body(FixedBodyDef);
  _Simulate := False;
  _GridEnable := False;
  _GridSizeX := 0.5;
  _GridSizeY := 0.5;
  _GridSizeXRcp := 1 / _GridSizeX;
  _GridSizeYRcp := 1 / _GridSizeY;
  _GridOffsetX := 0;
  _GridOffsetY := 0;
  g2.CallbackUpdateAdd(@Update);
  inherited Create;
end;

destructor TG2Scene2D.Destroy;
  var n: TG2Scene2DEntity;
begin
  g2.CallbackUpdateRemove(@Update);
  while _Entities.Count > 0 do
  begin
    n := _Entities.Pop;
    n.Free;
  end;
  _ContactListener.Free;
  _PhysDraw.Free;
  _PhysWorld.destroy;
  inherited Destroy;
end;

procedure TG2Scene2D.Clear;
  var n: TG2Scene2DEntity;
begin
  while _Entities.Count > 0 do
  begin
    n := _Entities.Pop;
    n.Free;
  end;
  _PhysWorld.clear;
end;

procedure TG2Scene2D.DebugDraw(const Display: TG2Display2D);
  var i: Integer;
begin
  for i := 0 to _Entities.Count - 1 do
  _Entities[i].DebugDraw(Display);
  _PhysDraw.Disp := Display;
  _PhysWorld.draw_debug_data;
end;

procedure TG2Scene2D.Render(const Display: TG2Display2D);
  var i: TG2IntS32;
begin
  if _SortRenderHooks then
  begin
    _RenderHooks.Sort(@CompRenderHooks);
    _SortRenderHooks := False;
  end;
  for i := 0 to _RenderHooks.Count - 1 do
  _RenderHooks[i].Hook(Display);
  for i := 0 to _Entities.Count - 1 do
  if _Entities[i].Enabled then
  begin
    _Entities[i].Render(Display);
  end;
end;

procedure TG2Scene2D.EnablePhysics;
  var i: TG2IntS32;
  var rb: TG2Scene2DComponentRigidBody;
begin
  for i := 0 to _Entities.Count - 1 do
  begin
    rb := TG2Scene2DComponentRigidBody(_Entities[i].ComponentOfType[TG2Scene2DComponentRigidBody]);
    if rb <> nil then
    rb.Enabled := True;
  end;
  for i := 0 to _Joints.Count - 1 do
  _Joints[i].Enabled := True;
end;

procedure TG2Scene2D.DisablePhysics;
  var i: TG2IntS32;
  var rb: TG2Scene2DComponentRigidBody;
begin
  for i := 0 to _Entities.Count - 1 do
  begin
    rb := TG2Scene2DComponentRigidBody(_Entities[i].ComponentOfType[TG2Scene2DComponentRigidBody]);
    if rb <> nil then
    rb.Enabled := False;
  end;
  for i := 0 to _Joints.Count - 1 do
  _Joints[i].Enabled := False;
end;

function TG2Scene2D.RenderHookAdd(
  const HookProc: TG2Scene2DRenderHookProc;
  const Layer: TG2IntS32
): TG2Scene2DRenderHook;
begin
  Result := TG2Scene2DRenderHook.Create(Self, HookProc, Layer);
  _RenderHooks.Add(Result);
end;

procedure TG2Scene2D.RenderHookRemove(var Hook: TG2Scene2DRenderHook);
begin
  _RenderHooks.Remove(Hook);
  Hook.Free;
  Hook := nil;
end;

function TG2Scene2D.FindEntity(const GUID: String): TG2Scene2DEntity;
  var i: TG2IntS32;
begin
  for i := 0 to _Entities.Count - 1 do
  if _Entities[i].GUID = GUID then
  Exit(_Entities[i]);
  Result := nil;
end;

function TG2Scene2D.FindEntityByName(const EntityName: String): TG2Scene2DEntity;
  var i: TG2IntS32;
begin
  for i := 0 to _Entities.Count - 1 do
  if _Entities[i].Name = EntityName then
  Exit(_Entities[i]);
  Result := nil;
end;

procedure TG2Scene2D.QueryPoint(const p: TG2Vec2; var EntityList: TG2Scene2DEntityList);
  var aabb: tb2_aabb;
begin
  aabb.lower_bound := p;
  aabb.upper_bound := p;
  _QueryPoint := p;
  EntityList.Clear;
  _QueryTarget := @EntityList;
  _PhysWorld.query_aabb(@ProcessQuery, aabb);
end;

function TG2Scene2D.AdjustToGrid(const v: TG2Vec2): TG2Vec2;
begin
  if not _GridEnable then Exit(v);
  Result.x := Round((v.x - _GridOffsetX) * _GridSizeXRcp) * _GridSizeX + _GridOffsetX;
  Result.y := Round((v.y - _GridOffsetY) * _GridSizeYRcp) * _GridSizeY + _GridOffsetY;
end;

function TG2Scene2D.GridPos(const v: TG2Vec2): TPoint;
begin
  Result.x := Round((v.x - _GridOffsetX) * _GridSizeXRcp);
  Result.y := Round((v.y - _GridOffsetY) * _GridSizeYRcp);
end;

function TG2Scene2D.CreatePrefab(
  const dm: TG2DataManager;
  const Transform: TG2Transform2;
  const EntityClass: CG2Scene2DEntity
): TG2Scene2DEntity;
  procedure ProcessEntity(const Entity: TG2Scene2DEntity);
    var i: Integer;
  begin
    Entity.NewGUID;
    VerifyEntityName(Entity);
    for i := 0 to Entity.ChildCount - 1 do
    ProcessEntity(Entity.Children[i]);
  end;
  var Def: array[0..3] of AnsiChar;
  var i, n: Integer;
  var CreateClass: CG2Scene2DEntity;
begin
  if Assigned(EntityClass) then CreateClass := EntityClass else CreateClass := TG2Scene2DEntity;
  dm.ReadBuffer(@Def, 4);
  if Def = 'PF2D' then
  begin
    Result := CreateClass.Create(Self);
    Result.Load(dm);
    n := dm.ReadIntS32;
    for i := 0 to n - 1 do
    begin
      TG2Scene2DJoint.LoadClass(dm, Self);
    end;
    ProcessEntity(Result);
    Result.Transform := Transform;
  end
  else
  begin
    Result := nil;
  end;
end;

function TG2Scene2D.CreatePrefab(
  const PrefabName: String;
  const Transform: TG2Transform2;
  const EntityClass: CG2Scene2DEntity
): TG2Scene2DEntity;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(PrefabName, dmAsset);
  try
    Result := CreatePrefab(dm, Transform, EntityClass);
  finally
    dm.Free;
  end;
end;

procedure TG2Scene2D.Save(const dm: TG2DataManager);
  const Header: array[0..3] of AnsiChar = 'G2S2';
  var i, n: TG2IntS32;
begin
  dm.WriteBuffer(@Header, SizeOf(Header));
  dm.WriteIntU16(CurrentVersion);
  dm.WriteVec2(_Gravity);
  dm.WriteBool(_GridEnable);
  dm.WriteFloat(_GridSizeX);
  dm.WriteFloat(_GridSizeY);
  dm.WriteFloat(_GridOffsetX);
  dm.WriteFloat(_GridOffsetY);
  n := 0;
  for i := 0 to EntityCount - 1 do
  if Entities[i].Parent = nil then Inc(n);
  dm.WriteIntS32(n);
  for i := 0 to EntityCount - 1 do
  if Entities[i].Parent = nil then
  Entities[i].Save(dm);
  dm.WriteIntS32(JointCount);
  for i := 0 to JointCount - 1 do
  Joints[i].Save(dm);
end;

procedure TG2Scene2D.Load(const dm: TG2DataManager);
  var Header: array[0..3] of AnsiChar;
  var {%H-}Version: TG2IntU16;
  var i, j, n: TG2IntS32;
  var CName: String;
  var Joint: TG2Scene2DJoint;
begin
  {$Hints off}
  dm.ReadBuffer(@Header, SizeOf(Header));
  {$Hints on}
  if Header <> 'G2S2' then Exit;
  Version := dm.ReadIntU16;
  _Gravity := dm.ReadVec2;
  _PhysWorld.set_gravity(_Gravity);
  _GridEnable := dm.ReadBool;
  GridSizeX := dm.ReadFloat;
  GridSizeY := dm.ReadFloat;
  _GridOffsetX := dm.ReadFloat;
  _GridOffsetY := dm.ReadFloat;
  {$Hints off}
  n := dm.ReadIntS32;
  {$Hints on}
  for i := 0 to n - 1 do
  TG2Scene2DEntity.Create(Self).Load(dm);
  n := dm.ReadIntS32;
  for i := 0 to n - 1 do
  begin
    CName := dm.ReadStringA;
    for j := 0 to High(TG2Scene2DJoint.JointList) do
    if CName = TG2Scene2DJoint.JointList[j].ClassName then
    begin
      Joint := TG2Scene2DJoint.JointList[j].Create(Self);
      Joint.Load(dm);
      Break;
    end;
  end;
end;

procedure TG2Scene2D.Load(const FileName: String);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName, dmAsset);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

//TG2Scene2D END

//TG2Scene2DComponentSprite BEGIN
procedure TG2Scene2DComponentSprite.SetLayer(const Value: TG2IntS32);
begin
  _Layer := Value;
  if _RenderHook <> nil then _RenderHook.Layer := _Layer;
end;

procedure TG2Scene2DComponentSprite.SetPicture(const Value: TG2Picture);
begin
  if _Picture <> Value then
  begin
    if Assigned(_Picture) then _Picture.RefDec;
    _Picture := Value;
    if Assigned(_Picture) then _Picture.RefInc;
  end;
end;

procedure TG2Scene2DComponentSprite.SetPosition(const Value: TG2Vec2);
begin
  _Transform.p := Value;
end;

function TG2Scene2DComponentSprite.GetPosition: TG2Vec2;
begin
  Result := _Transform.p;
end;

procedure TG2Scene2DComponentSprite.SetRotation(const Value: TG2Rotation2);
begin
  _Transform.r := Value;
end;

function TG2Scene2DComponentSprite.GetRotation: TG2Rotation2;
begin
  Result := _Transform.r;
end;

function TG2Scene2DComponentSprite.GetCurrentVersion: TG2IntU16;
begin
  Result := $0002;
end;

procedure TG2Scene2DComponentSprite.OnInitialize;
begin
  _RenderHook := nil;
  _Picture := nil;
  _Width := 1;
  _Height := 1;
  _Scale := 1;
  _FlipX := False;
  _FlipY := False;
  _Filter := tfLinear;
  _BlendMode := bmNormal;
  _Layer := 0;
  _Color := $ffffffff;
  _Visible := True;
  _Transform.SetIdentity;
end;

procedure TG2Scene2DComponentSprite.OnFinalize;
begin
  Picture := nil;
end;

procedure TG2Scene2DComponentSprite.OnAttach;
begin
  _RenderHook := Scene.RenderHookAdd(@OnRender, _Layer);
end;

procedure TG2Scene2DComponentSprite.OnDetach;
begin
  Scene.RenderHookRemove(_RenderHook);
end;

procedure TG2Scene2DComponentSprite.OnRender(const Display: TG2Display2D);
  var xf: TG2Transform2;
  var v: array[0..3] of TG2Vec2;
  var t: array[0..3] of TG2Vec2;
  var tx0, tx1, ty0, ty1: TG2Float;
  var i: Integer;
  var hw, hh: TG2Float;
begin
  if not _Visible
  or (_Picture = nil)
  or (_Owner = nil) then
  Exit;
  hw := _Width * _Scale * 0.5;
  hh := _Height * _Scale * 0.5;
  v[0] := G2Vec2(-hw, -hh);
  v[1] := G2Vec2(hw, -hh);
  v[2] := G2Vec2(-hw, hh);
  v[3] := G2Vec2(hw, hh);
  if not _FlipX then begin tx0 := _Picture.TexCoords.l; tx1 := _Picture.TexCoords.r; end
  else begin tx0 := _Picture.TexCoords.r; tx1 := _Picture.TexCoords.l; end;
  if not _FlipY then begin ty0 := _Picture.TexCoords.t; ty1 := _Picture.TexCoords.b; end
  else begin ty0 := _Picture.TexCoords.b; ty1 := _Picture.TexCoords.t; end;
  t[0] := G2Vec2(tx0, ty0);
  t[1] := G2Vec2(tx1, ty0);
  t[2] := G2Vec2(tx0, ty1);
  t[3] := G2Vec2(tx1, ty1);
  xf := _Owner.Transform;
  G2Transform2Mul(@xf, @_Transform, @xf);
  for i := 0 to High(v) do
  G2Vec2Transform2Mul(@v[i], @v[i], @xf);
  Display.PicQuad(
    v[0], v[1], v[2], v[3],
    t[0], t[1], t[2], t[3],
    _Color, _Picture.Texture, _BlendMode, _Filter
  );
end;

class constructor TG2Scene2DComponentSprite.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentSprite.GetName: String;
begin
  Result := 'Sprite';
end;

{$Hints off}
class function TG2Scene2DComponentSprite.CanAttach(
  const Node: TG2Scene2DEntity
): Boolean;
begin
  Result := True;
end;
{$Hints on}

procedure TG2Scene2DComponentSprite.Save(const dm: TG2DataManager);
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  if Assigned(_Picture)
  and (_Picture.IsShared) then
  begin
    dm.WriteStringA(_Picture.AssetName);
    dm.WriteBuffer(@_Picture.Texture.Usage, SizeOf(_Picture.Texture.Usage));
  end
  else
  begin
    dm.WriteIntS32(0);
  end;
  dm.WriteFloat(_Width);
  dm.WriteFloat(_Height);
  dm.WriteFloat(_Scale);
  dm.WriteBool(_FlipX);
  dm.WriteBool(_FlipY);
  //Version $0002 BEGIN
  dm.WriteColor(_Color);
  //Version $0002 END
  dm.WriteBuffer(@_Transform, SizeOf(_Transform));
  dm.WriteBuffer(@_Filter, SizeOf(_Filter));
  dm.WriteBuffer(@_BlendMode, SizeOf(_BlendMode));
  dm.WriteIntS32(_Layer);
end;

procedure TG2Scene2DComponentSprite.Load(const dm: TG2DataManager);
  var Version: TG2IntU16;
  var Usage: TG2TextureUsage;
  var TexFile: String;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  TexFile := dm.ReadStringA;
  if Length(TexFile) > 0 then
  begin
    dm.ReadBuffer(@Usage, SizeOf(Usage));
    Picture := TG2Picture.SharedAsset(TexFile, Usage);
  end;
  _Width := dm.ReadFloat;
  _Height := dm.ReadFloat;
  _Scale := dm.ReadFloat;
  _FlipX := dm.ReadBool;
  _FlipY := dm.ReadBool;
  if Version >= $0002 then
  begin
    _Color := dm.ReadColor;
  end;
  dm.ReadBuffer(@_Transform, SizeOf(_Transform));
  dm.ReadBuffer(@_Filter, SizeOf(_Filter));
  dm.ReadBuffer(@_BlendMode, SizeOf(_BlendMode));
  Layer := dm.ReadIntS32;
end;
//TG2Scene2DComponentSprite END

//TG2Scene2DComponentModel3D BEGIN
procedure TG2Scene2DComponentModel3D.SetMesh(const Value: TG2LegacyMesh);
  var MeshBounds: TG2AABox;
begin
  if Value = _Mesh then Exit;
  if _Mesh <> nil then
  begin
    _Inst.Free;
    if _Mesh.IsShared then _Mesh.RefDec;
  end;
  _Mesh := Value;
  if _Mesh <> nil then
  begin
    if _Mesh.IsShared then _Mesh.RefInc;
    _Inst := _Mesh.NewInst;
    MeshBounds := _Inst.AABox;
    _Scale := G2Max(G2Max(MeshBounds.SizeX, MeshBounds.SizeY), MeshBounds.SizeZ);
    if _Scale > G2EPS2 then _Scale := 1 / _Scale else _Scale := 1;
  end;
  _AnimName := '';
  _AnimIndex := -1;
end;

procedure TG2Scene2DComponentModel3D.SetLayer(const Value: TG2IntS32);
begin
  _Layer := Value;
  if _RenderHook <> nil then _RenderHook.Layer := _Layer;
end;

procedure TG2Scene2DComponentModel3D.SetAnimName(const Value: String);
begin
  if _AnimName = Value then Exit;
  _AnimName := Value;
  if _Inst <> nil then
  begin
    _AnimIndex := _Mesh.AnimIndex(_AnimName);
  end
  else
  begin
    _AnimIndex := -1;
  end;
  _AnimFrame := 0;
end;

procedure TG2Scene2DComponentModel3D.OnInitialize;
begin
  inherited OnInitialize;
  _Mesh := nil;
  _Inst := nil;
  _Scale := 1;
  _CameraYaw := 0;
  _CameraPitch := 0;
  _CameraRoll := 0;
  _CameraTarget := G2Vec3(0, 0, 0);
  _CameraOrtho := True;
  _CameraNear := 0.01;
  _CameraFar := 100;
  _CameraDistance := 2;
  _Color := $ffffffff;
  _CameraFOV := Pi * 0.2;
  _AnimName := '';
  _AnimIndex := -1;
  _AnimSpeed := 1;
  _AnimLoop := True;
end;

procedure TG2Scene2DComponentModel3D.OnFinalize;
begin
  Mesh := nil;
  inherited OnFinalize;
end;

procedure TG2Scene2DComponentModel3D.OnAttach;
begin
  inherited OnAttach;
  _RenderHook := Scene.RenderHookAdd(@OnRender, _Layer);
  g2.CallbackUpdateAdd(@OnUpdate);
end;

procedure TG2Scene2DComponentModel3D.OnDetach;
begin
  g2.CallbackUpdateRemove(@OnUpdate);
  Scene.RenderHookRemove(_RenderHook);
  inherited OnDetach;
end;

procedure TG2Scene2DComponentModel3D.OnRender(const Display: TG2Display2D);
  var VecC, VecY, VecX: TG2Vec2;
  var W, V, P, Sc: TG2Mat;
  var sw_rcp, sh_rcp, sy, cy, sp, cp, sp2, cp2: TG2Float;
  var CamPos, Up: TG2Vec3;
begin
  if _Inst = nil then Exit;
  G2SinCos(_CameraYaw - G2HalfPi, sy, cy);
  G2SinCos(_CameraPitch, sp, cp);
  sp2 := cp; cp2 := -sp;
  CamPos := _CameraTarget + G2Vec3(cy * cp, sp, sy * cp) * _CameraDistance;
  Up := G2Vec3(cy * cp2, sp2, sy * cp2);
  VecC := Display.CoordToScreen(Owner.Position);
  VecX := Display.CoordToScreen(Owner.Position + Owner.Rotation.AxisX);
  VecY := Display.CoordToScreen(Owner.Position + Owner.Rotation.AxisY);
  sw_rcp := 1 / g2.Params.WidthRT; sh_rcp := 1 / g2.Params.HeightRT;
  VecC := (VecC * G2Vec2(sw_rcp, sh_rcp) - G2Vec2(0.5, 0.5)) * G2Vec2(2, -2);
  VecX := (VecX * G2Vec2(sw_rcp, sh_rcp) - G2Vec2(0.5, 0.5)) * G2Vec2(2, -2);
  VecY := (VecY * G2Vec2(sw_rcp, sh_rcp) - G2Vec2(0.5, 0.5)) * G2Vec2(2, -2);
  VecX := VecX - VecC; VecY := VecY - VecC;
  Sc := G2MatIdentity;
  Sc.SetValue(
    VecX.x, -VecY.x, 0, 0,
    VecX.y, -VecY.y, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
  );
  W := G2MatScaling(_Scale);
  V := G2MatView(CamPos, _CameraTarget, Up) * G2MatRotationZ(_CameraRoll);
  if _CameraOrtho then
  begin
    P := G2MatOrth(1, 1, _CameraNear, _CameraFar);
  end
  else
  begin
    P := G2MatProj(_CameraFOV, 1, _CameraNear, _CameraFar);
  end;
  P := Sc * P * G2MatTranslation(VecC.x, VecC.y, 0);
  _Inst.Color := _Color;
  _Inst.Render(W, V, P);
end;

procedure TG2Scene2DComponentModel3D.OnUpdate;
begin
  if (_Inst <> nil) and (_AnimIndex > -1) then
  begin
    _AnimFrame += g2.DeltaTimeSec * _AnimSpeed;
    if _AnimFrame >= _Mesh.Anims[_AnimIndex]^.FrameCount then
    begin
      if _AnimLoop then
      begin
        _AnimFrame := Frac(_AnimFrame) + Trunc(_AnimFrame) mod _Mesh.Anims[_AnimIndex]^.FrameCount;
      end
      else
      begin
        _AnimFrame := _Mesh.Anims[_AnimIndex]^.FrameCount - 1;
      end;
    end;
    _Inst.FrameSet(_AnimName, _AnimFrame);
  end;
end;

class constructor TG2Scene2DComponentModel3D.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentModel3D.GetName: String;
begin
  Result := 'Model 3D';
end;

class function TG2Scene2DComponentModel3D.CanAttach(const Node: TG2Scene2DEntity): Boolean;
begin
  Result := True;
end;

procedure TG2Scene2DComponentModel3D.Save(const dm: TG2DataManager);
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  if Assigned(_Mesh)
  and (_Mesh.IsShared) then
  begin
    dm.WriteStringA(_Mesh.AssetName);
  end
  else
  begin
    dm.WriteIntS32(0);
  end;
  dm.WriteBool(_CameraOrtho);
  dm.WriteFloat(_CameraYaw);
  dm.WriteFloat(_CameraPitch);
  dm.WriteFloat(_CameraRoll);
  dm.WriteFloat(_CameraDistance);
  dm.WriteFloat(_CameraNear);
  dm.WriteFloat(_CameraFar);
  dm.WriteFloat(_CameraFOV);
  dm.WriteVec3(_CameraTarget);
  dm.WriteFloat(_Scale);
  dm.WriteColor(_Color);
  dm.WriteStringA(_AnimName);
  dm.WriteIntS32(_AnimIndex);
  dm.WriteFloat(_AnimFrame);
  dm.WriteFloat(_AnimSpeed);
  dm.WriteBool(_AnimLoop);
  dm.WriteIntS32(_Layer);
end;

procedure TG2Scene2DComponentModel3D.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
  var MeshFile: String;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  MeshFile := dm.ReadStringA;
  if Length(MeshFile) > 0 then
  begin
    Mesh := TG2LegacyMesh.SharedAsset(MeshFile);
  end
  else
  begin
    Mesh := nil;
  end;
  _CameraOrtho := dm.ReadBool;
  _CameraYaw := dm.ReadFloat;
  _CameraPitch := dm.ReadFloat;
  _CameraRoll := dm.ReadFloat;
  _CameraDistance := dm.ReadFloat;
  _CameraNear := dm.ReadFloat;
  _CameraFar := dm.ReadFloat;
  _CameraFOV := dm.ReadFloat;
  _CameraTarget := dm.ReadVec3;
  _Scale := dm.ReadFloat;
  _Color := dm.ReadColor;
  _AnimName := dm.ReadStringA;
  _AnimIndex := dm.ReadIntS32;
  _AnimFrame := dm.ReadFloat;
  _AnimSpeed := dm.ReadFloat;
  _AnimLoop := dm.ReadBool;
  Layer := dm.ReadIntS32;
end;
//TG2Scene2DComponentModel3D END

//TG2Scene2DComponentText BEGIN
function TG2Scene2DComponentText.GetLayer: TG2IntS32;
begin
  Result := _Layer;
end;

procedure TG2Scene2DComponentText.SetLayer(const Value: TG2IntS32);
begin
  _Layer := Value;
  if _RenderHook <> nil then _RenderHook.Layer := _Layer;
end;

procedure TG2Scene2DComponentText.SetFont(const Value: TG2Font);
begin
  if _Font <> Value then
  begin
    if Assigned(_Font) then _Font.RefDec;
    _Font := Value;
    if Assigned(_Font) then _Font.RefInc;
  end;
end;

function TG2Scene2DComponentText.GetWidth: TG2Float;
begin
  if Assigned(_Font) then Exit(_Font.TextWidth(_Text) * _ScaleX);
  Result := 0;
end;

function TG2Scene2DComponentText.GetHeight: TG2Float;
begin
  if Assigned(_Font) then Exit(_Font.TextHeight('A') * _ScaleY);
  Result := 0;
end;

procedure TG2Scene2DComponentText.SetPosition(const Value: TG2Vec2);
begin
  _Transform.p := Value;
end;

function TG2Scene2DComponentText.GetPosition: TG2Vec2;
begin
  Result := _Transform.p;
end;

procedure TG2Scene2DComponentText.SetRotation(const Value: TG2Rotation2);
begin
  _Transform.r := Value;
end;

function TG2Scene2DComponentText.GetRotation: TG2Rotation2;
begin
  Result := _Transform.r;
end;

procedure TG2Scene2DComponentText.OnInitialize;
begin
  _RenderHook := nil;
  _Font := nil;
  _Text := '';
  _AlignH := g2al_left;
  _AlignV := g2al_top;
  _ScaleX := 0.01;
  _ScaleY := 0.01;
  _Filter := tfPoint;
  _BlendMode := bmNormal;
  _Layer := 0;
  _Color := $ffffffff;
  _Visible := True;
  _Transform.SetIdentity;
end;

procedure TG2Scene2DComponentText.OnFinalize;
begin
  Font := nil;
end;

procedure TG2Scene2DComponentText.OnAttach;
begin
  _RenderHook := Scene.RenderHookAdd(@OnRender, _Layer);
end;

procedure TG2Scene2DComponentText.OnDetach;
begin
  Scene.RenderHookRemove(_RenderHook);
end;

procedure TG2Scene2DComponentText.OnRender(const Display: TG2Display2D);
  var xf: TG2Transform2;
  var i, j, CharSpaceX, CharSpaceY: TG2IntS32;
  var c: TG2IntU8;
  var x0, y0, tu1, tv1, tu2, tv2: TG2Float;
  var v: array[0..3] of TG2Vec2;
  var CharTU, CharTV, CurPos: TG2Float;
begin
  if not _Visible
  or not Assigned(_Font)
  or not Assigned(_Font.Texture)
  or (Length(_Text) = 0) then Exit;
  xf := _Owner.Transform;
  G2Transform2Mul(@xf, @_Transform, @xf);
  CharSpaceX := _Font.Texture.Width shr 4;
  CharSpaceY := _Font.Texture.Height shr 4;
  CharTU := CharSpaceX / _Font.Texture.RealWidth;
  CharTV := CharSpaceY / _Font.Texture.RealHeight;
  case _AlignH of
    g2al_left: x0 := 0;
    g2al_right: x0 := -GetWidth;
    else x0 := -GetWidth * 0.5;
  end;
  case _AlignV of
    g2al_top: y0 := 0;
    g2al_bottom: y0 := -GetHeight;
    else y0 := -GetHeight * 0.5;
  end;
  CurPos := x0;
  for i := 0 to Length(_Text) - 1 do
  begin
    c := Ord(_Text[i + 1]);
    tu1 := (c mod 16) * CharTU;
    tv1 := (c div 16) * CharTV;
    tu2 := tu1 + CharTU;
    tv2 := tv1 + CharTV;
    v[0].x := CurPos - _Font.Props[c].OffsetX * _ScaleX;
    v[0].y := y0 - _Font.Props[c].OffsetY * _ScaleY;
    v[3].x := v[0].x + CharSpaceX * _ScaleX;
    v[3].y := v[0].y + CharSpaceY * _ScaleY;
    v[1].x := v[3].x; v[1].y := v[0].y;
    v[2].x := v[0].x; v[2].y := v[3].y;
    CurPos := CurPos + _Font.Props[c].Width * _ScaleX;
    for j := 0 to 3 do v[j] := xf.Transform(v[j]);
    Display.PicQuadCol(
      v[0].x, v[0].y, v[1].x, v[1].y,
      v[2].x, v[2].y, v[3].x, v[3].y,
      tu1, tv1, tu2, tv1,
      tu1, tv2, tu2, tv2,
      Color, Color, Color, Color,
      Font.Texture,
      BlendMode, Filter
    );
  end;
end;

class constructor TG2Scene2DComponentText.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentText.GetName: String;
begin
  Result := 'Text';
end;

class function TG2Scene2DComponentText.CanAttach(const Node: TG2Scene2DEntity): Boolean;
begin
  Result := True;
end;

procedure TG2Scene2DComponentText.Save(const dm: TG2DataManager);
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  if Assigned(_Font)
  and (_Font.IsShared) then
  begin
    dm.WriteStringA(_Font.AssetName);
  end
  else
  begin
    dm.WriteIntS32(0);
  end;
  dm.WriteStringA(_Text);
  dm.WriteFloat(_ScaleX);
  dm.WriteFloat(_ScaleY);
  dm.WriteIntU8(TG2IntU8(_AlignH));
  dm.WriteIntU8(TG2IntU8(_AlignV));
  dm.WriteBuffer(@_Transform, SizeOf(_Transform));
  dm.WriteBuffer(@_Filter, SizeOf(_Filter));
  dm.WriteBuffer(@_BlendMode, SizeOf(_BlendMode));
  dm.WriteIntS32(_Layer);
end;

procedure TG2Scene2DComponentText.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
  var FontFile: String;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  FontFile := dm.ReadStringA;
  if Length(FontFile) > 0 then
  begin
    Font := TG2Font.SharedAsset(FontFile);
  end;
  _Text := dm.ReadStringA;
  _ScaleX := dm.ReadFloat;
  _ScaleY := dm.ReadFloat;
  _AlignH := TG2Scene2DAlignH(dm.ReadIntU8);
  _AlignV := TG2Scene2DAlignV(dm.ReadIntU8);
  dm.ReadBuffer(@_Transform, SizeOf(_Transform));
  dm.ReadBuffer(@_Filter, SizeOf(_Filter));
  dm.ReadBuffer(@_BlendMode, SizeOf(_BlendMode));
  Layer := dm.ReadIntS32;
end;
//TG2Scene2DComponentText END

//TG2Scene2DComponentEffect BEGIN
{$Hints off}
procedure TG2Scene2DComponentEffect.OnEffectFinish(const Inst: Pointer);
begin
  if _AutoDestruct and (Owner <> nil) then Owner.Free;
end;
{$Hints on}

function TG2Scene2DComponentEffect.GetEffect: TG2Effect2D;
begin
  if Assigned(_EffectInst) then Result := _EffectInst.Effect
  else Result := nil;
end;

procedure TG2Scene2DComponentEffect.SetEffect(const Value: TG2Effect2D);
begin
  if Assigned(_EffectInst) and (_EffectInst.Effect = Value) then Exit;
  if Assigned(_EffectInst) then
  begin
    _EffectInst.Stop;
    _EffectInst.Effect.RefDec;
    _EffectInst.RefDec;
  end;
  _EffectInst := nil;
  if Assigned(Value) then
  begin
    _EffectInst := Value.CreateInstance;
    _EffectInst.RefInc;
    _EffectInst.Effect.RefInc;
    _Scale := _EffectInst.Scale;
    _Speed := _EffectInst.Speed;
    _Repeating := _EffectInst.Repeating;
    _LocalSpace := _EffectInst.LocalSpace;
    _FixedOrientation := _EffectInst.FixedOrientation;
    _EffectInst.Transform := @Owner.Transform;
    _EffectInst.OnFinish := @OnEffectFinish;
  end;
end;

procedure TG2Scene2DComponentEffect.SetLayer(const Value: TG2IntS32);
begin
  _Layer := Value;
  if _RenderHook <> nil then _RenderHook.Layer := _Layer;
end;

procedure TG2Scene2DComponentEffect.SetScale(const Value: TG2Float);
begin
  _Scale := Value;
  if Assigned(_EffectInst) then _EffectInst.Scale := Value;
end;

function TG2Scene2DComponentEffect.GetScale: TG2Float;
begin
  if Assigned(_EffectInst) then Result := _EffectInst.Scale else Result := _Scale;
end;

procedure TG2Scene2DComponentEffect.SetSpeed(const Value: TG2Float);
begin
  _Speed := Value;
  if Assigned(_EffectInst) then _EffectInst.Speed := Value;
end;

function TG2Scene2DComponentEffect.GetSpeed: TG2Float;
begin
  if Assigned(_EffectInst) then Result := _EffectInst.Speed else Result := _Speed;
end;

procedure TG2Scene2DComponentEffect.SetRepeating(const Value: Boolean);
begin
  _Repeating := Value;
  if Assigned(_EffectInst) then _EffectInst.Repeating := Value;
end;

function TG2Scene2DComponentEffect.GetRepeating: Boolean;
begin
  if Assigned(_EffectInst) then Result := _EffectInst.Repeating else Result := _Repeating;
end;

function TG2Scene2DComponentEffect.GetPlaying: Boolean;
begin
  if Assigned(_EffectInst) then Result := _EffectInst.Playing else Result := False;
end;

function TG2Scene2DComponentEffect.GetLocalSpace: Boolean;
begin
  if Assigned(_EffectInst) then Result := _EffectInst.LocalSpace else Result := _LocalSpace;
end;

procedure TG2Scene2DComponentEffect.SetLocalSpace(const Value: Boolean);
begin
  if Value = _LocalSpace then Exit;
  _LocalSpace := Value;
  if Assigned(_EffectInst) then _EffectInst.LocalSpace := Value;
  if Playing then
  begin
    Stop;
    Play;
  end;
end;

function TG2Scene2DComponentEffect.GetFixedOrientation: Boolean;
begin
  if Assigned(_EffectInst) then Result := _EffectInst.FixedOrientation else Result := _FixedOrientation;
end;

procedure TG2Scene2DComponentEffect.SetFixedOrientation(const Value: Boolean);
begin
  _FixedOrientation := Value;
  if Assigned(_EffectInst) then _EffectInst.FixedOrientation := Value;
end;

procedure TG2Scene2DComponentEffect.OnInitialize;
begin
  _EffectInst := nil;
  _RenderHook := nil;
  _Layer := 0;
  _Scale := 1;
  _Speed := 1;
  _Repeating := False;
  _AutoPlay := True;
  _AutoDestruct := False;
  _LocalSpace := True;
  _FixedOrientation := False;
end;

procedure TG2Scene2DComponentEffect.OnFinalize;
begin
  Effect := nil;
  inherited OnFinalize;
end;

procedure TG2Scene2DComponentEffect.OnAttach;
begin
  _RenderHook := Scene.RenderHookAdd(@OnRender, _Layer);
end;

procedure TG2Scene2DComponentEffect.OnDetach;
begin
  Scene.RenderHookRemove(_RenderHook);
  inherited OnDetach;
end;

procedure TG2Scene2DComponentEffect.OnRender(const Display: TG2Display2D);
begin
  if Assigned(_EffectInst) then
  _EffectInst.Render(Display);
end;

class constructor TG2Scene2DComponentEffect.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentEffect.GetName: String;
begin
  Result := 'Effect';
end;

{$Hints off}
class function TG2Scene2DComponentEffect.CanAttach(const Node: TG2Scene2DEntity): Boolean;
begin
  Result := True;
end;
{$Hints on}

procedure TG2Scene2DComponentEffect.Play;
begin
  if Assigned(_EffectInst) then _EffectInst.Play;
end;

procedure TG2Scene2DComponentEffect.Stop;
begin
  if Assigned(_EffectInst) then _EffectInst.Stop;
end;

procedure TG2Scene2DComponentEffect.Save(const dm: TG2DataManager);
  var s: TG2Float;
  var b: Boolean;
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  if Assigned(_EffectInst)
  and _EffectInst.Effect.IsShared then
  begin
    dm.WriteStringA(_EffectInst.Effect.AssetName);
  end
  else
  begin
    dm.WriteIntS32(0);
  end;
  dm.WriteIntS32(_Layer);
  if Assigned(_EffectInst) then s := _EffectInst.Scale else s := _Scale;
  dm.WriteFloat(s);
  if Assigned(_EffectInst) then s := _EffectInst.Speed else s := _Speed;
  dm.WriteFloat(s);
  if Assigned(_EffectInst) then b := _EffectInst.Repeating else b := _Repeating;
  dm.WriteBool(b);
  if Assigned(_EffectInst) then b := _EffectInst.LocalSpace else b := _LocalSpace;
  dm.WriteBool(b);
  if Assigned(_EffectInst) then b := _EffectInst.FixedOrientation else b := _FixedOrientation;
  dm.WriteBool(b);
  dm.WriteBool(_AutoPlay);
  dm.WriteBool(_AutoDestruct);
end;

procedure TG2Scene2DComponentEffect.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
  var EffectFile: String;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  EffectFile := dm.ReadStringA;
  Layer := dm.ReadIntS32;
  _Scale := dm.ReadFloat;
  _Speed := dm.ReadFloat;
  _Repeating := dm.ReadBool;
  _LocalSpace := dm.ReadBool;
  _FixedOrientation := dm.ReadBool;
  _AutoPlay := dm.ReadBool;
  _AutoDestruct := dm.ReadBool;
  if Length(EffectFile) > 0 then
  begin
    Effect := TG2Effect2D.SharedAsset(EffectFile);
    if Assigned(_EffectInst) then
    begin
      _EffectInst.Scale := _Scale;
      _EffectInst.Speed := _Speed;
      _EffectInst.Repeating := _Repeating;
      _EffectInst.LocalSpace := _LocalSpace;
      _EffectInst.FixedOrientation := _FixedOrientation;
      if _AutoPlay then Play;
    end;
  end;
end;
//TG2Scene2DComponentEffect END

//TG2Scene2DComponentBackground BEGIN
procedure TG2Scene2DComponentBackground.SetLayer(const Value: TG2IntS32);
begin
  if _Layer = Value then Exit;
  _Layer := Value;
  if _RenderHook <> nil then _RenderHook.Layer := Value;
end;

procedure TG2Scene2DComponentBackground.SetTexture(const Value: TG2Texture2DBase);
begin
  if Value = _Texture then Exit;
  if _Texture <> nil then _Texture.RefDec;
  _Texture := Value;
  if _Texture <> nil then _Texture.RefInc;
end;

procedure TG2Scene2DComponentBackground.OnInitialize;
begin
  _Texture := nil;
  _RenderHook := nil;
  _Scale.SetValue(1, 1);
  _ScrollSpeed.SetZero;
  _ScrollPos.SetZero;
  _Filter := tfLinear;
  _BlendMode := bmNormal;
  _RefTexture := False;
  _FlipX := False;
  _FlipY := False;
  _RepeatX := True;
  _RepeatY := True;
  _Color := $ffffffff;
  _Layer := 0;
end;

procedure TG2Scene2DComponentBackground.OnFinalize;
begin
  Texture := nil;
end;

procedure TG2Scene2DComponentBackground.OnAttach;
begin
  _RenderHook := Scene.RenderHookAdd(@OnRender, 0);
  g2.CallbackUpdateAdd(@OnUpdate);
end;

procedure TG2Scene2DComponentBackground.OnDetach;
begin
  Scene.RenderHookRemove(_RenderHook);
  g2.CallbackUpdateRemove(@OnUpdate);
end;

procedure TG2Scene2DComponentBackground.OnRender(const Display: TG2Display2D);
  function IntersectScreenGrid(const lv0, lv1: TG2Vec2; const r: TG2Rect; var xp0, xp1: TG2Vec2): Boolean;
    var tn, tf, d, t, t0, t1: TG2Float;
    var v: TG2Vec2;
    var i, j: TG2IntS32;
  begin
    tn := -1E+16;
    tf := 1E+16;
    v := lv1 - lv0;
    for i := 0 to 1 do
    if Abs(v[i]) < G2EPS then
    begin
      j := (i + 1) mod 2;
      xp0[i] := lv0[i];
      xp0[j] := r.br[j];
      xp1[i] := lv0[i];
      xp1[j] := r.tl[j];
      Exit(True);
    end;
    for i := 0 to 1 do
    begin
      d := 1 / v[i];
      t0 := (r.tl[i] - lv0[i]) * d;
      t1 := (r.br[i] - lv0[i]) * d;
      if t0 > t1 then
      begin
        t := t1;
        t1 := t0;
        t0 := t;
      end;
      if i = 0 then
      begin
        tn := t0;
        tf := t1;
      end
      else
      begin
        if t0 < tn then tn := t0;
        if t1 > tf then tf := t1;
      end;
    end;
    xp0 := lv0 + v * tn;
    xp1 := lv0 + v * tf;
    Result := True;
  end;
  var r: TG2Rect;
  var v, t: array[0..3] of TG2Vec2;
  var i: Integer;
  var xf: TG2Transform2;
  var pvx, pvy: TG2Vec2;
  var ox, oy, dn, df, d: TG2Float;
begin
  if (_Texture = nil)
  or (_Owner = nil) then
  Exit;
  xf := _Owner.Transform;
  if Abs(_Scale.x) < G2EPS then pvx := xf.r.AxisX else pvx := xf.r.AxisX / _Scale.x;
  if Abs(_Scale.y) < G2EPS then pvy := xf.r.AxisY else pvy := xf.r.AxisY / _Scale.y;
  if _FlipX then pvx := -pvx; if _FlipY then pvy := -pvy;
  ox := pvx.Dot(xf.p);
  oy := pvy.Dot(xf.p);
  r := Display.ScreenBounds;
  if _RepeatX and _RepeatY then
  begin
    v[0] := G2Vec2(r.l, r.t);
    v[1] := G2Vec2(r.r, r.t);
    v[2] := G2Vec2(r.l, r.b);
    v[3] := G2Vec2(r.r, r.b);
  end
  else
  begin
    v[0] := xf.p - xf.r.AxisX * (_Scale.x * 0.5) - xf.r.AxisY * (_Scale.y * 0.5);
    v[1] := xf.p + xf.r.AxisX * (_Scale.x * 0.5) - xf.r.AxisY * (_Scale.y * 0.5);
    v[2] := xf.p - xf.r.AxisX * (_Scale.x * 0.5) + xf.r.AxisY * (_Scale.y * 0.5);
    v[3] := xf.p + xf.r.AxisX * (_Scale.x * 0.5) + xf.r.AxisY * (_Scale.y * 0.5);
    if _RepeatX then
    begin
      d := xf.r.AxisX.Dot(r.tl);
      dn := d;
      df := d;
      d := xf.r.AxisX.Dot(r.tr);
      if d < dn then dn := d else if d > df then df := d;
      d := xf.r.AxisX.Dot(r.bl);
      if d < dn then dn := d else if d > df then df := d;
      d := xf.r.AxisX.Dot(r.br);
      if d < dn then dn := d else if d > df then df := d;
      v[0] := v[0] + xf.r.AxisX * (dn - xf.r.AxisX.Dot(v[0]));
      v[1] := v[1] + xf.r.AxisX * (df - xf.r.AxisX.Dot(v[1]));
      v[2] := v[2] + xf.r.AxisX * (dn - xf.r.AxisX.Dot(v[2]));
      v[3] := v[3] + xf.r.AxisX * (df - xf.r.AxisX.Dot(v[3]));
    end
    else if _RepeatY then
    begin
      d := xf.r.AxisY.Dot(r.tl);
      dn := d; df := d;
      d := xf.r.AxisY.Dot(r.tr);
      if d < dn then dn := d else if d > df then df := d;
      d := xf.r.AxisY.Dot(r.bl);
      if d < dn then dn := d else if d > df then df := d;
      d := xf.r.AxisY.Dot(r.br);
      if d < dn then dn := d else if d > df then df := d;
      v[0] := v[0] + xf.r.AxisY * (dn - xf.r.AxisY.Dot(v[0]));
      v[1] := v[1] + xf.r.AxisY * (dn - xf.r.AxisY.Dot(v[1]));
      v[2] := v[2] + xf.r.AxisY * (df - xf.r.AxisY.Dot(v[2]));
      v[3] := v[3] + xf.r.AxisY * (df - xf.r.AxisY.Dot(v[3]));
    end;
  end;
  for i := 0 to 3 do
  begin
    t[i].x := pvx.Dot(v[i]) - ox + _ScrollPos.x - 0.5;
    t[i].y := pvy.Dot(v[i]) - oy + _ScrollPos.y - 0.5;
  end;
  Display.PicQuad(
    v[0], v[1], v[2], v[3],
    t[0], t[1], t[2], t[3],
    _Color, _Texture,
    _BlendMode, _Filter
  );
end;

procedure TG2Scene2DComponentBackground.OnUpdate;
begin
  if _FlipX then
  _ScrollPos.x += _ScrollSpeed.x * (1 / g2.Params.TargetUPS)
  else
  _ScrollPos.x -= _ScrollSpeed.x * (1 / g2.Params.TargetUPS);
  if _FlipY then
  _ScrollPos.y += _ScrollSpeed.y * (1 / g2.Params.TargetUPS)
  else
  _ScrollPos.y -= _ScrollSpeed.y * (1 / g2.Params.TargetUPS);
  if Abs(_ScrollPos.x) > 1 then
  _ScrollPos.x := Frac(_ScrollPos.x);
  if Abs(_ScrollPos.y) > 1 then
  _ScrollPos.y := Frac(_ScrollPos.y);
end;

class constructor TG2Scene2DComponentBackground.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentBackground.GetName: String;
begin
  Result := 'Background';
end;

{$Hints off}
class function TG2Scene2DComponentBackground.CanAttach(
  const Node: TG2Scene2DEntity
): Boolean;
begin
  Result := True;
end;
{$Hints on}

procedure TG2Scene2DComponentBackground.Save(const dm: TG2DataManager);
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  if Assigned(_Texture)
  and _Texture.IsShared then
  begin
    dm.WriteStringA(_Texture.AssetName);
  end
  else
  begin
    dm.WriteIntS32(0);
  end;
  dm.WriteVec2(_Scale);
  dm.WriteVec2(_ScrollSpeed);
  dm.WriteBool(_FlipX);
  dm.WriteBool(_FlipY);
  dm.WriteBool(_RepeatX);
  dm.WriteBool(_RepeatY);
  dm.WriteColor(_Color);
  dm.WriteBuffer(@_Filter, SizeOf(_Filter));
  dm.WriteIntS32(_Layer);
  dm.WriteBuffer(@_BlendMode, SizeOf(_BlendMode));
end;

procedure TG2Scene2DComponentBackground.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
  var TexFile: String;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  TexFile := dm.ReadStringA;
  if Length(TexFile) > 0 then
  begin
    Texture := TG2Texture2D.SharedAsset(TexFile);
  end;
  _Scale := dm.ReadVec2;
  _ScrollSpeed := dm.ReadVec2;
  _FlipX := dm.ReadBool;
  _FlipY := dm.ReadBool;
  _RepeatX := dm.ReadBool;
  _RepeatY := dm.ReadBool;
  _Color := dm.ReadColor;
  dm.ReadBuffer(@_Filter, SizeOf(_Filter));
  Layer := dm.ReadIntS32;
  dm.ReadBuffer(@_BlendMode, SizeOf(_BlendMode));
end;
//TG2Scene2DComponentBackground END

//TG2Scene2DComponentSpineAnimation BEGIN
procedure TG2Scene2DComponentSpineAnimation.SetSkeleton(const Value: TSpineSkeleton);
  var asd: TSpineAnimationStateData;
begin
  if _Skeleton = Value then Exit;
  if Assigned(_Skeleton) then _Skeleton.RefDec;
  _Skeleton := Value;
  if Assigned(_Skeleton) then _Skeleton.RefInc;
  if Assigned(_State) then _State.Free;
  _State := nil;
  if Assigned(_Skeleton) then
  begin
    asd := TSpineAnimationStateData.Create(_Skeleton.Data);
    _State := TSpineAnimationState.Create(asd);
    asd.Free;
    _State.TimeScale := _TimeScale;
    if Length(_Animation) > 0 then _State.SetAnimation(0, _Animation, _Loop);
    _Skeleton.ScaleX := _Scale.x;
    _Skeleton.ScaleY := _Scale.y;
    _Skeleton.FlipX := _FlipX;
    _Skeleton.FlipY := _FlipY;
  end;
end;

procedure TG2Scene2DComponentSpineAnimation.SetTimeScale(const Value: TG2Float);
begin
  if _TimeScale = Value then Exit;
  _TimeScale := Value;
  if Assigned(_State) then _State.TimeScale := _TimeScale;
end;

procedure TG2Scene2DComponentSpineAnimation.SetColor(const Value: TG2Color);
begin
  _Color := Value;
  _SpineRender.r := _Color.r * G2Rcp255;
  _SpineRender.g := _Color.g * G2Rcp255;
  _SpineRender.b := _Color.b * G2Rcp255;
  _SpineRender.a := _Color.a * G2Rcp255;
end;

function TG2Scene2DComponentSpineAnimation.GetBoneTransform(const Bone: TSpineBone): TG2Transform2;
  var p: TG2Vec2;
  var tx, ty, sx, sy, rx0, ry0, rx1, ry1: TG2Float;
begin
  Result := G2Transform2;
  if not Assigned(_Skeleton) then Exit;
  tx := _Skeleton.x; ty := _Skeleton.y;
  sx := _Skeleton.ScaleX; sy := _Skeleton.ScaleY;
  rx0 := _Skeleton.rx; ry0 := _Skeleton.ry;
  rx1 := -_Skeleton.ry; ry1 := _Skeleton.rx;
  p := G2Vec2(Bone.WorldX * sx, Bone.WorldY * sy);
  Result.p := G2Vec2(p.x * rx0 + p.y * ry0 + tx, p.x * rx1 + p.y * ry1 + ty);
  Result.r.c := (Bone.a + Bone.b) * rx0 + (Bone.a + Bone.b) * ry0;
  Result.r.s := (Bone.c + Bone.d) * rx1 + (Bone.d + Bone.d) * ry1;
end;

procedure TG2Scene2DComponentSpineAnimation.SetLayer(const Value: TG2IntS32);
begin
  if _Layer = Value then Exit;
  _Layer := Value;
  if Assigned(_RenderHook) then _RenderHook.Layer := _Layer;
end;

procedure TG2Scene2DComponentSpineAnimation.SetAnimation(const Value: String);
begin
  if _Animation = Value then Exit;
  _Animation := Value;
  if Assigned(_State) then _State.SetAnimation(0, _Animation, _Loop);
end;

procedure TG2Scene2DComponentSpineAnimation.SetLoop(const Value: Boolean);
begin
  if _Loop = Value then Exit;
  _Loop := Value;
  if Assigned(_State) then _State.SetAnimation(0, _Animation, _Loop);
end;

procedure TG2Scene2DComponentSpineAnimation.SetFlipX(const Value: Boolean);
begin
  if _FlipX = Value then Exit;
  _FlipX := Value;
  if Assigned(_Skeleton) then _Skeleton.FlipX := _FlipX;
end;

procedure TG2Scene2DComponentSpineAnimation.SetFlipY(const Value: Boolean);
begin
  if _FlipY = Value then Exit;
  _FlipY := Value;
  if Assigned(_Skeleton) then _Skeleton.FlipY := _FlipY;
end;

procedure TG2Scene2DComponentSpineAnimation.SetScale(const Value: TG2Vec2);
begin
  _Scale := Value;
  if Assigned(_Skeleton) then
  begin
    _Skeleton.ScaleX := _Scale.x;
    _Skeleton.ScaleY := _Scale.y;
  end;
end;

procedure TG2Scene2DComponentSpineAnimation.OnInitialize;
begin
  inherited OnInitialize;
  _SpineRender := TG2SpineRender.Create;
  _Skeleton := nil;
  _Offset := G2Vec2;
  _Scale := G2Vec2(1, 1);
  _FlipX := False;
  _FlipY := False;
  _Animation := '';
  _Loop := True;
  _TimeScale := 1;
  _Color := $ffffffff;
  _OnUpdateAnimation := nil;
end;

procedure TG2Scene2DComponentSpineAnimation.OnFinalize;
begin
  if Assigned(_State) then _State.Free;
  _State := nil;
  Skeleton := nil;
  _SpineRender.Free;
  inherited OnFinalize;
end;

procedure TG2Scene2DComponentSpineAnimation.OnAttach;
begin
  _RenderHook := Scene.RenderHookAdd(@OnRender, 0);
  g2.CallbackUpdateAdd(@OnUpdate);
end;

procedure TG2Scene2DComponentSpineAnimation.OnDetach;
begin
  Scene.RenderHookRemove(_RenderHook);
  g2.CallbackUpdateRemove(@OnUpdate);
end;

procedure TG2Scene2DComponentSpineAnimation.OnRender(const Display: TG2Display2D);
begin
  if not Assigned(Owner) or not Assigned(_Skeleton) then Exit;
  _SpineRender.Display := Display;
  _Skeleton.Draw(_SpineRender);
end;

procedure TG2Scene2DComponentSpineAnimation.OnUpdate;
begin
  UpdateAnimation(g2.DeltaTimeSec);
end;

class constructor TG2Scene2DComponentSpineAnimation.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentSpineAnimation.GetName: String;
begin
  Result := 'Spine Animation';
end;

{$Hints off}
class function TG2Scene2DComponentSpineAnimation.CanAttach(const Node: TG2Scene2DEntity): Boolean;
begin
  Result := True;
end;

procedure TG2Scene2DComponentSpineAnimation.UpdateAnimation(const DeltaTime: TG2Float);
  var lt: TG2Vec2;
begin
  if not Assigned(Owner) or not Assigned(_Skeleton) then Exit;
  _Skeleton.Rotation := Owner.Transform.r.Angle * G2RadToDeg;
  lt := Owner.Transform.r.Transform(_Offset);
  _Skeleton.x := Owner.Transform.p.x + lt.x;
  _Skeleton.y := Owner.Transform.p.y + lt.y;
  _State.Update(g2.DeltaTimeSec);
  _State.Apply(_Skeleton);
  if Assigned(_OnUpdateAnimation) then _OnUpdateAnimation(Self);
  _Skeleton.UpdateWorldTransform;
end;
{$Hints on}

procedure TG2Scene2DComponentSpineAnimation.Save(const dm: TG2DataManager);
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  if Assigned(_Skeleton) then
  begin
    dm.WriteStringA(_Skeleton.Data.Name);
  end
  else
  begin
    dm.WriteIntS32(0);
  end;
  dm.WriteIntS32(_Layer);
  dm.WriteVec2(_Offset);
  dm.WriteVec2(_Scale);
  dm.WriteBool(_Loop);
  dm.WriteBool(_FlipX);
  dm.WriteBool(_FlipY);
  dm.WriteFloat(_TimeScale);
  dm.WriteStringA(_Animation);
end;

procedure TG2Scene2DComponentSpineAnimation.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
  var SkeletonPath: String;
  var AtlasPath: String;
  var Atlas: TSpineAtlas;
  var Skel: TSpineSkeleton;
  var sb: TSpineSkeletonBinary;
  var sd: TSpineSkeletonData;
  var al: TSpineAtlasList;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  SkeletonPath := dm.ReadStringA;
  Layer := dm.ReadIntS32;
  _Offset := dm.ReadVec2;
  _Scale := dm.ReadVec2;
  _Loop := dm.ReadBool;
  _FlipX := dm.ReadBool;
  _FlipY := dm.ReadBool;
  _TimeScale := dm.ReadFloat;
  _Animation := dm.ReadStringA;
  if Length(SkeletonPath) > 0 then
  begin
    AtlasPath := G2PathNoExt(SkeletonPath) + '.atlas';
    Atlas := TSpineAtlas.Create(AtlasPath);
    al := TSpineAtlasList.Create;
    al.Add(Atlas);
    sb := TSpineSkeletonBinary.Create(al);
    sd := sb.ReadSkeletonData(SkeletonPath);
    Skel := TSpineSkeleton.Create(sd);
    Skeleton := Skel;
    Skel.Free;
    sd.Free;
    sb.Free;
    al.Free;
    Atlas.Free;
  end;
end;
//TG2Scene2DComponentSpineAnimation END

//TG2Scene2DComponentRigidBody BEGIN
procedure TG2Scene2DComponentRigidBody.SetEnabled(const Value: Boolean);
  var i: Integer;
  var bd: tb2_body_def;
begin
  if Value = _Enabled then Exit;
  _Enabled := Value;
  if _Enabled then
  begin
    if Owner = nil then
    begin
      _Enabled := False;
      Exit;
    end;
    bd := _BodyDef;
    bd.angle := bd.angle + Owner.Transform.r.Angle;
    bd.position := bd.position + Owner.Transform.p;
    bd.user_data := Self;
    _Body := Scene.PhysWorld.create_body(bd);
    for i := 0 to Owner.ComponentCount - 1 do
    if Owner.Components[i] is TG2Scene2DComponentCollisionShape then
    AddShape(TG2Scene2DComponentCollisionShape(Owner.Components[i]));
    g2.CallbackUpdateAdd(@OnUpdate);
  end
  else
  begin
    g2.CallbackUpdateRemove(@OnUpdate);
    for i := 0 to Owner.ComponentCount - 1 do
    if Owner.Components[i] is TG2Scene2DComponentCollisionShape then
    RemoveShape(TG2Scene2DComponentCollisionShape(Owner.Components[i]));
    Scene.PhysWorld.destroy_body(_Body);
  end;
end;

procedure TG2Scene2DComponentRigidBody.SetBodyType(
  const Value: TG2Scene2DComponentRigidBodyType
);
  var new_type: tb2_body_type;
begin
  case Value of
    g2_s2d_rbt_static_body: new_type := b2_static_body;
    g2_s2d_rbt_kinematic_body: new_type := b2_kinematic_body;
    g2_s2d_rbt_dynamic_body: new_type := b2_dynamic_body;
  end;
  if new_type = _BodyDef.body_type then Exit;
  _BodyDef.body_type := new_type;
  if _Enabled then _Body^.set_type(_BodyDef.body_type);
end;

function TG2Scene2DComponentRigidBody.GetBodyType: TG2Scene2DComponentRigidBodyType;
begin
  case _BodyDef.body_type of
    b2_static_body: Exit(g2_s2d_rbt_static_body);
    b2_kinematic_body: Exit(g2_s2d_rbt_kinematic_body);
    else Exit(g2_s2d_rbt_dynamic_body);
  end;
end;

procedure TG2Scene2DComponentRigidBody.SetPosition(const Value: TG2Vec2);
begin
  if _Enabled then
  begin
    _Body^.set_transform(Value, _Body^.get_angle);
  end;
  _BodyDef.position := Value;
end;

function TG2Scene2DComponentRigidBody.GetPosition: TG2Vec2;
begin
  if _Enabled then
  Result := _Body^.get_position
  else
  Result := _BodyDef.position;
end;

procedure TG2Scene2DComponentRigidBody.SetRotation(const Value: TG2Float);
begin
  if _Enabled then
  begin
    _Body^.set_transform(_Body^.get_position, Value);
  end;
  _BodyDef.angle := Value;
end;

function TG2Scene2DComponentRigidBody.GetRotation: TG2Float;
begin
  if _Enabled then
  Result := _Body^.get_angle
  else
  Result := _BodyDef.angle;
end;

procedure TG2Scene2DComponentRigidBody.SetFixedRotation(const Value: Boolean);
begin
  if _Enabled then
  begin
    _Body^.set_fixed_rotation(Value);
  end;
  _BodyDef.fixed_rotation := Value;
end;

function TG2Scene2DComponentRigidBody.GetFixedRotation: Boolean;
begin
  if _Enabled then
  Result := _Body^.is_fixed_rotation
  else
  Result := _BodyDef.fixed_rotation;
end;

procedure TG2Scene2DComponentRigidBody.SetTransform(const Value: TG2Transform2);
begin
  if _Enabled then
  _Body^.set_transform(Value)
  else
  begin
    _BodyDef.position := Value.p;
    _BodyDef.angle := Value.r.Angle;
  end;
end;

function TG2Scene2DComponentRigidBody.GetTransform: TG2Transform2;
begin
  if _Enabled then
  Result := _Body^.get_transform
  else
  Result.SetValue(_BodyDef.position, G2Rotation2(_BodyDef.angle));
end;

procedure TG2Scene2DComponentRigidBody.SetGravityScale(const Value: TG2Float);
begin
  _BodyDef.gravity_scale := Value;
  if _Enabled then
  _Body^.set_gravity_scale(Value);
end;

function TG2Scene2DComponentRigidBody.GetGravityScale: TG2Float;
begin
  if _Enabled then
  Result := _Body^.get_gravity_scale
  else
  Result := _BodyDef.gravity_scale;
end;

procedure TG2Scene2DComponentRigidBody.SetLinearDamping(const Value: TG2Float);
begin
  _BodyDef.linear_damping := Value;
  if _Enabled then
  _Body^.set_linear_damping(Value);
end;

function TG2Scene2DComponentRigidBody.GetLinearDamping: TG2Float;
begin
  if _Enabled then
  Result := _Body^.get_linear_damping
  else
  Result := _BodyDef.linear_damping;
end;

procedure TG2Scene2DComponentRigidBody.SetAngularDamping(const Value: TG2Float);
begin
  _BodyDef.angular_damping := Value;
  if _Enabled then
  _Body^.set_angular_damping(Value);
end;

function TG2Scene2DComponentRigidBody.GetAngularDamping: TG2Float;
begin
  if _Enabled then
  Result := _Body^.get_angular_damping
  else
  Result := _BodyDef.angular_damping;
end;

procedure TG2Scene2DComponentRigidBody.SetLinearVelocity(const Value: TG2Vec2);
begin
  if _Enabled then _Body^.set_linear_velocity(Value);
end;

function TG2Scene2DComponentRigidBody.GetLinearVelocity: TG2Vec2;
begin
  if _Enabled then Result := _Body^.get_linear_velocity else Result := G2Vec2;
end;

procedure TG2Scene2DComponentRigidBody.SetAngularVelocity(const Value: TG2Float);
begin
  if _Enabled then _Body^.set_angular_velocity(Value);
end;

function TG2Scene2DComponentRigidBody.GetAngularVelocity: TG2Float;
begin
  if _Enabled then Result := _Body^.get_angular_velocity else Result := 0;
end;

procedure TG2Scene2DComponentRigidBody.SetIsBullet(const Value: Boolean);
begin
  if _BodyDef.bullet = Value then Exit;
  _BodyDef.bullet := Value;
  if _Enabled then _Body^.set_bullet(_BodyDef.bullet);
end;

function TG2Scene2DComponentRigidBody.GetIsBullet: Boolean;
begin
  Result := _BodyDef.bullet;
end;

procedure TG2Scene2DComponentRigidBody.OnInitialize;
begin
  _Enabled := False;
  _Body := nil;
  _BodyDef := b2_body_def;
end;

procedure TG2Scene2DComponentRigidBody.OnFinalize;
begin
  Detach;
end;

procedure TG2Scene2DComponentRigidBody.OnAttach;
begin

end;

procedure TG2Scene2DComponentRigidBody.OnDetach;
begin
  Enabled := False;
end;

procedure TG2Scene2DComponentRigidBody.OnUpdate;
begin
  if Owner = nil then Exit;
  if (BodyType = g2_s2d_rbt_dynamic_body) then
  begin
    ApplyToOwner;
  end
  else if (BodyType = g2_s2d_rbt_kinematic_body) then
  begin
    UpdateFromOwner;
  end;
end;

procedure TG2Scene2DComponentRigidBody.AddShape(const Shape: TG2Scene2DComponentCollisionShape);
begin
  Shape.Fixture := _Body^.create_fixture(Shape.FixtureDef);
  Shape.Fixture^.set_user_data(Shape);
end;

procedure TG2Scene2DComponentRigidBody.RemoveShape(const Shape: TG2Scene2DComponentCollisionShape);
  var Fixture: pb2_fixture;
begin
  Fixture := Shape.Fixture;
  _Body^.destroy_fixture(Fixture);
  Shape.Fixture := nil;
end;

class constructor TG2Scene2DComponentRigidBody.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentRigidBody.GetName: String;
begin
  Result := 'Rigid Body';
end;

class function TG2Scene2DComponentRigidBody.CanAttach(
  const Node: TG2Scene2DEntity
): Boolean;
begin
  Result := Node.ComponentOfType[TG2Scene2DComponentRigidBody] = nil;
end;

procedure TG2Scene2DComponentRigidBody.MakeStatic;
begin
  BodyType := g2_s2d_rbt_static_body;
end;

procedure TG2Scene2DComponentRigidBody.MakeKinematic;
begin
  BodyType := g2_s2d_rbt_kinematic_body;
end;

procedure TG2Scene2DComponentRigidBody.MakeDynamic;
begin
  BodyType := g2_s2d_rbt_dynamic_body;
end;

procedure TG2Scene2DComponentRigidBody.UpdateFromOwner;
begin
  SetTransform(Owner.Transform);
  _Body^.set_awake(true);
end;

procedure TG2Scene2DComponentRigidBody.ApplyToOwner;
begin
  Owner.Transform := Transform;
end;

procedure TG2Scene2DComponentRigidBody.ApplyLinearImpulse(
  const Impulse, Point: TG2Vec2; const Wake: Boolean
);
begin
  if _Enabled then _Body^.apply_linear_impulse(Impulse, Point, Wake);
end;

procedure TG2Scene2DComponentRigidBody.ApplyAngularImpulse(
  const Impulse: TG2Float; const Wake: Boolean);
begin
  if _Enabled then _Body^.apply_angular_impulse(Impulse, Wake);
end;

procedure TG2Scene2DComponentRigidBody.ApplyForce(
  const Force, Point: TG2Vec2; const Wake: Boolean
);
begin
  if _Enabled then _Body^.apply_force(Force, Point, Wake);
end;

procedure TG2Scene2DComponentRigidBody.ApplyForceToCenter(
  const Force: TG2Vec2; const Wake: Boolean
);
begin
  if _Enabled then _Body^.apply_force_to_center(Force, Wake);
end;

procedure TG2Scene2DComponentRigidBody.ApplyTorque(
  const Torque: TG2Float; const Wake: Boolean
);
begin
  if _Enabled then _Body^.apply_torque(Torque, Wake);
end;

procedure TG2Scene2DComponentRigidBody.Wake;
begin
  _Body^.set_awake(true);
end;

procedure TG2Scene2DComponentRigidBody.Save(const dm: TG2DataManager);
  var xf: TG2Transform2;
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  xf := Transform;
  dm.WriteBuffer(@xf, SizeOf(xf));
  dm.WriteBuffer(@_BodyDef, SizeOf(_BodyDef));
  dm.WriteBool(_Enabled);
end;

procedure TG2Scene2DComponentRigidBody.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
  var xf: TG2Transform2;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  {$Hints off}
  dm.ReadBuffer(@xf, SizeOf(xf));
  {$Hints on}
  dm.ReadBuffer(@_BodyDef, SizeOf(_BodyDef));
  Transform := xf;
  Enabled := dm.ReadBool;
end;
//TG2Scene2DComponentRigidBody END

//TG2Scene2DEventBeginContactData BEGIN
constructor TG2Scene2DEventBeginContactData.Create;
begin
  inherited Create;
end;

function TG2Scene2DEventBeginContactData.GetContactPoint: TG2Vec2;
  var wm: tb2_world_manifold;
  var i: Integer;
begin
  if PhysContact^.get_manifold^.point_count = 0 then Exit(G2Vec2);
  PhysContact^.get_world_manifold(wm{%H-});
  Result := wm.points[0];
  if PhysContact^.get_manifold^.point_count > 0 then
  begin
    for i := 1 to PhysContact^.get_manifold^.point_count - 1 do
    begin
      Result := Result + wm.points[i];
    end;
    Result := Result / PhysContact^.get_manifold^.point_count;
  end;
end;
//TG2Scene2DEventBeginContactData END

//TG2Scene2DEventEndContactData BEGIN
constructor TG2Scene2DEventEndContactData.Create;
begin
  inherited Create;
end;
//TG2Scene2DEventEndContactData END

//TG2Scene2DEventBeforeContactSolveData BEGIN
constructor TG2Scene2DEventBeforeContactSolveData.Create;
begin
  inherited Create;
end;
//TG2Scene2DEventBeforeContactSolveData END

//TG2Scene2DEventAfterContactSolveData BEGIN
constructor TG2Scene2DEventAfterContactSolveData.Create;
begin
  inherited Create;
end;
//TG2Scene2DEventAfterContactSolveData END

//TG2Scene2DComponentCollisionShape BEGIN
procedure TG2Scene2DComponentCollisionShape.SetFilterCategoryMask(const Value: TG2IntU16);
begin
  _FixtureDef.filter.category_bits := Value;
  if Assigned(_Fixture) then _Fixture^.set_filter_data(_FixtureDef.filter);
end;

function TG2Scene2DComponentCollisionShape.GetFilterCategoryMask: TG2IntU16;
begin
  Result := _FixtureDef.filter.category_bits;
end;

procedure TG2Scene2DComponentCollisionShape.SetFilterMask(const Value: TG2IntU16);
begin
  _FixtureDef.filter.mask_bits := Value;
  if Assigned(_Fixture) then _Fixture^.set_filter_data(_FixtureDef.filter);
end;

function TG2Scene2DComponentCollisionShape.GetFilterMask: TG2IntU16;
begin
  Result := _FixtureDef.filter.mask_bits;
end;

procedure TG2Scene2DComponentCollisionShape.SetFilterGroup(const Value: TG2IntS16);
begin
  _FixtureDef.filter.group_index := Value;
  if Assigned(_Fixture) then _Fixture^.set_filter_data(_FixtureDef.filter);
end;

function TG2Scene2DComponentCollisionShape.GetFilterGroup: TG2IntS16;
begin
  Result := _FixtureDef.filter.group_index;
end;

procedure TG2Scene2DComponentCollisionShape.OnInitialize;
begin
  inherited OnInitialize;
  _EventBeginContact := TG2Scene2DEventDispatcher.Create('OnBeginContact');
  _EventEndContact := TG2Scene2DEventDispatcher.Create('OnEndContact');
  _EventBeforeContactSolve := TG2Scene2DEventDispatcher.Create('OnBeforeContactSolve');
  _EventAfterContactSolve := TG2Scene2DEventDispatcher.Create('OnAfterContactSolve');
  _EventBeginContactData := TG2Scene2DEventBeginContactData.Create;
  _EventEndContactData := TG2Scene2DEventEndContactData.Create;
  _EventBeforeContactSolveData := TG2Scene2DEventBeforeContactSolveData.Create;
  _EventAfterContactSolveData := TG2Scene2DEventAfterContactSolveData.Create;
  _EventDispatchers.Add(_EventBeginContact);
  _EventDispatchers.Add(_EventEndContact);
  _EventDispatchers.Add(_EventBeforeContactSolve);
  _EventDispatchers.Add(_EventAfterContactSolve);
  _Fixture := nil;
  _FixtureDef := b2_fixture_def;
  _FixtureDef.density := 1;
end;

procedure TG2Scene2DComponentCollisionShape.OnFinalize;
begin
  _EventBeginContactData.Free;
  _EventEndContactData.Free;
  _EventBeforeContactSolveData.Free;
  _EventAfterContactSolveData.Free;
  _EventBeginContact.Free;
  _EventEndContact.Free;
  _EventBeforeContactSolve.Free;
  _EventAfterContactSolve.Free;
  inherited OnFinalize;
end;

procedure TG2Scene2DComponentCollisionShape.OnAttach;
  var rb: TG2Scene2DComponentRigidBody;
begin
  rb := TG2Scene2DComponentRigidBody(Owner.ComponentOfType[TG2Scene2DComponentRigidBody]);
  if (rb <> nil) and rb.Enabled then rb.AddShape(Self);
end;

procedure TG2Scene2DComponentCollisionShape.OnDetach;
  var rb: TG2Scene2DComponentRigidBody;
begin
  rb := TG2Scene2DComponentRigidBody(Owner.ComponentOfType[TG2Scene2DComponentRigidBody]);
  if (rb <> nil) and rb.Enabled then rb.RemoveShape(Self);
end;

procedure TG2Scene2DComponentCollisionShape.Reattach;
  var OldOwner: TG2Scene2DEntity;
begin
  if Owner = nil then Exit;
  OldOwner := Owner;
  Detach;
  Attach(OldOwner);
end;

function TG2Scene2DComponentCollisionShape.GetFriction: TG2Float;
begin
  Result := _FixtureDef.friction;
end;

procedure TG2Scene2DComponentCollisionShape.SetFriction(const Value: TG2Float);
begin
  _FixtureDef.friction := Value;
  if _Fixture <> nil then _Fixture^.set_friction(Value);
end;

function TG2Scene2DComponentCollisionShape.GetDensity: TG2Float;
begin
  Result := _FixtureDef.density;
end;

procedure TG2Scene2DComponentCollisionShape.SetDensity(const Value: TG2Float);
begin
  _FixtureDef.density := Value;
  if _Fixture <> nil then _Fixture^.set_density(Value);
end;

function TG2Scene2DComponentCollisionShape.GetRestitution: TG2Float;
begin
  Result := _FixtureDef.restitution;
end;

procedure TG2Scene2DComponentCollisionShape.SetRestitution(const Value: TG2Float);
begin
  _FixtureDef.restitution := Value;
  if _Fixture <> nil then _Fixture^.set_restitution(Value);
end;

function TG2Scene2DComponentCollisionShape.GetIsSensor: Boolean;
begin
  Result := _FixtureDef.is_sensor;
end;

procedure TG2Scene2DComponentCollisionShape.SetIsSensor(const Value: Boolean);
begin
  _FixtureDef.is_sensor := Value;
  if _Fixture <> nil then _Fixture^.set_sensor(Value);
end;

{$Hints off}
procedure TG2Scene2DComponentCollisionShape.OnBeginContact(
  const OtherEntity: TG2Scene2DEntity;
  const OtherShape: TG2Scene2DComponentCollisionShape;
  const Contact: pb2_contact
);
begin
  _EventBeginContactData.Entities[0] := Self.Owner;
  _EventBeginContactData.Entities[1] := OtherEntity;
  _EventBeginContactData.Shapes[0] := Self;
  _EventBeginContactData.Shapes[1] := OtherShape;
  _EventBeginContactData.PhysContact := Contact;
  _EventBeginContact.DispatchEvent(_EventBeginContactData);
end;
{$Hints on}

{$Hints off}
procedure TG2Scene2DComponentCollisionShape.OnEndContact(
  const OtherEntity: TG2Scene2DEntity;
  const OtherShape: TG2Scene2DComponentCollisionShape;
  const Contact: pb2_contact
);
begin
  _EventEndContactData.Entities[0] := Self.Owner;
  _EventEndContactData.Entities[1] := OtherEntity;
  _EventEndContactData.Shapes[0] := Self;
  _EventEndContactData.Shapes[1] := OtherShape;
  _EventEndContactData.PhysContact := Contact;
  _EventEndContact.DispatchEvent(_EventEndContactData);
end;
{$Hints on}

{$Hints off}
procedure TG2Scene2DComponentCollisionShape.OnBeforeContactSolve(
  const OtherEntity: TG2Scene2DEntity;
  const OtherShape: TG2Scene2DComponentCollisionShape;
  const Contact: pb2_contact
);
begin
  _EventBeforeContactSolveData.Entities[0] := Self.Owner;
  _EventBeforeContactSolveData.Entities[1] := OtherEntity;
  _EventBeforeContactSolveData.Shapes[0] := Self;
  _EventBeforeContactSolveData.Shapes[1] := OtherShape;
  _EventBeforeContactSolveData.PhysContact := Contact;
  _EventBeforeContactSolve.DispatchEvent(_EventBeforeContactSolveData);
end;
{$Hints on}

{$Hints off}
procedure TG2Scene2DComponentCollisionShape.OnAfterContactSolve(
  const OtherEntity: TG2Scene2DEntity;
  const OtherShape: TG2Scene2DComponentCollisionShape;
  const Contact: pb2_contact
);
begin
  _EventAfterContactSolveData.Entities[0] := Self.Owner;
  _EventAfterContactSolveData.Entities[1] := OtherEntity;
  _EventAfterContactSolveData.Shapes[0] := Self;
  _EventAfterContactSolveData.Shapes[1] := OtherShape;
  _EventAfterContactSolveData.PhysContact := Contact;
  _EventAfterContactSolve.DispatchEvent(_EventAfterContactSolveData);
end;
{$Hints on}

class constructor TG2Scene2DComponentCollisionShape.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentCollisionShape.GetName: String;
begin
  Result := 'Collision Shape';
end;

{$Hints off}
class function TG2Scene2DComponentCollisionShape.CanAttach(
  const Node: TG2Scene2DEntity
): Boolean;
begin
  Result := True;
end;
{$Hints on}
//TG2Scene2DComponentCollisionShape END

//TG2Scene2DComponentCollisionShapeEdge BEGIN
function TG2Scene2DComponentCollisionShapeEdge.GetHasVertex0: Boolean;
begin
  Result := _EdgeShape.has_vertex0;
end;

function TG2Scene2DComponentCollisionShapeEdge.GetHasVertex3: Boolean;
begin
  Result := _EdgeShape.has_vertex3;
end;

function TG2Scene2DComponentCollisionShapeEdge.GetVertex0: TG2Vec2;
begin
  Result := _EdgeShape.vertex0;
end;

function TG2Scene2DComponentCollisionShapeEdge.GetVertex1: TG2Vec2;
begin
  Result := _EdgeShape.vertex1;
end;

function TG2Scene2DComponentCollisionShapeEdge.GetVertex2: TG2Vec2;
begin
  Result := _EdgeShape.vertex2;
end;

function TG2Scene2DComponentCollisionShapeEdge.GetVertex3: TG2Vec2;
begin
  Result := _EdgeShape.vertex3;
end;

procedure TG2Scene2DComponentCollisionShapeEdge.SetHasVertex0(const Value: Boolean);
begin
  _EdgeShape.has_vertex0 := Value;
end;

procedure TG2Scene2DComponentCollisionShapeEdge.SetHasVertex3(const Value: Boolean);
begin
  _EdgeShape.has_vertex3 := Value;
end;

procedure TG2Scene2DComponentCollisionShapeEdge.SetVertex0(const Value: TG2Vec2);
begin
  _EdgeShape.vertex0 := Value;
end;

procedure TG2Scene2DComponentCollisionShapeEdge.SetVertex1(const Value: TG2Vec2);
begin
  _EdgeShape.vertex1 := Value;
end;

procedure TG2Scene2DComponentCollisionShapeEdge.SetVertex2(const Value: TG2Vec2);
begin
  _EdgeShape.vertex2 := Value;
end;

procedure TG2Scene2DComponentCollisionShapeEdge.SetVertex3(const Value: TG2Vec2);
begin
  _EdgeShape.vertex3 := Value;
end;

procedure TG2Scene2DComponentCollisionShapeEdge.OnInitialize;
begin
  inherited OnInitialize;
  _EdgeShape.create;
  _FixtureDef.shape := @_EdgeShape;
  _EdgeShape.set_edge(b2_vec2(-0.5, 0), b2_vec2(0.5, 0));
end;

procedure TG2Scene2DComponentCollisionShapeEdge.OnFinalize;
begin
  _EdgeShape.destroy;
end;

class constructor TG2Scene2DComponentCollisionShapeEdge.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentCollisionShapeEdge.GetName: String;
begin
  Result := 'Edge Shape';
end;

procedure TG2Scene2DComponentCollisionShapeEdge.SetUp(const v0, v1: TG2Vec2);
begin
  _EdgeShape.set_edge(v0, v1);
end;

procedure TG2Scene2DComponentCollisionShapeEdge.Save(const dm: TG2DataManager);
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  dm.WriteBuffer(@_FixtureDef, SizeOf(_FixtureDef));
  dm.WriteBuffer(@_EdgeShape.vertex0, SizeOf(_EdgeShape.vertex0));
  dm.WriteBuffer(@_EdgeShape.vertex1, SizeOf(_EdgeShape.vertex1));
  dm.WriteBuffer(@_EdgeShape.vertex2, SizeOf(_EdgeShape.vertex2));
  dm.WriteBuffer(@_EdgeShape.vertex3, SizeOf(_EdgeShape.vertex3));
  dm.WriteBool(_EdgeShape.has_vertex0);
  dm.WriteBool(_EdgeShape.has_vertex3);
  dm.WriteStringA(_EventBeginContact.Name);
  dm.WriteStringA(_EventEndContact.Name);
  dm.WriteStringA(_EventBeforeContactSolve.Name);
  dm.WriteStringA(_EventAfterContactSolve.Name);
end;

procedure TG2Scene2DComponentCollisionShapeEdge.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  dm.ReadBuffer(@_FixtureDef, SizeOf(_FixtureDef));
  _FixtureDef.shape := @_EdgeShape;
  dm.ReadBuffer(@_EdgeShape.vertex0, SizeOf(_EdgeShape.vertex0));
  dm.ReadBuffer(@_EdgeShape.vertex1, SizeOf(_EdgeShape.vertex1));
  dm.ReadBuffer(@_EdgeShape.vertex2, SizeOf(_EdgeShape.vertex2));
  dm.ReadBuffer(@_EdgeShape.vertex3, SizeOf(_EdgeShape.vertex3));
  _EdgeShape.has_vertex0 := dm.ReadBool;
  _EdgeShape.has_vertex3 := dm.ReadBool;
  _EventBeginContact.Name := dm.ReadStringA;
  _EventEndContact.Name := dm.ReadStringA;
  _EventBeforeContactSolve.Name := dm.ReadStringA;
  _EventAfterContactSolve.Name := dm.ReadStringA;
  Reattach;
end;
//TG2Scene2DComponentCollisionShapeEdge END

//TG2Scene2DComponentCollisionShapePoly BEGIN
function TG2Scene2DComponentCollisionShapePoly.GetVertices: PG2Vec2Arr;
begin
  Result := PG2Vec2Arr(@_PolyShape.vertices);
end;

function TG2Scene2DComponentCollisionShapePoly.GetVertexCount: TG2IntS32;
begin
  Result := _PolyShape.count;
end;

procedure TG2Scene2DComponentCollisionShapePoly.OnInitialize;
begin
  inherited OnInitialize;
  _PolyShape.create;
  _FixtureDef.shape := @_PolyShape;
end;

procedure TG2Scene2DComponentCollisionShapePoly.OnFinalize;
begin
  _PolyShape.destroy;
end;

class constructor TG2Scene2DComponentCollisionShapePoly.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentCollisionShapePoly.GetName: String;
begin
  Result := 'Polygon Shape';
end;

procedure TG2Scene2DComponentCollisionShapePoly.SetUpBox(const w, h: TG2Float);
begin
  _PolyShape.set_as_box(w, h);
  Reattach;
end;

procedure TG2Scene2DComponentCollisionShapePoly.SetUpBox(
  const w, h: TG2Float;
  const c: TG2Vec2;
  const r: TG2Float
);
begin
  _PolyShape.set_as_box(w * 0.5, h * 0.5, c, r);
  Reattach;
end;

procedure TG2Scene2DComponentCollisionShapePoly.SetUp(
  const v: PG2Vec2Arr;
  const vc: TG2IntS32
);
begin
  _PolyShape.set_polygon(pb2_vec2_arr(v), vc);
  Reattach;
end;

procedure TG2Scene2DComponentCollisionShapePoly.Save(const dm: TG2DataManager);
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  dm.WriteBuffer(@_FixtureDef, SizeOf(_FixtureDef));
  dm.WriteIntS32(_PolyShape.count);
  dm.WriteBuffer(@_PolyShape.vertices, SizeOf(_PolyShape.vertices));
  dm.WriteBuffer(@_PolyShape.normals, SizeOf(_PolyShape.normals));
  dm.WriteBuffer(@_PolyShape.centroid, SizeOf(_PolyShape.centroid));
  dm.WriteStringA(_EventBeginContact.Name);
  dm.WriteStringA(_EventEndContact.Name);
  dm.WriteStringA(_EventBeforeContactSolve.Name);
  dm.WriteStringA(_EventAfterContactSolve.Name);
end;

procedure TG2Scene2DComponentCollisionShapePoly.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  dm.ReadBuffer(@_FixtureDef, SizeOf(_FixtureDef));
  _FixtureDef.shape := @_PolyShape;
  _PolyShape.count := dm.ReadIntS32;
  dm.ReadBuffer(@_PolyShape.vertices, SizeOf(_PolyShape.vertices));
  dm.ReadBuffer(@_PolyShape.normals, SizeOf(_PolyShape.normals));
  dm.ReadBuffer(@_PolyShape.centroid, SizeOf(_PolyShape.centroid));
  _EventBeginContact.Name := dm.ReadStringA;
  _EventEndContact.Name := dm.ReadStringA;
  _EventBeforeContactSolve.Name := dm.ReadStringA;
  _EventAfterContactSolve.Name := dm.ReadStringA;
  Reattach;
end;
//TG2Scene2DComponentCollisionShapePoly END

//TG2Scene2DComponentCollisionShapeBox BEGIN
procedure TG2Scene2DComponentCollisionShapeBox.UpdateProperties;
begin
  inherited SetUpBox(_Width, _Height, _Offset, _Angle);
end;

procedure TG2Scene2DComponentCollisionShapeBox.SetWidth(const Value: TG2Float);
begin
  _Width := Value;
  UpdateProperties;
end;

procedure TG2Scene2DComponentCollisionShapeBox.SetHeight(const Value: TG2Float);
begin
  _Height := Value;
  UpdateProperties;
end;

procedure TG2Scene2DComponentCollisionShapeBox.SetOffset(const Value: TG2Vec2);
begin
  _Offset := Value;
  UpdateProperties;
end;

procedure TG2Scene2DComponentCollisionShapeBox.SetAngle(const Value: TG2Float);
begin
  _Angle := Value;
  UpdateProperties;
end;

procedure TG2Scene2DComponentCollisionShapeBox.SetUp(const v: PG2Vec2Arr; const vc: TG2IntS32);
begin
  inherited SetUp(v, vc);
end;

procedure TG2Scene2DComponentCollisionShapeBox.OnInitialize;
begin
  inherited OnInitialize;
  _Width := 1;
  _Height := 1;
  _Offset.SetValue(0, 0);
  _Angle := 0;
  UpdateProperties;
end;

procedure TG2Scene2DComponentCollisionShapeBox.OnFinalize;
begin
  inherited OnFinalize;
end;

class constructor TG2Scene2DComponentCollisionShapeBox.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentCollisionShapeBox.GetName: String;
begin
  Result := 'Box Shape';
end;

procedure TG2Scene2DComponentCollisionShapeBox.SetUpBox(const w, h: TG2Float);
begin
  _Width := w;
  _Height := h;
  UpdateProperties;
end;

procedure TG2Scene2DComponentCollisionShapeBox.SetUpBox(const w, h: TG2Float; const c: TG2Vec2; const r: TG2Float);
begin
  _Width := w;
  _Height := h;
  _Offset := c;
  _Angle := r;
  UpdateProperties;
end;

procedure TG2Scene2DComponentCollisionShapeBox.Save(const dm: TG2DataManager);
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  dm.WriteBuffer(@_FixtureDef, SizeOf(_FixtureDef));
  dm.WriteFloat(_Width);
  dm.WriteFloat(_Height);
  dm.WriteVec2(_Offset);
  dm.WriteFloat(_Angle);
  dm.WriteStringA(_EventBeginContact.Name);
  dm.WriteStringA(_EventEndContact.Name);
  dm.WriteStringA(_EventBeforeContactSolve.Name);
  dm.WriteStringA(_EventAfterContactSolve.Name);
end;

procedure TG2Scene2DComponentCollisionShapeBox.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  dm.ReadBuffer(@_FixtureDef, SizeOf(_FixtureDef));
  _FixtureDef.shape := @_PolyShape;
  _Width := dm.ReadFloat;
  _Height := dm.ReadFloat;
  _Offset := dm.ReadVec2;
  _Angle := dm.ReadFloat;
  _EventBeginContact.Name := dm.ReadStringA;
  _EventEndContact.Name := dm.ReadStringA;
  _EventBeforeContactSolve.Name := dm.ReadStringA;
  _EventAfterContactSolve.Name := dm.ReadStringA;
  UpdateProperties;
  Reattach;
end;
//TG2Scene2DComponentCollisionShapeBox END

//TG2Scene2DComponentCollisionShapeCircle BEGIN
function TG2Scene2DComponentCollisionShapeCircle.GetCenter: TG2Vec2;
begin
  Result := _CircleShape.center;
end;

procedure TG2Scene2DComponentCollisionShapeCircle.SetCenter(const Value: TG2Vec2);
begin
  _CircleShape.center := Value;
  Reattach;
end;

function TG2Scene2DComponentCollisionShapeCircle.GetRadius: TG2Float;
begin
  Result := _CircleShape.radius;
end;

procedure TG2Scene2DComponentCollisionShapeCircle.SetRadius(const Value: TG2Float);
begin
  _CircleShape.radius := Value;
  Reattach;
end;

procedure TG2Scene2DComponentCollisionShapeCircle.OnInitialize;
begin
  inherited OnInitialize;
  _CircleShape.create;
  _CircleShape.center.set_zero;
  _CircleShape.radius := 1;
  _FixtureDef.shape := @_CircleShape;
end;

procedure TG2Scene2DComponentCollisionShapeCircle.OnFinalize;
begin
  _CircleShape.destroy;
end;

class constructor TG2Scene2DComponentCollisionShapeCircle.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentCollisionShapeCircle.GetName: String;
begin
  Result := 'Cirlce Shape';
end;

procedure TG2Scene2DComponentCollisionShapeCircle.SetUp(
  const c: TG2Vec2;
  const r: TG2Float
);
begin
  _CircleShape.center := c;
  _CircleShape.radius := r;
end;

procedure TG2Scene2DComponentCollisionShapeCircle.Save(const dm: TG2DataManager);
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  dm.WriteBuffer(@_FixtureDef, SizeOf(_FixtureDef));
  dm.WriteBuffer(@_CircleShape.center, SizeOf(_CircleShape.center));
  dm.WriteFloat(_CircleShape.radius);
  dm.WriteStringA(_EventBeginContact.Name);
  dm.WriteStringA(_EventEndContact.Name);
  dm.WriteStringA(_EventBeforeContactSolve.Name);
  dm.WriteStringA(_EventAfterContactSolve.Name);
end;

procedure TG2Scene2DComponentCollisionShapeCircle.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  dm.ReadBuffer(@_FixtureDef, SizeOf(_FixtureDef));
  _FixtureDef.shape := @_CircleShape;
  dm.ReadBuffer(@_CircleShape.center, SizeOf(_CircleShape.center));
  _CircleShape.radius := dm.ReadFloat;
  _EventBeginContact.Name := dm.ReadStringA;
  _EventEndContact.Name := dm.ReadStringA;
  _EventBeforeContactSolve.Name := dm.ReadStringA;
  _EventAfterContactSolve.Name := dm.ReadStringA;
  Reattach;
end;
//TG2Scene2DComponentCollisionShapeCircle END

//TG2Scene2DComponentCollisionShapeChain BEGIN
function TG2Scene2DComponentCollisionShapeChain.GetVertexCount: TG2IntS32;
begin
  Result := _ChainShape.count;
end;

function TG2Scene2DComponentCollisionShapeChain.GetVertexNext: TG2Vec2;
begin
  Result := _ChainShape.next_vertex;
end;

function TG2Scene2DComponentCollisionShapeChain.GetVertexPrev: TG2Vec2;
begin
  Result := _ChainShape.prev_vertex;
end;

function TG2Scene2DComponentCollisionShapeChain.GetVertices: PG2Vec2Arr;
begin
  Result := _ChainShape.vertices;
end;

procedure TG2Scene2DComponentCollisionShapeChain.SetVertexNext(const Value: TG2Vec2);
begin
  _ChainShape.next_vertex := Value;
end;

procedure TG2Scene2DComponentCollisionShapeChain.SetVertexPrev(const Value: TG2Vec2);
begin
  _ChainShape.prev_vertex := Value;
end;

procedure TG2Scene2DComponentCollisionShapeChain.OnInitialize;
begin
  inherited OnInitialize;
  _ChainShape.create;
  _FixtureDef.shape := @_ChainShape;
end;

procedure TG2Scene2DComponentCollisionShapeChain.OnFinalize;
begin
  _ChainShape.destroy;
end;

class constructor TG2Scene2DComponentCollisionShapeChain.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentCollisionShapeChain.GetName: String;
begin
  Result := 'Chain Shape';
end;

procedure TG2Scene2DComponentCollisionShapeChain.SetUp(
  const v: PG2Vec2Arr;
  const vc: TG2IntS32
);
begin
  _ChainShape.set_chain(v, vc);
end;

procedure TG2Scene2DComponentCollisionShapeChain.Save(const dm: TG2DataManager);
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  dm.WriteBuffer(@_FixtureDef, SizeOf(_FixtureDef));
  dm.WriteIntS32(_ChainShape.count);
  dm.WriteBuffer(_ChainShape.vertices, TG2IntS64(SizeOf(_ChainShape.vertices^[0])) * _ChainShape.count);
  dm.WriteBool(_ChainShape.has_next_vertex);
  if (_ChainShape.has_next_vertex) then
  dm.WriteBuffer(@_ChainShape.next_vertex, SizeOf(_ChainShape.next_vertex));
  dm.WriteBool(_ChainShape.has_prev_vertex);
  if (_ChainShape.has_prev_vertex) then
  dm.WriteBuffer(@_ChainShape.prev_vertex, SizeOf(_ChainShape.prev_vertex));
  dm.WriteStringA(_EventBeginContact.Name);
  dm.WriteStringA(_EventEndContact.Name);
  dm.WriteStringA(_EventBeforeContactSolve.Name);
  dm.WriteStringA(_EventAfterContactSolve.Name);
end;

procedure TG2Scene2DComponentCollisionShapeChain.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  dm.ReadBuffer(@_FixtureDef, SizeOf(_FixtureDef));
  _FixtureDef.shape := @_ChainShape;
  _ChainShape.clear;
  _ChainShape.count := dm.ReadIntS32;
  _ChainShape.vertices := pb2_vec2_arr(b2_alloc(_ChainShape.count * SizeOf(tb2_vec2)));
  dm.ReadBuffer(_ChainShape.vertices, _ChainShape.count * TG2IntS64(SizeOf(tb2_vec2)));
  _ChainShape.has_next_vertex := dm.ReadBool;
  if (_ChainShape.has_next_vertex) then
  dm.ReadBuffer(@_ChainShape.next_vertex, SizeOf(_ChainShape.next_vertex))
  else
  _ChainShape.next_vertex.set_zero;
  _ChainShape.has_prev_vertex := dm.ReadBool;
  if (_ChainShape.has_prev_vertex) then
  dm.ReadBuffer(@_ChainShape.prev_vertex, SizeOf(_ChainShape.prev_vertex))
  else
  _ChainShape.prev_vertex.set_zero;
  _EventBeginContact.Name := dm.ReadStringA;
  _EventEndContact.Name := dm.ReadStringA;
  _EventBeforeContactSolve.Name := dm.ReadStringA;
  _EventAfterContactSolve.Name := dm.ReadStringA;
  Reattach;
end;
//TG2Scene2DComponentCollisionShapeChain END

//TG2Scene2DComponentCharacter BEGIN
procedure TG2Scene2DComponentCharacter.SetupShapes;
  var qw, hw, hh, d: TG2Float;
begin
  hw := _Width * 0.5;
  hh := _Height * 0.5;
  qw := hw * 0.5;
  d := (1 - _Duck) * 0.5 + 0.5;
  _BodyVerts[0] := b2_vec2(hw, hh - hw);
  _BodyVerts[1] := b2_vec2(hw, -hh * d + qw);
  _BodyVerts[2] := b2_vec2(hw - qw, -hh * d);
  _BodyVerts[3] := b2_vec2(-hw + qw, -hh * d);
  _BodyVerts[4] := b2_vec2(-hw, -hh * d + qw);
  _BodyVerts[5] := b2_vec2(-hw, hh - hw);
  _BodyVerts[6] := b2_vec2(0, hh - hw * 0.5);
  _DuckCheckVerts[0] := b2_vec2(_BodyVerts[2].x, _BodyVerts[0].y);
  _DuckCheckVerts[1] := b2_vec2(_BodyVerts[2].x, _BodyVerts[2].y);
  _DuckCheckVerts[2] := b2_vec2(_BodyVerts[3].x, _BodyVerts[3].y);
  _DuckCheckVerts[3] := b2_vec2(_BodyVerts[3].x, _BodyVerts[0].y);
  _GroundCheckVerts[0] := b2_vec2(qw + qw * 0.14, hh * 0.5);
  _GroundCheckVerts[1] := b2_vec2(-qw - qw * 0.14, hh * 0.5);
  _GroundCheckVerts[2] := b2_vec2(-qw - qw * 0.14, hh + hh * 0.12);
  _GroundCheckVerts[3] := b2_vec2(qw + qw * 0.14, hh + hh * 0.12);
  _ShapeBody.set_polygon(@_BodyVerts, 7);
  _ShapeFeet.center := b2_vec2(0, 0);
  _ShapeFeet.radius := hw * 0.99;
  _ShapeDuckCheck.set_polygon(@_DuckCheckVerts, 4);
  _ShapeGroundCheck.set_polygon(@_GroundCheckVerts, 4);
end;

procedure TG2Scene2DComponentCharacter.OnInitialize;
begin
  inherited OnInitialize;
  _BodyDef.fixed_rotation := True;
  _BodyDef.body_type := b2_dynamic_body;
  _BodyDef.linear_damping := 0.5;
  _BodyFeetDef := b2_body_def;
  _BodyFeetDef.body_type := b2_dynamic_body;
  _FixtureBodyDef := b2_fixture_def;
  _FixtureBodyDef.friction := 0;
  _FixtureBodyDef.density := 3;
  _FixtureBodyDef.user_data := Self;
  _FixtureFeetDef := b2_fixture_def;
  _FixtureFeetDef.friction := 4;
  _FixtureFeetDef.density := 3;
  _FixtureFeetDef.user_data := Self;
  _ShapeBody.create;
  _FixtureBodyDef.shape := @_ShapeBody;
  _ShapeFeet.create;
  _FixtureFeetDef.shape := @_ShapeFeet;
  _ShapeDuckCheck.create;
  _ShapeGroundCheck.create;
  _Width := 0.5;
  _Height := 1;
  _WalkSpeed := 0;
  _JumpSpeed := G2Vec2;
  _JumpDelay := 0;
  _GlideSpeed := G2Vec2;
  _MaxGlideSpeed := 2;
  _Standing := False;
  _FootContactCount := 0;
  _Duck := 0;
  _DuckCheckContacts := 0;
  SetupShapes;
end;

procedure TG2Scene2DComponentCharacter.OnFinalize;
begin
  _ShapeGroundCheck.destroy;
  _ShapeDuckCheck.destroy;
  _ShapeFeet.destroy;
  _ShapeBody.destroy;
  inherited OnFinalize;
end;

procedure TG2Scene2DComponentCharacter.OnUpdate;
  var n: TG2Vec2;
  var d, f: TG2Float;
  var c: pb2_contact_edge;
begin
  if _JumpDelay > 0 then _JumpDelay -= g2.DeltaTimeSec;
  _Standing := _FootContactCount > 0;
  if (_FixtureFeet <> nil) then
  begin
    if _Standing then f := 4 else f := 0;
    if Abs(_FixtureFeet^.get_friction - f) > G2EPS then
    begin
      _FixtureFeet^.set_friction(f);
      c := _BodyFeet^.get_contact_list;
      while c <> nil do
      begin
        c^.contact^.reset_friction;
        c := c^.next;
      end;
    end;
  end;
  if _Standing and (_Body <> nil) and (_JumpDelay <= 0) and (Abs(_JumpSpeed.LenSq) > G2EPS2) then
  begin
    n := _JumpSpeed.Norm;
    d := n.Dot(_Body^.get_linear_velocity);
    _Body^.set_linear_velocity(_Body^.get_linear_velocity - n * Abs(d) + _JumpSpeed);
    _JumpDelay := 0.1;
  end;
  _JumpSpeed.SetZero;
  if (_BodyFeet <> nil) and (Abs(_WalkSpeed) > G2EPS2) then
  begin
    _BodyFeet^.set_fixed_rotation(false);
    _BodyFeet^.set_angular_velocity(_WalkSpeed);
  end
  else
  begin
    _BodyFeet^.set_angular_velocity(0);
    _BodyFeet^.set_fixed_rotation(true);
  end;
  _WalkSpeed := 0;
  if not _Standing and (_Body <> nil) and (Abs(_GlideSpeed.LenSq) > G2EPS2) then
  begin
    n := _GlideSpeed.Norm;
    d := n.Dot(_Body^.get_linear_velocity);
    if d < _MaxGlideSpeed then
    begin
      d := G2Min(_GlideSpeed.Len, G2Max(_MaxGlideSpeed - d, 0));
      _Body^.set_linear_velocity(_Body^.get_linear_velocity + n * d);
    end;
  end;
  _GlideSpeed.SetZero;
  inherited OnUpdate;
end;

procedure TG2Scene2DComponentCharacter.SetEnabled(const Value: Boolean);
  var bd: tb2_body_def;
  var fd: tb2_fixture_def;
  var jd: tb2_revolute_joint_def;
begin
  if Value = _Enabled then Exit;
  if not Value then
  begin
    _Duck := 0;
    _Scene.PhysWorld.destroy_joint(_Joint);
    _Body^.destroy_fixture(_FixtureGroundCheck);
    _Body^.destroy_fixture(_FixtureDuckCheck);
    _BodyFeet^.destroy_fixture(_FixtureFeet);
    _Body^.destroy_fixture(_FixtureBody);
    Scene.PhysWorld.destroy_body(_BodyFeet);
    _Joint := nil;
    _FixtureFeet := nil;
    _FixtureBody := nil;
    _BodyFeet := nil;
  end;
  inherited SetEnabled(Value);
  if _Enabled then
  begin
    _DuckCheckContacts := 0;
    _FixtureBodyDef.shape := @_ShapeBody;
    _FixtureFeetDef.shape := @_ShapeFeet;
    bd := _BodyFeetDef;
    bd.body_type := b2_dynamic_body;
    bd.angle := bd.angle + Owner.Transform.r.Angle;
    bd.position := Owner.Transform.Transform(G2Vec2(0, _Height * 0.5 - _Width * 0.5));
    _BodyFeet := Scene.PhysWorld.create_body(bd);
    _FixtureBody := _Body^.create_fixture(_FixtureBodyDef);
    _FixtureFeet := _BodyFeet^.create_fixture(_FixtureFeetDef);
    fd := b2_fixture_def;
    fd.is_sensor := True;
    fd.shape := @_ShapeDuckCheck;
    fd.user_data := Self;
    _FixtureDuckCheck := _Body^.create_fixture(fd);
    fd := b2_fixture_def;
    fd.is_sensor := True;
    fd.shape := @_ShapeGroundCheck;
    fd.user_data := Self;
    _FixtureGroundCheck := _Body^.create_fixture(fd);
    jd := b2_revolute_joint_def;
    jd.initialize(_Body, _BodyFeet, bd.position);
    _Joint := _Scene.PhysWorld.create_joint(jd);
    _Body^.get_mass_data(_BodyMassData);
  end;
end;

procedure TG2Scene2DComponentCharacter.SetWidth(const Value: TG2Float);
begin
  if Abs(_Width - Value) <= G2EPS2 then Exit;
  _Width := Value;
  SetupShapes;
  if _Enabled then
  begin
    Enabled := False;
    Enabled := True;
  end;
end;

procedure TG2Scene2DComponentCharacter.SetHeight(const Value: TG2Float);
begin
  if Abs(_Height - Value) <= G2EPS2 then Exit;
  _Height := Value;
  SetupShapes;
  if _Enabled then
  begin
    Enabled := False;
    Enabled := True;
  end;
end;

procedure TG2Scene2DComponentCharacter.SetDuck(const Value: TG2Float);
  var v: TG2Float;
begin
  if not _Enabled then Exit;
  v := G2Clamp(Value, 0, 1);
  if Abs(_Duck - v) <= G2EPS2 then Exit;
  if (_DuckCheckContacts > 0) and (Value < _Duck) then Exit;
  _Duck := Value;
  SetupShapes;
  if _Body <> nil then
  begin
    _Body^.destroy_fixture(_FixtureBody);
    _FixtureBody := _Body^.create_fixture(_FixtureBodyDef);
    _Body^.set_mass_data(_BodyMassData);
  end;
end;

{$Hints off}
procedure TG2Scene2DComponentCharacter.OnBeginContact(
  const OtherEntity: TG2Scene2DEntity;
  const OtherShape: TG2Scene2DComponentCollisionShape;
  const SelfFixture: pb2_fixture; const Contact: pb2_contact);
begin
  if SelfFixture = _FixtureGroundCheck then
  begin
    if _FootContactCount = 0 then _JumpDelay := 0.1;
    Inc(_FootContactCount);
  end
  else if SelfFixture = _FixtureDuckCheck then
  Inc(_DuckCheckContacts);
end;
{$Hints on}

{$Hints off}
procedure TG2Scene2DComponentCharacter.OnEndContact(
  const OtherEntity: TG2Scene2DEntity;
  const OtherShape: TG2Scene2DComponentCollisionShape;
  const SelfFixture: pb2_fixture; const Contact: pb2_contact);
begin
  if SelfFixture = _FixtureGroundCheck then
  Dec(_FootContactCount)
  else if SelfFixture = _FixtureDuckCheck then
  Dec(_DuckCheckContacts);
end;
{$Hints on}

{$Hints off}
procedure TG2Scene2DComponentCharacter.OnBeforeContactSolve(
  const OtherEntity: TG2Scene2DEntity;
  const OtherShape: TG2Scene2DComponentCollisionShape;
  const SelfFixture: pb2_fixture; const Contact: pb2_contact);
begin

end;
{$Hints on}

{$Hints off}
procedure TG2Scene2DComponentCharacter.OnAfterContactSolve(
  const OtherEntity: TG2Scene2DEntity;
  const OtherShape: TG2Scene2DComponentCollisionShape;
  const SelfFixture: pb2_fixture; const Contact: pb2_contact);
begin

end;
{$Hints on}

class constructor TG2Scene2DComponentCharacter.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentCharacter.GetName: String;
begin
  Result := 'Character';
end;

procedure TG2Scene2DComponentCharacter.Walk(const Speed: TG2Float);
begin
  _WalkSpeed := Speed;
end;

procedure TG2Scene2DComponentCharacter.Jump(const Speed: TG2Vec2);
begin
  if _Standing then _JumpSpeed := Speed;
end;

procedure TG2Scene2DComponentCharacter.Glide(const Speed: TG2Vec2);
begin
  if not _Standing then _GlideSpeed := Speed;
end;

procedure TG2Scene2DComponentCharacter.Save(const dm: TG2DataManager);
  var xf: TG2Transform2;
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  xf := Transform;
  dm.WriteBuffer(@xf, SizeOf(xf));
  dm.WriteFloat(_Width);
  dm.WriteFloat(_Height);
  dm.WriteBuffer(@_BodyDef, SizeOf(_BodyDef));
  dm.WriteBuffer(@_BodyFeetDef, SizeOf(_BodyFeetDef));
  dm.WriteBuffer(@_FixtureBodyDef, SizeOf(_FixtureBodyDef));
  dm.WriteBuffer(@_FixtureFeetDef, SizeOf(_FixtureFeetDef));
  dm.WriteFloat(_MaxGlideSpeed);
  dm.WriteBool(_Enabled);
end;

procedure TG2Scene2DComponentCharacter.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
  var b: Boolean;
  var xf: TG2Transform2;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  {$Hints off}
  dm.ReadBuffer(@xf, SizeOf(xf));
  {$Hints on}
  _Width := dm.ReadFloat;
  _Height := dm.ReadFloat;
  dm.ReadBuffer(@_BodyDef, SizeOf(_BodyDef));
  dm.ReadBuffer(@_BodyFeetDef, SizeOf(_BodyFeetDef));
  dm.ReadBuffer(@_FixtureBodyDef, SizeOf(_FixtureBodyDef));
  dm.ReadBuffer(@_FixtureFeetDef, SizeOf(_FixtureFeetDef));
  _MaxGlideSpeed := dm.ReadFloat;
  b := dm.ReadBool;
  _FixtureBodyDef.user_data := Self;
  _FixtureFeetDef.user_data := Self;
  SetupShapes;
  Enabled := b;
  Transform := xf;
end;
//TG2Scene2DComponentCharacter END

//TG2Scene2DComponentPoly BEGIN
function TG2Scene2DComponentPoly.TG2Scene2DComponentPolyLayer.GetVisible: Boolean;
begin
  Result := _Hook <> nil;
end;

procedure TG2Scene2DComponentPoly.TG2Scene2DComponentPolyLayer.SetVisible(const Value: Boolean);
begin
  if GetVisible = Value then Exit;
  if _Hook <> nil then _Owner.Scene.RenderHookRemove(_Hook);
  if Value then
  begin
    _Hook := _Owner.Scene.RenderHookAdd(@OnRender, _Layer);
  end;
end;

procedure TG2Scene2DComponentPoly.TG2Scene2DComponentPolyLayer.SetLayer(const Value: TG2IntS32);
begin
  if Value = _Layer then Exit;
  _Layer := Value;
  if _Hook <> nil then
  _Hook.Layer := _Layer;
end;

procedure TG2Scene2DComponentPoly.TG2Scene2DComponentPolyLayer.OnRender(const Display: TG2Display2D);
begin
  _Owner.RenderLayer(Self, Display);
end;

procedure TG2Scene2DComponentPoly.TG2Scene2DComponentPolyLayer.SetTexture(const Value: TG2Texture2DBase);
begin
  if Value = _Texture then Exit;
  if Assigned(_Texture) then _Texture.RefDec;
  _Texture := Value;
  if Assigned(_Texture) then _Texture.RefInc;
end;

function TG2Scene2DComponentPoly.TG2Scene2DComponentPolyLayer.GetScale: TG2Vec2;
begin
  Result := G2Vec2(1 / _Scale.x, 1 / _Scale.y);
end;

procedure TG2Scene2DComponentPoly.TG2Scene2DComponentPolyLayer.SetScale(const Value: TG2Vec2);
begin
  if Value.x > 0 then _Scale.x := 1 / Value.x else _Scale.x := 1;
  if Value.y > 0 then _Scale.y := 1 / Value.y else _Scale.y := 1;
end;

constructor TG2Scene2DComponentPoly.TG2Scene2DComponentPolyLayer.Create(const Component: TG2Scene2DComponentPoly);
begin
  inherited Create;
  _Owner := Component;
  SetLength(Color, Length(_Owner._Vertices));
  FillChar(Color[0], SizeOf(TG2Color) * Length(Color), $ff);
  Scale := G2Vec2(1, 1);
  _Texture := nil;
  _Hook := nil;
  _Layer := 0;
end;

destructor TG2Scene2DComponentPoly.TG2Scene2DComponentPolyLayer.Destroy;
begin
  Texture := nil;
  if _Hook <> nil then _Owner.Scene.RenderHookRemove(_Hook);
  inherited Destroy;
end;

procedure TG2Scene2DComponentPoly.ClearLayers;
  var i: Integer;
begin
  for i := 0 to High(_Layers) do
  _Layers[i].Free;
end;

procedure TG2Scene2DComponentPoly.CreateLayers;
  var i: TG2IntS32;
begin
  for i := 0 to High(_Layers) do
  begin
    _Layers[i] := TG2Scene2DComponentPolyLayer.Create(Self);
  end;
end;

procedure TG2Scene2DComponentPoly.SetDebugLayer(const Value: TG2IntS32);
begin
  if _DebugLayer = Value then Exit;
  _DebugLayer := Value;
  if _DebugRenderHook <> nil then
  begin
    _DebugRenderHook.Layer := _DebugLayer;
  end;
end;

procedure TG2Scene2DComponentPoly.SetDebugRender(const Value: Boolean);
begin
  if _DebugRender = Value then Exit;
  _DebugRender := Value;
  if _DebugRender then
  begin
    _DebugRenderHook := Scene.RenderHookAdd(@OnDebugRender, _DebugLayer);
  end
  else
  begin
    Scene.RenderHookRemove(_DebugRenderHook);
  end;
end;

function TG2Scene2DComponentPoly.GetLayerCount: TG2IntS32;
begin
  Result := Length(_Layers);
end;

procedure TG2Scene2DComponentPoly.SetLayerCount(const Value: TG2IntS32);
  var i, n: TG2IntS32;
begin
  if Value = Length(_Layers) then
  begin
    Exit;
  end
  else if Value > Length(_Layers) then
  begin
    n := Length(_Layers);
    SetLength(_Layers, Value);
    for i := n to High(_Layers) do
    begin
      _Layers[i] := TG2Scene2DComponentPolyLayer.Create(Self);
    end;
  end
  else
  begin
    for i := Value to High(_Layers) do
    begin
      _Layers[i].Free;
    end;
    SetLength(_Layers, Value);
  end;
end;

function TG2Scene2DComponentPoly.GetLayer(const Index: TG2IntS32): TG2Scene2DComponentPolyLayer;
begin
  Result := _Layers[Index];
end;

procedure TG2Scene2DComponentPoly.RenderLayer(const Layer: TG2Scene2DComponentPolyLayer; const Display: TG2Display2D);
  var i, j: Integer;
  var v, t: TG2Vec2;
  var c: TG2Color;
begin
  if not _Visible then Exit;
  if (Owner = nil) or (Layer.Texture = nil) then Exit;
  Display.PolyBegin(ptTriangles, Layer.Texture, bmNormal, tfLinear);
  for i := 0 to High(_Faces) do
  begin
    for j := 0 to 2 do
    begin
      v := G2Vec2(_Vertices[_Faces[i][j]].x, _Vertices[_Faces[i][j]].y);
      c := Layer.Color[_Faces[i][j]];
      t := G2Vec2(v.x + _Vertices[_Faces[i][j]].u, v.y + _Vertices[_Faces[i][j]].v) * Layer.ScaleRcp;
      v := Owner.Transform.Transform(v);
      Display.PolyAdd(v, t, c);
    end;
  end;
  Display.PolyEnd;
end;

function TG2Scene2DComponentPoly.GetVertexCount: TG2IntS32;
begin
  Result := Length(_Vertices);
end;

function TG2Scene2DComponentPoly.GetVertex(const Index: TG2IntS32): PG2Scene2DComponentPolyVertex;
begin
  Result := @_Vertices[Index];
end;

function TG2Scene2DComponentPoly.GetFaceCount: TG2IntS32;
begin
  Result := Length(_Faces);
end;

function TG2Scene2DComponentPoly.GetFace(const Index: TG2IntS32): PG2IntU16Arr;
begin
  Result := @_Faces[Index][0];
end;

procedure TG2Scene2DComponentPoly.OnInitialize;
begin
  _Layers := nil;
  _DebugLayer := 100;
  _DebugRender := False;
  _DebugRenderHook := nil;
  _Visible := True;
end;

procedure TG2Scene2DComponentPoly.OnFinalize;
begin
  if _DebugRenderHook <> nil then Scene.RenderHookRemove(_DebugRenderHook);
  ClearLayers;
end;

procedure TG2Scene2DComponentPoly.OnAttach;
begin
  if _DebugRender then _DebugRenderHook := Scene.RenderHookAdd(@OnDebugRender, _DebugLayer);
end;

procedure TG2Scene2DComponentPoly.OnDetach;
begin
  if _DebugRenderHook <> nil then Scene.RenderHookRemove(_DebugRenderHook);
end;

procedure TG2Scene2DComponentPoly.OnDebugRender(const Display: TG2Display2D);
  var i, j, n: TG2IntS32;
  var v: TG2Vec2;
begin
  Display.PrimBegin(ptLines, bmNormal);
  for i := 0 to High(_Faces) do
  begin
    for j := 0 to 2 do
    begin
      n := (j + 1) mod 3;
      v := Owner.Transform.Transform(G2Vec2(_Vertices[_Faces[i][j]].x, _Vertices[_Faces[i][j]].y));
      Display.PrimAdd(v, $ff0000ff);
      v := Owner.Transform.Transform(G2Vec2(_Vertices[_Faces[i][n]].x, _Vertices[_Faces[i][n]].y));
      Display.PrimAdd(v, $ff0000ff);
    end;
  end;
  Display.PrimEnd;
end;

{$Hints off}
procedure TG2Scene2DComponentPoly.OnRender(const Display: TG2Display2D);
begin

end;
{$Hints on}

class constructor TG2Scene2DComponentPoly.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

{$Hints off}
class function TG2Scene2DComponentPoly.CanAttach(const Node: TG2Scene2DEntity): Boolean;
begin
  Result := True;
end;
{$Hints on}

class function TG2Scene2DComponentPoly.GetName: String;
begin
  Result := 'Polygone Mesh';
end;

procedure TG2Scene2DComponentPoly.SetUp(const Triangles: PG2Vec2Arr; const TriangleCount: TG2IntS32);
  var vc, fc: TG2IntS32;
  function AddVertex(const v: TG2Vec2): TG2IntU16;
    var i: TG2IntS32;
  begin
    for i := 0 to vc - 1 do
    if (v - G2Vec2(_Vertices[i].x, _Vertices[i].y)).LenSq <= G2EPS then
    begin
      Result := i;
      Exit;
    end;
    Result := vc;
    _Vertices[vc].x := v.x;
    _Vertices[vc].y := v.y;
    _Vertices[vc].u := 0;
    _Vertices[vc].v := 0;
    Inc(vc);
  end;
  procedure AddTri(const v0, v1, v2: TG2Vec2);
  begin
    _Faces[fc][0] := AddVertex(v0);
    _Faces[fc][1] := AddVertex(v1);
    _Faces[fc][2] := AddVertex(v2);
    Inc(fc);
  end;
  var i: Integer;
begin
  SetLength(_Vertices, TriangleCount * 3);
  SetLength(_Faces, TriangleCount);
  vc := 0;
  fc := 0;
  for i := 0 to TriangleCount - 1 do
  AddTri(Triangles^[i * 3 + 0], Triangles^[i * 3 + 1], Triangles^[i * 3 + 2]);
  if vc < Length(_Vertices) then SetLength(_Vertices, vc);
  ClearLayers;
  CreateLayers;
end;

procedure TG2Scene2DComponentPoly.SetUp(
  const NewVertices: PG2Vec2; const NewVertexCount, VertexStride: TG2IntS32;
  const NewIndices: PG2IntU16; const NewIndexCount, IndexStride: TG2IntS32;
  const NewTexCoords: PG2Vec2; const TexCoordStride: TG2IntS32
);
  var pv: PG2Vec2;
  var pt: PG2Vec2;
  var pi: PG2IntU16;
  var i: TG2IntS32;
begin
  pv := NewVertices;
  pt := NewTexCoords;
  SetLength(_Vertices, NewVertexCount);
  for i := 0 to NewVertexCount - 1 do
  begin
    _Vertices[i].x := pv^.x;
    _Vertices[i].y := pv^.y;
    _Vertices[i].u := pt^.x;
    _Vertices[i].v := pt^.y;
    pv := PG2Vec2(Pointer(pv) + VertexStride);
    pt := PG2Vec2(Pointer(pt) + TexCoordStride);
  end;
  pi := NewIndices;
  SetLength(_Faces, NewIndexCount div 3);
  for i := 0 to (NewIndexCount div 3) - 1 do
  begin
    _Faces[i][0] := pi^;
    pi := PG2IntU16(Pointer(pi) + IndexStride);
    _Faces[i][1] := pi^;
    pi := PG2IntU16(Pointer(pi) + IndexStride);
    _Faces[i][2] := pi^;
    pi := PG2IntU16(Pointer(pi) + IndexStride);
  end;
  ClearLayers;
  CreateLayers;
end;

procedure TG2Scene2DComponentPoly.Save(const dm: TG2DataManager);
  var i: TG2IntS32;
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  dm.WriteIntS32(Length(_Vertices));
  dm.WriteBuffer(@_Vertices[0], TG2IntS64(SizeOf(TG2Scene2DComponentPolyVertex)) * Length(_Vertices));
  dm.WriteIntS32(Length(_Faces));
  dm.WriteBuffer(@_Faces[0], TG2IntS64(SizeOf(_Faces[0])) * Length(_Faces));
  dm.WriteIntS32(Length(_Layers));
  for i := 0 to High(_Layers) do
  begin
    dm.WriteBuffer(@_Layers[i].Color[0], TG2IntS64(SizeOf(TG2Color)) * Length(_Vertices));
    dm.WriteVec2(_Layers[i].Scale);
    if Assigned(_Layers[i].Texture)
    and _Layers[i].Texture.IsShared then
    begin
      dm.WriteStringA(_Layers[i].Texture.AssetName);
    end
    else
    begin
      dm.WriteIntS32(0);
    end;
    dm.WriteIntS32(_Layers[i].Layer);
    dm.WriteBool(_Layers[i].Visible);
  end;
end;

procedure TG2Scene2DComponentPoly.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
  var i, n: TG2IntS32;
  var TexFile: String;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  n := dm.ReadIntS32;
  SetLength(_Vertices, n);
  dm.ReadBuffer(@_Vertices[0], TG2IntS64(SizeOf(TG2Scene2DComponentPolyVertex)) * Length(_Vertices));
  n := dm.ReadIntS32;
  SetLength(_Faces, n);
  dm.ReadBuffer(@_Faces[0], TG2IntS64(SizeOf(_Faces[0])) * Length(_Faces));
  n := dm.ReadIntS32;
  SetLength(_Layers, n);
  CreateLayers;
  for i := 0 to High(_Layers) do
  begin
    dm.ReadBuffer(@_Layers[i].Color[0], TG2IntS64(SizeOf(TG2Color)) * Length(_Vertices));
    _Layers[i].Scale := dm.ReadVec2;
    TexFile := dm.ReadStringA;
    if Length(TexFile) > 0 then
    begin
      _Layers[i].Texture := TG2Texture2D.SharedAsset(TexFile);
    end;
    _Layers[i].Layer := dm.ReadIntS32;
    _Layers[i].Visible := dm.ReadBool;
  end;
end;
//TG2Scene2DComponentPoly END

//TG2Scene2DComponentProperties BEGIN
function TG2Scene2DComponentProperties.TProp.IsInt: Boolean;
begin
  Result := StrToIntDef(Value, 0) = StrToIntDef(Value, 1);
end;

function TG2Scene2DComponentProperties.TProp.IsFloat: Boolean;
begin
  Result := Abs(StrToFloatDef(Value, 1) - StrToFloatDef(Value, 0)) < G2EPS2;
end;

function TG2Scene2DComponentProperties.TProp.AsInt: TG2IntS32;
begin
  Result := StrToIntDef(Value, 0);
end;

function TG2Scene2DComponentProperties.TProp.AsFloat: TG2Float;
begin
  Result := StrToFloatDef(Value, 0);
end;

function TG2Scene2DComponentProperties.GetCount: TG2IntS32;
begin
  Result := Length(_Props);
end;

function TG2Scene2DComponentProperties.GetProp(const Index: TG2IntS32): PProp;
begin
  Result := _Props[Index];
end;

class constructor TG2Scene2DComponentProperties.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentProperties.CanAttach(const Node: TG2Scene2DEntity): Boolean;
begin
  Result := Node.ComponentOfType[TG2Scene2DComponentProperties] = nil;
end;

function TG2Scene2DComponentProperties.FindIndex(const Name: String): TG2IntS32;
  var i: TG2IntS32;
begin
  for i := 0 to High(_Props) do
  if _Props[i]^.Name = Name then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;

function TG2Scene2DComponentProperties.Find(const Name: String): PProp;
  var i: TG2IntS32;
begin
  i := FindIndex(Name);
  if i > -1 then Exit(_Props[i]);
  Result := nil;
end;

procedure TG2Scene2DComponentProperties.Add(const Name: String; const Value: String);
  var i: TG2IntS32;
  var Prop: PProp;
begin
  New(Prop);
  Prop^.Name := Name;
  Prop^.Value := Value;
  i := Length(_Props);
  SetLength(_Props, i + 1);
  _Props[i] := Prop;
end;

procedure TG2Scene2DComponentProperties.Delete(const Index: TG2IntS32);
  var i: TG2IntS32;
begin
  if (Index < 0) or (Index > High(_Props)) then Exit;
  Dispose(_Props[Index]);
  for i := High(_Props) - 1 downto Index do
  begin
    _Props[i] := _Props[i + 1];
  end;
  SetLength(_Props, Length(_Props) - 1);
end;

procedure TG2Scene2DComponentProperties.Delete(const Name: String);
  var i: TG2IntS32;
begin
  i := FindIndex(Name);
  if i > -1 then
  begin
    Delete(i);
  end;
end;

procedure TG2Scene2DComponentProperties.Save(const dm: TG2DataManager);
  var i: TG2IntS32;
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  dm.WriteIntS32(Length(_Props));
  for i := 0 to High(_Props) do
  begin
    dm.WriteStringA(_Props[i]^.Name);
    dm.WriteStringA(_Props[i]^.Value);
  end;
end;

procedure TG2Scene2DComponentProperties.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
  var i, n: TG2IntS32;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  n := dm.ReadIntS32;
  SetLength(_Props, n);
  for i := 0 to n - 1 do
  begin
    New(_Props[i]);
    _Props[i]^.Name := dm.ReadStringA;
    _Props[i]^.Value := dm.ReadStringA;
  end;
end;
//TG2Scene2DComponentProperties END

//TG2Scene2DComponentStrings BEGIN
procedure TG2Scene2DComponentStrings.SetText(const Value: TG2TextAsset);
begin
  if _Text = Value then Exit;
  if Assigned(_Text) and _Text.IsShared then _Text.RefDec;
  _Text := Value;
  if Assigned(_Text) and _Text.IsShared then _Text.RefInc;
end;

procedure TG2Scene2DComponentStrings.OnInitialize;
begin
  inherited OnInitialize;
  _Text := nil;
end;

procedure TG2Scene2DComponentStrings.OnFinalize;
begin
  inherited OnFinalize;
end;

class constructor TG2Scene2DComponentStrings.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentStrings.CanAttach(const Node: TG2Scene2DEntity): Boolean;
begin
  Result := True;
end;

class function TG2Scene2DComponentStrings.GetName: String;
begin
  Result := 'Text Data';
end;

procedure TG2Scene2DComponentStrings.Save(const dm: TG2DataManager);
begin
  SaveClassType(dm);
  SaveVersion(dm);
  SaveTags(dm);
  if Assigned(_Text)
  and _Text.IsShared then
  begin
    dm.WriteStringA(_Text.AssetName);
  end
  else
  begin
    dm.WriteStringA('');
  end;
end;

procedure TG2Scene2DComponentStrings.Load(const dm: TG2DataManager);
  var {%H-}Version: TG2IntU16;
  var AssetName: String;
begin
  Version := LoadVersion(dm);
  LoadTags(dm);
  AssetName := dm.ReadStringA;
  if Length(AssetName) > 0 then
  begin
    Text := TG2TextAsset.SharedAsset(AssetName);
  end
  else
  begin
    Text := nil;
  end;
end;
//TG2Scene2DComponentStrings END

operator := (v: tb2_vec2): TG2Vec2;
begin
  Result := PG2Vec2(@v)^;
end;

operator := (v: TG2Vec2): tb2_vec2;
begin
  Result := pb2_vec2(@v)^;
end;

operator := (r: tb2_rot): TG2Rotation2;
begin
  Result.c := r.c;
  Result.s := r.s;
end;

operator := (r: TG2Rotation2): tb2_rot;
begin
  Result.c := r.c;
  Result.s := r.s;
end;

operator := (t: tb2_transform): TG2Transform2;
begin
  Result.p := t.p;
  Result.r := t.q;
end;

operator := (t: TG2Transform2): tb2_transform;
begin
  Result.p := t.p;
  Result.q := t.r;
end;

operator := (varr: pb2_vec2_arr): PG2Vec2Arr;
begin
  Result := PG2Vec2Arr(@(varr^));
end;

operator := (varr: PG2Vec2Arr): pb2_vec2_arr;
begin
  Result := pb2_vec2_arr(@(varr^));
end;

end.
