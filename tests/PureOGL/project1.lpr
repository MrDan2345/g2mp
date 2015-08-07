program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Windows,
  Classes,
  G2Math,
  G2OpenGL;

{$R *.res}

type TVertex = packed record
  Pos: TG2Vec3;
  Color: TG2Vec4;
end;

var WindowHandle: HWND;
var AppRunning: Boolean;
var Context: HGLRC;
var DC: HDC;
var VB: GLUint;
var IB: GLUint;


procedure Initialize;
  var Vertices: array[0..3] of TVertex;
  var Indices: array[0..5] of Word;
  //var VBData: Pointer;
begin
  Vertices[0].Pos.SetValue(-2, 2, 0); Vertices[0].Color.SetValue(1, 0, 0, 1);
  Vertices[1].Pos.SetValue(2, 2, 0); Vertices[1].Color.SetValue(0, 1, 0, 1);
  Vertices[2].Pos.SetValue(-2, -2, 0); Vertices[2].Color.SetValue(0, 0, 1, 1);
  Vertices[3].Pos.SetValue(2, -2, 0); Vertices[3].Color.SetValue(1, 1, 0, 1);
  glGenBuffers(1, @VB);
  glBindBuffer(GL_ARRAY_BUFFER, VB);
  glBufferData(GL_ARRAY_BUFFER, Sizeof(TVertex) * 4, @Vertices, GL_STATIC_DRAW);

  Indices[0] := 0; Indices[1] := 1; Indices[2] := 2;
  Indices[3] := 2; Indices[4] := 1; Indices[5] := 3;
  glGenBuffers(1, @IB);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, IB);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, SizeOf(Word) * 6, @Indices, GL_STATIC_DRAW);

  //Vertices[0].Pos.SetValue(-1, 1, 0); Vertices[0].Color := $ffffffff; Vertices[0].TexCoord.SetValue(0, 0);
  //Vertices[1].Pos.SetValue(1, 1, 0);  Vertices[1].Color := $ffffffff; Vertices[1].TexCoord.SetValue(1, 0);
  //Vertices[2].Pos.SetValue(-1, -1, 0);  Vertices[2].Color := $ffffffff; Vertices[2].TexCoord.SetValue(0, 1);
  //Vertices[3].Pos.SetValue(1, -1, 0);  Vertices[3].Color := $ffffffff; Vertices[3].TexCoord.SetValue(1, 1);
  //FVF := D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1;
  //Device.CreateVertexBuffer(
  //  SizeOf(TVertex) * 4, D3DUSAGE_WRITEONLY,
  //  FVF,
  //  D3DPOOL_MANAGED, VB, nil
  //);
  //VB.Lock(0, SizeOf(TVertex) * 4, VBData, D3DLOCK_DISCARD);
  //Move(Vertices, VBData^, SizeOf(TVertex) * 4);
  //VB.UnLock;
end;

procedure Finalize;
begin

end;

procedure OnUpdate;
begin

end;

procedure OnRender;
  var W, V, P, WV: TG2Mat;
begin
  W := G2MatRotationY(GetTickCount * 0.001);
  V := G2MatView(G2Vec3(0, 5, -5), G2Vec3(0, 0, 0), G2Vec3(0, 1, 0));
  P := G2MatProj(Pi / 4, 1, 1, 100);
  WV := W * V;
  glMatrixMode(GL_MODELVIEW);
  glLoadMatrixf(@WV);
  glMatrixMode(GL_PROJECTION);
  glLoadMatrixf(@P);
  glClear(GL_COLOR_BUFFER_BIT);

  //glBegin(GL_QUADS);
  //glColor4f(1, 0, 0, 1); glVertex3f(-2, 2, 0);
  //glColor4f(0, 1, 0, 1); glVertex3f(2, 2, 0);
  //glColor4f(0, 0, 1, 1); glVertex3f(2, -2, 0);
  //glColor4f(1, 1, 0, 1); glVertex3f(-2, -2, 0);
  //glEnd;

  glBindBuffer(GL_ARRAY_BUFFER, VB);
  glEnableClientState(GL_VERTEX_ARRAY);
  glVertexPointer(3, GL_FLOAT, SizeOf(TVertex), Pointer(0));
  glEnableClientState(GL_COLOR_ARRAY);
  glColorPointer(4, GL_FLOAT, SizeOf(TVertex), Pointer(12));

  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, IB);
  glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, Pointer(0));

  SwapBuffers(DC);
end;

function MessageHandler(Wnd: HWnd; Msg: UInt; wParam: WPARAM; lParam: LPARAM): LResult; stdcall;
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
  end;
  Result := DefWindowProcA(Wnd, Msg, wParam, lParam);
end;

procedure CreateWindow(const W, H: Integer; const Caption: AnsiString = 'PureOGL');
  var WndClass: TWndClassExA;
  var WndClassName: AnsiString;
  var R: TRect;
  var WndStyle: DWord;
begin
  WndClassName := 'PureOGL';
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
    WS_POPUP or
    WS_VISIBLE or
    WS_EX_TOPMOST or
    WS_MINIMIZEBOX or
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
  DestroyWindow(WindowHandle);
end;

procedure CreateDevice;
  var pfd: TPixelFormatDescriptor;
  var pf: Integer;
  var R: TRect;
begin
  DC := GetDC(WindowHandle);
  FillChar(pfd, SizeOf(pfd), 0);
  pfd.nSize := SizeOf(pfd);
  pfd.nVersion := 1;
  pfd.dwFlags := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  pfd.iPixelType := PFD_TYPE_RGBA;
  pfd.cColorBits := 32;
  pfd.cAlphaBits := 8;
  pfd.cDepthBits := 16;
  pfd.iLayerType := PFD_MAIN_PLANE;
  pf := ChoosePixelFormat(DC, @pfd);
  SetPixelFormat(DC, pf, @pfd);
  Context := wglCreateContext(DC);
  wglMakeCurrent(DC, Context);
  InitOpenGL;
  GetClientRect(WindowHandle, R);
  glViewport(0, 0, R.Right - R.Left, R.Bottom - R.Top);
  glClearColor(0.5, 0.5, 0.5, 1);
  glClearDepth(1);
  glEnable(GL_TEXTURE_2D);
  glShadeModel(GL_SMOOTH);
  glDisable(GL_CULL_FACE);
  glEnable(GL_BLEND);
end;

procedure FreeDevice;
begin
  UnInitOpenGL;
  wglMakeCurrent(DC, Context);
  wglDeleteContext(Context);
  ReleaseDC(WindowHandle, DC);
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

