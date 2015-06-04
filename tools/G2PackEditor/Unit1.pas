{-------------------------------------------------------------------------------
G2PK File Format:
  Header:
    Definition: String4
    Version: UInt4
    FolderCount: UInt4
    DataPos: UInt4
  Folders[FolderCount]:
    Name: StringNT
    Open: Bool;
    FileCount: UInt4
    Files[FileCount]:
      Name: StringNT
      FileName: StringNT
      Encrypted: Bool
      Compressed: Bool
      CompRatio: Int4;
      DataPos: UInt4
      DataLength: UInt4
      OriginalSize: UInt4;
      CRC[40]: UInt1
  Data
-------------------------------------------------------------------------------}

unit Unit1;     

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Types,
  Math,
  Forms,
  Dialogs,
  ZLib,
  DirectInput,
  Direct3D9,
  DXTypes,
  Gen2,
  G2Math,
  G2Landscape,
  G2PerlinNoise,
  Resources, AppEvnts;

type
  TForm1 = class(TForm)
    od1: TOpenDialog;
    sd2: TSaveDialog;
    od2: TOpenDialog;
    sd1: TSaveDialog;
    ApplicationEvents1: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure ApplicationEvents1Deactivate(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TMenu = class;
  TResources = class;
  TOptions = class;
  TEditBox = class;

  TMyApp = class (TG2App)
  strict private
    m_MD: TPoint;
    m_Font: TG2Font;
  public
    AppClose: Boolean;
    Font: TG2Font;
    MgrTextures: TG2TextureMgr;
    TexBorder: TG2Texture2D;
    TexGrad: TG2Texture2D;
    TexTopBG: TG2Texture2D;
    TexTitle: TG2Texture2D;
    TexBtn1: TG2Texture2D;
    TexBtn1H: TG2Texture2D;
    TexBtn1D: TG2Texture2D;
    TexBtn2: TG2Texture2D;
    TexBtn2H: TG2Texture2D;
    TexBtn2D: TG2Texture2D;
    TexBtn3: TG2Texture2D;
    TexBtn3H: TG2Texture2D;
    TexBtn3D: TG2Texture2D;
    TexBtn4: TG2Texture2D;
    TexBtn4H: TG2Texture2D;
    TexBtn4D: TG2Texture2D;
    TexArrow: TG2Texture2D;
    TexLockOpen: TG2Texture2D;
    TexLockShut: TG2Texture2D;
    TexCompressed: TG2Texture2D;
    TexUncompressed: TG2Texture2D;
    bg: array [0..1] of array[0..7] of Single;
    bgGrad: Single;
    Menu: TMenu;
    Res: TResources;
    Opt: TOptions;
    FreezeInputTime: DWord;
    Edit: TEditBox;
    CurOpenFile: String;
    EncKey: AnsiString;
    LogStr: AnsiString;
    ToolTipMsg: AnsiString;
    procedure SavePack(const FileName: WideString);
    procedure LoadPack(const FileName: WideString);
    procedure RenderBorder;
    procedure RenderBackground;
    procedure RenderTitle;
    procedure RenderButton(
      const R: TRect;
      const BtnInd: Integer;
      const Text: AnsiString;
      const Centered: Boolean = False;
      const Img: TG2Texture2D = nil;
      const FlipV: Boolean = False;
      const FlipH: Boolean = False;
      const ToolTip: AnsiString = ''
    );
    procedure OnRender; override;
    procedure OnUpdate; override;
    procedure OnKeyDown(const Key: Byte); override;
    procedure OnKeyUp(const Key: Byte); override;
    procedure OnMouseDown(const Button: Byte); override;
    procedure OnMouseUp(const Button: Byte); override;
    procedure OnWheelMove(const Shift: Integer); override;
    procedure ReadParams;
    procedure WriteParams;
    function GetSizeString(const Size: DWord): AnsiString;
    procedure Initialize; override;
    procedure Finalize; override;
  end;

  TMenu = class
  strict private
  type
    TMenuItem = record
    public
      Name: AnsiString;
      Proc: TG2ProcObj;
    end;
  var
    m_Items: array of TMenuItem;
    m_X: Single;
    m_Y: Single;
    m_W: Single;
    m_H: Single;
    m_CurItem: Integer;
    m_Font: TG2Font;
    m_sp: Single;
    m_PlugInput: TG2PlugInput;
    function McItem: Integer;
    procedure OnMouseDown(const Button: Byte);
    function GetCurItemName: AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    property X: Single read m_X write m_X;
    property Y: Single read m_Y write m_Y;
    property W: Single read m_W write m_W;
    property H: Single read m_H write m_H;
    property sp: Single read m_sp;
    property CurItem: Integer read m_CurItem write m_CurItem;
    property CurItemName: AnsiString read GetCurItemName;
    procedure AddItem(const Name: AnsiString; const Proc: TG2ProcObj);
    procedure Render;
  end;

  PG2Folder = ^TG2Folder;
  TG2Folder = record
  public
    Name: AnsiString;
    Files: TList;
    Open: Boolean;
  end;

  TG2FileCRC = packed record
    Pos: DWord;
    Num: Byte;
  end;

  PG2File = ^TG2File;
  TG2File = record
  public
    Name: AnsiString;
    FileName: AnsiString;
    Encrypted: Boolean;
    Compressed: Boolean;
    CompRatio: Integer;
    Data: array of Byte;
    DataSize: DWord;
    Folder: PG2Folder;
    CRC: array[0..7] of TG2FileCRC;
  end;

  TResources = class
  strict private
    m_X: Single;
    m_Y: Single;
    m_W: Single;
    m_H: Single;
    m_Folders: TList;
    m_MD: TPoint;
    m_Scroll: Integer;
    m_ScrollHold: Boolean;
    m_MCScrollTop: Integer;
    procedure ClickFolder(const fld: PG2Folder; const Pos, Size: Integer; const R: TRect);
    procedure ClickFile(const f: PG2File; const Pos, Size: Integer; const R: TRect);
  public
    constructor Create;
    destructor Destroy; override;
    property X: Single read m_X write m_X;
    property Y: Single read m_Y write m_Y;
    property W: Single read m_W write m_W;
    property H: Single read m_H write m_H;
    property ScrollHold: Boolean read m_ScrollHold write m_ScrollHold;
    property Folders: TList read m_Folders;
    procedure OnMouseDown(const Button: Byte);
    procedure OnMouseUp(const Button: Byte);
    procedure OnWheelMove(const Shift: Integer);
    procedure Adjust;
    function RectNewFolder: TRect;
    function RectClear: TRect;
    function RectUp: TRect;
    function RectDown: TRect;
    function RectList: TRect;
    function RectScroll: TRect;
    function ScrollSize: Integer;
    function NewFolder(const Name: AnsiString): PG2Folder;
    procedure FreeFolder(const f: PG2Folder);
    function NewFile(const Folder: PG2Folder; const Name: AnsiString): PG2File;
    procedure FreeFile(const f: PG2File);
    procedure LoadFile(const f: PG2File; const Src: AnsiString);
    function FindFolder(const Name: AnsiString): PG2Folder;
    function FindFile(const fld: PG2Folder; const Name: AnsiString): PG2File;
    function FindFolderNameCount(const Name: AnsiString): Integer;
    function FindFileNameCount(const fld: PG2Folder; const Name: AnsiString): Integer;
    procedure VerifyFolderName(const fld: PG2Folder);
    procedure VerifyFileName(const f: PG2File);
    procedure MoveFolder(const fld: PG2Folder; const Offset: Integer);
    procedure MoveFile(const f: PG2File; const Offset: Integer);
    procedure CompressFile(const f: PG2File);
    function EncryptFile(const f: PG2File): Boolean;
    procedure Render;
  end;

  TOptions = class
  strict private
    m_X: Single;
    m_Y: Single;
    m_W: Single;
    m_H: Single;
    md: TPoint;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Adjust;
    function RectSave: TRect;
    function RectSaveAs: TRect;
    function RectLoad: TRect;
    function RectEnc: TRect;
    procedure OnMouseDown(const Button: Byte);
    procedure OnMouseUp(const Button: Byte);
    procedure Render;
  end;

  TEditBox = class
  strict private
    m_Rect: TRect;
    m_TextLink: PAnsiString;
    m_TextBackup: AnsiString;
    m_Active: Boolean;
    m_Font: TG2Font;
    m_CurPos: Integer;
    m_CurTime: DWord;
  public
    constructor Create;
    destructor Destroy; override;
    property Active: Boolean read m_Active;
    procedure Update;
    procedure Render;
    procedure Activate(const R: TRect; const TextLink: PAnsiString);
    procedure Deactivate;
    procedure OnKeyDown(const Key: Byte);
    procedure OnMouseDown(const Button: Byte);
    procedure OnMouseUp(const Button: Byte);
  end;

var
  Form1: TForm1;
  App: TMyApp;

implementation

{$R *.dfm}

//TResources BEGIN
constructor TResources.Create;
begin
  inherited Create;
  //App.g2.RequestPlug(TG2PlugInput, @m_PlugInput);
  //m_PlugInput.OnMouseDown := OnMouseDown;
  //m_PlugInput.OnMouseUp := OnMouseUp;
  m_X := 0;
  m_Y := 0;
  m_W := 256;
  m_H := 256;
  m_Folders := TList.Create;
end;

destructor TResources.Destroy;
begin
  while m_Folders.Count > 0 do
  FreeFolder(PG2Folder(m_Folders[0]));
  m_Folders.Free;
  //App.g2.ReleasePlug(@m_PlugInput);
  inherited Destroy;
end;

procedure TResources.OnMouseDown(const Button: Byte);
var
  R: TRect;
begin
  if GetTickCount - App.FreezeInputTime < 1000 then Exit;
  m_MD := App.PlugInput.MousePos;
  R := RectScroll;
  if (PtInRect(R, m_MD)) then
  begin
    m_ScrollHold := True;
    m_MCScrollTop := m_MD.Y - R.Top;
  end;
end;

procedure TResources.OnMouseUp(const Button: Byte);
var
  R, R1: TRect;
  mc: TPoint;
  i, j, l: Integer;
  fld: PG2Folder;
  f: PG2File;
  ss: Integer;
  b: Boolean;
begin
  if GetTickCount - App.FreezeInputTime < 1000 then Exit;
  if App.Menu.CurItemName <> 'Data' then Exit;
  mc := App.PlugInput.MousePos;
  R := RectNewFolder;
  if PtInRect(R, mc) and (PtInRect(R, m_MD)) then
  begin
    NewFolder('New Folder');
  end;
  R := RectClear;
  if PtInRect(R, mc) and (PtInRect(R, m_MD)) then
  begin
    while m_Folders.Count > 0 do
    FreeFolder(PG2Folder(m_Folders[0]));
  end;
  R := RectUp;
  if PtInRect(R, mc) and (PtInRect(R, m_MD)) then
  begin
    ss := ScrollSize;
    m_Scroll := m_Scroll - 20;
    if m_Scroll > (ss - (m_H - 32)) then m_Scroll := Round(ss - (m_H - 32));
    if m_Scroll < 0 then m_Scroll := 0;
    if ss < m_H - 32 then m_Scroll := 0;
  end;
  R := RectDown;
  if PtInRect(R, mc) and (PtInRect(R, m_MD)) then
  begin
    ss := ScrollSize;
    m_Scroll := m_Scroll + 20;
    if m_Scroll > (ss - (m_H - 32)) then m_Scroll := Round(ss - (m_H - 32));
    if m_Scroll < 0 then m_Scroll := 0;
    if ss < m_H - 32 then m_Scroll := 0;
  end;
  b := True;
  R := RectList;
  if PtInRect(R, mc) and (PtInRect(R, m_MD)) then
  begin
    l := 0;
    for i := 0 to m_Folders.Count - 1 do
    begin
      if not b then Break;
      fld := PG2Folder(m_Folders[i]);
      R1 := Rect(R.Left, R.Top + l * 32 - m_Scroll, R.Right, R.Top + l * 32 - m_Scroll + 32);
      if PtInRect(R1, mc) and PtInRect(R1, m_MD) then
      begin
        ClickFolder(fld, mc.X - R.Left, R.Right - R.Left, R1);
        Break;
      end;
      Inc(l);
      if b and fld^.Open then
      for j := 0 to fld^.Files.Count - 1 do
      begin
        f := PG2File(fld^.Files[j]);
        R1 := Rect(R.Left + 32, R.Top + l * 32 - m_Scroll, R.Right, R.Top + l * 32 - m_Scroll + 32);
        if PtInRect(R1, mc) and PtInRect(R1, m_MD) then
        begin
          ClickFile(f, mc.X - (R.Left + 32), R.Right - (R.Left + 32), R1);
          b := False;
          Break;
        end;
        Inc(l);
      end;
    end;
  end;  
end;

procedure TResources.OnWheelMove(const Shift: Integer);
var
  ss: Integer;
begin
  ss := ScrollSize;
  m_Scroll := m_Scroll - Shift div 10;
  if m_Scroll > (ss - (m_H - 32)) then m_Scroll := Round(ss - (m_H - 32));
  if m_Scroll < 0 then m_Scroll := 0;
  if ss < m_H - 32 then m_Scroll := 0;
end;

procedure TResources.ClickFolder(const fld: PG2Folder; const Pos, Size: Integer; const R: TRect);
var
  i: Integer;
  f: PG2File;
  str: AnsiString;
begin
  if (Pos > 0) and (Pos < 32) then
  fld^.Open := not fld^.Open or (fld^.Files.Count = 0);

  if (Pos > 32) and (Pos < Size - 64 - 96 - 96) then
  App.Edit.Activate(
    Rect(R.Left + 32 + 4, R.Top + 4, R.Right - 64 - 96 - 96 - 4, R.Bottom - 4),
    @fld^.Name
  );

  if (Pos > Size - 64 - 96 - 96) and (Pos < Size - 64 - 96) then
  begin
    Form1.od1.Options := Form1.od1.Options + [ofAllowMultiSelect];
    if Form1.od1.Execute then
    for i := 0 to Form1.od1.Files.Count - 1 do
    begin
      str := ExtractFileName(Form1.od1.Files[i]);
      f := NewFile(fld, str);
      LoadFile(f, Form1.od1.Files[i]);
    end;
    App.FreezeInputTime := GetTickCount;
  end;

  if (Pos > Size - 64 - 96) and (Pos < Size - 64) then
  FreeFolder(fld);

  if (Pos > Size - 64) and (Pos < Size - 32) then
  MoveFolder(fld, -1);

  if (Pos > Size - 32) and (Pos < Size) then
  MoveFolder(fld, 1);
end;

procedure TResources.ClickFile(const f: PG2File; const Pos, Size: Integer; const R: TRect);
var
  fs: TFileStream;
begin
  if (Pos > 0) and (Pos < Size - 64 - 96 - 64 - 64 - 32 - 32) then
  App.Edit.Activate(
    Rect(R.Left + 4, R.Top + 4, R.Right - 64 - 96 - 64 - 64 - 32 - 32 - 4, R.Bottom - 4),
    @f^.Name
  );

  if (Pos > Size - 64 - 96 - 64 - 64 - 32 - 32) and (Pos < Size - 64 - 96 - 64 - 64 - 32) then
  CompressFile(f);

  if (Pos > Size - 64 - 96 - 64 - 64 - 32) and (Pos < Size - 64 - 96 - 64 - 64) then
  EncryptFile(f);

  if (Pos > Size - 64 - 96 - 64 - 64) and (Pos < Size - 64 - 96 - 64) then
  if (Length(f^.Data) > 0) and not f^.Compressed and not f^.Encrypted then
  begin
    Form1.sd1.FileName := f^.FileName;
    if Form1.sd1.Execute then
    begin
      fs := TFileStream.Create(Form1.sd1.FileName, fmCreate);
      fs.Write(f^.Data[0], Length(f^.Data));
      fs.Free;
    end;
    App.FreezeInputTime := GetTickCount;
  end;

  if (Pos > Size - 64 - 96 - 64) and (Pos < Size - 64 - 96) then
  begin
    Form1.od1.Options := Form1.od1.Options - [ofAllowMultiSelect];
    if Form1.od1.Execute then
    LoadFile(f, Form1.od1.FileName);
    App.FreezeInputTime := GetTickCount;
  end;

  if (Pos > Size - 64 - 96) and (Pos < Size - 64) then
  FreeFile(f);

  if (Pos > Size - 64) and (Pos < Size - 32) then
  MoveFile(f, -1);

  if (Pos > Size - 32) and (Pos < Size) then
  MoveFile(f, 1);
end;

procedure TResources.Adjust;
begin
  with App do
  begin
    m_X := Menu.X + Menu.W + 32;
    m_Y := 64;
    m_W := Gfx.Params.Width - m_X - 32;
    m_H := Gfx.Params.Height - m_Y - 32;
  end;
end;

function TResources.RectNewFolder: TRect;
begin
  Result := Rect(Round(m_X), Round(m_Y), Round(m_X + 256), Round(m_Y + 32));
end;

function TResources.RectClear: TRect;
begin
  Result := Rect(Round(m_X + 256), Round(m_Y), Round(m_X + 512), Round(m_Y + 32));
end;

function TResources.RectUp: TRect;
begin
  Result := Rect(Round(m_X + m_W - 32), Round(m_Y + 32), Round(m_X + m_W), Round(m_Y + 64));
end;

function TResources.RectDown: TRect;
begin
  Result := Rect(Round(m_X + m_W - 32), Round(m_Y + m_H - 32), Round(m_X + m_W), Round(m_Y + m_H));
end;

function TResources.RectList: TRect;
begin
  Result := Rect(Round(m_X), Round(m_Y + 32), Round(m_X + m_W - 32), Round(m_Y + m_H));
end;

function TResources.RectScroll: TRect;
var
  ss: Integer;
  y, h: Integer;
begin
  ss := ScrollSize;
  if ss > m_H - 32 then
  begin
    h := Round((m_H - 32) / ss * (m_H - 96));
    y := Round(m_Scroll / (ss - (m_H - 32)) * (m_H - 96 - h) + 64);
    Result := Rect(
      Round(m_X + m_W - 32),
      Round(m_Y + y),
      Round(m_X + m_W),
      Round(m_Y + y + h)
    );
  end
  else
  Result := Rect(
    Round(m_X + m_W - 32),
    Round(m_Y),
    Round(m_X + m_W),
    Round(m_Y + m_H)
  );
end;

function TResources.ScrollSize: Integer;
var
  i, j: Integer;
  fld: PG2Folder;
  l: Integer;
begin
  l := 0;
  for i := 0 to m_Folders.Count - 1 do
  begin
    fld := PG2Folder(m_Folders[i]);
    Inc(l);
    if fld^.Open then
    for j := 0 to fld^.Files.Count - 1 do
    Inc(l);
  end;
  Result := l * 32;
end;

function TResources.NewFolder(const Name: AnsiString): PG2Folder;
begin
  New(Result);
  Result^.Name := Name;
  Result^.Files := TList.Create;
  Result^.Open := True;
  m_Folders.Add(Result);
  VerifyFolderName(Result);
end;

procedure TResources.FreeFolder(const f: PG2Folder);
begin
  m_Folders.Remove(f);
  while f^.Files.Count > 0 do
  begin
    Dispose(PG2File(f^.Files[0]));
    f^.Files.Delete(0);
  end;
  f^.Files.Free;
  Dispose(f);
end;

function TResources.NewFile(const Folder: PG2Folder; const Name: AnsiString): PG2File;
begin
  New(Result);
  Result^.Name := Name;
  Result^.Folder := Folder;
  Result^.Encrypted := False;
  Result^.Compressed := False;
  Result^.DataSize := 0;
  Result^.CompRatio := 0;
  ZeroMemory(@Result^.CRC, SizeOf(Result^.CRC));
  Folder^.Files.Add(Result);
  VerifyFileName(Result);
end;

procedure TResources.FreeFile(const f: PG2File);
begin
  f^.Folder^.Files.Remove(f);
  Dispose(f);
end;

procedure TResources.LoadFile(const f: PG2File; const Src: AnsiString);
var
  fs: TFileStream;
begin
  fs := TFileStream.Create(Src, fmOpenRead);
  SetLength(f^.Data, fs.Size);
  fs.Read(f^.Data[0], fs.Size);
  fs.Free;
  f^.DataSize := Length(f^.Data);
  f^.FileName := ExtractFileName(Src);
  f^.Encrypted := False;
  f^.Compressed := False;
  ZeroMemory(@f^.CRC, SizeOf(f^.CRC));
end;

function TResources.FindFolder(const Name: AnsiString): PG2Folder;
var
  i: Integer;
begin
  for i := 0 to m_Folders.Count - 1 do
  if LowerCase(Name) = LowerCase(PG2Folder(m_Folders[i])^.Name) then
  begin
    Result := PG2Folder(m_Folders[i]);
    Exit;
  end;
  Result := nil;
end;

function TResources.FindFile(const fld: PG2Folder; const Name: AnsiString): PG2File;
var
  i: Integer;
begin
  for i := 0 to fld^.Files.Count - 1 do
  if LowerCase(Name) = LowerCase(PG2File(fld^.Files[i])^.Name) then
  begin
    Result := PG2File(fld^.Files[i]);
    Exit;
  end;
  Result := nil;
end;

function TResources.FindFolderNameCount(const Name: AnsiString): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to m_Folders.Count - 1 do
  if LowerCase(Name) = LowerCase(PG2Folder(m_Folders[i])^.Name) then
  Inc(Result);
end;

function TResources.FindFileNameCount(const fld: PG2Folder; const Name: AnsiString): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to fld^.Files.Count - 1 do
  if LowerCase(Name) = LowerCase(PG2File(fld^.Files[i])^.Name) then
  Inc(Result);
end;

procedure TResources.VerifyFolderName(const fld: PG2Folder);
var
  OrigName: AnsiString;
  Ind: Integer;
begin
  OrigName := fld^.Name;
  Ind := 0;
  while FindFolderNameCount(fld^.Name) > 1 do
  begin
    Inc(Ind);
    fld^.Name := OrigName + ' ' + IntToStr(Ind);
  end;
end;

procedure TResources.VerifyFileName(const f: PG2File);
var
  OrigName: AnsiString;
  Ind: Integer;
begin
  OrigName := f^.Name;
  Ind := 0;
  while FindFileNameCount(f^.Folder, f^.Name) > 1 do
  begin
    Inc(Ind);
    f^.Name := OrigName + ' ' + IntToStr(Ind);
  end;
end;

procedure TResources.MoveFolder(const fld: PG2Folder; const Offset: Integer);
var
  CurPos, NewPos: Integer;
begin
  CurPos := m_Folders.IndexOf(fld);
  if CurPos = -1 then Exit;
  NewPos := CurPos + Offset;
  if (NewPos < 0) or (NewPos >= m_Folders.Count) then Exit;
  m_Folders.Remove(fld);
  m_Folders.Insert(NewPos, fld);
end;

procedure TResources.MoveFile(const f: PG2File; const Offset: Integer);
var
  CurPos, NewPos: Integer;
begin
  CurPos := f^.Folder^.Files.IndexOf(f);
  if CurPos = -1 then Exit;
  NewPos := CurPos + Offset;
  if (NewPos < 0) or (NewPos >= f^.Folder^.Files.Count) then Exit;
  f^.Folder^.Files.Remove(f);
  f^.Folder^.Files.Insert(NewPos, f);
end;

procedure TResources.CompressFile(const f: PG2File);
var
  ms: TMemoryStream;
  cs: TCompressionStream;
  ds: TDecompressionStream;
  ReEnc: Boolean;
begin
  ReEnc := f^.Encrypted;
  if ReEnc then
  if not EncryptFile(f) then Exit;
  if f^.Encrypted then Exit;
  ms := TMemoryStream.Create;
  try
    if f^.Compressed then
    begin
      ms.Write(f^.Data[0], Length(f^.Data));
      ms.Position := 0;
      SetLength(f^.Data, f^.DataSize);
      ds := TDecompressionStream.Create(ms);
      try
        ds.Read(f^.Data[0], f^.DataSize);
      finally
        ds.Free;
      end;
      f^.CompRatio := 0;
      f^.Compressed := False;
      App.LogStr := 'File ' + f^.Name + ' Decompressed';
    end
    else
    begin
      cs := TCompressionStream.Create(clMax, ms);
      try
        cs.Write(f^.Data[0], Length(f^.Data));
      finally
        cs.Free;
      end;
      SetLength(f^.Data, ms.Size);
      ms.Position := 0;
      ms.Read(f^.Data[0], ms.Size);
      f^.CompRatio := Trunc((1 - Length(f^.Data) / f^.DataSize) * 100);
      f^.Compressed := True;
      App.LogStr := 'File ' + f^.Name + ' Compressed at ' + IntToStr(f^.CompRatio) + '% Rate';
    end;
  finally
    ms.Free;
  end;
  if ReEnc then
  EncryptFile(f);
end;

function TResources.EncryptFile(const f: PG2File): Boolean;
var
  Data: array of Byte;
  i: Integer;
begin
  Result := True;
  if Length(App.EncKey) <= 0 then
  begin
    Result := False;
    Exit;
  end;
  if f^.Encrypted then
  begin
    SetLength(Data, Length(f^.Data));
    Move(f^.Data[0], Data[0], Length(Data));
    G2EncDec(@Data[0], Length(Data), App.EncKey);
    for i := 0 to High(f^.CRC) do
    if f^.CRC[i].Num <> Data[f^.CRC[i].Pos] then
    begin
      Result := False;
      App.LogStr := 'Decryption Failed (Incorrect Encryption Key)';
      Break;
    end;
    if Result then
    begin
      Move(Data[0], f^.Data[0], Length(Data));
      f^.Encrypted := False;
      App.LogStr := 'File ' + f^.Name + ' Decrypted with Key: "' + App.EncKey + '"';
    end;
  end
  else
  begin
    for i := 0 to High(f^.CRC) do
    begin
      f^.CRC[i].Pos := Random(Length(f^.Data));
      f^.CRC[i].Num := f^.Data[f^.CRC[i].Pos];
    end;
    G2EncDec(@f^.Data[0], Length(f^.Data), App.EncKey);
    f^.Encrypted := True;
    App.LogStr := 'File ' + f^.Name + ' Encrypted with Key: "' + App.EncKey + '"';
  end;
end;

procedure TResources.Render;
var
  i, j, l: Integer;
  fld: PG2Folder;
  f: PG2File;
  str: AnsiString;
  ss: Integer;
  y: Integer;
  R: TRect;
  Tex: TG2Texture2D;
  btn: Byte;
begin
  with App do
  begin
    ss := ScrollSize;
    if m_ScrollHold then
    begin
      R := RectScroll;
      y := Round(App.PlugInput.MousePos.Y - m_MCScrollTop - (m_Y + 64));
      m_Scroll := Round((y / (m_H - 96)) * ss);
      if m_Scroll > (ss - (m_H - 32)) then m_Scroll := Round(ss - (m_H - 32));
      if m_Scroll < 0 then m_Scroll := 0;
      if ss < m_H - 32 then m_Scroll := 0;
    end;
    if ss < m_H - 32 then m_Scroll := 0;

    RenderButton(RectNewFolder, 1, 'New Folder', True);
    RenderButton(RectClear, 1, 'Clear', True);
    RenderButton(RectUp, 1, '', True, TexArrow);
    RenderButton(RectDown, 1, '', True, TexArrow, True);

    if ss > m_H - 32 then
    RenderButton(RectScroll, 4, '');

    App.RenderModes.ScissorSet(Rect(Round(m_X), Round(m_Y + 32), Round(m_X + m_W - 32), Round(m_Y + m_H)));
    l := 1;
    for i := 0 to m_Folders.Count - 1 do
    begin
      fld := PG2Folder(m_Folders[i]);

      if (m_Y + l * 32 - m_Scroll < m_Y + m_H)
      and (m_Y + l * 32 - m_Scroll + 32 > m_Y + 32) then
      begin
        if fld^.Open then str := '-' else str := '+';
        //+/-
        RenderButton(
          Rect(
            Round(m_X),
            Round(m_Y + l * 32 - m_Scroll),
            Round(m_X + 32),
            Round(m_Y + l * 32 - m_Scroll + 32)
          ),
          1, str, True
        );
        //Name
        str := fld^.Name;
        if not fld^.Open then
        str := str + ' (' + IntToStr(fld^.Files.Count) + ')';
        RenderButton(
          Rect(
            Round(m_X + 32),
            Round(m_Y + l * 32 - m_Scroll),
            Round(m_X + m_W - 32 - 64 - 96 - 96),
            Round(m_Y + l * 32 - m_Scroll + 32)
          ),
          1, str, False
        );
        //Add Files
        RenderButton(
          Rect(
            Round(m_X + m_W - 32 - 64 - 96 - 96),
            Round(m_Y + l * 32 - m_Scroll),
            Round(m_X + m_W - 32 - 64 - 96),
            Round(m_Y + l * 32 - m_Scroll + 32)
          ),
          1, 'Add Files', True
        );
        //Delete
        RenderButton(
          Rect(
            Round(m_X + m_W - 32 - 64 - 96),
            Round(m_Y + l * 32 - m_Scroll),
            Round(m_X + m_W - 32 - 64),
            Round(m_Y + l * 32 - m_Scroll + 32)
          ),
          1, 'Delete', True
        );
        //Up
        RenderButton(
          Rect(
            Round(m_X + m_W - 32 - 64),
            Round(m_Y + l * 32 - m_Scroll),
            Round(m_X + m_W - 32 - 32),
            Round(m_Y + l * 32 - m_Scroll + 32)
          ),
          1, '', True, TexArrow
        );
        //Down
        RenderButton(
          Rect(
            Round(m_X + m_W - 32 - 32),
            Round(m_Y + l * 32 - m_Scroll),
            Round(m_X + m_W - 32),
            Round(m_Y + l * 32 - m_Scroll + 32)
          ),
          1, '', True, TexArrow, True
        );
      end;

      Inc(l);

      if fld^.Open then
      for j := 0 to fld^.Files.Count - 1 do
      begin
        f := PG2File(fld^.Files[j]);

        if (m_Y + l * 32 - m_Scroll < m_Y + m_H)
        and (m_Y + l * 32 - m_Scroll + 32 > m_Y + 32) then
        begin
          if f^.Compressed or f^.Encrypted then
          btn := 3
          else
          btn := 2;
          //Name
          str := f^.Name + ' (' + f^.FileName + ') [' + GetSizeString(Length(f^.Data)) + ']';
          if f^.Compressed then
          str := str + ' [C: ' + IntToStr(f^.CompRatio) + '%]';
          RenderButton(
            Rect(
              Round(m_X + 32),
              Round(m_Y + l * 32 - m_Scroll),
              Round(m_X + m_W - 32 - 64 - 96 - 64 - 64 - 32 - 32),
              Round(m_Y + l * 32 - m_Scroll + 32)
            ),
            btn, str, False
          );
          if f^.Compressed then
          begin
            Tex := TexCompressed;
            str := 'Uncompress';
          end
          else
          begin
            Tex := TexUncompressed;
            str := 'Compress';
          end;
          //Compress
          RenderButton(
            Rect(
              Round(m_X + m_W - 32 - 64 - 96 - 64 - 64 - 32 - 32),
              Round(m_Y + l * 32 - m_Scroll),
              Round(m_X + m_W - 32 - 64 - 96 - 64 - 64 - 32),
              Round(m_Y + l * 32 - m_Scroll + 32)
            ),
            btn, '', True, Tex, False, False, str
          );
          if f^.Encrypted then
          begin
            Tex := TexLockShut;
            str := 'Decrypt';
          end
          else
          begin
            Tex := TexLockOpen;
            str := 'Encrypt';
          end;
          //Encrypt
          RenderButton(
            Rect(
              Round(m_X + m_W - 32 - 64 - 96 - 64 - 64 - 32),
              Round(m_Y + l * 32 - m_Scroll),
              Round(m_X + m_W - 32 - 64 - 96 - 64 - 64),
              Round(m_Y + l * 32 - m_Scroll + 32)
            ),
            btn, '', True, Tex, False, False, str
          );
          //Save
          RenderButton(
            Rect(
              Round(m_X + m_W - 32 - 64 - 96 - 64 - 64),
              Round(m_Y + l * 32 - m_Scroll),
              Round(m_X + m_W - 32 - 64 - 96 - 64),
              Round(m_Y + l * 32 - m_Scroll + 32)
            ),
            btn, 'Save', True
          );
          //Load
          RenderButton(
            Rect(
              Round(m_X + m_W - 32 - 64 - 96 - 64),
              Round(m_Y + l * 32 - m_Scroll),
              Round(m_X + m_W - 32 - 64 - 96),
              Round(m_Y + l * 32 - m_Scroll + 32)
            ),
            btn, 'Load', True
          );
          //Delete
          RenderButton(
            Rect(
              Round(m_X + m_W - 32 - 64 - 96),
              Round(m_Y + l * 32 - m_Scroll),
              Round(m_X + m_W - 32 - 64),
              Round(m_Y + l * 32 - m_Scroll + 32)
            ),
            btn, 'Delete', True
          );
          //Up
          RenderButton(
            Rect(
              Round(m_X + m_W - 32 - 64),
              Round(m_Y + l * 32 - m_Scroll),
              Round(m_X + m_W - 32 - 32),
              Round(m_Y + l * 32 - m_Scroll + 32)
            ),
            btn, '', True, TexArrow
          );
          //Down
          RenderButton(
            Rect(
              Round(m_X + m_W - 32 - 32),
              Round(m_Y + l * 32 - m_Scroll),
              Round(m_X + m_W - 32),
              Round(m_Y + l * 32 - m_Scroll + 32)
            ),
            btn, '', True, TexArrow, True
          );
        end;

        Inc(l);

      end;
    end;
    App.RenderModes.ScissorDisable;
  end;
end;
//TResources END

//TOptions BEGIN
constructor TOptions.Create;
begin
  inherited Create;
end;

destructor TOptions.Destroy;
begin
  inherited Destroy;
end;

procedure TOptions.Adjust;
begin
  with App do
  begin
    m_X := Menu.X + Menu.W + 32;
    m_Y := 64;
    m_W := Gfx.Params.Width - m_X - 32;
    m_H := Gfx.Params.Height - m_Y - 32;
  end;
end;

function TOptions.RectSave: TRect;
begin
  Result := Rect(
    Round(m_X),
    Round(m_Y + 32 * 0),
    Round(m_X + 512),
    Round(m_Y + 32 * 1)
  );
end;

function TOptions.RectSaveAs: TRect;
begin
  Result := Rect(
    Round(m_X),
    Round(m_Y + 32 * 1),
    Round(m_X + 512),
    Round(m_Y + 32 * 2)
  );
end;

function TOptions.RectLoad: TRect;
begin
  Result := Rect(
    Round(m_X),
    Round(m_Y + 32 * 2),
    Round(m_X + 512),
    Round(m_Y + 32 * 3)
  );
end;

function TOptions.RectEnc: TRect;
var
  x: Integer;
begin
  x := App.Font.GetTextWidth('Encryption Key:') + 32;
  Result := Rect(
    Round(m_X + x),
    Round(m_Y + 32 * 4),
    Round(m_X + x + 384),
    Round(m_Y + 32 * 5)
  );
end;

procedure TOptions.OnMouseDown(const Button: Byte);
begin
  md := App.PlugInput.MousePos;
end;

procedure TOptions.OnMouseUp(const Button: Byte);
var
  mc: TPoint;
  R: TRect;
begin
  if GetTickCount - App.FreezeInputTime < 5000 then Exit;
  mc := App.PlugInput.MousePos;
  if PtInRect(RectSave, md) and PtInRect(RectSave, App.PlugInput.MousePos) then
  begin
    if FileExists(App.CurOpenFile) then
    App.SavePack(App.CurOpenFile)
    else if Form1.sd2.Execute then
    App.SavePack(Form1.sd2.FileName);
    App.FreezeInputTime := GetTickCount;
  end
  else if PtInRect(RectSaveAs, md) and PtInRect(RectSaveAs, App.PlugInput.MousePos) then
  begin
    if Form1.sd2.Execute then
    App.SavePack(Form1.sd2.FileName);
    App.FreezeInputTime := GetTickCount;
  end
  else if PtInRect(RectLoad, md) and PtInRect(RectLoad, App.PlugInput.MousePos) then
  begin
    if Form1.od2.Execute then
    App.LoadPack(Form1.od2.FileName);
    App.FreezeInputTime := GetTickCount;
  end
  else
  begin
    R := RectEnc;
    if PtInRect(R, md) and PtInRect(R, mc) then
    begin
      App.Edit.Activate(
        Rect(R.Left + 4, R.Top + 4, R.Right - 4, R.Bottom - 4),
        @App.EncKey
      );
    end;
  end;
end;

procedure TOptions.Render;
var
  i, j: Integer;
  fld: PG2Folder;
  f: PG2File;
  nc, nu: DWord;
begin
  with App do
  begin
    RenderButton(RectSave, 1, 'Save', True);
    RenderButton(RectSaveAs, 1, 'Save As', True);
    RenderButton(RectLoad, 1, 'Load', True);
    RenderModes.FilteringPoint();
    Font.Print(
      m_X + 16,
      m_Y + 32 * 4 + 5, $ffffffff, 'Encryption Key:'
    );
    nc := 0;
    nu := 0;
    for i := 0 to Res.Folders.Count - 1 do
    begin
      fld := PG2Folder(Res.Folders[i]);
      for j := 0 to fld^.Files.Count - 1 do
      begin
        f := PG2File(fld^.Files[j]);
        Inc(nc, Length(f^.Data));
        Inc(nu, f^.DataSize);
      end;
    end;
    Font.Print(
      m_X + 16,
      m_Y + 32 * 5 + 5, $ffffffff, 'Data Size = ' + GetSizeString(nc) + ' (' + GetSizeString(nu) + ' Uncompressed)'
    );
    RenderModes.FilteringLinear();
    RenderButton(RectEnc, 2, App.EncKey, False);
  end;
end;
//TOptions END

//TEditBox BEGIN
constructor TEditBox.Create;
begin
  inherited Create;
  m_Active := False;
  m_Font := App.Gfx.Shared.RequestFont('Times New Roman', 12);
  m_CurTime := 0;
end;

destructor TEditBox.Destroy;
begin
  inherited Destroy;
end;

procedure TEditBox.Update;
begin
  m_CurTime := Trunc(m_CurTime + 1000 / App.Tmr.TargetUPS);
end;

procedure TEditBox.Render;
var
  Str: AnsiString;
  cx: Integer;
begin
  if not m_Active then Exit;
  with App do
  begin
    Render.TextureClear();
    Prim2D.DrawRect4Col(
      m_Rect.Left, m_Rect.Top,
      m_Rect.Right - m_Rect.Left,
      m_Rect.Bottom - m_Rect.Top,
      $ffaaaaaa, $ffaaaaaa,
      $ffcccccc, $ffcccccc
    );
    Prim2D.DrawLine(G2Vec2(m_Rect.Left, m_Rect.Top), G2Vec2(m_Rect.Right, m_Rect.Top), $ff888888);
    Prim2D.DrawLine(G2Vec2(m_Rect.Left, m_Rect.Top), G2Vec2(m_Rect.Left, m_Rect.Bottom), $ff888888);
    Prim2D.DrawLine(G2Vec2(m_Rect.Right, m_Rect.Top), G2Vec2(m_Rect.Right, m_Rect.Bottom), $ffffffff);
    Prim2D.DrawLine(G2Vec2(m_Rect.Left, m_Rect.Bottom), G2Vec2(m_Rect.Right, m_Rect.Bottom), $ffffffff);
    RenderModes.FilteringPoint();
    RenderModes.ScissorSet(m_Rect);
    m_Font.Print(
      m_Rect.Left + 5,
      m_Rect.Top + 3,
      $ff000000,
      m_TextLink^
    );
    if m_CurPos > Length(m_TextLink^) then
    m_CurPos := Length(m_TextLink^);
    if m_CurPos > 0 then
    begin
      SetLength(Str, m_CurPos);
      Move(m_TextLink^[1], Str[1], m_CurPos);
      cx := m_Font.GetTextWidth(Str);
    end
    else
    cx := 0;
    cx := cx + 5;
    Render.TextureClear(); 
    Prim2D.DrawLine(
      G2Vec2(m_Rect.Left + cx, m_Rect.Top + 4),
      G2Vec2(m_Rect.Left + cx, m_Rect.Bottom - 4),
      G2LerpColor($ff000000, $0, Sin(G2PiTime(200, m_CurTime)) * 0.5 + 0.5)
    );
    RenderModes.ScissorDisable;
    RenderModes.FilteringLinear();
  end;
end;

procedure TEditBox.Activate(const R: TRect; const TextLink: PAnsiString);
begin
  m_Active := True;
  m_Rect := R;
  m_TextLink := TextLink;
  m_TextBackup := TextLink^;
  m_CurPos := Length(m_TextLink^);
end;

procedure TEditBox.Deactivate;
begin
  m_Active := False;
end;

procedure TEditBox.OnKeyDown(const Key: Byte);
var
  c: AnsiChar;
  Str1, Str2: AnsiString;
begin
  if not m_Active then Exit;
  c := DIKToChar(Key);
  if Key = DIK_LEFT then
  begin
    m_CurPos := m_CurPos - 1;
    m_CurTime := 420;
  end;
  if Key = DIK_RIGHT then
  begin
    m_CurPos := m_CurPos + 1;
    m_CurTime := 420;
  end;
  if Key = DIK_DELETE then
  if Length(m_TextLink^) - m_CurPos > 0 then
  begin
    SetLength(Str1, m_CurPos);
    SetLength(Str2, Length(m_TextLink^) - m_CurPos - 1);
    Move(m_TextLink^[1], Str1[1], m_CurPos);
    Move(m_TextLink^[1 + m_CurPos + 1], Str2[1], Length(m_TextLink^) - m_CurPos - 1);
    m_TextLink^ := Str1 + Str2;
  end;
  if Key = DIK_BACK then
  if m_CurPos > 0 then
  begin
    SetLength(Str1, m_CurPos - 1);
    SetLength(Str2, Length(m_TextLink^) - m_CurPos);
    Move(m_TextLink^[1], Str1[1], m_CurPos - 1);
    Move(m_TextLink^[1 + m_CurPos], Str2[1], Length(m_TextLink^) - m_CurPos);
    m_TextLink^ := Str1 + Str2;
    Dec(m_CurPos);
  end;
  if (c in ['A'..'Z'])
  or (c in ['a'..'z'])
  or (c in ['0'..'9'])
  or (c in ['-', '_', '+', '=', '(', ')', '[', ']', ' ']) then
  begin
    if (
      App.PlugInput.KeyDown[DIK_LSHIFT]
      or App.PlugInput.KeyDown[DIK_RSHIFT]
    ) then
    c := AnsiChar(UpperCase(c)[1])
    else
    c := AnsiChar(LowerCase(c)[1]);
    SetLength(Str1, m_CurPos);
    SetLength(Str2, Length(m_TextLink^) - m_CurPos);
    Move(m_TextLink^[1], Str1[1], m_CurPos);
    Move(m_TextLink^[1 + m_CurPos], Str2[1], Length(m_TextLink^) - m_CurPos);
    m_TextLink^ := Str1 + c + Str2;
    Inc(m_CurPos);
  end;
  if Key = DIK_ESCAPE then
  begin
    m_TextLink^ := m_TextBackup;
    Deactivate;
  end;
  if Key = DIK_RETURN then
  Deactivate;
  if m_CurPos < 0 then m_CurPos := 0;
  if m_CurPos > Length(m_TextLink^) then m_CurPos := Length(m_TextLink^);
end;

procedure TEditBox.OnMouseDown(const Button: Byte);
begin
  if not m_Active then Exit;
end;

procedure TEditBox.OnMouseUp(const Button: Byte);
begin
  if not m_Active then Exit;
  if not PtInRect(
    m_Rect,
    App.PlugInput.MousePos
  ) then
  Deactivate;
end;
//TEditBox END

//TMenu BEGIN
constructor TMenu.Create;
begin
  inherited Create;
  m_X := 16;
  m_Y := 64;
  m_W := 160;
  m_H := 256;
  m_CurItem := 0;
  m_Font := App.Gfx.Shared.RequestFont('Times New Roman', 16);
  m_sp := m_Font.GetTextHeight('A') + 16;
  App.g2.RequestPlug(TG2PlugInput, @m_PlugInput);
  m_PlugInput.OnMouseDown := OnMouseDown;
end;

destructor TMenu.Destroy;
begin
  App.g2.ReleasePlug(@m_PlugInput);
  inherited Destroy;
end;

function TMenu.McItem: Integer;
var
  i: Integer;
begin
  for i := 0 to High(m_Items) do
  begin
    if PtInRect(
      Rect(
        Round(m_X + 16),
        Round(m_Y + i * sp + 16),
        Round(m_X + m_W - 16),
        Round(m_Y + (i + 1) * sp + 16)
      ),
      App.PlugInput.MousePos
    ) then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

procedure TMenu.OnMouseDown(const Button: Byte);
var
  i: Integer;
begin
  if App.Edit.Active then Exit;
  i := McItem;
  if i >= 0 then
  begin
    if Assigned(m_Items[i].Proc) then m_Items[i].Proc();
    m_CurItem := i;
  end;
end;

function TMenu.GetCurItemName: AnsiString;
begin
  if Length(m_Items) <= 0 then
  begin
    Result := '';
    Exit;
  end;
  Result := m_Items[m_CurItem].Name;
end;

procedure TMenu.AddItem(const Name: AnsiString; const Proc: TG2ProcObj);
begin
  SetLength(m_Items, Length(m_Items) + 1);
  m_Items[High(m_Items)].Name := Name;
  m_Items[High(m_Items)].Proc := Proc;
end;

procedure TMenu.Render;
var
  i: Integer;
  c1, c2: TG2Color;
  w, h: Single;
const
  ls = 4;
begin
  with App do
  begin
    RenderModes.FilteringPoint();
    Render.TextureClear();
    c1 := $00000000;
    c2 := $22000000;
    Render2D.DrawBegin(ptTriangleList);
    for i := 0 to Length(m_Items) do
    with Render2D do
    begin
      AddPos(G2Vec2(m_X + 16, m_Y + i * sp - ls + 16));
      AddPos(G2Vec2(m_X + m_W - 16, m_Y + i * sp - ls + 16));
      AddPos(G2Vec2(m_X + 16 - ls, m_Y + i * sp + 16));
      AddPos(G2Vec2(m_X + 16, m_Y + i * sp + 16));
      AddPos(G2Vec2(m_X + m_W - 16, m_Y + i * sp + 16));
      AddPos(G2Vec2(m_X + m_W - (16 - ls), m_Y + i * sp + 16));
      AddPos(G2Vec2(m_X + 16, m_Y + i * sp + ls + 16));
      AddPos(G2Vec2(m_X + m_W - 16, m_Y + i * sp + ls + 16));

      AddCol(c1); AddCol(c1);
      AddCol(c1); AddCol(c2); AddCol(c2); AddCol(c1);
      AddCol(c1); AddCol(c1);

      AddInd(2); AddInd(0); AddInd(3);
      AddInd(3); AddInd(0); AddInd(1);
      AddInd(3); AddInd(1); AddInd(4);
      AddInd(1); AddInd(5); AddInd(4);
      AddInd(5); AddInd(7); AddInd(4);
      AddInd(4); AddInd(7); AddInd(6);
      AddInd(4); AddInd(6); AddInd(3);
      AddInd(2); AddInd(3); AddInd(6);

      Render2D.BaseVertexIndex := Render2D.BaseVertexIndex + 8;
    end;
    Render2D.DrawEnd;
    Render2D.BaseVertexIndex := 0;

    for i := 0 to High(m_Items) do
    begin
      if m_CurItem = i then
      begin
        Render.TextureClear();
        Render2D.DrawBegin(ptTriangleList);
        with Render2D do
        begin
          c1 := $0;
          c2 := $ff000000;

          AddPos(G2Vec2(m_X + m_W - 16 - ls * 2, m_Y + i * sp + 16));
          AddPos(G2Vec2(m_X + m_W - 16, m_Y));
          AddPos(G2Vec2(m_X + m_W - 16, m_Y + i * sp + 16));

          AddCol(c1); AddCol(c1); AddCol(c2);

          AddInd(0); AddInd(1); AddInd(2);

          BaseVertexIndex := BaseVertexIndex + 3;

          AddPos(G2Vec2(m_X + 16 - ls, m_Y + (i + 1) * sp + 16));
          AddPos(G2Vec2(m_X + m_W - 16, m_Y + (i + 1) * sp + 16));
          AddPos(G2Vec2(m_X + m_W - 16 - ls * 2, m_Y + (i + 1) * sp + ls * 2 + 16));
          AddPos(G2Vec2(m_X + m_W - 16, m_Y + m_H));

          AddCol(c1); AddCol(c2); AddCol(c1); AddCol(c1);

          AddInd(0); AddInd(1); AddInd(2);
          AddInd(2); AddInd(1); AddInd(3);

          BaseVertexIndex := BaseVertexIndex + 4;

          c1 := $00ffffff;
          c2 := $ffffffff;

          AddPos(G2Vec2(m_X + 16 - ls, m_Y + i * sp + 16));
          AddPos(G2Vec2(m_X + m_W - 16, m_Y + i * sp + 16));
          AddPos(G2Vec2(m_X + m_W - 16, m_Y + i * sp + ls + 16));
          AddPos(G2Vec2(m_X + m_W - (16 - ls), m_Y + i * sp + 16));
          AddPos(G2Vec2(m_X + m_W - 16, m_Y));

          AddCol(c1); AddCol(c2); AddCol(c1);
          AddCol(c1); AddCol(c1);

          AddInd(0); AddInd(1); AddInd(2);
          AddInd(2); AddInd(1); AddInd(3);
          AddInd(1); AddInd(4); AddInd(3);

          BaseVertexIndex := BaseVertexIndex + 5;

          AddPos(G2Vec2(m_X + 16 - ls, m_Y + (i + 1) * sp + 16));
          AddPos(G2Vec2(m_X + m_W - 16, m_Y + (i + 1) * sp + 16));
          AddPos(G2Vec2(m_X + m_W - 16, m_Y + (i + 1) * sp - ls + 16));
          AddPos(G2Vec2(m_X + m_W - (16 - ls), m_Y + (i + 1) * sp + 16));
          AddPos(G2Vec2(m_X + m_W - 16, m_Y + m_H));

          AddCol(c1); AddCol(c2); AddCol(c1);
          AddCol(c1); AddCol(c1);

          AddInd(0); AddInd(2); AddInd(1);
          AddInd(1); AddInd(2); AddInd(3);
          AddInd(4); AddInd(1); AddInd(3);

          BaseVertexIndex := BaseVertexIndex + 5;

          AddPos(G2Vec2(m_X + 24, m_Y + i * sp + 16));
          AddPos(G2Vec2(m_X + m_W * 0.5, m_Y + i * sp + 16));
          AddPos(G2Vec2(m_X + m_W - 24, m_Y + i * sp + 16));
          AddPos(G2Vec2(m_X + 24, m_Y + (i + 1) * sp + 16));
          AddPos(G2Vec2(m_X + m_W * 0.5, m_Y + (i + 1) * sp + 16));
          AddPos(G2Vec2(m_X + m_W - 24, m_Y + (i + 1) * sp + 16));

          c1 := $00ffffff;
          c2 := $88ffffff;

          AddCol(c1); AddCol(c2); AddCol(c1);
          AddCol(c1); AddCol(c2); AddCol(c1);

          AddInd(0); AddInd(1); AddInd(3);
          AddInd(3); AddInd(1); AddInd(4);
          AddInd(1); AddInd(2); AddInd(4);
          AddInd(4); AddInd(2); AddInd(5);
        end;
        Render2D.DrawEnd;
        Render2D.BaseVertexIndex := 0;
        m_Font.Print(
          m_X + 32 + 1,
          m_Y + 8 + i * sp - 1 + 16,
          $ff000000, m_Items[i].Name
        );
        m_Font.Print(
          m_X + 32 - 1,
          m_Y + 8 + i * sp + 1 + 16,
          $ffffffff, m_Items[i].Name
        );
        m_Font.Print(
          m_X + 32,
          m_Y + 8 + i * sp + 16,
          $ff8888ff, m_Items[i].Name
        );
      end
      else
      begin
        if i = McItem then
        begin
          Render.TextureClear();
          Render2D.DrawBegin(ptTriangleList);

          with Render2D do
          begin
            c1 := $00ffffff;
            c2 := $55ffffff;
            AddPos(G2Vec2(m_X + 24 + 16, m_Y + i * sp + 8 + 16));
            AddPos(G2Vec2(m_X + m_W - 24 - 16, m_Y + i * sp + 8 + 16));
            AddPos(G2Vec2(m_X + 24, m_Y + i * sp + sp * 0.5 + 16));
            AddPos(G2Vec2(m_X + 24 + 16, m_Y + i * sp + sp * 0.5 + 16));
            AddPos(G2Vec2(m_X + m_W - 24 - 16, m_Y + i * sp + sp * 0.5 + 16));
            AddPos(G2Vec2(m_X + m_W - 24, m_Y + i * sp + sp * 0.5 + 16));
            AddPos(G2Vec2(m_X + 24 + 16, m_Y + i * sp + sp - 8 + 16));
            AddPos(G2Vec2(m_X + m_W - 24 - 16, m_Y + i * sp + sp - 8 + 16));

            AddCol(c1); AddCol(c1);
            AddCol(c1); AddCol(c2); AddCol(c2); AddCol(c1);
            AddCol(c1); AddCol(c1);

            AddInd(2); AddInd(0); AddInd(3);
            AddInd(0); AddInd(1); AddInd(3);
            AddInd(3); AddInd(1); AddInd(4);
            AddInd(4); AddInd(1); AddInd(5);
            AddInd(2); AddInd(3); AddInd(6);
            AddInd(6); AddInd(3); AddInd(4);
            AddInd(6); AddInd(4); AddInd(7);
            AddInd(7); AddInd(4); AddInd(5);
          end;

          Render2D.DrawEnd;
        end;
        m_Font.Print(
          m_X + 32,
          m_Y + 8 + i * sp + 16,
          $ff000044, m_Items[i].Name
        );
      end;
    end;

    Render.TextureClear();
    Render2D.DrawBegin(ptTriangleList);
    with Render2D do
    begin
      w := App.Gfx.Params.Width;
      h := App.Gfx.Params.Height;

      AddPos(G2Vec2(m_X + m_W + 32, m_Y));
      AddPos(G2Vec2(m_X + m_W + 32, m_Y + 128));
      AddPos(G2Vec2(m_X + m_W + 32, h - 64 - 128));
      AddPos(G2Vec2(m_X + m_W + 32, h - 64));
      AddPos(G2Vec2(w - 32, m_Y));
      AddPos(G2Vec2(w - 32, m_Y + 128));
      AddPos(G2Vec2(w - 32, h - 64 - 128));
      AddPos(G2Vec2(w - 32, h - 64));

      c1 := $00000000;
      c2 := $22000000;
      AddCol(c1); AddCol(c2); AddCol(c2); AddCol(c1);
      AddCol(c1); AddCol(c2); AddCol(c2); AddCol(c1);

      AddInd(0); AddInd(4); AddInd(1);
      AddInd(1); AddInd(4); AddInd(5);
      AddInd(1); AddInd(5); AddInd(2);
      AddInd(2); AddInd(5); AddInd(6);
      AddInd(2); AddInd(6); AddInd(3);
      AddInd(3); AddInd(6); AddInd(7);

      BaseVertexIndex := BaseVertexIndex + 8;

      AddPos(G2Vec2(m_X + m_W + 32, m_Y));
      AddPos(G2Vec2(m_X + m_W + 32, h - 64));
      AddPos(G2Vec2(m_X + m_W + 32, m_Y + (h - 64 - m_Y) * 0.5));
      AddPos(G2Vec2(m_X + m_W + 32 - ls, m_Y + (h - 64 - m_Y) * 0.5));

      c1 := $00ffffff;
      c2 := $ffffffff;
      AddCol(c1); AddCol(c1); AddCol(c2); AddCol(c1);

      AddInd(0); AddInd(2); AddInd(3);
      AddInd(3); AddInd(2); AddInd(1);

      BaseVertexIndex := BaseVertexIndex + 4;

      AddPos(G2Vec2(w - 32, m_Y));
      AddPos(G2Vec2(w - 32, h - 64));
      AddPos(G2Vec2(w - 32, m_Y + (h - 64 - m_Y) * 0.5));
      AddPos(G2Vec2(w - 32 + ls, m_Y + (h - 64 - m_Y) * 0.5));

      c1 := $00ffffff;
      c2 := $ffffffff;
      AddCol(c1); AddCol(c1); AddCol(c2); AddCol(c1);

      AddInd(0); AddInd(3); AddInd(2);
      AddInd(2); AddInd(3); AddInd(1);

      BaseVertexIndex := BaseVertexIndex + 4;
      
      AddPos(G2Vec2(w - 32, m_Y));
      AddPos(G2Vec2(w - 32, h - 64));
      AddPos(G2Vec2(w - 32, m_Y + (h - 64 - m_Y) * 0.5));
      AddPos(G2Vec2(w - 32 - ls * 2, m_Y + (h - 64 - m_Y) * 0.5));

      c1 := $00000000;
      c2 := $ff000000;
      AddCol(c1); AddCol(c1); AddCol(c2); AddCol(c1);

      AddInd(0); AddInd(2); AddInd(3);
      AddInd(3); AddInd(2); AddInd(1);

      BaseVertexIndex := BaseVertexIndex + 4;
    end;
    Render2D.DrawEnd;
    Render2D.BaseVertexIndex := 0;

    RenderModes.FilteringLinear();
  end;
end;
//TMenu END

//TMyApp BEGIN
procedure TMyApp.SavePack(const FileName: WideString);
type
  THeader = packed record
    Definition: array [0..3] of AnsiChar;
    Version: DWord;
    FolderCount: DWord;
    DataPos: DWord;
  end;
var
  fs: TFileStream;
  DataPos: DWord;
  i, j: Integer;
  fld: PG2Folder;
  f: PG2File;
  Header: THeader;
  dw: DWord;
  procedure WriteStringNT(const s: AnsiString);
  var
    b: Byte;
  begin
    b := 0;
    fs.Write(s[1], Length(s));
    fs.Write(b, 1);
  end;
begin
  fs := TFileStream.Create(FileName, fmCreate);

  DataPos := SizeOf(Header);
  for i := 0 to Res.Folders.Count - 1 do
  begin
    fld := PG2Folder(Res.Folders[i]);
    Inc(DataPos, Length(fld^.Name) + 1 + 1 + 4);
    for j := 0 to fld^.Files.Count - 1 do
    begin
      f := PG2File(fld^.Files[j]);
      Inc(DataPos, Length(f^.Name) + 1 + Length(f^.FileName) + 1 + 1 + 1 + 4 + 4 + 4 + 4 + SizeOf(f^.CRC));
    end;
  end;

  Header.Definition := 'G2PK';
  Header.Version := $00010000;
  Header.FolderCount := Res.Folders.Count;
  Header.DataPos := DataPos;

  fs.Write(Header, SizeOf(Header));

  DataPos := 0;

  for i := 0 to Res.Folders.Count - 1 do
  begin
    fld := PG2Folder(Res.Folders[i]);
    WriteStringNT(fld^.Name);
    fs.Write(fld^.Open, 1);
    dw := fld^.Files.Count;
    fs.Write(dw, 4);
    for j := 0 to fld^.Files.Count - 1 do
    begin
      f := PG2File(fld^.Files[j]);
      WriteStringNT(f^.Name);
      WriteStringNT(f^.FileName);
      fs.Write(f^.Encrypted, 1);
      fs.Write(f^.Compressed, 1);
      fs.Write(f^.CompRatio, 4);
      fs.Write(DataPos, 4);
      dw := Length(f^.Data);
      Inc(DataPos, dw);
      fs.Write(dw, 4);
      fs.Write(f^.DataSize, 4);
      fs.Write(f^.CRC, SizeOf(f^.CRC));
    end;
  end;

  for i := 0 to Res.Folders.Count - 1 do
  begin
    fld := PG2Folder(Res.Folders[i]);
    for j := 0 to fld^.Files.Count - 1 do
    begin
      f := PG2File(fld^.Files[j]);
      fs.Write(f^.Data[0], Length(f^.Data));
    end;
  end;

  fs.Free;
  LogStr := 'Pack Saved to ' + FileName;
end;

procedure TMyApp.LoadPack(const FileName: WideString);
type
  THeader = packed record
    Definition: array [0..3] of AnsiChar;
    Version: DWord;
    FolderCount: DWord;
    DataPos: DWord;
  end;
var
  fs: TFileStream;
  Header: THeader;
  i, j: Integer;
  fld: PG2Folder;
  f: PG2File;
  Str: AnsiString;
  dw: DWord;
  CurPos: Int64;
  DataPos, DataLength: DWord;
  function ReadStringNT: AnsiString;
  var
    Pos: Int64;
    b: Byte;
    Len: Integer;
  begin
    Pos := fs.Position;
    Len := 0;
    repeat
      fs.Read(b, 1);
      Inc(Len);
    until b = 0;
    Dec(Len);
    fs.Position := Pos;
    SetLength(Result, Len);
    fs.Read(Result[1], Len);
    fs.Position := fs.Position + 1;
  end;
begin
  fs := TFileStream.Create(FileName, fmOpenRead);

  if fs.Size < SizeOf(Header) then Exit;
  fs.Read(Header, SizeOf(Header));

  if Header.Definition <> 'G2PK' then Exit;
  if Header.Version > $00010000 then Exit;

  while Res.Folders.Count > 0 do
  Res.FreeFolder(PG2Folder(Res.Folders[0]));

  for i := 0 to Header.FolderCount - 1 do
  begin
    Str := ReadStringNT;
    fld := Res.NewFolder(Str);
    fs.Read(fld^.Open, 1);
    fs.Read(dw, 4);
    for j := 0 to dw - 1 do
    begin
      Str := ReadStringNT;
      f := Res.NewFile(fld, Str);
      f^.FileName := ReadStringNT;
      fs.Read(f^.Encrypted, 1);
      fs.Read(f^.Compressed, 1);
      fs.Read(f^.CompRatio, 4);
      fs.Read(DataPos, 4);
      fs.Read(DataLength, 4);
      fs.Read(f^.DataSize, 4);
      CurPos := fs.Position;
      fs.Position := Header.DataPos + DataPos;
      SetLength(f^.Data, DataLength);
      fs.Read(f^.Data[0], DataLength);
      fs.Position := CurPos;
      fs.Read(f^.CRC, SizeOf(f^.CRC));
    end;
  end;

  fs.Free;
  CurOpenFile := FileName;
  Menu.CurItem := 1;
  LogStr := 'Pack Loaded from ' + FileName;
end;

procedure TMyApp.RenderBorder;
const
  BS = 32;
var
  w, h: Integer;
begin
  w := Gfx.Params.Width;
  h := Gfx.Params.Height;

  Render.TextureSet(TexBorder);

  Render2D.DrawBegin(ptTriangleList);

  Render2D.AddPos(G2Vec2(0, 0));
  Render2D.AddPos(G2Vec2(BS, 0));
  Render2D.AddPos(G2Vec2(w - BS, 0));
  Render2D.AddPos(G2Vec2(w, 0));
  Render2D.AddPos(G2Vec2(w, BS));
  Render2D.AddPos(G2Vec2(w, h - BS));
  Render2D.AddPos(G2Vec2(w, h));
  Render2D.AddPos(G2Vec2(w - BS, h));
  Render2D.AddPos(G2Vec2(BS, h));
  Render2D.AddPos(G2Vec2(0, h));
  Render2D.AddPos(G2Vec2(0, h - BS));
  Render2D.AddPos(G2Vec2(0, BS));
  Render2D.AddPos(G2Vec2(BS, BS));
  Render2D.AddPos(G2Vec2(w - BS, BS));
  Render2D.AddPos(G2Vec2(w - BS, h - BS));
  Render2D.AddPos(G2Vec2(BS, h - BS));

  Render2D.AddTex(G2Vec2(0, 0));
  Render2D.AddTex(G2Vec2(0.5, 0));
  Render2D.AddTex(G2Vec2(0.5, 0));
  Render2D.AddTex(G2Vec2(1, 0));
  Render2D.AddTex(G2Vec2(1, 0.5));
  Render2D.AddTex(G2Vec2(1, 0.5));
  Render2D.AddTex(G2Vec2(1, 1));
  Render2D.AddTex(G2Vec2(0.5, 1));
  Render2D.AddTex(G2Vec2(0.5, 1));
  Render2D.AddTex(G2Vec2(0, 1));
  Render2D.AddTex(G2Vec2(0, 0.5));
  Render2D.AddTex(G2Vec2(0, 0.5));
  Render2D.AddTex(G2Vec2(0.5, 0.5));
  Render2D.AddTex(G2Vec2(0.5, 0.5));
  Render2D.AddTex(G2Vec2(0.5, 0.5));
  Render2D.AddTex(G2Vec2(0.5, 0.5));

  Render2D.AddInd(0); Render2D.AddInd(1); Render2D.AddInd(11);
  Render2D.AddInd(11); Render2D.AddInd(1); Render2D.AddInd(12);
  
  Render2D.AddInd(1); Render2D.AddInd(2); Render2D.AddInd(12);
  Render2D.AddInd(12); Render2D.AddInd(2); Render2D.AddInd(13);

  Render2D.AddInd(2); Render2D.AddInd(3); Render2D.AddInd(13);
  Render2D.AddInd(13); Render2D.AddInd(3); Render2D.AddInd(4);

  Render2D.AddInd(11); Render2D.AddInd(12); Render2D.AddInd(10);
  Render2D.AddInd(10); Render2D.AddInd(12); Render2D.AddInd(15);
  
  Render2D.AddInd(13); Render2D.AddInd(4); Render2D.AddInd(14);
  Render2D.AddInd(14); Render2D.AddInd(4); Render2D.AddInd(5);

  Render2D.AddInd(10); Render2D.AddInd(15); Render2D.AddInd(9);
  Render2D.AddInd(9); Render2D.AddInd(15); Render2D.AddInd(8);

  Render2D.AddInd(15); Render2D.AddInd(14); Render2D.AddInd(8);
  Render2D.AddInd(8); Render2D.AddInd(14); Render2D.AddInd(7);

  Render2D.AddInd(14); Render2D.AddInd(5); Render2D.AddInd(7);
  Render2D.AddInd(7); Render2D.AddInd(5); Render2D.AddInd(6);

  Render2D.DrawEnd;
end;

procedure TMyApp.RenderBackground;
var
  i, j: Integer;
  w, h: Integer;
  sw: Single;
  v1, v2: Integer;
  g, hv1, hv2: Single;
begin
  w := Gfx.Params.Width;
  h := Gfx.Params.Height;
  sw := w / High(bg[0]);
  Render.TextureSet(TexGrad);
  Render2D.DrawBegin(ptTriangleList);
  for i := 0 to High(bg[0]) do
  begin
    v1 := Trunc(i + bgGrad);
    v2 := (v1 + 1);
    g := (i + bgGrad) - v1;
    v1 := v1 mod Length(bg[0]);
    v2 := v2 mod Length(bg[0]);
    hv1 := G2LerpFloat(bg[0][v1], bg[0][v2], g);
    hv2 := G2LerpFloat(bg[1][v1], bg[1][v2], g);
    Render2D.AddPos(G2Vec2(i * sw, 0 * h));
    Render2D.AddPos(G2Vec2(i * sw, hv1 * h));
    Render2D.AddPos(G2Vec2(i * sw, hv2 * h));
    Render2D.AddPos(G2Vec2(i * sw, 1 * h));
    Render2D.AddTex(G2Vec2(0.5, 0));
    Render2D.AddTex(G2Vec2(0.5, 0.5));
    Render2D.AddTex(G2Vec2(0.5, 0.5));
    Render2D.AddTex(G2Vec2(0.5, 1));
    Render2D.AddCol($ffffffff);
    Render2D.AddCol($ffffffff);
    Render2D.AddCol($ffffffff);
    Render2D.AddCol($ffffffff);
    if i < High(bg[0]) then
    begin
      for j := 0 to 2 do
      begin
        Render2D.AddInd((i + 0) * 4 + 0 + j);
        Render2D.AddInd((i + 1) * 4 + 0 + j);
        Render2D.AddInd((i + 0) * 4 + 1 + j);

        Render2D.AddInd((i + 0) * 4 + 1 + j);
        Render2D.AddInd((i + 1) * 4 + 0 + j);
        Render2D.AddInd((i + 1) * 4 + 1 + j);
      end;
    end;
  end;
  Render2D.DrawEnd;
end;

procedure TMyApp.RenderTitle;
var
  w: Integer;
  str: AnsiString;
begin
  w := Gfx.Params.Width;
  Render.TextureSet(TexTopBG);

  Render2D.DrawBegin(ptTriangleStrip);

  Render2D.AddPos(G2Vec2(0, 64));
  Render2D.AddPos(G2Vec2(0, 0));
  Render2D.AddPos(G2Vec2(128, 64));
  Render2D.AddPos(G2Vec2(128, 0));
  Render2D.AddPos(G2Vec2(w - 128, 64));
  Render2D.AddPos(G2Vec2(w - 128, 0));
  Render2D.AddPos(G2Vec2(w, 64));
  Render2D.AddPos(G2Vec2(w, 0));

  Render2D.AddTex(G2Vec2(0, 1));
  Render2D.AddTex(G2Vec2(0, 0));
  Render2D.AddTex(G2Vec2(0.5, 1));
  Render2D.AddTex(G2Vec2(0.5, 0));
  Render2D.AddTex(G2Vec2(0.5, 1));
  Render2D.AddTex(G2Vec2(0.5, 0));
  Render2D.AddTex(G2Vec2(1, 1));
  Render2D.AddTex(G2Vec2(1, 0));

  Render2D.DrawEnd;

  Render2D.DrawRect((w - TexTitle.Width) * 0.5, -10, TexTitle.Width, TexTitle.Height, $ffffffff, TexTitle);
  RenderModes.FilteringPoint();
  str := 'v 1.0';
  Font.Print(w - Font.GetTextWidth(str) - 16, 16, $ff000000, str);
  RenderModes.FilteringLinear();
end;

procedure TMyApp.RenderButton(
      const R: TRect;
      const BtnInd: Integer;
      const Text: AnsiString;
      const Centered: Boolean = False;
      const Img: TG2Texture2D = nil;
      const FlipV: Boolean = False;
      const FlipH: Boolean = False;
      const ToolTip: AnsiString = ''
    );
const
  bs = 16;
var
  i: Integer;
  Tex: TG2TextureBase;
  tsy: Integer;
  PrevScissorRect: TRect;
  PrevScissorEnable: Boolean;
  ScR: TRect;
begin
  with App do
  begin
    tsy := 0;
    if PtInRect(R, App.PlugInput.MousePos) then
    begin
      if App.PlugInput.MouseDown[0]
      and (PtInRect(R, m_MD)) then
      begin
        Tex := MgrTextures.FindTexture('Btn' + IntToStr(BtnInd) + 'D');
        tsy := 1;
      end
      else
      Tex := MgrTextures.FindTexture('Btn' + IntToStr(BtnInd) + 'H');
      if Length(ToolTip) > 0 then
      ToolTipMsg := ToolTip;
    end
    else
    Tex := MgrTextures.FindTexture('Btn' + IntToStr(BtnInd));
    Render.TextureSet(Tex);

    Render2D.DrawBegin(ptTriangleList);
    with Render2D do
    begin
      AddPos(G2Vec2(R.Left, R.Top));
      AddPos(G2Vec2(R.Left + bs, R.Top));
      AddPos(G2Vec2(R.Right - bs, R.Top));
      AddPos(G2Vec2(R.Right, R.Top));
      AddPos(G2Vec2(R.Right, R.Top + bs));
      AddPos(G2Vec2(R.Right, R.Bottom - bs));
      AddPos(G2Vec2(R.Right, R.Bottom));
      AddPos(G2Vec2(R.Right - bs, R.Bottom));
      AddPos(G2Vec2(R.Left + bs, R.Bottom));
      AddPos(G2Vec2(R.Left, R.Bottom));
      AddPos(G2Vec2(R.Left, R.Bottom - bs));
      AddPos(G2Vec2(R.Left, R.Top + bs));
      AddPos(G2Vec2(R.Left + bs, R.Top + bs));
      AddPos(G2Vec2(R.Right - bs, R.Top + bs));
      AddPos(G2Vec2(R.Right - bs, R.Bottom - bs));
      AddPos(G2Vec2(R.Left + bs, R.Bottom - bs));

      for i := 0 to 15 do
      AddCol($aaffffff);

      AddTex(G2Vec2(0, 0));
      AddTex(G2Vec2(0.5, 0));
      AddTex(G2Vec2(0.5, 0));
      AddTex(G2Vec2(1, 0));
      AddTex(G2Vec2(1, 0.5));
      AddTex(G2Vec2(1, 0.5));
      AddTex(G2Vec2(1, 1));
      AddTex(G2Vec2(0.5, 1));
      AddTex(G2Vec2(0.5, 1));
      AddTex(G2Vec2(0, 1));
      AddTex(G2Vec2(0, 0.5));
      AddTex(G2Vec2(0, 0.5));
      AddTex(G2Vec2(0.5, 0.5));
      AddTex(G2Vec2(0.5, 0.5));
      AddTex(G2Vec2(0.5, 0.5));
      AddTex(G2Vec2(0.5, 0.5));

      AddInd(0); AddInd(1); AddInd(12);
      AddInd(0); AddInd(12); AddInd(11);
      AddInd(12); AddInd(1); AddInd(2);
      AddInd(12); AddInd(2); AddInd(13);
      AddInd(13); AddInd(2); AddInd(3);
      AddInd(13); AddInd(3); AddInd(4);
      AddInd(14); AddInd(13); AddInd(4);
      AddInd(14); AddInd(4); AddInd(5);
      AddInd(14); AddInd(5); AddInd(6);
      AddInd(14); AddInd(6); AddInd(7);
      AddInd(8); AddInd(15); AddInd(14);
      AddInd(8); AddInd(14); AddInd(7);
      AddInd(9); AddInd(15); AddInd(8);
      AddInd(9); AddInd(10); AddInd(15);
      AddInd(10); AddInd(11); AddInd(12);
      AddInd(10); AddInd(12); AddInd(15);
      AddInd(15); AddInd(12); AddInd(13);
      AddInd(15); AddInd(13); AddInd(14);
    end;
    Render2D.DrawEnd;

    if Assigned(Img) then
    begin
      Render.TextureSet(Img);
      Render2D.DrawRect(
        (R.Left + R.Right - Img.Width) * 0.5,
        (R.Top + R.Bottom - Img.Height) * 0.5,
        Img.Width, Img.Height, $ffffffff,
        Img, 0, 1, 1, FlipH, FlipV
      );
    end;

    if Length(Text) > 0 then
    begin
      RenderModes.FilteringPoint();
      PrevScissorEnable := Gfx.RenderStates.ScissorTestEnable;
      if not PrevScissorEnable then
      Gfx.RenderStates.ScissorTestEnable := True;
      Gfx.Device.GetScissorRect(PrevScissorRect);
      ScR := Rect(R.Left + 6, R.Top + 4, R.Right - 4, R.Bottom - 6);
      if PrevScissorEnable then
      begin
        if ScR.Left < PrevScissorRect.Left then ScR.Left := PrevScissorRect.Left;
        if ScR.Top < PrevScissorRect.Top then ScR.Top := PrevScissorRect.Top;
        if ScR.Right > PrevScissorRect.Right then ScR.Right := PrevScissorRect.Right;
        if ScR.Bottom > PrevScissorRect.Bottom then ScR.Bottom := PrevScissorRect.Bottom;
      end;
      Gfx.Device.SetScissorRect(@ScR);
      if Centered then
      m_Font.Print(
        (R.Left + R.Right - m_Font.GetTextWidth(Text)) * 0.5,
        (R.Top + R.Bottom - m_Font.GetTextHeight(Text)) * 0.5 + tsy,
        $ffffffff, Text
      )
      else
      m_Font.Print(
        R.Left + 12,
        (R.Top + R.Bottom - m_Font.GetTextHeight(Text)) * 0.5 + tsy,
        $ffffffff, Text
      );
      if not PrevScissorEnable then
      Gfx.RenderStates.ScissorTestEnable := False
      else
      Gfx.Device.SetScissorRect(@PrevScissorRect);
      RenderModes.FilteringLinear();
    end;
  end;
end;

procedure TMyApp.OnRender;
var
  str: AnsiString;
  X, Y, W, H: Integer;
begin
  ToolTipMsg := '';
  Gfx.RenderStates.AlphaRef := 1;
  Render.RenderStart;
  Render.Clear(False, False, True, $ff888888);

  RenderModes.FilteringLinear();
  RenderBackground;
  if Menu.CurItemName = 'Data' then
  Res.Render
  else if Menu.CurItemName = 'File' then
  Opt.Render;
  Edit.Render;
  Menu.Render;
  RenderTitle;
  RenderBorder;
  RenderModes.FilteringPoint();

  Font.Print(16, Gfx.Params.Height - Font.GetTextHeight(LogStr) - 8, $ff888888, LogStr);
  str := 'DAN SOFT STUDIO';
  Font.Print(
    Gfx.Params.Width - Font.GetTextWidth(str) - 32,
    Gfx.Params.Height - Font.GetTextHeight(str) - 6,
    $ffffffff, str
  );

  if Length(ToolTipMsg) > 0 then
  begin
    W := Font.GetTextWidth(ToolTipMsg) + 8;
    H := Font.GetTextHeight(ToolTipMsg);
    X := PlugInput.MousePos.X + 16;
    Y := PlugInput.MousePos.Y + 16;
    if X + W > Gfx.Params.Width - 16 then
    X := Gfx.Params.Width - 16 - W;
    if Y + H > Gfx.Params.Height - 16 then
    Y := Gfx.Params.Height - 16 - H;
    Render.TextureClear();
    Prim2D.DrawRect4Col(
      X, Y, W, H,
      $88008800, $88008800,
      $88004400, $88004400
    );
    Prim2D.DrawLine(G2Vec2(X, Y), G2Vec2(X + W, Y), $8800aa00);
    Prim2D.DrawLine(G2Vec2(X, Y), G2Vec2(X, Y + H), $8800aa00);
    Prim2D.DrawLine(G2Vec2(X + W, Y), G2Vec2(X + W, Y + H), $8800aa00);
    Prim2D.DrawLine(G2Vec2(X, Y + H), G2Vec2(X + W, Y + H), $8800aa00);
    Font.Print(X + 4, Y, $ffffffff, ToolTipMsg)
  end;

  Render.RenderStop;
  Render.Present;
end;

procedure TMyApp.OnUpdate;
begin
  if AppClose then
  begin
    Tmr.Enabled := False;
    Form1.Close;
  end
  else
  begin
    Edit.Update;
    bgGrad := bgGrad + 0.0015;
  end;
end;

procedure TMyApp.OnKeyDown(const Key: Byte);
begin
  if Edit.Active then
  Edit.OnKeyDown(Key)
  else
  begin
    if (PlugInput.KeyDown[DIK_LCONTROL] or PlugInput.KeyDown[DIK_RCONTROL])
    and (Key = DIK_S) then
    begin
      if FileExists(CurOpenFile) then
      App.SavePack(CurOpenFile)
      else if Form1.sd2.Execute then
      SavePack(Form1.sd2.FileName);
      FreezeInputTime := GetTickCount;
    end;
  end;
  //if Key = DIK_ESCAPE then
  //AppClose := True;
end;

procedure TMyApp.OnKeyUp(const Key: Byte);
begin

end;

procedure TMyApp.OnMouseDown(const Button: Byte);
begin
  m_MD := App.PlugInput.MousePos;
  if Edit.Active then
  Edit.OnMouseDown(Button)
  else
  begin
    if Menu.CurItemName = 'Data' then
    Res.OnMouseDown(Button)
    else if Menu.CurItemName = 'File' then
    Opt.OnMouseDown(Button);
  end;
end;

procedure TMyApp.OnMouseUp(const Button: Byte);
begin
  Res.ScrollHold := False;
  if Edit.Active then
  Edit.OnMouseUp(Button)
  else
  begin
    if Menu.CurItemName = 'Data' then
    Res.OnMouseUp(Button)
    else if Menu.CurItemName = 'File' then
    Opt.OnMouseUp(Button);
  end;
end;

procedure TMyApp.OnWheelMove(const Shift: Integer);
begin
  if not Edit.Active then
  begin
    if (Menu.CurItemName = 'Data')
    and PtInRect(
      Res.RectList,
      PlugInput.MousePos
    ) then
    Res.OnWheelMove(Shift);
  end;
end;

procedure TMyApp.ReadParams;
var
  fs: TFileStream;
  n: DWord;
  i: Integer;
  b: Byte;
begin
  if FileExists(AppPath + 'G2Packer.cfg') then
  begin
    fs := TFileStream.Create(AppPath + 'G2Packer.cfg', fmOpenRead);
    fs.Read(n, 4);
    SetLength(EncKey, n);
    fs.Read(EncKey[1], n);
    fs.Read(i, 4); Form1.Left := i;
    fs.Read(i, 4); Form1.Top := i;
    fs.Read(i, 4); Form1.Width := i;
    fs.Read(i, 4); Form1.Height := i;
    fs.Read(b, 1);
    if b = 1 then
    Form1.WindowState := wsMaximized
    else
    Form1.WindowState := wsNormal;
    fs.Free;
  end;
end;

procedure TMyApp.WriteParams;
var
  fs: TFileStream;
  n: DWord;
  i: Integer;
  b: Byte;
begin
  fs := TFileStream.Create(AppPath + 'G2Packer.cfg', fmCreate);
  n := Length(EncKey);
  fs.Write(n, 4);
  fs.Write(EncKey[1], n);
  if Form1.WindowState = wsMaximized then
  b := 1
  else
  b := 0;
  Form1.WindowState := wsNormal;
  i := Form1.Left; fs.Write(i, 4);
  i := Form1.Top; fs.Write(i, 4);
  i := Form1.Width; fs.Write(i, 4);
  i := Form1.Height; fs.Write(i, 4);
  fs.Write(b, 1);
  fs.Free;
end;

function TMyApp.GetSizeString(const Size: DWord): AnsiString;
begin
  if Size < 1024 then
  Result := IntToStr(Size) + 'Bytes'
  else if Size < 1048576 then
  Result := IntToStr(Size div 1024) + 'Kb'
  else if Size < 1073741824 then
  Result := IntToStr(Size div 1048576) + 'Mb'
  else if Size < 1099511627776 then
  Result := IntToStr(Size div 1073741824) + 'Gb'
  else
  Result := IntToStr(Size div 1099511627776) + 'Tb';
end;

procedure TMyApp.Initialize;
var
  i: Integer;
begin
  AppClose := False;
  Tmr.MaxFPS := 0;
  inherited Initialize;
  g2.RequestMod(TG2TextureMgr, @MgrTextures);
  Font := Gfx.Shared.RequestFont('Times New Roman', 12);
  Cam.SetPerspective(QuatPi, 4/3, 0.1, 10000);
  Cam.SetView(250, 300, 250, 500, 100, 500, 0, 1, 0);
  Gfx.Transforms.P := Cam.Proj;
  Gfx.Transforms.V := Cam.View;
  Gfx.Transforms.ApplyV;
  Gfx.Transforms.ApplyP;
  TexBorder := MgrTextures.CreateTexture2DFromBuffer('Border', @ImgBorder, Length(ImgBorder), 1);
  TexGrad := MgrTextures.CreateTexture2DFromBuffer('Grad', @ImgGrad, Length(ImgGrad), 1, D3DFMT_A8R8G8B8);
  TexTopBG := MgrTextures.CreateTexture2DFromBuffer('TopBG', @ImgTopBG, Length(ImgTopBG), 1);
  TexTitle := MgrTextures.CreateTexture2DFromBuffer('Title', @ImgTitle, Length(ImgTitle), 1, D3DFMT_A8R8G8B8);
  TexBtn1 := MgrTextures.CreateTexture2DFromBuffer('Btn1', @ImgButton1, Length(ImgButton1), 1);
  TexBtn1H := MgrTextures.CreateTexture2DFromBuffer('Btn1H', @ImgButton1Hover, Length(ImgButton1Hover), 1);
  TexBtn1D := MgrTextures.CreateTexture2DFromBuffer('Btn1D', @ImgButton1Down, Length(ImgButton1Down), 1);
  TexBtn2 := MgrTextures.CreateTexture2DFromBuffer('Btn2', @ImgButton2, Length(ImgButton2), 1);
  TexBtn2H := MgrTextures.CreateTexture2DFromBuffer('Btn2H', @ImgButton2Hover, Length(ImgButton2Hover), 1);
  TexBtn2D := MgrTextures.CreateTexture2DFromBuffer('Btn2D', @ImgButton2Down, Length(ImgButton2Down), 1);
  TexBtn3 := MgrTextures.CreateTexture2DFromBuffer('Btn3', @ImgButton3, Length(ImgButton3), 1);
  TexBtn3H := MgrTextures.CreateTexture2DFromBuffer('Btn3H', @ImgButton3Hover, Length(ImgButton3Hover), 1);
  TexBtn3D := MgrTextures.CreateTexture2DFromBuffer('Btn3D', @ImgButton3Down, Length(ImgButton3Down), 1);
  TexBtn4 := MgrTextures.CreateTexture2DFromBuffer('Btn4', @ImgButton4, Length(ImgButton4), 1);
  TexBtn4H := MgrTextures.CreateTexture2DFromBuffer('Btn4H', @ImgButton4Hover, Length(ImgButton4Hover), 1);
  TexBtn4D := MgrTextures.CreateTexture2DFromBuffer('Btn4D', @ImgButton4Down, Length(ImgButton4Down), 1);
  TexArrow := MgrTextures.CreateTexture2DFromBuffer('Arrow', @ImgArrow, Length(ImgArrow), 1);
  TexLockOpen := MgrTextures.CreateTexture2DFromBuffer('LockOpen', @ImgLockOpen, Length(ImgLockOpen), 1);
  TexLockShut := MgrTextures.CreateTexture2DFromBuffer('LockShut', @ImgLockShut, Length(ImgLockShut), 1);
  TexCompressed := MgrTextures.CreateTexture2DFromBuffer('Compressed', @ImgCompressed, Length(ImgCompressed), 1);
  TexUncompressed := MgrTextures.CreateTexture2DFromBuffer('Uncompressed', @ImgUncompressed, Length(ImgUncompressed), 1);
  m_Font := Gfx.Shared.RequestFont('Times New Roman', 12);
  Randomize;
  for i := 0 to High(bg[0]) do
  begin
    bg[0][i] := 0.5 - Random(31) * 0.01;
    bg[1][i] := 0.5 + Random(31) * 0.01;
  end;
  bgGrad := 0;
  Menu := TMenu.Create;
  Menu.AddItem('File', nil);
  Menu.AddItem('Data', nil);
  Res := TResources.Create;
  Res.Adjust;
  Opt := TOptions.Create;
  Opt.Adjust;
  Edit := TEditBox.Create;
  CurOpenFile := '';
  EncKey := '';
  LogStr := '';
  ReadParams;
  if FileExists(ParamStr(1)) then
  LoadPack(ParamStr(1));
  Tmr.Enabled := True;
end;

procedure TMyApp.Finalize;
begin
  WriteParams;
  Edit.Free;
  Opt.Free;
  Res.Free;
  Menu.Free;
  inherited Finalize;
end;
//TMyApp END

procedure TForm1.ApplicationEvents1Activate(Sender: TObject);
begin
  App.Tmr.Enabled := True;      
end;

procedure TForm1.ApplicationEvents1Deactivate(Sender: TObject);
begin
  App.Tmr.Enabled := False;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  App.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.ClientWidth := 800;
  Form1.ClientHeight := 500;
  App := TMyApp.Create;
  App.Handle := Form1.Handle;
  App.Gfx.InitParams.Width := Form1.ClientWidth;
  App.Gfx.InitParams.Height := Form1.ClientHeight;
  App.Initialize;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  if Assigned(App)
  and App.g2.Initialized then
  with App do
  begin
    Gfx.Params.Width := Form1.ClientWidth;
    Gfx.Params.Height := Form1.ClientHeight;
    Gfx.Params.Apply;
    Res.Adjust;
    Opt.Adjust;
    Tmr.OnTimer;
    OnRender;
  end;
end;

end.
