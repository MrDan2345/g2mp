unit G2DataManager;

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
  G2Types,
  G2Math,
  G2Utils;

type
  TG2DataManager = class (TG2ResourceAsync)
  private
    _Ajax: Variant;
    _Data: Variant;
    _Position: Integer;
    _OnLoadProc: TG2ProcObj;
    procedure OnAjaxStateChange;
    procedure OnLoad;
    function GetSize: Integer;
  public
    property Position: Integer read _Position write _Position;
    property OnLoadProc: TG2ProcObj read _OnLoadProc write _OnLoadProc;
    property Size: Integer read GetSize;
    constructor Create; override;
    destructor Destroy; override;
    procedure Load(const FileName: String);
    function ReadBool: Boolean;
    function ReadIntS8: Integer;
    function ReadIntS16: Integer;
    function ReadIntS32: Integer;
    function ReadIntU8: Integer;
    function ReadIntU16: Integer;
    function ReadIntU32: Integer;
    function ReadFloat32: TG2Float;
    function ReadFloat64: TG2Float;
    function ReadVec2: TG2Vec2;
    function ReadVec3: TG2Vec3;
    function ReadVec4: TG2Vec4;
    function ReadMat3x3: TG2Mat;
    function ReadMat4x3: TG2Mat;
    function ReadMat4x4: TG2Mat;
    function ReadString(const Size: Integer): String;
    function ReadStringNT: String;
    procedure Skip(const Size: Integer);
  end;

implementation

//TG2DataManager BEGIN
procedure TG2DataManager.OnAjaxStateChange;
begin
  if (_Ajax.readyState = 4) and (_Ajax.status = 200) then
  OnLoad;
end;

procedure TG2DataManager.OnLoad;
begin
  asm
    @_Data = new DataView((@_Ajax).response);
  end;
  _Position := 0;
  _State := asLoaded;
  if Assigned(_OnLoadProc) then
  _OnLoadProc;
end;

function TG2DataManager.GetSize: Integer;
begin
  Result := _Data.byteLength;
end;

constructor TG2DataManager.Create;
begin
  inherited Create;
  asm
    @_Ajax = new XMLHttpRequest();
  end;
  _Ajax.onreadystatechange := @OnAjaxStateChange;
  _OnLoadProc := nil;
end;

destructor TG2DataManager.Destroy;
begin
  inherited Destroy;
end;

procedure TG2DataManager.Load(const FileName: String);
begin
  _State := asLoading;
  if PreventCaching then
  begin
    //_Ajax.setRequestHeader("pragma", "no-cache");
    _Ajax.open('GET', FileName + '?c=' + IntToStr(G2Time), True);
  end
  else
  _Ajax.open('GET', FileName, True);
  _Ajax.responseType := 'arraybuffer';
  _Ajax.send();
end;

function TG2DataManager.ReadBool: Boolean;
begin
  Result := _Data.getInt8(_Position, True) > 0;
  Inc(_Position, 1);
end;

function TG2DataManager.ReadIntS8: Integer;
begin
  Result := _Data.getInt8(_Position, True);
  Inc(_Position, 1);
end;

function TG2DataManager.ReadIntS16: Integer;
begin
  Result := _Data.getInt16(_Position, True);
  Inc(_Position, 2);
end;

function TG2DataManager.ReadIntS32: Integer;
begin
  Result := _Data.getInt32(_Position, True);
  Inc(_Position, 4);
end;

function TG2DataManager.ReadIntU8: Integer;
begin
  Result := _Data.getUint8(_Position, True);
  Inc(_Position, 1);
end;

function TG2DataManager.ReadIntU16: Integer;
begin
  Result := _Data.getUint16(_Position, True);
  Inc(_Position, 2);
end;

function TG2DataManager.ReadIntU32: Integer;
begin
  Result := _Data.getUint32(_Position, True);
  Inc(_Position, 4);
end;

function TG2DataManager.ReadFloat32: TG2Float;
begin
  Result := _Data.getFloat32(_Position, True);
  Inc(_Position, 4);
end;

function TG2DataManager.ReadFloat64: TG2Float;
begin
  Result := _Data.getFloat64(_Position, True);
  Inc(_Position, 8);
end;

function TG2DataManager.ReadVec2: TG2Vec2;
begin
  Result.x := ReadFloat32;
  Result.y := ReadFloat32;
end;

function TG2DataManager.ReadVec3: TG2Vec3;
begin
  Result.x := ReadFloat32;
  Result.y := ReadFloat32;
  Result.z := ReadFloat32;
end;

function TG2DataManager.ReadVec4: TG2Vec4;
begin
  Result.x := ReadFloat32;
  Result.y := ReadFloat32;
  Result.z := ReadFloat32;
  Result.w := ReadFloat32;
end;

function TG2DataManager.ReadMat3x3: TG2Mat;
begin
  Result.e00 := ReadFloat32;
  Result.e01 := ReadFloat32;
  Result.e02 := ReadFloat32;
  Result.e03 := 0;
  Result.e10 := ReadFloat32;
  Result.e11 := ReadFloat32;
  Result.e12 := ReadFloat32;
  Result.e13 := 0;
  Result.e20 := ReadFloat32;
  Result.e21 := ReadFloat32;
  Result.e22 := ReadFloat32;
  Result.e23 := 0;
  Result.e30 := 0;
  Result.e31 := 0;
  Result.e32 := 0;
  Result.e33 := 1;
end;

function TG2DataManager.ReadMat4x3: TG2Mat;
begin
  Result.e00 := ReadFloat32;
  Result.e01 := ReadFloat32;
  Result.e02 := ReadFloat32;
  Result.e03 := 0;
  Result.e10 := ReadFloat32;
  Result.e11 := ReadFloat32;
  Result.e12 := ReadFloat32;
  Result.e13 := 0;
  Result.e20 := ReadFloat32;
  Result.e21 := ReadFloat32;
  Result.e22 := ReadFloat32;
  Result.e23 := 0;
  Result.e30 := ReadFloat32;
  Result.e31 := ReadFloat32;
  Result.e32 := ReadFloat32;
  Result.e33 := 1;
end;

function TG2DataManager.ReadMat4x4: TG2Mat;
begin
  Result.e00 := ReadFloat32;
  Result.e01 := ReadFloat32;
  Result.e02 := ReadFloat32;
  Result.e03 := ReadFloat32;
  Result.e10 := ReadFloat32;
  Result.e11 := ReadFloat32;
  Result.e12 := ReadFloat32;
  Result.e13 := ReadFloat32;
  Result.e20 := ReadFloat32;
  Result.e21 := ReadFloat32;
  Result.e22 := ReadFloat32;
  Result.e23 := ReadFloat32;
  Result.e30 := ReadFloat32;
  Result.e31 := ReadFloat32;
  Result.e32 := ReadFloat32;
  Result.e33 := ReadFloat32;
end;

function TG2DataManager.ReadString(const Size: Integer): String;
  var i: Integer;
begin
  Result := '';
  for i := 0 to Size - 1 do
  Result := Result + G2Char(ReadIntU8);
end;

function TG2DataManager.ReadStringNT: String;
  var b: Integer;
begin
  Result := '';
  b := ReadIntU8;
  while (b <> 0) do
  begin
    Result := Result + G2Char(b);
    b := ReadIntU8;
  end;
end;

procedure TG2DataManager.Skip(const Size: Integer);
begin
  _Position := _Position + Size;
end;
//TG2DataManager END

end.
