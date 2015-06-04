unit G2Image;

//The contents of this software are used with permission, subject to
//the Mozilla Public License Version 1.1 (the "License"); you may
//not use this software except in compliance with the License. You may
//obtain a copy of the License at
//http://www.mozilla.org/MPL/MPL-1.1.html
//
//Software distributed under the License is distributed on an
//"AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
//implied. See the License for the specific language governing
//rights and limitations under the License.
//
//This module is a part of g2mp game development framework.

interface

uses
  w3c.TypedArray,
  G2DataManager;

type
  TG2Image = class;

  TG2ColorRGBA = record
    r, g, b, a: Integer;
  end;

  CG2ImageFormat = class of TG2Image;

  TG2Image = class
  protected
    _Width: Integer;
    _Height: Integer;
    _Data: JInt8Array;
    _DataSize: Integer;
    function GetPixel(const x, y: Integer): TG2ColorRGBA;
    procedure SetPixel(const x, y: Integer; const Value: TG2ColorRGBA);
    procedure DataAlloc(const Size: Integer);
    procedure DataFree;
  public
    property Width: Integer read _Width;
    property Height: Integer read _Height;
    property Data: JInt8Array read _Data;
    property Pixels[const x, y: Integer]: TG2ColorRGBA read GetPixel write SetPixel; default;
    class function CanLoad(const DataManager: TG2DataManager): Boolean; virtual; abstract;
    procedure Load(const DataManager: TG2DataManager); virtual; abstract;
    procedure Allocate(const NewWidth, NewHeight: Integer);
    constructor Create; virtual;
    destructor Destroy; override;
  end;

implementation

//TG2Image BEGIN
function TG2Image.GetPixel(const x, y: Integer): TG2ColorRGBA;
  var n: Integer;
begin
  n := (y * _Width + x) * 4;
  Result.r := _Data[n];
  Result.g := _Data[n + 1];
  Result.b := _Data[n + 2];
  Result.a := _Data[n + 3];
end;

procedure TG2Image.SetPixel(const x, y: Integer; const Value: TG2ColorRGBA);
  var n: Integer;
begin
  n := (y * _Width + x) * 4;
  _Data[n] := Value.r;
  _Data[n + 1] := Value.g;
  _Data[n + 2] := Value.b;
  _Data[n + 3] := Value.a;
end;

procedure TG2Image.DataAlloc(const Size: Integer);
begin
  _Data := JInt8Array.Create(Size);
  _DataSize := Size;
end;

procedure TG2Image.DataFree;
begin
  _Data := nil;
end;

procedure TG2Image.Allocate(const NewWidth, NewHeight: Integer);
begin
  DataAlloc(NewWidth * NewHeight * 4);
end;

constructor TG2Image.Create;
begin
  inherited Create;
end;

destructor TG2Image.Destroy;
begin
  DataFree;
  inherited Destroy;
end;
//TG2Image END

end.
