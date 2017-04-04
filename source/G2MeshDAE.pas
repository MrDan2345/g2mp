unit G2MeshDAE;

interface

uses
  SysUtils,
  G2Types,
  G2Utils,
  G2Math,
  G2MeshData,
  G2DataManager;

type
  TG2MeshLoaderDAE = class (TG2MeshLoader)
  public
    class function CanLoad(const DataManager: TG2DataManager): Boolean; override;
    procedure Load(const DataManager: TG2DataManager); override;
    procedure ExportMeshData(const MeshData: PG2MeshData); override;
  end;

implementation

class function TG2MeshLoaderDAE.CanLoad(const DataManager: TG2DataManager): Boolean;
  var xml: array[0..255] of AnsiChar;
  var p, i: TG2IntS32;
begin
  p := DataManager.Position;
  DataManager.ReadBuffer(@xml[0], G2Min(DataManager.Size, (Length(xml) - 1) * SizeOf(AnsiChar)));
  DataManager.Position := p;
  xml[255] := #0;
  i := Pos('<COLLADA', xml);
  if i = 0 then i := Pos('<collada', xml);
  Result := i > 0;
end;

procedure TG2MeshLoaderDAE.Load(const DataManager: TG2DataManager);
  var xml, xn, xscene: TG2XMLNode;
  var xml_data: AnsiString;
begin
  SetLength(xml_data, DataManager.Size - DataManager.Position);
  DataManager.ReadBuffer(@xml_data[1], DataManager.Size - DataManager.Position);
  xml := TG2XMLNode.Create;
  xml.XML := xml_data;
  xn := xml.FindNodeByName('collada');
  if Assigned(xn) then
  begin
    xscene := xn.FindChildByName('library_visual_scenes');
    if Assigned(xscene) then
    begin

    end;
  end;
  xml.Free;
end;

procedure TG2MeshLoaderDAE.ExportMeshData(const MeshData: PG2MeshData);
begin

end;

initialization
begin
  G2AddMeshLoader(TG2MeshLoaderDAE);
end;

end.
