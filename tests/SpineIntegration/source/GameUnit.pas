unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  Types,
  Classes,
  Spine;

type
  TG2SpineTexture = class (TSpineTexture)
  public
    Texture: TG2Texture2D;
    constructor Create(const TextureName: AnsiString);
    destructor Destroy; override;
    function GetWidth: Integer; override;
    function GetHeight: Integer; override;
  end;

  TG2SpineTextureLoader = class (TSpineTextureLoader)
  public
    function LoadTexture(const TextureName: AnsiString): TSpineTexture; override;
  end;

  TG2SpineRender = class (TSpineRender)
  public
    procedure Render(const Texture: TSpineTexture; const Vertices: PSpineVertexArray); override;
  end;

  TGame = class
  protected
    TextureAtlas: TSpineTextureAtlas;
    Skeleton: TSpineSkeleton;
    Animation: TSpineAnimation;
    SpineRender: TG2SpineRender;
    Time: Single;
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

//TG2SpineTexture BEGIN
constructor TG2SpineTexture.Create(const TextureName: AnsiString);
begin
  inherited Create;
  Texture := TG2Texture2D.SharedAsset(TextureName);
  Texture.RefInc;
end;

destructor TG2SpineTexture.Destroy;
begin
  Texture.RefDec;
  inherited Destroy;
end;

function TG2SpineTexture.GetWidth: Integer;
begin
  Result := Texture.RealWidth;
end;

function TG2SpineTexture.GetHeight: Integer;
begin
  Result := Texture.RealHeight;
end;
//TG2SpineTexture END

//TG2SpineTextureLoader BEGIN
function TG2SpineTextureLoader.LoadTexture(const TextureName: AnsiString): TSpineTexture;
begin
  Result := TG2SpineTexture.Create(TextureName);
end;
//TG2SpineTextureLoader END

//TG2SpineRender BEGIN
procedure TG2SpineRender.Render(const Texture: TSpineTexture; const Vertices: PSpineVertexArray);
  var pv: PSpineVertexArray absolute Vertices;
begin
  g2.PicQuadCol(
    pv^[0].x, pv^[0].y, pv^[1].x, pv^[1].y,
    pv^[3].x, pv^[3].y, pv^[2].x, pv^[2].y,
    pv^[0].u, pv^[0].v, pv^[1].u, pv^[1].v,
    pv^[3].u, pv^[3].v, pv^[2].u, pv^[2].v,
    G2Color(Round(pv^[0].r * $ff), Round(pv^[0].g * $ff), Round(pv^[0].b * $ff), Round(pv^[0].a * $ff)),
    G2Color(Round(pv^[1].r * $ff), Round(pv^[1].g * $ff), Round(pv^[1].b * $ff), Round(pv^[1].a * $ff)),
    G2Color(Round(pv^[3].r * $ff), Round(pv^[3].g * $ff), Round(pv^[3].b * $ff), Round(pv^[3].a * $ff)),
    G2Color(Round(pv^[2].r * $ff), Round(pv^[2].g * $ff), Round(pv^[2].b * $ff), Round(pv^[2].a * $ff)),
    TG2SpineTexture(Texture).Texture, bmNormal, tfLinear
  );
end;
//TG2SpineRender END

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
  var tl: TG2SpineTextureLoader;
  var sb: TSpineSkeletonBinary;
  var sd: TSpineSkeletonData;
  var b: TSpineBone;
  const CharacterName = 'spineboy';
begin
  tl := TG2SpineTextureLoader.Create;
  TextureAtlas := TSpineTextureAtlas.Create('../assets/' + CharacterName + '.atlas', tl);
  tl.Free;

  sb := TSpineSkeletonBinary.Create(TextureAtlas);
  sd := sb.ReadSkeletonData('../assets/' + CharacterName + '.skel');
  sb.Free;
  Skeleton := TSpineSkeleton.Create(sd);
  Animation := sd.FindAnimation('walk');
  sd.Free;
  Skeleton.SetSkin('spineboy');
  Skeleton.SetToBindPose;

  b := Skeleton.GetRootBone;
  b.x := g2.Params.Width * 0.5;
  b.y := 500;
  b.ScaleX := 1;
  b.ScaleY := 1;
  Skeleton.UpdateWorldTransform;

  SpineRender := TG2SpineRender.Create;
  Time := 0;
end;

procedure TGame.Finalize;
begin
  SpineRender.Free;
  TextureAtlas.Free;
end;

procedure TGame.Update;
begin
  Time := Time + g2.DeltaTimeMs;
  Animation.Apply(Skeleton, Time, True);
  Skeleton.UpdateWorldTransform;
  Skeleton.Time := Time;
end;

procedure TGame.Render;
begin
  g2.PicRect(
    0, 0,
    TG2SpineTexture(TSpineAtlasPage(TextureAtlas.Pages[0]).Texture).Texture.Width,
    TG2SpineTexture(TSpineAtlasPage(TextureAtlas.Pages[0]).Texture).Texture.Height,
    $ffffffff, TG2SpineTexture(TSpineAtlasPage(TextureAtlas.Pages[0]).Texture).Texture
  );
  Skeleton.Draw(SpineRender);
end;

procedure TGame.KeyDown(const Key: Integer);
begin

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
