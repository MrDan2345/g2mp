unit G2Scene2D;

interface

uses
  Types,
  Classes,
  SysUtils,
  G2Types,
  G2Utils,
  Gen2MP,
  G2DataManager,
  G2Math,
  box2d;

type
  TG2Scene2DComponent = class;
  TG2Scene2DEntity = class;
  TG2Scene2DJoint = class;
  TG2Scene2DRenderHook = class;
  TG2Scene2D = class;
  TG2Scene2DComponentRigidBody = class;
  TG2Scene2DComponentCollisionShape = class;

  CG2Scene2DComponent = class of TG2Scene2DComponent;

  TG2Scene2DComponentCallbackObj = procedure (const Component: TG2Scene2DComponent) of Object;

  TG2Scene2DEventData = class
  protected
    var _EventType: TG2IntU16;
  public
    property EventType: TG2IntU16 read _EventType;
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
    var _ProcOnAttach: TG2Scene2DComponentCallbackObj;
    var _ProcOnDetach: TG2Scene2DComponentCallbackObj;
    var _ProcOnFinalize: TG2Scene2DComponentCallbackObj;
    procedure SetOwner(const Value: TG2Scene2DEntity); inline;
  protected
    var _EventDispatchers: specialize TG2QuickListG<TG2Scene2DEventDispatcher>;
    procedure OnInitialize; virtual;
    procedure OnFinalize; virtual;
    procedure OnAttach; virtual;
    procedure OnDetach; virtual;
    procedure SaveClassType(const Stream: TStream);
  public
    class constructor CreateClass;
    class function GetName: String; virtual;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; virtual;
    property UserData: Pointer read _UserData write _UserData;
    property Scene: TG2Scene2D read _Scene;
    property Owner: TG2Scene2DEntity read _Owner write SetOwner;
    property CallbackOnAttach: TG2Scene2DComponentCallbackObj read _ProcOnAttach write _ProcOnAttach;
    property CallbackOnDetach: TG2Scene2DComponentCallbackObj read _ProcOnDetach write _ProcOnDetach;
    property CallbackOnFinalize: TG2Scene2DComponentCallbackObj read _ProcOnFinalize write _ProcOnFinalize;
    constructor Create(const OwnerScene: TG2Scene2D); virtual;
    destructor Destroy; override;
    procedure Attach(const Entity: TG2Scene2DEntity);
    procedure Detach;
    procedure AddEvent(const EventName: String; const Event: TG2Scene2DEvent);
    procedure RemoveEvent(const EventName: String; const Event: TG2Scene2DEvent);
    procedure Save(const Stream: TStream); virtual;
    procedure Load(const Stream: TStream); virtual;
  end;

  TG2Scene2DComponentList = specialize TG2QuickListG<TG2Scene2DComponent>;
  TG2Scene2DEntityList = specialize TG2QuickListG<TG2Scene2DEntity>;

  TG2Scene2DEntity = class
  private
    var _UserData: Pointer;
    var _GUID: String;
    var _EventDispatchers: specialize TG2QuickListG<TG2Scene2DEventDispatcher>;
    function GetChild(const Index: TG2IntS32): TG2Scene2DEntity; inline;
    function GetChildCount: TG2IntS32; inline;
    function GetComponent(const Index: TG2IntS32): TG2Scene2DComponent; inline;
    function GetComponentCount: TG2IntS32; inline;
    function GetComponentOfType(const ComponentType: CG2Scene2DComponent): TG2Scene2DComponent; inline;
    procedure SetTransformIsolated(const Value: TG2Transform2); inline;
    procedure SetParent(const Value: TG2Scene2DEntity); inline;
    procedure AddComponent(const Component: TG2Scene2DComponent); inline;
    procedure RemoveComponent(const Component: TG2Scene2DComponent); inline;
  protected
    var _Scene: TG2Scene2D;
    var _Parent: TG2Scene2DEntity;
    var _Children: TG2Scene2DEntityList;
    var _Components: TG2Scene2DComponentList;
    var _Transform: TG2Transform2;
    var _Name: AnsiString;
    procedure SetTransform(const Value: TG2Transform2); virtual;
    procedure AddChild(const Child: TG2Scene2DEntity); virtual;
    procedure RemoveChild(const Child: TG2Scene2DEntity); virtual;
    procedure OnDebugDraw(const Display: TG2Display2D); virtual;
    procedure OnRender(const Display: TG2Display2D); virtual;
  public
    property UserData: Pointer read _UserData write _UserData;
    property GUID: String read _GUID;
    property Scene: TG2Scene2D read _Scene;
    property Parent: TG2Scene2DEntity read _Parent write SetParent;
    property Children[const Index: TG2IntS32]: TG2Scene2DEntity read GetChild;
    property ChildCount: TG2IntS32 read GetChildCount;
    property Components[const Index: TG2IntS32]: TG2Scene2DComponent read GetComponent;
    property ComponentCount: TG2IntS32 read GetComponentCount;
    property ComponentOfType[const ComponentType: CG2Scene2DComponent]: TG2Scene2DComponent read GetComponentOfType;
    property Name: AnsiString read _Name write _Name;
    property Transform: TG2Transform2 read _Transform write SetTransform;
    constructor Create(const OwnerScene: TG2Scene2D); virtual;
    destructor Destroy; override;
    procedure NewGUID;
    procedure DebugDraw(const Display: TG2Display2D);
    procedure Render(const Display: TG2Display2D);
    procedure AddEvent(const EventName: String; const Event: TG2Scene2DEvent);
    procedure RemoveEvent(const EventName: String; const Event: TG2Scene2DEvent);
    procedure Save(const Stream: TStream); virtual;
    procedure Load(const Stream: TStream); virtual;
  end;

  TG2Scene2DJointList = specialize TG2QuickListG<TG2Scene2DJoint>;

  CG2Scene2DJoint = class of TG2Scene2DJoint;

  TG2Scene2DJoint = class
  private
    class var JointList: array of CG2Scene2DJoint;
    var _UserData: Pointer;
    var _Scene: TG2Scene2D;
    var _Enabled: Boolean;
    procedure SetEnabled(const Value: Boolean); virtual;
  protected
    var _Joint: pb2_joint;
    procedure SaveClassType(const Stream: TStream);
  public
    property UserData: Pointer read _UserData write _UserData;
    property Scene: TG2Scene2D read _Scene;
    property Enabled: Boolean read _Enabled write SetEnabled;
    class constructor ClassCreate;
    constructor Create(const OwnerScene: TG2Scene2D); virtual;
    destructor Destroy; override;
    procedure Save(const Stream: TStream); virtual;
    procedure Load(const Stream: TStream); virtual;
  end;

  TG2Scene2DDistanceJoint = class (TG2Scene2DJoint)
  private
    var _RigidBodyA: TG2Scene2DComponentRigidBody;
    var _RigidBodyB: TG2Scene2DComponentRigidBody;
    var _AnchorA: TG2Vec2;
    var _AnchorB: TG2Vec2;
    var _Distance: TG2Float;
    procedure SetEnabled(const Value: Boolean); override;
    function Valid: Boolean; inline;
  public
    property RigidBodyA: TG2Scene2DComponentRigidBody read _RigidBodyA write _RigidBodyA;
    property RigidBodyB: TG2Scene2DComponentRigidBody read _RigidBodyB write _RigidBodyB;
    property AnchorA: TG2Vec2 read _AnchorA write _AnchorA;
    property AnchorB: TG2Vec2 read _AnchorB write _AnchorB;
    property Distnace: TG2Float read _Distance write _Distance;
    class constructor CreateClass;
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
    procedure Save(const Stream: TStream); override;
    procedure Load(const Stream: TStream); override;
  end;

  TG2Scene2DRevoluteJoint = class (TG2Scene2DJoint)
  private
    var _RigidBodyA: TG2Scene2DComponentRigidBody;
    var _RigidBodyB: TG2Scene2DComponentRigidBody;
    var _Anchor: TG2Vec2;
    procedure SetEnabled(const Value: Boolean); override;
    function Valid: Boolean; inline;
  public
    property RigidBodyA: TG2Scene2DComponentRigidBody read _RigidBodyA write _RigidBodyA;
    property RigidBodyB: TG2Scene2DComponentRigidBody read _RigidBodyB write _RigidBodyB;
    property Anchor: TG2Vec2 read _Anchor write _Anchor;
    class constructor CreateClass;
    constructor Create(const OwnerScene: TG2Scene2D); override;
    destructor Destroy; override;
    procedure Save(const Stream: TStream); override;
    procedure Load(const Stream: TStream); override;
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

  TG2Scene2DModifyFilePathProc = function (const Path: String): String of Object;

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
    var _Entities: TG2Scene2DEntityList;
    var _Joints: TG2Scene2DJointList;
    var _RenderHooks: TRenderHookList;
    var _SortRenderHooks: Boolean;
    var _Gravity: TG2Vec2;
    var _PhysWorld: tb2_world;
    var _ContactListener: TPhysContactListener;
    var _PhysDraw: TPhysDraw;
    var _Simulate: Boolean;
    var _ModifySavePathProc: TG2Scene2DModifyFilePathProc;
    var _ModifyLoadPathProc: TG2Scene2DModifyFilePathProc;
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
    procedure SetGravity(const Value: TG2Vec2); inline;
  public
    property Entities[const Index: TG2IntS32]: TG2Scene2DEntity read GetEntity;
    property EntityCount: TG2IntS32 read GetEntityCount;
    property Joints[const Index: TG2IntS32]: TG2Scene2DJoint read GetJoint;
    property JointCount: TG2IntS32 read GetJointCount;
    property Gravity: TG2Vec2 read _Gravity write SetGravity;
    property Simulate: Boolean read _Simulate write _Simulate;
    property PhysWorld: tb2_world read _PhysWorld;
    property ModifySavePath: TG2Scene2DModifyFilePathProc read _ModifySavePathProc write _ModifySavePathProc;
    property ModifyLoadPath: TG2Scene2DModifyFilePathProc read _ModifyLoadPathProc write _ModifyLoadPathProc;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure DebugDraw(const Display: TG2Display2D);
    procedure Render(const Display: TG2Display2D);
    procedure EnablePhysics;
    function RenderHookAdd(const HookProc: TG2Scene2DRenderHookProc; const Layer: TG2IntS32): TG2Scene2DRenderHook;
    procedure RenderHookRemove(var Hook: TG2Scene2DRenderHook);
    function FindEntity(const GUID: String): TG2Scene2DEntity;
    function FindEntityByName(const EntityName: String): TG2Scene2DEntity;
    procedure Save(const Stream: TStream);
    procedure Load(const Stream: TStream);
    procedure Load(const FileName: String);
  end;

  TG2Scene2DComponentSprite = class (TG2Scene2DComponent)
  private
    var _Texture: TG2Texture2DBase;
    var _TexCoords: TG2Rect;
    var _RenderHook: TG2Scene2DRenderHook;
    var _Width: TG2Float;
    var _Height: TG2Float;
    var _Scale: TG2Float;
    var _FlipX: Boolean;
    var _FlipY: Boolean;
    var _Transform: TG2Transform2;
    var _Filter: TG2Filter;
    var _RefTexture: Boolean;
    var _Layer: TG2IntS32;
    var _Color: TG2Color;
    var _BlendMode: TG2BlendMode;
    var _Visible: Boolean;
    function GetLayer: TG2IntS32; inline;
    procedure SetLayer(const Value: TG2IntS32); inline;
    procedure SetTexture(const Value: TG2Texture2DBase); inline;
  protected
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure OnAttach; override;
    procedure OnDetach; override;
    procedure OnRender(const Display: TG2Display2D);
  public
    class constructor CreateClass;
    class function GetName: String; override;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; override;
    property Layer: TG2IntS32 read GetLayer write SetLayer;
    property Texture: TG2Texture2DBase read _Texture write SetTexture;
    property TexCoords: TG2Rect read _TexCoords write _TexCoords;
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
    procedure SetAtlasFrame(const Frame: TG2AtlasFrame);
    procedure Save(const Stream: TStream); override;
    procedure Load(const Stream: TStream); override;
  end;

  TG2Scene2DComponentEffect = class (TG2Scene2DComponent)
  private
    var _EffectInst: TG2Effect2DInst;
    var _RenderHook: TG2Scene2DRenderHook;
    var _Layer: TG2IntS32;
    var _Scale: TG2Float;
    var _Speed: TG2Float;
    var _Repeating: Boolean;
    var _RefEffect: Boolean;
    var _AutoDestruct: Boolean;
    var _LocalSpace: Boolean;
    var _FixedOrientation: Boolean;
    procedure OnEffectFinish(const Inst: Pointer);
    procedure SetEffectInst(const Value: TG2Effect2DInst); inline;
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
    property EffectInst: TG2Effect2DInst read _EffectInst write SetEffectInst;
    property Layer: TG2IntS32 read _Layer write SetLayer;
    property Scale: TG2Float read GetScale write SetScale;
    property Speed: TG2Float read GetSpeed write SetSpeed;
    property Repeating: Boolean read GetRepeating write SetRepeating;
    property Playing: Boolean read GetPlaying;
    property AutoDestruct: Boolean read _AutoDestruct write _AutoDestruct;
    property LocalSpace: Boolean read GetLocalSpace write SetLocalSpace;
    property FixedOrientation: Boolean read GetFixedOrientation write SetFixedOrientation;
    class constructor CreateClass;
    class function GetName: String; override;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; override;
    procedure Play;
    procedure Stop;
    procedure Save(const Stream: TStream); override;
    procedure Load(const Stream: TStream); override;
  end;

  TG2Scene2DComponentBackground = class (TG2Scene2DComponent)
  private
    var _Texture: TG2Texture2DBase;
    var _RenderHook: TG2Scene2DRenderHook;
    var _Scale: TG2Vec2;
    var _ScrollSpeed: TG2Vec2;
    var _ScrollPos: TG2Vec2;
    var _FlipX: Boolean;
    var _FlipY: Boolean;
    var _Filter: TG2Filter;
    var _BlendMode: TG2BlendMode;
    var _RefTexture: Boolean;
    function GetLayer: TG2IntS32; inline;
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
    property Layer: TG2IntS32 read GetLayer write SetLayer;
    property Texture: TG2Texture2DBase read _Texture write SetTexture;
    property Scale: TG2Vec2 read _Scale write _Scale;
    property ScrollSpeed: TG2Vec2 read _ScrollSpeed write _ScrollSpeed;
    property FlipX: Boolean read _FlipX write _FlipX;
    property FlipY: Boolean read _FlipY write _FlipY;
    property Filter: TG2Filter read _Filter write _Filter;
    property BlendMode: TG2BlendMode read _BlendMode write _BlendMode;
    procedure Save(const Stream: TStream); override;
    procedure Load(const Stream: TStream); override;
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
    property Enabled: Boolean read _Enabled write SetEnabled;
    property PhysBody: pb2_body read _Body;
    procedure MakeStatic; inline;
    procedure MakeKinematic; inline;
    procedure MakeDynamic; inline;
    procedure Save(const Stream: TStream); override;
    procedure Load(const Stream: TStream); override;
  end;

  TG2Scene2DEventBeginContactData = class (TG2Scene2DEventData)
  public
    var PhysContact: pb2_contact;
    var Shapes: array[0..1] of TG2Scene2DComponentCollisionShape;
    constructor Create; override;
  end;

  TG2Scene2DEventEndContactData = class (TG2Scene2DEventData)
  public
    var PhysContact: pb2_contact;
    var Shapes: array[0..1] of TG2Scene2DComponentCollisionShape;
    constructor Create; override;
  end;

  TG2Scene2DEventBeforeContactSolveData = class (TG2Scene2DEventData)
  public
    var PhysContact: pb2_contact;
    var Shapes: array[0..1] of TG2Scene2DComponentCollisionShape;
    constructor Create; override;
  end;

  TG2Scene2DEventAfterContactSolveData = class (TG2Scene2DEventData)
  public
    var PhysContact: pb2_contact;
    var Shapes: array[0..1] of TG2Scene2DComponentCollisionShape;
    constructor Create; override;
  end;

  TG2Scene2DComponentCollisionShape = class (TG2Scene2DComponent)
  private
    var _EventBeginContactData: TG2Scene2DEventBeginContactData;
    var _EventEndContactData: TG2Scene2DEventEndContactData;
  protected
    var _FixtureDef: tb2_fixture_def;
    var _Fixture: pb2_fixture;
    var _EventBeginContact: TG2Scene2DEventDispatcher;
    var _EventEndContact: TG2Scene2DEventDispatcher;
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
    procedure OnBeginContact(
      const Other: TG2Scene2DComponentCollisionShape;
      const Contact: pb2_contact
    ); inline;
    procedure OnEndContact(
      const Other: TG2Scene2DComponentCollisionShape;
      const Contact: pb2_contact
    ); inline;
  public
    class constructor CreateClass;
    class function GetName: String; override;
    class function CanAttach(const Node: TG2Scene2DEntity): Boolean; override;
    property Fricton: TG2Float read GetFriction write SetFriction;
    property Density: TG2Float read GetDensity write SetDensity;
    property EventBeginContact: TG2Scene2DEventDispatcher read _EventBeginContact;
    property EventEndContact: TG2Scene2DEventDispatcher read _EventEndContact;
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
    procedure Save(const Stream: TStream); override;
    procedure Load(const Stream: TStream); override;
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
    procedure Save(const Stream: TStream); override;
    procedure Load(const Stream: TStream); override;
  end;

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
    procedure SetUp(const v: PG2Vec2Arr; const vc: TG2IntS32); override;
  protected
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
    procedure Save(const Stream: TStream); override;
    procedure Load(const Stream: TStream); override;
  end;

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
    procedure Save(const Stream: TStream); override;
    procedure Load(const Stream: TStream); override;
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
    procedure Save(const Stream: TStream); override;
    procedure Load(const Stream: TStream); override;
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
    var _Joint: pb2_joint;
    var _BodyVerts: array[0..5] of tb2_vec2;
    var _Width: TG2Float;
    var _Height: TG2Float;
    procedure SetupShapes;
    procedure OnInitialize; override;
    procedure OnFinalize; override;
    procedure SetEnabled(const Value: Boolean); override;
    procedure SetWidth(const Value: TG2Float); inline;
    procedure SetHeight(const Value: TG2Float); inline;
  public
    class constructor CreateClass;
    class function GetName: String; override;
    property Width: TG2Float read _Width write SetWidth;
    property Height: TG2Float read _Height write SetHeight;
    procedure Save(const Stream: TStream); override;
    procedure Load(const Stream: TStream); override;
  end;

  TG2Scene2DComponentPoly = class (TG2Scene2DComponent)
  public
    type TG2Scene2DComponentPolyVertex = record
      x, y: TG2Float;
      c: TG2Color;
    end;
    type PG2Scene2DComponentPolyVertex = ^TG2Scene2DComponentPolyVertex;
    type TG2Scene2DComponentPolyLayer = class
    private
      var _Owner: TG2Scene2DComponentPoly;
      var _Hook: TG2Scene2DRenderHook;
      var _Layer: TG2IntS32;
      var _RefTexture: Boolean;
      var _Texture: TG2Texture2DBase;
      function GetVisible: Boolean; inline;
      procedure SetVisible(const Value: Boolean); inline;
      procedure SetLayer(const Value: TG2IntS32); inline;
      procedure OnRender(const Display: TG2Display2D);
      procedure SetTexture(const Value: TG2Texture2DBase);
    public
      Opacity: array of TG2Float;
      Scale: TG2Vec2;
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
      const NewIndices: PG2IntU16; const NewIndexCount, IndexStride: TG2IntS32
    ); overload;
    procedure Save(const Stream: TStream); override;
    procedure Load(const Stream: TStream); override;
  end;

  operator := (v: tb2_vec2): TG2Vec2; inline;
  operator := (v: TG2Vec2): tb2_vec2; inline;
  operator := (r: tb2_rot): TG2Rotation2; inline;
  operator := (r: TG2Rotation2): tb2_rot; inline;
  operator := (t: tb2_transform): TG2Transform2; inline;
  operator := (t: TG2Transform2): tb2_transform; inline;
  operator := (varr: pb2_vec2_arr): PG2Vec2Arr; inline;
  operator := (varr: PG2Vec2Arr): pb2_vec2_arr; inline;

const g2_s2d_et_begin_contact = 0;
const g2_s2d_et_end_contact = 1;

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

procedure TG2Scene2DComponent.SaveClassType(const Stream: TStream);
  var n: TG2IntS32;
  var str: String;
begin
  str := ClassName;
  n := Length(ClassName);
  Stream.Write(n, SizeOf(n));
  Stream.Write(str[1], n);
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

class function TG2Scene2DComponent.CanAttach(const Node: TG2Scene2DEntity): Boolean;
begin
  Result := False;
end;

constructor TG2Scene2DComponent.Create(const OwnerScene: TG2Scene2D);
begin
  inherited Create;
  _Scene := OwnerScene;
  _ProcOnAttach := nil;
  _ProcOnDetach := nil;
  _ProcOnFinalize := nil;
  _EventDispatchers.Clear;
  OnInitialize;
end;

destructor TG2Scene2DComponent.Destroy;
begin
  OnFinalize;
  if Assigned(_ProcOnFinalize) then _ProcOnFinalize(Self);
  inherited Destroy;
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

procedure TG2Scene2DComponent.Save(const Stream: TStream);
begin

end;

procedure TG2Scene2DComponent.Load(const Stream: TStream);
begin

end;
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

procedure TG2Scene2DEntity.OnRender(const Display: TG2Display2D);
begin

end;

constructor TG2Scene2DEntity.Create(const OwnerScene: TG2Scene2D);
begin
  _Parent := nil;
  _Children.Clear;
  _Transform.SetIdentity;
  _Name := 'Entity';
  _Scene := OwnerScene;
  _EventDispatchers.Clear;
  NewGUID;
  _Scene.EntityAdd(Self);
end;

destructor TG2Scene2DEntity.Destroy;
  var i: TG2IntS32;
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

procedure TG2Scene2DEntity.Save(const Stream: TStream);
  var i, n: TG2IntS32;
begin
  Stream.Write(_Transform, SizeOf(_Transform));
  n := Length(_Name);
  Stream.Write(n, SizeOf(n));
  Stream.Write(_Name[1], n);
  n := Length(_GUID);
  Stream.Write(n, SizeOf(n));
  Stream.Write(_GUID[1], n);
  n := _Children.Count;
  Stream.Write(n, SizeOf(n));
  for i := 0 to _Children.Count - 1 do
  _Children[i].Save(Stream);
  n := _Components.Count;
  Stream.Write(n, SizeOf(n));
  for i := 0 to _Components.Count - 1 do
  _Components[i].Save(Stream);
end;

procedure TG2Scene2DEntity.Load(const Stream: TStream);
  var i, j, n, ec, cc: TG2IntS32;
  var e: TG2Scene2DEntity;
  var c: TG2Scene2DComponent;
  var CName: String;
begin
  Stream.Read(_Transform, SizeOf(_Transform));
  Stream.Read(n, SizeOf(n));
  SetLength(_Name, n);
  Stream.Read(_Name[1], n);
  Stream.Read(n, SizeOf(n));
  SetLength(_GUID, n);
  Stream.Read(_GUID[1], n);
  Stream.Read(ec, SizeOf(ec));
  for i := 0 to ec - 1 do
  begin
    e := TG2Scene2DEntity.Create(Scene);
    e.Parent := Self;
    e.Load(Stream);
  end;
  Stream.Read(cc, SizeOf(cc));
  for i := 0 to cc - 1 do
  begin
    Stream.Read(n, SizeOf(n));
    SetLength(CName, n);
    Stream.Read(CName[1], n);
    for j := 0 to High(TG2Scene2DComponent.ComponentList) do
    if TG2Scene2DComponent.ComponentList[j].ClassName = CName then
    begin
      c := TG2Scene2DComponent.ComponentList[j].Create(Scene);
      c.Attach(Self);
      c.Load(Stream);
      Break;
    end;
  end;
end;
//TG2Scene2DEntity END

//TG2Scene2DJoint BEGIN
procedure TG2Scene2DJoint.SetEnabled(const Value: Boolean);
begin
  _Enabled := Value;
end;

procedure TG2Scene2DJoint.SaveClassType(const Stream: TStream);
  var n: TG2IntS32;
begin
  n := Length(ClassName);
  Stream.Write(n, SizeOf(n));
  Stream.Write(ClassName[1], n);
end;

class constructor TG2Scene2DJoint.ClassCreate;
begin
  SetLength(JointList, Length(JointList) + 1);
  JointList[High(JointList)] := CG2Scene2DJoint(ClassType);
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

procedure TG2Scene2DJoint.Save(const Stream: TStream);
begin

end;

procedure TG2Scene2DJoint.Load(const Stream: TStream);
begin

end;
//TG2Scene2DJoint END

//TG2Scene2DDistanceJoint BEIGN
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

function TG2Scene2DDistanceJoint.Valid: Boolean;
begin
  Result := (
    (_RigidBodyA <> nil)
    and (_RigidBodyB <> nil)
  );
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

procedure TG2Scene2DDistanceJoint.Save(const Stream: TStream);
  var n: Integer;
begin
  SaveClassType(Stream);
  if _RigidBodyA = nil then
  begin
    n := 0;
    Stream.Write(n, SizeOf(n));
  end
  else
  begin
    n := Length(_RigidBodyA.Owner.GUID);
    Stream.Write(n, SizeOf(n));
    Stream.Write(_RigidBodyA.Owner.GUID[1], n);
  end;
  if _RigidBodyB = nil then
  begin
    n := 0;
    Stream.Write(n, SizeOf(n));
  end
  else
  begin
    n := Length(_RigidBodyB.Owner.GUID);
    Stream.Write(n, SizeOf(n));
    Stream.Write(_RigidBodyB.Owner.GUID[1], n);
  end;
  Stream.Write(_AnchorA, SizeOf(_AnchorA));
  Stream.Write(_AnchorB, SizeOf(_AnchorB));
  Stream.Write(_Distance, SizeOf(_Distance));
  Stream.Write(_Enabled, SizeOf(_Enabled));
end;

procedure TG2Scene2DDistanceJoint.Load(const Stream: TStream);
  var n: Integer;
  var GUID: String;
  var b: Boolean;
  var e: TG2Scene2DEntity;
begin
  Stream.Read(n, SizeOf(n));
  if n > 0 then
  begin
    SetLength(GUID, n);
    Stream.Read(GUID[1], n);
    e := _Scene.FindEntity(GUID);
    if e <> nil then
    _RigidBodyA := TG2Scene2DComponentRigidBody(e.ComponentOfType[TG2Scene2DComponentRigidBody])
    else
    _RigidBodyA := nil;
  end
  else
  _RigidBodyA := nil;
  Stream.Read(n, SizeOf(n));
  if n > 0 then
  begin
    SetLength(GUID, n);
    Stream.Read(GUID[1], n);
    e := _Scene.FindEntity(GUID);
    if e <> nil then
    _RigidBodyB := TG2Scene2DComponentRigidBody(e.ComponentOfType[TG2Scene2DComponentRigidBody])
    else
    _RigidBodyB := nil;
  end
  else
  _RigidBodyB := nil;
  Stream.Read(_AnchorA, SizeOf(_AnchorA));
  Stream.Read(_AnchorB, SizeOf(_AnchorB));
  Stream.Read(_Distance, SizeOf(_Distance));
  Stream.Read(b, SizeOf(b));
  Enabled := b;
end;
//TG2Scene2DDistanceJoint END

//TG2Scene2DRevoluteJoint BEGIN
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
      _Anchor
    );
    _Joint := _Scene.PhysWorld.create_joint(def);
  end
  else
  begin
    _Scene.PhysWorld.destroy_joint(_Joint);
    _Joint := nil;
  end;
end;

function TG2Scene2DRevoluteJoint.Valid: Boolean;
begin
  Result := (
    (_RigidBodyA <> nil)
    and (_RigidBodyB <> nil)
  );
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
end;

destructor TG2Scene2DRevoluteJoint.Destroy;
begin
  inherited Destroy;
end;

procedure TG2Scene2DRevoluteJoint.Save(const Stream: TStream);
  var n: Integer;
begin
  SaveClassType(Stream);
  if _RigidBodyA = nil then
  begin
    n := 0;
    Stream.Write(n, SizeOf(n));
  end
  else
  begin
    n := Length(_RigidBodyA.Owner.GUID);
    Stream.Write(n, SizeOf(n));
    Stream.Write(_RigidBodyA.Owner.GUID[1], n);
  end;
  if _RigidBodyB = nil then
  begin
    n := 0;
    Stream.Write(n, SizeOf(n));
  end
  else
  begin
    n := Length(_RigidBodyB.Owner.GUID);
    Stream.Write(n, SizeOf(n));
    Stream.Write(_RigidBodyB.Owner.GUID[1], n);
  end;
  Stream.Write(_Anchor, SizeOf(_Anchor));
  Stream.Write(_Enabled, SizeOf(_Enabled));
end;

procedure TG2Scene2DRevoluteJoint.Load(const Stream: TStream);
  var n: Integer;
  var GUID: String;
  var b: Boolean;
  var e: TG2Scene2DEntity;
begin
  Stream.Read(n, SizeOf(n));
  if n > 0 then
  begin
    SetLength(GUID, n);
    Stream.Read(GUID[1], n);
    e := _Scene.FindEntity(GUID);
    if e <> nil then
    _RigidBodyA := TG2Scene2DComponentRigidBody(e.ComponentOfType[TG2Scene2DComponentRigidBody])
    else
    _RigidBodyA := nil;
  end
  else
  _RigidBodyA := nil;
  Stream.Read(n, SizeOf(n));
  if n > 0 then
  begin
    SetLength(GUID, n);
    Stream.Read(GUID[1], n);
    e := _Scene.FindEntity(GUID);
    if e <> nil then
    _RigidBodyB := TG2Scene2DComponentRigidBody(e.ComponentOfType[TG2Scene2DComponentRigidBody])
    else
    _RigidBodyB := nil;
  end
  else
  _RigidBodyB := nil;
  Stream.Read(_Anchor, SizeOf(_Anchor));
  Stream.Read(b, SizeOf(b));
  Enabled := b;
end;
//TG2Scene2DRevoluteJoint END

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
  var Shape0, Shape1: TG2Scene2DComponentCollisionShape;
begin
  Shape0 := TG2Scene2DComponentCollisionShape(contact^.get_fixture_a^.get_user_data);
  Shape1 := TG2Scene2DComponentCollisionShape(contact^.get_fixture_b^.get_user_data);
  if Assigned(Shape0) and Assigned(Shape1) then
  begin
    Shape0.OnBeginContact(Shape1, contact);
    Shape1.OnBeginContact(Shape0, contact);
  end;
end;

procedure TG2Scene2D.TPhysContactListener.end_contact(const contact: pb2_contact);
  var Shape0, Shape1: TG2Scene2DComponentCollisionShape;
begin
  Shape0 := TG2Scene2DComponentCollisionShape(contact^.get_fixture_a^.get_user_data);
  Shape1 := TG2Scene2DComponentCollisionShape(contact^.get_fixture_b^.get_user_data);
  if Assigned(Shape0) and Assigned(Shape1) then
  begin
    Shape0.OnEndContact(Shape1, contact);
    Shape1.OnEndContact(Shape0, contact);
  end;
end;

procedure TG2Scene2D.TPhysContactListener.pre_solve(const contact: pb2_contact; const old_manifold: pb2_manifold);
begin
  inherited pre_solve(contact, old_manifold);
end;

procedure TG2Scene2D.TPhysContactListener.post_solve(const contact: pb2_contact; const impulse: pb2_contact_impulse);
begin
  inherited post_solve(contact, impulse);
end;

procedure TG2Scene2D.Update;
begin
  if _Simulate then
  _PhysWorld.step(g2.DeltaTimeSec, 6, 2);
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

procedure TG2Scene2D.SetGravity(const Value: TG2Vec2);
begin
  _Gravity := Value;
  _PhysWorld.set_gravity(_Gravity);
end;

constructor TG2Scene2D.Create;
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
  _Simulate := False;
  _ModifySavePathProc := nil;
  _ModifyLoadPathProc := nil;
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
  for i := 0 to _Entities.Count - 1 do
  _Entities[i].Render(Display);
  if _SortRenderHooks then
  begin
    _RenderHooks.Sort(@CompRenderHooks);
    _SortRenderHooks := False;
  end;
  for i := 0 to _RenderHooks.Count - 1 do
  _RenderHooks[i].Hook(Display);
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
  var i: Integer;
begin
  for i := 0 to _Entities.Count - 1 do
  if _Entities[i].GUID = GUID then
  Exit(_Entities[i]);
  Result := nil;
end;

function TG2Scene2D.FindEntityByName(const EntityName: String): TG2Scene2DEntity;
  var i: Integer;
begin
  for i := 0 to _Entities.Count - 1 do
  if _Entities[i].Name = EntityName then
  Exit(_Entities[i]);
  Result := nil;
end;

procedure TG2Scene2D.Save(const Stream: TStream);
  const Header: array[0..3] of AnsiChar = 'G2S2';
  var i, p, n: TG2IntS32;
begin
  Stream.Write(Header, SizeOf(Header));
  n := 0;
  for i := 0 to EntityCount - 1 do
  if Entities[i].Parent = nil then Inc(n);
  Stream.Write(n, SizeOf(n));
  for i := 0 to EntityCount - 1 do
  if Entities[i].Parent = nil then
  Entities[i].Save(Stream);
  n := JointCount;
  Stream.Write(n, SizeOf(n));
  for i := 0 to JointCount - 1 do
  Joints[i].Save(Stream);
end;

procedure TG2Scene2D.Load(const Stream: TStream);
  var Header: array[0..3] of AnsiChar;
  var i, j, n, cn: TG2IntS32;
  var CName: String;
  var Joint: TG2Scene2DJoint;
begin
  Stream.Read(Header, SizeOf(Header));
  if Header <> 'G2S2' then Exit;
  Stream.Read(n, SizeOf(n));
  for i := 0 to n - 1 do
  TG2Scene2DEntity.Create(Self).Load(Stream);
  Stream.Read(n, SizeOf(n));
  for i := 0 to n - 1 do
  begin
    Stream.Read(cn, SizeOf(n));
    SetLength(CName, cn);
    Stream.Read(CName[1], cn);
    for j := 0 to High(TG2Scene2DJoint.JointList) do
    if CName = TG2Scene2DJoint.JointList[j].ClassName then
    begin
      Joint := TG2Scene2DJoint.JointList[j].Create(Self);
      Joint.Load(Stream);
      Break;
    end;
  end;
end;

procedure TG2Scene2D.Load(const FileName: String);
  var fs: TFileStream;
begin
  fs := TFileStream.Create(FileName, fmOpenRead);
  try
    Load(fs);
  finally
    fs.Free;
  end;
end;

//TG2Scene2D END

//TG2Scene2DComponentSprite BEGIN
function TG2Scene2DComponentSprite.GetLayer: TG2IntS32;
begin
  Result := _Layer;
end;

procedure TG2Scene2DComponentSprite.SetLayer(const Value: TG2IntS32);
begin
  _Layer := Value;
  if _RenderHook <> nil then _RenderHook.Layer := _Layer;
end;

procedure TG2Scene2DComponentSprite.SetTexture(const Value: TG2Texture2DBase);
begin
  if Value = _Texture then Exit;
  if (_Texture <> nil)
  and (_RefTexture) then
  _Texture.RefDec;
  _RefTexture := False;
  _Texture := Value;
end;

procedure TG2Scene2DComponentSprite.OnInitialize;
begin
  _RefTexture := False;
  _RenderHook := nil;
  _Texture := nil;
  _TexCoords := G2Rect(0, 0, 1, 1);
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
  Texture := nil;
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
  or (_Texture = nil)
  or (_Owner = nil) then
  Exit;
  hw := _Width * _Scale * 0.5;
  hh := _Height * _Scale * 0.5;
  v[0].SetValue(-hw, -hh);
  v[1].SetValue(hw, -hh);
  v[2].SetValue(-hw, hh);
  v[3].SetValue(hw, hh);
  if not _FlipX then begin tx0 := _TexCoords.l; tx1 := _TexCoords.r; end
  else begin tx0 := _TexCoords.r; tx1 := _TexCoords.l; end;
  if not _FlipY then begin ty0 := _TexCoords.t; ty1 := _TexCoords.b; end
  else begin ty0 := _TexCoords.b; ty1 := _TexCoords.t; end;
  t[0].SetValue(tx0, ty0);
  t[1].SetValue(tx1, ty0);
  t[2].SetValue(tx0, ty1);
  t[3].SetValue(tx1, ty1);
  xf := _Owner.Transform;
  G2Transform2Mul(@xf, @_Transform, @xf);
  for i := 0 to High(v) do
  G2Vec2Transform2Mul(@v[i], @v[i], @xf);
  Display.PicQuad(
    v[0], v[1], v[2], v[3],
    t[0], t[1], t[2], t[3],
    _Color, _Texture, _BlendMode, _Filter
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

class function TG2Scene2DComponentSprite.CanAttach(
  const Node: TG2Scene2DEntity
): Boolean;
begin
  Result := True;
end;

procedure TG2Scene2DComponentSprite.SetAtlasFrame(const Frame: TG2AtlasFrame);
begin
  Texture := Frame.Texture;
  TexCoords := Frame.TexCoords;
  if Frame.Width > Frame.Height then
  begin
    Width := 1;
    Height := Frame.Height / Frame.Width;
  end
  else
  begin
    Height := 1;
    Width := Frame.Width / Frame.Height;
  end;
end;

procedure TG2Scene2DComponentSprite.Save(const Stream: TStream);
  var n: TG2IntS32;
  var TexFile: String;
begin
  SaveClassType(Stream);
  if (_Texture = nil)
  or not (_Texture is TG2Texture2D)
  or (TG2Texture2D(_Texture).TextureFileName = '') then
  begin
  n := 0;
  end
  else
  begin
    if Assigned(Scene.ModifySavePath) then
    TexFile := Scene.ModifySavePath(TG2Texture2D(_Texture).TextureFileName)
    else
    TexFile := TG2Texture2D(_Texture).TextureFileName;
    n := Length(TexFile);
  end;
  Stream.Write(n, SizeOf(n));
  if n > 0 then
  Stream.Write(TexFile[1], n);
  Stream.Write(_TexCoords, SizeOf(_TexCoords));
  Stream.Write(_Width, SizeOf(_Width));
  Stream.Write(_Height, SizeOf(_Height));
  Stream.Write(_Scale, SizeOf(_Scale));
  Stream.Write(_FlipX, SizeOf(_FlipX));
  Stream.Write(_FlipY, SizeOf(_FlipY));
  Stream.Write(_Transform, SizeOf(_Transform));
  Stream.Write(_Filter, SizeOf(_Filter));
  Stream.Write(_BlendMode, SizeOf(_BlendMode));
  n := Layer;
  Stream.Write(n, SizeOf(n));
end;

procedure TG2Scene2DComponentSprite.Load(const Stream: TStream);
  var n: TG2IntS32;
  var TexFile: String;
begin
  Stream.Read(n, SizeOf(n));
  if n > 0 then
  begin
    SetLength(TexFile, n);
    Stream.Read(TexFile[1], n);
    if Assigned(Scene.ModifyLoadPath) then
    TexFile := Scene.ModifyLoadPath(TexFile);
    _Texture := TG2Texture2D.FindTexture(TexFile);
    if _Texture = nil then
    begin
      if FileExists(TexFile) then
      begin
        _Texture := TG2Texture2D.Create;
        TG2Texture2D(_Texture).Load(TexFile);
      end;
    end;
    if _Texture <> nil then
    begin
      _RefTexture := True;
      _Texture.RefInc;
    end;
  end;
  Stream.Read(_TexCoords, SizeOf(_TexCoords));
  Stream.Read(_Width, SizeOf(_Width));
  Stream.Read(_Height, SizeOf(_Height));
  Stream.Read(_Scale, SizeOf(_Scale));
  Stream.Read(_FlipX, SizeOf(_FlipX));
  Stream.Read(_FlipY, SizeOf(_FlipY));
  Stream.Read(_Transform, SizeOf(_Transform));
  Stream.Read(_Filter, SizeOf(_Filter));
  Stream.Read(_BlendMode, SizeOf(_BlendMode));
  Stream.Read(n, SizeOf(n));
  Layer := n;
end;
//TG2Scene2DComponentSprite END

//TG2Scene2DComponentEffect BEGIN
procedure TG2Scene2DComponentEffect.OnEffectFinish(const Inst: Pointer);
begin
  if _AutoDestruct and (Owner <> nil) then Owner.Free;
end;

procedure TG2Scene2DComponentEffect.SetEffectInst(const Value: TG2Effect2DInst);
begin
  if Value = _EffectInst then Exit;
  if (_EffectInst <> nil) then
  begin
    _EffectInst.OnFinish := nil;
    if (_RefEffect) then _EffectInst.Effect.RefDec;
    _EffectInst.RefDec;
  end;
  _RefEffect := False;
  _EffectInst := Value;
  if (_EffectInst <> nil) then
  begin
    _EffectInst.RefInc;
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
  if _EffectInst <> nil then _EffectInst.Scale := Value;
end;

function TG2Scene2DComponentEffect.GetScale: TG2Float;
begin
  if _EffectInst <> nil then Result := _EffectInst.Scale else Result := _Scale;
end;

procedure TG2Scene2DComponentEffect.SetSpeed(const Value: TG2Float);
begin
  _Speed := Value;
  if _EffectInst <> nil then _EffectInst.Speed := Value;
end;

function TG2Scene2DComponentEffect.GetSpeed: TG2Float;
begin
  if _EffectInst <> nil then Result := _EffectInst.Speed else Result := _Speed;
end;

procedure TG2Scene2DComponentEffect.SetRepeating(const Value: Boolean);
begin
  _Repeating := Value;
  if _EffectInst <> nil then _EffectInst.Repeating := Value;
end;

function TG2Scene2DComponentEffect.GetRepeating: Boolean;
begin
  if _EffectInst <> nil then Result := _EffectInst.Repeating else Result := _Repeating;
end;

function TG2Scene2DComponentEffect.GetPlaying: Boolean;
begin
  if _EffectInst <> nil then Result := _EffectInst.Playing else Result := False;
end;

function TG2Scene2DComponentEffect.GetLocalSpace: Boolean;
begin
  if _EffectInst <> nil then Result := _EffectInst.LocalSpace else Result := _LocalSpace;
end;

procedure TG2Scene2DComponentEffect.SetLocalSpace(const Value: Boolean);
begin
  if Value = _LocalSpace then Exit;
  _LocalSpace := Value;
  if _EffectInst <> nil then _EffectInst.LocalSpace := Value;
  if Playing then
  begin
    Stop;
    Play;
  end;
end;

function TG2Scene2DComponentEffect.GetFixedOrientation: Boolean;
begin
  if _EffectInst <> nil then Result := _EffectInst.FixedOrientation else Result := _FixedOrientation;
end;

procedure TG2Scene2DComponentEffect.SetFixedOrientation(const Value: Boolean);
begin
  _FixedOrientation := Value;
  if _EffectInst <> nil then _EffectInst.FixedOrientation := Value;
end;

procedure TG2Scene2DComponentEffect.OnInitialize;
begin
  _EffectInst := nil;
  _RenderHook := nil;
  _Layer := 0;
  _RefEffect := False;
  _Scale := 1;
  _Speed := 1;
  _Repeating := False;
  _AutoDestruct := False;
  _LocalSpace := True;
  _FixedOrientation := False;
end;

procedure TG2Scene2DComponentEffect.OnFinalize;
begin
  EffectInst := nil;
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
  if _EffectInst <> nil then
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

class function TG2Scene2DComponentEffect.CanAttach(const Node: TG2Scene2DEntity): Boolean;
begin
  Result := True;
end;

procedure TG2Scene2DComponentEffect.Play;
begin
  if _EffectInst <> nil then _EffectInst.Play;
end;

procedure TG2Scene2DComponentEffect.Stop;
begin
  if _EffectInst <> nil then _EffectInst.Stop;
end;

procedure TG2Scene2DComponentEffect.Save(const Stream: TStream);
  var n: TG2IntS32;
  var s: TG2Float;
  var b: Boolean;
  var EffectFile: String;
begin
  SaveClassType(Stream);
  if (_EffectInst = nil)
  or (_EffectInst.Effect.EffectFile = '') then
  begin
  n := 0;
  end
  else
  begin
    if Assigned(Scene.ModifySavePath) then
    EffectFile := Scene.ModifySavePath(_EffectInst.Effect.EffectFile)
    else
    EffectFile := _EffectInst.Effect.EffectFile;
    n := Length(EffectFile);
  end;
  Stream.Write(n, SizeOf(n));
  if n > 0 then
  Stream.Write(EffectFile[1], n);
  n := Layer;
  Stream.Write(n, SizeOf(n));
  if _EffectInst <> nil then s := _EffectInst.Scale else s := 1;
  Stream.Write(s, SizeOf(s));
  if _EffectInst <> nil then s := _EffectInst.Speed else s := 1;
  Stream.Write(s, SizeOf(s));
  if _EffectInst <> nil then b := _EffectInst.Repeating else b := False;
  Stream.Write(b, SizeOf(b));
  if _EffectInst <> nil then b := _EffectInst.LocalSpace else b := True;
  Stream.Write(b, SizeOf(b));
  if _EffectInst <> nil then b := _EffectInst.FixedOrientation else b := False;
  Stream.Write(b, SizeOf(b));
end;

procedure TG2Scene2DComponentEffect.Load(const Stream: TStream);
  var n: TG2IntS32;
  var s: TG2Float;
  var b: Boolean;
  var Effect: TG2Effect2D;
  var EffectFile: String;
begin
  Stream.Read(n, SizeOf(n));
  if n > 0 then
  begin
    SetLength(EffectFile, n);
    Stream.Read(EffectFile[1], n);
    if Assigned(Scene.ModifyLoadPath) then
    EffectFile := Scene.ModifyLoadPath(EffectFile);
    Effect := TG2Effect2D.FindEffect(EffectFile);
    if Effect = nil then
    begin
      if FileExists(EffectFile) then
      begin
        Effect := TG2Effect2D.Create;
        Effect.Load(EffectFile);
      end;
    end;
    if Effect <> nil then
    begin
      _EffectInst := Effect.CreateInstance;
      _RefEffect := True;
      Effect.RefInc;
      _EffectInst.RefInc;
      _EffectInst.Transform := @Owner.Transform;
    end;
  end;
  Stream.Read(n, SizeOf(n));
  Layer := n;
  Stream.Read(s, SizeOf(s));
  if _EffectInst <> nil then _EffectInst.Scale := s;
  Stream.Read(s, SizeOf(s));
  if _EffectInst <> nil then _EffectInst.Speed := s;
  Stream.Read(b, SizeOf(b));
  if _EffectInst <> nil then _EffectInst.Repeating := b;
  Stream.Read(_LocalSpace, SizeOf(_LocalSpace));
  if _EffectInst <> nil then _EffectInst.LocalSpace := _LocalSpace;
  Stream.Read(_FixedOrientation, SizeOf(_FixedOrientation));
  if _EffectInst <> nil then _EffectInst.FixedOrientation := _FixedOrientation;
end;
//TG2Scene2DComponentEffect END

//TG2Scene2DComponentBackground BEGIN
function TG2Scene2DComponentBackground.GetLayer: TG2IntS32;
begin
  if _RenderHook <> nil then Exit(_RenderHook.Layer);
  Result := 0;
end;

procedure TG2Scene2DComponentBackground.SetLayer(const Value: TG2IntS32);
begin
  if _RenderHook <> nil then _RenderHook.Layer := Value;
end;

procedure TG2Scene2DComponentBackground.SetTexture(const Value: TG2Texture2DBase);
begin
  if Value = _Texture then Exit;
  if (_Texture <> nil)
  and (_RefTexture) then
  _Texture.RefDec;
  _RefTexture := False;
  _Texture := Value;
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
  var r: TG2Rect;
  var v, t: array[0..3] of TG2Vec2;
  var i: Integer;
  var xf: TG2Transform2;
  var pvx, pvy: TG2Vec2;
  var ox, oy: TG2Float;
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
  v[0].SetValue(r.l, r.t);
  v[1].SetValue(r.r, r.t);
  v[2].SetValue(r.l, r.b);
  v[3].SetValue(r.r, r.b);
  for i := 0 to 3 do
  begin
    t[i].x := pvx.Dot(v[i]) - ox + _ScrollPos.x;
    t[i].y := pvy.Dot(v[i]) - oy + _ScrollPos.y;
  end;
  Display.PicQuad(
    v[0], v[1], v[2], v[3],
    t[0], t[1], t[2], t[3],
    $ffffffff, _Texture,
    _BlendMode, _Filter
  );
end;

procedure TG2Scene2DComponentBackground.OnUpdate;
  var f: TG2Float;
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

class function TG2Scene2DComponentBackground.CanAttach(
  const Node: TG2Scene2DEntity
): Boolean;
begin
  Result := True;
end;

procedure TG2Scene2DComponentBackground.Save(const Stream: TStream);
  var n: TG2IntS32;
  var TexFile: String;
begin
  SaveClassType(Stream);
  if (_Texture = nil)
  or not (_Texture is TG2Texture2D)
  or (TG2Texture2D(_Texture).TextureFileName = '') then
  begin
  n := 0;
  end
  else
  begin
    if Assigned(Scene.ModifySavePath) then
    TexFile := Scene.ModifySavePath(TG2Texture2D(_Texture).TextureFileName)
    else
    TexFile := TG2Texture2D(_Texture).TextureFileName;
    n := Length(TexFile);
  end;
  Stream.Write(n, SizeOf(n));
  if n > 0 then
  Stream.Write(TexFile[1], n);
  Stream.Write(_Scale, SizeOf(_Scale));
  Stream.Write(_ScrollSpeed, SizeOf(_ScrollSpeed));
  Stream.Write(_FlipX, SizeOf(_FlipX));
  Stream.Write(_FlipY, SizeOf(_FlipY));
  Stream.Write(_Filter, SizeOf(_Filter));
  n := Layer;
  Stream.Write(n, SizeOf(n));
  Stream.Write(_BlendMode, SizeOf(_BlendMode));
end;

procedure TG2Scene2DComponentBackground.Load(const Stream: TStream);
  var n: TG2IntS32;
  var TexFile: String;
begin
  Stream.Read(n, SizeOf(n));
  if n > 0 then
  begin
    SetLength(TexFile, n);
    Stream.Read(TexFile[1], n);
    if Assigned(Scene.ModifyLoadPath) then
    TexFile := Scene.ModifyLoadPath(TexFile);
    _Texture := TG2Texture2D.FindTexture(TexFile);
    if _Texture = nil then
    begin
      if FileExists(TexFile) then
      begin
        _Texture := TG2Texture2D.Create;
        TG2Texture2D(_Texture).Load(TexFile);
      end;
    end;
    if _Texture <> nil then
    begin
      _RefTexture := True;
      _Texture.RefInc;
    end;
  end;
  Stream.Read(_Scale, SizeOf(_Scale));
  Stream.Read(_ScrollSpeed, SizeOf(_ScrollSpeed));
  Stream.Read(_FlipX, SizeOf(_FlipX));
  Stream.Read(_FlipY, SizeOf(_FlipY));
  Stream.Read(_Filter, SizeOf(_Filter));
  Stream.Read(n, SizeOf(n));
  Layer := n;
  Stream.Read(_BlendMode, SizeOf(_BlendMode));
end;
//TG2Scene2DComponentBackground END

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
  Owner.Transform := Transform;//b2_mul(_Body^.get_transform, Transform);
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

procedure TG2Scene2DComponentRigidBody.Save(const Stream: TStream);
  var xf: TG2Transform2;
begin
  SaveClassType(Stream);
  xf := Transform;
  Stream.Write(xf, SizeOf(xf));
  Stream.Write(_BodyDef, SizeOf(_BodyDef));
  Stream.Write(_Enabled, SizeOf(_Enabled));
end;

procedure TG2Scene2DComponentRigidBody.Load(const Stream: TStream);
  var b: Boolean;
  var xf: TG2Transform2;
begin
  Stream.Read(xf, SizeOf(xf));
  Stream.Read(_BodyDef, SizeOf(_BodyDef));
  Stream.Read(b, SizeOf(b));
  Enabled := b;
  Transform := xf;
end;
//TG2Scene2DComponentRigidBody END

//TG2Scene2DEventBeginContactData BEGIN
constructor TG2Scene2DEventBeginContactData.Create;
begin
  inherited Create;
  _EventType := g2_s2d_et_begin_contact;
end;
//TG2Scene2DEventBeginContactData END

//TG2Scene2DEventEndContactData BEGIN
constructor TG2Scene2DEventEndContactData.Create;
begin
  inherited Create;
  _EventType := g2_s2d_et_end_contact;
end;
//TG2Scene2DEventEndContactData END

//TG2Scene2DComponentCollisionShape BEGIN
procedure TG2Scene2DComponentCollisionShape.OnInitialize;
begin
  inherited OnInitialize;
  _EventBeginContact := TG2Scene2DEventDispatcher.Create('OnBeginContact');
  _EventEndContact := TG2Scene2DEventDispatcher.Create('OnEndContact');
  _EventBeginContactData := TG2Scene2DEventBeginContactData.Create;
  _EventEndContactData := TG2Scene2DEventEndContactData.Create;
  _Fixture := nil;
  _FixtureDef := b2_fixture_def;
  _FixtureDef.density := 1;
end;

procedure TG2Scene2DComponentCollisionShape.OnFinalize;
begin
  _EventBeginContactData.Free;
  _EventEndContactData.Free;
  _EventBeginContact.Free;
  _EventEndContact.Free;
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

procedure TG2Scene2DComponentCollisionShape.OnBeginContact(
  const Other: TG2Scene2DComponentCollisionShape;
  const Contact: pb2_contact
);
begin
  _EventBeginContactData.Shapes[0] := Self;
  _EventBeginContactData.Shapes[1] := Other;
  _EventBeginContactData.PhysContact := Contact;
  _EventBeginContact.DispatchEvent(_EventBeginContactData);
end;

procedure TG2Scene2DComponentCollisionShape.OnEndContact(
  const Other: TG2Scene2DComponentCollisionShape;
  const Contact: pb2_contact
);
begin
  _EventEndContactData.Shapes[0] := Self;
  _EventEndContactData.Shapes[1] := Other;
  _EventEndContactData.PhysContact := Contact;
  _EventEndContact.DispatchEvent(_EventEndContactData);
end;

class constructor TG2Scene2DComponentCollisionShape.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentCollisionShape.GetName: String;
begin
  Result := 'Collision Shape';
end;

class function TG2Scene2DComponentCollisionShape.CanAttach(
  const Node: TG2Scene2DEntity
): Boolean;
begin
  Result := True;
end;
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

procedure TG2Scene2DComponentCollisionShapeEdge.Save(const Stream: TStream);
begin
  SaveClassType(Stream);
  Stream.Write(_FixtureDef, SizeOf(_FixtureDef));
  Stream.Write(_EdgeShape.vertex0, SizeOf(_EdgeShape.vertex0));
  Stream.Write(_EdgeShape.vertex1, SizeOf(_EdgeShape.vertex1));
  Stream.Write(_EdgeShape.vertex2, SizeOf(_EdgeShape.vertex2));
  Stream.Write(_EdgeShape.vertex3, SizeOf(_EdgeShape.vertex3));
  Stream.Write(_EdgeShape.has_vertex0, SizeOf(_EdgeShape.has_vertex0));
  Stream.Write(_EdgeShape.has_vertex3, SizeOf(_EdgeShape.has_vertex3));
end;

procedure TG2Scene2DComponentCollisionShapeEdge.Load(const Stream: TStream);
begin
  Stream.Read(_FixtureDef, SizeOf(_FixtureDef));
  _FixtureDef.shape := @_EdgeShape;
  Stream.Read(_EdgeShape.vertex0, SizeOf(_EdgeShape.vertex0));
  Stream.Read(_EdgeShape.vertex1, SizeOf(_EdgeShape.vertex1));
  Stream.Read(_EdgeShape.vertex2, SizeOf(_EdgeShape.vertex2));
  Stream.Read(_EdgeShape.vertex3, SizeOf(_EdgeShape.vertex3));
  Stream.Read(_EdgeShape.has_vertex0, SizeOf(_EdgeShape.has_vertex0));
  Stream.Read(_EdgeShape.has_vertex3, SizeOf(_EdgeShape.has_vertex3));
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
  _PolyShape.set_as_box(w, h, c, r);
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

procedure TG2Scene2DComponentCollisionShapePoly.Save(const Stream: TStream);
begin
  SaveClassType(Stream);
  Stream.Write(_FixtureDef, SizeOf(_FixtureDef));
  Stream.Write(_PolyShape.count, SizeOf(_PolyShape.count));
  Stream.Write(_PolyShape.vertices, SizeOf(_PolyShape.vertices));
  Stream.Write(_PolyShape.normals, SizeOf(_PolyShape.normals));
  Stream.Write(_PolyShape.centroid, SizeOf(_PolyShape.centroid));
end;

procedure TG2Scene2DComponentCollisionShapePoly.Load(const Stream: TStream);
begin
  Stream.Read(_FixtureDef, SizeOf(_FixtureDef));
  _FixtureDef.shape := @_PolyShape;
  Stream.Read(_PolyShape.count, SizeOf(_PolyShape.count));
  Stream.Read(_PolyShape.vertices, SizeOf(_PolyShape.vertices));
  Stream.Read(_PolyShape.normals, SizeOf(_PolyShape.normals));
  Stream.Read(_PolyShape.centroid, SizeOf(_PolyShape.centroid));
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

procedure TG2Scene2DComponentCollisionShapeBox.Save(const Stream: TStream);
begin
  SaveClassType(Stream);
  Stream.Write(_FixtureDef, SizeOf(_FixtureDef));
  Stream.Write(_Width, SizeOf(_Width));
  Stream.Write(_Height, SizeOf(_Height));
  Stream.Write(_Offset, SizeOf(_Offset));
  Stream.Write(_Angle, SizeOf(_Angle));
end;

procedure TG2Scene2DComponentCollisionShapeBox.Load(const Stream: TStream);
begin
  Stream.Read(_FixtureDef, SizeOf(_FixtureDef));
  _FixtureDef.shape := @_PolyShape;
  Stream.Read(_Width, SizeOf(_Width));
  Stream.Read(_Height, SizeOf(_Height));
  Stream.Read(_Offset, SizeOf(_Offset));
  Stream.Read(_Angle, SizeOf(_Angle));
  UpdateProperties;
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

procedure TG2Scene2DComponentCollisionShapeCircle.Save(const Stream: TStream);
begin
  SaveClassType(Stream);
  Stream.Write(_FixtureDef, SizeOf(_FixtureDef));
  Stream.Write(_CircleShape.center, SizeOf(_CircleShape.center));
  Stream.Write(_CircleShape.radius, SizeOf(_CircleShape.radius));
end;

procedure TG2Scene2DComponentCollisionShapeCircle.Load(const Stream: TStream);
begin
  Stream.Read(_FixtureDef, SizeOf(_FixtureDef));
  _FixtureDef.shape := @_CircleShape;
  Stream.Read(_CircleShape.center, SizeOf(_CircleShape.center));
  Stream.Read(_CircleShape.radius, SizeOf(_CircleShape.radius));
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

procedure TG2Scene2DComponentCollisionShapeChain.Save(const Stream: TStream);
begin
  SaveClassType(Stream);
  Stream.Write(_FixtureDef, SizeOf(_FixtureDef));
  Stream.Write(_ChainShape.count, SizeOf(_ChainShape.count));
  Stream.Write(_ChainShape.vertices^, SizeOf(_ChainShape.vertices^[0]) * _ChainShape.count);
  Stream.Write(_ChainShape.has_next_vertex, SizeOf(_ChainShape.has_next_vertex));
  if (_ChainShape.has_next_vertex) then
  Stream.Write(_ChainShape.next_vertex, SizeOf(_ChainShape.next_vertex));
  Stream.Write(_ChainShape.has_prev_vertex, SizeOf(_ChainShape.has_prev_vertex));
  if (_ChainShape.has_prev_vertex) then
  Stream.Write(_ChainShape.prev_vertex, SizeOf(_ChainShape.prev_vertex));
end;

procedure TG2Scene2DComponentCollisionShapeChain.Load(const Stream: TStream);
begin
  Stream.Read(_FixtureDef, SizeOf(_FixtureDef));
  _FixtureDef.shape := @_ChainShape;
  _ChainShape.clear;
  Stream.Read(_ChainShape.count, SizeOf(_ChainShape.count));
  _ChainShape.vertices := pb2_vec2_arr(b2_alloc(_ChainShape.count * SizeOf(tb2_vec2)));
  Stream.Read(_ChainShape.vertices^, _ChainShape.count * SizeOf(tb2_vec2));
  Stream.Read(_ChainShape.has_next_vertex, SizeOf(_ChainShape.has_next_vertex));
  if (_ChainShape.has_next_vertex) then
  Stream.Read(_ChainShape.next_vertex, SizeOf(_ChainShape.next_vertex))
  else
  _ChainShape.next_vertex.set_zero;
  Stream.Read(_ChainShape.has_prev_vertex, SizeOf(_ChainShape.has_prev_vertex));
  if (_ChainShape.has_prev_vertex) then
  Stream.Read(_ChainShape.prev_vertex, SizeOf(_ChainShape.prev_vertex))
  else
  _ChainShape.prev_vertex.set_zero;
  Reattach;
end;
//TG2Scene2DComponentCollisionShapeChain END

//TG2Scene2DComponentCharacter BEGIN
procedure TG2Scene2DComponentCharacter.SetupShapes;
  var qw, hw, hh: TG2Float;
begin
  hw := _Width * 0.5;
  hh := _Height * 0.5;
  qw := hw * 0.5;
  _BodyVerts[0] := b2_vec2(hw, hh - hw);
  _BodyVerts[1] := b2_vec2(hw, -hh + qw);
  _BodyVerts[2] := b2_vec2(hw - qw, -hh);
  _BodyVerts[3] := b2_vec2(-hw + qw, -hh);
  _BodyVerts[4] := b2_vec2(-hw, -hh + qw);
  _BodyVerts[5] := b2_vec2(-hw, hh - hw);
  _ShapeBody.set_polygon(@_BodyVerts, 6);
  _ShapeFeet.center := b2_vec2(0, 0);
  _ShapeFeet.radius := hw;
end;

procedure TG2Scene2DComponentCharacter.OnInitialize;
begin
  inherited OnInitialize;
  _BodyDef.fixed_rotation := True;
  _BodyDef.body_type := b2_dynamic_body;
  _BodyFeetDef := b2_body_def;
  _BodyFeetDef.body_type := b2_dynamic_body;
  _FixtureBodyDef := b2_fixture_def;
  _FixtureFeetDef := b2_fixture_def;
  _ShapeBody.create;
  _FixtureBodyDef.shape := @_ShapeBody;
  _ShapeFeet.create;
  _FixtureFeetDef.shape := @_ShapeFeet;
  _Width := 0.5;
  _Height := 1;
  SetupShapes;
end;

procedure TG2Scene2DComponentCharacter.OnFinalize;
begin
  _ShapeFeet.destroy;
  _ShapeBody.destroy;
  inherited OnFinalize;
end;

procedure TG2Scene2DComponentCharacter.SetEnabled(const Value: Boolean);
  var bd: tb2_body_def;
  var jd: tb2_revolute_joint_def;
begin
  if Value = _Enabled then Exit;
  if not Value then
  begin
    _Scene.PhysWorld.destroy_joint(_Joint);
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
    _FixtureBodyDef.shape := @_ShapeBody;
    _FixtureFeetDef.shape := @_ShapeFeet;
    bd := _BodyFeetDef;
    bd.angle := bd.angle + Owner.Transform.r.Angle;
    bd.position := Owner.Transform.Transform(G2Vec2(0, _Height * 0.5 - _Width * 0.5));
    _BodyFeet := Scene.PhysWorld.create_body(bd);
    _FixtureBody := _Body^.create_fixture(_FixtureBodyDef);
    _FixtureFeet := _BodyFeet^.create_fixture(_FixtureFeetDef);
    jd := b2_revolute_joint_def;
    jd.initialize(_Body, _BodyFeet, bd.position);
    _Joint := _Scene.PhysWorld.create_joint(jd);
  end;
end;

procedure TG2Scene2DComponentCharacter.SetWidth(const Value: TG2Float);
begin
  _Width := Value;
  SetupShapes;
end;

procedure TG2Scene2DComponentCharacter.SetHeight(const Value: TG2Float);
begin
  _Height := Value;
  SetupShapes;
end;

class constructor TG2Scene2DComponentCharacter.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentCharacter.GetName: String;
begin
  Result := 'Character';
end;

procedure TG2Scene2DComponentCharacter.Save(const Stream: TStream);
  var xf: TG2Transform2;
begin
  SaveClassType(Stream);
  xf := Transform;
  Stream.Write(xf, SizeOf(xf));
  Stream.Write(_Width, SizeOf(_Width));
  Stream.Write(_Height, SizeOf(_Height));
  Stream.Write(_BodyDef, SizeOf(_BodyDef));
  Stream.Write(_BodyFeetDef, SizeOf(_BodyFeetDef));
  Stream.Write(_FixtureBodyDef, SizeOf(_FixtureBodyDef));
  Stream.Write(_FixtureFeetDef, SizeOf(_FixtureFeetDef));
  Stream.Write(_Enabled, SizeOf(_Enabled));
end;

procedure TG2Scene2DComponentCharacter.Load(const Stream: TStream);
  var b: Boolean;
  var xf: TG2Transform2;
begin
  Stream.Read(xf, SizeOf(xf));
  Stream.Read(_Width, SizeOf(_Width));
  Stream.Read(_Height, SizeOf(_Height));
  Stream.Read(_BodyDef, SizeOf(_BodyDef));
  Stream.Read(_BodyFeetDef, SizeOf(_BodyFeetDef));
  Stream.Read(_FixtureBodyDef, SizeOf(_FixtureBodyDef));
  Stream.Read(_FixtureFeetDef, SizeOf(_FixtureFeetDef));
  Stream.Read(b, SizeOf(b));
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
  if (_Texture <> nil) and (_RefTexture) then _Texture.RefDec;
  _RefTexture := False;
  _Texture := Value;
end;

constructor TG2Scene2DComponentPoly.TG2Scene2DComponentPolyLayer.Create(const Component: TG2Scene2DComponentPoly);
begin
  inherited Create;
  _Owner := Component;
  SetLength(Opacity, Length(_Owner._Vertices));
  FillChar(Opacity[0], SizeOf(TG2Float) * Length(Opacity), 0);
  Scale := G2Vec2(1, 1);
  Texture := nil;
  _Hook := nil;
  _Layer := 0;
  _RefTexture := False;
end;

destructor TG2Scene2DComponentPoly.TG2Scene2DComponentPolyLayer.Destroy;
begin
  if _RefTexture then Texture.RefDec;
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
      c := _Vertices[_Faces[i][j]].c;
      c.a := Round(c.a * Layer.Opacity[_Faces[i][j]]);
      t := v * Layer.Scale;
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

procedure TG2Scene2DComponentPoly.OnRender(const Display: TG2Display2D);
begin

end;

class constructor TG2Scene2DComponentPoly.CreateClass;
begin
  SetLength(ComponentList, Length(ComponentList) + 1);
  ComponentList[High(ComponentList)] := CG2Scene2DComponent(ClassType);
end;

class function TG2Scene2DComponentPoly.CanAttach(const Node: TG2Scene2DEntity): Boolean;
begin
  Result := True;
end;

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
    _Vertices[vc].c := $ffffffff;
    Inc(vc);
  end;
  procedure AddTri(const v0, v1, v2: TG2Vec2);
  begin
    _Faces[fc][0] := AddVertex(v0);
    _Faces[fc][1] := AddVertex(v1);
    _Faces[fc][2] := AddVertex(v2);
    Inc(fc);
  end;
  var i, j: Integer;
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
  const NewIndices: PG2IntU16; const NewIndexCount, IndexStride: TG2IntS32
);
  var pv: PG2Vec2;
  var pi: PG2IntU16;
  var i: TG2IntS32;
begin
  pv := NewVertices;
  SetLength(_Vertices, NewVertexCount);
  for i := 0 to NewVertexCount - 1 do
  begin
    _Vertices[i].x := pv^.x;
    _Vertices[i].y := pv^.y;
    _Vertices[i].c := $ffffffff;
    pv := PG2Vec2(Pointer(pv) + VertexStride);
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

procedure TG2Scene2DComponentPoly.Save(const Stream: TStream);
  var i, n: TG2IntS32;
  var b: Boolean;
  var TexFile: String;
begin
  SaveClassType(Stream);
  i := Length(_Vertices);
  Stream.Write(i, SizeOf(i));
  Stream.Write(_Vertices[0], SizeOf(TG2Scene2DComponentPolyVertex) * Length(_Vertices));
  i := Length(_Faces);
  Stream.Write(i, SizeOf(i));
  Stream.Write(_Faces[0], SizeOf(_Faces[0]) * Length(_Faces));
  i := Length(_Layers);
  Stream.Write(i, SizeOf(i));
  for i := 0 to High(_Layers) do
  begin
    Stream.Write(_Layers[i].Opacity[0], SizeOf(TG2Float) * Length(_Vertices));
    Stream.Write(_Layers[i].Scale, SizeOf(TG2Vec2));
    if (_Layers[i].Texture = nil)
    or not (_Layers[i].Texture is TG2Texture2D)
    or (TG2Texture2D(_Layers[i].Texture).TextureFileName = '') then
    begin
      n := 0;
    end
    else
    begin
      if Assigned(Scene.ModifySavePath) then
      TexFile := Scene.ModifySavePath(TG2Texture2D(_Layers[i].Texture).TextureFileName)
      else
      TexFile := TG2Texture2D(_Layers[i].Texture).TextureFileName;
      n := Length(TexFile);
    end;
    Stream.Write(n, SizeOf(n));
    if n > 0 then Stream.Write(TexFile[1], n);
    n := _Layers[i].Layer;
    Stream.Write(n, SizeOf(n));
    b := _Layers[i].Visible;
    Stream.Write(b, SizeOf(b));
  end;
end;

procedure TG2Scene2DComponentPoly.Load(const Stream: TStream);
  var i, n: TG2IntS32;
  var b: Boolean;
  var TexFile: String;
begin
  Stream.Read(n, SizeOf(n));
  SetLength(_Vertices, n);
  Stream.Read(_Vertices[0], SizeOf(TG2Scene2DComponentPolyVertex) * Length(_Vertices));
  Stream.Read(n, SizeOf(n));
  SetLength(_Faces, n);
  Stream.Read(_Faces[0], SizeOf(_Faces[0]) * Length(_Faces));
  Stream.Read(n, SizeOf(n));
  SetLength(_Layers, n);
  CreateLayers;
  for i := 0 to High(_Layers) do
  begin
    Stream.Read(_Layers[i].Opacity[0], SizeOf(TG2Float) * Length(_Vertices));
    Stream.Read(_Layers[i].Scale, SizeOf(TG2Vec2));
    Stream.Read(n, SizeOf(n));
    if n > 0 then
    begin
      SetLength(TexFile, n);
      Stream.Read(TexFile[1], n);
      if Assigned(Scene.ModifyLoadPath) then
      TexFile := Scene.ModifyLoadPath(TexFile);
      _Layers[i]._Texture := TG2Texture2D.FindTexture(TexFile);
      if _Layers[i]._Texture = nil then
      begin
        if FileExists(TexFile) then
        begin
          _Layers[i]._Texture := TG2Texture2D.Create;
          TG2Texture2D(_Layers[i]._Texture).Load(TexFile);
        end;
      end;
      if _Layers[i]._Texture <> nil then
      begin
        _Layers[i]._RefTexture := True;
        _Layers[i]._Texture.RefInc;
      end;
    end;
    Stream.Read(n, SizeOf(n));
    _Layers[i].Layer := n;
    Stream.Read(b, SizeOf(b));
    _Layers[i].Visible := b;
  end;
end;
//TG2Scene2DComponentPoly END

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
