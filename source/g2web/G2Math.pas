unit G2Math;

//The contents of this software are used with permission, subject to
//the Mozilla Public License Version 1.1 (the "License"); you may
//not use this software except in compliance with the License. You may
//obtain a copy of the License at
//http://www.mozilla.org/MPL/MPL-1.1.html
//
//Software distributed under the License is distributed on an
//"AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
//implied. See the License for the specific language governing
//rights and limitations under the License.
//
//This module is a part of g2mp game development framework.

interface

uses
  w3c.TypedArray,
  G2Types;

type
  {$Hints off}
  TG2Point = record
  public
    x, y: Integer;
  end;
  {$Hints on}

  {$Hints off}
  TG2Rect = record
  public
    l, t, r, b: Integer;
  end;
  {$Hints on}

  {$Hints off}
  TG2Vec2 = record
  public
    Arr: array[0..1] of TG2Float;
  private
    function GetX: TG2Float;
    procedure SetX(const Value: TG2Float);
    function GetY: TG2Float;
    procedure SetY(const Value: TG2Float);
    function GetE(const Index: Integer): TG2Float;
    procedure SetE(const Index: Integer; const Value: TG2Float);
  public
    property x: TG2Float read GetX write SetX;
    property y: TG2Float read GetY write SetY;
    property e[const Index: Integer]: TG2Float read GetE write SetE; default;
    procedure SetValue(const _x, _y: TG2Float);
    function LenSq: TG2Float;
    function Len: TG2Float;
    function Norm: TG2Vec2;
    function Perp: TG2Vec2;
    function ToFloat32Array: JFloat32Array;
    function CopyRef: TG2Vec2;
    class function Instance: TG2Vec2;
  end;
  {$Hints on}

  {$Hints off}
  TG2Vec3 = record
  public
    Arr: array[0..2] of TG2Float;
  private
    function GetX: TG2Float;
    procedure SetX(const Value: TG2Float);
    function GetY: TG2Float;
    procedure SetY(const Value: TG2Float);
    function GetZ: TG2Float;
    procedure SetZ(const Value: TG2Float);
    function GetE(const Index: Integer): TG2Float;
    procedure SetE(const Index: Integer; const Value: TG2Float);
  public
    property x: TG2Float read GetX write SetX;
    property y: TG2Float read GetY write SetY;
    property z: TG2Float read GetZ write SetZ;
    property e[const Index: Integer]: TG2Float read GetE write SetE; default;
    procedure SetValue(const _x, _y, _z: TG2Float);
    function LenSq: TG2Float;
    function Len: TG2Float;
    function Dot(const v: TG2Vec3): TG2Float;
    function Cross(const v: TG2Vec3): TG2Vec3;
    function Norm: TG2Vec3;
    function ToFloat32Array: JFloat32Array;
    function CopyRef: TG2Vec3;
    class function Instance: TG2Vec3;
  end;
  {$Hints on}

  {$Hints off}
  TG2Vec4 = record
  public
    Arr: array[0..3] of TG2Float;
  private
    function GetX: TG2Float;
    procedure SetX(const Value: TG2Float);
    function GetY: TG2Float;
    procedure SetY(const Value: TG2Float);
    function GetZ: TG2Float;
    procedure SetZ(const Value: TG2Float);
    function GetW: TG2Float;
    procedure SetW(const Value: TG2Float);
    function GetE(const Index: Integer): TG2Float;
    procedure SetE(const Index: Integer; const Value: TG2Float);
  public
    property x: TG2Float read GetX write SetX;
    property y: TG2Float read GetY write SetY;
    property z: TG2Float read GetZ write SetZ;
    property w: TG2Float read GetW write SetW;
    property e[const Index: Integer]: TG2Float read GetE write SetE; default;
    procedure SetValue(const _x, _y, _z, _w: TG2Float);
    function ToFloat32Array: JFloat32Array;
    function CopyRef: TG2Vec4;
    class function Instance: TG2Vec4;
  end;
  {$Hints on}

  {$Hints off}
  TG2Quat = record
  public
    Arr: array[0..3] of TG2Float;
  private
    function GetX: TG2Float;
    procedure SetX(const Value: TG2Float);
    function GetY: TG2Float;
    procedure SetY(const Value: TG2Float);
    function GetZ: TG2Float;
    procedure SetZ(const Value: TG2Float);
    function GetW: TG2Float;
    procedure SetW(const Value: TG2Float);
    function GetE(const Index: Integer): TG2Float;
    procedure SetE(const Index: Integer; const Value: TG2Float);
  public
    property x: TG2Float read GetX write SetX;
    property y: TG2Float read GetY write SetY;
    property z: TG2Float read GetZ write SetZ;
    property w: TG2Float read GetW write SetW;
    property e[const Index: Integer]: TG2Float read GetE write SetE; default;
    procedure SetValue(const _x, _y, _z, _w: TG2Float);
    function ToFloat32Array: JFloat32Array;
    function CopyRef: TG2Quat;
    class function Instance: TG2Quat;
  end;
  {$Hints on}

  {$Hints off}
  TG2Mat = record
  public
    Arr: array[0..15] of TG2Float;
  private
    function GetE00: TG2Float;
    procedure SetE00(const Value: TG2Float);
    function GetE01: TG2Float;
    procedure SetE01(const Value: TG2Float);
    function GetE02: TG2Float;
    procedure SetE02(const Value: TG2Float);
    function GetE03: TG2Float;
    procedure SetE03(const Value: TG2Float);
    function GetE10: TG2Float;
    procedure SetE10(const Value: TG2Float);
    function GetE11: TG2Float;
    procedure SetE11(const Value: TG2Float);
    function GetE12: TG2Float;
    procedure SetE12(const Value: TG2Float);
    function GetE13: TG2Float;
    procedure SetE13(const Value: TG2Float);
    function GetE20: TG2Float;
    procedure SetE20(const Value: TG2Float);
    function GetE21: TG2Float;
    procedure SetE21(const Value: TG2Float);
    function GetE22: TG2Float;
    procedure SetE22(const Value: TG2Float);
    function GetE23: TG2Float;
    procedure SetE23(const Value: TG2Float);
    function GetE30: TG2Float;
    procedure SetE30(const Value: TG2Float);
    function GetE31: TG2Float;
    procedure SetE31(const Value: TG2Float);
    function GetE32: TG2Float;
    procedure SetE32(const Value: TG2Float);
    function GetE33: TG2Float;
    procedure SetE33(const Value: TG2Float);
    function GetE(const Index: Integer): TG2Float;
    procedure SetE(const Index: Integer; const Value: TG2Float);
    function GetMat(const x, y: Integer): TG2Float;
    procedure SetMat(const x, y: Integer; const Value: TG2Float);
  public
    property e00: TG2Float read GetE00 write SetE00;
    property e01: TG2Float read GetE01 write SetE01;
    property e02: TG2Float read GetE02 write SetE02;
    property e03: TG2Float read GetE03 write SetE03;
    property e10: TG2Float read GetE10 write SetE10;
    property e11: TG2Float read GetE11 write SetE11;
    property e12: TG2Float read GetE12 write SetE12;
    property e13: TG2Float read GetE13 write SetE13;
    property e20: TG2Float read GetE20 write SetE20;
    property e21: TG2Float read GetE21 write SetE21;
    property e22: TG2Float read GetE22 write SetE22;
    property e23: TG2Float read GetE23 write SetE23;
    property e30: TG2Float read GetE30 write SetE30;
    property e31: TG2Float read GetE31 write SetE31;
    property e32: TG2Float read GetE32 write SetE32;
    property e33: TG2Float read GetE33 write SetE33;
    property e[const Index: Integer]: TG2Float read GetE write SetE; default;
    property Mat[const x, y: Integer]: TG2Float read GetMat write SetMat;
    procedure SetValue(
      const _e00, _e10, _e20, _e30: TG2Float;
      const _e01, _e11, _e21, _e31: TG2Float;
      const _e02, _e12, _e22, _e32: TG2Float;
      const _e03, _e13, _e23, _e33: TG2Float
    );
    function GetTranslation: TG2Vec3;
    function ToFloat32Array: JFloat32Array;
    function CopyRef: TG2Mat;
    class function Instance: TG2Mat;
  end;
  {$Hints on}

  {$Hints off}
  TG2Box = record
  public
    c, vx, vy, vz: TG2Vec3;
    procedure SetValue(const bc, bx, by, bz: TG2Vec3);
    function Transform(const m: TG2Mat): TG2Box;
  end;
  {$Hints on}

  {$Hints off}
  TG2AABox = record
    MinV, MaxV: TG2Vec3;
    procedure SetValue(const BMinV, BMaxV: TG2Vec3); overload;
    procedure SetValue(const v: TG2Vec3); overload;
    procedure SetValue(const b: TG2Box); overload;
    procedure Include(const v: TG2Vec3); overload;
    procedure Merge(const b: TG2AABox);
    function Intersect(const b: TG2AABox): Boolean;
  end;
  {$Hints on}

  {$Hints off}
  TG2Sphere = record
  public
    c: TG2Vec3;
    r: TG2Float;
    procedure SetValue(const sc: TG2Vec3; const sr: TG2Float);
  end;
  {$Hints on}

  {$Hints off}
  TG2Plane = record
  public
    n: TG2Vec3;
    d: TG2Float;
  private
    function GetA: TG2Float;
    procedure SetA(const Value: TG2Float);
    function GetB: TG2Float;
    procedure SetB(const Value: TG2Float);
    function GetC: TG2Float;
    procedure SetC(const Value: TG2Float);
  public
    property a: TG2Float read GetA write SetA;
    property b: TG2Float read GetB write SetB;
    property c: TG2Float read GetC write SetC;
    procedure SetValue(const pa, pb, pc, pd: TG2Float); overload;
    procedure SetValue(const pn: TG2Vec3; const pd: TG2Float); overload;
    procedure SetValue(const v0, v1, v2: TG2Vec3); overload;
    function CopyRef: TG2Plane;
    class function Instance: TG2Plane;
  end;
  {$Hints on}

  {$Hints off}
  TG2Ray = record
  public
    Origin: TG2Vec3;
    Dir: TG2Vec3;
    procedure SetValue(const ROrigin, RDir: TG2Vec3);
  end;
  {$Hints on}

  TG2FrustumCheck = (
    fcInside,
    fcIntersect,
    fcOutside
  );

  TG2Frustum = record
  private
    _Planes: array[0..5] of TG2Plane;
    _RefV: TG2Mat;
    _RefP: TG2Mat;
    function GetPlane(const Index: Integer): TG2Plane;
    procedure Normalize;
    function DistanceToPoint(const PlaneIndex: Integer; const Pt: TG2Vec3): Single;
  public
    property RefV: TG2Mat read _RefV write _RefV;
    property RefP: TG2Mat read _RefP write _RefP;
    property Planes[const Index: Integer]: TG2Plane read GetPlane;
    procedure Update;
    procedure ExtractPoints(var OutV: array[0..7] of TG2Vec3);
    function IntersectFrustum(const Frustum: TG2Frustum): Boolean;
    function CheckSphere(const Center: TG2Vec3; const Radius: TG2Float): TG2FrustumCheck; overload;
    function CheckSphere(const Sphere: TG2Sphere): TG2FrustumCheck; overload;
    function CheckBox(const MinV, MaxV: TG2Vec3): TG2FrustumCheck; overload;
    function CheckBox(const Box: TG2AABox): TG2FrustumCheck; overload;
  end;

procedure G2SinCos(const a: TG2Float; var s, c: TG2Float);
function G2LerpFloat(const f0, f1, s: TG2Float): TG2Float;
function G2LerpVec2(const v0, v1: TG2Vec2; const s: TG2Float): TG2Vec2;
function G2LerpVec3(const v0, v1: TG2Vec3; const s: TG2Float): TG2Vec3;
function G2LerpVec4(const v0, v1: TG2Vec4; const s: TG2Float): TG2Vec4;
function G2TriangleNormal(const v0, v1, v2: TG2Vec3): TG2Vec3;
function G2Intersect3Planes(const p1, p2, p3: TG2Plane): TG2Vec3;

function G2Point(const x, y: Integer): TG2Point;
function G2Rect(const l, t, r, b: Integer): TG2Rect;
function G2PtInRect(const r: TG2Rect; const p: TG2Point): Boolean;

function G2Vec2(const x, y: TG2Float): TG2Vec2;
function G2Vec2Add(const v0, v1: TG2Vec2): TG2Vec2;
function G2Vec2Sub(const v0, v1: TG2Vec2): TG2Vec2;
function G2Vec2Mul(const v0, v1: TG2Vec2): TG2Vec2;
function G2Vec2Div(const v0, v1: TG2Vec2): TG2Vec2;
function G2Vec2FloatAdd(const v0: TG2Vec2; const f: TG2Float): TG2Vec2;
function G2Vec2FloatSub(const v0: TG2Vec2; const f: TG2Float): TG2Vec2;
function G2Vec2FloatMul(const v0: TG2Vec2; const f: TG2Float): TG2Vec2;
function G2Vec2FloatDiv(const v0: TG2Vec2; const f: TG2Float): TG2Vec2;
function G2Vec2IntAdd(const v0: TG2Vec2; const i: Integer): TG2Vec2;
function G2Vec2IntSub(const v0: TG2Vec2; const i: Integer): TG2Vec2;
function G2Vec2IntMul(const v0: TG2Vec2; const i: Integer): TG2Vec2;
function G2Vec2IntDiv(const v0: TG2Vec2; const i: Integer): TG2Vec2;
function G2Vec2Dot(const v0, v1: TG2Vec2): TG2Float;
function G2Vec2Cross(const v0, v1: TG2Vec2): TG2Float;
function G2Vec2Norm(const v0: TG2Vec2): TG2Vec2;
function G2Vec2LenSq(const v0: TG2Vec2): TG2Float;
function G2Vec2Len(const v0: TG2Vec2): TG2Float;
function G2Vec2Angle(const v0, v1: TG2Vec2): TG2Float;
function G2Vec2Perp(const v0: TG2Vec2): TG2Vec2;
function G2Vec2Reflect(const v0, n: TG2Vec2): TG2Vec2;
function G2Vec2MatMul3x3(const v0: TG2Vec2; const m: TG2Mat): TG2Vec2;
function G2Vec2MatMul4x3(const v0: TG2Vec2; const m: TG2Mat): TG2Vec2;
function G2Vec2MatMul4x4(const v0: TG2Vec2; const m: TG2Mat): TG2Vec2;
function G2Vec2Vec3Assign(const v0: TG2Vec3): TG2Vec2;
function G2Vec2Vec4Assign(const v0: TG2Vec4): TG2Vec2;

function G2Vec3(const x, y, z: TG2Float): TG2Vec3;
function G2Vec3Add(const v0, v1: TG2Vec3): TG2Vec3;
function G2Vec3Sub(const v0, v1: TG2Vec3): TG2Vec3;
function G2Vec3Mul(const v0, v1: TG2Vec3): TG2Vec3;
function G2Vec3Div(const v0, v1: TG2Vec3): TG2Vec3;
function G2Vec3FloatAdd(const v0: TG2Vec3; const f: TG2Float): TG2Vec3;
function G2Vec3FloatSub(const v0: TG2Vec3; const f: TG2Float): TG2Vec3;
function G2Vec3FloatMul(const v0: TG2Vec3; const f: TG2Float): TG2Vec3;
function G2Vec3FloatDiv(const v0: TG2Vec3; const f: TG2Float): TG2Vec3;
function G2Vec3IntAdd(const v0: TG2Vec3; const i: Integer): TG2Vec3;
function G2Vec3IntSub(const v0: TG2Vec3; const i: Integer): TG2Vec3;
function G2Vec3IntMul(const v0: TG2Vec3; const i: Integer): TG2Vec3;
function G2Vec3IntDiv(const v0: TG2Vec3; const i: Integer): TG2Vec3;
function G2Vec3Dot(const v0, v1: TG2Vec3): TG2Float;
function G2Vec3Cross(const v0, v1: TG2Vec3): TG2Vec3;
function G2Vec3Norm(const v0: TG2Vec3): TG2Vec3;
function G2Vec3LenSq(const v0: TG2Vec3): TG2Float;
function G2Vec3Len(const v0: TG2Vec3): TG2Float;
function G2Vec3Angle(const v0, v1: TG2Vec3): TG2Float;
function G2Vec3Reflect(const v0, n: TG2Vec3): TG2Vec3;
function G2Vec3MatMul3x3(const v0: TG2Vec3; const m: TG2Mat): TG2Vec3;
function G2Vec3MatMul4x3(const v0: TG2Vec3; const m: TG2Mat): TG2Vec3;
function G2Vec3MatMul4x4(const v0: TG2Vec3; const m: TG2Mat): TG2Vec3;
function G2Vec3Vec4Assign(const v0: TG2Vec4): TG2Vec3;
function G2Vec3CatmullRom(const v0, v1, v2, v3: TG2Vec3; const t: TG2Float): TG2Vec3;

function G2Vec4(const x, y, z, w: TG2Float): TG2Vec4;
function G2Vec4Add(const v0, v1: TG2Vec4): TG2Vec4;
function G2Vec4Sub(const v0, v1: TG2Vec4): TG2Vec4;
function G2Vec4Mul(const v0, v1: TG2Vec4): TG2Vec4;
function G2Vec4Div(const v0, v1: TG2Vec4): TG2Vec4;
function G2Vec4FloatAdd(const v0: TG2Vec4; const f: TG2Float): TG2Vec4;
function G2Vec4FloatSub(const v0: TG2Vec4; const f: TG2Float): TG2Vec4;
function G2Vec4FloatMul(const v0: TG2Vec4; const f: TG2Float): TG2Vec4;
function G2Vec4FloatDiv(const v0: TG2Vec4; const f: TG2Float): TG2Vec4;
function G2Vec4IntAdd(const v0: TG2Vec4; const i: Integer): TG2Vec4;
function G2Vec4IntSub(const v0: TG2Vec4; const i: Integer): TG2Vec4;
function G2Vec4IntMul(const v0: TG2Vec4; const i: Integer): TG2Vec4;
function G2Vec4IntDiv(const v0: TG2Vec4; const i: Integer): TG2Vec4;
function G2Vec4MatMul(const v0: TG2Vec4; const m: TG2Mat): TG2Vec4;

function G2Quat(const x, y, z, w: TG2Float): TG2Quat; overload;
function G2Quat(const Axis: TG2Vec3; const Angle: TG2Float): TG2Quat; overload;
function G2Quat(const m: TG2Mat): TG2Quat; overload;
function G2QuatAdd(const q0, q1: TG2Quat): TG2Quat;
function G2QuatSub(const q0, q1: TG2Quat): TG2Quat;
function G2QuatMul(const q0, q1: TG2Quat): TG2Quat;
function G2QuatDiv(const q0, q1: TG2Quat): TG2Quat;
function G2QuatFloatAdd(const q0: TG2Quat; const f: TG2Float): TG2Quat;
function G2QuatFloatSub(const q0: TG2Quat; const f: TG2Float): TG2Quat;
function G2QuatFloatMul(const q0: TG2Quat; const f: TG2Float): TG2Quat;
function G2QuatFloatDiv(const q0: TG2Quat; const f: TG2Float): TG2Quat;
function G2QuatNorm(const q0: TG2Quat): TG2Quat;
function G2QuatDot(const q0, q1: TG2Quat): TG2Float;
function G2QuatSlerp(const q0, q1: TG2Quat; const s: TG2Float): TG2Quat;

function G2Mat(
  const e00, e10, e20, e30: TG2Float;
  const e01, e11, e21, e31: TG2Float;
  const e02, e12, e22, e32: TG2Float;
  const e03, e13, e23, e33: TG2Float
): TG2Mat; overload;
function G2Mat(const AxisX, AxisY, AxisZ, Translation: TG2Vec3): TG2Mat; overload;
function G2MatIdentity: TG2Mat;
function G2MatScaling(const x, y, z: TG2Float): TG2Mat; overload;
function G2MatScaling(const v: TG2Vec3): TG2Mat; overload;
function G2MatScaling(const s: TG2Float): TG2Mat; overload;
function G2MatTranslation(const x, y, z: TG2Float): TG2Mat; overload;
function G2MatTranslation(const v: TG2Vec3): TG2Mat; overload;
function G2MatRotationX(const a: TG2Float): TG2Mat;
function G2MatRotationY(const a: TG2Float): TG2Mat;
function G2MatRotationZ(const a: TG2Float): TG2Mat;
function G2MatRotation(const x, y, z, a: TG2Float): TG2Mat; overload;
function G2MatRotation(const v: TG2Vec3; const a: TG2Float): TG2Mat; overload;
function G2MatRotation(const q: TG2Quat): TG2Mat; overload;
function G2MatView(const Pos, Target, Up: TG2Vec3): TG2Mat;
function G2MatOrth(const Width, Height, ZNear, ZFar: TG2Float): TG2Mat;
function G2MatOrth2D(const Width, Height, ZNear, ZFar: TG2Float; FlipH: Boolean; FlipV: Boolean): TG2Mat;
function G2MatProj(const FOV, Aspect, ZNear, ZFar: TG2Float): TG2Mat;
function G2MatTranspose(const m: TG2Mat): TG2Mat;
function G2MatAdd(const m0, m1: TG2Mat): TG2Mat;
function G2MatSub(const m0, m1: TG2Mat): TG2Mat;
function G2MatFloatAdd(const m0: TG2Mat; const f: TG2Float): TG2Mat;
function G2MatFloatSub(const m0: TG2Mat; const f: TG2Float): TG2Mat;
function G2MatFloatMul(const m0: TG2Mat; const f: TG2Float): TG2Mat;
function G2MatFloatDiv(const m0: TG2Mat; const f: TG2Float): TG2Mat;
function G2MatMul(const m0, m1: TG2Mat): TG2Mat;
function G2MatInv(const m0: TG2Mat): TG2Mat;
procedure G2MatDecompose(var OutScaling: TG2Vec3; var OutRotation: TG2Quat; var OutTranslation: TG2Vec3; const m: TG2Mat);

function G2BoxToAABox(const b: TG2Box): TG2AABox;
function G2AABoxToBox(const b: TG2AABox): TG2Box;

operator + (TG2Vec2, TG2Vec2): TG2Vec2 uses G2Vec2Add;
operator - (TG2Vec2, TG2Vec2): TG2Vec2 uses G2Vec2Sub;
operator * (TG2Vec2, TG2Vec2): TG2Vec2 uses G2Vec2Mul;
operator / (TG2Vec2, TG2Vec2): TG2Vec2 uses G2Vec2Div;
operator + (TG2Vec2, TG2Float): TG2Vec2 uses G2Vec2FloatAdd;
operator - (TG2Vec2, TG2Float): TG2Vec2 uses G2Vec2FloatSub;
operator * (TG2Vec2, TG2Float): TG2Vec2 uses G2Vec2FloatMul;
operator / (TG2Vec2, TG2Float): TG2Vec2 uses G2Vec2FloatDiv;
operator + (TG2Vec2, Integer): TG2Vec2 uses G2Vec2IntAdd;
operator - (TG2Vec2, Integer): TG2Vec2 uses G2Vec2IntSub;
operator * (TG2Vec2, Integer): TG2Vec2 uses G2Vec2IntMul;
operator / (TG2Vec2, Integer): TG2Vec2 uses G2Vec2IntDiv;
operator * (TG2Vec2, TG2Mat): TG2Vec2 uses G2Vec2MatMul4x3;

operator + (TG2Vec3, TG2Vec3): TG2Vec3 uses G2Vec3Add;
operator - (TG2Vec3, TG2Vec3): TG2Vec3 uses G2Vec3Sub;
operator * (TG2Vec3, TG2Vec3): TG2Vec3 uses G2Vec3Mul;
operator / (TG2Vec3, TG2Vec3): TG2Vec3 uses G2Vec3Div;
operator + (TG2Vec3, TG2Float): TG2Vec3 uses G2Vec3FloatAdd;
operator - (TG2Vec3, TG2Float): TG2Vec3 uses G2Vec3FloatSub;
operator * (TG2Vec3, TG2Float): TG2Vec3 uses G2Vec3FloatMul;
operator / (TG2Vec3, TG2Float): TG2Vec3 uses G2Vec3FloatDiv;
operator + (TG2Vec3, Integer): TG2Vec3 uses G2Vec3IntAdd;
operator - (TG2Vec3, Integer): TG2Vec3 uses G2Vec3IntSub;
operator * (TG2Vec3, Integer): TG2Vec3 uses G2Vec3IntMul;
operator / (TG2Vec3, Integer): TG2Vec3 uses G2Vec3IntDiv;
operator * (TG2Vec3, TG2Mat): TG2Vec3 uses G2Vec3MatMul4x3;

operator + (TG2Vec4, TG2Vec4): TG2Vec4 uses G2Vec4Add;
operator - (TG2Vec4, TG2Vec4): TG2Vec4 uses G2Vec4Sub;
operator * (TG2Vec4, TG2Vec4): TG2Vec4 uses G2Vec4Mul;
operator / (TG2Vec4, TG2Vec4): TG2Vec4 uses G2Vec4Div;
operator + (TG2Vec4, TG2Float): TG2Vec4 uses G2Vec4FloatAdd;
operator - (TG2Vec4, TG2Float): TG2Vec4 uses G2Vec4FloatSub;
operator * (TG2Vec4, TG2Float): TG2Vec4 uses G2Vec4FloatMul;
operator / (TG2Vec4, TG2Float): TG2Vec4 uses G2Vec4FloatDiv;
operator + (TG2Vec4, Integer): TG2Vec4 uses G2Vec4IntAdd;
operator - (TG2Vec4, Integer): TG2Vec4 uses G2Vec4IntSub;
operator * (TG2Vec4, Integer): TG2Vec4 uses G2Vec4IntMul;
operator / (TG2Vec4, Integer): TG2Vec4 uses G2Vec4IntDiv;
operator * (TG2Vec4, TG2Mat): TG2Vec4 uses G2Vec4MatMul;

operator + (TG2Mat, TG2Mat): TG2Mat uses G2MatAdd;
operator - (TG2Mat, TG2Mat): TG2Mat uses G2MatSub;
operator * (TG2Mat, TG2Mat): TG2Mat uses G2MatMul;

const TwoPi = Pi * 2;
const HalfPi = Pi * 0.5;

implementation

//TG2Vec2 BEGIN
function TG2Vec2.GetX: TG2Float;
begin
  Result := Arr[0];
end;

procedure TG2Vec2.SetX(const Value: TG2Float);
begin
  Arr[0] := Value;
end;

function TG2Vec2.GetY: TG2Float;
begin
  Result := Arr[1];
end;

procedure TG2Vec2.SetY(const Value: TG2Float);
begin
  Arr[1] := Value;
end;

function TG2Vec2.GetE(const Index: Integer): TG2Float;
begin
  Result := Arr[Index];
end;

procedure TG2Vec2.SetE(const Index: Integer; const Value: TG2Float);
begin
  Arr[Index] := Value;
end;

procedure TG2Vec2.SetValue(const _x, _y: TG2Float);
begin
  x := _x; y := _y;
end;

function TG2Vec2.LenSq: TG2Float;
begin
  Result := G2Vec2LenSq(Self);
end;

function TG2Vec2.Len: TG2Float;
begin
  Result := G2Vec2Len(Self);
end;

function TG2Vec2.Norm: TG2Vec2;
begin
  Result := G2Vec2Norm(Self);
end;

function TG2Vec2.Perp: TG2Vec2;
begin
  Result := G2Vec2Perp(Self);
end;

function TG2Vec2.ToFloat32Array: JFloat32Array;
begin
  asm
    @Result = new Float32Array(@Arr);
  end;
end;

function TG2Vec2.CopyRef: TG2Vec2;
begin
  asm @Result = @Self; end;
end;

class function TG2Vec2.Instance: TG2Vec2;
  var v: TG2Vec2;
begin
  asm @Result = @v; end;
end;
//TG2Vec2 END

//TG2Vec3 BEGIN
function TG2Vec3.GetX: TG2Float;
begin
  Result := Arr[0];
end;

procedure TG2Vec3.SetX(const Value: TG2Float);
begin
  Arr[0] := Value;
end;

function TG2Vec3.GetY: TG2Float;
begin
  Result := Arr[1];
end;

procedure TG2Vec3.SetY(const Value: TG2Float);
begin
  Arr[1] := Value;
end;

function TG2Vec3.GetZ: TG2Float;
begin
  Result := Arr[2];
end;

procedure TG2Vec3.SetZ(const Value: TG2Float);
begin
  Arr[2] := Value;
end;

function TG2Vec3.GetE(const Index: Integer): TG2Float;
begin
  Result := Arr[Index];
end;

procedure TG2Vec3.SetE(const Index: Integer; const Value: TG2Float);
begin
  Arr[Index] := Value;
end;

procedure TG2Vec3.SetValue(const _x, _y, _z: TG2Float);
begin
  x := _x; y := _y; z := _z;
end;

function TG2Vec3.LenSq: TG2Float;
begin
  Result := x * x + y * y;
end;

function TG2Vec3.Len: TG2Float;
begin
  Result := G2Vec3Len(Self);
end;

function TG2Vec3.Dot(const v: TG2Vec3): TG2Float;
begin
  Result := G2Vec3Dot(Self, v);
end;

function TG2Vec3.Cross(const v: TG2Vec3): TG2Vec3;
begin
  Result := G2Vec3Cross(Self, v);
end;

function TG2Vec3.Norm: TG2Vec3;
begin
  Result := G2Vec3Norm(Self);
end;

function TG2Vec3.ToFloat32Array: JFloat32Array;
begin
  asm
    @Result = new Float32Array(@Arr);
  end;
end;

function TG2Vec3.CopyRef: TG2Vec3;
begin
  asm @Result = @Self; end;
end;

class function TG2Vec3.Instance: TG2Vec3;
  var v: TG2Vec3;
begin
  asm @Result = @v; end;
end;
//TG2Vec3 END

//TG2Vec4 BEGIN
function TG2Vec4.GetX: TG2Float;
begin
  Result := Arr[0];
end;

procedure TG2Vec4.SetX(const Value: TG2Float);
begin
  Arr[0] := Value;
end;

function TG2Vec4.GetY: TG2Float;
begin
  Result := Arr[1];
end;

procedure TG2Vec4.SetY(const Value: TG2Float);
begin
  Arr[1] := Value;
end;

function TG2Vec4.GetZ: TG2Float;
begin
  Result := Arr[2];
end;

procedure TG2Vec4.SetZ(const Value: TG2Float);
begin
  Arr[2] := Value;
end;

function TG2Vec4.GetW: TG2Float;
begin
  Result := Arr[3];
end;

procedure TG2Vec4.SetW(const Value: TG2Float);
begin
  Arr[3] := Value;
end;

function TG2Vec4.GetE(const Index: Integer): TG2Float;
begin
  Result := Arr[Index];
end;

procedure TG2Vec4.SetE(const Index: Integer; const Value: TG2Float);
begin
  Arr[Index] := Value;
end;

procedure TG2Vec4.SetValue(const _x, _y, _z, _w: TG2Float);
begin
  x := _x; y := _y; z := _z; w := _w;
end;

function TG2Vec4.ToFloat32Array: JFloat32Array;
begin
  asm
    @Result = new Float32Array(@Arr);
  end;
end;

function TG2Vec4.CopyRef: TG2Vec4;
begin
  asm @Result = @Self; end;
end;

class function TG2Vec4.Instance: TG2Vec4;
  var v: TG2Vec4;
begin
  asm @Result = @v; end;
end;
//TG2Vec4 END

//TG2Quat BEGIN
function TG2Quat.GetX: TG2Float;
begin
  Result := Arr[0];
end;

procedure TG2Quat.SetX(const Value: TG2Float);
begin
  Arr[0] := Value;
end;

function TG2Quat.GetY: TG2Float;
begin
  Result := Arr[1];
end;

procedure TG2Quat.SetY(const Value: TG2Float);
begin
  Arr[1] := Value;
end;

function TG2Quat.GetZ: TG2Float;
begin
  Result := Arr[2];
end;

procedure TG2Quat.SetZ(const Value: TG2Float);
begin
  Arr[2] := Value;
end;

function TG2Quat.GetW: TG2Float;
begin
  Result := Arr[3];
end;

procedure TG2Quat.SetW(const Value: TG2Float);
begin
  Arr[3] := Value;
end;

function TG2Quat.GetE(const Index: Integer): TG2Float;
begin
  Result := Arr[Index];
end;

procedure TG2Quat.SetE(const Index: Integer; const Value: TG2Float);
begin
  Arr[Index] := Value;
end;

procedure TG2Quat.SetValue(const _x, _y, _z, _w: TG2Float);
begin
  x := _x; y := _y; z := _z; w := _w;
end;

function TG2Quat.ToFloat32Array: JFloat32Array;
begin
  asm
    @Result = new Float32Array(@Arr);
  end;
end;

function TG2Quat.CopyRef: TG2Quat;
begin
  asm @Result = @Self; end;
end;

class function TG2Quat.Instance: TG2Quat;
  var v: TG2Quat;
begin
  asm @Result = @v; end;
end;
//TG2Quat END

//TG2Mat BEGIN
function TG2Mat.GetE00: TG2Float;
begin
  Result := Arr[0];
end;

procedure TG2Mat.SetE00(const Value: TG2Float);
begin
  Arr[0] := Value;
end;

function TG2Mat.GetE01: TG2Float;
begin
  Result := Arr[1];
end;

procedure TG2Mat.SetE01(const Value: TG2Float);
begin
  Arr[1] := Value;
end;

function TG2Mat.GetE02: TG2Float;
begin
  Result := Arr[2];
end;

procedure TG2Mat.SetE02(const Value: TG2Float);
begin
  Arr[2] := Value;
end;

function TG2Mat.GetE03: TG2Float;
begin
  Result := Arr[3];
end;

procedure TG2Mat.SetE03(const Value: TG2Float);
begin
  Arr[3] := Value;
end;

function TG2Mat.GetE10: TG2Float;
begin
  Result := Arr[4];
end;

procedure TG2Mat.SetE10(const Value: TG2Float);
begin
  Arr[4] := Value;
end;

function TG2Mat.GetE11: TG2Float;
begin
  Result := Arr[5];
end;

procedure TG2Mat.SetE11(const Value: TG2Float);
begin
  Arr[5] := Value;
end;

function TG2Mat.GetE12: TG2Float;
begin
  Result := Arr[6];
end;

procedure TG2Mat.SetE12(const Value: TG2Float);
begin
  Arr[6] := Value;
end;

function TG2Mat.GetE13: TG2Float;
begin
  Result := Arr[7];
end;

procedure TG2Mat.SetE13(const Value: TG2Float);
begin
  Arr[7] := Value;
end;

function TG2Mat.GetE20: TG2Float;
begin
  Result := Arr[8];
end;

procedure TG2Mat.SetE20(const Value: TG2Float);
begin
  Arr[8] := Value;
end;

function TG2Mat.GetE21: TG2Float;
begin
  Result := Arr[9];
end;

procedure TG2Mat.SetE21(const Value: TG2Float);
begin
  Arr[9] := Value;
end;

function TG2Mat.GetE22: TG2Float;
begin
  Result := Arr[10];
end;

procedure TG2Mat.SetE22(const Value: TG2Float);
begin
  Arr[10] := Value;
end;

function TG2Mat.GetE23: TG2Float;
begin
  Result := Arr[11];
end;

procedure TG2Mat.SetE23(const Value: TG2Float);
begin
  Arr[11] := Value;
end;

function TG2Mat.GetE30: TG2Float;
begin
  Result := Arr[12];
end;

procedure TG2Mat.SetE30(const Value: TG2Float);
begin
  Arr[12] := Value;
end;

function TG2Mat.GetE31: TG2Float;
begin
  Result := Arr[13];
end;

procedure TG2Mat.SetE31(const Value: TG2Float);
begin
  Arr[13] := Value;
end;

function TG2Mat.GetE32: TG2Float;
begin
  Result := Arr[14];
end;

procedure TG2Mat.SetE32(const Value: TG2Float);
begin
  Arr[14] := Value;
end;

function TG2Mat.GetE33: TG2Float;
begin
  Result := Arr[15];
end;

procedure TG2Mat.SetE33(const Value: TG2Float);
begin
  Arr[15] := Value;
end;

function TG2Mat.GetE(const Index: Integer): TG2Float;
begin
  Result := Arr[Index];
end;

procedure TG2Mat.SetE(const Index: Integer; const Value: TG2Float);
begin
  Arr[Index] := Value;
end;

function TG2Mat.GetMat(const x, y: Integer): TG2Float;
begin
  Result := Arr[x * 4 + y];
end;

procedure TG2Mat.SetMat(const x, y: Integer; const Value: TG2Float);
begin
  Arr[x * 4 + y] := Value;
end;

procedure TG2Mat.SetValue(
  const _e00, _e10, _e20, _e30: TG2Float;
  const _e01, _e11, _e21, _e31: TG2Float;
  const _e02, _e12, _e22, _e32: TG2Float;
  const _e03, _e13, _e23, _e33: TG2Float
);
begin
  e00 := _e00; e10 := _e10; e20 := _e20; e30 := _e30;
  e01 := _e01; e11 := _e11; e21 := _e21; e31 := _e31;
  e02 := _e02; e12 := _e12; e22 := _e22; e32 := _e32;
  e03 := _e03; e13 := _e13; e23 := _e23; e33 := _e33;
end;

function TG2Mat.GetTranslation: TG2Vec3;
begin
  Result.x := e30;
  Result.y := e31;
  Result.z := e32;
end;

function TG2Mat.ToFloat32Array: JFloat32Array;
begin
  asm
    @Result = new Float32Array(@Arr);
  end;
end;

function TG2Mat.CopyRef: TG2Mat;
begin
  asm @Result = @Self; end;
end;

class function TG2Mat.Instance: TG2Mat;
  var m: TG2Mat;
begin
  asm @Result = @m; end;
end;
//TG2Mat END

//TG2Box BEGIN
procedure TG2Box.SetValue(const bc, bx, by, bz: TG2Vec3);
begin
  c := bc; vx := bx; vy := by; vz := bz;
end;

function TG2Box.Transform(const m: TG2Mat): TG2Box;
begin
  Result.c := G2Vec3MatMul4x3(c, m);
  Result.vx := G2Vec3MatMul3x3(vx, m);
  Result.vy := G2Vec3MatMul3x3(vy, m);
  Result.vz := G2Vec3MatMul3x3(vz, m);
end;
//TG2Box END

//TG2AABox BEGIN
procedure TG2AABox.SetValue(const BMinV, BMaxV: TG2Vec3);
begin
  MinV := BMinV; MaxV := BMaxV;
end;

procedure TG2AABox.SetValue(const v: TG2Vec3);
begin
  MinV := v; MaxV := v;
end;

procedure TG2AABox.SetValue(const b: TG2Box);
begin
  Self := G2BoxToAABox(b);
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
procedure TG2Sphere.SetValue(const sc: TG2Vec3; const sr: TG2Float);
begin
  c := sc; r := sr;
end;
//TG2Sphere END

//TG2Plane BEGIN
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

function TG2Plane.CopyRef: TG2Plane;
begin
  asm @Result = @Self; end;
end;

class function TG2Plane.Instance: TG2Plane;
  var p: TG2Plane;
begin
  asm @Result = @p; end;
end;
//TG2Plane END

//TG2Ray BEGIN
procedure TG2Ray.SetValue(const ROrigin, RDir: TG2Vec3);
begin
  Origin := ROrigin; Dir := RDir;
end;
//TG2Ray END

//TG2Frustum BEGIN
function TG2Frustum.GetPlane(const Index: Integer): TG2Plane;
begin
  Result := _Planes[Index].CopyRef;
end;

procedure TG2Frustum.Normalize;
  var i: Integer;
  var Rcp: TG2Float;
begin
  for i := 0 to 5 do
  begin
    Rcp := 1 / G2Vec3Len(_Planes[i].n);
    _Planes[i].n.x := _Planes[i].n.x * Rcp;
    _Planes[i].n.y := _Planes[i].n.y * Rcp;
    _Planes[i].n.z := _Planes[i].n.z * Rcp;
    _Planes[i].d := _Planes[i].d * Rcp;
  end;
end;

function TG2Frustum.DistanceToPoint(const PlaneIndex: Integer; const Pt: TG2Vec3): Single;
begin
  Result := _Planes[PlaneIndex].n.Dot(Pt) + _Planes[PlaneIndex].d;
end;

procedure TG2Frustum.Update;
  var m: TG2Mat;
begin
  m := G2MatMul(_RefV, _RefP);
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

procedure TG2Frustum.ExtractPoints(var OutV: array[0..7] of TG2Vec3);
begin
  OutV[0] := G2Intersect3Planes(_Planes[4], _Planes[0], _Planes[2]);
  OutV[1] := G2Intersect3Planes(_Planes[5], _Planes[0], _Planes[2]);
  OutV[2] := G2Intersect3Planes(_Planes[4], _Planes[2], _Planes[1]);
  OutV[3] := G2Intersect3Planes(_Planes[5], _Planes[2], _Planes[1]);
  OutV[4] := G2Intersect3Planes(_Planes[4], _Planes[1], _Planes[3]);
  OutV[5] := G2Intersect3Planes(_Planes[5], _Planes[1], _Planes[3]);
  OutV[6] := G2Intersect3Planes(_Planes[4], _Planes[3], _Planes[0]);
  OutV[7] := G2Intersect3Planes(_Planes[5], _Planes[3], _Planes[0]);
end;

function TG2Frustum.IntersectFrustum(const Frustum: TG2Frustum): Boolean;
  function FrustumOutside(const f1, f2: TG2Frustum): Boolean;
    var Points: array[0..7] of TG2Vec3;
    var i, j, n: Integer;
  begin
    f2.ExtractPoints(Points);
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
  var i: Integer;
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
  var i: Integer;
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

procedure G2SinCos(const a: TG2Float; var s, c: TG2Float);
begin
  s := Sin(a);
  c := Cos(a);
end;

function G2LerpFloat(const f0, f1, s: TG2Float): TG2Float;
begin
  Result := f0 + (f1 - f0) * s;
end;

function G2LerpVec2(const v0, v1: TG2Vec2; const s: TG2Float): TG2Vec2;
begin
  Result.x := v0.x + (v1.x - v0.x) * s;
  Result.y := v0.y + (v1.y - v0.y) * s;
end;

function G2LerpVec3(const v0, v1: TG2Vec3; const s: TG2Float): TG2Vec3;
begin
  Result.x := v0.x + (v1.x - v0.x) * s;
  Result.y := v0.y + (v1.y - v0.y) * s;
  Result.z := v0.z + (v1.z - v0.z) * s;
end;

function G2LerpVec4(const v0, v1: TG2Vec4; const s: TG2Float): TG2Vec4;
begin
  Result.x := v0.x + (v1.x - v0.x) * s;
  Result.y := v0.y + (v1.y - v0.y) * s;
  Result.z := v0.z + (v1.z - v0.z) * s;
  Result.w := v0.w + (v1.w - v0.w) * s;
end;

function G2TriangleNormal(const v0, v1, v2: TG2Vec3): TG2Vec3;
begin
  Result := (v1 - v0).Cross(v2 - v0).Norm;
end;

function G2Intersect3Planes(const p1, p2, p3: TG2Plane): TG2Vec3;
  var iDet: Single;
begin
  iDet := -p1.n.Dot(p2.n.Cross(p3.n));
  if Abs(iDet) > G2EPS then
  Result := ((p2.n.Cross(p3.n) * p1.d) + (p3.n.Cross(p1.n) * p2.d) + (p1.n.Cross(p2.n) * p3.d)) / iDet
  else
  Result.SetValue(0, 0, 0);
end;

function G2Point(const x, y: Integer): TG2Point;
begin
  Result.x := x;
  Result.y := y;
end;

function G2Rect(const l, t, r, b: Integer): TG2Rect;
begin
  Result.l := l;
  Result.t := t;
  Result.r := r;
  Result.b := b;
end;

function G2PtInRect(const r: TG2Rect; const p: TG2Point): Boolean;
begin
  Result := (
    (p.x >= r.l)
    and (p.y >= r.t)
    and (p.x <= r.r)
    and (p.y <= r.b)
  );
end;

function G2Vec2(const x, y: TG2Float): TG2Vec2;
begin
  Result.SetValue(x, y);
end;

function G2Vec2Add(const v0, v1: TG2Vec2): TG2Vec2;
begin
  Result.x := v0.x + v1.x;
  Result.y := v0.y + v1.y;
end;

function G2Vec2Sub(const v0, v1: TG2Vec2): TG2Vec2;
begin
  Result.x := v0.x - v1.x;
  Result.y := v0.y - v1.y;
end;

function G2Vec2Mul(const v0, v1: TG2Vec2): TG2Vec2;
begin
  Result.x := v0.x * v1.x;
  Result.y := v0.y * v1.y;
end;

function G2Vec2Div(const v0, v1: TG2Vec2): TG2Vec2;
begin
  Result.x := v0.x / v1.x;
  Result.y := v0.y / v1.y;
end;

function G2Vec2FloatAdd(const v0: TG2Vec2; const f: TG2Float): TG2Vec2;
begin
  Result.x := v0.x + f;
  Result.y := v0.y + f;
end;

function G2Vec2FloatSub(const v0: TG2Vec2; const f: TG2Float): TG2Vec2;
begin
  Result.x := v0.x - f;
  Result.y := v0.y - f;
end;

function G2Vec2FloatMul(const v0: TG2Vec2; const f: TG2Float): TG2Vec2;
begin
  Result.x := v0.x * f;
  Result.y := v0.y * f;
end;

function G2Vec2FloatDiv(const v0: TG2Vec2; const f: TG2Float): TG2Vec2;
begin
  Result.x := v0.x / f;
  Result.y := v0.y / f;
end;

function G2Vec2IntAdd(const v0: TG2Vec2; const i: Integer): TG2Vec2;
begin
  Result.x := v0.x + i;
  Result.y := v0.y + i;
end;

function G2Vec2IntSub(const v0: TG2Vec2; const i: Integer): TG2Vec2;
begin
  Result.x := v0.x - i;
  Result.y := v0.y - i;
end;

function G2Vec2IntMul(const v0: TG2Vec2; const i: Integer): TG2Vec2;
begin
  Result.x := v0.x * i;
  Result.y := v0.y * i;
end;

function G2Vec2IntDiv(const v0: TG2Vec2; const i: Integer): TG2Vec2;
begin
  Result.x := v0.x / i;
  Result.y := v0.y / i;
end;

function G2Vec2Dot(const v0, v1: TG2Vec2): TG2Float;
begin
  Result := v0.x * v1.x + v0.y * v1.y;
end;

function G2Vec2Cross(const v0, v1: TG2Vec2): TG2Float;
begin
  Result := v0.x * v1.y - v0.y * v1.x;
end;

function G2Vec2Norm(const v0: TG2Vec2): TG2Vec2;
  var d: TG2Float;
begin
  d := Sqrt(G2Vec2Dot(v0, v0));
  if d > 0 then
  begin
    d := 1 / d;
    Result.x := v0.x * d;
    Result.y := v0.y * d;
  end
  else
  begin
    Result.x := 0;
    Result.y := 0;
  end;
end;

function G2Vec2LenSq(const v0: TG2Vec2): TG2Float;
begin
  Result := v0.x * v0.x + v0.y * v0.y;
end;

function G2Vec2Len(const v0: TG2Vec2): TG2Float;
begin
  Result := Sqrt(v0.x * v0.x + v0.y * v0.y);
end;

function G2Vec2Angle(const v0, v1: TG2Vec2): TG2Float;
  var VLen: TG2Float;
begin
  VLen := G2Vec2Len(v0) * G2Vec2Len(v1);
  if VLen > 0 then
  Result := ArcCos(G2Vec2Dot(v0, v1) / VLen)
  else
  Result := 0;
end;

function G2Vec2Perp(const v0: TG2Vec2): TG2Vec2;
begin
  Result.SetValue(-v0.y, v0.x);
end;

function G2Vec2Reflect(const v0, n: TG2Vec2): TG2Vec2;
  var d: Single;
begin
  d := G2Vec2Dot(v0, n);
  Result := G2Vec2Sub(v0, G2Vec2FloatMul(n, 2 * d));
end;

function G2Vec2MatMul3x3(const v0: TG2Vec2; const m: TG2Mat): TG2Vec2;
  var vr: TG2Vec2;
begin
  vr.x := v0.x * m.e00 + v0.y * m.e10;
  vr.y := v0.x * m.e01 + v0.y * m.e11;
  Result := vr;
end;

function G2Vec2MatMul4x3(const v0: TG2Vec2; const m: TG2Mat): TG2Vec2;
  var vr: TG2Vec2;
begin
  vr.x := v0.x * m.e00 + v0.y * m.e10 + m.e30;
  vr.y := v0.x * m.e01 + v0.y * m.e11 + m.e31;
  Result := vr;
end;

function G2Vec2MatMul4x4(const v0: TG2Vec2; const m: TG2Mat): TG2Vec2;
  var vr: TG2Vec2;
  var w: TG2Float;
begin
  vr.x := v0.x * m.e00 + v0.y * m.e10 + m.e30;
  vr.y := v0.x * m.e01 + v0.y * m.e11 + m.e31;
  w := 1 / (v0.x * m.e03 + v0.y * m.e13 + m.e33);
  Result.x := vr.x * w;
  Result.y := vr.y * w;
end;

function G2Vec2Vec3Assign(const v0: TG2Vec3): TG2Vec2;
begin
  Result.SetValue(v0.x, v0.y);
end;

function G2Vec2Vec4Assign(const v0: TG2Vec4): TG2Vec2;
begin
  Result.SetValue(v0.x, v0.y);
end;

function G2Vec2Neg(const v0: TG2Vec2): TG2Vec2;
begin
  Result.x := -v0.x;
  Result.y := -v0.y;
end;

function G2Vec3(const x, y, z: TG2Float): TG2Vec3;
begin
  Result.SetValue(x, y, z);
end;

function G2Vec3Add(const v0, v1: TG2Vec3): TG2Vec3;
begin
  Result.x := v0.x + v1.x;
  Result.y := v0.y + v1.y;
  Result.z := v0.z + v1.z;
end;

function G2Vec3Sub(const v0, v1: TG2Vec3): TG2Vec3;
begin
  Result.x := v0.x - v1.x;
  Result.y := v0.y - v1.y;
  Result.z := v0.z - v1.z;
end;

function G2Vec3Mul(const v0, v1: TG2Vec3): TG2Vec3;
begin
  Result.x := v0.x * v1.x;
  Result.y := v0.y * v1.y;
  Result.z := v0.z * v1.z;
end;

function G2Vec3Div(const v0, v1: TG2Vec3): TG2Vec3;
begin
  Result.x := v0.x / v1.x;
  Result.y := v0.y / v1.y;
  Result.z := v0.z / v1.z;
end;

function G2Vec3FloatAdd(const v0: TG2Vec3; const f: TG2Float): TG2Vec3;
begin
  Result.x := v0.x + f;
  Result.y := v0.y + f;
  Result.z := v0.z + f;
end;

function G2Vec3FloatSub(const v0: TG2Vec3; const f: TG2Float): TG2Vec3;
begin
  Result.x := v0.x - f;
  Result.y := v0.y - f;
  Result.z := v0.z - f;
end;

function G2Vec3FloatMul(const v0: TG2Vec3; const f: TG2Float): TG2Vec3;
begin
  Result.x := v0.x * f;
  Result.y := v0.y * f;
  Result.z := v0.z * f;
end;

function G2Vec3FloatDiv(const v0: TG2Vec3; const f: TG2Float): TG2Vec3;
begin
  Result.x := v0.x / f;
  Result.y := v0.y / f;
  Result.z := v0.z / f;
end;

function G2Vec3IntAdd(const v0: TG2Vec3; const i: Integer): TG2Vec3;
begin
  Result.x := v0.x + i;
  Result.y := v0.y + i;
  Result.z := v0.z + i;
end;

function G2Vec3IntSub(const v0: TG2Vec3; const i: Integer): TG2Vec3;
begin
  Result.x := v0.x - i;
  Result.y := v0.y - i;
  Result.z := v0.z - i;
end;

function G2Vec3IntMul(const v0: TG2Vec3; const i: Integer): TG2Vec3;
begin
  Result.x := v0.x * i;
  Result.y := v0.y * i;
  Result.z := v0.z * i;
end;

function G2Vec3IntDiv(const v0: TG2Vec3; const i: Integer): TG2Vec3;
begin
  Result.x := v0.x / i;
  Result.y := v0.y / i;
  Result.z := v0.z / i;
end;

function G2Vec3Dot(const v0, v1: TG2Vec3): TG2Float;
begin
  Result := v0.x * v1.x + v0.y * v1.y + v0.z * v1.z;
end;

function G2Vec3Cross(const v0, v1: TG2Vec3): TG2Vec3;
begin
  Result.x := v0.y * v1.z - v0.z * v1.y;
  Result.y := v0.z * v1.x - v0.x * v1.z;
  Result.z := v0.x * v1.y - v0.y * v1.x;
end;

function G2Vec3Norm(const v0: TG2Vec3): TG2Vec3;
  var d: TG2Float;
begin
  d := Sqrt(v0.x * v0.x + v0.y * v0.y + v0.z * v0.z);
  if d > 0 then
  begin
    d := 1 / d;
    Result.x := v0.x * d;
    Result.y := v0.y * d;
    Result.z := v0.z * d;
  end
  else
  begin
    Result.x := 0;
    Result.y := 0;
    Result.z := 0;
  end;
end;

function G2Vec3LenSq(const v0: TG2Vec3): TG2Float;
begin
  Result := v0.x * v0.x + v0.y * v0.y + v0.z * v0.z;
end;

function G2Vec3Len(const v0: TG2Vec3): TG2Float;
begin
  Result := Sqrt(v0.x * v0.x + v0.y * v0.y + v0.z * v0.z);
end;

function G2Vec3Angle(const v0, v1: TG2Vec3): TG2Float;
  var VLen: TG2Float;
begin
  VLen := G2Vec3Len(v0) * G2Vec3Len(v1);
  if VLen > 0 then
  Result := ArcCos(G2Vec3Dot(v0, v1) / VLen)
  else
  Result := 0;
end;

function G2Vec3Reflect(const v0, n: TG2Vec3): TG2Vec3;
  var d: Single;
begin
  d := G2Vec3Dot(v0, n);
  Result := G2Vec3Sub(v0, G2Vec3FloatMul(n, (2 * d)));
end;

function G2Vec3MatMul3x3(const v0: TG2Vec3; const m: TG2Mat): TG2Vec3;
  var vr: TG2Vec3;
begin
  vr.x := v0.x * m.e00 + v0.y * m.e10 + v0.z * m.e20;
  vr.y := v0.x * m.e01 + v0.y * m.e11 + v0.z * m.e21;
  vr.z := v0.x * m.e02 + v0.y * m.e12 + v0.z * m.e22;
  Result := vr;
end;

function G2Vec3MatMul4x3(const v0: TG2Vec3; const m: TG2Mat): TG2Vec3;
  var vr: TG2Vec3;
begin
  vr.x := v0.x * m.e00 + v0.y * m.e10 + v0.z * m.e20 + m.e30;
  vr.y := v0.x * m.e01 + v0.y * m.e11 + v0.z * m.e21 + m.e31;
  vr.z := v0.x * m.e02 + v0.y * m.e12 + v0.z * m.e22 + m.e32;
  Result := vr;
end;

function G2Vec3MatMul4x4(const v0: TG2Vec3; const m: TG2Mat): TG2Vec3;
  var vr: TG2Vec3;
  var w: TG2Float;
begin
  vr.x := v0.x * m.e00 + v0.y * m.e10 + v0.z * m.e20 + m.e30;
  vr.y := v0.x * m.e01 + v0.y * m.e11 + v0.z * m.e21 + m.e31;
  vr.z := v0.x * m.e02 + v0.y * m.e12 + v0.z * m.e22 + m.e32;
  w := 1 / (v0.x * m.e03 + v0.y * m.e13 + v0.z * m.e23 + m.e33);
  Result.x := vr.x * w;
  Result.y := vr.y * w;
  Result.z := vr.z * w;
end;

function G2Vec3Vec4Assign(const v0: TG2Vec4): TG2Vec3;
begin
  Result.SetValue(v0.x, v0.y, v0.z);
end;

function G2Vec3CatmullRom(const v0, v1, v2, v3: TG2Vec3; const t: TG2Float): TG2Vec3;
begin
  Result.x := 0.5 * (2 * v1.x + (v2.x - v0.x) * t + (2 * v0.x - 5 * v1.x + 4 * v2.x - v3.x) * t * t + (v3.x - 3 * v2.x + 3 * v1.x - v0.x) * t * t * t);
  Result.y := 0.5 * (2 * v1.y + (v2.y - v0.y) * t + (2 * v0.y - 5 * v1.y + 4 * v2.y - v3.y) * t * t + (v3.y - 3 * v2.y + 3 * v1.y - v0.y) * t * t * t);
  Result.z := 0.5 * (2 * v1.z + (v2.z - v0.z) * t + (2 * v0.z - 5 * v1.z + 4 * v2.z - v3.z) * t * t + (v3.z - 3 * v2.z + 3 * v1.z - v0.z) * t * t * t);
end;

function G2Vec4Add(const v0, v1: TG2Vec4): TG2Vec4;
begin
  Result.x := v0.x + v1.x;
  Result.y := v0.y + v1.y;
  Result.z := v0.z + v1.z;
  Result.w := v0.w + v1.w;
end;

function G2Vec4(const x, y, z, w: TG2Float): TG2Vec4;
begin
  Result.SetValue(x, y, z, w);
end;

function G2Vec4Sub(const v0, v1: TG2Vec4): TG2Vec4;
begin
  Result.x := v0.x - v1.x;
  Result.y := v0.y - v1.y;
  Result.z := v0.z - v1.z;
  Result.w := v0.w - v1.w;
end;

function G2Vec4Mul(const v0, v1: TG2Vec4): TG2Vec4;
begin
  Result.x := v0.x * v1.x;
  Result.y := v0.y * v1.y;
  Result.z := v0.z * v1.z;
  Result.w := v0.w * v1.w;
end;

function G2Vec4Div(const v0, v1: TG2Vec4): TG2Vec4;
begin
  Result.x := v0.x / v1.x;
  Result.y := v0.y / v1.y;
  Result.z := v0.z / v1.z;
  Result.w := v0.w / v1.w;
end;

function G2Vec4FloatAdd(const v0: TG2Vec4; const f: TG2Float): TG2Vec4;
begin
  Result.x := v0.x + f;
  Result.y := v0.y + f;
  Result.z := v0.z + f;
  Result.w := v0.w + f;
end;

function G2Vec4FloatSub(const v0: TG2Vec4; const f: TG2Float): TG2Vec4;
begin
  Result.x := v0.x - f;
  Result.y := v0.y - f;
  Result.z := v0.z - f;
  Result.w := v0.w - f;
end;

function G2Vec4FloatMul(const v0: TG2Vec4; const f: TG2Float): TG2Vec4;
begin
  Result.x := v0.x * f;
  Result.y := v0.y * f;
  Result.z := v0.z * f;
  Result.w := v0.w * f;
end;

function G2Vec4FloatDiv(const v0: TG2Vec4; const f: TG2Float): TG2Vec4;
begin
  Result.x := v0.x / f;
  Result.y := v0.y / f;
  Result.z := v0.z / f;
  Result.w := v0.w / f;
end;

function G2Vec4IntAdd(const v0: TG2Vec4; const i: Integer): TG2Vec4;
begin
  Result.x := v0.x + i;
  Result.y := v0.y + i;
  Result.z := v0.z + i;
  Result.w := v0.w + i;
end;

function G2Vec4IntSub(const v0: TG2Vec4; const i: Integer): TG2Vec4;
begin
  Result.x := v0.x - i;
  Result.y := v0.y - i;
  Result.z := v0.z - i;
  Result.w := v0.w - i;
end;

function G2Vec4IntMul(const v0: TG2Vec4; const i: Integer): TG2Vec4;
begin
  Result.x := v0.x * i;
  Result.y := v0.y * i;
  Result.z := v0.z * i;
  Result.w := v0.w * i;
end;

function G2Vec4IntDiv(const v0: TG2Vec4; const i: Integer): TG2Vec4;
begin
  Result.x := v0.x / i;
  Result.y := v0.y / i;
  Result.z := v0.z / i;
  Result.w := v0.w / i;
end;

function G2Vec4MatMul(const v0: TG2Vec4; const m: TG2Mat): TG2Vec4;
  var vr: TG2Vec4;
begin
  vr.x := v0.x * m.e00 + v0.y * m.e10 + v0.z * m.e20 + v0.w * m.e30;
  vr.y := v0.x * m.e01 + v0.y * m.e11 + v0.z * m.e21 + v0.w * m.e31;
  vr.z := v0.x * m.e02 + v0.y * m.e12 + v0.z * m.e22 + v0.w * m.e32;
  vr.w := v0.x * m.e03 + v0.y * m.e13 + v0.z * m.e23 + v0.w * m.e33;
  Result := vr;
end;

function G2Quat(const x, y, z, w: TG2Float): TG2Quat;
begin
  Result.SetValue(x, y, z, w);
end;

function G2Quat(const Axis: TG2Vec3; const Angle: TG2Float): TG2Quat;
  var AxisNorm: TG2Vec3;
  var s, c: TG2Float;
begin
  AxisNorm := G2Vec3Norm(Axis);
  G2SinCos(Angle * 0.5, s, c);
  Result.x := s * AxisNorm.x;
  Result.y := s * AxisNorm.y;
  Result.z := s * AxisNorm.z;
  Result.w := c;
end;

function G2Quat(const m: TG2Mat): TG2Quat;
  var Trace, SqrtTrace, RcpSqrtTrace, MaxDiag, s: TG2Float;
  var MaxI, i: Integer;
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

function G2QuatAdd(const q0, q1: TG2Quat): TG2Quat;
begin
  Result.x := q0.x + q1.x;
  Result.y := q0.y + q1.y;
  Result.z := q0.z + q1.z;
  Result.w := q0.w + q1.w;
end;

function G2QuatSub(const q0, q1: TG2Quat): TG2Quat;
begin
  Result.x := q0.x - q1.x;
  Result.y := q0.y - q1.y;
  Result.z := q0.z - q1.z;
  Result.w := q0.w - q1.w;
end;

function G2QuatMul(const q0, q1: TG2Quat): TG2Quat;
begin
  Result.x := q0.x * q1.x;
  Result.y := q0.y * q1.y;
  Result.z := q0.z * q1.z;
  Result.w := q0.w * q1.w;
end;

function G2QuatDiv(const q0, q1: TG2Quat): TG2Quat;
begin
  Result.x := q0.x / q1.x;
  Result.y := q0.y / q1.y;
  Result.z := q0.z / q1.z;
  Result.w := q0.w / q1.w;
end;

function G2QuatFloatAdd(const q0: TG2Quat; const f: TG2Float): TG2Quat;
begin
  Result.x := q0.x + f;
  Result.y := q0.y + f;
  Result.z := q0.z + f;
  Result.w := q0.w + f;
end;

function G2QuatFloatSub(const q0: TG2Quat; const f: TG2Float): TG2Quat;
begin
  Result.x := q0.x - f;
  Result.y := q0.y - f;
  Result.z := q0.z - f;
  Result.w := q0.w - f;
end;

function G2QuatFloatMul(const q0: TG2Quat; const f: TG2Float): TG2Quat;
begin
  Result.x := q0.x * f;
  Result.y := q0.y * f;
  Result.z := q0.z * f;
  Result.w := q0.w * f;
end;

function G2QuatFloatDiv(const q0: TG2Quat; const f: TG2Float): TG2Quat;
begin
  Result.x := q0.x / f;
  Result.y := q0.y / f;
  Result.z := q0.z / f;
  Result.w := q0.w / f;
end;

function G2QuatNorm(const q0: TG2Quat): TG2Quat;
  var d: TG2Float;
begin
  d := Sqrt(q0.x * q0.x + q0.y * q0.y + q0.z * q0.z + q0.w * q0.w);
  if d > 0 then
  begin
    d := 1 / d;
    Result.x := q0.x * d;
    Result.y := q0.y * d;
    Result.z := q0.z * d;
    Result.w := q0.w * d;
  end
  else
  begin
    Result.x := 0;
    Result.y := 0;
    Result.z := 0;
    Result.w := 1;
  end;
end;

function G2QuatDot(const q0, q1: TG2Quat): TG2Float;
begin
  Result := q0.x * q1.x + q0.y * q1.y + q0.z * q1.z + q0.w * q1.w
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
  const e00, e10, e20, e30: TG2Float;
  const e01, e11, e21, e31: TG2Float;
  const e02, e12, e22, e32: TG2Float;
  const e03, e13, e23, e33: TG2Float
): TG2Mat;
begin
  Result.SetValue(
    e00, e10, e20, e30,
    e01, e11, e21, e31,
    e02, e12, e22, e32,
    e03, e13, e23, e33
  );
end;

function G2Mat(const AxisX, AxisY, AxisZ, Translation: TG2Vec3): TG2Mat;
begin
  Result.SetValue(
    AxisX.x, AxisY.x, AxisZ.x, Translation.x,
    AxisX.y, AxisY.y, AxisZ.y, Translation.y,
    AxisX.z, AxisY.z, AxisZ.z, Translation.z,
    0, 0, 0, 1
  );
end;

function G2MatIdentity: TG2Mat;
begin
  Result.SetValue(
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
  );
end;

function G2MatScaling(const x, y, z: TG2Float): TG2Mat;
begin
  Result.SetValue(
    x, 0, 0, 0,
    0, y, 0, 0,
    0, 0, z, 0,
    0, 0, 0, 1
  );
end;

function G2MatScaling(const v: TG2Vec3): TG2Mat;
begin
  Result.SetValue(
    v.x, 0, 0, 0,
    0, v.y, 0, 0,
    0, 0, v.z, 0,
    0, 0, 0, 1
  );
end;

function G2MatScaling(const s: TG2Float): TG2Mat;
begin
  Result.SetValue(
    s, 0, 0, 0,
    0, s, 0, 0,
    0, 0, s, 0,
    0, 0, 0, 1
  );
end;

function G2MatTranslation(const x, y, z: TG2Float): TG2Mat;
begin
  Result.SetValue(
    1, 0, 0, x,
    0, 1, 0, y,
    0, 0, 1, z,
    0, 0, 0, 1
  );
end;

function G2MatTranslation(const v: TG2Vec3): TG2Mat;
begin
  Result.SetValue(
    1, 0, 0, v.x,
    0, 1, 0, v.y,
    0, 0, 1, v.z,
    0, 0, 0, 1
  );
end;

function G2MatRotationX(const a: TG2Float): TG2Mat;
  var s, c: TG2Float;
begin
  G2SinCos(a, s, c);
  Result.SetValue(
    1, 0, 0, 0,
    0, c, -s, 0,
    0, s, c, 0,
    0, 0, 0, 1
  );
end;

function G2MatRotationY(const a: TG2Float): TG2Mat;
  var s, c: TG2Float;
begin
  G2SinCos(a, s, c);
  Result.SetValue(
    c, 0, s, 0,
    0, 1, 0, 0,
    -s, 0, c, 0,
    0, 0, 0, 1
  );
end;

function G2MatRotationZ(const a: TG2Float): TG2Mat;
  var s, c: TG2Float;
begin
  G2SinCos(a, s, c);
  Result.SetValue(
    c, -s, 0, 0,
    s, c, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
  );
end;

function G2MatRotation(const x, y, z, a: TG2Float): TG2Mat;
begin
  Result := G2MatRotation(G2Vec3(x, y, z), a);
end;

function G2MatRotation(const v: TG2Vec3; const a: TG2Float): TG2Mat;
  var vr: TG2Vec3;
  var s, c, cr, xs, ys, zs, crxy, crxz, cryz: TG2Float;
begin
  vr := G2Vec3Norm(v);
  G2SinCos(a, s, c);
  cr := 1 - c;
  xs := vr.x * s;
  ys := vr.y * s;
  zs := vr.z * s;
  crxy := cr * vr.x * vr.y;
  crxz := cr * vr.x * vr.z;
  cryz := cr * vr.y * vr.z;
  Result.SetValue(
    cr * v.x * v.x + c, -zs + crxy, ys + crxz, 0,
    zs + crxy, cr * v.y * v.y + c, -xs + cryz, 0,
    -ys + crxz, xs + cryz, cr * v.z * v.z + c, 0,
    0, 0, 0, 1
  );
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
  Result.SetValue(
    1 - yy - zz, xy - wz, xz + wy, 0,
    xy + wz, 1 - xx - zz, yz - wx, 0,
    xz - wy, yz + wx, 1 - xx - yy, 0,
    0, 0, 0, 1
  );
end;

function G2MatView(const Pos, Target, Up: TG2Vec3): TG2Mat;
  var VecX, VecY, VecZ: TG2Vec3;
begin
  VecZ := G2Vec3Norm(G2Vec3Sub(Target, Pos));
  VecX := G2Vec3Norm(G2Vec3Cross(Up, VecZ));
  VecY := G2Vec3Norm(G2Vec3Cross(VecZ, VecX));
  Result.SetValue(
    VecX.x, VecX.y, VecX.z, -G2Vec3Dot(VecX, Pos),
    VecY.x, VecY.y, VecY.z, -G2Vec3Dot(VecY, Pos),
    VecZ.x, VecZ.y, VecZ.z, -G2Vec3Dot(VecZ, Pos),
    0, 0, 0, 1
  );
end;

function G2MatOrth(const Width, Height, ZNear, ZFar: TG2Float): TG2Mat;
  var RcpD: TG2Float;
begin
  RcpD := 1 / (ZFar - ZNear);
  Result.SetValue(
    2 / Width, 0, 0, 0,
    0, 2 / Height, 0, 0,
    0, 0, RcpD, -ZNear * RcpD,
    0, 0, 0, 1
  );
end;

function G2MatOrth2D(const Width, Height, ZNear, ZFar: TG2Float; FlipH: Boolean; FlipV: Boolean): TG2Mat;
  var RcpD, x, y, w, h: TG2Float;
begin
  if FlipH then begin x := 1; w := -2 / Width; end else begin x := -1; w := 2 / Width; end;
  if FlipV then begin y := 1; h := -2 / Height; end else begin y := -1; h := 2 / Height; end;
  RcpD := 1 / (ZFar - ZNear);
  Result.SetValue(
    w, 0, 0, x,
    0, h, 0, y,
    0, 0, RcpD, -ZNear * RcpD,
    0, 0, 0, 1
  );
end;

function G2MatProj(const FOV, Aspect, ZNear, ZFar: TG2Float): TG2Mat;
  var ct, q: TG2Float;
begin
  ct := CoTan(FOV * 0.5);
  q := ZFar / (ZFar - ZNear);
  Result.SetValue(
    ct / Aspect, 0, 0, 0,
    0, ct, 0, 0,
    0, 0, q, -q * ZNear,
    0, 0, 1, 0
  );
end;

function G2MatTranspose(const m: TG2Mat): TG2Mat;
begin
  Result.SetValue(
    m.e00, m.e01, m.e02, m.e03,
    m.e10, m.e11, m.e12, m.e13,
    m.e20, m.e21, m.e22, m.e23,
    m.e30, m.e31, m.e32, m.e33
  );
end;

function G2MatAdd(const m0, m1: TG2Mat): TG2Mat;
  var i: Integer;
begin
  for i := 0 to 15 do
  Result[i] := m0[i] + m1[i];
end;

function G2MatSub(const m0, m1: TG2Mat): TG2Mat;
  var i: Integer;
begin
  for i := 0 to 15 do
  Result[i] := m0[i] - m1[i];
end;

function G2MatFloatAdd(const m0: TG2Mat; const f: TG2Float): TG2Mat;
  var i: Integer;
begin
  for i := 0 to 15 do
  Result[i] := m0[i] + f;
end;

function G2MatFloatSub(const m0: TG2Mat; const f: TG2Float): TG2Mat;
  var i: Integer;
begin
  for i := 0 to 15 do
  Result[i] := m0[i] - f;
end;

function G2MatFloatMul(const m0: TG2Mat; const f: TG2Float): TG2Mat;
  var i: Integer;
begin
  for i := 0 to 15 do
  Result[i] := m0[i] * f;
end;

function G2MatFloatDiv(const m0: TG2Mat; const f: TG2Float): TG2Mat;
  var i: Integer;
begin
  for i := 0 to 15 do
  Result[i] := m0[i] / f;
end;

function G2MatMul(const m0, m1: TG2Mat): TG2Mat;
  var mr: TG2Mat;
begin
  mr.e00 := m0.e00 * m1.e00 + m0.e01 * m1.e10 + m0.e02 * m1.e20 + m0.e03 * m1.e30;
  mr.e10 := m0.e10 * m1.e00 + m0.e11 * m1.e10 + m0.e12 * m1.e20 + m0.e13 * m1.e30;
  mr.e20 := m0.e20 * m1.e00 + m0.e21 * m1.e10 + m0.e22 * m1.e20 + m0.e23 * m1.e30;
  mr.e30 := m0.e30 * m1.e00 + m0.e31 * m1.e10 + m0.e32 * m1.e20 + m0.e33 * m1.e30;
  mr.e01 := m0.e00 * m1.e01 + m0.e01 * m1.e11 + m0.e02 * m1.e21 + m0.e03 * m1.e31;
  mr.e11 := m0.e10 * m1.e01 + m0.e11 * m1.e11 + m0.e12 * m1.e21 + m0.e13 * m1.e31;
  mr.e21 := m0.e20 * m1.e01 + m0.e21 * m1.e11 + m0.e22 * m1.e21 + m0.e23 * m1.e31;
  mr.e31 := m0.e30 * m1.e01 + m0.e31 * m1.e11 + m0.e32 * m1.e21 + m0.e33 * m1.e31;
  mr.e02 := m0.e00 * m1.e02 + m0.e01 * m1.e12 + m0.e02 * m1.e22 + m0.e03 * m1.e32;
  mr.e12 := m0.e10 * m1.e02 + m0.e11 * m1.e12 + m0.e12 * m1.e22 + m0.e13 * m1.e32;
  mr.e22 := m0.e20 * m1.e02 + m0.e21 * m1.e12 + m0.e22 * m1.e22 + m0.e23 * m1.e32;
  mr.e32 := m0.e30 * m1.e02 + m0.e31 * m1.e12 + m0.e32 * m1.e22 + m0.e33 * m1.e32;
  mr.e03 := m0.e00 * m1.e03 + m0.e01 * m1.e13 + m0.e02 * m1.e23 + m0.e03 * m1.e33;
  mr.e13 := m0.e10 * m1.e03 + m0.e11 * m1.e13 + m0.e12 * m1.e23 + m0.e13 * m1.e33;
  mr.e23 := m0.e20 * m1.e03 + m0.e21 * m1.e13 + m0.e22 * m1.e23 + m0.e23 * m1.e33;
  mr.e33 := m0.e30 * m1.e03 + m0.e31 * m1.e13 + m0.e32 * m1.e23 + m0.e33 * m1.e33;
  Result := mr;
end;

function G2MatInv(const m0: TG2Mat): TG2Mat;
  var d, di: TG2Float;
begin
  di := m0.e00;
  d := 1 / di;
  Result.e00 := d;
  Result.e10 := -m0.e10 * d;
  Result.e20 := -m0.e20 * d;
  Result.e30 := -m0.e30 * d;
  Result.e01 := m0.e01 * d;
  Result.e02 := m0.e02 * d;
  Result.e03 := m0.e03 * d;
  Result.e11 := m0.e11 + Result.e10 * Result.e01 * di;
  Result.e12 := m0.e12 + Result.e10 * Result.e02 * di;
  Result.e13 := m0.e13 + Result.e10 * Result.e03 * di;
  Result.e21 := m0.e21 + Result.e20 * Result.e01 * di;
  Result.e22 := m0.e22 + Result.e20 * Result.e02 * di;
  Result.e23 := m0.e23 + Result.e20 * Result.e03 * di;
  Result.e31 := m0.e31 + Result.e30 * Result.e01 * di;
  Result.e32 := m0.e32 + Result.e30 * Result.e02 * di;
  Result.e33 := m0.e33 + Result.e30 * Result.e03 * di;
  di := Result.e11;
  d := 1 / di;
  Result.e11 := d;
  Result.e01 := -Result.e01 * d;
  Result.e21 := -Result.e21 * d;
  Result.e31 := -Result.e31 * d;
  Result.e10 := Result.e10 * d;
  Result.e12 := Result.e12 * d;
  Result.e13 := Result.e13 * d;
  Result.e00 := Result.e00 + Result.e01 * Result.e10 * di;
  Result.e02 := Result.e02 + Result.e01 * Result.e12 * di;
  Result.e03 := Result.e03 + Result.e01 * Result.e13 * di;
  Result.e20 := Result.e20 + Result.e21 * Result.e10 * di;
  Result.e22 := Result.e22 + Result.e21 * Result.e12 * di;
  Result.e23 := Result.e23 + Result.e21 * Result.e13 * di;
  Result.e30 := Result.e30 + Result.e31 * Result.e10 * di;
  Result.e32 := Result.e32 + Result.e31 * Result.e12 * di;
  Result.e33 := Result.e33 + Result.e31 * Result.e13 * di;
  di := Result.e22;
  d := 1 / di;
  Result.e22 := d;
  Result.e02 := -Result.e02 * d;
  Result.e12 := -Result.e12 * d;
  Result.e32 := -Result.e32 * d;
  Result.e20 := Result.e20 * d;
  Result.e21 := Result.e21 * d;
  Result.e23 := Result.e23 * d;
  Result.e00 := Result.e00 + Result.e02 * Result.e20 * di;
  Result.e01 := Result.e01 + Result.e02 * Result.e21 * di;
  Result.e03 := Result.e03 + Result.e02 * Result.e23 * di;
  Result.e10 := Result.e10 + Result.e12 * Result.e20 * di;
  Result.e11 := Result.e11 + Result.e12 * Result.e21 * di;
  Result.e13 := Result.e13 + Result.e12 * Result.e23 * di;
  Result.e30 := Result.e30 + Result.e32 * Result.e20 * di;
  Result.e31 := Result.e31 + Result.e32 * Result.e21 * di;
  Result.e33 := Result.e33 + Result.e32 * Result.e23 * di;
  di := Result.e33;
  d := 1 / di;
  Result.e33 := d;
  Result.e03 := -Result.e03 * d;
  Result.e13 := -Result.e13 * d;
  Result.e23 := -Result.e23 * d;
  Result.e30 := Result.e30 * d;
  Result.e31 := Result.e31 * d;
  Result.e32 := Result.e32 * d;
  Result.e00 := Result.e00 + Result.e03 * Result.e30 * di;
  Result.e01 := Result.e01 + Result.e03 * Result.e31 * di;
  Result.e02 := Result.e02 + Result.e03 * Result.e32 * di;
  Result.e10 := Result.e10 + Result.e13 * Result.e30 * di;
  Result.e11 := Result.e11 + Result.e13 * Result.e31 * di;
  Result.e12 := Result.e12 + Result.e13 * Result.e32 * di;
  Result.e20 := Result.e20 + Result.e23 * Result.e30 * di;
  Result.e21 := Result.e21 + Result.e23 * Result.e31 * di;
  Result.e22 := Result.e22 + Result.e23 * Result.e32 * di;
end;

procedure G2MatDecompose(var OutScaling: TG2Vec3; var OutRotation: TG2Quat; var OutTranslation: TG2Vec3; const m: TG2Mat);
  var mn: TG2Mat;
  var v: TG2Vec3;
begin
  OutScaling.x := G2Vec3Len(G2Vec3(m.e00, m.e01, m.e02));
  OutScaling.y := G2Vec3Len(G2Vec3(m.e10, m.e11, m.e12));
  OutScaling.z := G2Vec3Len(G2Vec3(m.e20, m.e21, m.e22));
  OutTranslation := G2Vec3(m.e30, m.e31, m.e32);
  if (OutScaling.x = 0) or (OutScaling.y = 0) or (OutScaling.z = 0) then
  begin
    OutRotation.SetValue(0, 0, 0, 1);
    Exit;
  end;
  v.x := 1 / OutScaling.x;
  v.y := 1 / OutScaling.y;
  v.z := 1 / OutScaling.z;
  mn.SetValue(
    m.e00 * v.x, m.e10 * v.y, m.e20 * v.z, 0,
    m.e01 * v.x, m.e11 * v.y, m.e21 * v.z, 0,
    m.e02 * v.x, m.e12 * v.y, m.e22 * v.z, 0,
    0, 0, 0, 1
  );
  OutRotation := G2Quat(mn);
end;

function G2BoxToAABox(const b: TG2Box): TG2AABox;
  var i: Integer;
  var v: array[0..7] of TG2Vec3;
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
    if v[i].x < Result.MinV.x then Result.MinV.x := v[i].x;
    if v[i].y < Result.MinV.y then Result.MinV.y := v[i].y;
    if v[i].z < Result.MinV.z then Result.MinV.z := v[i].z;
    if v[i].x > Result.MaxV.x then Result.MaxV.x := v[i].x;
    if v[i].y > Result.MaxV.y then Result.MaxV.y := v[i].y;
    if v[i].z > Result.MaxV.z then Result.MaxV.z := v[i].z;
  end;
end;

function G2AABoxToBox(const b: TG2AABox): TG2Box;
  var v: TG2Vec3;
begin
  Result.c := (b.MinV + b.MaxV) * 0.5;
  v := (b.MaxV - b.MinV) * 0.5;
  Result.vx.SetValue(v.x, 0, 0);
  Result.vy.SetValue(0, v.y, 0);
  Result.vz.SetValue(0, 0, v.z);
end;

end.
