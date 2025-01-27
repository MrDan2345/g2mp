unit G2Audio;
{$include Gen2MP.inc}
interface

uses
  Classes,
  G2DataManager;

type
  TG2Audio = class;

  CG2AudioFormat = class of TG2Audio;

  TG2AudioFormat = (
    afMono8,
    afMono16,
    afMono24,
    afMono32,
    afStereo8,
    afStereo16,
    afStereo24,
    afStereo32
  );

  TG2Audio = class
  protected
    _Data: Pointer;
    _DataSize: Integer;
    _Format: TG2AudioFormat;
    _ChannelCount: Integer;
    _SampleRate: Integer;
    _SampleSize: Integer;
    procedure DataAlloc(const Size: Integer);
    procedure DataFree;
  public
    property Data: Pointer read _Data;
    property DataSize: Integer read _DataSize;
    property Format: TG2AudioFormat read _Format;
    property ChannelCount: Integer read _ChannelCount;
    property SampleRate: Integer read _SampleRate;
    property SampleSize: Integer read _SampleSize;
    class function CanRead(const Stream: TStream): Boolean; virtual; overload;
    class function CanRead(const FileName: String): Boolean; virtual; overload;
    class function CanRead(const Buffer: Pointer; const Size: Integer): Boolean; virtual; overload;
    class function CanRead(const DataManager: TG2DataManager): Boolean; virtual; abstract overload;
    procedure Load(const Stream: TStream); virtual; overload;
    procedure Load(const FileName: String); virtual; overload;
    procedure Load(const Buffer: Pointer; const Size: Integer); virtual; overload;
    procedure Load(const DataManager: TG2DataManager); virtual; abstract; overload;
    constructor Create;
    destructor Destroy; override;
  end;

procedure G2AddAudioFormat(const Format: CG2AudioFormat);

var G2AudioFormats: array of CG2AudioFormat;

implementation

//TG2Audio BEGIN
procedure TG2Audio.DataAlloc(const Size: Integer);
begin
  DataFree;
  _DataSize := Size;
  _Data := GetMem(_DataSize);
end;

procedure TG2Audio.DataFree;
begin
  if _DataSize > 0 then
  begin
    FreeMem(_Data, _DataSize);
    _DataSize := 0;
    _Data := nil;
  end;
end;

class function TG2Audio.CanRead(const Stream: TStream): Boolean;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Stream);
  try
    Result := CanRead(dm);
  finally
    dm.Free;
  end;
end;

class function TG2Audio.CanRead(const FileName: String): Boolean;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName, dmAsset);
  try
    Result := CanRead(dm);
  finally
    dm.Free;
  end;
end;

class function TG2Audio.CanRead(const Buffer: Pointer; const Size: Integer): Boolean;
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Buffer, Size);
  try
    Result := CanRead(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Audio.Load(const Stream: TStream);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Stream);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Audio.Load(const FileName: String);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(FileName, dmAsset);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

procedure TG2Audio.Load(const Buffer: Pointer; const Size: Integer);
  var dm: TG2DataManager;
begin
  dm := TG2DataManager.Create(Buffer, Size);
  try
    Load(dm);
  finally
    dm.Free;
  end;
end;

constructor TG2Audio.Create;
begin
  inherited Create;
  _DataSize := 0;
  _Data := nil;
end;

destructor TG2Audio.Destroy;
begin
  DataFree;
  inherited Destroy;
end;
//TG2Audio END

procedure G2AddAudioFormat(const Format: CG2AudioFormat);
begin
  SetLength(G2AudioFormats, Length(G2AudioFormats) + 1);
  G2AudioFormats[High(G2AudioFormats)] := Format;
end;

end.
