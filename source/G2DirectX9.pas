{$optimization off}
{$mode objfpc}
unit G2DirectX9;

interface

uses
  Windows,
  G2Math;

const
  Direct3D9dll = 'd3d9.dll';
  D3D_SDK_VERSION = (32 or $80000000);

const
  MAX_DEVICE_IDENTIFIER_STRING = 512;

  D3DPRESENT_INTERVAL_DEFAULT = $00000000;
  D3DPRESENT_INTERVAL_ONE = $00000001;
  D3DPRESENT_INTERVAL_TWO = $00000002;
  D3DPRESENT_INTERVAL_THREE = $00000004;
  D3DPRESENT_INTERVAL_FOUR = $00000008;
  D3DPRESENT_INTERVAL_IMMEDIATE = $80000000;

  D3DCREATE_FPU_PRESERVE = $00000002;
  D3DCREATE_MULTITHREADED = $00000004;

  D3DCREATE_PUREDEVICE = $00000010;
  D3DCREATE_SOFTWARE_VERTEXPROCESSING = $00000020;
  D3DCREATE_HARDWARE_VERTEXPROCESSING = $00000040;
  D3DCREATE_MIXED_VERTEXPROCESSING = $00000080;

  D3DCREATE_DISABLE_DRIVER_MANAGEMENT = $00000100;
  D3DCREATE_ADAPTERGROUP_DEVICE = $00000200;
  D3DCREATE_DISABLE_DRIVER_MANAGEMENT_EX = $00000400;

  D3DCLEAR_TARGET = $00000001;
  D3DCLEAR_ZBUFFER = $00000002;
  D3DCLEAR_STENCIL = $00000004;

  D3DCREATE_NOWINDOWCHANGES = $00000800;

  D3DUSAGE_RENDERTARGET = $00000001;
  D3DUSAGE_DEPTHSTENCIL = $00000002;
  D3DUSAGE_DYNAMIC = $00000200;
  D3DUSAGE_AUTOGENMIPMAP = $00000400;
  D3DUSAGE_DMAP = $00004000;
  D3DUSAGE_QUERY_LEGACYBUMPMAP = $00008000;
  D3DUSAGE_QUERY_SRGBREAD = $00010000;
  D3DUSAGE_QUERY_FILTER = $00020000;
  D3DUSAGE_QUERY_SRGBWRITE = $00040000;
  D3DUSAGE_QUERY_POSTPIXELSHADER_BLENDING = $00080000;
  D3DUSAGE_QUERY_VERTEXTEXTURE = $00100000;
  D3DUSAGE_QUERY_WRAPANDMIP = $00200000;
  D3DUSAGE_WRITEONLY  = $00000008;
  D3DUSAGE_SOFTWAREPROCESSING = $00000010;
  D3DUSAGE_DONOTCLIP = $00000020;
  D3DUSAGE_POINTS = $00000040;
  D3DUSAGE_RTPATCHES = $00000080;
  D3DUSAGE_NPATCHES = $00000100;

  D3DLOCK_READONLY = $00000010;
  D3DLOCK_DISCARD = $00002000;
  D3DLOCK_NOOVERWRITE = $00001000;
  D3DLOCK_NOSYSLOCK = $00000800;
  D3DLOCK_DONOTWAIT = $00004000;
  D3DLOCK_NO_DIRTY_UPDATE = $00008000;

  D3DFVF_RESERVED0 = $001;
  D3DFVF_POSITION_MASK = $400E;
  D3DFVF_XYZ = $002;
  D3DFVF_XYZRHW = $004;
  D3DFVF_XYZB1 = $006;
  D3DFVF_XYZB2 = $008;
  D3DFVF_XYZB3 = $00a;
  D3DFVF_XYZB4 = $00c;
  D3DFVF_XYZB5 = $00e;
  D3DFVF_XYZW = $4002;
  D3DFVF_NORMAL = $010;
  D3DFVF_PSIZE = $020;
  D3DFVF_DIFFUSE = $040;
  D3DFVF_SPECULAR = $080;
  D3DFVF_TEXCOUNT_MASK = $f00;
  D3DFVF_TEXCOUNT_SHIFT = 8;
  D3DFVF_TEX0 = $000;
  D3DFVF_TEX1 = $100;
  D3DFVF_TEX2 = $200;
  D3DFVF_TEX3 = $300;
  D3DFVF_TEX4 = $400;
  D3DFVF_TEX5 = $500;
  D3DFVF_TEX6 = $600;
  D3DFVF_TEX7 = $700;
  D3DFVF_TEX8 = $800;
  D3DFVF_LASTBETA_UBYTE4 = $1000;
  D3DFVF_LASTBETA_D3DCOLOR = $8000;
  D3DFVF_RESERVED2 = $6000;

  D3DBLENDOP_ADD = 1;
  D3DBLENDOP_SUBTRACT = 2;
  D3DBLENDOP_REVSUBTRACT = 3;
  D3DBLENDOP_MIN = 4;
  D3DBLENDOP_MAX = 5;

  D3DBLEND_ZERO = 1;
  D3DBLEND_ONE = 2;
  D3DBLEND_SRCCOLOR = 3;
  D3DBLEND_INVSRCCOLOR = 4;
  D3DBLEND_SRCALPHA = 5;
  D3DBLEND_INVSRCALPHA = 6;
  D3DBLEND_DESTALPHA = 7;
  D3DBLEND_INVDESTALPHA = 8;
  D3DBLEND_DESTCOLOR = 9;
  D3DBLEND_INVDESTCOLOR = 10;
  D3DBLEND_SRCALPHASAT = 11;
  D3DBLEND_BOTHSRCALPHA = 12;
  D3DBLEND_BOTHINVSRCALPHA = 13;
  D3DBLEND_BLENDFACTOR = 14;
  D3DBLEND_INVBLENDFACTOR = 15;

  D3DTEXF_NONE = 0;
  D3DTEXF_POINT = 1;
  D3DTEXF_LINEAR = 2;
  D3DTEXF_ANISOTROPIC = 3;
  D3DTEXF_PYRAMIDALQUAD = 6;
  D3DTEXF_GAUSSIANQUAD = 7;

  D3DTADDRESS_WRAP = 1;
  D3DTADDRESS_MIRROR = 2;
  D3DTADDRESS_CLAMP = 3;
  D3DTADDRESS_BORDER = 4;
  D3DTADDRESS_MIRRORONCE = 5;

  D3DCULL_NONE = 1;
  D3DCULL_CW = 2;
  D3DCULL_CCW = 3;

  D3DTOP_DISABLE = 1;
  D3DTOP_SELECTARG1 = 2;
  D3DTOP_SELECTARG2 = 3;
  D3DTOP_MODULATE = 4;
  D3DTOP_MODULATE2X = 5;
  D3DTOP_MODULATE4X = 6;
  D3DTOP_ADD = 7;
  D3DTOP_ADDSIGNED = 8;
  D3DTOP_ADDSIGNED2X = 9;
  D3DTOP_SUBTRACT = 10;
  D3DTOP_ADDSMOOTH = 11;
  D3DTOP_BLENDDIFFUSEALPHA = 12;
  D3DTOP_BLENDTEXTUREALPHA = 13;
  D3DTOP_BLENDFACTORALPHA = 14;
  D3DTOP_BLENDTEXTUREALPHAPM = 15;
  D3DTOP_BLENDCURRENTALPHA = 16;
  D3DTOP_PREMODULATE = 17;
  D3DTOP_MODULATEALPHA_ADDCOLOR = 18;
  D3DTOP_MODULATECOLOR_ADDALPHA = 19;
  D3DTOP_MODULATEINVALPHA_ADDCOLOR = 20;
  D3DTOP_MODULATEINVCOLOR_ADDALPHA = 21;
  D3DTOP_BUMPENVMAP = 22;
  D3DTOP_BUMPENVMAPLUMINANCE = 23;
  D3DTOP_DOTPRODUCT3 = 24;
  D3DTOP_MULTIPLYADD = 25;
  D3DTOP_LERP = 26;

  D3DTA_SELECTMASK = $0000000f;
  D3DTA_DIFFUSE = $00000000;
  D3DTA_CURRENT = $00000001;
  D3DTA_TEXTURE = $00000002;
  D3DTA_TFACTOR = $00000003;
  D3DTA_SPECULAR = $00000004;
  D3DTA_TEMP = $00000005;
  D3DTA_CONSTANT = $00000006;
  D3DTA_COMPLEMENT = $00000010;
  D3DTA_ALPHAREPLICATE = $00000020;

  D3DFVF_TEXTUREFORMAT2 = 0;
  D3DFVF_TEXTUREFORMAT1 = 3;
  D3DFVF_TEXTUREFORMAT3 = 1;
  D3DFVF_TEXTUREFORMAT4 = 2;

  D3DPRESENT_DONOTWAIT = $00000001;
  D3DPRESENT_LINEAR_CONTENT = $00000002;
  D3DPRESENT_DONOTFLIP = $00000004;
  D3DPRESENT_FLIPRESTART = $00000008;

type
  TD3DTextureFilterType = type DWord;
  TD3DColor = type DWord;

  TD3DFormat = (
    D3DFMT_UNKNOWN =  0,
    D3DFMT_R8G8B8 = 20,
    D3DFMT_A8R8G8B8 = 21,
    D3DFMT_X8R8G8B8 = 22,
    D3DFMT_R5G6B5 = 23,
    D3DFMT_X1R5G5B5 = 24,
    D3DFMT_A1R5G5B5 = 25,
    D3DFMT_A4R4G4B4 = 26,
    D3DFMT_R3G3B2 = 27,
    D3DFMT_A8 = 28,
    D3DFMT_A8R3G3B2 = 29,
    D3DFMT_X4R4G4B4 = 30,
    D3DFMT_A2B10G10R10 = 31,
    D3DFMT_A8B8G8R8 = 32,
    D3DFMT_X8B8G8R8 = 33,
    D3DFMT_G16R16 = 34,
    D3DFMT_A2R10G10B10 = 35,
    D3DFMT_A16B16G16R16 = 36,
    D3DFMT_A8P8 = 40,
    D3DFMT_P8 = 41,
    D3DFMT_L8 = 50,
    D3DFMT_A8L8 = 51,
    D3DFMT_A4L4 = 52,
    D3DFMT_V8U8 = 60,
    D3DFMT_L6V5U5 = 61,
    D3DFMT_X8L8V8U8 = 62,
    D3DFMT_Q8W8V8U8 = 63,
    D3DFMT_V16U16 = 64,
    D3DFMT_A2W10V10U10 = 67,
    D3DFMT_A8X8V8U8 = 68,
    D3DFMT_L8X8V8U8 = 69,
    D3DFMT_D16_LOCKABLE = 70,
    D3DFMT_D32 = 71,
    D3DFMT_D15S1 = 73,
    D3DFMT_D24S8 = 75,
    D3DFMT_D24X8 = 77,
    D3DFMT_D24X4S4 = 79,
    D3DFMT_D16 = 80,
    D3DFMT_L16 = 81,
    D3DFMT_D32F_LOCKABLE = 82,
    D3DFMT_D24FS8 = 83,
    D3DFMT_VERTEXDATA = 100,
    D3DFMT_INDEX16 = 101,
    D3DFMT_INDEX32 = 102,
    D3DFMT_Q16W16V16U16 = 110,
    D3DFMT_R16F = 111,
    D3DFMT_G16R16F = 112,
    D3DFMT_A16B16G16R16F = 113,
    D3DFMT_R32F = 114,
    D3DFMT_G32R32F = 115,
    D3DFMT_A32B32G32R32F = 116,
    D3DFMT_CxV8U8 = 117,
    D3DFMT_MULTI2_ARGB8 = Byte('M') or (Byte('E') shl 8) or (Byte('T') shl 16) or (Byte('1') shl 24),
    D3DFMT_DXT1 = Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('1') shl 24),
    D3DFMT_DXT2 = Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('2') shl 24),
    D3DFMT_YUY2 = Byte('Y') or (Byte('U') shl 8) or (Byte('Y') shl 16) or (Byte('2') shl 24),
    D3DFMT_DXT3 = Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('3') shl 24),
    D3DFMT_DXT4 = Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('4') shl 24),
    D3DFMT_DXT5 = Byte('D') or (Byte('X') shl 8) or (Byte('T') shl 16) or (Byte('5') shl 24),
    D3DFMT_GRGB = Byte('G') or (Byte('R') shl 8) or (Byte('G') shl 16) or (Byte('B') shl 24),
    D3DFMT_RGBG = Byte('R') or (Byte('G') shl 8) or (Byte('B') shl 16) or (Byte('G') shl 24),
    D3DFMT_UYVY = Byte('U') or (Byte('Y') shl 8) or (Byte('V') shl 16) or (Byte('Y') shl 24),
    D3DFMT_FORCE_DWORD = $7fffffff
  );

  TD3DDevType = (
    D3DDEVTYPE_HAL = 1,
    D3DDEVTYPE_REF = 2,
    D3DDEVTYPE_SW = 3,
    D3DDEVTYPE_NULLREF = 4,
    D3DDEVTYPE_FORCE_DWORD = $ffffffff
  );

  TD3DResourceType = (
    D3DRTYPE_SURFACE = 1,
    D3DRTYPE_VOLUME = 2,
    D3DRTYPE_TEXTURE = 3,
    D3DRTYPE_VOLUMETEXTURE = 4,
    D3DRTYPE_CUBETEXTURE = 5,
    D3DRTYPE_VERTEXBUFFER = 6,
    D3DRTYPE_INDEXBUFFER = 7
  );

  TD3DMultiSampleType = (
    D3DMULTISAMPLE_NONE =  0,
    D3DMULTISAMPLE_NONMASKABLE =  1,
    D3DMULTISAMPLE_2_SAMPLES =  2,
    D3DMULTISAMPLE_3_SAMPLES =  3,
    D3DMULTISAMPLE_4_SAMPLES =  4,
    D3DMULTISAMPLE_5_SAMPLES =  5,
    D3DMULTISAMPLE_6_SAMPLES =  6,
    D3DMULTISAMPLE_7_SAMPLES =  7,
    D3DMULTISAMPLE_8_SAMPLES =  8,
    D3DMULTISAMPLE_9_SAMPLES =  9,
    D3DMULTISAMPLE_10_SAMPLES = 10,
    D3DMULTISAMPLE_11_SAMPLES = 11,
    D3DMULTISAMPLE_12_SAMPLES = 12,
    D3DMULTISAMPLE_13_SAMPLES = 13,
    D3DMULTISAMPLE_14_SAMPLES = 14,
    D3DMULTISAMPLE_15_SAMPLES = 15,
    D3DMULTISAMPLE_16_SAMPLES = 16
  );

  TD3DSwapEffect = (
    D3DSWAPEFFECT_DISCARD = 1,
    D3DSWAPEFFECT_FLIP = 2,
    D3DSWAPEFFECT_COPY = 3
  );

  TD3DBackBufferType = (
    D3DBACKBUFFER_TYPE_MONO = 0,
    D3DBACKBUFFER_TYPE_LEFT = 1,
    D3DBACKBUFFER_TYPE_RIGHT = 2
  );

  TD3DPool = (
    D3DPOOL_DEFAULT = 0,
    D3DPOOL_MANAGED = 1,
    D3DPOOL_SYSTEMMEM = 2,
    D3DPOOL_SCRATCH = 3
  );

  TD3DTransformStateType = (
    D3DTS_VIEW = 2,
    D3DTS_PROJECTION = 3,
    D3DTS_TEXTURE0 = 16,
    D3DTS_TEXTURE1 = 17,
    D3DTS_TEXTURE2 = 18,
    D3DTS_TEXTURE3 = 19,
    D3DTS_TEXTURE4 = 20,
    D3DTS_TEXTURE5 = 21,
    D3DTS_TEXTURE6 = 22,
    D3DTS_TEXTURE7 = 23,
    D3DTS_FORCEWORD = $ffff
  );

  TD3DLightType = (
    D3DLIGHT_POINT = 1,
    D3DLIGHT_SPOT = 2,
    D3DLIGHT_DIRECTIONAL = 3
  );

  TD3DRenderStateType = (
    D3DRS_ZENABLE                   = 7,    (* D3DZBUFFERTYPE (or TRUE/FALSE for legacy) *)
    D3DRS_FILLMODE                  = 8,    (* D3DFILLMODE *)
    D3DRS_SHADEMODE                 = 9,    (* D3DSHADEMODE *)
    D3DRS_ZWRITEENABLE              = 14,   (* TRUE to enable z writes *)
    D3DRS_ALPHATESTENABLE           = 15,   (* TRUE to enable alpha tests *)
    D3DRS_LASTPIXEL                 = 16,   (* TRUE for last-pixel on lines *)
    D3DRS_SRCBLEND                  = 19,   (* D3DBLEND *)
    D3DRS_DESTBLEND                 = 20,   (* D3DBLEND *)
    D3DRS_CULLMODE                  = 22,   (* D3DCULL *)
    D3DRS_ZFUNC                     = 23,   (* D3DCMPFUNC *)
    D3DRS_ALPHAREF                  = 24,   (* D3DFIXED *)
    D3DRS_ALPHAFUNC                 = 25,   (* D3DCMPFUNC *)
    D3DRS_DITHERENABLE              = 26,   (* TRUE to enable dithering *)
    D3DRS_ALPHABLENDENABLE          = 27,   (* TRUE to enable alpha blending *)
    D3DRS_FOGENABLE                 = 28,   (* TRUE to enable fog blending *)
    D3DRS_SPECULARENABLE            = 29,   (* TRUE to enable specular *)
    D3DRS_FOGCOLOR                  = 34,   (* D3DCOLOR *)
    D3DRS_FOGTABLEMODE              = 35,   (* D3DFOGMODE *)
    D3DRS_FOGSTART                  = 36,   (* Fog start (for both vertex and pixel fog) *)
    D3DRS_FOGEND                    = 37,   (* Fog end      *)
    D3DRS_FOGDENSITY                = 38,   (* Fog density  *)
    D3DRS_RANGEFOGENABLE            = 48,   (* Enables range-based fog *)
    D3DRS_STENCILENABLE             = 52,   (* BOOL enable/disable stenciling *)
    D3DRS_STENCILFAIL               = 53,   (* D3DSTENCILOP to do if stencil test fails *)
    D3DRS_STENCILZFAIL              = 54,   (* D3DSTENCILOP to do if stencil test passes and Z test fails *)
    D3DRS_STENCILPASS               = 55,   (* D3DSTENCILOP to do if both stencil and Z tests pass *)
    D3DRS_STENCILFUNC               = 56,   (* D3DCMPFUNC fn.  Stencil Test passes if ((ref & mask) stencilfn (stencil & mask)) is true *)
    D3DRS_STENCILREF                = 57,   (* Reference value used in stencil test *)
    D3DRS_STENCILMASK               = 58,   (* Mask value used in stencil test *)
    D3DRS_STENCILWRITEMASK          = 59,   (* Write mask applied to values written to stencil buffer *)
    D3DRS_TEXTUREFACTOR             = 60,   (* D3DCOLOR used for multi-texture blend *)
    D3DRS_WRAP0                     = 128,  (* wrap for 1st texture coord. set *)
    D3DRS_WRAP1                     = 129,  (* wrap for 2nd texture coord. set *)
    D3DRS_WRAP2                     = 130,  (* wrap for 3rd texture coord. set *)
    D3DRS_WRAP3                     = 131,  (* wrap for 4th texture coord. set *)
    D3DRS_WRAP4                     = 132,  (* wrap for 5th texture coord. set *)
    D3DRS_WRAP5                     = 133,  (* wrap for 6th texture coord. set *)
    D3DRS_WRAP6                     = 134,  (* wrap for 7th texture coord. set *)
    D3DRS_WRAP7                     = 135,  (* wrap for 8th texture coord. set *)
    D3DRS_CLIPPING                  = 136,
    D3DRS_LIGHTING                  = 137,
    D3DRS_AMBIENT                   = 139,
    D3DRS_FOGVERTEXMODE             = 140,
    D3DRS_COLORVERTEX               = 141,
    D3DRS_LOCALVIEWER               = 142,
    D3DRS_NORMALIZENORMALS          = 143,
    D3DRS_DIFFUSEMATERIALSOURCE     = 145,
    D3DRS_SPECULARMATERIALSOURCE    = 146,
    D3DRS_AMBIENTMATERIALSOURCE     = 147,
    D3DRS_EMISSIVEMATERIALSOURCE    = 148,
    D3DRS_VERTEXBLEND               = 151,
    D3DRS_CLIPPLANEENABLE           = 152,
    D3DRS_POINTSIZE                 = 154,   (* float point size *)
    D3DRS_POINTSIZE_MIN             = 155,   (* float point size min threshold *)
    D3DRS_POINTSPRITEENABLE         = 156,   (* BOOL point texture coord control *)
    D3DRS_POINTSCALEENABLE          = 157,   (* BOOL point size scale enable *)
    D3DRS_POINTSCALE_A              = 158,   (* float point attenuation A value *)
    D3DRS_POINTSCALE_B              = 159,   (* float point attenuation B value *)
    D3DRS_POINTSCALE_C              = 160,   (* float point attenuation C value *)
    D3DRS_MULTISAMPLEANTIALIAS      = 161,  // BOOL - set to do FSAA with multisample buffer
    D3DRS_MULTISAMPLEMASK           = 162,  // DWORD - per-sample enable/disable
    D3DRS_PATCHEDGESTYLE            = 163,  // Sets whether patch edges will use float style tessellation
    D3DRS_DEBUGMONITORTOKEN         = 165,  // DEBUG ONLY - token to debug monitor
    D3DRS_POINTSIZE_MAX             = 166,   (* float point size max threshold *)
    D3DRS_INDEXEDVERTEXBLENDENABLE  = 167,
    D3DRS_COLORWRITEENABLE          = 168,  // per-channel write enable
    D3DRS_TWEENFACTOR               = 170,   // float tween factor
    D3DRS_BLENDOP                   = 171,   // D3DBLENDOP setting
    D3DRS_POSITIONDEGREE            = 172,   // NPatch position interpolation degree. D3DDEGREE_LINEAR or D3DDEGREE_CUBIC (default)
    D3DRS_NORMALDEGREE              = 173,   // NPatch normal interpolation degree. D3DDEGREE_LINEAR (default) or D3DDEGREE_QUADRATIC
    D3DRS_SCISSORTESTENABLE         = 174,
    D3DRS_SLOPESCALEDEPTHBIAS       = 175,
    D3DRS_ANTIALIASEDLINEENABLE     = 176,
    D3DRS_MINTESSELLATIONLEVEL      = 178,
    D3DRS_MAXTESSELLATIONLEVEL      = 179,
    D3DRS_ADAPTIVETESS_X            = 180,
    D3DRS_ADAPTIVETESS_Y            = 181,
    D3DRS_ADAPTIVETESS_Z            = 182,
    D3DRS_ADAPTIVETESS_W            = 183,
    D3DRS_ENABLEADAPTIVETESSELLATION = 184,
    D3DRS_TWOSIDEDSTENCILMODE       = 185,   (* BOOL enable/disable 2 sided stenciling *)
    D3DRS_CCW_STENCILFAIL           = 186,   (* D3DSTENCILOP to do if ccw stencil test fails *)
    D3DRS_CCW_STENCILZFAIL          = 187,   (* D3DSTENCILOP to do if ccw stencil test passes and Z test fails *)
    D3DRS_CCW_STENCILPASS           = 188,   (* D3DSTENCILOP to do if both ccw stencil and Z tests pass *)
    D3DRS_CCW_STENCILFUNC           = 189,   (* D3DCMPFUNC fn.  ccw Stencil Test passes if ((ref & mask) stencilfn (stencil & mask)) is true *)
    D3DRS_COLORWRITEENABLE1         = 190,   (* Additional ColorWriteEnables for the devices that support D3DPMISCCAPS_INDEPENDENTWRITEMASKS *)
    D3DRS_COLORWRITEENABLE2         = 191,   (* Additional ColorWriteEnables for the devices that support D3DPMISCCAPS_INDEPENDENTWRITEMASKS *)
    D3DRS_COLORWRITEENABLE3         = 192,   (* Additional ColorWriteEnables for the devices that support D3DPMISCCAPS_INDEPENDENTWRITEMASKS *)
    D3DRS_BLENDFACTOR               = 193,   (* D3DCOLOR used for a constant blend factor during alpha blending for devices that support D3DPBLENDCAPS_BLENDFACTOR *)
    D3DRS_SRGBWRITEENABLE           = 194,   (* Enable rendertarget writes to be DE-linearized to SRGB (for formats that expose D3DUSAGE_QUERY_SRGBWRITE) *)
    D3DRS_DEPTHBIAS                 = 195,
    D3DRS_WRAP8                     = 198,   (* Additional wrap states for vs_3_0+ attributes with D3DDECLUSAGE_TEXCOORD *)
    D3DRS_WRAP9                     = 199,
    D3DRS_WRAP10                    = 200,
    D3DRS_WRAP11                    = 201,
    D3DRS_WRAP12                    = 202,
    D3DRS_WRAP13                    = 203,
    D3DRS_WRAP14                    = 204,
    D3DRS_WRAP15                    = 205,
    D3DRS_SEPARATEALPHABLENDENABLE  = 206,  (* TRUE to enable a separate blending function for the alpha channel *)
    D3DRS_SRCBLENDALPHA             = 207,  (* SRC blend factor for the alpha channel when D3DRS_SEPARATEDESTALPHAENABLE is TRUE *)
    D3DRS_DESTBLENDALPHA            = 208,  (* DST blend factor for the alpha channel when D3DRS_SEPARATEDESTALPHAENABLE is TRUE *)
    D3DRS_BLENDOPALPHA              = 209   (* Blending operation for the alpha channel when D3DRS_SEPARATEDESTALPHAENABLE is TRUE *)
  );

  TD3DTextureStageStateType = (
    D3DTSS_COLOROP        =  1, { D3DTEXTUREOP - per-stage blending controls for color channels }
    D3DTSS_COLORARG1      =  2, { D3DTA_* (texture arg) }
    D3DTSS_COLORARG2      =  3, { D3DTA_* (texture arg) }
    D3DTSS_ALPHAOP        =  4, { D3DTEXTUREOP - per-stage blending controls for alpha channel }
    D3DTSS_ALPHAARG1      =  5, { D3DTA_* (texture arg) }
    D3DTSS_ALPHAARG2      =  6, { D3DTA_* (texture arg) }
    D3DTSS_BUMPENVMAT00   =  7, { float (bump mapping matrix) }
    D3DTSS_BUMPENVMAT01   =  8, { float (bump mapping matrix) }
    D3DTSS_BUMPENVMAT10   =  9, { float (bump mapping matrix) }
    D3DTSS_BUMPENVMAT11   = 10, { float (bump mapping matrix) }
    D3DTSS_TEXCOORDINDEX  = 11, { identifies which set of texture coordinates index this texture }
    D3DTSS_BUMPENVLSCALE  = 22, { float scale for bump map luminance }
    D3DTSS_BUMPENVLOFFSET = 23, { float offset for bump map luminance }
    D3DTSS_TEXTURETRANSFORMFLAGS = 24, { D3DTEXTURETRANSFORMFLAGS controls texture transform }
    D3DTSS_COLORARG0      = 26, { D3DTA_* third arg for triadic ops }
    D3DTSS_ALPHAARG0      = 27, { D3DTA_* third arg for triadic ops }
    D3DTSS_RESULTARG      = 28, { D3DTA_* arg for result (CURRENT or TEMP) }
    D3DTSS_CONSTANT       = 32  { Per-stage constant D3DTA_CONSTANT }
  );

  TD3DSamplerStateType = (
    D3DSAMP_ADDRESSU       = 1,  { D3DTEXTUREADDRESS for U coordinate }
    D3DSAMP_ADDRESSV       = 2,  { D3DTEXTUREADDRESS for V coordinate }
    D3DSAMP_ADDRESSW       = 3,  { D3DTEXTUREADDRESS for W coordinate }
    D3DSAMP_BORDERCOLOR    = 4,  { D3DCOLOR }
    D3DSAMP_MAGFILTER      = 5,  { D3DTEXTUREFILTER filter to use for magnification }
    D3DSAMP_MINFILTER      = 6,  { D3DTEXTUREFILTER filter to use for minification }
    D3DSAMP_MIPFILTER      = 7,  { D3DTEXTUREFILTER filter to use between mipmaps during minification }
    D3DSAMP_MIPMAPLODBIAS  = 8,  { float Mipmap LOD bias }
    D3DSAMP_MAXMIPLEVEL    = 9,  { DWORD 0..(n-1) LOD index of largest map to use (0 == largest) }
    D3DSAMP_MAXANISOTROPY  = 10, { DWORD maximum anisotropy }
    D3DSAMP_SRGBTEXTURE    = 11, { Default = 0 (which means Gamma 1.0,
                                  no correction required.) else correct for
                                  Gamma = 2.2 }
    D3DSAMP_ELEMENTINDEX   = 12, { When multi-element texture is assigned to sampler, this
                                   indicates which element index to use.  Default = 0.  }
    D3DSAMP_DMAPOFFSET     = 13  { Offset in vertices in the pre-sampled displacement map.
                                   Only valid for D3DDMAPSAMPLER sampler  }
  );

  TD3DStateBlockType = (
    D3DSBT_ALL = 1,
    D3DSBT_PIXELSTATE = 2,
    D3DSBT_VERTEXSTATE = 3
  );

  TD3DPrimitiveType = (
    D3DPT_POINTLIST = 1,
    D3DPT_LINELIST = 2,
    D3DPT_LINESTRIP = 3,
    D3DPT_TRIANGLELIST = 4,
    D3DPT_TRIANGLESTRIP = 5,
    D3DPT_TRIANGLEFAN = 6
  );

  {$MINENUMSIZE 1}
  TD3DDeclType = (
    D3DDECLTYPE_FLOAT1 = 0, // 1D float expanded to (value, 0., 0., 1.)
    D3DDECLTYPE_FLOAT2 = 1, // 2D float expanded to (value, value, 0., 1.)
    D3DDECLTYPE_FLOAT3 = 2, // 3D float expanded to (value, value, value, 1.)
    D3DDECLTYPE_FLOAT4 = 3, // 4D float
    D3DDECLTYPE_D3DCOLOR = 4, // 4D packed unsigned bytes mapped to 0. to 1. range
                              // Input is in D3DCOLOR format (ARGB) expanded to (R, G, B, A)
    D3DDECLTYPE_UBYTE4 = 5, // 4D unsigned byte
    D3DDECLTYPE_SHORT2 = 6, // 2D signed short expanded to (value, value, 0., 1.)
    D3DDECLTYPE_SHORT4 = 7, // 4D signed short
    D3DDECLTYPE_UBYTE4N = 8, // Each of 4 bytes is normalized by dividing to 255.0
    D3DDECLTYPE_SHORT2N = 9, // 2D signed short normalized (v[0]/32767.0,v[1]/32767.0,0,1)
    D3DDECLTYPE_SHORT4N = 10, // 4D signed short normalized (v[0]/32767.0,v[1]/32767.0,v[2]/32767.0,v[3]/32767.0)
    D3DDECLTYPE_USHORT2N = 11, // 2D unsigned short normalized (v[0]/65535.0,v[1]/65535.0,0,1)
    D3DDECLTYPE_USHORT4N = 12, // 4D unsigned short normalized (v[0]/65535.0,v[1]/65535.0,v[2]/65535.0,v[3]/65535.0)
    D3DDECLTYPE_UDEC3 = 13, // 3D unsigned 10 10 10 format expanded to (value, value, value, 1)
    D3DDECLTYPE_DEC3N = 14, // 3D signed 10 10 10 format normalized and expanded to (v[0]/511.0, v[1]/511.0, v[2]/511.0, 1)
    D3DDECLTYPE_FLOAT16_2 = 15, // Two 16-bit floating point values, expanded to (value, value, 0, 1)
    D3DDECLTYPE_FLOAT16_4 = 16, // Four 16-bit floating point values
    D3DDECLTYPE_UNUSED = 17 // When the type field in a decl is unused.
  );

  TD3DDeclMethod = (
    D3DDECLMETHOD_DEFAULT,
    D3DDECLMETHOD_PARTIALU,
    D3DDECLMETHOD_PARTIALV,
    D3DDECLMETHOD_CROSSUV,
    D3DDECLMETHOD_UV,
    D3DDECLMETHOD_LOOKUP,
    D3DDECLMETHOD_LOOKUPPRESAMPLED
  );

  TD3DDeclUsage = (
    D3DDECLUSAGE_POSITION,
    D3DDECLUSAGE_BLENDWEIGHT,
    D3DDECLUSAGE_BLENDINDICES,
    D3DDECLUSAGE_NORMAL,
    D3DDECLUSAGE_PSIZE,
    D3DDECLUSAGE_TEXCOORD,
    D3DDECLUSAGE_TANGENT,
    D3DDECLUSAGE_BINORMAL,
    D3DDECLUSAGE_TESSFACTOR,
    D3DDECLUSAGE_POSITIONT,
    D3DDECLUSAGE_COLOR,
    D3DDECLUSAGE_FOG,
    D3DDECLUSAGE_DEPTH,
    D3DDECLUSAGE_SAMPLE
  );
  {$MINENUMSIZE 4}

  TD3DBasisType = (
    D3DBASIS_BEZIER = 0,
    D3DBASIS_BSPLINE = 1,
    D3DBASIS_CATMULL_ROM = 2
  );

  TD3DDegreeType = (
    D3DDEGREE_LINEAR = 1,
    D3DDEGREE_QUADRATIC = 2,
    D3DDEGREE_CUBIC = 3,
    D3DDEGREE_QUINTIC = 5
  );

  TD3DQueryType = (
    D3DQUERYTYPE_VCACHE = 4,
    D3DQUERYTYPE_RESOURCEMANAGER = 5,
    D3DQUERYTYPE_VERTEXSTATS = 6,
    D3DQUERYTYPE_EVENT = 8,
    D3DQUERYTYPE_OCCLUSION = 9,
    D3DQUERYTYPE_TIMESTAMP = 10,
    D3DQUERYTYPE_TIMESTAMPDISJOINT = 11,
    D3DQUERYTYPE_TIMESTAMPFREQ = 12,
    D3DQUERYTYPE_PIPELINETIMINGS = 13,
    D3DQUERYTYPE_INTERFACETIMINGS = 14,
    D3DQUERYTYPE_VERTEXTIMINGS = 15,
    D3DQUERYTYPE_PIXELTIMINGS = 16,
    D3DQUERYTYPE_BANDWIDTHTIMINGS = 17,
    D3DQUERYTYPE_CACHEUTILIZATION = 18
  );

  TD3DCubeMapFaces = (
    D3DCUBEMAP_FACE_POSITIVE_X = 0,
    D3DCUBEMAP_FACE_NEGATIVE_X = 1,
    D3DCUBEMAP_FACE_POSITIVE_Y = 2,
    D3DCUBEMAP_FACE_NEGATIVE_Y = 3,
    D3DCUBEMAP_FACE_POSITIVE_Z = 4,
    D3DCUBEMAP_FACE_NEGATIVE_Z = 5
  );

type
  PD3DDisplayMode = ^TD3DDisplayMode;
  TD3DDisplayMode = packed record
    Width: LongWord;
    Height: LongWord;
    RefreshRate: LongWord;
    Format: TD3DFormat;
  end;

  PD3DAdapterIdentifier9 = ^TD3DAdapterIdentifier9;
  TD3DAdapterIdentifier9 = packed record
    Driver: array [0..MAX_DEVICE_IDENTIFIER_STRING - 1] of AnsiChar;
    Description: array [0..MAX_DEVICE_IDENTIFIER_STRING - 1] of AnsiChar;
    DeviceName: array [0..31] of AnsiChar;
    DriverVersionLowPart: DWord;
    DriverVersionHighPart: DWord;
    VendorId: DWord;
    DeviceId: DWord;
    SubSysId: DWord;
    Revision: DWord;
    DeviceIdentifier: TGUID;
    WHQLLevel: DWord;
  end;

  PD3DVShaderCaps2_0 = ^TD3DVShaderCaps2_0;
  TD3DVShaderCaps2_0 = packed record
    Caps: DWord;
    DynamicFlowControlDepth: Integer;
    NumTemps: Integer;
    StaticFlowControlDepth: Integer;
  end;

  PD3DPShaderCaps2_0 = ^TD3DPShaderCaps2_0;
  TD3DPShaderCaps2_0 = packed record
    Caps: DWord;
    DynamicFlowControlDepth: Integer;
    NumTemps: Integer;
    StaticFlowControlDepth: Integer;
    NumInstructionSlots: Integer;
  end;

  PD3DCaps9 = ^TD3DCaps9;
  TD3DCaps9 = record
    DeviceType: TD3DDevType;
    AdapterOrdinal: DWord;
    Caps: DWord;
    Caps2: DWord;
    Caps3: DWord;
    PresentationIntervals: DWord;
    CursorCaps: DWord;
    DevCaps: DWord;
    PrimitiveMiscCaps: DWord;
    RasterCaps: DWord;
    ZCmpCaps: DWord;
    SrcBlendCaps: DWord;
    DestBlendCaps: DWord;
    AlphaCmpCaps: DWord;
    ShadeCaps: DWord;
    TextureCaps: DWord;
    TextureFilterCaps: DWord;
    CubeTextureFilterCaps: DWord;
    VolumeTextureFilterCaps: DWord;
    TextureAddressCaps: DWord;
    VolumeTextureAddressCaps: DWord;
    LineCaps: DWord;
    MaxTextureWidth, MaxTextureHeight: DWord;
    MaxVolumeExtent: DWord;
    MaxTextureRepeat: DWord;
    MaxTextureAspectRatio: DWord;
    MaxAnisotropy: DWord;
    MaxVertexW: Single;
    GuardBandLeft: Single;
    GuardBandTop: Single;
    GuardBandRight: Single;
    GuardBandBottom: Single;
    ExtentsAdjust: Single;
    StencilCaps: DWord;
    FVFCaps: DWord;
    TextureOpCaps: DWord;
    MaxTextureBlendStages: DWord;
    MaxSimultaneousTextures: DWord;
    VertexProcessingCaps: DWord;
    MaxActiveLights: DWord;
    MaxUserClipPlanes: DWord;
    MaxVertexBlendMatrices: DWord;
    MaxVertexBlendMatrixIndex: DWord;
    MaxPointSize: Single;
    MaxPrimitiveCount: DWord;
    MaxVertexIndex: DWord;
    MaxStreams: DWord;
    MaxStreamStride: DWord;
    VertexShaderVersion: DWord;
    MaxVertexShaderConst: DWord;
    PixelShaderVersion: DWord;
    PixelShader1xMaxValue: Single;
    DevCaps2: DWord;
    MaxNpatchTessellationLevel: Single;
    Reserved5: DWord;
    MasterAdapterOrdinal: LongWord;
    AdapterOrdinalInGroup: LongWord;
    NumberOfAdaptersInGroup: LongWord;
    DeclTypes: DWord;
    NumSimultaneousRTs: DWord;
    StretchRectFilterCaps: DWord;
    VS20Caps: TD3DVShaderCaps2_0;
    PS20Caps: TD3DPShaderCaps2_0;
    VertexTextureFilterCaps: DWord;
    MaxVShaderInstructionsExecuted: DWord;
    MaxPShaderInstructionsExecuted: DWord;
    MaxVertexShader30InstructionSlots: DWord;
    MaxPixelShader30InstructionSlots: DWord;
  end;

  PD3DPresentParameters = ^TD3DPresentParameters;
  TD3DPresentParameters = record
    BackBufferWidth: LongWord;
    BackBufferHeight: LongWord;
    BackBufferFormat: TD3DFormat;
    BackBufferCount: LongWord;
    MultiSampleType: TD3DMultiSampleType;
    MultiSampleQuality: DWord;
    SwapEffect: TD3DSwapEffect;
    hDeviceWindow: HWnd;
    Windowed: Bool;
    EnableAutoDepthStencil: Bool;
    AutoDepthStencilFormat: TD3DFormat;
    Flags: LongInt;
    FullScreen_RefreshRateInHz: LongWord;
    PresentationInterval: LongWord;
  end;

  PD3DDeviceCreationParameters = ^TD3DDeviceCreationParameters;
  TD3DDeviceCreationParameters = packed record
    AdapterOrdinal: LongWord;
    DeviceType: TD3DDevType;
    hFocusWindow: HWnd;
    BehaviorFlags: LongInt;
  end;

  PD3DRasterStatus = ^TD3DRasterStatus;
  TD3DRasterStatus = packed record
    InVBlank: Bool;
    ScanLine: LongWord;
  end;

  PD3DGammaRamp = ^TD3DGammaRamp;
  TD3DGammaRamp = packed record
    red: array [0..255] of Word;
    green: array [0..255] of Word;
    blue: array [0..255] of Word;
  end;

  PD3DRect = ^TD3DRect;
  TD3DRect = packed record
    x1: LongInt;
    y1: LongInt;
    x2: LongInt;
    y2: LongInt;
  end;

  PD3DVector = ^TD3DVector;
  TD3DVector = packed record
    x, y, z: Single;
  end;

  PD3DMatrix = ^TD3DMatrix;
  TD3DMatrix = array [0..3, 0..3] of Single;

  PD3DViewport9 = ^TD3DViewport9;
  TD3DViewport9 = packed record
    X: DWord;
    Y: DWord;
    Width: DWord;
    Height: DWord;
    MinZ: Single;
    MaxZ: Single;
  end;

  PD3DColorValue = ^TD3DColorValue;
  TD3DColorValue = packed record
    r: Single;
    g: Single;
    b: Single;
    a: Single;
  end;

  PD3DMaterial9 = ^TD3DMaterial9;
  TD3DMaterial9 = packed record
    Diffuse: TD3DColorValue;
    Ambient: TD3DColorValue;
    Specular: TD3DColorValue;
    Emissive: TD3DColorValue;
    Power: Single;
  end;

  PD3DLight9 = ^TD3DLight9;
  TD3DLight9 = packed record
    _Type: TD3DLightType;
    Diffuse: TD3DColorValue;
    Specular: TD3DColorValue;
    Ambient: TD3DColorValue;
    Position: TD3DVector;
    Direction: TD3DVector;
    Range: Single;
    Falloff: Single;
    Attenuation0: Single;
    Attenuation1: Single;
    Attenuation2: Single;
    Theta: Single;
    Phi: Single;
  end;

  PD3DClipStatus9 = ^TD3DClipStatus9;
  TD3DClipStatus9 = packed record
    ClipUnion: DWord;
    ClipIntersection: DWord;
  end;

  PD3DVertexElement9 = ^TD3DVertexElement9;
  TD3DVertexElement9 = packed record
    Stream: Word;
    Offset: Word;
    _Type: TD3DDeclType;
    Method: TD3DDeclMethod;
    Usage: TD3DDeclUsage;
    UsageIndex: Byte;
  end;

  PD3DRectPatchInfo = ^TD3DRectPatchInfo;
  TD3DRectPatchInfo = packed record
    StartVertexOffsetWidth : LongWord;
    StartVertexOffsetHeight : LongWord;
    Width: LongWord;
    Height: LongWord;
    Stride: LongWord;
    Basis: TD3DBasisType;
    Degree: TD3DDegreeType;
  end;

  PD3DTriPatchInfo = ^TD3DTriPatchInfo;
  TD3DTriPatchInfo = packed record
    StartVertexOffset: LongWord;
    NumVertices: LongWord;
    Basis: TD3DBasisType;
    Degree: TD3DDegreeType;
  end;

  PD3DSurfaceDesc = ^TD3DSurfaceDesc;
  TD3DSurfaceDesc = packed record
    Format: TD3DFormat;
    _Type: TD3DResourceType;
    Usage: DWord;
    Pool: TD3DPool;
    MultiSampleType: TD3DMultiSampleType;
    MultiSampleQuality: DWORD;
    Width: LongWord;
    Height: LongWord;
  end;

  PD3DLockedRect = ^TD3DLockedRect;
  TD3DLockedRect = record
    Pitch: Integer;
    pBits: Pointer;
  end;

  PD3DVolumeDesc = ^TD3DVolumeDesc;
  TD3DVolumeDesc = record
    Format: TD3DFormat;
    _Type: TD3DResourceType;
    Usage: DWord;
    Pool: TD3DPool;
    Width: LongWord;
    Height: LongWord;
    Depth: LongWord;
  end;

  PD3DLockedBox = ^TD3DLockedBox;
  TD3DLockedBox = packed record
    RowPitch: Integer;
    SlicePitch: Integer;
    pBits: Pointer;
  end;

  PD3DBox = ^TD3DBox;
  TD3DBox = packed record
    Left: LongWord;
    Top: LongWord;
    Right: LongWord;
    Bottom: LongWord;
    Front: LongWord;
    Back: LongWord;
  end;

  PD3DVertexBufferDesc = ^TD3DVertexBufferDesc;
  TD3DVertexBufferDesc = packed record
    Format: TD3DFormat;
    _Type: TD3DResourceType;
    Usage: DWord;
    Pool: TD3DPool;
    Size: LongWord;
    FVF: DWord;
  end;

  PD3DIndexBufferDesc = ^TD3DIndexBufferDesc;
  TD3DIndexBufferDesc = packed record
    Format: TD3DFormat;
    _Type: TD3DResourceType;
    Usage: DWord;
    Pool: TD3DPool;
    Size: LongWord;
  end;

const
  D3DTS_WORLD = TD3DTransformStateType(256);
  D3DDECL_END: TD3DVertexElement9 = (
    Stream: $FF;
    Offset: 0;
    _Type: D3DDECLTYPE_UNUSED;
    Method: TD3DDeclMethod(0);
    Usage: TD3DDeclUsage(0);
    UsageIndex: 0
  );

type
  IDirect3D9 = interface;
  IDirect3DDevice9 = interface;
  IDirect3DResource9 = interface;
  IDirect3DSurface9 = interface;
  IDirect3DVolume9 = interface;
  IDirect3DSwapChain9 = interface;
  IDirect3DBaseTexture9 = interface;
  IDirect3DTexture9 = interface;
  IDirect3DVolumeTexture9 = interface;
  IDirect3DCubeTexture9 = interface;
  IDirect3DVertexBuffer9 = interface;
  IDirect3DIndexBuffer9 = interface;
  IDirect3DStateBlock9 = interface;
  IDirect3DVertexDeclaration9 = interface;
  IDirect3DVertexShader9 = interface;
  IDirect3DPixelShader9 = interface;
  IDirect3DQuery9 = interface;

  IDirect3D9 = interface(IUnknown)
    ['{81BDCBCA-64D4-426d-AE8D-AD0147F4275C}']
    function RegisterSoftwareDevice(pInitializeFunction: Pointer): HResult; stdcall;
    function GetAdapterCount: LongWord; stdcall;
    function GetAdapterIdentifier(Adapter: LongWord; Flags: DWord; out pIdentifier: TD3DAdapterIdentifier9): HResult; stdcall;
    function GetAdapterModeCount(Adapter: LongWord; Format: TD3DFormat): LongWord; stdcall;
    function EnumAdapterModes(Adapter: LongWord; Format: TD3DFormat; Mode: LongWord; out pMode: TD3DDisplayMode): HResult; stdcall;
    function GetAdapterDisplayMode(Adapter: LongWord; out pMode: TD3DDisplayMode): HResult; stdcall;
    function CheckDeviceType(Adapter: LongWord; CheckType: TD3DDevType; AdapterFormat, BackBufferFormat: TD3DFormat; Windowed: BOOL): HResult; stdcall;
    function CheckDeviceFormat(Adapter: LongWord; DeviceType: TD3DDevType; AdapterFormat: TD3DFormat; Usage: DWord; RType: TD3DResourceType; CheckFormat: TD3DFormat): HResult; stdcall;
    function CheckDeviceMultiSampleType(Adapter: LongWord; DeviceType: TD3DDevType; SurfaceFormat: TD3DFormat; Windowed: BOOL; MultiSampleType: TD3DMultiSampleType; pQualityLevels: PDWORD): HResult; stdcall;
    function CheckDepthStencilMatch(Adapter: LongWord; DeviceType: TD3DDevType; AdapterFormat, RenderTargetFormat, DepthStencilFormat: TD3DFormat): HResult; stdcall;
    function CheckDeviceFormatConversion(Adapter: LongWord; DeviceType: TD3DDevType; SourceFormat, TargetFormat: TD3DFormat): HResult; stdcall;
    function GetDeviceCaps(Adapter: LongWord; DeviceType: TD3DDevType; out pCaps: TD3DCaps9): HResult; stdcall;
    function GetAdapterMonitor(Adapter: LongWord): HMONITOR; stdcall;
    function CreateDevice(Adapter: LongWord; DeviceType: TD3DDevType; hFocusWindow: HWND; BehaviorFlags: DWord; pPresentationParameters: PD3DPresentParameters; out ppReturnedDeviceInterface: IDirect3DDevice9): HResult; stdcall;
  end;

  IDirect3DDevice9 = interface(IUnknown)
    ['{D0223B96-BF7A-43fd-92BD-A43B0D82B9EB}']
    function TestCooperativeLevel: HResult; stdcall;
    function GetAvailableTextureMem: LongWord; stdcall;
    function EvictManagedResources: HResult; stdcall;
    function GetDirect3D(out ppD3D9: IDirect3D9): HResult; stdcall;
    function GetDeviceCaps(out pCaps: TD3DCaps9): HResult; stdcall;
    function GetDisplayMode(iSwapChain: LongWord; out pMode: TD3DDisplayMode): HResult; stdcall;
    function GetCreationParameters(out pParameters: TD3DDeviceCreationParameters): HResult; stdcall;
    function SetCursorProperties(XHotSpot, YHotSpot: LongWord; pCursorBitmap: IDirect3DSurface9): HResult; stdcall;
    procedure SetCursorPosition(XScreenSpace, YScreenSpace: LongWord; Flags: DWord); stdcall;
    function ShowCursor(bShow: BOOL): BOOL; stdcall;
    function CreateAdditionalSwapChain(const pPresentationParameters: TD3DPresentParameters; out pSwapChain: IDirect3DSwapChain9): HResult; stdcall;
    function GetSwapChain(iSwapChain: LongWord; out pSwapChain: IDirect3DSwapChain9): HResult; stdcall;
    function GetNumberOfSwapChains: LongWord; stdcall;
    function Reset(const pPresentationParameters: TD3DPresentParameters): HResult; stdcall;
    function Present(pSourceRect, pDestRect: PRect; hDestWindowOverride: HWND; pDirtyRegion: PRgnData): HResult; stdcall;
    function GetBackBuffer(iSwapChain: LongWord; iBackBuffer: LongWord; _Type: TD3DBackBufferType; out ppBackBuffer: IDirect3DSurface9): HResult; stdcall;
    function GetRasterStatus(iSwapChain: LongWord; out pRasterStatus: TD3DRasterStatus): HResult; stdcall;
    function SetDialogBoxMode(bEnableDialogs: BOOL): HResult; stdcall;
    procedure SetGammaRamp(iSwapChain: LongWord; Flags: DWord; const pRamp: TD3DGammaRamp); stdcall;
    procedure GetGammaRamp(iSwapChain: LongWord; out pRamp: TD3DGammaRamp); stdcall;
    function CreateTexture(Width, Height, Levels: LongWord; Usage: DWord; Format: TD3DFormat; Pool: TD3DPool; out ppTexture: IDirect3DTexture9; pSharedHandle: PHandle): HResult; stdcall;
    function CreateVolumeTexture(Width, Height, Depth, Levels: LongWord; Usage: DWord; Format: TD3DFormat; Pool: TD3DPool; out ppVolumeTexture: IDirect3DVolumeTexture9; pSharedHandle: PHandle): HResult; stdcall;
    function CreateCubeTexture(EdgeLength, Levels: LongWord; Usage: DWord; Format: TD3DFormat; Pool: TD3DPool; out ppCubeTexture: IDirect3DCubeTexture9; pSharedHandle: PHandle): HResult; stdcall;
    function CreateVertexBuffer(Length: LongWord; Usage, FVF: DWord; Pool: TD3DPool; out ppVertexBuffer: IDirect3DVertexBuffer9; pSharedHandle: PHandle): HResult; stdcall;
    function CreateIndexBuffer(Length: LongWord; Usage: DWord; Format: TD3DFormat; Pool: TD3DPool; out ppIndexBuffer: IDirect3DIndexBuffer9; pSharedHandle: PHandle): HResult; stdcall;
    function CreateRenderTarget(Width, Height: LongWord; Format: TD3DFormat; MultiSample: TD3DMultiSampleType; MultisampleQuality: DWORD; Lockable: BOOL; out ppSurface: IDirect3DSurface9; pSharedHandle: PHandle): HResult; stdcall;
    function CreateDepthStencilSurface(Width, Height: LongWord; Format: TD3DFormat; MultiSample: TD3DMultiSampleType; MultisampleQuality: DWORD; Discard: BOOL; out ppSurface: IDirect3DSurface9; pSharedHandle: PHandle): HResult; stdcall;
    function UpdateSurface(pSourceSurface: IDirect3DSurface9; pSourceRect: PRect; pDestinationSurface: IDirect3DSurface9; pDestPoint: PPoint): HResult; stdcall;
    function UpdateTexture(pSourceTexture, pDestinationTexture: IDirect3DBaseTexture9): HResult; stdcall;
    function GetRenderTargetData(pRenderTarget, pDestSurface: IDirect3DSurface9): HResult; stdcall;
    function GetFrontBufferData(iSwapChain: LongWord; pDestSurface: IDirect3DSurface9): HResult; stdcall;
    function StretchRect(pSourceSurface: IDirect3DSurface9; pSourceRect: PRect; pDestSurface: IDirect3DSurface9; pDestRect: PRect; Filter: TD3DTextureFilterType): HResult; stdcall;
    function ColorFill(pSurface: IDirect3DSurface9; pRect: PRect; color: TD3DColor): HResult; stdcall;
    function CreateOffscreenPlainSurface(Width, Height: LongWord; Format: TD3DFormat; Pool: TD3DPool; out ppSurface: IDirect3DSurface9; pSharedHandle: PHandle): HResult; stdcall;
    function SetRenderTarget(RenderTargetIndex: DWORD; pRenderTarget: IDirect3DSurface9): HResult; stdcall;
    function GetRenderTarget(RenderTargetIndex: DWORD; out ppRenderTarget: IDirect3DSurface9): HResult; stdcall;
    function SetDepthStencilSurface(pNewZStencil: IDirect3DSurface9): HResult; stdcall;
    function GetDepthStencilSurface(out ppZStencilSurface: IDirect3DSurface9): HResult; stdcall;
    function BeginScene: HResult; stdcall;
    function EndScene: HResult; stdcall;
    function Clear(Count: DWord; pRects: PD3DRect; Flags: DWord; Color: TD3DColor; Z: Single; Stencil: DWord): HResult; stdcall;
    function SetTransform(State: TD3DTransformStateType; const pMatrix: TG2Mat): HResult; stdcall;
    function GetTransform(State: TD3DTransformStateType; out pMatrix: TG2Mat): HResult; stdcall;
    function MultiplyTransform(State: TD3DTransformStateType; const pMatrix: TG2Mat): HResult; stdcall;
    function SetViewport(const pViewport: TD3DViewport9): HResult; stdcall;
    function GetViewport(out pViewport: TD3DViewport9): HResult; stdcall;
    function SetMaterial(const pMaterial: TD3DMaterial9): HResult; stdcall;
    function GetMaterial(out pMaterial: TD3DMaterial9): HResult; stdcall;
    function SetLight(Index: DWord; const pLight: TD3DLight9): HResult; stdcall;
    function GetLight(Index: DWord; out pLight: TD3DLight9): HResult; stdcall;
    function LightEnable(Index: DWord; Enable: BOOL): HResult; stdcall;
    function GetLightEnable(Index: DWord; out pEnable: BOOL): HResult; stdcall;
    function SetClipPlane(Index: DWord; pPlane: PSingle): HResult; stdcall;
    function GetClipPlane(Index: DWord; pPlane: PSingle): HResult; stdcall;
    function SetRenderState(State: TD3DRenderStateType; Value: DWord): HResult; stdcall;
    function GetRenderState(State: TD3DRenderStateType; out pValue: DWord): HResult; stdcall;
    function CreateStateBlock(_Type: TD3DStateBlockType; out ppSB: IDirect3DStateBlock9): HResult; stdcall;
    function BeginStateBlock: HResult; stdcall;
    function EndStateBlock(out ppSB: IDirect3DStateBlock9): HResult; stdcall;
    function SetClipStatus(const pClipStatus: TD3DClipStatus9): HResult; stdcall;
    function GetClipStatus(out pClipStatus: TD3DClipStatus9): HResult; stdcall;
    function GetTexture(Stage: DWord; out ppTexture: IDirect3DBaseTexture9): HResult; stdcall;
    function SetTexture(Stage: DWord; pTexture: IDirect3DBaseTexture9): HResult; stdcall;
    function GetTextureStageState(Stage: DWord; _Type: TD3DTextureStageStateType; out pValue: DWord): HResult; stdcall;
    function SetTextureStageState(Stage: DWord; _Type: TD3DTextureStageStateType; Value: DWord): HResult; stdcall;
    function GetSamplerState(Sampler: DWORD; _Type: TD3DSamplerStateType; out pValue: DWORD): HResult; stdcall;
    function SetSamplerState(Sampler: DWORD; _Type: TD3DSamplerStateType; Value: DWORD): HResult; stdcall;
    function ValidateDevice(out pNumPasses: DWord): HResult; stdcall;
    function SetPaletteEntries(PaletteNumber: LongWord; pEntries: pPaletteEntry): HResult; stdcall;
    function GetPaletteEntries(PaletteNumber: LongWord; pEntries: pPaletteEntry): HResult; stdcall;
    function SetCurrentTexturePalette(PaletteNumber: LongWord): HResult; stdcall;
    function GetCurrentTexturePalette(out PaletteNumber: LongWord): HResult; stdcall;
    function SetScissorRect(pRect: PRect): HResult; stdcall;
    function GetScissorRect(out pRect: TRect): HResult; stdcall;
    function SetSoftwareVertexProcessing(bSoftware: BOOL): HResult; stdcall;
    function GetSoftwareVertexProcessing: BOOL; stdcall;
    function SetNPatchMode(nSegments: Single): HResult; stdcall;
    function GetNPatchMode: Single; stdcall;
    function DrawPrimitive(PrimitiveType: TD3DPrimitiveType; StartVertex, PrimitiveCount: LongWord): HResult; stdcall;
    function DrawIndexedPrimitive(_Type: TD3DPrimitiveType; BaseVertexIndex: Integer; MinVertexIndex, NumVertices, startIndex, primCount: LongWord): HResult; stdcall;
    function DrawPrimitiveUP(PrimitiveType: TD3DPrimitiveType; PrimitiveCount: LongWord; const pVertexStreamZeroData; VertexStreamZeroStride: LongWord): HResult; stdcall;
    function DrawIndexedPrimitiveUP(PrimitiveType: TD3DPrimitiveType; MinVertexIndex, NumVertice, PrimitiveCount: LongWord; const pIndexData; IndexDataFormat: TD3DFormat; const pVertexStreamZeroData; VertexStreamZeroStride: LongWord): HResult; stdcall;
    function ProcessVertices(SrcStartIndex, DestIndex, VertexCount: LongWord; pDestBuffer: IDirect3DVertexBuffer9; pVertexDecl: IDirect3DVertexDeclaration9; Flags: DWord): HResult; stdcall;
    function CreateVertexDeclaration(pVertexElements: PD3DVertexElement9; out ppDecl: IDirect3DVertexDeclaration9): HResult; stdcall;
    function SetVertexDeclaration(pDecl: IDirect3DVertexDeclaration9): HResult; stdcall;
    function GetVertexDeclaration(out ppDecl: IDirect3DVertexDeclaration9): HResult; stdcall;
    function SetFVF(FVF: DWORD): HResult; stdcall;
    function GetFVF(out FVF: DWORD): HResult; stdcall;
    function CreateVertexShader(pFunction: PDWord; out ppShader: IDirect3DVertexShader9): HResult; stdcall;
    function SetVertexShader(pShader: IDirect3DVertexShader9): HResult; stdcall;
    function GetVertexShader(out ppShader: IDirect3DVertexShader9): HResult; stdcall;
    function SetVertexShaderConstantF(StartRegister: LongWord; pConstantData: PSingle; Vector4fCount: LongWord): HResult; stdcall;
    function GetVertexShaderConstantF(StartRegister: LongWord; pConstantData: PSingle; Vector4fCount: LongWord): HResult; stdcall;
    function SetVertexShaderConstantI(StartRegister: LongWord; pConstantData: PInteger; Vector4iCount: LongWord): HResult; stdcall;
    function GetVertexShaderConstantI(StartRegister: LongWord; pConstantData: PInteger; Vector4iCount: LongWord): HResult; stdcall;
    function SetVertexShaderConstantB(StartRegister: LongWord; pConstantData: PBOOL; BoolCount: LongWord): HResult; stdcall;
    function GetVertexShaderConstantB(StartRegister: LongWord; pConstantData: PBOOL; BoolCount: LongWord): HResult; stdcall;
    function SetStreamSource(StreamNumber: LongWord; pStreamData: IDirect3DVertexBuffer9; OffsetInBytes, Stride: LongWord): HResult; stdcall;
    function GetStreamSource(StreamNumber: LongWord; out ppStreamData: IDirect3DVertexBuffer9; out pOffsetInBytes, pStride: LongWord): HResult; stdcall;
    function SetStreamSourceFreq(StreamNumber: LongWord; Setting: LongWord): HResult; stdcall;
    function GetStreamSourceFreq(StreamNumber: LongWord; out Setting: LongWord): HResult; stdcall;
    function SetIndices(pIndexData: IDirect3DIndexBuffer9): HResult; stdcall;
    function GetIndices(out ppIndexData: IDirect3DIndexBuffer9): HResult; stdcall;
    function CreatePixelShader(pFunction: PDWord; out ppShader: IDirect3DPixelShader9): HResult; stdcall;
    function SetPixelShader(pShader: IDirect3DPixelShader9): HResult; stdcall;
    function GetPixelShader(out ppShader: IDirect3DPixelShader9): HResult; stdcall;
    function SetPixelShaderConstantF(StartRegister: LongWord; pConstantData: PSingle; Vector4fCount: LongWord): HResult; stdcall;
    function GetPixelShaderConstantF(StartRegister: LongWord; pConstantData: PSingle; Vector4fCount: LongWord): HResult; stdcall;
    function SetPixelShaderConstantI(StartRegister: LongWord; pConstantData: PInteger; Vector4iCount: LongWord): HResult; stdcall;
    function GetPixelShaderConstantI(StartRegister: LongWord; pConstantData: PInteger; Vector4iCount: LongWord): HResult; stdcall;
    function SetPixelShaderConstantB(StartRegister: LongWord; pConstantData: PBOOL; BoolCount: LongWord): HResult; stdcall;
    function GetPixelShaderConstantB(StartRegister: LongWord; pConstantData: PBOOL; BoolCount: LongWord): HResult; stdcall;
    function DrawRectPatch(Handle: LongWord; pNumSegs: PSingle; pTriPatchInfo: PD3DRectPatchInfo): HResult; stdcall;
    function DrawTriPatch(Handle: LongWord; pNumSegs: PSingle; pTriPatchInfo: PD3DTriPatchInfo): HResult; stdcall;
    function DeletePatch(Handle: LongWord): HResult; stdcall;
    function CreateQuery(_Type: TD3DQueryType; out ppQuery: IDirect3DQuery9): HResult; stdcall;
  end;

  IDirect3DResource9 = interface(IUnknown)
    ['{05EEC05D-8F7D-4362-B999-D1BAF357C704}']
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function SetPrivateData(const refguid: TGUID; const pData: Pointer; SizeOfData, Flags: DWord): HResult; stdcall;
    function GetPrivateData(const refguid: TGUID; pData: Pointer; out pSizeOfData: DWord): HResult; stdcall;
    function FreePrivateData(const refguid: TGUID): HResult; stdcall;
    function SetPriority(PriorityNew: DWord): DWord; stdcall;
    function GetPriority: DWord; stdcall;
    procedure PreLoad; stdcall;
    function GetType: TD3DResourceType; stdcall;
  end;

  IDirect3DSurface9 = interface(IDirect3DResource9)
    ['{0CFBAF3A-9FF6-429a-99B3-A2796AF8B89B}']
    function GetContainer(const riid: TGUID; out ppContainer): HResult; stdcall;
    function GetDesc(out pDesc: TD3DSurfaceDesc): HResult; stdcall;
    function LockRect(out pLockedRect: TD3DLockedRect; pRect: PRect; Flags: DWord): HResult; stdcall;
    function UnlockRect: HResult; stdcall;
    function GetDC(out phdc: HDC): HResult; stdcall;
    function ReleaseDC(hdc: HDC): HResult; stdcall;
  end;

  IDirect3DVolume9 = interface (IUnknown)
    ['{24F416E6-1F67-4aa7-B88E-D33F6F3128A1}']
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function SetPrivateData(const refguid: TGUID; const pData; SizeOfData, Flags: DWord): HResult; stdcall;
    function GetPrivateData(const refguid: TGUID; pData: Pointer; out pSizeOfData: DWord): HResult; stdcall;
    function FreePrivateData(const refguid: TGUID): HResult; stdcall;
    function GetContainer(const riid: TGUID; var ppContainer: Pointer): HResult; stdcall;
    function GetDesc(out pDesc: TD3DVolumeDesc): HResult; stdcall;
    function LockBox(out pLockedVolume: TD3DLockedBox; pBox: PD3DBox; Flags: DWord): HResult; stdcall;
    function UnlockBox: HResult; stdcall;
  end;

  IDirect3DSwapChain9 = interface(IUnknown)
    ['{794950F2-ADFC-458a-905E-10A10B0B503B}']
    function Present(pSourceRect, pDestRect: PRect; hDestWindowOverride: HWND; pDirtyRegion: PRgnData; dwFlags: DWORD): HResult; stdcall;
    function GetFrontBufferData(pDestSurface: IDirect3DSurface9): HResult; stdcall;
    function GetBackBuffer(iBackBuffer: LongWord; _Type: TD3DBackBufferType; out ppBackBuffer: IDirect3DSurface9): HResult; stdcall;
    function GetRasterStatus(out pRasterStatus: TD3DRasterStatus): HResult; stdcall;
    function GetDisplayMode(out pMode: TD3DDisplayMode): HResult; stdcall;
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function GetPresentParameters(out pPresentationParameters: TD3DPresentParameters): HResult; stdcall;
  end;

  IDirect3DBaseTexture9 = interface(IDirect3DResource9)
    ['{580CA87E-1D3C-4d54-991D-B7D3E3C298CE}']
    function SetLOD(LODNew: DWord): DWord; stdcall;
    function GetLOD: DWord; stdcall;
    function GetLevelCount: DWord; stdcall;
    function SetAutoGenFilterType(FilterType: TD3DTextureFilterType): HResult; stdcall;
    function GetAutoGenFilterType: TD3DTextureFilterType; stdcall;
    procedure GenerateMipSubLevels; stdcall;
  end;

  IDirect3DTexture9 = interface(IDirect3DBaseTexture9)
    ['{85C31227-3DE5-4f00-9B3A-F11AC38C18B5}']
    function GetLevelDesc(Level: LongWord; out pDesc: TD3DSurfaceDesc): HResult; stdcall;
    function GetSurfaceLevel(Level: LongWord; out ppSurfaceLevel: IDirect3DSurface9): HResult; stdcall;
    function LockRect(Level: LongWord; out pLockedRect: TD3DLockedRect; pRect: PRect; Flags: DWord): HResult; stdcall;
    function UnlockRect(Level: LongWord): HResult; stdcall;
    function AddDirtyRect(pDirtyRect: PRect): HResult; stdcall;
  end;

  IDirect3DVolumeTexture9 = interface(IDirect3DBaseTexture9)
    ['{2518526C-E789-4111-A7B9-47EF328D13E6}']
    function GetLevelDesc(Level: LongWord; out pDesc: TD3DVolumeDesc): HResult; stdcall;
    function GetVolumeLevel(Level: LongWord; out ppVolumeLevel: IDirect3DVolume9): HResult; stdcall;
    function LockBox(Level: LongWord; out pLockedVolume: TD3DLockedBox; pBox: PD3DBox; Flags: DWord): HResult; stdcall;
    function UnlockBox(Level: LongWord): HResult; stdcall;
    function AddDirtyBox(pDirtyBox: PD3DBox): HResult; stdcall;
  end;

  IDirect3DCubeTexture9 = interface(IDirect3DBaseTexture9)
    ['{FFF32F81-D953-473a-9223-93D652ABA93F}']
    function GetLevelDesc(Level: LongWord; out pDesc: TD3DSurfaceDesc): HResult; stdcall;
    function GetCubeMapSurface(FaceType: TD3DCubeMapFaces; Level: LongWord; out ppCubeMapSurface: IDirect3DSurface9): HResult; stdcall;
    function LockRect(FaceType: TD3DCubeMapFaces; Level: LongWord; out pLockedRect: TD3DLockedRect; pRect: PRect; Flags: DWord): HResult; stdcall;
    function UnlockRect(FaceType: TD3DCubeMapFaces; Level: LongWord): HResult; stdcall;
    function AddDirtyRect(FaceType: TD3DCubeMapFaces; pDirtyRect: PRect): HResult; stdcall;
  end;

  IDirect3DVertexBuffer9 = interface(IDirect3DResource9)
    ['{B64BB1B5-FD70-4df6-BF91-19D0A12455E3}']
    function Lock(OffsetToLock, SizeToLock: LongWord; out ppbData: Pointer; Flags: DWord): HResult; stdcall;
    function Unlock: HResult; stdcall;
    function GetDesc(out pDesc: TD3DVertexBufferDesc): HResult; stdcall;
  end;

  IDirect3DIndexBuffer9 = interface(IDirect3DResource9)
    ['{7C9DD65E-D3F7-4529-ACEE-785830ACDE35}']
    function Lock(OffsetToLock, SizeToLock: DWord; out ppbData: Pointer; Flags: DWord): HResult; stdcall;
    function Unlock: HResult; stdcall;
    function GetDesc(out pDesc: TD3DIndexBufferDesc): HResult; stdcall;
  end;

  IDirect3DStateBlock9 = interface(IUnknown)
    ['{B07C4FE5-310D-4ba8-A23C-4F0F206F218B}']
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function Capture: HResult; stdcall;
    function Apply: HResult; stdcall;
  end;

  IDirect3DVertexDeclaration9 = interface(IUnknown)
    ['{DD13C59C-36FA-4098-A8FB-C7ED39DC8546}']
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function GetDeclaration(pElement: PD3DVertexElement9; out pNumElements: LongWord): HResult; stdcall;
  end;

  IDirect3DVertexShader9 = interface(IUnknown)
    ['{EFC5557E-6265-4613-8A94-43857889EB36}']
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function GetFunction(pData: Pointer; out pSizeOfData: LongWord): HResult; stdcall;
  end;

  IDirect3DPixelShader9 = interface(IUnknown)
    ['{6D3BDBDC-5B02-4415-B852-CE5E8BCCB289}']
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function GetFunction(pData: Pointer; out pSizeOfData: LongWord): HResult; stdcall;
  end;

  IDirect3DQuery9 = interface(IUnknown)
    ['{d9771460-a695-4f26-bbd3-27b840b541cc}']
    function GetDevice(out ppDevice: IDirect3DDevice9): HResult; stdcall;
    function GetType: TD3DQueryType; stdcall;
    function GetDataSize: DWORD; stdcall;
    function Issue(dwIssueFlags: DWORD): HResult; stdcall;
    function GetData(pData: Pointer; dwSize: DWORD; dwGetDataFlags: DWORD): HResult; stdcall;
  end;

  function Direct3DCreate9(const SDKVersion: LongWord): IDirect3D9; stdcall;

  function D3DFVF_TEXCOORDSIZE3(const CoordIndex: DWord): DWord; inline;
  function D3DFVF_TEXCOORDSIZE2(const CoordIndex: DWord): DWord; inline;
  function D3DFVF_TEXCOORDSIZE4(const CoordIndex: DWord): DWord; inline;
  function D3DFVF_TEXCOORDSIZE1(const CoordIndex: DWord): DWord; inline;
  function D3DTS_WORLDMATRIX(const Index: Byte): TD3DTransformStateType; inline;
  function D3DVertexElement(
    Offset: Word;
    _Type: TD3DDeclType;
    Usage: TD3DDeclUsage;
    UsageIndex: Byte = 0;
    Stream: Word = 0;
    Method: TD3DDeclMethod = D3DDECLMETHOD_DEFAULT
  ): TD3DVertexElement9; inline;

implementation

function _Direct3DCreate9(SDKVersion: LongWord): Pointer; stdcall external Direct3D9dll name 'Direct3DCreate9';

function Direct3DCreate9(const SDKVersion: LongWord): IDirect3D9; stdcall;
begin
  Result := IDirect3D9(_Direct3DCreate9(SDKVersion));
  if Assigned(Result) then Result._Release;
end;

function D3DFVF_TEXCOORDSIZE3(const CoordIndex: DWord): DWord;
begin
  Result := D3DFVF_TEXTUREFORMAT3 shl (CoordIndex * 2 + 16);
end;

{$Hints off}
function D3DFVF_TEXCOORDSIZE2(const CoordIndex: DWord): DWord;
begin
  Result := D3DFVF_TEXTUREFORMAT2;
end;
{$Hints on}

function D3DFVF_TEXCOORDSIZE4(const CoordIndex: DWord): DWord;
begin
  Result := D3DFVF_TEXTUREFORMAT4 shl (CoordIndex * 2 + 16);
end;

function D3DFVF_TEXCOORDSIZE1(const CoordIndex: DWord): DWord;
begin
  Result := D3DFVF_TEXTUREFORMAT1 shl (CoordIndex * 2 + 16);
end;

function D3DTS_WORLDMATRIX(const Index: Byte): TD3DTransformStateType;
begin
  Result := TD3DTransformStateType(Index + 256);
end;

function D3DVertexElement(
  Offset: Word;
  _Type: TD3DDeclType;
  Usage: TD3DDeclUsage;
  UsageIndex: Byte = 0;
  Stream: Word = 0;
  Method: TD3DDeclMethod = D3DDECLMETHOD_DEFAULT
): TD3DVertexElement9;
begin
  Result.Stream := Stream;
  Result.Offset := Offset;
  Result._Type := _Type;
  Result.Method := Method;
  Result.Usage := Usage;
  Result.UsageIndex := UsageIndex;
end;

end.
