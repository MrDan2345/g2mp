{
     File:       QuickTime/ImageCompression.h
 
     Contains:   QuickTime Image Compression Interfaces.
 
     Version:    QuickTime 7.7.1
 
     Copyright:  � 1990-2012 by Apple Inc., all rights reserved
 
     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:
 
                     http://www.freepascal.org/bugs.html
 
}
{  Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
{  Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2012 }
{
    Modified for use with Free Pascal
    Version 308
    Please report any bugs to <gpc@microbizz.nl>
}

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}
{$mode macpas}
{$packenum 1}
{$macro on}
{$inline on}
{$calling mwpascal}

unit ImageCompression;
interface
{$setc UNIVERSAL_INTERFACES_VERSION := $0400}
{$setc GAP_INTERFACES_VERSION := $0308}

{$ifc not defined USE_CFSTR_CONSTANT_MACROS}
    {$setc USE_CFSTR_CONSTANT_MACROS := TRUE}
{$endc}

{$ifc defined CPUPOWERPC and defined CPUI386}
	{$error Conflicting initial definitions for CPUPOWERPC and CPUI386}
{$endc}
{$ifc defined FPC_BIG_ENDIAN and defined FPC_LITTLE_ENDIAN}
	{$error Conflicting initial definitions for FPC_BIG_ENDIAN and FPC_LITTLE_ENDIAN}
{$endc}

{$ifc not defined __ppc__ and defined CPUPOWERPC32}
	{$setc __ppc__ := 1}
{$elsec}
	{$setc __ppc__ := 0}
{$endc}
{$ifc not defined __ppc64__ and defined CPUPOWERPC64}
	{$setc __ppc64__ := 1}
{$elsec}
	{$setc __ppc64__ := 0}
{$endc}
{$ifc not defined __i386__ and defined CPUI386}
	{$setc __i386__ := 1}
{$elsec}
	{$setc __i386__ := 0}
{$endc}
{$ifc not defined __x86_64__ and defined CPUX86_64}
	{$setc __x86_64__ := 1}
{$elsec}
	{$setc __x86_64__ := 0}
{$endc}
{$ifc not defined __arm__ and defined CPUARM}
	{$setc __arm__ := 1}
{$elsec}
	{$setc __arm__ := 0}
{$endc}

{$ifc defined cpu64}
  {$setc __LP64__ := 1}
{$elsec}
  {$setc __LP64__ := 0}
{$endc}


{$ifc defined __ppc__ and __ppc__ and defined __i386__ and __i386__}
	{$error Conflicting definitions for __ppc__ and __i386__}
{$endc}

{$ifc defined __ppc__ and __ppc__}
	{$setc TARGET_CPU_PPC := TRUE}
	{$setc TARGET_CPU_PPC64 := FALSE}
	{$setc TARGET_CPU_X86 := FALSE}
	{$setc TARGET_CPU_X86_64 := FALSE}
	{$setc TARGET_CPU_ARM := FALSE}
	{$setc TARGET_OS_MAC := TRUE}
	{$setc TARGET_OS_IPHONE := FALSE}
	{$setc TARGET_IPHONE_SIMULATOR := FALSE}
	{$setc TARGET_OS_EMBEDDED := FALSE}
{$elifc defined __ppc64__ and __ppc64__}
	{$setc TARGET_CPU_PPC := FALSE}
	{$setc TARGET_CPU_PPC64 := TRUE}
	{$setc TARGET_CPU_X86 := FALSE}
	{$setc TARGET_CPU_X86_64 := FALSE}
	{$setc TARGET_CPU_ARM := FALSE}
	{$setc TARGET_OS_MAC := TRUE}
	{$setc TARGET_OS_IPHONE := FALSE}
	{$setc TARGET_IPHONE_SIMULATOR := FALSE}
	{$setc TARGET_OS_EMBEDDED := FALSE}
{$elifc defined __i386__ and __i386__}
	{$setc TARGET_CPU_PPC := FALSE}
	{$setc TARGET_CPU_PPC64 := FALSE}
	{$setc TARGET_CPU_X86 := TRUE}
	{$setc TARGET_CPU_X86_64 := FALSE}
	{$setc TARGET_CPU_ARM := FALSE}
{$ifc defined(iphonesim)}
 	{$setc TARGET_OS_MAC := FALSE}
	{$setc TARGET_OS_IPHONE := TRUE}
	{$setc TARGET_IPHONE_SIMULATOR := TRUE}
{$elsec}
	{$setc TARGET_OS_MAC := TRUE}
	{$setc TARGET_OS_IPHONE := FALSE}
	{$setc TARGET_IPHONE_SIMULATOR := FALSE}
{$endc}
	{$setc TARGET_OS_EMBEDDED := FALSE}
{$elifc defined __x86_64__ and __x86_64__}
	{$setc TARGET_CPU_PPC := FALSE}
	{$setc TARGET_CPU_PPC64 := FALSE}
	{$setc TARGET_CPU_X86 := FALSE}
	{$setc TARGET_CPU_X86_64 := TRUE}
	{$setc TARGET_CPU_ARM := FALSE}
	{$setc TARGET_OS_MAC := TRUE}
	{$setc TARGET_OS_IPHONE := FALSE}
	{$setc TARGET_IPHONE_SIMULATOR := FALSE}
	{$setc TARGET_OS_EMBEDDED := FALSE}
{$elifc defined __arm__ and __arm__}
	{$setc TARGET_CPU_PPC := FALSE}
	{$setc TARGET_CPU_PPC64 := FALSE}
	{$setc TARGET_CPU_X86 := FALSE}
	{$setc TARGET_CPU_X86_64 := FALSE}
	{$setc TARGET_CPU_ARM := TRUE}
	{ will require compiler define when/if other Apple devices with ARM cpus ship }
	{$setc TARGET_OS_MAC := FALSE}
	{$setc TARGET_OS_IPHONE := TRUE}
	{$setc TARGET_IPHONE_SIMULATOR := FALSE}
	{$setc TARGET_OS_EMBEDDED := TRUE}
{$elsec}
	{$error __ppc__ nor __ppc64__ nor __i386__ nor __x86_64__ nor __arm__ is defined.}
{$endc}

{$ifc defined __LP64__ and __LP64__ }
  {$setc TARGET_CPU_64 := TRUE}
{$elsec}
  {$setc TARGET_CPU_64 := FALSE}
{$endc}

{$ifc defined FPC_BIG_ENDIAN}
	{$setc TARGET_RT_BIG_ENDIAN := TRUE}
	{$setc TARGET_RT_LITTLE_ENDIAN := FALSE}
{$elifc defined FPC_LITTLE_ENDIAN}
	{$setc TARGET_RT_BIG_ENDIAN := FALSE}
	{$setc TARGET_RT_LITTLE_ENDIAN := TRUE}
{$elsec}
	{$error Neither FPC_BIG_ENDIAN nor FPC_LITTLE_ENDIAN are defined.}
{$endc}
{$setc ACCESSOR_CALLS_ARE_FUNCTIONS := TRUE}
{$setc CALL_NOT_IN_CARBON := FALSE}
{$setc OLDROUTINENAMES := FALSE}
{$setc OPAQUE_TOOLBOX_STRUCTS := TRUE}
{$setc OPAQUE_UPP_TYPES := TRUE}
{$setc OTCARBONAPPLICATION := TRUE}
{$setc OTKERNEL := FALSE}
{$setc PM_USE_SESSION_APIS := TRUE}
{$setc TARGET_API_MAC_CARBON := TRUE}
{$setc TARGET_API_MAC_OS8 := FALSE}
{$setc TARGET_API_MAC_OSX := TRUE}
{$setc TARGET_CARBON := TRUE}
{$setc TARGET_CPU_68K := FALSE}
{$setc TARGET_CPU_MIPS := FALSE}
{$setc TARGET_CPU_SPARC := FALSE}
{$setc TARGET_OS_UNIX := FALSE}
{$setc TARGET_OS_WIN32 := FALSE}
{$setc TARGET_RT_MAC_68881 := FALSE}
{$setc TARGET_RT_MAC_CFM := FALSE}
{$setc TARGET_RT_MAC_MACHO := TRUE}
{$setc TYPED_FUNCTION_POINTERS := TRUE}
{$setc TYPE_BOOL := FALSE}
{$setc TYPE_EXTENDED := FALSE}
{$setc TYPE_LONGLONG := TRUE}
uses MacTypes,Components,CGLTypes,ColorSyncDeprecated,CVBase,CVImageBuffer,CVPixelBuffer,CVPixelBufferPool,Files,Dialogs,OSUtils,QuickdrawTypes,QDOffscreen,CFBase,CFData,CFDictionary,CGContext,CGImage;
{$endc} {not MACOSALLINCLUDE}


{$ifc TARGET_OS_MAC}

{$ALIGN MAC68K}


type
	MatrixRecord = record
		matrix: array [0..2,0..2] of Fixed;
	end;
	MatrixRecordPtr = ^MatrixRecord;
const
	kRawCodecType = FourCharCode('raw ');
	kCinepakCodecType = FourCharCode('cvid');
	kGraphicsCodecType = FourCharCode('smc ');
	kAnimationCodecType = FourCharCode('rle ');
	kVideoCodecType = FourCharCode('rpza');
	kComponentVideoCodecType = FourCharCode('yuv2');
	kJPEGCodecType = FourCharCode('jpeg');
	kMotionJPEGACodecType = FourCharCode('mjpa');
	kMotionJPEGBCodecType = FourCharCode('mjpb');
	kSGICodecType = FourCharCode('.SGI');
	kPlanarRGBCodecType = FourCharCode('8BPS');
	kMacPaintCodecType = FourCharCode('PNTG');
	kGIFCodecType = FourCharCode('gif ');
	kPhotoCDCodecType = FourCharCode('kpcd');
	kQuickDrawGXCodecType = FourCharCode('qdgx');
	kAVRJPEGCodecType = FourCharCode('avr ');
	kOpenDMLJPEGCodecType = FourCharCode('dmb1');
	kBMPCodecType = FourCharCode('WRLE');
	kWindowsRawCodecType = FourCharCode('WRAW');
	kVectorCodecType = FourCharCode('path');
	kQuickDrawCodecType = FourCharCode('qdrw');
	kWaterRippleCodecType = FourCharCode('ripl');
	kFireCodecType = FourCharCode('fire');
	kCloudCodecType = FourCharCode('clou');
	kH261CodecType = FourCharCode('h261');
	kH263CodecType = FourCharCode('h263');
	kDVCNTSCCodecType = FourCharCode('dvc '); { DV - NTSC and DVCPRO NTSC (available in QuickTime 6.0 or later)}
                                        { NOTE: kDVCProNTSCCodecType is deprecated.  }
                                        { Use kDVCNTSCCodecType instead -- as far as the codecs are concerned, }
                                        { the two data formats are identical.}
	kDVCPALCodecType = FourCharCode('dvcp');
	kDVCProPALCodecType = FourCharCode('dvpp'); { available in QuickTime 6.0 or later}
	kDVCPro50NTSCCodecType = FourCharCode('dv5n');
	kDVCPro50PALCodecType = FourCharCode('dv5p');
	kDVCPROHD720p60CodecType = FourCharCode('dvhp');
	kDVCPROHD720p50CodecType = FourCharCode('dvhq');
	kDVCPROHD720pCodecType = kDVCPROHD720p60CodecType;
	kDVCPro100NTSCCodecType = FourCharCode('dv1n');
	kDVCPro100PALCodecType = FourCharCode('dv1p');
	kDVCPROHD1080i60CodecType = FourCharCode('dvh6');
	kDVCPROHD1080i50CodecType = FourCharCode('dvh5');
	kDVCPROHD1080p30CodecType = FourCharCode('dvh3');
	kDVCPROHD1080p25CodecType = FourCharCode('dvh2');
	kBaseCodecType = FourCharCode('base');
	kFLCCodecType = FourCharCode('flic');
	kTargaCodecType = FourCharCode('tga ');
	kPNGCodecType = FourCharCode('png ');
	kTIFFCodecType = FourCharCode('tiff'); { NOTE: despite what might seem obvious from the two constants}
                                        { below and their names, they really are correct. 'yuvu' really }
                                        { does mean signed, and 'yuvs' really does mean unsigned. Really. }
	kComponentVideoSigned = FourCharCode('yuvu');
	kComponentVideoUnsigned = FourCharCode('yuvs');
	kCMYKCodecType = FourCharCode('cmyk');
	kMicrosoftVideo1CodecType = FourCharCode('msvc');
	kSorensonCodecType = FourCharCode('SVQ1');
	kSorenson3CodecType = FourCharCode('SVQ3'); { available in QuickTime 5 and later}
	kIndeo4CodecType = FourCharCode('IV41');
	kMPEG4VisualCodecType = FourCharCode('mp4v');
	k64ARGBCodecType = FourCharCode('b64a');
	k48RGBCodecType = FourCharCode('b48r');
	k32AlphaGrayCodecType = FourCharCode('b32a');
	k16GrayCodecType = FourCharCode('b16g');
	kMpegYUV420CodecType = FourCharCode('myuv');
	kYUV420CodecType = FourCharCode('y420');
	kSorensonYUV9CodecType = FourCharCode('syv9');
	k422YpCbCr8CodecType = FourCharCode('2vuy'); { Component Y'CbCr 8-bit 4:2:2  }
	k444YpCbCr8CodecType = FourCharCode('v308'); { Component Y'CbCr 8-bit 4:4:4  }
	k4444YpCbCrA8CodecType = FourCharCode('v408'); { Component Y'CbCrA 8-bit 4:4:4:4 }
	k422YpCbCr16CodecType = FourCharCode('v216'); { Component Y'CbCr 10,12,14,16-bit 4:2:2}
	k422YpCbCr10CodecType = FourCharCode('v210'); { Component Y'CbCr 10-bit 4:2:2 }
	k444YpCbCr10CodecType = FourCharCode('v410'); { Component Y'CbCr 10-bit 4:4:4 }
	k4444YpCbCrA8RCodecType = FourCharCode('r408'); { Component Y'CbCrA 8-bit 4:4:4:4, rendering format. full range alpha, zero biased yuv}
	kJPEG2000CodecType = FourCharCode('mjp2');
	kPixletCodecType = FourCharCode('pxlt');
	kH264CodecType = FourCharCode('avc1');


{$ifc not TARGET_CPU_64}

{ one source effects }
const
	kBlurImageFilterType = FourCharCode('blur');
	kSharpenImageFilterType = FourCharCode('shrp');
	kEdgeDetectImageFilterType = FourCharCode('edge');
	kEmbossImageFilterType = FourCharCode('embs');
	kConvolveImageFilterType = FourCharCode('genk');
	kAlphaGainImageFilterType = FourCharCode('gain');
	kRGBColorBalanceImageFilterType = FourCharCode('rgbb');
	kHSLColorBalanceImageFilterType = FourCharCode('hslb');
	kColorSyncImageFilterType = FourCharCode('sync');
	kFilmNoiseImageFilterType = FourCharCode('fmns');
	kSolarizeImageFilterType = FourCharCode('solr');
	kColorTintImageFilterType = FourCharCode('tint');
	kLensFlareImageFilterType = FourCharCode('lens');
	kBrightnessContrastImageFilterType = FourCharCode('brco');

{ two source effects }
const
	kAlphaCompositorTransitionType = FourCharCode('blnd');
	kCrossFadeTransitionType = FourCharCode('dslv');
	kChannelCompositeEffectType = FourCharCode('chan');
	kChromaKeyTransitionType = FourCharCode('ckey');
	kImplodeTransitionType = FourCharCode('mplo');
	kExplodeTransitionType = FourCharCode('xplo');
	kGradientTransitionType = FourCharCode('matt');
	kPushTransitionType = FourCharCode('push');
	kSlideTransitionType = FourCharCode('slid');
	kWipeTransitionType = FourCharCode('smpt');
	kIrisTransitionType = FourCharCode('smp2');
	kRadialTransitionType = FourCharCode('smp3');
	kMatrixTransitionType = FourCharCode('smp4');
	kZoomTransitionType = FourCharCode('zoom');

{ three source effects }
const
	kTravellingMatteEffectType = FourCharCode('trav');


{ Supported by QTNewGWorld in QuickTime 4.0 and later }
const
	kCMYKPixelFormat = FourCharCode('cmyk'); { CMYK, 8-bit }
	k64ARGBPixelFormat = FourCharCode('b64a'); { ARGB, 16-bit big-endian samples }
	k48RGBPixelFormat = FourCharCode('b48r'); { RGB, 16-bit big-endian samples }
	k32AlphaGrayPixelFormat = FourCharCode('b32a'); { AlphaGray, 16-bit big-endian samples }
	k16GrayPixelFormat = FourCharCode('b16g'); { Grayscale, 16-bit big-endian samples }
	k422YpCbCr8PixelFormat = FourCharCode('2vuy'); { Component Y'CbCr 8-bit 4:2:2, ordered Cb Y'0 Cr Y'1 }

{ Supported by QTNewGWorld in QuickTime 4.1.2 and later }
const
	k4444YpCbCrA8PixelFormat = FourCharCode('v408'); { Component Y'CbCrA 8-bit 4:4:4:4, ordered Cb Y' Cr A }
	k4444YpCbCrA8RPixelFormat = FourCharCode('r408'); { Component Y'CbCrA 8-bit 4:4:4:4, rendering format. full range alpha, zero biased yuv, ordered A Y' Cb Cr }

{ Supported by QTNewGWorld in QuickTime 6.0 and later }
const
	kYUV420PixelFormat = FourCharCode('y420'); { Planar Component Y'CbCr 8-bit 4:2:0.  PixMap baseAddr points to a big-endian PlanarPixmapInfoYUV420 struct; see ImageCodec.i. }


{ These are the bits that are set in the Component flags, and also in the codecInfo struct. }
const
	codecInfoDoes1 = 1 shl 0; { codec can work with 1-bit pixels }
	codecInfoDoes2 = 1 shl 1; { codec can work with 2-bit pixels }
	codecInfoDoes4 = 1 shl 2; { codec can work with 4-bit pixels }
	codecInfoDoes8 = 1 shl 3; { codec can work with 8-bit pixels }
	codecInfoDoes16 = 1 shl 4; { codec can work with 16-bit pixels }
	codecInfoDoes32 = 1 shl 5; { codec can work with 32-bit pixels }
	codecInfoDoesDither = 1 shl 6; { codec can do ditherMode }
	codecInfoDoesStretch = 1 shl 7; { codec can stretch to arbitrary sizes }
	codecInfoDoesShrink = 1 shl 8; { codec can shrink to arbitrary sizes }
	codecInfoDoesMask = 1 shl 9; { codec can mask to clipping regions }
	codecInfoDoesTemporal = 1 shl 10; { codec can handle temporal redundancy }
	codecInfoDoesDouble = 1 shl 11; { codec can stretch to double size exactly }
	codecInfoDoesQuad = 1 shl 12; { codec can stretch to quadruple size exactly }
	codecInfoDoesHalf = 1 shl 13; { codec can shrink to half size }
	codecInfoDoesQuarter = 1 shl 14; { codec can shrink to quarter size }
	codecInfoDoesRotate = 1 shl 15; { codec can rotate on decompress }
	codecInfoDoesHorizFlip = 1 shl 16; { codec can flip horizontally on decompress }
	codecInfoDoesVertFlip = 1 shl 17; { codec can flip vertically on decompress }
	codecInfoHasEffectParameterList = 1 shl 18; { codec implements get effects parameter list call, once was codecInfoDoesSkew }
	codecInfoDoesBlend = 1 shl 19; { codec can blend on decompress }
	codecInfoDoesReorder = 1 shl 19; { codec can rearrange frames during compression }
	codecInfoDoesWarp = 1 shl 20; { codec can warp arbitrarily on decompress }
	codecInfoDoesMultiPass = 1 shl 20; { codec can perform multi-pass compression }
	codecInfoDoesRecompress = 1 shl 21; { codec can recompress image without accumulating errors }
	codecInfoDoesSpool = 1 shl 22; { codec can spool image data }
	codecInfoDoesRateConstrain = 1 shl 23; { codec can data rate constrain }


const
	codecInfoDepth1 = 1 shl 0; { compressed data at 1 bpp depth available }
	codecInfoDepth2 = 1 shl 1; { compressed data at 2 bpp depth available }
	codecInfoDepth4 = 1 shl 2; { compressed data at 4 bpp depth available }
	codecInfoDepth8 = 1 shl 3; { compressed data at 8 bpp depth available }
	codecInfoDepth16 = 1 shl 4; { compressed data at 16 bpp depth available }
	codecInfoDepth32 = 1 shl 5; { compressed data at 32 bpp depth available }
	codecInfoDepth24 = 1 shl 6; { compressed data at 24 bpp depth available }
	codecInfoDepth33 = 1 shl 7; { compressed data at 1 bpp monochrome depth  available }
	codecInfoDepth34 = 1 shl 8; { compressed data at 2 bpp grayscale depth available }
	codecInfoDepth36 = 1 shl 9; { compressed data at 4 bpp grayscale depth available }
	codecInfoDepth40 = 1 shl 10; { compressed data at 8 bpp grayscale depth available }
	codecInfoStoresClut = 1 shl 11; { compressed data can have custom cluts }
	codecInfoDoesLossless = 1 shl 12; { compressed data can be stored in lossless format }
	codecInfoSequenceSensitive = 1 shl 13; { compressed data is sensitive to out of sequence decoding }


{ input sequence flags}
const
	codecFlagUseImageBuffer = 1 shl 0; { decompress}
	codecFlagUseScreenBuffer = 1 shl 1; { decompress}
	codecFlagUpdatePrevious = 1 shl 2; { compress}
	codecFlagNoScreenUpdate = 1 shl 3; { decompress}
	codecFlagWasCompressed = 1 shl 4; { compress}
	codecFlagDontOffscreen = 1 shl 5; { decompress}
	codecFlagUpdatePreviousComp = 1 shl 6; { compress}
	codecFlagForceKeyFrame = 1 shl 7; { compress}
	codecFlagOnlyScreenUpdate = 1 shl 8; { decompress}
	codecFlagLiveGrab = 1 shl 9; { compress}
	codecFlagDiffFrame = 1 shl 9; { decompress}
	codecFlagDontUseNewImageBuffer = 1 shl 10; { decompress}
	codecFlagInterlaceUpdate = 1 shl 11; { decompress}
	codecFlagCatchUpDiff = 1 shl 12; { decompress}
	codecFlagSupportDisable = 1 shl 13; { decompress}
	codecFlagReenable = 1 shl 14; { decompress}


{ output sequence flags}
const
	codecFlagOutUpdateOnNextIdle = 1 shl 9;
	codecFlagOutUpdateOnDataSourceChange = 1 shl 10;
	codecFlagSequenceSensitive = 1 shl 11;
	codecFlagOutUpdateOnTimeChange = 1 shl 12;
	codecFlagImageBufferNotSourceImage = 1 shl 13;
	codecFlagUsedNewImageBuffer = 1 shl 14;
	codecFlagUsedImageBuffer = 1 shl 15;


const
{ The minimum data size for spooling in or out data }
	codecMinimumDataSize = 32768;


const
	compressorComponentType = FourCharCode('imco'); { the type for "Components" which compress images }
	decompressorComponentType = FourCharCode('imdc'); { the type for "Components" which decompress images }

type
	CompressorComponent = Component;
	DecompressorComponent = Component;
	CodecComponent = Component;

const
	anyCodec = 0;							{  take first working codec of given type  }
	bestSpeedCodec = -1;							{  take fastest codec of given type  }
	bestFidelityCodec = -2;							{  take codec which is most accurate  }
	bestCompressionCodec = -3;							{  take codec of given type that is most accurate  }

{$endc} {not TARGET_CPU_64}

type
	CodecType = OSType;
	CodecType_fix = CodecType; { used as field type when a record declaration contains a CodecType field identifier }
	CodecFlags = UInt16;
	CodecQ = UInt32;

{$ifc not TARGET_CPU_64}

const
	codecLosslessQuality = $00000400;
	codecMaxQuality = $000003FF;
	codecMinQuality = $00000000;
	codecLowQuality = $00000100;
	codecNormalQuality = $00000200;
	codecHighQuality = $00000300;

const
	codecLockBitsShieldCursor = 1 shl 0; { shield cursor }

const
	codecCompletionSource = 1 shl 0; { asynchronous codec is done with source data }
	codecCompletionDest = 1 shl 1; { asynchronous codec is done with destination data }
	codecCompletionDontUnshield = 1 shl 2; { on dest complete don't unshield cursor }
	codecCompletionWentOffscreen = 1 shl 3; { codec used offscreen buffer }
	codecCompletionUnlockBits = 1 shl 4; { on dest complete, call ICMSequenceUnlockBits }
	codecCompletionForceChainFlush = 1 shl 5; { ICM needs to flush the whole chain }
	codecCompletionDropped = 1 shl 6; { codec decided to drop this frame }
	codecCompletionDecoded = 1 shl 10; { codec has decoded this frame; if it is cancelled and rescheduled, set icmFrameAlreadyDecoded in ICMFrameTimeRecord.flags }
	codecCompletionNotDisplayable = 1 shl 11; { the frame may still be scheduled for decode, but will not be able to be displayed because the buffer containing it will need to be recycled to display earlier frames. }
	codecCompletionNotDrawn = 1 shl 12; { set in conjunction with codecCompletionDest to indicate that the frame was not drawn }

const
	codecProgressOpen = 0;
	codecProgressUpdatePercent = 1;
	codecProgressClose = 2;

type
	ICMDataProcPtr = function( var dataP: Ptr; bytesNeeded: SIGNEDLONG; refcon: SIGNEDLONG ): OSErr;
	ICMFlushProcPtr = function( data: Ptr; bytesAdded: SIGNEDLONG; refcon: SIGNEDLONG ): OSErr;
	ICMCompletionProcPtr = procedure( result: OSErr; flags: SInt16; refcon: SIGNEDLONG );
	ICMProgressProcPtr = function( message: SInt16; completeness: Fixed; refcon: SIGNEDLONG ): OSErr;
	StdPixProcPtr = procedure( var src: PixMap; var srcRect: Rect; var matrix: MatrixRecord; mode: SInt16; mask: RgnHandle; var matte: PixMap; var matteRect: Rect; flags: SInt16 );
	QDPixProcPtr = procedure( var src: PixMap; var srcRect: Rect; var matrix: MatrixRecord; mode: SInt16; mask: RgnHandle; var matte: PixMap; var matteRect: Rect; flags: SInt16 );
	ICMAlignmentProcPtr = procedure( var rp: Rect; refcon: SIGNEDLONG );
	ICMCursorShieldedProcPtr = procedure( const (*var*) r: Rect; refcon: UnivPtr; flags: SIGNEDLONG );
	ICMMemoryDisposedProcPtr = procedure( memoryBlock: Ptr; refcon: UnivPtr );
	ICMCursorNotify = UnivPtr;
	ICMConvertDataFormatProcPtr = function( refCon: UnivPtr; flags: SIGNEDLONG; desiredFormat: Handle; sourceDataFormat: Handle; srcData: UnivPtr; srcDataSize: SIGNEDLONG; var dstData: UnivPtr; var dstDataSize: SIGNEDLONG ): OSErr;


	ICMDataUPP = ICMDataProcPtr;
	ICMFlushUPP = ICMFlushProcPtr;
	ICMCompletionUPP = ICMCompletionProcPtr;
	ICMProgressUPP = ICMProgressProcPtr;
	StdPixUPP = StdPixProcPtr;
	QDPixUPP = QDPixProcPtr;
	ICMAlignmentUPP = ICMAlignmentProcPtr;
	ICMCursorShieldedUPP = ICMCursorShieldedProcPtr;
	ICMMemoryDisposedUPP = ICMMemoryDisposedProcPtr;
	ICMConvertDataFormatUPP = ICMConvertDataFormatProcPtr;
	ImageSequence = SIGNEDLONG;
	ImageSequenceDataSource = SIGNEDLONG;
	ImageTranscodeSequence = SIGNEDLONG;
	ImageFieldSequence = SIGNEDLONG;
	ICMProgressProcRecord = record
		progressProc: ICMProgressUPP;
		progressRefCon: SIGNEDLONG;
	end;
	ICMProgressProcRecordPtr = ^ICMProgressProcRecord;
type
	ICMCompletionProcRecord = record
		completionProc: ICMCompletionUPP;
		completionRefCon: SIGNEDLONG;
	end;
	ICMCompletionProcRecordPtr = ^ICMCompletionProcRecord;
type
	ICMDataProcRecord = record
		dataProc: ICMDataUPP;
		dataRefCon: SIGNEDLONG;
	end;
	ICMDataProcRecordPtr = ^ICMDataProcRecord;
type
	ICMFlushProcRecord = record
		flushProc: ICMFlushUPP;
		flushRefCon: SIGNEDLONG;
	end;
	ICMFlushProcRecordPtr = ^ICMFlushProcRecord;
type
	ICMAlignmentProcRecord = record
		alignmentProc: ICMAlignmentUPP;
		alignmentRefCon: SIGNEDLONG;
	end;
	ICMAlignmentProcRecordPtr = ^ICMAlignmentProcRecord;
type
	DataRateParams = record
		dataRate: SIGNEDLONG;
		dataOverrun: SIGNEDLONG;
		frameDuration: SIGNEDLONG;
		keyFrameRate: SIGNEDLONG;
		minSpatialQuality: CodecQ;
		minTemporalQuality: CodecQ;
	end;
	DataRateParamsPtr = ^DataRateParams;

{$endc} {not TARGET_CPU_64}

type
	ImageDescription = packed record
		idSize: SInt32;                 { total size of ImageDescription including extra data ( CLUTs and other per sequence data ) }
		cType: CodecType;                  { what kind of codec compressed this data }
		resvd1: SInt32;                 { reserved for Apple use }
		resvd2: SInt16;                 { reserved for Apple use }
		dataRefIndex: SInt16;           { set to zero  }
		version: SInt16;                { which version is this data }
		revisionLevel: SInt16;          { what version of that codec did this }
		vendor: SInt32;                 { whose  codec compressed this data }
		temporalQuality: CodecQ;        { what was the temporal quality factor  }
		spatialQuality: CodecQ;         { what was the spatial quality factor }
		width: SInt16;                  { how many pixels wide is this data }
		height: SInt16;                 { how many pixels high is this data }
		hRes: Fixed;                   { horizontal resolution }
		vRes: Fixed;                   { vertical resolution }
		dataSize: SInt32;               { if known, the size of data for this image descriptor }
		frameCount: SInt16;             { number of frames this description applies to }
		name: Str31;                   { name of codec ( in case not installed )  }
		depth: SInt16;                  { what depth is this data (1-32) or ( 33-40 grayscale ) }
		clutID: SInt16;                 { clut id or if 0 clut follows  or -1 if no clut }
	end;
	ImageDescriptionPtr = ^ImageDescription;
type
	ImageDescriptionHandle = ^ImageDescriptionPtr;

{$ifc not TARGET_CPU_64}


type
	CodecInfoPtr = ^CodecInfo;
	CodecInfo = record
		typeName: Str31;               { name of the codec type i.e.: 'Apple Image Compression' }
		version: SInt16;                { version of the codec data that this codec knows about }
		revisionLevel: SInt16;          { revision level of this codec i.e: 0x00010001 (1.0.1) }
		vendor: SIGNEDLONG;                 { Maker of this codec i.e: 'appl' }
		decompressFlags: SIGNEDLONG;        { codecInfo flags for decompression capabilities }
		compressFlags: SIGNEDLONG;          { codecInfo flags for compression capabilities }
		formatFlags: SIGNEDLONG;            { codecInfo flags for compression format details }
		compressionAccuracy: UInt8;    { measure (1-255) of accuracy of this codec for compress (0 if unknown) }
		decompressionAccuracy: UInt8;  { measure (1-255) of accuracy of this codec for decompress (0 if unknown) }
		compressionSpeed: UInt16;       { ( millisecs for compressing 320x240 on base mac II) (0 if unknown)  }
		decompressionSpeed: UInt16;     { ( millisecs for decompressing 320x240 on mac II)(0 if unknown)  }
		compressionLevel: UInt8;       { measure (1-255) of compression level of this codec (0 if unknown)  }
		resvd: UInt8;                  { pad }
		minimumHeight: SInt16;          { minimum height of image (block size) }
		minimumWidth: SInt16;           { minimum width of image (block size) }
		decompressPipelineLatency: SInt16; { in milliseconds ( for asynchronous codecs ) }
		compressPipelineLatency: SInt16; { in milliseconds ( for asynchronous codecs ) }
		privateData: SIGNEDLONG;
	end;
type
	CodecNameSpecPtr = ^CodecNameSpec;
	CodecNameSpec = record
		codec: CodecComponent;
		cType: CodecType;
		typeName: Str31;
		name: Handle;
	end;
type
	CodecNameSpecList = record
		count: SInt16;
		list: array [0..0] of CodecNameSpec;
	end;
	CodecNameSpecListPtr = ^CodecNameSpecList;
const
	defaultDither = 0;
	forceDither = 1;
	suppressDither = 2;
	useColorMatching = 4;

const
	callStdBits = 1;
	callOldBits = 2;
	noDefaultOpcodes = 4;

const
	graphicsModeStraightAlpha = 256;
	graphicsModePreWhiteAlpha = 257;
	graphicsModePreBlackAlpha = 258;
	graphicsModeComposition = 259;
	graphicsModeStraightAlphaBlend = 260;
	graphicsModePreMulColorAlpha = 261;
	graphicsModePerComponentAlpha = 272;

const
	evenField1ToEvenFieldOut = 1 shl 0;
	evenField1ToOddFieldOut = 1 shl 1;
	oddField1ToEvenFieldOut = 1 shl 2;
	oddField1ToOddFieldOut = 1 shl 3;
	evenField2ToEvenFieldOut = 1 shl 4;
	evenField2ToOddFieldOut = 1 shl 5;
	oddField2ToEvenFieldOut = 1 shl 6;
	oddField2ToOddFieldOut = 1 shl 7;

{ Flags for ICMFrameTimeRecord.flags }
const
	icmFrameTimeHasVirtualStartTimeAndDuration = 1 shl 0;
	icmFrameAlreadyDecoded = 1 shl 1;
	icmFrameTimeIsNonScheduledDisplayTime = 1 shl 2;
	icmFrameTimeHasDecodeTime = 1 shl 3;
	icmFrameTimeDecodeImmediately = 1 shl 4;
	icmFrameTimeDoNotDisplay = 1 shl 5;

type
	ICMFrameTimeRecordPtr = ^ICMFrameTimeRecord;
	ICMFrameTimeRecord = record
		value: wide;                  { frame display time}
		scale: SIGNEDLONG;                  { timescale of value/duration fields}
		base: UnivPtr;                   { timebase}

		duration: SIGNEDLONG;               { duration frame is to be displayed (0 if unknown)}
		rate: Fixed;                   { rate of timebase relative to wall-time}

		recordSize: SIGNEDLONG;             { total number of bytes in ICMFrameTimeRecord}

		frameNumber: SIGNEDLONG;            { number of frame, zero if not known}

		flags: SIGNEDLONG;

		virtualStartTime: wide;       { conceptual start time}
		virtualDuration: SIGNEDLONG;        { conceptual duration}

                                              { The following fields only exist for QuickTime 7.0 and greater. }
		decodeTime: TimeValue64;             { suggested decode time, if icmFrameTimeHasDecodeTime is set in flags}
	end;
type
	ICMFrameTimePtr = ICMFrameTimeRecordPtr;
{ QuickTime flavor of universally unique identifier (uuid)}
type
	QTUUIDPtr = ^QTUUID;
	QTUUID = record
		data1: UInt32;
		data2: UInt16;
		data3: UInt16;
    data4: array[0..7] of UInt8;
	end;
type
	QTMediaContextID = QTUUID;
	QTMediaContextIDPtr = ^QTMediaContextID;

{$endc} {not TARGET_CPU_64}

{ See Movies.h for the flags themselves. }
type
	MediaSampleFlags = UInt32;

{$ifc not TARGET_CPU_64}


{
 *  NewICMDataUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewICMDataUPP( userRoutine: ICMDataProcPtr ): ICMDataUPP; external name '_NewICMDataUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewICMFlushUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewICMFlushUPP( userRoutine: ICMFlushProcPtr ): ICMFlushUPP; external name '_NewICMFlushUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewICMCompletionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewICMCompletionUPP( userRoutine: ICMCompletionProcPtr ): ICMCompletionUPP; external name '_NewICMCompletionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewICMProgressUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewICMProgressUPP( userRoutine: ICMProgressProcPtr ): ICMProgressUPP; external name '_NewICMProgressUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewStdPixUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewStdPixUPP( userRoutine: StdPixProcPtr ): StdPixUPP; external name '_NewStdPixUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewQDPixUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewQDPixUPP( userRoutine: QDPixProcPtr ): QDPixUPP; external name '_NewQDPixUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewICMAlignmentUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewICMAlignmentUPP( userRoutine: ICMAlignmentProcPtr ): ICMAlignmentUPP; external name '_NewICMAlignmentUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewICMCursorShieldedUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewICMCursorShieldedUPP( userRoutine: ICMCursorShieldedProcPtr ): ICMCursorShieldedUPP; external name '_NewICMCursorShieldedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewICMMemoryDisposedUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewICMMemoryDisposedUPP( userRoutine: ICMMemoryDisposedProcPtr ): ICMMemoryDisposedUPP; external name '_NewICMMemoryDisposedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewICMConvertDataFormatUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewICMConvertDataFormatUPP( userRoutine: ICMConvertDataFormatProcPtr ): ICMConvertDataFormatUPP; external name '_NewICMConvertDataFormatUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeICMDataUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeICMDataUPP( userUPP: ICMDataUPP ); external name '_DisposeICMDataUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeICMFlushUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeICMFlushUPP( userUPP: ICMFlushUPP ); external name '_DisposeICMFlushUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeICMCompletionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeICMCompletionUPP( userUPP: ICMCompletionUPP ); external name '_DisposeICMCompletionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeICMProgressUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeICMProgressUPP( userUPP: ICMProgressUPP ); external name '_DisposeICMProgressUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeStdPixUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeStdPixUPP( userUPP: StdPixUPP ); external name '_DisposeStdPixUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeQDPixUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeQDPixUPP( userUPP: QDPixUPP ); external name '_DisposeQDPixUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeICMAlignmentUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeICMAlignmentUPP( userUPP: ICMAlignmentUPP ); external name '_DisposeICMAlignmentUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeICMCursorShieldedUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeICMCursorShieldedUPP( userUPP: ICMCursorShieldedUPP ); external name '_DisposeICMCursorShieldedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeICMMemoryDisposedUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeICMMemoryDisposedUPP( userUPP: ICMMemoryDisposedUPP ); external name '_DisposeICMMemoryDisposedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeICMConvertDataFormatUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeICMConvertDataFormatUPP( userUPP: ICMConvertDataFormatUPP ); external name '_DisposeICMConvertDataFormatUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeICMDataUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeICMDataUPP( var dataP: Ptr; bytesNeeded: SIGNEDLONG; refcon: SIGNEDLONG; userUPP: ICMDataUPP ): OSErr; external name '_InvokeICMDataUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeICMFlushUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeICMFlushUPP( data: Ptr; bytesAdded: SIGNEDLONG; refcon: SIGNEDLONG; userUPP: ICMFlushUPP ): OSErr; external name '_InvokeICMFlushUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeICMCompletionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeICMCompletionUPP( result: OSErr; flags: SInt16; refcon: SIGNEDLONG; userUPP: ICMCompletionUPP ); external name '_InvokeICMCompletionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeICMProgressUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeICMProgressUPP( message: SInt16; completeness: Fixed; refcon: SIGNEDLONG; userUPP: ICMProgressUPP ): OSErr; external name '_InvokeICMProgressUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeStdPixUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeStdPixUPP( var src: PixMap; var srcRect: Rect; var matrix: MatrixRecord; mode: SInt16; mask: RgnHandle; var matte: PixMap; var matteRect: Rect; flags: SInt16; userUPP: StdPixUPP ); external name '_InvokeStdPixUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeQDPixUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeQDPixUPP( var src: PixMap; var srcRect: Rect; var matrix: MatrixRecord; mode: SInt16; mask: RgnHandle; var matte: PixMap; var matteRect: Rect; flags: SInt16; userUPP: QDPixUPP ); external name '_InvokeQDPixUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeICMAlignmentUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeICMAlignmentUPP( var rp: Rect; refcon: SIGNEDLONG; userUPP: ICMAlignmentUPP ); external name '_InvokeICMAlignmentUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeICMCursorShieldedUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeICMCursorShieldedUPP( const (*var*) r: Rect; refcon: UnivPtr; flags: SIGNEDLONG; userUPP: ICMCursorShieldedUPP ); external name '_InvokeICMCursorShieldedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeICMMemoryDisposedUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeICMMemoryDisposedUPP( memoryBlock: Ptr; refcon: UnivPtr; userUPP: ICMMemoryDisposedUPP ); external name '_InvokeICMMemoryDisposedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeICMConvertDataFormatUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeICMConvertDataFormatUPP( refCon: UnivPtr; flags: SIGNEDLONG; desiredFormat: Handle; sourceDataFormat: Handle; srcData: UnivPtr; srcDataSize: SIGNEDLONG; var dstData: UnivPtr; var dstDataSize: SIGNEDLONG; userUPP: ICMConvertDataFormatUPP ): OSErr; external name '_InvokeICMConvertDataFormatUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CodecManagerVersion()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CodecManagerVersion( var version: SIGNEDLONG ): OSErr; external name '_CodecManagerVersion';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetCodecNameList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetCodecNameList( var list: CodecNameSpecListPtr; showAll: SInt16 ): OSErr; external name '_GetCodecNameList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeCodecNameList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DisposeCodecNameList( list: CodecNameSpecListPtr ): OSErr; external name '_DisposeCodecNameList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetCodecInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetCodecInfo( var info: CodecInfo; cType: CodecType; codec: CodecComponent ): OSErr; external name '_GetCodecInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMaxCompressionSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMaxCompressionSize( src: PixMapHandle; const (*var*) srcRect: Rect; colorDepth: SInt16; quality: CodecQ; cType: CodecType; codec: CompressorComponent; var size: SIGNEDLONG ): OSErr; external name '_GetMaxCompressionSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetCSequenceMaxCompressionSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetCSequenceMaxCompressionSize( seqID: ImageSequence; src: PixMapHandle; var size: SIGNEDLONG ): OSErr; external name '_GetCSequenceMaxCompressionSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetCompressionTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetCompressionTime( src: PixMapHandle; const (*var*) srcRect: Rect; colorDepth: SInt16; cType: CodecType; codec: CompressorComponent; var spatialQuality: CodecQ; var temporalQuality: CodecQ; var compressTime: UNSIGNEDLONG ): OSErr; external name '_GetCompressionTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompressImage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CompressImage( src: PixMapHandle; const (*var*) srcRect: Rect; quality: CodecQ; cType: CodecType; desc: ImageDescriptionHandle; data: Ptr ): OSErr; external name '_CompressImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FCompressImage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function FCompressImage( src: PixMapHandle; const (*var*) srcRect: Rect; colorDepth: SInt16; quality: CodecQ; cType: CodecType; codec: CompressorComponent; ctable: CTabHandle; flags: CodecFlags; bufferSize: SIGNEDLONG; flushProc: ICMFlushProcRecordPtr; progressProc: ICMProgressProcRecordPtr; desc: ImageDescriptionHandle; data: Ptr ): OSErr; external name '_FCompressImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DecompressImage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DecompressImage( data: Ptr; desc: ImageDescriptionHandle; dst: PixMapHandle; const (*var*) srcRect: Rect; const (*var*) dstRect: Rect; mode: SInt16; mask: RgnHandle ): OSErr; external name '_DecompressImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FDecompressImage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function FDecompressImage( data: Ptr; desc: ImageDescriptionHandle; dst: PixMapHandle; const (*var*) srcRect: Rect; matrix: MatrixRecordPtr; mode: SInt16; mask: RgnHandle; matte: PixMapHandle; const (*var*) matteRect: Rect; accuracy: CodecQ; codec: DecompressorComponent; bufferSize: SIGNEDLONG; dataProc: ICMDataProcRecordPtr; progressProc: ICMProgressProcRecordPtr ): OSErr; external name '_FDecompressImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ For video compression, consider using ICMCompressionSessionCreate etc. instead of CompressSequenceBegin etc. }
{
 *  CompressSequenceBegin()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CompressSequenceBegin( var seqID: ImageSequence; src: PixMapHandle; prev: PixMapHandle; const (*var*) srcRect: Rect; const (*var*) prevRect: Rect; colorDepth: SInt16; cType: CodecType; codec: CompressorComponent; spatialQuality: CodecQ; temporalQuality: CodecQ; keyFrameRate: SIGNEDLONG; ctable: CTabHandle; flags: CodecFlags; desc: ImageDescriptionHandle ): OSErr; external name '_CompressSequenceBegin';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompressSequenceFrame()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CompressSequenceFrame( seqID: ImageSequence; src: PixMapHandle; const (*var*) srcRect: Rect; flags: CodecFlags; data: Ptr; var dataSize: SIGNEDLONG; var similarity: UInt8; asyncCompletionProc: ICMCompletionProcRecordPtr ): OSErr; external name '_CompressSequenceFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ For video decompression, consider using ICMDecompressionSessionCreate etc. instead of DecompressSequenceBegin etc. }
{
 *  DecompressSequenceBegin()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DecompressSequenceBegin( var seqID: ImageSequence; desc: ImageDescriptionHandle; port: CGrafPtr; gdh: GDHandle; const (*var*) srcRect: Rect; matrix: MatrixRecordPtr; mode: SInt16; mask: RgnHandle; flags: CodecFlags; accuracy: CodecQ; codec: DecompressorComponent ): OSErr; external name '_DecompressSequenceBegin';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ For video decompression, consider using ICMDecompressionSessionCreate etc. instead of DecompressSequenceBeginS etc. }
{
 *  DecompressSequenceBeginS()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DecompressSequenceBeginS( var seqID: ImageSequence; desc: ImageDescriptionHandle; data: Ptr; dataSize: SIGNEDLONG; port: CGrafPtr; gdh: GDHandle; const (*var*) srcRect: Rect; matrix: MatrixRecordPtr; mode: SInt16; mask: RgnHandle; flags: CodecFlags; accuracy: CodecQ; codec: DecompressorComponent ): OSErr; external name '_DecompressSequenceBeginS';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DecompressSequenceFrame()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DecompressSequenceFrame( seqID: ImageSequence; data: Ptr; inFlags: CodecFlags; var outFlags: CodecFlags; asyncCompletionProc: ICMCompletionProcRecordPtr ): OSErr; external name '_DecompressSequenceFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DecompressSequenceFrameS()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DecompressSequenceFrameS( seqID: ImageSequence; data: Ptr; dataSize: SIGNEDLONG; inFlags: CodecFlags; var outFlags: CodecFlags; asyncCompletionProc: ICMCompletionProcRecordPtr ): OSErr; external name '_DecompressSequenceFrameS';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DecompressSequenceFrameWhen()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DecompressSequenceFrameWhen( seqID: ImageSequence; data: Ptr; dataSize: SIGNEDLONG; inFlags: CodecFlags; var outFlags: CodecFlags; asyncCompletionProc: ICMCompletionProcRecordPtr; const (*var*) frameTime: ICMFrameTimeRecord ): OSErr; external name '_DecompressSequenceFrameWhen';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceFlush()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceFlush( seqID: ImageSequence ): OSErr; external name '_CDSequenceFlush';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDSequenceMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetDSequenceMatrix( seqID: ImageSequence; matrix: MatrixRecordPtr ): OSErr; external name '_SetDSequenceMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDSequenceMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GetDSequenceMatrix( seqID: ImageSequence; matrix: MatrixRecordPtr ): OSErr; external name '_GetDSequenceMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDSequenceMatte()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetDSequenceMatte( seqID: ImageSequence; matte: PixMapHandle; const (*var*) matteRect: Rect ): OSErr; external name '_SetDSequenceMatte';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDSequenceMask()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetDSequenceMask( seqID: ImageSequence; mask: RgnHandle ): OSErr; external name '_SetDSequenceMask';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDSequenceTransferMode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetDSequenceTransferMode( seqID: ImageSequence; mode: SInt16; const (*var*) opColor: RGBColor ): OSErr; external name '_SetDSequenceTransferMode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDSequenceDataProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetDSequenceDataProc( seqID: ImageSequence; dataProc: ICMDataProcRecordPtr; bufferSize: SIGNEDLONG ): OSErr; external name '_SetDSequenceDataProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDSequenceAccuracy()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetDSequenceAccuracy( seqID: ImageSequence; accuracy: CodecQ ): OSErr; external name '_SetDSequenceAccuracy';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDSequenceSrcRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetDSequenceSrcRect( seqID: ImageSequence; const (*var*) srcRect: Rect ): OSErr; external name '_SetDSequenceSrcRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDSequenceFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function SetDSequenceFlags( seqID: ImageSequence; flags: SIGNEDLONG; flagsMask: SIGNEDLONG ): OSErr; external name '_SetDSequenceFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	codecDSequenceDisableOverlaySurface = 1 shl 5;
	codecDSequenceSingleField = 1 shl 6;
	codecDSequenceBidirectionalPrediction = 1 shl 7;
	codecDSequenceFlushInsteadOfDirtying = 1 shl 8;
	codecDSequenceEnableSubPixelPositioning = 1 shl 9;
	codecDSequenceDeinterlaceFields = 1 shl 10;

type
	CodecComponentPtr = ^CodecComponent;
	CodecComponentHandle = ^CodecComponentPtr;
{ selectors for ICMSequenceGet/SetInfo}
const
	kICMSequenceTaskWeight = FourCharCode('twei'); { data is pointer to UInt32}
	kICMSequenceTaskName = FourCharCode('tnam'); { data is pointer to OSType}
	kICMSequenceUserPreferredCodecs = FourCharCode('punt'); { data is pointer to CodecComponentHandle}

{
 *  ICMSequenceGetInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function ICMSequenceGetInfo( seqID: ImageSequence; which: OSType; data: UnivPtr ): OSErr; external name '_ICMSequenceGetInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ICMSequenceSetInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function ICMSequenceSetInfo( seqID: ImageSequence; which: OSType; data: UnivPtr; dataSize: Size ): OSErr; external name '_ICMSequenceSetInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDSequenceImageBuffer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetDSequenceImageBuffer( seqID: ImageSequence; var gworld: GWorldPtr ): OSErr; external name '_GetDSequenceImageBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDSequenceScreenBuffer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetDSequenceScreenBuffer( seqID: ImageSequence; var gworld: GWorldPtr ): OSErr; external name '_GetDSequenceScreenBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetCSequenceQuality()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetCSequenceQuality( seqID: ImageSequence; spatialQuality: CodecQ; temporalQuality: CodecQ ): OSErr; external name '_SetCSequenceQuality';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetCSequencePrev()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetCSequencePrev( seqID: ImageSequence; prev: PixMapHandle; const (*var*) prevRect: Rect ): OSErr; external name '_SetCSequencePrev';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetCSequenceFlushProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetCSequenceFlushProc( seqID: ImageSequence; flushProc: ICMFlushProcRecordPtr; bufferSize: SIGNEDLONG ): OSErr; external name '_SetCSequenceFlushProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetCSequenceKeyFrameRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetCSequenceKeyFrameRate( seqID: ImageSequence; keyFrameRate: SIGNEDLONG ): OSErr; external name '_SetCSequenceKeyFrameRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetCSequenceKeyFrameRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetCSequenceKeyFrameRate( seqID: ImageSequence; var keyFrameRate: SIGNEDLONG ): OSErr; external name '_GetCSequenceKeyFrameRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetCSequencePrevBuffer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetCSequencePrevBuffer( seqID: ImageSequence; var gworld: GWorldPtr ): OSErr; external name '_GetCSequencePrevBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceBusy()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceBusy( seqID: ImageSequence ): OSErr; external name '_CDSequenceBusy';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceEnd()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceEnd( seqID: ImageSequence ): OSErr; external name '_CDSequenceEnd';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceEquivalentImageDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceEquivalentImageDescription( seqID: ImageSequence; newDesc: ImageDescriptionHandle; var equivalent: Boolean ): OSErr; external name '_CDSequenceEquivalentImageDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceEquivalentImageDescriptionS()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function CDSequenceEquivalentImageDescriptionS( seqID: ImageSequence; newDesc: ImageDescriptionHandle; var equivalent: Boolean; var canSwitch: Boolean ): OSErr; external name '_CDSequenceEquivalentImageDescriptionS';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ReplaceDSequenceImageDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function ReplaceDSequenceImageDescription( seqID: ImageSequence; newDesc: ImageDescriptionHandle ): OSErr; external name '_ReplaceDSequenceImageDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetCompressedImageSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetCompressedImageSize( desc: ImageDescriptionHandle; data: Ptr; bufferSize: SIGNEDLONG; dataProc: ICMDataProcRecordPtr; var dataSize: SIGNEDLONG ): OSErr; external name '_GetCompressedImageSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetSimilarity()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetSimilarity( src: PixMapHandle; const (*var*) srcRect: Rect; desc: ImageDescriptionHandle; data: Ptr; var similarity: Fixed ): OSErr; external name '_GetSimilarity';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	kImageDescriptionSampleFormat = FourCharCode('idfm'); { image description extension describing sample format}
	kImageDescriptionClassicAtomFormat = FourCharCode('atom'); { sample contains classic atom structure (ie, GX codec and Curve codec)}
	kImageDescriptionQTAtomFormat = FourCharCode('qtat'); { sample contains QT atom structure}
	kImageDescriptionEffectDataFormat = FourCharCode('fxat'); { sample describes an effect (as QTAtoms)}
	kImageDescriptionPrivateDataFormat = FourCharCode('priv'); { sample is in a private codec specific format}
	kImageDescriptionAlternateCodec = FourCharCode('subs'); { image description extension containing the OSType of a substitute codec should the main codec not be available}
	kImageDescriptionColorSpace = FourCharCode('cspc'); { image description extension containing an OSType naming the native pixel format of an image (only used for pixel formats not supported by classic Color QuickDraw)}

{
 *  GetImageDescriptionCTable()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetImageDescriptionCTable( desc: ImageDescriptionHandle; var ctable: CTabHandle ): OSErr; external name '_GetImageDescriptionCTable';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetImageDescriptionCTable()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetImageDescriptionCTable( desc: ImageDescriptionHandle; ctable: CTabHandle ): OSErr; external name '_SetImageDescriptionCTable';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetImageDescriptionExtension()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetImageDescriptionExtension( desc: ImageDescriptionHandle; var extension: Handle; idType: SIGNEDLONG; index: SIGNEDLONG ): OSErr; external name '_GetImageDescriptionExtension';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AddImageDescriptionExtension()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function AddImageDescriptionExtension( desc: ImageDescriptionHandle; extension: Handle; idType: SIGNEDLONG ): OSErr; external name '_AddImageDescriptionExtension';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  RemoveImageDescriptionExtension()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function RemoveImageDescriptionExtension( desc: ImageDescriptionHandle; idType: SIGNEDLONG; index: SIGNEDLONG ): OSErr; external name '_RemoveImageDescriptionExtension';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CountImageDescriptionExtensionType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CountImageDescriptionExtensionType( desc: ImageDescriptionHandle; idType: SIGNEDLONG; var count: SIGNEDLONG ): OSErr; external name '_CountImageDescriptionExtensionType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetNextImageDescriptionExtensionType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetNextImageDescriptionExtensionType( desc: ImageDescriptionHandle; var idType: SIGNEDLONG ): OSErr; external name '_GetNextImageDescriptionExtensionType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FindCodec()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function FindCodec( cType: CodecType; specCodec: CodecComponent; var compressor: CompressorComponent; var decompressor: DecompressorComponent ): OSErr; external name '_FindCodec';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompressPicture()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CompressPicture( srcPicture: PicHandle; dstPicture: PicHandle; quality: CodecQ; cType: CodecType ): OSErr; external name '_CompressPicture';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FCompressPicture()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function FCompressPicture( srcPicture: PicHandle; dstPicture: PicHandle; colorDepth: SInt16; ctable: CTabHandle; quality: CodecQ; doDither: SInt16; compressAgain: SInt16; progressProc: ICMProgressProcRecordPtr; cType: CodecType; codec: CompressorComponent ): OSErr; external name '_FCompressPicture';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompressPictureFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CompressPictureFile( srcRefNum: SInt16; dstRefNum: SInt16; quality: CodecQ; cType: CodecType ): OSErr; external name '_CompressPictureFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FCompressPictureFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function FCompressPictureFile( srcRefNum: SInt16; dstRefNum: SInt16; colorDepth: SInt16; ctable: CTabHandle; quality: CodecQ; doDither: SInt16; compressAgain: SInt16; progressProc: ICMProgressProcRecordPtr; cType: CodecType; codec: CompressorComponent ): OSErr; external name '_FCompressPictureFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetPictureFileHeader()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetPictureFileHeader( refNum: SInt16; var frame: Rect; var header: OpenCPicParams ): OSErr; external name '_GetPictureFileHeader';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DrawPictureFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DrawPictureFile( refNum: SInt16; const (*var*) frame: Rect; progressProc: ICMProgressProcRecordPtr ): OSErr; external name '_DrawPictureFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DrawTrimmedPicture()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DrawTrimmedPicture( srcPicture: PicHandle; const (*var*) frame: Rect; trimMask: RgnHandle; doDither: SInt16; progressProc: ICMProgressProcRecordPtr ): OSErr; external name '_DrawTrimmedPicture';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DrawTrimmedPictureFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DrawTrimmedPictureFile( srcRefnum: SInt16; const (*var*) frame: Rect; trimMask: RgnHandle; doDither: SInt16; progressProc: ICMProgressProcRecordPtr ): OSErr; external name '_DrawTrimmedPictureFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MakeThumbnailFromPicture()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MakeThumbnailFromPicture( picture: PicHandle; colorDepth: SInt16; thumbnail: PicHandle; progressProc: ICMProgressProcRecordPtr ): OSErr; external name '_MakeThumbnailFromPicture';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MakeThumbnailFromPictureFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MakeThumbnailFromPictureFile( refNum: SInt16; colorDepth: SInt16; thumbnail: PicHandle; progressProc: ICMProgressProcRecordPtr ): OSErr; external name '_MakeThumbnailFromPictureFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MakeThumbnailFromPixMap()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MakeThumbnailFromPixMap( src: PixMapHandle; const (*var*) srcRect: Rect; colorDepth: SInt16; thumbnail: PicHandle; progressProc: ICMProgressProcRecordPtr ): OSErr; external name '_MakeThumbnailFromPixMap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TrimImage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TrimImage( desc: ImageDescriptionHandle; inData: Ptr; inBufferSize: SIGNEDLONG; dataProc: ICMDataProcRecordPtr; outData: Ptr; outBufferSize: SIGNEDLONG; flushProc: ICMFlushProcRecordPtr; var trimRect: Rect; progressProc: ICMProgressProcRecordPtr ): OSErr; external name '_TrimImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ConvertImage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ConvertImage( srcDD: ImageDescriptionHandle; srcData: Ptr; colorDepth: SInt16; ctable: CTabHandle; accuracy: CodecQ; quality: CodecQ; cType: CodecType; codec: CodecComponent; dstDD: ImageDescriptionHandle; dstData: Ptr ): OSErr; external name '_ConvertImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetCompressedPixMapInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetCompressedPixMapInfo( pix: PixMapPtr; var desc: ImageDescriptionHandle; var data: Ptr; var bufferSize: SIGNEDLONG; var dataProc: ICMDataProcRecord; var progressProc: ICMProgressProcRecord ): OSErr; external name '_GetCompressedPixMapInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetCompressedPixMapInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetCompressedPixMapInfo( pix: PixMapPtr; desc: ImageDescriptionHandle; data: Ptr; bufferSize: SIGNEDLONG; dataProc: ICMDataProcRecordPtr; progressProc: ICMProgressProcRecordPtr ): OSErr; external name '_SetCompressedPixMapInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  StdPix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure StdPix( src: PixMapPtr; const (*var*) srcRect: Rect; matrix: MatrixRecordPtr; mode: SInt16; mask: RgnHandle; matte: PixMapPtr; const (*var*) matteRect: Rect; flags: SInt16 ); external name '_StdPix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TransformRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TransformRgn( matrix: MatrixRecordPtr; rgn: RgnHandle ): OSErr; external name '_TransformRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{**********
    preview stuff
**********}
{
 *  SFGetFilePreview()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }


{
 *  SFPGetFilePreview()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }


{
 *  StandardGetFilePreview()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }


{
 *  CustomGetFilePreview()
 *  
 *  Availability:
 *    Mac OS X:         not available
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }


{
 *  MakeFilePreview()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MakeFilePreview( resRefNum: SInt16; progress: ICMProgressProcRecordPtr ): OSErr; external name '_MakeFilePreview';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AddFilePreview()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function AddFilePreview( resRefNum: SInt16; previewType: OSType; previewData: Handle ): OSErr; external name '_AddFilePreview';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


type
	PreviewResourceRecordPtr = ^PreviewResourceRecord;
	PreviewResourceRecord = record
		modDate: UNSIGNEDLONG;
		version: SInt16;
		resType: OSType;
		resID: SInt16;
	end;
type
	PreviewResourcePtr = PreviewResourceRecordPtr;
	PreviewResource = ^PreviewResourcePtr;
{
 *  AlignScreenRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure AlignScreenRect( var rp: Rect; alignmentProc: ICMAlignmentProcRecordPtr ); external name '_AlignScreenRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AlignWindow()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure AlignWindow( wp: WindowRef; front: Boolean; const (*var*) alignmentRect: Rect; alignmentProc: ICMAlignmentProcRecordPtr ); external name '_AlignWindow';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DragAlignedWindow()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure DragAlignedWindow( wp: WindowRef; startPt: Point; var boundsRect: Rect; var alignmentRect: Rect; alignmentProc: ICMAlignmentProcRecordPtr ); external name '_DragAlignedWindow';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DragAlignedGrayRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DragAlignedGrayRgn( theRgn: RgnHandle; startPt: Point; var boundsRect: Rect; var slopRect: Rect; axis: SInt16; actionProc: UniversalProcPtr; var alignmentRect: Rect; alignmentProc: ICMAlignmentProcRecordPtr ): SIGNEDLONG; external name '_DragAlignedGrayRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetCSequenceDataRateParams()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetCSequenceDataRateParams( seqID: ImageSequence; params: DataRateParamsPtr ): OSErr; external name '_SetCSequenceDataRateParams';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetCSequenceFrameNumber()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetCSequenceFrameNumber( seqID: ImageSequence; frameNumber: SIGNEDLONG ): OSErr; external name '_SetCSequenceFrameNumber';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetCSequencePreferredPacketSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetCSequencePreferredPacketSize( seqID: ImageSequence; preferredPacketSizeInBytes: SIGNEDLONG ): OSErr; external name '_SetCSequencePreferredPacketSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewImageGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewImageGWorld( var gworld: GWorldPtr; idh: ImageDescriptionHandle; flags: GWorldFlags ): OSErr; external name '_NewImageGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetCSequenceDataRateParams()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetCSequenceDataRateParams( seqID: ImageSequence; params: DataRateParamsPtr ): OSErr; external name '_GetCSequenceDataRateParams';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetCSequenceFrameNumber()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetCSequenceFrameNumber( seqID: ImageSequence; var frameNumber: SIGNEDLONG ): OSErr; external name '_GetCSequenceFrameNumber';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetBestDeviceRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetBestDeviceRect( var gdh: GDHandle; var rp: Rect ): OSErr; external name '_GetBestDeviceRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetSequenceProgressProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetSequenceProgressProc( seqID: ImageSequence; var progressProc: ICMProgressProcRecord ): OSErr; external name '_SetSequenceProgressProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GDHasScale()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GDHasScale( gdh: GDHandle; depth: SInt16; var scale: Fixed ): OSErr; external name '_GDHasScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GDGetScale()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GDGetScale( gdh: GDHandle; var scale: Fixed; var flags: SInt16 ): OSErr; external name '_GDGetScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GDSetScale()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GDSetScale( gdh: GDHandle; scale: Fixed; flags: SInt16 ): OSErr; external name '_GDSetScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ICMShieldSequenceCursor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ICMShieldSequenceCursor( seqID: ImageSequence ): OSErr; external name '_ICMShieldSequenceCursor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ICMDecompressComplete()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure ICMDecompressComplete( seqID: ImageSequence; err: OSErr; flag: SInt16; completionRtn: ICMCompletionProcRecordPtr ); external name '_ICMDecompressComplete';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ICMDecompressCompleteS()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ICMDecompressCompleteS( seqID: ImageSequence; err: OSErr; flag: SInt16; completionRtn: ICMCompletionProcRecordPtr ): OSErr; external name '_ICMDecompressCompleteS';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ICMSequenceLockBits()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ICMSequenceLockBits( seqID: ImageSequence; dst: PixMapPtr; flags: SIGNEDLONG ): OSErr; external name '_ICMSequenceLockBits';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ICMSequenceUnlockBits()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ICMSequenceUnlockBits( seqID: ImageSequence; flags: SIGNEDLONG ): OSErr; external name '_ICMSequenceUnlockBits';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	kICMPixelFormatIsPlanarMask = $0F; { these bits in formatFlags indicate how many planes there are; they're 0 if chunky}
	kICMPixelFormatIsIndexed = 1 shl 4;
	kICMPixelFormatIsSupportedByQD = 1 shl 5;
	kICMPixelFormatIsMonochrome = 1 shl 6;
	kICMPixelFormatHasAlphaChannel = 1 shl 7;

type
	ICMPixelFormatInfo = record
		size: SIGNEDLONG;                   { caller MUST fill this in with sizeof(ICMPixelFormatInfo) before calling ICMGet/SetPixelFormatInfo}
		formatFlags: UNSIGNEDLONG;
		bitsPerPixel: array [0..13] of SInt16;       { list each plane's bits per pixel separately if planar}
                                              { new field for QuickTime 4.1}
		defaultGammaLevel: Fixed;
                                              { new fields for QuickTime 6.0}
		horizontalSubsampling: array [0..13] of SInt16; { per plane; use 1 if plane is not subsampled}
		verticalSubsampling: array [0..13] of SInt16; { per plane; use 1 if plane is not subsampled}
                                              { new fields for QuickTime 6.5}
		cmpCount: SInt16;               { for use in PixMap.cmpCount}
		cmpSize: SInt16;                { for use in PixMap.cmpSize}
	end;
	ICMPixelFormatInfoPtr = ^ICMPixelFormatInfo;
{ IMPORTANT: Fill in theInfo->size with sizeof(ICMPixelFormatInfo) before calling ICMGetPixelFormatInfo }
{
 *  ICMGetPixelFormatInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ICMGetPixelFormatInfo( PixelFormat: OSType; theInfo: ICMPixelFormatInfoPtr ): OSErr; external name '_ICMGetPixelFormatInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ IMPORTANT: Fill in theInfo->size with sizeof(ICMPixelFormatInfo) before calling ICMSetPixelFormatInfo }
{
 *  ICMSetPixelFormatInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ICMSetPixelFormatInfo( PixelFormat: OSType; theInfo: ICMPixelFormatInfoPtr ): OSErr; external name '_ICMSetPixelFormatInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	kICMGetChainUltimateParent = 0;
	kICMGetChainParent = 1;
	kICMGetChainChild = 2;
	kICMGetChainUltimateChild = 3;

{
 *  ICMSequenceGetChainMember()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ICMSequenceGetChainMember( seqID: ImageSequence; var retSeqID: ImageSequence; flags: SIGNEDLONG ): OSErr; external name '_ICMSequenceGetChainMember';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDSequenceTimeCode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetDSequenceTimeCode( seqID: ImageSequence; timeCodeFormat: UnivPtr; timeCodeTime: UnivPtr ): OSErr; external name '_SetDSequenceTimeCode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceNewMemory()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceNewMemory( seqID: ImageSequence; var data: Ptr; dataSize: Size; dataUse: SIGNEDLONG; memoryGoneProc: ICMMemoryDisposedUPP; refCon: UnivPtr ): OSErr; external name '_CDSequenceNewMemory';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceDisposeMemory()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceDisposeMemory( seqID: ImageSequence; data: Ptr ): OSErr; external name '_CDSequenceDisposeMemory';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceNewDataSource()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceNewDataSource( seqID: ImageSequence; var sourceID: ImageSequenceDataSource; sourceType: OSType; sourceInputNumber: SIGNEDLONG; dataDescription: Handle; transferProc: ICMConvertDataFormatUPP; refCon: UnivPtr ): OSErr; external name '_CDSequenceNewDataSource';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceDisposeDataSource()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceDisposeDataSource( sourceID: ImageSequenceDataSource ): OSErr; external name '_CDSequenceDisposeDataSource';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceSetSourceData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceSetSourceData( sourceID: ImageSequenceDataSource; data: UnivPtr; dataSize: SIGNEDLONG ): OSErr; external name '_CDSequenceSetSourceData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceChangedSourceData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceChangedSourceData( sourceID: ImageSequenceDataSource ): OSErr; external name '_CDSequenceChangedSourceData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceSetSourceDataQueue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceSetSourceDataQueue( sourceID: ImageSequenceDataSource; dataQueue: QHdrPtr ): OSErr; external name '_CDSequenceSetSourceDataQueue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceGetDataSource()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceGetDataSource( seqID: ImageSequence; var sourceID: ImageSequenceDataSource; sourceType: OSType; sourceInputNumber: SIGNEDLONG ): OSErr; external name '_CDSequenceGetDataSource';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PtInDSequenceData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PtInDSequenceData( seqID: ImageSequence; data: UnivPtr; dataSize: Size; where: Point; var hit: Boolean ): OSErr; external name '_PtInDSequenceData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  HitTestDSequenceData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function HitTestDSequenceData( seqID: ImageSequence; data: UnivPtr; dataSize: Size; where: Point; var hit: SIGNEDLONG; hitFlags: SIGNEDLONG ): OSErr; external name '_HitTestDSequenceData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetDSequenceNonScheduledDisplayTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function SetDSequenceNonScheduledDisplayTime( sequence: ImageSequence; displayTime: TimeValue64; displayTimeScale: TimeScale; flags: UInt32 ): OSErr; external name '_SetDSequenceNonScheduledDisplayTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetDSequenceNonScheduledDisplayTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function GetDSequenceNonScheduledDisplayTime( sequence: ImageSequence; var displayTime: TimeValue64; var displayTimeScale: TimeScale ): OSErr; external name '_GetDSequenceNonScheduledDisplayTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  SetDSequenceNonScheduledDisplayDirection()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function SetDSequenceNonScheduledDisplayDirection( sequence: ImageSequence; rate: Fixed ): OSErr; external name '_SetDSequenceNonScheduledDisplayDirection';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetDSequenceNonScheduledDisplayDirection()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function GetDSequenceNonScheduledDisplayDirection( sequence: ImageSequence; var rate: Fixed ): OSErr; external name '_GetDSequenceNonScheduledDisplayDirection';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetGraphicsImporterForFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetGraphicsImporterForFile( const (*var*) theFile: FSSpec; var gi: ComponentInstance ): OSErr; external name '_GetGraphicsImporterForFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetGraphicsImporterForDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetGraphicsImporterForDataRef( dataRef: Handle; dataRefType: OSType; var gi: ComponentInstance ): OSErr; external name '_GetGraphicsImporterForDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	kDontUseValidateToFindGraphicsImporter = 1 shl 0;

{
 *  GetGraphicsImporterForFileWithFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetGraphicsImporterForFileWithFlags( const (*var*) theFile: FSSpec; var gi: ComponentInstance; flags: SIGNEDLONG ): OSErr; external name '_GetGraphicsImporterForFileWithFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetGraphicsImporterForDataRefWithFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetGraphicsImporterForDataRefWithFlags( dataRef: Handle; dataRefType: OSType; var gi: ComponentInstance; flags: SIGNEDLONG ): OSErr; external name '_GetGraphicsImporterForDataRefWithFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetFileNameExtension()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTGetFileNameExtension(const (*var*) fileName: StrFileName; fileType: OSType; var extension: OSType ): OSErr; external name '_QTGetFileNameExtension';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ImageTranscodeSequenceBegin()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ImageTranscodeSequenceBegin( var its: ImageTranscodeSequence; srcDesc: ImageDescriptionHandle; destType: OSType; var dstDesc: ImageDescriptionHandle; data: UnivPtr; dataSize: SIGNEDLONG ): OSErr; external name '_ImageTranscodeSequenceBegin';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ImageTranscodeSequenceEnd()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ImageTranscodeSequenceEnd( its: ImageTranscodeSequence ): OSErr; external name '_ImageTranscodeSequenceEnd';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ImageTranscodeFrame()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ImageTranscodeFrame( its: ImageTranscodeSequence; srcData: UnivPtr; srcDataSize: SIGNEDLONG; var dstData: UnivPtr; var dstDataSize: SIGNEDLONG ): OSErr; external name '_ImageTranscodeFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ImageTranscodeDisposeFrameData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ImageTranscodeDisposeFrameData( its: ImageTranscodeSequence; dstData: UnivPtr ): OSErr; external name '_ImageTranscodeDisposeFrameData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceInvalidate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceInvalidate( seqID: ImageSequence; invalRgn: RgnHandle ): OSErr; external name '_CDSequenceInvalidate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CDSequenceSetTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CDSequenceSetTimeBase( seqID: ImageSequence; base: UnivPtr ): OSErr; external name '_CDSequenceSetTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ImageFieldSequenceBegin()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ImageFieldSequenceBegin( var ifs: ImageFieldSequence; desc1: ImageDescriptionHandle; desc2: ImageDescriptionHandle; descOut: ImageDescriptionHandle ): OSErr; external name '_ImageFieldSequenceBegin';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ImageFieldSequenceExtractCombine()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ImageFieldSequenceExtractCombine( ifs: ImageFieldSequence; fieldFlags: SIGNEDLONG; data1: UnivPtr; dataSize1: SIGNEDLONG; data2: UnivPtr; dataSize2: SIGNEDLONG; outputData: UnivPtr; var outDataSize: SIGNEDLONG ): OSErr; external name '_ImageFieldSequenceExtractCombine';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ImageFieldSequenceEnd()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ImageFieldSequenceEnd( ifs: ImageFieldSequence ): OSErr; external name '_ImageFieldSequenceEnd';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	kICMTempThenAppMemory = 1 shl 12;
	kICMAppThenTempMemory = 1 shl 13;

{
 *  QTNewGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTNewGWorld( var offscreenGWorld: GWorldPtr; PixelFormat: OSType; const (*var*) boundsRect: Rect; cTable: CTabHandle; aGDevice: GDHandle; flags: GWorldFlags ): OSErr; external name '_QTNewGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTNewGWorldFromPtr()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function QTNewGWorldFromPtr( var gw: GWorldPtr; pixelFormat: OSType; const (*var*) boundsRect: Rect; cTable: CTabHandle; aGDevice: GDHandle; flags: GWorldFlags; baseAddr: UnivPtr; rowBytes: SIGNEDLONG ): OSErr; external name '_QTNewGWorldFromPtr';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTUpdateGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTUpdateGWorld( var offscreenGWorld: GWorldPtr; PixelFormat: OSType; const (*var*) boundsRect: Rect; cTable: CTabHandle; aGDevice: GDHandle; flags: GWorldFlags ): GWorldFlags; external name '_QTUpdateGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MakeImageDescriptionForPixMap()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MakeImageDescriptionForPixMap( pixmap: PixMapHandle; var idh: ImageDescriptionHandle ): OSErr; external name '_MakeImageDescriptionForPixMap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MakeImageDescriptionForEffect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function MakeImageDescriptionForEffect( effectType: OSType; var idh: ImageDescriptionHandle ): OSErr; external name '_MakeImageDescriptionForEffect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetPixelSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTGetPixelSize( PixelFormat: OSType ): SInt16; external name '_QTGetPixelSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetPixelFormatDepthForImageDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTGetPixelFormatDepthForImageDescription( PixelFormat: OSType ): SInt16; external name '_QTGetPixelFormatDepthForImageDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTGetPixMapPtrRowBytes()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function QTGetPixMapPtrRowBytes( pm: PixMapPtr ): SIGNEDLONG; external name '_QTGetPixMapPtrRowBytes';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetPixMapHandleRowBytes()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function QTGetPixMapHandleRowBytes( pm: PixMapHandle ): SIGNEDLONG; external name '_QTGetPixMapHandleRowBytes';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTSetPixMapPtrRowBytes()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function QTSetPixMapPtrRowBytes( pm: PixMapPtr; rowBytes: SIGNEDLONG ): OSErr; external name '_QTSetPixMapPtrRowBytes';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTSetPixMapHandleRowBytes()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function QTSetPixMapHandleRowBytes( pm: PixMapHandle; rowBytes: SIGNEDLONG ): OSErr; external name '_QTSetPixMapHandleRowBytes';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	kQTUsePlatformDefaultGammaLevel = 0;  { When decompressing into this PixMap, gamma-correct to the platform's standard gamma. }
	kQTUseSourceGammaLevel = -1;  { When decompressing into this PixMap, don't perform gamma-correction. }
	kQTCCIR601VideoGammaLevel = $00023333; { 2.2, standard television video gamma.}

{
 *  QTGetPixMapPtrGammaLevel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function QTGetPixMapPtrGammaLevel( pm: PixMapPtr ): Fixed; external name '_QTGetPixMapPtrGammaLevel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTSetPixMapPtrGammaLevel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function QTSetPixMapPtrGammaLevel( pm: PixMapPtr; gammaLevel: Fixed ): OSErr; external name '_QTSetPixMapPtrGammaLevel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetPixMapHandleGammaLevel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function QTGetPixMapHandleGammaLevel( pm: PixMapHandle ): Fixed; external name '_QTGetPixMapHandleGammaLevel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTSetPixMapHandleGammaLevel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function QTSetPixMapHandleGammaLevel( pm: PixMapHandle; gammaLevel: Fixed ): OSErr; external name '_QTSetPixMapHandleGammaLevel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetPixMapPtrRequestedGammaLevel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function QTGetPixMapPtrRequestedGammaLevel( pm: PixMapPtr ): Fixed; external name '_QTGetPixMapPtrRequestedGammaLevel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTSetPixMapPtrRequestedGammaLevel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function QTSetPixMapPtrRequestedGammaLevel( pm: PixMapPtr; requestedGammaLevel: Fixed ): OSErr; external name '_QTSetPixMapPtrRequestedGammaLevel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetPixMapHandleRequestedGammaLevel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function QTGetPixMapHandleRequestedGammaLevel( pm: PixMapHandle ): Fixed; external name '_QTGetPixMapHandleRequestedGammaLevel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTSetPixMapHandleRequestedGammaLevel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function QTSetPixMapHandleRequestedGammaLevel( pm: PixMapHandle; requestedGammaLevel: Fixed ): OSErr; external name '_QTSetPixMapHandleRequestedGammaLevel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QuadToQuadMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
type
	FixedPoint4 = array[0..3] of FixedPoint;
function QuadToQuadMatrix( const (*var*) source: FixedPoint4; const (*var*) dest: FixedPoint4; var map: MatrixRecord ): OSErr; external name '_QuadToQuadMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	identityMatrixType = $00; { result if matrix is identity }
	translateMatrixType = $01; { result if matrix translates }
	scaleMatrixType = $02; { result if matrix scales }
	scaleTranslateMatrixType = $03; { result if matrix scales and translates }
	linearMatrixType = $04; { result if matrix is general 2 x 2 }
	linearTranslateMatrixType = $05; { result if matrix is general 2 x 2 and translates }
	perspectiveMatrixType = $06;  { result if matrix is general 3 x 3 }

type
	MatrixFlags = UInt16;
{
 *  GetMatrixType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMatrixType( const (*var*) m: MatrixRecord ): SInt16; external name '_GetMatrixType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CopyMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure CopyMatrix( const (*var*) m1: MatrixRecord; var m2: MatrixRecord ); external name '_CopyMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  EqualMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function EqualMatrix( const (*var*) m1: MatrixRecord; const (*var*) m2: MatrixRecord ): Boolean; external name '_EqualMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetIdentityMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetIdentityMatrix( var matrix: MatrixRecord ); external name '_SetIdentityMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TranslateMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure TranslateMatrix( var m: MatrixRecord; deltaH: Fixed; deltaV: Fixed ); external name '_TranslateMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  RotateMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure RotateMatrix( var m: MatrixRecord; degrees: Fixed; aboutX: Fixed; aboutY: Fixed ); external name '_RotateMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ScaleMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure ScaleMatrix( var m: MatrixRecord; scaleX: Fixed; scaleY: Fixed; aboutX: Fixed; aboutY: Fixed ); external name '_ScaleMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SkewMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SkewMatrix( var m: MatrixRecord; skewX: Fixed; skewY: Fixed; aboutX: Fixed; aboutY: Fixed ); external name '_SkewMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TransformFixedPoints()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TransformFixedPoints( const (*var*) m: MatrixRecord; var fpt: FixedPoint; count: SIGNEDLONG ): OSErr; external name '_TransformFixedPoints';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TransformPoints()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TransformPoints( const (*var*) mp: MatrixRecord; var pt1: Point; count: SIGNEDLONG ): OSErr; external name '_TransformPoints';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TransformFixedRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TransformFixedRect( const (*var*) m: MatrixRecord; var fr: FixedRect; var fpp: FixedPoint ): Boolean; external name '_TransformFixedRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TransformRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TransformRect( const (*var*) m: MatrixRecord; var r: Rect; var fpp: FixedPoint ): Boolean; external name '_TransformRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  InverseMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function InverseMatrix( const (*var*) m: MatrixRecord; var im: MatrixRecord ): Boolean; external name '_InverseMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ConcatMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure ConcatMatrix( const (*var*) a: MatrixRecord; var b: MatrixRecord ); external name '_ConcatMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  RectMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure RectMatrix( var matrix: MatrixRecord; const (*var*) srcRect: Rect; const (*var*) dstRect: Rect ); external name '_RectMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MapMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure MapMatrix( var matrix: MatrixRecord; const (*var*) fromRect: Rect; const (*var*) toRect: Rect ); external name '_MapMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompAdd()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure CompAdd( var src: wide; var dst: wide ); external name '_CompAdd';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompSub()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure CompSub( var src: wide; var dst: wide ); external name '_CompSub';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompNeg()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure CompNeg( var dst: wide ); external name '_CompNeg';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompShift()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure CompShift( var src: wide; shift: SInt16 ); external name '_CompShift';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompMul()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure CompMul( src1: SIGNEDLONG; src2: SIGNEDLONG; var dst: wide ); external name '_CompMul';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompDiv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CompDiv( var numerator: wide; denominator: SIGNEDLONG; var remainder: SIGNEDLONG ): SIGNEDLONG; external name '_CompDiv';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompFixMul()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure CompFixMul( var compSrc: wide; fixSrc: Fixed; var compDst: wide ); external name '_CompFixMul';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompMulDiv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure CompMulDiv( var co: wide; mul: SIGNEDLONG; divisor: SIGNEDLONG ); external name '_CompMulDiv';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompMulDivTrunc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure CompMulDivTrunc( var co: wide; mul: SIGNEDLONG; divisor: SIGNEDLONG; var remainder: SIGNEDLONG ); external name '_CompMulDivTrunc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompCompare()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CompCompare( const (*var*) a: wide; const (*var*) minusb: wide ): SIGNEDLONG; external name '_CompCompare';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CompSquareRoot()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CompSquareRoot( const (*var*) src: wide ): UNSIGNEDLONG; external name '_CompSquareRoot';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FixMulDiv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function FixMulDiv( src: Fixed; mul: Fixed; divisor: Fixed ): Fixed; external name '_FixMulDiv';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  UnsignedFixMulDiv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function UnsignedFixMulDiv( src: Fixed; mul: Fixed; divisor: Fixed ): Fixed; external name '_UnsignedFixMulDiv';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FracSinCos()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function FracSinCos( degree: Fixed; var cosOut: Fract ): Fract; external name '_FracSinCos';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FixExp2()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function FixExp2( src: Fixed ): Fixed; external name '_FixExp2';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FixLog2()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function FixLog2( src: Fixed ): Fixed; external name '_FixLog2';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FixPow()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function FixPow( base: Fixed; exp: Fixed ): Fixed; external name '_FixPow';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


type
	GraphicsImportComponent = ComponentInstance;
const
	GraphicsImporterComponentType = FourCharCode('grip');

{ Component flags for Graphics Importer components }
const
	graphicsImporterIsBaseImporter = 1 shl 0;
	graphicsImporterCanValidateFile = 1 shl 9;
	graphicsImporterSubTypeIsFileExtension = 1 shl 12;
	graphicsImporterHasMIMEList = 1 shl 14;
	graphicsImporterUsesImageDecompressor = 1 shl 23;

{ Atom types for QuickTime Image files }
const
	quickTimeImageFileImageDescriptionAtom = FourCharCode('idsc');
	quickTimeImageFileImageDataAtom = FourCharCode('idat');
	quickTimeImageFileMetaDataAtom = FourCharCode('meta');
	quickTimeImageFileColorSyncProfileAtom = FourCharCode('iicc');

{ Flags for GraphicsImportDoesDrawAllPixels }
const
	graphicsImporterDrawsAllPixels = 0;
	graphicsImporterDoesntDrawAllPixels = 1;
	graphicsImporterDontKnowIfDrawAllPixels = 2;

{ Flags for GraphicsImportSetFlags }
const
	kGraphicsImporterDontDoGammaCorrection = 1 shl 0;
	kGraphicsImporterTrustResolutionFromFile = 1 shl 1;
	kGraphicsImporterEnableSubPixelPositioning = 1 shl 2;
	kGraphicsImporterDontUseColorMatching = 1 shl 3; { set this flag (*before* calling GraphicsImportGetColorSyncProfile) if you do matching yourself }

{ Flags for GraphicsImportCreateCGImage }
const
	kGraphicsImportCreateCGImageUsingCurrentSettings = 1 shl 0;

const
	kGraphicsExportGroup = FourCharCode('expo');
	kGraphicsExportFileType = FourCharCode('ftyp');
	kGraphicsExportMIMEType = FourCharCode('mime');
	kGraphicsExportExtension = FourCharCode('ext ');
	kGraphicsExportDescription = FourCharCode('desc');

{ User data types for layers of Photoshop files }
const
	kQTPhotoshopLayerMode = FourCharCode('lmod'); { OSType }
	kQTPhotoshopLayerOpacity = FourCharCode('lopa'); { UInt8, 0 = transparent .. 255 = opaque }
	kQTPhotoshopLayerClipping = FourCharCode('lclp'); { UInt8, 0 = base, 1 = non-base }
	kQTPhotoshopLayerFlags = FourCharCode('lflg'); { UInt8 }
	kQTPhotoshopLayerName = FourCharCode('�lnm'); { Text }
	kQTPhotoshopLayerUnicodeName = FourCharCode('luni'); { Unicode characters, not terminated }

{ User data returned by graphics importers to suggest intended use for indexed images }
const
	kQTIndexedImageType = FourCharCode('nth?'); { 1 or more OSTypes, such as the following values: }
	kQTIndexedImageIsThumbnail = FourCharCode('n=th'); { The image at this index is a thumbnail. }
	kQTIndexedImageIsLayer = FourCharCode('n=ly'); { The image at this index is a layer. }
	kQTIndexedImageIsPage = FourCharCode('n=pg'); { The image at this index is a page. }
	kQTIndexedImageIsMultiResolution = FourCharCode('n=rs'); { The image at this index is one of several identical images at different resolutions. }

{ Other user data types returned by graphics importers }
const
	kQTTIFFUserDataPrefix = $74690000; { Added to some tag values in TIFF IFDs to generate user data codes.  (0x7469 is 'ti'.) }
                                        { For example, YCbCrPositioning is tag 0x0213, so its user data code is 0x74690213. }
	kQTTIFFExifUserDataPrefix = $65780000; { Added to tag values in Exif IFDs to generate user data codes.  (0x6578 is 'ex'.) }
                                        { For example, DateTimeOriginal is tag 0x9003, so its user data code is 0x65789003. }
	kQTTIFFExifGPSUserDataPrefix = $67700000; { Added to tag values in Exif GPS IFDs to generate user data codes.  (0x6770 is 'gp'.) }
                                        { For example, GPSAltitude is tag 0x0006, so its user data code is 0x6770006. }
	kQTAlphaMode = FourCharCode('almo'); { UInt32; eg, graphicsModeStraightAlpha or graphicsModePreBlackAlpha }
	kQTAlphaModePreMulColor = FourCharCode('almp'); { RGBColor; used if kQTAlphaMode is graphicsModePreMulColorAlpha }
	kUserDataIPTC = FourCharCode('iptc');

{ Found in TIFF and Exif JPEG files }
const
	kQTTIFFUserDataOrientation = $74690112; { 1 SHORT }
	kQTTIFFUserDataTransferFunction = $7469012D; { n SHORTs }
	kQTTIFFUserDataWhitePoint = $7469013E; { 2 RATIONALs }
	kQTTIFFUserDataPrimaryChromaticities = $7469013F; { 6 RATIONALs }
	kQTTIFFUserDataTransferRange = $74690156; { 6 SHORTs }
	kQTTIFFUserDataYCbCrPositioning = $74690213; { 1 SHORT }
	kQTTIFFUserDataReferenceBlackWhite = $74690214; { n LONGs }

{ Found in GeoTIFF files; defined in the GeoTIFF 1.0 spec }
const
	kQTTIFFUserDataModelPixelScale = $7469830E; { 3 DOUBLEs }
	kQTTIFFUserDataModelTransformation = $746985D8; { 16 DOUBLEs }
	kQTTIFFUserDataModelTiepoint = $74698482; { n DOUBLEs }
	kQTTIFFUserDataGeoKeyDirectory = $746987AF; { n SHORTs }
	kQTTIFFUserDataGeoDoubleParams = $746987B0; { n DOUBLEs }
	kQTTIFFUserDataGeoAsciiParams = $746987B1; { n ASCIIs }
	kQTTIFFUserDataIntergraphMatrix = $74698480; { 16 or 17 DOUBLEs }

{ Found in Exif TIFF and Exif JPEG files; defined in the Exif 2.1 spec }
const
	kQTExifUserDataExifVersion = $65789000; { 4 bytes (import only) }
	kQTExifUserDataFlashPixVersion = $6578A000; { 4 bytes }
	kQTExifUserDataColorSpace = $6578A001; { 1 SHORT }
	kQTExifUserDataComponentsConfiguration = $65789101; { 4 bytes }
	kQTExifUserDataCompressedBitsPerPixel = $65789102; { 1 RATIONAL }
	kQTExifUserDataPixelXDimension = $6578A002; { 1 SHORT or LONG }
	kQTExifUserDataPixelYDimension = $6578A003; { 1 SHORT or LONG }
	kQTExifUserDataMakerNote = $6578927C; { n bytes }
	kQTExifUserDataUserComment = $65789286; { n bytes (Note: this constant was erroneously 0x6578928C)}
	kQTExifUserDataRelatedSoundFile = $6578A004; { 13 ASCIIs}
	kQTExifUserDataDateTimeOriginal = $65789003; { 20 ASCIIs }
	kQTExifUserDataDateTimeDigitized = $65789004; { 20 ASCIIs }
	kQTExifUserDataSubSecTime = $65789290; { n ASCIIs }
	kQTExifUserDataSubSecTimeOriginal = $65789291; { n ASCIIs }
	kQTExifUserDataSubSecTimeDigitized = $65789292; { n ASCIIs }
	kQTExifUserDataExposureTime = $6578829A; { 1 RATIONAL }
	kQTExifUserDataFNumber = $6578829D; { 1 RATIONAL }
	kQTExifUserDataExposureProgram = $65788822; { 1 SHORT }
	kQTExifUserDataSpectralSensitivity = $65788824; { n ASCIIs }
	kQTExifUserDataISOSpeedRatings = $65788827; { n SHORTs }
	kQTExifUserDataShutterSpeedValue = $65789201; { 1 SIGNED RATIONAL }
	kQTExifUserDataApertureValue = $65789202; { 1 RATIONAL }
	kQTExifUserDataBrightnessValue = $65789203; { 1 SIGNED RATIONAL }
	kQTExifUserDataExposureBiasValue = $65789204; { 1 SIGNED RATIONAL }
	kQTExifUserDataMaxApertureValue = $65789205; { 1 RATIONAL }
	kQTExifUserDataSubjectDistance = $65789206; { 1 RATIONAL }
	kQTExifUserDataMeteringMode = $65789207; { 1 SHORT }
	kQTExifUserDataLightSource = $65789208; { 1 SHORT }
	kQTExifUserDataFlash = $65789209; { 1 SHORT }
	kQTExifUserDataFocalLength = $6578920A; { 1 RATIONAL }
	kQTExifUserDataFlashEnergy = $6578A20B; { 1 RATIONAL }
	kQTExifUserDataFocalPlaneXResolution = $6578A20E; { 1 RATIONAL }
	kQTExifUserDataFocalPlaneYResolution = $6578A20F; { 1 RATIONAL }
	kQTExifUserDataFocalPlaneResolutionUnit = $6578A210; { 1 SHORT }
	kQTExifUserDataSubjectLocation = $6578A214; { 1 SHORT }
	kQTExifUserDataExposureIndex = $6578A215; { 1 RATIONAL }
	kQTExifUserDataSensingMethod = $6578A217; { 1 SHORT }
	kQTExifUserDataFileSource = $6578A300; { 1 UNDEFINED }
	kQTExifUserDataSceneType = $6578A301; { 1 UNDEFINED }

{ Found in some Exif TIFF and Exif JPEG files; defined in the Exif 2.1 spec }
{ Note: these were wrong in the QuickTime 6.0 headers -- the high two bytes were 0x677 instead of 0x6770. }
const
	kQTExifUserDataGPSVersionID = $67700000; { 4 BYTEs }
	kQTExifUserDataGPSLatitudeRef = $67700001; { 2 ASCIIs}
	kQTExifUserDataGPSLatitude = $67700002; { 3 RATIONALs }
	kQTExifUserDataGPSLongitudeRef = $67700003; { 2 ASCIIs }
	kQTExifUserDataGPSLongitude = $67700004; { 3 RATIONALs }
	kQTExifUserDataGPSAltitudeRef = $67700005; { 1 BYTE }
	kQTExifUserDataGPSAltitude = $67700006; { 1 RATIONAL }
	kQTExifUserDataGPSTimeStamp = $67700007; { 3 RATIONALs }
	kQTExifUserDataGPSSatellites = $67700008; { n ASCIIs }
	kQTExifUserDataGPSStatus = $67700009; { 2 ASCIIs }
	kQTExifUserDataGPSMeasureMode = $6770000A; { 2 ASCIIs }
	kQTExifUserDataGPSDOP = $6770000B; { 1 RATIONAL }
	kQTExifUserDataGPSSpeedRef = $6770000C; { 2 ASCIIs }
	kQTExifUserDataGPSSpeed = $6770000D; { 1 RATIONAL }
	kQTExifUserDataGPSTrackRef = $6770000E; { 2 ASCIIs }
	kQTExifUserDataGPSTrack = $6770000F; { 1 RATIONAL }
	kQTExifUserDataGPSImgDirectionRef = $67700010; { 2 ASCIIs }
	kQTExifUserDataGPSImgDirection = $67700011; { 1 RATIONAL }
	kQTExifUserDataGPSMapDatum = $67700012; { n ASCII }
	kQTExifUserDataGPSDestLatitudeRef = $67700013; { 2 ASCIIs }
	kQTExifUserDataGPSDestLatitude = $67700014; { 3 RATIONALs }
	kQTExifUserDataGPSDestLongitudeRef = $67700015; { 2 ASCIIs }
	kQTExifUserDataGPSDestLongitude = $67700016; { 3 RATIONALs }
	kQTExifUserDataGPSDestBearingRef = $67700017; { 2 ASCIIs }
	kQTExifUserDataGPSDestBearing = $67700018; { 1 RATIONAL }
	kQTExifUserDataGPSDestDistanceRef = $67700019; { 2 ASCIIs }
	kQTExifUserDataGPSDestDistance = $6770001A; { 1 RATIONAL }


{* These are GraphicsImport procedures *}
{
 *  GraphicsImportSetDataReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSetDataReference( ci: GraphicsImportComponent; dataRef: Handle; dataReType: OSType ): ComponentResult; external name '_GraphicsImportSetDataReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetDataReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetDataReference( ci: GraphicsImportComponent; var dataRef: Handle; var dataReType: OSType ): ComponentResult; external name '_GraphicsImportGetDataReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetDataFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSetDataFile( ci: GraphicsImportComponent; const (*var*) theFile: FSSpec ): ComponentResult; external name '_GraphicsImportSetDataFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetDataFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetDataFile( ci: GraphicsImportComponent; var theFile: FSSpec ): ComponentResult; external name '_GraphicsImportGetDataFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetDataHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSetDataHandle( ci: GraphicsImportComponent; h: Handle ): ComponentResult; external name '_GraphicsImportSetDataHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetDataHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetDataHandle( ci: GraphicsImportComponent; var h: Handle ): ComponentResult; external name '_GraphicsImportGetDataHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetImageDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetImageDescription( ci: GraphicsImportComponent; var desc: ImageDescriptionHandle ): ComponentResult; external name '_GraphicsImportGetImageDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetDataOffsetAndSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetDataOffsetAndSize( ci: GraphicsImportComponent; var offset: UNSIGNEDLONG; var size: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsImportGetDataOffsetAndSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportReadData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportReadData( ci: GraphicsImportComponent; dataPtr: UnivPtr; dataOffset: UNSIGNEDLONG; dataSize: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsImportReadData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetClip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSetClip( ci: GraphicsImportComponent; clipRgn: RgnHandle ): ComponentResult; external name '_GraphicsImportSetClip';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetClip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetClip( ci: GraphicsImportComponent; var clipRgn: RgnHandle ): ComponentResult; external name '_GraphicsImportGetClip';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetSourceRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSetSourceRect( ci: GraphicsImportComponent; const (*var*) sourceRect: Rect ): ComponentResult; external name '_GraphicsImportSetSourceRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetSourceRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetSourceRect( ci: GraphicsImportComponent; var sourceRect: Rect ): ComponentResult; external name '_GraphicsImportGetSourceRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetNaturalBounds()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetNaturalBounds( ci: GraphicsImportComponent; var naturalBounds: Rect ): ComponentResult; external name '_GraphicsImportGetNaturalBounds';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportDraw()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportDraw( ci: GraphicsImportComponent ): ComponentResult; external name '_GraphicsImportDraw';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSetGWorld( ci: GraphicsImportComponent; port: CGrafPtr; gd: GDHandle ): ComponentResult; external name '_GraphicsImportSetGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetGWorld( ci: GraphicsImportComponent; var port: CGrafPtr; var gd: GDHandle ): ComponentResult; external name '_GraphicsImportGetGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSetMatrix( ci: GraphicsImportComponent; const (*var*) matrix: MatrixRecord ): ComponentResult; external name '_GraphicsImportSetMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetMatrix( ci: GraphicsImportComponent; var matrix: MatrixRecord ): ComponentResult; external name '_GraphicsImportGetMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetBoundsRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSetBoundsRect( ci: GraphicsImportComponent; const (*var*) bounds: Rect ): ComponentResult; external name '_GraphicsImportSetBoundsRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetBoundsRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetBoundsRect( ci: GraphicsImportComponent; var bounds: Rect ): ComponentResult; external name '_GraphicsImportGetBoundsRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSaveAsPicture()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSaveAsPicture( ci: GraphicsImportComponent; const (*var*) fss: FSSpec; scriptTag: ScriptCode ): ComponentResult; external name '_GraphicsImportSaveAsPicture';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetGraphicsMode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSetGraphicsMode( ci: GraphicsImportComponent; graphicsMode: SIGNEDLONG; const (*var*) opColor: RGBColor ): ComponentResult; external name '_GraphicsImportSetGraphicsMode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetGraphicsMode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetGraphicsMode( ci: GraphicsImportComponent; var graphicsMode: SIGNEDLONG; var opColor: RGBColor ): ComponentResult; external name '_GraphicsImportGetGraphicsMode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetQuality()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSetQuality( ci: GraphicsImportComponent; quality: CodecQ ): ComponentResult; external name '_GraphicsImportSetQuality';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetQuality()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetQuality( ci: GraphicsImportComponent; var quality: CodecQ ): ComponentResult; external name '_GraphicsImportGetQuality';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSaveAsQuickTimeImageFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSaveAsQuickTimeImageFile( ci: GraphicsImportComponent; const (*var*) fss: FSSpec; scriptTag: ScriptCode ): ComponentResult; external name '_GraphicsImportSaveAsQuickTimeImageFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetDataReferenceOffsetAndLimit()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSetDataReferenceOffsetAndLimit( ci: GraphicsImportComponent; offset: UNSIGNEDLONG; limit: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsImportSetDataReferenceOffsetAndLimit';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetDataReferenceOffsetAndLimit()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetDataReferenceOffsetAndLimit( ci: GraphicsImportComponent; var offset: UNSIGNEDLONG; var limit: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsImportGetDataReferenceOffsetAndLimit';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetAliasedDataReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetAliasedDataReference( ci: GraphicsImportComponent; var dataRef: Handle; var dataRefType: OSType ): ComponentResult; external name '_GraphicsImportGetAliasedDataReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportValidate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportValidate( ci: GraphicsImportComponent; var valid: Boolean ): ComponentResult; external name '_GraphicsImportValidate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetMetaData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetMetaData( ci: GraphicsImportComponent; userData: UnivPtr ): ComponentResult; external name '_GraphicsImportGetMetaData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetMIMETypeList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetMIMETypeList( ci: GraphicsImportComponent; qtAtomContainerPtr: UnivPtr ): ComponentResult; external name '_GraphicsImportGetMIMETypeList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportDoesDrawAllPixels()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportDoesDrawAllPixels( ci: GraphicsImportComponent; var drawsAllPixels: SInt16 ): ComponentResult; external name '_GraphicsImportDoesDrawAllPixels';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetAsPicture()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetAsPicture( ci: GraphicsImportComponent; var picture: PicHandle ): ComponentResult; external name '_GraphicsImportGetAsPicture';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportExportImageFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportExportImageFile( ci: GraphicsImportComponent; fileType: OSType; fileCreator: OSType; const (*var*) fss: FSSpec; scriptTag: ScriptCode ): ComponentResult; external name '_GraphicsImportExportImageFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetExportImageTypeList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetExportImageTypeList( ci: GraphicsImportComponent; qtAtomContainerPtr: UnivPtr ): ComponentResult; external name '_GraphicsImportGetExportImageTypeList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportDoExportImageFileDialog()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportDoExportImageFileDialog( ci: GraphicsImportComponent; const (*var*) inDefaultSpec: FSSpec; prompt: StringPtr; filterProc: ModalFilterYDUPP; var outExportedType: OSType; var outExportedSpec: FSSpec; var outScriptTag: ScriptCode ): ComponentResult; external name '_GraphicsImportDoExportImageFileDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetExportSettingsAsAtomContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetExportSettingsAsAtomContainer( ci: GraphicsImportComponent; qtAtomContainerPtr: UnivPtr ): ComponentResult; external name '_GraphicsImportGetExportSettingsAsAtomContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetExportSettingsFromAtomContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSetExportSettingsFromAtomContainer( ci: GraphicsImportComponent; qtAtomContainer: UnivPtr ): ComponentResult; external name '_GraphicsImportSetExportSettingsFromAtomContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetProgressProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportSetProgressProc( ci: GraphicsImportComponent; progressProc: ICMProgressProcRecordPtr ): ComponentResult; external name '_GraphicsImportSetProgressProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetProgressProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImportGetProgressProc( ci: GraphicsImportComponent; progressProc: ICMProgressProcRecordPtr ): ComponentResult; external name '_GraphicsImportGetProgressProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetImageCount()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportGetImageCount( ci: GraphicsImportComponent; var imageCount: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsImportGetImageCount';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetImageIndex()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportSetImageIndex( ci: GraphicsImportComponent; imageIndex: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsImportSetImageIndex';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetImageIndex()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportGetImageIndex( ci: GraphicsImportComponent; var imageIndex: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsImportGetImageIndex';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetDataOffsetAndSize64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportGetDataOffsetAndSize64( ci: GraphicsImportComponent; var offset: wide; var size: wide ): ComponentResult; external name '_GraphicsImportGetDataOffsetAndSize64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportReadData64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportReadData64( ci: GraphicsImportComponent; dataPtr: UnivPtr; const (*var*) dataOffset: wide; dataSize: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsImportReadData64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetDataReferenceOffsetAndLimit64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportSetDataReferenceOffsetAndLimit64( ci: GraphicsImportComponent; const (*var*) offset: wide; const (*var*) limit: wide ): ComponentResult; external name '_GraphicsImportSetDataReferenceOffsetAndLimit64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetDataReferenceOffsetAndLimit64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportGetDataReferenceOffsetAndLimit64( ci: GraphicsImportComponent; var offset: wide; var limit: wide ): ComponentResult; external name '_GraphicsImportGetDataReferenceOffsetAndLimit64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetDefaultMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportGetDefaultMatrix( ci: GraphicsImportComponent; var defaultMatrix: MatrixRecord ): ComponentResult; external name '_GraphicsImportGetDefaultMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetDefaultClip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportGetDefaultClip( ci: GraphicsImportComponent; var defaultRgn: RgnHandle ): ComponentResult; external name '_GraphicsImportGetDefaultClip';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetDefaultGraphicsMode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportGetDefaultGraphicsMode( ci: GraphicsImportComponent; var defaultGraphicsMode: SIGNEDLONG; var defaultOpColor: RGBColor ): ComponentResult; external name '_GraphicsImportGetDefaultGraphicsMode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetDefaultSourceRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportGetDefaultSourceRect( ci: GraphicsImportComponent; var defaultSourceRect: Rect ): ComponentResult; external name '_GraphicsImportGetDefaultSourceRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetColorSyncProfile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportGetColorSyncProfile( ci: GraphicsImportComponent; var profile: Handle ): ComponentResult; external name '_GraphicsImportGetColorSyncProfile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetDestRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportSetDestRect( ci: GraphicsImportComponent; const (*var*) destRect: Rect ): ComponentResult; external name '_GraphicsImportSetDestRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetDestRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportGetDestRect( ci: GraphicsImportComponent; var destRect: Rect ): ComponentResult; external name '_GraphicsImportGetDestRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportSetFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportSetFlags( ci: GraphicsImportComponent; flags: SIGNEDLONG ): ComponentResult; external name '_GraphicsImportSetFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImportGetFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsImportGetFlags( ci: GraphicsImportComponent; var flags: SIGNEDLONG ): ComponentResult; external name '_GraphicsImportGetFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ 2 private selectors }
{
 *  GraphicsImportGetBaseDataOffsetAndSize64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.1 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.4 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0.2 and later
 *    Windows:          in qtmlClient.lib 5.0.2 and later
 }
function GraphicsImportGetBaseDataOffsetAndSize64( ci: GraphicsImportComponent; var offset: wide; var size: wide ): ComponentResult; external name '_GraphicsImportGetBaseDataOffsetAndSize64';
(* AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER *)


{
 *  GraphicsImportSetImageIndexToThumbnail()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function GraphicsImportSetImageIndexToThumbnail( ci: GraphicsImportComponent ): ComponentResult; external name '_GraphicsImportSetImageIndexToThumbnail';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{$ifc TARGET_API_MAC_OSX}
{
 *  GraphicsImportCreateCGImage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GraphicsImportCreateCGImage( ci: GraphicsImportComponent; var imageRefOut: CGImageRef; flags: UInt32 ): ComponentResult; external name '_GraphicsImportCreateCGImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{$endc} {TARGET_API_MAC_OSX}

{
 *  GraphicsImportSaveAsPictureToDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function GraphicsImportSaveAsPictureToDataRef( ci: GraphicsImportComponent; dataRef: Handle; dataRefType: OSType ): ComponentResult; external name '_GraphicsImportSaveAsPictureToDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  GraphicsImportSaveAsQuickTimeImageFileToDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function GraphicsImportSaveAsQuickTimeImageFileToDataRef( ci: GraphicsImportComponent; dataRef: Handle; dataRefType: OSType ): ComponentResult; external name '_GraphicsImportSaveAsQuickTimeImageFileToDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  GraphicsImportExportImageFileToDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function GraphicsImportExportImageFileToDataRef( ci: GraphicsImportComponent; fileType: OSType; fileCreator: OSType; dataRef: Handle; dataRefType: OSType ): ComponentResult; external name '_GraphicsImportExportImageFileToDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  GraphicsImportDoExportImageFileToDataRefDialog()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function GraphicsImportDoExportImageFileToDataRefDialog( ci: GraphicsImportComponent; inDataRef: Handle; inDataRefType: OSType; prompt: CFStringRef; filterProc: ModalFilterYDUPP; var outExportedType: OSType; var outDataRef: Handle; var outDataRefType: OSType ): ComponentResult; external name '_GraphicsImportDoExportImageFileToDataRefDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{$ifc TARGET_API_MAC_OSX}
{ NOTE: If the source override ColorSync profile is NULL, then the image's ColorSync profile may be used if available, otherwise a generic ColorSync profile may be used. }
{
 *  GraphicsImportSetOverrideSourceColorSyncProfileRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GraphicsImportSetOverrideSourceColorSyncProfileRef( ci: GraphicsImportComponent; newOverrideSourceProfileRef: CMProfileRef ): ComponentResult; external name '_GraphicsImportSetOverrideSourceColorSyncProfileRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  GraphicsImportGetOverrideSourceColorSyncProfileRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GraphicsImportGetOverrideSourceColorSyncProfileRef( ci: GraphicsImportComponent; var outOverrideSourceProfileRef: CMProfileRef ): ComponentResult; external name '_GraphicsImportGetOverrideSourceColorSyncProfileRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{ NOTE: If the destination ColorSync profile is NULL, then a generic ColorSync profile may be used. }
{
 *  GraphicsImportSetDestinationColorSyncProfileRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GraphicsImportSetDestinationColorSyncProfileRef( ci: GraphicsImportComponent; newDestinationProfileRef: CMProfileRef ): ComponentResult; external name '_GraphicsImportSetDestinationColorSyncProfileRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  GraphicsImportGetDestinationColorSyncProfileRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GraphicsImportGetDestinationColorSyncProfileRef( ci: GraphicsImportComponent; var destinationProfileRef: CMProfileRef ): ComponentResult; external name '_GraphicsImportGetDestinationColorSyncProfileRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{$endc} {TARGET_API_MAC_OSX}

{
 *  GraphicsImportWillUseColorMatching()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function GraphicsImportWillUseColorMatching( ci: GraphicsImportComponent; var outWillMatch: Boolean ): ComponentResult; external name '_GraphicsImportWillUseColorMatching';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{$ifc TARGET_API_MAC_OSX}
{ This convenience API is implemented by the base graphics importer for format-specific importers. }
{
 *  GraphicsImportGetGenericColorSyncProfile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GraphicsImportGetGenericColorSyncProfile( ci: GraphicsImportComponent; pixelFormat: OSType; reservedSetToNULL: UnivPtr; flags: UInt32; var genericColorSyncProfileOut: Handle ): ComponentResult; external name '_GraphicsImportGetGenericColorSyncProfile';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{$endc} {TARGET_API_MAC_OSX}

{ Format-specific importers that implement GetColorSyncProfile and that want the base graphics 
   importer to automatically support ColorSync matching should:
   (a) implement GraphicsImportSetReturnGenericColorSyncProfile; when it is called, set an internal flag
   (b) change GraphicsImportGetColorSyncProfile so that, if this internal flag is set,
       when the source image file contains a profile 
       and the kGraphicsImporterDontUseColorMatching flag is NOT set,
       it returns a generic profile of the appropriate colorspace instead.
   Other importers should *not* implement GraphicsImportSetReturnGenericColorSyncProfile. }
{ WARNING: Applications should not call this API; it is internal graphics importer plumbing.
   Set kGraphicsImporterDontUseColorMatching instead. }
{
 *  GraphicsImportSetReturnGenericColorSyncProfile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function GraphicsImportSetReturnGenericColorSyncProfile( ci: GraphicsImportComponent; returnGenericProfilesUnlessDontMatchFlagSet: Boolean ): ComponentResult; external name '_GraphicsImportSetReturnGenericColorSyncProfile';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{ WARNING: Applications should not call this API; it is internal graphics importer plumbing. }
{
 *  GraphicsImportGetReturnGenericColorSyncProfile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function GraphicsImportGetReturnGenericColorSyncProfile( ci: GraphicsImportComponent; var returnGenericProfilesUnlessDontMatchFlagSet: Boolean ): ComponentResult; external name '_GraphicsImportGetReturnGenericColorSyncProfile';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


type
	GraphicsExportComponent = ComponentInstance;
const
	GraphicsExporterComponentType = FourCharCode('grex');
	kBaseGraphicsExporterSubType = FourCharCode('base');

{ Component flags for Graphics Exporter components }
const
	graphicsExporterIsBaseExporter = 1 shl 0;
	graphicsExporterCanTranscode = 1 shl 1;
	graphicsExporterUsesImageCompressor = 1 shl 2;

type
	QTResolutionSettingsPtr = ^QTResolutionSettings;
	QTResolutionSettings = record
		horizontalResolution: Fixed;
		verticalResolution: Fixed;
	end;
type
	QTTargetDataSizePtr = ^QTTargetDataSize;
	QTTargetDataSize = record
		targetDataSize: UNSIGNEDLONG;
	end;
type
	QTThumbnailSettingsPtr = ^QTThumbnailSettings;
	QTThumbnailSettings = record
		enableThumbnail: SIGNEDLONG;        { a thoroughly padded Boolean}
		maxThumbnailWidth: SIGNEDLONG;      { set to zero to let someone else decide}
		maxThumbnailHeight: SIGNEDLONG;     { set to zero to let someone else decide}
	end;
const
	kQTResolutionSettings = FourCharCode('reso');
	kQTTargetDataSize = FourCharCode('dasz');
	kQTDontRecompress = FourCharCode('dntr');
	kQTInterlaceStyle = FourCharCode('ilac');
	kQTColorSyncProfile = FourCharCode('iccp');
	kQTThumbnailSettings = FourCharCode('thum');
	kQTEnableExif = FourCharCode('exif'); { UInt8 (boolean)}
	kQTMetaData = FourCharCode('meta');

const
	kQTTIFFCompressionMethod = FourCharCode('tifc'); { UInt32}
	kQTTIFFCompression_None = 1;
	kQTTIFFCompression_PackBits = 32773;
	kQTTIFFLittleEndian = FourCharCode('tife'); { UInt8 (boolean)}

const
	kQTPNGFilterPreference = FourCharCode('pngf'); { UInt32}
	kQTPNGFilterBestForColorType = FourCharCode('bflt');
	kQTPNGFilterNone = 0;
	kQTPNGFilterSub = 1;
	kQTPNGFilterUp = 2;
	kQTPNGFilterAverage = 3;
	kQTPNGFilterPaeth = 4;
	kQTPNGFilterAdaptivePerRow = FourCharCode('aflt');
	kQTPNGInterlaceStyle = FourCharCode('ilac'); { UInt32}
	kQTPNGInterlaceNone = 0;
	kQTPNGInterlaceAdam7 = 1;

const
	kQTJPEGQuantizationTables = FourCharCode('jpqt');
	kQTJPEGHuffmanTables = FourCharCode('jpht');


{* These are GraphicsExport procedures *}
{ To use: set the input and output (and other settings as desired) and call GEDoExport. }
{
 *  GraphicsExportDoExport()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportDoExport( ci: GraphicsExportComponent; var actualSizeWritten: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportDoExport';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Used for internal communication between the base and format-specific graphics exporter: }
{
 *  GraphicsExportCanTranscode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportCanTranscode( ci: GraphicsExportComponent; var canTranscode: Boolean ): ComponentResult; external name '_GraphicsExportCanTranscode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportDoTranscode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportDoTranscode( ci: GraphicsExportComponent ): ComponentResult; external name '_GraphicsExportDoTranscode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportCanUseCompressor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportCanUseCompressor( ci: GraphicsExportComponent; var canUseCompressor: Boolean; codecSettingsAtomContainerPtr: UnivPtr ): ComponentResult; external name '_GraphicsExportCanUseCompressor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportDoUseCompressor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportDoUseCompressor( ci: GraphicsExportComponent; codecSettingsAtomContainer: UnivPtr; var outDesc: ImageDescriptionHandle ): ComponentResult; external name '_GraphicsExportDoUseCompressor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportDoStandaloneExport()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportDoStandaloneExport( ci: GraphicsExportComponent ): ComponentResult; external name '_GraphicsExportDoStandaloneExport';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Queries applications can make of a format-specific graphics exporter: }
{
 *  GraphicsExportGetDefaultFileTypeAndCreator()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetDefaultFileTypeAndCreator( ci: GraphicsExportComponent; var fileType: OSType; var fileCreator: OSType ): ComponentResult; external name '_GraphicsExportGetDefaultFileTypeAndCreator';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetDefaultFileNameExtension()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetDefaultFileNameExtension( ci: GraphicsExportComponent; var fileNameExtension: OSType ): ComponentResult; external name '_GraphicsExportGetDefaultFileNameExtension';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetMIMETypeList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetMIMETypeList( ci: GraphicsExportComponent; qtAtomContainerPtr: UnivPtr ): ComponentResult; external name '_GraphicsExportGetMIMETypeList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ (1 unused selector) }
{ Graphics exporter settings: }
{
 *  GraphicsExportRequestSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportRequestSettings( ci: GraphicsExportComponent; filterProc: ModalFilterYDUPP; yourDataProc: UnivPtr ): ComponentResult; external name '_GraphicsExportRequestSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetSettingsFromAtomContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetSettingsFromAtomContainer( ci: GraphicsExportComponent; qtAtomContainer: UnivPtr ): ComponentResult; external name '_GraphicsExportSetSettingsFromAtomContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetSettingsAsAtomContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetSettingsAsAtomContainer( ci: GraphicsExportComponent; qtAtomContainerPtr: UnivPtr ): ComponentResult; external name '_GraphicsExportGetSettingsAsAtomContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetSettingsAsText()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetSettingsAsText( ci: GraphicsExportComponent; var theText: Handle ): ComponentResult; external name '_GraphicsExportGetSettingsAsText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Graphics exporters may implement some or none of the following: }
{
 *  GraphicsExportSetDontRecompress()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetDontRecompress( ci: GraphicsExportComponent; dontRecompress: Boolean ): ComponentResult; external name '_GraphicsExportSetDontRecompress';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetDontRecompress()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetDontRecompress( ci: GraphicsExportComponent; var dontRecompress: Boolean ): ComponentResult; external name '_GraphicsExportGetDontRecompress';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetInterlaceStyle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetInterlaceStyle( ci: GraphicsExportComponent; interlaceStyle: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportSetInterlaceStyle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetInterlaceStyle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInterlaceStyle( ci: GraphicsExportComponent; var interlaceStyle: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportGetInterlaceStyle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetMetaData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetMetaData( ci: GraphicsExportComponent; userData: UnivPtr ): ComponentResult; external name '_GraphicsExportSetMetaData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetMetaData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetMetaData( ci: GraphicsExportComponent; userData: UnivPtr ): ComponentResult; external name '_GraphicsExportGetMetaData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetTargetDataSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetTargetDataSize( ci: GraphicsExportComponent; targetDataSize: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportSetTargetDataSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetTargetDataSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetTargetDataSize( ci: GraphicsExportComponent; var targetDataSize: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportGetTargetDataSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetCompressionMethod()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetCompressionMethod( ci: GraphicsExportComponent; compressionMethod: SIGNEDLONG ): ComponentResult; external name '_GraphicsExportSetCompressionMethod';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetCompressionMethod()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetCompressionMethod( ci: GraphicsExportComponent; var compressionMethod: SIGNEDLONG ): ComponentResult; external name '_GraphicsExportGetCompressionMethod';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetCompressionQuality()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetCompressionQuality( ci: GraphicsExportComponent; spatialQuality: CodecQ ): ComponentResult; external name '_GraphicsExportSetCompressionQuality';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetCompressionQuality()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetCompressionQuality( ci: GraphicsExportComponent; var spatialQuality: CodecQ ): ComponentResult; external name '_GraphicsExportGetCompressionQuality';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetResolution()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetResolution( ci: GraphicsExportComponent; horizontalResolution: Fixed; verticalResolution: Fixed ): ComponentResult; external name '_GraphicsExportSetResolution';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetResolution()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetResolution( ci: GraphicsExportComponent; var horizontalResolution: Fixed; var verticalResolution: Fixed ): ComponentResult; external name '_GraphicsExportGetResolution';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetDepth()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetDepth( ci: GraphicsExportComponent; depth: SIGNEDLONG ): ComponentResult; external name '_GraphicsExportSetDepth';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetDepth()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetDepth( ci: GraphicsExportComponent; var depth: SIGNEDLONG ): ComponentResult; external name '_GraphicsExportGetDepth';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ (2 unused selectors) }
{
 *  GraphicsExportSetColorSyncProfile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetColorSyncProfile( ci: GraphicsExportComponent; colorSyncProfile: Handle ): ComponentResult; external name '_GraphicsExportSetColorSyncProfile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetColorSyncProfile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetColorSyncProfile( ci: GraphicsExportComponent; var colorSyncProfile: Handle ): ComponentResult; external name '_GraphicsExportGetColorSyncProfile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Always implemented by the base graphics exporter: }
{
 *  GraphicsExportSetProgressProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetProgressProc( ci: GraphicsExportComponent; progressProc: ICMProgressProcRecordPtr ): ComponentResult; external name '_GraphicsExportSetProgressProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetProgressProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetProgressProc( ci: GraphicsExportComponent; progressProc: ICMProgressProcRecordPtr ): ComponentResult; external name '_GraphicsExportGetProgressProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Sources for the input image: }
{
 *  GraphicsExportSetInputDataReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetInputDataReference( ci: GraphicsExportComponent; dataRef: Handle; dataRefType: OSType; desc: ImageDescriptionHandle ): ComponentResult; external name '_GraphicsExportSetInputDataReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetInputDataReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInputDataReference( ci: GraphicsExportComponent; var dataRef: Handle; var dataRefType: OSType ): ComponentResult; external name '_GraphicsExportGetInputDataReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetInputFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetInputFile( ci: GraphicsExportComponent; const (*var*) theFile: FSSpec; desc: ImageDescriptionHandle ): ComponentResult; external name '_GraphicsExportSetInputFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetInputFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInputFile( ci: GraphicsExportComponent; var theFile: FSSpec ): ComponentResult; external name '_GraphicsExportGetInputFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetInputHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetInputHandle( ci: GraphicsExportComponent; h: Handle; desc: ImageDescriptionHandle ): ComponentResult; external name '_GraphicsExportSetInputHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetInputHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInputHandle( ci: GraphicsExportComponent; var h: Handle ): ComponentResult; external name '_GraphicsExportGetInputHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetInputPtr()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetInputPtr( ci: GraphicsExportComponent; p: Ptr; size: UNSIGNEDLONG; desc: ImageDescriptionHandle ): ComponentResult; external name '_GraphicsExportSetInputPtr';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetInputPtr()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInputPtr( ci: GraphicsExportComponent; var p: Ptr; var size: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportGetInputPtr';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetInputGraphicsImporter()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetInputGraphicsImporter( ci: GraphicsExportComponent; grip: GraphicsImportComponent ): ComponentResult; external name '_GraphicsExportSetInputGraphicsImporter';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetInputGraphicsImporter()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInputGraphicsImporter( ci: GraphicsExportComponent; var grip: GraphicsImportComponent ): ComponentResult; external name '_GraphicsExportGetInputGraphicsImporter';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetInputPicture()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetInputPicture( ci: GraphicsExportComponent; picture: PicHandle ): ComponentResult; external name '_GraphicsExportSetInputPicture';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetInputPicture()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInputPicture( ci: GraphicsExportComponent; var picture: PicHandle ): ComponentResult; external name '_GraphicsExportGetInputPicture';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetInputGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetInputGWorld( ci: GraphicsExportComponent; gworld: GWorldPtr ): ComponentResult; external name '_GraphicsExportSetInputGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetInputGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInputGWorld( ci: GraphicsExportComponent; var gworld: GWorldPtr ): ComponentResult; external name '_GraphicsExportGetInputGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetInputPixmap()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetInputPixmap( ci: GraphicsExportComponent; pixmap: PixMapHandle ): ComponentResult; external name '_GraphicsExportSetInputPixmap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetInputPixmap()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInputPixmap( ci: GraphicsExportComponent; var pixmap: PixMapHandle ): ComponentResult; external name '_GraphicsExportGetInputPixmap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Only applicable when the input is a data reference, file, handle or ptr: }
{
 *  GraphicsExportSetInputOffsetAndLimit()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetInputOffsetAndLimit( ci: GraphicsExportComponent; offset: UNSIGNEDLONG; limit: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportSetInputOffsetAndLimit';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetInputOffsetAndLimit()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInputOffsetAndLimit( ci: GraphicsExportComponent; var offset: UNSIGNEDLONG; var limit: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportGetInputOffsetAndLimit';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Used by format-specific graphics exporters when transcoding: }
{
 *  GraphicsExportMayExporterReadInputData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportMayExporterReadInputData( ci: GraphicsExportComponent; var mayReadInputData: Boolean ): ComponentResult; external name '_GraphicsExportMayExporterReadInputData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetInputDataSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInputDataSize( ci: GraphicsExportComponent; var size: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportGetInputDataSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportReadInputData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportReadInputData( ci: GraphicsExportComponent; dataPtr: UnivPtr; dataOffset: UNSIGNEDLONG; dataSize: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportReadInputData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Used by format-specific graphics exporters, especially when doing standalone export: }
{
 *  GraphicsExportGetInputImageDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInputImageDescription( ci: GraphicsExportComponent; var desc: ImageDescriptionHandle ): ComponentResult; external name '_GraphicsExportGetInputImageDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetInputImageDimensions()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInputImageDimensions( ci: GraphicsExportComponent; var dimensions: Rect ): ComponentResult; external name '_GraphicsExportGetInputImageDimensions';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetInputImageDepth()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetInputImageDepth( ci: GraphicsExportComponent; var inputDepth: SIGNEDLONG ): ComponentResult; external name '_GraphicsExportGetInputImageDepth';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportDrawInputImage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportDrawInputImage( ci: GraphicsExportComponent; gw: CGrafPtr; gd: GDHandle; const (*var*) srcRect: Rect; const (*var*) dstRect: Rect ): ComponentResult; external name '_GraphicsExportDrawInputImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Destinations for the output image: }
{
 *  GraphicsExportSetOutputDataReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetOutputDataReference( ci: GraphicsExportComponent; dataRef: Handle; dataRefType: OSType ): ComponentResult; external name '_GraphicsExportSetOutputDataReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetOutputDataReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetOutputDataReference( ci: GraphicsExportComponent; var dataRef: Handle; var dataRefType: OSType ): ComponentResult; external name '_GraphicsExportGetOutputDataReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetOutputFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetOutputFile( ci: GraphicsExportComponent; const (*var*) theFile: FSSpec ): ComponentResult; external name '_GraphicsExportSetOutputFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetOutputFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetOutputFile( ci: GraphicsExportComponent; var theFile: FSSpec ): ComponentResult; external name '_GraphicsExportGetOutputFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetOutputHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetOutputHandle( ci: GraphicsExportComponent; h: Handle ): ComponentResult; external name '_GraphicsExportSetOutputHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetOutputHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetOutputHandle( ci: GraphicsExportComponent; var h: Handle ): ComponentResult; external name '_GraphicsExportGetOutputHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetOutputOffsetAndMaxSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetOutputOffsetAndMaxSize( ci: GraphicsExportComponent; offset: UNSIGNEDLONG; maxSize: UNSIGNEDLONG; truncateFile: Boolean ): ComponentResult; external name '_GraphicsExportSetOutputOffsetAndMaxSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetOutputOffsetAndMaxSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetOutputOffsetAndMaxSize( ci: GraphicsExportComponent; var offset: UNSIGNEDLONG; var maxSize: UNSIGNEDLONG; var truncateFile: Boolean ): ComponentResult; external name '_GraphicsExportGetOutputOffsetAndMaxSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetOutputFileTypeAndCreator()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetOutputFileTypeAndCreator( ci: GraphicsExportComponent; fileType: OSType; fileCreator: OSType ): ComponentResult; external name '_GraphicsExportSetOutputFileTypeAndCreator';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetOutputFileTypeAndCreator()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetOutputFileTypeAndCreator( ci: GraphicsExportComponent; var fileType: OSType; var fileCreator: OSType ): ComponentResult; external name '_GraphicsExportGetOutputFileTypeAndCreator';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Used by format-specific graphics exporters: }
{
 *  GraphicsExportWriteOutputData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportWriteOutputData( ci: GraphicsExportComponent; dataPtr: {const} UnivPtr; dataSize: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportWriteOutputData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportSetOutputMark()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportSetOutputMark( ci: GraphicsExportComponent; mark: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportSetOutputMark';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportGetOutputMark()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportGetOutputMark( ci: GraphicsExportComponent; var mark: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportGetOutputMark';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsExportReadOutputData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GraphicsExportReadOutputData( ci: GraphicsExportComponent; dataPtr: UnivPtr; dataOffset: UNSIGNEDLONG; dataSize: UNSIGNEDLONG ): ComponentResult; external name '_GraphicsExportReadOutputData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Allows embedded thumbnail creation, if supported. }
{
 *  GraphicsExportSetThumbnailEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.1 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.4 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0.2 and later
 *    Windows:          in qtmlClient.lib 5.0.2 and later
 }
function GraphicsExportSetThumbnailEnabled( ci: GraphicsExportComponent; enableThumbnail: Boolean; maxThumbnailWidth: SIGNEDLONG; maxThumbnailHeight: SIGNEDLONG ): ComponentResult; external name '_GraphicsExportSetThumbnailEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER *)


{
 *  GraphicsExportGetThumbnailEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.1 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.4 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0.2 and later
 *    Windows:          in qtmlClient.lib 5.0.2 and later
 }
function GraphicsExportGetThumbnailEnabled( ci: GraphicsExportComponent; var thumbnailEnabled: Boolean; var maxThumbnailWidth: SIGNEDLONG; var maxThumbnailHeight: SIGNEDLONG ): ComponentResult; external name '_GraphicsExportGetThumbnailEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER *)


{ Allows export of Exif files, if supported.  This disables Exif-incompatible settings such as grayscale JPEG and compressed TIFF, and enables export of Exif metadata. }
{
 *  GraphicsExportSetExifEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.1 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.4 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0.2 and later
 *    Windows:          in qtmlClient.lib 5.0.2 and later
 }
function GraphicsExportSetExifEnabled( ci: GraphicsExportComponent; enableExif: Boolean ): ComponentResult; external name '_GraphicsExportSetExifEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER *)


{
 *  GraphicsExportGetExifEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.1 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.4 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0.2 and later
 *    Windows:          in qtmlClient.lib 5.0.2 and later
 }
function GraphicsExportGetExifEnabled( ci: GraphicsExportComponent; var exifEnabled: Boolean ): ComponentResult; external name '_GraphicsExportGetExifEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER *)


{$ifc TARGET_API_MAC_OSX}
{
 *  GraphicsExportSetInputCGImage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GraphicsExportSetInputCGImage( ci: GraphicsExportComponent; imageRef: CGImageRef ): ComponentResult; external name '_GraphicsExportSetInputCGImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  GraphicsExportGetInputCGImage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GraphicsExportGetInputCGImage( ci: GraphicsExportComponent; var imageRefOut: CGImageRef ): ComponentResult; external name '_GraphicsExportGetInputCGImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  GraphicsExportSetInputCGBitmapContext()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GraphicsExportSetInputCGBitmapContext( ci: GraphicsExportComponent; bitmapContextRef: CGContextRef ): ComponentResult; external name '_GraphicsExportSetInputCGBitmapContext';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  GraphicsExportGetInputCGBitmapContext()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GraphicsExportGetInputCGBitmapContext( ci: GraphicsExportComponent; var bitmapContextRefOut: CGContextRef ): ComponentResult; external name '_GraphicsExportGetInputCGBitmapContext';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{$endc} {TARGET_API_MAC_OSX}

{
 *  GraphicsExportSetFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GraphicsExportSetFlags( ci: GraphicsExportComponent; flags: UInt32 ): ComponentResult; external name '_GraphicsExportSetFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  GraphicsExportGetFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GraphicsExportGetFlags( ci: GraphicsExportComponent; var flagsOut: UInt32 ): ComponentResult; external name '_GraphicsExportGetFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


type
	ImageTranscoderComponent = ComponentInstance;
const
	ImageTranscodererComponentType = FourCharCode('imtc');


{* These are ImageTranscoder procedures *}
{
 *  ImageTranscoderBeginSequence()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ImageTranscoderBeginSequence( itc: ImageTranscoderComponent; srcDesc: ImageDescriptionHandle; var dstDesc: ImageDescriptionHandle; data: UnivPtr; dataSize: SIGNEDLONG ): ComponentResult; external name '_ImageTranscoderBeginSequence';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ImageTranscoderConvert()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ImageTranscoderConvert( itc: ImageTranscoderComponent; srcData: UnivPtr; srcDataSize: SIGNEDLONG; var dstData: UnivPtr; var dstDataSize: SIGNEDLONG ): ComponentResult; external name '_ImageTranscoderConvert';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ImageTranscoderDisposeData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ImageTranscoderDisposeData( itc: ImageTranscoderComponent; dstData: UnivPtr ): ComponentResult; external name '_ImageTranscoderDisposeData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ImageTranscoderEndSequence()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ImageTranscoderEndSequence( itc: ImageTranscoderComponent ): ComponentResult; external name '_ImageTranscoderEndSequence';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


//#if (MAC_OS_X_VERSION_MAX_ALLOWED == MAC_OS_X_VERSION_10_2) || //!defined(kComponentPropertyListenerCollectionContextVersion)

{ MixedMode ProcInfo constants for component property calls }
const
	uppCallComponentGetComponentPropertyInfoProcInfo = $0003FFF0;
	uppCallComponentGetComponentPropertyProcInfo = $0003FFF0;
	uppCallComponentSetComponentPropertyProcInfo = $0000FFF0;
	uppCallComponentAddComponentPropertyListenerProcInfo = $0000FFF0;
	uppCallComponentRemoveComponentPropertyListenerProcInfo = $0000FFF0;


{ == CallComponentGetComponentPropertyInfo flags == }
const
	kComponentPropertyFlagCanSetLater = 1 shl 0;
	kComponentPropertyFlagCanSetNow = 1 shl 1;
	kComponentPropertyFlagCanGetLater = 1 shl 2;
	kComponentPropertyFlagCanGetNow = 1 shl 3;
	kComponentPropertyFlagHasExtendedInfo = 1 shl 4;
	kComponentPropertyFlagValueMustBeReleased = 1 shl 5;
	kComponentPropertyFlagValueIsCFTypeRef = 1 shl 6;
	kComponentPropertyFlagGetBufferMustBeInitialized = 1 shl 7;
	kComponentPropertyFlagWillNotifyListeners = 1 shl 8;


type
	ComponentPropertyClass = OSType;
	ComponentPropertyClassPtr = ^ComponentPropertyClass;
	ComponentPropertyID = OSType;
	ComponentPropertyIDPtr = ^ComponentPropertyID;
	ComponentValueType = OSType;
	ComponentValueTypePtr = ^ComponentValueType;
	ComponentValuePtr = UnivPtr;
	ComponentValuePtrPtr = ^ComponentValuePtr;
	ConstComponentValuePtr = {const} UnivPtr;
	ConstComponentValuePtrPtr = ^ConstComponentValuePtr;

{ == standard property class constants == }
const
	kComponentPropertyClassPropertyInfo = FourCharCode('pnfo'); { property info class }
                                        { property info property IDs }
	kComponentPropertyInfoList = FourCharCode('list'); { array of ComponentPropertyInfo (CFData), one for each property }
	kComponentPropertyCacheSeed = FourCharCode('seed'); { property cache seed value }
	kComponentPropertyCacheFlags = FourCharCode('flgs'); { see kComponentPropertyCache flags }
	kComponentPropertyExtendedInfo = FourCharCode('meta'); { CFDictionary with extended property information}


{ values for kComponentPropertyClassPropertyInfo/kComponentPropertyCacheFlags standard component property }
const
	kComponentPropertyCacheFlagNotPersistent = 1 shl 0; { property metadata should not be saved in persistent cache}
	kComponentPropertyCacheFlagIsDynamic = 1 shl 1; { property metadata should not cached at all}


type
	ComponentPropertyInfoPtr = ^ComponentPropertyInfo;
	ComponentPropertyInfo = record
		propClass: ComponentPropertyClass;
		propID: ComponentPropertyID;
		propType: ComponentValueType;
		propSize: ByteCount;
		propFlags: UInt32;
	end;


//#endif  { #MAC_OS_X_VERSION_10_3 <= MAC_OS_X_VERSION_MAX_ALLOWED } 


{ == "QT" prefixed Component Property calls == }

type
	QTComponentPropertyListenerProcPtr = procedure( inComponent: ComponentInstance; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inUserData: UnivPtr );
	QTComponentPropertyListenerUPP = QTComponentPropertyListenerProcPtr;

{
 *  QTGetComponentPropertyInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTGetComponentPropertyInfo( inComponent: ComponentInstance; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; outPropType: ComponentValueTypePtr { can be NULL }; outPropValueSize: ByteCountPtr { can be NULL }; outPropertyFlags: UInt32Ptr { can be NULL } ): ComponentResult; external name '_QTGetComponentPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTGetComponentProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTGetComponentProperty( inComponent: ComponentInstance; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; outPropValueAddress: ComponentValuePtr; outPropValueSizeUsed: ByteCountPtr { can be NULL } ): ComponentResult; external name '_QTGetComponentProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTSetComponentProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTSetComponentProperty( inComponent: ComponentInstance; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstComponentValuePtr ): ComponentResult; external name '_QTSetComponentProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTAddComponentPropertyListener()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTAddComponentPropertyListener( inComponent: ComponentInstance; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inDispatchProc: QTComponentPropertyListenerUPP; inUserData: UnivPtr { can be NULL } ): ComponentResult; external name '_QTAddComponentPropertyListener';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTRemoveComponentPropertyListener()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTRemoveComponentPropertyListener( inComponent: ComponentInstance; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inDispatchProc: QTComponentPropertyListenerUPP; inUserData: UnivPtr { can be NULL } ): ComponentResult; external name '_QTRemoveComponentPropertyListener';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{ == "QT" prefixed Component Property Listener helpers == }


type
  QTComponentPropertyListenerCollectionContextPtr = ^QTComponentPropertyListenerCollectionContext;
	QTComponentPropertyListenersRef = CFTypeRef;
	QTComponentPropertyListenerFilterProcPtr = function( inCollection: QTComponentPropertyListenersRef; inCollectionContext: QTComponentPropertyListenerCollectionContextPtr { ptr to avoid circular reference with QTComponentPropertyListenerCollectionContext}; inNotifier: ComponentInstance; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inListenerCallbackProc: QTComponentPropertyListenerUPP; inListenerProcRefCon: {const} UnivPtr; inFilterProcRefCon: {const} UnivPtr ): Boolean;
	QTComponentPropertyListenerFilterUPP = QTComponentPropertyListenerFilterProcPtr;
	QTComponentPropertyListenerCollectionContext = record
		version: UInt32;                { struct version }
		filterProcUPP: QTComponentPropertyListenerFilterUPP;
		filterProcData: UnivPtr;
	end;
const
	kQTComponentPropertyListenerCollectionContextVersion = 1;

{
 *  NewQTComponentPropertyListenerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewQTComponentPropertyListenerUPP( userRoutine: QTComponentPropertyListenerProcPtr ): QTComponentPropertyListenerUPP; external name '_NewQTComponentPropertyListenerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  NewQTComponentPropertyListenerFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewQTComponentPropertyListenerFilterUPP( userRoutine: QTComponentPropertyListenerFilterProcPtr ): QTComponentPropertyListenerFilterUPP; external name '_NewQTComponentPropertyListenerFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  DisposeQTComponentPropertyListenerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeQTComponentPropertyListenerUPP( userUPP: QTComponentPropertyListenerUPP ); external name '_DisposeQTComponentPropertyListenerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  DisposeQTComponentPropertyListenerFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeQTComponentPropertyListenerFilterUPP( userUPP: QTComponentPropertyListenerFilterUPP ); external name '_DisposeQTComponentPropertyListenerFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  InvokeQTComponentPropertyListenerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeQTComponentPropertyListenerUPP( inComponent: ComponentInstance; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inUserData: UnivPtr; userUPP: QTComponentPropertyListenerUPP ); external name '_InvokeQTComponentPropertyListenerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  InvokeQTComponentPropertyListenerFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeQTComponentPropertyListenerFilterUPP( inCollection: QTComponentPropertyListenersRef; const (*var*) inCollectionContext: QTComponentPropertyListenerCollectionContext; inNotifier: ComponentInstance; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inListenerCallbackProc: QTComponentPropertyListenerUPP; inListenerProcRefCon: {const} UnivPtr; inFilterProcRefCon: {const} UnivPtr; userUPP: QTComponentPropertyListenerFilterUPP ): Boolean; external name '_InvokeQTComponentPropertyListenerFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  QTComponentPropertyListenerCollectionCreate()
 *  
 *  Summary:
 *    Create a collection to use with the functions
 *    ComponentPropertyListenerCollectionAddListener,
 *    ComponentPropertyListenerCollectionRemoveListener,
 *    ComponentPropertyListenerCollectionNotifyListeners,
 *    ComponentPropertyListenerCollectionIsEmpty, and
 *    ComponentPropertyListenerCollectionHasListenersForProperty.
 *  
 *  Parameters:
 *    
 *    outCollection:
 *      Returns the new, empty, listener collection.
 *    
 *    inAllocator:
 *      Allocator used to create the collection and it's contents.
 *    
 *    inContext:
 *      The listener collection context. May be NULL.  A copy of the
 *      contents of the structure is made, so a pointer to a structure
 *      on the stack can be passed.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTComponentPropertyListenerCollectionCreate( inAllocator: CFAllocatorRef { can be NULL }; {const} inContext: QTComponentPropertyListenerCollectionContextPtr { can be NULL }; var outCollection: QTComponentPropertyListenersRef ): OSStatus; external name '_QTComponentPropertyListenerCollectionCreate';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTComponentPropertyListenerCollectionAddListener()
 *  
 *  Summary:
 *    Add a listener callback for the specified property class and ID
 *    to a property listener collection.
 *  
 *  Parameters:
 *    
 *    inCollection:
 *      The property listener collection.
 *    
 *    inPropClass:
 *      The property class.
 *    
 *    inPropID:
 *      The property ID.
 *    
 *    inListenerProc:
 *      The property listener callback function.
 *    
 *    inListenerProcRefCon:
 *      The data parameter to pass to the listener callback function.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTComponentPropertyListenerCollectionAddListener( inCollection: QTComponentPropertyListenersRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inListenerProc: QTComponentPropertyListenerUPP; inListenerProcRefCon: {const} UnivPtr ): OSStatus; external name '_QTComponentPropertyListenerCollectionAddListener';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTComponentPropertyListenerCollectionRemoveListener()
 *  
 *  Summary:
 *    Remove a listener callback for the specified property class and
 *    ID from a property listener collection.
 *  
 *  Parameters:
 *    
 *    inCollection:
 *      The property listener collection.
 *    
 *    inPropClass:
 *      The property class.
 *    
 *    inPropID:
 *      The property ID.
 *    
 *    inListenerProc:
 *      The property listener callback function.
 *    
 *    inListenerProcRefCon:
 *      The data parameter to pass to the listener callback function.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTComponentPropertyListenerCollectionRemoveListener( inCollection: QTComponentPropertyListenersRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inListenerProc: QTComponentPropertyListenerUPP; inListenerProcRefCon: {const} UnivPtr ): OSStatus; external name '_QTComponentPropertyListenerCollectionRemoveListener';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTComponentPropertyListenerCollectionNotifyListeners()
 *  
 *  Summary:
 *    Call all listener callbacks in the collection registered for the
 *    specified property class and ID.
 *  
 *  Discussion:
 *    If the "filterProcUPP" in the collection's context is non-NULL,
 *    the filter function will be called before each registered
 *    listener that matches the specified property class and ID. If the
 *    filter function return false, the listener proc will not be
 *    called. This is intended to allow a component to change the
 *    calling semantics (call another thread, etc), to use a different
 *    listener callback signature, etc.
 *  
 *  Parameters:
 *    
 *    inCollection:
 *      The property listener collection.
 *    
 *    inNotifier:
 *      The calling ComponentInstance.
 *    
 *    inPropClass:
 *      The property class.
 *    
 *    inPropID:
 *      The property ID.
 *    
 *    inFilterProcRefCon:
 *      The data parameter to pass to the filter function.
 *    
 *    inFlags:
 *      Flags.  Must be set to 0.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTComponentPropertyListenerCollectionNotifyListeners( inCollection: QTComponentPropertyListenersRef; inNotifier: ComponentInstance; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inFilterProcRefCon: {const} UnivPtr { can be NULL }; inFlags: UInt32 ): OSStatus; external name '_QTComponentPropertyListenerCollectionNotifyListeners';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTComponentPropertyListenerCollectionIsEmpty()
 *  
 *  Summary:
 *    Return true if the listener collection is empty.
 *  
 *  Parameters:
 *    
 *    inCollection:
 *      The property listener collection.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTComponentPropertyListenerCollectionIsEmpty( inCollection: QTComponentPropertyListenersRef ): Boolean; external name '_QTComponentPropertyListenerCollectionIsEmpty';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTComponentPropertyListenerCollectionHasListenersForProperty()
 *  
 *  Summary:
 *    Returns true if there are any listeners registered for the
 *    specified property class and ID.
 *  
 *  Parameters:
 *    
 *    inCollection:
 *      The property listener collection.
 *    
 *    inPropClass:
 *      The property class.
 *    
 *    inPropID:
 *      The property ID.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTComponentPropertyListenerCollectionHasListenersForProperty( inCollection: QTComponentPropertyListenersRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID ): Boolean; external name '_QTComponentPropertyListenerCollectionHasListenersForProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{ DRM properties}
const
	kQTPropertyClass_DRM = FourCharCode('drm ');

const
	kQTDRMPropertyID_InteractWithUser = FourCharCode('shui'); { Boolean*}
	kQTDRMPropertyID_IsProtected = FourCharCode('prot'); { Boolean*}
	kQTDRMPropertyID_IsAuthorized = FourCharCode('auth'); { Boolean*}


{ UPP call backs }

{ selectors for component calls }
const
	kGraphicsImportSetDataReferenceSelect = $0001;
	kGraphicsImportGetDataReferenceSelect = $0002;
	kGraphicsImportSetDataFileSelect = $0003;
	kGraphicsImportGetDataFileSelect = $0004;
	kGraphicsImportSetDataHandleSelect = $0005;
	kGraphicsImportGetDataHandleSelect = $0006;
	kGraphicsImportGetImageDescriptionSelect = $0007;
	kGraphicsImportGetDataOffsetAndSizeSelect = $0008;
	kGraphicsImportReadDataSelect = $0009;
	kGraphicsImportSetClipSelect = $000A;
	kGraphicsImportGetClipSelect = $000B;
	kGraphicsImportSetSourceRectSelect = $000C;
	kGraphicsImportGetSourceRectSelect = $000D;
	kGraphicsImportGetNaturalBoundsSelect = $000E;
	kGraphicsImportDrawSelect = $000F;
	kGraphicsImportSetGWorldSelect = $0010;
	kGraphicsImportGetGWorldSelect = $0011;
	kGraphicsImportSetMatrixSelect = $0012;
	kGraphicsImportGetMatrixSelect = $0013;
	kGraphicsImportSetBoundsRectSelect = $0014;
	kGraphicsImportGetBoundsRectSelect = $0015;
	kGraphicsImportSaveAsPictureSelect = $0016;
	kGraphicsImportSetGraphicsModeSelect = $0017;
	kGraphicsImportGetGraphicsModeSelect = $0018;
	kGraphicsImportSetQualitySelect = $0019;
	kGraphicsImportGetQualitySelect = $001A;
	kGraphicsImportSaveAsQuickTimeImageFileSelect = $001B;
	kGraphicsImportSetDataReferenceOffsetAndLimitSelect = $001C;
	kGraphicsImportGetDataReferenceOffsetAndLimitSelect = $001D;
	kGraphicsImportGetAliasedDataReferenceSelect = $001E;
	kGraphicsImportValidateSelect = $001F;
	kGraphicsImportGetMetaDataSelect = $0020;
	kGraphicsImportGetMIMETypeListSelect = $0021;
	kGraphicsImportDoesDrawAllPixelsSelect = $0022;
	kGraphicsImportGetAsPictureSelect = $0023;
	kGraphicsImportExportImageFileSelect = $0024;
	kGraphicsImportGetExportImageTypeListSelect = $0025;
	kGraphicsImportDoExportImageFileDialogSelect = $0026;
	kGraphicsImportGetExportSettingsAsAtomContainerSelect = $0027;
	kGraphicsImportSetExportSettingsFromAtomContainerSelect = $0028;
	kGraphicsImportSetProgressProcSelect = $0029;
	kGraphicsImportGetProgressProcSelect = $002A;
	kGraphicsImportGetImageCountSelect = $002B;
	kGraphicsImportSetImageIndexSelect = $002C;
	kGraphicsImportGetImageIndexSelect = $002D;
	kGraphicsImportGetDataOffsetAndSize64Select = $002E;
	kGraphicsImportReadData64Select = $002F;
	kGraphicsImportSetDataReferenceOffsetAndLimit64Select = $0030;
	kGraphicsImportGetDataReferenceOffsetAndLimit64Select = $0031;
	kGraphicsImportGetDefaultMatrixSelect = $0032;
	kGraphicsImportGetDefaultClipSelect = $0033;
	kGraphicsImportGetDefaultGraphicsModeSelect = $0034;
	kGraphicsImportGetDefaultSourceRectSelect = $0035;
	kGraphicsImportGetColorSyncProfileSelect = $0036;
	kGraphicsImportSetDestRectSelect = $0037;
	kGraphicsImportGetDestRectSelect = $0038;
	kGraphicsImportSetFlagsSelect = $0039;
	kGraphicsImportGetFlagsSelect = $003A;
	kGraphicsImportGetBaseDataOffsetAndSize64Select = $003D;
	kGraphicsImportSetImageIndexToThumbnailSelect = $003E;
	kGraphicsImportCreateCGImageSelect = $003F;
	kGraphicsImportSaveAsPictureToDataRefSelect = $0040;
	kGraphicsImportSaveAsQuickTimeImageFileToDataRefSelect = $0041;
	kGraphicsImportExportImageFileToDataRefSelect = $0042;
	kGraphicsImportDoExportImageFileToDataRefDialogSelect = $0043;
	kGraphicsImportSetOverrideSourceColorSyncProfileRefSelect = $0044;
	kGraphicsImportGetOverrideSourceColorSyncProfileRefSelect = $0045;
	kGraphicsImportSetDestinationColorSyncProfileRefSelect = $0046;
	kGraphicsImportGetDestinationColorSyncProfileRefSelect = $0047;
	kGraphicsImportWillUseColorMatchingSelect = $0048;
	kGraphicsImportGetGenericColorSyncProfileSelect = $0049;
	kGraphicsImportSetReturnGenericColorSyncProfileSelect = $004A;
	kGraphicsImportGetReturnGenericColorSyncProfileSelect = $004B;
	kGraphicsExportDoExportSelect = $0001;
	kGraphicsExportCanTranscodeSelect = $0002;
	kGraphicsExportDoTranscodeSelect = $0003;
	kGraphicsExportCanUseCompressorSelect = $0004;
	kGraphicsExportDoUseCompressorSelect = $0005;
	kGraphicsExportDoStandaloneExportSelect = $0006;
	kGraphicsExportGetDefaultFileTypeAndCreatorSelect = $0007;
	kGraphicsExportGetDefaultFileNameExtensionSelect = $0008;
	kGraphicsExportGetMIMETypeListSelect = $0009;
	kGraphicsExportRequestSettingsSelect = $000B;
	kGraphicsExportSetSettingsFromAtomContainerSelect = $000C;
	kGraphicsExportGetSettingsAsAtomContainerSelect = $000D;
	kGraphicsExportGetSettingsAsTextSelect = $000E;
	kGraphicsExportSetDontRecompressSelect = $000F;
	kGraphicsExportGetDontRecompressSelect = $0010;
	kGraphicsExportSetInterlaceStyleSelect = $0011;
	kGraphicsExportGetInterlaceStyleSelect = $0012;
	kGraphicsExportSetMetaDataSelect = $0013;
	kGraphicsExportGetMetaDataSelect = $0014;
	kGraphicsExportSetTargetDataSizeSelect = $0015;
	kGraphicsExportGetTargetDataSizeSelect = $0016;
	kGraphicsExportSetCompressionMethodSelect = $0017;
	kGraphicsExportGetCompressionMethodSelect = $0018;
	kGraphicsExportSetCompressionQualitySelect = $0019;
	kGraphicsExportGetCompressionQualitySelect = $001A;
	kGraphicsExportSetResolutionSelect = $001B;
	kGraphicsExportGetResolutionSelect = $001C;
	kGraphicsExportSetDepthSelect = $001D;
	kGraphicsExportGetDepthSelect = $001E;
	kGraphicsExportSetColorSyncProfileSelect = $0021;
	kGraphicsExportGetColorSyncProfileSelect = $0022;
	kGraphicsExportSetProgressProcSelect = $0023;
	kGraphicsExportGetProgressProcSelect = $0024;
	kGraphicsExportSetInputDataReferenceSelect = $0025;
	kGraphicsExportGetInputDataReferenceSelect = $0026;
	kGraphicsExportSetInputFileSelect = $0027;
	kGraphicsExportGetInputFileSelect = $0028;
	kGraphicsExportSetInputHandleSelect = $0029;
	kGraphicsExportGetInputHandleSelect = $002A;
	kGraphicsExportSetInputPtrSelect = $002B;
	kGraphicsExportGetInputPtrSelect = $002C;
	kGraphicsExportSetInputGraphicsImporterSelect = $002D;
	kGraphicsExportGetInputGraphicsImporterSelect = $002E;
	kGraphicsExportSetInputPictureSelect = $002F;
	kGraphicsExportGetInputPictureSelect = $0030;
	kGraphicsExportSetInputGWorldSelect = $0031;
	kGraphicsExportGetInputGWorldSelect = $0032;
	kGraphicsExportSetInputPixmapSelect = $0033;
	kGraphicsExportGetInputPixmapSelect = $0034;
	kGraphicsExportSetInputOffsetAndLimitSelect = $0035;
	kGraphicsExportGetInputOffsetAndLimitSelect = $0036;
	kGraphicsExportMayExporterReadInputDataSelect = $0037;
	kGraphicsExportGetInputDataSizeSelect = $0038;
	kGraphicsExportReadInputDataSelect = $0039;
	kGraphicsExportGetInputImageDescriptionSelect = $003A;
	kGraphicsExportGetInputImageDimensionsSelect = $003B;
	kGraphicsExportGetInputImageDepthSelect = $003C;
	kGraphicsExportDrawInputImageSelect = $003D;
	kGraphicsExportSetOutputDataReferenceSelect = $003E;
	kGraphicsExportGetOutputDataReferenceSelect = $003F;
	kGraphicsExportSetOutputFileSelect = $0040;
	kGraphicsExportGetOutputFileSelect = $0041;
	kGraphicsExportSetOutputHandleSelect = $0042;
	kGraphicsExportGetOutputHandleSelect = $0043;
	kGraphicsExportSetOutputOffsetAndMaxSizeSelect = $0044;
	kGraphicsExportGetOutputOffsetAndMaxSizeSelect = $0045;
	kGraphicsExportSetOutputFileTypeAndCreatorSelect = $0046;
	kGraphicsExportGetOutputFileTypeAndCreatorSelect = $0047;
	kGraphicsExportWriteOutputDataSelect = $0048;
	kGraphicsExportSetOutputMarkSelect = $0049;
	kGraphicsExportGetOutputMarkSelect = $004A;
	kGraphicsExportReadOutputDataSelect = $004B;
	kGraphicsExportSetThumbnailEnabledSelect = $004C;
	kGraphicsExportGetThumbnailEnabledSelect = $004D;
	kGraphicsExportSetExifEnabledSelect = $004E;
	kGraphicsExportGetExifEnabledSelect = $004F;
	kGraphicsExportSetInputCGImageSelect = $0050;
	kGraphicsExportGetInputCGImageSelect = $0051;
	kGraphicsExportSetInputCGBitmapContextSelect = $0052;
	kGraphicsExportGetInputCGBitmapContextSelect = $0053;
	kGraphicsExportSetFlagsSelect = $0054;
	kGraphicsExportGetFlagsSelect = $0055;
	kImageTranscoderBeginSequenceSelect = $0001;
	kImageTranscoderConvertSelect = $0002;
	kImageTranscoderDisposeDataSelect = $0003;
	kImageTranscoderEndSequenceSelect = $0004;
	kQTGetComponentPropertyInfoSelect = -11;
	kQTGetComponentPropertySelect = -12;
	kQTSetComponentPropertySelect = -13;
	kQTAddComponentPropertyListenerSelect = -14;
	kQTRemoveComponentPropertyListenerSelect = -15;
{ Aperture modes }

{
 *  Summary:
 *    Aperture modes
 *  
 *  Discussion:
 *    You can set the aperture mode property on a movie to indicate
 *    whether aspect ratio and clean aperture correction should be
 *    performed (kQTPropertyClass_Visual /
 *    kQTVisualPropertyID_ApertureMode). When a movie is in clean,
 *    production or encoded pixels aperture mode, each track's
 *    dimensions are overriden by special dimensions for that mode. The
 *    original track dimensions are preserved and can be restored by
 *    setting the movie into classic aperture mode. Aperture modes are
 *    not saved in movies. 
 *    You can set the aperture mode property on a decompression session
 *    options object to indicate whether pixel buffers should be tagged
 *    to enable aspect ratio and clean aperture correction
 *    (kQTPropertyClass_ICMDecompressionSessionOptions /
 *    kICMDecompressionSessionOptionsPropertyID_ApertureMode).
 }
const
{
   * An aperture mode which gives compatibility with behavior in
   * QuickTime 7.0.x and earlier. 
   * A movie in classic aperture mode uses track dimensions as set in
   * NewMovieTrack and SetTrackDimensions. 
   * A decompression session in classic aperture mode does not set the
   * clean aperture or pixel aspect ratio attachments on emitted pixel
   * buffers. 
   * Movies default to classic aperture mode. If you call
   * SetTrackDimensions on a track, the movie is automatically switched
   * into classic aperture mode.
   }
	kQTApertureMode_Classic = FourCharCode('clas');

  {
   * An aperture mode for general display. 
   * Where possible, video will be displayed at the correct pixel
   * aspect ratio, trimmed to the clean aperture. A movie in clean
   * aperture mode sets each track's dimensions to match its
   * kQTVisualPropertyID_CleanApertureDimensions. 
   * A decompression session in clean aperture mode sets the clean
   * aperture and pixel aspect ratio attachments on emitted pixel
   * buffers based on the image description.
   }
	kQTApertureMode_CleanAperture = FourCharCode('clea');

  {
   * An aperture mode for modal use in authoring applications. 
   *  Where possible, video will be displayed at the correct pixel
   * aspect ratio, but without trimming to the clean aperture so that
   * the edge processing region can be viewed. A movie in production
   * aperture mode sets each track's dimensions to match its
   * kQTVisualPropertyID_ProductionApertureDimensions. 
   * A decompression session in production aperture mode sets the pixel
   * aspect ratio attachments on emitted pixel buffers based on the
   * image description.
   }
	kQTApertureMode_ProductionAperture = FourCharCode('prod');

  {
   * An aperture mode for technical use. 
   * Displays all encoded pixels with no aspect ratio or clean aperture
   * compensation. A movie in encoded pixels aperture mode sets each
   * track's dimensions to match its
   * kQTVisualPropertyID_EncodedPixelsDimensions. 
   * A decompression session in encoded pixels aperture mode does not
   * set the clean aperture or pixel aspect ratio attachments on
   * emitted pixel buffers.
   }
	kQTApertureMode_EncodedPixels = FourCharCode('enco');

{ Property interface for Image Descriptions }

{
 *  Summary:
 *    Properties of image descriptions.
 }
const
{
   * Class identifier for image description properties.
   }
	kQTPropertyClass_ImageDescription = FourCharCode('idsc');

  {
   * The width of the encoded image. Usually, but not always, this is
   * the ImageDescription's width field.
   }
	kICMImageDescriptionPropertyID_EncodedWidth = FourCharCode('encw'); { SInt32, Read/Write }

  {
   * The height of the encoded image. Usually, but not always, this is
   * the ImageDescription's height field.
   }
	kICMImageDescriptionPropertyID_EncodedHeight = FourCharCode('ench'); { SInt32, Read/Write }

  {
   * Describes the clean aperture of the buffer. If not specified
   * explicitly in the image description, the default clean aperture
   * (full encoded width and height) will be returned.
   }
	kICMImageDescriptionPropertyID_CleanAperture = FourCharCode('clap'); { Native-endian CleanApertureImageDescriptionExtension, Read/Write }

  {
   * Describes the pixel aspect ratio. If not specified explicitly in
   * the image description, a square (1:1) pixel aspect ratio will be
   * returned.
   }
	kICMImageDescriptionPropertyID_PixelAspectRatio = FourCharCode('pasp'); { Native-endian PixelAspectRatioImageDescriptionExtension, Read/Write }

  {
   * Dimensions at which the image could be displayed on a square-pixel
   * display, generally calculated using the clean aperture and pixel
   * aspect ratio. 
   * Note that this value is returned as a FixedPoint; the width and
   * height can also be read separately as rounded SInt32s via
   * kICMImageDescriptionPropertyID_CleanApertureDisplayWidth and
   * kICMImageDescriptionPropertyID_CleanApertureDisplayHeight.
   }
	kICMImageDescriptionPropertyID_CleanApertureDisplayDimensions = FourCharCode('cadi'); { FixedPoint, Read }

  {
   * Dimensions at which the image could be displayed on a square-pixel
   * display, disregarding any clean aperture but honoring the pixel
   * aspect ratio. This may be useful for authoring applications that
   * want to expose the edge processing region. For general viewing,
   * use kICMImageDescriptionPropertyID_CleanApertureDimensions
   * instead. 
   * Note that this value is returned as a FixedPoint; the width and
   * height can also be read separately as rounded SInt32s via
   * kICMImageDescriptionPropertyID_ProductionApertureDisplayWidth and
   * kICMImageDescriptionPropertyID_ProductionApertureDisplayHeight.
   }
	kICMImageDescriptionPropertyID_ProductionApertureDisplayDimensions = FourCharCode('prdi'); { FixedPoint, Read }

  {
   * Dimensions of the encoded image. 
   * Note that this value is returned as a FixedPoint for convenience;
   * the width and height can also be read separately as SInt32s via
   * kICMImageDescriptionPropertyID_EncodedWidth and
   * kICMImageDescriptionPropertyID_EncodedHeight.
   }
	kICMImageDescriptionPropertyID_EncodedPixelsDimensions = FourCharCode('endi'); { FixedPoint, Read }

  {
   * A width at which the image could be displayed on a square-pixel
   * display, possibly calculated using the clean aperture and pixel
   * aspect ratio.
   }
	kICMImageDescriptionPropertyID_CleanApertureDisplayWidth = FourCharCode('disw'); { SInt32, Read }

  {
   * A height at which the image could be displayed on a square-pixel
   * display, possibly calculated using the clean aperture and pixel
   * aspect ratio.
   }
	kICMImageDescriptionPropertyID_CleanApertureDisplayHeight = FourCharCode('dish'); { SInt32, Read }

  {
   * A width at which the image could be displayed on a square-pixel
   * display, disregarding any clean aperture but honoring the pixel
   * aspect ratio. This may be useful for authoring applications that
   * want to expose the edge processing region. For general viewing,
   * use kICMImageDescriptionPropertyID_CleanApertureDisplayWidth
   * instead.
   }
	kICMImageDescriptionPropertyID_ProductionApertureDisplayWidth = FourCharCode('pdsw'); { SInt32, Read }

  {
   * A height at which the image could be displayed on a square-pixel
   * display, disregarding any clean aperture but honoring the pixel
   * aspect ratio. This may be useful for authoring applications that
   * want to expose the edge processing region. For general viewing,
   * use kICMImageDescriptionPropertyID_CleanApertureDisplayHeight
   * instead.
   }
	kICMImageDescriptionPropertyID_ProductionApertureDisplayHeight = FourCharCode('pdsh'); { SInt32, Read }

  {
   * Synonym for
   * kICMImageDescriptionPropertyID_CleanApertureDisplayWidth.
   }
	kICMImageDescriptionPropertyID_DisplayWidth = FourCharCode('disw'); { SInt32, Read }

  {
   * Synonym for
   * kICMImageDescriptionPropertyID_CleanApertureDisplayHeight.
   }
	kICMImageDescriptionPropertyID_DisplayHeight = FourCharCode('dish'); { SInt32, Read }

  {
   * Synonym for
   * kICMImageDescriptionPropertyID_ProductionApertureDisplayWidth.
   }
	kICMImageDescriptionPropertyID_ProductionDisplayWidth = FourCharCode('pdsw'); { SInt32, Read }

  {
   * Synonym for
   * kICMImageDescriptionPropertyID_ProductionApertureDisplayHeight.
   }
	kICMImageDescriptionPropertyID_ProductionDisplayHeight = FourCharCode('pdsh'); { SInt32, Read }

  {
   * Color information, if available in the
   * NCLCColorInfoImageDescriptionExtension format.
   }
	kICMImageDescriptionPropertyID_NCLCColorInfo = FourCharCode('nclc'); { Native-endian NCLCColorInfoImageDescriptionExtension, Read/Write }

  {
   * A CGColorSpaceRef for the colorspace described by the image
   * description, constructed from video color info or ICC Profile.
   * IMPORTANT NOTE: The YCbCr matrix from the video color info is not
   * represented in the CGColorSpaceRef. The caller of GetProperty is
   * responsible for releasing this, eg, by calling
   * CGColorSpaceRelease. Only supported on Mac OS X.
   }
	kICMImageDescriptionPropertyID_CGColorSpace = FourCharCode('cgcs'); { CGColorSpaceRef, Read -- caller of GetProperty must call CGColorSpaceRelease }

  {
   * A CFDataRef containing the serialized ICC profile described by the
   * image description. The caller of GetProperty is responsible for
   * releasing this, eg, by calling CFRelease.
   }
	kICMImageDescriptionPropertyID_ICCProfile = FourCharCode('iccp'); { CFDataRef, Read/Write -- caller of GetProperty must call CFRelease }

  {
   * The gamma level described by the image description.
   }
	kICMImageDescriptionPropertyID_GammaLevel = FourCharCode('gama'); { Fixed, Read/Write }

  {
   * Information about the number and order of fields, if available.
   }
	kICMImageDescriptionPropertyID_FieldInfo = FourCharCode('fiel'); { FieldInfoImageDescriptionExtension2, Read/Write }

  {
   * The offset in bytes from the start of one row to the next. Only
   * valid if the codec type is a chunky pixel format.
   }
	kICMImageDescriptionPropertyID_RowBytes = FourCharCode('rowb'); { SInt32, Read/Write }

  {
   * A track width suitable for passing to NewMovieTrack when creating
   * a new track to hold this image data.
   }
	kICMImageDescriptionPropertyID_ClassicTrackWidth = FourCharCode('claw'); { Fixed, Read }

  {
   * A track height suitable for passing to NewMovieTrack when creating
   * a new track to hold this image data.
   }
	kICMImageDescriptionPropertyID_ClassicTrackHeight = FourCharCode('clah'); { Fixed, Read }

  {
   * Defines a duration for quantizing time. This is applicable for
   * cases where a single media sample generates visual output that
   * varies continuously through its duration. By interpreting this
   * property, such a sample may be considered to have internal "step
   * points" at multiples of the stepping duration. This can be used to
   * throttle frame generation during playback, and when stepping using
   * InterestingTime APIs. Setting a step duration with value zero
   * removes any current step duration.
   }
	kICMImageDescriptionPropertyID_StepDuration = FourCharCode('step'); { TimeRecord (base ignored), Read/Write }

  {
   * The clean aperture as a FixedRect in source coordinates, within
   * the rectangle defined by the image description width and height,
   * suitable for use as a source rectangle in a decompression
   * sequence. 
   * For historical reasons, the DVCPROHD codecs store the production
   * aperture display dimensions in the image description width and
   * height; the actual encoded dimensions are smaller. For DVCPROHD,
   * the clip rect will be relative to the image description width and
   * height, not the encoded dimensions.
   }
	kICMImageDescriptionPropertyID_CleanApertureClipRect = FourCharCode('cacr'); { FixedRect, Read }

  {
   * A matrix transforming the clean aperture clip rect to the origin,
   * scaled to the clean aperture display dimensions. 
   * For historical reasons, the DVCPROHD codecs store the production
   * aperture display dimensions in the image description width and
   * height; the actual encoded dimensions are smaller. For DVCPROHD,
   * the matrix will be relative to the image description width and
   * height, not the encoded dimensions.
   }
	kICMImageDescriptionPropertyID_CleanApertureMatrix = FourCharCode('camx'); { MatrixRecord, Read }

  {
   * A matrix transforming the image to the origin, scaled to the
   * production aperture display dimensions. 
   * For historical reasons, the DVCPROHD codecs store the production
   * aperture display dimensions in the image description width and
   * height; the actual encoded dimensions are smaller. For DVCPROHD,
   * the matrix will be relative to the image description width and
   * height, not the encoded dimensions.
   }
	kICMImageDescriptionPropertyID_ProductionApertureMatrix = FourCharCode('pamx'); { MatrixRecord, Read }

  {
   * A localized, human readable string summarizing the image as a
   * CFString, ie: "Apple DV, 720 x 480 (640 x 480), Millions". 
   *  The elements are: the codec name, the encoded pixels dimensions,
   * then parenthetically the clean aperture mode dimensions, but only
   * if they are different from the encoded pixels dimensions; then the
   * depth. 
   * The codec name shall be from the localized decompressor component
   * name string if exactly one decompressor with the correct cType is
   * available; otherwise the string in the image description shall be
   * used. The caller of GetProperty is responsible for releasing this
   * CFString, eg, by calling CFRelease.
   }
	kICMImageDescriptionPropertyID_SummaryString = FourCharCode('isum'); { CFStringRef, Read - caller of GetProperty must call CFRelease}

{
 *  ICMImageDescriptionGetPropertyInfo()
 *  
 *  Summary:
 *    Gets info about a particular property of a ImageDescription.
 *  
 *  Parameters:
 *    
 *    inDesc:
 *      ImageDescriptionHandle being interrogated
 *    
 *    inPropClass:
 *      The class of property being requested
 *    
 *    inPropID:
 *      The ID of the property being requested
 *    
 *    outPropType:
 *      The type of property is returned here (can be NULL)
 *    
 *    outPropValueSize:
 *      The size of property is returned here (can be NULL)
 *    
 *    outPropertyFlags:
 *      The property flags are returned here (can be NULL)
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMImageDescriptionGetPropertyInfo( inDesc: ImageDescriptionHandle; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; outPropType: ComponentValueTypePtr { can be NULL }; outPropValueSize: ByteCountPtr { can be NULL }; outPropertyFlags: UInt32Ptr { can be NULL } ): OSStatus; external name '_ICMImageDescriptionGetPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMImageDescriptionGetProperty()
 *  
 *  Summary:
 *    Gets a particular property of a ImageDescriptionHandle.
 *  
 *  Parameters:
 *    
 *    inDesc:
 *      ImageDescriptionHandle being interrogated
 *    
 *    inPropClass:
 *      The class of property being requested
 *    
 *    inPropID:
 *      The ID of the property being requested
 *    
 *    inPropValueSize:
 *      The size of the property value buffer
 *    
 *    outPropValueAddress:
 *      Points to the buffer to receive the property value
 *    
 *    outPropValueSizeUsed:
 *      Points to a variable to receive the actual size of returned
 *      property value (can be NULL)
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMImageDescriptionGetProperty( inDesc: ImageDescriptionHandle; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; outPropValueAddress: ComponentValuePtr; outPropValueSizeUsed: ByteCountPtr { can be NULL } ): OSStatus; external name '_ICMImageDescriptionGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMImageDescriptionSetProperty()
 *  
 *  Summary:
 *    Sets a particular property of a ImageDescriptionHandle.
 *  
 *  Parameters:
 *    
 *    inDesc:
 *      ImageDescriptionHandle being modified
 *    
 *    inPropClass:
 *      The class of property being set
 *    
 *    inPropID:
 *      The ID of the property being set
 *    
 *    inPropValueSize:
 *      The size of property value
 *    
 *    inPropValueAddress:
 *      Points to the property value buffer
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMImageDescriptionSetProperty( inDesc: ImageDescriptionHandle; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstComponentValuePtr ): OSStatus; external name '_ICMImageDescriptionSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMValidTimeFlags
 *  
 *  Summary:
 *    Flags to describe which time values are valid.
 }
type
	ICMValidTimeFlagsPtr = ^ICMValidTimeFlags;
	ICMValidTimeFlags = UInt32;
const
{
   * Indicates that a display time stamp is valid.
   }
	kICMValidTime_DisplayTimeStampIsValid = 1 shl 0;

  {
   * Indicates that a display duration is valid.
   }
	kICMValidTime_DisplayDurationIsValid = 1 shl 1;

  {
   * Indicates that a decode time stamp is valid.
   }
	kICMValidTime_DecodeTimeStampIsValid = 1 shl 2;

  {
   * Indicates that a decode duration is valid.
   }
	kICMValidTime_DecodeDurationIsValid = 1 shl 3;

  {
   * Indicates that a display offset (the offset from a decode time
   * stamp to a display time stamp) is valid.
   }
	kICMValidTime_DisplayOffsetIsValid = 1 shl 4;


{
 *  ICMDecompressionSessionRef
 *  
 *  Summary:
 *    Represents a decompression session that emits CVPixelBufferRefs
 *    containing frames, tagged with display times.
 *  
 *  Discussion:
 *    ICMDecompressionSession does not support source extraction,
 *    matrix transformations, graphics transfer modes, region-based
 *    clipping or data-loading procedures. Note that the pixel buffers
 *    may be output out of display order, provided that the client opts
 *    in.
 }
type
	ICMDecompressionSessionRef = ^OpaqueICMDecompressionSession; { an opaque type }
	OpaqueICMDecompressionSession = record end;

{
 *  QTVisualContextRef
 *  
 *  Summary:
 *    Represents a destination visual rendering environment.
 *  
 *  Discussion:
 *    The QTVisualContextRef type encapsulates a connection to a
 *    generic visual destination. A single visual context object may
 *    not be associated with more than one movie at a time.
 }
type
	QTVisualContextRef = ^OpaqueQTVisualContext; { an opaque type }
	OpaqueQTVisualContext = record end;

{
 *  ICMDecompressionSessionOptionsRef
 *  
 *  Summary:
 *    Holds options for a decompression session.
 }
type
	ICMDecompressionSessionOptionsRef = ^OpaqueICMDecompressionSessionOptions; { an opaque type }
	OpaqueICMDecompressionSessionOptions = record end;

{
 *  ICMDecompressionFrameOptionsRef
 *  
 *  Summary:
 *    Holds options for decompressing an individual frame.
 }
type
	ICMDecompressionFrameOptionsRef = ^OpaqueICMDecompressionFrameOptions; { an opaque type }
	OpaqueICMDecompressionFrameOptions = record end;

{
 *  ICMDecompressionTrackingFlags
 *  
 *  Summary:
 *    Describes changes in state of a frame queued with an ICM
 *    decompression session.
 }
type
	ICMDecompressionTrackingFlags = UInt32;
const
{
   * Indicates that this is the last call for this sourceFrameRefCon.
   }
	kICMDecompressionTracking_LastCall = 1 shl 0;

  {
   * Indicates that the session no longer needs the source data pointer.
   }
	kICMDecompressionTracking_ReleaseSourceData = 1 shl 1;

  {
   * Indicates that a frame is being emitted. The pixelBuffer parameter
   * contains the decompressed frame. If the decompression session is
   * targetting a visual context, the frame has not yet been sent to
   * the visual context but will be after the callback returns.
   }
	kICMDecompressionTracking_EmittingFrame = 1 shl 2;

  {
   * Indicates that this frame was decoded.
   }
	kICMDecompressionTracking_FrameDecoded = 1 shl 3;

  {
   * Indicates that the codec decided to drop this frame.
   }
	kICMDecompressionTracking_FrameDropped = 1 shl 4;

  {
   * Indicates that this frame will not be able to be displayed unless
   * it is queued for redecode (also known as FrameNotDisplayable).
   }
	kICMDecompressionTracking_FrameNeedsRequeueing = 1 shl 5;


{
 *  ICMDecompressionTrackingCallback
 *  
 *  Summary:
 *    The callback through which a client of an ICM decompression
 *    session receives decoded frames and information about decoding.
 *  
 *  Discussion:
 *    The client may retain the emitted pixel buffers as long as it
 *    needs; they will not be reused before the client releases them.
 *  
 *  Parameters:
 *    
 *    decompressionTrackingRefCon:
 *      The callback's reference value, copied from the
 *      decompressionTrackingRefCon field of the
 *      ICMDecompressionTrackingCallbackRecord structure.
 *    
 *    result:
 *      Indicates whether there was an error in decompression.
 *    
 *    decompressionTrackingFlags:
 *      One or more flags describing the a frame's state transitions.
 *    
 *    pixelBuffer:
 *      When the kICMDecompressionTracking_EmittingFrame flag is set in
 *      decompressionTrackingFlags, a pixel buffer containing the
 *      decompressed frame.  Otherwise, NULL.
 *    
 *    displayTime:
 *      If kICMValidTime_DisplayTimeStampIsValid is set in
 *      validTimeFlags, the display time of the frame.
 *    
 *    displayDuration:
 *      If kICMValidTime_DisplayDurationIsValid is set in
 *      validTimeFlags, the display duration of the frame.
 *    
 *    validTimeFlags:
 *      Indicates which of displayTime and displayDuration is valid.
 *    
 *    reserved:
 *      Reserved for future use.  Ignore the value of this parameter.
 *    
 *    sourceFrameRefCon:
 *      The frame's reference value, copied from the sourceFrameRefCon
 *      parameter to ICMDecompressionSessionDecodeFrame.
 }
type
	ICMDecompressionTrackingCallback = procedure( decompressionTrackingRefCon: UnivPtr; result: OSStatus; decompressionTrackingFlags: ICMDecompressionTrackingFlags; pixelBuffer: CVPixelBufferRef; displayTime: TimeValue64; displayDuration: TimeValue64; validTimeFlags: ICMValidTimeFlags; reserved: UnivPtr; sourceFrameRefCon: UnivPtr );

{
 *  ICMDecompressionTrackingCallbackRecord
 *  
 *  Summary:
 *    A tracking callback for an ICM decompression session.
 }
type
	ICMDecompressionTrackingCallbackRecordPtr = ^ICMDecompressionTrackingCallbackRecord;
	ICMDecompressionTrackingCallbackRecord = record
{
   * The callback function pointer.
   }
		decompressionTrackingCallback: ICMDecompressionTrackingCallback;

  {
   * The callback's reference value.
   }
		decompressionTrackingRefCon: UnivPtr;
	end;
{
 *  ICMDecompressionSessionCreate()
 *  
 *  Summary:
 *    Creates a session for decompressing video frames.
 *  
 *  Discussion:
 *    Frames will be output through calls to trackingCallback.
 *  
 *  Parameters:
 *    
 *    allocator:
 *      An allocator for the session.  Pass NULL to use the default
 *      allocator.
 *    
 *    desc:
 *      An image description for the source frames.
 *    
 *    decompressionOptions:
 *      Options for the session. The session will retain this options
 *      object. You may change some options during the session by
 *      modifying the object.
 *    
 *    destinationPixelBufferAttributes:
 *      Describes requirements for emitted pixel buffers.
 *    
 *    trackingCallback:
 *      The callback to be called with information about queued frames,
 *      and pixel buffers containing the decompressed frames.
 *    
 *    decompressionSessionOut:
 *      Points to a variable to receive the new decompression session.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionCreate( allocator: CFAllocatorRef { can be NULL }; desc: ImageDescriptionHandle; decompressionOptions: ICMDecompressionSessionOptionsRef { can be NULL }; destinationPixelBufferAttributes: CFDictionaryRef { can be NULL }; var trackingCallback: ICMDecompressionTrackingCallbackRecord; var decompressionSessionOut: ICMDecompressionSessionRef ): OSStatus; external name '_ICMDecompressionSessionCreate';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionCreateForVisualContext()
 *  
 *  Summary:
 *    Creates a session for decompressing video frames.
 *  
 *  Discussion:
 *    Frames will be output to a visual context.  If desired, the
 *    trackingCallback may attach additional data to pixel buffers
 *    before they are sent to the visual context.
 *  
 *  Parameters:
 *    
 *    allocator:
 *      An allocator for the session.  Pass NULL to use the default
 *      allocator.
 *    
 *    desc:
 *      An image description for the source frames.
 *    
 *    decompressionOptions:
 *      Options for the session. The session will retain this options
 *      object. You may change some options during the session by
 *      modifying the object.
 *    
 *    visualContext:
 *      The target visual context.
 *    
 *    trackingCallback:
 *      The callback to be called with information about queued frames,
 *      and pixel buffers containing the decompressed frames.
 *    
 *    decompressionSessionOut:
 *      Points to a variable to receive the new decompression session.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionCreateForVisualContext( allocator: CFAllocatorRef { can be NULL }; desc: ImageDescriptionHandle; decompressionOptions: ICMDecompressionSessionOptionsRef { can be NULL }; visualContext: QTVisualContextRef; var trackingCallback: ICMDecompressionTrackingCallbackRecord; var decompressionSessionOut: ICMDecompressionSessionRef ): OSStatus; external name '_ICMDecompressionSessionCreateForVisualContext';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionRetain()
 *  
 *  Summary:
 *    Increments the retain count of a decompression session.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionRetain( session: ICMDecompressionSessionRef ): ICMDecompressionSessionRef; external name '_ICMDecompressionSessionRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionRelease()
 *  
 *  Summary:
 *    Decrements the retain count of a decompression session.  If it
 *    drops to zero, the session is disposed.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure ICMDecompressionSessionRelease( session: ICMDecompressionSessionRef ); external name '_ICMDecompressionSessionRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionGetTypeID()
 *  
 *  Summary:
 *    Returns the CFTypeID for decompression sessions.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionGetTypeID: CFTypeID; external name '_ICMDecompressionSessionGetTypeID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionDecodeFrame()
 *  
 *  Summary:
 *    Queues a frame for decompression.
 *  
 *  Parameters:
 *    
 *    session:
 *      The decompression session.
 *    
 *    data:
 *      Points to the compressed data for this frame. The data must
 *      remain in this location until the tracking callback is called
 *      with the kICMDecompressionTracking_ReleaseSourceData flag set
 *      in decompressionTrackingFlags.
 *    
 *    dataSize:
 *      The number of bytes of compressed data. You may not pass zero
 *      in this parameter.
 *    
 *    frameOptions:
 *      Options for this frame.
 *    
 *    frameTime:
 *      Points to a structure describing the frame's timing information.
 *    
 *    sourceFrameRefCon:
 *      Your reference value for the frame.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionDecodeFrame( session: ICMDecompressionSessionRef; data: {const} UnivPtr; dataSize: ByteCount; frameOptions: ICMDecompressionFrameOptionsRef { can be NULL }; const (*var*) frameTime: ICMFrameTimeRecord; sourceFrameRefCon: UnivPtr ): OSStatus; external name '_ICMDecompressionSessionDecodeFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionGetPropertyInfo()
 *  
 *  Summary:
 *    Retrieves information about properties of a decompression session.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionGetPropertyInfo( session: ICMDecompressionSessionRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; outPropType: ComponentValueTypePtr { can be NULL }; outPropValueSize: ByteCountPtr { can be NULL }; outPropertyFlags: UInt32Ptr { can be NULL } ): OSStatus; external name '_ICMDecompressionSessionGetPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionGetProperty()
 *  
 *  Summary:
 *    Retrieves the value of a specific property of a decompression
 *    session.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionGetProperty( session: ICMDecompressionSessionRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; outPropValueAddress: ComponentValuePtr; outPropValueSizeUsed: ByteCountPtr { can be NULL } ): OSStatus; external name '_ICMDecompressionSessionGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionSetProperty()
 *  
 *  Summary:
 *    Sets the value of a specific property of a decompression session.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionSetProperty( session: ICMDecompressionSessionRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstComponentValuePtr ): OSStatus; external name '_ICMDecompressionSessionSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMNonScheduledDisplayTime
 *  
 *  Discussion:
 *    The display time for a decompression session.
 }
type
	ICMNonScheduledDisplayTime = record
{
   * A display time.  Usually this is the display time of a
   * non-scheduled queued frame.
   }
		displayTime: TimeValue64;

  {
   * The timescale according to which displayTime should be interpreted.
   }
		displayTimeScale: TimeScale;

  {
   * Reserved, set to zero.
   }
		flags: UInt32;
	end;

{
 *  Summary:
 *    Properties of decompression sessions.
 }
const
{
   * Class identifier for decompression session properties.
   }
	kQTPropertyClass_ICMDecompressionSession = FourCharCode('icds');

  {
   * The non-scheduled display time for a decompression session.
   * Setting this requests display of the non-scheduled queued frame at
   * that display time, if there is one. 
   * See ICMDecompressionSessionSetNonScheduledDisplayTime.
   }
	kICMDecompressionSessionPropertyID_NonScheduledDisplayTime = FourCharCode('nsti'); { ICMNonScheduledDisplayTime, Read/Write }

  {
   * The direction for non-scheduled display time. 
   * See ICMDecompressionSessionSetNonScheduledDisplayDirection.
   }
	kICMDecompressionSessionPropertyID_NonScheduledDisplayDirection = FourCharCode('nsdu'); { Fixed, Read/Write }

  {
   * The pixel buffer pool from which emitted pixel buffers are
   * allocated. Getting this does not change the retain count of the
   * pool.
   }
	kICMDecompressionSessionPropertyID_PixelBufferPool = FourCharCode('pool'); { CVPixelBufferPoolRef, Read }

  {
   * Indicates whether the a common pixel buffer pool is shared between
   * the decompressor and the session client. This is false if separate
   * pools are used because the decompressor's and the client's pixel
   * buffer attributes were incompatible.
   }
	kICMDecompressionSessionPropertyID_PixelBufferPoolIsShared = FourCharCode('plsh'); { Boolean, Read }

{
 *  ICMDecompressionSessionSetNonScheduledDisplayTime()
 *  
 *  Summary:
 *    Sets the display time for a decompression session, and requests
 *    display of the non-scheduled queued frame at that display time,
 *    if there is one.
 *  
 *  Discussion:
 *    Call ICMDecompressionSessionSetNonScheduledDisplayTime after
 *    queueing non-scheduled frames with
 *    ICMDecompressionSessionDecodeFrame with the
 *    icmFrameTimeIsNonScheduledDisplayTime flag set to request display
 *    of the frame at a particular display time. 
 *    If there is no queued non-scheduled frame with this display time,
 *    the frame with the next earlier display time is displayed. (Which
 *    of two display times is earlier is determined using the
 *    non-scheduled display time direction, which you can set with
 *    ICMDecompressionSessionSetNonScheduledDisplayDirection.) If there
 *    is no such frame, nothing happens. 
 *    This has no effect if frames are scheduled against a timebase.
 *  
 *  Parameters:
 *    
 *    session:
 *      The decompression session.
 *    
 *    displayTime:
 *      A display time.  Usually this is the display time of a
 *      non-scheduled queued frame.
 *    
 *    displayTimeScale:
 *      The timescale according to which displayTime should be
 *      interpreted.
 *    
 *    flags:
 *      Reserved, set to zero.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionSetNonScheduledDisplayTime( session: ICMDecompressionSessionRef; displayTime: TimeValue64; displayTimeScale: TimeScale; flags: UInt32 ): OSStatus; external name '_ICMDecompressionSessionSetNonScheduledDisplayTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionSetNonScheduledDisplayDirection()
 *  
 *  Summary:
 *    Sets the direction for non-scheduled display time.
 *  
 *  Discussion:
 *    If rate is zero or positive, direction is forwards.  If negative,
 *    direction is backwards. 
 *    Any frames queued under the opposite direction will be flushed.
 *    
 *    The non-scheduled display direction defaults to forwards (rate
 *    1.0).
 *  
 *  Parameters:
 *    
 *    session:
 *      The decompression session.
 *    
 *    rate:
 *      Indicates the direction.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionSetNonScheduledDisplayDirection( session: ICMDecompressionSessionRef; rate: Fixed ): OSStatus; external name '_ICMDecompressionSessionSetNonScheduledDisplayDirection';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionFlush()
 *  
 *  Summary:
 *    Flushes frames queued with a decompression session.
 *  
 *  Discussion:
 *    The tracking callback will be called for each frame with the
 *    result -1.
 *  
 *  Parameters:
 *    
 *    session:
 *      The decompression session.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionFlush( session: ICMDecompressionSessionRef ): OSStatus; external name '_ICMDecompressionSessionFlush';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionOptionsCreate()
 *  
 *  Summary:
 *    Creates a decompression session options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionOptionsCreate( allocator: CFAllocatorRef { can be NULL }; var options: ICMDecompressionSessionOptionsRef ): OSStatus; external name '_ICMDecompressionSessionOptionsCreate';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionOptionsCreateCopy()
 *  
 *  Summary:
 *    Copies a decompression session options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionOptionsCreateCopy( allocator: CFAllocatorRef { can be NULL }; originalOptions: ICMDecompressionSessionOptionsRef; var copiedOptions: ICMDecompressionSessionOptionsRef ): OSStatus; external name '_ICMDecompressionSessionOptionsCreateCopy';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionOptionsRetain()
 *  
 *  Summary:
 *    Increments the retain count of a decompression session options
 *    object.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionOptionsRetain( options: ICMDecompressionSessionOptionsRef ): ICMDecompressionSessionOptionsRef; external name '_ICMDecompressionSessionOptionsRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionOptionsRelease()
 *  
 *  Summary:
 *    Decrements the retain count of a decompression session options
 *    object.  If it drops to zero, the object is disposed.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure ICMDecompressionSessionOptionsRelease( options: ICMDecompressionSessionOptionsRef ); external name '_ICMDecompressionSessionOptionsRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionOptionsGetTypeID()
 *  
 *  Summary:
 *    Returns the CFTypeID for decompression session options objects.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionOptionsGetTypeID: CFTypeID; external name '_ICMDecompressionSessionOptionsGetTypeID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionOptionsGetPropertyInfo()
 *  
 *  Summary:
 *    Retrieves information about properties of a decompression session
 *    options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionOptionsGetPropertyInfo( options: ICMDecompressionSessionOptionsRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; outPropType: ComponentValueTypePtr { can be NULL }; outPropValueSize: ByteCountPtr { can be NULL }; outPropertyFlags: UInt32Ptr { can be NULL } ): OSStatus; external name '_ICMDecompressionSessionOptionsGetPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionOptionsGetProperty()
 *  
 *  Summary:
 *    Retrieves the value of a specific property of a decompression
 *    session options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionOptionsGetProperty( options: ICMDecompressionSessionOptionsRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; outPropValueAddress: ComponentValuePtr; outPropValueSizeUsed: ByteCountPtr { can be NULL } ): OSStatus; external name '_ICMDecompressionSessionOptionsGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionSessionOptionsSetProperty()
 *  
 *  Summary:
 *    Sets the value of a specific property of a decompression session
 *    options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionSessionOptionsSetProperty( options: ICMDecompressionSessionOptionsRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstComponentValuePtr ): OSStatus; external name '_ICMDecompressionSessionOptionsSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  Summary:
 *    Properties of decompression session options objects.
 }
const
{
   * Class identifier for decompression session options object
   * properties.
   }
	kQTPropertyClass_ICMDecompressionSessionOptions = FourCharCode('idso');

  {
   * By default, this is true, meaning that frames must be output in
   * display order. Set this to false to allow frames to be output in
   * decode order rather than in display order.
   }
	kICMDecompressionSessionOptionsPropertyID_DisplayOrderRequired = FourCharCode('dorq'); { Boolean, Read/Write }

  {
   * A specific decompressor component or component instance to be
   * used, or one of the wildcards anyCodec, bestSpeedCodec,
   * bestFidelityCodec, or bestCompressionCodec. 
   * By default, this is anyCodec.
   }
	kICMDecompressionSessionOptionsPropertyID_DecompressorComponent = FourCharCode('imdc'); { DecompressorComponent, Read/Write }

  {
   * The decompression accuracy. 
   * The default accuracy is codecNormalQuality.
   }
	kICMDecompressionSessionOptionsPropertyID_Accuracy = FourCharCode('acur'); { CodecQ, Read/Write }

  {
   * Requests special handling of fields. Not all codecs will obey this
   * request; some codecs will only handle it at certain accuracy
   * levels. Ignored for non-interlaced content.
   }
	kICMDecompressionSessionOptionsPropertyID_FieldMode = FourCharCode('fiel'); { ICMFieldMode, Read/Write }

  {
   * The maximum number of buffers ahead of the current time that
   * should be decompressed. Used in sessions that target visual
   * contexts. By default, the number of buffers will be determined
   * from the visual context.
   }
	kICMDecompressionSessionOptionsPropertyID_MaxBufferCount = FourCharCode('m#bf'); { UInt32, Read/Write }

  {
   * The minimum time ahead of the current time that frames should be
   * decompressed. Used in sessions that target visual contexts. By
   * default, the output-ahead time will be determined from the visual
   * context.
   }
	kICMDecompressionSessionOptionsPropertyID_OutputAheadTime = FourCharCode('futu'); { TimeRecord, Read/Write }

  {
   * You can set the aperture mode property on a decompression session
   * options object to indicate whether pixel buffers should be tagged
   * to enable aspect ratio and clean aperture correction. The default
   * aperture mode for a decompression session is clean aperture mode.
   }
	kICMDecompressionSessionOptionsPropertyID_ApertureMode = FourCharCode('apmd'); { OSType, Read/Write }


{
 *  ICMFieldMode
 *  
 *  Summary:
 *    Describes special field handling.
 }
type
	ICMFieldMode = UInt32;
const
{
   * Both fields should be decompressed.
   }
	kICMFieldMode_BothFields = 0;

  {
   * Only the top field should be decompressed, producing a half-height
   * image.
   }
	kICMFieldMode_TopFieldOnly = 1;

  {
   * Only the bottom field should be decompressed, producing a
   * half-height image.
   }
	kICMFieldMode_BottomFieldOnly = 2;

  {
   * Both fields should be decompressed, and then filtered to reduce
   * interlacing artifacts.
   }
	kICMFieldMode_DeinterlaceFields = 3;


{
 *  ICMDecompressionFrameOptionsCreate()
 *  
 *  Summary:
 *    Creates a frame decompression options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionFrameOptionsCreate( allocator: CFAllocatorRef { can be NULL }; var options: ICMDecompressionFrameOptionsRef ): OSStatus; external name '_ICMDecompressionFrameOptionsCreate';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionFrameOptionsCreateCopy()
 *  
 *  Summary:
 *    Copies a frame decompression options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionFrameOptionsCreateCopy( allocator: CFAllocatorRef { can be NULL }; originalOptions: ICMDecompressionFrameOptionsRef; var copiedOptions: ICMDecompressionFrameOptionsRef ): OSStatus; external name '_ICMDecompressionFrameOptionsCreateCopy';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionFrameOptionsRetain()
 *  
 *  Summary:
 *    Increments the retain count of a frame decompression options
 *    object.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionFrameOptionsRetain( options: ICMDecompressionFrameOptionsRef ): ICMDecompressionFrameOptionsRef; external name '_ICMDecompressionFrameOptionsRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionFrameOptionsRelease()
 *  
 *  Summary:
 *    Decrements the retain count of a frame decompression options
 *    object.  If it drops to zero, the object is disposed.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure ICMDecompressionFrameOptionsRelease( options: ICMDecompressionFrameOptionsRef ); external name '_ICMDecompressionFrameOptionsRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionFrameOptionsGetTypeID()
 *  
 *  Summary:
 *    Returns the CFTypeID for frame decompression options objects.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionFrameOptionsGetTypeID: CFTypeID; external name '_ICMDecompressionFrameOptionsGetTypeID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionFrameOptionsGetPropertyInfo()
 *  
 *  Summary:
 *    Retrieves information about properties of a decompression frame
 *    options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionFrameOptionsGetPropertyInfo( options: ICMDecompressionFrameOptionsRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; outPropType: ComponentValueTypePtr { can be NULL }; outPropValueSize: ByteCountPtr { can be NULL }; outPropertyFlags: UInt32Ptr { can be NULL } ): OSStatus; external name '_ICMDecompressionFrameOptionsGetPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionFrameOptionsGetProperty()
 *  
 *  Summary:
 *    Retrieves the value of a specific property of a decompression
 *    frame options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionFrameOptionsGetProperty( options: ICMDecompressionFrameOptionsRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; outPropValueAddress: ComponentValuePtr; outPropValueSizeUsed: ByteCountPtr { can be NULL } ): OSStatus; external name '_ICMDecompressionFrameOptionsGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMDecompressionFrameOptionsSetProperty()
 *  
 *  Summary:
 *    Sets the value of a specific property of a decompression frame
 *    options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMDecompressionFrameOptionsSetProperty( options: ICMDecompressionFrameOptionsRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstComponentValuePtr ): OSStatus; external name '_ICMDecompressionFrameOptionsSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  Summary:
 *    Properties of decompression frame options objects.
 }
const
{
   * Class identifier for decompression frame options object properties.
   }
	kQTPropertyClass_ICMDecompressionFrameOptions = FourCharCode('idfo');

  {
   * A specific pixel buffer that the frame should be decompressed
   * into. Setting this circumvents the pixel buffer pool mechanism. If
   * this buffer is not compatible with the codec's pixel buffer
   * requirements, decompression will fail.
   }
	kICMDecompressionFrameOptionsPropertyID_DestinationPixelBuffer = FourCharCode('cvpb'); { CVPixelBufferRef, Read/Write }


{
 *  ICMCompressionSessionRef
 *  
 *  Summary:
 *    Represents a compression session for a sequence of images. 
 *    B-frame capable.
 }
type
	ICMCompressionSessionRef = ^OpaqueICMCompressionSession; { an opaque type }
	OpaqueICMCompressionSession = record end;

{
 *  ICMEncodedFrameRef
 *  
 *  Summary:
 *    Represents a frame encoded by a compressor component and emitted
 *    by a compression session.
 *  
 *  Discussion:
 *    Compressor components have access to the mutable flavor of
 *    encoded frame object (ICMMutableEncodedFrameRef); compression
 *    session clients receive the read-only flavor
 *    (ICMMutableEncodedFrameRef).
 }
type
	ICMEncodedFrameRef = ^OpaqueICMEncodedFrame; { an opaque type }
	OpaqueICMEncodedFrame = record end;
	ICMEncodedFrameRefPtr = ^ICMEncodedFrameRef;
	ICMMutableEncodedFrameRef = ^OpaqueICMMutableEncodedFrameRef; { an opaque type }
	OpaqueICMMutableEncodedFrameRef = record end;
	ICMMutableEncodedFrameRefPtr = ^ICMMutableEncodedFrameRef;

{
 *  ICMCompressionSessionOptionsRef
 *  
 *  Summary:
 *    An opaque struct which holds options to configure a compression
 *    session.
 }
type
	ICMCompressionSessionOptionsRef = ^OpaqueICMCompressionSessionOptions; { an opaque type }
	OpaqueICMCompressionSessionOptions = record end;

{
 *  ICMCompressionFrameOptionsRef
 *  
 *  Summary:
 *    A token which holds options to configure an individual frame
 *    during a compression session.
 }
type
	ICMCompressionFrameOptionsRef = ^OpaqueICMCompressionFrameOptions; { an opaque type }
	OpaqueICMCompressionFrameOptions = record end;

{
 *  ICMMultiPassStorageRef
 *  
 *  Summary:
 *    A mechanism for storing information for each frame of a multipass
 *    compression session.
 *  
 *  Discussion:
 *    The ICM provides default storage mechanisms using temporary
 *    files, but clients may override this with custom mechanisms.
 }
type
	ICMMultiPassStorageRef = ^OpaqueICMMultiPassStorage; { an opaque type }
	OpaqueICMMultiPassStorage = record end;

{
 *  ICMEncodedFrameOutputCallback
 *  
 *  Summary:
 *    The callback through which a client of an ICM compression session
 *    receives encoded frames.
 *  
 *  Discussion:
 *    During the encoded frame output callback, the ICM has a reference
 *    to the passed ICMEncodedFrame, but the ICM will release that
 *    reference afterwards; the callback should retain the encoded
 *    frame if the client wants to keep it after the callback returns.
 *  
 *  Parameters:
 *    
 *    encodedFrameOutputRefCon:
 *      The callback's reference value, copied from the
 *      encodedFrameOutputRefCon field of the
 *      ICMEncodedFrameOutputRecord.
 *    
 *    session:
 *      The compression session.
 *    
 *    error:
 *      Indicates whether there was an error.
 *    
 *    frame:
 *      The encoded frame.
 *    
 *    reserved:
 *      Reserved for future use.  Ignore the value of this parameter.
 *  
 *  Result:
 *    If the callback returns an error, the compressor and ICM will
 *    stop emitting frames so that the error can be propogated back to
 *    the caller of ICMCompressionSessionEncodeFrame or
 *    ICMCompressionSessionCompleteFrames.
 }
type
	ICMEncodedFrameOutputCallback = function( encodedFrameOutputRefCon: UnivPtr; session: ICMCompressionSessionRef; error: OSStatus; frame: ICMEncodedFrameRef; reserved: UnivPtr ): OSStatus;

{
 *  ICMEncodedFrameOutputRecord
 *  
 *  Summary:
 *    Holds an encoded frame callback and reference value.
 }
type
	ICMEncodedFrameOutputRecord = record
{
   * An encoded frame callback.
   }
		encodedFrameOutputCallback: ICMEncodedFrameOutputCallback;

  {
   * The reference value for the encoded frame callback.
   }
		encodedFrameOutputRefCon: UnivPtr;

  {
   * The allocator for encoded frame data. Pass NULL if you do not need
   * a specific allocator.
   }
		frameDataAllocator: CFAllocatorRef;
	end;

{
 *  ICMSourceTrackingFlags
 *  
 }
type
	ICMSourceTrackingFlags = UInt32;
const
{
   * Indicates that this is the last call for this sourceFrameRefCon.
   }
	kICMSourceTracking_LastCall = 1 shl 0;

  {
   * Indicates that the session is done with the source pixel buffer
   * and has released any reference to it that it had.
   }
	kICMSourceTracking_ReleasedPixelBuffer = 1 shl 1;

  {
   * Indicates that this frame was encoded.
   }
	kICMSourceTracking_FrameWasEncoded = 1 shl 2;

  {
   * Indicates that this frame was dropped.
   }
	kICMSourceTracking_FrameWasDropped = 1 shl 3;

  {
   * Indicates that this frame was merged into other frames.
   }
	kICMSourceTracking_FrameWasMerged = 1 shl 4;

  {
   * Indicates that the time stamp of this frame was modified.
   }
	kICMSourceTracking_FrameTimeWasChanged = 1 shl 5;

  {
   * Indicates that the ICM has copied the image from the source pixel
   * buffer into another pixel buffer because the source pixel buffer
   * was not compatible with the compressor's required pixel buffer
   * attributes.
   }
	kICMSourceTracking_CopiedPixelBuffer = 1 shl 6;


{
 *  ICMSourceTrackingCallback
 *  
 *  Summary:
 *    A callback which the ICM calls to provide information about the
 *    status of a frame that was passed to
 *    ICMCompressionSessionEncodeFrame.
 *  
 *  Discussion:
 *    Note that this callback may be called several times.
 *  
 *  Parameters:
 *    
 *    sourceTrackingRefCon:
 *      The callback's reference value, copied from the
 *      sourceTrackingRefCon field of ICMSourceTrackingCallbackRecord.
 *    
 *    sourceTrackingFlags:
 *      Flags describing what has happened to the frame.
 *    
 *    sourceFrameRefCon:
 *      The frame's reference value, copied from the sourceFrameRefCon
 *      parameter to ICMCompressionSessionEncodeFrame.
 *    
 *    reserved:
 *      Reserved for future use.  Ignore the value of this parameter.
 }
type
	ICMSourceTrackingCallback = procedure( sourceTrackingRefCon: UnivPtr; sourceTrackingFlags: ICMSourceTrackingFlags; sourceFrameRefCon: UnivPtr; reserved: UnivPtr );

{
 *  ICMSourceTrackingCallbackRecord
 *  
 *  Summary:
 *    A tracking callback for an ICM compression session.
 }
type
	ICMSourceTrackingCallbackRecordPtr = ^ICMSourceTrackingCallbackRecord;
	ICMSourceTrackingCallbackRecord = record
{
   * The callback function pointer.
   }
		sourceTrackingCallback: ICMSourceTrackingCallback;

  {
   * The callback's reference value.
   }
		sourceTrackingRefCon: UnivPtr;
	end;

{
 *  ICMFrameType
 *  
 *  Summary:
 *    Informally identifies a type of frame.
 *  
 *  Discussion:
 *    Do not assume that there are no other frame types beyond I, P and
 *    B.
 }
type
	ICMFrameType = UInt16;
const
	kICMFrameType_I = 'I';
	kICMFrameType_P = 'P';
	kICMFrameType_B = 'B';
	kICMFrameType_Unknown = 0;


{ ICMCompressionSessionRef routines }
{
 *  ICMCompressionSessionCreate()
 *  
 *  Summary:
 *    Creates a compression session for the given codec type.
 *  
 *  Discussion:
 *    Some compressors do not support arbitrary source dimensions, and
 *    may override the suggested width and height.
 *  
 *  Parameters:
 *    
 *    allocator:
 *      An allocator for the session.  Pass NULL to use the default
 *      allocator.
 *    
 *    width:
 *      The width of frames.
 *    
 *    height:
 *      The height of frames.
 *    
 *    cType:
 *      The codec type.
 *    
 *    timescale:
 *      The timescale to be used for all timestamps and durations used
 *      in the session.
 *    
 *    compressionOptions:
 *      Settings configuring the session.
 *    
 *    sourcePixelBufferAttributes:
 *      Required attributes for source pixel buffers, used when
 *      creating a pixel buffer pool for source frames. If you do not
 *      want the ICM to create one for you, pass NULL. (Using pixel
 *      buffers not allocated by the ICM may increase the chance that
 *      it will be necessary to copy image data.)
 *    
 *    encodedFrameOutputRecord:
 *      The callback that will receive encoded frames.
 *    
 *    compressionSessionOut:
 *      Points to a variable to receive the created session object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionCreate( allocator: CFAllocatorRef { can be NULL }; width: SInt32; height: SInt32; cType: CodecType; timescale_: TimeScale; compressionOptions: ICMCompressionSessionOptionsRef { can be NULL }; sourcePixelBufferAttributes: CFDictionaryRef { can be NULL }; var encodedFrameOutputRecord: ICMEncodedFrameOutputRecord; var compressionSessionOut: ICMCompressionSessionRef ): OSStatus; external name '_ICMCompressionSessionCreate';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionRetain()
 *  
 *  Summary:
 *    Increments the retain count of a compression session.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionRetain( session: ICMCompressionSessionRef ): ICMCompressionSessionRef; external name '_ICMCompressionSessionRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionRelease()
 *  
 *  Summary:
 *    Decrements the retain count of a compression session.  If it
 *    drops to zero, the session is disposed.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens. Remember to
 *    call ICMCompressionSessionCompleteFrames first if you want to
 *    ensure any pending frames are emitted.  If you do not, they will
 *    be discarded.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure ICMCompressionSessionRelease( session: ICMCompressionSessionRef ); external name '_ICMCompressionSessionRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionGetTypeID()
 *  
 *  Summary:
 *    Returns the CFTypeID for compression sessions.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionGetTypeID: CFTypeID; external name '_ICMCompressionSessionGetTypeID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionGetPropertyInfo()
 *  
 *  Summary:
 *    Retrieves information about properties of a compression session.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionGetPropertyInfo( session: ICMCompressionSessionRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; outPropType: ComponentValueTypePtr { can be NULL }; outPropValueSize: ByteCountPtr { can be NULL }; outPropertyFlags: UInt32Ptr { can be NULL } ): OSStatus; external name '_ICMCompressionSessionGetPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionGetProperty()
 *  
 *  Summary:
 *    Retrieves the value of a specific property of a compression
 *    session.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionGetProperty( session: ICMCompressionSessionRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; outPropValueAddress: ComponentValuePtr; outPropValueSizeUsed: ByteCountPtr { can be NULL } ): OSStatus; external name '_ICMCompressionSessionGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionSetProperty()
 *  
 *  Summary:
 *    Sets the value of a specific property of a compression session.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionSetProperty( session: ICMCompressionSessionRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstComponentValuePtr ): OSStatus; external name '_ICMCompressionSessionSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  Summary:
 *    Properties of compression sessions.
 }
const
{
   * Class identifier for compression session properties.
   }
	kQTPropertyClass_ICMCompressionSession = FourCharCode('icse');

  {
   * The time scale for the compression session.
   }
	kICMCompressionSessionPropertyID_TimeScale = FourCharCode('tscl'); { TimeScale, Read }

  {
   * The compressor's pixel buffer attributes for the compression
   * session. You can use these to create a pixel buffer pool for
   * source pixel buffers. Note that this is not the same as the
   * sourcePixelBufferAttributes passed in to
   * ICMCompressionSessionCreate. Getting this property does not change
   * its retain count.
   }
	kICMCompressionSessionPropertyID_CompressorPixelBufferAttributes = FourCharCode('batt'); { CFDictionaryRef, Read }

  {
   * A pool that can provide ideal source pixel buffers for a
   * compression session. The compression session creates this pixel
   * buffer pool based on the compressor's pixel buffer attributes and
   * any pixel buffer attributes passed in to
   * ICMCompressionSessionCreate. If the source pixel buffer attributes
   * and the compressor pixel buffer attributes can not be reconciled,
   * the pool is based on the source pixel buffer attributes and the
   * ICM converts each CVPixelBuffer internally.
   }
	kICMCompressionSessionPropertyID_PixelBufferPool = FourCharCode('pool'); { CVPixelBufferPoolRef, Read }

  {
   * The image description for the compression session. For some
   * codecs, the image description may not be available before the
   * first frame is compressed. Multiple calls to retrieve this
   * property will return the same handle. The ICM will dispose this
   * handle when the compression session is disposed. 
   * IMPORTANT: The caller must NOT dispose this handle.
   }
	kICMCompressionSessionPropertyID_ImageDescription = FourCharCode('idsc'); { ImageDescriptionHandle, Read }

{
 *  ICMCompressionSessionGetTimeScale()
 *  
 *  Summary:
 *    Retrieves the time scale for the compression session.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionGetTimeScale( session: ICMCompressionSessionRef ): TimeScale; external name '_ICMCompressionSessionGetTimeScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionGetPixelBufferPool()
 *  
 *  Summary:
 *    Returns a pool that can provide ideal source pixel buffers for a
 *    compression session.
 *  
 *  Discussion:
 *    The compression session creates this pixel buffer pool based on
 *    the compressor's pixel buffer attributes and any pixel buffer
 *    attributes passed in to ICMCompressionSessionCreate. If the
 *    source pixel buffer attributes and the compressor pixel buffer
 *    attributes can not be reconciled, the pool is based on the source
 *    pixel buffer attributes and the ICM converts each CVPixelBuffer
 *    internally.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionGetPixelBufferPool( session: ICMCompressionSessionRef ): CVPixelBufferPoolRef; external name '_ICMCompressionSessionGetPixelBufferPool';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionGetImageDescription()
 *  
 *  Summary:
 *    Retrieves the image description for the compression session.
 *  
 *  Discussion:
 *    For some codecs, this may fail if called before the first frame
 *    is compressed. Multiple calls to
 *    ICMCompressionSessionGetImageDescription will return the same
 *    handle. The ICM will dispose this handle when the compression
 *    session is disposed. 
 *    IMPORTANT: The caller must NOT dispose this handle.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionGetImageDescription( session: ICMCompressionSessionRef; var imageDescOut: ImageDescriptionHandle ): OSStatus; external name '_ICMCompressionSessionGetImageDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ ICMCompressionSessionRef encoding routines }
{
 *  ICMCompressionSessionEncodeFrame()
 *  
 *  Summary:
 *    Call this function to present frames to the compression session.
 *    Encoded frames may or may not be output before the function
 *    returns.
 *  
 *  Discussion:
 *    The session will retain the pixel buffer as long as necessary;
 *    the client should not modify the pixel data until the session
 *    releases it. (The most practical way to deal with this is by
 *    allocating pixel buffers from a pool.) 
 *    The client may fill in both, either or neither of
 *    displayTimeStamp and displayDuration, but should set the
 *    appropriate flags to indicate which is valid. If the client needs
 *    to track the progress of a source frame, it should provide a
 *    sourceTrackingCallback. 
 *    Note: If multipass compression is enabled, calls to
 *    ICMCompressionSessionEncodeFrame must be bracketed by
 *    ICMCompressionSessionBeginPass ... ICMCompressionSessionEndPass.
 *  
 *  Parameters:
 *    
 *    session:
 *      Identifies the compression session.
 *    
 *    pixelBuffer:
 *      Contains the source image to be compressed. PixelBuffer must
 *      have a nonzero reference count. The session will retain it as
 *      long as necessary. The client should not modify pixel buffer's
 *      pixels until the pixel buffer release callback is called. In a
 *      multipass encoding session pass where the compressor suggested
 *      the flag kICMCompressionPassMode_NoSourceFrames, you may pass
 *      NULL for pixelBuffer.
 *    
 *    displayTimeStamp:
 *      The display timestamp of the frame, using the timescale passed
 *      to ICMCompressionSessionCreate. If you pass a valid value, set
 *      the kICMValidTime_DisplayTimeStampIsValid flag in
 *      validTimeFlags.
 *    
 *    displayDuration:
 *      The display duration of the frame, using the timescale passed
 *      to ICMCompressionSessionCreate. If you pass a valid value, set
 *      the kICMValidTime_DisplayDurationIsValid flag in validTimeFlags.
 *    
 *    validTimeFlags:
 *      Flags to indicate which of displayTimeStamp and displayDuration
 *      are valid.
 *    
 *    frameOptions:
 *      Options for this frame.
 *    
 *    sourceTrackingCallback:
 *      A callback to be notified about the status of this source
 *      frame. Pass NULL if you do not require notification.
 *    
 *    sourceFrameRefCon:
 *      Your reference to the source frame.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionEncodeFrame( session: ICMCompressionSessionRef; pixelBuffer: CVPixelBufferRef; displayTimeStamp: TimeValue64; displayDuration: TimeValue64; validTimeFlags: ICMValidTimeFlags; frameOptions: ICMCompressionFrameOptionsRef { can be NULL }; sourceTrackingCallback: ICMSourceTrackingCallbackRecordPtr { can be NULL }; sourceFrameRefCon: UnivPtr ): OSStatus; external name '_ICMCompressionSessionEncodeFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionCompleteFrames()
 *  
 *  Discussion:
 *    Call this function to force the compression session to complete
 *    encoding frames. Set completeAllFrames to direct the session to
 *    complete all pending frames. 
 *    If completeAllFrames is false, only frames with display time
 *    stamps up to and including completeUntilDisplayTimeStamp. 
 *    If ICMCompressionSessionOptionsSetDurationsNeeded is true and you
 *    are passing valid display timestamps but not display durations to
 *    ICMCompressionSessionEncodeFrame, pass the display timestamp of
 *    the next frame that would be passed to EncodeFrame in
 *    nextDisplayTimeStamp. 
 *    Note: This function might return before frames are completed if
 *    the encoded frame callback returns an error.
 *  
 *  Parameters:
 *    
 *    session:
 *      Identifies the compression session.
 *    
 *    completeAllFrames:
 *      Set to direct the session to complete all pending frames.
 *    
 *    completeUntilDisplayTimeStamp:
 *      If completeAllFrames is false, the display timestamp to
 *      complete frames up to. Ignored if completeAllFrames is true.
 *    
 *    nextDisplayTimeStamp:
 *      See above. Ignored unless
 *      ICMCompressionSessionOptionsSetDurationsNeeded set true and
 *      kICMValidTime_DisplayDurationIsValid was clear in
 *      validTimeFlags in last call to ICMCompressionSessionEncodeFrame.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionCompleteFrames( session: ICMCompressionSessionRef; completeAllFrames: Boolean; completeUntilDisplayTimeStamp: TimeValue64; nextDisplayTimeStamp: TimeValue64 ): OSStatus; external name '_ICMCompressionSessionCompleteFrames';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ ICMCompressionSessionRef multipass support routines }

{
 *  ICMCompressionPassModeFlags
 *  
 *  Summary:
 *    Flags describing how a compressor should behave in a given pass
 *    of multipass encoding.
 }
type
	ICMCompressionPassModeFlagsPtr = ^ICMCompressionPassModeFlags;
	ICMCompressionPassModeFlags = UInt32;
const
{
   * In this pass the compressor shall output encoded frames.
   }
	kICMCompressionPassMode_OutputEncodedFrames = 1 shl 0;

  {
   * In this pass the client need not provide source frame buffers.
   }
	kICMCompressionPassMode_NoSourceFrames = 1 shl 1;

  {
   * In this pass the compressor may write private data to multipass
   * storage.
   }
	kICMCompressionPassMode_WriteToMultiPassStorage = 1 shl 2;

  {
   * In this pass the compressor may read private data from multipass
   * storage.
   }
	kICMCompressionPassMode_ReadFromMultiPassStorage = 1 shl 3;

  {
   * The compressor will set this flag to indicate that it will not be
   * able to output encoded frames in the coming pass. If this flag is
   * not set, then the client is allowed to set the
   * kICMCompressionPassMode_OutputEncodedFrames flag when calling
   * ICMCompressionSessionBeginPass.
   }
	kICMCompressionPassMode_NotReadyToOutputEncodedFrames = 1 shl 4;

{
 *  ICMCompressionSessionSupportsMultiPassEncoding()
 *  
 *  Summary:
 *    Queries whether a compression session supports multipass encoding.
 *  
 *  Discussion:
 *    Even if this function returns false, if you set the
 *    kICMCompressionSessionOptionsPropertyID_MultiPassStorage property
 *    on the CompressionSessionOptions, you must call
 *    ICMCompressionSessionBeginPass and ICMCompressionSessionEndPass.
 *  
 *  Parameters:
 *    
 *    session:
 *      The compression session.
 *    
 *    multiPassStyleFlags:
 *      Reserved.  Set to zero.
 *    
 *    firstPassModeFlagsOut:
 *      Points to a variable to receive the session's requested mode
 *      flags for the first pass. The client may modify these flags,
 *      but should not set kICMCompressionPassMode_NoSourceFrames. Pass
 *      NULL if you do not want this information.
 *  
 *  Result:
 *    true if the session supports multipass encoding, false otherwise.
 *    If the session does not support multipass encoding,
 *    *firstPassModeFlagsOut will be set to
 *    kICMCompressionPassMode_OutputEncodedFrames.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionSupportsMultiPassEncoding( session: ICMCompressionSessionRef; multiPassStyleFlags: UInt32; firstPassModeFlagsOut: ICMCompressionPassModeFlagsPtr { can be NULL } ): Boolean; external name '_ICMCompressionSessionSupportsMultiPassEncoding';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionBeginPass()
 *  
 *  Summary:
 *    Call to announce the start of a specific compression pass.
 *  
 *  Discussion:
 *    The source frames and frame options for each display timestamp
 *    should be the same across passes. 
 *    During multipass compression, valid displayTimeStamps must be
 *    passed to ICMCompressionSessionEncodeFrame since they are used to
 *    index the compressor's stored state. 
 *    During an analysis pass
 *    (kICMCompressionPassMode_WriteToMultiPassStorage), the compressor
 *    does not output encoded frames, but records compressor-private
 *    information for each frame. 
 *    During repeated analysis passes and the encoding pass
 *    (kICMCompressionPassMode_ReadFromMultiPassStorage), the
 *    compressor may refer to this information for other frames and use
 *    it to improve encoding. 
 *    During an encoding pass
 *    (kICMCompressionPassMode_OutputEncodedFrames), the compressor
 *    must output encoded frames. 
 *    If the compressor set the kICMCompressionPassMode_NoSourceFrames
 *    flag for the pass, the client may pass NULL pixel buffers to
 *    ICMCompressionSessionEncodeFrame. 
 *    By default, the ICM provides local storage that lasts only until
 *    the compression session is disposed. If the client provides
 *    custom multipass storage, pass may be performed at different
 *    times or on different machines; segments of each pass may even be
 *    distributed.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionBeginPass( session: ICMCompressionSessionRef; passModeFlags: ICMCompressionPassModeFlags; flags: UInt32 ): OSStatus; external name '_ICMCompressionSessionBeginPass';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionEndPass()
 *  
 *  Summary:
 *    Call to announce the end of a pass.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionEndPass( session: ICMCompressionSessionRef ): OSStatus; external name '_ICMCompressionSessionEndPass';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionProcessBetweenPasses()
 *  
 *  Summary:
 *    Lets the compressor perform processing between passes.
 *  
 *  Discussion:
 *    Call this function repeatedly, until the compressor sets
 *    *interpassProcessingDoneOut to true to indicate that it is done
 *    with this round of interpass processing. 
 *    When done, the compressor will indicate its preferred mode for
 *    the next pass. 
 *    The client may choose to begin an encoding pass (by ORing in the
 *    kICMCompressionPassMode_OutputEncodedFrames flag) regardless of
 *    the compressor's request.
 *  
 *  Parameters:
 *    
 *    session:
 *      The compression session.
 *    
 *    flags:
 *      Reserved.  Set to zero.
 *    
 *    interpassProcessingDoneOut:
 *      Points to a Boolean that will be set to false if
 *      ICMCompressionSessionProcessBetweenPasses should be called
 *      again, true if not
 *    
 *    requestedNextPassModeFlagsOut:
 *      Points to ICMCompressionPassModeFlags that will be set to the
 *      codec's recommended mode flags for the next pass.
 *      kICMCompressionPassMode_OutputEncodedFrames will only be set if
 *      it recommends that the next pass be the final one.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionProcessBetweenPasses( session: ICMCompressionSessionRef; flags: UInt32; var interpassProcessingDoneOut: Boolean; var requestedNextPassModeFlagsOut: ICMCompressionPassModeFlags ): OSStatus; external name '_ICMCompressionSessionProcessBetweenPasses';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ ICMCompressionSessionOptionsRef routines }
{
 *  ICMCompressionSessionOptionsCreate()
 *  
 *  Summary:
 *    Creates a compression session options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsCreate( allocator: CFAllocatorRef { can be NULL }; var options: ICMCompressionSessionOptionsRef ): OSStatus; external name '_ICMCompressionSessionOptionsCreate';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsCreateCopy()
 *  
 *  Summary:
 *    Copies a compression session options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsCreateCopy( allocator: CFAllocatorRef { can be NULL }; originalOptions: ICMCompressionSessionOptionsRef; var copiedOptions: ICMCompressionSessionOptionsRef ): OSStatus; external name '_ICMCompressionSessionOptionsCreateCopy';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsRetain()
 *  
 *  Summary:
 *    Increments the retain count of a compression session options
 *    object.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsRetain( options: ICMCompressionSessionOptionsRef ): ICMCompressionSessionOptionsRef; external name '_ICMCompressionSessionOptionsRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsRelease()
 *  
 *  Summary:
 *    Decrements the retain count of a compression session options
 *    object.  If it drops to zero, the object is disposed.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure ICMCompressionSessionOptionsRelease( options: ICMCompressionSessionOptionsRef ); external name '_ICMCompressionSessionOptionsRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsGetTypeID()
 *  
 *  Summary:
 *    Returns the CFTypeID for compression session options objects.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsGetTypeID: CFTypeID; external name '_ICMCompressionSessionOptionsGetTypeID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsGetPropertyInfo()
 *  
 *  Summary:
 *    Retrieves information about properties of a compression session
 *    options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsGetPropertyInfo( options: ICMCompressionSessionOptionsRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; outPropType: ComponentValueTypePtr { can be NULL }; outPropValueSize: ByteCountPtr { can be NULL }; outPropertyFlags: UInt32Ptr { can be NULL } ): OSStatus; external name '_ICMCompressionSessionOptionsGetPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsGetProperty()
 *  
 *  Summary:
 *    Retrieves the value of a specific property of a compression
 *    session options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsGetProperty( options: ICMCompressionSessionOptionsRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; outPropValueAddress: ComponentValuePtr; outPropValueSizeUsed: ByteCountPtr { can be NULL } ): OSStatus; external name '_ICMCompressionSessionOptionsGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsSetProperty()
 *  
 *  Summary:
 *    Sets the value of a specific property of a compression session
 *    options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsSetProperty( options: ICMCompressionSessionOptionsRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstComponentValuePtr ): OSStatus; external name '_ICMCompressionSessionOptionsSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


const
{
   * Indicates no limit on the number of frames in the compression
   * window.
   }
	kICMUnlimitedFrameDelayCount = -1;

  {
   * Indicates no time limit on the number of frames in the compression
   * window.
   }
	kICMUnlimitedFrameDelayTime = -1;

  {
   * Indicates no CPU time limit on compression.
   }
	kICMUnlimitedCPUTimeBudget = -1;


{
 *  ICMDataRateLimit
 *  
 *  Summary:
 *    A hard limit on the data rate.
 *  
 *  Discussion:
 *    A hard limit is described by a data size in bytes and a duration
 *    in seconds, and requires that the total size of compressed data
 *    for any continuous segment of that duration (in decode time) must
 *    not exceed the provided data size.
 }
type
	ICMDataRateLimit = record
{
   * The number of bytes.
   }
		dataSize: SInt32;

  {
   * The number of seconds.
   }
		dataDuration: Float32;
	end;

{
 *  Summary:
 *    Scaling modes
 *  
 *  Discussion:
 *    These constants indicate how source frames to a compression
 *    session should be scaled if the dimensions and/or display aspect
 *    ratio do not match.
 }
const
{
   * The full width and height of source frames shall be scaled to the
   * full width and height of the destination. This is the default if
   * no other scaling mode is specified.
   }
	kICMScalingMode_StretchProductionAperture = FourCharCode('sp2p');

  {
   * The clean aperture of the source frames shall be scaled to the
   * clean aperture of the destination.
   }
	kICMScalingMode_StretchCleanAperture = FourCharCode('sc2c');

  {
   * The clean aperture of the source frames shall be scaled to fit
   * inside the clean aperture of the destination, preserving the
   * original display aspect ratio. If the display aspect ratios are
   * different, the source frames will be centered with black bars
   * above and below, or to the left and right.
   }
	kICMScalingMode_Letterbox = FourCharCode('lett');

  {
   * The clean aperture of the source frames shall be scaled to cover
   * the clean aperture of the destination, preserving the original
   * display aspect ratio. If the display aspect ratios are different,
   * the source frames will be centered and cropped.
   }
	kICMScalingMode_Trim = FourCharCode('trim');


{
 *  ICMSimpleBoundaryConditions
 *  
 *  Summary:
 *    Indicates whether and how a compression session's frames will be
 *    concatenated with other compressed frames to form a longer series.
 *  
 *  Discussion:
 *    Some clients divide a long series of frames into several shorter
 *    segments, each of which is then compressed by an independent
 *    compression session. Boundary conditions tell the compressor
 *    about how each session fits into the greater series: does this
 *    session stand alone, or will it be used to encode the first
 *    segment, a middle segment, or the last segment in a longer
 *    continuum? 
 *    This information enables compressors to ensure that compressed
 *    segments can be concatenated smoothly -- for example, avoiding
 *    data rate spikes where segments are joined. 
 *    By default, a session is assumed to stand alone.
 }
type
	ICMSimpleBoundaryConditions = record
{
   * True if frames compressed in a separate session will be
   * concatenated before the beginning of this one. False if this is a
   * stand-alone session, or if this session will encode the first
   * segment of a multi-segment compression. By default, false.
   }
		moreFramesBeforeStart: Boolean;

  {
   * True if frames compressed in a separate session will be
   * concatenated following the end of this one. False if this is a
   * stand-alone session, or if this session will encode the last
   * segment of a multi-segment compression. By default, false.
   }
		moreFramesAfterEnd: Boolean;
	end;

{
 *  Summary:
 *    Properties of compression sessions options objects.
 }
const
{
   * Class identifier for compression session options object properties.
   }
	kQTPropertyClass_ICMCompressionSessionOptions = FourCharCode('icso');

  {
   * Enables temporal compression. By default, temporal compression is
   * disabled. 
   * IMPORTANT: If you want temporal compression (P frames and/or B
   * frames) you must set this to true.
   }
	kICMCompressionSessionOptionsPropertyID_AllowTemporalCompression = FourCharCode('p ok'); { Boolean, Read/Write }

  {
   * Enables frame reordering. 
   * In order to encode B frames, a compressor must reorder frames,
   * which means that the order in which they will be emitted and
   * stored (the decode order) is different from the order in which
   * they were presented to the compressor (the display order). 
   * By default, frame reordering is disabled. 
   * IMPORTANT: In order to encode using B frames, you must enable
   * frame reordering.
   }
	kICMCompressionSessionOptionsPropertyID_AllowFrameReordering = FourCharCode('b ok'); { Boolean, Read/Write }

  {
   * Indicates that durations of emitted frames are needed. 
   * If this flag is set and source frames are provided with times but
   * not durations, then frames will be delayed so that durations can
   * be calculated as the difference between one frame's time stamp and
   * the next frame's time stamp. 
   * By default, this flag is clear, so frames will not be delayed in
   * order to calculate durations. 
   * IMPORTANT: If you will be passing encoded frames to
   * AddMediaSampleFromEncodedFrame, you must set this flag to true.
   }
	kICMCompressionSessionOptionsPropertyID_DurationsNeeded = FourCharCode('need'); { Boolean, Read/Write }

  {
   * The maximum interval between key frames, also known as the key
   * frame rate. 
   * Key frames, also known as sync frames, reset inter-frame
   * dependencies; decoding a key frame is sufficient to prepare a
   * decompressor for correctly decoding the difference frames that
   * follow. 
   * Compressors are allowed to generate key frames more frequently if
   * this would result in more efficient compression. 
   * The default key frame interval is 0, which indicates that the
   * compressor should choose where to place all key frames. A key
   * frame interval of 1 indicates that every frame must be a key
   * frame, 2 indicates that at least every other frame must be a key
   * frame, etc.
   }
	kICMCompressionSessionOptionsPropertyID_MaxKeyFrameInterval = FourCharCode('kyfr'); { SInt32, Read/Write }

  {
   * The requested maximum interval between partial sync frames. If the
   * interval is n, any sequence of n successive frames must include at
   * least one key or partial sync frame. 
   * Where supported, partial sync frames perform a partial reset of
   * inter-frame dependencies; decoding two partial sync frames and the
   * non-droppable difference frames between them is sufficient to
   * prepare a decompressor for correctly decoding the difference
   * frames that follow. 
   * Compressors are allowed to generate partial sync frames more
   * frequently if this would result in more efficient compression.
   * 
   * The default partial sync frame interval is 0, which indicates that
   * the compressor should choose where to place partial sync frames. A
   * partial sync frame interval of 1 means there can be no difference
   * frames, so it is equivalent to a key frame interval of 1. A
   * partial sync frame interval of 2 means that every other frame must
   * be a key frame or a partial sync frame. 
   * Compressors that do not support partial sync frames will ignore
   * this setting.
   }
	kICMCompressionSessionOptionsPropertyID_MaxPartialSyncFrameInterval = FourCharCode('psfr'); { SInt32, Read/Write }

  {
   * Enables the compressor to modify frame times. 
   * Some compressors are able to identify and coalesce runs of
   * identical frames and output single frames with longer duration, or
   * output frames at a different frame rate from the original. This
   * feature is controlled by the "allow frame time changes" flag. By
   * default, this flag is set to false, which forces compressors to
   * emit one encoded frame for every source frame, and to preserve
   * frame display times. 
   * (Note: this feature replaces the practice of having compressors
   * return special high similarity values to indicate that frames
   * could be dropped.) 
   * If you want to allow the compressor to modify frame times in order
   * to improve compression performance, enable frame time changes.
   }
	kICMCompressionSessionOptionsPropertyID_AllowFrameTimeChanges = FourCharCode('+ ok'); { Boolean, Read/Write }

  {
   * Enables the compressor to call the encoded-frame callback from a
   * different thread. 
   * By default, the flag is false, which means that the compressor
   * must call the encoded-frame callback from the same thread that
   * ICMCompressionSessionEncodeFrame and
   * ICMCompressionSessionCompleteFrames were called on.
   }
	kICMCompressionSessionOptionsPropertyID_AllowAsyncCompletion = FourCharCode('asok'); { Boolean, Read/Write }

  {
   * The maximum frame delay count is the maximum number of frames that
   * a compressor is allowed to hold before it must output a compressed
   * frame. It limits the number of frames that may be held in the
   * "compression window". If the maximum frame delay count is M, then
   * before the call to encode frame N returns, frame N-M must have
   * been emitted. 
   * The default is kICMUnlimitedFrameDelayCount, which sets no limit
   * on the compression window.
   }
	kICMCompressionSessionOptionsPropertyID_MaxFrameDelayCount = FourCharCode('cwin'); { SInt32, Read/Write }

  {
   * The maximum frame delay time is the maximum difference between a
   * source frame's display time and the corresponding encoded frame's
   * decode time. It limits the span of display time that may be held
   * in the "compression window". If the maximum frame delay time is
   * TM, then before the call to encode a frame with display time TN
   * returns, all frames with display times up to and including TN-TM
   * must have been emitted. 
   * The default is kICMUnlimitedFrameDelayTime, which sets no time
   * limit on the compression window.
   }
	kICMCompressionSessionOptionsPropertyID_MaxFrameDelayTime = FourCharCode('cwit'); { TimeValue64, Read/Write }

  {
   * Sets a specific compressor component or component instance to be
   * used, or one of the wildcards anyCodec, bestSpeedCodec,
   * bestFidelityCodec, or bestCompressionCodec. 
   * Use this API to force the Image Compression Manager to use a
   * specific compressor component or compressor component instance. 
   * (If you pass in a component instance that you opened, the ICM will
   * not close that instance; you must do so after the compression
   * session is released.) To allow the Image Compression Manager to
   * choose the compressor component, set the compressorComponent to
   * anyCodec (the default), bestSpeedCodec, bestFidelityCodec or
   * bestCompressionCodec.
   }
	kICMCompressionSessionOptionsPropertyID_CompressorComponent = FourCharCode('imco'); { CompressorComponent, Read/Write }

  {
   * A handle containing compressor settings. The compressor will be
   * configured with these settings (by a call to
   * ImageCodecSetSettings) during ICMCompressionSessionCreate.
   }
	kICMCompressionSessionOptionsPropertyID_CompressorSettings = FourCharCode('cost'); { Handle, Read/Write }

  {
   * The depth for compression. 
   * If a compressor does not support a specific depth, the closest
   * supported depth will be used (preferring deeper depths to
   * shallower depths). The default depth is k24RGBPixelFormat.
   }
	kICMCompressionSessionOptionsPropertyID_Depth = FourCharCode('deep'); { UInt32, Read/Write }

  {
   * The color table for compression.  Used with indexed-color depths.
   * 
   * Clients who get this property are responsible for disposing the
   * returned CTabHandle.
   }
	kICMCompressionSessionOptionsPropertyID_ColorTable = FourCharCode('clut'); { CTabHandle, Read/Write}

  {
   * The compression quality. 
   * This value is always used to set the spatialQuality; if temporal
   * compression is enabled, it is also used to set temporalQuality.
   * <BR> The default quality is codecNormalQuality.
   }
	kICMCompressionSessionOptionsPropertyID_Quality = FourCharCode('qual'); { CodecQ, Read/Write }

  {
   * The long-term desired average data rate in bytes per second. 
   *  This is not a hard limit. 
   * The default data rate is zero, which indicates that the quality
   * setting should determine the size of compressed data. 
   * Note that data rate settings only have an effect when timing
   * information is provided for source frames, and that some codecs do
   * not support limiting to specified data rates.
   }
	kICMCompressionSessionOptionsPropertyID_AverageDataRate = FourCharCode('aver'); { SInt32, Read/Write }

  {
   * Zero, one or two hard limits on data rate. 
   * Each hard limit is described by a data size in bytes and a
   * duration in seconds, and requires that the total size of
   * compressed data for any contiguous segment of that duration (in
   * decode time) must not exceed the data size. 
   * By default, no data rate limits are set. 
   * When setting this property, the inPropValueSize parameter should
   * be the number of data rate limits multiplied by
   * sizeof(ICMDataRateLimit). 
   * Note that data rate settings only have an effect when timing
   * information is provided for source frames, and that some codecs do
   * not support limiting to specified data rates.
   }
	kICMCompressionSessionOptionsPropertyID_DataRateLimits = FourCharCode('hard'); { C array of ICMDataRateLimit struct, Read/Write }

  {
   * The current number of data rate limits.
   }
	kICMCompressionSessionOptionsPropertyID_DataRateLimitCount = FourCharCode('har#'); { UInt32, Read }

  {
   * The maximum allowed number of data rate limits.  (Currently 2.)
   }
	kICMCompressionSessionOptionsPropertyID_MaxDataRateLimits = FourCharCode('mhar'); { UInt32, Read }

  {
   * Indicates that the source was previously compressed. 
   * This property is purely an optional, informational hint to the
   * compressor; by default it is false.
   }
	kICMCompressionSessionOptionsPropertyID_WasCompressed = FourCharCode('wasc'); { Boolean, Read/Write }

  {
   * Recommends a CPU time budget for the compressor in microseconds
   * per frame. 
   * Zero means to go as fast as possible. 
   * By default, this is set to kICMUnlimitedCPUTimeBudget, which sets
   * no limit. 
   * This is an advisory hint to the compressor, and some compressors
   * may ignore it. Multithreaded compressors may use this amount of
   * CPU time on each processor. 
   * Compressors should not feel compelled to use the full time budget
   * if they complete ahead of time!
   }
	kICMCompressionSessionOptionsPropertyID_CPUTimeBudget = FourCharCode('cput'); { UInt32, Read/Write }

  {
   * Storage for multi-pass compression. 
   * To enable multipass compression, the client must provide a storage
   * location for multipass data.  Use
   * ICMMultiPassStorageCreateWithTemporaryFile to have the ICM store
   * it in a temporary file.  Use
   * ICMMultiPassStorageCreateWithCallbacks to manage the storage
   * yourself. 
   * Note that the amount of multipass data to be stored can be
   * substantial; it could be greater than the size of the output movie
   * file. 
   * If this property is not NULL, the client must call
   * ICMCompressionSessionBeginPass and ICMCompressionSessionEndPass
   * around groups of calls to ICMCompressionSessionEncodeFrame. 
   *  By default, this property is NULL and multipass compression is
   * not enabled. The compression session options object retains the
   * multipass storage object, when one is set.
   }
	kICMCompressionSessionOptionsPropertyID_MultiPassStorage = FourCharCode('imps'); { ICMMultiPassStorageRef, Read/Write }

  {
   * Indicates the number of source frames, if known. If nonzero, this
   * should be the exact number of times that the client calls
   * ICMCompressionSessionEncodeFrame in each pass. 
   * The default is 0, which indicates that the number of source frames
   * is not known.
   }
	kICMCompressionSessionOptionsPropertyID_SourceFrameCount = FourCharCode('frco'); { UInt64, Read/Write }

  {
   * Indicates the expected frame rate, if known. The frame rate is
   * measured in frames per second. This is not used to control the
   * frame rate; it is provided as a hint to the compressor so that it
   * can set up internal configuration before compression begins. The
   * actual frame rate will depend on frame durations and may vary. By
   * default, this is zero, indicating "unknown".
   }
	kICMCompressionSessionOptionsPropertyID_ExpectedFrameRate = FourCharCode('fran'); { Fixed, Read/Write }

  {
   * Indicates how source frames to a compression session should be
   * scaled if the dimensions and/or display aspect ratio do not match.
   }
	kICMCompressionSessionOptionsPropertyID_ScalingMode = FourCharCode('scam'); { OSType, Read/Write }

  {
   * Describes the clean aperture for compressed frames. Note that if
   * the compressor enforces a clean aperture, it will override this
   * setting. The clean aperture will be set on the output image
   * description and may affect scaling in some scaling modes. By
   * default, this is all zeros, meaning unset.
   }
	kICMCompressionSessionOptionsPropertyID_CleanAperture = FourCharCode('clap'); { Native-endian CleanApertureImageDescriptionExtension, Read/Write }

  {
   * Describes the pixel aspect ratio for compressed frames. Note that
   * if the compressor enforces a pixel aspect ratio, it will override
   * this setting. The pixel aspect ratio will be set on the output
   * image description and may affect scaling in some scaling modes. By
   * default, this is all zeros, meaning unset.
   }
	kICMCompressionSessionOptionsPropertyID_PixelAspectRatio = FourCharCode('pasp'); { Native-endian PixelAspectRatioImageDescriptionExtension, Read/Write }

  {
   * Describes the number and order of fields for compressed frames.
   * Note that if the compressor enforces field info, it will override
   * this setting. The field info will be set on the output image
   * description and may affect scaling in some scaling modes. By
   * default, this is all zeros, meaning unset.
   }
	kICMCompressionSessionOptionsPropertyID_FieldInfo = FourCharCode('fiel'); { FieldInfoImageDescriptionExtension2, Read/Write }

  {
   * Indicates whether and how a compression session's frames will be
   * concatenated with other compressed frames to form a longer series.
   }
	kICMCompressionSessionOptionsPropertyID_SimpleBoundaryConditions = FourCharCode('ends'); { ICMSimpleBoundaryConditions struct, Read/Write }

  {
   * Requests additional distortion to be applied to the aspect ratio
   * in the kICMScalingMode_Letterbox and kICMScalingMode_Trim scaling
   * modes. Values greater than fixed1 mean wider, values less than
   * fixed1 mean narrower. For example, a value of X2Fix(2.0) would
   * make the picture aspect ratio twice as wide.
   }
	kICMCompressionSessionOptionsPropertyID_ExtraAspectRatioStretchFactor = FourCharCode('exsf'); { Fixed, Default fixed1, Read/Write }


{
 *  ICMCompressionSessionOptionsSetAllowTemporalCompression()
 *  
 *  Summary:
 *    Enables temporal compression.
 *  
 *  Discussion:
 *    By default, temporal compression is disabled. 
 *    IMPORTANT: If you want temporal compression (P frames and/or B
 *    frames) you must set this to true.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsSetAllowTemporalCompression( options: ICMCompressionSessionOptionsRef; allowTemporalCompression: Boolean ): OSStatus; external name '_ICMCompressionSessionOptionsSetAllowTemporalCompression';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsGetAllowTemporalCompression()
 *  
 *  Summary:
 *    Retrieves the allow temporal compression flag.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsGetAllowTemporalCompression( options: ICMCompressionSessionOptionsRef ): Boolean; external name '_ICMCompressionSessionOptionsGetAllowTemporalCompression';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsSetAllowFrameReordering()
 *  
 *  Summary:
 *    Enables frame reordering.
 *  
 *  Discussion:
 *    In order to encode B frames, a compressor must reorder frames,
 *    which means that the order in which they will be emitted and
 *    stored (the decode order) is different from the order in which
 *    they were presented to the compressor (the display order). 
 *     By default, frame reordering is disabled. 
 *    IMPORTANT: In order to encode using B frames, you must enable
 *    frame reordering.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsSetAllowFrameReordering( options: ICMCompressionSessionOptionsRef; allowFrameReordering: Boolean ): OSStatus; external name '_ICMCompressionSessionOptionsSetAllowFrameReordering';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsGetAllowFrameReordering()
 *  
 *  Summary:
 *    Retrieves the allow frame reordering flag.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsGetAllowFrameReordering( options: ICMCompressionSessionOptionsRef ): Boolean; external name '_ICMCompressionSessionOptionsGetAllowFrameReordering';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsSetDurationsNeeded()
 *  
 *  Summary:
 *    Indicates that durations of emitted frames are needed.
 *  
 *  Discussion:
 *    If this flag is set and source frames are provided with times but
 *    not durations, then frames will be delayed so that durations can
 *    be calculated as the difference between one frame's time stamp
 *    and the next frame's time stamp. 
 *    By default, this flag is clear, so frames will not be delayed in
 *    order to calculate durations. 
 *    IMPORTANT: If you will be passing encoded frames to
 *    AddMediaSampleFromEncodedFrame, you must set this flag to true.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsSetDurationsNeeded( options: ICMCompressionSessionOptionsRef; decodeDurationsNeeded: Boolean ): OSStatus; external name '_ICMCompressionSessionOptionsSetDurationsNeeded';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsGetDurationsNeeded()
 *  
 *  Summary:
 *    Retrieves the "durations needed" flag.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsGetDurationsNeeded( options: ICMCompressionSessionOptionsRef ): Boolean; external name '_ICMCompressionSessionOptionsGetDurationsNeeded';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsSetMaxKeyFrameInterval()
 *  
 *  Summary:
 *    Sets the maximum interval between key frames (also known as the
 *    key frame rate).
 *  
 *  Discussion:
 *    Compressors are allowed to generate key frames more frequently if
 *    this would result in more efficient compression. 
 *    The default key frame interval is 0, which indicates that the
 *    compressor should choose where to place all key frames. 
 *     (Note: this is a break with previous practice, which used a key
 *    frame rate of zero to disable temporal compression.)
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsSetMaxKeyFrameInterval( options: ICMCompressionSessionOptionsRef; maxKeyFrameInterval: SInt32 ): OSStatus; external name '_ICMCompressionSessionOptionsSetMaxKeyFrameInterval';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsGetMaxKeyFrameInterval()
 *  
 *  Summary:
 *    Retrieves the maximum key frame interval.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsGetMaxKeyFrameInterval( options: ICMCompressionSessionOptionsRef ): SInt32; external name '_ICMCompressionSessionOptionsGetMaxKeyFrameInterval';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsSetAllowFrameTimeChanges()
 *  
 *  Summary:
 *    Enables the compressor to modify frame times.
 *  
 *  Discussion:
 *    Some compressors are able to identify and coalesce runs of
 *    identical frames and output single frames with longer duration,
 *    or output frames at a different frame rate from the original.
 *    This feature is controlled by the "allow frame time changes"
 *    flag. By default, this flag is set to false, which forces
 *    compressors to emit one encoded frame for every source frame, and
 *    to preserve frame display times. 
 *    (Note: this feature replaces the practice of having compressors
 *    return special high similarity values to indicate that frames
 *    could be dropped.) 
 *    If you want to allow the compressor to modify frame times in
 *    order to improve compression performance, enable frame time
 *    changes.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsSetAllowFrameTimeChanges( options: ICMCompressionSessionOptionsRef; allowFrameTimeChanges: Boolean ): OSStatus; external name '_ICMCompressionSessionOptionsSetAllowFrameTimeChanges';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionSessionOptionsGetAllowFrameTimeChanges()
 *  
 *  Summary:
 *    Retrieves the allow frame time changes flag.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionSessionOptionsGetAllowFrameTimeChanges( options: ICMCompressionSessionOptionsRef ): Boolean; external name '_ICMCompressionSessionOptionsGetAllowFrameTimeChanges';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ ICMMultiPassStorageRef routines }

{
 *  ICMMultiPassStorageCreationFlags
 *  
 }
type
	ICMMultiPassStorageCreationFlags = UInt32;
const
{
   * Indicates that the temporary file should not be deleted when the
   * multipass storage is released.
   }
	kICMMultiPassStorage_DoNotDeleteWhenDone = 1 shl 0;

{
 *  ICMMultiPassStorageCreateWithTemporaryFile()
 *  
 *  Summary:
 *    Creates a multipass storage using a temporary file.
 *  
 *  Discussion:
 *    If you pass NULL for directoryRef, the ICM will use the user's
 *    temporary items folder. 
 *    If you pass NULL for fileName, the ICM will pick a unique name.
 *    
 *    The file will be deleted when the multipass storage is released,
 *    unless you set the kICMMultiPassStorage_DoNotDeleteWhenDone flag.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMMultiPassStorageCreateWithTemporaryFile( allocator: CFAllocatorRef { can be NULL }; directoryRef: FSRefPtr { can be NULL }; fileName: CFStringRef { can be NULL }; flags: ICMMultiPassStorageCreationFlags; var multiPassStorageOut: ICMMultiPassStorageRef ): OSStatus; external name '_ICMMultiPassStorageCreateWithTemporaryFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMMultiPassStorageStep
 *  
 *  Summary:
 *    Indicates a jump in time stamps used to index multipass storage.
 }
type
	ICMMultiPassStorageStep = UInt32;
const
{
   * Requests the first time stamp at which a value is stored.
   }
	kICMMultiPassStorage_GetFirstTimeStamp = 1;

  {
   * Requests the previous time stamp before the given time stamp at
   * which a value is stored.
   }
	kICMMultiPassStorage_GetPreviousTimeStamp = 2;

  {
   * Requests the next time stamp after the given time stamp at which a
   * value is stored.
   }
	kICMMultiPassStorage_GetNextTimeStamp = 3;

  {
   * Requests the last time stamp at which a value is stored.
   }
	kICMMultiPassStorage_GetLastTimeStamp = 4;


{
 *  ICMMultiPassSetDataAtTimeStampCallback
 *  
 *  Summary:
 *    Stores a value at a given time stamp.
 *  
 *  Discussion:
 *    The new data should replace any previous data held at that
 *    timestamp with that index.
 *  
 *  Parameters:
 *    
 *    storageRefCon:
 *      The callbacks' reference value.
 *    
 *    timeStamp:
 *      The time stamp at which the value should be stored.
 *    
 *    index:
 *      An index by which multiple values may be stored at a time
 *      stamp. The meaning of individual indexes is private to the
 *      compressor.
 *    
 *    data:
 *      The data to be stored, or NULL to delete the value. The
 *      contents are private to the compressor component.
 }
type
	ICMMultiPassSetDataAtTimeStampCallback = function( storageRefCon: UnivPtr; timeStamp: TimeValue64; index: SIGNEDLONG; data: CFDataRef ): OSStatus;

{
 *  ICMMultiPassGetTimeStampCallback
 *  
 *  Summary:
 *    Retrieves a time stamp for which a value is stored.
 *  
 *  Parameters:
 *    
 *    storageRefCon:
 *      The callbacks' reference value.
 *    
 *    fromTimeStamp:
 *      The initial time stamp.  Ignored for some values of step.
 *    
 *    step:
 *      Indicates the kind of time stamp search to perform.
 *    
 *    timeStampOut:
 *      Points to a TimeValue64 to receive the found time stamp. Set to
 *      -1 if no time stamp is found.
 }
type
	ICMMultiPassGetTimeStampCallback = function( storageRefCon: UnivPtr; fromTimeStamp: TimeValue64; step: ICMMultiPassStorageStep; var timeStampOut: TimeValue64 ): OSStatus;

{
 *  ICMMultiPassCopyDataAtTimeStampCallback
 *  
 *  Summary:
 *    Retrieves a value at a given time stamp and index.
 *  
 *  Parameters:
 *    
 *    storageRefCon:
 *      The callbacks' reference value.
 *    
 *    timeStamp:
 *      The time stamp at which the value should be retrieved.
 *    
 *    index:
 *      An index by which multiple values may be stored at a time
 *      stamp. The meaning of individual indexes is private to the
 *      compressor.
 *    
 *    dataOut:
 *      Points to a variable to receive the value. Set to a
 *      newly-created CFMutableData containing the value for the given
 *      time stamp and index, or set to NULL if no value is at that
 *      time stamp and index. It will be the callers responsibility to
 *      release the CFMutableData.
 }
type
	ICMMultiPassCopyDataAtTimeStampCallback = function( storageRefCon: UnivPtr; timeStamp: TimeValue64; index: SIGNEDLONG; var dataOut: CFMutableDataRef ): OSStatus;

{
 *  ICMMultiPassReleaseCallback
 *  
 *  Summary:
 *    Called when the multipass storage's retain count drops to zero.
 *  
 *  Parameters:
 *    
 *    storageRefCon:
 *      The callbacks' reference value.
 }
type
	ICMMultiPassReleaseCallback = function( storageRefCon: UnivPtr ): OSStatus;

{
 *  ICMMultiPassStorageCallbacks
 *  
 *  Summary:
 *    A collection of callbacks for creating a custom multipass storage
 *    object.
 }
type
	ICMMultiPassStorageCallbacks = record
{
   * The version of the struct.  Set to
   * kICMMultiPassStorageCallbacksVersionOne.
   }
		version: UInt32;

  {
   * The callbacks' reference value.
   }
		storageRefCon: UnivPtr;

  {
   * The callback for storing values.
   }
		setDataAtTimeStampCallback: ICMMultiPassSetDataAtTimeStampCallback;

  {
   * The callback for finding time stamps.
   }
		getTimeStampCallback: ICMMultiPassGetTimeStampCallback;

  {
   * The callback for retrieving values.
   }
		copyDataAtTimeStampCallback: ICMMultiPassCopyDataAtTimeStampCallback;

  {
   * The callback for disposing the callback's state when done.
   }
		releaseCallback: ICMMultiPassReleaseCallback;
	end;
const
	kICMMultiPassStorageCallbacksVersionOne = 1;

{
 *  ICMMultiPassStorageCreateWithCallbacks()
 *  
 *  Summary:
 *    Assembles a multipass storage mechanism from callbacks.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMMultiPassStorageCreateWithCallbacks( allocator: CFAllocatorRef { can be NULL }; var callbacks: ICMMultiPassStorageCallbacks; var multiPassStorageOut: ICMMultiPassStorageRef ): OSStatus; external name '_ICMMultiPassStorageCreateWithCallbacks';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMMultiPassStorageRetain()
 *  
 *  Summary:
 *    Increments the retain count of a multipass storage object.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMMultiPassStorageRetain( multiPassStorage: ICMMultiPassStorageRef ): ICMMultiPassStorageRef; external name '_ICMMultiPassStorageRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMMultiPassStorageRelease()
 *  
 *  Summary:
 *    Decrements the retain count of a multipass storage object.  If it
 *    drops to zero, the object is disposed.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure ICMMultiPassStorageRelease( multiPassStorage: ICMMultiPassStorageRef ); external name '_ICMMultiPassStorageRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMMultiPassStorageGetTypeID()
 *  
 *  Summary:
 *    Returns the CFTypeID for multipass storage objects.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMMultiPassStorageGetTypeID: CFTypeID; external name '_ICMMultiPassStorageGetTypeID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ ICMCompressionFrameOptionsRef routines }
{
 *  ICMCompressionFrameOptionsCreate()
 *  
 *  Summary:
 *    Creates a frame compression options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionFrameOptionsCreate( allocator: CFAllocatorRef { can be NULL }; session: ICMCompressionSessionRef; var options: ICMCompressionFrameOptionsRef ): OSStatus; external name '_ICMCompressionFrameOptionsCreate';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionFrameOptionsCreateCopy()
 *  
 *  Summary:
 *    Copies a frame compression options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionFrameOptionsCreateCopy( allocator: CFAllocatorRef { can be NULL }; originalOptions: ICMCompressionFrameOptionsRef; var copiedOptions: ICMCompressionFrameOptionsRef ): OSStatus; external name '_ICMCompressionFrameOptionsCreateCopy';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionFrameOptionsRetain()
 *  
 *  Summary:
 *    Increments the retain count of a frame compression options object.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionFrameOptionsRetain( options: ICMCompressionFrameOptionsRef ): ICMCompressionFrameOptionsRef; external name '_ICMCompressionFrameOptionsRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionFrameOptionsRelease()
 *  
 *  Summary:
 *    Decrements the retain count of a frame compression options
 *    object.  If it drops to zero, the object is disposed.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure ICMCompressionFrameOptionsRelease( options: ICMCompressionFrameOptionsRef ); external name '_ICMCompressionFrameOptionsRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionFrameOptionsGetTypeID()
 *  
 *  Summary:
 *    Returns the CFTypeID for frame compression options objects.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionFrameOptionsGetTypeID: CFTypeID; external name '_ICMCompressionFrameOptionsGetTypeID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionFrameOptionsGetPropertyInfo()
 *  
 *  Summary:
 *    Retrieves information about properties of a compression frame
 *    options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionFrameOptionsGetPropertyInfo( options: ICMCompressionFrameOptionsRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; outPropType: ComponentValueTypePtr { can be NULL }; outPropValueSize: ByteCountPtr { can be NULL }; outPropertyFlags: UInt32Ptr { can be NULL } ): OSStatus; external name '_ICMCompressionFrameOptionsGetPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionFrameOptionsGetProperty()
 *  
 *  Summary:
 *    Retrieves the value of a specific property of a compression frame
 *    options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionFrameOptionsGetProperty( options: ICMCompressionFrameOptionsRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; outPropValueAddress: ComponentValuePtr; outPropValueSizeUsed: ByteCountPtr { can be NULL } ): OSStatus; external name '_ICMCompressionFrameOptionsGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionFrameOptionsSetProperty()
 *  
 *  Summary:
 *    Sets the value of a specific property of a compression frame
 *    options object.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionFrameOptionsSetProperty( options: ICMCompressionFrameOptionsRef; inPropClass: ComponentPropertyClass; inPropID: ComponentPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstComponentValuePtr ): OSStatus; external name '_ICMCompressionFrameOptionsSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  Summary:
 *    Properties of compression frame options objects.
 }
const
{
   * Class identifier for compression frame options object properties.
   }
	kQTPropertyClass_ICMCompressionFrameOptions = FourCharCode('icfo');

  {
   * Forces frames to be compressed as key frames. 
   * The compressor must obey the "force key frame" flag if set. By
   * default this property is false.
   }
	kICMCompressionFrameOptionsPropertyID_ForceKeyFrame = FourCharCode('keyf'); { Boolean, Read/Write }

  {
   * Requests a frame be compressed as a particular frame type. 
   *  The frame type setting may be ignored by the compressor if not
   * appropriate. 
   * By default this is set to kICMFrameType_Unknown. 
   * Do not assume that kICMFrameType_I means a key frame; if you need
   * a key frame, set the "force key frame" property.
   }
	kICMCompressionFrameOptionsPropertyID_FrameType = FourCharCode('frty'); { ICMFrameType, Read/Write }

{
 *  ICMCompressionFrameOptionsSetForceKeyFrame()
 *  
 *  Summary:
 *    Forces frames to be compressed as key frames.
 *  
 *  Discussion:
 *    The compressor must obey the "force key frame" flag if set. By
 *    default this is set false.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionFrameOptionsSetForceKeyFrame( options: ICMCompressionFrameOptionsRef; forceKeyFrame: Boolean ): OSStatus; external name '_ICMCompressionFrameOptionsSetForceKeyFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionFrameOptionsGetForceKeyFrame()
 *  
 *  Summary:
 *    Retrieves the "force key frame" flag.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionFrameOptionsGetForceKeyFrame( options: ICMCompressionFrameOptionsRef ): Boolean; external name '_ICMCompressionFrameOptionsGetForceKeyFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionFrameOptionsSetFrameType()
 *  
 *  Summary:
 *    Requests a frame be compressed as a particular frame type.
 *  
 *  Discussion:
 *    The frame type setting may be ignored by the compressor if not
 *    appropriate. 
 *    By default this is set to kICMFrameType_Unknown. 
 *    Do not assume that kICMFrameType_I means a key frame; if you need
 *    a key frame, set forceKeyFrame.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionFrameOptionsSetFrameType( options: ICMCompressionFrameOptionsRef; frameType: ICMFrameType ): OSStatus; external name '_ICMCompressionFrameOptionsSetFrameType';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressionFrameOptionsGetFrameType()
 *  
 *  Summary:
 *    Retrieves the frame type setting.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressionFrameOptionsGetFrameType( options: ICMCompressionFrameOptionsRef ): ICMFrameType; external name '_ICMCompressionFrameOptionsGetFrameType';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ ICMEncodedFrameRef routines }
{
 *  ICMEncodedFrameRetain()
 *  
 *  Summary:
 *    Increments the retain count of an encoded frame object.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameRetain( frame: ICMEncodedFrameRef ): ICMEncodedFrameRef; external name '_ICMEncodedFrameRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameRelease()
 *  
 *  Summary:
 *    Decrements the retain count of an encoded frame object.  If it
 *    drops to zero, the object is disposed.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure ICMEncodedFrameRelease( frame: ICMEncodedFrameRef ); external name '_ICMEncodedFrameRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetTypeID()
 *  
 *  Summary:
 *    Returns the CFTypeID for encoded frame objects.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetTypeID: CFTypeID; external name '_ICMEncodedFrameGetTypeID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetDataPtr()
 *  
 *  Summary:
 *    Gets the data buffer.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetDataPtr( frame: ICMEncodedFrameRef ): UInt8Ptr; external name '_ICMEncodedFrameGetDataPtr';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetBufferSize()
 *  
 *  Summary:
 *    Gets the size of the data buffer.
 *  
 *  Discussion:
 *    This is the physical size of the buffer.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetBufferSize( frame: ICMEncodedFrameRef ): ByteCount; external name '_ICMEncodedFrameGetBufferSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetDataSize()
 *  
 *  Summary:
 *    Gets the data size of the compressed frame in the buffer.
 *  
 *  Discussion:
 *    This is the logical size of the frame data. It may be less than
 *    the physical size of the buffer.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetDataSize( frame: ICMEncodedFrameRef ): ByteCount; external name '_ICMEncodedFrameGetDataSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameSetDataSize()
 *  
 *  Summary:
 *    Sets the data size of the compressed frame in the buffer.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameSetDataSize( frame: ICMMutableEncodedFrameRef; dataSize: ByteCount ): OSStatus; external name '_ICMEncodedFrameSetDataSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetDecodeNumber()
 *  
 *  Summary:
 *    Retrieves the decode number.
 *  
 *  Discussion:
 *    The ICM automatically stamps ascending decode numbers on frames
 *    after the compressor emits them. The first decode number in a
 *    session is 1. 
 *    Note: Compressors should not call this function.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetDecodeNumber( frame: ICMEncodedFrameRef ): UInt32; external name '_ICMEncodedFrameGetDecodeNumber';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetTimeScale()
 *  
 *  Summary:
 *    Retrieves the timescale.
 *  
 *  Discussion:
 *    This is always the same as the timescale of the compression
 *    session.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetTimeScale( frame: ICMEncodedFrameRef ): TimeScale; external name '_ICMEncodedFrameGetTimeScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetImageDescription()
 *  
 *  Summary:
 *    Retrieves the image description.
 *  
 *  Discussion:
 *    Returns the same image description handle as
 *    ICMCompressionSessionGetImageDescription. 
 *    IMPORTANT: The caller should NOT dispose this handle.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetImageDescription( frame: ICMEncodedFrameRef; var imageDescOut: ImageDescriptionHandle ): OSStatus; external name '_ICMEncodedFrameGetImageDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetValidTimeFlags()
 *  
 *  Summary:
 *    Retrieves flags indicating which of the time stamps and durations
 *    are valid.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetValidTimeFlags( frame: ICMEncodedFrameRef ): ICMValidTimeFlags; external name '_ICMEncodedFrameGetValidTimeFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetDecodeTimeStamp()
 *  
 *  Summary:
 *    Retrieves the frame's decode time stamp.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetDecodeTimeStamp( frame: ICMEncodedFrameRef ): TimeValue64; external name '_ICMEncodedFrameGetDecodeTimeStamp';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetDisplayTimeStamp()
 *  
 *  Summary:
 *    Retrieves the frame's display time stamp.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetDisplayTimeStamp( frame: ICMEncodedFrameRef ): TimeValue64; external name '_ICMEncodedFrameGetDisplayTimeStamp';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetDisplayOffset()
 *  
 *  Summary:
 *    Retrieves the frame's display offset, which is the offset from
 *    decode time stamp to display time stamp.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetDisplayOffset( frame: ICMEncodedFrameRef ): TimeValue64; external name '_ICMEncodedFrameGetDisplayOffset';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetDecodeDuration()
 *  
 *  Summary:
 *    Retrieves the frame's decode duration.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetDecodeDuration( frame: ICMEncodedFrameRef ): TimeValue64; external name '_ICMEncodedFrameGetDecodeDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetDisplayDuration()
 *  
 *  Summary:
 *    Retrieves the frame's display duration.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetDisplayDuration( frame: ICMEncodedFrameRef ): TimeValue64; external name '_ICMEncodedFrameGetDisplayDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameSetValidTimeFlags()
 *  
 *  Summary:
 *    Sets flags that indicate which of the time stamps and durations
 *    are valid.
 *  
 *  Discussion:
 *    Note that setting the (decode/display) (timestamp/duration)
 *    automatically sets the corresponding valid time flags. For
 *    example, calling ICMEncodedFrameSetDecodeTimeStamp sets
 *    kICMValidTime_DisplayTimeStampIsValid. If both decode timestamp
 *    and display timestamp are valid,
 *    kICMValidTime_DisplayOffsetIsValid is automatically set.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameSetValidTimeFlags( frame: ICMMutableEncodedFrameRef; validTimeFlags: ICMValidTimeFlags ): OSStatus; external name '_ICMEncodedFrameSetValidTimeFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameSetDecodeTimeStamp()
 *  
 *  Summary:
 *    Sets the decode time stamp.
 *  
 *  Discussion:
 *    This automatically sets the kICMValidTime_DecodeTimeStampIsValid
 *    flag. If the display timestamp is valid, it also sets the
 *    kICMValidTime_DisplayOffsetIsValid flag.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameSetDecodeTimeStamp( frame: ICMMutableEncodedFrameRef; decodeTimeStamp: TimeValue64 ): OSStatus; external name '_ICMEncodedFrameSetDecodeTimeStamp';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameSetDisplayTimeStamp()
 *  
 *  Summary:
 *    Sets the display time stamp.
 *  
 *  Discussion:
 *    This automatically sets the kICMValidTime_DisplayTimeStampIsValid
 *    flag. If the decode timestamp is valid, it also sets the
 *    kICMValidTime_DisplayOffsetIsValid flag.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameSetDisplayTimeStamp( frame: ICMMutableEncodedFrameRef; displayTimeStamp: TimeValue64 ): OSStatus; external name '_ICMEncodedFrameSetDisplayTimeStamp';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameSetDecodeDuration()
 *  
 *  Summary:
 *    Sets the decode duration.
 *  
 *  Discussion:
 *    This automatically sets the kICMValidTime_DecodeDurationIsValid
 *    flag.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameSetDecodeDuration( frame: ICMMutableEncodedFrameRef; decodeDuration: TimeValue64 ): OSStatus; external name '_ICMEncodedFrameSetDecodeDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameSetDisplayDuration()
 *  
 *  Summary:
 *    Sets the display duration.
 *  
 *  Discussion:
 *    This automatically sets the kICMValidTime_DisplayDurationIsValid
 *    flag.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameSetDisplayDuration( frame: ICMMutableEncodedFrameRef; displayDuration: TimeValue64 ): OSStatus; external name '_ICMEncodedFrameSetDisplayDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetMediaSampleFlags()
 *  
 *  Summary:
 *    Retrieves the media sample flags for an encoded frame.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetMediaSampleFlags( frame: ICMEncodedFrameRef ): MediaSampleFlags; external name '_ICMEncodedFrameGetMediaSampleFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameSetMediaSampleFlags()
 *  
 *  Summary:
 *    Sets the media sample flags for an encoded frame.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameSetMediaSampleFlags( frame: ICMMutableEncodedFrameRef; mediaSampleFlags_: MediaSampleFlags ): OSStatus; external name '_ICMEncodedFrameSetMediaSampleFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetFrameType()
 *  
 *  Summary:
 *    Retrieves the frame type for an encoded frame.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetFrameType( frame: ICMEncodedFrameRef ): ICMFrameType; external name '_ICMEncodedFrameGetFrameType';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameSetFrameType()
 *  
 *  Summary:
 *    Sets the frame type for an encoded frame.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameSetFrameType( frame: ICMMutableEncodedFrameRef; frameType: ICMFrameType ): OSStatus; external name '_ICMEncodedFrameSetFrameType';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetSimilarity()
 *  
 *  Summary:
 *    Retrieves the similarity for an encoded frame.
 *  
 *  Discussion:
 *    1.0 means identical.  0.0 means not at all alike. By default,
 *    this is set to -1.0, which means unknown.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetSimilarity( frame: ICMEncodedFrameRef ): Float32; external name '_ICMEncodedFrameGetSimilarity';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameSetSimilarity()
 *  
 *  Summary:
 *    Sets the similarity for an encoded frame.
 *  
 *  Discussion:
 *    1.0 means identical.  0.0 means not at all alike.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameSetSimilarity( frame: ICMMutableEncodedFrameRef; similarity: Float32 ): OSStatus; external name '_ICMEncodedFrameSetSimilarity';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameGetSourceFrameRefCon()
 *  
 *  Summary:
 *    Retrieves the source frame reference value.
 *  
 *  Discussion:
 *    This is copied from the sourceFrameRefCon parameter to
 *    ICMCompressionSessionEncodeFrame.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameGetSourceFrameRefCon( frame: ICMEncodedFrameRef ): UnivPtr; external name '_ICMEncodedFrameGetSourceFrameRefCon';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ ICMCompressorSession interface for compressor components }

{
 *  ICMCompressorSessionRef
 *  
 *  Summary:
 *    Represents the session between the ICM and an image compressor
 *    component.
 *  
 *  Discussion:
 *    (Do not confuse this with ICMCompressionSessionRef, which is the
 *    session between the client and the ICM.) Note: compressors do not
 *    need to make any retain or release calls on this token.
 }
type
	ICMCompressorSessionRef = ^OpaqueICMCompressorSession; { an opaque type }
	OpaqueICMCompressorSession = record end;

{
 *  ICMCompressorSourceFrameRef
 *  
 *  Summary:
 *    An opaque token that represents a frame that has been passed to
 *    ICMCompressionSessionEncodeFrame.
 *  
 *  Discussion:
 *    Such tokens are passed to the compressor component, which may
 *    retain a window of them in order to perform out-of-order encoding.
 }
type
	ICMCompressorSourceFrameRef = ^OpaqueICMCompressorSourceFrame; { an opaque type }
	OpaqueICMCompressorSourceFrame = record end;
	ICMCompressorSourceFrameRefPtr = ^ICMCompressorSourceFrameRef;
{
 *  ICMCompressorSourceFrameRetain()
 *  
 *  Summary:
 *    Increments the retain count of a source frame object.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressorSourceFrameRetain( sourceFrame: ICMCompressorSourceFrameRef ): ICMCompressorSourceFrameRef; external name '_ICMCompressorSourceFrameRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressorSourceFrameRelease()
 *  
 *  Summary:
 *    Decrements the retain count of a source frame object.  If it
 *    drops to zero, the object is disposed.
 *  
 *  Discussion:
 *    If you pass NULL to this function, nothing happens.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure ICMCompressorSourceFrameRelease( sourceFrame: ICMCompressorSourceFrameRef ); external name '_ICMCompressorSourceFrameRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressorSourceFrameGetTypeID()
 *  
 *  Summary:
 *    Returns the CFTypeID for source frame objects.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressorSourceFrameGetTypeID: CFTypeID; external name '_ICMCompressorSourceFrameGetTypeID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressorSourceFrameGetPixelBuffer()
 *  
 *  Summary:
 *    Retrieves a source frame's pixel buffer.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressorSourceFrameGetPixelBuffer( sourceFrame: ICMCompressorSourceFrameRef ): CVPixelBufferRef; external name '_ICMCompressorSourceFrameGetPixelBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressorSourceFrameGetDisplayNumber()
 *  
 *  Summary:
 *    Retrieves a source frame's display number.
 *  
 *  Discussion:
 *    The ICM tags source frames with display numbers in the order they
 *    are passed to ICMCompressionSessionEncodeFrame; the first display
 *    number is 1. Compressors may compare these numbers to work out
 *    whether prediction is forward or backward even when display times
 *    are not provided.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressorSourceFrameGetDisplayNumber( sourceFrame: ICMCompressorSourceFrameRef ): SIGNEDLONG; external name '_ICMCompressorSourceFrameGetDisplayNumber';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressorSourceFrameGetDisplayTimeStampAndDuration()
 *  
 *  Summary:
 *    Retrieves the display time stamp and duration of a source frame.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressorSourceFrameGetDisplayTimeStampAndDuration( sourceFrame: ICMCompressorSourceFrameRef; displayTimeStampOut: TimeValue64Ptr { can be NULL }; displayDurationOut: TimeValue64Ptr { can be NULL }; timeScaleOut: TimeScalePtr { can be NULL }; validTimeFlagsOut: ICMValidTimeFlagsPtr { can be NULL } ): OSStatus; external name '_ICMCompressorSourceFrameGetDisplayTimeStampAndDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressorSourceFrameGetFrameOptions()
 *  
 *  Summary:
 *    Retrieves the frame compression options for a source frame.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressorSourceFrameGetFrameOptions( sourceFrame: ICMCompressorSourceFrameRef ): ICMCompressionFrameOptionsRef; external name '_ICMCompressorSourceFrameGetFrameOptions';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressorSourceFrameDetachPixelBuffer()
 *  
 *  Summary:
 *    Disconnects the pixel buffer from the source frame and allows it
 *    to be released.
 *  
 *  Discussion:
 *    Compressor components often need to hold onto
 *    ICMCompressorSourceFrameRefs for some time after they are done
 *    with the pixel buffers. In order to allow pixel buffer memory to
 *    be released earlier, they may call
 *    ICMCompressorSourceFrameDetachPixelBuffer to declare that they
 *    have no further need for the source frame's pixel buffer. After
 *    calling this, ICMCompressorSourceFrameGetPixelBuffer will return
 *    NULL.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressorSourceFrameDetachPixelBuffer( sourceFrame: ICMCompressorSourceFrameRef ): OSStatus; external name '_ICMCompressorSourceFrameDetachPixelBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressorSessionDropFrame()
 *  
 *  Summary:
 *    Called by a compressor to indicate that sourceFrame has been
 *    dropped and will not contribute to any encoded frames.
 *  
 *  Discussion:
 *    Calling this function does not automatically release the source
 *    frame; if the compressor called ICMCompressorSourceFrameRetain it
 *    should still call ICMCompressorSourceFrameRelease.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressorSessionDropFrame( session: ICMCompressorSessionRef; sourceFrame: ICMCompressorSourceFrameRef ): OSStatus; external name '_ICMCompressorSessionDropFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMCompressorSessionEmitEncodedFrame()
 *  
 *  Summary:
 *    Called by a compressor to output an encoded frame corresponding
 *    to one (or more) source frames.
 *  
 *  Discussion:
 *    (Encoded frames may only correspond to more than one source frame
 *    if allowFrameTimeChanges is set in the
 *    compressionSessionOptions.) 
 *    After calling this, the compressor should release the encoded
 *    frame by calling ICMEncodedFrameRelease. 
 *    Calling this function does not automatically release the source
 *    frames; if the compressor called ICMCompressorSourceFrameRetain
 *    it should still call ICMCompressorSourceFrameRelease.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMCompressorSessionEmitEncodedFrame( session: ICMCompressorSessionRef; encodedFrame: ICMMutableEncodedFrameRef; numberOfSourceFrames: SIGNEDLONG; sourceFrames: {variable-size-array} ICMCompressorSourceFrameRefPtr ): OSStatus; external name '_ICMCompressorSessionEmitEncodedFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMEncodedFrameCreateMutable()
 *  
 *  Summary:
 *    Called by a compressor to create an encoded-frame token
 *    corresponding to a given source frame.
 *  
 *  Discussion:
 *    The encoded frame will initially have zero mediaSampleFlags; if
 *    the frame is not a key frame, the compressor must call
 *    ICMEncodedFrameSetMediaSampleFlags to set mediaSampleNotSync. If
 *    the frame is droppable, the compressor should set
 *    mediaSampleDroppable. If the frame is a partial key frame, the
 *    compressor should set mediaSamplePartialSync. 
 *    The encoded frame will initially have undefined decodeTimeStamp
 *    and decodeDuration. The compressor may set these directly by
 *    calling ICMEncodedFrameSetDecodeTimeStamp and/or
 *    ICMEncodedFrameSetDecodeDuration. If these are not set by the
 *    compressor, the ICM will attempt to derive them.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMEncodedFrameCreateMutable( session: ICMCompressorSessionRef; sourceFrame: ICMCompressorSourceFrameRef; bufferSize: ByteCount; var frameOut: ICMMutableEncodedFrameRef ): OSStatus; external name '_ICMEncodedFrameCreateMutable';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ Multi-pass storage access routines for compressor components }
{
 *  ICMMultiPassStorageSetDataAtTimeStamp()
 *  
 *  Summary:
 *    Called by a multipass-capable compressor to store data at a given
 *    timestamp.
 *  
 *  Discussion:
 *    The new data replaces any previous data held at that timestamp.
 *    If data is NULL, the data for that timestamp is deleted. The
 *    format of the data is private to the compressor.
 *  
 *  Parameters:
 *    
 *    multiPassStorage:
 *      The multipass storage object.
 *    
 *    timeStamp:
 *      The time stamp at which the value should be stored.
 *    
 *    index:
 *      An index by which multiple values may be stored at a time
 *      stamp. The meaning of individual indexes is private to the
 *      compressor.
 *    
 *    data:
 *      The data to be stored, or NULL to delete the value.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMMultiPassStorageSetDataAtTimeStamp( multiPassStorage: ICMMultiPassStorageRef; timeStamp: TimeValue64; index: SIGNEDLONG; data: CFDataRef ): OSStatus; external name '_ICMMultiPassStorageSetDataAtTimeStamp';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMMultiPassStorageGetTimeStamp()
 *  
 *  Summary:
 *    Called by a multipass-capable compressor to retrieve a time stamp
 *    for which a value is stored.
 *  
 *  Parameters:
 *    
 *    multiPassStorage:
 *      The multipass storage object.
 *    
 *    fromTimeStamp:
 *      The initial time stamp.  Ignored for some values of step.
 *    
 *    step:
 *      Indicates the kind of time stamp search to perform.
 *    
 *    timeStampOut:
 *      Points to a TimeValue64 to receive the found time stamp. It
 *      will be set to -1 if no time stamp is found.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMMultiPassStorageGetTimeStamp( multiPassStorage: ICMMultiPassStorageRef; fromTimeStamp: TimeValue64; step: ICMMultiPassStorageStep; var timeStampOut: TimeValue64 ): OSStatus; external name '_ICMMultiPassStorageGetTimeStamp';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  ICMMultiPassStorageCopyDataAtTimeStamp()
 *  
 *  Summary:
 *    Called by a multipass-capable compressor to retrieve data at a
 *    given timestamp.
 *  
 *  Parameters:
 *    
 *    multiPassStorage:
 *      The multipass storage object.
 *    
 *    timeStamp:
 *      The time stamp at which the value should be retrieved.
 *    
 *    index:
 *      An index by which multiple values may be stored at a time
 *      stamp. The meaning of individual indexes is private to the
 *      compressor.
 *    
 *    dataOut:
 *      Points to a CFMutableDataRef to receive the value. It will be
 *      set to a newly-created CFMutableData containing the value for
 *      the given time stamp and index, or set to NULL if no value is
 *      at that time stamp and index. It is the caller's responsibility
 *      to release the CFMutableData.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ICMMultiPassStorageCopyDataAtTimeStamp( multiPassStorage: ICMMultiPassStorageRef; timeStamp: TimeValue64; index: SIGNEDLONG; var dataOut: CFMutableDataRef ): OSStatus; external name '_ICMMultiPassStorageCopyDataAtTimeStamp';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  kQTVisualContextTypeKey
 *  
 *  Summary:
 *    Read-only CFStringRef: Type of the visual context.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
var kQTVisualContextTypeKey: CFStringRef; external name '_kQTVisualContextTypeKey'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
{
 *  kQTVisualContextType_PixelBuffer
 *  
 *  Summary:
 *    Value for kQTVisualContextTypeKey for pixel buffer visual
 *    contexts.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
var kQTVisualContextType_PixelBuffer: CFStringRef; external name '_kQTVisualContextType_PixelBuffer'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
{
 *  kQTVisualContextType_OpenGLTexture
 *  
 *  Summary:
 *    Value for kQTVisualContextTypeKey for OpenGL texture visual
 *    contexts.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
var kQTVisualContextType_OpenGLTexture: CFStringRef; external name '_kQTVisualContextType_OpenGLTexture'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
{
 *  kQTVisualContextWorkingColorSpaceKey
 *  
 *  Summary:
 *    CGColorSpaceRef: Color space in which QuickTime will perform
 *    image processing. If this attribute is not set, images will be
 *    processed in the output color space.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
var kQTVisualContextWorkingColorSpaceKey: CFStringRef; external name '_kQTVisualContextWorkingColorSpaceKey'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
{
 *  kQTVisualContextOutputColorSpaceKey
 *  
 *  Summary:
 *    CGColorSpaceRef: Color space of images produced by this visual
 *    context. If this attribute is not set, images may be in any color
 *    space.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
var kQTVisualContextOutputColorSpaceKey: CFStringRef; external name '_kQTVisualContextOutputColorSpaceKey'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
{
 *  kQTVisualContextExpectedReadAheadKey
 *  
 *  Summary:
 *    CFNumberRef: Number of seconds ahead of real-time that the client
 *    expects to pull images out of the visual context.  Applications
 *    using the CoreVideo display link should set this attribute
 *    according to value returned from
 *    CVDisplayLinkGetOutputVideoLatency().
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
var kQTVisualContextExpectedReadAheadKey: CFStringRef; external name '_kQTVisualContextExpectedReadAheadKey'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
{
 *  kQTVisualContextPixelBufferAttributesKey
 *  
 *  Summary:
 *    CFDictionaryRef: Dictionary containing pixel buffer attributes as
 *    described for the CoreVideo pixel buffer pool.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
var kQTVisualContextPixelBufferAttributesKey: CFStringRef; external name '_kQTVisualContextPixelBufferAttributesKey'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
{
 *  kQTVisualContextTargetDimensionsKey
 *  
 *  Summary:
 *    CFDictionaryRef: Dictionary containing
 *    kQTVisualContextTargetDimensions_WidthKey and
 *    kQTVisualContextTargetDimensions_HeightKey.  This is only a hint
 *    to optimize certain media types, such as text, that can render at
 *    any resolution. If this attribute is not set, the movie will
 *    render at its native resolution.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
var kQTVisualContextTargetDimensionsKey: CFStringRef; external name '_kQTVisualContextTargetDimensionsKey'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
{
 *  kQTVisualContextTargetDimensions_WidthKey
 *  
 *  Summary:
 *    CFNumberRef: Width, in pixels, of the rendering target.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
var kQTVisualContextTargetDimensions_WidthKey: CFStringRef; external name '_kQTVisualContextTargetDimensions_WidthKey'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
{
 *  kQTVisualContextTargetDimensions_HeightKey
 *  
 *  Summary:
 *    CFNumberRef: Height, in pixels, of the rendering target.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
var kQTVisualContextTargetDimensions_HeightKey: CFStringRef; external name '_kQTVisualContextTargetDimensions_HeightKey'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
{
 *  QTVisualContextRetain()
 *  
 *  Summary:
 *    Increments the visual context's reference count.
 *  
 *  Discussion:
 *    The same visual context is returned for convenience. If
 *    visualContext is NULL, nothing happens.
 *  
 *  Parameters:
 *    
 *    visualContext:
 *      [in] The visual context to retain.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTVisualContextRetain( visualContext: QTVisualContextRef ): QTVisualContextRef; external name '_QTVisualContextRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTVisualContextRelease()
 *  
 *  Summary:
 *    Decrements the visual context's reference count.
 *  
 *  Discussion:
 *    If the retain count decreases to zero, the visual context is
 *    disposed. If visualContext is NULL, nothing happens.
 *  
 *  Parameters:
 *    
 *    visualContext:
 *      [in] The visual context to release.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure QTVisualContextRelease( visualContext: QTVisualContextRef ); external name '_QTVisualContextRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTVisualContextGetTypeID()
 *  
 *  Summary:
 *    Returns the CFTypeID for QTVisualContextRef.
 *  
 *  Discussion:
 *    You could use this to test whether a CFTypeRef that extracted
 *    from a CF container such as a CFArray was a QTVisualContextRef. 
 *    All visual contexts have the same CFTypeID.  If you need to
 *    distinguish between different types of visual contexts (eg.
 *    PixelBuffer vs. OpenGLTexture), query for kQTVisualContextTypeKey
 *    with QTVisualContextGetAttribute().
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTVisualContextGetTypeID: CFTypeID; external name '_QTVisualContextGetTypeID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTVisualContextSetAttribute()
 *  
 *  Summary:
 *    Sets a visual context attribute.
 *  
 *  Parameters:
 *    
 *    visualContext:
 *      [in] The visual context.
 *    
 *    attributeKey:
 *      [in] Identifier of attribute to set.
 *    
 *    attributeValue:
 *      [in] Value of attribute to set, or NULL to remove a value.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTVisualContextSetAttribute( visualContext: QTVisualContextRef; attributeKey: CFStringRef; attributeValue: CFTypeRef { can be NULL } ): OSStatus; external name '_QTVisualContextSetAttribute';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTVisualContextGetAttribute()
 *  
 *  Summary:
 *    Gets a visual context attribute.
 *  
 *  Parameters:
 *    
 *    visualContext:
 *      [in]  The visual context.
 *    
 *    attributeKey:
 *      [in]  Identifier of attribute to get.
 *    
 *    attributeValueOut:
 *      [out] Pointer to variable that will receive the attribute
 *      value, or NULL if the attribute is not set.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTVisualContextGetAttribute( visualContext: QTVisualContextRef; attributeKey: CFStringRef; var attributeValueOut: CFTypeRef ): OSStatus; external name '_QTVisualContextGetAttribute';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTVisualContextImageAvailableCallback
 *  
 *  Summary:
 *    User-defined callback function to recieve notifications when a
 *    new image becomes available.
 *  
 *  Discussion:
 *    Due to unpredictible activity, such as user seeks or the arrival
 *    of streaming video packets from a network, new images may become
 *    available for times supposedly occupied by previous images. 
 *    Applications using the CoreVideo display link to drive rendering
 *    probably do not need to install a callback of this type since
 *    they will already be checking for new images at a sufficient rate.
 *  
 *  Parameters:
 *    
 *    visualContext:
 *      [in] The visual context invoking the callback.
 *    
 *    timeStamp:
 *      [in] Time for which a new image has become available.
 *    
 *    refCon:
 *      [in] User-defined value passed to
 *      QTVisualContextSetImageAvailableCallback.
 }
type
	QTVisualContextImageAvailableCallback = procedure( visualContext: QTVisualContextRef; const (*var*) timeStamp: CVTimeStamp; refCon: UnivPtr );
{
 *  QTVisualContextSetImageAvailableCallback()
 *  
 *  Summary:
 *    Installs user-defined callback to be notified when new images
 *    become available.
 *  
 *  Discussion:
 *    This routine installs the user defined
 *    QTVisualContextImageAvailableCallback callback. There can only be
 *    one callback associated with a QTVisualContext at a given time.
 *  
 *  Parameters:
 *    
 *    visualContext:
 *      [in] The visual context.
 *    
 *    imageAvailableCallback:
 *      [in] User-defined callback function to recieve notifications.
 *      Pass NULL to remove any existing callback.
 *    
 *    refCon:
 *      [in] User-defined value to pass to
 *      QTVisualContextImageAvailableCallback.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTVisualContextSetImageAvailableCallback( visualContext: QTVisualContextRef; imageAvailableCallback: QTVisualContextImageAvailableCallback { can be NULL }; refCon: UnivPtr { can be NULL } ): OSStatus; external name '_QTVisualContextSetImageAvailableCallback';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTVisualContextIsNewImageAvailable()
 *  
 *  Summary:
 *    Queries whether a new image is available for a given time.
 *  
 *  Discussion:
 *    This function returns true if there is a image available for the
 *    specified time that is different from the last image retrieved
 *    from QTVisualContextCopyImageForTime. See
 *    QTVisualContextCopyImageForTime for restrictions on time-stamps.
 *  
 *  Parameters:
 *    
 *    visualContext:
 *      [in] The visual context.
 *    
 *    timeStamp:
 *      [in] Time in question.  Pass NULL to request the image at the
 *      current time.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTVisualContextIsNewImageAvailable( visualContext: QTVisualContextRef; {const} timeStamp: CVTimeStampPtr { can be NULL } ): Boolean; external name '_QTVisualContextIsNewImageAvailable';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTVisualContextCopyImageForTime()
 *  
 *  Summary:
 *    Retrieves an image buffer from the visual context, indexed by the
 *    provided timestamp.
 *  
 *  Discussion:
 *    You should not request image buffers further ahead of the current
 *    time than the read-ahead time specified with the
 *    kQTVisualContextExpectedReadAheadKey attribute.  You may skip
 *    images by passing later times, but you may not pass an earlier
 *    time than passed to a previous call to this function.
 *  
 *  Parameters:
 *    
 *    visualContext:
 *      [in]  The visual context.
 *    
 *    allocator:
 *      [in]  Allocator used to create new CVImageBufferRef.
 *    
 *    timeStamp:
 *      [in]  Time in question.  Pass NULL to request the image at the
 *      current time.
 *    
 *    newImage:
 *      [out] Points to variable to receive new image. If there is no
 *      video at the requested time, this variable will be set to NULL.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTVisualContextCopyImageForTime( visualContext: QTVisualContextRef; allocator: CFAllocatorRef { can be NULL }; {const} timeStamp: CVTimeStampPtr { can be NULL }; var newImage: CVImageBufferRef ): OSStatus; external name '_QTVisualContextCopyImageForTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTVisualContextTask()
 *  
 *  Summary:
 *    Causes visual context to release internally held resources for
 *    later re-use.
 *  
 *  Discussion:
 *    For optimal resource management, this function should be called
 *    in every rendering pass, after old images have been released, new
 *    images have been used and all rendering has been flushed to the
 *    screen.  This call is not mandatory.
 *  
 *  Parameters:
 *    
 *    visualContext:
 *      [in] The visual context.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure QTVisualContextTask( visualContext: QTVisualContextRef ); external name '_QTVisualContextTask';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTOpenGLTextureContextCreate()
 *  
 *  Summary:
 *    Creates a new OpenGL texture context for the given OpenGL context
 *    and pixel format.
 *  
 *  Discussion:
 *    This function will fail if the graphics hardware is insufficient.
 *  
 *  Parameters:
 *    
 *    allocator:
 *      [in]  Allocator used to create the texture context.
 *    
 *    cglContext:
 *      [in]  OpenGL context used to create textures.
 *    
 *    cglPixelFormat:
 *      [in]  OpenGL pixel format used to create the OpenGL context.
 *    
 *    attributes:
 *      [in]  Dictionary of attributes.
 *    
 *    newTextureContext:
 *      [out] Points to a variable to recieve the new OpenGL texture
 *      context.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTOpenGLTextureContextCreate( allocator: CFAllocatorRef { can be NULL }; cglContext: CGLContextObj; cglPixelFormat: CGLPixelFormatObj; attributes: CFDictionaryRef { can be NULL }; var newTextureContext: QTVisualContextRef ): OSStatus; external name '_QTOpenGLTextureContextCreate';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTPixelBufferContextCreate()
 *  
 *  Summary:
 *    Creates a new pixel buffer context with the given attributes.
 *  
 *  Discussion:
 *    This function will fail if the graphics hardware is insufficient.
 *  
 *  Parameters:
 *    
 *    allocator:
 *      [in]  Allocator used to create the pixel buffer context.
 *    
 *    attributes:
 *      [in]  Dictionary of attributes.
 *    
 *    newPixelBufferContext:
 *      [out] Points to a variable to recieve the new pixel buffer
 *      context.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTPixelBufferContextCreate( allocator: CFAllocatorRef { can be NULL }; attributes: CFDictionaryRef { can be NULL }; var newPixelBufferContext: QTVisualContextRef ): OSStatus; external name '_QTPixelBufferContextCreate';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{$endc} {not TARGET_CPU_64}

{$endc} {TARGET_OS_MAC}
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
