unit G2ImagePNG;

{$mode objfpc}

interface

uses
  Types,
  Classes,
  G2DataManager,
  G2Image,
  ZBase,
  ZInflate;

type
  TG2ImagePNG = class(TG2Image)
  protected
    class procedure Decompress(const Buffer: Pointer; const Size: Integer; const Output: TStream);
    class function Swap16(const n: Word): Word;
    class function Swap32(const n: LongWord): LongWord;
    class function GetCRC(const Buffer: Pointer; const Size: Integer): LongWord;
  public
    class function CanLoad(const DataManager: TG2DataManager): Boolean; override;
    procedure Load(const DataManager: TG2DataManager); override;
    procedure Save(const DataManager: TG2DataManager); override;
  end;

implementation

type
  {$MINENUMSIZE 1}
  TColorType = (
    ctGrayscale = 0,
    ctTrueColor = 2,
    ctIndexedColor = 3,
    ctGrayscaleAlpha = 4,
    ctTrueColorAlpha = 6
  );
  {$MINENUMSIZE 4}

  TFilter = (
    flNone = 0,
    flSub = 1,
    flUp = 2,
    flAverage = 3,
    flPaeth = 4
  );

  TInterlace = (
    inNone = 0,
    inAdam7 = 1
  );

  TChunk = packed record
    ChunkLength: LongWord;
    ChunkType: array[0..3] of AnsiChar;
    ChunkData: Pointer;
    ChunkCRC: LongWord;
  end;

  TChunkIHDR = packed record
    Width: LongWord;
    Height: LongWord;
    BitDepth: Byte;
    ColorType: TColorType;
    CompMethod: Byte;
    FilterMethod: Byte;
    InterlaceMethod: TInterlace;
  end;

  TChunkPLTE = packed record
    Entries: array of record r, g, b: Byte; end;
  end;

  TChunkIDAT = array of Byte;

const
  PNGHeader: AnsiString = (#137#80#78#71#13#10#26#10);
  CRCTable: array[0..255] of LongWord = (
    $00000000, $77073096, $EE0E612C, $990951BA, $076DC419, $706AF48F, $E963A535, $9E6495A3,
    $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988, $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
    $1DB71064, $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC, $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
    $3B6E20C8, $4C69105E, $D56041E4, $A2677172, $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
    $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940, $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
    $26D930AC, $51DE003A, $C8D75180, $BFD06116, $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
    $2802B89E, $5F058808, $C60CD9B2, $B10BE924, $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,
    $76DC4190, $01DB7106, $98D220BC, $EFD5102A, $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
    $7807C9A2, $0F00F934, $9609A88E, $E10E9818, $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E, $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
    $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C, $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
    $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2, $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
    $4369E96A, $346ED9FC, $AD678846, $DA60B8D0, $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
    $5005713C, $270241AA, $BE0B1010, $C90C2086, $5768B525, $206F85B3, $B966D409, $CE61E49F,
    $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,
    $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A, $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
    $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8, $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
    $F00F9344, $8708A3D2, $1E01F268, $6906C2FE, $F762575D, $806567CB, $196C3671, $6E6B06E7,
    $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC, $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
    $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252, $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
    $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60, $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
    $CB61B38C, $BC66831A, $256FD2A0, $5268E236, $CC0C7795, $BB0B4703, $220216B9, $5505262F,
    $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04, $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
    $9B64C2B0, $EC63F226, $756AA39C, $026D930A, $9C0906A9, $EB0E363F, $72076785, $05005713,
    $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38, $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21,
    $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E, $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
    $88085AE6, $FF0F6A70, $66063BCA, $11010B5C, $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
    $A00AE278, $D70DD2EE, $4E048354, $3903B3C2, $A7672661, $D06016F7, $4969474D, $3E6E77DB,
    $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0, $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
    $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6, $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94, $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D
  );

function CheckCRC(const Chunk: TChunk): Boolean;
  var i: Integer;
  var CRC: LongWord;
  var Data: PByte;
begin
  CRC := $ffffffff;
  for i := 0 to 3 do
  CRC := CRCTable[(CRC xor Byte(Chunk.ChunkType[i])) and $ff] xor (CRC shr 8);
  Data := Chunk.ChunkData;
  for i := 0 to Chunk.ChunkLength - 1 do
  begin
    CRC := CRCTable[(CRC xor Data^) and $ff] xor (CRC shr 8);
    Inc(Data);
  end;
  CRC := CRC xor $ffffffff;
  Result := CRC = Chunk.ChunkCRC;
end;

//TG2ImagePNG BEGIN
{$Hints off}
class procedure TG2ImagePNG.Decompress(const Buffer: Pointer; const Size: Integer; const Output: TStream);
  var ZStreamRec: z_stream;
  var ZResult: Integer;
  var TempBuffer: Pointer;
  const BufferSize = $8000;
begin
  FillChar(ZStreamRec, SizeOf(z_stream), 0);
  ZStreamRec.next_in := Buffer;
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

class function TG2ImagePNG.Swap16(const n: Word): Word;
  type TByte2 = array[0..1] of Byte;
  var t: Word;
begin
  TByte2(t)[0] := TByte2(n)[1];
  TByte2(t)[1] := TByte2(n)[0];
  Result := t;
end;

class function TG2ImagePNG.Swap32(const n: LongWord): LongWord;
  type TByte4 = array[0..3] of Byte;
  var t: LongWord;
begin
  TByte4(t)[0] := TByte4(n)[3];
  TByte4(t)[1] := TByte4(n)[2];
  TByte4(t)[2] := TByte4(n)[1];
  TByte4(t)[3] := TByte4(n)[0];
  Result := t;
end;
{$Hints on}

class function TG2ImagePNG.GetCRC(const Buffer: Pointer; const Size: Integer): LongWord;
  var i: Integer;
  var pb: PByte;
begin
  Result := $ffffffff;
  pb := Buffer;
  for i := 0 to Size - 1 do
  begin
    Result:= CRCTable[(Result xor pb^) and $ff] xor (Result shr 8);
    Inc(pb);
  end;
  Result := Result xor $ffffffff;
end;

class function TG2ImagePNG.CanLoad(const DataManager: TG2DataManager): Boolean;
  var Header: array[0..7] of AnsiChar;
begin
  Result := False;
  if DataManager.Size - DataManager.Position < 8 then Exit;
  {$Hints off}
  DataManager.ReadBuffer(@Header, 8);
  {$Hints on}
  Result := Header = PNGHeader;
  DataManager.Position := DataManager.Position - 8;
end;

procedure TG2ImagePNG.Load(const DataManager: TG2DataManager);
  var Header: array[0..7] of AnsiChar;
  var ChunkData: array of Byte;
  var Chunk: TChunk;
  var ChunkIHDR: TChunkIHDR;
  var ChunkPLTE: TChunkPLTE;
  var ChunkIDAT: array of TChunkIDAT;
  var TranspG: Word;
  var TranspRGB: array[0..2] of Word;
  var TranspPalette: array of Byte;
  var Transp: Boolean;
  var KeepReading: Boolean;
  procedure ReadChunk;
  begin
    DataManager.ReadBuffer(@Chunk.ChunkLength, 4); Chunk.ChunkLength := Swap32(Chunk.ChunkLength);
    DataManager.ReadBuffer(@Chunk.ChunkType, 4);
    if Length(ChunkData) < Integer(Chunk.ChunkLength) then
    SetLength(ChunkData, Chunk.ChunkLength);
    Chunk.ChunkData := @ChunkData[0];
    DataManager.ReadBuffer(Chunk.ChunkData, Chunk.ChunkLength);
    DataManager.ReadBuffer(@Chunk.ChunkCRC, 4); Chunk.ChunkCRC := Swap32(Chunk.ChunkCRC);
  end;
  var i, j, Pass: Integer;
  var PixelDataSize: LongInt;
  var CompressedData: TMemoryStream;
  var DecompressedData: TMemoryStream;
  var CurFilter: TFilter;
  var ScanLineCur: PByteArray;
  var ScanLinePrev: PByteArray;
  var ScanLineSize: LongWord;
  var BitPerPixel: Byte;
  var BitStep: Byte;
  var BitMask: Byte;
  var BitCur: Byte;
  function UnpackBits(const Bits: Byte): Byte;
  begin
    Result := Round((Bits / BitMask) * $ff);
  end;
  function GetA(const Pos: Integer): Byte;
  begin
    if ChunkIHDR.BitDepth < 8 then
    begin
      if Pos > 0 then
      Result := ScanlineCur^[Pos - 1]
      else
      Result := 0;
    end
    else
    begin
      if Pos >= PixelDataSize then
      Result := ScanlineCur^[Pos - PixelDataSize]
      else
      Result := 0;
    end;
  end;
  function GetB(const Pos: Integer): Byte;
  begin
    if ScanlinePrev <> nil then
    Result := ScanlinePrev^[Pos]
    else
    Result := 0;
  end;
  function GetC(const Pos: Integer): Byte;
  begin
    if ScanlinePrev <> nil then
    begin
      if ChunkIHDR.BitDepth < 8 then
      begin
        if Pos > 0 then
        Result := ScanlinePrev^[Pos - 1]
        else
        Result := 0;
      end
      else
      begin
        if Pos >= PixelDataSize then
        Result := ScanlinePrev^[Pos - PixelDataSize]
        else
        Result := 0;
      end;
    end
    else
    Result := 0;
  end;
  function PaethPredictor(const a, b, c: Byte): Byte;
    var p, pa, pb, pc: Integer;
  begin
    p := Integer(a) + Integer(b) - Integer(c);
    pa := Abs(p - a);
    pb := Abs(p - b);
    pc := Abs(p - c);
    if (pa <= pb) and (pa <= pc) then Result := a
    else if (pb <= pc) then Result := b
    else Result := c;
  end;
  function FilterSub(const x: Byte; const Pos: Integer): Byte;
  begin
    Result := (x + GetA(Pos)) and $ff;
  end;
  function FilterUp(const x: Byte; const Pos: Integer): Byte;
  begin
    Result := (x + GetB(Pos)) and $ff;
  end;
  function FilterAverage(const x: Byte; const Pos: Integer): Byte;
  begin
    Result := (x + (GetA(Pos) + GetB(Pos)) div 2) and $ff;
  end;
  function FilterPaeth(const x: Byte; const Pos: Integer): Byte;
  begin
    Result := (x + PaethPredictor(GetA(Pos), GetB(Pos), GetC(Pos))) and $ff;
  end;
  const RowStart: array[0..7] of Integer = (0, 0, 0, 4, 0, 2, 0, 1);
  const ColStart: array[0..7] of Integer = (0, 0, 4, 0, 2, 0, 1, 0);
  const RowOffset: array[0..7] of Integer = (1, 8, 8, 8, 4, 4, 2, 2);
  const ColOffset: array[0..7] of Integer = (1, 8, 8, 4, 4, 2, 2, 1);
  var PassRows: LongInt;
  var PassCols: LongInt;
  var PassStart: LongInt;
  var PassEnd: LongInt;
  var x, y, b: Integer;
  var DataPtr: Pointer;
begin
  {$Hints off}
  DataManager.ReadBuffer(@Header, 8);
  {$Hints on}
  if Header = PNGHeader then
  begin
    ChunkIDAT := nil;
    Transp := False;
    KeepReading := True;
    while KeepReading do
    begin
      ReadChunk;
      if CheckCRC(Chunk) then
      begin
        if (Chunk.ChunkType = 'IHDR') then
        begin
          ChunkIHDR.Width := Swap32(PLongWord(@PByteArray(Chunk.ChunkData)^[0])^);
          ChunkIHDR.Height := Swap32(PLongWord(@PByteArray(Chunk.ChunkData)^[4])^);
          ChunkIHDR.BitDepth := PByteArray(Chunk.ChunkData)^[8];
          ChunkIHDR.ColorType := TColorType(PByteArray(Chunk.ChunkData)^[9]);
          ChunkIHDR.CompMethod := PByteArray(Chunk.ChunkData)^[10];
          ChunkIHDR.FilterMethod := PByteArray(Chunk.ChunkData)^[11];
          ChunkIHDR.InterlaceMethod := TInterlace(PByteArray(Chunk.ChunkData)^[12]);
          if ChunkIHDR.CompMethod <> 0 then Exit;
          if ChunkIHDR.FilterMethod <> 0 then Exit;
          if Byte(ChunkIHDR.InterlaceMethod) > 1 then Exit;
          case ChunkIHDR.ColorType of
            ctGrayscale:
            begin
              if not (ChunkIHDR.BitDepth in [1, 2, 4, 8, 16]) then Exit;
              if ChunkIHDR.BitDepth = 16 then
              PixelDataSize := 2 else PixelDataSize := 1;
              case ChunkIHDR.BitDepth of
                1:
                begin
                  BitPerPixel := 8;
                  BitStep := 1;
                  BitMask := 1;
                  SetFormat(G2IF_G8);
                end;
                2:
                begin
                  BitPerPixel := 4;
                  BitStep := 2;
                  BitMask := 3;
                  SetFormat(G2IF_G8);
                end;
                4:
                begin
                  BitPerPixel := 2;
                  BitStep := 4;
                  BitMask := 15;
                  SetFormat(G2IF_G8);
                end;
                8: SetFormat(G2IF_G8);
                16: SetFormat(G2IF_G16);
              end;
            end;
            ctTrueColor:
            begin
              if not (ChunkIHDR.BitDepth in [8, 16]) then Exit;
              PixelDataSize := 3 * ChunkIHDR.BitDepth div 8;
              case ChunkIHDR.BitDepth of
                8: SetFormat(G2IF_R8G8B8);
                16: SetFormat(G2IF_R16G16B16);
              end;
            end;
            ctIndexedColor:
            begin
              if not (ChunkIHDR.BitDepth in [1, 2, 4, 8]) then Exit;
              PixelDataSize := 1;
              SetFormat(G2IF_R8G8B8);
              case ChunkIHDR.BitDepth of
                1:
                begin
                  BitPerPixel := 8;
                  BitStep := 1;
                  BitMask := 1;
                end;
                2:
                begin
                  BitPerPixel := 4;
                  BitStep := 2;
                  BitMask := 3;
                end;
                4:
                begin
                  BitPerPixel := 2;
                  BitStep := 4;
                  BitMask := 15;
                end;
              end;
            end;
            ctGrayscaleAlpha:
            begin
              if not (ChunkIHDR.BitDepth in [8, 16]) then Exit;
              PixelDataSize := 2 * ChunkIHDR.BitDepth div 8;
              case ChunkIHDR.BitDepth of
                8: SetFormat(G2IF_G8A8);
                16: SetFormat(G2IF_G16A16);
              end;
            end;
            ctTrueColorAlpha:
            begin
              if not (ChunkIHDR.BitDepth in [8, 16]) then Exit;
              PixelDataSize := 4 * ChunkIHDR.BitDepth div 8;
              case ChunkIHDR.BitDepth of
                8: SetFormat(G2IF_R8G8B8A8);
                16: SetFormat(G2IF_R16G16B16A16);
              end;
            end;
            else
            Exit;
          end;
        end
        else if (Chunk.ChunkType = 'IEND') then
        begin
          KeepReading := False;
        end
        else if (Chunk.ChunkType = 'PLTE') then
        begin
          SetLength(ChunkPLTE.Entries, Chunk.ChunkLength div 3);
          Move(Chunk.ChunkData^, ChunkPLTE.Entries[0], Chunk.ChunkLength);
        end
        else if (Chunk.ChunkType = 'IDAT') then
        begin
          SetLength(ChunkIDAT, Length(ChunkIDAT) + 1);
          SetLength(ChunkIDAT[High(ChunkIDAT)], Chunk.ChunkLength);
          Move(Chunk.ChunkData^, ChunkIDAT[High(ChunkIDAT)][0], Chunk.ChunkLength);
        end
        else if (Chunk.ChunkType = 'tRNS') then
        begin
          Transp := True;
          case ChunkIHDR.ColorType of
            ctGrayscale:
            begin
              TranspG := Swap16(PWord(Chunk.ChunkData)^);
              if Format = G2IF_G8 then
              SetFormat(G2IF_G8A8)
              else
              SetFormat(G2IF_G16A16);
            end;
            ctTrueColor:
            begin
              for i := 0 to 2 do
              TranspRGB[i] := Swap16(PWord(Chunk.ChunkData)^);
              if Format = G2IF_R8G8B8 then
              SetFormat(G2IF_R8G8B8A8)
              else
              SetFormat(G2IF_R16G16B16A16);
            end;
            ctIndexedColor:
            begin
              SetLength(TranspPalette, Chunk.ChunkLength);
              Move(Chunk.ChunkData^, TranspPalette[0], Chunk.ChunkLength);
              SetFormat(G2IF_R8G8B8A8);
            end;
            ctGrayscaleAlpha, ctTrueColorAlpha: Exit;
          end;
        end;
      end;
    end;
    CompressedData := TMemoryStream.Create;
    DecompressedData := TMemoryStream.Create;
    try
     CompressedData.Position := 0;
     DecompressedData.Position := 0;
     for i := 0 to High(ChunkIDAT) do
     CompressedData.Write(ChunkIDAT[i][0], Length(ChunkIDAT[i]));
     Decompress(CompressedData.Memory, CompressedData.Size, DecompressedData);
     _Width := ChunkIHDR.Width;
     _Height := ChunkIHDR.Height;
     DataAlloc;
     DecompressedData.Position := 0;
     case ChunkIHDR.InterlaceMethod of
       inAdam7: begin PassStart := 1; PassEnd := 7; end;
       else begin PassStart := 0; PassEnd := 0; end;
     end;
     DataPtr := DecompressedData.Memory;
     for Pass := PassStart to PassEnd do
     begin
       PassRows := _Height div RowOffset[Pass];
       if (_Height mod RowOffset[Pass]) > RowStart[Pass] then Inc(PassRows);
       PassCols := _Width div ColOffset[Pass];
       if (_Width mod ColOffset[Pass]) > ColStart[Pass] then Inc(PassCols);
       if (PassRows > 0) and (PassCols > 0) then
       begin
         ScanlineSize := PixelDataSize * PassCols;
         ScanlinePrev := nil;
         ScanlineCur := DataPtr;
         if ChunkIHDR.BitDepth < 8 then
         begin
           if ScanlineSize mod BitPerPixel > 0 then
           ScanlineSize := (ScanlineSize div BitPerPixel + 1)
           else
           ScanlineSize := (ScanlineSize div BitPerPixel);
         end;
         Inc(DataPtr, (Integer(ScanlineSize) + 1) * PassRows);
         y := RowStart[Pass];
         for j := 0 to PassRows - 1 do
         begin
           CurFilter := TFilter(ScanlineCur^[0]);
           {$Hints off}
           ScanlineCur := PByteArray(PtrUInt(ScanlineCur) + 1);
           {$Hints on}
           if ChunkIHDR.BitDepth > 8 then
           for i := 0 to ScanlineSize div 2 - 1 do
           PWord(@ScanlineCur^[i * 2])^ := Swap16(PWord(@ScanlineCur^[i * 2])^);
           x := ColStart[Pass];
           case CurFilter of
             flSub:
             for i := 0 to ScanlineSize - 1 do
             ScanlineCur^[i] := FilterSub(ScanlineCur^[i], i);
             flUp:
             for i := 0 to ScanlineSize - 1 do
             ScanlineCur^[i] := FilterUp(ScanlineCur^[i], i);
             flAverage:
             for i := 0 to ScanlineSize - 1 do
             ScanlineCur^[i] := FilterAverage(ScanlineCur^[i], i);
             flPaeth:
             for i := 0 to ScanlineSize - 1 do
             ScanlineCur^[i] := FilterPaeth(ScanlineCur^[i], i);
           end;
           if ChunkIHDR.ColorType = ctIndexedColor then
           begin
             if ChunkIHDR.BitDepth < 8 then
             begin
               for i := 0 to PassCols - 1 do
               begin
                 BitCur := (ScanlineCur^[i div BitPerPixel] shr (8 - (i mod BitPerPixel + 1) * BitStep)) and BitMask;
                 PByte(_Data + (y * _Width + x) * _BPP + 0)^ := ChunkPLTE.Entries[BitCur].r;
                 PByte(_Data + (y * _Width + x) * _BPP + 1)^ := ChunkPLTE.Entries[BitCur].g;
                 PByte(_Data + (y * _Width + x) * _BPP + 2)^ := ChunkPLTE.Entries[BitCur].b;
                 if Transp then
                 begin
                   if BitCur > High(TranspPalette) then
                   PByte(_Data + (y * _Width + x) * _BPP + 3)^ := $ff
                   else
                   PByte(_Data + (y * _Width + x) * _BPP + 3)^ := TranspPalette[BitCur];
                 end;
                 x := x + ColOffset[Pass];
               end;
             end
             else //8 or 16 bit
             begin
               for i := 0 to PassCols - 1 do
               begin
                 PByte(_Data + (y * _Width + x) * _BPP + 0)^ := ChunkPLTE.Entries[ScanlineCur^[i]].r;
                 PByte(_Data + (y * _Width + x) * _BPP + 1)^ := ChunkPLTE.Entries[ScanlineCur^[i]].g;
                 PByte(_Data + (y * _Width + x) * _BPP + 2)^ := ChunkPLTE.Entries[ScanlineCur^[i]].b;
                 if Transp then
                 begin
                   if ScanlineCur^[i] > High(TranspPalette) then
                   PByte(_Data + (y * _Width + x) * _BPP + 3)^ := $ff
                   else
                   PByte(_Data + (y * _Width + x) * _BPP + 3)^ := TranspPalette[ScanlineCur^[i]];
                 end;
                 x := x + ColOffset[Pass];
               end;
             end;
           end
           else //non indexed
           begin
             if ChunkIHDR.BitDepth < 8 then
             begin
               for i := 0 to PassCols - 1 do
               begin
                 BitCur := (ScanlineCur^[i div BitPerPixel] shr (8 - (i mod BitPerPixel + 1) * BitStep)) and BitMask;
                 if Transp then
                 begin
                   if ChunkIHDR.ColorType = ctGrayscale then
                   begin
                     if BitCur = TranspG and BitMask then
                     PByte(_Data + (y * _Width + x) * _BPP + 1)^ := 0
                     else
                     PByte(_Data + (y * _Width + x) * _BPP + 1)^ := $ff;
                   end;
                 end;
                 BitCur := UnpackBits(BitCur);
                 PByte(_Data + (y * _Width + x) * _BPP)^ := BitCur;
                 x := x + ColOffset[Pass];
               end;
             end
             else //8 or 16 bit
             begin
               for i := 0 to PassCols - 1 do
               begin
                 for b := 0 to PixelDataSize - 1 do
                 PByte(_Data + (y * _Width + x) * _BPP + b)^ := ScanlineCur^[i * PixelDataSize + b];
                 if Transp then
                 begin
                   if ChunkIHDR.ColorType = ctGrayscale then
                   begin
                     if ChunkIHDR.BitDepth = 8 then
                     begin
                       if ScanlineCur^[i * PixelDataSize] = Byte(TranspG and $ff) then
                       PByteArray(_Data)^[(y * _Width + x) * _BPP + PixelDataSize] := 0
                       else
                       PByteArray(_Data)^[(y * _Width + x) * _BPP + PixelDataSize] := $ff;
                     end
                     else
                     begin
                       if PWord(@ScanlineCur^[i * PixelDataSize])^ = TranspG then
                       PWord(@PByteArray(_Data)^[(y * _Width + x) * _BPP + PixelDataSize])^ := 0
                       else
                       PWord(@PByteArray(_Data)^[(y * _Width + x) * _BPP + PixelDataSize])^ := $ffff;
                     end;
                   end
                   else
                   begin
                     if ChunkIHDR.BitDepth = 8 then
                     begin
                       if (ScanlineCur^[i * PixelDataSize + 0] = Byte(TranspRGB[0] and $ff))
                       and (ScanlineCur^[i * PixelDataSize + 1] = Byte(TranspRGB[1] and $ff))
                       and (ScanlineCur^[i * PixelDataSize + 2] = Byte(TranspRGB[2] and $ff)) then
                       PByte(_Data + (y * _Width + x) * _BPP + 3)^ := 0
                       else
                       PByte(_Data + (y * _Width + x) * _BPP + 3)^ := $ff;
                     end
                     else
                     begin
                       if (PWord(@ScanlineCur^[i * PixelDataSize + 0])^ = TranspRGB[0])
                       and (PWord(@ScanlineCur^[i * PixelDataSize + 2])^ = TranspRGB[1])
                       and (PWord(@ScanlineCur^[i * PixelDataSize + 4])^ = TranspRGB[2]) then
                       PWord(_Data + (y * _Width + x) * _BPP + 6)^ := 0
                       else
                       PWord(_Data + (y * _Width + x) * _BPP + 6)^ := $ffff;
                     end;
                   end;
                 end;
                 x := x + ColOffset[Pass];
               end;
             end;
           end;
           ScanlinePrev := ScanlineCur;
           {$Hints off}
           ScanlineCur := PByteArray(PtrUInt(ScanlineCur) + ScanlineSize);
           {$Hints on}
           y := y + RowOffset[Pass];
         end;
       end;
     end;
    finally
      CompressedData.Free;
      DecompressedData.Free;
    end;
  end;
end;

procedure TG2ImagePNG.Save(const DataManager: TG2DataManager);
  var ChunkType: array[0..3] of AnsiChar;
  var ChunkCompress: Boolean;
  var ChunkStreamDecompressed: TMemoryStream;
  var ChunkStreamCompressed: TMemoryStream;
  procedure ChunkBegin(const ChunkName: AnsiString);
  begin
    ChunkType := ChunkName[1] + ChunkName[2] + ChunkName[3] + ChunkName[4];
    ChunkCompress := ChunkType = 'IDAT';
    ChunkStreamDecompressed := TMemoryStream.Create;
    ChunkStreamCompressed := TMemoryStream.Create;
  end;
  procedure ChunkEnd;
  begin
    ChunkStreamDecompressed.Position := 0;
    ChunkStreamCompressed.Write(ChunkType, 4);
    if ChunkStreamDecompressed.Size > 0 then
    begin
      if ChunkCompress then
      G2ZLibCompress(ChunkStreamDecompressed.Memory, ChunkStreamDecompressed.Size, ChunkStreamCompressed)
      else
      ChunkStreamCompressed.Write(ChunkStreamDecompressed.Memory^, ChunkStreamDecompressed.Size);
    end;
    DataManager.WriteIntS32(Swap32(ChunkStreamCompressed.Size - 4));
    ChunkStreamCompressed.Position := 0;
    DataManager.WriteBuffer(ChunkStreamCompressed.Memory, ChunkStreamCompressed.Size);
    ChunkStreamCompressed.Position := 0;
    DataManager.WriteIntU32(Swap32(GetCRC(ChunkStreamCompressed.Memory, ChunkStreamCompressed.Size)));
    ChunkStreamDecompressed.Free;
    ChunkStreamCompressed.Free;
  end;
  procedure ChunkWrite(const Buffer: Pointer; const Size: Int64);
  begin
    ChunkStreamDecompressed.WriteBuffer(Buffer^, Size);
  end;
  procedure ChunkWriteInt4U(const v: LongWord);
  begin
    ChunkWrite(@v, 4);
  end;
  procedure ChunkWriteInt4S(const v: Integer);
  begin
    ChunkWrite(@v, 4);
  end;
  procedure ChunkWriteInt2U(const v: Word);
  begin
    ChunkWrite(@v, 2);
  end;
  procedure ChunkWriteInt2S(const v: SmallInt);
  begin
    ChunkWrite(@v, 2);
  end;
  procedure ChunkWriteInt1U(const v: Byte);
  begin
    ChunkWrite(@v, 1);
  end;
  procedure ChunkWriteInt1S(const v: ShortInt);
  begin
    ChunkWrite(@v, 1);
  end;
  var ImageData: Pointer;
  var ImageDataSize: Integer;
  var pb: PByte;
  var i, j: Integer;
begin
  DataManager.WriteBuffer(@PNGHeader[1], 8);
  ChunkBegin('IHDR');
  ChunkWriteInt4S(Swap32(_Width));
  ChunkWriteInt4S(Swap32(_Height));
  ChunkWriteInt1U(8);
  ChunkWriteInt1U(Byte(ctTrueColorAlpha));
  ChunkWriteInt1U(0);
  ChunkWriteInt1U(0);
  ChunkWriteInt1U(0);
  ChunkEnd;
  ChunkBegin('IDAT');
  ImageDataSize := (_Width * 4 + 1) * _Height;
  GetMem(ImageData, ImageDataSize);
  pb := ImageData;
  for j := 0 to _Height - 1 do
  begin
    pb^ := 0; Inc(pb);
    for i := 0 to _Width - 1 do
    begin
      PG2ColorR8G8B8A8(pb)^ := Pixels[i, j];
      Inc(pb, 4);
    end;
  end;
  ChunkWrite(ImageData, ImageDataSize);
  FreeMem(ImageData, ImageDataSize);
  ChunkEnd;
  ChunkBegin('IEND');
  ChunkEnd;
end;
//TG2ImagePNG END

initialization
begin
  G2AddImageFormat(TG2ImagePNG);
end;

end.
