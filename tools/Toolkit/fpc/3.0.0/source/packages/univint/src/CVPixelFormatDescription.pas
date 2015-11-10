{
 *  CVPixelFormatDescription.h
 *  CoreVideo
 *
 *  Copyright (c) 2004 Apple Computer, Inc. All rights reserved.
 *
 }
{  Pascal Translation:  Gale R Paeper, <gpaeper@empirenet.com>, 2008 }
{  Pascal Translation Update:  Gorazd Krosl, <gorazd_1957@yahoo.ca>, 2009 }
{  Pascal Translation Update: Jonas Maebe <jonas@freepascal.org>, October 2012 }
 
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

unit CVPixelFormatDescription;
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
uses MacTypes, CFArray, CFBase, CFDictionary, CVPixelBuffer;
{$endc} {not MACOSALLINCLUDE}


{$ALIGN POWER}


{ This document is influenced by Ice Floe #19: http://developer.apple.com/quicktime/icefloe/dispatch019.html }

{ The canonical name for the format.  This should bethe same as the codec name you'd use in QT }
var kCVPixelFormatName: CFStringRef; external name '_kCVPixelFormatName'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ QuickTime/QuickDraw Pixel Format Type constant (OSType) }
var kCVPixelFormatConstant: CFStringRef; external name '_kCVPixelFormatConstant'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ This is the codec type constant, i.e. '2vuy' or k422YpCbCr8CodecType }
var kCVPixelFormatCodecType: CFStringRef; external name '_kCVPixelFormatCodecType'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ This is the equivalent Microsoft FourCC code for this pixel format }
var kCVPixelFormatFourCC: CFStringRef; external name '_kCVPixelFormatFourCC'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ kCFBooleanTrue indicates that the format contains alpha and some images may be considered transparent;
   kCFBooleanFalse indicates that there is no alpha and images are always opaque. }
var kCVPixelFormatContainsAlpha: CFStringRef; external name '_kCVPixelFormatContainsAlpha'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_3) *)

{ All buffers have one or more image planes.  Each plane may contain a single or an interleaved set of components }   
{ For simplicity sake, pixel formats that are not planar may place the required format keys at the top
   level dictionary. }
var kCVPixelFormatPlanes: CFStringRef; external name '_kCVPixelFormatPlanes'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ The following keys describe the requirements/layout of a a single image plane. }

{ Used to assist with allocating memory for pixel formats that don't have an integer value for
   bytes per pixel }
{ Block width is essentially the width in pixels of the smallest "byte addressable" group of pixels }
{ This works in close conjunction with BitsPerBlock }
{ Examples:
   8-bit luminance only, BlockWidth would be 1, BitsPerBlock would be 8
   16-bit 1555 RGB, BlockWidth would be 1, BitsPerBlock would be 16
   32-bit 8888 ARGB, BlockWidth would be 1, BitsPerBlock would be 32
   2vuy (CbYCrY), BlockWidth would be 2, BitsPerBlock would be 32
   1-bit bitmap, BlockWidth would be 8, BitsPerBlock would be 8
   v210, BlockWidth would be 6, BitsPerBlock would be 128 }
{ Values assumed to 1 be one if not present }
var kCVPixelFormatBlockWidth: CFStringRef; external name '_kCVPixelFormatBlockWidth'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)
var kCVPixelFormatBlockHeight: CFStringRef; external name '_kCVPixelFormatBlockHeight'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ This value must be present.  For simple pixel formats this will be equivalent to the traditional 
   bitsPerPixel value. }
var kCVPixelFormatBitsPerBlock: CFStringRef; external name '_kCVPixelFormatBitsPerBlock'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ Used to state requirements on block multiples.  v210 would be '8' here for the horizontal case, 
   to match the standard v210 row alignment value of 48.
   These may be assumed as 1 if not present. }
var kCVPixelFormatBlockHorizontalAlignment: CFStringRef; external name '_kCVPixelFormatBlockHorizontalAlignment'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)
var kCVPixelFormatBlockVerticalAlignment: CFStringRef; external name '_kCVPixelFormatBlockVerticalAlignment'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ CFData containing the bit pattern for a block of black pixels.  If absent, black is assumed to be all zeros.
   If present, this should be bitsPerPixel bits long -- if bitsPerPixel is less than a byte, repeat the bit pattern 
   for the full byte.  }
var kCVPixelFormatBlackBlock: CFStringRef; external name '_kCVPixelFormatBlackBlock'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_4_0) *)

{ Subsampling information for this plane.  Assumed to be '1' if not present. }
var kCVPixelFormatHorizontalSubsampling: CFStringRef; external name '_kCVPixelFormatHorizontalSubsampling'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)
var kCVPixelFormatVerticalSubsampling: CFStringRef; external name '_kCVPixelFormatVerticalSubsampling'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ If present, these two keys describe the OpenGL format and type enums you would use to describe this
   image plane to OpenGL }
var kCVPixelFormatOpenGLFormat: CFStringRef; external name '_kCVPixelFormatOpenGLFormat'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)
var kCVPixelFormatOpenGLType: CFStringRef; external name '_kCVPixelFormatOpenGLType'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)
var kCVPixelFormatOpenGLInternalFormat: CFStringRef; external name '_kCVPixelFormatOpenGLInternalFormat'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ CGBitmapInfo value, if required }
var kCVPixelFormatCGBitmapInfo: CFStringRef; external name '_kCVPixelFormatCGBitmapInfo'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ Pixel format compatibility flags }
var kCVPixelFormatQDCompatibility: CFStringRef; external name '_kCVPixelFormatQDCompatibility'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)
var kCVPixelFormatCGBitmapContextCompatibility: CFStringRef; external name '_kCVPixelFormatCGBitmapContextCompatibility'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)
var kCVPixelFormatCGImageCompatibility: CFStringRef; external name '_kCVPixelFormatCGImageCompatibility'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)
var kCVPixelFormatOpenGLCompatibility: CFStringRef; external name '_kCVPixelFormatOpenGLCompatibility'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)
{$ifc TARGET_OS_IPHONE}
var kCVPixelFormatOpenGLESCompatibility: CFStringRef; external name '_kCVPixelFormatOpenGLESCompatibility'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0) *)
{$endc}

{ This callback routine implements code to handle the functionality of CVPixelBufferFillExtendedPixels.  
   For custom pixel formats where you will never need to use that call, this is not required. }
type
	CVFillExtendedPixelsCallBack = function( pixelBuffer: CVPixelBufferRef; refCon: UnivPtr ): Boolean;
	CVFillExtendedPixelsCallBackData = record
		version: CFIndex;
		fillCallBack: CVFillExtendedPixelsCallBack;
		refCon: UnivPtr;
	end;

{ The value for this key is a CFData containing a CVFillExtendedPixelsCallBackData struct }
var kCVPixelFormatFillExtendedPixelsCallback: CFStringRef; external name '_kCVPixelFormatFillExtendedPixelsCallback'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ Create a description of a pixel format from a provided OSType }
function CVPixelFormatDescriptionCreateWithPixelFormatType( allocator: CFAllocatorRef; pixelFormat: OSType ): CFDictionaryRef; external name '_CVPixelFormatDescriptionCreateWithPixelFormatType';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ Get an array containing all known pixel format description dictionaries }
function CVPixelFormatDescriptionArrayCreateWithAllPixelFormatTypes( allocator: CFAllocatorRef ): CFArrayRef; external name '_CVPixelFormatDescriptionArrayCreateWithAllPixelFormatTypes';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{ Register a new pixel format with CoreVideo }
procedure CVPixelFormatDescriptionRegisterDescriptionWithPixelFormatType( description: CFDictionaryRef; pixelFormat: OSType ); external name '_CVPixelFormatDescriptionRegisterDescriptionWithPixelFormatType';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)


{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
