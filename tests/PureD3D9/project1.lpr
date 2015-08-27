program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Windows,
  Classes,
  G2Math,
  G2DirectX9;

{$R *.res}

var WindowHandle: HWND;
var AppRunning: Boolean;
var D3D9: IDirect3D9;
var Device: IDirect3DDevice9;
var SwapChain: IDirect3DSwapChain9;
var RenderTarget: IDirect3DSurface9;
var DepthStencil: IDirect3DSurface9;
var VB: IDirect3DVertexBuffer9;
var FVF: DWord;

procedure SafeRelease(var i);
begin
  if IUnknown(i) <> nil then IUnknown(i) := nil;
end;

procedure Initialize;
  type TVertex = packed record
    Pos: TG2Vec3;
    Color: DWord;
    TexCoord: TG2Vec2;
  end;
  var Vertices: array[0..3] of TVertex;
  var VBData: Pointer;
begin
  Vertices[0].Pos.SetValue(-1, 1, 0); Vertices[0].Color := $ffffffff; Vertices[0].TexCoord.SetValue(0, 0);
  Vertices[1].Pos.SetValue(1, 1, 0);  Vertices[1].Color := $ffffffff; Vertices[1].TexCoord.SetValue(1, 0);
  Vertices[2].Pos.SetValue(-1, -1, 0);  Vertices[2].Color := $ffffffff; Vertices[2].TexCoord.SetValue(0, 1);
  Vertices[3].Pos.SetValue(1, -1, 0);  Vertices[3].Color := $ffffffff; Vertices[3].TexCoord.SetValue(1, 1);
  FVF := D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1;
  Device.CreateVertexBuffer(
    SizeOf(TVertex) * 4, D3DUSAGE_WRITEONLY,
    FVF,
    D3DPOOL_MANAGED, VB, nil
  );
  VB.Lock(0, SizeOf(TVertex) * 4, VBData, D3DLOCK_DISCARD);
  Move(Vertices, VBData^, SizeOf(TVertex) * 4);
  VB.UnLock;
end;

procedure Finalize;
begin
  SafeRelease(VB);
end;

procedure OnUpdate;
begin

end;

procedure OnRender;
  var W, V, P: TG2Mat;
  var Viewport: TD3DViewport9;
begin
  Device.GetViewport(Viewport);
  Device.SetRenderState(D3DRS_LIGHTING, 0);
  Device.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_SELECTARG1);
  Device.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_DIFFUSE);
  W := G2MatRotationY(GetTickCount * 0.001);
  V := G2MatView(G2Vec3(0, 5, -5), G2Vec3(0, 0, 0), G2Vec3(0, 1, 0));
  P := G2MatProj(Pi / 4, Viewport.Width / Viewport.Height, 1, 100);
  Device.SetTexture(0, nil);
  Device.SetTransform(D3DTS_WORLD, W);
  Device.SetTransform(D3DTS_VIEW, V);
  Device.SetTransform(D3DTS_PROJECTION, P);
  Device.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, TD3DColor($ff808080), 1, 0);
  Device.BeginScene;
  Device.SetStreamSource(0, VB, 0, 24);
  Device.SetFVF(FVF);
  Device.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2);
  Device.EndScene;
  SwapChain.Present(nil, nil, 0, nil, 0);
end;

function MessageHandler(Wnd: HWnd; Msg: UInt; wParam: WPARAM; lParam: LPARAM): LResult; stdcall;
  var w, h: Integer;
  var pp: TD3DPresentParameters;
  var Viewport: TD3DViewport9;
begin
  case Msg of
    WM_DESTROY, WM_QUIT, WM_CLOSE:
    begin
      PostQuitMessage(0);
      Result := 0;
      Exit;
    end;
    WM_KEYDOWN:
    begin
      if wParam = VK_ESCAPE then AppRunning := False;
    end;
    WM_KEYUP:
    begin

    end;
    WM_LBUTTONDOWN:
    begin

    end;
    WM_LBUTTONUP:
    begin

    end;
    WM_RBUTTONDOWN:
    begin

    end;
    WM_RBUTTONUP:
    begin

    end;
    WM_MBUTTONDOWN:
    begin

    end;
    WM_MBUTTONUP:
    begin

    end;
    WM_SIZE:
    begin
      if Device <> nil then
      begin
        Device.GetViewport(Viewport);
        w := lParam and $ffff;
        h := (lParam shr 16) and $ffff;
        Viewport.Width := w;
        Viewport.Height := h;
        ZeroMemory(@pp, SizeOf(pp));
        SwapChain.GetPresentParameters(pp);
        pp.BackBufferWidth := w;
        pp.BackBufferHeight := h;
        Device.SetRenderTarget(0, nil);
        Device.SetDepthStencilSurface(nil);
        SafeRelease(RenderTarget);
        SafeRelease(SwapChain);
        Device.CreateAdditionalSwapChain(pp, SwapChain);
        SwapChain.GetBackBuffer(0, D3DBACKBUFFER_TYPE_MONO, RenderTarget);
        Device.SetRenderTarget(0, RenderTarget);
        Device.SetDepthStencilSurface(DepthStencil);
        Device.SetViewport(Viewport);
      end;
    end;
  end;
  Result := DefWindowProcA(Wnd, Msg, wParam, lParam);
end;

var WndClass: TWndClassExA;
var WndClassName: AnsiString;

procedure CreateWindow(const W, H: Integer; const Caption: AnsiString = 'PureD3D9');
  var R: TRect;
  var WndStyle: DWord;
begin
  WndClassName := 'PureD3D9';
  FillChar(WndClass, SizeOf(TWndClassExA), 0);
  WndClass.cbSize := SizeOf(TWndClassExA);
  WndClass.hIconSm := LoadIcon(MainInstance, 'MAINICON');
  WndClass.hIcon := LoadIcon(MainInstance, 'MAINICON');
  WndClass.hInstance := HInstance;
  WndClass.hCursor := LoadCursor(0, IDC_ARROW);
  WndClass.lpszClassName := PAnsiChar(WndClassName);
  WndClass.style := CS_HREDRAW or CS_VREDRAW or CS_OWNDC or CS_DBLCLKS;
  WndClass.lpfnWndProc := @MessageHandler;
  if RegisterClassExA(WndClass) = 0 then
  WndClassName := 'Static';
  WndStyle := (
    WS_CAPTION or
    WS_THICKFRAME or
    WS_VISIBLE or
    WS_EX_TOPMOST or
    WS_MINIMIZEBOX or
    WS_MAXIMIZEBOX or
    WS_SYSMENU
  );
  R.Left := (GetSystemMetrics(SM_CXSCREEN) - W) div 2;
  R.Right := R.Left + W;
  R.Top := (GetSystemMetrics(SM_CYSCREEN) - H) div 2;
  R.Bottom := R.Top + H;
  AdjustWindowRect(R, WndStyle, False);
  WindowHandle := CreateWindowExA(
    0, PAnsiChar(WndClassName), PAnsiChar(Caption),
    WndStyle,
    R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top,
    0, 0, HInstance, nil
  );
end;

procedure FreeWindow;
begin
  DestroyIcon(WndClass.hIcon);
  DestroyIcon(WndClass.hIconSm);
  DestroyCursor(WndClass.hCursor);
  UnRegisterClassA(PAnsiChar(WndClassName), WndClass.hInstance);
  DestroyWindow(WindowHandle);
end;

procedure CreateDevice;
  var pp: TD3DPresentParameters;
  var R: TRect;
begin
  D3D9 := Direct3DCreate9(D3D_SDK_VERSION);
  GetClientRect(WindowHandle, R);
  ZeroMemory(@pp, SizeOf(pp));
  pp.BackBufferWidth := R.Right - R.Left;
  pp.BackBufferHeight := R.Bottom - R.Top;
  pp.BackBufferFormat := D3DFMT_X8R8G8B8;
  pp.BackBufferCount := 1;
  pp.MultiSampleType := D3DMULTISAMPLE_NONE;
  pp.SwapEffect := D3DSWAPEFFECT_DISCARD;
  pp.hDeviceWindow := WindowHandle;
  pp.Windowed := True;
  pp.EnableAutoDepthStencil := False;
  pp.AutoDepthStencilFormat := D3DFMT_D16;
  pp.PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
  D3D9.CreateDevice(
    0, D3DDEVTYPE_HAL,
    WindowHandle,
    D3DCREATE_SOFTWARE_VERTEXPROCESSING or D3DCREATE_MULTITHREADED,
    @pp,
    Device
  );
  Device.CreateDepthStencilSurface(
    2048,
    2048,
    D3DFMT_D16,
    D3DMULTISAMPLE_NONE,
    0,
    True,
    DepthStencil,
    nil
  );
  Device.CreateAdditionalSwapChain(pp, SwapChain);
  SwapChain.GetBackBuffer(0, D3DBACKBUFFER_TYPE_MONO, RenderTarget);
  Device.SetRenderTarget(0, RenderTarget);
  Device.SetDepthStencilSurface(DepthStencil);
  Device.SetRenderState(D3DRS_ALPHABLENDENABLE, 1);
  Device.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
  Device.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
  Device.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, 0);
  Device.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
  Device.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_DIFFUSE);
  Device.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_TEXTURE);
  Device.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
  Device.SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_DIFFUSE);
  Device.SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_TEXTURE);
end;

procedure FreeDevice;
begin
  SafeRelease(DepthStencil);
  SafeRelease(RenderTarget);
  SafeRelease(SwapChain);
  SafeRelease(Device);
  SafeRelease(D3D9);
end;

procedure Loop;
  var msg: TMsg;
begin
  AppRunning := True;
  FillChar(msg, SizeOf(msg), 0);
  while AppRunning
  and (msg.message <> WM_QUIT)
  and (msg.message <> WM_DESTROY)
  and (msg.message <> WM_CLOSE) do
  begin
    if PeekMessage(msg, 0, 0, 0, PM_REMOVE) then
    begin
      TranslateMessage(msg);
      DispatchMessage(msg);
    end
    else
    begin
      OnUpdate;
      OnRender;
    end
  end;
  ExitCode := 0;
end;

begin
  CreateWindow(800, 600);
  CreateDevice;
  Initialize;
  Loop;
  Finalize;
  FreeDevice;
  FreeWindow;
end.

