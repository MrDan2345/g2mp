unit G2Math;
{$include Gen2MP.inc}
interface

uses
  Math,
  Types,
  SysUtils,
  G2Types;

type
  TG2MatRef = array[0..15] of TG2Float;
  PG2MatRef = ^TG2MatRef;
  TG2Vec2Ref = array[0..1] of TG2Float;
  PG2Vec2Ref = ^TG2Vec2Ref;
  TG2Vec3Ref = array[0..2] of TG2Float;
  PG2Vec3Ref = ^TG2Vec3Ref;
  TG2Vec4Ref = array[0..3] of TG2Float;
  PG2Vec4Ref = ^TG2Vec4Ref;
  TG2QuatRef = array[0..3] of TG2Float;
  PG2QuatRef = ^TG2QuatRef;

  PG2Mat = ^TG2Mat;
  TG2Mat = object
  private
    function GetMat(const ix, iy: TG2IntS32): TG2Float; inline;
    procedure SetMat(const ix, iy: TG2IntS32; const Value: TG2Float); inline;
  public
    Arr: array [0..15] of TG2Float;
    property e00: TG2Float read Arr[0] write Arr[0];
    property e01: TG2Float read Arr[1] write Arr[1];
    property e02: TG2Float read Arr[2] write Arr[2];
    property e03: TG2Float read Arr[3] write Arr[3];
    property e10: TG2Float read Arr[4] write Arr[4];
    property e11: TG2Float read Arr[5] write Arr[5];
    property e12: TG2Float read Arr[6] write Arr[6];
    property e13: TG2Float read Arr[7] write Arr[7];
    property e20: TG2Float read Arr[8] write Arr[8];
    property e21: TG2Float read Arr[9] write Arr[9];
    property e22: TG2Float read Arr[10] write Arr[10];
    property e23: TG2Float read Arr[11] write Arr[11];
    property e30: TG2Float read Arr[12] write Arr[12];
    property e31: TG2Float read Arr[13] write Arr[13];
    property e32: TG2Float read Arr[14] write Arr[14];
    property e33: TG2Float read Arr[15] write Arr[15];
    property Mat[const ix, iy: TG2IntS32]: TG2Float read GetMat write SetMat; default;
    procedure SetValue(
      const m00, m10, m20, m30: TG2Float;
      const m01, m11, m21, m31: TG2Float;
      const m02, m12, m22, m32: TG2Float;
      const m03, m13, m23, m33: TG2Float
    ); overload; inline;
    function ToStr: AnsiString;
  end;
  TG2MatArr = array[Word] of TG2Mat;
  PG2MatArr = ^TG2MatArr;

  PG2Vec2 = ^TG2Vec2;
  TG2Vec2 = object
  private
    function GetArr(const Index: TG2IntS32): TG2Float; inline;
    procedure SetArr(const Index: TG2IntS32; const Value: TG2Float); inline;
  public
    x, y: TG2Float;
    property Arr[const Index: TG2IntS32]: TG2Float read GetArr write SetArr; default;
    procedure SetValue(const vx, vy: TG2Float); inline;
    function Norm: TG2Vec2;
    function Dot(const v: TG2Vec2): TG2Float;
    function Cross(const v: TG2Vec2): TG2Float;
    function Angle(const v: TG2Vec2): TG2Float;
    function AngleOX: TG2Float;
    function AngleOY: TG2Float;
    function Len: TG2Float;
    function LenSq: TG2Float;
    function Perp: TG2Vec2;
    function Reflect(const n: TG2Vec2): TG2Vec2;
    function Transform3x3(const m: TG2Mat): TG2Vec2;
    function Transform4x3(const m: TG2Mat): TG2Vec2;
    function Transform4x4(const m: TG2Mat): TG2Vec2;
  end;

  PG2Vec3 = ^TG2Vec3;
  TG2Vec3 = object
  private
    function GetArr(const Index: TG2IntS32): TG2Float; inline;
    procedure SetArr(const Index: TG2IntS32; const Value: TG2Float); inline;
  public
    x, y, z: TG2Float;
    property Arr[const Index: TG2IntS32]: TG2Float read GetArr write SetArr; default;
    procedure SetValue(const vx, vy, vz: TG2Float); inline;
    function Norm: TG2Vec3;
    function Dot(const v: TG2Vec3): TG2Float;
    function Cross(const v: TG2Vec3): TG2Vec3;
    function Len: TG2Float;
    function LenSq: TG2Float;
    function Transform3x3(const m: TG2Mat): TG2Vec3;
    function Transform4x3(const m: TG2Mat): TG2Vec3;
    function Transform4x4(const m: TG2Mat): TG2Vec3;
  end;

  PG2Vec4 = ^TG2Vec4;
  TG2Vec4 = object
  private
    function GetArr(const Index: TG2IntS32): TG2Float; inline;
    procedure SetArr(const Index: TG2IntS32; const Value: TG2Float); inline;
  public
    x, y, z, w: TG2Float;
    property Arr[const Index: TG2IntS32]: TG2Float read GetArr write SetArr; default;
    procedure SetValue(const vx, vy, vz, vw: TG2Float); inline;
  end;

  PG2Quat = ^TG2Quat;
  TG2Quat = object
  private
    function GetArr(const Index: TG2IntS32): TG2Float; inline;
    procedure SetArr(const Index: TG2IntS32; const Value: TG2Float); inline;
  public
    x, y, z, w: TG2Float;
    property Arr[const Index: TG2IntS32]: TG2Float read GetArr write SetArr; default;
    procedure SetValue(const qx, qy, qz, qw: TG2Float); inline;
  end;

  PG2Box = ^TG2Box;
  TG2Box = object
  private
    function GetArr(const Index: TG2IntS32): TG2Float; inline;
    procedure SetArr(const Index: TG2IntS32; const Value: TG2Float); inline;
  public
    c, vx, vy, vz: TG2Vec3;
    property Arr[const Index: TG2IntS32]: TG2Float read GetArr write SetArr; default;
    procedure SetValue(const bc, bx, by, bz: TG2Vec3); inline;
    function Transform(const m: TG2Mat): TG2Box;
  end;

  PG2AABox = ^TG2AABox;
  TG2AABox = object
  private
    function GetArr(const Index: TG2IntS32): TG2Float; inline;
    procedure SetArr(const Index: TG2IntS32; const Value: TG2Float); inline;
  public
    MinV, MaxV: TG2Vec3;
    property Arr[const Index: TG2IntS32]: TG2Float read GetArr write SetArr; default;
    procedure SetValue(const BMinV, BMaxV: TG2Vec3); inline; overload;
    procedure SetValue(const v: TG2Vec3); inline; overload;
    procedure Include(const v: TG2Vec3); inline; overload;
    procedure Include(const b: TG2AABox); inline; overload;
    procedure Merge(const b: TG2AABox);
    function Intersect(const b: TG2AABox): Boolean; inline;
  end;

  PG2Sphere = ^TG2Sphere;
  TG2Sphere = object
  private
    function GetArr(const Index: TG2IntS32): TG2Float; inline;
    procedure SetArr(const Index: TG2IntS32; const Value: TG2Float); inline;
  public
    c: TG2Vec3;
    r: TG2Float;
    property Arr[const Index: TG2IntS32]: TG2Float read GetArr write SetArr; default;
    procedure SetValue(const sc: TG2Vec3; const sr: TG2Float); inline;
  end;

  PG2Plane = ^TG2Plane;
  TG2Plane = object
  private
    function GetArr(const Index: TG2IntS32): TG2Float; inline;
    procedure SetArr(const Index: TG2IntS32; const Value: TG2Float); inline;
    function GetA: TG2Float; inline;
    procedure SetA(const Value: TG2Float); inline;
    function GetB: TG2Float; inline;
    procedure SetB(const Value: TG2Float); inline;
    function GetC: TG2Float; inline;
    procedure SetC(const Value: TG2Float); inline;
  public
    n: TG2Vec3;
    d: TG2Float;
    property Arr[const Index: TG2IntS32]: TG2Float read GetArr write SetArr; default;
    property a: TG2Float read GetA write SetA;
    property b: TG2Float read GetB write SetB;
    property c: TG2Float read GetC write SetC;
    procedure SetValue(const pa, pb, pc, pd: TG2Float); overload; inline;
    procedure SetValue(const pn: TG2Vec3; const pd: TG2Float); overload; inline;
    procedure SetValue(const v0, v1, v2: TG2Vec3); overload; inline;
  end;

  PG2Ray = ^TG2Ray;
  TG2Ray = object
  private
    function GetArr(const Index: TG2IntS32): TG2Float; inline;
    procedure SetArr(const Index: TG2IntS32; const Value: TG2Float); inline;
  public
    Origin: TG2Vec3;
    Dir: TG2Vec3;
    property Arr[const Index: TG2IntS32]: TG2Float read GetArr write SetArr; default;
    procedure SetValue(const ROrigin, RDir: TG2Vec3); inline;
  end;

  TG2FrustumCheck = (
    fcInside,
    fcIntersect,
    fcOutside
  );

  PG2Frustum = ^TG2Frustum;
  TG2Frustum = object
  private
    _Planes: array[0..5] of TG2Plane;
    _RefV: PG2Mat;
    _RefP: PG2Mat;
    function GetPlane(const Index: TG2IntS32): PG2Plane; inline;
    procedure Normalize; inline;
    function DistanceToPoint(const PlaneIndex: TG2IntS32; const Pt: TG2Vec3): TG2Float; inline;
  public
    property RefV: PG2Mat read _RefV write _RefV;
    property RefP: PG2Mat read _RefP write _RefP;
    property Planes[const Index: TG2IntS32]: PG2Plane read GetPlane;
    procedure Update;
    procedure ExtractPoints(const OutV: PG2Vec3);
    function IntersectFrustum(const Frustum: TG2Frustum): Boolean;
    function CheckSphere(const Center: TG2Vec3; const Radius: TG2Float): TG2FrustumCheck; overload;
    function CheckSphere(const Sphere: TG2Sphere): TG2FrustumCheck; overload;
    function CheckBox(const MinV, MaxV: TG2Vec3): TG2FrustumCheck; overload;
    function CheckBox(const Box: TG2AABox): TG2FrustumCheck; overload;
  end;

  { TG2Rect }

  TG2Rect = object
  private
    procedure SetX(const Value: TG2Float); inline;
    procedure SetY(const Value: TG2Float); inline;
    procedure SetWidth(const Value: TG2Float); inline;
    function GetWidth: TG2Float; inline;
    procedure SetHeight(const Value: TG2Float); inline;
    function GetHeight: TG2Float; inline;
    procedure SetTopLeft(const Value: TG2Vec2); inline;
    function GetTopLeft: TG2Vec2; inline;
    procedure SetTopRight(const Value: TG2Vec2); inline;
    function GetTopRight: TG2Vec2; inline;
    procedure SetBottomLeft(const Value: TG2Vec2); inline;
    function GetBottomLeft: TG2Vec2; inline;
    procedure SetBottomRight(const Value: TG2Vec2); inline;
    function GetBottomRight: TG2Vec2; inline;
    function GetCenter: TG2Vec2; inline;
  public
    Left: TG2Float;
    Top: TG2Float;
    Right: TG2Float;
    Bottom: TG2Float;
    property x: TG2Float read Left write SetX;
    property y: TG2Float read Top write SetY;
    property l: TG2Float read Left write Left;
    property t: TG2Float read Top write Top;
    property r: TG2Float read Right write Right;
    property b: TG2Float read Bottom write Bottom;
    property w: TG2Float read GetWidth write SetWidth;
    property h: TG2Float read GetHeight write SetHeight;
    property tl: TG2Vec2 read GetTopLeft write SetTopLeft;
    property tr: TG2Vec2 read GetTopRight write SetTopRight;
    property bl: TG2Vec2 read GetBottomLeft write SetBottomLeft;
    property br: TG2Vec2 read GetBottomRight write SetBottomRight;
    property Width: TG2Float read GetWidth write SetWidth;
    property Height: TG2Float read GetHeight write SetHeight;
    property TopLeft: TG2Vec2 read GetTopLeft write SetTopLeft;
    property TopRight: TG2Vec2 read GetTopRight write SetTopRight;
    property BottomLeft: TG2Vec2 read GetBottomLeft write SetBottomLeft;
    property BottomRight: TG2Vec2 read GetBottomRight write SetBottomRight;
    property Center: TG2Vec2 read GetCenter;
    function Contains(const v: TG2Vec2): Boolean; inline; overload;
    function Contains(const vx, vy: TG2Float): Boolean; inline; overload;
    function Clip(const ClipRect: TG2Rect): TG2Rect; inline;
    function Expand(const Dimensions: TG2Vec2): TG2Rect; inline; overload;
    function Expand(const dx, dy: TG2Float): TG2Rect; inline; overload;
  end;
  PG2Rect = ^TG2Rect;

  TG2Vec2Arr = array[Word] of TG2Vec2;
  PG2Vec2Arr = ^TG2Vec2Arr;

  TG2PolyTriang = record
    v: array of TG2Vec2;
    Triangles: array of array[0..2] of TG2IntS32;
  end;
  PG2PolyTriang = ^TG2PolyTriang;

  operator := (v: TG2Vec2) vr: TG2Vec2Ref;
  operator := (vr: TG2Vec2Ref) v: TG2Vec2;
  operator := (v: TG2Vec2) pr: TPoint;
  operator := (p: TPoint) vr: TG2Vec2;
  operator := (v: TG2Vec3) vr: TG2Vec3Ref;
  operator := (vr: TG2Vec3Ref) v: TG2Vec3;
  operator := (m: TG2Mat) mr: TG2MatRef;
  operator := (mr: TG2MatRef) m: TG2Mat;
  operator := (r: TG2Rect) rr: TRect;
  operator := (r: TRect) rr: TG2Rect;
  operator := (b: TG2Box) rb: TG2AABox;
  operator := (b: TG2AABox) rb: TG2Box;
  operator := (c: TG2Color) rv: TG2Vec4;
  operator := (v: TG2Vec4) rc: TG2Color;
  operator - (v: TG2Vec2) vr: TG2Vec2;
  operator - (v: TG2Vec3) vr: TG2Vec3;
  operator - (v0, v1: TG2Vec2) vr: TG2Vec2;
  operator - (v0, v1: TG2Vec3) vr: TG2Vec3;
  operator - (v: TG2Vec2; f: TG2Float) vr: TG2Vec2;
  operator - (v: TG2Vec3; f: TG2Float) vr: TG2Vec3;
  operator - (v: TG2Vec4; f: TG2Float) vr: TG2Vec4;
  operator - (v: TG2Vec2; p: TPoint) vr: TG2Vec2;
  operator - (p: TPoint; v: TG2Vec2) vr: TG2Vec2;
  operator + (v0, v1: TG2Vec2) vr: TG2Vec2;
  operator + (v0, v1: TG2Vec3) vr: TG2Vec3;
  operator + (v: TG2Vec2; f: TG2Float) vr: TG2Vec2;
  operator + (v: TG2Vec3; f: TG2Float) vr: TG2Vec3;
  operator + (v: TG2Vec4; f: TG2Float) vr: TG2Vec4;
  operator + (b: TG2AABox; v: TG2Vec3) rb: TG2AABox;
  operator + (v: TG2Vec2; p: TPoint) vr: TG2Vec2;
  operator + (p: TPoint; v: TG2Vec2) vr: TG2Vec2;
  operator * (v: TG2Vec2; f: TG2Float) vr: TG2Vec2;
  operator * (v: TG2Vec3; f: TG2Float) vr: TG2Vec3;
  operator * (v: TG2Vec2; m: TG2Mat) vr: TG2Vec2;
  operator * (v: TG2Vec3; m: TG2Mat) vr: TG2Vec3;
  operator * (m0, m1: TG2Mat) mr: TG2Mat;
  operator / (v: TG2Vec2; f: TG2Float) vr: TG2Vec2;
  operator / (v: TG2Vec3; f: TG2Float) vr: TG2Vec3;

function G2Rect(const x, y, w, h: TG2Float): TG2Rect;
function G2Vec2(const x, y: TG2Float): TG2Vec2;
function G2Vec2(const pt: TPoint): TG2Vec2;
function G2Vec2InPoly(const v: TG2Vec2; const VArr: PG2Vec2; const VCount: TG2IntS32): Boolean;
function G2Vec3(const x, y, z: TG2Float): TG2Vec3; overload;
function G2Vec3(const v2: TG2Vec2; const z: TG2Float): TG2Vec3; overload;
function G2Vec4(const x, y, z, w: TG2Float): TG2Vec4;
function G2Quat(const x, y, z, w: TG2Float): TG2Quat;
function G2Quat(const Axis: TG2Vec3; const Angle: TG2Float): TG2Quat;
function G2Quat(const m: TG2Mat): TG2Quat;
function G2QuatDot(const q0, q1: TG2Quat): TG2Float;
function G2QuatSlerp(const q0, q1: TG2Quat; const s: TG2Float): TG2Quat;
function G2Mat(
  const m00, m10, m20, m30: TG2Float;
  const m01, m11, m21, m31: TG2Float;
  const m02, m12, m22, m32: TG2Float;
  const m03, m13, m23, m33: TG2Float
): TG2Mat;
function G2Mat(const AxisX, AxisY, AxisZ, Translation: TG2Vec3): TG2Mat;
function G2MatIdentity: TG2Mat;
function G2MatScaling(const x, y, z: TG2Float): TG2Mat;
function G2MatScaling(const v: TG2Vec3): TG2Mat;
function G2MatScaling(const s: TG2Float): TG2Mat;
function G2MatTranslation(const x, y, z: TG2Float): TG2Mat;
function G2MatTranslation(const v: TG2Vec3): TG2Mat;
function G2MatRotationX(const a: TG2Float): TG2Mat;
function G2MatRotationY(const a: TG2Float): TG2Mat;
function G2MatRotationZ(const a: TG2Float): TG2Mat;
function G2MatRotation(const x, y, z, a: TG2Float): TG2Mat;
function G2MatRotation(const v: TG2Vec3; const a: TG2Float): TG2Mat;
function G2MatRotation(const q: TG2Quat): TG2Mat;
function G2MatView(const Pos, Target, Up: TG2Vec3): TG2Mat;
function G2MatOrth(const Width, Height, ZNear, ZFar: TG2Float): TG2Mat;
function G2MatOrth2D(const Width, Height, ZNear, ZFar: TG2Float; const FlipH: Boolean = False; const FlipV: Boolean = True): TG2Mat;
function G2MatProj(const FOV, Aspect, ZNear, ZFar: TG2Float): TG2Mat;
function G2MatTranspose(const m: TG2Mat): TG2Mat;
procedure G2MatDecompose(const OutScaling: PG2Vec3; const OutRotation: PG2Quat; const OutTranslation: PG2Vec3; const m: TG2Mat);

function G2Min(const f0, f1: TG2Float): TG2Float; inline; overload;
function G2Min(const v0, v1: TG2IntS32): TG2IntS32; inline; overload;
function G2Min(const v0, v1: TG2IntU32): TG2IntU32; inline; overload;
function G2Max(const f0, f1: TG2Float): TG2Float; inline; overload;
function G2Max(const v0, v1: TG2IntS32): TG2IntS32; inline; overload;
function G2Max(const v0, v1: TG2IntU32): TG2IntU32; inline; overload;
function G2Clamp(const f, LimMin, LimMax: TG2Float): TG2Float; inline;
function G2SmoothStep(const t, f0, f1: TG2Float): TG2Float; inline;
function G2LerpFloat(const v0, v1, t: TG2Float): TG2Float; inline;
function G2LerpVec2(const v0, v1: TG2Vec2; const t: TG2Float): TG2Vec2; inline;
function G2LerpVec3(const v0, v1: TG2Vec3; const t: TG2Float): TG2Vec3; inline;
function G2LerpVec4(const v0, v1: TG2Vec4; const t: TG2Float): TG2Vec4; inline;
function G2LerpQuat(const v0, v1: TG2Quat; const t: TG2Float): TG2Quat; inline;
function G2LerpColor(const c0, c1: TG2Color; const t: TG2Float): TG2Color; inline;
function G2CosrpFloat(const f0, f1: TG2Float; const s: TG2Float): TG2Float; inline;
function G2Vec2CatmullRom(const v0, v1, v2, v3: TG2Vec2; const t: TG2Float): TG2Vec2; inline;
function G2Vec3CatmullRom(const v0, v1, v2, v3: TG2Vec3; const t: TG2Float): TG2Vec3; inline;
function G2CoTan(const x: TG2Float): TG2Float;
function G2ArcCos(const x: TG2Float): TG2Float;
function G2ArcTan2(const y, x: TG2Float): TG2Float;
procedure G2SinCos(const Angle: TG2Float; var s, c: TG2Float);
function G2Vec2ToLine(const l1, l2, v: TG2Vec2; var VecOnLine: TG2Vec2; var InSegment: Boolean): TG2Float;
function G2Vec3ToLine(const l1, l2, v: TG2Vec3; var VecOnLine: TG2Vec3; var InSegment: Boolean): TG2Float;
function G2TriangleNormal(const v0, v1, v2: TG2Vec3): TG2Vec3;
function G2Intersect3Planes(const p1, p2, p3: TG2Plane): TG2Vec3;
function G2PolyTriangulate(const Triang: PG2PolyTriang): Boolean;
function G2LineVsCircle(const v0, v1, c: TG2Vec2; const r: TG2Float; var p0, p1: PG2Vec2): Boolean;
function G2LineVsLine(const l0v0, l0v1, l1v0, l1v1: TG2Vec2; var p: TG2Vec2): Boolean;
function G2LineVsLineInf(const l0v0, l0v1, l1v0, l1v1: TG2Vec2; var p: TG2Vec2): Boolean;
function G2RectVsRect(const r0, r1: TG2Rect; var Resp: TG2Vec2): Boolean;
function G2Ray2VsRect(const RayOrigin, RayDir: TG2Vec2; const R: TG2Rect; var Intersection: TG2Vec2; var Dist: TG2Float): Boolean;
function G2Ballistics(const PosOrigin, PosTarget: TG2Vec2; const TotalVelocity, Gravity: TG2Float; var Trajectory0, Trajectory1: TG2Vec2; var Time0, Time1: TG2Float): Boolean;

var G2MatAdd: procedure (const OutM, InM1, InM2: PG2Mat);
var G2MatSub: procedure (const OutM, InM1, InM2: PG2Mat);
var G2MatFltMul: procedure (const OutM, InM: PG2Mat; const s: PG2Float);
var G2MatMul: procedure (const OutM, InM1, InM2: PG2Mat);
var G2MatInv: procedure (const OutM, InM: PG2Mat);
var G2Vec3MatMul3x3: procedure (const OutV, InV: PG2Vec3; const InM: PG2Mat);
var G2Vec3MatMul4x3: procedure (const OutV, InV: PG2Vec3; const InM: PG2Mat);
var G2Vec3MatMul4x4: procedure (const OutV, InV: PG2Vec3; const InM: PG2Mat);
var G2Vec4MatMul: procedure (const OutV, InV: PG2Vec4; const InM: PG2Mat);
var G2Vec3Len: function (const InV: PG2Vec3): TG2Float;
var G2Vec4Len: function (const InV: PG2Vec4): TG2Float;
var G2Vec3Norm: procedure (const OutV, InV: PG2Vec3);
var G2Vec4Norm: procedure (const OutV, InV: PG2Vec4);
var G2Vec3Cross: procedure (const OutV, InV1, InV2: PG2Vec3);

{$ifdef G2Cpu386}procedure G2MatAddSSE(const OutM, InM1, InM2: PG2Mat); assembler;{$endif}
procedure G2MatAddStd(const OutM, InM1, InM2: PG2Mat);
{$ifdef G2Cpu386}procedure G2MatSubSSE(const OutM, InM1, InM2: PG2Mat); assembler;{$endif}
procedure G2MatSubStd(const OutM, InM1, InM2: PG2Mat);
{$ifdef G2Cpu386}procedure G2MatFltMulSSE(const OutM, InM: PG2Mat; const s: PG2Float); assembler;{$endif}
procedure G2MatFltMulStd(const OutM, InM: PG2Mat; const s: PG2Float);
{$ifdef G2Cpu386}procedure G2MatMulSSE(const OutM, InM1, InM2: PG2Mat); assembler;{$endif}
procedure G2MatMulStd(const OutM, InM1, InM2: PG2Mat);
{$ifdef G2Cpu386}procedure G2MatInvSSE(const OutM, InM: PG2Mat); assembler;{$endif}
procedure G2MatInvStd(const OutM, InM: PG2Mat);
procedure G2Vec2MatMul3x3(const OutV, InV: PG2Vec2; const InM: PG2Mat); inline;
procedure G2Vec2MatMul4x3(const OutV, InV: PG2Vec2; const InM: PG2Mat); inline;
procedure G2Vec2MatMul4x4(const OutV, InV: PG2Vec2; const InM: PG2Mat); inline;
{$ifdef G2Cpu386}procedure G2Vec3MatMul3x3SSE(const OutV, InV: PG2Vec3; const InM: PG2Mat); assembler;{$endif}
procedure G2Vec3MatMul3x3Std(const OutV, InV: PG2Vec3; const InM: PG2Mat);
{$ifdef G2Cpu386}procedure G2Vec3MatMul4x3SSE(const OutV, InV: PG2Vec3; const InM: PG2Mat); assembler;{$endif}
procedure G2Vec3MatMul4x3Std(const OutV, InV: PG2Vec3; const InM: PG2Mat);
{$ifdef G2Cpu386}procedure G2Vec3MatMul4x4SSE(const OutV, InV: PG2Vec3; const InM: PG2Mat); assembler;{$endif}
procedure G2Vec3MatMul4x4Std(const OutV, InV: PG2Vec3; const InM: PG2Mat);
{$ifdef G2Cpu386}procedure G2Vec4MatMulSSE(const OutV, InV: PG2Vec4; const InM: PG2Mat); assembler;{$endif}
procedure G2Vec4MatMulStd(const OutV, InV: PG2Vec4; const InM: PG2Mat);
{$ifdef G2Cpu386}function G2Vec3LenSSE(const InV: PG2Vec3): TG2Float; assembler;{$endif}
function G2Vec3LenStd(const InV: PG2Vec3): TG2Float;
{$ifdef G2Cpu386}function G2Vec4LenSSE(const InV: PG2Vec4): TG2Float; assembler;{$endif}
function G2Vec4LenStd(const InV: PG2Vec4): TG2Float;
procedure G2Vec2Norm(const OutV, InV: PG2Vec2); inline;
{$ifdef G2Cpu386}procedure G2Vec3NormSSE(const OutV, InV: PG2Vec3); assembler;{$endif}
procedure G2Vec3NormStd(const OutV, InV: PG2Vec3);
{$ifdef G2Cpu386}procedure G2Vec4NormSSE(const OutV, InV: PG2Vec4); assembler;{$endif}
procedure G2Vec4NormStd(const OutV, InV: PG2Vec4);
{$ifdef G2Cpu386}procedure G2Vec3CrossSSE(const OutV, InV1, InV2: PG2Vec3); assembler;{$endif}
procedure G2Vec3CrossStd(const OutV, InV1, InV2: PG2Vec3);

procedure G2InitializeMath;

implementation

//TG2Mat BEGIN
function TG2Mat.GetMat(const ix, iy: TG2IntS32): TG2Float;
begin
  Result := Arr[ix * 4 + iy];
end;

procedure TG2Mat.SetMat(const ix, iy: TG2IntS32; const Value: TG2Float);
begin
  Arr[ix * 4 + iy] := Value;
end;

procedure TG2Mat.SetValue(
      const m00, m10, m20, m30: TG2Float;
      const m01, m11, m21, m31: TG2Float;
      const m02, m12, m22, m32: TG2Float;
      const m03, m13, m23, m33: TG2Float
    );
begin
  Arr[0] := m00; Arr[4] := m10; Arr[8] := m20; Arr[12] := m30;
  Arr[1] := m01; Arr[5] := m11; Arr[9] := m21; Arr[13] := m31;
  Arr[2] := m02; Arr[6] := m12; Arr[10] := m22; Arr[14] := m32;
  Arr[3] := m03; Arr[7] := m13; Arr[11] := m23; Arr[15] := m33;
end;

function TG2Mat.ToStr: AnsiString;
begin
  Result := (
    'TG2Mat('#$D#$A +
    FormatFloat('0.0##', e00) + ', ' + FormatFloat('0.0##', e10) + ', ' + FormatFloat('0.0##', e20) + ', ' + FormatFloat('0.0##', e20) + ', '#$D#$A +
    FormatFloat('0.0##', e01) + ', ' + FormatFloat('0.0##', e11) + ', ' + FormatFloat('0.0##', e21) + ', ' + FormatFloat('0.0##', e21) + ', '#$D#$A +
    FormatFloat('0.0##', e02) + ', ' + FormatFloat('0.0##', e12) + ', ' + FormatFloat('0.0##', e22) + ', ' + FormatFloat('0.0##', e22) + ', '#$D#$A +
    FormatFloat('0.0##', e03) + ', ' + FormatFloat('0.0##', e13) + ', ' + FormatFloat('0.0##', e23) + ', ' + FormatFloat('0.0##', e23) + #$D#$A +
    ')'
  );
end;
//TG2Mat END

//TG2Vec2 BEGIN
function TG2Vec2.GetArr(const Index: TG2IntS32): TG2Float;
begin
  Result := PG2FloatArr(@x)^[Index];
end;

procedure TG2Vec2.SetArr(const Index: TG2IntS32; const Value: TG2Float);
begin
  PG2FloatArr(@x)^[Index] := Value;
end;

procedure TG2Vec2.SetValue(const vx, vy: TG2Float);
begin
  x := vx; y := vy;
end;

function TG2Vec2.Norm: TG2Vec2;
begin
  G2Vec2Norm(@Result, @Self);
end;

function TG2Vec2.Dot(const v: TG2Vec2): TG2Float;
begin
  Result := x * v.x + y * v.y;
end;

function TG2Vec2.Cross(const v: TG2Vec2): TG2Float;
begin
  Result := x * v.y - y * v.x;
end;

function TG2Vec2.Angle(const v: TG2Vec2): TG2Float;
  var VLen: TG2Float;
begin
  VLen := Len * v.Len;
  if VLen > 0 then
  Result := G2ArcCos(Dot(v) / VLen)
  else
  Result := 0;
end;

function TG2Vec2.AngleOX: TG2Float;
begin
  Result := G2ArcTan2(y, x);
end;

function TG2Vec2.AngleOY: TG2Float;
begin
  Result := G2ArcTan2(x, y);
end;

function TG2Vec2.Len: TG2Float;
begin
  Result := Sqrt(x * x + y * y);
end;

function TG2Vec2.LenSq: TG2Float;
begin
  Result := x * x + y * y;
end;

function TG2Vec2.Perp: TG2Vec2;
begin
  {$Warnings off}
  Result.SetValue(-y, x);
  {$Warnings on}
end;

function TG2Vec2.Reflect(const n: TG2Vec2): TG2Vec2;
  var d: TG2Float;
begin
  d := Dot(n);
  Result := Self - n * (2 * d);
end;

function TG2Vec2.Transform3x3(const m: TG2Mat): TG2Vec2;
begin
  G2Vec2MatMul3x3(@Result, @Self, @m);
end;

function TG2Vec2.Transform4x3(const m: TG2Mat): TG2Vec2;
begin
  G2Vec2MatMul4x3(@Result, @Self, @m);
end;

function TG2Vec2.Transform4x4(const m: TG2Mat): TG2Vec2;
begin
  G2Vec2MatMul4x4(@Result, @Self, @m);
end;
//TG2Vec2 END

//TG2Vec3 BEGIN
function TG2Vec3.GetArr(const Index: TG2IntS32): TG2Float;
begin
  Result := PG2FloatArr(@x)^[Index];
end;

procedure TG2Vec3.SetArr(const Index: TG2IntS32; const Value: TG2Float);
begin
  PG2FloatArr(@x)^[Index] := Value;
end;

procedure TG2Vec3.SetValue(const vx, vy, vz: TG2Float);
begin
  x := vx; y := vy; z := vz;
end;

function TG2Vec3.Norm: TG2Vec3;
begin
  G2Vec3Norm(@Result, @Self);
end;

function TG2Vec3.Dot(const v: TG2Vec3): TG2Float;
begin
  Result := x * v.x + y * v.y + z * v.z;
end;

function TG2Vec3.Cross(const v: TG2Vec3): TG2Vec3;
begin
  G2Vec3Cross(@Result, @Self, @v);
end;

function TG2Vec3.Len: TG2Float;
begin
  Result := G2Vec3Len(@Self);
end;

function TG2Vec3.LenSq: TG2Float;
begin
  Result := x * x + y * y + z * z;
end;

function TG2Vec3.Transform3x3(const m: TG2Mat): TG2Vec3;
begin
  G2Vec3MatMul3x3(@Result, @Self, @m);
end;

function TG2Vec3.Transform4x3(const m: TG2Mat): TG2Vec3;
begin
  G2Vec3MatMul4x3(@Result, @Self, @m);
end;

function TG2Vec3.Transform4x4(const m: TG2Mat): TG2Vec3;
begin
  G2Vec3MatMul4x4(@Result, @Self, @m);
end;
//TG2Vec3 END

//TG2Vec4 BEGIN
function TG2Vec4.GetArr(const Index: TG2IntS32): TG2Float;
begin
  Result := PG2FloatArr(@x)^[Index];
end;

procedure TG2Vec4.SetArr(const Index: TG2IntS32; const Value: TG2Float);
begin
  PG2FloatArr(@x)^[Index] := Value;
end;

procedure TG2Vec4.SetValue(const vx, vy, vz, vw: TG2Float);
begin
  x := vx; y := vy; z := vz; w := vw;
end;
//TG2Vec4 END

//TG2Quat BEGIN
function TG2Quat.GetArr(const Index: TG2IntS32): TG2Float;
begin
  Result := PG2FloatArr(@x)^[Index];
end;

procedure TG2Quat.SetArr(const Index: TG2IntS32; const Value: TG2Float);
begin
  PG2FloatArr(@x)^[Index] := Value;
end;

procedure TG2Quat.SetValue(const qx, qy, qz, qw: TG2Float);
begin
  x := qx; y := qy; z := qz; w := qw;
end;
//TG2Quat END

//TG2Box BEGIN
function TG2Box.GetArr(const Index: TG2IntS32): TG2Float;
begin
  Result := PG2FloatArr(@c.x)^[Index];
end;

procedure TG2Box.SetArr(const Index: TG2IntS32; const Value: TG2Float);
begin
  PG2FloatArr(@c.x)^[Index] := Value;
end;

procedure TG2Box.SetValue(const bc, bx, by, bz: TG2Vec3);
begin
  c := bc; vx := bx; vy := by; vz := bz;
end;

function TG2Box.Transform(const m: TG2Mat): TG2Box;
begin
  Result.c := c.Transform4x3(m);
  Result.vx := vx.Transform3x3(m);
  Result.vy := vy.Transform3x3(m);
  Result.vz := vz.Transform3x3(m);
end;
//TG2Box END

//TG2AABox BEGIN
function TG2AABox.GetArr(const Index: TG2IntS32): TG2Float;
begin
  Result := PG2FloatArr(@MinV.x)^[Index];
end;

procedure TG2AABox.SetArr(const Index: TG2IntS32; const Value: TG2Float);
begin
  PG2FloatArr(@MinV.x)^[Index] := Value;
end;

procedure TG2AABox.SetValue(const BMinV, BMaxV: TG2Vec3);
begin
  MinV := BMinV; MaxV := BMaxV;
end;

procedure TG2AABox.SetValue(const v: TG2Vec3);
begin
  MinV := v; MaxV := v;
end;

procedure TG2AABox.Include(const v: TG2Vec3);
begin
  if v.x < MinV.x then MinV.x := v.x
  else if v.x > MaxV.x then MaxV.x := v.x;
  if v.y < MinV.y then MinV.y := v.y
  else if v.y > MaxV.y then MaxV.y := v.y;
  if v.z < MinV.z then MinV.z := v.z
  else if v.z > MaxV.z then MaxV.z := v.z;
end;

procedure TG2AABox.Include(const b: TG2AABox);
begin
  if b.MinV.x < MinV.x then MinV.x := b.MinV.x
  else if b.MaxV.x > MaxV.x then MaxV.x := b.MaxV.x;
  if b.MinV.y < MinV.y then MinV.y := b.MinV.y
  else if b.MaxV.y > MaxV.y then MaxV.y := b.MaxV.y;
  if b.MinV.z < MinV.z then MinV.z := b.MinV.z
  else if b.MaxV.z > MaxV.z then MaxV.z := b.MaxV.z;
end;

procedure TG2AABox.Merge(const b: TG2AABox);
begin
  if b.MinV.x < MinV.x then MinV.x := b.MinV.x
  else if b.MaxV.x > MaxV.x then MaxV.x := b.MaxV.x;
  if b.MinV.y < MinV.y then MinV.y := b.MinV.y
  else if b.MaxV.y > MaxV.y then MaxV.y := b.MaxV.y;
  if b.MinV.z < MinV.z then MinV.z := b.MinV.z
  else if b.MaxV.z > MaxV.z then MaxV.z := b.MaxV.z;
end;

function TG2AABox.Intersect(const b: TG2AABox): Boolean;
begin
  Result := (
    (MinV.x < b.MaxV.x)
    and (MinV.y < b.MaxV.y)
    and (MinV.z < b.MaxV.z)
    and (MaxV.x > b.MinV.x)
    and (MaxV.y > b.MinV.y)
    and (MaxV.z > b.MinV.z)
  );
end;
//TG2AABox END

//TG2Sphere BEGIN
function TG2Sphere.GetArr(const Index: TG2IntS32): TG2Float;
begin
  Result := PG2FloatArr(@c.x)^[Index];
end;

procedure TG2Sphere.SetArr(const Index: TG2IntS32; const Value: TG2Float);
begin
  PG2FloatArr(@c.x)^[Index] := Value;
end;

procedure TG2Sphere.SetValue(const sc: TG2Vec3; const sr: TG2Float);
begin
  c := sc; r := sr;
end;
//TG2Sphere END

//TG2Plane BEGIN
function TG2Plane.GetArr(const Index: TG2IntS32): TG2Float;
begin
  Result := PG2FloatArr(@n.x)^[Index];
end;

procedure TG2Plane.SetArr(const Index: TG2IntS32; const Value: TG2Float);
begin
  PG2FloatArr(@n.x)^[Index] := Value;
end;

function TG2Plane.GetA: TG2Float;
begin
  Result := n.x;
end;

procedure TG2Plane.SetA(const Value: TG2Float);
begin
  n.x := Value;
end;

function TG2Plane.GetB: TG2Float;
begin
  Result := n.y;
end;

procedure TG2Plane.SetB(const Value: TG2Float);
begin
  n.y := Value;
end;

function TG2Plane.GetC: TG2Float;
begin
  Result := n.z;
end;

procedure TG2Plane.SetC(const Value: TG2Float);
begin
  n.z := Value;
end;

procedure TG2Plane.SetValue(const pa, pb, pc, pd: TG2Float);
begin
  n.x := pa; n.y := pb; n.z := pc; d := pd;
end;

procedure TG2Plane.SetValue(const pn: TG2Vec3; const pd: TG2Float);
begin
  n := pn; d := pd;
end;

procedure TG2Plane.SetValue(const v0, v1, v2: TG2Vec3);
begin
  n := G2TriangleNormal(v0, v1, v2);
  d := n.Dot(v0);
end;
//TG2Plane END

//TG2Ray BEGIN
function TG2Ray.GetArr(const Index: TG2IntS32): TG2Float;
begin
  Result := PG2FloatArr(@Origin.x)^[Index];
end;

procedure TG2Ray.SetArr(const Index: TG2IntS32; const Value: TG2Float);
begin
  PG2FloatArr(@Origin.x)^[Index] := Value;
end;

procedure TG2Ray.SetValue(const ROrigin, RDir: TG2Vec3);
begin
  Origin := ROrigin; Dir := RDir;
end;
//TG2Ray END

//TG2Frustum BEGIN
function TG2Frustum.GetPlane(const Index: TG2IntS32): PG2Plane;
begin
  Result := @_Planes[Index];
end;

procedure TG2Frustum.Normalize;
  var i: TG2IntS32;
  var Rcp: TG2Float;
begin
  for i := 0 to 5 do
  begin
    Rcp := 1 / G2Vec3Len(@_Planes[i].n);
    _Planes[i].N.x := _Planes[i].N.x * Rcp;
    _Planes[i].N.y := _Planes[i].N.y * Rcp;
    _Planes[i].N.z := _Planes[i].N.z * Rcp;
    _Planes[i].D := _Planes[i].D * Rcp;
  end;
end;

function TG2Frustum.DistanceToPoint(const PlaneIndex: TG2IntS32; const Pt: TG2Vec3): TG2Float;
begin
  Result := _Planes[PlaneIndex].n.Dot(Pt) + _Planes[PlaneIndex].d;
end;

procedure TG2Frustum.Update;
  var m: TG2Mat;
begin
  G2MatMul(@m, _RefV, _RefP);
  //Left plane
  _Planes[0].N.x := m.e03 + m.e00;
  _Planes[0].N.y := m.e13 + m.e10;
  _Planes[0].N.z := m.e23 + m.e20;
  _Planes[0].D := m.e33 + m.e30;

  //Right plane
  _Planes[1].N.x := m.e03 - m.e00;
  _Planes[1].N.y := m.e13 - m.e10;
  _Planes[1].N.z := m.e23 - m.e20;
  _Planes[1].D := m.e33 - m.e30;

  //Top plane
  _Planes[2].N.x := m.e03 - m.e01;
  _Planes[2].N.y := m.e13 - m.e11;
  _Planes[2].N.z := m.e23 - m.e21;
  _Planes[2].D := m.e33 - m.e31;

  //Bottom plane
  _Planes[3].N.x := m.e03 + m.e01;
  _Planes[3].N.y := m.e13 + m.e11;
  _Planes[3].N.z := m.e23 + m.e21;
  _Planes[3].D := m.e33 + m.e31;

  //Near plane
  _Planes[4].N.x := m.e02;
  _Planes[4].N.y := m.e12;
  _Planes[4].N.z := m.e22;
  _Planes[4].D := m.e32;

  //Far plane
  _Planes[5].N.x := m.e03 - m.e02;
  _Planes[5].N.y := m.e13 - m.e12;
  _Planes[5].N.z := m.e23 - m.e22;
  _Planes[5].D := m.e33 - m.e32;

  Normalize;
end;

procedure TG2Frustum.ExtractPoints(const OutV: PG2Vec3);
  var pv: PG2Vec3;
begin
  pv := OutV;
  //0 - Left
  //1 - Right
  //2 - Top
  //3 - Bottom
  //4 - Near
  //5 - Far
  pv^ := G2Intersect3Planes(_Planes[4], _Planes[0], _Planes[2]); Inc(pv);
  pv^ := G2Intersect3Planes(_Planes[5], _Planes[0], _Planes[2]); Inc(pv);
  pv^ := G2Intersect3Planes(_Planes[4], _Planes[2], _Planes[1]); Inc(pv);
  pv^ := G2Intersect3Planes(_Planes[5], _Planes[2], _Planes[1]); Inc(pv);
  pv^ := G2Intersect3Planes(_Planes[4], _Planes[1], _Planes[3]); Inc(pv);
  pv^ := G2Intersect3Planes(_Planes[5], _Planes[1], _Planes[3]); Inc(pv);
  pv^ := G2Intersect3Planes(_Planes[4], _Planes[3], _Planes[0]); Inc(pv);
  pv^ := G2Intersect3Planes(_Planes[5], _Planes[3], _Planes[0]);
end;

function TG2Frustum.IntersectFrustum(const Frustum: TG2Frustum): Boolean;
  function FrustumOutside(const f1, f2: TG2Frustum): Boolean;
    var Points: array[0..7] of TG2Vec3;
    var i, j, n: TG2IntS32;
  begin
    f2.ExtractPoints(@Points[0]);
    for i := 0 to 5 do
    begin
      n := 0;
      for j := 0 to 7 do
      begin
        if f1.DistanceToPoint(i, Points[j]) < 0 then
        Inc(n);
      end;
      if n >= 8 then
      begin
        Result := True;
        Exit;
      end;
    end;
    Result := False;
  end;
begin
  Result := (
    (not FrustumOutside(Self, Frustum))
    and (not FrustumOutside(Frustum, Self))
  );
end;

function TG2Frustum.CheckSphere(const Center: TG2Vec3; const Radius: TG2Float): TG2FrustumCheck;
  var i: TG2IntS32;
  var d: TG2Float;
begin
  Result := fcInside;
  for i := 0 to 5 do
  begin
    d := DistanceToPoint(i, Center);
    if d < -Radius then
    begin
      Result := fcOutside;
      Exit;
    end;
    if d < Radius then
    Result := fcIntersect;
  end;
end;

function TG2Frustum.CheckSphere(const Sphere: TG2Sphere): TG2FrustumCheck;
begin
  Result := CheckSphere(Sphere.c, Sphere.r);
end;

function TG2Frustum.CheckBox(const MinV, MaxV: TG2Vec3): TG2FrustumCheck;
  var i: TG2IntS32;
  var MaxPt, MinPt: TG2Vec3;
begin
  Result := fcInside;
  for i := 0 to 5 do
  begin
    if _Planes[i].N.x <= 0 then
    begin
      MinPt.x := MinV.x;
      MaxPt.x := MaxV.x;
    end
    else
    begin
      MinPt.x := MaxV.x;
      MaxPt.x := MinV.x;
    end;
    if _Planes[i].N.y <= 0 then
    begin
      MinPt.y := MinV.y;
      MaxPt.y := MaxV.y;
    end
    else
    begin
      MinPt.y := MaxV.y;
      MaxPt.y := MinV.y;
    end;
    if _Planes[i].N.z <= 0 then
    begin
      MinPt.z := MinV.z;
      MaxPt.z := MaxV.z;
    end
    else
    begin
      MinPt.z :=MaxV.z;
      MaxPt.z :=MinV.z;
    end;
    if DistanceToPoint(i, MinPt) < 0 then
    begin
      Result := fcOutside;
      Exit;
    end;
    if DistanceToPoint(i, MaxPt) <= 0 then
    Result := fcIntersect;
  end;
end;

function TG2Frustum.CheckBox(const Box: TG2AABox): TG2FrustumCheck;
begin
  Result := CheckBox(Box.MinV, Box.MaxV);
end;
//TG2Frustum END

//TG2Rect BEGIN
procedure TG2Rect.SetX(const Value: TG2Float);
  var d: TG2Float;
begin
  d := w;
  Left := Value;
  w := d;
end;

procedure TG2Rect.SetY(const Value: TG2Float);
  var d: TG2Float;
begin
  d := h;
  Top := Value;
  h := d;
end;

procedure TG2Rect.SetWidth(const Value: TG2Float);
begin
  Right := Left + Value;
end;

function TG2Rect.GetWidth: TG2Float;
begin
  Result := Right - Left;
end;

procedure TG2Rect.SetHeight(const Value: TG2Float);
begin
  Bottom := Top + Value;
end;

function TG2Rect.GetHeight: TG2Float;
begin
  Result := Bottom - Top;
end;

procedure TG2Rect.SetTopLeft(const Value: TG2Vec2);
begin
  Left := Value.x;
  Top := Value.y;
end;

function TG2Rect.GetTopLeft: TG2Vec2;
begin
  {$Warnings off}
  Result.SetValue(Left, Top);
  {$Warnings on}
end;

procedure TG2Rect.SetTopRight(const Value: TG2Vec2);
begin
  Top := Value.y;
  Right := Value.x;
end;

function TG2Rect.GetTopRight: TG2Vec2;
begin
  {$Warnings off}
  Result.SetValue(Right, Top);
  {$Warnings on}
end;

procedure TG2Rect.SetBottomLeft(const Value: TG2Vec2);
begin
  Left := Value.x;
  Bottom := Value.y;
end;

function TG2Rect.GetBottomLeft: TG2Vec2;
begin
  {$Warnings off}
  Result.SetValue(Left, Bottom);
  {$Warnings on}
end;

procedure TG2Rect.SetBottomRight(const Value: TG2Vec2);
begin
  Right := Value.x;
  Bottom := Value.y;
end;

function TG2Rect.GetBottomRight: TG2Vec2;
begin
  {$Warnings off}
  Result.SetValue(Right, Bottom);
  {$Warnings on}
end;

function TG2Rect.GetCenter: TG2Vec2;
begin
  {$Warnings off}
  Result.SetValue((l + r) * 0.5, (t + b) * 0.5);
  {$Warnings on}
end;

function TG2Rect.Contains(const v: TG2Vec2): Boolean;
begin
  Result := Contains(v.x, v.y);
end;

function TG2Rect.Contains(const vx, vy: TG2Float): Boolean;
begin
  Result := (vx > l) and (vx < r) and (vy > t) and (vy < b);
end;

function TG2Rect.Clip(const ClipRect: TG2Rect): TG2Rect;
begin
  Result.l := G2Max(l, ClipRect.l);
  Result.t := G2Max(t, ClipRect.t);
  Result.r := G2Min(r, ClipRect.r);
  Result.b := G2Min(b, ClipRect.b);
end;

function TG2Rect.Expand(const Dimensions: TG2Vec2): TG2Rect;
begin
  Result := Expand(Dimensions.x, Dimensions.y);
end;

function TG2Rect.Expand(const dx, dy: TG2Float): TG2Rect;
begin
  Result.l := l - dx;
  Result.t := t - dy;
  Result.r := r + dx;
  Result.b := b + dy;
end;
//TG2Rect END

operator := (v: TG2Vec2) vr: TG2Vec2Ref;
begin
  vr[0] := v.x; vr[1] := v.y;
end;

operator := (vr: TG2Vec2Ref) v: TG2Vec2;
begin
  v.x := vr[0]; v.y := vr[1];
end;

operator := (v: TG2Vec2) pr: TPoint;
begin
  pr.x := Round(v.x);
  pr.y := Round(v.y);
end;

operator := (p: TPoint) vr: TG2Vec2;
begin
  vr.x := p.x;
  vr.y := p.y;
end;

operator := (v: TG2Vec3) vr: TG2Vec3Ref;
begin
  vr[0] := v.x; vr[1] := v.y; vr[2] := v.z;
end;

operator := (vr: TG2Vec3Ref) v: TG2Vec3;
begin
  v.x := vr[0]; v.y := vr[1]; v.z := vr[2];
end;

operator := (m: TG2Mat) mr: TG2MatRef;
begin
  mr[0] := m.e00; mr[1] := m.e10; mr[2] := m.e20; mr[3] := m.e30;
  mr[4] := m.e01; mr[5] := m.e11; mr[6] := m.e21; mr[7] := m.e31;
  mr[8] := m.e02; mr[9] := m.e12; mr[10] := m.e22; mr[11] := m.e32;
  mr[12] := m.e03; mr[13] := m.e13; mr[14] := m.e23; mr[15] := m.e33;
end;

operator := (mr: TG2MatRef) m: TG2Mat;
begin
  m.e00 := mr[0]; m.e10 := mr[1]; m.e20 := mr[2]; m.e30 := mr[3];
  m.e01 := mr[4]; m.e11 := mr[5]; m.e21 := mr[6]; m.e31 := mr[7];
  m.e02 := mr[8]; m.e12 := mr[9]; m.e22 := mr[10]; m.e32 := mr[11];
  m.e03 := mr[12]; m.e13 := mr[13]; m.e23 := mr[14]; m.e33 := mr[15];
end;

operator := (r: TG2Rect) rr: TRect;
begin
  rr.Left := Round(r.l);
  rr.Top := Round(r.t);
  rr.Right := Round(r.r);
  rr.Bottom := Round(r.b);
end;

operator := (r: TRect) rr: TG2Rect;
begin
  rr.l := r.Left;
  rr.t := r.Top;
  rr.r := r.Right;
  rr.b := r.Bottom;
end;

operator := (b: TG2Box) rb: TG2AABox;
var
  i: TG2IntS32;
  v: array[0..7] of TG2Vec3;
begin
  v[0] := b.c + b.vx + b.vy + b.vz;
  v[1] := b.c + b.vx + b.vy - b.vz;
  v[2] := b.c - b.vx + b.vy - b.vz;
  v[3] := b.c - b.vx + b.vy + b.vz;
  v[4] := b.c + b.vx - b.vy + b.vz;
  v[5] := b.c + b.vx - b.vy - b.vz;
  v[6] := b.c - b.vx - b.vy - b.vz;
  v[7] := b.c - b.vx - b.vy + b.vz;
  Result.MinV := v[0];
  Result.MaxV := v[0];
  for i := 1 to 7 do
  begin
    if v[i].x < rb.MinV.x then rb.MinV.x := v[i].x;
    if v[i].y < rb.MinV.y then rb.MinV.y := v[i].y;
    if v[i].z < rb.MinV.z then rb.MinV.z := v[i].z;
    if v[i].x > rb.MaxV.x then rb.MaxV.x := v[i].x;
    if v[i].y > rb.MaxV.y then rb.MaxV.y := v[i].y;
    if v[i].z > rb.MaxV.z then rb.MaxV.z := v[i].z;
  end;
end;

operator := (b: TG2AABox) rb: TG2Box;
  var v: TG2Vec3;
begin
  rb.c := (b.MinV + b.MaxV) * 0.5;
  v := (b.MaxV - b.MinV) * 0.5;
  rb.vx.SetValue(v.x, 0, 0);
  rb.vy.SetValue(0, v.y, 0);
  rb.vz.SetValue(0, 0, v.z);
end;

operator := (c: TG2Color) rv: TG2Vec4;
begin
  {$Warnings off}
  rv.SetValue(c.r * G2Rcp255, c.g * G2Rcp255, c.b * G2Rcp255, c.a * G2Rcp255);
  {$Warnings on}
end;

operator := (v: TG2Vec4) rc: TG2Color;
begin
  rc := G2Color(Round(v.x * $ff), Round(v.y * $ff), Round(v.z * $ff), Round(v.w * $ff));
end;

operator - (v: TG2Vec2) vr: TG2Vec2;
begin
  vr.x := -v.x;
  vr.y := -v.y;
end;

operator - (v: TG2Vec3) vr: TG2Vec3;
begin
  vr.x := -v.x;
  vr.y := -v.y;
  vr.z := -v.z;
end;

operator - (v0, v1: TG2Vec2) vr: TG2Vec2;
begin
  vr.x := v0.x - v1.x;
  vr.y := v0.y - v1.y;
end;

operator - (v0, v1: TG2Vec3) vr: TG2Vec3;
begin
  vr.x := v0.x - v1.x;
  vr.y := v0.y - v1.y;
  vr.z := v0.z - v1.z;
end;

operator - (v: TG2Vec2; f: TG2Float) vr: TG2Vec2;
begin
  vr.x := v.x - f;
  vr.y := v.y - f;
end;

operator - (v: TG2Vec3; f: TG2Float) vr: TG2Vec3;
begin
  vr.x := v.x - f;
  vr.y := v.y - f;
  vr.z := v.z - f;
end;

operator - (v: TG2Vec4; f: TG2Float) vr: TG2Vec4;
begin
  vr.x := v.x - f;
  vr.y := v.y - f;
  vr.z := v.z - f;
  vr.w := v.w - f;
end;

operator - (v: TG2Vec2; p: TPoint) vr: TG2Vec2;
begin
  vr.x := v.x - p.x;
  vr.y := v.y - p.y;
end;

operator - (p: TPoint; v: TG2Vec2) vr: TG2Vec2;
begin
  vr.x := p.x - v.x;
  vr.y := p.y - v.y;
end;

operator + (v0, v1: TG2Vec2) vr: TG2Vec2;
begin
  vr.x := v0.x + v1.x;
  vr.y := v0.y + v1.y;
end;

operator + (v0, v1: TG2Vec3) vr: TG2Vec3;
begin
  vr.x := v0.x + v1.x;
  vr.y := v0.y + v1.y;
  vr.z := v0.z + v1.z;
end;

operator + (v: TG2Vec2; f: TG2Float) vr: TG2Vec2;
begin
  vr.x := v.x + f;
  vr.y := v.y + f;
end;

operator + (v: TG2Vec3; f: TG2Float) vr: TG2Vec3;
begin
  vr.x := v.x + f;
  vr.y := v.y + f;
  vr.z := v.z + f;
end;

operator + (v: TG2Vec4; f: TG2Float) vr: TG2Vec4;
begin
  vr.x := v.x + f;
  vr.y := v.y + f;
  vr.z := v.z + f;
  vr.w := v.w + f;
end;

operator + (b: TG2AABox; v: TG2Vec3) rb: TG2AABox;
begin
  rb.MinV := b.MinV;
  rb.MaxV := b.MaxV;
  if v.x < rb.MinV.x then rb.MinV.x := v.x
  else if v.x > rb.MaxV.x then rb.MaxV.x := v.x;
  if v.y < rb.MinV.y then rb.MinV.y := v.y
  else if v.y > rb.MaxV.y then rb.MaxV.y := v.y;
  if v.z < rb.MinV.z then rb.MinV.z := v.z
  else if v.z > rb.MaxV.z then rb.MaxV.z := v.z;
end;

operator + (v: TG2Vec2; p: TPoint) vr: TG2Vec2;
begin
  vr.x := v.x + p.x;
  vr.y := v.y + p.y;
end;

operator + (p: TPoint; v: TG2Vec2) vr: TG2Vec2;
begin
  vr.x := v.x + p.x;
  vr.y := v.y + p.y;
end;

operator * (v: TG2Vec2; f: TG2Float) vr: TG2Vec2;
begin
  vr.x := v.x * f;
  vr.y := v.y * f;
end;

operator * (v: TG2Vec3; f: TG2Float) vr: TG2Vec3;
begin
  vr.x := v.x * f;
  vr.y := v.y * f;
  vr.z := v.z * f;
end;

operator * (v: TG2Vec2; m: TG2Mat) vr: TG2Vec2;
begin
  G2Vec2MatMul4x3(@vr, @v, @m);
end;

operator * (v: TG2Vec3; m: TG2Mat) vr: TG2Vec3;
begin
  G2Vec3MatMul4x3(@vr, @v, @m);
end;

operator * (m0, m1: TG2Mat) mr: TG2Mat;
begin
  G2MatMul(@mr, @m0, @m1);
end;

operator / (v: TG2Vec2; f: TG2Float) vr: TG2Vec2;
  var RcpF: TG2Float;
begin
  RcpF := 1 / f;
  vr.x := v.x * RcpF;
  vr.y := v.y * RcpF;
end;

operator / (v: TG2Vec3; f: TG2Float) vr: TG2Vec3;
  var RcpF: TG2Float;
begin
  RcpF := 1 / f;
  vr.x := v.x * RcpF;
  vr.y := v.y * RcpF;
  vr.z := v.z * RcpF;
end;

{$Warnings off}
function G2Rect(const x, y, w, h: TG2Float): TG2Rect;
begin
  Result.x := x;
  Result.y := y;
  Result.w := w;
  Result.h := h;
end;
{$Warnings off}

function G2Vec2(const x, y: TG2Float): TG2Vec2;
begin
  Result.x := x; Result.y := y;
end;

function G2Vec2(const pt: TPoint): TG2Vec2;
begin
  Result.x := pt.x; Result.y := pt.y;
end;

function G2Vec2InPoly(const v: TG2Vec2; const VArr: PG2Vec2; const VCount: TG2IntS32): Boolean;
var
  i: TG2IntS32;
  pi, pj: PG2Vec2;
begin
  Result := False;
  if VCount < 3 then Exit;
  pj := @PG2Vec2Arr(VArr)^[VCount - 1];
  for i := 0 to VCount - 1 do
  begin
    pi := @PG2Vec2Arr(VArr)^[i];
    if (((pi^.y <= v.y) and (v.y < pj^.y)) or ((pj^.y <= v.y) and (v.y < pi^.y)))
    and (v.x < (pj^.x - pi^.x) * (v.y - pi^.y) / (pj^.y - pi^.y) + pi^.x) then
    Result := not Result;
    pj := pi;
  end;
end;

function G2Vec3(const x, y, z: TG2Float): TG2Vec3;
begin
  Result.x := x; Result.y := y; Result.z := z;
end;

function G2Vec3(const v2: TG2Vec2; const z: TG2Float): TG2Vec3;
begin
  Result.x := v2.x; Result.y := v2.y; Result.z := z;
end;

function G2Vec4(const x, y, z, w: TG2Float): TG2Vec4;
begin
  Result.x := x; Result.y := y; Result.z := z; Result.w := w;
end;

function G2Quat(const x, y, z, w: TG2Float): TG2Quat;
begin
  Result.x := x; Result.y := y; Result.z := z; Result.w := w;
end;

function G2Quat(const Axis: TG2Vec3; const Angle: TG2Float): TG2Quat;
  var AxisNorm: TG2Vec3;
  var s, c: TG2Float;
begin
  {$Hints off}
  AxisNorm := Axis.Norm;
  G2SinCos(Angle * 0.5, s, c);
  Result.x := s * AxisNorm.x;
  Result.y := s * AxisNorm.y;
  Result.z := s * AxisNorm.z;
  Result.w := c;
  {$Hints on}
end;

function G2Quat(const m: TG2Mat): TG2Quat;
  var Trace, SqrtTrace, RcpSqrtTrace, MaxDiag, s: TG2Float;
  var MaxI, i: TG2IntS32;
begin
  Trace := m.e00 + m.e11 + m.e22 + 1;
  if Trace > 0 then
  begin
    SqrtTrace := Sqrt(Trace);
    RcpSqrtTrace := 0.5 / SqrtTrace;
    Result.x := (m.e12 - m.e21) * RcpSqrtTrace;
    Result.y := (m.e20 - m.e02) * RcpSqrtTrace;
    Result.z := (m.e01 - m.e10) * RcpSqrtTrace;
    Result.w := SqrtTrace * 0.5;
    Exit;
  end;
  MaxI := 0;
  MaxDiag := m.e00;
  for i := 1 to 2 do
  if m.Mat[i, i] > MaxDiag then
  begin
    MaxI := i;
    MaxDiag := m.Mat[i, i];
  end;
  case MaxI of
    0:
    begin
      s := 2 * Sqrt(1 + m.e00 - m.e11 - m.e22);
      Result.x := 0.25 * s; s := 1 / s;
      Result.y := (m.e01 + m.e10) * s;
      Result.z := (m.e02 + m.e20) * s;
      Result.w := (m.e12 - m.e21) * s;
    end;
    1:
    begin
      s := 2 * Sqrt(1 + m.e11 - m.e00 - m.e22);
      Result.y := 0.25 * s; s := 1 / s;
      Result.x := (m.e01 + m.e10) * s;
      Result.z := (m.e12 + m.e21) * s;
      Result.w := (m.e20 - m.e02) * s;
    end;
    2:
    begin
      s := 2 * Sqrt(1 + m.e22 - m.e00 - m.e11);
      Result.z := 0.25 * s; s := 1 / s;
      Result.x := (m.e02 + m.e20) * s;
      Result.y := (m.e12 + m.e21) * s;
      Result.w := (m.e01 - m.e10) * s;
    end;
  end;
end;

function G2QuatDot(const q0, q1: TG2Quat): TG2Float;
begin
  Result := q0.x * q1.x + q0.y * q1.y + q0.z * q1.z + q0.w * q1.w;
end;

function G2QuatSlerp(const q0, q1: TG2Quat; const s: TG2Float): TG2Quat;
  var SinTh, CosTh, Th, ra, rb: TG2Float;
  var qa, qb: TG2Quat;
begin
  qa := q0;
  qb := q1;
  CosTh := qa.x * qb.x + qa.y * qb.y + qa.z * qb.z + qa.w * qb.w;
  if CosTh < 0 then
  begin
    qb.x := -qb.x; qb.y := -qb.y; qb.z := -qb.z;
    CosTh := -CosTh;
  end;
  if Abs(CosTh) >= 1.0 then
  begin
    Result := qa;
    Exit;
  end;
  Th := ArcCos(CosTh);
  SinTh := Sin(Th);
  if Abs(SinTh) < 1E-4 then
  begin
    ra := 1 - s;
    rb := s;
  end
  else
  begin
    ra := Sin((1 - s) * Th) / SinTh;
    rb := Sin(s * Th) / SinTh;
  end;
  Result.x := qa.x * ra + qb.x * rb;
  Result.y := qa.y * ra + qb.y * rb;
  Result.z := qa.z * ra + qb.z * rb;
  Result.w := qa.w * ra + qb.w * rb;
end;

function G2Mat(
  const m00, m10, m20, m30: TG2Float;
  const m01, m11, m21, m31: TG2Float;
  const m02, m12, m22, m32: TG2Float;
  const m03, m13, m23, m33: TG2Float
): TG2Mat;
begin
  {$Warnings off}
  Result.SetValue(
    m00, m10, m20, m30,
    m01, m11, m21, m31,
    m02, m12, m22, m32,
    m03, m13, m23, m33
  );
  {$Warnings on}
end;

function G2Mat(const AxisX, AxisY, AxisZ, Translation: TG2Vec3): TG2Mat;
begin
  {$Warnings off}
  Result.SetValue(
    AxisX.x, AxisY.x, AxisZ.x, Translation.x,
    AxisX.y, AxisY.y, AxisZ.y, Translation.y,
    AxisX.z, AxisY.z, AxisZ.z, Translation.z,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatIdentity: TG2Mat;
begin
  {$Warnings off}
  Result.SetValue(
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatScaling(const x, y, z: TG2Float): TG2Mat;
begin
  {$Warnings off}
  Result.SetValue(
    x, 0, 0, 0,
    0, y, 0, 0,
    0, 0, z, 0,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatScaling(const v: TG2Vec3): TG2Mat;
begin
  {$Warnings off}
  Result.SetValue(
    v.x, 0, 0, 0,
    0, v.y, 0, 0,
    0, 0, v.z, 0,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatScaling(const s: TG2Float): TG2Mat;
begin
  {$Warnings off}
  Result.SetValue(
    s, 0, 0, 0,
    0, s, 0, 0,
    0, 0, s, 0,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatTranslation(const x, y, z: TG2Float): TG2Mat;
begin
  {$Warnings off}
  Result.SetValue(
    1, 0, 0, x,
    0, 1, 0, y,
    0, 0, 1, z,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatTranslation(const v: TG2Vec3): TG2Mat;
begin
  {$Warnings off}
  Result.SetValue(
    1, 0, 0, v.x,
    0, 1, 0, v.y,
    0, 0, 1, v.z,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatRotationX(const a: TG2Float): TG2Mat;
  var s, c: TG2Float;
begin
  {$Hints off}
  G2SinCos(a, s, c);
  {$Hints on}
  {$Warnings off}
  Result.SetValue(
    1, 0, 0, 0,
    0, c, -s, 0,
    0, s, c, 0,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatRotationY(const a: TG2Float): TG2Mat;
  var s, c: TG2Float;
begin
  {$Hints off}
  G2SinCos(a, s, c);
  {$Hints on}
  {$Warnings off}
  Result.SetValue(
    c, 0, s, 0,
    0, 1, 0, 0,
    -s, 0, c, 0,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatRotationZ(const a: TG2Float): TG2Mat;
  var s, c: TG2Float;
begin
  {$Hints off}
  G2SinCos(a, s, c);
  {$Hints on}
  {$Warnings off}
  Result.SetValue(
    c, -s, 0, 0,
    s, c, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatRotation(const x, y, z, a: TG2Float): TG2Mat;
begin
  Result := G2MatRotation(G2Vec3(x, y, z), a);
end;

function G2MatRotation(const v: TG2Vec3; const a: TG2Float): TG2Mat;
  var vr: TG2Vec3;
  var s, c, cr, xs, ys, zs, crxy, crxz, cryz: TG2Float;
begin
  G2Vec3Norm(@vr, @v);
  {$Hints off}
  G2SinCos(a, s, c);
  {$Hints on}
  cr := 1 - c;
  xs := vr.x * s;
  ys := vr.y * s;
  zs := vr.z * s;
  crxy := cr * vr.x * vr.y;
  crxz := cr * vr.x * vr.z;
  cryz := cr * vr.y * vr.z;
  {$Warnings off}
  Result.SetValue(
    cr * v.x * v.x + c, -zs + crxy, ys + crxz, 0,
    zs + crxy, cr * v.y * v.y + c, -xs + cryz, 0,
    -ys + crxz, xs + cryz, cr * v.z * v.z + c, 0,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatRotation(const q: TG2Quat): TG2Mat;
  var xx, yy, zz, xy, xz, yz, wx, wy, wz: TG2Float;
begin
  xx := 2 * q.x * q.x;
  yy := 2 * q.y * q.y;
  zz := 2 * q.z * q.z;
  xy := 2 * q.x * q.y;
  xz := 2 * q.x * q.z;
  yz := 2 * q.y * q.z;
  wx := 2 * q.w * q.x;
  wy := 2 * q.w * q.y;
  wz := 2 * q.w * q.z;
  {$Warnings off}
  Result.SetValue(
    1 - yy - zz, xy - wz, xz + wy, 0,
    xy + wz, 1 - xx - zz, yz - wx, 0,
    xz - wy, yz + wx, 1 - xx - yy, 0,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatView(const Pos, Target, Up: TG2Vec3): TG2Mat;
  var VecX, VecY, VecZ: TG2Vec3;
begin
  VecZ := (Target - Pos).Norm;
  VecX := Up.Cross(VecZ).Norm;
  VecY := VecZ.Cross(VecX).Norm;
  {$Warnings off}
  Result.SetValue(
    VecX.x, VecX.y, VecX.z, -VecX.Dot(Pos),
    VecY.x, VecY.y, VecY.z, -VecY.Dot(Pos),
    VecZ.x, VecZ.y, VecZ.z, -VecZ.Dot(Pos),
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatOrth(const Width, Height, ZNear, ZFar: TG2Float): TG2Mat;
  var RcpD: TG2Float;
begin
  RcpD := 1 / (ZFar - ZNear);
  {$Warnings off}
  Result.SetValue(
    2 / Width, 0, 0, 0,
    0, 2 / Height, 0, 0,
    0, 0, RcpD, -ZNear * RcpD,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatOrth2D(const Width, Height, ZNear, ZFar: TG2Float; const FlipH: Boolean = False; const FlipV: Boolean = True): TG2Mat;
  var RcpD: TG2Float;
  var x, y, w, h: TG2Float;
begin
  if FlipH then begin x := 1; w := -2 / Width; end else begin x := -1; w := 2 / Width; end;
  if FlipV then begin y := 1; h := -2 / Height; end else begin y := -1; h := 2 / Height; end;
  RcpD := 1 / (ZFar - ZNear);
  {$Warnings off}
  Result.SetValue(
    w, 0, 0, x,
    0, h, 0, y,
    0, 0, RcpD, -ZNear * RcpD,
    0, 0, 0, 1
  );
  {$Warnings on}
end;

function G2MatProj(const FOV, Aspect, ZNear, ZFar: TG2Float): TG2Mat;
  var ct, q: TG2Float;
begin
  ct := G2CoTan(FOV * 0.5);
  q := ZFar / (ZFar - ZNear);
  {$Warnings off}
  Result.SetValue(
    ct / Aspect, 0, 0, 0,
    0, ct, 0, 0,
    0, 0, q, -q * ZNear,
    0, 0, 1, 0
  );
  {$Warnings on}
end;

function G2MatTranspose(const m: TG2Mat): TG2Mat;
begin
  {$Warnings off}
  Result.SetValue(
    m.e00, m.e01, m.e02, m.e03,
    m.e10, m.e11, m.e12, m.e13,
    m.e20, m.e21, m.e22, m.e23,
    m.e30, m.e31, m.e32, m.e33
  );
  {$Warnings on}
end;

procedure G2MatDecompose(const OutScaling: PG2Vec3; const OutRotation: PG2Quat; const OutTranslation: PG2Vec3; const m: TG2Mat);
  var mn: TG2Mat;
  var v: TG2Vec3;
begin
  if OutScaling <> nil then
  begin
    OutScaling^.x := PG2Vec3(@m.e00)^.Len;
    OutScaling^.y := PG2Vec3(@m.e10)^.Len;
    OutScaling^.z := PG2Vec3(@m.e20)^.Len;
  end;
  if OutTranslation <> nil then
  begin
    OutTranslation^ := PG2Vec3(@m.e30)^;
  end;
  if OutRotation <> nil then
  begin
    if OutScaling <> nil then
    begin
      if (OutScaling^.x = 0) or (OutScaling^.y = 0) or (OutScaling^.z = 0) then
      begin
        OutRotation^.SetValue(0, 0, 0, 1);
        Exit;
      end;
      v.x := 1 / OutScaling^.x;
      v.y := 1 / OutScaling^.y;
      v.z := 1 / OutScaling^.z;
    end
    else
    begin
      v.SetValue(PG2Vec3(@m.e00)^.Len, PG2Vec3(@m.e10)^.Len, PG2Vec3(@m.e20)^.Len);
      if (v.x = 0) or (v.y = 0) or (v.z = 0) then
      begin
        OutRotation^.SetValue(0, 0, 0, 1);
        Exit;
      end;
      v.x := 1 / v.x;
      v.y := 1 / v.y;
      v.z := 1 / v.z;
    end;
    mn.SetValue(
      m.e00 * v.x, m.e10 * v.y, m.e20 * v.z, 0,
      m.e01 * v.x, m.e11 * v.y, m.e21 * v.z, 0,
      m.e02 * v.x, m.e12 * v.y, m.e22 * v.z, 0,
      0, 0, 0, 1
    );
    OutRotation^ := G2Quat(mn);
  end;
end;

function G2LerpFloat(const v0, v1, t: TG2Float): TG2Float;
begin
  Result := v0 + (v1 - v0) * t;
end;

function G2Min(const f0, f1: TG2Float): TG2Float;
begin
  if f0 < f1 then Result := f0 else Result := f1;
end;

function G2Min(const v0, v1: TG2IntS32): TG2IntS32;
begin
  if v0 < v1 then Result := v0 else Result := v1;
end;

function G2Min(const v0, v1: TG2IntU32): TG2IntU32;
begin
  if v0 < v1 then Result := v0 else Result := v1;
end;

function G2Max(const f0, f1: TG2Float): TG2Float;
begin
  if f0 > f1 then Result := f0 else Result := f1;
end;

function G2Max(const v0, v1: TG2IntS32): TG2IntS32;
begin
  if v0 > v1 then Result := v0 else Result := v1;
end;

function G2Max(const v0, v1: TG2IntU32): TG2IntU32;
begin
  if v0 > v1 then Result := v0 else Result := v1;
end;

function G2Clamp(const f, LimMin, LimMax: TG2Float): TG2Float;
begin
  if f < LimMin then Result := LimMin
  else if f > LimMax then Result := LimMax
  else Result := f;
end;

function G2SmoothStep(const t, f0, f1: TG2Float): TG2Float;
begin
  Result := G2Clamp((t - f0) / (f1 - f0), 0, 1);
end;

function G2LerpVec2(const v0, v1: TG2Vec2; const t: TG2Float): TG2Vec2;
begin
  Result.x := v0.x + (v1.x - v0.x) * t;
  Result.y := v0.y + (v1.y - v0.y) * t;
end;

function G2LerpVec3(const v0, v1: TG2Vec3; const t: TG2Float): TG2Vec3;
begin
  Result.x := v0.x + (v1.x - v0.x) * t;
  Result.y := v0.y + (v1.y - v0.y) * t;
  Result.z := v0.z + (v1.z - v0.z) * t;
end;

function G2LerpVec4(const v0, v1: TG2Vec4; const t: TG2Float): TG2Vec4;
begin
  Result.x := v0.x + (v1.x - v0.x) * t;
  Result.y := v0.y + (v1.y - v0.y) * t;
  Result.z := v0.z + (v1.z - v0.z) * t;
  Result.w := v0.w + (v1.w - v0.w) * t;
end;

function G2LerpQuat(const v0, v1: TG2Quat; const t: TG2Float): TG2Quat;
begin
  Result.x := v0.x + (v1.x - v0.x) * t;
  Result.y := v0.y + (v1.y - v0.y) * t;
  Result.z := v0.z + (v1.z - v0.z) * t;
  Result.w := v0.w + (v1.w - v0.w) * t;
end;

function G2LerpColor(const c0, c1: TG2Color; const t: TG2Float): TG2Color;
begin
  Result.r := Round(c0.r + (c1.r - c0.r) * t);
  Result.g := Round(c0.g + (c1.g - c0.g) * t);
  Result.b := Round(c0.b + (c1.b - c0.b) * t);
  Result.a := Round(c0.a + (c1.a - c0.a) * t);
end;

function G2CosrpFloat(const f0, f1: TG2Float; const s: TG2Float): TG2Float;
begin
  Result := f0 + (f1 - f0) * (1.0 - Cos(s * Pi)) * 0.5;
end;

function G2Vec2CatmullRom(const v0, v1, v2, v3: TG2Vec2; const t: TG2Float): TG2Vec2;
begin
  Result.x := 0.5 * (2 * v1.x + (v2.x - v0.x) * t + (2 * v0.x - 5 * v1.x + 4 * v2.x - v3.x) * t * t + (v3.x - 3 * v2.x + 3 * v1.x - v0.x) * t * t * t);
  Result.y := 0.5 * (2 * v1.y + (v2.y - v0.y) * t + (2 * v0.y - 5 * v1.y + 4 * v2.y - v3.y) * t * t + (v3.y - 3 * v2.y + 3 * v1.y - v0.y) * t * t * t);
end;

function G2Vec3CatmullRom(const v0, v1, v2, v3: TG2Vec3; const t: TG2Float): TG2Vec3;
begin
  Result.x := 0.5 * (2 * v1.x + (v2.x - v0.x) * t + (2 * v0.x - 5 * v1.x + 4 * v2.x - v3.x) * t * t + (v3.x - 3 * v2.x + 3 * v1.x - v0.x) * t * t * t);
  Result.y := 0.5 * (2 * v1.y + (v2.y - v0.y) * t + (2 * v0.y - 5 * v1.y + 4 * v2.y - v3.y) * t * t + (v3.y - 3 * v2.y + 3 * v1.y - v0.y) * t * t * t);
  Result.z := 0.5 * (2 * v1.z + (v2.z - v0.z) * t + (2 * v0.z - 5 * v1.z + 4 * v2.z - v3.z) * t * t + (v3.z - 3 * v2.z + 3 * v1.z - v0.z) * t * t * t);
end;

function G2CoTan(const x: TG2Float): TG2Float;
  var s, c: TG2Float;
begin
  {$Hints off}
  G2SinCos(x, s, c);
  {$Hints on}
  Result := c / s;
end;

{$ifdef G2Cpu386}
{$Warnings off}
function G2ArcCos(const x: TG2Float): TG2Float; assembler;
asm
  fld1
  fld x
  fst st(2)
  fmul st(0), st(0)
  fsubp
  fsqrt
  fxch
  fpatan
end;
{$Warnings on}
{$else}
function G2ArcCos(const x: G2Float): G2Float;
begin
  Result := G2ArcTan2(Sqrt((1 + x) * (1 - x)), x);
end;
{$endif}

{$ifdef G2Cpu386}
function G2ArcTan2(const y, x: TG2Float): TG2Float; assembler;
asm
  fld y
  fld x
  fpatan
  fwait
end;
{$else}
function G2ArcTan2(const y, x: G2Float): G2Float;
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
{$endif}

{$ifdef G2Cpu386}
procedure G2SinCos(const Angle: TG2Float; var s, c: TG2Float); assembler;
asm
  fld Angle
  fsincos
  fstp [edx]
  fstp [eax]
  fwait
end;
{$else}
procedure G2SinCos(const Angle: G2Float; var s, c: G2Float);
begin
  s := Sin(Angle);
  c := Cos(Angle);
end;
{$endif}

function G2Vec2ToLine(const l1, l2, v: TG2Vec2; var VecOnLine: TG2Vec2; var InSegment: Boolean): TG2Float;
  var u: TG2Float;
begin
  u := ((v.x - l1.x) * (l2.x - l1.x) + (v.y - l1.y) * (l2.y - l1.y)) / (Sqr(l2.x - l1.x) + Sqr(l2.y - l1.y));
  VecOnLine.SetValue(l1.x + u * (l2.x - l1.x), l1.y + u * (l2.y - l1.y));
  InSegment := (u >= 0) and (u <= 1);
  Result := (v - VecOnLine).Len;
end;

function G2Vec3ToLine(const l1, l2, v: TG2Vec3; var VecOnLine: TG2Vec3; var InSegment: Boolean): TG2Float;
  var u: TG2Float;
begin
  u := (
    ((v.x - l1.x) * (l2.x - l1.x) + (v.y - l1.y) * (l2.y - l1.y) + (v.z - l1.z) * (l2.z - l1.z)) /
    (Sqr(l2.x - l1.x) + Sqr(l2.y - l1.y) + Sqr(l2.z - l1.z))
  );
  VecOnLine.SetValue(l1.x + u * (l2.x - l1.x), l1.y + u * (l2.y - l1.y), l1.z + u * (l2.z - l1.z));
  InSegment := (u >= 0) and (u <= 1);
  Result := (v - VecOnLine).Len;
end;

function G2TriangleNormal(const v0, v1, v2: TG2Vec3): TG2Vec3;
begin
  Result := (v1 - v0).Cross(v2 - v0).Norm;
end;

procedure G2FaceTBN(
  const v1, v2, v3: TG2Vec3;
  const uv1, uv2, uv3: TG2Vec2;
  var T, B, N: TG2Vec3
);
  var FaceNormal, Side1, Side2, cp: TG2Vec3;
  var Rcpcpx: TG2Float;
begin
  FaceNormal := G2TriangleNormal(v1, v2, v3);
  Side1.SetValue(v2.x - v1.x, uv2.x - uv1.x, uv2.y - uv1.y);
  Side2.SetValue(v3.x - v1.x, uv3.x - uv1.x, uv3.y - uv1.y);
  cp := Side1.Cross(Side2);
  Rcpcpx := 1 / cp.x;
  T.x := -cp.y * Rcpcpx; B.x := -cp.z * Rcpcpx;
  Side1.x := v2.y - v1.y; Side2.x := v3.y - v1.y;
  cp := Side1.Cross(Side2);
  T.y := -cp.y * Rcpcpx; B.y := -cp.z * Rcpcpx;
  Side1.x := v2.z - v1.z; Side2.x := v3.z - v1.z;
  cp := Side1.Cross(Side2);
  T.z := -cp.y * Rcpcpx; B.z := -cp.z * Rcpcpx;
  T := T.Norm; B := B.Norm;
  N := T.Cross(B).Norm;
  if N.Dot(FaceNormal) < 0 then N := -N;
end;

function G2Intersect3Planes(const p1, p2, p3: TG2Plane): TG2Vec3;
  var iDet: TG2Float;
begin
  iDet := -p1.n.Dot(p2.n.Cross(p3.n));
  if Abs(iDet) > 1E-5 then
  Result := ((p2.n.Cross(p3.n) * p1.d) + (p3.n.Cross(p1.n) * p2.d) + (p1.n.Cross(p2.n) * p3.d)) / iDet
  else
  Result.SetValue(0, 0, 0);
end;

function G2PolyTriangulate(const Triang: PG2PolyTriang): Boolean;
  function InsideTriangle(const Ax, Ay, Bx, By, Cx, Cy, Px, Py: TG2Float): Boolean;
  begin
    Result := (
      ((Cx - Bx) * (Py - By) - (Cy - By) * (Px - Bx) >= 0)
      and ((Bx - Ax) * (Py - Ay) - (By - Ay) * (Px - Ax) >= 0)
      and ((Ax - Cx) * (Py - Cy) - (Ay - Cy) * (Px - Cx) >= 0)
    );
  end;
  function Area: TG2Float;
    var i, j: TG2IntS32;
  begin
    Result := 0;
    i := High(Triang^.v);
    for j := 0 to High(Triang^.v) do
    begin
      Result := Result + Triang^.v[i].x * Triang^.v[j].y - Triang^.v[j].x * Triang^.v[i].y;
      i := j;
    end;
    Result := Result * 0.5;
  end;
  function Snip(const u, v, w, n: TG2IntS32; const Ind: PG2IntS32Arr): Boolean;
    var i: TG2IntS32;
    var Ax, Ay, Bx, By, Cx, Cy, Px, Py: TG2Float;
  begin
    Ax := Triang^.v[Ind^[u]].x;
    Ay := Triang^.v[Ind^[u]].y;
    Bx := Triang^.v[Ind^[v]].x;
    By := Triang^.v[Ind^[v]].y;
    Cx := Triang^.v[Ind^[w]].x;
    Cy := Triang^.v[Ind^[w]].y;
    if 1E-5 > (((Bx - Ax) * (Cy - Ay)) - ((By - Ay) * (Cx - Ax))) then
    begin
      Result := False;
      Exit;
    end;
    for i := 0 to n - 1 do
    begin
      if (i = u) or (i = v) or (i = w) then Continue;
      Px := Triang^.v[Ind^[i]].x;
      Py := Triang^.v[Ind^[i]].y;
      if InsideTriangle(Ax, Ay, Bx, By, Cx, Cy, Px, Py) then
      begin
        Result := False;
        Exit;
      end;
    end;
    Result := True;
  end;
  var u, v, w, i, n, nv, c: TG2IntS32;
  var s, t: TG2IntS32;
  var Ind: array of TG2IntS32;
begin
  n := Length(Triang^.v);
  if n < 3 then
  begin
    Result := False;
    Exit;
  end;
  SetLength(Triang^.Triangles, n);
  SetLength(Ind, n);
  if Area > 0 then
  for i := 0 to n - 1 do Ind[i] := i
  else
  for i := 0 to n - 1 do Ind[i] := n - 1 - i;
  nv := n;
  c := nv * 2;
  i := 0;
  v := nv - 1;
  t := 0;
  while nv > 2 do
  begin
    if c - 1 <= 0 then
    begin
      SetLength(Triang^.Triangles, 0);
      Result := False;
      Exit;
    end;
    u := v; if nv <= u then u := 0;
    v := u + 1; if nv <= v then v := 0;
    w := v + 1; if nv <= w then w := 0;
    if Snip(u, v, w, nv, @Ind[0]) then
    begin
      Triang^.Triangles[t][0] := Ind[u];
      Triang^.Triangles[t][1] := Ind[v];
      Triang^.Triangles[t][2] := Ind[w];
      Inc(t);
      for s := v to nv - 2 do
      Ind[s] := Ind[s + 1];
      Dec(nv);
      c := nv * 2;
      i := 0;
    end
    else
    begin
      Inc(i);
      if (i > nv + 1) then
      begin
        SetLength(Triang^.Triangles, 0);
        Result := False;
        Exit;
      end;
      v := v + 1; if nv <= v then v := 0;
    end;
  end;
  SetLength(Triang^.Triangles, t);
  Result := True;
end;

function G2LineVsCircle(const v0, v1, c: TG2Vec2; const r: TG2Float; var p0, p1: PG2Vec2): Boolean;
  var dx, dy, a, b, d, x0, x1, y0, y1: TG2Float;
  var asq, bsq, rsq, l, h: TG2Float;
  var rv0, rv1: TG2Vec2;
begin
  Result := False;
  p0 := nil; p1 := nil;
  rv0 := v0 - c; rv1 := v1 - c;
  if rv0.x < rv1.x then begin x0 := rv0.x; x1 := rv1.x; end else begin x0 := rv1.x; x1 := rv0.x end;
  if rv0.y < rv1.y then begin y0 := rv0.y; y1 := rv1.y; end else begin y0 := rv1.y; y1 := rv0.y end;
  if (x0 > r) or (x1 < -r) or (y0 > r) or (y1 < -r) then
  begin
    Result := False;
    Exit;
  end;
  dx := rv0.x - rv1.x; dy := rv0.y - rv1.y;
  rsq := r * r;
  if Abs(dx) < G2EPS then
  begin
    if Abs(dy) < G2EPS then
    begin
      Result := False;
      Exit;
    end
    else
    begin
      x0 := rv0.x;
      d := rsq - (x0 * x0);
      x0 := x0 + c.x;
      if rv0.y < rv1.y then begin l := rv0.y; h := rv1.y end else begin l := rv1.y; h := rv0.y end;
      if d < 0 then
      begin
        Result := False;
        Exit;
      end
      else if d < G2EPS then
      begin
        if (0 >= l) and (0 <= h) then
        begin
          Result := True;
          New(p0); p0^.x := x0; p0^.y := c.y;
          Exit;
        end
        else
        begin
          Result := False;
          Exit;
        end;
      end
      else
      begin
        d := Sqrt(d);
        if (d >= l) and (d <= h) then
        begin
          New(p0); p0^.x := x0; p0^.y := d + c.y;
        end;
        if (-d >= l) and (-d <= h) then
        begin
          New(p1); p1^.x := x0; p1^.y := -d + c.y;
          if p0 = nil then
          begin
            p0 := p1;
            p1 := nil;
          end;
        end;
        if p0 <> nil then
        Result := True;
        Exit;
      end;
    end;
  end
  else if Abs(dy) < G2EPS then
  begin
    y0 := rv0.y;
    d := rsq - (y0 * y0);
    y0 := y0 + c.y;
    if rv0.x < rv1.x then begin l := rv0.x; h := rv1.x end else begin l := rv1.x; h := rv0.x end;
    if d < 0 then
    begin
      Result := False;
      Exit;
    end
    else if d < G2EPS then
    begin
      if (0 >= l) and (0 <= h) then
      begin
        Result := True;
        New(p0); p0^.x := c.x; p0^.y := y0;
        Exit;
      end
      else
      begin
        Result := False;
        Exit;
      end;
    end
    else
    begin
      d := Sqrt(d);
      if (d >= l) and (d <= h) then
      begin
        New(p0); p0^.x := d + c.x; p0^.y := y0;
      end;
      if (-d >= l) and (-d <= h) then
      begin
        New(p1); p1^.x := -d + c.x; p1^.y := y0;
        if p0 = nil then
        begin
          p0 := p1;
          p1 := nil;
        end;
      end;
      if p0 <> nil then
      Result := True;
      Exit;
    end;
  end;
  a := dy / dx;
  b := rv0.y - rv0.x * a;
  asq := a * a; bsq := b * b;
  d := 4 * (asq * rsq - bsq + rsq);
  if d < 0 then
  begin
    Result := False;
    Exit;
  end
  else if d < G2EPS then
  begin
    if Abs(dx) > Abs(dy) then
    begin
      if rv0.x < rv1.x then begin l := rv0.x; h := rv1.x end else begin l := rv1.x; h := rv0.x end;
      x0 := -(a * b) / (asq + 1);
      if (x0 >= l) and (x0 <= h) then
      begin
        Result := True;
        y0 := x0 * a + b;
        New(p0); p0^.x := x0 + c.x; p0^.y := y0 + c.y;
        Exit;
      end
      else
      begin
        Result := False;
        Exit;
      end;
    end
    else
    begin
      if rv0.y < rv1.y then begin l := rv0.y; h := rv1.y end else begin l := rv1.y; h := rv0.y end;
      y0 := b / (asq + 1);
      if (y0 >= l) and (y0 <= h) then
      begin
        Result := True;
        x0 := (y0 - b) / a;
        New(p0); p0^.x := x0 + c.x; p0^.y := y0 + c.y;
        Exit;
      end
      else
      begin
        Result := False;
        Exit;
      end;
    end;
  end
  else
  begin
    d := Sqrt(d);
    if Abs(dx) > Abs(dy) then
    begin
      if rv0.x < rv1.x then begin l := rv0.x; h := rv1.x end else begin l := rv1.x; h := rv0.x end;
      x0 := -(2 * a * b + d) / (2 * asq + 2);
      if (x0 >= l) and (x0 <= h) then
      begin
        y0 := x0 * a + b;
        New(p0); p0^.x := x0 + c.x; p0^.y := y0 + c.y;
      end;
      x1 := -(2 * a * b - d) / (2 * asq + 2);
      if (x1 >= l) and (x1 <= h) then
      begin
        y1 := x1 * a + b;
        New(p1); p1^.x := x1 + c.x; p1^.y := y1 + c.y;
        if p0 = nil then
        begin
          p0 := p1;
          p1 := nil;
        end;
      end;
      if (p0 <> nil) then
      Result := True;
      Exit;
    end
    else
    begin
      if rv0.y < rv1.y then begin l := rv0.y; h := rv1.y end else begin l := rv1.y; h := rv0.y end;
      y0 := (2 * b + a * d) / (2 * asq + 2);
      if (y0 >= l) and (y0 <= h) then
      begin
        x0 := (y0 - b) / a;
        New(p0); p0^.x := x0 + c.x; p0^.y := y0 + c.y;
      end;
      y1 := (2 * b - a * d) / (2 * asq + 2);
      if (y1 >= l) and (y1 <= h) then
      begin
        x1 := (y1 - b) / a;
        New(p1); p1^.x := x1 + c.x; p1^.y := y1 + c.y;
        if p0 = nil then
        begin
          p0 := p1;
          p1 := nil;
        end;
      end;
      if (p0 <> nil) then
      Result := True;
      Exit;
    end;
  end;
end;

function G2LineVsLine(const l0v0, l0v1, l1v0, l1v1: TG2Vec2; var p: TG2Vec2): Boolean;
  var a0, b0, a1, b1, x, y: TG2Float;
  var lv0, lv1, lh0, lh1: Boolean;
  var xl, xh, yl, yh: TG2Float;
  var xl0, xh0, yl0, yh0: TG2Float;
  var xl1, xh1, yl1, yh1: TG2Float;
begin
  if l0v0.x < l0v1.x then begin xl0 := l0v0.x; xh0 := l0v1.x; end else begin xl0 := l0v1.x; xh0 := l0v0.x; end;
  if l0v0.y < l0v1.y then begin yl0 := l0v0.y; yh0 := l0v1.y; end else begin yl0 := l0v1.y; yh0 := l0v0.y; end;
  if l1v0.x < l1v1.x then begin xl1 := l1v0.x; xh1 := l1v1.x; end else begin xl1 := l1v1.x; xh1 := l1v0.x; end;
  if l1v0.y < l1v1.y then begin yl1 := l1v0.y; yh1 := l1v1.y; end else begin yl1 := l1v1.y; yh1 := l1v0.y; end;
  if (xl0 > xh1) or (xl1 > xh0) or (yl0 > yh1) or (yl1 > yh0) then
  begin
    Result := False;
    Exit;
  end;
  lv0 := Abs(l0v0.x - l0v1.x) < G2EPS;
  lv1 := Abs(l1v0.x - l1v1.x) < G2EPS;
  if lv0 and lv1 then
  begin
    if Abs(l0v0.x - l1v0.x) < G2EPS then
    begin
      p.x := l0v0.x;
      if yh0 < yh1 then yh := yh0 else yh := yh1;
      if yl0 > yl1 then yl := yl0 else yl := yl1;
      p.y := (yh + yl) * 0.5;
      Result := True;
    end
    else
    Result := False;
    Exit;
  end;
  lh0 := Abs(l0v0.y - l0v1.y) < G2EPS;
  lh1 := Abs(l1v0.y - l1v1.y) < G2EPS;
  if lh0 and lh1 then
  begin
    if Abs(l0v0.y - l1v0.y) < G2EPS then
    begin
      p.y := l0v0.y;
      if xh0 < xh1 then xh := xh0 else xh := xh1;
      if xl0 > xl1 then xl := xl0 else xl := xl1;
      p.x := (xh + xl) * 0.5;
      Result := True;
    end
    else
    Result := False;
    Exit;
  end;
  if lv0 and lh1 then
  begin
    x := l0v0.x; y := l1v0.y;
  end
  else if lh0 and lv1 then
  begin
    x := l1v0.x; y := l0v0.y;
  end
  else if lv0 then
  begin
    x := l0v0.x;
    a1 := (l1v1.y - l1v0.y) / (l1v1.x - l1v0.x);
    b1 := l1v0.y - l1v0.x * a1;
    y := x * a1 + b1;
  end
  else if lh0 then
  begin
    y := l0v0.y;
    a1 := (l1v1.y - l1v0.y) / (l1v1.x - l1v0.x);
    b1 := l1v0.y - l1v0.x * a1;
    x := (y - b1) / a1;
  end
  else if lv1 then
  begin
    x := l1v0.x;
    a0 := (l0v1.y - l0v0.y) / (l0v1.x - l0v0.x);
    b0 := l0v0.y - l0v0.x * a0;
    y := x * a0 + b0;
  end
  else if lh1 then
  begin
    y := l1v0.y;
    a0 := (l0v1.y - l0v0.y) / (l0v1.x - l0v0.x);
    b0 := l0v0.y - l0v0.x * a0;
    x := (y - b0) / a0;
  end
  else
  begin
    a0 := (l0v1.y - l0v0.y) / (l0v1.x - l0v0.x);
    b0 := l0v0.y - l0v0.x * a0;
    a1 := (l1v1.y - l1v0.y) / (l1v1.x - l1v0.x);
    b1 := l1v0.y - l1v0.x * a1;
    if Abs(a1 - a0) < G2EPS then
    begin
      if xh0 < xh1 then xh := xh0 else xh := xh1;
      if xl0 > xl1 then xl := xl0 else xl := xl1;
      x := (xh + xl) * 0.5;
    end
    else
    x := (b0 - b1) / (a1 - a0);
    y := a0 * x + b0;
  end;
  if xl0 > xl1 then xl := xl0 else xl := xl1;
  if xh0 < xh1 then xh := xh0 else xh := xh1;
  if yl0 > yl1 then yl := yl0 else yl := yl1;
  if yh0 < yh1 then yh := yh0 else yh := yh1;
  if (x < xl) or (x > xh) or (y < yl) or (y > yh) then
  begin
    Result := False;
    Exit;
  end;
  p.SetValue(x, y);
  Result := True;
end;

function G2LineVsLineInf(const l0v0, l0v1, l1v0, l1v1: TG2Vec2; var p: TG2Vec2): Boolean;
  var a0, b0, a1, b1, x, y: TG2Float;
  var lv0, lv1, lh0, lh1: Boolean;
  var xl, xh, yl, yh: TG2Float;
  var xl0, xh0, yl0, yh0: TG2Float;
  var xl1, xh1, yl1, yh1: TG2Float;
begin
  if l0v0.x < l0v1.x then begin xl0 := l0v0.x; xh0 := l0v1.x; end else begin xl0 := l0v1.x; xh0 := l0v0.x; end;
  if l0v0.y < l0v1.y then begin yl0 := l0v0.y; yh0 := l0v1.y; end else begin yl0 := l0v1.y; yh0 := l0v0.y; end;
  if l1v0.x < l1v1.x then begin xl1 := l1v0.x; xh1 := l1v1.x; end else begin xl1 := l1v1.x; xh1 := l1v0.x; end;
  if l1v0.y < l1v1.y then begin yl1 := l1v0.y; yh1 := l1v1.y; end else begin yl1 := l1v1.y; yh1 := l1v0.y; end;
  lv0 := Abs(l0v0.x - l0v1.x) < G2EPS;
  lv1 := Abs(l1v0.x - l1v1.x) < G2EPS;
  if lv0 and lv1 then
  begin
    if Abs(l0v0.x - l1v0.x) < G2EPS then
    begin
      p.x := l0v0.x;
      if yh0 < yh1 then yh := yh0 else yh := yh1;
      if yl0 > yl1 then yl := yl0 else yl := yl1;
      p.y := (yh + yl) * 0.5;
      Result := True;
    end
    else
    Result := False;
    Exit;
  end;
  lh0 := Abs(l0v0.y - l0v1.y) < G2EPS;
  lh1 := Abs(l1v0.y - l1v1.y) < G2EPS;
  if lh0 and lh1 then
  begin
    if Abs(l0v0.y - l1v0.y) < G2EPS then
    begin
      p.y := l0v0.y;
      if xh0 < xh1 then xh := xh0 else xh := xh1;
      if xl0 > xl1 then xl := xl0 else xl := xl1;
      p.x := (xh + xl) * 0.5;
      Result := True;
    end
    else
    Result := False;
    Exit;
  end;
  if lv0 and lh1 then
  begin
    x := l0v0.x; y := l1v0.y;
  end
  else if lh0 and lv1 then
  begin
    x := l1v0.x; y := l0v0.y;
  end
  else if lv0 then
  begin
    x := l0v0.x;
    a1 := (l1v1.y - l1v0.y) / (l1v1.x - l1v0.x);
    b1 := l1v0.y - l1v0.x * a1;
    y := x * a1 + b1;
  end
  else if lh0 then
  begin
    y := l0v0.y;
    a1 := (l1v1.y - l1v0.y) / (l1v1.x - l1v0.x);
    b1 := l1v0.y - l1v0.x * a1;
    x := (y - b1) / a1;
  end
  else if lv1 then
  begin
    x := l1v0.x;
    a0 := (l0v1.y - l0v0.y) / (l0v1.x - l0v0.x);
    b0 := l0v0.y - l0v0.x * a0;
    y := x * a0 + b0;
  end
  else if lh1 then
  begin
    y := l1v0.y;
    a0 := (l0v1.y - l0v0.y) / (l0v1.x - l0v0.x);
    b0 := l0v0.y - l0v0.x * a0;
    x := (y - b0) / a0;
  end
  else
  begin
    a0 := (l0v1.y - l0v0.y) / (l0v1.x - l0v0.x);
    b0 := l0v0.y - l0v0.x * a0;
    a1 := (l1v1.y - l1v0.y) / (l1v1.x - l1v0.x);
    b1 := l1v0.y - l1v0.x * a1;
    if Abs(a1 - a0) < G2EPS then
    begin
      if xh0 < xh1 then xh := xh0 else xh := xh1;
      if xl0 > xl1 then xl := xl0 else xl := xl1;
      x := (xh + xl) * 0.5;
    end
    else
    x := (b0 - b1) / (a1 - a0);
    y := a0 * x + b0;
  end;
  p.SetValue(x, y);
  Result := True;
end;

function G2RectVsRect(const r0, r1: TG2Rect; var Resp: TG2Vec2): Boolean;
  var dx0, dx1, dy0, dy1, dy, dx: TG2Float;
begin
  Result := False;
  dx0 := r0.r - r1.l; dx1 := r1.r - r0.l;
  if (dx0 < 0) or (dx1 < 0) then Exit;
  dy0 := r0.b - r1.t; dy1 := r1.b - r0.t;
  if (dy0 < 0) or (dy1 < 0) then Exit;
  Result := True;
  if dx0 < dx1 then dx := dx0 else dx := dx1;
  if dy0 < dy1 then dy := dy0 else dy := dy1;
  if dx < dy then
  begin
    Resp.y := 0;
    if dx0 < dx1 then
    Resp.x := dx0
    else
    Resp.x := -dx1;
  end
  else
  begin
    Resp.x := 0;
    if dy0 < dy1 then
    Resp.y := dy0
    else
    Resp.y := -dy1;
  end;
end;

function G2Ray2VsRect(const RayOrigin, RayDir: TG2Vec2; const R: TG2Rect; var Intersection: TG2Vec2; var Dist: TG2Float): Boolean;
  var d, t, t0, t1, tn, tf: TG2Float;
  var i: TG2IntS32;
begin
  Result := False;
  tn := -1E+16;
  tf := 1E+16;
  for i := 0 to 1 do
  begin
    if Abs(RayDir[i]) < G2EPS then
    begin
      if (RayOrigin[i] < R.TopLeft[i])
      or (RayOrigin[i] > R.BottomRight[i]) then
      Exit;
    end;
    d := 1 / RayDir[i];
    t0 := (R.TopLeft[i] - RayOrigin[i]) * d;
    t1 := (R.BottomRight[i] - RayOrigin[i]) * d;
    if t0 > t1 then
    begin
      t := t1;
      t1 := t0;
      t0 := t;
    end;
    if t0 > tn then
    tn := t0;
    if t1 < tf then
    tf := t1;
    if (tn > tf) or (tf < 0) then Exit;
  end;
  if tn > 0 then
  begin
    Intersection.x := RayOrigin.x + RayDir.x * tn;
    Intersection.y := RayOrigin.y + RayDir.y * tn;
    Dist := tn;
  end
  else
  begin
    Intersection.x := RayOrigin.x + RayDir.x * tf;
    Intersection.y := RayOrigin.y + RayDir.y * tf;
    Dist := tf;
  end;
  Result := True;
end;

function G2Ballistics(const PosOrigin, PosTarget: TG2Vec2; const TotalVelocity, Gravity: TG2Float; var Trajectory0, Trajectory1: TG2Vec2; var Time0, Time1: TG2Float): Boolean;
  var x, y, x2, vt2, vt4, gr, gr2, dc, n0, n1, t2, t, vx, vy: Double;
begin
  x := PosTarget.x - PosOrigin.x;
  x2 := x * x;
  y := PosTarget.y - PosOrigin.y;
  vt2 := TotalVelocity * TotalVelocity;
  vt4 := vt2 * vt2;
  gr := Gravity; gr2 := gr * gr;
  dc := 16 * (2 * vt2 * y * gr + vt4 -  x2 * gr2);
  if dc > 0 then
  begin
    dc := Sqrt(dc);
    n0 := 4 * vt2 + 4 * y * gr;
    n1 := 1 / (2 * gr2);
    t2 := (n0 - dc) * n1;
    if t2 >= 0 then
    begin
      t := Sqrt(t2);
      vx := x / t;
      vy := (2 * y - gr * t2) / (2 * t);
      vx := Sqrt(vt2 - vy * vy);
      if (x < 0) <> (vx < 0) then vx := -vx;
      Trajectory0.x := vx;
      Trajectory0.y := vy;
      if Trajectory0.Len > TotalVelocity then
      Trajectory0 := Trajectory0.Norm * TotalVelocity;
      Time0 := t;
    end
    else
    begin
      Trajectory0.SetValue(0, 0);
      Time0 := 0;
      Result := False;
      Exit;
    end;
    t2 := (n0 + dc) * n1;
    if t2 >= 0 then
    begin
      t := Sqrt(t2);
      vx := x / t;
      vy := (2 * y - gr * t2) / (2 * t);
      Trajectory1.x := vx;
      Trajectory1.y := vy;
      if Trajectory1.Len > TotalVelocity then
      Trajectory1 := Trajectory1.Norm * TotalVelocity;
      Time1 := t;
    end
    else
    begin
      Trajectory1.SetValue(0, 0);
      Time1 := 0;
      Result := False;
      Exit;
    end;
    Result := True;
  end
  else
  begin
    Trajectory0.SetValue(0, 0);
    Trajectory1.SetValue(0, 0);
    Time0 := 0;
    Time1 := 0;
    Result := False;
  end;
end;

{$ifdef G2Cpu386}
procedure G2MatAddSSE(const OutM, InM1, InM2: PG2Mat); assembler;
asm
  movups xmm0, [InM1]
  movups xmm1, [InM2]
  addps xmm0, xmm1
  movlps [OutM], xmm0
  movhps [OutM + 8], xmm0
  movups xmm0, [InM1 + 10h]
  movups xmm1, [InM2 + 10h]
  addps xmm0, xmm1
  movlps [OutM + 10h], xmm0
  movhps [OutM + 18h], xmm0
  movups xmm0, [InM1 + 20h]
  movups xmm1, [InM2 + 20h]
  addps xmm0, xmm1
  movlps [OutM + 20h], xmm0
  movhps [OutM + 28h], xmm0
  movups xmm0, [InM1 + 30h]
  movups xmm1, [InM2 + 30h]
  addps xmm0, xmm1
  movlps [OutM + 30h], xmm0
  movhps [OutM + 38h], xmm0
end;
{$endif}

procedure G2MatAddStd(const OutM, InM1, InM2: PG2Mat);
begin
  with OutM^ do
  begin
    e00 := InM1^.e00 + InM2^.e00; e10 := InM1^.e10 + InM2^.e10; e20 := InM1^.e20 + InM2^.e20; e30 := InM1^.e30 + InM2^.e30;
    e01 := InM1^.e01 + InM2^.e01; e11 := InM1^.e11 + InM2^.e11; e21 := InM1^.e21 + InM2^.e21; e31 := InM1^.e31 + InM2^.e31;
    e02 := InM1^.e02 + InM2^.e02; e12 := InM1^.e12 + InM2^.e12; e22 := InM1^.e22 + InM2^.e22; e32 := InM1^.e32 + InM2^.e32;
    e03 := InM1^.e03 + InM2^.e03; e13 := InM1^.e13 + InM2^.e13; e23 := InM1^.e23 + InM2^.e23; e33 := InM1^.e33 + InM2^.e33;
  end;
end;

{$ifdef G2Cpu386}
procedure G2MatSubSSE(const OutM, InM1, InM2: PG2Mat); assembler;
asm
  movups xmm0, [InM1]
  movups xmm1, [InM2]
  subps xmm0, xmm1
  movlps [OutM], xmm0
  movhps [OutM + 8h], xmm0
  movups xmm0, [InM1 + 10h]
  movups xmm1, [InM2 + 10h]
  subps xmm0, xmm1
  movlps [OutM + 10h], xmm0
  movhps [OutM + 18h], xmm0
  movups xmm0, [InM1 + 20h]
  movups xmm1, [InM2 + 20h]
  subps xmm0, xmm1
  movlps [OutM + 20h], xmm0
  movhps [OutM + 28h], xmm0
  movups xmm0, [InM1 + 30h]
  movups xmm1, [InM2 + 30h]
  subps xmm0, xmm1
  movlps [OutM + 30h], xmm0
  movhps [OutM + 38h], xmm0
end;
{$endif}

procedure G2MatSubStd(const OutM, InM1, InM2: PG2Mat);
begin
  with OutM^ do
  begin
    e00 := InM1^.e00 - InM2^.e00; e10 := InM1^.e10 - InM2^.e10; e20 := InM1^.e20 - InM2^.e20; e30 := InM1^.e30 - InM2^.e30;
    e01 := InM1^.e01 - InM2^.e01; e11 := InM1^.e11 - InM2^.e11; e21 := InM1^.e21 - InM2^.e21; e31 := InM1^.e31 - InM2^.e31;
    e02 := InM1^.e02 - InM2^.e02; e12 := InM1^.e12 - InM2^.e12; e22 := InM1^.e22 - InM2^.e22; e32 := InM1^.e32 - InM2^.e32;
    e03 := InM1^.e03 - InM2^.e03; e13 := InM1^.e13 - InM2^.e13; e23 := InM1^.e23 - InM2^.e23; e33 := InM1^.e33 - InM2^.e33;
  end;
end;

{$ifdef G2Cpu386}
procedure G2MatFltMulSSE(const OutM, InM: PG2Mat; const s: PG2Float); assembler;
asm
  movss xmm0, [s]
  shufps xmm0, xmm0, 0
  movups xmm1, [InM]
  mulps xmm1, xmm0
  movlps [OutM], xmm1
  movhps [OutM + 8], xmm1
  movups xmm1, [InM + 10h]
  mulps xmm1, xmm0
  movlps [OutM + 10h], xmm1
  movhps [OutM + 18h], xmm1
  movups xmm1, [InM + 20h]
  mulps xmm1, xmm0
  movlps [OutM + 20h], xmm1
  movhps [OutM + 28h], xmm1
  movups xmm1, [InM + 30h]
  mulps xmm1, xmm0
  movlps [OutM + 30h], xmm1
  movhps [OutM + 38h], xmm1
end;
{$endif}

procedure G2MatFltMulStd(const OutM, InM: PG2Mat; const s: PG2Float);
begin
  OutM^.e00 := InM^.e00 * s^;
  OutM^.e10 := InM^.e10 * s^;
  OutM^.e20 := InM^.e20 * s^;
  OutM^.e30 := InM^.e30 * s^;
  OutM^.e01 := InM^.e01 * s^;
  OutM^.e11 := InM^.e11 * s^;
  OutM^.e21 := InM^.e21 * s^;
  OutM^.e31 := InM^.e31 * s^;
  OutM^.e02 := InM^.e02 * s^;
  OutM^.e12 := InM^.e12 * s^;
  OutM^.e22 := InM^.e22 * s^;
  OutM^.e32 := InM^.e32 * s^;
  OutM^.e03 := InM^.e03 * s^;
  OutM^.e13 := InM^.e13 * s^;
  OutM^.e23 := InM^.e23 * s^;
  OutM^.e33 := InM^.e33 * s^;
end;

{$ifdef G2Cpu386}
procedure G2MatMulSSE(const OutM, InM1, InM2: PG2Mat); assembler;
asm
  movss xmm0, [InM1]
  movups xmm4, [InM2]
  shufps xmm0, xmm0, 0
  mulps xmm0, xmm4
  movss xmm1, [InM1 + 4]
  movups xmm5, [InM2 + 10h]
  shufps xmm1, xmm1, 0
  mulps xmm1, xmm5
  addps xmm0, xmm1
  movss xmm1, [InM1 + 8]
  movups xmm6, [InM2 + 20h]
  shufps xmm1, xmm1, 0
  mulps xmm1, xmm6
  addps xmm0, xmm1
  movss xmm1, [InM1 + 0Ch]
  movups xmm7, [InM2 + 30h]
  shufps xmm1, xmm1, 0
  mulps xmm1, xmm7
  addps xmm0, xmm1
  movss xmm1, [InM1 + 10h]
  shufps xmm1, xmm1, 0
  mulps xmm1, xmm4
  movss xmm2, [InM1 + 14h]
  shufps xmm2, xmm2, 0
  mulps xmm2, xmm5
  addps xmm1, xmm2
  movss xmm2, [InM1 + 18h]
  shufps xmm2, xmm2, 0
  mulps xmm2, xmm6
  addps xmm1, xmm2
  movss xmm2, [InM1 + 1Ch]
  shufps xmm2, xmm2, 0
  mulps xmm2, xmm7
  addps xmm1, xmm2
  movss xmm2, [InM1 + 20h]
  shufps xmm2, xmm2, 0
  mulps xmm2, xmm4
  movss xmm3, [InM1 + 24h]
  shufps xmm3, xmm3, 0
  mulps xmm3, xmm5
  addps xmm2, xmm3
  movss xmm3, [InM1 + 28h]
  shufps xmm3, xmm3, 0
  mulps xmm3, xmm6
  addps xmm2, xmm3
  movss xmm3, [InM1 + 2Ch]
  shufps xmm3, xmm3, 0
  mulps xmm3, xmm7
  addps xmm2, xmm3
  movss xmm3, [InM1 + 30h]
  movlps [OutM], xmm0
  movhps [OutM + 8h], xmm0
  shufps xmm3, xmm3, 0
  mulps xmm3, xmm4
  movss xmm4, [InM1 + 34h]
  movlps [OutM + 10h], xmm1
  movhps [OutM + 18h], xmm1
  shufps xmm4, xmm4, 0
  mulps xmm4, xmm5
  addps xmm3, xmm4
  movss xmm4, [InM1 + 38h]
  movlps [OutM + 20h], xmm2
  movhps [OutM + 28h], xmm2
  shufps xmm4, xmm4, 0
  mulps xmm4, xmm6
  addps xmm3, xmm4
  movss xmm4, [InM1 + 3Ch]
  shufps xmm4, xmm4, 0
  mulps xmm4, xmm7
  addps xmm3, xmm4
  movlps [OutM + 30h], xmm3
  movhps [OutM + 38h], xmm3
end;
{$endif}

procedure G2MatMulStd(const OutM, InM1, InM2: PG2Mat);
  var mr: TG2Mat;
begin
  with mr do
  begin
    e00 := InM1^.e00 * InM2^.e00 + InM1^.e01 * InM2^.e10 + InM1^.e02 * InM2^.e20 + InM1^.e03 * InM2^.e30;
    e10 := InM1^.e10 * InM2^.e00 + InM1^.e11 * InM2^.e10 + InM1^.e12 * InM2^.e20 + InM1^.e13 * InM2^.e30;
    e20 := InM1^.e20 * InM2^.e00 + InM1^.e21 * InM2^.e10 + InM1^.e22 * InM2^.e20 + InM1^.e23 * InM2^.e30;
    e30 := InM1^.e30 * InM2^.e00 + InM1^.e31 * InM2^.e10 + InM1^.e32 * InM2^.e20 + InM1^.e33 * InM2^.e30;
    e01 := InM1^.e00 * InM2^.e01 + InM1^.e01 * InM2^.e11 + InM1^.e02 * InM2^.e21 + InM1^.e03 * InM2^.e31;
    e11 := InM1^.e10 * InM2^.e01 + InM1^.e11 * InM2^.e11 + InM1^.e12 * InM2^.e21 + InM1^.e13 * InM2^.e31;
    e21 := InM1^.e20 * InM2^.e01 + InM1^.e21 * InM2^.e11 + InM1^.e22 * InM2^.e21 + InM1^.e23 * InM2^.e31;
    e31 := InM1^.e30 * InM2^.e01 + InM1^.e31 * InM2^.e11 + InM1^.e32 * InM2^.e21 + InM1^.e33 * InM2^.e31;
    e02 := InM1^.e00 * InM2^.e02 + InM1^.e01 * InM2^.e12 + InM1^.e02 * InM2^.e22 + InM1^.e03 * InM2^.e32;
    e12 := InM1^.e10 * InM2^.e02 + InM1^.e11 * InM2^.e12 + InM1^.e12 * InM2^.e22 + InM1^.e13 * InM2^.e32;
    e22 := InM1^.e20 * InM2^.e02 + InM1^.e21 * InM2^.e12 + InM1^.e22 * InM2^.e22 + InM1^.e23 * InM2^.e32;
    e32 := InM1^.e30 * InM2^.e02 + InM1^.e31 * InM2^.e12 + InM1^.e32 * InM2^.e22 + InM1^.e33 * InM2^.e32;
    e03 := InM1^.e00 * InM2^.e03 + InM1^.e01 * InM2^.e13 + InM1^.e02 * InM2^.e23 + InM1^.e03 * InM2^.e33;
    e13 := InM1^.e10 * InM2^.e03 + InM1^.e11 * InM2^.e13 + InM1^.e12 * InM2^.e23 + InM1^.e13 * InM2^.e33;
    e23 := InM1^.e20 * InM2^.e03 + InM1^.e21 * InM2^.e13 + InM1^.e22 * InM2^.e23 + InM1^.e23 * InM2^.e33;
    e33 := InM1^.e30 * InM2^.e03 + InM1^.e31 * InM2^.e13 + InM1^.e32 * InM2^.e23 + InM1^.e33 * InM2^.e33;
  end;
  OutM^ := mr;
end;

{$ifdef G2Cpu386}
procedure G2MatInvSSE(const OutM, InM: PG2Mat); assembler;
asm
  movlps xmm0, [InM]
  movhps xmm0, [InM + 10h]
  movlps xmm1, [InM + 20h]
  movhps xmm1, [InM + 30h]
  movaps xmm2, xmm0
  shufps xmm2, xmm1, $88
  shufps xmm1, xmm0, $DD
  movlps xmm0, [InM + 8]
  movhps xmm0, [InM + 18h]
  movlps xmm3, [InM + 28h]
  movhps xmm3, [InM + 38h]
  movaps xmm4, xmm0
  shufps xmm4, xmm3, $88
  shufps xmm3, xmm0, $DD
  movaps xmm0, xmm4
  mulps xmm0, xmm3
  shufps xmm0, xmm0, $B1
  movaps xmm5, xmm1
  mulps xmm5, xmm0
  movaps xmm6, xmm2
  mulps xmm6, xmm0
  shufps xmm0, xmm0, $4E
  movaps xmm7, xmm5
  movaps xmm5, xmm1
  mulps xmm5, xmm0
  subps xmm5, xmm7
  movaps xmm7, xmm6
  movaps xmm6, xmm2
  mulps xmm6, xmm0
  subps xmm6, xmm7
  shufps xmm6, xmm6, $4E
  movlps [OutM], xmm6
  movhps [OutM + 8], xmm6
  movaps xmm0, xmm1
  mulps xmm0, xmm4
  shufps xmm0, xmm0, $B1
  movaps xmm7, xmm5
  movaps xmm5, xmm3
  mulps xmm5, xmm0
  addps xmm5, xmm7
  movaps xmm6, xmm2
  mulps xmm6, xmm0
  shufps xmm0, xmm0, $4E
  movaps xmm7, xmm3
  mulps xmm7, xmm0
  subps xmm5, xmm7
  movaps xmm7, xmm6
  movaps xmm6, xmm2
  mulps xmm6, xmm0
  subps xmm6, xmm7
  shufps xmm6, xmm6, $4E
  movaps xmm0, xmm1
  shufps xmm0, xmm0, $4E
  mulps xmm0, xmm3
  shufps xmm0, xmm0, $B1
  shufps xmm4, xmm4, $4E
  movaps xmm7, xmm4
  mulps xmm7, xmm0
  addps xmm5, xmm7
  movlps [OutM + 10h], xmm6
  movhps [OutM + 18h], xmm6
  movaps xmm6, xmm2
  mulps xmm6, xmm0
  shufps xmm0, xmm0, $4E
  movaps xmm7, xmm4
  mulps xmm7, xmm0
  subps xmm5, xmm7
  movaps xmm7, xmm6
  movaps xmm6, xmm2
  mulps xmm6, xmm0
  subps xmm6, xmm7
  shufps xmm6, xmm6, $4E
  movaps xmm0, xmm2
  mulps xmm0, xmm1
  shufps xmm0, xmm0, $B1
  movaps xmm7, xmm3
  mulps xmm7, xmm0
  addps xmm6, xmm7
  movlps [OutM + 20h], xmm5
  movhps [OutM + 28h], xmm5
  movups xmm7, [OutM + 10h]
  movaps xmm5, xmm4
  mulps xmm5, xmm0
  subps xmm5, xmm7
  shufps xmm0, xmm0, $4E
  movaps xmm7, xmm6
  movaps xmm6, xmm3
  mulps xmm6, xmm0
  subps xmm6, xmm7
  movaps xmm7, xmm4
  mulps xmm7, xmm0
  subps xmm5, xmm7
  movaps xmm0, xmm2
  mulps xmm0, xmm3
  shufps xmm0, xmm0, $B1
  movlps [OutM + 10h], xmm5
  movhps [OutM + 18h], xmm5
  movups xmm5, [OutM]
  movaps xmm7, xmm4
  mulps xmm7, xmm0
  subps xmm5, xmm7
  movaps xmm7, xmm1
  mulps xmm7, xmm0
  addps xmm6, xmm7
  shufps xmm0, xmm0, $4E
  movaps xmm7, xmm4
  mulps xmm7, xmm0
  addps xmm5, xmm7
  movaps xmm7, xmm1
  mulps xmm7, xmm0
  subps xmm6, xmm7
  movaps xmm0, xmm2
  mulps xmm0, xmm4
  movups xmm4, [OutM + 10h]
  shufps xmm0, xmm0, $B1
  movaps xmm7, xmm3
  mulps xmm7, xmm0
  addps xmm5, xmm7
  movaps xmm7, xmm1
  mulps xmm7, xmm0
  subps xmm4, xmm7
  shufps xmm0, xmm0, $4E
  mulps xmm3, xmm0
  subps xmm5, xmm3
  mulps xmm1, xmm0
  addps xmm4, xmm1
  movups xmm1, [OutM + 20h]
  mulps xmm2, xmm1
  movaps xmm7, xmm2
  shufps xmm7, xmm7, $4E
  addps xmm2, xmm7
  movaps xmm7, xmm2
  shufps xmm7, xmm7, $B1
  addss xmm2, xmm7
  rcpss xmm0, xmm2
  movss xmm7, xmm0
  mulss xmm7, xmm7
  mulss xmm2, xmm7
  addss xmm0, xmm0
  subss xmm0, xmm2
  shufps xmm0, xmm0, 0
  mulps xmm1, xmm0
  movlps [OutM], xmm1
  movhps [OutM + 8], xmm1
  mulps xmm5, xmm0
  movlps [OutM + 10h], xmm5
  movhps [OutM + 18h], xmm5
  mulps xmm6, xmm0
  movlps [OutM + 20h], xmm6
  movhps [OutM + 28h], xmm6
  mulps xmm4, xmm0
  movlps [OutM + 30h], xmm4
  movhps [OutM + 38h], xmm4
end;
{$endif}

procedure G2MatInvStd(const OutM, InM: PG2Mat);
  var d, di: TG2Float;
begin
  di := InM^.e00;
  d := 1 / di;
  with OutM^ do
  begin
    e00 := d;
    e10 := -InM^.e10 * d;
    e20 := -InM^.e20 * d;
    e30 := -InM^.e30 * d;
    e01 := InM^.e01 * d;
    e02 := InM^.e02 * d;
    e03 := InM^.e03 * d;
    e11 := InM^.e11 + e10 * e01 * di;
    e12 := InM^.e12 + e10 * e02 * di;
    e13 := InM^.e13 + e10 * e03 * di;
    e21 := InM^.e21 + e20 * e01 * di;
    e22 := InM^.e22 + e20 * e02 * di;
    e23 := InM^.e23 + e20 * e03 * di;
    e31 := InM^.e31 + e30 * e01 * di;
    e32 := InM^.e32 + e30 * e02 * di;
    e33 := InM^.e33 + e30 * e03 * di;
    di := e11;
    d := 1 / di;
    e11 := d;
    e01 := -e01 * d;
    e21 := -e21 * d;
    e31 := -e31 * d;
    e10 := e10 * d;
    e12 := e12 * d;
    e13 := e13 * d;
    e00 := e00 + e01 * e10 * di;
    e02 := e02 + e01 * e12 * di;
    e03 := e03 + e01 * e13 * di;
    e20 := e20 + e21 * e10 * di;
    e22 := e22 + e21 * e12 * di;
    e23 := e23 + e21 * e13 * di;
    e30 := e30 + e31 * e10 * di;
    e32 := e32 + e31 * e12 * di;
    e33 := e33 + e31 * e13 * di;
    di := e22;
    d := 1 / di;
    e22 := d;
    e02 := -e02 * d;
    e12 := -e12 * d;
    e32 := -e32 * d;
    e20 := e20 * d;
    e21 := e21 * d;
    e23 := e23 * d;
    e00 := e00 + e02 * e20 * di;
    e01 := e01 + e02 * e21 * di;
    e03 := e03 + e02 * e23 * di;
    e10 := e10 + e12 * e20 * di;
    e11 := e11 + e12 * e21 * di;
    e13 := e13 + e12 * e23 * di;
    e30 := e30 + e32 * e20 * di;
    e31 := e31 + e32 * e21 * di;
    e33 := e33 + e32 * e23 * di;
    di := e33;
    d := 1 / di;
    e33 := d;
    e03 := -e03 * d;
    e13 := -e13 * d;
    e23 := -e23 * d;
    e30 := e30 * d;
    e31 := e31 * d;
    e32 := e32 * d;
    e00 := e00 + e03 * e30 * di;
    e01 := e01 + e03 * e31 * di;
    e02 := e02 + e03 * e32 * di;
    e10 := e10 + e13 * e30 * di;
    e11 := e11 + e13 * e31 * di;
    e12 := e12 + e13 * e32 * di;
    e20 := e20 + e23 * e30 * di;
    e21 := e21 + e23 * e31 * di;
    e22 := e22 + e23 * e32 * di;
  end;
end;

procedure G2Vec2MatMul3x3(const OutV, InV: PG2Vec2; const InM: PG2Mat);
  var vr: TG2Vec2;
begin
  vr.x := InV^.x * InM^.e00 + InV^.y * InM^.e10;
  vr.y := InV^.x * InM^.e01 + InV^.y * InM^.e11;
  OutV^ := vr;
end;

procedure G2Vec2MatMul4x3(const OutV, InV: PG2Vec2; const InM: PG2Mat);
  var vr: TG2Vec2;
begin
  vr.x := InV^.x * InM^.e00 + InV^.y * InM^.e10 + InM^.e30;
  vr.y := InV^.x * InM^.e01 + InV^.y * InM^.e11 + InM^.e31;
  OutV^ := vr;
end;

procedure G2Vec2MatMul4x4(const OutV, InV: PG2Vec2; const InM: PG2Mat);
  var vr: TG2Vec2;
  var w: TG2Float;
begin
  vr.x := InV^.x * InM^.e00 + InV^.y * InM^.e10 + InM^.e30;
  vr.y := InV^.x * InM^.e01 + InV^.y * InM^.e11 + InM^.e31;
  w := 1 / (InV^.x * InM^.e03 + InV^.y * InM^.e13 + InM^.e33);
  OutV^.x := vr.x * w;
  OutV^.y := vr.y * w;
end;

{$ifdef G2Cpu386}
procedure G2Vec3MatMul3x3SSE(const OutV, InV: PG2Vec3; const InM: PG2Mat); assembler;
asm
  movups xmm0, [InM]
  movss xmm1, [InV]
  shufps xmm1, xmm1, 0
  mulps xmm1, xmm0
  movups xmm0, [InM + 10h]
  movss xmm2, [InV + 4]
  shufps xmm2, xmm2, 0
  mulps xmm2, xmm0
  addps xmm1, xmm2
  movups xmm0, [InM + 20h]
  movss xmm2, [InV + 8]
  shufps xmm2, xmm2, 0
  mulps xmm2, xmm0
  addps xmm1, xmm2
  movlps [OutV], xmm1
  movhlps xmm1, xmm1
  movss [OutV + 8], xmm1
end;
{$endif}

procedure G2Vec3MatMul3x3Std(const OutV, InV: PG2Vec3; const InM: PG2Mat);
  var vr: TG2Vec3;
begin
  vr.x := InV^.x * InM^.e00 + InV^.y * InM^.e10 + InV^.z * InM^.e20;
  vr.y := InV^.x * InM^.e01 + InV^.y * InM^.e11 + InV^.z * InM^.e21;
  vr.z := InV^.x * InM^.e02 + InV^.y * InM^.e12 + InV^.z * InM^.e22;
  OutV^ := vr;
end;

{$ifdef G2Cpu386}
procedure G2Vec3MatMul4x3SSE(const OutV, InV: PG2Vec3; const InM: PG2Mat); assembler;
asm
  movups xmm0, [InM]
  movss xmm1, [InV]
  shufps xmm1, xmm1, 0
  mulps xmm1, xmm0
  movups xmm0, [InM + 10h]
  movss xmm2, [InV + 4]
  shufps xmm2, xmm2, 0
  mulps xmm2, xmm0
  addps xmm1, xmm2
  movups xmm0, [InM + 20h]
  movss xmm2, [InV + 8]
  shufps xmm2, xmm2, 0
  mulps xmm2, xmm0
  addps xmm1, xmm2
  movups xmm0, [InM + 30h]
  addps xmm1, xmm0
  movlps [OutV], xmm1
  movhlps xmm1, xmm1
  movss [OutV + 8], xmm1
end;
{$endif}

procedure G2Vec3MatMul4x3Std(const OutV, InV: PG2Vec3; const InM: PG2Mat);
  var vr: TG2Vec3;
begin
  vr.x := InV^.x * InM^.e00 + InV^.y * InM^.e10 + InV^.z * InM^.e20 + InM^.e30;
  vr.y := InV^.x * InM^.e01 + InV^.y * InM^.e11 + InV^.z * InM^.e21 + InM^.e31;
  vr.z := InV^.x * InM^.e02 + InV^.y * InM^.e12 + InV^.z * InM^.e22 + InM^.e32;
  OutV^ := vr;
end;

{$ifdef G2Cpu386}
procedure G2Vec3MatMul4x4SSE(const OutV, InV: PG2Vec3; const InM: PG2Mat); assembler;
asm
  movups xmm0, [InM]
  movss xmm1, [InV]
  shufps xmm1, xmm1, 0
  mulps xmm1, xmm0
  movups xmm0, [InM + 10h]
  movss xmm2, [InV + 4]
  shufps xmm2, xmm2, 0
  mulps xmm2, xmm0
  addps xmm1, xmm2
  movups xmm0, [InM + 20h]
  movss xmm2, [InV + 8]
  shufps xmm2, xmm2, 0
  mulps xmm2, xmm0
  addps xmm1, xmm2
  movups xmm0, [InM + 30h]
  addps xmm1, xmm0
  movaps xmm0, xmm1
  shufps xmm0, xmm0, $FF
  rcpps xmm0, xmm0
  mulps xmm1, xmm0
  movlps [OutV], xmm1
  movhlps xmm1, xmm1
  movss [OutV + 8], xmm1
end;
{$endif}

procedure G2Vec3MatMul4x4Std(const OutV, InV: PG2Vec3; const InM: PG2Mat);
  var vr: TG2Vec3;
  var w: TG2Float;
begin
  vr.x := InV^.x * InM^.e00 + InV^.y * InM^.e10 + InV^.z * InM^.e20 + InM^.e30;
  vr.y := InV^.x * InM^.e01 + InV^.y * InM^.e11 + InV^.z * InM^.e21 + InM^.e31;
  vr.z := InV^.x * InM^.e02 + InV^.y * InM^.e12 + InV^.z * InM^.e22 + InM^.e32;
  w := 1 / (InV^.x * InM^.e03 + InV^.y * InM^.e13 + InV^.z * InM^.e23 + InM^.e33);
  OutV^.x := vr.x * w;
  OutV^.y := vr.y * w;
  OutV^.z := vr.z * w;
end;

{$ifdef G2Cpu386}
procedure G2Vec4MatMulSSE(const OutV, InV: PG2Vec4; const InM: PG2Mat); assembler;
asm
  movups xmm0, [InM]
  movss xmm1, [InV]
  shufps xmm1, xmm1, 0
  mulps xmm1, xmm0
  movups xmm0, [InM + 10h]
  movss xmm2, [InV + 4]
  shufps xmm2, xmm2, 0
  mulps xmm2, xmm0
  addps xmm1, xmm2
  movups xmm0, [InM + 20h]
  movss xmm2, [InV + 8]
  shufps xmm2, xmm2, 0
  mulps xmm2, xmm0
  addps xmm1, xmm2
  movups xmm0, [InM + 30h]
  movss xmm2, [InV + 0Ch]
  shufps xmm2, xmm2, 0
  mulps xmm2, xmm0
  addps xmm1, xmm2
  movups [OutV], xmm1
end;
{$endif}

procedure G2Vec4MatMulStd(const OutV, InV: PG2Vec4; const InM: PG2Mat);
  var vr: TG2Vec4;
begin
  vr.x := InV^.x * InM^.e00 + InV^.y * InM^.e10 + InV^.z * InM^.e20 + InV^.w * InM^.e30;
  vr.y := InV^.x * InM^.e01 + InV^.y * InM^.e11 + InV^.z * InM^.e21 + InV^.w * InM^.e31;
  vr.z := InV^.x * InM^.e02 + InV^.y * InM^.e12 + InV^.z * InM^.e22 + InV^.w * InM^.e32;
  vr.w := InV^.x * InM^.e03 + InV^.y * InM^.e13 + InV^.z * InM^.e23 + InV^.w * InM^.e33;
  OutV^ := vr;
end;

{$ifdef G2Cpu386}
function G2Vec3LenSSE(const InV: PG2Vec3): TG2Float; assembler;
asm
  movss xmm0, [InV + 8]
  movlhps xmm0, xmm0
  movlps xmm0, [InV]
  mulps xmm0, xmm0
  movaps xmm1, xmm0
  shufps xmm1, xmm1, $C9
  addss xmm0, xmm1
  shufps xmm1, xmm1, $C9
  addss xmm0, xmm1
  sqrtss xmm0, xmm0
  movss [Result], xmm0
end;
{$endif}

function G2Vec3LenStd(const InV: PG2Vec3): TG2Float;
begin
  Result := Sqrt(InV^.x * InV^.x + InV^.y * InV^.y + InV^.z * InV^.z);
end;

{$ifdef G2Cpu386}
function G2Vec4LenSSE(const InV: PG2Vec4): TG2Float; assembler;
asm
  movups xmm0, [InV]
  mulps xmm0, xmm0
  movaps xmm1, xmm0
  shufps xmm1, xmm1, $B1
  addps xmm0, xmm1
  movhlps xmm1, xmm0
  addss xmm0, xmm1
  sqrtss xmm0, xmm0
  movss [Result], xmm0
end;
{$endif}

function G2Vec4LenStd(const InV: PG2Vec4): TG2Float;
begin
  Result := Sqrt(InV^.x * InV^.x + InV^.y * InV^.y + InV^.z * InV^.z + InV^.w * InV^.w);
end;

procedure G2Vec2Norm(const OutV, InV: PG2Vec2);
  var d: TG2Float;
begin
  d := Sqrt(InV^.x * InV^.x + InV^.y * InV^.y);
  if d > 0 then
  begin
    d := 1 / d;
    OutV^.x := InV^.x * d;
    OutV^.y := InV^.y * d;
  end
  else
  begin
    OutV^.x := 0;
    OutV^.y := 0;
  end;
end;

{$ifdef G2Cpu386}
procedure G2Vec3NormSSE(const OutV, InV: PG2Vec3); assembler;
asm
  movss xmm0, [InV + 8]
  movlhps xmm0, xmm0
  movlps xmm0, [InV]
  movaps xmm1, xmm0
  mulps xmm1, xmm1
  movaps xmm2, xmm1
  shufps xmm2, xmm2, $C9
  addss xmm1, xmm2
  shufps xmm2, xmm2, $C9
  addss xmm1, xmm2
  movss [OutV], xmm1
  mov ecx, OutV
  cmp dword ptr [OutV], 0
  jbe @Bail
  mov OutV, ecx
  rsqrtss xmm1, xmm1
  shufps xmm1, xmm1, 0
  mulps xmm0, xmm1
  movlps [OutV], xmm0
  movhlps xmm0, xmm0
  movss [OutV + 8], xmm0
  jmp @Exit
@Bail:
  mov dword ptr [OutV], 0
  mov dword ptr [OutV + 4], 0
  mov dword ptr [OutV + 8], 0
@Exit:
end;
{$endif}

procedure G2Vec3NormStd(const OutV, InV: PG2Vec3);
  var d: TG2Float;
begin
  d := Sqrt(InV^.x * InV^.x + InV^.y * InV^.y + InV^.z * InV^.z);
  if d > 0 then
  begin
    d := 1 / d;
    OutV^.x := InV^.x * d;
    OutV^.y := InV^.y * d;
    OutV^.z := InV^.z * d;
  end
  else
  begin
    OutV^.x := 0;
    OutV^.y := 0;
    OutV^.z := 0;
  end;
end;

{$ifdef G2Cpu386}
procedure G2Vec4NormSSE(const OutV, InV: PG2Vec4); assembler;
asm
  movups xmm0, [InV]
  movaps xmm1, xmm0
  mulps xmm1, xmm1
  movaps xmm2, xmm1
  shufps xmm2, xmm2, $B1
  addps xmm1, xmm2
  movhlps xmm2, xmm1
  addss xmm1, xmm2
  movss [OutV], xmm1
  mov ecx, OutV
  cmp dword ptr [OutV], 0
  jbe @Bail
  mov OutV, ecx
  rsqrtss xmm1, xmm1
  shufps xmm1, xmm1, 0
  mulps xmm0, xmm1
  movlps [OutV], xmm0
  movhps [OutV + 8], xmm0
  jmp @Exit
@Bail:
  mov dword ptr [OutV], 0
  mov dword ptr [OutV + 4], 0
  mov dword ptr [OutV + 8], 0
  mov dword ptr [OutV + 12], 0
@Exit:
end;
{$endif}

procedure G2Vec4NormStd(const OutV, InV: PG2Vec4);
  var d: TG2Float;
begin
  d := Sqrt(InV^.x * InV^.x + InV^.y * InV^.y + InV^.z * InV^.z + InV^.w * InV^.w);
  if d > 0 then
  begin
    d := 1 / d;
    OutV^.x := InV^.x * d;
    OutV^.y := InV^.y * d;
    OutV^.z := InV^.z * d;
    OutV^.w := InV^.w * d;
  end
  else
  begin
    OutV^.x := 0;
    OutV^.y := 0;
    OutV^.z := 0;
    OutV^.w := 0;
  end;
end;

{$ifdef G2Cpu386}
procedure G2Vec3CrossSSE(const OutV, InV1, InV2: PG2Vec3); assembler;
asm
  movss xmm1, [InV1 + 8]
  movlhps xmm1, xmm1
  movlps xmm1, [InV1]
  movss xmm2, [InV2 + 8]
  movlhps xmm2, xmm2
  movlps xmm2, [InV2]
  shufps xmm1, xmm1, $C9
  shufps xmm2, xmm2, $D2
  movaps xmm0, xmm1
  mulps xmm0, xmm2
  shufps xmm1, xmm1, $C9
  shufps xmm2, xmm2, $D2
  mulps xmm1, xmm2
  subps xmm0, xmm1
  movlps [OutV], xmm0
  movhlps xmm0, xmm0
  movss [OutV + 8], xmm0
end;
{$endif}

procedure G2Vec3CrossStd(const OutV, InV1, InV2: PG2Vec3);
begin
  OutV^.x := InV1^.y * InV2^.z - InV1^.z * InV2^.y;
  OutV^.y := InV1^.z * InV2^.x - InV1^.x * InV2^.z;
  OutV^.z := InV1^.x * InV2^.y - InV1^.y * InV2^.x;
end;

{$if defined(G2Cpu386) and (defined(G2Target_Windows) or defined(G2Target_Linux))}
var SysMMX: Boolean = False;
var SysSSE: Boolean = False;
var SysSSE2: Boolean = False;
var SysSSE3: Boolean = False;
procedure CPUExtensions; assembler;
asm
  push ebx
  mov eax, 1
  cpuid
  test ecx, 00000001h
  jz @CheckSSE2
  mov [SysSSE3], 1
@CheckSSE2:
  test edx, 04000000h
  jz @CheckSSE
  mov [SysSSE2], 1
@CheckSSE:
  test edx, 02000000h
  jz @CheckMMX
  mov [SysSSE], 1
@CheckMMX:
  test edx, 00800000h
  jz @Done
  mov [SysMMX], 1
@Done:
  pop ebx
end;
{$endif}

procedure G2InitializeMath;
begin
  {$if defined(G2Cpu386) and (defined(G2Target_Windows) or defined(G2Target_Linux))}
  CPUExtensions;
  if SysSSE then
  begin
    G2MatAdd := @G2MatAddSSE;
    G2MatSub := @G2MatSubSSE;
    G2MatFltMul := @G2MatFltMulSSE;
    G2MatMul := @G2MatMulSSE;
    G2MatInv := @G2MatInvSSE;
    G2Vec3MatMul3x3 := @G2Vec3MatMul3x3SSE;
    G2Vec3MatMul4x3 := @G2Vec3MatMul4x3SSE;
    G2Vec3MatMul4x4 := @G2Vec3MatMul4x4SSE;
    G2Vec4MatMul := @G2Vec4MatMulSSE;
    G2Vec3Len := @G2Vec3LenSSE;
    G2Vec4Len := @G2Vec4LenSSE;
    G2Vec3Norm := @G2Vec3NormSSE;
    G2Vec4Norm := @G2Vec4NormSSE;
    G2Vec3Cross := @G2Vec3CrossSSE;
  end
  else
  begin
    G2MatAdd := @G2MatAddStd;
    G2MatSub := @G2MatSubStd;
    G2MatFltMul := @G2MatFltMulStd;
    G2MatMul := @G2MatMulStd;
    G2MatInv := @G2MatInvStd;
    G2Vec3MatMul3x3 := @G2Vec3MatMul3x3Std;
    G2Vec3MatMul4x3 := @G2Vec3MatMul4x3Std;
    G2Vec3MatMul4x4 := @G2Vec3MatMul4x4Std;
    G2Vec4MatMul := @G2Vec4MatMulStd;
    G2Vec3Len := @G2Vec3LenStd;
    G2Vec4Len := @G2Vec4LenStd;
    G2Vec3Norm := @G2Vec3NormStd;
    G2Vec4Norm := @G2Vec4NormStd;
    G2Vec3Cross := @G2Vec3CrossStd;
  end;
  {$else}
  G2MatAdd := @G2MatAddStd;
  G2MatSub := @G2MatSubStd;
  G2MatFltMul := @G2MatFltMulStd;
  G2MatMul := @G2MatMulStd;
  G2MatInv := @G2MatInvStd;
  G2Vec3MatMul3x3 := @G2Vec3MatMul3x3Std;
  G2Vec3MatMul4x3 := @G2Vec3MatMul4x3Std;
  G2Vec3MatMul4x4 := @G2Vec3MatMul4x4Std;
  G2Vec4MatMul := @G2Vec4MatMulStd;
  G2Vec3Len := @G2Vec3LenStd;
  G2Vec4Len := @G2Vec4LenStd;
  G2Vec3Norm := @G2Vec3NormStd;
  G2Vec4Norm := @G2Vec4NormStd;
  G2Vec3Cross := @G2Vec3CrossStd;
  {$endif}
end;

initialization
begin
  G2InitializeMath;
end;

end.
