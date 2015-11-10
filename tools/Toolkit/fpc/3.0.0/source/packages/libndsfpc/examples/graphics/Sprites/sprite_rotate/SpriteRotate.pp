program SpriteRotate;

{$mode objfpc}

uses
  ctypes, nds9;

var
  i: integer;
	angle: integer = 0;
	gfx: pcuint16;
begin
	videoSetMode(MODE_0_2D);

	vramSetBankA(VRAM_A_MAIN_SPRITE);

	oamInit(oamMain, SpriteMapping_1D_32, false);

	gfx := oamAllocateGfx(oamMain, SpriteSize_32x32, SpriteColorFormat_256Color);

	for i := 0 to (32 * 32 div 2) -1 do
		gfx[i] := 1 or (1 shl 8);

	SPRITE_PALETTE[1] := RGB15(31,0,0);

	while true do
	begin
		scanKeys();

		if (keysHeld() and KEY_LEFT) <> 0 then
			angle := angle + degreesToAngle(2);
		if (keysHeld() and KEY_RIGHT) <> 0 then
			angle := angle - degreesToAngle(2);

		//-------------------------------------------------------------------------
		// Set the first rotation/scale matrix
		//
		// There are 32 rotation/scale matricies that can store sprite rotations
		// Any number of sprites can share a sprite rotation matrix or each sprite
		// (up to 32) can utilize a seperate rotation. Because this sprite is doubled
		// in size we have to adjust its position by subtracting half of its height and
		// width (20 - 16, 20 - 16, )
		//-------------------------------------------------------------------------
		oamRotateScale(oamMain, 0, angle, intToFixed(1, 8), intToFixed(1, 8));

		oamSet(oamMain, //main graphics engine context
			0,           //oam index (0 to 127)
			20 - 16, 20 - 16,   //x and y pixle location of the sprite
			0,                    //priority, lower renders last (on top)
			0,					  //this is the palette index if multiple palettes or the alpha value if bmp sprite
			SpriteSize_32x32,
			SpriteColorFormat_256Color,
			gfx,                  //pointer to the loaded graphics
			0,                  //sprite rotation/scale matrix index
			true,               //double the size when rotating?
			false,			//hide the sprite?
			false, false, //vflip, hflip
			false	//apply mosaic
			);

		//-------------------------------------------------------------------------
		// Because the sprite below has size double set to false it can never be larger than
		// 32x32 causing it to clip as it rotates.
		//-------------------------------------------------------------------------
		oamSet(oamMain, //main graphics engine context
			1,           //oam index (0 to 127)
			204, 20,   //x and y pixle location of the sprite
			0,                    //priority, lower renders last (on top)
			0,					  //this is the palette index if multiple palettes or the alpha value if bmp sprite
			SpriteSize_32x32,
			SpriteColorFormat_256Color,
			gfx,                  //pointer to the loaded graphics
			0,                  //sprite rotation/scale matrix index
			false,               //double the size when rotating?
			false,			//hide the sprite?
			false, false, //vflip, hflip
			false	//apply mosaic
			);
		swiWaitForVBlank();


		oamUpdate(oamMain);
	end;
end.