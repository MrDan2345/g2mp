unit G2AudioWAV;
{$include Gen2MP.inc}

interface

uses
  G2Types,
  G2Audio,
  G2DataManager,
  Classes;

type
  TG2AudioWAV = class(TG2Audio)
  public
    class function CanRead(const DataManager: TG2DataManager): Boolean; override;
    procedure Load(const DataManager: TG2DataManager); override;
  end;

implementation

type
  TRIFFHeader = packed record
    FileID: array[0..3] of AnsiChar;
    FileSize: LongWord;
    FileType: array[0..3] of AnsiChar;
  end;

  TRIFFChunkHeader = packed record
    ChunkID: array[0..3] of AnsiChar;
    ChunkSize: LongWord;
  end;

  TWAVFormat = packed record
    AudioFormat: Word;
    ChannelCount: Word;
    SampleRate: LongWord;
    ByteRate: LongWord;
    BlockAlign: Word;
    BitsPerSample: Word;
  end;

//TG2AudioWAV BEGIN
class function TG2AudioWAV.CanRead(const DataManager: TG2DataManager): Boolean;
  var Header: TRIFFHeader;
begin
  Result := False;
  if DataManager.Size - DataManager.Position < 12 then Exit;
  {$Hints off}
  DataManager.ReadBuffer(@Header, 12);
  {$Hints on}
  Result := (Header.FileID = 'RIFF') and (Header.FileType = 'WAVE');
  DataManager.Position := DataManager.Position - 12;
end;

procedure TG2AudioWAV.Load(const DataManager: TG2DataManager);
  type TChunkID = array[0..3] of AnsiChar;
  var Header: TRIFFHeader;
  var DataPos: TG2IntS64;
  var TotalSize: Integer;
  var ChunkSize: LongWord;
  function FindChunk(const ChunkID: TChunkID): Boolean;
    var ChunkHeader: TRIFFChunkHeader;
  begin
    Result := False;
    DataManager.Position := DataPos;
    while not Result and (TG2IntS64(DataManager.Position - DataPos) <= TG2IntS64(TotalSize) - TG2IntS64(SizeOf(TRIFFChunkHeader))) do
    begin
      DataManager.ReadBuffer(@ChunkHeader, SizeOf(ChunkHeader));
      if ChunkHeader.ChunkID = ChunkID then
      begin
        Result := True;
        ChunkSize := ChunkHeader.ChunkSize;
      end
      else
      DataManager.Position := DataManager.Position + ChunkHeader.ChunkSize;
    end;
  end;
  var WAVFormat: TWAVFormat;
begin
  if DataManager.Size - DataManager.Position < SizeOf(Header) then Exit;
  {$Hints off}
  DataManager.ReadBuffer(@Header, SizeOf(Header));
  {$Hints on}
  if not (Header.FileID = 'RIFF') and (Header.FileType = 'WAVE') then Exit;
  DataPos := DataManager.Position; TotalSize := Header.FileSize - 4;
  if not FindChunk('fmt ') then Exit;
  DataManager.ReadBuffer(@WAVFormat, SizeOf(WAVFormat));
  if WAVFormat.AudioFormat <> 1 then Exit;
  _ChannelCount := WAVFormat.ChannelCount;
  _SampleRate := WAVFormat.SampleRate;
  _SampleSize := WAVFormat.BitsPerSample div 8;
  case _ChannelCount of
    1:
    begin
      case _SampleSize of
        1: _Format := afMono8;
        2: _Format := afMono16;
        3: _Format := afMono24;
        else Exit;
      end;
    end;
    2:
    begin
      case _SampleSize of
        1: _Format := afStereo8;
        2: _Format := afStereo16;
        3: _Format := afStereo24;
        else Exit;
      end;
    end;
    else Exit;
  end;
  if not FindChunk('data') then Exit;
  DataAlloc(ChunkSize);
  DataManager.ReadBuffer(_Data, ChunkSize);
end;
//TG2AudioWAV END

initialization
begin
  G2AddAudioFormat(TG2AudioWAV);
end;

end.
