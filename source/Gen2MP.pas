unit Gen2MP;
{$include Gen2MP.inc}
{$if defined(G2Cpu386)}
  {$message 'CPU i386'}
{$endif}
{$if defined(G2Target_Windows)}
  {$message 'Target Windows'}
{$elseif defined(G2Target_Linux)}
  {$message 'Target Linux'}
{$elseif defined(G2Target_OSX)}
  {$message 'Target OSX'}
{$elseif defined(G2Target_Android)}
  {$message 'Target Android'}
{$elseif defined(G2Target_iOS)}
  {$message 'Target iOS'}
  {$modeswitch objectivec1}
  {$linkframework OpenGLES}
  {$linkframework QuartzCore}
  {$linkframework UIKit}
  {$linkframework Foundation}
{$else}
  {$message 'Target Undefined'}
{$endif}
{$if defined(G2Gfx_D3D9)}
  {$message 'Graphics API Direct3D9'}
{$elseif defined(G2Gfx_OGL)}
  {$message 'Graphics API OpenGL'}
{$elseif defined(G2Gfx_GLES)}
  {$message 'Graphics API OpenGL ES'}
{$else}
  {$message 'Graphics API Undefined'}
{$endif}
{$if defined(G2Snd_DS)}
  {$message 'Sound API DirectSound'}
{$elseif defined(G2Snd_OAL)}
  {$message 'Sound API OpenAL'}
{$else}
  {$message 'Sound API Undefined'}
{$endif}
{$if defined(G2RM_FF)}
  {$message 'Render Mode FF'}
{$elseif defined(G2RM_SM2)}
  {$message 'Render Mode SM2'}
{$endif}
interface

uses
  {$if defined(G2Target_Linux) or defined(G2Target_OSX)}
    cthreads,
  {$endif}
  {$if defined(G2Target_Windows)}
    Windows,
  {$elseif defined(G2Target_Linux)}
    X,
    XLib,
    XUtil,
    gdk2,
    pango,
  {$elseif defined(G2Target_OSX)}
    MacOSAll,
  {$elseif defined(G2Target_Android)}
    G2AndroidJNI,
    G2AndroidBinding,
    G2AndroidLog,
  {$elseif defined(G2Target_iOS)}
    iPhoneAll,
    CGGeometry,
  {$endif}
  {$if defined(G2Gfx_D3D9)}
    G2DirectX9,
  {$elseif defined(G2Gfx_OGL)}
    G2OpenGL,
  {$elseif defined(G2Gfx_GLES)}
    {$if defined(G2RM_FF)}
      {$if defined(G2Target_Android)}
        G2OpenGLES11,
      {$elseif defined(G2Target_iOS)}
        OpenGLES11_iOS,
      {$endif}
    {$elseif defined(G2RM_SM2)}
      {$if defined(G2Target_Android)}
        G2OpenGLES20,
      {$elseif defined(G2Target_iOS)}
        OpenGLES20_iOS,
      {$endif}
    {$endif}
  {$endif}
  {$if defined(G2Snd_OAL)}
    {$ifdef G2Target_Android}
      G2OpenALTypes,
      G2OpenAL_Android,
    {$else}
    G2OpenAL,
  {$endif}
  {$elseif defined(G2Snd_DS)}
    G2DirectSound,
    ActiveX,
  {$endif}
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  G2Image,
  G2ImagePNG,
  G2Audio,
  G2AudioWAV,
  G2MeshData,
  {$if defined(G2RM_SM2)}
    G2Shaders,
  {$endif}
  Types,
  Classes,
  SysUtils;

type
  TG2Core = class;
  TG2Window = class;
  TG2Params = class;
  TG2Sys = class;
  TG2Gfx = class;
  {$if defined(G2Gfx_D3D9)}
  TG2GfxD3D9 = class;
  {$elseif defined(G2Gfx_OGL)}
  TG2GfxOGL = class;
  {$endif}
  TG2Snd = class;
  {$if defined(G2Snd_OAL)}
  TG2SndOAL = class;
  {$elseif defined(G2Snd_DS)}
  TG2SndDS = class;
  {$elseif defined(G2Snd_OSL)}
  TG2SndOSL = class;
  {$endif}
  {$ifdef G2Threading}
  TG2Updater = class;
  TG2Renderer = class;
  {$endif}
  TG2TextureBase = class;
  TG2Texture2DBase = class;
  TG2Texture2D = class;
  TG2Texture2DRT = class;
  TG2Font = class;
  {$if defined(G2RM_SM2)}
  TG2ShaderGroup = class;
  {$endif}
  TG2RenderControl = class;
  TG2RenderControlStateChange = class;
  TG2RenderControlManaged = class;
  {$if defined(G2RM_SM2)}
  TG2RenderControlBuffer = class;
  {$endif}
  TG2RenderControlLegacyMesh = class;
  TG2RenderControlPic2D = class;
  TG2RenderControlPrim2D = class;
  TG2RenderControlPrim3D = class;
  TG2RenderControlPoly2D = class;
  TG2RenderControlPoly3D = class;
  TG2VertexBuffer = class;
  TG2IndexBuffer = class;
  TG2Display2D = class;
  {$if defined(G2RM_SM2)}
  TG2Mesh = class;
  TG2MeshInst = class;
  {$endif}
  TG2LegacyMesh = class;
  TG2LegacyMeshInst = class;
  TG2S3DMesh = class;
  TG2S3DMeshInst = class;
  TG2S3DParticle = class;
  TG2Scene3D = class;
  TG2CustomTimer = class;

  TG2Proc = procedure;
  TG2ProcObj = procedure of Object;
  TG2ProcPtr = procedure (const Ptr: Pointer);
  TG2ProcPtrObj = procedure (const Ptr: Pointer) of Object;
  TG2ProcWndMessage = procedure (const Param1, Param2, Param3: TG2IntS32) of Object;
  TG2ProcChar = procedure (const c: AnsiChar);
  TG2ProcCharObj = procedure (const c: AnsiChar) of Object;
  TG2ProcKey = procedure (const Key: TG2IntS32);
  TG2ProcKeyObj = procedure (const Key: TG2IntS32) of Object;
  TG2ProcMouse = procedure (const Button, x, y: TG2IntS32);
  TG2ProcMouseObj = procedure (const Button, x, y: TG2IntS32) of Object;
  TG2ProcScroll = procedure (const y: TG2IntS32);
  TG2ProcScrollObj = procedure (const y: TG2IntS32) of Object;
  TG2ProcResize = procedure (const PrevWidth, PrevHeight, NewWidth, NewHeight: TG2IntS32);
  TG2ProcResizeObj = procedure (const PrevWidth, PrevHeight, NewWidth, NewHeight: TG2IntS32) of Object;
  TG2ProcInt = procedure (const v: Integer);
  TG2ProcIntObj = procedure (const v: Integer) of Object;
  TG2ProcString = procedure (const s: AnsiString);
  TG2ProcStringObj = procedure (const s: AnsiString) of Object;

  CG2RenderControl = class of TG2RenderControl;

  TG2TextureUsage = (
    tuDefault,
    tu2D,
    tu3D
  );

  TG2Filter = (
    tfNone = 0,
    tfPoint = 1,
    tfLinear = 2
  );

  TG2PrimType = (
    ptNone,
    ptLines,
    ptTriangles
  );

  {$ifdef G2Target_Android}
  TG2AndroidMessageType = (
    amConnect = 0,
    amInit = 1,
    amQuit = 2,
    amResize = 3,
    amDraw = 4,
    amTouchDown = 5,
    amTouchUp = 6,
    amTouchMove = 7
  );
  {$endif}

  {$if defined(G2Target_iOS)}
  TG2OpenGLView = objcclass(UIView)
  public
    class function layerClass: Pobjc_class; override;
    function initWithFrame(frame: CGRect): id; override;
    procedure dealloc; override;
    procedure setupLayer; message 'setupLayer';
    procedure setupContext; message 'setupContext';
    procedure setupRenderBuffer; message 'setupRenderBuffer';
    procedure setupFrameBuffer; message 'setupFrameBuffer';
    procedure render; message 'render';
  end;

  TG2AppDelegate = objcclass(UIResponder, UIApplicationDelegateProtocol)
  private
    _Window: UIWindow;
  public
    procedure Loop; message 'Loop';
    function applicationDidFinishLaunchingWithOptions(application: UIApplication; launchOptions: NSDictionary): Boolean; message 'application:didFinishLaunchingWithOptions:';
    procedure applicationWillResignActive(application: UIApplication); message 'applicationWillResignActive:';
    procedure applicationDidEnterBackground(application: UIApplication); message 'applicationDidEnterBackground:';
    procedure applicationWillEnterForeground(application: UIApplication); message 'applicationWillEnterForeground:';
    procedure applicationDidBecomeActive(application: UIApplication); message 'applicationDidBecomeActive:';
    procedure applicationWillTerminate(application: UIApplication); message 'applicationWillTerminate:';
    procedure dealloc; override;
  end;

  TG2ViewController = objcclass(UIViewController)
  public
    function initWithNibName_bundle(nibNameOrNil: NSString; nibBundleOrNil: NSBundle): id; override;
    procedure dealloc; override;
    procedure didReceiveMemoryWarning; override;
    procedure loadView; override;
    //procedure viewDidLoad; override;
    procedure viewDidUnload; override;
    function shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation): Boolean; override;
  end;
  {$endif}

  TG2LinkProc = record
    Obj: Boolean;
    Proc: TG2Proc;
    ProcObj: TG2ProcObj;
  end;
  PG2LinkProc = ^TG2LinkProc;
  TG2LinkProcList = specialize TG2QuickListG<PG2LinkProc>;
  TG2LinkRenderList = specialize TG2QuickSortListG<PG2LinkProc>;

  TG2LinkUpdate = record
    Obj: Boolean;
    Proc: TG2Proc;
    ProcObj: TG2ProcObj;
    Enabled: Boolean;
  end;
  PG2LinkUpdate = ^TG2LinkUpdate;
  TG2LinkUpdateList = specialize TG2QuickListG<PG2LinkUpdate>;

  TG2LinkPrint = record
    Obj: Boolean;
    Proc: TG2ProcChar;
    ProcObj: TG2ProcCharObj;
  end;
  PG2LinkPrint = ^TG2LinkPrint;
  TG2LinkPrintList = specialize TG2QuickListG<PG2LinkPrint>;

  TG2LinkKey = record
    Obj: Boolean;
    Proc: TG2ProcKey;
    ProcObj: TG2ProcKeyObj;
  end;
  PG2LinkKey = ^TG2LinkKey;
  TG2LinkKeyList = specialize TG2QuickListG<PG2LinkKey>;

  TG2LinkMouse = record
    Obj: Boolean;
    Proc: TG2ProcMouse;
    ProcObj: TG2ProcMouseObj;
  end;
  PG2LinkMouse = ^TG2LinkMouse;
  TG2LinkMouseList = specialize TG2QuickListG<PG2LinkMouse>;

  TG2LinkScroll = record
    Obj: Boolean;
    Proc: TG2ProcScroll;
    ProcObj: TG2ProcScrollObj;
  end;
  PG2LinkScroll = ^TG2LinkScroll;
  TG2LinkScrollList = specialize TG2QuickListG<PG2LinkScroll>;

  TG2LinkResize = record
    Obj: Boolean;
    Proc: TG2ProcResize;
    ProcObj: TG2ProcResizeObj;
  end;
  PG2LinkResize = ^TG2LinkResize;
  TG2LinkResizeList = specialize TG2QuickListG<PG2LinkResize>;

  TG2Log = class
  private
    {$if defined(G2Log)}
    var _LogFile: TextFile;
    {$endif}
  public
    constructor Create;
    destructor Destroy; override;
    procedure Write(const LogMessage: String); inline;
    procedure WriteLn(const LogMessage: String); inline;
  end;

  TG2CustomTimerFunc = function (const PrevInterval: TG2IntS32): TG2IntS32;
  TG2CustomTimerFuncObj = function (const PrevInterval: TG2IntS32): TG2IntS32 of Object;

  TG2CustomTimer = class
  private
    var _Interval: TG2IntS32;
    var _TimeLeft: TG2Float;
    var _Obj: Boolean;
    var _Func: TG2CustomTimerFunc;
    var _FuncObj: TG2CustomTimerFuncObj;
  public
    constructor Create(const NewFunc: TG2CustomTimerFunc; const NewInterval: TG2IntS32);
    constructor Create(const NewFunc: TG2CustomTimerFuncObj; const NewInterval: TG2IntS32);
    function Update: Boolean;
  end;

  TG2CustomTimerList = specialize TG2QuickListG<TG2CustomTimer>;

  TG2TargetPlatform = (tpUndefined, tpWindows, tpLinux, tpMacOSX, tpAndroid, tpiOS);

  TG2Core = class
  private
    _Started: Boolean;
    _Window: TG2Window;
    _Params: TG2Params;
    _Sys: TG2Sys;
    _Gfx: TG2Gfx;
    _Snd: TG2Snd;
    _Log: TG2Log;
    _PackLinker: TG2PackLinker;
    _AssetSourceManager: TG2AssetSourceManager;
    {$ifdef G2Threading}
    _Updater: TG2Updater;
    _Renderer: TG2Renderer;
    {$endif}
    _FPS: TG2IntS32;
    _UpdatePrevTime: TG2IntU32;
    _UpdateCount: TG2Float;
    _TargetUPS: TG2IntS32;
    _MaxFPS: TG2IntS32;
    _RenderPrevTime: TG2IntU32;
    _FrameCount: TG2IntS32;
    _FPSUpdateTime: TG2IntU32;
    _CanRender: Boolean;
    _Platform: TG2TargetPlatform;
    _LinkInitialize: TG2LinkProcList;
    _LinkFinalize: TG2LinkProcList;
    _LinkUpdate: TG2LinkUpdateList;
    _LinkRender: TG2LinkRenderList;
    _LinkPrint: TG2LinkPrintList;
    _LinkKeyDown: TG2LinkKeyList;
    _LinkKeyUp: TG2LinkKeyList;
    _LinkMouseDown: TG2LinkMouseList;
    _LinkMouseUp: TG2LinkMouseList;
    _LinkScroll: TG2LinkScrollList;
    _LinkResize: TG2LinkResizeList;
    _CustomTimers: TG2CustomTimerList;
    _KeyDown: array[0..255] of Boolean;
    _MBDown: array[0..31] of Boolean;
    _MDPos: array[0..31] of TPoint;
    _ShowCursor: Boolean;
    _AppPath: String;
    _Pause: Boolean;
    {$if defined(G2Target_iOS)}
    _PoolInitialized: Boolean;
    _Delegate: TG2AppDelegate;
    _ViewController: TG2ViewController;
    {$endif}
    {$if defined(G2Target_Android) or defined(G2Target_iOS)}
    _CursorPos: TPoint;
    {$endif}
    procedure Render;
    procedure Update;
    procedure UpdateRender;
    procedure OnRender;
    procedure OnUpdate;
    procedure OnLoop;
    procedure OnStop;
    procedure OnPrint(const Char: AnsiChar);
    procedure OnKeyDown(const Key: TG2IntS32);
    procedure OnKeyUp(const Key: TG2IntS32);
    procedure OnMouseDown(const Button: TG2IntS32; const x, y: TG2IntS32);
    procedure OnMouseUp(const Button: TG2IntS32; const x, y: TG2IntS32);
    procedure OnScroll(const y: TG2IntS32);
    procedure OnResize(const PrevWidth, PrevHeight, NewWidth, NewHeight: TG2IntS32);
    function GetKeyDown(const Index: TG2IntS32): Boolean; inline;
    function GetMouseDown(const Index: TG2IntS32): Boolean; inline;
    function GetMouseDownPos(const Index: TG2IntS32): TPoint; inline;
    function GetMousePos: TPoint;
    function GetAppPath: String;
    procedure SetShowCursor(const Value: Boolean);
    procedure SetPause(const Value: Boolean);
    function GetDeltaTime: TG2Float; inline;
    function GetDeltaTimeSec: TG2Float; inline;
    function GetRenderTarget: TG2Texture2DRT; inline;
    procedure SetRenderTarget(const Value: TG2Texture2DRT); inline;
  public
    property Window: TG2Window read _Window;
    property Params: TG2Params read _Params;
    property Sys: TG2Sys read _Sys;
    property Gfx: TG2Gfx read _Gfx;
    property Snd: TG2Snd read _Snd;
    property Log: TG2Log read _Log;
    property PackLinker: TG2PackLinker read _PackLinker;
    property AssetSourceManager: TG2AssetSourceManager read _AssetSourceManager;
    property FPS: TG2IntS32 read _FPS;
    property AppPath: String read _AppPath;
    property TargetPlatform: TG2TargetPlatform read _Platform;
    property KeyDown[const Index: TG2IntS32]: Boolean read GetKeyDown;
    property MouseDown[const Index: TG2IntS32]: Boolean read GetMouseDown;
    property MouseDownPos[const Index: TG2IntS32]: TPoint read GetMouseDownPos;
    property MousePos: TPoint read GetMousePos;
    property ShowCursor: Boolean read _ShowCursor write SetShowCursor;
    property Pause: Boolean read _Pause write SetPause;
    property DeltaTimeMs: TG2Float read GetDeltaTime;
    property DeltaTimeSec: TG2Float read GetDeltaTimeSec;
    property RenderTarget: TG2Texture2DRT read GetRenderTarget write SetRenderTarget;
    {$if defined(G2Target_iOS)}
    property Delegate: TG2AppDelegate read _Delegate write _Delegate;
    {$endif}
    procedure Start;
    procedure Stop;
    {$if defined(G2Target_Android)}
    class procedure AndroidMessage(const Env: PJNIEnv; const Obj: JObject; const MessageType, Param0, Param1, Param2: TG2IntS32);
    {$endif}
    procedure CallbackInitializeAdd(const ProcInitialize: TG2Proc); overload;
    procedure CallbackInitializeAdd(const ProcInitialize: TG2ProcObj); overload;
    procedure CallbackInitializeRemove(const ProcInitialize: TG2Proc); overload;
    procedure CallbackInitializeRemove(const ProcInitialize: TG2ProcObj); overload;
    procedure CallbackFinalizeAdd(const ProcFinalize: TG2Proc); overload;
    procedure CallbackFinalizeAdd(const ProcFinalize: TG2ProcObj); overload;
    procedure CallbackFinalizeRemove(const ProcFinalize: TG2Proc); overload;
    procedure CallbackFinalizeRemove(const ProcFinalize: TG2ProcObj); overload;
    procedure CallbackUpdateAdd(const ProcUpdate: TG2Proc); overload;
    procedure CallbackUpdateAdd(const ProcUpdate: TG2ProcObj); overload;
    procedure CallbackUpdateRemove(const ProcUpdate: TG2Proc); overload;
    procedure CallbackUpdateRemove(const ProcUpdate: TG2ProcObj); overload;
    procedure CallbackRenderAdd(const ProcRender: TG2Proc; const Order: TG2Float = 0); overload;
    procedure CallbackRenderAdd(const ProcRender: TG2ProcObj; const Order: TG2Float = 0); overload;
    procedure CallbackRenderRemove(const ProcRender: TG2Proc); overload;
    procedure CallbackRenderRemove(const ProcRender: TG2ProcObj); overload;
    procedure CallbackPrintAdd(const ProcPrint: TG2ProcChar); overload;
    procedure CallbackPrintAdd(const ProcPrint: TG2ProcCharObj); overload;
    procedure CallbackPrintRemove(const ProcPrint: TG2ProcChar); overload;
    procedure CallbackPrintRemove(const ProcPrint: TG2ProcCharObj); overload;
    procedure CallbackKeyDownAdd(const ProcKeyDown: TG2ProcKey); overload;
    procedure CallbackKeyDownAdd(const ProcKeyDown: TG2ProcKeyObj); overload;
    procedure CallbackKeyDownRemove(const ProcKeyDown: TG2ProcKey); overload;
    procedure CallbackKeyDownRemove(const ProcKeyDown: TG2ProcKeyObj); overload;
    procedure CallbackKeyUpAdd(const ProcKeyUp: TG2ProcKey); overload;
    procedure CallbackKeyUpAdd(const ProcKeyUp: TG2ProcKeyObj); overload;
    procedure CallbackKeyUpRemove(const ProcKeyUp: TG2ProcKey); overload;
    procedure CallbackKeyUpRemove(const ProcKeyUp: TG2ProcKeyObj); overload;
    procedure CallbackMouseDownAdd(const ProcMouseDown: TG2ProcMouse); overload;
    procedure CallbackMouseDownAdd(const ProcMouseDown: TG2ProcMouseObj); overload;
    procedure CallbackMouseDownRemove(const ProcMouseDown: TG2ProcMouse); overload;
    procedure CallbackMouseDownRemove(const ProcMouseDown: TG2ProcMouseObj); overload;
    procedure CallbackMouseUpAdd(const ProcMouseUp: TG2ProcMouse); overload;
    procedure CallbackMouseUpAdd(const ProcMouseUp: TG2ProcMouseObj); overload;
    procedure CallbackMouseUpRemove(const ProcMouseUp: TG2ProcMouse); overload;
    procedure CallbackMouseUpRemove(const ProcMouseUp: TG2ProcMouseObj); overload;
    procedure CallbackScrollAdd(const ProcScroll: TG2ProcScroll); overload;
    procedure CallbackScrollAdd(const ProcScroll: TG2ProcScrollObj); overload;
    procedure CallbackScrollRemove(const ProcScroll: TG2ProcScroll); overload;
    procedure CallbackScrollRemove(const ProcScroll: TG2ProcScrollObj); overload;
    procedure CallbackResizeAdd(const ProcResize: TG2ProcResize); overload;
    procedure CallbackResizeAdd(const ProcResize: TG2ProcResizeObj); overload;
    procedure CallbackResizeRemove(const ProcResize: TG2ProcResize); overload;
    procedure CallbackResizeRemove(const ProcResize: TG2ProcResizeObj); overload;
    procedure CustomTimer(const Func: TG2CustomTimerFuncObj; const IntervalMs: TG2IntS32); overload;
    procedure CustomTimer(const Func: TG2CustomTimerFunc; const IntervalMs: TG2IntS32); overload;
    procedure PicQuadCol(
      const Pos0, Pos1, Pos2, Pos3, Tex0, Tex1, Tex2, Tex3: TG2Vec2;
      const Col0, Col1, Col2, Col3: TG2Color;
      const Texture: TG2Texture2DBase; const BlendMode: TG2IntU32 = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicQuadCol(
      const x0, y0, x1, y1, x2, y2, x3, y3, tu0, tv0, tu1, tv1, tu2, tv2, tu3, tv3: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicQuad(
      const Pos0, Pos1, Pos2, Pos3, Tex0, Tex1, Tex2, Tex3: TG2Vec2;
      const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicQuad(
      const x0, y0, x1, y1, x2, y2, x3, y3, tu0, tv0, tu1, tv1, tu2, tv2, tu3, tv3: TG2Float;
      const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const Pos: TG2Vec2;
      const Width, Height: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const TexRect: TG2Vec4;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const x, y: TG2Float;
      const Width, Height: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const tu0, tv0, tu1, tv1: TG2Float;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const Pos: TG2Vec2;
      const Width, Height: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const x, y: TG2Float;
      const Width, Height: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const Pos: TG2Vec2;
      const Col0, Col1, Col2, Col3: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const x, y: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const Pos: TG2Vec2;
      const Width, Height: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const FrameWidth, FrameHeight: TG2IntS32;
      const FrameID: TG2IntS32;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const x, y: TG2Float;
      const Width, Height: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const FrameWidth, FrameHeight: TG2IntS32;
      const FrameID: TG2IntS32;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const Pos: TG2Vec2; const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const x, y: TG2Float; const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const Pos: TG2Vec2;
      const Width, Height: TG2Float;
      const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const x, y: TG2Float;
      const Width, Height: TG2Float;
      const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const Pos: TG2Vec2;
      const Width, Height: TG2Float;
      const TexRect: TG2Vec4;
      const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const x, y: TG2Float;
      const Width, Height: TG2Float;
      const tu0, tv0, tu1, tv1: TG2Float;
      const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const Pos: TG2Vec2;
      const Width, Height: TG2Float;
      const Col: TG2Color;
      const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const FrameWidth, FrameHeight: TG2IntS32;
      const FrameID: TG2IntS32;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const x, y: TG2Float;
      const Width, Height: TG2Float;
      const Col: TG2Color;
      const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const FrameWidth, FrameHeight: TG2IntS32;
      const FrameID: TG2IntS32;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PrimBegin(const PrimType: TG2PrimType; const BlendMode: TG2BlendMode); inline;
    procedure PrimEnd; inline;
    procedure PrimAdd(const x, y: TG2Float; const Color: TG2Color); inline;
    procedure PrimAdd(const Pos: TG2Vec2; const Color: TG2Color); inline;
    procedure PrimLineCol(const Pos0, Pos1: TG2Vec2; const Col0, Col1: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimLineCol(const x0, y0, x1, y1: TG2Float; const Col0, Col1: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimLine(const Pos0, Pos1: TG2Vec2; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimLine(const x0, y0, x1, y1: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimTriCol(const Pos0, Pos1, Pos2: TG2Vec2; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimTriCol(const x0, y0, x1, y1, x2, y2: TG2Float; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimQuadCol(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimQuadCol(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimQuad(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimQuad(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimRectCol(const x, y, w, h: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
    procedure PrimRect(const x, y, w, h: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
    procedure PrimRectHollowCol(const x, y, w, h: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
    procedure PrimRectHollow(const x, y, w, h: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
    procedure PrimCircleCol(const Pos: TG2Vec2; const Radius: TG2Float; const Col0, Col1: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimCircleCol(const x, y, Radius: TG2Float; const Col0, Col1: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimTriHollowCol(const Pos0, Pos1, Pos2: TG2Vec2; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimTriHollowCol(const x0, y0, x1, y1, x2, y2: TG2Float; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimQuadHollowCol(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimQuadHollowCol(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimCircleHollow(const Pos: TG2Vec2; const Radius: TG2Float; const Col: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimCircleHollow(const x, y, Radius: TG2Float; const Col: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PolyBegin(const PolyType: TG2PrimType; const Texture: TG2Texture2DBase; const BlendMode: TG2BlendModeRef = bmNormal; const Filter: TG2Filter = tfPoint);
    procedure PolyEnd;
    procedure PolyAdd(const x, y, u, v: TG2Float; const Color: TG2Color); inline; overload;
    procedure PolyAdd(const Pos, TexCoord: TG2Vec2; const Color: TG2Color); inline; overload;
    procedure Prim3DBegin(const PrimType: TG2PrimType; const BlendMode: TG2BlendMode; const WVP: TG2Mat); inline;
    procedure Prim3DEnd; inline;
    procedure Prim3DAdd(const x, y, z: TG2Float; const Color: TG2Color); inline;
    procedure Prim3DAdd(const Pos: TG2Vec3; const Color: TG2Color); inline;
    procedure Prim3DAddTri(const v0, v1, v2: TG2Vec3; const c0, c1, c2: TG2Color); inline;
    procedure Prim3DAddQuad(const v0, v1, v2, v3: TG2Vec3; const c0, c1, c2, c3: TG2Color); inline;
    procedure Poly3DBegin(const PolyType: TG2PrimType; const Texture: TG2Texture2DBase; const WVP: TG2Mat; const BlendMode: TG2BlendModeRef = bmNormal; const Filter: TG2Filter = tfPoint); inline;
    procedure Poly3DEnd; inline;
    procedure Poly3DAdd(const x, y, z, u, v: TG2Float; const Color: TG2Color); inline;
    procedure Poly3DAdd(const Pos: TG2Vec3; const TexCoord: TG2Vec2; const Color: TG2Color); inline;
    procedure Poly3DAddQuad(const p0, p1, p2, p3: TG2Vec3; const t0, t1, t2, t3: TG2Vec2; const c0, c1, c2, c3: TG2Color); inline;
    procedure Clear(const Color: TG2Color); overload; inline;
    procedure Clear(
      const Color: Boolean; const ColorValue: TG2Color;
      const Depth: Boolean = True; const DepthValue: TG2Float = 1;
      const Stencil: Boolean = False; const StencilValue: TG2IntU8 = 0
    ); overload; inline;
    constructor Create;
    destructor Destroy; override;
  end;

  TG2ThreadState = (tsIdle, tsRunning, tsFinished);

  TG2Thread = class
  private
    _ThreadHandle: TThreadID;
    _ThreadID: TThreadID;
    _State: TG2ThreadState;
    _Proc: TG2ProcObj;
    procedure Run;
  protected
    procedure Execute; virtual;
  public
    property ThreadID: TThreadID read _ThreadID;
    property State: TG2ThreadState read _State;
    property Proc: TG2ProcObj read _Proc write _Proc;
    constructor Create;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    procedure WaitFor(const Timeout: TG2IntU32 = $ffffffff);
  end;

  TG2CriticalSection = object
  private
    _CS: TRTLCriticalSection;
  public
    procedure Initialize;
    procedure Finalize;
    procedure Enter;
    procedure Leave;
  end;

  TG2WindowMessage = record
    MessageProc: TG2ProcWndMessage;
    Param1: TG2IntS32;
    Param2: TG2IntS32;
    Param3: TG2IntS32;
  end;

  TG2ScreenMode = (smWindow, smMaximized, smFullscreen);

  {$if defined(G2Target_Windows)}
  TG2Cursor = HCursor;
  {$elseif defined(G2Target_Linux)}
  TG2Cursor = TCursor;
  {$endif}

  TG2Window = class
  private
    {$if defined(G2Target_Windows)}
    _Handle: THandle;
    _ProcessResize: Boolean;
    {$elseif defined(G2Target_Linux)}
    _Display: PDisplay;
    _Handle: TWindow;
    _WMDelete: TAtom;
    _VisualInfo: PXVisualInfo;
    {$elseif defined(G2Target_OSX)}
    _Handle: WindowRef;
    {$elseif defined(G2Target_iOS)}
    _View: TG2OpenGLView;
    {$endif}
    {$if not defined(G2Target_Mobile)}
    _CursorArrow: TG2Cursor;
    _CursorText: TG2Cursor;
    _CursorHand: TG2Cursor;
    _CursorSizeNS: TG2Cursor;
    _CursorSizeWE: TG2Cursor;
    _Cursor: TG2Cursor;
    {$endif}
    _Loop: Boolean;
    _Caption: AnsiString;
    _MessageStack: array of TG2WindowMessage;
    _MessageCount: TG2IntS32;
    procedure AddMessage(const MessageProc: TG2ProcWndMessage; const Param1, Param2, Param3: TG2IntS32);
    procedure ProcessMessages;
    procedure OnPrint(const Key, {%H-}Param2, {%H-}Param3: TG2IntS32);
    procedure OnKeyDown(const Key, {%H-}Param2, {%H-}Param3: TG2IntS32);
    procedure OnKeyUp(const Key, {%H-}Param2, {%H-}Param3: TG2IntS32);
    procedure OnMouseDown(const Button, x, y: TG2IntS32);
    procedure OnMouseUp(const Button, x, y: TG2IntS32);
    procedure OnScroll(const y, {%H-}Param2, {%H-}Param3: TG2IntS32);
    procedure OnResize(const Mode, {%H-}NewWidth, {%H-}NewHeight: TG2IntS32);
    procedure Adjust(
      const OldScreenMode, NewScreenMode: TG2ScreenMode;
      const {%H-}OldWidth, {%H-}OldHeight, NewWidth, NewHeight: TG2IntS32;
      const OldResizable, NewResizable: Boolean
    );
    procedure Stop; inline;
    procedure SetCaption(const Value: AnsiString); inline;
    {$if not defined(G2Target_Mobile)}
    procedure SetCursor(const Value: TG2Cursor);
    {$endif}
  public
    {$if defined(G2Target_Windows)}
    property Handle: THandle read _Handle;
    {$elseif defined(G2Target_Linux)}
    property Display: PDisplay read _Display;
    property Handle: TWindow read _Handle;
    property VisualInfo: PXVisualInfo read _VisualInfo;
    {$elseif defined(G2Target_OSX)}
    property Handle: WindowRef read _Handle;
    {$elseif defined(G2Target_iOS)}
    property View: TG2OpenGLView read _View write _View;
    {$endif}
    {$if not defined(G2Target_Mobile)}
    property Cursor: TG2Cursor read _Cursor write SetCursor;
    property CursorArrow: TG2Cursor read _CursorArrow;
    property CursorText: TG2Cursor read _CursorText;
    property CursorHand: TG2Cursor read _CursorHand;
    property CursorSizeNS: TG2Cursor read _CursorSizeNS;
    property CursorSizeWE: TG2Cursor read _CursorSizeWE;
    {$endif}
    property Caption: AnsiString read _Caption write SetCaption;
    property IsLooping: Boolean read _Loop;
    procedure Loop;
    procedure DisplayMessage(const Text: AnsiString);
    constructor Create(const Width: TG2IntS32 = 0; const Height: TG2IntS32 = 0; const NewCaption: AnsiString = 'Gen2MP');
    destructor Destroy; override;
  end;

  TG2Params = class
  private
    _ScreenWidth: TG2IntS32;
    _ScreenHeight: TG2IntS32;
    _NewWidth: TG2IntS32;
    _Width: TG2IntS32;
    _NewHeight: TG2IntS32;
    _Height: TG2IntS32;
    _NewScreenMode: TG2ScreenMode;
    _ScreenMode: TG2ScreenMode;
    _NewResizable: Boolean;
    _Resizable: Boolean;
    _WidthRT: TG2IntS32;
    _HeightRT: TG2IntS32;
    _TargetUPS: TG2IntS32;
    _MaxFPS: TG2IntS32;
    _PreventUpdateOverload: Boolean;
    _Buffered: Boolean;
    procedure SetWidth(const Value: TG2IntS32); inline;
    procedure SetHeight(const Value: TG2IntS32); inline;
    procedure SetScreenMode(const Value: TG2ScreenMode); inline;
    procedure SetResizable(const Value: Boolean); inline;
    procedure SetBuffered(const Value: Boolean); inline;
  public
    property ScreenWidth: TG2IntS32 read _ScreenWidth;
    property ScreenHeight: TG2IntS32 read _ScreenHeight;
    property Width: TG2IntS32 read _Width write SetWidth;
    property Height: TG2IntS32 read _Height write SetHeight;
    property WidthRT: TG2IntS32 read _WidthRT;
    property HeightRT: TG2IntS32 read _HeightRT;
    property ScreenMode: TG2ScreenMode read _ScreenMode write SetScreenMode;
    property Resizable: Boolean read _Resizable write SetResizable;
    property TargetUPS: TG2IntS32 read _TargetUPS write _TargetUPS;
    property MaxFPS: TG2IntS32 read _MaxFPS write _MaxFPS;
    property PreventUpdateOverload: Boolean read _PreventUpdateOverload write _PreventUpdateOverload;
    constructor Create;
    destructor Destroy; override;
    function NeedUpdate: Boolean;
    procedure Apply;
  end;

  TG2Sys = class
  private
    _MMX: Boolean;
    _SSE: Boolean;
    _SSE2: Boolean;
    _SSE3: Boolean;
  public
    property MMX: Boolean read _MMX;
    property SSE: Boolean read _SSE;
    property SSE2: Boolean read _SSE2;
    property SSE3: Boolean read _SSE3;
    constructor Create;
    destructor Destroy; override;
  end;

  TG2RenderQueueItem = record
    RenderControl: TG2RenderControl;
    RenderData: Pointer;
  end;

  {$if defined(G2RM_SM2)}
  PG2ShaderMethod = ^TG2ShaderMethod;
  {$endif}

  TG2CullMode = (
    g2cm_none = 0,
    g2cm_ccw = 1,
    g2cm_cw = 2
  );

  {$if defined(G2RM_FF)}
  TG2GfxTextureStageOperation = (
    g2tso_disable = 0,
    g2tso_select_arg0 = 1,
    g2tso_modulate = 2,
    g2tso_add = 3,
    g2tso_add_signed = 4,
    g2tso_subtract = 5,
    g2tso_dot = 6,
    g2tso_lerp = 7
  );
  TG2GfxTextureStageArgument = (
    g2tsa_diffuse = 0,
    g2tsa_current = 1,
    g2tsa_texture = 2,
    g2tsa_constant = 3
  );
  TG2GfxTextureStage = class
  private
    {$if defined(G2Gfx_D3D9)}
    const StageOpRemap: array[0..7] of TG2IntU32 = (
      D3DTOP_DISABLE,
      D3DTOP_SELECTARG1,
      D3DTOP_MODULATE,
      D3DTOP_ADD,
      D3DTOP_ADDSIGNED,
      D3DTOP_SUBTRACT,
      D3DTOP_DOTPRODUCT3,
      D3DTOP_LERP
    );
    const StageArgRemap: array[0..3] of TG2IntU32 = (
      D3DTA_DIFFUSE,
      D3DTA_CURRENT,
      D3DTA_TEXTURE,
      D3DTA_CONSTANT
    );
    {$elseif defined(G2Gfx_OGL)}
    const StageOpRemap: array[0..7] of TGLenum = (
      GL_REPLACE,
      GL_REPLACE,
      GL_MODULATE,
      GL_ADD,
      GL_ADD_SIGNED,
      GL_SUBTRACT,
      GL_DOT3_RGB,
      GL_INTERPOLATE
    );
    const StageArgRemap: array[0..3] of TGLenum = (
      GL_PRIMARY_COLOR,
      GL_PREVIOUS,
      GL_TEXTURE,
      GL_CONSTANT
    );
    {$elseif defined(G2Gfx_GLES)}
    const StageOpRemap: array[0..7] of TGLenum = (
      GL_REPLACE,
      GL_REPLACE,
      GL_MODULATE,
      GL_ADD,
      GL_ADD_SIGNED,
      GL_SUBTRACT,
      GL_DOT3_RGB,
      GL_INTERPOLATE
    );
    const StageArgRemap: array[0..3] of TGLenum = (
      GL_PRIMARY_COLOR,
      GL_PREVIOUS,
      GL_TEXTURE,
      GL_CONSTANT
    );
    {$endif}
  private
    {$if defined(G2Gfx_D3D9)}
    _Gfx: TG2GfxD3D9;
    {$elseif defined(G2Gfx_OGL)}
    _Gfx: TG2GfxOGL;
    {$elseif defined(G2Gfx_GLES)}
    _Gfx: TG2GfxGLES;
    {$endif}
    _Stage: TG2IntU8;
    _ColorArgument: array[0..2] of TG2GfxTextureStageArgument;
    _ColorOperation: TG2GfxTextureStageOperation;
    _AlphaArgument: array[0..2] of TG2GfxTextureStageArgument;
    _AlphaOperation: TG2GfxTextureStageOperation;
    _ConstantColor: TG2Color;
    {$if defined(G2Gfx_D3D9)}
    _TexCoordIndex: TG2IntU8;
    {$endif}
    procedure SetColorArgument(const Index: TG2IntU8; const Argument: TG2GfxTextureStageArgument);
    procedure SetAlphaArgument(const Index: TG2IntU8; const Argument: TG2GfxTextureStageArgument);
    procedure SetColorOperation(const Value: TG2GfxTextureStageOperation);
    procedure SetAlphaOperation(const Value: TG2GfxTextureStageOperation);
    procedure SetColorArgument0(const Value: TG2GfxTextureStageArgument);
    procedure SetColorArgument1(const Value: TG2GfxTextureStageArgument);
    procedure SetColorArgument2(const Value: TG2GfxTextureStageArgument);
    procedure SetAlphaArgument0(const Value: TG2GfxTextureStageArgument);
    procedure SetAlphaArgument1(const Value: TG2GfxTextureStageArgument);
    procedure SetAlphaArgument2(const Value: TG2GfxTextureStageArgument);
    procedure SetConstantColor(const Value: TG2Color);
    {$if defined(G2Gfx_D3D9)}
    procedure SetTexCoordIndex(const Value: TG2IntU8);
    {$endif}
  public
    constructor Create(const AStage: TG2IntU8);
    property ColorOperation: TG2GfxTextureStageOperation read _ColorOperation write SetColorOperation;
    property ColorArgument0: TG2GfxTextureStageArgument read _ColorArgument[0] write SetColorArgument0;
    property ColorArgument1: TG2GfxTextureStageArgument read _ColorArgument[1] write SetColorArgument1;
    property ColorArgument2: TG2GfxTextureStageArgument read _ColorArgument[2] write SetColorArgument2;
    property AlphaOperation: TG2GfxTextureStageOperation read _AlphaOperation write SetAlphaOperation;
    property AlphaArgument0: TG2GfxTextureStageArgument read _AlphaArgument[0] write SetAlphaArgument0;
    property AlphaArgument1: TG2GfxTextureStageArgument read _AlphaArgument[1] write SetAlphaArgument1;
    property AlphaArgument2: TG2GfxTextureStageArgument read _AlphaArgument[2] write SetAlphaArgument2;
    property ConstantColor: TG2Color read _ConstantColor write SetConstantColor;
    {$if defined(G2Gfx_D3D9)}
    property TexCoordIndex: TG2IntU8 read _TexCoordIndex write SetTexCoordIndex;
    {$endif}
  end;
  {$endif}

  TG2Gfx = class
  private
    _RenderControls: TG2QuickList;
    _RenderQueue: array[0..1] of array of TG2RenderQueueItem;
    _RenderQueueCapacity: array[0..1] of TG2IntS32;
    _RenderQueueCount: array[0..1] of TG2IntS32;
    _QueueFill: TG2IntS32;
    _QueueDraw: TG2IntS32;
    _NeedToSwap: Boolean;
    _CanSwap: Boolean;
    _ControlStateChange: TG2RenderControlStateChange;
    {$if defined(G2RM_SM2)}
    _ControlBuffer: TG2RenderControlBuffer;
    {$endif}
    _ControlLegacyMesh: TG2RenderControlLegacyMesh;
    _ControlPic2D: TG2RenderControlPic2D;
    _ControlPrim2D: TG2RenderControlPrim2D;
    _ControlPrim3D: TG2RenderControlPrim3D;
    _ControlPoly2D: TG2RenderControlPoly2D;
    _ControlPoly3D: TG2RenderControlPoly3D;
    _ControlManaged: TG2RenderControlManaged;
    {$if defined(G2RM_FF)}
    _TextureStages: array[0..31] of TG2GfxTextureStage;
    {$elseif defined(G2RM_SM2)}
    _Shaders: TG2QuickList;
    _ShaderMethod: PG2ShaderMethod;
    procedure AddShader(const Name: AnsiString; const Prog: Pointer; const ProgSize: TG2IntS32);
    procedure InitShaders;
    procedure FreeShaders;
    {$endif}
    function AddRenderControl(const ControlClass: CG2RenderControl): TG2RenderControl;
  protected
    _BlendMode: TG2BlendMode;
    _Filter: TG2Filter;
    _CullMode: TG2CullMode;
    _RenderTarget: TG2Texture2DRT;
    _DepthEnable: Boolean;
    _DepthWriteEnable: Boolean;
    _BlendEnable: Boolean;
    _BlendSeparate: Boolean;
    _VertexBuffer: TG2VertexBuffer;
    _IndexBuffer: TG2IndexBuffer;
    procedure ProcessRenderQueue;
    procedure SetRenderTarget(const Value: TG2Texture2DRT); virtual; abstract;
    procedure SetBlendMode(const Value: TG2BlendMode); virtual; abstract;
    procedure SetFilter(const Value: TG2Filter); virtual; abstract;
    procedure SetCullMode(const Value: TG2CullMode); virtual; abstract;
    procedure SetScissor(const Value: PRect); virtual; abstract;
    procedure SetDepthEnable(const Value: Boolean); virtual; abstract;
    procedure SetDepthWriteEnable(const Value: Boolean); virtual; abstract;
    procedure SetVertexBuffer(const Value: TG2VertexBuffer); virtual; abstract;
    procedure SetIndexBuffer(const Value: TG2IndexBuffer); virtual; abstract;
    {$if defined(G2RM_FF)}
    function GetTextureStage(const Stage: TG2IntU8): TG2GfxTextureStage; inline;
    {$elseif defined(G2RM_SM2)}
    procedure SetShaderMethod(const Value: PG2ShaderMethod); virtual; abstract;
    {$endif}
    procedure Resize(const {%H-}OldWidth, {%H-}OldHeight, NewWidth, NewHeight: TG2IntS32); virtual;
  public
    SizeRT: TPoint;
    property StateChange: TG2RenderControlStateChange read _ControlStateChange;
    {$if defined(G2RM_SM2)}
    property Buffer: TG2RenderControlBuffer read _ControlBuffer;
    {$endif}
    property LegacyMesh: TG2RenderControlLegacyMesh read _ControlLegacyMesh;
    property Pic2D: TG2RenderControlPic2D read _ControlPic2D;
    property Prim2D: TG2RenderControlPrim2D read _ControlPrim2D;
    property Prim3D: TG2RenderControlPrim3D read _ControlPrim3D;
    property Poly2D: TG2RenderControlPoly2D read _ControlPoly2D;
    property Poly3D: TG2RenderControlPoly3D read _ControlPoly3D;
    property Managed: TG2RenderControlManaged read _ControlManaged;
    property RenderTarget: TG2Texture2DRT read _RenderTarget write SetRenderTarget;
    property BlendMode: TG2BlendMode read _BlendMode write SetBlendMode;
    property Filter: TG2Filter read _Filter write SetFilter;
    property CullMode: TG2CullMode read _CullMode write SetCullMode;
    property DepthEnable: Boolean read _DepthEnable write SetDepthEnable;
    property DepthWriteEnable: Boolean read _DepthWriteEnable write SetDepthWriteEnable;
    property VertexBuffer: TG2VertexBuffer read _VertexBuffer write SetVertexBuffer;
    property IndexBuffer: TG2IndexBuffer read _IndexBuffer write SetIndexBuffer;
    {$if defined(G2RM_FF)}
    property TextureStage[const Index: TG2IntU8]: TG2GfxTextureStage read GetTextureStage;
    {$elseif defined(G2RM_SM2)}
    property ShaderMethod: PG2ShaderMethod read _ShaderMethod write SetShaderMethod;
    {$endif}
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure Reset;
    procedure Swap;
    procedure RenderStart;
    procedure RenderStop;
    procedure Render; virtual; abstract;
    procedure AddRenderQueueItem(const Control: TG2RenderControl; const Data: Pointer);
    procedure Clear(
      const Color: Boolean; const ColorValue: TG2Color;
      const Depth: Boolean; const DepthValue: TG2Float;
      const Stencil: Boolean; const StencilValue: TG2IntU8
    ); virtual; abstract;
    {$if defined(G2RM_SM2)}
    function RequestShader(const Name: AnsiString): TG2ShaderGroup;
    {$endif}
    procedure ThreadAttach; virtual;
    procedure ThreadDetach; virtual;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  {$if defined(G2RM_SM2)}
  TG2ShaderItem = record
    Name: AnsiString;
    ShaderGroup: TG2ShaderGroup;
  end;
  PG2ShaderItem = ^TG2ShaderItem;
  {$endif}

  {$ifdef G2Gfx_D3D9}
  TG2GfxD3D9 = class (TG2Gfx)
  private
    _D3D9: IDirect3D9;
    _Device: IDirect3DDevice9;
    _DefSwapChain: IDirect3DSwapChain9;
    _DefRenderTarget: IDirect3DSurface9;
    _DefDepthStencil: IDirect3DSurface9;
    _PresentParameters: TD3DPresentParameters;
  protected
    procedure SetRenderTarget(const Value: TG2Texture2DRT); override;
    procedure SetBlendMode(const Value: TG2BlendMode); override;
    procedure SetFilter(const Value: TG2Filter); override;
    procedure SetCullMode(const Value: TG2CullMode); override;
    procedure SetScissor(const Value: PRect); override;
    procedure SetDepthEnable(const Value: Boolean); override;
    procedure SetDepthWriteEnable(const Value: Boolean); override;
    procedure SetVertexBuffer(const Value: TG2VertexBuffer); override;
    procedure SetIndexBuffer(const Value: TG2IndexBuffer); override;
    {$if defined(G2RM_SM2)}
    procedure SetShaderMethod(const Value: PG2ShaderMethod); override;
    {$endif}
    procedure Resize(const OldWidth, OldHeight, NewWidth, NewHeight: TG2IntS32); override;
  public
    Caps: TD3DCaps9;
    property Device: IDirect3DDevice9 read _Device;
    procedure Initialize; override;
    procedure Finalize; override;
    procedure Render; override;
    procedure Clear(
      const Color: Boolean; const ColorValue: TG2Color;
      const Depth: Boolean; const DepthValue: TG2Float;
      const Stencil: Boolean; const StencilValue: TG2IntU8
    ); override;
    constructor Create; override;
    destructor Destroy; override;
  end;
  {$endif}

  {$ifdef G2Gfx_OGL}
  TG2GfxOGL = class (TG2Gfx)
  private
    _EnableMipMaps: Boolean;
    {$if defined(G2Target_Windows)}
    _Context: HGLRC;
    _DC: HDC;
    {$elseif defined(G2Target_Linux)}
    _Context: GLXContext;
    {$elseif defined(G2Target_OSX)}
    _Context: TAGLContext;
    {$endif}
    {$if defined(G2Threading)}
    _ThreadLock: TG2CriticalSection;
    _ThreadID: TThreadID;
    _ThreadRef: TG2IntS32;
    {$endif}
    {$if defined(G2RM_FF)}
    _DummyTex: TGLuint;
    {$endif}
    _ActiveTexture: TG2IntU32;
    _ClientActiveTexture: TG2IntU32;
  protected
    procedure SetRenderTarget(const Value: TG2Texture2DRT); override;
    procedure SetBlendMode(const Value: TG2BlendMode); override;
    procedure SetFilter(const Value: TG2Filter); override;
    procedure SetCullMode(const Value: TG2CullMode); override;
    procedure SetScissor(const Value: PRect); override;
    procedure SetDepthEnable(const Value: Boolean); override;
    procedure SetDepthWriteEnable(const Value: Boolean); override;
    procedure SetVertexBuffer(const Value: TG2VertexBuffer); override;
    procedure SetIndexBuffer(const Value: TG2IndexBuffer); override;
    function GetActiveTexture: TG2IntU8; inline;
    procedure SetActiveTexture(const Value: TG2IntU8); inline;
    function GetClientActiveTexture: TG2IntU8; inline;
    procedure SetClientActiveTexture(const Value: TG2IntU8); inline;
    {$if defined(G2RM_SM2)}
    procedure SetShaderMethod(const Value: PG2ShaderMethod); override;
    {$endif}
    procedure Resize(const OldWidth, OldHeight, NewWidth, NewHeight: TG2IntS32); override;
  public
    {$if defined(G2Target_Windows)}
    property Context: HGLRC read _Context;
    property DC: HDC read _DC;
    {$elseif defined(G2Target_Linux)}
    property Context: GLXContext read _Context;
    {$elseif defined(G2Target_OSX)}
    property Context: TAGLContext read _Context;
    {$endif}
    property ActiveTexture: TG2IntU8 read GetActiveTexture write SetActiveTexture;
    property ClientActiveTexture: TG2IntU8 read GetClientActiveTexture write SetClientActiveTexture;
    {$if defined(G2RM_FF)}
    property DummyTex: TGLuint read _DummyTex;
    {$endif}
    procedure Initialize; override;
    procedure Finalize; override;
    procedure Render; override;
    procedure Clear(
      const Color: Boolean; const ColorValue: TG2Color;
      const Depth: Boolean; const DepthValue: TG2Float;
      const Stencil: Boolean; const StencilValue: TG2IntU8
    ); override;
    procedure SetProj2D;
    procedure EnableMipMaps(const Value: Boolean);
    procedure SetDefaults;
    procedure ThreadAttach; override;
    procedure ThreadDetach; override;
    constructor Create; override;
    destructor Destroy; override;
  end;
  {$endif}

  {$ifdef G2Gfx_GLES}
  TG2GfxGLES = class (TG2Gfx)
  private
    {$if defined(G2Target_iOS)}
    _EAGLLayer: CAEAGLLayer;
    _Context: EAGLContext;
    _RenderBuffer: GLUInt;
    {$endif}
  protected
    procedure SetRenderTarget(const Value: TG2Texture2DRT); override;
    procedure SetBlendMode(const Value: TG2BlendMode); override;
    procedure SetFilter(const Value: TG2Filter); override;
    procedure SetCullMode(const Value: TG2CullMode); override;
    procedure SetScissor(const Value: PRect); override;
    procedure SetDepthEnable(const Value: Boolean); override;
    procedure SetDepthWriteEnable(const Value: Boolean); override;
  public
    {$if defined(G2Target_iOS)}
    property Context: EAGLContext read _Context;
    {$endif}
    procedure Initialize; override;
    procedure Finalize; override;
    procedure Render; override;
    procedure Clear(
      const Color: Boolean; const ColorValue: TG2Color;
      const Depth: Boolean; const DepthValue: TG2Float;
      const Stencil: Boolean; const StencilValue: TG2IntU8
    ); override;
    procedure SetProj2D;
    procedure SetDefaults;
    procedure SwapBlendMode;
    procedure MaskAll;
    procedure MaskColor;
    procedure MaskAlpha;
    constructor Create; override;
    destructor Destroy; override;
  end;
  {$endif}

  TG2TextAsset = class (TG2Asset)
  protected
    var _Lines: TStringList;
    procedure Initialize; override;
    procedure Finalize; override;
  public
    property Lines: TStringList read _Lines;
    class function SharedAsset(const SharedAssetName: String): TG2TextAsset;
    function Load(const FileName: String): Boolean;
    function Load(const Stream: TStream): Boolean;
    function Load(const Buffer: Pointer; const Size: TG2IntS32): Boolean;
    function Load(const DataManager: TG2DataManager): Boolean;
  end;

  TG2Snd = class
  protected
    _ListenerPos: TG2Vec3;
    _ListenerVel: TG2Vec3;
    _ListenerDir: TG2Vec3;
    _ListenerUp: TG2Vec3;
    procedure SetListenerPos(const Value: TG2Vec3); virtual; abstract;
    procedure SetListenerVel(const Value: TG2Vec3); virtual; abstract;
    procedure SetListenerDir(const Value: TG2Vec3); virtual; abstract;
    procedure SetListenerUp(const Value: TG2Vec3); virtual; abstract;
  public
    property ListenerPos: TG2Vec3 read _ListenerPos write SetListenerPos;
    property ListenerVel: TG2Vec3 read _ListenerVel write SetListenerVel;
    property ListenerDir: TG2Vec3 read _ListenerDir write SetListenerDir;
    property ListenerUp: TG2Vec3 read _ListenerUp write SetListenerUp;
    procedure Initialize; virtual; abstract;
    procedure Finalize; virtual; abstract;
    constructor Create;
    destructor Destroy; override;
  end;

  {$ifdef G2Snd_OAL}
  TG2SndOAL = class (TG2Snd)
  protected
    _Context: PALCcontext;
    _Device: PALCdevice;
    procedure SetListenerPos(const Value: TG2Vec3); override;
    procedure SetListenerVel(const Value: TG2Vec3); override;
    procedure SetListenerDir(const Value: TG2Vec3); override;
    procedure SetListenerUp(const Value: TG2Vec3); override;
  public
    procedure Initialize; override;
    procedure Finalize; override;
  end;
  {$endif}

  {$ifdef G2Snd_DS}
  TG2SndDS = class (TG2Snd)
  protected
    _Device: IDirectSound8;
    _Listener: IDirectSound3DListener8;
    procedure SetListenerPos(const Value: TG2Vec3); override;
    procedure SetListenerVel(const Value: TG2Vec3); override;
    procedure SetListenerDir(const Value: TG2Vec3); override;
    procedure SetListenerUp(const Value: TG2Vec3); override;
  public
    procedure Initialize; override;
    procedure Finalize; override;
  end;
  {$endif}

  {$ifdef G2Threading}
  TG2Updater = class (TThread)
  protected
    procedure Execute; override;
  end;

  TG2Renderer = class (TThread)
  protected
    procedure Execute; override;
  end;
  {$endif}

  TG2TextureBase = class (TG2Asset)
  protected
    _Gfx: {$if defined(G2Gfx_D3D9)}TG2GfxD3D9{$elseif defined(G2Gfx_OGL)}TG2GfxOGL{$elseif defined(G2Gfx_GLES)}TG2GfxGLES{$endif};
    _Texture: {$ifdef G2Gfx_D3D9}IDirect3DBaseTexture9{$else}GLUInt{$endif};
    _Usage: TG2TextureUsage;
    procedure Release; virtual;
    procedure Initialize; override;
    procedure Finalize; override;
  public
    function BaseTexture: {$ifdef G2Gfx_D3D9}IDirect3DBaseTexture9{$else}GLUInt{$endif}; inline;
    property Usage: TG2TextureUsage read _Usage;
  end;

  TG2Texture2DBase = class (TG2TextureBase)
  protected
    _RealWidth: TG2IntS32;
    _RealHeight: TG2IntS32;
    _Width: TG2IntS32;
    _Height: TG2IntS32;
    _SizeTU: TG2Float;
    _SizeTV: TG2Float;
    function GetTexCoords: TG2Rect; inline;
  public
    function GetTexture: {$ifdef G2Gfx_D3D9}IDirect3DTexture9{$else}GLUInt{$endif}; inline;
    property RealWidth: TG2IntS32 read _RealWidth;
    property RealHeight: TG2IntS32 read _RealHeight;
    property Width: TG2IntS32 read _Width;
    property Height: TG2IntS32 read _Height;
    property SizeTU: TG2Float read _SizeTU;
    property SizeTV: TG2Float read _SizeTV;
    property TexCoords: TG2Rect read GetTexCoords;
    function CreateImage: TG2Image;
    procedure Save(const dm: TG2DataManager);
    procedure Save(const FileName: String);
  end;
  PG2Texture2DBase = ^TG2Texture2DBase;

  TG2Texture2D = class (TG2Texture2DBase)
  public
    class function SharedAsset(const SharedAssetName: String; const TextureUsage: TG2TextureUsage = tuDefault): TG2Texture2D;
    function Load(const FileName: String; const TextureUsage: TG2TextureUsage = tuDefault): Boolean;
    function Load(const Stream: TStream; const TextureUsage: TG2TextureUsage = tuDefault): Boolean;
    function Load(const Buffer: Pointer; const Size: TG2IntS32; const TextureUsage: TG2TextureUsage = tuDefault): Boolean;
    function Load(const DataManager: TG2DataManager; const TextureUsage: TG2TextureUsage = tuDefault): Boolean;
    function Load(const Image: TG2Image; const TextureUsage: TG2TextureUsage = tuDefault): Boolean;
  end;

  {$ifdef G2Gfx_OGL}
  TG2TexRTMode = (
    rtmNone,
    rtmPBuffer,
    rtmPBufferTex,
    rtmFBO
  );
  {$endif}

  TG2Texture2DRT = class (TG2Texture2DBase)
  private
    {$if defined(G2Gfx_D3D9)}
    _Surface: IDirect3DSurface9;
    {$elseif defined(G2Gfx_OGL)}
    _Mode: TG2TexRTMode;
    _FrameBuffer: GLuint;
    _RenderBuffer: GLuint;
    {$if defined(G2Target_Windows)}
    _PBufferHandle: HPBuffer;
    _PBufferDC: HDC;
    _PBufferRC: HGLRC;
    {$elseif defined(G2Target_Linux)}
    _PBufferContext: GLXContext;
    _PBuffer: GLXPBuffer;
    {$elseif defined(G2Target_OSX)}
    _PBufferContext: TAGLContext;
    _PBuffer: TAGLPBuffer;
    {$endif}
    {$elseif defined(G2Gfx_GLES)}
    _FrameBuffer: GLuint;
    _RenderBuffer: GLuint;
    {$endif}
  protected
    procedure Release; override;
  public
    function Make(const NewWidth, NewHeight: TG2IntS32): Boolean;
  end;

  TG2AtlasPage = class
  public
    Texture: TG2Texture2DBase;
    Width: Integer;
    Height: Integer;
  end;
  TG2AtlasPageList = specialize TG2QuickListG<TG2AtlasPage>;

  TG2AtlasFrame = class
  public
    Name: String;
    Page: TG2AtlasPage;
    PosL: Integer;
    PosT: Integer;
    Width: Integer;
    Height: Integer;
    TexCoords: TG2Rect;
    property Texture: TG2Texture2DBase read Page.Texture;
  end;
  TG2AtlasFrameList = specialize TG2QuickListG<TG2AtlasFrame>;

  TG2Atlas = class (TG2Asset)
  public
    var Pages: TG2AtlasPageList;
    var Frames: TG2AtlasFrameList;
    constructor Create;
    destructor Destroy; override;
    class function SharedAsset(const SharedAssetName: String): TG2Atlas;
    procedure Load(const FileName: String);
    procedure Load(const DataManager: TG2DataManager);
    procedure RenderAtlas(
      const TextureArr: PG2Texture2DBase;
      const TextureNames: PPAnsiChar;
      const TextureCount: TG2IntS32;
      const MaxPageWidth: TG2IntS32;
      const MaxPageHeight: TG2IntS32;
      const Spacing: TG2IntS32;
      const TransparentBorders: Boolean;
      const ForcePOT: Boolean;
      const OutTexturesBaked: PG2IntS32
    );
    procedure Clear;
    function FindFrame(const Name: String): TG2AtlasFrame;
  end;

  TG2Picture = class (TG2Asset)
  protected
    function GetTexture: TG2Texture2DBase; virtual; abstract;
    function GetTexCoords: TG2Rect; virtual; abstract;
    function GetIsValid: Boolean; virtual; abstract;
  public
    property Texture: TG2Texture2DBase read GetTexture;
    property TexCoords: TG2Rect read GetTexCoords;
    property IsValid: Boolean read GetIsValid;
    class function SharedAsset(const SharedAssetName: String; const Usage: TG2TextureUsage = tuDefault): TG2Picture;
  end;

  TG2PictureTexture = class (TG2Picture)
  private
    var _Texture: TG2Texture2DBase;
  protected
    function GetTexture: TG2Texture2DBase; override;
    function GetTexCoords: TG2Rect; override;
    function GetIsValid: Boolean; override;
  public
    constructor Create(const SharedTexture: TG2Texture2DBase); reintroduce;
    destructor Destroy; override;
  end;

  TG2PictureAtlasFrame = class (TG2Picture)
  private
    var _Atlas: TG2Atlas;
    var _Frame: TG2AtlasFrame;
  protected
    function GetTexture: TG2Texture2DBase; override;
    function GetTexCoords: TG2Rect; override;
    function GetIsValid: Boolean; override;
  public
    constructor Create(const SharedAtlas: TG2Atlas; const SharedFrame: TG2AtlasFrame); reintroduce;
    destructor Destroy; override;
  end;

  TG2Effect2D = class;
  TG2Effect2DInst = class;
  TG2Effect2DEmitterData = class;
  TG2Effect2DEmitterDataList = specialize TG2QuickListG<TG2Effect2DEmitterData>;
  TG2Effect2DEmitter = class;
  TG2Effect2DEmitterList = specialize TG2QuickListG<TG2Effect2DEmitter>;
  TG2Effect2DLayer = class;
  TG2Effect2DLayerList = specialize TG2QuickListG<TG2Effect2DLayer>;
  TG2Effect2DParticle = class;
  TG2Effect2DParticleList = specialize TG2QuickListG<TG2Effect2DParticle>;

  TG2Effect2DEmitter = class
  public
    var Data: TG2Effect2DEmitterData;
    var Parent: TG2Effect2DParticle;
    var Delay: TG2Float;
    var Duration: TG2Float;
    var DurationTotal: TG2Float;
    var ParticlesToEmitt: Integer;
    var Layer: Integer;
    var Orientation: TG2Float;
    var Radius0, Radius1: TG2Float;
    var Width0, Width1: TG2Float;
    var Height0, Height1: TG2Float;
  end;

  TG2Effect2DParticle = class
  public
    var Data: TG2Effect2DEmitterData;
    var Layer: TG2Effect2DLayer;
    var xf: TG2Transform2;
    var OrientationInit: TG2Float;
    var Duration: TG2Float;
    var DurationTotal: TG2Float;
    var CenterX: TG2Float;
    var CenterY: TG2Float;
    var WidthInit: TG2Float;
    var Width: TG2Float;
    var HeightInit: TG2Float;
    var Height: TG2Float;
    var ScaleInit: TG2Float;
    var Scale: TG2Float;
    var VelocityInit: TG2Float;
    var Velocity: TG2Float;
    var RotationInit: TG2Float;
    var Rotation: TG2Float;
    var RotationLocal: Boolean;
    var ColorInit: TG2Color;
    var Color: TG2Color;
  end;

  TG2Effect2DLayer = class
  public
    var Index: TG2IntS32;
    var Particles: TG2Effect2DParticleList;
    var Ref: TG2IntS32;
  end;

  TG2Effect2DMod = class;
  CG2Effect2DMod = class of TG2Effect2DMod;
  TG2Effect2DModClassList = specialize TG2QuickListG<CG2Effect2DMod>;
  TG2Effect2DModList = specialize TG2QuickListG<TG2Effect2DMod>;
  TG2Effect2DMod = class
  private
    class var List: TG2Effect2DModClassList;
  public
    class function GetGUID: AnsiString; virtual;
    class function GetName: AnsiString; virtual;
    class function CreateMod(const GUID: AnsiString): TG2Effect2DMod;
    class constructor CreateClass;
    constructor Create; virtual;
    procedure OnParticleUpdate(const {%H-}Particle: TG2Effect2DParticle; const {%H-}Inst: TG2Effect2DInst; const {%H-}t, {%H-}dt: TG2Float); virtual;
    procedure OnEmitterUpdate(const {%H-}Emitter: TG2Effect2DEmitter; const {%H-}Inst: TG2Effect2DInst; const {%H-}t, {%H-}dt: TG2Float); virtual;
    procedure LoadG2ML(const {%H-}g2ml: PG2MLObject); virtual;
  end;

  TG2Effect2DModGraph = class
  public
    var Points: array of TG2Vec2;
    constructor Create;
    procedure AddPoint(const v: TG2Vec2);
    procedure LoadG2ML(const g2ml: PG2MLObject);
    function GetYAt(const x: TG2Float): TG2Float;
  end;

  TG2Effect2DModOpacityGraph = class (TG2Effect2DMod)
  public
    var Graph: TG2Effect2DModGraph;
    class function GetGUID: AnsiString; override;
    class function GetName: AnsiString; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnParticleUpdate(const Particle: TG2Effect2DParticle; const {%H-}Inst: TG2Effect2DInst; const t, {%H-}dt: TG2Float); override;
    procedure LoadG2ML(const g2ml: PG2MLObject); override;
  end;

  TG2Effect2DModScaleGraph = class (TG2Effect2DMod)
  public
    var Graph: TG2Effect2DModGraph;
    class function GetGUID: AnsiString; override;
    class function GetName: AnsiString; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnParticleUpdate(const Particle: TG2Effect2DParticle; const {%H-}Inst: TG2Effect2DInst; const t, {%H-}dt: TG2Float); override;
    procedure LoadG2ML(const g2ml: PG2MLObject); override;
  end;

  TG2Effect2DModColorGraph = class (TG2Effect2DMod)
  public
    type TColorSegment = record
      Color: TG2Color;
      Time: TG2Float;
    end;
    var Graph: array of TColorSegment;
    class function GetGUID: AnsiString; override;
    class function GetName: AnsiString; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnParticleUpdate(const Particle: TG2Effect2DParticle; const {%H-}Inst: TG2Effect2DInst; const t, {%H-}dt: TG2Float); override;
    procedure LoadG2ML(const g2ml: PG2MLObject); override;
  end;

  TG2Effect2DModWidthGraph = class (TG2Effect2DMod)
  public
    var Graph: TG2Effect2DModGraph;
    class function GetGUID: AnsiString; override;
    class function GetName: AnsiString; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnParticleUpdate(const Particle: TG2Effect2DParticle; const {%H-}Inst: TG2Effect2DInst; const t, {%H-}dt: TG2Float); override;
    procedure LoadG2ML(const g2ml: PG2MLObject); override;
  end;

  TG2Effect2DModHeightGraph = class (TG2Effect2DMod)
  public
    var Graph: TG2Effect2DModGraph;
    class function GetGUID: AnsiString; override;
    class function GetName: AnsiString; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnParticleUpdate(const Particle: TG2Effect2DParticle; const {%H-}Inst: TG2Effect2DInst; const t, {%H-}dt: TG2Float); override;
    procedure LoadG2ML(const g2ml: PG2MLObject); override;
  end;

  TG2Effect2DModRotationGraph = class (TG2Effect2DMod)
  public
    var Graph: TG2Effect2DModGraph;
    class function GetGUID: AnsiString; override;
    class function GetName: AnsiString; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnParticleUpdate(const Particle: TG2Effect2DParticle; const {%H-}Inst: TG2Effect2DInst; const t, {%H-}dt: TG2Float); override;
    procedure LoadG2ML(const g2ml: PG2MLObject); override;
  end;

  TG2Effect2DModOrientationGraph = class (TG2Effect2DMod)
  public
    var Graph: TG2Effect2DModGraph;
    class function GetGUID: AnsiString; override;
    class function GetName: AnsiString; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnParticleUpdate(const Particle: TG2Effect2DParticle; const {%H-}Inst: TG2Effect2DInst; const t, {%H-}dt: TG2Float); override;
    procedure LoadG2ML(const g2ml: PG2MLObject); override;
  end;

  TG2Effect2DModVelocityGraph = class (TG2Effect2DMod)
  public
    var Graph: TG2Effect2DModGraph;
    class function GetGUID: AnsiString; override;
    class function GetName: AnsiString; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnParticleUpdate(const Particle: TG2Effect2DParticle; const {%H-}Inst: TG2Effect2DInst; const t, {%H-}dt: TG2Float); override;
    procedure LoadG2ML(const g2ml: PG2MLObject); override;
  end;

  TG2Effect2DModAcceleration = class (TG2Effect2DMod)
  public
    var Direction: TG2Rotation2;
    var Local: Boolean;
    var Graph: TG2Effect2DModGraph;
    class function GetGUID: AnsiString; override;
    class function GetName: AnsiString; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnParticleUpdate(const Particle: TG2Effect2DParticle; const {%H-}Inst: TG2Effect2DInst; const t, dt: TG2Float); override;
    procedure LoadG2ML(const g2ml: PG2MLObject); override;
  end;

  TG2Effect2DModEmitterOrientationGraph = class (TG2Effect2DMod)
  public
    var Graph: TG2Effect2DModGraph;
    class function GetGUID: AnsiString; override;
    class function GetName: AnsiString; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnEmitterUpdate(const Emitter: TG2Effect2DEmitter; const {%H-}Inst: TG2Effect2DInst; const t, {%H-}dt: TG2Float); override;
    procedure LoadG2ML(const g2ml: PG2MLObject); override;
  end;

  TG2Effect2DModEmitterScaleGraph = class (TG2Effect2DMod)
  public
    var Graph: TG2Effect2DModGraph;
    class function GetGUID: AnsiString; override;
    class function GetName: AnsiString; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnEmitterUpdate(const Emitter: TG2Effect2DEmitter; const {%H-}Inst: TG2Effect2DInst; const t, {%H-}dt: TG2Float); override;
    procedure LoadG2ML(const g2ml: PG2MLObject); override;
  end;

  TG2Effect2DShape = (g2_e2ds_radial = 0, g2_e2ds_rectangular = 1);

  TG2Effect2DEmitterData = class
  public
    var Effect: TG2Effect2D;
    var Name: AnsiString;
    var Frame: TG2AtlasFrame;
    var TimeStart: TG2Float;
    var TimeEnd: TG2Float;
    var Orientation: TG2Float;
    var Shape: TG2Effect2DShape;
    var ShapeRadius0: TG2Float;
    var ShapeRadius1: TG2Float;
    var ShapeAngle: TG2Float;
    var ShapeWidth0: TG2Float;
    var ShapeWidth1: TG2Float;
    var ShapeHeight0: TG2Float;
    var ShapeHeight1: TG2Float;
    var Emission: TG2IntS32;
    var Layer: TG2IntS32;
    var Infinite: Boolean;
    var ParticleCenterX: TG2Float;
    var ParticleCenterY: TG2Float;
    var ParticleWidthMin: TG2Float;
    var ParticleWidthMax: TG2Float;
    var ParticleHeightMin: TG2Float;
    var ParticleHeightMax: TG2Float;
    var ParticleScaleMin: TG2Float;
    var ParticleScaleMax: TG2Float;
    var ParticleDurationMin: TG2Float;
    var ParticleDurationMax: TG2Float;
    var ParticleRotationMin: TG2Float;
    var ParticleRotationMax: TG2Float;
    var ParticleRotationLocal: Boolean;
    var ParticleOrientationMin: TG2Float;
    var ParticleOrientationMax: TG2Float;
    var ParticleVelocityMin: TG2Float;
    var ParticleVelocityMax: TG2Float;
    var ParticleColor0: TG2Color;
    var ParticleColor1: TG2Color;
    var ParticleBlend: TG2BlendMode;
    var Mods: TG2Effect2DModList;
    var Emitters: TG2Effect2DEmitterDataList;
    constructor Create;
    procedure LoadG2ML(const g2ml: PG2MLObject);
  end;

  TG2Effect2D = class (TG2Asset)
  public
    var Pages: TG2AtlasPageList;
    var Frames: TG2AtlasFrameList;
    var EmitterData: TG2Effect2DEmitterDataList;
    var Name: String;
    var Scale: TG2Float;
    class function SharedAsset(const SharedAssetName: String): TG2Effect2D;
    constructor Create;
    destructor Destroy; override;
    function FindFrame(const FrameName: String): TG2AtlasFrame;
    procedure Load(const FileName: String);
    procedure Load(const DataManager: TG2DataManager);
    procedure Clear;
    function CreateInstance: TG2Effect2DInst; inline;
  end;

  TG2Effect2DTRansformProc = function: TG2Transform2 of Object;

  TG2Effect2DInst = class (TG2Res)
  private
    var _EmitterCache: TG2Effect2DEmitterList;
    var _ParticleCache: TG2Effect2DParticleList;
    var _Emitters: TG2Effect2DEmitterList;
    var _Layers: TG2Effect2DLayerList;
    var _Effect: TG2Effect2D;
    var _Playing: Boolean;
    var _Repeating: Boolean;
    var _EmittersAlive: TG2IntS32;
    var _ParticlesAlive: TG2IntS32;
    var _Scale: TG2Float;
    var _Speed: TG2Float;
    var _OnFinish: TG2ProcPtrObj;
    var _Transform: PG2Transform2;
    var _LocalSpace: Boolean;
    var _FixedOrientation: Boolean;
    procedure OnUpdate;
    procedure Clear;
    function FindLayer(const Layer: TG2IntS32): TG2Effect2DLayer; inline;
    function CreateEmitter(const Data: TG2Effect2DEmitterData; const Parent: TG2Effect2DParticle = nil): TG2Effect2DEmitter;
  public
    property Effect: TG2Effect2D read _Effect;
    property Playing: Boolean read _Playing;
    property Repeating: Boolean read _Repeating write _Repeating;
    property Scale: TG2Float read _Scale write _Scale;
    property Speed: TG2Float read _Speed write _Speed;
    property LocalSpace: Boolean read _LocalSpace write _LocalSpace;
    property FixedOrientation: Boolean read _FixedOrientation write _FixedOrientation;
    property Transform: PG2Transform2 read _Transform write _Transform;
    property OnFinish: TG2ProcPtrObj read _OnFinish write _OnFinish;
    constructor Create(const ParentEffect: TG2Effect2D);
    destructor Destroy; override;
    procedure Play;
    procedure Stop;
    procedure Render(const Display: TG2Display2D = nil);
  end;

  TG2SoundBuffer = class (TG2Res)
  protected
    {$if defined(G2Snd_DS)}
    _Buffer: IDirectSoundBuffer;
    property GetBuffer: IDirectSoundBuffer read _Buffer;
    {$elseif defined(G2Snd_OAL)}
    _Buffer: TALUInt;
    property GetBuffer: TALUInt read _Buffer;
    {$endif}
    procedure Release;
    procedure Initialize; override;
    procedure Finalize; override;
  public
    function Load(const Stream: TStream): Boolean; overload;
    function Load(const FileName: String): Boolean; overload;
    function Load(const Buffer: Pointer; const Size: TG2IntS32): Boolean; overload;
    function Load(const Audio: TG2Audio): Boolean; overload;
  end;

  TG2SoundInst = class
  protected
    {$if defined(G2Snd_DS)}
    _SoundBuffer: IDirectSoundBuffer;
    _SoundBuffer3D: IDirectSound3DBuffer;
    {$elseif defined(G2Snd_OAL)}
    _Source: TALUInt;
    {$endif}
    _Buffer: TG2SoundBuffer;
    _Pos: TG2Vec3;
    _Vel: TG2Vec3;
    _Loop: Boolean;
    procedure SetBuffer(const Value: TG2SoundBuffer);
    procedure SetPos(const Value: TG2Vec3);
    procedure SetVel(const Value: TG2Vec3);
    procedure SetLoop(const Value: Boolean);
  public
    property Buffer: TG2SoundBuffer read _Buffer write SetBuffer;
    property Pos: TG2Vec3 read _Pos write SetPos;
    property Vel: TG2Vec3 read _Vel write SetVel;
    property Loop: Boolean read _Loop write SetLoop;
    procedure Play;
    procedure Pause;
    procedure Stop;
    function IsPlaying: Boolean;
    constructor Create(const SoundBuffer: TG2SoundBuffer);
    destructor Destroy; override;
  end;

  TG2Buffer = class (TG2Asset)
  protected
    _Allocated: Boolean;
    _Data: Pointer;
    _DataSize: TG2IntU32;
    procedure Initialize; override;
    procedure Finalize; override;
    procedure Allocate(const Size: TG2IntU32);
    procedure Release;
  public
    property Data: Pointer read _Data;
    property DataSize: TG2IntU32 read _DataSize;
  end;

  TG2VBElement = (vbNone, vbPosition, vbDiffuse, vbNormal, vbTangent, vbBinormal, vbTexCoord, vbVertexWeight, vbVertexIndex);

  TG2VBVertex = record
    Element: TG2VBElement;
    Count: TG2IntS32;
  end;

  TG2VBDecl = array of TG2VBVertex;
  PG2VBDecl = ^TG2VBDecl;

  TG2BufferUsage = (buNone, buWriteOnly, buReadWrite);
  TG2BufferLockMode = (lmNone, lmReadOnly, lmReadWrite);

  {$if defined(G2Gfx_D3D9)}
  {$if defined(G2RM_FF)}
  TG2D3DVertexMapping = record
    Enabled: Boolean;
    Count: TG2IntS32;
    SizeSrc: TG2IntS32;
    SizeDst: TG2IntS32;
    ProcWrite: procedure (const Src, Dst: Pointer) of Object;
    StridePos: TG2IntS32;
  end;
  {$endif}

  TG2VertexBuffer = class (TG2Buffer)
  private
    _Gfx: TG2GfxD3D9;
    _VertexSize: TG2IntU32;
    _VertexCount: TG2IntU32;
    _Decl: TG2VBDecl;
    _VB: IDirect3DVertexBuffer9;
    {$if defined(G2RM_FF)}
    _FVF: TG2IntU32;
    _VertexMapping: array of TG2D3DVertexMapping;
    _VertexStride: TG2IntU32;
    {$elseif defined(G2RM_SM2)}
    _DeclD3D: IDirect3DVertexDeclaration9;
    {$endif}
    _LockMode: TG2BufferLockMode;
    _Locked: Boolean;
    procedure WriteBufferData;
    {$if defined(G2RM_FF)}
    procedure InitFVF;
    procedure CopyFloatToFloat(const Src, Dst: Pointer);
    procedure CopyFloatToByte(const Src, Dst: Pointer);
    procedure CopyFloatToByteScale(const Src, Dst: Pointer);
    {$elseif defined(G2RM_SM2)}
    procedure InitDecl;
    {$endif}
  protected
    procedure Initialize; override;
    procedure Finalize; override;
  public
    property VB: IDirect3DVertexBuffer9 read _VB;
    property VertexCount: TG2IntU32 read _VertexCount;
    property VertexSize: TG2IntU32 read _VertexSize;
    {$if defined(G2RM_FF)}
    property VertexStride: TG2IntU32 read _VertexStride;
    property FVF: TG2IntU32 read _FVF;
    {$elseif defined(G2RM_SM2)}
    property DeclD3D: IDirect3DVertexDeclaration9 read _DeclD3D;
    {$endif}
    procedure Lock(const LockMode: TG2BufferLockMode = lmReadWrite);
    procedure UnLock;
    procedure Bind;
    procedure Unbind;
    constructor Create(const Decl: TG2VBDecl; const Count: TG2IntU32); reintroduce;
  end;
  {$elseif defined(G2Gfx_OGL)}
  TG2VertexBuffer = class (TG2Buffer)
  private
    _Gfx: TG2GfxOGL;
    _VertexSize: TG2IntU32;
    _VertexCount: TG2IntU32;
    _Decl: TG2VBDecl;
    _VB: GLUInt;
    _LockMode: TG2BufferLockMode;
    _Locked: Boolean;
    _TexCoordIndex: array[0..31] of Pointer;
    {$if defined(G2RM_SM2)}
    _BoundAttribs: TG2QuickListIntS32;
    {$endif}
    function GetTexCoordIndex(const Index: TG2IntS32): Pointer; inline;
    procedure WriteBufferData;
  protected
    procedure Initialize; override;
    procedure Finalize; override;
  public
    property VB: GLUInt read _VB;
    property VertexCount: TG2IntU32 read _VertexCount;
    property VertexSize: TG2IntU32 read _VertexSize;
    property TexCoordIndex[const Index: TG2IntS32]: Pointer read GetTexCoordIndex;
    procedure Lock(const LockMode: TG2BufferLockMode = lmReadWrite);
    procedure UnLock;
    procedure Bind;
    procedure Unbind;
    constructor Create(const Decl: TG2VBDecl; const Count: TG2IntU32); reintroduce;
  end;
  {$elseif defined(G2Gfx_GLES)}
  TG2VertexBuffer = class (TG2Buffer)
  private
    _Gfx: TG2GfxGLES;
    _VertexSize: TG2IntU32;
    _VertexCount: TG2IntU32;
    _Decl: TG2VBDecl;
    _VB: GLUInt;
    _LockMode: TG2BufferLockMode;
    _Locked: Boolean;
    _TexCoordIndex: array[0..31] of Pointer;
    function GetTexCoordIndex(const Index: TG2IntS32): Pointer; inline;
    procedure WriteBufferData;
  protected
    procedure Initialize; override;
    procedure Finalize; override;
  public
    property VB: GLUInt read _VB;
    property VertexCount: TG2IntU32 read _VertexCount;
    property VertexSize: TG2IntU32 read _VertexSize;
    property TexCoordIndex[const Index: TG2IntS32]: Pointer read GetTexCoordIndex;
    procedure Lock(const LockMode: TG2BufferLockMode = lmReadWrite);
    procedure UnLock;
    procedure Bind;
    procedure Unbind;
    constructor Create(const Decl: TG2VBDecl; const Count: TG2IntU32); reintroduce;
  end;
  {$endif}

  {$if defined(G2Gfx_D3D9)}
  TG2IndexBuffer = class (TG2Buffer)
  private
    _Gfx: TG2GfxD3D9;
    _IndexCount: TG2IntU32;
    _IB: IDirect3DIndexBuffer9;
    _LockMode: TG2BufferLockMode;
    _Locked: Boolean;
    procedure WriteBufferData;
  protected
    procedure Initialize; override;
    procedure Finalize; override;
  public
    property IB: IDirect3DIndexBuffer9 read _IB;
    property IndexCount: TG2IntU32 read _IndexCount;
    procedure Lock(const LockMode: TG2BufferLockMode = lmReadWrite);
    procedure UnLock;
    procedure Bind;
    procedure Unbind;
    constructor Create(const Count: TG2IntU32);
  end;
  {$elseif defined(G2Gfx_OGL)}
  TG2IndexBuffer = class (TG2Buffer)
  private
    _Gfx: TG2GfxOGL;
    _IndexCount: TG2IntU32;
    _IB: GLUInt;
    _LockMode: TG2BufferLockMode;
    _Locked: Boolean;
    procedure WriteBufferData;
  protected
    procedure Initialize; override;
    procedure Finalize; override;
  public
    property IndexCount: TG2IntU32 read _IndexCount;
    procedure Lock(const LockMode: TG2BufferLockMode = lmReadWrite);
    procedure UnLock;
    procedure Bind;
    procedure Unbind;
    constructor Create(const Count: TG2IntU32);
  end;
  {$elseif defined(G2Gfx_GLES)}
  TG2IndexBuffer = class (TG2Buffer)
  private
    _Gfx: TG2GfxGLES;
    _IndexCount: TG2IntU32;
    _IB: GLUInt;
    _LockMode: TG2BufferLockMode;
    _Locked: Boolean;
    procedure WriteBufferData;
  protected
    procedure Initialize; override;
    procedure Finalize; override;
  public
    property IndexCount: TG2IntU32 read _IndexCount;
    procedure Lock(const LockMode: TG2BufferLockMode = lmReadWrite);
    procedure UnLock;
    procedure Bind;
    procedure Unbind;
    constructor Create(const Count: TG2IntU32);
  end;
  {$endif}

  TG2FontCharProps = record
    Width: TG2IntS32;
    Height: TG2IntS32;
    OffsetX: TG2IntS32;
    OffsetY: TG2IntS32;
  end;

  TG2Font = class (TG2Asset)
  protected
    _Props: array[TG2IntU8] of TG2FontCharProps;
    _CharSpaceX: TG2IntS32;
    _CharSpaceY: TG2IntS32;
    _Texture: TG2Texture2D;
    procedure Initialize; override;
    procedure Finalize; override;
    function GetProps(const Index: TG2IntU8): TG2FontCharProps; inline;
  public
    class function SharedAsset(const SharedAssetName: String): TG2Font;
    property Texture: TG2Texture2D read _Texture;
    property Props[const Index: TG2IntU8]: TG2FontCharProps read GetProps;
    function TextWidth(const Text: AnsiString): TG2IntS32; overload;
    function TextWidth(const Text: AnsiString; const PosStart, PosEnd: TG2IntS32): TG2IntS32; overload;
    function TextHeight(const Text: AnsiString): TG2IntS32;
    procedure Make(const Size: TG2IntS32; const Face: AnsiString = {$ifdef G2Target_Linux}'Serif'{$else}'Times New Roman'{$endif});
    procedure Load(const Stream: TStream); overload;
    procedure Load(const FileName: String); overload;
    procedure Load(const Buffer: Pointer; const Size: TG2IntS32); overload;
    procedure Load(const DataManager: TG2DataManager); overload;
    procedure Print(
      const x, y, ScaleX, ScaleY: TG2Float;
      const Color: TG2Color;
      const Text: AnsiString;
      const BlendMode: TG2BlendMode;
      const Filter: TG2Filter;
      const Display: TG2Display2D = nil
    ); overload;
    procedure Print(
      const x, y, ScaleX, ScaleY: TG2Float;
      const Text: AnsiString;
      const BlendMode: TG2BlendMode;
      const Filter: TG2Filter;
      const Display: TG2Display2D = nil
    ); overload;
    procedure Print(
      const x, y, ScaleX, ScaleY: TG2Float;
      const Text: AnsiString;
      const Display: TG2Display2D = nil
    ); overload;
    procedure Print(
      const x, y: TG2Float;
      const Text: AnsiString;
      const Display: TG2Display2D = nil
    ); overload;
    procedure Print3D(
      const Pos, DirX, DirY: TG2Vec3;
      const ScaleX, ScaleY: TG2Float;
      const WVP: TG2Mat;
      const Text: AnsiString;
      const Color: TG2Color;
      const BlendMode: TG2BlendMode;
      const Filter: TG2Filter
    );
  end;

  {$if defined(G2RM_SM2)}
  {$if defined(G2Gfx_D3D9)}
  TG2ShaderParam = record
    ParamType: TG2IntU8;
    Name: AnsiString;
    Pos: TG2IntS32;
    Size: TG2IntS32;
  end;
  TG2ShaderParams = array of TG2ShaderParam;
  {$endif}

  TG2VertexShader = record
    Name: AnsiString;
    {$if defined(G2Gfx_D3D9)}
    Prog: IDirect3DVertexShader9;
    Params: TG2ShaderParams;
    {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
    Prog: GLHandle;
    {$endif}
  end;
  PG2VertexShader = ^TG2VertexShader;

  TG2PixelShader = record
    Name: AnsiString;
    {$if defined(G2Gfx_D3D9)}
    Prog: IDirect3DPixelShader9;
    Params: TG2ShaderParams;
    {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
    Prog: GLHandle;
    {$endif}
  end;
  PG2PixelShader = ^TG2PixelShader;

  TG2ShaderMethod = record
    Name: AnsiString;
    VertexShader: PG2VertexShader;
    PixelShader: PG2PixelShader;
    {$if defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
    ShaderProgram: GLHandle;
    {$endif}
  end;

  TG2ShaderGroup = class (TG2Res)
  private
    _Gfx: {$if defined(G2Gfx_D3D9)}TG2GfxD3D9{$elseif defined(G2Gfx_OGL)}TG2GfxOGL{$elseif defined(G2Gfx_GLES)}TG2GfxGLES{$endif};
    _VertexShaders: TG2QuickList;
    _PixelShaders: TG2QuickList;
    _Methods: TG2QuickList;
    _Method: TG2IntS32;
    function GetMethod: AnsiString;
    procedure SetMethod(const Value: AnsiString);
    procedure SetMethodIndex(const Value: TG2IntS32); inline;
    {$if defined(G2Gfx_D3D9)}
    function ParamVS(const Name: AnsiString): TG2IntS32;
    function ParamPS(const Name: AnsiString): TG2IntS32;
    {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
    function Param(const Name: AnsiString): GLInt;
    {$endif}
  protected
    procedure Initialize; override;
    procedure Finalize; override;
  public
    property Method: AnsiString read GetMethod write SetMethod;
    property MethodIndex: TG2IntS32 read _Method write SetMethodIndex;
    function FindMethodIndex(const Name: String): TG2IntS32;
    procedure Load(const Stream: TStream); overload;
    procedure Load(const FileName: String); overload;
    procedure Load(const Buffer: Pointer; const Size: TG2IntS32); overload;
    procedure Load(const DataManager: TG2DataManager); overload;
    procedure UniformMatrix4x4(const Name: AnsiString; const m: TG2Mat);
    procedure UniformMatrix4x4Arr(const Name: AnsiString; const m: PG2Mat; const ArrPos, Count: TG2IntS32);
    procedure UniformMatrix4x3(const Name: AnsiString; const m: TG2Mat);
    procedure UniformMatrix4x3Arr(const Name: AnsiString; const m: PG2Mat; const ArrPos, Count: TG2IntS32);
    procedure UniformFloat4(const Name: AnsiString; const v: TG2Vec4);
    procedure UniformFloat3(const Name: AnsiString; const v: TG2Vec3);
    procedure UniformFloat2(const Name: AnsiString; const v: TG2Vec2);
    procedure UniformFloat1(const Name: AnsiString; const v: TG2Float);
    procedure UniformInt1(const Name: AnsiString; const i: TG2IntS32);
    procedure Sampler(const Name: AnsiString; const Texture: TG2TextureBase; const {%H-}Stage: TG2IntS32 = 0);
    {$if defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
    function Attribute(const Name: AnsiString): GLInt;
    {$endif}
    procedure Clear;
  end;
  {$endif}

  TG2RenderControl = class
  protected
    _Gfx: {$if defined(G2Gfx_D3D9)}TG2GfxD3D9{$elseif defined(G2Gfx_OGL)}TG2GfxOGL{$elseif defined(G2Gfx_GLES)}TG2GfxGLES{$endif};
    _FillID: PG2IntS32;
    _DrawID: PG2IntS32;
    procedure RenderBegin; virtual; abstract;
    procedure RenderEnd; virtual; abstract;
    procedure RenderData(const Data: Pointer); virtual; abstract;
    procedure Reset; virtual; abstract;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TG2StateChageType = (
    stClear,
    stRenderTarget,
    stScissor,
    stDepthEnable,
    stDepthWriteEnable
  );

  TG2StateChange = record
    StateType: TG2StateChageType;
    Data: Pointer;
    DataSize: TG2IntS32;
  end;
  PG2StateChange = ^TG2StateChange;

  TG2RenderControlStateChange = class (TG2RenderControl)
  private
    var _Queue: array[0..1] of array of PG2StateChange;
    var _QueueCapacity: array[0..1] of TG2IntS32;
    var _QueueCount: array[0..1] of TG2IntS32;
    var _RenderTarget: TG2Texture2DRT;
    var _ScissorRect: TRect;
    var _Scissor: PRect;
    var _DepthEnable: Boolean;
    var _DepthWriteEnable: Boolean;
    procedure CheckCapacity;
    function PrepareData(const StateType: TG2StateChageType; const Size: TG2IntS32): Pointer;
    procedure SetRenderTarget(const RenderTarget: TG2Texture2DRT);
    procedure SetScissor(const ScissorRect: PRect);
    procedure SetDepthEnable(const Value: Boolean);
    procedure SetDepthWriteEnable(const Value: Boolean);
  public
    property StateRenderTarget: TG2Texture2DRT read _RenderTarget write SetRenderTarget;
    property StateScissor: PRect read _Scissor write SetScissor;
    property StateDepthEnable: Boolean read _DepthEnable write SetDepthEnable;
    property StateDepthWriteEnable: Boolean read _DepthWriteEnable write SetDepthWriteEnable;
    procedure StateClear(const Color: TG2Color); overload;
    procedure StateClear(
      const Color: Boolean; const ColorValue: TG2Color;
      const Depth: Boolean = True; const DepthValue: TG2Float = 1;
      const Stencil: Boolean = False; const StencilValue: TG2IntU8 = 0
    ); overload;
    procedure RenderBegin; override;
    procedure RenderEnd; override;
    procedure RenderData(const Data: Pointer); override;
    procedure Reset; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TG2PrimitiveType = (
    ptPointList = 1,
    ptLineList = 2,
    ptLineStrip = 3,
    ptTriangleList = 4,
    ptTriangleStrip = 5,
    ptTriangleFan = 6
  );

  TG2ManagedRenderObject = class
  protected
    _DrawID: PG2IntS32;
    _FillID: PG2IntS32;
    procedure DoRender; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Render;
  end;

  TG2RenderControlManaged = class (TG2RenderControl)
  private
    _Queue: array[0..1] of array of TG2ManagedRenderObject;
    _QueueCapacity: array[0..1] of TG2IntS32;
    _QueueCount: array[0..1] of TG2IntS32;
    procedure CheckCapacity;
  public
    procedure RenderObject(const Obj: TG2ManagedRenderObject);
    procedure RenderBegin; override;
    procedure RenderEnd; override;
    procedure RenderData(const Data: Pointer); override;
    procedure Reset; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  {$if defined(G2RM_SM2)}
  TG2RenderControlBuffer = class (TG2RenderControl)
  private
    type TParamType = (
      pt_float,
      pt_vec2,
      pt_vec3,
      pt_vec4,
      pt_mat4x4,
      pt_mat4x3
    );
    type TShaderParam = record
      ParamType: TParamType;
      Name: String;
      Index: TG2IntS32;
      Count: TG2IntS32;
      Data: array of TG2IntU8;
    end;
    type TShaderSampler  = record
      Name: String;
      Texture: TG2TextureBase;
    end;
    type TBufferData = record
      PrimType: TG2PrimitiveType;
      VertexBuffer: TG2VertexBuffer;
      IndexBuffer: TG2IndexBuffer;
      ShaderGroup: TG2ShaderGroup;
      Method: TG2IntS32;
      Params: array of TShaderParam;
      ParamCount: TG2IntS32;
      Samplers: array of TShaderSampler;
      SamplerCount: TG2IntS32;
      VertexStart: TG2IntS32;
      VertexCount: TG2IntS32;
      IndexStart: TG2IntS32;
      PrimCount: TG2IntS32;
    end;
    type PBufferData = ^TBufferData;
    var _Queue: array[0..1] of array of PBufferData;
    var _QueueCapacity: array[0..1] of TG2IntS32;
    var _QueueCount: array[0..1] of TG2IntS32;
    var _CurData: PBufferData;
    var _Cache: TG2QuickList;
    procedure CheckCapacity;
    procedure AddParam(
      const ParamType: TParamType;
      const Name: String;
      const Index: TG2IntS32;
      const Count: TG2IntS32;
      const Data: PG2IntU8;
      const DataSize: TG2IntS32
    ); inline;
  public
    procedure BufferBegin(
      const PrimType: TG2PrimitiveType;
      const VertexBuffer: TG2VertexBuffer;
      const IndexBuffer: TG2IndexBuffer;
      const ShaderGroup: TG2ShaderGroup;
      const Method: String;
      const VertexStart: TG2IntS32;
      const VertexCount: TG2IntS32;
      const IndexStart: TG2IntS32;
      const PrimCount: TG2IntS32
    );
    procedure BufferEnd;
    procedure ParamVec2(const Name: String; const Data: TG2Vec2);
    procedure ParamVec3(const Name: String; const Data: TG2Vec3);
    procedure ParamVec4(const Name: String; const Data: TG2Vec4);
    procedure ParamMat4x4(const name: String; const Data: TG2Mat);
    procedure ParamMat4x3(const name: String; const Data: TG2Mat);
    procedure ParamMat4x4Arr(const Name: String; const Data: PG2MatArr; const Index, Count: TG2IntS32);
    procedure ParamMat4x3Arr(const Name: String; const Data: PG2MatArr; const Index, Count: TG2IntS32);
    procedure Sampler(const Name: String; const Texture: TG2Texture2DBase);
    procedure RenderBegin; override;
    procedure RenderEnd; override;
    procedure RenderData(const Data: Pointer); override;
    procedure Reset; override;
    constructor Create; override;
    destructor Destroy; override;
  end;
  {$endif}

  TG2RenderControlLegacyMesh = class (TG2RenderControl)
  private
    type TBufferData = record
      Skinned: Boolean;
      W, V, P: TG2Mat;
      Color: TG2Color;
      VertexBuffer: TG2VertexBuffer;
      IndexBuffer: TG2IndexBuffer;
      {$if defined(G2RM_SM2)}
      BoneCount: TG2IntS32;
      SkinPallete: array of TG2Mat;
      {$endif}
      GroupCount: TG2IntS32;
      Groups: array of record
        {$if defined(G2RM_SM2)}
        Method: TG2IntS32;
        {$endif}
        ColorTexture: TG2Texture2DBase;
        LightTexture: TG2Texture2DBase;
        VertexStart: TG2IntS32;
        VertexCount: TG2IntS32;
        IndexStart: TG2IntS32;
        PrimCount: TG2IntS32;
      end;
    end;
    type PBufferData = ^TBufferData;
    {$if defined(G2RM_SM2)}
    var _ShaderGroup: TG2ShaderGroup;
    {$endif}
    var _Queue: array[0..1] of array of PBufferData;
    var _QueueCapacity: array[0..1] of TG2IntS32;
    var _QueueCount: array[0..1] of TG2IntS32;
    {$if defined(G2Gfx_D3D9)}
    procedure RenderD3D9(const p: PBufferData);
    {$elseif defined(G2Gfx_OGL)}
    procedure RenderOGL(const p: PBufferData);
    {$elseif defined(G2Gfx_GLES)}
    procedure RenderGLES(const p: PBufferData);
    {$endif}
    procedure CheckCapacity;
  public
    procedure RenderInstance(const Instance: TG2LegacyMeshInst; const W, V, P: TG2Mat);
    procedure RenderBegin; override;
    procedure RenderEnd; override;
    procedure RenderData(const Data: Pointer); override;
    procedure Reset; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TG2Pic2D = record
    Pos0, Pos1, Pos2, Pos3: TG2Vec2;
    Tex0, Tex1, Tex2, Tex3: TG2Vec2;
    c0, c1, c2, c3: TG2Color;
    Texture: TG2Texture2DBase;
    BlendMode: TG2BlendMode;
    Filter: TG2Filter;
  end;
  PG2Pic2D = ^TG2Pic2D;

  {$ifdef G2Gfx_D3D9}
  {$if defined(G2RM_FF)}
  TG2Pic2DVertex = packed record
    x, y, z, rhw: TG2Float;
    Color: TG2Color;
    tu, tv: TG2Float;
  end;
  {$elseif defined(G2RM_SM2)}
  TG2Pic2DVertex = packed record
    x, y, z: TG2Float;
    Color: TG2Color;
    tu, tv: TG2Float;
  end;
  {$endif}
  PG2Pic2DVertex = ^TG2Pic2DVertex;
  TG2Pic2DVertexArr = array[Word] of TG2Pic2DVertex;
  PG2Pic2DVertexArr = ^TG2Pic2DVertexArr;
  {$endif}

  TG2RenderControlPic2D = class(TG2RenderControl)
  private
    _Queue: array[0..1] of array of PG2Pic2D;
    _QueueCapacity: array[0..1] of TG2IntS32;
    _QueueCount: array[0..1] of TG2IntS32;
    _MaxQuads: TG2IntS32;
    _CurTexture: TG2Texture2DBase;
    _CurBlendMode: TG2BlendMode;
    _CurFilter: TG2Filter;
    _CurQuad: TG2IntS32;
    {$if defined(G2RM_SM2)}
    _ShaderGroup: TG2ShaderGroup;
    {$endif}
    {$if defined(G2Gfx_D3D9)}
    {$if defined(G2RM_SM2)}
    _Decl: IDirect3DVertexDeclaration9;
    {$endif}
    _Vertices: array of TG2Pic2DVertex;
    _Indices: array of TG2IntU16;
    {$elseif defined(G2Gfx_OGL)}
    {$if defined(G2RM_SM2)}
    _AttribPosition: GLInt;
    _AttribColor: GLInt;
    _AttribTexCoord: GLInt;
    {$endif}
    {$elseif defined(G2Gfx_GLES)}
    _Indices: array of TG2IntU16;
    _VertPositions: array of TG2Vec3;
    _VertColors: array of TG2Vec4;
    _VertTexCoords: array of TG2Vec2;
    {$endif}
    _PrevDepthEnable: Boolean;
    procedure CheckCapacity;
    procedure Flush;
  public
    procedure DrawQuad(
      const Pos0, Pos1, Pos2, Pos3: TG2Vec2;
      const Tex0, Tex1, Tex2, Tex3: TG2Vec2;
      const c0, c1, c2, c3: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filter: TG2Filter = tfPoint
    );
    procedure RenderBegin; override;
    procedure RenderEnd; override;
    procedure RenderData(const Data: Pointer); override;
    procedure Reset; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TG2Prim2DPoint = record
    x, y: TG2Float;
    Color: TG2Color;
  end;

  TG2Prim2D = record
    Points: array of TG2Prim2DPoint;
    Count: TG2IntS32;
    PrimType: TG2PrimType;
    BlendMode: TG2BlendMode;
  end;
  PG2Prim2D = ^TG2Prim2D;

  {$if defined(G2Gfx_D3D9)}
  {$if defined(G2RM_FF)}
  TG2Prim2DVertex = packed record
    x, y, z, rhw: TG2Float;
    Color: TG2Color;
  end;
  {$elseif defined(G2RM_SM2)}
  TG2Prim2DVertex = packed record
    x, y, z: TG2Float;
    Color: TG2Color;
  end;
  {$endif}
  PG2Prim2DVertex = ^TG2Prim2DVertex;
  TG2Prim2DVertexArr = array[Word] of TG2Prim2DVertex;
  PG2Prim2DVertexArr = ^TG2Prim2DVertexArr;
  {$endif}

  TG2RenderControlPrim2D = class(TG2RenderControl)
  private
    _Queue: array[0..1] of array of PG2Prim2D;
    _QueueCapacity: array[0..1] of TG2IntS32;
    _QueueCount: array[0..1] of TG2IntS32;
    _CurPoint: TG2IntS32;
    _CurPrim: PG2Prim2D;
    _CurPrimType: TG2PrimType;
    _CurBlendMode: TG2BlendMode;
    _MaxPoints: TG2IntS32;
    {$if defined(G2RM_SM2)}
    _ShaderGroup: TG2ShaderGroup;
    {$endif}
    {$if defined(G2Gfx_D3D9)}
    {$if defined(G2RM_SM2)}
    _Decl: IDirect3DVertexDeclaration9;
    {$endif}
    _Vertices: array of TG2Prim2DVertex;
    {$elseif defined(G2Gfx_OGL)}
    {$if defined(G2RM_SM2)}
    _AttribPosition: GLInt;
    _AttribColor: GLInt;
    {$endif}
    {$elseif defined(G2Gfx_GLES)}
    _VertPositions: array of TG2Vec3;
    _VertColors: array of TG2Vec4;
    _Indices: array of TG2IntU16;
    {$endif}
    _PrevDepthEnable: Boolean;
    procedure CheckCapacity;
    procedure Flush;
  public
    procedure PrimBegin(const PrimType: TG2PrimType; const BlendMode: TG2BlendMode); inline;
    procedure PrimEnd; inline;
    procedure PrimAdd(const x, y: TG2Float; const Color: TG2Color); inline;
    procedure RenderBegin; override;
    procedure RenderEnd; override;
    procedure RenderData(const Data: Pointer); override;
    procedure Reset; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TG2Prim3DPoint = record
    x, y, z: TG2Float;
    Color: TG2Color;
  end;

  TG2Prim3D = record
    Points: array of TG2Prim3DPoint;
    Count: TG2IntS32;
    PrimType: TG2PrimType;
    BlendMode: TG2BlendMode;
    WVP: TG2Mat;
  end;
  PG2Prim3D = ^TG2Prim3D;

  {$if defined(G2Gfx_D3D9)}
  {$if defined(G2RM_FF)}
  TG2Prim3DVertex = packed record
    x, y, z: TG2Float;
    Color: TG2Color;
  end;
  {$elseif defined(G2RM_SM2)}
  TG2Prim3DVertex = packed record
    x, y, z: TG2Float;
    Color: TG2Color;
  end;
  {$endif}
  PG2Prim3DVertex = ^TG2Prim3DVertex;
  TG2Prim3DVertexArr = array[Word] of TG2Prim3DVertex;
  PG2Prim3DVertexArr = ^TG2Prim3DVertexArr;
  {$endif}

  TG2RenderControlPrim3D = class(TG2RenderControl)
  private
    _Queue: array[0..1] of array of PG2Prim3D;
    _QueueCapacity: array[0..1] of TG2IntS32;
    _QueueCount: array[0..1] of TG2IntS32;
    _CurPoint: TG2IntS32;
    _CurPrim: PG2Prim3D;
    _CurPrimType: TG2PrimType;
    _CurBlendMode: TG2BlendMode;
    _CurWVP: TG2Mat;
    _MaxPoints: TG2IntS32;
    {$if defined(G2RM_SM2)}
    _ShaderGroup: TG2ShaderGroup;
    {$endif}
    {$if defined(G2Gfx_D3D9)}
    {$if defined(G2RM_SM2)}
    _Decl: IDirect3DVertexDeclaration9;
    {$endif}
    _Vertices: array of TG2Prim3DVertex;
    {$elseif defined(G2Gfx_OGL)}
    {$if defined(G2RM_SM2)}
    _AttribPosition: GLInt;
    _AttribColor: GLInt;
    {$endif}
    {$elseif defined(G2Gfx_GLES)}
    _VertPositions: array of TG2Vec3;
    _VertColors: array of TG2Vec4;
    _Indices: array of TG2IntU16;
    {$endif}
    procedure CheckCapacity;
    procedure Flush;
  public
    procedure PrimBegin(const PrimType: TG2PrimType; const BlendMode: TG2BlendMode; const WVP: TG2Mat); inline;
    procedure PrimEnd; inline;
    procedure PrimAdd(const x, y, z: TG2Float; const Color: TG2Color); overload;
    procedure PrimAdd(const v: TG2Vec3; const Color: TG2Color); inline; overload;
    procedure RenderBegin; override;
    procedure RenderEnd; override;
    procedure RenderData(const Data: Pointer); override;
    procedure Reset; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TG2Poly2DPoint = record
    x, y: TG2Float;
    Color: TG2Color;
    u, v: TG2Float;
  end;

  TG2Poly2D = record
    PolyType: TG2PrimType;
    Points: array of TG2Poly2DPoint;
    Count: TG2IntS32;
    Texture: TG2Texture2DBase;
    BlendMode: TG2BlendMode;
    Filter: TG2Filter;
  end;
  PG2Poly2D = ^TG2Poly2D;

  {$if defined(G2Gfx_D3D9)}
  {$if defined(G2RM_FF)}
  TG2Poly2DVertex = packed record
    x, y, z, rhw: TG2Float;
    Color: TG2Color;
    tu, tv: TG2Float;
  end;
  {$elseif defined(G2RM_SM2)}
  TG2Poly2DVertex = packed record
    x, y, z: TG2Float;
    Color: TG2Color;
    tu, tv: TG2Float;
  end;
  {$endif}
  PG2Poly2DVertex = ^TG2Poly2DVertex;
  TG2Poly2DVertexArr = array[Word] of TG2Poly2DVertex;
  PG2Poly2DVertexArr = ^TG2Poly2DVertexArr;
  {$endif}

  TG2RenderControlPoly2D = class(TG2RenderControl)
  private
    _Queue: array[0..1] of array of PG2Poly2D;
    _QueueCapacity: array[0..1] of TG2IntS32;
    _QueueCount: array[0..1] of TG2IntS32;
    _CurPoint: TG2IntS32;
    _CurIndex: TG2IntS32;
    _CurPoly: PG2Poly2D;
    _CurPolyType: TG2PrimType;
    _CurTexture: TG2Texture2DBase;
    _CurBlendMode: TG2BlendMode;
    _CurFilter: TG2Filter;
    _MaxPoints: TG2IntS32;
    {$if defined(G2RM_SM2)}
    _ShaderGroup: TG2ShaderGroup;
    {$endif}
    {$if defined(G2Gfx_D3D9)}
    {$if defined(G2RM_SM2)}
    _Decl: IDirect3DVertexDeclaration9;
    {$endif}
    _Vertices: array of TG2Poly2DVertex;
    {$elseif defined(G2Gfx_OGL)}
    {$if defined(G2RM_SM2)}
    _AttribPosition: GLInt;
    _AttribColor: GLInt;
    _AttribTexCoord: GLInt;
    {$endif}
    {$elseif defined(G2Gfx_GLES)}
    _VertPositions: array of TG2Vec3;
    _VertColors: array of TG2Vec4;
    _VertTexCoords: array of TG2Vec2;
    _Indices: array of TG2IntU16;
    {$endif}
    _PrevDepthEnable: Boolean;
    procedure CheckCapacity;
    procedure Flush;
  public
    procedure PolyBegin(const PolyType: TG2PrimType; const Texture: TG2Texture2DBase; const BlendMode: TG2BlendModeRef = bmNormal; const Filter: TG2Filter = tfPoint);
    procedure PolyEnd;
    procedure PolyAdd(const x, y, u, v: TG2Float; const Color: TG2Color); overload;
    procedure PolyAdd(const Pos, TexCoord: TG2Vec2; const Color: TG2Color); inline; overload;
    procedure RenderBegin; override;
    procedure RenderEnd; override;
    procedure RenderData(const Data: Pointer); override;
    procedure Reset; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TG2Poly3DPoint = record
    x, y, z, u, v: TG2Float;
    Color: TG2Color;
  end;

  TG2Poly3D = record
    Points: array of TG2Poly3DPoint;
    Count: TG2IntS32;
    PrimType: TG2PrimType;
    BlendMode: TG2BlendMode;
    Texture: TG2Texture2DBase;
    Filter: TG2Filter;
    WVP: TG2Mat;
  end;
  PG2Poly3D = ^TG2Poly3D;

  {$if defined(G2Gfx_D3D9)}
  TG2Poly3DVertex = packed record
    x, y, z: TG2Float;
    Color: TG2Color;
    u, v: TG2Float;
  end;
  PG2Poly3DVertex = ^TG2Poly3DVertex;
  TG2Poly3DVertexArr = array[Word] of TG2Poly3DVertex;
  PG2Poly3DVertexArr = ^TG2Poly3DVertexArr;
  {$endif}

  TG2RenderControlPoly3D = class(TG2RenderControl)
  private
    _Queue: array[0..1] of array of PG2Poly3D;
    _QueueCapacity: array[0..1] of TG2IntS32;
    _QueueCount: array[0..1] of TG2IntS32;
    _CurPoint: TG2IntS32;
    _CurPoly: PG2Poly3D;
    _CurPrimType: TG2PrimType;
    _CurBlendMode: TG2BlendMode;
    _CurTexture: TG2Texture2DBase;
    _CurFilter: TG2Filter;
    _CurWVP: TG2Mat;
    _MaxPoints: TG2IntS32;
    {$if defined(G2RM_SM2)}
    _ShaderGroup: TG2ShaderGroup;
    {$endif}
    {$if defined(G2Gfx_D3D9)}
    {$if defined(G2RM_SM2)}
    _Decl: IDirect3DVertexDeclaration9;
    {$endif}
    _Vertices: array of TG2Poly3DVertex;
    {$elseif defined(G2Gfx_OGL)}
    {$if defined(G2RM_SM2)}
    _AttribPosition: GLInt;
    _AttribColor: GLInt;
    _AttribTexCoord: GLInt;
    {$endif}
    {$elseif defined(G2Gfx_GLES)}
    _VertPositions: array of TG2Vec3;
    _VertColors: array of TG2Vec4;
    _Indices: array of TG2IntU16;
    {$endif}
    procedure CheckCapacity;
    procedure Flush;
  public
    procedure PolyBegin(
      const PrimType: TG2PrimType;
      const Texture: TG2Texture2DBase;
      const WVP: TG2Mat;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filter: TG2Filter = tfLinear
    ); inline;
    procedure PolyEnd; inline;
    procedure PolyAdd(const x, y, z, u, v: TG2Float; const Color: TG2Color); overload;
    procedure PolyAdd(const v: TG2Vec3; const t: TG2Vec2; const Color: TG2Color); inline; overload;
    procedure RenderBegin; override;
    procedure RenderEnd; override;
    procedure RenderData(const Data: Pointer); override;
    procedure Reset; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TG2Display2DMode = (d2dStretch, d2dFit, d2dOversize, d2dCenter);

  TG2Display2D = class
  private
    _Pos: TG2Vec2;
    _Rotation: TG2Float;
    _rs, _rc: TG2Float;
    _Width: TG2IntS32;
    _Height: TG2IntS32;
    _WidthScr: TG2IntS32;
    _HeightScr: TG2IntS32;
    _Mode: TG2Display2DMode;
    _Zoom: TG2Float;
    _ScreenScaleX: Single;
    _ScreenScaleY: Single;
    _ScreenScaleMin: Single;
    _ScreenScaleMax: Single;
    _ConvertCoord: TG2Vec4;
    _ViewPort: TRect;
    _AutoResizeViewport: Boolean;
    procedure SetMode(const Value: TG2Display2DMode); inline;
    procedure SetWidth(const Value: TG2IntS32); inline;
    procedure SetHeight(const Value: TG2IntS32); inline;
    procedure SetZoom(const Value: TG2Float); inline;
    procedure SetRotation(const Value: TG2Float); inline;
    procedure SetViewPort(const Value: TRect); inline;
    procedure UpdateMode;
    function GetRotationVector: TG2Vec2; inline;
    procedure OnResize(const OldWidth, OldHeight, NewWidth, NewHeight: TG2IntS32);
    procedure SetAutoResizeViewport(const Value: Boolean);
  public
    property Position: TG2Vec2 read _Pos write _Pos;
    property Rotation: TG2Float read _Rotation write SetRotation;
    property Width: TG2IntS32 read _Width write SetWidth;
    property Height: TG2IntS32 read _Height write SetHeight;
    property WidthScr: TG2IntS32 read _WidthScr;
    property HeightScr: TG2IntS32 read _HeightScr;
    property Zoom: TG2Float read _Zoom write SetZoom;
    property Mode: TG2Display2DMode read _Mode write SetMode;
    property RotationVector: TG2Vec2 read GetRotationVector;
    property ScreenScaleX: Single read _ScreenScaleX;
    property ScreenScaleY: Single read _ScreenScaleY;
    property ScreenScaleMin: Single read _ScreenScaleMin;
    property ScreenScaleMax: Single read _ScreenScaleMax;
    property ViewPort: TRect read _ViewPort write SetViewPort;
    property AutoResizeViewport: Boolean read _AutoResizeViewport write SetAutoResizeViewport;
    constructor Create;
    destructor Destroy; override;
    function CoordToScreen(const Coord: TG2Vec2): TG2Vec2;
    function CoordToDisplay(const Coord: TG2Vec2): TG2Vec2;
    function ScreenBounds: TG2Rect;
    procedure PicQuadCol(
      const Pos0, Pos1, Pos2, Pos3, Tex0, Tex1, Tex2, Tex3: TG2Vec2;
      const Col0, Col1, Col2, Col3: TG2Color;
      const Texture: TG2Texture2DBase; const BlendMode: TG2IntU32 = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicQuadCol(
      const x0, y0, x1, y1, x2, y2, x3, y3, tu0, tv0, tu1, tv1, tu2, tv2, tu3, tv3: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicQuad(
      const Pos0, Pos1, Pos2, Pos3, Tex0, Tex1, Tex2, Tex3: TG2Vec2;
      const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicQuad(
      const x0, y0, x1, y1, x2, y2, x3, y3, tu0, tv0, tu1, tv1, tu2, tv2, tu3, tv3: TG2Float;
      const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRectCol(
      const Pos: TG2Vec2;
      const w, h: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const TexRect: TG2Vec4;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRectCol(
      const x, y: TG2Float;
      const w, h: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const tu0, tv0, tu1, tv1: TG2Float;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRectCol(
      const Pos: TG2Vec2;
      const w, h: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRectCol(
      const x, y: TG2Float;
      const w, h: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRectCol(
      const Pos: TG2Vec2;
      const Col0, Col1, Col2, Col3: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRectCol(
      const x, y: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRectCol(
      const Pos: TG2Vec2;
      const w, h: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const FrameWidth, FrameHeight: TG2IntS32;
      const FrameID: TG2IntS32;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRectCol(
      const x, y: TG2Float;
      const w, h: TG2Float;
      const Col0, Col1, Col2, Col3: TG2Color;
      const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const FrameWidth, FrameHeight: TG2IntS32;
      const FrameID: TG2IntS32;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRectCol(
      const Pos: TG2Vec2;
      const w, h: TG2Float;
      const TexRect: TG2Rect;
      const Col0, Col1, Col2, Col3: TG2Color;
      const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRectCol(
      const x, y: TG2Float;
      const w, h: TG2Float;
      const TexRect: TG2Rect;
      const Col0, Col1, Col2, Col3: TG2Color;
      const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload;
    procedure PicRect(
      const Pos: TG2Vec2; const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRect(
      const x, y: TG2Float; const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRect(
      const Pos: TG2Vec2;
      const w, h: TG2Float;
      const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRect(
      const x, y: TG2Float;
      const w, h: TG2Float;
      const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRect(
      const Pos: TG2Vec2;
      const w, h: TG2Float;
      const TexRect: TG2Vec4;
      const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRect(
      const x, y: TG2Float;
      const w, h: TG2Float;
      const tu0, tv0, tu1, tv1: TG2Float;
      const Col: TG2Color;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRect(
      const Pos: TG2Vec2;
      const w, h: TG2Float;
      const Col: TG2Color;
      const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const FrameWidth, FrameHeight: TG2IntS32;
      const FrameID: TG2IntS32;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRect(
      const x, y: TG2Float;
      const w, h: TG2Float;
      const Col: TG2Color;
      const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const FrameWidth, FrameHeight: TG2IntS32;
      const FrameID: TG2IntS32;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRect(
      const Pos: TG2Vec2;
      const w, h: TG2Float;
      const TexRect: TG2Rect;
      const Color: TG2Color;
      const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); inline; overload;
    procedure PicRect(
      const x, y: TG2Float;
      const w, h: TG2Float;
      const TexRect: TG2Rect;
      const Color: TG2Color;
      const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
      const FlipU, FlipV: Boolean;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
    ); overload; inline;
    procedure PrimBegin(const PrimType: TG2PrimType; const BlendMode: TG2BlendMode); inline;
    procedure PrimEnd; inline;
    procedure PrimAdd(const x, y: TG2Float; const Color: TG2Color); inline; overload;
    procedure PrimAdd(const v: TG2Vec2; const Color: TG2Color); inline; overload;
    procedure PrimLineCol(const Pos0, Pos1: TG2Vec2; const Col0, Col1: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimLineCol(const x0, y0, x1, y1: TG2Float; const Col0, Col1: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimTriCol(const Pos0, Pos1, Pos2: TG2Vec2; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimTriCol(const x0, y0, x1, y1, x2, y2: TG2Float; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimQuadCol(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimQuadCol(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimQuad(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimQuad(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimRectCol(const x, y, w, h: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
    procedure PrimRect(const x, y, w, h: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
    procedure PrimRectHollowCol(const x, y, w, h: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
    procedure PrimRectHollow(const x, y, w, h: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
    procedure PrimCircleCol(const Pos: TG2Vec2; const Radius: TG2Float; const Col0, Col1: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimCircleCol(const x, y, Radius: TG2Float; const Col0, Col1: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimRingCol(const Pos: TG2Vec2; const Radius0, Radius1: TG2Float; const Col0, Col1: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal);
    procedure PrimRingCol(const x, y: TG2Float; const Radius0, Radius1: TG2Float; const Col0, Col1: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal);
    procedure PrimTriHollowCol(const Pos0, Pos1, Pos2: TG2Vec2; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimTriHollowCol(const x0, y0, x1, y1, x2, y2: TG2Float; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimQuadHollowCol(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimQuadHollowCol(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimCircleHollow(const Pos: TG2Vec2; const Radius: TG2Float; const Col: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimCircleHollow(const x, y, Radius: TG2Float; const Col: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimLine(const Pos0, Pos1: TG2Vec2; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PrimLine(const x0, y0, x1, y1: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal); overload;
    procedure PolyBegin(const PolyType: TG2PrimType; const Texture: TG2Texture2DBase; const BlendMode: TG2BlendModeRef = bmNormal; const Filter: TG2Filter = tfPoint);
    procedure PolyEnd;
    procedure PolyAdd(const x, y, u, v: TG2Float; const Color: TG2Color); inline; overload;
    procedure PolyAdd(const Pos, TexCoord: TG2Vec2; const Color: TG2Color); inline; overload;
  end;

{$if defined(G2RM_SM2)}
  TG2MeshNode = record
    OwnerID: TG2IntS32;
    Name: AnsiString;
    Transform: TG2Mat;
    SubNodesID: TG2QuickListIntS32;
  end;

  TG2GeomDataStatic = record
    BBox: TG2Box;
    VB: TG2VertexBuffer;
  end;
  PG2GeomDataStatic = ^TG2GeomDataStatic;

  TG2GeomDataSkinned = record
    MaxWeights: Word;
    BoneCount: TG2IntS32;
    Bones: array of record
      NodeID: TG2IntS32;
      Bind: TG2Mat;
      BBox: TG2Box;
      VCount: TG2IntS32;
    end;
    VB: TG2VertexBuffer;
  end;
  PG2GeomDataSkinned = ^TG2GeomDataSkinned;

  TG2MeshGeom = object
    NodeID: TG2IntS32;
    Decl: TG2VBDecl;
    Skinned: Boolean;
    Data: Pointer;
    VCount: TG2IntS32;
    FCount: TG2IntS32;
    GCount: TG2IntS32;
    TCount: TG2IntS32;
    IB: TG2IndexBuffer;
    Groups: array of record
      Material: TG2IntS32;
      VertexStart: TG2IntS32;
      VertexCount: TG2IntS32;
      FaceStart: TG2IntS32;
      FaceCount: TG2IntS32;
    end;
    Visible: Boolean;
  end;

  TG2MeshAnim = object
    Name: AnsiString;
    FrameRate: TG2IntS32;
    FrameCount: TG2IntS32;
    NodeCount: TG2IntS32;
    Nodes: array of record
      NodeID: TG2IntS32;
      Frames: array of record
        Scaling: TG2Vec3;
        Rotation: TG2Quat;
        Translation: TG2Vec3;
      end;
    end;
  end;

  TG2MeshMaterial = object
    ChannelCount: TG2IntS32;
    Channels: array of record
      Name: AnsiString;
      TwoSided: Boolean;
      MapDiffuse: TG2Texture2D;
      MapLight: TG2Texture2D;
    end;
  end;
  PG2MeshMaterial = ^TG2MeshMaterial;

  TG2MeshNodeArray = specialize TG2Array<TG2MeshNode>;
  TG2MeshGeomArray = specialize TG2Array<TG2MeshGeom>;
  TG2MeshAnimArray = specialize TG2Array<TG2MeshAnim>;
  TG2MeshMaterialArray = specialize TG2Array<TG2MeshMaterial>;

  TG2Mesh = class (TG2Asset)
  protected
    procedure Initialize; override;
    procedure Finalize; override;
  public
    class function SharedAsset(const SharedAssetName: String): TG2Mesh;
    var Nodes: TG2MeshNodeArray;
    var Geoms: TG2MeshGeomArray;
    var Anims: TG2MeshAnimArray;
    var Materials: TG2MeshMaterialArray;
    destructor Destroy; override;
    procedure Load(const MeshData: TG2MeshData);
    procedure Load(const DataManager: TG2DataManager);
    procedure Load(const Stream: TStream);
    procedure Load(const FileName: String);
    function AnimIndex(const Name: AnsiString): TG2IntS32;
    function NewInst: TG2MeshInst;
  end;

  TG2MeshInst = class (TG2Ref)
  private
    var _Mesh: TG2Mesh;
    var _RootNodes: TG2QuickListIntS32;
    var _SkinTransforms: array of array of TG2Mat;
    var _AutoComputeTransforms: Boolean;
    function GetOBBox: TG2Box;
    function GetGeomBBox(const Index: TG2IntS32): TG2Box;
    function GetSkinTransforms(const Index: TG2IntS32): PG2Mat; inline;
    function GetAABox: TG2AABox;
    procedure ComputeSkinTransforms;
  protected
  public
    var Transforms: array of record
      TransformDef: TG2Mat;
      TransformCur: TG2Mat;
      TransformCom: TG2Mat;
    end;
    var Materials: array of PG2MeshMaterial;
    property Mesh: TG2Mesh read _Mesh;
    property OBBox: TG2Box read GetOBBox;
    property AABox: TG2AABox read GetAABox;
    property AutoComputeTransforms: Boolean read _AutoComputeTransforms write _AutoComputeTransforms;
    property GeomBBox[const Index: TG2IntS32]: TG2Box read GetGeomBBox;
    property SkinTransforms[const Index: TG2IntS32]: PG2Mat read GetSkinTransforms;
    constructor Create(const AMesh: TG2Mesh);
    destructor Destroy; override;
    procedure FrameSetFast(const AnimName: AnsiString; const Frame: TG2IntS32);
    procedure FrameSet(const AnimName: AnsiString; const Frame: TG2Float);
    procedure ComputeTransforms;
  end;
{$endif}

  TG2S3DNode = class
  protected
    _Scene: TG2Scene3D;
    _Transform: TG2Mat;
    procedure SetTransform(const Value: TG2Mat); virtual;
  public
    property Transform: TG2Mat read _Transform write SetTransform;
    constructor Create(const Scene: TG2Scene3D); virtual;
    destructor Destroy; override;
  end;

  TG2S3DFrame = class (TG2S3dNode)
  protected
    function GetAABox: TG2AABox; virtual; abstract;
  public
    property AABox: TG2AABox read GetAABox;
    constructor Create(const Scene: TG2Scene3D); override;
    destructor Destroy; override;
  end;

  TG2S3DMeshVertex = record
    Position: TG2Vec3;
    Normal: TG2Vec3;
    TexCoord: TG2Vec2;
  end;
  PG2S3DMeshVertex = ^TG2S3DMeshVertex;

  TG2S3DMeshFace = record
    Indices: array[0..2] of TG2IntU16;
    MaterialID: TG2IntS32;
  end;
  PG2S3DMeshFace = ^TG2S3DMeshFace;

  TG2S3DMeshBuilder = object
  public
    Vertices: TG2QuickList;
    Faces: TG2QuickList;
    Materials: TG2QuickList;
    LastMaterial: TG2IntS32;
    procedure Init;
    procedure Clear;
  end;
  PG2S3DMeshBuilder = ^TG2S3DMeshBuilder;

  TG2S3DMeshNode = object
    OwnerID: TG2IntS32;
    Name: AnsiString;
    Transform: TG2Mat;
    SubNodesID: array of TG2IntS32;
  end;
  PG2S3DMeshNode = ^TG2S3DMeshNode;

  TG2S3DGeomDataStatic = object
    BBox: TG2Box;
    VB: TG2VertexBuffer;
  end;
  PG2S3DGeomDataStatic = ^TG2S3DGeomDataStatic;

  TG2S3DGeomDataSkinned = object
    MaxWeights: Word;
    BoneCount: TG2IntS32;
    Bones: array of record
      NodeID: TG2IntS32;
      Bind: TG2Mat;
      BBox: TG2Box;
      VCount: TG2IntS32;
    end;
    {$if defined(G2RM_FF)}
    Vertices: array of record
      Position: TG2Vec3;
      Normal: TG2Vec3;
      TexCoord: array of TG2Vec2;
      BoneWeightCount: TG2IntS32;
      Bones: array of TG2IntS32;
      Weights: array of TG2Float;
    end;
    {$elseif defined(G2RM_SM2)}
    VB: TG2VertexBuffer;
    {$endif}
  end;
  PG2S3DGeomDataSkinned = ^TG2S3DGeomDataSkinned;

  TG2S3DMeshGeom = object
    NodeID: TG2IntS32;
    Decl: TG2VBDecl;
    Skinned: Boolean;
    Data: Pointer;
    VCount: TG2IntS32;
    FCount: TG2IntS32;
    GCount: TG2IntS32;
    TCount: TG2IntS32;
    IB: TG2IndexBuffer;
    Groups: array of record
      Material: TG2IntS32;
      VertexStart: TG2IntS32;
      VertexCount: TG2IntS32;
      FaceStart: TG2IntS32;
      FaceCount: TG2IntS32;
    end;
    Visible: Boolean;
  end;
  PG2S3DMeshGeom = ^TG2S3DMeshGeom;

  TG2S3DMeshAnim = object
    Name: AnsiString;
    FrameRate: TG2IntS32;
    FrameCount: TG2IntS32;
    NodeCount: TG2IntS32;
    Nodes: array of record
      NodeID: TG2IntS32;
      Frames: array of record
        Scaling: TG2Vec3;
        Rotation: TG2Quat;
        Translation: TG2Vec3;
      end;
    end;
  end;
  PG2S3DMeshAnim = ^TG2S3DMeshAnim;

  TG2S3DMeshMaterial = object
    ChannelCount: TG2IntS32;
    Channels: array of record
      Name: AnsiString;
      TwoSided: Boolean;
      MapDiffuse: TG2Texture2D;
      MapLight: TG2Texture2D;
    end;
  end;
  PG2S3DMeshMaterial = ^TG2S3DMeshMaterial;

  TG2S3DMesh = class (TG2Asset)
  private
    _Instances: TG2QuickList;
    _NodeCount: TG2IntS32;
    _GeomCount: TG2IntS32;
    _AnimCount: TG2IntS32;
    _MaterialCount: TG2IntS32;
    _Nodes: array of TG2S3DMeshNode;
    _Geoms: array of TG2S3DMeshGeom;
    _Anims: array of TG2S3DMeshAnim;
    _Materials: array of TG2S3DMeshMaterial;
    _Loaded: Boolean;
    function GetNode(const Index: TG2IntS32): PG2S3DMeshNode; inline;
    function GetGeom(const Index: TG2IntS32): PG2S3DMeshGeom; inline;
    function GetAnim(const Index: TG2IntS32): PG2S3DMeshAnim; inline;
    function GetMaterial(const Index: TG2IntS32): PG2S3DMeshMaterial; inline;
  public
    class function SharedAsset(const SharedAssetName: String): TG2S3DMesh;
    property NodeCount: TG2IntS32 read _NodeCount;
    property GeomCount: TG2IntS32 read _GeomCount;
    property AnimCount: TG2IntS32 read _AnimCount;
    property MaterialCount: TG2IntS32 read _MaterialCount;
    property Nodes[const Index: TG2IntS32]: PG2S3DMeshNode read GetNode;
    property Geoms[const Index: TG2IntS32]: PG2S3DMeshGeom read GetGeom;
    property Anims[const Index: TG2IntS32]: PG2S3DMeshAnim read GetAnim;
    property Materials[const Index: TG2IntS32]: PG2S3DMeshMaterial read GetMaterial;
    constructor Create;
    destructor Destroy; override;
    procedure Load(const dm: TG2DataManager); overload;
    procedure Load(const MeshData: TG2MeshData); overload;
    function AnimIndex(const Name: AnsiString): TG2IntS32;
  end;

  TG2S3DMeshInstSkin = object
    {$if defined(G2RM_FF)}
    VB: TG2VertexBuffer;
    {$endif}
    Transforms: array of TG2Mat;
  end;
  PG2S3DMeshInstSkin = ^TG2S3DMeshInstSkin;

  TG2S3DMeshInst = class (TG2S3DFrame)
  private
    _Mesh: TG2S3DMesh;
    _RootNodes: array of TG2IntS32;
    _Skins: array of PG2S3DMeshInstSkin;
    _AutoComputeTransforms: Boolean;
    procedure SetMesh(const Value: TG2S3DMesh);
    function GetBBox: TG2Box;
    function GetGeomBBox(const Index: TG2IntS32): TG2Box;
    function GetSkin(const Index: TG2IntS32): PG2S3DMeshInstSkin; inline;
    procedure ComputeSkinTransforms;
  protected
    function GetAABox: TG2AABox; override;
  public
    Transforms: array of record
      TransformDef: TG2Mat;
      TransformCur: TG2Mat;
      TransformCom: TG2Mat;
    end;
    Materials: array of PG2S3DMeshMaterial;
    property Mesh: TG2S3DMesh read _Mesh write SetMesh;
    property BBox: TG2Box read GetBBox;
    property AutoComputeTransforms: Boolean read _AutoComputeTransforms write _AutoComputeTransforms;
    property GeomBBox[const Index: TG2IntS32]: TG2Box read GetGeomBBox;
    property Skins[const Index: TG2IntS32]: PG2S3DMeshInstSkin read GetSkin;
    constructor Create(const Scene: TG2Scene3D); override;
    destructor Destroy; override;
    procedure FrameSetFast(const AnimName: AnsiString; const Frame: TG2IntS32);
    procedure FrameSet(const AnimName: AnsiString; const Frame: TG2Float);
    procedure ComputeTransforms;
  end;

  TG2S3DParticleRender = class
  protected
    _Scene: TG2Scene3D;
  public
    constructor Create(const Scene: TG2Scene3D); virtual;
    destructor Destroy; override;
    procedure RenderBegin; virtual; abstract;
    procedure RenderEnd; virtual; abstract;
    procedure RenderParticle(const Particle: TG2S3DParticle); virtual; abstract;
  end;

  {$if defined(G2RM_FF)}
  TG2S3DParticleRenderFlat = class (TG2S3DParticleRender)
  private
    _VB: array of TG2VertexBuffer;
    _IB: TG2IndexBuffer;
    _MaxQuads: TG2IntS32;
    _VBCount: TG2IntS32;
    _CurVB: TG2IntS32;
    _CurQuad: TG2IntS32;
    _CurTexture: TG2Texture2D;
    _CurFilter: TG2Filter;
    _CurBlendMode: TG2BlendMode;
    procedure RenderFlush;
  public
    constructor Create(const Scene: TG2Scene3D); override;
    destructor Destroy; override;
    procedure RenderBegin; override;
    procedure RenderEnd; override;
    procedure RenderParticle(const Particle: TG2S3DParticle); override;
  end;
  {$elseif defined(G2RM_SM2)}
  TG2S3DParticleRenderFlat = class (TG2S3DParticleRender)
  private
    _VB: TG2VertexBuffer;
    _IB: TG2IndexBuffer;
    _MaxQuads: TG2IntS32;
    _CurQuad: TG2IntS32;
    _CurTexture: TG2Texture2D;
    _CurFilter: TG2Filter;
    _CurBlendMode: TG2BlendMode;
    _ShaderGroup: TG2ShaderGroup;
    procedure RenderFlush;
  public
    constructor Create(const Scene: TG2Scene3D); override;
    destructor Destroy; override;
    procedure RenderBegin; override;
    procedure RenderEnd; override;
    procedure RenderParticle(const Particle: TG2S3DParticle); override;
  end;
  {$endif}

  CG2S3DParticleRender = class of TG2S3DParticleRender;

  TG2S3DParticleGroup = record
    AABox: TG2AABox;
    Items: TG2QuickList;
    MinSize: TG2Float;
    MaxSize: TG2Float;
  end;
  PG2S3DParticleGroup = ^TG2S3DParticleGroup;

  TG2S3DParticle = class
  private
    _Group: PG2S3DParticleGroup;
  protected
    _Size: TG2Float;
    _Pos: TG2Vec3;
    _DepthSorted: Boolean;
    _RenderClass: CG2S3DParticleRender;
    _ParticleRender: TG2S3DParticleRender;
    _Dead: Boolean;
    function GetAABox: TG2AABox; inline;
  public
    property Size: TG2Float read _Size;
    property Pos: TG2Vec3 read _Pos write _Pos;
    property DepthSorted: Boolean read _DepthSorted write _DepthSorted;
    property RenderClass: CG2S3DParticleRender read _RenderClass;
    property ParticleRender: TG2S3DParticleRender read _ParticleRender write _ParticleRender;
    property Group: PG2S3DParticleGroup read _Group write _Group;
    property AABox: TG2AABox read GetAABox;
    property Dead: Boolean read _Dead;
    procedure Update; virtual; abstract;
    procedure Die; inline;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TG2S3DParticleFlat = class (TG2S3DParticle)
  private
    _Texture: TG2Texture2D;
    _Color: TG2Color;
    _VecX: TG2Vec3;
    _VecY: TG2Vec3;
    _Filter: TG2Filter;
    _BlendMode: TG2BlendMode;
    procedure SetVecX(const Value: TG2Vec3); inline;
    procedure SetVecY(const Value: TG2Vec3); inline;
    procedure UpdateSize;
  public
    property Texture: TG2Texture2D read _Texture write _Texture;
    property Color: TG2Color read _Color write _Color;
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

  PG2S3DOcTreeNode = ^TG2S3DOcTreeNode;
  TG2S3DOcTreeNode = object
  public
    Parent: PG2S3DOcTreeNode;
    SubNodes: array of array of array of PG2S3DOcTreeNode;
    DivX, DivY, DivZ: TG2IntS32;
    AABox: TG2AABox;
    Frames: TG2QuickList;
  end;

  TG2Scene3D = class (TG2ManagedRenderObject)
  private
    {$if defined(G2RM_SM2)}
    _ShaderGroup: TG2ShaderGroup;
    {$endif}
    _Nodes: TG2QuickList;
    _Frames: TG2QuickList;
    _MeshInst: TG2QuickList;
    _Particles: TG2QuickList;
    _NewParticles: TG2QuickList;
    _ParticleGroups: TG2QuickList;
    _ParticlesSorted: TG2QuickSortList;
    _ParticleRenders: TG2QuickList;
    _Frustum: TG2Frustum;
    _OcTreeRoot: PG2S3DOcTreeNode;
    _UpdatingParticles: Boolean;
    _StatParticlesRendered: TG2IntS32;
    _Ambient: TG2Color;
    procedure OcTreeBuild(const {%H-}MinV, {%H-}MaxV: TG2Vec3; const {%H-}Depth: TG2IntS32);
    procedure OcTreeBreak;
    function GetStatParticleGroupCount: TG2IntS32; inline;
    function GetStatParticleCount: TG2IntS32; inline;
  protected
    {$if defined(G2Gfx_D3D9)}
    _Gfx: TG2GfxD3D9;
    procedure RenderD3D9;
    {$elseif defined(G2Gfx_OGL)}
    _Gfx: TG2GfxOGL;
    procedure RenderOGL;
    {$elseif defined(G2Gfx_GLES)}
    _Gfx: TG2GfxGLES;
    procedure RenderGLES;
    {$endif}
    procedure RenderParticles;
    procedure DoRender; override;
  public
    V: TG2Mat;
    P: TG2Mat;
    property Nodes: TG2QuickList read _Nodes;
    property Frames: TG2QuickList read _Frames;
    property MeshInst: TG2QuickList read _MeshInst;
    property Ambient: TG2Color read _Ambient write _Ambient;
    property StatParticleGroupCount: TG2IntS32 read GetStatParticleGroupCount;
    property StatParticleCount: TG2IntS32 read GetStatParticleCount;
    property StatParticlesRendered: TG2IntS32 read _StatParticlesRendered;
    procedure Update;
    procedure Build;
    procedure ParticleAdd(const Particle: TG2S3DParticle);
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TG2LegacyMeshNode = object
    OwnerID: TG2IntS32;
    Name: AnsiString;
    Transform: TG2Mat;
    SubNodesID: TG2QuickListIntS32;
  end;
  PG2LegacyMeshNode = ^TG2LegacyMeshNode;

  TG2LegacyGeomDataStatic = object
    BBox: TG2Box;
    VB: TG2VertexBuffer;
  end;
  PG2LegacyGeomDataStatic = ^TG2LegacyGeomDataStatic;

  TG2LegacyGeomDataSkinned = object
    MaxWeights: Word;
    BoneCount: TG2IntS32;
    Bones: array of record
      NodeID: TG2IntS32;
      Bind: TG2Mat;
      BBox: TG2Box;
      VCount: TG2IntS32;
    end;
    {$if defined(G2RM_FF)}
    Vertices: array of record
      Position: TG2Vec3;
      Normal: TG2Vec3;
      TexCoord: array of TG2Vec2;
      BoneWeightCount: TG2IntS32;
      Bones: array of TG2IntS32;
      Weights: array of TG2Float;
    end;
    {$elseif defined(G2RM_SM2)}
    VB: TG2VertexBuffer;
    {$endif}
  end;
  PG2LegacyGeomDataSkinned = ^TG2LegacyGeomDataSkinned;

  TG2LegacyMeshGeom = object
    NodeID: TG2IntS32;
    Decl: TG2VBDecl;
    Skinned: Boolean;
    Data: Pointer;
    VCount: TG2IntS32;
    FCount: TG2IntS32;
    GCount: TG2IntS32;
    TCount: TG2IntS32;
    IB: TG2IndexBuffer;
    Groups: array of record
      Material: TG2IntS32;
      VertexStart: TG2IntS32;
      VertexCount: TG2IntS32;
      FaceStart: TG2IntS32;
      FaceCount: TG2IntS32;
    end;
    Visible: Boolean;
  end;
  PG2LegacyMeshGeom = ^TG2LegacyMeshGeom;

  TG2LegacyMeshAnim = object
    Name: AnsiString;
    FrameRate: TG2IntS32;
    FrameCount: TG2IntS32;
    NodeCount: TG2IntS32;
    Nodes: array of record
      NodeID: TG2IntS32;
      Frames: array of record
        Scaling: TG2Vec3;
        Rotation: TG2Quat;
        Translation: TG2Vec3;
      end;
    end;
  end;
  PG2LegacyMeshAnim = ^TG2LegacyMeshAnim;

  TG2LegacyMeshMaterial = object
    ChannelCount: TG2IntS32;
    Channels: array of record
      Name: AnsiString;
      TwoSided: Boolean;
      MapDiffuse: TG2Texture2D;
      MapLight: TG2Texture2D;
    end;
  end;
  PG2LegacyMeshMaterial = ^TG2LegacyMeshMaterial;

  TG2LegacyMeshNodeArray = specialize TG2Array<TG2LegacyMeshNode>;
  TG2LegacyMeshGeomArray = specialize TG2Array<TG2LegacyMeshGeom>;
  TG2LegacyMeshAnimArray = specialize TG2Array<TG2LegacyMeshAnim>;
  TG2LegacyMeshMaterialArray = specialize TG2Array<TG2LegacyMeshMaterial>;

  TG2LegacyMesh = class (TG2Asset)
  protected
    procedure Initialize; override;
    procedure Finalize; override;
  public
    class function SharedAsset(const SharedAssetName: String): TG2LegacyMesh;
    var Nodes: TG2LegacyMeshNodeArray;
    var Geoms: TG2LegacyMeshGeomArray;
    var Anims: TG2LegacyMeshAnimArray;
    var Materials: TG2LegacyMeshMaterialArray;
    procedure Release;
    procedure Load(const MeshData: TG2MeshData);
    procedure Load(const DataManager: TG2DataManager);
    procedure Load(const Stream: TStream);
    procedure Load(const FileName: String);
    function AnimIndex(const Name: AnsiString): TG2IntS32;
    function NewInst: TG2LegacyMeshInst;
  end;

  TG2LegacyMeshInstSkin = object
    {$if defined(G2RM_FF)}
    VB: array[0..1] of TG2VertexBuffer;
    VBReady: array[0..1] of Boolean;
    {$endif}
    Transforms: array of TG2Mat;
  end;
  PG2LegacyMeshInstSkin = ^TG2LegacyMeshInstSkin;

  TG2LegacyMeshInst = class (TG2Ref)
  private
    _Mesh: TG2LegacyMesh;
    _RootNodes: TG2QuickListIntS32;
    _Skins: array of PG2LegacyMeshInstSkin;
    _AutoComputeTransforms: Boolean;
    _Color: TG2Color;
    function GetOBBox: TG2Box;
    function GetGeomBBox(const Index: TG2IntS32): TG2Box;
    function GetSkinTransforms(const Index: TG2IntS32): PG2Mat; inline;
    function GetAABox: TG2AABox;
    function GetSkin(const Index: TG2IntS32): PG2LegacyMeshInstSkin; inline;
    procedure ComputeSkinTransforms;
    {$if defined(G2RM_FF)}
    procedure UpdateSkin(const GeomID, QueueID: TG2IntS32);
    {$endif}
  public
    var Transforms: array of record
      TransformDef: TG2Mat;
      TransformCur: TG2Mat;
      TransformCom: TG2Mat;
    end;
    var Materials: array of PG2LegacyMeshMaterial;
    property Mesh: TG2LegacyMesh read _Mesh;
    property OBBox: TG2Box read GetOBBox;
    property AABox: TG2AABox read GetAABox;
    property AutoComputeTransforms: Boolean read _AutoComputeTransforms write _AutoComputeTransforms;
    property Color: TG2Color read _Color write _Color;
    property GeomBBox[const Index: TG2IntS32]: TG2Box read GetGeomBBox;
    property Skins[const Index: TG2IntS32]: PG2LegacyMeshInstSkin read GetSkin;
    property SkinTransforms[const Index: TG2IntS32]: PG2Mat read GetSkinTransforms;
    constructor Create(const AMesh: TG2LegacyMesh);
    destructor Destroy; override;
    procedure FrameSetFast(const AnimName: AnsiString; const Frame: TG2IntS32);
    procedure FrameSet(const AnimName: AnsiString; const Frame: TG2Float);
    procedure ComputeTransforms;
    procedure Render(const W, V, P: TG2Mat);
  end;

//TG2GameState BEGIN
  TG2GameState = class
  private
    class var List: TG2GameState;
    class constructor CreateClass;
    class destructor DestroyClass;
    var Next: TG2GameState;
    var Prev: TG2GameState;
    var _State: TG2GameState;
    var _Enabled: Boolean;
    var _SwitchState: TG2GameState;
    var _RenderOrder: TG2Float;
    procedure SetEnabled(const Value: Boolean);
    procedure SetState(const Value: TG2GameState);
    procedure SetRenderOrder(const Value: TG2Float); inline;
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
  protected
    procedure OnInitialize; virtual;
    procedure OnFinalize; virtual;
    procedure OnRender; virtual;
    procedure OnUpdate; virtual;
    procedure OnKeyDown(const {%H-}Key: Integer); virtual;
    procedure OnKeyUp(const {%H-}Key: Integer); virtual;
    procedure OnMouseDown(const {%H-}Button, {%H-}x, {%H-}y: Integer); virtual;
    procedure OnMouseUp(const {%H-}Button, {%H-}x, {%H-}y: Integer); virtual;
    procedure OnScroll(const {%H-}y: Integer); virtual;
    procedure OnPrint(const {%H-}c: AnsiChar); virtual;
    procedure OnEnter(const {%H-}PrevState: TG2GameState); virtual;
    procedure OnLeave(const {%H-}NextState: TG2GameState); virtual;
  public
    property Enabled: Boolean read _Enabled write SetEnabled;
    property State: TG2GameState read _State write _SwitchState;
    property RenderOrder: TG2Float read _RenderOrder write SetRenderOrder;
    constructor Create; virtual;
    destructor Destroy; override;
  end;
//TG2GameState END

//IG2Serializable BEGIN
  {$push}
  {$interfaces corba}
  const IG2SerializableGUID = '{b78dfd2d-7d67-4f40-a4cb-841f32451707}';
  type IG2Serializable = interface
    procedure Serialize(const Stream: TStream);
    procedure Deserialize(const Stream: TStream);
  end;
  {$pop}
//IG2Serializable END

  TG2QuickListVec2 = specialize TG2QuickListG<TG2Vec2>;
  PG2QuickListVec2 = ^TG2QuickListVec2;
  TG2QuickListVec3 = specialize TG2QuickListG<TG2Vec3>;
  PG2QuickListVec3 = ^TG2QuickListVec3;
  TG2QuickListVec4 = specialize TG2QuickListG<TG2Vec4>;
  PG2QuickListVec4 = ^TG2QuickListVec4;

var g2: TG2Core;

function G2Time: TG2IntU32;
function G2PiTime(Amp: TG2Float = 1000): TG2Float; overload;
function G2PiTime(Amp: TG2Float; Time: TG2IntU32): TG2Float; overload;
function G2TimeInterval(Interval: TG2IntU32 = 1000): TG2Float; overload;
function G2TimeInterval(Interval: TG2IntU32; Time: TG2IntU32): TG2Float; overload;
function G2RandomPi: TG2Float;
function G2Random2Pi: TG2Float;
function G2RandomCirclePoint: TG2Vec2;
function G2RandomSpherePoint: TG2Vec3;
function G2RectInRect(const R0, R1: TRect): Boolean; overload;
function G2RectInRect(const R0, R1: TG2Rect): Boolean; overload;
function G2KeyName(const Key: TG2IntS32): AnsiString;
procedure G2TraceBegin;
function G2TraceEnd: TG2IntU32;
{$if defined(G2Cpu386)}
procedure G2BreakPoint; assembler;
{$endif}
procedure SafeRelease(var i);
procedure G2RegisterSerializable(const SerializableClass: TClass);
procedure G2SerializeToStream(const Obj: TObject; const Stream: TStream);
function G2SerializeFromStream(const Stream: TStream): TObject;

implementation

var G2Serializable: array of TClass;

{$ifdef G2Target_Windows}
var G2WndClassName: AnsiString;
{$endif}

var SysMMX: Boolean = False;
var SysSSE: Boolean = False;
var SysSSE2: Boolean = False;
var SysSSE3: Boolean = False;
var TraceTime: TG2IntU32;

{$if defined(G2Cpu386) and (defined(G2Target_Windows) or defined(G2Target_Linux))}
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

{$if defined(G2Target_Windows)}
function G2MessageHandler(Wnd: HWnd; Msg: UInt; wParam: WPARAM; lParam: LPARAM): LResult; stdcall;
  var WindowMode: TG2IntS32;
begin
  if Assigned(g2.Window) then
  case Msg of
    WM_DESTROY, WM_QUIT, WM_CLOSE:
    begin
      PostQuitMessage(0);
      Result := 0;
      Exit;
    end;
    WM_CHAR:
    begin
      g2.Window.AddMessage(@g2.Window.OnPrint, wParam, 0, 0);
    end;
    WM_KEYDOWN:
    begin
      g2.Window.AddMessage(@g2.Window.OnKeyDown, wParam, 0, 0);
    end;
    WM_KEYUP:
    begin
      g2.Window.AddMessage(@g2.Window.OnKeyUp, wParam, 0, 0);
    end;
    WM_LBUTTONDOWN:
    begin
      g2.Window.AddMessage(@g2.Window.OnMouseDown, G2MB_Left, lParam and $ffff, (lParam shr 16) and $ffff);
    end;
    WM_LBUTTONDBLCLK:
    begin
      g2.Window.AddMessage(@g2.Window.OnMouseDown, G2MB_Left, lParam and $ffff, (lParam shr 16) and $ffff);
    end;
    WM_LBUTTONUP:
    begin
      g2.Window.AddMessage(@g2.Window.OnMouseUp, G2MB_Left, lParam and $ffff, (lParam shr 16) and $ffff);
    end;
    WM_RBUTTONDOWN:
    begin
      g2.Window.AddMessage(@g2.Window.OnMouseDown, G2MB_Right, lParam and $ffff, (lParam shr 16) and $ffff);
    end;
    WM_RBUTTONDBLCLK:
    begin
      g2.Window.AddMessage(@g2.Window.OnMouseDown, G2MB_Right, lParam and $ffff, (lParam shr 16) and $ffff);
    end;
    WM_RBUTTONUP:
    begin
      g2.Window.AddMessage(@g2.Window.OnMouseUp, G2MB_Right, lParam and $ffff, (lParam shr 16) and $ffff);
    end;
    WM_MBUTTONDOWN:
    begin
      g2.Window.AddMessage(@g2.Window.OnMouseDown, G2MB_Middle, lParam and $ffff, (lParam shr 16) and $ffff);
    end;
    WM_MBUTTONDBLCLK:
    begin
      g2.Window.AddMessage(@g2.Window.OnMouseDown, G2MB_Middle, lParam and $ffff, (lParam shr 16) and $ffff);
    end;
    WM_MBUTTONUP:
    begin
      g2.Window.AddMessage(@g2.Window.OnMouseUp, G2MB_Middle, lParam and $ffff, (lParam shr 16) and $ffff);
    end;
    WM_MOUSEWHEEL:
    begin
      g2.Window.AddMessage(@g2.Window.OnScroll, SmallInt((LongWord(wParam) shr 16) and $ffff), 0, 0);
    end;
    WM_SETCURSOR:
    begin
      Windows.SetCursor(g2.Window.Cursor);
      if g2.Window.Cursor <> g2.Window.CursorArrow then Exit;
    end;
    WM_SIZE:
    begin
      if wParam <> SIZE_MINIMIZED then
      begin
        if wParam = SIZE_MAXIMIZED then WindowMode := 1 else WindowMode := 0;
        g2.Window.AddMessage(@g2.Window.OnResize, WindowMode, lParam and $ffff, (lParam shr 16) and $ffff);
      end;
    end;
  end;
  Result := DefWindowProc(Wnd, Msg, wParam, lParam);
end;
{$elseif defined(G2Target_Linux)}
procedure G2MessageHandler(Event: TXEvent);
begin
  case Event._type of
    ConfigureNotify:
    begin
      if (Event.xconfigure.width <> g2.Params.Width)
      or (Event.xconfigure.height <> g2.Params.Height) then
      begin
        g2.Params.Width := Event.xconfigure.width;
        g2.Params.Height := Event.xconfigure.height;
      end;
    end;
    KeyPress:
    begin
      g2.Window.AddMessage(@g2.Window.OnKeyDown, Event.xkey.keycode, 0, 0);
    end;
    KeyRelease:
    begin
      g2.Window.AddMessage(@g2.Window.OnKeyUp, Event.xkey.keycode, 0, 0);
    end;
    ButtonPress:
    begin
      case Event.xbutton.button of
        1: g2.Window.AddMessage(@g2.Window.OnMouseDown, G2MB_Left, Event.xbutton.x, Event.xbutton.y);
        2: g2.Window.AddMessage(@g2.Window.OnMouseDown, G2MB_Middle, Event.xbutton.x, Event.xbutton.y);
        3: g2.Window.AddMessage(@g2.Window.OnMouseDown, G2MB_Right, Event.xbutton.x, Event.xbutton.y);
      end;
    end;
    ButtonRelease:
    begin
      case Event.xbutton.button of
        1: g2.Window.AddMessage(@g2.Window.OnMouseUp, G2MB_Left, Event.xbutton.x, Event.xbutton.y);
        2: g2.Window.AddMessage(@g2.Window.OnMouseUp, G2MB_Middle, Event.xbutton.x, Event.xbutton.y);
        3: g2.Window.AddMessage(@g2.Window.OnMouseUp, G2MB_Right, Event.xbutton.x, Event.xbutton.y);
      end;
    end;
  end;
end;
{$elseif defined(G2Target_OSX)}
function G2MessageHandler(inHandlerCallRef: EventHandlerCallRef; inEvent: EventRef; inUserData: UnivPtr ): OSStatus; cdecl;
  var EventClass: MacOSAll.OSType;
  var EventKind: MacOSAll.UInt32;
  var Command: MacOSAll.HICommand;
  var Key: TG2IntU32;
  var Button: EventMouseButton;
  var CursorPos: TPoint;
begin
  EventClass := GetEventClass(inEvent);
  EventKind := GetEventKind(inEvent);
  case EventClass of
    kEventClassCommand:
    begin
      case EventKind of
        kEventProcessCommand:
        begin
          GetEventParameter(
            inEvent,
            kEventParamDirectObject,
            kEventParamHICommand,
            nil, SizeOf(Command),
            nil, @Command
          );
          if Command.commandID = kHICommandQuit then g2.Window.Stop;
        end;
      end;
    end;
    kEventClassWindow:
    begin
      case EventKind of
        kEventWindowClosed:
        begin
          g2.Window.Stop;
        end;
      end;
    end;
    kEventClassKeyboard:
    begin
      GetEventParameter(inEvent, kEventParamKeyCode, typeUInt32, nil, SizeOf(Key), nil, @Key);
      case EventKind of
        kEventRawKeyDown, kEventRawKeyRepeat: g2.Window.AddMessage(@g2.Window.OnKeyDown, Key, 0, 0);
        kEventRawKeyUp: g2.Window.AddMessage(@g2.Window.OnKeyUp, Key, 0, 0);
      end;
    end;
    kEventClassMouse:
    begin
      GetEventParameter(inEvent, kEventParamMouseButton, typeMouseButton, nil, SizeOf(Button), nil, @Button);
      case EventKind of
        kEventMouseDown:
        begin
          CursorPos := g2.MousePos;
          case Button of
            1: g2.Window.AddMessage(@g2.Window.OnMouseDown, G2MB_Left, CursorPos.x, CursorPos.y);
            2: g2.Window.AddMessage(@g2.Window.OnMouseDown, G2MB_Right, CursorPos.x, CursorPos.y);
            3: g2.Window.AddMessage(@g2.Window.OnMouseDown, G2MB_Middle, CursorPos.x, CursorPos.y);
          end;
        end;
        kEventMouseUp:
        begin
          CursorPos := g2.MousePos;
          case Button of
            1: g2.Window.AddMessage(@g2.Window.OnMouseUp, G2MB_Left, CursorPos.x, CursorPos.y);
            2: g2.Window.AddMessage(@g2.Window.OnMouseUp, G2MB_Right, CursorPos.x, CursorPos.y);
            3: g2.Window.AddMessage(@g2.Window.OnMouseUp, G2MB_Middle, CursorPos.x, CursorPos.y);
          end;
        end;
      end;
    end;
  end;
end;
{$endif}

{$ifdef G2Target_Windows}
var WndClass: TWndClassExA;
{$endif}
procedure G2Initialize;
begin
  {$ifdef G2Target_Windows}
  G2WndClassName := 'Gen2MP';
  FillChar(WndClass, SizeOf(TWndClassExA), 0);
  WndClass.cbSize := SizeOf(TWndClassExA);
  WndClass.hIconSm := LoadIcon(MainInstance, 'MAINICON');
  WndClass.hIcon := LoadIcon(MainInstance, 'MAINICON');
  WndClass.hInstance := HInstance;
  WndClass.hCursor := LoadCursor(0, IDC_ARROW);
  WndClass.lpszClassName := PAnsiChar(G2WndClassName);
  WndClass.style := CS_HREDRAW or CS_VREDRAW or CS_OWNDC or CS_DBLCLKS;
  WndClass.lpfnWndProc := @G2MessageHandler;
  if RegisterClassExA(WndClass) = 0 then
  G2WndClassName := 'Static';
  {$endif}
  g2 := TG2Core.Create;
  {$if defined(G2Cpu386) and (defined(G2Target_Windows) or defined(G2Target_Linux))}
  CPUExtensions;
  {$endif}
  g2.Sys._MMX := SysMMX;
  g2.Sys._SSE := SysSSE;
  g2.Sys._SSE2 := SysSSE2;
  g2.Sys._SSE3 := SysSSE3;
  {$if defined(G2Target_Android) or defined(G2Target_iOS)}
  G2DataManagerChachedRead := True;
  {$endif}
end;

procedure G2Finalize;
begin
  {$ifdef G2Target_Windows}
  if G2WndClassName = 'Gen2MP' then
  UnregisterClassA(PAnsiChar(G2WndClassName), WndClass.hInstance);
  DestroyIcon(WndClass.hIconSm);
  DestroyIcon(WndClass.hIcon);
  DestroyCursor(WndClass.hCursor);
  {$endif}
  g2.Free;
  g2 := nil;
end;

function KeyRemap(const Key: TG2IntS32): TG2IntS32;
{$if defined(G2Target_Windows)}
  const Remap: array[0..222] of TG2IntS32 = (
    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, G2K_Back, G2K_Tab,
    $ff, $ff, $ff, G2K_Return, $ff, $ff, G2K_ShiftL, G2K_CtrlL, G2K_AltL, G2K_Pause,
    G2K_CapsLock, $ff, $ff, $ff, $ff, $ff, $ff, G2K_Escape, $ff, $ff,
    $ff, $ff, G2K_Space, G2K_PgUp, G2K_PgDown, G2K_End, G2K_Home, G2K_Left, G2K_Up, G2K_Right,
    G2K_Down, $ff, $ff, $ff, $ff, G2K_Insert, G2K_Delete, $ff, G2K_0, G2K_1,
    G2K_2, G2K_3, G2K_4, G2K_5, G2K_6, G2K_7, G2K_8, G2K_9, $ff, $ff,
    $ff, $ff, $ff, $ff, $ff, G2K_A, G2K_B, G2K_C, G2K_D, G2K_E,
    G2K_F, G2K_G, G2K_H, G2K_I, G2K_J, G2K_K, G2K_L, G2K_M, G2K_N, G2K_O,
    G2K_P, G2K_Q, G2K_R, G2K_S, G2K_T, G2K_U, G2K_V, G2K_W, G2K_X, G2K_Y,
    G2K_Z, G2K_WinL, G2K_WinR, G2K_Menu, $ff, $ff, G2K_Num0, G2K_Num1, G2K_Num2, G2K_Num3,
    G2K_Num4, G2K_Num5, G2K_Num6, G2K_Num7, G2K_Num8, G2K_Num9, G2K_NumMul, G2K_NumPlus, $ff, G2K_NumMinus,
    G2K_NumPeriod, G2K_NumDiv, G2K_F1, G2K_F2, G2K_F3, G2K_F4, G2K_F5, G2K_F6, G2K_F7, G2K_F8,
    G2K_F9, G2K_F10, G2K_F11, G2K_F12, $ff, $ff, $ff, $ff, $ff, $ff,
    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
    $ff, $ff, $ff, $ff, G2K_NumLock, G2K_ScrlLock, $ff, $ff, $ff, $ff,
    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
    G2K_ShiftL, G2K_ShiftR, G2K_CtrlL, G2K_CtrlR, G2K_AltL, G2K_AltR, $ff, $ff, $ff, $ff,
    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
    $ff, $ff, $ff, $ff, $ff, $ff, G2K_SemiCol, G2K_Plus, G2K_Comma, G2K_Minus,
    G2K_Period, G2K_Slash, G2K_Tilda, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, G2K_BrktL,
    G2K_SlashR, G2K_BrktR, G2K_Quote
  );
{$elseif defined(G2Target_Linux)}
  const Remap: array[0..135] of TG2IntS32 = (
    $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, G2K_Escape,
    G2K_1, G2K_2, G2K_3, G2K_4, G2K_5, G2K_6, G2K_7, G2K_8, G2K_9, G2K_0,
    G2K_Minus, G2K_Plus, G2K_Back, G2K_Tab, G2K_Q, G2K_W, G2K_E, G2K_R, G2K_T, G2K_Y,
    G2K_U, G2K_I, G2K_O, G2K_P, G2K_BrktL, G2K_BrktR, G2K_Return, G2K_CtrlL, G2K_A, G2K_S,
    G2K_D, G2K_F, G2K_G, G2K_H, G2K_J, G2K_K, G2K_L, G2K_SemiCol, G2K_Quote, G2K_Tilda,
    G2K_ShiftL, G2K_SlashR, G2K_Z, G2K_X, G2K_C, G2K_V, G2K_B, G2K_N, G2K_M, G2K_Comma,
    G2K_Period, G2K_Slash, G2K_ShiftR, G2K_NumMul, G2K_AltL, G2K_Space, G2K_CapsLock, G2K_F1, G2K_F2, G2K_F3,
    G2K_F4, G2K_F5, G2K_F6, G2K_F7, G2K_F8, G2K_F9, G2K_F10, G2K_NumLock, G2K_ScrlLock, G2K_Num7,
    G2K_Num8, G2K_Num9, G2K_NumMinus, G2K_Num4, G2K_Num5, G2K_Num6, G2K_NumPlus, G2K_Num1, G2K_Num2, G2K_Num3,
    G2K_Num0, G2K_NumPeriod, $ff, $ff, $ff, G2K_F11, G2K_F12, $ff, $ff, $ff,
    $ff, $ff, $ff, $ff, G2K_NumReturn, $ff, G2K_NumDiv, $ff, G2K_AltR, $ff,
    G2K_Home, G2K_Up, G2K_PgUp, G2K_Left, G2K_Right, G2K_End, G2K_Down, G2K_PgDown, G2K_Insert, G2K_Delete,
    $ff, $ff, $ff, $ff, $ff, $ff, $ff, G2K_Pause, $ff, $ff,
    $ff, $ff, $ff, G2K_WinL, G2K_WinR, G2K_Menu
  );
{$elseif defined(G2Target_OSX)}
  const Remap: array[0..126] of TG2IntS32 = (
    G2K_A, G2K_S, G2K_D, G2K_F, G2K_H, G2K_G, G2K_Z, G2K_X, G2K_C, G2K_V,
    $ff, G2K_B, G2K_Q, G2K_W, G2K_E, G2K_R, G2K_Y, G2K_T, G2K_1, G2K_2,
    G2K_3, G2K_4, G2K_6, G2K_5, G2K_Plus, G2K_9, G2K_7, G2K_Minus, G2K_8, G2K_0,
    G2K_BrktR, G2K_O, G2K_U, G2K_BrktL, G2K_I, G2K_P, G2K_Return, G2K_L, G2K_J, G2K_Quote,
    G2K_K, G2K_SemiCol, G2K_SlashR, G2K_Comma, G2K_Slash, G2K_N, G2K_M, G2K_Period, G2K_Tab, G2K_Space,
    G2K_Tilda, G2K_Back, $ff, G2K_Escape, $ff, G2K_WinL, G2K_Shift, G2K_CapsLock, G2K_Alt, G2K_Ctrl,
    $ff, $ff, $ff, $ff, $ff, G2K_NumPeriod, $ff, G2K_NumMul, $ff, G2K_NumPlus,
    $ff, G2K_NumLock, $ff, $ff, $ff, G2K_NumDiv, G2K_NumReturn, $ff, G2K_NumMinus, $ff,
    $ff, $ff, G2K_Num0, G2K_Num1, G2K_Num2, G2K_Num3, G2K_Num4, G2K_Num5, G2K_Num6, G2K_Num7,
    $ff, G2K_Num8, G2K_Num9, $ff, $ff, $ff, G2K_F5, G2K_F6, G2K_F7, G2K_F3,
    G2K_F8, G2K_F9, $ff, G2K_F11, $ff, $ff, $ff, G2K_ScrlLock, G2K_Pause, G2K_F10,
    G2K_Menu, G2K_F12, $ff, $ff, G2K_Insert, G2K_Home, G2K_PgUp, G2K_Delete, G2K_F4, G2K_End,
    G2K_F2, G2K_PgDown, G2K_F1, G2K_Left, G2K_Right, G2K_Down, G2K_Up
  );
{$elseif defined(G2Target_Android)}
  const Remap: array[0..255] of TG2IntS32 = (
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
    40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
    50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
    60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
    70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
    80, 81, 82, 83, 84, 85, 86, 87, 88, 89,
    90, 91, 92, 93, 94, 95, 96, 97, 98, 99,
    100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
    110, 111, 112, 113, 114, 115, 116, 117, 118, 119,
    120, 121, 122, 123, 124, 125, 126, 127, 128, 129,
    130, 131, 132, 133, 134, 135, 136, 137, 138, 139,
    140, 141, 142, 143, 144, 145, 146, 147, 148, 149,
    150, 151, 152, 153, 154, 155, 156, 157, 158, 159,
    160, 161, 162, 163, 164, 165, 166, 167, 168, 169,
    170, 171, 172, 173, 174, 175, 176, 177, 178, 179,
    180, 181, 182, 183, 184, 185, 186, 187, 188, 189,
    190, 191, 192, 193, 194, 195, 196, 197, 198, 199,
    200, 201, 202, 203, 204, 205, 206, 207, 208, 209,
    210, 211, 212, 213, 214, 215, 216, 217, 218, 219,
    220, 221, 222, 223, 224, 225, 226, 227, 228, 229,
    230, 231, 232, 233, 234, 235, 236, 237, 238, 239,
    240, 241, 242, 243, 244, 245, 246, 247, 248, 249,
    250, 251, 252, 253, 254, 255
  );
{$elseif defined(G2Target_iOS)}
      const Remap: array[0..255] of TG2IntS32 = (
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
        10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
        30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
        40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
        50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
        60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
        70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
        80, 81, 82, 83, 84, 85, 86, 87, 88, 89,
        90, 91, 92, 93, 94, 95, 96, 97, 98, 99,
        100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
        110, 111, 112, 113, 114, 115, 116, 117, 118, 119,
        120, 121, 122, 123, 124, 125, 126, 127, 128, 129,
        130, 131, 132, 133, 134, 135, 136, 137, 138, 139,
        140, 141, 142, 143, 144, 145, 146, 147, 148, 149,
        150, 151, 152, 153, 154, 155, 156, 157, 158, 159,
        160, 161, 162, 163, 164, 165, 166, 167, 168, 169,
        170, 171, 172, 173, 174, 175, 176, 177, 178, 179,
        180, 181, 182, 183, 184, 185, 186, 187, 188, 189,
        190, 191, 192, 193, 194, 195, 196, 197, 198, 199,
        200, 201, 202, 203, 204, 205, 206, 207, 208, 209,
        210, 211, 212, 213, 214, 215, 216, 217, 218, 219,
        220, 221, 222, 223, 224, 225, 226, 227, 228, 229,
        230, 231, 232, 233, 234, 235, 236, 237, 238, 239,
        240, 241, 242, 243, 244, 245, 246, 247, 248, 249,
        250, 251, 252, 253, 254, 255
      );
{$endif}
begin
  if Key <= High(Remap) then Result := Remap[Key] else Result := $ff;
end;

{$if defined(G2Target_iOS)}
class function TG2OpenGLView.layerClass : Pobjc_class;
begin
  Result := CAEAGLLayer.classClass;
end;

function TG2OpenGLView.initWithFrame(frame: CGRect): id;
begin
  Self := inherited initWithFrame(frame);
  if Assigned(Self) then
  begin
    //g2.Start;
    setupLayer;
    setupContext;
    setupRenderBuffer;
    setupFrameBuffer;
    //render;
    g2.Start;
  end;
  Result := Self;
end;

procedure TG2OpenGLView.dealloc;
begin
  TG2GfxGLES(g2.Gfx)._Context.release;
  TG2GfxGLES(g2.Gfx)._Context := nil;
  inherited dealloc;
end;

procedure TG2OpenGLView.setupLayer;
begin
  TG2GfxGLES(g2.Gfx)._EAGLLayer := CAEAGLLayer(self.layer);
  TG2GfxGLES(g2.Gfx)._EAGLLayer.setOpaque(True);
  TG2GfxGLES(g2.Gfx)._EAGLLayer.setDrawableProperties(
    NSDictionary.dictionaryWithObjectsAndKeys(
      NSNumber.numberWithBool(False),
      NSStr('kEAGLDrawablePropertyRetainedBacking'),
      NSStr('kEAGLColorFormatRGBA8'),
      NSStr('kEAGLDrawablePropertyColorFormat'),
      nil
    )
  );
end;

procedure TG2OpenGLView.setupContext;
  var OpenGLVersion: EAGLRenderingAPI;
begin
  OpenGLVersion := kEAGLRenderingAPIOpenGLES1;
  TG2GfxGLES(g2.Gfx)._Context := EAGLContext.alloc.initWithAPI(OpenGLVersion);
  EAGLContext.setCurrentContext(TG2GfxGLES(g2.Gfx)._Context);
end;

procedure TG2OpenGLView.setupRenderBuffer;
begin
  glGenRenderbuffers(1, @TG2GfxGLES(g2.Gfx)._RenderBuffer);
  glBindRenderbuffer(GL_RENDERBUFFER, TG2GfxGLES(g2.Gfx)._RenderBuffer);
  TG2GfxGLES(g2.Gfx)._Context.renderbufferStorage_fromDrawable(GL_RENDERBUFFER, TG2GfxGLES(g2.Gfx)._EAGLLayer);
end;

procedure TG2OpenGLView.setupFrameBuffer;
  var FrameBuffer: GLUInt;
begin
  glGenFramebuffers(1, @FrameBuffer);
  glBindFramebuffer(GL_FRAMEBUFFER, FrameBuffer);
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, TG2GfxGLES(g2.Gfx)._RenderBuffer);
end;

procedure TG2OpenGLView.render;
begin
  glClearColor(1, 1, 1, 1);
  glClear(GL_COLOR_BUFFER_BIT);
  TG2GfxGLES(g2.Gfx)._Context.presentRenderbuffer(GL_RENDERBUFFER);
end;

procedure TG2AppDelegate.Loop;
begin
  g2.Window.Loop;
end;

function TG2AppDelegate.applicationDidFinishLaunchingWithOptions(application: UIApplication; launchOptions: NSDictionary): Boolean;
  var ctrl: TG2ViewController;
begin
  g2.Delegate := Self;
  _Window := UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds);
  _Window.setBackgroundColor(UIColor.blackColor);
  ctrl := TG2ViewController.alloc().init();
  _Window.setRootViewController(ctrl);
  _Window.makeKeyAndVisible;
  Result := True;
end;

procedure TG2AppDelegate.applicationWillResignActive(application: UIApplication);
begin
end;

procedure TG2AppDelegate.applicationDidEnterBackground(application: UIApplication);
begin
end;

procedure TG2AppDelegate.applicationWillEnterForeground(application: UIApplication);
begin
end;

procedure TG2AppDelegate.applicationDidBecomeActive(application: UIApplication);
begin
end;

procedure TG2AppDelegate.applicationWillTerminate(application: UIApplication);
begin
end;

procedure TG2AppDelegate.dealloc;
begin
  g2.Stop;
  _Window.release;
  inherited dealloc;
end;

function TG2ViewController.initWithNibName_bundle(nibNameOrNil: NSString; nibBundleOrNil: NSBundle): id;
begin
  Self := inherited initWithNibName_bundle(nibNameOrNil, nibBundleOrNil);
  if Assigned(Self) then
  begin
  end;
  Result := Self;
end;

procedure TG2ViewController.dealloc;
begin
  inherited dealloc;
end;

procedure TG2ViewController.didReceiveMemoryWarning;
begin
  inherited didReceiveMemoryWarning;
end;

procedure TG2ViewController.loadView;
begin
  g2.Window.View := TG2OpenGLView.alloc().initWithFrame(UIScreen.mainScreen.bounds);
  setView(g2.Window.View);
end;

//procedure TG2ViewController.viewDidLoad;
//begin
//  inherited viewDidLoad;
//end;

procedure TG2ViewController.viewDidUnload;
begin
  inherited viewDidUnload;
end;

function TG2ViewController.shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation): Boolean;
begin
  Result := toInterfaceOrientation = UIInterfaceOrientationPortrait;
end;
{$endif}

//TG2Log BEGIN
constructor TG2Log.Create;
begin
  inherited Create;
  {$if defined(G2Log) and not defined(G2Target_Mobile)}
  System.Assign(_LogFile, G2GetAppPath + 'G2Log.txt');
  System.Rewrite(_LogFile);
  {$endif}
end;

destructor TG2Log.Destroy;
begin
  {$if defined(G2Log) and not defined(G2Target_Mobile)}
  System.Close(_LogFile);
  {$endif}
  inherited Destroy;
end;

procedure TG2Log.Write(const LogMessage: String);
begin
  {$if defined(G2Log)}
  {$if defined(G2Target_Windows) or defined(G2Target_Linux) or defined(G2Target_OSX)}
  System.Write(_LogFile, LogMessage);
  {$elseif defined(G2Target_Android)}
  LOGW(PChar(AnsiString(LogMessage)));
  {$endif}
  {$endif}
end;

procedure TG2Log.WriteLn(const LogMessage: String);
begin
  {$if defined(G2Log)}
  {$if defined(G2Target_Windows) or defined(G2Target_Linux) or defined(G2Target_OSX)}
  System.WriteLn(_LogFile, LogMessage);
  {$elseif defined(G2Target_Android)}
  LOGW(PChar(AnsiString(LogMessage)));
  {$endif}
  {$endif}
end;
//TG2Log END

//TG2CustomTimer BEGIN
constructor TG2CustomTimer.Create(const NewFunc: TG2CustomTimerFunc; const NewInterval: TG2IntS32);
begin
  inherited Create;
  _Obj := False;
  _Interval := NewInterval;
  _TimeLeft := _Interval * 0.001;
  _Func := NewFunc;
end;

constructor TG2CustomTimer.Create(const NewFunc: TG2CustomTimerFuncObj; const NewInterval: TG2IntS32);
begin
  inherited Create;
  _Obj := True;
  _Interval := NewInterval;
  _TimeLeft := _Interval * 0.001;
  _FuncObj := NewFunc;
end;

function TG2CustomTimer.Update: Boolean;
  var n: TG2IntS32;
begin
  _TimeLeft -= g2.DeltaTimeSec;
  if _TimeLeft <= 0 then
  begin
    if _Obj then
    n := _FuncObj(_Interval)
    else
    n := _Func(_Interval);
    if n <= 0 then
    begin
      Exit(True);
    end
    else
    begin
      _Interval := n;
      _TimeLeft := _Interval * 0.001;
      Exit(False);
    end;
  end;
  Result := False;
end;
//TG2CustomTimer END

//TG2Core BEGIN
procedure TG2Core.Render;
begin
  if _CanRender then
  begin
    Gfx.RenderStart;
    Gfx.Render;
    Gfx.RenderStop;
    _CanRender := False;
  end;
end;

procedure TG2Core.Update;
  var i: TG2IntS32;
begin
  for i := _LinkUpdate.Count - 1 downto 0 do
  if not _LinkUpdate[i]^.Enabled then
  begin
    Dispose(_LinkUpdate[i]);
    _LinkUpdate.Delete(i);
  end;
  for i := 0 to _LinkUpdate.Count - 1 do
  if _LinkUpdate[i]^.Enabled then
  begin
    if _LinkUpdate[i]^.Obj then
    _LinkUpdate[i]^.ProcObj
    else
    _LinkUpdate[i]^.Proc;
  end;
  for i := _LinkUpdate.Count - 1 downto 0 do
  if not _LinkUpdate[i]^.Enabled then
  begin
    Dispose(_LinkUpdate[i]);
    _LinkUpdate.Delete(i);
  end;
  for i := _CustomTimers.Count - 1 downto 0 do
  if _CustomTimers[i].Update then
  begin
    _CustomTimers[i].Free;
    _CustomTimers.Delete(i);
  end;
end;

procedure TG2Core.UpdateRender;
  var i: TG2IntS32;
begin
  if not _CanRender then
  begin
    Gfx.Reset;
    Gfx.StateChange.StateRenderTarget := nil;
    for i := 0 to _LinkRender.Count - 1 do
    if _LinkRender[i]^.Obj then
    _LinkRender[i]^.ProcObj
    else
    _LinkRender[i]^.Proc;
    Gfx.StateChange.StateRenderTarget := nil;
    Gfx.Swap;
    _CanRender := True;
  end;
end;

procedure TG2Core.OnRender;
  var CurTime: TG2IntU32;
begin
  CurTime := G2Time;
  if (_MaxFPS = 0)
  or (CurTime - _RenderPrevTime >= 1000 / _MaxFPS) then
  begin
    Render;
    _RenderPrevTime := CurTime;
    Inc(_FrameCount);
  end;
  if (CurTime - _FPSUpdateTime >= 1000) then
  begin
    _FPS := _FrameCount;
    _FPSUpdateTime := CurTime;
    _FrameCount := 0;
  end;
end;

procedure TG2Core.OnUpdate;
  var CurTime: TG2IntU32;
  var i, NumUpdates: TG2IntS32;
begin
  if not _Pause then
  begin
    //{$if not defined(G2Target_Mobile)}
    _Window.ProcessMessages;
    //{$endif}
    CurTime := G2Time;
    _UpdateCount := _UpdateCount + TG2Float(CurTime - _UpdatePrevTime) * _TargetUPS * 0.001;
    NumUpdates := Trunc(_UpdateCount);
    if _Params.PreventUpdateOverload
    and (NumUpdates > 1) then
    NumUpdates := 1;
    _UpdateCount := _UpdateCount - NumUpdates;
    for i := 0 to NumUpdates - 1 do
    begin
      Update;
      {$if not defined(G2Target_Android)}if not _Window.IsLooping then Break;{$endif}
    end;
    {$if not defined(G2Target_Android)}if _Window.IsLooping then{$endif}
    g2.UpdateRender;
    _UpdatePrevTime := CurTime;
  end;
end;

procedure TG2Core.OnLoop;
  var i: TG2IntS32;
begin
  try
    _Window := TG2Window.Create(_Params.Width, _Params.Height);
    _Gfx.Initialize;
    _Snd.Initialize;
    for i := 0 to _LinkInitialize.Count - 1 do
    if _LinkInitialize[i]^.Obj then
    _LinkInitialize[i]^.ProcObj()
    else
    _LinkInitialize[i]^.Proc();
    {$ifdef G2Threading}
    _Updater := TG2Updater.Create(True);
    _Updater.FreeOnTerminate := False;
    _Updater.Resume;
    _Renderer := TG2Renderer.Create(True);
    _Renderer.FreeOnTerminate := False;
    _Renderer.Resume;
    {$endif}
    _Params.SetBuffered(True);
    _CanRender := False;
    _Started := True;
    {$if defined(G2Target_Windows) or defined(G2Target_Linux) or defined(G2Target_OSX)}
    _Window.Loop;
    {$elseif defined(G2Target_iOS)}
    NSTimer.scheduledTimerWithTimeInterval_target_selector_userInfo_repeats(1 / 60, _Delegate, objcselector('Loop'), nil, True);
    {$endif}
  except
     on e: Exception do
     begin
       {$if defined(G2Output)}
       WriteLn('g2mp exception: ' + e.Message);
       {$elseif not defined(G2Target_Mobile)}
       Window.DisplayMessage(e.Message);
       {$endif}
     end;
  end;
end;

procedure TG2Core.OnStop;
  var i: TG2IntS32;
begin
  try
    {$ifdef G2Threading}
    _Renderer.Terminate;
    _Renderer.WaitFor;
    _Renderer.Free;
    _Renderer := nil;
    _Updater.Terminate;
    _Updater.WaitFor;
    _Updater.Free;
    _Updater := nil;
    {$endif}
    for i := _LinkFinalize.Count - 1 downto 0 do
    if _LinkFinalize[i]^.Obj then
    _LinkFinalize[i]^.ProcObj
    else
    _LinkFinalize[i]^.Proc;
    _Snd.Finalize;
    _Gfx.Finalize;
    _Window.Free;
    _Window := nil;
    _Started := False;
  except
     on e: Exception do
     begin
       {$if defined(G2Output)}
       WriteLn('g2mp exception: ' + e.Message);
       {$endif}
     end;
  end;
end;

procedure TG2Core.OnPrint(const Char: AnsiChar);
  var i: TG2IntS32;
begin
  for i := 0 to _LinkPrint.Count - 1 do
  if _LinkPrint[i]^.Obj then
  _LinkPrint[i]^.ProcObj(Char)
  else
  _LinkPrint[i]^.Proc(Char);
end;

procedure TG2Core.OnKeyDown(const Key: TG2IntS32);
  var i: TG2IntS32;
begin
  for i := 0 to _LinkKeyDown.Count - 1 do
  if _LinkKeyDown[i]^.Obj then
  _LinkKeyDown[i]^.ProcObj(Key)
  else
  _LinkKeyDown[i]^.Proc(Key);
  _KeyDown[Key] := True;
end;

procedure TG2Core.OnKeyUp(const Key: TG2IntS32);
  var i: TG2IntS32;
begin
  for i := 0 to _LinkKeyUp.Count - 1 do
  if _LinkKeyUp[i]^.Obj then
  _LinkKeyUp[i]^.ProcObj(Key)
  else
  _LinkKeyUp[i]^.Proc(Key);
  _KeyDown[Key] := False;
end;

procedure TG2Core.OnMouseDown(const Button: TG2IntS32; const x, y: TG2IntS32);
  var i: TG2IntS32;
begin
  for i := 0 to _LinkMouseDown.Count - 1 do
  if _LinkMouseDown[i]^.Obj then
  _LinkMouseDown[i]^.ProcObj(Button, x, y)
  else
  _LinkMouseDown[i]^.Proc(Button, x, y);
  _MDPos[Button] := Point(x, y);
  _MBDown[Button] := True;
end;

procedure TG2Core.OnMouseUp(const Button: TG2IntS32; const x, y: TG2IntS32);
  var i: TG2IntS32;
begin
  for i := 0 to _LinkMouseUp.Count - 1 do
  if _LinkMouseUp[i]^.Obj then
  _LinkMouseUp[i]^.ProcObj(Button, x, y)
  else
  _LinkMouseUp[i]^.Proc(Button, x, y);
  _MBDown[Button] := False;
end;

procedure TG2Core.OnScroll(const y: TG2IntS32);
  var i: TG2IntS32;
begin
  for i := 0 to _LinkScroll.Count - 1 do
  if _LinkScroll[i]^.Obj then
  _LinkScroll[i]^.ProcObj(y)
  else
  _LinkScroll[i]^.Proc(y);
end;

procedure TG2Core.OnResize(const PrevWidth, PrevHeight, NewWidth, NewHeight: TG2IntS32);
  var i: TG2IntS32;
begin
  for i := 0 to _LinkResize.Count - 1 do
  if _LinkResize[i]^.Obj then
  _LinkResize[i]^.ProcObj(PrevWidth, PrevHeight, NewWidth, NewHeight)
  else
  _LinkResize[i]^.Proc(PrevWidth, PrevHeight, NewWidth, NewHeight);
end;

function TG2Core.GetKeyDown(const Index: TG2IntS32): Boolean;
begin
  if Index > High(_KeyDown) then
  begin
    Result := False;
    Exit;
  end;
  Result := _KeyDown[Index];
end;

function TG2Core.GetMouseDown(const Index: TG2IntS32): Boolean;
begin
  if Index > High(_MBDown) then
  begin
    Result := False;
    Exit;
  end;
  Result := _MBDown[Index];
end;

function TG2Core.GetMouseDownPos(const Index: TG2IntS32): TPoint;
begin
  Result := _MDPos[Index];
end;

function TG2Core.GetMousePos: TPoint;
{$if defined(G2Target_Windows)}
begin
  GetCursorPos(Result);
  if _Started then
  ScreenToClient(_Window.Handle, Result);
end;
{$elseif defined(G2Target_Linux)}
  var e: TXEvent;
begin
  XQueryPointer(
    _Window.Display, _Window.Handle,
    @e.xbutton.root, @e.xbutton.window,
    @e.xbutton.x_root, @e.xbutton.y_root,
    @Result.x, @Result.y,
    @e.xbutton.state
  );
end;
{$elseif defined(G2Target_OSX)}
  var CursorPos: MacOSAll.Point;
  var WindowRect: MacOSAll.Rect;
begin
  GetMouse(CursorPos);
  GetWindowBounds(_Window.Handle, kWindowContentRgn, WindowRect);
  Result := Point(CursorPos.h - WindowRect.left, CursorPos.v - WindowRect.top);
end;
{$elseif defined(G2Target_Android)}
begin
  Result := _CursorPos;
end;
{$elseif defined(G2Target_iOS)}
begin
  Result := _CursorPos;
end;
{$endif}

function TG2Core.GetAppPath: String;
begin
  Result := G2GetAppPath;
end;

procedure TG2Core.SetShowCursor(const Value: Boolean);
begin
  if _ShowCursor <> Value then
  begin
    _ShowCursor := Value;
    {$if defined(G2Target_Windows)}
    Windows.ShowCursor(_ShowCursor);
    {$endif}
  end;
end;

procedure TG2Core.SetPause(const Value: Boolean);
begin
  if _Pause <> Value then
  begin
    _Pause := Value;
    if not _Pause then
    _UpdatePrevTime := G2Time;
  end;
end;

function TG2Core.GetDeltaTime: TG2Float;
begin
  Result := 1000 / _TargetUPS;
end;

function TG2Core.GetDeltaTimeSec: TG2Float;
begin
  Result := 1 / _TargetUPS;
end;

function TG2Core.GetRenderTarget: TG2Texture2DRT;
begin
  Result := _Gfx.StateChange.StateRenderTarget;
end;

procedure TG2Core.SetRenderTarget(const Value: TG2Texture2DRT);
begin
  _Gfx.StateChange.StateRenderTarget := Value;
end;

procedure TG2Core.Start;
  var CurTime: TG2IntU32;
  {$if defined(G2Target_iOS)}
  var Pool: NSAutoreleasePool;
  {$endif}
begin
  {$if defined(G2Target_iOS)}
  if not _PoolInitialized then
  begin
    Pool := NSAutoreleasePool.alloc.init;
    _PoolInitialized := True;
    ExitCode := UIApplicationMain(argc, argv, nil, NSStr('TG2AppDelegate'));
    Pool.release;
    Exit;
  end;
  {$endif}
  if _Started then Exit;
  CurTime := G2Time;
  _UpdatePrevTime := CurTime;
  _UpdateCount := 1;
  _TargetUPS := g2.Params.TargetUPS;
  _MaxFPS := g2.Params.MaxFPS;
  _RenderPrevTime := CurTime;
  _FrameCount := 0;
  _FPSUpdateTime := CurTime;
  FillChar(_KeyDown, SizeOf(_KeyDown), 0);
  FillChar(_MBDown, SizeOf(_MBDown), 0);
  OnLoop;
  _UpdatePrevTime := CurTime;
end;

procedure TG2Core.Stop;
begin
  if _Started then
  begin
    {$ifdef G2Target_Android}
    OnStop;
    AndroidBinding.AppClose;
    {$else}
    _Window.Stop;
    {$endif}
  end;
end;

{$ifdef G2Target_Android}
class procedure TG2Core.AndroidMessage(const Env: PJNIEnv; const Obj: JObject; const MessageType, Param0, Param1, Param2: TG2IntS32);
begin
  case TG2AndroidMessageType(MessageType) of
    amConnect:
    begin
      AndroidBinding.Init(Env, Obj);
    end;
    amInit:
    begin
      AndroidBinding.Init(Env, Obj);
      G2InitializeMath;
      G2Initialize;
      g2.Params._ScreenWidth := Param0;
      g2.Params._ScreenHeight := Param1;
      g2.Params.Width := Param0;
      g2.Params.Height := Param1;
    end;
    amQuit:
    begin
      AndroidBinding.Init(Env, Obj);
      g2.Stop;
      G2Finalize;
    end;
    amResize:
    begin
      AndroidBinding.Init(Env, Obj);
      g2.Params.Width := Param0;
      g2.Params.Height := Param1;
      glViewport(0, 0, Param0, Param1);
    end;
    amDraw:
    begin
      AndroidBinding.Init(Env, Obj);
      g2.OnUpdate;
      g2.OnRender;
    end;
    amTouchDown:
    begin
      AndroidBinding.Init(Env, Obj);
      g2.Log.WriteLn('amTouchDown - BEGIN');
      g2.Window.AddMessage(@g2.Window.OnMouseDown, G2MB_Left, Param0, Param1);
      g2._CursorPos := Point(Param0, Param1);
      g2.Log.WriteLn('amTouchDown - END');
    end;
    amTouchUp:
    begin
      AndroidBinding.Init(Env, Obj);
      g2.Log.WriteLn('amTouchUp - BEGIN');
      g2.Window.AddMessage(@g2.Window.OnMouseUp, G2MB_Left, Param0, Param1);
      g2._CursorPos := Point(Param0, Param1);
      g2.Log.WriteLn('amTouchUp - END');
    end;
    amTouchMove:
    begin
      g2._CursorPos := Point(Param0, Param1);
    end;
  end;
end;
{$endif}

procedure TG2Core.CallbackInitializeAdd(const ProcInitialize: TG2Proc);
  var Link: PG2LinkProc;
begin
  New(Link);
  Link^.Obj := False;
  Link^.Proc := ProcInitialize;
  _LinkInitialize.Add(Link);
end;

procedure TG2Core.CallbackInitializeAdd(const ProcInitialize: TG2ProcObj);
  var Link: PG2LinkProc;
begin
  New(Link);
  Link^.Obj := True;
  Link^.ProcObj := ProcInitialize;
  _LinkInitialize.Add(Link);
end;

procedure TG2Core.CallbackInitializeRemove(const ProcInitialize: TG2Proc);
  var i: TG2IntS32;
  var Link: PG2LinkProc;
begin
  for i := 0 to _LinkInitialize.Count - 1 do
  begin
    Link := _LinkInitialize[i];
    if not Link^.Obj and (Link^.Proc = ProcInitialize) then
    begin
      Dispose(Link);
      _LinkInitialize.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackInitializeRemove(const ProcInitialize: TG2ProcObj);
  var i: TG2IntS32;
  var Link: PG2LinkProc;
begin
  for i := 0 to _LinkInitialize.Count - 1 do
  begin
    Link := _LinkInitialize[i];
    if Link^.Obj
    and G2CmpObjFuncPtr(@Link^.ProcObj, @ProcInitialize) then
    begin
      Dispose(Link);
      _LinkInitialize.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackFinalizeAdd(const ProcFinalize: TG2Proc);
  var Link: PG2LinkProc;
begin
  New(Link);
  Link^.Obj := False;
  Link^.Proc := ProcFinalize;
  _LinkFinalize.Add(Link);
end;

procedure TG2Core.CallbackFinalizeAdd(const ProcFinalize: TG2ProcObj);
  var Link: PG2LinkProc;
begin
  New(Link);
  Link^.Obj := True;
  Link^.ProcObj := ProcFinalize;
  _LinkFinalize.Add(Link);
end;

procedure TG2Core.CallbackFinalizeRemove(const ProcFinalize: TG2Proc);
  var i: TG2IntS32;
  var Link: PG2LinkProc;
begin
  for i := 0 to _LinkFinalize.Count - 1 do
  begin
    Link := _LinkFinalize[i];
    if not Link^.Obj and (Link^.Proc = ProcFinalize) then
    begin
      Dispose(Link);
      _LinkFinalize.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackFinalizeRemove(const ProcFinalize: TG2ProcObj);
  var i: TG2IntS32;
  var Link: PG2LinkProc;
begin
  for i := 0 to _LinkFinalize.Count - 1 do
  begin
    Link := _LinkFinalize[i];
    if Link^.Obj
    and G2CmpObjFuncPtr(@Link^.ProcObj, @ProcFinalize) then
    begin
      Dispose(Link);
      _LinkFinalize.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackUpdateAdd(const ProcUpdate: TG2Proc);
  var Link: PG2LinkUpdate;
begin
  New(Link);
  Link^.Obj := False;
  Link^.Proc := ProcUpdate;
  Link^.Enabled := True;
  _LinkUpdate.Add(Link);
end;

procedure TG2Core.CallbackUpdateAdd(const ProcUpdate: TG2ProcObj);
  var Link: PG2LinkUpdate;
begin
  New(Link);
  Link^.Obj := True;
  Link^.ProcObj := ProcUpdate;
  Link^.Enabled := True;
  _LinkUpdate.Add(Link);
end;

procedure TG2Core.CallbackUpdateRemove(const ProcUpdate: TG2Proc);
  var i: TG2IntS32;
  var Link: PG2LinkUpdate;
begin
  for i := 0 to _LinkUpdate.Count - 1 do
  begin
    Link := _LinkUpdate[i];
    if not Link^.Obj and (Link^.Proc = ProcUpdate) then
    begin
      Link^.Enabled := False;
      Link^.Proc := nil;
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackUpdateRemove(const ProcUpdate: TG2ProcObj);
  var i: TG2IntS32;
  var Link: PG2LinkUpdate;
begin
  for i := 0 to _LinkUpdate.Count - 1 do
  begin
    Link := _LinkUpdate[i];
    if Link^.Obj
    and G2CmpObjFuncPtr(@Link^.ProcObj, @ProcUpdate) then
    begin
      Link^.Enabled := False;
      Link^.ProcObj := nil;
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackRenderAdd(const ProcRender: TG2Proc; const Order: TG2Float = 0);
  var Link: PG2LinkProc;
begin
  New(Link);
  Link^.Obj := False;
  Link^.Proc := ProcRender;
  _LinkRender.Add(Link, Order);
end;

procedure TG2Core.CallbackRenderAdd(const ProcRender: TG2ProcObj; const Order: TG2Float = 0);
  var Link: PG2LinkProc;
begin
  New(Link);
  Link^.Obj := True;
  Link^.ProcObj := ProcRender;
  _LinkRender.Add(Link, Order);
end;

procedure TG2Core.CallbackRenderRemove(const ProcRender: TG2Proc);
  var i: TG2IntS32;
  var Link: PG2LinkProc;
begin
  for i := 0 to _LinkRender.Count - 1 do
  begin
    Link := _LinkRender[i];
    if not Link^.Obj and (Link^.Proc = ProcRender) then
    begin
      Dispose(Link);
      _LinkRender.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackRenderRemove(const ProcRender: TG2ProcObj);
  var i: TG2IntS32;
  var Link: PG2LinkProc;
begin
  for i := 0 to _LinkRender.Count - 1 do
  begin
    Link := _LinkRender[i];
    if Link^.Obj
    and G2CmpObjFuncPtr(@Link^.ProcObj, @ProcRender) then
    begin
      Dispose(Link);
      _LinkRender.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackPrintAdd(const ProcPrint: TG2ProcChar);
  var Link: PG2LinkPrint;
begin
  New(Link);
  Link^.Obj := False;
  Link^.Proc := ProcPrint;
  _LinkPrint.Add(Link);
end;

procedure TG2Core.CallbackPrintAdd(const ProcPrint: TG2ProcCharObj);
  var Link: PG2LinkPrint;
begin
  New(Link);
  Link^.Obj := True;
  Link^.ProcObj := ProcPrint;
  _LinkPrint.Add(Link);
end;

procedure TG2Core.CallbackPrintRemove(const ProcPrint: TG2ProcChar);
  var i: TG2IntS32;
  var Link: PG2LinkPrint;
begin
  for i := 0 to _LinkPrint.Count - 1 do
  begin
    Link := _LinkPrint[i];
    if not Link^.Obj and (Link^.Proc = ProcPrint) then
    begin
      Dispose(Link);
      _LinkPrint.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackPrintRemove(const ProcPrint: TG2ProcCharObj);
  var i: TG2IntS32;
  var Link: PG2LinkPrint;
begin
  for i := 0 to _LinkPrint.Count - 1 do
  begin
    Link := _LinkPrint[i];
    if Link^.Obj
    and G2CmpObjFuncPtr(@Link^.ProcObj, @ProcPrint) then
    begin
      Dispose(Link);
      _LinkPrint.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackKeyDownAdd(const ProcKeyDown: TG2ProcKey);
  var Link: PG2LinkKey;
begin
  New(Link);
  Link^.Obj := False;
  Link^.Proc := ProcKeyDown;
  _LinkKeyDown.Add(Link);
end;

procedure TG2Core.CallbackKeyDownAdd(const ProcKeyDown: TG2ProcKeyObj);
  var Link: PG2LinkKey;
begin
  New(Link);
  Link^.Obj := True;
  Link^.ProcObj := ProcKeyDown;
  _LinkKeyDown.Add(Link);
end;

procedure TG2Core.CallbackKeyDownRemove(const ProcKeyDown: TG2ProcKey);
  var i: TG2IntS32;
  var Link: PG2LinkKey;
begin
  for i := 0 to _LinkKeyDown.Count - 1 do
  begin
    Link := _LinkKeyDown[i];
    if not Link^.Obj and (Link^.Proc = ProcKeyDown) then
    begin
      Dispose(Link);
      _LinkKeyDown.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackKeyDownRemove(const ProcKeyDown: TG2ProcKeyObj);
  var i: TG2IntS32;
  var Link: PG2LinkKey;
begin
  for i := 0 to _LinkKeyDown.Count - 1 do
  begin
    Link := _LinkKeyDown[i];
    if Link^.Obj
    and G2CmpObjFuncPtr(@Link^.ProcObj, @ProcKeyDown) then
    begin
      Dispose(Link);
      _LinkKeyDown.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackKeyUpAdd(const ProcKeyUp: TG2ProcKey);
  var Link: PG2LinkKey;
begin
  New(Link);
  Link^.Obj := False;
  Link^.Proc := ProcKeyUp;
  _LinkKeyUp.Add(Link);
end;

procedure TG2Core.CallbackKeyUpAdd(const ProcKeyUp: TG2ProcKeyObj);
  var Link: PG2LinkKey;
begin
  New(Link);
  Link^.Obj := True;
  Link^.ProcObj := ProcKeyUp;
  _LinkKeyUp.Add(Link);
end;

procedure TG2Core.CallbackKeyUpRemove(const ProcKeyUp: TG2ProcKey);
  var i: TG2IntS32;
  var Link: PG2LinkKey;
begin
  for i := 0 to _LinkKeyUp.Count - 1 do
  begin
    Link := _LinkKeyUp[i];
    if not Link^.Obj and (Link^.Proc = ProcKeyUp) then
    begin
      Dispose(Link);
      _LinkKeyUp.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackKeyUpRemove(const ProcKeyUp: TG2ProcKeyObj);
  var i: TG2IntS32;
  var Link: PG2LinkKey;
begin
  for i := 0 to _LinkKeyUp.Count - 1 do
  begin
    Link := _LinkKeyUp[i];
    if Link^.Obj
    and G2CmpObjFuncPtr(@Link^.ProcObj, @ProcKeyUp) then
    begin
      Dispose(Link);
      _LinkKeyUp.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackMouseDownAdd(const ProcMouseDown: TG2ProcMouse);
  var Link: PG2LinkMouse;
begin
  New(Link);
  Link^.Obj := False;
  Link^.Proc := ProcMouseDown;
  _LinkMouseDown.Add(Link);
end;

procedure TG2Core.CallbackMouseDownAdd(const ProcMouseDown: TG2ProcMouseObj);
  var Link: PG2LinkMouse;
begin
  New(Link);
  Link^.Obj := True;
  Link^.ProcObj := ProcMouseDown;
  _LinkMouseDown.Add(Link);
end;

procedure TG2Core.CallbackMouseDownRemove(const ProcMouseDown: TG2ProcMouse);
  var i: TG2IntS32;
  var Link: PG2LinkMouse;
begin
  for i := 0 to _LinkMouseDown.Count - 1 do
  begin
    Link := _LinkMouseDown[i];
    if not Link^.Obj and (Link^.Proc = ProcMouseDown) then
    begin
      Dispose(Link);
      _LinkMouseDown.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackMouseDownRemove(const ProcMouseDown: TG2ProcMouseObj);
  var i: TG2IntS32;
  var Link: PG2LinkMouse;
begin
  for i := 0 to _LinkMouseDown.Count - 1 do
  begin
    Link := _LinkMouseDown[i];
    if Link^.Obj
    and G2CmpObjFuncPtr(@Link^.ProcObj, @ProcMouseDown) then
    begin
      Dispose(Link);
      _LinkMouseDown.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackMouseUpAdd(const ProcMouseUp: TG2ProcMouse);
  var Link: PG2LinkMouse;
begin
  New(Link);
  Link^.Obj := False;
  Link^.Proc := ProcMouseUp;
  _LinkMouseUp.Add(Link);
end;

procedure TG2Core.CallbackMouseUpAdd(const ProcMouseUp: TG2ProcMouseObj);
  var Link: PG2LinkMouse;
begin
  New(Link);
  Link^.Obj := True;
  Link^.ProcObj := ProcMouseUp;
  _LinkMouseUp.Add(Link);
end;

procedure TG2Core.CallbackMouseUpRemove(const ProcMouseUp: TG2ProcMouse);
  var i: TG2IntS32;
  var Link: PG2LinkMouse;
begin
  for i := 0 to _LinkMouseUp.Count - 1 do
  begin
    Link := _LinkMouseUp[i];
    if not Link^.Obj and (Link^.Proc = ProcMouseUp) then
    begin
      Dispose(Link);
      _LinkMouseUp.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackMouseUpRemove(const ProcMouseUp: TG2ProcMouseObj);
  var i: TG2IntS32;
  var Link: PG2LinkMouse;
begin
  for i := 0 to _LinkMouseUp.Count - 1 do
  begin
    Link := _LinkMouseUp[i];
    if Link^.Obj
    and G2CmpObjFuncPtr(@Link^.ProcObj, @ProcMouseUp) then
    begin
      Dispose(Link);
      _LinkMouseUp.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackScrollAdd(const ProcScroll: TG2ProcScroll);
  var Link: PG2LinkScroll;
begin
  New(Link);
  Link^.Obj := False;
  Link^.Proc := ProcScroll;
  _LinkScroll.Add(Link);
end;

procedure TG2Core.CallbackScrollAdd(const ProcScroll: TG2ProcScrollObj);
  var Link: PG2LinkScroll;
begin
  New(Link);
  Link^.Obj := True;
  Link^.ProcObj := ProcScroll;
  _LinkScroll.Add(Link);
end;

procedure TG2Core.CallbackScrollRemove(const ProcScroll: TG2ProcScroll);
  var i: TG2IntS32;
  var Link: PG2LinkScroll;
begin
  for i := 0 to _LinkScroll.Count - 1 do
  begin
    Link := _LinkScroll[i];
    if not Link^.Obj and (Link^.Proc = ProcScroll) then
    begin
      Dispose(Link);
      _LinkScroll.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackScrollRemove(const ProcScroll: TG2ProcScrollObj);
  var i: TG2IntS32;
  var Link: PG2LinkScroll;
begin
  for i := 0 to _LinkScroll.Count - 1 do
  begin
    Link := _LinkScroll[i];
    if Link^.Obj
    and G2CmpObjFuncPtr(@Link^.ProcObj, @ProcScroll) then
    begin
      Dispose(Link);
      _LinkScroll.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackResizeAdd(const ProcResize: TG2ProcResize);
  var Link: PG2LinkResize;
begin
  New(Link);
  Link^.Obj := False;
  Link^.Proc := ProcResize;
  _LinkResize.Add(Link);
end;

procedure TG2Core.CallbackResizeAdd(const ProcResize: TG2ProcResizeObj);
  var Link: PG2LinkResize;
begin
  New(Link);
  Link^.Obj := True;
  Link^.ProcObj := ProcResize;
  _LinkResize.Add(Link);
end;

procedure TG2Core.CallbackResizeRemove(const ProcResize: TG2ProcResize);
  var i: TG2IntS32;
  var Link: PG2LinkResize;
begin
  for i := 0 to _LinkResize.Count - 1 do
  begin
    Link := _LinkResize[i];
    if not Link^.Obj and (Link^.Proc = ProcResize) then
    begin
      Dispose(Link);
      _LinkResize.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CallbackResizeRemove(const ProcResize: TG2ProcResizeObj);
  var i: TG2IntS32;
  var Link: PG2LinkResize;
begin
  for i := 0 to _LinkResize.Count - 1 do
  begin
    Link := _LinkResize[i];
    if Link^.Obj
    and G2CmpObjFuncPtr(@Link^.ProcObj, @ProcResize) then
    begin
      Dispose(Link);
      _LinkResize.Delete(i);
      Break;
    end;
  end;
end;

procedure TG2Core.CustomTimer(const Func: TG2CustomTimerFuncObj; const IntervalMs: TG2IntS32);
  var ct: TG2CustomTimer;
begin
  ct := TG2CustomTimer.Create(Func, IntervalMs);
  _CustomTimers.Add(ct);
end;

procedure TG2Core.CustomTimer(const Func: TG2CustomTimerFunc; const IntervalMs: TG2IntS32);
  var ct: TG2CustomTimer;
begin
  ct := TG2CustomTimer.Create(Func, IntervalMs);
  _CustomTimers.Add(ct);
end;

procedure TG2Core.PicQuadCol(
  const Pos0, Pos1, Pos2, Pos3, Tex0, Tex1, Tex2, Tex3: TG2Vec2;
  const Col0, Col1, Col2, Col3: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2IntU32 = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  _Gfx.Pic2D.DrawQuad(
    Pos0, Pos1, Pos2, Pos3,
    Tex0, Tex1, Tex2, Tex3,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicQuadCol(
  const x0, y0, x1, y1, x2, y2, x3, y3, tu0, tv0, tu1, tv1, tu2, tv2, tu3, tv3: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  _Gfx.Pic2D.DrawQuad(
    G2Vec2(x0, y0), G2Vec2(x1, y1), G2Vec2(x2, y2), G2Vec2(x3, y3),
    G2Vec2(tu0, tv0), G2Vec2(tu1, tv1), G2Vec2(tu2, tv2), G2Vec2(tu3, tv3),
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Core.PicQuad(
  const Pos0, Pos1, Pos2, Pos3, Tex0, Tex1, Tex2, Tex3: TG2Vec2;
  const Col: TG2Color;
  const Texture: TG2Texture2DBase; const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
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
  const Col: TG2Color;
  const Texture: TG2Texture2DBase; const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
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
      const Col0, Col1, Col2, Col3: TG2Color;
      const TexRect: TG2Vec4;
      const Texture: TG2Texture2DBase;
      const BlendMode: TG2BlendModeRef = bmNormal;
      const Filtering: TG2Filter = tfPoint
); overload;
begin
  PicRectCol(Pos.x, Pos.y, Width, Height, Col0, Col1, Col2, Col3, TexRect.x, TexRect.y, TexRect.z, TexRect.w, Texture, BlendMode, Filtering);
end;

procedure TG2Core.PicRectCol(
  const x, y: TG2Float;
  const Width, Height: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Color;
  const tu0, tv0, tu1, tv1: TG2Float;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
); overload;
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
  const Col0, Col1, Col2, Col3: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(Pos.x, Pos.y, Width, Height, Col0, Col1, Col2, Col3, Texture, BlendMode, Filtering);
end;

procedure TG2Core.PicRectCol(
  const x, y: TG2Float;
  const Width, Height: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(x, y, Width, Height, Col0, Col1, Col2, Col3, 0, 0, Texture.SizeTU, Texture.SizeTV, Texture, BlendMode, Filtering);
end;

procedure TG2Core.PicRectCol(
  const Pos: TG2Vec2;
  const Col0, Col1, Col2, Col3: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(Pos.x, Pos.y, Texture.Width, Texture.Height, Col0, Col1, Col2, Col3, Texture, BlendMode, Filtering);
end;

procedure TG2Core.PicRectCol(
  const x, y: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(x, y, Texture.Width, Texture.Height, Col0, Col1, Col2, Col3, Texture, BlendMode, Filtering);
end;

procedure TG2Core.PicRectCol(
  const Pos: TG2Vec2;
  const Width, Height: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Color;
  const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const FrameWidth, FrameHeight: TG2IntS32;
  const FrameID: TG2IntS32;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
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
  const Col0, Col1, Col2, Col3: TG2Color;
  const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const FrameWidth, FrameHeight: TG2IntS32;
  const FrameID: TG2IntS32;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
  var Pts: array[0..3] of TG2Vec2;
  var w, h: TG2Float;
  var mr: TG2Mat;
  var pc, py, px: TG2IntS32;
  var tu, tv: TG2Float;
  var tr0, tr1, tc0, tc1, tc2, tc3: TG2Vec2;
begin
  mr := G2MatRotationZ(Rotation);
  w := Width * ScaleX; h := Height * ScaleY;
  {$Warnings off}
  Pts[0].SetValue(-w * CenterX, -h * CenterY);
  Pts[1].SetValue(Pts[0].x + w, Pts[0].y);
  Pts[2].SetValue(Pts[0].x, Pts[0].y + h);
  Pts[3].SetValue(Pts[0].x + w, Pts[0].y + h);
  {$Warnings on}
  G2Vec2MatMul3x3(@Pts[0], @Pts[0], @mr);
  G2Vec2MatMul3x3(@Pts[1], @Pts[1], @mr);
  G2Vec2MatMul3x3(@Pts[2], @Pts[2], @mr);
  G2Vec2MatMul3x3(@Pts[3], @Pts[3], @mr);
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
  _Gfx.Pic2D.DrawQuad(
    Pts[0], Pts[1], Pts[2], Pts[3],
    tc0, tc1, tc2, tc3,
    Col0, Col1, Col2, Col3,
    Texture,
    BlendMode,
    Filtering
  );
end;

procedure TG2Core.PicRect(
  const Pos: TG2Vec2; const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(Pos.x, Pos.y, Col, Col, Col, Col, Texture, BlendMode, Filtering);
end;

procedure TG2Core.PicRect(
  const x, y: TG2Float; const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(x, y, Col, Col, Col, Col, Texture, BlendMode, Filtering);
end;

procedure TG2Core.PicRect(
  const Pos: TG2Vec2;
  const Width, Height: TG2Float;
  const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(Pos, Width, Height, Col, Col, Col, Col, Texture, BlendMode, Filtering);
end;

procedure TG2Core.PicRect(
  const x, y: TG2Float;
  const Width, Height: TG2Float;
  const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(x, y, Width, Height, Col, Col, Col, Col, Texture, BlendMode, Filtering);
end;

procedure TG2Core.PicRect(
  const Pos: TG2Vec2;
  const Width, Height: TG2Float;
  const TexRect: TG2Vec4;
  const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
); overload;
begin
  PicRectCol(Pos, Width, Height, Col, Col, Col, Col, TexRect, Texture, BlendMode, Filtering);
end;

procedure TG2Core.PicRect(
  const x, y: TG2Float;
  const Width, Height: TG2Float;
  const tu0, tv0, tu1, tv1: TG2Float;
  const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
); overload;
begin
  PicRectCol(x, y, Width, Height, Col, Col, Col, Col, tu0, tv0, tu1, tv1, Texture, BlendMode, Filtering);
end;

procedure TG2Core.PicRect(
  const Pos: TG2Vec2;
  const Width, Height: TG2Float;
  const Col: TG2Color;
  const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const FrameWidth, FrameHeight: TG2IntS32;
  const FrameID: TG2IntS32;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(Pos, Width, Height, Col, Col, Col, Col, CenterX, CenterY, ScaleX, ScaleY, Rotation, FlipU, FlipV, Texture, FrameWidth, FrameHeight, FrameID, BlendMode, Filtering);
end;

procedure TG2Core.PicRect(
  const x, y: TG2Float;
  const Width, Height: TG2Float;
  const Col: TG2Color;
  const CenterX, CenterY, ScaleX, ScaleY, Rotation: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const FrameWidth, FrameHeight: TG2IntS32;
  const FrameID: TG2IntS32;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(x, y, Width, Height, Col, Col, Col, Col, CenterX, CenterY, ScaleX, ScaleY, Rotation, FlipU, FlipV, Texture, FrameWidth, FrameHeight, FrameID, BlendMode, Filtering);
end;

procedure TG2Core.PrimBegin(const PrimType: TG2PrimType; const BlendMode: TG2BlendMode);
begin
  _Gfx.Prim2D.PrimBegin(PrimType, BlendMode);
end;

procedure TG2Core.PrimEnd;
begin
  _Gfx.Prim2D.PrimEnd;
end;

procedure TG2Core.PrimAdd(const x, y: TG2Float; const Color: TG2Color);
begin
  _Gfx.Prim2D.PrimAdd(x, y, Color);
end;

procedure TG2Core.PrimAdd(const Pos: TG2Vec2; const Color: TG2Color);
begin
  _Gfx.Prim2D.PrimAdd(Pos.x, Pos.y, Color);
end;

procedure TG2Core.PrimLineCol(const Pos0, Pos1: TG2Vec2; const Col0, Col1: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(Pos0, Col0);
  PrimAdd(Pos1, Col1);
  PrimEnd;
end;

procedure TG2Core.PrimLineCol(const x0, y0, x1, y1: TG2Float; const Col0, Col1: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(x0, y0, Col0);
  PrimAdd(x1, y1, Col1);
  PrimEnd;
end;

procedure TG2Core.PrimLine(const Pos0, Pos1: TG2Vec2; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(Pos0, Col);
  PrimAdd(Pos1, Col);
  PrimEnd;
end;

procedure TG2Core.PrimLine(const x0, y0, x1, y1: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(x0, y0, Col);
  PrimAdd(x1, y1, Col);
  PrimEnd;
end;

procedure TG2Core.PrimTriCol(const Pos0, Pos1, Pos2: TG2Vec2; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(Pos0, Col0);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos2, Col2);
  PrimEnd;
end;

procedure TG2Core.PrimTriCol(const x0, y0, x1, y1, x2, y2: TG2Float; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(x0, y0, Col0);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x2, y2, Col2);
  PrimEnd;
end;

procedure TG2Core.PrimQuadCol(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(Pos0, Col0);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos2, Col2);
  PrimAdd(Pos2, Col2);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos3, Col3);
  PrimEnd;
end;

procedure TG2Core.PrimQuadCol(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(x0, y0, Col0);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x2, y2, Col2);
  PrimAdd(x2, y2, Col2);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x3, y3, Col3);
  PrimEnd;
end;

procedure TG2Core.PrimQuad(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(Pos0, Col);
  PrimAdd(Pos1, Col);
  PrimAdd(Pos2, Col);
  PrimAdd(Pos2, Col);
  PrimAdd(Pos1, Col);
  PrimAdd(Pos3, Col);
  PrimEnd;
end;

procedure TG2Core.PrimQuad(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(x0, y0, Col);
  PrimAdd(x1, y1, Col);
  PrimAdd(x2, y2, Col);
  PrimAdd(x2, y2, Col);
  PrimAdd(x1, y1, Col);
  PrimAdd(x3, y3, Col);
  PrimEnd;
end;

procedure TG2Core.PrimRectCol(const x, y, w, h: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
  var x1, y1: TG2Float;
begin
  x1 := x + w;
  y1 := y + h;
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(x, y, Col0);
  PrimAdd(x1, y, Col1);
  PrimAdd(x, y1, Col2);
  PrimAdd(x, y1, Col2);
  PrimAdd(x1, y, Col1);
  PrimAdd(x1, y1, Col3);
  PrimEnd;
end;

procedure TG2Core.PrimRect(const x, y, w, h: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
  var x1, y1: TG2Float;
begin
  x1 := x + w;
  y1 := y + h;
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(x, y, Col);
  PrimAdd(x1, y, Col);
  PrimAdd(x, y1, Col);
  PrimAdd(x, y1, Col);
  PrimAdd(x1, y, Col);
  PrimAdd(x1, y1, Col);
  PrimEnd;
end;

procedure TG2Core.PrimRectHollowCol(const x, y, w, h: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
  var x1, y1: TG2Float;
begin
  x1 := x + w;
  y1 := y + h;
  PrimBegin(ptLines, BlendMode);
  PrimAdd(x, y, Col0);
  PrimAdd(x1, y, Col1);
  PrimAdd(x1, y, Col1);
  PrimAdd(x1, y1, Col3);
  PrimAdd(x1, y1, Col3);
  PrimAdd(x, y1, Col2);
  PrimAdd(x, y1, Col2);
  PrimAdd(x, y, Col0);
  PrimEnd;
end;

procedure TG2Core.PrimRectHollow(const x, y, w, h: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
  var x1, y1: TG2Float;
begin
  x1 := x + w;
  y1 := y + h;
  PrimBegin(ptLines, BlendMode);
  PrimAdd(x, y, Col);
  PrimAdd(x1, y, Col);
  PrimAdd(x1, y1, Col);
  PrimAdd(x1, y - 1, Col);
  PrimAdd(x1, y1, Col);
  PrimAdd(x, y1, Col);
  PrimAdd(x, y1, Col);
  PrimAdd(x, y, Col);
  PrimEnd;
end;

procedure TG2Core.PrimCircleCol(const Pos: TG2Vec2; const Radius: TG2Float; const Col0, Col1: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal);
  var a, s, c: TG2Float;
  var v, v2: TG2Vec2;
  var i: TG2IntS32;
begin
  a := G2TwoPi / Segments;
  G2SinCos(a, s{%H-}, c{%H-});
  v.SetValue(Radius, 0);
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(Pos, Col0);
  PrimAdd(v + Pos, Col1);
  for i := 0 to Segments - 2 do
  begin
    v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
    v2 := v + Pos;
    PrimAdd(v2, Col1);
    PrimAdd(Pos, Col0);
    PrimAdd(v2, Col1);
  end;
  v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
  PrimAdd(v + Pos, Col1);
  PrimEnd;
end;

procedure TG2Core.PrimCircleCol(const x, y, Radius: TG2Float; const Col0, Col1: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal);
  var a, s, c, cx, cy: TG2Float;
  var v: TG2Vec2;
  var i: TG2IntS32;
begin
  a := G2TwoPi / Segments;
  G2SinCos(a, s{%H-}, c{%H-});
  v.SetValue(Radius, 0);
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(x, y, Col0);
  PrimAdd(v.x + x, v.y + y, Col1);
  for i := 0 to Segments - 2 do
  begin
    v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
    cx := v.x + x; cy := v.y + y;
    PrimAdd(cx, cy, Col1);
    PrimAdd(x, y, Col0);
    PrimAdd(cx, cy, Col1);
  end;
  v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
  PrimAdd(v.x + x, v.y + y, Col1);
  PrimEnd;
end;

procedure TG2Core.PrimTriHollowCol(const Pos0, Pos1, Pos2: TG2Vec2; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(Pos0, Col0);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos2, Col2);
  PrimAdd(Pos2, Col2);
  PrimAdd(Pos0, Col0);
  PrimEnd;
end;

procedure TG2Core.PrimTriHollowCol(const x0, y0, x1, y1, x2, y2: TG2Float; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(x0, y0, Col0);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x2, y2, Col2);
  PrimAdd(x2, y2, Col2);
  PrimAdd(x0, y0, Col0);
  PrimEnd;
end;

procedure TG2Core.PrimQuadHollowCol(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(Pos0, Col0);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos2, Col2);
  PrimAdd(Pos2, Col2);
  PrimAdd(Pos3, Col3);
  PrimAdd(Pos3, Col3);
  PrimAdd(Pos0, Col0);
  PrimEnd;
end;

procedure TG2Core.PrimQuadHollowCol(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(x0, y0, Col0);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x2, y2, Col2);
  PrimAdd(x2, y2, Col2);
  PrimAdd(x3, y3, Col3);
  PrimAdd(x3, y3, Col3);
  PrimAdd(x0, y0, Col0);
  PrimEnd;
end;

procedure TG2Core.PrimCircleHollow(const Pos: TG2Vec2; const Radius: TG2Float; const Col: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal);
  var a, s, c: TG2Float;
  var v, v2: TG2Vec2;
  var i: TG2IntS32;
begin
  a := G2TwoPi / Segments;
  G2SinCos(a, s{%H-}, c{%H-});
  v.SetValue(Radius, 0);
  PrimBegin(ptLines, BlendMode);
  PrimAdd(v + Pos, Col);
  for i := 0 to Segments - 2 do
  begin
    v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
    v2 := v + Pos;
    PrimAdd(v2, Col);
    PrimAdd(v2, Col);
  end;
  v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
  PrimAdd(v + Pos, Col);
  PrimEnd;
end;

procedure TG2Core.PrimCircleHollow(const x, y, Radius: TG2Float; const Col: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal);
  var a, s, c, cx, cy: TG2Float;
  var v: TG2Vec2;
  var i: TG2IntS32;
begin
  a := G2TwoPi / Segments;
  G2SinCos(a, s{%H-}, c{%H-});
  v.SetValue(Radius, 0);
  PrimBegin(ptLines, BlendMode);
  PrimAdd(v.x + x, v.y + y, Col);
  for i := 0 to Segments - 2 do
  begin
    v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
    cx := v.x + x; cy := v.y + y;
    PrimAdd(cx, cy, Col);
    PrimAdd(cx, cy, Col);
  end;
  v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
  PrimAdd(v.x + x, v.y + y, Col);
  PrimEnd;
end;

procedure TG2Core.PolyBegin(
  const PolyType: TG2PrimType;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef;
  const Filter: TG2Filter
);
begin
  _Gfx.Poly2D.PolyBegin(PolyType, Texture, BlendMode, Filter);
end;

procedure TG2Core.PolyEnd;
begin
  _Gfx.Poly2D.PolyEnd;
end;

procedure TG2Core.PolyAdd(const x, y, u, v: TG2Float; const Color: TG2Color);
begin
  _Gfx.Poly2D.PolyAdd(x, y, u, v, Color);
end;

procedure TG2Core.PolyAdd(const Pos, TexCoord: TG2Vec2; const Color: TG2Color);
begin
  _Gfx.Poly2D.PolyAdd(Pos, TexCoord, Color);
end;

procedure TG2Core.Prim3DBegin(
  const PrimType: TG2PrimType;
  const BlendMode: TG2BlendMode;
  const WVP: TG2Mat
);
begin
  _Gfx.Prim3D.PrimBegin(PrimType, BlendMode, WVP);
end;

procedure TG2Core.Prim3DEnd;
begin
  _Gfx.Prim3D.PrimEnd;
end;

procedure TG2Core.Prim3DAdd(const x, y, z: TG2Float; const Color: TG2Color);
begin
  _Gfx.Prim3D.PrimAdd(x, y, z, Color);
end;

procedure TG2Core.Prim3DAdd(const Pos: TG2Vec3; const Color: TG2Color);
begin
  _Gfx.Prim3D.PrimAdd(Pos, Color);
end;

procedure TG2Core.Prim3DAddTri(
  const v0, v1, v2: TG2Vec3;
  const c0, c1, c2: TG2Color
);
begin
  _Gfx.Prim3D.PrimAdd(v0, c0);
  _Gfx.Prim3D.PrimAdd(v1, c1);
  _Gfx.Prim3D.PrimAdd(v2, c2);
end;

procedure TG2Core.Prim3DAddQuad(
  const v0, v1, v2, v3: TG2Vec3;
  const c0, c1, c2, c3: TG2Color
);
begin
  _Gfx.Prim3D.PrimAdd(v0, c0);
  _Gfx.Prim3D.PrimAdd(v1, c1);
  _Gfx.Prim3D.PrimAdd(v2, c2);
  _Gfx.Prim3D.PrimAdd(v2, c2);
  _Gfx.Prim3D.PrimAdd(v1, c1);
  _Gfx.Prim3D.PrimAdd(v3, c3);
end;

procedure TG2Core.Poly3DBegin(
  const PolyType: TG2PrimType;
  const Texture: TG2Texture2DBase;
  const WVP: TG2Mat;
  const BlendMode: TG2BlendModeRef;
  const Filter: TG2Filter
);
begin
  _Gfx.Poly3D.PolyBegin(PolyType, Texture, WVP, BlendMode, Filter);
end;

procedure TG2Core.Poly3DEnd;
begin
  _Gfx.Poly3D.PolyEnd;
end;

procedure TG2Core.Poly3DAdd(
  const x, y, z, u, v: TG2Float;
  const Color: TG2Color
);
begin
  _Gfx.Poly3D.PolyAdd(x, y, z, u, v, Color);
end;

procedure TG2Core.Poly3DAdd(
  const Pos: TG2Vec3;
  const TexCoord: TG2Vec2;
  const Color: TG2Color
);
begin
  _Gfx.Poly3D.PolyAdd(Pos, TexCoord, Color);
end;

procedure TG2Core.Poly3DAddQuad(
  const p0, p1, p2, p3: TG2Vec3;
  const t0, t1, t2, t3: TG2Vec2;
  const c0, c1, c2, c3: TG2Color
);
begin
  Poly3DAdd(p0, t0, c0);
  Poly3DAdd(p1, t1, c1);
  Poly3DAdd(p2, t2, c2);
  Poly3DAdd(p2, t2, c2);
  Poly3DAdd(p1, t1, c1);
  Poly3DAdd(p3, t3, c3);
end;

procedure TG2Core.Clear(const Color: TG2Color);
begin
  _Gfx.StateChange.StateClear(Color);
end;

procedure TG2Core.Clear(
  const Color: Boolean; const ColorValue: TG2Color;
  const Depth: Boolean; const DepthValue: TG2Float;
  const Stencil: Boolean; const StencilValue: TG2IntU8
);
begin
  _Gfx.StateChange.StateClear(Color, ColorValue, Depth, DepthValue, Stencil, StencilValue);
end;

constructor TG2Core.Create;
begin
  inherited Create;
  {$if defined(G2Target_Windows)}
  _Platform := tpWindows;
  {$elseif defined(G2Target_Linux)}
  _Platform := tpLinux;
  {$elseif defined(G2Target_OSX)}
  _Platform := tpMacOSX;
  {$elseif defined(G2Target_Android)}
  _Platform := tpAndroid;
  G2DataManagerChachedRead := True;
  {$elseif defined(G2Target_iOS)}
  _Platform := tpiOS;
  _PoolInitialized := False;
  {$endif}
  _AppPath := GetAppPath;
  _Started := False;
  _Window := nil;
  _Log := TG2Log.Create;
  _Params := TG2Params.Create;
  _Sys := TG2Sys.Create;
  {$if defined(G2Gfx_D3D9)}
  _Gfx := TG2GfxD3D9.Create;
  {$elseif defined(G2Gfx_OGL)}
  _Gfx := TG2GfxOGL.Create;
  {$elseif defined(G2Gfx_GLES)}
  _Gfx := TG2GfxGLES.Create;
  {$endif}
  {$if defined(G2Snd_DS)}
  _Snd := TG2SndDS.Create;
  {$elseif defined(G2Snd_OAL)}
  _Snd := TG2SndOAL.Create;
  {$elseif defined(G2Snd_OSL)}
  _Snd := TG2SndOSL.Create;
  {$endif}
  _PackLinker := TG2PackLinker.Create;
  G2PackLinker := _PackLinker;
  _AssetSourceManager := TG2AssetSourceManager.Create;
  G2AssetSourceManager := _AssetSourceManager;
  _FPS := 0;
  _LinkInitialize.Clear;
  _LinkFinalize.Clear;
  _LinkUpdate.Clear;
  _LinkRender.Clear;
  _LinkPrint.Clear;
  _LinkKeyDown.Clear;
  _LinkKeyUp.Clear;
  _LinkMouseDown.Clear;
  _LinkMouseUp.Clear;
  _LinkScroll.Clear;
  _LinkResize.Clear;
  _CustomTimers.Clear;
  _ShowCursor := True;
  {$if defined(G2Target_Android) or defined(G2Target_iOS)}
  _CursorPos := Point(0, 0);
  {$endif}
end;

destructor TG2Core.Destroy;
  var i: TG2IntS32;
  var Res: TG2Res;
begin
  for i := 0 to _CustomTimers.Count - 1 do _CustomTimers[i].Free;
  for i := 0 to _LinkInitialize.Count - 1 do Dispose(_LinkInitialize[i]);
  for i := 0 to _LinkFinalize.Count - 1 do Dispose(_LinkFinalize[i]);
  for i := 0 to _LinkUpdate.Count - 1 do Dispose(_LinkUpdate[i]);
  for i := 0 to _LinkRender.Count - 1 do Dispose(_LinkRender[i]);
  for i := 0 to _LinkPrint.Count - 1 do Dispose(_LinkPrint[i]);
  for i := 0 to _LinkKeyDown.Count - 1 do Dispose(_LinkKeyDown[i]);
  for i := 0 to _LinkKeyUp.Count - 1 do Dispose(_LinkKeyUp[i]);
  for i := 0 to _LinkMouseDown.Count - 1 do Dispose(_LinkMouseDown[i]);
  for i := 0 to _LinkMouseUp.Count - 1 do Dispose(_LinkMouseUp[i]);
  for i := 0 to _LinkScroll.Count - 1 do Dispose(_LinkScroll[i]);
  for i := 0 to _LinkResize.Count - 1 do Dispose(_LinkResize[i]);
  if _Started then Stop;
  {$if defined(G2Log)}
  Res := TG2Res.List;
  while Res <> nil do
  begin
    if Res is TG2Asset then
    begin
      if TG2Asset(Res).IsShared then
      begin
        _Log.WriteLn('Warning: Shared Asset leak ' + Res.ClassName + '; Name: ' + TG2Asset(Res).AssetName + '; RefCount: ' + IntToStr(Res.RefCount));
      end
      else
      begin
        _Log.WriteLn('Warning: Asset leak ' + Res.ClassName + '; RefCount: ' + IntToStr(Res.RefCount));
      end;
    end
    else
    begin
      _Log.WriteLn('Warning: Resource leak ' + Res.ClassName + '; RefCount: ' + IntToStr(Res.RefCount));
    end;
    Res := Res.Next;
  end;
  {$endif}
  TG2Res.CleanUp;
  _PackLinker.Free;
  G2PackLinker := nil;
  _AssetSourceManager.Free;
  G2AssetSourceManager := nil;
  _Snd.Free;
  _Gfx.Free;
  _Sys.Free;
  _Sys := nil;
  _Params.Free;
  _Params := nil;
  _Log.Free;
  inherited Destroy;
end;
//TG2Core END

//TG2Thread BEGIN
function G2ThreadFunc(ThreadCaller: Pointer): PtrInt;
begin
  TG2Thread(ThreadCaller).Run;
  Result := 0;
end;

procedure TG2Thread.Run;
begin
  _State := tsRunning;
  Execute;
  _State := tsFinished;
end;

procedure TG2Thread.Execute;
begin
  if Assigned(_Proc) then _Proc;
end;

constructor TG2Thread.Create;
begin
  inherited Create;
  _State := tsIdle;
  _Proc := nil;
end;

destructor TG2Thread.Destroy;
begin
  Stop;
  inherited Destroy;
end;

procedure TG2Thread.Start;
begin
  _ThreadHandle := BeginThread(@G2ThreadFunc, Self, _ThreadID);
end;

procedure TG2Thread.Stop;
begin
  if _State = tsRunning then
  KillThread(_ThreadHandle);
  if _State <> tsIdle then
  CloseThread(_ThreadHandle);
end;

procedure TG2Thread.WaitFor(const Timeout: TG2IntU32);
begin
  WaitForThreadTerminate(_ThreadHandle, Timeout);
end;
//TG2Thread END

//TG2CriticalSection BEGIN
procedure TG2CriticalSection.Initialize;
begin
  InitCriticalSection(_CS);
end;

procedure TG2CriticalSection.Finalize;
begin
  DoneCriticalSection(_CS);
end;

procedure TG2CriticalSection.Enter;
begin
  EnterCriticalSection(_CS);
end;

procedure TG2CriticalSection.Leave;
begin
  LeaveCriticalSection(_CS);
end;
//TG2CriticalSection END

//TG2Window BEGIN
procedure TG2Window.AddMessage(const MessageProc: TG2ProcWndMessage; const Param1, Param2, Param3: TG2IntS32);
begin
  if _MessageCount >= Length(_MessageStack) then
  SetLength(_MessageStack, _MessageCount + 32);
  _MessageStack[_MessageCount].MessageProc := MessageProc;
  _MessageStack[_MessageCount].Param1 := Param1;
  _MessageStack[_MessageCount].Param2 := Param2;
  _MessageStack[_MessageCount].Param3 := Param3;
  Inc(_MessageCount);
end;

procedure TG2Window.ProcessMessages;
  var i: TG2IntS32;
begin
  if _MessageCount > 0 then
  begin
    for i := 0 to _MessageCount - 1 do
    _MessageStack[i].MessageProc(_MessageStack[i].Param1, _MessageStack[i].Param2, _MessageStack[i].Param3);
    _MessageCount := 0;
  end;
end;

procedure TG2Window.OnPrint(const Key, Param2, Param3: TG2IntS32);
begin
  g2.OnPrint(AnsiChar(PG2IntU8Arr(@Key)^[0]));
end;

procedure TG2Window.OnKeyDown(const Key, Param2, Param3: TG2IntS32);
begin
  g2.OnKeyDown(KeyRemap(Key));
end;

procedure TG2Window.OnKeyUp(const Key, Param2, Param3: TG2IntS32);
begin
  g2.OnKeyUp(KeyRemap(Key));
end;

procedure TG2Window.OnMouseDown(const Button, x, y: TG2IntS32);
begin
  g2.OnMouseDown(Button, x, y);
end;

procedure TG2Window.OnMouseUp(const Button, x, y: TG2IntS32);
begin
  g2.OnMouseUp(Button, x, y);
end;

procedure TG2Window.OnScroll(const y, Param2, Param3: TG2IntS32);
begin
  g2.OnScroll(y);
end;

procedure TG2Window.OnResize(const Mode, NewWidth, NewHeight: TG2IntS32);
  var R: TRect;
begin
  {$if defined(G2Target_Windows)}
  if not _ProcessResize then Exit;
  GetClientRect(_Handle, R{%H-});
  g2.Params.Width := R.Right - R.Left;
  g2.Params.Height := R.Bottom - R.Top;
  if g2.Params.ScreenMode <> smFullscreen then
  case Mode of
    0: g2.Params.ScreenMode := smWindow;
    1: g2.Params.ScreenMode := smMaximized;
  end;
  g2.Params.Apply;
  {$endif}
end;

procedure TG2Window.Adjust(
  const OldScreenMode, NewScreenMode: TG2ScreenMode;
  const OldWidth, OldHeight, NewWidth, NewHeight: TG2IntS32;
  const OldResizable, NewResizable: Boolean
);
  var R: TRect;
  var OldWndStyle, NewWndStyle: TG2IntU32;
  var w, h: TG2IntS32;
begin
  {$if defined(G2Target_Windows)}
  _ProcessResize := False;
  case NewScreenMode of
    smWindow:
    begin
      NewWndStyle := (
        WS_CAPTION or
        WS_POPUP or
        WS_VISIBLE or
        WS_EX_TOPMOST or
        WS_MINIMIZEBOX or
        WS_MAXIMIZEBOX or
        WS_SYSMENU
      );
      if (OldScreenMode <> NewScreenMode)
      or (OldResizable <> NewResizable) then
      begin
        if NewResizable then NewWndStyle := NewWndStyle or WS_THICKFRAME;
        SetWindowLongA(_Handle, GWL_STYLE, NewWndStyle);
      end;
      GetClientRect(_Handle, R{%H-});
      w := R.Right - R.Left;
      h := R.Bottom - R.Top;
      if (w <> NewWidth)
      or (h <> NewHeight) then
      begin
        R.Left := (GetSystemMetrics(SM_CXSCREEN) - NewWidth) shr 1;
        R.Right := R.Left + NewWidth;
        R.Top := (GetSystemMetrics(SM_CYSCREEN) - NewHeight) shr 1;
        R.Bottom := R.Top + NewHeight;
        AdjustWindowRect(R, NewWndStyle, False);
        SetWindowPos(_Handle, HWND_TOPMOST, R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top, SWP_NOZORDER);
      end;
    end;
    smMaximized:
    begin
      if OldScreenMode <> NewScreenMode then
      begin
        OldWndStyle := GetWindowLong(_Handle, GWL_STYLE);
        if (OldWndStyle and WS_MAXIMIZE) = 0 then
        begin
          NewWndStyle := (
            WS_CAPTION or
            WS_POPUP or
            WS_VISIBLE or
            WS_EX_TOPMOST or
            WS_MINIMIZEBOX or
            WS_MAXIMIZEBOX or
            WS_SYSMENU
          );
          SetWindowLongA(_Handle, GWL_STYLE, NewWndStyle);
          ShowWindow(_Handle, SW_MAXIMIZE);
        end;
        GetClientRect(_Handle, R);
        g2.Params.Width := R.Right - R.Left;
        g2.Params.Height := R.Bottom - R.Top;
      end;
    end;
    smFullscreen:
    begin
      if OldScreenMode <> NewScreenMode then
      begin
        NewWndStyle := (
          WS_POPUP or
          WS_VISIBLE or
          WS_EX_TOPMOST
        );
        SetWindowLongA(_Handle, GWL_STYLE, NewWndStyle);
        w := GetSystemMetrics(SM_CXSCREEN);
        h := GetSystemMetrics(SM_CYSCREEN);
        SetWindowPos(_Handle, HWND_TOPMOST, 0, 0, w, h, SWP_NOZORDER);
        g2.Params.Width := w;
        g2.Params.Height := h;
      end;
    end;
  end;
  _ProcessResize := True;
  {$elseif defined(G2Target_Linux)}
  {$elseif defined(G2Target_OSX)}
  {$endif}
end;

procedure TG2Window.Stop;
begin
  {$if defined(G2Target_iOS)}
  if _Loop then
  begin
    _Loop := False;
    g2.OnStop;
  end;
  {$else}
  _Loop := False;
  {$endif}
end;

procedure TG2Window.SetCaption(const Value: AnsiString);
begin
  if _Caption <> Value then
  begin
    _Caption := Value;
    {$if defined(G2Target_Windows)}
    SetWindowTextA(_Handle, PAnsiChar(_Caption));
    {$elseif defined(G2Target_Linux)}
    XStoreName(_Display, _Handle, PAnsiChar(_Caption));
    {$elseif defined(G2Target_OSX)}
    SetWindowTitleWithCFString(
      _Handle, CFStringCreateWithPascalString(nil, _Caption, kCFStringEncodingASCII)
    );
    {$endif}
  end;
end;

{$if not defined(G2Target_Mobile)}
procedure TG2Window.SetCursor(const Value: TG2Cursor);
begin
  if _Cursor <> Value then
  begin
    _Cursor := Value;
    {$if defined(G2Target_Windows)}
    Windows.SetCursor(_Cursor);
    {$endif}
  end;
end;
{$endif}

procedure TG2Window.Loop;
{$if defined(G2Target_Windows)}
  var msg: TMsg;
{$elseif defined(G2Target_Linux)}
  var Event: TXEvent;
{$elseif defined(G2Target_OSX)}
  var EvMask: MacOSAll.EventMask;
  var Event: MacOSAll.EventRecord;
{$endif}
begin
  {$if defined(G2Target_iOS)}
  g2.OnUpdate;
  g2.OnRender;
  {$else}
  _Loop := True;
  {$if defined(G2Target_Windows)}
  FillChar(msg{%H-}, SizeOf(msg), 0);
  while _Loop
  and (msg.message <> WM_QUIT)
  and (msg.message <> WM_DESTROY)
  and (msg.message <> WM_CLOSE) do
  begin
    if PeekMessage(msg, 0, 0, 0, PM_REMOVE) then
    begin
      TranslateMessage(msg);
      DispatchMessage(msg);
    end
    {$ifndef G2Threading}
    else
    begin
      g2.OnUpdate;
      g2.OnRender;
    end
    {$endif};
  end;
  ExitCode := 0;
  {$elseif defined(G2Target_Linux)}
  FillChar(Event, SizeOf(Event), 0);
  while _Loop
  and not (
    (Event._type = ClientMessage)
    and (Event.xclient.data.l[0] = _WMDelete)
  )do
  begin
    if XPending(_Display) > 0 then
    begin
      XNextEvent(_Display, @Event);
      G2MessageHandler(Event);
    end
    {$ifndef G2Threading}
    else
    begin
      g2.OnUpdate;
      g2.OnRender;
    end
    {$endif};
  end;
  {$elseif defined(G2Target_OSX)}
  EvMask := everyEvent;
  while _Loop do
  begin
    if GetNextEvent(EvMask, Event) then begin ; end
    {$ifndef G2Threading}
    else
    begin
      g2.OnUpdate;
      g2.OnRender;
    end
    {$endif};
  end;
  {$endif}
  g2.OnStop;
  {$endif}
end;

procedure TG2Window.DisplayMessage(const Text: AnsiString);
{$if defined(G2Target_Windows)}
begin
  MessageBoxA(_Handle, PAnsiChar(Text), 'Error', 0);
end;
{$elseif defined(G2Target_Linux)}
  var d: PDisplay;
  var w: TWindow;
  var e: TXEvent;
  var msg: PChar;
  var s: Integer;
begin
  msg := PChar(Text);
  d := XOpenDisplay(nil);
  if d = nil then exit;
  try
    s := DefaultScreen(d);
    w := XCreateSimpleWindow(
      d, RootWindow(d, s), 10, 10, 200, 200, 1,
      BlackPixel(d, s), WhitePixel(d, s)
    );
    XSelectInput(d, w, ExposureMask or KeyPressMask);
    XMapWindow(d, w);
    while (True) do
    begin
      XNextEvent(d, @e);
      if (e._type = Expose) then
      begin
        XFillRectangle(d, w, DefaultGC(d, s), 20, 20, 10, 10);
        XDrawString(d, w, DefaultGC(d, s), 50, 50, msg, strlen(msg));
      end;
      if (e._type = KeyPress) then Break;
    end;
  finally
    XCloseDisplay(d);
  end;
end;
{$else}
begin
end;
{$endif}

constructor TG2Window.Create(const Width: TG2IntS32 = 0; const Height: TG2IntS32 = 0; const NewCaption: AnsiString = 'Gen2MP');
{$if defined(G2Target_Windows)}
  var w, h: TG2IntS32;
  var R: TRect;
  var WndStyle: TG2IntU32;
{$elseif defined(G2Target_Linux)}
  type THints = record
    Flags: TG2IntU32;
    Functions: TG2IntU32;
    Decorations: TG2IntU32;
    InputMode: TG2IntS32;
    Status: TG2IntU32;
  end;
  var w, h: TG2IntS32;
  var WndParams: TXWindowChanges;
  var WndHints: THints;
  var WndProps: TAtom;
  var WndState: TAtom;
  var WndFullscreen: TAtom;
  var WndAbove: TAtom;
  var WndMaxV: TAtom;
  var WndMaxH: TAtom;
  var WndAttribs: TXSetWindowAttributes;
  var WndGetAttr: TXWindowAttributes;
  var WndValueMask: TG2IntU32;
  var event: TXEvent;
  var VisualAttribs: array[0..17] of TG2IntS32;
{$elseif defined(G2Target_OSX)}
  var w, h: TG2IntS32;
  var R: MacOSAll.Rect;
  var WndAttribs: MacOSAll.WindowAttributes;
  var WndEvents: array[0..5] of MacOSAll.EventTypeSpec;
{$endif}
begin
  inherited Create;
  _Caption := NewCaption;
  _MessageCount := 0;
  {$if defined(G2Target_Windows)}
  _ProcessResize := False;
  _CursorArrow := LoadCursor(0, IDC_ARROW);
  _CursorText := LoadCursor(0, IDC_IBEAM);
  _CursorHand := LoadCursor(0, IDC_HAND);
  _CursorSizeNS := LoadCursor(0, IDC_SIZENS);
  _CursorSizeWE := LoadCursor(0, IDC_SIZEWE);
  case g2.Params.ScreenMode of
    smWindow:
    begin
      if Width < 128 then w := 128 else w := Width;
      if Height < 32 then h := 32 else h := Height;
      WndStyle := (
        WS_CAPTION or
        WS_POPUP or
        WS_VISIBLE or
        WS_EX_TOPMOST or
        WS_MINIMIZEBOX or
        WS_MAXIMIZEBOX or
        WS_SYSMENU
      );
      if g2.Params.Resizable then WndStyle := WndStyle or WS_THICKFRAME;
      R.Left := (GetSystemMetrics(SM_CXSCREEN) - w) shr 1;
      R.Right := R.Left + w;
      R.Top := (GetSystemMetrics(SM_CYSCREEN) - h) shr 1;
      R.Bottom := R.Top + h;
      AdjustWindowRect(R, WndStyle, False);
      _Handle := CreateWindowExA(
        WS_EX_WINDOWEDGE or WS_EX_APPWINDOW, PAnsiChar(G2WndClassName), PAnsiChar(Caption),
        WndStyle,
        R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top,
        0, 0, HInstance, nil
      );
    end;
    smMaximized:
    begin
      w := GetSystemMetrics(SM_CXMAXIMIZED);
      h := GetSystemMetrics(SM_CYMAXIMIZED);
      WndStyle := (
        WS_CAPTION or
        WS_POPUP or
        WS_VISIBLE or
        WS_EX_TOPMOST or
        WS_MINIMIZEBOX or
        WS_MAXIMIZEBOX or
        WS_SYSMENU
      );
      R.Left := 0;
      R.Right := w;
      R.Top := 0;
      R.Bottom := h;
      _Handle := CreateWindowExA(
        0, PAnsiChar(G2WndClassName), PAnsiChar(Caption),
        WndStyle,
        R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top,
        0, 0, HInstance, nil
      );
      ShowWindow(_Handle, SW_MAXIMIZE);
      GetClientRect(_Handle, R);
      g2.Params.Width := R.Right - R.Left;
      g2.Params.Height := R.Bottom - R.Top;
    end;
    smFullscreen:
    begin
      w := GetSystemMetrics(SM_CXSCREEN);
      h := GetSystemMetrics(SM_CYSCREEN);
      WndStyle := (
        WS_POPUP or
        WS_VISIBLE or
        WS_EX_TOPMOST
      );
      _Handle := CreateWindowExA(
        0, PAnsiChar(G2WndClassName), PAnsiChar(Caption),
        WndStyle,
        (GetSystemMetrics(SM_CXSCREEN) - w) div 2,
        (GetSystemMetrics(SM_CYSCREEN) - h) div 2,
        w, h, 0, 0, HInstance, nil
      );
      GetClientRect(_Handle, R);
      g2.Params.Width := R.Right - R.Left;
      g2.Params.Height := R.Bottom - R.Top;
    end;
  end;
  BringWindowToTop(_Handle);
  _ProcessResize := True;
  {$elseif defined(G2Target_Linux)}
  _Display := XOpenDisplay(nil);
  FillChar(VisualAttribs, SizeOf(VisualAttribs), 0);
  VisualAttribs[0] := GLX_RGBA; VisualAttribs[1] := 1;
  VisualAttribs[2] := GLX_RED_SIZE; VisualAttribs[3] := 8;
  VisualAttribs[4] := GLX_GREEN_SIZE; VisualAttribs[5] := 8;
  VisualAttribs[6] := GLX_BLUE_SIZE; VisualAttribs[7] := 8;
  VisualAttribs[8] := GLX_ALPHA_SIZE; VisualAttribs[9] := 8;
  VisualAttribs[10] := GLX_DEPTH_SIZE; VisualAttribs[11] := 24;
  VisualAttribs[12] := GLX_STENCIL_SIZE; VisualAttribs[13] := 8;
  VisualAttribs[14] := GLX_DOUBLEBUFFER; VisualAttribs[15] := 1;
  _VisualInfo := glXChooseVisual(_Display, 0, @VisualAttribs);
  FillChar(WndAttribs, SizeOf(WndAttribs), 0);
  WndAttribs.colormap := XCreateColormap(_Display, RootWindow(_Display, 0), _VisualInfo^.visual, AllocNone);
  WndAttribs.event_mask := (
    ExposureMask or
    StructureNotifyMask or
    FocusChangeMask or
    ButtonPressMask or
    ButtonReleaseMask or
    KeyPressMask or
    KeyReleaseMask or
    PointerMotionMask
  );
  WndValueMask := CWColormap or CWEventMask or CWOverrideRedirect or CWBorderPixel or CWBackPixel;
  case g2.Params.ScreenMode of
    smFullscreen:
    begin
      XGetWindowAttributes(_Display, DefaultRootWindow(display), @WndGetAttr);
      w := WndGetAttr.width;
      h := WndGetAttr.height;
      _Handle := XCreateWindow(
        _Display, RootWindow(_Display, 0), 0, 0, w, h,
        0, _VisualInfo^.depth, InputOutput,
        _VisualInfo^.visual, WndValueMask, @WndAttribs
      );
      XMapRaised(_Display, _Handle);
      FillChar(WndHints, SizeOf(WndHints), 0);
      WndHints.Decorations := 0;
      WndHints.Flags := 2;
      WndProps := XInternAtom(_Display, '_MOTIF_WM_HINTS', True);
      XChangeProperty(_Display, _Handle, WndProps, WndProps, 32, PropModeReplace, @WndHints, 5);
      WndParams.x := 0;
      WndParams.y := 0;
      XConfigureWindow(_Display, _Handle, CWX or CWY, @WndParams);

      WndState := XInternAtom(_Display, '_NET_WM_STATE', False);
      WndFullscreen := XInternAtom(_Display, '_NET_WM_STATE_FULLSCREEN', False);
      WndMaxH := XInternAtom(_Display, '_NET_WM_STATE_MAXIMIZED_HORZ', False);
      WndMaxV := XInternAtom(_Display, '_NET_WM_STATE_MAXIMIZED_VERT', False);

      FillChar(event, SizeOf(event), 0);
      event._type := ClientMessage;
      event.xclient.window := _Handle;
      event.xclient.message_type := WndState;
      event.xclient.format := 32;
      event.xclient.data.l[0] := 1;
      event.xclient.data.l[1] := WndFullscreen;
      event.xclient.data.l[2] := 0;

      XSendEvent(_Display, DefaultRootWindow(_Display), False, SubstructureNotifyMask, @event);

      XSync(_Display, False);
      Sleep(1000);
      XGetWindowAttributes(_Display, _Handle, @WndGetAttr);
      g2.Params.Width := WndGetAttr.width;
      g2.Params.Height := WndGetAttr.height;
    end;
    smMaximized:
    begin
      XGetWindowAttributes(_Display, DefaultRootWindow(display), @WndGetAttr);
      w := WndGetAttr.width;
      h := WndGetAttr.height;
      _Handle := XCreateWindow(
        _Display, RootWindow(_Display, 0), 0, 0, w, h,
        0, _VisualInfo^.depth, InputOutput,
        _VisualInfo^.visual, WndValueMask, @WndAttribs
      );
      XMapRaised(_Display, _Handle);
      WndParams.x := 0;
      WndParams.y := 0;
      XConfigureWindow(_Display, _Handle, CWX or CWY, @WndParams);

      WndState := XInternAtom(_Display, '_NET_WM_STATE', False);
      WndMaxH := XInternAtom(_Display, '_NET_WM_STATE_MAXIMIZED_HORZ', False);
      WndMaxV := XInternAtom(_Display, '_NET_WM_STATE_MAXIMIZED_VERT', False);

      FillChar(event, SizeOf(event), 0);
      event._type := ClientMessage;
      event.xclient.window := _Handle;
      event.xclient.message_type := WndState;
      event.xclient.format := 32;
      event.xclient.data.l[0] := 1;
      event.xclient.data.l[1] := WndMaxH;
      event.xclient.data.l[2] := WndMaxV;

      XSendEvent(_Display, DefaultRootWindow(_Display), False, SubstructureNotifyMask, @event);

      XSync(_Display, False);
      Sleep(1000);
      XGetWindowAttributes(_Display, _Handle, @WndGetAttr);
      g2.Params.Width := WndGetAttr.width;
      g2.Params.Height := WndGetAttr.height;
    end;
    smWindow:
    begin
      if Width < 128 then w := 128 else w := Width;
      if Height < 32 then h := 32 else h := Height;
      _Handle := XCreateWindow(
        _Display, RootWindow(_Display, 0), 0, 0, w, h,
        0, _VisualInfo^.depth, InputOutput,
        _VisualInfo^.visual, WndValueMask, @WndAttribs
      );
      XMapRaised(_Display, _Handle);
      WndParams.x := (XDisplayWidth(_Display, 0) - w) div 2;
      WndParams.y := (XDisplayHeight(_Display, 0) - h) div 2;
      XConfigureWindow(_Display, _Handle, CWX or CWY, @WndParams);
    end;
  end;
  _WMDelete := XInternAtom(_Display, 'WM_DELETE_WINDOW', False);
  XSetWMProtocols(_Display, _Handle, @_WMDelete, 1);
  XStoreName(_Display, _Handle, PAnsiChar(_Caption));
  XFlush(_Display);
  gdk_init_check(@argc, argv);
  {$elseif defined(G2Target_OSX)}
  case g2.Params.ScreenMode of
    smFullscreen:
    begin
      GetAvailableWindowPositioningBounds(GetMainDevice, R);
      //w := CGDisplayPixelsWide(kCGDirectMainDisplay);
      w := R.right - R.left;
      h := R.bottom - R.top;
      g2.Params.Width := w; g2.Params.Height := h;
      WndAttribs := (
        (
          kWindowStandardHandlerAttribute or
          kWindowNoTitleBarAttribute or
          kWindowNoShadowAttribute
        ) and not kWindowResizableAttribute
      );
      CreateNewWindow(kDocumentWindowClass, WndAttribs, R, _Handle);
    end;
    smMaximized:
    begin
      GetAvailableWindowPositioningBounds(GetMainDevice, R);
      w := R.right - R.left;
      h := R.bottom - R.top;
      g2.Params.Width := w; g2.Params.Height := h;
      WndAttribs := (
        (
          kWindowCloseBoxAttribute or
          kWindowCollapseBoxAttribute or
          kWindowStandardHandlerAttribute or
          kWindowNoShadowAttribute
        ) and not kWindowResizableAttribute
      );
      CreateNewWindow(kDocumentWindowClass, WndAttribs, R, _Handle);
    end;
    smWindow:
    begin
      if Width < 128 then w := 128 else w := Width;
      if Height < 32 then h := 32 else h := Height;
      g2.Params.Width := w; g2.Params.Height := h;
      R.left := (CGDisplayPixelsWide(kCGDirectMainDisplay) - w) div 2;
      R.top := (CGDisplayPixelsHigh(kCGDirectMainDisplay) - h) div 2;
      R.right := R.left + w;
      R.bottom := R.top + h;
      WndAttribs := (
        (
          kWindowCloseBoxAttribute or
          kWindowCollapseBoxAttribute or
          kWindowStandardHandlerAttribute
        ) and not kWindowResizableAttribute
      );
      CreateNewWindow(kDocumentWindowClass, WndAttribs, R, _Handle);
    end;
  end;
  SetWindowTitleWithCFString(
    _Handle, CFStringCreateWithPascalString(nil, _Caption, kCFStringEncodingASCII)
  );
  WndEvents[0].eventClass := kEventClassCommand;
  WndEvents[0].eventKind := kEventProcessCommand;
  WndEvents[1].eventClass := kEventClassWindow;
  WndEvents[1].eventKind := kEventWindowClosed;
  WndEvents[2].eventClass := kEventClassKeyboard;
  WndEvents[2].eventKind := kEventRawKeyDown;
  WndEvents[3].eventClass := kEventClassKeyboard;
  WndEvents[3].eventKind := kEventRawKeyUp;
  WndEvents[4].eventClass := kEventClassMouse;
  WndEvents[4].eventKind := kEventMouseDown;
  WndEvents[5].eventClass := kEventClassMouse;
  WndEvents[5].eventKind := kEventMouseUp;
  InstallEventHandler(GetApplicationEventTarget, EventHandlerUPP(@G2MessageHandler), 6, @WndEvents, nil, nil);
  ShowWindow(_Handle);
  SelectWindow(_Handle);
  {$elseif defined(G2Target_iOS)}
  _Loop := True;
  {$endif}
  {$if not defined(G2Target_Mobile)}
  _Cursor := 0;
  Cursor := _CursorArrow;
  {$endif}
end;

destructor TG2Window.Destroy;
begin
  {$if defined(G2Target_Windows)}
  DestroyWindow(_Handle);
  {$elseif defined(G2Target_Linux)}
  XFree(_VisualInfo);
  XDestroyWindow(_Display, _Handle);
  XCloseDisplay(_Display);
  {$elseif defined(G2Target_OSX)}
  ReleaseWindow(_Handle);
  {$endif}
  inherited Destroy;
end;
//TG2Window END

//TG2Params BEGIN
procedure TG2Params.SetWidth(const Value: TG2IntS32);
begin
  {$if defined(G2Target_Mobile)}
  if not _Buffered then _Width := _ScreenWidth;
  _NewWidth := _ScreenWidth;
  {$else}
  if not _Buffered then _Width := Value;
  _NewWidth := Value;
  {$endif}
end;

procedure TG2Params.SetHeight(const Value: TG2IntS32);
begin
  {$if defined(G2Target_Mobile)}
  if not _Buffered then _Height := _ScreenHeight;
  _NewHeight := _ScreenHeight;
  {$else}
  if not _Buffered then _Height := Value;
  _NewHeight := Value;
  {$endif}
end;

procedure TG2Params.SetScreenMode(const Value: TG2ScreenMode);
begin
  if not _Buffered then _ScreenMode := Value;
  _NewScreenMode := Value;
end;

procedure TG2Params.SetResizable(const Value: Boolean);
begin
  if not _Buffered then _Resizable := Value;
  _NewResizable := Value;
end;

procedure TG2Params.SetBuffered(const Value: Boolean);
begin
  _Buffered := Value;
end;

constructor TG2Params.Create;
{$if defined(G2Target_Linux)}
  var Display: PXDisplay;
{$endif}
begin
  inherited Create;
  {$if defined(G2Target_Windows)}
  _ScreenWidth := GetSystemMetrics(SM_CXSCREEN);
  _ScreenHeight := GetSystemMetrics(SM_CYSCREEN);
  _Width := 800;
  _Height := 600;
  {$elseif defined(G2Target_Linux)}
  Display := XOpenDisplay(nil);
  _ScreenWidth := XDisplayWidth(Display, 0);
  _ScreenHeight := XDisplayHeight(Display, 0);
  XCloseDisplay(Display);
  _Width := 800;
  _Height := 600;
  {$elseif defined(G2Target_OSX)}
  _ScreenWidth := CGDisplayPixelsWide(kCGDirectMainDisplay);
  _ScreenHeight := CGDisplayPixelsHigh(kCGDirectMainDisplay);
  _Width := 800;
  _Height := 600;
  {$elseif defined(G2Target_iOS)}
  _ScreenWidth := Round(UIScreen.mainScreen.bounds.size.width);
  _ScreenHeight := Round(UIScreen.mainScreen.bounds.size.height);
  _Width := _ScreenWidth;
  _Height := _ScreenHeight;
  {$endif}
  _WidthRT := _Width;
  _HeightRT := _Height;
  _ScreenMode := smWindow;
  _Resizable := True;
  _NewWidth := _Width;
  _NewHeight := _Height;
  _NewResizable := _Resizable;
  _NewScreenMode := _ScreenMode;
  _TargetUPS := 60;
  _MaxFPS := 0;
  _Buffered := False;
  _PreventUpdateOverload := false;
end;

destructor TG2Params.Destroy;
begin
  inherited Destroy;
end;

function TG2Params.NeedUpdate: Boolean;
begin
  Result := (
    (_NewWidth <> _Width)
    or (_NewHeight <> _Height)
    or (_NewScreenMode <> _ScreenMode)
    or (_NewResizable <> _Resizable)
  );
end;

procedure TG2Params.Apply;
begin
  if NeedUpdate then
  begin
    g2.Window.Adjust(
      _ScreenMode, _NewScreenMode,
      _Width, _Height, _NewWidth, _NewHeight,
      _Resizable, _NewResizable
    );
    g2.Gfx.Resize(_Width, _Height, _NewWidth, _NewHeight);
    g2.OnResize(_Width, _Height, _NewWidth, _NewHeight);
    _ScreenMode := _NewScreenMode;
    _Width := _NewWidth;
    _Height := _NewHeight;
    _Resizable := _NewResizable;
  end;
end;
//TG2Params END

//TG2Sys BEGIN
constructor TG2Sys.Create;
begin
  inherited Create;
end;

destructor TG2Sys.Destroy;
begin
  inherited Destroy;
end;
//TG2Sys END

//TG2Gfx BEGIN
{$if defined(G2RM_SM2)}
procedure TG2Gfx.AddShader(const Name: AnsiString; const Prog: Pointer; const ProgSize: TG2IntS32);
  var ShaderGroup: TG2ShaderGroup;
  var ShaderItem: PG2ShaderItem;
begin
  ShaderGroup := TG2ShaderGroup.Create;
  ShaderGroup.Load(Prog, ProgSize);
  New(ShaderItem);
  ShaderItem^.Name := Name;
  ShaderItem^.ShaderGroup := ShaderGroup;
  _Shaders.Add(ShaderItem);
end;

procedure TG2Gfx.InitShaders;
begin
  AddShader('StandardShaders', @G2Bin_StandardShaders, SizeOf(G2Bin_StandardShaders));
end;

procedure TG2Gfx.FreeShaders;
  var i: TG2IntS32;
begin
  for i := 0 to _Shaders.Count - 1 do
  begin
    PG2ShaderItem(_Shaders[i])^.ShaderGroup.Free;
    Dispose(PG2ShaderItem(_Shaders[i]));
  end;
  _Shaders.Clear;
end;
{$endif}

{$if defined(G2RM_FF)}
//TG2GfxTextureStage BEGIN
procedure TG2GfxTextureStage.SetColorArgument(const Index: TG2IntU8; const Argument: TG2GfxTextureStageArgument);
{$if defined(G2Gfx_D3D9)}
  const ArgIndexRemap: array[0..2] of TD3DTextureStageStateType = (
    D3DTSS_COLORARG1,
    D3DTSS_COLORARG2,
    D3DTSS_COLORARG0
  );
begin
  if _ColorArgument[Index] = Argument then Exit;
  _ColorArgument[Index] := Argument;
  _Gfx.Device.SetTextureStageState(_Stage, ArgIndexRemap[Index], StageArgRemap[TG2IntU8(_ColorArgument[Index])]);
end;
{$elseif defined(G2Gfx_OGL)}
  const ArgIndexRemap: array[0..2] of TGLenum = (
    GL_SOURCE0_RGB,
    GL_SOURCE1_RGB,
    GL_SOURCE2_RGB
  );
  const OperandIndexRemap: array[0..2] of TGLenum = (
    GL_OPERAND0_RGB,
    GL_OPERAND1_RGB,
    GL_OPERAND2_RGB
  );
begin
  if _ColorArgument[Index] = Argument then Exit;
  _ColorArgument[Index] := Argument;
  glTexEnvi(GL_TEXTURE_ENV, ArgIndexRemap[Index], StageArgRemap[TG2IntU8(_ColorArgument[Index])]);
  glTexEnvi(GL_TEXTURE_ENV, OperandIndexRemap[Index], GL_SRC_COLOR);
end;
{$elseif defined(G2Gfx_GLES)}
  const ArgIndexRemap: array[0..2] of TGLenum = (
    GL_SOURCE0_RGB,
    GL_SOURCE1_RGB,
    GL_SOURCE2_RGB
  );
  const OperandIndexRemap: array[0..2] of TGLenum = (
    GL_OPERAND0_RGB,
    GL_OPERAND1_RGB,
    GL_OPERAND2_RGB
  );
begin
  if _ColorArgument[Index] = Argument then Exit;
  _ColorArgument[Index] := Argument;
  glTexEnvi(GL_TEXTURE_ENV, ArgIndexRemap[Index], StageArgRemap[TG2IntU8(_ColorArgument[Index])]);
  glTexEnvi(GL_TEXTURE_ENV, OperandIndexRemap[Index], GL_SRC_COLOR);
end;
{$endif}

procedure TG2GfxTextureStage.SetAlphaArgument(const Index: TG2IntU8; const Argument: TG2GfxTextureStageArgument);
{$if defined(G2Gfx_D3D9)}
  const ArgIndexRemap: array[0..2] of TD3DTextureStageStateType = (
    D3DTSS_ALPHAARG1,
    D3DTSS_ALPHAARG2,
    D3DTSS_ALPHAARG0
  );
begin
  if _AlphaArgument[Index] = Argument then Exit;
  _AlphaArgument[Index] := Argument;
  _Gfx.Device.SetTextureStageState(_Stage, ArgIndexRemap[Index], StageArgRemap[TG2IntU8(_AlphaArgument[Index])]);
end;
{$elseif defined(G2Gfx_OGL)}
  const ArgIndexRemap: array[0..2] of TGLenum = (
    GL_SOURCE0_ALPHA,
    GL_SOURCE1_ALPHA,
    GL_SOURCE2_ALPHA
  );
  const OperandIndexRemap: array[0..2] of TGLenum = (
    GL_OPERAND0_ALPHA,
    GL_OPERAND1_ALPHA,
    GL_OPERAND2_ALPHA
  );
begin
  if _AlphaArgument[Index] = Argument then Exit;
  _AlphaArgument[Index] := Argument;
  glTexEnvi(GL_TEXTURE_ENV, ArgIndexRemap[Index], StageArgRemap[TG2IntU8(_AlphaArgument[Index])]);
  glTexEnvi(GL_TEXTURE_ENV, OperandIndexRemap[Index], GL_SRC_ALPHA);
end;
{$elseif defined(G2Gfx_GLES)}
  const ArgIndexRemap: array[0..2] of TGLenum = (
    GL_SOURCE0_ALPHA,
    GL_SOURCE1_ALPHA,
    GL_SOURCE2_ALPHA
  );
  const OperandIndexRemap: array[0..2] of TGLenum = (
    GL_OPERAND0_ALPHA,
    GL_OPERAND1_ALPHA,
    GL_OPERAND2_ALPHA
  );
begin
  if _AlphaArgument[Index] = Argument then Exit;
  _AlphaArgument[Index] := Argument;
  glTexEnvi(GL_TEXTURE_ENV, ArgIndexRemap[Index], StageArgRemap[TG2IntU8(_AlphaArgument[Index])]);
  glTexEnvi(GL_TEXTURE_ENV, OperandIndexRemap[Index], GL_SRC_ALPHA);
end;
{$endif}

procedure TG2GfxTextureStage.SetColorOperation(const Value: TG2GfxTextureStageOperation);
{$if defined(G2Gfx_D3D9)}
begin
  if Value = _ColorOperation then Exit;
  _ColorOperation := Value;
  _Gfx.Device.SetTextureStageState(_Stage, D3DTSS_COLOROP, StageOpRemap[TG2IntU8(_ColorOperation)]);
end;
{$elseif defined(G2Gfx_OGL)}
begin
  if Value = _ColorOperation then Exit;
  _ColorOperation := Value;
  _Gfx.ActiveTexture := _Stage;
  glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, StageOpRemap[TG2IntU8(_ColorOperation)]);
  if _AlphaOperation = g2tso_disable then
  begin
    glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, StageOpRemap[TG2IntU8(_ColorOperation)]);
  end;
  if _ColorOperation = g2tso_disable then glDisable(GL_TEXTURE_2D);
end;
{$elseif defined(G2Gfx_GLES)}
begin
  if Value = _ColorOperation then Exit;
  _ColorOperation := Value;
  _Gfx.ActiveTexture := _Stage;
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
  glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, StageOpRemap[TG2IntU8(_ColorOperation)]);
  if _ColorOperation = g2tso_disable then glDisable(GL_TEXTURE_2D);
end;
{$endif}

procedure TG2GfxTextureStage.SetAlphaOperation(const Value: TG2GfxTextureStageOperation);
{$if defined(G2Gfx_D3D9)}
begin
  if Value = _AlphaOperation then Exit;
  _AlphaOperation := Value;
  _Gfx.Device.SetTextureStageState(_Stage, D3DTSS_ALPHAOP, StageOpRemap[TG2IntU8(_ColorOperation)]);
end;
{$elseif defined(G2Gfx_OGL)}
begin
  if Value = _AlphaOperation then Exit;
  _AlphaOperation := Value;
  _Gfx.ActiveTexture := _Stage;
  if _AlphaOperation = g2tso_disable then
  begin
    glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, StageOpRemap[TG2IntU8(_ColorOperation)]);
  end
  else
  begin
    glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, StageOpRemap[TG2IntU8(_AlphaOperation)]);
  end;
end;
{$elseif defined(G2Gfx_GLES)}
begin
  if Value = _AlphaOperation then Exit;
  _AlphaOperation := Value;
  _Gfx.ActiveTexture := _Stage;
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
  if _AlphaOperation = g2tso_disable then
  begin
    glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, StageOpRemap[TG2IntU8(_ColorOperation)]);
  end
  else
  begin
    glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, StageOpRemap[TG2IntU8(_AlphaOperation)]);
  end;
end;
{$endif}

procedure TG2GfxTextureStage.SetColorArgument0(const Value: TG2GfxTextureStageArgument);
begin
  SetColorArgument(0, Value);
end;

procedure TG2GfxTextureStage.SetColorArgument1(const Value: TG2GfxTextureStageArgument);
begin
  SetColorArgument(1, Value);
end;

procedure TG2GfxTextureStage.SetColorArgument2(const Value: TG2GfxTextureStageArgument);
begin
  SetColorArgument(2, Value);
end;

procedure TG2GfxTextureStage.SetAlphaArgument0(const Value: TG2GfxTextureStageArgument);
begin
  SetAlphaArgument(0, Value);
end;

procedure TG2GfxTextureStage.SetAlphaArgument1(const Value: TG2GfxTextureStageArgument);
begin
  SetAlphaArgument(1, Value);
end;

procedure TG2GfxTextureStage.SetAlphaArgument2(const Value: TG2GfxTextureStageArgument);
begin
  SetAlphaArgument(2, Value);
end;

procedure TG2GfxTextureStage.SetConstantColor(const Value: TG2Color);
{$if defined(G2Gfx_D3D9)}
begin
  if _ConstantColor = Value then Exit;
  _ConstantColor := Value;
  _Gfx.Device.SetTextureStageState(_Stage, D3DTSS_CONSTANT, _ConstantColor);
end;
{$elseif defined(G2Gfx_OGL)}
  var v: TG2Vec4;
begin
  if _ConstantColor = Value then Exit;
  _ConstantColor := Value;
  v := _ConstantColor;
  _Gfx.ActiveTexture := _Stage;
  glTexEnvfv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, @v);
end;
{$elseif defined(G2Gfx_GLES)}
  var v: TG2Vec4;
begin
  if _ConstantColor = Value then Exit;
  _ConstantColor := Value;
  v := _ConstantColor;
  _Gfx.ActiveTexture := _Stage;
  glTexEnvfv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, @v);
end;
{$endif}

{$if defined(G2Gfx_D3D9)}
procedure TG2GfxTextureStage.SetTexCoordIndex(const Value: TG2IntU8);
begin
  if _TexCoordIndex = Value then Exit;
  _TexCoordIndex := Value;
  _Gfx.Device.SetTextureStageState(_Stage, D3DTSS_TEXCOORDINDEX, _TexCoordIndex);
end;
{$endif}

constructor TG2GfxTextureStage.Create(const AStage: TG2IntU8);
begin
  inherited Create;
  {$if defined(G2Gfx_D3D9)}
  _Gfx := TG2GfxD3D9(g2.Gfx);
  _TexCoordIndex := _Stage;
  {$elseif defined(G2Gfx_OGL)}
  _Gfx := TG2GfxOGL(g2.Gfx);
  {$elseif defined(G2Gfx_GLES)}
  _Gfx := TG2GfxGLES(g2.Gfx);
  {$endif}
  _Stage := AStage;
  _ConstantColor := $0;
end;
//TG2GfxTextureStage END
{$endif}

function TG2Gfx.AddRenderControl(const ControlClass: CG2RenderControl): TG2RenderControl;
begin
  Result := ControlClass.Create;
  _RenderControls.Add(Result);
end;

procedure TG2Gfx.ProcessRenderQueue;
  var CurRenderControl: TG2RenderControl;
  var i: TG2IntS32;
begin
  CurRenderControl := nil;
  for i := 0 to _RenderQueueCount[_QueueDraw] - 1 do
  begin
    if _RenderQueue[_QueueDraw][i].RenderControl <> CurRenderControl then
    begin
      if CurRenderControl <> nil then
      CurRenderControl.RenderEnd;
      CurRenderControl := _RenderQueue[_QueueDraw][i].RenderControl;
      CurRenderControl.RenderBegin;
    end;
    CurRenderControl.RenderData(_RenderQueue[_QueueDraw][i].RenderData);
  end;
  if CurRenderControl <> nil then
  CurRenderControl.RenderEnd;
end;

{$if defined(G2RM_FF)}
function TG2Gfx.GetTextureStage(const Stage: TG2IntU8): TG2GfxTextureStage;
begin
  Result := _TextureStages[Stage];
end;
{$endif}

procedure TG2Gfx.Resize(const OldWidth, OldHeight, NewWidth, NewHeight: TG2IntS32);
begin
  if _RenderTarget = nil then
  begin
    SizeRT.x := NewWidth;
    SizeRT.y := NewHeight;
  end;
end;

procedure TG2Gfx.Initialize;
  {$if defined(G2RM_FF)}
  var i: TG2IntS32;
  {$endif}
begin
  {$if defined(G2RM_SM2)}
  InitShaders;
  {$endif}
  _ControlStateChange := TG2RenderControlStateChange(AddRenderControl(TG2RenderControlStateChange));
  {$if defined(G2RM_SM2)}
  _ControlBuffer := TG2RenderControlBuffer(AddRenderControl(TG2RenderControlBuffer));
  {$endif}
  _ControlLegacyMesh := TG2RenderControlLegacyMesh(AddRenderControl(TG2RenderControlLegacyMesh));
  _ControlPic2D := TG2RenderControlPic2D(AddRenderControl(TG2RenderControlPic2D));
  _ControlPrim2D := TG2RenderControlPrim2D(AddRenderControl(TG2RenderControlPrim2D));
  _ControlPrim3D := TG2RenderControlPrim3D(AddRenderControl(TG2RenderControlPrim3D));
  _ControlPoly2D := TG2RenderControlPoly2D(AddRenderControl(TG2RenderControlPoly2D));
  _ControlPoly3D := TG2RenderControlPoly3D(AddRenderControl(TG2RenderControlPoly3D));
  _ControlManaged := TG2RenderControlManaged(AddRenderControl(TG2RenderControlManaged));
  {$if defined(G2RM_FF)}
  for i := 0 to High(_TextureStages) do
  begin
    _TextureStages[i] := TG2GfxTextureStage.Create(i);
  end;
  {$endif}
  _RenderTarget := nil;
  _DepthEnable := False;
  _DepthWriteEnable := True;
  _BlendEnable := True;
  _BlendSeparate := False;
  _VertexBuffer := nil;
  _IndexBuffer := nil;
  _CullMode := g2cm_none;
  BlendMode := bmNormal;
  Filter := tfPoint;
end;

procedure TG2Gfx.Finalize;
  var i: TG2IntS32;
begin
  TG2Asset.UnlockQueue(0);
  TG2Asset.UnlockQueue(1);
  {$if defined(G2RM_FF)}
  for i := 0 to High(_TextureStages) do
  begin
    _TextureStages[i].Free;
  end;
  {$endif}
  for i := 0 to _RenderControls.Count - 1 do
  TG2RenderControl(_RenderControls[i]).Free;
  {$if defined(G2RM_SM2)}
  FreeShaders;
  {$endif}
end;

procedure TG2Gfx.Reset;
  var i: TG2IntS32;
begin
  _RenderQueueCount[_QueueFill] := 0;
  for i := 0 to _RenderControls.Count - 1 do
  TG2RenderControl(_RenderControls[i]).Reset;
end;

procedure TG2Gfx.Swap;
  var t: TG2IntS32;
begin
  _NeedToSwap := True;
  while not _CanSwap do;
  TG2Asset.UnlockQueue(_QueueDraw);
  t := _QueueFill;
  _QueueFill := _QueueDraw;
  _QueueDraw := t;
  _NeedToSwap := False;
end;

procedure TG2Gfx.RenderStart;
begin
  while _NeedToSwap do;
  _CanSwap := False;
end;

procedure TG2Gfx.RenderStop;
begin
  _CanSwap := True;
end;

procedure TG2Gfx.AddRenderQueueItem(const Control: TG2RenderControl; const Data: Pointer);
begin
  if _RenderQueueCount[_QueueFill] >= _RenderQueueCapacity[_QueueFill] then
  begin
    _RenderQueueCapacity[_QueueFill] := _RenderQueueCapacity[_QueueFill] + 128;
    SetLength(_RenderQueue[_QueueFill], _RenderQueueCapacity[_QueueFill]);
  end;
  _RenderQueue[_QueueFill][_RenderQueueCount[_QueueFill]].RenderControl := Control;
  _RenderQueue[_QueueFill][_RenderQueueCount[_QueueFill]].RenderData := Data;
  Inc(_RenderQueueCount[_QueueFill]);
end;

{$if defined(G2RM_SM2)}
function TG2Gfx.RequestShader(const Name: AnsiString): TG2ShaderGroup;
  var i: TG2IntS32;
begin
  for i := 0 to _Shaders.Count - 1 do
  if PG2ShaderItem(_Shaders[i])^.Name = Name then
  begin
    Result := PG2ShaderItem(_Shaders[i])^.ShaderGroup;
    Exit;
  end;
  Result := nil;
end;
{$endif}

procedure TG2Gfx.ThreadAttach;
begin

end;

procedure TG2Gfx.ThreadDetach;
begin

end;

constructor TG2Gfx.Create;
begin
  _RenderControls.Clear;
  _RenderQueueCapacity[0] := 0;
  _RenderQueueCapacity[1] := 0;
  _RenderQueueCount[0] := 0;
  _RenderQueueCount[1] := 0;
  _QueueFill := 0;
  _QueueDraw := 1;
  _NeedToSwap := False;
  _CanSwap := True;
  inherited Create;
end;

destructor TG2Gfx.Destroy;
begin
  inherited Destroy;
end;
//TG2Gfx END

{$ifdef G2Gfx_D3D9}
//TG2GfxD3D9 BEGIN
procedure TG2GfxD3D9.SetRenderTarget(const Value: TG2Texture2DRT);
begin
  if _RenderTarget <> Value then
  begin
    _RenderTarget := Value;
    if _RenderTarget = nil then
    begin
      _Device.SetRenderTarget(0, _DefRenderTarget);
      SizeRT.x := g2.Params.Width;
      SizeRT.y := g2.Params.Height;
    end
    else
    begin
      _Device.SetRenderTarget(0, _RenderTarget._Surface);
      SizeRT.x := _RenderTarget.RealWidth;
      SizeRT.y := _RenderTarget.RealHeight;
    end;
  end;
end;

procedure TG2GfxD3D9.SetBlendMode(const Value: TG2BlendMode);
  var be: Boolean;
  var bs: Boolean absolute be;
  const BlendMap: array[0..10] of TG2IntU32 = (
    D3DBLEND_ZERO,
    D3DBLEND_ZERO,
    D3DBLEND_ONE,
    D3DBLEND_SRCCOLOR,
    D3DBLEND_INVSRCCOLOR,
    D3DBLEND_DESTCOLOR,
    D3DBLEND_INVDESTCOLOR,
    D3DBLEND_SRCALPHA,
    D3DBLEND_INVSRCALPHA,
    D3DBLEND_DESTALPHA,
    D3DBLEND_INVDESTALPHA
  );
begin
  if _BlendMode <> Value then
  begin
    _BlendMode := Value;
    be := _BlendMode.BlendEnable;
    if be <> _BlendEnable then
    begin
      _BlendEnable := be;
      if _BlendEnable then
      _Device.SetRenderState(D3DRS_ALPHABLENDENABLE, 1)
      else
      _Device.SetRenderState(D3DRS_ALPHABLENDENABLE, 0);
    end;
    bs := _BlendMode.BlendSeparate and _BlendEnable;
    if bs <> _BlendSeparate then
    begin
      _BlendSeparate := bs;
      if _BlendSeparate then
      _Device.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, 1)
      else
      _Device.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, 0);
    end;
    if _BlendEnable then
    begin
      _Device.SetRenderState(D3DRS_SRCBLEND, BlendMap[TG2IntU8(_BlendMode.ColorSrc)]);
      _Device.SetRenderState(D3DRS_DESTBLEND, BlendMap[TG2IntU8(_BlendMode.ColorDst)]);
      if _BlendSeparate then
      begin
        _Device.SetRenderState(D3DRS_SRCBLENDALPHA, BlendMap[TG2IntU8(_BlendMode.AlphaSrc)]);
        _Device.SetRenderState(D3DRS_DESTBLENDALPHA, BlendMap[TG2IntU8(_BlendMode.AlphaDst)]);
      end;
    end
    else
    begin
      _Device.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ONE);
      _Device.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ZERO);
    end;
  end;
end;

procedure TG2GfxD3D9.SetFilter(const Value: TG2Filter);
begin
  if _Filter <> Value then
  begin
    _Filter := Value;
    case _Filter of
      tfPoint:
      begin
        _Device.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_POINT);
        _Device.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_POINT);
        _Device.SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_POINT);
      end;
      tfLinear:
      begin
        _Device.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
        _Device.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
        _Device.SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);
      end;
    end;
  end;
end;

procedure TG2GfxD3D9.SetCullMode(const Value: TG2CullMode);
  const CullModeRemap: array[0..2] of TG2IntU32 = (
    D3DCULL_NONE,
    D3DCULL_CCW,
    D3DCULL_CW
  );
begin
  if _CullMode = Value then Exit;
  _CullMode := Value;
  _Device.SetRenderState(D3DRS_CULLMODE, CullModeRemap[TG2IntU8(_CullMode)]);
end;

procedure TG2GfxD3D9.SetScissor(const Value: PRect);
begin
  if Value <> nil then
  begin
    _Device.SetRenderState(D3DRS_SCISSORTESTENABLE, 1);
    _Device.SetScissorRect(Value);
  end
  else
  _Device.SetRenderState(D3DRS_SCISSORTESTENABLE, 0);
end;

procedure TG2GfxD3D9.SetDepthEnable(const Value: Boolean);
begin
  if Value = _DepthEnable then Exit;
  _DepthEnable := Value;
  _Device.SetRenderState(D3DRS_ZENABLE, TG2IntU32(Value));
  if _DepthEnable then
  _Device.SetDepthStencilSurface(_DefDepthStencil)
  else
  _Device.SetDepthStencilSurface(nil);
end;

procedure TG2GfxD3D9.SetDepthWriteEnable(const Value: Boolean);
begin
  if Value = _DepthWriteEnable then Exit;
  _DepthWriteEnable := Value;
  _Device.SetRenderState(D3DRS_ZWRITEENABLE, TG2IntU32(Value));
end;

procedure TG2GfxD3D9.SetVertexBuffer(const Value: TG2VertexBuffer);
begin
  if _VertexBuffer = Value then Exit;
  _VertexBuffer := Value;
  if _VertexBuffer <> nil then _VertexBuffer.Bind;
end;

procedure TG2GfxD3D9.SetIndexBuffer(const Value: TG2IndexBuffer);
begin
  if _IndexBuffer  = Value then Exit;
  _IndexBuffer := Value;
  if _IndexBuffer <> nil then _IndexBuffer.Bind;
end;

{$if defined(G2RM_SM2)}
procedure TG2GfxD3D9.SetShaderMethod(const Value: PG2ShaderMethod);
begin
  if Value = _ShaderMethod then Exit;
  _ShaderMethod := Value;
  if _ShaderMethod = nil then
  begin
    _Device.SetVertexShader(nil);
    _Device.SetPixelShader(nil);
  end
  else
  begin
    _Device.SetVertexShader(_ShaderMethod^.VertexShader^.Prog);
    _Device.SetPixelShader(_ShaderMethod^.PixelShader^.Prog);
  end;
end;
{$endif}

procedure TG2GfxD3D9.Resize(const OldWidth, OldHeight, NewWidth, NewHeight: TG2IntS32);
  var Viewport: TD3DViewport9;
  var PrevDepthStencil: IDirect3DSurface9;
begin
  inherited Resize(OldWidth, OldHeight, NewWidth, NewHeight);
  _Device.GetViewport(Viewport);
  _Device.SetRenderTarget(0, nil);
  _Device.GetDepthStencilSurface(PrevDepthStencil);
  SafeRelease(_DefRenderTarget);
  SafeRelease(_DefSwapChain);
  _PresentParameters.BackBufferWidth := NewWidth;
  _PresentParameters.BackBufferHeight := NewHeight;
  _Device.CreateAdditionalSwapChain(_PresentParameters, _DefSwapChain);
  _DefSwapChain.GetBackBuffer(0, D3DBACKBUFFER_TYPE_MONO, _DefRenderTarget);
  _Device.SetRenderTarget(0, _DefRenderTarget);
  _Device.SetDepthStencilSurface(PrevDepthStencil);
  Viewport.Width := NewWidth;
  Viewport.Height := NewHeight;
  _Device.SetViewport(Viewport);
end;

procedure TG2GfxD3D9.Initialize;
  var Viewport: TD3DViewport9;
begin
  ZeroMemory(@_PresentParameters, SizeOf(_PresentParameters));
  _PresentParameters.BackBufferWidth := 1;
  _PresentParameters.BackBufferHeight := 1;
  _PresentParameters.BackBufferFormat := D3DFMT_X8R8G8B8;
  _PresentParameters.BackBufferCount := 1;
  _PresentParameters.MultiSampleType := D3DMULTISAMPLE_NONE;
  _PresentParameters.SwapEffect := D3DSWAPEFFECT_DISCARD;
  _PresentParameters.hDeviceWindow := g2.Window.Handle;
  _PresentParameters.Windowed := True;
  _PresentParameters.EnableAutoDepthStencil := False;
  _PresentParameters.AutoDepthStencilFormat := D3DFMT_D16;
  _PresentParameters.PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
  _D3D9.CreateDevice(
    0, D3DDEVTYPE_HAL,
    g2.Window.Handle,
    D3DCREATE_HARDWARE_VERTEXPROCESSING
    or D3DCREATE_MULTITHREADED,
    @_PresentParameters,
    _Device
  );
  _PresentParameters.BackBufferWidth := g2.Params.Width;
  _PresentParameters.BackBufferHeight := g2.Params.Height;
  _Device.CreateAdditionalSwapChain(_PresentParameters, _DefSwapChain);
  _DefSwapChain.GetBackBuffer(0, D3DBACKBUFFER_TYPE_MONO, _DefRenderTarget);
  _Device.SetRenderTarget(0, _DefRenderTarget);
  _Device.CreateDepthStencilSurface(
    G2Max(2048, g2.Params.Width),
    G2Max(2048, g2.Params.Height),
    D3DFMT_D16,
    D3DMULTISAMPLE_NONE,
    0,
    True,
    _DefDepthStencil,
    nil
  );
  _Device.GetViewport(Viewport);
  Viewport.Width := g2.Params.Width;
  Viewport.Height := g2.Params.Height;
  _Device.SetViewport(Viewport);
  SizeRT.x := g2.Params.Width;
  SizeRT.y := g2.Params.Height;
  _Device.SetRenderState(D3DRS_NORMALIZENORMALS, 1);
  _Device.SetRenderState(D3DRS_LIGHTING, 0);
  _Device.SetRenderState(D3DRS_ALPHABLENDENABLE, 1);
  _Device.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
  _Device.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
  _Device.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, 0);
  _Device.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
  _Device.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
  _Device.SetRenderState(D3DRS_SRCBLENDALPHA, D3DBLEND_ONE);
  _Device.SetRenderState(D3DRS_DESTBLENDALPHA, D3DBLEND_ONE);
  _Device.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
  _Device.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_DIFFUSE);
  _Device.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_TEXTURE);
  _Device.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
  _Device.SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_DIFFUSE);
  _Device.SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_TEXTURE);
  inherited Initialize;
end;

procedure TG2GfxD3D9.Finalize;
begin
  inherited Finalize;
  {$if defined(G2RM_SM2)}
  FreeShaders;
  {$endif}
  SafeRelease(_DefDepthStencil);
  SafeRelease(_DefRenderTarget);
  SafeRelease(_Device);
end;

procedure TG2GfxD3D9.Render;
begin
  _Device.BeginScene;
  ProcessRenderQueue;
  SetDepthEnable(True);
  _Device.EndScene;
  _DefSwapChain.Present(nil, nil, 0, nil, 0);
end;

procedure TG2GfxD3D9.Clear(
  const Color: Boolean; const ColorValue: TG2Color;
  const Depth: Boolean; const DepthValue: TG2Float;
  const Stencil: Boolean; const StencilValue: TG2IntU8
);
  var Target: TG2IntU32;
begin
  if Color then Target := D3DCLEAR_TARGET else Target := 0;
  if Depth and _DepthEnable then Target := Target or D3DCLEAR_ZBUFFER;
  if Stencil then Target := Target or D3DCLEAR_STENCIL;
  _Device.Clear(0, nil, Target, TD3DColor(ColorValue), DepthValue, StencilValue);
end;

constructor TG2GfxD3D9.Create;
begin
  inherited Create;
  _D3D9 := Direct3DCreate9(D3D_SDK_VERSION);
  _D3D9.GetDeviceCaps(0, D3DDEVTYPE_HAL, Caps);
end;

destructor TG2GfxD3D9.Destroy;
begin
  SafeRelease(_D3D9);
  inherited Destroy;
end;
//TG2GfxD3D9 END
{$endif}

{$ifdef G2Gfx_OGL}
//TG2GfxOGL BEGIN
procedure TG2GfxOGL.SetRenderTarget(const Value: TG2Texture2DRT);
  var RTMode: TG2TexRTMode;
begin
  if _RenderTarget <> Value then
  begin
    if (_RenderTarget <> nil) then
    begin
      RTMode := _RenderTarget._Mode;
      if RTMode = rtmFBO then
      begin
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, 0, 0);
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
      end
      else if RTMode = rtmPBuffer then
      begin
        glBindTexture(GL_TEXTURE_2D, _RenderTarget._Texture);
        glCopyTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0, _RenderTarget.RealWidth, _RenderTarget.RealHeight);
        {$ifdef G2Target_OSX}
        aglSwapBuffers(_RenderTarget._PBufferContext);
        {$endif}
      end;
    end
    else
    RTMode := rtmNone;
    _RenderTarget := Value;
    if _RenderTarget = nil then
    begin
      if RTMode = rtmFBO then
      SetDefaults
      else if RTMode = rtmPBuffer then
      {$if defined(G2Target_Windows)}
      wglMakeCurrent(_DC, _Context);
      {$elseif defined(G2Target_Linux)}
      glXMakeCurrent(g2.Window.Display, g2.Window.Handle, _Context);
      {$elseif defined(G2Target_OSX)}
      aglSetCurrentContext(_Context);
      {$endif}
      SizeRT.x := g2.Params.Width;
      SizeRT.y := g2.Params.Height;
    end
    else
    begin
      if _RenderTarget._Mode = rtmFBO then
      begin
        glBindFramebuffer(GL_FRAMEBUFFER, _RenderTarget._FrameBuffer);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _RenderTarget._Texture, 0);
        SetDefaults;
      end
      else if _RenderTarget._Mode = rtmPBuffer then
      begin
        {$if defined(G2Target_Windows)}
        wglMakeCurrent(_RenderTarget._PBufferDC, _RenderTarget._PBufferRC);
        {$elseif defined(G2Target_Linux)}
        glXMakeCurrent(g2.Window.Display, _RenderTarget._PBuffer, _RenderTarget._PBufferContext);
        {$elseif defined(G2Target_OSX)}
        aglSetCurrentContext(_RenderTarget._PBufferContext);
        aglSetPBuffer(_RenderTarget._PBufferContext, _RenderTarget._PBuffer, 0, 0, aglGetVirtualScreen(_Context));
        {$endif}
        SetDefaults;
      end;
      SizeRT.x := _RenderTarget.RealWidth;
      SizeRT.y := _RenderTarget.RealHeight;
    end;
  end;
end;

procedure TG2GfxOGL.SetBlendMode(const Value: TG2BlendMode);
  var be: Boolean;
  const BlendMap: array[0..10] of TGLEnum = (
    GL_ZERO,
    GL_ZERO,
    GL_ONE,
    GL_SRC_COLOR,
    GL_ONE_MINUS_SRC_COLOR,
    GL_DST_COLOR,
    GL_ONE_MINUS_DST_COLOR,
    GL_SRC_ALPHA,
    GL_ONE_MINUS_SRC_ALPHA,
    GL_DST_ALPHA,
    GL_ONE_MINUS_DST_ALPHA
  );
begin
  if _BlendMode <> Value then
  begin
    _BlendMode := Value;
    be := _BlendMode.BlendEnable;
    if be <> _BlendEnable then
    begin
      _BlendEnable := be;
      if _BlendEnable then
      glEnable(GL_BLEND)
      else
      glDisable(GL_BLEND);
    end;
    _BlendSeparate := _BlendMode.BlendSeparate and _BlendEnable;
    if _BlendEnable then
    begin
      if _BlendSeparate then
      glBlendFuncSeparate(
        BlendMap[TG2IntU8(_BlendMode.ColorSrc)], BlendMap[TG2IntU8(_BlendMode.ColorDst)],
        BlendMap[TG2IntU8(_BlendMode.AlphaSrc)], BlendMap[TG2IntU8(_BlendMode.AlphaDst)]
      )
      else
      glBlendFunc(BlendMap[TG2IntU8(_BlendMode.ColorSrc)], BlendMap[TG2IntU8(_BlendMode.ColorDst)]);
    end
    else
    glBlendFunc(GL_ONE, GL_ZERO);
  end;
end;

procedure TG2GfxOGL.SetFilter(const Value: TG2Filter);
begin
  _Filter := Value;
  if _Filter <> tfNone then
  begin
    case _Filter of
      tfPoint:
      begin
        if _EnableMipMaps then
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST)
        else
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
      end;
      tfLinear:
      begin
        if _EnableMipMaps then
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
        else
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      end;
    end;
  end;
end;

procedure TG2GfxOGL.SetCullMode(const Value: TG2CullMode);
begin
  if _CullMode = Value then Exit;
  _CullMode := Value;
  case _CullMode of
    g2cm_none:
    begin
      glDisable(GL_CULL_FACE);
    end;
    g2cm_ccw:
    begin
      glEnable(GL_CULL_FACE);
      glFrontFace(GL_CCW);
    end;
    g2cm_cw:
    begin
      glEnable(GL_CULL_FACE);
      glFrontFace(GL_CW);
    end;
  end;
end;

procedure TG2GfxOGL.SetScissor(const Value: PRect);
begin
  if Value <> nil then
  begin
    glEnable(GL_SCISSOR_TEST);
    glScissor(Value^.Left, g2.Params.Height - Value^.Bottom, Value^.Right - Value^.Left, Value^.Bottom - Value^.Top);
  end
  else
  glDisable(GL_SCISSOR_TEST);
end;

procedure TG2GfxOGL.SetDepthEnable(const Value: Boolean);
begin
  if Value = _DepthEnable then Exit;
  _DepthEnable := Value;
  if _DepthEnable then
  glEnable(GL_DEPTH_TEST)
  else
  glDisable(GL_DEPTH_TEST);
end;

procedure TG2GfxOGL.SetDepthWriteEnable(const Value: Boolean);
begin
  if Value = _DepthWriteEnable then Exit;
  _DepthWriteEnable := Value;
  glDepthMask(_DepthWriteEnable);
end;

procedure TG2GfxOGL.SetVertexBuffer(const Value: TG2VertexBuffer);
begin
  if _VertexBuffer = Value then Exit;
  if _VertexBuffer <> nil then _VertexBuffer.Unbind;
  _VertexBuffer := Value;
  if _VertexBuffer <> nil then _VertexBuffer.Bind;
end;

procedure TG2GfxOGL.SetIndexBuffer(const Value: TG2IndexBuffer);
begin
  if _IndexBuffer = Value then Exit;
  if _IndexBuffer <> nil then _IndexBuffer.Unbind;
  _IndexBuffer := Value;
  if _IndexBuffer <> nil then _IndexBuffer.Bind;
end;

function TG2GfxOGL.GetActiveTexture: TG2IntU8;
begin
  Result := _ActiveTexture - GL_TEXTURE0;
end;

procedure TG2GfxOGL.SetActiveTexture(const Value: TG2IntU8);
  var NewActiveTexture: TGLenum;
begin
  NewActiveTexture := GL_TEXTURE0 + Value;
  if NewActiveTexture = _ActiveTexture then Exit;
  _ActiveTexture := NewActiveTexture;
  glActiveTexture(_ActiveTexture);
end;

function TG2GfxOGL.GetClientActiveTexture: TG2IntU8;
begin
  Result := _ClientActiveTexture - GL_TEXTURE0;
end;

procedure TG2GfxOGL.SetClientActiveTexture(const Value: TG2IntU8);
  var NewActiveTexture: TGLenum;
begin
  NewActiveTexture := GL_TEXTURE0 + Value;
  if NewActiveTexture = _ClientActiveTexture then Exit;
  _ClientActiveTexture := NewActiveTexture;
  glClientActiveTexture(_ClientActiveTexture);
end;

{$if defined(G2RM_SM2)}
procedure TG2GfxOGL.SetShaderMethod(const Value: PG2ShaderMethod);
begin
  if Value = _ShaderMethod then Exit;
  _ShaderMethod := Value;
  glUseProgram(_ShaderMethod^.ShaderProgram);
end;
{$endif}

procedure TG2GfxOGL.Resize(const OldWidth, OldHeight, NewWidth, NewHeight: TG2IntS32);
begin
  inherited Resize(OldWidth, OldHeight, NewWidth, NewHeight);
  glViewport(0, 0, NewWidth, NewHeight);
end;

procedure TG2GfxOGL.Initialize;
  {$if defined(G2Target_Windows)}
  var pfd: TPixelFormatDescriptor;
  var pf: TG2IntS32;
  {$elseif defined(G2Target_Linux)}
  {$elseif defined(G2Target_OSX)}
  var OglAttribs: array[0..5] of TG2IntS32;
  var PixelFormat: TAGLPixelFormat;
  {$endif}
begin
  {$if defined(G2Threading)}
  _ThreadLock.Initialize;
  _ThreadID := 0;
  _ThreadRef := 0;
  {$endif}
  {$if defined(G2Target_Windows)}
  FillChar(pfd, SizeOf(pfd), 0);
  pfd.nSize := SizeOf(pfd);
  pfd.nVersion := 1;
  pfd.dwFlags := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  pfd.iPixelType := PFD_TYPE_RGBA;
  pfd.cColorBits := 24;
  pfd.cAlphaBits := 8;
  pfd.cDepthBits := 16;
  pfd.iLayerType := PFD_MAIN_PLANE;
  _DC := GetDC(g2.Window.Handle);
  pf := ChoosePixelFormat(_DC, @pfd);
  SetPixelFormat(_DC, pf, @pfd);
  _Context := wglCreateContext(_DC);
  {$elseif defined(G2Target_Linux)}
  _Context := glXCreateContext(g2.Window.Display, g2.Window.VisualInfo, nil, True);
  {$elseif defined(G2Target_OSX)}
  OglAttribs[0] := AGL_RGBA;
  OglAttribs[1] := AGL_DOUBLEBUFFER;
  OglAttribs[2] := AGL_NO_RECOVERY;
  OglAttribs[3] := AGL_DEPTH_SIZE; OglAttribs[4] := 16;
  OglAttribs[5] := AGL_NONE;
  PixelFormat := aglChoosePixelFormat(nil, 0, @OglAttribs);
  _Context := aglCreateContext(PixelFormat, nil);
  aglDestroyPixelFormat(PixelFormat);
  aglSetWindowRef(_Context, g2.Window.Handle);
  {$endif}
  {$if not defined(G2Threading)}
  {$if defined(G2Target_Windows)}
  wglMakeCurrent(_DC, _Context);
  {$elseif defined(G2Target_Linux)}
  glXMakeCurrent(g2.Window.Display, g2.Window.Handle, _Context);
  {$elseif defined(G2Target_OSX)}
  aglSetCurrentContext(_Context);
  {$endif}
  {$endif}
  ThreadAttach;
  InitOpenGL;
  SetDefaults;
  ThreadDetach;
  SizeRT.x := g2.Params.Width;
  SizeRT.y := g2.Params.Height;
  inherited Initialize;
end;

procedure TG2GfxOGL.Finalize;
begin
  inherited Finalize;
  {$if defined(G2RM_FF)}
  ThreadAttach;
  glDeleteTextures(1, @_DummyTex);
  ThreadDetach;
  {$endif}
  {$if not defined(G2Threading)}
  {$if defined(G2Target_Windows)}
  wglMakeCurrent(0, 0);
  {$elseif defined(G2Target_Linux)}
  glXMakeCurrent(g2.Window.Display, 0, nil);
  {$elseif defined(G2Target_OSX)}
  aglSetCurrentContext(0);
  {$endif}
  {$endif}
  UnInitOpenGL;
  {$if defined(G2Target_Windows)}
  wglDeleteContext(_Context);
  ReleaseDC(g2.Window.Handle, _DC);
  {$elseif defined(G2Target_Linux)}
  glXDestroyContext(g2.Window.Display, _Context);
  {$elseif defined(G2Target_OSX)}
  aglDestroyContext(_Context);
  {$endif}
  {$if defined(G2Threading)}
  _ThreadLock.Finalize;
  {$endif}
end;

procedure TG2GfxOGL.Render;
begin
  ThreadAttach;
  ProcessRenderQueue;
  {$if defined(G2Target_Windows)}
  SwapBuffers(_DC);
  {$elseif defined(G2Target_Linux)}
  glXSwapBuffers(g2.Window.Display, g2.Window.Handle);
  {$elseif defined(G2Target_OSX)}
  aglSwapBuffers(_Context);
  {$endif}
  ThreadDetach;
end;

procedure TG2GfxOGL.Clear(
  const Color: Boolean; const ColorValue: TG2Color;
  const Depth: Boolean; const DepthValue: TG2Float;
  const Stencil: Boolean; const StencilValue: TG2IntU8
);
  var Target: TGLbitfield;
begin
  Target := 0;
  if Color then
  begin
    Target := GL_COLOR_BUFFER_BIT;
    glClearColor(ColorValue.r * G2Rcp255, ColorValue.g * G2Rcp255, ColorValue.b * G2Rcp255, ColorValue.a * G2Rcp255);
  end;
  if Depth then
  begin
    Target := Target or GL_DEPTH_BUFFER_BIT;
    glClearDepth(DepthValue);
  end;
  if Stencil then
  begin
    Target := Target or GL_STENCIL_BUFFER_BIT;
    glClearStencil(StencilValue);
  end;
  if Target > 0 then glClear(Target);
end;

procedure TG2GfxOGL.SetProj2D;
  var m: TG2Mat;
begin
  glMatrixMode(GL_PROJECTION);
  if _RenderTarget = nil then
  begin
    m := G2MatOrth2D(g2.Params.Width, g2.Params.Height, 0.1, 1);
    m.e30 := m.e30 + 1 / g2.Params.Width;
  end
  else
  m := G2MatOrth2D(_RenderTarget.RealWidth, _RenderTarget.RealHeight, 0.1, 1, False, False);
  glLoadMatrixf(@m);
end;

procedure TG2GfxOGL.EnableMipMaps(const Value: Boolean);
begin
  if _EnableMipMaps = Value then Exit;
  _EnableMipMaps := Value;
  Filter := Filter;
end;

procedure TG2GfxOGL.SetDefaults;
  {$if defined(G2RM_FF)}
  var TexData: TG2Color;
  {$endif}
begin
  if _RenderTarget = nil then
  glViewport(0, 0, g2.Params.Width, g2.Params.Height)
  else
  glViewport(0, 0, _RenderTarget.RealWidth, _RenderTarget.RealHeight);
  glClearColor(0.5, 0.5, 0.5, 1);
  glClearDepth(1);
  glEnable(GL_TEXTURE_2D);
  {$if defined(G2RM_FF)}
  TexData := $ffffffff;
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  glGenTextures(1, @_DummyTex);
  glBindTexture(GL_TEXTURE_2D, _DummyTex);
  glTexImage2D(
    GL_TEXTURE_2D,
    0,
    GL_RGBA,
    1,
    1,
    0,
    GL_RGBA,
    GL_UNSIGNED_BYTE,
    @TexData
  );
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 0);
  glBindTexture(GL_TEXTURE_2D, 0);
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
  {$endif}
  glShadeModel(GL_SMOOTH);
  glCullFace(GL_FRONT);
  glDisable(GL_CULL_FACE);
  _BlendSeparate := False;
  _BlendEnable := False;
  glDisable(GL_BLEND);
  _BlendMode := bmInvalid;
  BlendMode := bmNormal;
  _EnableMipMaps := False;
  _ActiveTexture := GL_TEXTURE0;
  _ClientActiveTexture := GL_TEXTURE0;
end;

procedure TG2GfxOGL.ThreadAttach;
begin
  {$if defined(G2Threading)}
  if _ThreadID = GetCurrentThreadID then
  begin
    Inc(_ThreadRef);
    Exit;
  end;
  _ThreadLock.Enter;
  _ThreadID := GetCurrentThreadID;
  {$if defined(G2Target_Windows)}
  wglMakeCurrent(_DC, _Context);
  {$elseif defined(G2Target_Linux)}
  glXMakeCurrent(g2.Window.Display, g2.Window.Handle, _Context);
  {$elseif defined(G2Target_OSX)}
  aglSetCurrentContext(_Context);
  {$endif}
  _ThreadRef := 1;
  {$endif}
end;

procedure TG2GfxOGL.ThreadDetach;
begin
  {$if defined(G2Threading)}
  if _ThreadID = GetCurrentThreadID then
  begin
    Dec(_ThreadRef);
    if _ThreadRef = 0 then
    begin
      {$if defined(G2Target_Windows)}
      wglMakeCurrent(0, 0);
      {$elseif defined(G2Target_Linux)}
      glXMakeCurrent(g2.Window.Display, 0, 0);
      {$elseif defined(G2Target_OSX)}
      aglSetCurrentContext(0);
      {$endif}
      _ThreadID := 0;
      _ThreadLock.leave;
    end;
  end;
  {$endif}
end;

constructor TG2GfxOGL.Create;
begin
  inherited Create;
end;

destructor TG2GfxOGL.Destroy;
begin
  inherited Destroy;
end;
//TG2GfxOGL END
{$endif}

{$ifdef G2Gfx_GLES}
//TG2GfxGLES BEGIN
procedure TG2GfxGLES.SetRenderTarget(const Value: TG2Texture2DRT);
begin
  if _RenderTarget <> Value then
  begin
    if (_RenderTarget <> nil) then
    begin
      glFramebufferTexture2D(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, 0, 0);
      glBindFramebuffer(GL_FRAMEBUFFER_OES, 0);
    end;
    _RenderTarget := Value;
    if _RenderTarget = nil then
    begin
      SetDefaults;
    end
    else
    begin
      glBindFramebuffer(GL_FRAMEBUFFER_OES, _RenderTarget._FrameBuffer);
      glFramebufferTexture2D(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, _RenderTarget._Texture, 0);
      SetDefaults;
    end;
  end;
end;

procedure TG2GfxGLES.SetBlendMode(const Value: TG2BlendMode);
  var be: Boolean;
  const BlendMap: array[0..10] of TGLEnum = (
    GL_ZERO,
    GL_ZERO,
    GL_ONE,
    GL_SRC_COLOR,
    GL_ONE_MINUS_SRC_COLOR,
    GL_DST_COLOR,
    GL_ONE_MINUS_DST_COLOR,
    GL_SRC_ALPHA,
    GL_ONE_MINUS_SRC_ALPHA,
    GL_DST_ALPHA,
    GL_ONE_MINUS_DST_ALPHA
  );
begin
  if _BlendMode <> Value then
  begin
    _BlendMode := Value;
    be := _BlendMode.BlendEnable;
    if be <> _BlendEnable then
    begin
      _BlendEnable := be;
      if _BlendEnable then
      glEnable(GL_BLEND)
      else
      glDisable(GL_BLEND);
    end;
    _BlendSeparate := _BlendMode.BlendSeparate and _BlendEnable;
    if _BlendEnable then
    begin
      {if _BlendSeparate then
      glBlendFuncSeparate(
        BlendMap[IntU8(_BlendMode.ColorSrc)], BlendMap[IntU8(_BlendMode.ColorDst)],
        BlendMap[IntU8(_BlendMode.AlphaSrc)], BlendMap[IntU8(_BlendMode.AlphaDst)]
      )
      else}
      glBlendFunc(BlendMap[TG2IntU8(_BlendMode.ColorSrc)], BlendMap[TG2IntU8(_BlendMode.ColorDst)]);
    end
    else
    glBlendFunc(GL_ONE, GL_ZERO);
  end;
end;

procedure TG2GfxGLES.SetFilter(const Value: TG2Filter);
begin
  _Filter := Value;
  if _Filter <> tfNone then
  begin
    case _Filter of
      tfPoint:
      begin
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
      end;
      tfLinear:
      begin
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      end;
    end;
  end;
end;

procedure TG2GfxOGL.SetCullMode(const Value: TG2CullMode);
begin
  if _CullMode = Value then Exit;
  _CullMode := Value;
  case _CullMode of
    g2cm_none:
    begin
      glDisable(GL_CULL_FACE);
    end;
    g2cm_ccw:
    begin
      glEnable(GL_CULL_FACE);
      glFrontFace(GL_CCW);
    end;
    g2cm_cw:
    begin
      glEnable(GL_CULL_FACE);
      glFrontFace(GL_CW);
    end;
  end;
end;

procedure TG2GfxGLES.SetScissor(const Value: PRect);
begin
  if Value <> nil then
  begin
    glEnable(GL_SCISSOR_TEST);
    glScissor(Value^.Left, g2.Params.Height - Value^.Bottom, Value^.Right - Value^.Left, Value^.Bottom - Value^.Top);
  end
  else
  glDisable(GL_SCISSOR_TEST);
end;

procedure TG2GfxGLES.SetDepthEnable(const Value: Boolean);
begin
  if Value = _DepthEnable then Exit;
  _DepthEnable := Value;
  if _DepthEnable then
  glEnable(GL_DEPTH_TEST)
  else
  glDisable(GL_DEPTH_TEST);
end;

procedure TG2GfxGLES.SetDepthWriteEnable(const Value: Boolean);
begin
  if Value = _DepthWriteEnable then Exit;
  _DepthWriteEnable := Value;
  glDepthMask(_DepthWriteEnable);
end;

procedure TG2GfxGLES.Initialize;
  {$if defined(G2Target_iOS)}
  var FrameBuffer: GLUInt;
  {$endif}
begin
  {$if defined(G2Target_Android)}
  InitOpenGLES;
  {$elseif defined(G2Target_iOS)}
  _EAGLLayer := CAEAGLLayer(g2.Delegate.View.layer);
  _EAGLLayer.setOpaque(True);
  _EAGLLayer.setDrawableProperties(
    NSDictionary.dictionaryWithObjectsAndKeys(
      NSNumber.numberWithBool(False),
      G2NSStr('kEAGLDrawablePropertyRetainedBacking'),
      G2NSStr('kEAGLColorFormatRGBA8'),
      G2NSStr('kEAGLDrawablePropertyColorFormat'),
      nil
    )
  );
  _Context := EAGLContext.alloc.initWithAPI(kEAGLRenderingAPIOpenGLES1);
  EAGLContext.setCurrentContext(_Context);
  glGenRenderbuffers(1, @_RenderBuffer);
  glBindRenderbuffer(GL_RENDERBUFFER, _RenderBuffer);
  _Context.renderbufferStorage_fromDrawable(GL_RENDERBUFFER, _EAGLLayer);
  glGenFramebuffers(1, @FrameBuffer);
  glBindFramebuffer(GL_FRAMEBUFFER, FrameBuffer);
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _RenderBuffer);
  {$endif}
  SetDefaults;
  inherited Initialize;
end;

procedure TG2GfxGLES.Finalize;
begin
  {$if defined(G2Target_iOS)}

  {$elseif defined(G2Target_Android)}
  UnInitOpenGLES;
  {$endif}
  inherited Finalize;
end;

procedure TG2GfxGLES.Render;
begin
  ProcessRenderQueue;
  {$if defined(G2Target_iOS)}
  _Context.presentRenderbuffer(GL_RENDERBUFFER);
  {$endif}
end;

procedure TG2GfxGLES.Clear(
  const Color: Boolean; const ColorValue: TG2Color;
  const Depth: Boolean; const DepthValue: TG2Float;
  const Stencil: Boolean; const StencilValue: TG2IntU8
);
  var Target: TGLbitfield;
begin
  Target := 0;
  if Color then
  begin
    Target := GL_COLOR_BUFFER_BIT;
    glClearColor(ColorValue.r * G2Rcp255, ColorValue.g * G2Rcp255, ColorValue.b * G2Rcp255, ColorValue.a * G2Rcp255);
  end;
  if Depth then
  begin
    Target := Target or GL_DEPTH_BUFFER_BIT;
    glClearDepthf(DepthValue);
  end;
  if Stencil then
  begin
    Target := Target or GL_STENCIL_BUFFER_BIT;
    glClearStencil(StencilValue);
  end;
  if Target > 0 then glClear(Target);
end;

procedure TG2GfxGLES.SetProj2D;
  var m: TG2Mat;
begin
  glMatrixMode(GL_PROJECTION);
  if _RenderTarget = nil then
  m := G2MatOrth2D(g2.Params.Width, g2.Params.Height, 0, 1)
  else
  m := G2MatOrth2D(_RenderTarget.RealWidth, _RenderTarget.RealHeight, 0, 1, False, False);
  glLoadMatrixf(@m);
end;

procedure TG2GfxGLES.SetDefaults;
begin
  if _RenderTarget = nil then
  glViewport(0, 0, g2.Params.Width, g2.Params.Height)
  else
  glViewport(0, 0, _RenderTarget.RealWidth, _RenderTarget.RealHeight);
  glClearColor(0.5, 0.5, 0.5, 1);
  glClearDepthf(1);
  glEnable(GL_TEXTURE_2D);
  glShadeModel(GL_SMOOTH);
  glCullFace(GL_FRONT);
  glDisable(GL_CULL_FACE);
  _BlendSeparate := False;
  _BlendEnable := False;
  glEnable(GL_BLEND);
  _BlendMode := bmInvalid;
  BlendMode := bmNormal;
end;

procedure TG2GfxGLES.SwapBlendMode;
  var bm: TG2BlendMode;
begin
  bm := _BlendMode;
  bm.SwapColorAlpha;
  BlendMode := bm;
end;

procedure TG2GfxGLES.MaskAll;
begin
  glColorMask(True, True, True, True);
end;

procedure TG2GfxGLES.MaskColor;
begin
  glColorMask(True, True, True, False);
end;

procedure TG2GfxGLES.MaskAlpha;
begin
  glColorMask(False, False, False, True);
end;

constructor TG2GfxGLES.Create;
begin
  inherited Create;
end;

destructor TG2GfxGLES.Destroy;
begin
  inherited Destroy;
end;
//TG2GfxGLES END
{$endif}

//TG2TextAsset BEGIN
procedure TG2TextAsset.Initialize;
begin
  inherited Initialize;
  _Lines := TStringList.Create;
end;

procedure TG2TextAsset.Finalize;
begin
  _Lines.Free;
  inherited Finalize;
end;

class function TG2TextAsset.SharedAsset(const SharedAssetName: String): TG2TextAsset;
  var Res: TG2Res;
  var dm: TG2DataManager;
begin
  Res := TG2Res.List;
  while Res <> nil do
  begin
    if (Res is TG2TextAsset)
    and (TG2TextAsset(Res).AssetName = SharedAssetName)
    and (Res.RefCount > 0) then
    begin
      Result := TG2TextAsset(Res);
      Exit;
    end;
    Res := Res.Next;
  end;
  dm := TG2DataManager.Create(SharedAssetName, dmAsset);
  Result := TG2TextAsset.Create;
  Result.AssetName := SharedAssetName;
  Result.Load(dm);
  dm.Free;
end;

function TG2TextAsset.Load(const FileName: String): Boolean;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

function TG2TextAsset.Load(const Stream: TStream): Boolean;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Stream);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

function TG2TextAsset.Load(const Buffer: Pointer; const Size: TG2IntS32): Boolean;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Buffer, Size);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

function TG2TextAsset.Load(const DataManager: TG2DataManager): Boolean;
  var Buffer: array of AnsiChar;
begin
  SetLength(Buffer, DataManager.Size + 1);
  DataManager.ReadBuffer(@Buffer[0], DataManager.Size);
  Buffer[DataManager.Size] := #0;
  _Lines.SetText(@Buffer[0]);
end;
//TG2TextAsset END

//TG2Snd BEGIN
constructor TG2Snd.Create;
begin
  inherited Create;
end;

destructor TG2Snd.Destroy;
begin
  inherited Destroy;
end;
//TG2Snd END

{$ifdef G2Snd_OAL}
//TG2SndOAL BEGIN
procedure TG2SndOAL.SetListenerPos(const Value: TG2Vec3);
  var v: TG2Vec3;
begin
  _ListenerPos := Value;
  v.x := _ListenerPos.x; v.y := _ListenerPos.y; v.z := -_ListenerPos.z;
  alListenerfv(AL_POSITION, @v);
end;

procedure TG2SndOAL.SetListenerVel(const Value: TG2Vec3);
  var v: TG2Vec3;
begin
  _ListenerVel := Value;
  v.x := _ListenerVel.x; v.y := _ListenerVel.y; v.z := -_ListenerVel.z;
  AlListenerfv(AL_VELOCITY, @v);
end;

procedure TG2SndOAL.SetListenerDir(const Value: TG2Vec3);
  var Orientation: array[0..5] of TG2Float;
begin
  _ListenerDir := Value;
  Orientation[0] := _ListenerDir.x;
  Orientation[1] := _ListenerDir.y;
  Orientation[2] := -_ListenerDir.z;
  Orientation[3] := _ListenerUp.x;
  Orientation[4] := _ListenerUp.y;
  Orientation[5] := -_ListenerUp.z;
  AlListenerfv(AL_ORIENTATION, @Orientation);
end;

procedure TG2SndOAL.SetListenerUp(const Value: TG2Vec3);
  var Orientation: array[0..5] of TG2Float;
begin
  _ListenerUp := Value;
  Orientation[0] := _ListenerDir.x;
  Orientation[1] := _ListenerDir.y;
  Orientation[2] := -_ListenerDir.z;
  Orientation[3] := _ListenerUp.x;
  Orientation[4] := _ListenerUp.y;
  Orientation[5] := -_ListenerUp.z;
  AlListenerfv(AL_ORIENTATION, @Orientation);
end;

procedure TG2SndOAL.Initialize;
begin
  _Device := alcOpenDevice(nil);
  _Context := alcCreateContext(_Device, nil);
  alcMakeContextCurrent(_Context);
  ListenerPos := G2Vec3(0, 0, 0);
  ListenerVel := G2Vec3(0, 0, 0);
  ListenerDir := G2Vec3(0, 0, 1);
  ListenerUp := G2Vec3(0, 1, 0);
end;

procedure TG2SndOAL.Finalize;
begin
  alcMakeContextCurrent(nil);
  alcDestroyContext(_Context);
  alcCloseDevice(_Device);
end;
//TG2SndOAL END
{$endif}

{$ifdef G2Snd_DS}
//TG2SndDS BEGIN
procedure TG2SndDS.SetListenerPos(const Value: TG2Vec3);
begin
  _ListenerPos := Value;
  _Listener.SetPosition(_ListenerPos.x, _ListenerPos.y, _ListenerPos.z, DS3D_IMMEDIATE);
end;

procedure TG2SndDS.SetListenerVel(const Value: TG2Vec3);
begin
  _ListenerVel := Value;
  _Listener.SetVelocity(_ListenerVel.x, _ListenerVel.y, _ListenerVel.z, DS3D_IMMEDIATE);
end;

procedure TG2SndDS.SetListenerDir(const Value: TG2Vec3);
begin
  _ListenerDir := Value;
  _Listener.SetOrientation(_ListenerDir.x, _ListenerDir.y, _ListenerDir.z, _ListenerUp.x, _ListenerUp.y, _ListenerUp.z, DS3D_IMMEDIATE);
end;

procedure TG2SndDS.SetListenerUp(const Value: TG2Vec3);
begin
  _ListenerUp := Value;
  _Listener.SetOrientation(_ListenerDir.x, _ListenerDir.y, _ListenerDir.z, _ListenerUp.x, _ListenerUp.y, _ListenerUp.z, DS3D_IMMEDIATE);
end;

procedure TG2SndDS.Initialize;
  var PrimaryBuffer: IDirectSoundBuffer;
  var Desc: TDSBufferDesc;
begin
  CoInitialize(nil);
  DirectSoundCreate8(nil, _Device, nil);
  FillChar(Desc{%H-}, SizeOf(Desc), 0);
  Desc.dwSize := SizeOf(Desc);
  Desc.dwFlags := DSBCAPS_CTRL3D or DSBCAPS_PRIMARYBUFFER;
  _Device.CreateSoundBuffer(Desc, PrimaryBuffer, nil);
  PrimaryBuffer.QueryInterface(IID_IDirectSound3DListener8, _Listener);
  _Device.SetCooperativeLevel(g2.Window.Handle, DSSCL_NORMAL);
  ListenerPos := G2Vec3(0, 0, 0);
  ListenerVel := G2Vec3(0, 0, 0);
  ListenerDir := G2Vec3(0, 0, 1);
  ListenerUp := G2Vec3(0, 1, 0);
  SafeRelease(PrimaryBuffer);
end;

procedure TG2SndDS.Finalize;
begin
  SafeRelease(_Listener);
  SafeRelease(_Device);
  CoUninitialize;
end;
//TG2SndDS END
{$endif}

{$ifdef G2Threading}
//TG2Updater BEGIN
procedure TG2Updater.Execute;
begin
  while not Terminated do
  begin
    g2.OnUpdate;
  end;
end;
//TG2Updater END

//TG2Renderer BEGIN
procedure TG2Renderer.Execute;
begin
  while not Terminated do
  begin
    g2.OnRender;
  end;
end;
//TG2Renderer END
{$endif}

//TG2Mgr BEGIN
//procedure TG2Mgr.FreeItems;
//begin
//  while _Items.Count > 0 do
//  TG2Res(_Items[0]).Free;
//end;
//
//procedure TG2Mgr.ItemAdd(const Item: TG2Res);
//begin
//  _Items.Add(Item);
//end;
//
//procedure TG2Mgr.ItemRemove(const Item: TG2Res);
//begin
//  _Items.Remove(Item);
//end;
//
//constructor TG2Mgr.Create;
//begin
//  inherited Create;
//  _Items.Clear;
//end;
//
//destructor TG2Mgr.Destroy;
//begin
//  FreeItems;
//  inherited Destroy;
//end;
//TG2Mgr END

//TG2TextureBase BEGIN
procedure TG2TextureBase.Release;
begin
  {$if defined(G2Gfx_D3D9)}
  SafeRelease(_Texture);
  {$else}
  if _Texture <> 0 then
  begin
    _Gfx.ThreadAttach;
    glDeleteTextures(1, @_Texture);
    _Gfx.ThreadDetach;
    _Texture := 0;
  end;
  {$endif}
end;

procedure TG2TextureBase.Initialize;
begin
  {$if defined(G2Gfx_D3D9)}
  _Gfx := TG2GfxD3D9(g2.Gfx);
  {$elseif defined(G2Gfx_OGL)}
  _Gfx := TG2GfxOGL(g2.Gfx);
  _Texture := 0;
  {$elseif defined(G2Gfx_GLES)}
  _Gfx := TG2GfxGLES(g2.Gfx);
  _Texture := 0;
  {$endif}
end;

procedure TG2TextureBase.Finalize;
begin
  Release;
end;

function TG2TextureBase.BaseTexture: {$ifdef G2Gfx_D3D9}IDirect3DBaseTexture9{$else}GLUInt{$endif};
begin
  Result := {$ifdef G2Gfx_D3D9}IDirect3DBaseTexture9(_Texture){$else}_Texture{$endif};
end;
//TG2TextureBase END

//TG2Texture2DBase BEGIN
function TG2Texture2DBase.GetTexCoords: TG2Rect;
begin
  Result := G2Rect(0, 0, _SizeTU, _SizeTV);
end;

function TG2Texture2DBase.GetTexture: {$ifdef G2Gfx_D3D9}IDirect3DTexture9{$else}GLUInt{$endif};
begin
  Result := {$ifdef G2Gfx_D3D9}IDirect3DTexture9(_Texture){$else}_Texture{$endif};
end;

function TG2Texture2DBase.CreateImage: TG2Image;
{$if defined(G2Gfx_D3D9)}
  function ImageFromLockedRect(const LockedRect: TD3DLockedRect): TG2Image;
    var i, j: TG2IntS32;
    var p: Pointer;
    var Image: TG2ImagePNG;
    var c: TG2ColorR8G8B8A8;
  begin
    Image := TG2ImagePNG.Create;
    Image.Allocate(G2IF_R8G8B8A8, _Width, _Height);
    for j := 0 to _Height - 1 do
    for i := 0 to _Width - 1 do
    begin
      p := LockedRect.pBits + j * LockedRect.Pitch + i * 4;
      c.b := PG2IntU8(p + 0)^;
      c.g := PG2IntU8(p + 1)^;
      c.r := PG2IntU8(p + 2)^;
      c.a := PG2IntU8(p + 3)^;
      Image.Pixels[i, j] := c;
    end;
    Result := Image;
  end;
  var SurfLock: TD3DLockedRect;
  var RTSurface, TexSurface: IDirect3DSurface9;
begin
  Result := nil;
  if Self is TG2Texture2D then
  begin
    GetTexture.LockRect(0, SurfLock, nil, D3DLOCK_READONLY);
    Result := ImageFromLockedRect(SurfLock);
    GetTexture.UnlockRect(0);
  end
  else if Self is TG2Texture2DRT then
  begin
    GetTexture.GetSurfaceLevel(0, RTSurface);
    _Gfx.Device.CreateOffscreenPlainSurface(
      _RealWidth,
      _RealHeight,
      D3DFMT_A8R8G8B8,
      D3DPOOL_SYSTEMMEM,
      TexSurface,
      nil
    );
    _Gfx.Device.GetRenderTargetData(
      RTSurface,
      TexSurface
    );
    SafeRelease(RTSurface);
    TexSurface.LockRect(SurfLock, nil, D3DLOCK_READONLY);
    Result := ImageFromLockedRect(SurfLock);
    TexSurface.UnlockRect;
    SafeRelease(TexSurface);
  end;
end;
{$elseif defined(G2Gfx_OGL)}
  var TexData, p: Pointer;
  var Image: TG2ImagePNG;
  var i, j: TG2IntS32;
  var c: TG2ColorR8G8B8A8;
begin
  _Gfx.ThreadAttach;
  TexData := G2MemAlloc(_RealWidth * _RealHeight * 4);
  glBindTexture(GL_TEXTURE_2D, _Texture);
  glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE, TexData);
  glBindTexture(GL_TEXTURE_2D, 0);
  Image := TG2ImagePNG.Create;
  Image.Allocate(G2IF_R8G8B8A8, _Width, _Height);
  for j := 0 to _Height - 1 do
  for i := 0 to _Width - 1 do
  begin
    p := TexData + j * _RealWidth * 4 + i * 4;
    c.r := PG2IntU8(p + 0)^;
    c.g := PG2IntU8(p + 1)^;
    c.b := PG2IntU8(p + 2)^;
    c.a := PG2IntU8(p + 3)^;
    Image.Pixels[i, j] := c;
  end;
  G2MemFree(TexData, _RealWidth * _RealHeight * 4);
  Result := Image;
  _Gfx.ThreadDetach;
end;
{$else}
begin
  Result := nil;
end;
{$endif}

procedure TG2Texture2DBase.Save(const dm: TG2DataManager);
  var Image: TG2Image;
begin
  Image := CreateImage;
  Image.Save(dm);
  Image.Free;
end;

procedure TG2Texture2DBase.Save(const FileName: String);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName, dmWrite);
  try
    Save(dm);
  finally
    dm.Free;
  end;
end;
//TG2Texture2DBase END

//TG2Texture2D BEGIN
class function TG2Texture2D.SharedAsset(const SharedAssetName: String; const TextureUsage: TG2TextureUsage): TG2Texture2D;
  var Res: TG2Res;
  var dm: TG2DataManager;
begin
  Res := TG2Res.List;
  while Res <> nil do
  begin
    if (Res is TG2Texture2D)
    and (TG2Texture2D(Res).AssetName = SharedAssetName)
    and (TG2Texture2D(Res).Usage = TextureUsage)
    and (Res.RefCount > 0) then
    begin
      Result := TG2Texture2D(Res);
      Exit;
    end;
    Res := Res.Next;
  end;
  dm := TG2DataManager.Create(SharedAssetName, dmAsset);
  Result := TG2Texture2D.Create;
  Result.AssetName := SharedAssetName;
  Result.Load(dm);
  dm.Free;
end;

function TG2Texture2D.Load(const FileName: String; const TextureUsage: TG2TextureUsage = tuDefault): Boolean;
  var Image: TG2Image;
  var i: TG2IntS32;
begin
  for i := 0 to High(G2ImageFormats) do
  if G2ImageFormats[i].CanLoad(FileName) then
  begin
    Image := G2ImageFormats[i].Create;
    try
      Image.Load(FileName);
      Result := Load(Image, TextureUsage);
    finally
      Image.Free;
    end;
    Exit;
  end;
  Result := False;
end;

function TG2Texture2D.Load(const Stream: TStream; const TextureUsage: TG2TextureUsage = tuDefault): Boolean;
  var Image: TG2Image;
  var i: TG2IntS32;
begin
  for i := 0 to High(G2ImageFormats) do
  if G2ImageFormats[i].CanLoad(Stream) then
  begin
    Image := G2ImageFormats[i].Create;
    try
      Image.Load(Stream);
      Result := Load(Image, TextureUsage);
    finally
      Image.Free;
    end;
    Exit;
  end;
  Result := False;
end;

function TG2Texture2D.Load(const Buffer: Pointer; const Size: TG2IntS32; const TextureUsage: TG2TextureUsage = tuDefault): Boolean;
  var Image: TG2Image;
  var i: TG2IntS32;
begin
  for i := 0 to High(G2ImageFormats) do
  if G2ImageFormats[i].CanLoad(Buffer, Size) then
  begin
    Image := G2ImageFormats[i].Create;
    try
      Image.Load(Buffer, Size);
      Result := Load(Image, TextureUsage);
    finally
      Image.Free;
    end;
    Exit;
  end;
  Result := False;
end;

function TG2Texture2D.Load(const DataManager: TG2DataManager; const TextureUsage: TG2TextureUsage = tuDefault): Boolean;
  var Image: TG2Image;
  var i: TG2IntS32;
begin
  for i := 0 to High(G2ImageFormats) do
  if G2ImageFormats[i].CanLoad(DataManager) then
  begin
    Image := G2ImageFormats[i].Create;
    try
      Image.Load(DataManager);
      Result := Load(Image, TextureUsage);
    finally
      Image.Free;
    end;
    Exit;
  end;
  Result := False;
end;

function TG2Texture2D.Load(const Image: TG2Image; const TextureUsage: TG2TextureUsage = tuDefault): Boolean;
  function MaxMipLevel(const w, h: TG2IntS32): TG2IntS32;
    var rw, rh, mipu, mipv: TG2IntS32;
  begin
    rw := 1;
    rh := 1;
    mipu := 1;
    mipv := 1;
    while rw < w do
    begin
      rw := rw shl 1;
      Inc(mipu);
    end;
    while rh < h do
    begin
      rh := rh shl 1;
      Inc(mipv);
    end;
    if mipu > mipv then Result := mipu else Result := mipv;
  end;
  {$ifdef G2Gfx_D3D9}
  var SurfLock, ParSurfLock: TD3DLockedRect;
  {$else}
  var TexData, MipData, Mip0, Mip1, Ptr: Pointer;
  var px, py, px4: TG2IntS32;
  var ds: TG2IntU32;
  {$endif}
  var op00, op01, op10, op11, oc: TG2IntS32;
  var i, j, x, y, l: TG2IntS32;
  var Levels: TG2IntU32;
begin
  Release;
  _Gfx.ThreadAttach;
  Result := False;
  _Usage := TextureUsage;
  if (Image.Width <= 0) or (Image.Height <= 0) or (Image.Data = nil) then Exit;
  _Width := Image.Width;
  _Height := Image.Height;
  _RealWidth := 1; while _RealWidth < _Width do _RealWidth := _RealWidth shl 1;
  _RealHeight := 1; while _RealHeight < _Height do _RealHeight := _RealHeight shl 1;
  {$if defined(G2Gfx_D3D9)}
  if _Usage = tu3D then
  Levels := MaxMipLevel(_RealWidth, _RealHeight)
  else
  Levels := 1;
  _Gfx.Device.CreateTexture(
    _RealWidth, _RealHeight, Levels, 0,
    D3DFMT_A8R8G8B8, D3DPOOL_MANAGED,
    IDirect3DTexture9(_Texture), nil
  );
  GetTexture.LockRect(0, SurfLock, nil, D3DLOCK_DISCARD);
  case _Usage of
    tuDefault, tu3D:
    begin
      for j := 0 to _RealHeight - 1 do
      for i := 0 to _RealWidth - 1 do
      begin
        x := Round((i / _RealWidth) * _Width);
        y := Round((j / _RealHeight) * _Height);
        PG2IntU8(SurfLock.pBits + j * SurfLock.Pitch + i * 4 + 0)^ := Image.Pixels[x, y].b;
        PG2IntU8(SurfLock.pBits + j * SurfLock.Pitch + i * 4 + 1)^ := Image.Pixels[x, y].g;
        PG2IntU8(SurfLock.pBits + j * SurfLock.Pitch + i * 4 + 2)^ := Image.Pixels[x, y].r;
        PG2IntU8(SurfLock.pBits + j * SurfLock.Pitch + i * 4 + 3)^ := Image.Pixels[x, y].a;
      end;
    end;
    tu2D:
    begin
      for j := 0 to _Height - 1 do
      for i := 0 to _Width - 1 do
      begin
        PG2IntU8(SurfLock.pBits + j * SurfLock.Pitch + i * 4 + 0)^ := Image.Pixels[i, j].b;
        PG2IntU8(SurfLock.pBits + j * SurfLock.Pitch + i * 4 + 1)^ := Image.Pixels[i, j].g;
        PG2IntU8(SurfLock.pBits + j * SurfLock.Pitch + i * 4 + 2)^ := Image.Pixels[i, j].r;
        PG2IntU8(SurfLock.pBits + j * SurfLock.Pitch + i * 4 + 3)^ := Image.Pixels[i, j].a;
      end;
    end;
  end;
  GetTexture.UnlockRect(0);
  if _Usage = tu3D then
  begin
    x := _RealWidth div 2; if x < 1 then x := 1;
    y := _RealHeight div 2; if y < 1 then y := 1;
    for l := 1 to Levels - 1 do
    begin
      GetTexture.LockRect(l - 1, ParSurfLock, nil, D3DLOCK_READONLY);
      GetTexture.LockRect(l, SurfLock, nil, D3DLOCK_DISCARD);
      oc := 0;
      op00 := 0;
      op01 := op00 + ParSurfLock.Pitch;
      for j := 0 to y - 1 do
      begin
        op10 := op00 + 4;
        op11 := op01 + 4;
        for i := 0 to x - 1 do
        begin
          PG2IntU8(SurfLock.pBits + oc + 0)^ := (
            PG2IntU8(ParSurfLock.pBits + op00 + 0)^ +
            PG2IntU8(ParSurfLock.pBits + op10 + 0)^ +
            PG2IntU8(ParSurfLock.pBits + op01 + 0)^ +
            PG2IntU8(ParSurfLock.pBits + op11 + 0)^
          ) div 4;
          PG2IntU8(SurfLock.pBits + oc + 1)^ := (
            PG2IntU8(ParSurfLock.pBits + op00 + 1)^ +
            PG2IntU8(ParSurfLock.pBits + op10 + 1)^ +
            PG2IntU8(ParSurfLock.pBits + op01 + 1)^ +
            PG2IntU8(ParSurfLock.pBits + op11 + 1)^
          ) div 4;
          PG2IntU8(SurfLock.pBits + oc + 2)^ := (
            PG2IntU8(ParSurfLock.pBits + op00 + 2)^ +
            PG2IntU8(ParSurfLock.pBits + op10 + 2)^ +
            PG2IntU8(ParSurfLock.pBits + op01 + 2)^ +
            PG2IntU8(ParSurfLock.pBits + op11 + 2)^
          ) div 4;
          PG2IntU8(SurfLock.pBits + oc + 3)^ := (
            PG2IntU8(ParSurfLock.pBits + op00 + 3)^ +
            PG2IntU8(ParSurfLock.pBits + op10 + 3)^ +
            PG2IntU8(ParSurfLock.pBits + op01 + 3)^ +
            PG2IntU8(ParSurfLock.pBits + op11 + 3)^
          ) div 4;
          oc := oc + 4;
          op00 := op00 + 8;
          op01 := op01 + 8;
          op10 := op10 + 8;
          op11 := op11 + 8;
        end;
        op00 := op00 + ParSurfLock.Pitch;
        op01 := op01 + ParSurfLock.Pitch;
      end;
      x := x div 2; if x < 1 then x := 1;
      y := y div 2; if y < 1 then y := 1;
      GetTexture.UnlockRect(l);
      GetTexture.UnlockRect(l - 1);
    end;
  end;
  {$else}
  GetMem(TexData, _RealWidth * _RealHeight * 4);
  FillChar(TexData^, _RealWidth * _RealHeight * 4, 0);
  case _Usage of
    tuDefault, tu3D:
    begin
      for j := 0 to _RealHeight - 1 do
      for i := 0 to _RealWidth - 1 do
      begin
        x := Round((i / _RealWidth) * _Width);
        y := Round((j / _RealHeight) * _Height);
        PG2IntU8(TexData + (j * _RealWidth + i) * 4 + 0)^ := Image.Pixels[x, y].r;
        PG2IntU8(TexData + (j * _RealWidth + i) * 4 + 1)^ := Image.Pixels[x, y].g;
        PG2IntU8(TexData + (j * _RealWidth + i) * 4 + 2)^ := Image.Pixels[x, y].b;
        PG2IntU8(TexData + (j * _RealWidth + i) * 4 + 3)^ := Image.Pixels[x, y].a;
      end;
    end;
    tu2D:
    begin
      for j := 0 to _Height - 1 do
      for i := 0 to _Width - 1 do
      begin
        PG2IntU8(TexData + (j * _RealWidth + i) * 4 + 0)^ := Image.Pixels[i, j].r;
        PG2IntU8(TexData + (j * _RealWidth + i) * 4 + 1)^ := Image.Pixels[i, j].g;
        PG2IntU8(TexData + (j * _RealWidth + i) * 4 + 2)^ := Image.Pixels[i, j].b;
        PG2IntU8(TexData + (j * _RealWidth + i) * 4 + 3)^ := Image.Pixels[i, j].a;
      end;
    end;
  end;
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  glGenTextures(1, @_Texture);
  glBindTexture(GL_TEXTURE_2D, _Texture);
  glTexImage2D(
    GL_TEXTURE_2D,
    0,
    GL_RGBA,
    _RealWidth,
    _RealHeight,
    0,
    GL_RGBA,
    GL_UNSIGNED_BYTE,
    TexData
  );
  if _Usage = tu3D then
  begin
    Mip0 := TexData;
    px := _RealWidth; py := _RealHeight;
    x := px div 2; if x < 1 then x := 1;
    y := py div 2; if y < 1 then y := 1;
    ds := x * y * 4;
    GetMem(MipData, ds);
    Mip1 := MipData;
    Levels := MaxMipLevel(_RealWidth, _RealHeight);
    for l := 1 to Levels - 1 do
    begin
      oc := 0;
      px4 := px * 4;
      op00 := 0;
      op01 := op00 + px4;
      for j := 0 to y - 1 do
      begin
        op10 := op00 + 4;
        op11 := op01 + 4;
        for i := 0 to x - 1 do
        begin
          PG2IntU8(Mip1 + oc + 0)^ := (
            PG2IntU8(Mip0 + op00 + 0)^ +
            PG2IntU8(Mip0 + op01 + 0)^ +
            PG2IntU8(Mip0 + op10 + 0)^ +
            PG2IntU8(Mip0 + op11 + 0)^
          ) div 4;
          PG2IntU8(Mip1 + oc + 1)^ := (
            PG2IntU8(Mip0 + op00 + 1)^ +
            PG2IntU8(Mip0 + op01 + 1)^ +
            PG2IntU8(Mip0 + op10 + 1)^ +
            PG2IntU8(Mip0 + op11 + 1)^
          ) div 4;
          PG2IntU8(Mip1 + oc + 2)^ := (
            PG2IntU8(Mip0 + op00 + 2)^ +
            PG2IntU8(Mip0 + op01 + 2)^ +
            PG2IntU8(Mip0 + op10 + 2)^ +
            PG2IntU8(Mip0 + op11 + 2)^
          ) div 4;
          PG2IntU8(Mip1 + oc + 3)^ := (
            PG2IntU8(Mip0 + op00 + 3)^ +
            PG2IntU8(Mip0 + op01 + 3)^ +
            PG2IntU8(Mip0 + op10 + 3)^ +
            PG2IntU8(Mip0 + op11 + 3)^
          ) div 4;
          oc := oc + 4;
          op00 := op00 + 8;
          op01 := op01 + 8;
          op10 := op10 + 8;
          op11 := op11 + 8;
        end;
        op00 := op00 + px4;
        op01 := op01 + px4;
      end;
      glTexImage2D(
        GL_TEXTURE_2D,
        l,
        GL_RGBA,
        x,
        y,
        0,
        GL_RGBA,
        GL_UNSIGNED_BYTE,
        Mip1
      );
      Ptr := Mip0;
      Mip0 := Mip1;
      Mip1 := Ptr;
      px := x; py := y;
      x := px div 2; if x < 1 then x := 1;
      y := py div 2; if y < 1 then y := 1;
    end;
    FreeMem(MipData, ds);
  end;
  FreeMem(TexData, _RealWidth * _RealHeight * 4);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  {$if defined(G2Gfx_OGL)}
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_BASE_LEVEL, 0);
  {$endif}
  glBindTexture(GL_TEXTURE_2D, 0);
  {$endif}
  case _Usage of
    tuDefault:
    begin
      _SizeTU := 1;
      _SizeTV := 1;
      {$if defined(G2Gfx_OGL)}
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 0);
      {$endif}
    end;
    tu3D:
    begin
      _SizeTU := 1;
      _SizeTV := 1;
      {$if defined(G2Gfx_OGL)}
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, Levels - 1);
      {$endif}
    end;
    tu2D:
    begin
      _SizeTU := _Width / _RealWidth;
      _SizeTV := _Height / _RealHeight;
      {$if defined(G2Gfx_OGL)}
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAX_LEVEL, 0);
      {$endif}
    end;
  end;
  _Gfx.ThreadDetach;
  Result := True;
end;
//TG2Texture2D END

//TG2Texture2DRT BEGIN
procedure TG2Texture2DRT.Release;
begin
  inherited Release;
  {$if defined(G2Gfx_D3D9)}
  SafeRelease(_Surface);
  {$elseif defined(G2Gfx_OGL)}
  _Gfx.ThreadAttach;
  case _Mode of
    rtmFBO:
    begin
      glDeleteRenderbuffers(1, @_RenderBuffer);
      glDeleteFramebuffers(1, @_FrameBuffer);
    end;
    rtmPBuffer:
    begin
      {$if defined(G2Target_Windows)}
      if (_PBufferRC <> 0) then
      begin
        wglDeleteContext(_PBufferRC);
        _PBufferRC := 0;
      end;
      if (_PBufferDC <> 0) then
      begin
        wglReleasePbufferDC(_PBufferHandle, _PBufferDC);
        _PBufferDC := 0;
      end;
      if (_PBufferHandle <> 0) then
      begin
        wglDestroyPbuffer(_PBufferHandle);
        _PBufferHandle := 0;
      end;
      {$elseif defined(G2Target_Linux)}
      if (_PBufferContext <> nil) then
      begin
        glXDestroyContext(g2.Window.Display, _PBufferContext);
        _PBufferContext := nil;
      end;
      if (_PBuffer <> 0) then
      begin
        glXDestroyPBuffer(g2.Window.Display, _PBuffer);
        _PBuffer := 0;
      end;
      {$elseif defined(G2Target_OSX)}
      if (_PBufferContext <> nil) then
      begin
        aglDestroyContext(_PBufferContext);
        _PBufferContext := nil;
      end;
      if (_PBuffer <> nil) then
      begin
        aglDestroyPBuffer(_PBuffer);
        _PBuffer := nil;
      end;
      {$endif}
    end;
  end;
  _Gfx.ThreadDetach;
  _Mode := rtmNone;
  {$elseif defined(G2Gfx_GLES)}
  _Gfx.ThreadAttach;
  glDeleteRenderbuffers(1, @_RenderBuffer);
  glDeleteFramebuffers(1, @_FrameBuffer);
  _Gfx.ThreadDetach;
  {$endif}
end;

function TG2Texture2DRT.Make(const NewWidth, NewHeight: TG2IntS32): Boolean;
{$ifdef G2Gfx_OGL}
{$if defined(G2Target_Windows)}
  var pbufferiAttr: array[0..21] of TG2IntS32;
  var pbufferfAttr: array[0..3] of TG2Float;
  var pixelFormat: TG2IntS32;
  var nPixelFormat: TG2IntU32;
{$elseif defined(G2Target_Linux)}
  var AttrCount: TG2IntS32;
  var FBConfig: GLXFBConfig;
  var VisualInfo: PXVisualInfo;
  var PBufferAttr: array[0..9] of TG2IntS32;
  var FBConfigAttr: array[0..31] of TG2IntS32;
{$elseif defined(G2Target_OSX)}
  var PBufferAttr: array[0..31] of TG2IntU32;
  var PixelFormat: TAGLPixelFormat;
  var Device: GDHandle;
{$endif}
{$endif}
begin
  Release;
  Result := False;
  _Width := NewWidth;
  _Height := NewHeight;
  _RealWidth := 1; while _RealWidth < _Width do _RealWidth := _RealWidth shl 1;
  _RealHeight := 1; while _RealHeight < _Height do _RealHeight := _RealHeight shl 1;
  {$if defined(G2Gfx_D3D9)}
  _Gfx.Device.CreateTexture(
    _RealWidth, _RealHeight, 1, D3DUSAGE_RENDERTARGET,
    D3DFMT_A8R8G8B8, D3DPOOL_DEFAULT,
    IDirect3DTexture9(_Texture), nil
  );
  IDirect3DTexture9(_Texture).GetSurfaceLevel(0, _Surface);
  {$elseif defined(G2Gfx_OGL)}
  _Gfx.ThreadAttach;
  if gl_FBO_Cap then _Mode := rtmFBO
  else if gl_PBuffer_Cap then _Mode := rtmPBuffer
  else _Mode := rtmNone;
  if (_Mode <> rtmNone) then
  begin
    glGenTextures(1, @_Texture);
    if _Texture = 0 then Exit;
    glBindTexture(GL_TEXTURE_2D, _Texture);
    glTexImage2D(
      GL_TEXTURE_2D,
      0,
      GL_RGBA,
      _RealWidth,
      _RealHeight,
      0,
      GL_RGBA,
      GL_UNSIGNED_BYTE,
      nil
    );
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  end;
  if _Mode = rtmFBO then
  begin
    glGenFramebuffers(1, @_FrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _FrameBuffer);
    glGenRenderbuffers(1, @_RenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _RenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA, _RealWidth, _RealHeight);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _RealWidth, _RealHeight);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _RenderBuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, 0, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
  end
  else if (_Mode = rtmPBuffer) then
  begin
    {$if defined(G2Target_Windows)}
    FillChar(pbufferiAttr, SizeOf(pbufferiAttr), 0);
    FillChar(pbufferfAttr, SizeOf(pbufferfAttr), 0);
    pbufferiAttr[0] := WGL_DRAW_TO_PBUFFER; pbufferiAttr[1] := 1;
    pbufferiAttr[2] := WGL_DOUBLE_BUFFER; pbufferiAttr[3] := 1;
    pbufferiAttr[4] := WGL_COLOR_BITS; pbufferiAttr[5] := 32;
    pbufferiAttr[6] := WGL_RED_BITS; pbufferiAttr[7] := 8;
    pbufferiAttr[8] := WGL_GREEN_BITS; pbufferiAttr[9] := 8;
    pbufferiAttr[10] := WGL_BLUE_BITS; pbufferiAttr[11] := 8;
    pbufferiAttr[12] := WGL_ALPHA_BITS; pbufferiAttr[13] := 8;
    pbufferiAttr[14] := WGL_DEPTH_BITS; pbufferiAttr[15] := 16;
    pbufferiAttr[16] := WGL_STENCIL_BITS; pbufferiAttr[17] := 0;
    if not wglChoosePixelFormat(_Gfx.DC, @pbufferiAttr, @pbufferfAttr, 1, @pixelFormat, @nPixelFormat) then Exit;
    _PBufferHandle := wglCreatePbuffer(_Gfx.DC, pixelFormat, _RealWidth, _RealHeight, nil);
    if _PBufferHandle = 0 then Exit;
    _PBufferDC := wglGetPbufferDC(_PBufferHandle);
    _PBufferRC := wglCreateContext(_PBufferDC);
    wglShareLists(_Gfx.Context, _PBufferRC);
    {$elseif defined(G2Target_Linux)}
    FillChar(PBufferAttr, SizeOf(PBufferAttr), 0);
    FillChar(FBConfigAttr, SizeOf(FBConfigAttr), 0);
    FBConfigAttr[0] := GLX_DRAWABLE_TYPE;
    FBConfigAttr[1] := GLX_PBUFFER_BIT;
    FBConfigAttr[2] := GLX_DOUBLEBUFFER;
    FBConfigAttr[3] := 1;
    FBConfigAttr[4] := GLX_RENDER_TYPE;
    FBConfigAttr[5] := GLX_RGBA_BIT;
    FBConfigAttr[6] := GLX_RED_SIZE;
    FBConfigAttr[7] := 8;
    FBConfigAttr[8] := GLX_GREEN_SIZE;
    FBConfigAttr[9] := 8;
    FBConfigAttr[10] := GLX_BLUE_SIZE;
    FBConfigAttr[11] := 8;
    FBConfigAttr[12] := GLX_ALPHA_SIZE;
    FBConfigAttr[13] := 8;
    FBConfigAttr[14] := GLX_DEPTH_SIZE;
    FBConfigAttr[15] := 16;
    AttrCount := 16;
    FBConfig := glXChooseFBConfig(g2.Window.Display, 0, @FBConfigAttr, @AttrCount);
    PBufferAttr[0] := GLX_PBUFFER_WIDTH;
    PBufferAttr[1] := _RealWidth;
    PBufferAttr[2] := GLX_PBUFFER_HEIGHT;
    PBufferAttr[3] := _RealHeight;
    PBufferAttr[4] := GLX_PRESERVED_CONTENTS;
    PBufferAttr[5] := 1;
    PBufferAttr[6] := GLX_LARGEST_PBUFFER;
    PBufferAttr[7] := 1;
    _PBuffer := glXCreatePBuffer(g2.Window.Display, PG2IntS32(FBConfig)^, @PBufferAttr);
    VisualInfo := glXGetVisualFromFBConfig(g2.Window.Display, PG2IntS32(FBConfig)^);
    _PBufferContext := glXCreateContext(g2.Window.Display, VisualInfo, _Gfx.Context, True);
    XFree(FBConfig);
    XFree(VisualInfo);
    {$elseif defined(G2Target_OSX)}
    FillChar(PBufferAttr, SizeOf(PBufferAttr), 0);
    PBufferAttr[0] := AGL_DOUBLEBUFFER;
    PBufferAttr[1] := AGL_RGBA;
    PBufferAttr[2] := 1;
    PBufferAttr[3] := AGL_RED_SIZE;
    PBufferAttr[4] := 8;
    PBufferAttr[5] := AGL_GREEN_SIZE;
    PBufferAttr[6] := 8;
    PBufferAttr[7] := AGL_BLUE_SIZE;
    PBufferAttr[8] := 8;
    PBufferAttr[9] := AGL_ALPHA_SIZE;
    PBufferAttr[10] := 8;
    PBufferAttr[11] := AGL_DEPTH_SIZE;
    PBufferAttr[12] := 16;
    DMGetGDeviceByDisplayID(DisplayIDType(kCGDirectMainDisplay), Device, False);
    PixelFormat := aglChoosePixelFormat(@Device, 1, @PBufferAttr);
    _PBufferContext := aglCreateContext(PixelFormat, _Gfx.Context);
    aglDestroyPixelFormat(PixelFormat);
    aglCreatePBuffer(_RealWidth, _RealHeight, GL_TEXTURE_2D, GL_RGBA, 0, @_PBuffer);
    {$endif}
  end;
  _Gfx.ThreadDetach;
  {$elseif defined(G2Gfx_GLES)}
  _Gfx.ThreadAttach;
  glGenTextures(1, @_Texture);
  if _Texture = 0 then Exit;
  glBindTexture(GL_TEXTURE_2D, _Texture);
  glTexImage2D(
    GL_TEXTURE_2D,
    0,
    GL_RGBA,
    _RealWidth,
    _RealHeight,
    0,
    GL_RGBA,
    GL_UNSIGNED_BYTE,
    nil
  );
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  glGenFramebuffers(1, @_FrameBuffer);
  glBindFramebuffer(GL_FRAMEBUFFER_OES, _FrameBuffer);
  glGenRenderbuffers(1, @_RenderBuffer);
  glBindRenderbuffer(GL_RENDERBUFFER_OES, _RenderBuffer);
  glRenderbufferStorage(GL_RENDERBUFFER_OES, GL_RGBA, _RealWidth, _RealHeight);
  glRenderbufferStorage(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, _RealWidth, _RealHeight);
  glFramebufferRenderbuffer(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _RenderBuffer);
  glFramebufferTexture2D(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, 0, 0);
  glBindFramebuffer(GL_FRAMEBUFFER_OES, 0);
  _Gfx.ThreadDetach;
  {$endif}
  _SizeTU := _Width / _RealWidth;
  _SizeTV := _Height / _RealHeight;
  Result := True;
end;
//TG2Texture2DRT END

//TG2Atlas BEGIN
constructor TG2Atlas.Create;
begin
  inherited Create;
  Pages.Clear;
  Frames.Clear;
end;

destructor TG2Atlas.Destroy;
begin
  Clear;
  inherited Destroy;
end;

class function TG2Atlas.SharedAsset(const SharedAssetName: String): TG2Atlas;
  var Res: TG2Res;
  var dm: TG2DataManager;
begin
  Res := TG2Res.List;
  while Res <> nil do
  begin
    if (Res is TG2Atlas)
    and (TG2Atlas(Res).AssetName = SharedAssetName)
    and Res.IsReferenced then
    begin
      Result := TG2Atlas(Res);
      Exit;
    end;
    Res := Res.Next;
  end;
  dm := TG2DataManager.Create(SharedAssetName, dmAsset);
  Result := TG2Atlas.Create;
  Result.AssetName := SharedAssetName;
  Result.Load(dm);
  dm.Free;
end;

procedure TG2Atlas.Load(const FileName: String);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Atlas.Load(const DataManager: TG2DataManager);
  var g2ml: TG2ML;
  var FileData: AnsiString;
  var Root: PG2MLObject;
  var i0, i1, i2, i3, i: Integer;
  var n0, n1, n2, n3: PG2MLObject;
  var Page: TG2AtlasPage;
  var Frame: TG2AtlasFrame;
  var sx, sy: Single;
begin
  Clear;
  SetLength(FileData, DataManager.Size);
  DataManager.ReadBuffer(@FileData[1], DataManager.Size);
  g2ml := TG2ML.Create;
  Root := g2ml.Read(FileData);
  for i0 := 0 to Root^.Children.Count - 1 do
  begin
    n0 := Root^.Children[i0];
    if n0^.Name = 'g2af' then
    begin
      for i1 := 0 to n0^.Children.Count - 1 do
      begin
        n1 := n0^.Children[i1];
        if n1^.Name = 'page' then
        begin
          Page := TG2AtlasPage.Create;
          Pages.Add(Page);
          for i2 := 0 to n1^.Children.Count - 1 do
          begin
            n2 := n1^.Children[i2];
            if n2^.Name = 'image' then
            begin
              Page.Texture := TG2Texture2D.SharedAsset(DataManager.Path + n2^.AsString, tu2D);
              Page.Texture.RefInc;
            end
            else if n2^.Name = 'width' then
            begin
              Page.Width := n2^.AsInt;
            end
            else if n2^.Name = 'height' then
            begin
              Page.Height := n2^.AsInt;
            end
            else if n2^.Name = 'frame' then
            begin
              Frame := TG2AtlasFrame.Create;
              Frame.Page := Page;
              Frames.Add(Frame);
              for i3 := 0 to n2^.Children.Count - 1 do
              begin
                n3 := n2^.Children[i3];
                if n3^.Name = 'name' then
                begin
                  Frame.Name := n3^.AsString;
                end
                else if n3^.Name = 'pos_l' then
                begin
                  Frame.PosL := n3^.AsInt;
                end
                else if n3^.Name = 'pos_t' then
                begin
                  Frame.PosT := n3^.AsInt;
                end
                else if n3^.Name = 'width' then
                begin
                  Frame.Width := n3^.AsInt;
                end
                else if n3^.Name = 'height' then
                begin
                  Frame.Height := n3^.AsInt;
                end;
              end;
            end;
          end;
        end;
      end;
      Break;
    end;
  end;
  for i := 0 to Frames.Count - 1 do
  begin
    sx := (1 / Frames[i].Page.Width) * Frames[i].Page.Texture.TexCoords.w;
    sy := (1 / Frames[i].Page.Height) * Frames[i].Page.Texture.TexCoords.h;
    Frames[i].TexCoords := G2Rect(
      Frames[i].PosL * sx, Frames[i].PosT * sy,
      Frames[i].Width * sx, Frames[i].Height * sy
    );
  end;
  g2ml.Free;
end;

type
  TTexturesSorted = specialize TG2QuickSortListG<TG2Texture2DBase>;
  TTextureArr = array[TG2IntU16] of TG2Texture2DBase;
  PTextureArr = ^TTextureArr;
  PImg = ^TImg;
  TImg = record
    Texture: TG2Texture2DBase;
    Alias: PImg;
    Image: TG2Image;
    md5: TG2MD5;
    Frame: TG2AtlasFrame;
    Name: AnsiString;
  end;
  TImgList = specialize TG2QuickListG<PImg>;
  TPagePlacements = record
    Page: TG2AtlasPage;
    Pl: TG2QuickListPoint;
    Rects: array of TRect;
  end;
  PPagePlacements = ^TPagePlacements;
  TPagePlacementsList = specialize TG2QuickListG<PPagePlacements>;
  TPAnsiCharArr = array[TG2IntU16] of PAnsiChar;
  PPAnsiCharArr = ^TPAnsiCharArr;

procedure TG2Atlas.RenderAtlas(
  const TextureArr: PG2Texture2DBase;
  const TextureNames: PPAnsiChar;
  const TextureCount: TG2IntS32;
  const MaxPageWidth: TG2IntS32;
  const MaxPageHeight: TG2IntS32;
  const Spacing: TG2IntS32;
  const TransparentBorders: Boolean;
  const ForcePOT: Boolean;
  const OutTexturesBaked: PG2IntS32
);
  function RectInRect(const R0, R1: TG2Rect): Boolean;
  begin
    Result := (
      (R0.l < R1.r)
      and (R0.r > R1.l)
      and (R0.t < R1.b)
      and (R0.b > R1.t)
    );
  end;
  var Remap: array of Integer;
  var TexturesSorted: TTexturesSorted;
  var PagePl: TPagePlacementsList;
  var pp: PPagePlacements;
  var i, j, pxi, pyi, px, py, pxm, pym, t, rti, w, h: TG2IntS32;
  var ImgList: TImgList;
  var Img: PImg;
  var p: TG2AtlasPage;
  var sc, scm: TG2Float;
  var ps: TG2Vec2;
  var r: TRect;
  var BorderColor: TG2Color;
  var Placed, Hit: Boolean;
  var PrevDepthEnable: Boolean;
  var PrevClipRect: PRect;
  var PrevRenderTarget: TG2Texture2DRT;
  var bm: TG2BlendMode;
begin
  Clear;
  if OutTexturesBaked <> nil then OutTexturesBaked^ := 0;
  if TextureCount <= 0 then Exit;
  rti := 0;
  SetLength(Remap, TextureCount);
  TexturesSorted.Clear;
  for i := 0 to TextureCount - 1 do
  begin
    j := TexturesSorted.Add(
      PTextureArr(TextureArr)^[i],
      -(PTextureArr(TextureArr)^[i].Width * PTextureArr(TextureArr)^[i].Height)
    );
    Remap[j] := i;
  end;
  for i := 0 to TextureCount - 1 do
  begin
    for j := 0 to TexturesSorted.Count - 1 do
    if TexturesSorted[j] = PTextureArr(TextureArr)^[i] then
    begin
      Remap[j] := i;
      Break;
    end;
  end;
  ImgList.Clear;
  for i := 0 to TexturesSorted.Count - 1 do
  begin
    New(Img);
    Img^.Texture := TexturesSorted[i];
    Img^.Alias := nil;
    Img^.Image := Img^.Texture.CreateImage;
    Img^.md5 := G2MD5(PG2IntU8(Img^.Image.Data), Img^.Image.Width * Img^.Image.Height * Img^.Image.BPP);
    Img^.Frame := nil;
    if (TextureNames = nil) then
    begin
      if Img^.Texture is TG2Texture2D then
      Img^.Name := TG2Texture2D(Img^.Texture).AssetName
      else if Img^.Texture is TG2Texture2DRT then
      begin
        Img^.Name := 'rt_' + IntToStr(rti);
        Inc(rti);
      end
      else
      Img^.Name := 'invalid';
    end
    else
    Img^.Name := PPAnsiCharArr(TextureNames)^[Remap[i]];
    ImgList.Add(Img);
  end;
  TexturesSorted.Clear;
  for i := 0 to ImgList.Count - 2 do
  for j := i + 1 to ImgList.Count - 1 do
  if ImgList[i]^.md5 = ImgList[j]^.md5 then
  begin
    Img := ImgList[i];
    while Img^.Alias <> nil do Img := Img^.Alias;
    ImgList[j]^.Alias := Img;
  end;
  PagePl.Clear;
  for i := 0 to ImgList.Count - 1 do
  begin
    Img := ImgList[i];
    if (Img^.Texture.Width + Spacing * 2 > MaxPageWidth)
    or (Img^.Texture.Height + Spacing * 2 > MaxPageHeight) then
    Continue;
    Img^.Frame := TG2AtlasFrame.Create;
    Img^.Frame.Page := nil;
    Img^.Frame.Name := Img^.Name;
    Img^.Frame.Width := Img^.Texture.Width;
    Img^.Frame.Height := Img^.Texture.Height;
    Frames.Add(Img^.Frame);
    if Img^.Alias <> nil then
    begin
      Img^.Frame.Page := Img^.Alias^.Frame.Page;
      Img^.Frame.PosL := Img^.Alias^.Frame.PosL;
      Img^.Frame.PosT := Img^.Alias^.Frame.PosT;
      Continue;
    end;
    scm := 0;
    Placed := False;
    for j := 0 to PagePl.Count - 1 do
    begin
      pp := PagePl[j];
      for pxi := 0 to pp^.Pl.Count - 1 do
      begin
        for pyi := 0 to pp^.Pl.Count - 1 do
        begin
          px := pp^.Pl[pxi].x + Spacing;
          py := pp^.Pl[pyi].y + Spacing;
          r.Left := px - Spacing;
          r.Top := py - Spacing;
          r.Right := px + Img^.Texture.Width + Spacing;
          r.Bottom := py + Img^.Texture.Height + Spacing;
          Hit := False;
          for t := 0 to High(pp^.Rects) do
          if RectInRect(pp^.Rects[t], r) then
          begin
            Hit := True;
            Break;
          end;
          if not Hit then
          begin
            sc := px + py;
            if px + Img^.Texture.Width + Spacing > pp^.Page.Width then sc *= px + Img^.Texture.Width + Spacing;
            if py + Img^.Texture.Height + Spacing > pp^.Page.Height then sc *= py + Img^.Texture.Height + Spacing;
            if not Placed or (sc < scm) then
            begin
              scm := sc;
              pxm := px;
              pym := py;
              Placed := True;
            end;
          end;
        end;
      end;
      if Placed then Break;
    end;
    if not Placed then
    begin
      New(pp);
      pp^.Page := TG2AtlasPage.Create;
      pp^.Page.Texture := nil;
      pp^.Page.Width := Spacing * 2;
      pp^.Page.Height := Spacing * 2;
      pp^.Pl.Clear;
      pp^.Pl.Add(Point(0, 0));
      Pages.Add(pp^.Page);
      pxm := pp^.Pl[0].x + Spacing;
      pym := pp^.Pl[0].y + Spacing;
      PagePl.Add(pp);
    end;
    r.Left := pxm - Spacing;
    r.Top := pym - Spacing;
    r.Right := pxm + Img^.Texture.Width + Spacing;
    r.Bottom := pym + Img^.Texture.Height + Spacing;
    SetLength(pp^.Rects, Length(pp^.Rects) + 1);
    pp^.Rects[High(pp^.Rects)] := r;
    pp^.Pl.Add(Point(r.Right, r.Bottom));
    if r.Right > pp^.Page.Width then pp^.Page.Width := r.Right;
    if r.Bottom > pp^.Page.Height then pp^.Page.Height := r.Bottom;
    Img^.Frame.PosL := pxm;
    Img^.Frame.PosT := pym;
    Img^.Frame.Page := pp^.Page;
    if OutTexturesBaked <> nil then
    Inc(OutTexturesBaked^);
  end;
  for i := 0 to Pages.Count - 1 do
  begin
    Pages[i].Texture := TG2Texture2DRT.Create;
    Pages[i].Texture.RefInc;
    if ForcePOT then
    begin
      w := 1; while w < Pages[i].Width do w := w shl 1;
      h := 1; while h < Pages[i].Height do h := h shl 1;
      TG2Texture2DRT(Pages[i].Texture).Make(w, h);
    end
    else
    TG2Texture2DRT(Pages[i].Texture).Make(Pages[i].Width, Pages[i].Height);
  end;
  PrevRenderTarget := g2.Gfx.StateChange.StateRenderTarget;
  PrevClipRect := g2.Gfx.StateChange.StateScissor;
  PrevDepthEnable := g2.Gfx.StateChange.StateDepthEnable;
  g2.Gfx.StateChange.StateDepthEnable := False;
  g2.Gfx.StateChange.StateScissor := nil;
  bm := bmDisable;
  for i := 0 to Pages.Count - 1 do
  begin
    p := Pages[i];
    g2.Gfx.StateChange.StateRenderTarget := TG2Texture2DRT(Pages[i].Texture);
    g2.Gfx.StateChange.StateClear($00000000);
    for j := 0 to ImgList.Count - 1 do
    if (ImgList[j]^.Alias = nil)
    and (ImgList[j]^.Frame <> nil)
    and (ImgList[j]^.Frame.Page = p) then
    begin
      Img := ImgList[j];
      ps.x := 1 / Img^.Texture.RealWidth;
      ps.y := 1 / Img^.Texture.RealHeight;
      if Spacing > 0 then
      begin
        if TransparentBorders then
        BorderColor := $00ffffff
        else
        BorderColor := $ffffffff;
        g2.PicRect(
          Img^.Frame.PosL - Spacing, Img^.Frame.PosT - Spacing, Spacing, Spacing,
          0, 0, 0, 0,
          BorderColor, Img^.Texture, bm, tfPoint
        );
        g2.PicRect(
          Img^.Frame.PosL + Img^.Frame.Width, Img^.Frame.PosT - Spacing, Spacing, Spacing,
          Img^.Texture.SizeTU - ps.x, 0, Img^.Texture.SizeTU - ps.x, 0,
          BorderColor, Img^.Texture, bm, tfPoint
        );
        g2.PicRect(
          Img^.Frame.PosL + Img^.Frame.Width, Img^.Frame.PosT + Img^.Frame.Height, Spacing, Spacing,
          Img^.Texture.SizeTU - ps.x, Img^.Texture.SizeTV - ps.y, Img^.Texture.SizeTU - ps.x, Img^.Texture.SizeTV - ps.y,
          BorderColor, Img^.Texture, bm, tfPoint
        );
        g2.PicRect(
          Img^.Frame.PosL - Spacing, Img^.Frame.PosT + Img^.Frame.Height, Spacing, Spacing,
          0, Img^.Texture.SizeTV - ps.y, 0, Img^.Texture.SizeTV - ps.y,
          BorderColor, Img^.Texture, bm, tfPoint
        );
        g2.PicRect(
          Img^.Frame.PosL, Img^.Frame.PosT - Spacing, Img^.Frame.Width, Spacing,
          0, 0, Img^.Frame.Width / Img^.Texture.RealWidth, 0,
          BorderColor, Img^.Texture, bm, tfPoint
        );
        g2.PicRect(
          Img^.Frame.PosL + Img^.Frame.Width, Img^.Frame.PosT, Spacing, Img^.Frame.Height,
          (Img^.Frame.Width - 1) / Img^.Texture.RealWidth, 0,
          (Img^.Frame.Width - 1) / Img^.Texture.RealWidth, Img^.Frame.Height / Img^.Texture.RealHeight,
          BorderColor, Img^.Texture, bm, tfPoint
        );
        g2.PicRect(
          Img^.Frame.PosL, Img^.Frame.PosT + Img^.Frame.Height, Img^.Frame.Width, Spacing,
          0, (Img^.Frame.Height - 1) / Img^.Texture.RealHeight,
          Img^.Frame.Width / Img^.Texture.RealWidth, (Img^.Frame.Height - 1) / Img^.Texture.RealHeight,
          BorderColor, Img^.Texture, bm, tfPoint
        );
        g2.PicRect(
          Img^.Frame.PosL - Spacing, Img^.Frame.PosT, Spacing, Img^.Frame.Height,
          0, 0, 0, Img^.Frame.Height / Img^.Texture.RealHeight,
          BorderColor, Img^.Texture, bm, tfPoint
        );
      end;
      g2.PicRect(
        Img^.Frame.PosL, Img^.Frame.PosT,
        Img^.Frame.Width, Img^.Frame.Height,
        $ffffffff, Img^.Texture,
        bm, tfPoint
      );
    end;
  end;
  for i := 0 to ImgList.Count - 1 do
  begin
    Img := ImgList[i];
    Img^.Frame.TexCoords.l := Img^.Frame.PosL / Img^.Frame.Texture.RealWidth;
    Img^.Frame.TexCoords.t := Img^.Frame.PosT / Img^.Frame.Texture.RealHeight;
    Img^.Frame.TexCoords.r := (Img^.Frame.PosL + Img^.Frame.Width) / Img^.Frame.Texture.RealWidth;
    Img^.Frame.TexCoords.b := (Img^.Frame.PosT + Img^.Frame.Height) / Img^.Frame.Texture.RealHeight;
    Dispose(Img);
  end;
  for i := 0 to PagePl.Count - 1 do
  begin
    Dispose(PagePl[i]);
  end;
  g2.Gfx.StateChange.StateRenderTarget := PrevRenderTarget;
  g2.Gfx.StateChange.StateScissor := PrevClipRect;
  g2.Gfx.StateChange.StateDepthEnable := PrevDepthEnable;
end;

procedure TG2Atlas.Clear;
  var i: Integer;
begin
  for i := 0 to Frames.Count - 1 do
  Frames[i].Free;
  for i := 0 to Pages.Count - 1 do
  begin
    Pages[i].Texture.RefDec;
    Pages[i].Free;
  end;
  Pages.Clear;
  Frames.Clear;
end;

function TG2Atlas.FindFrame(const Name: String): TG2AtlasFrame;
  var i: Integer;
begin
  for i := 0 to Frames.Count - 1 do
  if Frames[i].Name = Name then
  begin
    Result := Frames[i];
    Exit;
  end;
  Result := nil;
end;
//TG2Atlas END

//TG2Picture BEGIN
class function TG2Picture.SharedAsset(const SharedAssetName: String; const Usage: TG2TextureUsage): TG2Picture;
  var PathArr: TG2StrArrA;
  var Tex: TG2Texture2D;
  var Atlas: TG2Atlas;
  var Frame: TG2AtlasFrame;
  var PictureTexture: TG2PictureTexture absolute Result;
  var PictureAtlasFrame: TG2PictureAtlasFrame absolute Result;
  var Res: TG2Res;
begin
  Res := TG2Res.List;
  while Res <> nil do
  begin
    if (Res is TG2Picture)
    and (TG2Picture(Res).AssetName = SharedAssetName)
    and (TG2Picture(Res).Texture.Usage = Usage)
    and (Res.RefCount > 0) then
    begin
      Result := TG2Picture(Res);
      Exit;
    end;
    Res := Res.Next;
  end;
  PathArr := G2StrExplode(SharedAssetName, '#');
  if Length(PathArr) = 1 then
  begin
    Tex := TG2Texture2D.SharedAsset(SharedAssetName, Usage);
    PictureTexture := TG2PictureTexture.Create(Tex);
  end
  else
  begin
    Atlas := TG2Atlas.SharedAsset(PathArr[0]);
    Frame := Atlas.FindFrame(PathArr[1]);
    PictureAtlasFrame := TG2PictureAtlasFrame.Create(Atlas, Frame);
  end;
  Result.AssetName := SharedAssetName;
end;
//TG2Picture END

//TG2PictureTexture BEGIN
function TG2PictureTexture.GetTexture: TG2Texture2DBase;
begin
  Result := _Texture;
end;

function TG2PictureTexture.GetTexCoords: TG2Rect;
begin
  if Assigned(_Texture) then
  Result := _Texture.TexCoords
  else
  Result := G2Rect(0, 0, 0, 0);
end;

function TG2PictureTexture.GetIsValid: Boolean;
begin
  Result := Assigned(_Texture);
end;

constructor TG2PictureTexture.Create(const SharedTexture: TG2Texture2DBase);
begin
  inherited Create;
  _Texture := SharedTexture;
  if Assigned(_Texture) then _Texture.RefInc;
end;

destructor TG2PictureTexture.Destroy;
begin
  if Assigned(_Texture) then _Texture.RefDec;
  inherited Destroy;
end;
//TG2PictureTexture END

//TG2PictureAtlasFrame BEGIN
function TG2PictureAtlasFrame.GetTexture: TG2Texture2DBase;
begin
  if IsValid then
  Result := _Frame.Texture
  else
  Result := nil;
end;

function TG2PictureAtlasFrame.GetTexCoords: TG2Rect;
begin
  if IsValid then
  Result := _Frame.TexCoords
  else
  Result := G2Rect(0, 0, 0, 0);
end;

function TG2PictureAtlasFrame.GetIsValid: Boolean;
begin
  Result := Assigned(_Atlas) and Assigned(_Frame);
end;

constructor TG2PictureAtlasFrame.Create(const SharedAtlas: TG2Atlas; const SharedFrame: TG2AtlasFrame);
begin
  inherited Create;
  _Atlas := SharedAtlas;
  _Frame := SharedFrame;
  if Assigned(_Atlas) then _Atlas.RefInc;
end;

destructor TG2PictureAtlasFrame.Destroy;
begin
  if Assigned(_Atlas) then _Atlas.RefDec;
  inherited Destroy;
end;
//TG2PictureAtlasFrame END

//TG2Effect2DMod BEGIN
class function TG2Effect2DMod.GetGUID: AnsiString;
begin
  Result := '28ad0411-cecf-4b6f-9959-ee462f40541c';
end;

class function TG2Effect2DMod.GetName: AnsiString;
begin
  Result := 'Base Mod Class';
end;

class function TG2Effect2DMod.CreateMod(const GUID: AnsiString): TG2Effect2DMod;
  var i: Integer;
begin
  for i := 0 to List.Count - 1 do
  if List[i].GetGUID = GUID then
  Exit(List[i].Create);
  Result := nil;
end;

class constructor TG2Effect2DMod.CreateClass;
begin
  List.Clear;
  List.Add(TG2Effect2DModScaleGraph);
  List.Add(TG2Effect2DModOpacityGraph);
  List.Add(TG2Effect2DModColorGraph);
  List.Add(TG2Effect2DModWidthGraph);
  List.Add(TG2Effect2DModHeightGraph);
  List.Add(TG2Effect2DModOrientationGraph);
  List.Add(TG2Effect2DModRotationGraph);
  List.Add(TG2Effect2DModVelocityGraph);
  List.Add(TG2Effect2DModAcceleration);
  List.Add(TG2Effect2DModEmitterOrientationGraph);
  List.Add(TG2Effect2DModEmitterScaleGraph);
end;

constructor TG2Effect2DMod.Create;
begin

end;

procedure TG2Effect2DMod.OnParticleUpdate(const Particle: TG2Effect2DParticle; const Inst: TG2Effect2DInst; const t, dt: TG2Float);
begin

end;

procedure TG2Effect2DMod.OnEmitterUpdate(const Emitter: TG2Effect2DEmitter; const Inst: TG2Effect2DInst; const t, dt: TG2Float);
begin

end;

procedure TG2Effect2DMod.LoadG2ML(const g2ml: PG2MLObject);
begin

end;
//TG2Effect2DMod END

//TG2Effect2DModGraph BEGIN
constructor TG2Effect2DModGraph.Create;
begin
  inherited Create;
  Points := nil;
end;

procedure TG2Effect2DModGraph.AddPoint(const v: TG2Vec2);
begin
  SetLength(Points, Length(Points) + 1);
  Points[High(Points)] := v;
end;

procedure TG2Effect2DModGraph.LoadG2ML(const g2ml: PG2MLObject);
  var i: TG2IntS32;
  var n: PG2MLObject;
  var v: TG2Vec2;
begin
  for i := 0 to g2ml^.Children.Count - 1 do
  begin
    n := g2ml^.Children[i];
    if n^.Name = 'point' then
    begin
      v.x := n^.FindNode('x')^.AsFloat;
      v.y := n^.FindNode('y')^.AsFloat;
      AddPoint(v);
    end;
  end;
end;

function TG2Effect2DModGraph.GetYAt(const x: TG2Float): TG2Float;
  var n, n1, i: TG2IntS32;
  var d: TG2Float;
begin
  n := High(Points);
  for i := 0 to High(Points) do
  if Points[i].x >= x then
  begin
    n := i - 1;
    if n < 0 then n := 0;
    Break;
  end;
  if n = High(Points) then
  Result := Points[n].y
  else
  begin
    n1 := n + 1;
    d := (x - Points[n].x) / (Points[n1].x - Points[n].x);
    Result := G2LerpFloat(Points[n].y, Points[n1].y, d);
  end;
end;
//TG2Effect2DModGraph END

//TG2Effect2DModOpacityGraph BEGIN
class function TG2Effect2DModOpacityGraph.GetGUID: AnsiString;
begin
  Result := 'df171382-9708-47aa-84e6-728073083b92';
end;

class function TG2Effect2DModOpacityGraph.GetName: AnsiString;
begin
  Result := 'Opacity Graph';
end;

constructor TG2Effect2DModOpacityGraph.Create;
begin
  inherited Create;
  Graph := TG2Effect2DModGraph.Create;
end;

destructor TG2Effect2DModOpacityGraph.Destroy;
begin
  Graph.Free;
  inherited Destroy;
end;

procedure TG2Effect2DModOpacityGraph.OnParticleUpdate(const Particle: TG2Effect2DParticle; const Inst: TG2Effect2DInst; const t, dt: TG2Float);
begin
  Particle.Color.a := Round(Particle.ColorInit.a * Graph.GetYAt(t));
end;

procedure TG2Effect2DModOpacityGraph.LoadG2ML(const g2ml: PG2MLObject);
begin
  Graph.LoadG2ML(g2ml^.FindNode('graph'));
end;
//TG2Effect2DModOpacityGraph END

//TG2Effect2DModScaleGraph BEGIN
class function TG2Effect2DModScaleGraph.GetGUID: AnsiString;
begin
  Result := 'cc60e497-dce8-4682-81ef-cc0b1865ff8c';
end;

class function TG2Effect2DModScaleGraph.GetName: AnsiString;
begin
  Result := 'Scale Graph';
end;

constructor TG2Effect2DModScaleGraph.Create;
begin
  inherited Create;
  Graph := TG2Effect2DModGraph.Create;
end;

destructor TG2Effect2DModScaleGraph.Destroy;
begin
  Graph.Free;
  inherited Destroy;
end;

procedure TG2Effect2DModScaleGraph.OnParticleUpdate(const Particle: TG2Effect2DParticle; const Inst: TG2Effect2DInst; const t, dt: TG2Float);
begin
  Particle.Scale := Particle.ScaleInit * Graph.GetYAt(t);
end;

procedure TG2Effect2DModScaleGraph.LoadG2ML(const g2ml: PG2MLObject);
begin
  Graph.LoadG2ML(g2ml^.FindNode('graph'));
end;
//TG2Effect2DModScaleGraph END

//TG2Effect2DModColorGraph BEGIN
class function TG2Effect2DModColorGraph.GetGUID: AnsiString;
begin
  Result := 'b680c31b-b593-4bdd-9846-632b42d47c0c';
end;

class function TG2Effect2DModColorGraph.GetName: AnsiString;
begin
  Result := 'Color Graph';
end;

constructor TG2Effect2DModColorGraph.Create;
begin
  inherited Create;
end;

destructor TG2Effect2DModColorGraph.Destroy;
begin
  inherited Destroy;
end;

procedure TG2Effect2DModColorGraph.OnParticleUpdate(const Particle: TG2Effect2DParticle; const Inst: TG2Effect2DInst; const t, dt: TG2Float);
  var i, n: Integer;
  var c: TG2Color;
  var t0, td: TG2Float;
begin
  n := High(Graph);
  for i := 0 to High(Graph) do
  if Graph[i].Time >= t then
  begin
    n := i - 1;
    Break;
  end;
  if n = -1 then
  c := Graph[0].Color
  else if n = High(Graph) then
  c := Graph[n].Color
  else
  begin
    td := Graph[n + 1].Time - Graph[n].Time;
    t0 := t - Graph[n].Time;
    c := G2LerpColor(Graph[n].Color, Graph[n + 1].Color, t0 / td);
  end;
  Particle.Color.r := Round(Particle.ColorInit.r * G2Rcp255 * c.r);
  Particle.Color.g := Round(Particle.ColorInit.g * G2Rcp255 * c.g);
  Particle.Color.b := Round(Particle.ColorInit.b * G2Rcp255 * c.b);
end;

procedure TG2Effect2DModColorGraph.LoadG2ML(const g2ml: PG2MLObject);
  var i: TG2IntS32;
  var n: PG2MLObject;
  var c: TG2Color;
  var t: TG2Float;
begin
  for i := 0 to g2ml^.Children.Count - 1 do
  begin
    n := g2ml^.Children[i];
    if n^.Name = 'color_section' then
    begin
      c := ($ff shl 24) or TG2IntU32(StrToIntDef('$' + n^.FindNode('color')^.AsString, $ffffff));
      t := n^.FindNode('position')^.AsFloat;
      SetLength(Graph, Length(Graph) + 1);
      Graph[High(Graph)].Color := c;
      Graph[High(Graph)].Time := t;
    end;
  end;
end;
//TG2Effect2DModColorGraph END

//TG2Effect2DModWidthGraph BEGIN
class function TG2Effect2DModWidthGraph.GetGUID: AnsiString;
begin
  Result := '4b3cbb53-42b9-40f1-a639-5546a2193f78';
end;

class function TG2Effect2DModWidthGraph.GetName: AnsiString;
begin
  Result := 'Width Graph';
end;

constructor TG2Effect2DModWidthGraph.Create;
begin
  inherited Create;
  Graph := TG2Effect2DModGraph.Create;
end;

destructor TG2Effect2DModWidthGraph.Destroy;
begin
  Graph.Free;
  inherited Destroy;
end;

procedure TG2Effect2DModWidthGraph.OnParticleUpdate(const Particle: TG2Effect2DParticle; const Inst: TG2Effect2DInst; const t, dt: TG2Float);
begin
  Particle.Width := Particle.WidthInit * Graph.GetYAt(t);
end;

procedure TG2Effect2DModWidthGraph.LoadG2ML(const g2ml: PG2MLObject);
begin
  Graph.LoadG2ML(g2ml^.FindNode('graph'));
end;
//TG2Effect2DModWidthGraph END

//TG2Effect2DModHeightGraph BEGIN
class function TG2Effect2DModHeightGraph.GetGUID: AnsiString;
begin
  Result := '563235a5-0dc2-4dcb-9710-6127b7138123';
end;

class function TG2Effect2DModHeightGraph.GetName: AnsiString;
begin
  Result := 'Height Graph';
end;

constructor TG2Effect2DModHeightGraph.Create;
begin
  inherited Create;
  Graph := TG2Effect2DModGraph.Create;
end;

destructor TG2Effect2DModHeightGraph.Destroy;
begin
  Graph.Free;
  inherited Destroy;
end;

procedure TG2Effect2DModHeightGraph.OnParticleUpdate(const Particle: TG2Effect2DParticle; const Inst: TG2Effect2DInst; const t, dt: TG2Float);
begin
  Particle.Height := Particle.HeightInit * Graph.GetYAt(t);
end;

procedure TG2Effect2DModHeightGraph.LoadG2ML(const g2ml: PG2MLObject);
begin
  Graph.LoadG2ML(g2ml^.FindNode('graph'));
end;
//TG2Effect2DModHeightGraph END

//TG2Effect2DModRotationGraph BEGIN
class function TG2Effect2DModRotationGraph.GetGUID: AnsiString;
begin
  Result := '69d28969-766a-4365-a560-d8f116cd4e1a';
end;

class function TG2Effect2DModRotationGraph.GetName: AnsiString;
begin
  Result := 'Rotation Graph';
end;

constructor TG2Effect2DModRotationGraph.Create;
begin
  inherited Create;
  Graph := TG2Effect2DModGraph.Create;
end;

destructor TG2Effect2DModRotationGraph.Destroy;
begin
  Graph.Free;
  inherited Destroy;
end;

procedure TG2Effect2DModRotationGraph.OnParticleUpdate(const Particle: TG2Effect2DParticle; const Inst: TG2Effect2DInst; const t, dt: TG2Float);
begin
  Particle.Rotation := Particle.RotationInit + Graph.GetYAt(t);
end;

procedure TG2Effect2DModRotationGraph.LoadG2ML(const g2ml: PG2MLObject);
begin
  Graph.LoadG2ML(g2ml^.FindNode('graph'));
end;
//TG2Effect2DModRotationGraph END

//TG2Effect2DModOrientationGraph BEGIN
class function TG2Effect2DModOrientationGraph.GetGUID: AnsiString;
begin
  Result := 'fa779732-c3ec-4f79-9370-975547d787bb';
end;

class function TG2Effect2DModOrientationGraph.GetName: AnsiString;
begin
  Result := 'Orientation Graph';
end;

constructor TG2Effect2DModOrientationGraph.Create;
begin
  inherited Create;
  Graph := TG2Effect2DModGraph.Create;
end;

destructor TG2Effect2DModOrientationGraph.Destroy;
begin
  Graph.Free;
  inherited Destroy;
end;

procedure TG2Effect2DModOrientationGraph.OnParticleUpdate(const Particle: TG2Effect2DParticle; const Inst: TG2Effect2DInst; const t, dt: TG2Float);
begin
  Particle.xf.r.Angle := Particle.RotationInit + Graph.GetYAt(t);
end;

procedure TG2Effect2DModOrientationGraph.LoadG2ML(const g2ml: PG2MLObject);
begin
  Graph.LoadG2ML(g2ml^.FindNode('graph'));
end;
//TG2Effect2DModOrientationGraph END

//TG2Effect2DModVelocityGraph BEIGN
class function TG2Effect2DModVelocityGraph.GetGUID: AnsiString;
begin
  Result := 'd75e2d11-68ab-494d-8d05-151fd4f0d69f';
end;

class function TG2Effect2DModVelocityGraph.GetName: AnsiString;
begin
  Result := 'Velocity Graph';
end;

constructor TG2Effect2DModVelocityGraph.Create;
begin
  inherited Create;
  Graph := TG2Effect2DModGraph.Create;
end;

destructor TG2Effect2DModVelocityGraph.Destroy;
begin
  Graph.Free;
  inherited Destroy;
end;

procedure TG2Effect2DModVelocityGraph.OnParticleUpdate(const Particle: TG2Effect2DParticle; const Inst: TG2Effect2DInst; const t, dt: TG2Float);
begin
  Particle.Velocity := Particle.VelocityInit * Graph.GetYAt(t);
end;

procedure TG2Effect2DModVelocityGraph.LoadG2ML(const g2ml: PG2MLObject);
begin
  Graph.LoadG2ML(g2ml^.FindNode('graph'));
end;
//TG2Effect2DModVelocityGraph END

//TG2Effect2DModAcceleration BEGIN
class function TG2Effect2DModAcceleration.GetGUID: AnsiString;
begin
  Result := '9eb3a4ef-450a-403a-8515-3862e9991a77';
end;

class function TG2Effect2DModAcceleration.GetName: AnsiString;
begin
  Result := 'Acceleration';
end;

constructor TG2Effect2DModAcceleration.Create;
begin
  inherited Create;
  Graph := TG2Effect2DModGraph.Create;
  Local := False;
  Direction := G2Rotation2;
end;

destructor TG2Effect2DModAcceleration.Destroy;
begin
  Graph.Free;
  inherited Destroy;
end;

procedure TG2Effect2DModAcceleration.OnParticleUpdate(const Particle: TG2Effect2DParticle; const Inst: TG2Effect2DInst; const t, dt: TG2Float);
  var r: TG2Rotation2;
  var a, v: TG2Vec2;
  var vl: TG2Float;
begin
  r := Direction;
  if Local then G2Rotation2Mul(@r, @r, @Particle.xf.r);
  a := r.AxisX * (Graph.GetYAt(t) * dt);
  v := Particle.xf.r.AxisX * Particle.Velocity;
  v := v + a;
  vl := v.Len;
  Particle.Velocity := vl;
  if Abs(vl) > G2EPS then
  Particle.xf.r.AxisX := v.Norm;
end;

procedure TG2Effect2DModAcceleration.LoadG2ML(const g2ml: PG2MLObject);
begin
  Local := g2ml^.FindNode('local')^.AsBool;
  Direction := G2Rotation2(g2ml^.FindNode('direction')^.AsFloat);
  Graph.LoadG2ML(g2ml^.FindNode('graph'));
end;
//TG2Effect2DModAcceleration END

//TG2Effect2DModEmitterOrientationGraph BEGIN
class function TG2Effect2DModEmitterOrientationGraph.GetGUID: AnsiString;
begin
  Result := '5b84cb78-4021-49be-9764-a9a7a5e09af8';
end;

class function TG2Effect2DModEmitterOrientationGraph.GetName: AnsiString;
begin
  Result := 'Emitter Orientation Graph';
end;

constructor TG2Effect2DModEmitterOrientationGraph.Create;
begin
  inherited Create;
  Graph := TG2Effect2DModGraph.Create;
end;

destructor TG2Effect2DModEmitterOrientationGraph.Destroy;
begin
  Graph.Free;
  inherited Destroy;
end;

procedure TG2Effect2DModEmitterOrientationGraph.OnEmitterUpdate(const Emitter: TG2Effect2DEmitter; const Inst: TG2Effect2DInst; const t, dt: TG2Float);
begin
  Emitter.Orientation := Emitter.Data.Orientation + Graph.GetYAt(t);
end;

procedure TG2Effect2DModEmitterOrientationGraph.LoadG2ML(const g2ml: PG2MLObject);
begin
  Graph.LoadG2ML(g2ml^.FindNode('graph'));
end;
//TG2Effect2DModEmitterOrientationGraph END

//TG2Effect2DModEffectScaleGraph BEGIN
class function TG2Effect2DModEmitterScaleGraph.GetGUID: AnsiString;
begin
  Result := 'a0156854-2d47-4d3b-8fc2-b127a9b6cddf';
end;

class function TG2Effect2DModEmitterScaleGraph.GetName: AnsiString;
begin
  Result := 'Emitter Scale Graph';
end;

constructor TG2Effect2DModEmitterScaleGraph.Create;
begin
  inherited Create;
  Graph := TG2Effect2DModGraph.Create;
end;

destructor TG2Effect2DModEmitterScaleGraph.Destroy;
begin
  Graph.Free;
  inherited Destroy;
end;

procedure TG2Effect2DModEmitterScaleGraph.OnEmitterUpdate(const Emitter: TG2Effect2DEmitter; const Inst: TG2Effect2DInst; const t, dt: TG2Float);
  var d: TG2Float;
begin
  d := Graph.GetYAt(t);
  Emitter.Width0 := Emitter.Data.ShapeWidth0 * d;
  Emitter.Width1 := Emitter.Data.ShapeWidth1 * d;
  Emitter.Height0 := Emitter.Data.ShapeHeight0 * d;
  Emitter.Height1 := Emitter.Data.ShapeHeight1 * d;
  Emitter.Radius0 := Emitter.Data.ShapeRadius0 * d;
  Emitter.Radius1 := Emitter.Data.ShapeRadius1 * d;
end;

procedure TG2Effect2DModEmitterScaleGraph.LoadG2ML(const g2ml: PG2MLObject);
begin
  Graph.LoadG2ML(g2ml^.FindNode('graph'));
end;
//TG2Effect2DModEffectScaleGraph END

//TG2Effect2DEmitterData BEGIN
constructor TG2Effect2DEmitterData.Create;
begin
  inherited Create;
  Name := '';
  Frame := nil;
  TimeStart := 0;
  TimeEnd := 1;
  Orientation := 0;
  Shape := g2_e2ds_radial;
  ShapeRadius0 := 0;
  ShapeRadius1 := 1;
  ShapeAngle := G2HalfPi;
  ShapeWidth0 := 0;
  ShapeWidth1 := 1;
  ShapeHeight0 := 0;
  ShapeHeight1 := 1;
  Emission := 1;
  Layer := 0;
  Infinite := False;
  ParticleCenterX := 0.5;
  ParticleCenterY := 0.5;
  ParticleWidthMin := 1;
  ParticleWidthMax := 1;
  ParticleHeightMin := 1;
  ParticleHeightMax := 1;
  ParticleScaleMin := 1;
  ParticleScaleMax := 1;
  ParticleDurationMin := 1;
  ParticleDurationMax := 1;
  ParticleRotationMin := 0;
  ParticleRotationMax := 0;
  ParticleRotationLocal := True;
  ParticleOrientationMin := 0;
  ParticleOrientationMax := 0;
  ParticleVelocityMin := 0;
  ParticleVelocityMax := 1;
  ParticleColor0 := $ffffffff;
  ParticleColor1 := $ffffffff;
  ParticleBlend := bmNormal;
  Mods.Clear;
  Emitters.Clear;
end;

procedure TG2Effect2DEmitterData.LoadG2ML(const g2ml: PG2MLObject);
  function ReadBlendMode(const Node: PG2MLObject): TG2BlendMode;
    var BlendOpToStr: array[0..10] of String = (
      'Disable',
      'Zero',
      'One',
      'SrcColor',
      'InvSrcColor',
      'DstColor',
      'InvDstColor',
      'SrcAlpha',
      'InvSrcAlpha',
      'DstAlpha',
      'InvDstAlpha'
    );
    var i, j: TG2IntS32;
    var c: PG2MLObject;
    var op: TG2BlendOperation;
    var s: String;
  begin
    Result := bmDisable;
    for i := 0 to Node^.Children.Count - 1 do
    begin
      c := Node^.Children[i];
      op := boDisable;
      s := c^.AsString;
      for j := 0 to High(BlendOpToStr) do
      if BlendOpToStr[j] = s then
      op := TG2BlendOperation(j);
      if c^.Name = 'ColorSrc' then Result.ColorSrc := op
      else if c^.Name = 'ColorDst' then Result.ColorDst := op
      else if c^.Name = 'AlphaSrc' then Result.AlphaSrc := op
      else if c^.Name = 'AlphaDst' then Result.AlphaDst := op;
    end;
  end;
  var i: TG2IntS32;
  var n: PG2MLObject;
  var e: TG2Effect2DEmitterData;
  var EffectMod: TG2Effect2DMod;
  var mod_guid: AnsiString;
begin
  for i := 0 to g2ml^.Children.Count - 1 do
  begin
    n := g2ml^.Children[i];
    if n^.Name = 'name' then Name := n^.AsString
    else if n^.Name = 'frame' then Frame := Effect.FindFrame(n^.AsString)
    else if n^.Name = 'time_start' then TimeStart := n^.AsFloat
    else if n^.Name = 'time_end' then TimeEnd := n^.AsFloat
    else if n^.Name = 'orientation' then Orientation := n^.AsFloat
    else if n^.Name = 'shape' then Shape := TG2Effect2DShape(n^.AsInt)
    else if n^.Name = 'shape_radius_0' then ShapeRadius0 := n^.AsFloat
    else if n^.Name = 'shape_radius_1' then ShapeRadius1 := n^.AsFloat
    else if n^.Name = 'shape_angle' then ShapeAngle := n^.AsFloat
    else if n^.Name = 'shape_width_0' then ShapeWidth0 := n^.AsFloat
    else if n^.Name = 'shape_width_1' then ShapeWidth1 := n^.AsFloat
    else if n^.Name = 'shape_height_0' then ShapeHeight0 := n^.AsFloat
    else if n^.Name = 'shape_height_1' then ShapeHeight1 := n^.AsFloat
    else if n^.Name = 'emission' then Emission := n^.AsInt
    else if n^.Name = 'layer' then Layer := n^.AsInt
    else if n^.Name = 'infinite' then Infinite := n^.AsBool
    else if n^.Name = 'particle_center_x' then ParticleCenterX := n^.AsFloat
    else if n^.Name = 'particle_center_y' then ParticleCenterY := n^.AsFloat
    else if n^.Name = 'particle_width_min' then ParticleWidthMin := n^.AsFloat
    else if n^.Name = 'particle_width_max' then ParticleWidthMax := n^.AsFloat
    else if n^.Name = 'particle_height_min' then ParticleHeightMin := n^.AsFloat
    else if n^.Name = 'particle_height_max' then ParticleHeightMax := n^.AsFloat
    else if n^.Name = 'particle_scale_min' then ParticleScaleMin := n^.AsFloat
    else if n^.Name = 'particle_scale_max' then ParticleScaleMax := n^.AsFloat
    else if n^.Name = 'particle_duration_min' then ParticleDurationMin := n^.AsFloat
    else if n^.Name = 'particle_duration_max' then ParticleDurationMax := n^.AsFloat
    else if n^.Name = 'particle_rotation_min' then ParticleRotationMin := n^.AsFloat
    else if n^.Name = 'particle_rotation_max' then ParticleRotationMax := n^.AsFloat
    else if n^.Name = 'particle_rotation_local' then ParticleRotationLocal := n^.AsBool
    else if n^.Name = 'particle_orientation_min' then ParticleOrientationMin := n^.AsFloat
    else if n^.Name = 'particle_orientation_max' then ParticleOrientationMax := n^.AsFloat
    else if n^.Name = 'particle_velocity_min' then ParticleVelocityMin := n^.AsFloat
    else if n^.Name = 'particle_velocity_max' then ParticleVelocityMax := n^.AsFloat
    else if n^.Name = 'particle_color_0' then
    begin
      ParticleColor0 := ($ff shl 24) or TG2IntU32(StrToIntDef('$' + n^.AsString, $ffffff));
    end
    else if n^.Name = 'particle_color_1' then
    begin
      ParticleColor1 := ($ff shl 24) or TG2IntU32(StrToIntDef('$' + n^.AsString, $ffffff));
    end
    else if n^.Name = 'particle_opacity' then
    begin
      ParticleColor0.a := Round(n^.AsFloat * $ff);
      ParticleColor1.a := ParticleColor0.a;
    end
    else if n^.Name = 'blend_mode' then ParticleBlend := ReadBlendMode(n)
    else if n^.Name = 'mod' then
    begin
      mod_guid := n^.FindNode('guid')^.AsString;
      EffectMod := TG2Effect2DMod.CreateMod(mod_guid);
      EffectMod.LoadG2ML(n);
      Mods.Add(EffectMod);
    end
    else if n^.Name = 'emitter' then
    begin
      e := TG2Effect2DEmitterData.Create;
      e.Effect := Effect;
      Emitters.Add(e);
      e.LoadG2ML(n);
    end;
  end;
end;
//TG2Effect2DEmitterData END

//TG2Effect2D BEGIN
class function TG2Effect2D.SharedAsset(const SharedAssetName: String): TG2Effect2D;
  var Res: TG2Res;
  var dm: TG2DataManager;
begin
  Res := TG2Res.List;
  while Res <> nil do
  begin
    if (Res is TG2Effect2D)
    and (TG2Effect2D(Res).AssetName = SharedAssetName) then
    begin
      Result := TG2Effect2D(Res);
      Exit;
    end;
    Res := Res.Next;
  end;
  dm := TG2DataManager.Create(SharedAssetName, dmAsset);
  Result := TG2Effect2D.Create;
  Result.AssetName := SharedAssetName;
  Result.Load(dm);
  dm.Free;
end;

constructor TG2Effect2D.Create;
begin
  inherited Create;
  Name := '';
  Scale := 1;
  Pages.Clear;
  Frames.Clear;
  EmitterData.Clear;
end;

destructor TG2Effect2D.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TG2Effect2D.FindFrame(const FrameName: String): TG2AtlasFrame;
  var i: TG2IntS32;
begin
  for i := 0 to Frames.Count - 1 do
  if Frames[i].Name = FrameName then Exit(Frames[i]);
  Result := nil;
end;

procedure TG2Effect2D.Load(const FileName: String);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Effect2D.Load(const DataManager: TG2DataManager);
  var g2ml: TG2ML;
  var FileData: AnsiString;
  var Root, n0, n1, n2, n3, n4: PG2MLObject;
  var i, i0, i1, i2, i3, i4: TG2IntS32;
  var Page: TG2AtlasPage;
  var Frame: TG2AtlasFrame;
  var Emitter: TG2Effect2DEmitterData;
  var sx, sy: TG2Float;
begin
  SetLength(FileData, DataManager.Size);
  DataManager.ReadBuffer(@FileData[1], DataManager.Size);
  g2ml := TG2ML.Create;
  Page := nil;
  Frame := nil;
  Emitter := nil;
  Root := g2ml.Read(FileData);
  for i0 := 0 to Root^.Children.Count - 1 do
  begin
    n0 := Root^.Children[i0];
    if n0^.Name = 'g2fx' then
    for i1 := 0 to n0^.Children.Count - 1 do
    begin
      n1 := n0^.Children[i1];
      if n1^.Name = 'name' then Name := n1^.AsString
      else if n1^.Name = 'scale' then Scale := n1^.AsFloat
      else if n1^.Name = 'atlas' then
      begin
        for i2 := 0 to n1^.Children.Count - 1 do
        begin
          n2 := n1^.Children[i2];
          if n2^.Name = 'page' then
          begin
            Page := TG2AtlasPage.Create;
            Page.Texture := nil;
            Page.Width := 0;
            Page.Height := 0;
            Pages.Add(Page);
            for i3 := 0 to n2^.Children.Count - 1 do
            begin
              n3 := n2^.Children[i3];
              if n3^.Name = 'texture' then
              begin
                Page.Texture := TG2Texture2D.SharedAsset(DataManager.Path + n3^.AsString, tu2D);
                Page.Texture.RefInc;
              end
              else if n3^.Name = 'width' then Page.Width := n3^.AsInt
              else if n3^.Name = 'height' then Page.Height := n3^.AsInt
              else if n3^.Name = 'frame' then
              begin
                Frame := TG2AtlasFrame.Create;
                Frame.Page := Page;
                Frame.Name := '';
                Frame.Width := 0;
                Frame.Height := 0;
                Frame.PosL := 0;
                Frame.PosT := 0;
                Frame.TexCoords := G2Rect(0, 0, 0, 0);
                Frames.Add(Frame);
                for i4 := 0 to n3^.Children.Count - 1 do
                begin
                  n4 := n3^.Children[i4];
                  if n4^.Name = 'name' then Frame.Name := n4^.AsString
                  else if n4^.Name = 'pos_l' then Frame.PosL := n4^.AsInt
                  else if n4^.Name = 'pos_t' then Frame.PosT := n4^.AsInt
                  else if n4^.Name = 'width' then Frame.Width := n4^.AsInt
                  else if n4^.Name = 'height' then Frame.Height := n4^.AsInt;
                end;
              end;
            end;
          end;
        end;
      end
      else if n1^.Name = 'emitter' then
      begin
        Emitter := TG2Effect2DEmitterData.Create;
        Emitter.Effect := Self;
        EmitterData.Add(Emitter);
        Emitter.LoadG2ML(n1);
      end;
    end;
  end;
  g2ml.FreeObject(Root);
  for i := 0 to Frames.Count - 1 do
  begin
    sx := (1 / Frames[i].Page.Width) * Frames[i].Page.Texture.TexCoords.w;
    sy := (1 / Frames[i].Page.Height) * Frames[i].Page.Texture.TexCoords.h;
    Frames[i].TexCoords := G2Rect(
      Frames[i].PosL * sx, Frames[i].PosT * sy,
      Frames[i].Width * sx, Frames[i].Height * sy
    );
  end;
end;

procedure TG2Effect2D.Clear;
  var i: TG2IntS32;
begin
  for i := 0 to Frames.Count - 1 do
  Frames[i].Free;
  for i := 0 to Pages.Count - 1 do
  begin
    if Assigned(Pages[i].Texture) then
    Pages[i].Texture.RefDec;
    Pages[i].Free;
  end;
  for i := 0 to EmitterData.Count - 1 do
  EmitterData[i].Free;
  Frames.Clear;
  Pages.Clear;
  EmitterData.Clear;
end;

function TG2Effect2D.CreateInstance: TG2Effect2DInst;
begin
  Result := TG2Effect2DInst.Create(Self);
end;
//TG2Effect2D END

//TG2Effect2DInst BEGIN
procedure TG2Effect2DInst.OnUpdate;
  var dt: TG2Float;
  var gxf: TG2Transform2;
  procedure ProcessEmitter(const Emitter: TG2Effect2DEmitter);
    var xf, pxf: TG2Transform2;
    var t, aw, ah, w0, w1, h0, h1, at, rn: TG2Float;
    var i, j, ec: Integer;
    var p: TG2Effect2DParticle;
    var v0: TG2Vec2;
    var r0: TG2Rotation2;
  begin
    if Emitter.DurationTotal <= 0 then
    begin
      _Emitters.Remove(Emitter);
      _EmitterCache.Add(Emitter);
      Dec(_EmittersAlive);
      Exit;
    end;
    if Emitter.Parent = nil then
    xf := gxf
    else
    xf := Emitter.Parent.xf;
    if Emitter.Delay > 0 then
    begin
      Emitter.Delay -= dt;
      if Emitter.Delay < 0 then Emitter.Duration += Emitter.Delay;
      if Emitter.Delay > 0 then Exit;
    end
    else
    Emitter.Duration -= dt;
    if Emitter.Data.Infinite
    and (Emitter.Duration <= 0) then
    begin
      Emitter.Duration := Emitter.DurationTotal + Emitter.Duration;
      Emitter.ParticlesToEmitt := Emitter.ParticlesToEmitt + Emitter.Data.Emission;
    end;
    t := 1 - (Emitter.Duration / Emitter.DurationTotal);
    if t < 0 then Exit
    else if (t > 1) then
    begin
      if (Emitter.ParticlesToEmitt > 0) then
      ec := Emitter.ParticlesToEmitt
      else
      begin
        _Emitters.Remove(Emitter);
        _EmitterCache.Add(Emitter);
        Dec(_EmittersAlive);
        Exit;
      end;
    end
    else
    ec := Emitter.ParticlesToEmitt - (Emitter.Data.Emission - Round(Emitter.Data.Emission * t));
    if ec <= 0 then Exit;
    if ec > Emitter.ParticlesToEmitt then ec := Emitter.ParticlesToEmitt;
    Emitter.ParticlesToEmitt := Emitter.ParticlesToEmitt - ec;
    for i := 0 to ec - 1 do
    begin
      if _ParticleCache.Count > 0 then
      p := _ParticleCache.Pop
      else
      p := TG2Effect2DParticle.Create;
      p.Data := Emitter.Data;
      p.xf := G2Transform2(G2Vec2, G2Rotation2(Emitter.Data.ParticleOrientationMin + Random * (Emitter.Data.ParticleOrientationMax - Emitter.Data.ParticleOrientationMin)));
      p.DurationTotal := Emitter.Data.ParticleDurationMin + Random * (Emitter.Data.ParticleDurationMax - Emitter.Data.ParticleDurationMin);
      p.Duration := p.DurationTotal;
      p.CenterX := Emitter.Data.ParticleCenterX;
      p.CenterY := Emitter.Data.ParticleCenterY;
      p.WidthInit := Emitter.Data.ParticleWidthMin + Random * (Emitter.Data.ParticleWidthMax - Emitter.Data.ParticleWidthMin);
      p.Width := p.WidthInit;
      p.HeightInit := Emitter.Data.ParticleHeightMin + Random * (Emitter.Data.ParticleHeightMax - Emitter.Data.ParticleHeightMin);
      p.Height := p.HeightInit;
      p.ScaleInit := (Emitter.Data.ParticleScaleMin + Random * (Emitter.Data.ParticleScaleMax - Emitter.Data.ParticleScaleMin)) * _Scale;
      p.Scale := p.ScaleInit;
      p.RotationLocal := Emitter.Data.ParticleRotationLocal;
      p.RotationInit := Emitter.Data.ParticleRotationMin + Random * (Emitter.Data.ParticleRotationMax - Emitter.Data.ParticleRotationMin);
      p.Rotation := p.RotationInit;
      p.VelocityInit := Emitter.Data.ParticleVelocityMin + Random * (Emitter.Data.ParticleVelocityMax - Emitter.Data.ParticleVelocityMin);
      p.Velocity := p.VelocityInit;
      p.ColorInit := G2LerpColor(Emitter.Data.ParticleColor0, Emitter.Data.ParticleColor1, Random);
      p.Color := p.ColorInit;
      case Emitter.Data.Shape of
        g2_e2ds_radial:
        begin
          v0 := G2Vec2(G2LerpFloat(Emitter.Radius0, Emitter.Radius1, Random), 0);
          r0 := G2Rotation2(Emitter.Data.ShapeAngle * Random - Emitter.Data.ShapeAngle * 0.5 + Emitter.Orientation);
          v0 := r0.Transform(v0);
          pxf.p := v0;
          pxf.r := r0;
        end;
        g2_e2ds_rectangular:
        begin
          w0 := Emitter.Width0; w1 := Emitter.Width1;
          h0 := Emitter.Height0; h1 := Emitter.Height1;
          aw := w1 * (h1 - h0);
          if aw < 0.001 then aw := 0.001;
          ah := h0 * (w1 - w0);
          if ah < 0.001 then ah := 0.001;
          at := aw + ah;
          rn := Random * at;
          if rn <= aw * 0.5 then
          begin
            v0.x := G2LerpFloat(-w1 * 0.5, w1 * 0.5, Random);
            v0.y := G2LerpFloat(-h1 * 0.5, -h0 * 0.5, Random);
          end
          else if rn <= aw then
          begin
            v0.x := G2LerpFloat(-w1 * 0.5, w1 * 0.5, Random);
            v0.y := G2LerpFloat(h0 * 0.5, h1 * 0.5, Random);
          end
          else if rn <= aw + ah * 0.5 then
          begin
            v0.x := G2LerpFloat(-w1 * 0.5, -w0 * 0.5, Random);
            v0.y := G2LerpFloat(-h0 * 0.5, h0 * 0.5, Random);
          end
          else if rn <= at then
          begin
            v0.x := G2LerpFloat(w0 * 0.5, w1 * 0.5, Random);
            v0.y := G2LerpFloat(-h0 * 0.5, h0 * 0.5, Random);
          end;
          r0 := G2Rotation2(Emitter.Orientation);
          pxf.p := r0.Transform(v0);
          pxf.r := r0;
        end;
      end;
      pxf.p := pxf.p * _Scale;
      G2Transform2Mul(@p.xf, @p.xf, @pxf);
      G2Transform2Mul(@p.xf, @p.xf, @xf);
      p.OrientationInit := p.xf.r.Angle;
      for j := 0 to Emitter.Data.Emitters.Count - 1 do
      CreateEmitter(Emitter.Data.Emitters[j], p);
      p.Layer := FindLayer(p.Data.Layer);
      Inc(p.Layer.Ref);
      p.Layer.Particles.Add(p);
      Inc(_ParticlesAlive);
    end;
    for i := 0 to Emitter.Data.Mods.Count - 1 do
    Emitter.Data.Mods[i].OnEmitterUpdate(Emitter, Self, t, dt);
  end;
  procedure ProcessParticle(const Particle: TG2Effect2DParticle);
    var i: Integer;
    var e: TG2Effect2DEmitter;
    var t: TG2Float;
  begin
    Particle.Duration -= dt;
    if Particle.Duration <= 0 then
    begin
      Particle.Layer.Particles.Remove(Particle);
      Dec(Particle.Layer.Ref);
      if Particle.Layer.Ref <= 0 then
      begin
        _Layers.Remove(Particle.Layer);
        Particle.Layer.Free;
      end;
      for i := _Emitters.Count - 1 downto 0 do
      begin
        e := _Emitters[i];
        if e.Parent = Particle then
        begin
          _EmitterCache.Add(e);
          _Emitters.Delete(i);
          Dec(_EmittersAlive);
        end;
      end;
      Particle.Free;
      Dec(_ParticlesAlive);
    end
    else
    begin
      t := 1 - (Particle.Duration / Particle.DurationTotal);
      for i := 0 to Particle.Data.Mods.Count - 1 do
      Particle.Data.Mods[i].OnParticleUpdate(Particle, Self, t, dt);
      Particle.xf.p := Particle.xf.p + (Particle.xf.r.AxisX * (Particle.Velocity * dt * _Scale));
    end;
  end;
  var i, j: Integer;
begin
  if not _Playing then Exit;
  if (_EmittersAlive = 0) and (_ParticlesAlive = 0) then
  begin
    Stop;
    if _Repeating then Play;
    if Assigned(_OnFinish) then _OnFinish(Self);
    Exit;
  end;
  if (_Transform <> nil) and not _LocalSpace then
  begin
    gxf := _Transform^;
    if _FixedOrientation then gxf.r := G2Rotation2;
  end
  else
  gxf := G2Transform2;
  dt := g2.DeltaTimeSec * _Speed;
  for i := _Emitters.Count - 1 downto 0 do
  ProcessEmitter(_Emitters[i]);
  for i := _Layers.Count - 1 downto 0 do
  for j := _Layers[i].Particles.Count - 1 downto 0 do
  ProcessParticle(_Layers[i].Particles[j]);
end;

procedure TG2Effect2DInst.Clear;
  var i, j: TG2IntS32;
begin
  for i := 0 to _Layers.Count - 1 do
  begin
    for j := 0 to _Layers[i].Particles.Count - 1 do
    _Layers[i].Particles[j].Free;
    _Layers[i].Free;
  end;
  _Layers.Clear;
  for i := 0 to _Emitters.Count - 1 do
  _Emitters[i].Free;
  _Emitters.Clear;
  for i := 0 to _EmitterCache.Count - 1 do
  _EmitterCache[i].Free;
  _EmitterCache.Clear;
  for i := 0 to _ParticleCache.Count - 1 do
  _ParticleCache[i].Free;
  _ParticleCache.Clear;
  _ParticlesAlive := 0;
  _EmittersAlive := 0;
end;

function TG2Effect2DInst.FindLayer(const Layer: TG2IntS32): TG2Effect2DLayer;
  var i, n: Integer;
begin
  n := 0;
  for i := 0 to _Layers.Count - 1 do
  begin
    if _Layers[i].Index = Layer then
    begin
      Result := _Layers[i];
      Exit;
    end
    else if _Layers[i].Index < Layer then n := i + 1;
  end;
  Result := TG2Effect2DLayer.Create;
  Result.Index := Layer;
  Result.Ref := 0;
  _Layers.Insert(n, Result);
end;

function TG2Effect2DInst.CreateEmitter(
  const Data: TG2Effect2DEmitterData;
  const Parent: TG2Effect2DParticle
): TG2Effect2DEmitter;
begin
  if _EmitterCache.Count > 0 then
  Result := _EmitterCache.Pop
  else
  Result := TG2Effect2DEmitter.Create;
  Result.Data := Data;
  Result.Parent := Parent;
  Result.DurationTotal := Data.TimeEnd - Data.TimeStart;
  Result.Duration := Result.DurationTotal;
  Result.Delay := Data.TimeStart;
  Result.ParticlesToEmitt := Data.Emission;
  Result.Orientation := Data.Orientation;
  Result.Radius0 := Data.ShapeRadius0;
  Result.Radius1 := Data.ShapeRadius1;
  Result.Width0 := Data.ShapeWidth0;
  Result.Width1 := Data.ShapeWidth1;
  Result.Height0 := Data.ShapeHeight0;
  Result.Height1 := Data.ShapeHeight1;
  _Emitters.Add(Result);
  Inc(_EmittersAlive);
end;

constructor TG2Effect2DInst.Create(const ParentEffect: TG2Effect2D);
begin
  inherited Create;
  _Effect := ParentEffect;
  _EmitterCache.Clear;
  _ParticleCache.Clear;
  _Emitters.Clear;
  _Layers.Clear;
  _Playing := False;
  _Repeating := False;
  _Scale := _Effect.Scale;
  _Speed := 1;
  _LocalSpace := True;
  _FixedOrientation := False;
  _Transform := nil;
  _OnFinish := nil;
end;

destructor TG2Effect2DInst.Destroy;
begin
  Stop;
  Clear;
  inherited Destroy;
end;

procedure TG2Effect2DInst.Play;
  var i: Integer;
begin
  if _Playing then Exit;
  _EmittersAlive := 0;
  _ParticlesAlive := 0;
  _EmittersAlive := 0;
  _ParticlesAlive := 0;
  for i := 0 to _Effect.EmitterData.Count - 1 do
  CreateEmitter(_Effect.EmitterData[i]);
  g2.CallbackUpdateAdd(@OnUpdate);
  _Playing := True;
end;

procedure TG2Effect2DInst.Stop;
begin
  if not _Playing then Exit;
  g2.CallbackUpdateRemove(@OnUpdate);
  Clear;
  _Playing := False;
end;

procedure TG2Effect2DInst.Render(const Display: TG2Display2D);
  procedure RenderParticle(const Particle: TG2Effect2DParticle);
    var v0, v1, v2, v3: TG2Vec2;
    var px0, px1, py0, py1, a: TG2Float;
    var xfl: TG2Transform2;
    var xfg: TG2Transform2;
  begin
    if Particle.Data.Frame = nil then Exit;
    if Particle.Data.ParticleRotationLocal then
    begin
      xfl := Particle.xf;
      a := xfl.r.Angle;
      xfl.r.Angle := a + Particle.Rotation;
    end
    else
    begin
      xfl := G2Transform2(Particle.xf.p, G2Rotation2(Particle.Rotation));
    end;
    if (_Transform <> nil) and _LocalSpace then
    begin
      xfg := _Transform^;
      if _FixedOrientation then xfg.r := G2Rotation2;
      G2Transform2Mul(@xfl, @xfl, @xfg);
    end;
    px0 := -(Particle.Width * Particle.Scale) * (Particle.CenterX);
    px1 := (Particle.Width * Particle.Scale) * (1 - Particle.CenterX);
    py0 := -(Particle.Height * Particle.Scale) * (Particle.CenterY);
    py1 := (Particle.Height * Particle.Scale) * (1 - Particle.CenterY);
    v0 := xfl.Transform(G2Vec2(px0, py0));
    v1 := xfl.Transform(G2Vec2(px1, py0));
    v2 := xfl.Transform(G2Vec2(px0, py1));
    v3 := xfl.Transform(G2Vec2(px1, py1));
    if Display <> nil then
    begin
      Display.PicQuad(
        v0, v1, v2, v3,
        Particle.Data.Frame.TexCoords.tl, Particle.Data.Frame.TexCoords.tr,
        Particle.Data.Frame.TexCoords.bl, Particle.Data.Frame.TexCoords.br,
        Particle.Color, Particle.Data.Frame.Texture, Particle.Data.ParticleBlend, tfLinear
      );
    end
    else
    begin
      g2.PicQuad(
        v0, v1, v2, v3,
        Particle.Data.Frame.TexCoords.tl, Particle.Data.Frame.TexCoords.tr,
        Particle.Data.Frame.TexCoords.bl, Particle.Data.Frame.TexCoords.br,
        Particle.Color, Particle.Data.Frame.Texture, Particle.Data.ParticleBlend, tfLinear
      );
    end;
  end;
  var i, j: Integer;
begin
  if not _Playing then Exit;
  for i := 0 to _Layers.Count - 1 do
  for j := 0 to _Layers[i].Particles.Count - 1 do
  RenderParticle(_Layers[i].Particles[j]);
end;
//TG2Effect2DInst END

//TG2SoundBuffer BEGIN
procedure TG2SoundBuffer.Release;
begin
  {$if defined(G2Snd_DS)}
  SafeRelease(_Buffer);
  {$elseif defined(G2Snd_OAL)}
  if _Buffer <> 0 then
  begin
    alDeleteBuffers(1, @_Buffer);
    _Buffer := 0;
  end;
  {$endif}
end;

procedure TG2SoundBuffer.Initialize;
begin
  {$ifdef G2Snd_OAL}
  _Buffer := 0;
  {$endif}
end;

procedure TG2SoundBuffer.Finalize;
begin
  Release;
end;

function TG2SoundBuffer.Load(const Stream: TStream): Boolean;
  var Audio: TG2Audio;
  var i: TG2IntS32;
begin
  for i := 0 to High(G2AudioFormats) do
  if G2AudioFormats[i].CanRead(Stream) then
  begin
    Audio := G2AudioFormats[i].Create;
    try
      Audio.Load(Stream);
      Result := Load(Audio);
    finally
      Audio.Free;
    end;
    Exit;
  end;
  Result := False;
end;

function TG2SoundBuffer.Load(const FileName: String): Boolean;
  var Audio: TG2Audio;
  var i: TG2IntS32;
begin
  for i := 0 to High(G2AudioFormats) do
  if G2AudioFormats[i].CanRead(FileName) then
  begin
    Audio := G2AudioFormats[i].Create;
    try
      Audio.Load(FileName);
      Result := Load(Audio);
    finally
      Audio.Free;
    end;
    Exit;
  end;
  Result := False;
end;

function TG2SoundBuffer.Load(const Buffer: Pointer; const Size: TG2IntS32): Boolean;
  var Audio: TG2Audio;
  var i: TG2IntS32;
begin
  for i := 0 to High(G2AudioFormats) do
  if G2AudioFormats[i].CanRead(Buffer, Size) then
  begin
    Audio := G2AudioFormats[i].Create;
    try
      Audio.Load(Buffer, Size);
      Result := Load(Audio);
    finally
      Audio.Free;
    end;
    Exit;
  end;
  Result := False;
end;

function TG2SoundBuffer.Load(const Audio: TG2Audio): Boolean;
{$if defined(G2Snd_DS)}
  var Desc: TDSBufferDesc;
  var Format: TWaveFormatEx;
  var Ptr: Pointer;
  var LockBytes: TG2IntU32;
  var hr: HResult;
begin
  Result := False;
  Release;
  FillChar(Format{%H-}, SizeOf(Format), 0);
  Format.cbSize := SizeOf(Format);
  Format.nChannels := Audio.ChannelCount;
  Format.nSamplesPerSec := Audio.SampleRate;
  Format.wBitsPerSample := Audio.SampleSize * 8;
  Format.wFormatTag := 1;
  Format.nAvgBytesPerSec := Audio.SampleRate * Audio.SampleSize;
  Format.nBlockAlign := Audio.SampleSize * Audio.ChannelCount;
  FillChar(Desc{%H-}, SizeOf(Desc), 0);
  Desc.dwSize := SizeOf(Desc);
  Desc.dwFlags := DSBCAPS_CTRL3D;
  Desc.dwBufferBytes := Audio.DataSize;
  Desc.lpwfxFormat := @Format;
  hr := TG2SndDS(g2.Snd)._Device.CreateSoundBuffer(
    Desc, _Buffer, nil
  );
  if Failed(hr) then Exit;
  _Buffer.Lock(0, 0, @Ptr, @LockBytes, nil, nil, DSBLOCK_ENTIREBUFFER);
  try
    Move(Audio.Data^, Ptr^, Audio.DataSize);
  finally
    _Buffer.Unlock(Ptr, LockBytes, nil, 0);
  end;
  Result := True;
end;
{$elseif defined(G2Snd_OAL)}
  var Format: TALEnum;
begin
  Result := False;
  Release;
  case Audio.Format of
    afMono8: Format := AL_FORMAT_MONO8;
    afMono16: Format := AL_FORMAT_MONO16;
    afStereo8: Format := AL_FORMAT_STEREO8;
    afStereo16: Format := AL_FORMAT_STEREO16;
    else Format := AL_FORMAT_MONO8;
  end;
  alGenBuffers(1, @_Buffer);
  if _Buffer = 0 then Exit;
  alBufferData(_Buffer, Format, Audio.Data, Audio.DataSize, Audio.SampleRate);
  Result := True;
end;
{$endif}
//TG2SoundBuffer END

//TG2SoundInst BEGIN
procedure TG2SoundInst.SetBuffer(const Value: TG2SoundBuffer);
begin
  if _Buffer <> Value then
  begin
    _Buffer := Value;
    {$if defined(G2Snd_DS)}
    SafeRelease(_SoundBuffer3D);
    SafeRelease(_SoundBuffer);
    TG2SndDS(g2.Snd)._Device.DuplicateSoundBuffer(
      _Buffer.GetBuffer, _SoundBuffer
    );
    _SoundBuffer.QueryInterface(IID_IDirectSound3DBuffer8, _SoundBuffer3D);
    _SoundBuffer3D.SetMode(DS3DMODE_HEADRELATIVE, DS3D_IMMEDIATE);
    {$elseif defined(G2Snd_OAL)}
    alSourcei(_Source, AL_BUFFER, _Buffer.GetBuffer);
    {$endif}
  end;
end;

procedure TG2SoundInst.SetPos(const Value: TG2Vec3);
{$ifdef G2Snd_OAL}
  var v: TG2Vec3;
{$endif}
begin
  _Pos := Value;
  {$if defined(G2Snd_DS)}
  _SoundBuffer3D.SetPosition(_Pos.x, _Pos.y, _Pos.z, DS3D_IMMEDIATE);
  {$elseif defined(G2Snd_OAL)}
  v.x := _Pos.x; v.y := _Pos.y; v.z := -_Pos.z;
  alSourcefv(_Source, AL_POSITION, @v);
  {$endif}
end;

procedure TG2SoundInst.SetVel(const Value: TG2Vec3);
{$ifdef G2Snd_OAL}
  var v: TG2Vec3;
{$endif}
begin
  _Vel := Value;
  {$if defined(G2Snd_DS)}
  _SoundBuffer3D.SetVelocity(_Vel.x, _Vel.y, _Vel.z, DS3D_IMMEDIATE);
  {$elseif defined(G2Snd_OAL)}
  v.x := _Pos.x; v.y := _Pos.y; v.z := -_Pos.z;
  alSourcefv(_Source, AL_VELOCITY, @v);
  {$endif}
end;

procedure TG2SoundInst.SetLoop(const Value: Boolean);
{$ifdef G2Snd_DS}
  var Flags: TG2IntU32;
{$endif}
begin
  if _Loop <> Value then
  begin
    _Loop := Value;
    {$if defined(G2Snd_DS)}
    if IsPlaying then
    begin
      if _Loop then Flags := DSBPLAY_LOOPING else Flags := 0;
      _SoundBuffer.Play(0, 0, Flags);
    end;
    {$elseif defined(G2Snd_OAL)}
    alSourcei(_Source, AL_LOOPING, TG2IntS32(loop));
    {$endif}
  end;
end;

procedure TG2SoundInst.Play;
{$ifdef G2Snd_DS}
  var Flags: TG2IntU32;
{$endif}
begin
  {$if defined(G2Snd_DS)}
  if _Loop then Flags := DSBPLAY_LOOPING else Flags := 0;
  if IsPlaying then Stop;
  _SoundBuffer.Play(0, 0, Flags);
  {$elseif defined(G2Snd_OAL)}
  alSourcePlay(_Source);
  {$endif}
end;

procedure TG2SoundInst.Pause;
begin
  {$if defined(G2Snd_DS)}
  _SoundBuffer.Stop;
  {$elseif defined(G2Snd_OAL)}
  alSourcePause(_Source);
  {$endif}
end;

procedure TG2SoundInst.Stop;
begin
  {$if defined(G2Snd_DS)}
  _SoundBuffer.Stop;
  _SoundBuffer.SetCurrentPosition(0);
  {$elseif defined(G2Snd_OAL)}
  alSourceStop(_Source);
  {$endif}
end;

function TG2SoundInst.IsPlaying: Boolean;
{$if defined(G2Snd_DS)}
  var Status: TG2IntU32;
{$elseif defined(G2Snd_OAL)}
  var Param: TALInt;
{$endif}
begin
  {$if defined(G2Snd_DS)}
  _SoundBuffer.GetStatus(Status);
  Result := Status and DSBSTATUS_PLAYING > 0;
  {$elseif defined(G2Snd_OAL)}
  alGetSourcei(_Source, AL_SOURCE_STATE, @Param);
  Result := Param = AL_PLAYING;
  {$endif}
end;

constructor TG2SoundInst.Create(const SoundBuffer: TG2SoundBuffer);
begin
  inherited Create;
  _Buffer := nil;
  _Pos := g2.Snd.ListenerPos;
  _Vel := g2.Snd.ListenerVel;
  _Loop := False;
  {$if defined(G2Snd_DS)}
  Buffer := SoundBuffer;
  {$elseif defined(G2Snd_OAL)}
  alGenSources(1, @_Source);
  Buffer := SoundBuffer;
  alSourcef(_Source, AL_PITCH, 1.0 );
  alSourcef(_Source, AL_GAIN, 1.0 );
  alSourcefv(_Source, AL_POSITION, @_Pos);
  alSourcefv(_Source, AL_VELOCITY, @_Vel);
  alSourcei(_Source, AL_LOOPING, TG2IntS32(_Loop));
  {$endif}
end;

destructor TG2SoundInst.Destroy;
begin
  Stop;
  {$if defined(G2Snd_DS)}
  SafeRelease(_SoundBuffer3D);
  SafeRelease(_SoundBuffer);
  {$elseif defined(G2Snd_OAL)}
  alDeleteSources(1, @_Source);
  {$endif}
  inherited Destroy;
end;
//TG2SoundInst END

//TG2Buffer BEGIN
procedure TG2Buffer.Initialize;
begin
  _Allocated := False;
  _Data := nil;
  _DataSize := 0;
end;

procedure TG2Buffer.Finalize;
begin
  Release;
end;

procedure TG2Buffer.Allocate(const Size: TG2IntU32);
begin
  Release;
  _Data := G2MemAlloc(Size);
  _Allocated := True;
  _DataSize := Size;
end;

procedure TG2Buffer.Release;
begin
  if _Allocated then
  begin
    G2MemFree(_Data, _DataSize);
    _Allocated := False;
  end;
end;
//TG2Buffer END

//TG2VertexBuffer BEGIN
{$if defined(G2Gfx_d3d9)}
procedure TG2VertexBuffer.WriteBufferData;
{$if defined(G2RM_FF)}
  var i, j, n: TG2IntS32;
  var p0, p1: PG2IntU8Arr;
begin
  p0 := Data;
  _VB.Lock(0, _VertexStride * _VertexCount, Pointer(p1), D3DLOCK_DISCARD);
  for i := 0 to _VertexCount - 1 do
  begin
    for j := 0 to High(_Decl) do
    begin
      if _VertexMapping[j].Enabled then
      begin
        for n := 0 to _VertexMapping[j].Count - 1 do
        _VertexMapping[j].ProcWrite(
          @p0^[n * _VertexMapping[j].SizeSrc],
          @p1^[_VertexMapping[j].StridePos + n * _VertexMapping[j].SizeDst]
        );
      end;
      p0 := PG2IntU8Arr(Pointer(p0) + _Decl[j].Count * 4);
    end;
    p1 := PG2IntU8Arr(Pointer(p1) + _VertexStride);
  end;
  _VB.Unlock;
end;
{$elseif defined(G2RM_SM2)}
  var p0: Pointer;
begin
  _VB.Lock(0, _VertexSize * _VertexCount, p0, D3DLOCK_DISCARD);
  Move(_Data^, p0^, _VertexSize * _VertexCount);
  _VB.Unlock;
end;
{$endif}
{$if defined(G2RM_FF)}
procedure TG2VertexBuffer.InitFVF;
  var i, tc, bi, bw: TG2IntS32;
  var CurPos, VDiffuseID, VNormalID, VIndexID, VWeightID: TG2IntS32;
  var PosFVF, PosSize, DiffuseSize, NormalSize: TG2IntU32;
  var TexCoordSize: array[0..7] of TG2IntU32;
  var VTexCoordID: array[0..7] of TG2IntS32;
begin
  _FVF := 0; _VertexStride := 0; PosFVF := 0;
  tc := 0; bi := 0; bw := 0;
  PosSize := 0;
  DiffuseSize := 0;
  NormalSize := 0;
  for i := 0 to High(TexCoordSize) do TexCoordSize[i] := 0;
  VDiffuseID := -1;
  VNormalID := -1;
  for i := 0 to High(VTexCoordID) do VTexCoordID[i] := -1;
  VIndexID := -1;
  VWeightID := -1;
  for i := 0 to High(_Decl) do
  case _Decl[i].Element of
    vbPosition:
    begin
      case _Decl[i].Count of
        3:
        begin
          PosFVF := D3DFVF_XYZ;
          PosSize := 12;
          _VertexMapping[i].Enabled := True;
          _VertexMapping[i].ProcWrite := @CopyFloatToFloat;
          _VertexMapping[i].StridePos := 0;
          _VertexMapping[i].Count := _Decl[i].Count;
          _VertexMapping[i].SizeDst := 4;
          _VertexMapping[i].SizeSrc := 4;
        end;
      end;
    end;
    vbDiffuse:
    begin
      case _Decl[i].Count of
        4:
        begin
          _FVF := _FVF or D3DFVF_DIFFUSE;
          _VertexStride := _VertexStride + 4;
          _VertexMapping[i].Enabled := True;
          _VertexMapping[i].ProcWrite := @CopyFloatToByteScale;
          _VertexMapping[i].Count := _Decl[i].Count;
          _VertexMapping[i].SizeDst := 1;
          _VertexMapping[i].SizeSrc := 4;
          DiffuseSize := 4;
          VDiffuseID := i;
        end;
      end;
    end;
    vbTexCoord:
    begin
      case _Decl[i].Count of
        1:
        begin
          _FVF := _FVF or D3DFVF_TEXCOORDSIZE1(tc);
          TexCoordSize[tc] := 4;
        end;
        2:
        begin
          _FVF := _FVF or D3DFVF_TEXCOORDSIZE2(tc);
          TexCoordSize[tc] := 8;
        end;
        3:
        begin
          _FVF := _FVF or D3DFVF_TEXCOORDSIZE3(tc);
          TexCoordSize[tc] := 12;
        end;
        4:
        begin
          _FVF := _FVF or D3DFVF_TEXCOORDSIZE4(tc);
          TexCoordSize[tc] := 16;
        end;
      end;
      if TexCoordSize[tc] > 0 then
      begin
        _VertexStride := _VertexStride + TexCoordSize[tc];
        _VertexMapping[i].Enabled := True;
        _VertexMapping[i].ProcWrite := @CopyFloatToFloat;
        _VertexMapping[i].Count := _Decl[i].Count;
        _VertexMapping[i].SizeDst := 4;
        _VertexMapping[i].SizeSrc := 4;
        VTexCoordID[tc] := i;
        Inc(tc);
      end;
    end;
    vbNormal:
    begin
      case _Decl[i].Count of
        3:
        begin
          _FVF := _FVF or D3DFVF_NORMAL;
          _VertexStride := _VertexStride + 12;
          _VertexMapping[i].Enabled := True;
          _VertexMapping[i].ProcWrite := @CopyFloatToFloat;
          _VertexMapping[i].Count := _Decl[i].Count;
          _VertexMapping[i].SizeDst := 4;
          _VertexMapping[i].SizeSrc := 4;
          NormalSize := 12;
          VNormalID := i;
        end;
      end;
    end;
    vbVertexIndex:
    begin
      bi := _Decl[i].Count;
      VIndexID := i;
      _VertexMapping[i].Count := _Decl[i].Count;
      _VertexMapping[i].SizeDst := 1;
      _VertexMapping[i].SizeSrc := 4;
    end;
    vbVertexWeight:
    begin
      bw := _Decl[i].Count;
      VWeightID := i;
      _VertexMapping[i].Count := _Decl[i].Count;
      _VertexMapping[i].SizeDst := 4;
      _VertexMapping[i].SizeSrc := 4;
    end;
  end;
  if tc > 0 then
  _FVF := _FVF or TG2IntU32(1 shl (tc + 7));
  if bw > 0 then
  begin
    case bw of
      1: if bi > 0 then
      begin
        PosFVF := PosFVF or D3DFVF_XYZB2 or D3DFVF_LASTBETA_UBYTE4;
        _VertexMapping[VIndexID].Enabled := True;
        _VertexMapping[VIndexID].ProcWrite := @CopyFloatToByte;
        _VertexMapping[VIndexID].StridePos := PosSize + 4;
        _VertexMapping[VWeightID].Enabled := True;
        _VertexMapping[VWeightID].ProcWrite := @CopyFloatToFloat;
        _VertexMapping[VWeightID].StridePos := PosSize;
        PosSize := 20;
      end
      else
      begin
        PosFVF := D3DFVF_XYZB1;
        _VertexMapping[VWeightID].Enabled := True;
        _VertexMapping[VWeightID].ProcWrite := @CopyFloatToFloat;
        _VertexMapping[VWeightID].StridePos := PosSize;
        PosSize := 16;
      end;
      2: if bi > 0 then
      begin
        PosFVF := PosFVF or D3DFVF_XYZB3 or D3DFVF_LASTBETA_UBYTE4;
        _VertexMapping[VIndexID].Enabled := True;
        _VertexMapping[VIndexID].ProcWrite := @CopyFloatToByte;
        _VertexMapping[VIndexID].StridePos := PosSize + 8;
        _VertexMapping[VWeightID].Enabled := True;
        _VertexMapping[VWeightID].ProcWrite := @CopyFloatToFloat;
        _VertexMapping[VWeightID].StridePos := PosSize;
        PosSize := 24;
      end
      else
      begin
        PosFVF := D3DFVF_XYZB2;
        _VertexMapping[VWeightID].Enabled := True;
        _VertexMapping[VWeightID].ProcWrite := @CopyFloatToFloat;
        _VertexMapping[VWeightID].StridePos := PosSize;
        PosSize := 20;
      end;
      3: if bi > 0 then
      begin
        PosFVF := PosFVF or D3DFVF_XYZB4 or D3DFVF_LASTBETA_UBYTE4;
        _VertexMapping[VIndexID].Enabled := True;
        _VertexMapping[VIndexID].ProcWrite := @CopyFloatToByte;
        _VertexMapping[VIndexID].StridePos := PosSize + 12;
        _VertexMapping[VWeightID].Enabled := True;
        _VertexMapping[VWeightID].ProcWrite := @CopyFloatToFloat;
        _VertexMapping[VWeightID].StridePos := PosSize;
        PosSize := 28;
      end
      else
      begin
        PosFVF := D3DFVF_XYZB3;
        _VertexMapping[VWeightID].Enabled := True;
        _VertexMapping[VWeightID].ProcWrite := @CopyFloatToFloat;
        _VertexMapping[VWeightID].StridePos := PosSize;
        PosSize := 24;
      end;
      4: if bi > 0 then
      begin
        PosFVF := PosFVF or D3DFVF_XYZB5 or D3DFVF_LASTBETA_UBYTE4;
        _VertexMapping[VIndexID].Enabled := True;
        _VertexMapping[VIndexID].ProcWrite := @CopyFloatToByte;
        _VertexMapping[VIndexID].StridePos := PosSize + 16;
        _VertexMapping[VWeightID].Enabled := True;
        _VertexMapping[VWeightID].ProcWrite := @CopyFloatToFloat;
        _VertexMapping[VWeightID].StridePos := PosSize;
        PosSize := 32;
      end
      else
      begin
        PosFVF := D3DFVF_XYZB4;
        _VertexMapping[VWeightID].Enabled := True;
        _VertexMapping[VWeightID].ProcWrite := @CopyFloatToFloat;
        _VertexMapping[VWeightID].StridePos := PosSize;
        PosSize := 28;
      end;
    end;
  end;
  _FVF := _FVF or PosFVF;
  _VertexStride := _VertexStride + PosSize;
  CurPos := PosSize;
  if VDiffuseID > -1 then _VertexMapping[VDiffuseID].StridePos := CurPos;
  CurPos := CurPos + TG2IntS32(DiffuseSize);
  if VNormalID > -1 then _VertexMapping[VNormalID].StridePos := CurPos;
  CurPos := CurPos + TG2IntS32(NormalSize);
  for i := 0 to High(VTexCoordID) do
  begin
    if VTexCoordID[i] = -1 then Break;
    _VertexMapping[VTexCoordID[i]].StridePos := CurPos;
    CurPos := CurPos + TG2IntS32(TexCoordSize[i]);
  end;
end;

procedure TG2VertexBuffer.CopyFloatToFloat(const Src, Dst: Pointer);
begin
  PG2Float(Dst)^ := PG2Float(Src)^;
end;

procedure TG2VertexBuffer.CopyFloatToByte(const Src, Dst: Pointer);
begin
  PG2IntU8(Dst)^ := Round(PG2Float(Src)^);
end;

procedure TG2VertexBuffer.CopyFloatToByteScale(const Src, Dst: Pointer);
begin
  PG2IntU8(Dst)^ := Round(PG2Float(Src)^ * 255);
end;
{$elseif defined(G2RM_SM2)}
procedure TG2VertexBuffer.InitDecl;
  var i, n, VBPos: TG2IntS32;
  var ve: array of TD3DVertexElement9;
  var IndPosition, IndColor, IndTexCoord, IndNormal, IndBinormal, IndTangent, IndSkinWeight, IndSkinIndex: TG2IntS32;
begin
  IndPosition := 0;
  IndColor := 0;
  IndTexCoord := 0;
  IndNormal := 0;
  IndBinormal := 0;
  IndTangent := 0;
  IndSkinWeight := 0;
  IndSkinIndex := 0;
  SetLength(ve, Length(_Decl) + 1);
  n := 0;
  VBPos := 0;
  for i := 0 to High(_Decl) do
  case _Decl[i].Element of
    vbPosition:
    begin
      case _Decl[i].Count of
        1:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT1, D3DDECLUSAGE_POSITION, IndPosition);
          Inc(n); Inc(VBPos, 4); Inc(IndPosition);
        end;
        2:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT2, D3DDECLUSAGE_POSITION, IndPosition);
          Inc(n); Inc(VBPos, 8); Inc(IndPosition);
        end;
        3:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT3, D3DDECLUSAGE_POSITION, IndPosition);
          Inc(n); Inc(VBPos, 12); Inc(IndPosition);
        end;
        4:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT4, D3DDECLUSAGE_POSITION, IndPosition);
          Inc(n); Inc(VBPos, 16); Inc(IndPosition);
        end;
      end;
    end;
    vbDiffuse:
    begin
      case _Decl[i].Count of
        1:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT1, D3DDECLUSAGE_COLOR, IndColor);
          Inc(n); Inc(VBPos, 4); Inc(IndColor);
        end;
        2:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT2, D3DDECLUSAGE_COLOR, IndColor);
          Inc(n); Inc(VBPos, 8); Inc(IndColor);
        end;
        3:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT3, D3DDECLUSAGE_COLOR, IndColor);
          Inc(n); Inc(VBPos, 12); Inc(IndColor);
        end;
        4:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT4, D3DDECLUSAGE_COLOR, IndColor);
          Inc(n); Inc(VBPos, 16); Inc(IndColor);
        end;
      end;
    end;
    vbTexCoord:
    begin
      case _Decl[i].Count of
        1:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT1, D3DDECLUSAGE_TEXCOORD, IndTexCoord);
          Inc(n); Inc(VBPos, 4); Inc(IndTexCoord);
        end;
        2:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT2, D3DDECLUSAGE_TEXCOORD, IndTexCoord);
          Inc(n); Inc(VBPos, 8); Inc(IndTexCoord);
        end;
        3:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT3, D3DDECLUSAGE_TEXCOORD, IndTexCoord);
          Inc(n); Inc(VBPos, 12); Inc(IndTexCoord);
        end;
        4:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT4, D3DDECLUSAGE_TEXCOORD, IndTexCoord);
          Inc(n); Inc(VBPos, 16); Inc(IndTexCoord);
        end;
      end;
    end;
    vbNormal:
    begin
      case _Decl[i].Count of
        1:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT1, D3DDECLUSAGE_NORMAL, IndNormal);
          Inc(n); Inc(VBPos, 4); Inc(IndNormal);
        end;
        2:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT2, D3DDECLUSAGE_NORMAL, IndNormal);
          Inc(n); Inc(VBPos, 8); Inc(IndNormal);
        end;
        3:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT3, D3DDECLUSAGE_NORMAL, IndNormal);
          Inc(n); Inc(VBPos, 12); Inc(IndNormal);
        end;
        4:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT4, D3DDECLUSAGE_NORMAL, IndNormal);
          Inc(n); Inc(VBPos, 16); Inc(IndNormal);
        end;
      end;
    end;
    vbBinormal:
    begin
      case _Decl[i].Count of
        1:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT1, D3DDECLUSAGE_BINORMAL, IndBinormal);
          Inc(n); Inc(VBPos, 4); Inc(IndBinormal);
        end;
        2:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT2, D3DDECLUSAGE_BINORMAL, IndBinormal);
          Inc(n); Inc(VBPos, 8); Inc(IndBinormal);
        end;
        3:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT3, D3DDECLUSAGE_BINORMAL, IndBinormal);
          Inc(n); Inc(VBPos, 12); Inc(IndBinormal);
        end;
        4:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT4, D3DDECLUSAGE_BINORMAL, IndBinormal);
          Inc(n); Inc(VBPos, 16); Inc(IndBinormal);
        end;
      end;
    end;
    vbTangent:
    begin
      case _Decl[i].Count of
        1:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT1, D3DDECLUSAGE_TANGENT, IndTangent);
          Inc(n); Inc(VBPos, 4); Inc(IndTangent);
        end;
        2:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT2, D3DDECLUSAGE_TANGENT, IndTangent);
          Inc(n); Inc(VBPos, 8); Inc(IndTangent);
        end;
        3:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT3, D3DDECLUSAGE_TANGENT, IndTangent);
          Inc(n); Inc(VBPos, 12); Inc(IndTangent);
        end;
        4:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT4, D3DDECLUSAGE_TANGENT, IndTangent);
          Inc(n); Inc(VBPos, 16); Inc(IndTangent);
        end;
      end;
    end;
    vbVertexWeight:
    begin
      case _Decl[i].Count of
        1:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT1, D3DDECLUSAGE_BLENDWEIGHT, IndSkinWeight);
          Inc(n); Inc(VBPos, 4); Inc(IndSkinWeight);
        end;
        2:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT2, D3DDECLUSAGE_BLENDWEIGHT, IndSkinWeight);
          Inc(n); Inc(VBPos, 8); Inc(IndSkinWeight);
        end;
        3:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT3, D3DDECLUSAGE_BLENDWEIGHT, IndSkinWeight);
          Inc(n); Inc(VBPos, 12); Inc(IndSkinWeight);
        end;
        4:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT4, D3DDECLUSAGE_BLENDWEIGHT, IndSkinWeight);
          Inc(n); Inc(VBPos, 16); Inc(IndSkinWeight);
        end;
      end;
    end;
    vbVertexIndex:
    begin
      case _Decl[i].Count of
        1:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT1, D3DDECLUSAGE_BLENDINDICES, IndSkinIndex);
          Inc(n); Inc(VBPos, 4); Inc(IndSkinIndex);
        end;
        2:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT2, D3DDECLUSAGE_BLENDINDICES, IndSkinIndex);
          Inc(n); Inc(VBPos, 8); Inc(IndSkinIndex);
        end;
        3:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT3, D3DDECLUSAGE_BLENDINDICES, IndSkinIndex);
          Inc(n); Inc(VBPos, 12); Inc(IndSkinIndex);
        end;
        4:
        begin
          ve[n] := D3DVertexElement(VBPos, D3DDECLTYPE_FLOAT4, D3DDECLUSAGE_BLENDINDICES, IndSkinIndex);
          Inc(n); Inc(VBPos, 16); Inc(IndSkinIndex);
        end;
      end;
    end;
  end;
  if Length(ve) <> n + 1 then
  SetLength(ve, n + 1);
  ve[n] := D3DDECL_END;
  _Gfx.Device.CreateVertexDeclaration(@ve[0], _DeclD3D);
end;
{$endif}

procedure TG2VertexBuffer.Initialize;
  var i: TG2IntS32;
begin
  inherited Initialize;
  _VertexSize := 0;
  for i := 0 to High(_Decl) do
  begin
    if _Decl[i].Element <> vbNone then
    _VertexSize := _VertexSize + TG2IntU32(_Decl[i].Count * 4);
  end;
  Allocate(_VertexSize * _VertexCount);
  {$if defined(G2RM_FF)}
  SetLength(_VertexMapping, Length(_Decl));
  for i := 0 to High(_VertexMapping) do
  _VertexMapping[i].Enabled := False;
  InitFVF;
  _Gfx.Device.CreateVertexBuffer(
    _VertexStride * _VertexCount,
    D3DUSAGE_WRITEONLY, _FVF, D3DPOOL_MANAGED,
    _VB, nil
  );
  {$elseif defined(G2RM_SM2)}
  InitDecl;
  _Gfx.Device.CreateVertexBuffer(
    _VertexSize * _VertexCount,
    D3DUSAGE_WRITEONLY, 0, D3DPOOL_MANAGED,
    _VB, nil
  );
  {$endif}
  _Locked := False;
end;

procedure TG2VertexBuffer.Finalize;
begin
  {$if defined(G2RM_SM2)}
  SafeRelease(_DeclD3D);
  {$endif}
  SafeRelease(_VB);
  Release;
  inherited Finalize;
end;

procedure TG2VertexBuffer.Lock(const LockMode: TG2BufferLockMode = lmReadWrite);
begin
  if _Locked then UnLock;
  _LockMode := LockMode;
  _Locked := True;
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
begin
  {$if defined(G2RM_FF)}
  _Gfx.Device.SetFVF(_FVF);
  _Gfx.Device.SetStreamSource(0, _VB, 0, _VertexStride);
  {$elseif defined(G2RM_SM2)}
  _Gfx.Device.SetVertexDeclaration(_DeclD3D);
  _Gfx.Device.SetStreamSource(0, _VB, 0, _VertexSize);
  {$endif}
end;

procedure TG2VertexBuffer.Unbind;
begin

end;

constructor TG2VertexBuffer.Create(const Decl: TG2VBDecl; const Count: TG2IntU32);
begin
  _Gfx := TG2GfxD3D9(g2.Gfx);
  _Decl := Decl;
  _VertexCount := Count;
  inherited Create;
end;
{$elseif defined(G2Gfx_OGL)}
function TG2VertexBuffer.GetTexCoordIndex(const Index: TG2IntS32): Pointer;
begin
  Result := _TexCoordIndex[Index];
end;

procedure TG2VertexBuffer.WriteBufferData;
begin
  _Gfx.ThreadAttach;
  glBindBuffer(GL_ARRAY_BUFFER, _VB);
  glBufferSubData(GL_ARRAY_BUFFER, 0, _VertexCount * _VertexSize, Data);
  _Gfx.ThreadDetach;
end;

procedure TG2VertexBuffer.Initialize;
  var i, ti: TG2IntS32;
begin
  inherited Initialize;
  _Gfx.ThreadAttach;
  _VertexSize := 0;
  ti := 0;
  for i := 0 to High(_Decl) do
  if _Decl[i].Element <> vbNone then
  begin
    if _Decl[i].Element = vbTexCoord then
    begin
      _TexCoordIndex[ti] := Pointer(_VertexSize);
      Inc(ti);
    end;
    _VertexSize := _VertexSize + TG2IntU32(_Decl[i].Count * 4);
  end;
  for i := ti to High(_TexCoordIndex) do
  _TexCoordIndex[i] := nil;
  Allocate(_VertexCount * _VertexSize);
  glGenBuffers(1, @_VB);
  glBindBuffer(GL_ARRAY_BUFFER, _VB);
  glBufferData(GL_ARRAY_BUFFER, _VertexCount * _VertexSize, nil, GL_STATIC_DRAW);
  {$if defined(G2RM_SM2)}
  _BoundAttribs.Clear;
  {$endif}
  _Gfx.ThreadDetach;
  _Locked := False;
end;

procedure TG2VertexBuffer.Finalize;
begin
  glDeleteBuffers(1, @_VB);
  Release;
  inherited Finalize;
end;

procedure TG2VertexBuffer.Lock(const LockMode: TG2BufferLockMode = lmReadWrite);
begin
  if _Locked then UnLock;
  _LockMode := LockMode;
  _Locked := True;
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
{$if defined(G2RM_FF)}
  var i: TG2IntS32;
  var BufferPos: TG2IntU32;
  var CurTexture: TG2IntU32;
begin
  _Gfx.ThreadAttach;
  glBindBuffer(GL_ARRAY_BUFFER, _VB);
  BufferPos := 0;
  CurTexture := GL_TEXTURE0;
  for i := 0 to High(_Decl) do
  begin
    case _Decl[i].Element of
      vbPosition:
      begin
        glEnableClientState(GL_VERTEX_ARRAY);
        glVertexPointer(_Decl[i].Count, GL_FLOAT, _VertexSize, PGLVoid(BufferPos));
        Inc(BufferPos, _Decl[i].Count * 4);
      end;
      vbNormal:
      begin
        glEnableClientState(GL_NORMAL_ARRAY);
        glNormalPointer(GL_FLOAT, _VertexSize, PGLVoid(BufferPos));
        Inc(BufferPos, _Decl[i].Count * 4);
      end;
      vbDiffuse:
      begin
        glEnableClientState(GL_COLOR_ARRAY);
        glColorPointer(_Decl[i].Count, GL_FLOAT, _VertexSize, PGLVoid(BufferPos));
        Inc(BufferPos, _Decl[i].Count * 4);
      end;
      vbTexCoord:
      begin
        glClientActiveTexture(CurTexture);
        Inc(CurTexture);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glTexCoordPointer(_Decl[i].Count, GL_FLOAT, _VertexSize, PGLVoid(BufferPos));
        Inc(BufferPos, _Decl[i].Count * 4);
      end;
      else
      begin
        Inc(BufferPos, _Decl[i].Count * 4);
      end;
    end;
  end;
  glClientActiveTexture(GL_TEXTURE0);
  _Gfx.ThreadDetach;
end;
{$elseif defined(G2RM_SM2)}
  function GetAttribIndex(const Attrib: AnsiString): GLInt;
  begin
    if _Gfx.ShaderMethod = nil then
    begin
      Result := -1;
      Exit;
    end;
    Result := glGetAttribLocation(_Gfx.ShaderMethod^.ShaderProgram, PAnsiChar(Attrib));
  end;
  var i: TG2IntS32;
  var VBPos: TG2IntU32;
  var IndPosition, IndColor, IndTexCoord, IndNormal, IndBinormal, IndTangent, IndBlendWeight, IndBlendIndex: TG2IntS32;
  var ai: GLInt;
begin
  _Gfx.ThreadAttach;
  glBindBuffer(GL_ARRAY_BUFFER, _VB);
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
      ai := GetAttribIndex('a_Position' + IntToStr(IndPosition));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        glEnableVertexAttribArray(ai);
        glVertexAttribPointer(ai, _Decl[i].Count, GL_FLOAT, False, _VertexSize, Pointer(VBPos));
      end;
      Inc(IndPosition);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbDiffuse:
    begin
      ai := GetAttribIndex('a_Color' + IntToStr(IndColor));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        glEnableVertexAttribArray(ai);
        glVertexAttribPointer(ai, _Decl[i].Count, GL_FLOAT, False, _VertexSize, Pointer(VBPos));
      end;
      Inc(IndPosition);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbTexCoord:
    begin
      ai := GetAttribIndex('a_TexCoord' + IntToStr(IndTexCoord));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        glEnableVertexAttribArray(ai);
        glVertexAttribPointer(ai, _Decl[i].Count, GL_FLOAT, False, _VertexSize, Pointer(VBPos));
      end;
      Inc(IndTexCoord);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbNormal:
    begin
      ai := GetAttribIndex('a_Normal' + IntToStr(IndNormal));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        glEnableVertexAttribArray(ai);
        glVertexAttribPointer(ai, _Decl[i].Count, GL_FLOAT, False, _VertexSize, Pointer(VBPos));
      end;
      Inc(IndNormal);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbBinormal:
    begin
      ai := GetAttribIndex('a_Binormal' + IntToStr(IndBinormal));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        glEnableVertexAttribArray(ai);
        glVertexAttribPointer(ai, _Decl[i].Count, GL_FLOAT, False, _VertexSize, Pointer(VBPos));
      end;
      Inc(IndBinormal);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbTangent:
    begin
      ai := GetAttribIndex('a_Tangent' + IntToStr(IndTangent));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        glEnableVertexAttribArray(ai);
        glVertexAttribPointer(ai, _Decl[i].Count, GL_FLOAT, False, _VertexSize, Pointer(VBPos));
      end;
      Inc(IndTangent);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbVertexWeight:
    begin
      ai := GetAttribIndex('a_BlendWeight' + IntToStr(IndBlendWeight));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        glEnableVertexAttribArray(ai);
        glVertexAttribPointer(ai, _Decl[i].Count, GL_FLOAT, False, _VertexSize, Pointer(VBPos));
      end;
      Inc(IndBlendWeight);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    vbVertexIndex:
    begin
      ai := GetAttribIndex('a_BlendIndex' + IntToStr(IndBlendIndex));
      if ai > -1 then
      begin
        _BoundAttribs.Add(ai);
        glEnableVertexAttribArray(ai);
        glVertexAttribPointer(ai, _Decl[i].Count, GL_FLOAT, False, _VertexSize, Pointer(VBPos));
      end;
      Inc(IndBlendIndex);
      Inc(VBPos, _Decl[i].Count * 4);
    end;
    else
    begin
      Inc(VBPos, _Decl[i].Count * 4);
    end;
  end;
  _Gfx.ThreadDetach;
end;
{$endif}

procedure TG2VertexBuffer.Unbind;
{$if defined(G2RM_FF)}
  var i: TG2IntS32;
  var CurTexture: TG2IntU32;
begin
  _Gfx.ThreadAttach;
  CurTexture := GL_TEXTURE0;
  for i := 0 to High(_Decl) do
  begin
    case _Decl[i].Element of
      vbPosition:
      begin
        glDisableClientState(GL_VERTEX_ARRAY);
      end;
      vbNormal:
      begin
        glDisableClientState(GL_NORMAL_ARRAY);
      end;
      vbDiffuse:
      begin
        glDisableClientState(GL_COLOR_ARRAY);
      end;
      vbTexCoord:
      begin
        glClientActiveTexture(CurTexture);
        Inc(CurTexture);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
      end;
    end;
  end;
  glClientActiveTexture(GL_TEXTURE0);
  _Gfx.ThreadDetach;
end;
{$elseif defined(G2RM_SM2)}
  var i: TG2IntS32;
begin
  _Gfx.ThreadAttach;
  for i := 0 to _BoundAttribs.Count - 1 do
  glDisableVertexAttribArray(_BoundAttribs[i]);
  _BoundAttribs.Clear;
  _Gfx.ThreadDetach;
end;
{$endif}

constructor TG2VertexBuffer.Create(const Decl: TG2VBDecl; const Count: TG2IntU32);
begin
  _Gfx := TG2GfxOGL(g2.Gfx);
  _Decl := Decl;
  _VertexCount := Count;
  inherited Create;
end;
{$elseif defined(G2Gfx_GLES)}
function TG2VertexBuffer.GetTexCoordIndex(const Index: TG2IntS32): Pointer;
begin
  Result := _TexCoordIndex[Index];
end;

procedure TG2VertexBuffer.WriteBufferData;
begin
  _Gfx.ThreadAttach;
  glBindBuffer(GL_ARRAY_BUFFER, _VB);
  glBufferSubData(GL_ARRAY_BUFFER, PGLInt(0), _VertexCount * _VertexSize, Data);
  glBindBuffer(GL_ARRAY_BUFFER, 0);
  _Gfx.ThreadDetach;
end;

procedure TG2VertexBuffer.Initialize;
  var i, ti: TG2IntS32;
begin
  inherited Initialize;
  _VertexSize := 0;
  ti := 0;
  for i := 0 to High(_Decl) do
  if _Decl[i].Element <> vbNone then
  begin
    if _Decl[i].Element = vbTexCoord then
    begin
      _TexCoordIndex[ti] := Pointer(_VertexSize);
      Inc(ti);
    end;
    _VertexSize := _VertexSize + TG2IntU32(_Decl[i].Count * 4);
  end;
  for i := ti to High(_TexCoordIndex) do
  _TexCoordIndex[i] := nil;
  Allocate(_VertexCount * _VertexSize);
  _Gfx.ThreadAttach;
  glGenBuffers(1, @_VB);
  glBindBuffer(GL_ARRAY_BUFFER, _VB);
  glBufferData(GL_ARRAY_BUFFER, _VertexCount * _VertexSize, nil, GL_STATIC_DRAW);
  _Gfx.ThreadDetach;
  _Locked := False;
end;

procedure TG2VertexBuffer.Finalize;
begin
  _Gfx.ThreadAttach;
  glDeleteBuffers(1, @_VB);
  _Gfx.ThreadDetach;
  Release;
  inherited Finalize;
end;

procedure TG2VertexBuffer.Lock(const LockMode: TG2BufferLockMode = lmReadWrite);
begin
  if _Locked then UnLock;
  _LockMode := LockMode;
  _Locked := True;
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
  var i: TG2IntS32;
  var BufferPos: TG2IntU32;
  var CurTexture: TG2IntU32;
begin
  glBindBuffer(GL_ARRAY_BUFFER, _VB);
  BufferPos := 0;
  CurTexture := GL_TEXTURE0;
  for i := 0 to High(_Decl) do
  begin
    case _Decl[i].Element of
      vbPosition:
      begin
        glEnableClientState(GL_VERTEX_ARRAY);
        glVertexPointer(_Decl[i].Count, GL_FLOAT, _VertexSize, PGLVoid(BufferPos));
        Inc(BufferPos, _Decl[i].Count * 4);
      end;
      vbNormal:
      begin
        glEnableClientState(GL_NORMAL_ARRAY);
        glNormalPointer(GL_FLOAT, _VertexSize, PGLVoid(BufferPos));
        Inc(BufferPos, _Decl[i].Count * 4);
      end;
      vbDiffuse:
      begin
        glEnableClientState(GL_COLOR_ARRAY);
        glColorPointer(_Decl[i].Count, GL_FLOAT, _VertexSize, PGLVoid(BufferPos));
        Inc(BufferPos, _Decl[i].Count * 4);
      end;
      vbTexCoord:
      begin
        glClientActiveTexture(CurTexture);
        Inc(CurTexture);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        glTexCoordPointer(_Decl[i].Count, GL_FLOAT, _VertexSize, PGLVoid(BufferPos));
        Inc(BufferPos, _Decl[i].Count * 4);
      end;
      else
      begin
        Inc(BufferPos, _Decl[i].Count * 4);
      end;
    end;
  end;
  glClientActiveTexture(GL_TEXTURE0);
end;

procedure TG2VertexBuffer.Unbind;
  var i: TG2IntS32;
  var CurTexture: TG2IntU32;
begin
  CurTexture := GL_TEXTURE0;
  for i := 0 to High(_Decl) do
  begin
    case _Decl[i].Element of
      vbPosition:
      begin
        glDisableClientState(GL_VERTEX_ARRAY);
      end;
      vbNormal:
      begin
        glDisableClientState(GL_NORMAL_ARRAY);
      end;
      vbDiffuse:
      begin
        glDisableClientState(GL_COLOR_ARRAY);
      end;
      vbTexCoord:
      begin
        glClientActiveTexture(CurTexture);
        Inc(CurTexture);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
      end;
    end;
  end;
  glClientActiveTexture(GL_TEXTURE0);
  glBindBuffer(GL_ARRAY_BUFFER, 0);
end;

constructor TG2VertexBuffer.Create(const Decl: TG2VBDecl; const Count: TG2IntU32);
begin
  _Gfx := TG2GfxGLES(g2.Gfx);
  _Decl := Decl;
  _VertexCount := Count;
  inherited Create;
end;
{$endif}
//TG2VertexBuffer END

//TG2IndexBuffer BEGIN
{$if defined(G2Gfx_D3D9)}
procedure TG2IndexBuffer.WriteBufferData;
  var IBData: Pointer;
begin
  _IB.Lock(0, _IndexCount * 2, IBData, D3DLOCK_DISCARD);
  Move(Data^, IBData^, _IndexCount * 2);
  _IB.Unlock;
end;

procedure TG2IndexBuffer.Initialize;
begin
  _Locked := False;
  _LockMode := lmNone;
  Allocate(_IndexCount * 2);
  _Gfx.Device.CreateIndexBuffer(
    _IndexCount * 2, D3DUSAGE_WRITEONLY,
    D3DFMT_INDEX16, D3DPOOL_MANAGED,
    _IB, nil
  );
end;

procedure TG2IndexBuffer.Finalize;
begin
  SafeRelease(_IB);
  Release;
end;

procedure TG2IndexBuffer.Lock(const LockMode: TG2BufferLockMode = lmReadWrite);
begin
  if _Locked then UnLock;
  _LockMode := LockMode;
  _Locked := True;
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
  _Gfx.Device.SetIndices(_IB);
end;

procedure TG2IndexBuffer.Unbind;
begin

end;

constructor TG2IndexBuffer.Create(const Count: TG2IntU32);
begin
  _Gfx := TG2GfxD3D9(g2.Gfx);
  _IndexCount := Count;
  inherited Create;
end;
{$elseif defined(G2Gfx_OGL)}
procedure TG2IndexBuffer.WriteBufferData;
begin
  _Gfx.ThreadAttach;
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _IB);
  glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, _IndexCount * 2, Data);
  _Gfx.ThreadDetach;
end;

procedure TG2IndexBuffer.Initialize;
begin
  inherited Initialize;
  _Locked := False;
  _LockMode := lmNone;
  Allocate(_IndexCount * 2);
  _Gfx.ThreadAttach;
  glGenBuffers(1, @_IB);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _IB);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, _IndexCount * 2, nil, GL_STATIC_DRAW);
  _Gfx.ThreadDetach;
end;

procedure TG2IndexBuffer.Finalize;
begin
  _Gfx.ThreadAttach;
  glDeleteBuffers(1, @_IB);
  _Gfx.ThreadDetach;
  Release;
  inherited Finalize;
end;

procedure TG2IndexBuffer.Lock(const LockMode: TG2BufferLockMode = lmReadWrite);
begin
  if _Locked then UnLock;
  _LockMode := LockMode;
  _Locked := True;
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
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _IB);
end;

procedure TG2IndexBuffer.Unbind;
begin

end;

constructor TG2IndexBuffer.Create(const Count: TG2IntU32);
begin
  _Gfx := TG2GfxOGL(g2.Gfx);
  _IndexCount := Count;
  inherited Create;
end;
{$elseif defined(G2Gfx_GLES)}
procedure TG2IndexBuffer.WriteBufferData;
begin
  _Gfx.ThreadAttach;
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _IB);
  glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, PGLInt(0), _IndexCount * 2, Data);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
  _Gfx.ThreadDetach;
end;

procedure TG2IndexBuffer.Initialize;
begin
  inherited Initialize;
  _Locked := False;
  _LockMode := lmNone;
  Allocate(_IndexCount * 2);
  _Gfx.ThreadAttach;
  glGenBuffers(1, @_IB);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _IB);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, _IndexCount * 2, nil, GL_STATIC_DRAW);
  _Gfx.ThreadDetach;
end;

procedure TG2IndexBuffer.Finalize;
begin
  _Gfx.ThreadAttach;
  glDeleteBuffers(1, @_IB);
  _Gfx.ThreadDetach;
  Release;
  inherited Finalize;
end;

procedure TG2IndexBuffer.Lock(const LockMode: TG2BufferLockMode = lmReadWrite);
begin
  if _Locked then UnLock;
  _LockMode := LockMode;
  _Locked := True;
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
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _IB);
end;

procedure TG2IndexBuffer.Unbind;
begin
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
end;

constructor TG2IndexBuffer.Create(const Count: TG2IntU32);
begin
  _Gfx := TG2GfxGLES(g2.Gfx);
  _IndexCount := Count;
  inherited Create;
end;
{$endif}
//TG2IndexBuffer END

//TG2Font BEGIN
procedure TG2Font.Initialize;
begin
  _Texture := TG2Texture2D.Create;
end;

procedure TG2Font.Finalize;
begin
  _Texture.Free;
end;

function TG2Font.GetProps(const Index: TG2IntU8): TG2FontCharProps;
begin
  Result := _Props[Index];
end;

class function TG2Font.SharedAsset(const SharedAssetName: String): TG2Font;
  var Res: TG2Res;
  var dm: TG2DataManager;
begin
  Res := TG2Res.List;
  while Res <> nil do
  begin
    if (Res is TG2Font)
    and (TG2Texture2D(Res).AssetName = SharedAssetName)
    and (Res.RefCount > 0) then
    begin
      Result := TG2Font(Res);
      Exit;
    end;
    Res := Res.Next;
  end;
  dm := TG2DataManager.Create(SharedAssetName, dmAsset);
  Result := TG2Font.Create;
  Result.AssetName := SharedAssetName;
  Result.Load(dm);
  dm.Free;
end;

function TG2Font.TextWidth(const Text: AnsiString): TG2IntS32;
  var i: TG2IntS32;
begin
  Result := 0;
  for i := 1 to Length(Text) do
  Result := Result + _Props[Ord(Text[i])].Width;
end;

function TG2Font.TextWidth(const Text: AnsiString; const PosStart, PosEnd: TG2IntS32): TG2IntS32;
  var i: TG2IntS32;
begin
  Result := 0;
  for i := PosStart to G2Min(PosEnd, Length(Text)) do
  Result := Result + _Props[Ord(Text[i])].Width;
end;

function TG2Font.TextHeight(const Text: AnsiString): TG2IntS32;
  var i: TG2IntS32;
  var b: TG2IntU8;
begin
  Result := 0;
  for i := 1 to Length(Text) do
  begin
    b := Ord(Text[i]);
    if _Props[b].Height > Result then
    Result := _Props[b].Height;
  end;
end;

procedure TG2Font.Make(const Size: TG2IntS32; const Face: AnsiString = {$ifdef G2Target_Linux}'Serif'{$else}'Times New Roman'{$endif});
{$if defined(G2Target_Windows)}
  type TARGB = packed record
    b, g, r, a: TG2IntU8;
  end;
  type TARGBArr = array[Word] of TARGB;
  type PARGBArr = ^TARGBArr;
  var dc: HDC;
  var Font: HFont;
  var Bitmap: HBitmap;
  var bmi: TBitmapInfo;
  var BitmapBits: Pointer;
  var i, x, y: TG2IntS32;
  var MapWidth, MapHeight: TG2IntS32;
  var TexWidth, TexHeight: TG2IntS32;
  var MaxWidth, MaxHeight: TG2IntS32;
  var CharSize: TSize;
  {$ifdef G2Gfx_D3D9}
  var lr: TD3DLockedRect;
  {$else}
  var TextureData: Pointer;
  {$endif}
begin
  AssetName := '';
  {$ifdef G2Gfx_D3D9}
  MaxWidth := TG2GfxD3D9(g2.Gfx).Caps.MaxTextureWidth; if MaxWidth > 2048 then MaxWidth := 2048;
  MaxHeight := TG2GfxD3D9(g2.Gfx).Caps.MaxTextureHeight; if MaxHeight > 2048 then MaxHeight := 2048;
  {$else}
  MaxWidth := 2048; MaxHeight := 2048;
  {$endif}
  dc := CreateCompatibleDC(0);
  SetMapMode(dc, MM_TEXT);
  Font := CreateFontA(
    Size, 0, 0, 0,
    FW_NORMAL, 0, 0, 0,
    DEFAULT_CHARSET,
    OUT_DEFAULT_PRECIS,
    CLIP_DEFAULT_PRECIS,
    ANTIALIASED_QUALITY,
    VARIABLE_PITCH,
    PAnsiChar(Face)
  );
  SelectObject(dc, Font);
  _CharSpaceX := 0;
  _CharSpaceY := 0;
  for i := 0 to 255 do
  begin
    GetTextExtentPoint32A(dc, PAnsiChar(@i), 1, CharSize{%H-});
    if CharSize.cx > _CharSpaceX then _CharSpaceX := CharSize.cx;
    if CharSize.cy > _CharSpaceY then _CharSpaceY := CharSize.cy;
  end;
  MapWidth := TG2IntS32(_CharSpaceX * 16);
  MapHeight := TG2IntS32(_CharSpaceY * 16);
  TexWidth := 1; while TexWidth < MapWidth do TexWidth := TexWidth shl 1; if TexWidth > MaxWidth then TexWidth := MaxWidth;
  TexHeight := 1; while TexHeight < MapHeight do TexHeight := TexHeight shl 1; if TexHeight > MaxHeight then TexHeight := MaxHeight;
  _CharSpaceX := TexWidth div 16;
  _CharSpaceY := TexHeight div 16;
  ZeroMemory(@bmi.bmiHeader, SizeOf(TBitmapInfoHeader));
  bmi.bmiHeader.biSize := SizeOf(TBitmapInfoHeader);
  bmi.bmiHeader.biWidth :=  TexWidth;
  bmi.bmiHeader.biHeight := -TexHeight;
  bmi.bmiHeader.biPlanes := 1;
  bmi.bmiHeader.biCompression := BI_RGB;
  bmi.bmiHeader.biBitCount := 32;
  Bitmap := CreateDIBSection(
    dc,
    bmi,
    DIB_RGB_COLORS,
    Pointer(BitmapBits){%H-},
    0, 0
  );
  SelectObject(dc, Bitmap);
  SetTextColor(dc, $ffffff);
  SetBkColor(dc, $00000000);
  SetTextAlign(dc, TA_TOP);
  for y := 0 to 15 do
  for x := 0 to 15 do
  begin
    i := x + y * 16;
    GetTextExtentPoint32A(dc, PAnsiChar(@i), 1, CharSize);
    _Props[i].Width := CharSize.cx;
    _Props[i].Height := CharSize.cy;
    _Props[i].OffsetX := (_CharSpaceX - _Props[i].Width) div 2;
    _Props[i].OffsetY := (_CharSpaceY - _Props[i].Height) div 2;
    ExtTextOut(
      dc,
      x * _CharSpaceX + _Props[i].OffsetX,
      y * _CharSpaceY + _Props[i].OffsetY,
      ETO_OPAQUE,
      nil,
      PAnsiChar(@i),
      1,
      nil
    );
  end;
  {$ifdef G2Gfx_D3D9}
  TG2GfxD3D9(g2.Gfx).Device.CreateTexture(
    TexWidth, TexHeight, 1, 0,
    D3DFMT_A8R8G8B8,
    D3DPOOL_MANAGED,
    IDirect3DTexture9(_Texture._Texture),
    nil
  );
  _Texture.GetTexture.LockRect(0, lr, nil, D3DLOCK_DISCARD);
  for y := 0 to TexWidth - 1 do
  for x := 0 to TexHeight - 1 do
  begin
    i := y * TexWidth + x;
    PARGBArr(lr.pBits)^[i].a := PARGBArr(BitmapBits)^[i].r;
    PARGBArr(lr.pBits)^[i].r := $ff;
    PARGBArr(lr.pBits)^[i].g := $ff;
    PARGBArr(lr.pBits)^[i].b := $ff;
  end;
  _Texture.GetTexture.UnlockRect(0);
  {$else}
  GetMem(TextureData, TexWidth * TexHeight * 4);
  for y := 0 to TexWidth - 1 do
  for x := 0 to TexHeight - 1 do
  begin
    i := y * TexWidth + x;
    PARGBArr(TextureData)^[i].a := PARGBArr(BitmapBits)^[i].r;
    PARGBArr(TextureData)^[i].r := $ff;
    PARGBArr(TextureData)^[i].g := $ff;
    PARGBArr(TextureData)^[i].b := $ff;
  end;
  TG2GfxOGL(g2.Gfx).ThreadAttach;
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  glGenTextures(1, @_Texture._Texture);
  glBindTexture(GL_TEXTURE_2D, _Texture._Texture);
  glTexImage2D(
    GL_TEXTURE_2D,
    0,
    GL_RGBA,
    TexWidth,
    TexHeight,
    0,
    GL_RGBA,
    GL_UNSIGNED_BYTE,
    TextureData
  );
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  TG2GfxOGL(g2.Gfx).ThreadDetach;
  FreeMem(TextureData, TexWidth * TexHeight * 4);
  {$endif}
  DeleteObject(Font);
  DeleteObject(Bitmap);
  DeleteDC(dc);
{$elseif defined(G2Target_Linux)}
  type TARGB = packed record
    b, g, r, a: TG2IntU8;
  end;
  type PARGB = ^TARGB;
  type TARGBArr = array[Word] of TARGB;
  type PARGBArr = ^TARGBArr;
  var TexWidth, TexHeight: TG2IntS32;
  var MaxWidth, MaxHeight: TG2IntS32;
  var MapWidth, MapHeight: TG2IntS32;
  var Pixmap: PGdkPixmap;
  var Image: PGdkImage;
  var Context: PPangoContext;
  var FontDesc: PPangoFontDescription;
  var Layout: PPangoLayout;
  var fg, bg: PGdkGC;
  var TextureData: Pointer;
  var x, y, i: TG2IntS32;
  var p: TG2IntU32;
  function MakeColor(const r, g, b: Word): PGdkGC;
    var Values: TGdkGCValues;
    var Color: TGdkColor;
  begin
    Color.pixel := 0; Color.red := r; Color.green := g; Color.blue := b;
    gdk_colormap_alloc_color(gdk_colormap_get_system(), @Color, False, True);
    Values.foreground := color;
    Result := gdk_gc_new_with_values(Pixmap, @Values, GDK_GC_FOREGROUND);
  end;
begin
  FontDesc := pango_font_description_from_string(PAnsiChar(Face + ' ' + IntToStr(Size)));
  Context := gdk_pango_context_get;
  Layout := pango_layout_new(Context);
  pango_layout_set_font_description(Layout, FontDesc);
  _CharSpaceX := 0;
  _CharSpaceY := 0;
  for i := 0 to 255 do
  begin
    pango_layout_set_text(Layout, PAnsiChar(@i), 1);
    pango_layout_get_size(Layout, @_Props[i].Width, @_Props[i].Height);
    _Props[i].Width := _Props[i].Width div (PANGO_SCALE);
    _Props[i].Height := _Props[i].Height div (PANGO_SCALE);
    if _CharSpaceX < _Props[i].Width then _CharSpaceX := _Props[i].Width;
    if _CharSpaceY < _Props[i].Height then _CharSpaceY := _Props[i].Height;
  end;
  MaxWidth := 2048; MaxHeight := 2048;
  MapWidth := TG2IntS32(_CharSpaceX * 16);
  MapHeight := TG2IntS32(_CharSpaceY * 16);
  TexWidth := 1; while TexWidth < MapWidth do TexWidth := TexWidth shl 1; if TexWidth > MaxWidth then TexWidth := MaxWidth;
  TexHeight := 1; while TexHeight < MapHeight do TexHeight := TexHeight shl 1; if TexHeight > MaxHeight then TexHeight := MaxHeight;
  _CharSpaceX := TexWidth div 16;
  _CharSpaceY := TexHeight div 16;
  Pixmap := gdk_pixmap_new(nil, TexWidth, TexHeight, 24);
  bg := MakeColor(0, 0, 0);
  fg := MakeColor($ffff, $ffff, $ffff);
  gdk_draw_rectangle(Pixmap, bg, 1, 0, 0, TexWidth, TexHeight);
  for y := 0 to 15 do
  for x := 0 to 15 do
  begin
    i := x + y * 16;
    _Props[i].OffsetX := (_CharSpaceX - _Props[i].Width) div 2;
    _Props[i].OffsetY := (_CharSpaceY - _Props[i].Height) div 2;
    pango_layout_set_text(Layout, PAnsiChar(@i), 1);
    gdk_draw_layout(
      Pixmap, fg,
      x * _CharSpaceX + _Props[i].OffsetX,
      y * _CharSpaceY + _Props[i].OffsetY,
      Layout
    );
  end;
  Image := gdk_image_get(Pixmap, 0, 0, TexWidth, TexHeight);
  GetMem(TextureData, TexWidth * TexHeight * 4);
  for y := 0 to TexHeight - 1 do
  for x := 0 to TexWidth - 1 do
  begin
    i := y * TexWidth + x;
    p := gdk_image_get_pixel(Image, x, y);
    PARGBArr(TextureData)^[i].a := PARGB(@p)^.r;
    PARGBArr(TextureData)^[i].r := $ff;
    PARGBArr(TextureData)^[i].g := $ff;
    PARGBArr(TextureData)^[i].b := $ff;
  end;
  gdk_image_destroy(Image);
  TG2GfxOGL(g2.Gfx).ThreadAttach;
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  glGenTextures(1, @_Texture._Texture);
  glBindTexture(GL_TEXTURE_2D, _Texture._Texture);
  glTexImage2D(
    GL_TEXTURE_2D,
    0,
    GL_RGBA,
    TexWidth,
    TexHeight,
    0,
    GL_RGBA,
    GL_UNSIGNED_BYTE,
    TextureData
  );
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  TG2GfxOGL(g2.Gfx).ThreadDetach;
  FreeMem(TextureData, TexWidth * TexHeight * 4);
{$elseif defined(G2Target_OSX)}
  type TARGB = packed record
    b, g, r, a: TG2IntU8;
  end;
  type TARGBArr = array[Word] of TARGB;
  type PARGBArr = ^TARGBArr;
  var MaxWidth, MaxHeight: TG2IntS32;
  var TexWidth, TexHeight: TG2IntS32;
  var MapWidth, MapHeight: TG2IntS32;
  var Context: CGContextRef;
  var ContextData: Pointer;
  var ContextDataSize: TG2IntS32;
  var Font: CTFontRef;
  var ColorSpace: CGColorSpaceRef;
  var Chars: array [0..255] of UniChar;
  var Glyphs: array[0..255] of CGGlyph;
  var GlyphRects: array[0..255] of CGRect;
  var x, y, i, MaxCharHeight: TG2IntS32;
begin
  for i := 0 to 255 do
  Chars[i] := i;
  Font := CTFontCreateWithName(CFSTR(PAnsiChar(Face)), Size, nil);
  CTFontGetGlyphsForCharacters(Font, @Chars, @Glyphs, 256);
  CTFontGetBoundingRectsForGlyphs(Font, kCTFontDefaultOrientation, @Glyphs, @GlyphRects, 256);
  CFRelease(Font);
  _CharSpaceX := 0;
  _CharSpaceY := 0;
  for i := 0 to 255 do
  begin
    _Props[i].Width := Round(GlyphRects[i].size.width + 2);
    _Props[i].Height := Round(GlyphRects[i].size.height + 2);
    if _CharSpaceX < _Props[i].Width then _CharSpaceX := _Props[i].Width;
    if _CharSpaceY < _Props[i].Height then _CharSpaceY := _Props[i].Height;
  end;
  MaxWidth := 2048; MaxHeight := 2048;
  MaxCharHeight := _CharSpaceY;
  MapWidth := TG2IntS32(_CharSpaceX * 16);
  MapHeight := TG2IntS32(_CharSpaceY * 16);
  TexWidth := 1; while TexWidth < MapWidth do TexWidth := TexWidth shl 1; if TexWidth > MaxWidth then TexWidth := MaxWidth;
  TexHeight := 1; while TexHeight < MapHeight do TexHeight := TexHeight shl 1; if TexHeight > MaxHeight then TexHeight := MaxHeight;
  _CharSpaceX := TexWidth div 16;
  _CharSpaceY := TexHeight div 16;
  ContextDataSize := TexWidth * 4 * TexHeight;
  Getmem(ContextData, ContextDataSize);
  ColorSpace := CGColorSpaceCreateDeviceRGB;
  Context := CGBitmapContextCreate(
    ContextData, TexWidth, TexHeight, 8, TexWidth * 4,
    ColorSpace, kCGImageAlphaNoneSkipLast
  );
  FillChar(ContextData^, ContextDataSize, $ff);
  for i := 0 to ContextDataSize div 4 do
  PARGBArr(ContextData)^[i].a := 0;
  CGContextSetRGBFillColor(Context, 1, 1, 1, 1);
  CGContextSelectFont(Context, PAnsiChar(Face), Size, kCGEncodingMacRoman);
  for y := 0 to 15 do
  for x := 0 to 15 do
  begin
    i := x + y * 16;
    _Props[i].OffsetX := (_CharSpaceX - _Props[i].Width) div 2;
    _Props[i].OffsetY := (_CharSpaceY - _Props[i].Height) div 2;
    CGContextShowTextAtPoint(
      Context,
      x * _CharSpaceX + _Props[i].OffsetX,
      TexHeight - (y + 1) * _CharSpaceY + MaxCharHeight div 8,
      PAnsiChar(@i), 1
    );
  end;
  _Gfx.ThreadAttach;
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  glGenTextures(1, @_Texture._Texture);
  glBindTexture(GL_TEXTURE_2D, _Texture._Texture);
  glTexImage2D(
    GL_TEXTURE_2D,
    0,
    GL_RGBA,
    TexWidth,
    TexHeight,
    0,
    GL_RGBA,
    GL_UNSIGNED_BYTE,
    ContextData
  );
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  _Gfx.ThreadDetach;
  CGContextRelease(Context);
  CGColorSpaceRelease(ColorSpace);
  Freemem(ContextData, ContextDataSize);
{$elseif defined(G2Target_Android)}
  type TARGB = packed record
    b, g, r, a: TG2IntU8;
  end;
  type TARGBArr = array[Word] of TARGB;
  type PARGBArr = ^TARGBArr;
  var TexWidth, TexHeight: TG2IntS32;
  var Data: Pointer;
  var CharWidths: array[0..255] of TG2IntS32;
  var CharHeights: array[0..255] of TG2IntS32;
  var i: TG2IntS32;
begin
  AndroidBinding.FontMake(Data, TexWidth, TexHeight, Size, @CharWidths, @CharHeights);
  for i := 0 to TexWidth * TexHeight - 1 do
  begin
    PARGBArr(Data)^[i].a := PARGBArr(Data)^[i].r;
    PARGBArr(Data)^[i].r := 255;
    PARGBArr(Data)^[i].g := 255;
    PARGBArr(Data)^[i].b := 255;
  end;
  _CharSpaceX := TexWidth div 16;
  _CharSpaceY := TexHeight div 16;
  for i := 0 to 255 do
  begin
    _Props[i].Width := CharWidths[i];
    _Props[i].Height := CharHeights[i];
    _Props[i].OffsetX := (_CharSpaceX - _Props[i].Width) div 2;
    _Props[i].OffsetY := (_CharSpaceY - _Props[i].Height) div 2;
  end;
  TG2GfxGLES(g2.Gfx).ThreadAttach;
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  glGenTextures(1, @_Texture._Texture);
  glBindTexture(GL_TEXTURE_2D, _Texture._Texture);
  glTexImage2D(
    GL_TEXTURE_2D,
    0,
    GL_RGBA,
    TexWidth,
    TexHeight,
    0,
    GL_RGBA,
    GL_UNSIGNED_BYTE,
    Data
  );
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  TG2GfxGLES(g2.Gfx).ThreadDetach;
  FreeMem(Data, TexWidth * TexHeight * 4);
{$elseif defined(G2Target_iOS)}
  var TexWidth, TexHeight: TG2IntS32;
begin
  TexWidth := 0;
  TexHeight := 0;
{$else}
begin
{$endif}
  _Texture._RealWidth := TexWidth;
  _Texture._RealHeight := TexHeight;
  _Texture._Width := TexWidth;
  _Texture._Height := TexHeight;
  _Texture._SizeTU := 1;
  _Texture._SizeTV := 1;
end;

procedure TG2Font.Load(const Stream: TStream);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Stream);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Font.Load(const FileName: String);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName, dmAsset);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Font.Load(const Buffer: Pointer; const Size: TG2IntS32);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Buffer, Size);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Font.Load(const DataManager: TG2DataManager);
  type TCharProp = packed record
    Width: TG2IntU8;
    Height: TG2IntU8;
  end;
  type TG2FontFile = packed record
    Definition: array[0..3] of AnsiChar;
    Version: TG2IntU32;
    FontFace: AnsiString;
    FontSize: TG2IntS32;
    DataSize: TG2IntS64;
    Chars: array[0..255] of TCharProp;
  end;
  const Definition: array[0..3] of AnsiChar = 'G2F ';
  const Version = $00010001;
  var Header: TG2FontFile;
  var b: TG2IntU8;
  var i: TG2IntS32;
begin
  if DataManager.Size - DataManager.Position < 8 then Exit;
  DataManager.ReadBuffer(@Header.Definition, 4);
  if (Header.Definition <> Definition) then Exit;
  DataManager.ReadBuffer(@Header.Version, 4);
  if Header.Version <> Version then Exit;
  Header.FontFace := '';
  repeat b := DataManager.ReadIntU8; Header.FontFace := Header.FontFace + Chr(b) until b = 0;
  DataManager.ReadBuffer(@Header.FontSize, SizeOf(Header.FontSize));
  DataManager.ReadBuffer(@Header.DataSize, SizeOf(Header.DataSize));
  DataManager.ReadBuffer(@Header.Chars, SizeOf(Header.Chars));
  Texture.Load(DataManager);
  _CharSpaceX := _Texture.Width div 16;
  _CharSpaceY := _Texture.Height div 16;
  for i := 0 to 255 do
  begin
    _Props[i].Width := Header.Chars[i].Width;
    _Props[i].Height := Header.Chars[i].Height;
    _Props[i].OffsetX := (_CharSpaceX - _Props[i].Width) div 2;
    _Props[i].OffsetY := (_CharSpaceY - _Props[i].Height) div 2;
  end;
end;

procedure TG2Font.Print(
  const x, y, ScaleX, ScaleY: TG2Float;
  const Color: TG2Color;
  const Text: AnsiString;
  const BlendMode: TG2BlendMode;
  const Filter: TG2Filter;
  const Display: TG2Display2D = nil
);
  var i: TG2IntS32;
  var c: TG2IntU8;
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
    if Display <> nil then
    Display.PicQuadCol(
      x1, y1, x2, y1,
      x1, y2, x2, y2,
      tu1, tv1, tu2, tv1,
      tu1, tv2, tu2, tv2,
      Color, Color, Color, Color,
      _Texture,
      BlendMode, Filter
    )
    else
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
  const Text: AnsiString;
  const BlendMode: TG2BlendMode;
  const Filter: TG2Filter;
  const Display: TG2Display2D = nil
);
begin
  Print(x, y, ScaleX, ScaleY, $ffffffff, Text, BlendMode, Filter, Display);
end;

procedure TG2Font.Print(
  const x, y, ScaleX, ScaleY: TG2Float;
  const Text: AnsiString;
  const Display: TG2Display2D = nil
);
begin
  Print(x, y, ScaleX, ScaleY, Text, bmNormal, tfPoint, Display);
end;

procedure TG2Font.Print(
  const x, y: TG2Float;
  const Text: AnsiString;
  const Display: TG2Display2D = nil
);
begin
  Print(x, y, 1, 1, Text, Display);
end;

procedure TG2Font.Print3D(
  const Pos, DirX, DirY: TG2Vec3;
  const ScaleX, ScaleY: TG2Float;
  const WVP: TG2Mat;
  const Text: AnsiString;
  const Color: TG2Color;
  const BlendMode: TG2BlendMode;
  const Filter: TG2Filter
);
  var i: TG2IntS32;
  var CharTU, CharTV, tu1, tv1, tu2, tv2: TG2Float;
  var CurPos: TG2Vec3;
  var v0, v1, v2, v3: TG2Vec3;
  var c: TG2IntU8;
begin
  if Length(Text) = 0 then Exit;
  CharTU := _CharSpaceX / _Texture.RealWidth;
  CharTV := _CharSpaceY / _Texture.RealHeight;
  CurPos := Pos;
  g2.Poly3DBegin(ptTriangles, _Texture, WVP, BlendMode, Filter);
  for i := 0 to Length(Text) - 1 do
  begin
    c := Ord(Text[i + 1]);
    v0 := CurPos;
    v1 := v0 + DirX * (_Props[c].Width * ScaleX);
    v2 := v0 + DirY * (_Props[c].Height * ScaleY);
    v3 := v1 + (v2 - v0);
    tu1 := (c mod 16) * CharTU;
    tv1 := (c div 16) * CharTV;
    tu2 := tu1 + CharTU;
    tv2 := tv1 + CharTV;
    g2.Poly3DAddQuad(
      v0, v1, v2, v3,
      G2Vec2(tu1, tv1), G2Vec2(tu2, tv1),
      G2Vec2(tu1, tv2), G2Vec2(tu2, tv2),
      Color, Color, Color, Color
    );
    CurPos := v1;
  end;
  g2.Poly3DEnd;
end;
//TG2Font END

{$if defined(G2RM_SM2)}
//TG2ShaderGroup BEGIN
function TG2ShaderGroup.GetMethod: AnsiString;
begin
  if (_Method > -1) and (_Method < _Methods.Count) then
  Result := PG2ShaderMethod(_Methods[_Method])^.Name;
end;

procedure TG2ShaderGroup.SetMethod(const Value: AnsiString);
begin
  _Method := FindMethodIndex(Value);
  if _Method > -1 then
  begin
    _Gfx.ShaderMethod := PG2ShaderMethod(_Methods[_Method]);
  end
  else
  begin
    _Gfx.ShaderMethod := nil;
  end;
end;

procedure TG2ShaderGroup.SetMethodIndex(const Value: TG2IntS32);
begin
  _Method := Value;
  if _Method > -1 then
  begin
    _Gfx.ShaderMethod := PG2ShaderMethod(_Methods[_Method]);
  end
  else
  begin
    _Gfx.ShaderMethod := nil;
  end;
end;

{$if defined(G2RM_SM2)}
{$if defined(G2Gfx_D3D9)}
function TG2ShaderGroup.ParamVS(const Name: AnsiString): TG2IntS32;
  var i: TG2IntS32;
begin
  if _Method = -1 then Exit;
  for i := 0 to High(PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params) do
  if PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[i].Name = Name then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;

function TG2ShaderGroup.ParamPS(const Name: AnsiString): TG2IntS32;
  var i: TG2IntS32;
begin
  if _Method = -1 then Exit;
  for i := 0 to High(PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params) do
  if PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[i].Name = Name then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;
{$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
function TG2ShaderGroup.Param(const Name: AnsiString): GLInt;
begin
  Result := glGetUniformLocation(PG2ShaderMethod(_Methods[_Method])^.ShaderProgram, PAnsiChar(Name));
end;
{$endif}
{$endif}

procedure TG2ShaderGroup.Initialize;
begin
  _Gfx := {$if defined(G2Gfx_D3D9)}TG2GfxD3D9{$elseif defined(G2Gfx_OGL)}TG2GfxOGL{$elseif defined(G2Gfx_GLES)}TG2GfxGLES{$endif}(g2.Gfx);
  _Methods.Clear;
  _VertexShaders.Clear;
  _PixelShaders.Clear;
  _Method := -1;
end;

procedure TG2ShaderGroup.Finalize;
begin
  Clear;
end;

function TG2ShaderGroup.FindMethodIndex(const Name: String): TG2IntS32;
  var i: TG2IntS32;
begin
  for i := 0 to _Methods.Count - 1 do
  if PG2ShaderMethod(_Methods[i])^.Name = Name then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;

procedure TG2ShaderGroup.Load(const Stream: TStream);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Stream, dmRead);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2ShaderGroup.Load(const FileName: String);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName, dmAsset);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2ShaderGroup.Load(const Buffer: Pointer; const Size: TG2IntS32);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Buffer, Size, dmRead);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2ShaderGroup.Load(const DataManager: TG2DataManager);
  {$if defined(G2Gfx_D3D9)}
  procedure ReadParams(var Params: TG2ShaderParams);
    var i: TG2IntS32;
  begin
    SetLength(Params, DataManager.ReadIntS32);
    for i := 0 to High(Params) do
    begin
      Params[i].ParamType := DataManager.ReadIntU8;
      Params[i].Name := DataManager.ReadStringA;
      Params[i].Pos := DataManager.ReadIntS32;
      Params[i].Size := DataManager.ReadIntS32;
    end;
  end;
  {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
  procedure SkipParams;
    var i, n: TG2IntS32;
    var Str: AnsiString;
  begin
    n := DataManager.ReadIntS32;
    for i := 0 to n - 1 do
    begin
      DataManager.Skip(1);
      Str := DataManager.ReadStringA;
      DataManager.Skip(8);
    end;
  end;
  {$endif}
  type THeader = packed record
    Definition: array[0..3] of AnsiChar;
    Version: TG2IntU16;
    MethodCount: TG2IntS32;
    VertexShaderCount: TG2IntS32;
    PixelShaderCount: TG2IntS32;
  end;
  var Header: THeader;
  var i, n: TG2IntS32;
  var VS: PG2VertexShader;
  var PS: PG2PixelShader;
  var MTD: PG2ShaderMethod;
  var Source: AnsiString;
  {$if defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
  var SourcePtr: Pointer;
  var Errors: AnsiString;
  {$endif}
begin
  Clear;
  _Gfx.ThreadAttach;
  DataManager.ReadBuffer(@Header, SizeOf(Header));
  if (Header.Definition <> 'G2SG') or (Header.Version > $0100) then Exit;
  DataManager.Codec := cdZLib;
  for i := 0 to Header.VertexShaderCount - 1 do
  begin
    New(VS);
    VS^.Name := DataManager.ReadStringA;
    n := DataManager.ReadIntS32;
    DataManager.Skip(n);
    n := DataManager.ReadIntS32;
    DataManager.Skip(n);
    {$if defined(G2Gfx_D3D9)}
    n := DataManager.ReadIntS32;
    SetLength(Source, n);
    DataManager.ReadBuffer(@Source[1], n);
    n := DataManager.ReadIntS32;
    DataManager.Skip(n);
    _Gfx.Device.CreateVertexShader(@Source[1], VS^.Prog);
    ReadParams(VS^.Params);
    {$elseif defined(G2Gfx_OGL)}
    n := DataManager.ReadIntS32;
    DataManager.Skip(n);
    n := DataManager.ReadIntS32;
    SetLength(Source, n);
    DataManager.ReadBuffer(@Source[1], n);
    VS^.Prog := glCreateShader(GL_VERTEX_SHADER);
    SourcePtr := @Source[1];
    glShaderSource(VS^.Prog, 1, @SourcePtr, @n);
    glCompileShader(VS^.Prog);
    SkipParams;
    {$endif}
    _VertexShaders.Add(VS);
  end;
  for i := 0 to Header.PixelShaderCount - 1 do
  begin
    New(PS);
    PS^.Name := DataManager.ReadStringA;
    n := DataManager.ReadIntS32;
    DataManager.Skip(n);
    n := DataManager.ReadIntS32;
    DataManager.Skip(n);
    {$if defined(G2Gfx_D3D9)}
    n := DataManager.ReadIntS32;
    SetLength(Source, n);
    DataManager.ReadBuffer(@Source[1], n);
    n := DataManager.ReadIntS32;
    DataManager.Skip(n);
    _Gfx.Device.CreatePixelShader(@Source[1], PS^.Prog);
    ReadParams(PS^.Params);
    {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
    n := DataManager.ReadIntS32;
    DataManager.Skip(n);
    n := DataManager.ReadIntS32;
    SetLength(Source, n);
    DataManager.ReadBuffer(@Source[1], n);
    PS^.Prog := glCreateShader(GL_FRAGMENT_SHADER);
    SourcePtr := @Source[1];
    glShaderSource(PS^.Prog, 1, @SourcePtr, @n);
    glCompileShader(PS^.Prog);
    SkipParams;
    {$endif}
    _PixelShaders.Add(PS);
  end;
  for i := 0 to Header.MethodCount - 1 do
  begin
    New(MTD);
    MTD^.Name := DataManager.ReadStringA;
    n := DataManager.ReadIntS32;
    MTD^.VertexShader := PG2VertexShader(_VertexShaders[n]);
    n := DataManager.ReadIntS32;
    MTD^.PixelShader := PG2PixelShader(_PixelShaders[n]);
    {$if defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
    MTD^.ShaderProgram := glCreateProgram();
    glAttachShader(MTD^.ShaderProgram, MTD^.VertexShader^.Prog);
    glAttachShader(MTD^.ShaderProgram, MTD^.PixelShader^.Prog);
    glLinkProgram(MTD^.ShaderProgram);
    SetLength(Errors, 2048);
    glGetProgramInfoLog(MTD^.ShaderProgram, 2048, n, PAnsiChar(Errors));
    {$endif}
    _Methods.Add(MTD);
  end;
  DataManager.Codec := cdNone;
  _Gfx.ThreadDetach;
end;

{$if defined(G2Gfx_D3D9)}
procedure TG2ShaderGroup.UniformMatrix4x4(const Name: AnsiString; const m: TG2Mat);
  var psid, vsid, Size: TG2IntS32;
  var mt: TG2Mat;
begin
  mt := G2MatTranspose(m);
  vsid := ParamVS(Name);
  if vsid > -1 then
  begin
    Size := Min(4, PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Size);
    _Gfx.Device.SetVertexShaderConstantF(PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Pos, @mt, Size);
  end;
  psid := ParamPS(Name);
  if psid > -1 then
  begin
    Size := Min(4, PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Size);
    _Gfx.Device.SetPixelShaderConstantF(PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Pos, @mt, Size);
  end;
end;

procedure TG2ShaderGroup.UniformMatrix4x4Arr(const Name: AnsiString; const m: PG2Mat; const ArrPos, Count: TG2IntS32);
  var psid, vsid, Pos, i: TG2IntS32;
  var mt: TG2Mat;
  var pm: PG2Mat;
begin
  vsid := ParamVS(Name);
  if vsid > -1 then
  begin
    pm := m;
    Pos := PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Pos + ArrPos * 4;
    for i := 0 to Count - 1 do
    begin
      mt := G2MatTranspose(pm^);
      _Gfx.Device.SetVertexShaderConstantF(Pos, @mt, 4);
      Inc(Pos, 4);
      Inc(pm);
    end;
  end;
  psid := ParamPS(Name);
  if psid > -1 then
  begin
    pm := @m;
    Pos := PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Pos + ArrPos * 4;
    for i := 0 to Count - 1 do
    begin
      mt := G2MatTranspose(pm^);
      _Gfx.Device.SetPixelShaderConstantF(Pos, @mt, 4);
      Inc(Pos, 4);
      Inc(pm);
    end;
  end;
end;

procedure TG2ShaderGroup.UniformMatrix4x3(const Name: AnsiString; const m: TG2Mat);
  var psid, vsid, Size: TG2IntS32;
  var mt: TG2Mat;
begin
  mt := G2MatTranspose(m);
  vsid := ParamVS(Name);
  if vsid > -1 then
  begin
    Size := Min(3, PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Size);
    _Gfx.Device.SetVertexShaderConstantF(PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Pos, @mt, Size);
  end;
  psid := ParamPS(Name);
  if psid > -1 then
  begin
    Size := Min(3, PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Size);
    _Gfx.Device.SetPixelShaderConstantF(PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Pos, @mt, Size);
  end;
end;

procedure TG2ShaderGroup.UniformMatrix4x3Arr(const Name: AnsiString; const m: PG2Mat; const ArrPos, Count: TG2IntS32);
  var psid, vsid, Pos, i: TG2IntS32;
  var mt: TG2Mat;
  var pm: PG2Mat;
begin
  vsid := ParamVS(Name);
  if vsid > -1 then
  begin
    pm := m;
    Pos := PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Pos + ArrPos * 3;
    for i := 0 to Count - 1 do
    begin
      mt := G2MatTranspose(pm^);
      _Gfx.Device.SetVertexShaderConstantF(Pos, @mt, 3);
      Inc(Pos, 3);
      Inc(pm);
    end;
  end;
  psid := ParamPS(Name);
  if psid > -1 then
  begin
    pm := m;
    Pos := PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Pos + ArrPos * 3;
    for i := 0 to Count - 1 do
    begin
      mt := G2MatTranspose(pm^);
      _Gfx.Device.SetPixelShaderConstantF(Pos, @mt, 3);
      Inc(Pos, 3);
      Inc(pm);
    end;
  end;
end;

procedure TG2ShaderGroup.UniformFloat4(const Name: AnsiString; const v: TG2Vec4);
  var psid, vsid, Size: TG2IntS32;
begin
  vsid := ParamVS(Name);
  if vsid > -1 then
  begin
    Size := Min(1, PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Size);
    _Gfx.Device.SetVertexShaderConstantF(PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Pos, @v, Size);
  end;
  psid := ParamPS(Name);
  if psid > -1 then
  begin
    Size := Min(1, PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Size);
    _Gfx.Device.SetPixelShaderConstantF(PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Pos, @v, Size);
  end;
end;

procedure TG2ShaderGroup.UniformFloat3(const Name: AnsiString; const v: TG2Vec3);
  var psid, vsid, Size: TG2IntS32;
  var v4: TG2Vec4;
begin
  v4 := v.AsVec4;
  vsid := ParamVS(Name);
  if vsid > -1 then
  begin
    Size := Min(1, PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Size);
    _Gfx.Device.SetVertexShaderConstantF(PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Pos, @v4, Size);
  end;
  psid := ParamPS(Name);
  if psid > -1 then
  begin
    Size := Min(1, PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Size);
    _Gfx.Device.SetPixelShaderConstantF(PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Pos, @v4, Size);
  end;
end;

procedure TG2ShaderGroup.UniformFloat2(const Name: AnsiString; const v: TG2Vec2);
  var psid, vsid, Size: TG2IntS32;
  var v4: TG2Vec4;
begin
  v4 := v.AsVec4;
  vsid := ParamVS(Name);
  if vsid > -1 then
  begin
    Size := Min(1, PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Size);
    _Gfx.Device.SetVertexShaderConstantF(PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Pos, @v4, Size);
  end;
  psid := ParamPS(Name);
  if psid > -1 then
  begin
    Size := Min(1, PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Size);
    _Gfx.Device.SetPixelShaderConstantF(PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Pos, @v4, Size);
  end;
end;

procedure TG2ShaderGroup.UniformFloat1(const Name: AnsiString; const v: TG2Float);
  var psid, vsid, Size: TG2IntS32;
  var v4: TG2Vec4;
begin
  v4 := G2Vec4(v, 0, 0, 0);
  vsid := ParamVS(Name);
  if vsid > -1 then
  begin
    Size := Min(1, PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Size);
    _Gfx.Device.SetVertexShaderConstantF(PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Pos, @v4, Size);
  end;
  psid := ParamPS(Name);
  if psid > -1 then
  begin
    Size := Min(1, PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Size);
    _Gfx.Device.SetPixelShaderConstantF(PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Pos, @v4, Size);
  end;
end;

procedure TG2ShaderGroup.UniformInt1(const Name: AnsiString; const i: TG2IntS32);
  var psid, vsid: TG2IntS32;
  var IntArr: array[0..3] of TG2IntS32;
begin
  FillChar({%H-}IntArr[1], 12, 0);
  IntArr[0] := i;
  vsid := ParamVS(Name);
  if vsid > -1 then
  begin
    _Gfx.Device.SetVertexShaderConstantI(PG2ShaderMethod(_Methods[_Method])^.VertexShader^.Params[vsid].Pos, @IntArr, 1);
  end;
  psid := ParamPS(Name);
  if psid > -1 then
  begin
    _Gfx.Device.SetPixelShaderConstantI(PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Pos, @IntArr, 1);
  end;
end;
{$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
procedure TG2ShaderGroup.UniformMatrix4x4(const Name: AnsiString; const m: TG2Mat);
  var shid: GLInt;
begin
  shid := Param(Name);
  if shid > -1 then
  glUniformMatrix4fv(shid, 1, True, @m);
end;

procedure TG2ShaderGroup.UniformMatrix4x4Arr(const Name: AnsiString; const m: PG2Mat; const ArrPos, Count: TG2IntS32);
  var shid: GLInt;
begin
  shid := Param(Name + '[' + IntToStr(ArrPos) + ']');
  if shid > -1 then
  glUniformMatrix4fv(shid, Count, True, PG2Float(m));
end;

procedure TG2ShaderGroup.UniformMatrix4x3(const Name: AnsiString; const m: TG2Mat);
begin
  UniformMatrix4x4(Name, m);
end;

procedure TG2ShaderGroup.UniformMatrix4x3Arr(const Name: AnsiString; const m: PG2Mat; const ArrPos, Count: TG2IntS32);
begin
  UniformMatrix4x4Arr(Name, m, ArrPos, Count);
end;

procedure TG2ShaderGroup.UniformFloat4(const Name: AnsiString; const v: TG2Vec4);
  var shid: GLInt;
begin
  shid := Param(Name);
  if shid > -1 then
  glUniform4fv(shid, 1, @v);
end;

procedure TG2ShaderGroup.UniformFloat3(const Name: AnsiString; const v: TG2Vec3);
  var shid: GLInt;
begin
  shid := Param(Name);
  if shid > -1 then
  glUniform3fv(shid, 1, @v);
end;

procedure TG2ShaderGroup.UniformFloat2(const Name: AnsiString; const v: TG2Vec2);
  var shid: GLInt;
begin
  shid := Param(Name);
  if shid > -1 then
  glUniform2fv(shid, 1, @v);
end;

procedure TG2ShaderGroup.UniformFloat1(const Name: AnsiString; const v: TG2Float);
  var shid: GLInt;
begin
  shid := Param(Name);
  if shid > -1 then
  glUniform1fv(shid, 1, @v);
end;

procedure TG2ShaderGroup.UniformInt1(const Name: AnsiString; const i: TG2IntS32);
  var shid: GLInt;
begin
  shid := Param(Name);
  if shid > -1 then
  glUniform1i(shid, i);
end;
{$endif}

procedure TG2ShaderGroup.Sampler(const Name: AnsiString; const Texture: TG2TextureBase; const Stage: TG2IntS32 = 0);
{$if defined(G2Gfx_D3D9)}
  var psid: TG2IntS32;
begin
  psid := ParamPS(Name);
  if (psid > -1)
  and (PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].ParamType = 3) then
  begin
    _Gfx.Device.SetTexture(
      PG2ShaderMethod(_Methods[_Method])^.PixelShader^.Params[psid].Pos,
      Texture.BaseTexture
    );
  end;
end;
{$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
  var shid: GLInt;
begin
  shid := Param(Name);
  if shid > -1 then
  begin
    _Gfx.ActiveTexture := Stage;
    glBindTexture(GL_TEXTURE_2D, Texture.BaseTexture);
    glUniform1i(shid, Stage);
  end;
end;
{$endif}

{$if defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
function TG2ShaderGroup.Attribute(const Name: AnsiString): GLInt;
begin
  if _Method > -1 then
  Result := glGetAttribLocation(PG2ShaderMethod(_Methods[_Method])^.ShaderProgram, Name)
  else
  Result := -1;
end;
{$endif}

procedure TG2ShaderGroup.Clear;
  var i: TG2IntS32;
begin
  for i := 0 to _VertexShaders.Count - 1 do
  begin
    {$if defined(G2Gfx_D3D9)}
    SafeRelease(PG2VertexShader(_VertexShaders[i])^.Prog);
    {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
    glDeleteShader(PG2VertexShader(_VertexShaders[i])^.Prog);
    {$endif}
    Dispose(PG2VertexShader(_VertexShaders[i]));
  end;
  _VertexShaders.Clear;
  for i := 0 to _PixelShaders.Count - 1 do
  begin
    {$if defined(G2Gfx_D3D9)}
    SafeRelease(PG2PixelShader(_PixelShaders[i])^.Prog);
    {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
    glDeleteShader(PG2PixelShader(_PixelShaders[i])^.Prog);
    {$endif}
    Dispose(PG2PixelShader(_PixelShaders[i]));
  end;
  _PixelShaders.Clear;
  for i := 0 to _Methods.Count - 1 do
  begin
    {$if defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
    glDeleteProgram(PG2ShaderMethod(_Methods[i])^.ShaderProgram);
    {$endif}
    Dispose(PG2ShaderMethod(_Methods[i]));
  end;
  _Methods.Clear;
end;
//TG2ShaderGroup END
{$endif}

//TG2RenderControl BEGIN
constructor TG2RenderControl.Create;
begin
  inherited Create;
  _Gfx := {$if defined(G2Gfx_D3D9)}TG2GfxD3D9{$elseif defined(G2Gfx_OGL)}TG2GfxOGL{$elseif defined(G2Gfx_GLES)}TG2GfxGLES{$endif}(g2.Gfx);
  _FillID := @_Gfx._QueueFill;
  _DrawID := @_Gfx._QueueDraw;
end;

destructor TG2RenderControl.Destroy;
begin
  inherited Destroy;
end;
//TG2RenderControl END

//TG2RenderControlStateChange BEGIN
procedure TG2RenderControlStateChange.CheckCapacity;
  var n, i: TG2IntS32;
begin
  if _QueueCount[_FillID^] >= _QueueCapacity[_FillID^] then
  begin
    n := _QueueCapacity[_FillID^];
    _QueueCapacity[_FillID^] := _QueueCapacity[_FillID^] + 128;
    SetLength(_Queue[_FillID^], _QueueCapacity[_FillID^]);
    for i := n to _QueueCapacity[_FillID^] - 1 do
    begin
      New(_Queue[_FillID^][i]);
      _Queue[_FillID^][i]^.DataSize := 0;
    end;
  end;
end;

function TG2RenderControlStateChange.PrepareData(const StateType: TG2StateChageType; const Size: TG2IntS32): Pointer;
  var StateChange: PG2StateChange;
begin
  CheckCapacity;
  StateChange := _Queue[_FillID^][_QueueCount[_FillID^]];
  StateChange^.StateType := StateType;
  if StateChange^.DataSize < Size then
  begin
    if StateChange^.DataSize > 0 then
    FreeMem(StateChange^.Data, StateChange^.DataSize);
    StateChange^.DataSize := Size;
    GetMem(StateChange^.Data, Size);
  end;
  Result := StateChange^.Data;
  _Gfx.AddRenderQueueItem(Self, StateChange);
  Inc(_QueueCount[_FillID^]);
end;

procedure TG2RenderControlStateChange.SetRenderTarget(const RenderTarget: TG2Texture2DRT);
  var Data: Pointer;
begin
  Data := PrepareData(stRenderTarget, SizeOf(TG2Texture2DRT));
  PPointer(Data)^ := RenderTarget;
  if RenderTarget <> nil then
  begin
    g2.Params._WidthRT := RenderTarget.RealWidth;
    g2.Params._HeightRT := RenderTarget.RealHeight;
  end
  else
  begin
    g2.Params._WidthRT := g2.Params.Width;
    g2.Params._HeightRT := g2.Params.Height;
  end;
end;

procedure TG2RenderControlStateChange.SetScissor(const ScissorRect: PRect);
  var Data: Pointer;
  var b: Boolean;
begin
  Data := PrepareData(stScissor, SizeOf(TRect) + 1);
  b := ScissorRect <> nil;
  PG2Bool(Data)^ := b;
  if b then
  begin
    PRect(Data + 1)^ := ScissorRect^;
    _ScissorRect := ScissorRect^;
    _Scissor := @_ScissorRect;
  end
  else
  begin
    _Scissor := nil;
  end;
end;

procedure TG2RenderControlStateChange.SetDepthEnable(const Value: Boolean);
  var Data: Pointer;
begin
  Data := PrepareData(stDepthEnable, 1);
  PG2Bool(Data)^ := Value;
  _DepthEnable := Value;
end;

procedure TG2RenderControlStateChange.SetDepthWriteEnable(const Value: Boolean);
  var Data: Pointer;
begin
  Data := PrepareData(stDepthWriteEnable, 1);
  PG2Bool(Data)^ := Value;
  _DepthWriteEnable := Value;
end;

procedure TG2RenderControlStateChange.StateClear(const Color: TG2Color);
begin
  StateClear(True, Color, False, 1, False, 0);
end;

procedure TG2RenderControlStateChange.StateClear(
  const Color: Boolean; const ColorValue: TG2Color;
  const Depth: Boolean; const DepthValue: TG2Float;
  const Stencil: Boolean; const StencilValue: TG2IntU8
);
  var Data: Pointer;
begin
  Data := PrepareData(stClear, 16);
  PG2Bool(Data + 0)^ := Color;
  PG2Color(Data + 1)^ := ColorValue;
  PG2Bool(Data + 5)^ := Depth;
  PG2Float(Data + 6)^ := DepthValue;
  PG2Bool(Data + 10)^ := Stencil;
  PG2IntU8(Data + 11)^ := StencilValue;
end;

procedure TG2RenderControlStateChange.RenderBegin;
begin

end;

procedure TG2RenderControlStateChange.RenderEnd;
begin

end;

procedure TG2RenderControlStateChange.RenderData(const Data: Pointer);
  var StateChange: PG2StateChange;
begin
  StateChange := PG2StateChange(Data);
  case StateChange^.StateType of
    stClear:
    begin
      _Gfx.Clear(
        PG2Bool(StateChange^.Data + 0)^,
        PG2Color(StateChange^.Data + 1)^,
        PG2Bool(StateChange^.Data + 5)^,
        PG2Float(StateChange^.Data + 6)^,
        PG2Bool(StateChange^.Data + 10)^,
        PG2IntU8(StateChange^.Data + 11)^
      );
    end;
    stRenderTarget:
    begin
      _Gfx.SetRenderTarget(TG2Texture2DRT(StateChange^.Data^));
    end;
    stScissor:
    begin
      if PG2Bool(StateChange^.Data)^ then
      _Gfx.SetScissor(PRect(StateChange^.Data + 1))
      else
      _Gfx.SetScissor(nil);
    end;
    stDepthEnable:
    begin
      _Gfx.DepthEnable := PG2Bool(StateChange^.Data)^;
    end;
    stDepthWriteEnable:
    begin
      _Gfx.DepthWriteEnable := PG2Bool(StateChange^.Data)^;
    end;
  end;
end;

procedure TG2RenderControlStateChange.Reset;
begin
  _QueueCount[_FillID^] := 0;
end;

constructor TG2RenderControlStateChange.Create;
begin
  inherited Create;
  _QueueCapacity[0] := 0;
  _QueueCapacity[1] := 0;
  _QueueCount[0] := 0;
  _QueueCount[1] := 0;
  _RenderTarget := _Gfx.RenderTarget;
  _Scissor := nil;
  _DepthEnable := _Gfx.DepthEnable;
  _DepthWriteEnable := _Gfx.DepthWriteEnable;
end;

destructor TG2RenderControlStateChange.Destroy;
  var n, i: TG2IntS32;
begin
  for n := 0 to 1 do
  for i := 0 to _QueueCapacity[n] - 1 do
  begin
    if _Queue[n][i]^.DataSize > 0 then
    FreeMem(_Queue[n][i]^.Data, _Queue[n][i]^.DataSize);
    Dispose(_Queue[n][i]);
  end;
  inherited Destroy;
end;
//TG2RenderControlStateChange END

//TG2ManagedRenderObject BEGIN
constructor TG2ManagedRenderObject.Create;
begin
  inherited Create;
  _DrawID := g2.Gfx.Managed._DrawID;
  _FillID := g2.Gfx.Managed._FillID;
end;

destructor TG2ManagedRenderObject.Destroy;
begin
  inherited Destroy;
end;

procedure TG2ManagedRenderObject.Render;
begin
  g2.Gfx.Managed.RenderObject(Self);
end;
//TG2ManagedRenderObject END

//TG2RenderControlManaged BEGIN
procedure TG2RenderControlManaged.CheckCapacity;
begin
  if _QueueCount[_FillID^] >= _QueueCapacity[_FillID^] then
  begin
    _QueueCapacity[_FillID^] := _QueueCapacity[_FillID^] + 128;
    SetLength(_Queue[_FillID^], _QueueCapacity[_FillID^]);
  end;
end;

procedure TG2RenderControlManaged.RenderObject(const Obj: TG2ManagedRenderObject);
begin
  CheckCapacity;
  _Gfx.AddRenderQueueItem(Self, Obj);
  Inc(_QueueCount[_FillID^]);
end;

procedure TG2RenderControlManaged.RenderBegin;
begin

end;

procedure TG2RenderControlManaged.RenderEnd;
begin

end;

procedure TG2RenderControlManaged.RenderData(const Data: Pointer);
begin
  TG2ManagedRenderObject(Data).DoRender;
end;

procedure TG2RenderControlManaged.Reset;
begin
  _QueueCount[_FillID^] := 0;
end;

constructor TG2RenderControlManaged.Create;
begin
  inherited Create;
  _QueueCapacity[0] := 0;
  _QueueCapacity[1] := 0;
  _QueueCount[0] := 0;
  _QueueCount[1] := 0;
end;

destructor TG2RenderControlManaged.Destroy;
begin
  inherited Destroy;
end;
//TG2RenderControlManaged END

{$if defined(G2RM_SM2)}
//TG2RenderControlBuffer BEGIN
procedure TG2RenderControlBuffer.CheckCapacity;
  var n, i: TG2IntS32;
begin
  if _QueueCount[_FillID^] >= _QueueCapacity[_FillID^] then
  begin
    n := _QueueCapacity[_FillID^];
    _QueueCapacity[_FillID^] := _QueueCapacity[_FillID^] + 128;
    SetLength(_Queue[_FillID^], _QueueCapacity[_FillID^]);
    for i := n to _QueueCapacity[_FillID^] - 1 do
    New(_Queue[_FillID^][i]);
  end;
end;

procedure TG2RenderControlBuffer.AddParam(
  const ParamType: TParamType;
  const Name: String;
  const Index: TG2IntS32;
  const Count: TG2IntS32;
  const Data: PG2IntU8;
  const DataSize: TG2IntS32
);
  var p: ^TShaderParam;
begin
  if _CurData = nil then Exit;
  if _CurData^.ParamCount >= Length(_CurData^.Params) then
  SetLength(_CurData^.Params, _CurData^.ParamCount + 32);
  p := @_CurData^.Params[_CurData^.ParamCount];
  p^.Name := name;
  p^.ParamType := ParamType;
  p^.Index := Index;
  p^.Count := Count;
  if Length(p^.Data) < DataSize then
  SetLength(p^.Data, DataSize);
  Move(Data^, p^.Data[0], DataSize);
  _CurData^.ParamCount := _CurData^.ParamCount + 1;
end;

procedure TG2RenderControlBuffer.BufferBegin(
  const PrimType: TG2PrimitiveType;
  const VertexBuffer: TG2VertexBuffer; const IndexBuffer: TG2IndexBuffer;
  const ShaderGroup: TG2ShaderGroup; const Method: String;
  const VertexStart: TG2IntS32; const VertexCount: TG2IntS32;
  const IndexStart: TG2IntS32; const PrimCount: TG2IntS32
);
begin
  CheckCapacity;
  _CurData := _Queue[_FillID^][_QueueCount[_FillID^]];
  _CurData^.PrimType := PrimType;
  _CurData^.VertexBuffer := VertexBuffer;
  _CurData^.IndexBuffer := IndexBuffer;
  _CurData^.ShaderGroup := ShaderGroup;
  _CurData^.Method := ShaderGroup.FindMethodIndex(Method);
  _CurData^.ParamCount := 0;
  _CurData^.SamplerCount := 0;
  _CurData^.VertexStart := VertexStart;
  _CurData^.VertexCount := VertexCount;
  _CurData^.IndexStart := IndexStart;
  _CurData^.PrimCount := PrimCount;
end;

procedure TG2RenderControlBuffer.BufferEnd;
begin
  _Gfx.AddRenderQueueItem(Self, _CurData);
  Inc(_QueueCount[_FillID^]);
  _CurData := nil;
end;

procedure TG2RenderControlBuffer.ParamVec2(const Name: String; const Data: TG2Vec2);
begin
  AddParam(pt_vec2, Name, 0, 1, @Data, SizeOf(TG2Vec2));
end;

procedure TG2RenderControlBuffer.ParamVec3(const Name: String; const Data: TG2Vec3);
begin
  AddParam(pt_vec3, Name, 0, 1, @Data, SizeOf(TG2Vec3));
end;

procedure TG2RenderControlBuffer.ParamVec4(const Name: String; const Data: TG2Vec4);
begin
  AddParam(pt_vec4, Name, 0, 1, @Data, SizeOf(TG2Vec4));
end;

procedure TG2RenderControlBuffer.ParamMat4x4(const name: String; const Data: TG2Mat);
begin
  AddParam(pt_mat4x4, Name, 0, 1, @Data, SizeOf(TG2Mat));
end;

procedure TG2RenderControlBuffer.ParamMat4x3(const name: String; const Data: TG2Mat);
begin
  AddParam(pt_mat4x3, Name, 0, 1, @Data, SizeOf(TG2Mat));
end;

procedure TG2RenderControlBuffer.ParamMat4x4Arr(const Name: String; const Data: PG2MatArr; const Index, Count: TG2IntS32);
begin
  AddParam(pt_mat4x4, Name, Index, Count, PG2IntU8(Data), SizeOf(TG2Mat) * Count);
end;

procedure TG2RenderControlBuffer.ParamMat4x3Arr(const Name: String; const Data: PG2MatArr; const Index, Count: TG2IntS32);
begin
  AddParam(pt_mat4x3, Name, Index, Count, PG2IntU8(Data), SizeOf(TG2Mat) * Count);
end;

procedure TG2RenderControlBuffer.Sampler(const Name: String; const Texture: TG2Texture2DBase);
  var s: ^TShaderSampler;
begin
  if _CurData = nil then Exit;
  if _CurData^.SamplerCount >= Length(_CurData^.Samplers) then
  SetLength(_CurData^.Samplers, _CurData^.SamplerCount + 8);
  s := @_CurData^.Samplers[_CurData^.SamplerCount];
  s^.Name := Name;
  s^.Texture := Texture;
  Texture.LockAsset(_FillID^);
  _CurData^.SamplerCount := _CurData^.SamplerCount + 1;
end;

procedure TG2RenderControlBuffer.RenderBegin;
begin
  {$if defined(G2Gfx_D3D9)}

  {$elseif defined(G2Gfx_OGL)}

  {$elseif defined(G2Gfx_GLES)}

  {$endif}
end;

procedure TG2RenderControlBuffer.RenderEnd;
begin
  {$if defined(G2Gfx_D3D9)}

  {$elseif defined(G2Gfx_OGL)}

  {$elseif defined(G2Gfx_GLES)}

  {$endif}
end;

procedure TG2RenderControlBuffer.RenderData(const Data: Pointer);
{$if defined(G2Gfx_D3D9)}
  const PrimTypeRemap: array[0..5] of TD3DPrimitiveType = (
    D3DPT_POINTLIST,
    D3DPT_LINESTRIP,
    D3DPT_LINELIST,
    D3DPT_TRIANGLESTRIP,
    D3DPT_TRIANGLELIST,
    D3DPT_TRIANGLEFAN
  );
{$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
  const PrimTypeRemap: array[0..5] of GLenum = (
    GL_POINTS,
    GL_LINE_STRIP,
    GL_LINES,
    GL_TRIANGLE_STRIP,
    GL_TRIANGLES,
    GL_TRIANGLE_FAN
  );
{$endif}
  var BufferData: PBufferData;
  var i: TG2IntS32;
  var p: ^TShaderParam;
begin
  BufferData := PBufferData(Data);
  BufferData^.ShaderGroup.MethodIndex := BufferData^.Method;
  _Gfx.VertexBuffer := BufferData^.VertexBuffer;
  _Gfx.IndexBuffer := BufferData^.IndexBuffer;
  for i := 0 to BufferData^.SamplerCount - 1 do
  BufferData^.ShaderGroup.Sampler(BufferData^.Samplers[i].Name, BufferData^.Samplers[i].Texture, i);
  for i := 0 to BufferData^.ParamCount - 1 do
  begin
    p := @BufferData^.Params[i];
    case BufferData^.Params[i].ParamType of
      pt_float:
      begin
        BufferData^.ShaderGroup.UniformFloat1(p^.Name, PG2Float(@p^.Data[0])^);
      end;
      pt_vec2:
      begin
	BufferData^.ShaderGroup.UniformFloat2(p^.Name, PG2Vec2(@p^.Data[0])^);
      end;
      pt_vec3:
      begin
        BufferData^.ShaderGroup.UniformFloat3(p^.Name, PG2Vec3(@p^.Data[0])^);
      end;
      pt_vec4:
      begin
        BufferData^.ShaderGroup.UniformFloat4(p^.Name, PG2Vec4(@p^.Data[0])^);
      end;
      pt_mat4x4:
      begin
	if p^.Count > 1 then BufferData^.ShaderGroup.UniformMatrix4x4(p^.Name, PG2Mat(@p^.Data[0])^)
        else BufferData^.ShaderGroup.UniformMatrix4x4Arr(p^.Name, PG2Mat(@p^.Data[0]), p^.Index, p^.Count);
      end;
      pt_mat4x3:
      begin
	if p^.Count > 1 then BufferData^.ShaderGroup.UniformMatrix4x3(p^.Name, PG2Mat(@p^.Data[0])^)
        else BufferData^.ShaderGroup.UniformMatrix4x3Arr(p^.Name, PG2Mat(@p^.Data[0]), p^.Index, p^.Count);
      end;
    end;
  end;
{$if defined(G2Gfx_D3D9)}
  if BufferData^.IndexBuffer <> nil then
  begin
    _Gfx.Device.DrawIndexedPrimitive(
      PrimTypeRemap[Ord(BufferData^.PrimType)], 0,
      BufferData^.VertexStart, BufferData^.VertexCount,
      BufferData^.IndexStart, BufferData^.PrimCount
    );
  end
  else
  begin
    _Gfx.Device.DrawPrimitive(
      PrimTypeRemap[Ord(BufferData^.PrimType)],
      BufferData^.VertexStart, BufferData^.PrimCount
    );
  end;
{$elseif defined(G2Gfx_OGL)}
  if BufferData^.IndexBuffer <> nil then
  begin
    glDrawElements(
      PrimTypeRemap[Ord(BufferData^.PrimType)],
      BufferData^.PrimCount * 3, GL_UNSIGNED_SHORT,
      PGLvoid(BufferData^.IndexStart * 2)
    );
  end
  else
  begin
    glDrawArrays(
      PrimTypeRemap[Ord(BufferData^.PrimType)],
      BufferData^.VertexStart,
      BufferData^.PrimCount * 3
    );
  end;
{$endif}
end;

procedure TG2RenderControlBuffer.Reset;
begin
  _QueueCount[_FillID^] := 0;
end;

constructor TG2RenderControlBuffer.Create;
begin
  inherited Create;
  _QueueCapacity[0] := 0;
  _QueueCapacity[1] := 0;
  _QueueCount[0] := 0;
  _QueueCount[1] := 0;
  _CurData := nil;
  _Cache.Clear;
end;

destructor TG2RenderControlBuffer.Destroy;
  var n, i: TG2IntS32;
begin
  for n := 0 to 1 do
  for i := 0 to _QueueCapacity[n] - 1 do
  Dispose(_Queue[n][i]);
  for i := 0 to _Cache.Count - 1 do
  Dispose(PBufferData(_Cache[i]));
  inherited Destroy;
end;
//TG2RenderControlBuffer END
{$endif}

//TG2RenderControlLegacyMesh BEGIN
{$if defined(G2Gfx_D3D9)}
{$if defined(G2RM_FF)}
procedure TG2RenderControlLegacyMesh.RenderD3D9(const p: PBufferData);
  var PrevDepthEnable: Boolean;
  var g, CurStage: TG2IntS32;
  var Ambient: TG2Color;
begin
  Ambient := p^.Color;
  _Gfx.BlendMode := bmDisable;
  PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := True;
  _Gfx.CullMode := g2cm_ccw;
  _Gfx.Device.SetTransform(D3DTS_WORLD, p^.W);
  _Gfx.Device.SetTransform(D3DTS_VIEW, p^.V);
  _Gfx.Device.SetTransform(D3DTS_PROJECTION, p^.P);
  p^.VertexBuffer.Bind;
  p^.IndexBuffer.Bind;
  for g := 0 to p^.GroupCount - 1 do
  begin
    if p^.Groups[g].ColorTexture <> nil then
    begin
      _Gfx.Device.SetTexture(0, p^.Groups[g].ColorTexture.GetTexture);
      _Gfx.Device.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
      _Gfx.Device.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
      _Gfx.Device.SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);
      _Gfx.TextureStage[0].ColorOperation := g2tso_modulate;
      _Gfx.TextureStage[0].ColorArgument0 := g2tsa_constant;
      _Gfx.TextureStage[0].ColorArgument1 := g2tsa_texture;
      _Gfx.TextureStage[0].ConstantColor := Ambient;
    end;
    _Gfx.Device.DrawIndexedPrimitive(
      D3DPT_TRIANGLELIST,
      0,
      p^.Groups[g].VertexStart, p^.Groups[g].VertexCount,
      p^.Groups[g].IndexStart, p^.Groups[g].PrimCount
    );
  end;
  p^.IndexBuffer.Unbind;
  p^.VertexBuffer.Unbind;
  _Gfx.TextureStage[0].ColorOperation := g2tso_modulate;
  _Gfx.TextureStage[0].ColorArgument0 := g2tsa_diffuse;
  _Gfx.TextureStage[0].ColorArgument1 := g2tsa_texture;
  _Gfx.DepthEnable := PrevDepthEnable;
end;
{$else}
procedure TG2RenderControlLegacyMesh.RenderD3D9(const p: PBufferData);
  var WVP: TG2Mat;
  var g, PrevMethod: TG2IntS32;
  var PrevDepthEnable: Boolean;
  var Ambient: TG2Color;
begin
  Ambient := p^.Color;
  _Gfx.BlendMode := bmDisable;
  PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := True;
  _Gfx.Device.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(1, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(1, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(1, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);
  p^.VertexBuffer.Bind;
  p^.IndexBuffer.Bind;
  WVP := p^.W * p^.V * p^.P;
  PrevMethod := -1;
  for g := 0 to p^.GroupCount - 1 do
  begin
    if PrevMethod <> p^.Groups[g].Method then
    begin
      _ShaderGroup.MethodIndex := p^.Groups[g].Method;
      _ShaderGroup.UniformMatrix4x4('WVP', WVP);
      _ShaderGroup.UniformFloat4('LightAmbient', Ambient);
      if p^.Skinned then
      begin
        _ShaderGroup.UniformMatrix4x3Arr('SkinPallete', @p^.SkinPallete[0], 0, p^.BoneCount);
      end;
    end;
    if p^.Groups[g].ColorTexture <> nil then
    begin
      _ShaderGroup.Sampler('Tex0', p^.Groups[g].ColorTexture, 0);
    end;
    if p^.Groups[g].LightTexture <> nil then
    begin
      _ShaderGroup.Sampler('Tex1', p^.Groups[g].LightTexture, 1);
    end;
    _Gfx.Device.DrawIndexedPrimitive(
      D3DPT_TRIANGLELIST,
      0,
      p^.Groups[g].VertexStart, p^.Groups[g].VertexCount,
      p^.Groups[g].IndexStart, p^.Groups[g].PrimCount
    );
  end;
  p^.IndexBuffer.Unbind;
  p^.VertexBuffer.Unbind;
  _Gfx.DepthEnable := PrevDepthEnable;
end;
{$endif}
{$elseif defined(G2Gfx_OGL)}
{$if defined(G2RM_FF)}
procedure TG2RenderControlLegacyMesh.RenderOGL(const p: PBufferData);
  var PrevDepthEnable: Boolean;
  var g: TG2IntS32;
  var WV: TG2Mat;
  var Ambient: TG2Color;
begin
  Ambient := p^.Color;
  _Gfx.BlendMode := bmDisable;
  PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := True;
  glMatrixMode(GL_PROJECTION);
  glLoadMatrixf(@p^.P);
  glMatrixMode(GL_MODELVIEW);
  WV := p^.W * p^.V;
  glLoadMatrixf(@WV);
  p^.VertexBuffer.Bind;
  p^.IndexBuffer.Bind;
  for g := 0 to p^.GroupCount - 1 do
  begin
    if p^.Groups[g].ColorTexture <> nil then
    begin
      _Gfx.ActiveTexture := 0;
      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D, p^.Groups[g].ColorTexture.GetTexture);
      if p^.Groups[g].ColorTexture.Usage = tu3D then
      begin
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
      end
      else
      begin
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      end;
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      _Gfx.TextureStage[0].ColorOperation := g2tso_modulate;
      _Gfx.TextureStage[0].ColorArgument0 := g2tsa_texture;
      _Gfx.TextureStage[0].ColorArgument1 := g2tsa_constant;
      _Gfx.TextureStage[0].ConstantColor := Ambient;
    end;
    glDrawElements(
      GL_TRIANGLES,
      p^.Groups[g].PrimCount * 3,
      GL_UNSIGNED_SHORT,
      PGLVoid(p^.Groups[g].IndexStart * 2)
    );
  end;
  p^.IndexBuffer.Unbind;
  p^.VertexBuffer.Unbind;
  _Gfx.TextureStage[0].ColorOperation := g2tso_modulate;
  _Gfx.TextureStage[0].ColorArgument0 := g2tsa_diffuse;
  _Gfx.TextureStage[0].ColorArgument1 := g2tsa_texture;
  _Gfx.DepthEnable := PrevDepthEnable;
end;
{$else}
procedure TG2RenderControlLegacyMesh.RenderOGL(const p: PBufferData);
  var WVP: TG2Mat;
  var g, PrevMethod: TG2IntS32;
  var PrevDepthEnable: Boolean;
  var Ambient: TG2Color;
begin
  Ambient := p^.Color;
  PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := True;
  p^.VertexBuffer.Bind;
  p^.IndexBuffer.Bind;
  WVP := p^.W * p^.V * p^.P;
  PrevMethod := -1;
  for g := 0 to p^.GroupCount - 1 do
  begin
    if PrevMethod <> p^.Groups[g].Method then
    begin
      _ShaderGroup.MethodIndex := p^.Groups[g].Method;
      _ShaderGroup.UniformMatrix4x4('WVP', WVP);
      _ShaderGroup.UniformFloat4('LightAmbient', Ambient);
      if p^.Skinned then
      begin
        _ShaderGroup.UniformMatrix4x3Arr('SkinPallete', @p^.SkinPallete[0], 0, p^.BoneCount);
      end;
    end;
    if p^.Groups[g].ColorTexture <> nil then
    begin
      _ShaderGroup.Sampler('Tex0', p^.Groups[g].ColorTexture, 0);
    end;
    if p^.Groups[g].LightTexture <> nil then
    begin
      _ShaderGroup.Sampler('Tex1', p^.Groups[g].LightTexture, 1);
    end;
    glDrawElements(
      GL_TRIANGLES,
      p^.Groups[g].PrimCount * 3,
      GL_UNSIGNED_SHORT,
      PGLVoid(p^.Groups[g].IndexStart * 2)
    );
  end;
  p^.IndexBuffer.Unbind;
  p^.VertexBuffer.Unbind;
  _Gfx.DepthEnable := PrevDepthEnable;
end;
{$endif}
{$elseif defined(G2Gfx_GLES)}
{$if defined(G2RM_FF)}
procedure TG2RenderControlLegacyMesh.RenderOGL(const p: PBufferData);
  var PrevDepthEnable: Boolean;
  var g: TG2IntS32;
  var WV: TG2Mat;
  var Ambient: TG2Color;
begin
  Ambient := p^.Color;
  PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := True;
  glMatrixMode(GL_PROJECTION);
  glLoadMatrixf(@p^.P);
  glMatrixMode(GL_MODELVIEW);
  WV := p^.W * p^.V;
  glLoadMatrixf(@WV);
  p^.VertexBuffer.Bind;
  p^.IndexBuffer.Bind;
  for g := 0 to p^.GroupCount - 1 do
  begin
    if p^.Groups[g].ColorTexture <> nil then
    begin
      _Gfx.ActiveTexture := 0;
      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D, p^.Groups[g].ColorTexture.GetTexture);
      if p^.Groups[g].ColorTexture.Usage = tu3D then
      begin
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
      end
      else
      begin
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      end;
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      _Gfx.TextureStage[0].ColorOperation := g2tso_modulate;
      _Gfx.TextureStage[0].ColorArgument0 := g2tsa_texture;
      _Gfx.TextureStage[0].ColorArgument1 := g2tsa_constant;
      _Gfx.TextureStage[0].ConstantColor := Ambient;
    end;
    glDrawElements(
      GL_TRIANGLES,
      p^.Groups[g].PrimCount * 3,
      GL_UNSIGNED_SHORT,
      PGLVoid(p^.Groups[g].IndexStart * 2)
    );
  end;
  p^.IndexBuffer.Unbind;
  p^.VertexBuffer.Unbind;
  _Gfx.TextureStage[0].ColorOperation := g2tso_modulate;
  _Gfx.TextureStage[0].ColorArgument0 := g2tsa_diffuse;
  _Gfx.TextureStage[0].ColorArgument1 := g2tsa_texture;
  _Gfx.DepthEnable := PrevDepthEnable;
end;
{$else}
procedure TG2RenderControlLegacyMesh.RenderOGL(const p: PBufferData);
  var WVP: TG2Mat;
  var g, PrevMethod: TG2IntS32;
  var PrevDepthEnable: Boolean;
  var Ambient: TG2Color;
begin
  Ambient := p^.Color;
  PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := True;
  p^.VertexBuffer.Bind;
  p^.IndexBuffer.Bind;
  WVP := p^.W * p^.V * p^.P;
  PrevMethod := -1;
  for g := 0 to p^.GroupCount - 1 do
  begin
    if PrevMethod <> p^.Groups[g].Method then
    begin
      _ShaderGroup.MethodIndex := p^.Groups[g].Method;
      _ShaderGroup.UniformMatrix4x4('WVP', WVP);
      _ShaderGroup.UniformFloat4('LightAmbient', Ambient);
      if p^.Skinned then
      begin
        _ShaderGroup.UniformMatrix4x3Arr('SkinPallete', @p^.SkinPallete[0], 0, p^.BoneCount);
      end;
    end;
    if p^.Groups[g].ColorTexture <> nil then
    begin
      _ShaderGroup.Sampler('Tex0', p^.Groups[g].ColorTexture, 0);
    end;
    if p^.Groups[g].LightTexture <> nil then
    begin
      _ShaderGroup.Sampler('Tex1', p^.Groups[g].LightTexture, 1);
    end;
    glDrawElements(
      GL_TRIANGLES,
      p^.Groups[g].PrimCount * 3,
      GL_UNSIGNED_SHORT,
      PGLVoid(p^.Groups[g].IndexStart * 2)
    );
  end;
  p^.IndexBuffer.Unbind;
  p^.VertexBuffer.Unbind;
  _Gfx.DepthEnable := PrevDepthEnable;
end;
{$endif}
{$endif}

procedure TG2RenderControlLegacyMesh.CheckCapacity;
  var n, i: TG2IntS32;
begin
  if _QueueCount[_FillID^] >= _QueueCapacity[_FillID^] then
  begin
    n := _QueueCapacity[_FillID^];
    _QueueCapacity[_FillID^] := _QueueCapacity[_FillID^] + 128;
    SetLength(_Queue[_FillID^], _QueueCapacity[_FillID^]);
    for i := n to _QueueCapacity[_FillID^] - 1 do
    New(_Queue[_FillID^][i]);
  end;
end;

procedure TG2RenderControlLegacyMesh.RenderInstance(const Instance: TG2LegacyMeshInst; const W, V, P: TG2Mat);
  var pb: PBufferData;
  var i, g: TG2IntS32;
  {$if not defined(G2RM_FF)}
  var wc: TG2IntS32;
  var DataSkinned: PG2LegacyGeomDataSkinned;
  var ShaderMethod: String;
  {$endif}
  var Geom: PG2LegacyMeshGeom;
  var DataStatic: PG2LegacyGeomDataStatic;
  var Material: PG2LegacyMeshMaterial;
begin
  for i := 0 to Instance.Mesh.Geoms.Count - 1 do
  if Instance.Mesh.Geoms[i]^.Visible then
  begin
    CheckCapacity;
    pb := _Queue[_FillID^][_QueueCount[_FillID^]];
    pb^.Color := Instance.Color;
    Geom := Instance.Mesh.Geoms[i];
    pb^.Skinned := Geom^.Skinned;
    pb^.V := V;
    pb^.P := P;
    if pb^.Skinned then
    begin
      {$if defined(G2RM_FF)}
      Instance.UpdateSkin(i, _FillID^);
      pb^.VertexBuffer := Instance.Skins[i]^.VB[_FillID^];
      {$else}
      DataSkinned := PG2LegacyGeomDataSkinned(Geom^.Data);
      pb^.VertexBuffer := DataSkinned^.VB;
      pb^.BoneCount := DataSkinned^.BoneCount;
      if Length(pb^.SkinPallete) < pb^.BoneCount then SetLength(pb^.SkinPallete, pb^.BoneCount);
      Move(Instance.SkinTransforms[i]^, pb^.SkinPallete[0], SizeOf(TG2Mat) * pb^.BoneCount);
      wc := DataSkinned^.MaxWeights;
      {$endif}
      pb^.W := W;
    end
    else
    begin
      DataStatic := PG2LegacyGeomDataStatic(Geom^.Data);
      pb^.VertexBuffer := DataStatic^.VB;
      {$if not defined(G2RM_FF)}
      wc := 0;
      {$endif}
      pb^.W := Instance.Transforms[Geom^.NodeID].TransformCom * W;
    end;
    pb^.VertexBuffer.LockAsset(_FillID^);
    pb^.IndexBuffer := Geom^.IB;
    pb^.IndexBuffer.LockAsset(_FillID^);
    pb^.GroupCount := Geom^.GCount;
    if Length(pb^.Groups) < pb^.GroupCount then SetLength(pb^.Groups, pb^.GroupCount);
    for g := 0 to Geom^.GCount - 1 do
    begin
      Material := Instance.Mesh.Materials[Geom^.Groups[g].Material];
      if (Material^.ChannelCount > 0) then
      begin
        pb^.Groups[g].ColorTexture := Material^.Channels[0].MapDiffuse;
        pb^.Groups[g].LightTexture := Material^.Channels[0].MapLight;
      end
      else
      begin
        pb^.Groups[g].ColorTexture := nil;
        pb^.Groups[g].LightTexture := nil;
      end;
      if Assigned(pb^.Groups[g].ColorTexture) then pb^.Groups[g].ColorTexture.LockAsset(_FillID^);
      if Assigned(pb^.Groups[g].LightTexture) then pb^.Groups[g].LightTexture.LockAsset(_FillID^);
      {$if defined(G2RM_SM2)}
      ShaderMethod := 'SceneB' + IntToStr(wc);
      if Assigned(pb^.Groups[g].LightTexture) then ShaderMethod += 'L';
      pb^.Groups[g].Method := _ShaderGroup.FindMethodIndex(ShaderMethod);
      {$endif}
      pb^.Groups[g].VertexStart := Geom^.Groups[g].VertexStart;
      pb^.Groups[g].IndexStart := Geom^.Groups[g].FaceStart * 3;
      pb^.Groups[g].VertexCount := Geom^.Groups[g].VertexCount;
      pb^.Groups[g].PrimCount := Geom^.Groups[g].FaceCount;
    end;
    _Gfx.AddRenderQueueItem(Self, pb);
    Inc(_QueueCount[_FillID^]);
  end;
end;

procedure TG2RenderControlLegacyMesh.RenderBegin;
begin
  _Gfx.CullMode := g2cm_ccw;
  {$if defined(G2Gfx_D3D9)}
  {$if defined(G2RM_FF)}
  _Gfx.Device.SetRenderState(D3DRS_LIGHTING, 0);
  {$endif}
  {$endif}
end;

procedure TG2RenderControlLegacyMesh.RenderEnd;
begin
  {$if defined(G2Gfx_D3D9)}
  {$if defined(G2RM_FF)}
  _Gfx.Device.SetRenderState(D3DRS_LIGHTING, 0);
  {$endif}
  {$endif}
end;

procedure TG2RenderControlLegacyMesh.RenderData(const Data: Pointer);
  var p: PBufferData absolute Data;
begin
  {$if defined(G2Gfx_D3D9)}
  RenderD3D9(p);
  {$elseif defined(G2Gfx_OGL)}
  RenderOGL(p);
  {$elseif defined(G2Gfx_GLES)}
  RenderGLES(p);
  {$endif}
end;

procedure TG2RenderControlLegacyMesh.Reset;
begin
  _QueueCount[_FillID^] := 0;
end;

constructor TG2RenderControlLegacyMesh.Create;
begin
  inherited Create;
  {$if defined(G2RM_SM2)}
  _ShaderGroup := _Gfx.RequestShader('StandardShaders');
  {$endif}
end;

destructor TG2RenderControlLegacyMesh.Destroy;
begin
  inherited Destroy;
end;
//TG2RenderControlLegacyMesh END

//TG2RenderControlPic2D BEGIN
procedure TG2RenderControlPic2D.CheckCapacity;
  var n, i: TG2IntS32;
begin
  if _QueueCount[_FillID^] >= _QueueCapacity[_FillID^] then
  begin
    n := _QueueCapacity[_FillID^];
    _QueueCapacity[_FillID^] := _QueueCapacity[_FillID^] + 128;
    SetLength(_Queue[_FillID^], _QueueCapacity[_FillID^]);
    for i := n to _QueueCapacity[_FillID^] - 1 do
    New(_Queue[_FillID^][i]);
  end;
end;

procedure TG2RenderControlPic2D.Flush;
begin
  {$if defined(G2Gfx_D3D9)}
  _Gfx.Device.DrawIndexedPrimitiveUP(D3DPT_TRIANGLELIST, 0, _CurQuad * 4, _CurQuad * 2, _Indices[0], D3DFMT_INDEX16, _Vertices[0], SizeOf(TG2Pic2DVertex));
  {$elseif defined(G2Gfx_OGL)}
  glEnd;
  {$elseif defined(G2Gfx_GLES)}
  glVertexPointer(3, GL_FLOAT, 0, @_VertPositions[0]);
  glColorPointer(4, GL_FLOAT, 0, @_VertColors[0]);
  glTexCoordPointer(2, GL_FLOAT, 0, @_VertTexCoords[0]);
  if _Gfx.BlendMode.BlendSeparate then
  begin
    _Gfx.MaskColor;
    glDrawElements(GL_TRIANGLES, _CurQuad * 6, GL_UNSIGNED_SHORT, @_Indices[0]);
    _Gfx.MaskAlpha;
    _Gfx.SwapBlendMode;
    glDrawElements(GL_TRIANGLES, _CurQuad * 6, GL_UNSIGNED_SHORT, @_Indices[0]);
    _Gfx.MaskAll;
    _Gfx.SwapBlendMode;
  end
  else
  glDrawElements(GL_TRIANGLES, _CurQuad * 6, GL_UNSIGNED_SHORT, @_Indices[0]);
  {$endif}
  _CurQuad := 0;
end;

procedure TG2RenderControlPic2D.DrawQuad(
  const Pos0, Pos1, Pos2, Pos3: TG2Vec2;
  const Tex0, Tex1, Tex2, Tex3: TG2Vec2;
  const c0, c1, c2, c3: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef;
  const Filter: TG2Filter = tfPoint
);
  var p: PG2Pic2D;
begin
  CheckCapacity;
  p := _Queue[_FillID^][_QueueCount[_FillID^]];
  p^.Pos0 := Pos0; p^.Pos1 := Pos1; p^.Pos2 := Pos2; p^.Pos3 := Pos3;
  p^.Tex0 := Tex0; p^.Tex1 := Tex1; p^.Tex2 := Tex2; p^.Tex3 := Tex3;
  p^.c0 := c0; p^.c1 := c1; p^.c2 := c2; p^.c3 := c3;
  p^.Texture := Texture;
  p^.BlendMode := BlendMode;
  p^.Filter := Filter;
  Texture.LockAsset(_FillID^);
  _Gfx.AddRenderQueueItem(Self, p);
  Inc(_QueueCount[_FillID^]);
end;

procedure TG2RenderControlPic2D.RenderBegin;
{$if defined(G2RM_SM2)}
  var WVP: TG2Mat;
{$endif}
begin
  _PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := False;
  _Gfx.CullMode := g2cm_none;
  _CurTexture := nil;
  _CurBlendMode := bmInvalid;
  _CurFilter := tfNone;
  _CurQuad := 0;
  {$if defined(G2RM_FF)}
  {$if defined(G2Gfx_D3D9)}
  _Gfx.Device.SetFVF(D3DFVF_XYZRHW or D3DFVF_DIFFUSE or D3DFVF_TEX1);
  {$elseif defined(G2Gfx_OGL)}
  _Gfx.SetProj2D;
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  glEnable(GL_TEXTURE_2D);
  {$elseif defined(G2Gfx_GLES)}
  _Gfx.SetProj2D;
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_COLOR_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  {$endif}
  {$elseif defined(G2RM_SM2)}
  _ShaderGroup.Method := 'Pic';
  {$if defined(G2Gfx_D3D9)}
  _Gfx.Device.SetVertexDeclaration(_Decl);
  WVP := G2MatOrth2D(_Gfx.SizeRT.x, _Gfx.SizeRT.y, 0, 1);
  {$elseif defined(G2Gfx_OGL)}
  glEnable(GL_TEXTURE_2D);
  _AttribPosition := _ShaderGroup.Attribute('a_Position0');
  _AttribColor := _ShaderGroup.Attribute('a_Color0');
  _AttribTexCoord := _ShaderGroup.Attribute('a_TexCoord0');
  if _Gfx.RenderTarget = nil then
  WVP := G2MatOrth2D(_Gfx.SizeRT.x, _Gfx.SizeRT.y, 0, 1)
  else
  WVP := G2MatOrth2D(_Gfx.SizeRT.x, _Gfx.SizeRT.y, 0, 1, False, False);
  {$endif}
  _ShaderGroup.UniformMatrix4x4('WVP', WVP);
  {$endif}
end;

procedure TG2RenderControlPic2D.RenderEnd;
begin
  if _CurQuad > 0 then Flush;
  {$if defined(G2RM_FF)}
  {$ifdef G2Gfx_GLES}
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_COLOR_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  {$endif}
  {$elseif defined(G2RM_SM2)}

  {$endif}
  _Gfx.DepthEnable := _PrevDepthEnable;
end;

procedure TG2RenderControlPic2D.RenderData(const Data: Pointer);
  var p: PG2Pic2D;
  {$if defined(G2Gfx_D3D9)}
  var v: PG2Pic2DVertex;
  {$elseif defined(G2Gfx_GLES)}
  var v: TG2IntS32;
  {$endif}
begin
  p := PG2Pic2D(Data);
  if (p^.Texture <> _CurTexture)
  or (p^.BlendMode <> _CurBlendMode)
  or (p^.Filter <> _CurFilter)
  or (_CurQuad >= _MaxQuads)then
  begin
    if _CurQuad > 0 then Flush;
    if (p^.Texture <> _CurTexture) then
    begin
      _CurTexture := p^.Texture;
      {$if defined(G2Gfx_D3D9)}
      {$if defined(G2RM_FF)}
      _Gfx.Device.SetTexture(0, _CurTexture.GetTexture);
      {$elseif defined(G2RM_SM2)}
      _ShaderGroup.Sampler('Tex0', _CurTexture);
      {$endif}
      {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
      {$if defined(G2RM_FF)}
      glBindTexture(GL_TEXTURE_2D, _CurTexture.GetTexture);
      {$elseif defined(G2RM_SM2)}
      _ShaderGroup.Sampler('Tex0', _CurTexture);
      {$endif}
      {$if not defined(G2Gfx_GLES)}
      _Gfx.EnableMipMaps(_CurTexture.Usage = tu3D);
      {$endif}
      _CurFilter := p^.Filter;
      _Gfx.Filter := _CurFilter;
      {$endif}
    end;
    if (p^.BlendMode <> _CurBlendMode) then
    begin
      _CurBlendMode := p^.BlendMode;
      _Gfx.BlendMode := _CurBlendMode;
    end;
    if (p^.Filter <> _CurFilter) then
    begin
      _CurFilter := p^.Filter;
      _Gfx.Filter := _CurFilter;
    end;
    {$if defined(G2Gfx_OGL)}
    glBegin(GL_QUADS);
    {$endif}
  end;
  {$if defined(G2Gfx_D3D9)}
  v := @_Vertices[_CurQuad * 4];
  {$if defined(G2RM_FF)}
  v^.x := p^.Pos0.x - 0.0125; v^.y := p^.Pos0.y - 0.0125; v^.z := 0; v^.rhw := 1;
  v^.Color := p^.c0; v^.tu := p^.Tex0.x; v^.tv := p^.Tex0.y; Inc(v);
  v^.x := p^.Pos1.x - 0.0125; v^.y := p^.Pos1.y - 0.0125; v^.z := 0; v^.rhw := 1;
  v^.Color := p^.c1; v^.tu := p^.Tex1.x; v^.tv := p^.Tex1.y; Inc(v);
  v^.x := p^.Pos2.x - 0.0125; v^.y := p^.Pos2.y - 0.0125; v^.z := 0; v^.rhw := 1;
  v^.Color := p^.c2; v^.tu := p^.Tex2.x; v^.tv := p^.Tex2.y; Inc(v);
  v^.x := p^.Pos3.x - 0.0125; v^.y := p^.Pos3.y - 0.0125; v^.z := 0; v^.rhw := 1;
  v^.Color := p^.c3; v^.tu := p^.Tex3.x; v^.tv := p^.Tex3.y;
  {$elseif defined(G2RM_SM2)}
  v^.x := p^.Pos0.x - 0.0125; v^.y := p^.Pos0.y - 0.0125; v^.z := 0;
  v^.Color := p^.c0; v^.tu := p^.Tex0.x; v^.tv := p^.Tex0.y; Inc(v);
  v^.x := p^.Pos1.x - 0.0125; v^.y := p^.Pos1.y - 0.0125; v^.z := 0;
  v^.Color := p^.c1; v^.tu := p^.Tex1.x; v^.tv := p^.Tex1.y; Inc(v);
  v^.x := p^.Pos2.x - 0.0125; v^.y := p^.Pos2.y - 0.0125; v^.z := 0;
  v^.Color := p^.c2; v^.tu := p^.Tex2.x; v^.tv := p^.Tex2.y; Inc(v);
  v^.x := p^.Pos3.x - 0.0125; v^.y := p^.Pos3.y - 0.0125; v^.z := 0;
  v^.Color := p^.c3; v^.tu := p^.Tex3.x; v^.tv := p^.Tex3.y;
  {$endif}
  {$elseif defined(G2Gfx_OGL)}
  {$if defined(G2RM_FF)}
  glColor4f(p^.c0.r * G2Rcp255, p^.c0.g * G2Rcp255, p^.c0.b * G2Rcp255, p^.c0.a * G2Rcp255);
  glTexCoord2f(p^.Tex0.x, p^.Tex0.y); glVertex3f(p^.Pos0.x, p^.Pos0.y, 0);
  glColor4f(p^.c1.r * G2Rcp255, p^.c1.g * G2Rcp255, p^.c1.b * G2Rcp255, p^.c1.a * G2Rcp255);
  glTexCoord2f(p^.Tex1.x, p^.Tex1.y); glVertex3f(p^.Pos1.x, p^.Pos1.y, 0);
  glColor4f(p^.c3.r * G2Rcp255, p^.c3.g * G2Rcp255, p^.c3.b * G2Rcp255, p^.c3.a * G2Rcp255);
  glTexCoord2f(p^.Tex3.x, p^.Tex3.y); glVertex3f(p^.Pos3.x, p^.Pos3.y, 0);
  glColor4f(p^.c2.r * G2Rcp255, p^.c2.g * G2Rcp255, p^.c2.b * G2Rcp255, p^.c2.a * G2Rcp255);
  glTexCoord2f(p^.Tex2.x, p^.Tex2.y); glVertex3f(p^.Pos2.x, p^.Pos2.y, 0);
  {$elseif defined(G2RM_SM2)}
  glVertexAttrib4f(_AttribColor, p^.c0.r * G2Rcp255, p^.c0.g * G2Rcp255, p^.c0.b * G2Rcp255, p^.c0.a * G2Rcp255);
  glVertexAttrib2f(_AttribTexCoord, p^.Tex0.x, p^.Tex0.y); glVertexAttrib3f(_AttribPosition, p^.Pos0.x, p^.Pos0.y, 0);
  glVertexAttrib4f(_AttribColor, p^.c1.r * G2Rcp255, p^.c1.g * G2Rcp255, p^.c1.b * G2Rcp255, p^.c1.a * G2Rcp255);
  glVertexAttrib2f(_AttribTexCoord, p^.Tex1.x, p^.Tex1.y); glVertexAttrib3f(_AttribPosition, p^.Pos1.x, p^.Pos1.y, 0);
  glVertexAttrib4f(_AttribColor, p^.c3.r * G2Rcp255, p^.c3.g * G2Rcp255, p^.c3.b * G2Rcp255, p^.c3.a * G2Rcp255);
  glVertexAttrib2f(_AttribTexCoord, p^.Tex3.x, p^.Tex3.y); glVertexAttrib3f(_AttribPosition, p^.Pos3.x, p^.Pos3.y, 0);
  glVertexAttrib4f(_AttribColor, p^.c2.r * G2Rcp255, p^.c2.g * G2Rcp255, p^.c2.b * G2Rcp255, p^.c2.a * G2Rcp255);
  glVertexAttrib2f(_AttribTexCoord, p^.Tex2.x, p^.Tex2.y); glVertexAttrib3f(_AttribPosition, p^.Pos2.x, p^.Pos2.y, 0);
  {$endif}
  {$elseif defined(G2Gfx_GLES)}
  v := _CurQuad * 4;
  _VertPositions[v].SetValue(p^.Pos0.x, p^.Pos0.y, 0);
  _VertColors[v].SetValue(p^.c0.r * G2Rcp255, p^.c0.g * G2Rcp255, p^.c0.b * G2Rcp255, p^.c0.a * G2Rcp255);
  _VertTexCoords[v] := p^.Tex0; Inc(v);
  _VertPositions[v].SetValue(p^.Pos1.x, p^.Pos1.y, 0);
  _VertColors[v].SetValue(p^.c1.r * G2Rcp255, p^.c1.g * G2Rcp255, p^.c1.b * G2Rcp255, p^.c1.a * G2Rcp255);
  _VertTexCoords[v] := p^.Tex1; Inc(v);
  _VertPositions[v].SetValue(p^.Pos2.x, p^.Pos2.y, 0);
  _VertColors[v].SetValue(p^.c2.r * G2Rcp255, p^.c2.g * G2Rcp255, p^.c2.b * G2Rcp255, p^.c2.a * G2Rcp255);
  _VertTexCoords[v] := p^.Tex2; Inc(v);
  _VertPositions[v].SetValue(p^.Pos3.x, p^.Pos3.y, 0);
  _VertColors[v].SetValue(p^.c3.r * G2Rcp255, p^.c3.g * G2Rcp255, p^.c3.b * G2Rcp255, p^.c3.a * G2Rcp255);
  _VertTexCoords[v] := p^.Tex3; Inc(v);
  {$endif}
  Inc(_CurQuad);
end;

procedure TG2RenderControlPic2D.Reset;
begin
  _QueueCount[_FillID^] := 0;
end;

constructor TG2RenderControlPic2D.Create;
{$if defined(G2Gfx_D3D9)}
  var i: TG2IntS32;
{$if defined(G2RM_SM2)}
  var ve: array [0..3] of TD3DVertexElement9;
{$endif}
{$elseif defined(G2Gfx_GLES)}
  var i: TG2IntS32;
{$endif}
begin
  inherited Create;
  _QueueCapacity[0] := 0;
  _QueueCapacity[1] := 0;
  _QueueCount[0] := 0;
  _QueueCount[1] := 0;
  _MaxQuads := 8000;
  {$if defined(G2RM_SM2)}
  _ShaderGroup := _Gfx.RequestShader('StandardShaders');
  {$endif}
  {$if defined(G2Gfx_D3D9)}
  {$if defined(G2RM_SM2)}
  ve[0] := D3DVertexElement(0, D3DDECLTYPE_FLOAT3, D3DDECLUSAGE_POSITION);
  ve[1] := D3DVertexElement(12, D3DDECLTYPE_D3DCOLOR, D3DDECLUSAGE_COLOR);
  ve[2] := D3DVertexElement(16, D3DDECLTYPE_FLOAT2, D3DDECLUSAGE_TEXCOORD);
  ve[3] := D3DDECL_END;
  _Gfx.Device.CreateVertexDeclaration(@ve, _Decl);
  {$endif}
  SetLength(_Vertices, _MaxQuads * 4);
  SetLength(_Indices, _MaxQuads * 6);
  for i := 0 to _MaxQuads - 1 do
  begin
    _Indices[i * 6 + 0] := i * 4 + 0;
    _Indices[i * 6 + 1] := i * 4 + 1;
    _Indices[i * 6 + 2] := i * 4 + 2;
    _Indices[i * 6 + 3] := i * 4 + 2;
    _Indices[i * 6 + 4] := i * 4 + 1;
    _Indices[i * 6 + 5] := i * 4 + 3;
  end;
  {$elseif defined(G2Gfx_GLES)}
  SetLength(_VertPositions, _MaxQuads * 4);
  SetLength(_VertColors, _MaxQuads * 4);
  SetLength(_VertTexCoords, _MaxQuads * 4);
  SetLength(_Indices, _MaxQuads * 6);
  for i := 0 to _MaxQuads - 1 do
  begin
    _Indices[i * 6 + 0] := i * 4 + 0;
    _Indices[i * 6 + 1] := i * 4 + 1;
    _Indices[i * 6 + 2] := i * 4 + 2;
    _Indices[i * 6 + 3] := i * 4 + 2;
    _Indices[i * 6 + 4] := i * 4 + 1;
    _Indices[i * 6 + 5] := i * 4 + 3;
  end;
  {$endif}
end;

destructor TG2RenderControlPic2D.Destroy;
  var n, i: TG2IntS32;
begin
  for n := 0 to 1 do
  for i := 0 to _QueueCapacity[n] - 1 do
  Dispose(_Queue[n][i]);
  {$ifdef G2Gfx_D3D9}
  _Vertices := nil;
  _Indices := nil;
  {$if defined(G2RM_SM2)}
  SafeRelease(_Decl);
  {$endif}
  {$endif}
  inherited Destroy;
end;
//TG2RenderControlPic2D END

//TG2RenderControlPrim2D BEGIN
procedure TG2RenderControlPrim2D.CheckCapacity;
  var n, i: TG2IntS32;
begin
  if _QueueCount[_FillID^] >= _QueueCapacity[_FillID^] then
  begin
    n := _QueueCapacity[_FillID^];
    _QueueCapacity[_FillID^] := _QueueCapacity[_FillID^] + 128;
    SetLength(_Queue[_FillID^], _QueueCapacity[_FillID^]);
    for i := n to _QueueCapacity[_FillID^] - 1 do
    begin
      New(_Queue[_FillID^][i]);
      _Queue[_FillID^][i]^.Count := 0;
      _Queue[_FillID^][i]^.PrimType := ptNone;
      SetLength(_Queue[_FillID^][i]^.Points, 32);
    end;
  end;
end;

procedure TG2RenderControlPrim2D.Flush;
begin
  {$if defined(G2Gfx_D3D9)}
  case _CurPrimType of
    ptLines:
    begin
      if _CurPoint mod 2 = 0 then
      _Gfx.Device.DrawPrimitiveUP(D3DPT_LINELIST, _CurPoint div 2, _Vertices[0], SizeOf(TG2Prim2DVertex));
    end;
    ptTriangles:
    begin
      if _CurPoint mod 3 = 0 then
      _Gfx.Device.DrawPrimitiveUP(D3DPT_TRIANGLELIST, _CurPoint div 3, _Vertices[0], SizeOf(TG2Prim2DVertex));
    end;
  end;
  {$elseif defined(G2Gfx_OGL)}
  glEnd;
  {$elseif defined(G2Gfx_GLES)}
  glVertexPointer(3, GL_FLOAT, 0, @_VertPositions[0]);
  glColorPointer(4, GL_FLOAT, 0, @_VertColors[0]);
  case _CurPrimType of
    ptLines:
    begin
      if _CurPoint mod 2 = 0 then
      begin
        if _Gfx.BlendMode.BlendSeparate then
        begin
          _Gfx.MaskColor;
          glDrawElements(GL_LINES, _CurPoint, GL_UNSIGNED_SHORT, @_Indices[0]);
          _Gfx.MaskAlpha;
          _Gfx.SwapBlendMode;
          glDrawElements(GL_LINES, _CurPoint, GL_UNSIGNED_SHORT, @_Indices[0]);
          _Gfx.MaskAll;
          _Gfx.SwapBlendMode;
        end
        else
        glDrawElements(GL_LINES, _CurPoint, GL_UNSIGNED_SHORT, @_Indices[0]);
      end;
    end;
    ptTriangles:
    begin
      if _CurPoint mod 3 = 0 then
      glDrawElements(GL_TRIANGLES, _CurPoint, GL_UNSIGNED_SHORT, @_Indices[0]);
    end;
  end;
  {$endif}
  _CurPoint := 0;
end;

procedure TG2RenderControlPrim2D.PrimBegin(const PrimType: TG2PrimType; const BlendMode: TG2BlendMode);
begin
  if _CurPrim <> nil then PrimEnd;
  CheckCapacity;
  _CurPrim := _Queue[_FillID^][_QueueCount[_FillID^]];
  _CurPrim^.Count := 0;
  _CurPrim^.PrimType := PrimType;
  _CurPrim^.BlendMode := BlendMode;
end;

procedure TG2RenderControlPrim2D.PrimEnd;
begin
  if _CurPrim = nil then Exit;
  _Gfx.AddRenderQueueItem(Self, _CurPrim);
  Inc(_QueueCount[_FillID^]);
  _CurPrim := nil;
end;

procedure TG2RenderControlPrim2D.PrimAdd(const x, y: TG2Float; const Color: TG2Color);
begin
  if _CurPrim = nil then Exit;
  if _CurPrim^.Count + 4 > _MaxPoints then
  begin
    if ((_CurPrim^.PrimType = ptLines) and (_CurPrim^.Count mod 2 = 0))
    or ((_CurPrim^.PrimType = ptTriangles) and (_CurPrim^.Count mod 3 = 0)) then
    PrimBegin(_CurPrim^.PrimType, _CurPrim^.BlendMode);
  end;
  if _CurPrim^.Count >= Length(_CurPrim^.Points) then
  SetLength(_CurPrim^.Points, Length(_CurPrim^.Points) + 32);
  _CurPrim^.Points[_CurPrim^.Count].x := x;
  _CurPrim^.Points[_CurPrim^.Count].y := y;
  _CurPrim^.Points[_CurPrim^.Count].Color := Color;
  Inc(_CurPrim^.Count);
end;

procedure TG2RenderControlPrim2D.RenderBegin;
{$if defined(G2RM_SM2)}
  var WVP: TG2Mat;
{$endif}
begin
  _PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := False;
  _Gfx.CullMode := g2cm_none;
  _CurPoint := 0;
  _CurPrimType := ptNone;
  _CurBlendMode := bmInvalid;
  {$if defined(G2RM_FF)}
  {$if defined(G2Gfx_D3D9)}
  _Gfx.Device.SetFVF(D3DFVF_XYZRHW or D3DFVF_DIFFUSE);
  _Gfx.Device.SetTexture(0, nil);
  {$elseif defined(G2Gfx_OGL)}
  _Gfx.SetProj2D;
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  glDisable(GL_TEXTURE_2D);
  {$elseif defined(G2Gfx_GLES)}
  _Gfx.SetProj2D;
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  glDisable(GL_TEXTURE_2D);
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_COLOR_ARRAY);
  {$endif}
  {$elseif defined(G2RM_SM2)}
  _ShaderGroup.Method := 'Prim';
  {$if defined(G2Gfx_D3D9)}
  _Gfx.Device.SetVertexDeclaration(_Decl);
  WVP := G2MatOrth2D(_Gfx.SizeRT.x, _Gfx.SizeRT.y, 0, 1);
  {$elseif defined(G2Gfx_OGL)}
  _AttribPosition := _ShaderGroup.Attribute('a_Position0');
  _AttribColor := _ShaderGroup.Attribute('a_Color0');
  if _Gfx.RenderTarget = nil then
  WVP := G2MatOrth2D(_Gfx.SizeRT.x, _Gfx.SizeRT.y, 0, 1)
  else
  WVP := G2MatOrth2D(_Gfx.SizeRT.x, _Gfx.SizeRT.y, 0, 1, False, False);
  glDisable(GL_TEXTURE_2D);
  {$endif}
  _ShaderGroup.UniformMatrix4x4('WVP', WVP);
  {$endif}
  _Gfx.BlendMode := bmNormal;
end;

procedure TG2RenderControlPrim2D.RenderEnd;
begin
  if _CurPoint > 0 then Flush;
  {$if defined(G2RM_FF)}
  {$if defined(G2Gfx_OGL)}
  glEnable(GL_TEXTURE_2D);
  {$elseif defined(G2Gfx_GLES)}
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_COLOR_ARRAY);
  glEnable(GL_TEXTURE_2D);
  {$endif}
  {$elseif defined(G2RM_SM2)}
  {$if defined(G2Gfx_OGL)}
  glEnable(GL_TEXTURE_2D);
  {$endif}
  {$endif}
  _Gfx.DepthEnable := _PrevDepthEnable;
end;

procedure TG2RenderControlPrim2D.RenderData(const Data: Pointer);
  var p: PG2Prim2D;
  var i: TG2IntS32;
begin
  p := PG2Prim2D(Data);
  if p^.Count = 0 then Exit;
  if (p^.PrimType <> _CurPrimType)
  or (p^.BlendMode <> _CurBlendMode)
  or (p^.Count + _CurPoint > _MaxPoints) then
  begin
    if _CurPoint > 0 then Flush;
    _CurPrimType := p^.PrimType;
    if (p^.BlendMode <> _CurBlendMode) then
    begin
      _CurBlendMode := p^.BlendMode;
      _Gfx.BlendMode := _CurBlendMode;
    end;
    {$if defined(G2Gfx_OGL)}
    case _CurPrimType of
      ptLines: glBegin(GL_LINES);
      ptTriangles: glBegin(GL_TRIANGLES);
    end;
    {$endif}
  end;
  {$if defined(G2Gfx_D3D9)}
  for i := 0 to p^.Count - 1 do
  begin
    _Vertices[_CurPoint].x := p^.Points[i].x;
    _Vertices[_CurPoint].y := p^.Points[i].y;
    _Vertices[_CurPoint].z := 0;
    {$if defined(G2RM_FF)}
    _Vertices[_CurPoint].rhw := 1;
    {$endif}
    _Vertices[_CurPoint].Color := p^.Points[i].Color;
    Inc(_CurPoint);
  end;
  {$elseif defined(G2Gfx_OGL)}
  for i := 0 to p^.Count - 1 do
  begin
    {$if defined(G2RM_FF)}
    glColor4f(p^.Points[i].Color.r * G2Rcp255, p^.Points[i].Color.g * G2Rcp255, p^.Points[i].Color.b * G2Rcp255, p^.Points[i].Color.a * G2Rcp255);
    glVertex3f(p^.Points[i].x, p^.Points[i].y, 0);
    {$elseif defined(G2RM_SM2)}
    glVertexAttrib4f(_AttribColor, p^.Points[i].Color.r * G2Rcp255, p^.Points[i].Color.g * G2Rcp255, p^.Points[i].Color.b * G2Rcp255, p^.Points[i].Color.a * G2Rcp255);
    glVertexAttrib3f(_AttribPosition, p^.Points[i].x, p^.Points[i].y, 0);
    {$endif}
    Inc(_CurPoint);
  end;
  {$elseif defined(G2Gfx_GLES)}
  for i := 0 to p^.Count - 1 do
  begin
    _VertPositions[_CurPoint].x := p^.Points[i].x;
    _VertPositions[_CurPoint].y := p^.Points[i].y;
    _VertPositions[_CurPoint].z := 0;
    _VertColors[_CurPoint].SetValue(
      p^.Points[i].Color.r * G2Rcp255,
      p^.Points[i].Color.g * G2Rcp255,
      p^.Points[i].Color.b * G2Rcp255,
      p^.Points[i].Color.a * G2Rcp255
    );
    Inc(_CurPoint);
  end;
  {$endif}
end;

procedure TG2RenderControlPrim2D.Reset;
begin
  _QueueCount[_FillID^] := 0;
  _CurPrim := nil;
end;

constructor TG2RenderControlPrim2D.Create;
{$if defined(G2Gfx_D3D9)}
{$if defined(G2RM_SM2)}
  var ve: array[0..2] of TD3DVertexElement9;
{$endif}
{$elseif defined(G2Gfx_GLES)}
  var i: TG2IntS32;
{$endif}
begin
  inherited Create;
  _QueueCapacity[0] := 0;
  _QueueCapacity[1] := 0;
  _QueueCount[0] := 0;
  _QueueCount[1] := 0;
  _MaxPoints := 2048;
  {$if defined(G2RM_SM2)}
  _ShaderGroup := _Gfx.RequestShader('StandardShaders');
  {$endif}
  {$if defined(G2Gfx_D3D9)}
  {$if defined(G2RM_SM2)}
  ve[0] := D3DVertexElement(0, D3DDECLTYPE_FLOAT3, D3DDECLUSAGE_POSITION);
  ve[1] := D3DVertexElement(12, D3DDECLTYPE_D3DCOLOR, D3DDECLUSAGE_COLOR);
  ve[2] := D3DDECL_END;
  _Gfx.Device.CreateVertexDeclaration(@ve, _Decl);
  {$endif}
  SetLength(_Vertices, _MaxPoints);
  {$elseif defined(G2Gfx_GLES)}
  SetLength(_VertPositions, _MaxPoints);
  SetLength(_VertColors, _MaxPoints);
  SetLength(_Indices, _MaxPoints);
  for i := 0 to _MaxPoints - 1 do
  _Indices[i] := i;
  {$endif}
end;

destructor TG2RenderControlPrim2D.Destroy;
  var n, i: TG2IntS32;
begin
  for n := 0 to 1 do
  for i := 0 to _QueueCapacity[n] - 1 do
  Dispose(_Queue[n][i]);
  {$ifdef G2Gfx_D3D9}
  _Vertices := nil;
  {$if defined(G2RM_SM2)}
  SafeRelease(_Decl);
  {$endif}
  {$endif}
  inherited Destroy;
end;
//TG2RenderControlPrim2D END

//TG2RenderControlPrim3D BEGIN
procedure TG2RenderControlPrim3D.CheckCapacity;
  var n, i: TG2IntS32;
begin
  if _QueueCount[_FillID^] >= _QueueCapacity[_FillID^] then
  begin
    n := _QueueCapacity[_FillID^];
    _QueueCapacity[_FillID^] := _QueueCapacity[_FillID^] + 128;
    SetLength(_Queue[_FillID^], _QueueCapacity[_FillID^]);
    for i := n to _QueueCapacity[_FillID^] - 1 do
    begin
      New(_Queue[_FillID^][i]);
      _Queue[_FillID^][i]^.Count := 0;
      _Queue[_FillID^][i]^.PrimType := ptNone;
      SetLength(_Queue[_FillID^][i]^.Points, 32);
    end;
  end;
end;

procedure TG2RenderControlPrim3D.Flush;
begin
  {$if defined(G2Gfx_D3D9)}
  case _CurPrimType of
    ptLines:
    begin
      if _CurPoint mod 2 = 0 then
      _Gfx.Device.DrawPrimitiveUP(D3DPT_LINELIST, _CurPoint div 2, _Vertices[0], SizeOf(TG2Prim3DVertex));
    end;
    ptTriangles:
    begin
      if _CurPoint mod 3 = 0 then
      _Gfx.Device.DrawPrimitiveUP(D3DPT_TRIANGLELIST, _CurPoint div 3, _Vertices[0], SizeOf(TG2Prim3DVertex));
    end;
  end;
  {$elseif defined(G2Gfx_OGL)}
  glEnd;
  {$elseif defined(G2Gfx_GLES)}
  glVertexPointer(3, GL_FLOAT, 0, @_VertPositions[0]);
  glColorPointer(4, GL_FLOAT, 0, @_VertColors[0]);
  case _CurPrimType of
    ptLines:
    begin
      if _CurPoint mod 2 = 0 then
      begin
        if _Gfx.BlendMode.BlendSeparate then
        begin
          _Gfx.MaskColor;
          glDrawElements(GL_LINES, _CurPoint, GL_UNSIGNED_SHORT, @_Indices[0]);
          _Gfx.MaskAlpha;
          _Gfx.SwapBlendMode;
          glDrawElements(GL_LINES, _CurPoint, GL_UNSIGNED_SHORT, @_Indices[0]);
          _Gfx.MaskAll;
          _Gfx.SwapBlendMode;
        end
        else
        glDrawElements(GL_LINES, _CurPoint, GL_UNSIGNED_SHORT, @_Indices[0]);
      end;
    end;
    ptTriangles:
    begin
      if _CurPoint mod 3 = 0 then
      glDrawElements(GL_TRIANGLES, _CurPoint, GL_UNSIGNED_SHORT, @_Indices[0]);
    end;
  end;
  {$endif}
  _CurPoint := 0;
end;

procedure TG2RenderControlPrim3D.PrimBegin(
  const PrimType: TG2PrimType;
  const BlendMode: TG2BlendMode;
  const WVP: TG2Mat
);
begin
  if _CurPrim <> nil then PrimEnd;
  CheckCapacity;
  _CurPrim := _Queue[_FillID^][_QueueCount[_FillID^]];
  _CurPrim^.Count := 0;
  _CurPrim^.PrimType := PrimType;
  _CurPrim^.BlendMode := BlendMode;
  _CurPrim^.WVP := WVP;
end;

procedure TG2RenderControlPrim3D.PrimEnd;
begin
  if _CurPrim = nil then Exit;
  _Gfx.AddRenderQueueItem(Self, _CurPrim);
  Inc(_QueueCount[_FillID^]);
  _CurPrim := nil;
end;

procedure TG2RenderControlPrim3D.PrimAdd(
  const x, y, z: TG2Float;
  const Color: TG2Color
);
begin
  if _CurPrim = nil then Exit;
  if _CurPrim^.Count + 4 > _MaxPoints then
  begin
    if ((_CurPrim^.PrimType = ptLines) and (_CurPrim^.Count mod 2 = 0))
    or ((_CurPrim^.PrimType = ptTriangles) and (_CurPrim^.Count mod 3 = 0)) then
    PrimBegin(_CurPrim^.PrimType, _CurPrim^.BlendMode, _CurPrim^.WVP);
  end;
  if _CurPrim^.Count >= Length(_CurPrim^.Points) then
  SetLength(_CurPrim^.Points, Length(_CurPrim^.Points) + 32);
  _CurPrim^.Points[_CurPrim^.Count].x := x;
  _CurPrim^.Points[_CurPrim^.Count].y := y;
  _CurPrim^.Points[_CurPrim^.Count].z := z;
  _CurPrim^.Points[_CurPrim^.Count].Color := Color;
  Inc(_CurPrim^.Count);
end;

procedure TG2RenderControlPrim3D.PrimAdd(
  const v: TG2Vec3;
  const Color: TG2Color
);
begin
  PrimAdd(v.x, v.y, v.z, Color);
end;

procedure TG2RenderControlPrim3D.RenderBegin;
{$if defined(G2Gfx_D3D9) and defined(G2RM_FF)}
  var m: TG2Mat;
{$endif}
{$if defined(G2Gfx_OGL) and defined(G2RM_SM2)}
  var WVP: TG2Mat;
{$endif}
begin
  _CurPoint := 0;
  _CurPrimType := ptNone;
  _CurBlendMode := bmInvalid;
  _CurWVP := G2MatZero;
  {$if defined(G2RM_FF)}
  {$if defined(G2Gfx_D3D9)}
  m := G2MatIdentity;
  _Gfx.Device.SetFVF(D3DFVF_XYZ or D3DFVF_DIFFUSE);
  _Gfx.Device.SetTexture(0, nil);
  _Gfx.Device.SetTransform(D3DTS_WORLD, m);
  _Gfx.Device.SetTransform(D3DTS_VIEW, m);
  {$elseif defined(G2Gfx_OGL)}
  _Gfx.SetProj2D;
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  glDisable(GL_TEXTURE_2D);
  {$elseif defined(G2Gfx_GLES)}
  _Gfx.SetProj2D;
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  glDisable(GL_TEXTURE_2D);
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_COLOR_ARRAY);
  {$endif}
  {$elseif defined(G2RM_SM2)}
  _ShaderGroup.Method := 'Prim';
  {$if defined(G2Gfx_D3D9)}
  _Gfx.Device.SetVertexDeclaration(_Decl);
  {$elseif defined(G2Gfx_OGL)}
  _AttribPosition := _ShaderGroup.Attribute('a_Position0');
  _AttribColor := _ShaderGroup.Attribute('a_Color0');
  if _Gfx.RenderTarget = nil then
  WVP := G2MatOrth2D(_Gfx.SizeRT.x, _Gfx.SizeRT.y, 0, 1)
  else
  WVP := G2MatOrth2D(_Gfx.SizeRT.x, _Gfx.SizeRT.y, 0, 1, False, False);
  glDisable(GL_TEXTURE_2D);
  {$endif}
  {$endif}
  _Gfx.BlendMode := bmNormal;
  _Gfx.CullMode := g2cm_none;
end;

procedure TG2RenderControlPrim3D.RenderEnd;
begin
  if _CurPoint > 0 then Flush;
  {$if defined(G2RM_FF)}
  {$if defined(G2Gfx_OGL)}
  glEnable(GL_TEXTURE_2D);
  {$elseif defined(G2Gfx_GLES)}
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_COLOR_ARRAY);
  glEnable(GL_TEXTURE_2D);
  {$endif}
  {$elseif defined(G2RM_SM2)}
  {$if defined(G2Gfx_OGL)}
  glEnable(GL_TEXTURE_2D);
  {$endif}
  {$endif}
end;

procedure TG2RenderControlPrim3D.RenderData(const Data: Pointer);
  var p: PG2Prim3D;
  var i: TG2IntS32;
  var tc: Boolean;
begin
  p := PG2Prim3D(Data);
  if p^.Count = 0 then Exit;
  tc := G2MatCompare(p^.WVP, _CurWVP);
  if (p^.PrimType <> _CurPrimType)
  or (p^.BlendMode <> _CurBlendMode)
  or (p^.Count + _CurPoint > _MaxPoints)
  or (not tc) then
  begin
    if _CurPoint > 0 then Flush;
    _CurPrimType := p^.PrimType;
    if (p^.BlendMode <> _CurBlendMode) then
    begin
      _CurBlendMode := p^.BlendMode;
      _Gfx.BlendMode := _CurBlendMode;
    end;
    {$if defined(G2Gfx_D3D9)}
    if not tc then
    begin
      _CurWVP := p^.WVP;
      _Gfx.Device.SetTransform(D3DTS_PROJECTION, _CurWVP);
    end;
    {$elseif defined(G2Gfx_OGL)}
    if not tc then
    begin
      _CurWVP := p^.WVP;
      glLoadMatrixf(@_CurWVP);
    end;
    case _CurPrimType of
      ptLines: glBegin(GL_LINES);
      ptTriangles: glBegin(GL_TRIANGLES);
    end;
    {$endif}
  end;
  {$if defined(G2Gfx_D3D9)}
  for i := 0 to p^.Count - 1 do
  begin
    _Vertices[_CurPoint].x := p^.Points[i].x;
    _Vertices[_CurPoint].y := p^.Points[i].y;
    _Vertices[_CurPoint].z := p^.Points[i].z;
    _Vertices[_CurPoint].Color := p^.Points[i].Color;
    Inc(_CurPoint);
  end;
  {$elseif defined(G2Gfx_OGL)}
  for i := 0 to p^.Count - 1 do
  begin
    {$if defined(G2RM_FF)}
    glColor4f(p^.Points[i].Color.r * G2Rcp255, p^.Points[i].Color.g * G2Rcp255, p^.Points[i].Color.b * G2Rcp255, p^.Points[i].Color.a * G2Rcp255);
    glVertex3f(p^.Points[i].x, p^.Points[i].y, p^.Points[i].z);
    {$elseif defined(G2RM_SM2)}
    glVertexAttrib4f(_AttribColor, p^.Points[i].Color.r * G2Rcp255, p^.Points[i].Color.g * G2Rcp255, p^.Points[i].Color.b * G2Rcp255, p^.Points[i].Color.a * G2Rcp255);
    glVertexAttrib3f(_AttribPosition, p^.Points[i].x, p^.Points[i].y, p^.Points[i].z);
    {$endif}
    Inc(_CurPoint);
  end;
  {$elseif defined(G2Gfx_GLES)}
  for i := 0 to p^.Count - 1 do
  begin
    _VertPositions[_CurPoint].x := p^.Points[i].x;
    _VertPositions[_CurPoint].y := p^.Points[i].y;
    _VertPositions[_CurPoint].z := 0;
    _VertColors[_CurPoint].SetValue(
      p^.Points[i].Color.r * G2Rcp255,
      p^.Points[i].Color.g * G2Rcp255,
      p^.Points[i].Color.b * G2Rcp255,
      p^.Points[i].Color.a * G2Rcp255
    );
    Inc(_CurPoint);
  end;
  {$endif}
end;

procedure TG2RenderControlPrim3D.Reset;
begin
  _QueueCount[_FillID^] := 0;
  _CurPrim := nil;
end;

constructor TG2RenderControlPrim3D.Create;
{$if defined(G2Gfx_D3D9)}
{$if defined(G2RM_SM2)}
  var ve: array[0..2] of TD3DVertexElement9;
{$endif}
{$elseif defined(G2Gfx_GLES)}
  var i: TG2IntS32;
{$endif}
begin
  inherited Create;
  _QueueCapacity[0] := 0;
  _QueueCapacity[1] := 0;
  _QueueCount[0] := 0;
  _QueueCount[1] := 0;
  _MaxPoints := 2048;
  {$if defined(G2RM_SM2)}
  _ShaderGroup := _Gfx.RequestShader('StandardShaders');
  {$endif}
  {$if defined(G2Gfx_D3D9)}
  {$if defined(G2RM_SM2)}
  ve[0] := D3DVertexElement(0, D3DDECLTYPE_FLOAT3, D3DDECLUSAGE_POSITION);
  ve[1] := D3DVertexElement(12, D3DDECLTYPE_D3DCOLOR, D3DDECLUSAGE_COLOR);
  ve[2] := D3DDECL_END;
  _Gfx.Device.CreateVertexDeclaration(@ve, _Decl);
  {$endif}
  SetLength(_Vertices, _MaxPoints);
  {$elseif defined(G2Gfx_GLES)}
  SetLength(_VertPositions, _MaxPoints);
  SetLength(_VertColors, _MaxPoints);
  SetLength(_Indices, _MaxPoints);
  for i := 0 to _MaxPoints - 1 do
  _Indices[i] := i;
  {$endif}
end;

destructor TG2RenderControlPrim3D.Destroy;
  var n, i: TG2IntS32;
begin
  for n := 0 to 1 do
  for i := 0 to _QueueCapacity[n] - 1 do
  Dispose(_Queue[n][i]);
  {$ifdef G2Gfx_D3D9}
  _Vertices := nil;
  {$if defined(G2RM_SM2)}
  SafeRelease(_Decl);
  {$endif}
  {$endif}
  inherited Destroy;
end;
//TG2RenderControlPrim3D END

//TG2RenderControlPoly2D BEGIN
procedure TG2RenderControlPoly2D.CheckCapacity;
  var n, i: TG2IntS32;
begin
  if _QueueCount[_FillID^] >= _QueueCapacity[_FillID^] then
  begin
    n := _QueueCapacity[_FillID^];
    _QueueCapacity[_FillID^] := _QueueCapacity[_FillID^] + 128;
    SetLength(_Queue[_FillID^], _QueueCapacity[_FillID^]);
    for i := n to _QueueCapacity[_FillID^] - 1 do
    begin
      New(_Queue[_FillID^][i]);
      _Queue[_FillID^][i]^.Count := 0;
      SetLength(_Queue[_FillID^][i]^.Points, 32);
    end;
  end;
end;

procedure TG2RenderControlPoly2D.Flush;
begin
  {$if defined(G2Gfx_D3D9)}
  case _CurPolyType of
    ptLines: _Gfx.Device.DrawPrimitiveUP(D3DPT_LINELIST, _CurPoint div 2, _Vertices[0], SizeOf(TG2Poly2DVertex));
    ptTriangles: _Gfx.Device.DrawPrimitiveUP(D3DPT_TRIANGLELIST, _CurPoint div 3, _Vertices[0], SizeOf(TG2Poly2DVertex));
  end;
  {$elseif defined(G2Gfx_OGL)}
  glEnd;
  {$elseif defined(G2Gfx_GLES)}
  glVertexPointer(3, GL_FLOAT, 0, @_VertPositions[0]);
  glColorPointer(4, GL_FLOAT, 0, @_VertColors[0]);
  glTexCoordPointer(2, GL_FLOAT, 0, @_VertTexCoords[0]);
  if _Gfx.BlendMode.BlendSeparate then
  begin
    _Gfx.MaskColor;
    case _CurPolyType of
      ptLines: glDrawElements(GL_LINES, _CurIndex, GL_UNSIGNED_SHORT, @_Indices[0]);
      ptTriangles: glDrawElements(GL_TRIANGLES, _CurIndex, GL_UNSIGNED_SHORT, @_Indices[0]);
    end;
    _Gfx.MaskAlpha;
    _Gfx.SwapBlendMode;
    case _CurPolyType of
      ptLines: glDrawElements(GL_LINES, _CurIndex, GL_UNSIGNED_SHORT, @_Indices[0]);
      ptTriangles: glDrawElements(GL_TRIANGLES, _CurIndex, GL_UNSIGNED_SHORT, @_Indices[0]);
    end;
    _Gfx.MaskAll;
    _Gfx.SwapBlendMode;
  end
  else
  case _CurPolyType of
    ptLines: glDrawElements(GL_LINES, _CurIndex, GL_UNSIGNED_SHORT, @_Indices[0]);
    ptTriangles: glDrawElements(GL_TRIANGLES, _CurIndex, GL_UNSIGNED_SHORT, @_Indices[0]);
  end;
  {$endif}
  _CurPoint := 0;
  _CurIndex := 0;
end;

procedure TG2RenderControlPoly2D.PolyBegin(const PolyType: TG2PrimType; const Texture: TG2Texture2DBase; const BlendMode: TG2BlendModeRef = bmNormal; const Filter: TG2Filter = tfPoint);
begin
  if _CurPoly <> nil then PolyEnd;
  CheckCapacity;
  _CurPoly := _Queue[_FillID^][_QueueCount[_FillID^]];
  _CurPoly^.PolyType := PolyType;
  _CurPoly^.Texture := Texture;
  _CurPoly^.BlendMode := BlendMode;
  _CurPoly^.Filter := Filter;
  _CurPoly^.Count := 0;
  Texture.LockAsset(_FillID^);
end;

procedure TG2RenderControlPoly2D.PolyEnd;
begin
  if _CurPoly = nil then Exit;
  _Gfx.AddRenderQueueItem(Self, _CurPoly);
  Inc(_QueueCount[_FillID^]);
  _CurPoly := nil;
end;

procedure TG2RenderControlPoly2D.PolyAdd(const x, y, u, v: TG2Float; const Color: TG2Color);
begin
  if _CurPoly = nil then Exit;
  if _CurPoly^.Count + 4 > _MaxPoints then
  begin
    if ((_CurPoly^.PolyType = ptLines) and (_CurPoly^.Count mod 2 = 0))
    or ((_CurPoly^.PolyType = ptTriangles) and (_CurPoly^.Count mod 3 = 0)) then
    PolyBegin(_CurPoly^.PolyType, _CurPoly^.Texture, _CurPoly^.BlendMode, _CurPoly^.Filter);
  end;
  if _CurPoly^.Count >= Length(_CurPoly^.Points) then
  SetLength(_CurPoly^.Points, Length(_CurPoly^.Points) + 32);
  _CurPoly^.Points[_CurPoly^.Count].x := x;
  _CurPoly^.Points[_CurPoly^.Count].y := y;
  _CurPoly^.Points[_CurPoly^.Count].Color := Color;
  _CurPoly^.Points[_CurPoly^.Count].u := u;
  _CurPoly^.Points[_CurPoly^.Count].v := v;
  Inc(_CurPoly^.Count);
end;

procedure TG2RenderControlPoly2D.PolyAdd(const Pos, TexCoord: TG2Vec2; const Color: TG2Color);
begin
  PolyAdd(Pos.x, Pos.y, TexCoord.x, TexCoord.y, Color);
end;

procedure TG2RenderControlPoly2D.RenderBegin;
{$if defined(G2RM_SM2)}
  var WVP: TG2Mat;
{$endif}
begin
  _PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := False;
  _Gfx.CullMode := g2cm_none;
  _CurPoint := 0;
  _CurIndex := 0;
  _CurPolyType := ptNone;
  _CurTexture := nil;
  _CurBlendMode := bmInvalid;
  _CurFilter := tfNone;
  {$if defined(G2RM_FF)}
  {$if defined(G2Gfx_D3D9)}
  _Gfx.Device.SetFVF(D3DFVF_XYZRHW or D3DFVF_DIFFUSE or D3DFVF_TEX1);
  {$elseif defined(G2Gfx_OGL)}
  _Gfx.SetProj2D;
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  glEnable(GL_TEXTURE_2D);
  {$elseif defined(G2Gfx_GLES)}
  _Gfx.SetProj2D;
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_COLOR_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  {$endif}
  {$elseif defined(G2RM_SM2)}
  _ShaderGroup.Method := 'Pic';
  {$if defined(G2Gfx_D3D9)}
  _Gfx.Device.SetVertexDeclaration(_Decl);
  WVP := G2MatOrth2D(_Gfx.SizeRT.x, _Gfx.SizeRT.y, 0, 1);
  {$elseif defined(G2Gfx_OGL)}
  _AttribPosition := _ShaderGroup.Attribute('a_Position0');
  _AttribColor := _ShaderGroup.Attribute('a_Color0');
  _AttribTexCoord := _ShaderGroup.Attribute('a_TexCoord0');
  if _Gfx.RenderTarget = nil then
  WVP := G2MatOrth2D(_Gfx.SizeRT.x, _Gfx.SizeRT.y, 0, 1)
  else
  WVP := G2MatOrth2D(_Gfx.SizeRT.x, _Gfx.SizeRT.y, 0, 1, False, False);
  {$endif}
  _ShaderGroup.UniformMatrix4x4('WVP', WVP);
  {$endif}
end;

procedure TG2RenderControlPoly2D.RenderEnd;
begin
  if _CurPoint > 0 then Flush;
  {$if defined(G2RM_FF)}
  {$if defined(G2Gfx_GLES)}
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_COLOR_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  {$endif}
  {$elseif defined(G2RM_SM2)}

  {$endif}
  _Gfx.DepthEnable := _PrevDepthEnable;
end;

procedure TG2RenderControlPoly2D.RenderData(const Data: Pointer);
  var p: PG2Poly2D;
  var i: TG2IntS32;
begin
  p := PG2Poly2D(Data);
  if p^.Count = 0 then Exit;
  if (p^.Count + _CurPoint >= _MaxPoints)
  or (p^.PolyType <> _CurPolyType)
  or (p^.Texture <> _CurTexture)
  or (p^.BlendMode <> _CurBlendMode)
  or (p^.Filter <> _CurFilter) then
  begin
    if _CurPoint > 0 then Flush;
    _CurPolyType := p^.PolyType;
    if (p^.Texture <> _CurTexture) then
    begin
      _CurTexture := p^.Texture;
      {$if defined(G2Gfx_D3D9)}
      {$if defined(G2RM_FF)}
      _Gfx.Device.SetTexture(0, _CurTexture.GetTexture);
      {$elseif defined(G2RM_SM2)}
      _ShaderGroup.Sampler('Tex0', _CurTexture);
      {$endif}
      {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
      {$if defined(G2RM_FF)}
      glBindTexture(GL_TEXTURE_2D, _CurTexture.GetTexture);
      {$elseif defined(G2RM_SM2)}
      _ShaderGroup.Sampler('Tex0', _CurTexture, 0);
      {$endif}
      {$if not defined(G2Gfx_GLES)}
      _Gfx.EnableMipMaps(_CurTexture.Usage = tu3D);
      {$endif}
      _CurFilter := p^.Filter;
      _Gfx.Filter := _CurFilter;
      {$endif}
    end;
    if (p^.BlendMode <> _CurBlendMode) then
    begin
      _CurBlendMode := p^.BlendMode;
      _Gfx.BlendMode := _CurBlendMode;
    end;
    if (p^.Filter <> _CurFilter) then
    begin
      _CurFilter := p^.Filter;
      _Gfx.Filter := _CurFilter;
    end;
    {$if defined(G2Gfx_OGL)}
    case _CurPolyType of
      ptLines: glBegin(GL_LINES);
      ptTriangles: glBegin(GL_TRIANGLES);
    end;
    {$endif}
  end;
  {$if defined(G2Gfx_D3D9)}
  for i := 0 to p^.Count - 1 do
  begin
    _Vertices[_CurPoint].x := p^.Points[i].x;
    _Vertices[_CurPoint].y := p^.Points[i].y;
    _Vertices[_CurPoint].z := 0;
    {$if defined(G2RM_FF)}
    _Vertices[_CurPoint].rhw := 1;
    {$endif}
    _Vertices[_CurPoint].Color := p^.Points[i].Color;
    _Vertices[_CurPoint].tu := p^.Points[i].u;
    _Vertices[_CurPoint].tv := p^.Points[i].v;
    Inc(_CurPoint);
  end;
  {$elseif defined(G2Gfx_OGL)}
  for i := 0 to p^.Count - 1 do
  begin
    {$if defined(G2RM_FF)}
    glColor4f(p^.Points[i].Color.r * G2Rcp255, p^.Points[i].Color.g * G2Rcp255, p^.Points[i].Color.b * G2Rcp255, p^.Points[i].Color.a * G2Rcp255);
    glTexCoord2f(p^.Points[i].u, p^.Points[i].v); glVertex3f(p^.Points[i].x, p^.Points[i].y, 0);
    {$elseif defined(G2RM_SM2)}
    glVertexAttrib4f(_AttribColor, p^.Points[i].Color.r * G2Rcp255, p^.Points[i].Color.g * G2Rcp255, p^.Points[i].Color.b * G2Rcp255, p^.Points[i].Color.a * G2Rcp255);
    glVertexAttrib2f(_AttribTexCoord, p^.Points[i].u, p^.Points[i].v); glVertexAttrib3f(_AttribPosition, p^.Points[i].x, p^.Points[i].y, 0);
    {$endif}
  end;
  Inc(_CurPoint, p^.Count);
  {$elseif defined(G2Gfx_GLES)}
  for i := 0 to p^.Count - 1 do
  _Indices[_CurIndex + i] := _CurPoint + i;
  Inc(_CurIndex, p^.Count);
  for i := 0 to p^.Count - 1 do
  begin
    _VertPositions[_CurPoint].x := p^.Points[i].x;
    _VertPositions[_CurPoint].y := p^.Points[i].y;
    _VertPositions[_CurPoint].z := 0;
    _VertColors[_CurPoint].SetValue(p^.Points[i].Color.r * G2Rcp255, p^.Points[i].Color.g * G2Rcp255, p^.Points[i].Color.b * G2Rcp255, p^.Points[i].Color.a * G2Rcp255);
    _VertTexCoords[_CurPoint].x := p^.Points[i].u;
    _VertTexCoords[_CurPoint].y := p^.Points[i].v;
    Inc(_CurPoint);
  end;
  {$endif}
end;

procedure TG2RenderControlPoly2D.Reset;
begin
  _QueueCount[_FillID^] := 0;
  _CurPoly := nil;
end;

constructor TG2RenderControlPoly2D.Create;
{$if defined(G2Gfx_D3D9)}
{$if defined(G2RM_SM2)}
  var ve: array[0..3] of TD3DVertexElement9;
{$endif}
{$endif}
begin
  inherited Create;
  _QueueCapacity[0] := 0;
  _QueueCapacity[1] := 0;
  _QueueCount[0] := 0;
  _QueueCount[1] := 0;
  _MaxPoints := 2048;
  {$if defined(G2RM_SM2)}
  _ShaderGroup := _Gfx.RequestShader('StandardShaders');
  {$endif}
  {$if defined(G2Gfx_D3D9)}
  {$if defined(G2RM_SM2)}
  ve[0] := D3DVertexElement(0, D3DDECLTYPE_FLOAT3, D3DDECLUSAGE_POSITION);
  ve[1] := D3DVertexElement(12, D3DDECLTYPE_D3DCOLOR, D3DDECLUSAGE_COLOR);
  ve[2] := D3DVertexElement(16, D3DDECLTYPE_FLOAT2, D3DDECLUSAGE_TEXCOORD);
  ve[3] := D3DDECL_END;
  _Gfx.Device.CreateVertexDeclaration(@ve, _Decl);
  {$endif}
  SetLength(_Vertices, _MaxPoints);
  {$elseif defined(G2Gfx_GLES)}
  SetLength(_VertPositions, _MaxPoints);
  SetLength(_VertColors, _MaxPoints);
  SetLength(_VertTexCoords, _MaxPoints);
  SetLength(_Indices, _MaxPoints);
  {$endif}
end;

destructor TG2RenderControlPoly2D.Destroy;
  var n, i: TG2IntS32;
begin
  for n := 0 to 1 do
  for i := 0 to _QueueCapacity[n] - 1 do
  Dispose(_Queue[n][i]);
  {$ifdef G2Gfx_D3D9}
  {$if defined(G2RM_SM2)}
  _Decl := nil;
  {$endif}
  _Vertices := nil;
  {$endif}
  inherited Destroy;
end;
//TG2RenderControlPoly2D END

//TG2RenderControlPoly3D BEGIN
procedure TG2RenderControlPoly3D.CheckCapacity;
  var n, i: TG2IntS32;
begin
  if _QueueCount[_FillID^] >= _QueueCapacity[_FillID^] then
  begin
    n := _QueueCapacity[_FillID^];
    _QueueCapacity[_FillID^] := _QueueCapacity[_FillID^] + 128;
    SetLength(_Queue[_FillID^], _QueueCapacity[_FillID^]);
    for i := n to _QueueCapacity[_FillID^] - 1 do
    begin
      New(_Queue[_FillID^][i]);
      _Queue[_FillID^][i]^.Count := 0;
      SetLength(_Queue[_FillID^][i]^.Points, 32);
    end;
  end;
end;

procedure TG2RenderControlPoly3D.Flush;
begin
  {$if defined(G2Gfx_D3D9)}
  case _CurPrimType of
    ptLines:
    begin
      if _CurPoint mod 2 = 0 then
      _Gfx.Device.DrawPrimitiveUP(D3DPT_LINELIST, _CurPoint div 2, _Vertices[0], SizeOf(TG2Poly3DVertex));
    end;
    ptTriangles:
    begin
      if _CurPoint mod 3 = 0 then
      _Gfx.Device.DrawPrimitiveUP(D3DPT_TRIANGLELIST, _CurPoint div 3, _Vertices[0], SizeOf(TG2Poly3DVertex));
    end;
  end;
  {$elseif defined(G2Gfx_OGL)}
  glEnd;
  {$elseif defined(G2Gfx_GLES)}
  glVertexPointer(3, GL_FLOAT, 0, @_VertPositions[0]);
  glColorPointer(4, GL_FLOAT, 0, @_VertColors[0]);
  case _CurPrimType of
    ptLines:
    begin
      if _CurPoint mod 2 = 0 then
      begin
        if _Gfx.BlendMode.BlendSeparate then
        begin
          _Gfx.MaskColor;
          glDrawElements(GL_LINES, _CurPoint, GL_UNSIGNED_SHORT, @_Indices[0]);
          _Gfx.MaskAlpha;
          _Gfx.SwapBlendMode;
          glDrawElements(GL_LINES, _CurPoint, GL_UNSIGNED_SHORT, @_Indices[0]);
          _Gfx.MaskAll;
          _Gfx.SwapBlendMode;
        end
        else
        glDrawElements(GL_LINES, _CurPoint, GL_UNSIGNED_SHORT, @_Indices[0]);
      end;
    end;
    ptTriangles:
    begin
      if _CurPoint mod 3 = 0 then
      glDrawElements(GL_TRIANGLES, _CurPoint, GL_UNSIGNED_SHORT, @_Indices[0]);
    end;
  end;
  {$endif}
  _CurPoint := 0;
end;

procedure TG2RenderControlPoly3D.PolyBegin(
  const PrimType: TG2PrimType;
  const Texture: TG2Texture2DBase;
  const WVP: TG2Mat;
  const BlendMode: TG2BlendModeRef;
  const Filter: TG2Filter
);
begin
  if _CurPoly <> nil then PolyEnd;
  CheckCapacity;
  _CurPoly := _Queue[_FillID^][_QueueCount[_FillID^]];
  _CurPoly^.Count := 0;
  _CurPoly^.PrimType := PrimType;
  _CurPoly^.BlendMode := BlendMode;
  _CurPoly^.Texture := Texture;
  _CurPoly^.Filter := Filter;
  _CurPoly^.WVP := WVP;
  Texture.LockAsset(_FillID^);
end;

procedure TG2RenderControlPoly3D.PolyEnd;
begin
  if _CurPoly = nil then Exit;
  _Gfx.AddRenderQueueItem(Self, _CurPoly);
  Inc(_QueueCount[_FillID^]);
  _CurPoly := nil;
end;

procedure TG2RenderControlPoly3D.PolyAdd(
  const x, y, z, u, v: TG2Float;
  const Color: TG2Color
);
begin
  if _CurPoly = nil then Exit;
  if _CurPoly^.Count + 4 > _MaxPoints then
  begin
    if ((_CurPoly^.PrimType = ptLines) and (_CurPoly^.Count mod 2 = 0))
    or ((_CurPoly^.PrimType = ptTriangles) and (_CurPoly^.Count mod 3 = 0)) then
    PolyBegin(_CurPoly^.PrimType, _CurPoly^.Texture, _CurPoly^.WVP, _CurPoly^.BlendMode, _CurPoly^.Filter);
  end;
  if _CurPoly^.Count >= Length(_CurPoly^.Points) then
  SetLength(_CurPoly^.Points, Length(_CurPoly^.Points) + 32);
  _CurPoly^.Points[_CurPoly^.Count].x := x;
  _CurPoly^.Points[_CurPoly^.Count].y := y;
  _CurPoly^.Points[_CurPoly^.Count].z := z;
  _CurPoly^.Points[_CurPoly^.Count].Color := Color;
  _CurPoly^.Points[_CurPoly^.Count].u := u;
  _CurPoly^.Points[_CurPoly^.Count].v := v;
  Inc(_CurPoly^.Count);
end;

procedure TG2RenderControlPoly3D.PolyAdd(
  const v: TG2Vec3;
  const t: TG2Vec2;
  const Color: TG2Color
);
begin
  PolyAdd(v.x, v.y, v.z, t.x, t.y, Color);
end;

procedure TG2RenderControlPoly3D.RenderBegin;
{$if defined(G2Gfx_D3D9) and defined(G2RM_FF)}
  var m: TG2Mat;
{$endif}
begin
  _CurPoint := 0;
  _CurPrimType := ptNone;
  _CurBlendMode := bmInvalid;
  _CurTexture := nil;
  _CurFilter := tfNone;
  _CurWVP := G2MatZero;
  {$if defined(G2RM_FF)}
  {$if defined(G2Gfx_D3D9)}
  m := G2MatIdentity;
  _Gfx.Device.SetFVF(D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1);
  _Gfx.Device.SetTexture(0, nil);
  _Gfx.Device.SetTransform(D3DTS_WORLD, m);
  _Gfx.Device.SetTransform(D3DTS_VIEW, m);
  {$elseif defined(G2Gfx_OGL)}
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  {$elseif defined(G2Gfx_GLES)}
  _Gfx.SetProj2D;
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  glDisable(GL_TEXTURE_2D);
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_COLOR_ARRAY);
  {$endif}
  {$elseif defined(G2RM_SM2)}
  _ShaderGroup.Method := 'Pic';
  {$if defined(G2Gfx_D3D9)}
  _Gfx.Device.SetVertexDeclaration(_Decl);
  {$elseif defined(G2Gfx_OGL)}
  _AttribPosition := _ShaderGroup.Attribute('a_Position0');
  _AttribColor := _ShaderGroup.Attribute('a_Color0');
  _AttribTexCoord := _ShaderGroup.Attribute('a_TexCoord0');
  {$endif}
  {$endif}
  _Gfx.CullMode := g2cm_none;
  _Gfx.BlendMode := bmNormal;
end;

procedure TG2RenderControlPoly3D.RenderEnd;
begin
  if _CurPoint > 0 then Flush;
  {$if defined(G2RM_FF)}
  {$if defined(G2Gfx_OGL)}
  {$elseif defined(G2Gfx_GLES)}
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_COLOR_ARRAY);
  {$endif}
  {$elseif defined(G2RM_SM2)}
  {$if defined(G2Gfx_OGL)}
  {$endif}
  {$endif}
end;

procedure TG2RenderControlPoly3D.RenderData(const Data: Pointer);
  var p: PG2Poly3D;
  var i: TG2IntS32;
  var tc: Boolean;
begin
  p := PG2Poly3D(Data);
  if p^.Count = 0 then Exit;
  tc := G2MatCompare(p^.WVP, _CurWVP);
  if (p^.PrimType <> _CurPrimType)
  or (p^.BlendMode <> _CurBlendMode)
  or (p^.Texture <> _CurTexture)
  or (p^.Filter <> _CurFilter)
  or (p^.Count + _CurPoint > _MaxPoints)
  or (not tc) then
  begin
    if _CurPoint > 0 then Flush;
    _CurPrimType := p^.PrimType;
    if (p^.Texture <> _CurTexture) then
    begin
      _CurPrimType := p^.PrimType;
      _CurTexture := p^.Texture;
      {$if defined(G2Gfx_D3D9)}
      {$if defined(G2RM_FF)}
      _Gfx.Device.SetTexture(0, _CurTexture.GetTexture);
      {$elseif defined(G2RM_SM2)}
      _ShaderGroup.Sampler('Tex0', _CurTexture);
      {$endif}
      {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
      {$if defined(G2RM_FF)}
      glBindTexture(GL_TEXTURE_2D, _CurTexture.GetTexture);
      {$elseif defined(G2RM_SM2)}
      _ShaderGroup.Sampler('Tex0', _CurTexture, 0);
      {$endif}
      {$if not defined(G2Gfx_GLES)}
      _Gfx.EnableMipMaps(_CurTexture.Usage = tu3D);
      {$endif}
      _CurFilter := p^.Filter;
      _Gfx.Filter := _CurFilter;
      {$endif}
    end;
    if (p^.BlendMode <> _CurBlendMode) then
    begin
      _CurBlendMode := p^.BlendMode;
      _Gfx.BlendMode := _CurBlendMode;
    end;
    if (p^.Filter <> _CurFilter) then
    begin
      _CurFilter := p^.Filter;
      _Gfx.Filter := _CurFilter;
    end;
    {$if defined(G2Gfx_D3D9)}
    if not tc then
    begin
      _CurWVP := p^.WVP;
      _Gfx.Device.SetTransform(D3DTS_PROJECTION, _CurWVP);
    end;
    {$elseif defined(G2Gfx_OGL)}
    if not tc then
    begin
      _CurWVP := p^.WVP;
      glLoadMatrixf(@_CurWVP);
    end;
    case _CurPrimType of
      ptLines: glBegin(GL_LINES);
      ptTriangles: glBegin(GL_TRIANGLES);
    end;
    {$endif}
  end;
  {$if defined(G2Gfx_D3D9)}
  for i := 0 to p^.Count - 1 do
  begin
    _Vertices[_CurPoint].x := p^.Points[i].x;
    _Vertices[_CurPoint].y := p^.Points[i].y;
    _Vertices[_CurPoint].z := p^.Points[i].z;
    _Vertices[_CurPoint].Color := p^.Points[i].Color;
    _Vertices[_CurPoint].u := p^.Points[i].u;
    _Vertices[_CurPoint].v := p^.Points[i].v;
    Inc(_CurPoint);
  end;
  {$elseif defined(G2Gfx_OGL)}
  for i := 0 to p^.Count - 1 do
  begin
    {$if defined(G2RM_FF)}
    glColor4f(p^.Points[i].Color.r * G2Rcp255, p^.Points[i].Color.g * G2Rcp255, p^.Points[i].Color.b * G2Rcp255, p^.Points[i].Color.a * G2Rcp255);
    glTexCoord2f(p^.Points[i].u, p^.Points[i].v);
    glVertex3f(p^.Points[i].x, p^.Points[i].y, p^.Points[i].z);
    {$elseif defined(G2RM_SM2)}
    glVertexAttrib4f(_AttribColor, p^.Points[i].Color.r * G2Rcp255, p^.Points[i].Color.g * G2Rcp255, p^.Points[i].Color.b * G2Rcp255, p^.Points[i].Color.a * G2Rcp255);
    glVertexAttrib3f(_AttribPosition, p^.Points[i].x, p^.Points[i].y, p^.Points[i].z);
    glVertexAttrib2f(_AttribTexCoord, p^.Points[i].u, p^.Points[i].v);
    {$endif}
    Inc(_CurPoint);
  end;
  {$elseif defined(G2Gfx_GLES)}
  for i := 0 to p^.Count - 1 do
  begin
    _VertPositions[_CurPoint].x := p^.Points[i].x;
    _VertPositions[_CurPoint].y := p^.Points[i].y;
    _VertPositions[_CurPoint].z := p^.Points[i].z;
    _VertColors[_CurPoint].SetValue(
      p^.Points[i].Color.r * G2Rcp255,
      p^.Points[i].Color.g * G2Rcp255,
      p^.Points[i].Color.b * G2Rcp255,
      p^.Points[i].Color.a * G2Rcp255
    );
    Inc(_CurPoint);
  end;
  {$endif}
end;

procedure TG2RenderControlPoly3D.Reset;
begin
  _QueueCount[_FillID^] := 0;
  _CurPoly := nil;
end;

constructor TG2RenderControlPoly3D.Create;
{$if defined(G2Gfx_D3D9)}
{$if defined(G2RM_SM2)}
  var ve: array[0..3] of TD3DVertexElement9;
{$endif}
{$elseif defined(G2Gfx_GLES)}
  var i: TG2IntS32;
{$endif}
begin
  inherited Create;
  _QueueCapacity[0] := 0;
  _QueueCapacity[1] := 0;
  _QueueCount[0] := 0;
  _QueueCount[1] := 0;
  _MaxPoints := 2048;
  {$if defined(G2RM_SM2)}
  _ShaderGroup := _Gfx.RequestShader('StandardShaders');
  {$endif}
  {$if defined(G2Gfx_D3D9)}
  {$if defined(G2RM_SM2)}
  ve[0] := D3DVertexElement(0, D3DDECLTYPE_FLOAT3, D3DDECLUSAGE_POSITION);
  ve[1] := D3DVertexElement(12, D3DDECLTYPE_D3DCOLOR, D3DDECLUSAGE_COLOR);
  ve[2] := D3DVertexElement(16, D3DDECLTYPE_FLOAT2, D3DDECLUSAGE_TEXCOORD);
  ve[3] := D3DDECL_END;
  _Gfx.Device.CreateVertexDeclaration(@ve, _Decl);
  {$endif}
  SetLength(_Vertices, _MaxPoints);
  {$elseif defined(G2Gfx_GLES)}
  SetLength(_VertPositions, _MaxPoints);
  SetLength(_VertColors, _MaxPoints);
  SetLength(_Indices, _MaxPoints);
  for i := 0 to _MaxPoints - 1 do
  _Indices[i] := i;
  {$endif}
end;

destructor TG2RenderControlPoly3D.Destroy;
  var n, i: TG2IntS32;
begin
  for n := 0 to 1 do
  for i := 0 to _QueueCapacity[n] - 1 do
  Dispose(_Queue[n][i]);
  {$ifdef G2Gfx_D3D9}
  _Vertices := nil;
  {$if defined(G2RM_SM2)}
  SafeRelease(_Decl);
  {$endif}
  {$endif}
  inherited Destroy;
end;
//TG2RenderControlPoly3D END

//TG2Display2D BEGIN
procedure TG2Display2D.SetMode(const Value: TG2Display2DMode);
begin
  if _Mode = Value then Exit;
  _Mode := Value;
  UpdateMode;
end;

procedure TG2Display2D.SetWidth(const Value: TG2IntS32);
begin
  if _Width = Value then Exit;
  _Width := Value;
  UpdateMode;
end;

procedure TG2Display2D.SetHeight(const Value: TG2IntS32);
begin
  if _Height = Value then Exit;
  _Height := Value;
  UpdateMode;
end;

procedure TG2Display2D.SetZoom(const Value: TG2Float);
begin
  _Zoom := Value;
  UpdateMode;
end;

procedure TG2Display2D.SetRotation(const Value: TG2Float);
begin
  _Rotation := Value;
  G2SinCos(-_Rotation, _rs, _rc);
end;

procedure TG2Display2D.SetViewPort(const Value: TRect);
begin
  _ViewPort := Value;
  UpdateMode;
end;

procedure TG2Display2D.UpdateMode;
  var w, h: TG2IntS32;
begin
  w := (_ViewPort.Right - _ViewPort.Left);
  h := (_ViewPort.Bottom - _ViewPort.Top);
  case _Mode of
    d2dStretch:
    begin
      _ConvertCoord.z := w / _Width * _Zoom;
      _ConvertCoord.w := h / _Height * _Zoom;
      _ConvertCoord.x := w * 0.5;
      _ConvertCoord.y := h * 0.5;
    end;
    d2dFit:
    begin
      _ConvertCoord.z := w / _Width * _Zoom;
      _ConvertCoord.w := h / _Height * _Zoom;
      if _ConvertCoord.z < _ConvertCoord.w then
      _ConvertCoord.w := _ConvertCoord.z
      else
      _ConvertCoord.z := _ConvertCoord.w;
      _ConvertCoord.x := w * 0.5;
      _ConvertCoord.y := h * 0.5;
    end;
    d2dOversize:
    begin
      _ConvertCoord.z := w / _Width * _Zoom;
      _ConvertCoord.w := h / _Height * _Zoom;
      if _ConvertCoord.z > _ConvertCoord.w then
      _ConvertCoord.w := _ConvertCoord.z
      else
      _ConvertCoord.z := _ConvertCoord.w;
      _ConvertCoord.x := w * 0.5;
      _ConvertCoord.y := h * 0.5;
    end;
    d2dCenter:
    begin
      _ConvertCoord.z := _Zoom;
      _ConvertCoord.w := _Zoom;
      _ConvertCoord.x := w * 0.5;
      _ConvertCoord.y := h * 0.5;
    end;
  end;
  _ConvertCoord.x += _ViewPort.Left;
  _ConvertCoord.y += _ViewPort.Top;
  if _ConvertCoord.z > 0 then
  _WidthScr := Round(w / _ConvertCoord.z)
  else
  _WidthScr := 0;
  if _ConvertCoord.w > 0 then
  _HeightScr := Round(h / _ConvertCoord.w)
  else
  _HeightScr := 0;
  if w > 0 then
  _ScreenScaleX := _WidthScr / w
  else
  _ScreenScaleX := 0;
  if h > 0 then
  _ScreenScaleY := _HeightScr / h
  else
  _ScreenScaleY := 0;
  if _ScreenScaleX < _ScreenScaleY then
  begin
    _ScreenScaleMin := _ScreenScaleX;
    _ScreenScaleMax := _ScreenScaleY;
  end
  else
  begin
    _ScreenScaleMin := _ScreenScaleY;
    _ScreenScaleMax := _ScreenScaleX;
  end;
end;

function TG2Display2D.GetRotationVector: TG2Vec2;
begin
{$Warnings off}
  Result.SetValue(_rc, _rs);
{$Warnings on}
end;

procedure TG2Display2D.OnResize(const OldWidth, OldHeight, NewWidth, NewHeight: TG2IntS32);
  var ScaleX, ScaleY: TG2Float;
begin
  ScaleX := NewWidth / OldWidth;
  ScaleY := NewHeight / OldHeight;
  ViewPort := Rect(
    Round(Viewport.Left * ScaleX), Round(Viewport.Top * ScaleY),
    Round(Viewport.Right * ScaleX), Round(Viewport.Bottom * ScaleY)
  );
end;

procedure TG2Display2D.SetAutoResizeViewport(const Value: Boolean);
begin
  if _AutoResizeViewport = Value then Exit;
  _AutoResizeViewport := Value;
  if _AutoResizeViewport then
  begin
    g2.CallbackResizeAdd(@OnResize);
  end
  else
  begin
    g2.CallbackResizeRemove(@OnResize);
  end;
end;

constructor TG2Display2D.Create;
begin
  inherited Create;
  _ViewPort := Rect(0, 0, g2.Params.Width, g2.Params.Height);
  _Width := 800;
  _Height := 600;
  _Mode := d2dFit;
  _Zoom := 1;
  _Rotation := 0;
  _rs := 0; _rc := 1;
  _AutoResizeViewport := False;
  AutoResizeViewport := True;
  UpdateMode;
  _Pos := G2Vec2(_Width * 0.5, _Height * 0.5);
end;

destructor TG2Display2D.Destroy;
begin
  AutoResizeViewport := False;
  inherited Destroy;
end;

function TG2Display2D.CoordToScreen(const Coord: TG2Vec2): TG2Vec2;
  var v: TG2Vec2;
begin
  v.SetValue(Coord.x - _Pos.x, Coord.y - _Pos.y);
  Result.x := (_rc * v.x - _rs * v.y) * _ConvertCoord.z + _ConvertCoord.x;
  Result.y := (_rs * v.x + _rc * v.y) * _ConvertCoord.w + _ConvertCoord.y;
end;

function TG2Display2D.CoordToDisplay(const Coord: TG2Vec2): TG2Vec2;
  var v: TG2Vec2;
begin
  v.SetValue((Coord.x - _ConvertCoord.x) / _ConvertCoord.z, (Coord.y - _ConvertCoord.y) / _ConvertCoord.w);
  v.y := (v.y * _rc - v.x * _rs) / (_rs * _rs + _rc * _rc);
  Result.x := (v.x + _rs * v.y) / _rc + _Pos.x;
  Result.y := v.y + _Pos.y;
end;

{$Warnings off}
function TG2Display2D.ScreenBounds: TG2Rect;
  var v: array[0..3] of TG2Vec2;
  var i: Integer;
begin
  v[0] := CoordToDisplay(G2Vec2(_ViewPort.Left, _ViewPort.Top));
  v[1] := CoordToDisplay(G2Vec2(_ViewPort.Right, _ViewPort.Top));
  v[2] := CoordToDisplay(G2Vec2(_ViewPort.Left, _ViewPort.Bottom));
  v[3] := CoordToDisplay(G2Vec2(_ViewPort.Right, _ViewPort.Bottom));
  Result.TopLeft := v[0];
  Result.BottomRight := v[0];
  for i := 1 to 3 do
  begin
    if v[i].x < Result.l then Result.l := v[i].x
    else if v[i].x > Result.r then Result.r := v[i].x;
    if v[i].y < Result.t then Result.t := v[i].y
    else if v[i].y > Result.b then Result.b := v[i].y;
  end;
end;
{$Warnings on}

procedure TG2Display2D.PicQuadCol(
  const Pos0, Pos1, Pos2, Pos3, Tex0, Tex1, Tex2, Tex3: TG2Vec2;
  const Col0, Col1, Col2, Col3: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2IntU32 = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  g2.PicQuadCol(
    CoordToScreen(Pos0), CoordToScreen(Pos1),
    CoordToScreen(Pos2), CoordToScreen(Pos3),
    Tex0, Tex1, Tex2, Tex3,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicQuadCol(
  const x0, y0, x1, y1, x2, y2, x3, y3, tu0, tv0, tu1, tv1, tu2, tv2, tu3, tv3: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  g2.PicQuadCol(
    CoordToScreen(G2Vec2(x0, y0)), CoordToScreen(G2Vec2(x1, y1)),
    CoordToScreen(G2Vec2(x2, y2)), CoordToScreen(G2Vec2(x3, y3)),
    G2Vec2(tu0, tv0), G2Vec2(tu1, tv1),
    G2Vec2(tu2, tv2), G2Vec2(tu3, tv3),
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicQuad(
  const Pos0, Pos1, Pos2, Pos3, Tex0, Tex1, Tex2, Tex3: TG2Vec2;
  const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicQuadCol(
    Pos0, Pos1, Pos2, Pos3,
    Tex0, Tex1, Tex2, Tex3,
    Col, Col, Col, Col,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicQuad(
  const x0, y0, x1, y1, x2, y2, x3, y3, tu0, tv0, tu1, tv1, tu2, tv2, tu3, tv3: TG2Float;
  const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicQuadCol(
    x0, y0, x1, y1, x2, y2, x3, y3,
    tu0, tv0, tu1, tv1, tu2, tv2, tu3, tv3,
    Col, Col, Col, Col,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRectCol(
  const Pos: TG2Vec2;
  const w, h: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Color;
  const TexRect: TG2Vec4;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
  var Pos2: TG2Vec2;
begin
  Pos2.x := Pos.x + w; Pos2.y := Pos.y + h;
  PicQuadCol(
    Pos.x, Pos.y, Pos2.x, Pos.y, Pos.x, Pos2.y, Pos2.x, Pos2.y,
    TexRect.x, TexRect.y, TexRect.z, TexRect.y,
    TexRect.x, TexRect.w, TexRect.z, TexRect.w,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRectCol(
  const x, y: TG2Float;
  const w, h: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Color;
  const tu0, tv0, tu1, tv1: TG2Float;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
  var x2, y2: TG2Float;
begin
  x2 := x + w; y2 := y + h;
  PicQuadCol(
    x, y, x2, y, x, y2, x2, y2,
    tu0, tv0, tu1, tv0, tu0, tv1, tu1, tv1,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRectCol(
  const Pos: TG2Vec2;
  const w, h: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
  var Pos2: TG2Vec2;
begin
  Pos2.x := Pos.x + w; Pos2.y := Pos.y + h;
  PicQuadCol(
    Pos.x, Pos.y, Pos2.x, Pos.y, Pos.x, Pos2.y, Pos2.x, Pos2.y,
    0, 0, Texture.SizeTU, 0,
    0, Texture.SizeTV, Texture.SizeTU, Texture.SizeTV,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRectCol(
  const x, y: TG2Float;
  const w, h: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
  var x2, y2: TG2Float;
begin
  x2 := x + w; y2 := y + h;
  PicQuadCol(
    x, y, x2, y, x, y2, x2, y2,
    0, 0, Texture.SizeTU, 0,
    0, Texture.SizeTV, Texture.SizeTU, Texture.SizeTV,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRectCol(
  const Pos: TG2Vec2;
  const Col0, Col1, Col2, Col3: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
  var Pos2: TG2Vec2;
begin
  Pos2.x := Pos.x + Texture.Width; Pos2.y := Pos.y + Texture.Height;
  PicQuadCol(
    Pos.x, Pos.y, Pos2.x, Pos.y, Pos.x, Pos2.y, Pos2.x, Pos2.y,
    0, 0, Texture.SizeTU, 0,
    0, Texture.SizeTV, Texture.SizeTU, Texture.SizeTV,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRectCol(
  const x, y: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
  var x2, y2: TG2Float;
begin
  x2 := x + Texture.Width; y2 := y + Texture.Height;
  PicQuadCol(
    x, y, x2, y, x, y2, x2, y2,
    0, 0, Texture.SizeTU, 0,
    0, Texture.SizeTV, Texture.SizeTU, Texture.SizeTV,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRectCol(
  const Pos: TG2Vec2;
  const w, h: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Color;
  const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const FrameWidth, FrameHeight: TG2IntS32;
  const FrameID: TG2IntS32;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    Pos.x, Pos.y, w, h,
    Col0, Col1, Col2, Col3,
    CenterX, CenterY, ScaleX, ScaleY, Angle,
    FlipU, FlipV, Texture,
    FrameWidth, FrameHeight, FrameID,
    BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRectCol(
  const x, y: TG2Float;
  const w, h: TG2Float;
  const Col0, Col1, Col2, Col3: TG2Color;
  const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const FrameWidth, FrameHeight: TG2IntS32;
  const FrameID: TG2IntS32;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
  var v0, v1, v2, v3: TG2Vec2;
  var tr0, tr1, tc0, tc1, tc2, tc3: TG2Vec2;
  var wl, wh, hl, hh, s, c, tu, tv: TG2Float;
  var pc, px, py: TG2IntS32;
begin
  wl := -w * CenterX * ScaleX; wh := w * ScaleX + wl;
  hl := -h * CenterY * ScaleY; hh := h * ScaleY + hl;
  G2SinCos(Angle, s{%H-}, c{%H-});
  v0.x := c * wl - s * hl + x; v0.y := s * wl + c * hl + y;
  v1.x := c * wh - s * hl + x; v1.y := s * wh + c * hl + y;
  v2.x := c * wl - s * hh + x; v2.y := s * wl + c * hh + y;
  v3.x := c * wh - s * hh + x; v3.y := s * wh + c * hh + y;
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
  PicQuadCol(
    v0, v1, v2, v3,
    tc0, tc1, tc2, tc3,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRectCol(
  const Pos: TG2Vec2;
  const w, h: TG2Float;
  const TexRect: TG2Rect;
  const Col0, Col1, Col2, Col3: TG2Color;
  const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    Pos.x, Pos.y,
    w, h,
    TexRect,
    Col0, Col1, Col2, Col3,
    CenterX, CenterY, ScaleX, ScaleY, Angle,
    FlipU, FlipV, Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRectCol(
  const x, y: TG2Float;
  const w, h: TG2Float;
  const TexRect: TG2Rect;
  const Col0, Col1, Col2, Col3: TG2Color;
  const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
  var v0, v1, v2, v3: TG2Vec2;
  var tr0, tr1, tc0, tc1, tc2, tc3: TG2Vec2;
  var wl, wh, hl, hh, s, c: TG2Float;
begin
  wl := -w * CenterX * ScaleX; wh := w * ScaleX + wl;
  hl := -h * CenterY * ScaleY; hh := h * ScaleY + hl;
  G2SinCos(Angle, s{%H-}, c{%H-});
  v0.x := c * wl - s * hl + x; v0.y := s * wl + c * hl + y;
  v1.x := c * wh - s * hl + x; v1.y := s * wh + c * hl + y;
  v2.x := c * wl - s * hh + x; v2.y := s * wl + c * hh + y;
  v3.x := c * wh - s * hh + x; v3.y := s * wh + c * hh + y;
  tr0 := TexRect.tl;
  tr1 := TexRect.br;
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
  PicQuadCol(
    v0, v1, v2, v3,
    tc0, tc1, tc2, tc3,
    Col0, Col1, Col2, Col3,
    Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRect(
  const Pos: TG2Vec2; const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(Pos, Col, Col, Col, Col, Texture, BlendMode, Filtering);
end;

procedure TG2Display2D.PicRect(
  const x, y: TG2Float; const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(x, y, Col, Col, Col, Col, Texture, BlendMode, Filtering);
end;

procedure TG2Display2D.PicRect(
  const Pos: TG2Vec2;
  const w, h: TG2Float;
  const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(Pos, w, h, Col, Col, Col, Col, Texture, BlendMode, Filtering);
end;

procedure TG2Display2D.PicRect(
  const x, y: TG2Float;
  const w, h: TG2Float;
  const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(x, y, w, h, Col, Col, Col, Col, Texture, BlendMode, Filtering);
end;

procedure TG2Display2D.PicRect(
  const Pos: TG2Vec2;
  const w, h: TG2Float;
  const TexRect: TG2Vec4;
  const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(Pos, w, h, TexRect, Col, Col, Col, Col, Texture, BlendMode, Filtering);
end;

procedure TG2Display2D.PicRect(
  const x, y: TG2Float;
  const w, h: TG2Float;
  const tu0, tv0, tu1, tv1: TG2Float;
  const Col: TG2Color;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(x, y, w, h, Col, Col, Col, Col, tu0, tv0, tu1, tv1, Texture, BlendMode, Filtering);
end;

procedure TG2Display2D.PicRect(
  const Pos: TG2Vec2;
  const w, h: TG2Float;
  const Col: TG2Color;
  const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const FrameWidth, FrameHeight: TG2IntS32;
  const FrameID: TG2IntS32;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    Pos, w, h,
    Col, Col, Col, Col,
    CenterX, CenterY, ScaleX, ScaleY, Angle,
    FlipU, FlipV, Texture,
    FrameWidth, FrameHeight, FrameID,
    BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRect(
  const x, y: TG2Float;
  const w, h: TG2Float;
  const Col: TG2Color;
  const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const FrameWidth, FrameHeight: TG2IntS32;
  const FrameID: TG2IntS32;
  const BlendMode: TG2BlendModeRef = bmNormal;
  const Filtering: TG2Filter = tfPoint
);
begin
  PicRectCol(
    x, y, w, h,
    Col, Col, Col, Col,
    CenterX, CenterY, ScaleX, ScaleY, Angle,
    FlipU, FlipV, Texture,
    FrameWidth, FrameHeight, FrameID,
    BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRect(
  const Pos: TG2Vec2; const w, h: TG2Float;
  const TexRect: TG2Rect; const Color: TG2Color;
  const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef;
  const Filtering: TG2Filter
);
begin
  PicRectCol(
    Pos, w, h, TexRect,
    Color, Color, Color, Color,
    CenterX, CenterY, ScaleX, ScaleY, Angle,
    FlipU, FlipV, Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PicRect(
  const x, y: TG2Float; const w, h: TG2Float;
  const TexRect: TG2Rect; const Color: TG2Color;
  const CenterX, CenterY, ScaleX, ScaleY, Angle: TG2Float;
  const FlipU, FlipV: Boolean;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef;
  const Filtering: TG2Filter
);
begin
  PicRectCol(
    x, y, w, h, TexRect,
    Color, Color, Color, Color,
    CenterX, CenterY, ScaleX, ScaleY, Angle,
    FlipU, FlipV, Texture, BlendMode, Filtering
  );
end;

procedure TG2Display2D.PrimBegin(const PrimType: TG2PrimType; const BlendMode: TG2BlendMode);
begin
  g2.PrimBegin(PrimType, BlendMode);
end;

procedure TG2Display2D.PrimEnd;
begin
  g2.PrimEnd;
end;

procedure TG2Display2D.PrimAdd(const x, y: TG2Float; const Color: TG2Color);
begin
  g2.PrimAdd(CoordToScreen(G2Vec2(x, y)), Color);
end;

procedure TG2Display2D.PrimAdd(const v: TG2Vec2; const Color: TG2Color);
begin
  g2.PrimAdd(CoordToScreen(v), Color);
end;

procedure TG2Display2D.PrimLineCol(const Pos0, Pos1: TG2Vec2; const Col0, Col1: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(Pos0, Col0);
  PrimAdd(Pos1, Col1);
  PrimEnd;
end;

procedure TG2Display2D.PrimLineCol(const x0, y0, x1, y1: TG2Float; const Col0, Col1: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(x0, y0, Col0);
  PrimAdd(x1, y1, Col1);
  PrimEnd;
end;

procedure TG2Display2D.PrimTriCol(const Pos0, Pos1, Pos2: TG2Vec2; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(Pos0, Col0);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos2, Col2);
  PrimEnd;
end;

procedure TG2Display2D.PrimTriCol(const x0, y0, x1, y1, x2, y2: TG2Float; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(x0, y0, Col0);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x2, y2, Col2);
  PrimEnd;
end;

procedure TG2Display2D.PrimQuadCol(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(Pos0, Col0);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos2, Col2);
  PrimAdd(Pos2, Col2);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos3, Col3);
  PrimEnd;
end;

procedure TG2Display2D.PrimQuadCol(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(x0, y0, Col0);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x2, y2, Col2);
  PrimAdd(x2, y2, Col2);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x3, y3, Col3);
  PrimEnd;
end;

procedure TG2Display2D.PrimQuad(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(Pos0, Col);
  PrimAdd(Pos1, Col);
  PrimAdd(Pos2, Col);
  PrimAdd(Pos2, Col);
  PrimAdd(Pos1, Col);
  PrimAdd(Pos3, Col);
  PrimEnd;
end;

procedure TG2Display2D.PrimQuad(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(x0, y0, Col);
  PrimAdd(x1, y1, Col);
  PrimAdd(x2, y2, Col);
  PrimAdd(x2, y2, Col);
  PrimAdd(x1, y1, Col);
  PrimAdd(x3, y3, Col);
  PrimEnd;
end;

procedure TG2Display2D.PrimRectCol(const x, y, w, h: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
  var x1, y1: TG2Float;
begin
  x1 := x + w;
  y1 := y + h;
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(x, y, Col0);
  PrimAdd(x1, y, Col1);
  PrimAdd(x, y1, Col2);
  PrimAdd(x, y1, Col2);
  PrimAdd(x1, y, Col1);
  PrimAdd(x1, y1, Col3);
  PrimEnd;
end;

procedure TG2Display2D.PrimRect(const x, y, w, h: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
  var x1, y1: TG2Float;
begin
  x1 := x + w;
  y1 := y + h;
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(x, y, Col);
  PrimAdd(x1, y, Col);
  PrimAdd(x, y1, Col);
  PrimAdd(x, y1, Col);
  PrimAdd(x1, y, Col);
  PrimAdd(x1, y1, Col);
  PrimEnd;
end;

procedure TG2Display2D.PrimRectHollowCol(const x, y, w, h: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
  var x1, y1: TG2Float;
begin
  x1 := x + w;
  y1 := y + h;
  PrimBegin(ptLines, BlendMode);
  PrimAdd(x, y, Col0);
  PrimAdd(x1, y, Col1);
  PrimAdd(x1, y, Col1);
  PrimAdd(x1, y1, Col3);
  PrimAdd(x1, y1, Col3);
  PrimAdd(x, y1, Col2);
  PrimAdd(x, y1, Col2);
  PrimAdd(x, y, Col0);
  PrimEnd;
end;

procedure TG2Display2D.PrimRectHollow(const x, y, w, h: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
  var x1, y1: TG2Float;
begin
  x1 := x + w;
  y1 := y + h;
  PrimBegin(ptLines, BlendMode);
  PrimAdd(x, y, Col);
  PrimAdd(x1, y, Col);
  PrimAdd(x1, y, Col);
  PrimAdd(x1, y1, Col);
  PrimAdd(x1, y1, Col);
  PrimAdd(x, y1, Col);
  PrimAdd(x, y1, Col);
  PrimAdd(x, y, Col);
  PrimEnd;
end;

procedure TG2Display2D.PrimCircleCol(const Pos: TG2Vec2; const Radius: TG2Float; const Col0, Col1: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal);
  var a, s, c: TG2Float;
  var v, v2: TG2Vec2;
  var i: TG2IntS32;
begin
  a := G2TwoPi / Segments;
  G2SinCos(a, s{%H-}, c{%H-});
  v.SetValue(Radius, 0);
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(Pos, Col0);
  PrimAdd(v + Pos, Col1);
  for i := 0 to Segments - 2 do
  begin
    v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
    v2 := v + Pos;
    PrimAdd(v2, Col1);
    PrimAdd(Pos, Col0);
    PrimAdd(v2, Col1);
  end;
  v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
  PrimAdd(v + Pos, Col1);
  PrimEnd;
end;

procedure TG2Display2D.PrimCircleCol(const x, y, Radius: TG2Float; const Col0, Col1: TG2Color; const Segments: TG2IntS32 = 16; const BlendMode: TG2BlendModeRef = bmNormal);
  var a, s, c, cx, cy: TG2Float;
  var v: TG2Vec2;
  var i: TG2IntS32;
begin
  a := G2TwoPi / Segments;
  G2SinCos(a, s{%H-}, c{%H-});
  v.SetValue(Radius, 0);
  PrimBegin(ptTriangles, BlendMode);
  PrimAdd(x, y, Col0);
  PrimAdd(v.x + x, v.y + y, Col1);
  for i := 0 to Segments - 2 do
  begin
    v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
    cx := v.x + x; cy := v.y + y;
    PrimAdd(cx, cy, Col1);
    PrimAdd(x, y, Col0);
    PrimAdd(cx, cy, Col1);
  end;
  v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
  PrimAdd(v.x + x, v.y + y, Col1);
  PrimEnd;
end;

procedure TG2Display2D.PrimRingCol(
  const Pos: TG2Vec2; const Radius0, Radius1: TG2Float;
  const Col0, Col1: TG2Color; const Segments: TG2IntS32;
  const BlendMode: TG2BlendModeRef
);
  var a, s, c: TG2Float;
  var v0, v1, pv0, pv1: TG2Vec2;
  var i: TG2IntS32;
begin
  a := G2TwoPi / Segments;
  G2SinCos(a, s{%H-}, c{%H-});
  v0.SetValue(Radius0, 0);
  v1.SetValue(Radius1, 0);
  PrimBegin(ptTriangles, BlendMode);
  for i := 0 to Segments - 1 do
  begin
    pv0 := v0; pv1 := v1;
    v0.SetValue(c * v0.x - s * v0.y, s * v0.x + c * v0.y);
    v1.SetValue(c * v1.x - s * v1.y, s * v1.x + c * v1.y);
    PrimAdd(Pos + pv0, Col0);
    PrimAdd(Pos + pv1, Col1);
    PrimAdd(Pos + v0, Col0);
    PrimAdd(Pos + v0, Col0);
    PrimAdd(Pos + pv1, Col1);
    PrimAdd(Pos + v1, Col1);
  end;
  PrimEnd;
end;

procedure TG2Display2D.PrimRingCol(
  const x, y: TG2Float; const Radius0, Radius1: TG2Float;
  const Col0, Col1: TG2Color; const Segments: TG2IntS32;
  const BlendMode: TG2BlendModeRef
);
begin
  PrimRingCol(G2Vec2(x, y), Radius0, Radius1, Col0, Col1, Segments, BlendMode);
end;

procedure TG2Display2D.PrimTriHollowCol(const Pos0, Pos1, Pos2: TG2Vec2; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(Pos0, Col0);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos2, Col2);
  PrimAdd(Pos2, Col2);
  PrimAdd(Pos0, Col0);
  PrimEnd;
end;

procedure TG2Display2D.PrimTriHollowCol(const x0, y0, x1, y1, x2, y2: TG2Float; const Col0, Col1, Col2: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(x0, y0, Col0);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x2, y2, Col2);
  PrimAdd(x2, y2, Col2);
  PrimAdd(x0, y0, Col0);
  PrimEnd;
end;

procedure TG2Display2D.PrimQuadHollowCol(const Pos0, Pos1, Pos2, Pos3: TG2Vec2; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(Pos0, Col0);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos1, Col1);
  PrimAdd(Pos3, Col2);
  PrimAdd(Pos3, Col2);
  PrimAdd(Pos2, Col3);
  PrimAdd(Pos2, Col3);
  PrimAdd(Pos0, Col0);
  PrimEnd;
end;

procedure TG2Display2D.PrimQuadHollowCol(const x0, y0, x1, y1, x2, y2, x3, y3: TG2Float; const Col0, Col1, Col2, Col3: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(x0, y0, Col0);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x1, y1, Col1);
  PrimAdd(x3, y3, Col2);
  PrimAdd(x3, y3, Col2);
  PrimAdd(x2, y2, Col3);
  PrimAdd(x2, y2, Col3);
  PrimAdd(x0, y0, Col0);
  PrimEnd;
end;

procedure TG2Display2D.PrimCircleHollow(const Pos: TG2Vec2; const Radius: TG2Float; const Col: TG2Color; const Segments: TG2IntS32; const BlendMode: TG2BlendModeRef = bmNormal);
  var a, s, c: TG2Float;
  var v, v2: TG2Vec2;
  var i: TG2IntS32;
begin
  a := G2TwoPi / Segments;
  G2SinCos(a, s{%H-}, c{%H-});
  v.SetValue(Radius, 0);
  v2 := v + Pos;
  PrimBegin(ptLines, BlendMode);
  PrimAdd(v2, Col);
  for i := 0 to Segments - 2 do
  begin
    v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
    v2 := v + Pos;
    PrimAdd(v2, Col);
    PrimAdd(v2, Col);
  end;
  v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
  v2 := v + Pos;
  PrimAdd(v2, Col);
  PrimEnd;
end;

procedure TG2Display2D.PrimCircleHollow(const x, y, Radius: TG2Float; const Col: TG2Color; const Segments: TG2IntS32; const BlendMode: TG2BlendModeRef = bmNormal);
  var a, s, c, cx, cy: TG2Float;
  var v: TG2Vec2;
  var i: TG2IntS32;
begin
  a := G2TwoPi / Segments;
  G2SinCos(a, s{%H-}, c{%H-});
  v.SetValue(Radius, 0);
  cx := v.x + x; cy := v.y + y;
  PrimBegin(ptLines, BlendMode);
  PrimAdd(cx, cy, Col);
  for i := 0 to Segments - 2 do
  begin
    v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
    cx := v.x + x; cy := v.y + y;
    PrimAdd(cx, cy, Col);
    PrimAdd(cx, cy, Col);
  end;
  v.SetValue(c * v.x - s * v.y, s * v.x + c * v.y);
  cx := v.x + x; cy := v.y + y;
  PrimAdd(cx, cy, Col);
  PrimEnd;
end;

procedure TG2Display2D.PrimLine(const Pos0, Pos1: TG2Vec2; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(Pos0, Col);
  PrimAdd(Pos1, Col);
  PrimEnd;
end;

procedure TG2Display2D.PrimLine(const x0, y0, x1, y1: TG2Float; const Col: TG2Color; const BlendMode: TG2BlendModeRef = bmNormal);
begin
  PrimBegin(ptLines, BlendMode);
  PrimAdd(x0, y0, Col);
  PrimAdd(x1, y1, Col);
  PrimEnd;
end;

procedure TG2Display2D.PolyBegin(
  const PolyType: TG2PrimType;
  const Texture: TG2Texture2DBase;
  const BlendMode: TG2BlendModeRef;
  const Filter: TG2Filter
);
begin
  g2.PolyBegin(PolyType, Texture, BlendMode, Filter);
end;

procedure TG2Display2D.PolyEnd;
begin
  g2.PolyEnd;
end;

procedure TG2Display2D.PolyAdd(const x, y, u, v: TG2Float; const Color: TG2Color);
begin
  g2.PolyAdd(CoordToScreen(G2Vec2(x, y)), G2Vec2(u, v), Color);
end;

procedure TG2Display2D.PolyAdd(const Pos, TexCoord: TG2Vec2; const Color: TG2Color);
begin
  g2.PolyAdd(CoordToScreen(Pos), TexCoord, Color);
end;
//TG2Display2D END

{$if defined(G2RM_SM2)}
//TG2Mesh BEGIN
procedure TG2Mesh.Initialize;
begin
  Nodes.Clear;
  Geoms.Clear;
  Anims.Clear;
  Materials.Clear;
end;

procedure TG2Mesh.Finalize;
begin
  inherited Finalize;
end;

class function TG2Mesh.SharedAsset(const SharedAssetName: String): TG2Mesh;
  var Res: TG2Res;
  var dm: TG2DataManager;
begin
  Res := TG2Res.List;
  while Res <> nil do
  begin
    if (Res is TG2Mesh)
    and (TG2Mesh(Res).AssetName = SharedAssetName)
    and (Res.RefCount > 0) then
    begin
      Result := TG2Mesh(Res);
      Exit;
    end;
    Res := Res.Next;
  end;
  dm := TG2DataManager.Create(SharedAssetName, dmAsset);
  Result := TG2Mesh.Create;
  Result.AssetName := SharedAssetName;
  Result.Load(dm);
  dm.Free;
end;

destructor TG2Mesh.Destroy;
  var DataSkinned: PG2GeomDataSkinned;
  var DataStatic: PG2GeomDataStatic;
  var i, j: TG2IntS32;
begin
  Nodes.Clear;
  for i := 0 to Geoms.Count - 1 do
  begin
    if Geoms[i]^.Skinned then
    begin
      DataSkinned := PG2GeomDataSkinned(Geoms[i]^.Data);
      DataSkinned^.VB.Free;
      Dispose(DataSkinned);
    end
    else
    begin
      DataStatic := PG2GeomDataStatic(Geoms[i]^.Data);
      DataStatic^.VB.Free;
      Dispose(DataStatic);
    end;
    Geoms[i]^.IB.Free;
  end;
  Geoms.Clear;
  Anims.Clear;
  for i := 0 to Materials.Count - 1 do
  for j := 0 to Materials[i]^.ChannelCount - 1 do
  begin
    if Assigned(Materials[i]^.Channels[j].MapDiffuse) then
    begin
      Materials[i]^.Channels[j].MapDiffuse.RefDec;
    end;
    if Assigned(Materials[i]^.Channels[j].MapLight) then
    begin
      Materials[i]^.Channels[j].MapLight.RefDec;
    end;
  end;
  Materials.Clear;
  inherited Destroy;
end;

procedure TG2Mesh.Load(const MeshData: TG2MeshData);
  type TVertex = packed record
    Position: TG2Vec3;
    Normal: TG2Vec3;
    Tangent: TG2Vec3;
    Binormal: TG2Vec3;
  end;
  type PVertex = ^TVertex;
  var i, j, n: TG2IntS32;
  var MinV, MaxV, v: TG2Vec3;
  var Vertex: PVertex;
  var TexCoords: PG2Vec2;
  var BlendWeights: PG2Float;
  var BlendIndices: PG2Float;
  var DataStatic: PG2GeomDataStatic;
  var DataSkinned: PG2GeomDataSkinned;
begin
  Nodes.Clear;
  Nodes.Allocate(MeshData.NodeCount);
  for i := 0 to Nodes.Count - 1 do
  begin
    Nodes[i]^.Name := MeshData.Nodes[i].Name;
    Nodes[i]^.OwnerID := MeshData.Nodes[i].OwnerID;
    Nodes[i]^.Transform := MeshData.Nodes[i].Transform;
    Nodes[i]^.SubNodesID.Clear;
  end;
  for i := 0 to Nodes.Count - 1 do
  if Nodes[i]^.OwnerID > -1 then
  begin
    Nodes[Nodes[i]^.OwnerID]^.SubNodesID.Add(i);
  end;
  Geoms.Clear;
  Geoms.Allocate(MeshData.GeomCount);
  for i := 0 to Geoms.Count - 1 do
  begin
    Geoms[i]^.NodeID := MeshData.Geoms[i].NodeID;
    Geoms[i]^.VCount := MeshData.Geoms[i].VCount;
    Geoms[i]^.FCount := MeshData.Geoms[i].FCount;
    Geoms[i]^.GCount := MeshData.Geoms[i].MCount;
    Geoms[i]^.TCount := MeshData.Geoms[i].TCount;
    Geoms[i]^.Visible := True;
    Geoms[i]^.Skinned := MeshData.Geoms[i].SkinID > -1;
    SetLength(Geoms[i]^.Decl, 4 + Geoms[i]^.TCount);
    Geoms[i]^.Decl[0].Element := vbPosition; Geoms[i]^.Decl[0].Count := 3;
    Geoms[i]^.Decl[1].Element := vbNormal; Geoms[i]^.Decl[1].Count := 3;
    Geoms[i]^.Decl[2].Element := vbTangent; Geoms[i]^.Decl[2].Count := 3;
    Geoms[i]^.Decl[3].Element := vbBinormal; Geoms[i]^.Decl[3].Count := 3;
    for j := 4 to 4 + Geoms[i]^.TCount - 1 do
    begin
      Geoms[i]^.Decl[j].Element := vbTexCoord;
      Geoms[i]^.Decl[j].Count := 2;
    end;
    if Geoms[i]^.Skinned then
    begin
      New(DataSkinned);
      Geoms[i]^.Data := DataSkinned;
      DataSkinned^.MaxWeights := MeshData.Skins[MeshData.Geoms[i].SkinID].MaxWeights;
      DataSkinned^.BoneCount := MeshData.Skins[MeshData.Geoms[i].SkinID].BoneCount;
      SetLength(DataSkinned^.Bones, DataSkinned^.BoneCount);
      for j := 0 to DataSkinned^.BoneCount - 1 do
      begin
        DataSkinned^.Bones[j].NodeID := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].NodeID;
        DataSkinned^.Bones[j].Bind := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].Bind;
        DataSkinned^.Bones[j].BBox := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].BBox;
        DataSkinned^.Bones[j].VCount := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].VCount;
      end;
      n := Length(Geoms[i]^.Decl);
      if DataSkinned^.MaxWeights = 1 then
      begin
        SetLength(Geoms[i]^.Decl, Length(Geoms[i]^.Decl) + 1);
        Geoms[i]^.Decl[n].Element := vbVertexIndex; Geoms[i]^.Decl[n].Count := 1;
      end
      else
      begin
        SetLength(Geoms[i]^.Decl, Length(Geoms[i]^.Decl) + 2 * DataSkinned^.MaxWeights);
        Geoms[i]^.Decl[n].Element := vbVertexIndex; Geoms[i]^.Decl[n].Count := DataSkinned^.MaxWeights;
        Inc(n);
        Geoms[i]^.Decl[n].Element := vbVertexWeight; Geoms[i]^.Decl[n].Count := DataSkinned^.MaxWeights;
      end;
      DataSkinned^.VB := TG2VertexBuffer.Create(Geoms[i]^.Decl, Geoms[i]^.VCount);
      DataSkinned^.VB.Lock;
      for j := 0 to Geoms[i]^.VCount - 1 do
      begin
        Vertex := PVertex(DataSkinned^.VB.Data + TG2IntS32(DataSkinned^.VB.VertexSize) * j);
        TexCoords := PG2Vec2(Pointer(Vertex) + TG2IntS32(SizeOf(TVertex)));
        BlendIndices := PG2Float(Pointer(TexCoords) + Geoms[i]^.TCount * 8);
        BlendWeights := PG2Float(Pointer(BlendIndices) + DataSkinned^.MaxWeights * 4);
        Vertex^.Position := MeshData.Geoms[i].Vertices[j].Position;
        Vertex^.Normal := MeshData.Geoms[i].Vertices[j].Normal;
        Vertex^.Tangent := MeshData.Geoms[i].Vertices[j].Tangent;
        Vertex^.Binormal := MeshData.Geoms[i].Vertices[j].Binormal;
        for n := 0 to Geoms[i]^.TCount - 1 do
        begin
          TexCoords^ := MeshData.Geoms[i].Vertices[j].TexCoords[n];
          Inc(TexCoords);
        end;
        if DataSkinned^.MaxWeights = 1 then
        BlendIndices^ := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[0].BoneID
        else
        begin
          for n := 0 to MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].WeightCount - 1 do
          begin
            BlendIndices^ := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[n].BoneID;
            Inc(BlendIndices);
            BlendWeights^ := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[n].Weight;
            Inc(BlendWeights);
          end;
          for n := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].WeightCount to DataSkinned^.MaxWeights - 1 do
          begin
            BlendIndices^ := 0;
            Inc(BlendIndices);
            BlendWeights^ := 0;
            Inc(BlendWeights);
          end;
        end;
      end;
      DataSkinned^.VB.UnLock;
    end
    else
    begin
      New(DataStatic);
      Geoms[i]^.Data := DataStatic;
      DataStatic^.VB := TG2VertexBuffer.Create(Geoms[i]^.Decl, Geoms[i]^.VCount);
      DataStatic^.VB.Lock;
      MinV := MeshData.Geoms[i].Vertices[0].Position;
      MaxV := MinV;
      for j := 0 to Geoms[i]^.VCount - 1 do
      begin
        Vertex := PVertex(DataStatic^.VB.Data + TG2IntS32(DataStatic^.VB.VertexSize) * j);
        TexCoords := PG2Vec2(DataStatic^.VB.Data + TG2IntS32(DataStatic^.VB.VertexSize) * j + TG2IntS32(SizeOf(TVertex)));
        Vertex^.Position := MeshData.Geoms[i].Vertices[j].Position;
        Vertex^.Normal := MeshData.Geoms[i].Vertices[j].Normal;
        Vertex^.Tangent := MeshData.Geoms[i].Vertices[j].Tangent;
        Vertex^.Binormal := MeshData.Geoms[i].Vertices[j].Binormal;
        for n := 0 to Geoms[i]^.TCount - 1 do
        begin
          TexCoords^ := MeshData.Geoms[i].Vertices[j].TexCoords[n];
          Inc(TexCoords);
        end;
        if MeshData.Geoms[i].Vertices[j].Position.x > MaxV.x then MaxV.x := MeshData.Geoms[i].Vertices[j].Position.x
        else if MeshData.Geoms[i].Vertices[j].Position.x < MinV.x then MinV.x := MeshData.Geoms[i].Vertices[j].Position.x;
        if MeshData.Geoms[i].Vertices[j].Position.y > MaxV.y then MaxV.y := MeshData.Geoms[i].Vertices[j].Position.y
        else if MeshData.Geoms[i].Vertices[j].Position.y < MinV.y then MinV.y := MeshData.Geoms[i].Vertices[j].Position.y;
        if MeshData.Geoms[i].Vertices[j].Position.z > MaxV.z then MaxV.z := MeshData.Geoms[i].Vertices[j].Position.z
        else if MeshData.Geoms[i].Vertices[j].Position.z < MinV.z then MinV.z := MeshData.Geoms[i].Vertices[j].Position.z;
      end;
      DataStatic^.VB.UnLock;
      DataStatic^.BBox.c := (MinV + MaxV) * 0.5;
      v := (MaxV - MinV) * 0.5;
      DataStatic^.BBox.vx.SetValue(v.x, 0, 0);
      DataStatic^.BBox.vy.SetValue(0, v.y, 0);
      DataStatic^.BBox.vz.SetValue(0, 0, v.z);
    end;
    Geoms[i]^.IB := TG2IndexBuffer.Create(Geoms[i]^.FCount * 3);
    Geoms[i]^.IB.Lock;
    for j := 0 to Geoms[i]^.FCount - 1 do
    begin
      PG2IntU16Arr(Geoms[i]^.IB.Data)^[j * 3 + 0] := MeshData.Geoms[i].Faces[j][0];
      PG2IntU16Arr(Geoms[i]^.IB.Data)^[j * 3 + 1] := MeshData.Geoms[i].Faces[j][1];
      PG2IntU16Arr(Geoms[i]^.IB.Data)^[j * 3 + 2] := MeshData.Geoms[i].Faces[j][2];
    end;
    Geoms[i]^.IB.UnLock;
    SetLength(Geoms[i]^.Groups, Geoms[i]^.GCount);
    for j := 0 to Geoms[i]^.GCount - 1 do
    begin
      Geoms[i]^.Groups[j].Material := MeshData.Geoms[i].Groups[j].MaterialID;
      Geoms[i]^.Groups[j].VertexStart := MeshData.Geoms[i].Groups[j].VertexStart;
      Geoms[i]^.Groups[j].VertexCount := MeshData.Geoms[i].Groups[j].VertexCount;
      Geoms[i]^.Groups[j].FaceStart := MeshData.Geoms[i].Groups[j].FaceStart;
      Geoms[i]^.Groups[j].FaceCount := MeshData.Geoms[i].Groups[j].FaceCount;
    end;
  end;
  Materials.Clear;
  Materials.Allocate(MeshData.MaterialCount);
  for i := 0 to Materials.Count - 1 do
  begin
    Materials[i]^.ChannelCount := MeshData.Materials[i].ChannelCount;
    SetLength(Materials[i]^.Channels, Materials[i]^.ChannelCount);
    for j := 0 to Materials[i]^.ChannelCount - 1 do
    begin
      Materials[i]^.Channels[j].Name := MeshData.Materials[i].Channels[j].Name;
      Materials[i]^.Channels[j].TwoSided := MeshData.Materials[i].Channels[j].TwoSided;
      //if G2FileExists(MeshData.Materials[i].Channels[j].DiffuseMap) then
      begin
        Materials[i]^.Channels[j].MapDiffuse := TG2Texture2D.SharedAsset(MeshData.Materials[i].Channels[j].DiffuseMap, tu3D);
        Materials[i]^.Channels[j].MapDiffuse.RefInc;
      end;
      //else
      //begin
      //  Materials[i]^.Channels[j].MapDiffuse := nil;
      //end;
      if G2FileExists(MeshData.Materials[i].Channels[j].LightMap) then
      begin
        Materials[i]^.Channels[j].MapLight := TG2Texture2D.SharedAsset(MeshData.Materials[i].Channels[j].LightMap, tuDefault);
        Materials[i]^.Channels[j].MapLight.RefInc;
      end
      else
      begin
        Materials[i]^.Channels[j].MapLight := nil;
      end;
    end;
  end;
  Anims.Clear;
  Anims.Allocate(MeshData.AnimCount);
  for i := 0 to Anims.Count - 1 do
  begin
    Anims[i]^.Name := MeshData.Anims[i].Name;
    Anims[i]^.FrameCount := MeshData.Anims[i].FrameCount;
    Anims[i]^.FrameRate := MeshData.Anims[i].FrameRate;
    Anims[i]^.NodeCount := MeshData.Anims[i].NodeCount;
    SetLength(Anims[i]^.Nodes, Anims[i]^.NodeCount);
    for j := 0 to Anims[i]^.NodeCount - 1 do
    begin
      Anims[i]^.Nodes[j].NodeID := MeshData.Anims[i].Nodes[j].NodeID;
      SetLength(Anims[i]^.Nodes[j].Frames, Anims[i]^.FrameCount);
      for n := 0 to Anims[i]^.FrameCount - 1 do
      begin
        Anims[i]^.Nodes[j].Frames[n].Scaling := MeshData.Anims[i].Nodes[j].Frames[n].Scaling;
        Anims[i]^.Nodes[j].Frames[n].Rotation := MeshData.Anims[i].Nodes[j].Frames[n].Rotation;
        Anims[i]^.Nodes[j].Frames[n].Translation := MeshData.Anims[i].Nodes[j].Frames[n].Translation;
      end;
    end;
  end;
end;

procedure TG2Mesh.Load(const DataManager: TG2DataManager);
  var MeshData: TG2MeshData;
  var MeshLoader: TG2MeshLoader;
  var i: TG2IntS32;
begin
  for i := 0 to High(G2MeshLoaders) do
  if G2MeshLoaders[i].CanLoad(DataManager) then
  begin
    MeshLoader := G2MeshLoaders[i].Create;
    try
      MeshLoader.Load(DataManager);
      MeshLoader.ExportMeshData(@MeshData);
      MeshData.LimitSkins;
      Load(MeshData);
    finally
      MeshLoader.Free;
    end;
  end;
end;

procedure TG2Mesh.Load(const Stream: TStream);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Stream);
  Load(dm);
  dm.Free;
end;

procedure TG2Mesh.Load(const FileName: String);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName, dmAsset);
  Load(dm);
  dm.Free;
end;

function TG2Mesh.AnimIndex(const Name: AnsiString): TG2IntS32;
  var i: TG2IntS32;
begin
  for i := 0 to Anims.Count - 1 do
  if Anims[i]^.Name = Name then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;

function TG2Mesh.NewInst: TG2MeshInst;
begin
  Result := TG2MeshInst.Create(Self);
end;
//TG2Mesh END

//TG2MeshInst BEIGN
function TG2MeshInst.GetOBBox: TG2Box;
  var i: TG2IntS32;
  var b: TG2AABox;
begin
  if _Mesh.Geoms.Count < 1 then
  begin
    Result.SetValue(G2Vec3(0, 0, 0), G2Vec3(0, 0, 0), G2Vec3(0, 0, 0), G2Vec3(0, 0, 0));

    Exit;
  end;
  b := GetGeomBBox(0);
  for i := 1 to _Mesh.Geoms.Count - 1 do
  b.Merge(GetGeomBBox(i));
  Result := b;
end;

function TG2MeshInst.GetGeomBBox(const Index: TG2IntS32): TG2Box;
  var DataSkinned: PG2GeomDataSkinned;
  var i, j: TG2IntS32;
  var b: TG2AABox;
begin
  if _Mesh.Geoms[Index]^.Skinned then
  begin
    DataSkinned := PG2GeomDataSkinned(_Mesh.Geoms[Index]^.Data);
    for i := 0 to DataSkinned^.BoneCount - 1 do
    if DataSkinned^.Bones[i].VCount > 0 then
    begin
      b := DataSkinned^.Bones[i].BBox.Transform(_SkinTransforms[Index][i]);
      Break;
    end;
    for j := i + 1 to DataSkinned^.BoneCount - 1 do
    if DataSkinned^.Bones[j].VCount > 0 then
    b.Merge(DataSkinned^.Bones[j].BBox.Transform(_SkinTransforms[Index][j]));
    Result := b;
  end
  else
  Result := PG2GeomDataStatic(_Mesh.Geoms[Index]^.Data)^.BBox.Transform(Transforms[_Mesh.Geoms[Index]^.NodeID].TransformCom);
end;

function TG2MeshInst.GetSkinTransforms(const Index: TG2IntS32): PG2Mat;
begin
  Result := @_SkinTransforms[Index];
end;

function TG2MeshInst.GetAABox: TG2AABox;
begin
  Result := GetOBBox;
end;

procedure TG2MeshInst.ComputeSkinTransforms;
  var i, j: TG2IntS32;
  var DataSkinned: PG2GeomDataSkinned;
begin
  for i := 0 to _Mesh.Geoms.Count - 1 do
  if _Mesh.Geoms[i]^.Skinned then
  begin
    DataSkinned := PG2GeomDataSkinned(_Mesh.Geoms[i]^.Data);
    for j := 0 to DataSkinned^.BoneCount - 1 do
    _SkinTransforms[i][j] := DataSkinned^.Bones[j].Bind * Transforms[DataSkinned^.Bones[j].NodeID].TransformCom;
  end;
end;

constructor TG2MeshInst.Create(const AMesh: TG2Mesh);
  var i: TG2IntS32;
begin
  inherited Create;
  _Mesh := AMesh;
  SetLength(Materials, _Mesh.Materials.Count);
  for i := 0 to _Mesh.Materials.Count - 1 do
  Materials[i] := _Mesh.Materials[i];
  SetLength(Transforms, _Mesh.Nodes.Count);
  _RootNodes.Clear;
  for i := 0 to _Mesh.Nodes.Count - 1 do
  begin
    if _Mesh.Nodes[i]^.OwnerID = -1 then
    begin
      _RootNodes.Add(i);
    end;
    Transforms[i].TransformDef := _Mesh.Nodes[i]^.Transform;
    Transforms[i].TransformCur := Transforms[i].TransformDef;
    Transforms[i].TransformCom := G2MatIdentity;
  end;
  SetLength(_SkinTransforms, _Mesh.Geoms.Count);
  for i := 0 to _Mesh.Geoms.Count - 1 do
  if _Mesh.Geoms[i]^.Skinned then
  begin
    SetLength(_SkinTransforms[i], PG2GeomDataSkinned(_Mesh.Geoms[i]^.Data)^.BoneCount);
  end;
  ComputeTransforms;
end;

destructor TG2MeshInst.Destroy;
begin
  inherited Destroy;
end;

procedure TG2MeshInst.FrameSetFast(const AnimName: AnsiString; const Frame: TG2IntS32);
  var AnimIndex, i, f0: TG2IntS32;
  var ms, mr, mt: TG2Mat;
begin
  AnimIndex := _Mesh.AnimIndex(AnimName);
  if AnimIndex > -1 then
  begin
    if Frame < 0 then
    f0 := _Mesh.Anims[AnimIndex]^.FrameCount - (Abs(Frame) mod _Mesh.Anims[AnimIndex]^.FrameCount)
    else
    f0 := Frame mod _Mesh.Anims[AnimIndex]^.FrameCount;
    for i := 0 to _Mesh.Anims[AnimIndex]^.NodeCount - 1 do
    begin
      ms := G2MatScaling(_Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Scaling);
      mr := G2MatRotation(_Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Rotation);
      mt := G2MatTranslation(_Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Translation);
      Transforms[_Mesh.Anims[AnimIndex]^.Nodes[i].NodeID].TransformCur := ms * mr * mt;
    end;
    if _AutoComputeTransforms then ComputeTransforms;
  end;
end;

procedure TG2MeshInst.FrameSet(const AnimName: AnsiString; const Frame: TG2Float);
  var AnimIndex, i, f0, f1: TG2IntS32;
  var f: TG2Float;
  var s0: TG2Vec3;
  var r0: TG2Quat;
  var t0: TG2Vec3;
  var ms, mr, mt: TG2Mat;
begin
  AnimIndex := _Mesh.AnimIndex(AnimName);
  if AnimIndex > -1 then
  begin
    if Frame < 0 then
    f := _Mesh.Anims[AnimIndex]^.FrameCount - (Trunc(Abs(Frame)) mod _Mesh.Anims[AnimIndex]^.FrameCount) + Frac(Frame)
    else
    f := Frame;
    f0 := Trunc(f) mod _Mesh.Anims[AnimIndex]^.FrameCount;
    f1 := (f0 + 1) mod _Mesh.Anims[AnimIndex]^.FrameCount;
    f := Frac(f);
    for i := 0 to _Mesh.Anims[AnimIndex]^.NodeCount - 1 do
    begin
      s0 := G2LerpVec3(
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Scaling,
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f1].Scaling,
        f
      );
      r0 := G2QuatSlerp(
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Rotation,
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f1].Rotation,
        f
      );
      t0 := G2LerpVec3(
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Translation,
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f1].Translation,
        f
      );
      ms := G2MatScaling(s0);
      mr := G2MatRotation(r0);
      mt := G2MatTranslation(t0);
      Transforms[_Mesh.Anims[AnimIndex]^.Nodes[i].NodeID].TransformCur := ms * mr * mt;
    end;
    if _AutoComputeTransforms then ComputeTransforms;
  end;
end;

procedure TG2MeshInst.ComputeTransforms;
  procedure ComputeNode(const NodeID: TG2IntS32);
    var i: TG2IntS32;
  begin
    if _Mesh.Nodes[NodeID]^.OwnerID > -1 then
    Transforms[NodeID].TransformCom := Transforms[NodeID].TransformCur * Transforms[_Mesh.Nodes[NodeID]^.OwnerID].TransformCom
    else
    Transforms[NodeID].TransformCom := Transforms[NodeID].TransformCur;
    for i := 0 to _Mesh.Nodes[NodeID]^.SubNodesID.Count - 1 do
    ComputeNode(_Mesh.Nodes[NodeID]^.SubNodesID[i]);
  end;
  var i: TG2IntS32;
begin
  for i := 0 to _RootNodes.Count - 1 do
  ComputeNode(_RootNodes[i]);
  ComputeSkinTransforms;
end;
//TG2MeshInst END
{$endif}

//TG2S3DNode BEGIN
procedure TG2S3DNode.SetTransform(const Value: TG2Mat);
begin
  _Transform := Value;
end;

constructor TG2S3DNode.Create(const Scene: TG2Scene3D);
begin
  inherited Create;
  _Scene := Scene;
  _Scene.Nodes.Add(Self);
  _Transform := G2MatIdentity;
end;

destructor TG2S3DNode.Destroy;
begin
  _Scene.Nodes.Remove(Self);
  inherited Destroy;
end;
//TG2S3DNode END

//TG2S3DFrame BEGIN
constructor TG2S3DFrame.Create(const Scene: TG2Scene3D);
begin
  inherited Create(Scene);
  _Scene.Frames.Add(Self);
end;

destructor TG2S3DFrame.Destroy;
begin
  _Scene.Frames.Remove(Self);
  inherited Destroy;
end;
//TG2S3DFrame END

//TG2S3DMeshBuilder BEGIN
procedure TG2S3DMeshBuilder.Init;
begin
  Vertices.Clear;
  Faces.Clear;
  Materials.Clear;
  LastMaterial := -1;
end;

procedure TG2S3DMeshBuilder.Clear;
  var i: TG2IntS32;
begin
  for i := 0 to Vertices.Count - 1 do
  Dispose(PG2S3DMeshVertex(Vertices[i]));
  Vertices.Clear;
  for i := 0 to Faces.Count - 1 do
  Dispose(PG2S3DMeshFace(Faces[i]));
  Faces.Clear;
  for i := 0 to Materials.Count - 1 do
  Dispose(PG2S3DMeshMaterial(Materials[i]));
  Materials.Clear;
  LastMaterial := -1;
end;
//TG2S3DMeshBuilder END

//TG2S3DMesh BEGIN
function TG2S3DMesh.GetNode(const Index: TG2IntS32): PG2S3DMeshNode;
begin
  Result := @_Nodes[Index];
end;

function TG2S3DMesh.GetGeom(const Index: TG2IntS32): PG2S3DMeshGeom;
begin
  Result := @_Geoms[Index];
end;

function TG2S3DMesh.GetAnim(const Index: TG2IntS32): PG2S3DMeshAnim;
begin
  Result := @_Anims[Index];
end;

function TG2S3DMesh.GetMaterial(const Index: TG2IntS32): PG2S3DMeshMaterial;
begin
  Result := @_Materials[Index];
end;

class function TG2S3DMesh.SharedAsset(const SharedAssetName: String): TG2S3DMesh;
  var Res: TG2Res;
  var dm: TG2DataManager;
begin
  Res := TG2Res.List;
  while Res <> nil do
  begin
    if (Res is TG2S3DMesh)
    and (TG2S3DMesh(Res).AssetName = SharedAssetName)
    and (Res.RefCount > 0) then
    begin
      Result := TG2S3DMesh(Res);
      Exit;
    end;
    Res := Res.Next;
  end;
  dm := TG2DataManager.Create(SharedAssetName, dmAsset);
  Result := TG2S3DMesh.Create;
  Result.AssetName := SharedAssetName;
  Result.Load(dm);
  dm.Free;
end;

constructor TG2S3DMesh.Create;
begin
  inherited Create;
  _Loaded := False;
  _NodeCount := 0;
  _GeomCount := 0;
  _AnimCount := 0;
  _MaterialCount := 0;
  _Instances.Clear;
end;

destructor TG2S3DMesh.Destroy;
  var i, j: TG2IntS32;
begin
  if _Loaded then
  begin
    while _Instances.Count > 0 do
    TG2S3DMeshInst(_Instances[0]).Free;
    for i := 0 to _GeomCount - 1 do
    begin
      _Geoms[i].IB.Free;
      if _Geoms[i].Skinned then
      Dispose(PG2S3DGeomDataSkinned(_Geoms[i].Data))
      else
      begin
        PG2S3DGeomDataStatic(_Geoms[i].Data)^.VB.Free;
        Dispose(PG2S3DGeomDataStatic(_Geoms[i].Data));
      end;
    end;
    for i := 0 to _MaterialCount - 1 do
    for j := 0 to _Materials[i].ChannelCount - 1 do
    begin
      if Assigned(_Materials[i].Channels[j].MapDiffuse) then
      begin
        _Materials[i].Channels[j].MapDiffuse.RefDec;
        _Materials[i].Channels[j].MapDiffuse := nil;
      end;
      if Assigned(_Materials[i].Channels[j].MapDiffuse) then
      begin
        _Materials[i].Channels[j].MapLight.RefDec;
        _Materials[i].Channels[j].MapLight := nil;
      end;
    end;
    _Loaded := False;
  end;
  inherited Destroy;
end;

procedure TG2S3DMesh.Load(const dm: TG2DataManager);
  var i: TG2IntS32;
  var ml: TG2MeshLoader;
  var md: TG2MeshData;
begin
  for i := 0 to High(G2MeshLoaders) do
  if G2MeshLoaders[i].CanLoad(dm) then
  begin
    ml := G2MeshLoaders[i].Create;
    ml.Load(dm);
    ml.ExportMeshData(@md);
    ml.Free;
    Load(md);
    _Loaded := True;
  end;
end;

procedure TG2S3DMesh.Load(const MeshData: TG2MeshData);
  {$if defined(G2RM_FF)}
  type TVertex = packed record
    Position: TG2Vec3;
    Normal: TG2Vec3;
  end;
  {$elseif defined(G2RM_SM2)}
  type TVertex = packed record
    Position: TG2Vec3;
    Normal: TG2Vec3;
    Tangent: TG2Vec3;
    Binormal: TG2Vec3;
  end;
  {$endif}
  type PVertex = ^TVertex;
  var i, j, n: TG2IntS32;
  var MinV, MaxV, v: TG2Vec3;
  var Vertex: PVertex;
  var TexCoords: PG2Vec2;
  {$if defined(G2RM_SM2)}
  var BlendWeights: PG2Float;
  var BlendIndices: PG2Float;
  {$endif}
  var DataStatic: PG2S3DGeomDataStatic;
  var DataSkinned: PG2S3DGeomDataSkinned;
begin
  _NodeCount := MeshData.NodeCount;
  SetLength(_Nodes, _NodeCount);
  for i := 0 to _NodeCount - 1 do
  begin
    _Nodes[i].Name := MeshData.Nodes[i].Name;
    _Nodes[i].OwnerID := MeshData.Nodes[i].OwnerID;
    _Nodes[i].Transform := MeshData.Nodes[i].Transform;
    _Nodes[i].SubNodesID := nil;
  end;
  for i := 0 to _NodeCount - 1 do
  if _Nodes[i].OwnerID > -1 then
  begin
    SetLength(_Nodes[_Nodes[i].OwnerID].SubNodesID, Length(_Nodes[_Nodes[i].OwnerID].SubNodesID) + 1);
    _Nodes[_Nodes[i].OwnerID].SubNodesID[High(_Nodes[_Nodes[i].OwnerID].SubNodesID)] := i;
  end;
  _GeomCount := MeshData.GeomCount;
  SetLength(_Geoms, _GeomCount);
  for i := 0 to _GeomCount - 1 do
  begin
    _Geoms[i].NodeID := MeshData.Geoms[i].NodeID;
    _Geoms[i].VCount := MeshData.Geoms[i].VCount;
    _Geoms[i].FCount := MeshData.Geoms[i].FCount;
    _Geoms[i].GCount := MeshData.Geoms[i].MCount;
    _Geoms[i].TCount := MeshData.Geoms[i].TCount;
    _Geoms[i].Visible := True;
    _Geoms[i].Skinned := MeshData.Geoms[i].SkinID > -1;
    {$if defined(G2RM_FF)}
    SetLength(_Geoms[i].Decl, 2 + _Geoms[i].TCount);
    _Geoms[i].Decl[0].Element := vbPosition; _Geoms[i].Decl[0].Count := 3;
    _Geoms[i].Decl[1].Element := vbNormal; _Geoms[i].Decl[1].Count := 3;
    for j := 2 to 2 + _Geoms[i].TCount - 1 do
    begin
      _Geoms[i].Decl[j].Element := vbTexCoord;
      _Geoms[i].Decl[j].Count := 2;
    end;
    {$elseif defined(G2RM_SM2)}
    SetLength(_Geoms[i].Decl, 4 + _Geoms[i].TCount);
    _Geoms[i].Decl[0].Element := vbPosition; _Geoms[i].Decl[0].Count := 3;
    _Geoms[i].Decl[1].Element := vbNormal; _Geoms[i].Decl[1].Count := 3;
    _Geoms[i].Decl[2].Element := vbTangent; _Geoms[i].Decl[2].Count := 3;
    _Geoms[i].Decl[3].Element := vbBinormal; _Geoms[i].Decl[3].Count := 3;
    for j := 4 to 4 + _Geoms[i].TCount - 1 do
    begin
      _Geoms[i].Decl[j].Element := vbTexCoord;
      _Geoms[i].Decl[j].Count := 2;
    end;
    {$endif}
    if _Geoms[i].Skinned then
    begin
      New(DataSkinned);
      _Geoms[i].Data := DataSkinned;
      DataSkinned^.MaxWeights := MeshData.Skins[MeshData.Geoms[i].SkinID].MaxWeights;
      DataSkinned^.BoneCount := MeshData.Skins[MeshData.Geoms[i].SkinID].BoneCount;
      SetLength(DataSkinned^.Bones, DataSkinned^.BoneCount);
      for j := 0 to DataSkinned^.BoneCount - 1 do
      begin
        DataSkinned^.Bones[j].NodeID := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].NodeID;
        DataSkinned^.Bones[j].Bind := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].Bind;
        DataSkinned^.Bones[j].BBox := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].BBox;
        DataSkinned^.Bones[j].VCount := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].VCount;
      end;
      {$if defined(G2RM_FF)}
      SetLength(DataSkinned^.Vertices, _Geoms[i].VCount);
      for j := 0 to _Geoms[i].VCount - 1 do
      begin
        SetLength(DataSkinned^.Vertices[j].TexCoord, _Geoms[i].TCount);
        SetLength(DataSkinned^.Vertices[j].Bones, PG2S3DGeomDataSkinned(_Geoms[i].Data)^.MaxWeights);
        SetLength(DataSkinned^.Vertices[j].Weights, PG2S3DGeomDataSkinned(_Geoms[i].Data)^.MaxWeights);
        DataSkinned^.Vertices[j].Position := MeshData.Geoms[i].Vertices[j].Position;
        DataSkinned^.Vertices[j].Normal := MeshData.Geoms[i].Vertices[j].Position;
        for n := 0 to _Geoms[i].TCount - 1 do
        DataSkinned^.Vertices[j].TexCoord[n] := MeshData.Geoms[i].Vertices[j].TexCoords[n];
        DataSkinned^.Vertices[j].BoneWeightCount := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].WeightCount;
        for n := 0 to MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].WeightCount - 1 do
        begin
          DataSkinned^.Vertices[j].Bones[n] := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[n].BoneID;
          DataSkinned^.Vertices[j].Weights[n] := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[n].Weight;
        end;
        for n := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].WeightCount to PG2S3DGeomDataSkinned(_Geoms[i].Data)^.MaxWeights - 1 do
        begin
          DataSkinned^.Vertices[j].Bones[n] := 0;
          DataSkinned^.Vertices[j].Weights[n] := 0;
        end;
      end;
      {$elseif defined(G2RM_SM2)}
      n := Length(_Geoms[i].Decl);
      if DataSkinned^.MaxWeights = 1 then
      begin
        SetLength(_Geoms[i].Decl, Length(_Geoms[i].Decl) + 1);
        _Geoms[i].Decl[n].Element := vbVertexIndex; _Geoms[i].Decl[n].Count := 1;
      end
      else
      begin
        SetLength(_Geoms[i].Decl, Length(_Geoms[i].Decl) + 2 * DataSkinned^.MaxWeights);
        _Geoms[i].Decl[n].Element := vbVertexIndex; _Geoms[i].Decl[n].Count := DataSkinned^.MaxWeights;
        Inc(n);
        _Geoms[i].Decl[n].Element := vbVertexWeight; _Geoms[i].Decl[n].Count := DataSkinned^.MaxWeights;
      end;
      DataSkinned^.VB := TG2VertexBuffer.Create(_Geoms[i].Decl, _Geoms[i].VCount);
      DataSkinned^.VB.Lock;
      for j := 0 to _Geoms[i].VCount - 1 do
      begin
        Vertex := PVertex(DataSkinned^.VB.Data + TG2IntS32(DataSkinned^.VB.VertexSize) * j);
        TexCoords := PG2Vec2(Pointer(Vertex) + TG2IntS32(SizeOf(TVertex)));
        BlendIndices := PG2Float(Pointer(TexCoords) + _Geoms[i].TCount * 8);
        BlendWeights := PG2Float(Pointer(BlendIndices) + DataSkinned^.MaxWeights * 4);
        Vertex^.Position := MeshData.Geoms[i].Vertices[j].Position;
        Vertex^.Normal := MeshData.Geoms[i].Vertices[j].Normal;
        Vertex^.Tangent := MeshData.Geoms[i].Vertices[j].Tangent;
        Vertex^.Binormal := MeshData.Geoms[i].Vertices[j].Binormal;
        for n := 0 to _Geoms[i].TCount - 1 do
        begin
          TexCoords^ := MeshData.Geoms[i].Vertices[j].TexCoords[n];
          Inc(TexCoords);
        end;
        if DataSkinned^.MaxWeights = 1 then
        BlendIndices^ := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[0].BoneID
        else
        for n := 0 to DataSkinned^.MaxWeights - 1 do
        begin
          BlendIndices^ := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[n].BoneID;
          Inc(BlendIndices);
          BlendWeights^ := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[n].Weight;
          Inc(BlendWeights);
        end;
      end;
      DataSkinned^.VB.UnLock;
      {$endif}
    end
    else
    begin
      New(DataStatic);
      _Geoms[i].Data := DataStatic;
      DataStatic^.VB := TG2VertexBuffer.Create(_Geoms[i].Decl, _Geoms[i].VCount);
      DataStatic^.VB.Lock;
      MinV := MeshData.Geoms[i].Vertices[0].Position;
      MaxV := MinV;
      for j := 0 to _Geoms[i].VCount - 1 do
      begin
        Vertex := PVertex(DataStatic^.VB.Data + TG2IntS32(DataStatic^.VB.VertexSize) * j);
        TexCoords := PG2Vec2(DataStatic^.VB.Data + TG2IntS32(DataStatic^.VB.VertexSize) * j + TG2IntS32(SizeOf(TVertex)));
        Vertex^.Position := MeshData.Geoms[i].Vertices[j].Position;
        Vertex^.Normal := MeshData.Geoms[i].Vertices[j].Normal;
        {$if defined(G2RM_SM2)}
        Vertex^.Tangent := MeshData.Geoms[i].Vertices[j].Tangent;
        Vertex^.Binormal := MeshData.Geoms[i].Vertices[j].Binormal;
        {$endif}
        for n := 0 to _Geoms[i].TCount - 1 do
        begin
          TexCoords^ := MeshData.Geoms[i].Vertices[j].TexCoords[n];
          Inc(TexCoords);
        end;
        if MeshData.Geoms[i].Vertices[j].Position.x > MaxV.x then MaxV.x := MeshData.Geoms[i].Vertices[j].Position.x
        else if MeshData.Geoms[i].Vertices[j].Position.x < MinV.x then MinV.x := MeshData.Geoms[i].Vertices[j].Position.x;
        if MeshData.Geoms[i].Vertices[j].Position.y > MaxV.y then MaxV.y := MeshData.Geoms[i].Vertices[j].Position.y
        else if MeshData.Geoms[i].Vertices[j].Position.y < MinV.y then MinV.y := MeshData.Geoms[i].Vertices[j].Position.y;
        if MeshData.Geoms[i].Vertices[j].Position.z > MaxV.z then MaxV.z := MeshData.Geoms[i].Vertices[j].Position.z
        else if MeshData.Geoms[i].Vertices[j].Position.z < MinV.z then MinV.z := MeshData.Geoms[i].Vertices[j].Position.z;
      end;
      DataStatic^.VB.UnLock;
      DataStatic^.BBox.c := (MinV + MaxV) * 0.5;
      v := (MaxV - MinV) * 0.5;
      DataStatic^.BBox.vx.SetValue(v.x, 0, 0);
      DataStatic^.BBox.vy.SetValue(0, v.y, 0);
      DataStatic^.BBox.vz.SetValue(0, 0, v.z);
    end;
    _Geoms[i].IB := TG2IndexBuffer.Create(_Geoms[i].FCount * 3);
    _Geoms[i].IB.Lock;
    for j := 0 to _Geoms[i].FCount - 1 do
    begin
      PG2IntU16Arr(_Geoms[i].IB.Data)^[j * 3 + 0] := MeshData.Geoms[i].Faces[j][0];
      PG2IntU16Arr(_Geoms[i].IB.Data)^[j * 3 + 1] := MeshData.Geoms[i].Faces[j][1];
      PG2IntU16Arr(_Geoms[i].IB.Data)^[j * 3 + 2] := MeshData.Geoms[i].Faces[j][2];
    end;
    _Geoms[i].IB.UnLock;
    SetLength(_Geoms[i].Groups, _Geoms[i].GCount);
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
  SetLength(_Materials, _MaterialCount);
  for i := 0 to _MaterialCount - 1 do
  begin
    _Materials[i].ChannelCount := MeshData.Materials[i].ChannelCount;
    SetLength(_Materials[i].Channels, _Materials[i].ChannelCount);
    for j := 0 to _Materials[i].ChannelCount - 1 do
    begin
      _Materials[i].Channels[j].Name := MeshData.Materials[i].Channels[j].Name;
      _Materials[i].Channels[j].TwoSided := MeshData.Materials[i].Channels[j].TwoSided;
      {$if defined(G2Target_Android)}
      if Length(MeshData.Materials[i].Channels[j].DiffuseMap) > 0 then
      {$else}
      if G2FileExists(MeshData.Materials[i].Channels[j].DiffuseMap) then
      {$endif}
      begin
        _Materials[i].Channels[j].MapDiffuse := TG2Texture2D.SharedAsset(MeshData.Materials[i].Channels[j].DiffuseMap, {$if defined(G2Target_Android)}tuDefault{$else}tu3D{$endif});
        if Assigned(_Materials[i].Channels[j].MapDiffuse) then
        begin
          _Materials[i].Channels[j].MapDiffuse.RefInc;
        end;
      end
      else
      _Materials[i].Channels[j].MapDiffuse := nil;
      {$if defined(G2Target_Android)}
      if Length(MeshData.Materials[i].Channels[j].LightMap) > 0 then
      {$else}
      if G2FileExists(MeshData.Materials[i].Channels[j].LightMap) then
      {$endif}
      begin
        _Materials[i].Channels[j].MapLight := TG2Texture2D.SharedAsset(MeshData.Materials[i].Channels[j].LightMap, tuDefault);
        if Assigned(_Materials[i].Channels[j].MapLight) then
        begin
          _Materials[i].Channels[j].MapLight.RefInc;
        end;
      end
      else
      _Materials[i].Channels[j].MapLight := nil;
    end;
  end;
  _AnimCount := MeshData.AnimCount;
  SetLength(_Anims, _AnimCount);
  for i := 0 to _AnimCount - 1 do
  begin
    _Anims[i].Name := MeshData.Anims[i].Name;
    _Anims[i].FrameCount := MeshData.Anims[i].FrameCount;
    _Anims[i].FrameRate := MeshData.Anims[i].FrameRate;
    _Anims[i].NodeCount := MeshData.Anims[i].NodeCount;
    SetLength(_Anims[i].Nodes, _Anims[i].NodeCount);
    for j := 0 to _Anims[i].NodeCount - 1 do
    begin
      _Anims[i].Nodes[j].NodeID := MeshData.Anims[i].Nodes[j].NodeID;
      SetLength(_Anims[i].Nodes[j].Frames, _Anims[i].FrameCount);
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

function TG2S3DMesh.AnimIndex(const Name: AnsiString): TG2IntS32;
  var i: TG2IntS32;
begin
  for i := 0 to _AnimCount - 1 do
  if _Anims[i].Name = Name then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;
//TG2S3DMesh END

//TG2S3DMeshInst BEGIN
procedure TG2S3DMeshInst.SetMesh(const Value: TG2S3DMesh);
  var i, r: TG2IntS32;
begin
  if Value = _Mesh then Exit;
  _Mesh := Value;
  for i := 0 to High(_Skins) do
  if _Skins[i] <> nil then
  begin
    {$if defined(G2RM_FF)}
    _Skins[i]^.VB.Free;
    {$endif}
    Dispose(_Skins[i]);
    _Skins[i] := nil;
  end;
  if _Mesh <> nil then
  begin
    SetLength(Materials, _Mesh.MaterialCount);
    for i := 0 to _Mesh.MaterialCount - 1 do
    Materials[i] := _Mesh.Materials[i];
    SetLength(Transforms, _Mesh.NodeCount);
    r := 0;
    SetLength(_RootNodes, _Mesh.NodeCount);
    for i := 0 to _Mesh.NodeCount - 1 do
    begin
      if _Mesh.Nodes[i]^.OwnerID = -1 then
      begin
        _RootNodes[i] := i;
        Inc(r);
      end;
      Transforms[i].TransformDef := _Mesh.Nodes[i]^.Transform;
      Transforms[i].TransformCur := Transforms[i].TransformDef;
      Transforms[i].TransformCom := G2MatIdentity;
    end;
    SetLength(_Skins, _Mesh.GeomCount);
    for i := 0 to _Mesh.GeomCount - 1 do
    if _Mesh.Geoms[i]^.Skinned then
    begin
      New(_Skins[i]);
      SetLength(_Skins[i]^.Transforms, PG2S3DGeomDataSkinned(_Mesh.Geoms[i]^.Data)^.BoneCount);
      {$if defined(G2RM_FF)}
      _Skins[i]^.VB := TG2VertexBuffer.Create(_Mesh.Geoms[i]^.Decl, _Mesh.Geoms[i]^.VCount);
      {$endif}
    end;
    if r < Length(_RootNodes) then
    SetLength(_RootNodes, r);
    ComputeTransforms;
  end;
end;

function TG2S3DMeshInst.GetBBox: TG2Box;
  var i: TG2IntS32;
  var b: TG2AABox;
begin
  if _Mesh.GeomCount < 1 then
  begin
    {$Warnings off}
    Result.SetValue(G2Vec3(0, 0, 0), G2Vec3(0, 0, 0), G2Vec3(0, 0, 0), G2Vec3(0, 0, 0));
    {$Warnings on}
    Exit;
  end;
  b := GetGeomBBox(0);
  for i := 1 to _Mesh.GeomCount - 1 do
  b.Merge(GetGeomBBox(i));
  Result := b;
end;

function TG2S3DMeshInst.GetGeomBBox(const Index: TG2IntS32): TG2Box;
  var DataSkinned: PG2S3DGeomDataSkinned;
  var i, j: TG2IntS32;
  var b: TG2AABox;
begin
  if _Mesh.Geoms[Index]^.Skinned then
  begin
    DataSkinned := PG2S3DGeomDataSkinned(_Mesh.Geoms[Index]^.Data);
    for i := 0 to DataSkinned^.BoneCount - 1 do
    if DataSkinned^.Bones[i].VCount > 0 then
    begin
      b := DataSkinned^.Bones[i].BBox.Transform(_Skins[Index]^.Transforms[i]);
      Break;
    end;
    for j := i + 1 to DataSkinned^.BoneCount - 1 do
    if DataSkinned^.Bones[j].VCount > 0 then
    b.Merge(DataSkinned^.Bones[j].BBox.Transform(_Skins[Index]^.Transforms[j]));
    Result := b;
  end
  else
  Result := PG2S3DGeomDataStatic(_Mesh.Geoms[Index]^.Data)^.BBox.Transform(Transforms[_Mesh.Geoms[Index]^.NodeID].TransformCom);
end;

function TG2S3DMeshInst.GetSkin(const Index: TG2IntS32): PG2S3DMeshInstSkin;
begin
  Result := _Skins[Index];
end;

{$Notes off}
procedure TG2S3DMeshInst.ComputeSkinTransforms;
  type TVertex = packed record
    Position: TG2Vec3;
    Normal: TG2Vec3;
  end;
  type PVertex = ^TVertex;
  var i, j, n: TG2IntS32;
  var DataSkinned: PG2S3DGeomDataSkinned;
  var vp, vn: TG2Vec3;
  var Vertex: PVertex;
  var TexCoords: PG2Vec2;
begin
  for i := 0 to _Mesh.GeomCount - 1 do
  if _Mesh.Geoms[i]^.Skinned then
  begin
    DataSkinned := PG2S3DGeomDataSkinned(_Mesh.Geoms[i]^.Data);
    for j := 0 to DataSkinned^.BoneCount - 1 do
    _Skins[i]^.Transforms[j] := DataSkinned^.Bones[j].Bind * Transforms[DataSkinned^.Bones[j].NodeID].TransformCom;
    {$if defined(G2RM_FF)}
    _Skins[i]^.VB.Lock;
    for j := 0 to _Mesh.Geoms[i]^.VCount - 1 do
    begin
      Vertex := PVertex(_Skins[i]^.VB.Data + TG2IntS32(_Skins[i]^.VB.VertexSize) * j);
      TexCoords := PG2Vec2(Pointer(Vertex) + SizeOf(TVertex));
      vp.SetValue(0, 0, 0);
      vn.SetValue(0, 0, 0);
      for n := 0 to DataSkinned^.Vertices[j].BoneWeightCount - 1 do
      begin
        vp := vp + DataSkinned^.Vertices[j].Position.Transform4x3(
          _Skins[i]^.Transforms[DataSkinned^.Vertices[j].Bones[n]]
        ) * DataSkinned^.Vertices[j].Weights[n];
        vn := vn + DataSkinned^.Vertices[j].Normal.Transform3x3(
          _Skins[i]^.Transforms[DataSkinned^.Vertices[j].Bones[n]]
        ) * DataSkinned^.Vertices[j].Weights[n];
      end;
      Vertex^.Position := vp;
      Vertex^.Normal := vn;
      for n := 0 to _Mesh.Geoms[i]^.TCount - 1 do
      begin
        TexCoords^ := DataSkinned^.Vertices[j].TexCoord[n];
        Inc(TexCoords);
      end;
    end;
    _Skins[i]^.VB.UnLock;
    {$endif}
  end;
end;
{$Notes on}

function TG2S3DMeshInst.GetAABox: TG2AABox;
begin
  Result := GetBBox;
end;

constructor TG2S3DMeshInst.Create(const Scene: TG2Scene3D);
begin
  inherited Create(Scene);
  _Mesh := nil;
  _AutoComputeTransforms := True;
  _Scene.MeshInst.Add(Self);
end;

destructor TG2S3DMeshInst.Destroy;
begin
  if _Mesh <> nil then
  _Mesh._Instances.Remove(Self);
  Mesh := nil;
  _Scene.MeshInst.Remove(Self);
  inherited Destroy;
end;

procedure TG2S3DMeshInst.FrameSetFast(const AnimName: AnsiString; const Frame: TG2IntS32);
  var AnimIndex, i, f0: TG2IntS32;
  var ms, mr, mt: TG2Mat;
begin
  AnimIndex := _Mesh.AnimIndex(AnimName);
  if AnimIndex > -1 then
  begin
    if Frame < 0 then
    f0 := _Mesh.Anims[AnimIndex]^.FrameCount - (Abs(Frame) mod _Mesh.Anims[AnimIndex]^.FrameCount)
    else
    f0 := Frame mod _Mesh.Anims[AnimIndex]^.FrameCount;
    for i := 0 to _Mesh.Anims[AnimIndex]^.NodeCount - 1 do
    begin
      ms := G2MatScaling(_Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Scaling);
      mr := G2MatRotation(_Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Rotation);
      mt := G2MatTranslation(_Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Translation);
      Transforms[_Mesh.Anims[AnimIndex]^.Nodes[i].NodeID].TransformCur := ms * mr * mt;
    end;
    if _AutoComputeTransforms then ComputeTransforms;
  end;
end;

procedure TG2S3DMeshInst.FrameSet(const AnimName: AnsiString; const Frame: TG2Float);
  var AnimIndex, i, f0, f1: TG2IntS32;
  var f: TG2Float;
  var s0: TG2Vec3;
  var r0: TG2Quat;
  var t0: TG2Vec3;
  var ms, mr, mt: TG2Mat;
begin
  AnimIndex := _Mesh.AnimIndex(AnimName);
  if AnimIndex > -1 then
  begin
    if Frame < 0 then
    f := _Mesh.Anims[AnimIndex]^.FrameCount - (Trunc(Abs(Frame)) mod _Mesh.Anims[AnimIndex]^.FrameCount) + Frac(Frame)
    else
    f := Frame;
    f0 := Trunc(f) mod _Mesh.Anims[AnimIndex]^.FrameCount;
    f1 := (f0 + 1) mod _Mesh.Anims[AnimIndex]^.FrameCount;
    f := Frac(f);
    for i := 0 to _Mesh.Anims[AnimIndex]^.NodeCount - 1 do
    begin
      s0 := G2LerpVec3(
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Scaling,
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f1].Scaling,
        f
      );
      r0 := G2QuatSlerp(
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Rotation,
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f1].Rotation,
        f
      );
      t0 := G2LerpVec3(
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Translation,
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f1].Translation,
        f
      );
      ms := G2MatScaling(s0);
      mr := G2MatRotation(r0);
      mt := G2MatTranslation(t0);
      Transforms[_Mesh.Anims[AnimIndex]^.Nodes[i].NodeID].TransformCur := ms * mr * mt;
    end;
    if _AutoComputeTransforms then ComputeTransforms;
  end;
end;

procedure TG2S3DMeshInst.ComputeTransforms;
  procedure ComputeNode(const NodeID: TG2IntS32);
    var i: TG2IntS32;
  begin
    if _Mesh.Nodes[NodeID]^.OwnerID > -1 then
    Transforms[NodeID].TransformCom := Transforms[NodeID].TransformCur * Transforms[_Mesh.Nodes[NodeID]^.OwnerID].TransformCom
    else
    Transforms[NodeID].TransformCom := Transforms[NodeID].TransformCur;
    for i := 0 to High(_Mesh.Nodes[NodeID]^.SubNodesID) do
    ComputeNode(_Mesh.Nodes[NodeID]^.SubNodesID[i]);
  end;
  var i: TG2IntS32;
begin
  for i := 0 to High(_RootNodes) do
  ComputeNode(_RootNodes[i]);
  ComputeSkinTransforms;
end;
//TG2S3DMeshInst END

//TG2S3DParticleRender BEGIN
constructor TG2S3DParticleRender.Create(const Scene: TG2Scene3D);
begin
  inherited Create;
  _Scene := Scene;
end;

destructor TG2S3DParticleRender.Destroy;
begin
  inherited Destroy;
end;
//TG2S3DParticleRender END

//TG2S3DParticleRenderFlat BEGIN
{$if defined(G2RM_FF)}
procedure TG2S3DParticleRenderFlat.RenderFlush;
begin
  {$if defined(G2Gfx_D3D9)}
  g2.Gfx.Filter := _CurFilter;
  g2.Gfx.BlendMode := _CurBlendMode;
  TG2GfxD3D9(g2.Gfx).Device.SetTexture(0, _CurTexture.GetTexture);
  TG2GfxD3D9(g2.Gfx).Device.DrawIndexedPrimitive(D3DPT_TRIANGLELIST, 0, 0, _CurQuad * 4, 0, _CurQuad * 2);
  {$elseif defined(G2Gfx_OGL)}
  TG2GfxOGL(g2.Gfx).ActiveTexture := 0;
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, _CurTexture.GetTexture);
  if _CurTexture.Usage = tu3D then
  begin
    case _CurFilter of
      tfPoint:
      begin
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
      end;
      tfLinear:
      begin
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      end;
    end;
  end
  else
  begin
    case _CurFilter of
      tfPoint:
      begin
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
      end;
      tfLinear:
      begin
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      end;
    end;
  end;
  g2.Gfx.BlendMode := _CurBlendMode;
  glDrawElements(
    GL_TRIANGLES,
    _CurQuad * 6,
    GL_UNSIGNED_SHORT,
    GLvoid(0)
  );
  {$elseif defined(G2Gfx_GLES)}
  TG2GfxGLES(g2.Gfx).ActiveTexture := 0;
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, _CurTexture.GetTexture);
  g2.Gfx.Filter := _CurFilter;
  g2.Gfx.BlendMode := _CurBlendMode;
  glDrawElements(
    GL_TRIANGLES,
    _CurQuad * 6,
    GL_UNSIGNED_SHORT,
    GLvoid(0)
  );
  {$endif}
  _CurQuad := 0;
  _VB[_CurVB].Unbind;
  _CurVB := (_CurVB + 1) mod _VBCount;
  _VB[_CurVB].Bind;
end;

constructor TG2S3DParticleRenderFlat.Create(const Scene: TG2Scene3D);
  var Decl: TG2VBDecl;
  var i, n0, n1: TG2IntS32;
begin
  inherited Create(Scene);
  _MaxQuads := 64;
  _VBCount := 16;
  SetLength(_VB, _VBCount);
  _CurVB := 0;
  SetLength(Decl, 3);
  Decl[0].Element := vbPosition; Decl[0].Count := 3;
  Decl[1].Element := vbDiffuse; Decl[1].Count := 4;
  Decl[2].Element := vbTexCoord; Decl[2].Count := 2;
  for i := 0 to _VBCount - 1 do
  _VB[i] := TG2VertexBuffer.Create(Decl, 4 * _MaxQuads);
  _IB := TG2IndexBuffer.Create(6 * _MaxQuads);
  _IB.Lock;
  for i := 0 to _MaxQuads - 1 do
  begin
    n0 := i * 6;
    n1 := i * 4;
    PG2IntU16Arr(_IB.Data)^[n0 + 0] := n1 + 0;
    PG2IntU16Arr(_IB.Data)^[n0 + 1] := n1 + 1;
    PG2IntU16Arr(_IB.Data)^[n0 + 2] := n1 + 2;
    PG2IntU16Arr(_IB.Data)^[n0 + 3] := n1 + 2;
    PG2IntU16Arr(_IB.Data)^[n0 + 4] := n1 + 1;
    PG2IntU16Arr(_IB.Data)^[n0 + 5] := n1 + 3;
  end;
  _IB.UnLock;
end;

destructor TG2S3DParticleRenderFlat.Destroy;
begin
  inherited Destroy;
end;

procedure TG2S3DParticleRenderFlat.RenderBegin;
  var m: TG2Mat;
begin
  m := G2MatIdentity;
  {$if defined(G2Gfx_D3D9)}
  TG2GfxD3D9(g2.Gfx).Device.SetTransform(D3DTS_WORLD, m);
  {$elseif defined(G2Gfx_OGL) or defined(G2Gfx_GLES)}
  glMatrixMode(GL_MODELVIEW);
  glLoadMatrixf(@m);
  {$endif}
  g2.Gfx.DepthEnable := True;
  g2.Gfx.DepthWriteEnable := False;
  _CurQuad := 0;
  _CurTexture := nil;
  _CurFilter := tfNone;
  _CurBlendMode := bmInvalid;
  _VB[_CurVB].Bind;
  _IB.Bind;
  _VB[_CurVB].Lock;
end;

procedure TG2S3DParticleRenderFlat.RenderEnd;
begin
  _VB[_CurVB].UnLock;
  if _CurQuad > 0 then
  RenderFlush;
  _IB.Unbind;
  _VB[_CurVB].Unbind;
  g2.Gfx.DepthEnable := False;
  g2.Gfx.DepthWriteEnable := True;
end;

procedure TG2S3DParticleRenderFlat.RenderParticle(const Particle: TG2S3DParticle);
  type TVertex = packed record
    Position: TG2Vec3;
    Color: TG2Vec4;
    TexCoords: TG2Vec2;
  end;
  type TVertexArr = array[Word] of TVertex;
  type PVertexArr = ^TVertexArr;
  var p: TG2S3DParticleFlat;
  var q: TG2IntS32;
  var vc: TG2Vec4;
  var vx, vy: TG2Vec3;
begin
  p := TG2S3DParticleFlat(Particle);
  if (p.Texture <> _CurTexture)
  or (p.Filter <> _CurFilter)
  or (p.BlendMode <> _CurBlendMode)
  or (_CurQuad >= _MaxQuads - 1)
  then
  begin
    if (_CurQuad > 0) then
    begin
      _VB[_CurVB].UnLock;
      RenderFlush;
      _VB[_CurVB].Lock;
    end;
    _CurTexture := p.Texture;
    _CurFilter := p.Filter;
    _CurBlendMode := p.BlendMode;
  end;
  q := _CurQuad * 4;
  {$if defined(G2Gfx_D3D9)}
  vc.SetValue(p.Color.b * G2Rcp255, p.Color.g * G2Rcp255, p.Color.r * G2Rcp255, p.Color.a * G2Rcp255);
  {$else}
  vc.SetValue(p.Color.r * G2Rcp255, p.Color.g * G2Rcp255, p.Color.b * G2Rcp255, p.Color.a * G2Rcp255);
  {$endif}
  vx := p.VecX * 0.5; vy := p.VecY * 0.5;
  PVertexArr(_VB[_CurVB].Data)^[q].Position := p.Pos - vx + vy;
  PVertexArr(_VB[_CurVB].Data)^[q].Color := vc;
  PVertexArr(_VB[_CurVB].Data)^[q].TexCoords.SetValue(0, 0);
  Inc(q);
  PVertexArr(_VB[_CurVB].Data)^[q].Position := p.Pos + vx + vy;
  PVertexArr(_VB[_CurVB].Data)^[q].Color := vc;
  PVertexArr(_VB[_CurVB].Data)^[q].TexCoords.SetValue(1, 0);
  Inc(q);
  PVertexArr(_VB[_CurVB].Data)^[q].Position := p.Pos - vx - vy;
  PVertexArr(_VB[_CurVB].Data)^[q].Color := vc;
  PVertexArr(_VB[_CurVB].Data)^[q].TexCoords.SetValue(0, 1);
  Inc(q);
  PVertexArr(_VB[_CurVB].Data)^[q].Position := p.Pos + vx - vy;
  PVertexArr(_VB[_CurVB].Data)^[q].Color := vc;
  PVertexArr(_VB[_CurVB].Data)^[q].TexCoords.SetValue(1, 1);
  Inc(_CurQuad);
end;
{$elseif defined(G2RM_SM2)}
procedure TG2S3DParticleRenderFlat.RenderFlush;
begin
  if _CurQuad = 0 then Exit;
  {$if defined(G2Gfx_D3D9)}
  TG2GfxD3D9(g2.Gfx).Device.DrawIndexedPrimitive(D3DPT_TRIANGLELIST, 0, 0, _CurQuad * 4, 0, _CurQuad * 2);
  {$elseif defined(G2Gfx_OGL)}
  glDrawElements(GL_TRIANGLES, _CurQuad * 6, GL_UNSIGNED_SHORT, GLvoid(0));
  {$endif}
  _CurQuad := 0;
end;

constructor TG2S3DParticleRenderFlat.Create(const Scene: TG2Scene3D);
  type TVertex = packed record
    Position: TG2Vec3;
    TexCoord: TG2Vec2;
    TransformIndex: TG2Float;
  end;
  type TVertexArr = array[Word] of TVertex;
  type PVertexArr = ^TVertexArr;
  var Decl: TG2VBDecl;
  var i: TG2IntS32;
begin
  inherited Create(Scene);
  {$if defined(G2Gfx_D3D9)}
  _MaxQuads := 60;
  {$elseif defined(G2Gfx_OGL)}
  _MaxQuads := 45;
  {$endif}
  _ShaderGroup := g2.Gfx.RequestShader('StandardShaders');
  SetLength(Decl, 3);
  Decl[0].Element := vbPosition; Decl[0].Count := 3;
  Decl[1].Element := vbTexCoord; Decl[1].Count := 2;
  Decl[2].Element := vbVertexIndex; Decl[2].Count := 1;
  _VB := TG2VertexBuffer.Create(Decl, _MaxQuads * 4);
  _VB.Lock;
  for i := 0 to _MaxQuads - 1 do
  begin
    PVertexArr(_VB.Data)^[i * 4 + 0].Position := G2Vec3(-0.5, 0.5, 0);
    PVertexArr(_VB.Data)^[i * 4 + 1].Position := G2Vec3(0.5, 0.5, 0);
    PVertexArr(_VB.Data)^[i * 4 + 2].Position := G2Vec3(-0.5, -0.5, 0);
    PVertexArr(_VB.Data)^[i * 4 + 3].Position := G2Vec3(0.5, -0.5, 0);
    PVertexArr(_VB.Data)^[i * 4 + 0].TexCoord := G2Vec2(0, 0);
    PVertexArr(_VB.Data)^[i * 4 + 1].TexCoord := G2Vec2(1, 0);
    PVertexArr(_VB.Data)^[i * 4 + 2].TexCoord := G2Vec2(0, 1);
    PVertexArr(_VB.Data)^[i * 4 + 3].TexCoord := G2Vec2(1, 1);
    PVertexArr(_VB.Data)^[i * 4 + 0].TransformIndex := i;
    PVertexArr(_VB.Data)^[i * 4 + 1].TransformIndex := i;
    PVertexArr(_VB.Data)^[i * 4 + 2].TransformIndex := i;
    PVertexArr(_VB.Data)^[i * 4 + 3].TransformIndex := i;
  end;
  _VB.UnLock;
  _IB := TG2IndexBuffer.Create(_MaxQuads * 6);
  _IB.Lock;
  for i := 0 to _MaxQuads - 1 do
  begin
    PG2IntU16Arr(_IB.Data)^[i * 6 + 0] := i * 4 + 0;
    PG2IntU16Arr(_IB.Data)^[i * 6 + 1] := i * 4 + 1;
    PG2IntU16Arr(_IB.Data)^[i * 6 + 2] := i * 4 + 2;
    PG2IntU16Arr(_IB.Data)^[i * 6 + 3] := i * 4 + 2;
    PG2IntU16Arr(_IB.Data)^[i * 6 + 4] := i * 4 + 1;
    PG2IntU16Arr(_IB.Data)^[i * 6 + 5] := i * 4 + 3;
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
  {$if defined(G2Gfx_D3D9)}

  {$elseif defined(G2Gfx_OGL)}

  {$endif}
  _ShaderGroup.Method := 'SceneParticles';
  WVP := _Scene.V * _Scene.P;
  _ShaderGroup.UniformMatrix4x4('WVP', WVP);
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
      _ShaderGroup.Sampler('Tex0', _CurTexture);
    end;
    {$if defined(G2Gfx_D3D9)}
    if (p.Filter <> _CurFilter) then
    {$endif}
    begin
      _CurFilter := p.Filter;
      {$if defined(G2Gfx_D3D9)}
      g2.Gfx.Filter := _CurFilter;
      {$elseif defined(G2Gfx_OGL)}
      if _CurTexture.Usage = tu3D then
      begin
        case _CurFilter of
          tfPoint:
          begin
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
          end;
          tfLinear:
          begin
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
          end;
        end;
      end
      else
      begin
        case _CurFilter of
          tfPoint:
          begin
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
          end;
          tfLinear:
          begin
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
          end;
        end;
      end;
      {$endif}
    end;
    if (p.BlendMode <> _CurBlendMode) then
    begin
      _CurBlendMode := p.BlendMode;
      g2.Gfx.BlendMode := _CurBlendMode;
    end;
  end;
  m := G2Mat(p.VecX, p.VecY, G2Vec3(0, 0, 0), p.Pos);
  m.e03 := p.Color.r * G2Rcp255;
  m.e13 := p.Color.g * G2Rcp255;
  m.e23 := p.Color.b * G2Rcp255;
  m.e33 := p.Color.a * G2Rcp255;
  _ShaderGroup.UniformMatrix4x4Arr('TransformPallete', @m, _CurQuad, 1);
  //_ShaderGroup.UniformMatrix4x4Arr('TransformPallete', @m, _CurQuad, 1);
  Inc(_CurQuad);
end;
{$endif}
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
  G2SinCos(Rotation, s{%H-}, c{%H-});
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
  _Color := $ffffffff;
  _Filter := tfLinear;
  _BlendMode := bmNormal;
  DepthSorted := True;
end;

destructor TG2S3DParticleFlat.Destroy;
begin
  inherited Destroy;
end;
//TG2S3DParticleFlat END

//TG2Scene3D BEGIN
procedure TG2Scene3D.OcTreeBuild(const MinV, MaxV: TG2Vec3; const Depth: TG2IntS32);
begin
  if _OcTreeRoot <> nil then OcTreeBreak;
end;

procedure TG2Scene3D.OcTreeBreak;
begin

end;

function TG2Scene3D.GetStatParticleGroupCount: TG2IntS32;
begin
  Result := _ParticleGroups.Count;
end;

function TG2Scene3D.GetStatParticleCount: TG2IntS32;
begin
  Result := _Particles.Count;
end;

{$if defined(G2Gfx_D3D9)}
{$if defined(G2RM_FF)}
procedure TG2Scene3D.RenderD3D9;
  var i, g, m, CurStage: TG2IntS32;
  var W: TG2Mat;
  var Mesh: TG2S3DMesh;
  var Inst: TG2S3DMeshInst;
  var Geom: PG2S3DMeshGeom;
  var Material: PG2S3DMeshMaterial;
  var PrevDepthEnable: Boolean;
  var VB: TG2VertexBuffer;
begin
  _Frustum.Update;
  PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := True;
  _Gfx.CullMode := g2cm_ccw;
  _Gfx.Device.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(1, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(1, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(1, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(2, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(2, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(2, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetTransform(D3DTS_VIEW, V);
  _Gfx.Device.SetTransform(D3DTS_PROJECTION, P);
  for i := 0 to _MeshInst.Count - 1 do
  begin
    Inst := TG2S3DMeshInst(_MeshInst[i]);
    Mesh := Inst.Mesh;
    if _Frustum.CheckBox(Inst.BBox) <> fcOutside then
    for g := 0 to Mesh.GeomCount - 1 do
    begin
      Geom := Mesh.Geoms[g];
      if Geom^.Skinned then
      begin
        VB := Inst.Skins[g]^.VB;
        W := Inst.Transform;
      end
      else
      begin
        VB := PG2S3DGeomDataStatic(Geom^.Data)^.VB;
        W := Inst.Transforms[Geom^.NodeID].TransformCom * Inst.Transform;
      end;
      _Gfx.Device.SetTransform(D3DTS_WORLD, W);
      VB.Bind;
      Geom^.IB.Bind;
      for m := 0 to Geom^.GCount - 1 do
      begin
        Material := Inst.Materials[Geom^.Groups[m].Material];
        if Material^.ChannelCount > 0 then
        begin
          if Material^.Channels[0].MapLight <> nil then
          begin
            _Gfx.Device.SetTexture(0, Material^.Channels[0].MapLight.GetTexture);
            _Gfx.Device.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
            _Gfx.Device.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_DIFFUSE);
            _Gfx.Device.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_TEXTURE);
            _Gfx.Device.SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_ADD);
            _Gfx.Device.SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_CURRENT);
            _Gfx.Device.SetTextureStageState(1, D3DTSS_COLORARG2, D3DTA_CONSTANT);
            _Gfx.Device.SetTextureStageState(1, D3DTSS_CONSTANT, _Ambient);
            _Gfx.Device.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
            _Gfx.Device.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
            _Gfx.Device.SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 1);
            _Gfx.Device.SetTextureStageState(2, D3DTSS_TEXCOORDINDEX, 0);
            CurStage := 2;
            _Gfx.Device.SetTextureStageState(3, D3DTSS_COLOROP, D3DTOP_DISABLE);
          end
          else
          begin
            CurStage := 0;
            _Gfx.Device.SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0);
            _Gfx.Device.SetTextureStageState(2, D3DTSS_TEXCOORDINDEX, 2);
            _Gfx.Device.SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
          end;
          if Material^.Channels[0].MapDiffuse <> nil then
          begin
            _Gfx.Device.SetTexture(CurStage, Material^.Channels[0].MapDiffuse.GetTexture);
            _Gfx.Device.SetTextureStageState(CurStage, D3DTSS_COLOROP, D3DTOP_MODULATE);
            if CurStage = 0 then
            _Gfx.Device.SetTextureStageState(CurStage, D3DTSS_COLORARG1, D3DTA_DIFFUSE)
            else
            _Gfx.Device.SetTextureStageState(CurStage, D3DTSS_COLORARG1, D3DTA_CURRENT);
            _Gfx.Device.SetTextureStageState(CurStage, D3DTSS_COLORARG2, D3DTA_TEXTURE);
            _Gfx.Device.SetSamplerState(CurStage, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
            _Gfx.Device.SetSamplerState(CurStage, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
          end;
        end;
        _Gfx.Device.DrawIndexedPrimitive(
          D3DPT_TRIANGLELIST,
          0,
          Geom^.Groups[m].VertexStart, Geom^.Groups[m].VertexCount,
          Geom^.Groups[m].FaceStart * 3, Geom^.Groups[m].FaceCount
        );
      end;
      Geom^.IB.Unbind;
      VB.Unbind;
    end;
  end;
  _Gfx.Device.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
  _Gfx.Device.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_DIFFUSE);
  _Gfx.Device.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_TEXTURE);
  _Gfx.Device.SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0);
  _Gfx.Device.SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
  _Gfx.DepthEnable := PrevDepthEnable;
end;
{$elseif defined(G2RM_SM2)}
procedure TG2Scene3D.RenderD3D9;
  var i, g, m: TG2IntS32;
  var PrevDepthEnable: Boolean;
  var W, VP, WVP: TG2Mat;
  var Mesh: TG2S3DMesh;
  var Inst: TG2S3DMeshInst;
  var Geom: PG2S3DMeshGeom;
  var Material: PG2S3DMeshMaterial;
  var VB: TG2VertexBuffer;
  var Method: AnsiString;
  var Tex: array[0..1] of TG2TextureBase;
begin
  _Frustum.Update;
  PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := True;
  _Gfx.CullMode := g2cm_ccw;
  _Gfx.Device.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(1, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(1, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
  _Gfx.Device.SetSamplerState(1, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);
  VP := V * P;
  Tex[0] := nil;
  Tex[1] := nil;
  for i := 0 to _MeshInst.Count - 1 do
  begin
    Inst := TG2S3DMeshInst(_MeshInst[i]);
    Mesh := Inst.Mesh;
    if _Frustum.CheckBox(Inst.BBox) <> fcOutside then
    for g := 0 to Mesh.GeomCount - 1 do
    begin
      Geom := Mesh.Geoms[g];
      if Geom^.Skinned then
      begin
        VB := PG2S3DGeomDataSkinned(Geom^.Data)^.VB;
        W := Inst.Transform;
        Method := 'SceneB' + IntToStr(PG2S3DGeomDataSkinned(Geom^.Data)^.MaxWeights);
      end
      else
      begin
        VB := PG2S3DGeomDataStatic(Geom^.Data)^.VB;
        W := Inst.Transforms[Geom^.NodeID].TransformCom * Inst.Transform;
        Method := 'SceneB0';
      end;
      WVP := W * VP;
      VB.Bind;
      Geom^.IB.Bind;
      for m := 0 to Geom^.GCount - 1 do
      begin
        Material := Inst.Materials[Geom^.Groups[m].Material];
        if Material^.ChannelCount > 0 then
        begin
          if Material^.Channels[0].MapLight <> nil then
          begin
            _ShaderGroup.Method := Method + 'L';
            if Tex[1] <> Material^.Channels[0].MapLight then
            begin
              Tex[1] := Material^.Channels[0].MapLight;
              _ShaderGroup.Sampler('Tex1', Tex[1]);
            end;
          end
          else
          begin
            _ShaderGroup.Method := Method;
          end;
          if Material^.Channels[0].MapDiffuse <> nil then
          begin
            if Tex[0] <> Material^.Channels[0].MapDiffuse then
            begin
              Tex[0] := Material^.Channels[0].MapDiffuse;
              _ShaderGroup.Sampler('Tex0', Tex[0]);
            end;
          end;
        end;
        if Geom^.Skinned then
        _ShaderGroup.UniformMatrix4x3Arr('SkinPallete', @Inst.Skins[g]^.Transforms[0], 0, PG2S3DGeomDataSkinned(Geom^.Data)^.BoneCount);
        _ShaderGroup.UniformMatrix4x4('WVP', WVP);
        _ShaderGroup.UniformFloat4('LightAmbient', _Ambient);
        _Gfx.Device.DrawIndexedPrimitive(
          D3DPT_TRIANGLELIST,
          0,
          Geom^.Groups[m].VertexStart, Geom^.Groups[m].VertexCount,
          Geom^.Groups[m].FaceStart * 3, Geom^.Groups[m].FaceCount
        );
      end;
      Geom^.IB.Unbind;
      VB.Unbind;
    end;
  end;
  _Gfx.DepthEnable := PrevDepthEnable;
end;
{$endif}
{$elseif defined(G2Gfx_OGL)}
{$if defined(G2RM_FF)}
procedure TG2Scene3D.RenderOGL;
  var i, g, m: TG2IntS32;
  var f: TG2Float;
  var CurStage: TG2IntU8;
  var W, VP: TG2Mat;
  var Mesh: TG2S3DMesh;
  var Inst: TG2S3DMeshInst;
  var Geom: PG2S3DMeshGeom;
  var Material: PG2S3DMeshMaterial;
  var PrevDepthEnable: Boolean;
  var VB: TG2VertexBuffer;
  var EnvColor: TG2Vec4;
begin
  _Frustum.Update;
  PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := True;
  _Gfx.CullMode := g2cm_ccw;
  VP := V * P;
  glMatrixMode(GL_PROJECTION);
  glLoadMatrixf(@VP);
  glMatrixMode(GL_MODELVIEW);
  for i := 0 to _MeshInst.Count - 1 do
  begin
    Inst := TG2S3DMeshInst(_MeshInst[i]);
    Mesh := Inst.Mesh;
    if _Frustum.CheckBox(Inst.BBox) <> fcOutside then
    for g := 0 to Mesh.GeomCount - 1 do
    begin
      Geom := Mesh.Geoms[g];
      if Geom^.Skinned then
      begin
        VB := Inst.Skins[g]^.VB;
        W := Inst.Transform;
      end
      else
      begin
        VB := PG2S3DGeomDataStatic(Geom^.Data)^.VB;
        W := Inst.Transforms[Geom^.NodeID].TransformCom * Inst.Transform;
      end;
      glLoadMatrixf(@W);
      VB.Bind;
      Geom^.IB.Bind;
      for m := 0 to Geom^.GCount - 1 do
      begin
        Material := Inst.Materials[Geom^.Groups[m].Material];
        if Material^.ChannelCount > 0 then
        begin
          if Material^.Channels[0].MapLight <> nil then
          begin
            _Gfx.ActiveTexture := 0;
            glEnable(GL_TEXTURE_2D);
            glBindTexture(GL_TEXTURE_2D, Material^.Channels[0].MapLight.GetTexture);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
            glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_MODULATE);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PRIMARY_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_TEXTURE);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_MODULATE);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_ALPHA, GL_PRIMARY_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_ALPHA, GL_TEXTURE);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_ALPHA, GL_SRC_ALPHA);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_ALPHA, GL_SRC_ALPHA);
            glClientActiveTexture(GL_TEXTURE0);
            glEnableClientState(GL_TEXTURE_COORD_ARRAY);
            glTexCoordPointer(2, GL_FLOAT, VB.VertexSize, VB.TexCoordIndex[1]);
            _Gfx.ActiveTexture := 1;
            glEnable(GL_TEXTURE_2D);
            glBindTexture(GL_TEXTURE_2D, Material^.Channels[0].MapLight.GetTexture);
            _Gfx.Filter := tfLinear;
            glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
            glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_ADD);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PREVIOUS);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_CONSTANT);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_REPLACE);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_ALPHA, GL_PREVIOUS);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_ALPHA, GL_SRC_ALPHA);
            EnvColor.SetValue(_Ambient.r * G2Rcp255, _Ambient.g * G2Rcp255, _Ambient.b * G2Rcp255, 1);
            glTexEnvfv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_COLOR, @EnvColor);
            glClientActiveTexture(GL_TEXTURE1);
            glDisableClientState(GL_TEXTURE_COORD_ARRAY);
            CurStage := 2;
          end
          else
          begin
            CurStage := 0;
            _Gfx.ActiveTexture := 1;
            glDisable(GL_TEXTURE_2D);
          end;
          if Material^.Channels[0].MapDiffuse <> nil then
          begin
            _Gfx.ActiveTexture := CurStage;
            glEnable(GL_TEXTURE_2D);
            glBindTexture(GL_TEXTURE_2D, Material^.Channels[0].MapDiffuse.GetTexture);
            if Material^.Channels[0].MapDiffuse.Usage = tu3D then
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
            else
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
            glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_MODULATE);
            if CurStage = 0 then
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PRIMARY_COLOR)
            else
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PREVIOUS);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_TEXTURE);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_MODULATE);
            if CurStage = 0 then
            glTexEnvi(GL_TEXTURE_2D, GL_SOURCE0_ALPHA, GL_PRIMARY_COLOR)
            else
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_ALPHA, GL_PREVIOUS);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_ALPHA, GL_SRC_ALPHA);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_ALPHA, GL_TEXTURE);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_ALPHA, GL_SRC_ALPHA);
            glClientActiveTexture(CurStage);
            glEnableClientState(GL_TEXTURE_COORD_ARRAY);
            glTexCoordPointer(2, GL_FLOAT, VB.VertexSize, VB.TexCoordIndex[0]);
          end;
        end;
        glDrawElements(
          GL_TRIANGLES,
          Geom^.Groups[m].FaceCount * 3,
          GL_UNSIGNED_SHORT,
          PGLVoid(Geom^.Groups[m].FaceStart * 6)
        );
      end;
      Geom^.IB.Unbind;
      VB.Unbind;
    end;
  end;
  _Gfx.ActiveTexture := 2;
  glDisable(GL_TEXTURE_2D);
  _Gfx.ActiveTexture := 1;
  glDisable(GL_TEXTURE_2D);
  glClientActiveTexture(GL_TEXTURE2);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glClientActiveTexture(GL_TEXTURE1);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glClientActiveTexture(GL_TEXTURE0);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  _Gfx.ActiveTexture := 0;
  glEnable(GL_TEXTURE_2D);
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
  glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_MODULATE);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PRIMARY_COLOR);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_TEXTURE);
  glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR);
  glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR);
  glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_MODULATE);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_ALPHA, GL_PRIMARY_COLOR);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_ALPHA, GL_TEXTURE);
  glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_ALPHA, GL_SRC_ALPHA);
  glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_ALPHA, GL_SRC_ALPHA);
  _Gfx.DepthEnable := PrevDepthEnable;
end;
{$elseif defined(G2RM_SM2)}
procedure TG2Scene3D.RenderOGL;
  var i, g, m: TG2IntS32;
  var f: TG2Float;
  var CurStage: TG2IntU32;
  var W, VP, WVP: TG2Mat;
  var Mesh: TG2S3DMesh;
  var Inst: TG2S3DMeshInst;
  var Geom: PG2S3DMeshGeom;
  var Material: PG2S3DMeshMaterial;
  var PrevDepthEnable: Boolean;
  var VB: TG2VertexBuffer;
  var Method: AnsiString;
  var Tex: array[0..1] of TG2TextureBase;
begin
  _Frustum.Update;
  PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := True;
  _Gfx.CullMode := g2cm_ccw;
  VP := V * P;
  Tex[0] := nil;
  Tex[1] := nil;
  for i := 0 to _MeshInst.Count - 1 do
  begin
    Inst := TG2S3DMeshInst(_MeshInst[i]);
    Mesh := Inst.Mesh;
    if _Frustum.CheckBox(Inst.BBox) <> fcOutside then
    for g := 0 to Mesh.GeomCount - 1 do
    begin
      Geom := Mesh.Geoms[g];
      if Geom^.Skinned then
      begin
        VB := PG2S3DGeomDataSkinned(Geom^.Data)^.VB;
        W := Inst.Transform;
        Method := 'SceneB' + IntToStr(PG2S3DGeomDataSkinned(Geom^.Data)^.MaxWeights);
      end
      else
      begin
        VB := PG2S3DGeomDataStatic(Geom^.Data)^.VB;
        W := Inst.Transforms[Geom^.NodeID].TransformCom * Inst.Transform;
        Method := 'SceneB0';
      end;
      WVP := W * VP;
      Geom^.IB.Bind;
      for m := 0 to Geom^.GCount - 1 do
      begin
        Material := Inst.Materials[Geom^.Groups[m].Material];
        _ShaderGroup.Method := 'SceneB0';
        if Material^.ChannelCount > 0 then
        begin
          if Material^.Channels[0].MapLight <> nil then
          begin
            _ShaderGroup.Method := Method + 'L';
            if Tex[1] <> Material^.Channels[0].MapLight then
            begin
              Tex[1] := Material^.Channels[0].MapLight;
              _ShaderGroup.Sampler('Tex1', Tex[1], 1);
              glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
              glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            end
            else
            _ShaderGroup.UniformInt1('Tex1', 1);
          end
          else
          begin
            _ShaderGroup.Method := Method;
          end;
          if Material^.Channels[0].MapDiffuse <> nil then
          begin
            if Tex[0] <> Material^.Channels[0].MapDiffuse then
            begin
              Tex[0] := Material^.Channels[0].MapDiffuse;
              _ShaderGroup.Sampler('Tex0', Tex[0], 0);
              glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
              glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            end
            else
            _ShaderGroup.UniformInt1('Tex0', 0);
          end;
        end;
        if Geom^.Skinned then
        _ShaderGroup.UniformMatrix4x4Arr('SkinPallete', @Inst.Skins[g]^.Transforms[0], 0, PG2S3DGeomDataSkinned(Geom^.Data)^.BoneCount);
        _ShaderGroup.UniformMatrix4x4('WVP', WVP);
        _ShaderGroup.UniformFloat4('LightAmbient', _Ambient);
        VB.Bind;
        glDrawElements(
          GL_TRIANGLES,
          Geom^.Groups[m].FaceCount * 3,
          GL_UNSIGNED_SHORT,
          PGLVoid(Geom^.Groups[m].FaceStart * 6)
        );
        VB.Unbind;
      end;
      Geom^.IB.Unbind;
    end;
  end;
  _Gfx.DepthEnable := PrevDepthEnable;
end;
{$endif}
{$elseif defined(G2Gfx_GLES)}
{$if defined(G2RM_FF)}
procedure TG2Scene3D.RenderGLES;
  var i, g, m: TG2IntS32;
  var f: TG2Float;
  var CurStage: TG2IntU8;
  var W, VP: TG2Mat;
  var Mesh: TG2S3DMesh;
  var Inst: TG2S3DMeshInst;
  var Geom: PG2S3DMeshGeom;
  var Material: PG2S3DMeshMaterial;
  var PrevDepthEnable: Boolean;
  var VB: TG2VertexBuffer;
  var EnvColor: TG2Vec4;
begin
  _Frustum.Update;
  PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := True;
  _Gfx.CullMode := g2cm_ccw;
  VP := V * P;
  glMatrixMode(GL_PROJECTION);
  glLoadMatrixf(@VP);
  glMatrixMode(GL_MODELVIEW);
  EnvColor.SetValue(_Ambient.r * G2Rcp255, _Ambient.g * G2Rcp255, _Ambient.b * G2Rcp255, 1);
  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, @EnvColor);
  glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, @EnvColor);
  for i := 0 to _MeshInst.Count - 1 do
  begin
    Inst := TG2S3DMeshInst(_MeshInst[i]);
    Mesh := Inst.Mesh;
    if _Frustum.CheckBox(Inst.BBox) <> fcOutside then
    for g := 0 to Mesh.GeomCount - 1 do
    begin
      Geom := Mesh.Geoms[g];
      if Geom^.Skinned then
      begin
        VB := Inst.Skins[g]^.VB;
        W := Inst.Transform;
      end
      else
      begin
        VB := PG2S3DGeomDataStatic(Geom^.Data)^.VB;
        W := Inst.Transforms[Geom^.NodeID].TransformCom * Inst.Transform;
      end;
      glLoadMatrixf(@W);
      VB.Bind;
      Geom^.IB.Bind;
      for m := 0 to Geom^.GCount - 1 do
      begin
        Material := Inst.Materials[Geom^.Groups[m].Material];
        _Gfx.ActiveTexture := 0;
        glDisable(GL_TEXTURE_2D);
        if Material^.ChannelCount > 0 then
        begin
          CurStage := 0;
          if Material^.Channels[0].MapLight <> nil then
          begin
            glEnable(GL_LIGHTING);
            _Gfx.ActiveTexture := CurStage;
            glEnable(GL_TEXTURE_2D);
            glBindTexture(GL_TEXTURE_2D, Material^.Channels[0].MapLight.GetTexture);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
            glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_ADD);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PRIMARY_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_TEXTURE);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_MODULATE);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_ALPHA, GL_PRIMARY_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_ALPHA, GL_TEXTURE);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_ALPHA, GL_SRC_ALPHA);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_ALPHA, GL_SRC_ALPHA);
            glClientActiveTexture(CurStage);
            glEnableClientState(GL_TEXTURE_COORD_ARRAY);
            glTexCoordPointer(2, GL_FLOAT, VB.VertexSize, VB.TexCoordIndex[1]);
            Inc(CurStage);
          end
          else
          glDisable(GL_LIGHTING);
          if Material^.Channels[0].MapDiffuse <> nil then
          begin
            _Gfx.ActiveTexture := CurStage;
            glEnable(GL_TEXTURE_2D);
            glBindTexture(GL_TEXTURE_2D, Material^.Channels[0].MapDiffuse.GetTexture);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
            glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_MODULATE);
            glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_MODULATE);
            if CurStage = GL_TEXTURE0 then
            begin
              glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PRIMARY_COLOR);
              glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_ALPHA, GL_PRIMARY_COLOR);
            end
            else
            begin
              glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PREVIOUS);
              glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_ALPHA, GL_PREVIOUS);
            end;
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_TEXTURE);
            glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_ALPHA, GL_TEXTURE);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_ALPHA, GL_SRC_ALPHA);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR);
            glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_ALPHA, GL_SRC_ALPHA);
            glClientActiveTexture(CurStage);
            glEnableClientState(GL_TEXTURE_COORD_ARRAY);
            glTexCoordPointer(2, GL_FLOAT, VB.VertexSize, VB.TexCoordIndex[0]);
            Inc(CurStage);
          end;
        end;
        glDrawElements(
          GL_TRIANGLES,
          Geom^.Groups[m].FaceCount * 3,
          GL_UNSIGNED_SHORT,
          PGLVoid(Geom^.Groups[m].FaceStart * 6)
        );
      end;
      Geom^.IB.Unbind;
      VB.Unbind;
    end;
  end;
  glDisable(GL_LIGHTING);
  _Gfx.ActiveTexture := 2;
  glDisable(GL_TEXTURE_2D);
  _Gfx.ActiveTexture := 1;
  glDisable(GL_TEXTURE_2D);
  glClientActiveTexture(GL_TEXTURE2);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glClientActiveTexture(GL_TEXTURE1);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glClientActiveTexture(GL_TEXTURE0);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  _Gfx.ActiveTexture := 0;
  glEnable(GL_TEXTURE_2D);
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
  glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_RGB, GL_MODULATE);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_RGB, GL_PRIMARY_COLOR);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_RGB, GL_TEXTURE);
  glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_COLOR);
  glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_RGB, GL_SRC_COLOR);
  glTexEnvi(GL_TEXTURE_ENV, GL_COMBINE_ALPHA, GL_MODULATE);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE0_ALPHA, GL_PRIMARY_COLOR);
  glTexEnvi(GL_TEXTURE_ENV, GL_SOURCE1_ALPHA, GL_TEXTURE);
  glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_ALPHA, GL_SRC_ALPHA);
  glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND1_ALPHA, GL_SRC_ALPHA);
  _Gfx.DepthEnable := PrevDepthEnable;
end;
{$elseif defined(G2RM_SM2)}
procedure TG2Scene3D.RenderGLES;
  var i, g, m: TG2IntS32;
  var f: TG2Float;
  var CurStage: TG2IntU32;
  var W, VP, WVP: TG2Mat;
  var Mesh: TG2S3DMesh;
  var Inst: TG2S3DMeshInst;
  var Geom: PG2S3DMeshGeom;
  var Material: PG2S3DMeshMaterial;
  var PrevDepthEnable: Boolean;
  var VB: TG2VertexBuffer;
  var Method: AnsiString;
  var Tex: array[0..1] of TG2TextureBase;
begin
  _Frustum.Update;
  PrevDepthEnable := _Gfx.DepthEnable;
  _Gfx.DepthEnable := True;
  _Gfx.CullMode := g2cm_ccw;
  VP := V * P;
  Tex[0] := nil;
  Tex[1] := nil;
  for i := 0 to _MeshInst.Count - 1 do
  begin
    Inst := TG2S3DMeshInst(_MeshInst[i]);
    Mesh := Inst.Mesh;
    if _Frustum.CheckBox(Inst.BBox) <> fcOutside then
    for g := 0 to Mesh.GeomCount - 1 do
    begin
      Geom := Mesh.Geoms[g];
      if Geom^.Skinned then
      begin
        VB := PG2S3DGeomDataSkinned(Geom^.Data)^.VB;
        W := Inst.Transform;
        Method := 'SceneB' + IntToStr(PG2S3DGeomDataSkinned(Geom^.Data)^.MaxWeights);
      end
      else
      begin
        VB := PG2S3DGeomDataStatic(Geom^.Data)^.VB;
        W := Inst.Transforms[Geom^.NodeID].TransformCom * Inst.Transform;
        Method := 'SceneB0';
      end;
      WVP := W * VP;
      Geom^.IB.Bind;
      for m := 0 to Geom^.GCount - 1 do
      begin
        Material := Inst.Materials[Geom^.Groups[m].Material];
        _ShaderGroup.Method := 'SceneB0';
        if Material^.ChannelCount > 0 then
        begin
          if Material^.Channels[0].MapLight <> nil then
          begin
            _ShaderGroup.Method := Method + 'L';
            if Tex[1] <> Material^.Channels[0].MapLight then
            begin
              Tex[1] := Material^.Channels[0].MapLight;
              _ShaderGroup.Sampler('Tex1', Tex[1], 1);
              glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
              glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            end
            else
            _ShaderGroup.UniformInt1('Tex1', 1);
          end
          else
          begin
            _ShaderGroup.Method := Method;
          end;
          if Material^.Channels[0].MapDiffuse <> nil then
          begin
            if Tex[0] <> Material^.Channels[0].MapDiffuse then
            begin
              Tex[0] := Material^.Channels[0].MapDiffuse;
              _ShaderGroup.Sampler('Tex0', Tex[0], 0);
              glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
              glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            end
            else
            _ShaderGroup.UniformInt1('Tex0', 0);
          end;
        end;
        if Geom^.Skinned then
        _ShaderGroup.UniformMatrix4x4Arr('SkinPallete', @Inst.Skins[g]^.Transforms[0], 0, PG2S3DGeomDataSkinned(Geom^.Data)^.BoneCount);
        _ShaderGroup.UniformMatrix4x4('WVP', WVP);
        _ShaderGroup.UniformFloat4('LightAmbient', _Ambient);
        VB.Bind;
        glDrawElements(
          GL_TRIANGLES,
          Geom^.Groups[m].FaceCount * 3,
          GL_UNSIGNED_SHORT,
          PGLVoid(Geom^.Groups[m].FaceStart * 6)
        );
        VB.Unbind;
      end;
      Geom^.IB.Unbind;
    end;
  end;
  _Gfx.DepthEnable := PrevDepthEnable;
end;
{$endif}
{$endif}

procedure TG2Scene3D.RenderParticles;
  var gi, i: TG2IntS32;
  var ViewDir: TG2Vec3;
  var g: PG2S3DParticleGroup;
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
    g := PG2S3DParticleGroup(_ParticleGroups[gi]);
    if _Frustum.CheckBox(g^.AABox) <> fcOutside then
    begin
      for i := 0 to g^.Items.Count - 1 do
      begin
        pt := TG2S3DParticle(g^.Items[i]);
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

procedure TG2Scene3D.DoRender;
begin
  {$if defined(G2Gfx_D3D9)}
  RenderD3D9;
  {$elseif defined(G2Gfx_OGL)}
  RenderOGL;
  {$elseif defined(G2Gfx_GLES)}
  RenderGLES;
  {$endif}
  RenderParticles;
end;

procedure TG2Scene3D.Update;
  var i, n: TG2IntS32;
  var pt: TG2S3DParticle;
  var g: PG2S3DParticleGroup;
begin
  _UpdatingParticles := True;
  for i := 0 to _ParticleGroups.Count - 1 do
  begin
    g := PG2S3DParticleGroup(_ParticleGroups[i]);
    g^.AABox := TG2S3DParticle(g^.Items[0]).AABox;
    g^.MaxSize := 0;
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
      g^.Items.Remove(pt);
      pt.Free;
      _Particles.Delete(i);
      if g^.Items.Count < 1 then
      begin
        _ParticleGroups.Remove(g);
        Dispose(g);
      end;
      Dec(n);
    end
    else
    begin
      g^.MaxSize := g^.MaxSize + pt.Size;
      g^.AABox.Include(pt.AABox);
      Inc(i);
    end;
  end;
  for i := 0 to _ParticleGroups.Count - 1 do
  begin
    g := PG2S3DParticleGroup(_ParticleGroups[i]);
    g^.MaxSize := g^.MaxSize / g^.Items.Count;
    g^.MinSize := g^.MaxSize * 0.1;
    g^.MaxSize := g^.MaxSize * 10;
  end;
  _UpdatingParticles := False;
  for i := 0 to _NewParticles.Count - 1 do
  ParticleAdd(TG2S3DParticle(_NewParticles[i]));
  _NewParticles.Clear;
end;

procedure TG2Scene3D.Build;
begin

end;

procedure TG2Scene3D.ParticleAdd(const Particle: TG2S3DParticle);
  var i, n: TG2IntS32;
  var Bounds: TG2AABox;
  var g: PG2S3DParticleGroup;
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
  if (Particle.Size >= PG2S3DParticleGroup(_ParticleGroups[i])^.MinSize)
  and (Particle.Size <= PG2S3DParticleGroup(_ParticleGroups[i])^.MaxSize)
  and (Bounds.Intersect(PG2S3DParticleGroup(_ParticleGroups[i])^.AABox)) then
  begin
    g := PG2S3DParticleGroup(_ParticleGroups[i]);
    g^.MaxSize := (g^.MaxSize * 0.1 * g^.Items.Count + Particle.Size) / (g^.Items.Count + 1);
    g^.MinSize := g^.MaxSize * 0.1;
    g^.MaxSize := g^.MaxSize * 10;
    g^.Items.Add(Particle);
    g^.AABox.Include(Particle.AABox);
    Particle.Group := g;
    Exit;
  end;
  New(g);
  _ParticleGroups.Add(g);
  g^.Items.Clear;
  g^.Items.Add(Particle);
  g^.AABox := Particle.AABox;
  g^.MinSize := Particle.Size * 0.1;
  g^.MaxSize := Particle.Size * 0.1;
  Particle.Group := g;
end;

constructor TG2Scene3D.Create;
begin
  inherited Create;
  {$if defined(G2Gfx_D3D9)}
  _Gfx := TG2GfxD3D9(g2.Gfx);
  {$elseif defined(G2Gfx_OGL)}
  _Gfx := TG2GfxOGL(g2.Gfx);
  {$elseif defined(G2Gfx_GLES)}
  _Gfx := TG2GfxGLES(g2.Gfx);
  {$endif}
  {$if defined(G2RM_SM2)}
  _ShaderGroup := _Gfx.RequestShader('StandardShaders');
  {$endif}
  _Nodes.Clear;
  _Frames.Clear;
  _MeshInst.Clear;
  _Particles.Clear;
  _NewParticles.Clear;
  _ParticleGroups.Clear;
  _ParticleRenders.Clear;
  _Frustum.RefV := @V;
  _Frustum.RefP := @P;
  _OcTreeRoot := nil;
  _UpdatingParticles := False;
  _StatParticlesRendered := 0;
  _Ambient := $ff141414;
end;

destructor TG2Scene3D.Destroy;
  var i: TG2IntS32;
begin
  for i := 0 to _NewParticles.Count - 1 do
  TG2S3DParticle(_NewParticles[i]).Free;
  _NewParticles.Clear;
  for i := 0 to _Particles.Count - 1 do
  TG2S3DParticle(_Particles[i]).Free;
  _Particles.Clear;
  for i := 0 to _ParticleGroups.Count - 1 do
  Dispose(PG2S3DParticleGroup(_ParticleGroups[i]));
  _ParticleGroups.Clear;
  for i := 0 to _ParticleRenders.Count - 1 do
  TG2S3DParticleRender(_ParticleRenders[i]).Free;
  _ParticleRenders.Clear;
  while _Nodes.Count > 0 do
  TG2S3DNode(_Nodes[0]).Free;
  inherited Destroy;
end;
//TG2Scene3D END

//TG2LegacyMesh BEGIN
procedure TG2LegacyMesh.Initialize;
begin
  inherited Initialize;
  Nodes.Clear;
  Geoms.Clear;
  Anims.Clear;
  Materials.Clear;
end;

procedure TG2LegacyMesh.Finalize;
begin
  Release;
  inherited Finalize;
end;

class function TG2LegacyMesh.SharedAsset(const SharedAssetName: String): TG2LegacyMesh;
  var Res: TG2Res;
  var dm: TG2DataManager;
begin
  Res := TG2Res.List;
  while Res <> nil do
  begin
    if (Res is TG2LegacyMesh)
    and (TG2LegacyMesh(Res).AssetName = SharedAssetName)
    and (Res.RefCount > 0) then
    begin
      Result := TG2LegacyMesh(Res);
      Exit;
    end;
    Res := Res.Next;
  end;
  dm := TG2DataManager.Create(SharedAssetName, dmAsset);
  Result := TG2LegacyMesh.Create;
  Result.AssetName := SharedAssetName;
  Result.Load(dm);
  dm.Free;
end;

procedure TG2LegacyMesh.Release;
begin

end;

procedure TG2LegacyMesh.Load(const DataManager: TG2DataManager);
  var i: TG2IntS32;
  var ml: TG2MeshLoader;
  var md: TG2MeshData;
begin
  for i := 0 to High(G2MeshLoaders) do
  if G2MeshLoaders[i].CanLoad(DataManager) then
  begin
    ml := G2MeshLoaders[i].Create;
    ml.Load(DataManager);
    ml.ExportMeshData(@md);
    ml.Free;
    Load(md);
    Break;
  end;
end;

procedure TG2LegacyMesh.Load(const Stream: TStream);
  var i: TG2IntS32;
  var ml: TG2MeshLoader;
  var md: TG2MeshData;
begin
  for i := 0 to High(G2MeshLoaders) do
  if G2MeshLoaders[i].CanLoad(Stream) then
  begin
    ml := G2MeshLoaders[i].Create;
    ml.Load(Stream);
    ml.ExportMeshData(@md);
    ml.Free;
    Load(md);
    Break;
  end;
end;

procedure TG2LegacyMesh.Load(const FileName: String);
  var i: TG2IntS32;
  var ml: TG2MeshLoader;
  var md: TG2MeshData;
begin
  for i := 0 to High(G2MeshLoaders) do
  if G2MeshLoaders[i].CanLoad(FileName) then
  begin
    ml := G2MeshLoaders[i].Create;
    ml.Load(FileName);
    ml.ExportMeshData(@md);
    ml.Free;
    md.LimitSkins(4);
    Load(md);
    Break;
  end;
end;

procedure TG2LegacyMesh.Load(const MeshData: TG2MeshData);
  type TVertex = packed record
    Position: TG2Vec3;
    Normal: TG2Vec3;
  end;
  type PVertex = ^TVertex;
  var i, j, n: TG2IntS32;
  var MinV, MaxV, v: TG2Vec3;
  var Vertex: PVertex;
  var TexCoords: PG2Vec2;
  {$if defined(G2RM_SM2)}
  var BlendWeights: PG2Float;
  var BlendIndices: PG2Float;
  {$endif}
  var DataStatic: PG2LegacyGeomDataStatic;
  var DataSkinned: PG2LegacyGeomDataSkinned;
begin
  Nodes.Allocate(MeshData.NodeCount);
  for i := 0 to Nodes.Count - 1 do
  begin
    Nodes[i]^.Name := MeshData.Nodes[i].Name;
    Nodes[i]^.OwnerID := MeshData.Nodes[i].OwnerID;
    Nodes[i]^.Transform := MeshData.Nodes[i].Transform;
    Nodes[i]^.SubNodesID.Clear;
  end;
  for i := 0 to Nodes.Count - 1 do
  if Nodes[i]^.OwnerID > -1 then
  begin
    Nodes[Nodes[i]^.OwnerID]^.SubNodesID.Add(i);
  end;
  Geoms.Allocate(MeshData.GeomCount);
  for i := 0 to Geoms.Count - 1 do
  begin
    Geoms[i]^.NodeID := MeshData.Geoms[i].NodeID;
    Geoms[i]^.VCount := MeshData.Geoms[i].VCount;
    Geoms[i]^.FCount := MeshData.Geoms[i].FCount;
    Geoms[i]^.GCount := MeshData.Geoms[i].MCount;
    Geoms[i]^.TCount := MeshData.Geoms[i].TCount;
    Geoms[i]^.Visible := True;
    Geoms[i]^.Skinned := MeshData.Geoms[i].SkinID > -1;
    SetLength(Geoms[i]^.Decl, 2 + Geoms[i]^.TCount);
    Geoms[i]^.Decl[0].Element := vbPosition; Geoms[i]^.Decl[0].Count := 3;
    Geoms[i]^.Decl[1].Element := vbNormal; Geoms[i]^.Decl[1].Count := 3;
    for j := 2 to 2 + Geoms[i]^.TCount - 1 do
    begin
      Geoms[i]^.Decl[j].Element := vbTexCoord;
      Geoms[i]^.Decl[j].Count := 2;
    end;
    if Geoms[i]^.Skinned then
    begin
      New(DataSkinned);
      Geoms[i]^.Data := DataSkinned;
      DataSkinned^.MaxWeights := MeshData.Skins[MeshData.Geoms[i].SkinID].MaxWeights;
      DataSkinned^.BoneCount := MeshData.Skins[MeshData.Geoms[i].SkinID].BoneCount;
      SetLength(DataSkinned^.Bones, DataSkinned^.BoneCount);
      for j := 0 to DataSkinned^.BoneCount - 1 do
      begin
        DataSkinned^.Bones[j].NodeID := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].NodeID;
        DataSkinned^.Bones[j].Bind := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].Bind;
        DataSkinned^.Bones[j].BBox := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].BBox;
        DataSkinned^.Bones[j].VCount := MeshData.Skins[MeshData.Geoms[i].SkinID].Bones[j].VCount;
      end;
      {$if defined(G2RM_FF)}
      SetLength(DataSkinned^.Vertices, Geoms[i]^.VCount);
      for j := 0 to Geoms[i]^.VCount - 1 do
      begin
        SetLength(DataSkinned^.Vertices[j].TexCoord, Geoms[i]^.TCount);
        SetLength(DataSkinned^.Vertices[j].Bones, DataSkinned^.MaxWeights);
        SetLength(DataSkinned^.Vertices[j].Weights, DataSkinned^.MaxWeights);
        DataSkinned^.Vertices[j].Position := MeshData.Geoms[i].Vertices[j].Position;
        DataSkinned^.Vertices[j].Normal := MeshData.Geoms[i].Vertices[j].Normal;
        for n := 0 to Geoms[i]^.TCount - 1 do
        DataSkinned^.Vertices[j].TexCoord[n] := MeshData.Geoms[i].Vertices[j].TexCoords[n];
        DataSkinned^.Vertices[j].BoneWeightCount := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].WeightCount;
        for n := 0 to MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].WeightCount - 1 do
        begin
          DataSkinned^.Vertices[j].Bones[n] := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[n].BoneID;
          DataSkinned^.Vertices[j].Weights[n] := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[n].Weight;
        end;
        for n := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].WeightCount to DataSkinned^.MaxWeights - 1 do
        begin
          DataSkinned^.Vertices[j].Bones[n] := 0;
          DataSkinned^.Vertices[j].Weights[n] := 0;
        end;
      end;
      {$elseif defined(G2RM_SM2)}
      n := Length(Geoms[i]^.Decl);
      if DataSkinned^.MaxWeights = 1 then
      begin
        SetLength(Geoms[i]^.Decl, Length(Geoms[i]^.Decl) + 1);
        Geoms[i]^.Decl[n].Element := vbVertexIndex; Geoms[i]^.Decl[n].Count := 1;
      end
      else
      begin
        SetLength(Geoms[i]^.Decl, Length(Geoms[i]^.Decl) + 2 * DataSkinned^.MaxWeights);
        Geoms[i]^.Decl[n].Element := vbVertexIndex; Geoms[i]^.Decl[n].Count := DataSkinned^.MaxWeights;
        Inc(n);
        Geoms[i]^.Decl[n].Element := vbVertexWeight; Geoms[i]^.Decl[n].Count := DataSkinned^.MaxWeights;
      end;
      DataSkinned^.VB := TG2VertexBuffer.Create(Geoms[i]^.Decl, Geoms[i]^.VCount);
      DataSkinned^.VB.Lock;
      for j := 0 to Geoms[i]^.VCount - 1 do
      begin
        Vertex := PVertex(DataSkinned^.VB.Data + TG2IntS32(DataSkinned^.VB.VertexSize) * j);
        TexCoords := PG2Vec2(Pointer(Vertex) + TG2IntS32(SizeOf(TVertex)));
        BlendIndices := PG2Float(Pointer(TexCoords) + Geoms[i]^.TCount * 8);
        BlendWeights := PG2Float(Pointer(BlendIndices) + DataSkinned^.MaxWeights * 4);
        Vertex^.Position := MeshData.Geoms[i].Vertices[j].Position;
        Vertex^.Normal := MeshData.Geoms[i].Vertices[j].Normal;
        for n := 0 to Geoms[i]^.TCount - 1 do
        begin
          TexCoords^ := MeshData.Geoms[i].Vertices[j].TexCoords[n];
          Inc(TexCoords);
        end;
        if DataSkinned^.MaxWeights = 1 then
        begin
          BlendIndices^ := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[0].BoneID
        end
        else
        begin
          for n := 0 to MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].WeightCount - 1 do
          begin
            BlendIndices^ := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[n].BoneID;
            Inc(BlendIndices);
            BlendWeights^ := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].Weights[n].Weight;
            Inc(BlendWeights);
          end;
          for n := MeshData.Skins[MeshData.Geoms[i].SkinID].Vertices[j].WeightCount to DataSkinned^.MaxWeights - 1 do
          begin
            BlendIndices^ := 0;
            Inc(BlendIndices);
            BlendWeights^ := 0;
            Inc(BlendWeights);
          end;
        end;
      end;
      DataSkinned^.VB.UnLock;
      {$endif}
    end
    else
    begin
      New(DataStatic);
      Geoms[i]^.Data := DataStatic;
      DataStatic^.VB := TG2VertexBuffer.Create(Geoms[i]^.Decl, Geoms[i]^.VCount);
      DataStatic^.VB.Lock;
      if MeshData.Geoms[i].VCount > 0 then
      begin
        MinV := MeshData.Geoms[i].Vertices[0].Position;
      end
      else
      begin
        MinV := G2Vec3;
      end;
      MaxV := MinV;
      for j := 0 to Geoms[i]^.VCount - 1 do
      begin
        Vertex := PVertex(DataStatic^.VB.Data + TG2IntS32(DataStatic^.VB.VertexSize) * j);
        TexCoords := PG2Vec2(DataStatic^.VB.Data + TG2IntS32(DataStatic^.VB.VertexSize) * j + TG2IntS32(SizeOf(TVertex)));
        Vertex^.Position := MeshData.Geoms[i].Vertices[j].Position;
        Vertex^.Normal := MeshData.Geoms[i].Vertices[j].Normal;
        for n := 0 to Geoms[i]^.TCount - 1 do
        begin
          TexCoords^ := MeshData.Geoms[i].Vertices[j].TexCoords[n];
          Inc(TexCoords);
        end;
        if MeshData.Geoms[i].Vertices[j].Position.x > MaxV.x then MaxV.x := MeshData.Geoms[i].Vertices[j].Position.x
        else if MeshData.Geoms[i].Vertices[j].Position.x < MinV.x then MinV.x := MeshData.Geoms[i].Vertices[j].Position.x;
        if MeshData.Geoms[i].Vertices[j].Position.y > MaxV.y then MaxV.y := MeshData.Geoms[i].Vertices[j].Position.y
        else if MeshData.Geoms[i].Vertices[j].Position.y < MinV.y then MinV.y := MeshData.Geoms[i].Vertices[j].Position.y;
        if MeshData.Geoms[i].Vertices[j].Position.z > MaxV.z then MaxV.z := MeshData.Geoms[i].Vertices[j].Position.z
        else if MeshData.Geoms[i].Vertices[j].Position.z < MinV.z then MinV.z := MeshData.Geoms[i].Vertices[j].Position.z;
      end;
      DataStatic^.VB.UnLock;
      DataStatic^.BBox.c := (MinV + MaxV) * 0.5;
      v := (MaxV - MinV) * 0.5;
      DataStatic^.BBox.vx.SetValue(v.x, 0, 0);
      DataStatic^.BBox.vy.SetValue(0, v.y, 0);
      DataStatic^.BBox.vz.SetValue(0, 0, v.z);
    end;
    Geoms[i]^.IB := TG2IndexBuffer.Create(Geoms[i]^.FCount * 3);
    Geoms[i]^.IB.Lock;
    for j := 0 to Geoms[i]^.FCount - 1 do
    begin
      PG2IntU16Arr(Geoms[i]^.IB.Data)^[j * 3 + 0] := MeshData.Geoms[i].Faces[j][0];
      PG2IntU16Arr(Geoms[i]^.IB.Data)^[j * 3 + 1] := MeshData.Geoms[i].Faces[j][1];
      PG2IntU16Arr(Geoms[i]^.IB.Data)^[j * 3 + 2] := MeshData.Geoms[i].Faces[j][2];
    end;
    Geoms[i]^.IB.UnLock;
    SetLength(Geoms[i]^.Groups, Geoms[i]^.GCount);
    for j := 0 to Geoms[i]^.GCount - 1 do
    begin
      Geoms[i]^.Groups[j].Material := MeshData.Geoms[i].Groups[j].MaterialID;
      Geoms[i]^.Groups[j].VertexStart := MeshData.Geoms[i].Groups[j].VertexStart;
      Geoms[i]^.Groups[j].VertexCount := MeshData.Geoms[i].Groups[j].VertexCount;
      Geoms[i]^.Groups[j].FaceStart := MeshData.Geoms[i].Groups[j].FaceStart;
      Geoms[i]^.Groups[j].FaceCount := MeshData.Geoms[i].Groups[j].FaceCount;
    end;
  end;
  Materials.Allocate(MeshData.MaterialCount);
  for i := 0 to Materials.Count - 1 do
  begin
    Materials[i]^.ChannelCount := MeshData.Materials[i].ChannelCount;
    SetLength(Materials[i]^.Channels, Materials[i]^.ChannelCount);
    for j := 0 to Materials[i]^.ChannelCount - 1 do
    begin
      Materials[i]^.Channels[j].Name := MeshData.Materials[i].Channels[j].Name;
      Materials[i]^.Channels[j].TwoSided := MeshData.Materials[i].Channels[j].TwoSided;
      if Length(MeshData.Materials[i].Channels[j].DiffuseMap) > 0 then
      begin
        Materials[i]^.Channels[j].MapDiffuse := TG2Texture2D.SharedAsset(MeshData.Materials[i].Channels[j].DiffuseMap, {$if defined(G2Target_Android)}tuDefault{$else}tu3D{$endif});
        if Assigned(Materials[i]^.Channels[j].MapDiffuse) then
        begin
          Materials[i]^.Channels[j].MapDiffuse.RefInc;
        end;
      end
      else
      begin
        Materials[i]^.Channels[j].MapDiffuse := nil;
      end;
      if Length(MeshData.Materials[i].Channels[j].LightMap) > 0 then
      begin
        Materials[i]^.Channels[j].MapLight := TG2Texture2D.SharedAsset(MeshData.Materials[i].Channels[j].LightMap, tuDefault);
        if Assigned(Materials[i]^.Channels[j].MapLight) then
        begin
          Materials[i]^.Channels[j].MapLight.RefInc;
        end;
      end
      else
      begin
        Materials[i]^.Channels[j].MapLight := nil;
      end;
    end;
  end;
  Anims.Allocate(MeshData.AnimCount);
  for i := 0 to Anims.Count - 1 do
  begin
    Anims[i]^.Name := MeshData.Anims[i].Name;
    Anims[i]^.FrameCount := MeshData.Anims[i].FrameCount;
    Anims[i]^.FrameRate := MeshData.Anims[i].FrameRate;
    Anims[i]^.NodeCount := MeshData.Anims[i].NodeCount;
    SetLength(Anims[i]^.Nodes, Anims[i]^.NodeCount);
    for j := 0 to Anims[i]^.NodeCount - 1 do
    begin
      Anims[i]^.Nodes[j].NodeID := MeshData.Anims[i].Nodes[j].NodeID;
      SetLength(Anims[i]^.Nodes[j].Frames, Anims[i]^.FrameCount);
      for n := 0 to Anims[i]^.FrameCount - 1 do
      begin
        Anims[i]^.Nodes[j].Frames[n].Scaling := MeshData.Anims[i].Nodes[j].Frames[n].Scaling;
        Anims[i]^.Nodes[j].Frames[n].Rotation := MeshData.Anims[i].Nodes[j].Frames[n].Rotation;
        Anims[i]^.Nodes[j].Frames[n].Translation := MeshData.Anims[i].Nodes[j].Frames[n].Translation;
      end;
    end;
  end;
end;

function TG2LegacyMesh.AnimIndex(const Name: AnsiString): TG2IntS32;
  var i: TG2IntS32;
begin
  for i := 0 to Anims.Count - 1 do
  if Anims[i]^.Name = Name then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;

function TG2LegacyMesh.NewInst: TG2LegacyMeshInst;
begin
  Result := TG2LegacyMeshInst.Create(Self);
end;
//TG2LegacyMesh END

//TG2LegacyMeshInst BEGIN
function TG2LegacyMeshInst.GetOBBox: TG2Box;
  var i: TG2IntS32;
  var b: TG2AABox;
begin
  if _Mesh.Geoms.Count < 1 then
  begin
    Result.SetValue(G2Vec3(0, 0, 0), G2Vec3(0, 0, 0), G2Vec3(0, 0, 0), G2Vec3(0, 0, 0));
    Exit;
  end;
  b := GetGeomBBox(0);
  for i := 1 to _Mesh.Geoms.Count - 1 do
  b.Merge(GetGeomBBox(i));
  Result := b;
end;

function TG2LegacyMeshInst.GetGeomBBox(const Index: TG2IntS32): TG2Box;
  var DataSkinned: PG2LegacyGeomDataSkinned;
  var i, j: TG2IntS32;
  var b: TG2AABox;
begin
  if _Mesh.Geoms[Index]^.Skinned then
  begin
    DataSkinned := PG2LegacyGeomDataSkinned(_Mesh.Geoms[Index]^.Data);
    for i := 0 to DataSkinned^.BoneCount - 1 do
    if DataSkinned^.Bones[i].VCount > 0 then
    begin
      b := DataSkinned^.Bones[i].BBox.Transform(_Skins[Index]^.Transforms[i]);
      Break;
    end;
    for j := i + 1 to DataSkinned^.BoneCount - 1 do
    if DataSkinned^.Bones[j].VCount > 0 then
    b.Merge(DataSkinned^.Bones[j].BBox.Transform(_Skins[Index]^.Transforms[j]));
    Result := b;
  end
  else
  Result := PG2LegacyGeomDataStatic(_Mesh.Geoms[Index]^.Data)^.BBox.Transform(Transforms[_Mesh.Geoms[Index]^.NodeID].TransformCom);
end;

function TG2LegacyMeshInst.GetSkinTransforms(const Index: TG2IntS32): PG2Mat;
begin
  Result := @_Skins[Index]^.Transforms[0];
end;

function TG2LegacyMeshInst.GetAABox: TG2AABox;
begin
  Result := GetOBBox;
end;

function TG2LegacyMeshInst.GetSkin(const Index: TG2IntS32): PG2LegacyMeshInstSkin;
begin
  Result := _Skins[Index];
end;

procedure TG2LegacyMeshInst.ComputeSkinTransforms;
  var DataSkinned: PG2LegacyGeomDataSkinned;
  var i, j: TG2IntS32;
begin
  for i := 0 to _Mesh.Geoms.Count - 1 do
  if _Mesh.Geoms[i]^.Skinned then
  begin
    DataSkinned := PG2LegacyGeomDataSkinned(_Mesh.Geoms[i]^.Data);
    for j := 0 to DataSkinned^.BoneCount - 1 do
    begin
      _Skins[i]^.Transforms[j] := DataSkinned^.Bones[j].Bind * Transforms[DataSkinned^.Bones[j].NodeID].TransformCom;
    end;
    {$if defined(G2RM_FF)}
    for j := 0 to 1 do
    begin
      _Skins[i]^.VBReady[j] := False;
    end
    {$endif}
  end;
end;

{$if defined(G2RM_FF)}
procedure TG2LegacyMeshInst.UpdateSkin(const GeomID, QueueID: TG2IntS32);
  type TVertex = packed record
    Position: TG2Vec3;
    Normal: TG2Vec3;
  end;
  type PVertex = ^TVertex;
  var vp, vn: TG2Vec3;
  var Vertex: PVertex;
  var TexCoords: PG2Vec2;
  var i, j: TG2IntS32;
  var DataSkinned: PG2LegacyGeomDataSkinned;
begin
  if not _Mesh.Geoms[GeomID]^.Skinned or _Skins[GeomID]^.VBReady[QueueID] then Exit;
  DataSkinned := PG2LegacyGeomDataSkinned(_Mesh.Geoms[GeomID]^.Data);
  _Skins[GeomID]^.VB[QueueID].Lock;
  for i := 0 to _Mesh.Geoms[GeomID]^.VCount - 1 do
  begin
    Vertex := PVertex(_Skins[GeomID]^.VB[QueueID].Data + TG2IntS32(_Skins[GeomID]^.VB[QueueID].VertexSize) * i);
    TexCoords := PG2Vec2(Pointer(Vertex) + SizeOf(TVertex));
    vp.SetValue(0, 0, 0);
    vn.SetValue(0, 0, 0);
    for j := 0 to DataSkinned^.Vertices[i].BoneWeightCount - 1 do
    begin
      vp := vp + DataSkinned^.Vertices[i].Position.Transform4x3(
        _Skins[GeomID]^.Transforms[DataSkinned^.Vertices[i].Bones[j]]
      ) * DataSkinned^.Vertices[i].Weights[j];
      vn := vn + DataSkinned^.Vertices[i].Normal.Transform3x3(
        _Skins[GeomID]^.Transforms[DataSkinned^.Vertices[i].Bones[j]]
      ) * DataSkinned^.Vertices[i].Weights[j];
    end;
    Vertex^.Position := vp;
    Vertex^.Normal := vn;
    for j := 0 to _Mesh.Geoms[GeomID]^.TCount - 1 do
    begin
      TexCoords^ := DataSkinned^.Vertices[i].TexCoord[j];
      Inc(TexCoords);
    end;
  end;
  _Skins[GeomID]^.VB[QueueID].UnLock;
  _Skins[GeomID]^.VBReady[QueueID] := True;
end;
{$endif}

constructor TG2LegacyMeshInst.Create(const AMesh: TG2LegacyMesh);
  var i: TG2IntS32;
  {$if defined(G2RM_FF)}
  var j: TG2IntS32;
  {$endif}
begin
  inherited Create;
  _Mesh := AMesh;
  _AutoComputeTransforms := True;
  _Color := $ffffffff;
  SetLength(Materials, _Mesh.Materials.Count);
  for i := 0 to _Mesh.Materials.Count - 1 do
  Materials[i] := _Mesh.Materials[i];
  SetLength(Transforms, _Mesh.Nodes.Count);
  _RootNodes.Clear;
  for i := 0 to _Mesh.Nodes.Count - 1 do
  begin
    if _Mesh.Nodes[i]^.OwnerID = -1 then _RootNodes.Add(i);
    Transforms[i].TransformDef := _Mesh.Nodes[i]^.Transform;
    Transforms[i].TransformCur := Transforms[i].TransformDef;
    Transforms[i].TransformCom := G2MatIdentity;
  end;
  SetLength(_Skins, _Mesh.Geoms.Count);
  for i := 0 to _Mesh.Geoms.Count - 1 do
  if _Mesh.Geoms[i]^.Skinned then
  begin
    New(_Skins[i]);
    SetLength(_Skins[i]^.Transforms, PG2LegacyGeomDataSkinned(_Mesh.Geoms[i]^.Data)^.BoneCount);
    {$if defined(G2RM_FF)}
    for j := 0 to 1 do
    begin
      _Skins[i]^.VB[j] := TG2VertexBuffer.Create(_Mesh.Geoms[i]^.Decl, _Mesh.Geoms[i]^.VCount);
      _Skins[i]^.VBReady[j] := False;
    end;
    {$endif}
  end;
  ComputeTransforms;
end;

destructor TG2LegacyMeshInst.Destroy;
  var i: TG2IntS32;
  {$if defined(G2RM_FF)}
  var j: TG2IntS32;
  {$endif}
begin
  for i := 0 to _Mesh.Geoms.Count - 1 do
  if _Mesh.Geoms[i]^.Skinned then
  begin
    {$if defined(G2RM_FF)}
    for j := 0 to 1 do
    begin
      _Skins[i]^.VB[j].Free;
    end;
    {$endif}
    Dispose(_Skins[i]);
  end;
  inherited Destroy;
end;

procedure TG2LegacyMeshInst.FrameSetFast(const AnimName: AnsiString; const Frame: TG2IntS32);
  var AnimIndex, i, f0: TG2IntS32;
  var ms, mr, mt: TG2Mat;
begin
  AnimIndex := _Mesh.AnimIndex(AnimName);
  if AnimIndex > -1 then
  begin
    if Frame < 0 then
    f0 := _Mesh.Anims[AnimIndex]^.FrameCount - (Abs(Frame) mod _Mesh.Anims[AnimIndex]^.FrameCount)
    else
    f0 := Frame mod _Mesh.Anims[AnimIndex]^.FrameCount;
    for i := 0 to _Mesh.Anims[AnimIndex]^.NodeCount - 1 do
    begin
      ms := G2MatScaling(_Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Scaling);
      mr := G2MatRotation(_Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Rotation);
      mt := G2MatTranslation(_Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Translation);
      Transforms[_Mesh.Anims[AnimIndex]^.Nodes[i].NodeID].TransformCur := ms * mr * mt;
    end;
    if _AutoComputeTransforms then ComputeTransforms;
  end;
end;

procedure TG2LegacyMeshInst.FrameSet(const AnimName: AnsiString; const Frame: TG2Float);
  var AnimIndex, i, f0, f1: TG2IntS32;
  var f: TG2Float;
  var s0: TG2Vec3;
  var r0: TG2Quat;
  var t0: TG2Vec3;
  var ms, mr, mt: TG2Mat;
begin
  AnimIndex := _Mesh.AnimIndex(AnimName);
  if AnimIndex > -1 then
  begin
    if Frame < 0 then
    f := _Mesh.Anims[AnimIndex]^.FrameCount - (Trunc(Abs(Frame)) mod _Mesh.Anims[AnimIndex]^.FrameCount) + Frac(Frame)
    else
    f := Frame;
    f0 := Trunc(f) mod _Mesh.Anims[AnimIndex]^.FrameCount;
    f1 := (f0 + 1) mod _Mesh.Anims[AnimIndex]^.FrameCount;
    f := Frac(f);
    for i := 0 to _Mesh.Anims[AnimIndex]^.NodeCount - 1 do
    begin
      s0 := G2LerpVec3(
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Scaling,
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f1].Scaling,
        f
      );
      r0 := G2QuatSlerp(
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Rotation,
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f1].Rotation,
        f
      );
      t0 := G2LerpVec3(
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f0].Translation,
        _Mesh.Anims[AnimIndex]^.Nodes[i].Frames[f1].Translation,
        f
      );
      ms := G2MatScaling(s0);
      mr := G2MatRotation(r0);
      mt := G2MatTranslation(t0);
      Transforms[_Mesh.Anims[AnimIndex]^.Nodes[i].NodeID].TransformCur := ms * mr * mt;
    end;
    if _AutoComputeTransforms then ComputeTransforms;
  end;
end;

procedure TG2LegacyMeshInst.ComputeTransforms;
  procedure ComputeNode(const NodeID: TG2IntS32);
    var i: TG2IntS32;
  begin
    if _Mesh.Nodes[NodeID]^.OwnerID > -1 then
    Transforms[NodeID].TransformCom := Transforms[NodeID].TransformCur * Transforms[_Mesh.Nodes[NodeID]^.OwnerID].TransformCom
    else
    Transforms[NodeID].TransformCom := Transforms[NodeID].TransformCur;
    for i := 0 to _Mesh.Nodes[NodeID]^.SubNodesID.Count - 1 do
    ComputeNode(_Mesh.Nodes[NodeID]^.SubNodesID[i]);
  end;
  var i: TG2IntS32;
begin
  for i := 0 to _RootNodes.Count - 1 do
  ComputeNode(_RootNodes[i]);
  ComputeSkinTransforms;
end;

procedure TG2LegacyMeshInst.Render(const W, V, P: TG2Mat);
begin
  g2.Gfx.LegacyMesh.RenderInstance(Self, W, V, P);
end;
//TG2LegacyMeshInst END

//TG2GameState BEGIN
class constructor TG2GameState.CreateClass;
begin
  List := nil;
end;

class destructor TG2GameState.DestroyClass;
begin
  while List <> nil do List.Free;
end;

procedure TG2GameState.SetEnabled(const Value: Boolean);
begin
  if _Enabled = Value then Exit;
  _Enabled := Value;
  if _State <> nil then
  _State.SetEnabled(_Enabled);
end;

procedure TG2GameState.SetState(const Value: TG2GameState);
begin
  if _State = Value then Exit;
  if _State <> nil then
  begin
    _State.OnLeave(Value);
    _State.SetEnabled(False);
  end;
  if Value <> nil then
  begin
    Value.SetEnabled(True);
    Value.OnEnter(_State);
  end;
  _State := Value;
end;

procedure TG2GameState.SetRenderOrder(const Value: TG2Float);
begin
  if Value <> _RenderOrder then
  begin
    _RenderOrder := Value;
    g2.CallbackRenderRemove(@Render);
    g2.CallbackRenderAdd(@Render, _RenderOrder);
  end;
end;

procedure TG2GameState.Initialize;
begin
  OnInitialize;
end;

procedure TG2GameState.Finalize;
begin
  State := nil;
  OnFinalize;
end;

procedure TG2GameState.Update;
begin
  if _SwitchState <> _State then
  SetState(_SwitchState);
  if _Enabled then OnUpdate;
end;

procedure TG2GameState.Render;
begin
  if _Enabled then OnRender;
end;

procedure TG2GameState.KeyDown(const Key: Integer);
begin
  if _Enabled then OnKeyDown(Key);
end;

procedure TG2GameState.KeyUp(const Key: Integer);
begin
  if _Enabled then OnKeyUp(Key);
end;

procedure TG2GameState.MouseDown(const Button, x, y: Integer);
begin
  if _Enabled then OnMouseDown(Button, x, y);
end;

procedure TG2GameState.MouseUp(const Button, x, y: Integer);
begin
  if _Enabled then OnMouseUp(Button, x, y);
end;

procedure TG2GameState.Scroll(const y: Integer);
begin
  if _Enabled then OnScroll(y);
end;

procedure TG2GameState.Print(const c: AnsiChar);
begin
  if _Enabled then OnPrint(c);
end;

procedure TG2GameState.OnInitialize;
begin

end;

procedure TG2GameState.OnFinalize;
begin

end;

procedure TG2GameState.OnRender;
begin

end;

procedure TG2GameState.OnUpdate;
begin

end;

procedure TG2GameState.OnKeyDown(const Key: Integer);
begin

end;

procedure TG2GameState.OnKeyUp(const Key: Integer);
begin

end;

procedure TG2GameState.OnMouseDown(const Button, x, y: Integer);
begin

end;

procedure TG2GameState.OnMouseUp(const Button, x, y: Integer);
begin

end;

procedure TG2GameState.OnScroll(const y: Integer);
begin

end;

procedure TG2GameState.OnPrint(const c: AnsiChar);
begin

end;

procedure TG2GameState.OnEnter(const PrevState: TG2GameState);
begin

end;

procedure TG2GameState.OnLeave(const NextState: TG2GameState);
begin

end;

constructor TG2GameState.Create;
begin
  inherited Create;
  _State := nil;
  _Enabled := False;
  _RenderOrder := 0;
  g2.CallbackRenderAdd(@Render, _RenderOrder);
  g2.CallbackUpdateAdd(@Update);
  g2.CallbackKeyDownAdd(@KeyDown);
  g2.CallbackKeyUpAdd(@KeyUp);
  g2.CallbackMouseDownAdd(@MouseDown);
  g2.CallbackMouseUpAdd(@MouseUp);
  g2.CallbackPrintAdd(@Print);
  g2.CallbackScrollAdd(@Scroll);
  if List = nil then
  begin
    List := Self;
    Next := nil;
    Prev := nil;
    SetEnabled(True);
  end
  else
  begin
    Next := List;
    Prev := nil;
    List.Prev := Self;
    List := Self;
  end;
  Initialize;
end;

destructor TG2GameState.Destroy;
begin
  Finalize;
  State := nil;
  g2.CallbackRenderRemove(@Render);
  g2.CallbackUpdateRemove(@Update);
  g2.CallbackKeyDownRemove(@KeyDown);
  g2.CallbackKeyUpRemove(@KeyUp);
  g2.CallbackMouseDownRemove(@MouseDown);
  g2.CallbackMouseUpRemove(@MouseUp);
  g2.CallbackPrintRemove(@Print);
  g2.CallbackScrollRemove(@Scroll);
  if Prev <> nil then
  Prev.Next := Next;
  if Next <> nil then
  Next.Prev := Prev;
  if List = Self then
  List := Next;
  inherited Destroy;
end;
//TG2GameState END

{$if defined(G2Target_Android)}
type timeval = packed record
 tv_sec: TG2IntU32;
 tv_usec: TG2IntU32;
end;
function gettimeofday(timeval, timezone: Pointer): TG2IntS32; cdecl; external 'libc';
{$endif}

function G2Time: TG2IntU32;
{$if defined(G2Target_Android)}
  var CurTimeVal: timeval;
{$endif}
begin
  {$if defined(G2Target_Windows)}
  Result := {%H-}GetTickCount;
  {$elseif defined(G2Target_Linux) or defined(G2Target_OSX)}
  Result := TG2IntU32(Trunc(Now * 24 * 60 * 60 * 1000));
  {$elseif defined(G2Target_Android)}
  gettimeofday(@CurTimeVal, nil);
  Result := CurTimeVal.tv_sec * 1000 + CurTimeVal.tv_usec div 1000;
  {$elseif defined(G2Target_iOS)}
  Result := TG2IntU32(Trunc(CACurrentMediaTime * 1000));
  {$endif}
end;

function G2PiTime(Amp: TG2Float = 1000): TG2Float;
begin
  Result := (G2Time mod Round(G2TwoPi * Amp)) / (Amp);
end;

function G2PiTime(Amp: TG2Float; Time: TG2IntU32): TG2Float;
begin
  Result := (Time mod Round(G2TwoPi * Amp)) / (Amp);
end;

function G2TimeInterval(Interval: TG2IntU32 = 1000): TG2Float;
begin
  Result := (G2Time mod Interval) / Interval;
end;

function G2TimeInterval(Interval: TG2IntU32; Time: TG2IntU32): TG2Float;
begin
  Result := (Time mod Interval) / Interval;
end;

function G2RandomPi: TG2Float;
begin
  {$ifdef G2Target_OSX}
  Result := Random * Pi;
  {$else}
  Result := Random(Round(Pi * 1000)) / 1000;
  {$endif}
end;

function G2Random2Pi: TG2Float;
begin
  Result := System.Random(Round(G2TwoPi * 1000)) / 1000;
end;

function G2RandomCirclePoint: TG2Vec2;
  var a: TG2Float;
begin
  a := G2Random2Pi;
  G2SinCos(a, Result{%H-}.y, Result{%H-}.x);
end;

function G2RandomSpherePoint: TG2Vec3;
  var a1, a2, s1, s2, c1, c2: TG2Float;
begin
  a1 := G2Random2Pi;
  a2 := G2Random2Pi;
  G2SinCos(a1, s1{%H-}, c1{%H-});
  G2SinCos(a2, s2{%H-}, c2{%H-});
  {$Warnings off}
  Result.SetValue(c1 * c2, s2, s1 * c2);
  {$Warnings on}
end;

function G2RectInRect(const R0, R1: TRect): Boolean;
begin
  Result := (
    (R0.Left <= R1.Right)
    and (R0.Right >= R1.Left)
    and (R0.Top <= R1.Bottom)
    and (R0.Bottom >= R1.Top)
  );
end;

function G2RectInRect(const R0, R1: TG2Rect): Boolean;
begin
  Result := (
    (R0.l <= R1.r)
    and (R0.r >= R1.l)
    and (R0.t <= R1.b)
    and (R0.b >= R1.t)
  );
end;

function G2KeyName(const Key: TG2IntS32): AnsiString;
  const NameMap: array[0..102] of AnsiString = (
    'Escape', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9',
    'F10', 'F11', 'F12', 'Scroll Lock', 'Pause', 'Tilda', '1', '2', '3', '4',
    '5', '6', '7', '8', '9', '0', 'Minus', 'Plus', 'Backspace', 'Tab',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V', 'W', 'X', 'Y', 'Z', 'Left Braket', 'Right Braket', 'Semicolon', 'Quote',
    'Comma', 'Period', 'Slash', 'Reverse Slash', 'Caps Lock', 'Shift', 'Shift', 'Control', 'Control', 'Win',
    'Win', 'Alt', 'Alt', 'Menu', 'Return', 'Space', 'Insert', 'Home', 'Page Up', 'Delete',
    'End', 'Page Down', 'Up', 'Down', 'Left', 'Right', 'Num Lock', 'NumDiv', 'NumMul', 'NumMinus',
    'NumPlus', 'NumReturn', 'NumPeriod', 'Num0', 'Num1', 'Num2', 'Num3', 'Num4', 'Num5', 'Num6',
    'Num7', 'Num8', 'Num9'
  );
begin
  if (Key >= 0) and (Key <= High(NameMap)) then Result := NameMap[Key] else Result := 'Undefined';
end;

procedure G2TraceBegin;
begin
  TraceTime := G2Time;
end;

function G2TraceEnd: TG2IntU32;
begin
  Result := G2Time - TraceTime;
end;

{$if defined(G2Cpu386)}
procedure G2BreakPoint;
asm
  int 3;
end;
{$endif}

procedure SafeRelease(var i);
begin
  if IUnknown(i) <> nil then IUnknown(i) := nil;
end;

procedure G2RegisterSerializable(const SerializableClass: TClass);
  var i: TG2IntS32;
begin
  for i := 0 to High(G2Serializable) do
  if G2Serializable[i] = SerializableClass then
  Exit;
  SetLength(G2Serializable, Length(G2Serializable) + 1);
  G2Serializable[High(G2Serializable)] := SerializableClass;
end;

procedure G2SerializeToStream(const Obj: TObject; const Stream: TStream);
  var n: TG2IntU8;
  var Intf: IG2Serializable;
begin
  if Obj.GetInterfaceByStr(IG2SerializableGUID, Intf) then
  begin
    n := Length(Obj.ClassName);
    Stream.Write(n, SizeOf(n));
    Stream.Write(Obj.ClassName[1], n);
    Intf.Serialize(Stream);
  end;
end;

function G2SerializeFromStream(const Stream: TStream): TObject;
  var i: TG2IntS32;
  var InitPos: TG2IntS64;
  var n: TG2IntU8;
  var ClassName: AnsiString;
  var Intf: IG2Serializable;
begin
  InitPos := Stream.Position;
  if Stream.Position > Stream.Size - 1 then Exit(nil);
  Stream.Read(n{%H-}, SizeOf(n));
  if Stream.Position > Stream.Size - n then
  begin
    Stream.Position := InitPos;
    Exit(nil);
  end;
  SetLength(ClassName, n);
  Stream.Read(ClassName[1], n);
  for i := 0 to High(G2Serializable) do
  if G2Serializable[i].ClassName = ClassName then
  begin
    Result := G2Serializable[i].Create;
    if Result.GetInterfaceByStr(IG2SerializableGUID, Intf) then
    begin
      Intf.Deserialize(Stream);
      Exit;
    end
    else
    Result.Free;
  end;
  Stream.Position := InitPos;
  Result := nil;
end;

initialization
begin
  {$if not defined(G2Target_Mobile)}
  G2Initialize;
  {$endif}
end;

finalization
begin
  {$if not defined(G2Target_Mobile)}
  G2Finalize;
  {$endif}
end;

end.
