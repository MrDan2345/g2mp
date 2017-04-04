unit Gen2MP;

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
  w3system,
  w3application,
  w3components,
  w3graphics,
  Khronos.WebGl,
  w3c.TypedArray,
  G2Types,
  G2Utils,
  G2Math,
  G2DataManager,
  G2Shaders,
  G2MeshData;

type
  TG2Core = class;
  TG2TextureBase = class;
  TG2Texture2DBase = class;
  TG2Texture2D = class;
  TG2Texture2DRT = class;
  TG2VertexBuffer = class;
  TG2IndexBuffer = class;
  TG2ShaderProgram = class;
  TG2RenderControl = class;
  TG2RenderControlPrim2D = class;
  TG2RenderControlPic2D = class;
  TG2RenderControlBuffer = class;
  TG2Scene3D = class;
  TG2S3DMesh = class;
  TG2S3DMeshInst = class;
  TG2S3DParticle = class;

  TG2BlendMode = (
    bmInvalid,
    bmDisable,
    bmNormal,
    bmAdd,
    bmSub,
    bmMul
  );

  TG2Filter = (
    tfNone = 0,
    tfPoint = 1,
    tfLinear = 2
  );

  TG2PrimitiveType = (
    ptPointList = 1,
    ptLineList = 2,
    ptLineStrip = 3,
    ptTriangleList = 4,
    ptTriangleStrip = 5,
    ptTriangleFan = 6
  );

  TG2Prim2DType = (
    ptNone,
    ptLines,
    ptTriangles
  );
  
  TG2Proc = procedure;
  TG2ProcObj = procedure of Object;
  TG2ProcPtr = procedure (const Ptr: Pointer);
  TG2ProcPtrObj = procedure (const Ptr: Pointer) of Object;
  TG2ProcWndMessage = procedure (const Param1, Param2, Param3: Integer) of Object;
  TG2ProcChar = procedure (const c: AnsiChar);
  TG2ProcCharObj = procedure (const c: AnsiChar) of Object;
  TG2ProcKey = procedure (const Key: Integer);
  TG2ProcKeyObj = procedure (const Key: Integer) of Object;
  TG2ProcMouse = procedure (const Button, x, y: Integer);
  TG2ProcMouseObj = procedure (const Button, x, y: Integer) of Object;
  TG2ProcScroll = procedure (const y: Integer);
  TG2ProcScrollObj = procedure (const y: Integer) of Object;
  TG2ProcInt = procedure (const v: Integer);
  TG2ProcIntObj = procedure (const v: Integer) of Object;
  TG2ProcString = procedure (const s: String);
  TG2ProcStringObj = procedure (const s: String) of Object;

  TG2Gfx = class (TObject)
  private
    _Handle: THandle;
    _BlendMode: TG2BlendMode;
    _BlendEnable: Boolean;
    _RenderTarget: TG2Texture2DRT;
    _DepthEnable: Boolean;
    _DepthWriteEnable: Boolean;
    _Shader: TG2ShaderProgram;
    procedure SetBlendMode(const Value: TG2BlendMode);
    procedure SetRenderTarget(const Value: TG2Texture2DRT);
    procedure SetDepthEnable(const Value: Boolean);
    procedure SetDepthWriteEnable(const Value: Boolean);
  public
    gl: JWebGLRenderingContext;
    property BlendMode: TG2BlendMode read _BlendMode write SetBlendMode;
    property RenderTarget: TG2Texture2DRT read _RenderTarget write SetRenderTarget;
    property Shader: TG2ShaderProgram read _Shader write _Shader;
    property DepthEnable: Boolean read _DepthEnable write SetDepthEnable;
    property DepthWriteEnable: Boolean read _DepthWriteEnable write SetDepthWriteEnable;
    constructor Create(const Handle: THandle);
    destructor Destroy; override;
    procedure SetDefaults;
  end;

  TG2Params = class (TObject)
  private
    function GetWidth: Integer;
    procedure SetWidth(const Value: Integer);
    function GetHeight: Integer;
    procedure SetHeight(const Value: Integer);
  public
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
  end;

  TG2LocalStorage = class (TObject)
  private
    function GetKey(const Key: String): String;
    procedure SetKey(const Key, Value: String);
  public
    property Items[const Key: String]: String read GetKey write SetKey; default;
  end;

  TG2Link = class (TObject)
  public
    Next: TG2Link;
    Prev: TG2Link;
  end;
  
  TG2LinkProc = class (TG2Link)
    Proc: TG2Proc;
  end;
  
  TG2LinkRender = class (TG2Link)
    Proc: TG2Proc;
    Order: TG2Float;
  end;
  
  TG2LinkPrint = class (TG2Link)
    Proc: TG2ProcChar;
  end;

  TG2LinkKey = class (TG2Link)
    Proc: TG2ProcKey;
  end;

  TG2LinkMouse = class (TG2Link)
    Proc: TG2ProcMouse;
  end;

  TG2LinkScroll = class (TG2Link)
    Proc: TG2ProcScroll;
  end;
  
  TG2Core = class (TG2Resource)
  private
    _Body: TDocumentBody;
    _Canvas: TW3GraphicContext;
    _TargetUPS: Integer;
    _FPS: Integer;
    _TotalFrames: Integer;
    _TimeToUpdate: Integer;
    _LastTick: Integer;
    _LastFPSUpdate: Integer;
    _TimerPause: Boolean;
    _TimerEnable: Boolean;
    _LinkInitialize: TG2LinkProc;
    _LinkFinalize: TG2LinkProc;
    _LinkUpdate: TG2LinkProc;
    _LinkRender: TG2LinkRender;
    _LinkPrint: TG2LinkPrint;
    _LinkKeyDown: TG2LinkKey;
    _LinkKeyUp: TG2LinkKey;
    _LinkMouseDown: TG2LinkMouse;
    _LinkMouseUp: TG2LinkMouse;
    _LinkScroll: TG2LinkScroll;
    _Gfx: TG2Gfx;
    _Params: TG2Params;
    _LocalStorage: TG2LocalStorage;
    _RenderControl: TG2RenderControl;
    _RenderControlPrim2D: TG2RenderControlPrim2D;
    _RenderControlPic2D: TG2RenderControlPic2D;
    _RenderControlBuffer: TG2RenderControlBuffer;
    _ClearColor: TG2Vec4;
    _MousePos: TG2Point;
    _LoadingItems: Integer;
    procedure ClearLinks(var List: TG2Link);
    procedure Initialize;
    procedure Finalize;
    function GetWidth: Integer;
    procedure SetWidth(const Value: Integer);
    function GetHeight: Integer;
    procedure SetHeight(const Value: Integer);
    procedure OnTimer;
    procedure OnUpdate;
    procedure OnRender;
    procedure OnMouseMove(const e: Variant);
    procedure OnMouseDown(const e: Variant);
    procedure OnMouseUp(const e: Variant);
    procedure OnScroll;
    procedure SetRenderControl(const Value: TG2RenderControl);
    function GetDeltaTime: TG2Float;
  public
    property Params: TG2Params read _Params;
    property LocalStorage: TG2LocalStorage read _LocalStorage;
    property Gfx: TG2Gfx read _Gfx;
    property RenderControl: TG2RenderControl read _RenderControl write SetRenderControl;
    property ClearColor: TG2Vec4 read _ClearColor write _ClearColor;
    property LoadingItems: Integer read _LoadingItems write _LoadingItems;
    property MousePos: TG2Point read _MousePos;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property FPS: Integer read _FPS;
    property DeltaTime: TG2Float read GetDeltaTime;
    property TargetUPS: Integer read _TargetUPS write _TargetUPS;
    property TimerPause: Boolean read _TimerPause write _TimerPause;
    property TimerEnable: Boolean read _TimerEnable write _TimerEnable;
    constructor Create; override;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    procedure CallbackInitializeAdd(const ProcInitialize: TG2Proc);
    procedure CallbackInitializeRemove(const ProcInitialize: TG2Proc);
    procedure CallbackFinalizeAdd(const ProcFinalize: TG2Proc);
    procedure CallbackFinalizeRemove(const ProcFinalize: TG2Proc);
    procedure CallbackUpdateAdd(const ProcUpdate: TG2Proc);
    procedure CallbackUpdateRemove(const ProcUpdate: TG2Proc);
    procedure CallbackRenderAdd(const ProcRender: TG2Proc; Order: TG2Float = 0);
    procedure CallbackRenderRemove(const ProcRender: TG2Proc);
    procedure CallbackPrintAdd(const ProcPrint: TG2ProcChar);
    procedure CallbackPrintRemove(const ProcPrint: TG2ProcChar);
    procedure CallbackKeyDownAdd(const ProcKeyDown: TG2ProcKey);
    procedure CallbackKeyDownRemove(const ProcKeyDown: TG2ProcKey);
    procedure CallbackKeyUpAdd(const ProcKeyUp: TG2ProcKey);
    procedure CallbackKeyUpRemove(const ProcKeyUp: TG2ProcKey);
    procedure CallbackMouseDownAdd(const ProcMouseDown: TG2ProcMouse);
    procedure CallbackMouseDownRemove(const ProcMouseDown: TG2ProcMouse);
    procedure CallbackMouseUpAdd(const ProcMouseUp: TG2ProcMouse);
    procedure CallbackMouseUpRemove(const ProcMouseUp: TG2ProcMouse);
    procedure CallbackScrollAdd(const ProcScroll: TG2ProcScroll);
    procedure CallbackScrollRemove(const ProcScroll: TG2ProcScroll);
    procedure PicQuadCol(
      const Pos0, Pos1, Pos2, Pos3, Tex0, Tex1, Tex2, Tex3: TG2Vec2;
      const Col0, Col1, Col2, Col3: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicQuadCol(
      const x0, y0, x1, y1, x2, y2, x3, y3, tu0, tv0, tu1, tv1, tu2, tv2, tu3, tv3: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicQuad(
      const Pos0, Pos1, Pos2, Pos3, Tex0, Tex1, Tex2, Tex3: TG2Vec2;
      const Col: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicQuad(
      const x0, y0, x1, y1, x2, y2, x3, y3, tu0, tv0, tu1, tv1, tu2, tv2, tu3, tv3: TG2Float;
      const Col: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const Pos: TG2Vec2;
      const Width, Height: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Vec4;
      const TexRect: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const x, y: TG2Float;
      const Width, Height: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Vec4;
      const tu0, tv0, tu1, tv1: TG2Float;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const Pos: TG2Vec2;
      const Width, Height: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const x, y: TG2Float;
      const Width, Height: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const Pos: TG2Vec2;
      const Col0, Col1, Col2, Col3: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const x, y: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const Pos: TG2Vec2;
      const Width, Height: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Vec4;
      const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const FrameWidth, FrameHeight: Integer;
      const FrameID: Integer;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const x, y: TG2Float;
      const Width, Height: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Vec4;
      const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const FrameWidth, FrameHeight: Integer;
      const FrameID: Integer;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const Pos: TG2Vec2; const Col: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const x, y: TG2Float; const Col: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const Pos: TG2Vec2;
      const Width, Height: TG2Float;
      const Col: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const x, y: TG2Float;
      const Width, Height: TG2Float;
      const Col: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const Pos: TG2Vec2;
      const Width, Height: TG2Float;
      const TexRect: TG2Vec4;
      const Col: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const x, y: TG2Float;
      const Width, Height: TG2Float;
      const tu0, tv0, tu1, tv1: TG2Float;
      const Col: TG2Vec4;
      const Texture: TG2Texture2DBase;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const Pos: TG2Vec2;
      const Width, Height: TG2Float;
      const Col: TG2Vec4;
      const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const FrameWidth, FrameHeight: Integer;
      const FrameID: Integer;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const x, y: TG2Float;
      const Width, Height: TG2Float;
      const Col: TG2Vec4;
      const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const FrameWidth, FrameHeight: Integer;
      const FrameID: Integer;
      BlendMode: TG2BlendMode = bmNormal;
      Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PrimLineCol(const Pos0, Pos1: TG2Vec2; const Col0, Col1: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimLineCol(const x0, y0, x1, y1: TG2Float; const Col0, Col1: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimTriCol(const Pos0, Pos1, Pos2: TG2Vec2; const Col0, Col1, Col2: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimTriCol(const x0, y0, x1, y1, x2, y2: TG2Float; const Col0, Col1, Col2: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimQuadCol(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col0, Col1, Col2, Col3: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimQuadCol(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col0, Col1, Col2, Col3: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimQuad(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimQuad(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimRectCol(const x, y, w, h: TG2Float; const Col0, Col1, Col2, Col3: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
    procedure PrimRect(const x, y, w, h: TG2Float; const Col: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
    procedure PrimRectHollowCol(const x, y, w, h: TG2Float; const Col0, Col1, Col2, Col3: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
    procedure PrimRectHollow(const x, y, w, h: TG2Float; const Col: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
    procedure PrimCircleCol(const Pos: TG2Vec2; const Radius: TG2Float; const Col0, Col1: TG2Vec4; Segments: Integer = 16; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimCircleCol(const x, y, Radius: TG2Float; const Col0, Col1: TG2Vec4; Segments: Integer = 16; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimTriHollowCol(const Pos0, Pos1, Pos2: TG2Vec2; const Col0, Col1, Col2: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimTriHollowCol(const x0, y0, x1, y1, x2, y2: TG2Float; const Col0, Col1, Col2: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimQuadHollowCol(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col0, Col1, Col2, Col3: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimQuadHollowCol(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col0, Col1, Col2, Col3: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimCircleHollow(const Pos: TG2Vec2; const Radius: TG2Float; const Col: TG2Vec4; Segments: Integer = 16; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimCircleHollow(const x, y, Radius: TG2Float; const Col: TG2Vec4; Segments: Integer = 16; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimLine(const Pos0, Pos1: TG2Vec2; const Col: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimLine(const x0, y0, x1, y1: TG2Float; const Col: TG2Vec4; BlendMode: TG2BlendMode = bmNormal); overload;
    procedure PrimBegin(const PrimType: TG2Prim2DType; BlendMode: TG2BlendMode = bmNormal);
    procedure PrimAdd(const Position: TG2Vec2; const Color: TG2Vec4);
    procedure PrimEnd;
    procedure RenderPrimitive(
      const VB: TG2VertexBuffer;
      const PrimitiveType: TG2PrimitiveType;
      const VertexStart: Integer;
      const PrimitiveCount: Integer;
      const Texture: TG2Texture2DBase;
      const W, V, P: TG2Mat
    ); overload;
    procedure RenderPrimitive(
      const VB: TG2VertexBuffer;
      const IB: TG2IndexBuffer;
      const PrimitiveType: TG2PrimitiveType;
      const VertexStart: Integer;
      const VertexCount: Integer;
      const IndexStart: Integer;
      const PrimitiveCount: Integer;
      const Texture: TG2Texture2DBase;
      const W, V, P: TG2Mat
    ); overload;
  end;

  TG2TextureUsage = (
    tuDefault,
    tuUsage2D,
    tuUsage3D
  );

  TG2TextureBase = class (TG2ResourceAsync)
  protected
    _gl: JWebGLRenderingContext;
    _Usage: TG2TextureUsage;
    _Texture: JWebGLTexture;
    procedure Release; virtual;
  public
    property Usage: TG2TextureUsage read _Usage;
    property Texture: JWebGLTexture read _Texture;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TG2Texture2DBase = class (TG2TextureBase)
  private
    function GetProjection: TG2Mat;
  protected
    _RealWidth: Integer;
    _RealHeight: Integer;
    _Width: Integer;
    _Height: Integer;
    _SizeTU: TG2Float;
    _SizeTV: TG2Float;
  public
    property RealWidth: Integer read _RealWidth;
    property RealHeight: Integer read _RealHeight;
    property Width: Integer read _Width;
    property Height: Integer read _Height;
    property SizeTU: TG2Float read _SizeTU;
    property SizeTV: TG2Float read _SizeTV;
    property Projection: TG2Mat read GetProjection;
    procedure Bind(const Stage: Integer);
  end;

  TG2Texture2D = class (TG2Texture2DBase)
  private
    _Image: Variant;
    _OnLoadProc: TG2ProcObj;
    procedure OnLoad;
    procedure OnError;
  public
    property OnLoadProc: TG2ProcObj read _OnLoadProc write _OnLoadProc;
    constructor Create; override;
    procedure Load(const FileName: String; TextureUsage: TG2TextureUsage = tuDefault);
  end;

  TG2Texture2DRT = class (TG2Texture2DBase)
  private
    _FrameBuffer: JWebGLFrameBuffer;
    _RenderBuffer: JWebGLRenderbuffer;
  protected
    procedure Release; override;
  public
    property FrameBuffer: JWebGLFrameBuffer read _FrameBuffer;
    property RenderBuffer: JWebGLRenderBuffer read _RenderBuffer;
    constructor Create; override;
    function Make(const NewWidth, NewHeight: Integer): Boolean;
  end;

  TG2Texture2DVideo = class (TG2Texture2DBase)
  private
    _Video: Variant;
    _IntervalID: Variant;
    _OnFinishedProc: TG2ProcObj;
    procedure OnReadyToPlay;
    procedure OnPlayFinished;
    procedure OnUpdateTexture;
  public
    property OnFinished: TG2ProcObj read _OnFinishedProc write _OnFinishedProc;
    constructor Create; override;
    destructor Destroy; override;
    procedure Load(const FileName: String);
  end;

  TG2TextureCubeBase = class (TG2TextureBase)
  protected
    _Size: TG2Float;
  public
    property Size: TG2Float read _Size;
    procedure Bind(const Stage: Integer);
  end;

  TG2TextureCube = class (TG2TextureCubeBase)
  private
    _Image: array[0..5] of Variant;
    _OnLoadProc: TG2ProcObj;
    _ImagesLoaded: Integer;
    procedure OnLoad;
    procedure OnError;
  public
    property OnLoadProc: TG2ProcObj read _OnLoadProc write _OnLoadProc;
    constructor Create; override;
    procedure Load(
      const FileNamePosX: String;
      const FileNameNegX: String;
      const FileNamePosY: String;
      const FileNameNegY: String;
      const FileNamePosZ: String;
      const FileNameNegZ: String;
      TextureUsage: TG2TextureUsage = tuDefault
    );
  end;

  TG2FontCharProps = record
    Width: Integer;
    Height: Integer;
    OffsetX: Integer;
    OffsetY: Integer;
  end;

  TG2Font = class (TG2ResourceAsync)
  private
    _Props: array[0..255] of TG2FontCharProps;
    _CharSpaceX: Integer;
    _CharSpaceY: Integer;
    _DataManager: TG2DataManager;
    _Texture: TG2Texture2D;
    procedure OnLoadCheck;
    procedure OnLoadTexture;
    procedure OnLoadHeader;
  public
    constructor Create; override;
    destructor Destroy; override;
    function TextWidth(const Text: String): Integer;
    function TextHeight(const Text: String): Integer;
    procedure Load(const FontHeader, FontImage: String);
    procedure Print(
      const x, y, ScaleX, ScaleY: TG2Float;
      const Color: TG2Vec4;
      const Text: String;
      const BlendMode: TG2BlendMode;
      const Filter: TG2Filter
    ); overload;
    procedure Print(
      const x, y, ScaleX, ScaleY: TG2Float;
      const Text: String;
      const BlendMode: TG2BlendMode;
      const Filter: TG2Filter
    ); overload;
    procedure Print(const x, y, ScaleX, ScaleY: TG2Float; const Text: String); overload;
    procedure Print(const x, y: TG2Float; const Text: String); overload;
  end;

  TG2VBElement = (vbNone, vbPosition, vbDiffuse, vbNormal, vbTangent, vbBinormal, vbTexCoord, vbVertexWeight, vbVertexIndex);

  TG2VBVertex = record
    Element: TG2VBElement;
    Count: Integer;
  end;

  TG2VBDecl = array of TG2VBVertex;

  TG2BufferUsage = (buNone, buWriteOnly, buReadWrite);
  TG2BufferLockMode = (lmNone, lmReadOnly, lmReadWrite);

  TG2VertexBuffer = class (TG2Resource)
  private
    _gl: JWebGLRenderingContext;
    _VertexSize: Integer;
    _VertexCount: Integer;
    _Decl: TG2VBDecl;
    _VB: JWebGLBuffer;
    _LockMode: TG2BufferLockMode;
    _Locked: Boolean;
    _TexCoordIndex: array[0..31] of Integer;
    _DataBuffer: JArrayBuffer;
    _Data: JDataView;
    _BoundAttribs: TG2QuickListInt;
    _Position: Integer;
    function GetTexCoordIndex(const Index: Integer): Integer;
    procedure WriteBufferData;
  public
    property VB: JWebGLBuffer read _VB;
    property VertexCount: Integer read _VertexCount;
    property VertexSize: Integer read _VertexSize;
    property TexCoordIndex[const Index: Integer]: Integer read GetTexCoordIndex;
    property Data: JDataView read _Data;
    property Position: Integer read _Position write _Position;
    procedure Lock(LockMode: TG2BufferLockMode = lmReadWrite);
    procedure UnLock;
    procedure Bind;
    procedure Unbind;
    procedure Initialize(const Decl: TG2VBDecl; const Count: Integer);
    constructor Create; override;
    destructor Destroy; override;
    procedure WriteFloat32(const f: TG2Float);
    procedure WriteVec2(const v: TG2Vec2);
    procedure WriteVec3(const v: TG2Vec3);
    procedure WriteVec4(const v: TG2Vec4);
  end;

  TG2IndexBuffer = class (TG2Resource)
  private
    _gl: JWebGLRenderingContext;
    _IndexCount: Integer;
    _IB: JWEbGLBuffer;
    _LockMode: TG2BufferLockMode;
    _Locked: Boolean;
    _DataBuffer: JArrayBuffer;
    _Data: JDataView;
    _Position: Integer;
    procedure WriteBufferData;
  public
    property IB: JWebGLBuffer read _IB;
    property IndexCount: Integer read _IndexCount;
    property Data: JDataView read _Data;
    property Position: Integer read _Position write _Position;
    constructor Create; override;
    destructor Destroy; override;
    procedure Initialize(const Count: Integer);
    procedure Lock(LockMode: TG2BufferLockMode = lmReadWrite);
    procedure UnLock;
    procedure Bind;
    procedure Unbind;
    procedure WriteIntU16(const n: Integer);
  end;

  TG2RenderControl = class (TG2Resource)
  protected
    _gl: JWebGLRenderingContext;
  public
    constructor Create; override;
    procedure RenderStart; virtual;
    procedure RenderStop; virtual;
  end;

  TG2ShaderProgram = class (TG2Resource)
  private
    _gl: JWebGLRenderingContext;
    _ShaderProgram: JWebGLProgram;
      _VertexShader: JWebGLShader;
      _PixelShader: JWebGLShader;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Compile(const VertexShaderSource, PixelShaderSource: String);
    procedure Use;
    function GetShaderAttribute(const AttributeName: String): GLInt;
    function GetShaderUniform(const UniformName: String): JWebGLUniformLocation;
  end;

  TG2RenderControlPrim2D = class (TG2RenderControl)
  private
    _Shader: TG2ShaderProgram;
    _AttribPosition: GLInt;
    _AttribColor: GLInt;
    _UniformWVP: JWebGLUniformLocation;
    _MaxPoints: Integer;
    _ArrPositions: array of Float;
    _ArrColors: array of Float;
    _BufferPositions: JWebGLBuffer;
    _BufferColors: JWebGLBuffer;
    _CurPoint: Integer;
    _CurPrimType: TG2Prim2DType;
    _CurBlendMode: TG2BlendMode;
    procedure Flush;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure RenderStart; override;
    procedure RenderStop; override;
    procedure PrimBegin(const PrimType: TG2Prim2DType; const BlendMode: TG2BlendMode);
    procedure PrimEnd;
    procedure PrimAdd(const Position: TG2Vec2; const Color: TG2Vec4);
    procedure PrimQuadCol(
      const Pos0, Pos1, Pos2, Pos3: TG2Vec2;
      const Col0, Col1, Col2, Col3: TG2Vec4;
      const BlendMode: TG2BlendMode
    );
  end;

  TG2RenderControlPic2D = class (TG2RenderControl)
  private
    _Shader: TG2ShaderProgram;
    _AttribPosition: GLInt;
    _AttribColor: GLInt;
    _AttribTexCoord: GLInt;
    _UniformWVP: JWebGLUniformLocation;
    _UniformTex0: JWebGLUniformLocation;
    _MaxQuads: Integer;
    _ArrPositions: array of TG2Float;
    _ArrColors: array of TG2Float;
    _ArrTexCoords: array of TG2Float;
    _BufferPositions: JWebGLBuffer;
    _BufferColors: JWebGLBuffer;
    _BufferTexCoords: JWebGLBuffer;
    _BufferIndices: JWebGLBuffer;
    _CurQuad: Integer;
    _CurTexture: TG2Texture2DBase;
    _CurBlendMode: TG2BlendMode;
    procedure Flush;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure RenderStart; override;
    procedure RenderStop; override;
    procedure PicQuadCol(
      const Pos0, Pos1, Pos2, Pos3: TG2Vec2;
      const Tex0, Tex1, Tex2, Tex3: TG2Vec2;
      const Col0, Col1, Col2, Col3: TG2Vec4;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendMode;
      const Filter: TG2Filter
    );
  end;

  TG2RenderControlBuffer = class (TG2RenderControl)
  private
    _Shader: TG2ShaderProgram;
    _UniformWVP: JWebGLUniformLocation;
    _UniformTex0: JWebGLUniformLocation;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure RenderPrimitive(
      const VB: TG2VertexBuffer;
      const PrimitiveType: TG2PrimitiveType;
      const VertexStart: Integer;
      const PrimitiveCount: Integer;
      const Texture: TG2Texture2DBase;
      const W, V, P: TG2Mat
    ); overload;
    procedure RenderPrimitive(
      const VB: TG2VertexBuffer;
      const IB: TG2IndexBuffer;
      const PrimitiveType: TG2PrimitiveType;
      const VertexStart: Integer;
      const VertexCount: Integer;
      const IndexStart: Integer;
      const PrimitiveCount: Integer;
      const Texture: TG2Texture2DBase;
      const W, V, P: TG2Mat
    ); overload;
    procedure RenderStart; override;
    procedure RenderStop; override;
  end;

  TG2S3DParticleRender = class
  protected
    _Scene: TG2Scene3D;
    _gl: JWebGLRenderingContext;
  public
    constructor Create(const Scene: TG2Scene3D); virtual;
    destructor Destroy; override;
    procedure RenderBegin; virtual; abstract;
    procedure RenderEnd; virtual; abstract;
    procedure RenderParticle(const Particle: TG2S3DParticle); virtual; abstract;
  end;

  TG2S3DParticleRenderFlat = class (TG2S3DParticleRender)
  private
    _VB: TG2VertexBuffer;
    _IB: TG2IndexBuffer;
    _MaxQuads: Integer;
    _CurQuad: Integer;
    _CurTexture: TG2Texture2D;
    _CurFilter: TG2Filter;
    _CurBlendMode: TG2BlendMode;
    _Shader: TG2ShaderProgram;
    _UniformWVP: JWebGLUniformLocation;
    _UniformTex0: JWebGLUniformLocation;
    procedure RenderFlush;
  public
    constructor Create(const Scene: TG2Scene3D); override;
    destructor Destroy; override;
    procedure RenderBegin; override;
    procedure RenderEnd; override;
    procedure RenderParticle(const Particle: TG2S3DParticle); override;
  end;

  CG2S3DParticleRender = class of TG2S3DParticleRender;

  TG2S3DParticleGroup = class
  public
    AABox: TG2AABox;
    Items: TG2QuickList;
    MinSize: TG2Float;
    MaxSize: TG2Float;
  end;

  TG2S3DParticle = class
  private
    _Group: TG2S3DParticleGroup;
  protected
    _Size: TG2Float;
    _Pos: TG2Vec3;
    _DepthSorted: Boolean;
    _RenderClass: CG2S3DParticleRender;
    _ParticleRender: TG2S3DParticleRender;
    _Dead: Boolean;
    function GetAABox: TG2AABox;
  public
    property Size: TG2Float read _Size;
    property Pos: TG2Vec3 read _Pos write _Pos;
    property DepthSorted: Boolean read _DepthSorted write _DepthSorted;
    property RenderClass: CG2S3DParticleRender read _RenderClass;
    property ParticleRender: TG2S3DParticleRender read _ParticleRender write _ParticleRender;
    property Group: TG2S3DParticleGroup read _Group write _Group;
    property AABox: TG2AABox read GetAABox;
    property Dead: Boolean read _Dead;
    procedure Update; virtual; abstract;
    procedure Die;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TG2S3DParticleFlat = class (TG2S3DParticle)
  private
    _Texture: TG2Texture2D;
    _Color: TG2Vec4;
    _VecX: TG2Vec3;
    _VecY: TG2Vec3;
    _Filter: TG2Filter;
    _BlendMode: TG2BlendMode;
    procedure SetVecX(const Value: TG2Vec3);
    procedure SetVecY(const Value: TG2Vec3);
    procedure UpdateSize;
  public
    property Texture: TG2Texture2D read _Texture write _Texture;
    property Color: TG2Vec4 read _Color write _Color;
    property Filter: TG2Filter read _Filter write _Filter;
    property BlendMode: TG2BlendMode read _BlendMode write _BlendMode;
    property VecX: TG2Vec3 read _VecX write SetVecX;
    property VecY: TG2Vec3 read _VecY write SetVecY;
    procedure MakeBillboard(const View: TG2Mat; const Width, Height, Rotation: TG2Float);
    procedure MakeAxis(const View: TG2Mat; const Pos0, Pos1: TG2Vec3; const Width: TG2Float);
    procedure Update; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TG2S3DNode = class
  protected
    _Scene: TG2Scene3D;
    _Transform: TG2Mat;
    _UserData: TObject;
    procedure SetTransform(const Value: TG2Mat); virtual;
  public
    property Transform: TG2Mat read _Transform write SetTransform;
    property UserData: TObject read _UserData write _UserData;
    constructor Create(const Scene: TG2Scene3D); virtual;
    destructor Destroy; override;
  end;

  TG2S3DFrame = class (TG2S3DNode)
  protected
    function GetAABox: TG2AABox; virtual; abstract;
  public
    property AABox: TG2AABox read GetAABox;
    constructor Create(const Scene: TG2Scene3D); override;
    destructor Destroy; override;
  end;

  TG2S3DMeshNode = class
  public
    OwnerID: Integer;
    Name: String;
    Transform: TG2Mat;
    SubNodesID: array of Integer;
  end;

  TG2S3DGeomData = class
  end;

  TG2S3DGeomDataStatic = class (TG2S3DGeomData)
  public
    BBox: TG2Box;
    VB: TG2VertexBuffer;
  end;

  TG2S3DGeomDataSkinned = class (TG2S3DGeomData)
  public
    MaxWeights: Integer;
    BoneCount: Integer;
    Bones: array of record
      NodeID: Integer;
      Bind: TG2Mat;
      BBox: TG2Box;
      VCount: Integer;
    end;
    VB: TG2VertexBuffer;
  end;

  TG2S3DMeshGeom = class
  public
    NodeID: Integer;
    Decl: TG2VBDecl;
    Skinned: Boolean;
    Data: TG2S3DGeomData;
    VCount: Integer;
    FCount: Integer;
    GCount: Integer;
    TCount: Integer;
    IB: TG2IndexBuffer;
    Groups: array of record
      Material: Integer;
      VertexStart: Integer;
      VertexCount: Integer;
      FaceStart: Integer;
      FaceCount: Integer;
    end;
    Visible: Boolean;
  end;

  TG2S3DMeshAnim = class
  public
    Name: String;
    FrameRate: Integer;
    FrameCount: Integer;
    NodeCount: Integer;
    Nodes: array of record
      NodeID: Integer;
      Frames: array of record
        Scaling: TG2Vec3;
        Rotation: TG2Quat;
        Translation: TG2Vec3;
      end;
    end;
  end;

  TG2S3DMeshMaterial = class
  public
    ChannelCount: Integer;
    Channels: array of record
      Name: String;
      TwoSided: Boolean;
      MapDiffuse: TG2Texture2D;
      MapLight: TG2Texture2D;
    end;
  end;

  TG2S3DMesh = class (TG2ResourceAsync)
  private
    _DataManager: TG2DataManager;
    _Scene: TG2Scene3D;
    _Instances: TG2QuickList;
    _NodeCount: Integer;
    _GeomCount: Integer;
    _AnimCount: Integer;
    _MaterialCount: Integer;
    _Nodes: array of TG2S3DMeshNode;
    _Geoms: array of TG2S3DMeshGeom;
    _Anims: array of TG2S3DMeshAnim;
    _Materials: array of TG2S3DMeshMaterial;
    _Loaded: Boolean;
    procedure OnLoad;
    function GetNode(const Index: Integer): TG2S3DMeshNode;
    function GetGeom(const Index: Integer): TG2S3DMeshGeom;
    function GetAnim(const Index: Integer): TG2S3DMeshAnim;
    function GetMaterial(const Index: Integer): TG2S3DMeshMaterial;
    procedure Release;
  public
    property NodeCount: Integer read _NodeCount;
    property GeomCount: Integer read _GeomCount;
    property AnimCount: Integer read _AnimCount;
    property MaterialCount: Integer read _MaterialCount;
    property Nodes[const Index: Integer]: TG2S3DMeshNode read GetNode;
    property Geoms[const Index: Integer]: TG2S3DMeshGeom read GetGeom;
    property Anims[const Index: Integer]: TG2S3DMeshAnim read GetAnim;
    property Materials[const Index: Integer]: TG2S3DMeshMaterial read GetMaterial;
    constructor Create(const Scene: TG2Scene3D); overload;
    destructor Destroy; override;
    procedure Load(const FileName: String);
    procedure LoadData(const MeshData: TG2MeshData);
    function AnimIndex(const Name: String): Integer;
    function NewInst: TG2S3DMeshInst;
  end;

  TG2S3DMeshInstSkin = class
  public
    Transforms: array of TG2Mat;
  end;

  TG2S3DMeshInst = class (TG2S3DFrame)
  private
    _Mesh: TG2S3DMesh;
    _RootNodes: array of Integer;
    _Skins: array of TG2S3DMeshInstSkin;
    _AutoComputeTransforms: Boolean;
    procedure SetMesh(const Value: TG2S3DMesh);
    function GetBBox: TG2Box;
    function GetGeomBBox(const Index: Integer): TG2Box;
    function GetSkin(const Index: Integer): TG2S3DMeshInstSkin;
    procedure ComputeSkinTransforms;
  protected
    function GetAABox: TG2AABox; override;
  public
    Transforms: array of record
      TransformDef: TG2Mat;
      TransformCur: TG2Mat;
      TransformCom: TG2Mat;
    end;
    Materials: array of TG2S3DMeshMaterial;
    UserData: array of TObject;
    property Mesh: TG2S3DMesh read _Mesh write SetMesh;
    property BBox: TG2Box read GetBBox;
    property AutoComputeTransforms: Boolean read _AutoComputeTransforms write _AutoComputeTransforms;
    property GeomBBox[const Index: Integer]: TG2Box read GetGeomBBox;
    property Skins[const Index: Integer]: TG2S3DMeshInstSkin read GetSkin;
    constructor Create(const Scene: TG2Scene3D); override;
    destructor Destroy; override;
    procedure FrameSetFast(const AnimName: String; const Frame: Integer);
    procedure FrameSet(const AnimName: String; const Frame: Single);
    procedure ComputeTransforms;
  end;

  TG2S3DOcTreeNode = class
  public
    Parent: TG2S3DOcTreeNode;
    SubNodes: array of array of array of TG2S3DOcTreeNode;
    DivX, DivY, DivZ: Integer;
    AABox: TG2AABox;
    Frames: TG2QuickList;
  end;

  TG2S3DTexture = class
  public
    Name: String;
    Texture: TG2Texture2D;
  end;

  TG2Scene3D = class (TG2Resource)
  private
    _Textures: TG2QuickList;
    _Nodes: TG2QuickList;
    _Frames: TG2QuickList;
    _MeshInst: TG2QuickList;
    _Meshes: TG2QuickList;
    _Particles: TG2QuickList;
    _NewParticles: TG2QuickList;
    _ParticleGroups: TG2QuickList;
    _ParticlesSorted: TG2QuickSortList;
    _ParticleRenders: TG2QuickList;
    _Frustum: TG2Frustum;
    _OcTreeRoot: TG2S3DOcTreeNode;
    _UpdatingParticles: Boolean;
    _StatParticlesRendered: Integer;
    _Ambient: TG2Vec4;
    procedure OcTreeBuild(const MinV, MaxV: TG2Vec3; const Depth: Integer);
    procedure OcTreeBreak;
    function GetStatParticleGroupCount: Integer;
    function GetStatParticleCount: Integer;
    function GetNodeCount: Integer;
    function GetFrameCount: Integer;
    function GetMeshInstCount: Integer;
    function GetMeshCount: Integer;
    function GetNode(const Index: Integer): TG2S3DNode;
    function GetFrame(const Index: Integer): TG2S3DFrame;
    function GetMeshInst(const Index: Integer): TG2S3DMeshInst;
    function GetMesh(const Index: Integer): TG2S3DMesh;
  protected
    gl: JWebGLRenderingContext;
    ShaderB: array[0..4] of TG2ShaderProgram;
    ShaderBL: array[0..4] of TG2ShaderProgram;
    ShaderParticles: TG2ShaderProgram;
    procedure RenderParticles;
  public
    V: TG2Mat;
    P: TG2Mat;
    property Frustum: TG2Frustum read _Frustum;
    property NodeCount: Integer read GetNodeCount;
    property FrameCount: Integer read GetFrameCount;
    property MeshInstCount: Integer read GetMeshInstCount;
    property MeshCount: Integer read GetMeshCount;
    property Nodes[const Index: Integer]: TG2S3DNode read GetNode;
    property Frames[const Index: Integer]: TG2S3DFrame read GetFrame;
    property MeshInst[const Index: Integer]: TG2S3DMeshInst read GetMeshInst;
    property Meshes[const Index: Integer]: TG2S3DMesh read GetMesh;
    property Ambient: TG2Vec4 read _Ambient write _Ambient;
    property StatParticleGroupCount: Integer read GetStatParticleGroupCount;
    property StatParticleCount: Integer read GetStatParticleCount;
    property StatParticlesRendered: Integer read _StatParticlesRendered;
    procedure Update; virtual;
    procedure Render; virtual;
    procedure Build;
    procedure ParticleAdd(const Particle: TG2S3DParticle);
    function FindTexture(const TextureName: String; Usage: TG2TextureUsage = tuDefault): TG2Texture2D;
    constructor Create; override;
    destructor Destroy; override;
  end;

var g2: TG2Core;

procedure G2TypedArrayCopy(const Src, Dst: JTypedArray; const SrcStart, DstStart, Size: Integer);
function G2NewVariant: Variant;

implementation

//TG2Gfx BEGIN
procedure TG2Gfx.SetBlendMode(const Value: TG2BlendMode);
begin
  if Value <> _BlendMode then
  begin
    _BlendMode := Value;
    if (_BlendMode = bmDisable) = _BlendEnable then
    begin
      _BlendEnable := not _BlendEnable;
      if _BlendEnable then
      gl.enable(gl.BLEND)
      else
      gl.disable(gl.BLEND);
    end;
    case _BlendMode of
      bmDisable:
      begin
        gl.blendFunc(gl.ONE, gl.ZERO);
      end;
      bmNormal:
      begin
        gl.blendFuncSeparate(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA, gl.ONE, gl.ONE);
      end;
      bmAdd:
      begin
        gl.blendFuncSeparate(gl.ONE, gl.ONE, gl.ONE, gl.ONE);
      end;
      bmSub:
      begin
        gl.blendFuncSeparate(gl.ZERO, gl.ONE_MINUS_SRC_COLOR, gl.ZERO, gl.ONE_MINUS_SRC_ALPHA);
      end;
      bmMul:
      begin
        gl.blendFuncSeparate(gl.ZERO, gl.SRC_COLOR, gl.ONE, gl.SRC_ALPHA);
      end;
    end;
  end;
end;

procedure TG2Gfx.SetRenderTarget(const Value: TG2Texture2DRT);
begin
  if _RenderTarget <> Value then
  begin
    g2.RenderControl := nil;
    if _RenderTarget <> nil then
    begin
      gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, nil, 0);
      gl.bindFramebuffer(gl.FRAMEBUFFER, nil);
    end;
    _RenderTarget := Value;
    if _RenderTarget = nil then
    begin
      SetDefaults;
    end
    else
    begin
      gl.bindFramebuffer(gl.FRAMEBUFFER, _RenderTarget.FrameBuffer);
      gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, _RenderTarget.Texture, 0);
      SetDefaults;
    end;
  end;
end;

procedure TG2Gfx.SetDepthEnable(const Value: Boolean);
begin
  if Value = _DepthEnable then Exit;
  _DepthEnable := Value;
  if _DepthEnable then
  gl.Enable(gl.DEPTH_TEST)
  else
  gl.Disable(gl.DEPTH_TEST);
end;

procedure TG2Gfx.SetDepthWriteEnable(const Value: Boolean);
begin
  if Value = _DepthWriteEnable then Exit;
  _DepthWriteEnable := Value;
  gl.DepthMask(_DepthWriteEnable);
end;

constructor TG2Gfx.Create(const Handle: THandle);
  var Properties: Variant;
begin
  _Handle := Handle;
  Properties := G2NewVariant;
  Properties.antialias := False;
  gl := JWebGLRenderingContext(Handle.getContext('experimental-webgl', Properties));
  _RenderTarget := nil;
  _DepthEnable := False;
  _DepthWriteEnable := True;
  SetDefaults;
end;

destructor TG2Gfx.Destroy;
begin
  inherited Destroy;
end;

procedure TG2Gfx.SetDefaults;
begin
  if _RenderTarget = nil then
  gl.ViewportSet(0, 0, g2.Params.Width, g2.Params.Height)
  else
  gl.ViewportSet(0, 0, _RenderTarget.Width, _RenderTarget.Height);
  gl.clearColor(1.0, 1.0, 1.0, 1.0);
  gl.ClearDepth(1);
  gl.CullFace(gl.FRONT);
  gl.Disable(gl.CULL_FACE);
  _BlendMode := bmInvalid;
  _BlendEnable := False;
  BlendMode := bmDisable;
end;
//TG2Gfx END

//TG2Params BEGIN
function TG2Params.GetWidth: Integer;
begin
  Result := g2.Width;
end;

procedure TG2Params.SetWidth(const Value: Integer);
begin
  g2.Width := Value;
end;

function TG2Params.GetHeight: Integer;
begin
  Result := g2.Height;
end;

procedure TG2Params.SetHeight(const Value: Integer);
begin
  g2.Height := Value;
end;
//TG2Params END

//TG2LocalStorage BEGIN
function TG2LocalStorage.GetKey(const Key: String): String;
begin
  asm
    @Result = window.localStorage.getItem(@Key);
    if (@Result == null) @Result = "";
  end;
end;

procedure TG2LocalStorage.SetKey(const Key, Value: String);
begin
  asm
    window.localStorage.setItem(@Key, @Value);
  end;
end;
//TG2LocalStorage END

//TG2Core BEGIN
function G2CompareProc(f0, f1: TG2Proc): Boolean;
begin
  asm
    (@Result) = (@f0) == (@f1);
  end;
end;

function G2CompareProcChar(f0, f1: TG2ProcChar): Boolean;
begin
  asm
    (@Result) = (@f0) == (@f1);
  end;
end;

function G2CompareProcKey(f0, f1: TG2ProcKey): Boolean;
begin
  asm
    (@Result) = (@f0) == (@f1);
  end;
end;

function G2CompareProcMouse(f0, f1: TG2ProcMouse): Boolean;
begin
  asm
    (@Result) = (@f0) == (@f1);
  end;
end;

function G2CompareProcScroll(f0, f1: TG2ProcScroll): Boolean;
begin
  asm
    (@Result) = (@f0) == (@f1);
  end;
end;

procedure TG2Core.ClearLinks(var List: TG2Link);
  var Link: TG2Link;
begin
  while List <> nil do
  begin
    Link := List;
    List := List.Next;
    Link.Free;    
  end;
end;

procedure TG2Core.Initialize;
  var t, WndWidth, WndHeight: Integer;
  var h: THandle;
  var Link: TG2LinkProc;
begin
  t := G2Time;
  _Body := TDocumentBody.Create(nil);
  _Body.Handle.style.textAlign := 'center';
  asm
    @WndWidth = window.innerWidth;
    @WndHeight = window.innerHeight;
  end;
  _Canvas := TW3GraphicContext.Create(_Body.Handle);
  _Canvas.Handle.width := WndWidth;
  _Canvas.Handle.height := WndHeight;
  _Params := TG2Params.Create;
  h := _Body.Handle;
  h.onmousemove := @OnMouseMove;
  h.onmouseup := @OnMouseUp;
  h := _Canvas.Handle;
  h.onmousedown := @OnMouseDown;
  w3_AddEvent(h, 'mousewheel', OnScroll, false);
  _TargetUPS := 60;
  _TotalFrames := 0;
  _FPS := 0;
  _LastFPSUpdate := t;
  _LastTick := t;
  _TimeToUpdate := 0;
  _TimerPause := False;
  _TimerEnable := True;
  _Gfx := TG2Gfx.Create(_Canvas.Handle);
  _LocalStorage := TG2LocalStorage.Create;
  _RenderControl := nil;
  _RenderControlPrim2D := TG2RenderControlPrim2D.Create;
  _RenderControlPic2D := TG2RenderControlPic2D.Create;
  _RenderControlBuffer := TG2RenderControlBuffer.Create;
  asm
    window.RequestAnimFrame = (
      function() {
        return (
          window.requestAnimationFrame ||
          window.webkitRequestAnimationFrame ||
          window.mozRequestAnimationFrame ||
          window.oRequestAnimationFrame ||
          window.msRequestAnimationFrame ||
          function(callback){
            window.setTimeout(callback, 1000 / 60);
          }
        );
      }
    )();
  end;
  OnTimer;
  Link := _LinkInitialize;
  while Link <> nil do
  begin
    Link.Proc();
    Link := TG2LinkProc(Link.Next);
  end;
end;

procedure TG2Core.Finalize;
  var Link: TG2LinkProc;
begin
  Link := _LinkFinalize;
  while Link <> nil do
  begin
    Link.Proc();
    Link := TG2LinkProc(Link.Next);
  end;
end;

function TG2Core.GetWidth: Integer;
begin
  Result := _Canvas.Handle.width;
end;

procedure TG2Core.SetWidth(const Value: Integer);
begin
  _Canvas.Handle.width := Value;
end;

function TG2Core.GetHeight: Integer;
begin
  Result := _Canvas.Handle.height;
end;

procedure TG2Core.SetHeight(const Value: Integer);
begin
  _Canvas.Handle.height := Value;
end;

procedure TG2Core.OnTimer;
  var i, t, UpdateTime, UpdateCount: Integer;
begin
  if _TimerEnable then
  begin
    t := G2Time;
    if not _TimerPause then _TimeToUpdate := t - _LastTick;
    _LastTick := t;
    UpdateTime := Trunc(1000 / _TargetUPS);
    UpdateCount := Trunc(_TimeToUpdate / UpdateTime);
    if UpdateCount > 2 then UpdateCount := 2;
    for i := 0 to UpdateCount - 1 do OnUpdate;
    _TimeToUpdate := _TimeToUpdate - UpdateCount * UpdateTime;
    if t - _LastFPSUpdate >= 2000 then
    begin
      _LastFPSUpdate := t;
      _FPS := Trunc(_TotalFrames * 0.5);
      _TotalFrames := 0;
    end;
    OnRender;
    _TotalFrames := _TotalFrames + 1;
    var RenderCallback := @OnTimer;
    asm
      window.RequestAnimFrame(@RenderCallback);
    end;
  end;
end;

procedure TG2Core.OnUpdate;
  var Link: TG2LinkProc;
begin
  Link := _LinkUpdate;
  while Link <> nil do
  begin
    Link.Proc();
    Link := TG2LinkProc(Link.Next);
  end;
end;

procedure TG2Core.OnRender;
  var Link: TG2LinkRender;
begin
  g2.Gfx.gl.clearColor(g2.ClearColor.x, g2.ClearColor.y, g2.ClearColor.z, g2.ClearColor.w);
  g2.Gfx.gl.clearDepth(1);
  g2.Gfx.gl.clear(g2.Gfx.gl.COLOR_BUFFER_BIT or g2.Gfx.gl.DEPTH_BUFFER_BIT);
  Link := _LinkRender;
  while Link <> nil do
  begin
    Link.Proc();
    Link := TG2LinkRender(Link.Next);
  end;
  g2.RenderControl := nil;
  g2.Gfx.RenderTarget := nil;
end;

procedure TG2Core.OnMouseMove(const e: Variant);
  var ox, oy: Integer;
  var o: Variant;
  //var Link: TG2LinkMouse;
begin
  _MousePos.x := e.clientX;
  _MousePos.y := e.clientY;
  ox := 0;
  oy := 0;
  o := _Canvas.Handle;
  repeat
    ox := ox + o.offsetLeft;
    oy := oy + o.offsetTop;
    o := o.offsetParent;
  until (o = null);
  _MousePos.x := _MousePos.x - ox;
  _MousePos.y := _MousePos.y - oy;
  //Link := _LinkMouseMove;
  //while Link <> nil do
  //begin
  //  Link.Proc(_MousePos.x, _MousePos.y);
  //  Link := TG2LinkMouse(Link.Next);
  //end;
  //MouseMove(_MousePos.x, _MousePos.y);
end;

procedure TG2Core.OnMouseDown(const e: Variant);
  var Button: Integer;
  var Link: TG2LinkMouse;
begin
  case e.button of
    2: Button := G2MB_Right;
    4: Button := G2MB_Middle;
    else Button := G2MB_Left;
  end;
  Link := _LinkMouseDown;
  while Link <> nil do
  begin
    Link.Proc(Button, _MousePos.x, _MousePos.y);
    Link := TG2LinkMouse(Link.Next);
  end;
  //MouseDown(Button, _MousePos.x, _MousePos.y);
end;

procedure TG2Core.OnMouseUp(const e: Variant);
  var Button: Integer;
  var Link: TG2LinkMouse;
begin
  case e.button of
    2: Button := G2MB_Right;
    4: Button := G2MB_Middle;
    else Button := G2MB_Left;
  end;
  Link := _LinkMouseUp;
  while Link <> nil do
  begin
    Link.Proc(Button, _MousePos.x, _MousePos.y);
    Link := TG2LinkMouse(Link.Next);
  end;
  //MouseUp(Button, _MousePos.x, _MousePos.y);
end;

procedure TG2Core.OnScroll;
  var Shift: Integer;
  var Link: TG2LinkScroll;
begin
  asm
    @Shift = event.detail ? event.detail * -1 : event.wheelDelta / 40;
  end;
  Link := _LinkScroll;
  while Link <> nil do
  begin
    Link.Proc(Shift);
    Link := TG2LinkScroll(Link.Next);
  end;
  //MouseWheel(Shift);
end;

procedure TG2Core.SetRenderControl(const Value: TG2RenderControl);
begin
  if Value = _RenderControl then Exit;
  if _RenderControl <> nil then
  _RenderControl.RenderStop;
  _RenderControl := Value;
  if _RenderControl <> nil then
  _RenderControl.RenderStart;
end;

function TG2Core.GetDeltaTime: TG2Float;
begin
  Result := 1000 / TargetUPS;
end;

constructor TG2Core.Create;
begin
  inherited Create;
  _Gfx := nil;
  _Params := nil;
  _ClearColor.SetValue(0.5, 0.5, 0.5, 1);
  _LinkInitialize := nil;
  _LinkFinalize := nil;
  _LinkUpdate := nil;
  _LinkRender := nil;
  _LinkPrint := nil;
  _LinkKeyDown := nil;
  _LinkKeyUp := nil;
  _LinkMouseDown := nil;
  _LinkMouseUp := nil;
  _LinkScroll := nil;
end;

destructor TG2Core.Destroy;
  var List: TG2Link;
begin
  List := _LinkInitialize; ClearLinks(List);
  List := _LinkFinalize; ClearLinks(List);
  List := _LinkUpdate; ClearLinks(List);
  List := _LinkRender; ClearLinks(List);
  List := _LinkPrint; ClearLinks(List);
  List := _LinkKeyDown; ClearLinks(List);
  List := _LinkKeyUp; ClearLinks(List);
  List := _LinkMouseDown; ClearLinks(List);
  List := _LinkMouseUp; ClearLinks(List);
  List := _LinkScroll; ClearLinks(List);
  if _Params <> nil then
  begin
    _Params.Free;
    _Params := nil;
  end;
  if _Gfx <> nil then
  begin
    _Gfx.Free;
    _Gfx := nil;
  end;
  inherited Destroy;
end;

procedure TG2Core.Start;
begin
  g2.Initialize;
end;

procedure TG2Core.Stop;
begin
  g2.Finalize;
end;

procedure TG2Core.CallbackInitializeAdd(const ProcInitialize: TG2Proc);
  var Link: TG2LinkProc;
begin
  Link := TG2LinkProc.Create;
  Link.Proc := ProcInitialize;
  if _LinkInitialize <> nil then _LinkInitialize.Prev := Link;
  Link.Prev := nil;
  Link.Next := _LinkInitialize;
  _LinkInitialize := Link;
end;

procedure TG2Core.CallbackInitializeRemove(const ProcInitialize: TG2Proc);
  var Link: TG2LinkProc;
begin
  Link := _LinkInitialize;
  while Link <> nil do
  begin
    if G2CompareProc(@Link.Proc, @ProcInitialize) then
    begin
      if Link.Next <> nil then Link.Next.Prev := Link.Prev;
      if Link.Prev <> nil then Link.Prev.Next := Link.Next;
      if _LinkInitialize = Link then _LinkInitialize := TG2LinkProc(Link.Next);
      Link.Free;
      Exit;
    end
    else
    Link := TG2LinkProc(Link.Next);
  end;
end;

procedure TG2Core.CallbackFinalizeAdd(const ProcFinalize: TG2Proc);
  var Link: TG2LinkProc;
begin
  Link := TG2LinkProc.Create;
  Link.Proc := ProcFinalize;
  if _LinkFinalize <> nil then _LinkFinalize.Prev := Link;
  Link.Prev := nil;
  Link.Next := _LinkFinalize;
  _LinkFinalize := Link;
end;

procedure TG2Core.CallbackFinalizeRemove(const ProcFinalize: TG2Proc);
  var Link: TG2LinkProc;
begin
  Link := _LinkFinalize;
  while Link <> nil do
  begin
    if G2CompareProc(@Link.Proc, @ProcFinalize) then
    begin
      if Link.Next <> nil then Link.Next.Prev := Link.Prev;
      if Link.Prev <> nil then Link.Prev.Next := Link.Next;
      if _LinkFinalize = Link then _LinkFinalize := TG2LinkProc(Link.Next);
      Link.Free;
      Exit;
    end
    else
    Link := TG2LinkProc(Link.Next);
  end;
end;

procedure TG2Core.CallbackUpdateAdd(const ProcUpdate: TG2Proc);
  var Link: TG2LinkProc;
begin
  Link := TG2LinkProc.Create;
  Link.Proc := ProcUpdate;
  if _LinkUpdate <> nil then _LinkUpdate.Prev := Link;
  Link.Prev := nil;
  Link.Next := _LinkUpdate;
  _LinkUpdate := Link;
end;

procedure TG2Core.CallbackUpdateRemove(const ProcUpdate: TG2Proc);
  var Link: TG2LinkProc;
begin
  Link := _LinkUpdate;
  while Link <> nil do
  begin
    if G2CompareProc(@Link.Proc, @ProcUpdate) then
    begin
      if Link.Next <> nil then Link.Next.Prev := Link.Prev;
      if Link.Prev <> nil then Link.Prev.Next := Link.Next;
      if _LinkUpdate = Link then _LinkUpdate := TG2LinkProc(Link.Next);
      Link.Free;
      Exit;
    end
    else
    Link := TG2LinkProc(Link.Next);
  end;
end;

procedure TG2Core.CallbackRenderAdd(const ProcRender: TG2Proc; Order: TG2Float);
  var Link, List: TG2LinkRender;
begin
  Link := TG2LinkRender.Create;
  Link.Proc := ProcRender;
  Link.Order := Order;
  Link.Prev := nil;
  Link.Next := nil;
  if _LinkRender = nil then
  _LinkRender := Link
  else
  begin
    List := _LinkRender;
    while List <> nil do
    begin
      if (List.Order >= Link.Order) then
      begin
        Link.Next := List;
        Link.Prev := List.Prev;
        if List.Prev <> nil then List.Prev.Next := Link;
        List.Prev := Link;
        if List = _LinkRender then
        _LinkRender := Link;
        Exit;
      end
      else if List.Next = nil then
      begin
        List.Next := Link;
        Link.Prev := List;
        Exit;
      end
      else
      List := TG2LinkRender(List.Next);
    end;
  end;
end;

procedure TG2Core.CallbackRenderRemove(const ProcRender: TG2Proc);
  var Link: TG2LinkRender;
begin
  Link := _LinkRender;
  while Link <> nil do
  begin
    if G2CompareProc(@Link.Proc, @ProcRender) then
    begin
      if Link.Next <> nil then Link.Next.Prev := Link.Prev;
      if Link.Prev <> nil then Link.Prev.Next := Link.Next;
      if _LinkRender = Link then _LinkRender := TG2LinkRender(Link.Next);
      Link.Free;
      Exit;
    end
    else
    Link := TG2LinkRender(Link.Next);
  end;
end;

procedure TG2Core.CallbackPrintAdd(const ProcPrint: TG2ProcChar);
  var Link: TG2LinkPrint;
begin
  Link := TG2LinkPrint.Create;
  Link.Proc := ProcPrint;
  if _LinkPrint <> nil then _LinkPrint.Prev := Link;
  Link.Prev := nil;
  Link.Next := _LinkPrint;
  _LinkPrint := Link;
end;

procedure TG2Core.CallbackPrintRemove(const ProcPrint: TG2ProcChar);
  var Link: TG2LinkPrint;
begin
  Link := _LinkPrint;
  while Link <> nil do
  begin
    if G2CompareProcChar(@Link.Proc, ProcPrint) then
    begin
      if Link.Next <> nil then Link.Next.Prev := Link.Prev;
      if Link.Prev <> nil then Link.Prev.Next := Link.Next;
      if _LinkPrint = Link then _LinkPrint := TG2LinkPrint(Link.Next);
      Link.Free;
      Exit;
    end
    else
    Link := TG2LinkPrint(Link.Next);
  end;
end;

procedure TG2Core.CallbackKeyDownAdd(const ProcKeyDown: TG2ProcKey);
  var Link: TG2LinkKey;
begin
  Link := TG2LinkKey.Create;
  Link.Proc := ProcKeyDown;
  if _LinkKeyDown <> nil then _LinkKeyDown.Prev := Link;
  Link.Prev := nil;
  Link.Next := _LinkKeyDown;
  _LinkKeyDown := Link;
end;

procedure TG2Core.CallbackKeyDownRemove(const ProcKeyDown: TG2ProcKey);
  var Link: TG2LinkKey;
begin
  Link := _LinkKeyDown;
  while Link <> nil do
  begin
    if G2CompareProcKey(@Link.Proc, @ProcKeyDown) then
    begin
      if Link.Next <> nil then Link.Next.Prev := Link.Prev;
      if Link.Prev <> nil then Link.Prev.Next := Link.Next;
      if _LinkKeyDown = Link then _LinkKeyDown := TG2LinkKey(Link.Next);
      Link.Free;
      Exit;
    end
    else
    Link := TG2LinkKey(Link.Next);
  end;
end;

procedure TG2Core.CallbackKeyUpAdd(const ProcKeyUp: TG2ProcKey);
  var Link: TG2LinkKey;
begin
  Link := TG2LinkKey.Create;
  Link.Proc := ProcKeyUp;
  if _LinkKeyUp <> nil then _LinkKeyUp.Prev := Link;
  Link.Prev := nil;
  Link.Next := _LinkKeyUp;
  _LinkKeyUp := Link;
end;

procedure TG2Core.CallbackKeyUpRemove(const ProcKeyUp: TG2ProcKey);
  var Link: TG2LinkKey;
begin
  Link := _LinkKeyUp;
  while Link <> nil do
  begin
    if G2CompareProcKey(@Link.Proc, @ProcKeyUp) then
    begin
      if Link.Next <> nil then Link.Next.Prev := Link.Prev;
      if Link.Prev <> nil then Link.Prev.Next := Link.Next;
      if _LinkKeyUp = Link then _LinkKeyUp := TG2LinkKey(Link.Next);
      Link.Free;
      Exit;
    end
    else
    Link := TG2LinkKey(Link.Next);
  end;
end;

procedure TG2Core.CallbackMouseDownAdd(const ProcMouseDown: TG2ProcMouse);
  var Link: TG2LinkMouse;
begin
  Link := TG2LinkMouse.Create;
  Link.Proc := ProcMouseDown;
  if _LinkMouseDown <> nil then _LinkMouseDown.Prev := Link;
  Link.Prev := nil;
  Link.Next := _LinkMouseDown;
  _LinkMouseDown := Link;
end;

procedure TG2Core.CallbackMouseDownRemove(const ProcMouseDown: TG2ProcMouse);
  var Link: TG2LinkMouse;
begin
  Link := _LinkMouseDown;
  while Link <> nil do
  begin
    if G2CompareProcMouse(@Link.Proc, @ProcMouseDown) then
    begin
      if Link.Next <> nil then Link.Next.Prev := Link.Prev;
      if Link.Prev <> nil then Link.Prev.Next := Link.Next;
      if _LinkMouseDown = Link then _LinkMouseDown := TG2LinkMouse(Link.Next);
      Link.Free;
      Exit;
    end
    else
    Link := TG2LinkMouse(Link.Next);
  end;
end;

procedure TG2Core.CallbackMouseUpAdd(const ProcMouseUp: TG2ProcMouse);
  var Link: TG2LinkMouse;
begin
  Link := TG2LinkMouse.Create;
  Link.Proc := ProcMouseUp;
  if _LinkMouseUp <> nil then _LinkMouseUp.Prev := Link;
  Link.Prev := nil;
  Link.Next := _LinkMouseUp;
  _LinkMouseUp := Link;
end;

procedure TG2Core.CallbackMouseUpRemove(const ProcMouseUp: TG2ProcMouse);
  var Link: TG2LinkMouse;
begin
  Link := _LinkMouseUp;
  while Link <> nil do
  begin
    if G2CompareProcMouse(@Link.Proc, @ProcMouseUp) then
    begin
      if Link.Next <> nil then Link.Next.Prev := Link.Prev;
      if Link.Prev <> nil then Link.Prev.Next := Link.Next;
      if _LinkMouseUp = Link then _LinkMouseUp := TG2LinkMouse(Link.Next);
      Link.Free;
      Exit;
    end
    else
    Link := TG2LinkMouse(Link.Next);
  end;
end;

procedure TG2Core.CallbackScrollAdd(const ProcScroll: TG2ProcScroll);
  var Link: TG2LinkScroll;
begin
  Link := TG2LinkScroll.Create;
  Link.Proc := ProcScroll;
  if _LinkScroll <> nil then _LinkScroll.Prev := Link;
  Link.Prev := nil;
  Link.Next := _LinkScroll;
  _LinkScroll := Link;
end;

procedure TG2Core.CallbackScrollRemove(const ProcScroll: TG2ProcScroll);
  var Link: TG2LinkScroll;
begin
  Link := _LinkScroll;
  while Link <> nil do
  begin
    if G2CompareProcScroll(@Link.Proc, ProcScroll) then
    begin
      if Link.Next <> nil then Link.Next.Prev := Link.Prev;
      if Link.Prev <> nil then Link.Prev.Next := Link.Next;
      if _LinkScroll = Link then _LinkScroll := TG2LinkScroll(Link.Next);
      Link.Free;
      Exit;
    end
    else
    Link := TG2LinkScroll(Link.Next);
  end;
end;

procedure TG2Core.PicQuadCol(
  const Pos0, Pos1, Pos2, Pos3, Tex0, Tex1, Tex2, Tex3: TG2Vec2;
  const Col0, Col1, Col2, Col3: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  RenderControl := _RenderControlPic2D;
  _RenderControlPic2D.PicQuadCol(
    Pos0, Pos1, Pos2, Pos3,
    Tex0, Tex1, Tex2, Tex3,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicQuadCol(
  const x0, y0, x1, y1, x2, y2, x3, y3, tu0, tv0, tu1, tv1, tu2, tv2, tu3, tv3: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  RenderControl := _RenderControlPic2D;
  _RenderControlPic2D.PicQuadCol(
    G2Vec2(x0, y0), G2Vec2(x1, y1), G2Vec2(x2, y2), G2Vec2(x3, y3),
    G2Vec2(tu0, tv0), G2Vec2(tu1, tv1), G2Vec2(tu2, tv2), G2Vec2(tu3, tv3),
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicQuad(
  const Pos0, Pos1, Pos2, Pos3, Tex0, Tex1, Tex2, Tex3: TG2Vec2;
  const Col: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicQuadCol(
    Pos0, Pos1, Pos2, Pos3,
    Tex0, Tex1, Tex2, Tex3,
    Col, Col, Col, Col,
    Texture, BlendMode,
    Filtering
  );
end;

procedure TG2Core.PicQuad(
  const x0, y0, x1, y1, x2, y2, x3, y3, tu0, tv0, tu1, tv1, tu2, tv2, tu3, tv3: TG2Float;
  const Col: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicQuadCol(
    x0, y0, x1, y1, x2, y2, x3, y3,
    tu0, tv0, tu1, tv1, tu2, tv2, tu3, tv3,
    Col, Col, Col, Col,
    Texture, BlendMode,
    Filtering
  );
end;

procedure TG2Core.PicRectCol(
  const Pos: TG2Vec2;
  const Width, Height: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Vec4;
  const TexRect: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    Pos.x, Pos.y, Width, Height,
    Col0, Col1, Col2, Col3,
    TexRect.x, TexRect.y, TexRect.z, TexRect.w,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicRectCol(
  const x, y: TG2Float;
  const Width, Height: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Vec4;
  const tu0, tv0, tu1, tv1: TG2Float;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
  var x0, y0, x1, y1: TG2Float;
begin
  x0 := x; y0 := y;
  x1 := x0 + Width;
  y1 := y0 + Height;
  PicQuadCol(
    x0, y0, x1, y0, x0, y1, x1, y1,
    tu0, tv0, tu1, tv0, tu0, tv1, tu1, tv1,
    Col0, Col1, Col2, Col3,
    Texture,
    BlendMode,
    Filtering
  );
end;

procedure TG2Core.PicRectCol(
  const Pos: TG2Vec2;
  const Width, Height: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    Pos.x, Pos.y, Width, Height,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicRectCol(
  const x, y: TG2Float;
  const Width, Height: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    x, y, Width, Height,
    Col0, Col1, Col2, Col3,
    0, 0, Texture.SizeTU, Texture.SizeTV,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicRectCol(
  const Pos: TG2Vec2;
  const Col0, Col1, Col2, Col3: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    Pos.x, Pos.y, Texture.Width, Texture.Height,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicRectCol(
  const x, y: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    x, y, Texture.Width, Texture.Height,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicRectCol(
  const Pos: TG2Vec2;
  const Width, Height: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Vec4;
  const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const FrameWidth, FrameHeight: Integer;
  const FrameID: Integer;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    Pos.x, Pos.y, Width, Height,
    Col0, Col1, Col2, Col3,
    CenterX, CenterY, ScaleX, ScaleY, Rotation,
    FlipU, FlipV, Texture,
    FrameWidth, FrameHeight, FrameID,
    BlendMode, Filtering
  );
end;

procedure TG2Core.PicRectCol(
  const x, y: TG2Float;
  const Width, Height: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Vec4;
  const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const FrameWidth, FrameHeight: Integer;
  const FrameID: Integer;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
  var Pts: array[0..3] of TG2Vec2;
  var w, h: TG2Float;
  var mr: TG2Mat;
  var pc, py, px: Integer;
  var tu, tv: TG2Float;
  var tr0, tr1, tc0, tc1, tc2, tc3: TG2Vec2;
begin
  mr := G2MatRotationZ(Rotation);
  w := Width * ScaleX; h := Height * ScaleY;
  Pts[0].SetValue(-w * CenterX, -h * CenterY);
  Pts[1].SetValue(Pts[0].x + w, Pts[0].y);
  Pts[2].SetValue(Pts[0].x, Pts[0].y + h);
  Pts[3].SetValue(Pts[0].x + w, Pts[0].y + h);
  Pts[0] := G2Vec2MatMul3x3(Pts[0], mr);
  Pts[1] := G2Vec2MatMul3x3(Pts[1], mr);
  Pts[2] := G2Vec2MatMul3x3(Pts[2], mr);
  Pts[3] := G2Vec2MatMul3x3(Pts[3], mr);
  Pts[0].x := Pts[0].x + x; Pts[0].y := Pts[0].y + y;
  Pts[1].x := Pts[1].x + x; Pts[1].y := Pts[1].y + y;
  Pts[2].x := Pts[2].x + x; Pts[2].y := Pts[2].y + y;
  Pts[3].x := Pts[3].x + x; Pts[3].y := Pts[3].y + y;
  tu := (FrameWidth / Texture.Width) * Texture.SizeTU;
  tv := (FrameHeight / Texture.Height) * Texture.SizeTV;
  pc := Texture.Width div FrameWidth;
  px := FrameID mod pc;
  py := FrameID div pc;
  tr0.SetValue(px * tu, py * tv);
  tr1.SetValue(px * tu + tu, py * tv + tv);
  if FlipU then
  begin
    tc0.x := tr1.x; tc1.x := tr0.x;
    tc2.x := tr1.x; tc3.x := tr0.x;
  end
  else
  begin
    tc0.x := tr0.x; tc1.x := tr1.x;
    tc2.x := tr0.x; tc3.x := tr1.x;
  end;
  if FlipV then
  begin
    tc0.y := tr1.y; tc2.y := tr0.y;
    tc1.y := tr1.y; tc3.y := tr0.y;
  end
  else
  begin
    tc0.y := tr0.y; tc2.y := tr1.y;
    tc1.y := tr0.y; tc3.y := tr1.y;
  end;
  RenderControl := _RenderControlPic2D;
  _RenderControlPic2D.PicQuadCol(
    Pts[0], Pts[1], Pts[2], Pts[3],
    tc0, tc1, tc2, tc3,
    Col0, Col1, Col2, Col3,
    Texture,
    BlendMode,
    Filtering
  );
end;

procedure TG2Core.PicRect(
  const Pos: TG2Vec2; const Col: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    Pos.x, Pos.y,
    Col, Col, Col, Col,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicRect(
  const x, y: TG2Float; const Col: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    x, y,
    Col, Col, Col, Col,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicRect(
  const Pos: TG2Vec2;
  const Width, Height: TG2Float;
  const Col: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    Pos, Width, Height,
    Col, Col, Col, Col,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicRect(
  const x, y: TG2Float;
  const Width, Height: TG2Float;
  const Col: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    x, y, Width, Height,
    Col, Col, Col, Col,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicRect(
  const Pos: TG2Vec2;
  const Width, Height: TG2Float;
  const TexRect: TG2Vec4;
  const Col: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    Pos, Width, Height,
    Col, Col, Col, Col,
    TexRect,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicRect(
  const x, y: TG2Float;
  const Width, Height: TG2Float;
  const tu0, tv0, tu1, tv1: TG2Float;
  const Col: TG2Vec4;
  const Texture: TG2Texture2DBase;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    x, y, Width, Height,
    Col, Col, Col, Col,
    tu0, tv0, tu1, tv1,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicRect(
  const Pos: TG2Vec2;
  const Width, Height: TG2Float;
  const Col: TG2Vec4;
  const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const FrameWidth, FrameHeight: Integer;
  const FrameID: Integer;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    Pos, Width, Height,
    Col, Col, Col, Col,
    CenterX, CenterY, ScaleX, ScaleY, Rotation, FlipU, FlipV,
    Texture, FrameWidth, FrameHeight, FrameID,
    BlendMode, Filtering
  );
end;

procedure TG2Core.PicRect(
  const x, y: TG2Float;
  const Width, Height: TG2Float;
  const Col: TG2Vec4;
  const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const FrameWidth, FrameHeight: Integer;
  const FrameID: Integer;
  BlendMode: TG2BlendMode = bmNormal;
  Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    x, y, Width, Height,
    Col, Col, Col, Col,
    CenterX, CenterY, ScaleX, ScaleY, Rotation, FlipU, FlipV,
    Texture, FrameWidth, FrameHeight, FrameID,
    BlendMode, Filtering
  );
end;

//procedure TG2Core.PrimQuadCol(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col0, Col1, Col2, Col3: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
//begin
//  RenderControl := _RenderControlPrim2D;
//  _RenderControlPrim2D.PrimQuadCol(
//    Pos0, Pos1, Pos2, Pos3,
//    Col0, Col1, Col2, Col3,
//    BlendMode
//  );
//end;

procedure TG2Core.PrimLineCol(const Pos0, Pos1: TG2Vec2; const Col0, Col1: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  RenderControl := _RenderControlPrim2D;
  _RenderControlPrim2D.PrimBegin(ptLines, BlendMode);
  _RenderControlPrim2D.PrimAdd(Pos0, Col0);
  _RenderControlPrim2D.PrimAdd(Pos1, Col1);
  _RenderControlPrim2D.PrimEnd;
end;

procedure TG2Core.PrimLineCol(const x0, y0, x1, y1: TG2Float; const Col0, Col1: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  RenderControl := _RenderControlPrim2D;
  _RenderControlPrim2D.PrimBegin(ptLines, BlendMode);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x0, y0), Col0);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x1, y1), Col1);
  _RenderControlPrim2D.PrimEnd;
end;

procedure TG2Core.PrimTriCol(const Pos0, Pos1, Pos2: TG2Vec2; const Col0, Col1, Col2: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  RenderControl := _RenderControlPrim2D;
  _RenderControlPrim2D.PrimBegin(ptTriangles, BlendMode);
  _RenderControlPrim2D.PrimAdd(Pos0, Col0);
  _RenderControlPrim2D.PrimAdd(Pos1, Col1);
  _RenderControlPrim2D.PrimAdd(Pos2, Col2);
  _RenderControlPrim2D.PrimEnd;
end;

procedure TG2Core.PrimTriCol(const x0, y0, x1, y1, x2, y2: TG2Float; const Col0, Col1, Col2: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  RenderControl := _RenderControlPrim2D;
  _RenderControlPrim2D.PrimBegin(ptTriangles, BlendMode);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x0, y0), Col0);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x1, y1), Col1);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x2, y2), Col2);
  _RenderControlPrim2D.PrimEnd;
end;

procedure TG2Core.PrimQuadCol(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col0, Col1, Col2, Col3: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  RenderControl := _RenderControlPrim2D;
  _RenderControlPrim2D.PrimBegin(ptTriangles, BlendMode);
  _RenderControlPrim2D.PrimAdd(Pos0, Col0);
  _RenderControlPrim2D.PrimAdd(Pos1, Col1);
  _RenderControlPrim2D.PrimAdd(Pos2, Col2);
  _RenderControlPrim2D.PrimAdd(Pos2, Col2);
  _RenderControlPrim2D.PrimAdd(Pos1, Col1);
  _RenderControlPrim2D.PrimAdd(Pos3, Col3);
  _RenderControlPrim2D.PrimEnd;
end;

procedure TG2Core.PrimQuadCol(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col0, Col1, Col2, Col3: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  RenderControl := _RenderControlPrim2D;
  _RenderControlPrim2D.PrimBegin(ptTriangles, BlendMode);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x0, y0), Col0);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x1, y1), Col1);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x2, y2), Col2);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x2, y2), Col2);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x1, y1), Col1);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x3, y3), Col3);
  _RenderControlPrim2D.PrimEnd;
end;

procedure TG2Core.PrimQuad(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  PrimQuadCol(Pos0, Pos1, Pos2, Pos3, Col, Col, Col, Col, BlendMode);
end;

procedure TG2Core.PrimQuad(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  PrimQuadCol(x0, y0, x1, y1, x2, y2, x3, y3, Col, Col, Col, Col, BlendMode);
end;

procedure TG2Core.PrimRectCol(const x, y, w, h: TG2Float; const Col0, Col1, Col2, Col3: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
  var xh, yh: TG2Float;
begin
  xh := x + w; yh := y + h;
  PrimQuadCol(x, y, xh, y, x, yh, xh, yh, Col0, Col1, Col2, Col3, BlendMode);
end;

procedure TG2Core.PrimRect(const x, y, w, h: TG2Float; const Col: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  PrimRectCol(x, y, w, h, Col, Col, Col, Col, BlendMode);
end;

procedure TG2Core.PrimRectHollowCol(const x, y, w, h: TG2Float; const Col0, Col1, Col2, Col3: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  PrimQuadHollowCol(x, y, x + w, y, x, y + h, x + w, y + h, Col0, Col1, Col2, Col3, BlendMode);
end;

procedure TG2Core.PrimRectHollow(const x, y, w, h: TG2Float; const Col: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  PrimQuadHollowCol(x, y, x + w, y, x, y + h, x + w, y + h, Col, Col, Col, Col, BlendMode);
end;

procedure TG2Core.PrimCircleCol(const Pos: TG2Vec2; const Radius: TG2Float; const Col0, Col1: TG2Vec4; Segments: Integer = 16; BlendMode: TG2BlendMode = bmNormal);
  var i: Integer;
  var s, c: TG2Float;
begin
  RenderControl := _RenderControlPrim2D;
  _RenderControlPrim2D.PrimBegin(ptTriangles, BlendMode);
  for i := 0 to Segments - 1 do
  begin
    G2SinCos((i / Segments) * TwoPi, s, c);
    _RenderControlPrim2D.PrimAdd(Pos, Col0);
    _RenderControlPrim2D.PrimAdd(G2Vec2(Pos.x + c * Radius, Pos.y + s * Radius), Col1);
    G2SinCos(((i + 1) / Segments) * TwoPi, s, c);
    _RenderControlPrim2D.PrimAdd(G2Vec2(Pos.x + c * Radius, Pos.y + s * Radius), Col1);
  end;
  _RenderControlPrim2D.PrimEnd;
end;

procedure TG2Core.PrimCircleCol(const x, y, Radius: TG2Float; const Col0, Col1: TG2Vec4; Segments: Integer = 16; BlendMode: TG2BlendMode = bmNormal);
begin
  PrimCircleCol(G2Vec2(x, y), Radius, Col0, Col1, Segments, BlendMode);
end;

procedure TG2Core.PrimTriHollowCol(const Pos0, Pos1, Pos2: TG2Vec2; const Col0, Col1, Col2: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  RenderControl := _RenderControlPrim2D;
  _RenderControlPrim2D.PrimBegin(ptLines, BlendMode);
  _RenderControlPrim2D.PrimAdd(Pos0, Col0);
  _RenderControlPrim2D.PrimAdd(Pos1, Col1);
  _RenderControlPrim2D.PrimAdd(Pos1, Col1);
  _RenderControlPrim2D.PrimAdd(Pos2, Col2);
  _RenderControlPrim2D.PrimAdd(Pos2, Col2);
  _RenderControlPrim2D.PrimAdd(Pos0, Col0);
  _RenderControlPrim2D.PrimEnd;
end;

procedure TG2Core.PrimTriHollowCol(const x0, y0, x1, y1, x2, y2: TG2Float; const Col0, Col1, Col2: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  RenderControl := _RenderControlPrim2D;
  _RenderControlPrim2D.PrimBegin(ptLines, BlendMode);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x0, y0), Col0);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x1, y1), Col1);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x1, y1), Col1);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x2, y2), Col2);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x2, y2), Col2);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x0, y0), Col0);
  _RenderControlPrim2D.PrimEnd;
end;

procedure TG2Core.PrimQuadHollowCol(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col0, Col1, Col2, Col3: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  RenderControl := _RenderControlPrim2D;
  _RenderControlPrim2D.PrimBegin(ptLines, BlendMode);
  _RenderControlPrim2D.PrimAdd(Pos0, Col0);
  _RenderControlPrim2D.PrimAdd(Pos1, Col1);
  _RenderControlPrim2D.PrimAdd(Pos1, Col1);
  _RenderControlPrim2D.PrimAdd(Pos3, Col3);
  _RenderControlPrim2D.PrimAdd(Pos3, Col3);
  _RenderControlPrim2D.PrimAdd(Pos2, Col2);
  _RenderControlPrim2D.PrimAdd(Pos2, Col2);
  _RenderControlPrim2D.PrimAdd(Pos0, Col0);
  _RenderControlPrim2D.PrimEnd;
end;

procedure TG2Core.PrimQuadHollowCol(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col0, Col1, Col2, Col3: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  RenderControl := _RenderControlPrim2D;
  _RenderControlPrim2D.PrimBegin(ptLines, BlendMode);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x0, y0), Col0);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x1, y1), Col1);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x1, y1), Col1);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x3, y3), Col3);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x3, y3), Col3);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x2, y2), Col2);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x2, y2), Col2);
  _RenderControlPrim2D.PrimAdd(G2Vec2(x0, y0), Col0);
  _RenderControlPrim2D.PrimEnd;
end;

procedure TG2Core.PrimCircleHollow(const Pos: TG2Vec2; const Radius: TG2Float; const Col: TG2Vec4; Segments: Integer = 16; BlendMode: TG2BlendMode = bmNormal);
begin
  PrimCircleHollow(Pos.x, Pos.y, Radius, Col, Segments, BlendMode);
end;

procedure TG2Core.PrimCircleHollow(const x, y, Radius: TG2Float; const Col: TG2Vec4; Segments: Integer = 16; BlendMode: TG2BlendMode = bmNormal);
  var s, c: Single;
  var i: Integer;
begin
  RenderControl := _RenderControlPrim2D;
  _RenderControlPrim2D.PrimBegin(ptLines, BlendMode);
  s := 0; c := 1;
  for i := 0 to Segments - 1 do
  begin
    _RenderControlPrim2D.PrimAdd(G2Vec2(x + c * Radius, y + s * Radius), Col);
    G2SinCos(((i + 1) / Segments * TwoPi), s, c);
    _RenderControlPrim2D.PrimAdd(G2Vec2(x + c * Radius, y + s * Radius), Col);
  end;
  _RenderControlPrim2D.PrimEnd;
end;

procedure TG2Core.PrimLine(const Pos0, Pos1: TG2Vec2; const Col: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  PrimLineCol(Pos0, Pos1, Col, Col, BlendMode);
end;

procedure TG2Core.PrimLine(const x0, y0, x1, y1: TG2Float; const Col: TG2Vec4; BlendMode: TG2BlendMode = bmNormal);
begin
  PrimLineCol(G2Vec2(x0, y0), G2Vec2(x1, y1), Col, Col, BlendMode);
end;

procedure TG2Core.PrimBegin(const PrimType: TG2Prim2DType; BlendMode: TG2BlendMode = bmNormal);
begin
  RenderControl := _RenderControlPrim2D;
  _RenderControlPrim2D.PrimBegin(PrimType, BlendMode);
end;

procedure TG2Core.PrimAdd(const Position: TG2Vec2; const Color: TG2Vec4);
begin
  _RenderControlPrim2D.PrimAdd(Position, Color);
end;

procedure TG2Core.PrimEnd;
begin
  _RenderControlPrim2D.PrimEnd;
end;

procedure TG2Core.RenderPrimitive(
  const VB: TG2VertexBuffer;
  const PrimitiveType: TG2PrimitiveType;
  const VertexStart: Integer;
  const PrimitiveCount: Integer;
  const Texture: TG2Texture2DBase;
  const W, V, P: TG2Mat
);
begin
  RenderControl := _RenderControlBuffer;
  _RenderControlBuffer.RenderPrimitive(
    VB, PrimitiveType, VertexStart, PrimitiveCount, Texture, W, V, P
  );
end;

procedure TG2Core.RenderPrimitive(
  const VB: TG2VertexBuffer;
  const IB: TG2IndexBuffer;
  const PrimitiveType: TG2PrimitiveType;
  const VertexStart: Integer;
  const VertexCount: Integer;
  const IndexStart: Integer;
  const PrimitiveCount: Integer;
  const Texture: TG2Texture2DBase;
  const W, V, P: TG2Mat
);
begin
  RenderControl := _RenderControlBuffer;
  _RenderControlBuffer.RenderPrimitive(
    VB, IB, PrimitiveType, VertexStart, VertexCount, IndexStart, PrimitiveCount, Texture, W, V, P
  );
end;
//TG2Core END

//TG2TextureBase BEGIN
procedure TG2TextureBase.Release;
begin
  if _Texture <> nil then
  begin
    _gl.deleteTexture(_Texture);
    _Texture := nil;
  end;
end;

constructor TG2TextureBase.Create;
begin
  inherited Create;
  Parent := g2;
  _gl := g2.Gfx.gl;
  _Texture := _gl.createTexture;
end;

destructor TG2TextureBase.Destroy;
begin
  Release;
  inherited Destroy;
end;
//TG2TextureBase END

//TG2Texture2DBase BEGIN
function TG2Texture2DBase.GetProjection: TG2Mat;
  var OffsetX, OffsetY: TG2Float;
begin
  OffsetX := 0.5 + (0.5 / _RealWidth);
  OffsetY := 0.5 + (0.5 / _RealHeight);
  Result := G2MatIdentity;
  Result.e00 := 0.5;
  Result.e11 := -0.5;
  Result.e22 := 1;
  Result.e30 := OffsetX;
  Result.e31 := OffsetY;
  Result.e33 := 1.0;
end;

procedure TG2Texture2DBase.Bind(const Stage: Integer);
begin
  _gl.activeTexture(_gl.TEXTURE0 + Stage);
  _gl.bindTexture(_gl.TEXTURE_2D, _Texture);
end;
//TG2Texture2DBase END

//TG2Texture2D BEGIN
procedure TG2Texture2D.OnLoad;
begin
  _gl.bindTexture(_gl.TEXTURE_2D, _Texture);
  asm
    (@_gl).pixelStorei((@_gl).UNPACK_FLIP_Y_WEBGL, false);
    (@_gl).texImage2D((@_gl).TEXTURE_2D, 0, (@_gl).RGBA, (@_gl).RGBA, (@_gl).UNSIGNED_BYTE, @_Image);
    (@_gl).texParameteri((@_gl).TEXTURE_2D, (@_gl).TEXTURE_WRAP_S, (@_gl).REPEAT);
    (@_gl).texParameteri((@_gl).TEXTURE_2D, (@_gl).TEXTURE_WRAP_T, (@_gl).REPEAT);
    (@_gl).texParameteri((@_gl).TEXTURE_2D, (@_gl).TEXTURE_MAG_FILTER, (@_gl).LINEAR);
    (@_gl).texParameteri((@_gl).TEXTURE_2D, (@_gl).TEXTURE_MIN_FILTER, (@_gl).LINEAR_MIPMAP_LINEAR);
    (@_gl).generateMipmap((@_gl).TEXTURE_2D);
    (@_gl).bindTexture((@_gl).TEXTURE_2D, null);
  end;
  _RealWidth := _Image.width;
  _RealHeight := _Image.height;
  _Width := _RealWidth;
  _Height := _RealHeight;
  case _Usage of
    tuDefault, tuUsage3D:
    begin
      _SizeTU := 1;
      _SizeTV := 1;
    end;
    tuUsage2D:
    begin
      _SizeTU := _Width / _RealWidth;
      _SizeTV := _Height / _RealHeight;
    end;
  end;
  _State := asLoaded;
  g2.LoadingItems := g2.LoadingItems - 1;
  if Assigned(_OnLoadProc) then
  _OnLoadProc;
end;

procedure TG2Texture2D.OnError;
begin
  _State := asError;
  g2.LoadingItems := g2.LoadingItems - 1;
end;

constructor TG2Texture2D.Create;
begin
  inherited Create;
  _OnLoadProc := nil;
end;

procedure TG2Texture2D.Load(const FileName: String; TextureUsage: TG2TextureUsage = tuDefault);
  var fname: String;
begin
  _Usage := Usage;
  asm
    @_Image = new Image();
  end;
  _Image.onload := @OnLoad;
  _Image.onerror := @OnError;
  fname := FileName;
  if PreventCaching then
  fname := fname + '?c=' + IntToStr(G2Time);
  _Image.src := FileName;
  _State := asLoading;
  g2.LoadingItems := g2.LoadingItems + 1;
end;
//TG2Texture2D END

//TG2Texture2DVideo BEGIN
procedure TG2Texture2DVideo.OnReadyToPlay;
  function SetTimer(const Proc: TG2ProcObj): Variant;
  begin
    asm
      (@Result) = setInterval((@Proc), 30);
    end;
  end;
begin
  if _State = asLoaded then Exit;
  _Video.play();
  _Video.volume := 0.1;
  _RealWidth := _Video.videoWidth;
  _RealHeight := _Video.videoHeight;
  _Width := _RealWidth;
  _Height := _RealHeight;
  _SizeTU := 1;
  _SizeTV := 1;
  _gl.bindTexture(_gl.TEXTURE_2D, _Texture);
  asm
    (@_gl).pixelStorei((@_gl).UNPACK_FLIP_Y_WEBGL, false);
    (@_gl).texImage2D((@_gl).TEXTURE_2D, 0, (@_gl).RGBA, (@_gl).RGBA, (@_gl).UNSIGNED_BYTE, (@_Video));
    (@_gl).texParameteri((@_gl).TEXTURE_2D, (@_gl).TEXTURE_WRAP_S, (@_gl).CLAMP_TO_EDGE);
    (@_gl).texParameteri((@_gl).TEXTURE_2D, (@_gl).TEXTURE_WRAP_T, (@_gl).CLAMP_TO_EDGE);
    (@_gl).texParameteri((@_gl).TEXTURE_2D, (@_gl).TEXTURE_MAG_FILTER, (@_gl).LINEAR);
    (@_gl).texParameteri((@_gl).TEXTURE_2D, (@_gl).TEXTURE_MIN_FILTER, (@_gl).LINEAR);
    (@_gl).bindTexture((@_gl).TEXTURE_2D, null);
  end;
  _IntervalID := SetTimer(@OnUpdateTexture);
  _State := asLoaded;
end;

procedure TG2Texture2DVideo.OnPlayFinished;
begin
  if Assigned(_OnFinishedProc) then _OnFinishedProc;
end;

procedure TG2Texture2DVideo.OnUpdateTexture;
begin
  _gl.bindTexture(_gl.TEXTURE_2D, _Texture);
  asm
    (@_gl).pixelStorei((@_gl).UNPACK_FLIP_Y_WEBGL, false);
    (@_gl).texImage2D((@_gl).TEXTURE_2D, 0, (@_gl).RGBA, (@_gl).RGBA, (@_gl).UNSIGNED_BYTE, (@_Video));
    (@_gl).bindTexture((@_gl).TEXTURE_2D, null);
  end;
end;

constructor TG2Texture2DVideo.Create;
begin
  inherited Create;
  _IntervalID := -1;
  _OnFinishedProc := nil;
end;

destructor TG2Texture2DVideo.Destroy;
begin
  inherited Destroy;
  if _IntervalID > -1 then
  begin
    asm
      //clearInterval(@_IntervalID);
    end;
    _IntervalID := -1;
  end;
end;

procedure TG2Texture2DVideo.Load(const FileName: String);
begin
  asm
    @_Video = document.createElement("video");
    (@_Video).style.display = "none";
    (@_Video).preload = "auto";
    (@_Video).src = FileName;
  end;
  _Video.addEventListener('canplaythrough', @OnReadyToPlay, True);
  _Video.addEventListener('ended', @OnPlayFinished, True);
  _State := asLoading;
end;
//TG2Texture2DVideo END

//TG2Texture2DRT BEGIN
procedure TG2Texture2DRT.Release;
begin
  inherited Release;
  _gl.deleteRenderbuffer(_RenderBuffer);
  _gl.deleteFramebuffer(_FrameBuffer);
end;

constructor TG2Texture2DRT.Create;
begin
  inherited Create;
  _FrameBuffer := _gl.createFramebuffer;
  _RenderBuffer := _gl.createRenderbuffer;
end;

function TG2Texture2DRT.Make(const NewWidth, NewHeight: Integer): Boolean;
begin
  Result := False;
  _Width := NewWidth;
  _Height := NewHeight;
  _RealWidth := 1; while _RealWidth < _Width do _RealWidth := _RealWidth shl 1;
  _RealHeight := 1; while _RealHeight < _Height do _RealHeight := _RealHeight shl 1;
  _SizeTU := _Width / _RealWidth;
  _SizeTV := _Height / _RealHeight;
  _gl.BindTexture(_gl.TEXTURE_2D, _Texture);
  _gl.TexImage2D(
    _gl.TEXTURE_2D,
    0,
    _gl.RGBA,
    _RealWidth,
    _RealHeight,
    0,
    _gl.RGBA,
    _gl.UNSIGNED_BYTE,
    nil
  );
  _gl.TexParameteri(_gl.TEXTURE_2D, _gl.TEXTURE_MAG_FILTER, _gl.LINEAR);
  _gl.TexParameteri(_gl.TEXTURE_2D, _gl.TEXTURE_MIN_FILTER, _gl.LINEAR);
  _gl.TexParameteri(_gl.TEXTURE_2D, _gl.TEXTURE_WRAP_S, _gl.CLAMP_TO_EDGE);
  _gl.TexParameteri(_gl.TEXTURE_2D, _gl.TEXTURE_WRAP_T, _gl.CLAMP_TO_EDGE);
  _gl.bindFramebuffer(_gl.FRAMEBUFFER, _FrameBuffer);
  _gl.bindRenderbuffer(_gl.RENDERBUFFER, _RenderBuffer);
  //_gl.renderbufferStorage(_gl.RENDERBUFFER, _gl.RGBA, _RealWidth, _RealHeight);
  _gl.renderbufferStorage(_gl.RENDERBUFFER, _gl.DEPTH_COMPONENT16, _RealWidth, _RealHeight);
  _gl.framebufferRenderbuffer(_gl.FRAMEBUFFER, _gl.DEPTH_ATTACHMENT, _gl.RENDERBUFFER, _RenderBuffer);
  _gl.framebufferTexture2D(_gl.FRAMEBUFFER, _gl.COLOR_ATTACHMENT0, _gl.TEXTURE_2D, nil, 0);
  _gl.bindFramebuffer(_gl.FRAMEBUFFER, nil);
  Result := True;
end;
//TG2Texture2DRT END

//TG2TextureCubeBase BEGIN
procedure TG2TextureCubeBase.Bind(const Stage: Integer);
begin
  _gl.activeTexture(_gl.TEXTURE0 + Stage);
  _gl.bindTexture(_gl.TEXTURE_CUBE_MAP, _Texture);
end;
//TG2TextureCubeBase END

//TG2TextureCube BEGIN
procedure TG2TextureCube.OnLoad;
  var i: Integer;
  var glvar: Variant;
begin
  Inc(_ImagesLoaded);
  if _State = asLoading then
  begin
    if _ImagesLoaded >= 6 then
    begin
      asm @glvar = @_gl; end;
      _gl.bindTexture(_gl.TEXTURE_CUBE_MAP, _Texture);
      _gl.texParameteri(_gl.TEXTURE_CUBE_MAP, _gl.TEXTURE_WRAP_S, _gl.CLAMP_TO_EDGE);
      _gl.texParameteri(_gl.TEXTURE_CUBE_MAP, _gl.TEXTURE_WRAP_T, _gl.CLAMP_TO_EDGE);
      _gl.texParameteri(_gl.TEXTURE_CUBE_MAP, _gl.TEXTURE_MIN_FILTER, _gl.LINEAR_MIPMAP_LINEAR);
      _gl.texParameteri(_gl.TEXTURE_CUBE_MAP, _gl.TEXTURE_MAG_FILTER, _gl.LINEAR);
      _gl.pixelStorei(_gl.UNPACK_FLIP_Y_WEBGL, 0);
      for i := 0 to 5 do
      begin
        glvar.texImage2D(G2TextureCubeFaceGL[i], 0, _gl.RGBA, _gl.RGBA, _gl.UNSIGNED_BYTE, _Image[i]);
      end;
      _gl.generateMipmap(_gl.TEXTURE_CUBE_MAP);
      _gl.bindTexture(_gl.TEXTURE_CUBE_MAP, nil);
      _Size := _Image[0].width;
      _State := asLoaded;
      g2.LoadingItems := g2.LoadingItems - 1;
      if Assigned(_OnLoadProc) then
      _OnLoadProc;
    end;
  end;
end;

procedure TG2TextureCube.OnError;
begin
  _State := asError;
  g2.LoadingItems := g2.LoadingItems - 1;
end;

constructor TG2TextureCube.Create;
begin
  inherited Create;
  _OnLoadProc := nil;
end;

procedure TG2TextureCube.Load(
  const FileNamePosX: String;
  const FileNameNegX: String;
  const FileNamePosY: String;
  const FileNameNegY: String;
  const FileNamePosZ: String;
  const FileNameNegZ: String;
  TextureUsage: TG2TextureUsage = tuDefault
);
  var i, t: Integer;
begin
  _Usage := Usage;
  _State := asLoading;
  _ImagesLoaded := 0;
  for i := 0 to 5 do
  begin
    asm
      @_Image[@i] = new Image();
    end;
    _Image[i].onload := @OnLoad;
    _Image[i].onerror := @OnError;
  end;
  if PreventCaching then
  begin
    t := G2Time;
    _Image[0].src := FileNamePosX + '?c=' + IntToStr(t);
    _Image[1].src := FileNameNegX + '?c=' + IntToStr(t);
    _Image[2].src := FileNamePosY + '?c=' + IntToStr(t);
    _Image[3].src := FileNameNegY + '?c=' + IntToStr(t);
    _Image[4].src := FileNamePosZ + '?c=' + IntToStr(t);
    _Image[5].src := FileNameNegZ + '?c=' + IntToStr(t);
  end
  else
  begin
    _Image[0].src := FileNamePosX;
    _Image[1].src := FileNameNegX;
    _Image[2].src := FileNamePosY;
    _Image[3].src := FileNameNegY;
    _Image[4].src := FileNamePosZ;
    _Image[5].src := FileNameNegZ;
  end;
  g2.LoadingItems := g2.LoadingItems + 1;
end;
//TG2TextureCube END

//TG2Font BEGIN
procedure TG2Font.OnLoadCheck;
  var i: Integer;
begin
  if (_DataManager.State = asLoaded)
  and (_Texture.State = asLoaded) then
  begin
    _CharSpaceX := _Texture.Width div 16;
    _CharSpaceY := _Texture.Height div 16;
    for i := 0 to 255 do
    begin
      _Props[i].OffsetX := (_CharSpaceX - _Props[i].Width) div 2;
      _Props[i].OffsetY := (_CharSpaceY - _Props[i].Height) div 2;
    end;
    g2.LoadingItems := g2.LoadingItems - 1;
    _State := asLoaded;
  end;
end;

procedure TG2Font.OnLoadTexture;
begin
  OnLoadCheck;
end;

procedure TG2Font.OnLoadHeader;
  const Definition: String = 'G2FH';
  const Version = $00010000;
  var HeaderDefinition: String;
  var HeaderVersion: Integer;
  var HeaderFontFace: String;
  var HeaderFontSize: Integer;
  var i: Integer;
begin
  HeaderDefinition := _DataManager.ReadString(4);
  if HeaderDefinition <> Definition then Exit;
  HeaderVersion := _DataManager.ReadIntU32;
  if HeaderVersion <> Version then Exit;
  HeaderFontFace := _DataManager.ReadStringNT;
  HeaderFontSize := _DataManager.ReadIntS32;
  _DataManager.Skip(8);
  for i := 0 to 255 do
  begin
    _Props[i].Width := _DataManager.ReadIntU8;
    _Props[i].Height := _DataManager.ReadIntU8;
  end;
  OnLoadCheck;
end;

constructor TG2Font.Create;
begin
  inherited Create;
  Parent := g2;
  _DataManager := TG2DataManager.Create;
  _DataManager.OnLoadProc := @OnLoadHeader;
  _Texture := TG2Texture2D.Create;
  _Texture.OnLoadProc := @OnLoadTexture;
end;

destructor TG2Font.Destroy;
begin
  _Texture.Free;
  _DataManager.Free;
  inherited Destroy;
end;

function TG2Font.TextWidth(const Text: String): Integer;
  var i: Integer;
begin
  Result := 0;
  for i := 1 to Length(Text) do
  Result := Result + _Props[Ord(Text[i])].Width;
end;

function TG2Font.TextHeight(const Text: String): Integer;
  var i: Integer;
  var b: Integer;
begin
  Result := 0;
  for i := 1 to Length(Text) do
  begin
    b := Ord(Text[i]);
    if _Props[b].Height > Result then
    Result := _Props[b].Height;
  end;
end;

procedure TG2Font.Load(const FontHeader, FontImage: String);
begin
  _Texture.Load(FontImage);
  _DataManager.Load(FontHeader);
  _State := asLoading;
  g2.LoadingItems := g2.LoadingItems + 1;
end;

procedure TG2Font.Print(
  const x, y, ScaleX, ScaleY: TG2Float;
  const Color: TG2Vec4;
  const Text: String;
  const BlendMode: TG2BlendMode;
  const Filter: TG2Filter
);
  var i: Integer;
  var c: Integer;
  var tu1, tv1, tu2, tv2: TG2Float;
  var x1, y1, x2, y2: TG2Float;
  var CharTU, CharTV, CurPos: TG2Float;
begin
  CharTU := _CharSpaceX / _Texture.RealWidth;
  CharTV := _CharSpaceY / _Texture.RealHeight;
  CurPos := x;
  for i := 0 to Length(Text) - 1 do
  begin
    c := Ord(Text[i + 1]);
    tu1 := (c mod 16) * CharTU;
    tv1 := (c div 16) * CharTV;
    tu2 := tu1 + CharTU;
    tv2 := tv1 + CharTV;
    x1 := CurPos - _Props[c].OffsetX * ScaleX;
    y1 := y - _Props[c].OffsetY * ScaleY;
    x2 := x1 + _CharSpaceX * ScaleX;
    y2 := y1 + _CharSpaceY * ScaleY;
    CurPos := CurPos + _Props[c].Width * ScaleX;
    g2.PicQuadCol(
      x1, y1, x2, y1,
      x1, y2, x2, y2,
      tu1, tv1, tu2, tv1,
      tu1, tv2, tu2, tv2,
      Color, Color, Color, Color,
      _Texture,
      BlendMode, Filter
    );
  end;
end;

procedure TG2Font.Print(
  const x, y, ScaleX, ScaleY: TG2Float;
  const Text: String;
  const BlendMode: TG2BlendMode;
  const Filter: TG2Filter
);
begin
  Print(x, y, ScaleX, ScaleY, G2Vec4(1, 1, 1, 1), Text, BlendMode, Filter);
end;

procedure TG2Font.Print(const x, y, ScaleX, ScaleY: TG2Float; const Text: String);
begin
  Print(x, y, ScaleX, ScaleY, Text, bmNormal, tfPoint);
end;

procedure TG2Font.Print(const x, y: TG2Float; const Text: String);
begin
  Print(x, y, 1, 1, Text);
end;
//TG2Font END

//TG2VertexBuffer BEGIN
function TG2VertexBuffer.GetTexCoordIndex(const Index: Integer): Integer;
begin
  Result := _TexCoordIndex[Index];
end;

procedure TG2VertexBuffer.WriteBufferData;
begin
  _gl.bindBuffer(_gl.ARRAY_BUFFER, _VB);
  _gl.bufferSubData(_gl.ARRAY_BUFFER, 0, _DataBuffer);
  _gl.bindBuffer(_gl.ARRAY_BUFFER, nil);
end;

procedure TG2VertexBuffer.Lock(LockMode: TG2BufferLockMode = lmReadWrite);
begin
  if _Locked then UnLock;
  _LockMode := LockMode;
  _Locked := True;
  _Position := 0;
end;

procedure TG2VertexBuffer.UnLock;
begin
  if not _Locked then Exit;
  case _LockMode of
    lmReadWrite: WriteBufferData;
  end;
  _Locked := False;
end;

procedure TG2VertexBuffer.Bind;
  var i: Integer;
  var VBPos: Integer;
  var IndPosition, IndColor, IndTexCoord, IndNormal, IndBinormal, IndTangent, IndBlendWeight, IndBlendIndex: Integer;
  var ai: GLInt;
begin
  _gl.bindBuffer(_gl.ARRAY_BUFFER, _VB);
  VBPos := 0;
  IndPosition := 0;
  IndColor := 0;
  IndTexCoord := 0;
  IndNormal := 0;
  IndBinormal := 0;
  IndTangent := 0;
  IndBlendWeight := 0;
  IndBlendIndex := 0;
  for i := 0 to High(_Decl) do
  case _Decl[i].Element of
    vbPosition:
    begin
      ai := g2.Gfx.Shader.GetShaderAttribute('a_Position' + IntToStr(IndPosition));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        _gl.enableVertexAttribArray(ai);
        _gl.vertexAttribPointer(ai, _Decl[i].Count, _gl.FLOAT, False, _VertexSize, VBPos);
      end;
      Inc(IndPosition);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbDiffuse:
    begin
      ai := g2.Gfx.Shader.GetShaderAttribute('a_Color' + IntToStr(IndColor));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        _gl.enableVertexAttribArray(ai);
        _gl.vertexAttribPointer(ai, _Decl[i].Count, _gl.FLOAT, False, _VertexSize, VBPos);
      end;
      Inc(IndPosition);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbTexCoord:
    begin
      ai := g2.Gfx.Shader.GetShaderAttribute('a_TexCoord' + IntToStr(IndTexCoord));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        _gl.enableVertexAttribArray(ai);
        _gl.vertexAttribPointer(ai, _Decl[i].Count, _gl.FLOAT, False, _VertexSize, VBPos);
      end;
      Inc(IndTexCoord);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbNormal:
    begin
      ai := g2.Gfx.Shader.GetShaderAttribute('a_Normal' + IntToStr(IndNormal));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        _gl.enableVertexAttribArray(ai);
        _gl.vertexAttribPointer(ai, _Decl[i].Count, _gl.FLOAT, False, _VertexSize, VBPos);
      end;
      Inc(IndNormal);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbBinormal:
    begin
      ai := g2.Gfx.Shader.GetShaderAttribute('a_Binormal' + IntToStr(IndBinormal));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        _gl.enableVertexAttribArray(ai);
        _gl.vertexAttribPointer(ai, _Decl[i].Count, _gl.FLOAT, False, _VertexSize, VBPos);
      end;
      Inc(IndBinormal);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbTangent:
    begin
      ai := g2.Gfx.Shader.GetShaderAttribute('a_Tangent' + IntToStr(IndTangent));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        _gl.enableVertexAttribArray(ai);
        _gl.vertexAttribPointer(ai, _Decl[i].Count, _gl.FLOAT, False, _VertexSize, VBPos);
      end;
      Inc(IndTangent);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbVertexWeight:
    begin
      ai := g2.Gfx.Shader.GetShaderAttribute('a_BlendWeight' + IntToStr(IndBlendWeight));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        _gl.enableVertexAttribArray(ai);
        _gl.vertexAttribPointer(ai, _Decl[i].Count, _gl.FLOAT, False, _VertexSize, VBPos);
      end;
      Inc(IndBlendWeight);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbVertexIndex:
    begin
      ai := g2.Gfx.Shader.GetShaderAttribute('a_BlendIndex' + IntToStr(IndBlendIndex));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        _gl.enableVertexAttribArray(ai);
        _gl.vertexAttribPointer(ai, _Decl[i].Count, _gl.FLOAT, False, _VertexSize, VBPos);
      end;
      Inc(IndBlendIndex);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    else
    begin
      Inc(VBPos, _Decl[i].Count * 4);
    end;
  end;
end;

procedure TG2VertexBuffer.Unbind;
  var i: Integer;
begin
  for i := 0 to _BoundAttribs.Count - 1 do
  _gl.disableVertexAttribArray(_BoundAttribs[i]);
  _BoundAttribs.Clear;
end;

procedure TG2VertexBuffer.Initialize(const Decl: TG2VBDecl; const Count: Integer);
  var i, ti: Integer;
begin
  _Decl := Decl;
  _VertexCount := Count;
  _VertexSize := 0;
  ti := 0;
  for i := 0 to High(_Decl) do
  if _Decl[i].Element <> vbNone then
  begin
    if _Decl[i].Element = vbTexCoord then
    begin
      _TexCoordIndex[ti] := _VertexSize;
      Inc(ti);
    end;
    _VertexSize := _VertexSize + _Decl[i].Count * 4;
  end;
  for i := ti to High(_TexCoordIndex) do
  _TexCoordIndex[i] := 0;
  _gl.bindBuffer(_gl.ARRAY_BUFFER, _VB);
  _gl.bufferData(_gl.ARRAY_BUFFER, _VertexCount * _VertexSize, _gl.STATIC_DRAW);
  asm @_DataBuffer = new ArrayBuffer(@_VertexCount * @_VertexSize); end;
  asm @_Data = new DataView(@_DataBuffer); end;
  _Locked := False;
end;

constructor TG2VertexBuffer.Create;
begin
  inherited Create;
  Parent := g2;
  _gl := g2.Gfx.gl;
  _VB := _gl.createBuffer();
end;

destructor TG2VertexBuffer.Destroy;
begin
  _gl.deleteBuffer(_VB);
  inherited Destroy;
end;

procedure TG2VertexBuffer.WriteFloat32(const f: TG2Float);
begin
  Data.setFloat32(_Position, f, True);
  _Position := _Position + 4;
end;

procedure TG2VertexBuffer.WriteVec2(const v: TG2Vec2);
begin
  WriteFloat32(v.x);
  WriteFloat32(v.y);
end;

procedure TG2VertexBuffer.WriteVec3(const v: TG2Vec3);
begin
  WriteFloat32(v.x);
  WriteFloat32(v.y);
  WriteFloat32(v.z);
end;

procedure TG2VertexBuffer.WriteVec4(const v: TG2Vec4);
begin
  WriteFloat32(v.x);
  WriteFloat32(v.y);
  WriteFloat32(v.z);
  WriteFloat32(v.w);
end;
//TG2VertexBuffer END

//TG2IndexBuffer BEGIN
procedure TG2IndexBuffer.WriteBufferData;
begin
  _gl.bindBuffer(_gl.ELEMENT_ARRAY_BUFFER, _IB);
  _gl.bufferSubData(_gl.ELEMENT_ARRAY_BUFFER, 0, _DataBuffer);
end;

constructor TG2IndexBuffer.Create;
begin
  inherited Create;
  Parent := g2;
  _gl := g2.Gfx.gl;
  _IB := _gl.createBuffer();
end;

destructor TG2IndexBuffer.Destroy;
begin
  _gl.deleteBuffer(_IB);
  inherited Destroy;
end;

procedure TG2IndexBuffer.Initialize(const Count: Integer);
begin
  _IndexCount := Count;
  _Locked := False;
  _LockMode := lmNone;
  _gl.bindBuffer(_gl.ELEMENT_ARRAY_BUFFER, _IB);
  _gl.bufferData(_gl.ELEMENT_ARRAY_BUFFER, _IndexCount * 2, _gl.STATIC_DRAW);
  asm @_DataBuffer = new ArrayBuffer(@_IndexCount * 2); end;
  asm @_Data = new DataView(@_DataBuffer); end;
end;

procedure TG2IndexBuffer.Lock(LockMode: TG2BufferLockMode = lmReadWrite);
begin
  if _Locked then UnLock;
  _LockMode := LockMode;
  _Locked := True;
  _Position := 0;
end;

procedure TG2IndexBuffer.UnLock;
begin
  if not _Locked then Exit;
  case _LockMode of
    lmReadWrite: WriteBufferData;
  end;
  _Locked := False;
end;

procedure TG2IndexBuffer.Bind;
begin
  _gl.bindBuffer(_gl.ELEMENT_ARRAY_BUFFER, _IB);
end;

procedure TG2IndexBuffer.Unbind;
begin

end;

procedure TG2IndexBuffer.WriteIntU16(const n: Integer);
begin
  Data.setUint16(_Position, n, True);
  _Position := _Position + 2;
end;
//TG2IndexBuffer END

//TG2RenderControl BEGIN
constructor TG2RenderControl.Create;
begin
  inherited Create;
  Parent := g2;
  _gl := g2.Gfx.gl;
end;

procedure TG2RenderControl.RenderStart;
begin

end;

procedure TG2RenderControl.RenderStop;
begin

end;
//TG2RenderControl END

//TG2ShaderProgram BEGIN
constructor TG2ShaderProgram.Create;
begin
  inherited Create;
  _gl := g2.Gfx.gl;
  _ShaderProgram := _gl.createProgram();
  _VertexShader := _gl.createShader(g2.Gfx.gl.VERTEX_SHADER);
  _PixelShader := _gl.createShader(g2.Gfx.gl.FRAGMENT_SHADER);
  Parent := g2;
end;

destructor TG2ShaderProgram.Destroy;
begin
  _gl.deleteShader(_PixelShader);
  _gl.deleteShader(_VertexShader);
  _gl.deleteProgram(_ShaderProgram);
  inherited Destroy;
end;

procedure TG2ShaderProgram.Compile(const VertexShaderSource, PixelShaderSource: String);
begin
  _gl.shaderSource(_VertexShader, VertexShaderSource);
  _gl.shaderSource(_PixelShader, PixelShaderSource);
  _gl.compileShader(_VertexShader);
  if not _gl.getShaderParameter(_VertexShader, _gl.COMPILE_STATUS) then
  ShowMessage('VertexShader error: ' + _gl.getShaderInfoLog(_VertexShader));
  _gl.compileShader(_PixelShader);
  if not _gl.getShaderParameter(_PixelShader, _gl.COMPILE_STATUS) then
  ShowMessage('PixelShader error: ' + _gl.getShaderInfoLog(_PixelShader));
  _gl.attachShader(_ShaderProgram, _VertexShader);
  _gl.attachShader(_ShaderProgram, _PixelShader);
  _gl.linkProgram(_ShaderProgram);
end;

procedure TG2ShaderProgram.Use;
begin
  if g2.Gfx.Shader <> Self then
  begin
    g2.Gfx.Shader := Self;
    g2.Gfx.gl.useProgram(_ShaderProgram);
  end;
end;

function TG2ShaderProgram.GetShaderAttribute(const AttributeName: String): GLInt;
begin
  Result := g2.Gfx.gl.getAttribLocation(_ShaderProgram, AttributeName);
end;

function TG2ShaderProgram.GetShaderUniform(const UniformName: String): JWebGLUniformLocation;
begin
  Result := g2.Gfx.gl.getUniformLocation(_ShaderProgram, UniformName);
end;
//TG2ShaderProgram END

//TG2RenderControlPrim2D BGEIN
procedure TG2RenderControlPrim2D.Flush;
  var VertsPositions: JFloat32Array;
  var VertsColors: JFloat32Array;
begin
  asm
    @VertsPositions = new Float32Array(@_ArrPositions);
    @VertsColors = new Float32Array(@_ArrColors);
  end;
  _gl.bindBuffer(_gl.ARRAY_BUFFER, _BufferPositions);
    _gl.bufferData(_gl.ARRAY_BUFFER, VertsPositions, _gl.DYNAMIC_DRAW);
  _gl.vertexAttribPointer(_AttribPosition, 3, _gl.FLOAT, False, 0, 0);
  _gl.bindBuffer(_gl.ARRAY_BUFFER, _BufferColors);
    _gl.bufferData(_gl.ARRAY_BUFFER, VertsColors, _gl.DYNAMIC_DRAW);
  _gl.vertexAttribPointer(_AttribColor, 4, _gl.FLOAT, False, 0, 0);
  case _CurPrimType of
    ptLines: _gl.drawArrays(_gl.LINES, 0, _CurPoint);
    ptTriangles: _gl.drawArrays(_gl.TRIANGLES, 0, _CurPoint);
  end;
  _CurPoint := 0;
  _ArrPositions.SetLength(0);
  _ArrColors.SetLength(0);
end;

constructor TG2RenderControlPrim2D.Create;
begin
  inherited Create;
  _Shader := TG2ShaderProgram.Create;
  _Shader.Compile(VS_Prim, PS_Prim);
  _Shader.Parent := Self;
  _AttribPosition := _Shader.GetShaderAttribute('a_Position0');
  _AttribColor := _Shader.GetShaderAttribute('a_Color0');
  _UniformWVP := _Shader.GetShaderUniform('WVP');
  _MaxPoints := 2048;
  _BufferPositions := _gl.createBuffer;
  _BufferColors := _gl.createBuffer;
end;

destructor TG2RenderControlPrim2D.Destroy;
begin
  _gl.deleteBuffer(_BufferPositions);
  _gl.deleteBuffer(_BufferColors);
  inherited Destroy;
end;

procedure TG2RenderControlPrim2D.RenderStart;
  var WVP: TG2Mat;
begin
  _Shader.Use;
  if g2.Gfx.RenderTarget = nil then
  WVP := G2MatOrth2D(g2.Params.Width, g2.Params.Height, 0, 1, False, True)
  else
  WVP := G2MatOrth2D(g2.Gfx.RenderTarget.Width, g2.Gfx.RenderTarget.Height, 0, 1, False, False);
  WVP := G2MatTranspose(WVP);
  g2.Gfx.gl.uniformMatrix4fv(_UniformWVP, False, WVP.ToFloat32Array);
  g2.Gfx.gl.enableVertexAttribArray(_AttribPosition);
  g2.Gfx.gl.enableVertexAttribArray(_AttribColor);
  _CurPoint := 0;
  _CurPrimType := ptNone;
  _CurBlendMode := bmInvalid;
  _ArrPositions.SetLength(0);
  _ArrColors.SetLength(0);
end;

procedure TG2RenderControlPrim2D.RenderStop;
begin
  if _CurPoint > 0 then Flush;
  _gl.disableVertexAttribArray(_AttribPosition);
  _gl.disableVertexAttribArray(_AttribColor);
end;

procedure TG2RenderControlPrim2D.PrimBegin(const PrimType: TG2Prim2DType; const BlendMode: TG2BlendMode);
begin
  if _CurPoint = 0 then
  begin
    _CurPrimType := PrimType;
    _CurBlendMode := BlendMode;
    g2.Gfx.BlendMode := _CurBlendMode;
  end
  else if (_CurPrimType <> PrimType)
  or (_CurBlendMode <> BlendMode)
  or ((_CurPrimType = ptLines) and (_MaxPoints - _CurPoint < 4) and (_CurPoint mod 2 = 0))
  or ((_CurPrimType = ptTriangles) and (_MaxPoints - _CurPoint < 6) and (_CurPoint mod 3 = 0)) then
  begin
    Flush;
    _CurPrimType := PrimType;
    _CurBlendMode := BlendMode;
    g2.Gfx.BlendMode := _CurBlendMode;
  end;
end;

procedure TG2RenderControlPrim2D.PrimEnd;
begin
  if _CurPoint > 0 then Flush;
end;

procedure TG2RenderControlPrim2D.PrimAdd(const Position: TG2Vec2; const Color: TG2Vec4);
  var i: Integer;
begin
  if ((_CurPrimType = ptLines) and (_MaxPoints - _CurPoint < 4) and (_CurPoint mod 2 = 0))
  or ((_CurPrimType = ptTriangles) and (_MaxPoints - _CurPoint < 6) and (_CurPoint mod 3 = 0)) then
  Flush;
  i := _CurPoint * 3;
  _ArrPositions[i + 0] := Position.x;
  _ArrPositions[i + 1] := Position.y;
  _ArrPositions[i + 2] := 0.0;
  i := _CurPoint * 4;
  _ArrColors[i + 0] := Color.x;
  _ArrColors[i + 1] := Color.y;
  _ArrColors[i + 2] := Color.z;
  _ArrColors[i + 3] := Color.w;
  _CurPoint := _CurPoint + 1;
end;

procedure TG2RenderControlPrim2D.PrimQuadCol(
  const Pos0, Pos1, Pos2, Pos3: TG2Vec2;
  const Col0, Col1, Col2, Col3: TG2Vec4;
  const BlendMode: TG2BlendMode
);
begin
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(Pos0, Col0); PrimAdd(Pos1, Col1); PrimAdd(Pos2, Col2);
  PrimAdd(Pos2, Col2); PrimAdd(Pos1, Col1); PrimAdd(Pos3, Col3);
end;
//TG2RenderControlPrim2D END

//TG2RenderControlPic2D BEGIN
procedure TG2RenderControlPic2D.Flush;
  var VertsPositions: JFloat32Array;
  var VertsColors: JFloat32Array;
  var VertsTexCoords: JFloat32Array;
begin
  VertsPositions := new JFloat32Array(_ArrPositions);
  VertsColors := new JFloat32Array(_ArrColors);
  VertsTexCoords := new JFloat32Array(_ArrTexCoords);
  _gl.bindBuffer(_gl.ARRAY_BUFFER, _BufferPositions);
    _gl.bufferData(_gl.ARRAY_BUFFER, VertsPositions, _gl.DYNAMIC_DRAW);
  _gl.vertexAttribPointer(_AttribPosition, 3, _gl.FLOAT, False, 0, 0);
  _gl.bindBuffer(_gl.ARRAY_BUFFER, _BufferColors);
    _gl.bufferData(_gl.ARRAY_BUFFER, VertsColors, _gl.DYNAMIC_DRAW);
  _gl.vertexAttribPointer(_AttribColor, 4, _gl.FLOAT, False, 0, 0);
  _gl.bindBuffer(_gl.ARRAY_BUFFER, _BufferTexCoords);
    _gl.bufferData(_gl.ARRAY_BUFFER, VertsTexCoords, _gl.DYNAMIC_DRAW);
  _gl.vertexAttribPointer(_AttribTexCoord, 2, _gl.FLOAT, False, 0, 0);
  _gl.bindBuffer(_gl.ELEMENT_ARRAY_BUFFER, _BufferIndices);
  _gl.drawElements(_gl.TRIANGLES, _CurQuad * 6, _gl.UNSIGNED_SHORT, 0);
  _CurQuad := 0;
  _ArrPositions.SetLength(0);
  _ArrColors.SetLength(0);
  _ArrTexCoords.SetLength(0);
end;

constructor TG2RenderControlPic2D.Create;
  var QuadIndPk: array[0..5] of Integer = [0, 1, 2, 2, 1, 3];
  var QuadInd: array of Integer;
  var i, j: Integer;
begin
  inherited Create;
  _Shader := TG2ShaderProgram.Create;
  _Shader.Compile(VS_Pic, PS_Pic);
  _Shader.Parent := Self;
  _AttribPosition := _Shader.GetShaderAttribute('a_Position0');
  _AttribColor := _Shader.GetShaderAttribute('a_Color0');
  _AttribTexCoord := _Shader.GetShaderAttribute('a_TexCoord0');
  _UniformWVP := _Shader.GetShaderUniform('WVP');
  _UniformTex0 := _Shader.GetShaderUniform('Tex0');
  _MaxQuads := 2048;
  _BufferPositions := _gl.createBuffer;
  _BufferColors := _gl.createBuffer;
  _BufferTexCoords := _gl.createBuffer;
  _BufferIndices := _gl.createBuffer;
  QuadInd.SetLength(_MaxQuads * 6);
  for i := 0 to _MaxQuads - 1 do
  for j := 0 to 5 do
  QuadInd[i * 6 + j] := QuadIndPk[j] + i * 4;
  _gl.bindBuffer(_gl.ELEMENT_ARRAY_BUFFER, _BufferIndices);
    _gl.bufferData(_gl.ELEMENT_ARRAY_BUFFER, new JUint16Array(QuadInd), _gl.STATIC_DRAW);
end;

destructor TG2RenderControlPic2D.Destroy;
begin
  _gl.deleteBuffer(_BufferPositions);
  _gl.deleteBuffer(_BufferColors);
  _gl.deleteBuffer(_BufferIndices);
  inherited Destroy;
end;

procedure TG2RenderControlPic2D.RenderStart;
  var WVP: TG2Mat;
begin
  _Shader.Use;
  if g2.Gfx.RenderTarget = nil then
  WVP := G2MatOrth2D(g2.Params.Width, g2.Params.Height, 0, 1, False, True)
  else
  WVP := G2MatOrth2D(g2.Gfx.RenderTarget.Width, g2.Gfx.RenderTarget.Height, 0, 1, False, False);
  WVP := G2MatTranspose(WVP);
  _gl.uniformMatrix4fv(_UniformWVP, False, WVP.ToFloat32Array);
  _gl.uniform1i(_UniformTex0, 0);
  _gl.enableVertexAttribArray(_AttribPosition);
  _gl.enableVertexAttribArray(_AttribColor);
  _gl.enableVertexAttribArray(_AttribTexCoord);
  _CurQuad := 0;
  _CurTexture := nil;
  _CurBlendMode := bmInvalid;
  _ArrPositions.SetLength(0);
  _ArrColors.SetLength(0);
  _ArrTexCoords.SetLength(0);
end;

procedure TG2RenderControlPic2D.RenderStop;
begin
  if _CurQuad > 0 then Flush;
  _gl.disableVertexAttribArray(_AttribPosition);
  _gl.disableVertexAttribArray(_AttribColor);
  _gl.disableVertexAttribArray(_AttribTexCoord);
end;

procedure TG2RenderControlPic2D.PicQuadCol(
  const Pos0, Pos1, Pos2, Pos3: TG2Vec2;
  const Tex0, Tex1, Tex2, Tex3: TG2Vec2;
  const Col0, Col1, Col2, Col3: TG2Vec4;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendMode;
  const Filter: TG2Filter
);
  var i: Integer;
begin
  if _CurQuad = 0 then
  begin
    _CurTexture := Texture;
    _CurBlendMode := BlendMode;
    _CurTexture.Bind(0);
    g2.Gfx.BlendMode := _CurBlendMode;
  end
  else if (_CurQuad >= _MaxQuads - 1)
  or (_CurTexture <> Texture)
  or (_CurBlendMode <> BlendMode) then
  begin
    Flush;
    if _CurTexture <> Texture then
    begin
      _CurTexture := Texture;
      _CurTexture.Bind(0);
    end;
    if _CurBlendMode <> BlendMode then
    begin
      _CurBlendMode := BlendMode;
      g2.Gfx.BlendMode := _CurBlendMode;
    end;
  end;
  i := _CurQuad * 12;
  _ArrPositions[i + 0] := Pos0.x;
  _ArrPositions[i + 1] := Pos0.y;
  _ArrPositions[i + 2] := 0.0;
  _ArrPositions[i + 3] := Pos1.x;
  _ArrPositions[i + 4] := Pos1.y;
  _ArrPositions[i + 5] := 0.0;
  _ArrPositions[i + 6] := Pos2.x;
  _ArrPositions[i + 7] := Pos2.y;
  _ArrPositions[i + 8] := 0.0;
  _ArrPositions[i + 9] := Pos3.x;
  _ArrPositions[i + 10] := Pos3.y;
  _ArrPositions[i + 11] := 0.0;
  i := _CurQuad * 16;
  _ArrColors[i + 0] := Col0.x;
  _ArrColors[i + 1] := Col0.y;
  _ArrColors[i + 2] := Col0.z;
  _ArrColors[i + 3] := Col0.w;
  _ArrColors[i + 4] := Col1.x;
  _ArrColors[i + 5] := Col1.y;
  _ArrColors[i + 6] := Col1.z;
  _ArrColors[i + 7] := Col1.w;
  _ArrColors[i + 8] := Col2.x;
  _ArrColors[i + 9] := Col2.y;
  _ArrColors[i + 10] := Col2.z;
  _ArrColors[i + 11] := Col2.w;
  _ArrColors[i + 12] := Col3.x;
  _ArrColors[i + 13] := Col3.y;
  _ArrColors[i + 14] := Col3.z;
  _ArrColors[i + 15] := Col3.w;
  i := _CurQuad * 8;
  _ArrTexCoords[i + 0] := Tex0.x;
  _ArrTexCoords[i + 1] := Tex0.y;
  _ArrTexCoords[i + 2] := Tex1.x;
  _ArrTexCoords[i + 3] := Tex1.y;
  _ArrTexCoords[i + 4] := Tex2.x;
  _ArrTexCoords[i + 5] := Tex2.y;
  _ArrTexCoords[i + 6] := Tex3.x;
  _ArrTexCoords[i + 7] := Tex3.y;
  _CurQuad := _CurQuad + 1;
end;
//TG2RenderControlPic2D END

//TG2RenderControlBuffer BEGIN
constructor TG2RenderControlBuffer.Create;
begin
  inherited Create;
  _Shader := TG2ShaderProgram.Create;
  _Shader.Compile(VS_Pic, PS_Pic);
  _Shader.Parent := Self;
  _UniformWVP := _Shader.GetShaderUniform('WVP');
  _UniformTex0 := _Shader.GetShaderUniform('Tex0');
end;

destructor TG2RenderControlBuffer.Destroy;
begin
  inherited Destroy;
end;

procedure TG2RenderControlBuffer.RenderPrimitive(
  const VB: TG2VertexBuffer;
  const PrimitiveType: TG2PrimitiveType;
  const VertexStart: Integer;
  const PrimitiveCount: Integer;
  const Texture: TG2Texture2DBase;
  const W, V, P: TG2Mat
);
  var WVP: TG2Mat;
begin
  Texture.Bind(0);
  WVP := G2MatTranspose(W * V * P);
  _gl.uniformMatrix4fv(_UniformWVP, False, WVP.ToFloat32Array);
  _gl.uniform1i(_UniformTex0, 0);
  VB.Bind;
  _gl.DrawArrays(_gl.TRIANGLES, VertexStart, PrimitiveCount * 3);
  VB.Unbind;
end;

procedure TG2RenderControlBuffer.RenderPrimitive(
  const VB: TG2VertexBuffer;
  const IB: TG2IndexBuffer;
  const PrimitiveType: TG2PrimitiveType;
  const VertexStart: Integer;
  const VertexCount: Integer;
  const IndexStart: Integer;
  const PrimitiveCount: Integer;
  const Texture: TG2Texture2DBase;
  const W, V, P: TG2Mat
);
  var WVP: TG2Mat;
begin
  Texture.Bind(0);
  WVP := G2MatTranspose(W * V * P);
  _gl.uniformMatrix4fv(_UniformWVP, False, WVP.ToFloat32Array);
  _gl.uniform1i(_UniformTex0, 0);
  VB.Bind;
  IB.Bind;
  _gl.DrawElements(_gl.TRIANGLES, PrimitiveCount * 3, _gl.UNSIGNED_SHORT, 0);
  IB.Unbind;
  VB.Unbind;
end;

procedure TG2RenderControlBuffer.RenderStart;
begin
  _Shader.Use;
end;

procedure TG2RenderControlBuffer.RenderStop;
begin

end;
//TG2RenderControlBuffer END

//TG2S3DParticleRender BEGIN
constructor TG2S3DParticleRender.Create(const Scene: TG2Scene3D);
begin
  inherited Create;
  _Scene := Scene;
  _gl := g2.Gfx.gl;
end;

destructor TG2S3DParticleRender.Destroy;
begin
  inherited Destroy;
end;
//TG2S3DParticleRender END

//TG2S3DParticleRenderFlat BEGIN
procedure TG2S3DParticleRenderFlat.RenderFlush;
begin
  if _CurQuad = 0 then Exit;
  _gl.drawElements(_gl.TRIANGLES, _CurQuad * 6, _gl.UNSIGNED_SHORT, 0);
  _CurQuad := 0;
end;

constructor TG2S3DParticleRenderFlat.Create(const Scene: TG2Scene3D);
  var Decl: TG2VBDecl;
  var i: Integer;
begin
  inherited Create(Scene);
  _MaxQuads := 45;
  _Shader := TG2ShaderProgram.Create;
  _Shader.Parent := _Scene;
  _Shader.Compile(VS_SceneParticles, PS_SceneParticles);
  _UniformWVP := _Shader.GetShaderUniform('WVP');
  _UniformTex0 := _Shader.GetShaderUniform('Tex0');
  Decl.SetLength(3);
  Decl[0].Element := vbPosition; Decl[0].Count := 3;
  Decl[1].Element := vbTexCoord; Decl[1].Count := 2;
  Decl[2].Element := vbVertexIndex; Decl[2].Count := 1;
  _VB := TG2VertexBuffer.Create;
  _VB.Initialize(Decl, _MaxQuads * 4);
  _VB.Lock;
  for i := 0 to _MaxQuads - 1 do
  begin
    _VB.WriteVec3(G2Vec3(-0.5, 0.5, 0));
    _VB.WriteVec2(G2Vec2(0, 0));
    _VB.WriteFloat32(i);
    _VB.WriteVec3(G2Vec3(0.5, 0.5, 0));
    _VB.WriteVec2(G2Vec2(1, 0));
    _VB.WriteFloat32(i);
    _VB.WriteVec3(G2Vec3(-0.5, -0.5, 0));
    _VB.WriteVec2(G2Vec2(0, 1));
    _VB.WriteFloat32(i);
    _VB.WriteVec3(G2Vec3(0.5, -0.5, 0));
    _VB.WriteVec2(G2Vec2(1, 1));
    _VB.WriteFloat32(i);
  end;
  _VB.UnLock;
  _IB := TG2IndexBuffer.Create;
  _IB.Initialize(_MaxQuads * 6);
  _IB.Lock;
  for i := 0 to _MaxQuads - 1 do
  begin
    _IB.WriteIntU16(i * 4 + 0);
    _IB.WriteIntU16(i * 4 + 1);
    _IB.WriteIntU16(i * 4 + 2);
    _IB.WriteIntU16(i * 4 + 2);
    _IB.WriteIntU16(i * 4 + 1);
    _IB.WriteIntU16(i * 4 + 3);
  end;
  _IB.UnLock;
end;

destructor TG2S3DParticleRenderFlat.Destroy;
begin
  _VB.Free;
  _IB.Free;
  inherited Destroy;
end;

procedure TG2S3DParticleRenderFlat.RenderBegin;
  var WVP: TG2Mat;
begin
  g2.Gfx.DepthEnable := True;
  g2.Gfx.DepthWriteEnable := False;
  _Shader.Use;
  WVP := G2MatTranspose(_Scene.V * _Scene.P);
  _gl.uniformMatrix4fv(_UniformWVP, False, WVP.ToFloat32Array);
  _gl.uniform1i(_UniformTex0, 0);
  _VB.Bind;
  _IB.Bind;
  _CurQuad := 0;
  _CurTexture := nil;
  _CurBlendMode := bmInvalid;
  _CurFilter := tfNone;
end;

procedure TG2S3DParticleRenderFlat.RenderEnd;
begin
  if _CurQuad > 0 then
  RenderFlush;
  _IB.Unbind;
  _VB.Unbind;
  g2.Gfx.DepthEnable := False;
  g2.Gfx.DepthWriteEnable := True;
end;

procedure TG2S3DParticleRenderFlat.RenderParticle(const Particle: TG2S3DParticle);
  var p: TG2S3DParticleFlat;
  var m: TG2Mat;
begin
  p := TG2S3DParticleFlat(Particle);
  if (p.Texture <> _CurTexture)
  or (p.Filter <> _CurFilter)
  or (p.BlendMode <> _CurBlendMode)
  or (_CurQuad >= _MaxQuads - 1)
  then
  begin
    if (_CurQuad > 0) then
    RenderFlush;
    if (p.Texture <> _CurTexture) then
    begin
      _CurTexture := p.Texture;
      _CurTexture.Bind(0);
    end;
    begin
      _CurFilter := p.Filter;
      case _CurFilter of
        tfPoint:
        begin
          _gl.texParameteri(_gl.TEXTURE_2D, _gl.TEXTURE_MIN_FILTER, _gl.NEAREST);
          _gl.texParameteri(_gl.TEXTURE_2D, _gl.TEXTURE_MAG_FILTER, _gl.NEAREST);
        end;
        tfLinear:
        begin
          _gl.texParameteri(_gl.TEXTURE_2D, _gl.TEXTURE_MIN_FILTER, _gl.LINEAR);
          _gl.texParameteri(_gl.TEXTURE_2D, _gl.TEXTURE_MAG_FILTER, _gl.LINEAR);
        end;
      end;
    end;
    if (p.BlendMode <> _CurBlendMode) then
    begin
      _CurBlendMode := p.BlendMode;
      g2.Gfx.BlendMode := _CurBlendMode;
    end;
  end;
  m := G2Mat(p.VecX, p.VecY, G2Vec3(0, 0, 0), p.Pos);
  m.e03 := p.Color.x;
  m.e13 := p.Color.y;
  m.e23 := p.Color.z;
  m.e33 := p.Color.w;
  _gl.uniformMatrix4fv(_Shader.GetShaderUniform('TransformPallete[' + IntToStr(_CurQuad) + ']'), False, G2MatTranspose(m).ToFloat32Array);
  Inc(_CurQuad);
end;
//TG2S3DParticleRenderFlat END

//TG2S3DParticle BEGIN
function TG2S3DParticle.GetAABox: TG2AABox;
begin
  Result.MinV.x := _Pos.x - _Size;
  Result.MinV.y := _Pos.y - _Size;
  Result.MinV.z := _Pos.z - _Size;
  Result.MaxV.x := _Pos.x + _Size;
  Result.MaxV.y := _Pos.y + _Size;
  Result.MaxV.z := _Pos.z + _Size;
end;

procedure TG2S3DParticle.Die;
begin
  _Dead := True;
end;

constructor TG2S3DParticle.Create;
begin
  inherited Create;
  _ParticleRender := nil;
  _RenderClass := nil;
  _Size := 0;
  _Pos.SetValue(0, 0, 0);
  _Dead := False;
end;

destructor TG2S3DParticle.Destroy;
begin
  inherited Destroy;
end;
//TG2S3DParticle END

//TG2S3DParticleFlat BEGIN
procedure TG2S3DParticleFlat.SetVecX(const Value: TG2Vec3);
begin
  _VecX := Value;
  UpdateSize;
end;

procedure TG2S3DParticleFlat.SetVecY(const Value: TG2Vec3);
begin
  _VecY := Value;
  UpdateSize;
end;

procedure TG2S3DParticleFlat.UpdateSize;
begin
  _Size := Sqrt(Sqr(_VecX.Len) + Sqr(_VecY.Len));
end;

procedure TG2S3DParticleFlat.MakeBillboard(const View: TG2Mat; const Width, Height, Rotation: TG2Float);
  var s, c: TG2Float;
  var vx, vy: TG2Vec3;
begin
  G2SinCos(Rotation, s, c);
  vx := G2Vec3(View.e00, View.e10, View.e20).Norm * (Width * 0.5);
  vy := G2Vec3(View.e01, View.e11, View.e21).Norm * (Height * 0.5);
  VecX := (vx * s) - (vy * c);
  VecY := (vy * s) + (vx * c);
end;

procedure TG2S3DParticleFlat.MakeAxis(const View: TG2Mat; const Pos0, Pos1: TG2Vec3; const Width: TG2Float);
begin
  Pos := (Pos0 + Pos1) * 0.5;
  VecY := (Pos1 - Pos0) * 0.5;
  VecX := VecY.Cross(G2Vec3(View.e02, View.e12, View.e22)).Norm * (Width * 0.5);
end;

procedure TG2S3DParticleFlat.Update;
begin

end;

constructor TG2S3DParticleFlat.Create;
begin
  inherited Create;
  _RenderClass := TG2S3DParticleRenderFlat;
  _VecX.SetValue(1, 0, 0);
  _VecY.SetValue(0, 1, 0);
  UpdateSize;
  _Texture := nil;
  _Color := G2Vec4(1, 1, 1, 1);
  _Filter := tfLinear;
  _BlendMode := bmNormal;
  DepthSorted := True;
end;

destructor TG2S3DParticleFlat.Destroy;
begin
  inherited Destroy;
end;
//TG2S3DParticleFlat END

//TG2S3DNode BEGIN
procedure TG2S3DNode.SetTransform(const Value: TG2Mat);
begin
  _Transform := Value;
end;

constructor TG2S3DNode.Create(const Scene: TG2Scene3D);
begin
  inherited Create;
  _Scene := Scene;
  _Transform := G2MatIdentity;
  _UserData := nil;
  _Scene._Nodes.Add(Self);
end;

destructor TG2S3DNode.Destroy;
begin
  _Scene._Nodes.Remove(Self);
  if _UserData <> nil then
  _UserData.Free;
  inherited Destroy;
end;
//TG2S3DNode END

//TG2S3DFrame BEGIN
constructor TG2S3DFrame.Create(const Scene: TG2Scene3D);
begin
  inherited Create(Scene);
  _Scene._Frames.Add(Self);
end;

destructor TG2S3DFrame.Destroy;
begin
  _Scene._Frames.Remove(Self);
  inherited Destroy;
end;
//TG2S3DFrame END

//TG2S3DMesh BEGIN
procedure TG2S3DMesh.OnLoad;
  var i: Integer;
  var MeshLoader: TG2MeshLoader;
  var MeshData: TG2MeshData;
begin
  g2.LoadingItems := g2.LoadingItems - 1;
  MeshLoader := nil;
  for i := 0 to High(G2MeshLoaders) do
  if G2MeshLoaders[i].CanLoad(_DataManager) then
  begin
    MeshLoader := G2MeshLoaders[i].Create;
    Break;
  end;
  if MeshLoader = nil then
  begin
    _State := asError;
    Exit;
  end;
  MeshLoader.Load(_DataManager);
  MeshData := MeshLoader.ExportMeshData;
  LoadData(MeshData);
  MeshData.Free;
  _Loaded := True;
  _State := asLoaded;
end;

function TG2S3DMesh.GetNode(const Index: Integer): TG2S3DMeshNode;
begin
  Result := _Nodes[Index];
end;

function TG2S3DMesh.GetGeom(const Index: Integer): TG2S3DMeshGeom;
begin
  Result := _Geoms[Index];
end;

function TG2S3DMesh.GetAnim(const Index: Integer): TG2S3DMeshAnim;
begin
  Result := _Anims[Index];
end;

function TG2S3DMesh.GetMaterial(const Index: Integer): TG2S3DMeshMaterial;
begin
  Result := _Materials[Index];
end;

procedure TG2S3DMesh.Release;
  var i: Integer;
begin
  if _Loaded then
  begin
    while _Instances.Count > 0 do
    TG2S3DMeshInst(_Instances.Pop).Free;
    for i := 0 to _GeomCount - 1 do
    begin
      _Geoms[i].IB.Free;
      if _Geoms[i].Skinned then
      TG2S3DGeomDataSkinned(_Geoms[i].Data).Free
      else
      begin
        TG2S3DGeomDataStatic(_Geoms[i].Data).VB.Free;
        TG2S3DGeomDataStatic(_Geoms[i].Data).Free;
      end;
    end;
    _Loaded := False;
  end;
end;

constructor TG2S3DMesh.Create(const Scene: TG2Scene3D);
begin
  inherited Create;
  _Loaded := False;
  _NodeCount := 0;
  _GeomCount := 0;
  _AnimCount := 0;
  _MaterialCount := 0;
  _Instances.Clear;
  _Scene := Scene;
  _Scene._Meshes.Add(Self);
  _DataManager := TG2DataManager.Create;
  _DataManager.Parent := Self;
  _DataManager.OnLoadProc := Self.OnLoad;
end;

destructor TG2S3DMesh.Destroy;
begin
  _DataManager.Free;
  _Scene._Meshes.Remove(Self);
  Release;
  inherited Destroy;
end;

procedure TG2S3DMesh.Load(const FileName: String);
begin
  _DataManager.Load(FileName);
  _State := asLoading;
  g2.LoadingItems := g2.LoadingItems + 1;
end;

procedure TG2S3DMesh.LoadData(const MeshData: TG2MeshData);
  var i, j, n: Integer;
  var OffsetVertex, OffsetTexCoords, OffsetBlendIndices, OffsetBlendWeights: Integer;
  var DataStatic: TG2S3DGeomDataStatic;
  var DataSkinned: TG2S3DGeomDataSkinned;
  var MinV, MaxV, v: TG2Vec3;
begin
  _NodeCount := MeshData.NodeCount;
  _Nodes.SetLength(_NodeCount);
  for i := 0 to _NodeCount - 1 do
  begin
    _Nodes[i] := TG2S3DMeshNode.Create;
    _Nodes[i].Name := MeshData.Nodes[i].Name;
    _Nodes[i].OwnerID := MeshData.Nodes[i].OwnerID;
    _Nodes[i].Transform := MeshData.Nodes[i].Transform;
    _Nodes[i].SubNodesID.SetLength(0);
  end;
  for i := 0 to _NodeCount - 1 do
  if _Nodes[i].OwnerID > -1 then
  begin
    _Nodes[_Nodes[i].OwnerID].SubNodesID.SetLength(Length(_Nodes[_Nodes[i].OwnerID].SubNodesID) + 1);
    _Nodes[_Nodes[i].OwnerID].SubNodesID[High(_Nodes[_Nodes[i].OwnerID].SubNodesID)] := i;
  end;
  _GeomCount := MeshData.GeomCount;
  _Geoms.SetLength(_GeomCount);
  for i := 0 to _GeomCount - 1 do
  begin
    _Geoms[i] := TG2S3DMeshGeom.Create;
    _Geoms[i].NodeID := MeshData.Geoms[i].NodeID;
    _Geoms[i].VCount := MeshData.Geoms[i].VCount;
    _Geoms[i].FCount := MeshData.Geoms[i].FCount;
    _Geoms[i].GCount := MeshData.Geoms[i].MCount;
    _Geoms[i].TCount := MeshData.Geoms[i].TCount;
    _Geoms[i].Visible := True;
    _Geoms[i].Skinned := MeshData.Geoms[i].SkinID > -1;
    _Geoms[i].Decl.SetLength(5 + _Geoms[i].TCount);
    _Geoms[i].Decl[0].Element := vbPosition; _Geoms[i].Decl[0].Count := 3;
    _Geoms[i].Decl[1].Element := vbDiffuse; _Geoms[i].Decl[1].Count := 4;
    _Geoms[i].Decl[2].Element := vbNormal; _Geoms[i].Decl[2].Count := 3;
    _Geoms[i].Decl[3].Element := vbTangent; _Geoms[i].Decl[3].Count := 3;
    _Geoms[i].Decl[4].Element := vbBinormal; _Geoms[i].Decl[4].Count := 3;
    for j := 5 to 5 + _Geoms[i].TCount - 1 do
    begin
      _Geoms[i].Decl[j].Element := vbTexCoord;
      _Geoms[i].Decl[j].Count := 2;
    end;
    if _Geoms[i].Skinned then
    begin
      DataSkinned := TG2S3DGeomDataSkinned.Create;
      _Geoms[i].Data := DataSkinned;
      DataSkinned.MaxWeights := MeshData.Skins[MeshData.Geoms[i].SkinID].MaxWeights;
      DataSkinned.BoneCount := MeshData.Skins[MeshData.Geoms[i].SkinID].BoneCount;
      DataSkinned.Bones.SetLength(DataSkinned.BoneCount);
      for j := 0 to DataSkinned.BoneCount - 1 do
      begin
        DataSkinned.Bones[j].NodeID := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].NodeID;
        DataSkinned.Bones[j].Bind := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].Bind;
        DataSkinned.Bones[j].BBox := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].BBox;
        DataSkinned.Bones[j].VCount := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].VCount;
      end;
      n := Length(_Geoms[i].Decl);
      if DataSkinned.MaxWeights = 1 then
      begin
        _Geoms[i].Decl.SetLength(Length(_Geoms[i].Decl) + 1);
        _Geoms[i].Decl[n].Element := vbVertexIndex; _Geoms[i].Decl[n].Count := 1;
      end
      else
      begin
        _Geoms[i].Decl.SetLength(Length(_Geoms[i].Decl) + 2 * DataSkinned.MaxWeights);
        _Geoms[i].Decl[n].Element := vbVertexIndex; _Geoms[i].Decl[n].Count := DataSkinned.MaxWeights;
        Inc(n);
        _Geoms[i].Decl[n].Element := vbVertexWeight; _Geoms[i].Decl[n].Count := DataSkinned.MaxWeights;
      end;
      DataSkinned.VB := TG2VertexBuffer.Create;
      DataSkinned.VB.Initialize(_Geoms[i].Decl, _Geoms[i].VCount);
      DataSkinned.VB.Lock;
      for j := 0 to _Geoms[i].VCount - 1 do
      begin
        OffsetVertex := DataSkinned.VB.VertexSize * j;
        OffsetTexCoords := OffsetVertex + 64;
        OffsetBlendIndices := OffsetTexCoords + _Geoms[i].TCount * 8;
        OffsetBlendWeights := OffsetBlendIndices + DataSkinned.MaxWeights * 4;
        DataSkinned.VB.Position := OffsetVertex;
        DataSkinned.VB.WriteVec3(MeshData.Geoms[i].Vertices[j].Position);
        DataSkinned.VB.WriteVec4(MeshData.Geoms[i].Vertices[j].Color);
        DataSkinned.VB.WriteVec3(MeshData.Geoms[i].Vertices[j].Normal);
        DataSkinned.VB.WriteVec3(MeshData.Geoms[i].Vertices[j].Tangent);
        DataSkinned.VB.WriteVec3(MeshData.Geoms[i].Vertices[j].Binormal);
        DataSkinned.VB.Position := OffsetTexCoords;
        for n := 0 to _Geoms[i].TCount - 1 do
        DataSkinned.VB.WriteVec2(MeshData.Geoms[i].Vertices[j].TexCoords[n]);
        if DataSkinned.MaxWeights = 1 then
        DataSkinned.VB.WriteFloat32(MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[0].BoneID)
        else
        for n := 0 to DataSkinned.MaxWeights - 1 do
        begin
          DataSkinned.VB.Position := OffsetBlendIndices;
          DataSkinned.VB.WriteFloat32(MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[n].BoneID);
          OffsetBlendIndices := OffsetBlendIndices + 4;
          DataSkinned.VB.Position := OffsetBlendWeights;
          DataSkinned.VB.WriteFloat32(MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[n].Weight);
          OffsetBlendWeights := OffsetBlendWeights + 4;
        end;
      end;
      DataSkinned.VB.UnLock;
    end
    else
    begin
      DataStatic := TG2S3DGeomDataStatic.Create;
      _Geoms[i].Data := DataStatic;
      DataStatic.VB := TG2VertexBuffer.Create;
      DataStatic.VB.Initialize(_Geoms[i].Decl, _Geoms[i].VCount);
      DataStatic.VB.Lock;
      MinV := MeshData.Geoms[i].Vertices[0].Position;
      MaxV := MinV;
      for j := 0 to _Geoms[i].VCount - 1 do
      begin
        OffsetVertex := DataStatic.VB.VertexSize * j;
        OffsetTexCoords := OffsetVertex + 64;
        DataStatic.VB.Position := OffsetVertex;
        DataStatic.VB.WriteVec3(MeshData.Geoms[i].Vertices[j].Position);
        DataStatic.VB.WriteVec4(MeshData.Geoms[i].Vertices[j].Color);
        DataStatic.VB.WriteVec3(MeshData.Geoms[i].Vertices[j].Normal);
        DataStatic.VB.WriteVec3(MeshData.Geoms[i].Vertices[j].Tangent);
        DataStatic.VB.WriteVec3(MeshData.Geoms[i].Vertices[j].Binormal);
        DataStatic.VB.Position := OffsetTexCoords;
        for n := 0 to _Geoms[i].TCount - 1 do
        DataStatic.VB.WriteVec2(MeshData.Geoms[i].Vertices[j].TexCoords[n]);
        if MeshData.Geoms[i].Vertices[j].Position.x > MaxV.x then MaxV.x := MeshData.Geoms[i].Vertices[j].Position.x
        else if MeshData.Geoms[i].Vertices[j].Position.x < MinV.x then MinV.x := MeshData.Geoms[i].Vertices[j].Position.x;
        if MeshData.Geoms[i].Vertices[j].Position.y > MaxV.y then MaxV.y := MeshData.Geoms[i].Vertices[j].Position.y
        else if MeshData.Geoms[i].Vertices[j].Position.y < MinV.y then MinV.y := MeshData.Geoms[i].Vertices[j].Position.y;
        if MeshData.Geoms[i].Vertices[j].Position.z > MaxV.z then MaxV.z := MeshData.Geoms[i].Vertices[j].Position.z
        else if MeshData.Geoms[i].Vertices[j].Position.z < MinV.z then MinV.z := MeshData.Geoms[i].Vertices[j].Position.z;
      end;
      DataStatic.VB.UnLock;
      DataStatic.BBox.c := (MinV + MaxV) * 0.5;
      v := (MaxV - MinV) * 0.5;
      DataStatic.BBox.vx.SetValue(v.x, 0, 0);
      DataStatic.BBox.vy.SetValue(0, v.y, 0);
      DataStatic.BBox.vz.SetValue(0, 0, v.z);
    end;
    _Geoms[i].IB := TG2IndexBuffer.Create;
    _Geoms[i].IB.Initialize(_Geoms[i].FCount * 3);
    _Geoms[i].IB.Lock;
    for j := 0 to _Geoms[i].FCount - 1 do
    begin
      _Geoms[i].IB.WriteIntU16(MeshData.Geoms[i].Faces[j][0]);
      _Geoms[i].IB.WriteIntU16(MeshData.Geoms[i].Faces[j][1]);
      _Geoms[i].IB.WriteIntU16(MeshData.Geoms[i].Faces[j][2]);
    end;
    _Geoms[i].IB.UnLock;
    _Geoms[i].Groups.SetLength(_Geoms[i].GCount);
    for j := 0 to _Geoms[i].GCount - 1 do
    begin
      _Geoms[i].Groups[j].Material := MeshData.Geoms[i].Groups[j].MaterialID;
      _Geoms[i].Groups[j].VertexStart := MeshData.Geoms[i].Groups[j].VertexStart;
      _Geoms[i].Groups[j].VertexCount := MeshData.Geoms[i].Groups[j].VertexCount;
      _Geoms[i].Groups[j].FaceStart := MeshData.Geoms[i].Groups[j].FaceStart;
      _Geoms[i].Groups[j].FaceCount := MeshData.Geoms[i].Groups[j].FaceCount;
    end;
  end;
  _MaterialCount := MeshData.MaterialCount;
  _Materials.SetLength(_MaterialCount);
  for i := 0 to _MaterialCount - 1 do
  begin
    _Materials[i] := TG2S3DMeshMaterial.Create;
    _Materials[i].ChannelCount := MeshData.Materials[i].ChannelCount;
    _Materials[i].Channels.SetLength(_Materials[i].ChannelCount);
    for j := 0 to _Materials[i].ChannelCount - 1 do
    begin
      _Materials[i].Channels[j].Name := MeshData.Materials[i].Channels[j].Name;
      _Materials[i].Channels[j].TwoSided := MeshData.Materials[i].Channels[j].TwoSided;
      if Length(MeshData.Materials[i].Channels[j].DiffuseMap) > 0 then
      _Materials[i].Channels[j].MapDiffuse := _Scene.FindTexture(MeshData.Materials[i].Channels[j].DiffuseMap, tuUsage3D)
      else
      _Materials[i].Channels[j].MapDiffuse := nil;
      if Length(MeshData.Materials[i].Channels[j].LightMap) > 0 then
      _Materials[i].Channels[j].MapLight := _Scene.FindTexture(MeshData.Materials[i].Channels[j].LightMap, tuDefault)
      else
      _Materials[i].Channels[j].MapLight := nil;
    end;
  end;
  _AnimCount := MeshData.AnimCount;
  _Anims.SetLength(_AnimCount);
  for i := 0 to _AnimCount - 1 do
  begin
    _Anims[i] := TG2S3DMeshAnim.Create;
    _Anims[i].Name := MeshData.Anims[i].Name;
    _Anims[i].FrameCount := MeshData.Anims[i].FrameCount;
    _Anims[i].FrameRate := MeshData.Anims[i].FrameRate;
    _Anims[i].NodeCount := MeshData.Anims[i].NodeCount;
    _Anims[i].Nodes.SetLength(_Anims[i].NodeCount);
    for j := 0 to _Anims[i].NodeCount - 1 do
    begin
      _Anims[i].Nodes[j].NodeID := MeshData.Anims[i].Nodes[j].NodeID;
      _Anims[i].Nodes[j].Frames.SetLength(_Anims[i].FrameCount);
      for n := 0 to _Anims[i].FrameCount - 1 do
      begin
        _Anims[i].Nodes[j].Frames[n].Scaling := MeshData.Anims[i].Nodes[j].Frames[n].Scaling;
        _Anims[i].Nodes[j].Frames[n].Rotation := MeshData.Anims[i].Nodes[j].Frames[n].Rotation;
        _Anims[i].Nodes[j].Frames[n].Translation := MeshData.Anims[i].Nodes[j].Frames[n].Translation;
      end;
    end;
  end;
  _Loaded := True;
end;

function TG2S3DMesh.AnimIndex(const Name: String): Integer;
  var i: Integer;
begin
  for i := 0 to _AnimCount - 1 do
  if _Anims[i].Name = Name then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;

function TG2S3DMesh.NewInst: TG2S3DMeshInst;
begin
  Result := TG2S3DMeshInst.Create(_Scene);
  Result.Mesh := Self;
end;
//TG2S3DMesh END

//TG2S3DMeshInst BEGIN
procedure TG2S3DMeshInst.SetMesh(const Value: TG2S3DMesh);
  var i, r: Integer;
begin
  if Value = _Mesh then Exit;
  if _Mesh <> nil then
  begin
    for i := 0 to _Mesh.NodeCount - 1 do
    begin
      UserData[i].Free;
      UserData[i] := nil;
    end;
    _Mesh._Instances.Remove(Self);
  end;
  _Mesh := Value;
  for i := 0 to High(_Skins) do
  if _Skins[i] <> nil then
  begin
    _Skins[i].Free;
    _Skins[i] := nil;
  end;
  if _Mesh <> nil then
  begin
    UserData.SetLength(_Mesh.NodeCount);
    for i := 0 to _Mesh.NodeCount - 1 do
    UserData[i] := nil;
    Materials.SetLength(_Mesh.MaterialCount);
    for i := 0 to _Mesh.MaterialCount - 1 do
    begin
      Materials[i] := _Mesh.Materials[i];
    end;
    Transforms.SetLength(_Mesh.NodeCount);
    r := 0;
    _RootNodes.SetLength(_Mesh.NodeCount);
    for i := 0 to _Mesh.NodeCount - 1 do
    begin
      if _Mesh.Nodes[i].OwnerID = -1 then
      begin
        _RootNodes[i] := i;
        Inc(r);
      end;
      Transforms[i].TransformDef := _Mesh.Nodes[i].Transform;
      Transforms[i].TransformCur := Transforms[i].TransformDef;
      Transforms[i].TransformCom := G2MatIdentity;
    end;
    _Skins.SetLength(_Mesh.GeomCount);
    for i := 0 to _Mesh.GeomCount - 1 do
    if _Mesh.Geoms[i].Skinned then
    begin
      _Skins[i] := TG2S3DMeshInstSkin.Create;
      _Skins[i].Transforms.SetLength(TG2S3DGeomDataSkinned(_Mesh.Geoms[i].Data).BoneCount);
    end;
    if r < Length(_RootNodes) then
    _RootNodes.SetLength(r);
    ComputeTransforms;
  end;
end;

function TG2S3DMeshInst.GetBBox: TG2Box;
  var i: Integer;
  var b: TG2AABox;
begin
  if _Mesh.GeomCount < 1 then
  begin
    Result.SetValue(G2Vec3(0, 0, 0), G2Vec3(0, 0, 0), G2Vec3(0, 0, 0), G2Vec3(0, 0, 0));
    Exit;
  end;
  b := G2BoxToAABox(GetGeomBBox(0));
  for i := 1 to _Mesh.GeomCount - 1 do
  b.Merge(G2BoxToAABox(GetGeomBBox(i)));
  Result := G2AABoxToBox(b);
end;

function TG2S3DMeshInst.GetGeomBBox(const Index: Integer): TG2Box;
  var DataSkinned: TG2S3DGeomDataSkinned;
  var i, j: Integer;
  var b: TG2AABox;
begin
  if _Mesh.Geoms[Index].Skinned then
  begin
    DataSkinned := TG2S3DGeomDataSkinned(_Mesh.Geoms[Index].Data);
    for i := 0 to DataSkinned.BoneCount - 1 do
    if DataSkinned.Bones[i].VCount > 0 then
    begin
      b := G2BoxToAABox(DataSkinned.Bones[i].BBox.Transform(_Skins[Index].Transforms[i]));
      Break;
    end;
    for j := i + 1 to DataSkinned.BoneCount - 1 do
    if DataSkinned.Bones[j].VCount > 0 then
    b.Merge(G2BoxToAABox(DataSkinned.Bones[j].BBox.Transform(_Skins[Index].Transforms[j])));
    Result := G2AABoxToBox(b);
  end
  else
  Result := TG2S3DGeomDataStatic(_Mesh.Geoms[Index].Data).BBox.Transform(Transforms[_Mesh.Geoms[Index].NodeID].TransformCom);
end;

function TG2S3DMeshInst.GetSkin(const Index: Integer): TG2S3DMeshInstSkin;
begin
  Result := _Skins[Index];
end;

procedure TG2S3DMeshInst.ComputeSkinTransforms;
  var i, j: Integer;
  var DataSkinned: TG2S3DGeomDataSkinned;
begin
  for i := 0 to _Mesh.GeomCount - 1 do
  if _Mesh.Geoms[i].Skinned then
  begin
    DataSkinned := TG2S3DGeomDataSkinned(_Mesh.Geoms[i].Data);
    for j := 0 to DataSkinned.BoneCount - 1 do
    _Skins[i].Transforms[j] := DataSkinned.Bones[j].Bind * Transforms[DataSkinned.Bones[j].NodeID].TransformCom;
  end;
end;

function TG2S3DMeshInst.GetAABox: TG2AABox;
begin
  Result := G2BoxToAABox(GetBBox);
end;

constructor TG2S3DMeshInst.Create(const Scene: TG2Scene3D);
begin
  inherited Create(Scene);
  _Mesh := nil;
  _AutoComputeTransforms := True;
  _Scene._MeshInst.Add(Self);
end;

destructor TG2S3DMeshInst.Destroy;
begin
  _Scene._MeshInst.Remove(Self);
  Mesh := nil;
  inherited Destroy;
end;

procedure TG2S3DMeshInst.FrameSetFast(const AnimName: String; const Frame: Integer);
  var AnimIndex, i, f0: Integer;
  var ms, mr, mt: TG2Mat;
begin
  AnimIndex := _Mesh.AnimIndex(AnimName);
  if AnimIndex > -1 then
  begin
    if Frame < 0 then
    f0 := _Mesh.Anims[AnimIndex].FrameCount - (Abs(Frame) mod _Mesh.Anims[AnimIndex].FrameCount)
    else
    f0 := Frame mod _Mesh.Anims[AnimIndex].FrameCount;
    for i := 0 to _Mesh.Anims[AnimIndex].NodeCount - 1 do
    begin
      ms := G2MatScaling(_Mesh.Anims[AnimIndex].Nodes[i].Frames[f0].Scaling);
      mr := G2MatRotation(_Mesh.Anims[AnimIndex].Nodes[i].Frames[f0].Rotation);
      mt := G2MatTranslation(_Mesh.Anims[AnimIndex].Nodes[i].Frames[f0].Translation);
      Transforms[_Mesh.Anims[AnimIndex].Nodes[i].NodeID].TransformCur := ms * mr * mt;
    end;
    if _AutoComputeTransforms then ComputeTransforms;
  end;
end;

procedure TG2S3DMeshInst.FrameSet(const AnimName: String; const Frame: Single);
  var AnimIndex, i, f0, f1: Integer;
  var f: Single;
  var s0: TG2Vec3;
  var r0: TG2Quat;
  var t0: TG2Vec3;
  var ms, mr, mt: TG2Mat;
begin
  AnimIndex := _Mesh.AnimIndex(AnimName);
  if AnimIndex > -1 then
  begin
    if Frame < 0 then
    f := _Mesh.Anims[AnimIndex].FrameCount - (Trunc(Abs(Frame)) mod _Mesh.Anims[AnimIndex].FrameCount) + Frac(Frame)
    else
    f := Frame;
    f0 := Trunc(f) mod _Mesh.Anims[AnimIndex].FrameCount;
    f1 := (f0 + 1) mod _Mesh.Anims[AnimIndex].FrameCount;
    f := Frac(f);
    for i := 0 to _Mesh.Anims[AnimIndex].NodeCount - 1 do
    begin
      s0 := G2LerpVec3(
        _Mesh.Anims[AnimIndex].Nodes[i].Frames[f0].Scaling,
        _Mesh.Anims[AnimIndex].Nodes[i].Frames[f1].Scaling,
        f
      );
      r0 := G2QuatSlerp(
        _Mesh.Anims[AnimIndex].Nodes[i].Frames[f0].Rotation,
        _Mesh.Anims[AnimIndex].Nodes[i].Frames[f1].Rotation,
        f
      );
      t0 := G2LerpVec3(
        _Mesh.Anims[AnimIndex].Nodes[i].Frames[f0].Translation,
        _Mesh.Anims[AnimIndex].Nodes[i].Frames[f1].Translation,
        f
      );
      ms := G2MatScaling(s0);
      mr := G2MatRotation(r0);
      mt := G2MatTranslation(t0);
      Transforms[_Mesh.Anims[AnimIndex].Nodes[i].NodeID].TransformCur := ms * mr * mt;
    end;
    if _AutoComputeTransforms then ComputeTransforms;
  end;
end;

procedure TG2S3DMeshInst.ComputeTransforms;
  procedure ComputeNode(const NodeID: Integer);
    var i: Integer;
  begin
    if _Mesh.Nodes[NodeID].OwnerID > -1 then
    Transforms[NodeID].TransformCom := Transforms[NodeID].TransformCur * Transforms[_Mesh.Nodes[NodeID].OwnerID].TransformCom
    else
    Transforms[NodeID].TransformCom := Transforms[NodeID].TransformCur;
    for i := 0 to High(_Mesh.Nodes[NodeID].SubNodesID) do
    ComputeNode(_Mesh.Nodes[NodeID].SubNodesID[i]);
  end;
  var i: Integer;
begin
  for i := 0 to High(_RootNodes) do
  ComputeNode(_RootNodes[i]);
  ComputeSkinTransforms;
end;
//TG2S3DMeshInst END

//TG2Scene3D BEGIN
procedure TG2Scene3D.OcTreeBuild(const MinV, MaxV: TG2Vec3; const Depth: Integer);
begin
  if _OcTreeRoot <> nil then OcTreeBreak;
end;

procedure TG2Scene3D.OcTreeBreak;
begin
  _OcTreeRoot := nil;
end;

function TG2Scene3D.GetStatParticleGroupCount: Integer;
begin
  Result := _ParticleGroups.Count;
end;

function TG2Scene3D.GetStatParticleCount: Integer;
begin
  Result := _Particles.Count;
end;

function TG2Scene3D.GetNodeCount: Integer;
begin
  Result := _Nodes.Count;
end;

function TG2Scene3D.GetFrameCount: Integer;
begin
  Result := _Frames.Count;
end;

function TG2Scene3D.GetMeshInstCount: Integer;
begin
  Result := _MeshInst.Count;
end;

function TG2Scene3D.GetMeshCount: Integer;
begin
  Result := _Meshes.Count;
end;

function TG2Scene3D.GetNode(const Index: Integer): TG2S3DNode;
begin
  Result := TG2S3DNode(_Nodes[Index]);
end;

function TG2Scene3D.GetFrame(const Index: Integer): TG2S3DFrame;
begin
  Result := TG2S3DFrame(_Frames[Index]);
end;

function TG2Scene3D.GetMeshInst(const Index: Integer): TG2S3DMeshInst;
begin
  Result := TG2S3DMeshInst(_MeshInst[Index]);
end;

function TG2Scene3D.GetMesh(const Index: Integer): TG2S3DMesh;
begin
  Result := TG2S3DMesh(_Meshes[Index]);
end;

procedure TG2Scene3D.RenderParticles;
  var gi, i: Integer;
  var ViewDir: TG2Vec3;
  var g: TG2S3DParticleGroup;
  var pt: TG2S3DParticle;
  var CurRender: TG2S3DParticleRender;
begin
  if _ParticleGroups.Count = 0 then Exit;
  _StatParticlesRendered := 0;
  CurRender := nil;
  ViewDir := G2Vec3(V.e02, V.e12, V.e22).Norm;
  _ParticlesSorted.Clear;
  for gi := 0 to _ParticleGroups.Count - 1 do
  begin
    g := TG2S3DParticleGroup(_ParticleGroups[gi]);
    if _Frustum.CheckBox(g.AABox) <> fcOutside then
    begin
      for i := 0 to g.Items.Count - 1 do
      begin
        pt := TG2S3DParticle(g.Items[i]);
        if pt.DepthSorted then
        _ParticlesSorted.Add(pt, ViewDir.Dot(pt.Pos))
        else
        begin
          if CurRender <> pt.ParticleRender then
          begin
            if CurRender <> nil then
            CurRender.RenderEnd;
            CurRender := pt.ParticleRender;
            CurRender.RenderBegin;
          end;
          CurRender.RenderParticle(pt);
          Inc(_StatParticlesRendered);
        end;
      end;
    end;
  end;
  for i := _ParticlesSorted.Count - 1 downto 0 do
  begin
    pt := TG2S3DParticle(_ParticlesSorted[i]);
    if CurRender <> pt.ParticleRender then
    begin
      if CurRender <> nil then
      CurRender.RenderEnd;
      CurRender := pt.ParticleRender;
      CurRender.RenderBegin;
    end;
    CurRender.RenderParticle(pt);
    Inc(_StatParticlesRendered);
  end;
  if CurRender <> nil then
  CurRender.RenderEnd;
end;

procedure TG2Scene3D.Update;
  var i, n: Integer;
  var pt: TG2S3DParticle;
  var g: TG2S3DParticleGroup;
begin
  _UpdatingParticles := True;
  for i := 0 to _ParticleGroups.Count - 1 do
  begin
    g := TG2S3DParticleGroup(_ParticleGroups[i]);
    g.AABox := TG2S3DParticle(g.Items[0]).AABox;
    g.MaxSize := 0;
  end;
  n := _Particles.Count;
  i := 0;
  while i < n do
  begin
    pt := TG2S3DParticle(_Particles[i]);
    pt.Update;
    g := TG2S3DParticle(_Particles[i]).Group;
    if pt.Dead then
    begin
      g.Items.Remove(pt);
      pt.Free;
      _Particles.Delete(i);
      if g.Items.Count < 1 then
      begin
        _ParticleGroups.Remove(g);
        g.Free;
      end;
      Dec(n);
    end
    else
    begin
      g.MaxSize := g.MaxSize + pt.Size;
      g.AABox.Merge(pt.AABox);
      Inc(i);
    end;
  end;
  for i := 0 to _ParticleGroups.Count - 1 do
  begin
    g := TG2S3DParticleGroup(_ParticleGroups[i]);
    g.MaxSize := g.MaxSize / g.Items.Count;
    g.MinSize := g.MaxSize * 0.1;
    g.MaxSize := g.MaxSize * 10;
  end;
  _UpdatingParticles := False;
  for i := 0 to _NewParticles.Count - 1 do
  ParticleAdd(TG2S3DParticle(_NewParticles[i]));
  _NewParticles.Clear;
end;

procedure TG2Scene3D.Render;
  var i, j, g, m: Integer;
  var W, VP, WVP: TG2Mat;
  var Mesh: TG2S3DMesh;
  var Inst: TG2S3DMeshInst;
  var Geom: TG2S3DMeshGeom;
  var Material: TG2S3DMeshMaterial;
  var PrevDepthEnable: Boolean;
  var VB: TG2VertexBuffer;
  var ShaderMethod: Integer;
  var Tex: array[0..1] of TG2Texture2D;
  var Shader: TG2ShaderProgram;
begin
  g2.RenderControl := nil;
  g2.Gfx.BlendMode := bmNormal;
  _Frustum.Update;
  PrevDepthEnable := g2.Gfx.DepthEnable;
  g2.Gfx.DepthEnable := True;
  gl.Enable(gl.CULL_FACE);
  VP := V * P;
  Tex[0] := nil;
  Tex[1] := nil;
  for i := 0 to _MeshInst.Count - 1 do
  begin
    Inst := TG2S3DMeshInst(_MeshInst[i]);
    Mesh := Inst.Mesh;
    if _Frustum.CheckBox(G2BoxToAABox(Inst.BBox)) <> fcOutside then
    for g := 0 to Mesh.GeomCount - 1 do
    begin
      Geom := Mesh.Geoms[g];
      if Geom.Skinned then
      begin
        VB := TG2S3DGeomDataSkinned(Geom.Data).VB;
        W := Inst.Transform;
        ShaderMethod := TG2S3DGeomDataSkinned(Geom.Data).MaxWeights;
      end
      else
      begin
        VB := TG2S3DGeomDataStatic(Geom.Data).VB;
        W := Inst.Transforms[Geom.NodeID].TransformCom * Inst.Transform;
        ShaderMethod := 0;
      end;
      WVP := G2MatTranspose(W * VP);
      Geom.IB.Bind;
      for m := 0 to Geom.GCount - 1 do
      begin
        Material := Inst.Materials[Geom.Groups[m].Material];
        if Material.ChannelCount > 0 then
        begin
          if Material.Channels[0].MapLight <> nil then
          begin
            Shader := ShaderBL[ShaderMethod];
            Shader.Use;
            gl.uniform1i(Shader.GetShaderUniform('Tex1'), 1);
            if Tex[1] <> Material.Channels[0].MapLight then
            begin
              Tex[1] := Material.Channels[0].MapLight;
              Tex[1].Bind(1);
              gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
              gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
            end;
          end
          else
          begin
            Shader := ShaderB[ShaderMethod];
            Shader.Use;
          end;
          if Material.Channels[0].MapDiffuse <> nil then
          begin
            gl.uniform1i(Shader.GetShaderUniform('Tex0'), 0);
            if Tex[0] <> Material.Channels[0].MapDiffuse then
            begin
              Tex[0] := Material.Channels[0].MapDiffuse;
              Tex[0].Bind(0);
              gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_LINEAR);
              gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
            end;
          end;
        end
        else
        begin
          Shader := ShaderB[0];
          Shader.Use;
          gl.uniform1i(Shader.GetShaderUniform('Tex0'), 0);
        end;
        if Geom.Skinned then
        begin
          for j := 0 to TG2S3DGeomDataSkinned(Geom.Data).BoneCount - 1 do
          gl.uniformMatrix4fv(
            Shader.GetShaderUniform('SkinPallete[' + IntToStr(j) + ']'),
            False, G2MatTranspose(Inst.Skins[g].Transforms[j]).ToFloat32Array
          );
        end;
        gl.uniformMatrix4fv(Shader.GetShaderUniform('WVP'), False, WVP.ToFloat32Array);
        gl.uniform4fv(Shader.GetShaderUniform('LightAmbient'), _Ambient.ToFloat32Array);
        VB.Bind;
        gl.DrawElements(
          gl.TRIANGLES,
          Geom.Groups[m].FaceCount * 3,
          gl.UNSIGNED_SHORT,
          Geom.Groups[m].FaceStart * 6
        );
        VB.Unbind;
      end;
      Geom.IB.Unbind;
    end;
  end;
  gl.Disable(gl.CULL_FACE);
  g2.Gfx.DepthEnable := PrevDepthEnable;
  RenderParticles;
end;

procedure TG2Scene3D.Build;
begin

end;

procedure TG2Scene3D.ParticleAdd(const Particle: TG2S3DParticle);
  var i, n: Integer;
  var Bounds: TG2AABox;
  var g: TG2S3DParticleGroup;
  var ps: TG2Float;
begin
  if _UpdatingParticles then
  begin
    _NewParticles.Add(Particle);
    Exit;
  end;
  _Particles.Add(Particle);
  n := -1;
  for i := 0 to _ParticleRenders.Count - 1 do
  if TG2S3DParticleRender(_ParticleRenders[i]) is Particle.RenderClass then
  begin
    n := i;
    Break;
  end;
  if n = -1 then
  begin
    n := _ParticleRenders.Count;
    _ParticleRenders.Add(Particle.RenderClass.Create(Self));
  end;
  Particle.ParticleRender := TG2S3DParticleRender(_ParticleRenders[n]);
  ps := Particle.Size * 2;
  Bounds.MinV.x := Particle.Pos.x - ps;
  Bounds.MinV.y := Particle.Pos.y - ps;
  Bounds.MinV.z := Particle.Pos.z - ps;
  Bounds.MaxV.x := Particle.Pos.x + ps;
  Bounds.MaxV.y := Particle.Pos.y + ps;
  Bounds.MaxV.z := Particle.Pos.z + ps;
  g := nil;
  for i := 0 to _ParticleGroups.Count - 1 do
  if (Particle.Size >= TG2S3DParticleGroup(_ParticleGroups[i]).MinSize)
  and (Particle.Size <= TG2S3DParticleGroup(_ParticleGroups[i]).MaxSize)
  and (Bounds.Intersect(TG2S3DParticleGroup(_ParticleGroups[i]).AABox)) then
  begin
    g := TG2S3DParticleGroup(_ParticleGroups[i]);
    g.MaxSize := (g.MaxSize * 0.1 * g.Items.Count + Particle.Size) / (g.Items.Count + 1);
    g.MinSize := g.MaxSize * 0.1;
    g.MaxSize := g.MaxSize * 10;
    g.Items.Add(Particle);
    g.AABox.Merge(Particle.AABox);
    Particle.Group := g;
    Exit;
  end;
  g := TG2S3DParticleGroup.Create;
  _ParticleGroups.Add(g);
  g.Items.Clear;
  g.Items.Add(Particle);
  g.AABox := Particle.AABox;
  g.MinSize := Particle.Size * 0.1;
  g.MaxSize := Particle.Size * 0.1;
  Particle.Group := g;
end;

function TG2Scene3D.FindTexture(const TextureName: String; Usage: TG2TextureUsage = tuDefault): TG2Texture2D;
  var i: Integer;
  var pt: TG2S3DTexture;
begin
  for i := 0 to _Textures.Count - 1 do
  if TG2S3DTexture(_Textures[i]).Name = TextureName then
  begin
    Result := TG2S3DTexture(_Textures[i]).Texture;
    Exit;
  end;
  pt := TG2S3DTexture.Create;
  pt.Name := TextureName;
  pt.Texture := TG2Texture2D.Create;
  pt.Texture.Load(TextureName, Usage);
  _Textures.Add(pt);
  Result := pt.Texture;
end;

constructor TG2Scene3D.Create;
begin
  inherited Create;
  gl := g2.Gfx.gl;
  Parent := g2;
  _Frustum.RefV := V.CopyRef;
  _Frustum.RefP := P.CopyRef;
  _Textures.Clear;
  _Nodes.Clear;
  _Frames.Clear;
  _MeshInst.Clear;
  _Meshes.Clear;
  _Particles.Clear;
  _NewParticles.Clear;
  _ParticleGroups.Clear;
  _ParticleRenders.Clear;
  _OcTreeRoot := nil;
  _UpdatingParticles := False;
  _StatParticlesRendered := 0;
  _Ambient := G2Vec4($14/$ff, $14/$ff, $14/$ff, 1);
  ShaderB[0] := TG2ShaderProgram.Create; ShaderB[0].Parent := Self; ShaderB[0].Compile(VS_SceneB0, PS_Scene);
  ShaderB[1] := TG2ShaderProgram.Create; ShaderB[1].Parent := Self; ShaderB[1].Compile(VS_SceneB1, PS_Scene);
  ShaderB[2] := TG2ShaderProgram.Create; ShaderB[2].Parent := Self; ShaderB[2].Compile(VS_SceneB2, PS_Scene);
  ShaderB[3] := TG2ShaderProgram.Create; ShaderB[3].Parent := Self; ShaderB[3].Compile(VS_SceneB3, PS_Scene);
  ShaderB[4] := TG2ShaderProgram.Create; ShaderB[4].Parent := Self; ShaderB[4].Compile(VS_SceneB4, PS_Scene);
  ShaderBL[0] := TG2ShaderProgram.Create; ShaderBL[0].Parent := Self; ShaderBL[0].Compile(VS_SceneB0L, PS_SceneL);
  ShaderBL[1] := TG2ShaderProgram.Create; ShaderBL[1].Parent := Self; ShaderBL[1].Compile(VS_SceneB1L, PS_SceneL);
  ShaderBL[2] := TG2ShaderProgram.Create; ShaderBL[2].Parent := Self; ShaderBL[2].Compile(VS_SceneB2L, PS_SceneL);
  ShaderBL[3] := TG2ShaderProgram.Create; ShaderBL[3].Parent := Self; ShaderBL[3].Compile(VS_SceneB3L, PS_SceneL);
  ShaderBL[4] := TG2ShaderProgram.Create; ShaderBL[4].Parent := Self; ShaderBL[4].Compile(VS_SceneB4L, PS_SceneL);
  ShaderParticles := TG2ShaderProgram.Create; ShaderParticles.Parent := Self; ShaderParticles.Compile(VS_SceneParticles, PS_SceneParticles);
end;

destructor TG2Scene3D.Destroy;
  var i: Integer;
begin
//  for i := 0 to _NewParticles.Count - 1 do
//  TG2S3DParticle(_NewParticles[i]).Free;
//  _NewParticles.Clear;
//  for i := 0 to _Particles.Count - 1 do
//  TG2S3DParticle(_Particles[i]).Free;
//  _Particles.Clear;
//  for i := 0 to _ParticleGroups.Count - 1 do
//  Dispose(PG2S3DParticleGroup(_ParticleGroups[i]));
//  _ParticleGroups.Clear;
//  for i := 0 to _ParticleRenders.Count - 1 do
//  TG2S3DParticleRender(_ParticleRenders[i]).Free;
//  _ParticleRenders.Clear;
  while _Nodes.Count > 0 do
  TG2S3DNode(_Nodes[0]).Free;
  while _Meshes.Count > 0 do
  TG2S3DMesh(_Meshes[0]).Free;
  for i := 0 to _Textures.Count - 1 do
  begin
    TG2S3DTexture(_Textures[i]).Texture.Free;
    TG2S3DTexture(_Textures[i]).Free;
  end;
  _Textures.Clear;
  inherited Destroy;
end;
//TG2Scene3D END

procedure G2TypedArrayCopy(const Src, Dst: JTypedArray; const SrcStart, DstStart, Size: Integer);
begin
  asm
    var DstU8 = new Uint8Array(@Dst, @DstStart, @Size);
    var SrcU8 = new Uint8Array(@Src, @SrcStart, @Size);
    DstU8.set(SrcU8);
  end;
end;

function G2NewVariant: Variant;
begin
  asm
    @Result = {};
  end;
end;

initialization

begin
  g2 := TG2Core.Create;
end;

finalization

end.
