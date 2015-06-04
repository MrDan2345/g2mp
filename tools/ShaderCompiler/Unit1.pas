unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, Menus, SynHighlighterAny, SynEdit, SynHighlighterCpp,
  D3DX9, G2Utils, G2OpenGL, Windows, G2DataManager;

type

  TG2ShaderDataType = (stVS, stPS);

  TG2ShaderParam = record
    ParamType: Byte;
    Name: AnsiString;
    Pos: Integer;
    Size: Integer;
  end;

  TG2ShaderData = record
    Name: AnsiString;
    ShaderType: TG2ShaderDataType;
    SourceHLSL: Pointer;
    SourceHLSLSize: Integer;
    SourceGLSL: Pointer;
    SourceGLSLSize: Integer;
    BinD3D: Pointer;
    BinD3DSize: Integer;
    BinOGL: Pointer;
    BinOGLSize: Integer;
    Params: array of TG2ShaderParam;
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
    procedure AddVertexShader(const Name: AnsiString = 'VertexShader');
    procedure AddPixelShader(const Name: AnsiString = 'PixelShader');
    procedure AddMethod(const Name: AnsiString = 'Method');
    procedure RemoveVertexShader(const Name: AnsiString); overload;
    procedure RemoveVertexShader(const Index: Integer); overload;
    procedure RemovePixelShader(const Name: AnsiString); overload;
    procedure RemovePixelShader(const Index: Integer); overload;
    procedure RemoveMethod(const Name: AnsiString); overload;
    procedure RemoveMethod(const Index: Integer); overload;
    function VertexShaderIndex(const Name: AnsiString): Integer;
    function PixelShaderIndex(const Name: AnsiString): Integer;
    function MethodIndex(const Name: AnsiString): Integer;
    procedure Clear;
    procedure Save(const dm: TG2DataManager);
    procedure Load(const dm: TG2DataManager);
  end;

  { TForm1 }

  TForm1 = class(TForm)
    BtnVertexCompileHLSL: TButton;
    BtnPixelCompileHLSL: TButton;
    BtnVertexCompileGLSL: TButton;
    BtnPixelCompileGLSL: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    PixelShaderLog1: TListBox;
    PixelShaderGLSL: TSynEdit;
    SaveDialog1: TSaveDialog;
    VertexShaderGLSL: TSynEdit;
    VertexShaderLog1: TListBox;
    SaveVertexShader1: TButton;
    SavePixelShader1: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    AddPixelShader: TMenuItem;
    AddMethod: TMenuItem;
    LabeledEdit3: TLabeledEdit;
    RemoveMethod: TMenuItem;
    MethodList1: TListBox;
    PopupMenu3: TPopupMenu;
    RemovePixelShader: TMenuItem;
    PixelShaderList1: TListBox;
    PopupMenu2: TPopupMenu;
    SynCppSyn1: TSynCppSyn;
    VertexShaderHLSL: TSynEdit;
    PixelShaderHLSL: TSynEdit;
    VertexShaderList1: TListBox;
    AddVertexShader: TMenuItem;
    RemoveVertexShader: TMenuItem;
    PageControl1: TPageControl;
    PopupMenu1: TPopupMenu;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure AddMethodClick(Sender: TObject);
    procedure AddPixelShaderClick(Sender: TObject);
    procedure BtnPixelCompileGLSLClick(Sender: TObject);
    procedure BtnVertexCompileGLSLClick(Sender: TObject);
    procedure BtnVertexCompileHLSLClick(Sender: TObject);
    procedure BtnPixelCompileHLSLClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure PageControl1PageChanged(Sender: TObject);
    procedure SaveVertexShader1Click(Sender: TObject);
    procedure SavePixelShader1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure AddVertexShaderClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit2Change(Sender: TObject);
    procedure LabeledEdit3Change(Sender: TObject);
    procedure MethodList1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PixelShaderList1Click(Sender: TObject);
    procedure RemoveMethodClick(Sender: TObject);
    procedure RemovePixelShaderClick(Sender: TObject);
    procedure RemoveVertexShaderClick(Sender: TObject);
    procedure TabSheet1Resize(Sender: TObject);
    procedure TabSheet2Resize(Sender: TObject);
    procedure TabSheet3Resize(Sender: TObject);
    procedure VertexShaderList1Click(Sender: TObject);
  private
    { private declarations }
  public
    CurVertexShader: Integer;
    CurPixelShader: Integer;
    procedure UpdateVertexShaderList;
    procedure UpdatePixelShaderList;
    procedure UpdateMethodList;
    procedure UpdateVertexShaderTab;
    procedure UpdatePixelShaderTab;
    procedure UpdateMethodTab;
    procedure SaveVertexShader(const ID: Integer);
    procedure SavePixelShader(const ID: Integer);
    procedure CompileShaderHLSL(const Shader: PG2ShaderData);
    procedure CompileShaderGLSL(const Shader: PG2ShaderData);
    procedure SaveGroup(const FileName: WideString);
    procedure LoadGroup(const FileName: WideString);
  end;

var
  Form1: TForm1;
  ShaderGroup: TG2ShaderGroupData;

implementation

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

procedure TG2ShaderGroupData.AddVertexShader(const Name: AnsiString = 'VertexShader');
  var CurName: AnsiString;
  var i, Index: Integer;
  var Source: AnsiString;
begin
  CurName := Name;
  Index := 0;
  if VertexShaderIndex(CurName) > -1 then
  begin
    CurName := Name + IntToStr(Index);
    while VertexShaderIndex(CurName) > -1 do
    begin
      Inc(Index);
      CurName := Name + IntToStr(Index);
    end;
  end;
  i := Length(_VertexShaders);
  SetLength(_VertexShaders, i + 1);
  _VertexShaders[i].Name := CurName;
  _VertexShaders[i].ShaderType := stVS;
  _VertexShaders[i].SourceHLSL := nil;
  _VertexShaders[i].SourceHLSLSize := 0;
  _VertexShaders[i].SourceGLSL := nil;
  _VertexShaders[i].SourceGLSLSize := 0;
  _VertexShaders[i].BinD3D := nil;
  _VertexShaders[i].BinD3DSize := 0;
  _VertexShaders[i].BinOGL := nil;
  _VertexShaders[i].BinOGLSize := 0;
  Source := 'uniform float4x4 WVP;'#$D;
  Source := Source + 'void main ('#$D;
  Source := Source + '  in float3 InPosition: Position,'#$D;
  Source := Source + '  out float4 OutPosition: Position'#$D;
  Source := Source + ') {'#$D;
  Source := Source + '  OutPosition = mul(float4(InPosition, 1), WVP);'#$D;
  Source := Source + '}'#$D;
  _VertexShaders[i].SourceHLSLSize := Length(Source);
  GetMem(_VertexShaders[i].SourceHLSL, _VertexShaders[i].SourceHLSLSize);
  Move(Source[1], _VertexShaders[i].SourceHLSL^, _VertexShaders[i].SourceHLSLSize);
  Source := 'uniform mat4 WVP;'#$D;
  Source := Source  + 'attribute vec3 a_Position;'#$D;
  Source := Source  + 'void main () {'#$D;
  Source := Source  + '  gl_Position = vec4(a_Position, 1) * WVP;'#$D;
  Source := Source  + '}'#$D;
  _VertexShaders[i].SourceGLSLSize := Length(Source);
  GetMem(_VertexShaders[i].SourceGLSL, _VertexShaders[i].SourceGLSLSize);
  Move(Source[1], _VertexShaders[i].SourceGLSL^, _VertexShaders[i].SourceGLSLSize);
end;

procedure TG2ShaderGroupData.AddPixelShader(const Name: AnsiString = 'PixelShader');
  var CurName: AnsiString;
  var i, Index: Integer;
  var Source: AnsiString;
begin
  CurName := Name;
  Index := 0;
  if PixelShaderIndex(CurName) > -1 then
  begin
    CurName := Name + IntToStr(Index);
    while PixelShaderIndex(CurName) > -1 do
    begin
      Inc(Index);
      CurName := Name + IntToStr(Index);
    end;
  end;
  i := Length(_PixelShaders);
  SetLength(_PixelShaders, i + 1);
  _PixelShaders[i].Name := CurName;
  _PixelShaders[i].ShaderType := stPS;
  _PixelShaders[i].SourceHLSL := nil;
  _PixelShaders[i].SourceHLSLSize := 0;
  _PixelShaders[i].SourceGLSL := nil;
  _PixelShaders[i].SourceGLSLSize := 0;
  _PixelShaders[i].BinD3D := nil;
  _PixelShaders[i].BinD3DSize := 0;
  _PixelShaders[i].BinOGL := nil;
  _PixelShaders[i].BinOGLSize := 0;
  Source := 'void main ('#$D;
  Source := Source  + '  out float4 OutColor: Color'#$D;
  Source := Source  + ') {'#$D;
  Source := Source  + '  OutColor = float4(1, 1, 1, 1);'#$D;
  Source := Source  + '}'#$D;
  _PixelShaders[i].SourceHLSLSize := Length(Source);
  GetMem(_PixelShaders[i].SourceHLSL, _PixelShaders[i].SourceHLSLSize);
  Move(Source[1], _PixelShaders[i].SourceHLSL^, _PixelShaders[i].SourceHLSLSize);
  Source := 'void main () {'#$D;
  Source := Source  + '  gl_FragColor = vec4(1, 1, 1, 1);'#$D;
  Source := Source  + '}'#$D;
  _PixelShaders[i].SourceGLSLSize := Length(Source);
  GetMem(_PixelShaders[i].SourceGLSL, _PixelShaders[i].SourceGLSLSize);
  Move(Source[1], _PixelShaders[i].SourceGLSL^, _PixelShaders[i].SourceGLSLSize);
end;

procedure TG2ShaderGroupData.AddMethod(const Name: AnsiString = 'Method');
  var CurName: AnsiString;
  var i, Index: Integer;
begin
  CurName := Name;
  Index := 0;
  if MethodIndex(CurName) > -1 then
  begin
    CurName := Name + IntToStr(Index);
    while MethodIndex(CurName) > -1 do
    begin
      Inc(Index);
      CurName := Name + IntToStr(Index);
    end;
  end;
  i := Length(_Methods);
  SetLength(_Methods, i + 1);
  _Methods[i].Name := CurName;
  _Methods[i].PixelShaderID := -1;
  _Methods[i].VertexShaderID := -1;
end;

procedure TG2ShaderGroupData.RemoveVertexShader(const Name: AnsiString);
  var i: Integer;
begin
  i := VertexShaderIndex(Name);
  if i > -1 then
  RemoveVertexShader(i);
end;

procedure TG2ShaderGroupData.RemoveVertexShader(const Index: Integer);
  var i: Integer;
begin
  if _VertexShaders[Index].SourceHLSLSize > 0 then
  begin
    FreeMem(_VertexShaders[Index].SourceHLSL, _VertexShaders[Index].SourceHLSLSize);
    _VertexShaders[Index].SourceHLSLSize := 0;
  end;
  if _VertexShaders[Index].SourceGLSLSize > 0 then
  begin
    FreeMem(_VertexShaders[Index].SourceGLSL, _VertexShaders[Index].SourceGLSLSize);
    _VertexShaders[Index].SourceGLSLSize := 0;
  end;
  if _VertexShaders[Index].BinD3DSize > 0 then
  begin
    FreeMem(_VertexShaders[Index].BinD3D, _VertexShaders[Index].BinD3DSize);
    _VertexShaders[Index].BinD3DSize := 0;
  end;
  if _VertexShaders[Index].BinOGLSize > 0 then
  begin
    FreeMem(_VertexShaders[Index].BinOGL, _VertexShaders[Index].BinOGLSize);
    _VertexShaders[Index].BinOGLSize := 0;
  end;
  for i := Index to High(_VertexShaders) - 1 do
  _VertexShaders[i] := _VertexShaders[i + 1];
  SetLength(_VertexShaders, Length(_VertexShaders) - 1);
  for i := 0 to High(_Methods) do
  if _Methods[i].VertexShaderID = Index then
  begin
    _Methods[i].VertexShaderID := -1;
  end
  else if _Methods[i].VertexShaderID > Index then
  begin
    _Methods[i].VertexShaderID := _Methods[i].VertexShaderID - 1;
  end;
end;

procedure TG2ShaderGroupData.RemovePixelShader(const Name: AnsiString);
  var i: Integer;
begin
  i := PixelShaderIndex(Name);
  if i > -1 then
  RemovePixelShader(i);
end;

procedure TG2ShaderGroupData.RemovePixelShader(const Index: Integer);
  var i: Integer;
begin
  if _PixelShaders[Index].SourceHLSLSize > 0 then
  begin
    FreeMem(_PixelShaders[Index].SourceHLSL, _PixelShaders[Index].SourceHLSLSize);
    _PixelShaders[Index].SourceHLSLSize := 0;
  end;
  if _PixelShaders[Index].SourceGLSLSize > 0 then
  begin
    FreeMem(_PixelShaders[Index].SourceGLSL, _PixelShaders[Index].SourceGLSLSize);
    _PixelShaders[Index].SourceGLSLSize := 0;
  end;
  if _PixelShaders[Index].BinD3DSize > 0 then
  begin
    FreeMem(_PixelShaders[Index].BinD3D, _PixelShaders[Index].BinD3DSize);
    _PixelShaders[Index].BinD3DSize := 0;
  end;
  if _PixelShaders[Index].BinOGLSize > 0 then
  begin
    FreeMem(_PixelShaders[Index].BinOGL, _PixelShaders[Index].BinOGLSize);
    _PixelShaders[Index].BinOGLSize := 0;
  end;
  for i := Index to High(_PixelShaders) - 1 do
  _PixelShaders[i] := _PixelShaders[i + 1];
  SetLength(_PixelShaders, Length(_PixelShaders) - 1);
  for i := 0 to High(_Methods) do
  if _Methods[i].PixelShaderID = Index then
  begin
    _Methods[i].PixelShaderID := -1;
  end
  else if _Methods[i].PixelShaderID > Index then
  begin
    _Methods[i].PixelShaderID := _Methods[i].PixelShaderID - 1;
  end;
end;

procedure TG2ShaderGroupData.RemoveMethod(const Name: AnsiString);
  var i: Integer;
begin
  i := MethodIndex(Name);
  if i > -1 then
  RemoveMethod(i);
end;

procedure TG2ShaderGroupData.RemoveMethod(const Index: Integer);
  var i: Integer;
begin
  for i := Index to High(_Methods) - 1 do
  _Methods[i] := _Methods[i + 1];
  SetLength(_Methods, Length(_Methods) - 1);
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
    _VertexShaders[i].ShaderType := stVS;
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
    _PixelShaders[i].ShaderType := stPS;
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

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormResize(Sender: TObject);
begin

end;

procedure TForm1.AddVertexShaderClick(Sender: TObject);
begin
  ShaderGroup.AddVertexShader();
  UpdateVertexShaderList;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  OnResize(Self);
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
  if VertexShaderList1.ItemIndex > -1 then
  begin
    ShaderGroup.VertexShaders[VertexShaderList1.ItemIndex]^.Name := LabeledEdit1.Text;
    UpdateVertexShaderList;
  end;
end;

procedure TForm1.LabeledEdit2Change(Sender: TObject);
begin
  if PixelShaderList1.ItemIndex > -1 then
  begin
    ShaderGroup.PixelShaders[PixelShaderList1.ItemIndex]^.Name := LabeledEdit2.Text;
    UpdatePixelShaderList;
  end;
end;

procedure TForm1.LabeledEdit3Change(Sender: TObject);
begin
  if MethodList1.ItemIndex > -1 then
  begin
    ShaderGroup.Methods[MethodList1.ItemIndex]^.Name := LabeledEdit3.Text;
    UpdateMethodList;
  end;
end;

procedure TForm1.MethodList1Click(Sender: TObject);
  var PrevOnChange0, PrevOnChange1, PrevOnChange2: TNotifyEvent;
begin
  if MethodList1.ItemIndex > -1 then
  begin
    PrevOnChange0 := LabeledEdit3.OnChange;
    PrevOnChange1 := ComboBox1.OnChange;
    PrevOnChange2 := ComboBox2.OnChange;
    LabeledEdit3.OnChange := nil;
    ComboBox1.OnChange := nil;
    ComboBox2.OnChange := nil;
    LabeledEdit3.Text := ShaderGroup.Methods[MethodList1.ItemIndex]^.Name;
    ComboBox1.ItemIndex := ShaderGroup.Methods[MethodList1.ItemIndex]^.VertexShaderID + 1;
    ComboBox2.ItemIndex := ShaderGroup.Methods[MethodList1.ItemIndex]^.PixelShaderID + 1;
    LabeledEdit3.OnChange := PrevOnChange0;
    ComboBox1.OnChange := PrevOnChange1;
    ComboBox2.OnChange := PrevOnChange2;
  end;
  UpdateMethodTab;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
  UpdateVertexShaderList;
  UpdatePixelShaderList;
  UpdateMethodList;
end;

procedure TForm1.PixelShaderList1Click(Sender: TObject);
  var PrevOnChange: TNotifyEvent;
  var Txt: AnsiString;
begin
  if (CurPixelShader > -1)
  and (CurPixelShader < PixelShaderList1.Items.Count) then
  begin
    SavePixelShader(CurPixelShader);
  end;
  if PixelShaderList1.ItemIndex > -1 then
  begin
    PrevOnChange := LabeledEdit2.OnChange;
    LabeledEdit2.OnChange := nil;
    LabeledEdit2.Text := ShaderGroup.PixelShaders[PixelShaderList1.ItemIndex]^.Name;
    LabeledEdit2.OnChange := PrevOnChange;
    SetLength(Txt, ShaderGroup.PixelShaders[PixelShaderList1.ItemIndex]^.SourceHLSLSize);
    Move(ShaderGroup.PixelShaders[PixelShaderList1.ItemIndex]^.SourceHLSL^, Txt[1], ShaderGroup.PixelShaders[PixelShaderList1.ItemIndex]^.SourceHLSLSize);
    PixelShaderHLSL.Text := Txt;
    SetLength(Txt, ShaderGroup.PixelShaders[PixelShaderList1.ItemIndex]^.SourceGLSLSize);
    Move(ShaderGroup.PixelShaders[PixelShaderList1.ItemIndex]^.SourceGLSL^, Txt[1], ShaderGroup.PixelShaders[PixelShaderList1.ItemIndex]^.SourceGLSLSize);
    PixelShaderGLSL.Text := Txt;
    CurPixelShader := PixelShaderList1.ItemIndex;
  end;
  UpdatePixelShaderTab;
end;

procedure TForm1.RemoveMethodClick(Sender: TObject);
begin
  if MethodList1.ItemIndex > -1 then
  begin
    ShaderGroup.RemoveMethod(MethodList1.ItemIndex);
    MethodList1.ItemIndex := -1;
    LabeledEdit3.Text := '';
    UpdateMethodList;
  end;
end;

procedure TForm1.RemovePixelShaderClick(Sender: TObject);
begin
  if PixelShaderList1.ItemIndex > -1 then
  begin
    ShaderGroup.RemovePixelShader(PixelShaderList1.ItemIndex);
    PixelShaderList1.ItemIndex := -1;
    CurPixelShader := -1;
    LabeledEdit2.Text := '';
    UpdatePixelShaderList;
  end;
end;

procedure TForm1.RemoveVertexShaderClick(Sender: TObject);
begin
  if VertexShaderList1.ItemIndex > -1 then
  begin
    ShaderGroup.RemoveVertexShader(VertexShaderList1.ItemIndex);
    VertexShaderList1.ItemIndex := -1;
    CurVertexShader := -1;
    LabeledEdit1.Text := '';
    UpdateVertexShaderList;
  end;
end;

procedure TForm1.TabSheet1Resize(Sender: TObject);
begin
  MethodList1.Height := TabSheet1.ClientHeight - 12;
end;

procedure TForm1.TabSheet2Resize(Sender: TObject);
  var w: Integer;
begin
  VertexShaderList1.Height := TabSheet2.ClientHeight - 12;
  VertexShaderHLSL.Height := TabSheet2.ClientHeight - 92 - VertexShaderLog1.Height;
  VertexShaderGLSL.Height := TabSheet2.ClientHeight - 92 - VertexShaderLog1.Height;
  w := (TabSheet2.Width - 184) div 2 - 4;
  VertexShaderHLSL.Width := w;
  VertexShaderGLSL.Width := w;
  VertexShaderGLSL.Left := VertexShaderHLSL.Left + w + 8;
  BtnVertexCompileGLSL.Left := VertexShaderGLSL.Left;
  VertexShaderLog1.Top := VertexShaderHLSL.Top + VertexShaderHLSL.Height + 8;
  VertexShaderLog1.Width := VertexShaderHLSL.Width + VertexShaderGLSL.Width + 8;
end;

procedure TForm1.TabSheet3Resize(Sender: TObject);
  var w: Integer;
begin
  PixelShaderList1.Height := TabSheet3.ClientHeight - 12;
  PixelShaderHLSL.Height := TabSheet3.ClientHeight - 92 - PixelShaderLog1.Height;
  PixelShaderGLSL.Height := TabSheet3.ClientHeight - 92 - PixelShaderLog1.Height;
  w := (TabSheet3.Width - 184) div 2 - 4;
  PixelShaderHLSL.Width := w;
  PixelShaderGLSL.Width := w;
  PixelShaderGLSL.Left := PixelShaderHLSL.Left + w + 8;
  BtnPixelCompileGLSL.Left := PixelShaderGLSL.Left;
  PixelShaderLog1.Top := PixelShaderHLSL.Top + PixelShaderHLSL.Height + 8;
  PixelShaderLog1.Width := PixelShaderHLSL.Width + PixelShaderGLSL.Width + 8;
end;

procedure TForm1.VertexShaderList1Click(Sender: TObject);
  var PrevOnChange: TNotifyEvent;
  var Txt: AnsiString;
begin
  if (CurVertexShader > -1)
  and (CurVertexShader< VertexShaderList1.Items.Count) then
  begin
    SaveVertexShader(CurVertexShader);
  end;
  if VertexShaderList1.ItemIndex > -1 then
  begin
    PrevOnChange := LabeledEdit1.OnChange;
    LabeledEdit1.OnChange := nil;
    LabeledEdit1.Text := ShaderGroup.VertexShaders[VertexShaderList1.ItemIndex]^.Name;
    LabeledEdit1.OnChange := PrevOnChange;
    SetLength(Txt, ShaderGroup.VertexShaders[VertexShaderList1.ItemIndex]^.SourceHLSLSize);
    Move(ShaderGroup.VertexShaders[VertexShaderList1.ItemIndex]^.SourceHLSL^, Txt[1], ShaderGroup.VertexShaders[VertexShaderList1.ItemIndex]^.SourceHLSLSize);
    VertexShaderHLSL.Text := Txt;
    SetLength(Txt, ShaderGroup.VertexShaders[VertexShaderList1.ItemIndex]^.SourceGLSLSize);
    Move(ShaderGroup.VertexShaders[VertexShaderList1.ItemIndex]^.SourceGLSL^, Txt[1], ShaderGroup.VertexShaders[VertexShaderList1.ItemIndex]^.SourceGLSLSize);
    VertexShaderGLSL.Text := Txt;
    CurVertexShader := VertexShaderList1.ItemIndex;
  end;
  UpdateVertexShaderTab;
end;

procedure TForm1.SaveVertexShader1Click(Sender: TObject);
  var i: Integer;
begin
  i := VertexShaderList1.ItemIndex;
  if i > -1 then SaveVertexShader(i);
end;

procedure TForm1.SavePixelShader1Click(Sender: TObject);
  var i: Integer;
begin
  i := PixelShaderList1.ItemIndex;
  if i > -1 then SavePixelShader(i);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
  var i: Integer;
begin
  i := MethodList1.ItemIndex;
  if i > -1 then
  begin
    ShaderGroup.Methods[i]^.VertexShaderID := ComboBox1.ItemIndex - 1;
  end;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
  var i: Integer;
begin
  i := MethodList1.ItemIndex;
  if i > -1 then
  begin
    ShaderGroup.Methods[i]^.PixelShaderID := ComboBox2.ItemIndex - 1;
  end;
end;

procedure TForm1.AddPixelShaderClick(Sender: TObject);
begin
  ShaderGroup.AddPixelShader();
  UpdatePixelShaderList;
end;

procedure TForm1.BtnPixelCompileGLSLClick(Sender: TObject);
  var i: Integer;
begin
  i := PixelShaderList1.ItemIndex;
  if i > -1 then
  begin
    SavePixelShader1Click(Form1);
    CompileShaderGLSL(ShaderGroup.PixelShaders[i]);
  end;
end;

procedure TForm1.BtnVertexCompileGLSLClick(Sender: TObject);
  var i: Integer;
begin
  i := VertexShaderList1.ItemIndex;
  if i > -1 then
  begin
    SaveVertexShader1Click(Form1);
    CompileShaderGLSL(ShaderGroup.VertexShaders[i]);
  end;
end;

procedure TForm1.BtnVertexCompileHLSLClick(Sender: TObject);
  var i: Integer;
begin
  i := VertexShaderList1.ItemIndex;
  if i > -1 then
  begin
    SaveVertexShader1Click(Form1);
    CompileShaderHLSL(ShaderGroup.VertexShaders[i]);
  end;
end;

procedure TForm1.BtnPixelCompileHLSLClick(Sender: TObject);
  var i: Integer;
begin
  i := PixelShaderList1.ItemIndex;
  if i > -1 then
  begin
    SavePixelShader1Click(Form1);
    CompileShaderHLSL(ShaderGroup.PixelShaders[i]);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  SaveGroup(SaveDialog1.FileName);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  LoadGroup(OpenDialog1.FileName);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ShaderGroup.Clear;
  UpdateMethodList;
  UpdateVertexShaderList;
  UpdatePixelShaderList;
end;

procedure TForm1.PageControl1Changing(Sender: TObject; var AllowChange: Boolean
  );
begin
  AllowChange := True;
  if PageControl1.ActivePage.Caption = 'VertexShaders' then
  begin
    SaveVertexShader(VertexShaderList1.ItemIndex);
  end
  else if PageControl1.ActivePage.Caption = 'PixelShaders' then
  begin
    SavePixelShader(PixelShaderList1.ItemIndex);
  end
end;

procedure TForm1.PageControl1PageChanged(Sender: TObject);
begin

end;

procedure TForm1.AddMethodClick(Sender: TObject);
begin
  ShaderGroup.AddMethod();
  UpdateMethodList;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ShaderGroup.Clear;
  CloseAction := caFree;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  UpdateMethodTab;
  UpdateVertexShaderTab;
  UpdatePixelShaderTab;
  PageControl1.ActivePageIndex := 0;
  CurVertexShader := -1;
  CurPixelShader := -1;
end;

procedure TForm1.UpdateVertexShaderList;
  var i, Index: Integer;
begin
  Index := VertexShaderList1.ItemIndex;
  VertexShaderList1.Clear;
  VertexShaderList1.Items.BeginUpdate;
  ComboBox1.Clear;
  ComboBox1.Items.BeginUpdate;
  ComboBox1.Items.Add('None');
  for i := 0 to ShaderGroup.VertexShaderCount - 1 do
  begin
    VertexShaderList1.Items.Add(ShaderGroup.VertexShaders[i]^.Name);
    ComboBox1.Items.Add(ShaderGroup.VertexShaders[i]^.Name);
  end;
  ComboBox1.Items.EndUpdate;
  VertexShaderList1.Items.EndUpdate;
  ComboBox1.ItemIndex := 0;
  if Index < VertexShaderList1.Items.Count then
  VertexShaderList1.ItemIndex := Index;
  UpdateVertexShaderTab;
end;

procedure TForm1.UpdatePixelShaderList;
  var i, Index: Integer;
begin
  Index := PixelShaderList1.ItemIndex;
  PixelShaderList1.Clear;
  PixelShaderList1.Items.BeginUpdate;
  ComboBox2.Clear;
  ComboBox2.Items.BeginUpdate;
  ComboBox2.Items.Add('None');
  for i := 0 to ShaderGroup.PixelShaderCount - 1 do
  begin
    PixelShaderList1.Items.Add(ShaderGroup.PixelShaders[i]^.Name);
    ComboBox2.Items.Add(ShaderGroup.PixelShaders[i]^.Name);
  end;
  ComboBox2.Items.EndUpdate;
  PixelShaderList1.Items.EndUpdate;
  ComboBox2.ItemIndex := 0;
  if Index < PixelShaderList1.Items.Count then
  PixelShaderList1.ItemIndex := Index;
  UpdatePixelShaderTab;
end;

procedure TForm1.UpdateMethodList;
  var i, Index: Integer;
begin
  Index := MethodList1.ItemIndex;
  MethodList1.Clear;
  MethodList1.Items.BeginUpdate;
  for i := 0 to ShaderGroup.MethodCount - 1 do
  MethodList1.Items.Add(ShaderGroup.Methods[i]^.Name);
  MethodList1.Items.EndUpdate;
  if Index < MethodList1.Items.Count then
  MethodList1.ItemIndex := Index;
  UpdateMethodTab;
end;

procedure TForm1.UpdateVertexShaderTab;
  var Enable: Boolean;
begin
  Enable := VertexShaderList1.ItemIndex > -1;
  LabeledEdit1.Enabled := Enable;
  SaveVertexShader1.Enabled := Enable;
  VertexShaderHLSL.Enabled := Enable;
  VertexShaderGLSL.Enabled := Enable;
  BtnVertexCompileHLSL.Enabled := Enable;
  BtnVertexCompileGLSL.Enabled := Enable;
  if not Enable then
  begin
    LabeledEdit1.Text := '';
    VertexShaderHLSL.Text := '';
  end;
end;

procedure TForm1.UpdatePixelShaderTab;
  var Enable: Boolean;
begin
  Enable := PixelShaderList1.ItemIndex > -1;
  LabeledEdit2.Enabled := Enable;
  SavePixelShader1.Enabled := Enable;
  PixelShaderHLSL.Enabled := Enable;
  PixelShaderGLSL.Enabled := Enable;
  BtnPixelCompileHLSL.Enabled := Enable;
  BtnPixelCompileGLSL.Enabled := Enable;
  if not Enable then
  begin
    LabeledEdit2.Text := '';
    PixelShaderHLSL.Text := '';
  end;
end;

procedure TForm1.UpdateMethodTab;
  var Enable: Boolean;
begin
  Enable := MethodList1.ItemIndex > -1;
  LabeledEdit3.Enabled := Enable;
  ComboBox1.Enabled := Enable;
  ComboBox2.Enabled := Enable;
  if not Enable then
  begin
    LabeledEdit3.Text := '';
  end;
end;

procedure TForm1.SaveVertexShader(const ID: Integer);
  var Source: AnsiString;
begin
  if ID > -1 then
  begin
    if ShaderGroup.VertexShaders[ID]^.SourceHLSLSize > 0 then
    begin
      FreeMem(ShaderGroup.VertexShaders[ID]^.SourceHLSL, ShaderGroup.VertexShaders[ID]^.SourceHLSLSize);
      ShaderGroup.VertexShaders[ID]^.SourceHLSLSize := 0;
    end;
    if ShaderGroup.VertexShaders[ID]^.SourceGLSLSize > 0 then
    begin
      FreeMem(ShaderGroup.VertexShaders[ID]^.SourceGLSL, ShaderGroup.VertexShaders[ID]^.SourceGLSLSize);
      ShaderGroup.VertexShaders[ID]^.SourceGLSLSize := 0;
    end;
    Source := VertexShaderHLSL.Text;
    ShaderGroup.VertexShaders[ID]^.SourceHLSLSize := Length(Source);
    GetMem(ShaderGroup.VertexShaders[ID]^.SourceHLSL, ShaderGroup.VertexShaders[ID]^.SourceHLSLSize);
    Move(Source[1], ShaderGroup.VertexShaders[ID]^.SourceHLSL^, ShaderGroup.VertexShaders[ID]^.SourceHLSLSize);
    Source := VertexShaderGLSL.Text;
    ShaderGroup.VertexShaders[ID]^.SourceGLSLSize := Length(Source);
    GetMem(ShaderGroup.VertexShaders[ID]^.SourceGLSL, ShaderGroup.VertexShaders[ID]^.SourceGLSLSize);
    Move(Source[1], ShaderGroup.VertexShaders[ID]^.SourceGLSL^, ShaderGroup.VertexShaders[ID]^.SourceGLSLSize);
  end;
end;

procedure TForm1.SavePixelShader(const ID: Integer);
  var Source: AnsiString;
begin
  if ID > -1 then
  begin
    if ShaderGroup.PixelShaders[ID]^.SourceHLSLSize > 0 then
    begin
      FreeMem(ShaderGroup.PixelShaders[ID]^.SourceHLSL, ShaderGroup.PixelShaders[ID]^.SourceHLSLSize);
      ShaderGroup.PixelShaders[ID]^.SourceHLSLSize := 0;
    end;
    if ShaderGroup.PixelShaders[ID]^.SourceGLSLSize > 0 then
    begin
      FreeMem(ShaderGroup.PixelShaders[ID]^.SourceGLSL, ShaderGroup.PixelShaders[ID]^.SourceGLSLSize);
      ShaderGroup.PixelShaders[ID]^.SourceGLSLSize := 0;
    end;
    Source := PixelShaderHLSL.Text;
    ShaderGroup.PixelShaders[ID]^.SourceHLSLSize := Length(Source);
    GetMem(ShaderGroup.PixelShaders[ID]^.SourceHLSL, ShaderGroup.PixelShaders[ID]^.SourceHLSLSize);
    Move(Source[1], ShaderGroup.PixelShaders[ID]^.SourceHLSL^, ShaderGroup.PixelShaders[ID]^.SourceHLSLSize);
    Source := PixelShaderGLSL.Text;
    ShaderGroup.PixelShaders[ID]^.SourceGLSLSize := Length(Source);
    GetMem(ShaderGroup.PixelShaders[ID]^.SourceGLSL, ShaderGroup.PixelShaders[ID]^.SourceGLSLSize);
    Move(Source[1], ShaderGroup.PixelShaders[ID]^.SourceGLSL^, ShaderGroup.PixelShaders[ID]^.SourceGLSLSize);
  end;
end;


procedure TForm1.CompileShaderHLSL(const Shader: PG2ShaderData);
  var Source, Profile, Errors, Disassembly, Token, ParamName, ParamPos, ParamSize, ParamType: AnsiString;
  var ShaderBuffer, ErrorBuffer, DisassemblyBuffer: ID3DXBuffer;
  var Parser: TG2Parser;
  var tt: TG2TokenType;
  var i: Integer;
begin
  if Shader^.BinD3DSize > 0 then
  begin
    FreeMem(Shader^.BinD3D, Shader^.BinD3DSize);
    Shader^.BinD3DSize := 0;
  end;
  case Shader^.ShaderType of
    stVS: Profile := 'vs_2_0';
    stPS: Profile := 'ps_2_0';
  end;
  SetLength(Source, Shader^.SourceHLSLSize);
  Move(Shader^.SourceHLSL^, Source[1], Shader^.SourceHLSLSize);
  D3DXCompileShader(
    PAnsiChar(Source),
    Length(Source),
    nil,
    nil,
    'main',
    PAnsiChar(Profile),
    D3DXSHADER_OPTIMIZATION_LEVEL3 or
    D3DXSHADER_PARTIALPRECISION,
    @ShaderBuffer,
    @ErrorBuffer,
    nil
  );
  Shader^.Params := nil;
  if Assigned(ErrorBuffer) then
  begin
    SetLength(Errors, ErrorBuffer.GetBufferSize);
    Move(ErrorBuffer.GetBufferPointer^, Errors[1], ErrorBuffer.GetBufferSize);
    case Shader^.ShaderType of
      stVS: VertexShaderLog1.Items.Text := Errors;
      stPS: PixelShaderLog1.Items.Text := Errors;
    end;
    Exit;
  end;
  case Shader^.ShaderType of
    stVS: VertexShaderLog1.Items.Text := 'Shader Compiled!';
    stPS: PixelShaderLog1.Items.Text := 'Shader Compiled!';
  end;
  Shader^.BinD3DSize := ShaderBuffer.GetBufferSize;
  Shader^.BinD3D := G2MemAlloc(Shader^.BinD3DSize);
  Move(ShaderBuffer.GetBufferPointer^, Shader^.BinD3D^, Shader^.BinD3DSize);
  D3DXDisassembleShader(
    ShaderBuffer.GetBufferPointer,
    False,
    nil,
    DisassemblyBuffer
  );
  if Assigned(DisassemblyBuffer) then
  begin
    SetLength(Disassembly, DisassemblyBuffer.GetBufferSize);
    Move(DisassemblyBuffer.GetBufferPointer^, Disassembly[1], DisassemblyBuffer.GetBufferSize);
    //case Shader^.ShaderType of
    //  stVS: VertexShaderLog1.Items.Text := Disassembly;
    //  stPS: PixelShaderLog1.Items.Text := Disassembly;
    //end;
    Parser := TG2Parser.Create(Disassembly);
    Parser.AddKeyWord('registers:');
    Parser.AddKeyWord('ps_2_0');
    Parser.AddKeyWord('vs_2_0');
    Parser.AddSymbol('//');
    Parser.AddCommentLine('-');
    repeat
      {$Hints off}
      Token := Parser.NextToken(tt);
      {$Hints on}
    until ((tt = ttKeyword) and (LowerCase(Token) = 'registers:')) or (tt = ttEOF);
    if (tt = ttKeyword) then
    begin
      i := 0;
      repeat
        Token := Parser.NextToken(tt);
        if tt = ttWord then
        Inc(i);
      until (i >= 3) or (tt = ttEOF);
      repeat
        Token := Parser.NextToken(tt);
        if (tt = ttSymbol) and (Token = '//') then
        begin
          repeat
            Token := Parser.NextToken(tt);
          until (Token <> '//') or (tt = ttEOF);
          if (tt = ttWord) then
          begin
            if Token[1] = '$' then
            ParamName := G2StrCut(Token, 2, Length(Token))
            else
            ParamName := Token;
            Token := Parser.NextToken(tt);
            if (tt = ttWord) and (
              (Token[1] = 'c')
              or (Token[1] = 'i')
              or (Token[1] = 'b')
              or (Token[1] = 's')
            ) then
            begin
              ParamType := Token[1];
              ParamPos := G2StrCut(Token, 2, Length(Token));
              Token := Parser.NextToken(tt);
              if tt = ttNumber then
              begin
                ParamSize := Token;
                SetLength(Shader^.Params, Length(Shader^.Params) + 1);
                if ParamType = 'c' then
                Shader^.Params[High(Shader^.Params)].ParamType := 0
                else if ParamType = 'i' then
                Shader^.Params[High(Shader^.Params)].ParamType := 1
                else if ParamType = 'b' then
                Shader^.Params[High(Shader^.Params)].ParamType := 2
                else if ParamType = 's' then
                Shader^.Params[High(Shader^.Params)].ParamType := 3;
                Shader^.Params[High(Shader^.Params)].Name := ParamName;
                Shader^.Params[High(Shader^.Params)].Pos := StrToInt(ParamPos);
                Shader^.Params[High(Shader^.Params)].Size := StrToInt(ParamSize);
              end;
            end;
          end;
        end;
      until (Token = 'ps_2_0') or (Token = 'vs_2_0') or (tt = ttEOF);
    end;
    Parser.Free;
  end;
end;

procedure TForm1.CompileShaderGLSL(const Shader: PG2ShaderData);
  var Context: HGLRC;
  var DC: HDC;
  var pfd: TPixelFormatDescriptor;
  var pf, i: Integer;
  var ShaderProgram, ShaderObject: GLHandle;
  var Profile: GLEnum;
  var Source, Errors: AnsiString;
  var PSource: PAnsiString;
begin
  if Shader^.BinOGLSize > 0 then
  begin
    FreeMem(Shader^.BinOGL, Shader^.BinOGLSize);
    Shader^.BinOGLSize := 0;
  end;
  DC := GetDC(Form1.Handle);
  {$Hints off}
  FillChar(pfd, SizeOf(pfd), 0);
  {$Hints on}
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
  case Shader^.ShaderType of
    stVS: Profile := GL_VERTEX_SHADER;
    stPS: Profile := GL_FRAGMENT_SHADER;
  end;
  SetLength(Source, Shader^.SourceGLSLSize);
  Move(Shader^.SourceGLSL^, Source[1], Shader^.SourceGLSLSize);
  ShaderProgram := glCreateProgram();
  ShaderObject := glCreateShader(Profile);
  PSource := @Source;
  glShaderSource(ShaderObject, 1, PPGLChar(PSource), nil);
  glCompileShader(ShaderObject);
  SetLength(Errors, 8192);
  {$Hints off}
  glGetShaderInfoLog(ShaderObject, Length(Errors), i, PAnsiChar(Errors));
  {$Hints on}
  glDeleteShader(ShaderObject);
  glDeleteProgram(ShaderProgram);
  UnInitOpenGL;
  wglMakeCurrent(DC, Context);
  wglDeleteContext(Context);
  ReleaseDC(WindowHandle, DC);
  if i > 0 then
  begin
    SetLength(Errors, i);
    case Shader^.ShaderType of
      stVS: VertexShaderLog1.Items.Text := Errors;
      stPS: PixelShaderLog1.Items.Text := Errors;
    end;
    Exit;
  end;
  case Shader^.ShaderType of
    stVS: VertexShaderLog1.Items.Text := 'Shader Compiled!';
    stPS: PixelShaderLog1.Items.Text := 'Shader Compiled!';
  end;
  Shader^.BinOGLSize := Length(Source);
  Shader^.BinOGL := G2MemAlloc(Shader^.BinOGLSize);
  Move(Source[1], Shader^.BinOGL^, Shader^.BinOGLSize);
end;

procedure TForm1.SaveGroup(const FileName: WideString);
  var dm: TG2DataManager;
  var i: Integer;
begin
  for i := 0 to ShaderGroup.VertexShaderCount - 1 do
  begin
    CompileShaderHLSL(ShaderGroup.VertexShaders[i]);
    CompileShaderGLSL(ShaderGroup.VertexShaders[i]);
  end;
  for i := 0 to ShaderGroup.PixelShaderCount - 1 do
  begin
    CompileShaderHLSL(ShaderGroup.PixelShaders[i]);
    CompileShaderGLSL(ShaderGroup.PixelShaders[i]);
  end;
  dm := TG2DataManager.Create(FileName, dmWrite);
  try
    ShaderGroup.Save(dm);
  finally
    dm.Free;
  end;
end;

procedure TForm1.LoadGroup(const FileName: WideString);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName, dmRead);
  try
    ShaderGroup.Load(dm);
    UpdateMethodList;
    UpdateVertexShaderList;
    UpdatePixelShaderList;
  finally
    dm.Free;
  end;
end;

end.

