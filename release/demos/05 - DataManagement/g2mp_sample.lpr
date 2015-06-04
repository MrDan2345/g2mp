program g2mp_sample;

{$mode objfpc}{$H+}

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2DataManager;

var
  Font: TG2Font;
  TexBackground: TG2Texture2D;
  Text: AnsiString;

procedure Initialize;
  var dm: TG2DataManager;
begin
  g2.Window.Caption := 'DataManagement';
  //link a gen2 data pack
  g2.PackLinker.LinkPack('data.g2pk');
  //load the texture from the data pack
  //the following directory structure must be used with the packs:
  //gen2_data_pack_name\folder_name\file_name.file_extension
  TexBackground := TG2Texture2D.Create;
  TexBackground.Load('data\textures\Background.png', tuUsage2D);
  //load the font from the data pack
  Font := TG2Font.Create;
  Font.Load('data\fonts\Font.g2f');
  //Load the text form DataManagement.txt
  dm := TG2DataManager.Create('Text.txt', dmAsset);
  try
    SetLength(Text, dm.Size);
    dm.ReadBuffer(@Text[1], dm.Size);
  finally
    dm.Free;
  end;
end;

procedure Finalize;
begin
  Font.Free;
end;

procedure Update;
begin

end;

procedure Render;
begin
  g2.PicRect(
    0, 0, g2.Params.Width, g2.Params.Height,
    0, 0, g2.Params.Width / TexBackground.Width, g2.Params.Height / TexBackground.Height,
    $ffffffff, TexBackground
  );
  Font.Print(
    (g2.Params.Width - Font.TextWidth(Text)) * 0.5,
    (g2.Params.Height - Font.TextHeight(Text)) * 0.5,
    Text
  );
end;

procedure KeyDown(const Key: Integer);
begin
  if Key = G2K_Escape then
  g2.Stop;
end;

{$R *.res}

begin
  g2.CallbackInitializeAdd(@Initialize);
  g2.CallbackFinalizeAdd(@Finalize);
  g2.CallbackUpdateAdd(@Update);
  g2.CallbackRenderAdd(@Render);
  g2.CallbackKeyDownAdd(@KeyDown);
  g2.Params.ScreenMode := smWindow;
  g2.Params.Width := 1024;
  g2.Params.Width := 768;
  g2.Start;
end.

