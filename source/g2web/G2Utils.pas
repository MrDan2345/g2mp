unit G2Utils;

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
  G2Math;

type
  TG2AsyncState = (
    asIdle,
    asLoading,
    asLoaded,
    asError
  );

  TG2QuickList = record
  private
    _Items: array of TObject;
    _ItemCount: Integer;
    procedure SetItem(const Index: Integer; const Value: TObject);
    function GetItem(const Index: Integer): TObject;
    procedure SetCapacity(const Value: Integer);
    function GetCapacity: Integer;
    function GetFirst: TObject;
    function GetLast: TObject;
  public
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read _ItemCount;
    property Items[const Index: Integer]: TObject read GetItem write SetItem; default;
    property First: TObject read GetFirst;
    property Last: TObject read GetLast;
    function Add(const Item: TObject): Integer;
    function Pop: TObject;
    function Insert(const Index: Integer; const Item: TObject): Integer;
    procedure Delete(const Index: Integer);
    procedure Remove(const Item: TObject);
    procedure Clear;
  end;

  TG2QuickListVariant = record
  private
    _Items: array of Variant;
    _ItemCount: Integer;
    procedure SetItem(const Index: Integer; const Value: Variant);
    function GetItem(const Index: Integer): Variant;
    procedure SetCapacity(const Value: Integer);
    function GetCapacity: Integer;
    function GetFirst: Variant;
    function GetLast: Variant;
  public
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read _ItemCount;
    property Items[const Index: Integer]: Variant read GetItem write SetItem; default;
    property First: Variant read GetFirst;
    property Last: Variant read GetLast;
    function Add(const Item: Variant): Integer;
    function Pop: Variant;
    function Insert(const Index: Integer; const Item: Variant): Integer;
    procedure Delete(const Index: Integer);
    procedure Remove(const Item: Variant);
    procedure Clear;
  end;

  TG2QuickListInt = record
  private
    _Items: array of Integer;
    _ItemCount: Integer;
    procedure SetItem(const Index: Integer; const Value: Integer);
    function GetItem(const Index: Integer): Integer;
    procedure SetCapacity(const Value: Integer);
    function GetCapacity: Integer;
    function GetFirst: Integer;
    function GetLast: Integer;
  public
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read _ItemCount;
    property Items[const Index: Integer]: Integer read GetItem write SetItem; default;
    property First: Integer read GetFirst;
    property Last: Integer read GetLast;
    function Add(const Item: Integer): Integer;
    function Pop: Integer;
    function Insert(const Index: Integer; const Item: Integer): Integer;
    procedure Delete(const Index: Integer);
    procedure Remove(const Item: Integer);
    procedure Clear;
  end;

  TG2QuickSortListItem = record
    Data: TObject;
    Order: Float;
  end;

  TG2QuickSortList = record
  private
    _Items: array of TG2QuickSortListItem;
    _ItemCount: Integer;
    procedure SetItem(const Index: Integer; const Value: TObject);
    function GetItem(const Index: Integer): TObject;
    procedure InsertItem(const Pos: Integer; const Item: TObject; const Order: Float);
    procedure SetCapacity(const Value: Integer);
    function GetCapacity: Integer;
    function GetFirst: TObject;
    function GetLast: TObject;
  public
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read _ItemCount;
    property Items[const Index: Integer]: TObject read GetItem write SetItem; default;
    property First: TObject read GetFirst;
    property Last: TObject read GetLast;
    function Add(const Item: TObject; const Order: Float): Integer; overload;
    function Add(const Item: TObject): Integer; overload;
    function Pop: TObject;
    procedure Delete(const Index: Integer);
    procedure Remove(const Item: TObject);
    procedure Clear;
  end;

  TG2QuickSortListItemVariant = record
    Data: Variant;
    Order: Float;
  end;

  TG2QuickSortListVariant = record
  private
    _Items: array of TG2QuickSortListItemVariant;
    _ItemCount: Integer;
    procedure SetItem(const Index: Integer; const Value: Variant);
    function GetItem(const Index: Integer): Variant;
    procedure InsertItem(const Pos: Integer; const Item: Variant; const Order: Float);
    procedure SetCapacity(const Value: Integer);
    function GetCapacity: Integer;
    function GetFirst: Variant;
    function GetLast: Variant;
  public
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read _ItemCount;
    property Items[const Index: Integer]: Variant read GetItem write SetItem; default;
    property First: Variant read GetFirst;
    property Last: Variant read GetLast;
    function Add(const Item: Variant; const Order: Float): Integer; overload;
    function Add(const Item: Variant): Integer; overload;
    function Pop: Variant;
    procedure Delete(const Index: Integer);
    procedure Remove(const Item: Variant);
    procedure Clear;
  end;

  TG2QuickSortListItemInt = record
    Data: Integer;
    Order: Float;
  end;

  TG2QuickSortListInt = record
  private
    _Items: array of TG2QuickSortListItemVariant;
    _ItemCount: Integer;
    procedure SetItem(const Index: Integer; const Value: Integer);
    function GetItem(const Index: Integer): Integer;
    procedure InsertItem(const Pos: Integer; const Item: Integer; const Order: Float);
    procedure SetCapacity(const Value: Integer);
    function GetCapacity: Integer;
    function GetFirst: Integer;
    function GetLast: Integer;
  public
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read _ItemCount;
    property Items[const Index: Integer]: Integer read GetItem write SetItem; default;
    property First: Integer read GetFirst;
    property Last: Integer read GetLast;
    function Add(const Item: Integer; const Order: Float): Integer; overload;
    function Add(const Item: Integer): Integer; overload;
    function Pop: Integer;
    procedure Delete(const Index: Integer);
    procedure Remove(const Item: Variant);
    procedure Clear;
  end;

  TG2Resource = class (TObject)
  private
    _Parent: TG2Resource;
    procedure SetParent(const Value: TG2Resource);
  public
    Resources: TG2QuickList;
    property Parent: TG2Resource read _Parent write SetParent;
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TG2ResourceAsync = class (TG2Resource)
  protected
    _State: TG2AsyncState;
  public
    property State: TG2AsyncState read _State;
    constructor Create; override;
  end;

function G2StrExplode(const Str: String; const Separator: String): TG2StrArr;

function G2Char(const n: Integer): String;
function G2Random(const n: Integer): Integer;

function G2Time: Integer;
function G2PiTime(Amp: Single = 1000): Single; overload;
function G2PiTime(Amp: Single; Time: Integer): Single; overload;
function G2TimeInterval(Interval: Integer = 1000): Single; overload;
function G2TimeInterval(Interval: Integer; Time: Integer): Single; overload;
function G2RandomPi: Single;
function G2Random2Pi: Single;
function G2RandomCirclePoint: TG2Vec2;
function G2RandomSpherePoint: TG2Vec3;

var PreventCaching: Boolean = False;

implementation

//TG2QuickList BEGIN
procedure TG2QuickList.SetItem(const Index: Integer; const Value: TObject);
begin
  _Items[Index] := Value;
end;

function TG2QuickList.GetItem(const Index: Integer): TObject;
begin
  Result := _Items[Index];
end;

procedure TG2QuickList.SetCapacity(const Value: Integer);
begin
  _Items.SetLength(Value);
end;

function TG2QuickList.GetCapacity: Integer;
begin
  Result := _Items.Length;
end;

function TG2QuickList.GetFirst: TObject;
begin
  if _ItemCount > 0 then
  Result := _Items[0]
  else
  Result := nil;
end;

function TG2QuickList.GetLast: TObject;
begin
  if _ItemCount > 0 then
  Result := _Items[_ItemCount - 1]
  else
  Result := nil;
end;

function TG2QuickList.Add(const Item: TObject): Integer;
begin
  if _Items.Length <= _ItemCount then
  _Items.SetLength(_Items.Length + 32);
  _Items[_ItemCount] := Item;
  Result := _ItemCount;
  Inc(_ItemCount);
end;

function TG2QuickList.Pop: TObject;
begin
  if _ItemCount > 0 then
  begin
    Result := _Items[_ItemCount - 1];
    Delete(_ItemCount - 1);
  end
  else
  Result := nil;
end;

function TG2QuickList.Insert(const Index: Integer; const Item: TObject): Integer;
  var i: Integer;
begin
  if _Items.Length <= _ItemCount then
  _Items.SetLength(_Items.Length + 32);
  if Index < _ItemCount then
  begin
    for i := _ItemCount - 1 downto Index do
    _Items[i + 1] := _Items[i];
    _Items[Index] := Item;
    Result := Index;
  end
  else
  begin
    _Items[_ItemCount] := Item;
    Result := _ItemCount;
  end;
  Inc(_ItemCount);
end;

procedure TG2QuickList.Delete(const Index: Integer);
  var i: Integer;
begin
  for i := Index to _ItemCount - 2 do
  _Items[i] := _Items[i + 1];
  Dec(_ItemCount);
end;

procedure TG2QuickList.Remove(const Item: TObject);
  var i: Integer;
begin
  for i := 0 to _ItemCount - 1 do
  if _Items[i] = Item then
  begin
    Delete(i);
    Exit;
  end;
end;

procedure TG2QuickList.Clear;
begin
  _ItemCount := 0;
end;
//TG2QuickList END

//TG2QuickListVariant BEGIN
procedure TG2QuickListVariant.SetItem(const Index: Integer; const Value: Variant);
begin
  _Items[Index] := Value;
end;

function TG2QuickListVariant.GetItem(const Index: Integer): Variant;
begin
  Result := _Items[Index];
end;

procedure TG2QuickListVariant.SetCapacity(const Value: Integer);
begin
  _Items.SetLength(Value);
end;

function TG2QuickListVariant.GetCapacity: Integer;
begin
  Result := _Items.Length;
end;

function TG2QuickListVariant.GetFirst: Variant;
begin
  if _ItemCount > 0 then
  Result := _Items[0]
  else
  Result := nil;
end;

function TG2QuickListVariant.GetLast: Variant;
begin
  if _ItemCount > 0 then
  Result := _Items[_ItemCount - 1]
  else
  Result := nil;
end;

function TG2QuickListVariant.Add(const Item: Variant): Integer;
begin
  if _Items.Length <= _ItemCount then
  _Items.SetLength(_Items.Length + 32);
  _Items[_ItemCount] := Item;
  Result := _ItemCount;
  Inc(_ItemCount);
end;

function TG2QuickListVariant.Pop: Variant;
begin
  if _ItemCount > 0 then
  begin
    Result := _Items[_ItemCount - 1];
    Delete(_ItemCount - 1);
  end
  else
  Result := nil;
end;

function TG2QuickListVariant.Insert(const Index: Integer; const Item: Variant): Integer;
  var i: Integer;
begin
  if _Items.Length <= _ItemCount then
  _Items.SetLength(_Items.Length + 32);
  if Index < _ItemCount then
  begin
    for i := _ItemCount - 1 downto Index do
    _Items[i + 1] := _Items[i];
    _Items[Index] := Item;
    Result := Index;
  end
  else
  begin
    _Items[_ItemCount] := Item;
    Result := _ItemCount;
  end;
  Inc(_ItemCount);
end;

procedure TG2QuickListVariant.Delete(const Index: Integer);
  var i: Integer;
begin
  for i := Index to _ItemCount - 2 do
  _Items[i] := _Items[i + 1];
  Dec(_ItemCount);
end;

procedure TG2QuickListVariant.Remove(const Item: Variant);
  var i: Integer;
begin
  for i := 0 to _ItemCount - 1 do
  if _Items[i] = Item then
  begin
    Delete(i);
    Exit;
  end;
end;

procedure TG2QuickListVariant.Clear;
begin
  _ItemCount := 0;
end;
//TG2QuickListVariant END

//TG2QuickListInt BEGIN
procedure TG2QuickListInt.SetItem(const Index: Integer; const Value: Integer);
begin
  _Items[Index] := Value;
end;

function TG2QuickListInt.GetItem(const Index: Integer): Integer;
begin
  Result := _Items[Index];
end;

procedure TG2QuickListInt.SetCapacity(const Value: Integer);
begin
  _Items.SetLength(Value);
end;

function TG2QuickListInt.GetCapacity: Integer;
begin
  Result := _Items.Length;
end;

function TG2QuickListInt.GetFirst: Integer;
begin
  if _ItemCount > 0 then
  Result := _Items[0]
  else
  Result := 0;
end;

function TG2QuickListInt.GetLast: Integer;
begin
  if _ItemCount > 0 then
  Result := _Items[_ItemCount - 1]
  else
  Result := 0;
end;

function TG2QuickListInt.Add(const Item: Integer): Integer;
begin
  if _Items.Length <= _ItemCount then
  _Items.SetLength(_Items.Length + 32);
  _Items[_ItemCount] := Item;
  Result := _ItemCount;
  Inc(_ItemCount);
end;

function TG2QuickListInt.Pop: Integer;
begin
  if _ItemCount > 0 then
  begin
    Result := _Items[_ItemCount - 1];
    Delete(_ItemCount - 1);
  end
  else
  Result := 0;
end;

function TG2QuickListInt.Insert(const Index: Integer; const Item: Integer): Integer;
  var i: Integer;
begin
  if _Items.Length <= _ItemCount then
  _Items.SetLength(_Items.Length + 32);
  if Index < _ItemCount then
  begin
    for i := _ItemCount - 1 downto Index do
    _Items[i + 1] := _Items[i];
    _Items[Index] := Item;
    Result := Index;
  end
  else
  begin
    _Items[_ItemCount] := Item;
    Result := _ItemCount;
  end;
  Inc(_ItemCount);
end;

procedure TG2QuickListInt.Delete(const Index: Integer);
  var i: Integer;
begin
  for i := Index to _ItemCount - 2 do
  _Items[i] := _Items[i + 1];
  Dec(_ItemCount);
end;

procedure TG2QuickListInt.Remove(const Item: Integer);
  var i: Integer;
begin
  for i := 0 to _ItemCount - 1 do
  if _Items[i] = Item then
  begin
    Delete(i);
    Exit;
  end;
end;

procedure TG2QuickListInt.Clear;
begin
  _ItemCount := 0;
end;
//TG2QuickListInt END

//TG2QuickSortList BEGIN
procedure TG2QuickSortList.SetItem(const Index: Integer; const Value: TObject);
begin
  _Items[Index].Data := Value;
end;

function TG2QuickSortList.GetItem(const Index: Integer): TObject;
begin
  Result := _Items[Index].Data;
end;

procedure TG2QuickSortList.InsertItem(const Pos: Integer; const Item: TObject; const Order: Float);
  var i: Integer;
begin
  if Length(_Items) <= _ItemCount then
  _Items.SetLength(Length(_Items) + 32);
  for i := _ItemCount downto Pos + 1 do
  begin
    _Items[i].Data := _Items[i - 1].Data;
    _Items[i].Order := _Items[i - 1].Order;
  end;
  _Items[Pos].Data := Item;
  _Items[Pos].Order := Order;
  Inc(_ItemCount);
end;

procedure TG2QuickSortList.SetCapacity(const Value: Integer);
begin
  _Items.SetLength(Value);
end;

function TG2QuickSortList.GetCapacity: Integer;
begin
  Result := Length(_Items);
end;

function TG2QuickSortList.GetFirst: TObject;
begin
  if _ItemCount > 0 then
  Result := _Items[0].Data
  else
  Result := nil;
end;

function TG2QuickSortList.GetLast: TObject;
begin
  if _ItemCount > 0 then
  Result := _Items[_ItemCount - 1].Data
  else
  Result := nil;
end;

function TG2QuickSortList.Add(const Item: TObject; const Order: Float): Integer;
  var l, h, m: Integer;
begin
  l := 0;
  h := _ItemCount - 1;
  while l <= h do
  begin
    m := (l + h) div 2;
    if _Items[m].Order - Order < 0 then
    l := m + 1 else h := m - 1;
  end;
  InsertItem(l, Item, Order);
  Result := l;
end;

function TG2QuickSortList.Add(const Item: TObject): Integer;
begin
  if Length(_Items) <= _ItemCount then
  _Items.SetLength(Length(_Items) + 32);
  _Items[_ItemCount].Data := Item;
  _Items[_ItemCount].Order := 0;
  Result := _ItemCount;
  Inc(_ItemCount);
end;

function TG2QuickSortList.Pop: TObject;
begin
  if _ItemCount > 0 then
  begin
    Result := _Items[_ItemCount - 1].Data;
    Delete(_ItemCount - 1);
  end
  else
  Result := nil;
end;

procedure TG2QuickSortList.Delete(const Index: Integer);
  var i: Integer;
begin
  for i := Index to _ItemCount - 2 do
  begin
    _Items[i].Data := _Items[i + 1].Data;
    _Items[i].Order := _Items[i + 1].Order;
  end;
  Dec(_ItemCount);
end;

procedure TG2QuickSortList.Remove(const Item: TObject);
  var i: Integer;
begin
  for i := 0 to _ItemCount - 1 do
  if _Items[i].Data = Item then
  begin
    Delete(i);
    Exit;
  end;
end;

procedure TG2QuickSortList.Clear;
begin
  _ItemCount := 0;
end;
//TG2QuickSortList END

//TG2QuickSortListVariant BEGIN
procedure TG2QuickSortListVariant.SetItem(const Index: Integer; const Value: Variant);
begin
  _Items[Index].Data := Value;
end;

function TG2QuickSortListVariant.GetItem(const Index: Integer): Variant;
begin
  Result := _Items[Index].Data;
end;

procedure TG2QuickSortListVariant.InsertItem(const Pos: Integer; const Item: Variant; const Order: Float);
  var i: Integer;
begin
  if Length(_Items) <= _ItemCount then
  _Items.SetLength(Length(_Items) + 32);
  for i := _ItemCount downto Pos + 1 do
  begin
    _Items[i].Data := _Items[i - 1].Data;
    _Items[i].Order := _Items[i - 1].Order;
  end;
  _Items[Pos].Data := Item;
  _Items[Pos].Order := Order;
  Inc(_ItemCount);
end;

procedure TG2QuickSortListVariant.SetCapacity(const Value: Integer);
begin
  _Items.SetLength(Value);
end;

function TG2QuickSortListVariant.GetCapacity: Integer;
begin
  Result := Length(_Items);
end;

function TG2QuickSortListVariant.GetFirst: Variant;
begin
  if _ItemCount > 0 then
  Result := _Items[0].Data
  else
  Result := nil;
end;

function TG2QuickSortListVariant.GetLast: Variant;
begin
  if _ItemCount > 0 then
  Result := _Items[_ItemCount - 1].Data
  else
  Result := nil;
end;

function TG2QuickSortListVariant.Add(const Item: Variant; const Order: Float): Integer;
  var l, h, m: Integer;
begin
  l := 0;
  h := _ItemCount - 1;
  while l <= h do
  begin
    m := (l + h) div 2;
    if _Items[m].Order - Order < 0 then
    l := m + 1 else h := m - 1;
  end;
  InsertItem(l, Item, Order);
  Result := l;
end;

function TG2QuickSortListVariant.Add(const Item: Variant): Integer;
begin
  if Length(_Items) <= _ItemCount then
  _Items.SetLength(Length(_Items) + 32);
  _Items[_ItemCount].Data := Item;
  _Items[_ItemCount].Order := 0;
  Result := _ItemCount;
  Inc(_ItemCount);
end;

function TG2QuickSortListVariant.Pop: Variant;
begin
  if _ItemCount > 0 then
  begin
    Result := _Items[_ItemCount - 1].Data;
    Delete(_ItemCount - 1);
  end
  else
  Result := nil;
end;

procedure TG2QuickSortListVariant.Delete(const Index: Integer);
  var i: Integer;
begin
  for i := Index to _ItemCount - 2 do
  begin
    _Items[i].Data := _Items[i + 1].Data;
    _Items[i].Order := _Items[i + 1].Order;
  end;
  Dec(_ItemCount);
end;

procedure TG2QuickSortListVariant.Remove(const Item: Variant);
  var i: Integer;
begin
  for i := 0 to _ItemCount - 1 do
  if _Items[i].Data = Item then
  begin
    Delete(i);
    Exit;
  end;
end;

procedure TG2QuickSortListVariant.Clear;
begin
  _ItemCount := 0;
end;
//TG2QuickSortListVariant END

//TG2QuickSortListInt BEGIN
procedure TG2QuickSortListInt.SetItem(const Index: Integer; const Value: Integer);
begin
  _Items[Index].Data := Value;
end;

function TG2QuickSortListInt.GetItem(const Index: Integer): Integer;
begin
  Result := _Items[Index].Data;
end;

procedure TG2QuickSortListInt.InsertItem(const Pos: Integer; const Item: Integer; const Order: Float);
  var i: Integer;
begin
  if Length(_Items) <= _ItemCount then
  _Items.SetLength(Length(_Items) + 32);
  for i := _ItemCount downto Pos + 1 do
  begin
    _Items[i].Data := _Items[i - 1].Data;
    _Items[i].Order := _Items[i - 1].Order;
  end;
  _Items[Pos].Data := Item;
  _Items[Pos].Order := Order;
  Inc(_ItemCount);
end;

procedure TG2QuickSortListInt.SetCapacity(const Value: Integer);
begin
  _Items.SetLength(Value);
end;

function TG2QuickSortListInt.GetCapacity: Integer;
begin
  Result := Length(_Items);
end;

function TG2QuickSortListInt.GetFirst: Integer;
begin
  if _ItemCount > 0 then
  Result := _Items[0].Data
  else
  Result := 0;
end;

function TG2QuickSortListInt.GetLast: Integer;
begin
  if _ItemCount > 0 then
  Result := _Items[_ItemCount - 1].Data
  else
  Result := 0;
end;

function TG2QuickSortListInt.Add(const Item: Integer; const Order: Float): Integer;
  var l, h, m: Integer;
begin
  l := 0;
  h := _ItemCount - 1;
  while l <= h do
  begin
    m := (l + h) div 2;
    if _Items[m].Order - Order < 0 then
    l := m + 1 else h := m - 1;
  end;
  InsertItem(l, Item, Order);
  Result := l;
end;

function TG2QuickSortListInt.Add(const Item: Integer): Integer;
begin
  if Length(_Items) <= _ItemCount then
  _Items.SetLength(Length(_Items) + 32);
  _Items[_ItemCount].Data := Item;
  _Items[_ItemCount].Order := 0;
  Result := _ItemCount;
  Inc(_ItemCount);
end;

function TG2QuickSortListInt.Pop: Integer;
begin
  if _ItemCount > 0 then
  begin
    Result := _Items[_ItemCount - 1].Data;
    Delete(_ItemCount - 1);
  end
  else
  Result := 0;
end;

procedure TG2QuickSortListInt.Delete(const Index: Integer);
  var i: Integer;
begin
  for i := Index to _ItemCount - 2 do
  begin
    _Items[i].Data := _Items[i + 1].Data;
    _Items[i].Order := _Items[i + 1].Order;
  end;
  Dec(_ItemCount);
end;

procedure TG2QuickSortListInt.Remove(const Item: Integer);
  var i: Integer;
begin
  for i := 0 to _ItemCount - 1 do
  if _Items[i].Data = Item then
  begin
    Delete(i);
    Exit;
  end;
end;

procedure TG2QuickSortListInt.Clear;
begin
  _ItemCount := 0;
end;
//TG2QuickSortListInt END

//TG2Resource BEGIN
procedure TG2Resource.SetParent(const Value: TG2Resource);
begin
  if Value = _Parent then Exit;
  if _Parent <> nil then
  _Parent.Resources.Remove(Self);
  _Parent := Value;
  if _Parent <> nil then
  _Parent.Resources.Add(Self);
end;

constructor TG2Resource.Create;
begin
  inherited Create;
  _Parent := nil;
end;

destructor TG2Resource.Destroy;
begin
  while Resources.Count > 0 do
  TObject(Resources.Pop).Free;
  Parent := nil;
  inherited Destroy;
end;
//TG2Resource END

//TG2ResourceAsync BEGIN
constructor TG2ResourceAsync.Create;
begin
  inherited Create;
  _State := asIdle;
end;
//TG2ResourceAsync END

function G2StrExplode(const Str: String; const Separator: String): TG2StrArr;
  var Arr: Variant;
  var i, n: Integer;
begin
  asm @Arr = (@Str).split(@Separator); @n = (@Arr).length; end;
  Result.SetLength(n);
  for i := 0 to n - 1 do
  asm @Result[@i] = @Arr[@i]; end;
end;

function G2Char(const n: Integer): String;
begin
  asm
    (@Result) = String.fromCharCode(@n);
  end;
end;

function G2Random(const n: Integer): Integer;
begin
  Result := Trunc(Random * 0.99999 * n);
end;

function G2Time: Integer;
begin
  asm
    @Result = new Date().getTime();
  end;
end;

function G2PiTime(Amp: Single = 1000): Single;
begin
  Result := (G2Time mod Round(TwoPi * Amp)) / (Amp);
end;

function G2PiTime(Amp: Single; Time: Integer): Single;
begin
  Result := (Time mod Round(TwoPi * Amp)) / (Amp);
end;

function G2TimeInterval(Interval: Integer = 1000): Single;
begin
  Result := (G2Time mod Interval) / Interval;
end;

function G2TimeInterval(Interval: Integer; Time: Integer): Single;
begin
  Result := (Time mod Interval) / Interval;
end;

function G2RandomPi: Single;
begin
  Result := Random * Pi;
end;

function G2Random2Pi: Single;
begin
  Result := Random * TwoPi;
end;

function G2RandomCirclePoint: TG2Vec2;
  var a, s, c: Single;
begin
  a := G2Random2Pi;
  G2SinCos(a, s, c);
  Result.x := c;
  Result.y := s;
end;

function G2RandomSpherePoint: TG2Vec3;
  var a1, a2, s1, s2, c1, c2: Single;
begin
  a1 := G2Random2Pi;
  a2 := G2Random2Pi;
  G2SinCos(a1, s1, c1);
  G2SinCos(a2, s2, c2);
  Result.SetValue(c1 * c2, s2, s1 * c2);
end;

end.
