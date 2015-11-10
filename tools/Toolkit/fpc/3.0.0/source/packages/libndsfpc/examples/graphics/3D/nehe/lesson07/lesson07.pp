(****************************************
 * 		NDS NeHe Lesson 07    			*
 * 		Author: Ethos					*
 ****************************************)

program Lesson07;
{$L build/drunkenlogo.pcx.o}

{$mode objfpc}

uses
  ctypes, nds9;

{$include inc/drunkenlogo.pcx.inc}

var
  light: boolean;				// Lighting ON/OFF ( NEW )
  lp: boolean;					// L Pressed? ( NEW )

  xrot: cfloat;				// X Rotation
  yrot: cfloat;				// Y Rotation
  xspeed: cfloat;				// X Rotation Speed
  yspeed: cfloat;				// Y Rotation Speed
  z: cfloat = -5.0;			// Depth Into The Screen

  texture: array [0..2] of integer;			// Storage For 3 Textures (only going to use 1 on the DS for this demo)

const
  LightAmbient: array [0..3] of cfloat =		( 0.5, 0.5, 0.5, 1.0 );
  LightDiffuse: array [0..3] of cfloat =		( 1.0, 1.0, 1.0, 1.0 );
  LightPosition: array [0..3] of cfloat =	  ( 0.0, 0.0, 2.0, 1.0 );

  

function DrawGLScene(): boolean;											// Here's Where We Do All The Drawing
begin
	glLoadIdentity();									// Reset The View
	glTranslatef(0.0,0.0,z);

	glRotatef(xrot,1.0,0.0,0.0);
	glRotatef(yrot,0.0,1.0,0.0);

	glBindTexture(GL_TEXTURE_2D, texture[0]);  //no filters to swtich between

	glBegin(GL_QUADS);
		// Front Face
		glNormal3f( 0.0, 0.0, 1.0);
		glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, -1.0,  1.0);
		glTexCoord2f(1.0, 0.0); glVertex3f( 1.0, -1.0,  1.0);
		glTexCoord2f(1.0, 1.0); glVertex3f( 1.0,  1.0,  1.0);
		glTexCoord2f(0.0, 1.0); glVertex3f(-1.0,  1.0,  1.0);
		// Back Face
		glNormal3f( 0.0, 0.0,-1.0);
		glTexCoord2f(1.0, 0.0); glVertex3f(-1.0, -1.0, -1.0);
		glTexCoord2f(1.0, 1.0); glVertex3f(-1.0,  1.0, -1.0);
		glTexCoord2f(0.0, 1.0); glVertex3f( 1.0,  1.0, -1.0);
		glTexCoord2f(0.0, 0.0); glVertex3f( 1.0, -1.0, -1.0);
		// Top Face
		glNormal3f( 0.0, 1.0, 0.0);
		glTexCoord2f(0.0, 1.0); glVertex3f(-1.0,  1.0, -1.0);
		glTexCoord2f(0.0, 0.0); glVertex3f(-1.0,  1.0,  1.0);
		glTexCoord2f(1.0, 0.0); glVertex3f( 1.0,  1.0,  1.0);
		glTexCoord2f(1.0, 1.0); glVertex3f( 1.0,  1.0, -1.0);
		// Bottom Face
		glNormal3f( 0.0,-1.0, 0.0);
		glTexCoord2f(1.0, 1.0); glVertex3f(-1.0, -1.0, -1.0);
		glTexCoord2f(0.0, 1.0); glVertex3f( 1.0, -1.0, -1.0);
		glTexCoord2f(0.0, 0.0); glVertex3f( 1.0, -1.0,  1.0);
		glTexCoord2f(1.0, 0.0); glVertex3f(-1.0, -1.0,  1.0);
		// Right face
		glNormal3f( 1.0, 0.0, 0.0);
		glTexCoord2f(1.0, 0.0); glVertex3f( 1.0, -1.0, -1.0);
		glTexCoord2f(1.0, 1.0); glVertex3f( 1.0,  1.0, -1.0);
		glTexCoord2f(0.0, 1.0); glVertex3f( 1.0,  1.0,  1.0);
		glTexCoord2f(0.0, 0.0); glVertex3f( 1.0, -1.0,  1.0);
		// Left Face
		glNormal3f(-1.0, 0.0, 0.0);
		glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, -1.0, -1.0);
		glTexCoord2f(1.0, 0.0); glVertex3f(-1.0, -1.0,  1.0);
		glTexCoord2f(1.0, 1.0); glVertex3f(-1.0,  1.0,  1.0);
		glTexCoord2f(0.0, 1.0); glVertex3f(-1.0,  1.0, -1.0);
	glEnd();

	xrot:=xrot+xspeed;
	yrot:=yrot+yspeed;


	result := true;			
end;


function LoadGLTextures(): boolean;									// Load PCX files And Convert To Textures
var
	pcx: sImage;                //////////////(NEW) and different from nehe.
begin
	//load our texture
	loadPCX(pcuint8(drunkenlogo_pcx), @pcx);
	
	image8to16(@pcx);

	glGenTextures(1, @texture[0]);
	glBindTexture(0, texture[0]);
	glTexImage2D(0, 0, GL_RGB, TEXTURE_SIZE_128 , TEXTURE_SIZE_128, 0, TEXGEN_TEXCOORD, pcx.image.data8);

	imageDestroy(@pcx);

	result := true;
end;

begin
	// Setup the Main screen for 3D 
	videoSetMode(MODE_0_3D);
	vramSetBankA(VRAM_A_TEXTURE);                        //NEW  must set up some memory for textures

	// initialize the geometry engine
	glInit();
	
	// enable textures
	glEnable(GL_TEXTURE_2D);
	
	// enable antialiasing
	glEnable(GL_ANTIALIAS);
	
	// setup the rear plane
	glClearColor(0,0,0,31); // BG must be opaque for AA to work
	glClearPolyID(63); // BG must have a unique polygon ID for AA to work
	glClearDepth($7FFF);

	// Set our viewport to be the same size as the screen
	glViewPort(0,0,255,191);
	
	LoadGLTextures();
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(70, 256.0 / 192.0, 0.1, 100);
	
	//set up a directional light arguments are light number (0-3), light color, 
	//and an x,y,z vector that points in the direction of the light, the direction must be normalized
	glLight(0, RGB15(31,31,31) , 0, floattov10(-1.0), 0);
	
	//need to set up some material properties since DS does not have them set by default
	glMaterialf(GL_AMBIENT, RGB15(8,8,8));
	glMaterialf(GL_DIFFUSE, RGB15(8,8,8));
	glMaterialf(GL_SPECULAR, BIT(15) or RGB15(8,8,8));
	glMaterialf(GL_EMISSION, RGB15(16,16,16));
	
	//ds uses a table for shinyness..this generates a half-ass one
	glMaterialShinyness();
	
	// Set the current matrix to be the model matrix
	glMatrixMode(GL_MODELVIEW);
	
	while true do 
	begin
		//these little button functions are pretty handy
		scanKeys();

	
		if ((keysDown() and KEY_A)) <> 0 then
			light := not light;

		if (keysHeld() and KEY_R) <> 0 then
			z := z -0.02;
		if (keysHeld() and KEY_L) <> 0 then
			z := z+0.02;
		if (keysHeld() and KEY_LEFT) <> 0 then
			xspeed := xspeed-0.01;
		if (keysHeld() and KEY_RIGHT) <> 0 then
			xspeed := xspeed+0.01;
		if (keysHeld() and KEY_UP) <> 0 then
			yspeed := yspeed+0.01;
		if (keysHeld() and KEY_DOWN) <> 0 then
			yspeed := yspeed-0.01;
		
		
		glColor3f(1,1,1);
		
		if (not light) then
			//ds specific, several attributes can be set here including turning on our light	
			glPolyFmt(POLY_ALPHA(31) or POLY_CULL_BACK)
		else
			//ds specific, several attributes can be set here including turning on our light	
			glPolyFmt(POLY_ALPHA(31) or POLY_CULL_BACK  or POLY_FORMAT_LIGHT0);

		DrawGLScene();

		// flush to screen	
		glFlush(0);
		
		// wait for the screen to refresh
		swiWaitForVBlank();
	end;
		
end.
