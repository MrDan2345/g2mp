{
    This file is part of the Free Component Library

    JSON source parser
    Copyright (c) 2007 by Michael Van Canneyt michael@freepascal.org

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$mode objfpc}
{$h+}
unit jsonparser;

interface

uses
  Classes, SysUtils, fpJSON, jsonscanner;
  
Type

  { TJSONParser }

  TJSONParser = Class(TObject)
  Private
    FScanner : TJSONScanner;
    FuseUTF8,
    FStrict: Boolean;
    function ParseNumber: TJSONNumber;
    procedure SetStrict(const AValue: Boolean);
    function GetUTF8 : Boolean;
    procedure SetUTF8(const AValue: Boolean);
  Protected
    procedure DoError(const Msg: String);
    function DoParse(AtCurrent,AllowEOF: Boolean): TJSONData;
    function GetNextToken: TJSONToken;
    function CurrentTokenString: String;
    function CurrentToken: TJSONToken;
    function ParseArray: TJSONArray;
    function ParseObject: TJSONObject;
    Property Scanner : TJSONScanner read FScanner;
  Public
    function Parse: TJSONData;
    Constructor Create(Source : TStream; AUseUTF8 : Boolean = True); overload;
    Constructor Create(Source : TJSONStringType; AUseUTF8 : Boolean = True); overload;
    destructor Destroy();override;
    // Use strict JSON: " for strings, object members are strings, not identifiers
    Property Strict : Boolean Read FStrict Write SetStrict;
    // if set to TRUE, then strings will be converted to UTF8 ansistrings, not system codepage ansistrings.
    Property UseUTF8 : Boolean Read GetUTF8 Write SetUTF8;
  end;
  
  EJSONParser = Class(EParserError);
  
implementation

Resourcestring
  SErrUnexpectedEOF   = 'Unexpected EOF encountered.';
  SErrUnexpectedToken = 'Unexpected token (%s) encountered.';
  SErrExpectedColon   = 'Expected colon (:), got token "%s".';
  SErrUnexpectedComma = 'Invalid comma encountered.';
  SErrEmptyElement = 'Empty element encountered.';
  SErrExpectedElementName    = 'Expected element name, got token "%s"';
  SExpectedCommaorBraceClose = 'Expected , or ], got token "%s".';
  SErrInvalidNumber          = 'Number is not an integer or real number: %s';
  SErrNoScanner = 'No scanner. No source specified ?';
  
{ TJSONParser }

procedure DefJSONParserHandler(AStream: TStream; const AUseUTF8: Boolean; out
  Data: TJSONData);

Var
  P : TJSONParser;

begin
  Data:=Nil;
  P:=TJSONParser.Create(AStream,AUseUTF8);
  try
    Data:=P.Parse;
  finally
    P.Free;
  end;
end;

Function TJSONParser.Parse : TJSONData;

begin
  if (FScanner=Nil) then
    DoError(SErrNoScanner);
  Result:=DoParse(False,True);
end;

{
  Consume next token and convert to JSON data structure.
  If AtCurrent is true, the current token is used. If false,
  a token is gotten from the scanner.
  If AllowEOF is false, encountering a tkEOF will result in an exception.
}

Function TJSONParser.CurrentToken : TJSONToken;

begin
  Result:=FScanner.CurToken;
end;

Function TJSONParser.CurrentTokenString : String;

begin
  If CurrentToken in [tkString,tkIdentifier,tkNumber] then
    Result:=FScanner.CurTokenString
  else
    Result:=TokenInfos[CurrentToken];
end;

Function TJSONParser.DoParse(AtCurrent,AllowEOF : Boolean) : TJSONData;

var
  T : TJSONToken;
  
begin
  Result:=nil;
  try
    If not AtCurrent then
      T:=GetNextToken
    else
      T:=FScanner.CurToken;
    Case T of
      tkEof : If Not AllowEof then
                DoError(SErrUnexpectedEOF);
      tkNull  : Result:=CreateJSON;
      tkTrue,
      tkFalse : Result:=CreateJSON(t=tkTrue);
      tkString : Result:=CreateJSON(CurrentTokenString);
      tkCurlyBraceOpen : Result:=ParseObject;
      tkCurlyBraceClose : DoError(SErrUnexpectedToken);
      tkSQuaredBraceOpen : Result:=ParseArray;
      tkSQuaredBraceClose : DoError(SErrUnexpectedToken);
      tkNumber : Result:=ParseNumber;
      tkComma : DoError(SErrUnexpectedToken);
    end;
  except
    FreeAndNil(Result);
    Raise;
  end;
end;


// Creates the correct JSON number type, based on the current token.
Function TJSONParser.ParseNumber : TJSONNumber;

Var
  I : Integer;
  I64 : Int64;
  QW  : QWord;
  F : TJSONFloat;
  S : String;

begin
  S:=CurrentTokenString;
  I:=0;
  if TryStrToQWord(S,QW) then
    begin
    if QW>qword(high(Int64)) then
      Result:=CreateJSON(QW)
    else
      if QW>MaxInt then
      begin
        I64 := QW;
        Result:=CreateJSON(I64);
      end
      else
      begin
        I := QW;
        Result:=CreateJSON(I);
      end
    end
  else
    begin
    If TryStrToInt64(S,I64) then
      if (I64>Maxint) or (I64<-MaxInt) then
        Result:=CreateJSON(I64)
      Else
        begin
        I:=I64;
        Result:=CreateJSON(I);
        end
    else
      begin
      I:=0;
      Val(S,F,I);
      If (I<>0) then
        DoError(SErrInvalidNumber);
      Result:=CreateJSON(F);
      end;
    end;

end;

function TJSONParser.GetUTF8 : Boolean;

begin
  if Assigned(FScanner) then
    Result:=FScanner.UseUTF8
  else
    Result:=FUseUTF8;  
end;

procedure TJSONParser.SetUTF8(const AValue: Boolean);

begin
  FUseUTF8:=AValue;
  if Assigned(FScanner) then
    FScanner.UseUTF8:=FUseUTF8;
end;

procedure TJSONParser.SetStrict(const AValue: Boolean);
begin
  if (FStrict=AValue) then
     exit;
  FStrict:=AValue;
  If Assigned(FScanner) then
    FScanner.Strict:=Fstrict;
end;

// Current token is {, on exit current token is }
Function TJSONParser.ParseObject : TJSONObject;

Var
  T : TJSONtoken;
  E : TJSONData;
  N : String;
  
begin
  Result:=CreateJSONObject([]);
  Try
    T:=GetNextToken;
    While T<>tkCurlyBraceClose do
      begin
      If (T<>tkString) and (T<>tkIdentifier) then
        DoError(SErrExpectedElementName);
      N:=CurrentTokenString;
      T:=GetNextToken;
      If (T<>tkColon) then
        DoError(SErrExpectedColon);
      E:=DoParse(False,False);
      Result.Add(N,E);
      T:=GetNextToken;
      If Not (T in [tkComma,tkCurlyBraceClose]) then
        DoError(SExpectedCommaorBraceClose);
      If T=tkComma then
        T:=GetNextToken;
      end;
  Except
    FreeAndNil(Result);
    Raise;
  end;
end;

// Current token is [, on exit current token is ]
Function TJSONParser.ParseArray : TJSONArray;

Var
  T : TJSONtoken;
  E : TJSONData;
  LastComma : Boolean;
  
begin
  Result:=CreateJSONArray([]);
  LastComma:=False;
  Try
    Repeat
      T:=GetNextToken;
      If (T<>tkSquaredBraceClose) then
        begin
        E:=DoParse(True,False);
        If (E<>Nil) then
          Result.Add(E)
        else if (Result.Count>0) then
          DoError(SErrEmptyElement);
        T:=GetNextToken;
        If Not (T in [tkComma,tkSquaredBraceClose]) then
          DoError(SExpectedCommaorBraceClose);
        LastComma:=(t=TkComma);
        end;
    Until (T=tkSquaredBraceClose);
    If LastComma then // Test for ,] case
      DoError(SErrUnExpectedToken);
  Except
    FreeAndNil(Result);
    Raise;
  end;
end;

// Get next token, discarding whitespace
Function TJSONParser.GetNextToken : TJSONToken ;

begin
  Repeat
    Result:=FScanner.FetchToken;
  Until (Result<>tkWhiteSpace);
end;

Procedure TJSONParser.DoError(const Msg : String);

Var
  S : String;

begin
  S:=Format(Msg,[CurrentTokenString]);
  S:=Format('Error at line %d, Pos %d:',[FScanner.CurRow,FSCanner.CurColumn])+S;
  Raise EJSONParser.Create(S);
end;

constructor TJSONParser.Create(Source: TStream; AUseUTF8 : Boolean = True);
begin
  Inherited Create;
  FScanner:=TJSONScanner.Create(Source);
  UseUTF8:=AUseUTF8;
end;

constructor TJSONParser.Create(Source: TJSONStringType; AUseUTF8 : Boolean = True);
begin
  Inherited Create;
  FScanner:=TJSONScanner.Create(Source);
  UseUTF8:=AUseUTF8;
end;

destructor TJSONParser.Destroy();
begin
  FreeAndNil(FScanner);
  inherited Destroy();
end;

Procedure InitJSONHandler;

begin
  if GetJSONParserHandler=Nil then
    SetJSONParserHandler(@DefJSONParserHandler);
end;

Procedure DoneJSONHandler;

begin
  if GetJSONParserHandler=@DefJSONParserHandler then
    SetJSONParserHandler(Nil);
end;

initialization
  InitJSONHandler;
finalization
  DoneJSONHandler;
end.

