{
    This file is part of the Free Component Library

    JSON source lexical scanner
    Copyright (c) 2007 by Michael Van Canneyt michael@freepascal.org

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$mode objfpc}
{$h+}

unit jsonscanner;

interface

uses SysUtils, Classes;

resourcestring
  SErrInvalidCharacter = 'Invalid character at line %d, pos %d: ''%s''';
  SErrOpenString = 'string exceeds end of line';

type

  TJSONToken = (
    tkEOF,
    tkWhitespace,
    tkString,
    tkNumber,
    tkTrue,
    tkFalse,
    tkNull,
    // Simple (one-character) tokens
    tkComma,                 // ','
    tkColon,                 // ':'
    tkCurlyBraceOpen,        // '{'
    tkCurlyBraceClose,       // '}'
    tkSquaredBraceOpen,       // '['
    tkSquaredBraceClose,      // ']'
    tkIdentifier,            // Any Javascript identifier
    tkUnknown
    );

  EScannerError       = class(EParserError);


  { TJSONScanner }

  TJSONScanner = class
  private
    FSource : TStringList;
    FCurRow: Integer;
    FCurToken: TJSONToken;
    FCurTokenString: string;
    FCurLine: string;
    FStrict: Boolean;
    FUseUTF8 : Boolean;
    TokenStr: PChar;
    function GetCurColumn: Integer;
  protected
    procedure Error(const Msg: string);overload;
    procedure Error(const Msg: string; Const Args: array of Const);overload;
    function DoFetchToken: TJSONToken;
  public
    constructor Create(Source : TStream; AUseUTF8 : Boolean = True); overload;
    constructor Create(const Source : String; AUseUTF8 : Boolean = True); overload;
    destructor Destroy; override;
    function FetchToken: TJSONToken;


    property CurLine: string read FCurLine;
    property CurRow: Integer read FCurRow;
    property CurColumn: Integer read GetCurColumn;

    property CurToken: TJSONToken read FCurToken;
    property CurTokenString: string read FCurTokenString;
    // Use strict JSON: " for strings, object members are strings, not identifiers
    Property Strict : Boolean Read FStrict Write FStrict;
    // if set to TRUE, then strings will be converted to UTF8 ansistrings, not system codepage ansistrings.
    Property UseUTF8 : Boolean Read FUseUTF8 Write FUseUTF8;
  end;

const
  TokenInfos: array[TJSONToken] of string = (
    'EOF',
    'Whitespace',
    'String',
    'Number',
    'True',
    'False',
    'Null',
    ',',
    ':',
    '{',
    '}',
    '[',
    ']',
    'identifier',
    ''
  );


implementation

constructor TJSONScanner.Create(Source : TStream; AUseUTF8 : Boolean = True);

begin
  FSource:=TStringList.Create;
  FSource.LoadFromStream(Source);
  FUseUTF8:=AUseUTF8;
end;

constructor TJSONScanner.Create(const Source : String; AUseUTF8 : Boolean = True);
begin
  FSource:=TStringList.Create;
  FSource.Text:=Source;
  FUseUTF8:=AUseUTF8;
end;

destructor TJSONScanner.Destroy;
begin
  FreeAndNil(FSource);
  Inherited;
end;


function TJSONScanner.FetchToken: TJSONToken;
  
begin
  Result:=DoFetchToken;
end;

procedure TJSONScanner.Error(const Msg: string);
begin
  raise EScannerError.Create(Msg);
end;

procedure TJSONScanner.Error(const Msg: string; const Args: array of Const);
begin
  raise EScannerError.CreateFmt(Msg, Args);
end;

function TJSONScanner.DoFetchToken: TJSONToken;

  function FetchLine: Boolean;
  begin
    Result:=FCurRow<FSource.Count;
    if Result then
      begin
      FCurLine:=FSource[FCurRow];
      TokenStr:=PChar(FCurLine);
      Inc(FCurRow);
      end
    else             
      begin
      FCurLine:='';
      TokenStr:=nil;
      end;
  end;

var
  TokenStart, CurPos: PChar;
  it : TJSONToken;
  I : Integer;
  OldLength, SectionLength, Index: Integer;
  C : char;
  S : String;
  
begin
  if TokenStr = nil then
    if not FetchLine then
      begin
      Result := tkEOF;
      FCurToken := Result;
      exit;
      end;

  FCurTokenString := '';

  case TokenStr[0] of
    #0:         // Empty line
      begin
      FetchLine;
      Result := tkWhitespace;
      end;
    #9, ' ':
      begin
      Result := tkWhitespace;
      repeat
        Inc(TokenStr);
        if TokenStr[0] = #0 then
          if not FetchLine then
          begin
            FCurToken := Result;
            exit;
          end;
      until not (TokenStr[0] in [#9, ' ']);
      end;
    '"','''':
      begin
        C:=TokenStr[0];
        If (C='''') and Strict then
          Error(SErrInvalidCharacter, [CurRow,CurColumn,TokenStr[0]]);
        Inc(TokenStr);
        TokenStart := TokenStr;
        OldLength := 0;
        FCurTokenString := '';
        while not (TokenStr[0] in [#0,C]) do
          begin
          if (TokenStr[0]='\') then
            begin
            // Save length
            SectionLength := TokenStr - TokenStart;
            Inc(TokenStr);
            // Read escaped token
            Case TokenStr[0] of
              '"' : S:='"';
              '''' : S:='''';
              't' : S:=#9;
              'b' : S:=#8;
              'n' : S:=#10;
              'r' : S:=#13;
              'f' : S:=#12;
              '\' : S:='\';
              '/' : S:='/';
              'u' : begin
                    S:='0000';
                    For I:=1 to 4 do
                      begin
                      Inc(TokenStr);
                      Case TokenStr[0] of
                        '0'..'9','A'..'F','a'..'f' :
                          S[i]:=Upcase(TokenStr[0]);
                      else
                        Error(SErrInvalidCharacter, [CurRow,CurColumn,TokenStr[0]]);
                      end;
                      end;
                    // WideChar takes care of conversion...  
                    if UseUTF8 then
                      S:=Utf8Encode(WideString(WideChar(StrToInt('$'+S))))
                    else
                      S:=WideChar(StrToInt('$'+S));  
                    end;
              #0  : Error(SErrOpenString);
            else
              Error(SErrInvalidCharacter, [CurRow,CurColumn,TokenStr[0]]);
            end;
            SetLength(FCurTokenString, OldLength + SectionLength+1+Length(S));
            if SectionLength > 0 then
              Move(TokenStart^, FCurTokenString[OldLength + 1], SectionLength);
            Move(S[1],FCurTokenString[OldLength + SectionLength+1],Length(S));
            Inc(OldLength, SectionLength+Length(S));
            // Next char
            // Inc(TokenStr);
            TokenStart := TokenStr+1;
            end;
          if TokenStr[0] = #0 then
            Error(SErrOpenString);
          Inc(TokenStr);
          end;
        if TokenStr[0] = #0 then
          Error(SErrOpenString);
        SectionLength := TokenStr - TokenStart;
        SetLength(FCurTokenString, OldLength + SectionLength);
        if SectionLength > 0 then
          Move(TokenStart^, FCurTokenString[OldLength + 1], SectionLength);
        Inc(TokenStr);
        Result := tkString;
      end;
    ',':
      begin
        Inc(TokenStr);
        Result := tkComma;
      end;
    '0'..'9','.','-':
      begin
        TokenStart := TokenStr;
        while true do
        begin
          Inc(TokenStr);
          case TokenStr[0] of
            '.':
              begin
                if TokenStr[1] in ['0'..'9', 'e', 'E'] then
                begin
                  Inc(TokenStr);
                  repeat
                    Inc(TokenStr);
                  until not (TokenStr[0] in ['0'..'9', 'e', 'E','-','+']);
                end;
                break;
              end;
            '0'..'9': ;
            'e', 'E':
              begin
                Inc(TokenStr);
                if TokenStr[0] in ['-','+']  then
                  Inc(TokenStr);
                while TokenStr[0] in ['0'..'9'] do
                  Inc(TokenStr);
                break;
              end;
            else
              break;
          end;
        end;
        SectionLength := TokenStr - TokenStart;
        SetLength(FCurTokenString, SectionLength);
        if SectionLength > 0 then
          Move(TokenStart^, FCurTokenString[1], SectionLength);
        If (FCurTokenString[1]='.') then
          FCurTokenString:='0'+FCurTokenString;
        Result := tkNumber;
      end;
    ':':
      begin
        Inc(TokenStr);
        Result := tkColon;
      end;
    '{':
      begin
        Inc(TokenStr);
        Result := tkCurlyBraceOpen;
      end;
    '}':
      begin
        Inc(TokenStr);
        Result := tkCurlyBraceClose;
      end;  
    '[':
      begin
        Inc(TokenStr);
        Result := tkSquaredBraceOpen;
      end;
    ']':
      begin
        Inc(TokenStr);
        Result := tkSquaredBraceClose;
      end;
    'a'..'z','A'..'Z','_':
      begin
        TokenStart := TokenStr;
        repeat
          Inc(TokenStr);
        until not (TokenStr[0] in ['A'..'Z', 'a'..'z', '0'..'9', '_']);
        SectionLength := TokenStr - TokenStart;
        SetLength(FCurTokenString, SectionLength);
        if SectionLength > 0 then
          Move(TokenStart^, FCurTokenString[1], SectionLength);
        for it := tkTrue to tkNull do
          if CompareText(CurTokenString, TokenInfos[it]) = 0 then
            begin
            Result := it;
            FCurToken := Result;
            exit;
            end;
        if Strict then
          Error(SErrInvalidCharacter, [CurRow,CurColumn,TokenStr[0]])
        else
          Result:=tkIdentifier;
      end;
  else
    Error(SErrInvalidCharacter, [CurRow,CurCOlumn,TokenStr[0]]);
  end;

  FCurToken := Result;
end;

function TJSONScanner.GetCurColumn: Integer;
begin
  Result := TokenStr - PChar(CurLine);
end;

end.
