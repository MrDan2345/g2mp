// box2d.pas
// 2d physics engine originally made by Erin Catto http://www.box2d.org
// translated to pascal by Andrey Martynov (dan.soft.studio@gmail.com)
{$mode objfpc}
{$inline on}
unit box2d;

interface

uses
  sysutils,
  {$if defined(WIN32)}
  windows,
  {$elseif defined(UNIX)}
  linux, BaseUnix, unixtype,
  {$endif}
  math;

type
  tb2_ptr = pointer;
  tb2_int8 = shortint;
  tb2_int16 = smallint;
  tb2_int32 = longint;
  tb2_uint8 = byte;
  tb2_uint16 = word;
  tb2_uint32 = longword;
  tb2_float32 = single;
  tb2_float64 = double;
  pb2_ptr = ^tb2_ptr;
  pb2_int8 = ^tb2_int8;
  pb2_int16 = ^tb2_int16;
  pb2_int32 = ^tb2_int32;
  pb2_uint8 = ^tb2_uint8;
  pb2_uint16 = ^tb2_uint16;
  pb2_uint32 = ^tb2_uint32;
  pb2_float32 = ^tb2_float32;
  pb2_float64 = ^tb2_float64;
  tb2_ptr_arr = array[word] of tb2_ptr;
  tb2_int8_arr = array[word] of tb2_int8;
  tb2_int16_arr = array[word] of tb2_int16;
  tb2_int32_arr = array[word] of tb2_int32;
  tb2_uint8_arr = array[word] of tb2_uint8;
  tb2_uint16_arr = array[word] of tb2_uint16;
  tb2_uint32_arr = array[word] of tb2_uint32;
  tb2_float32_arr = array[word] of tb2_float32;
  tb2_float64_arr = array[word] of tb2_float64;
  pb2_ptr_arr = ^tb2_ptr_arr;
  pb2_int8_arr = ^tb2_int8_arr;
  pb2_int16_arr = ^tb2_int16_arr;
  pb2_int32_arr = ^tb2_int32_arr;
  pb2_uint8_arr = ^tb2_uint8_arr;
  pb2_uint16_arr = ^tb2_uint16_arr;
  pb2_uint32_arr = ^tb2_uint32_arr;
  pb2_float32_arr = ^tb2_float32_arr;
  pb2_float64_arr = ^tb2_float64_arr;

const
  b2_max_float = maxsingle;
  b2_epsilon = 1.192092896E-07;
  b2_pi = 3.14159265359;
  b2_two_pi = b2_pi * b2_pi;

  b2_max_manifold_points = 2;
  b2_max_polygon_vertices = 8;
  b2_aabb_extension = 0.1;
  b2_aabb_multiplier = 2.0;
  b2_linear_slop = 0.005;
  b2_angular_slop = (2.0 / 180.0 * b2_pi);
  b2_polygon_radius = (2.0 * b2_linear_slop);
  b2_max_sub_steps = 8;

  b2_max_toi_contacts = 32;
  b2_velocity_threshold = 1.0;
  b2_max_linear_correction = 0.2;
  b2_max_angular_correction = (8.0 / 180.0 * b2_pi);
  b2_max_translation = 2.0;
  b2_max_translation_squared = (b2_max_translation * b2_max_translation);
  b2_max_rotation = (0.5 * b2_pi);
  b2_max_rotation_squared = (b2_max_rotation * b2_max_rotation);
  b2_baumgarte = 0.2;
  b2_toi_baugarte = 0.75;
  b2_min_pulley_length = 2.0;

  b2_time_to_sleep = 0.5;
  b2_linear_sleep_tolerance = 0.01;
  b2_angular_sleep_tolerance = (2.0 / 180.0 * b2_pi);

  b2_chunk_size = 16 * 1024;
  b2_max_block_size = 640;
  b2_block_sizes = 14;
  b2_chunk_array_increment = 128;

  b2_stack_size = 100 * 1024;
  b2_max_stack_entries = 32;

  b2_null_feature = $ff;
  b2_null_node = -1;
  b2_null_proxy = -1;

type
  tb2_version = record
    major: tb2_int32;
    minor: tb2_int32;
    revision: tb2_int32;
  end;

  pb2_vec2 = ^tb2_vec2;
  tb2_vec2 = object
  private
    function get_arr(const index: tb2_int32): tb2_float32; inline;
    procedure set_arr(const index: tb2_int32; const value: tb2_float32); inline;
  public
    var x, y: tb2_float32;
    property arr[const index: tb2_int32]: tb2_float32 read get_arr write set_arr; default;
    procedure set_value(const vx, vy: tb2_float32);
    procedure set_zero;
    function len: tb2_float32;
    function len_sq: tb2_float32;
    function normalize: tb2_float32;
    function is_valid: boolean;
    function skew: tb2_vec2;
  end;
  tb2_vec2_arr = array[word] of tb2_vec2;
  pb2_vec2_arr = ^tb2_vec2_arr;

  pb2_vec3 = ^tb2_vec3;
  tb2_vec3 = object
  private
    function get_arr(const index: tb2_int32): tb2_float32; inline;
    procedure set_arr(const index: tb2_int32; const value: tb2_float32); inline;
  public
    var x, y, z: tb2_float32;
    property arr[const index: tb2_int32]: tb2_float32 read get_arr write set_arr; default;
    procedure set_value(const vx, vy, vz: tb2_float32);
    procedure set_zero;
  end;

  pb2_mat22 = ^tb2_mat22;
  tb2_mat22 = object
  private
    function get_arr(const index: tb2_int32): tb2_float32; inline;
    procedure set_arr(const index: tb2_int32; const value: tb2_float32); inline;
  public
    var ex, ey: tb2_vec2;
    property arr[const index: tb2_int32]: tb2_float32 read get_arr write set_arr; default;
    procedure set_value(const vc0, vc1: tb2_vec2); overload;
    procedure set_value(const ve00, ve01, ve10, ve11: tb2_float32); overload;
    procedure set_identity;
    procedure set_zero;
    function get_inverse: tb2_mat22;
    function solve(const v: tb2_vec2): tb2_vec2;
  end;

  pb2_mat33 = ^tb2_mat33;
  tb2_mat33 = object
  private
    function get_arr(const index: tb2_int32): tb2_float32; inline;
    procedure set_arr(const index: tb2_int32; const value: tb2_float32); inline;
  public
    var ex, ey, ez: tb2_vec3;
    property arr[const index: tb2_int32]: tb2_float32 read get_arr write set_arr; default;
    procedure set_value(const vc0, vc1, vc2: tb2_vec3);
    procedure set_identity;
    procedure set_zero;
    function solve33(const v: tb2_vec3): tb2_vec3;
    function solve22(const v: tb2_vec2): tb2_vec2;
    procedure get_inverse22(const m: pb2_mat33);
    procedure get_sym_inverse33(const m: pb2_mat33);
  end;

  pb2_rot = ^tb2_rot;
  tb2_rot = object
  public
    var s, c: tb2_float32;
    procedure set_value(const angle: tb2_float32);
    procedure set_value(const vs, vc: tb2_float32);
    procedure set_identity;
    function get_angle: tb2_float32;
    function get_x_axis: tb2_vec2;
    function get_y_axis: tb2_vec2;
  end;

  pb2_transform = ^tb2_transform;
  tb2_transform = object
  public
    var p: tb2_vec2;
    var q: tb2_rot;
    procedure set_value(const position: tb2_vec2; const rotation: tb2_rot);
    procedure set_value(const position: tb2_vec2; const angle: tb2_float32);
    procedure set_identity;
  end;

  tb2_sweep = object
  public
    var local_center: tb2_vec2;
    var c0, c: tb2_vec2;
    var a0, a: tb2_float32;
    var alpha0: tb2_float32;
    procedure get_transform(const xf: pb2_transform; const beta: tb2_float32);
    procedure advance(const alpha: tb2_float32);
    procedure normalize;
  end;

  tb2_color = object
  public
    var r, g, b, a: tb2_float32;
    procedure set_value(const vr, vg, vb: tb2_float32; const va: tb2_float32 = 1.0); inline;
  end;

  tb2_draw_flag = (
    b2_df_shape,
    b2_df_joint,
    b2_df_aabb,
    b2_df_pair,
    b2_df_center_of_mass
  );
  tb2_draw_flag_set = set of tb2_draw_flag;

  tb2_draw = class
  protected
    var _draw_flags: tb2_draw_flag_set;
  public
    property draw_flags: tb2_draw_flag_set read _draw_flags write _draw_flags;
    constructor create; virtual;
    destructor destroy; override;
    procedure draw_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color); virtual; abstract;
    procedure draw_solid_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color); virtual; abstract;
    procedure draw_circle(const center: tb2_vec2; const radius: tb2_float32; const color: tb2_color); virtual; abstract;
    procedure draw_solid_circle(const center: tb2_vec2; const radius: tb2_float32; const axis: tb2_vec2; const color: tb2_color); virtual; abstract;
    procedure draw_segment(const p0, p1: tb2_vec2; const color: tb2_color); virtual; abstract;
    procedure draw_transform(const xf: tb2_transform); virtual; abstract;
  end;

  generic tb2_growable_stack<T> = object
  private
    type t_arr = array[word] of T;
    type pt_arr = ^t_arr;
    var _stack: pt_arr;
    var _array: array [0..255] of T;
    var _count: tb2_int32;
    var _capacity: tb2_int32;
  public
    constructor create;
    destructor destroy;
    procedure push(const element: T);
    function pop: T;
    function get_count: tb2_int32;
  end;

  tb2_growable_stack_int = specialize tb2_growable_stack<tb2_int32>;

  pb2_block = ^tb2_block;
  tb2_block = record
    next: pb2_block;
  end;

  pb2_chunk = ^tb2_chunk;
  tb2_chunk = record
    block_size: tb2_int32;
    blocks: pb2_block;
  end;
  tb2_chunk_arr = array[word] of tb2_chunk;
  pb2_chunk_arr = ^tb2_chunk_arr;

  pb2_block_allocator = ^tb2_block_allocator;
  tb2_block_allocator = object
  private
    const _block_sizes: array [0 .. b2_block_sizes - 1] of tb2_int32 = (
      16, 32, 64, 96, 128, 160, 192, 224, 256, 320, 384, 448, 512, 640
    );
    var _chunks: pb2_chunk_arr;
    var _chunk_count: tb2_int32;
    var _chunk_space: tb2_int32;
    var _free_lists: array [0..b2_block_sizes - 1] of pb2_block;
    class var _block_size_lookup: array [0..b2_max_block_size] of tb2_uint8;
    class var _block_size_lookup_initialized: boolean;
  public
    constructor create;
    destructor destroy;
    function alloc(const size: tb2_int32): tb2_ptr;
    procedure free(var p: tb2_ptr; const size: tb2_int32);
    procedure clear;
  end;

  pb2_stack_entry = ^tb2_stack_entry;
  tb2_stack_entry = record
    data: pb2_uint8_arr;
    size: tb2_int32;
    used_malloc: boolean;
  end;

  pb2_stack_allocator = ^tb2_stack_allocator;
  tb2_stack_allocator = object
  private
    var _data: array [0..b2_stack_size - 1] of tb2_int8;
    var _index: tb2_int32;
    var _allocation: tb2_int32;
    var _max_allocation: tb2_int32;
    var _entries: array [0..b2_max_stack_entries - 1] of tb2_stack_entry;
    var _entry_count: tb2_int32;
  public
    constructor create;
    destructor destroy;
    function alloc(const size: tb2_int32): tb2_ptr;
    procedure free(var p: tb2_ptr);
    function get_max_allocation: tb2_int32; inline;
  end;

  tb2_timer = object
  private
  {$if defined(WIN32)}
    var _start: tb2_float64;
    var _inv_frequency: tb2_float64;
  {$elseif defined(UNIX)}
    var _start_sec: tb2_uint32;
    var _start_usec: tb2_uint32;
  {$endif}
  public
    constructor create;
    procedure reset;
    function get_milliseconds: tb2_float32;
  end;

  pb2_mass_data = ^tb2_mass_data;
  tb2_mass_data = record
    mass: tb2_float32;
    center: tb2_vec2;
    inertia: tb2_float32;
  end;

  tb2_contact_feature_type = (
    b2_cft_vertex = 0,
    b2_cft_face = 1
  );

  pb2_contact_feature = ^tb2_contact_feature;
  tb2_contact_feature = packed object
  public
    var index_a: tb2_uint8;
    var index_b: tb2_uint8;
    var type_a: tb2_uint8;
    var type_b: tb2_uint8;
  end;

  tb2_contact_id = packed record
    case byte of
    0: (cf: tb2_contact_feature);
    1: (key: tb2_uint32);
  end;

  pb2_manifold_point = ^tb2_manifold_point;
  tb2_manifold_point = record
    local_point: tb2_vec2;
    normal_impulse: tb2_float32;
    tangent_impulse: tb2_float32;
    id: tb2_contact_id;
  end;

  tb2_manifold_type = (
    b2_mt_circles,
    b2_mt_face_a,
    b2_mt_face_b
  );

  pb2_manifold = ^tb2_manifold;
  tb2_manifold = object
  public
    var points: array [0..b2_max_manifold_points - 1] of tb2_manifold_point;
    var local_normal: tb2_vec2;
    var local_point: tb2_vec2;
    var manifold_type: tb2_manifold_type;
    var point_count: tb2_int32;
  end;

  pb2_world_manifold = ^tb2_world_manifold;
  tb2_world_manifold = object
  public
    var normal: tb2_vec2;
    var points: array [0..b2_max_manifold_points - 1] of tb2_vec2;
    var separations: array [0..b2_max_manifold_points - 1] of tb2_float32;
    procedure initialize(
      const manifold: pb2_manifold;
      const xf_a: tb2_transform; const radius_a: tb2_float32;
      const xf_b: tb2_transform; const radius_b: tb2_float32
    );
  end;

  tb2_point_state = (
    b2_null_state,
    b2_add_state,
    b2_persist_state,
    b2_remove_state
  );

  pb2_clip_vertex = ^tb2_clip_vertex;
  tb2_clip_vertex = record
    v: tb2_vec2;
    id: tb2_contact_id;
  end;
  tb2_clip_vertex_arr = array[word] of tb2_clip_vertex;
  pb2_clip_vertex_arr = ^tb2_clip_vertex_arr;

  pb2_ray_cast_input = ^tb2_ray_cast_input;
  tb2_ray_cast_input = record
    p1, p2: tb2_vec2;
    max_fraction: tb2_float32;
  end;

  pb2_ray_cast_output = ^tb2_ray_cast_output;
  tb2_ray_cast_output = record
    normal: tb2_vec2;
    fraction: tb2_float32;
  end;

  pb2_aabb = ^tb2_aabb;
  tb2_aabb = object
  public
    var lower_bound: tb2_vec2;
    var upper_bound: tb2_vec2;
    function is_valid: boolean;
    function get_center: tb2_vec2;
    function get_extents: tb2_vec2;
    function get_perimeter: tb2_float32;
    procedure combine(const aabb: tb2_aabb);
    procedure combine(const aabb1, aabb2: tb2_aabb);
    function contains(const aabb: tb2_aabb): boolean;
    function ray_cast(var output: tb2_ray_cast_output; const input: tb2_ray_cast_input): boolean;
  end;

  pb2_shape = ^tb2_shape;
  pb2_circle_shape = ^tb2_circle_shape;
  pb2_edge_shape = ^tb2_edge_shape;
  pb2_chain_shape = ^tb2_chain_shape;
  pb2_polygon_shape = ^tb2_polygon_shape;

  pb2_distance_proxy = ^tb2_distance_proxy;
  tb2_distance_proxy = object
  public
    var buffer: array [0..1] of tb2_vec2;
    var vertices: pb2_vec2_arr;
    var count: tb2_int32;
    var radius: tb2_float32;
    constructor create;
    destructor destroy;
    procedure set_shape(const shape: pb2_shape; const index: tb2_int32);
    function get_support(const d: tb2_vec2): tb2_int32; inline;
    function get_support_vertex(const d: tb2_vec2): tb2_vec2; inline;
    function get_vertex_count: tb2_int32; inline;
    function get_vertex(const index: tb2_int32): tb2_vec2; inline;
  end;

  pb2_simplex_cache = ^tb2_simplex_cache;
  tb2_simplex_cache = record
    metric: tb2_float32;
    count: tb2_uint16;
    index_a: array [0..2] of uint8;
    index_b: array [0..2] of uint8;
  end;

  pb2_simplex_vertex = ^tb2_simplex_vertex;
  tb2_simplex_vertex = record
    w_a: tb2_vec2;
    w_b: tb2_vec2;
    w: tb2_vec2;
    a: tb2_float32;
    index_a: tb2_int32;
    index_b: tb2_int32;
  end;
  tb2_simplex_vertex_arr = array[word] of tb2_simplex_vertex;
  pb2_simplex_vertex_arr = ^tb2_simplex_vertex_arr;

  tb2_simplex = object
  public
    var v1, v2, v3: tb2_simplex_vertex;
    var count: tb2_int32;
    procedure read_cache(
      const cache: pb2_simplex_cache;
      const proxy_a: pb2_distance_proxy; const xf_a: tb2_transform;
      const proxy_b: pb2_distance_proxy; const xf_b: tb2_transform
    );
    procedure write_cache(const cache: pb2_simplex_cache);
    function get_search_direction: tb2_vec2;
    function get_closest_point: tb2_vec2;
    procedure get_witness_points(const p_a, p_b: pb2_vec2);
    function get_metric: tb2_float32;
    procedure solve2;
    procedure solve3;
  end;

  pb2_distance_input = ^tb2_distance_input;
  tb2_distance_input = object
  public
    var proxy_a: tb2_distance_proxy;
    var proxy_b: tb2_distance_proxy;
    var transform_a: tb2_transform;
    var transform_b: tb2_transform;
    var use_radii: boolean;
    constructor create;
    destructor destroy;
  end;

  pb2_distance_output = ^tb2_distance_output;
  tb2_distance_output = object
  public
    var point_a: tb2_vec2;
    var point_b: tb2_vec2;
    var distance: tb2_float32;
    var iterations: tb2_int32;
  end;

  tb2_shape_type = (
    b2_st_circle,
    b2_st_edge,
    b2_st_polygon,
    b2_st_chain,
    b2_st_type_count
  );

  tb2_shape = object
  public
    var shape_type: tb2_shape_type;
    var radius: tb2_float32;
    constructor create_shape;
    destructor destroy; virtual;
    function clone(const allocator: pb2_block_allocator): pb2_shape; virtual; abstract;
    function get_type: tb2_shape_type; inline;
    function get_child_count: tb2_int32; virtual; abstract;
    function test_point(const xf: tb2_transform; const p: tb2_vec2): boolean; virtual; abstract;
    function ray_cast(
      var output: tb2_ray_cast_output; const input: tb2_ray_cast_input;
      const xf: tb2_transform; const child_index: tb2_int32
    ): boolean; virtual; abstract;
    procedure compute_aabb(var aabb: tb2_aabb; const xf: tb2_transform; const child_index: tb2_int32); virtual; abstract;
    procedure compute_mass(var mass_data: tb2_mass_data; const density: tb2_float32); virtual; abstract;
  end;

  tb2_circle_shape = object (tb2_shape)
  public
    var center: tb2_vec2;
    constructor create;
    function clone(const allocator: pb2_block_allocator): pb2_shape; virtual;
    function get_child_count: tb2_int32; virtual;
    function test_point(const xf: tb2_transform; const p: tb2_vec2): boolean; virtual;
    function ray_cast(
      var output: tb2_ray_cast_output; const input: tb2_ray_cast_input;
      const xf: tb2_transform; const child_index: tb2_int32
    ): boolean; virtual;
    procedure compute_aabb(var aabb: tb2_aabb; const xf: tb2_transform; const child_index: tb2_int32); virtual;
    procedure compute_mass(var mass_data: tb2_mass_data; const density: tb2_float32); virtual;
    function get_support(const d: tb2_vec2): tb2_int32;
    function get_support_vertex(const d: tb2_vec2): tb2_vec2;
    function get_vertex_count: tb2_int32; inline;
    function get_vertex(const index: tb2_int32): tb2_vec2;
  end;

  tb2_edge_shape = object (tb2_shape)
  public
    var vertex1, vertex2: tb2_vec2;
    var vertex0, vertex3: tb2_vec2;
    var has_vertex0, has_vertex3: boolean;
    constructor create;
    procedure set_edge(const v1, v2: tb2_vec2);
    function clone(const allocator: pb2_block_allocator): pb2_shape; virtual;
    function get_child_count: tb2_int32; virtual;
    function test_point(const xf: tb2_transform; const p: tb2_vec2): boolean; virtual;
    function ray_cast(
      var output: tb2_ray_cast_output; const input: tb2_ray_cast_input;
      const xf: tb2_transform; const child_index: tb2_int32
    ): boolean; virtual;
    procedure compute_aabb(var aabb: tb2_aabb; const xf: tb2_transform; const child_index: tb2_int32); virtual;
    procedure compute_mass(var mass_data: tb2_mass_data; const density: tb2_float32); virtual;
  end;

  tb2_chain_shape = object (tb2_shape)
  public
    var vertices: pb2_vec2_arr;
    var count: tb2_int32;
    var prev_vertex, next_vertex: tb2_vec2;
    var has_prev_vertex, has_next_vertex: boolean;
    constructor create;
    destructor destroy; virtual;
    procedure clear;
    procedure set_loop(const new_vertices: pb2_vec2_arr; const vcount: tb2_int32);
    procedure set_chain(const new_vertices: pb2_vec2_arr; const vcount: tb2_int32);
    procedure set_prev_vertex(const new_prev_vertex: tb2_vec2);
    procedure set_next_vertex(const new_next_vertex: tb2_vec2);
    function clone(const allocator: pb2_block_allocator): pb2_shape; virtual;
    function get_child_count: tb2_int32; virtual;
    procedure get_child_edge(const edge: pb2_edge_shape; const index: tb2_int32);
    function test_point(const xf: tb2_transform; const p: tb2_vec2): boolean; virtual;
    function ray_cast(
      var output: tb2_ray_cast_output; const input: tb2_ray_cast_input;
      const xf: tb2_transform; const child_index: tb2_int32
    ): boolean; virtual;
    procedure compute_aabb(var aabb: tb2_aabb; const xf: tb2_transform; const child_index: tb2_int32); virtual;
    procedure compute_mass(var mass_data: tb2_mass_data; const density: tb2_float32); virtual;
  end;

  tb2_polygon_shape = object (tb2_shape)
  private
    function compute_centroid(const vs: pb2_vec2_arr; const count: tb2_int32): tb2_vec2; static;
  public
    var centroid: tb2_vec2;
    var vertices: array [0..b2_max_polygon_vertices - 1] of tb2_vec2;
    var normals: array [0..b2_max_polygon_vertices - 1] of tb2_vec2;
    var count: tb2_int32;
    constructor create;
    function clone(const allocator: pb2_block_allocator): pb2_shape; virtual;
    function get_child_count: tb2_int32; virtual;
    procedure set_polygon(const points: pb2_vec2_arr; const vcount: tb2_int32);
    procedure set_as_box(const hx, hy: tb2_float32);
    procedure set_as_box(const hx, hy: tb2_float32; const center: tb2_vec2; const angle: tb2_float32);
    function test_point(const xf: tb2_transform; const p: tb2_vec2): boolean; virtual;
    function ray_cast(
      var output: tb2_ray_cast_output; const input: tb2_ray_cast_input;
      const xf: tb2_transform; const child_index: tb2_int32
    ): boolean; virtual;
    procedure compute_aabb(var aabb: tb2_aabb; const xf: tb2_transform; const child_index: tb2_int32); virtual;
    procedure compute_mass(var mass_data: tb2_mass_data; const density: tb2_float32); virtual;
    function get_vertex_count: tb2_int32; inline;
    function get_vertex(const index: tb2_int32): tb2_vec2; inline;
    function validate: boolean;
  end;

  pb2_tree_node = ^tb2_tree_node;
  tb2_tree_node = object
  public
    var aabb: tb2_aabb;
    var user_data: tb2_ptr;
    var union: record
      case byte of
      0: (parent: tb2_int32);
      1: (next: tb2_int32);
    end;
    var child1: tb2_int32;
    var child2: tb2_int32;
    var height: tb2_int32;
    function is_leaf: boolean; inline;
  end;
  tb2_tree_node_arr = array[word] of tb2_tree_node;
  pb2_tree_node_arr = ^tb2_tree_node_arr;

  tb2_query_callback = function (const node_id: tb2_int32): boolean of object;
  tb2_ray_cast_callback = function (const input: tb2_ray_cast_input; const node_id: tb2_int32): tb2_float32 of object;
  tb2_add_pair_callback = procedure (const user_data_a, user_data_b: tb2_ptr) of object;

  tb2_dynamic_tree = object
  private
    var _root: tb2_int32;
    var _nodes: pb2_tree_node_arr;
    var _node_count: tb2_int32;
    var _node_capacity: tb2_int32;
    var _free_list: tb2_int32;
    var _path: tb2_uint32;
    var _insertion_count: tb2_int32;
    function allocate_node: tb2_int32;
    procedure free_node(const node_id: tb2_int32);
    procedure insert_leaf(const node_id: tb2_int32);
    procedure remove_leaf(const node_id: tb2_int32);
    function balance(const index: tb2_int32): tb2_int32;
    function compute_height: tb2_int32; overload;
    function compute_height(const node_id: tb2_int32): tb2_int32; overload;
    procedure validate_structure(const index: tb2_int32);
    procedure validate_metrics(const index: tb2_int32);
  public
    constructor create;
    destructor destroy;
    function create_proxy(const aabb: tb2_aabb; const user_data: tb2_ptr): tb2_int32;
    procedure destroy_proxy(const proxy_id: tb2_int32);
    function move_proxy(const proxy_id: tb2_int32; const aabb: tb2_aabb; const displacement: tb2_vec2): boolean;
    function get_user_data(const proxy_id: tb2_int32): tb2_ptr;
    function get_fat_aabb(const proxy_id: tb2_int32): tb2_aabb;
    procedure query(const callback: tb2_query_callback; const aabb: tb2_aabb);
    procedure ray_cast(const callback: tb2_ray_cast_callback; const input: tb2_ray_cast_input);
    procedure validate;
    function get_height: tb2_int32;
    function get_max_balance: tb2_int32;
    function get_area_ratio: tb2_float32;
    procedure rebuild_bottom_up;
    procedure shift_origin(const new_origin: tb2_vec2);
  end;

  pb2_pair = ^tb2_pair;
  tb2_pair = record
    proxy_id_a: tb2_int32;
    proxy_id_b: tb2_int32;
  end;
  tb2_pair_arr = array [word] of tb2_pair;
  pb2_pair_arr = ^tb2_pair_arr;

  pb2_broad_phase = ^tb2_broad_phase;
  tb2_broad_phase = object
  private
    var _tree: tb2_dynamic_tree;
    var _proxy_count: tb2_int32;
    var _move_buffer: pb2_int32_arr;
    var _move_capacity: tb2_int32;
    var _move_count: tb2_int32;
    var _pair_buffer: pb2_pair_arr;
    var _pair_capacity: tb2_int32;
    var _pair_count: tb2_int32;
    var _query_proxy_id: tb2_int32;
    procedure buffer_move(const proxy_id: tb2_int32);
    procedure un_buffer_move(const proxy_id: tb2_int32);
    function query_callback(const proxy_id: tb2_int32): boolean;
    function pair_less_than(const pair1, pair2: tb2_pair): boolean; inline;
  public
    constructor create;
    destructor destroy;
    function create_proxy(const aabb: tb2_aabb; const user_data: tb2_ptr): tb2_int32;
    procedure destroy_proxy(const proxy_id: tb2_int32);
    procedure move_proxy(const proxy_id: tb2_int32; const aabb: tb2_aabb; const displacement: tb2_vec2);
    procedure touch_proxy(const proxy_id: tb2_int32);
    function get_fat_aabb(const proxy_id: tb2_int32): tb2_aabb; inline;
    function get_user_data(const proxy_id: tb2_int32): tb2_ptr; inline;
    function test_overlap(const proxy_id_a, proxy_id_b: tb2_int32): boolean; inline;
    function get_proxy_count: tb2_int32; inline;
    procedure update_pairs(const callback: tb2_add_pair_callback);
    procedure query(const callback: tb2_query_callback; const aabb: tb2_aabb); inline;
    procedure ray_cast(const callback: tb2_ray_cast_callback; const input: tb2_ray_cast_input); inline;
    function get_tree_height: tb2_int32; inline;
    function get_tree_balance: tb2_int32; inline;
    function get_tree_quality: tb2_float32;
    procedure shift_origin(const new_origin: tb2_vec2); inline;
  end;

  tb2_toi_input = record
    proxy_a: tb2_distance_proxy;
    proxy_b: tb2_distance_proxy;
    sweep_a: tb2_sweep;
    sweep_b: tb2_sweep;
    t_max: tb2_float32;
  end;

  tb2_toi_state = (
    b2_tois_unknown,
    b2_tois_failed,
    b2_tois_overlapped,
    b2_tois_touching,
    b2_tois_separated
  );

  tb2_toi_output = record
    state: tb2_toi_state;
    t: tb2_float32;
  end;

  tb2_separation_function_type = (
    b2_sft_points,
    b2_sft_face_a,
    b2_sft_face_b
  );

  tb2_separation_function = object
  public
    var proxy_a: pb2_distance_proxy;
    var proxy_b: pb2_distance_proxy;
    var sweep_a, sweep_b: tb2_sweep;
    var separation_type: tb2_separation_function_type;
    var local_point: tb2_vec2;
    var axis: tb2_vec2;
    function initialize(
      const cache: pb2_simplex_cache;
      const new_proxy_a: pb2_distance_proxy; const new_sweep_a: tb2_sweep;
      const new_proxy_b: pb2_distance_proxy; const new_sweep_b: tb2_sweep;
      const t1: tb2_float32
    ): tb2_float32;
    function find_min_separation(const index_a, index_b: pb2_int32; const t: tb2_float32): tb2_float32;
    function evaluate(const index_a, index_b: tb2_int32; const t: tb2_float32): tb2_float32;
  end;

  tb2_body_type = (
    b2_static_body,
    b2_kinematic_body,
    b2_dynamic_body
  );

  tb2_body_def = record
    body_type: tb2_body_type;
    position: tb2_vec2;
    angle: tb2_float32;
    linear_velocity: tb2_vec2;
    angular_velocity: tb2_float32;
    linear_damping: tb2_float32;
    angular_damping: tb2_float32;
    allow_sleep: boolean;
    awake: boolean;
    fixed_rotation: boolean;
    bullet: boolean;
    active: boolean;
    user_data: tb2_ptr;
    gravity_scale: tb2_float32;
  end;

  tb2_body_flag = (
    b2_bf_island_flag,
    b2_bf_awake_flag,
    b2_bf_auto_sleep_flag,
    b2_bf_bullet_flag,
    b2_bf_fixed_rotation_flag,
    b2_bf_active_flag,
    b2_bf_toi_flag
  );
  tb2_body_flag_set = set of tb2_body_flag;

  tb2_filter = record
    category_bits: tb2_uint16;
    mask_bits: tb2_uint16;
    group_index: tb2_int16;
  end;

  tb2_fixture_def = record
    shape: pb2_shape;
    user_data: tb2_ptr;
    friction: tb2_float32;
    restitution: tb2_float32;
    density: tb2_float32;
    is_sensor: boolean;
    filter: tb2_filter;
  end;

  pb2_world = ^tb2_world;
  pb2_fixture = ^tb2_fixture;
  ppb2_fixture = ^pb2_fixture;
  pb2_fixture_arr = ^tb2_fixture_arr;
  pb2_joint_edge = ^tb2_joint_edge;
  pb2_contact_edge = ^tb2_contact_edge;

  pb2_body = ^tb2_body;
  tb2_body = object
  private
    var _type: tb2_body_type;
    var _flags: tb2_body_flag_set;
    var _island_index: tb2_int32;
    var _xf: tb2_transform;
    var _sweep: tb2_sweep;
    var _linear_velocity: tb2_vec2;
    var _angular_velocity: tb2_float32;
    var _force: tb2_vec2;
    var _torque: tb2_float32;
    var _world: pb2_world;
    var _prev: pb2_body;
    var _next: pb2_body;
    var _fixture_list: pb2_fixture;
    var _fixture_count: tb2_int32;
    var _joint_list: pb2_joint_edge;
    var _contact_list: pb2_contact_edge;
    var _mass, _rcp_mass: tb2_float32;
    var _inertia, _rcp_inertia: tb2_float32;
    var _linear_damping: tb2_float32;
    var _angular_damping: tb2_float32;
    var _gravity_scale: tb2_float32;
    var _sleep_time: tb2_float32;
    var _user_data: tb2_ptr;
    procedure synchronize_fixtures;
    procedure synchronize_transform; inline;
    function should_collide(const other: pb2_body): boolean;
    procedure advance(const t: tb2_float32);
  public
    constructor create(const def: tb2_body_def; const world: pb2_world);
    destructor destroy;
    function create_fixture(const def: tb2_fixture_def): pb2_fixture;
    function create_fixture(const shape: pb2_shape; const density: tb2_float32): pb2_fixture;
    procedure destroy_fixture(var fixture: pb2_fixture);
    procedure set_transform(const position: tb2_vec2; const angle: tb2_float32); overload;
    procedure set_transform(const xf: tb2_transform); overload;
    function get_transform: tb2_transform; inline;
    function get_position: tb2_vec2; inline;
    function get_angle: tb2_float32; inline;
    function get_world_center: tb2_vec2; inline;
    function get_local_center: tb2_vec2; inline;
    procedure set_linear_velocity(const v: tb2_vec2); inline;
    function get_linear_velocity: tb2_vec2; inline;
    procedure set_angular_velocity(const w: tb2_float32); inline;
    function get_angular_velocity: tb2_float32; inline;
    procedure apply_force(const force: tb2_vec2; const point: tb2_vec2; const wake: boolean); inline;
    procedure apply_force_to_center(const force: tb2_vec2; const wake: boolean); inline;
    procedure apply_torque(const torque: tb2_float32; const wake: boolean); inline;
    procedure apply_linear_impulse(const impulse: tb2_vec2; const point: tb2_vec2; const wake: boolean); inline;
    procedure apply_angular_impulse(const impulse: tb2_float32; const wake: boolean); inline;
    function get_mass: tb2_float32; inline;
    function get_inertia: tb2_float32; inline;
    procedure get_mass_data(var data: tb2_mass_data); inline;
    procedure set_mass_data(const data: tb2_mass_data);
    procedure reset_mass_data;
    function get_world_point(const local_point: tb2_vec2): tb2_vec2; inline;
    function get_world_vector(const local_vector: tb2_vec2): tb2_vec2; inline;
    function get_local_point(const world_point: tb2_vec2): tb2_vec2; inline;
    function get_local_vector(const world_vector: tb2_vec2): tb2_vec2; inline;
    function get_linear_velocity_from_world_point(const world_point: tb2_vec2): tb2_vec2; inline;
    function get_linear_velocity_from_local_point(const local_point: tb2_vec2): tb2_vec2; inline;
    function get_linear_damping: tb2_float32; inline;
    procedure set_linear_damping(const linear_damping: tb2_float32); inline;
    function get_angular_damping: tb2_float32; inline;
    procedure set_angular_damping(const angular_damping: tb2_float32); inline;
    function get_gravity_scale: tb2_float32; inline;
    procedure set_gravity_scale(const scale: tb2_float32); inline;
    procedure set_type(const new_type: tb2_body_type);
    function get_type: tb2_body_type; inline;
    procedure set_bullet(const flag: boolean); inline;
    function is_bullet: boolean; inline;
    procedure set_sleeping_allowed(const flag: boolean); inline;
    function is_sleeping_allowed: boolean; inline;
    procedure set_awake(const flag: boolean); inline;
    function is_awake: boolean; inline;
    procedure set_active(const flag: boolean);
    function is_active: boolean; inline;
    procedure set_fixed_rotation(const flag: boolean);
    function is_fixed_rotation: boolean; inline;
    function get_fixture_list: pb2_fixture; inline;
    function get_joint_list: pb2_joint_edge; inline;
    function get_contact_list: pb2_contact_edge; inline;
    function get_next: pb2_body; inline;
    function get_user_data: tb2_ptr; inline;
    procedure set_user_data(const data: tb2_ptr); inline;
    function get_world: pb2_world; inline;
    procedure dump;
  end;
  tb2_body_arr = array[word] of tb2_body;
  pb2_body_arr = ^tb2_body_arr;
  tpb2_body_arr = array[word] of pb2_body;
  ppb2_body_arr = ^tpb2_body_arr;

  pb2_fixture_proxy = ^tb2_fixture_proxy;
  tb2_fixture_proxy = record
    aabb: tb2_aabb;
    fixture: pb2_fixture;
    child_index: tb2_int32;
    proxy_id: tb2_int32;
  end;
  tb2_fixture_proxy_arr = array[word] of tb2_fixture_proxy;
  pb2_fixture_proxy_arr = ^tb2_fixture_proxy_arr;

  tb2_fixture = object
  protected
    var _density: tb2_float32;
    var _next: pb2_fixture;
    var _body: pb2_body;
    var _shape: pb2_shape;
    var _friction: tb2_float32;
    var _restitution: tb2_float32;
    var _proxies: pb2_fixture_proxy_arr;
    var _proxy_count: tb2_int32;
    var _filter: tb2_filter;
    var _is_sensor: boolean;
    var _user_data: tb2_ptr;
    procedure create_fixture(const allocator: pb2_block_allocator; const body: pb2_body; const def: tb2_fixture_def);
    procedure destroy_fixture(const allocator: pb2_block_allocator);
    procedure create_proxies(const broad_phase: pb2_broad_phase; const xf: tb2_transform);
    procedure destroy_proxies(const broad_phase: pb2_broad_phase);
    procedure synchronize(const broad_phase: pb2_broad_phase; const xf1, xf2: tb2_transform);
  public
    constructor create;
    function get_type: tb2_shape_type; inline;
    function get_shape: pb2_shape; inline;
    procedure set_sensor(const sensor: boolean);
    function is_sensor: boolean; inline;
    procedure set_filter_data(const filter: tb2_filter);
    function get_filter_data: tb2_filter; inline;
    procedure refilter;
    function get_body: pb2_body; inline;
    function get_next: pb2_fixture; inline;
    function get_user_data: tb2_ptr; inline;
    procedure set_user_data(const data: tb2_ptr); inline;
    function test_point(const p: tb2_vec2): boolean; inline;
    function ray_cast(var output: tb2_ray_cast_output; const input: tb2_ray_cast_input; const child_index: tb2_int32): boolean; inline;
    procedure get_mass_data(var mass_data: tb2_mass_data); inline;
    function get_density: tb2_float32; inline;
    procedure set_density(const density: tb2_float32); inline;
    function get_friction: tb2_float32; inline;
    procedure set_friction(const friction: tb2_float32); inline;
    function get_restitution: tb2_float32; inline;
    procedure set_restitution(const restitution: tb2_float32); inline;
    function get_aabb(const child_index: tb2_int32): tb2_aabb; inline;
    procedure dump(const body_index: tb2_int32);
  end;
  tb2_fixture_arr = array[word] of tb2_fixture;

  pb2_contact = ^tb2_contact;

  tb2_contact_create_fcn = function (
    const fixture_a: pb2_fixture; const index_a: tb2_int32;
    const fixture_b: pb2_fixture; const index_b: tb2_int32;
    const allocator: pb2_block_allocator
  ): pb2_contact;
  tb2_contact_destroy_fcn = procedure(var contact: pb2_contact; const allocator: pb2_block_allocator);

  tb2_contact_register = record
    create_fcn: tb2_contact_create_fcn;
    destroy_fcn: tb2_contact_destroy_fcn;
    primary: boolean;
  end;

  tb2_contact_edge = record
    other: pb2_body;
    contact: pb2_contact;
    prev: pb2_contact_edge;
    next: pb2_contact_edge;
  end;

  tb2_contact_flag = (
    b2_cf_island_flag,
    b2_cf_touching_flag,
    b2_cf_enabled_flag,
    b2_cf_filter_flag,
    b2_cf_bullet_hit_flag,
    b2_cf_toi_flag
  );
  tb2_contact_flag_set = set of tb2_contact_flag;

  tb2_contact_listener = class;

  tb2_contact = object
  protected
    var _flags: tb2_contact_flag_set;
    var _prev: pb2_contact;
    var _next: pb2_contact;
    var _node_a: tb2_contact_edge;
    var _node_b: tb2_contact_edge;
    var _fixture_a: pb2_fixture;
    var _fixture_b: pb2_fixture;
    var _index_a: tb2_int32;
    var _index_b: tb2_int32;
    var _manifold: tb2_manifold;
    var _toi_count: tb2_int32;
    var _toi: tb2_float32;
    var _friction: tb2_float32;
    var _restitution: tb2_float32;
    var _tangent_speed: tb2_float32;
    procedure flag_for_filtering; inline;
    procedure add_type(
      const create_fcn: tb2_contact_create_fcn; const destroy_fcn: tb2_contact_destroy_fcn;
      const type_a, type_b: tb2_shape_type
    ); static;
    procedure initialize_registers; static;
    function create_contact(
      const fixture_a: pb2_fixture; const index_a: tb2_int32;
      const fixture_b: pb2_fixture; const index_b: tb2_int32;
      const allocator: pb2_block_allocator
    ): pb2_contact; static;
    procedure destroy_contact(var contact: pb2_contact; const allocator: pb2_block_allocator); static;
    procedure update(const listener: tb2_contact_listener);
  public
    constructor create;
    constructor create(const f_a: pb2_fixture; const index_a: tb2_int32; const f_b: pb2_fixture; const index_b: tb2_int32);
    destructor destroy; virtual;
    function get_manifold: pb2_manifold; inline;
    procedure get_world_manifold(var world_manifold: tb2_world_manifold); inline;
    function is_touching: boolean; inline;
    procedure set_enabled(const flag: boolean); inline;
    function is_enabled: boolean; inline;
    function get_next: pb2_contact; inline;
    function get_fixture_a: pb2_fixture; inline;
    function get_child_index_a: tb2_int32; inline;
    function get_fixture_b: pb2_fixture; inline;
    function get_child_index_b: tb2_int32; inline;
    procedure set_friction(const friction: tb2_float32); inline;
    function get_friction: tb2_float32; inline;
    procedure reset_friction; inline;
    procedure set_restitution(const restitution: tb2_float32); inline;
    function get_restitution: tb2_float32; inline;
    procedure reset_restitution; inline;
    procedure set_tangent_speed(const speed: tb2_float32); inline;
    function get_tangent_speed: tb2_float32; inline;
    procedure evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform); virtual; abstract;
  end;
  tb2_contact_arr = array[word] of tb2_contact;
  pb2_contact_arr = ^tb2_contact_arr;
  tpb2_contact_arr = array[word] of pb2_contact;
  ppb2_contact_arr = ^tpb2_contact_arr;

  pb2_circle_contact = ^tb2_circle_contact;
  tb2_circle_contact = object (tb2_contact)
  public
    constructor create_circle_contact(const fixture_a, fixture_b: pb2_fixture);
    procedure evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform); virtual;
  end;

  pb2_polygon_and_circle_contact = ^tb2_polygon_and_circle_contact;
  tb2_polygon_and_circle_contact = object (tb2_contact)
  public
    constructor create_polygon_and_circle_contact(const fixture_a, fixture_b: pb2_fixture);
    procedure evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform); virtual;
  end;

  pb2_polygon_contact = ^tb2_polygon_contact;
  tb2_polygon_contact = object (tb2_contact)
  public
    constructor create_polygon_contact(const fixture_a, fixture_b: pb2_fixture);
    procedure evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform); virtual;
  end;

  pb2_edge_and_circle_contact = ^tb2_edge_and_circle_contact;
  tb2_edge_and_circle_contact = object (tb2_contact)
  public
    constructor create_edge_and_circle_contact(const fixture_a, fixture_b: pb2_fixture);
    procedure evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform); virtual;
  end;

  pb2_edge_and_polygon_contact = ^tb2_edge_and_polygon_contact;
  tb2_edge_and_polygon_contact = object (tb2_contact)
  public
    constructor create_edge_and_polygon_contact(const fixture_a, fixture_b: pb2_fixture);
    procedure evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform); virtual;
  end;

  pb2_chain_and_circle_contact = ^tb2_chain_and_circle_contact;
  tb2_chain_and_circle_contact = object (tb2_contact)
  public
    constructor create_chain_and_circle_contact(
      const fixture_a: pb2_fixture; const index_a: tb2_int32;
      const fixture_b: pb2_fixture; const index_b: tb2_int32
    );
    procedure evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform); virtual;
  end;

  pb2_chain_and_polygon_contact = ^tb2_chain_and_polygon_contact;
  tb2_chain_and_polygon_contact = object (tb2_contact)
  public
    constructor create_chain_and_polygon_contact(
      const fixture_a: pb2_fixture; const index_a: tb2_int32;
      const fixture_b: pb2_fixture; const index_b: tb2_int32
    );
    procedure evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform); virtual;
  end;

  pb2_profile = ^tb2_profile;
  tb2_profile = record
    step: tb2_float32;
    collide: tb2_float32;
    solve: tb2_float32;
    solve_init: tb2_float32;
    solve_velocity: tb2_float32;
    solve_position: tb2_float32;
    broad_phase: tb2_float32;
    solve_toi: tb2_float32;
  end;

  tb2_time_step = record
    dt: tb2_float32;
    rcp_dt: tb2_float32;
    dt_ratio: tb2_float32;
    velocity_iterations: tb2_int32;
    position_iterations: tb2_int32;
    warm_starting: boolean;
  end;

  pb2_position = ^tb2_position;
  tb2_position = record
    c: tb2_vec2;
    a: tb2_float32;
  end;
  tb2_position_arr = array[word] of tb2_position;
  pb2_position_arr = ^tb2_position_arr;

  pb2_velocity = ^tb2_velocity;
  tb2_velocity = record
    v: tb2_vec2;
    w: tb2_float32;
  end;
  tb2_velocity_arr = array[word] of tb2_velocity;
  pb2_velocity_arr = ^tb2_velocity_arr;

  tb2_solver_data = record
    step: tb2_time_step;
    positions: pb2_position_arr;
    velocities: pb2_velocity_arr;
  end;

  pb2_contact_position_constraint = ^tb2_contact_position_constraint;
  tb2_contact_position_constraint = record
    local_points: array[0..b2_max_manifold_points] of tb2_vec2;
    local_normal: tb2_vec2;
    local_point: tb2_vec2;
    index_a: tb2_int32;
    index_b: tb2_int32;
    rcp_mass_a, rcp_mass_b: tb2_float32;
    local_center_a, local_center_b: tb2_vec2;
    rcp_inertia_a, rcp_inertia_b: tb2_float32;
    manifold_type: tb2_manifold_type;
    radius_a, radius_b: tb2_float32;
    point_count: tb2_int32;
  end;
  tb2_contact_position_constraint_arr = array[word] of tb2_contact_position_constraint;
  pb2_contact_position_constraint_arr = ^tb2_contact_position_constraint_arr;

  pb2_velocity_constraint_point = ^tb2_velocity_constraint_point;
  tb2_velocity_constraint_point = record
    r_a: tb2_vec2;
    r_b: tb2_vec2;
    normal_impulse: tb2_float32;
    tangent_impulse: tb2_float32;
    normal_mass: tb2_float32;
    tangent_mass: tb2_float32;
    velocity_bias: tb2_float32;
  end;

  pb2_contact_velocity_constraint = ^tb2_contact_velocity_constraint;
  tb2_contact_velocity_constraint = record
    points: array[0..b2_max_manifold_points - 1] of tb2_velocity_constraint_point;
    normal: tb2_vec2;
    normal_mass: tb2_mat22;
    k: tb2_mat22;
    index_a: tb2_int32;
    index_b: tb2_int32;
    rcp_mass_a, rcp_mass_b: tb2_float32;
    rcp_inertia_a, rcp_inertia_b: tb2_float32;
    friction: tb2_float32;
    restitution: tb2_float32;
    tangent_speed: tb2_float32;
    point_count: tb2_int32;
    contact_index: tb2_int32;
  end;
  tb2_contact_velocity_constraint_arr = array[word] of tb2_contact_velocity_constraint;
  pb2_contact_velocity_constraint_arr = ^tb2_contact_velocity_constraint_arr;

  pb2_contact_solver_def = ^tb2_contact_solver_def;
  tb2_contact_solver_def = record
    step: tb2_time_step;
    contacts: ppb2_contact_arr;
    count: tb2_int32;
    positions: pb2_position_arr;
    velocities: pb2_velocity_arr;
    allocator: pb2_stack_allocator;
  end;

  pb2_contact_solver = ^tb2_contact_solver;
  tb2_contact_solver = object
  private
    type tposition_solver_manifold = record
      normal: tb2_vec2;
      point: tb2_vec2;
      separation: tb2_float32;
    end;
    function initialize_position_solver_manifold(
      const pc: pb2_contact_position_constraint;
      const xf_a, xf_b: tb2_transform; const index: tb2_int32
    ): tposition_solver_manifold;
  public
    var step: tb2_time_step;
    var positions: pb2_position_arr;
    var velocities: pb2_velocity_arr;
    var allocator: pb2_stack_allocator;
    var position_constraints: pb2_contact_position_constraint_arr;
    var velocity_constraints: pb2_contact_velocity_constraint_arr;
    var contacts: ppb2_contact_arr;
    var count: tb2_int32;
    constructor create(const def: tb2_contact_solver_def);
    destructor destroy;
    procedure initialize_velocity_constraints;
    procedure warm_start;
    procedure solve_velocity_constraints;
    procedure store_impulses;
    function solve_position_constraints: boolean;
    function solve_toi_position_constraints(const toi_index_a, toi_index_b: tb2_int32): boolean;
  end;

  pb2_joint = ^tb2_joint;

  tb2_destruction_listener = class
  public
    procedure say_goodbye(const joint: pb2_joint); virtual; abstract;
    procedure say_goodbye(const fixture: pb2_fixture); virtual; abstract;
  end;

  tb2_contact_filter = class
  public
    function should_collide(const fixture_a, fixture_b: pb2_fixture): boolean; virtual;
  end;

  pb2_contact_impulse = ^tb2_contact_impulse;
  tb2_contact_impulse = record
    normal_impulses: array [0..b2_max_manifold_points - 1] of tb2_float32;
    tangent_impulses: array [0..b2_max_manifold_points - 1] of tb2_float32;
    count: tb2_int32;
  end;

  tb2_contact_listener = class
  public
    procedure begin_contact(const contact: pb2_contact); virtual;
    procedure end_contact(const contact: pb2_contact); virtual;
    procedure pre_solve(const contact: pb2_contact; const old_manifold: pb2_manifold); virtual;
    procedure post_solve(const contact: pb2_contact; const impulse: pb2_contact_impulse); virtual;
  end;

  tb2_query_fixture_callback = function (const fixture: pb2_fixture): boolean of object;

  tb2_ray_cast_fixture_callback = function (
    const fixture: pb2_fixture; const point: tb2_vec2;
    const normal: tb2_vec2; const fraction: tb2_float32
  ): tb2_float32 of object;

  pb2_contact_manager = ^tb2_contact_manager;
  tb2_contact_manager = object
  public
    var broad_phase: tb2_broad_phase;
    var contact_list: pb2_contact;
    var contact_count: tb2_int32;
    var contact_filter: tb2_contact_filter;
    var contact_listener: tb2_contact_listener;
    var allocator: pb2_block_allocator;
    constructor create;
    destructor destroy;
    procedure add_pair(const proxy_user_data_a, proxy_user_data_b: tb2_ptr);
    procedure find_new_contacts;
    procedure destroy_contact(var c: pb2_contact);
    procedure collide;
  end;

  pb2_joint_arr = ^tb2_joint_arr;
  ppb2_joint_arr = ^tpb2_joint_arr;

  tb2_island = object
  public
    var _allocator: pb2_stack_allocator;
    var _listener: tb2_contact_listener;
    var _bodies: ppb2_body_arr;
    var _contacts: ppb2_contact_arr;
    var _joints: ppb2_joint_arr;
    var _positions: pb2_position_arr;
    var _velocities: pb2_velocity_arr;
    var _body_count: tb2_int32;
    var _joint_count: tb2_int32;
    var _contact_count: tb2_int32;
    var _body_capacity: tb2_int32;
    var _contact_capacity: tb2_int32;
    var _joint_capacity: tb2_int32;
    constructor create(
      const body_capacity, contact_capacity, joint_capacity: tb2_int32;
      const allocator: pb2_stack_allocator; const listener: tb2_contact_listener
    );
    destructor destroy;
    procedure clear; inline;
    procedure solve(const profile: pb2_profile; const step: tb2_time_step; const gravity: tb2_vec2; const allow_sleep: boolean);
    procedure solve_toi(const sub_step: tb2_time_step; const toi_index_a, toi_index_b: tb2_int32);
    procedure add(const body: pb2_body); inline;
    procedure add(const contact: pb2_contact); inline;
    procedure add(const joint: pb2_joint); inline;
    procedure report(const constraints: pb2_contact_velocity_constraint_arr);
  end;

  tb2_joint_type = (
    b2_jt_unknown_joint,
    b2_jt_revolute_joint,
    b2_jt_prismatic_joint,
    b2_jt_distance_joint,
    b2_jt_pulley_joint,
    b2_jt_mouse_joint,
    b2_jt_gear_joint,
    b2_jt_wheel_joint,
    b2_jt_weld_joint,
    b2_jt_friction_joint,
    b2_jt_rope_joint,
    b2_jt_motor_joint
  );

  tb2_limit_state = (
    b2_ls_inactive_limit,
    b2_ls_at_lower_limit,
    b2_ls_at_upper_limit,
    b2_ls_equal_limits
  );

  tb2_jacobian = record
    linear: tb2_vec2;
    angular_a: tb2_float32;
    angular_b: tb2_float32;
  end;

  tb2_joint_edge = record
    other: pb2_body;
    joint: pb2_joint;
    prev: pb2_joint_edge;
    next: pb2_joint_edge;
  end;

  pb2_joint_def = ^tb2_joint_def;
  tb2_joint_def = object
  public
    var joint_type: tb2_joint_type;
    var user_data: tb2_ptr;
    var body_a: pb2_body;
    var body_b: pb2_body;
    var collide_connected: boolean;
  end;

  tb2_joint = object
  protected
    var _type: tb2_joint_type;
    var _prev: pb2_joint;
    var _next: pb2_joint;
    var _edge_a: tb2_joint_edge;
    var _edge_b: tb2_joint_edge;
    var _body_a: pb2_body;
    var _body_b: pb2_body;
    var _index: tb2_int32;
    var _island_flag: boolean;
    var _collide_connected: boolean;
    var _user_data: tb2_ptr;
    function create_joint(const def: tb2_joint_def; const allocator: pb2_block_allocator): pb2_joint; static;
    procedure destroy_joint(var joint: pb2_joint; const allocator: pb2_block_allocator); static;
    procedure init_velocity_constraints(var data: tb2_solver_data); virtual; abstract;
    procedure solve_velocity_constraints(var data: tb2_solver_data); virtual; abstract;
    function solve_position_constraints(var data: tb2_solver_data): boolean; virtual; abstract;
  public
    constructor create(const def: tb2_joint_def);
    destructor destroy; virtual;
    function get_type: tb2_joint_type; inline;
    function get_body_a: pb2_body; inline;
    function get_body_b: pb2_body; inline;
    function get_anchor_a: tb2_vec2; virtual; abstract;
    function get_anchor_b: tb2_vec2; virtual; abstract;
    function get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2; virtual; abstract;
    function get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32; virtual; abstract;
    function get_next: pb2_joint; inline;
    function get_user_data: tb2_ptr; inline;
    procedure set_user_data(const data: tb2_ptr); inline;
    function is_active: boolean; inline;
    function get_collide_connected: boolean; inline;
    procedure dump; virtual;
    procedure shift_origin(const new_origin: tb2_vec2); virtual;
  end;
  tb2_joint_arr = array[word] of tb2_joint;
  tpb2_joint_arr = array[word] of pb2_joint;

  pb2_distance_joint_def = ^tb2_distance_joint_def;
  tb2_distance_joint_def = object (tb2_joint_def)
  public
    var local_anchor_a: tb2_vec2;
    var local_anchor_b: tb2_vec2;
    var len: tb2_float32;
    var frequency_hz: tb2_float32;
    var damping_ratio: tb2_float32;
    procedure initialize(
      const b_a, b_b: pb2_body;
      const anchor_a, anchor_b: tb2_vec2
    );
  end;

  pb2_distance_joint = ^tb2_distance_joint;
  tb2_distance_joint = object (tb2_joint)
  protected
    var _frequency_hz: tb2_float32;
    var _damping_ratio: tb2_float32;
    var _bias: tb2_float32;
    var _local_anchor_a: tb2_vec2;
    var _local_anchor_b: tb2_vec2;
    var _gamma: tb2_float32;
    var _impulse: tb2_float32;
    var _len: tb2_float32;
    var _index_a: tb2_int32;
    var _index_b: tb2_int32;
    var _u: tb2_vec2;
    var _r_a: tb2_vec2;
    var _r_b: tb2_vec2;
    var _local_center_a: tb2_vec2;
    var _local_center_b: tb2_vec2;
    var _rcp_mass_a: tb2_float32;
    var _rcp_mass_b: tb2_float32;
    var _rcp_inertia_a: tb2_float32;
    var _rcp_inertia_b: tb2_float32;
    var _mass: tb2_float32;
    procedure init_velocity_constraints(var data: tb2_solver_data); virtual;
    procedure solve_velocity_constraints(var data: tb2_solver_data); virtual;
    function solve_position_constraints(var data: tb2_solver_data): boolean; virtual;
  public
    constructor create_distance_joint(const def: tb2_distance_joint_def);
    function get_anchor_a: tb2_vec2; virtual;
    function get_anchor_b: tb2_vec2; virtual;
    function get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2; virtual;
    function get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32; virtual;
    function get_local_anchor_a: tb2_vec2; inline;
    function get_local_anchor_b: tb2_vec2; inline;
    procedure set_length(const len: tb2_float32); inline;
    function get_length: tb2_float32; inline;
    procedure set_frequency(const hz: tb2_float32); inline;
    function get_frequency: tb2_float32; inline;
    procedure set_damping_datio(const ratio: tb2_float32); inline;
    function get_damping_ratio: tb2_float32; inline;
    procedure dump; virtual;
  end;

  pb2_wheel_joint_def = ^tb2_wheel_joint_def;
  tb2_wheel_joint_def = object (tb2_joint_def)
  public
    var local_anchor_a: tb2_vec2;
    var local_anchor_b: tb2_vec2;
    var local_axis_a: tb2_vec2;
    var enable_motor: boolean;
    var max_motor_torque: tb2_float32;
    var motor_speed: tb2_float32;
    var frequency_hz: tb2_float32;
    var damping_ratio: tb2_float32;
    procedure initialize(
      const b_a, b_b: pb2_body;
      const anchor, axis: tb2_vec2
    );
  end;

  pb2_wheel_joint = ^tb2_wheel_joint;
  tb2_wheel_joint = object (tb2_joint)
  protected
    var _frequency_hz: tb2_float32;
    var _damping_ratio: tb2_float32;
    var _local_anchor_a: tb2_vec2;
    var _local_anchor_b: tb2_vec2;
    var _local_x_axis_a: tb2_vec2;
    var _local_y_axis_a: tb2_vec2;
    var _impulse: tb2_float32;
    var _motor_impulse: tb2_float32;
    var _spring_impulse: tb2_float32;
    var _max_motor_torque: tb2_float32;
    var _motor_speed: tb2_float32;
    var _enable_motor: boolean;
    var _index_a: tb2_int32;
    var _index_b: tb2_int32;
    var _local_center_a: tb2_vec2;
    var _local_center_b: tb2_vec2;
    var _rcp_mass_a: tb2_float32;
    var _rcp_mass_b: tb2_float32;
    var _rcp_inertia_a: tb2_float32;
    var _rcp_inertia_b: tb2_float32;
    var _ax, _ay: tb2_vec2;
    var _s_a_x, _s_b_x: tb2_float32;
    var _s_a_y, _s_b_y: tb2_float32;
    var _mass: tb2_float32;
    var _motor_mass: tb2_float32;
    var _spring_mass: tb2_float32;
    var _bias: tb2_float32;
    var _gamma: tb2_float32;
    procedure init_velocity_constraints(var data: tb2_solver_data); virtual;
    procedure solve_velocity_constraints(var data: tb2_solver_data); virtual;
    function solve_position_constraints(var data: tb2_solver_data): boolean; virtual;
  public
    constructor create_wheel_joint(const def: tb2_wheel_joint_def);
    function get_anchor_a: tb2_vec2; virtual;
    function get_anchor_b: tb2_vec2; virtual;
    function get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2; virtual;
    function get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32; virtual;
    function get_local_anchor_a: tb2_vec2; inline;
    function get_local_anchor_b: tb2_vec2; inline;
    function get_local_axis_a: tb2_vec2; inline;
    function get_joint_translation: tb2_float32;
    function get_joint_speed: tb2_float32;
    function is_motor_enabled: boolean; inline;
    procedure enable_motor(const flag: boolean);
    procedure set_motor_speed(const speed: tb2_float32);
    function get_motor_speed: tb2_float32; inline;
    procedure set_max_motor_torque(const torque: tb2_float32);
    function get_max_motor_torque: tb2_float32; inline;
    function get_motor_torque(const rcp_dt: tb2_float32): tb2_float32; inline;
    procedure set_spring_frequency_hz(const hz: tb2_float32); inline;
    function get_spring_frequency_hz: tb2_float32; inline;
    procedure set_spring_damping_ratio(const ratio: tb2_float32); inline;
    function get_spring_damping_ratio: tb2_float32; inline;
    procedure dump; virtual;
  end;

  pb2_mouse_joint_def = ^tb2_mouse_joint_def;
  tb2_mouse_joint_def  = object (tb2_joint_def)
  public
    var target: tb2_vec2;
    var max_force: tb2_float32;
    var frequency_hz: tb2_float32;
    var damping_ratio: tb2_float32;
  end;

  pb2_mouse_joint = ^tb2_mouse_joint;
  tb2_mouse_joint = object (tb2_joint)
  protected
    var _local_anchor_b: tb2_vec2;
    var _target_a: tb2_vec2;
    var _frequency_hz: tb2_float32;
    var _damping_ratio: tb2_float32;
    var _beta: tb2_float32;
    var _impulse: tb2_vec2;
    var _max_force: tb2_float32;
    var _gamma: tb2_float32;
    var _index_a: tb2_int32;
    var _index_b: tb2_int32;
    var _r_b: tb2_vec2;
    var _local_center_b: tb2_vec2;
    var _rcp_mass_b: tb2_float32;
    var _rcp_inertia_b: tb2_float32;
    var _mass: tb2_mat22;
    var _c: tb2_vec2;
    procedure init_velocity_constraints(var data: tb2_solver_data); virtual;
    procedure solve_velocity_constraints(var data: tb2_solver_data); virtual;
    function solve_position_constraints(var data: tb2_solver_data): boolean; virtual;
  public
    constructor create_mouse_joint(const def: tb2_mouse_joint_def);
    function get_anchor_a: tb2_vec2; virtual;
    function get_anchor_b: tb2_vec2; virtual;
    function get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2; virtual;
    function get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32; virtual;
    procedure set_target(const target: tb2_vec2); inline;
    function get_target: tb2_vec2; inline;
    procedure set_max_force(const force: tb2_float32); inline;
    function get_max_force: tb2_float32; inline;
    procedure set_frequency(const hz: tb2_float32); inline;
    function get_frequency: tb2_float32; inline;
    procedure set_damping_ratio(const ratio: tb2_float32); inline;
    function get_damping_ratio: tb2_float32; inline;
    procedure dump; virtual;
    procedure shift_origin(const new_origin: tb2_vec2); virtual;
  end;

  pb2_revolute_joint_def = ^tb2_revolute_joint_def;
  tb2_revolute_joint_def = object (tb2_joint_def)
  public
    var local_anchor_a: tb2_vec2;
    var local_anchor_b: tb2_vec2;
    var reference_angle: tb2_float32;
    var enable_limit: boolean;
    var lower_angle: tb2_float32;
    var upper_angle: tb2_float32;
    var enable_motor: boolean;
    var motor_speed: tb2_float32;
    var max_motor_torque: tb2_float32;
    procedure initialize(
      const b_a, b_b: pb2_body;
      const anchor: tb2_vec2
    );
  end;

  pb2_revolute_joint = ^tb2_revolute_joint;
  tb2_revolute_joint = object (tb2_joint)
  protected
    var _local_anchor_a: tb2_vec2;
    var _local_anchor_b: tb2_vec2;
    var _impulse: tb2_vec3;
    var _motor_impulse: tb2_float32;
    var _enable_motor: boolean;
    var _max_motor_torque: tb2_float32;
    var _motor_speed: tb2_float32;
    var _enable_limit: boolean;
    var _reference_angle: tb2_float32;
    var _lower_angle: tb2_float32;
    var _upper_angle: tb2_float32;
    var _index_a: tb2_int32;
    var _index_b: tb2_int32;
    var _r_a: tb2_vec2;
    var _r_b: tb2_vec2;
    var _local_center_a: tb2_vec2;
    var _local_center_b: tb2_vec2;
    var _rcp_mass_a: tb2_float32;
    var _rcp_mass_b: tb2_float32;
    var _rcp_inertia_a: tb2_float32;
    var _rcp_inertia_b: tb2_float32;
    var _mass: tb2_mat33;
    var _motor_mass: tb2_float32;
    var _limit_state: tb2_limit_state;
    procedure init_velocity_constraints(var data: tb2_solver_data); virtual;
    procedure solve_velocity_constraints(var data: tb2_solver_data); virtual;
    function solve_position_constraints(var data: tb2_solver_data): boolean; virtual;
  public
    constructor create_revolute_joint(const def: tb2_revolute_joint_def);
    function get_anchor_a: tb2_vec2; virtual;
    function get_anchor_b: tb2_vec2; virtual;
    function get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2; virtual;
    function get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32 virtual;
    function get_local_anchor_a: tb2_vec2; inline;
    function get_local_anchor_b: tb2_vec2; inline;
    function get_reference_angle: tb2_float32; inline;
    function get_joint_angle: tb2_float32; inline;
    function get_joint_speed: tb2_float32; inline;
    function is_limit_enabled: boolean; inline;
    procedure enable_limit(const flag: boolean);
    function get_lower_limit: tb2_float32; inline;
    function get_upper_limit: tb2_float32; inline;
    procedure set_limits(const lower, upper: tb2_float32);
    function is_motor_enabled: boolean; inline;
    procedure enable_motor(const flag: boolean); inline;
    procedure set_motor_speed(const speed: tb2_float32); inline;
    function get_motor_speed: tb2_float32; inline;
    procedure set_max_motor_torque(const torque: tb2_float32); inline;
    function get_max_motor_torque: tb2_float32; inline;
    function get_motor_torque(const rcp_dt: tb2_float32): tb2_float32; inline;
    procedure dump; virtual;
  end;

  pb2_prismatic_joint_def = ^tb2_prismatic_joint_def;
  tb2_prismatic_joint_def = object(tb2_joint_def)
  public
    var local_anchor_a: tb2_vec2;
    var local_anchor_b: tb2_vec2;
    var local_axis_a: tb2_vec2;
    var reference_angle: tb2_float32;
    var enable_limit: boolean;
    var lower_translation: tb2_float32;
    var upper_translation: tb2_float32;
    var enable_motor: boolean;
    var max_motor_force: tb2_float32;
    var motor_speed: tb2_float32;
    procedure initialize(const b_a, b_b: pb2_body; const anchor, axis: tb2_vec2);
  end;

  pb2_prismatic_joint = ^tb2_prismatic_joint;
  tb2_prismatic_joint = object (tb2_joint)
  protected
    var _local_anchor_a: tb2_vec2;
    var _local_anchor_b: tb2_vec2;
    var _local_x_axis_a: tb2_vec2;
    var _local_y_axis_a: tb2_vec2;
    var _reference_angle: tb2_float32;
    var _impulse: tb2_vec3;
    var _motor_impulse: tb2_float32;
    var _lower_translation: tb2_float32;
    var _upper_translation: tb2_float32;
    var _max_motor_force: tb2_float32;
    var _motor_speed: tb2_float32;
    var _enable_limit: boolean;
    var _enable_motor: boolean;
    var _limit_state: tb2_limit_state;
    var _index_a: tb2_int32;
    var _index_b: tb2_int32;
    var _local_center_a: tb2_vec2;
    var _local_center_b: tb2_vec2;
    var _rcp_mass_a: tb2_float32;
    var _rcp_mass_b: tb2_float32;
    var _rcp_inertia_a: tb2_float32;
    var _rcp_inertia_b: tb2_float32;
    var _axis, _perp: tb2_vec2;
    var _s1, _s2: tb2_float32;
    var _a1, _a2: tb2_float32;
    var _k: tb2_mat33;
    var _motor_mass: tb2_float32;
    procedure init_velocity_constraints(var data: tb2_solver_data); virtual;
    procedure solve_velocity_constraints(var data: tb2_solver_data); virtual;
    function solve_position_constraints(var data: tb2_solver_data): boolean; virtual;
  public
    constructor create_prismatic_joint(const def: tb2_prismatic_joint_def);
    function get_anchor_a: tb2_vec2; virtual;
    function get_anchor_b: tb2_vec2; virtual;
    function get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2; virtual;
    function get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32; virtual;
    function get_local_anchor_a: tb2_vec2; inline;
    function get_local_anchor_b: tb2_vec2; inline;
    function get_local_axis_a: tb2_vec2; inline;
    function get_reference_angle: tb2_float32; inline;
    function get_joint_translation: tb2_float32;
    function get_joint_speed: tb2_float32;
    function is_limit_enabled: boolean; inline;
    procedure enable_limit(const flag: boolean);
    function get_lower_limit: tb2_float32; inline;
    function get_upper_limit: tb2_float32; inline;
    procedure set_limits(const lower, upper: tb2_float32);
    function is_motor_enabled: boolean; inline;
    procedure enable_motor(const flag: boolean); inline;
    procedure set_motor_speed(const speed: tb2_float32); inline;
    function get_motor_speed: tb2_float32; inline;
    procedure set_max_motor_force(const force: tb2_float32); inline;
    function get_max_motor_force: tb2_float32; inline;
    function get_motor_force(const rcp_dt: tb2_float32): tb2_float32;
    procedure dump; virtual;
  end;

  pb2_pulley_joint_def = ^tb2_pulley_joint_def;
  tb2_pulley_joint_def = object(tb2_joint_def)
  public
    var ground_anchor_a: tb2_vec2;
    var ground_anchor_b: tb2_vec2;
    var local_anchor_a: tb2_vec2;
    var local_anchor_b: tb2_vec2;
    var length_a: tb2_float32;
    var length_b: tb2_float32;
    var ratio: tb2_float32;
    procedure initialize(
      const b_a, b_b: pb2_body;
      const ground_a, ground_b: tb2_vec2;
      const anchor_a, anchor_b: tb2_vec2;
      const new_ratio: tb2_float32
    );
  end;

  pb2_pulley_joint = ^tb2_pulley_joint;
  tb2_pulley_joint = object(tb2_joint)
  protected
    var _ground_anchor_a: tb2_vec2;
    var _ground_anchor_b: tb2_vec2;
    var _length_a: tb2_float32;
    var _length_b: tb2_float32;
    var _local_anchor_a: tb2_vec2;
    var _local_anchor_b: tb2_vec2;
    var _constant: tb2_float32;
    var _ratio: tb2_float32;
    var _impulse: tb2_float32;
    var _index_a: tb2_int32;
    var _index_b: tb2_int32;
    var _u_a: tb2_vec2;
    var _u_b: tb2_vec2;
    var _r_a: tb2_vec2;
    var _r_b: tb2_vec2;
    var _local_center_a: tb2_vec2;
    var _local_center_b: tb2_vec2;
    var _rcp_mass_a: tb2_float32;
    var _rcp_mass_b: tb2_float32;
    var _rcp_inertia_a: tb2_float32;
    var _rcp_inertia_b: tb2_float32;
    var _mass: tb2_float32;
    procedure init_velocity_constraints(var data: tb2_solver_data); virtual;
    procedure solve_velocity_constraints(var data: tb2_solver_data); virtual;
    function solve_position_constraints(var data: tb2_solver_data): boolean; virtual;
  public
    constructor create_pulley_joint(const def: tb2_pulley_joint_def);
    function get_anchor_a: tb2_vec2; virtual;
    function get_anchor_b: tb2_vec2; virtual;
    function get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2; virtual;
    function get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32; virtual;
    function get_ground_anchor_a: tb2_vec2; inline;
    function get_ground_anchor_b: tb2_vec2; inline;
    function get_length_a: tb2_float32; inline;
    function get_length_b: tb2_float32; inline;
    function get_ratio: tb2_float32; inline;
    function get_current_length_a: tb2_float32;
    function get_current_length_b: tb2_float32;
    procedure shift_origin(const new_origin: tb2_vec2); virtual;
    procedure dump; virtual;
  end;

  pb2_gear_joint_def = ^tb2_gear_joint_def;
  tb2_gear_joint_def = object(tb2_joint_def)
  public
    var joint1: pb2_joint;
    var joint2: pb2_joint;
    var ratio: tb2_float32;
  end;

  pb2_gear_joint = ^tb2_gear_joint;
  tb2_gear_joint = object(tb2_joint)
  protected
    var _joint1: pb2_joint;
    var _joint2: pb2_joint;
    var _type_a: tb2_joint_type;
    var _type_b: tb2_joint_type;
    var _body_c: pb2_body;
    var _body_d: pb2_body;
    var _local_anchor_a: tb2_vec2;
    var _local_anchor_b: tb2_vec2;
    var _local_anchor_c: tb2_vec2;
    var _local_anchor_d: tb2_vec2;
    var _local_axis_c: tb2_vec2;
    var _local_axis_d: tb2_vec2;
    var _reference_angle_a: tb2_float32;
    var _reference_angle_b: tb2_float32;
    var _constant: tb2_float32;
    var _ratio: tb2_float32;
    var _impulse: tb2_float32;
    var _index_a, _index_b, _index_c, _index_d: tb2_int32;
    var _lc_a, _lc_b, _lc_c, _lc_d: tb2_vec2;
    var _m_a, _m_b, _m_c, _m_d: tb2_float32;
    var _i_a, _i_b, _i_c, _i_d: tb2_float32;
    var _jv_ac, _jv_bd: tb2_vec2;
    var _jw_a, _jw_b, _jw_c, _jw_d: tb2_float32;
    var _mass: tb2_float32;
    procedure init_velocity_constraints(var data: tb2_solver_data); virtual;
    procedure solve_velocity_constraints(var data: tb2_solver_data); virtual;
    function solve_position_constraints(var data: tb2_solver_data): boolean; virtual;
  public
    constructor create_gear_joint(const def: tb2_gear_joint_def);
    function get_anchor_a: tb2_vec2; virtual;
    function get_anchor_b: tb2_vec2; virtual;
    function get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2; virtual;
    function get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32; virtual;
    function get_joint1: pb2_joint; inline;
    function get_joint2: pb2_joint; inline;
    procedure set_ratio(const ratio: tb2_float32); inline;
    function get_ratio: tb2_float32;
    procedure dump; virtual;
  end;

  pb2_weld_joint_def = ^tb2_weld_joint_def;
  tb2_weld_joint_def = object(tb2_joint_def)
  public
    var local_anchor_a: tb2_vec2;
    var local_anchor_b: tb2_vec2;
    var reference_angle: tb2_float32;
    var frequency_hz: tb2_float32;
    var damping_ratio: tb2_float32;
    procedure initialize(const b_a, b_b: pb2_body; const anchor: tb2_vec2);
  end;

  pb2_weld_joint = ^tb2_weld_joint;
  tb2_weld_joint = object(tb2_joint)
  protected
    var _frequency_hz: tb2_float32;
    var _damping_ratio: tb2_float32;
    var _bias: tb2_float32;
    var _local_anchor_a: tb2_vec2;
    var _local_anchor_b: tb2_vec2;
    var _reference_angle: tb2_float32;
    var _gamma: tb2_float32;
    var _impulse: tb2_vec3;
    var _index_a: tb2_int32;
    var _index_b: tb2_int32;
    var _r_a: tb2_vec2;
    var _r_b: tb2_vec2;
    var _local_center_a: tb2_vec2;
    var _local_center_b: tb2_vec2;
    var _rcp_mass_a: tb2_float32;
    var _rcp_mass_b: tb2_float32;
    var _rcp_inertia_a: tb2_float32;
    var _rcp_inertia_b: tb2_float32;
    var _mass: tb2_mat33;
    procedure init_velocity_constraints(var data: tb2_solver_data); virtual;
    procedure solve_velocity_constraints(var data: tb2_solver_data); virtual;
    function solve_position_constraints(var data: tb2_solver_data): boolean; virtual;
  public
    constructor create_weld_joint(const def: tb2_weld_joint_def);
    function get_anchor_a: tb2_vec2; virtual;
    function get_anchor_b: tb2_vec2; virtual;
    function get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2; virtual;
    function get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32; virtual;
    function get_local_anchor_a: tb2_vec2; inline;
    function get_local_anchor_b: tb2_vec2; inline;
    function get_reference_angle: tb2_float32; inline;
    procedure set_frequency(const hz: tb2_float32); inline;
    function get_frequency: tb2_float32; inline;
    procedure set_damping_ratio(const ratio: tb2_float32); inline;
    function get_damping_ratio: tb2_float32; inline;
    procedure dump; virtual;
  end;

  pb2_friction_joint_def = ^tb2_friction_joint_def;
  tb2_friction_joint_def = object(tb2_joint_def)
  public
    var local_anchor_a: tb2_vec2;
    var local_anchor_b: tb2_vec2;
    var max_force: tb2_float32;
    var max_torque: tb2_float32;
    procedure initialize(const b_a, b_b: pb2_body; const anchor: tb2_vec2);
  end;

  pb2_friction_joint = ^tb2_friction_joint;
  tb2_friction_joint = object(tb2_joint)
  protected
    var _local_anchor_a: tb2_vec2;
    var _local_anchor_b: tb2_vec2;
    var _linear_impulse: tb2_vec2;
    var _angular_impulse: tb2_float32;
    var _max_force: tb2_float32;
    var _max_torque: tb2_float32;
    var _index_a: tb2_int32;
    var _index_b: tb2_int32;
    var _r_a: tb2_vec2;
    var _r_b: tb2_vec2;
    var _local_center_a: tb2_vec2;
    var _local_center_b: tb2_vec2;
    var _rcp_mass_a: tb2_float32;
    var _rcp_mass_b: tb2_float32;
    var _rcp_inertia_a: tb2_float32;
    var _rcp_inertia_b: tb2_float32;
    var _linear_mass: tb2_mat22;
    var _angular_mass: tb2_float32;
    procedure init_velocity_constraints(var data: tb2_solver_data); virtual;
    procedure solve_velocity_constraints(var data: tb2_solver_data); virtual;
    function solve_position_constraints(var data: tb2_solver_data): boolean; virtual;
  public
    constructor create_friction_joint(const def: tb2_friction_joint_def);
    function get_anchor_a: tb2_vec2; virtual;
    function get_anchor_b: tb2_vec2; virtual;
    function get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2; virtual;
    function get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32; virtual;
    function get_local_anchor_a: tb2_vec2; inline;
    function get_local_anchor_b: tb2_vec2; inline;
    procedure set_max_force(const force: tb2_float32);
    function get_max_force: tb2_float32;
    procedure set_max_torque(const torque: tb2_float32);
    function get_max_torque: tb2_float32;
    procedure dump; virtual;
  end;

  pb2_rope_joint_def = ^tb2_rope_joint_def;
  tb2_rope_joint_def = object(tb2_joint_def)
  public
    var local_anchor_a: tb2_vec2;
    var local_anchor_b: tb2_vec2;
    var max_length: tb2_float32;
  end;

  pb2_rope_joint = ^tb2_rope_joint;
  tb2_rope_joint = object(tb2_joint)
  protected
    var _local_anchor_a: tb2_vec2;
    var _local_anchor_b: tb2_vec2;
    var _max_length: tb2_float32;
    var _length: tb2_float32;
    var _impulse: tb2_float32;
    var _index_a: tb2_int32;
    var _index_b: tb2_int32;
    var _u: tb2_vec2;
    var _r_a: tb2_vec2;
    var _r_b: tb2_vec2;
    var _local_center_a: tb2_vec2;
    var _local_center_b: tb2_vec2;
    var _rcp_mass_a: tb2_float32;
    var _rcp_mass_b: tb2_float32;
    var _rcp_inertia_a: tb2_float32;
    var _rcp_inertia_b: tb2_float32;
    var _mass: tb2_float32;
    var _state: tb2_limit_state;
    procedure init_velocity_constraints(var data: tb2_solver_data); virtual;
    procedure solve_velocity_constraints(var data: tb2_solver_data); virtual;
    function solve_position_constraints(var data: tb2_solver_data): boolean; virtual;
  public
    constructor create_rope_joint(const def: tb2_rope_joint_def);
    function get_anchor_a: tb2_vec2; virtual;
    function get_anchor_b: tb2_vec2; virtual;
    function get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2; virtual;
    function get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32; virtual;
    function get_local_anchor_a: tb2_vec2; inline;
    function get_local_anchor_b: tb2_vec2; inline;
    procedure set_max_length(const len: tb2_float32); inline;
    function get_max_length: tb2_float32; inline;
    function get_limit_state: tb2_limit_state; inline;
    procedure dump; virtual;
  end;

  pb2_motor_joint_def = ^tb2_motor_joint_def;
  tb2_motor_joint_def = object(tb2_joint_def)
  public
    var linear_offset: tb2_vec2;
    var angular_offset: tb2_float32;
    var max_force: tb2_float32;
    var max_torque: tb2_float32;
    var correction_factor: tb2_float32;
    procedure initialize(const b_a, b_b: pb2_body);
  end;

  pb2_motor_joint = ^tb2_motor_joint;
  tb2_motor_joint = object(tb2_joint)
  protected
    var _linear_offset: tb2_vec2;
    var _angular_offset: tb2_float32;
    var _linear_impulse: tb2_vec2;
    var _angular_impulse: tb2_float32;
    var _max_force: tb2_float32;
    var _max_torque: tb2_float32;
    var _correction_factor: tb2_float32;
    var _index_a: tb2_int32;
    var _index_b: tb2_int32;
    var _r_a: tb2_vec2;
    var _r_b: tb2_vec2;
    var _local_center_a: tb2_vec2;
    var _local_center_b: tb2_vec2;
    var _linear_error: tb2_vec2;
    var _angular_error: tb2_float32;
    var _rcp_mass_a: tb2_float32;
    var _rcp_mass_b: tb2_float32;
    var _rcp_inertia_a: tb2_float32;
    var _rcp_inertia_b: tb2_float32;
    var _linear_mass: tb2_mat22;
    var _angular_mass: tb2_float32;
    procedure init_velocity_constraints(var data: tb2_solver_data); virtual;
    procedure solve_velocity_constraints(var data: tb2_solver_data); virtual;
    function solve_position_constraints(var data: tb2_solver_data): boolean; virtual;
  public
    constructor create_motor_joint(const def: tb2_motor_joint_def);
    function get_anchor_a: tb2_vec2; virtual;
    function get_anchor_b: tb2_vec2; virtual;
    function get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2; virtual;
    function get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32; virtual;
    procedure set_linear_offset(const linear_offset: tb2_vec2);
    function get_linear_offset: tb2_vec2; inline;
    procedure set_angular_offset(const angular_offset: tb2_float32);
    function get_angular_offset: tb2_float32; inline;
    procedure set_max_force(const force: tb2_float32); inline;
    function get_max_force: tb2_float32; inline;
    procedure set_max_torque(const torque: tb2_float32); inline;
    function get_max_torque: tb2_float32; inline;
    procedure set_correction_factor(const factor: tb2_float32); inline;
    function get_correction_factor: tb2_float32; inline;
    procedure dump; virtual;
  end;

  tb2_world_flag = (
    b2_wf_new_fixture,
    b2_wf_locked,
    b2_wf_clear_forces
  );
  tb2_world_flag_set = set of tb2_world_flag;

  tb2_world = object
  private
    type tb2_world_query_wrapper = object
    public
      var broad_phase: pb2_broad_phase;
      var callback: tb2_query_fixture_callback;
      function query_callback(const proxy_id: tb2_int32): boolean;
    end;
    type tb2_world_ray_cast_wrapper = object
    public
      var broad_phase: pb2_broad_phase;
      var callback: tb2_ray_cast_fixture_callback;
      function ray_cast_callback(const input: tb2_ray_cast_input; const proxy_id: tb2_int32): tb2_float32;
    end;
    var _block_allocator: tb2_block_allocator;
    var _stack_allocator: tb2_stack_allocator;
    var _flags: tb2_world_flag_set;
    var _contact_manager: tb2_contact_manager;
    var _body_list: pb2_body;
    var _joint_list: pb2_joint;
    var _body_count: tb2_int32;
    var _joint_count: tb2_int32;
    var _gravity: tb2_vec2;
    var _allow_sleep: boolean;
    var _destruction_listener: tb2_destruction_listener;
    var _debug_draw: tb2_draw;
    var _rcp_dt0: tb2_float32;
    var _warm_starting: boolean;
    var _continuous_physics: boolean;
    var _sub_stepping: boolean;
    var _step_complete: boolean;
    var _profile: tb2_profile;
    procedure solve(const step: tb2_time_step);
    procedure solve_toi(const step: tb2_time_step);
    procedure draw_joint(const joint: pb2_joint);
    procedure draw_shape(const fixture: pb2_fixture; const xf: tb2_transform; const color: tb2_color);
  public
    constructor create(const gravity: tb2_vec2);
    destructor destroy;
    procedure clear;
    procedure set_destruction_listener(const listener: tb2_destruction_listener); inline;
    procedure set_contact_filter(const filter: tb2_contact_filter); inline;
    procedure set_contact_listener(const listener: tb2_contact_listener); inline;
    procedure set_debug_draw(const debug_draw: tb2_draw); inline;
    function create_body(const def: tb2_body_def): pb2_body;
    procedure destroy_body(var body: pb2_body);
    function create_joint(const def: tb2_joint_def): pb2_joint;
    procedure destroy_joint(var joint: pb2_joint);
    procedure step(const time_step: tb2_float32; const velocity_iterations, position_iterations: tb2_int32);
    procedure clear_forces;
    procedure draw_debug_data;
    procedure query_aabb(const callback: tb2_query_fixture_callback; const aabb: tb2_aabb);
    procedure ray_cast(const callback: tb2_ray_cast_fixture_callback; const point1, point2: tb2_vec2);
    function get_body_list: pb2_body; inline;
    function get_joint_list: pb2_joint; inline;
    function get_contact_list: pb2_contact; inline;
    procedure set_allow_sleeping(const flag: boolean);
    function get_allow_sleeping: boolean; inline;
    procedure set_warm_starting(const flag: boolean); inline;
    function get_warm_starting: boolean; inline;
    procedure set_continuous_physics(const flag: boolean); inline;
    function get_continuous_physics: boolean; inline;
    procedure set_sub_stepping(const flag: boolean); inline;
    function get_sub_stepping: boolean; inline;
    function get_proxy_count: tb2_int32; inline;
    function get_body_count: tb2_int32; inline;
    function get_joint_count: tb2_int32; inline;
    function get_contact_count: tb2_int32; inline;
    function get_tree_height: tb2_int32; inline;
    function get_tree_balance: tb2_int32; inline;
    function get_tree_quality: tb2_float32; inline;
    procedure set_gravity(const gravity: tb2_vec2); inline;
    function get_gravity: tb2_vec2; inline;
    function is_locked: boolean; inline;
    procedure set_auto_clear_forces(const flag: boolean); inline;
    function get_auto_clear_forces: boolean; inline;
    procedure shift_origin(const new_origin: tb2_vec2);
    function get_contact_manager: pb2_contact_manager; inline;
    function get_profile: pb2_profile; inline;
    function get_stack_allocator: pb2_stack_allocator; inline;
    function get_block_allocator: pb2_block_allocator; inline;
    procedure dump;
  end;

  procedure b2_get_point_states(
    var state1: array of tb2_point_state;
    var state2: array of tb2_point_state;
    const manifold1: pb2_manifold; const manifold2: pb2_manifold
  );

  procedure b2_collide_circles(
    var manifold: tb2_manifold;
    const circle_a: pb2_circle_shape; const xf_a: tb2_transform;
    const circle_b: pb2_circle_shape; const xf_b: tb2_transform
  );

  procedure b2_collide_polygon_and_circle(
    var manifold: tb2_manifold;
    const polygon_a: pb2_polygon_shape; const xf_a: tb2_transform;
    const circle_b: pb2_circle_shape; const xf_b: tb2_transform
  );

  procedure b2_collide_polygons(
    var manifold: tb2_manifold;
    const polygon_a: pb2_polygon_shape; const xf_a: tb2_transform;
    const polygon_b: pb2_polygon_shape; const xf_b: tb2_transform
  );

  procedure b2_collide_edge_and_circle(
    var manifold: tb2_manifold;
    const edge_a: pb2_edge_shape; const xf_a: tb2_transform;
    const circle_b: pb2_circle_shape; const xf_b: tb2_transform
  );

  procedure b2_collide_edge_and_polygon(
    var manifold: tb2_manifold;
    const edge_a: pb2_edge_shape; const xf_a: tb2_transform;
    const polygon_b: pb2_polygon_shape; const xf_b: tb2_transform
  );

  function b2_clip_segment_to_line(
    const v_out: pb2_clip_vertex_arr; const v_in: pb2_clip_vertex_arr;
    const normal: tb2_vec2; const offset: tb2_float32; const vertex_index_a: tb2_int32
  ): tb2_int32;

  function b2_test_overlap(const a, b: tb2_aabb): boolean; inline; overload;

  function b2_test_overlap(
    const shape_a: pb2_shape; const index_a: tb2_int32;
    const shape_b: pb2_shape; const index_b: tb2_int32;
    const xf_a: tb2_transform; const xf_b: tb2_transform
  ): boolean; overload;

  procedure b2_distance(
    const output: pb2_distance_output;
    const cache: pb2_simplex_cache;
    const input: pb2_distance_input
  );

  procedure b2_time_of_impact(var output: tb2_toi_output; const input: tb2_toi_input);

  function b2_mix_friction(const friction1, friction2: tb2_float32): tb2_float32; inline;
  function b2_mix_restitution(const restitution1, restitution2: tb2_float32): tb2_float32; inline;

  function b2_alloc(const size: tb2_int32): tb2_ptr;
  procedure b2_free(var mem: tb2_ptr);
  procedure b2_log(const msg: string);

  function b2_is_valid(const x: tb2_float32): boolean; inline;
  function b2_inv_sqrt(const x: tb2_float32): tb2_float32; inline;
  function b2_sqrt(const x: tb2_float32): tb2_float32; inline;
  function b2_atan2(const y, x: tb2_float32): tb2_float32; inline;

  function b2_body_def: tb2_body_def; inline;
  function b2_fixture_def: tb2_fixture_def; inline;
  function b2_joint_def: tb2_joint_def; inline;
  function b2_distance_joint_def: tb2_distance_joint_def; inline;
  function b2_wheel_joint_def: tb2_wheel_joint_def; inline;
  function b2_mouse_joint_def: tb2_mouse_joint_def; inline;
  function b2_revolute_joint_def: tb2_revolute_joint_def; inline;
  function b2_prismatic_joint_def: tb2_prismatic_joint_def; inline;
  function b2_pulley_joint_def: tb2_pulley_joint_def; inline;
  function b2_gear_joint_def: tb2_gear_joint_def; inline;
  function b2_weld_joint_def: tb2_weld_joint_def; inline;
  function b2_rope_joint_def: tb2_rope_joint_def; inline;
  function b2_motor_joint_def: tb2_motor_joint_def; inline;
  function b2_friction_joint_def: tb2_friction_joint_def; inline;
  function b2_filter: tb2_filter; inline;

  function b2_vec2(const x, y: tb2_float32): tb2_vec2; inline;
  function b2_vec2_zero: tb2_vec2; inline;
  function b2_dot(const v0, v1: tb2_vec2): tb2_float32; inline; overload;
  function b2_cross(const v0, v1: tb2_vec2): tb2_float32; inline; overload;
  function b2_cross(const v: tb2_vec2; const s: tb2_float32): tb2_vec2; inline; overload;
  function b2_cross(const s: tb2_float32; const v: tb2_vec2): tb2_vec2; inline; overload;
  function b2_mul(const m: tb2_mat22; const v: tb2_vec2): tb2_vec2; inline; overload;
  function b2_mul_t(const m: tb2_mat22; const v: tb2_vec2): tb2_vec2; inline; overload;
  function b2_distance(const v0: tb2_vec2; const v1: tb2_vec2): tb2_float32; inline;
  function b2_distance_sq(const v0: tb2_vec2; const v1: tb2_vec2): tb2_float32; inline;

  function b2_vec3(const x, y, z: tb2_float32): tb2_vec3; inline;
  function b2_vec3_zero: tb2_vec3; inline;
  function b2_dot(const v0, v1: tb2_vec3): tb2_float32; inline; overload;
  function b2_cross(const v0, v1: tb2_vec3): tb2_vec3; inline; overload;

  function b2_mat22(const c0, c1: tb2_vec2): tb2_mat22; inline; overload;
  function b2_mat22(const e00, e01, e10, e11: tb2_float32): tb2_mat22; inline; overload;
  function b2_mul(const m0, m1: tb2_mat22): tb2_mat22; inline; overload;
  function b2_mul_t(const m0, m1: tb2_mat22): tb2_mat22; inline; overload;

  function b2_mul(const m0: tb2_mat33; const v0: tb2_vec3): tb2_vec3; inline; overload;
  function b2_mul22(const m0: tb2_mat33; const v0: tb2_vec2): tb2_vec2; inline;
  function b2_mul(const q0, q1: tb2_rot): tb2_rot; inline; overload;
  function b2_mul_t(const q0, q1: tb2_rot): tb2_rot; inline; overload;
  function b2_mul(const q0: tb2_rot; const v0: tb2_vec2): tb2_vec2; inline; overload;
  function b2_mul_t(const q0: tb2_rot; const v0: tb2_vec2): tb2_vec2; inline; overload;
  function b2_mul(const x0: tb2_transform; const v0: tb2_vec2): tb2_vec2; inline; overload;
  function b2_mul_t(const x0: tb2_transform; const v0: tb2_vec2): tb2_vec2; inline; overload;
  function b2_mul(const x0, x1: tb2_transform): tb2_transform; inline; overload;
  function b2_mul_t(const x0, x1: tb2_transform): tb2_transform; inline; overload;

  function b2_abs(const s: tb2_float32): tb2_float32; inline; overload;
  function b2_abs(const i: tb2_int32): tb2_int32; inline; overload;
  function b2_abs(const v0: tb2_vec2): tb2_vec2; inline; overload;
  function b2_abs(const m0: tb2_mat22): tb2_mat22; inline; overload;

  function b2_min(const s0, s1: tb2_int32): tb2_int32; inline; overload;
  function b2_min(const s0, s1: tb2_uint32): tb2_uint32; inline; overload;
  function b2_min(const s0, s1: tb2_float32): tb2_float32; inline; overload;
  function b2_min(const v0, v1: tb2_vec2): tb2_vec2; inline; overload;

  function b2_max(const s0, s1: tb2_int32): tb2_int32; inline; overload;
  function b2_max(const s0, s1: tb2_uint32): tb2_uint32; inline; overload;
  function b2_max(const s0, s1: tb2_float32): tb2_float32; inline; overload;
  function b2_max(const v0, v1: tb2_vec2): tb2_vec2; inline; overload;

  function b2_clamp(const s, l, h: tb2_float32): tb2_float32; inline; overload;
  function b2_clamp(const s, l, h: tb2_vec2): tb2_vec2; inline; overload;

  procedure b2_swap(var s0, s1: tb2_float32); inline; overload;
  procedure b2_swap(var s0, s1: tb2_vec2); inline; overload;
  procedure b2_swap(var s0, s1: tb2_vec3); inline; overload;
  procedure b2_swap(var s0, s1: tb2_rot); inline; overload;
  procedure b2_swap(var s0, s1: tb2_mat22); inline; overload;
  procedure b2_swap(var s0, s1: tb2_mat33); inline; overload;
  procedure b2_swap(var s0, s1: tb2_transform); inline; overload;

  function b2_next_power_of_two(const n: tb2_uint32): tb2_uint32; inline;
  function b2_is_power_of_two(const n: tb2_uint32): boolean; inline;

  function b2_color(const r, g, b: tb2_float32; const a: tb2_float32 = 1.0): tb2_color; inline;

  operator - (const v0: tb2_vec2): tb2_vec2;
  operator = (const v0, v1: tb2_vec2): boolean;
  operator + (const v0, v1: tb2_vec2): tb2_vec2;
  operator - (const v0, v1: tb2_vec2): tb2_vec2;
  operator + (const v0: tb2_vec2; const s: tb2_float32): tb2_vec2;
  operator + (const s: tb2_float32; const v0: tb2_vec2): tb2_vec2;
  operator - (const v0: tb2_vec2; const s: tb2_float32): tb2_vec2;
  operator * (const v0: tb2_vec2; const s: tb2_float32): tb2_vec2;
  operator * (const s: tb2_float32; const v0: tb2_vec2): tb2_vec2;
  operator / (const v0: tb2_vec2; const s: tb2_float32): tb2_vec2;

  operator - (const v0: tb2_vec3): tb2_vec3;
  operator = (const v0, v1: tb2_vec3): boolean;
  operator + (const v0, v1: tb2_vec3): tb2_vec3;
  operator - (const v0, v1: tb2_vec3): tb2_vec3;
  operator + (const v0: tb2_vec3; const s: tb2_float32): tb2_vec3;
  operator + (const s: tb2_float32; const v0: tb2_vec3): tb2_vec3;
  operator - (const v0: tb2_vec3; const s: tb2_float32): tb2_vec3;
  operator * (const v0: tb2_vec3; const s: tb2_float32): tb2_vec3;
  operator * (const s: tb2_float32; const v0: tb2_vec3): tb2_vec3;
  operator / (const v0: tb2_vec3; const s: tb2_float32): tb2_vec3;

  operator + (const m0, m1: tb2_mat22): tb2_mat22;

const b2_version: tb2_version = (major: 2; minor: 3; revision: 1);

var
  b2_gjk_calls, b2_gjk_iters, b2_gjk_max_iters: tb2_int32;
  b2_toi_time, b2_toi_max_time: tb2_float32;
  b2_toi_calls, b2_toi_iters, b2_toi_max_iters: tb2_int32;
  b2_toi_root_iters, b2_toi_max_root_iters: tb2_int32;
  b2_block_solve: boolean = true;

implementation

var
  b2_contact_registers: array [0..longint(b2_st_type_count) - 1, 0..longint(b2_st_type_count) - 1] of tb2_contact_register;
  b2_contact_initialized: boolean = false;

  b2_default_filter: tb2_contact_filter = nil;
  b2_default_listener: tb2_contact_listener = nil;

//tb2_vec2 BEGIN
function tb2_vec2.get_arr(const index: tb2_int32): tb2_float32;
begin
  result := pb2_float32_arr(@x)^[index];
end;

procedure tb2_vec2.set_arr(const index: tb2_int32; const value: tb2_float32);
begin
  pb2_float32_arr(@x)^[index] := value;
end;

procedure tb2_vec2.set_value(const vx, vy: tb2_float32);
begin
  x := vx;
  y := vy;
end;

procedure tb2_vec2.set_zero;
begin
  x := 0;
  y := 0;
end;

function tb2_vec2.len: tb2_float32;
begin
  result := b2_sqrt(x * x + y * y);
end;

function tb2_vec2.len_sq: tb2_float32;
begin
  result := x * x + y * y;
end;

function tb2_vec2.normalize: tb2_float32;
  var l, l_rcp: tb2_float32;
begin
  l := len;
  if (l < b2_epsilon) then
  begin
    result := 0.0;
    exit;
  end;
  l_rcp := 1.0 / l;
  x *= l_rcp;
  y *= l_rcp;
  result := l;
end;

function tb2_vec2.is_valid: boolean;
begin
  result := b2_is_valid(x) and b2_is_valid(y);
end;

function tb2_vec2.skew: tb2_vec2;
begin
  result.x := -y;
  result.y := x;
end;
//tb2_vec2 END

//tb2_vec3 BEGIN
function tb2_vec3.get_arr(const index: tb2_int32): tb2_float32;
begin
  result := pb2_float32_arr(@x)^[index];
end;

procedure tb2_vec3.set_arr(const index: tb2_int32; const value: tb2_float32);
begin
  pb2_float32_arr(@x)^[index] := value;
end;

procedure tb2_vec3.set_value(const vx, vy, vz: tb2_float32);
begin
  x := vx;
  y := vy;
  z := vz;
end;

procedure tb2_vec3.set_zero;
begin
  x := 0;
  y := 0;
  z := 0;
end;
//tb2_vec3 END

//tb2_mat22 BEGIN
function tb2_mat22.get_arr(const index: tb2_int32): tb2_float32;
begin
  result := pb2_float32_arr(@ex.x)^[index];
end;

procedure tb2_mat22.set_arr(const index: tb2_int32; const value: tb2_float32);
begin
  pb2_float32_arr(@ex.x)^[index] := value;
end;

procedure tb2_mat22.set_value(const vc0, vc1: tb2_vec2);
begin
  ex := vc0;
  ey := vc1;
end;

procedure tb2_mat22.set_value(const ve00, ve01, ve10, ve11: tb2_float32);
begin
  ex.x := ve00; ex.y := ve10;
  ey.x := ve01; ey.y := ve11;
end;

procedure tb2_mat22.set_identity;
begin
  ex.x := 1.0; ey.x := 0.0;
  ex.y := 0.0; ey.y := 1.0;
end;

procedure tb2_mat22.set_zero;
begin
  ex.x := 0.0; ey.x := 0.0;
  ex.y := 0.0; ey.y := 0.0;
end;

function tb2_mat22.get_inverse: tb2_mat22;
  var a, b, c, d, det: tb2_float32;
begin
  a := ex.x; b := ey.x; c := ex.y; d := ey.y;
  det := a * d - b * c;
  if det <> 0.0 then det := 1.0 / det;
  result.ex.x := det * d; result.ey.x := -det * b;
  result.ex.y := -det * c; result.ey.y := det * a;
end;

function tb2_mat22.solve(const v: tb2_vec2): tb2_vec2;
  var a00, a01, a10, a11, det: tb2_float32;
begin
  a00 := ex.x; a01 := ey.x; a10 := ex.y; a11 := ey.y;
  det := a00 * a11 - a01 * a10;
  if det <> 0.0 then det := 1.0 / det;
  result.x := det * (a11 * v.x - a01 * v.y);
  result.y := det * (a00 * v.y - a10 * v.x);
end;
//tb2_mat22 END

//tb2_mat33 BEGIN
function tb2_mat33.get_arr(const index: tb2_int32): tb2_float32;
begin
  result := pb2_float32_arr(@ex)^[index];
end;

procedure tb2_mat33.set_arr(const index: tb2_int32; const value: tb2_float32);
begin
  pb2_float32_arr(@ex)^[index] := value;
end;

procedure tb2_mat33.set_value(const vc0, vc1, vc2: tb2_vec3);
begin
  ex := vc0;
  ey := vc1;
  ez := vc2;
end;

procedure tb2_mat33.set_identity;
begin
  ex.set_value(1.0, 0.0, 0.0);
  ey.set_value(0.0, 1.0, 0.0);
  ez.set_value(0.0, 0.0, 1.0);
end;

procedure tb2_mat33.set_zero;
begin
  ex.set_zero;
  ey.set_zero;
  ez.set_zero;
end;

function tb2_mat33.solve33(const v: tb2_vec3): tb2_vec3;
  var det: tb2_float32;
begin
  det := b2_dot(ex, b2_cross(ey, ez));
  if det <> 0.0 then det := 1.0 / det;
  result.x := det * b2_dot(v, b2_cross(ey, ez));
  result.y := det * b2_dot(ex, b2_cross(v, ez));
  result.z := det * b2_dot(ex, b2_cross(ey, v));
end;

function tb2_mat33.solve22(const v: tb2_vec2): tb2_vec2;
  var a00, a01, a10, a11, det: tb2_float32;
begin
  a00 := ex.x; a01 := ey.x; a10 := ex.y; a11 := ey.y;
  det := a00 * a11 - a01 * a10;
  if det <> 0.0 then det := 1.0 / det;
  result.x := det * (a11 * v.x - a01 * v.y);
  result.y := det * (a00 * v.y - a10 * v.x);
end;

procedure tb2_mat33.get_inverse22(const m: pb2_mat33);
  var a, b, c, d, det: tb2_float32;
begin
  a := ex.x; b := ey.x; c := ex.y; d := ey.y;
  det := a * d - b * c;
  if det <> 0.0 then det := 1.0 / det;
  m^.ex.x := det * d; m^.ey.x := -det * b; m^.ex.z := 0.0;
  m^.ex.y := -det * c; m^.ey.y := det * a; m^.ey.z := 0.0;
  m^.ez.x := 0.0; M^.ez.y := 0.0; M^.ez.z := 0.0;
end;

procedure tb2_mat33.get_sym_inverse33(const m: pb2_mat33);
  var a00, a01, a02, a11, a12, a22, det: tb2_float32;
begin
  det := b2_dot(ex, b2_cross(ey, ez));
  if det <> 0.0 then det := 1.0 / det;

  a00 := ex.x; a01 := ey.x; a02 := ez.x;
  a11 := ey.y; a12 := ez.y;
  a22 := ez.z;

  M^.ex.x := det * (a11 * a22 - a12 * a12);
  M^.ex.y := det * (a02 * a12 - a01 * a22);
  M^.ex.z := det * (a01 * a12 - a02 * a11);

  M^.ey.x := M^.ex.y;
  M^.ey.y := det * (a00 * a22 - a02 * a02);
  M^.ey.z := det * (a02 * a01 - a00 * a12);

  M^.ez.x := M^.ex.z;
  M^.ez.y := M^.ey.z;
  M^.ez.z := det * (a00 * a11 - a01 * a01);
end;
//tb2_mat33 END

//tb2_rot BEGIN
procedure tb2_rot.set_value(const angle: tb2_float32);
begin
  s := sin(angle);
  c := cos(angle);
end;

procedure tb2_rot.set_value(const vs, vc: tb2_float32);
begin
  s := vs;
  c := vc;
end;

procedure tb2_rot.set_identity;
begin
  s := 0.0;
  c := 1.0;
end;

function tb2_rot.get_angle: tb2_float32;
begin
  result := b2_atan2(s, c);
end;

function tb2_rot.get_x_axis: tb2_vec2;
begin
  result := b2_vec2(c, s);
end;

function tb2_rot.get_y_axis: tb2_vec2;
begin
  result := b2_vec2(-s, c);
end;
//tb2_rot END

//tb2_transform BEGIN
procedure tb2_transform.set_value(const position: tb2_vec2; const rotation: tb2_rot);
begin
  p := position;
  q := rotation;
end;

procedure tb2_transform.set_value(const position: tb2_vec2; const angle: tb2_float32);
begin
  p := position;
  q.set_value(angle);
end;

procedure tb2_transform.set_identity;
begin
  p.set_zero;
  q.set_identity;
end;
//tb2_transform END

//tb2_sweep BEGIN
procedure tb2_sweep.get_transform(const xf: pb2_transform; const beta: tb2_float32);
begin
  xf^.p := (1.0 - beta) * c0 + beta * c;
  xf^.q.set_value((1.0 - beta) * a0 + beta * a);
  xf^.p := xf^.p - b2_mul(xf^.q, local_center);
end;

procedure tb2_sweep.advance(const alpha: tb2_float32);
  var beta: tb2_float32;
begin
  beta := (alpha - alpha0) / (1.0 - alpha0);
  c0 += beta * (c - c0);
  a0 += beta * (a - a0);
  alpha0 := alpha;
end;

procedure tb2_sweep.normalize;
  var d: tb2_float32;
begin
  d := b2_two_pi * trunc(a0 / b2_two_pi);
  a0 -= d;
  a -= d;
end;
//tb2_sweep END

//tb2_color BEGIN
procedure tb2_color.set_value(const vr, vg, vb: tb2_float32; const va: tb2_float32);
begin
  r := vr; g := vg; b := vb; a := va;
end;
//tb2_color END

//tb2_draw BEGIN
constructor tb2_draw.create;
begin
  inherited create;
  _draw_flags := [];
end;

destructor tb2_draw.destroy;
begin
  inherited destroy;
end;
//tb2_draw DND

//tb2_growable_stack BEGIN
constructor tb2_growable_stack.create;
begin
  _stack := pt_arr(@_array);
  _count := 0;
  _capacity := length(_array);
end;

destructor tb2_growable_stack.destroy;
begin
  if _stack <> @_array then
  begin
    b2_free(_stack);
    _stack := nil;
  end;
end;

procedure tb2_growable_stack.push(const element: T);
  var old: pt_arr;
begin
  if _count = _capacity then
  begin
    old := _stack;
    _capacity *= 2;
    _stack := pt_arr(b2_alloc(_capacity * sizeof(T)));
    move(old^, _stack^, _count * sizeof(T));
    if old <> @_array then
    b2_free(old);
  end;
  _stack^[_count] := element;
  inc(_count);
end;

function tb2_growable_stack.pop: T;
begin
  dec(_count);
  result := _stack^[_count];
end;

function tb2_growable_stack.get_count: tb2_int32;
begin
  result := _count;
end;
//tb2_growable_stack END

//tb2_block_allocator BEGIN
constructor tb2_block_allocator.create;
  var i, j: tb2_int32;
begin
  _chunk_space := b2_chunk_array_increment;
  _chunk_count := 0;
  _chunks := pb2_chunk_arr(b2_alloc(_chunk_space * sizeof(tb2_chunk)));

  fillchar(_chunks^, _chunk_space * sizeof(tb2_chunk), 0);
  fillchar(_free_lists, sizeof(_free_lists), 0);

  if not _block_size_lookup_initialized then
  begin
    j := 0;
    for i := 1 to b2_max_block_size do
    begin
      if i > _block_sizes[j] then
      inc(j);
      _block_size_lookup[i] := tb2_uint8(j);
    end;
    _block_size_lookup_initialized := true;
  end;
end;

destructor tb2_block_allocator.destroy;
  var i: tb2_int32;
begin
  for i := 0 to _chunk_count - 1 do
  b2_free(_chunks^[i].blocks);
  b2_free(_chunks);
end;

function tb2_block_allocator.alloc(const size: tb2_int32): tb2_ptr;
  var index, block_size, block_count, i: tb2_int32;
  var block, next, last: pb2_block;
  var chunk: pb2_chunk;
  var old_chunks: pb2_chunk_arr;
begin
  if size <= 0 then
  begin
    result := nil;
    exit;
  end;
  if size > b2_max_block_size then
  begin
    result := b2_alloc(size);
    exit;
  end;
  index := _block_size_lookup[size];
  if _free_lists[index] <> nil then
  begin
    block := _free_lists[index];
    _free_lists[index] := block^.next;
    result := block;
    exit;
  end
  else
  begin
    if _chunk_count = _chunk_space then
    begin
      old_chunks := _chunks;
      _chunk_space += b2_chunk_array_increment;
      _chunks := pb2_chunk_arr(b2_alloc(_chunk_space * sizeof(tb2_chunk)));
      move(old_chunks^, _chunks^, _chunk_count * sizeof(tb2_chunk));
      fillchar(_chunks^[_chunk_count], b2_chunk_array_increment * sizeof(tb2_chunk), 0);
      b2_free(old_chunks);
    end;
    chunk := @_chunks^[_chunk_count];
    chunk^.blocks := pb2_block(b2_alloc(b2_chunk_size));
    block_size := _block_sizes[index];
    chunk^.block_size := block_size;
    block_count := b2_chunk_size div block_size;
    for i := 0 to block_count - 2 do
    begin
      block := pb2_block(pb2_int8(chunk^.blocks) + block_size * i);
      next := pb2_block(pb2_int8(chunk^.blocks) + block_size * (i + 1));
      block^.next := next;
    end;
    last := pb2_block(pb2_int8(chunk^.blocks) + block_size * (block_count - 1));
    last^.next := nil;

    _free_lists[index] := chunk^.blocks^.next;
    inc(_chunk_count);
    result := chunk^.blocks;
  end;
end;

procedure tb2_block_allocator.free(var p: tb2_ptr; const size: tb2_int32);
  var index: tb2_int32;
  var block: pb2_block;
begin
  if size <= 0 then exit;
  if size > b2_max_block_size then
  begin
    b2_free(p);
    exit;
  end;
  index := _block_size_lookup[size];
  block := pb2_block(p);
  block^.next := _free_lists[index];
  _free_lists[index] := block;
end;

procedure tb2_block_allocator.clear;
  var i: tb2_int32;
begin
  for i := 0 to _chunk_count - 1 do
  b2_free(_chunks^[i].blocks);
  _chunk_count := 0;
  fillchar(_chunks^, _chunk_space * sizeof(tb2_chunk), 0);
  fillchar(_free_lists, sizeof(_free_lists), 0);
end;
//tb2_block_allocator END

//tb2_stack_allocator BEGIN
constructor tb2_stack_allocator.create;
begin
  _index := 0;
  _allocation := 0;
  _max_allocation := 0;
  _entry_count := 0;
end;

destructor tb2_stack_allocator.destroy;
begin
end;

function tb2_stack_allocator.alloc(const size: tb2_int32): tb2_ptr;
  var entry: pb2_stack_entry;
begin
  entry := @_entries[_entry_count];
  entry^.size := size;
  if _index + size > b2_stack_size then
  begin
    entry^.data := pb2_uint8_arr(b2_alloc(size));
    entry^.used_malloc := true;
  end
  else
  begin
    entry^.data := pb2_uint8_arr(@_data[_index]);
    entry^.used_malloc := false;
    _index += size;
  end;
  _allocation += size;
  _max_allocation := b2_max(_max_allocation, _allocation);
  inc(_entry_count);
  result := entry^.data;
end;

procedure tb2_stack_allocator.free(var p: tb2_ptr);
  var entry: pb2_stack_entry;
begin
  entry := @_entries[_entry_count - 1];
  if entry^.used_malloc then
  b2_free(p)
  else
  _index -= entry^.size;
  _allocation -= entry^.size;
  dec(_entry_count);
  p := nil;
end;

function tb2_stack_allocator.get_max_allocation: tb2_int32;
begin
  result := _max_allocation;
end;
//tb2_stack_allocator END

//tb2_timer BEGIN
{$if defined(WIN32)}
constructor tb2_timer.create;
  var frequency: tlargeinteger;
begin
  {$hints off}
  queryperformancefrequency(frequency);
  {$hints on}
  _inv_frequency := tb2_float64(frequency);
  if _inv_frequency > 0.0 then
  _inv_frequency := 1000.0 / _inv_frequency;
  queryperformancecounter(frequency);
  _start := tb2_float64(frequency);
end;

procedure tb2_timer.reset;
  var counter: tlargeinteger;
begin
  {$hints off}
  queryperformancecounter(counter);
  {$hints on}
  _start := tb2_float64(counter);
end;

function tb2_timer.get_milliseconds: tb2_float32;
  var counter: tlargeinteger;
  var count: tb2_float64;
begin
  {$hints off}
  queryperformancecounter(counter);
  {$hints on}
  count := tb2_float64(counter);
  result := tb2_float32(_inv_frequency * (count - _start));
end;
{$elseif defined(UNIX)}
constructor tb2_timer.create;
begin
  reset;
end;

procedure tb2_timer.reset;
  var t: timespec;
begin
  clock_gettime(CLOCK_MONOTONIC_RAW, @t);
  _start_sec := t.tv_sec;
  _start_usec := t.tv_nsec;
end;

function tb2_timer.get_milliseconds: tb2_float32;
  var t: timespec;
begin
  clock_gettime(CLOCK_MONOTONIC_RAW, @t);
  result := 1000.0 * (t.tv_sec - _start_sec) + 0.001 * (t.tv_nsec - _start_usec);
end;
{$else}
constructor tb2_timer.create;
begin
end;

procedure tb2_timer.reset;
begin
end;

function tb2_timer.get_milliseconds: tb2_float32;
begin
  result := 0.0;
end;
{$endif}
//tb2_timer END

{$hints off}
function b2_create_circle_contact(
  const fixture_a: pb2_fixture; const index_a: tb2_int32;
  const fixture_b: pb2_fixture; const index_b: tb2_int32;
  const allocator: pb2_block_allocator
): pb2_contact;
begin
  result := pb2_contact(allocator^.alloc(sizeof(tb2_circle_contact)));
  pb2_circle_contact(result)^.create_circle_contact(fixture_a, fixture_b);
end;
{$hints on}

procedure b2_destroy_circle_contact(var contact: pb2_contact; const allocator: pb2_block_allocator);
begin
  contact^.destroy;
  allocator^.free(contact, sizeof(tb2_circle_contact));
end;

{$hints off}
function b2_create_polygon_and_circle_contact(
  const fixture_a: pb2_fixture; const index_a: tb2_int32;
  const fixture_b: pb2_fixture; const index_b: tb2_int32;
  const allocator: pb2_block_allocator
): pb2_contact;
begin
  result := pb2_contact(allocator^.alloc(sizeof(tb2_polygon_and_circle_contact)));
  pb2_polygon_and_circle_contact(result)^.create_polygon_and_circle_contact(fixture_a, fixture_b);
end;
{$hints on}

procedure b2_destroy_polygon_and_circle_contact(var contact: pb2_contact; const allocator: pb2_block_allocator);
begin
  contact^.destroy;
  allocator^.free(contact, sizeof(tb2_polygon_and_circle_contact));
end;

{$hints off}
function b2_create_polygon_contact(
  const fixture_a: pb2_fixture; const index_a: tb2_int32;
  const fixture_b: pb2_fixture; const index_b: tb2_int32;
  const allocator: pb2_block_allocator
): pb2_contact;
begin
  result := pb2_contact(allocator^.alloc(sizeof(tb2_polygon_contact)));
  pb2_polygon_contact(result)^.create_polygon_contact(fixture_a, fixture_b);
end;
{$hints on}

procedure b2_destroy_polygon_contact(var contact: pb2_contact; const allocator: pb2_block_allocator);
begin
  contact^.destroy;
  allocator^.free(contact, sizeof(tb2_polygon_contact));
end;

{$hints off}
function b2_create_edge_and_circle_contact(
  const fixture_a: pb2_fixture; const index_a: tb2_int32;
  const fixture_b: pb2_fixture; const index_b: tb2_int32;
  const allocator: pb2_block_allocator
): pb2_contact;
begin
  result := allocator^.alloc(sizeof(tb2_edge_and_circle_contact));
  pb2_edge_and_circle_contact(result)^.create_edge_and_circle_contact(fixture_a, fixture_b);
end;
{$hints on}

procedure b2_destroy_edge_and_circle_contact(var contact: pb2_contact; const allocator: pb2_block_allocator);
begin
  contact^.destroy;
  allocator^.free(contact, sizeof(tb2_edge_and_circle_contact));
end;

{$hints off}
function b2_create_edge_and_polygon_contact(
  const fixture_a: pb2_fixture; const index_a: tb2_int32;
  const fixture_b: pb2_fixture; const index_b: tb2_int32;
  const allocator: pb2_block_allocator
): pb2_contact;
begin
  result := allocator^.alloc(sizeof(tb2_edge_and_polygon_contact));
  pb2_edge_and_polygon_contact(result)^.create_edge_and_polygon_contact(fixture_a, fixture_b);
end;
{$hints on}

procedure b2_destroy_edge_and_polygon_contact(var contact: pb2_contact; const allocator: pb2_block_allocator);
begin
  contact^.destroy;
  allocator^.free(contact, sizeof(tb2_edge_and_polygon_contact));
end;

function b2_create_chain_and_circle_contact(
  const fixture_a: pb2_fixture; const index_a: tb2_int32;
  const fixture_b: pb2_fixture; const index_b: tb2_int32;
  const allocator: pb2_block_allocator
): pb2_contact;
begin
  result := pb2_contact(allocator^.alloc(sizeof(tb2_chain_and_circle_contact)));
  pb2_chain_and_circle_contact(result)^.create_chain_and_circle_contact(fixture_a, index_a, fixture_b, index_b);
end;

procedure b2_destroy_chain_and_circle_contact(var contact: pb2_contact; const allocator: pb2_block_allocator);
begin
  contact^.destroy;
  allocator^.free(contact, sizeof(tb2_chain_and_circle_contact));
end;

function b2_create_chain_and_polygon_contact(
  const fixture_a: pb2_fixture; const index_a: tb2_int32;
  const fixture_b: pb2_fixture; const index_b: tb2_int32;
  const allocator: pb2_block_allocator
): pb2_contact;
begin
  result := allocator^.alloc(sizeof(tb2_chain_and_polygon_contact));
  pb2_chain_and_polygon_contact(result)^.create_chain_and_polygon_contact(fixture_a, index_a, fixture_b, index_b);
end;

procedure b2_destroy_chain_and_polygon_contact(var contact: pb2_contact; const allocator: pb2_block_allocator);
begin
  contact^.destroy;
  allocator^.free(contact, sizeof(tb2_chain_and_polygon_contact));
end;

//tb2_world_manifold BEGIN
procedure tb2_world_manifold.initialize(
  const manifold: pb2_manifold;
  const xf_a: tb2_transform; const radius_a: tb2_float32;
  const xf_b: tb2_transform; const radius_b: tb2_float32
);
  var point_a, point_b, c_a, c_b, plane_point, clip_point: tb2_vec2;
  var i: tb2_int32;
begin
  if manifold^.point_count = 0 then exit;
  case manifold^.manifold_type of
    b2_mt_circles:
    begin
      normal.set_value(1.0, 0.0);
      point_a := b2_mul(xf_a, manifold^.local_point);
      point_b := b2_mul(xf_b, manifold^.points[0].local_point);
      if b2_distance_sq(point_a, point_b) > b2_epsilon * b2_epsilon then
      begin
        normal := point_b - point_a;
        normal.normalize;
      end;
      c_a := point_a + radius_a * normal;
      c_b := point_b - radius_b * normal;
      points[0] := 0.5 * (c_a + c_b);
      separations[0] := b2_dot(c_b - c_a, normal);
    end;
    b2_mt_face_a:
    begin
      normal := b2_mul(xf_a.q, manifold^.local_normal);
      plane_point := b2_mul(xf_a, manifold^.local_point);
      for i := 0 to manifold^.point_count - 1 do
      begin
	clip_point := b2_mul(xf_b, manifold^.points[i].local_point);
	c_a := clip_point + (radius_a - b2_dot(clip_point - plane_point, normal)) * normal;
	c_b := clip_point - radius_b * normal;
	points[i] := 0.5 * (c_a + c_b);
	separations[i] := b2_dot(c_b - c_a, normal);
      end;
    end;
    b2_mt_face_b:
    begin
      normal := b2_mul(xf_b.q, manifold^.local_normal);
      plane_point := b2_mul(xf_b, manifold^.local_point);
      for i := 0 to manifold^.point_count - 1 do
      begin
	clip_point := b2_mul(xf_a, manifold^.points[i].local_point);
	c_b := clip_point + (radius_b - b2_dot(clip_point - plane_point, normal)) * normal;
	c_a := clip_point - radius_a * normal;
	points[i] := 0.5 * (c_a + c_b);
	separations[i] := b2_dot(c_a - c_b, normal);
      end;
      normal := -normal;
    end;
  end
end;
//tb2_world_manifold END

//tb2_aabb BEGIN
function tb2_aabb.is_valid: boolean;
begin
  result := (
    (upper_bound.x >= lower_bound.x)
    and (upper_bound.y >= lower_bound.y)
    and lower_bound.is_valid
    and upper_bound.is_valid
  );
end;

function tb2_aabb.get_center: tb2_vec2;
begin
  result := 0.5 * (lower_bound + upper_bound);
end;

function tb2_aabb.get_extents: tb2_vec2;
begin
  result := 0.5 * (upper_bound - lower_bound);
end;

function tb2_aabb.get_perimeter: tb2_float32;
begin
  result := 2.0 * (upper_bound.x - lower_bound.x + upper_bound.y - lower_bound.y);
end;

procedure tb2_aabb.combine(const aabb: tb2_aabb);
begin
  lower_bound := b2_min(lower_bound, aabb.lower_bound);
  upper_bound := b2_max(upper_bound, aabb.upper_bound);
end;

procedure tb2_aabb.combine(const aabb1, aabb2: tb2_aabb);
begin
  lower_bound := b2_min(aabb1.lower_bound, aabb2.lower_bound);
  upper_bound := b2_max(aabb1.upper_bound, aabb2.upper_bound);
end;

function tb2_aabb.contains(const aabb: tb2_aabb): boolean;
begin
  result := true;
  result := result and (lower_bound.x <= aabb.lower_bound.x);
  result := result and (lower_bound.y <= aabb.lower_bound.y);
  result := result and (aabb.upper_bound.x <= upper_bound.x);
  result := result and (aabb.upper_bound.y <= upper_bound.y);
end;

function tb2_aabb.ray_cast(var output: tb2_ray_cast_output; const input: tb2_ray_cast_input): boolean;
  var tmin, tmax, rcp_d, t1, t2, s: tb2_float32;
  var p, d, abs_d, normal: tb2_vec2;
  var i: tb2_int32;
begin
  tmin := -b2_max_float;
  tmax := b2_max_float;
  p := input.p1;
  d := input.p2 - input.p1;
  abs_d := b2_abs(d);
  for i := 0 to 1 do
  begin
    if abs_d[i] < b2_epsilon then
    begin
      if (p[i] < lower_bound[i]) or (upper_bound[i] < p[i]) then
      begin
        result := false;
        exit;
      end;
    end
    else
    begin
      rcp_d := 1.0 / d[i];
      t1 := (lower_bound[i] - p[i]) * rcp_d;
      t2 := (upper_bound[i] - p[i]) * rcp_d;
      s := -1.0;
      if t1 > t2 then
      begin
	b2_swap(t1, t2);
        s := 1.0;
      end;
      if t1 > tmin then
      begin
	normal.set_zero;
	normal[i] := s;
	tmin := t1;
      end;
      tmax := b2_min(tmax, t2);
      if tmin > tmax then
      begin
        result := false;
      end;
    end;
  end;
  if (tmin < 0.0) or (input.max_fraction < tmin) then
  begin
    result := false;
    exit;
  end;
  output.fraction := tmin;
  output.normal := normal;
  result := true;
end;
//tb2_aabb END

//tb2_distance_proxy BEGIN
constructor tb2_distance_proxy.create;
begin
  vertices := nil;
  count := 0;
  radius := 0.0;
end;

destructor tb2_distance_proxy.destroy;
begin
end;

procedure tb2_distance_proxy.set_shape(const shape: pb2_shape; const index: tb2_int32);
  var circle: pb2_circle_shape absolute shape;
  var polygon: pb2_polygon_shape absolute shape;
  var chain: pb2_chain_shape absolute shape;
  var edge: pb2_edge_shape absolute shape;
begin
  case (shape^.get_type) of
    b2_st_circle:
    begin
      vertices := pb2_vec2_arr(@circle^.center);
      count := 1;
      radius := circle^.radius;
    end;
    b2_st_polygon:
    begin
      vertices := pb2_vec2_arr(@polygon^.vertices);
      count := polygon^.count;
      radius := polygon^.radius;
    end;
    b2_st_chain:
    begin
      buffer[0] := chain^.vertices^[index];
      if index + 1 < chain^.count then buffer[1] := chain^.vertices^[index + 1]
      else buffer[1] := chain^.vertices^[0];
      vertices := pb2_vec2_arr(@buffer);
      count := 2;
      radius := chain^.radius;
    end;
    b2_st_edge:
    begin
      vertices := pb2_vec2_arr(@edge^.vertex1);
      count := 2;
      radius := edge^.radius;
    end;
  end;
end;

function tb2_distance_proxy.get_support(const d: tb2_vec2): tb2_int32;
  var best_index, i: tb2_int32;
  var best_value, value: tb2_float32;
begin
  best_index := 0;
  best_value := b2_dot(vertices^[0], d);
  for i := 1 to count - 1 do
  begin
    value := b2_dot(vertices^[i], d);
    if value > best_value then
    begin
      best_index := i;
      best_value := value;
    end;
  end;
  result := best_index;
end;

function tb2_distance_proxy.get_support_vertex(const d: tb2_vec2): tb2_vec2;
begin
  result := vertices^[get_support(d)];
end;

function tb2_distance_proxy.get_vertex_count: tb2_int32;
begin
  result := count;
end;

function tb2_distance_proxy.get_vertex(const index: tb2_int32): tb2_vec2;
begin
  result := vertices^[index];
end;
//tb2_distance_proxy END

//tb2_simplex BEGIN
procedure tb2_simplex.read_cache(
  const cache: pb2_simplex_cache;
  const proxy_a: pb2_distance_proxy; const xf_a: tb2_transform;
  const proxy_b: pb2_distance_proxy; const xf_b: tb2_transform
);
  var vertices: pb2_simplex_vertex_arr;
  var v: pb2_simplex_vertex;
  var i: tb2_int32;
  var w_a_local, w_b_local: tb2_vec2;
  var metric1, metric2: tb2_float32;
begin
  count := cache^.count;
  vertices := pb2_simplex_vertex_arr(@v1);
  for i := 0 to count - 1 do
  begin
    v := @vertices^[i];
    v^.index_a := cache^.index_a[i];
    v^.index_b := cache^.index_b[i];
    w_a_local := proxy_a^.get_vertex(v^.index_a);
    w_b_local := proxy_b^.get_vertex(v^.index_b);
    v^.w_a := b2_mul(xf_a, w_a_local);
    v^.w_b := b2_mul(xf_b, w_b_local);
    v^.w := v^.w_b - v^.w_a;
    v^.a := 0.0;
  end;
  if count > 1 then
  begin
    metric1 := cache^.metric;
    metric2 := get_metric;
    if (metric2 < 0.5 * metric1) or (2.0 * metric1 < metric2) or (metric2 < b2_epsilon) then
    count := 0;
  end;
  if count = 0 then
  begin
    v := @vertices^[0];
    v^.index_a := 0;
    v^.index_b := 0;
    w_a_local := proxy_a^.get_vertex(0);
    w_b_local := proxy_b^.get_vertex(0);
    v^.w_a := b2_mul(xf_a, w_a_local);
    v^.w_b := b2_mul(xf_b, w_b_local);
    v^.w := v^.w_b - v^.w_a;
    v^.a := 1.0;
    count := 1;
  end;
end;

procedure tb2_simplex.write_cache(const cache: pb2_simplex_cache);
  var vertices: pb2_simplex_vertex_arr;
  var i: tb2_int32;
begin
  cache^.metric := get_metric;
  cache^.count := tb2_uint16(count);
  vertices := pb2_simplex_vertex_arr(@v1);
  for i := 0 to count - 1 do
  begin
    cache^.index_a[i] := tb2_uint8(vertices^[i].index_a);
    cache^.index_b[i] := tb2_uint8(vertices^[i].index_b);
  end;
end;

function tb2_simplex.get_search_direction: tb2_vec2;
  var e12: tb2_vec2;
  var sgn: tb2_float32;
begin
  case count of
    1: result := -v1.w;
    2:
    begin
      e12 := v2.w - v1.w;
      sgn := b2_cross(e12, -v1.w);
      if sgn > 0.0 then
      result := b2_cross(1.0, e12)
      else
      result := b2_cross(e12, 1.0);
    end;
    else result := b2_vec2_zero;
  end;
end;

function tb2_simplex.get_closest_point: tb2_vec2;
begin
  case count of
    0: result := b2_vec2_zero;
    1: result := v1.w;
    2: result := v1.a * v1.w + v2.a * v2.w;
    3: result := b2_vec2_zero;
    else result := b2_vec2_zero;
  end;
end;

procedure tb2_simplex.get_witness_points(const p_a, p_b: pb2_vec2);
begin
  case count of
    1:
    begin
      p_a^ := v1.w_a;
      p_b^ := v1.w_b;
    end;
    2:
    begin
      p_a^ := v1.a * v1.w_a + v2.a * v2.w_a;
      p_b^ := v1.a * v1.w_b + v2.a * v2.w_b;
    end;
    3:
    begin
      p_a^ := v1.a * v1.w_a + v2.a * v2.w_a + v3.a * v3.w_a;
      p_b^ := p_a^;
    end;
    else
    begin
      p_a^ := b2_vec2_zero;
      p_b^ := b2_vec2_zero;
    end;
  end;
end;

function tb2_simplex.get_metric: tb2_float32;
begin
  case count of
    0: result := 0.0;
    1: result := 0.0;
    2: result := b2_distance(v1.w, v2.w);
    3: result := b2_cross(v2.w - v1.w, v3.w - v1.w);
    else result := 0.0;
  end;
end;

procedure tb2_simplex.solve2;
  var w1, w2, e12: tb2_vec2;
  var d12_2, d12_1, rcp_d12: tb2_float32;
begin
  w1 := v1.w;
  w2 := v2.w;
  e12 := w2 - w1;
  d12_2 := -b2_dot(w1, e12);
  if d12_2 <= 0.0 then
  begin
    v1.a := 1.0;
    count := 1;
    exit;
  end;
  d12_1 := b2_dot(w2, e12);
  if d12_1 <= 0.0 then
  begin
    v2.a := 1.0;
    count := 1;
    v1 := v2;
    exit;
  end;
  rcp_d12 := 1.0 / (d12_1 + d12_2);
  v1.a := d12_1 * rcp_d12;
  v2.a := d12_2 * rcp_d12;
  count := 2;
end;

procedure tb2_simplex.solve3;
  var w1, w2, w3, e12, e13, e23: tb2_vec2;
  var w1e12, w2e12, w1e13, w3e13, w2e23, w3e23: tb2_float32;
  var d12_1, d12_2, d13_1, d13_2, d23_1, d23_2: tb2_float32;
  var n123, d123_1, d123_2, d123_3: tb2_float32;
  var rcp_d12, rcp_d13, rcp_d23, rcp_d123: tb2_float32;
begin
  w1 := v1.w;
  w2 := v2.w;
  w3 := v3.w;
  e12 := w2 - w1;
  w1e12 := b2_dot(w1, e12);
  w2e12 := b2_dot(w2, e12);
  d12_1 := w2e12;
  d12_2 := -w1e12;
  e13 := w3 - w1;
  w1e13 := b2_dot(w1, e13);
  w3e13 := b2_dot(w3, e13);
  d13_1 := w3e13;
  d13_2 := -w1e13;
  e23 := w3 - w2;
  w2e23 := b2_dot(w2, e23);
  w3e23 := b2_dot(w3, e23);
  d23_1 := w3e23;
  d23_2 := -w2e23;
  n123 := b2_cross(e12, e13);
  d123_1 := n123 * b2_cross(w2, w3);
  d123_2 := n123 * b2_cross(w3, w1);
  d123_3 := n123 * b2_cross(w1, w2);
  if (d12_2 <= 0.0) and (d13_2 <= 0.0) then
  begin
    v1.a := 1.0;
    count := 1;
    exit;
  end;
  if (d12_1 > 0.0) and (d12_2 > 0.0) and (d123_3 <= 0.0) then
  begin
    rcp_d12 := 1.0 / (d12_1 + d12_2);
    v1.a := d12_1 * rcp_d12;
    v2.a := d12_2 * rcp_d12;
    count := 2;
    exit;
  end;
  if (d13_1 > 0.0) and (d13_2 > 0.0) and (d123_2 <= 0.0) then
  begin
    rcp_d13 := 1.0 / (d13_1 + d13_2);
    v1.a := d13_1 * rcp_d13;
    v3.a := d13_2 * rcp_d13;
    count := 2;
    v2 := v3;
    exit;
  end;
  if (d12_1 <= 0.0) and (d23_2 <= 0.0) then
  begin
    v2.a := 1.0;
    count := 1;
    v1 := v2;
    exit;
  end;
  if (d13_1 <= 0.0) and (d23_1 <= 0.0) then
  begin
    v3.a := 1.0;
    count := 1;
    v1 := v3;
    exit;
  end;
  if (d23_1 > 0.0) and (d23_2 > 0.0) and (d123_1 <= 0.0) then
  begin
    rcp_d23 := 1.0 / (d23_1 + d23_2);
    v2.a := d23_1 * rcp_d23;
    v3.a := d23_2 * rcp_d23;
    count := 2;
    v1 := v3;
    exit;
  end;
  rcp_d123 := 1.0 / (d123_1 + d123_2 + d123_3);
  v1.a := d123_1 * rcp_d123;
  v2.a := d123_2 * rcp_d123;
  v3.a := d123_3 * rcp_d123;
  count := 3;
end;
//tb2_simplex END

//tb2_distance_input BEGIN
constructor tb2_distance_input.create;
begin
  proxy_a.create;
  proxy_b.create;
end;

destructor tb2_distance_input.destroy;
begin
  proxy_a.destroy;
  proxy_b.destroy;
end;
//tb2_distance_input END

//tb2_shape BEGIN
constructor tb2_shape.create_shape;
begin

end;

destructor tb2_shape.destroy;
begin

end;

function tb2_shape.get_type: tb2_shape_type;
begin
  result := shape_type;
end;
//tb2_shape END

//tb2_circle_shape BEGIN
constructor tb2_circle_shape.create;
begin
  shape_type := b2_st_circle;
  radius := 0.0;
  center.set_zero;
end;

function tb2_circle_shape.clone(const allocator: pb2_block_allocator): pb2_shape;
begin
  result := pb2_shape(allocator^.alloc(sizeof(tb2_circle_shape)));
  pb2_circle_shape(result)^.create;
  pb2_circle_shape(result)^ := self;
end;

function tb2_circle_shape.get_child_count: tb2_int32;
begin
  result := 1;
end;

function tb2_circle_shape.test_point(const xf: tb2_transform; const p: tb2_vec2): boolean;
  var c, d: tb2_vec2;
begin
  c := xf.p + b2_mul(xf.q, center);
  d := p - c;
  result := b2_dot(d, d) <= radius * radius;
end;

{$hints off}
function tb2_circle_shape.ray_cast(
  var output: tb2_ray_cast_output; const input: tb2_ray_cast_input;
  const xf: tb2_transform; const child_index: tb2_int32
): boolean;
  var position, s, r: tb2_vec2;
  var a, b, c, rr, sigma: tb2_float32;
begin
  position := xf.p + b2_mul(xf.q, center);
  s := input.p1 - position;
  b := b2_dot(s, s) - radius * radius;
  r := input.p2 - input.p1;
  c := b2_dot(s, r);
  rr := b2_dot(r, r);
  sigma := c * c - rr * b;
  if (sigma < 0.0) or (rr < b2_epsilon) then
  begin
    result := false;
    exit;
  end;
  a := -(c + b2_sqrt(sigma));
  if (0.0 <= a) and (a <= input.max_fraction * rr) then
  begin
    a /= rr;
    output.fraction := a;
    output.normal := s + a * r;
    output.normal.normalize;
    result := true;
    exit;
  end;
  result := false;
end;
{$hints on}

{$hints off}
procedure tb2_circle_shape.compute_aabb(var aabb: tb2_aabb; const xf: tb2_transform; const child_index: tb2_int32);
  var p: tb2_vec2;
begin
  p := xf.p + b2_mul(xf.q, center);
  aabb.lower_bound.set_value(p.x - radius, p.y - radius);
  aabb.upper_bound.set_value(p.x + radius, p.y + radius);
end;
{$hints on}

procedure tb2_circle_shape.compute_mass(var mass_data: tb2_mass_data; const density: tb2_float32);
begin
  mass_data.mass := density * b2_pi * radius * radius;
  mass_data.center := center;
  mass_data.inertia := mass_data.mass * (0.5 * radius * radius + b2_dot(center, center));
end;

{$hints off}
function tb2_circle_shape.get_support(const d: tb2_vec2): tb2_int32;
begin
  result := 0;
end;
{$hints on}

{$hints off}
function tb2_circle_shape.get_support_vertex(const d: tb2_vec2): tb2_vec2;
begin
  result := center;
end;
{$hints on}

function tb2_circle_shape.get_vertex_count: tb2_int32;
begin
  result := 1;
end;

{$hints off}
function tb2_circle_shape.get_vertex(const index: tb2_int32): tb2_vec2;
begin
  result := center;
end;
{$hints on}
//tb2_circle_shape END

//tb2_edge_shape BEGIN
constructor tb2_edge_shape.create;
begin
  shape_type := b2_st_edge;
  radius := b2_polygon_radius;
  vertex0.x := 0.0;
  vertex0.y := 0.0;
  vertex3.x := 0.0;
  vertex3.y := 0.0;
  has_vertex0 := false;
  has_vertex3 := false;
end;

procedure tb2_edge_shape.set_edge(const v1, v2: tb2_vec2);
begin
  vertex1 := v1;
  vertex2 := v2;
  has_vertex0 := false;
  has_vertex3 := false;
end;

function tb2_edge_shape.clone(const allocator: pb2_block_allocator): pb2_shape;
begin
  result := pb2_shape(allocator^.alloc(sizeof(tb2_edge_shape)));
  pb2_edge_shape(result)^.create;
  pb2_edge_shape(result)^ := self;
end;

function tb2_edge_shape.get_child_count: tb2_int32;
begin
  result := 1;
end;

{$hints off}
function tb2_edge_shape.test_point(const xf: tb2_transform; const p: tb2_vec2): boolean;
begin
  result := false;
end;
{$hints on}

{$hints off}
function tb2_edge_shape.ray_cast(
  var output: tb2_ray_cast_output; const input: tb2_ray_cast_input;
  const xf: tb2_transform; const child_index: tb2_int32
): boolean;
  var p1, p2, d, v1, v2, e, normal, q, r: tb2_vec2;
  var numerator, denominator, t, rr, s: tb2_float32;
begin
  p1 := b2_mul_t(xf.q, input.p1 - xf.p);
  p2 := b2_mul_t(xf.q, input.p2 - xf.p);
  d := p2 - p1;
  v1 := vertex1;
  v2 := vertex2;
  e := v2 - v1;
  normal.set_value(e.y, -e.x);
  normal.normalize;
  numerator := b2_dot(normal, v1 - p1);
  denominator := b2_dot(normal, d);
  if denominator = 0.0 then
  begin
    result := false;
    exit;
  end;
  t := numerator / denominator;
  if (t < 0.0) or (input.max_fraction < t) then
  begin
    result := false;
    exit;
  end;
  q := p1 + t * d;
  r := v2 - v1;
  rr := b2_dot(r, r);
  if rr = 0.0 then
  begin
    result := false;
    exit;
  end;
  s := b2_dot(q - v1, r) / rr;
  if (s < 0.0) or (1.0 < s) then
  begin
    result := false;
    exit;
  end;
  output.fraction := t;
  if numerator > 0.0 then
  output.normal := -b2_mul(xf.q, normal)
  else
  output.normal := b2_mul(xf.q, normal);
  result := true;
end;
{$hints on}

{$hints off}
procedure tb2_edge_shape.compute_aabb(var aabb: tb2_aabb; const xf: tb2_transform; const child_index: tb2_int32);
  var v1, v2, lower, upper, r: tb2_vec2;
begin
  v1 := b2_mul(xf, vertex1);
  v2 := b2_mul(xf, vertex2);
  lower := b2_min(v1, v2);
  upper := b2_max(v1, v2);
  r.set_value(radius, radius);
  aabb.lower_bound := lower - r;
  aabb.upper_bound := upper + r;
end;
{$hints on}

{$hints off}
procedure tb2_edge_shape.compute_mass(var mass_data: tb2_mass_data; const density: tb2_float32);
begin
  mass_data.mass := 0.0;
  mass_data.center := 0.5 * (vertex1 + vertex2);
  mass_data.inertia := 0.0;
end;
{$hints on}
//tb2_edge_shape END

//tb2_chain_shape BEGIN
constructor tb2_chain_shape.create;
begin
  shape_type := b2_st_chain;
  radius := b2_polygon_radius;
  vertices := nil;
  count := 0;
  has_prev_vertex := false;
  has_next_vertex := false;
end;

destructor tb2_chain_shape.destroy;
begin
  clear;
end;

procedure tb2_chain_shape.clear;
begin
  if (vertices <> nil) then
  b2_free(vertices);
  count := 0;
end;

procedure tb2_chain_shape.set_loop(const new_vertices: pb2_vec2_arr; const vcount: tb2_int32);
begin
  clear;
  count := vcount + 1;
  vertices := pb2_vec2_arr(b2_alloc(count * sizeof(tb2_vec2)));
  move(new_vertices^, vertices^, vcount * sizeof(tb2_vec2));
  vertices^[vcount] := vertices^[0];
  prev_vertex := vertices^[count - 2];
  next_vertex := vertices^[1];
  has_prev_vertex := true;
  has_next_vertex := true;
end;

procedure tb2_chain_shape.set_chain(const new_vertices: pb2_vec2_arr; const vcount: tb2_int32);
begin
  clear;
  count := vcount;
  vertices := pb2_vec2_arr(b2_alloc(count * sizeof(tb2_vec2)));
  move(new_vertices^, vertices^, count * sizeof(tb2_vec2));
  has_prev_vertex := false;
  has_next_vertex := false;
  prev_vertex.set_zero;
  next_vertex.set_zero;
end;

procedure tb2_chain_shape.set_prev_vertex(const new_prev_vertex: tb2_vec2);
begin
  prev_vertex := new_prev_vertex;
  has_prev_vertex := true;
end;

procedure tb2_chain_shape.set_next_vertex(const new_next_vertex: tb2_vec2);
begin
  next_vertex := new_next_vertex;
  has_next_vertex := true;
end;

function tb2_chain_shape.clone(const allocator: pb2_block_allocator): pb2_shape;
begin
  result := pb2_chain_shape(allocator^.alloc(sizeof(tb2_chain_shape)));
  pb2_chain_shape(result)^.create;
  pb2_chain_shape(result)^.set_chain(vertices, count);
  pb2_chain_shape(result)^.prev_vertex := prev_vertex;
  pb2_chain_shape(result)^.next_vertex := next_vertex;
  pb2_chain_shape(result)^.has_prev_vertex := has_prev_vertex;
  pb2_chain_shape(result)^.has_next_vertex := has_next_vertex;
end;

function tb2_chain_shape.get_child_count: tb2_int32;
begin
  result := count - 1;
end;

procedure tb2_chain_shape.get_child_edge(const edge: pb2_edge_shape; const index: tb2_int32);
begin
  edge^.shape_type := b2_st_edge;
  edge^.radius := radius;
  edge^.vertex1 := vertices^[index + 0];
  edge^.vertex2 := vertices^[index + 1];
  if index > 0 then
  begin
    edge^.vertex0 := vertices^[index - 1];
    edge^.has_vertex0 := true;
  end
  else
  begin
    edge^.vertex0 := prev_vertex;
    edge^.has_vertex0 := has_prev_vertex;
  end;
  if index < count - 2 then
  begin
    edge^.vertex3 := vertices^[index + 2];
    edge^.has_vertex3 := true;
  end
  else
  begin
    edge^.vertex3 := next_vertex;
    edge^.has_vertex3 := has_next_vertex;
  end;
end;

{$hints off}
function tb2_chain_shape.test_point(const xf: tb2_transform; const p: tb2_vec2): boolean;
begin
  result := false;
end;
{$hints on}

function tb2_chain_shape.ray_cast(
  var output: tb2_ray_cast_output; const input: tb2_ray_cast_input;
  const xf: tb2_transform; const child_index: tb2_int32
): boolean;
  var edge_shape: tb2_edge_shape;
  var i1, i2: tb2_int32;
begin
  edge_shape.create;
  i1 := child_index;
  i2 := child_index + 1;
  if i2 = count then i2 := 0;
  edge_shape.vertex1 := vertices^[i1];
  edge_shape.vertex2 := vertices^[i2];
  result := edge_shape.ray_cast(output, input, xf, 0);
end;

procedure tb2_chain_shape.compute_aabb(var aabb: tb2_aabb; const xf: tb2_transform; const child_index: tb2_int32);
  var i1, i2: tb2_int32;
  var v1, v2: tb2_vec2;
begin
  i1 := child_index;
  i2 := child_index + 1;
  if i2 = count then i2 := 0;
  v1 := b2_mul(xf, vertices^[i1]);
  v2 := b2_mul(xf, vertices^[i2]);
  aabb.lower_bound := b2_min(v1, v2);
  aabb.upper_bound := b2_max(v1, v2);
end;

{$hints off}
procedure tb2_chain_shape.compute_mass(var mass_data: tb2_mass_data; const density: tb2_float32);
begin
  mass_data.mass := 0.0;
  mass_data.center.set_zero;
  mass_data.inertia := 0.0;
end;
{$hints on}
//tb2_chain_shape END

//tb2_polygon_shape BEGIN
function tb2_polygon_shape.compute_centroid(const vs: pb2_vec2_arr; const count: tb2_int32): tb2_vec2;
  var i: tb2_int32;
  var c, ref, p1, p2, p3, e1, e2: tb2_vec2;
  var area, d, triangle_area: tb2_float32;
  const rcp3 = 1.0 / 3.0;
begin
  c.set_value(0.0, 0.0);
  area := 0.0;
  ref.set_value(0.0, 0.0);
  for i := 0 to count - 1 do
  begin
    p1 := ref;
    p2 := vs^[i];
    if i + 1 < count then p3 := vs^[i + 1] else p3 := vs^[0];
    e1 := p2 - p1;
    e2 := p3 - p1;
    d := b2_cross(e1, e2);
    triangle_area := 0.5 * d;
    area += triangle_area;
    c := c + triangle_area * rcp3 * (p1 + p2 + p3);
  end;
  c *= 1.0 / area;
  result := c;
end;

constructor tb2_polygon_shape.create;
begin
  shape_type := b2_st_polygon;
  radius := b2_polygon_radius;
  count := 0;
  centroid.set_zero;
end;

function tb2_polygon_shape.clone(const allocator: pb2_block_allocator): pb2_shape;
begin
  result := pb2_shape(allocator^.alloc(sizeof(tb2_polygon_shape)));
  pb2_polygon_shape(result)^.create;
  pb2_polygon_shape(result)^ := self;
end;

function tb2_polygon_shape.get_child_count: tb2_int32;
begin
  result := 1;
end;

procedure tb2_polygon_shape.set_polygon(const points: pb2_vec2_arr; const vcount: tb2_int32);
  var i, j, n, temp_count, i0, m, ih, ie, i1, i2: tb2_int32;
  var ps: array [0..b2_max_polygon_vertices - 1] of tb2_vec2;
  var v, r, edge: tb2_vec2;
  var unique: boolean;
  var x0, x, c: tb2_float32;
  var hull: array [0..b2_max_polygon_vertices - 1] of tb2_int32;
begin
  if vcount < 3 then
  begin
    set_as_box(1.0, 1.0);
    exit;
  end;
  n := b2_min(vcount, b2_max_polygon_vertices);
  temp_count := 0;
  for i := 0 to n - 1 do
  begin
    v := points^[i];
    unique := true;
    for j := 0 to temp_count - 1 do
    begin
      {$warnings off}
      if b2_distance_sq(v, ps[j]) < 0.5 * b2_linear_slop then
      {$warnings on}
      begin
	unique := false;
	break;
      end;
    end;
    if unique then
    begin
      ps[temp_count] := v;
      inc(temp_count);
    end;
  end;
  n := temp_count;
  if n < 3 then
  begin
    set_as_box(1.0, 1.0);
    exit;
  end;
  i0 := 0;
  x0 := ps[0].x;
  for i := 1 to n - 1 do
  begin
    x := ps[i].x;
    if (x > x0) or ((x = x0) and (ps[i].y < ps[i0].y)) then
    begin
      i0 := i;
      x0 := x;
    end;
  end;
  m := 0;
  ih := i0;
  while true do
  begin
    hull[m] := ih;
    ie := 0;
    for j := 1 to n - 1 do
    begin
      if ie = ih then
      begin
	ie := j;
	continue;
      end;
      r := ps[ie] - ps[hull[m]];
      v := ps[j] - ps[hull[m]];
      c := b2_cross(r, v);
      if c < 0.0 then ie := j;
      if (c = 0.0) and (v.len_sq > r.len_sq) then ie := j;
    end;
    inc(m);
    ih := ie;
    if ie = i0 then break;
  end;
  if m < 3 then
  begin
    set_as_box(1.0, 1.0);
    exit;
  end;
  count := m;
  for i := 0 to m - 1 do
  vertices[i] := ps[hull[i]];
  for i := 0 to m - 1 do
  begin
    i1 := i;
    if i + 1 < m then i2 := i + 1 else i2 := 0;
    edge := vertices[i2] - vertices[i1];
    normals[i] := b2_cross(edge, 1.0);
    normals[i].normalize;
  end;
  centroid := compute_centroid(@vertices, m);
end;

procedure tb2_polygon_shape.set_as_box(const hx, hy: tb2_float32);
begin
  count := 4;
  vertices[0].set_value(-hx, -hy);
  vertices[1].set_value(hx, -hy);
  vertices[2].set_value(hx, hy);
  vertices[3].set_value(-hx, hy);
  normals[0].set_value(0.0, -1.0);
  normals[1].set_value(1.0, 0.0);
  normals[2].set_value(0.0, 1.0);
  normals[3].set_value(-1.0, 0.0);
  centroid.set_zero;
end;

procedure tb2_polygon_shape.set_as_box(const hx, hy: tb2_float32; const center: tb2_vec2; const angle: tb2_float32);
  var xf: tb2_transform;
  var i: tb2_int32;
begin
  count := 4;
  vertices[0].set_value(-hx, -hy);
  vertices[1].set_value(hx, -hy);
  vertices[2].set_value(hx, hy);
  vertices[3].set_value(-hx, hy);
  normals[0].set_value(0.0, -1.0);
  normals[1].set_value(1.0, 0.0);
  normals[2].set_value(0.0, 1.0);
  normals[3].set_value(-1.0, 0.0);
  centroid := center;
  xf.p := center;
  xf.q.set_value(angle);
  for i := 0 to count - 1 do
  begin
    vertices[i] := b2_mul(xf, vertices[i]);
    normals[i] := b2_mul(xf.q, normals[i]);
  end;
end;

function tb2_polygon_shape.test_point(const xf: tb2_transform; const p: tb2_vec2): boolean;
  var p_local: tb2_vec2;
  var i: tb2_int32;
  var dot: tb2_float32;
begin
  p_local := b2_mul_t(xf.q, p - xf.p);
  for i := 0 to count - 1  do
  begin
    dot := b2_dot(normals[i], p_local - vertices[i]);
    if dot > 0.0 then
    begin
      result := false;
      exit;
    end;
  end;
  result := true;
end;

{$hints off}
function tb2_polygon_shape.ray_cast(
  var output: tb2_ray_cast_output; const input: tb2_ray_cast_input;
  const xf: tb2_transform; const child_index: tb2_int32
): boolean;
  var p1, p2, d: tb2_vec2;
  var lower, upper, numerator, denominator: tb2_float32;
  var index, i: tb2_int32;
begin
  p1 := b2_mul_t(xf.q, input.p1 - xf.p);
  p2 := b2_mul_t(xf.q, input.p2 - xf.p);
  d := p2 - p1;
  lower := 0.0;
  upper := input.max_fraction;
  index := -1;
  for i := 0 to count - 1 do
  begin
    numerator := b2_dot(normals[i], vertices[i] - p1);
    denominator := b2_dot(normals[i], d);
    if denominator = 0.0 then
    begin
      if numerator < 0.0 then
      begin
        result := false;
        exit;
      end
    end
    else
    begin
      if (denominator < 0.0) and (numerator < lower * denominator) then
      begin
        lower := numerator / denominator;
	index := i;
      end
      else if (denominator > 0.0) and (numerator < upper * denominator) then
      begin
        upper := numerator / denominator;
      end
    end;
    if upper < lower then
    begin
      result := false;
      exit;
    end;
  end;
  if index >= 0 then
  begin
    output.fraction := lower;
    output.normal := b2_mul(xf.q, normals[index]);
    result := true;
    exit;
  end;
  result := false;
end;
{$hints on}

{$hints off}
procedure tb2_polygon_shape.compute_aabb(var aabb: tb2_aabb; const xf: tb2_transform; const child_index: tb2_int32);
  var lower, upper, v: tb2_vec2;
  var i: tb2_int32;
begin
  lower := b2_mul(xf, vertices[0]);
  upper := lower;
  for i := 1 to count - 1 do
  begin
    v := b2_mul(xf, vertices[i]);
    lower := b2_min(lower, v);
    upper := b2_max(upper, v);
  end;
  v.set_value(radius, radius);
  aabb.lower_bound := lower - v;
  aabb.upper_bound := upper + v;
end;
{$hints on}

procedure tb2_polygon_shape.compute_mass(var mass_data: tb2_mass_data; const density: tb2_float32);
  var center, s, e1, e2: tb2_vec2;
  var area, i1, d, triangle_area, ex1, ey1, ex2, ey2, intx2, inty2: tb2_float32;
  var i: tb2_int32;
  const rcp3 = 1.0 / 3.0;
begin
  center.set_value(0.0, 0.0);
  area := 0.0;
  i1 := 0.0;
  s.set_value(0.0, 0.0);
  for i := 0 to count - 1 do
  s := s + vertices[i];
  s := s * (1.0 / count);
  for i := 0 to count - 1 do
  begin
    e1 := vertices[i] - s;
    if i + 1 < count then e2 := vertices[i + 1] - s else e2 := vertices[0] - s;
    d := b2_cross(e1, e2);
    triangle_area := 0.5 * d;
    area += triangle_area;
    center := center + triangle_area * rcp3 * (e1 + e2);
    ex1 := e1.x; ey1 := e1.y;
    ex2 := e2.x; ey2 := e2.y;
    intx2 := ex1 * ex1 + ex2 * ex1 + ex2 * ex2;
    inty2 := ey1 * ey1 + ey2 * ey1 + ey2 * ey2;
    i1 += (0.25 * rcp3 * d) * (intx2 + inty2);
  end;
  mass_data.mass := density * area;
  center := center * (1.0 / area);
  mass_data.center := center + s;
  mass_data.inertia := density * i1;
  mass_data.inertia += mass_data.mass * (b2_dot(mass_data.center, mass_data.center) - b2_dot(center, center));
end;

function tb2_polygon_shape.get_vertex_count: tb2_int32;
begin
  result := count;
end;

function tb2_polygon_shape.get_vertex(const index: tb2_int32): tb2_vec2;
begin
  result := vertices[index];
end;

function tb2_polygon_shape.validate: boolean;
  var i, j, i1, i2: tb2_int32;
  var p, e, v: tb2_vec2;
  var c: tb2_float32;
begin
  for i := 0 to count - 1 do
  begin
    i1 := i;
    if i < count - 1 then i2 := i1 + 1 else i2 := 0;
    p := vertices[i1];
    e := vertices[i2] - p;
    for j := 0 to count - 1 do
    begin
      if (j = i1) or (j = i2) then continue;
      v := vertices[j] - p;
      c := b2_cross(e, v);
      if c < 0.0 then
      begin
        result := false;
        exit;
      end;
    end;
  end;
  result := true;
end;
//tb2_polygon_shape END

//tb2_tree_node BEGIN
function tb2_tree_node.is_leaf: boolean;
begin
  result := child1 = b2_null_node;
end;
//tb2_tree_node END

//tb2_dynamic_tree BEGIN
function tb2_dynamic_tree.allocate_node: tb2_int32;
  var old_nodes: pb2_tree_node_arr;
  var i, node_id: tb2_int32;
begin
  if _free_list = b2_null_node then
  begin
    old_nodes := _nodes;
    _node_capacity *= 2;
    _nodes := pb2_tree_node_arr(b2_alloc(_node_capacity * sizeof(tb2_tree_node)));
    move(old_nodes^, _nodes^, _node_count * sizeof(tb2_tree_node));
    b2_free(old_nodes);
    for i := _node_count to _node_capacity - 2 do
    begin
      _nodes^[i].union.next := i + 1;
      _nodes^[i].height := -1;
    end;
    _nodes^[_node_capacity - 1].union.next := b2_null_node;
    _nodes^[_node_capacity - 1].height := -1;
    _free_list := _node_count;
  end;
  node_id := _free_list;
  _free_list := _nodes^[node_id].union.next;
  _nodes^[node_id].union.parent := b2_null_node;
  _nodes^[node_id].child1 := b2_null_node;
  _nodes^[node_id].child2 := b2_null_node;
  _nodes^[node_id].height := 0;
  _nodes^[node_id].user_data := nil;
  inc(_node_count);
  result := node_id;
end;

procedure tb2_dynamic_tree.free_node(const node_id: tb2_int32);
begin
  _nodes^[node_id].union.next := _free_list;
  _nodes^[node_id].height := -1;
  _free_list := node_id;
  dec(_node_count);
end;

procedure tb2_dynamic_tree.insert_leaf(const node_id: tb2_int32);
  var leaf_aabb, combined_aabb, aabb: tb2_aabb;
  var index, sibling, child1, child2, old_parent, new_parent: tb2_int32;
  var area, combined_area, cost, inheritance_cost, cost1, cost2, old_area, new_area: tb2_float32;
begin
  inc(_insertion_count);
  if _root = b2_null_node then
  begin
    _root := node_id;
    _nodes^[_root].union.parent := b2_null_node;
    exit;
  end;
  leaf_aabb := _nodes^[node_id].aabb;
  index := _root;
  while not _nodes^[index].is_leaf do
  begin
    child1 := _nodes^[index].child1;
    child2 := _nodes^[index].child2;
    area := _nodes^[index].aabb.get_perimeter;
    combined_aabb.combine(_nodes^[index].aabb, leaf_aabb);
    combined_area := combined_aabb.get_perimeter;
    cost := 2.0 * combined_area;
    inheritance_cost := 2.0 * (combined_area - area);
    if _nodes^[child1].is_leaf then
    begin
      aabb.combine(leaf_aabb, _nodes^[child1].aabb);
      cost1 := aabb.get_perimeter + inheritance_cost;
    end
    else
    begin
      aabb.combine(leaf_aabb, _nodes^[child1].aabb);
      old_area := _nodes^[child1].aabb.get_perimeter;
      new_area := aabb.get_perimeter;
      cost1 := (new_area - old_area) + inheritance_cost;
    end;
    if _nodes^[child2].is_leaf then
    begin
      aabb.combine(leaf_aabb, _nodes^[child2].aabb);
      cost2 := aabb.get_perimeter + inheritance_cost;
    end
    else
    begin
      aabb.combine(leaf_aabb, _nodes^[child2].aabb);
      old_area := _nodes^[child2].aabb.get_perimeter;
      new_area := aabb.get_perimeter;
      cost2 := new_area - old_area + inheritance_cost;
    end;
    if (cost < cost1) and (cost < cost2) then break;
    if cost1 < cost2 then
    index := child1
    else
    index := child2;
  end;
  sibling := index;
  old_parent := _nodes^[sibling].union.parent;
  new_parent := allocate_node;
  _nodes^[new_parent].union.parent := old_parent;
  _nodes^[new_parent].user_data := nil;
  _nodes^[new_parent].aabb.combine(leaf_aabb, _nodes^[sibling].aabb);
  _nodes^[new_parent].height := _nodes^[sibling].height + 1;
  if old_parent <> b2_null_node then
  begin
    if _nodes^[old_parent].child1 = sibling then
    _nodes^[old_parent].child1 := new_parent
    else
    _nodes^[old_parent].child2 := new_parent;
    _nodes^[new_parent].child1 := sibling;
    _nodes^[new_parent].child2 := node_id;
    _nodes^[sibling].union.parent := new_parent;
    _nodes^[node_id].union.parent := new_parent;
  end
  else
  begin
    _nodes^[new_parent].child1 := sibling;
    _nodes^[new_parent].child2 := node_id;
    _nodes^[sibling].union.parent := new_parent;
    _nodes^[node_id].union.parent := new_parent;
    _root := new_parent;
  end;
  index := _nodes^[node_id].union.parent;
  while index <> b2_null_node do
  begin
    index := balance(index);
    child1 := _nodes^[index].child1;
    child2 := _nodes^[index].child2;
    _nodes^[index].height := 1 + b2_max(_nodes^[child1].height, _nodes^[child2].height);
    _nodes^[index].aabb.combine(_nodes^[child1].aabb, _nodes^[child2].aabb);
    index := _nodes^[index].union.parent;
  end;
end;

procedure tb2_dynamic_tree.remove_leaf(const node_id: tb2_int32);
  var parent, grand_parent, sibling, index, child1, child2: tb2_int32;
begin
  if node_id = _root then
  begin
    _root := b2_null_node;
    exit;
  end;
  parent := _nodes^[node_id].union.parent;
  grand_parent := _nodes^[parent].union.parent;
  if _nodes^[parent].child1 = node_id then
  sibling := _nodes^[parent].child2
  else
  sibling := _nodes^[parent].child1;
  if grand_parent <> b2_null_node then
  begin
    if (_nodes^[grand_parent].child1 = parent) then
    _nodes^[grand_parent].child1 := sibling
    else
    _nodes^[grand_parent].child2 := sibling;
    _nodes^[sibling].union.parent := grand_parent;
    free_node(parent);
    index := grand_parent;
    while index <> b2_null_node do
    begin
      index := balance(index);
      child1 := _nodes^[index].child1;
      child2 := _nodes^[index].child2;
      _nodes^[index].aabb.combine(_nodes^[child1].aabb, _nodes^[child2].aabb);
      _nodes^[index].height := 1 + b2_max(_nodes^[child1].height, _nodes^[child2].height);
      index := _nodes^[index].union.parent;
    end;
  end
  else
  begin
    _root := sibling;
    _nodes^[sibling].union.parent := b2_null_node;
    free_node(parent);
  end;
end;

function tb2_dynamic_tree.balance(const index: tb2_int32): tb2_int32;
  var i_a: tb2_int32 absolute index;
  var i_b, i_c, i_f, i_g, i_d, i_e, balance_1: tb2_int32;
  var a, b, c, f, g, d, e: pb2_tree_node;
begin
  a := @_nodes^[i_a];
  if (a^.is_leaf) or (a^.height < 2) then
  begin
    result := i_a;
    exit;
  end;
  i_b := a^.child1;
  i_c := a^.child2;
  b := @_nodes^[i_b];
  c := @_nodes^[i_c];
  balance_1 := c^.height - b^.height;
  if balance_1 > 1 then
  begin
    i_f := c^.child1;
    i_g := c^.child2;
    f := @_nodes^[i_f];
    g := @_nodes^[i_g];
    c^.child1 := i_a;
    c^.union.parent := a^.union.parent;
    a^.union.parent := i_c;
    if c^.union.parent <> b2_null_node then
    begin
      if _nodes^[c^.union.parent].child1 = i_a then
      _nodes^[c^.union.parent].child1 := i_c
      else
      _nodes^[c^.union.parent].child2 := i_c;
    end
    else
    begin
      _root := i_c;
    end;
    if f^.height > g^.height then
    begin
      c^.child2 := i_f;
      a^.child2 := i_g;
      g^.union.parent := i_a;
      a^.aabb.combine(b^.aabb, g^.aabb);
      c^.aabb.combine(a^.aabb, f^.aabb);
      a^.height := 1 + b2_max(b^.height, g^.height);
      c^.height := 1 + b2_max(a^.height, f^.height);
    end
    else
    begin
      c^.child2 := i_g;
      a^.child2 := i_f;
      f^.union.parent := i_a;
      a^.aabb.combine(b^.aabb, f^.aabb);
      c^.aabb.combine(a^.aabb, g^.aabb);
      a^.height := 1 + b2_max(b^.height, f^.height);
      c^.height := 1 + b2_max(a^.height, g^.height);
    end;
    result := i_c;
    exit;
  end;
  if balance_1 < -1 then
  begin
    i_d := b^.child1;
    i_e := b^.child2;
    d := @_nodes^[i_d];
    e := @_nodes^[i_e];
    b^.child1 := i_a;
    b^.union.parent := a^.union.parent;
    a^.union.parent := i_b;
    if b^.union.parent <> b2_null_node then
    begin
      if _nodes^[b^.union.parent].child1 = i_a then
      _nodes^[b^.union.parent].child1 := i_b
      else
      _nodes^[b^.union.parent].child2 := i_b;
    end
    else
    begin
      _root := i_b;
    end;
    if d^.height > e^.height then
    begin
      b^.child2 := i_d;
      a^.child1 := i_e;
      e^.union.parent := i_a;
      a^.aabb.combine(c^.aabb, e^.aabb);
      b^.aabb.combine(a^.aabb, d^.aabb);
      a^.height := 1 + b2_max(c^.height, e^.height);
      b^.height := 1 + b2_max(a^.height, d^.height);
    end
    else
    begin
      b^.child2 := i_e;
      a^.child1 := i_d;
      d^.union.parent := i_a;
      a^.aabb.combine(c^.aabb, d^.aabb);
      b^.aabb.combine(a^.aabb, e^.aabb);
      a^.height := 1 + b2_max(c^.height, d^.height);
      b^.height := 1 + b2_max(a^.height, e^.height);
    end;
    result := i_b;
    exit;
  end;
  result := i_a;
end;

function tb2_dynamic_tree.compute_height: tb2_int32;
begin
  result := compute_height(_root);
end;

function tb2_dynamic_tree.compute_height(const node_id: tb2_int32): tb2_int32;
  var node: pb2_tree_node;
  var height1, height2: tb2_int32;
begin
  node := @_nodes^[node_id];
  if node^.is_leaf then
  begin
    result := 0;
    exit;
  end;
  height1 := compute_height(node^.child1);
  height2 := compute_height(node^.child2);
  result := 1 + b2_max(height1, height2);
end;

procedure tb2_dynamic_tree.validate_structure(const index: tb2_int32);
  var node: pb2_tree_node;
  var child1, child2: tb2_int32;
begin
  if index = b2_null_node then exit;
  node := @_nodes^[index];
  child1 := node^.child1;
  child2 := node^.child2;
  if node^.is_leaf then exit;
  validate_structure(child1);
  validate_structure(child2);
end;

{$notes off}
procedure tb2_dynamic_tree.validate_metrics(const index: tb2_int32);
  var node: pb2_tree_node;
  var child1, child2, height, height1, height2: tb2_int32;
  var aabb: tb2_aabb;
begin
  if index = b2_null_node then exit;
  node := @_nodes^[index];
  child1 := node^.child1;
  child2 := node^.child2;
  if node^.is_leaf then exit;
  height1 := _nodes^[child1].height;
  height2 := _nodes^[child2].height;
  height := 1 + b2_max(height1, height2);
  aabb.combine(_nodes^[child1].aabb, _nodes^[child2].aabb);
  validate_metrics(child1);
  validate_metrics(child2);
end;
{$notes on}

constructor tb2_dynamic_tree.create;
  var i: tb2_int32;
begin
  _root := b2_null_node;
  _node_capacity := 16;
  _node_count := 0;
  _nodes := pb2_tree_node_arr(b2_alloc(_node_capacity * sizeof(tb2_tree_node)));
  fillchar(_nodes^, _node_capacity * sizeof(tb2_tree_node), 0);
  for i := 0 to _node_capacity - 2 do
  begin
    _nodes^[i].union.next := i + 1;
    _nodes^[i].height := -1;
  end;
  _nodes^[_node_capacity - 1].union.next := b2_null_node;
  _nodes^[_node_capacity - 1].height := -1;
  _free_list := 0;
  _path := 0;
  _insertion_count := 0;
end;

destructor tb2_dynamic_tree.destroy;
begin
  b2_free(_nodes);
end;

function tb2_dynamic_tree.create_proxy(const aabb: tb2_aabb; const user_data: tb2_ptr): tb2_int32;
  var proxy_id: tb2_int32;
  var r: tb2_vec2;
begin
  proxy_id := allocate_node;
  r.set_value(b2_aabb_extension, b2_aabb_extension);
  _nodes^[proxy_id].aabb.lower_bound := aabb.lower_bound - r;
  _nodes^[proxy_id].aabb.upper_bound := aabb.upper_bound + r;
  _nodes^[proxy_id].user_data := user_data;
  _nodes^[proxy_id].height := 0;
  insert_leaf(proxy_id);
  result := proxy_id;
end;

procedure tb2_dynamic_tree.destroy_proxy(const proxy_id: tb2_int32);
begin
  remove_leaf(proxy_id);
  free_node(proxy_id);
end;

function tb2_dynamic_tree.move_proxy(const proxy_id: tb2_int32; const aabb: tb2_aabb; const displacement: tb2_vec2): boolean;
  var b: tb2_aabb;
  var r, d: tb2_vec2;
begin
  if _nodes^[proxy_id].aabb.contains(aabb) then
  begin
    result := false;
    exit;
  end;
  remove_leaf(proxy_id);
  b := aabb;
  r.set_value(b2_aabb_extension, b2_aabb_extension);
  b.lower_bound := b.lower_bound - r;
  b.upper_bound := b.upper_bound + r;
  d := b2_aabb_multiplier * displacement;
  if d.x < 0.0 then
  b.lower_bound.x += d.x
  else
  b.upper_bound.x += d.x;
  if d.y < 0.0 then
  b.lower_bound.y += d.y
  else
  b.upper_bound.y += d.y;
  _nodes^[proxy_id].aabb := b;
  insert_leaf(proxy_id);
  result := true;
end;

function tb2_dynamic_tree.get_user_data(const proxy_id: tb2_int32): tb2_ptr;
begin
  result := _nodes^[proxy_id].user_data;
end;

function tb2_dynamic_tree.get_fat_aabb(const proxy_id: tb2_int32): tb2_aabb;
begin
  result := _nodes^[proxy_id].aabb;
end;

procedure tb2_dynamic_tree.query(const callback: tb2_query_callback; const aabb: tb2_aabb);
  var stack: tb2_growable_stack_int;
  var node_id: tb2_int32;
  var node: pb2_tree_node;
  var proceed: boolean;
begin
  stack.create;
  stack.push(_root);
  while (stack.get_count > 0) do
  begin
    node_id := stack.pop;
    if (node_id = b2_null_node) then continue;
    node := @_nodes^[node_id];
    if b2_test_overlap(node^.aabb, aabb) then
    begin
      if node^.is_leaf then
      begin
	proceed := callback(node_id);
	if not proceed then
        exit;
      end
      else
      begin
	stack.push(node^.child1);
	stack.push(node^.child2);
      end;
    end;
  end;
  stack.destroy;
end;

procedure tb2_dynamic_tree.ray_cast(const callback: tb2_ray_cast_callback; const input: tb2_ray_cast_input);
  var p1, p2, r, v, abs_v, t, c, h: tb2_vec2;
  var max_fraction, separation, value: tb2_float32;
  var segment_aabb: tb2_aabb;
  var stack: tb2_growable_stack_int;
  var node_id: tb2_int32;
  var node: pb2_tree_node;
  var sub_input: tb2_ray_cast_input;
begin
  p1 := input.p1;
  p2 := input.p2;
  r := p2 - p1;
  r.normalize;
  v := b2_cross(1.0, r);
  abs_v := b2_abs(v);
  max_fraction := input.max_fraction;
  t := p1 + max_fraction * (p2 - p1);
  segment_aabb.lower_bound := b2_min(p1, t);
  segment_aabb.upper_bound := b2_max(p1, t);
  stack.create;
  stack.push(_root);
  while stack.get_count > 0 do
  begin
    node_id := stack.pop;
    if node_id = b2_null_node then continue;
    node := @_nodes^[node_id];
    if not b2_test_overlap(node^.aabb, segment_aabb) then continue;
    c := node^.aabb.get_center;
    h := node^.aabb.get_extents;
    separation := b2_abs(b2_dot(v, p1 - c)) - b2_dot(abs_v, h);
    if separation > 0.0 then continue;
    if node^.is_leaf then
    begin
      sub_input.p1 := input.p1;
      sub_input.p2 := input.p2;
      sub_input.max_fraction := max_fraction;
      value := callback(sub_input, node_id);
      if value = 0.0 then exit;
      if value > 0.0 then
      begin
	max_fraction := value;
	t := p1 + max_fraction * (p2 - p1);
	segment_aabb.lower_bound := b2_min(p1, t);
	segment_aabb.upper_bound := b2_max(p1, t);
      end;
    end
    else
    begin
      stack.push(node^.child1);
      stack.push(node^.child2);
    end;
  end;
end;

procedure tb2_dynamic_tree.validate;
  var free_count, free_index: tb2_int32;
begin
  validate_structure(_root);
  validate_metrics(_root);
  free_count := 0;
  free_index := _free_list;
  while free_index <> b2_null_node do
  begin
    free_index := _nodes^[free_index].union.next;
    inc(free_count);
  end;
end;

function tb2_dynamic_tree.get_height: tb2_int32;
begin
  if _root = b2_null_node then
  begin
    result := 0;
    exit;
  end;
  result := _nodes^[_root].height;
end;

function tb2_dynamic_tree.get_max_balance: tb2_int32;
  var i, child1, child2, balance_1: tb2_int32;
  var node: pb2_tree_node;
begin
  result := 0;
  for i := 0 to _node_capacity - 1 do
  begin
    node := @_nodes^[i];
    if node^.height <= 1 then continue;
    child1 := node^.child1;
    child2 := node^.child2;
    balance_1 := b2_abs(tb2_int32(_nodes^[child2].height - _nodes^[child1].height));
    result := b2_max(result, balance_1);
  end;
end;

function tb2_dynamic_tree.get_area_ratio: tb2_float32;
  var root, node: pb2_tree_node;
  var root_area, total_area: tb2_float32;
  var i: tb2_int32;
begin
  if _root = b2_null_node then
  begin
    result := 0.0;
    exit;
  end;
  root := @_nodes^[_root];
  root_area := root^.aabb.get_perimeter;
  total_area := 0.0;
  for i := 0 to _node_capacity - 1 do
  begin
    node := @_nodes^[i];
    if node^.height < 0 then continue;
    total_area += node^.aabb.get_perimeter;
  end;
  result := total_area / root_area;
end;

procedure tb2_dynamic_tree.rebuild_bottom_up;
  var nodes: pb2_int32_arr;
  var i, j, count, i_min, j_min, index1, index2, parent_index: tb2_int32;
  var min_cost, cost: tb2_float32;
  var aabb_i, aabb_j, b: tb2_aabb;
  var child1, child2, parent: pb2_tree_node;
begin
  nodes := pb2_int32_arr(b2_alloc(_node_count * sizeof(int32)));
  count := 0;
  for i := 0 to _node_capacity - 1 do
  begin
    if _nodes^[i].height < 0 then continue;
    if _nodes^[i].is_leaf then
    begin
      _nodes^[i].union.parent := b2_null_node;
      nodes^[count] := i;
      inc(count);
    end
    else
    free_node(i);
  end;
  while count > 1 do
  begin
    min_cost := b2_max_float;
    i_min := -1; j_min := -1;
    for i := 0 to count - 1 do
    begin
      aabb_i := _nodes^[nodes^[i]].aabb;
      for j := i + 1 to count - 1 do
      begin
	aabb_j := _nodes^[nodes^[j]].aabb;
	b.combine(aabb_i, aabb_j);
	cost := b.get_perimeter;
	if cost < min_cost then
	begin
	  i_min := i;
	  j_min := j;
	  min_cost := cost;
	end;
      end;
    end;
    index1 := nodes^[i_min];
    index2 := nodes^[j_min];
    child1 := @_nodes^[index1];
    child2 := @_nodes^[index2];
    parent_index := allocate_node;
    parent := @_nodes^[parent_index];
    parent^.child1 := index1;
    parent^.child2 := index2;
    parent^.height := 1 + b2_max(child1^.height, child2^.height);
    parent^.aabb.combine(child1^.aabb, child2^.aabb);
    parent^.union.parent := b2_null_node;
    child1^.union.parent := parent_index;
    child2^.union.parent := parent_index;
    nodes^[j_min] := nodes^[count - 1];
    nodes^[i_min] := parent_index;
    dec(count);
  end;
  _root := nodes^[0];
  b2_free(nodes);
  validate;
end;

procedure tb2_dynamic_tree.shift_origin(const new_origin: tb2_vec2);
  var i: tb2_int32;
begin
  for i := 0 to _node_capacity - 1 do
  begin
    _nodes^[i].aabb.lower_bound := _nodes^[i].aabb.lower_bound - new_origin;
    _nodes^[i].aabb.upper_bound := _nodes^[i].aabb.upper_bound - new_origin;
  end;
end;
//tb2_dynamic_tree END

//tb2_broad_phase BEGIN
procedure tb2_broad_phase.buffer_move(const proxy_id: tb2_int32);
  var old_buffer: pb2_int32_arr;
begin
  if _move_count = _move_capacity then
  begin
    old_buffer := _move_buffer;
    _move_capacity *= 2;
    _move_buffer := pb2_int32_arr(b2_alloc(_move_capacity * sizeof(tb2_int32)));
    move(old_buffer^, _move_buffer^, _move_count * sizeof(tb2_int32));
    b2_free(old_buffer);
  end;
  _move_buffer^[_move_count] := proxy_id;
  inc(_move_count);
end;

procedure tb2_broad_phase.un_buffer_move(const proxy_id: tb2_int32);
  var i: tb2_int32;
begin
  for i := 0 to _move_count - 1 do
  begin
    if _move_buffer^[i] = proxy_id then
    _move_buffer^[i] := b2_null_proxy;
  end;
end;

function tb2_broad_phase.query_callback(const proxy_id: tb2_int32): boolean;
  var old_buffer: pb2_pair_arr;
begin
  if proxy_id = _query_proxy_id then
  begin
    result := true;
    exit;
  end;
  if _pair_count = _pair_capacity then
  begin
    old_buffer := _pair_buffer;
    _pair_capacity *= 2;
    _pair_buffer := pb2_pair_arr(b2_alloc(_pair_capacity * sizeof(tb2_pair)));
    move(old_buffer^, _pair_buffer^, _pair_count * sizeof(tb2_pair));
    b2_free(old_buffer);
  end;
  _pair_buffer^[_pair_count].proxy_id_a := b2_min(proxy_id, _query_proxy_id);
  _pair_buffer^[_pair_count].proxy_id_b := b2_max(proxy_id, _query_proxy_id);
  inc(_pair_count);
  result := true;
end;

function tb2_broad_phase.pair_less_than(const pair1, pair2: tb2_pair): boolean;
begin
  result := (
    (pair1.proxy_id_a < pair2.proxy_id_a)
    or (
      (pair1.proxy_id_a = pair2.proxy_id_a)
      and (pair1.proxy_id_b < pair2.proxy_id_b)
    )
  );
end;

constructor tb2_broad_phase.create;
begin
  _tree.create;
  _proxy_count := 0;
  _pair_capacity := 16;
  _pair_count := 0;
  _pair_buffer := pb2_pair_arr(b2_alloc(_pair_capacity * sizeof(tb2_pair)));
  _move_capacity := 16;
  _move_count := 0;
  _move_buffer := pb2_int32_arr(b2_alloc(_move_capacity * sizeof(tb2_int32)));
end;

destructor tb2_broad_phase.destroy;
begin
  b2_free(_move_buffer);
  b2_free(_pair_buffer);
  _tree.destroy;
end;

function tb2_broad_phase.create_proxy(const aabb: tb2_aabb; const user_data: tb2_ptr): tb2_int32;
begin
  result := _tree.create_proxy(aabb, user_data);
  inc(_proxy_count);
  buffer_move(result);
end;

procedure tb2_broad_phase.destroy_proxy(const proxy_id: tb2_int32);
begin
  un_buffer_move(proxy_id);
  dec(_proxy_count);
  _tree.destroy_proxy(proxy_id);
end;

procedure tb2_broad_phase.move_proxy(const proxy_id: tb2_int32; const aabb: tb2_aabb; const displacement: tb2_vec2);
begin
  if _tree.move_proxy(proxy_id, aabb, displacement) then
  buffer_move(proxy_id);
end;

procedure tb2_broad_phase.touch_proxy(const proxy_id: tb2_int32);
begin
  buffer_move(proxy_id);
end;

function tb2_broad_phase.get_fat_aabb(const proxy_id: tb2_int32): tb2_aabb;
begin
  result := _tree.get_fat_aabb(proxy_id);
end;

function tb2_broad_phase.get_user_data(const proxy_id: tb2_int32): tb2_ptr;
begin
  result := _tree.get_user_data(proxy_id);
end;

function tb2_broad_phase.test_overlap(const proxy_id_a, proxy_id_b: tb2_int32): boolean;
begin
  result := b2_test_overlap(_tree.get_fat_aabb(proxy_id_a), _tree.get_fat_aabb(proxy_id_b));
end;

function tb2_broad_phase.get_proxy_count: tb2_int32;
begin
  result := _proxy_count;
end;

procedure tb2_broad_phase.update_pairs(const callback: tb2_add_pair_callback);
  procedure quick_sort_pairs(l, h: tb2_int32);
    var i, j: tb2_int32;
    var pair_ptr: pb2_pair;
    var pair: tb2_pair;
  begin
    if _pair_count <= 0 then Exit;
    repeat
      i := l;
      j := h;
      pair_ptr := @_pair_buffer^[(l + h) shr 1];
      repeat
         while pair_less_than(_pair_buffer^[i], pair_ptr^) do inc(i);
         while pair_less_than(pair_ptr^, _pair_buffer^[j]) do dec(j);
         if i <= j then
         begin
            if i <> j then
            begin
               pair := _pair_buffer^[i];
               _pair_buffer^[i] := _pair_buffer^[j];
               _pair_buffer^[j] := pair;
            end;
            inc(i);
            dec(j);
         end;
      until i > j;
      if l < j then
      quick_sort_pairs(l, j);
      l := i;
    until i >= h;
  end;
  var i: tb2_int32;
  var fat_aabb: tb2_aabb;
  var primary_pair, pair: pb2_pair;
  var user_data_a, user_data_b: tb2_ptr;
begin
  _pair_count := 0;
  for i := 0 to _move_count - 1 do
  begin
    _query_proxy_id := _move_buffer^[i];
    if _query_proxy_id = b2_null_proxy then continue;
    fat_aabb := _tree.get_fat_aabb(_query_proxy_id);
    _tree.query(@query_callback, fat_aabb);
  end;
  _move_count := 0;
  quick_sort_pairs(0, _pair_count - 1);
  i := 0;
  while i < _pair_count do
  begin
    primary_pair := @_pair_buffer^[i];
    user_data_a := _tree.get_user_data(primary_pair^.proxy_id_a);
    user_data_b := _tree.get_user_data(primary_pair^.proxy_id_b);
    callback(user_data_a, user_data_b);
    inc(i);
    while i < _pair_count do
    begin
      pair := @_pair_buffer^[i];
      if (pair^.proxy_id_a <> primary_pair^.proxy_id_a) or (pair^.proxy_id_b <> primary_pair^.proxy_id_b) then break;
      inc(i);
    end;
  end;
end;

procedure tb2_broad_phase.query(const callback: tb2_query_callback; const aabb: tb2_aabb);
begin
  _tree.query(callback, aabb);
end;

procedure tb2_broad_phase.ray_cast(const callback: tb2_ray_cast_callback; const input: tb2_ray_cast_input);
begin
  _tree.ray_cast(callback, input);
end;

function tb2_broad_phase.get_tree_height: tb2_int32;
begin
  result := _tree.get_height;
end;

function tb2_broad_phase.get_tree_balance: tb2_int32;
begin
  result := _tree.get_max_balance;
end;

function tb2_broad_phase.get_tree_quality: tb2_float32;
begin
  result := _tree.get_area_ratio;
end;

procedure tb2_broad_phase.shift_origin(const new_origin: tb2_vec2);
begin
  _tree.shift_origin(new_origin);
end;
//tb2_broad_phase END

//tb2_separation_function BEGIN
function tb2_separation_function.initialize(
  const cache: pb2_simplex_cache;
  const new_proxy_a: pb2_distance_proxy; const new_sweep_a: tb2_sweep;
  const new_proxy_b: pb2_distance_proxy; const new_sweep_b: tb2_sweep;
  const t1: tb2_float32
): tb2_float32;
  var count: tb2_int32;
  var xf_a, xf_b: tb2_transform;
  var local_point_a, local_point_a1, local_point_a2, local_point_b, local_point_b1, local_point_b2, point_a, point_b, normal: tb2_vec2;
  var s: tb2_float32;
begin
  proxy_a := new_proxy_a;
  proxy_b := new_proxy_b;
  count := cache^.count;
  sweep_a := new_sweep_a;
  sweep_b := new_sweep_b;
  sweep_a.get_transform(@xf_a, t1);
  sweep_b.get_transform(@xf_b, t1);
  if count = 1 then
  begin
    separation_type := b2_sft_points;
    local_point_a := proxy_a^.get_vertex(cache^.index_a[0]);
    local_point_b := proxy_b^.get_vertex(cache^.index_b[0]);
    point_a := b2_mul(xf_a, local_point_a);
    point_b := b2_mul(xf_b, local_point_b);
    axis := point_b - point_a;
    s := axis.normalize;
    result := s;
    exit;
  end
  else if cache^.index_a[0] = cache^.index_a[1] then
  begin
    separation_type := b2_sft_face_b;
    local_point_b1 := proxy_b^.get_vertex(cache^.index_b[0]);
    local_point_b2 := proxy_b^.get_vertex(cache^.index_b[1]);
    axis := b2_cross(local_point_b2 - local_point_b1, 1.0);
    axis.normalize;
    normal := b2_mul(xf_b.q, axis);
    local_point := 0.5 * (local_point_b1 + local_point_b2);
    point_b := b2_mul(xf_b, local_point);
    local_point_a := proxy_a^.get_vertex(cache^.index_a[0]);
    point_a := b2_mul(xf_a, local_point_a);
    s := b2_dot(point_a - point_b, normal);
    if s < 0.0 then
    begin
      axis := -axis;
      s := -s;
    end;
    result := s;
    exit;
  end
  else
  begin
    separation_type := b2_sft_face_a;
    local_point_a1 := proxy_a^.get_vertex(cache^.index_a[0]);
    local_point_a2 := proxy_a^.get_vertex(cache^.index_a[1]);
    axis := b2_cross(local_point_a2 - local_point_a1, 1.0);
    axis.normalize;
    normal := b2_mul(xf_a.q, axis);
    local_point := 0.5 * (local_point_a1 + local_point_a2);
    point_a := b2_mul(xf_a, local_point);
    local_point_b := proxy_b^.get_vertex(cache^.index_b[0]);
    point_b := b2_mul(xf_b, local_point_b);
    s := b2_dot(point_b - point_a, normal);
    if s < 0.0 then
    begin
      axis := -axis;
      s := -s;
    end;
    result := s;
    exit;
  end;
end;

function tb2_separation_function.find_min_separation(const index_a, index_b: pb2_int32; const t: tb2_float32): tb2_float32;
  var xf_a, xf_b: tb2_transform;
  var axis_a, axis_b, local_point_a, local_point_b, point_a, point_b, normal: tb2_vec2;
begin
  sweep_a.get_transform(@xf_a, t);
  sweep_b.get_transform(@xf_b, t);
  case separation_type of
    b2_sft_points:
    begin
      axis_a := b2_mul_t(xf_a.q, axis);
      axis_b := b2_mul_t(xf_b.q, -axis);
      index_a^ := proxy_a^.get_support(axis_a);
      index_b^ := proxy_b^.get_support(axis_b);
      local_point_a := proxy_a^.get_vertex(index_a^);
      local_point_b := proxy_b^.get_vertex(index_b^);
      point_a := b2_mul(xf_a, local_point_a);
      point_b := b2_mul(xf_b, local_point_b);
      result := b2_dot(point_b - point_a, axis);
      exit;
    end;
    b2_sft_face_a:
    begin
      normal := b2_mul(xf_a.q, axis);
      point_a := b2_mul(xf_a, local_point);
      axis_b := b2_mul_t(xf_b.q, -normal);
      index_a^ := -1;
      index_b^ := proxy_b^.get_support(axis_b);
      local_point_b := proxy_b^.get_vertex(index_b^);
      point_b := b2_mul(xf_b, local_point_b);
      result := b2_dot(point_b - point_a, normal);
      exit;
    end;
    b2_sft_face_b:
    begin
      normal := b2_mul(xf_b.q, axis);
      point_b := b2_mul(xf_b, local_point);
      axis_a := b2_mul_t(xf_a.q, -normal);
      index_b^ := -1;
      index_a^ := proxy_a^.get_support(axis_a);
      local_point_a := proxy_a^.get_vertex(index_a^);
      point_a := b2_mul(xf_a, local_point_a);
      result := b2_dot(point_a - point_b, normal);
      exit;
    end;
    else
    begin
      index_a^ := -1;
      index_b^ := -1;
      result := 0.0;
      exit;
    end;
  end;
end;

function tb2_separation_function.evaluate(const index_a, index_b: tb2_int32; const t: tb2_float32): tb2_float32;
  var xf_a, xf_b: tb2_transform;
  var local_point_a, local_point_b, point_a, point_b, normal: tb2_vec2;
begin
  sweep_a.get_transform(@xf_a, t);
  sweep_b.get_transform(@xf_b, t);
  case separation_type of
    b2_sft_points:
    begin
      local_point_a := proxy_a^.get_vertex(index_a);
      local_point_b := proxy_b^.get_vertex(index_b);
      point_a := b2_mul(xf_a, local_point_a);
      point_b := b2_mul(xf_b, local_point_b);
      result := b2_dot(point_b - point_a, axis);
      exit;
    end;
    b2_sft_face_a:
    begin
      normal := b2_mul(xf_a.q, axis);
      point_a := b2_mul(xf_a, local_point);
      local_point_b := proxy_b^.get_vertex(index_b);
      point_b := b2_mul(xf_b, local_point_b);
      result := b2_dot(point_b - point_a, normal);
      exit;
    end;
    b2_sft_face_b:
    begin
      normal := b2_mul(xf_b.q, axis);
      point_b := b2_mul(xf_b, local_point);
      local_point_a := proxy_b^.get_vertex(index_a);
      point_a := b2_mul(xf_a, local_point_a);
      result := b2_dot(point_a - point_b, normal);
      exit;
    end;
    else
    begin
      result := 0.0;
      exit;
    end;
  end;
end;
//tb2_separation_function END

//tb2_body BEGIN
procedure tb2_body.synchronize_fixtures;
  var xf1: tb2_transform;
  var broad_phase: pb2_broad_phase;
  var f: pb2_fixture;
begin
  xf1.q.set_value(_sweep.a0);
  xf1.p := _sweep.c0 - b2_mul(xf1.q, _sweep.local_center);
  broad_phase := @_world^._contact_manager.broad_phase;
  f := _fixture_list;
  while f <> nil do
  begin
    f^.synchronize(broad_phase, xf1, _xf);
    f := f^._next;
  end;
end;

procedure tb2_body.synchronize_transform;
begin
  _xf.q.set_value(_sweep.a);
  _xf.p := _sweep.c - b2_mul(_xf.q, _sweep.local_center);
end;

function tb2_body.should_collide(const other: pb2_body): boolean;
  var je: pb2_joint_edge;
begin
  if (_type <> b2_dynamic_body) and (other^._type <> b2_dynamic_body) then
  begin
    result := false;
    exit;
  end;
  je := _joint_list;
  while je <> nil do
  begin
    if je^.other = other then
    begin
      if not je^.joint^._collide_connected then
      begin
        result := false;
        exit;
      end;
    end;
    je := je^.next;
  end;
  result := true;
end;

procedure tb2_body.advance(const t: tb2_float32);
begin
  _sweep.advance(t);
  _sweep.c := _sweep.c0;
  _sweep.a := _sweep.a0;
  _xf.q.set_value(_sweep.a);
  _xf.p := _sweep.c - b2_mul(_xf.q, _sweep.local_center);
end;

constructor tb2_body.create(const def: tb2_body_def; const world: pb2_world);
begin
  _flags := [];
  if def.bullet then _flags += [b2_bf_bullet_flag];
  if def.fixed_rotation then _flags += [b2_bf_fixed_rotation_flag];
  if def.allow_sleep then _flags += [b2_bf_auto_sleep_flag];
  if def.awake then _flags += [b2_bf_awake_flag];
  if def.active then _flags += [b2_bf_active_flag];
  _world := world;
  _xf.p := def.position;
  _xf.q.set_value(def.angle);
  _sweep.local_center.set_zero;
  _sweep.c0 := _xf.p;
  _sweep.c := _xf.p;
  _sweep.a0 := def.angle;
  _sweep.a := def.angle;
  _sweep.alpha0 := 0.0;
  _joint_list := nil;
  _contact_list := nil;
  _prev := nil;
  _next := nil;
  _linear_velocity := def.linear_velocity;
  _angular_velocity := def.angular_velocity;
  _linear_damping := def.linear_damping;
  _angular_damping := def.angular_damping;
  _gravity_scale := def.gravity_scale;
  _force.set_zero;
  _torque := 0.0;
  _sleep_time := 0.0;
  _type := def.body_type;
  if _type = b2_dynamic_body then
  begin
    _mass := 1.0;
    _rcp_mass := 1.0;
  end
  else
  begin
    _mass := 0.0;
    _rcp_mass := 0.0;
  end;
  _inertia := 0.0;
  _rcp_inertia := 0.0;
  _user_data := def.user_data;
  _fixture_list := nil;
  _fixture_count := 0;
end;

destructor tb2_body.destroy;
begin
end;

function tb2_body.create_fixture(const def: tb2_fixture_def): pb2_fixture;
  var allocator: pb2_block_allocator;
  var broad_phase: pb2_broad_phase;
begin
  if _world^.is_locked then exit(nil);
  allocator := @_world^._block_allocator;
  result := pb2_fixture(allocator^.alloc(sizeof(tb2_fixture)));
  result^.create;
  result^.create_fixture(allocator, @self, def);
  if b2_bf_active_flag in _flags then
  begin
    broad_phase := @_world^._contact_manager.broad_phase;
    result^.create_proxies(broad_phase, _xf);
  end;
  result^._next := _fixture_list;
  _fixture_list := result;
  inc(_fixture_count);
  result^._body := @self;
  if result^._density > 0.0 then
  reset_mass_data;
  _world^._flags += [b2_wf_new_fixture];
end;

function tb2_body.create_fixture(const shape: pb2_shape; const density: tb2_float32): pb2_fixture;
  var def: tb2_fixture_def;
begin
  def := b2_fixture_def;
  def.shape := shape;
  def.density := density;
  result := create_fixture(def);
end;

procedure tb2_body.destroy_fixture(var fixture: pb2_fixture);
  var node: ppb2_fixture;
  var edge: pb2_contact_edge;
  var c: pb2_contact;
  var fixture_a, fixture_b: pb2_fixture;
  var allocator: pb2_block_allocator;
  var broad_phase: pb2_broad_phase;
begin
  if _world^.is_locked then exit;
  node := @pb2_fixture(_fixture_list);
  while node^ <> nil do
  begin
    if node^ = fixture then
    begin
      node^ := fixture^._next;
      break;
    end;
    node := @(node^^._next);
  end;
  edge := _contact_list;
  while edge <> nil do
  begin
    c := edge^.contact;
    edge := edge^.next;
    fixture_a := c^.get_fixture_a;
    fixture_b := c^.get_fixture_b;
    if (fixture = fixture_a) or (fixture = fixture_b) then
    _world^._contact_manager.destroy_contact(c);
  end;
  allocator := @_world^._block_allocator;
  if b2_bf_active_flag in _flags then
  begin
    broad_phase := @_world^._contact_manager.broad_phase;
    fixture^.destroy_proxies(broad_phase);
  end;
  fixture^.destroy_fixture(allocator);
  fixture^._body := nil;
  fixture^._next := nil;
  allocator^.free(fixture, sizeof(tb2_fixture));
  dec(_fixture_count);
  reset_mass_data;
end;

procedure tb2_body.set_transform(const position: tb2_vec2; const angle: tb2_float32);
  var broad_phase: pb2_broad_phase;
  var f: pb2_fixture;
begin
  if _world^.is_locked then exit;
  _xf.p := position;
  _xf.q.set_value(angle);
  _sweep.c := b2_mul(_xf, _sweep.local_center);
  _sweep.a := angle;
  _sweep.c0 := _sweep.c;
  _sweep.a0 := angle;
  broad_phase := @_world^._contact_manager.broad_phase;
  f := _fixture_list;
  while f <> nil do
  begin
    f^.synchronize(broad_phase, _xf, _xf);
    f := f^._next;
  end;
end;

procedure tb2_body.set_transform(const xf: tb2_transform);
  var broad_phase: pb2_broad_phase;
  var f: pb2_fixture;
begin
  if _world^.is_locked then exit;
  _xf := xf;
  _sweep.c := b2_mul(_xf, _sweep.local_center);
  _sweep.a := _xf.q.get_angle;
  _sweep.c0 := _sweep.c;
  _sweep.a0 := _sweep.a;
  broad_phase := @_world^._contact_manager.broad_phase;
  f := _fixture_list;
  while f <> nil do
  begin
    f^.synchronize(broad_phase, _xf, _xf);
    f := f^._next;
  end;
end;

function tb2_body.get_transform: tb2_transform;
begin
  result := _xf;
end;

function tb2_body.get_position: tb2_vec2;
begin
  result := _xf.p;
end;

function tb2_body.get_angle: tb2_float32;
begin
  result := _sweep.a;
end;

function tb2_body.get_world_center: tb2_vec2;
begin
  result := _sweep.c;
end;

function tb2_body.get_local_center: tb2_vec2;
begin
  result := _sweep.local_center;
end;

procedure tb2_body.set_linear_velocity(const v: tb2_vec2);
begin
  if _type = b2_static_body then exit;
  if b2_dot(v, v) > 0.0 then
  set_awake(true);
  _linear_velocity := v;
end;

function tb2_body.get_linear_velocity: tb2_vec2;
begin
  result := _linear_velocity;
end;

procedure tb2_body.set_angular_velocity(const w: tb2_float32);
begin
  if _type = b2_static_body then exit;
  if w * w > 0.0 then set_awake(true);
  _angular_velocity := w;
end;

function tb2_body.get_angular_velocity: tb2_float32;
begin
  result := _angular_velocity;
end;

procedure tb2_body.apply_force(const force: tb2_vec2; const point: tb2_vec2; const wake: boolean);
begin
  if _type <> b2_dynamic_body then exit;
  if wake and not (b2_bf_awake_flag in _flags) then
  set_awake(true);
  if b2_bf_awake_flag in _flags then
  begin
    _force := _force + force;
    _torque += b2_cross(point - _sweep.c, force);
  end;
end;

procedure tb2_body.apply_force_to_center(const force: tb2_vec2; const wake: boolean);
begin
  if _type <> b2_dynamic_body then exit;
  if wake and not (b2_bf_awake_flag in _flags) then
  set_awake(true);
  if b2_bf_awake_flag in _flags then _force := _force + force;
end;

procedure tb2_body.apply_torque(const torque: tb2_float32; const wake: boolean);
begin
  if _type <> b2_dynamic_body then exit;
  if wake and not (b2_bf_awake_flag in _flags) then
  set_awake(true);
  if b2_bf_awake_flag in _flags then _torque += torque;
end;

procedure tb2_body.apply_linear_impulse(const impulse: tb2_vec2; const point: tb2_vec2; const wake: boolean);
begin
  if _type <> b2_dynamic_body then exit;
  if wake and not (b2_bf_awake_flag in _flags) then
  set_awake(true);
  if b2_bf_awake_flag in _flags then
  begin
    _linear_velocity := _linear_velocity + _rcp_mass * impulse;
    _angular_velocity += _rcp_inertia * b2_cross(point - _sweep.c, impulse);
  end;
end;

procedure tb2_body.apply_angular_impulse(const impulse: tb2_float32; const wake: boolean);
begin
  if _type <> b2_dynamic_body then exit;
  if wake and not (b2_bf_awake_flag in _flags) then
  set_awake(true);
  if b2_bf_awake_flag in _flags then
  _angular_velocity += _rcp_inertia * impulse;
end;

function tb2_body.get_mass: tb2_float32;
begin
  result := _mass;
end;

function tb2_body.get_inertia: tb2_float32;
begin
  result := _inertia + _mass * b2_dot(_sweep.local_center, _sweep.local_center);
end;

procedure tb2_body.get_mass_data(var data: tb2_mass_data);
begin
  data.mass := _mass;
  data.inertia := _inertia + _mass * b2_dot(_sweep.local_center, _sweep.local_center);
  data.center := _sweep.local_center;
end;

procedure tb2_body.set_mass_data(const data: tb2_mass_data);
  var old_center: tb2_vec2;
begin
  if _world^.is_locked then exit;
  if _type <> b2_dynamic_body then exit;
  _rcp_mass := 0.0;
  _inertia := 0.0;
  _rcp_inertia := 0.0;
  _mass := data.mass;
  if _mass <= 0.0 then
  _mass := 1.0;
  _rcp_mass := 1.0 / _mass;
  if (data.inertia > 0.0) and not (b2_bf_fixed_rotation_flag in _flags) then
  begin
    _inertia := data.inertia - _mass * b2_dot(data.center, data.center);
    _rcp_inertia := 1.0 / _inertia;
  end;
  old_center := _sweep.c;
  _sweep.local_center := data.center;
  _sweep.c := b2_mul(_xf, _sweep.local_center);
  _sweep.c0 := _sweep.c;
  _linear_velocity := _linear_velocity + b2_cross(_angular_velocity, _sweep.c - old_center);
end;

procedure tb2_body.reset_mass_data;
  var local_center, old_center: tb2_vec2;
  var f: pb2_fixture;
  var mass_data: tb2_mass_data;
begin
  _mass := 0.0;
  _rcp_mass := 0.0;
  _inertia := 0.0;
  _rcp_inertia := 0.0;
  _sweep.local_center.set_zero;
  if (_type = b2_static_body) or (_type = b2_kinematic_body) then
  begin
    _sweep.c0 := _xf.p;
    _sweep.c := _xf.p;
    _sweep.a0 := _sweep.a;
    exit;
  end;
  local_center := b2_vec2_zero;
  f := _fixture_list;
  while f <> nil do
  begin
    if (f^._density = 0.0) then
    begin
      f := f^._next;
      continue;
    end;
    {$hints off}
    f^.get_mass_data(mass_data);
    {$hints on}
    _mass += mass_data.mass;
    local_center := local_center + (mass_data.mass * mass_data.center);
    _inertia += mass_data.inertia;
    f := f^._next;
  end;
  if _mass > 0.0 then
  begin
    _rcp_mass := 1.0 / _mass;
    local_center := local_center * _rcp_mass;
  end
  else
  begin
    _mass := 1.0;
    _rcp_mass := 1.0;
  end;
  if (_inertia > 0.0) and not (b2_bf_fixed_rotation_flag in _flags) then
  begin
    _inertia -= _mass * b2_dot(local_center, local_center);
    _rcp_inertia := 1.0 / _inertia;
  end
  else
  begin
    _inertia := 0.0;
    _rcp_inertia := 0.0;
  end;
  old_center := _sweep.c;
  _sweep.local_center := local_center;
  _sweep.c := b2_mul(_xf, _sweep.local_center);
  _sweep.c0 := _sweep.c;
  _linear_velocity := _linear_velocity + b2_cross(_angular_velocity, _sweep.c - old_center);
end;

function tb2_body.get_world_point(const local_point: tb2_vec2): tb2_vec2;
begin
  result := b2_mul(_xf, local_point);
end;

function tb2_body.get_world_vector(const local_vector: tb2_vec2): tb2_vec2;
begin
  result := b2_mul(_xf.q, local_vector);
end;

function tb2_body.get_local_point(const world_point: tb2_vec2): tb2_vec2;
begin
  result := b2_mul_t(_xf, world_point);
end;

function tb2_body.get_local_vector(const world_vector: tb2_vec2): tb2_vec2;
begin
  result := b2_mul_t(_xf.q, world_vector);
end;

function tb2_body.get_linear_velocity_from_world_point(const world_point: tb2_vec2): tb2_vec2;
begin
  result := _linear_velocity + b2_cross(_angular_velocity, world_point - _sweep.c);
end;

function tb2_body.get_linear_velocity_from_local_point(const local_point: tb2_vec2): tb2_vec2;
begin
  result := get_linear_velocity_from_world_point(get_world_point(local_point));
end;

function tb2_body.get_linear_damping: tb2_float32;
begin
  result := _linear_damping;
end;

procedure tb2_body.set_linear_damping(const linear_damping: tb2_float32);
begin
  _linear_damping := linear_damping;
end;

function tb2_body.get_angular_damping: tb2_float32;
begin
  result := _angular_damping;
end;

procedure tb2_body.set_angular_damping(const angular_damping: tb2_float32);
begin
  _angular_damping := angular_damping;
end;

function tb2_body.get_gravity_scale: tb2_float32;
begin
  result := _gravity_scale;
end;

procedure tb2_body.set_gravity_scale(const scale: tb2_float32);
begin
  _gravity_scale := scale;
end;

procedure tb2_body.set_type(const new_type: tb2_body_type);
  var ce, ce0: pb2_contact_edge;
  var broad_phase: pb2_broad_phase;
  var f: pb2_fixture;
  var proxy_count, i: tb2_int32;
begin
  if _world^.is_locked then exit;
  if _type = new_type then exit;
  _type := new_type;
  reset_mass_data;
  if _type = b2_static_body then
  begin
    _linear_velocity.set_zero;
    _angular_velocity := 0.0;
    _sweep.a0 := _sweep.a;
    _sweep.c0 := _sweep.c;
    synchronize_fixtures;
  end;
  set_awake(true);
  _force.set_zero;
  _torque := 0.0;
  ce := _contact_list;
  while ce <> nil do
  begin
    ce0 := ce;
    ce := ce^.next;
    _world^._contact_manager.destroy_contact(ce0^.contact);
  end;
  _contact_list := nil;
  broad_phase := @_world^._contact_manager.broad_phase;
  f := _fixture_list;
  while f <> nil do
  begin
    proxy_count := f^._proxy_count;
    for i := 0 to proxy_count - 1 do
    broad_phase^.touch_proxy(f^._proxies^[i].proxy_id);
    f := f^._next;
  end;
end;

function tb2_body.get_type: tb2_body_type;
begin
  result := _type;
end;

procedure tb2_body.set_bullet(const flag: boolean);
begin
  if flag then
  _flags += [b2_bf_bullet_flag]
  else
  _flags -= [b2_bf_bullet_flag];
end;

function tb2_body.is_bullet: boolean;
begin
  result := b2_bf_bullet_flag in _flags;
end;

procedure tb2_body.set_sleeping_allowed(const flag: boolean);
begin
  if flag then
  _flags += [b2_bf_auto_sleep_flag]
  else
  begin
    _flags -= [b2_bf_auto_sleep_flag];
    set_awake(true);
  end;
end;

function tb2_body.is_sleeping_allowed: boolean;
begin
  result := b2_bf_auto_sleep_flag in _flags;
end;

procedure tb2_body.set_awake(const flag: boolean);
begin
  if flag then
  begin
    if not (b2_bf_awake_flag in _flags) then
    begin
      _flags += [b2_bf_awake_flag];
      _sleep_time := 0.0;
    end;
  end
  else
  begin
    _flags -= [b2_bf_awake_flag];
    _sleep_time := 0.0;
    _linear_velocity.set_zero;
    _angular_velocity := 0.0;
    _force.set_zero;
    _torque := 0.0;
  end;
end;

function tb2_body.is_awake: boolean;
begin
  result := b2_bf_awake_flag in _flags;
end;

procedure tb2_body.set_active(const flag: boolean);
  var broad_phase: pb2_broad_phase;
  var f: pb2_fixture;
  var ce, ce0: pb2_contact_edge;
begin
  if flag = is_active then exit;
  if flag then
  begin
    _flags += [b2_bf_active_flag];
    broad_phase := @_world^._contact_manager.broad_phase;
    f := _fixture_list;
    while f <> nil do
    begin
      f^.create_proxies(broad_phase, _xf);
      f := f^._next;
    end;
  end
  else
  begin
    _flags -= [b2_bf_active_flag];
    broad_phase := @_world^._contact_manager.broad_phase;
    f := _fixture_list;
    while f <> nil do
    begin
      f^.destroy_proxies(broad_phase);
      f := f^._next;
    end;
    ce := _contact_list;
    while ce <> nil do
    begin
      ce0 := ce;
      ce := ce^.next;
      _world^._contact_manager.destroy_contact(ce0^.contact);
    end;
    _contact_list := nil;
  end;
end;

function tb2_body.is_active: boolean;
begin
  result := b2_bf_active_flag in _flags;
end;

procedure tb2_body.set_fixed_rotation(const flag: boolean);
  var status: boolean;
begin
  status := b2_bf_fixed_rotation_flag in _flags;
  if status = flag then exit;
  if flag then
  _flags += [b2_bf_fixed_rotation_flag]
  else
  _flags -= [b2_bf_fixed_rotation_flag];
  _angular_damping := 0.0;
  reset_mass_data;
end;

function tb2_body.is_fixed_rotation: boolean;
begin
  result := b2_bf_fixed_rotation_flag in _flags;
end;

function tb2_body.get_fixture_list: pb2_fixture;
begin
  result := _fixture_list;
end;

function tb2_body.get_joint_list: pb2_joint_edge;
begin
  result := _joint_list;
end;

function tb2_body.get_contact_list: pb2_contact_edge;
begin
  result := _contact_list;
end;

function tb2_body.get_next: pb2_body;
begin
  result := _next;
end;

function tb2_body.get_user_data: tb2_ptr;
begin
  result := _user_data;
end;

procedure tb2_body.set_user_data(const data: tb2_ptr);
begin
  _user_data := data;
end;

function tb2_body.get_world: pb2_world;
begin
  result := _world;
end;

procedure tb2_body.dump;
begin
  //int32 bodyIndex = m_islandIndex;
  //
  //b2Log("{\n");
  //b2Log("  b2BodyDef bd;\n");
  //b2Log("  bd.type = b2BodyType(%d);\n", m_type);
  //b2Log("  bd.position.Set(%.15lef, %.15lef);\n", m_xf.p.x, m_xf.p.y);
  //b2Log("  bd.angle = %.15lef;\n", m_sweep.a);
  //b2Log("  bd.linearVelocity.Set(%.15lef, %.15lef);\n", m_linearVelocity.x, m_linearVelocity.y);
  //b2Log("  bd.angularVelocity = %.15lef;\n", m_angularVelocity);
  //b2Log("  bd.linearDamping = %.15lef;\n", m_linearDamping);
  //b2Log("  bd.angularDamping = %.15lef;\n", m_angularDamping);
  //b2Log("  bd.allowSleep = bool(%d);\n", m_flags & e_autoSleepFlag);
  //b2Log("  bd.awake = bool(%d);\n", m_flags & e_awakeFlag);
  //b2Log("  bd.fixedRotation = bool(%d);\n", m_flags & e_fixedRotationFlag);
  //b2Log("  bd.bullet = bool(%d);\n", m_flags & e_bulletFlag);
  //b2Log("  bd.active = bool(%d);\n", m_flags & e_activeFlag);
  //b2Log("  bd.gravityScale = %.15lef;\n", m_gravityScale);
  //b2Log("  bodies[%d] = m_world->CreateBody(&bd);\n", m_islandIndex);
  //b2Log("\n");
  //for (b2Fixture* f = m_fixtureList; f; f = f->m_next)
  //{
	 // b2Log("  {\n");
	 // f->Dump(bodyIndex);
	 // b2Log("  }\n");
  //}
  //b2Log("}\n");
end;
//tb2_body END

//tb2_fixture BEGIN
procedure tb2_fixture.create_fixture(const allocator: pb2_block_allocator; const body: pb2_body; const def: tb2_fixture_def);
  var child_count, i: tb2_int32;
begin
  _user_data := def.user_data;
  _friction := def.friction;
  _restitution := def.restitution;
  _body := body;
  _next := nil;
  _filter := def.filter;
  _is_sensor := def.is_sensor;
  _shape := def.shape^.clone(allocator);
  child_count := _shape^.get_child_count;
  _proxies := pb2_fixture_proxy_arr(allocator^.alloc(child_count * sizeof(tb2_fixture_proxy)));
  for i := 0 to child_count - 1 do
  begin
    _proxies^[i].fixture := nil;
    _proxies^[i].proxy_id := b2_null_proxy;
  end;
  _proxy_count := 0;
  _density := def.density;
end;

procedure tb2_fixture.destroy_fixture(const allocator: pb2_block_allocator);
  var child_count: tb2_int32;
  var s: pb2_shape;
  var circle: pb2_circle_shape absolute s;
  var edge: pb2_edge_shape absolute s;
  var polygon: pb2_polygon_shape absolute s;
  var chain: pb2_chain_shape absolute s;
begin
  child_count := _shape^.get_child_count;
  allocator^.free(_proxies, child_count * sizeof(tb2_fixture_proxy));
  _proxies := nil;
  case _shape^.shape_type of
    b2_st_circle:
    begin
      circle := pb2_circle_shape(_shape);
      circle^.destroy;
      allocator^.free(circle, sizeof(tb2_circle_shape));
    end;
    b2_st_edge:
    begin
      edge := pb2_edge_shape(_shape);
      edge^.destroy;
      allocator^.free(edge, sizeof(tb2_edge_shape));
    end;
    b2_st_polygon:
    begin
      polygon := pb2_polygon_shape(_shape);
      polygon^.destroy;
      allocator^.free(polygon, sizeof(tb2_polygon_shape));
    end;
    b2_st_chain:
    begin
      chain := pb2_chain_shape(_shape);
      chain^.destroy;
      allocator^.free(chain, sizeof(tb2_chain_shape));
    end;
  end;
  _shape := nil;
end;

procedure tb2_fixture.create_proxies(const broad_phase: pb2_broad_phase; const xf: tb2_transform);
  var i: tb2_int32;
  var proxy: pb2_fixture_proxy;
begin
  _proxy_count := _shape^.get_child_count;
  for i := 0 to _proxy_count - 1 do
  begin
    proxy := @_proxies^[i];
    _shape^.compute_aabb(proxy^.aabb, xf, i);
    proxy^.proxy_id := broad_phase^.create_proxy(proxy^.aabb, proxy);
    proxy^.fixture := @self;
    proxy^.child_index := i;
  end;
end;

procedure tb2_fixture.destroy_proxies(const broad_phase: pb2_broad_phase);
  var i: tb2_int32;
  var proxy: pb2_fixture_proxy;
begin
  for i := 0 to _proxy_count - 1 do
  begin
    proxy := @_proxies^[i];
    broad_phase^.destroy_proxy(proxy^.proxy_id);
    proxy^.proxy_id := b2_null_proxy;
  end;
  _proxy_count := 0;
end;

procedure tb2_fixture.synchronize(const broad_phase: pb2_broad_phase; const xf1, xf2: tb2_transform);
  var i: tb2_int32;
  var proxy: pb2_fixture_proxy;
  var aabb1, aabb2: tb2_aabb;
  var displacement: tb2_vec2;
begin
  if _proxy_count = 0 then exit;
  for i := 0 to _proxy_count - 1 do
  begin
    proxy := @_proxies^[i];
    {$hints off}
    _shape^.compute_aabb(aabb1, xf1, proxy^.child_index);
    _shape^.compute_aabb(aabb2, xf2, proxy^.child_index);
    {$hints on}
    proxy^.aabb.combine(aabb1, aabb2);
    displacement := xf2.p - xf1.p;
    broad_phase^.move_proxy(proxy^.proxy_id, proxy^.aabb, displacement);
  end;
end;

constructor tb2_fixture.create;
begin
  _user_data := nil;
  _body := nil;
  _next := nil;
  _proxies := nil;
  _proxy_count := 0;
  _shape := nil;
  _density := 0.0;
end;

function tb2_fixture.get_type: tb2_shape_type;
begin
  result := _shape^.get_type;
end;

function tb2_fixture.get_shape: pb2_shape;
begin
  result := _shape;
end;

procedure tb2_fixture.set_sensor(const sensor: boolean);
begin
  if sensor <> _is_sensor then
  begin
    _body^.set_awake(true);
    _is_sensor := sensor;
  end;
end;

function tb2_fixture.is_sensor: boolean;
begin
  result := _is_sensor;
end;

procedure tb2_fixture.set_filter_data(const filter: tb2_filter);
begin
  _filter := filter;
  refilter;
end;

function tb2_fixture.get_filter_data: tb2_filter;
begin
  result := _filter;
end;

procedure tb2_fixture.refilter;
  var edge: pb2_contact_edge;
  var contact: pb2_contact;
  var fixture_a, fixture_b: pb2_fixture;
  var world: pb2_world;
  var broad_phase: pb2_broad_phase;
  var i: tb2_int32;
begin
  if _body = nil then exit;
  edge := _body^.get_contact_list;
  while edge <> nil do
  begin
    contact := edge^.contact;
    fixture_a := contact^.get_fixture_a;
    fixture_b := contact^.get_fixture_b;
    if (fixture_a = @self) or (fixture_b = @self) then
    contact^.flag_for_filtering;
    edge := edge^.next;
  end;
  world := _body^.get_world;
  if world = nil then exit;
  broad_phase := @world^._contact_manager.broad_phase;
  for i := 0 to _proxy_count - 1 do
  broad_phase^.touch_proxy(_proxies^[i].proxy_id);
end;

function tb2_fixture.get_body: pb2_body;
begin
  result := _body;
end;

function tb2_fixture.get_next: pb2_fixture;
begin
  result := _next;
end;

function tb2_fixture.get_user_data: tb2_ptr;
begin
  result := _user_data;
end;

procedure tb2_fixture.set_user_data(const data: tb2_ptr);
begin
  _user_data := data;
end;

function tb2_fixture.test_point(const p: tb2_vec2): boolean;
begin
  result := _shape^.test_point(_body^.get_transform, p);
end;

function tb2_fixture.ray_cast(var output: tb2_ray_cast_output; const input: tb2_ray_cast_input; const child_index: tb2_int32): boolean;
begin
  result := _shape^.ray_cast(output, input, _body^.get_transform, child_index);
end;

procedure tb2_fixture.get_mass_data(var mass_data: tb2_mass_data);
begin
  _shape^.compute_mass(mass_data, _density);
end;

function tb2_fixture.get_density: tb2_float32;
begin
  result := _density;
end;

procedure tb2_fixture.set_density(const density: tb2_float32);
begin
  _density := density;
end;

function tb2_fixture.get_friction: tb2_float32;
begin
  result := _friction;
end;

procedure tb2_fixture.set_friction(const friction: tb2_float32);
begin
  _friction := friction;
end;

function tb2_fixture.get_restitution: tb2_float32;
begin
  result := _restitution;
end;

procedure tb2_fixture.set_restitution(const restitution: tb2_float32);
begin
  _restitution := restitution;
end;

function tb2_fixture.get_aabb(const child_index: tb2_int32): tb2_aabb;
begin
  result := _proxies^[child_index].aabb;
end;

{$hints off}
procedure tb2_fixture.dump(const body_index: tb2_int32);
begin
  //b2Log("    b2FixtureDef fd;\n");
  //b2Log("    fd.friction = %.15lef;\n", m_friction);
  //b2Log("    fd.restitution = %.15lef;\n", m_restitution);
  //b2Log("    fd.density = %.15lef;\n", m_density);
  //b2Log("    fd.isSensor = bool(%d);\n", m_isSensor);
  //b2Log("    fd.filter.categoryBits = uint16(%d);\n", m_filter.categoryBits);
  //b2Log("    fd.filter.maskBits = uint16(%d);\n", m_filter.maskBits);
  //b2Log("    fd.filter.groupIndex = int16(%d);\n", m_filter.groupIndex);
  //
  //switch (m_shape->m_type)
  //{
  //case b2Shape::e_circle:
	 // {
		//  b2CircleShape* s = (b2CircleShape*)m_shape;
		//  b2Log("    b2CircleShape shape;\n");
		//  b2Log("    shape.m_radius = %.15lef;\n", s->m_radius);
		//  b2Log("    shape.m_p.Set(%.15lef, %.15lef);\n", s->m_p.x, s->m_p.y);
	 // }
	 // break;
  //
  //case b2Shape::e_edge:
	 // {
		//  b2EdgeShape* s = (b2EdgeShape*)m_shape;
		//  b2Log("    b2EdgeShape shape;\n");
		//  b2Log("    shape.m_radius = %.15lef;\n", s->m_radius);
		//  b2Log("    shape.m_vertex0.Set(%.15lef, %.15lef);\n", s->m_vertex0.x, s->m_vertex0.y);
		//  b2Log("    shape.m_vertex1.Set(%.15lef, %.15lef);\n", s->m_vertex1.x, s->m_vertex1.y);
		//  b2Log("    shape.m_vertex2.Set(%.15lef, %.15lef);\n", s->m_vertex2.x, s->m_vertex2.y);
		//  b2Log("    shape.m_vertex3.Set(%.15lef, %.15lef);\n", s->m_vertex3.x, s->m_vertex3.y);
		//  b2Log("    shape.m_hasVertex0 = bool(%d);\n", s->m_hasVertex0);
		//  b2Log("    shape.m_hasVertex3 = bool(%d);\n", s->m_hasVertex3);
	 // }
	 // break;
  //
  //case b2Shape::e_polygon:
	 // {
		//  b2PolygonShape* s = (b2PolygonShape*)m_shape;
		//  b2Log("    b2PolygonShape shape;\n");
		//  b2Log("    b2Vec2 vs[%d];\n", b2_maxPolygonVertices);
		//  for (int32 i = 0; i < s->m_count; ++i)
		//  {
		//	  b2Log("    vs[%d].Set(%.15lef, %.15lef);\n", i, s->m_vertices[i].x, s->m_vertices[i].y);
		//  }
		//  b2Log("    shape.Set(vs, %d);\n", s->m_count);
	 // }
	 // break;
  //
  //case b2Shape::e_chain:
	 // {
		//  b2ChainShape* s = (b2ChainShape*)m_shape;
		//  b2Log("    b2ChainShape shape;\n");
		//  b2Log("    b2Vec2 vs[%d];\n", s->m_count);
		//  for (int32 i = 0; i < s->m_count; ++i)
		//  {
		//	  b2Log("    vs[%d].Set(%.15lef, %.15lef);\n", i, s->m_vertices[i].x, s->m_vertices[i].y);
		//  }
		//  b2Log("    shape.CreateChain(vs, %d);\n", s->m_count);
		//  b2Log("    shape.m_prevVertex.Set(%.15lef, %.15lef);\n", s->m_prevVertex.x, s->m_prevVertex.y);
		//  b2Log("    shape.m_nextVertex.Set(%.15lef, %.15lef);\n", s->m_nextVertex.x, s->m_nextVertex.y);
		//  b2Log("    shape.m_hasPrevVertex = bool(%d);\n", s->m_hasPrevVertex);
		//  b2Log("    shape.m_hasNextVertex = bool(%d);\n", s->m_hasNextVertex);
	 // }
	 // break;
  //
  //default:
	 // return;
  //}
  //
  //b2Log("\n");
  //b2Log("    fd.shape = &shape;\n");
  //b2Log("\n");
  //b2Log("    bodies[%d]->CreateFixture(&fd);\n", bodyIndex);
end;
{$hints on}
//tb2_fixture END

//tb2_contact BEGIN
procedure tb2_contact.flag_for_filtering;
begin
  _flags += [b2_cf_filter_flag];
end;

procedure tb2_contact.add_type(
  const create_fcn: tb2_contact_create_fcn; const destroy_fcn: tb2_contact_destroy_fcn;
  const type_a, type_b: tb2_shape_type
);
begin
  b2_contact_registers[longint(type_a), longint(type_b)].create_fcn := create_fcn;
  b2_contact_registers[longint(type_a), longint(type_b)].destroy_fcn := destroy_fcn;
  b2_contact_registers[longint(type_a), longint(type_b)].primary := true;
  if type_a <> type_b then
  begin
    b2_contact_registers[longint(type_b), longint(type_a)].create_fcn := create_fcn;
    b2_contact_registers[longint(type_b), longint(type_a)].destroy_fcn := destroy_fcn;
    b2_contact_registers[longint(type_b), longint(type_a)].primary := false;
  end;
end;

procedure tb2_contact.initialize_registers;
begin
  add_type(@b2_create_circle_contact, @b2_destroy_circle_contact, b2_st_circle, b2_st_circle);
  add_type(@b2_create_polygon_and_circle_contact, @b2_destroy_polygon_and_circle_contact, b2_st_polygon, b2_st_circle);
  add_type(@b2_create_polygon_contact, @b2_destroy_polygon_contact, b2_st_polygon, b2_st_polygon);
  add_type(@b2_create_edge_and_circle_contact, @b2_destroy_edge_and_circle_contact, b2_st_edge, b2_st_circle);
  add_type(@b2_create_edge_and_polygon_contact, @b2_destroy_edge_and_polygon_contact, b2_st_edge, b2_st_polygon);
  add_type(@b2_create_chain_and_circle_contact, @b2_destroy_chain_and_circle_contact, b2_st_chain, b2_st_circle);
  add_type(@b2_create_chain_and_polygon_contact, @b2_destroy_chain_and_polygon_contact, b2_st_chain, b2_st_polygon);
end;

function tb2_contact.create_contact(
  const fixture_a: pb2_fixture; const index_a: tb2_int32;
  const fixture_b: pb2_fixture; const index_b: tb2_int32;
  const allocator: pb2_block_allocator
): pb2_contact;
  var type_a, type_b: tb2_shape_type;
  var create_fcn: tb2_contact_create_fcn;
begin
  if not b2_contact_initialized then
  begin
    initialize_registers;
    b2_contact_initialized := true;
  end;
  type_a := fixture_a^.get_type;
  type_b := fixture_b^.get_type;
  create_fcn := b2_contact_registers[longint(type_a), longint(type_b)].create_fcn;
  if assigned(create_fcn) then
  begin
    if b2_contact_registers[longint(type_a), longint(type_b)].primary then
    result := create_fcn(fixture_a, index_a, fixture_b, index_b, allocator)
    else
    result := create_fcn(fixture_b, index_b, fixture_a, index_a, allocator);
  end
  else
  result := nil;
end;

//procedure tb2_contact.destroy_contact(var contact: pb2_contact; const type_a, type_b: tb2_shape_type; const allocator: pb2_block_allocator);
//begin
//
//end;

procedure tb2_contact.destroy_contact(var contact: pb2_contact; const allocator: pb2_block_allocator);
  var fixture_a, fixture_b: pb2_fixture;
  var type_a, type_b: tb2_shape_type;
  var destroy_fcn: tb2_contact_destroy_fcn;
begin
  fixture_a := contact^._fixture_a;
  fixture_b := contact^._fixture_b;
  if (contact^._manifold.point_count > 0)
  and (not fixture_a^.is_sensor)
  and (not fixture_b^.is_sensor) then
  begin
    fixture_a^.get_body^.set_awake(true);
    fixture_b^.get_body^.set_awake(true);
  end;
  type_a := fixture_a^.get_type;
  type_b := fixture_b^.get_type;
  destroy_fcn := b2_contact_registers[longint(type_a), longint(type_b)].destroy_fcn;
  destroy_fcn(contact, allocator);
end;

procedure tb2_contact.update(const listener: tb2_contact_listener);
  var old_manifold: tb2_manifold;
  var touching, was_touching, sensor_a, sensor_b, sensor: boolean;
  var body_a, body_b: pb2_body;
  var xf_a, xf_b: tb2_transform;
  var shape_a, shape_b: pb2_shape;
  var i, j: tb2_int32;
  var mp2, mp1: pb2_manifold_point;
  var id2: tb2_contact_id;
begin
  old_manifold := _manifold;
  _flags += [b2_cf_enabled_flag];
  touching := false;
  was_touching := b2_cf_touching_flag in _flags;
  sensor_a := _fixture_a^.is_sensor;
  sensor_b := _fixture_b^.is_sensor;
  sensor := sensor_a or sensor_b;
  body_a := _fixture_a^.get_body;
  body_b := _fixture_b^.get_body;
  xf_a := body_a^.get_transform;
  xf_b := body_b^.get_transform;
  if sensor then
  begin
    shape_a := _fixture_a^.get_shape;
    shape_b := _fixture_b^.get_shape;
    touching := b2_test_overlap(shape_a, _index_a, shape_b, _index_b, xf_a, xf_b);
    _manifold.point_count := 0;
  end
  else
  begin
    evaluate(_manifold, xf_a, xf_b);
    touching := _manifold.point_count > 0;
    for i := 0 to _manifold.point_count - 1 do
    begin
      mp2 := @_manifold.points[i];
      mp2^.normal_impulse := 0.0;
      mp2^.tangent_impulse := 0.0;
      id2 := mp2^.id;
      for j := 0 to old_manifold.point_count - 1 do
      begin
        mp1 := @old_manifold.points[j];
        if mp1^.id.key = id2.key then
        begin
  	  mp2^.normal_impulse := mp1^.normal_impulse;
  	  mp2^.tangent_impulse := mp1^.tangent_impulse;
  	  break;
        end;
      end;
    end;
    if touching <> was_touching then
    begin
      body_a^.set_awake(true);
      body_b^.set_awake(true);
    end;
  end;
  if touching then
  _flags += [b2_cf_touching_flag]
  else
  _flags -= [b2_cf_touching_flag];
  if (not was_touching) and (touching) and (listener <> nil) then
  listener.begin_contact(@self);
  if (was_touching) and (not touching) and (listener <> nil) then
  listener.end_contact(@self);
  if (not sensor) and (touching) and (listener <> nil) then
  listener.pre_solve(@self, @old_manifold);
end;

constructor tb2_contact.create;
begin
  _fixture_a := nil;
  _fixture_b := nil;
end;

constructor tb2_contact.create(const f_a: pb2_fixture; const index_a: tb2_int32; const f_b: pb2_fixture; const index_b: tb2_int32);
begin
  _flags := [b2_cf_enabled_flag];
  _fixture_a := f_a;
  _fixture_b := f_b;
  _index_a := index_a;
  _index_b := index_b;
  _manifold.point_count := 0;
  _prev := nil;
  _next := nil;
  _node_a.contact := nil;
  _node_a.prev := nil;
  _node_a.next := nil;
  _node_a.other := nil;
  _node_b.contact := nil;
  _node_b.prev := nil;
  _node_b.next := nil;
  _node_b.other := nil;
  _toi_count := 0;
  _friction := b2_mix_friction(_fixture_a^._friction, _fixture_b^._friction);
  _restitution := b2_mix_restitution(_fixture_a^._restitution, _fixture_b^._restitution);
  _tangent_speed := 0.0;
end;

destructor tb2_contact.destroy;
begin
end;

function tb2_contact.get_manifold: pb2_manifold;
begin
  result := @_manifold;
end;

procedure tb2_contact.get_world_manifold(var world_manifold: tb2_world_manifold);
begin
  world_manifold.initialize(
    @_manifold,
    _fixture_a^.get_body^.get_transform, _fixture_a^.get_shape^.radius,
    _fixture_b^.get_body^.get_transform, _fixture_b^.get_shape^.radius
  );
end;

function tb2_contact.is_touching: boolean;
begin
  result := b2_cf_touching_flag in _flags;
end;

procedure tb2_contact.set_enabled(const flag: boolean);
begin
  if flag then
  _flags += [b2_cf_enabled_flag]
  else
  _flags -= [b2_cf_enabled_flag];
end;

function tb2_contact.is_enabled: boolean;
begin
  result := b2_cf_enabled_flag in _flags;
end;

function tb2_contact.get_next: pb2_contact;
begin
  result := _next;
end;

function tb2_contact.get_fixture_a: pb2_fixture;
begin
  result := _fixture_a;
end;

function tb2_contact.get_child_index_a: tb2_int32;
begin
  result := _index_a;
end;

function tb2_contact.get_fixture_b: pb2_fixture;
begin
  result := _fixture_b;
end;

function tb2_contact.get_child_index_b: tb2_int32;
begin
  result := _index_b;
end;

procedure tb2_contact.set_friction(const friction: tb2_float32);
begin
  _friction := friction;
end;

function tb2_contact.get_friction: tb2_float32;
begin
  result := _friction;
end;

procedure tb2_contact.reset_friction;
begin
  _friction := b2_mix_friction(_fixture_a^.get_friction, _fixture_b^.get_friction);
end;

procedure tb2_contact.set_restitution(const restitution: tb2_float32);
begin
  _restitution := restitution;
end;

function tb2_contact.get_restitution: tb2_float32;
begin
  result := _restitution;
end;

procedure tb2_contact.reset_restitution;
begin
  _restitution := b2_mix_restitution(_fixture_a^.get_restitution, _fixture_b^.get_restitution);
end;

procedure tb2_contact.set_tangent_speed(const speed: tb2_float32);
begin
  _tangent_speed := speed;
end;

function tb2_contact.get_tangent_speed: tb2_float32;
begin
  result := _tangent_speed;
end;
//tb2_contact END

//tb2_circle_contact BEGIN
constructor tb2_circle_contact.create_circle_contact(const fixture_a, fixture_b: pb2_fixture);
begin
  inherited create(fixture_a, 0, fixture_b, 0);
end;

procedure tb2_circle_contact.evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform);
begin
  b2_collide_circles(
    manifold,
    pb2_circle_shape(_fixture_a^.get_shape), xf_a,
    pb2_circle_shape(_fixture_b^.get_shape), xf_b
  );
end;
//tb2_circle_contact END

//tb2_polygon_and_circle_contact BEGIN
constructor tb2_polygon_and_circle_contact.create_polygon_and_circle_contact(const fixture_a, fixture_b: pb2_fixture);
begin
  inherited create(fixture_a, 0, fixture_b, 0);
end;

procedure tb2_polygon_and_circle_contact.evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform);
begin
  b2_collide_polygon_and_circle(
    manifold,
    pb2_polygon_shape(_fixture_a^.get_shape), xf_a,
    pb2_circle_shape(_fixture_b^.get_shape), xf_b
  );
end;
//tb2_polygon_and_circle_contact END

//tb2_polygon_contact BEGIN
constructor tb2_polygon_contact.create_polygon_contact(const fixture_a, fixture_b: pb2_fixture);
begin
  inherited create(fixture_a, 0, fixture_b, 0);
end;

procedure tb2_polygon_contact.evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform);
begin
  b2_collide_polygons(
    manifold,
    pb2_polygon_shape(_fixture_a^.get_shape), xf_a,
    pb2_polygon_shape(_fixture_b^.get_shape), xf_b
  );
end;
//tb2_polygon_contact END

//tb2_edge_and_circle_contact BEGIN
constructor tb2_edge_and_circle_contact.create_edge_and_circle_contact(const fixture_a, fixture_b: pb2_fixture);
begin
  inherited create(fixture_a, 0, fixture_b, 0);
end;

procedure tb2_edge_and_circle_contact.evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform);
begin
  b2_collide_edge_and_circle(
    manifold,
    pb2_edge_shape(_fixture_a^.get_shape), xf_a,
    pb2_circle_shape(_fixture_b^.get_shape), xf_b
  );
end;
//tb2_edge_and_circle_contact END

//tb2_edge_and_polygon_contact BEGIN
constructor tb2_edge_and_polygon_contact.create_edge_and_polygon_contact(const fixture_a, fixture_b: pb2_fixture);
begin
  inherited create(fixture_a, 0, fixture_b, 0);
end;

procedure tb2_edge_and_polygon_contact.evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform);
begin
  b2_collide_edge_and_polygon(
    manifold,
    pb2_edge_shape(_fixture_a^.get_shape), xf_a,
    pb2_polygon_shape(_fixture_b^.get_shape), xf_b
  );
end;
//tb2_edge_and_polygon_contact END

//tb2_chain_and_circle_contact BEGIN
constructor tb2_chain_and_circle_contact.create_chain_and_circle_contact(
  const fixture_a: pb2_fixture; const index_a: tb2_int32;
  const fixture_b: pb2_fixture; const index_b: tb2_int32
);
begin
  inherited create(fixture_a, index_a, fixture_b, index_b);
end;

procedure tb2_chain_and_circle_contact.evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform);
  var chain: pb2_chain_shape;
  var edge: tb2_edge_shape;
begin
  edge.create;
  chain := pb2_chain_shape(_fixture_a^.get_shape);
  chain^.get_child_edge(@edge, _index_a);
  b2_collide_edge_and_circle(
    manifold,
    @edge, xf_a,
    pb2_circle_shape(_fixture_b^.get_shape), xf_b
  );
end;
//tb2_chain_and_circle_contact END

//tb2_chain_and_polygon_contact BEGIN
constructor tb2_chain_and_polygon_contact.create_chain_and_polygon_contact(
  const fixture_a: pb2_fixture; const index_a: tb2_int32;
  const fixture_b: pb2_fixture; const index_b: tb2_int32
);
begin
  inherited create(fixture_a, index_a, fixture_b, index_b);
end;

procedure tb2_chain_and_polygon_contact.evaluate(var manifold: tb2_manifold; const xf_a, xf_b: tb2_transform);
  var chain: pb2_chain_shape;
  var edge: tb2_edge_shape;
begin
  chain := pb2_chain_shape(_fixture_a^.get_shape);
  chain^.get_child_edge(@edge, _index_a);
  b2_collide_edge_and_polygon(
    manifold,
    @edge, xf_a,
    pb2_polygon_shape(_fixture_b^.get_shape), xf_b
  );
end;
//tb2_chain_and_polygon_contact END

//tb2_contact_solver BEGIN
function tb2_contact_solver.initialize_position_solver_manifold(
  const pc: pb2_contact_position_constraint;
  const xf_a, xf_b: tb2_transform; const index: tb2_int32
): tposition_solver_manifold;
  var point_a, point_b, plane_point, clip_point: tb2_vec2;
begin
  case pc^.manifold_type of
    b2_mt_circles:
    begin
      point_a := b2_mul(xf_a, pc^.local_point);
      point_b := b2_mul(xf_b, pc^.local_points[0]);
      result.normal := point_b - point_a;
      result.normal.normalize;
      result.point := 0.5 * (point_a + point_b);
      result.separation := b2_dot(point_b - point_a, result.normal) - pc^.radius_a - pc^.radius_b;
    end;
    b2_mt_face_a:
    begin
      result.normal := b2_mul(xf_a.q, pc^.local_normal);
      plane_point := b2_mul(xf_a, pc^.local_point);
      clip_point := b2_mul(xf_b, pc^.local_points[index]);
      result.separation := b2_dot(clip_point - plane_point, result.normal) - pc^.radius_a - pc^.radius_b;
      result.point := clip_point;
    end;
    b2_mt_face_b:
    begin
      result.normal := b2_mul(xf_b.q, pc^.local_normal);
      plane_point := b2_mul(xf_b, pc^.local_point);
      clip_point := b2_mul(xf_a, pc^.local_points[index]);
      result.separation := b2_dot(clip_point - plane_point, result.normal) - pc^.radius_a - pc^.radius_b;
      result.point := clip_point;
      result.normal := -result.normal;
    end;
  end;
end;

constructor tb2_contact_solver.create(const def: tb2_contact_solver_def);
  var i, j, point_count: tb2_int32;
  var contact: pb2_contact;
  var fixture_a, fixture_b: pb2_fixture;
  var shape_a, shape_b: pb2_shape;
  var radius_a, radius_b: tb2_float32;
  var body_a, body_b: pb2_body;
  var manifold: pb2_manifold;
  var vc: pb2_contact_velocity_constraint;
  var pc: pb2_contact_position_constraint;
  var cp: pb2_manifold_point;
  var vcp: pb2_velocity_constraint_point;
begin
  step := def.step;
  allocator := def.allocator;
  count := def.count;
  position_constraints := pb2_contact_position_constraint_arr(allocator^.alloc(count * sizeof(tb2_contact_position_constraint)));
  velocity_constraints := pb2_contact_velocity_constraint_arr(allocator^.alloc(count * sizeof(tb2_contact_velocity_constraint)));
  positions := def.positions;
  velocities := def.velocities;
  contacts := def.contacts;
  for i := 0 to count - 1 do
  begin
    contact := contacts^[i];
    fixture_a := contact^.get_fixture_a;
    fixture_b := contact^.get_fixture_b;
    shape_a := fixture_a^.get_shape;
    shape_b := fixture_b^.get_shape;
    radius_a := shape_a^.radius;
    radius_b := shape_b^.radius;
    body_a := fixture_a^.get_body;
    body_b := fixture_b^.get_body;
    manifold := contact^.get_manifold;
    point_count := manifold^.point_count;
    vc := @velocity_constraints^[i];
    vc^.friction := contact^.get_friction;
    vc^.restitution := contact^.get_restitution;
    vc^.tangent_speed := contact^.get_tangent_speed;
    vc^.index_a := body_a^._island_index;
    vc^.index_b := body_b^._island_index;
    vc^.rcp_mass_a := body_a^._rcp_mass;
    vc^.rcp_mass_b := body_b^._rcp_mass;
    vc^.rcp_inertia_a := body_a^._rcp_inertia;
    vc^.rcp_inertia_b := body_b^._rcp_inertia;
    vc^.contact_index := i;
    vc^.point_count := point_count;
    vc^.k.set_zero;
    vc^.normal_mass.set_zero;
    pc := @position_constraints^[i];
    pc^.index_a := body_a^._island_index;
    pc^.index_b := body_b^._island_index;
    pc^.rcp_mass_a := body_a^._rcp_mass;
    pc^.rcp_mass_b := body_b^._rcp_mass;
    pc^.local_center_a := body_a^._sweep.local_center;
    pc^.local_center_b := body_b^._sweep.local_center;
    pc^.rcp_inertia_a := body_a^._rcp_inertia;
    pc^.rcp_inertia_b := body_b^._rcp_inertia;
    pc^.local_normal := manifold^.local_normal;
    pc^.local_point := manifold^.local_point;
    pc^.point_count := point_count;
    pc^.radius_a := radius_a;
    pc^.radius_b := radius_b;
    pc^.manifold_type := manifold^.manifold_type;
    for j := 0 to point_count - 1 do
    begin
      cp := @manifold^.points[j];
      vcp := @vc^.points[j];
      if step.warm_starting then
      begin
	vcp^.normal_impulse := step.dt_ratio * cp^.normal_impulse;
	vcp^.tangent_impulse := step.dt_ratio * cp^.tangent_impulse;
      end
      else
      begin
	vcp^.normal_impulse := 0.0;
	vcp^.tangent_impulse := 0.0;
      end;
      vcp^.r_a.set_zero;
      vcp^.r_b.set_zero;
      vcp^.normal_mass := 0.0;
      vcp^.tangent_mass := 0.0;
      vcp^.velocity_bias := 0.0;
      pc^.local_points[j] := cp^.local_point;
    end;
  end;
end;

destructor tb2_contact_solver.destroy;
begin
  allocator^.free(velocity_constraints);
  allocator^.free(position_constraints);
end;

procedure tb2_contact_solver.initialize_velocity_constraints;
  var i, j, index_a, index_b: tb2_int32;
  var vc: pb2_contact_velocity_constraint;
  var pc: pb2_contact_position_constraint;
  var radius_a, radius_b, m_a, m_b, i_a, i_b, a_a, w_a, a_b, w_b, rn_a, rn_b, k_normal, rt_a, rt_b, k_tangent, v_rel: tb2_float32;
  var manifold: pb2_manifold;
  var local_center_a, local_center_b, c_a, v_a, c_b, v_b, tangent: tb2_vec2;
  var xf_a, xf_b: tb2_transform;
  var world_manifold: tb2_world_manifold;
  var point_count: tb2_int32;
  var vcp, vcp1, vcp2: pb2_velocity_constraint_point;
  var rn1_a, rn1_b, rn2_a, rn2_b, k11, k22, k12: tb2_float32;
  const max_condition_number = 1000.0;
begin
  for i := 0 to count - 1 do
  begin
    vc := @velocity_constraints^[i];
    pc := @position_constraints^[i];
    radius_a := pc^.radius_a;
    radius_b := pc^.radius_b;
    manifold := contacts^[vc^.contact_index]^.get_manifold;
    index_a := vc^.index_a;
    index_b := vc^.index_b;
    m_a := vc^.rcp_mass_a;
    m_b := vc^.rcp_mass_b;
    i_a := vc^.rcp_inertia_a;
    i_b := vc^.rcp_inertia_b;
    local_center_a := pc^.local_center_a;
    local_center_b := pc^.local_center_b;
    c_a := positions^[index_a].c;
    a_a := positions^[index_a].a;
    v_a := velocities^[index_a].v;
    w_a := velocities^[index_a].w;
    c_b := positions^[index_b].c;
    a_b := positions^[index_b].a;
    v_b := velocities^[index_b].v;
    w_b := velocities^[index_b].w;
    xf_a.q.set_value(a_a);
    xf_b.q.set_value(a_b);
    xf_a.p := c_a - b2_mul(xf_a.q, local_center_a);
    xf_b.p := c_b - b2_mul(xf_b.q, local_center_b);
    world_manifold.initialize(manifold, xf_a, radius_a, xf_b, radius_b);
    vc^.normal := world_manifold.normal;
    point_count := vc^.point_count;
    for j := 0 to point_count - 1 do
    begin
      vcp := @vc^.points[j];
      vcp^.r_a := world_manifold.points[j] - c_a;
      vcp^.r_b := world_manifold.points[j] - c_b;
      rn_a := b2_cross(vcp^.r_a, vc^.normal);
      rn_b := b2_cross(vcp^.r_b, vc^.normal);
      k_normal := m_a + m_b + i_a * rn_a * rn_a + i_b * rn_b * rn_b;
      if k_normal > 0.0 then
      vcp^.normal_mass := 1.0 / k_normal
      else
      vcp^.normal_mass := 0.0;
      tangent := b2_cross(vc^.normal, 1.0);
      rt_a := b2_cross(vcp^.r_a, tangent);
      rt_b := b2_cross(vcp^.r_b, tangent);
      k_tangent := m_a + m_b + i_a * rt_a * rt_a + i_b * rt_b * rt_b;
      if k_tangent > 0.0 then
      vcp^.tangent_mass := 1.0 /  k_tangent
      else
      vcp^.tangent_mass := 0.0;
      vcp^.velocity_bias := 0.0;
      v_rel := b2_dot(vc^.normal, v_b + b2_cross(w_b, vcp^.r_b) - v_a - b2_cross(w_a, vcp^.r_a));
      if v_rel < -b2_velocity_threshold then
      vcp^.velocity_bias := -vc^.restitution * v_rel;
    end;
    if (vc^.point_count = 2) and (b2_block_solve) then
    begin
      vcp1 := @vc^.points[0];
      vcp2 := @vc^.points[1];
      rn1_a := b2_cross(vcp1^.r_a, vc^.normal);
      rn1_b := b2_cross(vcp1^.r_b, vc^.normal);
      rn2_a := b2_cross(vcp2^.r_a, vc^.normal);
      rn2_b := b2_cross(vcp2^.r_b, vc^.normal);
      k11 := m_a + m_b + i_a * rn1_a * rn1_a + i_b * rn1_b * rn1_b;
      k22 := m_a + m_b + i_a * rn2_a * rn2_a + i_b * rn2_b * rn2_b;
      k12 := m_a + m_b + i_a * rn1_a * rn2_a + i_b * rn1_b * rn2_b;
      if k11 * k11 < max_condition_number * (k11 * k22 - k12 * k12) then
      begin
	vc^.k.ex.set_value(k11, k12);
	vc^.k.ey.set_value(k12, k22);
	vc^.normal_mass := vc^.k.get_inverse;
      end
      else
      begin
	vc^.point_count := 1;
      end;
    end;
  end;
end;

procedure tb2_contact_solver.warm_start;
  var i, j, index_a, index_b, point_count: tb2_int32;
  var m_a, i_a, m_b, i_b, w_a, w_b: tb2_float32;
  var vc: pb2_contact_velocity_constraint;
  var vcp: pb2_velocity_constraint_point;
  var v_a, v_b, normal, tangent, p: tb2_vec2;
begin
  for i := 0 to count - 1 do
  begin
    vc := @velocity_constraints^[i];
    index_a := vc^.index_a;
    index_b := vc^.index_b;
    m_a := vc^.rcp_mass_a;
    i_a := vc^.rcp_inertia_a;
    m_b := vc^.rcp_mass_b;
    i_b := vc^.rcp_inertia_b;
    point_count := vc^.point_count;
    v_a := velocities^[index_a].v;
    w_a := velocities^[index_a].w;
    v_b := velocities^[index_b].v;
    w_b := velocities^[index_b].w;
    normal := vc^.normal;
    tangent := b2_cross(normal, 1.0);
    for j := 0 to point_count - 1 do
    begin
      vcp := @vc^.points[j];
      p := vcp^.normal_impulse * normal + vcp^.tangent_impulse * tangent;
      w_a -= i_a * b2_cross(vcp^.r_a, p);
      v_a := v_a - (m_a * p);
      w_b += i_b * b2_cross(vcp^.r_b, p);
      v_b := v_b + (m_b * p);
    end;
    velocities^[index_a].v := v_a;
    velocities^[index_a].w := w_a;
    velocities^[index_b].v := v_b;
    velocities^[index_b].w := w_b;
  end;
end;

procedure tb2_contact_solver.solve_velocity_constraints;
  var i, i1, j, index_a, index_b, point_count: tb2_int32;
  var vc: pb2_contact_velocity_constraint;
  var m_a, i_a, m_b, i_b, w_a, w_b, friction, vt, lambda, max_friction, new_impulse, vn, vn1, vn2: tb2_float32;
  var v_a, v_b, normal, tangent, dv, p, a, dv1, dv2, b, x, d, p1, p2: tb2_vec2;
  var vcp, cp1, cp2: pb2_velocity_constraint_point;
begin
  for i := 0 to count - 1 do
  begin
    vc := @velocity_constraints^[i];
    index_a := vc^.index_a;
    index_b := vc^.index_b;
    m_a := vc^.rcp_mass_a;
    i_a := vc^.rcp_inertia_a;
    m_b := vc^.rcp_mass_b;
    i_b := vc^.rcp_inertia_b;
    point_count := vc^.point_count;
    v_a := velocities^[index_a].v;
    w_a := velocities^[index_a].w;
    v_b := velocities^[index_b].v;
    w_b := velocities^[index_b].w;
    normal := vc^.normal;
    tangent := b2_cross(normal, 1.0);
    friction := vc^.friction;
    for j := 0 to point_count - 1 do
    begin
      vcp := @vc^.points[j];
      dv := v_b + b2_cross(w_b, vcp^.r_b) - v_a - b2_cross(w_a, vcp^.r_a);
      vt := b2_dot(dv, tangent) - vc^.tangent_speed;
      lambda := vcp^.tangent_mass * (-vt);
      max_friction := friction * vcp^.normal_impulse;
      new_impulse := b2_clamp(vcp^.tangent_impulse + lambda, -max_friction, max_friction);
      lambda := new_impulse - vcp^.tangent_impulse;
      vcp^.tangent_impulse := new_impulse;
      P := lambda * tangent;
      v_a := v_a - (m_a * p);
      w_a -= i_a * b2_cross(vcp^.r_a, p);
      v_b := v_b + (m_b * p);
      w_b += i_b * b2_cross(vcp^.r_b, p);
    end;
    if (point_count = 1) or not b2_block_solve then
    begin
      for i1 := 0 to point_count - 1 do
      begin
	vcp := @vc^.points[i1];
	dv := v_b + b2_cross(w_b, vcp^.r_b) - v_a - b2_cross(w_a, vcp^.r_a);
	vn := b2_dot(dv, normal);
	lambda := -vcp^.normal_mass * (vn - vcp^.velocity_bias);
	new_impulse := b2_max(vcp^.normal_impulse + lambda, 0.0);
	lambda := new_impulse - vcp^.normal_impulse;
	vcp^.normal_impulse := new_impulse;
	p := lambda * normal;
	v_a := v_a - (m_a * p);
	w_a -= i_a * b2_cross(vcp^.r_a, p);
	v_b := v_b + (m_b * p);
	w_b += i_b * b2_cross(vcp^.r_b, p);
      end;
    end
    else
    begin
      cp1 := @vc^.points[0];
      cp2 := @vc^.points[1];
      a.set_value(cp1^.normal_impulse, cp2^.normal_impulse);
      dv1 := v_b + b2_cross(w_b, cp1^.r_b) - v_a - b2_cross(w_a, cp1^.r_a);
      dv2 := v_b + b2_cross(w_b, cp2^.r_b) - v_a - b2_cross(w_a, cp2^.r_a);
      vn1 := b2_dot(dv1, normal);
      vn2 := b2_dot(dv2, normal);
      b.x := vn1 - cp1^.velocity_bias;
      b.y := vn2 - cp2^.velocity_bias;
      b := b - b2_mul(vc^.k, a);
      while true do
      begin
	x := - b2_mul(vc^.normal_mass, b);
	if (x.x >= 0.0) and (x.y >= 0.0) then
	begin
	  d := x - a;
	  p1 := d.x * normal;
	  p2 := d.y * normal;
	  v_a := v_a - (m_a * (p1 + p2));
	  w_a -= i_a * (b2_cross(cp1^.r_a, p1) + b2_cross(cp2^.r_a, p2));
	  v_b := v_b + (m_b * (p1 + p2));
	  w_b += i_b * (b2_cross(cp1^.r_b, p1) + b2_cross(cp2^.r_b, p2));
	  cp1^.normal_impulse := x.x;
	  cp2^.normal_impulse := x.y;
	  break;
	end;
	x.x := -cp1^.normal_mass * b.x;
	x.y := 0.0;
	vn1 := 0.0;
	vn2 := vc^.k.ex.y * x.x + b.y;
	if (x.x >= 0.0) and (vn2 >= 0.0) then
	begin
	  d := x - a;
	  p1 := d.x * normal;
	  p2 := d.y * normal;
	  v_a := v_a - (m_a * (p1 + p2));
	  w_a -= i_a * (b2_cross(cp1^.r_a, p1) + b2_cross(cp2^.r_a, p2));
	  v_b := v_b + (m_b * (p1 + p2));
	  w_b += i_b * (b2_cross(cp1^.r_b, p1) + b2_cross(cp2^.r_b, p2));
	  cp1^.normal_impulse := x.x;
	  cp2^.normal_impulse := x.y;
	  break;
	end;
	x.x := 0.0;
	x.y := -cp2^.normal_mass * b.y;
	vn1 := vc^.k.ey.x * x.y + b.x;
	vn2 := 0.0;
	if (x.y >= 0.0) and (vn1 >= 0.0) then
	begin
	  d := x - a;
	  p1 := d.x * normal;
	  p2 := d.y * normal;
	  v_a := v_a - (m_a * (p1 + p2));
	  w_a -= i_a * (b2_cross(cp1^.r_a, p1) + b2_cross(cp2^.r_a, p2));
	  v_b := v_b + (m_b * (p1 + p2));
	  w_b += i_b * (b2_cross(cp1^.r_b, p1) + b2_cross(cp2^.r_b, p2));
	  cp1^.normal_impulse := x.x;
	  cp2^.normal_impulse := x.y;
	  break;
	end;
	x.x := 0.0;
	x.y := 0.0;
	vn1 := b.x;
	vn2 := b.y;
	if (vn1 >= 0.0) and (vn2 >= 0.0) then
	begin
	  d := x - a;
	  p1 := d.x * normal;
	  p2 := d.y * normal;
	  v_a := v_a - (m_a * (p1 + p2));
	  w_a -= i_a * (b2_cross(cp1^.r_a, p1) + b2_cross(cp2^.r_a, p2));
	  v_b := v_b + (m_b * (p1 + p2));
	  w_b += i_b * (b2_cross(cp1^.r_b, p1) + b2_cross(cp2^.r_b, p2));
	  cp1^.normal_impulse := x.x;
	  cp2^.normal_impulse := x.y;
	  break;
	end;
	break;
      end;
    end;
    velocities^[index_a].v := v_a;
    velocities^[index_a].w := w_a;
    velocities^[index_b].v := v_b;
    velocities^[index_b].w := w_b;
  end;
end;

procedure tb2_contact_solver.store_impulses;
  var i, j: tb2_int32;
  var vc: pb2_contact_velocity_constraint;
  var manifold: pb2_manifold;
begin
  for i := 0 to count - 1 do
  begin
    vc := @velocity_constraints^[i];
    manifold := contacts^[vc^.contact_index]^.get_manifold;
    for j := 0 to vc^.point_count - 1 do
    begin
      manifold^.points[j].normal_impulse := vc^.points[j].normal_impulse;
      manifold^.points[j].tangent_impulse := vc^.points[j].tangent_impulse;
    end;
  end;
end;

function tb2_contact_solver.solve_position_constraints: boolean;
  var min_separation, m_a, i_a, m_b, i_b, a_a, a_b, separation, c, rn_a, rn_b, k, impulse: tb2_float32;
  var i, j, index_a, index_b, point_count: tb2_int32;
  var local_center_a, local_center_b, c_a, c_b, normal, point, r_a, r_b, p: tb2_vec2;
  var pc: pb2_contact_position_constraint;
  var xf_a, xf_b: tb2_transform;
  var psm: tposition_solver_manifold;
begin
  min_separation := 0.0;
  for i := 0 to count - 1 do
  begin
    pc := @position_constraints^[i];
    index_a := pc^.index_a;
    index_b := pc^.index_b;
    local_center_a := pc^.local_center_a;
    m_a := pc^.rcp_mass_a;
    i_a := pc^.rcp_inertia_a;
    local_center_b := pc^.local_center_b;
    m_b := pc^.rcp_mass_b;
    i_b := pc^.rcp_inertia_b;
    point_count := pc^.point_count;
    c_a := positions^[index_a].c;
    a_a := positions^[index_a].a;
    c_b := positions^[index_b].c;
    a_b := positions^[index_b].a;
    for j := 0 to point_count - 1 do
    begin
      xf_a.q.set_value(a_a);
      xf_b.q.set_value(a_b);
      xf_a.p := c_a - b2_mul(xf_a.q, local_center_a);
      xf_b.p := c_b - b2_mul(xf_b.q, local_center_b);
      psm := initialize_position_solver_manifold(pc, xf_a, xf_b, j);
      normal := psm.normal;
      point := psm.point;
      separation := psm.separation;
      r_a := point - c_a;
      r_b := point - c_b;
      min_separation := b2_min(min_separation, separation);
      c := b2_clamp(b2_baumgarte * (separation + b2_linear_slop), -b2_max_linear_correction, 0.0);
      rn_a := b2_cross(r_a, normal);
      rn_b := b2_cross(r_b, normal);
      k := m_a + m_b + i_a * rn_a * rn_a + i_b * rn_b * rn_b;
      if k > 0.0 then
      impulse := -(c / k)
      else
      impulse := 0.0;
      p := impulse * normal;
      c_a := c_a - (m_a * p);
      a_a -= i_a * b2_cross(r_a, p);
      c_b := c_b + (m_b * p);
      a_b += i_b * b2_cross(r_b, p);
    end;
    positions^[index_a].c := c_a;
    positions^[index_a].a := a_a;
    positions^[index_b].c := c_b;
    positions^[index_b].a := a_b;
  end;
  result := min_separation >= -3.0 * b2_linear_slop;
end;

function tb2_contact_solver.solve_toi_position_constraints(const toi_index_a, toi_index_b: tb2_int32): boolean;
  var min_separation, m_a, i_a, m_b, i_b, a_a, a_b, separation, c, rn_a, rn_b, k, impulse: tb2_float32;
  var i, j, index_a, index_b, point_count: tb2_int32;
  var local_center_a, local_center_b, c_a, c_b, normal, point, r_a, r_b, p: tb2_vec2;
  var pc: pb2_contact_position_constraint;
  var xf_a, xf_b: tb2_transform;
  var psm: tposition_solver_manifold;
begin
  min_separation := 0.0;
  for i := 0 to count - 1 do
  begin
    pc := @position_constraints^[i];
    index_a := pc^.index_a;
    index_b := pc^.index_b;
    local_center_a := pc^.local_center_a;
    local_center_b := pc^.local_center_b;
    point_count := pc^.point_count;
    m_a := 0.0;
    i_a := 0.0;
    if (index_a = toi_index_a) or (index_a = toi_index_b) then
    begin
      m_a := pc^.rcp_mass_a;
      i_a := pc^.rcp_inertia_a;
    end;
    m_b := 0.0;
    i_b := 0.0;
    if (index_b = toi_index_a) or (index_b = toi_index_b) then
    begin
      m_b := pc^.rcp_mass_b;
      i_b := pc^.rcp_inertia_b;
    end;
    c_a := positions^[index_a].c;
    a_a := positions^[index_a].a;
    c_b := positions^[index_b].c;
    a_b := positions^[index_b].a;
    for j := 0 to point_count - 1 do
    begin
      xf_a.q.set_value(a_a);
      xf_b.q.set_value(a_b);
      xf_a.p := c_a - b2_mul(xf_a.q, local_center_a);
      xf_b.p := c_b - b2_mul(xf_b.q, local_center_b);
      psm := initialize_position_solver_manifold(pc, xf_a, xf_b, j);
      normal := psm.normal;
      point := psm.point;
      separation := psm.separation;
      r_a := point - c_a;
      r_b := point - c_b;
      min_separation := b2_min(min_separation, separation);
      c := b2_clamp(b2_toi_baugarte * (separation + b2_linear_slop), -b2_max_linear_correction, 0.0);
      rn_a := b2_cross(r_a, normal);
      rn_b := b2_cross(r_b, normal);
      k := m_a + m_b + i_a * rn_a * rn_a + i_b * rn_b * rn_b;
      if k > 0.0 then
      impulse := - (c / k)
      else
      impulse := 0.0;
      p := impulse * normal;
      c_a := c_a - (m_a * p);
      a_a -= i_a * b2_cross(r_a, p);
      c_b := c_b + (m_b * p);
      a_b += i_b * b2_cross(r_b, p);
    end;
    positions^[index_a].c := c_a;
    positions^[index_a].a := a_a;
    positions^[index_b].c := c_b;
    positions^[index_b].a := a_b;
  end;
  result := min_separation >= -1.5 * b2_linear_slop;
end;
//tb2_contact_solver_END

//tb2_contact_filter BEGIN
function tb2_contact_filter.should_collide(const fixture_a, fixture_b: pb2_fixture): boolean;
begin
  if (fixture_a^.get_filter_data.group_index = fixture_b^.get_filter_data.group_index)
  and (fixture_a^.get_filter_data.group_index <> 0) then
  begin
    result := fixture_a^.get_filter_data.group_index > 0;
    exit;
  end;
  result := (
    ((fixture_a^.get_filter_data.mask_bits and fixture_b^.get_filter_data.category_bits) <> 0)
    and ((fixture_a^.get_filter_data.category_bits and fixture_b^.get_filter_data.mask_bits) <> 0)
  );
end;
//tb2_contact_filter END

//tb2_contact_listener BEGIN
{$hints off}
procedure tb2_contact_listener.begin_contact(const contact: pb2_contact);
begin
end;

procedure tb2_contact_listener.end_contact(const contact: pb2_contact);
begin
end;

procedure tb2_contact_listener.pre_solve(const contact: pb2_contact; const old_manifold: pb2_manifold);
begin
end;

procedure tb2_contact_listener.post_solve(const contact: pb2_contact; const impulse: pb2_contact_impulse);
begin
end;
{$hints on}
//tb2_contact_listener END

//tb2_contact_manager BEGIN
constructor tb2_contact_manager.create;
begin
  broad_phase.create;
  contact_list := nil;
  contact_count := 0;
  contact_filter := b2_default_filter;
  contact_listener := b2_default_listener;
  allocator := nil;
end;

destructor tb2_contact_manager.destroy;
begin
  broad_phase.destroy;
end;

procedure tb2_contact_manager.add_pair(const proxy_user_data_a, proxy_user_data_b: tb2_ptr);
  var proxy_a, proxy_b: pb2_fixture_proxy;
  var fixture_a, fixture_b, f_a, f_b: pb2_fixture;
  var index_a, index_b, i_a, i_b: tb2_int32;
  var body_a, body_b: pb2_body;
  var edge: pb2_contact_edge;
  var c: pb2_contact;
begin
  proxy_a := pb2_fixture_proxy(proxy_user_data_a);
  proxy_b := pb2_fixture_proxy(proxy_user_data_b);
  fixture_a := proxy_a^.fixture;
  fixture_b := proxy_b^.fixture;
  index_a := proxy_a^.child_index;
  index_b := proxy_b^.child_index;
  body_a := fixture_a^.get_body;
  body_b := fixture_b^.get_body;
  if body_a = body_b then exit;
  edge := body_b^.get_contact_list;
  while edge <> nil do
  begin
    if edge^.other = body_a then
    begin
      f_a := edge^.contact^.get_fixture_a;
      f_b := edge^.contact^.get_fixture_b;
      i_a := edge^.contact^.get_child_index_a;
      i_b := edge^.contact^.get_child_index_b;
      if (f_a = fixture_a) and (f_b = fixture_b) and (i_a = index_a) and (i_b = index_b) then exit;
      if (f_a = fixture_b) and (f_b = fixture_a) and (i_a = index_b) and (i_b = index_a) then exit;
    end;
    edge := edge^.next;
  end;
  if not body_b^.should_collide(body_a) then exit;
  if (contact_filter <> nil) and not contact_filter.should_collide(fixture_a, fixture_b) then exit;
  c := tb2_contact.create_contact(fixture_a, index_a, fixture_b, index_b, allocator);
  if c = nil then exit;
  fixture_a := c^.get_fixture_a;
  fixture_b := c^.get_fixture_b;
  index_a := c^.get_child_index_a;
  index_b := c^.get_child_index_b;
  body_a := fixture_a^.get_body;
  body_b := fixture_b^.get_body;
  c^._prev := nil;
  c^._next := contact_list;
  if contact_list <> nil then
  contact_list^._prev := c;
  contact_list := c;
  c^._node_a.contact := c;
  c^._node_a.other := body_b;
  c^._node_a.prev := nil;
  c^._node_a.next := body_a^._contact_list;
  if body_a^._contact_list <> nil then
  body_a^._contact_list^.prev := @c^._node_a;
  body_a^._contact_list := @c^._node_a;
  c^._node_b.contact := c;
  c^._node_b.other := body_a;
  c^._node_b.prev := nil;
  c^._node_b.next := body_b^._contact_list;
  if body_b^._contact_list <> nil then
  body_b^._contact_list^.prev := @c^._node_b;
  body_b^._contact_list := @c^._node_b;
  if not fixture_a^.is_sensor and not fixture_b^.is_sensor then
  begin
    body_a^.set_awake(true);
    body_b^.set_awake(true);
  end;
  inc(contact_count);
end;

procedure tb2_contact_manager.find_new_contacts;
begin
  broad_phase.update_pairs(@add_pair);
end;

procedure tb2_contact_manager.destroy_contact(var c: pb2_contact);
  var fixture_a, fixture_b: pb2_fixture;
  var body_a, body_b: pb2_body;
begin
  fixture_a := c^.get_fixture_a;
  fixture_b := c^.get_fixture_b;
  body_a := fixture_a^.get_body;
  body_b := fixture_b^.get_body;
  if (contact_listener <> nil) and (c^.is_touching) then
  contact_listener.end_contact(c);
  if c^._prev <> nil then
  c^._prev^._next := c^._next;
  if c^._next <> nil then
  c^._next^._prev := c^._prev;
  if c = contact_list then
  contact_list := c^._next;
  if c^._node_a.prev <> nil then
  c^._node_a.prev^.next := c^._node_a.next;
  if c^._node_a.next <> nil then
  c^._node_a.next^.prev := c^._node_a.prev;
  if @c^._node_a = body_a^._contact_list then
  body_a^._contact_list := c^._node_a.next;
  if c^._node_b.prev <> nil then
  c^._node_b.prev^.next := c^._node_b.next;
  if c^._node_b.next <> nil then
  c^._node_b.next^.prev := c^._node_b.prev;
  if @c^._node_b = body_b^._contact_list then
  body_b^._contact_list := c^._node_b.next;
  tb2_contact.destroy_contact(c, allocator);
  dec(contact_count);
end;

procedure tb2_contact_manager.collide;
  var c, c_nuke: pb2_contact;
  var fixture_a, fixture_b: pb2_fixture;
  var index_a, index_b, proxy_id_a, proxy_id_b: tb2_int32;
  var body_a, body_b: pb2_body;
  var active_a, actibe_b, overlap: boolean;
begin
  c := contact_list;
  while c <> nil do
  begin
    fixture_a := c^.get_fixture_a;
    fixture_b := c^.get_fixture_b;
    index_a := c^.get_child_index_a;
    index_b := c^.get_child_index_b;
    body_a := fixture_a^.get_body;
    body_b := fixture_b^.get_body;
    if b2_cf_filter_flag in c^._flags then
    begin
      if not body_b^.should_collide(body_a) then
      begin
	c_nuke := c;
	c := c_nuke^.get_next;
	destroy_contact(c_nuke);
	continue;
      end;
      if (contact_filter <> nil) and not contact_filter.should_collide(fixture_a, fixture_b) then
      begin
	c_nuke := c;
	c := c_nuke^.get_next;
	destroy_contact(c_nuke);
	continue;
      end;
      c^._flags -= [b2_cf_filter_flag];
    end;
    active_a := body_a^.is_awake and (body_a^.get_type <> b2_static_body);
    actibe_b := body_b^.is_awake and (body_b^.get_type <> b2_static_body);
    if not active_a and not actibe_b then
    begin
      c := c^.get_next;
      continue;
    end;
    proxy_id_a := fixture_a^._proxies^[index_a].proxy_id;
    proxy_id_b := fixture_b^._proxies^[index_b].proxy_id;
    overlap := broad_phase.test_overlap(proxy_id_a, proxy_id_b);
    if not overlap then
    begin
      c_nuke := c;
      c := c_nuke^.get_next;
      destroy_contact(c_nuke);
      continue;
    end;
    c^.update(contact_listener);
    c := c^.get_next;
  end;
end;
//tb2_contact_manager END

//tb2_island BEGIN
constructor tb2_island.create(
  const body_capacity, contact_capacity, joint_capacity: tb2_int32;
  const allocator: pb2_stack_allocator; const listener: tb2_contact_listener
);
begin
  _body_capacity := body_capacity;
  _contact_capacity := contact_capacity;
  _joint_capacity := joint_capacity;
  _body_count := 0;
  _contact_count := 0;
  _joint_count := 0;
  _allocator := allocator;
  _listener := listener;
  _bodies := ppb2_body_arr(_allocator^.alloc(_body_capacity * sizeof(pb2_body)));
  _contacts := ppb2_contact_arr(_allocator^.alloc(_contact_capacity * sizeof(pb2_contact)));
  _joints := ppb2_joint_arr(_allocator^.alloc(_joint_capacity * sizeof(pb2_joint)));
  _velocities := pb2_velocity_arr(_allocator^.alloc(_body_capacity * sizeof(tb2_velocity)));
  _positions := pb2_position_arr(_allocator^.alloc(_body_capacity * sizeof(tb2_position)));
end;

destructor tb2_island.destroy;
begin
  _allocator^.free(_positions);
  _allocator^.free(_velocities);
  _allocator^.free(_joints);
  _allocator^.free(_contacts);
  _allocator^.free(_bodies);
end;

procedure tb2_island.clear;
begin
  _body_count := 0;
  _contact_count := 0;
  _joint_count := 0;
end;

procedure tb2_island.solve(const profile: pb2_profile; const step: tb2_time_step; const gravity: tb2_vec2; const allow_sleep: boolean);
  var timer: tb2_timer;
  var h: tb2_float32;
  var i, j: tb2_int32;
  var scope_0: record
    b: pb2_body;
    c, v: tb2_vec2;
    a, w: tb2_float32;
  end;
  var solver_data: tb2_solver_data;
  var contact_solver_def: tb2_contact_solver_def;
  var contact_solver: tb2_contact_solver;
  var scope_1: record
    c, v, translation: tb2_vec2;
    a, w, rotation, ratio: tb2_float32;
  end;
  var position_solved: boolean;
  var scope_2: record
    contacts_okay, joints_okay: boolean;
  end;
  var body: pb2_body;
  var scope_3: record
    min_sleep_time: tb2_float32;
    b: pb2_body;
  end;
  const lin_tol_sqr = b2_linear_sleep_tolerance * b2_linear_sleep_tolerance;
  const ang_tol_sqr = b2_angular_sleep_tolerance * b2_angular_sleep_tolerance;
begin
  h := step.dt;
  for i := 0 to _body_count - 1 do
  with scope_0 do
  begin
    b := _bodies^[i];
    c := b^._sweep.c;
    a := b^._sweep.a;
    v := b^._linear_velocity;
    w := b^._angular_velocity;
    b^._sweep.c0 := b^._sweep.c;
    b^._sweep.a0 := b^._sweep.a;
    if b^._type = b2_dynamic_body then
    begin
      v := v + (h * (b^._gravity_scale * gravity + b^._rcp_mass * b^._force));
      w += h * b^._rcp_inertia * b^._torque;
      v := v * (1.0 / (1.0 + h * b^._linear_damping));
      w *= 1.0 / (1.0 + h * b^._angular_damping);
    end;
    _positions^[i].c := c;
    _positions^[i].a := a;
    _velocities^[i].v := v;
    _velocities^[i].w := w;
  end;
  timer.create;
  solver_data.step := step;
  solver_data.positions := _positions;
  solver_data.velocities := _velocities;
  contact_solver_def.step := step;
  contact_solver_def.contacts := _contacts;
  contact_solver_def.count := _contact_count;
  contact_solver_def.positions := _positions;
  contact_solver_def.velocities := _velocities;
  contact_solver_def.allocator := _allocator;
  contact_solver.create(contact_solver_def);
  contact_solver.initialize_velocity_constraints;
  if step.warm_starting then
  contact_solver.warm_start;
  for i := 0 to _joint_count - 1 do
  _joints^[i]^.init_velocity_constraints(solver_data);
  profile^.solve_init := timer.get_milliseconds;
  timer.reset;
  for i := 0 to step.velocity_iterations - 1 do
  begin
    for j := 0 to _joint_count - 1 do
    _joints^[j]^.solve_velocity_constraints(solver_data);
    contact_solver.solve_velocity_constraints;
  end;
  contact_solver.store_impulses;
  profile^.solve_velocity := timer.get_milliseconds;
  for i := 0 to _body_count - 1 do
  with scope_1 do
  begin
    c := _positions^[i].c;
    a := _positions^[i].a;
    v := _velocities^[i].v;
    w := _velocities^[i].w;
    translation := h * v;
    if b2_dot(translation, translation) > b2_max_translation_squared then
    begin
      ratio := b2_max_translation / translation.len;
      v := v * ratio;
    end;
    rotation := h * w;
    if rotation * rotation > b2_max_rotation_squared then
    begin
      ratio := b2_max_rotation / b2_abs(rotation);
      w *= ratio;
    end;
    c := c + (h * v);
    a += h * w;
    _positions^[i].c := c;
    _positions^[i].a := a;
    _velocities^[i].v := v;
    _velocities^[i].w := w;
  end;
  timer.reset;
  position_solved := false;
  for i := 0 to step.position_iterations - 1 do
  with scope_2 do
  begin
    contacts_okay := contact_solver.solve_position_constraints;
    joints_okay := true;
    for j := 0 to _joint_count - 1 do
    joints_okay := _joints^[j]^.solve_position_constraints(solver_data) and joints_okay;
    if contacts_okay and joints_okay then
    begin
      position_solved := true;
      break;
    end;
  end;
  for i := 0 to _body_count - 1 do
  begin
    body := _bodies^[i];
    body^._sweep.c := _positions^[i].c;
    body^._sweep.a := _positions^[i].a;
    body^._linear_velocity := _velocities^[i].v;
    body^._angular_velocity := _velocities^[i].w;
    body^.synchronize_transform;
  end;
  profile^.solve_position := timer.get_milliseconds;
  report(contact_solver.velocity_constraints);
  if allow_sleep then
  with scope_3 do
  begin
    min_sleep_time := b2_max_float;
    for i := 0 to _body_count - 1 do
    begin
      b := _bodies^[i];
      if b^.get_type = b2_static_body then continue;
      if (
         not (b2_bf_auto_sleep_flag in b^._flags)
	 or (b^._angular_velocity * b^._angular_velocity > ang_tol_sqr)
	 or (b2_dot(b^._linear_velocity, b^._linear_velocity) > lin_tol_sqr)
      ) then
      begin
	b^._sleep_time := 0.0;
	min_sleep_time := 0.0;
      end
      else
      begin
	b^._sleep_time += h;
	min_sleep_time := b2_min(min_sleep_time, b^._sleep_time);
      end;
    end;
    if (min_sleep_time >= b2_time_to_sleep) and position_solved then
    begin
      for j := 0 to _body_count - 1 do
      begin
        b := _bodies^[j];
        b^.set_awake(false);
      end;
    end;
  end;
  contact_solver.destroy;
end;

procedure tb2_island.solve_toi(const sub_step: tb2_time_step; const toi_index_a, toi_index_b: tb2_int32);
  var i: tb2_int32;
  var b: pb2_body;
  var contact_solver_def: tb2_contact_solver_def;
  var contact_solver: tb2_contact_solver;
  var h, a, w, rotation: tb2_float32;
  var c, v, translation: tb2_vec2;
begin
  for i := 0 to _body_count - 1 do
  begin
    b := _bodies^[i];
    _positions^[i].c := b^._sweep.c;
    _positions^[i].a := b^._sweep.a;
    _velocities^[i].v := b^._linear_velocity;
    _velocities^[i].w := b^._angular_velocity;
  end;
  contact_solver_def.contacts := _contacts;
  contact_solver_def.count := _contact_count;
  contact_solver_def.allocator := _allocator;
  contact_solver_def.step := sub_step;
  contact_solver_def.positions := _positions;
  contact_solver_def.velocities := _velocities;
  contact_solver.create(contact_solver_def);
  for i := 0 to sub_step.position_iterations - 1 do
  begin
    if contact_solver.solve_toi_position_constraints(toi_index_a, toi_index_b) then
    break;
  end;
  _bodies^[toi_index_a]^._sweep.c0 := _positions^[toi_index_a].c;
  _bodies^[toi_index_a]^._sweep.a0 := _positions^[toi_index_a].a;
  _bodies^[toi_index_b]^._sweep.c0 := _positions^[toi_index_b].c;
  _bodies^[toi_index_b]^._sweep.a0 := _positions^[toi_index_b].a;
  contact_solver.initialize_velocity_constraints;
  for i := 0 to sub_step.velocity_iterations - 1 do
  contact_solver.solve_velocity_constraints;
  h := sub_step.dt;
  for i := 0 to _body_count - 1 do
  begin
    c := _positions^[i].c;
    a := _positions^[i].a;
    v := _velocities^[i].v;
    w := _velocities^[i].w;
    translation := h * v;
    if b2_dot(translation, translation) > b2_max_translation_squared then
    v := v * (b2_max_translation / translation.len);
    rotation := h * w;
    if rotation * rotation > b2_max_rotation_squared then
    w *= b2_max_rotation / b2_abs(rotation);
    c := c + (h * v);
    a += h * w;
    _positions^[i].c := c;
    _positions^[i].a := a;
    _velocities^[i].v := v;
    _velocities^[i].w := w;
    b := _bodies^[i];
    b^._sweep.c := c;
    b^._sweep.a := a;
    b^._linear_velocity := v;
    b^._angular_velocity := w;
    b^.synchronize_transform;
  end;
  report(contact_solver.velocity_constraints);
  contact_solver.destroy;
end;

procedure tb2_island.add(const body: pb2_body);
begin
  body^._island_index := _body_count;
  _bodies^[_body_count] := body;
  inc(_body_count);
end;

procedure tb2_island.add(const contact: pb2_contact);
begin
  _contacts^[_contact_count] := contact;
  inc(_contact_count);
end;

procedure tb2_island.add(const joint: pb2_joint);
begin
  _joints^[_joint_count] := joint;
  inc(_joint_count);
end;

procedure tb2_island.report(const constraints: pb2_contact_velocity_constraint_arr);
  var i, j: tb2_int32;
  var c: pb2_contact;
  var vc: pb2_contact_velocity_constraint;
  var impulse: tb2_contact_impulse;
begin
  if _listener = nil then exit;
  for i := 0 to _contact_count - 1 do
  begin
    c := _contacts^[i];
    vc := @constraints^[i];
    impulse.count := vc^.point_count;
    for j := 0 to vc^.point_count - 1 do
    begin
      impulse.normal_impulses[j] := vc^.points[j].normal_impulse;
      impulse.tangent_impulses[j] := vc^.points[j].tangent_impulse;
    end;
    _listener.post_solve(c, @impulse);
  end;
end;
//tb2_island END

//tb2_joint BEGIN
function tb2_joint.create_joint(const def: tb2_joint_def; const allocator: pb2_block_allocator): pb2_joint;
begin
  case def.joint_type of
    b2_jt_distance_joint:
    begin
      result := pb2_joint(allocator^.alloc(sizeof(tb2_distance_joint)));
      pb2_distance_joint(result)^.create_distance_joint(pb2_distance_joint_def(@def)^);
    end;
    b2_jt_mouse_joint:
    begin
      result := pb2_joint(allocator^.alloc(sizeof(tb2_mouse_joint)));
      pb2_mouse_joint(result)^.create_mouse_joint(pb2_mouse_joint_def(@def)^);
    end;
    b2_jt_prismatic_joint:
    begin
      result := pb2_prismatic_joint(allocator^.alloc(sizeof(tb2_prismatic_joint)));
      pb2_prismatic_joint(result)^.create_prismatic_joint(pb2_prismatic_joint_def(@def)^);
    end;
    b2_jt_revolute_joint:
    begin
      result := pb2_joint(allocator^.alloc(sizeof(tb2_revolute_joint)));
      pb2_revolute_joint(result)^.create_revolute_joint(pb2_revolute_joint_def(@def)^);
    end;
    b2_jt_pulley_joint:
    begin
      result := pb2_joint(allocator^.alloc(sizeof(tb2_pulley_joint)));
      pb2_pulley_joint(result)^.create_pulley_joint(pb2_pulley_joint_def(@def)^);
    end;
    b2_jt_gear_joint:
    begin
      result := pb2_joint(allocator^.alloc(sizeof(tb2_gear_joint)));
      pb2_gear_joint(result)^.create_gear_joint(pb2_gear_joint_def(@def)^);
    end;
    b2_jt_wheel_joint:
    begin
      result := pb2_joint(allocator^.alloc(sizeof(tb2_wheel_joint)));
      pb2_wheel_joint(result)^.create_wheel_joint(pb2_wheel_joint_def(@def)^);
    end;
    b2_jt_weld_joint:
    begin
      result := pb2_joint(allocator^.alloc(sizeof(tb2_weld_joint)));
      pb2_weld_joint(result)^.create_weld_joint(pb2_weld_joint_def(@def)^);
    end;
    b2_jt_friction_joint:
    begin
      result := pb2_joint(allocator^.alloc(sizeof(tb2_friction_joint)));
      pb2_friction_joint(result)^.create_friction_joint(pb2_friction_joint_def(@def)^);
    end;
    b2_jt_rope_joint:
    begin
      result := pb2_joint(allocator^.alloc(sizeof(tb2_rope_joint)));
      pb2_rope_joint(result)^.create_rope_joint(pb2_rope_joint_def(@def)^);
    end;
    b2_jt_motor_joint:
    begin
      result := pb2_joint(allocator^.alloc(sizeof(tb2_motor_joint)));
      pb2_motor_joint(result)^.create_motor_joint(pb2_motor_joint_def(@def)^);
    end;
    else
    begin
      result := nil;
    end;
  end;
end;

procedure tb2_joint.destroy_joint(var joint: pb2_joint; const allocator: pb2_block_allocator);
begin
  joint^.destroy;
  case joint^._type of
    b2_jt_distance_joint: allocator^.free(joint, sizeof(tb2_distance_joint));
    b2_jt_mouse_joint: allocator^.free(joint, sizeof(tb2_mouse_joint));
    b2_jt_prismatic_joint: allocator^.free(joint, sizeof(tb2_prismatic_joint));
    b2_jt_revolute_joint: allocator^.free(joint, sizeof(tb2_revolute_joint));
    b2_jt_pulley_joint: allocator^.free(joint, sizeof(tb2_pulley_joint));
    b2_jt_gear_joint: allocator^.free(joint, sizeof(tb2_gear_joint));
    b2_jt_wheel_joint: allocator^.free(joint, sizeof(tb2_wheel_joint));
    b2_jt_weld_joint: allocator^.free(joint, sizeof(tb2_weld_joint));
    b2_jt_friction_joint: allocator^.free(joint, sizeof(tb2_friction_joint));
    b2_jt_rope_joint: allocator^.free(joint, sizeof(tb2_rope_joint));
    b2_jt_motor_joint: allocator^.free(joint, sizeof(tb2_motor_joint));
  end;
end;

constructor tb2_joint.create(const def: tb2_joint_def);
begin
  _type := def.joint_type;
  _prev := nil;
  _next := nil;
  _body_a := def.body_a;
  _body_b := def.body_b;
  _index := 0;
  _collide_connected := def.collide_connected;
  _island_flag := false;
  _user_data := def.user_data;
  _edge_a.joint := nil;
  _edge_a.other := nil;
  _edge_a.prev := nil;
  _edge_a.next := nil;
  _edge_b.joint := nil;
  _edge_b.other := nil;
  _edge_b.prev := nil;
  _edge_b.next := nil;
end;

destructor tb2_joint.destroy;
begin
end;

function tb2_joint.get_type: tb2_joint_type;
begin
  result := _type;
end;

function tb2_joint.get_body_a: pb2_body;
begin
  result := _body_a;
end;

function tb2_joint.get_body_b: pb2_body;
begin
  result := _body_b;
end;

function tb2_joint.get_next: pb2_joint;
begin
  result := _next;
end;

function tb2_joint.get_user_data: tb2_ptr;
begin
  result := _user_data;
end;

procedure tb2_joint.set_user_data(const data: tb2_ptr);
begin
  _user_data := data;
end;

function tb2_joint.is_active: boolean;
begin
  result := _body_a^.is_active and _body_b^.is_active;
end;

function tb2_joint.get_collide_connected: boolean;
begin
  result := _collide_connected;
end;

procedure tb2_joint.dump;
begin
  b2_log('dump is not supported for this joint type.');
end;

{$hints off}
procedure tb2_joint.shift_origin(const new_origin: tb2_vec2);
begin
end;
{$hints on}
//tb2_joint END

//tb2_distance_joint_def BEGIN
procedure tb2_distance_joint_def.initialize(
  const b_a, b_b: pb2_body;
  const anchor_a, anchor_b: tb2_vec2
);
begin
  body_a := b_a;
  body_b := b_b;
  local_anchor_a := body_a^.get_local_point(anchor_a);
  local_anchor_b := body_b^.get_local_point(anchor_b);
  len := (anchor_b - anchor_a).len;
end;
//tb2_distance_joint_def END

//tb2_distance_joint BEGIN
procedure tb2_distance_joint.init_velocity_constraints(var data: tb2_solver_data);
  var c_a, c_b, v_a, v_b, p: tb2_vec2;
  var a_a, w_a, a_b, w_b, l, cr_au, cr_bu, rcp_mass, c, omega, d, k, h: tb2_float32;
  var q_a, q_b: tb2_rot;
begin
  _index_a := _body_a^._island_index;
  _index_b := _body_b^._island_index;
  _local_center_a := _body_a^._sweep.local_center;
  _local_center_b := _body_b^._sweep.local_center;
  _rcp_mass_a := _body_a^._rcp_mass;
  _rcp_mass_b := _body_b^._rcp_mass;
  _rcp_inertia_a := _body_a^._rcp_inertia;
  _rcp_inertia_b := _body_b^._rcp_inertia;
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  q_a.set_value(a_a);
  q_b.set_value(a_b);
  _r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  _r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  _u := c_b + _r_b - c_a - _r_a;
  l := _u.len;
  if l > b2_linear_slop then
  _u := _u * (1.0 / l)
  else
  _u.set_value(0.0, 0.0);
  cr_au := b2_cross(_r_a, _u);
  cr_bu := b2_cross(_r_b, _u);
  rcp_mass := _rcp_mass_a + _rcp_inertia_a * cr_au * cr_au + _rcp_mass_b + _rcp_inertia_b * cr_bu * cr_bu;
  if rcp_mass <> 0.0 then
  _mass := 1.0 / rcp_Mass
  else
  _mass := 0.0;
  if _frequency_hz > 0.0 then
  begin
    c := l - _len;
    omega := 2.0 * b2_pi * _frequency_hz;
    d := 2.0 * _mass * _damping_ratio * omega;
    k := _mass * omega * omega;
    h := data.step.dt;
    _gamma := h * (d + h * k);
    if _gamma <> 0.0 then
    _gamma := 1.0 / _gamma
    else
    _gamma := 0.0;
    _bias := c * h * k * _gamma;
    rcp_Mass += _gamma;
    if rcp_mass <> 0.0 then
    _mass := 1.0 / rcp_mass
    else
    _mass := 0.0;
  end
  else
  begin
    _gamma := 0.0;
    _bias := 0.0;
  end;
  if data.step.warm_starting then
  begin
    _impulse *= data.step.dt_ratio;
    p := _impulse * _u;
    v_a := v_a - (_rcp_mass_a * p);
    w_a -= _rcp_inertia_a * b2_cross(_r_a, p);
    v_b := v_b + (_rcp_mass_b * p);
    w_b += _rcp_inertia_b * b2_cross(_r_b, p);
  end
  else
  begin
    _impulse := 0.0;
  end;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

procedure tb2_distance_joint.solve_velocity_constraints(var data: tb2_solver_data);
  var v_a, v_b, vp_a, vp_b, p: tb2_vec2;
  var w_a, w_b, c_dot, impulse: tb2_float32;
begin
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  vp_a := v_a + b2_cross(w_a, _r_a);
  vp_b := v_b + b2_cross(w_b, _r_b);
  c_dot := b2_dot(_u, vp_b - vp_a);
  impulse := -_mass * (c_dot + _bias + _gamma * _impulse);
  _impulse += impulse;
  p := impulse * _u;
  v_a := v_a - (_rcp_mass_a * p);
  w_a -= _rcp_inertia_a * b2_cross(_r_a, p);
  v_b := v_b + (_rcp_mass_b * p);
  w_b += _rcp_inertia_b * b2_cross(_r_b, p);
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

function tb2_distance_joint.solve_position_constraints(var data: tb2_solver_data): boolean;
  var c_a, c_b, r_a, r_b, u, p: tb2_vec2;
  var a_a, a_b, l, c, impulse: tb2_float32;
  var q_a, q_b: tb2_rot;
begin
  if _frequency_hz > 0.0 then
  begin
    result := true;
    exit;
  end;
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  q_a.set_value(a_a);
  q_b.set_value(a_b);
  r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  u := c_b + r_b - c_a - r_a;
  l := u.normalize;
  c := l - _len;
  c := b2_clamp(c, -b2_max_linear_correction, b2_max_linear_correction);
  impulse := -_mass * c;
  p := impulse * u;
  c_a := c_a - (_rcp_mass_a * p);
  a_a -= _rcp_inertia_a * b2_cross(r_a, p);
  c_b := c_b + (_rcp_mass_b * p);
  a_b += _rcp_inertia_b * b2_cross(r_b, p);
  data.positions^[_index_a].c := c_a;
  data.positions^[_index_a].a := a_a;
  data.positions^[_index_b].c := c_b;
  data.positions^[_index_b].a := a_b;
  result := b2_abs(c) < b2_linear_slop;
end;

constructor tb2_distance_joint.create_distance_joint(const def: tb2_distance_joint_def);
begin
  inherited create(def);
  _local_anchor_a := def.local_anchor_a;
  _local_anchor_b := def.local_anchor_b;
  _len := def.len;
  _frequency_hz := def.frequency_hz;
  _damping_ratio := def.damping_ratio;
  _impulse := 0.0;
  _gamma := 0.0;
  _bias := 0.0;
end;

function tb2_distance_joint.get_anchor_a: tb2_vec2;
begin
  result := _body_a^.get_world_point(_local_anchor_a);
end;

function tb2_distance_joint.get_anchor_b: tb2_vec2;
begin
  result := _body_b^.get_world_point(_local_anchor_b);
end;

function tb2_distance_joint.get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2;
begin
  result := (rcp_dt * _impulse) * _u;
end;

{$hints off}
function tb2_distance_joint.get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := 0.0;
end;
{$hints on}

function tb2_distance_joint.get_local_anchor_a: tb2_vec2;
begin
  result := _local_anchor_a;
end;

function tb2_distance_joint.get_local_anchor_b: tb2_vec2;
begin
  result := _local_anchor_b;
end;

procedure tb2_distance_joint.set_length(const len: tb2_float32);
begin
  _len := len;
end;

function tb2_distance_joint.get_length: tb2_float32;
begin
  result := _len;
end;

procedure tb2_distance_joint.set_frequency(const hz: tb2_float32);
begin
  _frequency_hz := hz;
end;

function tb2_distance_joint.get_frequency: tb2_float32;
begin
  result := _frequency_hz;
end;

procedure tb2_distance_joint.set_damping_datio(const ratio: tb2_float32);
begin
  _damping_ratio := ratio;
end;

function tb2_distance_joint.get_damping_ratio: tb2_float32;
begin
  result := _damping_ratio;
end;

procedure tb2_distance_joint.dump;
  var index_a, index_b: tb2_int32;
begin
  index_a := _body_a^._island_index;
  index_b := _body_b^._island_index;
  b2_log('  b2_distance_joint_def jd;');
  b2_log('  jd.body_a = bodies[' + inttostr(index_a) + '];');
  b2_log('  jd.body_b = bodies[' + inttostr(index_b) + '];');
  b2_log('  jd.collide_connected = bool(' + inttostr(byte(_collide_connected)) + ');');
  b2_log('  jd.local_anchor_a.set_value(' + floattostr(_local_anchor_a.x) + ', ' + floattostr(_local_anchor_a.y) + ');');
  b2_log('  jd.local_anchor_b.set_value(' + floattostr(_local_anchor_b.x) + ', ' + floattostr(_local_anchor_b.y) + ');');
  b2_log('  jd.length = ' + floattostr(_len) + ';');
  b2_log('  jd.frequency_hz = ' + floattostr(_frequency_hz) + ';');
  b2_log('  jd.damping_ratio = ' + floattostr(_damping_ratio) + ';');
  b2_log('  joints[' + inttostr(_index) + '] = _world->create_joint(&jd);');
end;
//tb2_distance_joint END

//tb2_wheel_joint_def BEGIN
procedure tb2_wheel_joint_def.initialize(
  const b_a, b_b: pb2_body;
  const anchor, axis: tb2_vec2
);
begin
  body_a := b_a;
  body_b := b_b;
  local_anchor_a := body_a^.get_local_point(anchor);
  local_anchor_b := body_b^.get_local_point(anchor);
  local_axis_a := body_a^.get_local_vector(axis);
end;
//tb2_wheel_joint_def END

//tb2_wheel_joint BEGIN
procedure tb2_wheel_joint.init_velocity_constraints(var data: tb2_solver_data);
  var m_a, i_a, m_b, i_b, a_a, w_a, a_b, w_b, rcp_mass, c, omega, d_1, k, h, l_a, l_b: tb2_float32;
  var c_a, v_a, c_b, v_b, r_a, r_b, d, p: tb2_vec2;
  var q_a, q_b: tb2_rot;
begin
  _index_a := _body_a^._island_index;
  _index_b := _body_b^._island_index;
  _local_center_a := _body_a^._sweep.local_center;
  _local_center_b := _body_b^._sweep.local_center;
  _rcp_mass_a := _body_a^._rcp_mass;
  _rcp_mass_b := _body_b^._rcp_mass;
  _rcp_inertia_a := _body_a^._rcp_inertia;
  _rcp_inertia_b := _body_b^._rcp_inertia;
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  q_a.set_value(a_a);
  q_b.set_value(a_b);
  r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  d := c_b + r_b - c_a - r_a;
  _ay := b2_mul(q_a, _local_y_axis_a);
  _s_a_y := b2_cross(d + r_a, _ay);
  _s_b_y := b2_cross(r_b, _ay);
  _mass := m_a + m_b + i_a * _s_a_y * _s_a_y + i_b * _s_b_y * _s_b_y;
  if _mass > 0.0 then
  _mass := 1.0 / _mass;
  _spring_mass := 0.0;
  _bias := 0.0;
  _gamma := 0.0;
  if _frequency_hz > 0.0 then
  begin
    _ax := b2_mul(q_a, _local_x_axis_a);
    _s_a_x := b2_cross(d + r_a, _ax);
    _s_b_x := b2_cross(r_b, _ax);
    rcp_mass := m_a + m_b + i_a * _s_a_x * _s_a_x + i_b * _s_b_x * _s_b_x;
    if rcp_mass > 0.0 then
    begin
      _spring_mass := 1.0 / rcp_mass;
      c := b2_dot(d, _ax);
      omega := 2.0 * b2_pi * _frequency_hz;
      d_1 := 2.0 * _spring_mass * _damping_ratio * omega;
      k := _spring_mass * omega * omega;
      h := data.step.dt;
      _gamma := h * (d_1 + h * k);
      if _gamma > 0.0 then
      _gamma := 1.0 / _gamma;
      _bias := c * h * k * _gamma;
      _spring_mass := rcp_mass + _gamma;
      if _spring_mass > 0.0 then
      _spring_mass := 1.0 / _spring_mass;
    end;
  end
  else
  begin
    _spring_impulse := 0.0;
  end;
  if _enable_motor then
  begin
    _motor_mass := i_a + i_b;
    if _motor_mass > 0.0 then
    _motor_mass := 1.0 / _motor_mass;
  end
  else
  begin
    _motor_mass := 0.0;
    _motor_impulse := 0.0;
  end;
  if data.step.warm_starting then
  begin
    _impulse *= data.step.dt_ratio;
    _spring_impulse *= data.step.dt_ratio;
    _motor_impulse *= data.step.dt_ratio;
    p := _impulse * _ay + _spring_impulse * _ax;
    l_a := _impulse * _s_a_y + _spring_impulse * _s_a_x + _motor_impulse;
    l_b := _impulse * _s_b_y + _spring_impulse * _s_b_x + _motor_impulse;
    v_a := v_a - (_rcp_mass_a * p);
    w_a -= _rcp_inertia_a * l_a;
    v_b := v_b + (_rcp_mass_b * p);
    w_b += _rcp_inertia_b * l_b;
  end
  else
  begin
    _impulse := 0.0;
    _spring_impulse := 0.0;
    _motor_impulse := 0.0;
  end;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

procedure tb2_wheel_joint.solve_velocity_constraints(var data: tb2_solver_data);
  var m_a, m_b, i_a, i_b, w_a, w_b, c_dot, impulse, l_a, l_b, old_impulse, max_impulse: tb2_float32;
  var v_a, v_b, p: tb2_vec2;
begin
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  c_dot := b2_dot(_ax, v_b - v_a) + _s_b_x * w_b - _s_a_x * w_a;
  impulse := -_spring_mass * (c_dot + _bias + _gamma * _spring_impulse);
  _spring_impulse += impulse;
  p := impulse * _ax;
  l_a := impulse * _s_a_x;
  l_b := impulse * _s_b_x;
  v_a := v_a - (m_a * p);
  w_a -= i_a * l_a;
  v_b := v_b + (m_b * p);
  w_b += i_b * l_b;
  c_dot := w_b - w_a - _motor_speed;
  impulse := -_motor_mass * c_dot;
  old_impulse := _motor_impulse;
  max_impulse := data.step.dt * _max_motor_torque;
  _motor_impulse := b2_clamp(_motor_impulse + impulse, -max_impulse, max_impulse);
  impulse := _motor_impulse - old_impulse;
  w_a -= i_a * impulse;
  w_b += i_b * impulse;
  c_dot := b2_dot(_ay, v_b - v_a) + _s_b_y * w_b - _s_a_y * w_a;
  impulse := -_mass * c_dot;
  _impulse += impulse;
  p := impulse * _ay;
  l_a := impulse * _s_a_y;
  l_b := impulse * _s_b_y;
  v_a := v_a - (m_a * p);
  w_a -= i_a * l_a;
  v_b := v_b + (m_b * p);
  w_b += i_b * l_b;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

function tb2_wheel_joint.solve_position_constraints(var data: tb2_solver_data): boolean;
  var c_a, c_b, r_a, r_b, d, ay, p: tb2_vec2;
  var a_a, a_b, s_a_y, s_b_y, c, k, impulse, l_a, l_b: tb2_float32;
  var q_a, q_b: tb2_rot;
begin
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  q_a.set_value(a_a); q_b.set_value(a_b);
  r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  d := (c_b - c_a) + r_b - r_a;
  ay := b2_mul(q_a, _local_y_axis_a);
  s_a_y := b2_cross(d + r_a, ay);
  s_b_y := b2_cross(r_b, ay);
  c := b2_dot(d, ay);
  k := _rcp_mass_a + _rcp_mass_b + _rcp_inertia_a * _s_a_y * _s_a_y + _rcp_inertia_b * _s_b_y * _s_b_y;
  if k <> 0.0 then
  impulse := -(c / k)
  else
  impulse := 0.0;
  p := impulse * ay;
  l_a := impulse * s_a_y;
  l_b := impulse * s_b_y;
  c_a := c_a - (_rcp_mass_a * p);
  a_a -= _rcp_inertia_a * l_a;
  c_b := c_b + (_rcp_mass_b * p);
  a_b += _rcp_inertia_b * l_b;
  data.positions^[_index_a].c := c_a;
  data.positions^[_index_a].a := a_a;
  data.positions^[_index_b].c := c_b;
  data.positions^[_index_b].a := a_b;
  result := b2_abs(c) <= b2_linear_slop;
end;

constructor tb2_wheel_joint.create_wheel_joint(const def: tb2_wheel_joint_def);
begin
  inherited create(def);
  _local_anchor_a := def.local_anchor_a;
  _local_anchor_b := def.local_anchor_b;
  _local_x_axis_a := def.local_axis_a;
  _local_y_axis_a := b2_cross(1.0, _local_x_axis_a);
  _mass := 0.0;
  _impulse := 0.0;
  _motor_mass := 0.0;
  _motor_impulse := 0.0;
  _spring_mass := 0.0;
  _spring_impulse := 0.0;
  _max_motor_torque := def.max_motor_torque;
  _motor_speed := def.motor_speed;
  _enable_motor := def.enable_motor;
  _frequency_hz := def.frequency_hz;
  _damping_ratio := def.damping_ratio;
  _bias := 0.0;
  _gamma := 0.0;
  _ax.set_zero;
  _ay.set_zero;
end;

function tb2_wheel_joint.get_anchor_a: tb2_vec2;
begin
  result := _body_a^.get_world_point(_local_anchor_a);
end;

function tb2_wheel_joint.get_anchor_b: tb2_vec2;
begin
  result := _body_b^.get_world_point(_local_anchor_b);
end;

function tb2_wheel_joint.get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2;
begin
  result := rcp_dt * (_impulse * _ay + _spring_impulse * _ax);
end;

function tb2_wheel_joint.get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := rcp_dt * _motor_impulse;
end;

function tb2_wheel_joint.get_local_anchor_a: tb2_vec2;
begin
  result := _local_anchor_a;
end;

function tb2_wheel_joint.get_local_anchor_b: tb2_vec2; { return m_localAnchorB; }
begin
  result := _local_anchor_b;
end;

function tb2_wheel_joint.get_local_axis_a: tb2_vec2; { return m_localXAxisA; }
begin
  result := _local_x_axis_a;
end;

function tb2_wheel_joint.get_joint_translation: tb2_float32;
  var p_a, p_b, d, axis: tb2_vec2;
begin
  p_a := _body_a^.get_world_point(_local_anchor_a);
  p_b := _body_b^.get_world_point(_local_anchor_b);
  d := p_b - p_a;
  axis := _body_a^.get_world_vector(_local_x_axis_a);
  result := b2_dot(d, axis);
end;

function tb2_wheel_joint.get_joint_speed: tb2_float32;
begin
  result := _body_b^._angular_velocity - _body_a^._angular_velocity;
end;

function tb2_wheel_joint.is_motor_enabled: boolean;
begin
  result := _enable_motor;
end;

procedure tb2_wheel_joint.enable_motor(const flag: boolean);
begin
  _body_a^.set_awake(true);
  _body_b^.set_awake(true);
  _enable_motor := flag;
end;

procedure tb2_wheel_joint.set_motor_speed(const speed: tb2_float32);
begin
  _body_a^.set_awake(true);
  _body_b^.set_awake(true);
  _motor_speed := speed;
end;

function tb2_wheel_joint.get_motor_speed: tb2_float32;
begin
  result := _motor_speed;
end;

procedure tb2_wheel_joint.set_max_motor_torque(const torque: tb2_float32);
begin
  _body_a^.set_awake(true);
  _body_b^.set_awake(true);
  _max_motor_torque := torque;
end;

function tb2_wheel_joint.get_max_motor_torque: tb2_float32;
begin
  result := _max_motor_torque;
end;

function tb2_wheel_joint.get_motor_torque(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := rcp_dt * _motor_impulse;
end;

procedure tb2_wheel_joint.set_spring_frequency_hz(const hz: tb2_float32);
begin
  _frequency_hz := hz;
end;

function tb2_wheel_joint.get_spring_frequency_hz: tb2_float32;
begin
  result := _frequency_hz;
end;

procedure tb2_wheel_joint.set_spring_damping_ratio(const ratio: tb2_float32);
begin
  _damping_ratio := ratio;
end;

function tb2_wheel_joint.get_spring_damping_ratio: tb2_float32;
begin
  result := _damping_ratio;
end;

procedure tb2_wheel_joint.dump;
  var index_a, index_b: tb2_int32;
begin
  index_a := _body_a^._island_index;
  index_b := _body_b^._island_index;
  b2_log('  b2_wheel_joint_def jd;');
  b2_log('  jd.body_a = bodies[' + inttostr(index_a) + '];');
  b2_log('  jd.body_b = bodies[' + inttostr(index_b) + '];');
  b2_log('  jd.collide_connected = bool(' + inttostr(byte(_collide_connected)) + ');');
  b2_log('  jd.local_anchor_a.set(' + floattostr(_local_anchor_a.x) + ', ' + floattostr(_local_anchor_a.y) + ');');
  b2_log('  jd.local_anchor_b.set(' + floattostr(_local_anchor_b.x) + ', ' + floattostr(_local_anchor_b.y) + ');');
  b2_log('  jd.local_axis_a.set(' + floattostr(_local_x_axis_a.x) + ', ' + floattostr(_local_x_axis_a.y) + ');');
  b2_log('  jd.enable_motor = bool(' + inttostr(byte(_enable_motor)) + ');');
  b2_log('  jd.motor_speed = ' + floattostr(_motor_speed) + ';');
  b2_log('  jd.max_motor_torque = ' + floattostr(_max_motor_torque) + ';');
  b2_log('  jd.frequency_hz = ' + floattostr(_frequency_hz) + ';');
  b2_log('  jd.damping_ratio = ' + floattostr(_damping_ratio) + ';');
  b2_log('  joints[' + inttostr(_index) + '] = _world->create_joint(&jd);');
end;
//tb2_wheel_joint END

//tb2_mouse_joint BEGIN
procedure tb2_mouse_joint.init_velocity_constraints(var data: tb2_solver_data);
  var c_b, v_b: tb2_vec2;
  var a_b, w_b, mass, omega, d, k, h: tb2_float32;
  var q_b: tb2_rot;
  var k_1: tb2_mat22;
begin
  _index_b := _body_b^._island_index;
  _local_center_b := _body_b^._sweep.local_center;
  _rcp_mass_b := _body_b^._rcp_mass;
  _rcp_inertia_b := _body_b^._rcp_inertia;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  q_b.set_value(a_b);
  mass := _body_b^.get_mass;
  omega := 2.0 * b2_pi * _frequency_hz;
  d := 2.0 * mass * _damping_ratio * omega;
  k := mass * (omega * omega);
  h := data.step.dt;
  _gamma := h * (d + h * k);
  if _gamma <> 0.0 then
  _gamma := 1.0 / _gamma;
  _beta := h * k * _gamma;
  _r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  k_1.ex.x := _rcp_mass_b + _rcp_inertia_b * _r_b.y * _r_b.y + _gamma;
  k_1.ex.y := -_rcp_inertia_b * _r_b.x * _r_b.y;
  k_1.ey.x := k_1.ex.y;
  k_1.ey.y := _rcp_mass_b + _rcp_inertia_b * _r_b.x * _r_b.x + _gamma;
  _mass := k_1.get_inverse;
  _c := c_b + _r_b - _target_a;
  _c := _c * _beta;
  w_b *= 0.98;
  if data.step.warm_starting then
  begin
    _impulse := _impulse * data.step.dt_ratio;
    v_b := v_b + (_rcp_mass_b * _impulse);
    w_b += _rcp_inertia_b * b2_cross(_r_b, _impulse);
  end
  else
  begin
    _impulse.set_zero;
  end;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

procedure tb2_mouse_joint.solve_velocity_constraints(var data: tb2_solver_data);
  var v_b, c_dot, impulse, old_impulse: tb2_vec2;
  var w_b, max_impulse: tb2_float32;
begin
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  c_dot := v_b + b2_cross(w_b, _r_b);
  impulse := b2_mul(_mass, -(c_dot + _c + _gamma * _impulse));
  old_impulse := _impulse;
  _impulse := _impulse + impulse;
  max_impulse := data.step.dt * _max_force;
  if _impulse.len_sq > max_impulse * max_impulse then
  _impulse := _impulse * (max_impulse / _impulse.len);
  impulse := _impulse - old_impulse;
  v_b := v_b + (_rcp_mass_b * impulse);
  w_b += _rcp_inertia_b * b2_cross(_r_b, impulse);
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

{$hints off}
function tb2_mouse_joint.solve_position_constraints(var data: tb2_solver_data): boolean;
begin
  result := true;
end;
{$hints on}

constructor tb2_mouse_joint.create_mouse_joint(const def: tb2_mouse_joint_def);
begin
  inherited create(def);
  _target_a := def.target;
  _local_anchor_b := b2_mul_t(_body_b^.get_transform, _target_a);
  _max_force := def.max_force;
  _impulse.set_zero;
  _frequency_hz := def.frequency_hz;
  _damping_ratio := def.damping_ratio;
  _beta := 0.0;
  _gamma := 0.0;
end;

function tb2_mouse_joint.get_anchor_a: tb2_vec2;
begin
  result := _target_a;
end;

function tb2_mouse_joint.get_anchor_b: tb2_vec2;
begin
  result := _body_b^.get_world_point(_local_anchor_b);
end;

function tb2_mouse_joint.get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2;
begin
  result := rcp_dt * _impulse;
end;

function tb2_mouse_joint.get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := rcp_dt * 0.0;
end;

procedure tb2_mouse_joint.set_target(const target: tb2_vec2);
begin
  if not _body_b^.is_awake then
  _body_b^.set_awake(true);
  _target_a := target;
end;

function tb2_mouse_joint.get_target: tb2_vec2;
begin
  result := _target_a;
end;

procedure tb2_mouse_joint.set_max_force(const force: tb2_float32);
begin
  _max_force := force;
end;

function tb2_mouse_joint.get_max_force: tb2_float32;
begin
  result := _max_force;
end;

procedure tb2_mouse_joint.set_frequency(const hz: tb2_float32);
begin
  _frequency_hz := hz;
end;

function tb2_mouse_joint.get_frequency: tb2_float32;
begin
  result := _frequency_hz;
end;

procedure tb2_mouse_joint.set_damping_ratio(const ratio: tb2_float32);
begin
  _damping_ratio := ratio;
end;

function tb2_mouse_joint.get_damping_ratio: tb2_float32;
begin
  result := _damping_ratio;
end;

procedure tb2_mouse_joint.dump;
begin
  b2_log('Mouse joint dumping is not supported.');
end;

procedure tb2_mouse_joint.shift_origin(const new_origin: tb2_vec2);
begin
  _target_a := _target_a - new_origin;
end;
//tb2_mouse_joint END

//tb2_revolute_joint_def BEGIN
procedure tb2_revolute_joint_def.initialize(const b_a, b_b: pb2_body; const anchor: tb2_vec2);
begin
  body_a := b_a;
  body_b := b_b;
  local_anchor_a := body_a^.get_local_point(anchor);
  local_anchor_b := body_b^.get_local_point(anchor);
  reference_angle := body_b^.get_angle - body_a^.get_angle;
end;
//tb2_revolute_joint_def END

//tb2_revolute_joint BEGIN
procedure tb2_revolute_joint.init_velocity_constraints(var data: tb2_solver_data);
  var a_a, w_a, a_b, w_b, m_a, m_b, i_a, i_b, joint_angle: tb2_float32;
  var v_a, v_b, p: tb2_vec2;
  var q_a, q_b: tb2_rot;
  var fixed_rotation: boolean;
begin
  _index_a := _body_a^._island_index;
  _index_b := _body_b^._island_index;
  _local_center_a := _body_a^._sweep.local_center;
  _local_center_b := _body_b^._sweep.local_center;
  _rcp_mass_a := _body_a^._rcp_mass;
  _rcp_mass_b := _body_b^._rcp_mass;
  _rcp_inertia_a := _body_a^._rcp_inertia;
  _rcp_inertia_b := _body_b^._rcp_inertia;
  a_a := data.positions^[_index_a].a;
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  a_b := data.positions^[_index_b].a;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  q_a.set_value(a_a); q_b.set_value(a_b);
  _r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  _r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  fixed_rotation := i_a + i_b = 0.0;
  _mass.ex.x := m_a + m_b + _r_a.y * _r_a.y * i_a + _r_b.y * _r_b.y * i_b;
  _mass.ey.x := -_r_a.y * _r_a.x * i_a - _r_b.y * _r_b.x * i_b;
  _mass.ez.x := -_r_a.y * i_a - _r_b.y * i_b;
  _mass.ex.y := _mass.ey.x;
  _mass.ey.y := m_a + m_b + _r_a.x * _r_a.x * i_a + _r_b.x * _r_b.x * i_b;
  _mass.ez.y := _r_a.x * i_a + _r_b.x * i_b;
  _mass.ex.z := _mass.ez.x;
  _mass.ey.z := _mass.ez.y;
  _mass.ez.z := i_a + i_b;
  _motor_mass := i_a + i_b;
  if _motor_mass > 0.0 then
  _motor_mass := 1.0 / _motor_mass;
  if (not _enable_motor) or (fixed_rotation) then
  _motor_impulse := 0.0;
  if _enable_limit and not fixed_rotation then
  begin
    joint_angle := a_b - a_a - _reference_angle;
    if b2_abs(_upper_angle - _lower_angle) < 2.0 * b2_angular_slop then
    _limit_state := b2_ls_equal_limits
    else if joint_angle <= _lower_angle then
    begin
      if _limit_state <> b2_ls_at_lower_limit then
      _impulse.z := 0.0;
      _limit_state := b2_ls_at_lower_limit;
    end
    else if joint_angle >= _upper_angle then
    begin
      if _limit_state <> b2_ls_at_upper_limit then
      _impulse.z := 0.0;
      _limit_state := b2_ls_at_upper_limit;
    end
    else
    begin
      _limit_state := b2_ls_inactive_limit;
      _impulse.z := 0.0;
    end;
  end
  else
  begin
    _limit_state := b2_ls_inactive_limit;
  end;
  if data.step.warm_starting then
  begin
    _impulse := _impulse * data.step.dt_ratio;
    _motor_impulse *= data.step.dt_ratio;
    p.set_value(_impulse.x, _impulse.y);
    v_a := v_a - (m_a * p);
    w_a -= i_a * (b2_cross(_r_a, p) + _motor_impulse + _impulse.z);
    v_b := v_b + (m_b * p);
    w_b += i_b * (b2_cross(_r_b, p) + _motor_impulse + _impulse.z);
  end
  else
  begin
    _impulse.set_zero;
    _motor_impulse := 0.0;
  end;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

procedure tb2_revolute_joint.solve_velocity_constraints(var data: tb2_solver_data);
  var v_a, v_b, c_dot_1, rhs, reduced, p, impulse_2: tb2_vec2;
  var w_a, w_b, m_a, i_a, m_b, i_b, c_dot, impulse, old_impulse, max_impulse, new_impulse: tb2_float32;
  var fixed_rotation: boolean;
  var c_dot_2, impulse_1: tb2_vec3;
begin
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  fixed_rotation := i_a + i_b = 0.0;
  if _enable_motor and (_limit_state <> b2_ls_equal_limits) and not fixed_rotation then
  begin
    c_dot := w_b - w_a - _motor_speed;
    impulse := -_motor_mass * c_dot;
    old_impulse := _motor_impulse;
    max_impulse := data.step.dt * _max_motor_torque;
    _motor_impulse := b2_clamp(_motor_impulse + impulse, -max_impulse, max_impulse);
    impulse := _motor_impulse - old_impulse;
    w_a -= i_a * impulse;
    w_b += i_b * impulse;
  end;
  if _enable_limit and (_limit_state <> b2_ls_inactive_limit) and not fixed_rotation then
  begin
    c_dot_1 := v_b + b2_cross(w_b, _r_b) - v_a - b2_cross(w_a, _r_a);
    c_dot := w_b - w_a;
    c_dot_2.set_value(c_dot_1.x, c_dot_1.y, c_dot);
    impulse_1 := -_mass.solve33(c_dot_2);
    if _limit_state = b2_ls_equal_limits then
    _impulse := _impulse + impulse_1
    else if _limit_state = b2_ls_at_lower_limit then
    begin
      new_impulse := _impulse.z + impulse_1.z;
      if new_impulse < 0.0 then
      begin
	rhs := -c_dot_1 + _impulse.z * b2_vec2(_mass.ez.x, _mass.ez.y);
	reduced := _mass.solve22(rhs);
	impulse_1.x := reduced.x;
	impulse_1.y := reduced.y;
	impulse_1.z := -_impulse.z;
	_impulse.x += reduced.x;
	_impulse.y += reduced.y;
	_impulse.z := 0.0;
      end
      else
      _impulse := _impulse + impulse_1;
    end
    else if _limit_state = b2_ls_at_upper_limit then
    begin
      new_impulse := _impulse.z + impulse_1.z;
      if new_impulse > 0.0 then
      begin
	rhs := -c_dot_1 + _impulse.z * b2_vec2(_mass.ez.x, _mass.ez.y);
	reduced := _mass.solve22(rhs);
	impulse_1.x := reduced.x;
	impulse_1.y := reduced.y;
	impulse_1.z := -_impulse.z;
	_impulse.x += reduced.x;
	_impulse.y += reduced.y;
	_impulse.z := 0.0;
      end
      else
      _impulse := _impulse + impulse_1;
    end;
    p.set_value(impulse_1.x, impulse_1.y);
    v_a := v_a - (m_a * p);
    w_a -= i_a * (b2_cross(_r_a, p) + impulse_1.z);
    v_b := v_b + (m_b * p);
    w_b += i_b * (b2_cross(_r_b, p) + impulse_1.z);
  end
  else
  begin
    c_dot_1 := v_b + b2_cross(w_b, _r_b) - v_a - b2_cross(w_a, _r_a);
    impulse_2 := _mass.solve22(-c_dot_1);
    _impulse.x += impulse_2.x;
    _impulse.y += impulse_2.y;
    v_a := v_a - (m_a * impulse_2);
    w_a -= i_a * b2_cross(_r_a, impulse_2);
    v_b := v_b + (m_b * impulse_2);
    w_b += i_b * b2_cross(_r_b, impulse_2);
  end;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

function tb2_revolute_joint.solve_position_constraints(var data: tb2_solver_data): boolean;
  var c_a, c_b, r_a, r_b, c_1, impulse: tb2_vec2;
  var a_a, a_b, angular_error, position_error, angle, limit_impulse, c, m_a, i_a, m_b, i_b: tb2_float32;
  var q_a, q_b: tb2_rot;
  var fixed_rotation: boolean;
  var k: tb2_mat22;
begin
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  angular_error := 0.0;
  position_error := 0.0;
  fixed_rotation := _rcp_inertia_a + _rcp_inertia_b = 0.0;
  if _enable_limit and (_limit_state <> b2_ls_inactive_limit) and not fixed_rotation then
  begin
    angle := a_b - a_a - _reference_angle;
    limit_impulse := 0.0;
    if _limit_state = b2_ls_equal_limits then
    begin
      c := b2_clamp(angle - _lower_angle, -b2_max_angular_correction, b2_max_angular_correction);
      limit_impulse := -_motor_mass * c;
      angular_error := b2_abs(c);
    end
    else if _limit_state = b2_ls_at_lower_limit then
    begin
      c := angle - _lower_angle;
      angular_error := -c;
      c := b2_clamp(c + b2_angular_slop, -b2_max_angular_correction, 0.0);
      limit_impulse := -_motor_mass * c;
    end
    else if _limit_state = b2_ls_at_upper_limit then
    begin
      c := angle - _upper_angle;
      angular_error := c;
      c := b2_clamp(c - b2_angular_slop, 0.0, b2_max_angular_correction);
      limit_impulse := -_motor_mass * c;
    end;
    a_a -= _rcp_inertia_a * limit_impulse;
    a_b += _rcp_inertia_b * limit_impulse;
  end;
  q_a.set_value(a_a);
  q_b.set_value(a_b);
  r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  c_1 := (c_b + r_b) - (c_a + r_a);
  position_error := c_1.len;
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  k.ex.x := m_a + m_b + i_a * r_a.y * r_a.y + i_b * r_b.y * r_b.y;
  k.ex.y := -i_a * r_a.x * r_a.y - i_b * r_b.x * r_b.y;
  k.ey.x := k.ex.y;
  k.ey.y := m_a + m_b + i_a * r_a.x * r_a.x + i_b * r_b.x * r_b.x;
  impulse := -k.solve(c_1);
  c_a := c_a - (m_a * impulse);
  a_a -= i_a * b2_cross(r_a, impulse);
  c_b := c_b + (m_b * impulse);
  a_b += i_b * b2_cross(r_b, impulse);
  data.positions^[_index_a].c := c_a;
  data.positions^[_index_a].a := a_a;
  data.positions^[_index_b].c := c_b;
  data.positions^[_index_b].a := a_b;
  result := (position_error <= b2_linear_slop) and (angular_error <= b2_angular_slop);
end;

constructor tb2_revolute_joint.create_revolute_joint(const def: tb2_revolute_joint_def);
begin
  inherited create(def);
  _local_anchor_a := def.local_anchor_a;
  _local_anchor_b := def.local_anchor_b;
  _reference_angle := def.reference_angle;
  _impulse.set_zero;
  _motor_impulse := 0.0;
  _lower_angle := def.lower_angle;
  _upper_angle := def.upper_angle;
  _max_motor_torque := def.max_motor_torque;
  _motor_speed := def.motor_speed;
  _enable_limit := def.enable_limit;
  _enable_motor := def.enable_motor;
  _limit_state := b2_ls_inactive_limit;
end;

function tb2_revolute_joint.get_anchor_a: tb2_vec2;
begin
  result := _body_a^.get_world_point(_local_anchor_a);
end;

function tb2_revolute_joint.get_anchor_b: tb2_vec2;
begin
  result := _body_b^.get_world_point(_local_anchor_b);
end;

function tb2_revolute_joint.get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2;
begin
  result := rcp_dt * b2_vec2(_impulse.x, _impulse.y);
end;

function tb2_revolute_joint.get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := rcp_dt * _impulse.z;
end;

function tb2_revolute_joint.get_local_anchor_a: tb2_vec2;
begin
  result := _local_anchor_a;
end;

function tb2_revolute_joint.get_local_anchor_b: tb2_vec2;
begin
  result := _local_anchor_b;
end;

function tb2_revolute_joint.get_reference_angle: tb2_float32;
begin
  result := _reference_angle;
end;

function tb2_revolute_joint.get_joint_angle: tb2_float32;
begin
  result := _body_b^._sweep.a - _body_a^._sweep.a - _reference_angle;
end;

function tb2_revolute_joint.get_joint_speed: tb2_float32;
begin
  result := _body_b^._angular_velocity - _body_a^._angular_velocity;
end;

function tb2_revolute_joint.is_limit_enabled: boolean;
begin
  result := _enable_limit;
end;

procedure tb2_revolute_joint.enable_limit(const flag: boolean);
begin
  if flag <> _enable_limit then
  begin
    _body_a^.set_awake(true);
    _body_b^.set_awake(true);
    _enable_limit := flag;
    _impulse.z := 0.0;
  end;
end;

function tb2_revolute_joint.get_lower_limit: tb2_float32;
begin
  result := _lower_angle;
end;

function tb2_revolute_joint.get_upper_limit: tb2_float32;
begin
  result := _upper_angle;
end;

procedure tb2_revolute_joint.set_limits(const lower, upper: tb2_float32);
begin
  if (lower <> _lower_angle) or (upper <> _upper_angle) then
  begin
    _body_a^.set_awake(true);
    _body_b^.set_awake(true);
    _impulse.z := 0.0;
    _lower_angle := lower;
    _upper_angle := upper;
  end;
end;

function tb2_revolute_joint.is_motor_enabled: boolean;
begin
  result := _enable_motor;
end;

procedure tb2_revolute_joint.enable_motor(const flag: boolean);
begin
  _body_a^.set_awake(true);
  _body_b^.set_awake(true);
  _enable_motor := flag;
end;

procedure tb2_revolute_joint.set_motor_speed(const speed: tb2_float32);
begin
  _body_a^.set_awake(true);
  _body_b^.set_awake(true);
  _motor_speed := speed;
end;

function tb2_revolute_joint.get_motor_speed: tb2_float32;
begin
  result := _motor_speed;
end;

procedure tb2_revolute_joint.set_max_motor_torque(const torque: tb2_float32);
begin
  _body_a^.set_awake(true);
  _body_b^.set_awake(true);
  _max_motor_torque := torque;
end;

function tb2_revolute_joint.get_max_motor_torque: tb2_float32;
begin
  result := _max_motor_torque;
end;

function tb2_revolute_joint.get_motor_torque(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := rcp_dt * _motor_impulse;
end;

procedure tb2_revolute_joint.dump;
begin
  //int32 indexA = m_bodyA->m_islandIndex;
  //int32 indexB = m_bodyB->m_islandIndex;
  //
  //b2Log("  b2RevoluteJointDef jd;\n");
  //b2Log("  jd.bodyA = bodies[%d];\n", indexA);
  //b2Log("  jd.bodyB = bodies[%d];\n", indexB);
  //b2Log("  jd.collideConnected = bool(%d);\n", m_collideConnected);
  //b2Log("  jd.localAnchorA.Set(%.15lef, %.15lef);\n", m_localAnchorA.x, m_localAnchorA.y);
  //b2Log("  jd.localAnchorB.Set(%.15lef, %.15lef);\n", m_localAnchorB.x, m_localAnchorB.y);
  //b2Log("  jd.referenceAngle = %.15lef;\n", m_referenceAngle);
  //b2Log("  jd.enableLimit = bool(%d);\n", m_enableLimit);
  //b2Log("  jd.lowerAngle = %.15lef;\n", m_lowerAngle);
  //b2Log("  jd.upperAngle = %.15lef;\n", m_upperAngle);
  //b2Log("  jd.enableMotor = bool(%d);\n", m_enableMotor);
  //b2Log("  jd.motorSpeed = %.15lef;\n", m_motorSpeed);
  //b2Log("  jd.maxMotorTorque = %.15lef;\n", m_maxMotorTorque);
  //b2Log("  joints[%d] = m_world->CreateJoint(&jd);\n", m_index);
end;
//tb2_revolute_joint END

//tb2_prismatic_joint_def BEGIN
procedure tb2_prismatic_joint_def.initialize(const b_a, b_b: pb2_body; const anchor, axis: tb2_vec2);
begin
  body_a := b_a;
  body_b := b_b;
  local_anchor_a := body_a^.get_local_point(anchor);
  local_anchor_b := body_b^.get_local_point(anchor);
  local_axis_a := body_a^.get_local_vector(axis);
  reference_angle := body_b^.get_angle - body_a^.get_angle;
end;
//tb2_prismatic_joint_def END

//tb2_prismatic_joint BEGIN
procedure tb2_prismatic_joint.init_velocity_constraints(var data: tb2_solver_data);
  var c_a, v_a, c_b, v_b, r_a, r_b, d, p: tb2_vec2;
  var a_a, w_a, a_b, w_b, m_a, i_a, m_b, i_b, k11, k12, k13, k22, k23, k33, joint_translation, l_a, l_b: tb2_float32;
  var q_a, q_b: tb2_rot;
begin
  _index_a := _body_a^._island_index;
  _index_b := _body_b^._island_index;
  _local_center_a := _body_a^._sweep.local_center;
  _local_center_b := _body_b^._sweep.local_center;
  _rcp_mass_a := _body_a^._rcp_mass;
  _rcp_mass_b := _body_b^._rcp_mass;
  _rcp_inertia_a := _body_a^._rcp_inertia;
  _rcp_inertia_b := _body_b^._rcp_inertia;
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  q_a.set_value(a_a); q_b.set_value(a_b);
  r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  d := (c_b - c_a) + r_b - r_a;
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  _axis := b2_mul(q_a, _local_x_axis_a);
  _a1 := b2_cross(d + r_a, _axis);
  _a2 := b2_cross(r_b, _axis);
  _motor_mass := m_a + m_b + i_a * _a1 * _a1 + i_b * _a2 * _a2;
  if _motor_mass > 0.0 then
  _motor_mass := 1.0 / _motor_mass;
  _perp := b2_mul(q_a, _local_y_axis_a);
  _s1 := b2_cross(d + r_a, _perp);
  _s2 := b2_cross(r_b, _perp);
  k11 := m_a + m_b + i_a * _s1 * _s1 + i_b * _s2 * _s2;
  k12 := i_a * _s1 + i_b * _s2;
  k13 := i_a * _s1 * _a1 + i_b * _s2 * _a2;
  k22 := i_a + i_b;
  if k22 = 0.0 then
  k22 := 1.0;
  k23 := i_a * _a1 + i_b * _a2;
  k33 := m_a + m_b + i_a * _a1 * _a1 + i_b * _a2 * _a2;
  _k.ex.set_value(k11, k12, k13);
  _k.ey.set_value(k12, k22, k23);
  _k.ez.set_value(k13, k23, k33);
  if _enable_limit then
  begin
    joint_translation := b2_dot(_axis, d);
    if b2_abs(_upper_translation - _lower_translation) < 2.0 * b2_linear_slop then
    _limit_state := b2_ls_equal_limits
    else if joint_translation <= _lower_translation then
    begin
      if _limit_state <> b2_ls_at_lower_limit then
      begin
	_limit_state := b2_ls_at_lower_limit;
	_impulse.z := 0.0;
      end;
    end
    else if joint_translation >= _upper_translation then
    begin
      if _limit_state <> b2_ls_at_upper_limit then
      begin
	_limit_state := b2_ls_at_upper_limit;
	_impulse.z := 0.0;
      end;
    end
    else
    begin
      _limit_state := b2_ls_inactive_limit;
      _impulse.z := 0.0;
    end;
  end
  else
  begin
    _limit_state := b2_ls_inactive_limit;
    _impulse.z := 0.0;
  end;
  if not _enable_motor then
  _motor_impulse := 0.0;
  if data.step.warm_starting then
  begin
    _impulse := _impulse * data.step.dt_ratio;
    _motor_impulse *= data.step.dt_ratio;
    p := _impulse.x * _perp + (_motor_impulse + _impulse.z) * _axis;
    l_a := _impulse.x * _s1 + _impulse.y + (_motor_impulse + _impulse.z) * _a1;
    l_b := _impulse.x * _s2 + _impulse.y + (_motor_impulse + _impulse.z) * _a2;
    v_a := v_a - (m_a * p);
    w_a -= i_a * l_a;
    v_b := v_b + (m_b * p);
    w_b += i_b * l_b;
  end
  else
  begin
    _impulse.set_zero;
    _motor_impulse := 0.0;
  end;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

procedure tb2_prismatic_joint.solve_velocity_constraints(var data: tb2_solver_data);
  var v_a, v_b, p, c_dot_1, b, f2r, df_2: tb2_vec2;
  var w_a, w_b, m_a, i_a, m_b, i_b, c_dot, impulse, old_impulse, max_impulse, l_a, l_b, c_dot_2: tb2_float32;
  var c_dot_3, f1, df: tb2_vec3;
begin
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  if _enable_motor and (_limit_state <> b2_ls_equal_limits) then
  begin
    c_dot := b2_dot(_axis, v_b - v_a) + _a2 * w_b - _a1 * w_a;
    impulse := _motor_mass * (_motor_speed - c_dot);
    old_impulse := _motor_impulse;
    max_impulse := data.step.dt * _max_motor_force;
    _motor_impulse := b2_clamp(_motor_impulse + impulse, -max_impulse, max_impulse);
    impulse := _motor_impulse - old_impulse;
    p := impulse * _axis;
    l_a := impulse * _a1;
    l_b := impulse * _a2;
    v_a := v_a - (m_a * p);
    w_a -= i_a * l_a;
    v_b := v_b + (m_b * p);
    w_b += i_b * l_b;
  end;
  c_dot_1.x := b2_dot(_perp, v_b - v_a) + _s2 * w_b - _s1 * w_a;
  c_dot_1.y := w_b - w_a;
  if _enable_limit and (_limit_state <> b2_ls_inactive_limit) then
  begin
    c_dot_2 := b2_dot(_axis, v_b - v_a) + _a2 * w_b - _a1 * w_a;
    c_dot_3.set_value(c_dot_1.x, c_dot_1.y, c_dot_2);
    f1 := _impulse;
    df :=  _k.solve33(-c_dot_3);
    _impulse := _impulse + df;
    if _limit_state = b2_ls_at_lower_limit then
    _impulse.z := b2_max(_impulse.z, 0.0)
    else if _limit_state = b2_ls_at_upper_limit then
    _impulse.z := b2_min(_impulse.z, 0.0);
    b := -c_dot_1 - (_impulse.z - f1.z) * b2_vec2(_k.ez.x, _k.ez.y);
    f2r := _k.solve22(b) + b2_vec2(f1.x, f1.y);
    _impulse.x := f2r.x;
    _impulse.y := f2r.y;
    df := _impulse - f1;
    p := df.x * _perp + df.z * _axis;
    l_a := df.x * _s1 + df.y + df.z * _a1;
    l_b := df.x * _s2 + df.y + df.z * _a2;
    v_a := v_a - (m_a * p);
    w_a -= i_a * l_a;
    v_b := v_b + (m_b * p);
    w_b += i_b * l_b;
  end
  else
  begin
    df_2 := _k.solve22(-c_dot_1);
    _impulse.x += df_2.x;
    _impulse.y += df_2.y;
    p := df_2.x * _perp;
    l_a := df_2.x * _s1 + df_2.y;
    l_b := df_2.x * _s2 + df_2.y;
    v_a := v_a - (m_a * p);
    w_a -= i_a * l_a;
    v_b := v_b + (m_b * p);
    w_b += i_b * l_b;
  end;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

function tb2_prismatic_joint.solve_position_constraints(var data: tb2_solver_data): boolean;
  var c_a, c_b, r_a, r_b, d, axis, perp, c1, impulse_1, p: tb2_vec2;
  var a_a, a_b, m_a, i_a, m_b, i_b, a1, a2, s1, s2, linear_error, angular_error, c2, translation, l_a, l_b: tb2_float32;
  var k11, k12, k13, k22, k23, k33: tb2_float32;
  var q_a, q_b: tb2_rot;
  var impulse, c: tb2_vec3;
  var active: boolean;
  var k: tb2_mat33;
  var k_2: tb2_mat22;
begin
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  q_a.set_value(a_a); q_b.set_value(a_b);
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  d := c_b + r_b - c_a - r_a;
  axis := b2_mul(q_a, _local_x_axis_a);
  a1 := b2_cross(d + r_a, axis);
  a2 := b2_cross(r_b, axis);
  perp := b2_mul(q_a, _local_y_axis_a);
  s1 := b2_cross(d + r_a, perp);
  s2 := b2_cross(r_b, perp);
  c1.x := b2_dot(perp, d);
  c1.y := a_b - a_a - _reference_angle;
  linear_error := b2_abs(c1.x);
  angular_error := b2_abs(c1.y);
  active := false;
  c2 := 0.0;
  if _enable_limit then
  begin
    translation := b2_dot(axis, d);
    if b2_abs(_upper_translation - _lower_translation) < 2.0 * b2_linear_slop then
    begin
      c2 := b2_clamp(translation, -b2_max_linear_correction, b2_max_linear_correction);
      linear_error := b2_max(linear_error, b2_abs(translation));
      active := true;
    end
    else if translation <= _lower_translation then
    begin
      c2 := b2_clamp(translation - _lower_translation + b2_linear_slop, -b2_max_linear_correction, 0.0);
      linear_error := b2_max(linear_error, _lower_translation - translation);
      active := true;
    end
    else if translation >= _upper_translation then
    begin
      c2 := b2_clamp(translation - _upper_translation - b2_linear_slop, 0.0, b2_max_linear_correction);
      linear_error := b2_max(linear_error, translation - _upper_translation);
      active := true;
    end;
  end;
  if active then
  begin
    k11 := m_a + m_b + i_a * s1 * s1 + i_b * s2 * s2;
    k12 := i_a * s1 + i_b * s2;
    k13 := i_a * s1 * a1 + i_b * s2 * a2;
    k22 := i_a + i_b;
    if k22 = 0.0 then
    k22 := 1.0;
    k23 := i_a * a1 + i_b * a2;
    k33 := m_a + m_b + i_a * a1 * a1 + i_b * a2 * a2;
    k.ex.set_value(k11, k12, k13);
    k.ey.set_value(k12, k22, k23);
    k.ez.set_value(k13, k23, k33);
    c.x := c1.x;
    c.y := c1.y;
    c.z := c2;
    impulse := k.solve33(-c);
  end
  else
  begin
    k11 := m_a + m_b + i_a * s1 * s1 + i_b * s2 * s2;
    k12 := i_a * s1 + i_b * s2;
    k22 := i_a + i_b;
    if k22 = 0.0 then
    k22 := 1.0;
    k_2.ex.set_value(k11, k12);
    k_2.ey.set_value(k12, k22);
    impulse_1 := k_2.solve(-c1);
    impulse.x := impulse_1.x;
    impulse.y := impulse_1.y;
    impulse.z := 0.0;
  end;
  p := impulse.x * perp + impulse.z * axis;
  l_a := impulse.x * s1 + impulse.y + impulse.z * a1;
  l_b := impulse.x * s2 + impulse.y + impulse.z * a2;
  c_a := c_a - (m_a * p);
  a_a -= i_a * l_a;
  c_b := c_b + (m_b * p);
  a_b += i_b * l_b;
  data.positions^[_index_a].c := c_a;
  data.positions^[_index_a].a := a_a;
  data.positions^[_index_b].c := c_b;
  data.positions^[_index_b].a := a_b;
  result := (linear_error <= b2_linear_slop) and (angular_error <= b2_angular_slop);
end;

constructor tb2_prismatic_joint.create_prismatic_joint(const def: tb2_prismatic_joint_def);
begin
  inherited create(def);
  _local_anchor_a := def.local_anchor_a;
  _local_anchor_b := def.local_anchor_b;
  _local_x_axis_a := def.local_axis_a;
  _local_x_axis_a.normalize;
  _local_y_axis_a := b2_cross(1.0, _local_x_axis_a);
  _reference_angle := def.reference_angle;
  _impulse.set_zero;
  _motor_mass := 0.0;
  _motor_impulse := 0.0;
  _lower_translation := def.lower_translation;
  _upper_translation := def.upper_translation;
  _max_motor_force := def.max_motor_force;
  _motor_speed := def.motor_speed;
  _enable_limit := def.enable_limit;
  _enable_motor := def.enable_motor;
  _limit_state := b2_ls_inactive_limit;
  _axis.set_zero;
  _perp.set_zero;
end;

function tb2_prismatic_joint.get_anchor_a: tb2_vec2;
begin
  result := _body_a^.get_world_point(_local_anchor_a);
end;

function tb2_prismatic_joint.get_anchor_b: tb2_vec2;
begin
  result := _body_b^.get_world_point(_local_anchor_b);
end;

function tb2_prismatic_joint.get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2;
begin
  result := rcp_dt * (_impulse.x * _perp + (_motor_impulse + _impulse.z) * _axis);
end;

function tb2_prismatic_joint.get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := rcp_dt * _impulse.y;
end;

function tb2_prismatic_joint.get_local_anchor_a: tb2_vec2;
begin
  result := _local_anchor_a;
end;

function tb2_prismatic_joint.get_local_anchor_b: tb2_vec2;
begin
  result := _local_anchor_b;
end;

function tb2_prismatic_joint.get_local_axis_a: tb2_vec2;
begin
  result := _local_x_axis_a;
end;

function tb2_prismatic_joint.get_reference_angle: tb2_float32;
begin
  result := _reference_angle;
end;

function tb2_prismatic_joint.get_joint_translation: tb2_float32;
  var p_a, p_b, d, axis: tb2_vec2;
begin
  p_a := _body_a^.get_world_point(_local_anchor_a);
  p_b := _body_b^.get_world_point(_local_anchor_b);
  d := p_b - p_a;
  axis := _body_a^.get_world_vector(_local_x_axis_a);
  result := b2_dot(d, axis);
end;

function tb2_prismatic_joint.get_joint_speed: tb2_float32;
  var r_a, r_b, p1, p2, d, axis, v_a, v_b: tb2_vec2;
  var w_a, w_b: tb2_float32;
begin
  r_a := b2_mul(_body_a^._xf.q, _local_anchor_a - _body_a^._sweep.local_center);
  r_b := b2_mul(_body_b^._xf.q, _local_anchor_b - _body_b^._sweep.local_center);
  p1 := _body_a^._sweep.c + r_a;
  p2 := _body_b^._sweep.c + r_b;
  d := p2 - p1;
  axis := b2_mul(_body_a^._xf.q, _local_x_axis_a);
  v_a := _body_a^._linear_velocity;
  v_b := _body_b^._linear_velocity;
  w_a := _body_a^._angular_velocity;
  w_b := _body_b^._angular_velocity;
  result := b2_dot(d, b2_cross(w_a, axis)) + b2_dot(axis, v_b + b2_cross(w_b, r_b) - v_a - b2_cross(w_a, r_a));
end;

function tb2_prismatic_joint.is_limit_enabled: boolean;
begin
  result := _enable_limit;
end;

procedure tb2_prismatic_joint.enable_limit(const flag: boolean);
begin
  if flag <> _enable_limit then
  begin
    _body_a^.set_awake(true);
    _body_b^.set_awake(true);
    _enable_limit := flag;
    _impulse.z := 0.0;
  end;
end;

function tb2_prismatic_joint.get_lower_limit: tb2_float32;
begin
  result := _lower_translation;
end;

function tb2_prismatic_joint.get_upper_limit: tb2_float32;
begin
  result := _upper_translation;
end;

procedure tb2_prismatic_joint.set_limits(const lower, upper: tb2_float32);
begin
  if (lower <> _lower_translation) or (upper <> _upper_translation) then
  begin
    _body_a^.set_awake(true);
    _body_b^.set_awake(true);
    _lower_translation := lower;
    _upper_translation := upper;
    _impulse.z := 0.0;
  end;
end;

function tb2_prismatic_joint.is_motor_enabled: boolean;
begin
  result := _enable_motor;
end;

procedure tb2_prismatic_joint.enable_motor(const flag: boolean);
begin
  _body_a^.set_awake(true);
  _body_b^.set_awake(true);
  _enable_motor := flag;
end;

procedure tb2_prismatic_joint.set_motor_speed(const speed: tb2_float32);
begin
  _body_a^.set_awake(true);
  _body_b^.set_awake(true);
  _motor_speed := speed;
end;

function tb2_prismatic_joint.get_motor_speed: tb2_float32;
begin
  result := _motor_speed;
end;

procedure tb2_prismatic_joint.set_max_motor_force(const force: tb2_float32);
begin
  _body_a^.set_awake(true);
  _body_b^.set_awake(true);
  _max_motor_force := force;
end;

function tb2_prismatic_joint.get_max_motor_force: tb2_float32;
begin
  result := _max_motor_force;
end;

function tb2_prismatic_joint.get_motor_force(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := rcp_dt * _motor_impulse;
end;

procedure tb2_prismatic_joint.dump;
begin
  //int32 indexA = m_bodyA->m_islandIndex;
  //int32 indexB = m_bodyB->m_islandIndex;
  //
  //b2Log("  b2PrismaticJointDef jd;\n");
  //b2Log("  jd.bodyA = bodies[%d];\n", indexA);
  //b2Log("  jd.bodyB = bodies[%d];\n", indexB);
  //b2Log("  jd.collideConnected = bool(%d);\n", m_collideConnected);
  //b2Log("  jd.localAnchorA.Set(%.15lef, %.15lef);\n", m_localAnchorA.x, m_localAnchorA.y);
  //b2Log("  jd.localAnchorB.Set(%.15lef, %.15lef);\n", m_localAnchorB.x, m_localAnchorB.y);
  //b2Log("  jd.localAxisA.Set(%.15lef, %.15lef);\n", m_localXAxisA.x, m_localXAxisA.y);
  //b2Log("  jd.referenceAngle = %.15lef;\n", m_referenceAngle);
  //b2Log("  jd.enableLimit = bool(%d);\n", m_enableLimit);
  //b2Log("  jd.lowerTranslation = %.15lef;\n", m_lowerTranslation);
  //b2Log("  jd.upperTranslation = %.15lef;\n", m_upperTranslation);
  //b2Log("  jd.enableMotor = bool(%d);\n", m_enableMotor);
  //b2Log("  jd.motorSpeed = %.15lef;\n", m_motorSpeed);
  //b2Log("  jd.maxMotorForce = %.15lef;\n", m_maxMotorForce);
  //b2Log("  joints[%d] = m_world->CreateJoint(&jd);\n", m_index);
end;
//tb2_prismatic_joint END

//tb2_pulley_joint_def BEGIN
procedure tb2_pulley_joint_def.initialize(
  const b_a, b_b: pb2_body;
  const ground_a, ground_b: tb2_vec2;
  const anchor_a, anchor_b: tb2_vec2;
  const new_ratio: tb2_float32
);
begin
  body_a := b_a;
  body_b := b_b;
  ground_anchor_a := ground_a;
  ground_anchor_b := ground_b;
  local_anchor_a := body_a^.get_local_point(anchor_a);
  local_anchor_b := body_b^.get_local_point(anchor_b);
  length_a := (anchor_a - ground_a).len;
  length_b := (anchor_b - ground_b).len;
  ratio := new_ratio;
end;
//tb2_pulley_joint_def END

//tb2_pulley_joint BEIGN
procedure tb2_pulley_joint.init_velocity_constraints(var data: tb2_solver_data);
  var c_a, v_a, c_b, v_b, p_a, p_b: tb2_vec2;
  var a_a, w_a, a_b, w_b, length_a, length_b, ru_a, ru_b, m_a, m_b: tb2_float32;
  var q_a, q_b: tb2_rot;
begin
  _index_a := _body_a^._island_index;
  _index_b := _body_b^._island_index;
  _local_center_a := _body_a^._sweep.local_center;
  _local_center_b := _body_b^._sweep.local_center;
  _rcp_mass_a := _body_a^._rcp_mass;
  _rcp_mass_b := _body_b^._rcp_mass;
  _rcp_inertia_a := _body_a^._rcp_inertia;
  _rcp_inertia_b := _body_b^._rcp_inertia;
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  q_a.set_value(a_a); q_b.set_value(a_b);
  _r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  _r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  _u_a := c_a + _r_a - _ground_anchor_a;
  _u_b := c_b + _r_b - _ground_anchor_b;
  length_a := _u_a.len;
  length_b := _u_b.len;
  if length_a > 10.0 * b2_linear_slop then
  _u_a := _u_a * (1.0 / length_a)
  else
  _u_a.set_zero;
  if length_b > 10.0 * b2_linear_slop then
  _u_b := _u_b * (1.0 / length_b)
  else
  _u_b.set_zero;
  ru_a := b2_cross(_r_a, _u_a);
  ru_b := b2_cross(_r_b, _u_b);
  m_a := _rcp_mass_a + _rcp_inertia_a * ru_a * ru_a;
  m_b := _rcp_mass_b + _rcp_inertia_b * ru_b * ru_b;
  _mass := m_a + _ratio * _ratio * m_b;
  if _mass > 0.0 then
  _mass := 1.0 / _mass;
  if data.step.warm_starting then
  begin
    _impulse *= data.step.dt_ratio;
    p_a := -(_impulse) * _u_a;
    p_b := (-_ratio * _impulse) * _u_b;
    v_a := v_a + (_rcp_mass_a * p_a);
    w_a += _rcp_inertia_a * b2_cross(_r_a, p_a);
    v_b := v_b + (_rcp_mass_b * p_b);
    w_b += _rcp_inertia_b * b2_cross(_r_b, p_b);
  end
  else
  _impulse := 0.0;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

procedure tb2_pulley_joint.solve_velocity_constraints(var data: tb2_solver_data);
  var v_a, v_b, vp_a, vp_b, p_a, p_b: tb2_vec2;
  var w_a, w_b, c_dot, impulse: tb2_float32;
begin
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  vp_a := v_a + b2_cross(w_a, _r_a);
  vp_b := v_b + b2_cross(w_b, _r_b);
  c_dot := -b2_dot(_u_a, vp_a) - _ratio * b2_dot(_u_b, vp_b);
  impulse := -_mass * c_dot;
  _impulse += impulse;
  p_a := -impulse * _u_a;
  p_b := -_ratio * impulse * _u_b;
  v_a := v_a + (_rcp_mass_a * p_a);
  w_a += _rcp_inertia_a * b2_cross(_r_a, p_a);
  v_b := v_b + (_rcp_mass_b * p_b);
  w_b += _rcp_inertia_b * b2_cross(_r_b, p_b);
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

function tb2_pulley_joint.solve_position_constraints(var data: tb2_solver_data): boolean;
  var c_a, c_b, r_a, r_b, u_a, u_b, p_a, p_b: tb2_vec2;
  var a_a, a_b, length_a, length_b, ru_a, ru_b, m_a, m_b, mass, c, linear_error, impulse: tb2_float32;
  var q_a, q_b: tb2_rot;
begin
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  q_a.set_value(a_a); q_b.set_value(a_b);
  r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  u_a := c_a + r_a - _ground_anchor_a;
  u_b := c_b + r_b - _ground_anchor_b;
  length_a := u_a.len;
  length_b := u_b.len;
  if length_a > 10.0 * b2_linear_slop then
  u_a := u_a * (1.0 / length_a)
  else
  u_a.set_zero;
  if length_b > 10.0 * b2_linear_slop then
  u_b := u_b * (1.0 / length_b)
  else
  u_b.set_zero;
  ru_a := b2_cross(r_a, u_a);
  ru_b := b2_cross(r_b, u_b);
  m_a := _rcp_mass_a + _rcp_inertia_a * ru_a * ru_a;
  m_b := _rcp_mass_b + _rcp_inertia_b * ru_b * ru_b;
  mass := m_a + _ratio * _ratio * m_b;
  if mass > 0.0 then
  mass := 1.0 / mass;
  c := _constant - length_a - _ratio * length_b;
  linear_error := b2_abs(c);
  impulse := -mass * c;
  p_a := -impulse * u_a;
  p_b := -_ratio * impulse * u_b;
  c_a := c_a + (_rcp_mass_a * p_a);
  a_a += _rcp_inertia_a * b2_cross(r_a, p_a);
  c_b := c_b + (_rcp_mass_b * p_b);
  a_b += _rcp_inertia_b * b2_cross(r_b, p_b);
  data.positions^[_index_a].c := c_a;
  data.positions^[_index_a].a := a_a;
  data.positions^[_index_b].c := c_b;
  data.positions^[_index_b].a := a_b;
  result := linear_error < b2_linear_slop;
end;

constructor tb2_pulley_joint.create_pulley_joint(const def: tb2_pulley_joint_def);
begin
  inherited create(def);
  _ground_anchor_a := def.ground_anchor_a;
  _ground_anchor_b := def.ground_anchor_b;
  _local_anchor_a := def.local_anchor_a;
  _local_anchor_b := def.local_anchor_b;
  _length_a := def.length_a;
  _length_b := def.length_b;
  _ratio := def.ratio;
  _constant := def.length_a + _ratio * def.length_b;
  _impulse := 0.0;
end;

function tb2_pulley_joint.get_anchor_a: tb2_vec2;
begin
  result := _body_a^.get_world_point(_local_anchor_a);
end;

function tb2_pulley_joint.get_anchor_b: tb2_vec2;
begin
  result := _body_b^.get_world_point(_local_anchor_b);
end;

function tb2_pulley_joint.get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2;
begin
  result := rcp_dt * (_impulse * _u_b);
end;

{$hints off}
function tb2_pulley_joint.get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := 0;
end;
{$hints on}

function tb2_pulley_joint.get_ground_anchor_a: tb2_vec2;
begin
  result := _ground_anchor_a;
end;

function tb2_pulley_joint.get_ground_anchor_b: tb2_vec2;
begin
  result := _ground_anchor_b;
end;

function tb2_pulley_joint.get_length_a: tb2_float32;
begin
  result := _length_b;
end;

function tb2_pulley_joint.get_length_b: tb2_float32;
begin
  result := _length_b;
end;

function tb2_pulley_joint.get_ratio: tb2_float32;
begin
  result := _ratio;
end;

function tb2_pulley_joint.get_current_length_a: tb2_float32;
begin
  result := (_body_a^.get_world_point(_local_anchor_a) - _ground_anchor_a).len;
end;

function tb2_pulley_joint.get_current_length_b: tb2_float32;
begin
  result := (_body_b^.get_world_point(_local_anchor_b) - _ground_anchor_b).len;
end;

procedure tb2_pulley_joint.shift_origin(const new_origin: tb2_vec2);
begin
  _ground_anchor_a := _ground_anchor_a - new_origin;
  _ground_anchor_b := _ground_anchor_b - new_origin;
end;

procedure tb2_pulley_joint.dump;
begin
  //int32 indexA = m_bodyA->m_islandIndex;
  //int32 indexB = m_bodyB->m_islandIndex;
  //
  //b2Log("  b2PulleyJointDef jd;\n");
  //b2Log("  jd.bodyA = bodies[%d];\n", indexA);
  //b2Log("  jd.bodyB = bodies[%d];\n", indexB);
  //b2Log("  jd.collideConnected = bool(%d);\n", m_collideConnected);
  //b2Log("  jd.groundAnchorA.Set(%.15lef, %.15lef);\n", m_groundAnchorA.x, m_groundAnchorA.y);
  //b2Log("  jd.groundAnchorB.Set(%.15lef, %.15lef);\n", m_groundAnchorB.x, m_groundAnchorB.y);
  //b2Log("  jd.localAnchorA.Set(%.15lef, %.15lef);\n", m_localAnchorA.x, m_localAnchorA.y);
  //b2Log("  jd.localAnchorB.Set(%.15lef, %.15lef);\n", m_localAnchorB.x, m_localAnchorB.y);
  //b2Log("  jd.lengthA = %.15lef;\n", m_lengthA);
  //b2Log("  jd.lengthB = %.15lef;\n", m_lengthB);
  //b2Log("  jd.ratio = %.15lef;\n", m_ratio);
  //b2Log("  joints[%d] = m_world->CreateJoint(&jd);\n", m_index);
end;
//tb2_pulley_joint END

//tb2_gear_joint BEGIN
procedure tb2_gear_joint.init_velocity_constraints(var data: tb2_solver_data);
  var a_a, a_b, a_c, a_d, w_a, w_b, w_c, w_d: tb2_float32;
  var v_a, v_b, v_c, v_d, u, r_a, r_b, r_c, r_d: tb2_vec2;
  var q_a, q_b, q_c, q_d: tb2_rot;
begin
  _index_a := _body_a^._island_index;
  _index_b := _body_b^._island_index;
  _index_c := _body_c^._island_index;
  _index_d := _body_d^._island_index;
  _lc_a := _body_a^._sweep.local_center;
  _lc_b := _body_b^._sweep.local_center;
  _lc_c := _body_d^._sweep.local_center;
  _lc_d := _body_d^._sweep.local_center;
  _m_a := _body_a^._rcp_mass;
  _m_b := _body_b^._rcp_mass;
  _m_c := _body_c^._rcp_mass;
  _m_d := _body_d^._rcp_mass;
  _i_a := _body_a^._rcp_inertia;
  _i_b := _body_b^._rcp_inertia;
  _i_c := _body_c^._rcp_inertia;
  _i_d := _body_d^._rcp_inertia;
  a_a := data.positions^[_index_a].a;
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  a_b := data.positions^[_index_b].a;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  a_c := data.positions^[_index_c].a;
  v_c := data.velocities^[_index_c].v;
  w_c := data.velocities^[_index_c].w;
  a_d := data.positions^[_index_d].a;
  v_d := data.velocities^[_index_d].v;
  w_d := data.velocities^[_index_d].w;
  q_a.set_value(a_a); q_b.set_value(a_b); q_c.set_value(a_c); q_d.set_value(a_d);
  _mass := 0.0;
  if _type_a = b2_jt_revolute_joint then
  begin
    _jv_ac.set_zero;
    _jw_a := 1.0;
    _jw_c := 1.0;
    _mass += _i_a + _i_c;
  end
  else
  begin
    u := b2_mul(q_c, _local_axis_c);
    r_c := b2_mul(q_c, _local_anchor_c - _lc_c);
    r_a := b2_mul(q_a, _local_anchor_a - _lc_a);
    _jv_ac := u;
    _jw_c := b2_cross(r_c, u);
    _jw_a := b2_cross(r_a, u);
    _mass += _m_c + _m_a + _i_c * _jw_c * _jw_c + _i_a * _jw_a * _jw_a;
  end;
  if _type_b = b2_jt_revolute_joint then
  begin
    _jv_bd.set_zero;
    _jw_b := _ratio;
    _jw_d := _ratio;
    _mass += _ratio * _ratio * (_i_b + _i_d);
  end
  else
  begin
    u := b2_mul(q_d, _local_axis_d);
    r_d := b2_mul(q_d, _local_anchor_d - _lc_d);
    r_b := b2_mul(q_b, _local_anchor_b - _lc_b);
    _jv_bd := _ratio * u;
    _jw_d := _ratio * b2_cross(r_d, u);
    _jw_b := _ratio * b2_cross(r_b, u);
    _mass += _ratio * _ratio * (_m_d + _m_b) + _i_d * _jw_d * _jw_d + _i_b * _jw_b * _jw_b;
  end;
  if _mass > 0.0 then
  _mass := 1.0 / _mass
  else
  _mass := 0.0;
  if data.step.warm_starting then
  begin
    v_a := v_a + ((_m_a * _impulse) * _jv_ac);
    w_a += _i_a * _impulse * _jw_a;
    v_b := v_b + ((_m_b * _impulse) * _jv_bd);
    w_b += _i_b * _impulse * _jw_b;
    v_c := v_c - ((_m_c * _impulse) * _jv_ac);
    w_c -= _i_c * _impulse * _jw_c;
    v_d := v_d - ((_m_d * _impulse) * _jv_bd);
    w_d -= _i_d * _impulse * _jw_d;
  end
  else
  _impulse := 0.0;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
  data.velocities^[_index_c].v := v_c;
  data.velocities^[_index_c].w := w_c;
  data.velocities^[_index_d].v := v_d;
  data.velocities^[_index_d].w := w_d;
end;

procedure tb2_gear_joint.solve_velocity_constraints(var data: tb2_solver_data);
  var v_a, v_b, v_c, v_d: tb2_vec2;
  var w_a, w_b, w_c, w_d, c_dot, impulse: tb2_float32;
begin
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  v_c := data.velocities^[_index_c].v;
  w_c := data.velocities^[_index_c].w;
  v_d := data.velocities^[_index_d].v;
  w_d := data.velocities^[_index_d].w;
  c_dot := b2_dot(_jv_ac, v_a - v_c) + b2_dot(_jv_bd, v_b - v_d);
  c_dot += (_jw_a * w_a - _jw_c * w_c) + (_jw_b * w_b - _jw_d * w_d);
  impulse := -_mass * c_dot;
  _impulse += impulse;
  v_a := v_a + ((_m_a * impulse) * _jv_ac);
  w_a += _i_a * impulse * _jw_a;
  v_b := v_b + ((_m_b * impulse) * _jv_bd);
  w_b += _i_b * impulse * _jw_b;
  v_c := v_c - ((_m_c * impulse) * _jv_ac);
  w_c -= _i_c * impulse * _jw_c;
  v_d := v_d - ((_m_d * impulse) * _jv_bd);
  w_d -= _i_d * impulse * _jw_d;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
  data.velocities^[_index_c].v := v_c;
  data.velocities^[_index_c].w := w_c;
  data.velocities^[_index_d].v := v_d;
  data.velocities^[_index_d].w := w_d;
end;

function tb2_gear_joint.solve_position_constraints(var data: tb2_solver_data): boolean;
  var c_a, c_b, c_c, c_d, jv_ac, jv_bd, u, r_c, r_a, r_b, r_d, p_c, p_a, p_b, p_d: tb2_vec2;
  var a_a, a_b, a_c, a_d, linear_error, coord_a, coord_b, jw_a, jw_b, jw_c, jw_d, mass, c, impulse: tb2_float32;
  var q_a, q_b, q_c, q_d: tb2_rot;
begin
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  c_c := data.positions^[_index_c].c;
  a_c := data.positions^[_index_c].a;
  c_d := data.positions^[_index_d].c;
  a_d := data.positions^[_index_d].a;
  q_a.set_value(a_a); q_b.set_value(a_b); q_c.set_value(a_c); q_d.set_value(a_d);
  linear_error := 0.0;
  mass := 0.0;
  if _type_a = b2_jt_revolute_joint then
  begin
    jv_ac.set_zero;
    jw_a := 1.0;
    jw_c := 1.0;
    mass += _i_a + _i_c;
    coord_a := a_a - a_c - _reference_angle_a;
  end
  else
  begin
    u := b2_mul(q_c, _local_axis_c);
    r_c := b2_mul(q_c, _local_anchor_c - _lc_c);
    r_a := b2_mul(q_a, _local_anchor_a - _lc_a);
    jv_ac := u;
    jw_c := b2_cross(r_c, u);
    jw_a := b2_cross(r_a, u);
    mass += _m_c + _m_a + _i_c * jw_c * jw_c + _i_a * jw_a * jw_a;
    p_c := _local_anchor_c - _lc_c;
    p_a := b2_mul_t(q_c, r_a + (c_a - c_c));
    coord_a := b2_dot(p_a - p_c, _local_axis_c);
  end;
  if _type_b = b2_jt_revolute_joint then
  begin
    jv_bd.set_zero;
    jw_b := _ratio;
    jw_d := _ratio;
    mass += _ratio * _ratio * (_i_b + _i_d);
    coord_b := a_b - a_d - _reference_angle_b;
  end
  else
  begin
    u := b2_mul(q_d, _local_axis_d);
    r_d := b2_mul(q_d, _local_anchor_d - _lc_d);
    r_b := b2_mul(q_b, _local_anchor_b - _lc_b);
    jv_bd := _ratio * u;
    jw_d := _ratio * b2_cross(r_d, u);
    jw_b := _ratio * b2_cross(r_b, u);
    mass += _ratio * _ratio * (_m_d + _m_b) + _i_d * jw_d * jw_d + _i_b * jw_b * jw_b;
    p_d := _local_anchor_d - _lc_d;
    p_b := b2_mul_t(q_d, r_b + (c_b - c_d));
    coord_b := b2_dot(p_b - p_d, _local_axis_d);
  end;
  c := (coord_a + _ratio * coord_b) - _constant;
  impulse := 0.0;
  if mass > 0.0 then impulse := -c / mass;
  c_a := c_a + (_m_a * impulse * jv_ac);
  a_a += _i_a * impulse * jw_a;
  c_b := c_b + (_m_b * impulse * jv_bd);
  a_b += _i_b * impulse * jw_b;
  c_c := c_c - (_m_c * impulse * jv_ac);
  a_a -= _i_c * impulse * jw_c;
  c_d := c_d - (_m_d * impulse * jv_bd);
  a_d -= _i_d * impulse * jw_d;
  data.positions^[_index_a].c := c_a;
  data.positions^[_index_a].a := a_a;
  data.positions^[_index_b].c := c_b;
  data.positions^[_index_b].a := a_b;
  data.positions^[_index_c].c := c_c;
  data.positions^[_index_c].a := a_c;
  data.positions^[_index_d].c := c_d;
  data.positions^[_index_d].a := a_d;
  result := linear_error < b2_linear_slop;
end;

constructor tb2_gear_joint.create_gear_joint(const def: tb2_gear_joint_def);
  var coord_a, coord_b, a_a, a_c, a_b, a_d: tb2_float32;
  var p_c, p_a, p_b, p_d: tb2_vec2;
  var xf_a, xf_c, xf_b, xf_d: tb2_transform;
  var revolute: pb2_revolute_joint;
  var prismatic: pb2_prismatic_joint;
begin
  inherited create(def);
  _joint1 := def.joint1;
  _joint2 := def.joint2;
  _type_a := _joint1^.get_type;
  _type_b := _joint2^.get_type;
  _body_c := _joint1^.get_body_a;
  _body_a := _joint1^.get_body_b;
  xf_a := _body_a^._xf;
  a_a := _body_a^._sweep.a;
  xf_c := _body_c^._xf;
  a_c := _body_c^._sweep.a;
  if _type_a = b2_jt_revolute_joint then
  begin
    revolute := pb2_revolute_joint(def.joint1);
    _local_anchor_c := revolute^._local_anchor_a;
    _local_anchor_a := revolute^._local_anchor_b;
    _reference_angle_a := revolute^._reference_angle;
    _local_axis_c.set_zero;
    coord_a := a_a - a_c - _reference_angle_a;
  end
  else
  begin
    prismatic := pb2_prismatic_joint(def.joint1);
    _local_anchor_c := prismatic^._local_anchor_a;
    _local_anchor_a := prismatic^._local_anchor_b;
    _reference_angle_a := prismatic^._reference_angle;
    _local_axis_c := prismatic^._local_x_axis_a;
    p_c := _local_anchor_c;
    p_a := b2_mul_t(xf_c.q, b2_mul(xf_a.q, _local_anchor_a) + (xf_a.p - xf_c.p));
    coord_a := b2_dot(p_a - p_c, _local_axis_c);
  end;
  _body_d := _joint2^.get_body_a;
  _body_b := _joint2^.get_body_b;
  xf_b := _body_b^._xf;
  a_b := _body_b^._sweep.a;
  xf_d := _body_d^._xf;
  a_d := _body_d^._sweep.a;
  if _type_b = b2_jt_revolute_joint then
  begin
    revolute := pb2_revolute_joint(def.joint2);
    _local_anchor_d := revolute^._local_anchor_a;
    _local_anchor_b := revolute^._local_anchor_b;
    _reference_angle_b := revolute^._reference_angle;
    _local_axis_d.set_zero;
    coord_b := a_b - a_d - _reference_angle_b;
  end
  else
  begin
    prismatic := pb2_prismatic_joint(def.joint2);
    _local_anchor_d := prismatic^._local_anchor_a;
    _local_anchor_b := prismatic^._local_anchor_b;
    _reference_angle_b := prismatic^._reference_angle;
    _local_axis_d := prismatic^._local_x_axis_a;
    p_d := _local_anchor_d;
    p_b := b2_mul_t(xf_d.q, b2_mul(xf_b.q, _local_anchor_b) + (xf_b.p - xf_d.p));
    coord_b := b2_dot(p_b - p_d, _local_axis_d);
  end;
  _ratio := def.ratio;
  _constant := coord_a + _ratio * coord_b;
  _impulse := 0.0;
end;

function tb2_gear_joint.get_anchor_a: tb2_vec2;
begin
  result := _body_a^.get_world_point(_local_anchor_a);
end;

function tb2_gear_joint.get_anchor_b: tb2_vec2;
begin
  result := _body_b^.get_world_point(_local_anchor_a);
end;

function tb2_gear_joint.get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2;
begin
  result := rcp_dt * (_impulse * _jv_ac);
end;

function tb2_gear_joint.get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := rcp_dt * (_impulse * _jw_a);
end;

function tb2_gear_joint.get_joint1: pb2_joint;
begin
  result := _joint1;
end;

function tb2_gear_joint.get_joint2: pb2_joint;
begin
  result := _joint2;
end;

procedure tb2_gear_joint.set_ratio(const ratio: tb2_float32);
begin
  _ratio := ratio;
end;

function tb2_gear_joint.get_ratio: tb2_float32;
begin
  result := _ratio;
end;

procedure tb2_gear_joint.dump;
begin
  //int32 indexA = m_bodyA->m_islandIndex;
  //int32 indexB = m_bodyB->m_islandIndex;
  //
  //int32 index1 = m_joint1->m_index;
  //int32 index2 = m_joint2->m_index;
  //
  //b2Log("  b2GearJointDef jd;\n");
  //b2Log("  jd.bodyA = bodies[%d];\n", indexA);
  //b2Log("  jd.bodyB = bodies[%d];\n", indexB);
  //b2Log("  jd.collideConnected = bool(%d);\n", m_collideConnected);
  //b2Log("  jd.joint1 = joints[%d];\n", index1);
  //b2Log("  jd.joint2 = joints[%d];\n", index2);
  //b2Log("  jd.ratio = %.15lef;\n", m_ratio);
  //b2Log("  joints[%d] = m_world->CreateJoint(&jd);\n", m_index);
end;
//tb2_gear_joint END

//tb2_weld_joint_def BEGIN
procedure tb2_weld_joint_def.initialize(const b_a, b_b: pb2_body; const anchor: tb2_vec2);
begin
  body_a := b_a;
  body_b := b_b;
  local_anchor_a := body_a^.get_local_point(anchor);
  local_anchor_b := body_b^.get_local_point(anchor);
  reference_angle := body_b^.get_angle - body_a^.get_angle;
end;
//tb2_weld_joint_def END

//tb2_weld_joint BEGIN
procedure tb2_weld_joint.init_velocity_constraints(var data: tb2_solver_data);
  var a_a, w_a, a_b, w_b, m_a, m_b, i_a, i_b, rcp_m, m, c, omega, d, k_1, h: tb2_float32;
  var v_a, v_b, p: tb2_vec2;
  var q_a, q_b: tb2_rot;
  var k: tb2_mat33;
begin
  _index_a := _body_a^._island_index;
  _index_b := _body_b^._island_index;
  _local_center_a := _body_a^._sweep.local_center;
  _local_center_a := _body_b^._sweep.local_center;
  _rcp_mass_a := _body_a^._rcp_mass;
  _rcp_mass_b := _body_b^._rcp_mass;
  _rcp_inertia_a := _body_a^._rcp_inertia;
  _rcp_inertia_b := _body_b^._rcp_inertia;
  a_a := data.positions^[_index_a].a;
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  a_b := data.positions^[_index_b].a;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  q_a.set_value(a_a); q_b.set_value(a_b);
  _r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  _r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  k.ex.x := m_a + m_b + _r_a.y * _r_a.y * i_a + _r_b.y * _r_b.y * i_b;
  k.ey.x := -_r_a.y * _r_a.x * i_a - _r_b.y * _r_b.x * i_b;
  k.ez.x := -_r_a.y * i_a - _r_b.y * i_b;
  k.ex.y := k.ey.x;
  k.ey.y := m_a + m_b + _r_a.x * _r_a.x * i_a + _r_b.x * _r_b.x * i_b;
  k.ez.y := _r_a.x * i_a + _r_b.x * i_b;
  k.ex.z := k.ez.x;
  k.ey.z := k.ez.y;
  k.ez.z := i_a + i_b;
  if _frequency_hz > 0.0 then
  begin
    k.get_inverse22(@_mass);
    rcp_m := i_a + i_b;
    if rcp_m > 0.0 then m := 1.0 / rcp_m else m := 0.0;
    c := a_b - a_a - _reference_angle;
    omega := 2.0 * b2_pi * _frequency_hz;
    d := 2.0 * m * _damping_ratio * omega;
    k_1 := m * omega * omega;
    h := data.step.dt;
    _gamma := h * (d + h * k_1);
    if _gamma <> 0.0 then _gamma := 1.0 / _gamma else _gamma := 0.0;
    _bias := c * h * k_1 * _gamma;
    rcp_m += _gamma;
    if rcp_m <> 0.0 then _mass.ez.z := 1.0 / rcp_m else _mass.ez.z := 0.0;
  end
  else if k.ez.z = 0.0 then
  begin
    k.get_inverse22(@_mass);
    _gamma := 0.0;
    _bias := 0.0;
  end
  else
  begin
    k.get_sym_inverse33(@_mass);
    _gamma := 0.0;
    _bias := 0.0;
  end;
  if data.step.warm_starting then
  begin
    _impulse := _impulse * data.step.dt_ratio;
    p.set_value(_impulse.x, _impulse.y);
    v_a := v_a - (m_a * p);
    w_a -= i_a * (b2_cross(_r_a, p) + _impulse.z);
    v_b := v_b + (m_b * p);
    w_b += i_b * (b2_cross(_r_b, p) + _impulse.z);
  end
  else
  begin
    _impulse.set_zero;
  end;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

procedure tb2_weld_joint.solve_velocity_constraints(var data: tb2_solver_data);
  var v_a, v_b, c_dot_1, impulse_1, p: tb2_vec2;
  var w_a, w_b, m_a, m_b, i_a, i_b, c_dot_2, impulse_2: tb2_float32;
  var c_dot, impulse: tb2_vec3;
begin
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  if _frequency_hz > 0.0 then
  begin
    c_dot_2 := w_b - w_a;
    impulse_2 := -_mass.ez.z * (c_dot_2 + _bias + _gamma * _impulse.z);
    _impulse.z += impulse_2;
    w_a -= i_a * impulse_2;
    w_b += i_b * impulse_2;
    c_dot_1 := v_b + b2_cross(w_b, _r_b) - v_a - b2_cross(w_a, _r_a);
    impulse_1 := -b2_mul22(_mass, c_dot_1);
    _impulse.x += impulse_1.x;
    _impulse.y += impulse_1.y;
    p := impulse_1;
    v_a := v_a - (m_a * p);
    w_a -= i_a * b2_cross(_r_a, p);
    v_b := v_b + (m_b * p);
    w_b += i_b * b2_cross(_r_b, p);
  end
  else
  begin
    c_dot_1 := v_b + b2_cross(w_b, _r_b) - v_a - b2_cross(w_a, _r_a);
    c_dot_2 := w_b - w_a;
    c_dot.set_value(c_dot_1.x, c_dot_1.y, c_dot_2);
    impulse := -b2_mul(_mass, c_dot);
    _impulse := _impulse + impulse;
    p.set_value(impulse.x, impulse.y);
    v_a := v_a - (m_a * p);
    w_a -= i_a * (b2_cross(_r_a, p) + impulse.z);
    v_b := v_b + (m_b * p);
    w_b += i_b * (b2_cross(_r_b, p) + impulse.z);
  end;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

function tb2_weld_joint.solve_position_constraints(var data: tb2_solver_data): boolean;
  var c_a, c_b, r_a, r_b, c_1, p, impulse_2: tb2_vec2;
  var a_a, a_b, m_a, m_b, i_a, i_b, position_error, angular_error, c_2: tb2_float32;
  var q_a, q_b: tb2_rot;
  var k: tb2_mat33;
  var c, impulse: tb2_vec3;
begin
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  q_a.set_value(a_a); q_b.set_value(a_b);
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  k.ex.x := m_a + m_b + r_a.y * r_a.y * i_a + r_b.y * r_b.y * i_b;
  k.ey.x := -r_a.y * r_a.x * i_a - r_b.y * r_b.x * i_b;
  k.ez.x := -r_a.y * i_a - r_b.y * i_b;
  k.ex.y := k.ey.x;
  k.ey.y := m_a + m_b + r_a.x * r_a.x * i_a + r_b.x * r_b.x * i_b;
  k.ez.y := r_a.x * i_a + r_b.x * i_b;
  k.ex.z := k.ez.x;
  k.ey.z := k.ez.y;
  k.ez.z := i_a + i_b;
  if _frequency_hz > 0.0 then
  begin
    c_1 :=  c_b + r_b - c_a - r_a;
    position_error := c_1.len;
    angular_error := 0.0;
    p := -k.solve22(c_1);
    c_a := c_a - (m_a * p);
    a_a -= i_a * b2_cross(r_a, p);
    c_b := c_b + (m_b * p);
    a_b += i_b * b2_cross(r_b, p);
  end
  else
  begin
    c_1 :=  c_b + r_b - c_a - r_a;
    c_2 := a_b - a_a - _reference_angle;
    position_error := c_1.len;
    angular_error := b2_abs(c_2);
    c.set_value(c_1.x, c_1.y, c_2);
    if k.ez.z > 0.0 then
    impulse := -k.solve33(c)
    else
    begin
      impulse_2 := -k.solve22(c_1);
      impulse.set_value(impulse_2.x, impulse_2.y, 0.0);
    end;
    p.set_value(impulse.x, impulse.y);
    c_a := c_a - (m_a * p);
    a_a -= i_a * (b2_cross(r_a, p) + impulse.z);
    c_b := c_b + (m_b * p);
    a_b += i_b * (b2_cross(r_b, p) + impulse.z);
  end;
  data.positions^[_index_a].c := c_a;
  data.positions^[_index_a].a := a_a;
  data.positions^[_index_b].c := c_b;
  data.positions^[_index_b].a := a_b;
  result := (position_error <= b2_linear_slop) and (angular_error <= b2_angular_slop);
end;

constructor tb2_weld_joint.create_weld_joint(const def: tb2_weld_joint_def);
begin
  inherited create(def);
  _local_anchor_a := def.local_anchor_a;
  _local_anchor_b := def.local_anchor_b;
  _reference_angle := def.reference_angle;
  _frequency_hz := def.frequency_hz;
  _damping_ratio := def.damping_ratio;
  _impulse.set_zero;
end;

function tb2_weld_joint.get_anchor_a: tb2_vec2;
begin
  result := _body_a^.get_world_point(_local_anchor_a);
end;

function tb2_weld_joint.get_anchor_b: tb2_vec2;
begin
  result := _body_b^.get_world_point(_local_anchor_b);
end;

function tb2_weld_joint.get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2;
begin
  result := rcp_dt * b2_vec2(_impulse.x, _impulse.y);
end;

function tb2_weld_joint.get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := rcp_dt * _impulse.z;
end;

function tb2_weld_joint.get_local_anchor_a: tb2_vec2;
begin
  result := _local_anchor_a;
end;

function tb2_weld_joint.get_local_anchor_b: tb2_vec2;
begin
  result := _local_anchor_b;
end;

function tb2_weld_joint.get_reference_angle: tb2_float32;
begin
  result := _reference_angle;
end;

procedure tb2_weld_joint.set_frequency(const hz: tb2_float32);
begin
  _frequency_hz := hz;
end;

function tb2_weld_joint.get_frequency: tb2_float32;
begin
  result := _frequency_hz;
end;

procedure tb2_weld_joint.set_damping_ratio(const ratio: tb2_float32);
begin
  _damping_ratio := ratio;
end;

function tb2_weld_joint.get_damping_ratio: tb2_float32;
begin
  result := _damping_ratio;
end;

procedure tb2_weld_joint.dump;
begin
  //int32 indexA = m_bodyA->m_islandIndex;
  //int32 indexB = m_bodyB->m_islandIndex;
  //
  //b2Log("  b2WeldJointDef jd;\n");
  //b2Log("  jd.bodyA = bodies[%d];\n", indexA);
  //b2Log("  jd.bodyB = bodies[%d];\n", indexB);
  //b2Log("  jd.collideConnected = bool(%d);\n", m_collideConnected);
  //b2Log("  jd.localAnchorA.Set(%.15lef, %.15lef);\n", m_localAnchorA.x, m_localAnchorA.y);
  //b2Log("  jd.localAnchorB.Set(%.15lef, %.15lef);\n", m_localAnchorB.x, m_localAnchorB.y);
  //b2Log("  jd.referenceAngle = %.15lef;\n", m_referenceAngle);
  //b2Log("  jd.frequencyHz = %.15lef;\n", m_frequencyHz);
  //b2Log("  jd.dampingRatio = %.15lef;\n", m_dampingRatio);
  //b2Log("  joints[%d] = m_world->CreateJoint(&jd);\n", m_index);
end;
//tb2_weld_joint END

//tb2_friction_joint_def BEIGN
procedure tb2_friction_joint_def.initialize(const b_a, b_b: pb2_body; const anchor: tb2_vec2);
begin
  body_a := b_a;
  body_b := b_b;
  local_anchor_a := body_a^.get_local_point(anchor);
  local_anchor_b := body_b^.get_local_point(anchor);
end;
//tb2_friction_joint_def END

//tb2_friction_joint BEGIN
procedure tb2_friction_joint.init_velocity_constraints(var data: tb2_solver_data);
  var a_a, w_a, a_b, w_b, m_a, m_b, i_a, i_b: tb2_float32;
  var v_a, v_b, p: tb2_vec2;
  var q_a, q_b: tb2_rot;
  var k: tb2_mat22;
begin
  _index_a := _body_a^._island_index;
  _index_b := _body_b^._island_index;
  _local_center_a := _body_a^._sweep.local_center;
  _local_center_b := _body_b^._sweep.local_center;
  _rcp_mass_a := _body_a^._rcp_mass;
  _rcp_mass_b := _body_b^._rcp_mass;
  _rcp_inertia_a := _body_a^._rcp_inertia;
  _rcp_inertia_b := _body_b^._rcp_inertia;
  a_a := data.positions^[_index_a].a;
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  a_b := data.positions^[_index_b].a;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  q_a.set_value(a_a); q_b.set_value(a_b);
  _r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  _r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  k.ex.x := m_a + m_b + i_a * _r_a.y * _r_a.y + i_b * _r_b.y * _r_b.y;
  k.ex.y := -i_a * _r_a.x * _r_a.y - i_b * _r_b.x * _r_b.y;
  k.ey.x := k.ex.y;
  k.ey.y := m_a + m_b + i_a * _r_a.x * _r_a.x + i_b * _r_b.x * _r_b.x;
  _linear_mass := k.get_inverse;
  _angular_mass := i_a + i_b;
  if _angular_mass > 0.0 then
  _angular_mass := 1.0 / _angular_mass;
  if data.step.warm_starting then
  begin
    _linear_impulse := _linear_impulse * data.step.dt_ratio;
    _angular_impulse *= data.step.dt_ratio;
    p.set_value(_linear_impulse.x, _linear_impulse.y);
    v_a := v_a - (m_a * p);
    w_a -= i_a * (b2_cross(_r_a, p) + _angular_impulse);
    v_b := v_b + (m_b * p);
    w_b += i_b * (b2_cross(_r_b, p) + _angular_impulse);
  end
  else
  begin
    _linear_impulse.set_zero;
    _angular_impulse := 0.0;
  end;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

procedure tb2_friction_joint.solve_velocity_constraints(var data: tb2_solver_data);
  var v_a, v_b, c_dot_1, impulse_1, old_impulse_1: tb2_vec2;
  var w_a, w_b, m_a, m_b, i_a, i_b, h, c_dot, impulse, old_impulse, max_impulse: tb2_float32;
begin
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  h := data.step.dt;

  c_dot := w_b - w_a;
  impulse := -_angular_mass * c_dot;
  old_impulse := _angular_impulse;
  max_impulse := h * _max_torque;
  _angular_impulse := b2_clamp(_angular_impulse + impulse, -max_impulse, max_impulse);
  impulse := _angular_impulse - old_impulse;
  w_a -= i_a * impulse;
  w_b += i_b * impulse;

  c_dot_1 := v_b + b2_cross(w_b, _r_b) - v_a - b2_cross(w_a, _r_a);
  impulse_1 := -b2_mul(_linear_mass, c_dot_1);
  old_impulse_1 := _linear_impulse;
  _linear_impulse := _linear_impulse + impulse;
  max_impulse := h * _max_force;
  if _linear_impulse.len_sq > max_impulse * max_impulse then
  begin
    _linear_impulse.normalize;
    _linear_impulse := _linear_impulse * max_impulse;
  end;
  impulse_1 := _linear_impulse - old_impulse_1;
  v_a := v_a - (m_a * impulse_1);
  w_a -= i_a * b2_cross(_r_a, impulse_1);
  v_b := v_b + (m_b * impulse_1);
  w_b += i_b * b2_cross(_r_b, impulse_1);
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

{$hints off}
function tb2_friction_joint.solve_position_constraints(var data: tb2_solver_data): boolean;
begin
  result := true;
end;
{$hints on}

constructor tb2_friction_joint.create_friction_joint(const def: tb2_friction_joint_def);
begin
  inherited create(def);
  _local_anchor_a := def.local_anchor_a;
  _local_anchor_b := def.local_anchor_b;
  _linear_impulse.set_zero;
  _angular_impulse := 0.0;
  _max_force := def.max_force;
  _max_torque := def.max_torque;
end;

function tb2_friction_joint.get_anchor_a: tb2_vec2;
begin
  result := _body_a^.get_world_point(_local_anchor_a);
end;

function tb2_friction_joint.get_anchor_b: tb2_vec2;
begin
  result := _body_b^.get_world_point(_local_anchor_b);
end;

function tb2_friction_joint.get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2;
begin
  result := rcp_dt * _linear_impulse;
end;

function tb2_friction_joint.get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := rcp_dt * _angular_impulse;
end;

function tb2_friction_joint.get_local_anchor_a: tb2_vec2;
begin
  result := _local_anchor_a;
end;

function tb2_friction_joint.get_local_anchor_b: tb2_vec2;
begin
  result := _local_anchor_b;
end;

procedure tb2_friction_joint.set_max_force(const force: tb2_float32);
begin
  _max_force := force;
end;

function tb2_friction_joint.get_max_force: tb2_float32;
begin
  result := _max_force;
end;

procedure tb2_friction_joint.set_max_torque(const torque: tb2_float32);
begin
   _max_torque := torque;
end;

function tb2_friction_joint.get_max_torque: tb2_float32;
begin
  result := _max_torque;
end;

procedure tb2_friction_joint.dump;
begin
  //int32 indexA = m_bodyA->m_islandIndex;
  //int32 indexB = m_bodyB->m_islandIndex;
  //
  //b2Log("  b2FrictionJointDef jd;\n");
  //b2Log("  jd.bodyA = bodies[%d];\n", indexA);
  //b2Log("  jd.bodyB = bodies[%d];\n", indexB);
  //b2Log("  jd.collideConnected = bool(%d);\n", m_collideConnected);
  //b2Log("  jd.localAnchorA.Set(%.15lef, %.15lef);\n", m_localAnchorA.x, m_localAnchorA.y);
  //b2Log("  jd.localAnchorB.Set(%.15lef, %.15lef);\n", m_localAnchorB.x, m_localAnchorB.y);
  //b2Log("  jd.maxForce = %.15lef;\n", m_maxForce);
  //b2Log("  jd.maxTorque = %.15lef;\n", m_maxTorque);
  //b2Log("  joints[%d] = m_world->CreateJoint(&jd);\n", m_index);
end;
//tb2_friction_joint END

//tb2_rope_joint BEGIN
procedure tb2_rope_joint.init_velocity_constraints(var data: tb2_solver_data);
  var c_a, v_a, c_b, v_b, p: tb2_vec2;
  var a_a, w_a, a_b, w_b, c, rcp_mass, cr_a, cr_b: tb2_float32;
  var q_a, q_b: tb2_rot;
begin
  _index_a := _body_a^._island_index;
  _index_b := _body_b^._island_index;
  _local_center_a := _body_a^._sweep.local_center;
  _local_center_b := _body_b^._sweep.local_center;
  _rcp_mass_a := _body_a^._rcp_mass;
  _rcp_mass_b := _body_b^._rcp_mass;
  _rcp_inertia_a := _body_a^._rcp_inertia;
  _rcp_inertia_b := _body_b^._rcp_inertia;
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  q_a.set_value(a_a); q_b.set_value(a_b);
  _r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  _r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  _u := c_b + _r_b - c_a - _r_a;
  _length := _u.len;
  c := _length - _max_length;
  if c > 0.0 then
  _state := b2_ls_at_upper_limit
  else
  _state := b2_ls_inactive_limit;
  if _length > b2_linear_slop then
  _u := _u * (1.0 / _length)
  else
  begin
    _u.set_zero;
    _mass := 0.0;
    _impulse := 0.0;
    exit;
  end;
  cr_a := b2_cross(_r_a, _u);
  cr_b := b2_cross(_r_b, _u);
  rcp_mass := _rcp_mass_a + _rcp_inertia_a * cr_a * cr_a + _rcp_mass_b + _rcp_inertia_b * cr_b * cr_b;
  if rcp_mass <> 0.0 then _mass := 1.0 / rcp_mass else _mass := 0.0;
  if data.step.warm_starting then
  begin
    _impulse *= data.step.dt_ratio;
    p := _impulse * _u;
    v_a := v_a - (_rcp_mass_a * p);
    w_a -= _rcp_inertia_a * b2_cross(_r_a, p);
    v_b := v_b + (_rcp_mass_b * p);
    w_b += _rcp_inertia_b * b2_cross(_r_b, p);
  end
  else
  _impulse := 0.0;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

procedure tb2_rope_joint.solve_velocity_constraints(var data: tb2_solver_data);
  var v_a, v_b, vp_a, vp_b, p: tb2_vec2;
  var w_a, w_b, c, c_dot, impulse, old_impulse: tb2_float32;
begin
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  vp_a := v_a + b2_cross(w_a, _r_a);
  vp_b := v_b + b2_cross(w_b, _r_b);
  c := _length - _max_length;
  c_dot := b2_dot(_u, vp_b - vp_a);
  if c < 0.0 then c_dot += data.step.rcp_dt * c;
  impulse := -_mass * c_dot;
  old_impulse := _impulse;
  _impulse := b2_min(0.0, _impulse + impulse);
  impulse := _impulse - old_impulse;
  p := impulse * _u;
  v_a := v_a - (_rcp_mass_a * p);
  w_a -= _rcp_inertia_a * b2_cross(_r_a, p);
  v_b := v_b + (_rcp_mass_b * p);
  w_b += _rcp_inertia_b * b2_cross(_r_b, p);
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

function tb2_rope_joint.solve_position_constraints(var data: tb2_solver_data): boolean;
  var c_a, c_b, r_a, r_b, u, p: tb2_vec2;
  var a_a, a_b, len, c, impulse: tb2_float32;
  var q_a, q_b: tb2_rot;
begin
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  q_a.set_value(a_a); q_b.set_value(a_b);
  r_a := b2_mul(q_a, _local_anchor_a - _local_center_a);
  r_b := b2_mul(q_b, _local_anchor_b - _local_center_b);
  u := c_b + r_b - c_a - r_a;
  len := u.normalize;
  c := len - _max_length;
  c := b2_clamp(c, 0.0, b2_max_linear_correction);
  impulse := -_mass * c;
  p := impulse * u;
  c_a := c_a - (_rcp_mass_a * p);
  a_a -= _rcp_inertia_a * b2_cross(r_a, p);
  c_b := c_b + (_rcp_mass_b * p);
  a_b += _rcp_inertia_b * b2_cross(r_b, p);
  data.positions^[_index_a].c := c_a;
  data.positions^[_index_a].a := a_a;
  data.positions^[_index_b].c := c_b;
  data.positions^[_index_b].a := a_b;
  result := len - _max_length < b2_linear_slop;
end;

constructor tb2_rope_joint.create_rope_joint(const def: tb2_rope_joint_def);
begin
  inherited create(def);
  _local_anchor_a := def.local_anchor_a;
  _local_anchor_b := def.local_anchor_b;
  _max_length := def.max_length;
  _mass := 0.0;
  _impulse := 0.0;
  _state := b2_ls_inactive_limit;
  _length := 0.0;
end;

function tb2_rope_joint.get_anchor_a: tb2_vec2;
begin
  result := _body_a^.get_world_point(_local_anchor_a);
end;

function tb2_rope_joint.get_anchor_b: tb2_vec2;
begin
  result := _body_b^.get_world_point(_local_anchor_b);
end;

function tb2_rope_joint.get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2;
begin
  result := (rcp_dt * _impulse) * _u;
end;

{$hints off}
function tb2_rope_joint.get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := 0;
end;
{$hints on}

function tb2_rope_joint.get_local_anchor_a: tb2_vec2;
begin
  result := _local_anchor_a;
end;

function tb2_rope_joint.get_local_anchor_b: tb2_vec2;
begin
  result := _local_anchor_b;
end;

procedure tb2_rope_joint.set_max_length(const len: tb2_float32);
begin
  _max_length := len;
end;

function tb2_rope_joint.get_max_length: tb2_float32;
begin
  result := _max_length;
end;

function tb2_rope_joint.get_limit_state: tb2_limit_state;
begin
  result := _state;
end;

procedure tb2_rope_joint.dump;
begin
  //int32 indexA = m_bodyA->m_islandIndex;
  //int32 indexB = m_bodyB->m_islandIndex;
  //
  //b2Log("  b2RopeJointDef jd;\n");
  //b2Log("  jd.bodyA = bodies[%d];\n", indexA);
  //b2Log("  jd.bodyB = bodies[%d];\n", indexB);
  //b2Log("  jd.collideConnected = bool(%d);\n", m_collideConnected);
  //b2Log("  jd.localAnchorA.Set(%.15lef, %.15lef);\n", m_localAnchorA.x, m_localAnchorA.y);
  //b2Log("  jd.localAnchorB.Set(%.15lef, %.15lef);\n", m_localAnchorB.x, m_localAnchorB.y);
  //b2Log("  jd.maxLength = %.15lef;\n", m_maxLength);
  //b2Log("  joints[%d] = m_world->CreateJoint(&jd);\n", m_index);
end;
//tb2_rope_joint END

//tb2_motor_joint_def BEGIN
procedure tb2_motor_joint_def.initialize(const b_a, b_b: pb2_body);
begin
  body_a := b_a;
  body_b := b_b;
  linear_offset := body_a^.get_local_point(body_b^.get_position);
  angular_offset := body_b^.get_angle - body_a^.get_angle;
end;
//tb2_motor_joint_def END

//tb2_motor_joint BEGIN
procedure tb2_motor_joint.init_velocity_constraints(var data: tb2_solver_data);
  var c_a, v_a, c_b, v_b, p: tb2_vec2;
  var a_a, w_a, a_b, w_b, m_a, i_a, m_b, i_b: tb2_float32;
  var q_a, q_b: tb2_rot;
  var k: tb2_mat22;
begin
  _index_a := _body_a^._island_index;
  _index_b := _body_b^._island_index;
  _local_center_a := _body_a^._sweep.local_center;
  _local_center_b := _body_b^._sweep.local_center;
  _rcp_mass_a := _body_a^._rcp_mass;
  _rcp_mass_b := _body_b^._rcp_mass;
  _rcp_inertia_a := _body_a^._rcp_inertia;
  _rcp_inertia_b := _body_b^._rcp_inertia;
  c_a := data.positions^[_index_a].c;
  a_a := data.positions^[_index_a].a;
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  c_b := data.positions^[_index_b].c;
  a_b := data.positions^[_index_b].a;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  q_a.set_value(a_a); q_b.set_value(a_b);
  _r_a := b2_mul(q_a, -_local_center_a);
  _r_b := b2_mul(q_b, -_local_center_b);
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  k.ex.x := m_a + m_b + i_a * _r_a.y * _r_a.y + i_b * _r_b.y * _r_b.y;
  k.ex.y := -i_a * _r_a.x * _r_a.y - i_b * _r_b.x * _r_b.y;
  k.ey.x := k.ex.y;
  k.ey.y := m_a + m_b + i_a * _r_a.x * _r_a.x + i_b * _r_b.x * _r_b.x;
  _linear_mass := k.get_inverse;
  _angular_mass := i_a + i_b;
  if _angular_mass > 0.0 then _angular_mass := 1.0 / _angular_mass;
  _linear_error := c_b + _r_b - c_a - _r_a - b2_mul(q_a, _linear_offset);
  _angular_error := a_b - a_a - _angular_offset;
  if data.step.warm_starting then
  begin
    _linear_impulse := _linear_impulse * data.step.dt_ratio;
    _angular_impulse *= data.step.dt_ratio;
    p.set_value(_linear_impulse.x, _linear_impulse.y);
    v_a := v_a - (m_a * p);
    w_a -= i_a * (b2_cross(_r_a, p) + _angular_impulse);
    v_b := v_b + (m_b * p);
    w_b += i_b * (b2_cross(_r_b, p) + _angular_impulse);
  end
  else
  begin
    _linear_impulse.set_zero;
    _angular_impulse := 0.0;
  end;
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

procedure tb2_motor_joint.solve_velocity_constraints(var data: tb2_solver_data);
  var v_a, v_b, c_dot_1, impulse_1, old_impulse_1: tb2_vec2;
  var w_a, w_b, m_a, i_a, m_b, i_b, h, rcp_h, c_dot, impulse, old_impulse, max_impulse: tb2_float32;
begin
  v_a := data.velocities^[_index_a].v;
  w_a := data.velocities^[_index_a].w;
  v_b := data.velocities^[_index_b].v;
  w_b := data.velocities^[_index_b].w;
  m_a := _rcp_mass_a; m_b := _rcp_mass_b;
  i_a := _rcp_inertia_a; i_b := _rcp_inertia_b;
  h := data.step.dt;
  rcp_h := data.step.rcp_dt;
  c_dot := w_b - w_a + rcp_h * _correction_factor * _angular_error;
  impulse := -_angular_mass * c_dot;
  old_impulse := _angular_impulse;
  max_impulse := h * _max_torque;
  _angular_impulse := b2_clamp(_angular_impulse + impulse, -max_impulse, max_impulse);
  impulse := _angular_impulse - old_impulse;
  w_a -= i_a * impulse;
  w_b += i_b * impulse;
  c_dot_1 := v_b + b2_cross(w_b, _r_b) - v_a - b2_cross(w_a, _r_a) + rcp_h * _correction_factor * _linear_error;
  impulse_1 := -b2_mul(_linear_mass, c_dot_1);
  old_impulse_1 := _linear_impulse;
  _linear_impulse := _linear_impulse + impulse;
  max_impulse := h * _max_force;
  if _linear_impulse.len_sq > max_impulse * max_impulse then
  begin
    _linear_impulse.normalize;
    _linear_impulse := _linear_impulse * max_impulse;
  end;
  impulse_1 := _linear_impulse - old_impulse_1;
  v_a := v_a - (m_a * impulse_1);
  w_a -= i_a * b2_cross(_r_a, impulse_1);
  v_b += m_b * impulse_1;
  w_b += i_b * b2_cross(_r_b, impulse_1);
  data.velocities^[_index_a].v := v_a;
  data.velocities^[_index_a].w := w_a;
  data.velocities^[_index_b].v := v_b;
  data.velocities^[_index_b].w := w_b;
end;

{$hints off}
function tb2_motor_joint.solve_position_constraints(var data: tb2_solver_data): boolean;
begin
  result := true;
end;
{$hints on}

constructor tb2_motor_joint.create_motor_joint(const def: tb2_motor_joint_def);
begin
  inherited create(def);
  _linear_offset := def.linear_offset;
  _angular_offset := def.angular_offset;
  _linear_impulse.set_zero;
  _angular_impulse := 0.0;
  _max_force := def.max_force;
  _max_torque := def.max_torque;
  _correction_factor := def.correction_factor;
end;

function tb2_motor_joint.get_anchor_a: tb2_vec2;
begin
  result := _body_a^.get_position;
end;

function tb2_motor_joint.get_anchor_b: tb2_vec2;
begin
  result := _body_b^.get_position;
end;

function tb2_motor_joint.get_reaction_force(const rcp_dt: tb2_float32): tb2_vec2;
begin
  result := rcp_dt * _linear_impulse;
end;

function tb2_motor_joint.get_reaction_torque(const rcp_dt: tb2_float32): tb2_float32;
begin
  result := rcp_dt * _angular_impulse;
end;

procedure tb2_motor_joint.set_linear_offset(const linear_offset: tb2_vec2);
begin
  if (linear_offset.x <> _linear_offset.x) or (linear_offset.y <> _linear_offset.y) then
  begin
    _body_a^.set_awake(true);
    _body_b^.set_awake(true);
    _linear_offset := linear_offset;
  end;
end;

function tb2_motor_joint.get_linear_offset: tb2_vec2;
begin
  result := _linear_offset;
end;

procedure tb2_motor_joint.set_angular_offset(const angular_offset: tb2_float32);
begin
  if angular_offset <> _angular_offset then
  begin
    _body_a^.set_awake(true);
    _body_b^.set_awake(true);
    _angular_offset := angular_offset;
  end;
end;

function tb2_motor_joint.get_angular_offset: tb2_float32;
begin
  result := _angular_offset;
end;

procedure tb2_motor_joint.set_max_force(const force: tb2_float32);
begin
  _max_force := force;
end;

function tb2_motor_joint.get_max_force: tb2_float32;
begin
  result := _max_force;
end;

procedure tb2_motor_joint.set_max_torque(const torque: tb2_float32);
begin
  _max_torque := torque;
end;

function tb2_motor_joint.get_max_torque: tb2_float32;
begin
  result := _max_torque;
end;

procedure tb2_motor_joint.set_correction_factor(const factor: tb2_float32);
begin
  _correction_factor := factor;
end;

function tb2_motor_joint.get_correction_factor: tb2_float32;
begin
  result := _correction_factor;
end;

procedure tb2_motor_joint.dump;
begin
  //int32 indexA = m_bodyA->m_islandIndex;
  //int32 indexB = m_bodyB->m_islandIndex;
  //
  //b2Log("  b2MotorJointDef jd;\n");
  //b2Log("  jd.bodyA = bodies[%d];\n", indexA);
  //b2Log("  jd.bodyB = bodies[%d];\n", indexB);
  //b2Log("  jd.collideConnected = bool(%d);\n", m_collideConnected);
  //b2Log("  jd.linearOffset.Set(%.15lef, %.15lef);\n", m_linearOffset.x, m_linearOffset.y);
  //b2Log("  jd.angularOffset = %.15lef;\n", m_angularOffset);
  //b2Log("  jd.maxForce = %.15lef;\n", m_maxForce);
  //b2Log("  jd.maxTorque = %.15lef;\n", m_maxTorque);
  //b2Log("  jd.correctionFactor = %.15lef;\n", m_correctionFactor);
  //b2Log("  joints[%d] = m_world->CreateJoint(&jd);\n", m_index);
end;
//tb2_motor_joint END

//tb2_world BEGIN
function tb2_world.tb2_world_query_wrapper.query_callback(const proxy_id: tb2_int32): boolean;
begin
  result := callback(pb2_fixture_proxy(broad_phase^.get_user_data(proxy_id))^.fixture);
end;

function tb2_world.tb2_world_ray_cast_wrapper.ray_cast_callback(const input: tb2_ray_cast_input; const proxy_id: tb2_int32): tb2_float32;
  var user_data: tb2_ptr;
  var proxy: pb2_fixture_proxy;
  var fixture: pb2_fixture;
  var index: tb2_int32;
  var output: tb2_ray_cast_output;
  var hit: boolean;
  var fraction: tb2_float32;
  var point: tb2_vec2;
begin
  user_data := broad_phase^.get_user_data(proxy_id);
  proxy := pb2_fixture_proxy(user_data);
  fixture := proxy^.fixture;
  index := proxy^.child_index;
  {$hints off}
  hit := fixture^.ray_cast(output, input, index);
  {$hints on}
  if hit then
  begin
    fraction := output.fraction;
    point := (1.0 - fraction) * input.p1 + fraction * input.p2;
    result := callback(fixture, point, output.normal, fraction);
  end
  else
  result := input.max_fraction;
end;

procedure tb2_world.solve(const step: tb2_time_step);
  var island: tb2_island;
  var b, seed, other: pb2_body;
  var c: pb2_contact;
  var j: pb2_joint;
  var stack_size, stack_count, i: tb2_int32;
  var stack: ppb2_body_arr;
  var ce: pb2_contact_edge;
  var je: pb2_joint_edge;
  var profile: tb2_profile;
  var timer: tb2_timer;
begin
  timer.create;
  _profile.solve_init := 0.0;
  _profile.solve_velocity := 0.0;
  _profile.solve_position := 0.0;
  island.create(
    _body_count,
    _contact_manager.contact_count,
    _joint_count,
    @_stack_allocator,
    _contact_manager.contact_listener
  );
  b := _body_list;
  while b <> nil do
  begin
    b^._flags -= [b2_bf_island_flag];
    b := b^._next;
  end;
  c := _contact_manager.contact_list;
  while c <> nil do
  begin
    c^._flags -= [b2_cf_island_flag];
    c := c^._next;
  end;
  j := _joint_list;
  while j <> nil do
  begin
    j^._island_flag := false;
    j := j^._next;
  end;
  stack_size := _body_count;
  stack := ppb2_body_arr(_stack_allocator.alloc(stack_size * sizeof(pb2_body)));
  seed := _body_list;
  timer.reset;
  while seed <> nil do
  begin
    if b2_bf_island_flag in seed^._flags then
    begin
      seed := seed^._next;
      continue;
    end;
    if (not seed^.is_awake) or (not seed^.is_active) then
    begin
      seed := seed^._next;
      continue;
    end;
    if seed^.get_type = b2_static_body then
    begin
      seed := seed^._next;
      continue;
    end;
    island.clear;
    stack_count := 0;
    stack^[stack_count] := seed;
    inc(stack_count);
    seed^._flags += [b2_bf_island_flag];
    while stack_count > 0 do
    begin
      dec(stack_count);
      b := stack^[stack_count];
      island.add(b);
      b^.set_awake(true);
      if b^.get_type = b2_static_body then continue;
      ce := b^._contact_list;
      while ce <> nil do
      begin
	c := ce^.contact;
	if b2_cf_island_flag in c^._flags then
	begin
          ce := ce^.next;
	  continue;
	end;
	if (not c^.is_enabled) or (not c^.is_touching) then
	begin
          ce := ce^.next;
	  continue;
	end;
	if (c^._fixture_a^._is_sensor) or (c^._fixture_b^._is_sensor) then
	begin
          ce := ce^.next;
	  continue;
	end;
	island.add(c);
	c^._flags += [b2_cf_island_flag];
	other := ce^.other;
	if b2_bf_island_flag in other^._flags then
	begin
          ce := ce^.next;
	  continue;
	end;
	stack^[stack_count] := other;
        inc(stack_count);
	other^._flags += [b2_bf_island_flag];
        ce := ce^.next;
      end;
      je := b^._joint_list;
      while je <> nil do
      begin
	if je^.joint^._island_flag then
	begin
          je := je^.next;
	  continue;
	end;
	other := je^.other;
	if not other^.is_active then
	begin
          je := je^.next;
	  continue;
	end;
	island.add(je^.joint);
	je^.joint^._island_flag := true;
	if b2_bf_island_flag in other^._flags then
	begin
          je := je^.next;
	  continue;
	end;
	stack^[stack_count] := other;
        inc(stack_count);
	other^._flags += [b2_bf_island_flag];
        je := je^.next;
      end;
    end;
    island.solve(@profile, step, _gravity, _allow_sleep);
    _profile.solve_init += profile.solve_init;
    _profile.solve_velocity += profile.solve_velocity;
    _profile.solve_position += profile.solve_position;
    for i := 0 to island._body_count - 1 do
    begin
      b := island._bodies^[i];
      if b^.get_type = b2_static_body then
      b^._flags -= [b2_bf_island_flag];
    end;
    seed := seed^._next;
  end;
  _stack_allocator.free(stack);
  b := _body_list;
  while b <> nil do
  begin
    if not (b2_bf_island_flag in b^._flags) then
    begin
      b := b^.get_next;
      continue;
    end;
    if b^.get_type = b2_static_body then
    begin
      b := b^.get_next;
      continue;
    end;
    b^.synchronize_fixtures;
    b := b^.get_next;
  end;
  _contact_manager.find_new_contacts;
  _profile.broad_phase := timer.get_milliseconds;
  island.destroy;
end;

procedure tb2_world.solve_toi(const step: tb2_time_step);
  var island: tb2_island;
  var b, b_a, b_b, other: pb2_body;
  var c, min_contact: pb2_contact;
  var min_alpha, alpha, alpha0, beta: tb2_float32;
  var f_a, f_b: pb2_fixture;
  var type_a, type_b: tb2_body_type;
  var active_a, active_b, collide_a, collide_b: boolean;
  var index_a, index_b, i: tb2_int32;
  var input: tb2_toi_input;
  var output: tb2_toi_output;
  var backup1, backup2, backup: tb2_sweep;
  var bodies: array[0..1] of pb2_body;
  var ce: pb2_contact_edge;
  var sub_step: tb2_time_step;
begin
  island.create(2 * b2_max_toi_contacts, b2_max_toi_contacts, 0, @_stack_allocator, _contact_manager.contact_listener);
  if _step_complete then
  begin
    b := _body_list;
    while b <> nil do
    begin
      b^._flags -= [b2_bf_island_flag];
      b^._sweep.alpha0 := 0.0;
      b := b^._next;
    end;
    c := _contact_manager.contact_list;
    while c <> nil do
    begin
      c^._flags -= [b2_cf_toi_flag, b2_cf_island_flag];
      c^._toi_count := 0;
      c^._toi := 1.0;
      c := c^._next;
    end;
  end;
  while true do
  begin
    min_contact := nil;
    min_alpha := 1.0;
    c := _contact_manager.contact_list;
    while c <> nil do
    begin
      if not c^.is_enabled then
      begin
        c := c^._next;
        continue;
      end;
      if c^._toi_count > b2_max_sub_steps then
      begin
        c := c^._next;
        continue;
      end;
      alpha := 1.0;
      if b2_cf_toi_flag in c^._flags then
      begin
	alpha := c^._toi;
      end
      else
      begin
	f_a := c^.get_fixture_a;
	f_b := c^.get_fixture_b;
	if (f_a^.is_sensor) or (f_b^.is_sensor) then
	begin
          c := c^._next;
          continue;
        end;
	b_a := f_a^.get_body;
	b_b := f_b^.get_body;
	type_a := b_a^._type;
	type_b := b_b^._type;
	active_a := b_a^.is_awake and (type_a <> b2_static_body);
	active_b := b_b^.is_awake and (type_b <> b2_static_body);
	if (not active_a) and (not active_b) then
	begin
          c := c^._next;
          continue;
        end;
	collide_a := b_a^.is_bullet or (type_a <> b2_dynamic_body);
	collide_b := b_b^.is_bullet or (type_b <> b2_dynamic_body);
	if (not collide_a) and (not collide_b) then
	begin
          c := c^._next;
          continue;
        end;
	alpha0 := b_a^._sweep.alpha0;
	if b_a^._sweep.alpha0 < b_b^._sweep.alpha0 then
	begin
	  alpha0 := b_b^._sweep.alpha0;
	  b_a^._sweep.advance(alpha0);
	end
	else if b_b^._sweep.alpha0 < b_a^._sweep.alpha0 then
	begin
	  alpha0 := b_a^._sweep.alpha0;
	  b_b^._sweep.advance(alpha0);
	end;
	index_a := c^.get_child_index_a;
	index_b := c^.get_child_index_b;
        input.proxy_a.create;
	input.proxy_a.set_shape(f_a^.get_shape, index_a);
	input.proxy_b.set_shape(f_b^.get_shape, index_b);
	input.sweep_a := b_a^._sweep;
	input.sweep_b := b_b^._sweep;
	input.t_max := 1.0;
        {$hints off}
	b2_time_of_impact(output, input);
        {$hints on}
	beta := output.t;
	if output.state = b2_tois_touching then
	alpha := b2_min(alpha0 + (1.0 - alpha0) * beta, 1.0)
	else
	alpha := 1.0;
	c^._toi := alpha;
	c^._flags += [b2_cf_toi_flag];
      end;
      if alpha < min_alpha then
      begin
	min_contact := c;
	min_alpha := alpha;
      end;
      c := c^._next;
    end;
    if (min_contact = nil) or (1.0 - 10.0 * b2_epsilon < min_alpha) then
    begin
      _step_complete := true;
      break;
    end;
    f_a := min_contact^.get_fixture_a;
    f_b := min_contact^.get_fixture_b;
    b_a := f_a^.get_body;
    b_b := f_b^.get_body;
    backup1 := b_a^._sweep;
    backup2 := b_b^._sweep;
    b_a^.advance(min_alpha);
    b_b^.advance(min_alpha);
    min_contact^.update(_contact_manager.contact_listener);
    min_contact^._flags -= [b2_cf_toi_flag];
    inc(min_contact^._toi_count);
    if (not min_contact^.is_enabled) or (not min_contact^.is_touching) then
    begin
      min_contact^.set_enabled(false);
      b_a^._sweep := backup1;
      b_b^._sweep := backup2;
      b_a^.synchronize_transform;
      b_b^.synchronize_transform;
      continue;
    end;
    b_a^.set_awake(true);
    b_b^.set_awake(true);
    island.clear;
    island.add(b_a);
    island.add(b_b);
    island.add(min_contact);
    b_a^._flags += [b2_bf_island_flag];
    b_b^._flags += [b2_bf_island_flag];
    min_contact^._flags += [b2_cf_island_flag];
    bodies[0] := b_a; bodies[1] := b_b;
    for i := 0 to 1 do
    begin
      b := bodies[i];
      if b^._type = b2_dynamic_body then
      begin
        ce := b^._contact_list;
        while ce <> nil do
	begin
	  if island._body_count = island._body_capacity then break;
	  if island._contact_count = island._contact_capacity then break;
	  c := ce^.contact;
	  if b2_cf_island_flag in c^._flags then
	  begin
            ce := ce^.next;
	    continue;
	  end;
	  other := ce^.other;
	  if (other^._type = b2_dynamic_body) and (not b^.is_bullet and  not other^.is_bullet) then
	  begin
            ce := ce^.next;
	    continue;
	  end;
	  if (c^._fixture_a^._is_sensor) or (c^._fixture_b^._is_sensor) then
	  begin
            ce := ce^.next;
	    continue;
	  end;
	  backup := other^._sweep;
	  if not (b2_bf_island_flag in other^._flags) then
	  other^.advance(min_alpha);
	  c^.update(_contact_manager.contact_listener);
	  if not c^.is_enabled then
	  begin
	    other^._sweep := backup;
	    other^.synchronize_transform;
            ce := ce^.next;
	    continue;
	  end;
	  if not c^.is_touching then
	  begin
	    other^._sweep := backup;
	    other^.synchronize_transform;
            ce := ce^.next;
	    continue;
	  end;
	  c^._flags += [b2_cf_island_flag];
	  island.add(c);
	  if b2_bf_island_flag in other^._flags then
	  begin
            ce := ce^.next;
	    continue;
	  end;
	  other^._flags += [b2_bf_island_flag];
	  if other^._type <> b2_static_body then
	  other^.set_awake(true);
	  island.add(other);
          ce := ce^.next;
	end;
      end;
    end;
    sub_step.dt := (1.0 - min_alpha) * step.dt;
    sub_step.rcp_dt := 1.0 / sub_step.dt;
    sub_step.dt_ratio := 1.0;
    sub_step.position_iterations := 20;
    sub_step.velocity_iterations := step.velocity_iterations;
    sub_step.warm_starting := false;
    island.solve_toi(sub_step, b_a^._island_index, b_b^._island_index);
    for i := 0 to island._body_count - 1 do
    begin
      b := island._bodies^[i];
      b^._flags -= [b2_bf_island_flag];
      if b^._type <> b2_dynamic_body then continue;
      b^.synchronize_fixtures;
      ce := b^._contact_list;
      while ce <> nil do
      begin
        ce^.contact^._flags -= [b2_cf_toi_flag, b2_cf_island_flag];
        ce := ce^.next
      end;
    end;
    _contact_manager.find_new_contacts;
    if _sub_stepping then
    begin
      _step_complete := false;
      break;
    end;
  end;
  island.destroy;
end;

procedure tb2_world.draw_joint(const joint: pb2_joint);
  var body_a, body_b: pb2_body;
  var xf1, xf2: tb2_transform;
  var x1, x2, p1, p2: tb2_vec2;
  var color: tb2_color;
  var scope_pulley: record
    pulley: pb2_pulley_joint;
    s1, s2: tb2_vec2;
  end;
begin
  body_a := joint^.get_body_a;
  body_b := joint^.get_body_b;
  xf1 := body_a^.get_transform;
  xf2 := body_b^.get_transform;
  x1 := xf1.p;
  x2 := xf2.p;
  p1 := joint^.get_anchor_a;
  p2 := joint^.get_anchor_b;
  color.set_value(0.5, 0.8, 0.8);
  case joint^.get_type of
    b2_jt_distance_joint: _debug_draw.draw_segment(p1, p2, color);
    b2_jt_pulley_joint:
    with scope_pulley do
    begin
      pulley := pb2_pulley_joint(joint);
      s1 := pulley^.get_ground_anchor_a;
      s2 := pulley^.get_ground_anchor_b;
      _debug_draw.draw_segment(s1, p1, color);
      _debug_draw.draw_segment(s2, p2, color);
      _debug_draw.draw_segment(s1, s2, color);
    end;
    b2_jt_mouse_joint: ;
    else
    begin
      _debug_draw.draw_segment(x1, p1, color);
      _debug_draw.draw_segment(p1, p2, color);
      _debug_draw.draw_segment(x2, p2, color);
    end;
  end;
end;

procedure tb2_world.draw_shape(const fixture: pb2_fixture; const xf: tb2_transform; const color: tb2_color);
  var i: tb2_int32;
  var scope_circle: record
    circle: pb2_circle_shape;
    center: tb2_vec2;
    radius: tb2_float32;
    axis: tb2_vec2;
  end;
  var scope_edge: record
    edge: pb2_edge_shape;
    v1, v2: tb2_vec2;
  end;
  var scope_chain: record
    chain: pb2_chain_shape;
    count: tb2_int32;
    vertices: pb2_vec2_arr;
    v1, v2: tb2_vec2;
  end;
  var scope_polygon: record
    poly: pb2_polygon_shape;
    vertex_count: tb2_int32;
    vertices: array[0..b2_max_polygon_vertices - 1] of tb2_vec2;
  end;
begin
  case fixture^.get_type of
    b2_st_circle:
    with scope_circle do
    begin
      circle := pb2_circle_shape(fixture^.get_shape);
      center := b2_mul(xf, circle^.center);
      radius := circle^.radius;
      axis := b2_mul(xf.q, b2_vec2(1.0, 0.0));
      _debug_draw.draw_solid_circle(center, radius, axis, color);
    end;
    b2_st_edge:
    with scope_edge do
    begin
      edge := pb2_edge_shape(fixture^.get_shape);
      v1 := b2_mul(xf, edge^.vertex1);
      v2 := b2_mul(xf, edge^.vertex2);
      _debug_draw.draw_segment(v1, v2, color);
    end;
    b2_st_chain:
    with scope_chain do
    begin
      chain := pb2_chain_shape(fixture^.get_shape);
      count := chain^.count;
      vertices := chain^.vertices;
      v1 := b2_mul(xf, vertices^[0]);
      for i := 1 to count - 1 do
      begin
	v2 := b2_mul(xf, vertices^[i]);
	_debug_draw.draw_segment(v1, v2, color);
	_debug_draw.draw_circle(v1, 0.05, color);
	v1 := v2;
      end;
    end;
    b2_st_polygon:
    with scope_polygon do
    begin
      poly := pb2_polygon_shape(fixture^.get_shape);
      vertex_count := poly^.count;
      for i := 0 to vertex_count - 1 do
      vertices[i] := b2_mul(xf, poly^.vertices[i]);
      _debug_draw.draw_solid_polygon(vertices, vertex_count, color);
    end;
  end;
end;

constructor tb2_world.create(const gravity: tb2_vec2);
begin
  _block_allocator.create;
  _stack_allocator.create;
  _contact_manager.create;
  _destruction_listener := nil;
  _debug_draw := nil;
  _body_list := nil;
  _joint_list := nil;
  _body_count := 0;
  _joint_count := 0;
  _warm_starting := true;
  _continuous_physics := true;
  _sub_stepping := false;
  _step_complete := true;
  _allow_sleep := true;
  _gravity := gravity;
  _flags := [b2_wf_clear_forces];
  _rcp_dt0 := 0.0;
  _contact_manager.allocator := @_block_allocator;
  fillchar(_profile, sizeof(_profile), 0);
end;

destructor tb2_world.destroy;
begin
  clear;
  _contact_manager.destroy;
  _stack_allocator.destroy;
  _block_allocator.destroy;
end;

procedure tb2_world.clear;
  var b, b_next: pb2_body;
  var f, f_next: pb2_fixture;
  var j, j_next: pb2_joint;
begin
  b := _body_list;
  while b <> nil do
  begin
    b_next := b^._next;
    f := b^._fixture_list;
    while f <> nil do
    begin
      f_next := f^._next;
      f^._proxy_count := 0;
      f^.destroy_fixture(@_block_allocator);
      f := f_next;
    end;
    b := b_next;
  end;
  j := _joint_list;
  while j <> nil do
  begin
    j_next := j^._next;
    destroy_joint(j);
    j := j_next;
  end;
  _body_list := nil;
  _joint_list := nil;
  _destruction_listener := nil;
end;

procedure tb2_world.set_destruction_listener(const listener: tb2_destruction_listener);
begin
  _destruction_listener := listener;
end;

procedure tb2_world.set_contact_filter(const filter: tb2_contact_filter);
begin
  _contact_manager.contact_filter := filter;
end;

procedure tb2_world.set_contact_listener(const listener: tb2_contact_listener);
begin
  _contact_manager.contact_listener := listener;
end;

procedure tb2_world.set_debug_draw(const debug_draw: tb2_draw);
begin
  _debug_draw := debug_draw;
end;

function tb2_world.create_body(const def: tb2_body_def): pb2_body;
begin
  if is_locked then exit(nil);
  result := pb2_body(_block_allocator.alloc(sizeof(tb2_body)));
  result^.create(def, @self);
  result^._prev := nil;
  result^._next := _body_list;
  if _body_list <> nil then
  _body_list^._prev := result;
  _body_list := result;
  inc(_body_count);
end;

procedure tb2_world.destroy_body(var body: pb2_body);
  var je, je0: pb2_joint_edge;
  var ce, ce0: pb2_contact_edge;
  var f, f0: pb2_fixture;
begin
  if is_locked then exit;
  je := body^._joint_list;
  while je <> nil do
  begin
    je0 := je;
    je := je^.next;
    if _destruction_listener <> nil then
    _destruction_listener.say_goodbye(je0^.joint);
    destroy_joint(je0^.joint);
    body^._joint_list := je;
  end;
  body^._joint_list := nil;
  ce := body^._contact_list;
  while ce <> nil do
  begin
    ce0 := ce;
    ce := ce^.next;
    _contact_manager.destroy_contact(ce0^.contact);
  end;
  body^._contact_list := nil;
  f := body^._fixture_list;
  while f <> nil do
  begin
    f0 := f;
    f := f^._next;
    if _destruction_listener <> nil then
    _destruction_listener.say_goodbye(f0);
    f0^.destroy_proxies(@_contact_manager.broad_phase);
    f0^.destroy_fixture(@_block_allocator);
    _block_allocator.free(f0, sizeof(tb2_fixture));
    body^._fixture_list := f;
    dec(body^._fixture_count);
  end;
  body^._fixture_list := nil;
  body^._fixture_count := 0;
  if body^._prev <> nil then
  body^._prev^._next := body^._next;
  if body^._next <> nil then
  body^._next^._prev := body^._prev;
  if body = _body_list then
  _body_list := body^._next;
  dec(_body_count);
  body^.destroy;
  _block_allocator.free(body, sizeof(tb2_body));
end;

function tb2_world.create_joint(const def: tb2_joint_def): pb2_joint;
  var body_a, body_b: pb2_body;
  var edge: pb2_contact_edge;
begin
  if is_locked then exit(nil);
  result := tb2_joint.create_joint(def, @_block_allocator);
  result^._prev := nil;
  result^._next := _joint_list;
  if _joint_list <> nil then
  _joint_list^._prev := result;
  _joint_list := result;
  inc(_joint_count);
  result^._edge_a.joint := result;
  result^._edge_a.other := result^._body_b;
  result^._edge_a.prev := nil;
  result^._edge_a.next := result^._body_a^._joint_list;
  if result^._body_a^._joint_list <> nil then result^._body_a^._joint_list^.prev := @result^._edge_a;
  result^._body_a^._joint_list := @result^._edge_a;
  result^._edge_b.joint := result;
  result^._edge_b.other := result^._body_a;
  result^._edge_b.prev := nil;
  result^._edge_b.next := result^._body_b^._joint_list;
  if result^._body_b^._joint_list <> nil then result^._body_b^._joint_list^.prev := @result^._edge_b;
  result^._body_b^._joint_list := @result^._edge_b;
  body_a := def.body_a;
  body_b := def.body_b;
  if not def.collide_connected then
  begin
    edge := body_b^.get_contact_list;
    while edge <> nil do
    begin
      if edge^.other = body_a then
      edge^.contact^.flag_for_filtering;
      edge := edge^.next;
    end;
  end;
end;

procedure tb2_world.destroy_joint(var joint: pb2_joint);
  var collide_connected: boolean;
  var body_a, body_b: pb2_body;
  var edge: pb2_contact_edge;
begin
  if is_locked then exit;
  collide_connected := joint^._collide_connected;
  if joint^._prev <> nil then
  joint^._prev^._next := joint^._next;
  if joint^._next <> nil then
  joint^._next^._prev := joint^._prev;
  if joint = _joint_list then
  _joint_list := joint^._next;
  body_a := joint^._body_a;
  body_b := joint^._body_b;
  body_a^.set_awake(true);
  body_b^.set_awake(true);
  if joint^._edge_a.prev <> nil then
  joint^._edge_a.prev^.next := joint^._edge_a.next;
  if joint^._edge_a.next <> nil then
  joint^._edge_a.next^.prev := joint^._edge_a.prev;
  if @joint^._edge_a = body_a^._joint_list then
  body_a^._joint_list := joint^._edge_a.next;
  joint^._edge_a.prev := nil;
  joint^._edge_a.next := nil;
  if joint^._edge_b.prev <> nil then
  joint^._edge_b.prev^.next := joint^._edge_b.next;
  if joint^._edge_b.next <> nil then
  joint^._edge_b.next^.prev := joint^._edge_b.prev;
  if @joint^._edge_b = body_b^._joint_list then
  body_b^._joint_list := joint^._edge_b.next;
  joint^._edge_b.prev := nil;
  joint^._edge_b.next := nil;
  tb2_joint.destroy_joint(joint, @_block_allocator);
  dec(_joint_count);
  if not collide_connected then
  begin
    edge := body_b^.get_contact_list;
    while edge <> nil do
    begin
      if edge^.other = body_a then
      edge^.contact^.flag_for_filtering;
      edge := edge^.next;
    end;
  end;
end;

procedure tb2_world.step(const time_step: tb2_float32; const velocity_iterations, position_iterations: tb2_int32);
  var step_timer, timer: tb2_timer;
  var s: tb2_time_step;
begin
  step_timer.create;
  if b2_wf_new_fixture in _flags then
  begin
    _contact_manager.find_new_contacts;
    _flags -= [b2_wf_new_fixture];
  end;
  _flags += [b2_wf_locked];
  s.dt := time_step;
  s.velocity_iterations := velocity_iterations;
  s.position_iterations := position_iterations;
  if (time_step > 0.0) then
  s.rcp_dt := 1.0 / time_step
  else
  s.rcp_dt := 0.0;
  s.dt_ratio := _rcp_dt0 * time_step;
  s.warm_starting := _warm_starting;
  timer.create;
  _contact_manager.collide;
  _profile.collide := timer.get_milliseconds;
  if _step_complete and (s.dt > 0.0) then
  begin
    timer.reset;
    solve(s);
    _profile.solve := timer.get_milliseconds;
  end;
  if _continuous_physics and (s.dt > 0.0) then
  begin
    timer.reset;
    solve_toi(s);
    _profile.solve_toi := timer.get_milliseconds;
  end;
  if (s.dt > 0.0) then
  _rcp_dt0 := s.rcp_dt;
  if b2_wf_clear_forces in _flags then
  clear_forces;
  _flags -= [b2_wf_locked];
  _profile.step := step_timer.get_milliseconds;
end;

procedure tb2_world.clear_forces;
  var b: pb2_body;
begin
  b := _body_list;
  while b <> nil do
  begin
    b^._force.set_zero;
    b^._torque := 0.0;
    b := b^.get_next;
  end;
end;

procedure tb2_world.draw_debug_data;
  var flags: tb2_draw_flag_set;
  var b: pb2_body;
  var f, f_a, f_b: pb2_fixture;
  var j: pb2_joint;
  var c: pb2_contact;
  var xf: tb2_transform;
  var color: tb2_color;
  var c_a, c_b: tb2_vec2;
  var bp: pb2_broad_phase;
  var i: tb2_int32;
  var proxy: pb2_fixture_proxy;
  var aabb: tb2_aabb;
  var vs: array[0..3] of tb2_vec2;
begin
  if _debug_draw = nil then exit;
  flags := _debug_draw.draw_flags;
  if b2_df_shape in flags then
  begin
    b := _body_list;
    while b <> nil do
    begin
      xf := b^.get_transform;
      f := b^.get_fixture_list;
      while f <> nil do
      begin
	if not b^.is_active then
	draw_shape(f, xf, b2_color(0.5, 0.5, 0.3))
	else if b^.get_type = b2_static_body then
	draw_shape(f, xf, b2_color(0.5, 0.9, 0.5))
	else if b^.get_type = b2_kinematic_body then
	draw_shape(f, xf, b2_color(0.5, 0.5, 0.9))
	else if not b^.is_awake then
	draw_shape(f, xf, b2_color(0.6, 0.6, 0.6))
	else
	draw_shape(f, xf, b2_color(0.9, 0.7, 0.7));
        f := f^.get_next;
      end;
      b := b^.get_next;
    end;
  end;
  if b2_df_joint in flags then
  begin
    j := _joint_list;
    while j <> nil do
    begin
      draw_joint(j);
      j := j^.get_next;
    end;
  end;
  if b2_df_pair in flags then
  begin
    color.set_value(0.3, 0.9, 0.9);
    c := _contact_manager.contact_list;
    while c <> nil do
    begin
      f_a := c^.get_fixture_a;
      f_b := c^.get_fixture_b;
      c_a.set_zero;
      for i := 0 to f_a^._proxy_count - 1 do
      c_a := c_a + f_a^.get_aabb(i).get_center;
      c_a := c_a * (1 / f_a^._proxy_count);
      c_b.set_zero;
      for i := 0 to f_b^._proxy_count - 1 do
      c_b := c_b + f_b^.get_aabb(i).get_center;
      c_b := c_b * (1 / f_b^._proxy_count);
      _debug_draw.draw_segment(c_a, c_b, color);
      c := c^.get_next;
    end;
  end;
  if b2_df_aabb in flags then
  begin
    color.set_value(0.9, 0.3, 0.9);
    bp := @_contact_manager.broad_phase;
    b := _body_list;
    while b <> nil do
    begin
      if not b^.is_active then
      begin
        b := b^.get_next;
        continue;
      end;
      f := b^.get_fixture_list;
      while f <> nil do
      begin
	for i := 0 to f^._proxy_count - 1 do
	begin
	  proxy := @f^._proxies^[i];
	  aabb := bp^.get_fat_aabb(proxy^.proxy_id);
          {$warnings off}
	  vs[0].set_value(aabb.lower_bound.x, aabb.lower_bound.y);
	  vs[1].set_value(aabb.upper_bound.x, aabb.lower_bound.y);
	  vs[2].set_value(aabb.upper_bound.x, aabb.upper_bound.y);
	  vs[3].set_value(aabb.lower_bound.x, aabb.upper_bound.y);
          {$warnings on}
	  _debug_draw.draw_polygon(@vs, 4, color);
	end;
        f := f^.get_next;
      end;
      b := b^.get_next;
    end;
  end;
  if b2_df_center_of_mass in flags then
  begin
    b := _body_list;
    while b <> nil do
    begin
      xf := b^.get_transform;
      xf.p := b^.get_world_center;
      _debug_draw.draw_transform(xf);
      b := b^.get_next;
    end;
  end;
end;

{$notes off}
procedure tb2_world.query_aabb(const callback: tb2_query_fixture_callback; const aabb: tb2_aabb);
  var wrapper: tb2_world_query_wrapper;
begin
  wrapper.broad_phase := @_contact_manager.broad_phase;
  wrapper.callback := callback;
  _contact_manager.broad_phase.query(@wrapper.query_callback, aabb);
end;
{$notes on}

{$notes off}
procedure tb2_world.ray_cast(const callback: tb2_ray_cast_fixture_callback; const point1, point2: tb2_vec2);
  var wrapper: tb2_world_ray_cast_wrapper;
  var input: tb2_ray_cast_input;
begin
  wrapper.broad_phase := @_contact_manager.broad_phase;
  wrapper.callback := callback;
  input.max_fraction := 1.0;
  input.p1 := point1;
  input.p2 := point2;
  _contact_manager.broad_phase.ray_cast(@wrapper.ray_cast_callback, input);
end;
{$notes on}

function tb2_world.get_body_list: pb2_body;
begin
  result := _body_list;
end;

function tb2_world.get_joint_list: pb2_joint;
begin
  result := _joint_list;
end;

function tb2_world.get_contact_list: pb2_contact;
begin
  result := _contact_manager.contact_list;
end;

procedure tb2_world.set_allow_sleeping(const flag: boolean);
  var b: pb2_body;
begin
  if flag = _allow_sleep then exit;
  _allow_sleep := flag;
  if not _allow_sleep then
  begin
    b := _body_list;
    while b <> nil do
    begin
      b^.set_awake(true);
      b := b^._next;
    end;
  end;
end;

function tb2_world.get_allow_sleeping: boolean;
begin
  result := _allow_sleep;
end;

procedure tb2_world.set_warm_starting(const flag: boolean);
begin
  _warm_starting := flag;
end;

function tb2_world.get_warm_starting: boolean;
begin
  result := _warm_starting;
end;

procedure tb2_world.set_continuous_physics(const flag: boolean);
begin
  _continuous_physics := flag;
end;

function tb2_world.get_continuous_physics: boolean;
begin
  result := _continuous_physics;
end;

procedure tb2_world.set_sub_stepping(const flag: boolean);
begin
  _sub_stepping := flag;
end;

function tb2_world.get_sub_stepping: boolean;
begin
  result := _sub_stepping;
end;

function tb2_world.get_proxy_count: tb2_int32;
begin
  result := _contact_manager.broad_phase.get_proxy_count;
end;

function tb2_world.get_body_count: tb2_int32;
begin
  result := _body_count;
end;

function tb2_world.get_joint_count: tb2_int32;
begin
  result := _joint_count;
end;

function tb2_world.get_contact_count: tb2_int32;
begin
  result := _contact_manager.contact_count;
end;

function tb2_world.get_tree_height: tb2_int32;
begin
  result := _contact_manager.broad_phase.get_tree_height;
end;

function tb2_world.get_tree_balance: tb2_int32;
begin
  result := _contact_manager.broad_phase.get_tree_balance;
end;

function tb2_world.get_tree_quality: tb2_float32;
begin
  result := _contact_manager.broad_phase.get_tree_quality;
end;

procedure tb2_world.set_gravity(const gravity: tb2_vec2);
begin
  _gravity := gravity;
end;

function tb2_world.get_gravity: tb2_vec2;
begin
  result := _gravity;
end;

function tb2_world.is_locked: boolean;
begin
  result := b2_wf_locked in _flags;
end;

procedure tb2_world.set_auto_clear_forces(const flag: boolean);
begin
  if flag then
  _flags += [b2_wf_clear_forces]
  else
  _flags -= [b2_wf_clear_forces];
end;

function tb2_world.get_auto_clear_forces: boolean;
begin
  result := b2_wf_clear_forces in _flags;
end;

procedure tb2_world.shift_origin(const new_origin: tb2_vec2);
  var b: pb2_body;
  var j: pb2_joint;
begin
  if b2_wf_locked in _flags then exit;
  b := _body_list;
  while b <> nil do
  begin
    b^._xf.p := b^._xf.p - new_origin;
    b^._sweep.c0 := b^._sweep.c0 - new_origin;
    b^._sweep.c := b^._sweep.c - new_origin;
    b := b^._next;
  end;
  j := _joint_list;
  while j <> nil do
  begin
    j^.shift_origin(new_origin);
    j := j^._next;
  end;
  _contact_manager.broad_phase.shift_origin(new_origin);
end;

function tb2_world.get_contact_manager: pb2_contact_manager;
begin
  result := @_contact_manager;
end;

function tb2_world.get_profile: pb2_profile;
begin
  result := @_profile;
end;

function tb2_world.get_stack_allocator: pb2_stack_allocator;
begin
  result := @_stack_allocator;
end;

function tb2_world.get_block_allocator: pb2_block_allocator;
begin
  result := @_block_allocator;
end;

procedure tb2_world.dump;
begin
  //if ((m_flags & e_locked) == e_locked)
  //{
	 // return;
  //}
  //
  //b2Log("b2Vec2 g(%.15lef, %.15lef);\n", m_gravity.x, m_gravity.y);
  //b2Log("m_world->SetGravity(g);\n");
  //
  //b2Log("b2Body** bodies = (b2Body**)b2Alloc(%d * sizeof(b2Body*));\n", m_bodyCount);
  //b2Log("b2Joint** joints = (b2Joint**)b2Alloc(%d * sizeof(b2Joint*));\n", m_jointCount);
  //int32 i = 0;
  //for (b2Body* b = m_bodyList; b; b = b->m_next)
  //{
	 // b->m_islandIndex = i;
	 // b->Dump();
	 // ++i;
  //}
  //
  //i = 0;
  //for (b2Joint* j = m_jointList; j; j = j->m_next)
  //{
	 // j->m_index = i;
	 // ++i;
  //}
  //
  //// First pass on joints, skip gear joints.
  //for (b2Joint* j = m_jointList; j; j = j->m_next)
  //{
	 // if (j->m_type == e_gearJoint)
	 // {
		//  continue;
	 // }
  //
	 // b2Log("{\n");
	 // j->Dump();
	 // b2Log("}\n");
  //}
  //
  //// Second pass on joints, only gear joints.
  //for (b2Joint* j = m_jointList; j; j = j->m_next)
  //{
	 // if (j->m_type != e_gearJoint)
	 // {
		//  continue;
	 // }
  //
	 // b2Log("{\n");
	 // j->Dump();
	 // b2Log("}\n");
  //}
  //
  //b2Log("b2Free(joints);\n");
  //b2Log("b2Free(bodies);\n");
  //b2Log("joints = NULL;\n");
  //b2Log("bodies = NULL;\n");
end;
//tb2_world END

procedure b2_get_point_states(
  var state1: array of tb2_point_state;
  var state2: array of tb2_point_state;
  const manifold1: pb2_manifold; const manifold2: pb2_manifold
);
  var i, j: tb2_int32;
  var id: tb2_contact_id;
begin
  for i := 0 to b2_max_manifold_points - 1 do
  begin
    state1[i] := b2_null_state;
    state2[i] := b2_null_state;
  end;
  for i := 0 to manifold1^.point_count - 1 do
  begin
    id := manifold1^.points[i].id;
    state1[i] := b2_remove_state;
    for j := 0 to manifold2^.point_count - 1 do
    begin
      if manifold2^.points[j].id.key = id.key then
      begin
        state1[i] := b2_persist_state;
        break;
      end;
    end;
  end;
  for i := 0 to manifold2^.point_count - 1 do
  begin
    id := manifold2^.points[i].id;
    state2[i] := b2_add_state;
    for j := 0 to manifold1^.point_count - 1 do
    begin
      if manifold1^.points[j].id.key = id.key then
      begin
	state2[i] := b2_persist_state;
	break;
      end;
    end;
  end;
end;

procedure b2_collide_circles(
  var manifold: tb2_manifold;
  const circle_a: pb2_circle_shape; const xf_a: tb2_transform;
  const circle_b: pb2_circle_shape; const xf_b: tb2_transform
);
  var p_a, p_b, d: tb2_vec2;
  var dist_sqr, r_a, r_b, radius: tb2_float32;
begin
  manifold.point_count := 0;
  p_a := b2_mul(xf_a, circle_a^.center);
  p_b := b2_mul(xf_b, circle_b^.center);
  d := p_b - p_a;
  dist_sqr := b2_dot(d, d);
  r_a := circle_a^.radius; r_b := circle_b^.radius;
  radius := r_a + r_b;
  if dist_sqr > radius * radius then exit;
  manifold.manifold_type := b2_mt_circles;
  manifold.local_point := circle_a^.center;
  manifold.local_normal.set_zero;
  manifold.point_count := 1;
  manifold.points[0].local_point := circle_b^.center;
  manifold.points[0].id.key := 0;
end;

procedure b2_collide_polygon_and_circle(
  var manifold: tb2_manifold;
  const polygon_a: pb2_polygon_shape; const xf_a: tb2_transform;
  const circle_b: pb2_circle_shape; const xf_b: tb2_transform
);
  var c, c_local, v1, v2, face_center: tb2_vec2;
  var normal_index, vertex_count, i, vert_index_1, vert_index_2: tb2_int32;
  var separation, radius, s, u1, u2: tb2_float32;
  var vertices, normals: pb2_vec2_arr;
begin
  manifold.point_count := 0;
  c := b2_mul(xf_b, circle_b^.center);
  c_local := b2_mul_t(xf_a, c);
  normal_index := 0;
  separation := -b2_max_float;
  radius := polygon_a^.radius + circle_b^.radius;
  vertex_count := polygon_a^.count;
  vertices := pb2_vec2_arr(@polygon_a^.vertices);
  normals := pb2_vec2_arr(@polygon_a^.normals);
  for i := 0 to vertex_count - 1 do
  begin
    s := b2_dot(normals^[i], c_local - vertices^[i]);
    if s > radius then exit;
    if s > separation then
    begin
      separation := s;
      normal_index := i;
    end;
  end;
  vert_index_1 := normal_index;
  if vert_index_1 + 1 < vertex_count then
  vert_index_2 := vert_index_1 + 1
  else
  vert_index_2 := 0;
  v1 := vertices^[vert_index_1];
  v2 := vertices^[vert_index_2];
  if separation < b2_epsilon then
  begin
    manifold.point_count := 1;
    manifold.manifold_type := b2_mt_face_a;
    manifold.local_normal := normals^[normal_index];
    manifold.local_point := 0.5 * (v1 + v2);
    manifold.points[0].local_point := circle_b^.center;
    manifold.points[0].id.key := 0;
    exit;
  end;
  u1 := b2_dot(c_local - v1, v2 - v1);
  u2 := b2_dot(c_local - v2, v1 - v2);
  if u1 <= 0.0 then
  begin
    if b2_distance_sq(c_local, v1) > radius * radius then exit;
    manifold.point_count := 1;
    manifold.manifold_type := b2_mt_face_a;
    manifold.local_normal := c_local - v1;
    manifold.local_normal.normalize;
    manifold.local_point := v1;
    manifold.points[0].local_point := circle_b^.center;
    manifold.points[0].id.key := 0;
  end
  else if u2 <= 0.0 then
  begin
    if b2_distance_sq(c_local, v2) > radius * radius then exit;
    manifold.point_count := 1;
    manifold.manifold_type := b2_mt_face_a;
    manifold.local_normal := c_local - v2;
    manifold.local_normal.normalize;
    manifold.local_point := v2;
    manifold.points[0].local_point := circle_b^.center;
    manifold.points[0].id.key := 0;
  end
  else
  begin
    face_center := 0.5 * (v1 + v2);
    separation := b2_dot(c_local - face_center, normals^[vert_index_1]);
    if separation > radius then exit;
    manifold.point_count := 1;
    manifold.manifold_type := b2_mt_face_a;
    manifold.local_normal := normals^[vert_index_1];
    manifold.local_point := face_center;
    manifold.points[0].local_point := circle_b^.center;
    manifold.points[0].id.key := 0;
  end;
end;

procedure b2_collide_polygons(
  var manifold: tb2_manifold;
  const polygon_a: pb2_polygon_shape; const xf_a: tb2_transform;
  const polygon_b: pb2_polygon_shape; const xf_b: tb2_transform
);
  function b2_find_max_separation(
    var edge_index: tb2_int32;
    const poly1: pb2_polygon_shape; const xf1: tb2_transform;
    const poly2: pb2_polygon_shape; const xf2: tb2_transform
  ): tb2_float32;
    var count1, count2, best_index, i, j: tb2_int32;
    var max_separation, si, sij: tb2_float32;
    var n1s, v1s, v2s: pb2_vec2_arr;
    var xf: tb2_transform;
    var n, v1: tb2_vec2;
  begin
    count1 := poly1^.count;
    count2 := poly2^.count;
    n1s := pb2_vec2_arr(@poly1^.normals);
    v1s := pb2_vec2_arr(@poly1^.vertices);
    v2s := pb2_vec2_arr(@poly2^.vertices);
    xf := b2_mul_t(xf2, xf1);
    best_index := 0;
    max_separation := -b2_max_float;
    for i := 0 to count1 - 1 do
    begin
      n := b2_mul(xf.q, n1s^[i]);
      v1 := b2_mul(xf, v1s^[i]);
      si := b2_max_float;
      for j := 0 to count2 - 1 do
      begin
	sij := b2_dot(n, v2s^[j] - v1);
	if sij < si then
	si := sij;
      end;
      if si > max_separation then
      begin
	max_separation := si;
	best_index := i;
      end;
    end;
    edge_index := best_index;
    result := max_separation;
  end;
  procedure b2_find_incident_edge(
    const c: pb2_clip_vertex_arr;
    const poly1: pb2_polygon_shape; const xf1: tb2_transform; const edge1: tb2_int32;
    const poly2: pb2_polygon_shape; const xf2: tb2_transform
  );
    var normals1, vertices2, normals2: pb2_vec2_arr;
    var count2, index, i, i1, i2: tb2_int32;
    var min_dot, dot: tb2_float32;
    var normal1: tb2_vec2;
  begin
    normals1 := pb2_vec2_arr(@poly1^.normals);
    count2 := poly2^.count;
    vertices2 := pb2_vec2_arr(@poly2^.vertices);
    normals2 := pb2_vec2_arr(@poly2^.normals);
    normal1 := b2_mul_t(xf2.q, b2_mul(xf1.q, normals1^[edge1]));
    index := 0;
    min_dot := b2_max_float;
    for i := 0 to count2 - 1 do
    begin
      dot := b2_dot(normal1, normals2^[i]);
      if dot < min_dot then
      begin
	min_dot := dot;
	index := i;
      end;
    end;
    i1 := index;
    if i1 + 1 < count2 then i2 := i1 + 1 else i2 := 0;
    c^[0].v := b2_mul(xf2, vertices2^[i1]);
    c^[0].id.cf.index_a := tb2_uint8(edge1);
    c^[0].id.cf.index_b := tb2_uint8(i1);
    c^[0].id.cf.type_a := tb2_uint8(b2_cft_face);
    c^[0].id.cf.type_b := tb2_uint8(b2_cft_vertex);
    c^[1].v := b2_mul(xf2, vertices2^[i2]);
    c^[1].id.cf.index_a := tb2_uint8(edge1);
    c^[1].id.cf.index_b := tb2_uint8(i2);
    c^[1].id.cf.type_a := tb2_uint8(b2_cft_face);
    c^[1].id.cf.type_b := tb2_uint8(b2_cft_vertex);
  end;
  var total_radius, separation_a, separation_b, front_offset, side_offset1, side_offset2, separation: tb2_float32;
  var edge_a, edge_b, edge1, count1, iv1, iv2, np, point_count, i: tb2_int32;
  var poly1, poly2: pb2_polygon_shape;
  var xf1, xf2: tb2_transform;
  var flip: tb2_uint8;
  var incident_edge: array[0..1] of tb2_clip_vertex;
  var vertices1: pb2_vec2_arr;
  var v11, v12, local_tangent, local_normal, plane_point, tangent, normal: tb2_vec2;
  var clip_points1, clip_points2: array[0..1] of tb2_clip_vertex;
  var cp: pb2_manifold_point;
  var cf: tb2_contact_feature;
  const k_tol = 0.1 * b2_linear_slop;
begin
  manifold.point_count := 0;
  total_radius := polygon_a^.radius + polygon_b^.radius;
  edge_a := 0;
  separation_a := b2_find_max_separation(edge_a, polygon_a, xf_a, polygon_b, xf_b);
  if separation_a > total_radius then exit;
  edge_b := 0;
  separation_b := b2_find_max_separation(edge_b, polygon_b, xf_b, polygon_a, xf_a);
  if separation_b > total_radius then exit;
  if separation_b > separation_a + k_tol then
  begin
    poly1 := polygon_b;
    poly2 := polygon_a;
    xf1 := xf_b;
    xf2 := xf_a;
    edge1 := edge_b;
    manifold.manifold_type := b2_mt_face_b;
    flip := 1;
  end
  else
  begin
    poly1 := polygon_a;
    poly2 := polygon_b;
    xf1 := xf_a;
    xf2 := xf_b;
    edge1 := edge_a;
    manifold.manifold_type := b2_mt_face_a;
    flip := 0;
  end;
  b2_find_incident_edge(@incident_edge, poly1, xf1, edge1, poly2, xf2);
  count1 := poly1^.count;
  vertices1 := pb2_vec2_arr(@poly1^.vertices);
  iv1 := edge1;
  if edge1 + 1 < count1 then iv2 := edge1 + 1 else iv2 := 0;
  v11 := vertices1^[iv1];
  v12 := vertices1^[iv2];
  local_tangent := v12 - v11;
  local_tangent.normalize;
  local_normal := b2_cross(local_tangent, 1.0);
  plane_point := 0.5 * (v11 + v12);
  tangent := b2_mul(xf1.q, local_tangent);
  normal := b2_cross(tangent, 1.0);
  v11 := b2_mul(xf1, v11);
  v12 := b2_mul(xf1, v12);
  front_offset := b2_dot(normal, v11);
  side_offset1 := -b2_dot(tangent, v11) + total_radius;
  side_offset2 := b2_dot(tangent, v12) + total_radius;
  np := b2_clip_segment_to_line(@clip_points1, @incident_edge, -tangent, side_offset1, iv1);
  if np < 2 then exit;
  np := b2_clip_segment_to_line(@clip_points2, @clip_points1,  tangent, side_offset2, iv2);
  if np < 2 then exit;
  manifold.local_normal := local_normal;
  manifold.local_point := plane_point;
  point_count := 0;
  for i := 0 to b2_max_manifold_points - 1 do
  begin
    separation := b2_dot(normal, clip_points2[i].v) - front_offset;
    if separation <= total_radius then
    begin
      cp := @manifold.points[point_count];
      cp^.local_point := b2_mul_t(xf2, clip_points2[i].v);
      cp^.id := clip_points2[i].id;
      if flip > 0 then
      begin
	cf := cp^.id.cf;
	cp^.id.cf.index_a := cf.index_b;
	cp^.id.cf.index_b := cf.index_a;
	cp^.id.cf.type_a := cf.type_b;
	cp^.id.cf.type_b := cf.type_a;
      end;
      inc(point_count);
    end;
  end;
  manifold.point_count := point_count;
end;

procedure b2_collide_edge_and_circle(
  var manifold: tb2_manifold;
  const edge_a: pb2_edge_shape; const xf_a: tb2_transform;
  const circle_b: pb2_circle_shape; const xf_b: tb2_transform
);
  var q, a, b, e, p, d, a1, b1, e1, a2, b2, e2, n: tb2_vec2;
  var u, v, radius, dd, u1, v2, den: tb2_float32;
  var cf: tb2_contact_feature;
begin
  manifold.point_count := 0;
  q := b2_mul_t(xf_a, b2_mul(xf_b, circle_b^.center));
  a := edge_a^.vertex1; b := edge_a^.vertex2;
  e := b - a;
  u := b2_dot(e, b - q);
  v := b2_dot(e, q - a);
  radius := edge_a^.radius + circle_b^.radius;
  cf.index_b := 0;
  cf.type_b := tb2_uint8(b2_cft_vertex);
  if v <= 0.0 then
  begin
    p := a;
    d := q - p;
    dd := b2_dot(d, d);
    if dd > radius * radius then exit;
    if edge_a^.has_vertex0 then
    begin
      a1 := edge_a^.vertex0;
      b1 := a;
      e1 := b1 - a1;
      u1 := b2_dot(e1, b1 - q);
      if u1 > 0.0 then exit;
    end;
    cf.index_a := 0;
    cf.type_a := tb2_uint8(b2_cft_vertex);
    manifold.point_count := 1;
    manifold.manifold_type := b2_mt_circles;
    manifold.local_normal.set_zero;
    manifold.local_point := p;
    manifold.points[0].id.key := 0;
    manifold.points[0].id.cf := cf;
    manifold.points[0].local_point := circle_b^.center;
    exit;
  end;
  if u <= 0.0 then
  begin
    p := b;
    d := q - p;
    dd := b2_dot(d, d);
    if dd > radius * radius then exit;
    if edge_a^.has_vertex3 then
    begin
      b2 := edge_a^.vertex3;
      a2 := b;
      e2 := b2 - a2;
      v2 := b2_dot(e2, q - a2);
      if v2 > 0.0 then exit;
    end;
    cf.index_a := 1;
    cf.type_a := tb2_uint8(b2_cft_vertex);
    manifold.point_count := 1;
    manifold.manifold_type := b2_mt_circles;
    manifold.local_normal.set_zero;
    manifold.local_point := p;
    manifold.points[0].id.key := 0;
    manifold.points[0].id.cf := cf;
    manifold.points[0].local_point := circle_b^.center;
    exit;
  end;
  den := b2_dot(e, e);
  p := (1.0 / den) * (u * a + v * b);
  d := q - p;
  dd := b2_dot(d, d);
  if dd > radius * radius then exit;
  n.set_value(-e.y, e.x);
  if b2_dot(n, q - a) < 0.0 then
  n.set_value(-n.x, -n.y);
  n.normalize;
  cf.index_a := 0;
  cf.type_a := tb2_uint8(b2_cft_face);
  manifold.point_count := 1;
  manifold.manifold_type := b2_mt_face_a;
  manifold.local_normal := n;
  manifold.local_point := a;
  manifold.points[0].id.key := 0;
  manifold.points[0].id.cf := cf;
  manifold.points[0].local_point := circle_b^.center;
end;

procedure b2_collide_edge_and_polygon(
  var manifold: tb2_manifold;
  const edge_a: pb2_edge_shape; const xf_a: tb2_transform;
  const polygon_b: pb2_polygon_shape; const xf_b: tb2_transform
);
  type t_ep_axis_type = (
    e_at_unknown,
    e_at_edge_a,
    e_at_edge_b
  );
  type t_ep_axis = record
    axis_type: t_ep_axis_type;
    index: tb2_int32;
    separation: tb2_float32;
  end;
  type tb2_temp_polygon = record
    vertices: array [0..b2_max_polygon_vertices - 1] of tb2_vec2;
    normals: array [0..b2_max_polygon_vertices - 1] of tb2_vec2;
    count: tb2_int32;
  end;
  type tb2_reference_face = record
    i1, i2: tb2_int32;
    v1, v2: tb2_vec2;
    normal: tb2_vec2;
    side_normal_1: tb2_vec2;
    side_offset_1: tb2_float32;
    side_normal_2: tb2_vec2;
    side_offset_2: tb2_float32;
  end;
  var poly_b: tb2_temp_polygon;
  var xf: tb2_transform;
  var centroid_b: tb2_vec2;
  var v0, v1, v2, v3: tb2_vec2;
  var normal0, normal1, normal2: tb2_vec2;
  var normal: tb2_vec2;
  var lower_limit, upper_limit: tb2_vec2;
  var radius: tb2_float32;
  var front: boolean;
  function compute_edge_separation: t_ep_axis;
    var i: tb2_int32;
    var s: tb2_float32;
  begin
    result.axis_type := e_at_edge_a;
    if front then result.index := 0 else result.index := 1;
    result.separation := b2_max_float;
    for i := 0 to poly_b.count - 1 do
    begin
      s := b2_dot(normal, poly_b.vertices[i] - v1);
      if s < result.separation then
      result.separation := s;
    end;
  end;
  function compute_polygon_separation: t_ep_axis;
    var perp, n: tb2_vec2;
    var i: tb2_int32;
    var s, s1, s2: tb2_float32;
  begin
    result.axis_type := e_at_unknown;
    result.index := -1;
    result.separation := -b2_max_float;
    perp.set_value(-normal.y, normal.x);
    for i := 0 to poly_b.count - 1 do
    begin
      n := -poly_b.normals[i];
      s1 := b2_dot(n, poly_b.vertices[i] - v1);
      s2 := b2_dot(n, poly_b.vertices[i] - v2);
      s := b2_min(s1, s2);
      if s > radius then
      begin
	result.axis_type := e_at_edge_b;
	result.index := i;
	result.separation := s;
	exit;
      end;
      if b2_dot(n, perp) >= 0.0 then
      begin
	if b2_dot(n - upper_limit, normal) < -b2_angular_slop then continue;
      end
      else
      begin
	if b2_dot(n - lower_limit, normal) < -b2_angular_slop then continue;
      end;
      if s > result.separation then
      begin
	result.axis_type := e_at_edge_b;
	result.index := i;
	result.separation := s;
      end;
    end;
  end;
  procedure collide(
    var manifold: tb2_manifold;
    const edge_a: pb2_edge_shape; const xf_a: tb2_transform;
    const polygon_b: pb2_polygon_shape; const xf_b: tb2_transform
  );
    var has_vertex0, has_vertex3, convex1, convex2: boolean;
    var edge0, edge1, edge2: tb2_vec2;
    var offset0, offset1, offset2, best_value, value, separation: tb2_float32;
    var i, best_index, i1, i2, np, point_count: tb2_int32;
    var edge_axis, polygon_axis, primary_axis: t_ep_axis;
    var ie: array[0..1] of tb2_clip_vertex;
    var rf: tb2_reference_face;
    var clip_points1, clip_points2: array[0..1] of tb2_clip_vertex;
    var cp: pb2_manifold_point;
    const k_relative_tol = 0.98;
    const k_absolute_tol = 0.001;
  begin
    xf := b2_mul_t(xf_a, xf_b);
    centroid_b := b2_mul(xf, polygon_b^.centroid);
    v0 := edge_a^.vertex0;
    v1 := edge_a^.vertex1;
    v2 := edge_a^.vertex2;
    v3 := edge_a^.vertex3;
    has_vertex0 := edge_a^.has_vertex0;
    has_vertex3 := edge_a^.has_vertex3;
    edge1 := v2 - v1;
    edge1.normalize;
    normal1.set_value(edge1.y, -edge1.x);
    offset1 := b2_dot(normal1, centroid_b - v1);
    offset0 := 0.0; offset2 := 0.0;
    convex1 := false; convex2 := false;
    if has_vertex0 then
    begin
      edge0 := v1 - v0;
      edge0.normalize;
      normal0.set_value(edge0.y, -edge0.x);
      convex1 := b2_cross(edge0, edge1) >= 0.0;
      offset0 := b2_dot(normal0, centroid_b - v0);
    end;
    if has_vertex3 then
    begin
      edge2 := v3 - v2;
      edge2.normalize;
      normal2.set_value(edge2.y, -edge2.x);
      convex2 := b2_cross(edge1, edge2) > 0.0;
      offset2 := b2_dot(normal2, centroid_b - v2);
    end;
    if has_vertex0 and has_vertex3 then
    begin
      if convex1 and convex2 then
      begin
	front := (offset0 >= 0.0) or (offset1 >= 0.0) or (offset2 >= 0.0);
	if front then
	begin
	  normal := normal1;
	  lower_limit := normal0;
	  upper_limit := normal2;
	end
	else
	begin
	  normal := -normal1;
	  lower_limit := -normal1;
	  upper_limit := -normal1;
	end;
      end
      else if convex1 then
      begin
	front := (offset0 >= 0.0) or ((offset1 >= 0.0) and (offset2 >= 0.0));
	if front then
	begin
	  normal := normal1;
	  lower_limit := normal0;
	  upper_limit := normal1;
	end
	else
	begin
	  normal := -normal1;
	  lower_limit := -normal2;
	  upper_limit := -normal1;
	end;
      end
      else if convex2 then
      begin
	front := (offset2 >= 0.0) or ((offset0 >= 0.0) and (offset1 >= 0.0));
	if front then
	begin
	  normal := normal1;
	  lower_limit := normal1;
	  upper_limit := normal2;
	end
	else
	begin
	  normal := -normal1;
	  lower_limit := -normal1;
	  upper_limit := -normal0;
	end;
      end
      else
      begin
	front := (offset0 >= 0.0) and (offset1 >= 0.0) and (offset2 >= 0.0);
	if front then
	begin
	  normal := normal1;
	  lower_limit := normal1;
	  upper_limit := normal1;
	end
	else
	begin
	  normal := -normal1;
	  lower_limit := -normal2;
	  upper_limit := -normal0;
	end;
      end;
    end
    else if has_vertex0 then
    begin
      if convex1 then
      begin
	front := (offset0 >= 0.0) or (offset1 >= 0.0);
	if front then
	begin
	  normal := normal1;
	  lower_limit := normal0;
	  upper_limit := -normal1;
	end
	else
	begin
	  normal := -normal1;
	  lower_limit := normal1;
	  upper_limit := -normal1;
	end;
      end
      else
      begin
	front := (offset0 >= 0.0) and (offset1 >= 0.0);
	if front then
	begin
	  normal := normal1;
	  lower_limit := normal1;
	  upper_limit := -normal1;
	end
	else
	begin
	  normal := -normal1;
	  lower_limit := normal1;
	  upper_limit := -normal0;
	end;
      end;
    end
    else if has_vertex3 then
    begin
      if convex2 then
      begin
	front := (offset1 >= 0.0) or (offset2 >= 0.0);
	if front then
	begin
	  normal := normal1;
	  lower_limit := -normal1;
	  upper_limit := normal2;
	end
	else
	begin
	  normal := -normal1;
	  lower_limit := -normal1;
	  upper_limit := normal1;
	end;
      end
      else
      begin
	front := (offset1 >= 0.0) and (offset2 >= 0.0);
	if front then
	begin
	  normal := normal1;
	  lower_limit := -normal1;
	  upper_limit := normal1;
	end
	else
	begin
	  normal := -normal1;
	  lower_limit := -normal2;
	  upper_limit := normal1;
	end;
      end;
    end
    else
    begin
      front := offset1 >= 0.0;
      if front then
      begin
	normal := normal1;
	lower_limit := -normal1;
	upper_limit := -normal1;
      end
      else
      begin
	normal := -normal1;
	lower_limit := normal1;
	upper_limit := normal1;
      end;
    end;
    poly_b.count := polygon_b^.count;
    for i := 0 to polygon_b^.count - 1 do
    begin
      poly_b.vertices[i] := b2_mul(xf, polygon_b^.vertices[i]);
      poly_b.normals[i] := b2_mul(xf.q, polygon_b^.normals[i]);
    end;
    radius := 2.0 * b2_polygon_radius;
    manifold.point_count := 0;
    edge_axis := compute_edge_separation;
    if edge_axis.axis_type = e_at_unknown then exit;
    if edge_axis.separation > radius then exit;
    polygon_axis := compute_polygon_separation;
    if (polygon_axis.axis_type <> e_at_unknown) and (polygon_axis.separation > radius) then exit;
    if polygon_axis.axis_type = e_at_unknown then
    primary_axis := edge_axis
    else if polygon_axis.separation > k_relative_tol * edge_axis.separation + k_absolute_tol then
    primary_axis := polygon_axis
    else
    primary_axis := edge_axis;
    if primary_axis.axis_type = e_at_edge_a then
    begin
      manifold.manifold_type := b2_mt_face_a;
      best_index := 0;
      best_value := b2_dot(normal, poly_b.normals[0]);
      for i := 1 to poly_b.count - 1 do
      begin
	value := b2_dot(normal, poly_b.normals[i]);
	if value < best_value then
	begin
	  best_value := value;
	  best_index := i;
	end;
      end;
      i1 := best_index;
      if i1 + 1 < poly_b.count then i2 := i1 + 1 else i2 := 0;
      ie[0].v := poly_b.vertices[i1];
      ie[0].id.cf.index_a := 0;
      ie[0].id.cf.index_b := tb2_uint8(i1);
      ie[0].id.cf.type_a := tb2_uint8(b2_cft_face);
      ie[0].id.cf.type_b := tb2_uint8(b2_cft_vertex);
      ie[1].v := poly_b.vertices[i2];
      ie[1].id.cf.index_a := 0;
      ie[1].id.cf.index_b := tb2_uint8(i2);
      ie[1].id.cf.type_a := tb2_uint8(b2_cft_face);
      ie[1].id.cf.type_b := tb2_uint8(b2_cft_vertex);
      if front then
      begin
	rf.i1 := 0;
	rf.i2 := 1;
	rf.v1 := v1;
	rf.v2 := v2;
	rf.normal := normal1;
      end
      else
      begin
	rf.i1 := 1;
	rf.i2 := 0;
	rf.v1 := v2;
	rf.v2 := v1;
	rf.normal := -normal1;
      end;
    end
    else
    begin
      manifold.manifold_type := b2_mt_face_b;
      ie[0].v := v1;
      ie[0].id.cf.index_a := 0;
      ie[0].id.cf.index_b := tb2_uint8(primary_axis.index);
      ie[0].id.cf.type_a := tb2_uint8(b2_cft_vertex);
      ie[0].id.cf.type_b := tb2_uint8(b2_cft_face);
      ie[1].v := v2;
      ie[1].id.cf.index_a := 0;
      ie[1].id.cf.index_b := tb2_uint8(primary_axis.index);
      ie[1].id.cf.type_a := tb2_uint8(b2_cft_vertex);
      ie[1].id.cf.type_b := tb2_uint8(b2_cft_face);
      rf.i1 := primary_axis.index;
      if rf.i1 + 1 < poly_b.count then rf.i2 := rf.i1 + 1 else rf.i2 := 0;
      rf.v1 := poly_b.vertices[rf.i1];
      rf.v2 := poly_b.vertices[rf.i2];
      rf.normal := poly_b.normals[rf.i1];
    end;
    rf.side_normal_1.set_value(rf.normal.y, -rf.normal.x);
    rf.side_normal_2 := -rf.side_normal_1;
    rf.side_offset_1 := b2_dot(rf.side_normal_1, rf.v1);
    rf.side_offset_2 := b2_dot(rf.side_normal_2, rf.v2);
    np := b2_clip_segment_to_line(@clip_points1, @ie, rf.side_normal_1, rf.side_offset_1, rf.i1);
    if np < b2_max_manifold_points then exit;
    np := b2_clip_segment_to_line(@clip_points2, @clip_points1, rf.side_normal_2, rf.side_offset_2, rf.i2);
    if np < b2_max_manifold_points then exit;
    if primary_axis.axis_type = e_at_edge_a then
    begin
      manifold.local_normal := rf.normal;
      manifold.local_point := rf.v1;
    end
    else
    begin
      manifold.local_normal := polygon_b^.normals[rf.i1];
      manifold.local_point := polygon_b^.vertices[rf.i1];
    end;
    point_count := 0;
    for i := 0 to b2_max_manifold_points - 1 do
    begin
      separation := b2_dot(rf.normal, clip_points2[i].v - rf.v1);
      if separation <= radius then
      begin
	cp := @manifold.points[point_count];
	if primary_axis.axis_type = e_at_edge_a then
	begin
	  cp^.local_point := b2_mul_t(xf, clip_points2[i].v);
	  cp^.id := clip_points2[i].id;
	end
	else
	begin
	  cp^.local_point := clip_points2[i].v;
	  cp^.id.cf.type_a := clip_points2[i].id.cf.type_b;
	  cp^.id.cf.type_b := clip_points2[i].id.cf.type_a;
	  cp^.id.cf.index_a := clip_points2[i].id.cf.index_b;
	  cp^.id.cf.index_b := clip_points2[i].id.cf.index_a;
	end;
	inc(point_count);
      end;
    end;
    manifold.point_count := point_count;
  end;
begin
  collide(manifold, edge_a, xf_a, polygon_b, xf_b);
end;

function b2_clip_segment_to_line(
  const v_out: pb2_clip_vertex_arr; const v_in: pb2_clip_vertex_arr;
  const normal: tb2_vec2; const offset: tb2_float32; const vertex_index_a: tb2_int32
): tb2_int32;
  var num_out: tb2_int32;
  var distance0, distance1, interp: tb2_float32;
begin
  num_out := 0;
  distance0 := b2_dot(normal, v_in^[0].v) - offset;
  distance1 := b2_dot(normal, v_in^[1].v) - offset;
  if distance0 <= 0.0 then
  begin
    v_out^[num_out] := v_in^[0];
    inc(num_out);
  end;
  if distance1 <= 0.0 then
  begin
    v_out^[num_out] := v_in^[1];
    inc(num_out);
  end;
  if distance0 * distance1 < 0.0 then
  begin
    interp := distance0 / (distance0 - distance1);
    v_out^[num_out].v := v_in^[0].v + interp * (v_in^[1].v - v_in^[0].v);
    v_out^[num_out].id.cf.index_a := tb2_uint8(vertex_index_a);
    v_out^[num_out].id.cf.index_b := v_in^[0].id.cf.index_b;
    v_out^[num_out].id.cf.type_a := byte(b2_cft_vertex);
    v_out^[num_out].id.cf.type_b := byte(b2_cft_face);
    inc(num_out);
  end;
  result := num_out;
end;

function b2_test_overlap(const a, b: tb2_aabb): boolean;
  var d1, d2: tb2_vec2;
begin
  d1 := b.lower_bound - a.upper_bound;
  d2 := a.lower_bound - b.upper_bound;
  if (d1.x > 0.0) or (d1.y > 0.0) then
  begin
    result := false;
    exit;
  end;
  if (d2.x > 0.0) or (d2.y > 0.0) then
  begin
    result := false;
    exit;
  end;
  result := true;
end;

function b2_test_overlap(
  const shape_a: pb2_shape; const index_a: tb2_int32;
  const shape_b: pb2_shape; const index_b: tb2_int32;
  const xf_a: tb2_transform; const xf_b: tb2_transform
): boolean;
  var input: tb2_distance_input;
  var output: tb2_distance_output;
  var cache: tb2_simplex_cache;
begin
  input.create;
  input.proxy_a.set_shape(shape_a, index_a);
  input.proxy_b.set_shape(shape_b, index_b);
  input.transform_a := xf_a;
  input.transform_b := xf_b;
  input.use_radii := true;
  cache.count := 0;
  b2_distance(@output, @cache, @input);
  input.destroy;
  result := output.distance < 10.0 * b2_epsilon;
end;

procedure b2_distance(
  const output: pb2_distance_output;
  const cache: pb2_simplex_cache;
  const input: pb2_distance_input
);
  var proxy_a: pb2_distance_proxy;
  var proxy_b: pb2_distance_proxy;
  var xf_a, xf_b: tb2_transform;
  var simplex: tb2_simplex;
  var vertices: pb2_simplex_vertex_arr;
  var vertex: pb2_simplex_vertex;
  var save_a, save_b: array [0..2] of tb2_int32;
  var save_count, iter, i: tb2_int32;
  var distance_sq1, distance_sq2, r_a, r_b: tb2_float32;
  var p, d, normal: tb2_vec2;
  var duplicate: boolean;
  const k_max_iters = 20;
begin
  inc(b2_gjk_calls);
  proxy_a := @input^.proxy_a;
  proxy_b := @input^.proxy_b;
  xf_a := input^.transform_a;
  xf_b := input^.transform_b;
  simplex.read_cache(cache, proxy_a, xf_a, proxy_b, xf_b);
  vertices := @simplex.v1;
  save_count := 0;
  distance_sq1 := b2_max_float;
  distance_sq2 := distance_sq1;
  iter := 0;
  while iter < k_max_iters do
  begin
    save_count := simplex.count;
    for i := 0 to save_count - 1 do
    begin
      save_a[i] := vertices^[i].index_a;
      save_b[i] := vertices^[i].index_b;
    end;
    case simplex.count of
      2: simplex.solve2;
      3: simplex.solve3;
    end;
    if simplex.count = 3 then break;
    p := simplex.get_closest_point;
    distance_sq2 := p.len_sq;
    distance_sq1 := distance_sq2;
    d := simplex.get_search_direction;
    if d.len_sq < b2_epsilon * b2_epsilon then break;
    vertex := @vertices^[simplex.count];
    vertex^.index_a := proxy_a^.get_support(b2_mul_t(xf_a.q, -d));
    vertex^.w_a := b2_mul(xf_a, proxy_a^.get_vertex(vertex^.index_a));
    vertex^.index_b := proxy_b^.get_support(b2_mul_t(xf_b.q, d));
    vertex^.w_b := b2_mul(xf_b, proxy_b^.get_vertex(vertex^.index_b));
    vertex^.w := vertex^.w_b - vertex^.w_a;
    inc(iter);
    inc(b2_gjk_iters);
    duplicate := false;
    for i := 0 to save_count - 1 do
    begin
      if (vertex^.index_a = save_a[i]) and (vertex^.index_b = save_b[i]) then
      begin
	duplicate := true;
	break;
      end;
    end;
    if duplicate then break;
    inc(simplex.count);
  end;
  b2_gjk_max_iters := b2_max(b2_gjk_max_iters, iter);
  simplex.get_witness_points(@output^.point_a, @output^.point_b);
  output^.distance := b2_distance(output^.point_a, output^.point_b);
  output^.iterations := iter;
  simplex.write_cache(cache);
  if input^.use_radii then
  begin
    r_a := proxy_a^.radius;
    r_b := proxy_b^.radius;
    if (output^.distance > r_a + r_b) and (output^.distance > b2_epsilon) then
    begin
      output^.distance -= r_a + r_b;
      normal := output^.point_b - output^.point_a;
      normal.normalize;
      output^.point_a := output^.point_a + r_a * normal;
      output^.point_b := output^.point_b - r_b * normal;
    end
    else
    begin
      p := 0.5 * (output^.point_a + output^.point_b);
      output^.point_a := p;
      output^.point_b := p;
      output^.distance := 0.0;
    end;
  end;
end;

procedure b2_time_of_impact(var output: tb2_toi_output; const input: tb2_toi_input);
  var timer: tb2_timer;
  var proxy_a, proxy_b: pb2_distance_proxy;
  var sweep_a, sweep_b: tb2_sweep;
  var t_max, total_radius, target, tolerance, t1, t2, s1, s2, a1, a2, t, s, time: tb2_float32;
  var iter, push_back_iter, index_a, index_b, root_iter_count: tb2_int32;
  var cache: tb2_simplex_cache;
  var distance_input: tb2_distance_input;
  var distance_output: tb2_distance_output;
  var xf_a, xf_b: tb2_transform;
  var fcn: tb2_separation_function;
  var done: boolean;
  const max_iterations = 20;
begin
  timer.create;
  inc(b2_toi_calls);
  output.state := b2_tois_unknown;
  output.t := input.t_max;
  proxy_a := @input.proxy_a;
  proxy_b := @input.proxy_b;
  sweep_a := input.sweep_a;
  sweep_b := input.sweep_b;
  sweep_a.normalize;
  sweep_b.normalize;
  t_max := input.t_max;
  total_radius := proxy_a^.radius + proxy_b^.radius;
  target := b2_max(b2_linear_slop, total_radius - 3.0 * b2_linear_slop);
  tolerance := 0.25 * b2_linear_slop;
  t1 := 0.0;
  iter := 0;
  cache.count := 0;
  distance_input.create;
  distance_input.proxy_a := input.proxy_a;
  distance_input.proxy_b := input.proxy_b;
  distance_input.use_radii := false;
  while true do
  begin
    sweep_a.get_transform(@xf_a, t1);
    sweep_b.get_transform(@xf_b, t1);
    distance_input.transform_a := xf_a;
    distance_input.transform_b := xf_b;
    b2_distance(@distance_output, @cache, @distance_input);
    if (distance_output.distance <= 0.0) then
    begin
      output.state := b2_tois_overlapped;
      output.t := 0.0;
      break;
    end;
    if (distance_output.distance < target + tolerance) then
    begin
      output.state := b2_tois_touching;
      output.t := t1;
      break;
    end;
    fcn.initialize(@cache, proxy_a, sweep_a, proxy_b, sweep_b, t1);
    done := false;
    t2 := t_max;
    push_back_iter := 0;
    while true do
    begin
      s2 := fcn.find_min_separation(@index_a, @index_b, t2);
      if s2 > target + tolerance then
      begin
	output.state := b2_tois_separated;
	output.t := t_max;
	done := true;
	break;
      end;
      if (s2 > target - tolerance) then
      begin
	t1 := t2;
	break;
      end;
      s1 := fcn.evaluate(index_a, index_b, t1);
      if s1 < target - tolerance then
      begin
        output.state := b2_tois_failed;
        output.t := t1;
        done := true;
        break;
      end;
      if s1 <= target + tolerance then
      begin
	output.state := b2_tois_touching;
	output.t := t1;
	done := true;
	break;
      end;
      root_iter_count := 0;
      a1 := t1; a2 := t2;
      while true do
      begin
	if root_iter_count and 1 > 0 then
	t := a1 + (target - s1) * (a2 - a1) / (s2 - s1)
	else
	t := 0.5 * (a1 + a2);
	inc(root_iter_count);
	inc(b2_toi_root_iters);
	s := fcn.evaluate(index_a, index_b, t);
	if b2_abs(s - target) < tolerance then
	begin
	  t2 := t;
	  break;
	end;
	if s > target then
	begin
	  a1 := t;
	  s1 := s;
	end
	else
	begin
	  a2 := t;
	  s2 := s;
	end;
	if root_iter_count = 50 then
	break;
      end;
      b2_toi_max_root_iters := b2_max(b2_toi_max_root_iters, root_iter_count);
      inc(push_back_iter);
      if push_back_iter = b2_max_polygon_vertices then
      break;
    end;
    inc(iter);
    inc(b2_toi_iters);
    if done then
    break;
    if iter = max_iterations then
    begin
      output.state := b2_tois_failed;
      output.t := t1;
      break;
    end;
  end;
  distance_input.destroy;
  b2_toi_max_iters := b2_max(b2_toi_max_iters, iter);
  time := timer.get_milliseconds;
  b2_toi_max_time := b2_max(b2_toi_max_time, time);
  b2_toi_time += time;
end;

function b2_mix_friction(const friction1, friction2: tb2_float32): tb2_float32;
begin
  result := b2_sqrt(friction1 * friction2);
end;

function b2_mix_restitution(const restitution1, restitution2: tb2_float32): tb2_float32;
begin
  result := b2_max(restitution1, restitution2);
end;

function b2_alloc(const size: tb2_int32): tb2_ptr;
begin
  result := sysgetmem(size);
end;

procedure b2_free(var mem: tb2_ptr);
begin
  sysfreemem(mem);
  mem := nil;
end;

procedure b2_log(const msg: string);
begin
  writeln(msg);
end;

function b2_is_valid(const x: tb2_float32): boolean;
begin
  result := (pb2_int32(@x)^ and $7f800000) <> $7f800000;
end;

function b2_inv_sqrt(const x: tb2_float32): tb2_float32;
  var _x, xhalf: tb2_float32;
  var i: tb2_int32 absolute _x;
begin
  _x := x;
  xhalf := 0.5 * x;
  i := $5f3759df - (i shr 1);
  result := _x * (1.5 - xhalf * _x * _x);
end;

function b2_sqrt(const x: tb2_float32): tb2_float32;
begin
  result := sqrt(x);
end;

function b2_atan2(const y, x: tb2_float32): tb2_float32;
begin
  result := arctan2(y, x);
  //if x = 0 then
  //begin
  //  if y = 0 then result := 0.0
  //  else if y > 0 then result := b2_pi * 0.5
  //  else if y < 0 then result := -b2_pi * 0.5;
  //end
  //else
  //result := arctan(y / x);
  //if x < 0.0 then
  //result := result + b2_pi;
  //if result > b2_pi then
  //result := result - 2 * b2_pi;
end;

function b2_body_def: tb2_body_def;
begin
  with result do
  begin
    user_data := nil;
    position.set_value(0.0, 0.0);
    angle := 0.0;
    linear_velocity.set_value(0.0, 0.0);
    angular_velocity := 0.0;
    linear_damping := 0.0;
    angular_damping := 0.0;
    allow_sleep := true;
    awake := true;
    fixed_rotation := false;
    bullet := false;
    body_type := b2_static_body;
    active := true;
    gravity_scale := 1.0;
  end;
end;

function b2_fixture_def: tb2_fixture_def;
begin
  with result do
  begin
    shape := nil;
    user_data := nil;
    friction := 0.2;
    restitution := 0.0;
    density := 0.0;
    is_sensor := false;
    filter := b2_filter;
  end;
end;

function b2_joint_def: tb2_joint_def;
begin
  with result do
  begin
    joint_type := b2_jt_unknown_joint;
    user_data := nil;
    body_a := nil;
    body_b := nil;
    collide_connected := false;
  end;
end;

function b2_distance_joint_def: tb2_distance_joint_def;
begin
  tb2_joint_def(result) := b2_joint_def;
  with result do
  begin
    joint_type := b2_jt_distance_joint;
    local_anchor_a.set_value(0.0, 0.0);
    local_anchor_b.set_value(0.0, 0.0);
    len := 1.0;
    frequency_hz := 0.0;
    damping_ratio := 0.0;
  end;
end;

function b2_wheel_joint_def: tb2_wheel_joint_def;
begin
  tb2_joint_def(result) := b2_joint_def;
  with result do
  begin
    joint_type := b2_jt_wheel_joint;
    local_anchor_a.set_zero;
    local_anchor_b.set_zero;
    local_axis_a.set_value(1.0, 0.0);
    enable_motor := false;
    max_motor_torque := 0.0;
    motor_speed := 0.0;
    frequency_hz := 2.0;
    damping_ratio := 0.7;
  end;
end;

function b2_mouse_joint_def: tb2_mouse_joint_def;
begin
  tb2_joint_def(result) := b2_joint_def;
  with result do
  begin
    joint_type := b2_jt_mouse_joint;
    target.set_value(0.0, 0.0);
    max_force := 0.0;
    frequency_hz := 5.0;
    damping_ratio := 0.7;
  end;
end;

function b2_revolute_joint_def: tb2_revolute_joint_def;
begin
  tb2_joint_def(result) := b2_joint_def;
  with result do
  begin
    joint_type := b2_jt_revolute_joint;
    local_anchor_a.set_value(0.0, 0.0);
    local_anchor_b.set_value(0.0, 0.0);
    reference_angle := 0.0;
    lower_angle := 0.0;
    upper_angle := 0.0;
    max_motor_torque := 0.0;
    motor_speed := 0.0;
    enable_limit := false;
    enable_motor := false;
  end;
end;

function b2_prismatic_joint_def: tb2_prismatic_joint_def;
begin
  tb2_joint_def(result) := b2_joint_def;
  with Result do
  begin
    joint_type := b2_jt_prismatic_joint;
    local_anchor_a.set_zero;
    local_anchor_b.set_zero;
    local_axis_a.set_value(1.0, 0.0);
    reference_angle := 0.0;
    enable_limit := false;
    lower_translation := 0.0;
    upper_translation := 0.0;
    enable_motor := false;
    max_motor_force := 0.0;
    motor_speed := 0.0;
  end;
end;

function b2_pulley_joint_def: tb2_pulley_joint_def;
begin
  tb2_joint_def(result) := b2_joint_def;
  with result do
  begin
    joint_type := b2_jt_pulley_joint;
    ground_anchor_a.set_value(-1.0, 1.0);
    ground_anchor_b.set_value(1.0, 1.0);
    local_anchor_a.set_value(-1.0, 0.0);
    local_anchor_b.set_value(1.0, 0.0);
    length_a := 0.0;
    length_b := 0.0;
    ratio := 1.0;
    collide_connected := true;
  end;
end;

function b2_gear_joint_def: tb2_gear_joint_def;
begin
  tb2_joint_def(result) := b2_joint_def;
  with result do
  begin
    joint_type := b2_jt_gear_joint;
    joint1 := nil;
    joint2 := nil;
    ratio := 1.0;
  end;
end;

function b2_weld_joint_def: tb2_weld_joint_def;
begin
  tb2_joint_def(result) := b2_joint_def;
  with result do
  begin
    joint_type := b2_jt_weld_joint;
    local_anchor_a.set_value(0.0, 0.0);
    local_anchor_b.set_value(0.0, 0.0);
    reference_angle := 0.0;
    frequency_hz := 0.0;
    damping_ratio := 0.0;
  end;
end;

function b2_rope_joint_def: tb2_rope_joint_def;
begin
  tb2_joint_def(result) := b2_joint_def;
  with result do
  begin
    joint_type := b2_jt_rope_joint;
    local_anchor_a.set_value(-1.0, 0.0);
    local_anchor_b.set_value(1.0, 0.0);
    max_length := 0.0;
  end;
end;

function b2_motor_joint_def: tb2_motor_joint_def;
begin
  tb2_joint_def(result) := b2_joint_def;
  with result do
  begin
    joint_type := b2_jt_motor_joint;
    linear_offset.set_zero;
    angular_offset := 0.0;
    max_force := 1.0;
    max_torque := 1.0;
    correction_factor := 0.3;
  end;
end;

function b2_friction_joint_def: tb2_friction_joint_def;
begin
  tb2_joint_def(result) := b2_joint_def;
  with result do
  begin
    joint_type := b2_jt_friction_joint;
    local_anchor_a.set_zero;
    local_anchor_b.set_zero;
    max_force := 0.0;
    max_torque := 0.0;
  end;
end;

function b2_filter: tb2_filter;
begin
  with result do
  begin
    category_bits := $0001;
    mask_bits := $FFFF;
    group_index := 0;
  end;
end;

function b2_vec2(const x, y: tb2_float32): tb2_vec2;
begin
  {$warnings off}
  result.set_value(x, y);
  {$warnings on}
end;

function b2_vec2_zero: tb2_vec2;
begin
  {$warnings off}
  result.set_zero;
  {$warnings on}
end;

function b2_dot(const v0, v1: tb2_vec2): tb2_float32;
begin
  result := v0.x * v1.x + v0.y * v1.y;
end;

function b2_cross(const v0, v1: tb2_vec2): tb2_float32;
begin
  result := v0.x * v1.y - v0.y * v1.x;
end;

function b2_cross(const v: tb2_vec2; const s: tb2_float32): tb2_vec2;
begin
  {$warnings off}
  result.set_value(s * v.y, -s * v.x);
  {$warnings on}
end;

function b2_cross(const s: tb2_float32; const v: tb2_vec2): tb2_vec2;
begin
  {$warnings off}
  result.set_value(-s * v.y, s * v.x);
  {$warnings on}
end;

function b2_mul(const m: tb2_mat22; const v: tb2_vec2): tb2_vec2;
begin
  {$warnings off}
  result.set_value(m.ex.x * v.x + m.ey.x * v.y, m.ex.y * v.x + m.ey.y * v.y);
  {$warnings on}
end;

function b2_mul_t(const m: tb2_mat22; const v: tb2_vec2): tb2_vec2;
begin
  {$warnings off}
  result.set_value(b2_dot(v, m.ex), b2_dot(v, m.ey));
  {$warnings on}
end;

function b2_distance(const v0: tb2_vec2; const v1: tb2_vec2): tb2_float32;
begin
  result := (v0 - v1).len;
end;

function b2_distance_sq(const v0: tb2_vec2; const v1: tb2_vec2): tb2_float32;
begin
  result := (v0 - v1).len_sq;
end;

function b2_vec3(const x, y, z: tb2_float32): tb2_vec3;
begin
  {$warnings off}
  result.set_value(x, y, z);
  {$warnings on}
end;

function b2_vec3_zero: tb2_vec3;
begin
  {$warnings off}
  result.set_zero;
  {$warnings on}
end;

function b2_dot(const v0, v1: tb2_vec3): tb2_float32;
begin
  result := v0.x * v1.x + v0.y * v1.y + v0.z * v1.z;
end;

function b2_cross(const v0, v1: tb2_vec3): tb2_vec3;
begin
  {$warnings off}
  result.set_value(v0.y * v1.z - v0.z * v1.y, v0.z * v1.x - v0.x * v1.z, v0.x * v1.y - v0.y * v1.x);
  {$warnings on}
end;

function b2_mat22(const c0, c1: tb2_vec2): tb2_mat22;
begin
  {$warnings off}
  result.set_value(c0, c1);
  {$warnings on}
end;

function b2_mat22(const e00, e01, e10, e11: tb2_float32): tb2_mat22;
begin
  {$warnings off}
  result.set_value(e00, e01, e10, e11);
  {$warnings on}
end;

function b2_mul(const m0, m1: tb2_mat22): tb2_mat22;
begin
  {$warnings off}
  result.set_value(b2_mul(m0, m1.ex), b2_mul(m0, m1.ey));
  {$warnings on}
end;

function b2_mul_t(const m0, m1: tb2_mat22): tb2_mat22;
begin
  {$warnings off}
  result.set_value(
    b2_vec2(b2_dot(m0.ex, m1.ex), b2_dot(m0.ey, m1.ex)),
    b2_vec2(b2_dot(m0.ex, m1.ey), b2_dot(m0.ey, m1.ey))
  );
  {$warnings on}
end;

function b2_mul(const m0: tb2_mat33; const v0: tb2_vec3): tb2_vec3;
begin
  result := v0.x * m0.ex + v0.y * m0.ey + v0.z * m0.ez;
end;

function b2_mul22(const m0: tb2_mat33; const v0: tb2_vec2): tb2_vec2;
begin
  {$warnings off}
  result.set_value(m0.ex.x * v0.x + m0.ey.x * v0.y, m0.ex.y * v0.x + m0.ey.y * v0.y);
  {$warnings on}
end;

function b2_mul(const q0, q1: tb2_rot): tb2_rot;
begin
  {$warnings off}
  result.set_value(q0.s * q1.c + q0.c * q1.s, q0.c * q1.c - q0.s * q1.s);
  {$warnings on}
end;

function b2_mul_t(const q0, q1: tb2_rot): tb2_rot;
begin
  {$warnings off}
  result.set_value(q0.c * q1.s - q0.s * q1.c, q0.c * q1.c + q0.s * q1.s);
  {$warnings on}
end;

function b2_mul(const q0: tb2_rot; const v0: tb2_vec2): tb2_vec2;
begin
  {$warnings off}
  result.set_value(q0.c * v0.x - q0.s * v0.y, q0.s * v0.x + q0.c * v0.y);
  {$warnings on}
end;

function b2_mul_t(const q0: tb2_rot; const v0: tb2_vec2): tb2_vec2;
begin
  {$warnings off}
  result.set_value(q0.c * v0.x + q0.s * v0.y, -q0.s * v0.x + q0.c * v0.y);
  {$warnings on}
end;

function b2_mul(const x0: tb2_transform; const v0: tb2_vec2): tb2_vec2;
begin
  {$warnings off}
  result.set_value(
    (x0.q.c * v0.x - x0.q.s * v0.y) + x0.p.x,
    (x0.q.s * v0.x + x0.q.c * v0.y) + x0.p.y
  );
  {$warnings on}
end;

function b2_mul_t(const x0: tb2_transform; const v0: tb2_vec2): tb2_vec2;
  var px, py: tb2_float32;
begin
  px := v0.x - x0.p.x;
  py := v0.y - x0.p.y;
  {$warnings off}
  result.set_value(x0.q.c * px + x0.q.s * py, -x0.q.s * px + x0.q.c * py);
  {$warnings on}
end;

function b2_mul(const x0, x1: tb2_transform): tb2_transform;
begin
  {$warnings off}
  result.set_value(
     b2_mul(x0.q, x1.p) + x0.p,
     b2_mul(x0.q, x1.q)
  );
  {$warnings on}
end;

function b2_mul_t(const x0, x1: tb2_transform): tb2_transform;
begin
  {$warnings off}
  result.set_value(
    b2_mul_t(x0.q, x1.p - x0.p),
    b2_mul_t(x0.q, x1.q)
  );
  {$warnings on}
end;

function b2_abs(const s: tb2_float32): tb2_float32;
begin
  result := abs(s);
end;

function b2_abs(const i: tb2_int32): tb2_int32;
begin
  result := abs(i);
end;

function b2_abs(const v0: tb2_vec2): tb2_vec2;
begin
  {$warnings off}
  result.set_value(b2_abs(v0.x), b2_abs(v0.y));
  {$warnings on}
end;

function b2_abs(const m0: tb2_mat22): tb2_mat22;
begin
  {$warnings off}
  result.set_value(b2_abs(m0.ex), b2_abs(m0.ey));
  {$warnings on}
end;

function b2_min(const s0, s1: tb2_int32): tb2_int32;
begin
  result := min(s0, s1);
end;

function b2_min(const s0, s1: tb2_uint32): tb2_uint32;
begin
  result := min(s0, s1);
end;

function b2_min(const s0, s1: tb2_float32): tb2_float32;
begin
  result := min(s0, s1);
end;

function b2_min(const v0, v1: tb2_vec2): tb2_vec2;
begin
  {$warnings off}
  result.set_value(b2_min(v0.x, v1.x), b2_min(v0.y, v1.y));
  {$warnings on}
end;

function b2_max(const s0, s1: tb2_int32): tb2_int32;
begin
  result := max(s0, s1);
end;

function b2_max(const s0, s1: tb2_uint32): tb2_uint32;
begin
  result := max(s0, s1);
end;

function b2_max(const s0, s1: tb2_float32): tb2_float32;
begin
  result := max(s0, s1);
end;

function b2_max(const v0, v1: tb2_vec2): tb2_vec2;
begin
  {$warnings off}
  result.set_value(b2_max(v0.x, v1.x), b2_max(v0.y, v1.y));
  {$warnings on}
end;

function b2_clamp(const s, l, h: tb2_float32): tb2_float32;
begin
  result := b2_max(l, b2_min(s, h));
end;

function b2_clamp(const s, l, h: tb2_vec2): tb2_vec2;
begin
  result := b2_max(l, b2_min(s, h));
end;

procedure b2_swap(var s0, s1: tb2_float32);
  var tmp: tb2_float32;
begin
  tmp := s0;
  s0 := s1;
  s1 := tmp;
end;

procedure b2_swap(var s0, s1: tb2_vec2);
  var tmp: tb2_vec2;
begin
  tmp := s0;
  s0 := s1;
  s1 := tmp;
end;

procedure b2_swap(var s0, s1: tb2_vec3);
  var tmp: tb2_vec3;
begin
  tmp := s0;
  s0 := s1;
  s1 := tmp;
end;

procedure b2_swap(var s0, s1: tb2_rot);
  var tmp: tb2_rot;
begin
  tmp := s0;
  s0 := s1;
  s1 := tmp;
end;

procedure b2_swap(var s0, s1: tb2_mat22);
  var tmp: tb2_mat22;
begin
  tmp := s0;
  s0 := s1;
  s1 := tmp;
end;

procedure b2_swap(var s0, s1: tb2_mat33);
  var tmp: tb2_mat33;
begin
  tmp := s0;
  s0 := s1;
  s1 := tmp;
end;

procedure b2_swap(var s0, s1: tb2_transform);
  var tmp: tb2_transform;
begin
  tmp := s0;
  s0 := s1;
  s1 := tmp;
end;

function b2_next_power_of_two(const n: tb2_uint32): tb2_uint32;
begin
  result := n;
  result := result or (result shr 1);
  result := result or (result shr 2);
  result := result or (result shr 4);
  result := result or (result shr 8);
  result := result or (result shr 16);
  result += 1;
end;

function b2_is_power_of_two(const n: tb2_uint32): boolean;
begin
  result := (n > 0) and ((n and (n - 1)) = 0);
end;

function b2_color(const r, g, b: tb2_float32; const a: tb2_float32): tb2_color;
begin
  {$warnings off}
  result.set_value(r, g, b, a);
  {$warnings on}
end;

operator - (const v0: tb2_vec2): tb2_vec2;
begin
  result.x := -v0.x;
  result.y := -v0.y;
end;

operator = (const v0, v1: tb2_vec2): boolean;
begin
  result := (v0.x = v1.x) and (v0.y = v1.y);
end;

operator + (const v0, v1: tb2_vec2): tb2_vec2;
begin
  result.x := v0.x + v1.x;
  result.y := v0.y + v1.y;
end;

operator - (const v0, v1: tb2_vec2): tb2_vec2;
begin
  result.x := v0.x - v1.x;
  result.y := v0.y - v1.y;
end;

operator + (const v0: tb2_vec2; const s: tb2_float32): tb2_vec2;
begin
  result.x := v0.x + s;
  result.y := v0.y + s;
end;

operator + (const s: tb2_float32; const v0: tb2_vec2): tb2_vec2;
begin
  result.x := v0.x + s;
  result.y := v0.y + s;
end;

operator - (const v0: tb2_vec2; const s: tb2_float32): tb2_vec2;
begin
  result.x := v0.x - s;
  result.y := v0.y - s;
end;

operator * (const v0: tb2_vec2; const s: tb2_float32): tb2_vec2;
begin
  result.x := v0.x * s;
  result.y := v0.y * s;
end;

operator * (const s: tb2_float32; const v0: tb2_vec2): tb2_vec2;
begin
  result.x := v0.x * s;
  result.y := v0.y * s;
end;

operator / (const v0: tb2_vec2; const s: tb2_float32): tb2_vec2;
  var rcp: tb2_float32;
begin
  rcp := 1 / s;
  result.x := v0.x * rcp;
  result.y := v0.y * rcp;
end;

operator - (const v0: tb2_vec3): tb2_vec3;
begin
  result.x := -v0.x;
  result.y := -v0.y;
  result.z := -v0.z;
end;

operator = (const v0, v1: tb2_vec3): boolean;
begin
  result := (v0.x = v1.x) and (v0.y = v1.y) and (v0.z = v1.z);
end;

operator + (const v0, v1: tb2_vec3): tb2_vec3;
begin
  result.x := v0.x + v1.x;
  result.y := v0.y + v1.y;
  result.z := v0.z + v1.z;
end;

operator - (const v0, v1: tb2_vec3): tb2_vec3;
begin
  result.x := v0.x - v1.x;
  result.y := v0.y - v1.y;
  result.z := v0.z - v1.z;
end;

operator + (const v0: tb2_vec3; const s: tb2_float32): tb2_vec3;
begin
  result.x := v0.x + s;
  result.y := v0.y + s;
  result.z := v0.z + s;
end;

operator + (const s: tb2_float32; const v0: tb2_vec3): tb2_vec3;
begin
  result.x := v0.x + s;
  result.y := v0.y + s;
  result.z := v0.z + s;
end;

operator - (const v0: tb2_vec3; const s: tb2_float32): tb2_vec3;
begin
  result.x := v0.x - s;
  result.y := v0.y - s;
  result.z := v0.z - s;
end;

operator * (const v0: tb2_vec3; const s: tb2_float32): tb2_vec3;
begin
  result.x := v0.x * s;
  result.y := v0.y * s;
  result.z := v0.z * s;
end;

operator * (const s: tb2_float32; const v0: tb2_vec3): tb2_vec3;
begin
  result.x := v0.x * s;
  result.y := v0.y * s;
  result.z := v0.z * s;
end;

operator / (const v0: tb2_vec3; const s: tb2_float32): tb2_vec3;
  var rcp: tb2_float32;
begin
  rcp := 1 / s;
  result.x := v0.x * rcp;
  result.y := v0.y * rcp;
  result.z := v0.z * rcp;
end;

operator + (const m0, m1: tb2_mat22): tb2_mat22;
begin
  result := b2_mat22(m0.ex + m1.ex, m0.ey + m1.ey);
end;

initialization
begin
  b2_default_filter := tb2_contact_filter.create;
  b2_default_listener := tb2_contact_listener.create;
end;

finalization
begin
  b2_default_filter.free;
  b2_default_listener.free;
end;

end.
