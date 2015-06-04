unit G2ImageBMP;

interface

uses
  Classes,
  G2Image;

type
  TG2ImageBMP = class (TG2Image)
  public
    class function CanLoad(const Stream: TStream): Boolean; override;
    procedure Load(const Stream: TStream); override;
  end;

implementation

const
  BMPHeader: array[0..1] of AnsiChar = 'BM';

type
  THeader = packed record
    Header: Word;
    Size: DWord;
    Reserved1: Word;
    Reserved2: Word;
    OffBits: DWord;
  end;

class function CanLoad(const Stream: TStream): Boolean;
  var Header: array[0..1] of AnsiChar;
begin
  Result := False;
  if Stream.Size - Stream.Position < 2 then Exit;
  {$Hints off}
  Stream.Read(Header, 2);
  {$Hints on}
  Result := Header = BMPHeader;
  Stream.Seek(-2, soFromCurrent);
end;

procedure TG2ImageBMP.Load(const Stream: TStream);
  var Header: THeader;
begin
  if Stream.Size - Stream.Position < SizeOf(Header) then Exit;
  Stream.Read(Header, SizeOf(Header));
  if Header.Header <> PWord(@BMPHeader)^ then Exit;

end;

end.
