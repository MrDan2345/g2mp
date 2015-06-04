program g2mp_sample;

{$mode objfpc}{$H+}

uses
  Gen2MP,
  G2Types,
  G2Math;

var
  Font: TG2Font;
  TexBackground: TG2Texture2D;
  TexAnimated: TG2Texture2D;

procedure Initialize;
begin
  g2.Window.Caption := 'Rendering';
  Font := TG2Font.Create;
  Font.Make(32);
  //thre are three types of texture usage in g2mp:
  //tuDefault - this texture usage will fit any purpose but will probably not be perfect for any.
  //if the dimensions of the image loaded are not a power of two, the texture will be created
  //with the nearest power of two dimensions and the image will be stretched across the entire texture.
  //tuUsage2D - this texture usage is designed for textures used in 2d graphics,
  //when the image is loaded, if its dimensions are not a power of 2, the texture will be created
  //with the nearest power of two dimensions, the image will then be embeded in the top left
  //corner of the texture. this will preserve the per pixel precision of the original image.
  //no mipmaps are generated for this type of texture. this texture usage is the fastest to
  //load as it does not require resampling of the image.
  //tuUsage3D - this texture usage is designed for textures used in 3d graphics,
  //it is the same as tuDefault except the mip maps will be generated for this type of texture.
  TexBackground := TG2Texture2D.Create;
  TexBackground.Load('Background.png', tuUsage2D);
  TexAnimated := TG2Texture2D.Create;
  TexAnimated.Load('Animated.png', tuUsage2D)
end;

procedure Finalize;
begin
  Font.Free;
end;

procedure Update;
begin

end;

procedure Render;
  var x, y: Single;
begin
  //render the background
  g2.PicRect(
    //x, y, width, height
    0, 0, g2.Params.Width, g2.Params.Height,
    //texture coordinates of the top left and the bottom right points of the sprite
    0, 0, g2.Params.Width /  TexBackground.Width, g2.Params.Height / TexBackground.Height,
    //ARGB color
    $ffffffff,
    //texture
    TexBackground,
    //blend mode (optional)
    bmNormal,
    //texture filtering (optional)
    tfLinear
  );

  //primitives
  g2.PrimRectCol(0, 0, g2.Params.Width, g2.Params.Height * 0.5, $eeeeeeee, $eecccccc, $ee888888, $ee666666);
  g2.PrimLine(10, 10, 100, 300, $ff0000ff);
  g2.PrimLineCol(30, 10, 120, 300, $ff0000ff, $ffff0000);
  g2.PrimCircleCol(350, 160, 150, $ff00ff00, $000000ff, 32);

  //animated sprites
  x := g2.Params.Width * 0.25;
  y := g2.Params.Height * 0.75;
  g2.PicRect(
    x * 0.5, y, 250, 250, //x, y, width, height
    $ffffffff, //ARGB color
    0.5, 0.5, //center of the sprite image
    1, 1, //scalex and scaley
    0, //ritation in radians
    False, False, //flip the image horizontally and vertically
    TexAnimated, //texture
    128, 128, //size in pixels of a single frame
    0, //the index of the frame
    bmNormal, //blend mode
    tfLinear //texture filtering
  );
  g2.PicRect(
    x * 1.5, y, 250, 250,
    $ffffffff,
    0.5, 0.5,
    1, 1,
    0,
    False, False,
    TexAnimated,
    128, 128,
    Trunc(G2TimeInterval(1200) * 20) mod 20 + 1,
    bmNormal,
    tfLinear
  );
  //the difference between a stndard draw function and an equivalent with a
  //Col suffix is that the latter specifies the color of each vertex of the
  //sprite/primitive. for most polygons the order in which the vertices are
  //defined is clockwise, the exceptions are the rectangles and quadrangles,
  //the vertex order in these primitives if defined as follows:
  //top left, top right, bottom left, bottom right
  g2.PicRectCol(
    x * 2.5, y, 250, 250,
    $ffffff00, $ffff00ff,
    $ff00ffff, $ff00ff00,
    0.5, 0.5,
    1, 1,
    0,
    False, False,
    TexAnimated,
    128, 128,
    Trunc(G2TimeInterval(1200) * 20) mod 20 + 1,
    bmNormal,
    tfLinear
  );
  g2.PicRect(
    x * 3.5, y, 250, 250,
    $ffffffff,
    0.5, 0.5,
    1, 1,
    G2PiTime,
    True, False,
    TexAnimated,
    128, 128,
    Trunc(G2TimeInterval(1200) * 20) mod 20 + 1,
    bmAdd,
    tfLinear
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
  g2.Params.Height := 768;
  g2.Start;
end.

