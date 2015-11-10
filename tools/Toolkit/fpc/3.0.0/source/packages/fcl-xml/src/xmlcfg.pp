{
    This file is part of the Free Component Library

    Implementation of TXMLConfig class
    Copyright (c) 1999 - 2005 by Sebastian Guenther, sg@freepascal.org

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{
  TXMLConfig enables applications to use XML files for storing their
  configuration data
}

{$ifdef fpc}{$MODE objfpc}{$endif}
{$H+}

{ This unit is deprecated because it doesn't work well with non-ascii data.
  Attempts to change its behavior will likely cause problems with existing
  config files, so it is superseded altogether by xmlconf unit. }
unit XMLCfg deprecated;

interface

{off $DEFINE MEM_CHECK}

uses
  {$IFDEF MEM_CHECK}MemCheck,{$ENDIF}
  SysUtils, Classes, DOM, XMLRead, XMLWrite;

resourcestring
  SMissingPathName = 'A part of the pathname is invalid (missing)';
  SEscapingNecessary = 'Invalid pathname, escaping must be enabled';
  SWrongRootName = 'XML file has wrong root element name';

type

  EXMLConfigError = class(Exception);

  {"APath" is the path and name of a value: A XML configuration file is
   hierachical. "/" is the path delimiter, the part after the last "/"
   is the name of the value. The path components will be mapped to XML
   elements, the name will be an element attribute.}

  TXMLConfig = class(TComponent)
  private
    FFilename: String;
    FStartEmpty: Boolean;
    FUseEscaping: Boolean;
    FRootName: DOMString;
    procedure SetFilenameForce(const AFilename: String; ForceReload: Boolean);
    procedure SetFilename(const AFilename: String);
    procedure SetStartEmpty(AValue: Boolean);
    procedure SetRootName(const AValue: DOMString);
  protected
    Doc: TXMLDocument;
    FModified: Boolean;
    procedure Loaded; override;
    function FindNode(const APath: String; PathHasValue: boolean): TDomNode;
    function Escape(const s: String): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    procedure Flush;    // Writes the XML file
    function  GetValue(const APath, ADefault: String): String; overload;
    function  GetValue(const APath: String; ADefault: Integer): Integer; overload;
    function  GetValue(const APath: String; ADefault: Boolean): Boolean; overload;
    procedure SetValue(const APath, AValue: String); overload;
    procedure SetDeleteValue(const APath, AValue, DefValue: String); overload;
    procedure SetValue(const APath: String; AValue: Integer); overload;
    procedure SetDeleteValue(const APath: String; AValue, DefValue: Integer); overload;
    procedure SetValue(const APath: String; AValue: Boolean); overload;
    procedure SetDeleteValue(const APath: String; AValue, DefValue: Boolean); overload;
    procedure DeletePath(const APath: string);
    procedure DeleteValue(const APath: string);
    property Modified: Boolean read FModified;
  published
    property Filename: String read FFilename write SetFilename;
    property StartEmpty: Boolean read FStartEmpty write SetStartEmpty;
    property UseEscaping: Boolean read FUseEscaping write FUseEscaping
      default True;
    property RootName: DOMString read FRootName write SetRootName;
  end deprecated;


// ===================================================================

implementation


constructor TXMLConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUseEscaping := True;
  FRootName := 'CONFIG';
  Doc := TXMLDocument.Create;
  Doc.AppendChild(Doc.CreateElement(RootName));
end;

destructor TXMLConfig.Destroy;
begin
  if Assigned(Doc) then
  begin
    Flush;
    Doc.Free;
  end;
  inherited Destroy;
end;

procedure TXMLConfig.Clear;
begin
  Doc.ReplaceChild(Doc.CreateElement(RootName), Doc.DocumentElement);
end;

procedure TXMLConfig.Flush;
begin
 if (Filename<>EmptyStr) and Modified then
  begin
    WriteXMLFile(Doc, Filename);
    FModified := False;
  end;
end;

function TXMLConfig.GetValue(const APath, ADefault: String): String;
var
  Node, Child, Attr: TDOMNode;
  NodeName: String;
  PathLen: integer;
  StartPos, EndPos: integer;
begin
  Result := ADefault;
  PathLen := Length(APath);
  Node := Doc.DocumentElement;
  StartPos := 1;
  while True do
  begin
    EndPos := StartPos;
    while (EndPos <= PathLen) and (APath[EndPos] <> '/') do
      Inc(EndPos);
    if EndPos > PathLen then
      break;
    SetLength(NodeName, EndPos - StartPos);
    Move(APath[StartPos], NodeName[1], EndPos - StartPos);
    StartPos := EndPos + 1;
    Child := Node.FindNode(Escape(NodeName));
    if not Assigned(Child) then
      exit;
    Node := Child;
  end;
  if StartPos > PathLen then
    exit;
  SetLength(NodeName, PathLen - StartPos + 1);
  Move(APath[StartPos], NodeName[1], Length(NodeName));
  Attr := Node.Attributes.GetNamedItem(Escape(NodeName));
  if Assigned(Attr) then
    Result := Attr.NodeValue;
end;

function TXMLConfig.GetValue(const APath: String; ADefault: Integer): Integer;
begin
  Result := StrToIntDef(GetValue(APath, IntToStr(ADefault)),ADefault);
end;

function TXMLConfig.GetValue(const APath: String; ADefault: Boolean): Boolean;
var
  s: String;
begin
  if ADefault then
    s := 'True'
  else
    s := 'False';

  s := GetValue(APath, s);

  if AnsiCompareText(s, 'TRUE')=0 then
    Result := True
  else if AnsiCompareText(s, 'FALSE')=0 then
    Result := False
  else
    Result := ADefault;
end;

procedure TXMLConfig.SetValue(const APath, AValue: String);
var
  Node, Child: TDOMNode;
  NodeName: String;
  PathLen: integer;
  StartPos, EndPos: integer;
begin
  Node := Doc.DocumentElement;
  PathLen := Length(APath);
  StartPos:=1;
  while True do
  begin
    EndPos := StartPos;
    while (EndPos <= PathLen) and (APath[EndPos] <> '/') do
      Inc(EndPos);
    if EndPos > PathLen then
      break;
    SetLength(NodeName, EndPos - StartPos);
    Move(APath[StartPos], NodeName[1], EndPos - StartPos);
    StartPos := EndPos + 1;
    NodeName := Escape(NodeName);
    Child := Node.FindNode(NodeName);
    if not Assigned(Child) then
    begin
      Child := Doc.CreateElement(NodeName);
      Node.AppendChild(Child);
    end;
    Node := Child;
  end;

  if StartPos > PathLen then
    exit;
  SetLength(NodeName, PathLen - StartPos + 1);
  Move(APath[StartPos], NodeName[1], Length(NodeName));
  NodeName := Escape(NodeName);
  if (not Assigned(TDOMElement(Node).GetAttributeNode(NodeName))) or
    (TDOMElement(Node)[NodeName] <> AValue) then
  begin
    TDOMElement(Node)[NodeName] := AValue;
    FModified := True;
  end;
end;

procedure TXMLConfig.SetDeleteValue(const APath, AValue, DefValue: String);
begin
  if AValue = DefValue then
    DeleteValue(APath)
  else
    SetValue(APath, AValue);
end;

procedure TXMLConfig.SetValue(const APath: String; AValue: Integer);
begin
  SetValue(APath, IntToStr(AValue));
end;

procedure TXMLConfig.SetDeleteValue(const APath: String; AValue,
  DefValue: Integer);
begin
  if AValue = DefValue then
    DeleteValue(APath)
  else
    SetValue(APath, AValue);
end;

procedure TXMLConfig.SetValue(const APath: String; AValue: Boolean);
begin
  if AValue then
    SetValue(APath, 'True')
  else
    SetValue(APath, 'False');
end;

procedure TXMLConfig.SetDeleteValue(const APath: String; AValue,
  DefValue: Boolean);
begin
  if AValue = DefValue then
    DeleteValue(APath)
  else
    SetValue(APath,AValue);
end;

procedure TXMLConfig.DeletePath(const APath: string);
var
  Node: TDomNode;
begin
  Node := FindNode(APath, False);
  if (Node = nil) or (Node.ParentNode = nil) then
    exit;
  Node.ParentNode.RemoveChild(Node);
  FModified := True;
end;

procedure TXMLConfig.DeleteValue(const APath: string);
var
  Node: TDomNode;
  StartPos: integer;
  NodeName: string;
begin
  Node := FindNode(APath, True);
  if not Assigned(Node) then
    exit;
  StartPos := Length(APath);
  while (StartPos > 0) and (APath[StartPos] <> '/') do
   Dec(StartPos);
  NodeName := Escape(Copy(APath, StartPos+1, Length(APath) - StartPos));
  if (not Assigned(TDOMElement(Node).GetAttributeNode(NodeName))) then
    exit;
  TDOMElement(Node).RemoveAttribute(NodeName);
  FModified := True;
end;

procedure TXMLConfig.Loaded;
begin
  inherited Loaded;
  if Length(Filename) > 0 then
    SetFilenameForce(Filename, true);              // Load the XML config file
end;

function TXMLConfig.FindNode(const APath: String;
  PathHasValue: boolean): TDomNode;
var
  NodePath: String;
  StartPos, EndPos: integer;
  PathLen: integer;
begin
  Result := Doc.DocumentElement;
  PathLen := Length(APath);
  StartPos := 1;
  while Assigned(Result) do
  begin
    EndPos := StartPos;
    while (EndPos <= PathLen) and (APath[EndPos] <> '/') do
      Inc(EndPos);
    if (EndPos > PathLen) and PathHasValue then
      exit;
    if EndPos = StartPos then
      break;
    SetLength(NodePath, EndPos - StartPos);
    Move(APath[StartPos], NodePath[1], Length(NodePath));
    Result := Result.FindNode(Escape(NodePath));
    StartPos := EndPos + 1;
    if StartPos > PathLen then
      exit;
  end;
  Result := nil;
end;

function TXMLConfig.Escape(const s: String): String;
const
  AllowedChars = ['A'..'Z', 'a'..'z', '0'..'9', '.', '-', '_'];
var
  EscapingNecessary: Boolean;
  i: Integer;
begin
  if Length(s) < 1 then
    raise EXMLConfigError.Create(SMissingPathName);

  if not (s[1] in ['A'..'Z', 'a'..'z', '_']) then
    EscapingNecessary := True
  else
  begin
    EscapingNecessary := False;
    for i := 2 to Length(s) do
      if not (s[i] in AllowedChars) then
      begin
        EscapingNecessary := True;
        break;
      end;
  end;

  if EscapingNecessary then
    if UseEscaping then
    begin
      Result := '_';
      for i := 1 to Length(s) do
        if s[i] in (AllowedChars - ['_']) then
	  Result := Result + s[i]
	else
	  Result := Result + '_' + IntToHex(Ord(s[i]), 2);
    end else
      raise EXMLConfigError.Create(SEscapingNecessary)
  else	// No escaping necessary
    Result := s;
end;

procedure TXMLConfig.SetFilenameForce(const AFilename: String; ForceReload: Boolean);
begin
  {$IFDEF MEM_CHECK}CheckHeapWrtMemCnt('TXMLConfig.SetFilename A '+AFilename);{$ENDIF}
  if (not ForceReload) and (FFilename = AFilename) then
    exit;
  Flush;
  FreeAndNil(Doc);

  FFilename := AFilename;

  if csLoading in ComponentState then
    exit;

  if FileExists(AFilename) and (not FStartEmpty) then
    ReadXMLFile(Doc, AFilename);

  if not Assigned(Doc) then
    Doc := TXMLDocument.Create;

  if not Assigned(Doc.DocumentElement) then
    Doc.AppendChild(Doc.CreateElement(RootName))
  else
    if Doc.DocumentElement.NodeName <> RootName then
      raise EXMLConfigError.Create('XML file has wrong root element name');

  {$IFDEF MEM_CHECK}CheckHeapWrtMemCnt('TXMLConfig.SetFilename END');{$ENDIF}
end;

procedure TXMLConfig.SetFilename(const AFilename: String);
begin
  SetFilenameForce(AFilename, False);
end;

procedure TXMLConfig.SetRootName(const AValue: DOMString);
var
  Cfg: TDOMElement;
begin
  if AValue <> RootName then
  begin
    FRootName := AValue;
    Cfg := Doc.CreateElement(AValue);
    while Assigned(Doc.DocumentElement.FirstChild) do
      Cfg.AppendChild(Doc.DocumentElement.FirstChild);
    Doc.ReplaceChild(Cfg, Doc.DocumentElement);
    FModified := True;
  end;
end;

procedure TXMLConfig.SetStartEmpty(AValue: Boolean);
begin
  if AValue <> StartEmpty then
  begin
    FStartEmpty := AValue;
    if (not AValue) and not Modified then
      SetFilenameForce(Filename, True);
  end;
end;

end.
