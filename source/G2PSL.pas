unit G2PSL;

interface

uses
  Types,
  Classes,
  G2Types,
  G2Utils;

type
  TG2ParserPSL = class (TG2Parser)
  public
    constructor Create(const ParseText: AnsiString; const CaseSensitive: Boolean = False); override;
  end;

function G2ProcessPSL(const PSL: AnsiString; var HLSL: AnsiString; var GLSL: AnsiString; var Errors: AnsiString): Boolean;

implementation

//TG2ParserPSL BEGIN
constructor TG2ParserPSL.Create(const ParseText: AnsiString; const CaseSensitive: Boolean = False);
begin
  inherited Create(ParseText, False);
  AddComment('{', '}');
  AddComment('(*', '*)');
  AddCommentLine('//');
  AddString('''');
  AddSymbol(':=');
  AddSymbol('=');
  AddSymbol('-');
  AddSymbol('+');
  AddSymbol('*');
  AddSymbol('/');
  AddSymbol(';');
  AddSymbol(':');
  AddSymbol(',');
  AddSymbol('.');
  AddSymbol('(');
  AddSymbol(')');
  AddSymbol('[');
  AddSymbol(']');
  AddSymbol('>=');
  AddSymbol('>');
  AddSymbol('<=');
  AddSymbol('<');
  AddKeyWord('begin');
  AddKeyWord('end');
  AddKeyWord('var');
  AddKeyWord('const');
  AddKeyWord('input');
  AddKeyWord('output');
  AddKeyWord('attribute');
  AddKeyWord('uniform');
  AddKeyWord('function');
  AddKeyWord('procedure');
  AddKeyWord('if');
  AddKeyWord('else');
  AddKeyWord('of');
  AddKeyWord('array');
end;
//TG2ParserPSL END

function G2ProcessPSL(const PSL: AnsiString; var HLSL: AnsiString; var GLSL: AnsiString; var Errors: AnsiString): Boolean;
  var HLSLHead, HLSLBody, GLSLHead, GLSLBody: AnsiString;
  procedure AddError(const Str: AnsiString);
  begin
    Errors := Errors + Str + #$D;
  end;
  procedure AddHLSLHead(const Str: AnsiString);
  begin
    if Length(HLSLHead) > 0 then
    HLSLHead := HLSLHead + ','#$D;
    HLSLHead := HLSLHead + '  ' + Str;
  end;
  procedure AddHLSLBody(const Str: AnsiString);
  begin
    HLSLBody := HLSLBody + '  ' + Str + #$D;
  end;
  procedure AddGLSLHead(const Str: AnsiString);
  begin
    GLSLHead := GLSLHead + Str + #$D;
  end;
  procedure AddGLSLBody(const Str: AnsiString);
  begin
    GLSLBody := GLSLBody + Str + #$D;
  end;
  var Types: array of AnsiString;
  procedure AddType(const Str: AnsiString);
  begin
    SetLength(Types, Length(Types) + 1);
    Types[High(Types)] := Str;
  end;
  procedure AddTypes;
  begin
    AddType('array');
    AddType('float');
    AddType('float1'); AddType('float2'); AddType('float3'); AddType('float4');
    AddType('float1x1'); AddType('float1x2'); AddType('float1x3'); AddType('float1x4');
    AddType('float2x1'); AddType('float2x2'); AddType('float2x3'); AddType('float2x4');
    AddType('float3x1'); AddType('float3x2'); AddType('float3x3'); AddType('float3x4');
    AddType('float4x1'); AddType('float4x2'); AddType('float4x3'); AddType('float4x4');
    AddType('integer');
    AddType('integer1'); AddType('integer2'); AddType('integer3'); AddType('integer4');
    AddType('integer1x1'); AddType('integer1x2'); AddType('integer1x3'); AddType('integer1x4');
    AddType('integer2x1'); AddType('integer2x2'); AddType('integer2x3'); AddType('integer2x4');
    AddType('integer3x1'); AddType('integer3x2'); AddType('integer3x3'); AddType('integer3x4');
    AddType('integer4x1'); AddType('integer4x2'); AddType('integer4x3'); AddType('integer4x4');
    AddType('boolean');
    AddType('boolean1'); AddType('boolean2'); AddType('boolean3'); AddType('boolean4');
    AddType('boolean1x1'); AddType('boolean1x2'); AddType('boolean1x3'); AddType('boolean1x4');
    AddType('boolean2x1'); AddType('boolean2x2'); AddType('boolean2x3'); AddType('boolean2x4');
    AddType('boolean3x1'); AddType('boolean3x2'); AddType('boolean3x3'); AddType('boolean3x4');
    AddType('boolean4x1'); AddType('boolean4x2'); AddType('boolean4x3'); AddType('boolean4x4');
  end;
  function ConvertTypeHLSL(const Str: AnsiString): AnsiString;
    var lc: AnsiString;
  begin
    lc := LowerCase(Str);
    if lc = 'array' then Result := ''
    else if lc = 'float' then Result := 'float'
    else if lc = 'float1' then Result := 'float' else if lc = 'float2' then Result := 'float2' else if lc = 'float3' then Result := 'float3' else if lc = 'float4' then Result := 'float4'
    else if lc = 'float1x1' then Result := 'float' else if lc = 'float1x2' then Result := 'float2' else if lc = 'float1x3' then Result := 'float3' else if lc = 'float1x4' then Result := 'float4'
    else if lc = 'float2x1' then Result := 'float2' else if lc = 'float2x2' then Result := 'float2x2' else if lc = 'float2x3' then Result := 'float2x3' else if lc = 'float2x4' then Result := 'float2x4'
    else if lc = 'float3x1' then Result := 'float3' else if lc = 'float3x2' then Result := 'float3x2' else if lc = 'float3x3' then Result := 'float3x3' else if lc = 'float3x4' then Result := 'float3x4'
    else if lc = 'float4x1' then Result := 'float4' else if lc = 'float4x2' then Result := 'float4x2' else if lc = 'float4x3' then Result := 'float4x3' else if lc = 'float4x4' then Result := 'float4x4'
    else if lc = 'integer' then Result := 'int'
    else if lc = 'integer1' then Result := 'int' else if lc = 'integer2' then Result := 'int2' else if lc = 'integer3' then Result := 'int3' else if lc = 'integer4' then Result := 'int4'
    else if lc = 'integer1x1' then Result := 'int' else if lc = 'integer1x2' then Result := 'int2' else if lc = 'integer1x3' then Result := 'int3' else if lc = 'integer1x4' then Result := 'int4'
    else if lc = 'integer2x1' then Result := 'int2' else if lc = 'integer2x2' then Result := 'int2x2' else if lc = 'integer2x3' then Result := 'int2x3' else if lc = 'integer2x4' then Result := 'int2x4'
    else if lc = 'integer3x1' then Result := 'int3' else if lc = 'integer3x2' then Result := 'int3x2' else if lc = 'integer3x3' then Result := 'int3x3' else if lc = 'integer3x4' then Result := 'int3x4'
    else if lc = 'integer4x1' then Result := 'int4' else if lc = 'integer4x2' then Result := 'int4x2' else if lc = 'integer4x3' then Result := 'int4x3' else if lc = 'integer4x4' then Result := 'int4x4'
    else if lc = 'boolean' then Result := 'bool'
    else if lc = 'boolean1' then Result := 'bool' else if lc = 'boolean2' then Result := 'bool2' else if lc = 'boolean3' then Result := 'bool3' else if lc = 'boolean4' then Result := 'bool4'
    else if lc = 'boolean1x1' then Result := 'bool' else if lc = 'boolean1x2' then Result := 'bool2' else if lc = 'boolean1x3' then Result := 'bool3' else if lc = 'boolean1x4' then Result := 'bool4'
    else if lc = 'boolean2x1' then Result := 'bool2' else if lc = 'boolean2x2' then Result := 'bool2x2' else if lc = 'boolean2x3' then Result := 'bool2x3' else if lc = 'boolean2x4' then Result := 'bool2x4'
    else if lc = 'boolean3x1' then Result := 'bool3' else if lc = 'boolean3x2' then Result := 'bool3x2' else if lc = 'boolean3x3' then Result := 'bool3x3' else if lc = 'boolean3x4' then Result := 'bool3x4'
    else if lc = 'boolean4x1' then Result := 'bool4' else if lc = 'boolean4x2' then Result := 'bool4x2' else if lc = 'boolean4x3' then Result := 'bool4x3' else if lc = 'boolean4x4' then Result := 'bool4x4';
  end;
  function IsType(const Str: AnsiString): Boolean;
    var i: Integer;
    var lc: AnsiString;
  begin
    lc := LowerCase(Str);
    for i := 0 to High(Types) do
    if Types[i] = lc then
    begin
      Result := True;
      Exit;
    end;
  end;
  type TVarClass = (vcVar, vcInput, vcOutput, vcConst, vcUniform);
  type TVarType = (vtFloat, vtFloatArr, vtInteger, vtIntegerArr, vtBoolean, vtBooleanArr);
  type TVar = record
    Name: AnsiString;
    VarClass: TVarClass;
    VarSize: Integer;
  end;
  type TParseStage = (psHead, psBody);
  var Parser: TG2ParserPSL;
  var Stage: TParseStage;
  var Token, Tmp0, Tmp1, Tmp3, Tmp4: AnsiString;
  var tt: TG2TokenType;
begin
  Result := True;
  HLSL := ''; HLSLHead := ''; HLSLBody := '';
  GLSL := ''; GLSLHead := ''; GLSLBody := '';
  Errors := '';
  Parser := TG2ParserPSL.Create(PSL);
  Stage := psHead;
  repeat
    case Stage of
      psHead:
      begin
        Token := Parser.NextToken(tt);
        if tt = ttKeyword then
        begin
          if (Token = 'input') or (Token = 'output') then
          begin
            if Token = 'input' then
            begin
              Tmp0 := 'const in ';
            end
            else if Token = 'output' then
            begin
              Tmp0 := 'out ';
            end;
            Token := Parser.NextToken(tt);
            if tt = ttWord then
            begin
              Tmp3 := Token;
              Token := Parser.NextToken(tt);
              if (tt = ttSymbol) and (Token = ':') then
              begin
                Token := Parser.NextToken(tt);
                if (tt = ttWord) and IsType(Token) then
                begin
                  Tmp0 := Tmp0 + ConvertTypeHLSL(Token) + ' ' + Tmp3 + ': ';
                  Token := Parser.NextToken(tt);
                  if (tt = ttSymbol) and (Token = ';') then
                  begin
                    Token := Parser.NextToken(tt);
                    if (tt = ttKeyword) and (Token = 'attribute') then
                    begin
                      Token := Parser.NextToken(tt);
                      if tt = ttWord then
                      begin
                        Tmp0 := Tmp0 + Token;
                        Token := Parser.NextToken(tt);
                        if (tt = ttSymbol) and (Token = ';') then
                        begin
                          AddHLSLHead(Tmp0);
                        end
                        else
                        begin
                          AddError('Uexpected token ' + Token);
                          Result := False;
                        end;
                      end
                      else
                      begin
                        AddError('Uexpected token ' + Token);
                        Result := False;
                      end;
                    end
                    else
                    begin
                      AddError('Uexpected token ' + Token);
                      Result := False;
                    end;
                  end
                  else
                  begin
                    AddError('Uexpected token ' + Token);
                    Result := False;
                  end;
                end
                else if (tt = ttKeyword) and (Token = 'array') then
                begin

                end
                else
                begin
                  AddError('Uexpected token ' + Token);
                  Result := False;
                end;
              end
              else
              begin
                AddError('Uexpected token ' + Token);
                Result := False;
              end;
            end
            else
            begin
              AddError('Unexpected token ' + Token);
              Result := False;
            end;
          end
          else if Token = 'uniform' then
          begin
            Tmp0 := 'uniform ';
            Token := Parser.NextToken(tt);
            if tt = ttWord then
            begin
              Tmp3 := Token;
              Token := Parser.NextToken(tt);
              if (tt = ttSymbol) and (Token = ':') then
              begin
                Token := Parser.NextToken(tt);
                if (tt = ttWord) and IsType(Token) then
                begin
                  Tmp0 := Tmp0 + ConvertTypeHLSL(Token) + ' ' + Tmp3;
                  Token := Parser.NextToken(tt);
                  if (tt = ttSymbol) and (Token = ';') then
                  begin
                    AddHLSLHead(Tmp0);
                  end
                  else
                  begin
                    AddError('Unexpected token ' + Token);
                    Result := False;
                  end;
                end
                else
                begin
                  AddError('Unexpected token ' + Token);
                  Result := False;
                end;
              end
              else
              begin
                AddError('Uexpected token ' + Token);
                Result := False;
              end;
            end
            else
            begin
              AddError('Uexpected token ' + Token);
              Result := False;
            end;
          end
          else if (Token = 'const') or (Token = 'var') then
          begin
            Tmp4 := Token;
            if Token = 'const' then
            begin
              Tmp0 := 'static const ';
            end
            else if Token = 'var' then
            begin
              Tmp0 := '';
            end;
            Token := Parser.NextToken(tt);
            if tt = ttWord then
            begin
              Tmp3 := Token;
              Token := Parser.NextToken(tt);
              if (tt = ttSymbol) and (Token = ':') then
              begin
                Token := Parser.NextToken(tt);
                if (tt = ttWord) and IsType(Token) then
                begin
                  Tmp0 := Tmp0 + ConvertTypeHLSL(Token) + ' ' + Tmp3;
                  Token := Parser.NextToken(tt);
                  if (tt = ttSymbol)
                  and ((Token = '=') or ((Token = ';') and (Tmp4 = 'var'))) then
                  begin
                    if Token = '=' then
                    begin
                      Tmp0 := Tmp0 + ' = ';
                      repeat
                        Token := Parser.NextToken(tt);
                        Tmp0 := Tmp0 + Token;
                      until (tt = ttEOF) or ((tt = ttSymbol) and (Token = ';'));
                      if (tt = ttSymbol) and (Token = ';') then
                      begin
                        AddHLSLBody(Tmp0);
                      end
                      else
                      begin
                        AddError('Uexpected token ' + Token);
                        Result := False;
                      end;
                    end
                    else if Token = ';' then
                    begin
                      Tmp0 := Tmp0 + ';';
                      AddHLSLBody(Tmp0);
                    end;
                  end
                  else
                  begin
                    AddError('Uexpected token ' + Token);
                    Result := False;
                  end;
                end
                else
                begin
                  AddError('Uexpected token ' + Token);
                  Result := False;
                end;
              end
              else
              begin
                AddError('Uexpected token ' + Token);
                Result := False;
              end;
            end
            else
            begin
              AddError('Uexpected token ' + Token);
              Result := False;
            end;
          end
          else
          begin
            AddError('Uexpected token ' + Token);
            Result := False;
          end;
        end
        else
        begin
          AddError('Uexpected token ' + Token);
          Result := False;
        end;
      end;
      psBody:
      begin

      end;
    end;
  until not Result or (tt = ttEOF);
  Parser.Free;
  //if Result then
  begin
    HLSL := 'void main ('#$D + HLSLHead + #$D') {'#$D + HLSLBody + '}';
    GLSL := 'void main ('#$D + GLSLHead + ') {'#$D + GLSLBody + '}';
  end;
end;

end.
