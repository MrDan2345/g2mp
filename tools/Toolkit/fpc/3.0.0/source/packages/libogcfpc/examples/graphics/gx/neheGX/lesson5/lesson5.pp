program lesson5;

{$J+}
{$macro on}
{$mode objfpc}

uses
  cmem, ctypes, gctypes, gccore;
 
const
  DEFAULT_FIFO_SIZE = (256 * 1024);
 
var
  frameBuffer: array [0..1] of pcuint32 = (nil, nil);
  rmode: PGXRModeObj = nil;

  yscale: f32;
  xfbHeight: cuint32;
  fb: cuint32 = 0;

  view: Mtx;
  perspective: Mtx44;
  model, modelview: Mtx;

  rtri: cfloat = 0.0;
  rquad: cfloat = 0.0;

  background: GXColor = (r:0; g:0; b:0; a:$ff;);
  gp_fifo: pointer = nil;

  cam: guVector   = (x: 0.0; y: 0.0; z: 0.0;);
  up: guVector    = (x: 0.0; y: 1.0; z: 0.0;);
  look: guVector  = (x: 0.0; y: 0.0; z:-1.0;);

  triAxis: guVector = (x: 0; y: 1; z: 0;);
	cubeAxis: guVector = (x: 1; y: 1; z: 1;);
  w, h: f32;

begin
	// init the vi.
	VIDEO_Init();
	WPAD_Init();
 
	rmode := VIDEO_GetPreferredMode(nil);
	
	// allocate 2 framebuffers for double buffering
//	frameBuffer[0] := MEM_K0_TO_K1(integer(SYS_AllocateFramebuffer(rmode)));
//	frameBuffer[1] := MEM_K0_TO_K1(integer(SYS_AllocateFramebuffer(rmode)));
	frameBuffer[0] := SYS_AllocateFramebuffer(rmode);
	frameBuffer[1] := SYS_AllocateFramebuffer(rmode);


	VIDEO_Configure(rmode);
	VIDEO_SetNextFramebuffer(frameBuffer[fb]);
	VIDEO_SetBlack(FALSE);
	VIDEO_Flush();
	VIDEO_WaitVSync();
	if (rmode^.viTVMode and VI_NON_INTERLACE) <> 0 then
    VIDEO_WaitVSync();

	// setup the fifo and then init the flipper
	gp_fifo := memalign(32,DEFAULT_FIFO_SIZE);
	memset(gp_fifo,0,DEFAULT_FIFO_SIZE);
 
	GX_Init(gp_fifo,DEFAULT_FIFO_SIZE);
 
	// clears the bg to color and clears the z buffer
	GX_SetCopyClear(background, $00ffffff);
 
	// other gx setup
	GX_SetViewport(0,0,rmode^.fbWidth,rmode^.efbHeight,0,1);
	yscale := GX_GetYScaleFactor(rmode^.efbHeight,rmode^.xfbHeight);
	xfbHeight := GX_SetDispCopyYScale(yscale);
	GX_SetScissor(0,0,rmode^.fbWidth,rmode^.efbHeight);
	GX_SetDispCopySrc(0,0,rmode^.fbWidth,rmode^.efbHeight);
	GX_SetDispCopyDst(rmode^.fbWidth,xfbHeight);
	GX_SetCopyFilter(rmode^.aa,rmode^.sample_pattern,GX_TRUE,rmode^.vfilter);
	
  if rmode^.viHeight = 2*rmode^.xfbHeight then
    GX_SetFieldMode(rmode^.field_rendering, GX_ENABLE)
  else
    GX_SetFieldMode(rmode^.field_rendering, GX_DISABLE);
 
	GX_SetCullMode(GX_CULL_NONE);
	GX_CopyDisp(frameBuffer[fb],GX_TRUE);
	GX_SetDispCopyGamma(GX_GM_1_0);
 

	// setup the vertex descriptor
	// tells the flipper to expect direct data
	GX_ClearVtxDesc();
	GX_SetVtxDesc(GX_VA_POS, GX_DIRECT);
 	GX_SetVtxDesc(GX_VA_CLR0, GX_DIRECT);
 
	// setup the vertex attribute table
	// describes the data
	// args: vat location 0-7, type of data, data format, size, scale
	// so for ex. in the first call we are sending position data with
	// 3 values X,Y,Z of size F32. scale sets the number of fractional
	// bits for non float data.
	GX_SetVtxAttrFmt(GX_VTXFMT0, GX_VA_POS, GX_POS_XYZ, GX_F32, 0);
	GX_SetVtxAttrFmt(GX_VTXFMT0, GX_VA_CLR0, GX_CLR_RGBA, GX_RGB8, 0);
 
	GX_SetNumChans(1);
	GX_SetNumTexGens(0);
	GX_SetTevOrder(GX_TEVSTAGE0, GX_TEXCOORDNULL, GX_TEXMAP_NULL, GX_COLOR0A0);
	GX_SetTevOp(GX_TEVSTAGE0, GX_PASSCLR);

	// setup our camera at the origin
	// looking down the -z axis with y up
	guLookAt(view, @cam, @up, @look);
 

	// setup our projection matrix
	// this creates a perspective matrix with a view angle of 90,
	// and aspect ratio based on the display resolution
  w := rmode^.viWidth;
  h := rmode^.viHeight;
	guPerspective(perspective, 45, f32(w/h), 0.1, 300.0);
	GX_LoadProjectionMtx(perspective, GX_PERSPECTIVE);


	while true do
	begin
		WPAD_ScanPads();

		if (WPAD_ButtonsDown(0) and WPAD_BUTTON_HOME) <> 0 then 
      exit;

		// do this before drawing
		GX_SetViewport(0,0,rmode^.fbWidth,rmode^.efbHeight,0,1);

		guMtxIdentity(model);
		guMtxRotAxisDeg(model, @triAxis, rtri);
		guMtxTransApply(model, model, -1.5,0.0,-6.0);
		guMtxConcat(view,model,modelview);
		// load the modelview matrix into matrix memory
		GX_LoadPosMtxImm(modelview, GX_PNMTX0);

		GX_Begin(GX_TRIANGLES, GX_VTXFMT0, 12);		// Draw A Pyramid

			GX_Position3f32( 0.0, 1.0, 0.0);		// Top of Triangle (front)
			GX_Color3f32(1.0,0.0,0.0);			// Set The Color To Red
			GX_Position3f32(-1.0,-1.0, 1.0);	// Left of Triangle (front)
			GX_Color3f32(0.0,1.0,0.0);			// Set The Color To Green
			GX_Position3f32( 1.0,-1.0, 1.0);	// Right of Triangle (front)
			GX_Color3f32(0.0,0.0,1.0);			// Set The Color To Blue

			GX_Position3f32( 0.0, 1.0, 0.0);		// Top of Triangle (Right)
			GX_Color3f32(1.0,0.0,0.0);			// Set The Color To Red
			GX_Position3f32( 1.0,-1.0, 1.0);	// Left of Triangle (Right)
			GX_Color3f32(0.0,0.0,1.0);			// Set The Color To Blue
			GX_Position3f32( 1.0,-1.0,-1.0);	// Right of Triangle (Right)
			GX_Color3f32(0.0,1.0,0.0);			// Set The Color To Green

			GX_Position3f32( 0.0, 1.0, 0.0);		// Top of Triangle (Back)
			GX_Color3f32(1.0,0.0,0.0);			// Set The Color To Red
			GX_Position3f32(-1.0,-1.0,-1.0);	// Left of Triangle (Back)
			GX_Color3f32(0.0,0.0,1.0);			// Set The Color To Blue
			GX_Position3f32( 1.0,-1.0,-1.0);	// Right of Triangle (Back)
			GX_Color3f32(0.0,1.0,0.0);			// Set The Color To Green
                               
			GX_Position3f32( 0.0, 1.0, 0.0);		// Top of Triangle (Left)
			GX_Color3f32(1.0,0.0,0.0);			// Set The Color To Red
			GX_Position3f32(-1.0,-1.0,-1.0);	// Left of Triangle (Left)
			GX_Color3f32(0.0,0.0,1.0);			// Set The Color To Blue
			GX_Position3f32(-1.0,-1.0, 1.0);	// Right of Triangle (Left)
			GX_Color3f32(0.0,1.0,0.0);			// Set The Color To Green

		GX_End();

		guMtxIdentity(model);
		guMtxRotAxisDeg(model, @cubeAxis, rquad);
		guMtxTransApply(model, model, 1.5,0.0,-7.0);
		guMtxConcat(view,model,modelview);
		// load the modelview matrix into matrix memory
		GX_LoadPosMtxImm(modelview, GX_PNMTX0);
		
		GX_Begin(GX_QUADS, GX_VTXFMT0, 24);			// Draw a Cube

			GX_Position3f32( 1.0, 1.0,-1.0);	// Top Left of the quad (top)
			GX_Color3f32(0.0,1.0,0.0);			// Set The Color To Green
			GX_Position3f32(-1.0, 1.0,-1.0);	// Top Right of the quad (top)
			GX_Color3f32(0.0,1.0,0.0);			// Set The Color To Green
			GX_Position3f32(-1.0, 1.0, 1.0);	// Bottom Right of the quad (top)
			GX_Color3f32(0.0,1.0,0.0);			// Set The Color To Green
			GX_Position3f32( 1.0, 1.0, 1.0);		// Bottom Left of the quad (top)
			GX_Color3f32(0.0,1.0,0.0);			// Set The Color To Green

			GX_Position3f32( 1.0,-1.0, 1.0);	// Top Left of the quad (bottom)
			GX_Color3f32(1.0,0.5,0.0);			// Set The Color To Orange
			GX_Position3f32(-1.0,-1.0, 1.0);	// Top Right of the quad (bottom)
			GX_Color3f32(1.0,0.5,0.0);			// Set The Color To Orange
			GX_Position3f32(-1.0,-1.0,-1.0);	// Bottom Right of the quad (bottom)
			GX_Color3f32(1.0,0.5,0.0);			// Set The Color To Orange
			GX_Position3f32( 1.0,-1.0,-1.0);	// Bottom Left of the quad (bottom)
			GX_Color3f32(1.0,0.5,0.0);			// Set The Color To Orange

			GX_Position3f32( 1.0, 1.0, 1.0);		// Top Right Of The Quad (Front)
			GX_Color3f32(1.0,0.0,0.0);			// Set The Color To Red
			GX_Position3f32(-1.0, 1.0, 1.0);	// Top Left Of The Quad (Front)
			GX_Color3f32(1.0,0.0,0.0);			// Set The Color To Red
			GX_Position3f32(-1.0,-1.0, 1.0);	// Bottom Left Of The Quad (Front)
			GX_Color3f32(1.0,0.0,0.0);			// Set The Color To Red
			GX_Position3f32( 1.0,-1.0, 1.0);	// Bottom Right Of The Quad (Front)
			GX_Color3f32(1.0,0.0,0.0);			// Set The Color To Red

			GX_Position3f32( 1.0,-1.0,-1.0);	// Bottom Left Of The Quad (Back)
			GX_Color3f32(1.0,1.0,0.0);			// Set The Color To Yellow
			GX_Position3f32(-1.0,-1.0,-1.0);	// Bottom Right Of The Quad (Back)
			GX_Color3f32(1.0,1.0,0.0);			// Set The Color To Yellow
			GX_Position3f32(-1.0, 1.0,-1.0);	// Top Right Of The Quad (Back)
			GX_Color3f32(1.0,1.0,0.0);			// Set The Color To Yellow
			GX_Position3f32( 1.0, 1.0,-1.0);	// Top Left Of The Quad (Back)
			GX_Color3f32(1.0,1.0,0.0);			// Set The Color To Yellow

			GX_Position3f32(-1.0, 1.0, 1.0);	// Top Right Of The Quad (Left)
			GX_Color3f32(0.0,0.0,1.0);			// Set The Color To Blue
			GX_Position3f32(-1.0, 1.0,-1.0);	// Top Left Of The Quad (Left)
			GX_Color3f32(0.0,0.0,1.0);			// Set The Color To Blue
			GX_Position3f32(-1.0,-1.0,-1.0);	// Bottom Left Of The Quad (Left)
			GX_Color3f32(0.0,0.0,1.0);			// Set The Color To Blue
			GX_Position3f32(-1.0,-1.0, 1.0);	// Bottom Right Of The Quad (Left)
			GX_Color3f32(0.0,0.0,1.0);			// Set The Color To Blue

			GX_Position3f32( 1.0, 1.0,-1.0);	// Top Right Of The Quad (Right)
			GX_Color3f32(1.0,0.0,1.0);			// Set The Color To Violet
			GX_Position3f32( 1.0, 1.0, 1.0);		// Top Left Of The Quad (Right)
			GX_Color3f32(1.0,0.0,1.0);			// Set The Color To Violet
			GX_Position3f32( 1.0,-1.0, 1.0);	// Bottom Left Of The Quad (Right)
			GX_Color3f32(1.0,0.0,1.0);			// Set The Color To Violet
			GX_Position3f32( 1.0,-1.0,-1.0);	// Bottom Right Of The Quad (Right)		
			GX_Color3f32(1.0,0.0,1.0);			// Set The Color To Violet

		GX_End();									// Done Drawing The Quad 

		// do this stuff after drawing
		GX_DrawDone();
		
		fb := fb xor 1;		// flip framebuffer
		GX_SetZMode(GX_TRUE, GX_LEQUAL, GX_TRUE);
		GX_SetColorUpdate(GX_TRUE);
		GX_CopyDisp(frameBuffer[fb],GX_TRUE);

		VIDEO_SetNextFramebuffer(frameBuffer[fb]);
 
		VIDEO_Flush();
 
		VIDEO_WaitVSync();

		rtri := rtri + 0.2;				// Increase The Rotation Variable For The Triangle ( NEW )
		rquad := rquad - 0.15;			// Decrease The Rotation Variable For The Quad     ( NEW )

	end;

end.
 
