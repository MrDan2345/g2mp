unit G2DataManager;
{$include Gen2MP.inc}
interface

uses
  {$if defined(G2Target_OSX)}
  MacOSAll,
  {$elseif defined(G2Target_Android)}
  G2AndroidBinding,
  {$elseif defined(G2Target_iOS)}
  iPhoneAll,
  {$endif}
  Classes,
  SysUtils,
  G2Types,
  G2Math,
  G2Utils,
  ZBase,
  ZInflate,
  Zdeflate;

type
  TG2Codec = (cdNone, cdZLib);

  TG2DataMode = (dmAsset, dmRead, dmWrite, dmModify, dmAssetNoPacks);

  TG2DataControl = class
  protected
    function GetPosition: TG2IntS64; virtual; abstract;
    procedure SetPosition(const Value: TG2IntS64); virtual; abstract;
    function GetSize: TG2IntS64; virtual; abstract;
  public
    property Position: TG2IntS64 read GetPosition write SetPosition;
    property Size: TG2IntS64 read GetSize;
    function ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; virtual;
    function WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; virtual;
  end;

  TG2DataControlFile = class (TG2DataControl)
  private
    {$if defined(G2Target_iOS)}
    _fh: NSFileHandle;
    {$endif}
    _fs: TFileStream;
  protected
    function GetPosition: TG2IntS64; override;
    procedure SetPosition(const Value: TG2IntS64); override;
    function GetSize: TG2IntS64; override;
  public
    function ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; override;
    function WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; override;
    constructor Create(const FileName: FileString; const Mode: TG2DataMode);
    destructor Destroy; override;
  end;

  {$ifdef G2Target_Android}
  TG2DataControlAndroidAsset = class (TG2DataControl)
  private
    _Position: IntS64;
    _Size: IntS64;
  protected
    function GetPosition: IntS64; override;
    procedure SetPosition(const Value: IntS64); override;
    function GetSize: IntS64; override;
  public
    function ReadBuffer(const Buffer: Pointer; const Count: IntS64): IntS64; override;
    function WriteBuffer(const Buffer: Pointer; const Count: IntS64): IntS64; override;
    constructor Create(const FileName: FileString; const Mode: TG2DataMode);
    destructor Destroy; override;
  end;

  TG2DataControlAndroidFile = class (TG2DataControl)
  private
    _Position: IntS64;
    _Size: IntS64;
  protected
    function GetPosition: IntS64; override;
    procedure SetPosition(const Value: IntS64); override;
    function GetSize: IntS64; override;
  public
    function ReadBuffer(const Buffer: Pointer; const Count: IntS64): IntS64; override;
    function WriteBuffer(const Buffer: Pointer; const Count: IntS64): IntS64; override;
    constructor Create(const FileName: FileString; const Mode: TG2DataMode);
    destructor Destroy; override;
  end;
  {$endif}

  TG2DataControlStream = class (TG2DataControl)
  private
    _ds: TStream;
  protected
    function GetPosition: TG2IntS64; override;
    procedure SetPosition(const Value: TG2IntS64); override;
    function GetSize: TG2IntS64; override;
  public
    function ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; override;
    function WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; override;
    constructor Create(const Stream: TStream; const Mode: TG2DataMode);
    destructor Destroy; override;
  end;

  TG2DataControlBuffer = class (TG2DataControl)
  private
    _Buffer: Pointer;
    _Size: TG2IntS64;
    _Position: TG2IntS64;
  protected
    function GetPosition: TG2IntS64; override;
    procedure SetPosition(const Value: TG2IntS64); override;
    function GetSize: TG2IntS64; override;
  public
    function ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; override;
    function WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; override;
    constructor Create(const Buffer: Pointer; const BufferSize: TG2IntS64; const Mode: TG2DataMode);
    destructor Destroy; override;
  end;

  TG2DataControlCache = class (TG2DataControl)
  private
    _Buffer: Pointer;
    _Size: TG2IntS64;
    _Position: TG2IntS64;
  protected
    function GetPosition: TG2IntS64; override;
    procedure SetPosition(const Value: TG2IntS64); override;
    function GetSize: TG2IntS64; override;
  public
    function ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; override;
    function WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; override;
    constructor Create(const Control: TG2DataControl); overload;
    constructor Create(const Buffer: Pointer; const BufferSize: TG2IntS64); overload;
    destructor Destroy; override;
  end;

  TG2DataReadProc = function (const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64 of object;
  TG2DataWriteProc = function (const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64 of object;

  TG2DataCodec = class
  public
    ReadBufferProc: TG2DataReadProc;
    WriteBufferProc: TG2DataWriteProc;
    function ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; virtual; abstract;
    function WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; virtual; abstract;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TG2DataCodecZLib = class (TG2DataCodec)
  private
    _Buffer: array[Word] of TG2IntU8;
    _RecCompr: z_stream;
    _RecDecom: z_stream;
    _Deflating: Boolean;
    _Inflating: Boolean;
  public
    function ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; override;
    function WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TG2DataManager = class
  private
    _Mode: TG2DataMode;
    _CodecMode: TG2Codec;
    _Control: TG2DataControl;
    _Codec: TG2DataCodec;
    _ProcReadBuffer: TG2DataReadProc;
    _ProcWriteBuffer: TG2DataWriteProc;
    function ReadBufferDirect(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
    function WriteBufferDirect(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
    function ReadBufferCodec(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
    function WriteBufferCodec(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
    function GetPosition: TG2IntS64; inline;
    procedure SetPosition(const Value: TG2IntS64); inline;
    function GetSize: TG2IntS64; inline;
    function GetCodec: TG2Codec;
    procedure SetCodec(const Value: TG2Codec);
    procedure Init;
  public
    property Position: TG2IntS64 read GetPosition write SetPosition;
    property Size: TG2IntS64 read GetSize;
    property Codec: TG2Codec read GetCodec write SetCodec;
    function ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
    function ReadBool: Boolean;
    function ReadIntU8: TG2IntU8;
    function ReadIntU16: TG2IntU16;
    function ReadIntU32: TG2IntU32;
    function ReadIntS8: TG2IntS8;
    function ReadIntS16: TG2IntS16;
    function ReadIntS32: TG2IntS32;
    function ReadIntS64: TG2IntS64;
    function ReadFloat: TG2Float;
    function ReadDouble: Double;
    function ReadColor: TG2Color;
    function ReadStringA: AnsiString;
    function ReadStringANT: AnsiString;
    function ReadVec2: TG2Vec2;
    function ReadVec3: TG2Vec3;
    function ReadVec4: TG2Vec4;
    function ReadMat4x4: TG2Mat;
    function ReadMat4x3: TG2Mat;
    function ReadMat3x3: TG2Mat;
    function WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
    procedure WriteBool(const Value: Boolean);
    procedure WriteIntU8(const Value: TG2IntU8);
    procedure WriteIntU16(const Value: TG2IntU16);
    procedure WriteIntU32(const Value: TG2IntU32);
    procedure WriteIntS8(const Value: TG2IntS8);
    procedure WriteIntS16(const Value: TG2IntS16);
    procedure WriteIntS32(const Value: TG2IntS32);
    procedure WriteIntS64(const Value: TG2IntS64);
    procedure WriteFloat(const Value: TG2Float);
    procedure WriteDouble(const Value: Double);
    procedure WriteColor(const Value: TG2Color);
    procedure WriteStringA(const Value: AnsiString);
    procedure WriteStringANT(const Value: AnsiString);
    procedure WriteVec2(const Value: TG2Vec2);
    procedure WriteVec3(const Value: TG2Vec3);
    procedure WriteVec4(const Value: TG2Vec4);
    procedure Skip(const Count: TG2IntS64);
    constructor Create(const FileName: FileString; const Mode: TG2DataMode = dmAsset); overload;
    constructor Create(const Stream: TStream; const Mode: TG2DataMode = dmRead); overload;
    constructor Create(const Buffer: Pointer; const BufferSize: TG2IntS64; const Mode: TG2DataMode = dmRead); overload;
    destructor Destroy; override;
  end;

  TG2PackCRC = packed record
    Pos: TG2IntU32;
    Num: TG2IntU8;
  end;

  TG2PackFile = record
    Name: AnsiString;
    Encrypted: Boolean;
    Compressed: Boolean;
    DataPos: TG2IntU32;
    DataLength: TG2IntU32;
    OriginalSize: TG2IntU32;
    Data: array of TG2IntU8;
    CRC: array[0..7] of TG2PackCRC;
  end;
  PG2PackFile = ^TG2PackFile;

  TG2PackFolder = record
    Name: AnsiString;
    Files: array of TG2PackFile;
  end;
  PG2PackFolder = ^TG2PackFolder;

  TG2Pack = object
  private
    _Key: AnsiString;
    _PackAlias: AnsiString;
    _FName: FileString;
    _Folders: array of TG2PackFolder;
    _DataPos: TG2IntU32;
  public
    property Key: AnsiString read _Key write _Key;
    property FName: FileString read _FName;
    property PackAlias: AnsiString read _PackAlias;
    procedure Connect(const FileName: FileString);
    procedure Disconnect;
    procedure GetFileData(const FolderName, FileName: AnsiString; var Data: Pointer; var DataSize: TG2IntU32);
    function FileExists(const FolderName, FileName: AnsiString): Boolean;
  end;
  PG2Pack = ^TG2Pack;

  TG2PackLinker = class
  private
    _Packs: TG2QuickList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LinkPack(const FileName: FileString; const Key: AnsiString = '');
    procedure UnLinkPack(const PackAlias: AnsiString);
    procedure GetFileData(const Path: AnsiString; var Data: Pointer; var DataSize: TG2IntU32);
    function FileExists(const Path: AnsiString): Boolean;
  end;

var G2DataManagerChachedRead: Boolean = False;
var G2PackLinker: TG2PackLinker = nil;

function G2FileExists(const FileName: FileString): Boolean;
function G2GetAppPath: FileString;
procedure G2ZLibDecompress(const Data: Pointer; const Size: TG2IntS64; const Output: TStream); overload;
procedure G2ZLibDecompress(const Data: Pointer; const Size: TG2IntS64; const Output: Pointer); overload;
procedure G2ZLibDecompress(const Data: Pointer; const Size: TG2IntS64; const Output: TG2DataManager); overload;
procedure G2ZLibCompress(const Data: Pointer; const Size: TG2IntS64; const Output: TStream); overload;
procedure G2ZLibCompress(const Data: Pointer; const Size: TG2IntS64; const Output: Pointer); overload;
procedure G2ZLibCompress(const Data: Pointer; const Size: TG2IntS64; const Output: TG2DataManager); overload;

implementation

{$Hints off}
//TG2DataControl BEGIN
function TG2DataControl.ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
begin
  Result := 0;
end;

function TG2DataControl.WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
begin
  Result := 0;
end;
//TG2DataControl END
{$Hints on}

//TG2DataControlFile BEGIN
function TG2DataControlFile.GetPosition: TG2IntS64;
{$if defined(G2Target_iOS)}
begin
  Result := _fh.offsetInFile;
end;
{$else}
begin
  Result := _fs.Position;
end;
{$endif}

procedure TG2DataControlFile.SetPosition(const Value: TG2IntS64);
{$if defined(G2Target_iOS)}
begin
  _fh.seekToFileOffset(Value);
end;
{$else}
begin
  _fs.Position := Value;
end;
{$endif}

function TG2DataControlFile.GetSize: TG2IntS64;
{$if defined(G2Target_iOS)}
  var d: NSData;
  var CurOffset: TG2IntS64;
begin
  CurOffset := _fh.offsetInFile;
  _fh.seekToFileOffset(0);
  d := _fh.availableData;
  Result := d.length;
  d := nil;
  _fh.seekToFileOffset(CurOffset);
end;
{$else}
begin
  Result := _fs.Size;
end;
{$endif}

function TG2DataControlFile.ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
{$if defined(G2Target_iOS)}
  var d: NSData;
begin
  d := _fh.readDataOfLength(Count);
  Result := d.length;
  Move(d.bytes^, Buffer^, Result);
  d := nil;
end;
{$else}
begin
  Result := _fs.Read(Buffer^, Count);
end;
{$endif}

function TG2DataControlFile.WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
{$if defined(G2Target_iOS)}
  var d: NSData;
begin
  d := NSData.dataWithBytes_length(Buffer, Count);
  _fh.writeData(d);
  d := nil;
end;
{$else}
begin
  Result := _fs.Write(Buffer^, Count);
end;
{$endif}

constructor TG2DataControlFile.Create(const FileName: FileString; const Mode: TG2DataMode);
begin
  inherited Create;
  {$if defined(G2Target_iOS)}
  case Mode of
    dmRead, dmAsset, dmAssetNoPacks: _fh := NSFileHandle.fileHandleForReadingAtPath(G2NSStr(FileName));
    dmWrite: _fh := NSFileHandle.fileHandleForWritingAtPath(G2NSStr(FileName));
    dmModify: _fh := NSFileHandle.fileHandleForUpdatingAtPath(G2NSStr(FileName));
  end;
  _fh.seekToFileOffset(0);
  {$else}
  case Mode of
    dmRead, dmAsset, dmAssetNoPacks: _fs := TFileStream.Create(FileName, fmOpenRead);
    dmWrite: _fs := TFileStream.Create(FileName, fmCreate);
    dmModify: _fs := TFileStream.Create(FileName, fmOpenReadWrite);
  end;
  {$endif}
end;

destructor TG2DataControlFile.Destroy;
begin
  {$if defined(G2Target_iOS)}
  _fh.closeFile;
  _fh := nil;
  {$else}
  _fs.Free;
  {$endif}
  inherited Destroy;
end;
//TG2DataControlFile END

{$ifdef G2Target_Android}
//TG2DataControlAndroidAsset BEGIN
function TG2DataControlAndroidAsset.GetPosition: IntS64;
begin
  Result := _Position;
end;

procedure TG2DataControlAndroidAsset.SetPosition(const Value: IntS64);
begin
  _Position := Value;
  AndroidBinding.FASetPos(_Position);
end;

function TG2DataControlAndroidAsset.GetSize: IntS64;
begin
  Result := _Size;
end;

function TG2DataControlAndroidAsset.ReadBuffer(const Buffer: Pointer; const Count: IntS64): IntS64;
begin
  Result := AndroidBinding.FARead(Buffer, Count);
  Inc(_Position, Result);
end;

function TG2DataControlAndroidAsset.WriteBuffer(const Buffer: Pointer; const Count: IntS64): IntS64;
begin
  //Cannot write to android assets
end;

constructor TG2DataControlAndroidAsset.Create(const FileName: FileString; const Mode: TG2DataMode);
begin
  _Position := 0;
  _Size := AndroidBinding.FAOpen(FileName, Length(FileName));
end;

destructor TG2DataControlAndroidAsset.Destroy;
begin
  AndroidBinding.FAClose();
end;
//TG2DataControlAndroidAsset END

//TG2DataControlAndroidFile BEGIN
function TG2DataControlAndroidFile.GetPosition: IntS64;
begin
  Result := _Position;
end;

procedure TG2DataControlAndroidFile.SetPosition(const Value: IntS64);
begin
  _Position := Value;
  AndroidBinding.FSetPos(_Position);
end;

function TG2DataControlAndroidFile.GetSize: IntS64;
begin
  Result := _Size;
end;

function TG2DataControlAndroidFile.ReadBuffer(const Buffer: Pointer; const Count: IntS64): IntS64;
begin
  Result := AndroidBinding.FRead(Buffer, Count);
  Inc(_Position, Result);
end;

function TG2DataControlAndroidFile.WriteBuffer(const Buffer: Pointer; const Count: IntS64): IntS64;
begin
  AndroidBinding.FWrite(Buffer, Count);
  Inc(_Position, Count);
end;

constructor TG2DataControlAndroidFile.Create(const FileName: FileString; const Mode: TG2DataMode);
begin
  _Position := 0;
  _Size := 0;
  case Mode of
    dmRead: _Size := AndroidBinding.FOpenInput(FileName, Length(FileName));
    dmWrite, dmModify: AndroidBinding.FOpenOutput(FileName, Length(FileName));
  end;
end;

destructor TG2DataControlAndroidFile.Destroy;
begin
  AndroidBinding.FClose();
end;
//TG2DataControlAndroidFile END
{$endif}

//TG2DataControlStream BEGIN
function TG2DataControlStream.GetPosition: TG2IntS64;
begin
  Result := _ds.Position;
end;

procedure TG2DataControlStream.SetPosition(const Value: TG2IntS64);
begin
  _ds.Position := Value;
end;

function TG2DataControlStream.GetSize: TG2IntS64;
begin
  Result := _ds.Size;
end;

function TG2DataControlStream.ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
begin
  Result := _ds.Read(Buffer^, Count);
end;

function TG2DataControlStream.WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
begin
  Result := _ds.Write(Buffer^, Count);
end;

{$Hints off}
constructor TG2DataControlStream.Create(const Stream: TStream; const Mode: TG2DataMode);
begin
  inherited Create;
  _ds := Stream;
end;
{$Hints on}

destructor TG2DataControlStream.Destroy;
begin
  inherited Destroy;
end;
//TG2DataControlStream END

//TG2DataControlBuffer BEGIN
function TG2DataControlBuffer.GetPosition: TG2IntS64;
begin
  Result := _Position;
end;

procedure TG2DataControlBuffer.SetPosition(const Value: TG2IntS64);
begin
  _Position := Value;
end;

function TG2DataControlBuffer.GetSize: TG2IntS64;
begin
  Result := _Size;
end;

function TG2DataControlBuffer.ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
  var MoveSize: Int64;
begin
  MoveSize := _Size - _Position;
  if Count < MoveSize then MoveSize := Count;
  System.Move((_Buffer + _Position)^, Buffer^, MoveSize);
  Inc(_Position, MoveSize);
  Result := MoveSize;
end;

function TG2DataControlBuffer.WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
  var MoveSize: TG2IntS64;
begin
  MoveSize := _Size - _Position;
  if Count < MoveSize then MoveSize := Count;
  System.Move(Buffer^, (_Buffer + _Position)^, Count);
  Inc(_Position, Count);
  Result := MoveSize;
end;

{$Hints off}
constructor TG2DataControlBuffer.Create(const Buffer: Pointer; const BufferSize: TG2IntS64; const Mode: TG2DataMode);
begin
  inherited Create;
  _Buffer := Buffer;
  _Size := BufferSize;
  _Position := 0;
end;
{$Hints on}

destructor TG2DataControlBuffer.Destroy;
begin
  inherited Destroy;
end;
//TG2DataControlBuffer END

//TG2DataControlCache BEGIN
function TG2DataControlCache.GetPosition: TG2IntS64;
begin
  Result := _Position;
end;

procedure TG2DataControlCache.SetPosition(const Value: TG2IntS64);
begin
  _Position := Value;
end;

function TG2DataControlCache.GetSize: TG2IntS64;
begin
  Result := _Size;
end;

function TG2DataControlCache.ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
  var MoveSize: TG2IntS64;
begin
  MoveSize := _Size - _Position;
  if Count < MoveSize then MoveSize := Count;
  System.Move(PByteArray(_Buffer)^[_Position], Buffer^, MoveSize);
  Inc(_Position, MoveSize);
  Result := MoveSize;
end;

function TG2DataControlCache.WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
  var MoveSize: TG2IntS64;
begin
  MoveSize := _Size - _Position;
  if Count < MoveSize then MoveSize := Count;
  System.Move(Buffer^, PByteArray(_Buffer)^[_Position], Count);
  Inc(_Position, Count);
  Result := MoveSize;
end;

{$Hints off}
constructor TG2DataControlCache.Create(const Control: TG2DataControl);
begin
  inherited Create;
  _Position := 0;
  _Size := Control.Size - Control.Position;
  GetMem(_Buffer, _Size);
  Control.ReadBuffer(_Buffer, _Size);
end;

constructor TG2DataControlCache.Create(const Buffer: Pointer; const BufferSize: TG2IntS64);
begin
  inherited Create;
  _Position := 0;
  _Buffer := Buffer;
  _Size := BufferSize;
end;
{$Hints on}

destructor TG2DataControlCache.Destroy;
begin
  FreeMem(_Buffer, _Size);
  inherited Destroy;
end;
//TG2DataControlCache END

//TG2DataCodec BEGIN
constructor TG2DataCodec.Create;
begin
  inherited Create;
end;

destructor TG2DataCodec.Destroy;
begin
  inherited Destroy;
end;
//TG2DataCodec END

//TG2DataCodecZLib BEGIN
function TG2DataCodecZLib.ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
  var ZResult: TG2IntS32;
begin
  if not _Inflating then
  begin
    _RecDecom.next_in := @_Buffer;
    _RecDecom.avail_in := 0;
    InflateInit(_RecDecom);
    _Inflating := True;
  end;
  _RecDecom.next_out := Buffer;
  _RecDecom.avail_out := Count;
  ZResult := Z_OK;
  while (_RecDecom.avail_out > 0) and (ZResult <> Z_STREAM_END) do
  begin
    if _RecDecom.avail_in = 0 then
    begin
      _RecDecom.avail_in := ReadBufferProc(@_Buffer, SizeOf(_Buffer));
      if _RecDecom.avail_in = 0 then Exit;
      _RecDecom.next_in := @_Buffer;
    end;
    ZResult := inflate(_RecDecom, Z_NO_FLUSH);
  end;
  Result := Count - _RecDecom.avail_out;
end;

function TG2DataCodecZLib.WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
begin
  if not _Deflating then
  begin
    _RecCompr.avail_out := SizeOf(_Buffer);
    _RecCompr.next_out := @_Buffer;
    DeflateInit(_RecCompr, Z_BEST_COMPRESSION);
    _Deflating := True;
  end;
  _RecCompr.next_in := Buffer;
  _RecCompr.avail_in := Count;
  while _RecCompr.avail_in > 0 do
  begin
    deflate(_RecCompr, Z_NO_FLUSH);
    if _RecCompr.avail_out = 0 then
    begin
      WriteBufferProc(@_Buffer, SizeOf(_Buffer));
      _RecCompr.avail_out := SizeOf(_Buffer);
      _RecCompr.next_out := @_Buffer;
    end;
  end;
  Result := Count - _RecDecom.avail_in;
end;

constructor TG2DataCodecZLib.Create;
begin
  inherited Create;
  _Deflating := False;
  _Inflating := False;
end;

destructor TG2DataCodecZLib.Destroy;
begin
  if _Deflating then
  begin
    _RecCompr.next_in := nil;
    _RecCompr.avail_in := 0;
    try
      while deflate(_RecCompr, Z_FINISH) <> Z_STREAM_END do
      begin
        WriteBufferProc(@_Buffer, SizeOf(_Buffer) - _RecCompr.avail_out);
        _RecCompr.next_out := _Buffer;
        _RecCompr.avail_out := SizeOf(_Buffer);
      end;
      if _RecCompr.avail_out < SizeOf(_Buffer) then
      WriteBufferProc(@_Buffer, SizeOf(_Buffer) - _RecCompr.avail_out);
    finally
      deflateEnd(_RecCompr);
    end;
    _Deflating := False;
  end;
  if _Inflating then
  begin
    inflateEnd(_RecDecom);
    _Inflating := False;
  end;
  inherited Destroy;
end;
//TG2DataCodecZLib END

//TG2DataManager BEGIN
function TG2DataManager.ReadBufferDirect(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
  var c: TG2IntS64;
begin
  c := Size - Position;
  if Count < c then c := Count;
  Result := _Control.ReadBuffer(Buffer, c);
end;

function TG2DataManager.WriteBufferDirect(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
begin
  Result := _Control.WriteBuffer(Buffer, Count);
end;

function TG2DataManager.ReadBufferCodec(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
begin
  Result := _Codec.ReadBuffer(Buffer, Count);
end;

function TG2DataManager.WriteBufferCodec(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
begin
  Result := _Codec.WriteBuffer(Buffer, Count);
end;

function TG2DataManager.GetPosition: TG2IntS64;
begin
  Result := _Control.Position;
end;

procedure TG2DataManager.SetPosition(const Value: TG2IntS64);
begin
  _Control.Position := Value;
end;

function TG2DataManager.GetSize: TG2IntS64;
begin
  Result := _Control.Size;
end;

function TG2DataManager.GetCodec: TG2Codec;
begin
  Result := _CodecMode;
end;

procedure TG2DataManager.SetCodec(const Value: TG2Codec);
begin
  if Value <> _CodecMode then
  begin
    if _CodecMode <> cdNone then
    _Codec.Free;
    _CodecMode := Value;
    case _CodecMode of
      cdZLib: _Codec := TG2DataCodecZLib.Create;
    end;
    if _CodecMode = cdNone then
    begin
      _ProcReadBuffer := @ReadBufferDirect;
      _ProcWriteBuffer := @WriteBufferDirect;
    end
    else
    begin
      _Codec.ReadBufferProc := @ReadBufferDirect;
      _Codec.WriteBufferProc := @WriteBufferDirect;
      _ProcReadBuffer := @ReadBufferCodec;
      _ProcWriteBuffer := @WriteBufferCodec;
    end;
  end;
end;

procedure TG2DataManager.Init;
  var CacheCtrl: TG2DataControlCache;
begin
  _CodecMode := cdNone;
  _Codec := nil;
  _ProcReadBuffer := @ReadBufferDirect;
  _ProcWriteBuffer := @WriteBufferDirect;
  if G2DataManagerChachedRead
  and not (_Control is TG2DataControlCache)
  and (
    (_Mode = dmAsset)
    or (_Mode = dmAssetNoPacks)
    or (_Mode = dmRead)
  )then
  begin
    CacheCtrl := TG2DataControlCache.Create(_Control);
    _Control.Destroy;
    _Control := CacheCtrl;
  end;
end;

function TG2DataManager.ReadBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
begin
  Result := _ProcReadBuffer(Buffer, Count);
end;

function TG2DataManager.ReadBool: Boolean;
begin
  ReadBuffer(@Result, 1);
end;

function TG2DataManager.ReadIntU8: TG2IntU8;
begin
  ReadBuffer(@Result, 1);
end;

function TG2DataManager.ReadIntU16: TG2IntU16;
begin
  ReadBuffer(@Result, 2);
end;

function TG2DataManager.ReadIntU32: TG2IntU32;
begin
  ReadBuffer(@Result, 4);
end;

function TG2DataManager.ReadIntS8: TG2IntS8;
begin
  ReadBuffer(@Result, 1);
end;

function TG2DataManager.ReadIntS16: TG2IntS16;
begin
  ReadBuffer(@Result, 2);
end;

function TG2DataManager.ReadIntS32: TG2IntS32;
begin
  ReadBuffer(@Result, 4);
end;

function TG2DataManager.ReadIntS64: TG2IntS64;
begin
  ReadBuffer(@Result, 8);
end;

function TG2DataManager.ReadFloat: TG2Float;
begin
  ReadBuffer(@Result, 4);
end;

function TG2DataManager.ReadDouble: Double;
begin
  ReadBuffer(@Result, 8);
end;

function TG2DataManager.ReadColor: TG2Color;
begin
  {$if defined(G2Gfx_D3D9)}
  ReadBuffer(@Result, 4);
  {$else}
  Result.b := ReadIntU8;
  Result.g := ReadIntU8;
  Result.r := ReadIntU8;
  Result.a := ReadIntU8;
  {$endif}
end;

function TG2DataManager.ReadStringA: AnsiString;
  var l: TG2IntU32;
begin
  l := ReadIntU32;
  SetLength(Result, l);
  ReadBuffer(@Result[1], l);
end;

function TG2DataManager.ReadStringANT: AnsiString;
  var b: TG2IntU8;
begin
  Result := '';
  b := ReadIntU8;
  while b <> 0 do
  begin
    Result := Result + AnsiChar(b);
    b := ReadIntU8;
  end;
end;

function TG2DataManager.ReadVec2: TG2Vec2;
begin
  ReadBuffer(@Result, 8);
end;

function TG2DataManager.ReadVec3: TG2Vec3;
begin
  ReadBuffer(@Result, 12);
end;

function TG2DataManager.ReadVec4: TG2Vec4;
begin
  ReadBuffer(@Result, 16);
end;

function TG2DataManager.ReadMat4x4: TG2Mat;
begin
  ReadBuffer(@Result, SizeOf(TG2Mat));
end;

{$Warnings off}
function TG2DataManager.ReadMat4x3: TG2Mat;
  var m4x3: array[0..3, 0..2] of TG2Float;
begin
  ReadBuffer(@m4x3, SizeOf(m4x3));
  Result.SetValue(
    m4x3[0, 0], m4x3[1, 0], m4x3[2, 0], m4x3[3, 0],
    m4x3[0, 1], m4x3[1, 1], m4x3[2, 1], m4x3[3, 1],
    m4x3[0, 2], m4x3[1, 2], m4x3[2, 2], m4x3[3, 2],
    0, 0, 0, 1
  );
end;
{$Warnings on}

{$Warnings off}
function TG2DataManager.ReadMat3x3: TG2Mat;
  var m3x3: array[0..2, 0..2] of TG2Float;
begin
  ReadBuffer(@m3x3, SizeOf(m3x3));
  Result.SetValue(
    m3x3[0, 0], m3x3[1, 0], m3x3[2, 0], 0,
    m3x3[0, 1], m3x3[1, 1], m3x3[2, 1], 0,
    m3x3[0, 2], m3x3[1, 2], m3x3[2, 2], 0,
    0, 0, 0, 1
  );
end;
{$Warnings on}

function TG2DataManager.WriteBuffer(const Buffer: Pointer; const Count: TG2IntS64): TG2IntS64;
begin
  Result := _ProcWriteBuffer(Buffer, Count);
end;

procedure TG2DataManager.WriteBool(const Value: Boolean);
begin
  WriteBuffer(@Value, 1);
end;

procedure TG2DataManager.WriteIntU8(const Value: TG2IntU8);
begin
  WriteBuffer(@Value, 1);
end;

procedure TG2DataManager.WriteIntU16(const Value: TG2IntU16);
begin
  WriteBuffer(@Value, 2);
end;

procedure TG2DataManager.WriteIntU32(const Value: TG2IntU32);
begin
  WriteBuffer(@Value, 4);
end;

procedure TG2DataManager.WriteIntS8(const Value: TG2IntS8);
begin
  WriteBuffer(@Value, 1);
end;

procedure TG2DataManager.WriteIntS16(const Value: TG2IntS16);
begin
  WriteBuffer(@Value, 2);
end;

procedure TG2DataManager.WriteIntS32(const Value: TG2IntS32);
begin
  WriteBuffer(@Value, 4);
end;

procedure TG2DataManager.WriteIntS64(const Value: TG2IntS64);
begin
  WriteBuffer(@Value, 8);
end;

procedure TG2DataManager.WriteFloat(const Value: TG2Float);
begin
  WriteBuffer(@Value, 4);
end;

procedure TG2DataManager.WriteDouble(const Value: Double);
begin
  WriteBuffer(@Value, 8);
end;

procedure TG2DataManager.WriteColor(const Value: TG2Color);
begin
  {$if defined(G2Gfx_D3D9)}
  WriteBuffer(@Value, 4);
  {$else}
  WriteIntU8(Value.b);
  WriteIntU8(Value.g);
  WriteIntU8(Value.r);
  WriteIntU8(Value.a);
  {$endif}
end;

procedure TG2DataManager.WriteStringA(const Value: AnsiString);
begin
  WriteIntU32(Length(Value));
  WriteBuffer(@Value[1], Length(Value));
end;

procedure TG2DataManager.WriteStringANT(const Value: AnsiString);
begin
  WriteBuffer(@Value[1], Length(Value));
  WriteIntU8(0);
end;

procedure TG2DataManager.WriteVec2(const Value: TG2Vec2);
begin
  WriteBuffer(@Value, 8);
end;

procedure TG2DataManager.WriteVec3(const Value: TG2Vec3);
begin
  WriteBuffer(@Value, 12);
end;

procedure TG2DataManager.WriteVec4(const Value: TG2Vec4);
begin
  WriteBuffer(@Value, 16);
end;

procedure TG2DataManager.Skip(const Count: TG2IntS64);
  var Buff: Pointer;
begin
  if _CodecMode = cdNone then
  Position := Position + Count
  else
  begin
    GetMem(Buff, Count);
    ReadBuffer(Buff, Count);
    FreeMem(Buff);
  end;
end;

constructor TG2DataManager.Create(const FileName: FileString; const Mode: TG2DataMode = dmAsset);
  var fs: FileString;
  var i: TG2IntS32;
  var Buffer: Pointer;
  var BufferSize: TG2IntU32;
begin
  inherited Create;
  _Mode := Mode;
  fs := FileName;
  for i := 1 to Length(fs) do
  if fs[i] = G2PathSepRev then
  fs[i] := G2PathSep;
  {$if defined(G2Target_OSX) or defined(G2Target_iOS)}
  if not G2FileExists(fs) then
  fs := G2GetAppPath + G2PathSep + fs;
  {$endif}
  if (Mode = dmAsset)
  and (G2PackLinker <> nil)
  and G2PackLinker.FileExists(AnsiString(FileName)) then
  begin
    {$Hints off}
    G2PackLinker.GetFileData(AnsiString(FileName), Buffer, BufferSize);
    {$Hints on}
    _Control := TG2DataControlCache.Create(Buffer, BufferSize);
  end
  else
  begin
    {$ifdef G2Target_Android}
    if (Mode = dmAsset) or (Mode = dmAssetNoPacks) then
    _Control := TG2DataControlAndroidAsset.Create(fs, Mode)
    else
    _Control := TG2DataControlAndroidFile.Create(fs, Mode);
    {$else}
    _Control := TG2DataControlFile.Create(fs, Mode);
    {$endif}
  end;
  Init;
end;

constructor TG2DataManager.Create(const Stream: TStream; const Mode: TG2DataMode = dmRead);
begin
  inherited Create;
  _Mode := Mode;
  _Control := TG2DataControlStream.Create(Stream, Mode);
  Init;
end;

constructor TG2DataManager.Create(const Buffer: Pointer; const BufferSize: TG2IntS64; const Mode: TG2DataMode = dmRead);
begin
  inherited Create;
  _Mode := Mode;
  _Control := TG2DataControlBuffer.Create(Buffer, BufferSize, Mode);
  Init;
end;

destructor TG2DataManager.Destroy;
begin
  Codec := cdNone;
  _Control.Free;
  inherited Destroy;
end;
//TG2DataManager END

//TG2Pack BEGIN
procedure TG2Pack.Connect(const FileName: FileString);
  type TPackHeader = packed record
    Definition: array [0..3] of AnsiChar;
    Version: TG2IntU32;
    FolderCount: TG2IntU32;
    DataPos: TG2IntU32;
  end;
  var dm: TG2DataManager;
  var Header: TPackHeader;
  var i, j: TG2IntS32;
  var Str: TG2StrArrA;
begin
  Disconnect;
  _FName := FileName;
  _PackAlias := AnsiString(ExtractFileName(FileName));
  Str := G2StrExplode(_PackAlias, '.');
  if Length(Str) > 1 then
  begin
    _PackAlias := '';
    for i := 0 to High(Str) - 1 do
    _PackAlias := _PackAlias + Str[i];
  end;
  dm := TG2DataManager.Create(_FName, dmAssetNoPacks);
  try
    if dm.Size < SizeOf(TPackHeader) then
    begin
      dm.Free;
      Exit;
    end;
    dm.ReadBuffer(@Header, SizeOf(TPackHeader));
    if Header.Definition <> 'G2PK' then
    begin
      dm.Free;
      Exit;
    end;
    if Header.Version > $00010000 then
    begin
      dm.Free;
      Exit;
    end;
    _DataPos := Header.DataPos;
    SetLength(_Folders, Header.FolderCount);
    for i := 0 to High(_Folders) do
    begin
      _Folders[i].Name := dm.ReadStringANT;
      dm.Skip(1);
      SetLength(_Folders[i].Files, dm.ReadIntU32);
      for j := 0 to High(_Folders[i].Files) do
      begin
        _Folders[i].Files[j].Name := dm.ReadStringANT;
        dm.ReadStringANT;
        _Folders[i].Files[j].Encrypted := dm.ReadBool;
        _Folders[i].Files[j].Compressed := dm.ReadBool;
        dm.Skip(4);
        _Folders[i].Files[j].DataPos := dm.ReadIntU32;
        _Folders[i].Files[j].DataLength := dm.ReadIntU32;
        _Folders[i].Files[j].OriginalSize := dm.ReadIntU32;
        dm.ReadBuffer(@_Folders[i].Files[j].CRC, SizeOf(_Folders[i].Files[j].CRC));
      end;
    end;
  finally
    dm.Free;
  end;
end;

procedure TG2Pack.Disconnect;
begin
  _FName := '';
  _PackAlias := '';
  _DataPos := 0;
  _Folders := nil;
end;

procedure TG2Pack.GetFileData(const FolderName, FileName: AnsiString; var Data: Pointer; var DataSize: TG2IntU32);
  var i, j: TG2IntS32;
  var dm: TG2DataManager;
  var Buffer: Pointer;
  var TmpBuffer: Pointer;
begin
  Data := nil;
  DataSize := 0;
  for i := 0 to High(_Folders) do
  if _Folders[i].Name = FolderName then
  begin
    for j := 0 to High(_Folders[i].Files) do
    if _Folders[i].Files[j].Name = FileName then
    begin
      dm := TG2DataManager.Create(_FName, dmAssetNoPacks);
      try
        dm.Position := TG2IntS64(_DataPos) + TG2IntS64(_Folders[i].Files[j].DataPos);
        GetMem(TmpBuffer, _Folders[i].Files[j].DataLength);
        dm.ReadBuffer(TmpBuffer, _Folders[i].Files[j].DataLength);
        if _Folders[i].Files[j].Encrypted then
        G2EncDec(PG2IntU8Arr(TmpBuffer), _Folders[i].Files[j].DataLength, _Key);
        if _Folders[i].Files[j].Compressed then
        begin
          GetMem(Buffer, _Folders[i].Files[j].OriginalSize);
          G2ZLibDecompress(TmpBuffer, _Folders[i].Files[j].DataLength, Buffer);
          Data := Buffer;
          FreeMem(TmpBuffer, _Folders[i].Files[j].DataLength);
        end
        else
        begin
          Data := TmpBuffer;
        end;
        DataSize := _Folders[i].Files[j].OriginalSize;
      finally
        dm.Free;
      end;
      Exit;
    end;
    Exit;
  end;
end;

function TG2Pack.FileExists(const FolderName, FileName: AnsiString): Boolean;
  var i, j: TG2IntS32;
begin
  for i := 0 to High(_Folders) do
  if _Folders[i].Name = FolderName then
  begin
    for j := 0 to High(_Folders[i].Files) do
    if _Folders[i].Files[j].Name = FileName then
    begin
      Result := True;
      Exit;
    end;
    Break;
  end;
  Result := False;
end;
//TG2Pack END

//TG2PackLinker BEGIN
constructor TG2PackLinker.Create;
begin
  inherited Create;
  _Packs.Clear;
end;

destructor TG2PackLinker.Destroy;
  var i: TG2IntS32;
begin
  for i := 0 to _Packs.Count - 1 do
  begin
    PG2Pack(_Packs[i])^.Disconnect;
    Dispose(PG2Pack(_Packs[i]));
  end;
  _Packs.Clear;
  inherited Destroy;
end;

procedure TG2PackLinker.LinkPack(const FileName: FileString; const Key: AnsiString = '');
  var Pack: PG2Pack;
begin
  New(Pack);
  Pack^.Connect(FileName);
  Pack^.Key := Key;
  _Packs.Add(Pack);
end;

procedure TG2PackLinker.UnLinkPack(const PackAlias: AnsiString);
  var i: TG2IntS32;
begin
  for i := 0 to _Packs.Count - 1 do
  if PG2Pack(_Packs[i])^.PackAlias = PackAlias then
  begin
    PG2Pack(_Packs[i])^.Disconnect;
    Dispose(PG2Pack(_Packs[i]));
    _Packs.Delete(i);
    Exit;
  end;
end;

procedure TG2PackLinker.GetFileData(const Path: AnsiString; var Data: Pointer; var DataSize: TG2IntU32);
  var Str: AnsiString;
  var PathArr: TG2StrArrA;
  var i: TG2IntS32;
begin
  Data := nil;
  DataSize := 0;
  Str := Path;
  for i := 1 to Length(Str) do
  if Str[i] = '/' then Str[i] := '\';
  PathArr := G2StrExplode(Str, '\');
  if Length(PathArr) <> 3 then Exit;
  for i := 0 to _Packs.Count - 1 do
  if PG2Pack(_Packs[i])^.PackAlias = PathArr[0] then
  begin
    PG2Pack(_Packs[i])^.GetFileData(PathArr[1], PathArr[2], Data, DataSize);
    Exit;
  end;
end;

function TG2PackLinker.FileExists(const Path: AnsiString): Boolean;
  var Str: AnsiString;
  var PathArr: TG2StrArrA;
  var i: TG2IntS32;
begin
  Result := False;
  Str := Path;
  for i := 1 to Length(Str) do
  if Str[i] = '/' then Str[i] := '\';
  PathArr := G2StrExplode(Str, '\');
  if Length(PathArr) <> 3 then Exit;
  for i := 0 to _Packs.Count - 1 do
  if PG2Pack(_Packs[i])^.PackAlias = PathArr[0] then
  begin
    Result := PG2Pack(_Packs[i])^.FileExists(PathArr[1], PathArr[2]);
    Exit;
  end;
end;
//TG2PackLinker END

function G2FileExists(const FileName: FileString): Boolean;
  var fs: FileString;
  var i: TG2IntS32;
  {$if defined(G2Target_iOS)}
  var fh: NSFileHandle;
  {$endif}
begin
  fs := FileName;
  for i := 1 to Length(fs) do
  if fs[i] = G2PathSepRev then
  fs[i] := G2PathSep;
  {$if defined(G2Target_Android)}
  Result := AndroidBinding.FExists(fs, Length(fs));
  {$elseif defined(G2Target_iOS)}
  Result := NSFileManager.defaultManager.fileExistsAtPath(G2NSStr(fs));
  {$else}
  Result := FileExists(AnsiString(fs));
  {$endif}
end;

function G2GetAppPath: FileString;
{$if defined(G2Target_Windows)}
begin
  Result := ExtractFilePath(ParamStr(0));
end;
{$elseif defined(G2Target_Linux)}
begin
  Result := ExtractFilePath(ParamStr(0));
end;
{$elseif defined(G2Target_OSX)}
  var MainBundle: CFBundleRef;
  var EXEUrl: CFURLRef;
  var EXEFSPath: CFStringRef;
  var utf16len: ptrint;
  var error: boolean;
  var PathStr: AnsiString;
  var i: TG2IntS32;
begin
  error := false;
  MainBundle := CFBundleGetMainBundle;
  if Assigned(MainBundle) then
  begin
    EXEUrl := CFBundleCopyExecutableURL(MainBundle);
    if Assigned(EXEUrl) then
    begin
      EXEFSPath := CFURLCopyFileSystemPath(EXEUrl, kCFURLPOSIXPathStyle);
      CFRelease(EXEUrl);
      utf16len := CFStringGetLength(EXEFSPath);
      SetLength(PathStr, utf16len * 3 + 1);
      if CFStringGetCString(EXEFSPath, @PathStr[1], Length(PathStr), kCFStringEncodingUTF8) then
      begin
        SetLength(PathStr, pos('.app/Contents/', PathStr) - 1);
        i := Length(PathStr);
        while (i > 0) and (PathStr[i] <> '/') do Dec(i);
        if i > 0 then Delete(PathStr, i + 1, Length(PathStr) - i);
        Result := PathStr;
      end
      else
      error := True;
      CFRelease(EXEFSPath);
    end
    else
    error := True;
  end
  else
  error := True;
  if error then
  Result := ParamStr(0);
end;
{$elseif defined(G2Target_Android)}
begin
  Result := '';
end;
{$elseif defined(G2Target_iOS)}
  var FullPath: FileString;
  var i: TG2IntS32;
begin
  FullPath := ParamStr(0);
  for i := Length(FullPath) downto 1 do
  if FullPath[i] = '/' then
  begin
    SetLength(Result, (i - 1) * SizeOf(FileChar));
    Move(FullPath[1], Result[1], (i - 1) * SizeOf(FileChar));
    Exit;
  end;
  Result := '';
end;
{$else}
begin
  Result := ParamStr(0);
end;
{$endif}

{$Hints off}
procedure G2ZLibDecompress(const Data: Pointer; const Size: TG2IntS64; const Output: TStream);
  var ZStreamRec: z_stream;
  var ZResult: TG2IntS32;
  var TempBuffer: Pointer;
  const BufferSize = $8000;
begin
  FillChar(ZStreamRec, SizeOf(z_stream), 0);
  ZStreamRec.next_in := Data;
  ZStreamRec.avail_in := Size;
  if inflateInit(ZStreamRec) < 0 then Exit;
  GetMem(TempBuffer, BufferSize);
  try
    while ZStreamRec.avail_in > 0 do
    begin
      ZStreamRec.next_out := TempBuffer;
      ZStreamRec.avail_out := BufferSize;
      inflate(ZStreamRec, Z_NO_FLUSH);
      Output.Write(TempBuffer^, BufferSize - ZStreamRec.avail_out);
    end;
    repeat
      ZStreamRec.next_out := TempBuffer;
      ZStreamRec.avail_out := BufferSize;
      ZResult := inflate(ZStreamRec, Z_FINISH);
      Output.Write(TempBuffer^, BufferSize - ZStreamRec.avail_out);
    until (ZResult = Z_STREAM_END) and (ZStreamRec.avail_out > 0);
  finally
    FreeMem(TempBuffer, BufferSize);
    inflateEnd(ZStreamRec);
  end;
end;
{$Hints on}

{$Hints off}
procedure G2ZLibDecompress(const Data: Pointer; const Size: TG2IntS64; const Output: Pointer);
  var ZStreamRec: z_stream;
  var ZResult: TG2IntS32;
  var TempBuffer: Pointer;
  var OutData: PByte;
  var n: TG2IntU32;
  const BufferSize = $8000;
begin
  OutData := Output;
  FillChar(ZStreamRec, SizeOf(z_stream), 0);
  ZStreamRec.next_in := Data;
  ZStreamRec.avail_in := Size;
  if inflateInit(ZStreamRec) < 0 then Exit;
  GetMem(TempBuffer, BufferSize);
  try
    while ZStreamRec.avail_in > 0 do
    begin
      ZStreamRec.next_out := TempBuffer;
      ZStreamRec.avail_out := BufferSize;
      inflate(ZStreamRec, Z_NO_FLUSH);
      n := BufferSize - ZStreamRec.avail_out;
      System.Move(TempBuffer^, OutData^, n);
      Inc(OutData, n);
    end;
    repeat
      ZStreamRec.next_out := TempBuffer;
      ZStreamRec.avail_out := BufferSize;
      ZResult := inflate(ZStreamRec, Z_FINISH);
      n := BufferSize - ZStreamRec.avail_out;
      System.Move(TempBuffer^, OutData^, n);
      Inc(OutData, n);
    until (ZResult = Z_STREAM_END) and (ZStreamRec.avail_out > 0);
  finally
    FreeMem(TempBuffer, BufferSize);
    inflateEnd(ZStreamRec);
  end;
end;
{$Hints on}

{$Hints off}
procedure G2ZLibDecompress(const Data: Pointer; const Size: TG2IntS64; const Output: TG2DataManager);
  var ZStreamRec: z_stream;
  var ZResult: TG2IntS32;
  var TempBuffer: Pointer;
  const BufferSize = $8000;
begin
  FillChar(ZStreamRec, SizeOf(z_stream), 0);
  ZStreamRec.next_in := Data;
  ZStreamRec.avail_in := Size;
  if inflateInit(ZStreamRec) < 0 then Exit;
  GetMem(TempBuffer, BufferSize);
  try
    while ZStreamRec.avail_in > 0 do
    begin
      ZStreamRec.next_out := TempBuffer;
      ZStreamRec.avail_out := BufferSize;
      inflate(ZStreamRec, Z_NO_FLUSH);
      Output.WriteBuffer(TempBuffer, BufferSize - ZStreamRec.avail_out);
    end;
    repeat
      ZStreamRec.next_out := TempBuffer;
      ZStreamRec.avail_out := BufferSize;
      ZResult := inflate(ZStreamRec, Z_FINISH);
      Output.WriteBuffer(TempBuffer, BufferSize - ZStreamRec.avail_out);
    until (ZResult = Z_STREAM_END) and (ZStreamRec.avail_out > 0);
  finally
    FreeMem(TempBuffer, BufferSize);
    inflateEnd(ZStreamRec);
  end;
end;
{$Hints on}

procedure G2ZLibCompress(const Data: Pointer; const Size: TG2IntS64; const Output: TStream);
  var ZStreamRec: z_stream;
  var ZResult: TG2IntS32;
  var TempBuffer: Pointer;
  const BufferSize = $8000;
begin
  GetMem(TempBuffer, BufferSize);
  {$Hints off}FillChar(ZStreamRec, SizeOf(z_stream), 0);{$Hints on}
  ZStreamRec.next_in := Data;
  ZStreamRec.avail_in := Size;
  if DeflateInit(ZStreamRec, Z_BEST_COMPRESSION) < 0 then
  begin
    FreeMem(TempBuffer, BufferSize);
    Exit;
  end;
  try
    while ZStreamRec.avail_in > 0 do
    begin
      ZStreamRec.next_out := TempBuffer;
      ZStreamRec.avail_out := BufferSize;
      Deflate(ZStreamRec, Z_NO_FLUSH);
      Output.WriteBuffer(TempBuffer^, BufferSize - ZStreamRec.avail_out);
    end;
    repeat
      ZStreamRec.next_out := TempBuffer;
      ZStreamRec.avail_out := BufferSize;
      ZResult := Deflate(ZStreamRec, Z_FINISH);
      Output.WriteBuffer(TempBuffer^, BufferSize - ZStreamRec.avail_out);
    until (ZResult = Z_STREAM_END) and (ZStreamRec.avail_out > 0);
  finally
    FreeMem(TempBuffer, BufferSize);
    DeflateEnd(ZStreamRec);
  end;
end;

procedure G2ZLibCompress(const Data: Pointer; const Size: TG2IntS64; const Output: Pointer);
  var ZStreamRec: z_stream;
  var ZResult: TG2IntS32;
  var n: TG2IntU32;
  var TempBuffer: Pointer;
  var OutData: PByte;
  const BufferSize = $8000;
begin
  OutData := Output;
  GetMem(TempBuffer, BufferSize);
  {$Hints off}FillChar(ZStreamRec, SizeOf(z_stream), 0);{$Hints on}
  ZStreamRec.next_in := Data;
  ZStreamRec.avail_in := Size;
  if DeflateInit(ZStreamRec, Z_BEST_COMPRESSION) < 0 then
  begin
    FreeMem(TempBuffer, BufferSize);
    Exit;
  end;
  try
    while ZStreamRec.avail_in > 0 do
    begin
      ZStreamRec.next_out := TempBuffer;
      ZStreamRec.avail_out := BufferSize;
      Deflate(ZStreamRec, Z_NO_FLUSH);
      n := BufferSize - ZStreamRec.avail_out;
      System.Move(TempBuffer^, OutData^, n);
      Inc(OutData, n);
    end;
    repeat
      ZStreamRec.next_out := TempBuffer;
      ZStreamRec.avail_out := BufferSize;
      ZResult := Deflate(ZStreamRec, Z_FINISH);
      n := BufferSize - ZStreamRec.avail_out;
      System.Move(TempBuffer^, OutData^, n);
      Inc(OutData, n);
    until (ZResult = Z_STREAM_END) and (ZStreamRec.avail_out > 0);
  finally
    FreeMem(TempBuffer, BufferSize);
    DeflateEnd(ZStreamRec);
  end;
end;

procedure G2ZLibCompress(const Data: Pointer; const Size: TG2IntS64; const Output: TG2DataManager);
  var ZStreamRec: z_stream;
  var ZResult: TG2IntS32;
  var TempBuffer: Pointer;
  const BufferSize = $8000;
begin
  GetMem(TempBuffer, BufferSize);
  {$Hints off}FillChar(ZStreamRec, SizeOf(z_stream), 0);{$Hints on}
  ZStreamRec.next_in := Data;
  ZStreamRec.avail_in := Size;
  if DeflateInit(ZStreamRec, Z_BEST_COMPRESSION) < 0 then
  begin
    FreeMem(TempBuffer, BufferSize);
    Exit;
  end;
  try
    while ZStreamRec.avail_in > 0 do
    begin
      ZStreamRec.next_out := TempBuffer;
      ZStreamRec.avail_out := BufferSize;
      Deflate(ZStreamRec, Z_NO_FLUSH);
      Output.WriteBuffer(TempBuffer, BufferSize - ZStreamRec.avail_out);
    end;
    repeat
      ZStreamRec.next_out := TempBuffer;
      ZStreamRec.avail_out := BufferSize;
      ZResult := Deflate(ZStreamRec, Z_FINISH);
      Output.WriteBuffer(TempBuffer, BufferSize - ZStreamRec.avail_out);
    until (ZResult = Z_STREAM_END) and (ZStreamRec.avail_out > 0);
  finally
    FreeMem(TempBuffer, BufferSize);
    DeflateEnd(ZStreamRec);
  end;
end;

end.
