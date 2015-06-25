unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  box2d,
  Types,
  SysUtils,
  Classes;

type
  t_draw = class (tb2_draw)
  private
    var _font: TG2Font;
  public
    constructor create; override;
    procedure draw_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color); override;
    procedure draw_solid_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color); override;
    procedure draw_circle(const center: tb2_vec2; const radius: tb2_float32; const color: tb2_color); override;
    procedure draw_solid_circle(const center: tb2_vec2; const radius: tb2_float32; const axis: tb2_vec2; const color: tb2_color); override;
    procedure draw_segment(const p0, p1: tb2_vec2; const color: tb2_color); override;
    procedure draw_transform(const xf: tb2_transform); override;
    procedure draw_string(const x, y: single; const text: string);
    procedure draw_string(const pos: tb2_vec2; const text: string);
    procedure draw_aabb(const aabb: tb2_aabb; const color: tb2_color);
    procedure draw_point(const v: tb2_vec2; const size: tb2_float32; const color: tb2_color);
  end;

  TTest = class;

  TSettings = record
    hz: tb2_float32;
    velocity_iterations: tb2_int32;
    position_iterations: tb2_int32;
    draw_shapes: boolean;
    draw_joints: boolean;
    draw_aabbs: boolean;
    draw_contact_points: boolean;
    draw_contact_normals: boolean;
    draw_contact_impulse: boolean;
    draw_friction_impulse: boolean;
    draw_coms: boolean;
    draw_stats: boolean;
    draw_profile: boolean;
    enable_warm_starting: boolean;
    enable_continuous: boolean;
    enable_sub_stepping: boolean;
    enable_sleep: boolean;
    pause: boolean;
    single_step: boolean;
  end;

  TContactPoint = record
    fixture_a: pb2_fixture;
    fixture_b: pb2_fixture;
    normal: tb2_vec2;
    position: tb2_vec2;
    state: tb2_point_state;
    normal_impulse: tb2_float32;
    tangent_impulse: tb2_float32;
    separation: tb2_float32;
  end;
  PContactPoint = ^TContactPoint;
  TContactPointArr = array[word] of TContactPoint;
  PContactPointArr = ^TContactPointArr;

  TDestructionListener = class (tb2_destruction_listener)
  public
    var test: TTest;
    procedure say_goodbye(const joint: pb2_joint); override;
    procedure say_goodbye(const fixture: pb2_fixture); override;
  end;

  TTest = class (tb2_contact_listener)
  protected
    const max_contact_points = 2048;
    type TFixtureQuery = object
    public
      var point: tb2_vec2;
      var query_fixture: pb2_fixture;
      function Callback(const fixture: pb2_fixture): boolean;
    end;
    var _ground_body: pb2_body;
    var _world_aabb: tb2_aabb;
    var _points: array [0..max_contact_points - 1] of TContactPoint;
    var _point_count: tb2_int32;
    var _destruction_listener: TDestructionListener;
    var _text_line: tb2_int32;
    var _world: pb2_world;
    var _bomb: pb2_body;
    var _mouse_joint: pb2_mouse_joint;
    var _bomb_spawn_point: tb2_vec2;
    var _bomb_spawning: boolean;
    var _mouse_world: tb2_vec2;
    var _step_count: tb2_int32;
    var _max_profile: tb2_profile;
    var _total_profile: tb2_profile;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure DrawTitle(const Text: String);
    procedure Step(var Settings: TSettings); virtual;
    procedure Draw(const Settings: TSettings); virtual;
    procedure Keyboard(const key: tb2_int32); virtual;
    procedure KeyboardUp(const key: tb2_int32); virtual;
    procedure ShiftMouseDown(const p: tb2_vec2);
    procedure MouseDown(const p: tb2_vec2); virtual;
    procedure MouseUp(const p: tb2_vec2); virtual;
    procedure MouseMove(const p: tb2_vec2);
    procedure LaunchBomb;
    procedure LaunchBomb(const position: tb2_vec2; const velocity: tb2_vec2);
    procedure SpawnBomb(const world_pt: tb2_vec2);
    procedure CompleteBombSpawn(const p: tb2_vec2);
    procedure JointDestroyed(const joint: pb2_joint); virtual;
    procedure pre_solve(const contact: pb2_contact; const old_manifold: pb2_manifold); override;
    procedure post_solve(const contact: pb2_contact; const impulse: pb2_contact_impulse); override;
    procedure ShiftOrigin(const new_origin: tb2_vec2);
  end;

  CTest = class of TTest;

  TBodyTypesTest = class (TTest)
  private
    var _attachment: pb2_body;
    var _platform: pb2_body;
    var _speed: tb2_float32;
  public
    constructor Create; override;
    procedure Keyboard(const key: tb2_int32); override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TBasicSliderCrankTest = class (TTest)
  public
    constructor Create; override;
  end;

  TApplyForceTest = class (TTest)
  private
    var _body: pb2_body;
  public
    constructor Create; override;
    procedure Keyboard(const key: tb2_int32); override;
  end;

  TAddPairTest = class (TTest)
  public
    constructor Create; override;
  end;

  TBreakableTest = class (TTest)
  private
    var _body1: pb2_body;
    var _velocity: tb2_vec2;
    var _angular_velocity: tb2_float32;
    var _shape1: tb2_polygon_shape;
    var _shape2: tb2_polygon_shape;
    var _piece1: pb2_fixture;
    var _piece2: pb2_fixture;
    var _broke: boolean;
    var _break: boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure post_solve(const contact: pb2_contact; const impulse: pb2_contact_impulse); override;
    procedure DoBreak;
    procedure Step(var Settings: TSettings); override;
  end;

  TBridgeTest = class (TTest)
  private
    var _middle: pb2_body;
    const NumLinks = 30;
  public
    constructor Create; override;
  end;

  TBulletTest = class (TTest)
  private
    var _body: pb2_body;
    var _bullet: pb2_body;
    var _x: tb2_float32;
  public
    constructor Create; override;
    procedure Launch;
    procedure Step(var Settings: TSettings); override;
  end;

  TCantileverTest = class (TTest)
  private
    const Num = 8;
    var _middle: pb2_body;
  public
    constructor Create; override;
  end;

  TCarTest = class (TTest)
  private
    var _car: pb2_body;
    var _wheel1: pb2_body;
    var _wheel2: pb2_body;
    var _hz: tb2_float32;
    var _zeta: tb2_float32;
    var _speed: tb2_float32;
    var _spring1: pb2_wheel_joint;
    var _spring2: pb2_wheel_joint;
  public
    constructor Create; override;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TChainTest = class (TTest)
  public
    constructor Create; override;
  end;

  TCharacterCollisionTest = class (TTest)
  private
    var _character: pb2_body;
  public
    constructor Create; override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TCollisionFilteringTest = class (TTest)
  private
    const k_small_group = 1;
    const k_large_group = -1;
    const k_default_category = $0001;
    const k_triangle_category = $0002;
    const k_box_category = $0004;
    const k_circle_category = $0008;
    const k_triangle_mask = $ffff;
    const k_box_mask = $ffff xor k_triangle_category;
    const k_circle_mask = $ffff;
  public
    constructor Create; override;
  end;

  TCollisionProcessingTest = class (TTest)
  public
    constructor Create; override;
    procedure Step(var Settings: TSettings); override;
  end;

  TCompoundShapesTest = class (TTest)
  public
    constructor Create; override;
  end;

  TConfinedTest = class (TTest)
  private
    const column_count = 0;
    const row_count = 0;
  public
    constructor Create; override;
    procedure CreateCircle;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TContinuousTest = class (TTest)
  private
    var _body: pb2_body;
    var _angular_velocity: tb2_float32;
  public
    constructor Create; override;
    procedure Launch;
    procedure Step(var Settings: TSettings); override;
  end;

  TConvexHullTest = class (TTest)
  private
    const max_count = b2_max_polygon_vertices;
    var _hull_points: array[0..b2_max_polygon_vertices - 1] of tb2_vec2;
    var _count: tb2_int32;
    var _auto: boolean;
    var _poly_shape: tb2_polygon_shape;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Generate;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TConveyorBeltTest = class (TTest)
  private
    var _platform: pb2_fixture;
  public
    constructor Create; override;
    procedure pre_solve(const contact: pb2_contact; const old_manifold: pb2_manifold); override;
  end;

  TDistanceTest = class (TTest)
  private
    var _position_b: tb2_vec2;
    var _angle_b: tb2_float32;
    var _transform_a: tb2_transform;
    var _transform_b: tb2_transform;
    var _polygon_a: tb2_polygon_shape;
    var _polygon_b: tb2_polygon_shape;
    var _dist_output: tb2_distance_output;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
    procedure Keyboard(const Key: tb2_int32); override;
  end;

  TDominosTest = class (TTest)
  public
    constructor Create; override;
  end;

  TDynamicTreeTest = class (TTest)
  private
    const actor_count = 128;
    type TActor = record
      aabb: tb2_aabb;
      fraction: tb2_float32;
      overlap: boolean;
      proxy_id: tb2_int32;
    end;
    type PActor = ^TActor;
    var _world_extent: tb2_float32;
    var _proxy_extent: tb2_float32;
    var _tree: tb2_dynamic_tree;
    var _query_aabb: tb2_aabb;
    var _ray_cast_input: tb2_ray_cast_input;
    var _ray_cast_output: tb2_ray_cast_output;
    var _ray_actor: PActor;
    var _actors: array [0..actor_count - 1] of TActor;
    var _automated: boolean;
    procedure GetRandomAABB(var aabb: tb2_aabb);
    procedure MoveAABB(var aabb: tb2_aabb);
    procedure CreateProxy;
    procedure DestroyProxy;
    procedure MoveProxy;
    procedure Action;
    procedure Query;
    procedure RayCast;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
    procedure Keyboard(const Key: tb2_int32); override;
    function QueryCallback(const proxy_id: tb2_int32): boolean;
    function RayCastCallback(const input: tb2_ray_cast_input; const proxy_id: tb2_int32): tb2_float32;
  end;

  TEdgeShapesTest = class (TTest)
  private
    type TEdgeShapesCallback = object
    private
      var _fixture: pb2_fixture;
      var _position: tb2_vec2;
      var _normal: tb2_vec2;
    public
      function get_fixture: pb2_fixture; inline;
      function get_position: tb2_vec2; inline;
      function get_normal: tb2_vec2; inline;
      constructor Create;
      function ReportFixture(const fixture: pb2_fixture; const position, normal: tb2_vec2; const fraction: tb2_float32): tb2_float32;
    end;
    const max_bodies = 256;
    var _body_index: tb2_int32;
    var _bodies: array[0..max_bodies - 1] of pb2_body;
    var _polygons: array[0..3] of tb2_polygon_shape;
    var _circle: tb2_circle_shape;
    var _angle: tb2_float32;
    var _callback: TEdgeShapesCallback;
    var _point1: tb2_vec2;
    var _point2: tb2_vec2;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CreateBody(const index: tb2_int32);
    procedure DestroyBody;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TEdgeTest = class (TTest)
  public
    constructor Create; override;
  end;

  TGearsTest = class (TTest)
  private
    var _joint1: pb2_revolute_joint;
    var _joint2: pb2_revolute_joint;
    var _joint3: pb2_prismatic_joint;
    var _joint4: pb2_gear_joint;
    var _joint5: pb2_gear_joint;
  public
    constructor Create; override;
    procedure Draw(const Settings: TSettings); override;
  end;

  THeavyOnLightTest = class (TTest)
  public
    constructor Create; override;
  end;

  THeavyOnLightTwoTest = class (TTest)
  private
    var _heavy: pb2_body;
  public
    constructor Create; override;
    procedure ToggleHeavy;
    procedure Keyboard(const Key: tb2_int32); override;
  end;

  TMobileTest = class (TTest)
  private
    const k_depth = 4;
  public
    constructor Create; override;
    function AddNode(const parent: pb2_body; const local_anchor: tb2_vec2; const depth: tb2_int32; const offset, a: tb2_float32): pb2_body;
  end;

  TMobileBalancedTest = class (TTest)
  private
    const k_depth = 4;
  public
    constructor Create; override;
    function AddNode(const parent: pb2_body; const local_anchor: tb2_vec2; const depth: tb2_int32; offset, a: tb2_float32): pb2_body;
  end;

  TMotorJointTest = class (TTest)
  private
    var _joint: pb2_motor_joint;
    var _time: tb2_float32;
    var _go: boolean;
    var _linear_offset: tb2_vec2;
    var _angular_offset: tb2_float32;
  public
    constructor Create; override;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TOneSidedPlatformTest = class (TTest)
  private
    type TState = (stUnknown, stAbove, stBelow);
    var _radius, _top, _bottom: tb2_float32;
    var _state: TState;
    var _platform: pb2_fixture;
    var _character: pb2_fixture;
  public
    constructor Create; override;
    procedure pre_solve(const contact: pb2_contact; const old_manifold: pb2_manifold); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TPinballTest = class (TTest)
  private
    var _left_joint: pb2_revolute_joint;
    var _right_joint: pb2_revolute_joint;
    var _ball: pb2_body;
    var _button: boolean;
  public
    constructor Create; override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure KeyboardUp(const Key: tb2_int32); override;
  end;

  TPolyCollisionTest = class (TTest)
  private
    var _polygon_a: tb2_polygon_shape;
    var _polygon_b: tb2_polygon_shape;
    var _transform_a: tb2_transform;
    var _transform_b: tb2_transform;
    var _position_b: tb2_vec2;
    var _angle_b: tb2_float32;
    var _manifold: tb2_manifold;
    var _world_manifold: tb2_world_manifold;
  public
    constructor Create; override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
    procedure Keyboard(const Key: tb2_int32); override;
  end;

  TPolyShapesTest = class (TTest)
  private
    type TPolyShapesCallback = object
    private
      const k_max_count = 4;
    public
      var circle_shape: tb2_circle_shape;
      var transform: tb2_transform;
      var debug_draw: t_draw;
      var count: tb2_int32;
      constructor Create;
      destructor Destroy;
      procedure DrawFixture(const fixture: pb2_fixture);
      function ReportFixture(const fixture: pb2_fixture): boolean;
    end;
    const k_max_bodies = 256;
    var _body_index: tb2_int32;
    var _bodies: array[0..k_max_bodies - 1] of pb2_body;
    var _polygons: array[0..3] of tb2_polygon_shape;
    var _circle: tb2_circle_shape;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CreateBody(const index: tb2_int32);
    procedure DestroyBody;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TPrismaticTest = class (TTest)
  private
    var _joint: pb2_prismatic_joint;
  public
    constructor Create; override;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TPulleysTest = class (TTest)
  private
    var _joint1: pb2_pulley_joint;
  public
    constructor Create; override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TPyramidTest = class (TTest)
  private
    const k_count = 20;
  public
    constructor Create; override;
    procedure Step(var Settings: TSettings); override;
  end;

  TRayCastTest = class (TTest)
  public
    type TRayCastClosestCallback = object
    public
      var hit: boolean;
      var hit_point: tb2_vec2;
      var hit_normal: tb2_vec2;
      constructor Create;
      function ReportFixture(const fixture: pb2_fixture; const point, normal: tb2_vec2; const fraction: tb2_float32): tb2_float32;
    end;
    TRayCastAnyCallback = object
    public
      var hit: boolean;
      var hit_point: tb2_vec2;
      var hit_normal: tb2_vec2;
      constructor Create;
      function ReportFixture(const fixture: pb2_fixture; const point, normal: tb2_vec2; const fraction: tb2_float32): tb2_float32;
    end;
    TRayCastMultipleCallback = object
    public
      const k_max_count = 16;
      var points: array [0..k_max_count - 1] of tb2_vec2;
      var normals: array[0..k_max_count - 1] of tb2_vec2;
      var count: tb2_int32;
      constructor Create;
      function ReportFixture(const fixture: pb2_fixture; const point, normal: tb2_vec2; const fraction: tb2_float32): tb2_float32;
    end;
    const k_max_bodies = 256;
    type TMode = (
      e_closest,
      e_any,
      e_multiple
    );
    var body_index: tb2_int32;
    var bodies: array[0..k_max_bodies - 1] of pb2_body;
    var user_data: array[0..k_max_bodies - 1] of tb2_int32;
    var polygons: array[0..3] of tb2_polygon_shape;
    var circle: tb2_circle_shape;
    var edge: tb2_edge_shape;
    var angle: tb2_float32;
    var mode: TMode;
    var point1, point2: tb2_vec2;
    var CallbackClosest: TRayCastClosestCallback;
    var CallbackAny: TRayCastAnyCallback;
    var CallbackMultiple: TRayCastMultipleCallback;
    constructor Create; override;
    destructor Destroy; override;
    procedure CreateBody(const index: tb2_int32);
    procedure DestroyBody;
    procedure Keyboard(const key: tb2_int32); override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TRevoluteTest = class (TTest)
  private
    var _ball: pb2_body;
    var _joint: pb2_revolute_joint;
  public
    constructor Create; override;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TRopeJointTest = class (TTest)
  private
    var _rope_def: tb2_rope_joint_def;
    var _rope: pb2_rope_joint;
  public
    constructor Create; override;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TSensorTest = class (TTest)
  private
    const k_count = 7;
    var _sensor: pb2_fixture;
    var _bodies: array[0..k_count - 1] of pb2_body;
    var _touching: array[0..k_count - 1] of boolean;
  public
    constructor Create; override;
    procedure begin_contact(const contact: pb2_contact); override;
    procedure end_contact(const contact: pb2_contact); override;
    procedure Step(var Settings: TSettings); override;
  end;

  TShapeEditingTest = class (TTest)
  private
    var _body: pb2_body;
    var _fixture1: pb2_fixture;
    var _fixture2: pb2_fixture;
    var _sensor: boolean;
  public
    constructor Create; override;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TSliderCrankTest = class (TTest)
  private
    var _joint1: pb2_revolute_joint;
    var _joint2: pb2_prismatic_joint;
  public
    constructor Create; override;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TSphereStackTest = class (TTest)
  private
    const k_count = 10;
  public
    constructor Create; override;
  end;

  TTheoJansenTest = class (TTest)
  private
    var _offset: tb2_vec2;
    var _chassis: pb2_body;
    var _wheel: pb2_body;
    var _motor_joint: pb2_revolute_joint;
    var _motor_on: boolean;
    var _motor_speed: tb2_float32;
  public
    procedure CreateLeg(const s: tb2_float32; const WheelAnchor: tb2_vec2);
    constructor Create; override;
    procedure Draw(const Settings: TSettings); override;
    procedure Keyboard(const Key: tb2_int32); override;
  end;

  TTilesTest = class (TTest)
  private
    const k_count = 20;
    var _fixture_count: tb2_int32;
    var _create_time: tb2_float32;
  public
    constructor Create; override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TTimeOfImpactTest = class (TTest)
  private
    var _sweep_a, _sweep_b: tb2_sweep;
    var _shape_a, _shape_b: tb2_polygon_shape;
    var _toi_output: tb2_toi_output;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TTumblerTest = class (TTest)
  private
    const k_count = 800;
    var _joint: pb2_revolute_joint;
    var _count: tb2_int32;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Step(var Settings: TSettings); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TVaryingFrictionTest = class (TTest)
  public
    constructor Create; override;
  end;

  TVaryingRestitutionTest = class (TTest)
  public
    constructor Create; override;
  end;

  TVerticalStackTest = class (TTest)
  private
    const k_column_count = 1;
    const k_row_count = 15;
    var _bullet: pb2_body;
    var _bodies: array[0..k_row_count * k_column_count - 1] of pb2_body;
    var _indices: array[0..k_row_count * k_column_count - 1] of tb2_int32;
  public
    constructor Create; override;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure Draw(const Settings: TSettings); override;
  end;

  TWebTest = class (TTest)
  private
    var _bodies: array[0..3] of pb2_body;
    var _joints: array[0..7] of pb2_joint;
  public
    constructor Create; override;
    procedure Keyboard(const Key: tb2_int32); override;
    procedure Draw(const Settings: TSettings); override;
    procedure JointDestroyed(const joint: pb2_joint); override;
  end;

  TGame = class
  protected
    var tests: array of CTest;
    var CurTest: Integer;
    var test: TTest;
    var font: TG2Font;
    var draw: t_draw;
    var disp_zoom: Single;
    var Settings: TSettings;
    var MousePos: TPoint;
    var PrevMdPos: TPoint;
    procedure AddTest(const TestClass: CTest);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    procedure Finalize;
    procedure Update;
    procedure Render;
    procedure KeyDown(const Key: Integer);
    procedure KeyUp(const Key: Integer);
    procedure MouseDown(const Button, x, y: Integer);
    procedure MouseUp(const Button, x, y: Integer);
    procedure Scroll(const y: Integer);
    procedure Print(const c: AnsiChar);
    procedure ResetTest;
    procedure PrevTest;
    procedure NextTest;
  end;

  function CreateSettings: TSettings;
  function RandomFloat: tb2_float32; inline;
  function RandomFloat(const l, h: tb2_float32): tb2_float32; inline;

var
  Game: TGame;
  disp: TG2Display2D;

implementation

const DRAW_STRING_NEW_LINE = 16;

//t_draw BEGIN
constructor t_draw.create;
begin
  inherited create;
  _font := TG2Font.Create;
  _font.Make(16);
end;

procedure t_draw.draw_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color);
  var i, i1: integer;
  var c: TG2Color;
  var v: pb2_vec2_arr absolute vertices;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $ff));
  for i := 0 to vertex_count - 1 do
  begin
    i1 := (i + 1) mod vertex_count;
    disp.PrimLine(v^[i].x, v^[i].y, v^[i1].x, v^[i1].y, c);
  end;
end;

procedure t_draw.draw_solid_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color);
  var i, i1, i2: integer;
  var c: TG2Color;
  var v: pb2_vec2_arr absolute vertices;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $80));
  for i := 0 to vertex_count - 2 do
  begin
    i1 := (i + 1) mod vertex_count;
    i2 := (i + 2) mod vertex_count;
    disp.PrimTriCol(
      v^[0].x, v^[0].y,
      v^[i1].x, v^[i1].y,
      v^[i2].x, v^[i2].y,
      c, c, c
    );
  end;
  draw_polygon(vertices, vertex_count, color);
end;

procedure t_draw.draw_circle(const center: tb2_vec2; const radius: tb2_float32; const color: tb2_color);
  var c: TG2Color;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $ff));
  disp.PrimCircleHollow(center.x, center.y, radius, c);
end;

procedure t_draw.draw_solid_circle(const center: tb2_vec2; const radius: tb2_float32; const axis: tb2_vec2; const color: tb2_color);
  var c: TG2Color;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $80));
  disp.PrimCircleCol(center.x, center.y, radius, c, c);
  disp.PrimLine(center.x, center.y, center.x + axis.x * radius, center.y + axis.y * radius, $ff000000);
  c.a := $ff;
  disp.PrimCircleHollow(center.x, center.y, radius, c);
end;

procedure t_draw.draw_segment(const p0, p1: tb2_vec2; const color: tb2_color);
  var c: TG2Color;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $ff));
  disp.PrimLine(p0.x, p0.y, p1.x, p1.y, c);
end;

procedure t_draw.draw_transform(const xf: tb2_transform);
  var v0, v1: TG2Vec2;
begin
  v0.SetValue(xf.p.x, xf.p.y);
  v1.SetValue(xf.p.x + xf.q.get_x_axis.x, xf.p.y +  + xf.q.get_x_axis.y);
  disp.PrimLine(v0, v1, $ffff0000);
  v1.SetValue(xf.p.x + xf.q.get_y_axis.x, xf.p.y +  + xf.q.get_y_axis.y);
  disp.PrimLine(v0, v1, $ff00ff00);
end;

procedure t_draw.draw_string(const x, y: single; const text: string);
begin
  _Font.Print(x, y, text);
end;

procedure t_draw.draw_string(const pos: tb2_vec2; const text: string);
begin
  draw_string(pos.x, pos.y, text);
end;

procedure t_draw.draw_aabb(const aabb: tb2_aabb; const color: tb2_color);
  var c: TG2Color;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $ff));
  disp.PrimRectHollow(
    aabb.lower_bound.x, aabb.lower_bound.y, aabb.upper_bound.x - aabb.lower_bound.x, aabb.upper_bound.y - aabb.lower_bound.y,
    c
  );
end;

procedure t_draw.draw_point(const v: tb2_vec2; const size: tb2_float32; const color: tb2_color);
  var c: TG2Color;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $ff));
  disp.PrimCircleCol(G2Vec2(v.x, v.y), size, c, c);
end;
//t_draw END

//TDestructionListener BEGIN
procedure TDestructionListener.say_goodbye(const joint: pb2_joint);
begin
  if pb2_joint(test._mouse_joint) = joint then
  test._mouse_joint := nil
  else
  test.JointDestroyed(joint);
end;

procedure TDestructionListener.say_goodbye(const fixture: pb2_fixture);
begin
end;
//TDestructionListener END

//TTest BEGIN
function TTest.TFixtureQuery.Callback(const fixture: pb2_fixture): boolean;
  var body: pb2_body;
  var inside: boolean;
begin
  query_fixture := nil;
  body := fixture^.get_body;
  if body^.get_type = b2_dynamic_body then
  begin
    inside := fixture^.test_point(point);
    if inside then
    begin
      query_fixture := fixture;
      result := false;
      exit;
    end;
  end;
  result := true;
end;

constructor TTest.Create;
  var gravity: tb2_vec2;
  var body_def: tb2_body_def;
begin
  inherited Create;
  disp.Position := G2Vec2(0, 0);
  gravity.set_value(0.0, -10.0);
  new(_world);
  _world^.create(gravity);
  _bomb := nil;
  _text_line := 30;
  _mouse_joint := nil;
  _point_count := 0;
  _destruction_listener := TDestructionListener.Create;
  _destruction_listener.test := Self;
  _world^.set_destruction_listener(_destruction_listener);
  _world^.set_contact_listener(Self);
  _world^.set_debug_draw(Game.draw);
  _bomb_spawning := false;
  _step_count := 0;
  body_def := b2_body_def;
  _ground_body := _world^.create_body(body_def);
  fillchar(_max_profile, sizeof(tb2_profile), 0);
  fillchar(_total_profile, sizeof(tb2_profile), 0);
end;

destructor TTest.Destroy;
begin
  _destruction_listener.Free;
  _world^.destroy;
  dispose(_world);
  _world := nil;
  inherited Destroy;
end;

procedure TTest.DrawTitle(const Text: String);
begin
  Game.draw.draw_string(5, DRAW_STRING_NEW_LINE, Text);
  _text_line := 3 * DRAW_STRING_NEW_LINE;
end;

procedure TTest.Step(var Settings: TSettings);
  var time_step: tb2_float32;
  var flags: tb2_draw_flag_set;
  var profile: tb2_profile;
begin
  if Settings.hz > 0.0 then time_step := 1.0 / settings.hz else time_step := 0.0;
  if Settings.pause then
  begin
    if Settings.single_step then Settings.single_step := false else exit;
  end;
  flags := [];
  if settings.draw_shapes then flags += [b2_df_shape];
  if settings.draw_joints then flags += [b2_df_joint];
  if settings.draw_aabbs then flags += [b2_df_aabb];
  if settings.draw_coms then flags += [b2_df_center_of_mass];
  Game.draw.draw_flags := flags;
  _world^.set_allow_sleeping(settings.enable_sleep);
  _world^.set_warm_starting(settings.enable_warm_starting);
  _world^.set_continuous_physics(settings.enable_continuous);
  _world^.set_sub_stepping(settings.enable_sub_stepping);
  _point_count := 0;
  _world^.step(time_step, settings.velocity_iterations, settings.position_iterations);
  if time_step > 0.0 then inc(_step_count);

  profile := _world^.get_profile^;
  _max_profile.step := b2_max(_max_profile.step, profile.step);
  _max_profile.collide := b2_max(_max_profile.collide, profile.collide);
  _max_profile.solve := b2_max(_max_profile.solve, profile.solve);
  _max_profile.solve_init := b2_max(_max_profile.solve_init, profile.solve_init);
  _max_profile.solve_velocity := b2_max(_max_profile.solve_velocity, profile.solve_velocity);
  _max_profile.solve_position := b2_max(_max_profile.solve_position, profile.solve_position);
  _max_profile.solve_toi := b2_max(_max_profile.solve_toi, profile.solve_toi);
  _max_profile.broad_phase := b2_max(_max_profile.broad_phase, profile.broad_phase);

  _total_profile.step += profile.step;
  _total_profile.collide += profile.collide;
  _total_profile.solve += profile.solve;
  _total_profile.solve_init += profile.solve_init;
  _total_profile.solve_velocity += profile.solve_velocity;
  _total_profile.solve_position += profile.solve_position;
  _total_profile.solve_toi += profile.solve_toi;
  _total_profile.broad_phase += profile.broad_phase;
end;

procedure TTest.Draw(const Settings: TSettings);
  var body_count, contact_count, joint_count, proxy_count, height, balance: tb2_int32;
  var quality, scale: tb2_float32;
  var p: pb2_profile;
  var p1, p2, tangent: tb2_vec2;
  var c: tb2_color;
  var avg_profile: tb2_profile;
  var i: tb2_int32;
  var cp: PContactPoint;
  const impulse_scale = 0.1;
  const axis_scale = 0.3;
begin
  _text_line := 0;
  _world^.draw_debug_data;
  Game.draw.draw_string(5, _text_line, 'FPS: ' + IntToStr(g2.FPS));
  _text_line += DRAW_STRING_NEW_LINE;
  if Settings.pause then
  begin
    Game.draw.draw_string(5, _text_line, '****PAUSED****');
    _text_line += DRAW_STRING_NEW_LINE;
  end;
  if Settings.draw_stats then
  begin
    body_count := _world^.get_body_count;
    contact_count := _world^.get_contact_count;
    joint_count := _world^.get_joint_count;
    Game.draw.draw_string(5, _text_line, 'bodies/contacts/joints = ' + inttostr(body_count) + '/' + inttostr(contact_count) + '/' + inttostr(joint_count));
    _text_line += DRAW_STRING_NEW_LINE;
    proxy_count := _world^.get_proxy_count;
    height := _world^.get_tree_height;
    balance := _world^.get_tree_balance;
    quality := _world^.get_tree_quality;
    Game.draw.draw_string(5, _text_line, 'proxies/height/balance/quality = ' + inttostr(proxy_count) + '/' + inttostr(height) + '/' + inttostr(balance) + '/' + floattostr(quality));
    _text_line += DRAW_STRING_NEW_LINE;
  end;
  if settings.draw_profile then
  begin
    p := _world^.get_profile;
    fillchar(avg_profile, sizeof(tb2_profile), 0);
    if _step_count > 0 then
    begin
      scale := 1.0 / _step_count;
      avg_profile.step := scale * _total_profile.step;
      avg_profile.collide := scale * _total_profile.collide;
      avg_profile.solve := scale * _total_profile.solve;
      avg_profile.solve_init := scale * _total_profile.solve_init;
      avg_profile.solve_velocity := scale * _total_profile.solve_velocity;
      avg_profile.solve_position := scale * _total_profile.solve_position;
      avg_profile.solve_toi := scale * _total_profile.solve_toi;
      avg_profile.broad_phase := scale * _total_profile.broad_phase;
    end;
    Game.draw.draw_string(5, _text_line, 'step [ave] (max) = ' + floattostr(p^.step) + ' [' + floattostr(avg_profile.step) + '] (' + floattostr(_max_profile.step) + ')');
    _text_line += DRAW_STRING_NEW_LINE;
    Game.draw.draw_string(5, _text_line, 'collide [ave] (max) = ' + floattostr(p^.collide) + ' [' + floattostr(avg_profile.collide) + '] (' + floattostr(_max_profile.collide) + ')');
    _text_line += DRAW_STRING_NEW_LINE;
    Game.draw.draw_string(5, _text_line, 'solve [ave] (max) = ' + floattostr(p^.solve) + ' [' + floattostr(avg_profile.solve) + '] (' + floattostr(_max_profile.solve) + ')');
    _text_line += DRAW_STRING_NEW_LINE;
    Game.draw.draw_string(5, _text_line, 'solve init [ave] (max) = ' + floattostr(p^.solve_init) + ' [' + floattostr(avg_profile.solve_init) + '] (' + floattostr(_max_profile.solve_init) + ')');
    _text_line += DRAW_STRING_NEW_LINE;
    Game.draw.draw_string(5, _text_line, 'solve velocity [ave] (max) = ' + floattostr(p^.solve_velocity) + ' [' + floattostr(avg_profile.solve_velocity) + '] (' + floattostr(_max_profile.solve_velocity) + ')');
    _text_line += DRAW_STRING_NEW_LINE;
    Game.draw.draw_string(5, _text_line, 'solve position [ave] (max) = ' + floattostr(p^.solve_position) + ' [' + floattostr(avg_profile.solve_position) + '] (' + floattostr(_max_profile.solve_position) + ')');
    _text_line += DRAW_STRING_NEW_LINE;
    Game.draw.draw_string(5, _text_line, 'solveTOI [ave] (max) = ' + floattostr(p^.solve_toi) + ' [' + floattostr(avg_profile.solve_toi) + '] (' + floattostr(_max_profile.solve_toi) + ')');
    _text_line += DRAW_STRING_NEW_LINE;
    Game.draw.draw_string(5, _text_line, 'broad-phase [ave] (max) = ' + floattostr(p^.broad_phase) + ' [' + floattostr(avg_profile.broad_phase) + '] (' + floattostr(_max_profile.broad_phase) + ')');
    _text_line += DRAW_STRING_NEW_LINE;
  end;
  if _mouse_joint <> nil then
  begin
    p1 := _mouse_joint^.get_anchor_b;
    p2 := _mouse_joint^.get_target;
    c.set_value(0.0, 1.0, 0.0);
    Game.draw.draw_point(p1, 0.1, c);
    Game.draw.draw_point(p2, 0.1, c);
    c.set_value(0.8, 0.8, 0.8);
    Game.draw.draw_segment(p1, p2, c);
  end;
  if _bomb_spawning then
  begin
    c.set_value(0.0, 0.0, 1.0);
    Game.draw.draw_point(_bomb_spawn_point, 0.4, c);
    c.set_value(0.8, 0.8, 0.8);
    Game.draw.draw_segment(_mouse_world, _bomb_spawn_point, c);
  end;
  if Settings.draw_contact_points then
  begin
    for i := 0 to _point_count - 1 do
    begin
      cp := @_points[i];
      if cp^.state = b2_add_state then
      Game.draw.draw_point(cp^.position, 10.0, b2_color(0.3, 0.95, 0.3))
      else if cp^.state = b2_persist_state then
      Game.draw.draw_point(cp^.position, 5.0, b2_color(0.3, 0.3, 0.95));
      if Settings.draw_contact_normals then
      begin
	p1 := cp^.position;
	p2 := p1 + axis_scale * cp^.normal;
	Game.draw.draw_segment(p1, p2, b2_color(0.9, 0.9, 0.9));
      end
      else if Settings.draw_contact_impulse then
      begin
	p1 := cp^.position;
	p2 := p1 + impulse_scale * cp^.normal_impulse * cp^.normal;
	Game.draw.draw_segment(p1, p2, b2_color(0.9, 0.9, 0.3));
      end;
      if Settings.draw_friction_impulse then
      begin
	tangent := b2_cross(cp^.normal, 1.0);
	p1 := cp^.position;
	p2 := p1 + impulse_scale * cp^.tangent_impulse * tangent;
	Game.draw.draw_segment(p1, p2, b2_color(0.9, 0.9, 0.3));
      end;
    end;
  end;
end;

procedure TTest.Keyboard(const key: tb2_int32);
begin
end;

procedure TTest.KeyboardUp(const key: tb2_int32);
begin
end;

procedure TTest.ShiftMouseDown(const p: tb2_vec2);
begin
  _mouse_world := p;
  if _mouse_joint <> nil then exit;
  SpawnBomb(p);
end;

procedure TTest.MouseDown(const p: tb2_vec2);
  var aabb: tb2_aabb;
  var d: tb2_vec2;
  var FixtureQuery: TFixtureQuery;
  var body: pb2_body;
  var md: tb2_mouse_joint_def;
begin
  _mouse_world := p;
  if _mouse_joint <> nil then exit;
  d.set_value(0.001, 0.001);
  aabb.lower_bound := p - d;
  aabb.upper_bound := p + d;
  FixtureQuery.point := p;
  FixtureQuery.query_fixture := nil;
  _world^.query_aabb(@FixtureQuery.Callback, aabb);
  if FixtureQuery.query_fixture <> nil then
  begin
    body := FixtureQuery.query_fixture^.get_body;
    md := b2_mouse_joint_def;
    md.body_a := _ground_body;
    md.body_b := body;
    md.target := p;
    md.max_force := 1000.0 * body^.get_mass;
    _mouse_joint := pb2_mouse_joint(_world^.create_joint(md));
    body^.set_awake(true);
  end;
end;

procedure TTest.MouseUp(const p: tb2_vec2);
begin
  if _mouse_joint <> nil then
  begin
    _world^.destroy_joint(_mouse_joint);
    _mouse_joint := nil;
  end;
  if _bomb_spawning then CompleteBombSpawn(p);
end;

procedure TTest.MouseMove(const p: tb2_vec2);
begin
  _mouse_world := p;
  if _mouse_joint <> nil then _mouse_joint^.set_target(p);
end;

procedure TTest.LaunchBomb;
  var p, v: tb2_vec2;
begin
  p.set_value(RandomFloat(-15.0, 15.0), 30.0);
  v := -5.0 * p;
  LaunchBomb(p, v);
end;

procedure TTest.LaunchBomb(const position: tb2_vec2; const velocity: tb2_vec2);
  var bd: tb2_body_def;
  var circle: tb2_circle_shape;
  var fd: tb2_fixture_def;
  var min_v, max_v: tb2_vec2;
  var aabb: tb2_aabb;
begin
  if _bomb <> nil then
  begin
    _world^.destroy_body(_bomb);
    _bomb := nil;
  end;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position := position;
  bd.bullet := true;
  _bomb := _world^.create_body(bd);
  _bomb^.set_linear_velocity(velocity);
  circle.create;
  circle.radius := 0.3;
  fd := b2_fixture_def;
  fd.shape := @circle;
  fd.density := 20.0;
  fd.restitution := 0.0;
  min_v := position - b2_vec2(0.3, 0.3);
  max_v := position + b2_vec2(0.3, 0.3);
  aabb.lower_bound := min_v;
  aabb.upper_bound := max_v;
  _bomb^.create_fixture(fd);
  circle.destroy;
end;

procedure TTest.SpawnBomb(const world_pt: tb2_vec2);
begin
  _bomb_spawn_point := world_pt;
  _bomb_spawning := true;
end;

procedure TTest.CompleteBombSpawn(const p: tb2_vec2);
  const multiplier = 30.0;
  var vel: tb2_vec2;
begin
  if not _bomb_spawning then exit;
  vel := _bomb_spawn_point - p;
  vel *= multiplier;
  LaunchBomb(_bomb_spawn_point, vel);
  _bomb_spawning := false;
end;

procedure TTest.JointDestroyed(const joint: pb2_joint);
begin
end;

procedure TTest.pre_solve(const contact: pb2_contact; const old_manifold: pb2_manifold);
  var manifold: pb2_manifold;
  var fixture_a, fixture_b: pb2_fixture;
  var state1, state2: array[0..b2_max_manifold_points - 1] of tb2_point_state;
  var world_manifold: tb2_world_manifold;
  var i: tb2_int32;
  var cp: PContactPoint;
begin
  manifold := contact^.get_manifold;
  if manifold^.point_count = 0 then exit;
  fixture_a := contact^.get_fixture_a;
  fixture_b := contact^.get_fixture_b;
  b2_get_point_states(state1, state2, old_manifold, manifold);
  contact^.get_world_manifold(world_manifold);
  for i := 0 to manifold^.point_count - 1 do
  begin
    if _point_count >= max_contact_points then break;
    cp := @_points[_point_count];
    cp^.fixture_a := fixture_a;
    cp^.fixture_b := fixture_b;
    cp^.position := world_manifold.points[i];
    cp^.normal := world_manifold.normal;
    cp^.state := state2[i];
    cp^.normal_impulse := manifold^.points[i].normal_impulse;
    cp^.tangent_impulse := manifold^.points[i].tangent_impulse;
    cp^.separation := world_manifold.separations[i];
    inc(_point_count);
  end;
end;

procedure TTest.post_solve(const contact: pb2_contact; const impulse: pb2_contact_impulse);
begin
end;

procedure TTest.ShiftOrigin(const new_origin: tb2_vec2);
begin
  _world^.shift_origin(new_origin);
end;
//TTest END

//TBodyTypesTest BEGIN
constructor TBodyTypesTest.Create;
  var ground: pb2_body;
  var bd: tb2_body_def;
  var edge_shape: tb2_edge_shape;
  var poly_shape: tb2_polygon_shape;
  var fd: tb2_fixture_def;
  var rjd: tb2_revolute_joint_def;
  var pjd: tb2_prismatic_joint_def;
  var body: pb2_body;
begin
  inherited Create;
  ground := nil;
  //Create ground
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-20.0, 0.0), b2_vec2(20.0, 0.0));
    fd := b2_fixture_def;
    fd.shape := @edge_shape;
    ground^.create_fixture(fd);
    edge_shape.destroy;
  end;
  //Create attachment
  begin
    bd := b2_body_def;;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(0.0, 3.0);
    _attachment := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(0.5, 2.0);
    _attachment^.create_fixture(@poly_shape, 2.0);
    poly_shape.destroy;
  end;
  //Create platform
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-4.0, 5.0);
    _platform := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(0.5, 4.0, b2_vec2(4.0, 0.0), 0.5 * b2_pi);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.friction := 0.6;
    fd.density := 2.0;
    _platform^.create_fixture(fd);
    rjd := b2_revolute_joint_def;
    rjd.initialize(_attachment, _platform, b2_vec2(0.0, 5.0));
    rjd.max_motor_torque := 50.0;
    rjd.enable_motor := true;
    _world^.create_joint(rjd);
    pjd := b2_prismatic_joint_def;
    pjd.Initialize(ground, _platform, b2_vec2(0.0, 5.0), b2_vec2(1.0, 0.0));
    pjd.max_motor_force := 1000.0;
    pjd.enable_motor := true;
    pjd.lower_translation := -10.0;
    pjd.upper_translation := 10.0;
    pjd.enable_limit := true;
    _world^.create_joint(pjd);
    _speed := 3.0;
    poly_shape.destroy;
  end;
  //Create a payload
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(0.0, 8.0);
    body := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(0.75, 0.75);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.friction := 0.6;
    fd.density := 2.0;
    body^.create_fixture(fd);
    poly_shape.destroy;
  end;
end;

procedure TBodyTypesTest.Keyboard(const key: tb2_int32);
begin
  case key of
    G2K_D: _platform^.set_type(b2_dynamic_body);
    G2K_S: _platform^.set_type(b2_static_body);
    G2K_K:
    begin
      _platform^.set_type(b2_kinematic_body);
      _platform^.set_linear_velocity(b2_vec2(-_speed, 0.0));
      _platform^.set_angular_velocity(0.0);
    end;
  end;
end;

procedure TBodyTypesTest.Step(var Settings: TSettings);
  var p, v: tb2_vec2;
begin
  if (_platform <> nil) and (_platform^.get_type = b2_kinematic_body) then
  begin
    p := _platform^.get_transform.p;
    v := _platform^.get_linear_velocity;
    if (
       ((p.x < -10.0) and (v.x < 0.0))
       or ((p.x > 10.0) and (v.x > 0.0))
    ) then
    begin
      v.x := -v.x;
      _platform^.set_linear_velocity(v);
    end;
  end;
  inherited Step(Settings);
end;

procedure TBodyTypesTest.Draw(const Settings: TSettings);
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'Keys: (d) dynamic, (s) static, (k) kinematic');
  _text_line += DRAW_STRING_NEW_LINE;
end;
//TBodyTypesTest END

//TBasicSliderCrankTest BEGIN
constructor TBasicSliderCrankTest.Create;
  var ground, prev_body: pb2_body;
  var bd: tb2_body_def;
  var poly_shape: tb2_polygon_shape;
  var edge_shape: tb2_edge_shape;
  var body: pb2_body;
  var rjd: tb2_revolute_joint_def;
  var pjd: tb2_prismatic_joint_def;
  var fd: tb2_fixture_def;
begin
  inherited Create;
  ground := nil;
  begin
    bd := b2_body_def;
    bd.position.set_value(0.0, 0.0);
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-20.0, 0.0), b2_vec2(20.0, 0.0));
    fd := b2_fixture_def;
    fd.shape := @edge_shape;
    ground^.create_fixture(fd);
    edge_shape.destroy;
  end;
  begin
    prev_body := ground;
    // Define crank.
    begin
      poly_shape.create;
      poly_shape.set_as_box(4.0, 1.0);
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(-8.0, 20.0);
      body := _world^.create_body(bd);
      body^.create_fixture(@poly_shape, 2.0);
      rjd := b2_revolute_joint_def;
      rjd.initialize(prev_body, body, b2_vec2(-12.0, 20.0));
      _world^.create_joint(rjd);
      prev_body := body;
      poly_shape.destroy;
    end;
    // Define connecting rod
    begin
      poly_shape.create;
      poly_shape.set_as_box(8.0, 1.0);
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(4.0, 20.0);
      body := _world^.create_body(bd);
      body^.create_fixture(@poly_shape, 2.0);
      rjd := b2_revolute_joint_def;
      rjd.initialize(prev_body, body, b2_vec2(-4.0, 20.0));
      _world^.create_joint(rjd);
      prev_body := body;
      poly_shape.destroy;
    end;
    // Define piston
    begin
      poly_shape.create;
      poly_shape.set_as_box(3.0, 3.0);
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.fixed_rotation := true;
      bd.position.set_value(12.0, 20.0);
      body := _world^.create_body(bd);
      body^.create_fixture(@poly_shape, 2.0);
      rjd := b2_revolute_joint_def;
      rjd.initialize(prev_body, body, b2_vec2(12.0, 20.0));
      _world^.create_joint(rjd);
      pjd := b2_prismatic_joint_def;
      pjd.initialize(ground, body, b2_vec2(12.0, 17.0), b2_vec2(1.0, 0.0));
      _world^.create_joint(pjd);
      poly_shape.destroy;
    end;
  end;
end;
//TBasicSliderCrankTest END

//TApplyForceTest BEGIN
constructor TApplyForceTest.Create;
  const restitution = 0.4;
  var ground: pb2_body;
  var bd: tb2_body_def;
  var edge_shape: tb2_edge_shape;
  var poly1, poly2: tb2_polygon_shape;
  var sd: tb2_fixture_def;
  var xf1: tb2_transform;
  var vertices: array[0..2] of tb2_vec2;
  var sd1: tb2_fixture_def;
  var xf2: tb2_transform;
  var sd2: tb2_fixture_def;
  var i: Integer;
  var body: pb2_body;
  var gravity: Extended;
  var inertia: tb2_float32;
  var mass: tb2_float32;
  var radius: tb2_float32;
  var fjd: tb2_friction_joint_def;
  var fd: tb2_fixture_def;
begin
  inherited Create;
  _world^.set_gravity(b2_vec2(0.0, 0.0));
  begin
    bd := b2_body_def;
    bd.position.set_value(0.0, 20.0);
    ground := _world^.create_body(bd);
    edge_shape.create;
    sd := b2_fixture_def;
    sd.shape := @edge_shape;
    sd.density := 0.0;
    sd.restitution := restitution;
    // Left vertical
    edge_shape.set_edge(b2_vec2(-20.0, -20.0), b2_vec2(-20.0, 20.0));
    ground^.create_fixture(sd);
    // Right vertical
    edge_shape.set_edge(b2_vec2(20.0, -20.0), b2_vec2(20.0, 20.0));
    ground^.create_fixture(sd);
    // Top horizontal
    edge_shape.set_edge(b2_vec2(-20.0, 20.0), b2_vec2(20.0, 20.0));
    ground^.create_fixture(sd);
    // Bottom horizontal
    edge_shape.set_edge(b2_vec2(-20.0, -20.0), b2_vec2(20.0, -20.0));
    ground^.create_fixture(sd);
    edge_shape.destroy;
  end;
  begin
    xf1.q.set_value(0.3524 * b2_pi);
    xf1.p := xf1.q.get_x_axis;
    vertices[0] := b2_mul(xf1, b2_vec2(-1.0, 0.0));
    vertices[1] := b2_mul(xf1, b2_vec2(1.0, 0.0));
    vertices[2] := b2_mul(xf1, b2_vec2(0.0, 0.5));
    poly1.create;
    poly1.set_polygon(@vertices, 3);
    sd1 := b2_fixture_def;
    sd1.shape := @poly1;
    sd1.density := 4.0;
    xf2.q.set_value(-0.3524 * b2_pi);
    xf2.p := -xf2.q.get_x_axis;
    vertices[0] := b2_mul(xf2, b2_vec2(-1.0, 0.0));
    vertices[1] := b2_mul(xf2, b2_vec2(1.0, 0.0));
    vertices[2] := b2_mul(xf2, b2_vec2(0.0, 0.5));
    poly2.create;
    poly2.set_polygon(@vertices, 3);
    sd2 := b2_fixture_def;
    sd2.shape := @poly2;
    sd2.density := 4.0;
    bd.body_type := b2_dynamic_body;
    bd.angular_damping := 2.0;
    bd.linear_damping := 0.5;
    bd.position.set_value(0.0, 2.0);
    bd.angle := b2_pi;
    bd.allow_sleep := false;
    _body := _world^.create_body(bd);
    _body^.create_fixture(sd1);
    _body^.create_fixture(sd2);
    poly1.destroy;
    poly2.destroy;
  end;
  begin
    poly1.create;
    poly1.set_as_box(0.5, 0.5);
    fd := b2_fixture_def;
    fd.shape := @poly1;
    fd.density := 1.0;
    fd.friction := 0.3;
    for i := 0 to 9 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(0.0, 5.0 + 1.54 * i);
      body := _world^.create_body(bd);
      body^.create_fixture(fd);
      gravity := 10.0;
      inertia := body^.get_inertia;
      mass := body^.get_mass;
      radius := b2_sqrt(2.0 * inertia / mass);
      fjd := b2_friction_joint_def;
      fjd.local_anchor_a.set_zero;
      fjd.local_anchor_b.set_zero;
      fjd.body_a := ground;
      fjd.body_b := body;
      fjd.collide_connected := true;
      fjd.max_force := mass * gravity;
      fjd.max_torque := mass * radius * gravity;
      _world^.create_joint(fjd);
    end;
  end;
end;

procedure TApplyForceTest.Keyboard(const key: tb2_int32);
  var f: tb2_vec2;
  var p: tb2_vec2;
begin
  case key of
    G2K_W:
    begin
      f := _body^.get_world_vector(b2_vec2(0.0, -200.0));
      p := _body^.get_world_point(b2_vec2(0.0, -2.0));
      _body^.apply_force(f, p, true);
    end;
    G2K_A:
    begin
      _body^.apply_torque(-50.0, true);
    end;
    G2K_D:
    begin
      _body^.apply_torque(50.0, true);
    end;
  end;
end;
//TApplyForceTest END

//TAddPairTest BEGIN
constructor TAddPairTest.Create;
  var circle_shape: tb2_circle_shape;
  var poly_shape: tb2_polygon_shape;
  var minX: Single;
  var maxX: Single;
  var minY: Single;
  var maxY: Single;
  var i: Integer;
  var bd: tb2_body_def;
  var body: pb2_body;
begin
  inherited Create;
  _world^.set_gravity(b2_vec2(0.0, 0.0));
  begin
    circle_shape.create;
    circle_shape.center.set_zero;
    circle_shape.radius := 0.1;
    minX := -6.0;
    maxX := 0.0;
    minY := 4.0;
    maxY := 6.0;
    for i := 0 to 399 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position := b2_vec2(RandomFloat(minX, maxX), RandomFloat(minY, maxY));
      body := _world^.create_body(bd);
      body^.create_fixture(@circle_shape, 0.01);
    end;
    circle_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(1.5, 1.5);
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-40.0, 5.0);
    bd.bullet := true;
    body := _world^.create_body(bd);
    body^.create_fixture(@poly_shape, 1.0);
    body^.set_linear_velocity(b2_vec2(150.0, 0.0));
    poly_shape.destroy;
  end;
end;
//TAddPairTest END

//TBreakableTest BEGIN
constructor TBreakableTest.Create;
  var bd: tb2_body_def;
  var ground: pb2_body;
  var edge_shape: tb2_edge_shape;
begin
  inherited Create;
  // Ground body
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  // Breakable dynamic body
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(0.0, 40.0);
    bd.angle := 0.25 * b2_pi;
    _body1 := _world^.create_body(bd);
    _shape1.create;
    _shape1.set_as_box(0.5, 0.5, b2_vec2(-0.5, 0.0), 0.0);
    _piece1 := _body1^.create_fixture(@_shape1, 1.0);
    _shape2.create;
    _shape2.set_as_box(0.5, 0.5, b2_vec2(0.5, 0.0), 0.0);
    _piece2 := _body1^.create_fixture(@_shape2, 1.0);
  end;
  _break := false;
  _broke := false;
end;

destructor TBreakableTest.Destroy;
begin
  _shape1.destroy;
  _shape2.destroy;
end;

procedure TBreakableTest.post_solve(const contact: pb2_contact; const impulse: pb2_contact_impulse);
  var count: tb2_int32;
  var max_impulse: tb2_float32;
  var i: Integer;
begin
  if _broke then
  begin
    // The body already broke.
    exit;
  end;
  // Should the body break?
  count := contact^.get_manifold^.point_count;
  max_impulse := 0.0;
  for i := 0 to count - 1 do
  max_impulse := b2_max(max_impulse, impulse^.normal_impulses[i]);
  if max_impulse > 40.0 then
  begin
    // Flag the body for breaking.
    _break := true;
  end;
end;

procedure TBreakableTest.DoBreak;
var
  body1: pb2_body;
  center: tb2_vec2;
  bd: tb2_body_def;
  body2: pb2_body;
  center1: tb2_vec2;
  center2: tb2_vec2;
  velocity1: tb2_vec2;
  velocity2: tb2_vec2;
begin
  body1 := _piece1^.get_body;
  center := body1^.get_world_center;
  body1^.destroy_fixture(_piece2);
  _piece2 := nil;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position := body1^.get_position;
  bd.angle := body1^.get_angle;
  body2 := _world^.create_body(bd);
  _piece2 := body2^.create_fixture(@_shape2, 1.0);
  center1 := body1^.get_world_center;
  center2 := body2^.get_world_center;
  velocity1 := _velocity + b2_cross(_angular_velocity, center1 - center);
  velocity2 := _velocity + b2_cross(_angular_velocity, center2 - center);
  body1^.set_angular_velocity(_angular_velocity);
  body1^.set_linear_velocity(velocity1);
  body2^.set_angular_velocity(_angular_velocity);
  body2^.set_linear_velocity(velocity2);
end;

procedure TBreakableTest.Step(var Settings: TSettings);
begin
  if _break then
  begin
    DoBreak;
    _broke := true;
    _break := false;
  end;
  if not _broke then
  begin
    _velocity := _body1^.get_linear_velocity;
    _angular_velocity := _body1^.get_angular_velocity;
  end;
  inherited Step(Settings);
end;
//TBreakableTest END

//TBridgeTest BEGIN
constructor TBridgeTest.Create;
  var ground: pb2_body;
  var bd: tb2_body_def;
  var edge_shape: tb2_edge_shape;
  var poly_shape: tb2_polygon_shape;
  var rjd: tb2_revolute_joint_def;
  var fd: tb2_fixture_def;
  var body: pb2_body;
  var anchor: tb2_vec2;
  var i: Integer;
  var vertices: array[0..2] of tb2_vec2;
  var circle_shape: tb2_circle_shape;
  var prev_body: pb2_body;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.6, 0.2);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 20.0;
    fd.friction := 0.2;
    rjd := b2_revolute_joint_def;
    prev_body := ground;
    for i := 0 to NumLinks - 1 do
    begin
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(-14.5 + 1.0 * i, 5.0);
      body := _world^.create_body(bd);
      body^.create_fixture(fd);
      anchor.set_value(-15.0 + 1.0 * i, 5.0);
      rjd.initialize(prev_body, body, anchor);
      _world^.create_joint(rjd);
      if i = NumLinks shr 1 then
      _middle := body;
      prev_body := body;
    end;
    anchor.set_value(-15.0 + 1.0 * NumLinks, 5.0);
    rjd.initialize(prev_body, ground, anchor);
    _world^.create_joint(rjd);
    poly_shape.destroy;
  end;
  for i := 0 to 1 do
  begin
    vertices[0].set_value(-0.5, 0.0);
    vertices[1].set_value(0.5, 0.0);
    vertices[2].set_value(0.0, 1.5);
    poly_shape.create;
    poly_shape.set_polygon(@vertices, 3);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 1.0;
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-8.0 + 8.0 * i, 12.0);
    body := _world^.create_body(bd);
    body^.create_fixture(fd);
    poly_shape.destroy;
  end;
  for i := 0 to 2 do
  begin
    circle_shape.create;
    circle_shape.radius := 0.5;
    fd := b2_fixture_def;
    fd.shape := @circle_shape;
    fd.density := 1.0;
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-6.0 + 6.0 * i, 10.0);
    body := _world^.create_body(bd);
    body^.create_fixture(fd);
    circle_shape.destroy;
  end;
end;
//TBridgeTest END

//TBulletTest BEIGN
constructor TBulletTest.Create;
  var bd: tb2_body_def;
    body: pb2_body;
    edge_shape: tb2_edge_shape;
    poly_shape: tb2_polygon_shape;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    bd.position.set_value(0.0, 0.0);
    body := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-10.0, 0.0), b2_vec2(10.0, 0.0));
    body^.create_fixture(@edge_shape, 0.0);
    poly_shape.create;
    poly_shape.set_as_box(0.2, 1.0, b2_vec2(0.5, 1.0), 0.0);
    body^.create_fixture(@poly_shape, 0.0);
    edge_shape.destroy;
    poly_shape.destroy;
  end;
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(0.0, 4.0);
    poly_shape.create;
    poly_shape.set_as_box(2.0, 0.1);
    _body := _world^.create_body(bd);
    _body^.create_fixture(@poly_shape, 1.0);
    poly_shape.set_as_box(0.25, 0.25);
    _x := 0.20352793;
    bd.position.set_value(_x, 10.0);
    bd.bullet := true;
    _bullet := _world^.create_body(bd);
    _bullet^.create_fixture(@poly_shape, 100.0);
    _bullet^.set_linear_velocity(b2_vec2(0.0, -50.0));
    poly_shape.destroy;
  end;
end;

procedure TBulletTest.Launch;
begin
  _body^.set_transform(b2_vec2(0.0, 4.0), 0.0);
  _body^.set_linear_velocity(b2_vec2_zero);
  _body^.set_angular_velocity(0.0);
  _x := RandomFloat(-1.0, 1.0);
  _bullet^.set_transform(b2_vec2(_x, 10.0), 0.0);
  _bullet^.set_linear_velocity(b2_vec2(0.0, -50.0));
  _bullet^.set_angular_velocity(0.0);
  //extern int32 b2_gjkCalls, b2_gjkIters, b2_gjkMaxIters;
  //extern int32 b2_toiCalls, b2_toiIters, b2_toiMaxIters;
  //extern int32 b2_toiRootIters, b2_toiMaxRootIters;

  //b2_gjkCalls = 0;
  //b2_gjkIters = 0;
  //b2_gjkMaxIters = 0;
  //
  //b2_toiCalls = 0;
  //b2_toiIters = 0;
  //b2_toiMaxIters = 0;
  //b2_toiRootIters = 0;
  //b2_toiMaxRootIters = 0;
end;

procedure TBulletTest.Step(var Settings: TSettings);
begin
  inherited Step(Settings);
//
//  extern int32 b2_gjkCalls, b2_gjkIters, b2_gjkMaxIters;
//  extern int32 b2_toiCalls, b2_toiIters;
//  extern int32 b2_toiRootIters, b2_toiMaxRootIters;
//
//  if (b2_gjkCalls > 0)
//  {
//	  g_debugDraw.DrawString(5, m_textLine, "gjk calls = %d, ave gjk iters = %3.1f, max gjk iters = %d",
//		  b2_gjkCalls, b2_gjkIters / float32(b2_gjkCalls), b2_gjkMaxIters);
//	  m_textLine += DRAW_STRING_NEW_LINE;
//  }
//
//  if (b2_toiCalls > 0)
//  {
//	  g_debugDraw.DrawString(5, m_textLine, "toi calls = %d, ave toi iters = %3.1f, max toi iters = %d",
//		  b2_toiCalls, b2_toiIters / float32(b2_toiCalls), b2_toiMaxRootIters);
//	  m_textLine += DRAW_STRING_NEW_LINE;
//
//	  g_debugDraw.DrawString(5, m_textLine, "ave toi root iters = %3.1f, max toi root iters = %d",
//		  b2_toiRootIters / float32(b2_toiCalls), b2_toiMaxRootIters);
//	  m_textLine += DRAW_STRING_NEW_LINE;
//  }

  if _step_count mod 60 = 0 then Launch;
end;
//TBulletTest END

//TCantileverTest BEGIN
constructor TCantileverTest.Create;
  var ground: pb2_body;
    bd: tb2_body_def;
    edge_shape: tb2_edge_shape;
    poly_shape: tb2_polygon_shape;
    fd: tb2_fixture_def;
    wjd: tb2_weld_joint_def;
    prev_body: pb2_body;
    i: Integer;
    body: pb2_body;
    anchor: tb2_vec2;
    vertices: array[0..2] of tb2_vec2;
    circle_shape: tb2_circle_shape;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.5, 0.125);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 20.0;
    wjd := b2_weld_joint_def;
    prev_body := ground;
    for i := 0 to Num - 1 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(-14.5 + 1.0 * i, 5.0);
      body := _world^.create_body(bd);
      body^.create_fixture(fd);
      anchor.set_value(-15.0 + 1.0 * i, 5.0);
      wjd.initialize(prev_body, body, anchor);
      _world^.create_joint(wjd);
      prev_body := body;
    end;
    poly_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(1.0, 0.125);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 20.0;
    wjd := b2_weld_joint_def;
    wjd.frequency_hz := 5.0;
    wjd.damping_ratio := 0.7;
    prev_body := ground;
    for i := 0 to 2 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(-14.0 + 2.0 * i, 15.0);
      body := _world^.create_body(bd);
      body^.create_fixture(fd);
      anchor.set_value(-15.0 + 2.0 * i, 15.0);
      wjd.initialize(prev_body, body, anchor);
      _world^.create_joint(wjd);
      prev_body := body;
    end;
    poly_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.5, 0.125);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 20.0;
    wjd := b2_weld_joint_def;
    prev_body := ground;
    for i := 0 to Num - 1 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(-4.5 + 1.0 * i, 5.0);
      body := _world^.create_body(bd);
      body^.create_fixture(fd);
      if i > 0 then
      begin
	anchor.set_value(-5.0 + 1.0 * i, 5.0);
	wjd.initialize(prev_body, body, anchor);
	_world^.create_joint(wjd);
      end;
      prev_body := body;
    end;
    poly_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.5, 0.125);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 20.0;
    wjd := b2_weld_joint_def;
    wjd.frequency_hz := 8.0;
    wjd.damping_ratio := 0.7;
    prev_body := ground;
    for i := 0 to Num - 1 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(5.5 + 1.0 * i, 10.0);
      body := _world^.create_body(bd);
      body^.create_fixture(fd);
      if i > 0 then
      begin
	anchor.set_value(5.0 + 1.0 * i, 10.0);
	wjd.initialize(prev_body, body, anchor);
	_world^.create_joint(wjd);
      end;
      prev_body := body;
    end;
    poly_shape.destroy;
  end;
  for i := 0 to 1 do
  begin
    vertices[0].set_value(-0.5, 0.0);
    vertices[1].set_value(0.5, 0.0);
    vertices[2].set_value(0.0, 1.5);
    poly_shape.create;
    poly_shape.set_polygon(@vertices, 3);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 1.0;
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-8.0 + 8.0 * i, 12.0);
    body := _world^.create_body(bd);
    body^.create_fixture(fd);
    poly_shape.destroy;
  end;
  for i := 0 to 1 do
  begin
    circle_shape.create;
    circle_shape.radius := 0.5;
    fd := b2_fixture_def;
    fd.shape := @circle_shape;
    fd.density := 1.0;
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-6.0 + 6.0 * i, 10.0);
    body := _world^.create_body(bd);
    body^.create_fixture(fd);
    circle_shape.destroy;
  end;
end;
//TCantileverTest END

//TCarTest BEGIN
constructor TCarTest.Create;
  var ground: pb2_body;
    bd: tb2_body_def;
    edge_shape: tb2_edge_shape;
    fd: tb2_fixture_def;
    x, y1, y2, dx: tb2_float32;
    i: Integer;
    body: pb2_body;
    poly_shape: tb2_polygon_shape;
    rjd: tb2_revolute_joint_def;
    N: tb2_int32;
    prev_body: pb2_body;
    anchor: tb2_vec2;
    vertices: array[0..7] of tb2_vec2;
    circle_shape: tb2_circle_shape;
    wjd: tb2_wheel_joint_def;
    axis: tb2_vec2;
  const hs: array[0..9] of tb2_float32 = (0.25, 1.0, 4.0, 0.0, 0.0, -1.0, -2.0, -2.0, -1.25, 0.0);
begin
  inherited Create;
  _hz := 4.0;
  _zeta := 0.7;
  _speed := 50.0;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    fd := b2_fixture_def;
    fd.shape := @edge_shape;
    fd.density := 0.0;
    fd.friction := 0.6;
    edge_shape.set_edge(b2_vec2(-20.0, 0.0), b2_vec2(20.0, 0.0));
    ground^.create_fixture(fd);
    x := 20.0; y1 := 0.0; dx := 5.0;
    for i := 0 to high(hs) do
    begin
      y2 := hs[i];
      edge_shape.set_edge(b2_vec2(x, y1), b2_vec2(x + dx, y2));
      ground^.create_fixture(fd);
      y1 := y2;
      x += dx;
    end;
    for i := 0 to high(hs) do
    begin
      y2 := hs[i];
      edge_shape.set_edge(b2_vec2(x, y1), b2_vec2(x + dx, y2));
      ground^.create_fixture(fd);
      y1 := y2;
      x += dx;
    end;
    edge_shape.set_edge(b2_vec2(x, 0.0), b2_vec2(x + 40.0, 0.0));
    ground^.create_fixture(fd);
    x += 80.0;
    edge_shape.set_edge(b2_vec2(x, 0.0), b2_vec2(x + 40.0, 0.0));
    ground^.create_fixture(fd);
    x += 40.0;
    edge_shape.set_edge(b2_vec2(x, 0.0), b2_vec2(x + 10.0, 5.0));
    ground^.create_fixture(fd);
    x += 20.0;
    edge_shape.set_edge(b2_vec2(x, 0.0), b2_vec2(x + 40.0, 0.0));
    ground^.create_fixture(fd);
    x += 40.0;
    edge_shape.set_edge(b2_vec2(x, 0.0), b2_vec2(x, 20.0));
    ground^.create_fixture(fd);
    edge_shape.destroy;
  end;
  // Teeter
  begin
    bd := b2_body_def;
    bd.position.set_value(140.0, 1.0);
    bd.body_type := b2_dynamic_body;
    body := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(10.0, 0.25);
    body^.create_fixture(@poly_shape, 1.0);
    rjd := b2_revolute_joint_def;
    rjd.initialize(ground, body, body^.get_position);
    rjd.lower_angle := -8.0 * b2_pi / 180.0;
    rjd.upper_angle := 8.0 * b2_pi / 180.0;
    rjd.enable_limit := true;
    _world^.create_joint(rjd);
    body^.apply_angular_impulse(100.0, true);
    poly_shape.destroy;
  end;
  // Bridge
  begin
    N := 20;
    poly_shape.create;
    poly_shape.set_as_box(1.0, 0.125);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 1.0;
    fd.friction := 0.6;
    rjd := b2_revolute_joint_def;
    prev_body := ground;
    for i := 0 to N - 1 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(161.0 + 2.0 * i, -0.125);
      body := _world^.create_body(bd);
      body^.create_fixture(fd);
      anchor.set_value(160.0 + 2.0 * i, -0.125);
      rjd.initialize(prev_body, body, anchor);
      _world^.create_joint(rjd);
      prev_body := body;
    end;
    anchor.set_value(160.0 + 2.0 * N, -0.125);
    rjd.initialize(prev_body, ground, anchor);
    _world^.create_joint(rjd);
    poly_shape.destroy;
  end;
  // Boxes
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.5, 0.5);
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(230.0, 0.5);
    body := _world^.create_body(bd);
    body^.create_fixture(@poly_shape, 0.5);
    bd.position.set_value(230.0, 1.5);
    body := _world^.create_body(bd);
    body^.create_fixture(@poly_shape, 0.5);
    bd.position.set_value(230.0, 2.5);
    body := _world^.create_body(bd);
    body^.create_fixture(@poly_shape, 0.5);
    bd.position.set_value(230.0, 3.5);
    body := _world^.create_body(bd);
    body^.create_fixture(@poly_shape, 0.5);
    bd.position.set_value(230.0, 4.5);
    body := _world^.create_body(bd);
    body^.create_fixture(@poly_shape, 0.5);
    poly_shape.destroy;
  end;
  // Car
  begin
    poly_shape.create;
    vertices[0].set_value(-1.5, -0.5);
    vertices[1].set_value(1.5, -0.5);
    vertices[2].set_value(1.5, 0.0);
    vertices[3].set_value(0.0, 0.9);
    vertices[4].set_value(-1.15, 0.9);
    vertices[5].set_value(-1.5, 0.2);
    poly_shape.set_polygon(@vertices, 6);
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(0.0, 1.0);
    _car := _world^.create_body(bd);
    _car^.create_fixture(@poly_shape, 1.0);
    circle_shape.create;
    circle_shape.radius := 0.4;
    fd := b2_fixture_def;
    fd.shape := @circle_shape;
    fd.density := 1.0;
    fd.friction := 0.9;
    bd.position.set_value(-1.0, 0.35);
    _wheel1 := _world^.create_body(bd);
    _wheel1^.create_fixture(fd);
    bd.position.set_value(1.0, 0.4);
    _wheel2 := _world^.create_body(bd);
    _wheel2^.create_fixture(fd);
    wjd := b2_wheel_joint_def;
    axis.set_value(0.0, 1.0);
    wjd.initialize(_car, _wheel1, _wheel1^.get_position, axis);
    wjd.motor_speed := 0.0;
    wjd.max_motor_torque := 20.0;
    wjd.enable_motor := true;
    wjd.frequency_hz := _hz;
    wjd.damping_ratio := _zeta;
    _spring1 := pb2_wheel_joint(_world^.create_joint(wjd));
    wjd.initialize(_car, _wheel2, _wheel2^.get_position, axis);
    wjd.motor_speed := 0.0;
    wjd.max_motor_torque := 10.0;
    wjd.enable_motor := false;
    wjd.frequency_hz := _hz;
    wjd.damping_ratio := _zeta;
    _spring2 := pb2_wheel_joint(_world^.create_joint(wjd));
    poly_shape.destroy;
    circle_shape.destroy;
  end;
end;

procedure TCarTest.Keyboard(const Key: tb2_int32);
begin
  case Key of
    G2K_A: _spring1^.set_motor_speed(-_speed);
    G2K_S: _spring1^.set_motor_speed(0.0);
    G2K_D: _spring1^.set_motor_speed(_speed);
    G2K_Q:
    begin
      _hz := b2_max(0.0, _hz - 1.0);
      _spring1^.set_spring_frequency_hz(_hz);
      _spring2^.set_spring_frequency_hz(_hz);
    end;
    G2K_E:
    begin
      _hz += 1.0;
      _spring1^.set_spring_frequency_hz(_hz);
      _spring2^.set_spring_frequency_hz(_hz);
    end;
  end;
end;

procedure TCarTest.Step(var Settings: TSettings);
begin
  inherited Step(Settings);
  disp.Position := G2Vec2(_car^.get_position.x, disp.Position.y);
end;

procedure TCarTest.Draw(const Settings: TSettings);
begin
  inherited Draw(Settings);
  Game.Draw.draw_string(5, _text_line, 'Keys: left = a, brake = s, right = d, hz down = q, hz up = e');
  _text_line += DRAW_STRING_NEW_LINE;
  Game.Draw.draw_string(5, _text_line, 'frequency = ' + floattostr(_hz) + ' hz, damping ratio = ' + floattostr(_zeta));
  _text_line += DRAW_STRING_NEW_LINE;
end;
//TCarTest END

//TChainTest BEGIN
constructor TChainTest.Create;
  var ground: pb2_body;
  bd: tb2_body_def;
  edge_shape: tb2_edge_shape;
  poly_shape: tb2_polygon_shape;
  fd: tb2_fixture_def;
  rjd: tb2_revolute_joint_def;
  prev_body: pb2_body;
  body: pb2_body;
  anchor: tb2_vec2;
  i: Integer;
  const y = 25.0;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.6, 0.125);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 20.0;
    fd.friction := 0.2;
    rjd := b2_revolute_joint_def;
    rjd.collide_connected := false;
    prev_body := ground;
    for i := 0 to 30 - 1 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(0.5 + i, y);
      body := _world^.create_body(bd);
      body^.create_fixture(fd);
      anchor.set_value(i, y);
      rjd.initialize(prev_body, body, anchor);
      _world^.create_joint(rjd);
      prev_body := body;
    end;
    edge_shape.destroy;
  end;
end;
//TChainTest END

//TCharacterCollisionTest BEGIN
constructor TCharacterCollisionTest.Create;
  var ground: pb2_body;
  var edge_shape: tb2_edge_shape;
  var vs: array[0..9] of tb2_vec2;
  var chain_shape: tb2_chain_shape;
  var poly_shape: tb2_polygon_shape;
  var bd: tb2_body_def;
  var body: pb2_body;
  var angle: tb2_float32;
  var delta: tb2_float32;
  var circle_shape: tb2_circle_shape;
  var fd: tb2_fixture_def;
  var i: Integer;
begin
  inherited Create;
  // Ground body
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-20.0, 0.0), b2_vec2(20.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  // Collinear edges with no adjacency information.
  // This shows the problematic case where a box shape can hit
  // an internal vertex.
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-8.0, 1.0), b2_vec2(-6.0, 1.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.set_edge(b2_vec2(-6.0, 1.0), b2_vec2(-4.0, 1.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.set_edge(b2_vec2(-4.0, 1.0), b2_vec2(-2.0, 1.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  // Chain shape
  begin
    bd := b2_body_def;
    bd.angle := 0.25 * b2_pi;
    ground := _world^.create_body(bd);
    vs[0].set_value(5.0, 7.0);
    vs[1].set_value(6.0, 8.0);
    vs[2].set_value(7.0, 8.0);
    vs[3].set_value(8.0, 7.0);
    chain_shape.create;
    chain_shape.set_chain(@vs, 4);
    ground^.create_fixture(@chain_shape, 0.0);
    chain_shape.destroy;
  end;
  // Square tiles. This shows that adjacency shapes may
  // have non-smooth collision. There is no solution
  // to this problem.
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(1.0, 1.0, b2_vec2(4.0, 3.0), 0.0);
    ground^.create_fixture(@poly_shape, 0.0);
    poly_shape.set_as_box(1.0, 1.0, b2_vec2(6.0, 3.0), 0.0);
    ground^.create_fixture(@poly_shape, 0.0);
    poly_shape.set_as_box(1.0, 1.0, b2_vec2(8.0, 3.0), 0.0);
    ground^.create_fixture(@poly_shape, 0.0);
    poly_shape.destroy;
  end;
  // Square made from an edge loop. Collision should be smooth.
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    vs[0].set_value(-1.0, 3.0);
    vs[1].set_value(1.0, 3.0);
    vs[2].set_value(1.0, 5.0);
    vs[3].set_value(-1.0, 5.0);
    chain_shape.create;
    chain_shape.set_loop(@vs, 4);
    ground^.create_fixture(@chain_shape, 0.0);
    chain_shape.destroy;
  end;
  // Edge loop. Collision should be smooth.
  begin
    bd := b2_body_def;
    bd.position.set_value(-10.0, 4.0);
    ground := _world^.create_body(bd);
    vs[0].set_value(0.0, 0.0);
    vs[1].set_value(6.0, 0.0);
    vs[2].set_value(6.0, 2.0);
    vs[3].set_value(4.0, 1.0);
    vs[4].set_value(2.0, 2.0);
    vs[5].set_value(0.0, 2.0);
    vs[6].set_value(-2.0, 2.0);
    vs[7].set_value(-4.0, 3.0);
    vs[8].set_value(-6.0, 2.0);
    vs[9].set_value(-6.0, 0.0);
    chain_shape.create;
    chain_shape.set_loop(@vs, 10);
    ground^.create_fixture(@chain_shape, 0.0);
    chain_shape.destroy;
  end;
  // Square character 1
  begin
    bd := b2_body_def;
    bd.position.set_value(-3.0, 8.0);
    bd.body_type := b2_dynamic_body;
    bd.fixed_rotation := true;
    bd.allow_sleep := false;
    body := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(0.5, 0.5);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 20.0;
    body^.create_fixture(fd);
    poly_shape.destroy;
  end;
  // Square character 2
  begin
    bd := b2_body_def;
    bd.position.set_value(-5.0, 5.0);
    bd.body_type := b2_dynamic_body;
    bd.fixed_rotation := true;
    bd.allow_sleep := false;
    body := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(0.25, 0.25);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 20.0;
    body^.create_fixture(fd);
    poly_shape.destroy;
  end;
  // Hexagon character
  begin
    bd := b2_body_def;
    bd.position.set_value(-5.0, 8.0);
    bd.body_type := b2_dynamic_body;
    bd.fixed_rotation := true;
    bd.allow_sleep := false;
    body := _world^.create_body(bd);
    angle := 0.0;
    delta := b2_pi / 3.0;
    for i := 0 to  5 do
    begin
      vs[i].set_value(0.5 * cos(angle), 0.5 * sin(angle));
      angle += delta;
    end;
    poly_shape.create;
    poly_shape.set_polygon(@vs, 6);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 20.0;
    body^.create_fixture(fd);
    poly_shape.destroy;
  end;
  // Circle character
  begin
    bd := b2_body_def;
    bd.position.set_value(3.0, 5.0);
    bd.body_type := b2_dynamic_body;
    bd.fixed_rotation := true;
    bd.allow_sleep := false;
    body := _world^.create_body(bd);
    circle_shape.create;
    circle_shape.radius := 0.5;
    fd := b2_fixture_def;
    fd.shape := @circle_shape;
    fd.density := 20.0;
    body^.create_fixture(fd);
    circle_shape.destroy;
  end;
  // Circle character
  begin
    bd := b2_body_def;
    bd.position.set_value(-7.0, 6.0);
    bd.body_type := b2_dynamic_body;
    bd.fixed_rotation := true;
    bd.allow_sleep := false;
    _character := _world^.create_body(bd);
    circle_shape.create;
    circle_shape.radius := 0.25;
    fd := b2_fixture_def;
    fd.shape := @circle_shape;
    fd.density := 20.0;
    fd.friction := 1.0;
    _character^.create_fixture(fd);
    circle_shape.destroy;
  end;
end;

procedure TCharacterCollisionTest.Step(var Settings: TSettings);
  var v: tb2_vec2;
begin
  if (_character <> nil) then
  begin
    v := _character^.get_linear_velocity;
    v.x := -5.0;
    _character^.set_linear_velocity(v);
  end;
  inherited Step(Settings);
end;

procedure TCharacterCollisionTest.Draw(const Settings: TSettings);
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'This tests various character collision shapes.');
  _text_line += DRAW_STRING_NEW_LINE;
  Game.draw.draw_string(5, _text_line, 'Limitation: square and hexagon can snag on aligned boxes.');
  _text_line += DRAW_STRING_NEW_LINE;
  Game.draw.draw_string(5, _text_line, 'Feature: edge chains have smooth collision inside and out.');
  _text_line += DRAW_STRING_NEW_LINE;
end;
//TCharacterCollisionTest END

//TCollisionFilteringTest BEGIN
constructor TCollisionFilteringTest.Create;
var
  edge_shape: tb2_edge_shape;
  fd: tb2_fixture_def;
  bd: tb2_body_def;
  ground: pb2_body;
  var vertices: array[0..2] of tb2_vec2;
    poly_shape: tb2_polygon_shape;
    body1: pb2_body;
    body2: pb2_body;
    body: pb2_body;
    p: tb2_polygon_shape;
    pjd: tb2_prismatic_joint_def;
    body3: pb2_body;
    body4: pb2_body;
    circle_shape: tb2_circle_shape;
    body5: pb2_body;
    body6: pb2_body;
begin
  inherited Create;
  // Ground body
  begin
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    fd := b2_fixture_def;
    fd.shape := @edge_shape;
    fd.friction := 0.3;
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    ground^.create_fixture(fd);
    edge_shape.destroy;
  end;
  // Small triangle
  vertices[0].set_value(-1.0, 0.0);
  vertices[1].set_value(1.0, 0.0);
  vertices[2].set_value(0.0, 2.0);
  poly_shape.create;
  poly_shape.set_polygon(@vertices, 3);
  fd := b2_fixture_def;
  fd.shape := @poly_shape;
  fd.density := 1.0;
  fd.filter.group_index := k_small_group;
  fd.filter.category_bits := k_triangle_category;
  fd.filter.mask_bits := k_triangle_mask;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position.set_value(-5.0, 2.0);
  body1 := _world^.create_body(bd);
  body1^.create_fixture(fd);
  // Large triangle (recycle definitions)
  vertices[0] *= 2.0;
  vertices[1] *= 2.0;
  vertices[2] *= 2.0;
  poly_shape.set_polygon(@vertices, 3);
  fd.filter.group_index := k_large_group;
  bd.position.set_value(-5.0, 6.0);
  bd.fixed_rotation := true; // look at me!
  body2 := _world^.create_body(bd);
  body2^.create_fixture(fd);
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-5.0, 10.0);
    body := _world^.create_body(bd);
    p.create;
    p.set_as_box(0.5, 1.0);
    body^.create_fixture(@p, 1.0);
    pjd := b2_prismatic_joint_def;
    pjd.body_a := body2;
    pjd.body_b := body;
    pjd.enable_limit := true;
    pjd.local_anchor_a.set_value(0.0, 4.0);
    pjd.local_anchor_b.set_zero;
    pjd.local_axis_a.set_value(0.0, 1.0);
    pjd.lower_translation := -1.0;
    pjd.upper_translation := 1.0;
    _world^.create_joint(pjd);
    p.destroy;
  end;
  // Small box
  poly_shape.set_as_box(1.0, 0.5);
  fd := b2_fixture_def;
  fd.shape := @poly_shape;
  fd.density := 1.0;
  fd.restitution := 0.1;
  fd.filter.group_index := k_small_group;
  fd.filter.category_bits := k_box_category;
  fd.filter.mask_bits := k_box_mask;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position.set_value(0.0, 2.0);
  body3 := _world^.create_body(bd);
  body3^.create_fixture(fd);
  // Large box (recycle definitions)
  poly_shape.set_as_box(2.0, 1.0);
  fd.filter.group_index := k_large_group;
  bd.position.set_value(0.0, 6.0);
  body4 := _world^.create_body(bd);
  body4^.create_fixture(fd);
  // Small circle
  circle_shape.create;
  circle_shape.radius := 1.0;
  fd := b2_fixture_def;
  fd.shape := @circle_shape;
  fd.density := 1.0;
  fd.filter.group_index := k_small_group;
  fd.filter.category_bits := k_circle_category;
  fd.filter.mask_bits := k_circle_mask;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position.set_value(5.0, 2.0);
  body5 := _world^.create_body(bd);
  body5^.create_fixture(fd);
  // Large circle
  circle_shape.radius *= 2.0;
  fd.filter.group_index := k_large_group;
  bd.position.set_value(5.0, 6.0);
  body6 := _world^.create_body(bd);
  body6^.create_fixture(fd);
  poly_shape.destroy;
  circle_shape.destroy;
end;
//TCollisionFilteringTest END

//TCollisionProcessingTest BEGIN
constructor TCollisionProcessingTest.Create;
var
  edge_shape: tb2_edge_shape;
  fd: tb2_fixture_def;
  bd: tb2_body_def;
  ground: pb2_body;
  var x_lo, x_hi, y_lo, y_hi: tb2_float32;
  var vertices: array[0..2] of tb2_vec2;
    poly_shape: tb2_polygon_shape;
    body1: pb2_body;
    body2: pb2_body;
    body3: pb2_body;
    body4: pb2_body;
    circle_shape: tb2_circle_shape;
    body5: pb2_body;
    body6: pb2_body;
begin
  inherited Create;
  // Ground body
  begin
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-50.0, 0.0), b2_vec2(50.0, 0.0));
    fd := b2_fixture_def;
    fd.shape := @edge_shape;
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    ground^.create_fixture(fd);
    edge_shape.destroy;
  end;
  x_lo := -5.0; x_hi := 5.0;
  y_lo := 2.0; y_hi := 35.0;
  // Small triangle
  vertices[0].set_value(-1.0, 0.0);
  vertices[1].set_value(1.0, 0.0);
  vertices[2].set_value(0.0, 2.0);
  poly_shape.create;
  poly_shape.set_polygon(@vertices, 3);
  fd := b2_fixture_def;
  fd.shape := @poly_shape;
  fd.density := 1.0;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position.set_value(RandomFloat(x_lo, x_hi), RandomFloat(y_lo, y_hi));
  body1 := _world^.create_body(bd);
  body1^.create_fixture(fd);
  // Large triangle (recycle definitions)
  vertices[0] *= 2.0;
  vertices[1] *= 2.0;
  vertices[2] *= 2.0;
  poly_shape.set_polygon(@vertices, 3);
  bd.position.set_value(RandomFloat(x_lo, x_hi), RandomFloat(y_lo, y_hi));
  body2 := _world^.create_body(bd);
  body2^.create_fixture(fd);
  // Small box
  poly_shape.set_as_box(1.0, 0.5);
  fd := b2_fixture_def;
  fd.shape := @poly_shape;
  fd.density := 1.0;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position.set_value(RandomFloat(x_lo, x_hi), RandomFloat(y_lo, y_hi));
  body3 := _world^.create_body(bd);
  body3^.create_fixture(fd);
  // Large box (recycle definitions)
  poly_shape.set_as_box(2.0, 1.0);
  bd.position.set_value(RandomFloat(x_lo, x_hi), RandomFloat(y_lo, y_hi));
  body4 := _world^.create_body(bd);
  body4^.create_fixture(fd);
  // Small circle
  circle_shape.create;
  circle_shape.radius := 1.0;
  fd := b2_fixture_def;
  fd.shape := @circle_shape;
  fd.density := 1.0;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position.set_value(RandomFloat(x_lo, x_hi), RandomFloat(y_lo, y_hi));
  body5 := _world^.create_body(bd);
  body5^.create_fixture(fd);
  // Large circle
  circle_shape.radius *= 2.0;
  bd.position.set_value(RandomFloat(x_lo, x_hi), RandomFloat(y_lo, y_hi));
  body6 := _world^.create_body(bd);
  body6^.create_fixture(fd);
  poly_shape.destroy;
  circle_shape.destroy;
end;

procedure TCollisionProcessingTest.Step(var Settings: TSettings);
  const  k_max_nuke = 6;
  var nuke: array[0..k_max_nuke - 1] of pb2_body;
  var nuke_count: tb2_int32;
  var cp: PContactPoint;
  var body1: pb2_body;
  var mass1, mass2: tb2_float32;
    body2: pb2_body;
    b: pb2_body;
    i: Integer;
    j: Integer;
begin
  inherited Step(Settings);
  // We are going to destroy some bodies according to contact
  // points. We must buffer the bodies that should be destroyed
  // because they may belong to multiple contact points.
  nuke_count := 0;
  // Traverse the contact results. Destroy bodies that
  // are touching heavier bodies.
  for i := 0 to _point_count - 1 do
  begin
    cp := @_points[i];
    body1 := cp^.fixture_a^.get_body;
    body2 := cp^.fixture_b^.get_body;
    mass1 := body1^.get_mass;
    mass2 := body2^.get_mass;
    if (mass1 > 0.0) and (mass2 > 0.0) then
    begin
      if (mass2 > mass1) then
      begin
        nuke[nuke_count] := body1;
        inc(nuke_count);
      end
      else
      begin
        nuke[nuke_count] := body2;
        inc(nuke_count);
      end;
      if (nuke_count = k_max_nuke) then break;
    end;
  end;
  for i := 0 to nuke_count - 1 do
  begin
    b := nuke[i];
    if b <> nil then
    begin
      for j := i + 1 to nuke_count - 1 do
      if nuke[j] = b then
      nuke[j] := nil;
      if (b <> _bomb) then
      begin
        _world^.destroy_body(b);
      end;
    end;
  end;
end;
//TCollisionProcessingTest END

//TCompoundShapesTest BEGIN
constructor TCompoundShapesTest.Create;
var
  bd: tb2_body_def;
  body: pb2_body;
  edge_shape: tb2_edge_shape;
  circle_shape1: tb2_circle_shape;
  circle_shape2: tb2_circle_shape;
  i: Integer;
  x: tb2_float32;
  poly_shape1: tb2_polygon_shape;
  poly_shape2: tb2_polygon_shape;
  xf1: tb2_transform;
  vertices: array[0..2] of tb2_vec2;
  triangle1: tb2_polygon_shape;
  xf2: tb2_transform;
  triangle2: tb2_polygon_shape;
  bottom: tb2_polygon_shape;
  left: tb2_polygon_shape;
  right: tb2_polygon_shape;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    bd.position.set_value(0.0, 0.0);
    body := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(50.0, 0.0), b2_vec2(-50.0, 0.0));
    body^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    circle_shape1.create;
    circle_shape1.radius := 0.5;
    circle_shape1.center.set_value(-0.5, 0.5);
    circle_shape2.create;
    circle_shape2.radius := 0.5;
    circle_shape2.center.set_value(0.5, 0.5);
    for i := 0 to 9 do
    begin
      x := RandomFloat(-0.1, 0.1);
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(x + 5.0, 1.05 + 2.5 * i);
      bd.angle := RandomFloat(-b2_pi, b2_pi);
      body := _world^.create_body(bd);
      body^.create_fixture(@circle_shape1, 2.0);
      body^.create_fixture(@circle_shape2, 0.0);
    end;
    circle_shape1.destroy;
    circle_shape2.destroy;
  end;
  begin
    poly_shape1.create;
    poly_shape1.set_as_box(0.25, 0.5);
    poly_shape2.create;
    poly_shape2.set_as_box(0.25, 0.5, b2_vec2(0.0, -0.5), 0.5 * b2_pi);
    for i := 0 to 9 do
    begin
      x := RandomFloat(-0.1, 0.1);
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(x - 5.0, 1.05 + 2.5 * i);
      bd.angle := RandomFloat(-b2_pi, b2_pi);
      body := _world^.create_body(bd);
      body^.create_fixture(@poly_shape1, 2.0);
      body^.create_fixture(@poly_shape2, 2.0);
    end;
    poly_shape1.destroy;
    poly_shape2.destroy;
  end;
  begin
    xf1.q.set_value(0.3524 * b2_pi);
    xf1.p := xf1.q.get_x_axis;
    triangle1.create;
    vertices[0] := b2_mul(xf1, b2_vec2(-1.0, 0.0));
    vertices[1] := b2_mul(xf1, b2_vec2(1.0, 0.0));
    vertices[2] := b2_mul(xf1, b2_vec2(0.0, 0.5));
    triangle1.set_polygon(@vertices, 3);
    xf2.q.set_value(-0.3524 * b2_pi);
    xf2.p := -xf2.q.get_x_axis;
    triangle2.create;
    vertices[0] := b2_mul(xf2, b2_vec2(-1.0, 0.0));
    vertices[1] := b2_mul(xf2, b2_vec2(1.0, 0.0));
    vertices[2] := b2_mul(xf2, b2_vec2(0.0, 0.5));
    triangle2.set_polygon(@vertices, 3);
    for i := 0 to 9 do
    begin
      x := RandomFloat(-0.1, 0.1);
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(x, 2.05 + 2.5 * i);
      bd.angle := 0.0;
      body := _world^.create_body(bd);
      body^.create_fixture(@triangle1, 2.0);
      body^.create_fixture(@triangle2, 2.0);
    end;
    triangle1.destroy;
    triangle2.destroy;
  end;
  begin
    bottom.create;
    bottom.set_as_box(1.5, 0.15);
    left.create;
    left.set_as_box(0.15, 2.7, b2_vec2(-1.45, 2.35), 0.2);
    right.create;
    right.set_as_box(0.15, 2.7, b2_vec2(1.45, 2.35), -0.2);
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(0.0, 2.0);
    body := _world^.create_body(bd);
    body^.create_fixture(@bottom, 4.0);
    body^.create_fixture(@left, 4.0);
    body^.create_fixture(@right, 4.0);
    bottom.destroy;
    left.destroy;
    right.destroy;
  end;
end;
//TCompoundShapesTest END

//TConfinedTest BEGIN
constructor TConfinedTest.Create;
var
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  radius: tb2_float32;
  circle_shape: tb2_circle_shape;
  bd: tb2_body_def;
  body: pb2_body;
  fd: tb2_fixture_def;
  i: Integer;
  j: Integer;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-10.0, 0.0), b2_vec2(10.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    // Left wall
    edge_shape.set_edge(b2_vec2(-10.0, 0.0), b2_vec2(-10.0, 20.0));
    ground^.create_fixture(@edge_shape, 0.0);
    // Right wall
    edge_shape.set_edge(b2_vec2(10.0, 0.0), b2_vec2(10.0, 20.0));
    ground^.create_fixture(@edge_shape, 0.0);
    // Roof
    edge_shape.set_edge(b2_vec2(-10.0, 20.0), b2_vec2(10.0, 20.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  radius := 0.5;
  circle_shape.create;
  circle_shape.center.set_zero;
  circle_shape.radius := radius;
  fd := b2_fixture_def;
  fd.shape := @circle_shape;
  fd.density := 1.0;
  fd.friction := 0.1;
  for j := 0 to column_count - 1 do
  begin
    for i := 0 to row_count - 1 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(-10.0 + (2.1 * j + 1.0 + 0.01 * i) * radius, (2.0 * i + 1.0) * radius);
      body := _world^.create_body(bd);
      body^.create_fixture(fd);
    end;
  end;
  _world^.set_gravity(b2_vec2(0.0, 0.0));
  circle_shape.destroy;
end;

procedure TConfinedTest.CreateCircle;
  var radius: tb2_float32;
    circle_shape: tb2_circle_shape;
    fd: tb2_fixture_def;
    p: tb2_vec2;
    bd: tb2_body_def;
    body: pb2_body;
begin
  radius := 2.0;
  circle_shape.create;
  circle_shape.center.set_zero;
  circle_shape.radius := radius;
  fd := b2_fixture_def;
  fd.shape := @circle_shape;
  fd.density := 1.0;
  fd.friction := 0.0;
  p.set_value(RandomFloat, 3.0 + RandomFloat);
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position := p;
  //bd.allowSleep = false;
  body := _world^.create_body(bd);
  body^.create_fixture(fd);
  circle_shape.destroy;
end;

procedure TConfinedTest.Keyboard(const Key: tb2_int32);
begin
  inherited Keyboard(Key);
  case Key of
    G2K_C: CreateCircle();
  end;
end;

procedure TConfinedTest.Step(var Settings: TSettings);
var
  Sleeping: Boolean;
  b: pb2_body;
  p: tb2_vec2;
begin
  Sleeping := true;
  b := _world^.get_body_list;
  while b <> nil do
  begin
    if b^.get_type <> b2_dynamic_body then
    begin
      b := b^.get_next;
      Continue;
    end;
    if b^.is_awake then
    begin
      Sleeping := false;
    end;
    b := b^.get_next()
  end;
  if _step_count = 180 then
  begin
    _step_count += 0;
  end;

  //if (sleeping)
  //{
  //	CreateCircle();
  //}

  inherited Step(Settings);
  b := _world^.get_body_list;
  while b <> nil do
  begin
    if b^.get_type <> b2_dynamic_body then
    begin
      b := b^.get_next;
      Continue;
    end;
    p := b^.get_position;
    if (p.x <= -10.0) or (10.0 <= p.x) or (p.y <= 0.0) or (20.0 <= p.y) then
    begin
      p.x += 0.0;
    end;
    b := b^.get_next;
  end;
end;

procedure TConfinedTest.Draw(const Settings: TSettings);
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'Press ''c'' to create a circle.');
  _text_line += DRAW_STRING_NEW_LINE;
end;
//TConfinedTest END

//TContinuousTest BEGIN
constructor TContinuousTest.Create;
var
  edge_shape: tb2_edge_shape;
  bd: tb2_body_def;
  body: pb2_body;
  poly_shape: tb2_polygon_shape;
  circle_shape: tb2_circle_shape;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    bd.position.set_value(0.0, 0.0);
    body := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-10.0, 0.0), b2_vec2(10.0, 0.0));
    body^.create_fixture(@edge_shape, 0.0);
    poly_shape.create;
    poly_shape.set_as_box(0.2, 1.0, b2_vec2(0.5, 1.0), 0.0);
    body^.create_fixture(@poly_shape, 0.0);
    edge_shape.destroy;
    poly_shape.destroy;
  end;

  {$if 1}
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(0.0, 20.0);
    //bd.angle = 0.1f;
    poly_shape.create;
    poly_shape.set_as_box(2.0, 0.1);
    _body := _world^.create_body(bd);
    _body^.create_fixture(@poly_shape, 1.0);
    _angular_velocity := RandomFloat(-50.0, 50.0);
    //m_angularVelocity = 46.661274f;
    _body^.set_linear_velocity(b2_vec2(0.0, -100.0));
    _body^.set_angular_velocity(_angular_velocity);
    poly_shape.destroy;
  end;
  {$else}
  begin
    bd := b2_body_def;
    bd.&type := b2_dynamic_body;
    bd.position.set_value(0.0, 2.0);
    body := _world^.create_body(bd);
    circle_shape.create;
    circle_shape.cp.set_zero;
    circle_shape.radius := 0.5;
    body^.create_fixture(@circle_shape, 1.0);
    bd.bullet := true;
    bd.position.set_value(0.0, 10.0);
    body := _world^.create_body(bd);
    body^.create_fixture(@circle_shape, 1.0);
    body^.set_linear_velocity(b2_vec2(0.0, -100.0));
    circle_shape.destroy;
  end;
  {$endif}

  //extern int32 b2_gjkCalls, b2_gjkIters, b2_gjkMaxIters;
  //extern int32 b2_toiCalls, b2_toiIters;
  //extern int32 b2_toiRootIters, b2_toiMaxRootIters;
  //extern float32 b2_toiTime, b2_toiMaxTime;

  //b2_gjkCalls = 0; b2_gjkIters = 0; b2_gjkMaxIters = 0;
  //b2_toiCalls = 0; b2_toiIters = 0;
  //b2_toiRootIters = 0; b2_toiMaxRootIters = 0;
  //b2_toiTime = 0.0f; b2_toiMaxTime = 0.0f;
end;

procedure TContinuousTest.Launch;
begin
  //extern int32 b2_gjkCalls, b2_gjkIters, b2_gjkMaxIters;
  //extern int32 b2_toiCalls, b2_toiIters;
  //extern int32 b2_toiRootIters, b2_toiMaxRootIters;
  //extern float32 b2_toiTime, b2_toiMaxTime;

  //b2_gjkCalls = 0; b2_gjkIters = 0; b2_gjkMaxIters = 0;
  //b2_toiCalls = 0; b2_toiIters = 0;
  //b2_toiRootIters = 0; b2_toiMaxRootIters = 0;
  //b2_toiTime = 0.0f; b2_toiMaxTime = 0.0f;

  _body^.set_transform(b2_vec2(0.0, 20.0), 0.0);
  _angular_velocity := RandomFloat(-50.0, 50.0);
  _body^.set_linear_velocity(b2_vec2(0.0, -100.0));
  _body^.set_angular_velocity(_angular_velocity);
end;

procedure TContinuousTest.Step(var Settings: TSettings);
begin
  inherited Step(Settings);
  //extern int32 b2_gjkCalls, b2_gjkIters, b2_gjkMaxIters;
  //if (b2_gjkCalls > 0)
  //{
	 // g_debugDraw.DrawString(5, m_textLine, "gjk calls = %d, ave gjk iters = %3.1f, max gjk iters = %d",
		//  b2_gjkCalls, b2_gjkIters / float32(b2_gjkCalls), b2_gjkMaxIters);
	 // m_textLine += DRAW_STRING_NEW_LINE;
  //}
  //
  //extern int32 b2_toiCalls, b2_toiIters;
  //extern int32 b2_toiRootIters, b2_toiMaxRootIters;
  //extern float32 b2_toiTime, b2_toiMaxTime;
  //
  //if (b2_toiCalls > 0)
  //{
	 // g_debugDraw.DrawString(5, m_textLine, "toi calls = %d, ave [max] toi iters = %3.1f [%d]",
		//				  b2_toiCalls, b2_toiIters / float32(b2_toiCalls), b2_toiMaxRootIters);
	 // m_textLine += DRAW_STRING_NEW_LINE;
  //
	 // g_debugDraw.DrawString(5, m_textLine, "ave [max] toi root iters = %3.1f [%d]",
		//  b2_toiRootIters / float32(b2_toiCalls), b2_toiMaxRootIters);
	 // m_textLine += DRAW_STRING_NEW_LINE;
  //
	 // g_debugDraw.DrawString(5, m_textLine, "ave [max] toi time = %.1f [%.1f] (microseconds)",
		//  1000.0f * b2_toiTime / float32(b2_toiCalls), 1000.0f * b2_toiMaxTime);
	 // m_textLine += DRAW_STRING_NEW_LINE;
  //}

  if _step_count mod 60 = 0 then Launch;
end;
//TContinuousTest END

//TConvexHullTest BEGIN
constructor TConvexHullTest.Create;
begin
  inherited Create;
  Generate;
  _auto := false;
  _poly_shape.create;
end;

destructor TConvexHullTest.Destroy;
begin
  _poly_shape.destroy;
  inherited Destroy;
end;

procedure TConvexHullTest.Generate;
  var lower_bound, upper_bound: tb2_vec2;
  var i: tb2_int32;
  var x: tb2_float32;
  var y: tb2_float32;
  var v: tb2_vec2;
begin
  lower_bound.set_value(-8.0, -8.0);
  upper_bound.set_value(8.0, 8.0);
  for i := 0 to max_count - 1 do
  begin
    x := 10.0 * RandomFloat;
    y := 10.0 * RandomFloat;
    // Clamp onto a square to help create collinearities.
    // This will stress the convex hull algorithm.
    v.set_value(x, y);
    v := b2_clamp(v, lower_bound, upper_bound);
    _hull_points[i] := v;
  end;
  _count := max_count;
end;

procedure TConvexHullTest.Keyboard(const Key: tb2_int32);
begin
  case Key of
    G2K_A: _auto := not _auto;
    G2K_G: Generate;
  end;
end;

procedure TConvexHullTest.Step(var Settings: TSettings);
begin
  if _auto then Generate;
  inherited Step(Settings);
  _poly_shape.set_polygon(@_hull_points, _count);
end;

procedure TConvexHullTest.Draw(const Settings: TSettings);
var
  i: Integer;
  v: tb2_vec2;
  v2: TG2Vec2;
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'Press g to generate a new random convex hull');
  _text_line += DRAW_STRING_NEW_LINE;
  Game.draw.draw_polygon(@_poly_shape.vertices, _poly_shape.count, b2_color(0.9, 0.9, 0.9));
  for i := 0 to _count - 1 do
  begin
    Game.draw.draw_point(_hull_points[i], 0.1, b2_color(0.3, 0.9, 0.3));
    v := _hull_points[i] + b2_vec2(0.05, 0.05);
    v2 := disp.CoordToScreen(G2Vec2(v.x, v.y));
    v.set_value(v2.x, v2.y);
    Game.draw.draw_string(v, inttostr(i));
  end;
  if not _poly_shape.validate then _text_line += 0;
end;
//TConvexHullTest END

//TConveyorBeltTest BEGIN
constructor TConveyorBeltTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  poly_shape: tb2_polygon_shape;
  body: pb2_body;
  fd: tb2_fixture_def;
  i: Integer;
begin
  inherited Create;
  // Ground
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-20.0, 0.0), b2_vec2(20.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  // Platform
  begin
    bd := b2_body_def;
    bd.position.set_value(-5.0, 5.0);
    body := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(10.0, 0.5);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.friction := 0.8;
    _platform := body^.create_fixture(fd);
    poly_shape.destroy;
  end;
  // Boxes
  for i := 0 to 4 do
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-10.0 + 2.0 * i, 7.0);
    body := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(0.5, 0.5);
    body^.create_fixture(@poly_shape, 20.0);
  end;
end;

procedure TConveyorBeltTest.pre_solve(const contact: pb2_contact; const old_manifold: pb2_manifold);
var
  fixture_a: pb2_fixture;
  fixture_b: pb2_fixture;
begin
  inherited pre_solve(contact, old_manifold);
  fixture_a := contact^.get_fixture_a;
  fixture_b := contact^.get_fixture_b;
  if fixture_a = _platform then
  contact^.set_tangent_speed(5.0);
  if fixture_b = _platform then
  contact^.set_tangent_speed(-5.0);
end;
//TConveyorBeltTest END

//TDistanceTest BEGIN
constructor TDistanceTest.Create;
  var r: tb2_rot;
begin
  inherited Create;
  _polygon_a.create;
  _polygon_b.create;
  begin
    _transform_a.set_identity;
    _transform_a.p.set_value(0.0, -0.2);
    _polygon_a.set_as_box(10.0, 0.2);
  end;
  begin
    _position_b.set_value(12.017401, 0.13678508);
    _angle_b := -0.0109265;
    r.set_value(_angle_b);
    _transform_b.set_value(_position_b, r);
    _polygon_b.set_as_box(2.0, 0.1);
  end;
  fillchar(_dist_output, sizeof(_dist_output), 0);
end;

destructor TDistanceTest.Destroy;
begin
  _polygon_a.destroy;
  _polygon_b.destroy;
  inherited Destroy;
end;

procedure TDistanceTest.Step(var Settings: TSettings);
var
  dist_input: tb2_distance_input;
  cache: tb2_simplex_cache;
begin
  inherited Step(Settings);
  if g2.KeyDown[G2K_A] then _position_b.x += 0.1;
  if g2.KeyDown[G2K_D] then _position_b.x -= 0.1;
  if g2.KeyDown[G2K_S] then _position_b.y -= 0.1;
  if g2.KeyDown[G2K_W] then _position_b.y += 0.1;
  if g2.KeyDown[G2K_Q] then _angle_b += 0.02 * b2_pi;
  if g2.KeyDown[G2K_E] then _angle_b -= 0.02 * b2_pi;
  _transform_b.set_value(_position_b, _angle_b);
  dist_input.create;
  dist_input.proxy_a.set_shape(@_polygon_a, 0);
  dist_input.proxy_b.set_shape(@_polygon_b, 0);
  dist_input.transform_a := _transform_a;
  dist_input.transform_b := _transform_b;
  dist_input.use_radii := true;
  cache.count := 0;
  b2_distance(@_dist_output, @cache, @dist_input);
  dist_input.destroy;
end;

procedure TDistanceTest.Draw(const Settings: TSettings);
  var color: tb2_color;
  var v: array[0..b2_max_polygon_vertices - 1] of tb2_vec2;
  var i: Integer;
  var x1: tb2_vec2;
  var x2: tb2_vec2;
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'distance = ' + floattostr(_dist_output.distance));
  _text_line += DRAW_STRING_NEW_LINE;
  Game.draw.draw_string(5, _text_line, 'iterations = ' + inttostr(_dist_output.iterations));
  _text_line += DRAW_STRING_NEW_LINE;
  begin
    color.set_value(0.9, 0.9, 0.9);
    for i := 0 to _polygon_a.count - 1 do
    v[i] := b2_mul(_transform_a, _polygon_a.vertices[i]);
    Game.draw.draw_polygon(@v, _polygon_a.count, color);
    for i := 0 to _polygon_b.count - 1 do
    v[i] := b2_mul(_transform_b, _polygon_b.vertices[i]);
    Game.draw.draw_polygon(v, _polygon_b.count, color);
  end;
  x1 := _dist_output.point_a;
  x2 := _dist_output.point_b;
  color.set_value(1.0, 0.0, 0.0);
  Game.draw.draw_point(x1, 0.1, color);
  color.set_value(1.0, 1.0, 0.0);
  Game.draw.draw_point(x2, 0.1, color);
end;

procedure TDistanceTest.Keyboard(const Key: tb2_int32);
begin
  //case Key of
  //  G2K_A: _position_b.x -= 0.1;
  //  G2K_D: _position_b.x += 0.1;
  //  G2K_S: _position_b.y -= 0.1;
  //  G2K_W: _position_b.y += 0.1;
  //  G2K_Q: _angle_b += 0.1 * b2_pi;
  //  G2K_E: _angle_b -= 0.1 * b2_pi;
  //end;
  //_transform_b.set_value(_position_b, _angle_b);
end;
//TDistanceTest END

//TDominosTest BEGIN
constructor TDominosTest.Create;
  var b1: pb2_body;
    edge_shape: tb2_edge_shape;
    poly_shape: tb2_polygon_shape;
    bd: tb2_body_def;
    ground: pb2_body;
    body: pb2_body;
    b2: pb2_body;
    b3: pb2_body;
    anchor: tb2_vec2;
    rjd: tb2_revolute_joint_def;
    b4: pb2_body;
    b5: pb2_body;
    fd: tb2_fixture_def;
    b6: pb2_body;
    b7: pb2_body;
    djd: tb2_distance_joint_def;
    d: tb2_vec2;
    radius: tb2_float32;
    circle_shape: tb2_circle_shape;
    i: Integer;
begin
  inherited Create;
  begin
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    bd := b2_body_def;
    b1 := _world^.create_body(bd);
    b1^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(6.0, 0.25);
    bd := b2_body_def;
    bd.position.set_value(-1.5, 10.0);
    ground := _world^.create_body(bd);
    ground^.create_fixture(@poly_shape, 0.0);
    poly_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.1, 1.0);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 20.0;
    fd.friction := 0.1;
    for i := 0 to 9 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(-6.0 + 1.0 * i, 11.25);
      body := _world^.create_body(bd);
      body^.create_fixture(fd);
    end;
    poly_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(7.0, 0.25, b2_vec2_zero, 0.3);
    bd := b2_body_def;
    bd.position.set_value(1.0, 6.0);
    ground := _world^.create_body(bd);
    ground^.create_fixture(@poly_shape, 0.0);
    poly_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.25, 1.5);
    bd := b2_body_def;
    bd.position.set_value(-7.0, 4.0);
    b2 := _world^.create_body(bd);
    b2^.create_fixture(@poly_shape, 0.0);
    poly_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(6.0, 0.125);
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-0.9, 1.0);
    bd.angle := -0.15;
    b3 := _world^.create_body(bd);
    b3^.create_fixture(@poly_shape, 10.0);
    poly_shape.destroy;
  end;
  rjd := b2_revolute_joint_def;
  anchor.set_value(-2.0, 1.0);
  rjd.initialize(b1, b3, anchor);
  rjd.collide_connected := true;
  _world^.create_joint(rjd);
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.25, 0.25);
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-10.0, 15.0);
    b4 := _world^.create_body(bd);
    b4^.create_fixture(@poly_shape, 10.0);
    poly_shape.destroy;
  end;
  anchor.set_value(-7.0, 15.0);
  rjd.initialize(b2, b4, anchor);
  _world^.create_joint(rjd);
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(6.5, 3.0);
    b5 := _world^.create_body(bd);
    poly_shape.create;
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 10.0;
    fd.friction := 0.1;
    poly_shape.set_as_box(1.0, 0.1, b2_vec2(0.0, -0.9), 0.0);
    b5^.create_fixture(fd);
    poly_shape.set_as_box(0.1, 1.0, b2_vec2(-0.9, 0.0), 0.0);
    b5^.create_fixture(fd);
    poly_shape.set_as_box(0.1, 1.0, b2_vec2(0.9, 0.0), 0.0);
    b5^.create_fixture(fd);
    poly_shape.destroy;
  end;
  anchor.set_value(6.0, 2.0);
  rjd.initialize(b1, b5, anchor);
  _world^.create_joint(rjd);
  begin
    poly_shape.create;
    poly_shape.set_as_box(1.0, 0.1);
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(6.5, 4.1);
    b6 := _world^.create_body(bd);
    b6^.create_fixture(@poly_shape, 30.0);
    poly_shape.destroy;
  end;
  anchor.set_value(7.5, 4.0);
  rjd.initialize(b5, b6, anchor);
  _world^.create_joint(rjd);
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.1, 1.0);
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(7.4, 1.0);
    b7 := _world^.create_body(bd);
    b7^.create_fixture(@poly_shape, 10.0);
    poly_shape.destroy;
  end;
  djd := b2_distance_joint_def;
  djd.body_a := b3;
  djd.body_b := b7;
  djd.local_anchor_a.set_value(6.0, 0.0);
  djd.local_anchor_b.set_value(0.0, -1.0);
  d := djd.body_b^.get_world_point(djd.local_anchor_b) - djd.body_a^.get_world_point(djd.local_anchor_a);
  djd.len := d.len;
  _world^.create_joint(djd);
  begin
    radius := 0.2;
    circle_shape.create;
    circle_shape.radius := radius;
    for i := 0 to 3 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(5.9 + 2.0 * radius * i, 2.4);
      body := _world^.create_body(bd);
      body^.create_fixture(@circle_shape, 10.0);
    end;
  end;
end;
//TDominosTest END

//TDynamicTreeTest BEGIN
procedure TDynamicTreeTest.GetRandomAABB(var aabb: tb2_aabb);
  var w: tb2_vec2;
begin
  w.set_value(2.0 * _proxy_extent, 2.0 * _proxy_extent);
  aabb.lower_bound.x := RandomFloat(-_world_extent, _world_extent);
  aabb.lower_bound.y := RandomFloat(0.0, 2.0 * _world_extent);
  aabb.upper_bound := aabb.lower_bound + w;
end;

procedure TDynamicTreeTest.MoveAABB(var aabb: tb2_aabb);
  var d, c0, min_v, max_v, c: tb2_vec2;
begin
  d.x := RandomFloat(-0.5, 0.5);
  d.y := RandomFloat(-0.5, 0.5);
  aabb.lower_bound += d;
  aabb.upper_bound += d;
  c0 := 0.5 * (aabb.lower_bound + aabb.upper_bound);
  min_v.set_value(-_world_extent, 0.0);
  max_v.set_value(_world_extent, 2.0 * _world_extent);
  c := b2_clamp(c0, min_v, max_v);
  aabb.lower_bound += c - c0;
  aabb.upper_bound += c - c0;
end;

procedure TDynamicTreeTest.CreateProxy;
var
  i: Integer;
  j: Integer;
  actor: PActor;
begin
  for i := 0 to actor_count - 1 do
  begin
    j := Random(actor_count);
    actor := @_actors[j];
    if actor^.proxy_id = b2_null_node then
    begin
      GetRandomAABB(actor^.aabb);
      actor^.proxy_id := _tree.create_proxy(actor^.aabb, actor);
      exit;
    end;
  end;
end;

procedure TDynamicTreeTest.DestroyProxy;
var
  i: Integer;
  actor: PActor;
  j: Integer;
begin
  for i := 0 to actor_count - 1 do
  begin
    j := Random(actor_count);
    actor := @_actors[j];
    if actor^.proxy_id <> b2_null_node then
    begin
      _tree.destroy_proxy(actor^.proxy_id);
      actor^.proxy_id := b2_null_node;
      exit;
    end;
  end;
end;

procedure TDynamicTreeTest.MoveProxy;
var
  j: Integer;
  i: Integer;
  actor: PActor;
  aabb0: tb2_aabb;
  displacement: tb2_vec2;
begin
  for i := 0 to actor_count - 1 do
  begin
    j := Random(actor_count);
    actor := @_actors[j];
    if actor^.proxy_id = b2_null_node then continue;
    aabb0 := actor^.aabb;
    MoveAABB(actor^.aabb);
    displacement := actor^.aabb.get_center - aabb0.get_center;
    _tree.move_proxy(actor^.proxy_id, actor^.aabb, displacement);
    exit;
  end;
end;

procedure TDynamicTreeTest.Action;
  var choice: tb2_int32;
begin
  choice := Random(20);
  case choice of
    0: CreateProxy;
    1: DestroyProxy;
    else MoveProxy;
  end;
end;

procedure TDynamicTreeTest.Query;
var
  overlap: Boolean;
  i: Integer;
begin
  _tree.query(@QueryCallback, _query_aabb);
  for i := 0 to actor_count - 1 do
  begin
    if _actors[i].proxy_id = b2_null_node then continue;
    overlap := b2_test_overlap(_query_aabb, _actors[i].aabb);
  end;
end;

procedure TDynamicTreeTest.RayCast;
  var input: tb2_ray_cast_input;
  var brute_output, output: tb2_ray_cast_output;
  var brute_actor: PActor;
    i: Integer;
    hit: Boolean;
begin
  _ray_actor := nil;
  input := _ray_cast_input;
  // Ray cast against the dynamic tree.
  _tree.ray_cast(@RayCastCallback, input);
  // Brute force ray cast.
  brute_actor := nil;
  for i := 0 to actor_count - 1 do
  begin
    if _actors[i].proxy_id = b2_null_node then continue;
    hit := _actors[i].aabb.ray_cast(output, input);
    if hit then
    begin
      brute_actor := @_actors[i];
      brute_output := output;
      input.max_fraction := output.fraction;
    end;
  end;
end;

constructor TDynamicTreeTest.Create;
var
  i: Integer;
  actor: PActor;
  h: tb2_float32;
begin
  inherited Create;
  _tree.create;
  _world_extent := 15.0;
  _proxy_extent := 0.5;
  Randomize;
  for i := 0 to actor_count - 1 do
  begin
    actor := @_actors[i];
    GetRandomAABB(actor^.aabb);
    actor^.proxy_id := _tree.create_proxy(actor^.aabb, actor);
  end;
  _step_count := 0;
  h := _world_extent;
  _query_aabb.lower_bound.set_value(-3.0, -4.0 + h);
  _query_aabb.upper_bound.set_value(5.0, 6.0 + h);
  _ray_cast_input.p1.set_value(-5.0, 5.0 + h);
  _ray_cast_input.p2.set_value(7.0, -4.0 + h);
  //m_rayCastInput.p1.Set(0.0f, 2.0f + h);
  //m_rayCastInput.p2.Set(0.0f, -2.0f + h);
  _ray_cast_input.max_fraction := 1.0;
  _automated := false;
end;

destructor TDynamicTreeTest.Destroy;
begin
  _tree.destroy;
  inherited Destroy;
end;

procedure TDynamicTreeTest.Step(var Settings: TSettings);
var
  i: Integer;
  num: tb2_int32;
begin
  _ray_actor := nil;
  for i := 0 to actor_count - 1 do
  begin
    _actors[i].fraction := 1.0;
    _actors[i].overlap := false;
  end;
  if _automated then
  begin
    num := b2_max(1, actor_count shr 2);
    for i := 0 to num - 1 do Action;
  end;
  Query;
  RayCast;
  inc(_step_count);
end;

procedure TDynamicTreeTest.Draw(const Settings: TSettings);
var
  i: Integer;
  actor: PActor;
  c, c1, c2: tb2_color;
  p: tb2_vec2;
  height: tb2_int32;
begin
  inherited Draw(Settings);
  for i := 0 to actor_count - 1 do
  begin
    actor := @_actors[i];
    if actor^.proxy_id = b2_null_node then continue;
    c.set_value(0.9, 0.9, 0.9);
    if (actor = _ray_actor) and (actor^.overlap) then
    c.set_value(0.9, 0.6, 0.6)
    else if actor = _ray_actor then
    c.set_value(0.6, 0.9, 0.6)
    else if actor^.overlap then
    c.set_value(0.6, 0.6, 0.9);
    Game.draw.draw_aabb(actor^.aabb, c);
  end;
  c.set_value(0.7, 0.7, 0.7);
  Game.draw.draw_aabb(_query_aabb, c);
  Game.draw.draw_segment(_ray_cast_input.p1, _ray_cast_input.p2, c);
  c1.set_value(0.2, 0.9, 0.2);
  c2.set_value(0.9, 0.2, 0.2);
  Game.draw.draw_point(_ray_cast_input.p1, 0.1, c1);
  Game.draw.draw_point(_ray_cast_input.p2, 0.1, c2);
  if _ray_actor <> nil then
  begin
    c.set_value(0.2, 0.2, 0.9);
    p := _ray_cast_input.p1 + _ray_actor^.fraction * (_ray_cast_input.p2 - _ray_cast_input.p1);
    Game.draw.draw_point(p, 0.1, c);
  end;
  begin
    height := _tree.get_height;
    Game.draw.draw_string(5, _text_line, 'dynamic tree height = ' + inttostr(height));
    _text_line += DRAW_STRING_NEW_LINE;
  end;
end;

procedure TDynamicTreeTest.Keyboard(const Key: tb2_int32);
begin
  case Key of
    G2K_A: _automated := not _automated;
    G2K_C: CreateProxy;
    G2K_D: DestroyProxy;
    G2K_M: MoveProxy;
  end;
end;

function TDynamicTreeTest.QueryCallback(const proxy_id: tb2_int32): boolean;
  var actor: PActor;
begin
  actor := PActor(_tree.get_user_data(proxy_id));
  actor^.overlap := b2_test_overlap(_query_aabb, actor^.aabb);
  result := true;
end;

function TDynamicTreeTest.RayCastCallback(const input: tb2_ray_cast_input; const proxy_id: tb2_int32): tb2_float32;
  var actor: PActor;
  var output: tb2_ray_cast_output;
  var hit: Boolean;
begin
  actor := PActor(_tree.get_user_data(proxy_id));
  hit := actor^.aabb.ray_cast(output, input);
  if hit then
  begin
    _ray_cast_output := output;
    _ray_actor := actor;
    _ray_actor^.fraction := output.fraction;
    result := output.fraction;
    exit;
  end;
  result := input.max_fraction;
end;
//TDynamicTreeTest END

//TEdgeShapesTest BEGIN
function TEdgeShapesTest.TEdgeShapesCallback.get_fixture: pb2_fixture;
begin
  result := _fixture;
end;

function TEdgeShapesTest.TEdgeShapesCallback.get_position: tb2_vec2;
begin
  result := _position;
end;

function TEdgeShapesTest.TEdgeShapesCallback.get_normal: tb2_vec2;
begin
  result := _normal;
end;

constructor TEdgeShapesTest.TEdgeShapesCallback.Create;
begin
  _fixture := nil;
end;

function TEdgeShapesTest.TEdgeShapesCallback.ReportFixture(const fixture: pb2_fixture; const position, normal: tb2_vec2; const fraction: tb2_float32): tb2_float32;
begin
  _fixture := fixture;
  _position := position;
  _normal := normal;
  result := fraction;
end;

constructor TEdgeShapesTest.Create;
var
  i: Integer;
  ground: pb2_body;
  x1, y1: tb2_float32;
  x2: tb2_float32;
  y2: tb2_float32;
  edge_shape: tb2_edge_shape;
  vertices: array[0..7] of tb2_vec2;
  w: tb2_float32;
  b: tb2_float32;
  s: tb2_float32;
  bd: tb2_body_def;
begin
  inherited Create;
  for i := 0 to High(_polygons) do
  _polygons[i].create;
  _circle.create;
  _callback.Create;
  // Ground body
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    x1 := -20.0;
    y1 := 2.0 * cos(x1 / 10.0 * b2_pi);
    for i := 0 to 79 do
    begin
      x2 := x1 + 0.5;
      y2 := 2.0 * cos(x2 / 10.0 * b2_pi);
      edge_shape.create;
      edge_shape.set_edge(b2_vec2(x1, y1), b2_vec2(x2, y2));
      ground^.create_fixture(@edge_shape, 0.0);
      x1 := x2;
      y1 := y2;
      edge_shape.destroy;
    end;
  end;
  begin
    vertices[0].set_value(-0.5, 0.0);
    vertices[1].set_value(0.5, 0.0);
    vertices[2].set_value(0.0, 1.5);
    _polygons[0].set_polygon(@vertices, 3);
  end;
  begin
    vertices[0].set_value(-0.1, 0.0);
    vertices[1].set_value(0.1, 0.0);
    vertices[2].set_value(0.0, 1.5);
    _polygons[1].set_polygon(@vertices, 3);
  end;
  begin
    w := 1.0;
    b := w / (2.0 + b2_sqrt(2.0));
    s := b2_sqrt(2.0) * b;
    vertices[0].set_value(0.5 * s, 0.0);
    vertices[1].set_value(0.5 * w, b);
    vertices[2].set_value(0.5 * w, b + s);
    vertices[3].set_value(0.5 * s, w);
    vertices[4].set_value(-0.5 * s, w);
    vertices[5].set_value(-0.5 * w, b + s);
    vertices[6].set_value(-0.5 * w, b);
    vertices[7].set_value(-0.5 * s, 0.0);
    _polygons[2].set_polygon(@vertices, 8);
  end;
  _polygons[3].set_as_box(0.5, 0.5);
  _circle.radius := 0.5;
  _body_index := 0;
  fillchar(_bodies, sizeof(_bodies), 0);
  _angle := 0.0;
end;

destructor TEdgeShapesTest.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(_polygons) do
  _polygons[i].destroy;
  _circle.destroy;
  inherited Destroy;
end;

procedure TEdgeShapesTest.CreateBody(const index: tb2_int32);
var
  bd: tb2_body_def;
  x: tb2_float32;
  y: tb2_float32;
  fd: tb2_fixture_def;
begin
  if _bodies[_body_index] <> nil then
  begin
    _world^.destroy_body(_bodies[_body_index]);
    _bodies[_body_index] := nil;
  end;
  bd := b2_body_def;
  x := RandomFloat(-10.0, 10.0);
  y := RandomFloat(10.0, 20.0);
  bd.position.set_value(x, y);
  bd.angle := RandomFloat(-b2_pi, b2_pi);
  bd.body_type := b2_dynamic_body;
  if index = 4 then
  begin
    bd.angular_damping := 0.02;
  end;
  _bodies[_body_index] := _world^.create_body(bd);
  if index < 4 then
  begin
    fd := b2_fixture_def;
    fd.shape := @_polygons[index];
    fd.friction := 0.3;
    fd.density := 20.0;
    _bodies[_body_index]^.create_fixture(fd);
  end
  else
  begin
    fd := b2_fixture_def;
    fd.shape := @_circle;
    fd.friction := 0.3;
    fd.density := 20.0;
    _bodies[_body_index]^.create_fixture(fd);
  end;
  _body_index := (_body_index + 1) mod max_bodies;
end;

procedure TEdgeShapesTest.DestroyBody;
var
  i: Integer;
begin
  for i := 0 to max_bodies - 1 do
  begin
    if _bodies[i] <> nil then
    begin
      _world^.destroy_body(_bodies[i]);
      _bodies[i] := nil;
      exit;
    end;
  end;
end;

procedure TEdgeShapesTest.Keyboard(const Key: tb2_int32);
begin
  case key of
    G2K_1,
    G2K_2,
    G2K_3,
    G2K_4,
    G2K_5: CreateBody(Key - G2K_1);
    G2K_D: DestroyBody;
  end;
end;

procedure TEdgeShapesTest.Step(var Settings: TSettings);
var
  advance_ray: Boolean;
  L: tb2_float32;
  d: tb2_vec2;
begin
  advance_ray := not Settings.pause or Settings.single_step;
  inherited Step(Settings);
  L := 25.0;
  _point1.set_value(0.0, 10.0);
  d.set_value(L * cos(_angle), -L * b2_abs(sin(_angle)));
  _point2 := _point1 + d;
  _world^.ray_cast(@_callback.ReportFixture, _point1, _point2);
  if advance_ray then _angle += 0.25 * b2_pi / 180.0;
end;

procedure TEdgeShapesTest.Draw(const Settings: TSettings);
var
  head: tb2_vec2;
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'Press 1-5 to drop stuff');
  _text_line += DRAW_STRING_NEW_LINE;
  if _callback.get_fixture <> nil then
  begin
    Game.draw.draw_point(_callback.get_position, 0.2, b2_color(0.4, 0.9, 0.4));
    Game.draw.draw_segment(_point1, _callback.get_position, b2_color(0.8, 0.8, 0.8));
    head := _callback.get_position + 1 * _callback.get_normal;
    Game.draw.draw_segment(_callback.get_position, head, b2_color(0.9, 0.9, 0.4));
  end
  else
  begin
    Game.draw.draw_segment(_point1, _point2, b2_color(0.8, 0.8, 0.8));
  end;
end;
//TEdgeShapesTest END

//TEdgeTest BEGIN
constructor TEdgeTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  v1, v2, v3, v4, v5, v6, v7: tb2_vec2;
  edge_shape: tb2_edge_shape;
  body: pb2_body;
  circle_shape: tb2_circle_shape;
  poly_shape: tb2_polygon_shape;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    v1.set_value(-10.0, 0.0); v2.set_value(-7.0, -2.0); v3.set_value(-4.0, 0.0);
    v4.set_value(0.0, 0.0); v5.set_value(4.0, 0.0); v6.set_value(7.0, 2.0); v7.set_value(10.0, 0.0);
    edge_shape.create;
    edge_shape.set_edge(v1, v2);
    edge_shape.has_vertex3 := true;
    edge_shape.vertex3 := v3;
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.set_edge(v2, v3);
    edge_shape.has_vertex0 := true;
    edge_shape.has_vertex3 := true;
    edge_shape.vertex0 := v1;
    edge_shape.vertex3 := v4;
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.set_edge(v3, v4);
    edge_shape.has_vertex0 := true;
    edge_shape.has_vertex3 := true;
    edge_shape.vertex0 := v2;
    edge_shape.vertex3 := v5;
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.set_edge(v4, v5);
    edge_shape.has_vertex0 := true;
    edge_shape.has_vertex3 := true;
    edge_shape.vertex0 := v3;
    edge_shape.vertex3 := v6;
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.set_edge(v5, v6);
    edge_shape.has_vertex0 := true;
    edge_shape.has_vertex3 := true;
    edge_shape.vertex0 := v4;
    edge_shape.vertex3 := v7;
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.set_edge(v6, v7);
    edge_shape.has_vertex0 := true;
    edge_shape.vertex0 := v5;
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-0.5, 0.6);
    bd.allow_sleep := false;
    body := _world^.create_body(bd);
    circle_shape.create;
    circle_shape.radius := 0.5;
    body^.create_fixture(@circle_shape, 1.0);
    circle_shape.destroy;
  end;
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(1.0, 0.6);
    bd.allow_sleep := false;
    body := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(0.5, 0.5);
    body^.create_fixture(@poly_shape, 1.0);
    poly_shape.destroy;
  end;
end;
//TEdfeTest END

//TGearsTest BEGIN
constructor TGearsTest.Create;
var
  ground: pb2_body;
  bd: tb2_body_def;
  edge_shape: tb2_edge_shape;
  circle1: tb2_circle_shape;
  box: tb2_polygon_shape;
  circle2: tb2_circle_shape;
  bd1: tb2_body_def;
  body1: pb2_body;
  bd2: tb2_body_def;
  body2: pb2_body;
  bd3: tb2_body_def;
  body3: pb2_body;
  rjd1: tb2_revolute_joint_def;
  joint1: pb2_joint;
  rjd2: tb2_revolute_joint_def;
  gjd4: tb2_gear_joint_def;
  joint2: pb2_joint;
  pjd3: tb2_prismatic_joint_def;
  gjd5: tb2_gear_joint_def;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(50.0, 0.0), b2_vec2(-50.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  //if false then
  begin
    circle1.create;
    circle1.radius := 1.0;
    box.create;
    box.set_as_box(0.5, 5.0);
    circle2.create;
    circle2.radius := 2.0;

    bd1 := b2_body_def;
    bd1.body_type := b2_static_body;
    bd1.position.set_value(10.0, 9.0);
    body1 := _world^.create_body(bd1);
    body1^.create_fixture(@circle1, 5.0);

    bd2 := b2_body_def;
    bd2.body_type := b2_dynamic_body;
    bd2.position.set_value(10.0, 8.0);
    body2 := _world^.create_body(bd2);
    body2^.create_fixture(@box, 5.0);

    bd3 := b2_body_def;
    bd3.body_type := b2_dynamic_body;
    bd3.position.set_value(10.0, 6.0);
    body3 := _world^.create_body(bd3);
    body3^.create_fixture(@circle2, 5.0);

    rjd1 := b2_revolute_joint_def;
    rjd1.initialize(body2, body3, bd3.position);
    joint1 := _world^.create_joint(rjd1);

    rjd2 := b2_revolute_joint_def;
    rjd2.initialize(ground, body3, bd3.position);
    joint2 := _world^.create_joint(rjd2);

    //gjd4 := b2_gear_joint_def;
    //gjd4.body_a := body1;
    //gjd4.body_b := body3;
    //gjd4.joint1 := joint1;
    //gjd4.joint2 := joint2;
    //gjd4.ratio := circle2.radius / circle1.radius;
    //_world^.create_joint(gjd4);

    circle1.destroy;
    circle2.destroy;
    box.destroy;
  end;
  //if false then
  begin
    circle1.create;
    circle1.radius := 1.0;
    circle2.create;
    circle2.radius := 2.0;
    box.create;
    box.set_as_box(0.5, 5.0);
    bd1 := b2_body_def;
    bd1.body_type := b2_dynamic_body;
    bd1.position.set_value(-3.0, 12.0);
    body1 := _world^.create_body(bd1);
    body1^.create_fixture(@circle1, 5.0);
    rjd1 := b2_revolute_joint_def;
    rjd1.body_a := ground;
    rjd1.body_b := body1;
    rjd1.local_anchor_a := ground^.get_local_point(bd1.position);
    rjd1.local_anchor_b := body1^.get_local_point(bd1.position);
    rjd1.reference_angle := body1^.get_angle - ground^.get_angle();
    _joint1 := pb2_revolute_joint(_world^.create_joint(rjd1));
    bd2 := b2_body_def;
    bd2.body_type := b2_dynamic_body;
    bd2.position.set_value(0.0, 12.0);
    body2 := _world^.create_body(bd2);
    body2^.create_fixture(@circle2, 5.0);
    rjd2 := b2_revolute_joint_def;
    rjd2.initialize(ground, body2, bd2.position);
    _joint2 := pb2_revolute_joint(_world^.create_joint(rjd2));
    bd3 := b2_body_def;
    bd3.body_type := b2_dynamic_body;
    bd3.position.set_value(2.5, 12.0);
    body3 := _world^.create_body(bd3);
    body3^.create_fixture(@box, 5.0);
    pjd3 := b2_prismatic_joint_def;
    pjd3.initialize(ground, body3, bd3.position, b2_vec2(0.0, 1.0));
    pjd3.lower_translation := -5.0;
    pjd3.upper_translation := 5.0;
    pjd3.enable_limit := true;
    _joint3 := pb2_prismatic_joint(_world^.create_joint(pjd3));
    gjd4 := b2_gear_joint_def;
    gjd4.body_a := body1;
    gjd4.body_b := body2;
    gjd4.joint1 := _joint1;
    gjd4.joint2 := _joint2;
    gjd4.ratio := circle2.radius / circle1.radius;
    _joint4 := pb2_gear_joint(_world^.create_joint(gjd4));
    gjd5 := b2_gear_joint_def;
    gjd5.body_a := body2;
    gjd5.body_b := body3;
    gjd5.joint1 := _joint2;
    gjd5.joint2 := _joint3;
    gjd5.ratio := -1.0 / circle2.radius;
    _joint5 := pb2_gear_joint(_world^.create_joint(gjd5));
    circle1.destroy;
    circle2.destroy;
    box.destroy;
  end;
end;

procedure TGearsTest.Draw(const Settings: TSettings);
  var ratio, value: tb2_float32;
begin
  inherited Draw(Settings);
  ratio := _joint4^.get_ratio;
  value := _joint1^.get_joint_angle + ratio * _joint2^.get_joint_angle;
  Game.draw.draw_string(5, _text_line, 'theta1 + ' + floattostr(ratio) + ' * theta2 = ' + floattostr(value));
  _text_line += DRAW_STRING_NEW_LINE;
  ratio := _joint5^.get_ratio;
  value := _joint2^.get_joint_angle + ratio * _joint3^.get_joint_translation;
  Game.draw.draw_string(5, _text_line, 'theta2 + ' + floattostr(ratio) + ' * delta = ' + floattostr(value));
  _text_line += DRAW_STRING_NEW_LINE;
end;
//TGearsTest END

//THeavyOnLightTest BEGIN
constructor THeavyOnLightTest.Create;
var
  edge_shape: tb2_edge_shape;
  ground: pb2_body;
  bd: tb2_body_def;
  body: pb2_body;
  circle_shape: tb2_circle_shape;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position.set_value(0.0, 0.5);
  body := _world^.create_body(bd);
  circle_shape.create;
  circle_shape.radius := 0.5;
  body^.create_fixture(@circle_shape, 10.0);
  bd.position.set_value(0.0, 6.0);
  body := _world^.create_body(bd);
  circle_shape.radius := 5.0;
  body^.create_fixture(@circle_shape, 10.0);
  circle_shape.destroy;
end;
//THeavyOnLightTest END

//THeavyOnLightTwoTest BEIGN
constructor THeavyOnLightTwoTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  circle_shape: tb2_circle_shape;
  body: pb2_body;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position.set_value(0.0, 2.5);
  body := _world^.create_body(bd);
  circle_shape.create;
  circle_shape.radius := 0.5;
  body^.create_fixture(@circle_shape, 10.0);
  bd.position.set_value(0.0, 3.5);
  body := _world^.create_body(bd);
  body^.create_fixture(@circle_shape, 10.0);
  _heavy := nil;
  circle_shape.destroy;
end;

procedure THeavyOnLightTwoTest.ToggleHeavy;
var
  bd: tb2_body_def;
  circle_shape: tb2_circle_shape;
begin
  if _heavy <> nil then
  begin
    _world^.destroy_body(_heavy);
    _heavy := nil;
  end
  else
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(0.0, 9.0);
    _heavy := _world^.create_body(bd);
    circle_shape.create;
    circle_shape.radius := 5.0;
    _heavy^.create_fixture(@circle_shape, 10.0);
    circle_shape.destroy;
  end;
end;

procedure THeavyOnLightTwoTest.Keyboard(const Key: tb2_int32);
begin
  case Key of
    G2K_H: ToggleHeavy;
  end;
end;
//THeavyOnLightTwoTest END

//TMobileTest BEGIN
constructor TMobileTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  a: tb2_float32;
  h: tb2_vec2;
  root: pb2_body;
  rjd: tb2_revolute_joint_def;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    bd.position.set_value(0.0, 20.0);
    ground := _world^.create_body(bd);
  end;
  a := 0.5;
  h.set_value(0.0, a);
  root := AddNode(ground, b2_vec2_zero, 0, 3.0, a);
  rjd := b2_revolute_joint_def;
  rjd.body_a := ground;
  rjd.body_b := root;
  rjd.local_anchor_a.set_zero;
  rjd.local_anchor_b := h;
  _world^.create_joint(rjd);
end;

function TMobileTest.AddNode(const parent: pb2_body; const local_anchor: tb2_vec2; const depth: tb2_int32; const offset, a: tb2_float32): pb2_body;
var
  density: tb2_float32;
  h: tb2_vec2;
  p: tb2_vec2;
  body: pb2_body;
  poly_shape: tb2_polygon_shape;
  a1: tb2_vec2;
  a2: tb2_vec2;
  body1: pb2_body;
  body2: pb2_body;
  rjd: tb2_revolute_joint_def;
  bd: tb2_body_def;
begin
  density := 20.0;
  h.set_value(0.0, a);
  p := parent^.get_position + local_anchor - h;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position := p;
  body := _world^.create_body(bd);
  poly_shape.create;
  poly_shape.set_as_box(0.25 * a, a);
  body^.create_fixture(@poly_shape, density);
  if depth = k_depth then
  begin
    result := body;
    exit;
  end;
  a1 := b2_vec2(offset, -a);
  a2 := b2_vec2(-offset, -a);
  body1 := AddNode(body, a1, depth + 1, 0.5 * offset, a);
  body2 := AddNode(body, a2, depth + 1, 0.5 * offset, a);
  rjd := b2_revolute_joint_def;
  rjd.collide_connected := true;
  rjd.body_a := body;
  rjd.local_anchor_b := h;
  rjd.local_anchor_a := a1;
  rjd.body_b := body1;
  _world^.create_joint(rjd);
  rjd.local_anchor_a := a2;
  rjd.body_b := body2;
  _world^.create_joint(rjd);
  result := body;
end;
//TMobileTest END

//TMobileBalancedTest BEGIN
constructor TMobileBalancedTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  a: tb2_float32;
  h: tb2_vec2;
  root: pb2_body;
  rjd: tb2_revolute_joint_def;
begin
  inherited Create;
  // Create ground body.
  begin
    bd := b2_body_def;
    bd.position.set_value(0.0, 20.0);
    ground := _world^.create_body(bd);
  end;
  a := 0.5;
  h.set_value(0.0, a);
  root := AddNode(ground, b2_vec2_zero, 0, 3.0, a);
  rjd := b2_revolute_joint_def;
  rjd.body_a := ground;
  rjd.body_b := root;
  rjd.local_anchor_a.set_zero;
  rjd.local_anchor_b := h;
  _world^.create_joint(rjd);
end;

function TMobileBalancedTest.AddNode(const parent: pb2_body; const local_anchor: tb2_vec2; const depth: tb2_int32; offset, a: tb2_float32): pb2_body;
var
  density: tb2_float32;
  h: tb2_vec2;
  p: tb2_vec2;
  bd: tb2_body_def;
  body: pb2_body;
  poly_shape: tb2_polygon_shape;
  a1: tb2_vec2;
  a2: tb2_vec2;
  body1: pb2_body;
  body2: pb2_body;
  rjd: tb2_revolute_joint_def;
begin
  density := 20.0;
  h.set_value(0.0, a);
  p := parent^.get_position + local_anchor - h;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position := p;
  body := _world^.create_body(bd);
  poly_shape.create;
  poly_shape.set_as_box(0.25 * a, a);
  body^.create_fixture(@poly_shape, density);
  if depth = k_depth then
  begin
    result := body;
    exit;
  end;
  poly_shape.set_as_box(offset, 0.25 * a, b2_vec2(0, -a), 0.0);
  body^.create_fixture(@poly_shape, density);
  a1 := b2_vec2(offset, -a);
  a2 := b2_vec2(-offset, -a);
  body1 := AddNode(body, a1, depth + 1, 0.5 * offset, a);
  body2 := AddNode(body, a2, depth + 1, 0.5 * offset, a);
  rjd := b2_revolute_joint_def;
  rjd.body_a := body;
  rjd.local_anchor_b := h;
  rjd.local_anchor_a := a1;
  rjd.body_b := body1;
  _world^.create_joint(rjd);
  rjd.local_anchor_a := a2;
  rjd.body_b := body2;
  _world^.create_joint(rjd);
  poly_shape.destroy;
  result := body;
end;
//TMobileBalancedTest END

//TMotorJointTest BEGIN
constructor TMotorJointTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  fd: tb2_fixture_def;
  body: pb2_body;
  poly_shape: tb2_polygon_shape;
  mjd: tb2_motor_joint_def;
begin
  inherited Create;
  _linear_offset.set_zero;
  _angular_offset := 0;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-20.0, 0.0), b2_vec2(20.0, 0.0));
    fd := b2_fixture_def;
    fd.shape := @edge_shape;
    ground^.create_fixture(fd);
    edge_shape.destroy;
  end;
  // Define motorized body
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(0.0, 8.0);
    body := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(2.0, 0.5);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.friction := 0.6;
    fd.density := 2.0;
    body^.create_fixture(fd);
    mjd := b2_motor_joint_def ;
    mjd.initialize(ground, body);
    mjd.max_force := 1000.0;
    mjd.max_torque := 1000.0;
    mjd.collide_connected := true;;
    _joint := pb2_motor_joint(_world^.create_joint(mjd));
    poly_shape.destroy;
  end;
  _go := false;
  _time := 0.0;
end;

procedure TMotorJointTest.Keyboard(const Key: tb2_int32);
begin
  case Key of
    G2K_S: _go := not _go;
  end;
end;

procedure TMotorJointTest.Step(var Settings: TSettings);
begin
  if _go and (Settings.hz > 0.0) then
  begin
    _time += 1.0 / Settings.hz;
  end;
  _linear_offset.x := 6.0 * sin(2.0 * _time);
  _linear_offset.y := 8.0 + 4.0 * sin(1.0 * _time);
  _angular_offset := 4.0 * _time;
  _joint^.set_linear_offset(_linear_offset);
  _joint^.set_angular_offset(_angular_offset);
  inherited Step(Settings);
end;

procedure TMotorJointTest.Draw(const Settings: TSettings);
begin
  inherited Draw(Settings);
  Game.draw.draw_point(_linear_offset, 0.2, b2_color(0.9, 0.9, 0.9));
  Game.draw.draw_string(5, _text_line, 'Keys: (s) pause');
  _text_line += 15;
end;
//TMotorJointTest END

//TOneSidedPlatformTest BEGIN
constructor TOneSidedPlatformTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  poly_shape: tb2_polygon_shape;
  body: pb2_body;
  circle_shape: tb2_circle_shape;
begin
  inherited Create;
  // Ground
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-20.0, 0.0), b2_vec2(20.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  // Platform
  begin
    bd := b2_body_def;
    bd.position.set_value(0.0, 10.0);
    body := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(3.0, 0.5);
    _platform := body^.create_fixture(@poly_shape, 0.0);
    _bottom := 10.0 - 0.5;
    _top := 10.0 + 0.5;
    poly_shape.destroy;
  end;
  // Actor
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(0.0, 12.0);
    body := _world^.create_body(bd);
    _radius := 0.5;
    circle_shape.create;
    circle_shape.radius := _radius;
    _character := body^.create_fixture(@circle_shape, 20.0);
    body^.set_linear_velocity(b2_vec2(0.0, -50.0));
    _state := stUnknown;
    circle_shape.destroy;
  end;
end;

procedure TOneSidedPlatformTest.pre_solve(const contact: pb2_contact; const old_manifold: pb2_manifold);
var
  fixture_a: pb2_fixture;
  fixture_b: pb2_fixture;
  position: tb2_vec2;
  v: tb2_vec2;
begin
  inherited pre_solve(contact, old_manifold);
  fixture_a := contact^.get_fixture_a;
  fixture_b := contact^.get_fixture_b;
  if (fixture_a <> _platform) and (fixture_a <> _character) then exit;
  if (fixture_b <> _platform) and (fixture_b <> _character) then exit;
{$if 1}
  position := _character^.get_body^.get_position;
  if position.y < _top + _radius - 3.0 * b2_linear_slop then
  begin
    contact^.set_enabled(false);
  end;
{$else}
  v := _character^.get_body^.get_linear_velocity;
  if v.y > 0.0 then
  begin
    contact^.set_enabled(false);
  end;
{$endif}
end;

procedure TOneSidedPlatformTest.Draw(const Settings: TSettings);
var
  v: tb2_vec2;
begin
  inherited Draw(Settings);
  v := _character^.get_body^.get_linear_velocity;
  Game.draw.draw_string(5, _text_line, 'Character Linear Velocity: ' + floattostr(v.y));
  _text_line += DRAW_STRING_NEW_LINE;
end;
//TOneSidedPlatformTest END

//TPinballTest BEIGN
constructor TPinballTest.Create;
var
  bd: tb2_body_def;
  vs: array[0..4] of tb2_vec2;
  loop: tb2_chain_shape;
  fd: tb2_fixture_def;
  ground: pb2_body;
  p1: tb2_vec2;
  p2: tb2_vec2;
  left_flipper: pb2_body;
  right_flipper: pb2_body;
  box: tb2_polygon_shape;
  rjd: tb2_revolute_joint_def;
  circle_shape: tb2_circle_shape;
begin
  inherited Create;
  // Ground body
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    vs[0].set_value(0.0, -2.0);
    vs[1].set_value(8.0, 6.0);
    vs[2].set_value(8.0, 20.0);
    vs[3].set_value(-8.0, 20.0);
    vs[4].set_value(-8.0, 6.0);
    loop.create;
    loop.set_loop(@vs, 5);
    fd := b2_fixture_def;
    fd.shape := @loop;
    fd.density := 0.0;
    ground^.create_fixture(fd);
    loop.destroy;
  end;
  // Flippers
  begin
    p1.set_value(-2.0, 0.0); p2.set_value(2.0, 0.0);
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position := p1;
    left_flipper := _world^.create_body(bd);
    bd.position := p2;
    right_flipper := _world^.create_body(bd);
    box.create;
    box.set_as_box(1.75, 0.1);
    fd := b2_fixture_def;
    fd.shape := @box;
    fd.density := 1.0;
    left_flipper^.create_fixture(fd);
    right_flipper^.create_fixture(fd);
    rjd := b2_revolute_joint_def;
    rjd.body_a := ground;
    rjd.local_anchor_b.set_zero;
    rjd.enable_motor := true;
    rjd.max_motor_torque := 1000.0;
    rjd.enable_limit := true;
    rjd.motor_speed := 0.0;
    rjd.local_anchor_a := p1;
    rjd.body_b := left_flipper;
    rjd.lower_angle := -30.0 * b2_pi / 180.0;
    rjd.upper_angle := 5.0 * b2_pi / 180.0;
    _left_joint := pb2_revolute_joint(_world^.create_joint(rjd));
    rjd.motor_speed := 0.0;
    rjd.local_anchor_a := p2;
    rjd.body_b := right_flipper;
    rjd.lower_angle := -5.0 * b2_pi / 180.0;
    rjd.upper_angle := 30.0 * b2_pi / 180.0;
    _right_joint := pb2_revolute_joint(_world^.create_joint(rjd));
  end;
  // Circle character
  begin
    bd := b2_body_def;
    bd.position.set_value(1.0, 15.0);
    bd.body_type := b2_dynamic_body;
    bd.bullet := true;
    _ball := _world^.create_body(bd);
    circle_shape.create;
    circle_shape.radius := 0.2;
    fd := b2_fixture_def;
    fd.shape := @circle_shape;
    fd.density := 1.0;
    _ball^.create_fixture(fd);
    circle_shape.destroy;
  end;
  _button := false;
end;

procedure TPinballTest.Step(var Settings: TSettings);
begin
  if _button then
  begin
    _left_joint^.set_motor_speed(20.0);
    _right_joint^.set_motor_speed(-20.0);
  end
  else
  begin
    _left_joint^.set_motor_speed(-10.0);
    _right_joint^.set_motor_speed(10.0);
  end;
  inherited Step(Settings);
end;

procedure TPinballTest.Draw(const Settings: TSettings);
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'Press ''a'' to control the flippers');
  _text_line += DRAW_STRING_NEW_LINE;
end;

procedure TPinballTest.Keyboard(const Key: tb2_int32);
begin
  case Key of
    G2K_A: _button := true;
  end;
end;

procedure TPinballTest.KeyboardUp(const Key: tb2_int32);
begin
  case Key of
    G2K_A: _button := false;
  end;
end;
//TPinballTest END

//TPolyCollisionTest BEIGN
constructor TPolyCollisionTest.Create;
begin
  inherited Create;
  fillchar(_manifold, sizeof(_manifold), 0);
  fillchar(_world_manifold, sizeof(_world_manifold), 0);
  begin
    _polygon_a.set_as_box(0.2, 0.4);
    _transform_a.set_value(b2_vec2(0.0, 0.0), 0.0);
  end;
  begin
    _polygon_b.set_as_box(0.5, 0.5);
    _position_b.set_value(19.345284, 1.5632932);
    _angle_b := 1.9160721;
    _transform_b.set_value(_position_b, _angle_b);
  end;
end;

procedure TPolyCollisionTest.Step(var Settings: TSettings);
begin
  inherited Step(Settings);
  b2_collide_polygons(_manifold, @_polygon_a, _transform_a, @_polygon_b, _transform_b);
  _world_manifold.initialize(@_manifold, _transform_a, _polygon_a.radius, _transform_b, _polygon_b.radius);
end;

procedure TPolyCollisionTest.Draw(const Settings: TSettings);
var
  color: tb2_color;
  v: array[0..b2_max_polygon_vertices - 1] of tb2_vec2;
  i: Integer;
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'point count = ' + inttostr(_manifold.point_count));
  _text_line += DRAW_STRING_NEW_LINE;
  begin
    color.set_value(0.9, 0.9, 0.9);
    for i := 0 to _polygon_a.count - 1 do
    v[i] := b2_mul(_transform_a, _polygon_a.vertices[i]);
    Game.draw.draw_polygon(@v, _polygon_a.count, color);
    for i := 0 to _polygon_b.count - 1 do
    v[i] := b2_mul(_transform_b, _polygon_b.vertices[i]);
    Game.draw.draw_polygon(@v, _polygon_b.count, color);
  end;
  for i := 0 to _manifold.point_count - 1 do
  begin
    Game.draw.draw_point(_world_manifold.points[i], 0.05, b2_color(0.9, 0.3, 0.3));
  end;
end;

procedure TPolyCollisionTest.Keyboard(const Key: tb2_int32);
begin
  inherited Keyboard(Key);
  case Key of
    G2K_A: _position_b.x += 0.1;
    G2K_D: _position_b.x -= 0.1;
    G2K_S: _position_b.y -= 0.1;
    G2K_W: _position_b.y += 0.1;
    G2K_Q: _angle_b += 0.1 * b2_pi;
    G2K_E: _angle_b -= 0.1 * b2_pi;
  end;
  _transform_b.set_value(_position_b, _angle_b);
end;
//TPolyCollisionTest END

//TPolyShapesTest BEGIN
constructor TPolyShapesTest.TPolyShapesCallback.Create;
begin
  count := 0;
  circle_shape.create;
end;

destructor TPolyShapesTest.TPolyShapesCallback.Destroy;
begin
  circle_shape.destroy;
end;

procedure TPolyShapesTest.TPolyShapesCallback.DrawFixture(const fixture: pb2_fixture);
var
  color: tb2_color;
  xf: tb2_transform;
  circle: pb2_circle_shape;
  center: tb2_vec2;
  radius: tb2_float32;
  poly: pb2_polygon_shape;
  vertex_count: tb2_int32;
  vertices: array[0..b2_max_polygon_vertices - 1] of tb2_vec2;
  i: Integer;
begin
  color.set_value(0.95, 0.95, 0.6);
  xf := fixture^.get_body^.get_transform;
  case fixture^.get_type of
    b2_st_circle:
    begin
      circle := pb2_circle_shape(fixture^.get_shape);
      center := b2_mul(xf, circle^.center);
      radius := circle^.radius;
      Game.draw.draw_circle(center, radius, color);
    end;
    b2_st_polygon:
    begin
      poly := pb2_polygon_shape(fixture^.get_shape);
      vertex_count := poly^.count;
      for i := 0 to vertex_count - 1 do
      begin
        vertices[i] := b2_mul(xf, poly^.vertices[i]);
      end;
      Game.draw.draw_polygon(@vertices, vertex_count, color);
    end;
  end;
end;

function TPolyShapesTest.TPolyShapesCallback.ReportFixture(const fixture: pb2_fixture): boolean;
var
  body: pb2_body;
  shape: pb2_shape;
  overlap: Boolean;
begin
  if count = k_max_count then
  begin
    result := false;
    exit;
  end;
  body := fixture^.get_body;
  shape := fixture^.get_shape;
  if (shape^.get_type <> b2_st_circle)
  and (shape^.get_type <> b2_st_polygon) then
  begin
    result := true;
    exit;
  end;
  overlap := b2_test_overlap(shape, 0, @circle_shape, 0, body^.get_transform(), transform);
  if overlap then
  begin
    DrawFixture(fixture);
    inc(count);
  end;
  result := true;
end;

constructor TPolyShapesTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  vertices: array[0..7] of tb2_vec2;
  w: tb2_float32;
  b: tb2_float32;
  s: tb2_float32;
  i: Integer;
begin
  inherited Create;
  for i := 0 to High(_polygons) do
  _polygons[i].create;
  _circle.create;
  // Ground body
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    vertices[0].set_value(-0.5, 0.0);
    vertices[1].set_value(0.5, 0.0);
    vertices[2].set_value(0.0, 1.5);
    _polygons[0].set_polygon(@vertices, 3);
  end;
  begin
    vertices[0].set_value(-0.1, 0.0);
    vertices[1].set_value(0.1, 0.0);
    vertices[2].set_value(0.0, 1.5);
    _polygons[1].set_polygon(@vertices, 3);
  end;
  begin
    w := 1.0;
    b := w / (2.0 + b2_sqrt(2.0));
    s := b2_sqrt(2.0) * b;
    vertices[0].set_value(0.5 * s, 0.0);
    vertices[1].set_value(0.5 * w, b);
    vertices[2].set_value(0.5 * w, b + s);
    vertices[3].set_value(0.5 * s, w);
    vertices[4].set_value(-0.5 * s, w);
    vertices[5].set_value(-0.5 * w, b + s);
    vertices[6].set_value(-0.5 * w, b);
    vertices[7].set_value(-0.5 * s, 0.0);
    _polygons[2].set_polygon(@vertices, 8);
  end;
  _polygons[3].set_as_box(0.5, 0.5);
  _circle.radius := 0.5;
  _body_index := 0;
  fillchar(_bodies, sizeof(_bodies), 0);
end;

destructor TPolyShapesTest.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(_polygons) do
  _polygons[i].destroy;
  _circle.destroy;
  inherited Destroy;
end;

procedure TPolyShapesTest.CreateBody(const index: tb2_int32);
var
  bd: tb2_body_def;
  x: tb2_float32;
  fd: tb2_fixture_def;
begin
  if _bodies[_body_index] <> nil then
  begin
    _world^.destroy_body(_bodies[_body_index]);
    _bodies[_body_index] := nil;
  end;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  x := RandomFloat(-2.0, 2.0);
  bd.position.set_value(x, 10.0);
  bd.angle := RandomFloat(-b2_pi, b2_pi);
  if index = 4 then
  bd.angular_damping := 0.02;
  _bodies[_body_index] := _world^.create_body(bd);
  if index < 4 then
  begin
    fd := b2_fixture_def;
    fd.shape := @_polygons[index];
    fd.density := 1.0;
    fd.friction := 0.3;
    _bodies[_body_index]^.create_fixture(fd);
  end
  else
  begin
    fd := b2_fixture_def;
    fd.shape := @_circle;
    fd.density := 1.0;
    fd.friction := 0.3;
    _bodies[_body_index]^.create_fixture(fd);
  end;
  _body_index := (_body_index + 1) mod k_max_bodies;
end;

procedure TPolyShapesTest.DestroyBody;
var
  i: Integer;
begin
  for i := 0 to k_max_bodies - 1 do
  begin
    if _bodies[i] <> nil then
    begin
      _world^.destroy_body(_bodies[i]);
      _bodies[i] := nil;
      exit;
    end;
  end;
end;

procedure TPolyShapesTest.Keyboard(const Key: tb2_int32);
var
  i: Integer;
begin
  case Key of
    G2K_1,
    G2K_2,
    G2K_3,
    G2K_4,
    G2K_5: CreateBody(Key - G2K_1);
    G2K_A:
    begin
      i := 0;
      while i < k_max_bodies do
      begin
	if _bodies[i] <> nil then
	begin
	  _bodies[i]^.set_active(not _bodies[i]^.is_active);
	end;
        i += 2;
      end;
    end;
    G2K_D: DestroyBody;
  end;
end;

procedure TPolyShapesTest.Draw(const Settings: TSettings);
var
  callback: TPolyShapesCallback;
  aabb: tb2_aabb;
  color: tb2_color;
begin
  inherited Draw(Settings);
  callback.Create;
  callback.circle_shape.radius := 2.0;
  callback.circle_shape.center.set_value(0.0, 1.1);
  callback.transform.set_identity;
  callback.debug_draw := Game.draw;
  callback.circle_shape.compute_aabb(aabb, callback.transform, 0);
  _world^.query_aabb(@callback.ReportFixture, aabb);
  color.set_value(0.4, 0.7, 0.8);
  Game.draw.draw_circle(callback.circle_shape.center, callback.circle_shape.radius, color);
  Game.draw.draw_string(5, _text_line, 'Press 1-5 to drop stuff');
  _text_line += DRAW_STRING_NEW_LINE;
  Game.draw.draw_string(5, _text_line, 'Press ''a'' to (de)activate some bodies');
  _text_line += DRAW_STRING_NEW_LINE;
  Game.draw.draw_string(5, _text_line, 'Press ''d'' to destroy a body');
  _text_line += DRAW_STRING_NEW_LINE;
  callback.Destroy;
end;
//TPolyShapesTest END

//TPrismaticTest BEGIN
constructor TPrismaticTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  poly_shape: tb2_polygon_shape;
  body: pb2_body;
  axis: tb2_vec2;
  pjd: tb2_prismatic_joint_def;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(2.0, 0.5);
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-10.0, 10.0);
    bd.angle := 0.5 * b2_pi;
    bd.allow_sleep := false;
    body := _world^.create_body(bd);
    body^.create_fixture(@poly_shape, 5.0);
    pjd := b2_prismatic_joint_def;
    // Bouncy limit
    axis.set_value(2.0, 1.0);
    axis.normalize;
    pjd.initialize(ground, body, b2_vec2(0.0, 0.0), axis);
    // Non-bouncy limit
    //pjd.Initialize(ground, body, b2Vec2(-10.0f, 10.0f), b2Vec2(1.0f, 0.0f));
    pjd.motor_speed := 10.0;
    pjd.max_motor_force := 10000.0;
    pjd.enable_motor := true;
    pjd.lower_translation := 0.0;
    pjd.upper_translation := 20.0;
    pjd.enable_limit := true;
    _joint := pb2_prismatic_joint(_world^.create_joint(pjd));
    poly_shape.destroy;
  end;
end;

procedure TPrismaticTest.Keyboard(const Key: tb2_int32);
begin
  case Key of
    G2K_L: _joint^.enable_limit(not _joint^.is_limit_enabled);
    G2K_M: _joint^.enable_motor(not _joint^.is_motor_enabled);
    G2K_S: _joint^.set_motor_speed(-_joint^.get_motor_speed);
  end;
end;

procedure TPrismaticTest.Draw(const Settings: TSettings);
var
  force: tb2_float32;
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'Keys: (l) limits, (m) motors, (s) speed');
  _text_line += DRAW_STRING_NEW_LINE;
  force := _joint^.get_motor_force(Settings.hz);
  Game.draw.draw_string(5, _text_line, 'Motor Force = ' + floattostr(force));
  _text_line += DRAW_STRING_NEW_LINE;
end;
//TPrismaticTest END

//TPulleysTest BEGIN
constructor TPulleysTest.Create;
  var y, L, a, b: tb2_float32;
    bd: tb2_body_def;
    ground: pb2_body;
    edge: tb2_edge_shape;
    circle: tb2_circle_shape;
    poly: tb2_polygon_shape;
    body1: pb2_body;
    body2: pb2_body;
    pd: tb2_pulley_joint_def;
    anchor1: tb2_vec2;
    anchor2: tb2_vec2;
    ground_anchor2: tb2_vec2;
    ground_anchor1: tb2_vec2;
begin
  inherited Create;
  y := 16.0;
  L := 12.0;
  a := 1.0;
  b := 2.0;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge.create;
    edge.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    //ground->CreateFixture(&shape, 0.0f);
    circle.create;
    circle.radius := 2.0;
    circle.center.set_value(-10.0, y + b + L);
    ground^.create_fixture(@circle, 0.0);
    circle.center.set_value(10.0, y + b + L);
    ground^.create_fixture(@circle, 0.0);
    edge.destroy;
    circle.destroy;
  end;
  begin
    poly.create;
    poly.set_as_box(a, b);
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    //bd.fixedRotation = true;
    bd.position.set_value(-10.0, y);
    body1 := _world^.create_body(bd);
    body1^.create_fixture(@poly, 5.0);
    bd.position.set_value(10.0, y);
    body2 := _world^.create_body(bd);
    body2^.create_fixture(@poly, 5.0);
    pd := b2_pulley_joint_def;
    anchor1.set_value(-10.0, y + b);
    anchor2.set_value(10.0, y + b);
    ground_anchor1.set_value(-10.0, y + b + L);
    ground_anchor2.set_value(10.0, y + b + L);
    pd.initialize(body1, body2, ground_anchor1, ground_anchor2, anchor1, anchor2, 1.5);
    _joint1 := pb2_pulley_joint(_world^.create_joint(pd));
  end;
end;

procedure TPulleysTest.Draw(const Settings: TSettings);
var
  ratio: tb2_float32;
  L: tb2_float32;
begin
  inherited Draw(Settings);
  ratio := _joint1^.get_ratio;
  L := _joint1^.get_current_length_a + ratio * _joint1^.get_current_length_b;
  Game.draw.draw_string(5, _text_line, 'L1 + ' + floattostr(ratio) + ' * L2 = ' + floattostr(L));
  _text_line += DRAW_STRING_NEW_LINE;
end;
//TPulleysTest END

//TPyramidTest BEIGN
constructor TPyramidTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  body: pb2_body;
  edge: tb2_edge_shape;
  a: tb2_float32;
  poly: tb2_polygon_shape;
  x: tb2_vec2;
  y: tb2_vec2;
  delta_x: tb2_vec2;
  delta_y: tb2_vec2;
  i: Integer;
  j: Integer;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge.create;
    edge.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge, 0.0);
    edge.destroy;
  end;
  begin
    a := 0.5;
    poly.create;
    poly.set_as_box(a, a);
    x.set_value(-7.0, 0.75);
    delta_x.set_value(0.5625, 1.25);
    delta_y.set_value(1.125, 0.0);
    for i := 0 to k_count - 1 do
    begin
      y := x;
      for j := i to k_count - 1 do
      begin
	bd := b2_body_def;
	bd.body_type := b2_dynamic_body;
	bd.position := y;
	body := _world^.create_body(bd);
	body^.create_fixture(@poly, 5.0);
	y += delta_y;
      end;
      x += delta_x;
    end;
    poly.destroy;
  end;
end;

procedure TPyramidTest.Step(var Settings: TSettings);
begin
  inherited Step(Settings);
  //b2DynamicTree* tree = &m_world->m_contactManager.m_broadPhase.m_tree;
  //if (m_stepCount == 400)
  //{
  //	tree->RebuildBottomUp();
  //}
end;
//TPyramidTest END

//TRayCastTest BEGIN
constructor TRayCastTest.TRayCastClosestCallback.Create;
begin
  hit := false;
end;

function TRayCastTest.TRayCastClosestCallback.ReportFixture(const fixture: pb2_fixture; const point, normal: tb2_vec2; const fraction: tb2_float32): tb2_float32;
var
  body: pb2_body;
  ud: tb2_ptr;
  index: LongInt;
begin
  body := fixture^.get_body;
  ud := body^.get_user_data;
  if ud <> nil then
  begin
    index := pb2_int32(ud)^;
    if index = 0 then
    begin
      // By returning -1, we instruct the calling code to ignore this fixture and
      // continue the ray-cast to the next fixture.
      result := -1.0;
      exit;
    end;
  end;
  hit := true;
  hit_point := point;
  hit_normal := normal;
  // By returning the current fraction, we instruct the calling code to clip the ray and
  // continue the ray-cast to the next fixture. WARNING: do not assume that fixtures
  // are reported in order. However, by clipping, we can always get the closest fixture.
  result := fraction;
end;

constructor TRayCastTest.TRayCastAnyCallback.Create;
begin
  hit := false;
end;

function TRayCastTest.TRayCastAnyCallback.ReportFixture(const fixture: pb2_fixture; const point, normal: tb2_vec2; const fraction: tb2_float32): tb2_float32;
var
  body: pb2_body;
  ud: tb2_ptr;
  index: LongInt;
begin
  body := fixture^.get_body;
  ud := body^.get_user_data;
  if ud <> nil then
  begin
    index := pb2_int32(ud)^;
    if index = 0 then
    begin
      // By returning -1, we instruct the calling code to ignore this fixture
      // and continue the ray-cast to the next fixture.
      result := -1.0;
      exit;
    end;
  end;
  hit := true;
  hit_point := point;
  hit_normal := normal;
  // At this point we have a hit, so we know the ray is obstructed.
  // By returning 0, we instruct the calling code to terminate the ray-cast.
  result := 0.0;
end;

constructor TRayCastTest.TRayCastMultipleCallback.Create;
begin
  count := 0;
end;

function TRayCastTest.TRayCastMultipleCallback.ReportFixture(const fixture: pb2_fixture; const point, normal: tb2_vec2; const fraction: tb2_float32): tb2_float32;
var
  body: pb2_body;
  ud: tb2_ptr;
  index: LongInt;
begin
  body := fixture^.get_body;
  ud := body^.get_user_data;
  if ud <> nil then
  begin
    index := pb2_int32(ud)^;
    if index = 0 then
    begin
      // By returning -1, we instruct the calling code to ignore this fixture
      // and continue the ray-cast to the next fixture.
      result := -1.0;
      exit;
    end;
  end;
  points[count] := point;
  normals[count] := normal;
  inc(count);
  if count = k_max_count then
  begin
    // At this point the buffer is full.
    // By returning 0, we instruct the calling code to terminate the ray-cast.
    result := 0.0;
    exit;
  end;
  // By returning 1, we instruct the caller to continue without clipping the ray.
  result := 1.0;
end;

constructor TRayCastTest.Create;
  var i: tb2_int32;
    bd: tb2_body_def;
    ground: pb2_body;
    edge_shape: tb2_edge_shape;
    vertices: array[0..7] of tb2_vec2;
    w: tb2_float32;
    b: tb2_float32;
    s: tb2_float32;
begin
  inherited Create;
  CallbackClosest.Create;
  CallbackAny.Create;
  CallbackMultiple.Create;
  for i := 0 to High(polygons) do
  polygons[i].create;
  circle.create;
  edge.create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    vertices[0].set_value(-0.5, 0.0);
    vertices[1].set_value(0.5, 0.0);
    vertices[2].set_value(0.0, 1.5);
    polygons[0].set_polygon(@vertices, 3);
  end;
  begin
    vertices[0].set_value(-0.1, 0.0);
    vertices[1].set_value(0.1, 0.0);
    vertices[2].set_value(0.0, 1.5);
    polygons[1].set_polygon(@vertices, 3);
  end;
  begin
    w := 1.0;
    b := w / (2.0 + b2_sqrt(2.0));
    s := b2_sqrt(2.0) * b;
    vertices[0].set_value(0.5 * s, 0.0);
    vertices[1].set_value(0.5 * w, b);
    vertices[2].set_value(0.5 * w, b + s);
    vertices[3].set_value(0.5 * s, w);
    vertices[4].set_value(-0.5 * s, w);
    vertices[5].set_value(-0.5 * w, b + s);
    vertices[6].set_value(-0.5 * w, b);
    vertices[7].set_value(-0.5 * s, 0.0);
    polygons[2].set_polygon(@vertices, 8);
  end;
  polygons[3].set_as_box(0.5, 0.5);
  circle.radius := 0.5;
  edge.set_edge(b2_vec2(-1.0, 0.0), b2_vec2(1.0, 0.0));
  body_index := 0;
  fillchar(bodies, sizeof(bodies), 0);
  angle := 0.0;
  mode := e_closest;
end;

destructor TRayCastTest.Destroy;
  var i: tb2_int32;
begin
  for i := 0 to High(polygons) do
  polygons[i].destroy;
  circle.destroy;
  edge.destroy;
  inherited Destroy;
end;

procedure TRayCastTest.CreateBody(const index: tb2_int32);
var
  bd: tb2_body_def;
  x: tb2_float32;
  y: tb2_float32;
  fd: tb2_fixture_def;
begin
  if bodies[body_index] <> nil then
  begin
    _world^.destroy_body(bodies[body_index]);
    bodies[body_index] := nil;
  end;
  bd := b2_body_def;
  x := RandomFloat(-10.0, 10.0);
  y := RandomFloat(0.0, 20.0);
  bd.position.set_value(x, y);
  bd.angle := RandomFloat(-b2_pi, b2_pi);
  user_data[body_index] := index;
  bd.user_data := @user_data[body_index];
  if index = 4 then
  bd.angular_damping := 0.02;
  bodies[body_index] := _world^.create_body(bd);
  if index < 4 then
  begin
    fd := b2_fixture_def;
    fd.shape := @polygons[index];
    fd.friction := 0.3;
    bodies[body_index]^.create_fixture(fd);
  end
  else if index < 5 then
  begin
    fd := b2_fixture_def;
    fd.shape := @circle;
    fd.friction := 0.3;
    bodies[body_index]^.create_fixture(fd);
  end
  else
  begin
    fd := b2_fixture_def;
    fd.shape := @edge;
    fd.friction := 0.3;
    bodies[body_index]^.create_fixture(fd);
  end;
  body_index := (body_index + 1) mod k_max_bodies;
end;

procedure TRayCastTest.DestroyBody;
var
  i: tb2_int32;
begin
  for i := 0 to k_max_bodies - 1 do
  begin
    if bodies[i] <> nil then
    begin
      _world^.destroy_body(bodies[i]);
      bodies[i] := nil;
      exit;
    end;
  end;
end;

procedure TRayCastTest.Keyboard(const key: tb2_int32);
begin
  case Key of
    G2K_1,
    G2K_2,
    G2K_3,
    G2K_4,
    G2K_5,
    G2K_6: CreateBody(Key - G2K_1);
    G2K_D: DestroyBody;
    G2K_M:
    begin
      if mode = e_closest then
      mode := e_any
      else if mode = e_any then
      mode := e_multiple
      else if mode = e_multiple then
      mode := e_closest;
    end;
  end;
end;

procedure TRayCastTest.Step(var Settings: TSettings);
var
  advance_ray: Boolean;
  L: tb2_float32;
  d: tb2_vec2;
begin
  advance_ray := not Settings.pause or Settings.single_step;
  inherited Step(Settings);

  L := 11.0;
  point1.set_value(0.0, 10.0);
  d.set_value(L * cos(angle), L * sin(angle));
  point2 := point1 + d;
  case mode of
    e_closest:
    begin
      CallbackClosest.hit := false;
      _world^.ray_cast(@CallbackClosest.ReportFixture, point1, point2);
    end;
    e_any:
    begin
      CallbackAny.hit := false;
      _world^.ray_cast(@CallbackAny.ReportFixture, point1, point2);
    end;
    e_multiple:
    begin
      CallbackMultiple.count := 0;
      _world^.ray_cast(@CallbackMultiple.ReportFixture, point1, point2);
    end;
  end;

  if advance_ray then
  angle += 0.25 * b2_pi / 180.0;
end;

procedure TRayCastTest.Draw(const Settings: TSettings);
  var head, p, n: tb2_vec2;
  var i: Integer;
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'Press 1-6 to drop stuff, m to change the mode');
  _text_line += DRAW_STRING_NEW_LINE;
  case mode of
    e_closest: Game.draw.draw_string(5, _text_line, 'Ray-cast mode: closest - find closest fixture along the ray');
    e_any: Game.draw.draw_string(5, _text_line, 'Ray-cast mode: any - check for obstruction');
    e_multiple: Game.draw.draw_string(5, _text_line, 'Ray-cast mode: multiple - gather multiple fixtures');
  end;
  _text_line += DRAW_STRING_NEW_LINE;
  case mode of
    e_closest:
    begin
      if CallbackClosest.hit then
      begin
	Game.draw.draw_point(CallbackClosest.hit_point, 0.1, b2_color(0.4, 0.9, 0.4));
	Game.draw.draw_segment(point1, CallbackClosest.hit_point, b2_color(0.8, 0.8, 0.8));
	head := CallbackClosest.hit_point + 0.5 * CallbackClosest.hit_normal;
	Game.draw.draw_segment(CallbackClosest.hit_point, head, b2_color(0.9, 0.9, 0.4));
      end
      else
      begin
        Game.draw.draw_segment(point1, point2, b2_color(0.8, 0.8, 0.8));
      end;
    end;
    e_any:
    begin
      if CallbackAny.hit then
      begin
  	Game.draw.draw_point(CallbackAny.hit_point, 0.1, b2_color(0.4, 0.9, 0.4));
  	Game.draw.draw_segment(point1, CallbackAny.hit_point, b2_color(0.8, 0.8, 0.8));
  	head := CallbackAny.hit_point + 0.5 * CallbackAny.hit_normal;
  	Game.Draw.draw_segment(CallbackAny.hit_point, head, b2_color(0.9, 0.9, 0.4));
      end
      else
      begin
        Game.draw.draw_segment(point1, point2, b2_color(0.8, 0.8, 0.8));
      end;
    end;
    e_multiple:
    begin
      Game.draw.draw_segment(point1, point2, b2_color(0.8, 0.8, 0.8));
      for i := 0 to CallbackMultiple.count - 1 do
      begin
	p := CallbackMultiple.points[i];
	n := CallbackMultiple.normals[i];
	Game.draw.draw_point(p, 0.1, b2_color(0.4, 0.9, 0.4));
	Game.Draw.draw_segment(point1, p, b2_color(0.8, 0.8, 0.8));
	head := p + 0.5 * n;
	Game.draw.draw_segment(p, head, b2_color(0.9, 0.9, 0.4));
      end;
    end;
  end;
end;
//TRayCastTest END

//TRevoluteTest BEGIN
constructor TRevoluteTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  fd: tb2_fixture_def;
  circle_shape: tb2_circle_shape;
  rjd: tb2_revolute_joint_def;
  body: pb2_body;
  w: tb2_float32;
  polygon_shape: tb2_polygon_shape;
  polygon_body: pb2_body;
  verts: array[0..2] of tb2_vec2;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    fd := b2_fixture_def;
    fd.shape := @edge_shape;
    ground^.create_fixture(fd);
    edge_shape.destroy;
  end;
  begin
    circle_shape.create;
    circle_shape.radius := 0.5;
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    rjd := b2_revolute_joint_def;
    bd.position.set_value(-10.0, 20.0);
    body := _world^.create_body(bd);
    body^.create_fixture(@circle_shape, 5.0);
    w := -100.0;
    body^.set_angular_velocity(w);
    body^.set_linear_velocity(b2_vec2(-8.0 * w, 0.0));
    rjd.initialize(ground, body, b2_vec2(-10.0, 12.0));
    rjd.motor_speed := 2.0 * b2_pi;
    rjd.max_motor_torque := 10000.0;
    rjd.enable_motor := false;
    rjd.lower_angle := -0.25 * b2_pi;
    rjd.upper_angle := 0.5 * b2_pi;
    rjd.enable_limit := true;
    rjd.collide_connected := true;
    _joint := pb2_revolute_joint(_world^.create_joint(rjd));
    circle_shape.destroy;
  end;
  begin
    circle_shape.create;
    circle_shape.radius := 3.0;
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(5.0, 30.0);
    fd := b2_fixture_def;
    fd.density := 5.0;
    fd.filter.mask_bits := 1;
    fd.shape := @circle_shape;
    _ball := _world^.create_body(bd);
    _ball^.create_fixture(fd);
    polygon_shape.create;
    polygon_shape.set_as_box(10.0, 0.2, b2_vec2(-10.0, 0.0), 0.0);
    bd := b2_body_def;
    bd.position.set_value(20.0, 10.0);
    bd.body_type := b2_dynamic_body;
    bd.bullet := true;
    polygon_body := _world^.create_body(bd);
    polygon_body^.create_fixture(@polygon_shape, 2.0);
    rjd := b2_revolute_joint_def;
    rjd.initialize(ground, polygon_body, b2_vec2(20.0, 10.0));
    rjd.lower_angle := -0.25 * b2_pi;
    rjd.upper_angle := 0.0 * b2_pi;
    rjd.enable_limit := true;
    _world^.create_joint(rjd);
    circle_shape.destroy;
    polygon_shape.destroy;
  end;
  // Tests mass computation of a small object far from the origin
  begin
    bd.body_type := b2_dynamic_body;
    body := _world^.create_body(bd);
    polygon_shape.create;
    verts[0].set_value(17.63, 36.31);
    verts[1].set_value(17.52, 36.69);
    verts[2].set_value(17.19, 36.36);
    polygon_shape.set_polygon(@verts, 3);
    fd.shape := @polygon_shape;
    fd.density := 1;
    body^.create_fixture(fd);
    polygon_shape.destroy;
  end;
end;

procedure TRevoluteTest.Keyboard(const Key: tb2_int32);
begin
  case Key of
    G2K_L: _joint^.enable_limit(not _joint^.is_limit_enabled);
    G2K_M: _joint^.enable_motor(not _joint^.is_motor_enabled);
  end;
end;

procedure TRevoluteTest.Draw(const Settings: TSettings);
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'Keys: (l) limits, (m) motor');
  _text_line += DRAW_STRING_NEW_LINE;
  //float32 torque1 = m_joint1->GetMotorTorque();
  //g_debugDraw.DrawString(5, m_textLine, "Motor Torque = %4.0f, %4.0f : Motor Force = %4.0f", (float) torque1, (float) torque2, (float) force3);
  //m_textLine += DRAW_STRING_NEW_LINE;
end;
//TRevoluteTest END

//TRopeJointTest BEGIN
constructor TRopeJointTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  poly_shape: tb2_polygon_shape;
  fd: tb2_fixture_def;
  rjd: tb2_revolute_joint_def;
  prev_body: pb2_body;
  i: Integer;
  body: pb2_body;
  anchor: tb2_vec2;
  extra_length: tb2_float32;
  const N = 10;
  const y = 15.0;
begin
  inherited Create;
  _rope_def := b2_rope_joint_def;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.5, 0.125);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 20.0;
    fd.friction := 0.2;
    fd.filter.category_bits := $0001;
    fd.filter.mask_bits := $FFFF and not $0002;
    rjd := b2_revolute_joint_def;
    rjd.collide_connected := false;
    _rope_def.local_anchor_a.set_value(0.0, y);
    prev_body := ground;
    for i := 0 to N - 1 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(0.5 + 1.0 * i, y);
      if i = N - 1 then
      begin
	poly_shape.set_as_box(1.5, 1.5);
	fd.density := 100.0;
	fd.filter.category_bits := $0002;
	bd.position.set_value(1.0 * i, y);
	bd.angular_damping := 0.4;
      end;
      body := _world^.create_body(bd);
      body^.create_fixture(fd);
      anchor.set_value(i, y);
      rjd.initialize(prev_body, body, anchor);
      _world^.create_joint(rjd);
      prev_body := body;
    end;
    _rope_def.local_anchor_b.set_zero;
    extra_length := 0.01;
    _rope_def.max_length := N - 1.0 + extra_length;
    _rope_def.body_b := prev_body;
    poly_shape.destroy;
  end;
  begin
    _rope_def.body_a := ground;
    _rope := pb2_rope_joint(_world^.create_joint(_rope_def));
  end;
end;

procedure TRopeJointTest.Keyboard(const Key: tb2_int32);
begin
  case Key of
    G2K_J:
    begin
      if _rope <> nil then
      begin
	_world^.destroy_joint(_rope);
	_rope := nil;
      end
      else
      begin
        _rope := pb2_rope_joint(_world^.create_joint(_rope_def));
      end;
    end;
  end;
end;

procedure TRopeJointTest.Draw(const Settings: TSettings);
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'Press (j) to toggle the rope joint.');
  _text_line += DRAW_STRING_NEW_LINE;
  if _rope <> nil then
  Game.draw.draw_string(5, _text_line, 'Rope ON')
  else
  Game.draw.draw_string(5, _text_line, 'Rope OFF');
  _text_line += DRAW_STRING_NEW_LINE;
end;
//TRopeJointTest END

//TSensorTest BEGIN
constructor TSensorTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  circle_shape: tb2_circle_shape;
  fd: tb2_fixture_def;
  i: Integer;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    begin
      edge_shape.create;
      edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
      ground^.create_fixture(@edge_shape, 0.0);
      edge_shape.destroy;
    end;
{$if 0}
    begin
      tb2_fixture_def sd;
      sd.SetAsBox(10.0f, 2.0f, b2Vec2(0.0f, 20.0f), 0.0f);
      sd.isSensor = true;
      m_sensor = ground->CreateFixture(&sd);
    end;
{$else}
    begin
      circle_shape.create;
      circle_shape.radius := 5.0;
      circle_shape.center.set_value(0.0, 10.0);
      fd := b2_fixture_def;
      fd.shape := @circle_shape;
      fd.is_sensor := true;
      _sensor := ground^.create_fixture(fd);
      circle_shape.destroy;
    end;
{$endif}
  end;
  begin
    circle_shape.create;
    circle_shape.radius := 1.0;
    for i := 0 to k_count - 1 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(-10.0 + 3.0 * i, 20.0);
      bd.user_data := @_touching[i];
      _touching[i] := false;
      _bodies[i] := _world^.create_body(bd);
      _bodies[i]^.create_fixture(@circle_shape, 1.0);
    end;
    circle_shape.destroy;
  end;
  _world^.set_contact_listener(Self);
end;

procedure TSensorTest.begin_contact(const contact: pb2_contact);
  var fixture_a, fixture_b: pb2_fixture;
  var user_data: tb2_ptr;
begin
  fixture_a := contact^.get_fixture_a;
  fixture_b := contact^.get_fixture_b;
  if fixture_a = _sensor then
  begin
    user_data := fixture_b^.get_body^.get_user_data;
    if user_data <> nil then
    begin
      pboolean(user_data)^ := true;
    end;
  end;
  if fixture_b = _sensor then
  begin
    user_data := fixture_a^.get_body^.get_user_data;
    if user_data <> nil then
    begin
      pboolean(user_data)^ := true;
    end;
  end;
end;

procedure TSensorTest.end_contact(const contact: pb2_contact);
  var fixture_a, fixture_b: pb2_fixture;
  var user_data: tb2_ptr;
begin
  fixture_a := contact^.get_fixture_a;
  fixture_b := contact^.get_fixture_b;
  if fixture_a = _sensor then
  begin
    user_data := fixture_b^.get_body^.get_user_data;
    if user_data <> nil then
    begin
      pboolean(user_data)^ := false;
    end;
  end;
  if fixture_b = _sensor then
  begin
    user_data := fixture_a^.get_body^.get_user_data;
    if user_data <> nil then
    begin
      pboolean(user_data)^ := false;
    end;
  end;
end;

procedure TSensorTest.Step(var Settings: TSettings);
var
  body: pb2_body;
  ground: pb2_body;
  circle: pb2_circle_shape;
  center: tb2_vec2;
  position: tb2_vec2;
  d: tb2_vec2;
  f: tb2_vec2;
  i: Integer;
begin
  inherited Step(Settings);
  for i := 0 to k_count - 1 do
  begin
    if not _touching[i] then Continue;
    body := _bodies[i];
    ground := _sensor^.get_body;
    circle := pb2_circle_shape(_sensor^.get_shape);
    center := ground^.get_world_point(circle^.center);
    position := body^.get_position;
    d := center - position;
    if d.len_sq < b2_epsilon * b2_epsilon then Continue;
    d.normalize;
    f := 100.0 * d;
    body^.apply_force(f, position, false);
  end;
end;
//TSensorTest END

//TShapeEditingTest BEIGN
constructor TShapeEditingTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  poly_shape: tb2_polygon_shape;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  bd := b2_body_def;
  bd.body_type := b2_dynamic_body;
  bd.position.set_value(0.0, 10.0);
  _body := _world^.create_body(bd);
  poly_shape.create;
  poly_shape.set_as_box(4.0, 4.0, b2_vec2(0.0, 0.0), 0.0);
  _fixture1 := _body^.create_fixture(@poly_shape, 10.0);
  _fixture2 := nil;
  _sensor := false;
  poly_shape.destroy;
end;

procedure TShapeEditingTest.Keyboard(const Key: tb2_int32);
var
  circle_shape: tb2_circle_shape;
begin
  case Key of
    G2K_C:
    begin
      if _fixture2 = nil then
      begin
	circle_shape.create;
	circle_shape.radius := 3.0;
	circle_shape.center.set_value(0.5, -4.0);
	_fixture2 := _body^.create_fixture(@circle_shape, 10.0);
	_body^.set_awake(true);
        circle_shape.destroy;
      end;
    end;
    G2K_D:
    begin
      if _fixture2 <> nil then
      begin
	_body^.destroy_fixture(_fixture2);
	_fixture2 := nil;
	_body^.set_awake(true);
      end;
    end;
    G2K_S:
    begin
      if _fixture2 <> nil then
      begin
	_sensor := not _sensor;
	_fixture2^.set_sensor(_sensor);
      end;
    end;
  end;
end;

procedure TShapeEditingTest.Draw(const Settings: TSettings);
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'Press: (c) create a shape, (d) destroy a shape.');
  _text_line += DRAW_STRING_NEW_LINE;
  Game.draw.draw_string(5, _text_line, 'sensor = ' + IntToStr(Integer(_sensor)));
  _text_line += DRAW_STRING_NEW_LINE;
end;
//TShapeEditingTest END

//TSliderCrankTest BEGIN
constructor TSliderCrankTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  prev_body: pb2_body;
  poly_shape: tb2_polygon_shape;
  body: pb2_body;
  rjd: tb2_revolute_joint_def;
  pjd: tb2_prismatic_joint_def;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    prev_body := ground;
    begin
      poly_shape.create;
      poly_shape.set_as_box(0.5, 2.0);
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(0.0, 7.0);
      body := _world^.create_body(bd);
      body^.create_fixture(@poly_shape, 2.0);
      rjd := b2_revolute_joint_def;
      rjd.initialize(prev_body, body, b2_vec2(0.0, 5.0));
      rjd.motor_speed := 1.0 * b2_pi;
      rjd.max_motor_torque := 10000.0;
      rjd.enable_motor := true;
      _joint1 := pb2_revolute_joint(_world^.create_joint(rjd));
      prev_body := body;
      poly_shape.destroy;
    end;
    begin
      poly_shape.create;
      poly_shape.set_as_box(0.5, 4.0);
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(0.0, 13.0);
      body := _world^.create_body(bd);
      body^.create_fixture(@poly_shape, 2.0);
      rjd := b2_revolute_joint_def;
      rjd.initialize(prev_body, body, b2_vec2(0.0, 9.0));
      rjd.enable_motor := false;
      _world^.create_joint(rjd);
      prev_body := body;
      poly_shape.destroy;
    end;
    begin
      poly_shape.create;
      poly_shape.set_as_box(1.5, 1.5);
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.fixed_rotation := true;
      bd.position.set_value(0.0, 17.0);
      body := _world^.create_body(bd);
      body^.create_fixture(@poly_shape, 2.0);
      rjd := b2_revolute_joint_def;
      rjd.initialize(prev_body, body, b2_vec2(0.0, 17.0));
      _world^.create_joint(rjd);
      pjd := b2_prismatic_joint_def;
      pjd.initialize(ground, body, b2_vec2(0.0, 17.0), b2_vec2(0.0, 1.0));
      pjd.max_motor_force := 1000.0;
      pjd.enable_motor := true;
      _joint2 := pb2_prismatic_joint(_world^.create_joint(pjd));
      poly_shape.destroy;
    end;
    begin
      poly_shape.create;
      poly_shape.set_as_box(1.5, 1.5);
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(0.0, 23.0);
      body := _world^.create_body(bd);
      body^.create_fixture(@poly_shape, 2.0);
      poly_shape.destroy;
    end;
  end;
end;

procedure TSliderCrankTest.Keyboard(const Key: tb2_int32);
begin
  case Key of
    G2K_F:
    begin
      _joint2^.enable_motor(not _joint2^.is_motor_enabled);
      _joint2^.get_body_b^.set_awake(true);
    end;
    G2K_M:
    begin
      _joint1^.enable_motor(not _joint1^.is_motor_enabled);
      _joint1^.get_body_b^.set_awake(true);
    end;
  end;
end;

procedure TSliderCrankTest.Draw(const Settings: TSettings);
var
  torque: tb2_float32;
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'Keys: (f) toggle friction, (m) toggle motor');
  _text_line += DRAW_STRING_NEW_LINE;
  torque := _joint1^.get_motor_torque(Settings.hz);
  Game.draw.draw_string(5, _text_line, 'Motor Torque = ' + FloatToStr(torque));
  _text_line += DRAW_STRING_NEW_LINE;
end;
//TSliderCrankTest END

//TSphereStackTest BEGIN
constructor TSphereStackTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  circle_shape: tb2_circle_shape;
  body: pb2_body;
  i: Integer;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    circle_shape.create;
    circle_shape.radius := 1.0;
    for i := 0 to k_count - 1 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(0.0, 4.0 + 3.0 * i);
      body := _world^.create_body(bd);
      body^.create_fixture(@circle_shape, 1.0);
      body^.set_linear_velocity(b2_vec2(0.0, -50.0));
    end;
    circle_shape.destroy;
  end;
end;
//TSphereStackTest END

//TTheoJansenTest BEIGN
procedure TTheoJansenTest.CreateLeg(const s: tb2_float32; const WheelAnchor: tb2_vec2);
  var p1, p2, p3, p4, p5, p6: tb2_vec2;
  var bd1, bd2: tb2_body_def;
  var fd1, fd2: tb2_fixture_def;
  var poly1, poly2: tb2_polygon_shape;
  var body1, body2: pb2_body;
  var vertices: array[0..2] of tb2_vec2;
    djd: tb2_distance_joint_def;
    rjd: tb2_revolute_joint_def;
begin
  p1.set_value(5.4 * s, -6.1);
  p2.set_value(7.2 * s, -1.2);
  p3.set_value(4.3 * s, -1.9);
  p4.set_value(3.1 * s, 0.8);
  p5.set_value(6.0 * s, 1.5);
  p6.set_value(2.5 * s, 3.7);
  fd1 := b2_fixture_def;
  fd2 := b2_fixture_def;
  fd1.filter.group_index := -1;
  fd2.filter.group_index := -1;
  fd1.density := 1.0;
  fd2.density := 1.0;
  poly1.create;
  poly2.create;
  if s > 0.0 then
  begin
    vertices[0] := p1;
    vertices[1] := p2;
    vertices[2] := p3;
    poly1.set_polygon(@vertices, 3);
    vertices[0] := b2_vec2_zero;
    vertices[1] := p5 - p4;
    vertices[2] := p6 - p4;
    poly2.set_polygon(@vertices, 3);
  end
  else
  begin
    vertices[0] := p1;
    vertices[1] := p3;
    vertices[2] := p2;
    poly1.set_polygon(@vertices, 3);
    vertices[0] := b2_vec2_zero;
    vertices[1] := p6 - p4;
    vertices[2] := p5 - p4;
    poly2.set_polygon(@vertices, 3);
  end;
  fd1.shape := @poly1;
  fd2.shape := @poly2;
  bd1 := b2_body_def;
  bd2 := b2_body_def;
  bd1.body_type := b2_dynamic_body;
  bd2.body_type := b2_dynamic_body;
  bd1.position := _offset;
  bd2.position := p4 + _offset;
  bd1.angular_damping := 10.0;
  bd2.angular_damping := 10.0;
  body1 := _world^.create_body(bd1);
  body2 := _world^.create_body(bd2);
  body1^.create_fixture(fd1);
  body2^.create_fixture(fd2);
  djd := b2_distance_joint_def;
  djd.damping_ratio := 0.5;
  djd.frequency_hz := 10.0;
  djd.initialize(body1, body2, p2 + _offset, p5 + _offset);
  _world^.create_joint(djd);
  djd.initialize(body1, body2, p3 + _offset, p4 + _offset);
  _world^.create_joint(djd);
  djd.initialize(body1, _wheel, p3 + _offset, WheelAnchor + _offset);
  _world^.create_joint(djd);
  djd.Initialize(body2, _wheel, p6 + _offset, WheelAnchor + _offset);
  _world^.create_joint(djd);
  rjd := b2_revolute_joint_def;
  rjd.initialize(body2, _chassis, p4 + _offset);
  _world^.create_joint(rjd);
  poly1.destroy;
  poly2.destroy;
end;

constructor TTheoJansenTest.Create;
  var pivot: tb2_vec2;
    bd: tb2_body_def;
    ground: pb2_body;
    edge_shape: tb2_edge_shape;
    circle_shape: tb2_circle_shape;
    body: pb2_body;
    poly_shape: tb2_polygon_shape;
    sd: tb2_fixture_def;
    rjd: tb2_revolute_joint_def;
    WheelAnchor: tb2_vec2;
    i: Integer;
begin
  inherited Create;
  _offset.set_value(0.0, 8.0);
  _motor_speed := 2.0;
  _motor_on := true;
  pivot.set_value(0.0, 0.8);
  // Ground
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-50.0, 0.0), b2_vec2(50.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.set_edge(b2_vec2(-50.0, 0.0), b2_vec2(-50.0, 10.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.set_edge(b2_vec2(50.0, 0.0), b2_vec2(50.0, 10.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  // Balls
  circle_shape.create;
  for i := 0 to 40 - 1 do
  begin
    circle_shape.radius := 0.25;
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-40.0 + 2.0 * i, 0.5);
    body := _world^.create_body(bd);
    body^.create_fixture(@circle_shape, 1.0);
  end;
  circle_shape.destroy;
  // Chassis
  begin
    poly_shape.create;
    poly_shape.set_as_box(2.5, 1.0);
    sd := b2_fixture_def;
    sd.density := 1.0;
    sd.shape := @poly_shape;
    sd.filter.group_index := -1;
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position := pivot + _offset;
    _chassis := _world^.create_body(bd);
    _chassis^.create_fixture(sd);
    poly_shape.destroy;
  end;
  begin
    circle_shape.create;
    circle_shape.radius := 1.6;
    sd := b2_fixture_def;
    sd.density := 1.0;
    sd.shape := @circle_shape;
    sd.filter.group_index := -1;
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position := pivot + _offset;
    _wheel := _world^.create_body(bd);
    _wheel^.create_fixture(sd);
    circle_shape.destroy;
  end;
  begin
    rjd := b2_revolute_joint_def;
    rjd.initialize(_wheel, _chassis, pivot + _offset);
    rjd.collide_connected := false;
    rjd.motor_speed := _motor_speed;
    rjd.max_motor_torque := 400.0;
    rjd.enable_motor := _motor_on;
    _motor_joint := pb2_revolute_joint(_world^.create_joint(rjd));
  end;
  WheelAnchor := pivot + b2_vec2(0.0, -0.8);
  CreateLeg(-1.0, WheelAnchor);
  CreateLeg(1.0, WheelAnchor);
  _wheel^.set_transform(_wheel^.get_position, 120.0 * b2_pi / 180.0);
  CreateLeg(-1.0, WheelAnchor);
  CreateLeg(1.0, WheelAnchor);
  _wheel^.set_transform(_wheel^.get_position, -120.0 * b2_pi / 180.0);
  CreateLeg(-1.0, WheelAnchor);
  CreateLeg(1.0, WheelAnchor);
end;

procedure TTheoJansenTest.Draw(const Settings: TSettings);
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'Keys: left = a, brake = s, right = d, toggle motor = m');
  _text_line += DRAW_STRING_NEW_LINE;
end;

procedure TTheoJansenTest.Keyboard(const Key: tb2_int32);
begin
  case Key of
    G2K_A: _motor_joint^.set_motor_speed(_motor_speed);
    G2K_S: _motor_joint^.set_motor_speed(0.0);
    G2K_D: _motor_joint^.set_motor_speed(-_motor_speed);
    G2K_M: _motor_joint^.enable_motor(not _motor_joint^.is_motor_enabled);
  end;
end;
//TTheoJansenTest END

//TTilesTest BEGIN
constructor TTilesTest.Create;
  var timer: tb2_timer;
  var a: tb2_float32;
    bd: tb2_body_def;
    ground, body: pb2_body;
    n: tb2_int32;
    m: tb2_int32;
    position: tb2_vec2;
    j: Integer;
    i: Integer;
    poly_shape: tb2_polygon_shape;
    x: tb2_vec2;
    y: tb2_vec2;
    delta_x: tb2_vec2;
    delta_y: tb2_vec2;
begin
  inherited Create;
  _fixture_count := 0;
  timer.create;
  begin
    a := 0.5;
    bd := b2_body_def;
    bd.position.y := -a;
    ground := _world^.create_body(bd);
{$if 1}
    n := 200;
    m := 10;
    position.set_value(0.0, 0.0);
    for j := 0 to m - 1 do
    begin
      position.x := -n * a;
      for i := 0 to n - 1 do
      begin
	poly_shape.create;
	poly_shape.set_as_box(a, a, position, 0.0);
	ground^.create_fixture(@poly_shape, 0.0);
	inc(_fixture_count);
	position.x += 2.0 * a;
        poly_shape.destroy;
      end;
      position.y -= 2.0 * a;
    end;
{$else}
    int32 N = 200;
    int32 M = 10;
    b2Vec2 position;
    position.x = -N * a;
    for (int32 i = 0; i < N; ++i)
    {
	    position.y = 0.0f;
	    for (int32 j = 0; j < M; ++j)
	    {
		    b2PolygonShape shape;
		    shape.SetAsBox(a, a, position, 0.0f);
		    ground->CreateFixture(&shape, 0.0f);
		    position.y -= 2.0f * a;
	    }
	    position.x += 2.0f * a;
    }
{$endif}
  end;
  begin
    a := 0.5;
    poly_shape.create;
    poly_shape.set_as_box(a, a);
    x.set_value(-7.0, 0.75);
    delta_x.set_value(0.5625, 1.25);
    delta_y.set_value(1.125, 0.0);
    for i := 0 to k_count - 1 do
    begin
      y := x;
      for j := i to k_count - 1 do
      begin
	bd := b2_body_def;
	bd.body_type := b2_dynamic_body;
	bd.position := y;
	body := _world^.create_body(bd);
	body^.create_fixture(@poly_shape, 5.0);
	inc(_fixture_count);
	y += delta_y;
      end;
      x += delta_x;
    end;
    poly_shape.destroy;
  end;
  _create_time := timer.get_milliseconds;
end;

procedure TTilesTest.Draw(const Settings: TSettings);
  var cm: pb2_contact_manager;
  var height, leaf_count, min_node_count, min_height: tb2_int32;
begin
  inherited Draw(Settings);
  cm := _world^.get_contact_manager;
  height := cm^.broad_phase.get_tree_height;
  leaf_count := cm^.broad_phase.get_proxy_count;
  min_node_count := 2 * leaf_count - 1;
  min_height := Trunc(ln(min_node_count) / ln(2.0)) + 1;
  Game.draw.draw_string(5, _text_line, 'dynamic tree height = ' + IntToStr(height) + ', min = ' + IntToStr(min_height));
  _text_line += DRAW_STRING_NEW_LINE;
  Game.draw.draw_string(5, _text_line, 'create time = ' + FloatToStr(_create_time) + ' ms, fixture count = ' + IntToStr(_fixture_count));
  _text_line += DRAW_STRING_NEW_LINE;
end;
//TTilesTest END

//TTimeOfImpactTest BEGIN
constructor TTimeOfImpactTest.Create;
begin
  inherited Create;
  _shape_a.create;
  _shape_b.create;
  _shape_a.set_as_box(25.0, 5.0);
  _shape_b.set_as_box(2.5, 2.5);
end;

destructor TTimeOfImpactTest.Destroy;
begin
  _shape_a.destroy;
  _shape_b.destroy;
  inherited Destroy;
end;

procedure TTimeOfImpactTest.Step(var Settings: TSettings);
var
  input: tb2_toi_input;
begin
  inherited Step(Settings);
  _sweep_a.c0.set_value(14.0, -10.0);
  _sweep_a.a0 := 2.95;
  _sweep_a.c := _sweep_a.c0;
  _sweep_a.a := _sweep_a.a0;
  _sweep_a.local_center.set_zero;
  _sweep_b.c0.set_value(43.474274, -0.252514);
  _sweep_b.a0 := 513.36676; // - 162.0f * b2_pi;
  //_sweep_b.c.set_value(54.595478, -51.083473);
  _sweep_b.c.set_value(24.595478, -21.083473);
  _sweep_b.a := 513.62781; //  - 162.0f * b2_pi;
  _sweep_b.local_center.set_zero;
  //sweepB.a0 -= 300.0f * b2_pi;
  //sweepB.a -= 300.0f * b2_pi;
  input.proxy_a.set_shape(@_shape_a, 0);
  input.proxy_b.set_shape(@_shape_b, 0);
  input.sweep_a := _sweep_a;
  input.sweep_b := _sweep_b;
  input.t_max := 1.0;
  b2_time_of_impact(_toi_output, input);
{$if 0}
  for (float32 t = 0.0f; t < 1.0f; t += 0.1f)
  {
	  sweepB.GetTransform(&transformB, t);
	  for (int32 i = 0; i < m_shapeB.m_count; ++i)
	  {
		  vertices[i] = b2Mul(transformB, m_shapeB.m_vertices[i]);
	  }
	  g_debugDraw.DrawPolygon(vertices, m_shapeB.m_count, b2Color(0.9f, 0.5f, 0.5f));
  }
{$endif}
end;

procedure TTimeOfImpactTest.Draw(const Settings: TSettings);
  var vertices: array[0..b2_max_polygon_vertices - 1] of tb2_vec2;
  var xf_a, xf_b: tb2_transform;
    i: Integer;
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'toi = ' + FloatToStr(_toi_output.t));
  _text_line += DRAW_STRING_NEW_LINE;
  _sweep_a.get_transform(@xf_a, 0.0);
  for i := 0 to _shape_a.count - 1 do
  vertices[i] := b2_mul(xf_a, _shape_a.vertices[i]);
  Game.draw.draw_polygon(@vertices, _shape_a.count, b2_color(0.9, 0.9, 0.9));
  _sweep_b.get_transform(@xf_b, 0.0);
  for i := 0 to _shape_b.count - 1 do
  vertices[i] := b2_mul(xf_b, _shape_b.vertices[i]);
  Game.draw.draw_polygon(@vertices, _shape_b.count, b2_color(0.5, 0.9, 0.5));
  _sweep_b.get_transform(@xf_b, _toi_output.t);
  for i := 0 to _shape_b.count - 1 do
  vertices[i] := b2_mul(xf_b, _shape_b.vertices[i]);
  Game.draw.draw_polygon(@vertices, _shape_b.count, b2_color(0.5, 0.7, 0.9));
  _sweep_b.get_transform(@xf_b, 1.0);
  for i := 0 to _shape_b.count - 1 do
  vertices[i] := b2_mul(xf_b, _shape_b.vertices[i]);
  Game.draw.draw_polygon(@vertices, _shape_b.count, b2_color(0.9, 0.5, 0.5));
end;
//TTimeOfImpactTest END

//TTumblerTest BEGIN
constructor TTumblerTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  body: pb2_body;
  poly_shape: tb2_polygon_shape;
  rjd: tb2_revolute_joint_def;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
  end;
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.allow_sleep := false;
    bd.position.set_value(0.0, 10.0);
    body := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(0.5, 10.0, b2_vec2(10.0, 0.0), 0.0);
    body^.create_fixture(@poly_shape, 5.0);
    poly_shape.set_as_box(0.5, 10.0, b2_vec2(-10.0, 0.0), 0.0);
    body^.create_fixture(@poly_shape, 5.0);
    poly_shape.set_as_box(10.0, 0.5, b2_vec2(0.0, 10.0), 0.0);
    body^.create_fixture(@poly_shape, 5.0);
    poly_shape.set_as_box(10.0, 0.5, b2_vec2(0.0, -10.0), 0.0);
    body^.create_fixture(@poly_shape, 5.0);
    rjd := b2_revolute_joint_def;
    rjd.body_a := ground;
    rjd.body_b := body;
    rjd.local_anchor_a.set_value(0.0, 10.0);
    rjd.local_anchor_b.set_value(0.0, 0.0);
    rjd.reference_angle := 0.0;
    rjd.motor_speed := 0.05 * b2_pi;
    rjd.max_motor_torque := 1e+8;
    rjd.enable_motor := true;
    _joint := pb2_revolute_joint(_world^.create_joint(rjd));
    poly_shape.destroy;
  end;
  _count := 0;
  //b2_block_solve := false;
end;

destructor TTumblerTest.Destroy;
begin
  //b2_block_solve := true;
  inherited Destroy;
end;

procedure TTumblerTest.Step(var Settings: TSettings);
var
  bd: tb2_body_def;
  body: pb2_body;
  poly_shape: tb2_polygon_shape;
begin
  inherited Step(Settings);
  if _count < k_count then
  begin
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(0.0, 10.0);
    body := _world^.create_body(bd);
    poly_shape.create;
    poly_shape.set_as_box(0.125, 0.125);
    body^.create_fixture(@poly_shape, 1.0);
    inc(_count);
    poly_shape.destroy;
  end;
end;

procedure TTumblerTest.Draw(const Settings: TSettings);
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'gjk_calls: ' + IntToStr(b2_gjk_calls) + '; gjk_iters: ' + IntToStr(b2_gjk_iters) + '; gjk_max_iters: ' + IntToStr(b2_gjk_max_iters));
  _text_line += DRAW_STRING_NEW_LINE;
  Game.draw.draw_string(5, _text_line, 'b2_toi_time: ' + FloatToStr(b2_toi_time) + '; b2_toi_max_time: ' + FloatToStr(b2_toi_max_time));
  _text_line += DRAW_STRING_NEW_LINE;
  Game.draw.draw_string(5, _text_line, 'b2_toi_calls: ' + IntToStr(b2_toi_calls) + '; b2_toi_iters: ' + IntToStr(b2_toi_iters) + '; b2_toi_max_iters: ' + IntToStr(b2_toi_max_iters));
  _text_line += DRAW_STRING_NEW_LINE;
end;
//TTumblerTest END

//TVaryingFrictionTest BEGIN
constructor TVaryingFrictionTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  poly_shape: tb2_polygon_shape;
  fd: tb2_fixture_def;
  body: pb2_body;
  i: Integer;
const
  friction: array[0..4] of tb2_float32 = (0.75, 0.5, 0.35, 0.1, 0.0);
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(13.0, 0.25);
    bd := b2_body_def;
    bd.position.set_value(-4.0, 22.0);
    bd.angle := -0.25;
    ground := _world^.create_body(bd);
    ground^.create_fixture(@poly_shape, 0.0);
    poly_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.25, 1.0);
    bd := b2_body_def;
    bd.position.set_value(10.5, 19.0);
    ground := _world^.create_body(bd);
    ground^.create_fixture(@poly_shape, 0.0);
    poly_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(13.0, 0.25);
    bd := b2_body_def;
    bd.position.set_value(4.0, 14.0);
    bd.angle := 0.25;
    ground := _world^.create_body(bd);
    ground^.create_fixture(@poly_shape, 0.0);
    poly_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.25, 1.0);
    bd := b2_body_def;
    bd.position.set_value(-10.5, 11.0);
    ground := _world^.create_body(bd);
    ground^.create_fixture(@poly_shape, 0.0);
    poly_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(13.0, 0.25);
    bd := b2_body_def;
    bd.position.set_value(-4.0, 6.0);
    bd.angle := -0.25;
    ground := _world^.create_body(bd);
    ground^.create_fixture(@poly_shape, 0.0);
    poly_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.5, 0.5);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 25.0;
    for i := 0 to High(friction) do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(-15.0 + 4.0 * i, 28.0);
      body := _world^.create_body(bd);
      fd.friction := friction[i];
      body^.create_fixture(fd);
    end;
    poly_shape.destroy;
  end;
end;
//TVaryingFrictionTest END

//TVaryingRestitutionTest BEGIN
constructor TVaryingRestitutionTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  circle_shape: tb2_circle_shape;
  fd: tb2_fixture_def;
  body: pb2_body;
  i: Integer;
const
  restitution: array[0..6] of tb2_float32 = (0.0, 0.1, 0.3, 0.5, 0.75, 0.9, 1.0);
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    circle_shape.create;
    circle_shape.radius := 1.0;
    fd := b2_fixture_def;
    fd.shape := @circle_shape;
    fd.density := 1.0;
    for i := 0 to High(restitution) do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      bd.position.set_value(-10.0 + 3.0 * i, 20.0);
      body := _world^.create_body(bd);
      fd.restitution := restitution[i];
      body^.create_fixture(fd);
    end;
    circle_shape.destroy;
  end;
end;
//TVaryingRestitutionTest END

//TVerticalStackTest BEIGN
constructor TVerticalStackTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  j: Integer;
  poly_shape: tb2_polygon_shape;
  i: Integer;
  n: tb2_int32;
  x: tb2_float32;
  body: pb2_body;
  fd: tb2_fixture_def;
const
  xs: array[0..4] of tb2_float32 = (0.0, -10.0, -5.0, 5.0, 10.0);
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.set_edge(b2_vec2(20.0, 0.0), b2_vec2(20.0, 20.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  for j := 0 to k_column_count - 1 do
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.5, 0.5);
    fd := b2_fixture_def;
    fd.shape := @poly_shape;
    fd.density := 1.0;
    fd.friction := 0.3;
    for i := 0 to k_row_count - 1 do
    begin
      bd := b2_body_def;
      bd.body_type := b2_dynamic_body;
      n := j * k_row_count + i;
      _indices[n] := n;
      bd.user_data := @_indices[n];
      x := 0.0;
      //float32 x = RandomFloat(-0.02f, 0.02f);
      //float32 x = i % 2 == 0 ? -0.01f : 0.01f;
      bd.position.set_value(xs[j] + x, 0.55 + 1.1 * i);
      body := _world^.create_body(bd);
      _bodies[n] := body;
      body^.create_fixture(fd);
    end;
  end;
  _bullet := nil;
end;

procedure TVerticalStackTest.Keyboard(const Key: tb2_int32);
var
  circle_shape: tb2_circle_shape;
  fd: tb2_fixture_def;
  bd: tb2_body_def;
begin
  case Key of
    G2K_Comma:
    begin
      if _bullet <> nil then
      begin
	_world^.destroy_body(_bullet);
	_bullet := nil;
      end;
      begin
	circle_shape.create;
	circle_shape.radius := 0.25;
	fd := b2_fixture_def;
	fd.shape := @circle_shape;
	fd.density := 20.0;
	fd.restitution := 0.05;
	bd := b2_body_def;
	bd.body_type := b2_dynamic_body;
	bd.bullet := true;
	bd.position.set_value(-31.0, 5.0);
	_bullet := _world^.create_body(bd);
	_bullet^.create_fixture(fd);
	_bullet^.set_linear_velocity(b2_vec2(400.0, 0.0));
        circle_shape.destroy;
      end;
    end;
    G2K_B: b2_block_solve := not b2_block_solve;
  end;
end;

procedure TVerticalStackTest.Draw(const Settings: TSettings);
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'Press: (,) to launch a bullet.');
  _text_line += DRAW_STRING_NEW_LINE;
  Game.draw.draw_string(5, _text_line, 'Blocksolve = ' + IntToStr(Integer(b2_block_solve)));
end;
//TVerticalStackTest END

//TWebTest BEGIN
constructor TWebTest.Create;
var
  bd: tb2_body_def;
  ground: pb2_body;
  edge_shape: tb2_edge_shape;
  poly_shape: tb2_polygon_shape;
  p1: tb2_vec2;
  p2: tb2_vec2;
  d: tb2_vec2;
  jd: tb2_distance_joint_def;
begin
  inherited Create;
  begin
    bd := b2_body_def;
    ground := _world^.create_body(bd);
    edge_shape.create;
    edge_shape.set_edge(b2_vec2(-40.0, 0.0), b2_vec2(40.0, 0.0));
    ground^.create_fixture(@edge_shape, 0.0);
    edge_shape.destroy;
  end;
  begin
    poly_shape.create;
    poly_shape.set_as_box(0.5, 0.5);
    bd := b2_body_def;
    bd.body_type := b2_dynamic_body;
    bd.position.set_value(-5.0, 5.0);
    _bodies[0] := _world^.create_body(bd);
    _bodies[0]^.create_fixture(@poly_shape, 5.0);
    bd.position.set_value(5.0, 5.0);
    _bodies[1] := _world^.create_body(bd);
    _bodies[1]^.create_fixture(@poly_shape, 5.0);
    bd.position.set_value(5.0, 15.0);
    _bodies[2] := _world^.create_body(bd);
    _bodies[2]^.create_fixture(@poly_shape, 5.0);
    bd.position.set_value(-5.0, 15.0);
    _bodies[3] := _world^.create_body(bd);
    _bodies[3]^.create_fixture(@poly_shape, 5.0);
    jd := b2_distance_joint_def;
    jd.frequency_hz := 2.0;
    jd.damping_ratio := 0.0;
    jd.body_a := ground;
    jd.body_b := _bodies[0];
    jd.local_anchor_a.set_value(-10.0, 0.0);
    jd.local_anchor_b.set_value(-0.5, -0.5);
    p1 := jd.body_a^.get_world_point(jd.local_anchor_a);
    p2 := jd.body_b^.get_world_point(jd.local_anchor_b);
    d := p2 - p1;
    jd.len := d.len;
    _joints[0] := _world^.create_joint(jd);
    jd.body_a := ground;
    jd.body_b := _bodies[1];
    jd.local_anchor_a.set_value(10.0, 0.0);
    jd.local_anchor_b.set_value(0.5, -0.5);
    p1 := jd.body_a^.get_world_point(jd.local_anchor_a);
    p2 := jd.body_b^.get_world_point(jd.local_anchor_b);
    d := p2 - p1;
    jd.len := d.len;
    _joints[1] := _world^.create_joint(jd);
    jd.body_a := ground;
    jd.body_b := _bodies[2];
    jd.local_anchor_a.set_value(10.0, 20.0);
    jd.local_anchor_b.set_value(0.5, 0.5);
    p1 := jd.body_a^.get_world_point(jd.local_anchor_a);
    p2 := jd.body_b^.get_world_point(jd.local_anchor_b);
    d := p2 - p1;
    jd.len := d.len;
    _joints[2] := _world^.create_joint(jd);
    jd.body_a := ground;
    jd.body_b := _bodies[3];
    jd.local_anchor_a.set_value(-10.0, 20.0);
    jd.local_anchor_b.set_value(-0.5, 0.5);
    p1 := jd.body_a^.get_world_point(jd.local_anchor_a);
    p2 := jd.body_b^.get_world_point(jd.local_anchor_b);
    d := p2 - p1;
    jd.len := d.len;
    _joints[3] := _world^.create_joint(jd);
    jd.body_a := _bodies[0];
    jd.body_b := _bodies[1];
    jd.local_anchor_a.set_value(0.5, 0.0);
    jd.local_anchor_b.set_value(-0.5, 0.0);
    p1 := jd.body_a^.get_world_point(jd.local_anchor_a);
    p2 := jd.body_b^.get_world_point(jd.local_anchor_b);
    d := p2 - p1;
    jd.len := d.len;
    _joints[4] := _world^.create_joint(jd);
    jd.body_a := _bodies[1];
    jd.body_b := _bodies[2];
    jd.local_anchor_a.set_value(0.0, 0.5);
    jd.local_anchor_b.set_value(0.0, -0.5);
    p1 := jd.body_a^.get_world_point(jd.local_anchor_a);
    p2 := jd.body_b^.get_world_point(jd.local_anchor_b);
    d := p2 - p1;
    jd.len := d.len;
    _joints[5] := _world^.create_joint(jd);
    jd.body_a := _bodies[2];
    jd.body_b := _bodies[3];
    jd.local_anchor_a.set_value(-0.5, 0.0);
    jd.local_anchor_b.set_value(0.5, 0.0);
    p1 := jd.body_a^.get_world_point(jd.local_anchor_a);
    p2 := jd.body_b^.get_world_point(jd.local_anchor_b);
    d := p2 - p1;
    jd.len := d.len;
    _joints[6] := _world^.create_joint(jd);
    jd.body_a := _bodies[3];
    jd.body_b := _bodies[0];
    jd.local_anchor_a.set_value(0.0, -0.5);
    jd.local_anchor_b.set_value(0.0, 0.5);
    p1 := jd.body_a^.get_world_point(jd.local_anchor_a);
    p2 := jd.body_b^.get_world_point(jd.local_anchor_b);
    d := p2 - p1;
    jd.len := d.len;
    _joints[7] := _world^.create_joint(jd);
    poly_shape.destroy;
  end;
end;

procedure TWebTest.Keyboard(const Key: tb2_int32);
var
  i: Integer;
begin
  case Key of
    G2K_B:
    begin
      for i := 0 to 3 do
      if _bodies[i] <> nil then
      begin
	_world^.destroy_body(_bodies[i]);
	_bodies[i] := nil;
        Break;
      end;
    end;
    G2K_J:
    begin
      for i := 0 to 7 do
      if _joints[i] <> nil then
      begin
	_world^.destroy_joint(_joints[i]);
	_joints[i] := nil;
	Break;
      end;
    end;
  end;
end;

procedure TWebTest.Draw(const Settings: TSettings);
begin
  inherited Draw(Settings);
  Game.draw.draw_string(5, _text_line, 'This demonstrates a soft distance joint.');
  _text_line += DRAW_STRING_NEW_LINE;
  Game.draw.draw_string(5, _text_line, 'Press: (b) to delete a body, (j) to delete a joint');
  _text_line += DRAW_STRING_NEW_LINE;
end;

procedure TWebTest.JointDestroyed(const joint: pb2_joint);
var
  i: Integer;
begin
  for i := 0 to 7 do
  begin
    if _joints[i] = joint then
    begin
      _joints[i] := nil;
      break;
    end;
  end;
end;
//TWebTest END

//TGame BEGIN
procedure TGame.AddTest(const TestClass: CTest);
begin
  SetLength(tests, Length(tests) + 1);
  tests[High(tests)] := TestClass;
end;

constructor TGame.Create;
begin
  g2.CallbackInitializeAdd(@Initialize);
  g2.CallbackFinalizeAdd(@Finalize);
  g2.CallbackUpdateAdd(@Update);
  g2.CallbackRenderAdd(@Render);
  g2.CallbackKeyDownAdd(@KeyDown);
  g2.CallbackKeyUpAdd(@KeyUp);
  g2.CallbackMouseDownAdd(@MouseDown);
  g2.CallbackMouseUpAdd(@MouseUp);
  g2.CallbackScrollAdd(@Scroll);
  g2.CallbackPrintAdd(@Print);
  g2.Params.MaxFPS := 100;
  g2.Params.Width := 1024;
  g2.Params.Height := 768;
  g2.Params.TargetUPS := 60;
  g2.Params.ScreenMode := smMaximized;
  g2.Params.PreventUpdateOverload := True;
  AddTest(TBodyTypesTest);
  AddTest(TBasicSliderCrankTest);
  AddTest(TApplyForceTest);
  AddTest(TAddPairTest);
  AddTest(TBreakableTest);
  AddTest(TBridgeTest);
  AddTest(TBulletTest);
  AddTest(TCantileverTest);
  AddTest(TCarTest);
  AddTest(TChainTest);
  AddTest(TCharacterCollisionTest);
  AddTest(TCollisionFilteringTest);
  AddTest(TCollisionProcessingTest);
  AddTest(TCompoundShapesTest);
  AddTest(TConfinedTest);
  AddTest(TContinuousTest);
  AddTest(TConvexHullTest);
  AddTest(TConveyorBeltTest);
  AddTest(TDistanceTest);
  AddTest(TDominosTest);
  AddTest(TDynamicTreeTest);
  AddTest(TEdgeShapesTest);
  AddTest(TEdgeTest);
  AddTest(TGearsTest);
  AddTest(THeavyOnLightTest);
  AddTest(THeavyOnLightTwoTest);
  AddTest(TMobileTest);
  AddTest(TMobileBalancedTest);
  AddTest(TMotorJointTest);
  AddTest(TOneSidedPlatformTest);
  AddTest(TPinballTest);
  AddTest(TPolyCollisionTest);
  AddTest(TPolyShapesTest);
  AddTest(TPrismaticTest);
  AddTest(TPulleysTest);
  AddTest(TPyramidTest);
  AddTest(TRayCastTest);
  AddTest(TRevoluteTest);
  AddTest(TRopeJointTest);
  AddTest(TSensorTest);
  AddTest(TShapeEditingTest);
  AddTest(TSliderCrankTest);
  AddTest(TSphereStackTest);
  AddTest(TTheoJansenTest);
  AddTest(TTilesTest);
  AddTest(TTimeOfImpactTest);
  AddTest(TTumblerTest);
  AddTest(TVaryingFrictionTest);
  AddTest(TVaryingRestitutionTest);
  AddTest(TVerticalStackTest);
  AddTest(TWebTest);
end;

destructor TGame.Destroy;
begin
  g2.CallbackInitializeRemove(@Initialize);
  g2.CallbackFinalizeRemove(@Finalize);
  g2.CallbackUpdateRemove(@Update);
  g2.CallbackRenderRemove(@Render);
  g2.CallbackKeyDownRemove(@KeyDown);
  g2.CallbackKeyUpRemove(@KeyUp);
  g2.CallbackMouseDownRemove(@MouseDown);
  g2.CallbackMouseUpRemove(@MouseUp);
  g2.CallbackScrollRemove(@Scroll);
  g2.CallbackPrintRemove(@Print);
  inherited Destroy;
end;

procedure TGame.Initialize;
begin
  Font := TG2Font.Create;
  Font.Make(32);
  disp := TG2Display2D.Create;
  disp.Position := G2Vec2(0, 0);
  disp_zoom := 10;
  disp.Zoom := disp_zoom;
  disp.Rotation := Pi;
  disp.Position := G2Vec2(0, 20);
  draw := t_draw.create;
  CurTest := High(tests);
  Settings := CreateSettings;
  //Settings.pause := true;
  Settings.hz := g2.Params.TargetUPS;
  Settings.enable_warm_starting := true;
  Settings.enable_continuous := true;
  Settings.enable_sub_stepping := false;
  //Settings.position_iterations := 1;
  //Settings.velocity_iterations := 5;
  Settings.draw_stats := true;
  Settings.draw_profile := true;
  Settings.draw_joints := true;
  Test := tests[CurTest].Create;
end;

procedure TGame.Finalize;
begin
  Test.Free;
  draw.free;
  Font.Free;
end;

procedure TGame.Update;
  var NewMousePos: TPoint;
  var v0, v1, vd: TG2Vec2;
begin
  NewMousePos := g2.MousePos;
  if (NewMousePos.x <> MousePos.x) or (NewMousePos.y <> MousePos.y) then
  begin
    v0 := disp.CoordToDisplay(G2Vec2(MousePos.x, MousePos.y));
    v1 := disp.CoordToDisplay(G2Vec2(NewMousePos.x, NewMousePos.y));
    vd := v1 - v0;
    Test.MouseMove(b2_vec2(v1.x, v1.y));
    MousePos := NewMousePos;
  end;
  if g2.MouseDown[G2MB_Right]
  and (
    (NewMousePos.x <> PrevMdPos.x)
    or (NewMousePos.y <> PrevMdPos.y)
  ) then
  begin
    v0 := disp.CoordToDisplay(G2Vec2(PrevMdPos.x, PrevMdPos.y));
    v1 := disp.CoordToDisplay(G2Vec2(NewMousePos.x, NewMousePos.y));
    vd := v0 - v1;
    disp.Position := disp.Position + vd;
    PrevMdPos := NewMousePos;
  end;
  Test.Step(Settings);
  disp.Zoom := G2LerpFloat(disp.Zoom, disp_zoom, 0.1);
end;

procedure TGame.Render;
begin
  g2.Clear($ff000000);
  Test.Draw(Settings);
end;

procedure TGame.KeyDown(const Key: Integer);
begin
  case Key of
    G2K_O: Settings.single_step := true;
    G2K_P: Settings.pause := not Settings.pause;
    G2K_R: ResetTest;
    G2K_BrktL: PrevTest;
    G2K_BrktR: NextTest;
  end;
  Test.Keyboard(Key);
end;

procedure TGame.KeyUp(const Key: Integer);
begin
  Test.KeyboardUp(Key);
end;

procedure TGame.MouseDown(const Button, x, y: Integer);
  var v: TG2Vec2;
begin
  case Button of
    G2MB_Left:
    begin
      v := disp.CoordToDisplay(G2Vec2(x, y));
      if (g2.KeyDown[G2K_ShiftL]) then
      Test.ShiftMouseDown(b2_vec2(v.x, v.y))
      else
      Test.MouseDown(b2_vec2(v.x, v.y));
    end;
    G2MB_Right:
    begin
      if Button = G2MB_Right then
      PrevMdPos := Point(x, y);
    end;
  end;
end;

procedure TGame.MouseUp(const Button, x, y: Integer);
  var v: TG2Vec2;
begin
  v := disp.CoordToDisplay(G2Vec2(x, y));
  Test.MouseUp(b2_vec2(v.x, v.y));
end;

procedure TGame.Scroll(const y: Integer);
begin
  if y > 0 then
  disp_zoom := disp_zoom * 1.1
  else
  disp_zoom := disp_zoom / 1.1;
end;

procedure TGame.Print(const c: AnsiChar);
begin

end;

procedure TGame.ResetTest;
begin
  test.Free;
  test := tests[CurTest].Create;
end;

procedure TGame.PrevTest;
begin
  CurTest -= 1;
  if CurTest < 0 then CurTest := High(tests);
  ResetTest;
end;

procedure TGame.NextTest;
begin
  CurTest := (CurTest + 1) mod Length(tests);
  ResetTest;
end;
//TGame END

function CreateSettings: TSettings;
begin
  with Result do
  begin
    hz := g2.Params.TargetUPS;
    velocity_iterations := 8;
    position_iterations := 3;
    draw_shapes := true;
    draw_joints := true;
    draw_aabbs := false;
    draw_contact_points := false;
    draw_contact_normals := false;
    draw_contact_impulse := false;
    draw_friction_impulse := false;
    draw_coms := false;
    draw_stats := false;
    draw_profile := false;
    enable_warm_starting := true;
    enable_continuous := true;
    enable_sub_stepping := false;
    enable_sleep := true;
    pause := false;
    single_step := false;
  end;
end;

function RandomFloat: tb2_float32;
begin
  Result := Random * 2 - 1;
end;

function RandomFloat(const l, h: tb2_float32): tb2_float32;
begin
  Result := Random * (h - l) + l;
end;

end.
