unit G2Types;
{$include Gen2MP.inc}
interface

const
  G2K_Escape = 0;
  G2K_F1 = 1;
  G2K_F2 = 2;
  G2K_F3 = 3;
  G2K_F4 = 4;
  G2K_F5 = 5;
  G2K_F6 = 6;
  G2K_F7 = 7;
  G2K_F8 = 8;
  G2K_F9 = 9;
  G2K_F10 = 10;
  G2K_F11 = 11;
  G2K_F12 = 12;
  G2K_ScrlLock = 13;
  G2K_Pause = 14;
  G2K_Tilda = 15;
  G2K_1 = 16;
  G2K_2 = 17;
  G2K_3 = 18;
  G2K_4 = 19;
  G2K_5 = 20;
  G2K_6 = 21;
  G2K_7 = 22;
  G2K_8 = 23;
  G2K_9 = 24;
  G2K_0 = 25;
  G2K_Minus = 26;
  G2K_Plus = 27;
  G2K_Back = 28;
  G2K_Tab = 29;

  G2K_A = 30;
  G2K_B = 31;
  G2K_C = 32;
  G2K_D = 33;
  G2K_E = 34;
  G2K_F = 35;
  G2K_G = 36;
  G2K_H = 37;
  G2K_I = 38;
  G2K_J = 39;
  G2K_K = 40;
  G2K_L = 41;
  G2K_M = 42;
  G2K_N = 43;
  G2K_O = 44;
  G2K_P = 45;
  G2K_Q = 46;
  G2K_R = 47;
  G2K_S = 48;
  G2K_T = 49;
  G2K_U = 50;
  G2K_V = 51;
  G2K_W = 52;
  G2K_X = 53;
  G2K_Y = 54;
  G2K_Z = 55;

  G2K_BrktL = 56;
  G2K_BrktR = 57;
  G2K_SemiCol = 58;
  G2K_Quote = 59;
  G2K_Comma = 60;
  G2K_Period = 61;
  G2K_Slash = 62;
  G2K_SlashR = 63;
  G2K_CapsLock = 64;
  G2K_ShiftL = 65;
  G2K_ShiftR = 66;
  G2K_CtrlL = 67;
  G2K_CtrlR = 68;
  G2K_WinL = 69;
  G2K_WinR = 70;
  G2K_AltL = 71;
  G2K_AltR = 72;
  G2K_Menu = 73;
  G2K_Return = 74;
  G2K_Space = 75;

  G2K_Insert = 76;
  G2K_Home = 77;
  G2K_PgUp = 78;
  G2K_Delete = 79;
  G2K_End = 80;
  G2K_PgDown = 81;

  G2K_Up = 82;
  G2K_Down = 83;
  G2K_Left = 84;
  G2K_Right = 85;

  G2K_NumLock = 86;
  G2K_NumDiv = 87;
  G2K_NumMul = 88;
  G2K_NumMinus = 89;
  G2K_NumPlus = 90;
  G2K_NumReturn = 91;
  G2K_NumPeriod = 92;
  G2K_Num0 = 93;
  G2K_Num1 = 94;
  G2K_Num2 = 95;
  G2K_Num3 = 96;
  G2K_Num4 = 97;
  G2K_Num5 = 98;
  G2K_Num6 = 99;
  G2K_Num7 = 100;
  G2K_Num8 = 101;
  G2K_Num9 = 102;

  G2K_Ctrl = G2K_CtrlL;
  G2K_Shift = G2K_ShiftL;
  G2K_Alt = G2K_AltL;

  G2MB_Undefined = 0;
  G2MB_Left = 1;
  G2MB_Right = 2;
  G2MB_Middle = 3;

  G2TwoPi = Pi * 2;
  G2HalfPi = Pi * 0.5;
  G2QuatPi = Pi * 0.25;
  G2RcpPi = 1 / Pi;
  G2Rcp255 = 1 / $ff;
  G2EPS = 1E-6;
  G2EPS2 = 1E-5;
  G2DegToRad = Pi / 180;
  G2RadToDeg = 180 / Pi;

  {$if defined(G2Target_Windows)}
  G2PathSep: AnsiChar = '\';
  G2PathSepRev: AnsiChar = '/';
  {$elseif defined(G2Target_Linux)}
  G2PathSep: AnsiChar = '/';
  G2PathSepRev: AnsiChar = '\';
  {$elseif defined(G2Target_OSX)}
  G2PathSep: AnsiChar = '/';
  G2PathSepRev: AnsiChar = '\';
  {$elseif defined(G2Target_Android)}
  G2PathSep: AnsiChar = '/';
  G2PathSepRev: AnsiChar = '\';
  {$elseif defined(G2Target_iOS)}
  G2PathSep: AnsiChar = '/';
  G2PathSepRev: AnsiChar = '\';
  {$endif}

type
  TG2IntS64 = Int64;
  TG2IntU32 = LongWord;
  TG2IntS32 = Integer;
  TG2IntU16 = Word;
  TG2IntS16 = SmallInt;
  TG2IntU8 = Byte;
  TG2IntS8 = ShortInt;
  TG2Float = Single;
  TG2Float64 = Double;
  TG2Float80 = Extended;
  TG2Bool = Boolean;
  TG2IntS64Arr = array[Word] of TG2IntS64;
  TG2IntU32Arr = array[Word] of TG2IntU32;
  TG2IntS32Arr = array[Word] of TG2IntS32;
  TG2IntU16Arr = array[Word] of TG2IntU16;
  TG2IntS16Arr = array[Word] of TG2IntS16;
  TG2IntU8Arr = array[Word] of TG2IntU8;
  TG2IntS8Arr = array[Word] of TG2IntS8;
  TG2FloatArr = array[Word] of TG2Float;
  PG2IntS64 = ^TG2IntS64;
  PG2IntU32 = ^TG2IntU32;
  PG2IntS32 = ^TG2IntS32;
  PG2IntU16 = ^TG2IntU16;
  PG2IntS16 = ^TG2IntS16;
  PG2IntU8 = ^TG2IntU8;
  PG2IntS8 = ^TG2IntS8;
  PG2Float = ^TG2Float;
  PG2Float64 = ^TG2Float64;
  PG2Float80 = ^TG2Float80;
  PG2Bool = ^TG2Bool;
  PG2IntS64Arr = ^TG2IntS64Arr;
  PG2IntU32Arr = ^TG2IntU32Arr;
  PG2IntS32Arr = ^TG2IntS32Arr;
  PG2IntU16Arr = ^TG2IntU16Arr;
  PG2IntS16Arr = ^TG2IntS16Arr;
  PG2IntU8Arr = ^TG2IntU8Arr;
  PG2IntS8Arr = ^TG2IntS8Arr;
  PG2FloatArr = ^TG2FloatArr;
  PPG2IntS32 = ^PG2IntS32;
  PPG2Float = ^PG2Float;
  PPG2Float64 = ^PG2Float64;
  PPG2Float80 = ^PG2Float80;

  TG2StrArrA = array of AnsiString;
  TG2StrArrW = array of WideString;

  TG2Color = packed record
    {$if defined(G2Gfx_D3D9)}
    b, g, r, a: TG2IntU8;
    {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
    r, g, b, a: TG2IntU8;
    {$endif}
  end;
  PG2Color = ^TG2Color;
  PPG2Color = ^PG2Color;

  {$MINENUMSIZE 1}
  TG2BlendOperation = (
    boDisable = 0,
    boZero = 1,
    boOne = 2,
    boSrcColor = 3,
    boInvSrcColor = 4,
    boDstColor = 5,
    boInvDstColor = 6,
    boSrcAlpha = 7,
    boInvSrcAlpha = 8,
    boDstAlpha = 9,
    boInvDstAlpha = 10
  );
  {$MINENUMSIZE 4}

  TG2BlendMode = packed object
    ColorSrc: TG2BlendOperation;
    ColorDst: TG2BlendOperation;
    AlphaSrc: TG2BlendOperation;
    AlphaDst: TG2BlendOperation;
    function BlendEnable: Boolean;
    function BlendSeparate: Boolean;
    procedure SwapColorAlpha;
  end;
  PG2BlendMode = ^TG2BlendMode;
  TG2BlendModeRef = TG2IntU32;

  TG2Ref = class
  private
    var _Ref: TG2IntS32;
  public
    procedure RefInc; //inline;
    procedure RefDec; //inline;
    property RefCount: TG2IntS32 read _Ref;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function IsReferenced: Boolean; inline;
  end;

  TG2Res = class (TG2Ref)
  public
    class var List: TG2Res;
    var Next: TG2Res;
    var Prev: TG2Res;
  protected
    procedure Initialize; virtual;
    procedure Finalize; virtual;
  public
    class constructor CreateClass;
    class procedure CleanUp;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

  TG2Asset = class (TG2Res)
  private
    class var ListLocked: array [0..1] of TG2Asset;
    var PrevLocked: array [0..1] of TG2Asset;
    var NextLocked: array [0..1] of TG2Asset;
    var _Lock: array[0..1] of Boolean;
    var _AssetName: String;
    var _MarkForDeletion: Boolean;
  protected
    procedure Initialize; override;
    procedure Finalize; override;
  public
    property AssetName: String read _AssetName write _AssetName;
    class constructor CreateClass;
    class procedure UnlockQueue(const Queue: TG2IntU8);
    function IsShared: Boolean; inline;
    procedure LockAsset(const Queue: TG2IntU8);
    procedure UnlockAsset(const Queue: TG2IntU8);
    procedure Free; reintroduce;
  end;

  operator := (c: TG2Color) cr: TG2IntU32;
  operator := (c: TG2IntU32) cr: TG2Color;
  operator + (c0, c1: TG2Color) cr: TG2Color;
  operator - (c0, c1: TG2Color) cr: TG2Color;
  operator * (c0, c1: TG2Color) cr: TG2Color;
  operator := (bm: TG2BlendMode) bmr: TG2IntU32;
  operator := (bm: TG2IntU32) bmr: TG2BLendMode;
  operator = (bm0, bm1: TG2BlendMode) r: Boolean;

  function G2Color(const r, g, b, a: TG2IntU8): TG2Color;

const
  bmInvalid = $ffffffff;
  bmDisable = (TG2IntU8(boDisable)) or (TG2IntU8(boDisable) shl 8) or (TG2IntU8(boDisable) shl 16) or (TG2IntU8(boDisable) shl 24);
  bmNormal = (TG2IntU8(boSrcAlpha)) or (TG2IntU8(boInvSrcAlpha) shl 8) or (TG2IntU8(boOne) shl 16) or (TG2IntU8(boOne) shl 24);
  bmAdd = (TG2IntU8(boSrcAlpha)) or (TG2IntU8(boDstAlpha) shl 8) or (TG2IntU8(boOne) shl 16) or (TG2IntU8(boOne) shl 24);
  bmSub = (TG2IntU8(boZero)) or (TG2IntU8(boInvSrcColor) shl 8) or (TG2IntU8(boZero) shl 16) or (TG2IntU8(boInvSrcColor) shl 24);
  bmMul = (TG2IntU8(boDstColor)) or (TG2IntU8(boInvSrcAlpha) shl 8) or (TG2IntU8(boZero) shl 16) or (TG2IntU8(boSrcAlpha) shl 24);

implementation

function ByteMax(const b0, b1: SmallInt): Byte; inline;
begin
  if b0 > b1 then
  Result := b0
  else
  Result := b1;
end;

function ByteMin(const b0, b1: SmallInt): Byte; inline;
begin
  if b0 < b1 then
  Result := b0
  else
  Result := b1;
end;

//TG2BlendMode BIEGN
function TG2BlendMode.BlendEnable: Boolean;
begin
  Result := PG2IntU32(@Self)^ <> 0;
end;

function TG2BlendMode.BlendSeparate: Boolean;
begin
  Result := (ColorSrc <> AlphaSrc) or (ColorDst <> AlphaDst);
end;

procedure TG2BlendMode.SwapColorAlpha;
  var TmpSrcColor, TmpDstColor: TG2BlendOperation;
begin
  TmpSrcColor := ColorSrc;
  TmpDstColor := ColorDst;
  ColorSrc := AlphaSrc;
  ColorDst := AlphaDst;
  AlphaSrc := TmpSrcColor;
  AlphaDst := TmpDstColor;
end;
//TG2BlendMode END

//TG2Ref BEGIN
procedure TG2Ref.RefInc;
begin
  Inc(_Ref);
end;

procedure TG2Ref.RefDec;
begin
  Dec(_Ref);
  if _Ref <= 0 then
  if Self is TG2Asset then TG2Asset(Self).Free else Free;
end;

procedure TG2Ref.AfterConstruction;
begin
  inherited AfterConstruction;
  _Ref := 0;
end;

procedure TG2Ref.BeforeDestruction;
begin
  inherited BeforeDestruction;
end;

function TG2Ref.IsReferenced: Boolean;
begin
  Result := _Ref > 0;
end;
//TG2Ref END

//TG2Res BEGIN
procedure TG2Res.Initialize;
begin

end;

procedure TG2Res.Finalize;
begin

end;

class constructor TG2Res.CreateClass;
begin
  List := nil;
end;

class procedure TG2Res.CleanUp;
  var Res: TG2Res;
begin
  while List <> nil do
  begin
    Res := List;
    while Res.Next <> nil do Res := Res.Next;
    Res.Free;
  end;
end;

procedure TG2Res.AfterConstruction;
begin
  inherited AfterConstruction;
  Prev := nil;
  Next := List;
  if List <> nil then List.Prev := Self;
  List := Self;
  Initialize;
end;

procedure TG2Res.BeforeDestruction;
begin
  Finalize;
  if Prev <> nil then Prev.Next := Next;
  if Next <> nil then Next.Prev := Prev;
  if List = Self then List := Next;
  inherited BeforeDestruction;
end;
//TG2Res END

//TG2Asset BEGIN
procedure TG2Asset.Initialize;
begin
  inherited Initialize;
  _AssetName := '';
  _Lock[0] := False;
  _Lock[1] := False;
  _MarkForDeletion := False;
  PrevLocked[0] := nil;
  PrevLocked[1] := nil;
  NextLocked[0] := nil;
  NextLocked[1] := nil;
end;

procedure TG2Asset.Finalize;
begin
  inherited Finalize;
end;

class constructor TG2Asset.CreateClass;
begin
  ListLocked[0] := nil;
  ListLocked[1] := nil;
end;

class procedure TG2Asset.UnlockQueue(const Queue: TG2IntU8);
begin
  while ListLocked[Queue] <> nil do
  ListLocked[Queue].UnlockAsset(Queue);
end;

function TG2Asset.IsShared: Boolean;
begin
  Result := Length(_AssetName) > 0;
end;

procedure TG2Asset.LockAsset(const Queue: TG2IntU8);
begin
  if _Lock[Queue] then Exit;
  _Lock[Queue] := True;
  NextLocked[Queue] := ListLocked[Queue];
  PrevLocked[Queue] := nil;
  if ListLocked[Queue] <> nil then ListLocked[Queue].PrevLocked[Queue] := Self;
  ListLocked[Queue] := Self;
end;

procedure TG2Asset.UnlockAsset(const Queue: TG2IntU8);
begin
  if not _Lock[Queue] then Exit;
  _Lock[Queue] := False;
  if PrevLocked[Queue] <> nil then PrevLocked[Queue].NextLocked[Queue] := NextLocked[Queue];
  if NextLocked[Queue] <> nil then NextLocked[Queue].PrevLocked[Queue] := PrevLocked[Queue];
  if Self = ListLocked[Queue] then ListLocked[Queue] := NextLocked[Queue];
  if _MarkForDeletion then Free;
end;

procedure TG2Asset.Free;
begin
  if not _Lock[0] and not _Lock[1] then
  begin
    if (Self <> nil) then Self.Destroy;
  end
  else
  begin
    _MarkForDeletion := True;
  end;
end;
//TG2Asset END

operator := (c: TG2Color) cr: TG2IntU32;
begin
  {$if defined(G2Gfx_D3D9)}
  Result := PG2IntU32(@c)^;
  {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
  Result := c.b or (c.g shl 8) or (c.r shl 16) or (c.a shl 24);
  {$endif}
end;

operator := (c: TG2IntU32) cr: TG2Color;
begin
  {$if defined(G2Gfx_D3D9)}
  Result := PG2Color(@c)^;
  {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
  Result.r := PG2Color(@c)^.b;
  Result.g := PG2Color(@c)^.g;
  Result.b := PG2Color(@c)^.r;
  Result.a := PG2Color(@c)^.a;
  {$endif}
end;

operator + (c0, c1: TG2Color) cr: TG2Color;
begin
  Result.r := ByteMin(c0.r + c1.r, $ff);
  Result.g := ByteMin(c0.g + c1.g, $ff);
  Result.b := ByteMin(c0.b + c1.b, $ff);
  Result.a := ByteMin(c0.a + c1.a, $ff);
end;

operator - (c0, c1: TG2Color) cr: TG2Color;
begin
  Result.r := ByteMax(c0.r + c1.r, 0);
  Result.g := ByteMax(c0.g + c1.g, 0);
  Result.b := ByteMax(c0.b + c1.b, 0);
  Result.a := ByteMax(c0.a + c1.a, 0);
end;

operator * (c0, c1: TG2Color) cr: TG2Color;
begin
  Result.r := Round((c0.r * G2Rcp255 * c1.r * G2Rcp255) * $ff);
  Result.g := Round((c0.g * G2Rcp255 * c1.g * G2Rcp255) * $ff);
  Result.b := Round((c0.b * G2Rcp255 * c1.b * G2Rcp255) * $ff);
  Result.a := Round((c0.a * G2Rcp255 * c1.a * G2Rcp255) * $ff);
end;

operator := (bm: TG2BlendMode) bmr: TG2IntU32;
begin
  Result := PG2IntU32(@bm)^;
end;

operator := (bm: TG2IntU32) bmr: TG2BLendMode;
begin
  Result := PG2BlendMode(@bm)^;
end;

operator = (bm0, bm1: TG2BlendMode) r: Boolean;
begin
  Result := PG2IntU32(@bm0)^ = PG2IntU32(@bm1)^;
end;

function G2Color(const r, g, b, a: TG2IntU8): TG2Color;
begin
  Result.a := a;
  Result.r := r;
  Result.g := g;
  Result.b := b;
end;

end.
