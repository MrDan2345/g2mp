program MeshBreakdown;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes,
  SysUtils,
  Gen2MP,
  G2Math,
  G2DataManager,
  G2MeshData,
  G2MeshG2M;

var
  dm: TG2DataManager;
  Tab: Integer;
  procedure WriteString(const Str: String);
    var TabStr: String;
    var i: Integer;
  begin
    TabStr := '';
    for i := 0 to Tab - 1 do
    TabStr := TabStr + '  ';
    dm.WriteStringARaw(TabStr + Str);
  end;
  procedure WriteStringLn(const Str: String);
  begin
    WriteString(Str + #$D#$A);
  end;
  function MatToStr(const m: TG2Mat): String;
    var i: Integer;
  begin
    Result := 'TG2Mat[';
    for i := 0 to 15 do
    begin
      Result := Result + FormatFloat('#0.00', m.Arr[i]);
      if i < 15 then Result := Result + ', ' else Result := Result + ']'
    end;
  end;
  function Vec3ToStr(const v: TG2Vec3): String;
    var i: Integer;
  begin
    Result := 'TG2Vec3[';
    for i := 0 to 2 do
    begin
      Result := Result + FormatFloat('#0.00', v.Arr[i]);
      if i < 2 then Result := Result + ', ' else Result := Result + ']'
    end;
  end;
  function Vec2ToStr(const v: TG2Vec2): String;
    var i: Integer;
  begin
    Result := 'TG2Vec2[';
    for i := 0 to 1 do
    begin
      Result := Result + FormatFloat('#0.00', v.Arr[i]);
      if i < 1 then Result := Result + ', ' else Result := Result + ']'
    end;
  end;

var
  ml: TG2MeshLoaderG2M;
  md: TG2MeshData;
  i, j, n, t: Integer;

begin
  ml := TG2MeshLoaderG2M.Create;
  dm := TG2DataManager.Create('test.g2m', dmRead);
  ml.Load(dm);
  ml.ExportMeshData(@md);
  dm.Free;
  dm := TG2DataManager.Create('Breakdown.txt', dmWrite);
  Tab := 0;
  WriteStringLn('<G2M Data>');

  Tab := 0;
  WriteStringLn('<Exported Data>');
  WriteStringLn('Node Count: ' + IntToStr(md.NodeCount));
  Inc(Tab);
  for i := 0 to md.NodeCount - 1 do
  begin
    WriteStringLn('Node[(' + IntToStr(i) + ')' + md.Nodes[i].Name + ']:');
    Inc(Tab);
    WriteStringLn('Owner: ' + IntToStr(md.Nodes[i].OwnerID));
    WriteStringLn('Transform: ' + MatToStr(md.Nodes[i].Transform));
    Dec(Tab);
  end;
  Dec(Tab);
  WriteStringLn('Geom Count: ' + IntToStr(md.GeomCount));
  Inc(Tab);
  for i := 0 to md.GeomCount - 1 do
  begin
    WriteStringLn('Geom[(' + IntToStr(i) + ')' + md.Nodes[md.Geoms[i].NodeID].Name + ']:');
    Inc(Tab);
    WriteStringLn('NodeID: ' + IntToStr(md.Geoms[i].NodeID));
    WriteStringLn('VCount: ' + IntToStr(md.Geoms[i].VCount));
    WriteStringLn('FCount: ' + IntToStr(md.Geoms[i].FCount));
    WriteStringLn('TCount: ' + IntToStr(md.Geoms[i].TCount));
    WriteStringLn('MCount: ' + IntToStr(md.Geoms[i].MCount));
    WriteStringLn('SkinID: ' + IntToStr(md.Geoms[i].SkinID));
    WriteStringLn('Faces:');
    Inc(Tab);
    for j := 0 to md.Geoms[i].FCount - 1 do
    begin
      WriteStringLn('Face[' + IntToStr(j) + ']:');
      Inc(Tab);
      for n := 0 to 2 do
      begin
        WriteStringLn('Vertex[' + IntToStr(md.Geoms[i].Faces[j][n]) + ']:');
        Inc(Tab);
        WriteStringLn('Position: ' + Vec3ToStr(md.Geoms[i].Vertices[md.Geoms[i].Faces[j][n]].Position));
        WriteStringLn('Normal: ' + Vec3ToStr(md.Geoms[i].Vertices[md.Geoms[i].Faces[j][n]].Normal));
        WriteStringLn('Binormal: ' + Vec3ToStr(md.Geoms[i].Vertices[md.Geoms[i].Faces[j][n]].Binormal));
        WriteStringLn('Tangent: ' + Vec3ToStr(md.Geoms[i].Vertices[md.Geoms[i].Faces[j][n]].Tangent));
        for t := 0 to md.Geoms[i].TCount - 1 do
        begin
          WriteStringLn('TexCoord[' + IntToStr(t) + ']: ' + Vec2ToStr(md.Geoms[i].Vertices[md.Geoms[i].Faces[j][n]].TexCoords[t]));
        end;
        Dec(Tab);
      end;
      Dec(Tab);
    end;
    Dec(Tab);
    Dec(Tab);
  end;
  Dec(Tab);
  WriteStringLn('Anim Count: ' + IntToStr(md.AnimCount));
  WriteStringLn('Skin Count: ' + IntToStr(md.SkinCount));
  WriteStringLn('Material Count: ' + IntToStr(md.MaterialCount));
  ml.Free;
  dm.Free;
end.

