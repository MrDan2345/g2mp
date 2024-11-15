unit G2Image;
{$include Gen2MP.inc}
interface

uses
  Types,
  SysUtils,
  Classes,
  G2Types,
  G2DataManager;

type
  TG2Image = class;

  TG2ImageFormat = (
    G2IF_NONE,
    G2IF_G8,
    G2IF_G16,
    G2IF_G8A8,
    G2IF_G16A16,
    G2IF_R8G8B8,
    G2IF_R16G16B16,
    G2IF_R8G8B8A8,
    G2IF_R16G16B16A16
  );

  TG2ColorR8G8B8A8 = record
    r, g, b, a: Byte;
  end;
  PG2ColorR8G8B8A8 = ^TG2ColorR8G8B8A8;

  CG2ImageFormat = class of TG2Image;

  TG2ImagePixelReadProc = function (const x, y: Integer): TG2ColorR8G8B8A8 of Object;
  TG2ImagePixelWriteProc = procedure (const x, y: Integer; const Value: TG2ColorR8G8B8A8) of Object;

  TG2Image = class
  protected
    _Width: Integer;
    _Height: Integer;
    _BPP: Integer;
    _Data: Pointer;
    _DataSize: LongWord;
    _Format: TG2ImageFormat;
    _ReadProc: TG2ImagePixelReadProc;
    _WriteProc: TG2ImagePixelWriteProc;
    procedure SetFormat(const f: TG2ImageFormat);
    function GetPixel(const x, y: Integer): TG2ColorR8G8B8A8;
    function ReadNone(const x, y: Integer): TG2ColorR8G8B8A8;
    function ReadG8(const x, y: Integer): TG2ColorR8G8B8A8;
    function ReadG16(const x, y: Integer): TG2ColorR8G8B8A8;
    function ReadG8A8(const x, y: Integer): TG2ColorR8G8B8A8;
    function ReadG16A16(const x, y: Integer): TG2ColorR8G8B8A8;
    function ReadR8G8B8(const x, y: Integer): TG2ColorR8G8B8A8;
    function ReadR16G16B16(const x, y: Integer): TG2ColorR8G8B8A8;
    function ReadR8G8B8A8(const x, y: Integer): TG2ColorR8G8B8A8;
    function ReadR16G16B16A16(const x, y: Integer): TG2ColorR8G8B8A8;
    procedure SetPixel(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
    procedure WriteNone(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
    procedure WriteG8(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
    procedure WriteG16(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
    procedure WriteG8A8(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
    procedure WriteG16A16(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
    procedure WriteR8G8B8(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
    procedure WriteR16G16B16(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
    procedure WriteR8G8B8A8(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
    procedure WriteR16G16B16A16(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
    procedure DataAlloc; overload;
    procedure DataAlloc(const Size: LongWord); overload;
    procedure DataFree;
  public
    property Width: Integer read _Width;
    property Height: Integer read _Height;
    property Data: Pointer read _Data;
    property BPP: Integer read _BPP;
    property Format: TG2ImageFormat read _Format;
    property Pixels[const x, y: Integer]: TG2ColorR8G8B8A8 read GetPixel write SetPixel; default;
    class function CanLoad(const Stream: TStream): Boolean; virtual; overload;
    class function CanLoad(const FileName: String): Boolean; virtual; overload;
    class function CanLoad(const Buffer: Pointer; const Size: Integer): Boolean; virtual; overload;
    class function CanLoad(const DataManager: TG2DataManager): Boolean; virtual; abstract; overload;
    procedure Load(const Stream: TStream); virtual; overload;
    procedure Load(const FileName: String); virtual; overload;
    procedure Load(const Buffer: Pointer; const Size: Integer); virtual; overload;
    procedure Load(const DataManager: TG2DataManager); virtual; abstract; overload;
    procedure Save(const Stream: TStream); virtual; overload;
    procedure Save(const FileName: String); virtual; overload;
    procedure Save(const Buffer: Pointer; const Size: Integer); virtual; overload;
    procedure Save(const DataManager: TG2DataManager); virtual; abstract; overload;
    procedure Allocate(const NewFormat: TG2ImageFormat; const NewWidth, NewHeight: Integer);
    constructor Create; virtual;
    destructor Destroy; override;
  end;

operator := (c0: TG2Color) cr: TG2ColorR8G8B8A8;
operator := (c0: TG2ColorR8G8B8A8) cr: TG2Color;
operator := (c0: TG2IntU32) cr: TG2ColorR8G8B8A8;
operator := (c0: TG2ColorR8G8B8A8) cr: TG2IntU32;

procedure G2AddImageFormat(const Format: CG2ImageFormat);

var G2ImageFormats: array of CG2ImageFormat;

implementation

//TG2Image BEIGN
procedure TG2Image.SetFormat(const f: TG2ImageFormat);
begin
  _Format := f;
  case _Format of
    G2IF_NONE:
    begin
      _BPP := 0;
      _ReadProc := @ReadNone;
      _WriteProc := @WriteNone;
    end;
    G2IF_G8:
    begin
      _BPP := 1;
      _ReadProc := @ReadG8;
      _WriteProc := @WriteG8;
    end;
    G2IF_G16:
    begin
      _BPP := 2;
      _ReadProc := @ReadG16;
      _WriteProc := @WriteG16;
    end;
    G2IF_G8A8:
    begin
      _BPP := 2;
      _ReadProc := @ReadG8A8;
      _WriteProc := @WriteG8A8;
    end;
    G2IF_G16A16:
    begin
      _BPP := 4;
      _ReadProc := @ReadG16A16;
      _WriteProc := @WriteG16A16;
    end;
    G2IF_R8G8B8:
    begin
      _BPP := 3;
      _ReadProc := @ReadR8G8B8;
      _WriteProc := @WriteR8G8B8;
    end;
    G2IF_R16G16B16:
    begin
      _BPP := 6;
      _ReadProc := @ReadR16G16B16;
      _WriteProc := @WriteR16G16B16;
    end;
    G2IF_R8G8B8A8:
    begin
      _BPP := 4;
      _ReadProc := @ReadR8G8B8A8;
      _WriteProc := @WriteR8G8B8A8;
    end;
    G2IF_R16G16B16A16:
    begin
      _BPP := 8;
      _ReadProc := @ReadR16G16B16A16;
      _WriteProc := @WriteR16G16B16A16;
    end;
  end;
end;

function TG2Image.GetPixel(const x, y: Integer): TG2ColorR8G8B8A8;
begin
  Result := _ReadProc(x, y);
end;

{$Hints off}
function TG2Image.ReadNone(const x, y: Integer): TG2ColorR8G8B8A8;
begin
  PLongWord(@Result)^ := 0;
end;
{$Hints on}

function TG2Image.ReadG8(const x, y: Integer): TG2ColorR8G8B8A8;
  var c: Byte;
begin
  c := PByte(_Data + y * _Width + x)^;
  Result.r := c;
  Result.g := c;
  Result.b := c;
  Result.a := $ff;
end;

function TG2Image.ReadG16(const x, y: Integer): TG2ColorR8G8B8A8;
  var c: Byte;
begin
  c := PByte(_Data + (y * _Width + x) * _BPP + 1)^;
  Result.r := c;
  Result.g := c;
  Result.b := c;
  Result.a := $ff;
end;

function TG2Image.ReadG8A8(const x, y: Integer): TG2ColorR8G8B8A8;
  var d: Word;
  var c: Byte;
begin
  d := PWord(_Data + (y * _Width + x) * _BPP)^;
  c := d and $ff;
  Result.r := c;
  Result.g := c;
  Result.b := c;
  Result.a := (d shr 8) and $ff;
end;

function TG2Image.ReadG16A16(const x, y: Integer): TG2ColorR8G8B8A8;
  var d: LongWord;
  var c: Byte;
begin
  d := PLongWord(_Data + (y * _Width + x) * _BPP)^;
  c := (d shr 8) and $ff;
  Result.r := c;
  Result.g := c;
  Result.b := c;
  Result.a := (d shr 24) and $ff;
end;

function TG2Image.ReadR8G8B8(const x, y: Integer): TG2ColorR8G8B8A8;
  var d: LongWord;
begin
  d := PLongWord(_Data + (y * _Width + x) * _BPP)^ and $ffffff;
  Result.r := d and $ff;
  Result.g := (d shr 8) and $ff;
  Result.b := (d shr 16) and $ff;
  Result.a := $ff;
end;

function TG2Image.ReadR16G16B16(const x, y: Integer): TG2ColorR8G8B8A8;
  var b: PByte;
begin
  b := PByte(_Data + (y * _Width + x) * _BPP + 1);
  Result.r := b^; Inc(b, 2);
  Result.g := b^; Inc(b, 2);
  Result.b := b^;
  Result.a := $ff;
end;

function TG2Image.ReadR8G8B8A8(const x, y: Integer): TG2ColorR8G8B8A8;
begin
  PLongWord(@Result)^ := PLongWord(_Data + (y * _Width + x) * _BPP)^;
end;

function TG2Image.ReadR16G16B16A16(const x, y: Integer): TG2ColorR8G8B8A8;
  var d: PByte;
begin
  d := PByte(_Data + (y * _Width + x) * _BPP + 1);
  Result.r := d^; Inc(d, 2);
  Result.g := d^; Inc(d, 2);
  Result.b := d^; Inc(d, 2);
  Result.a := d^;
end;

procedure TG2Image.SetPixel(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
begin
  _WriteProc(x, y, Value);
end;

{$Hints off}
procedure TG2Image.WriteNone(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
begin

end;
{$Hints on}

procedure TG2Image.WriteG8(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
  var d: PByte;
begin
  d := PByte(_Data + (y * _Width + x) * _BPP);
  d^ := Value.r;
end;

procedure TG2Image.WriteG16(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
  var d: PByte;
begin
  d := PByte(_Data + (y * _Width + x) * _BPP);
  d^ := 0; Inc(d);
  d^ := Value.r;
end;

procedure TG2Image.WriteG8A8(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
  var d: PByte;
begin
  d := PByte(_Data + (y * _Width + x) * _BPP);
  d^ := Value.r; Inc(d);
  d^ := Value.a;
end;

procedure TG2Image.WriteG16A16(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
  var d: PByte;
begin
  d := PByte(_Data + (y * _Width + x) * _BPP);
  d^ := 0; Inc(d); d^ := Value.r; Inc(d);
  d^ := 0; Inc(d); d^ := Value.a;
end;

procedure TG2Image.WriteR8G8B8(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
  var d: PByte;
begin
  d := PByte(_Data + (y * _Width + x) * _BPP);
  d^ := Value.r; Inc(d);
  d^ := Value.g; Inc(d);
  d^ := Value.b;
end;

procedure TG2Image.WriteR16G16B16(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
  var d: PByte;
begin
  d := PByte(_Data + (y * _Width + x) * _BPP);
  d^ := 0; Inc(d); d^ := Value.r; Inc(d);
  d^ := 0; Inc(d); d^ := Value.g; Inc(d);
  d^ := 0; Inc(d); d^ := Value.b;
end;

procedure TG2Image.WriteR8G8B8A8(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
begin
  PLongWord(_Data + (y * _Width + x) * _BPP)^ := PLongWord(@Value)^;
end;

procedure TG2Image.WriteR16G16B16A16(const x, y: Integer; const Value: TG2ColorR8G8B8A8);
  var d: PByte;
begin
  d := PByte(_Data + (y * _Width + x) * _BPP);
  d^ := 0; Inc(d); d^ := Value.r; Inc(d);
  d^ := 0; Inc(d); d^ := Value.g; Inc(d);
  d^ := 0; Inc(d); d^ := Value.b; Inc(d);
  d^ := 0; Inc(d); d^ := Value.a;
end;

procedure TG2Image.DataAlloc;
begin
  if _BPP > 0 then
  DataAlloc(_Width * _Height * _BPP);
end;

procedure TG2Image.DataAlloc(const Size: LongWord);
begin
  if _DataSize > 0 then DataFree;
  _DataSize := Size;
  GetMem(_Data, _DataSize);
end;

procedure TG2Image.DataFree;
begin
  if _DataSize > 0 then
  begin
    Freemem(_Data, _DataSize);
    _DataSize := 0;
  end;
end;

class function TG2Image.CanLoad(const Stream: TStream): Boolean;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Stream, dmRead);
  try
    Result := CanLoad(dm);
  finally
    dm.Free;
  end;
end;

class function TG2Image.CanLoad(const FileName: String): Boolean;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName, dmAsset);
  try
    Result := CanLoad(dm);
  finally
    dm.Free;
  end;
end;

class function TG2Image.CanLoad(const Buffer: Pointer; const Size: Integer): Boolean;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Buffer, Size, dmRead);
  try
    Result := CanLoad(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Image.Load(const Stream: TStream);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Stream, dmRead);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Image.Load(const FileName: String);
  var dm: TG2DataManager;
  {$if defined(G2Target_Android)}
  var Buffer: Pointer;
  var Size: TG2IntS64;
  {$endif}
begin
  dm := TG2DataManager.Create(FileName, dmAsset);
  {$if defined(G2Target_Android)}
  Size := dm.Size;
  GetMem(Buffer, Size);
  dm.ReadBuffer(Buffer, Size);
  dm.Free;
  dm := TG2DataManager.Create(Buffer, Size);
  {$endif}
  try
    Load(dm);
  finally
    dm.Free;
    {$if defined(G2Target_Android)}
    FreeMem(Buffer, Size);
    {$endif}
  end;
end;

procedure TG2Image.Load(const Buffer: Pointer; const Size: Integer);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Buffer, Size, dmRead);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Image.Save(const Stream: TStream);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Stream, dmWrite);
  try
    Save(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Image.Save(const FileName: String);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName, dmWrite);
  try
    Save(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Image.Save(const Buffer: Pointer; const Size: Integer);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Buffer, Size, dmWrite);
  try
    Save(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Image.Allocate(const NewFormat: TG2ImageFormat; const NewWidth, NewHeight: Integer);
begin
  SetFormat(NewFormat);
  _Width := NewWidth;
  _Height := NewHeight;
  DataAlloc;
end;

constructor TG2Image.Create;
begin
  inherited Create;
  _Width := 0;
  _Height := 0;
  _BPP := 0;
  _Data := nil;
  _DataSize := 0;
  _Format := G2IF_NONE;
end;

destructor TG2Image.Destroy;
begin
  DataFree;
  inherited Destroy;
end;
//TG2Image END

operator := (c0: TG2Color) cr: TG2ColorR8G8B8A8;
begin
  cr.r := c0.r;
  cr.g := c0.g;
  cr.b := c0.b;
  cr.a := c0.a;
end;

operator := (c0: TG2ColorR8G8B8A8) cr: TG2Color;
begin
  cr.r := c0.r;
  cr.g := c0.g;
  cr.b := c0.b;
  cr.a := c0.a;
end;

operator := (c0: TG2IntU32) cr: TG2ColorR8G8B8A8;
begin
  cr := TG2ColorR8G8B8A8(c0);
end;

operator := (c0: TG2ColorR8G8B8A8) cr: TG2IntU32;
begin
  cr := TG2IntU32(c0);
end;

procedure G2AddImageFormat(const Format: CG2ImageFormat);
begin
  SetLength(G2ImageFormats, Length(G2ImageFormats) + 1);
  G2ImageFormats[High(G2ImageFormats)] := Format;
end;

end.
