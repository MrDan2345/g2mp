{   Unicode tables unit.

    Copyright (c) 2013 by Inoussa OUEDRAOGO

    The source code is distributed under the Library GNU
    General Public License with the following modification:

        - object files and libraries linked into an application may be
          distributed without source code.

    If you didn't receive a copy of the file COPYING, contact:
          Free Software Foundation
          675 Mass Ave
          Cambridge, MA  02139
          USA

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

-------------------------------------------------------------------------------

  Overview of the Unicode Collation Algorithm(UCA) data layout :
  ============================================================

    The UCA data(see “TUCA_DataBook”) are organized into index data
    (see the “TUCA_DataBook” fields “BMP_Table1”, “BMP_Table2”,
    “OBMP_Table1” and “OBMP_Table2”) and actual properties data(see
    the “Props” field of  “TUCA_DataBook”). The index is a 3 level
    tables designed to minimize the overhaul data size. The
    properties’ data contain the actual (used) UCA’s properties
    for the customized code points(or sequence of code points)
    data (see TUCA_PropItemRec).
    To get the properties’ record of a code point, one goes
    through the index data to get its offset into the “Props”
    serialized data, see the “GetPropUCA” procedure.
    The “TUCA_PropItemRec” record, that represents the actual
    properties, contains a fixed part and a variable part. The
    fixed part is directly expressed as fields of the record :
      “WeightLength”, “ChildCount”, “Size”, “Flags”. The
    variable part depends on some values of the fixed part; For
    example “WeightLength” specify the number of weight[1] item,
    it can be zero or not null; The “Flags” fields does contains
    some bit states to indicate for example if the record’s owner,
    that is the target code point, is present(it is not always
    necessary to store the code point as you are required to have
    this information in the first place in order to get the
    “TUCA_PropItemRec” record).

    The data, as it is organized now, is as follow for each code point :
      * the fixed part is serialized,
      * if there are weight item array, they are serialized
          (see the "WeigthLength")
      * the code point is serialized (if needed)
      * the context[2] array is serialized
      * The children[3] record are serialized.

    The “Size” represent the size of the whole record, including its
    children records(see [3]). The “GetSelfOnlySize” returns the size
    of the queried record, excluding the size of its children.


    Notes :

    [1] : A weight item is an array of 3 words. A code point/sequence of code
          point may have zero or multiple items.

    [2] :  There are characters(mostly japanese ones) that do not have their
           own weighs; There inherit the weights of the preceding character
           in the string that you will be evaluating.
    [3] :  Some unicode characters are expressed using more than one code point.
           In that case the properties records are serialized as a trie. The
           trie data structure is useful when many characters’ expression have
           the same starting code point(s).

    [4] TUCA_PropItemRec serialization :
            TUCA_PropItemRec :
              WeightLength, ChildCount, Size, Flags [weight item array]
    [Code Point] [Context data]
              [Child 0] [Child 1] .. [Child n]

        each [Child k] is a TUCA_PropItemRec.
}

unit unicodedata;
{$mode delphi}
{$H+}
{$PACKENUM 1}
{$SCOPEDENUMS ON}
{$pointermath on}
{$define USE_INLINE}
{$warn 4056 off}  //Conversion between ordinals and pointers is not portable
{ $define uni_debug}

interface

const
  MAX_WORD = High(Word);
  LOW_SURROGATE_BEGIN  = Word($DC00);
  LOW_SURROGATE_END    = Word($DFFF);

  HIGH_SURROGATE_BEGIN = Word($D800);
  HIGH_SURROGATE_END   = Word($DBFF);
  HIGH_SURROGATE_COUNT = HIGH_SURROGATE_END - HIGH_SURROGATE_BEGIN + 1;
  UCS4_HALF_BASE       = LongWord($10000);
  UCS4_HALF_MASK       = Word($3FF);
  MAX_LEGAL_UTF32      = $10FFFF;

const
    // Unicode General Category
    UGC_UppercaseLetter         = 0;
    UGC_LowercaseLetter         = 1;
    UGC_TitlecaseLetter         = 2;
    UGC_ModifierLetter          = 3;
    UGC_OtherLetter             = 4;

    UGC_NonSpacingMark          = 5;
    UGC_CombiningMark           = 6;
    UGC_EnclosingMark           = 7;

    UGC_DecimalNumber           = 8;
    UGC_LetterNumber            = 9;
    UGC_OtherNumber             = 10;

    UGC_ConnectPunctuation      = 11;
    UGC_DashPunctuation         = 12;
    UGC_OpenPunctuation         = 13;
    UGC_ClosePunctuation        = 14;
    UGC_InitialPunctuation      = 15;
    UGC_FinalPunctuation        = 16;
    UGC_OtherPunctuation        = 17;

    UGC_MathSymbol              = 18;
    UGC_CurrencySymbol          = 19;
    UGC_ModifierSymbol          = 20;
    UGC_OtherSymbol             = 21;

    UGC_SpaceSeparator          = 22;
    UGC_LineSeparator           = 23;
    UGC_ParagraphSeparator      = 24;

    UGC_Control                 = 25;
    UGC_Format                  = 26;
    UGC_Surrogate               = 27;
    UGC_PrivateUse              = 28;
    UGC_Unassigned              = 29;

type

  TUInt24Rec = packed record
  public
  {$ifdef FPC_LITTLE_ENDIAN}
    byte0, byte1, byte2 : Byte;
  {$else FPC_LITTLE_ENDIAN}
    byte2, byte1, byte0 : Byte;
  {$endif FPC_LITTLE_ENDIAN}
  public
    class operator Implicit(a : TUInt24Rec) : Cardinal;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator Implicit(a : TUInt24Rec) : LongInt;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator Implicit(a : TUInt24Rec) : Word;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator Implicit(a : TUInt24Rec) : Byte;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator Implicit(a : Cardinal) : TUInt24Rec;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator Equal(a, b: TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}

    class operator Equal(a : TUInt24Rec; b : Cardinal): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator Equal(a : Cardinal; b : TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}

    class operator Equal(a : TUInt24Rec; b : LongInt): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator Equal(a : LongInt; b : TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}

    class operator Equal(a : TUInt24Rec; b : Word): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator Equal(a : Word; b : TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}

    class operator Equal(a : TUInt24Rec; b : Byte): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator Equal(a : Byte; b : TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}

    class operator NotEqual(a, b: TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator NotEqual(a : TUInt24Rec; b : Cardinal): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator NotEqual(a : Cardinal; b : TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator GreaterThan(a, b: TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator GreaterThan(a : TUInt24Rec; b : Cardinal): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator GreaterThan(a : Cardinal; b : TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator GreaterThanOrEqual(a, b: TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator GreaterThanOrEqual(a : TUInt24Rec; b : Cardinal): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator GreaterThanOrEqual(a : Cardinal; b : TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator LessThan(a, b: TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator LessThan(a : TUInt24Rec; b : Cardinal): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator LessThan(a : Cardinal; b : TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator LessThanOrEqual(a, b: TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator LessThanOrEqual(a : TUInt24Rec; b : Cardinal): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
    class operator LessThanOrEqual(a : Cardinal; b : TUInt24Rec): Boolean;{$ifdef USE_INLINE}inline;{$ENDIF}
  end;

  UInt24 = TUInt24Rec;
  PUInt24 = ^UInt24;

const
  ZERO_UINT24 : UInt24 =
  {$ifdef FPC_LITTLE_ENDIAN}
    (byte0 : 0; byte1 : 0; byte2 : 0;);
  {$else FPC_LITTLE_ENDIAN}
    (byte2 : 0; byte1 : 0; byte0 : 0;);
  {$endif FPC_LITTLE_ENDIAN}

type
  PUC_Prop = ^TUC_Prop;

  { TUC_Prop }

  { On alignment-sensitive targets, at least some of them, assembler uses to forcibly align data >1 byte.
    This breaks intended layout of initialized constants/variables.
    A proper solution is to patch compiler to emit always unaligned directives for words/dwords/etc,
    but for now just declare this record as "unpacked". This causes bloat, but it's better than having
    entire unit not working at all. }
  TUC_Prop = {$ifndef FPC_REQUIRES_PROPER_ALIGNMENT}packed{$endif} record
  private
    function GetCategory : Byte;inline;
    procedure SetCategory(AValue : Byte);
    function GetWhiteSpace : Boolean;inline;
    procedure SetWhiteSpace(AValue : Boolean);
    function GetHangulSyllable : Boolean;inline;
    procedure SetHangulSyllable(AValue : Boolean);
    function GetNumericValue: Double;inline;
  public
    CategoryData    : Byte;
  public
    CCC             : Byte;
    NumericIndex    : Byte;
    SimpleUpperCase : UInt24;
    SimpleLowerCase : UInt24;
    DecompositionID : SmallInt;
  public
    property Category : Byte read GetCategory write SetCategory;
    property WhiteSpace : Boolean read GetWhiteSpace write SetWhiteSpace;
    property HangulSyllable : Boolean read GetHangulSyllable write SetHangulSyllable;
    property NumericValue : Double read GetNumericValue;
  end;

type
  TUCA_PropWeights = packed record
    Weights  : array[0..2] of Word;
  end;
  PUCA_PropWeights = ^TUCA_PropWeights;


  TUCA_PropItemContextRec = packed record
  public
    CodePointCount : Byte;
    WeightCount    : Byte;
  public
    function GetCodePoints() : PUInt24;inline;
    function GetWeights() : PUCA_PropWeights;inline;
  end;
  PUCA_PropItemContextRec = ^TUCA_PropItemContextRec;

  PUCA_PropItemContextTreeNodeRec = ^TUCA_PropItemContextTreeNodeRec;
  TUCA_PropItemContextTreeNodeRec = packed record
  public
    Left    : Word;
    Right   : Word;
    Data    : TUCA_PropItemContextRec;
  public
    function GetLeftNode() : PUCA_PropItemContextTreeNodeRec;inline;
    function GetRightNode() : PUCA_PropItemContextTreeNodeRec;inline;
  end;


  { TUCA_PropItemContextTreeRec }

  TUCA_PropItemContextTreeRec = packed record
  public
    Size : UInt24;
  public
    function GetData:PUCA_PropItemContextTreeNodeRec;inline;
    property Data : PUCA_PropItemContextTreeNodeRec read GetData;

    function Find(
      const AChars     : PUInt24;
      const ACharCount : Integer;
      out   ANode      : PUCA_PropItemContextTreeNodeRec
    ) : Boolean;
  end;
  PUCA_PropItemContextTreeRec = ^TUCA_PropItemContextTreeRec;

  { TUCA_PropItemRec }

  TUCA_PropItemRec = packed record
  private
    const FLAG_VALID      = 0;
    const FLAG_CODEPOINT  = 1;
    const FLAG_CONTEXTUAL = 2;
    const FLAG_DELETION   = 3;
    const FLAG_COMPRESS_WEIGHT_1 = 6;
    const FLAG_COMPRESS_WEIGHT_2 = 7;
  private
    function GetCodePoint() : UInt24;inline;
  public
    WeightLength : Byte;
    ChildCount   : Byte;
    Size         : Word;
    Flags        : Byte;
  public
    function HasCodePoint() : Boolean;inline;
    property CodePoint : UInt24 read GetCodePoint;
    //Weights    : array[0..WeightLength] of TUCA_PropWeights;

    function IsValid() : Boolean;inline;
    //function GetWeightArray() : PUCA_PropWeights;inline;
    procedure GetWeightArray(ADest : PUCA_PropWeights);
    function GetSelfOnlySize() : Cardinal;inline;

    function GetContextual() : Boolean;inline;
    property Contextual : Boolean read GetContextual;
    function GetContext() : PUCA_PropItemContextTreeRec;

    function IsDeleted() : Boolean;inline;
    function IsWeightCompress_1() : Boolean;inline;
    function IsWeightCompress_2() : Boolean;inline;
  end;
  PUCA_PropItemRec = ^TUCA_PropItemRec;

  TUCA_VariableKind = (
    ucaShifted, ucaNonIgnorable, ucaBlanked, ucaShiftedTrimmed,
    ucaIgnoreSP // This one is not implemented !
  );

  TCollationName = string[128];

  PUCA_DataBook = ^TUCA_DataBook;
  TUCA_DataBook = record
  public
    Base               : PUCA_DataBook;
    Version            : TCollationName;
    CollationName      : TCollationName;
    VariableWeight     : TUCA_VariableKind;
    Backwards          : array[0..3] of Boolean;
    BMP_Table1         : PByte;
    BMP_Table2         : PUInt24;
    OBMP_Table1        : PWord;
    OBMP_Table2        : PUInt24;
    PropCount          : Integer;
    Props              : PUCA_PropItemRec;
    VariableLowLimit   : Word;
    VariableHighLimit  : Word;
    Dynamic            : Boolean;
  public
    function IsVariable(const AWeight : PUCA_PropWeights) : Boolean; inline;
  end;

  TCollationField = (BackWard, VariableLowLimit, VariableHighLimit);
  TCollationFields = set of TCollationField;

const
  ROOT_COLLATION_NAME = 'DUCET';
  ERROR_INVALID_CODEPOINT_SEQUENCE = 1;

  procedure FromUCS4(const AValue : UCS4Char; var AHighS, ALowS : UnicodeChar);inline;
  function ToUCS4(const AHighS, ALowS : UnicodeChar) : UCS4Char;inline;
  function UnicodeIsSurrogatePair(
    const AHighSurrogate,
          ALowSurrogate   : UnicodeChar
  ) : Boolean;inline;
  function UnicodeIsHighSurrogate(const AValue : UnicodeChar) : Boolean;inline;
  function UnicodeIsLowSurrogate(const AValue : UnicodeChar) : Boolean;inline;
  function UnicodeToUpper(
    const AString                : UnicodeString;
    const AIgnoreInvalidSequence : Boolean;
    out   AResultString          : UnicodeString
  ) : Integer;
  function UnicodeToLower(
    const AString                : UnicodeString;
    const AIgnoreInvalidSequence : Boolean;
    out   AResultString          : UnicodeString
  ) : Integer;

  function GetProps(const ACodePoint : Word) : PUC_Prop;overload;inline;
  function GetProps(const AHighS, ALowS : UnicodeChar): PUC_Prop;overload;inline;
  function GetProps(const ACodePoint : Cardinal) : PUC_Prop;overload;inline;
  function GetPropUCA(const AHighS, ALowS : UnicodeChar; const ABook : PUCA_DataBook): PUCA_PropItemRec; inline; overload;
  function GetPropUCA(const AChar : UnicodeChar; const ABook : PUCA_DataBook) : PUCA_PropItemRec; inline; overload;


  function NormalizeNFD(const AString : UnicodeString) : UnicodeString;inline;overload;
  function NormalizeNFD(const AStr : PUnicodeChar; ALength : SizeInt) : UnicodeString;overload;
  procedure CanonicalOrder(var AString : UnicodeString);inline;overload;
  procedure CanonicalOrder(AStr : PUnicodeChar; const ALength : SizeInt);overload;

type
  TUCASortKeyItem = Word;
  TUCASortKey = array of TUCASortKeyItem;
  function ComputeSortKey(
    const AString    : UnicodeString;
    const ACollation : PUCA_DataBook
  ) : TUCASortKey;inline;overload;
  function ComputeSortKey(
    const AStr       : PUnicodeChar;
    const ALength    : SizeInt;
    const ACollation : PUCA_DataBook
  ) : TUCASortKey;overload;
  function CompareSortKey(const A, B : TUCASortKey) : Integer;overload;
  function CompareSortKey(const A : TUCASortKey; const B : array of Word) : Integer;overload;
  function IncrementalCompareString(
    const AStrA      : PUnicodeChar;
    const ALengthA   : SizeInt;
    const AStrB      : PUnicodeChar;
    const ALengthB   : SizeInt;
    const ACollation : PUCA_DataBook
  ) : Integer;overload;
  function IncrementalCompareString(
    const AStrA,
          AStrB      : UnicodeString;
    const ACollation : PUCA_DataBook
  ) : Integer;inline;overload;

  function RegisterCollation(const ACollation : PUCA_DataBook) : Boolean;overload;
  function RegisterCollation(
    const ADirectory,
          ALanguage : string
  ) : Boolean;overload;
  function UnregisterCollation(const AName : ansistring): Boolean;
  procedure UnregisterCollations(const AFreeDynamicCollations : Boolean);
  function FindCollation(const AName : ansistring): PUCA_DataBook;overload;
  function FindCollation(const AIndex : Integer): PUCA_DataBook;overload;
  function GetCollationCount() : Integer;
  procedure PrepareCollation(
          ACollation     : PUCA_DataBook;
    const ABaseName      : ansistring;
    const AChangedFields : TCollationFields
  );
  function LoadCollation(
    const AData       : Pointer;
    const ADataLength : Integer
  ) : PUCA_DataBook;overload;
  function LoadCollation(const AFileName : string) : PUCA_DataBook;overload;
  function LoadCollation(
    const ADirectory,
          ALanguage : string
  ) : PUCA_DataBook;overload;
  procedure FreeCollation(AItem : PUCA_DataBook);

type
  TEndianKind = (Little, Big);
const
  ENDIAN_SUFFIX : array[TEndianKind] of string[2] = ('le','be');
{$IFDEF ENDIAN_LITTLE}
  ENDIAN_NATIVE     = TEndianKind.Little;
  ENDIAN_NON_NATIVE = TEndianKind.Big;
{$ENDIF ENDIAN_LITTLE}
{$IFDEF ENDIAN_BIG}
  ENDIAN_NATIVE = TEndianKind.Big;
  ENDIAN_NON_NATIVE = TEndianKind.Little;
{$ENDIF ENDIAN_BIG}

resourcestring
  SCollationNotFound = 'Collation not found : "%s".';

implementation
uses
  unicodenumtable;

type

  TCardinalRec = packed record
  {$ifdef FPC_LITTLE_ENDIAN}
    byte0, byte1, byte2, byte3 : Byte;
  {$else FPC_LITTLE_ENDIAN}
    byte3, byte2, byte1, byte0 : Byte;
  {$endif FPC_LITTLE_ENDIAN}
  end;

  TWordRec = packed record
  {$ifdef FPC_LITTLE_ENDIAN}
    byte0, byte1 : Byte;
  {$else FPC_LITTLE_ENDIAN}
    byte1, byte0 : Byte;
  {$endif FPC_LITTLE_ENDIAN}
  end;

{ TUInt24Rec }

class operator TUInt24Rec.Implicit(a : TUInt24Rec) : Cardinal;
begin
  TCardinalRec(Result).byte0 := a.byte0;
  TCardinalRec(Result).byte1 := a.byte1;
  TCardinalRec(Result).byte2 := a.byte2;
  TCardinalRec(Result).byte3 := 0;
end;

class operator TUInt24Rec.Implicit(a : TUInt24Rec) : LongInt;
begin
  Result := Cardinal(a);
end;

class operator TUInt24Rec.Implicit(a : TUInt24Rec) : Word;
begin
{$IFOPT R+}
  if (a > $FFFF) then
    Error(reIntOverflow);
{$ENDIF R+}
  TWordRec(Result).byte0 := a.byte0;
  TWordRec(Result).byte1 := a.byte1;
end;

class operator TUInt24Rec.Implicit(a : TUInt24Rec) : Byte;
begin
{$IFOPT R+}
  if (a > $FF) then
    Error(reIntOverflow);
{$ENDIF R+}
  Result := a.byte0;
end;

class operator TUInt24Rec.Implicit(a : Cardinal) : TUInt24Rec;
begin
{$IFOPT R+}
  if (a > $FFFFFF) then
    Error(reIntOverflow);
{$ENDIF R+}
  Result.byte0 := TCardinalRec(a).byte0;
  Result.byte1 := TCardinalRec(a).byte1;
  Result.byte2 := TCardinalRec(a).byte2;
end;

class operator TUInt24Rec.Equal(a, b : TUInt24Rec) : Boolean;
begin
  Result := (a.byte0 = b.byte0) and (a.byte1 = b.byte1) and (a.byte2 = b.byte2);
end;

class operator TUInt24Rec.Equal(a : TUInt24Rec; b : Cardinal) : Boolean;
begin
  Result := (TCardinalRec(b).byte3 = 0) and
            (a.byte0 = TCardinalRec(b).byte0) and
            (a.byte1 = TCardinalRec(b).byte1) and
            (a.byte2 = TCardinalRec(b).byte2);
end;

class operator TUInt24Rec.Equal(a : Cardinal; b : TUInt24Rec) : Boolean;
begin
  Result := (b = a);
end;

class operator TUInt24Rec.Equal(a : TUInt24Rec; b : LongInt) : Boolean;
begin
  Result := (LongInt(a) = b);
end;

class operator TUInt24Rec.Equal(a : LongInt; b : TUInt24Rec) : Boolean;
begin
  Result := (b = a);
end;

class operator TUInt24Rec.Equal(a : TUInt24Rec; b : Word) : Boolean;
begin
  Result := (a.byte2 = 0) and
            (a.byte0 = TWordRec(b).byte0) and
            (a.byte1 = TWordRec(b).byte1);
end;

class operator TUInt24Rec.Equal(a : Word; b : TUInt24Rec) : Boolean;
begin
  Result := (b = a);
end;

class operator TUInt24Rec.Equal(a : TUInt24Rec; b : Byte) : Boolean;
begin
  Result := (a.byte2 = 0) and
            (a.byte1 = 0) and
            (a.byte0 = b);
end;

class operator TUInt24Rec.Equal(a : Byte; b : TUInt24Rec) : Boolean;
begin
  Result := (b = a);
end;

class operator TUInt24Rec.NotEqual(a, b : TUInt24Rec) : Boolean;
begin
  Result := (a.byte0 <> b.byte0) or (a.byte1 <> b.byte1) or (a.byte2 <> b.byte2);
end;

class operator TUInt24Rec.NotEqual(a : TUInt24Rec; b : Cardinal) : Boolean;
begin
  Result := (TCardinalRec(b).byte3 <> 0) or
            (a.byte0 <> TCardinalRec(b).byte0) or
            (a.byte1 <> TCardinalRec(b).byte1) or
            (a.byte2 <> TCardinalRec(b).byte2);
end;

class operator TUInt24Rec.NotEqual(a : Cardinal; b : TUInt24Rec) : Boolean;
begin
  Result := (b <> a);
end;

class operator TUInt24Rec.GreaterThan(a, b: TUInt24Rec): Boolean;
begin
  Result := (a.byte2 > b.byte2) or
            ((a.byte2 = b.byte2) and (a.byte1 > b.byte1)) or
            ((a.byte2 = b.byte2) and (a.byte1 = b.byte1) and (a.byte0 > b.byte0));
end;

class operator TUInt24Rec.GreaterThan(a: TUInt24Rec; b: Cardinal): Boolean;
begin
  Result := Cardinal(a) > b;
end;

class operator TUInt24Rec.GreaterThan(a: Cardinal; b: TUInt24Rec): Boolean;
begin
  Result := a > Cardinal(b);
end;

class operator TUInt24Rec.GreaterThanOrEqual(a, b: TUInt24Rec): Boolean;
begin
  Result := (a.byte2 > b.byte2) or
            ((a.byte2 = b.byte2) and (a.byte1 > b.byte1)) or
            ((a.byte2 = b.byte2) and (a.byte1 = b.byte1) and (a.byte0 >= b.byte0));
end;

class operator TUInt24Rec.GreaterThanOrEqual(a: TUInt24Rec; b: Cardinal): Boolean;
begin
  Result := Cardinal(a) >= b;
end;

class operator TUInt24Rec.GreaterThanOrEqual(a: Cardinal; b: TUInt24Rec): Boolean;
begin
  Result := a >= Cardinal(b);
end;

class operator TUInt24Rec.LessThan(a, b: TUInt24Rec): Boolean;
begin
  Result := (b > a);
end;

class operator TUInt24Rec.LessThan(a: TUInt24Rec; b: Cardinal): Boolean;
begin
  Result := Cardinal(a) < b;
end;

class operator TUInt24Rec.LessThan(a: Cardinal; b: TUInt24Rec): Boolean;
begin
  Result := a < Cardinal(b);
end;

class operator TUInt24Rec.LessThanOrEqual(a, b: TUInt24Rec): Boolean;
begin
  Result := (b >= a);
end;

class operator TUInt24Rec.LessThanOrEqual(a: TUInt24Rec; b: Cardinal): Boolean;
begin
  Result := Cardinal(a) <= b;
end;

class operator TUInt24Rec.LessThanOrEqual(a: Cardinal; b: TUInt24Rec): Boolean;
begin
  Result := a <= Cardinal(b);
end;

type
  TBitOrder = 0..7;
function IsBitON(const AData : Byte; const ABit : TBitOrder) : Boolean ;inline;
begin
  Result := ( ( AData and ( 1 shl ABit ) ) <> 0 );
end;

procedure SetBit(var AData : Byte; const ABit : TBitOrder; const AValue : Boolean);inline;
begin
  if AValue then
    AData := AData or (1 shl (ABit mod 8))
  else
    AData := AData and ( not ( 1 shl ( ABit mod 8 ) ) );
end;

var
  CollationTable : array of PUCA_DataBook;
function IndexOfCollation(const AName : string) : Integer;
var
  i, c : Integer;
  p : Pointer;
begin
  c := Length(AName);
  p := @AName[1];
  for i := 0 to Length(CollationTable) - 1 do begin
    if (Length(CollationTable[i]^.CollationName) = c) and
       (CompareByte((CollationTable[i]^.CollationName[1]),p^,c)=0)
    then
      exit(i);
  end;
  Result := -1;
end;

function RegisterCollation(const ACollation : PUCA_DataBook) : Boolean;
var
  i : Integer;
begin
  Result := (IndexOfCollation(ACollation^.CollationName) = -1);
  if Result then begin
    i := Length(CollationTable);
    SetLength(CollationTable,(i+1));
    CollationTable[i] := ACollation;
  end;
end;

function RegisterCollation(const ADirectory, ALanguage : string) : Boolean;
var
  cl : PUCA_DataBook;
begin
  cl := LoadCollation(ADirectory,ALanguage);
  if (cl = nil) then
    exit(False);
  try
    Result := RegisterCollation(cl);
  except
    FreeCollation(cl);
    raise;
  end;
  if not Result then
    FreeCollation(cl);
end;

function UnregisterCollation(const AName : ansistring): Boolean;
var
  i, c : Integer;
begin
  i := IndexOfCollation(AName);
  Result := (i >= 0);
  if Result then begin
    c := Length(CollationTable);
    if (c = 1) then begin
      SetLength(CollationTable,0);
    end else begin
      CollationTable[i] := CollationTable[c-1];
      SetLength(CollationTable,(c-1));
    end;
  end;
end;

procedure UnregisterCollations(const AFreeDynamicCollations : Boolean);
var
  i : Integer;
  cl : PUCA_DataBook;
begin
  if AFreeDynamicCollations then begin
    for i := Low(CollationTable) to High(CollationTable) do begin
      if CollationTable[i].Dynamic then begin
        cl := CollationTable[i];
        CollationTable[i] := nil;
        FreeCollation(cl);
      end;
    end;
  end;
  SetLength(CollationTable,0);
end;

function FindCollation(const AName : ansistring): PUCA_DataBook;overload;
var
  i : Integer;
begin
  i := IndexOfCollation(AName);
  if (i = -1) then
    Result := nil
  else
    Result := CollationTable[i];
end;

function GetCollationCount() : Integer;
begin
  Result := Length(CollationTable);
end;

function FindCollation(const AIndex : Integer): PUCA_DataBook;overload;
begin
  if (AIndex < 0) or (AIndex >= Length(CollationTable)) then
    Result := nil
  else
    Result := CollationTable[AIndex];
end;

procedure PrepareCollation(
        ACollation     : PUCA_DataBook;
  const ABaseName      : ansistring;
  const AChangedFields : TCollationFields
);
var
  s : ansistring;
  p, base : PUCA_DataBook;
begin
  if (ABaseName <> '') then
    s := ABaseName
  else
    s := ROOT_COLLATION_NAME;
  p := ACollation;
  base := FindCollation(s);
  if (base = nil) then
    Error(reCodesetConversion);
  p^.Base := base;
  if not(TCollationField.BackWard in AChangedFields) then
    p^.Backwards := base^.Backwards;
  if not(TCollationField.VariableLowLimit in AChangedFields) then
    p^.VariableLowLimit := base^.VariableLowLimit;
  if not(TCollationField.VariableHighLimit in AChangedFields) then
    p^.VariableLowLimit := base^.VariableHighLimit;
end;

type
  TSerializedCollationHeader = packed record
    Base               : TCollationName;
    Version            : TCollationName;
    CollationName      : TCollationName;
    VariableWeight     : Byte;
    Backwards          : Byte;
    BMP_Table1Length   : DWord;
    BMP_Table2Length   : DWord;
    OBMP_Table1Length  : DWord;
    OBMP_Table2Length  : DWord;
    PropCount          : DWord;
    VariableLowLimit   : Word;
    VariableHighLimit  : Word;
    ChangedFields      : Byte;
  end;
  PSerializedCollationHeader = ^TSerializedCollationHeader;

procedure FreeCollation(AItem : PUCA_DataBook);
var
  h : PSerializedCollationHeader;
begin
  if (AItem = nil) or not(AItem^.Dynamic) then
    exit;
  h := PSerializedCollationHeader(PtrUInt(AItem) + SizeOf(TUCA_DataBook));
  if (AItem^.BMP_Table1 <> nil) then
    FreeMem(AItem^.BMP_Table1,h^.BMP_Table1Length);
  if (AItem^.BMP_Table2 <> nil) then
    FreeMem(AItem^.BMP_Table2,h^.BMP_Table2Length);
  if (AItem^.OBMP_Table1 <> nil) then
    FreeMem(AItem^.OBMP_Table1,h^.OBMP_Table1Length);
  if (AItem^.OBMP_Table2 <> nil) then
    FreeMem(AItem^.OBMP_Table2,h^.OBMP_Table2Length);
  if (AItem^.Props <> nil) then
    FreeMem(AItem^.Props,h^.PropCount);
  FreeMem(AItem,(SizeOf(TUCA_DataBook)+SizeOf(TSerializedCollationHeader)));
end;

function LoadCollation(
  const AData       : Pointer;
  const ADataLength : Integer
) : PUCA_DataBook;
var
  dataPointer : PByte;
  readedLength : LongInt;

  function ReadBuffer(ADest : Pointer; ALength : LongInt) : Boolean;
  begin
    Result := (readedLength + ALength) <= ADataLength;
    if not result then
      exit;
    Move(dataPointer^,ADest^,ALength);
    Inc(dataPointer,ALength);
    readedLength := readedLength + ALength;
  end;

var
  r : PUCA_DataBook;
  h : PSerializedCollationHeader;
  cfs : TCollationFields;
  i : Integer;
  baseName : TCollationName;
begin
  readedLength := 0;
  dataPointer := AData;
  r := AllocMem((SizeOf(TUCA_DataBook)+SizeOf(TSerializedCollationHeader)));
  try
    h := PSerializedCollationHeader(PtrUInt(r) + SizeOf(TUCA_DataBook));
    if not ReadBuffer(h,SizeOf(TSerializedCollationHeader)) then
      exit;
    r^.Version := h^.Version;
    r^.CollationName := h^.CollationName;
    r^.VariableWeight := TUCA_VariableKind(h^.VariableWeight);
    r^.Backwards[0] := IsBitON(h^.Backwards,0);
    r^.Backwards[1] := IsBitON(h^.Backwards,1);
    r^.Backwards[2] := IsBitON(h^.Backwards,2);
    r^.Backwards[3] := IsBitON(h^.Backwards,3);
    if (h^.BMP_Table1Length > 0) then begin
      r^.BMP_Table1 := GetMem(h^.BMP_Table1Length);
        if not ReadBuffer(r^.BMP_Table1,h^.BMP_Table1Length) then
          exit;
    end;
    if (h^.BMP_Table2Length > 0) then begin
      r^.BMP_Table2 := GetMem(h^.BMP_Table2Length);
        if not ReadBuffer(r^.BMP_Table2,h^.BMP_Table2Length) then
          exit;
    end;
    if (h^.OBMP_Table1Length > 0) then begin
      r^.OBMP_Table1 := GetMem(h^.OBMP_Table1Length);
        if not ReadBuffer(r^.OBMP_Table1,h^.OBMP_Table1Length) then
          exit;
    end;
    if (h^.OBMP_Table2Length > 0) then begin
      r^.OBMP_Table2 := GetMem(h^.OBMP_Table2Length);
        if not ReadBuffer(r^.OBMP_Table2,h^.OBMP_Table2Length) then
          exit;
    end;
    r^.PropCount := h^.PropCount;
    if (h^.PropCount > 0) then begin
      r^.Props := GetMem(h^.PropCount);
        if not ReadBuffer(r^.Props,h^.PropCount) then
          exit;
    end;
    r^.VariableLowLimit := h^.VariableLowLimit;
    r^.VariableHighLimit := h^.VariableHighLimit;

    cfs := [];
    for i := Ord(Low(TCollationField)) to Ord(High(TCollationField)) do begin
      if IsBitON(h^.ChangedFields,i) then
        cfs := cfs + [TCollationField(i)];
    end;
    if (h^.Base <> '') then
      baseName := h^.Base
    else if (h^.CollationName <> ROOT_COLLATION_NAME) then
      baseName := ROOT_COLLATION_NAME
    else
      baseName := '';
    if (baseName <> '') then
      PrepareCollation(r,baseName,cfs);
    r^.Dynamic := True;
    Result := r;
  except
    FreeCollation(r);
    raise;
  end;
end;

{$PUSH}
function LoadCollation(const AFileName : string) : PUCA_DataBook;
const
  BLOCK_SIZE = 16*1024;
var
  f : File of Byte;
  locSize, locReaded, c : LongInt;
  locBuffer : PByte;
  locBlockSize : LongInt;
begin
  Result := nil;
{$I-}
  if (AFileName = '') then
    exit;
  Assign(f,AFileName);
  Reset(f);
  try
    if (IOResult <> 0) then
      exit;
    locSize := FileSize(f);
    if (locSize < SizeOf(TSerializedCollationHeader)) then
      exit;
    locBuffer := GetMem(locSize);
    try
      locBlockSize := BLOCK_SIZE;
      locReaded := 0;
      while (locReaded < locSize) do begin
        if (locBlockSize > (locSize-locReaded)) then
          locBlockSize := locSize-locReaded;
        BlockRead(f,locBuffer[locReaded],locBlockSize,c);
        if (IOResult <> 0) or (c <= 0) then
          exit;
        locReaded := locReaded + c;
      end;
      Result := LoadCollation(locBuffer,locSize);
    finally
      FreeMem(locBuffer,locSize);
    end;
  finally
    Close(f);
  end;
end;
{$POP}

function LoadCollation(const ADirectory, ALanguage : string) : PUCA_DataBook;
var
  fileName : string;
begin
  fileName := ADirectory;
  if (fileName <> '') then begin
    if (fileName[Length(fileName)] <> DirectorySeparator) then
      fileName := fileName + DirectorySeparator;
  end;
  fileName := fileName + 'collation_' + ALanguage + '_' + ENDIAN_SUFFIX[ENDIAN_NATIVE] + '.bco';
  Result := LoadCollation(fileName);
end;

{$INCLUDE unicodedata.inc}
{$IFDEF ENDIAN_LITTLE}
  {$INCLUDE unicodedata_le.inc}
{$ENDIF ENDIAN_LITTLE}
{$IFDEF ENDIAN_BIG}
  {$INCLUDE unicodedata_be.inc}
{$ENDIF ENDIAN_BIG}

procedure FromUCS4(const AValue : UCS4Char; var AHighS, ALowS : UnicodeChar);inline;
begin
  AHighS := UnicodeChar((AValue - $10000) shr 10 + $d800);
  ALowS := UnicodeChar((AValue - $10000) and $3ff + $dc00);
end;

function ToUCS4(const AHighS, ALowS : UnicodeChar) : UCS4Char;inline;
begin
  Result := (UCS4Char(Word(AHighS)) - HIGH_SURROGATE_BEGIN) shl 10 +
            (UCS4Char(Word(ALowS)) - LOW_SURROGATE_BEGIN) + UCS4_HALF_BASE;
end;

function UnicodeIsSurrogatePair(
  const AHighSurrogate,
        ALowSurrogate   : UnicodeChar
) : Boolean;
begin
  Result :=
    ( (Word(AHighSurrogate) >= HIGH_SURROGATE_BEGIN) and
      (Word(AHighSurrogate) <= HIGH_SURROGATE_END)
    ) and
    ( (Word(ALowSurrogate) >= LOW_SURROGATE_BEGIN) and
      (Word(ALowSurrogate) <= LOW_SURROGATE_END)
    )
end;

function UnicodeIsHighSurrogate(const AValue : UnicodeChar) : Boolean;
begin
  Result := (Word(AValue) >= HIGH_SURROGATE_BEGIN) and
            (Word(AValue) <= HIGH_SURROGATE_END);
end;

function UnicodeIsLowSurrogate(const AValue : UnicodeChar) : Boolean;
begin
  Result := (Word(AValue) >= LOW_SURROGATE_BEGIN) and
            (Word(AValue) <= LOW_SURROGATE_END);
end;

function GetProps(const ACodePoint : Word) : PUC_Prop;overload;inline;
begin
  Result:=
    @UC_PROP_ARRAY[
       UC_TABLE_3[
         UC_TABLE_2[UC_TABLE_1[hi(ACodePoint)]]
           [lo(ACodePoint) shr 4]
       ][lo(ACodePoint) and $F]
     ];    {
    @UC_PROP_ARRAY[
       UC_TABLE_2[
         (UC_TABLE_1[WordRec(ACodePoint).Hi] * 256) +
         WordRec(ACodePoint).Lo
       ]
     ];}
end;

function GetProps(const AHighS, ALowS : UnicodeChar): PUC_Prop;overload;inline;
begin
  Result:=
    @UC_PROP_ARRAY[
       UCO_TABLE_3[
         UCO_TABLE_2[UCO_TABLE_1[Word(AHighS)-HIGH_SURROGATE_BEGIN]]
           [(Word(ALowS) - LOW_SURROGATE_BEGIN) div 32]
       ][(Word(ALowS) - LOW_SURROGATE_BEGIN) mod 32]
     ];    {
  Result:=
    @UC_PROP_ARRAY[
       UCO_TABLE_2[
         (UCO_TABLE_1[Word(AHighS)-HIGH_SURROGATE_BEGIN] * HIGH_SURROGATE_COUNT) +
         Word(ALowS) - LOW_SURROGATE_BEGIN
       ]
     ]; }
end;

function GetProps(const ACodePoint : Cardinal) : PUC_Prop;inline;
var
  l, h : UnicodeChar;
begin
  if (ACodePoint <= High(Word)) then
    exit(GetProps(Word(ACodePoint)));
  FromUCS4(ACodePoint,h,l);
  Result := GetProps(h,l);
end;

function UnicodeToUpper(
  const AString                : UnicodeString;
  const AIgnoreInvalidSequence : Boolean;
  out   AResultString          : UnicodeString
) : Integer;
var
  i, c : SizeInt;
  pp, pr : PUnicodeChar;
  pu : PUC_Prop;
  locIsSurrogate : Boolean;
  r : UnicodeString;
begin
  c := Length(AString);
  SetLength(r,2*c);
  if (c > 0) then begin
    pp := @AString[1];
    pr := @r[1];
    i := 1;
    while (i <= c) do begin
      pu := GetProps(Word(pp^));
      locIsSurrogate := (pu^.Category = UGC_Surrogate);
      if locIsSurrogate then begin
        if (i = c) or not(UnicodeIsSurrogatePair(pp[0],pp[1])) then begin
          if AIgnoreInvalidSequence then begin
            pr^ := pp^;
            Inc(pp);
            Inc(pr);
            Inc(i);
            Continue;
          end;
          exit(ERROR_INVALID_CODEPOINT_SEQUENCE);
        end;
        pu := GetProps(pp^,AString[i+1]);
      end;
      if (pu^.SimpleUpperCase = 0) then begin
        pr^ := pp^;
        if locIsSurrogate then begin
          Inc(pp);
          Inc(pr);
          Inc(i);
          pr^ := pp^;
        end;
      end else begin
        if (pu^.SimpleUpperCase <= $FFFF) then begin
          pr^ := UnicodeChar(Word(pu^.SimpleUpperCase));
        end else begin
          FromUCS4(UCS4Char(Cardinal(pu^.SimpleUpperCase)),pr^,PUnicodeChar(PtrUInt(pr)+SizeOf(UnicodeChar))^);
          Inc(pr);
        end;
        if locIsSurrogate then begin
          Inc(pp);
          Inc(i);
        end;
      end;
      Inc(pp);
      Inc(pr);
      Inc(i);
    end;
    Dec(pp);
    i := ((PtrUInt(pr) - PtrUInt(@r[1])) div SizeOf(UnicodeChar));
    SetLength(r,i);
    AResultString := r;
  end;
  Result := 0;
end;

function UnicodeToLower(
  const AString                : UnicodeString;
  const AIgnoreInvalidSequence : Boolean;
  out   AResultString          : UnicodeString
) : Integer;
var
  i, c : SizeInt;
  pp, pr : PUnicodeChar;
  pu : PUC_Prop;
  locIsSurrogate : Boolean;
  r : UnicodeString;
begin
  c := Length(AString);
  SetLength(r,2*c);
  if (c > 0) then begin
    pp := @AString[1];
    pr := @r[1];
    i := 1;
    while (i <= c) do begin
      pu := GetProps(Word(pp^));
      locIsSurrogate := (pu^.Category = UGC_Surrogate);
      if locIsSurrogate then begin
        if (i = c) or not(UnicodeIsSurrogatePair(pp[0],pp[1])) then begin
          if AIgnoreInvalidSequence then begin
            pr^ := pp^;
            Inc(pp);
            Inc(pr);
            Inc(i);
            Continue;
          end;
          exit(ERROR_INVALID_CODEPOINT_SEQUENCE);
        end;
        pu := GetProps(pp^,AString[i+1]);
      end;
      if (pu^.SimpleLowerCase = 0) then begin
        pr^ := pp^;
        if locIsSurrogate then begin
          Inc(pp);
          Inc(pr);
          Inc(i);
          pr^ := pp^;
        end;
      end else begin
        if (pu^.SimpleLowerCase <= $FFFF) then begin
          pr^ := UnicodeChar(Word(pu^.SimpleLowerCase));
        end else begin
          FromUCS4(UCS4Char(Cardinal(pu^.SimpleLowerCase)),pr^,PUnicodeChar(PtrUInt(pr)+SizeOf(UnicodeChar))^);
          Inc(pr);
        end;
        if locIsSurrogate then begin
          Inc(pp);
          Inc(i);
        end;
      end;
      Inc(pp);
      Inc(pr);
      Inc(i);
    end;
    Dec(pp);
    i := ((PtrUInt(pr) - PtrUInt(@r[1])) div SizeOf(UnicodeChar));
    SetLength(r,i);
    AResultString := r;
  end;
  Result := 0;
end;

//----------------------------------------------------------------------
function DecomposeHangul(const AChar : Cardinal; ABuffer : PCardinal) : Integer;
const
  SBase  = $AC00;
  LBase  = $1100;
  VBase  = $1161;
  TBase  = $11A7;
  LCount = 19;
  VCount = 21;
  TCount = 28;
  NCount = VCount * TCount;   // 588
  SCount = LCount * NCount;   // 11172
var
  SIndex, L, V, T : Integer;
begin
  SIndex := AChar - SBase;
  if (SIndex < 0) or (SIndex >= SCount) then begin
    ABuffer^ := AChar;
    exit(1);
  end;
  L := LBase + SIndex div NCount;
  V := VBase + (SIndex mod NCount) div TCount;
  T := TBase + SIndex mod TCount;
  ABuffer[0] := L;
  ABuffer[1] := V;
  Result := 2;
  if (T <> TBase) then begin
    ABuffer[2] := T;
    Inc(Result);
  end;
end;

function Decompose(const ADecomposeIndex : Integer; ABuffer : PUnicodeChar) : Integer;
var
  locStack : array[0..23] of Cardinal;
  locStackIdx : Integer;
  ResultBuffer : array[0..23] of Cardinal;
  ResultIdx : Integer;

  procedure AddCompositionToStack(const AIndex : Integer);
  var
    pdecIdx : ^TDecompositionIndexRec;
    k, kc : Integer;
    pu : ^UInt24;
  begin
    pdecIdx := @(UC_DEC_BOOK_DATA.Index[AIndex]);
    pu := @(UC_DEC_BOOK_DATA.CodePoints[pdecIdx^.StartPosition]);
    kc := pdecIdx^.Length;
    Inc(pu,kc);
    for k := 1 to kc do begin
      Dec(pu);
      locStack[locStackIdx + k] := pu^;
    end;
    locStackIdx := locStackIdx + kc;
  end;

  procedure AddResult(const AChar : Cardinal);inline;
  begin
    Inc(ResultIdx);
    ResultBuffer[ResultIdx] := AChar;
  end;

  function PopStack() : Cardinal;inline;
  begin
    Result := locStack[locStackIdx];
    Dec(locStackIdx);
  end;

var
  cu : Cardinal;
  decIdx : SmallInt;
  locIsWord : Boolean;
  i : Integer;
  p : PUnicodeChar;
begin
  ResultIdx := -1;
  locStackIdx := -1;
  AddCompositionToStack(ADecomposeIndex);
  while (locStackIdx >= 0) do begin
    cu := PopStack();
    locIsWord := (cu <= MAX_WORD);
    if locIsWord then
      decIdx := GetProps(Word(cu))^.DecompositionID
    else
      decIdx := GetProps(cu)^.DecompositionID;
    if (decIdx = -1) then
      AddResult(cu)
    else
      AddCompositionToStack(decIdx);
  end;
  p := ABuffer;
  Result := 0;
  for i := 0 to ResultIdx do begin
    cu := ResultBuffer[i];
    if (cu <= MAX_WORD) then begin
      p[0] := UnicodeChar(Word(cu));
      Inc(p);
    end else begin
      FromUCS4(cu,p[0],p[1]);
      Inc(p,2);
      Inc(Result);
    end;
  end;
  Result := Result + ResultIdx + 1;
end;

procedure CanonicalOrder(var AString : UnicodeString);
begin
  CanonicalOrder(@AString[1],Length(AString));
end;

procedure CanonicalOrder(AStr : PUnicodeChar; const ALength : SizeInt);
var
  i, c : SizeInt;
  p, q : PUnicodeChar;
  locIsSurrogateP, locIsSurrogateQ : Boolean;

  procedure Swap();
  var
    t, t1 : UnicodeChar;
  begin
    if not locIsSurrogateP then begin
      if not locIsSurrogateQ then begin
        t := p^;
        p^ := q^;
        q^ := t;
        exit;
      end;
      t := p^;
      p[0] := q[0];
      p[1] := q[1];
      q[1] := t;
      exit;
    end;
    if not locIsSurrogateQ then begin
      t := q[0];
      p[2] := p[1];
      p[1] := p[0];
      p[0] := t;
      exit;
    end;
    t := p[0];
    t1 := p[1];
    p[0] := q[0];
    p[1] := q[1];
    q[0] := t;
    q[1] := t1;
  end;

var
  pu : PUC_Prop;
  cccp, cccq : Byte;
begin
  c := ALength;
  if (c < 2) then
    exit;
  p := AStr;
  i := 1;
  while (i < c) do begin
    pu := GetProps(Word(p^));
    locIsSurrogateP := (pu^.Category = UGC_Surrogate);
    if locIsSurrogateP then begin
      if (i = (c - 1)) then
        Break;
      if not UnicodeIsSurrogatePair(p[0],p[1]) then begin
        Inc(p);
        Inc(i);
        Continue;
      end;
      pu := GetProps(p[0],p[1]);
    end;
    if (pu^.CCC > 0) then begin
      cccp := pu^.CCC;
      if locIsSurrogateP then
        q := p + 2
      else
        q := p + 1;
      pu := GetProps(Word(q^));
      locIsSurrogateQ := (pu^.Category = UGC_Surrogate);
      if locIsSurrogateQ then begin
        if (i = c) then
          Break;
        if not UnicodeIsSurrogatePair(q[0],q[1]) then begin
          Inc(p);
          Inc(i);
          Continue;
        end;
        pu := GetProps(q[0],q[1]);
      end;
      cccq := pu^.CCC;
      if (cccq > 0) and (cccp > cccq) then begin
        Swap();
        if (i > 1) then begin
          Dec(p);
          Dec(i);
          pu := GetProps(Word(p^));
          if (pu^.Category = UGC_Surrogate) then begin
            if (i > 1) then begin
              Dec(p);
              Dec(i);
            end;
          end;
          Continue;
        end;
      end;
    end;
    if locIsSurrogateP then begin
      Inc(p);
      Inc(i);
    end;
    Inc(p);
    Inc(i);
  end;
end;

//Canonical Decomposition
function NormalizeNFD(const AString : UnicodeString) : UnicodeString;
begin
  Result := NormalizeNFD(@AString[1],Length(AString));
end;

function NormalizeNFD(const AStr : PUnicodeChar; ALength : SizeInt) : UnicodeString;
const MAX_EXPAND = 3;
var
  i, c, kc, k : SizeInt;
  pp, pr : PUnicodeChar;
  pu : PUC_Prop;
  locIsSurrogate : Boolean;
  cpArray : array[0..7] of Cardinal;
  cp : Cardinal;
begin
  c := ALength;
  SetLength(Result,(MAX_EXPAND*c));
  if (c > 0) then begin
    pp := AStr;
    pr := @Result[1];
    i := 1;
    while (i <= c) do begin
      pu := GetProps(Word(pp^));
      locIsSurrogate := (pu^.Category = UGC_Surrogate);
      if locIsSurrogate then begin
        if (i = c) then
          Break;
        if not UnicodeIsSurrogatePair(pp[0],pp[1]) then begin
          pr^ := pp^;
          Inc(pp);
          Inc(pr);
          Inc(i);
          Continue;
        end;
        pu := GetProps(pp[0],pp[1]);
      end;
      if pu^.HangulSyllable then begin
        if locIsSurrogate then begin
          cp := ToUCS4(pp[0],pp[1]);
          Inc(pp);
          Inc(i);
        end else begin
          cp := Word(pp^);
        end;
        kc := DecomposeHangul(cp,@cpArray[0]);
        for k := 0 to kc - 1 do begin
          if (cpArray[k] <= MAX_WORD) then begin
            pr^ := UnicodeChar(Word(cpArray[k]));
            pr := pr + 1;
          end else begin
            FromUCS4(cpArray[k],pr[0],pr[1]);
            pr := pr + 2;
          end;
        end;
        if (kc > 0) then
          Dec(pr);
      end else begin
        if (pu^.DecompositionID = -1) then begin
          pr^ := pp^;
          if locIsSurrogate then begin
            Inc(pp);
            Inc(pr);
            Inc(i);
            pr^ := pp^;
          end;
        end else begin
          k := Decompose(pu^.DecompositionID,pr);
          pr := pr + (k - 1);
          if locIsSurrogate then begin
            Inc(pp);
            Inc(i);
          end;
        end;
      end;
      Inc(pp);
      Inc(pr);
      Inc(i);
    end;
    Dec(pp);
    i := ((PtrUInt(pr) - PtrUInt(@Result[1])) div SizeOf(UnicodeChar));
    SetLength(Result,i);
    CanonicalOrder(@Result[1],Length(Result));
  end;
end;

{ TUCA_PropItemContextTreeNodeRec }

function TUCA_PropItemContextTreeNodeRec.GetLeftNode: PUCA_PropItemContextTreeNodeRec;
begin
  if (Self.Left = 0) then
    Result := nil
  else
    Result := PUCA_PropItemContextTreeNodeRec(PtrUInt(@Self) + Self.Left);
end;

function TUCA_PropItemContextTreeNodeRec.GetRightNode: PUCA_PropItemContextTreeNodeRec;
begin
  if (Self.Right = 0) then
    Result := nil
  else
    Result := PUCA_PropItemContextTreeNodeRec(PtrUInt(@Self) + Self.Right);
end;

{ TUCA_PropItemContextRec }

function TUCA_PropItemContextRec.GetCodePoints() : PUInt24;
begin
  Result := PUInt24(
              PtrUInt(@Self) + SizeOf(Self.CodePointCount) +
              SizeOf(Self.WeightCount)
            );
end;

function TUCA_PropItemContextRec.GetWeights: PUCA_PropWeights;
begin
  Result := PUCA_PropWeights(
              PtrUInt(@Self) +
                SizeOf(Self.CodePointCount) + SizeOf(Self.WeightCount) +
                (Self.CodePointCount*SizeOf(UInt24))
            );
end;

{ TUCA_PropItemContextTreeRec }

function TUCA_PropItemContextTreeRec.GetData: PUCA_PropItemContextTreeNodeRec;
begin
  if (Size = 0) then
    Result := nil
  else
    Result := PUCA_PropItemContextTreeNodeRec(
                PtrUInt(
                  PtrUInt(@Self) + SizeOf(UInt24){Size}
                )
              );
end;

function CompareCodePoints(
  A : PUInt24; LA : Integer;
  B : PUInt24; LB : Integer
) : Integer;
var
  i, hb : Integer;
begin
  if (A = B) then
    exit(0);
  Result := 1;
  hb := LB - 1;
  for i := 0 to LA - 1 do begin
    if (i > hb) then
      exit;
    if (A[i] < B[i]) then
      exit(-1);
    if (A[i] > B[i]) then
      exit(1);
  end;
  if (LA = LB) then
    exit(0);
  exit(-1);
end;

function TUCA_PropItemContextTreeRec.Find(
  const AChars     : PUInt24;
  const ACharCount : Integer;
  out   ANode      : PUCA_PropItemContextTreeNodeRec
) : Boolean;
var
  t : PUCA_PropItemContextTreeNodeRec;
begin
  t := Data;
  while (t <> nil) do begin
    case CompareCodePoints(AChars,ACharCount,t^.Data.GetCodePoints(),t^.Data.CodePointCount) of
       0   : Break;
      -1   : t := t^.GetLeftNode();
      else
        t := t^.GetRightNode();
    end;
  end;
  Result := (t <> nil);
  if Result then
    ANode := t;
end;

{ TUC_Prop }

function TUC_Prop.GetCategory: Byte;
begin
  Result := Byte((CategoryData and Byte($F8)) shr 3);
end;

function TUC_Prop.GetNumericValue: Double;
begin
  Result := UC_NUMERIC_ARRAY[NumericIndex];
end;

procedure TUC_Prop.SetCategory(AValue: Byte);
begin
  CategoryData := Byte(CategoryData or Byte(AValue shl 3));
end;

function TUC_Prop.GetWhiteSpace: Boolean;
begin
  Result := IsBitON(CategoryData,0);
end;

procedure TUC_Prop.SetWhiteSpace(AValue: Boolean);
begin
  SetBit(CategoryData,0,AValue);
end;

function TUC_Prop.GetHangulSyllable: Boolean;
begin
  Result := IsBitON(CategoryData,1);
end;

procedure TUC_Prop.SetHangulSyllable(AValue: Boolean);
begin
   SetBit(CategoryData,1,AValue);
end;

{ TUCA_DataBook }

function TUCA_DataBook.IsVariable(const AWeight: PUCA_PropWeights): Boolean;
begin
  Result := (AWeight^.Weights[0] >= Self.VariableLowLimit) and
            (AWeight^.Weights[0] <= Self.VariableHighLimit);
end;

{ TUCA_PropItemRec }

function TUCA_PropItemRec.IsWeightCompress_1 : Boolean;
begin
  Result := IsBitON(Flags,FLAG_COMPRESS_WEIGHT_1);
end;

function TUCA_PropItemRec.IsWeightCompress_2 : Boolean;
begin
  Result := IsBitON(Flags,FLAG_COMPRESS_WEIGHT_2);
end;

function TUCA_PropItemRec.GetCodePoint() : UInt24;
begin
  if HasCodePoint() then begin
    if Contextual then
      Result := Unaligned(
                  PUInt24(
                    PtrUInt(@Self) + Self.GetSelfOnlySize()- SizeOf(UInt24) -
                    Cardinal(GetContext()^.Size)
                  )^
                )
    else
      Result := Unaligned(PUInt24(PtrUInt(@Self) + Self.GetSelfOnlySize() - SizeOf(UInt24))^)
  end else begin
  {$ifdef uni_debug}
    raise EUnicodeException.Create('TUCA_PropItemRec.GetCodePoint : "No code point available."');
  {$else uni_debug}
    Result := ZERO_UINT24;
  {$endif uni_debug}
  end
end;

function TUCA_PropItemRec.HasCodePoint() : Boolean;
begin
  Result := IsBitON(Flags,FLAG_CODEPOINT);
end;

function TUCA_PropItemRec.IsValid() : Boolean;
begin
  Result := IsBitON(Flags,FLAG_VALID);
end;

{function TUCA_PropItemRec.GetWeightArray: PUCA_PropWeights;
begin
  Result := PUCA_PropWeights(PtrUInt(@Self) + SizeOf(TUCA_PropItemRec));
end;}

procedure TUCA_PropItemRec.GetWeightArray(ADest: PUCA_PropWeights);
var
  c : Integer;
  p : PByte;
  pd : PUCA_PropWeights;
begin
  c := WeightLength;
  p := PByte(PtrUInt(@Self) + SizeOf(TUCA_PropItemRec));
  pd := ADest;
  pd^.Weights[0] := Unaligned(PWord(p)^);
  p := p + 2;
  if not IsWeightCompress_1() then begin
    pd^.Weights[1] := Unaligned(PWord(p)^);
    p := p + 2;
  end else begin
    pd^.Weights[1] := p^;
    p := p + 1;
  end;
  if not IsWeightCompress_2() then begin
    pd^.Weights[2] := Unaligned(PWord(p)^);
    p := p + 2;
  end else begin
    pd^.Weights[2] := p^;
    p := p + 1;
  end;
  if (c > 1) then
    Move(p^, (pd+1)^, ((c-1)*SizeOf(TUCA_PropWeights)));
end;

function TUCA_PropItemRec.GetSelfOnlySize() : Cardinal;
begin
  Result := SizeOf(TUCA_PropItemRec);
  if (WeightLength > 0) then begin
    Result := Result + (WeightLength * Sizeof(TUCA_PropWeights));
    if IsWeightCompress_1() then
      Result := Result - 1;
    if IsWeightCompress_2() then
      Result := Result - 1;
  end;
  if HasCodePoint() then
    Result := Result + SizeOf(UInt24);
  if Contextual then
    Result := Result + Cardinal(GetContext()^.Size);
end;

function TUCA_PropItemRec.GetContextual: Boolean;
begin
  Result := IsBitON(Flags,FLAG_CONTEXTUAL);
end;

function TUCA_PropItemRec.GetContext: PUCA_PropItemContextTreeRec;
var
  p : PtrUInt;
begin
  if not Contextual then
    exit(nil);
  p := PtrUInt(@Self) + SizeOf(TUCA_PropItemRec);
  if IsBitON(Flags,FLAG_CODEPOINT) then
    p := p + SizeOf(UInt24);
  Result := PUCA_PropItemContextTreeRec(p);
end;

function TUCA_PropItemRec.IsDeleted() : Boolean;
begin
  Result := IsBitON(Flags,FLAG_DELETION);
end;


function GetPropUCA(const AChar : UnicodeChar; const ABook : PUCA_DataBook) : PUCA_PropItemRec;
var
  i : Cardinal;
begin
  if (ABook^.BMP_Table2 = nil) then
    exit(nil);
  i := ABook^.BMP_Table2[
         (ABook^.BMP_Table1[Hi(Word(AChar))] * 256) +
         Lo(Word(AChar))
       ];
  if (i > 0) then
    Result:= PUCA_PropItemRec(PtrUInt(ABook^.Props) + i - 1)
  else
    Result := nil;
end;

function GetPropUCA(const AHighS, ALowS : UnicodeChar; const ABook : PUCA_DataBook): PUCA_PropItemRec;
var
  i : Cardinal;
begin
  if (ABook^.OBMP_Table2 = nil) then
    exit(nil);
  i := ABook^.OBMP_Table2[
         (ABook^.OBMP_Table1[Word(AHighS)-HIGH_SURROGATE_BEGIN] * HIGH_SURROGATE_COUNT) +
         Word(ALowS) - LOW_SURROGATE_BEGIN
       ];
  if (i > 0) then
    Result:= PUCA_PropItemRec(PtrUInt(ABook^.Props) + i - 1)
  else
    Result := nil;
end;

{$include weight_derivation.inc}

function CompareSortKey(const A : TUCASortKey; const B : array of Word) : Integer;
var
  bb : TUCASortKey;
begin
  SetLength(bb,Length(B));
  if (Length(bb) > 0) then
    Move(B[0],bb[0],(Length(bb)*SizeOf(B[0])));
  Result := CompareSortKey(A,bb);
end;

function CompareSortKey(const A, B : TUCASortKey) : Integer;
var
  i, hb : Integer;
begin
  if (Pointer(A) = Pointer(B)) then
    exit(0);
  Result := 1;
  hb := Length(B) - 1;
  for i := 0 to Length(A) - 1 do begin
    if (i > hb) then
      exit;
    if (A[i] < B[i]) then
      exit(-1);
    if (A[i] > B[i]) then
      exit(1);
  end;
  if (Length(A) = Length(B)) then
    exit(0);
  exit(-1);
end;

type
  TUCA_PropWeightsArray = array of TUCA_PropWeights;
function FormKeyBlanked(const ACEList : TUCA_PropWeightsArray; const ACollation : PUCA_DataBook) : TUCASortKey;
var
  r : TUCASortKey;
  i, c, k, ral, levelCount : Integer;
  pce : PUCA_PropWeights;
begin
  c := Length(ACEList);
  if (c = 0) then
    exit(nil);
  levelCount := Length(ACEList[0].Weights);
  SetLength(r,(levelCount*c + levelCount));
  ral := 0;
  for i := 0 to levelCount - 1 do begin
    if not ACollation^.Backwards[i] then begin
      pce := @ACEList[0];
      for k := 0 to c - 1 do begin
        if not(ACollation^.IsVariable(pce)) and (pce^.Weights[i] <> 0) then begin
          r[ral] := pce^.Weights[i];
          ral := ral + 1;
        end;
        pce := pce + 1;
      end;
    end else begin
      pce := @ACEList[c-1];
      for k := 0 to c - 1 do begin
        if not(ACollation^.IsVariable(pce)) and (pce^.Weights[i] <> 0) then begin
          r[ral] := pce^.Weights[i];
          ral := ral + 1;
        end;
        pce := pce - 1;
      end;
    end;
    r[ral] := 0;
    ral := ral + 1;
  end;
  ral := ral - 1;
  SetLength(r,ral);
  Result := r;
end;

function FormKeyNonIgnorable(const ACEList : TUCA_PropWeightsArray; const ACollation : PUCA_DataBook) : TUCASortKey;
var
  r : TUCASortKey;
  i, c, k, ral, levelCount : Integer;
  pce : PUCA_PropWeights;
begin
  c := Length(ACEList);
  if (c = 0) then
    exit(nil);
  levelCount := Length(ACEList[0].Weights);
  SetLength(r,(levelCount*c + levelCount));
  ral := 0;
  for i := 0 to levelCount - 1 do begin
    if not ACollation^.Backwards[i] then begin
      pce := @ACEList[0];
      for k := 0 to c - 1 do begin
        if (pce^.Weights[i] <> 0) then begin
          r[ral] := pce^.Weights[i];
          ral := ral + 1;
        end;
        pce := pce + 1;
      end;
    end else begin
      pce := @ACEList[c-1];
      for k := 0 to c - 1 do begin
        if (pce^.Weights[i] <> 0) then begin
          r[ral] := pce^.Weights[i];
          ral := ral + 1;
        end;
        pce := pce - 1;
      end;
    end;
    r[ral] := 0;
    ral := ral + 1;
  end;
  ral := ral - 1;
  SetLength(r,ral);
  Result := r;
end;

function FormKeyShifted(const ACEList : TUCA_PropWeightsArray; const ACollation : PUCA_DataBook) : TUCASortKey;
var
  r : TUCASortKey;
  i, c, k, ral, levelCount : Integer;
  pce : PUCA_PropWeights;
  variableState : Boolean;
begin
  c := Length(ACEList);
  if (c = 0) then
    exit(nil);
  levelCount := Length(ACEList[0].Weights);
  SetLength(r,(levelCount*c + levelCount));
  ral := 0;
  for i := 0 to levelCount - 1 do begin
    if not ACollation^.Backwards[i] then begin
      variableState := False;
      pce := @ACEList[0];
      for k := 0 to c - 1 do begin
        if not ACollation^.IsVariable(pce) then begin
          if (pce^.Weights[0] <> 0) then
            variableState := False;
          if (pce^.Weights[i] <> 0) and not(variableState) then begin
            r[ral] := pce^.Weights[i];
            ral := ral + 1;
          end;
        end else begin
          variableState := True;
        end;
        pce := pce + 1;
      end;
    end else begin
      pce := @ACEList[c-1];
      for k := 0 to c - 1 do begin
        if not ACollation^.IsVariable(pce) then begin
          if (pce^.Weights[0] <> 0) then
            variableState := False;
          if (pce^.Weights[i] <> 0) and not(variableState) then begin
            r[ral] := pce^.Weights[i];
            ral := ral + 1;
          end;
        end else begin
          variableState := True;
        end;
        pce := pce - 1;
      end;
    end;
    r[ral] := 0;
    ral := ral + 1;
  end;
  ral := ral - 1;
  SetLength(r,ral);
  Result := r;
end;

function FormKeyShiftedTrimmed(
  const ACEList : TUCA_PropWeightsArray;
  const ACollation : PUCA_DataBook
) : TUCASortKey;
var
  i : Integer;
  p : ^TUCASortKeyItem;
begin
  Result := FormKeyShifted(ACEList,ACollation);
  i := Length(Result) - 1;
  if (i >= 0) then begin
    p := @Result[i];
    while (i >= 0) do begin
      if (p^ <> $FFFF) then
        Break;
      Dec(i);
      Dec(p);
    end;
    if ((i+1) < Length(Result)) then
      SetLength(Result,(i+1));
  end;
end;

function FindChild(
  const ACodePoint : Cardinal;
  const AParent    : PUCA_PropItemRec
) : PUCA_PropItemRec;inline;
var
  k : Integer;
begin
  Result := PUCA_PropItemRec(PtrUInt(AParent) + AParent^.GetSelfOnlySize());
  for k := 0 to AParent^.ChildCount - 1 do begin
    if (ACodePoint = Result^.CodePoint) then
      exit;
    Result := PUCA_PropItemRec(PtrUInt(Result) + Result^.Size);
  end;
  Result := nil;
end;

function ComputeSortKey(
  const AString    : UnicodeString;
  const ACollation : PUCA_DataBook
) : TUCASortKey;
begin
  Result := ComputeSortKey(@AString[1],Length(AString),ACollation);
end;

function ComputeRawSortKey(
  const AStr       : PUnicodeChar;
  const ALength    : SizeInt;
  const ACollation : PUCA_DataBook
) : TUCA_PropWeightsArray;
var
  r : TUCA_PropWeightsArray;
  ral {used length of "r"}: Integer;
  rl  {capacity of "r"} : Integer;

  procedure GrowKey(const AMinGrow : Integer = 0);inline;
  begin
    if (rl < AMinGrow) then
      rl := rl + AMinGrow
    else
      rl := 2 * rl;
    SetLength(r,rl);
  end;

var
  i : Integer;
  s : UnicodeString;
  ps : PUnicodeChar;
  cp : Cardinal;
  cl : PUCA_DataBook;
  pp : PUCA_PropItemRec;
  ppLevel : Byte;
  removedCharIndex : array of DWord;
  removedCharIndexLength : DWord;
  locHistory : array[0..24] of record
                                 i  : Integer;
                                 cl : PUCA_DataBook;
                                 pp : PUCA_PropItemRec;
                                 ppLevel : Byte;
                                 cp      : Cardinal;
                                 removedCharIndexLength : DWord;
                               end;
  locHistoryTop : Integer;
  suppressState : record
                    cl : PUCA_DataBook;
                    CharCount : Integer;
                  end;
  LastKeyOwner : record
                    Length : Integer;
                    Chars  : array[0..24] of UInt24;
                 end;

  procedure SaveKeyOwner();
  var
    k : Integer;
    kppLevel : Byte;
  begin
    k := 0;
    kppLevel := High(Byte);
    while (k <= locHistoryTop) do begin
      if (kppLevel <> locHistory[k].ppLevel) then begin
        LastKeyOwner.Chars[k] := locHistory[k].cp;
        kppLevel := locHistory[k].ppLevel;
      end;
      k := k + 1;
    end;
    if (k = 0) or (kppLevel <> ppLevel) then begin
      LastKeyOwner.Chars[k] := cp;
      k := k + 1;
    end;
    LastKeyOwner.Length := k;
  end;

  procedure AddWeights(AItem : PUCA_PropItemRec);inline;
  begin
    SaveKeyOwner();
    if ((ral + AItem^.WeightLength) > rl) then
      GrowKey(AItem^.WeightLength);
    AItem^.GetWeightArray(@r[ral]);
    ral := ral + AItem^.WeightLength;
  end;

  procedure AddContextWeights(AItem : PUCA_PropItemContextRec);inline;
  begin
    if ((ral + AItem^.WeightCount) > rl) then
      GrowKey(AItem^.WeightCount);
    Move(AItem^.GetWeights()^,r[ral],(AItem^.WeightCount*SizeOf(r[0])));
    ral := ral + AItem^.WeightCount;
  end;

  procedure AddComputedWeights(ACodePoint : Cardinal);inline;
  begin
    SaveKeyOwner();
    if ((ral + 2) > rl) then
      GrowKey();
    DeriveWeight(ACodePoint,@r[ral]);
    ral := ral + 2;
  end;

  procedure RecordDeletion();inline;
  begin
    if pp^.IsValid() and pp^.IsDeleted() (*pp^.GetWeightLength() = 0*) then begin
      if (suppressState.cl = nil) or
         (suppressState.CharCount > ppLevel)
      then begin
        suppressState.cl := cl;
        suppressState.CharCount := ppLevel;
      end;
    end;
  end;

  procedure RecordStep();inline;
  begin
    Inc(locHistoryTop);
    locHistory[locHistoryTop].i := i;
    locHistory[locHistoryTop].cl := cl;
    locHistory[locHistoryTop].pp := pp;
    locHistory[locHistoryTop].ppLevel := ppLevel;
    locHistory[locHistoryTop].cp := cp;
    locHistory[locHistoryTop].removedCharIndexLength := removedCharIndexLength;
    RecordDeletion();
  end;

  procedure ClearHistory();inline;
  begin
    locHistoryTop := -1;
  end;

  function HasHistory() : Boolean;inline;
  begin
    Result := (locHistoryTop >= 0);
  end;

  function GetHistoryLength() : Integer;inline;
  begin
    Result := (locHistoryTop + 1);
  end;

  procedure GoBack();inline;
  begin
    Assert(locHistoryTop >= 0);
    i := locHistory[locHistoryTop].i;
    cp := locHistory[locHistoryTop].cp;
    cl := locHistory[locHistoryTop].cl;
    pp := locHistory[locHistoryTop].pp;
    ppLevel := locHistory[locHistoryTop].ppLevel;
    removedCharIndexLength := locHistory[locHistoryTop].removedCharIndexLength;
    ps := @s[i];
    Dec(locHistoryTop);
  end;

var
  c : Integer;
  lastUnblockedNonstarterCCC : Byte;

  function IsUnblockedNonstarter(const AStartFrom : Integer) : Boolean;
  var
    k : DWord;
    pk : PUnicodeChar;
    puk : PUC_Prop;
  begin
    k := AStartFrom;
    if (k > c) then
      exit(False);
    if (removedCharIndexLength>0) and
       (IndexDWord(removedCharIndex[0],removedCharIndexLength,k) >= 0)
    then begin
      exit(False);
    end;
    {if (k = (i+1)) or
       ( (k = (i+2)) and UnicodeIsHighSurrogate(s[i]) )
    then
      lastUnblockedNonstarterCCC := 0;}
    pk := @s[k];
    if UnicodeIsHighSurrogate(pk^) then begin
      if (k = c) then
        exit(False);
      if UnicodeIsLowSurrogate(pk[1]) then
        puk := GetProps(pk[0],pk[1])
      else
        puk := GetProps(Word(pk^));
    end else begin
      puk := GetProps(Word(pk^));
    end;
    if (puk^.CCC = 0) or (lastUnblockedNonstarterCCC >= puk^.CCC) then
      exit(False);
    lastUnblockedNonstarterCCC := puk^.CCC;
    Result := True;
  end;

  procedure RemoveChar(APos : Integer);inline;
  begin
    if (removedCharIndexLength >= Length(removedCharIndex)) then
      SetLength(removedCharIndex,(2*removedCharIndexLength + 2));
    removedCharIndex[removedCharIndexLength] := APos;
    Inc(removedCharIndexLength);
    if UnicodeIsHighSurrogate(s[APos]) and (APos < c) and UnicodeIsLowSurrogate(s[APos+1]) then begin
      if (removedCharIndexLength >= Length(removedCharIndex)) then
          SetLength(removedCharIndex,(2*removedCharIndexLength + 2));
        removedCharIndex[removedCharIndexLength] := APos+1;
        Inc(removedCharIndexLength);
    end;
  end;

  procedure Inc_I();inline;
  begin
    if (removedCharIndexLength = 0) then begin
      Inc(i);
      Inc(ps);
      exit;
    end;
    while True do begin
      Inc(i);
      Inc(ps);
      if (IndexDWord(removedCharIndex[0],removedCharIndexLength,i) = -1) then
        Break;
    end;
  end;

var
  surrogateState : Boolean;

  function MoveToNextChar() : Boolean;inline;
  begin
    Result := True;
    if UnicodeIsHighSurrogate(ps[0]) then begin
      if (i = c) then
        exit(False);
      if UnicodeIsLowSurrogate(ps[1]) then begin
        surrogateState := True;
        cp := ToUCS4(ps[0],ps[1]);
      end else begin
        surrogateState := False;
        cp := Word(ps[0]);
      end;
    end else begin
      surrogateState := False;
      cp := Word(ps[0]);
    end;
  end;

  procedure ClearPP(const AClearSuppressInfo : Boolean = True);inline;
  begin
    cl := nil;
    pp := nil;
    ppLevel := 0;
    if AClearSuppressInfo then begin
      suppressState.cl := nil;
      suppressState.CharCount := 0;
    end;
  end;

  function FindPropUCA() : Boolean;
  var
    candidateCL : PUCA_DataBook;
  begin
    pp := nil;
    if (cl = nil) then
      candidateCL := ACollation
    else
      candidateCL := cl;
    if surrogateState then begin
      while (candidateCL <> nil) do begin
        pp := GetPropUCA(ps[0],ps[1],candidateCL);
        if (pp <> nil) then
          break;
        candidateCL := candidateCL^.Base;
      end;
    end else begin
      while (candidateCL <> nil) do begin
        pp := GetPropUCA(ps[0],candidateCL);
        if (pp <> nil) then
          break;
        candidateCL := candidateCL^.Base;
      end;
    end;
    cl := candidateCL;
    Result := (pp <> nil);
  end;

  procedure AddWeightsAndClear();inline;
  var
    ctxNode : PUCA_PropItemContextTreeNodeRec;
  begin
    if (pp^.WeightLength > 0) then begin
      AddWeights(pp);
    end else
    if (LastKeyOwner.Length > 0) and pp^.Contextual and
       pp^.GetContext()^.Find(@LastKeyOwner.Chars[0],LastKeyOwner.Length,ctxNode) and
       (ctxNode^.Data.WeightCount > 0)
    then begin
      AddContextWeights(@ctxNode^.Data);
    end;
    //AddWeights(pp);
    ClearHistory();
    ClearPP();
  end;

  procedure StartMatch();

    procedure HandleLastChar();
    var
      ctxNode : PUCA_PropItemContextTreeNodeRec;
    begin
      while True do begin
        if pp^.IsValid() then begin
          if (pp^.WeightLength > 0) then
            AddWeights(pp)
          else
          if (LastKeyOwner.Length > 0) and pp^.Contextual and
             pp^.GetContext()^.Find(@LastKeyOwner.Chars[0],LastKeyOwner.Length,ctxNode) and
             (ctxNode^.Data.WeightCount > 0)
          then
            AddContextWeights(@ctxNode^.Data)
          else
            AddComputedWeights(cp){handle deletion of code point};
          break;
        end;
        if (cl^.Base = nil) then begin
          AddComputedWeights(cp);
          break;
        end;
        cl := cl^.Base;
        if not FindPropUCA() then begin
          AddComputedWeights(cp);
          break;
        end;
      end;
    end;
  var
    tmpCtxNode : PUCA_PropItemContextTreeNodeRec;
  begin
    ppLevel := 0;
    if not FindPropUCA() then begin
      AddComputedWeights(cp);
      ClearHistory();
      ClearPP();
    end else begin
      if (i = c) then begin
        HandleLastChar();
      end else begin
        if pp^.IsValid()then begin
          if (pp^.ChildCount = 0) then begin
            if (pp^.WeightLength > 0) then
              AddWeights(pp)
            else
            if (LastKeyOwner.Length > 0) and pp^.Contextual and
               pp^.GetContext()^.Find(@LastKeyOwner.Chars[0],LastKeyOwner.Length,tmpCtxNode) and
               (tmpCtxNode^.Data.WeightCount > 0)
            then
              AddContextWeights(@tmpCtxNode^.Data)
            else
              AddComputedWeights(cp){handle deletion of code point};
            ClearPP();
            ClearHistory();
          end else begin
            RecordStep();
          end
        end else begin
          if (pp^.ChildCount = 0) then begin
            AddComputedWeights(cp);
            ClearPP();
            ClearHistory();
          end else begin
            RecordStep();
          end;
        end ;
      end;
    end;
  end;

  function TryPermutation() : Boolean;
  var
    kk : Integer;
    b : Boolean;
    puk : PUC_Prop;
    ppk : PUCA_PropItemRec;
  begin
    Result := False;
    puk := GetProps(cp);
    if (puk^.CCC = 0) then
      exit;
    lastUnblockedNonstarterCCC := puk^.CCC;
    if surrogateState then
      kk := i + 2
    else
      kk := i + 1;
    while IsUnblockedNonstarter(kk) do begin
      b := UnicodeIsHighSurrogate(s[kk]) and (kk<c) and UnicodeIsLowSurrogate(s[kk+1]);
      if b then
        ppk := FindChild(ToUCS4(s[kk],s[kk+1]),pp)
      else
        ppk := FindChild(Word(s[kk]),pp);
      if (ppk <> nil) then begin
        pp := ppk;
        RemoveChar(kk);
        Inc(ppLevel);
        RecordStep();
        Result := True;
        if (pp^.ChildCount = 0 ) then
          Break;
      end;
      if b then
        Inc(kk);
      Inc(kk);
    end;
  end;

  procedure AdvanceCharPos();inline;
  begin
    if UnicodeIsHighSurrogate(ps[0]) and (i<c) and UnicodeIsLowSurrogate(ps[1]) then begin
      Inc(i);
      Inc(ps);
    end;
    Inc_I();
  end;

var
  ok : Boolean;
  pp1 : PUCA_PropItemRec;
  cltemp : PUCA_DataBook;
  ctxNode : PUCA_PropItemContextTreeNodeRec;
begin
  if (ALength = 0) then
    exit(nil);
  c := ALength;
  s := NormalizeNFD(AStr,c);
  c := Length(s);
  rl := 3*c;
  SetLength(r,rl);
  ral := 0;
  ps := @s[1];
  ClearPP();
  locHistoryTop := -1;
  removedCharIndexLength := 0;
  FillByte(suppressState,SizeOf(suppressState),0);
  LastKeyOwner.Length := 0;
  i := 1;
  while (i <= c) and MoveToNextChar() do begin
    if (pp = nil) then begin // Start Matching
      StartMatch();
    end else begin
      pp1 := FindChild(cp,pp);
      if (pp1 <> nil) then begin
        Inc(ppLevel);
        pp := pp1;
        if (pp^.ChildCount = 0) or (i = c) then begin
          ok := False;
          if pp^.IsValid() and (suppressState.CharCount = 0) then begin
            if (pp^.WeightLength > 0) then begin
              AddWeightsAndClear();
              ok := True;
            end else
            if (LastKeyOwner.Length > 0) and pp^.Contextual and
               pp^.GetContext()^.Find(@LastKeyOwner.Chars[0],LastKeyOwner.Length,ctxNode) and
               (ctxNode^.Data.WeightCount > 0)
            then begin
              AddContextWeights(@ctxNode^.Data);
              ClearHistory();
              ClearPP();
              ok := True;
            end
          end;
          if not ok then begin
            RecordDeletion();
            ok := False;
            while HasHistory() do begin
              GoBack();
              if pp^.IsValid() and
                 ( ( (cl = suppressState.cl) and (ppLevel <> suppressState.CharCount) ) or
                   ( (cl <> suppressState.cl) and (ppLevel < suppressState.CharCount) )
                 )
              then begin
                AddWeightsAndClear();
                ok := True;
                Break;
              end;
            end;
            if not ok then begin
              cltemp := cl^.Base;
              if (cltemp <> nil) then begin
                ClearPP(False);
                cl := cltemp;
                Continue;
              end;
            end;

            if not ok then begin
              AddComputedWeights(cp);
              ClearHistory();
              ClearPP();
            end;
          end;
        end else begin
          RecordStep();
        end;
      end else begin
        // permutations !
        ok := False;
        if TryPermutation() and pp^.IsValid() then begin
          if (suppressState.CharCount = 0) then begin
            AddWeightsAndClear();
            Continue;
          end;
          while True do begin
            if pp^.IsValid() and
               (pp^.WeightLength > 0) and
               ( ( (cl = suppressState.cl) and (ppLevel <> suppressState.CharCount) ) or
                 ( (cl <> suppressState.cl) and (ppLevel < suppressState.CharCount) )
               )
            then begin
              AddWeightsAndClear();
              ok := True;
              break;
            end;
            if not HasHistory() then
              break;
            GoBack();
            if (pp = nil) then
              break;
          end;
        end;
        if not ok then begin
          if pp^.IsValid() and (suppressState.CharCount = 0) then begin
            if (pp^.WeightLength > 0) then begin
              AddWeightsAndClear();
              ok := True;
            end else
            if (LastKeyOwner.Length > 0) and pp^.Contextual and
               pp^.GetContext()^.Find(@LastKeyOwner.Chars[0],LastKeyOwner.Length,ctxNode) and
               (ctxNode^.Data.WeightCount > 0)
            then begin
              AddContextWeights(@ctxNode^.Data);
              ClearHistory();
              ClearPP();
              ok := True;
            end
          end;
          if ok then
            Continue;
        end;
        if not ok then begin
          if (cl^.Base <> nil) then begin
            cltemp := cl^.Base;
            while HasHistory() do
              GoBack();
            pp := nil;
            ppLevel := 0;
            cl := cltemp;
            Continue;
          end;

          //walk back
          ok := False;
          while HasHistory() do begin
            GoBack();
            if pp^.IsValid() and
               (pp^.WeightLength > 0) and
               ( (suppressState.CharCount = 0) or
                 ( ( (cl = suppressState.cl) and (ppLevel <> suppressState.CharCount) ) or
                   ( (cl <> suppressState.cl) and (ppLevel < suppressState.CharCount) )
                 )
               )
            then begin
              AddWeightsAndClear();
              ok := True;
              Break;
            end;
          end;
          if ok then begin
            AdvanceCharPos();
            Continue;
          end;
          if (pp <> nil) then begin
            AddComputedWeights(cp);
            ClearHistory();
            ClearPP();
          end;
        end;
      end;
    end;
    if surrogateState then begin
      Inc(ps);
      Inc(i);
    end;
    //
    Inc_I();
  end;
  SetLength(r,ral);
  Result := r;
end;

type
  TComputeKeyContext = record
    Collation : PUCA_DataBook;
    r : TUCA_PropWeightsArray;
    ral {used length of "r"}: Integer;
    rl  {capacity of "r"} : Integer;
    i : Integer;
    s : UnicodeString;
    ps : PUnicodeChar;
    cp : Cardinal;
    cl : PUCA_DataBook;
    pp : PUCA_PropItemRec;
    ppLevel : Byte;
    removedCharIndex : array of DWord;
    removedCharIndexLength : DWord;
    locHistoryTop : Integer;
    locHistory : array[0..24] of record
                                   i  : Integer;
                                   cl : PUCA_DataBook;
                                   pp : PUCA_PropItemRec;
                                   ppLevel : Byte;
                                   cp      : Cardinal;
                                   removedCharIndexLength : DWord;
                                 end;
    suppressState : record
                      cl : PUCA_DataBook;
                      CharCount : Integer;
                    end;
    LastKeyOwner : record
                      Length : Integer;
                      Chars  : array[0..24] of UInt24;
                   end;
    c : Integer;
    lastUnblockedNonstarterCCC : Byte;
    surrogateState : Boolean;
    Finished : Boolean;
  end;
  PComputeKeyContext = ^TComputeKeyContext;

procedure ClearPP(AContext : PComputeKeyContext; const AClearSuppressInfo : Boolean = True);inline;
begin
  AContext^.cl := nil;
  AContext^.pp := nil;
  AContext^.ppLevel := 0;
  if AClearSuppressInfo then begin
    AContext^.suppressState.cl := nil;
    AContext^.suppressState.CharCount := 0;
  end;
end;

procedure InitContext(
        AContext   : PComputeKeyContext;
  const AStr       : PUnicodeChar;
  const ALength    : SizeInt;
  const ACollation : PUCA_DataBook
);
begin
  AContext^.Collation := ACollation;
  AContext^.c := ALength;
  AContext^.s := NormalizeNFD(AStr,AContext^.c);
  AContext^.c := Length(AContext^.s);
  AContext^.rl := 3*AContext^.c;
  SetLength(AContext^.r,AContext^.rl);
  AContext^.ral := 0;
  AContext^.ps := @AContext^.s[1];
  ClearPP(AContext);
  AContext^.locHistoryTop := -1;
  AContext^.removedCharIndexLength := 0;
  FillByte(AContext^.suppressState,SizeOf(AContext^.suppressState),0);
  AContext^.LastKeyOwner.Length := 0;
  AContext^.i := 1;
  AContext^.Finished := False;
end;

function FormKey(
  const AWeightArray  : TUCA_PropWeightsArray;
  const ACollation    : PUCA_DataBook
) : TUCASortKey;inline;
begin
  case ACollation.VariableWeight of
    TUCA_VariableKind.ucaShifted        : Result := FormKeyShifted(AWeightArray,ACollation);
    TUCA_VariableKind.ucaBlanked        : Result := FormKeyBlanked(AWeightArray,ACollation);
    TUCA_VariableKind.ucaNonIgnorable   : Result := FormKeyNonIgnorable(AWeightArray,ACollation);
    TUCA_VariableKind.ucaShiftedTrimmed : Result := FormKeyShiftedTrimmed(AWeightArray,ACollation);
    else
      Result := FormKeyShifted(AWeightArray,ACollation);
  end;
end;

function ComputeRawSortKeyNextItem(
  const AContext   : PComputeKeyContext
) : Boolean;forward;
function IncrementalCompareString_NonIgnorable(
  const AStrA      : PUnicodeChar;
  const ALengthA   : SizeInt;
  const AStrB      : PUnicodeChar;
  const ALengthB   : SizeInt;
  const ACollation : PUCA_DataBook
) : Integer;
var
  ctxA, ctxB : TComputeKeyContext;
  lastKeyIndexA, keyIndexA, lengthMaxA : Integer;
  keyIndexB : Integer;
  keyA, keyB : TUCASortKey;
begin
  if ( (ALengthA = 0) and (ALengthB = 0) ) or
     ( (PtrUInt(AStrA) = PtrUInt(AStrB)) and
       (ALengthA = ALengthB)
     )
  then
    exit(0);
  if (ALengthA = 0) then
    exit(-1);
  if (ALengthB = 0) then
    exit(1);

  InitContext(@ctxA,AStrA,ALengthA,ACollation);
  InitContext(@ctxB,AStrB,ALengthB,ACollation);
  lastKeyIndexA := -1;
  keyIndexA := -1;
  lengthMaxA := 0;
  keyIndexB := -1;
  while True do begin
    if not ComputeRawSortKeyNextItem(@ctxA) then
      Break;
    if (ctxA.ral = lengthMaxA) then
      Continue;
    lengthMaxA := ctxA.ral;
    keyIndexA := lastKeyIndexA + 1;
    while (keyIndexA < lengthMaxA) and (ctxA.r[keyIndexA].Weights[0] = 0) do begin
      Inc(keyIndexA);
    end;
    if (keyIndexA = lengthMaxA) then begin
      lastKeyIndexA := keyIndexA-1;
      Continue;
    end;

    while (keyIndexA < lengthMaxA) do begin
      if (ctxA.r[keyIndexA].Weights[0] = 0) then begin
        Inc(keyIndexA);
        Continue;
      end;
      Inc(keyIndexB);
      while (ctxB.ral <= keyIndexB) or (ctxB.r[keyIndexB].Weights[0] = 0) do begin
        if (ctxB.ral <= keyIndexB) then begin
          if not ComputeRawSortKeyNextItem(@ctxB) then
            Break;
          Continue;
        end;
        Inc(keyIndexB);
      end;
      if (ctxB.ral <= keyIndexB) then
        exit(1);
      if (ctxA.r[keyIndexA].Weights[0] > ctxB.r[keyIndexB].Weights[0]) then
        exit(1);
      if (ctxA.r[keyIndexA].Weights[0] < ctxB.r[keyIndexB].Weights[0]) then
        exit(-1);
      Inc(keyIndexA);
    end;
    lastKeyIndexA := keyIndexA - 1;
  end;
  //Key(A) is completed !
  Inc(keyIndexB);
  while (ctxB.ral <= keyIndexB) or (ctxB.r[keyIndexB].Weights[0] = 0) do begin
    if (ctxB.ral <= keyIndexB) then begin
      if not ComputeRawSortKeyNextItem(@ctxB) then
        Break;
      Continue;
    end;
    Inc(keyIndexB);
  end;
  if (ctxB.ral > keyIndexB) then begin
    //B has at least one more primary weight that A
    exit(-1);
  end;
  while ComputeRawSortKeyNextItem(@ctxB) do begin
    //
  end;
  //Key(B) is completed !
  keyA := FormKey(ctxA.r,ctxA.Collation);
  keyB := FormKey(ctxB.r,ctxB.Collation);
  Result := CompareSortKey(keyA,keyB);
end;

function IncrementalCompareString_Shift(
  const AStrA      : PUnicodeChar;
  const ALengthA   : SizeInt;
  const AStrB      : PUnicodeChar;
  const ALengthB   : SizeInt;
  const ACollation : PUCA_DataBook
) : Integer;
var
  ctxA, ctxB : TComputeKeyContext;
  lastKeyIndexA, keyIndexA, lengthMaxA : Integer;
  keyIndexB : Integer;
  keyA, keyB : TUCASortKey;
begin
  if ( (ALengthA = 0) and (ALengthB = 0) ) or
     ( (PtrUInt(AStrA) = PtrUInt(AStrB)) and
       (ALengthA = ALengthB)
     )
  then
    exit(0);
  if (ALengthA = 0) then
    exit(-1);
  if (ALengthB = 0) then
    exit(1);

  InitContext(@ctxA,AStrA,ALengthA,ACollation);
  InitContext(@ctxB,AStrB,ALengthB,ACollation);
  lastKeyIndexA := -1;
  keyIndexA := -1;
  lengthMaxA := 0;
  keyIndexB := -1;
  while True do begin
    if not ComputeRawSortKeyNextItem(@ctxA) then
      Break;
    if (ctxA.ral = lengthMaxA) then
      Continue;
    lengthMaxA := ctxA.ral;
    keyIndexA := lastKeyIndexA + 1;
    while (keyIndexA < lengthMaxA) and
          ( (ctxA.r[keyIndexA].Weights[0] = 0) or
            ctxA.Collation^.IsVariable(@ctxA.r[keyIndexA].Weights)
          )
    do begin
      Inc(keyIndexA);
    end;
    if (keyIndexA = lengthMaxA) then begin
      lastKeyIndexA := keyIndexA-1;
      Continue;
    end;

    while (keyIndexA < lengthMaxA) do begin
      if (ctxA.r[keyIndexA].Weights[0] = 0) or
         ctxA.Collation^.IsVariable(@ctxA.r[keyIndexA].Weights)
      then begin
        Inc(keyIndexA);
        Continue;
      end;
      Inc(keyIndexB);
      while (ctxB.ral <= keyIndexB) or
            (ctxB.r[keyIndexB].Weights[0] = 0) or
            ctxB.Collation^.IsVariable(@ctxB.r[keyIndexB].Weights)
      do begin
        if (ctxB.ral <= keyIndexB) then begin
          if not ComputeRawSortKeyNextItem(@ctxB) then
            Break;
          Continue;
        end;
        Inc(keyIndexB);
      end;
      if (ctxB.ral <= keyIndexB) then
        exit(1);
      if (ctxA.r[keyIndexA].Weights[0] > ctxB.r[keyIndexB].Weights[0]) then
        exit(1);
      if (ctxA.r[keyIndexA].Weights[0] < ctxB.r[keyIndexB].Weights[0]) then
        exit(-1);
      Inc(keyIndexA);
    end;
    lastKeyIndexA := keyIndexA - 1;
  end;
  //Key(A) is completed !
  Inc(keyIndexB);
  while (ctxB.ral <= keyIndexB) or
        (ctxB.r[keyIndexB].Weights[0] = 0) or
        ctxB.Collation^.IsVariable(@ctxB.r[keyIndexB].Weights)
  do begin
    if (ctxB.ral <= keyIndexB) then begin
      if not ComputeRawSortKeyNextItem(@ctxB) then
        Break;
      Continue;
    end;
    Inc(keyIndexB);
  end;
  if (ctxB.ral > keyIndexB) then begin
    //B has at least one more primary weight that A
    exit(-1);
  end;
  while ComputeRawSortKeyNextItem(@ctxB) do begin
    //
  end;
  //Key(B) is completed !
  keyA := FormKey(ctxA.r,ctxA.Collation);
  keyB := FormKey(ctxB.r,ctxB.Collation);
  Result := CompareSortKey(keyA,keyB);
end;

function IncrementalCompareString(
  const AStrA      : PUnicodeChar;
  const ALengthA   : SizeInt;
  const AStrB      : PUnicodeChar;
  const ALengthB   : SizeInt;
  const ACollation : PUCA_DataBook
) : Integer;
begin
  case ACollation^.VariableWeight of
    TUCA_VariableKind.ucaNonIgnorable :
      begin
        Result := IncrementalCompareString_NonIgnorable(
                    AStrA,ALengthA,AStrB,ALengthB,ACollation
                  );
      end;
    TUCA_VariableKind.ucaBlanked,
    TUCA_VariableKind.ucaShiftedTrimmed,
    TUCA_VariableKind.ucaIgnoreSP,
    TUCA_VariableKind.ucaShifted:
      begin
        Result := IncrementalCompareString_Shift(
                    AStrA,ALengthA,AStrB,ALengthB,ACollation
                  );
      end;
    else
      begin
        Result := IncrementalCompareString_Shift(
                    AStrA,ALengthA,AStrB,ALengthB,ACollation
                  );
      end;
  end;
end;

function IncrementalCompareString(
  const AStrA,
        AStrB      : UnicodeString;
  const ACollation : PUCA_DataBook
) : Integer;
begin
  Result := IncrementalCompareString(
              Pointer(AStrA),Length(AStrA),Pointer(AStrB),Length(AStrB),
              ACollation
            );
end;

function ComputeRawSortKeyNextItem(
  const AContext : PComputeKeyContext
) : Boolean;
var
  ctx : PComputeKeyContext;

  procedure GrowKey(const AMinGrow : Integer = 0);inline;
  begin
    if (ctx^.rl < AMinGrow) then
      ctx^.rl := ctx^.rl + AMinGrow
    else
      ctx^.rl := 2 * ctx^.rl;
    SetLength(ctx^.r,ctx^.rl);
  end;

  procedure SaveKeyOwner();
  var
    k : Integer;
    kppLevel : Byte;
  begin
    k := 0;
    kppLevel := High(Byte);
    while (k <= ctx^.locHistoryTop) do begin
      if (kppLevel <> ctx^.locHistory[k].ppLevel) then begin
        ctx^.LastKeyOwner.Chars[k] := ctx^.locHistory[k].cp;
        kppLevel := ctx^.locHistory[k].ppLevel;
      end;
      k := k + 1;
    end;
    if (k = 0) or (kppLevel <> ctx^.ppLevel) then begin
      ctx^.LastKeyOwner.Chars[k] := ctx^.cp;
      k := k + 1;
    end;
    ctx^.LastKeyOwner.Length := k;
  end;

  procedure AddWeights(AItem : PUCA_PropItemRec);inline;
  begin
    SaveKeyOwner();
    if ((ctx^.ral + AItem^.WeightLength) > ctx^.rl) then
      GrowKey(AItem^.WeightLength);
    AItem^.GetWeightArray(@ctx^.r[ctx^.ral]);
    ctx^.ral := ctx^.ral + AItem^.WeightLength;
  end;

  procedure AddContextWeights(AItem : PUCA_PropItemContextRec);inline;
  begin
    if ((ctx^.ral + AItem^.WeightCount) > ctx^.rl) then
      GrowKey(AItem^.WeightCount);
    Move(AItem^.GetWeights()^,ctx^.r[ctx^.ral],(AItem^.WeightCount*SizeOf(ctx^.r[0])));
    ctx^.ral := ctx^.ral + AItem^.WeightCount;
  end;

  procedure AddComputedWeights(ACodePoint : Cardinal);inline;
  begin
    SaveKeyOwner();
    if ((ctx^.ral + 2) > ctx^.rl) then
      GrowKey();
    DeriveWeight(ACodePoint,@ctx^.r[ctx^.ral]);
    ctx^.ral := ctx^.ral + 2;
  end;

  procedure RecordDeletion();inline;
  begin
    if ctx^.pp^.IsValid() and ctx^.pp^.IsDeleted() (*pp^.GetWeightLength() = 0*) then begin
      if (ctx^.suppressState.cl = nil) or
         (ctx^.suppressState.CharCount > ctx^.ppLevel)
      then begin
        ctx^.suppressState.cl := ctx^.cl;
        ctx^.suppressState.CharCount := ctx^.ppLevel;
      end;
    end;
  end;

  procedure RecordStep();inline;
  begin
    Inc(ctx^.locHistoryTop);
    ctx^.locHistory[ctx^.locHistoryTop].i := ctx^.i;
    ctx^.locHistory[ctx^.locHistoryTop].cl := ctx^.cl;
    ctx^.locHistory[ctx^.locHistoryTop].pp := ctx^.pp;
    ctx^.locHistory[ctx^.locHistoryTop].ppLevel := ctx^.ppLevel;
    ctx^.locHistory[ctx^.locHistoryTop].cp := ctx^.cp;
    ctx^.locHistory[ctx^.locHistoryTop].removedCharIndexLength := ctx^.removedCharIndexLength;
    RecordDeletion();
  end;

  procedure ClearHistory();inline;
  begin
    ctx^.locHistoryTop := -1;
  end;

  function HasHistory() : Boolean;inline;
  begin
    Result := (ctx^.locHistoryTop >= 0);
  end;

  function GetHistoryLength() : Integer;inline;
  begin
    Result := (ctx^.locHistoryTop + 1);
  end;

  procedure GoBack();inline;
  begin
    Assert(ctx^.locHistoryTop >= 0);
    ctx^.i := ctx^.locHistory[ctx^.locHistoryTop].i;
    ctx^.cp := ctx^.locHistory[ctx^.locHistoryTop].cp;
    ctx^.cl := ctx^.locHistory[ctx^.locHistoryTop].cl;
    ctx^.pp := ctx^.locHistory[ctx^.locHistoryTop].pp;
    ctx^.ppLevel := ctx^.locHistory[ctx^.locHistoryTop].ppLevel;
    ctx^.removedCharIndexLength := ctx^.locHistory[ctx^.locHistoryTop].removedCharIndexLength;
    ctx^.ps := @ctx^.s[ctx^.i];
    Dec(ctx^.locHistoryTop);
  end;

  function IsUnblockedNonstarter(const AStartFrom : Integer) : Boolean;
  var
    k : DWord;
    pk : PUnicodeChar;
    puk : PUC_Prop;
  begin
    k := AStartFrom;
    if (k > ctx^.c) then
      exit(False);
    if (ctx^.removedCharIndexLength>0) and
       (IndexDWord(ctx^.removedCharIndex[0],ctx^.removedCharIndexLength,k) >= 0)
    then begin
      exit(False);
    end;
    {if (k = (i+1)) or
       ( (k = (i+2)) and UnicodeIsHighSurrogate(s[i]) )
    then
      lastUnblockedNonstarterCCC := 0;}
    pk := @ctx^.s[k];
    if UnicodeIsHighSurrogate(pk^) then begin
      if (k = ctx^.c) then
        exit(False);
      if UnicodeIsLowSurrogate(pk[1]) then
        puk := GetProps(pk[0],pk[1])
      else
        puk := GetProps(Word(pk^));
    end else begin
      puk := GetProps(Word(pk^));
    end;
    if (puk^.CCC = 0) or (ctx^.lastUnblockedNonstarterCCC >= puk^.CCC) then
      exit(False);
    ctx^.lastUnblockedNonstarterCCC := puk^.CCC;
    Result := True;
  end;

  procedure RemoveChar(APos : Integer);inline;
  begin
    if (ctx^.removedCharIndexLength >= Length(ctx^.removedCharIndex)) then
      SetLength(ctx^.removedCharIndex,(2*ctx^.removedCharIndexLength + 2));
    ctx^.removedCharIndex[ctx^.removedCharIndexLength] := APos;
    Inc(ctx^.removedCharIndexLength);
    if UnicodeIsHighSurrogate(ctx^.s[APos]) and (APos < ctx^.c) and UnicodeIsLowSurrogate(ctx^.s[APos+1]) then begin
      if (ctx^.removedCharIndexLength >= Length(ctx^.removedCharIndex)) then
          SetLength(ctx^.removedCharIndex,(2*ctx^.removedCharIndexLength + 2));
        ctx^.removedCharIndex[ctx^.removedCharIndexLength] := APos+1;
        Inc(ctx^.removedCharIndexLength);
    end;
  end;

  procedure Inc_I();inline;
  begin
    if (ctx^.removedCharIndexLength = 0) then begin
      Inc(ctx^.i);
      Inc(ctx^.ps);
      exit;
    end;
    while True do begin
      Inc(ctx^.i);
      Inc(ctx^.ps);
      if (IndexDWord(ctx^.removedCharIndex[0],ctx^.removedCharIndexLength,ctx^.i) = -1) then
        Break;
    end;
  end;

  function MoveToNextChar() : Boolean;inline;
  begin
    Result := True;
    if UnicodeIsHighSurrogate(ctx^.ps[0]) then begin
      if (ctx^.i = ctx^.c) then
        exit(False);
      if UnicodeIsLowSurrogate(ctx^.ps[1]) then begin
        ctx^.surrogateState := True;
        ctx^.cp := ToUCS4(ctx^.ps[0],ctx^.ps[1]);
      end else begin
        ctx^.surrogateState := False;
        ctx^.cp := Word(ctx^.ps[0]);
      end;
    end else begin
      ctx^.surrogateState := False;
      ctx^.cp := Word(ctx^.ps[0]);
    end;
  end;

  function FindPropUCA() : Boolean;
  var
    candidateCL : PUCA_DataBook;
  begin
    ctx^.pp := nil;
    if (ctx^.cl = nil) then
      candidateCL := ctx^.Collation
    else
      candidateCL := ctx^.cl;
    if ctx^.surrogateState then begin
      while (candidateCL <> nil) do begin
        ctx^.pp := GetPropUCA(ctx^.ps[0],ctx^.ps[1],candidateCL);
        if (ctx^.pp <> nil) then
          break;
        candidateCL := candidateCL^.Base;
      end;
    end else begin
      while (candidateCL <> nil) do begin
        ctx^.pp := GetPropUCA(ctx^.ps[0],candidateCL);
        if (ctx^.pp <> nil) then
          break;
        candidateCL := candidateCL^.Base;
      end;
    end;
    ctx^.cl := candidateCL;
    Result := (ctx^.pp <> nil);
  end;

  procedure AddWeightsAndClear();inline;
  var
    ctxNode : PUCA_PropItemContextTreeNodeRec;
  begin
    if (ctx^.pp^.WeightLength > 0) then begin
      AddWeights(ctx^.pp);
    end else
    if (ctx^.LastKeyOwner.Length > 0) and ctx^.pp^.Contextual and
       ctx^.pp^.GetContext()^.Find(@ctx^.LastKeyOwner.Chars[0],ctx^.LastKeyOwner.Length,ctxNode) and
       (ctxNode^.Data.WeightCount > 0)
    then begin
      AddContextWeights(@ctxNode^.Data);
    end;
    //AddWeights(pp);
    ClearHistory();
    ClearPP(ctx);
  end;

  function StartMatch() : Boolean;

    procedure HandleLastChar();
    var
      ctxNode : PUCA_PropItemContextTreeNodeRec;
    begin
      while True do begin
        if ctx^.pp^.IsValid() then begin
          if (ctx^.pp^.WeightLength > 0) then
            AddWeights(ctx^.pp)
          else
          if (ctx^.LastKeyOwner.Length > 0) and ctx^.pp^.Contextual and
             ctx^.pp^.GetContext()^.Find(@ctx^.LastKeyOwner.Chars[0],ctx^.LastKeyOwner.Length,ctxNode) and
             (ctxNode^.Data.WeightCount > 0)
          then
            AddContextWeights(@ctxNode^.Data)
          else
            AddComputedWeights(ctx^.cp){handle deletion of code point};
          break;
        end;
        if (ctx^.cl^.Base = nil) then begin
          AddComputedWeights(ctx^.cp);
          break;
        end;
        ctx^.cl := ctx^.cl^.Base;
        if not FindPropUCA() then begin
          AddComputedWeights(ctx^.cp);
          break;
        end;
      end;
    end;
  var
    tmpCtxNode : PUCA_PropItemContextTreeNodeRec;
  begin
    Result := False;
    ctx^.ppLevel := 0;
    if not FindPropUCA() then begin
      AddComputedWeights(ctx^.cp);
      ClearHistory();
      ClearPP(ctx);
      Result := True;
    end else begin
      if (ctx^.i = ctx^.c) then begin
        HandleLastChar();
        Result := True;
      end else begin
        if ctx^.pp^.IsValid()then begin
          if (ctx^.pp^.ChildCount = 0) then begin
            if (ctx^.pp^.WeightLength > 0) then
              AddWeights(ctx^.pp)
            else
            if (ctx^.LastKeyOwner.Length > 0) and ctx^.pp^.Contextual and
               ctx^.pp^.GetContext()^.Find(@ctx^.LastKeyOwner.Chars[0],ctx^.LastKeyOwner.Length,tmpCtxNode) and
               (tmpCtxNode^.Data.WeightCount > 0)
            then
              AddContextWeights(@tmpCtxNode^.Data)
            else
              AddComputedWeights(ctx^.cp){handle deletion of code point};
            ClearPP(ctx);
            ClearHistory();
            Result := True;
          end else begin
            RecordStep();
          end
        end else begin
          if (ctx^.pp^.ChildCount = 0) then begin
            AddComputedWeights(ctx^.cp);
            ClearPP(ctx);
            ClearHistory();
            Result := True;
          end else begin
            RecordStep();
          end;
        end;
      end;
    end;
  end;

  function TryPermutation() : Boolean;
  var
    kk : Integer;
    b : Boolean;
    puk : PUC_Prop;
    ppk : PUCA_PropItemRec;
  begin
    Result := False;
    puk := GetProps(ctx^.cp);
    if (puk^.CCC = 0) then
      exit;
    ctx^.lastUnblockedNonstarterCCC := puk^.CCC;
    if ctx^.surrogateState then
      kk := ctx^.i + 2
    else
      kk := ctx^.i + 1;
    while IsUnblockedNonstarter(kk) do begin
      b := UnicodeIsHighSurrogate(ctx^.s[kk]) and (kk<ctx^.c) and UnicodeIsLowSurrogate(ctx^.s[kk+1]);
      if b then
        ppk := FindChild(ToUCS4(ctx^.s[kk],ctx^.s[kk+1]),ctx^.pp)
      else
        ppk := FindChild(Word(ctx^.s[kk]),ctx^.pp);
      if (ppk <> nil) then begin
        ctx^.pp := ppk;
        RemoveChar(kk);
        Inc(ctx^.ppLevel);
        RecordStep();
        Result := True;
        if (ctx^.pp^.ChildCount = 0 ) then
          Break;
      end;
      if b then
        Inc(kk);
      Inc(kk);
    end;
  end;

  procedure AdvanceCharPos();inline;
  begin
    if UnicodeIsHighSurrogate(ctx^.ps[0]) and (ctx^.i<ctx^.c) and UnicodeIsLowSurrogate(ctx^.ps[1]) then begin
      Inc(ctx^.i);
      Inc(ctx^.ps);
    end;
    Inc_I();
  end;

var
  ok : Boolean;
  pp1 : PUCA_PropItemRec;
  cltemp : PUCA_DataBook;
  ctxNode : PUCA_PropItemContextTreeNodeRec;
begin
  if AContext^.Finished then
    exit(False);
  ctx := AContext;
  while (ctx^.i <= ctx^.c) and MoveToNextChar() do begin
    ok := False;
    if (ctx^.pp = nil) then begin // Start Matching
      ok := StartMatch();
    end else begin
      pp1 := FindChild(ctx^.cp,ctx^.pp);
      if (pp1 <> nil) then begin
        Inc(ctx^.ppLevel);
        ctx^.pp := pp1;
        if (ctx^.pp^.ChildCount = 0) or (ctx^.i = ctx^.c) then begin
          ok := False;
          if ctx^.pp^.IsValid() and (ctx^.suppressState.CharCount = 0) then begin
            if (ctx^.pp^.WeightLength > 0) then begin
              AddWeightsAndClear();
              ok := True;
            end else
            if (ctx^.LastKeyOwner.Length > 0) and ctx^.pp^.Contextual and
               ctx^.pp^.GetContext()^.Find(@ctx^.LastKeyOwner.Chars[0],ctx^.LastKeyOwner.Length,ctxNode) and
               (ctxNode^.Data.WeightCount > 0)
            then begin
              AddContextWeights(@ctxNode^.Data);
              ClearHistory();
              ClearPP(ctx);
              ok := True;
            end
          end;
          if not ok then begin
            RecordDeletion();
            while HasHistory() do begin
              GoBack();
              if ctx^.pp^.IsValid() and
                 ( ( (ctx^.cl = ctx^.suppressState.cl) and (ctx^.ppLevel <> ctx^.suppressState.CharCount) ) or
                   ( (ctx^.cl <> ctx^.suppressState.cl) and (ctx^.ppLevel < ctx^.suppressState.CharCount) )
                 )
              then begin
                AddWeightsAndClear();
                ok := True;
                Break;
              end;
            end;
            if not ok then begin
              cltemp := ctx^.cl^.Base;
              if (cltemp <> nil) then begin
                ClearPP(ctx,False);
                ctx^.cl := cltemp;
                Continue;
              end;
            end;

            if not ok then begin
              AddComputedWeights(ctx^.cp);
              ClearHistory();
              ClearPP(ctx);
              ok := True;
            end;
          end;
        end else begin
          RecordStep();
        end;
      end else begin
        // permutations !
        ok := False;
        if TryPermutation() and ctx^.pp^.IsValid() then begin
          if (ctx^.suppressState.CharCount = 0) then begin
            AddWeightsAndClear();
            ok := True;
            exit(True);// Continue;
          end;
          while True do begin
            if ctx^.pp^.IsValid() and
               (ctx^.pp^.WeightLength > 0) and
               ( ( (ctx^.cl = ctx^.suppressState.cl) and (ctx^.ppLevel <> ctx^.suppressState.CharCount) ) or
                 ( (ctx^.cl <> ctx^.suppressState.cl) and (ctx^.ppLevel < ctx^.suppressState.CharCount) )
               )
            then begin
              AddWeightsAndClear();
              ok := True;
              break;
            end;
            if not HasHistory() then
              break;
            GoBack();
            if (ctx^.pp = nil) then
              break;
          end;
        end;
        if not ok then begin
          if ctx^.pp^.IsValid() and (ctx^.suppressState.CharCount = 0) then begin
            if (ctx^.pp^.WeightLength > 0) then begin
              AddWeightsAndClear();
              ok := True;
            end else
            if (ctx^.LastKeyOwner.Length > 0) and ctx^.pp^.Contextual and
               ctx^.pp^.GetContext()^.Find(@ctx^.LastKeyOwner.Chars[0],ctx^.LastKeyOwner.Length,ctxNode) and
               (ctxNode^.Data.WeightCount > 0)
            then begin
              AddContextWeights(@ctxNode^.Data);
              ClearHistory();
              ClearPP(ctx);
              ok := True;
            end
          end;
          if ok then
            exit(True);// Continue;
        end;
        if not ok then begin
          if (ctx^.cl^.Base <> nil) then begin
            cltemp := ctx^.cl^.Base;
            while HasHistory() do
              GoBack();
            ctx^.pp := nil;
            ctx^.ppLevel := 0;
            ctx^.cl := cltemp;
            Continue;
          end;

          //walk back
          ok := False;
          while HasHistory() do begin
            GoBack();
            if ctx^.pp^.IsValid() and
               (ctx^.pp^.WeightLength > 0) and
               ( (ctx^.suppressState.CharCount = 0) or
                 ( ( (ctx^.cl = ctx^.suppressState.cl) and (ctx^.ppLevel <> ctx^.suppressState.CharCount) ) or
                   ( (ctx^.cl <> ctx^.suppressState.cl) and (ctx^.ppLevel < ctx^.suppressState.CharCount) )
                 )
               )
            then begin
              AddWeightsAndClear();
              ok := True;
              Break;
            end;
          end;
          if ok then begin
            AdvanceCharPos();
            exit(True);// Continue;
          end;
          if (ctx^.pp <> nil) then begin
            AddComputedWeights(ctx^.cp);
            ClearHistory();
            ClearPP(ctx);
            ok := True;
          end;
        end;
      end;
    end;
    if ctx^.surrogateState then begin
      Inc(ctx^.ps);
      Inc(ctx^.i);
    end;
    //
    Inc_I();
    if ok then
      exit(True);
  end;
  SetLength(ctx^.r,ctx^.ral);
  ctx^.Finished := True;
  Result := True;
end;

function ComputeSortKey(
  const AStr       : PUnicodeChar;
  const ALength    : SizeInt;
  const ACollation : PUCA_DataBook
) : TUCASortKey;
var
  r : TUCA_PropWeightsArray;
begin
  r := ComputeRawSortKey(AStr,ALength,ACollation);
  Result := FormKey(r,ACollation);
end;

end.
