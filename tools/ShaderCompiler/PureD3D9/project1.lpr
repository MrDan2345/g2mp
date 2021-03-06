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
  G2DirectX9;

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

var WindowHandle: HWND;
var AppRunning: Boolean;
var D3D9: IDirect3D9;
var Device: IDirect3DDevice9;
var VB: IDirect3DVertexBuffer9;
var VertexShader: IDirect3DVertexShader9;
var PixelShader: IDirect3DPixelShader9;
var Decl: IDirect3DVertexDeclaration9;
var FVF: DWord;
var ShaderGroup: TG2ShaderGroupData;

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

function VEDecl(
    Stream:     Word;
    Offset:     Word;
    _Type:      TD3DDeclType;
    Method:     TD3DDeclMethod;
    Usage:      TD3DDeclUsage;
    UsageIndex: byte
  ): TD3DVertexElement9;
begin
  result.Stream:=Stream;
  result.Offset:=Offset;
  result._Type:=_Type;
  result.Method:=Method;
  result.Usage:=Usage;
  result.UsageIndex:=UsageIndex;
end;

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
  var de: array[0..3] of TD3DVertexElement9;
  var Vertices: array[0..3] of TVertex;
  var VBData: Pointer;
  var dm: TG2DataManager;
  var MID: Integer;
begin
  Vertices[0].Pos.SetValue(-1, 1, 0); Vertices[0].Color := $ffff0000; Vertices[0].TexCoord.SetValue(0, 0);
  Vertices[1].Pos.SetValue(1, 1, 0);  Vertices[1].Color := $ff00ff00; Vertices[1].TexCoord.SetValue(1, 0);
  Vertices[2].Pos.SetValue(-1, -1, 0);  Vertices[2].Color := $ff0000ff; Vertices[2].TexCoord.SetValue(0, 1);
  Vertices[3].Pos.SetValue(1, -1, 0);  Vertices[3].Color := $ffffff00; Vertices[3].TexCoord.SetValue(1, 1);
  FVF := D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1;
  Device.CreateVertexBuffer(
    SizeOf(TVertex) * 4, D3DUSAGE_WRITEONLY,
    0,
    D3DPOOL_MANAGED, VB, nil
  );
  VB.Lock(0, SizeOf(TVertex) * 4, VBData, D3DLOCK_DISCARD);
  Move(Vertices, VBData^, SizeOf(TVertex) * 4);
  VB.UnLock;
  de[0] := VEDecl(0, 0, D3DDECLTYPE_FLOAT3, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_POSITION, 0);
  de[1] := VEDecl(0, 12, D3DDECLTYPE_D3DCOLOR, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_COLOR, 0);
  de[2] := VEDecl(0, 16, D3DDECLTYPE_FLOAT2, D3DDECLMETHOD_DEFAULT, D3DDECLUSAGE_TEXCOORD, 0);
  de[3] := D3DDECL_END;
  //de[0]._Type := D3DDECLTYPE_FLOAT3; de[0].Method := D3DDECLMETHOD_DEFAULT; de[0].Stream := 0; de[0].Usage := D3DDECLUSAGE_POSITION; de[0].UsageIndex := 0; de[0].Offset := 0;
  //de[1]._Type := D3DDECLTYPE_D3DCOLOR; de[1].Method := D3DDECLMETHOD_DEFAULT; de[1].Stream := 0; de[1].Usage := D3DDECLUSAGE_COLOR; de[1].UsageIndex := 0; de[1].Offset := 12;
  //de[2]._Type := D3DDECLTYPE_FLOAT2; de[2].Method := D3DDECLMETHOD_DEFAULT; de[2].Stream := 0; de[2].Usage := D3DDECLUSAGE_TEXCOORD; de[2].UsageIndex := 0; de[2].Offset := 16;
  //de[3] := D3DDECL_END;
  Device.CreateVertexDeclaration(@de, Decl);
  dm := TG2DataManager.Create('Test.g2sg', dmRead);
  try
    ShaderGroup.Load(dm);
  finally
    dm.Free;
  end;
  MID := ShaderGroup.MethodIndex('Method');
  Device.CreateVertexShader(ShaderGroup.VertexShaders[ShaderGroup.Methods[MID]^.VertexShaderID]^.BinD3D, VertexShader);
  Device.CreatePixelShader(ShaderGroup.PixelShaders[ShaderGroup.Methods[MID]^.PixelShaderID]^.BinD3D, PixelShader);
end;

procedure Finalize;
begin
  SafeRelease(VertexShader);
  SafeRelease(PixelShader);
  ShaderGroup.Clear;
  SafeRelease(Decl);
  SafeRelease(VB);
end;

procedure OnUpdate;
begin

end;

procedure OnRender;
  var W, V, P: TG2Mat;
begin
  Device.SetRenderState(D3DRS_LIGHTING, 0);
  Device.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_SELECTARG1);
  Device.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_DIFFUSE);
  W := G2MatRotationY(GetTickCount * 0.001);
  V := G2MatView(G2Vec3(0, 5, -5), G2Vec3(0, 0, 0), G2Vec3(0, 1, 0));
  P := G2MatProj(Pi / 4, 1, 1, 100);
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
  Device.Present(nil, nil, 0, nil);
end;

procedure OnRenderShader;
  var W, V, P, WVP: TG2Mat;
  var MID, ParamWVP: Integer;
  var VS: PG2ShaderData;
  var PS: PG2ShaderData;
begin
  W := G2MatRotationY(GetTickCount * 0.001);
  V := G2MatView(G2Vec3(0, 5, -5), G2Vec3(0, 0, 0), G2Vec3(0, 1, 0));
  P := G2MatProj(Pi / 4, 1, 1, 100);
  WVP := G2MatTranspose(W * V * P);
  Device.SetRenderState(D3DRS_LIGHTING, 0);
  Device.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_SELECTARG1);
  Device.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_DIFFUSE);
  Device.SetTexture(0, nil);
  Device.SetTransform(D3DTS_WORLD, W);
  Device.SetTransform(D3DTS_VIEW, V);
  Device.SetTransform(D3DTS_PROJECTION, P);
  MID := ShaderGroup.MethodIndex('Method');
  VS := ShaderGroup.VertexShaders[ShaderGroup.Methods[MID]^.VertexShaderID];
  PS := ShaderGroup.PixelShaders[ShaderGroup.Methods[MID]^.PixelShaderID];
  ParamWVP := VS^.ParamIndex('WVP');
  Device.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, TD3DColor($ff808080), 1, 0);
  Device.BeginScene;
  if Assigned(Decl) then
  Device.SetVertexDeclaration(Decl);
  Device.SetVertexShader(VertexShader);
  Device.SetPixelShader(PixelShader);
  //Device.SetFVF(FVF);
  Device.SetVertexShaderConstantF(VS^.Params[ParamWVP].Pos, @WVP, 4);
  Device.SetStreamSource(0, VB, 0, 24);
  Device.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2);
  Device.EndScene;
  Device.Present(nil, nil, 0, nil);
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

procedure CreateWindow(const W, H: Integer; const Caption: AnsiString = 'PureD3D9');
  var WndClass: TWndClassExA;
  var WndClassName: AnsiString;
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
  pp.EnableAutoDepthStencil := True;
  pp.AutoDepthStencilFormat := D3DFMT_D16;
  pp.PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
  D3D9.CreateDevice(
    0, D3DDEVTYPE_HAL,
    WindowHandle,
    D3DCREATE_SOFTWARE_VERTEXPROCESSING or D3DCREATE_MULTITHREADED,
    @pp,
    Device
  );
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
      OnRenderShader;
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

