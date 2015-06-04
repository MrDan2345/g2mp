program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Windows,
  Classes,
  G2Math,
  G2Utils,
  G2DataManager,
  G2OpenGL;

{$R *.res}

type
  TG2ShaderParam = record
    ParamType: Byte;
    Name: AnsiString;
    Pos: Integer;
    Size: Integer;
  end;

  TG2ShaderData = object
    Name: AnsiString;
    SourceHLSL: Pointer;
    SourceHLSLSize: Integer;
    SourceGLSL: Pointer;
    SourceGLSLSize: Integer;
    BinD3D: Pointer;
    BinD3DSize: Integer;
    BinOGL: Pointer;
    BinOGLSize: Integer;
    Params: array of TG2ShaderParam;
    function ParamIndex(const ParamName: AnsiString): Integer;
  end;
  PG2ShaderData = ^TG2ShaderData;

  TG2ShaderMethodData = record
    Name: AnsiString;
    VertexShaderID: Integer;
    PixelShaderID: Integer;
  end;
  PG2ShaderMethodData = ^TG2ShaderMethodData;

  TG2ShaderGroupHeader = packed record
    Definition: array[0..3] of AnsiChar;
    Version: Word;
    MethodCount: Integer;
    VertexShaderCount: Integer;
    PixelShaderCount: Integer;
  end;

  TG2ShaderGroupData = object
  private
    _VertexShaders: array of TG2ShaderData;
    _PixelShaders: array of TG2ShaderData;
    _Methods: array of TG2ShaderMethodData;
    function GetVertexShader(const Index: Integer): PG2ShaderData;
    function GetVertexShaderCount: Integer;
    function GetPixelShader(const Index: Integer): PG2ShaderData;
    function GetPixelShaderCount: Integer;
    function GetMethod(const Index: Integer): PG2ShaderMethodData;
    function GetMethodCount: Integer;
  public
    property VertexShaders[const Index: Integer]: PG2ShaderData read GetVertexShader;
    property VertexShaderCount: Integer read GetVertexShaderCount;
    property PixelShaders[const Index: Integer]: PG2ShaderData read GetPixelShader;
    property PixelShaderCount: Integer read GetPixelShaderCount;
    property Methods[const Index: Integer]: PG2ShaderMethodData read GetMethod;
    property MethodCount: Integer read GetMethodCount;
    function VertexShaderIndex(const Name: AnsiString): Integer;
    function PixelShaderIndex(const Name: AnsiString): Integer;
    function MethodIndex(const Name: AnsiString): Integer;
    procedure Clear;
    procedure Save(const dm: TG2DataManager);
    procedure Load(const dm: TG2DataManager);
  end;

  TVertex = packed record
    Pos: TG2Vec3;
    Color: TG2Vec4;
  end;

var WindowHandle: HWND;
var AppRunning: Boolean;
var Context: HGLRC;
var DC: HDC;
var VB: GLUint;
var IB: GLUint;
var ShaderGroup: TG2ShaderGroupData;
var ShaderProgram: GLHandle;
var VertexShader: GLHandle;
var PixelShader: GLHandle;

//TG2ShaderData BEGIN
function TG2ShaderData.ParamIndex(const ParamName: AnsiString): Integer;
  var i: Integer;
begin
  for i := 0 to High(Params) do
  if Params[i].Name = ParamName then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;
//TG2ShaderData END

//TG2ShaderGroupData BEGIN
function TG2ShaderGroupData.GetVertexShader(const Index: Integer): PG2ShaderData;
begin
  Result := @_VertexShaders[Index];
end;

function TG2ShaderGroupData.GetVertexShaderCount: Integer;
begin
  Result := Length(_VertexShaders);
end;

function TG2ShaderGroupData.GetPixelShader(const Index: Integer): PG2ShaderData;
begin
  Result := @_PixelShaders[Index];
end;

function TG2ShaderGroupData.GetPixelShaderCount: Integer;
begin
  Result := Length(_PixelShaders);
end;

function TG2ShaderGroupData.GetMethod(const Index: Integer): PG2ShaderMethodData;
begin
  Result := @_Methods[Index];
end;

function TG2ShaderGroupData.GetMethodCount: Integer;
begin
  Result := Length(_Methods);
end;

function TG2ShaderGroupData.VertexShaderIndex(const Name: AnsiString): Integer;
  var i: Integer;
begin
  for i := 0 to High(_VertexShaders) do
  if _VertexShaders[i].Name = Name then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;

function TG2ShaderGroupData.PixelShaderIndex(const Name: AnsiString): Integer;
  var i: Integer;
begin
  for i := 0 to High(_PixelShaders) do
  if _PixelShaders[i].Name = Name then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;

function TG2ShaderGroupData.MethodIndex(const Name: AnsiString): Integer;
  var i: Integer;
begin
  for i := 0 to High(_Methods) do
  if _Methods[i].Name = Name then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;

procedure TG2ShaderGroupData.Clear;
  var i: Integer;
begin
  for i := 0 to High(_VertexShaders) do
  begin
    if _VertexShaders[i].SourceHLSLSize > 0 then
    begin
      FreeMem(_VertexShaders[i].SourceHLSL, _VertexShaders[i].SourceHLSLSize);
      _VertexShaders[i].SourceHLSLSize := 0;
    end;
    if _VertexShaders[i].SourceGLSLSize > 0 then
    begin
      FreeMem(_VertexShaders[i].SourceGLSL, _VertexShaders[i].SourceGLSLSize);
      _VertexShaders[i].SourceGLSLSize := 0;
    end;
    if _VertexShaders[i].BinD3DSize > 0 then
    begin
      FreeMem(_VertexShaders[i].BinD3D, _VertexShaders[i].BinD3DSize);
      _VertexShaders[i].BinD3DSize := 0;
    end;
    if _VertexShaders[i].BinOGLSize > 0 then
    begin
      FreeMem(_VertexShaders[i].BinOGL, _VertexShaders[i].BinOGLSize);
      _VertexShaders[i].BinOGLSize := 0;
    end;
  end;
  _VertexShaders := nil;
  for i := 0 to High(_PixelShaders) do
  begin
    if _PixelShaders[i].SourceHLSLSize > 0 then
    begin
      FreeMem(_PixelShaders[i].SourceHLSL, _PixelShaders[i].SourceHLSLSize);
      _PixelShaders[i].SourceHLSLSize := 0;
    end;
    if _PixelShaders[i].SourceGLSLSize > 0 then
    begin
      FreeMem(_PixelShaders[i].SourceGLSL, _PixelShaders[i].SourceGLSLSize);
      _PixelShaders[i].SourceGLSLSize := 0;
    end;
    if _PixelShaders[i].BinD3DSize > 0 then
    begin
      FreeMem(_PixelShaders[i].BinD3D, _PixelShaders[i].BinD3DSize);
      _PixelShaders[i].BinD3DSize := 0;
    end;
    if _PixelShaders[i].BinOGLSize > 0 then
    begin
      FreeMem(_PixelShaders[i].BinOGL, _PixelShaders[i].BinOGLSize);
      _PixelShaders[i].BinOGLSize := 0;
    end;
  end;
  _PixelShaders := nil;
  _Methods := nil;
end;

procedure TG2ShaderGroupData.Save(const dm: TG2DataManager);
  procedure WriteParams(const Shader: PG2ShaderData);
    var i: Integer;
  begin
    dm.WriteIntS32(Length(Shader^.Params));
    for i := 0 to High(Shader^.Params) do
    begin
      dm.WriteIntU8(Shader^.Params[i].ParamType);
      dm.WriteStringA(Shader^.Params[i].Name);
      dm.WriteIntS32(Shader^.Params[i].Pos);
      dm.WriteIntS32(Shader^.Params[i].Size);
    end;
  end;
  var Header: TG2ShaderGroupHeader;
  var i: Integer;
begin
  Header.Definition := 'G2SG';
  Header.Version := $0100;
  Header.MethodCount := Length(_Methods);
  Header.VertexShaderCount := Length(_VertexShaders);
  Header.PixelShaderCount := Length(_PixelShaders);
  dm.WriteBuffer(@Header, SizeOf(Header));
  dm.Codec := cdZLib;
  for i := 0 to High(_VertexShaders) do
  begin
    dm.WriteStringA(_VertexShaders[i].Name);
    dm.WriteIntS32(_VertexShaders[i].SourceHLSLSize);
    dm.WriteBuffer(_VertexShaders[i].SourceHLSL, _VertexShaders[i].SourceHLSLSize);
    dm.WriteIntS32(_VertexShaders[i].SourceGLSLSize);
    dm.WriteBuffer(_VertexShaders[i].SourceGLSL, _VertexShaders[i].SourceGLSLSize);
    dm.WriteIntS32(_VertexShaders[i].BinD3DSize);
    dm.WriteBuffer(_VertexShaders[i].BinD3D, _VertexShaders[i].BinD3DSize);
    dm.WriteIntS32(_VertexShaders[i].BinOGLSize);
    dm.WriteBuffer(_VertexShaders[i].BinOGL, _VertexShaders[i].BinOGLSize);
    WriteParams(@_VertexShaders[i]);
  end;
  for i := 0 to High(_PixelShaders) do
  begin
    dm.WriteStringA(_PixelShaders[i].Name);
    dm.WriteIntS32(_PixelShaders[i].SourceHLSLSize);
    dm.WriteBuffer(_PixelShaders[i].SourceHLSL, _PixelShaders[i].SourceHLSLSize);
    dm.WriteIntS32(_PixelShaders[i].SourceGLSLSize);
    dm.WriteBuffer(_PixelShaders[i].SourceGLSL, _PixelShaders[i].SourceGLSLSize);
    dm.WriteIntS32(_PixelShaders[i].BinD3DSize);
    dm.WriteBuffer(_PixelShaders[i].BinD3D, _PixelShaders[i].BinD3DSize);
    dm.WriteIntS32(_PixelShaders[i].BinOGLSize);
    dm.WriteBuffer(_PixelShaders[i].BinOGL, _PixelShaders[i].BinOGLSize);
    WriteParams(@_PixelShaders[i]);
  end;
  for i := 0 to High(_Methods) do
  begin
    dm.WriteStringA(_Methods[i].Name);
    dm.WriteIntS32(_Methods[i].VertexShaderID);
    dm.WriteIntS32(_Methods[i].PixelShaderID);
  end;
end;

procedure TG2ShaderGroupData.Load(const dm: TG2DataManager);
  procedure ReadParams(const Shader: PG2ShaderData);
    var i: Integer;
  begin
    SetLength(Shader^.Params, dm.ReadIntS32);
    for i := 0 to High(Shader^.Params) do
    begin
      Shader^.Params[i].ParamType := dm.ReadIntU8;
      Shader^.Params[i].Name := dm.ReadStringA;
      Shader^.Params[i].Pos := dm.ReadIntS32;
      Shader^.Params[i].Size := dm.ReadIntS32;
    end;
  end;
  var Header: TG2ShaderGroupHeader;
  var i: Integer;
begin
  Clear;
  if dm.Size - dm.Position < SizeOf(Header) then Exit;
  dm.ReadBuffer(@Header, SizeOf(Header));
  if Header.Definition <> 'G2SG' then Exit;
  SetLength(_Methods, Header.MethodCount);
  SetLength(_VertexShaders, Header.VertexShaderCount);
  SetLength(_PixelShaders, Header.PixelShaderCount);
  dm.Codec := cdZLib;
  for i := 0 to High(_VertexShaders) do
  begin
    _VertexShaders[i].Name := dm.ReadStringA;
    _VertexShaders[i].SourceHLSLSize := dm.ReadIntS32;
    _VertexShaders[i].SourceHLSL := G2MemAlloc(_VertexShaders[i].SourceHLSLSize);
    dm.ReadBuffer(_VertexShaders[i].SourceHLSL, _VertexShaders[i].SourceHLSLSize);
    _VertexShaders[i].SourceGLSLSize := dm.ReadIntS32;
    _VertexShaders[i].SourceGLSL := G2MemAlloc(_VertexShaders[i].SourceGLSLSize);
    dm.ReadBuffer(_VertexShaders[i].SourceGLSL, _VertexShaders[i].SourceGLSLSize);
    _VertexShaders[i].BinD3DSize := dm.ReadIntS32;
    _VertexShaders[i].BinD3D := G2MemAlloc(_VertexShaders[i].BinD3DSize);
    dm.ReadBuffer(_VertexShaders[i].BinD3D, _VertexShaders[i].BinD3DSize);
    _VertexShaders[i].BinOGLSize := dm.ReadIntS32;
    _VertexShaders[i].BinOGL := G2MemAlloc(_VertexShaders[i].BinOGLSize);
    dm.ReadBuffer(_VertexShaders[i].BinOGL, _VertexShaders[i].BinOGLSize);
    ReadParams(@_VertexShaders[i]);
  end;
  for i := 0 to High(_PixelShaders) do
  begin
    _PixelShaders[i].Name := dm.ReadStringA;
    _PixelShaders[i].SourceHLSLSize := dm.ReadIntS32;
    _PixelShaders[i].SourceHLSL := G2MemAlloc(_PixelShaders[i].SourceHLSLSize);
    dm.ReadBuffer(_PixelShaders[i].SourceHLSL, _PixelShaders[i].SourceHLSLSize);
    _PixelShaders[i].SourceGLSLSize := dm.ReadIntS32;
    _PixelShaders[i].SourceGLSL := G2MemAlloc(_PixelShaders[i].SourceGLSLSize);
    dm.ReadBuffer(_PixelShaders[i].SourceGLSL, _PixelShaders[i].SourceGLSLSize);
    _PixelShaders[i].BinD3DSize := dm.ReadIntS32;
    _PixelShaders[i].BinD3D := G2MemAlloc(_PixelShaders[i].BinD3DSize);
    dm.ReadBuffer(_PixelShaders[i].BinD3D, _PixelShaders[i].BinD3DSize);
    _PixelShaders[i].BinOGLSize := dm.ReadIntS32;
    _PixelShaders[i].BinOGL := G2MemAlloc(_PixelShaders[i].BinOGLSize);
    dm.ReadBuffer(_PixelShaders[i].BinOGL, _PixelShaders[i].BinOGLSize);
    ReadParams(@_PixelShaders[i]);
  end;
  for i := 0 to High(_Methods) do
  begin
    _Methods[i].Name := dm.ReadStringA;
    _Methods[i].VertexShaderID := dm.ReadIntS32;
    _Methods[i].PixelShaderID := dm.ReadIntS32;
  end;
end;
//TG2ShaderGroupData END

procedure Initialize;
  var Vertices: array[0..3] of TVertex;
  var Indices: array[0..5] of Word;
  var dm: TG2DataManager;
  var MID: Integer;
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

  dm := TG2DataManager.Create('Test.g2sg', dmRead);
  try
    ShaderGroup.Load(dm);
  finally
    dm.Free;
  end;
  MID := ShaderGroup.MethodIndex('Method');

  ShaderProgram := glCreateProgram();
  VertexShader := glCreateShader(GL_VERTEX_SHADER);
  glShaderSource(VertexShader, 1, @ShaderGroup.VertexShaders[ShaderGroup.Methods[MID]^.VertexShaderID]^.BinOGL, @ShaderGroup.VertexShaders[ShaderGroup.Methods[MID]^.VertexShaderID]^.BinOGLSize);
  glCompileShader(VertexShader);
  PixelShader := glCreateShader(GL_FRAGMENT_SHADER);
  glShaderSource(PixelShader, 1, @ShaderGroup.PixelShaders[ShaderGroup.Methods[MID]^.PixelShaderID]^.BinOGL, @ShaderGroup.PixelShaders[ShaderGroup.Methods[MID]^.PixelShaderID]^.BinOGLSize);
  glCompileShader(PixelShader);
  glAttachShader(ShaderProgram, VertexShader);
  glAttachShader(ShaderProgram, PixelShader);
  glLinkProgram(ShaderProgram);
end;

procedure Finalize;
begin
  glDeleteShader(VertexShader);
  glDeleteProgram(ShaderProgram);
end;

procedure OnUpdate;
begin

end;

procedure OnRender;
  var W, V, P, WV, WVP: TG2Mat;
  var DeclPosition, DeclColor, DeclTexCoord: GLInt;
  var UnifWVP: GLInt;
begin
  W := G2MatRotationY(GetTickCount * 0.001);
  V := G2MatView(G2Vec3(0, 5, -5), G2Vec3(0, 0, 0), G2Vec3(0, 1, 0));
  P := G2MatProj(Pi / 4, 1, 1, 100);
  WV := W * V;
  WVP := WV * P;
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

  glUseProgram(ShaderProgram);
  DeclPosition := glGetAttribLocation(ShaderProgram, 'a_Position0');
  DeclColor := glGetAttribLocation(ShaderProgram, 'a_Color0');
  //DeclTexCoord := glGetAttribLocation(ShaderProgram, 'a_TexCoord');

  UnifWVP := glGetUniformLocation(ShaderProgram, 'WVP');
  glUniformMatrix4fv(UnifWVP, 1, True, @WVP);

  glBindBuffer(GL_ARRAY_BUFFER, VB);
  glEnableVertexAttribArray(DeclPosition);
  glVertexAttribPointer(DeclPosition, 3, GL_FLOAT, False, SizeOf(TVertex), Pointer(0));
  glEnableVertexAttribArray(DeclColor);
  glVertexAttribPointer(DeclColor, 4, GL_FLOAT, False, SizeOf(TVertex), Pointer(12));
  //glEnableVertexAttribArray(DeclTexCoord);

  //glEnableClientState(GL_VERTEX_ARRAY);
  //glVertexPointer(3, GL_FLOAT, SizeOf(TVertex), Pointer(0));
  //glEnableClientState(GL_COLOR_ARRAY);
  //glColorPointer(4, GL_FLOAT, SizeOf(TVertex), Pointer(12));
  //
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, IB);
  glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, Pointer(0));

  glDisableVertexAttribArray(DeclPosition);

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

