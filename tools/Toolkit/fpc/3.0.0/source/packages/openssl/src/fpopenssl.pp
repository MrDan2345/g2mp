{
    This file is part of the Free Component Library (FCL)
    Copyright (c) 1999-2000 by the Free Pascal development team

    Small OOP wrapper around OpenSSL unit.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit fpopenssl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, openssl, ctypes;
Type
  TSSLType = (stAny,stSSLv2,stSSLv3,stTLSv1);

  //  PASN1_INTEGER = SslPtr;

  { TSSLData }

  TSSLData = Class(TPersistent)
  private
    FFileName: String;
    FValue: String;
  Public
    Function Empty : Boolean;
    Procedure Assign(Source : TPersistent);override;
    Property FileName : String Read FFileName Write FFileName;
    Property Value: String Read FValue Write FValue;
  end;

  { TSocketHandler }

  { TSSLContext }

  TSSLContext = Class(TObject)
  private
    FCTX: PSSL_CTX;
    function UsePrivateKey(pkey: SslPtr): cInt;
    function UsePrivateKeyASN1(pk: cInt; d: String; len: cLong): cInt;
    function UsePrivateKeyFile(const Afile: String; Atype: cInt): cInt;
  Public
    Constructor Create(AContext : PSSL_CTX = Nil); overload;
    Constructor Create(AType : TSSLType); overload;
    Destructor Destroy; override;
    Function SetCipherList(Var ACipherList : String) : Integer;
    procedure SetVerify(mode: Integer; arg2: PFunction);
    procedure SetDefaultPasswdCb(cb: PPasswdCb);
    procedure SetDefaultPasswdCbUserdata(u: SslPtr);
    Function UsePrivateKey(Data : TSSLData) : cint;
    // Use certificate.
    Function UseCertificate(Data : TSSLData) : cint;
    function UseCertificateASN1(len: cLong; d: String):cInt;
    function UseCertificateFile(const Afile: String; Atype: cInt):cInt;
    function UseCertificateChainFile(const Afile: PChar):cInt;
    function UseCertificate(x: SslPtr):cInt;
    function LoadVerifyLocations(const CAfile: String; const CApath: String):cInt;
    function LoadPFX(Const S,APassword : AnsiString) : cint;
    function LoadPFX(Data : TSSLData; Const APAssword : Ansistring) : cint;
    Property CTX: PSSL_CTX Read FCTX;
  end;

  TSSL = Class(TObject)
  Public
    FSSL : PSSL;
  Public
    Constructor Create(ASSL : PSSL = Nil);
    Constructor Create(AContext : TSSLContext);
    destructor Destroy; override;
    function SetFd(fd: cInt):cInt;
    function Accept : cInt;
    function Connect : cInt;
    function Shutdown : cInt;
    function Read(buf: SslPtr; num: cInt):cInt;
    function Peek(buf: SslPtr; num: cInt):cInt;
    function Write(buf: SslPtr; num: cInt):cInt;
    Function PeerCertificate : PX509;
    function Ctrl(cmd: cInt; larg: clong; parg: Pointer): cInt;
    function Pending:cInt;
    Function GetError(AResult :cint) : cint;
    function GetCurrentCipher :SslPtr;
    function Version: String;
    function PeerName: string;
    function PeerNameHash: cardinal;
    function PeerSubject : String;
    Function PeerIssuer : String;
    Function PeerSerialNo : Integer;
    Function PeerFingerprint : String;
    Function CertInfo : String;
    function CipherName: string;
    function CipherBits: integer;
    function CipherAlgBits: integer;
    Function VerifyResult : Integer;
    Property SSL: PSSL Read FSSL;
  end;

  ESSL = Class(Exception);

Function BioToString(B : PBIO) : AnsiString;

implementation

Resourcestring
  SErrCountNotGetContext = 'Failed to create SSL Context';
  SErrFailedToCreateSSL = 'Failed to create SSL';

Function BioToString(B : PBIO) : AnsiString;

Var
  L,RL : Integer;
begin
  l:=bioctrlpending(B);
  Result:=StringOfChar(#0,l);
  RL:=BioRead(B,Result,L);
  if (RL>0) then
    SetLength(Result,RL)
  else
    SetLength(Result,0);
end;

{ TSSLContext }

Constructor TSSLContext.Create(AContext: PSSL_CTX);
begin
  FCTX:=AContext
end;

Constructor TSSLContext.Create(AType: TSSLType);

Var
  C : PSSL_CTX;

begin
  Case AType of
    stAny:  C := SslCtxNew(SslMethodV23);
    stSSLv2: C := SslCtxNew(SslMethodV2);
    stSSLv3: C := SslCtxNew(SslMethodV3);
    stTLSv1: C := SslCtxNew(SslMethodTLSV1);
  end;
  if (C=Nil) then
     Raise ESSL.Create(SErrCountNotGetContext);
  Create(C);
end;

Destructor TSSLContext.Destroy;
begin
  SslCtxFree(FCTX);
  inherited Destroy;
end;

Function TSSLContext.SetCipherList(Var ACipherList: String): Integer;
begin
  Result:=SSLCTxSetCipherList(FCTX,ACipherList);
end;

procedure TSSLContext.SetVerify(mode: Integer; arg2: PFunction);
begin
  SslCtxSetVerify(FCtx,Mode,arg2);
end;

procedure TSSLContext.SetDefaultPasswdCb(cb: PPasswdCb);
begin
  SslCtxSetDefaultPasswdCb(Fctx,cb)
end;

procedure TSSLContext.SetDefaultPasswdCbUserdata(u: SslPtr);
begin
  SslCtxSetDefaultPasswdCbUserdata(FCTX,u);
end;

function TSSLContext.UsePrivateKey(pkey: SslPtr):cInt;
begin
  Result:=SslCtxUsePrivateKey(FCTX,pkey);
end;

function TSSLContext.UsePrivateKeyASN1(pk: cInt; d: String; len: cLong):cInt;
begin
  Result:=SslCtxUsePrivateKeyASN1(pk,FCtx,d,len);
end;

function TSSLContext.UsePrivateKeyFile(const Afile: String; Atype: cInt):cInt;
begin
  Result:=SslCtxUsePrivateKeyFile(FCTX,AFile,AType);
end;


Function TSSLContext.UsePrivateKey(Data: TSSLData): cint;

Var
  S : AnsiString;

begin
  Result:=-1;
  If (Data.Value<>'') then
    begin
    S:=Data.Value;
    Result:=UsePrivateKeyASN1(EVP_PKEY_RSA,S,length(S));
    end
  else if (Data.FileName<>'') then
    begin
    S:=Data.FileName;
    Result:=UsePrivateKeyFile(S,SSL_FILETYPE_PEM);
    if (Result<>1) then
      Result:=UsePrivateKeyFile(S,SSL_FILETYPE_ASN1);
    end;
end;

Function TSSLContext.UseCertificate(Data: TSSLData): cint;

Var
  S : AnsiString;
begin
  Result:=-1;
  if (Data.Value<>'') then
    begin
    S:=Data.Value;
    Result:=UseCertificateASN1(length(S),S);
    end
  else if (Data.FileName<>'') then
    begin
    S:=Data.FileName;
    Result:=UseCertificateChainFile(PChar(S));
    if Result<>1 then
       begin
       Result:=UseCertificateFile(S,SSL_FILETYPE_PEM);
       if Result<>1 then
         Result:=UseCertificateFile(S,SSL_FILETYPE_ASN1);
       end;
    end
end;

function TSSLContext.UseCertificateASN1(len: cLong; d: String): cInt;
begin
  Result:=sslctxUseCertificateASN1(FCTX,len,d);
end;

function TSSLContext.UseCertificateFile(const Afile: String; Atype: cInt): cInt;
begin
  Result:=sslctxUseCertificateFile(FCTX,Afile,Atype);
end;

function TSSLContext.UseCertificateChainFile(const Afile: PChar): cInt;
begin
  Result:=sslctxUseCertificateChainFile(FCTX,Afile);
end;

function TSSLContext.UseCertificate(x: SslPtr): cInt;
begin
  Result:=SSLCTXusecertificate(FCTX,X);
end;

function TSSLContext.LoadVerifyLocations(const CAfile: String; const CApath: String): cInt;
begin
  Result:=SslCtxLoadVerifyLocations(FCTX,CAfile,CApath);
end;

function TSSLContext.LoadPFX(Const S, APassword: AnsiString): cint;

var
  b: PBIO;
  p12,c,pk,ca: SslPtr;

begin
  Result:=-1;
  c:=nil;
  pk:=nil;
  ca:=nil;
  p12:=Nil;
  b:=BioNew(BioSMem);
  try
    BioWrite(b,S,Length(S));
    p12:=d2iPKCS12bio(b,nil);
  finally
    BioFreeAll(b);
  end;
  if Not Assigned(p12) then
    Exit;
  try
    try
      if PKCS12parse(p12,APassword,pk,c,ca)>0 then
        begin
        Result:=UseCertificate(c);
        if (Result>0) then
          Result:=UsePrivateKey(pk);
        end;
    finally
      EvpPkeyFree(pk);
      X509free(c);
//      SkX509PopFree(ca,_X509Free);
    end;
  finally
    PKCS12free(p12);
  end;
end;

function TSSLContext.LoadPFX(Data: TSSLData; Const APAssword : Ansistring): cint;

Var
  S : String;

begin
  Result:=-1;
  try
    if (Data.Value<>'') then
      S:=Data.Value
    else
      With TFileStream.Create(Data.FileName,fmOpenRead or fmShareDenyNone) do
        Try
          SetLength(S,Size);
          ReadBuffer(S[1],Size);
        finally
          Free;
        end;
    Result:=LoadPFX(s,APassword);
  except
    // Silently ignore
    Exit;
  end;
end;


{ TSSLData }

Function TSSLData.Empty: Boolean;
begin
  Result:=(Value='') and (FileName='');
end;

Procedure TSSLData.Assign(Source: TPersistent);


begin
  if Source is TSSLData then
   With TSSLData(Source) do
    begin
    Self.FValue:=FValue;
    Self.FFileName:=FFileName;
    end
  else
    inherited Assign(Source);
end;

{ TSSL }

Constructor TSSL.Create(ASSL: PSSL);
begin
  FSSL:=ASSL;
end;

Constructor TSSL.Create(AContext: TSSLContext);
begin
  FSSL:=Nil;
  if Assigned(AContext) and Assigned(AContext.CTX) then
    FSSL:=sslNew(AContext.CTX);
  If (FSSL=Nil) then
    Raise ESSL.Create(SErrFailedToCreateSSL)
end;

destructor TSSL.Destroy;
begin
  sslfree(FSSL);
  inherited Destroy;
end;

function TSSL.Ctrl(cmd: cInt; larg: clong; parg: Pointer): cInt;

begin
  Result:=sslCtrl(fSSL,cmd,larg,parg);
end;

function TSSL.SetFd(fd: cInt): cInt;
begin
  Result:=sslSetFD(fSSL,fd);
end;

function TSSL.Accept: cInt;
begin
  Result:=sslAccept(fSSL);
end;

function TSSL.Connect: cInt;
begin
  Result:=sslConnect(fSSL);
end;

function TSSL.Shutdown: cInt;
begin
  Result:=sslShutDown(fSSL);
end;

function TSSL.Read(buf: SslPtr; num: cInt): cInt;
begin
  Result:=sslRead(FSSL,buf,num);
end;

function TSSL.Peek(buf: SslPtr; num: cInt): cInt;
begin
  Result:=sslPeek(FSSL,buf,num);
end;

function TSSL.Write(buf: SslPtr; num: cInt): cInt;
begin
  Result:=sslWrite(FSSL,buf,num);
end;

Function TSSL.PeerCertificate: PX509;
begin
  Result:=sslGetPeercertificate(FSSL);
end;

function TSSL.Pending: cInt;
begin
  Result:=sslPending(FSSL);
end;

Function TSSL.GetError(AResult: cint): cint;
begin
  Result:=SslGetError(FSsl,AResult);
end;

function TSSL.GetCurrentCipher: SslPtr;
begin
  Result:=SSLGetCurrentCipher(FSSL);
end;

function TSSL.Version: String;
begin
  Result:=SSlGetVersion(FSsl);
end;

function TSSL.PeerName: string;
var
  s : ansistring;
  p : Integer;
begin
  Result:='';
  S:=PeerSubject;
  P:=Pos(S,'/CN=');
  if (P>0) then
    begin
    Delete(S,1,P+3);
    P:=Pos('/',S);
    if (P>0) then
      Result:=Copy(S,1,P-1);
    end;
end;

function TSSL.PeerNameHash: cardinal;
var
  C : PX509;
begin
  Result:=0;
  c:=PeerCertificate;
  if (C=Nil) then
    exit;
  try
    Result:=X509NameHash(X509GetSubjectName(C));
  finally
    X509Free(C);
  end;
end;

function TSSL.PeerSubject: String;
var
  c : PX509;
  s : ansistring;

begin
  Result:='';
  c:=PeerCertificate;
  if Assigned(c) then
    try
      setlength(s, 4096);
      Result:=X509NameOneline(X509GetSubjectName(c),s,Length(s));
    finally
      X509Free(c);
    end;
end;

Function TSSL.PeerIssuer: String;

var
  C: PX509;
  S: ansistring;

begin
  Result:='';
  C:=PeerCertificate;
  if (C=Nil) then
    Exit;
  try
    S:=StringOfChar(#0,4096);
    Result:=X509NameOneline(X509GetIssuerName(C),S,4096);
  finally
    X509Free(C);
  end;
end;

Function TSSL.PeerSerialNo: Integer;
var
  C : PX509;
  SN : PASN1_INTEGER;

begin
  Result:=-1;
  C:=PeerCertificate;
  if (C=Nil) then
    exit;
  try
    SN:=X509GetSerialNumber(C);
    Result:=Asn1IntegerGet(SN);
  finally
    X509Free(C);
  end;
end;

Function TSSL.PeerFingerprint: String;
var
  C : PX509;
  L : integer;

begin
  Result:='';
  C:=PeerCertificate;
  if (C=Nil) then
    Exit;
  try
    Result:=StringOfChar(#0,EVP_MAX_MD_SIZE);
    L:=0;
    X509Digest(C,EvpGetDigestByName('MD5'),Result,L);
    SetLength(Result,L);
  finally
    X509Free(C);
  end;
end;

Function TSSL.CertInfo: String;
var
  C : PX509;
  B : PBIO;

begin
  Result:='';
  C:=PeerCertificate;
  if (C=Nil)  then
    Exit;
  try
    B:=BioNew(BioSMem);
    try
      X509Print(B,C);
      Result:=BioToString(B);
    finally
      BioFreeAll(B);
    end;
  finally
    X509Free(C);
  end;
end;

function TSSL.CipherName: string;
begin
  Result:=SslCipherGetName(GetCurrentCipher);
end;

function TSSL.CipherBits: integer;

var
  x: integer;

begin
  x:=0;
  Result:=SSLCipherGetBits(GetCurrentCipher,x);
end;

function TSSL.CipherAlgBits: integer;

begin
  Result:=0;
  SSLCipherGetBits(GetCurrentCipher,Result);
end;

Function TSSL.VerifyResult: Integer;

begin
  Result:=SslGetVerifyResult(FSsl);
end;

end.

