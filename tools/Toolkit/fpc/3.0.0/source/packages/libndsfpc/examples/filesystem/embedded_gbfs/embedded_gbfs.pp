program embedded_gbfs;
{$mode objfpc}
{$L build/data.gbfs.o}
uses
  ctypes, nds9, gbfs;

var
  data_gbfs: GBFS_FILE; cvar; external;

const
  piover180: cfloat = 0.0174532925;

var
  heading: cfloat;
  xpos: cfloat;
  zpos: cfloat;
  yrot: cfloat;       // Y Rotation
  walkbias: cfloat = 0.0;
  walkbiasangle: cfloat = 0.0;
  lookupdown: cfloat = 0.0;

  texture: array [0..2] of integer;  // Storage For 3 Textures (only going to use 1 on the DS for this demo)

type
  tagVERTEX = record
    x, y, z: cfloat;
    u, v: cfloat;
  end;
  VERTEX = tagVERTEX;

  tagTRIANGLE = record
    vertex: array [0..2] of VERTEX;
  end;
  TRIANGLE = tagTRIANGLE;
  TTriangle = TRIANGLE;
  PTriangle = ^TRIANGLE;

  tagSECTOR = record
    numtriangles: integer;
    triangle:   PTRIANGLE;
  end;
  SECTOR = tagSECTOR;

var
  sector1: SECTOR;        // Our Model Goes Here:


function DrawGLScene(): boolean;
var
  x_m, y_m, z_m:  cfloat;
  u_m, v_m: cfloat;
  xtrans, ztrans, ytrans: cfloat;
  sceneroty: cfloat;
  numtriangles: integer;
  loop_m: integer;
begin
  // Reset The View
  xtrans := -xpos;
  ztrans := -zpos;
  ytrans := -walkbias - 0.25;
  sceneroty := 360.0 - yrot;

  glLoadIdentity();

  glRotatef(lookupdown,1.0,0,0);
  glRotatef(sceneroty,0,1.0,0);

  glTranslatef(xtrans, ytrans, ztrans);
  glBindTexture(GL_TEXTURE_2D, texture[0]);

  numtriangles := sector1.numtriangles;


  // Process Each Triangle
  for loop_m := 0 to numtriangles - 1 do
  begin
    glBegin(GL_TRIANGLES);
      glNormal3f( 0.0, 0.0, 1.0);
      x_m := sector1.triangle[loop_m].vertex[0].x;
      y_m := sector1.triangle[loop_m].vertex[0].y;
      z_m := sector1.triangle[loop_m].vertex[0].z;
      u_m := sector1.triangle[loop_m].vertex[0].u;
      v_m := sector1.triangle[loop_m].vertex[0].v;
      glTexCoord2f(u_m,v_m); glVertex3f(x_m,y_m,z_m);

      x_m := sector1.triangle[loop_m].vertex[1].x;
      y_m := sector1.triangle[loop_m].vertex[1].y;
      z_m := sector1.triangle[loop_m].vertex[1].z;
      u_m := sector1.triangle[loop_m].vertex[1].u;
      v_m := sector1.triangle[loop_m].vertex[1].v;
      glTexCoord2f(u_m,v_m); glVertex3f(x_m,y_m,z_m);

      x_m := sector1.triangle[loop_m].vertex[2].x;
      y_m := sector1.triangle[loop_m].vertex[2].y;
      z_m := sector1.triangle[loop_m].vertex[2].z;
      u_m := sector1.triangle[loop_m].vertex[2].u;
      v_m := sector1.triangle[loop_m].vertex[2].v;
      glTexCoord2f(u_m,v_m); glVertex3f(x_m,y_m,z_m);
    glEnd();
  end;
  DrawGLScene := true;                    // Everything Went OK
end;

function tsin(angle: cfloat): cfloat;
var
  s: cint32;
begin
  s := sinLerp(trunc((angle * DEGREES_IN_CIRCLE) / 360.0));

  tsin := f32tofloat(s);
end;

function tcos(angle: cfloat): cfloat;
var
  c: cint32;
begin
  c := cosLerp(trunc((angle * DEGREES_IN_CIRCLE) / 360.0));

  tcos := f32tofloat(c);
end;

var
 Myfile: pchar;


procedure myGetStr(buff: pchar; size: integer);
begin
  buff^ := Myfile^;
  inc(MyFile);

  while (buff^ <> #10) and (buff^ <> #13) do
  begin
    inc(buff);
    buff^ := Myfile^;
    inc(MyFile);
  end;

  buff[0] := #10;
  buff[1] := #0;
end;

procedure readstr(str: pchar);
begin
  repeat
    myGetStr(str, 255);
  until ((str[0] <> '/') and (str[0] <> #10));
end;

//---------------------------------------------------------------------------------
procedure SetupWorld();
var
  x, y, z, u, v: cfloat;
  numtriangles: integer;
  oneline: array [0..254] of char;
  loop, vert: integer;
begin
  Myfile := gbfs_get_obj(@data_gbfs, 'World.txt', nil);

  readstr(oneline);
  sscanf(oneline, 'NUMPOLYS %d'#10, @numtriangles);

  GetMem(sector1.triangle, numtriangles * sizeof(TRIANGLE));
  sector1.numtriangles := numtriangles;

  for loop := 0 to numtriangles - 1 do
  begin
    for vert := 0 to 2 do
    begin
      readstr(oneline);
      sscanf(oneline, '%f %f %f %f %f', @x, @y, @z, @u, @v);
      sector1.triangle[loop].vertex[vert].x := x;
      sector1.triangle[loop].vertex[vert].y := y;
      sector1.triangle[loop].vertex[vert].z := z;
      sector1.triangle[loop].vertex[vert].u := u;
      sector1.triangle[loop].vertex[vert].v := v;
    end;
  end;
end;

// Load PCX files And Convert To Textures
function LoadGLTextures(): boolean;
var
  pcx: sImage;
  pcx_file: pchar;
begin
  //load our texture
  pcx_file := gbfs_get_obj(@data_gbfs, 'Mud.pcx', nil);
  loadPCX(pcuint8(pcx_file), @pcx);

  image8to16(@pcx);

  glGenTextures(1, @texture[0]);
  glBindTexture(0, texture[0]);
  glTexImage2D(0, 0, GL_RGB, TEXTURE_SIZE_128 , TEXTURE_SIZE_128, 0, TEXGEN_TEXCOORD or GL_TEXTURE_WRAP_S or GL_TEXTURE_WRAP_T, pcx.image.data8);

  imageDestroy(@pcx);

  LoadGLTextures := true;
end;

begin
  // Setup the Main screen for 3D
  videoSetMode(MODE_0_3D);
  vramSetBankA(VRAM_A_TEXTURE);                        //NEW  must set up some memory for textures

  // Reset the screen and setup the view
  glInit();

  // Set our viewport to be the same size as the screen
  glViewport(0,0,255,191);



  // enable textures
  glEnable(GL_TEXTURE_2D);

  //setup the projection matrix
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(70, 256.0 / 192.0, 0.1, 100);

  //setup a light
  glLight(0, RGB15(31,31,31), 0, floattov10(-1.0), 0);

  //need to set up some material properties since DS does not have them set by default
  glMaterialf(GL_AMBIENT, RGB15(16,16,16));
  glMaterialf(GL_DIFFUSE, RGB15(16,16,16));
  glMaterialf(GL_SPECULAR, BIT(15) or RGB15(8,8,8));
  glMaterialf(GL_EMISSION, RGB15(16,16,16));

  //ds uses a table for shinyness..this generates a half-ass one
  glMaterialShinyness();

  //ds specific, several attributes can be set here
  glPolyFmt(POLY_ALPHA(31) or POLY_CULL_NONE or POLY_FORMAT_LIGHT0);

  // Set the current matrix to be the model matrix
  glMatrixMode(GL_MODELVIEW);

  // Specify the Clear Color and Depth
  glClearColor(0,0,0,31);
  glClearDepth($7FFF);

  // specify the color for vertices
  glColor3f(1,1,1);

  LoadGLTextures();
  SetupWorld();

  while true do
  begin
    //these little button functions are pretty handy
    scanKeys();

    if (keysHeld() and KEY_A) <> 0 then lookupdown := lookupdown - 1.0;

    if (keysHeld() and KEY_B) <> 0 then lookupdown := lookupdown + 1.0;

    if (keysHeld() and KEY_LEFT) <> 0 then
    begin
      heading := heading + 1.0;
      yrot := heading;
    end;

    if (keysHeld() and KEY_RIGHT) <> 0 then
    begin
      heading := heading - 1.0;
      yrot := heading;
    end;

    if (keysHeld() and KEY_DOWN) <> 0 then
    begin
      xpos := xpos + (tsin(heading)) * 0.05;
      zpos := zpos + (tcos(heading)) * 0.05;
      if (walkbiasangle >= 359.0) then
        walkbiasangle := 0.0
      else
        walkbiasangle:= walkbiasangle+10;

      walkbias := tsin(walkbiasangle) / 20.0;
    end;

    if (keysHeld() and KEY_UP) <> 0 then
    begin
      xpos := xpos - (tsin(heading)) * 0.05;
      zpos := zpos - (tcos(heading)) * 0.05;

      if (walkbiasangle <= 1.0) then
        walkbiasangle := 359.0
      else
        walkbiasangle := walkbiasangle- 10;

      walkbias := tsin(walkbiasangle) / 20.0;
    end;

    //Push our original Matrix onto the stack (save state)
    glPushMatrix();

    DrawGLScene();

    // Pop our Matrix from the stack (restore state)
    glPopMatrix(1);

    // flush to screen
    glFlush(0);

  end;

end.
