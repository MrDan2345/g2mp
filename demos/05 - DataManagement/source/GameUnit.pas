unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  Types,
  Classes;

type
  TGame = class
  protected
    Font: TG2Font;
    TexBackground: TG2Texture2D;
    Text: AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    procedure Finalize;
    procedure Update;
    procedure Render;
    procedure KeyDown(const Key: Integer);
    procedure KeyUp(const Key: Integer);
    procedure MouseDown(const Button, x, y: Integer);
    procedure MouseUp(const Button, x, y: Integer);
    procedure Scroll(const y: Integer);
    procedure Print(const c: AnsiChar);
  end;

var
  Game: TGame;

implementation

//TGame BEGIN
constructor TGame.Create;
begin
  g2.CallbackInitializeAdd(@Initialize);
  g2.CallbackFinalizeAdd(@Finalize);
  g2.CallbackUpdateAdd(@Update);
  g2.CallbackRenderAdd(@Render);
  g2.CallbackKeyDownAdd(@KeyDown);
  g2.CallbackKeyUpAdd(@KeyUp);
  g2.CallbackMouseDownAdd(@MouseDown);
  g2.CallbackMouseUpAdd(@MouseUp);
  g2.CallbackScrollAdd(@Scroll);
  g2.CallbackPrintAdd(@Print);
  g2.Params.MaxFPS := 100;
  g2.Params.Width := 1024;
  g2.Params.Height := 768;
  g2.Params.ScreenMode := smMaximized;
end;

destructor TGame.Destroy;
begin
  g2.CallbackInitializeRemove(@Initialize);
  g2.CallbackFinalizeRemove(@Finalize);
  g2.CallbackUpdateRemove(@Update);
  g2.CallbackRenderRemove(@Render);
  g2.CallbackKeyDownRemove(@KeyDown);
  g2.CallbackKeyUpRemove(@KeyUp);
  g2.CallbackMouseDownRemove(@MouseDown);
  g2.CallbackMouseUpRemove(@MouseUp);
  g2.CallbackScrollRemove(@Scroll);
  g2.CallbackPrintRemove(@Print);
  inherited Destroy;
end;

procedure TGame.Initialize;
  var dm: TG2DataManager;
begin
  g2.Window.Caption := 'DataManagement';
  //link a gen2 data pack
  g2.PackLinker.LinkPack('data.g2pk');
  //load the texture from the data pack
  //the following directory structure must be used with the packs:
  //gen2_data_pack_name\folder_name\file_name.file_extension
  TexBackground := TG2Texture2D.Create;
  //this texture is loaded from the pack that was linked earlier
  TexBackground.Load('data\textures\Background.png', tu2D);
  Font := TG2Font.Create;
  //load this font from the data pack
  Font.Load('data\fonts\Font.g2f');
  //Load the text form Text.txt
  dm := TG2DataManager.Create('Text.txt', dmAsset);
  try
    SetLength(Text, dm.Size);
    dm.ReadBuffer(@Text[1], dm.Size);
  finally
    dm.Free;
  end;
end;

procedure TGame.Finalize;
begin
  Font.Free;
  Free;
end;

procedure TGame.Update;
begin

end;

procedure TGame.Render;
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

procedure TGame.KeyDown(const Key: Integer);
begin
  if Key = G2K_Escape then g2.Stop;
end;

procedure TGame.KeyUp(const Key: Integer);
begin

end;

procedure TGame.MouseDown(const Button, x, y: Integer);
begin

end;

procedure TGame.MouseUp(const Button, x, y: Integer);
begin

end;

procedure TGame.Scroll(const y: Integer);
begin

end;

procedure TGame.Print(const c: AnsiChar);
begin

end;
//TGame END

end.
