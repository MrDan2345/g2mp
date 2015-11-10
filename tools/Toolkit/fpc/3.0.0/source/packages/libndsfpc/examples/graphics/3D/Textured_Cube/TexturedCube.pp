program TexturedCube;

{$L build/texture.bin.o}

{$mode objfpc}

uses
  ctypes, nds9;

//texture_bin.h is created automagicaly from the texture.bin placed in arm9/resources
//texture.bin is a raw 128x128 16 bit image.  I will release a tool for texture conversion
//later
{$include inc/texture.bin.inc}

var
  CubeVectors: array [0..23] of v16;
  CubeFaces: array [0..23] of u8;
  uv: array [0..3] of u32;
  normals: array [0..5] of u32;

procedure Initialize();
begin
//verticies for the cube
  CubeVectors[0] := floattov16(-0.5); CubeVectors[1] := floattov16(-0.5); CubeVectors[2] := floattov16(0.5);
  CubeVectors[3] := floattov16(0.5); CubeVectors[4] := floattov16(-0.5); CubeVectors[5] := floattov16(0.5);
  CubeVectors[6] := floattov16(0.5); CubeVectors[7] := floattov16(-0.5); CubeVectors[8] := floattov16(-0.5);
  CubeVectors[9] := floattov16(-0.5); CubeVectors[10] := floattov16(-0.5); CubeVectors[11] := floattov16(-0.5);
  CubeVectors[12] := floattov16(-0.5); CubeVectors[13] := floattov16(0.5); CubeVectors[14] := floattov16(0.5);
  CubeVectors[15] := floattov16(0.5); CubeVectors[16] := floattov16(0.5); CubeVectors[17] := floattov16(0.5);
  CubeVectors[18] := floattov16(0.5); CubeVectors[19] := floattov16(0.5); CubeVectors[20] := floattov16(-0.5);
  CubeVectors[21] := floattov16(-0.5); CubeVectors[22] := floattov16(0.5); CubeVectors[23] := floattov16(-0.5);

//polys
  CubeFaces[0] := 3; CubeFaces[1] := 2; CubeFaces[2] := 1; CubeFaces[3] := 0;
  CubeFaces[4] := 0; CubeFaces[5] := 1; CubeFaces[6] := 5; CubeFaces[7] := 4;
  CubeFaces[8] := 1; CubeFaces[9] := 2; CubeFaces[10] := 6; CubeFaces[11] := 5;
  CubeFaces[12] := 2; CubeFaces[13] := 3; CubeFaces[14] := 7; CubeFaces[15] := 6;
  CubeFaces[16] := 3; CubeFaces[17] := 0; CubeFaces[18] := 4; CubeFaces[19] := 7;
  CubeFaces[20] := 5; CubeFaces[21] := 6; CubeFaces[22] := 7; CubeFaces[23] := 4;

  //texture coordinates
  uv[0] := TEXTURE_PACK(inttot16(128), 0);
  uv[1] := TEXTURE_PACK(inttot16(128),inttot16(128));
  uv[2] := TEXTURE_PACK(0, inttot16(128));
  uv[3] := TEXTURE_PACK(0,0);

  normals[0] := NORMAL_PACK(0,floattov10(-0.97),0);
  normals[1] := NORMAL_PACK(0,0,floattov10(0.97));
  normals[2] := NORMAL_PACK(floattov10(0.97),0,0);
  normals[3] := NORMAL_PACK(0,0,floattov10(-0.97));
  normals[4] := NORMAL_PACK(floattov10(-0.97),0,0);
  normals[5] := NORMAL_PACK(0,floattov10(0.97),0);

end;

//draw a cube face at the specified color
procedure drawQuad(poly: integer);
var
  f1, f2, f3, f4: u32;
begin
  f1 := CubeFaces[poly * 4] ;
  f2 := CubeFaces[poly * 4 + 1] ;
  f3 := CubeFaces[poly * 4 + 2] ;
  f4 := CubeFaces[poly * 4 + 3] ;


  glNormal(normals[poly]);

  GFX_TEX_COORD^ := (uv[0]);
  glVertex3v16(CubeVectors[f1*3], CubeVectors[f1*3 + 1], CubeVectors[f1*3 +  2] );

  GFX_TEX_COORD^ := (uv[1]);
  glVertex3v16(CubeVectors[f2*3], CubeVectors[f2*3 + 1], CubeVectors[f2*3 + 2] );

  GFX_TEX_COORD^ := (uv[2]);
  glVertex3v16(CubeVectors[f3*3], CubeVectors[f3*3 + 1], CubeVectors[f3*3 + 2] );

  GFX_TEX_COORD^ := (uv[3]);
  glVertex3v16(CubeVectors[f4*3], CubeVectors[f4*3 + 1], CubeVectors[f4*3 + 2] );
end;

procedure DisplayEnableMotionBlur();
var
  dispcnt: cuint32;
begin
  dispcnt := REG_DISPCNT^;
  //set main display to display from VRAM
  dispcnt := dispcnt and ($00030000 xor $FFFFFFFF); 
  dispcnt := dispcnt or (2 shl 16); //choose to display screen from VRAM
  dispcnt := dispcnt and ($000C0000 xor $FFFFFFFF); 
  dispcnt := dispcnt or (1 shl 18); //choose to display screen from VRAM_B
  REG_DISPCNT^ := dispcnt;
end;
 
procedure DisplayEnableNormal();
var         
  dispcnt: cuint32;
begin
  dispcnt := REG_DISPCNT^;
  dispcnt := dispcnt and ($00030000 xor $FFFFFFFF); 
  dispcnt := dispcnt or (1 shl 16); //choose to display screen from normal layer composition
  REG_DISPCNT^ := dispcnt;
end;

var
  textureID: integer;
  i: integer;
  rotateX: cfloat = 0.0;
  rotateY: cfloat = 0.0;
  keys: cuint16;
  displayBlurred: boolean;

begin
  Initialize();
  //set mode 0, enable BG0 and set it to 3D
  videoSetMode(MODE_0_3D);

  // initialize gl
  glInit();

  //enable textures
  glEnable(GL_TEXTURE_2D);

  //this should work the same as the normal gl call
  glViewport(0,0,255,191);

  // enable antialiasing
  glEnable(GL_ANTIALIAS);

  // setup the rear plane
  glClearColor(0,0,0,31); // BG must be opaque for AA to work
  glClearPolyID(63); // BG must have a unique polygon ID for AA to work
  glClearDepth($7FFF);


  vramSetBankB(VRAM_B_LCD);
  REG_DISPCAPCNT^ := DCAP_MODE(DCAP_MODE_BLEND) //blend source A and source B
                      //or  DCAP_SRC_ADDR //this is not used since we are setting the display to render from VRAM
                      or    DCAP_SRC_B(DCAP_SRC_B_VRAM)
                      or    DCAP_SRC_A(DCAP_SRC_A_3DONLY)
                      or    DCAP_SIZE(DCAP_SIZE_256x192)
                      or    DCAP_OFFSET(0) //where to write the captured data within our chosen VRAM bank
                      or    DCAP_BANK(DCAP_BANK_VRAM_B)
                      or    DCAP_B(12) //blend mostly from B to make a very dramatic effect
                      or    DCAP_A(4) //and blend only a little bit from the new scene
                      ;
  //but, dramatic effects tend to leave some garbage on the screen since the precision of the math is low,
  //and we're not putting a lot of dampening on the effect.
  //a more realistic value might be 8 and 8, but perhaps in a more complex 3d scene the garbage isn't such a bad thing
  //since the scene is changing constantly
 
  DisplayEnableMotionBlur();
  displayBlurred := true;
 
 

  vramSetBankA(VRAM_A_TEXTURE);

  glGenTextures(1, @textureID);
  glBindTexture(0, textureID);
  glTexImage2D(0, 0, GL_RGB, TEXTURE_SIZE_128 , TEXTURE_SIZE_128, 0, TEXGEN_TEXCOORD, pcuint8(@texture_bin));


  //any floating point gl call is being converted to fixed prior to being implemented
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(70, 256.0 / 192.0, 0.1, 40);

  gluLookAt(  0.0, 0.0, 1.0,    //camera possition
              0.0, 0.0, 0.0,    //look at
              0.0, 1.0, 0.0);   //up

  while true do
  begin
    glLight(0, RGB15(31,31,31) , 0,         floattov10(-1.0),    0);
    glLight(1, RGB15(31,0,31),   0,         floattov10(1) - 1,       0);
    glLight(2, RGB15(0,31,0) ,   floattov10(-1.0), 0,          0);
    glLight(3, RGB15(0,0,31) ,   floattov10(1.0) - 1,  0,          0);

    glPushMatrix();

    //move it away from the camera
    glTranslatef32(0, 0, floattof32(-1));

    glRotateX(rotateX);
    glRotateY(rotateY);

    glMatrixMode(GL_TEXTURE);
    glLoadIdentity();

    glMatrixMode(GL_MODELVIEW);

    glMaterialf(GL_AMBIENT, RGB15(8,8,8));
    glMaterialf(GL_DIFFUSE, RGB15(16,16,16));
    glMaterialf(GL_SPECULAR, BIT(15) or RGB15(8,8,8));
    glMaterialf(GL_EMISSION, RGB15(5,5,5));

    //ds uses a table for shinyness..this generates a half-ass one
    glMaterialShinyness();

    //not a real gl function and will likely change
    glPolyFmt(POLY_ALPHA(31) or POLY_CULL_BACK or POLY_FORMAT_LIGHT0 or POLY_FORMAT_LIGHT1 or
                          POLY_FORMAT_LIGHT2 or POLY_FORMAT_LIGHT3 ) ;

    scanKeys();

    keys := keysHeld();

		if((keys and KEY_UP)) <> 0 then rotateX := rotateX +3;
		if((keys and KEY_DOWN)) <> 0 then rotateX := rotateX -3;
		if((keys and KEY_LEFT)) <> 0 then rotateY := rotateY +3;
		if((keys and KEY_RIGHT)) <> 0 then rotateY := rotateY -3;

    if (keysDown() and KEY_A) <> 0 then
    begin
      displayBlurred := not displayBlurred;
      if displayBlurred then
        DisplayEnableMotionBlur()
      else
        DisplayEnableNormal();
    end;

		glBindTexture(0, textureID);

		//draw the obj
		glBegin(GL_QUAD);
			for i := 0 to 5 do
				drawQuad(i);
		glEnd();

		glPopMatrix(1);

		glFlush(0);

		swiWaitForVBlank();
    
    //the display capture enable bit must be set again each frame if you want to continue capturing.
    REG_DISPCAPCNT^ := REG_DISPCAPCNT^ or DCAP_ENABLE;		
  end;
end.
