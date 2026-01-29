unit G2Utils;
{$include Gen2MP.inc}
interface

{$if defined(G2Target_iOS)}
  {$modeswitch objectivec1}
{$endif}

uses
  G2Types,
  {$if defined(G2Target_Windows)}
  Windows,
  {$elseif defined(G2Target_iOS)}
  iPhoneAll,
  {$endif}
  Classes,
  SysUtils,
  G2Math;

type
  TG2Group = class;
  TG2GroupItem = class;

  TG2PointArr = array of TPoint;
  TG2RectArr = array of TRect;

{$ifdef CPU64}
  TG2DynLib = QWord;
{$else}
  TG2DynLib = LongWord;
{$endif}

  TG2MD5 = object
    var b: array[0..15] of Byte;
    procedure Clear;
    procedure SetValue(const Value: PByte; const Count: TG2IntS32); overload;
    procedure SetValue(const Value: AnsiString); overload;
    function ToStringA: AnsiString;
  end;
  PG2MD5 = ^TG2MD5;

  generic TG2QuickListG<T> = object
  public
    type TItemPtr = ^T;
    type TCmpFunc = function (const Item0, Item1: T): TG2IntS32;
    type TCmpFuncObj = function (const Item0, Item1: T): TG2IntS32 of object;
  private
    var _Items: array of T;
    var _ItemCount: TG2IntS32;
    procedure SetItem(const Index: TG2IntS32; const Value: T); inline;
    function GetItem(const Index: TG2IntS32): T; inline;
    procedure SetCapacity(const Value: TG2IntS32); inline;
    function GetCapacity: TG2IntS32; inline;
    function GetFirst: T; inline;
    function GetLast: T; inline;
    function GetData: TItemPtr; inline;
  public
    property Capacity: TG2IntS32 read GetCapacity write SetCapacity;
    property Count: TG2IntS32 read _ItemCount;
    property Items[const Index: TG2IntS32]: T read GetItem write SetItem; default;
    property First: T read GetFirst;
    property Last: T read GetLast;
    property Data: TItemPtr read GetData;
    function Find(const Item: T): TG2IntS32;
    function Add(const Item: T): TG2IntS32;
    function Pop: T;
    function Extract(const Index: TG2IntS32): T;
    function Insert(const Index: TG2IntS32; const Item: T): TG2IntS32;
    procedure Delete(const Index: TG2IntS32; const ItemCount: TG2IntS32 = 1);
    procedure Remove(const Item: T);
    procedure Clear;
    procedure Allocate(const Amount: TG2IntS32);
    procedure Allocate(const Amount: TG2IntS32; const DefaultValue: T);
    function Search(const CmpFunc: TCmpFunc; const Item: T): TG2IntS32; overload;
    function Search(const CmpFunc: TCmpFuncObj; const Item: T): TG2IntS32; overload;
    procedure Sort(const CmpFunc: TCmpFunc; RangeStart, RangeEnd: TG2IntS32); overload;
    procedure Sort(const CmpFunc: TCmpFuncObj; RangeStart, RangeEnd: TG2IntS32); overload;
    procedure Sort(const CmpFunc: TCmpFunc); overload;
    procedure Sort(const CmpFunc: TCmpFuncObj); overload;
  end;

  generic TG2QuickSortListG<T> = object
  public
    type TItem = record
      Data: T;
      Order: TG2Float;
    end;
  private
    _Items: array of TItem;
    var _ItemCount: TG2IntS32;
    procedure SetItem(const Index: TG2IntS32; const Value: T); inline;
    function GetItem(const Index: TG2IntS32): T; inline;
    procedure InsertItem(const Pos: TG2IntS32; const Item: T; const Order: TG2Float); inline;
    procedure SetCapacity(const Value: TG2IntS32); inline;
    function GetCapacity: TG2IntS32; inline;
    function GetFirst: T; inline;
    function GetLast: T; inline;
  public
    property Capacity: TG2IntS32 read GetCapacity write SetCapacity;
    property Count: TG2IntS32 read _ItemCount;
    property Items[const Index: TG2IntS32]: T read GetItem write SetItem; default;
    property First: T read GetFirst;
    property Last: T read GetLast;
    function Add(const Item: T; const Order: TG2Float): TG2IntS32; overload;
    function Add(const Item: T): TG2IntS32; overload;
    function Pop: T;
    procedure Delete(const Index: TG2IntS32);
    procedure Remove(const Item: T);
    procedure Clear;
  end;

  generic TG2Array<T> = object
  public
    type TItemPtr = ^T;
    type TCmpFunc = function (const Item0, Item1: T): TG2IntS32;
    type TCmpFuncObj = function (const Item0, Item1: T): TG2IntS32 of object;
  private
    var _Items: array of T;
    var _ItemCount: TG2IntS32;
    procedure SetItem(const Index: TG2IntS32; const Value: TItemPtr); inline;
    function GetItem(const Index: TG2IntS32): TItemPtr; inline;
    procedure SetCapacity(const Value: TG2IntS32); inline;
    function GetCapacity: TG2IntS32; inline;
    function GetData: TItemPtr; inline;
  public
    property Capacity: TG2IntS32 read GetCapacity write SetCapacity;
    property Count: TG2IntS32 read _ItemCount;
    property Items[const Index: TG2IntS32]: TItemPtr read GetItem write SetItem; default;
    property Data: TItemPtr read GetData;
    function Add(const Item: T): TG2IntS32;
    function Insert(const Index: TG2IntS32; const Item: T): TG2IntS32;
    procedure Delete(const Index: TG2IntS32; const ItemCount: TG2IntS32 = 1);
    procedure Clear;
    procedure Allocate(const Amount: TG2IntS32);
    procedure Allocate(const Amount: TG2IntS32; const DefaultValue: T);
    procedure Sort(const CmpFunc: TCmpFunc; RangeStart, RangeEnd: TG2IntS32); overload;
    procedure Sort(const CmpFunc: TCmpFuncObj; RangeStart, RangeEnd: TG2IntS32); overload;
    procedure Sort(const CmpFunc: TCmpFunc); overload;
    procedure Sort(const CmpFunc: TCmpFuncObj); overload;
  end;

  TG2QuickList = specialize TG2QuickListG<Pointer>;
  PG2QuickList = ^TG2QuickList;
  TG2QuickListIntU16 = specialize TG2QuickListG<TG2IntU16>;
  PG2QuickListIntU16 = ^TG2QuickListIntU16;
  TG2QuickListIntS32 = specialize TG2QuickListG<TG2IntS32>;
  PG2QuickListIntS32 = ^TG2QuickListIntS32;
  TG2QuickListFloat = specialize TG2QuickListG<TG2Float>;
  PG2QuickListFloat = ^TG2QuickListFloat;
  TG2QuickListAnsiString = specialize TG2QuickListG<AnsiString>;
  PG2QuickListAnsiString = ^TG2QuickListAnsiString;
  TG2QuickListString = specialize TG2QuickListG<String>;
  PG2QuickListString = ^TG2QuickListString;
  TG2QuickListColor = specialize TG2QuickListG<TG2Color>;
  PG2QuickListColor = ^TG2QuickListColor;
  TG2QuickListVec2 = specialize TG2QuickListG<TG2Vec2>;
  PG2QuickListVec2 = ^TG2QuickListVec2;
  TG2QuickListVec3 = specialize TG2QuickListG<TG2Vec3>;
  PG2QuickListVec3 = ^TG2QuickListVec3;
  TG2QuickListVec4 = specialize TG2QuickListG<TG2Vec4>;
  PG2QuickListVec4 = ^TG2QuickListVec4;
  TG2QuickListPoint = specialize TG2QuickListG<TPoint>;
  PG2QuickListPoint = ^TG2QuickListPoint;
  TG2QuickSortList = specialize TG2QuickSortListG<Pointer>;
  PG2QuickSortList = ^TG2QuickSortList;
  TG2QuickSortListIntU16 = specialize TG2QuickSortListG<TG2IntU16>;
  PG2QuickSortListIntU16 = ^TG2QuickSortListIntU16;
  TG2QuickSortListIntS32 = specialize TG2QuickSortListG<TG2IntS32>;
  PG2QuickSortListIntS32 = ^TG2QuickSortListIntS32;
  TG2QuickSortListAnsiString = specialize TG2QuickSortListG<AnsiString>;
  PG2QuickSortListAnsiString = ^TG2QuickSortListAnsiString;
  TG2QuickSortListColor = specialize TG2QuickSortListG<TG2Color>;
  PG2QuickSortListColor = ^TG2QuickSortListColor;
  TG2QuickSortListVec2 = specialize TG2QuickSortListG<TG2Vec2>;
  PG2QuickSortListVec2 = ^TG2QuickSortListVec2;
  TG2QuickSortListVec3 = specialize TG2QuickSortListG<TG2Vec3>;
  PG2QuickSortListVec3 = ^TG2QuickSortListVec3;
  TG2QuickSortListVec4 = specialize TG2QuickSortListG<TG2Vec4>;
  PG2QuickSortListVec4 = ^TG2QuickSortListVec4;
  TG2QuickSortListPoint = specialize TG2QuickSortListG<TPoint>;
  PG2QuickSortListPoint = ^TG2QuickSortListPoint;

  TG2Group = class
  private
    var _List: TG2QuickList;
    var _ListRemove: TG2QuickList;
    var _ListAdd: TG2QuickList;
    var _Updating: Boolean;
    function GetItem(const Index: TG2IntS32): TG2GroupItem; inline;
    procedure SetItem(const Index: TG2IntS32; const Value: TG2GroupItem); inline;
    function GetCount: TG2IntS32; inline;
  public
    constructor Create;
    destructor Destroy; override;
    property Items[const Index: TG2IntS32]: TG2GroupItem read GetItem write SetItem; default;
    property Count: TG2IntS32 read GetCount;
    procedure Render(const Pass: TG2IntS32 = 0);
    procedure Update;
    procedure Add(const Item: TG2GroupItem);
    procedure Remove(const Item: TG2GroupItem);
    procedure Delete(const Index: TG2IntS32);
    procedure FreeItems;
  end;

  TG2GroupItem = class
  private
    var _Group: TG2Group;
    var _Dead: Boolean;
    var _Sort: TG2Float;
    procedure SetSort(const Value: TG2Float); inline;
  protected
    procedure Initialize; virtual;
    procedure Finalize; virtual;
  public
    constructor Create(const G2Group: TG2Group);
    destructor Destroy; override;
    property Dead: Boolean read _Dead write _Dead;
    property Sort: TG2Float read _Sort write SetSort;
    property Group: TG2Group read _Group write _Group;
    procedure Render(const Pass: TG2IntS32 = 0); virtual;
    procedure Update; virtual;
    procedure Die; inline;
  end;

  CG2GroupItem = class of TG2GroupItem;

  TG2TokenType = (ttEOF, ttError, ttSymbol, ttWord, ttKeyword, ttString, ttNumber);

  TG2Parser = class
  private
    var _Position: TG2IntS32;
    var _Text: array of AnsiChar;
    var _Comment: array of array[0..1] of AnsiString;
    var _CommentLine: array of AnsiString;
    var _String: array of AnsiString;
    var _Symbols: array of AnsiString;
    var _KeyWords: array of AnsiString;
    var _CaseSensitive: Boolean;
    var _Line: TG2IntS32;
    function GetComment(const Index: TG2IntS32): AnsiString; inline;
    function GetCommentCount: TG2IntS32; inline;
    function GetCommentLine(const Index: TG2IntS32): AnsiString; inline;
    function GetCommentLineCount: TG2IntS32; inline;
    function GetKeyWord(const Index: TG2IntS32): AnsiString; inline;
    function GetKeyWordCount: TG2IntS32; inline;
    function GetString(const Index: TG2IntS32): AnsiString; inline;
    function GetStringCount: TG2IntS32; inline;
    function GetSymbol(const Index: TG2IntS32): AnsiString; inline;
    function GetSymbolCount: TG2IntS32; inline;
    function GetText: AnsiString; inline;
    function GetLen: TG2IntS32; inline;
  public
    property Text: AnsiString read GetText;
    property Len: TG2IntS32 read GetLen;
    property Position: TG2IntS32 read _Position write _Position;
    property Line: TG2IntS32 read _Line;
    property CommentCount: TG2IntS32 read GetCommentCount;
    property Comments[const Index: TG2IntS32]: AnsiString read GetComment;
    property CommnetLineCount: TG2IntS32 read GetCommentLineCount;
    property CommentLines[const Index: TG2IntS32]: AnsiString read GetCommentLine;
    property StringCount: TG2IntS32 read GetStringCount;
    property Strings[const Index: TG2IntS32]: AnsiString read GetString;
    property SymbolCount: TG2IntS32 read GetSymbolCount;
    property Symbols[const Index: TG2IntS32]: AnsiString read GetSymbol;
    property KeyWordCount: TG2IntS32 read GetKeyWordCount;
    property KeyWords[const Index: TG2IntS32]: AnsiString read GetKeyWord;
    constructor Create; virtual;
    constructor Create(const ParseText: AnsiString; const CaseSensitive: Boolean = False); virtual;
    destructor Destroy; override;
    procedure Parse(const ParseText: AnsiString; const CaseSensitive: Boolean = False);
    procedure AddComment(const CommentStart, CommentEnd: AnsiString);
    procedure AddCommentLine(const CommentLine: AnsiString);
    procedure AddString(const StringStartEnd: AnsiString);
    procedure AddSymbol(const Symbol: AnsiString);
    procedure AddKeyWord(const KeyWord: AnsiString);
    procedure SkipSpaces;
    function Read(const Count: TG2IntS32): AnsiString; overload;
    function Read(const Pos: TG2IntS32; const Count: TG2IntS32): AnsiString; overload;
    function IsAtSymbol: TG2IntS32;
    function IsAtKeyword: TG2IntS32;
    function IsAtCommentLine: TG2IntS32;
    function IsAtCommentStart: TG2IntS32;
    function IsAtCommentEnd: TG2IntS32;
    function IsAtString: TG2IntS32;
    function IsAtEOF: Boolean;
    function NextToken(var TokenType: TG2TokenType): AnsiString;
  end;

  PG2MLObject = ^TG2MLObject;
  TG2QuickListG2ML = specialize TG2QuickListG<PG2MLObject>;
  TG2MLDataType = (dtNone, dtInt, dtFloat, dtString, dtData);

//TG2MLObject BEGIN
  TG2MLObject = object
  public
    var Name: AnsiString;
    var Parent: PG2MLObject;
    var Children: TG2QuickListG2ML;
    var DataType: TG2MLDataType;
    var Data: Pointer;
    var DataSize: Integer;
    function FindNode(const NodeName: AnsiString): PG2MLObject;
    function AsInt: TG2IntS32;
    function AsFloat: TG2Float;
    function AsString: AnsiString;
    function AsBool: Boolean;
    procedure Clear; inline;
  end;
//TG2MLObject END

//TG2ML BEGIN
  TG2ML = class
  private
    var _Parser: TG2Parser;
  public
    constructor Create;
    destructor Destroy; override;
    function Read(const Data: AnsiString): PG2MLObject;
    procedure FreeObject(var G2MLObject: PG2MLObject);
  end;
//TG2ML END

//TG2MLWriter BEGIN
  TG2MLWriter = class
  private
    var _Data: AnsiString;
    var _Nest: Integer;
    var _Compact: Boolean;
    procedure WriteSpaces(const Count: Integer);
    procedure WriteReturn;
  public
    property G2ML: AnsiString read _Data;
    property Compact: Boolean read _Compact write _Compact;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure NodeOpen(const NodeName: AnsiString);
    procedure NodeClose;
    procedure NodeValue(const NodeName: AnsiString; const Value: AnsiString); overload;
    procedure NodeValue(const NodeName: AnsiString; const Value: TG2IntS32); overload;
    procedure NodeValue(const NodeName: AnsiString; const Value: TG2Float); overload;
    procedure NodeValue(const NodeName: AnsiString; const Value: Boolean); overload;
  end;
//TG2MLWriter END

//TG2XMLNode BEGIN
  TG2XMLNode = class
  public
    type TAttribute = object
      Name: AnsiString;
      Value: AnsiString;
      function AsInt: TG2IntS32;
      function AsFloat: TG2Float;
    end;
    type PAttribute = ^TAttribute;
  private
    var _Parent: TG2XMLNode;
    var _Sibling: TG2XMLNode;
    var _Child: TG2XMLNode;
    var _Name: AnsiString;
    var _Data: AnsiString;
    var _Attributes: array of TAttribute;
    procedure SetParent(const Value: TG2XMLNode); inline;
    procedure SetSibling(const Value: TG2XMLNode); inline;
    procedure SetChild(const Value: TG2XMLNode); inline;
    procedure SetName(const Value: AnsiString); inline;
    procedure SetData(const Value: AnsiString); inline;
    procedure AddChild(const Node: TG2XMLNode);
    function GetXML: AnsiString;
    procedure SetXML(const Value: AnsiString);
    function GetAttribute(const Index: TG2IntS32): PAttribute; inline;
    function GetAttributeCount: TG2IntS32; inline;
  public
    property Parent: TG2XMLNode read _Parent;
    property Sibling: TG2XMLNode read _Sibling;
    property Child: TG2XMLNode read _Child;
    property Name: AnsiString read _Name;
    property Data: AnsiString read _Data;
    property XML: AnsiString read GetXML write SetXML;
    property Attribute[const Index: TG2IntS32]: PAttribute read GetAttribute;
    property AttributeCount: TG2IntS32 read GetAttributeCount;
    constructor Create;
    destructor Destroy; override;
    procedure AddAttribute(const AttribName, AttribValue: AnsiString);
    procedure AddData(const Value: AnsiString);
    function AsInt: TG2IntS32;
    function AsFloat: TG2Float;
    function FindChildByName(const ChildName: AnsiString): TG2XMLNode;
    function FindNodeByName(const NodeName: AnsiString): TG2XMLNode;
    function FindAttribute(const AttribName: AnsiString): PAttribute;
  end;
//TG2XMLNode END

  TG2AtlasPlacement = record
    Page: TG2IntS32;
    x: TG2IntS32;
    y: TG2IntS32;
  end;
  TG2AtlasPlacementArr = array of TG2AtlasPlacement;

  operator = (md5a, md5b: TG2MD5) r: Boolean;

  function G2MD5(const Value: PG2IntU8; const Count: TG2IntU32): TG2MD5; overload;
  function G2MD5(const Value: AnsiString): TG2MD5; overload;
  function G2CRC16(const Value: Pointer; const Count: TG2IntS32): TG2IntU16;
  function G2CRC32(const Value: Pointer; const Count: TG2IntS32): TG2IntU32;
  function G2Adler32(const Adler: TG2IntU32; const Buffer: Pointer; const Len: TG2IntU32): TG2IntU32;

  function G2FileSearch(const Path: String; const Attribs: TG2IntS32): TG2QuickListAnsiString;
  function G2PathRelative(const Origin: String; const Target: String): String;
  function G2PathNoExt(const Path: String): String;
  function G2PathClean(const Path: String): String;
  function G2RemoveDir(const DirPath: String): Boolean;

  function G2StrCut(const Str: AnsiString; const SubStart, SubEnd: TG2IntS32): AnsiString;
  function G2StrExplode(const Str: AnsiString; const Separator: AnsiString): TG2StrArrA;
  function G2StrParam(const Str: AnsiString; const Separator: AnsiString; const Param: TG2IntS32): AnsiString;
  function G2StrParamCount(const Str: AnsiString; const Separator: AnsiString): TG2IntS32;
  function G2StrInStr(const Str: AnsiString; SubStr: AnsiString): TG2IntS32;
  function G2StrReplace(const Str, PatternOld, PatternNew: AnsiString): AnsiString;
  function G2StrTrim(const Str: AnsiString): AnsiString;
  function G2StrSubstitute(const Str: AnsiString; const Start, ReplaceCount: TG2IntS32; const ReplaceStr: AnsiString): AnsiString;
  procedure G2EncDec(const Ptr: PG2IntU8Arr; const Count: TG2IntS32; const Key: AnsiString);
  function G2CmpObjFuncPtr(const Ptr0, Ptr1: Pointer): Boolean;

{$if defined(G2Target_iOS)}
  function G2NSStr(const a: AnsiString): NSString;
{$endif}

  function G2MemAlloc(const Size: TG2IntU32): Pointer; inline;
  procedure G2MemFree(var Mem: Pointer; const Size: TG2IntU32); inline;

  function G2DynLibOpen(const Name: AnsiString): TG2DynLib;
  procedure G2DynLibClose(const Handle: TG2DynLib);
  function G2DynLibAddress(const Handle: TG2DynLib; const Name: AnsiString): Pointer;

implementation

//TMD5 BEGIN
procedure TG2MD5.Clear;
begin
  FillChar(b, SizeOf(b), 0);
end;

procedure TG2MD5.SetValue(const Value: PByte; const Count: TG2IntS32);
begin
  Self := G2MD5(Value, Count);
end;

procedure TG2MD5.SetValue(const Value: AnsiString);
begin
  Self := G2MD5(Value);
end;

function TG2MD5.ToStringA: AnsiString;
  var i: TG2IntS32;
  const HexArr: array[0..15] of AnsiChar = (
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
  );
begin
  SetLength(Result, 32);
  for i := 0 to 15 do
  begin
    Result[i * 2 + 1] := HexArr[(b[i] shr 4) and $0f];
    Result[i * 2 + 2] := HexArr[b[i] and $0f];
  end;
end;
//TMD5 END

//TG2QuickListG BEGIN
{$Hints off}
procedure TG2QuickListG.SetItem(const Index: TG2IntS32; const Value: T);
begin
  _Items[Index] := Value;
end;

function TG2QuickListG.GetItem(const Index: TG2IntS32): T;
begin
  Result := _Items[Index];
end;

procedure TG2QuickListG.SetCapacity(const Value: TG2IntS32);
begin
  SetLength(_Items, Value);
end;

function TG2QuickListG.GetCapacity: TG2IntS32;
begin
  Result := Length(_Items);
end;

function TG2QuickListG.GetFirst: T;
begin
  if _ItemCount > 0 then Result := _Items[0];
end;

function TG2QuickListG.GetLast: T;
begin
  Result := _Items[_ItemCount - 1];
end;

function TG2QuickListG.GetData: TItemPtr;
begin
  if _ItemCount > 0 then
  Result := @_Items[0]
  else
  Result := nil;
end;

function TG2QuickListG.Find(const Item: T): TG2IntS32;
  var i: TG2IntS32;
begin
  for i := 0 to _ItemCount - 1 do
  if _Items[i] = Item then
  begin
    Result := i;
    Exit;
  end;
  Result := -1;
end;

function TG2QuickListG.Add(const Item: T): TG2IntS32;
begin
  if Length(_Items) <= _ItemCount then
  SetLength(_Items, Length(_Items) + 256);
  _Items[_ItemCount] := Item;
  Result := _ItemCount;
  Inc(_ItemCount);
end;

function TG2QuickListG.Pop: T;
begin
  if _ItemCount > 0 then Result := Extract(_ItemCount - 1);
end;

function TG2QuickListG.Extract(const Index: TG2IntS32): T;
begin
  Result := _Items[Index];
  Delete(Index);
end;

function TG2QuickListG.Insert(const Index: TG2IntS32; const Item: T): TG2IntS32;
  var i: TG2IntS32;
begin
  if Length(_Items) <= _ItemCount then
  SetLength(_Items, Length(_Items) + 256);
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

procedure TG2QuickListG.Delete(const Index: TG2IntS32; const ItemCount: TG2IntS32);
  var i: TG2IntS32;
begin
  for i := Index to _ItemCount - (1 + ItemCount) do
  _Items[i] := _Items[i + ItemCount];
  Dec(_ItemCount, ItemCount);
end;

procedure TG2QuickListG.Remove(const Item: T);
  var i: TG2IntS32;
begin
  i := Find(Item);
  if i > -1 then
  Delete(i);
end;

procedure TG2QuickListG.Clear;
begin
  _ItemCount := 0;
end;

procedure TG2QuickListG.Allocate(const Amount: TG2IntS32);
begin
  SetCapacity(_ItemCount + Amount);
  _ItemCount += Amount;
end;

procedure TG2QuickListG.Allocate(const Amount: TG2IntS32; const DefaultValue: T);
  var i, j: Integer;
begin
  j := _ItemCount;
  Allocate(Amount);
  for i := j to _ItemCount - 1 do
  _Items[i] := DefaultValue;
end;

function TG2QuickListG.Search(const CmpFunc: TCmpFunc; const Item: T): TG2IntS32;
  var l, h, m, r: TG2IntS32;
begin
  l := 0;
  h := _ItemCount - 1;
  while l <= h do
  begin
    m := (l + h) shr 1;
    r := CmpFunc(_Items[m], Item);
    if r = 0 then Exit(m)
    else if r < 0 then l := m + 1
    else h := m - 1;
  end;
  if (l < _ItemCount) and (CmpFunc(_Items[l], Item) = 0) then Exit(l) else Exit(-1);
end;

function TG2QuickListG.Search(const CmpFunc: TCmpFuncObj; const Item: T): TG2IntS32;
  var l, h, m, r: TG2IntS32;
begin
  l := 0;
  h := _ItemCount - 1;
  while l <= h do
  begin
    m := (l + h) shr 1;
    r := CmpFunc(_Items[m], Item);
    if r = 0 then Exit(m)
    else if r < 0 then l := m + 1
    else h := m - 1;
  end;
  if (l < _ItemCount) and (CmpFunc(_Items[l], Item) = 0) then Exit(l) else Exit(-1);
end;

procedure TG2QuickListG.Sort(
  const CmpFunc: TCmpFunc;
  RangeStart, RangeEnd: TG2IntS32
);
  var i, j : LongInt;
  var tmp, pivot: T;
begin
  if RangeEnd < RangeStart then Exit;
  i := RangeStart;
  j := RangeEnd;
  if i >= j then Exit;
  pivot := _Items[(RangeStart + RangeEnd) shr 1];
  repeat
    while CmpFunc(pivot, _Items[i]) > 0 do i := i + 1;
    while CmpFunc(pivot, _Items[j]) < 0 do j := j - 1;
    if i <= j then
    begin
      tmp := _Items[i];
      _Items[i] := _Items[j];
      _Items[j] := tmp;
      j := j - 1;
      i := i + 1;
    end;
  until i > j;
  if RangeStart < j then Sort(CmpFunc, RangeStart, j);
  if i < RangeEnd then Sort(CmpFunc, i, RangeEnd);
end;

procedure TG2QuickListG.Sort(
  const CmpFunc: TCmpFuncObj;
  RangeStart, RangeEnd: TG2IntS32
);
  var i, j : LongInt;
  var tmp, pivot: T;
begin
  i := RangeStart;
  j := RangeEnd;
  if i >= j then Exit;
  pivot := _Items[(RangeStart + RangeEnd) shr 1];
  repeat
    while CmpFunc(pivot, _Items[i]) > 0 do i := i + 1;
    while CmpFunc(pivot, _Items[j]) < 0 do j := j - 1;
    if i <= j then
    begin
      tmp := _Items[i];
      _Items[i] := _Items[j];
      _Items[j] := tmp;
      j := j - 1;
      i := i + 1;
    end;
  until i > j;
  if RangeStart < j then Sort(CmpFunc, RangeStart, j);
  if i < RangeEnd then Sort(CmpFunc, i, RangeEnd);
end;

procedure TG2QuickListG.Sort(const CmpFunc: TCmpFunc);
begin
  Sort(CmpFunc, 0, _ItemCount - 1);
end;

procedure TG2QuickListG.Sort(const CmpFunc: TCmpFuncObj);
begin
  Sort(CmpFunc, 0, _ItemCount - 1);
end;
{$Hints on}
//TG2QuickListG END

//TG2QuickSortListG BEGIN
{$Hints off}
procedure TG2QuickSortListG.SetItem(const Index: TG2IntS32; const Value: T);
begin
  _Items[Index].Data := Value;
end;

function TG2QuickSortListG.GetItem(const Index: TG2IntS32): T;
begin
  Result := _Items[Index].Data;
end;

procedure TG2QuickSortListG.InsertItem(const Pos: TG2IntS32; const Item: T; const Order: TG2Float);
  var i: TG2IntS32;
begin
  if Length(_Items) <= _ItemCount then
  SetLength(_Items, Length(_Items) + 32);
  for i := _ItemCount downto Pos + 1 do
  begin
    _Items[i].Data := _Items[i - 1].Data;
    _Items[i].Order := _Items[i - 1].Order;
  end;
  _Items[Pos].Data := Item;
  _Items[Pos].Order := Order;
  Inc(_ItemCount);
end;

procedure TG2QuickSortListG.SetCapacity(const Value: TG2IntS32);
begin
  SetLength(_Items, Value);
end;

function TG2QuickSortListG.GetCapacity: TG2IntS32;
begin
  Result := Length(_Items);
end;

function TG2QuickSortListG.GetFirst: T;
begin
  Result := _Items[0].Data;
end;

function TG2QuickSortListG.GetLast: T;
begin
  Result := _Items[_ItemCount - 1].Data;
end;

function TG2QuickSortListG.Add(const Item: T; const Order: TG2Float): TG2IntS32;
  var l, h, m: TG2IntS32;
begin
  l := 0;
  h := _ItemCount - 1;
  while l <= h do
  begin
    m := (l + h) shr 1;
    if _Items[m].Order - Order < 0 then
    l := m + 1 else h := m - 1;
  end;
  InsertItem(l, Item, Order);
  Result := l;
end;

function TG2QuickSortListG.Add(const Item: T): TG2IntS32;
begin
  if Length(_Items) <= _ItemCount then
  SetLength(_Items, Length(_Items) + 32);
  _Items[_ItemCount].Data := Item;
  _Items[_ItemCount].Order := 0;
  Result := _ItemCount;
  Inc(_ItemCount);
end;

function TG2QuickSortListG.Pop: T;
begin
  Result := _Items[_ItemCount - 1].Data;
  Delete(_ItemCount - 1);
end;

procedure TG2QuickSortListG.Delete(const Index: TG2IntS32);
  var i: TG2IntS32;
begin
  for i := Index to _ItemCount - 2 do
  begin
    _Items[i].Data := _Items[i + 1].Data;
    _Items[i].Order := _Items[i + 1].Order;
  end;
  Dec(_ItemCount);
end;

procedure TG2QuickSortListG.Remove(const Item: T);
  var i: TG2IntS32;
begin
  for i := 0 to _ItemCount - 1 do
  if _Items[i].Data = Item then
  begin
    Delete(i);
    Exit;
  end;
end;

procedure TG2QuickSortListG.Clear;
begin
  _ItemCount := 0;
end;
{$Hints on}
//TG2QuickSortListG END

//TG2Array BEGIN
procedure TG2Array.SetItem(const Index: TG2IntS32; const Value: TItemPtr);
begin
  _Items[Index] := Value^;
end;

function TG2Array.GetItem(const Index: TG2IntS32): TItemPtr;
begin
  Result := @_Items[Index];
end;

procedure TG2Array.SetCapacity(const Value: TG2IntS32);
begin
  SetLength(_Items, Value);
end;

function TG2Array.GetCapacity: TG2IntS32;
begin
  Result := Length(_Items);
end;

function TG2Array.GetData: TItemPtr;
begin
  Result := @_Items[0];
end;

function TG2Array.Add(const Item: T): TG2IntS32;
begin
  if Length(_Items) <= _ItemCount then
  SetLength(_Items, Length(_Items) + 256);
  _Items[_ItemCount] := Item;
  Result := _ItemCount;
  Inc(_ItemCount);
end;

function TG2Array.Insert(const Index: TG2IntS32; const Item: T): TG2IntS32;
  var i: TG2IntS32;
begin
  if Length(_Items) <= _ItemCount then
  SetLength(_Items, Length(_Items) + 256);
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

procedure TG2Array.Delete(const Index: TG2IntS32; const ItemCount: TG2IntS32);
var i: TG2IntS32;
begin
  for i := Index to _ItemCount - (1 + ItemCount) do
  _Items[i] := _Items[i + ItemCount];
  Dec(_ItemCount, ItemCount);
end;

procedure TG2Array.Clear;
begin
  _ItemCount := 0;
end;

procedure TG2Array.Allocate(const Amount: TG2IntS32);
begin
  SetCapacity(_ItemCount + Amount);
  _ItemCount += Amount;
end;

procedure TG2Array.Allocate(const Amount: TG2IntS32; const DefaultValue: T);
  var i, j: Integer;
begin
  j := _ItemCount;
  Allocate(Amount);
  for i := j to _ItemCount - 1 do
  _Items[i] := DefaultValue;
end;

procedure TG2Array.Sort(const CmpFunc: TCmpFunc; RangeStart, RangeEnd: TG2IntS32);
  var i, j : LongInt;
  var tmp, pivot: T;
begin
  if RangeEnd < RangeStart then Exit;
  i := RangeStart;
  j := RangeEnd;
  pivot := _Items[(RangeStart + RangeEnd) shr 1];
  repeat
    while CmpFunc(pivot, _Items[i]) > 0 do i := i + 1;
    while CmpFunc(pivot, _Items[j]) < 0 do j := j - 1;
    if i <= j then
    begin
      tmp := _Items[i];
      _Items[i] := _Items[j];
      _Items[j] := tmp;
      j := j - 1;
      i := i + 1;
    end;
  until i > j;
  if RangeStart < j then Sort(CmpFunc, RangeStart, j);
  if i < RangeEnd then Sort(CmpFunc, i, RangeEnd);
end;

procedure TG2Array.Sort(const CmpFunc: TCmpFuncObj; RangeStart, RangeEnd: TG2IntS32);
  var i, j : LongInt;
  var tmp, pivot: T;
begin
  i := RangeStart;
  j := RangeEnd;
  pivot := _Items[(RangeStart + RangeEnd) shr 1];
  repeat
    while CmpFunc(pivot, _Items[i]) > 0 do i := i + 1;
    while CmpFunc(pivot, _Items[j]) < 0 do j := j - 1;
    if i <= j then
    begin
      tmp := _Items[i];
      _Items[i] := _Items[j];
      _Items[j] := tmp;
      j := j - 1;
      i := i + 1;
    end;
  until i > j;
  if RangeStart < j then Sort(CmpFunc, RangeStart, j);
  if i < RangeEnd then Sort(CmpFunc, i, RangeEnd);
end;

procedure TG2Array.Sort(const CmpFunc: TCmpFunc);
begin
  Sort(CmpFunc, 0, _ItemCount - 1);
end;

procedure TG2Array.Sort(const CmpFunc: TCmpFuncObj);
begin
  Sort(CmpFunc, 0, _ItemCount - 1);
end;
//TG2Array END

//TG2Group BEGIN
constructor TG2Group.Create;
begin
  inherited Create;
  _List.Clear;
  _ListRemove.Clear;
  _ListAdd.Clear;
  _Updating := False;
end;

destructor TG2Group.Destroy;
begin
  FreeItems;
  inherited Destroy;
end;

function TG2Group.GetItem(const Index: TG2IntS32): TG2GroupItem;
begin
  Result := TG2GroupItem(_List[Index]);
end;

procedure TG2Group.SetItem(const Index: TG2IntS32; const Value: TG2GroupItem);
begin
  _List[Index] := Value;
end;

function TG2Group.GetCount: TG2IntS32;
begin
  Result := _List.Count;
end;

procedure TG2Group.Render(const Pass: TG2IntS32 = 0);
  var i: TG2IntS32;
begin
  for i := 0 to _List.Count - 1 do
  TG2GroupItem(_List[i]).Render(Pass);
end;

procedure TG2Group.Update;
  var i, j: TG2IntS32;
begin
  _Updating := True;
  i := 0;
  j := _List.Count - 1;
  while i <= j do
  begin
    if not TG2GroupItem(_List[i]).Dead then
    TG2GroupItem(_List[i]).Update;
    if TG2GroupItem(_List[i]).Dead then
    begin
      TG2GroupItem(_List[i]).Destroy;
      Delete(i);
      Dec(j);
    end
    else
    Inc(i);
  end;
  _Updating := False;
  if _ListRemove.Count > 0 then
  begin
    for i := 0 to _ListRemove.Count - 1 do
    Remove(TG2GroupItem(_ListRemove[i]));
    _ListRemove.Clear;
  end;
  if _ListAdd.Count > 0 then
  begin
    for i := 0 to _ListAdd.Count - 1 do
    Add(TG2GroupItem(_ListAdd[i]));
    _ListAdd.Clear;
  end;
end;

procedure TG2Group.Add(const Item: TG2GroupItem);
  var l, h, m: TG2IntS32;
  var dif: TG2Float;
begin
  if _Updating then
  _ListAdd.Add(Item)
  else
  begin
    Item.Group := Self;
    l := 0;
    h := _List.Count - 1;
    while l <= h do
    begin
      m := (l + h) div 2;
      dif := TG2GroupItem(_List[m]).Sort - Item.Sort;
      if dif < 0 then l := m + 1
      else h := m - 1;
    end;
    _List.Insert(l, Item);
  end;
end;

procedure TG2Group.Remove(const Item: TG2GroupItem);
begin
  if _Updating then
  _ListRemove.Add(Item)
  else
  _List.Remove(Item);
end;

procedure TG2Group.Delete(const Index: TG2IntS32);
begin
  _List.Delete(Index);
end;

procedure TG2Group.FreeItems;
  var i: TG2IntS32;
begin
  for i := 0 to _ListRemove.Count - 1 do
  TG2GroupItem(_ListRemove[i]).Free;
  _ListRemove.Clear;
  for i := 0 to _ListAdd.Count - 1 do
  TG2GroupItem(_ListAdd[i]).Free;
  _ListAdd.Clear;
  for i := 0 to _List.Count - 1 do
  TG2GroupItem(_List[i]).Free;
  _List.Clear;
end;
//TG2Group END

//TG2GroupItem BEGIN
procedure TG2GroupItem.SetSort(const Value: TG2Float);
begin
  _Sort := Value;
  _Group.Remove(Self);
  _Group.Add(Self);
end;

procedure TG2GroupItem.Initialize;
begin

end;

procedure TG2GroupItem.Finalize;
begin

end;

constructor TG2GroupItem.Create(const G2Group: TG2Group);
begin
  inherited Create;
  _Dead := False;
  _Sort := 0;
  _Group := G2Group;
  _Group.Add(Self);
  Initialize;
end;

destructor TG2GroupItem.Destroy;
begin
  Finalize;
  inherited Destroy;
end;

{$Hints off}
procedure TG2GroupItem.Render(const Pass: TG2IntS32 = 0);
begin

end;
{$Hints on}

procedure TG2GroupItem.Update;
begin

end;

procedure TG2GroupItem.Die;
begin
  _Dead := True;
end;
//TG2GroupItem END

//TG2Parser BEGIN
function TG2Parser.GetText: AnsiString;
begin
  SetLength(Result, Length(_Text));
  Move(_Text[0], Result[1], Length(_Text));
end;

function TG2Parser.GetComment(const Index: Integer): AnsiString;
begin
  Result := _Comment[Index][0] + _Comment[Index][1];
end;

function TG2Parser.GetCommentCount: Integer;
begin
  Result := Length(_Comment);
end;

function TG2Parser.GetCommentLine(const Index: Integer): AnsiString;
begin
  Result := _CommentLine[Index];
end;

function TG2Parser.GetCommentLineCount: Integer;
begin
  Result := Length(_CommentLine);
end;

function TG2Parser.GetKeyWord(const Index: Integer): AnsiString;
begin
  Result := _KeyWords[Index];
end;

function TG2Parser.GetKeyWordCount: Integer;
begin
  Result := Length(_KeyWords);
end;

function TG2Parser.GetString(const Index: Integer): AnsiString;
begin
  Result := _String[Index];
end;

function TG2Parser.GetStringCount: Integer;
begin
  Result := Length(_String);
end;

function TG2Parser.GetSymbol(const Index: Integer): AnsiString;
begin
  Result := _Symbols[Index];
end;

function TG2Parser.GetSymbolCount: Integer;
begin
  Result := Length(_Symbols);
end;

function TG2Parser.GetLen: TG2IntS32;
begin
  Result := Length(_Text);
end;

constructor TG2Parser.Create;
begin
  inherited Create;
  _Position := 0;
  _Text := nil;
  _CaseSensitive := False;
end;

constructor TG2Parser.Create(const ParseText: AnsiString; const CaseSensitive: Boolean = False);
begin
  inherited Create;
  Parse(ParseText, CaseSensitive);
end;

destructor TG2Parser.Destroy;
begin
  inherited Destroy;
end;

procedure TG2Parser.Parse(const ParseText: AnsiString; const CaseSensitive: Boolean);
begin
  _CaseSensitive := CaseSensitive;
  if Length(_Text) <> Length(ParseText) then
  SetLength(_Text, Length(ParseText));
  Move(ParseText[1], _Text[0], Length(ParseText));
  _Position := 0;
  _Line := 0;
end;

procedure TG2Parser.AddComment(const CommentStart, CommentEnd: AnsiString);
begin
  SetLength(_Comment, Length(_Comment) + 1);
  _Comment[High(_Comment)][0] := CommentStart;
  _Comment[High(_Comment)][1] := CommentEnd;
end;

procedure TG2Parser.AddCommentLine(const CommentLine: AnsiString);
begin
  SetLength(_CommentLine, Length(_CommentLine) + 1);
  _CommentLine[High(_CommentLine)] := CommentLine;
end;

procedure TG2Parser.AddString(const StringStartEnd: AnsiString);
begin
  SetLength(_String, Length(_String) + 1);
  _String[High(_String)] := StringStartEnd;
end;

procedure TG2Parser.AddSymbol(const Symbol: AnsiString);
begin
  SetLength(_Symbols, Length(_Symbols) + 1);
  _Symbols[High(_Symbols)] := Symbol;
end;

procedure TG2Parser.AddKeyWord(const KeyWord: AnsiString);
begin
  SetLength(_KeyWords, Length(_KeyWords) + 1);
  _KeyWords[High(_KeyWords)] := KeyWord;
end;

procedure TG2Parser.SkipSpaces;
begin
  while (_Position < Len)
  and (
    (_Text[_Position] = ' ')
    or (_Text[_Position] = #$D)
    or (_Text[_Position] = #$A)
  ) do
  begin
    if _Text[_Position] = #$D then
    Inc(_Line);
    Inc(_Position);
  end;
end;

function TG2Parser.Read(const Count: TG2IntS32): AnsiString;
  var c: TG2IntS32;
begin
  if Count + _Position > Len then
  c := Len - _Position
  else
  c := Count;
  SetLength(Result, c);
  Move(_Text[_Position], Result[1], c);
  Inc(_Position, c);
end;

function TG2Parser.Read(const Pos: TG2IntS32; const Count: TG2IntS32): AnsiString;
  var c: TG2IntS32;
begin
  if Count + Pos > Len then
  c := Len - Pos
  else
  c := Count;
  if c <= 0 then
  begin
    Result := '';
    Exit;
  end;
  SetLength(Result, c);
  Move(_Text[Pos], Result[1], c);
end;

function TG2Parser.IsAtSymbol: TG2IntS32;
  var i, j: TG2IntS32;
  var Match: Boolean;
begin
  for i := 0 to High(_Symbols) do
  begin
    Match := True;
    if _Position + Length(_Symbols[i]) - 1 > High(_Text) then
    Match := False
    else
    begin
      for j := 0 to Length(_Symbols[i]) - 1 do
      if (_CaseSensitive and (_Text[_Position + j] <> _Symbols[i][j + 1]))
      or (not _CaseSensitive and (LowerCase(_Text[_Position + j]) <> LowerCase(_Symbols[i][j + 1]))) then
      begin
        Match := False;
        Break;
      end;
    end;
    if Match then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

function TG2Parser.IsAtKeyword: TG2IntS32;
  var i, j: TG2IntS32;
  var Match: Boolean;
begin
  for i := 0 to High(_KeyWords) do
  begin
    Match := True;
    for j := 0 to Length(_KeyWords[i]) - 1 do
    if (_CaseSensitive and (_Text[_Position + j] <> _KeyWords[i][j + 1]))
    or (not _CaseSensitive and (LowerCase(_Text[_Position + j]) <> LowerCase(_KeyWords[i][j + 1]))) then
    begin
      Match := False;
      Break;
    end;
    if Match then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

function TG2Parser.IsAtCommentLine: TG2IntS32;
  var i, j: TG2IntS32;
  var Match: Boolean;
begin
  for i := 0 to High(_CommentLine) do
  begin
    Match := True;
    for j := 0 to Length(_CommentLine[i]) - 1 do
    if (_CaseSensitive and (_Text[_Position + j] <> _CommentLine[i][j + 1]))
    or (not _CaseSensitive and (LowerCase(_Text[_Position + j]) <> LowerCase(_CommentLine[i][j + 1]))) then
    begin
      Match := False;
      Break;
    end;
    if Match then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

function TG2Parser.IsAtCommentStart: TG2IntS32;
  var i, j: TG2IntS32;
  var Match: Boolean;
begin
  for i := 0 to High(_Comment) do
  begin
    Match := True;
    for j := 0 to Length(_Comment[i][0]) - 1 do
    if (_CaseSensitive and (_Text[_Position + j] <> _Comment[i][0][j + 1]))
    or (not _CaseSensitive and (LowerCase(_Text[_Position + j]) <> LowerCase(_Comment[i][0][j + 1]))) then
    begin
      Match := False;
      Break;
    end;
    if Match then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

function TG2Parser.IsAtCommentEnd: TG2IntS32;
  var i, j: TG2IntS32;
  var Match: Boolean;
begin
  for i := 0 to High(_Comment) do
  begin
    Match := True;
    for j := 0 to Length(_Comment[i][1]) - 1 do
    if (_CaseSensitive and (_Text[_Position + j] <> _Comment[i][1][j + 1]))
    or (not _CaseSensitive and (LowerCase(_Text[_Position + j]) <> LowerCase(_Comment[i][1][j + 1]))) then
    begin
      Match := False;
      Break;
    end;
    if Match then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

function TG2Parser.IsAtString: TG2IntS32;
  var i, j: TG2IntS32;
  var Match: Boolean;
begin
  for i := 0 to High(_String) do
  begin
    Match := True;
    for j := 0 to Length(_String[i]) - 1 do
    if (_CaseSensitive and (_Text[_Position + j] <> _String[i][j + 1]))
    or (not _CaseSensitive and (LowerCase(_Text[_Position + j]) <> LowerCase(_String[i][j + 1]))) then
    begin
      Match := False;
      Break;
    end;
    if Match then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

function TG2Parser.IsAtEOF: Boolean;
begin
  Result := _Position >= Len;
end;

function TG2Parser.NextToken(var TokenType: TG2TokenType): AnsiString;
  var i: TG2IntS32;
  var b: Boolean;
begin
  Result := '';
  TokenType := ttEOF;
  SkipSpaces;
  if _Position >= Len then
  Exit;
  i := IsAtCommentStart;
  while i > -1 do
  begin
    Inc(_Position, Length(_Comment[i][0]));
    while (_Position < Len - Length(_Comment[i][1]))
    and (IsAtCommentEnd <> i) do
    Inc(_Position);
    Inc(_Position, Length(_Comment[i][1]));
    SkipSpaces;
    i := IsAtCommentStart;
  end;
  i := IsAtCommentLine;
  while i > -1 do
  begin
    Inc(_Position, Length(_CommentLine[i]));
    while (_Position < Len)
    and (_Text[_Position] <> #$D)
    and (_Text[_Position] <> #$A) do
    Inc(_Position);
    SkipSpaces;
    i := IsAtCommentLine;
  end;
  i := IsAtString;
  if i > -1 then
  begin
    TokenType := ttString;
    Inc(_Position, Length(_String[i]));
    while (_Position <= Len - Length(_String[i]))
    and (IsAtString <> i) do
    begin
      Result := Result + _Text[_Position];
      Inc(_Position);
    end;
    if _Position <= Len - Length(_String[i]) then
    Inc(_Position, Length(_String[i]));
    Exit;
  end;
  i := IsAtSymbol;
  if i > -1 then
  begin
    TokenType := ttSymbol;
    Result := _Symbols[i];
    Inc(_Position, Length(_Symbols[i]));
    Exit;
  end;
  b := True;
  while b do
  begin
    Result := Result + _Text[_Position];
    Inc(_Position);
    if _Position >= Length(_Text) then
    b := False;
    if b and (
      (_Text[_Position] = ' ')
      or (_Text[_Position] = #$D)
      or (_Text[_Position] = #$A)
    ) then
    begin
      b := False;
    end;
    if b then
    begin
      i := IsAtSymbol;
      if i > -1 then
      b := False;
    end;
  end;
  if Length(Result) > 0 then
  begin
    if StrToIntDef(Result, 0) = StrToIntDef(Result, 1) then
    begin
      TokenType := ttNumber;
      Exit;
    end;
    for i := 0 to High(_KeyWords) do
    if LowerCase(_KeyWords[i]) = LowerCase(Result) then
    begin
      TokenType := ttKeyword;
      Result := _KeyWords[i];
      Exit;
    end;
    TokenType := ttWord;
  end;
end;
//TG2Parser END

//TG2MLObject BEGIN
function TG2MLObject.FindNode(const NodeName: AnsiString): PG2MLObject;
  var n: AnsiString;
  var i: Integer;
begin
  n := LowerCase(NodeName);
  for i := 0 to Children.Count - 1 do
  if Children[i]^.Name = n then
  begin
    Result := Children[i];
    Exit;
  end;
  Result := nil;
end;

function TG2MLObject.AsInt: TG2IntS32;
begin
  if DataType = dtInt then
  Result := PG2IntS32(Data)^
  else
  Result := 0;
end;

function TG2MLObject.AsFloat: TG2Float;
begin
  if DataType = dtFloat then
  Result := PG2Float(Data)^
  else if DataType = dtInt then
  Result := PG2IntS32(Data)^
  else
  Result := 0;
end;

function TG2MLObject.AsString: AnsiString;
begin
  if (DataType = dtString) or (DataType = dtData) then
  begin
    SetLength(Result, DataSize);
    Move(Data^, Result[1], DataSize);
  end
  else if DataType = dtInt then
  Result := IntToStr(PG2IntS32(Data)^)
  else if DataType = dtFloat then
  Result := FloatToStr(PG2Float(Data)^)
  else
  Result := '';
end;

function TG2MLObject.AsBool: Boolean;
  var Str: AnsiString;
begin
  if (DataType = dtString) then
  begin
    SetLength(Str, DataSize);
    Move(Data^, Str[1], DataSize);
    Result := LowerCase(Str) = 'true';
  end
  else if DataType = dtInt then
  Result := PG2IntS32(Data)^ > 0
  else if DataType = dtFloat then
  Result := PG2Float(Data)^ > 0
  else
  Result := False;
end;

procedure TG2MLObject.Clear;
begin
  Parent := nil;
  Children.Clear;
  DataType := dtNone;
  Data := nil;
  DataSize := 0;
end;
//TG2MLObject END

//TG2ML BEGIN
constructor TG2ML.Create;
begin
  inherited Create;
  _Parser := TG2Parser.Create;
  _Parser.AddSymbol('{#');
  _Parser.AddSymbol('#}');
  _Parser.AddSymbol('=');
  _Parser.AddString('"');
end;

destructor TG2ML.Destroy;
begin
  _Parser.Free;
  inherited Destroy;
end;

{$Hints off}
function TG2ML.Read(const Data: AnsiString): PG2MLObject;
  var Token: AnsiString;
  var tt: TG2TokenType;
  var CurObject: PG2MLObject;
  var NewObject: PG2MLObject;
begin
  _Parser.Parse(Data);
  New(Result);
  Result^.Name := 'root';
  Result^.Clear;
  CurObject := Result;
  repeat
    Token := _Parser.NextToken(tt);
    if tt = ttSymbol then
    begin
      if Token = '{#' then
      begin
        Token := _Parser.NextToken(tt);
        if tt = ttWord then
        begin
          New(NewObject);
          NewObject^.Clear;
          NewObject^.Parent := CurObject;
          NewObject^.Children.Clear;
          NewObject^.Name := Token;
          CurObject^.Children.Add(NewObject);
          CurObject := NewObject;
        end;
      end
      else if Token = '#}' then
      begin
        CurObject := CurObject^.Parent;
      end;
    end
    else if (tt = ttWord)
    and (CurObject <> Result) then
    begin
      New(NewObject);
      NewObject^.Clear;
      NewObject^.Name := Token;
      NewObject^.Parent := CurObject;
      CurObject^.Children.Add(NewObject);
      Token := _Parser.NextToken(tt);
      if (tt = ttSymbol) and (Token = '=') then
      begin
        Token := _Parser.NextToken(tt);
        if (tt = ttWord) or (tt = ttNumber) or (tt = ttString) then
        begin
          if (StrToIntDef(Token, 0) = StrToIntDef(Token, 1)) then
          begin
            NewObject^.DataType := dtInt;
            NewObject^.DataSize := SizeOf(TG2IntS32);
            NewObject^.Data := G2MemAlloc(NewObject^.DataSize);
            PG2IntS32(NewObject^.Data)^ := StrToIntDef(Token, 0);
          end
          else if (Abs(StrToFloatDef(Token, 1) - StrToFloatDef(Token, 0)) < 0.1) then
          begin
            NewObject^.DataType := dtFloat;
            NewObject^.DataSize := SizeOf(TG2Float);
            NewObject^.Data := G2MemAlloc(NewObject^.DataSize);
            PG2Float(NewObject^.Data)^ := StrToFloatDef(Token, 0);
          end
          else
          begin
            NewObject^.DataType := dtString;
            NewObject^.DataSize := Length(Token);
            NewObject^.Data := G2MemAlloc(NewObject^.DataSize);
            Move(Token[1], NewObject^.Data^, NewObject^.DataSize);
          end;
        end;
      end;
    end;
  until tt = ttEOF;
end;
{$Hints on}

procedure TG2ML.FreeObject(var G2MLObject: PG2MLObject);
  var i: Integer;
  var Obj: PG2MLObject;
begin
  for i := 0 to G2MLObject^.Children.Count - 1 do
  begin
    Obj := G2MLObject^.Children[i];
    FreeObject(Obj);
  end;
  if G2MLObject^.DataSize > 0 then
  G2MemFree(G2MLObject^.Data, G2MLObject^.DataSize);
  Dispose(G2MLObject);
  G2MLObject := nil;
end;
//TG2ML END

//TG2MLWriter BEGIN
procedure TG2MLWriter.WriteSpaces(const Count: Integer);
  var i: Integer;
begin
  for i := 0 to Count - 1 do
  _Data += ' ';
end;

procedure TG2MLWriter.WriteReturn;
begin
  _Data += #$D#$A;
end;

constructor TG2MLWriter.Create;
begin
  inherited Create;
  _Compact := False;
  Clear;
end;

destructor TG2MLWriter.Destroy;
begin
  inherited Destroy;
end;

procedure TG2MLWriter.Clear;
begin
  _Data := '';
  _Nest := 0;
end;

procedure TG2MLWriter.NodeOpen(const NodeName: AnsiString);
begin
  if _Compact then
  begin
    if _Nest > 0 then
    _Data += ' ';
    _Data += '{#' + NodeName;
  end
  else
  begin
    WriteSpaces(_Nest);
    _Data += '{#' + NodeName;
    WriteReturn;
  end;
  _Nest += 1;
end;

procedure TG2MLWriter.NodeClose;
begin
  _Nest -= 1;
  if _Compact then
  begin
    _Data += '#}';
  end
  else
  begin
    WriteSpaces(_Nest);
    _Data += '#}';
    WriteReturn;
  end;
end;

procedure TG2MLWriter.NodeValue(const NodeName: AnsiString; const Value: AnsiString);
begin
  if _Compact then
  begin
    _Data += ' ' + NodeName + '="' + Value + '"';
  end
  else
  begin
    WriteSpaces(_Nest);
    _Data += NodeName + ' = "' + Value + '"';
    WriteReturn;
  end;
end;

procedure TG2MLWriter.NodeValue(const NodeName: AnsiString; const Value: TG2IntS32);
begin
  if _Compact then
  begin
    _Data += ' ' + NodeName + '=' + IntToStr(Value);
  end
  else
  begin
    WriteSpaces(_Nest);
    _Data += NodeName + ' = ' + IntToStr(Value);
    WriteReturn;
  end;
end;

procedure TG2MLWriter.NodeValue(const NodeName: AnsiString; const Value: TG2Float);
begin
  if _Compact then
  begin
    _Data += ' ' + NodeName + '=' + FloatToStr(Value);
  end
  else
  begin
    WriteSpaces(_Nest);
    _Data += NodeName + ' = ' + FloatToStr(Value);
    WriteReturn;
  end;
end;

procedure TG2MLWriter.NodeValue(const NodeName: AnsiString; const Value: Boolean);
  var BoolStr: AnsiString;
begin
  if Value then BoolStr := '1' else BoolStr := '0';
  if _Compact then
  begin
    _Data += ' ' + NodeName + '=' + BoolStr;
  end
  else
  begin
    WriteSpaces(_Nest);
    _Data += NodeName + ' = ' + BoolStr;
    WriteReturn;
  end;
end;
//TG2MLWriter END

//TG2XMLNode BEGIN
function TG2XMLNode.TAttribute.AsInt: TG2IntS32;
begin
  Result := StrToIntDef(Value, 0);
end;

function TG2XMLNode.TAttribute.AsFloat: TG2Float;
begin
  Result := StrToFloatDef(Value, 0);
end;

procedure TG2XMLNode.SetParent(const Value: TG2XMLNode);
begin
  _Parent := Value;
end;

procedure TG2XMLNode.SetSibling(const Value: TG2XMLNode);
begin
  _Sibling := Value;
end;

procedure TG2XMLNode.SetChild(const Value: TG2XMLNode);
begin
  _Child := Value;
end;

procedure TG2XMLNode.SetName(const Value: AnsiString);
begin
  _Name := Value;
end;

procedure TG2XMLNode.SetData(const Value: AnsiString);
begin
  _Data := Value;
end;

procedure TG2XMLNode.AddChild(const Node: TG2XMLNode);
  var Target: ^TG2XMLNode;
begin
  Target := @_Child;
  while Assigned(Target^) do
  begin
    Target := @Target^._Sibling;
  end;
  Target^ := Node;
  Node.SetParent(Self);
end;

function TG2XMLNode.GetXML: AnsiString;
  var Tab: TG2IntS32;
  procedure WriteNode(const Node: TG2XMLNode; var Output: AnsiString);
    var i: TG2IntS32;
    var TabStr: AnsiString;
    var c: TG2XMLNode;
  begin
    TabStr := '';
    for i := 0 to Tab - 1 do TabStr += '  ';
    Output += TabStr + '<' + Node._Name;
    for i := 0 to High(Node._Attributes) do
    begin
      Output += ' ' + Node._Attributes[i].Name + ' = ' + Node._Attributes[i].Value;
    end;
    if Assigned(Node._Child) then
    begin
      Output += '>'#$D#$A;
      Inc(Tab);
      c := Node._Child;
      while Assigned(c) do
      begin
        WriteNode(c, Output);
        c := c._Sibling;
      end;
      Dec(Tab);
      Output += TabStr + '</' + Node._Name + '>'#$D#$A;
    end
    else if Length(Node._Data) > 0 then
    begin
      Output += Node._Data + '</' + Node._Name + '>'#$D#$A;
    end
    else
    begin
      Output += '/>'#$D#$A;
    end;
  end;
begin
  Result := '<?xml version="1.0" encoding="utf-8"?>';
  Tab := 0;
  WriteNode(Self, Result);
end;

procedure TG2XMLNode.SetXML(const Value: AnsiString);
  procedure ReadNode(const Parser: TG2Parser; const Node: TG2XMLNode);
    var tt: TG2TokenType;
    var Token: AnsiString;
    var c: TG2XMLNode;
    var AttributeName: AnsiString;
    var p: Integer;
  begin
    tt := ttError;
    repeat
      Token := Parser.NextToken(tt);
      case tt of
        ttSymbol:
        begin
          if Token = '<' then
          begin
            Token := Parser.NextToken(tt);
            if tt = ttWord then
            begin
              c := TG2XMLNode.Create;
              c.SetName(LowerCase(Token));
              Node.AddChild(c);
              repeat
                Token := Parser.NextToken(tt);
                case tt of
                  ttSymbol:
                  begin
                    if Token = '>' then
                    begin
                      ReadNode(Parser, c);
                      Break;
                    end
                    else if Token = '/>' then
                    begin
                      Break;
                    end;
                  end;
                  ttWord:
                  begin
                    AttributeName := LowerCase(Token);
                    p := Parser.Position;
                    Token := Parser.NextToken(tt);
                    if (tt = ttSymbol)
                    and (Token = '=') then
                    begin
                      Token := Parser.NextToken(tt);
                      if tt <> ttSymbol then
                      begin
                        c.AddAttribute(AttributeName, Token);
                      end
                      else
                      begin
                        Parser.Position := p;
                      end;
                    end
                    else
                    begin
                      Parser.Position := p;
                    end;
                  end;
                end;
              until tt = ttEOF;
            end
            else
            begin
              tt := ttError;
              Break;
            end;
          end
          else if Token = '</' then
          begin
            repeat
              Token := Parser.NextToken(tt);
              if (tt = ttSymbol)
              and (Token = '>') then
              begin
                Break;
              end;
            until tt = ttEOF;
            Break;
          end;
        end;
        else
        begin
          Node.AddData(Token);
        end;
      end;
    until (tt = ttEOF) or (tt = ttError);
  end;
  var Parser: TG2Parser;
begin
  Parser := TG2Parser.Create(Value);
  Parser.AddComment('<!--', '-->');
  Parser.AddComment('<?', '?>');
  Parser.AddSymbol('/>');
  Parser.AddSymbol('</');
  Parser.AddSymbol('<');
  Parser.AddSymbol('>');
  Parser.AddSymbol('=');
  Parser.AddString('"');
  ReadNode(Parser, Self);
  Parser.Free;
end;

function TG2XMLNode.GetAttribute(const Index: TG2IntS32): PAttribute;
begin
  Result := @_Attributes[Index];
end;

function TG2XMLNode.GetAttributeCount: TG2IntS32;
begin
  Result := Length(_Attributes);
end;

constructor TG2XMLNode.Create;
begin
  _Parent := nil;
  _Sibling := nil;
  _Child := nil;
  _Data := '';
end;

destructor TG2XMLNode.Destroy;
  var c: TG2XMLNode;
begin
  while Assigned(_Child) do
  begin
    c := _Child;
    _Child := _Child.Sibling;
    c.Free;
  end;
  inherited Destroy;
end;

procedure TG2XMLNode.AddAttribute(const AttribName, AttribValue: AnsiString);
begin
  SetLength(_Attributes, Length(_Attributes) + 1);
  _Attributes[High(_Attributes)].Name := AttribName;
  _Attributes[High(_Attributes)].Value := AttribValue;
end;

procedure TG2XMLNode.AddData(const Value: AnsiString);
begin
  if Length(_Data) > 0 then
  begin
    _Data := _Data + ' ' + Value;
  end
  else
  begin
    _Data := Value;
  end;
end;

function TG2XMLNode.AsInt: TG2IntS32;
begin
  Result := StrToIntDef(_Data, 0);
end;

function TG2XMLNode.AsFloat: TG2Float;
begin
  Result := StrToFloatDef(_Data, 0);
end;

function TG2XMLNode.FindChildByName(const ChildName: AnsiString): TG2XMLNode;
  var c: TG2XMLNode;
begin
  c := _Child;
  while Assigned(c) do
  begin
    if c.Name = ChildName then
    begin
      Result := c;
      Exit;
    end;
    c := c.Sibling;
  end;
  Result := nil;
end;

function TG2XMLNode.FindNodeByName(const NodeName: AnsiString): TG2XMLNode;
  var c: TG2XMLNode;
begin
  Result := nil;
  c := _Child;
  while Assigned(c) do
  begin
    if c.Name = NodeName then
    begin
      Result := c;
      Exit;
    end
    else
    begin
      Result := c.FindNodeByName(NodeName);
    end;
    if Assigned(Result) then Exit;
    c := c.Sibling;
  end;
end;

function TG2XMLNode.FindAttribute(const AttribName: AnsiString): PAttribute;
  var i: TG2IntS32;
begin
  for i := 0 to High(_Attributes) do
  if _Attributes[i].Name = AttribName then
  begin
    Result := @_Attributes[i];
    Exit;
  end;
  Result := nil;
end;
//TG2XMLNode END

operator = (md5a, md5b: TG2MD5) r: Boolean;
  type TDWordArr4 = array[0..3] of TG2IntU32;
  var da1: TDWordArr4 absolute md5a;
  var da2: TDWordArr4 absolute md5b;
  var i: TG2IntS32;
begin
  for i := 0 to 3 do
  if da1[i] <> da2[i] then
  begin
    Result := False;
    Exit;
  end;
  Result := True;
end;

function G2MD5(const Value: PG2IntU8; const Count: TG2IntU32): TG2MD5;
  const S11 = 7;
  const S12 = 12;
  const S13 = 17;
  const S14 = 22;
  const S21 = 5;
  const S22 = 9;
  const S23 = 14;
  const S24 = 20;
  const S31 = 4;
  const S32 = 11;
  const S33 = 16;
  const S34 = 23;
  const S41 = 6;
  const S42 = 10;
  const S43 = 15;
  const S44 = 21;
  var ContextCount: array[0..1] of TG2IntU32;
  var ContextState: array[0..4] of TG2IntU32;
  var ContextBuffer: array[0..63] of TG2IntU8;
  var Padding: array[0..63] of TG2IntU8;
  procedure Encode(const Dst: PG2IntU8Arr; const Src: PG2IntU32Arr; const Count: TG2IntS32);
    var i, j: TG2IntS32;
  begin
    i := 0;
    j := 0;
    while (j < Count) do
    begin
      Dst^[j] := Src^[i] and $ff;
      Dst^[j + 1] := (Src^[i] shr 8)  and $ff;
      Dst^[j + 2] := (Src^[i] shr 16) and $ff;
      Dst^[j + 3] := (Src^[i] shr 24) and $ff;
      Inc(j, 4);
      Inc(i);
    end;
  end;
  procedure Decode(const Dst: PG2IntU32Arr; const Src: PG2IntU8Arr; const Count, Shift: TG2IntS32);
    var i, j: TG2IntS32;
  begin
    j := 0;
    i := 0;
    while (j < Count) do
    begin
      Dst^[i] := (
        (Src^[j + Shift] and $ff) or
        ((Src^[j + Shift + 1] and $ff) shl 8)  or
        ((Src^[j + Shift + 2] and $ff) shl 16) or
        ((Src^[j + Shift + 3] and $ff) shl 24)
      );
      Inc(j, 4);
      Inc(i);
    end;
  end;
  procedure Transform(const Block: PG2IntU8Arr; const Shift: TG2IntS32);
    function F(const x, y, z: TG2IntU32): TG2IntU32;
    begin
      Result := (x and y) or ((not x) and z);
    end;
    function G(const x, y, z: TG2IntU32): TG2IntU32;
    begin
      Result := (x and z) or (y and (not z));
    end;
    function H(const x, y, z: TG2IntU32): TG2IntU32;
    begin
      Result := x xor y xor z;
    end;
    function I(const x, y, z: TG2IntU32): TG2IntU8;
    begin
      Result := y xor (x or (not z));
    end;
    procedure RL(var x: TG2IntU32; const n: TG2IntU8);
    begin
      x := (x shl n) or (x shr (32 - n));
    end;
    procedure FF(var a: Longword; const b, c, d, x: TG2IntU32; const s: TG2IntU8; const ac: TG2IntU32);
    begin
      Inc(a, F(b, c, d) + x + ac);
      RL(a, s);
      Inc(a, b);
    end;
    procedure GG(var a: TG2IntU32; const b, c, d, x: TG2IntU32; const s: TG2IntU8; const ac: TG2IntU32);
    begin
      Inc(a, G(b, c, d) + x + ac);
      RL(a, s);
      Inc(a, b);
    end;
    procedure HH(var a: TG2IntU32; const b, c, d, x: TG2IntU32; const s: TG2IntU8; const ac: TG2IntU32);
    begin
      Inc(a, H(b, c, d) + x + ac);
      RL(a, s);
      Inc(a, b);
    end;
    procedure II(var a: TG2IntU32; const b, c, d, x: TG2IntU32; const s: TG2IntU8; const ac: TG2IntU32);
    begin
      Inc(a, I(b, c, d) + x + ac);
      RL(a, s);
      Inc(a, b);
    end;
    var a, b, c, d: TG2IntU32;
    var x: array[0..15] of TG2IntU32;
  begin
    a := ContextState[0];
    b := ContextState[1];
    c := ContextState[2];
    d := ContextState[3];
    Decode(@x[0], Block, 64, Shift);
    FF( a, b, c, d, x[ 0], S11, $d76aa478); //1
    FF( d, a, b, c, x[ 1], S12, $e8c7b756); //2
    FF( c, d, a, b, x[ 2], S13, $242070db); //3
    FF( b, c, d, a, x[ 3], S14, $c1bdceee); //4
    FF( a, b, c, d, x[ 4], S11, $f57c0faf); //5
    FF( d, a, b, c, x[ 5], S12, $4787c62a); //6
    FF( c, d, a, b, x[ 6], S13, $a8304613); //7
    FF( b, c, d, a, x[ 7], S14, $fd469501); //8
    FF( a, b, c, d, x[ 8], S11, $698098d8); //9
    FF( d, a, b, c, x[ 9], S12, $8b44f7af); //10
    FF( c, d, a, b, x[10], S13, $ffff5bb1); //11
    FF( b, c, d, a, x[11], S14, $895cd7be); //12
    FF( a, b, c, d, x[12], S11, $6b901122); //13
    FF( d, a, b, c, x[13], S12, $fd987193); //14
    FF( c, d, a, b, x[14], S13, $a679438e); //15
    FF( b, c, d, a, x[15], S14, $49b40821); //16
    GG( a, b, c, d, x[ 1], S21, $f61e2562); //17
    GG( d, a, b, c, x[ 6], S22, $c040b340); //18
    GG( c, d, a, b, x[11], S23, $265e5a51); //19
    GG( b, c, d, a, x[ 0], S24, $e9b6c7aa); //20
    GG( a, b, c, d, x[ 5], S21, $d62f105d); //21
    GG( d, a, b, c, x[10], S22,  $2441453); //22
    GG( c, d, a, b, x[15], S23, $d8a1e681); //23
    GG( b, c, d, a, x[ 4], S24, $e7d3fbc8); //24
    GG( a, b, c, d, x[ 9], S21, $21e1cde6); //25
    GG( d, a, b, c, x[14], S22, $c33707d6); //26
    GG( c, d, a, b, x[ 3], S23, $f4d50d87); //27
    GG( b, c, d, a, x[ 8], S24, $455a14ed); //28
    GG( a, b, c, d, x[13], S21, $a9e3e905); //29
    GG( d, a, b, c, x[ 2], S22, $fcefa3f8); //30
    GG( c, d, a, b, x[ 7], S23, $676f02d9); //31
    GG( b, c, d, a, x[12], S24, $8d2a4c8a); //32
    HH( a, b, c, d, x[ 5], S31, $fffa3942); //33
    HH( d, a, b, c, x[ 8], S32, $8771f681); //34
    HH( c, d, a, b, x[11], S33, $6d9d6122); //35
    HH( b, c, d, a, x[14], S34, $fde5380c); //36
    HH( a, b, c, d, x[ 1], S31, $a4beea44); //37
    HH( d, a, b, c, x[ 4], S32, $4bdecfa9); //38
    HH( c, d, a, b, x[ 7], S33, $f6bb4b60); //39
    HH( b, c, d, a, x[10], S34, $bebfbc70); //40
    HH( a, b, c, d, x[13], S31, $289b7ec6); //41
    HH( d, a, b, c, x[ 0], S32, $eaa127fa); //42
    HH( c, d, a, b, x[ 3], S33, $d4ef3085); //43
    HH( b, c, d, a, x[ 6], S34,  $4881d05); //44
    HH( a, b, c, d, x[ 9], S31, $d9d4d039); //45
    HH( d, a, b, c, x[12], S32, $e6db99e5); //46
    HH( c, d, a, b, x[15], S33, $1fa27cf8); //47
    HH( b, c, d, a, x[ 2], S34, $c4ac5665); //48
    II( a, b, c, d, x[ 0], S41, $f4292244); //49
    II( d, a, b, c, x[ 7], S42, $432aff97); //50
    II( c, d, a, b, x[14], S43, $ab9423a7); //51
    II( b, c, d, a, x[ 5], S44, $fc93a039); //52
    II( a, b, c, d, x[12], S41, $655b59c3); //53
    II( d, a, b, c, x[ 3], S42, $8f0ccc92); //54
    II( c, d, a, b, x[10], S43, $ffeff47d); //55
    II( b, c, d, a, x[ 1], S44, $85845dd1); //56
    II( a, b, c, d, x[ 8], S41, $6fa87e4f); //57
    II( d, a, b, c, x[15], S42, $fe2ce6e0); //58
    II( c, d, a, b, x[ 6], S43, $a3014314); //59
    II( b, c, d, a, x[13], S44, $4e0811a1); //60
    II( a, b, c, d, x[ 4], S41, $f7537e82); //61
    II( d, a, b, c, x[11], S42, $bd3af235); //62
    II( c, d, a, b, x[ 2], S43, $2ad7d2bb); //63
    II( b, c, d, a, x[ 9], S44, $eb86d391); //64
    Inc(ContextState[0], a);
    Inc(ContextState[1], b);
    Inc(ContextState[2], c);
    Inc(ContextState[3], d);
  end;
  procedure Update(const Value: PG2IntU8; const Count: TG2IntU32);
    var i, Index, PartLen, Start: TG2IntU32;
    var pb: PG2IntU8Arr;
  begin
    pb := PG2IntU8Arr(Value);
    Index := (ContextCount[0] shr 3) and $3f;
    Inc(ContextCount[0], Count shl 3);
    if ContextCount[0] < (Count shl 3) then
    Inc(ContextCount[1]);
    Inc(ContextCount[1], Count shr 29);
    PartLen := 64 - Index;
    if Count >= PartLen then
    begin
      for i := 0 to PartLen - 1 do
      ContextBuffer[i + Index] := pb^[i];
      Transform(@ContextBuffer, 0);
      i := PartLen;
      while (i + 63) < Count do
      begin
        Transform(pb, i);
        Inc(i, 64);
      end;
      Index := 0;
    end
    else
    i := 0;
    if (i < Count) then
    begin
      Start := i;
      while (i < Count) do
      begin
        ContextBuffer[TG2IntS64(Index) + TG2IntS64(i) - TG2IntS64(Start)] := pb^[i];
        Inc(I);
      end;
    end;
  end;
  var Bits: array[0..7] of TG2IntU8;
  var Index, PadLen: TG2IntS32;
begin
  {$Hints off}
  FillChar(Padding, 64, 0);
  {$Hints on}
  Padding[0] := $80;
  ContextCount[0] := 0;
  ContextCount[1] := 0;
  ContextState[0] := $67452301;
  ContextState[1] := $efcdab89;
  ContextState[2] := $98badcfe;
  ContextState[3] := $10325476;
  Update(Value, Count);
  Encode(@Bits, @ContextCount, 8);
  Index := (ContextCount[0] shr 3) and $3f;
  if Index < 56 then
  PadLen := 56 - Index
  else
  PadLen := 120 - Index;
  Update(@Padding, PadLen);
  Update(@bits, 8);
  Encode(@Result, @ContextState, 16);
end;

function G2MD5(const Value: AnsiString): TG2MD5;
begin
  Result := G2MD5(@Value[1], Length(Value));
end;

function G2CRC16(const Value: Pointer; const Count: TG2IntS32): TG2IntU16;
  const CRC16Table: array[0..255] of TG2IntU16 = (
    $0000, $c0c1, $c181, $0140, $c301, $03c0, $0280, $c241, $c601, $06c0, $0780,
    $c741, $0500, $c5c1, $c481, $0440, $cc01, $0cc0, $0d80, $cd41, $0f00, $cfc1,
    $ce81, $0e40, $0a00, $cac1, $cb81, $0b40, $c901, $09c0, $0880, $c841, $d801,
    $18c0, $1980, $d941, $1b00, $dbc1, $da81, $1a40, $1e00, $dec1, $df81, $1f40,
    $dd01, $1dc0, $1c80, $dc41, $1400, $d4c1, $d581, $1540, $d701, $17c0, $1680,
    $d641, $d201, $12c0, $1380, $d341, $1100, $d1c1, $d081, $1040, $f001, $30c0,
    $3180, $f141, $3300, $f3c1, $f281, $3240, $3600, $f6c1, $f781, $3740, $f501,
    $35c0, $3480, $f441, $3c00, $fcc1, $fd81, $3d40, $ff01, $3fc0, $3e80, $fe41,
    $fa01, $3ac0, $3b80, $fb41, $3900, $f9c1, $f881, $3840, $2800, $e8c1, $e981,
    $2940, $eb01, $2bc0, $2a80, $ea41, $ee01, $2ec0, $2f80, $ef41, $2d00, $edc1,
    $ec81, $2c40, $e401, $24c0, $2580, $e541, $2700, $e7c1, $e681, $2640, $2200,
    $e2c1, $e381, $2340, $e101, $21c0, $2080, $e041, $a001, $60c0, $6180, $a141,
    $6300, $a3c1, $a281, $6240, $6600, $a6c1, $a781, $6740, $a501, $65c0, $6480,
    $a441, $6c00, $acc1, $ad81, $6d40, $af01, $6fc0, $6e80, $ae41, $aa01, $6ac0,
    $6b80, $ab41, $6900, $a9c1, $a881, $6840, $7800, $b8c1, $b981, $7940, $bb01,
    $7bc0, $7a80, $ba41, $be01, $7ec0, $7f80, $bf41, $7d00, $bdc1, $bc81, $7c40,
    $b401, $74c0, $7580, $b541, $7700, $b7c1, $b681, $7640, $7200, $b2c1, $b381,
    $7340, $b101, $71c0, $7080, $b041, $5000, $90c1, $9181, $5140, $9301, $53c0,
    $5280, $9241, $9601, $56c0, $5780, $9741, $5500, $95c1, $9481, $5440, $9c01,
    $5cc0, $5d80, $9d41, $5f00, $9fc1, $9e81, $5e40, $5a00, $9ac1, $9b81, $5b40,
    $9901, $59c0, $5880, $9841, $8801, $48c0, $4980, $8941, $4b00, $8bc1, $8a81,
    $4a40, $4e00, $8ec1, $8f81, $4f40, $8d01, $4dc0, $4c80, $8c41, $4400, $84c1,
    $8581, $4540, $8701, $47c0, $4680, $8641, $8201, $42c0, $4380, $8341, $4100,
    $81c1, $8081, $4040
  );
  var i: TG2IntS32;
  var pb: PG2IntU8Arr absolute Value;
begin
  Result := 0;
  for i := 0 to Count - 1 do
  Result := (Result shr 8) xor CRC16Table[pb^[i] xor (Result and $ff)];
end;

function G2CRC32(const Value: Pointer; const Count: TG2IntS32): TG2IntU32;
  const CRC32Table: array[0..255] of TG2IntU32 = (
    $00000000, $77073096, $ee0e612c, $990951ba, $076dc419, $706af48f, $e963a535,
    $9e6495a3, $0edb8832, $79dcb8a4, $e0d5e91e, $97d2d988, $09b64c2b, $7eb17cbd,
    $e7b82d07, $90bf1d91, $1db71064, $6ab020f2, $f3b97148, $84be41de, $1adad47d,
    $6ddde4eb, $f4d4b551, $83d385c7, $136c9856, $646ba8c0, $fd62f97a, $8a65c9ec,
    $14015c4f, $63066cd9, $fa0f3d63, $8d080df5, $3b6e20c8, $4c69105e, $d56041e4,
    $a2677172, $3c03e4d1, $4b04d447, $d20d85fd, $a50ab56b, $35b5a8fa, $42b2986c,
    $dbbbc9d6, $acbcf940, $32d86ce3, $45df5c75, $dcd60dcf, $abd13d59, $26d930ac,
    $51de003a, $c8d75180, $bfd06116, $21b4f4b5, $56b3c423, $cfba9599, $b8bda50f,
    $2802b89e, $5f058808, $c60cd9b2, $b10be924, $2f6f7c87, $58684c11, $c1611dab,
    $b6662d3d, $76dc4190, $01db7106, $98d220bc, $efd5102a, $71b18589, $06b6b51f,
    $9fbfe4a5, $e8b8d433, $7807c9a2, $0f00f934, $9609a88e, $e10e9818, $7f6a0dbb,
    $086d3d2d, $91646c97, $e6635c01, $6b6b51f4, $1c6c6162, $856530d8, $f262004e,
    $6c0695ed, $1b01a57b, $8208f4c1, $f50fc457, $65b0d9c6, $12b7e950, $8bbeb8ea,
    $fcb9887c, $62dd1ddf, $15da2d49, $8cd37cf3, $fbd44c65, $4db26158, $3ab551ce,
    $a3bc0074, $d4bb30e2, $4adfa541, $3dd895d7, $a4d1c46d, $d3d6f4fb, $4369e96a,
    $346ed9fc, $ad678846, $da60b8d0, $44042d73, $33031de5, $aa0a4c5f, $dd0d7cc9,
    $5005713c, $270241aa, $be0b1010, $c90c2086, $5768b525, $206f85b3, $b966d409,
    $ce61e49f, $5edef90e, $29d9c998, $b0d09822, $c7d7a8b4, $59b33d17, $2eb40d81,
    $b7bd5c3b, $c0ba6cad, $edb88320, $9abfb3b6, $03b6e20c, $74b1d29a, $ead54739,
    $9dd277af, $04db2615, $73dc1683, $e3630b12, $94643b84, $0d6d6a3e, $7a6a5aa8,
    $e40ecf0b, $9309ff9d, $0a00ae27, $7d079eb1, $f00f9344, $8708a3d2, $1e01f268,
    $6906c2fe, $f762575d, $806567cb, $196c3671, $6e6b06e7, $fed41b76, $89d32be0,
    $10da7a5a, $67dd4acc, $f9b9df6f, $8ebeeff9, $17b7be43, $60b08ed5, $d6d6a3e8,
    $a1d1937e, $38d8c2c4, $4fdff252, $d1bb67f1, $a6bc5767, $3fb506dd, $48b2364b,
    $d80d2bda, $af0a1b4c, $36034af6, $41047a60, $df60efc3, $a867df55, $316e8eef,
    $4669be79, $cb61b38c, $bc66831a, $256fd2a0, $5268e236, $cc0c7795, $bb0b4703,
    $220216b9, $5505262f, $c5ba3bbe, $b2bd0b28, $2bb45a92, $5cb36a04, $c2d7ffa7,
    $b5d0cf31, $2cd99e8b, $5bdeae1d, $9b64c2b0, $ec63f226, $756aa39c, $026d930a,
    $9c0906a9, $eb0e363f, $72076785, $05005713, $95bf4a82, $e2b87a14, $7bb12bae,
    $0cb61b38, $92d28e9b, $e5d5be0d, $7cdcefb7, $0bdbdf21, $86d3d2d4, $f1d4e242,
    $68ddb3f8, $1fda836e, $81be16cd, $f6b9265b, $6fb077e1, $18b74777, $88085ae6,
    $ff0f6a70, $66063bca, $11010b5c, $8f659eff, $f862ae69, $616bffd3, $166ccf45,
    $a00ae278, $d70dd2ee, $4e048354, $3903b3c2, $a7672661, $d06016f7, $4969474d,
    $3e6e77db, $aed16a4a, $d9d65adc, $40df0b66, $37d83bf0, $a9bcae53, $debb9ec5,
    $47b2cf7f, $30b5ffe9, $bdbdf21c, $cabac28a, $53b39330, $24b4a3a6, $bad03605,
    $cdd70693, $54de5729, $23d967bf, $b3667a2e, $c4614ab8, $5d681b02, $2a6f2b94,
    $b40bbe37, $c30c8ea1, $5a05df1b, $2d02ef8d
  );
  var i: TG2IntS32;
  var pb: PG2IntU8Arr absolute Value;
begin
  Result := $ffffffff;
  for i := 0 to Count - 1 do
  Result := ((Result shr 8) and $00ffffff) xor CRC32Table[(Result xor pb^[i]) and $ff];
  Result := Result xor $ffffffff;
end;

function G2Adler32(const Adler: TG2IntU32; const Buffer: Pointer; const Len: TG2IntU32): TG2IntU32;
  const BASE = TG2IntU32(65521);
  const NMAX = 3854;
  var s1, s2: TG2IntU32;
  var k: TG2IntS32;
  var b: PG2IntU32;
  var l: TG2IntU32;
begin
  if Buffer = nil then
  begin
    Result := 1;
    exit;
  end;
  b := Buffer;
  l := Len;
  s1 := Adler and $ffff;
  s2 := (Adler shr 16) and $ffff;
  while (l > 0) do
  begin
    if l < NMAX then k := l
    else k := NMAX;
    Dec(l, k);
    while (k > 0) do
    begin
      Inc(s1, b^);
      Inc(s2, s1);
      Inc(b);
      Dec(k);
    end;
    s1 := s1 mod BASE;
    s2 := s2 mod BASE;
  end;
  Result := (s2 shl 16) or s1;
end;

{$Warnings off}
function G2FileSearch(const Path: String; const Attribs: TG2IntS32): TG2QuickListAnsiString;
  var sr: TSearchRec;
begin
  Result.Clear;
  if FindFirst(Path, Attribs, sr) = 0 then
  begin
    repeat
      Result.Add(sr.Name);
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;
{$Warnings on}

function G2PathRelative(const Origin: String; const Target: String): String;
  var StrOrigin, StrTarget: String;
  var DirsOrigin: TG2StrArrA;
  var DirsTarget: TG2StrArrA;
  var i, mi, n: Integer;
begin
  StrOrigin := ExpandFileName(G2StrReplace(Origin, G2PathSepRev, G2PathSep));
  StrTarget := ExpandFileName(G2StrReplace(Target, G2PathSepRev, G2PathSep));
  DirsOrigin := G2StrExplode(StrOrigin, G2PathSep);
  DirsTarget := G2StrExplode(StrTarget, G2PathSep);
  for i := High(DirsOrigin) downto 0 do
  begin
    if Length(DirsOrigin[i]) = 0 then
    begin
      for n := i to High(DirsOrigin) - 1 do
      DirsOrigin[n] := DirsOrigin[n + 1];
      SetLength(DirsOrigin, Length(DirsOrigin) - 1);
    end;
  end;
  for i := High(DirsTarget) downto 0 do
  begin
    if Length(DirsTarget[i]) = 0 then
    begin
      for n := i to High(DirsTarget) - 1 do
      DirsTarget[n] := DirsTarget[n + 1];
      SetLength(DirsTarget, Length(DirsTarget) - 1);
    end;
  end;
  if (Length(DirsOrigin) = 0)
  or (Length(DirsTarget) = 0) then
  begin
    Result := Target;
    Exit;
  end;
  if LowerCase(DirsOrigin[0]) <> LowerCase(DirsTarget[0]) then
  begin
    Result := Target;
    Exit;
  end;
  i := 0;
  mi := G2Min(TG2IntS32(Length(DirsOrigin)), TG2IntS32(Length(DirsTarget)));
  while (LowerCase(DirsOrigin[i]) = LowerCase(DirsTarget[i])) and (i < mi) do i += 1;
  Result := '';
  for n := i to High(DirsTarget) do
  if Length(DirsTarget[n]) > 0 then
  begin
    if Length(Result) > 0 then Result := Result + G2PathSep + DirsTarget[n]
    else Result := Result + DirsTarget[n];
  end;
  for n := i to High(DirsOrigin) do
  if Length(DirsOrigin[n]) > 0 then
  Result := '..' + G2PathSep + Result;
  if Length(Result) = 0 then Result := '.' + G2PathSep;
end;

function G2PathNoExt(const Path: String): String;
  var i, n: Integer;
begin
  for i := Length(Path) downto 1 do
  if Path[i] = '.' then
  begin
    n := i - 1;
    SetLength(Result, n);
    if n > 0 then Move(Path[1], Result[1], n);
    Exit;
  end;
  Result := Path;
end;

function G2PathClean(const Path: String): String;
  var EditPath: String;
  var PathArr: TG2StrArrA;
  var skip, i, n: Integer;
begin
  EditPath := G2StrReplace(Path, G2PathSepRev, G2PathSep);
  PathArr := G2StrExplode(EditPath, G2PathSep);
  for i := High(PathArr) downto 0 do
  begin
    if Length(PathArr[i]) = 0 then
    begin
      for n := i to High(PathArr) - 1 do
      PathArr[n] := PathArr[n + 1];
      SetLength(PathArr, Length(PathArr) - 1);
    end;
  end;
  skip := 0;
  Result := '';
  for i := High(PathArr) downto 0 do
  begin
    if PathArr[i] = '..' then
    Inc(skip)
    else if skip > 0 then
    Dec(skip)
    else
    begin
      if Length(Result) > 0 then
      Result := PathArr[i] + G2PathSep + Result
      else
      Result := PathArr[i];
    end;
  end;
  for i := 0 to skip - 1 do
  Result := '..' + G2PathSep + Result;
end;

function G2RemoveDir(const DirPath: String): Boolean;
  function AppendPathDelim(const Path: String): String;
  begin
    if (Path <> '') and (Path[Length(Path)] <> PathDelim) then
    Result := Path + PathDelim
    else
    Result := Path;
  end;
  function CleanAndExpandDirectory(const Filename: string): string;
  begin
    Result := AppendPathDelim(SysUtils.ExpandFileName(Filename));
  end;
  var sr: TSearchRec;
  var CurSrcDir: String;
  var CurFilename: String;
begin
  Result := False;
  CurSrcDir := CleanAndExpandDirectory(DirPath);
  if FindFirst(CurSrcDir + '*', faAnyFile, sr) = 0 then
  begin
    repeat
      if (sr.Name = '.') or (sr.Name = '..') or (sr.Name = '') then
      Continue;
      CurFilename := CurSrcDir + sr.Name;
      if (sr.Attr and faReadOnly) > 0 then
      FileSetAttr(CurFilename, sr.Attr - faReadOnly);
      if (sr.Attr and faDirectory)>0 then
      begin
        if not G2RemoveDir(CurFilename) then Exit;
      end
      else
      begin
        if not DeleteFile(CurFilename) then Exit;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
  if not RemoveDir(DirPath) then Exit;
  Result := True;
end;

function G2StrCut(const Str: AnsiString; const SubStart, SubEnd: TG2IntS32): AnsiString;
  var i, l: TG2IntS32;
begin
  if SubEnd < SubStart then
  begin
    Result := '';
    Exit;
  end;
  l := SubEnd - SubStart + 1;
  SetLength(Result, l);
  for i := 0 to l - 1 do
  Result[i + 1] := Str[SubStart + i];
end;

function G2StrExplode(const Str: AnsiString; const Separator: AnsiString): TG2StrArrA;
  var i, j: TG2IntS32;
  var CurElement: TG2IntS32;
  var PrevParamIndex: TG2IntS32;
  var b: Boolean;
begin
  if Length(Separator) < 1 then
  begin
    SetLength(Result, 1);
    Result[0] := Str;
    Exit;
  end;
  Result := nil;
  SetLength(Result, Length(Str) + 1);
  CurElement := 0;
  PrevParamIndex := 1;
  for i := 1 to Length(Str) do
  begin
    b := True;
    for j := 0 to Length(Separator) - 1 do
    begin
      if Separator[j + 1] <> Str[i + j] then
      begin
        b := False;
        Break;
      end;
    end;
    if b then
    begin
      SetLength(Result[CurElement], i - PrevParamIndex);
      Move(Str[PrevParamIndex], Result[CurElement][1], i - PrevParamIndex);
      PrevParamIndex := i + Length(Separator);
      Inc(CurElement);
    end;
  end;
  if Length(Str) >= PrevParamIndex then
  begin
    SetLength(Result[CurElement], Length(Str) - PrevParamIndex + 1);
    Move(Str[PrevParamIndex], Result[CurElement][1], Length(Str) - PrevParamIndex + 1);
    Inc(CurElement);
  end
  else
  begin
    Result[CurElement] := '';
    Inc(CurElement);
  end;
  SetLength(Result, CurElement);
end;

function G2StrParam(const Str: AnsiString; const Separator: AnsiString; const Param: TG2IntS32): AnsiString;
  var i, j: TG2IntS32;
  var CurParam: TG2IntS32;
  var PrevParamIndex: TG2IntS32;
  var b: Boolean;
begin
  Result := '';
  b := False;
  CurParam := 0;
  PrevParamIndex := 1;
  for i := 1 to Length(Str) do
  begin
    for j := 1 to Length(Separator) do
    begin
      if Str[i + j] <> Separator[j] then
      Break
      else
      begin
        if j = Length(Separator) then
        begin
          if CurParam = Param then
          begin
            b := True;
            SetLength(Result, i - PrevParamIndex + 1);
            move(Str[PrevParamIndex], Result[1], Length(Result));
          end
          else
          begin
            CurParam := CurParam + 1;
            PrevParamIndex := i + Length(Separator) + 1;
          end;
        end;
      end;
    end;
    if b then Break;
    if (i = Length(Str)) and (CurParam = Param) then
    begin
      SetLength(Result, i - PrevParamIndex + 1);
      Move(Str[PrevParamIndex], Result[1], Length(Result));
    end;
  end;
end;

function G2StrParamCount(const Str: AnsiString; const Separator: AnsiString): TG2IntS32;
  var i, j: TG2IntS32;
  var DoInc: Boolean;
begin
  if Length(Str) <= 0 then
  begin
    Result := 0;
    Exit;
  end;
  Result := 1;
  for i := 1 to Length(Str) - Length(Separator) do
  begin
    DoInc := True;
    for j := 1 to Length(Separator) do
    if Str[i + j - 1] <> Separator[j] then
    begin
      DoInc := False;
      Break;
    end;
    if DoInc then
    Result := Result + 1;
  end;
end;

function G2StrInStr(const Str: AnsiString; SubStr: AnsiString): TG2IntS32;
  var i: TG2IntS32;
begin
  if Length(SubStr) > 0 then
  begin
    for i := 1 to Length(Str) + 1 - Length(SubStr) do
    if CompareMem(@Str[i], @SubStr[1], Length(SubStr)) then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := 0;
end;

function G2StrReplace(const Str, PatternOld, PatternNew: AnsiString): AnsiString;
  var StrArr: TG2StrArrA;
  var i, n: Integer;
begin
  if (Length(PatternOld) > 0) and (Length(Str) > 0) then
  begin
    StrArr := G2StrExplode(Str, PatternOld);
    SetLength(Result, Length(Str) + Length(PatternNew) * Length(StrArr));
    n := 1;
    for i := 0 to High(StrArr) - 1 do
    begin
      Move(StrArr[i][1], Result[n], Length(StrArr[i]));
      Inc(n, Length(StrArr[i]));
      Move(PatternNew[1], Result[n], Length(PatternNew));
      Inc(n, Length(PatternNew));
    end;
    i := High(StrArr);
    Move(StrArr[i][1], Result[n], Length(StrArr[i]));
    Inc(n, Length(StrArr[i]));
    SetLength(Result, n - 1);
  end
  else
  Result := Str;
end;

function G2StrTrim(const Str: AnsiString): AnsiString;
  var i, i0, i1: TG2IntS32;
begin
  i0 := 0;
  for i := 1 to Length(Str) do
  if Str[i] <> ' ' then
  begin
    i0 := i;
    Break;
  end;
  if i0 = 0 then Exit('');
  i1 := Length(Str);
  for i := Length(Str) downto 1 do
  if Str[i] <> ' ' then
  begin
    i1 := i;
    Break;
  end;
  i := i1 - i0 + 1;
  SetLength(Result, i);
  Move(Str[i0], Result[1], i);
end;

function G2StrSubstitute(const Str: AnsiString; const Start, ReplaceCount: TG2IntS32; const ReplaceStr: AnsiString): AnsiString;
begin
  SetLength(Result, Length(Str) - ReplaceCount + Length(ReplaceStr));
  if Start > 0 then
  begin
    Move(Str[1], Result[1], Start);
  end;
  Move(ReplaceStr[1], Result[Start + 1], Length(ReplaceStr));
  Move(Str[Start + ReplaceCount + 1], Result[Start + Length(ReplaceStr) + 1], Length(Str) - (Start + ReplaceCount));
end;

procedure G2EncDec(const Ptr: PG2IntU8Arr; const Count: TG2IntS32; const Key: AnsiString);
  var i: TG2IntS32;
begin
  for i := 0 to Count - 1 do
  Ptr^[i] := Ptr^[i] xor Ord(Key[(i mod Length(Key)) + 1]);
end;

function G2CmpObjFuncPtr(const Ptr0, Ptr1: Pointer): Boolean;
  type TDblPtr = array[0..1] of Pointer;
  type PDblPtr = ^TDblPtr;
begin
  Result := (
    (PDblPtr(Ptr0)^[0] = PDblPtr(Ptr1)^[0])
    and (PDblPtr(Ptr0)^[1] = PDblPtr(Ptr1)^[1])
  );
end;

{$if defined(G2Target_iOS)}
function G2NSStr(const a: AnsiString): NSString;
begin
  if a = '' then Result := NSString.alloc.init
  else Result := NSString.alloc.initWithCString(@a[1]);
end;
{$endif}

function G2MemAlloc(const Size: TG2IntU32): Pointer;
begin
  Result := GetMem(Size);
end;

procedure G2MemFree(var Mem: Pointer; const Size: TG2IntU32);
begin
  FreeMem(Mem, Size);
end;

{$if defined(G2Target_Windows)}
  function LibOpen(Name: PAnsiChar): TG2DynLib; stdcall; external 'kernel32.dll' name 'LoadLibraryA';
  function LibClose(Handle: TG2DynLib): Boolean; stdcall; external 'kernel32.dll' name 'FreeLibrary';
  function LibAddress(Handle: TG2DynLib; ProcName: PAnsiChar): Pointer; stdcall; external 'kernel32.dll' name 'GetProcAddress';
{$elseif defined(G2Target_Linux) or defined(G2Target_OSX) or defined(G2Target_Android) or defined(G2Target_iOS)}
  function LibOpen(Name: PAnsiChar; Flags: LongInt): TG2DynLib; cdecl; external 'dl' name 'dlopen';
  function LibClose(Handle: TG2DynLib): LongInt; cdecl; external 'dl' name 'dlclose';
  function LibAddress(Handle: TG2DynLib; ProcName: PAnsiChar): Pointer; cdecl; external 'dl' name 'dlsym';
{$endif}

function G2DynLibOpen(const Name: AnsiString): TG2DynLib;
begin
  Result := TG2DynLib(LibOpen(PAnsiChar(Name){$if defined(G2Target_Linux) or defined(G2Target_OSX) or defined(G2Target_Android) or defined(G2Target_iOS)}, 1{$endif}));
end;

procedure G2DynLibClose(const Handle: TG2DynLib);
begin
  LibClose(Handle);
end;

function G2DynLibAddress(const Handle: TG2DynLib; const Name: AnsiString): Pointer;
begin
  Result := LibAddress(Handle, PAnsiChar(Name));
end;

end.

