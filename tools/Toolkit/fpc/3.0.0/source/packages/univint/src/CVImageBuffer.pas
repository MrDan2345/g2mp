{
 *  CVImageBuffer.h
 *  CoreVideo
 *
 *  Copyright (c) 2004 Apple Computer, Inc. All rights reserved.
 *
 }
{  Pascal Translation:  Gale R Paeper, <gpaeper@empirenet.com>, 2008 }
{  Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
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

unit CVImageBuffer;
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
uses CFBase, CFDictionary, CGColorSpace, CGGeometry,CVBuffer;
{$endc} {not MACOSALLINCLUDE}


{$ALIGN POWER}

 
 {! @header CVImageBuffer.h
	@copyright 2004 Apple Computer, Inc. All rights reserved.
	@availability Mac OS X 10.4 or later
    @discussion CVImageBufferRef types are abstract and define various attachments and convenience
		calls for retreiving image related bits of data.
		   
}

//#pragma mark CVImageBufferRef attachment keys

var kCVImageBufferCGColorSpaceKey: CFStringRef; external name '_kCVImageBufferCGColorSpaceKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)				// CGColorSpaceRef

var kCVImageBufferCleanApertureKey: CFStringRef; external name '_kCVImageBufferCleanApertureKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)				// CFDictionary containing the following four keys
var kCVImageBufferCleanApertureWidthKey: CFStringRef; external name '_kCVImageBufferCleanApertureWidthKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)			// CFNumber
var kCVImageBufferCleanApertureHeightKey: CFStringRef; external name '_kCVImageBufferCleanApertureHeightKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)			// CFNumber
var kCVImageBufferCleanApertureHorizontalOffsetKey: CFStringRef; external name '_kCVImageBufferCleanApertureHorizontalOffsetKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)		// CFNumber
var kCVImageBufferCleanApertureVerticalOffsetKey: CFStringRef; external name '_kCVImageBufferCleanApertureVerticalOffsetKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)		// CFNumber
var kCVImageBufferPreferredCleanApertureKey: CFStringRef; external name '_kCVImageBufferPreferredCleanApertureKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)			// CFDictionary containing same keys as kCVImageBufferCleanApertureKey

var kCVImageBufferFieldCountKey: CFStringRef; external name '_kCVImageBufferFieldCountKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)				// CFNumber
var kCVImageBufferFieldDetailKey: CFStringRef; external name '_kCVImageBufferFieldDetailKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)				// CFString with one of the following four values
var kCVImageBufferFieldDetailTemporalTopFirst: CFStringRef; external name '_kCVImageBufferFieldDetailTemporalTopFirst'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)		// CFString
var kCVImageBufferFieldDetailTemporalBottomFirst: CFStringRef; external name '_kCVImageBufferFieldDetailTemporalBottomFirst'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)		// CFString
var kCVImageBufferFieldDetailSpatialFirstLineEarly: CFStringRef; external name '_kCVImageBufferFieldDetailSpatialFirstLineEarly'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)		// CFString
var kCVImageBufferFieldDetailSpatialFirstLineLate: CFStringRef; external name '_kCVImageBufferFieldDetailSpatialFirstLineLate'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)		// CFString

var kCVImageBufferPixelAspectRatioKey: CFStringRef; external name '_kCVImageBufferPixelAspectRatioKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)				// CFDictionary with the following two keys
var kCVImageBufferPixelAspectRatioHorizontalSpacingKey: CFStringRef; external name '_kCVImageBufferPixelAspectRatioHorizontalSpacingKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)	// CFNumber
var kCVImageBufferPixelAspectRatioVerticalSpacingKey: CFStringRef; external name '_kCVImageBufferPixelAspectRatioVerticalSpacingKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)	// CFNumber

var kCVImageBufferDisplayDimensionsKey: CFStringRef; external name '_kCVImageBufferDisplayDimensionsKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)				// CFDictionary with the following two keys
var kCVImageBufferDisplayWidthKey: CFStringRef; external name '_kCVImageBufferDisplayWidthKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)				// CFNumber
var kCVImageBufferDisplayHeightKey: CFStringRef; external name '_kCVImageBufferDisplayHeightKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)				// CFNumber

var kCVImageBufferGammaLevelKey: CFStringRef; external name '_kCVImageBufferGammaLevelKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)				// CFNumber describing the gamma level, used in absence of (or ignorance of) kCVImageBufferTransferFunctionKey

var kCVImageBufferICCProfileKey: CFStringRef; external name '_kCVImageBufferICCProfileKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_4_0) *)				// CFData representation of the ICC profile

var kCVImageBufferYCbCrMatrixKey: CFStringRef; external name '_kCVImageBufferYCbCrMatrixKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)				// CFString describing the color matrix for YCbCr->RGB. This key can be one of the following values:
var kCVImageBufferYCbCrMatrix_ITU_R_709_2: CFStringRef; external name '_kCVImageBufferYCbCrMatrix_ITU_R_709_2'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)			// CFString
var kCVImageBufferYCbCrMatrix_ITU_R_601_4: CFStringRef; external name '_kCVImageBufferYCbCrMatrix_ITU_R_601_4'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)			// CFString
var kCVImageBufferYCbCrMatrix_SMPTE_240M_1995: CFStringRef; external name '_kCVImageBufferYCbCrMatrix_SMPTE_240M_1995'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)		// CFString

var kCVImageBufferColorPrimariesKey: CFStringRef; external name '_kCVImageBufferColorPrimariesKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)				// CFString describing the color primaries. This key can be one of the following values
var kCVImageBufferColorPrimaries_ITU_R_709_2: CFStringRef; external name '_kCVImageBufferColorPrimaries_ITU_R_709_2'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)
var kCVImageBufferColorPrimaries_EBU_3213: CFStringRef; external name '_kCVImageBufferColorPrimaries_EBU_3213'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)
var kCVImageBufferColorPrimaries_SMPTE_C: CFStringRef; external name '_kCVImageBufferColorPrimaries_SMPTE_C'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)
var kCVImageBufferColorPrimaries_P22: CFStringRef; external name '_kCVImageBufferColorPrimaries_P22'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_8,__IPHONE_6_0) *)

var kCVImageBufferTransferFunctionKey: CFStringRef; external name '_kCVImageBufferTransferFunctionKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)				// CFString describing the transfer function. This key can be one of the following values
var kCVImageBufferTransferFunction_ITU_R_709_2: CFStringRef; external name '_kCVImageBufferTransferFunction_ITU_R_709_2'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)
var kCVImageBufferTransferFunction_SMPTE_240M_1995: CFStringRef; external name '_kCVImageBufferTransferFunction_SMPTE_240M_1995'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_4_0) *)
var kCVImageBufferTransferFunction_UseGamma: CFStringRef; external name '_kCVImageBufferTransferFunction_UseGamma'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_4_0) *)
var kCVImageBufferTransferFunction_EBU_3213: CFStringRef; external name '_kCVImageBufferTransferFunction_EBU_3213'; (* attribute const *)
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_5,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)			// Should not be used.
var kCVImageBufferTransferFunction_SMPTE_C: CFStringRef; external name '_kCVImageBufferTransferFunction_SMPTE_C'; (* attribute const *)
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_5,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)			// Should not be used.

{ Chroma siting information. For progressive images, only the TopField value is used. }
var kCVImageBufferChromaLocationTopFieldKey: CFStringRef; external name '_kCVImageBufferChromaLocationTopFieldKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)			// CFString with one of the following CFString values
var kCVImageBufferChromaLocationBottomFieldKey: CFStringRef; external name '_kCVImageBufferChromaLocationBottomFieldKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)		// CFString with one of the following CFString values
var kCVImageBufferChromaLocation_Left: CFStringRef; external name '_kCVImageBufferChromaLocation_Left'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)			    // Chroma sample is horizontally co-sited with the left column of luma samples, but centered vertically.
var kCVImageBufferChromaLocation_Center: CFStringRef; external name '_kCVImageBufferChromaLocation_Center'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)			    // Chroma sample is fully centered
var kCVImageBufferChromaLocation_TopLeft: CFStringRef; external name '_kCVImageBufferChromaLocation_TopLeft'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)			    // Chroma sample is co-sited with the top-left luma sample.
var kCVImageBufferChromaLocation_Top: CFStringRef; external name '_kCVImageBufferChromaLocation_Top'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)			    // Chroma sample is horizontally centered, but co-sited with the top row of luma samples.
var kCVImageBufferChromaLocation_BottomLeft: CFStringRef; external name '_kCVImageBufferChromaLocation_BottomLeft'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)		    // Chroma sample is co-sited with the bottom-left luma sample.
var kCVImageBufferChromaLocation_Bottom: CFStringRef; external name '_kCVImageBufferChromaLocation_Bottom'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)			    // Chroma sample is horizontally centered, but co-sited with the bottom row of luma samples.
var kCVImageBufferChromaLocation_DV420: CFStringRef; external name '_kCVImageBufferChromaLocation_DV420'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)			    // Cr and Cb samples are alternately co-sited with the left luma samples of the same field.

// These describe the format of the original subsampled data before conversion to 422/2vuy.   In order to use
// these tags, the data must have been converted to 4:2:2 via simple pixel replication.
var kCVImageBufferChromaSubsamplingKey: CFStringRef; external name '_kCVImageBufferChromaSubsamplingKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)		// CFString/CFNumber with one of the following values
var kCVImageBufferChromaSubsampling_420: CFStringRef; external name '_kCVImageBufferChromaSubsampling_420'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)
var kCVImageBufferChromaSubsampling_422: CFStringRef; external name '_kCVImageBufferChromaSubsampling_422'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)
var kCVImageBufferChromaSubsampling_411: CFStringRef; external name '_kCVImageBufferChromaSubsampling_411'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_4_0) *)

//#pragma mark CVImageBufferRef

{!
    @typedef	CVImageBufferRef
    @abstract   Base type for all CoreVideo image buffers

}
type
	CVImageBufferRef = CVBufferRef;

{!
    @function   CVImageBufferGetEncodedSize
    @abstract   Returns the full encoded dimensions of a CVImageBuffer.  For example, for an NTSC DV frame this would be 720x480
    @discussion Note: When creating a CIImage from a CVImageBuffer, this is the call you should use for retrieving the image size.
    @param      imageBuffer A CVImageBuffer that you wish to retrieve the encoded size from.
    @result     A CGSize returning the full encoded size of the buffer
		Returns zero size if called with a non-CVImageBufferRef type or NULL.
}
function CVImageBufferGetEncodedSize( imageBuffer: CVImageBufferRef ): CGSize; external name '_CVImageBufferGetEncodedSize';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{!
    @function   CVImageBufferGetDisplaySize
    @abstract   Returns the nominal output display size (in square pixels) of a CVImageBuffer.  
                For example, for an NTSC DV frame this would be 640x480
    @param      imageBuffer A CVImageBuffer that you wish to retrieve the display size from.
    @result     A CGSize returning the nominal display size of the buffer
		Returns zero size if called with a non-CVImageBufferRef type or NULL.
}
function CVImageBufferGetDisplaySize( imageBuffer: CVImageBufferRef ): CGSize; external name '_CVImageBufferGetDisplaySize';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{!
    @function   CVImageBufferGetCleanRect
    @abstract   Returns the source rectangle of a CVImageBuffer that represents the clean aperture
		of the buffer in encoded pixels.    For example, an NTSC DV frame would return a CGRect with an
		origin of 8,0 and a size of 704,480.		
		Note that the origin of this rect always the lower left	corner.   This is the same coordinate system as
		used by CoreImage.
    @param      imageBuffer A CVImageBuffer that you wish to retrieve the display size from.
    @result     A CGSize returning the nominal display size of the buffer
		Returns zero rect if called with a non-CVImageBufferRef type or NULL.
}
function CVImageBufferGetCleanRect( imageBuffer: CVImageBufferRef ): CGRect; external name '_CVImageBufferGetCleanRect';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{!
    @function   CVImageBufferIsFlipped
    @abstract   Returns whether the image is flipped vertically or not.
    @param      CVImageBuffer target
    @result     True if 0,0 in the texture is upper left, false if 0,0 is lower left.
}
function CVImageBufferIsFlipped( imageBuffer: CVImageBufferRef ): Boolean; external name '_CVImageBufferIsFlipped';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)


{$ifc TARGET_OS_MAC}
{!
    @function   CVImageBufferGetColorSpace
    @abstract   Returns the color space of a CVImageBuffer.
    @param      imageBuffer A CVImageBuffer that you wish to retrieve the color space from.
    @result     A CGColorSpaceRef representing the color space of the buffer.
		Returns NULL if called with a non-CVImageBufferRef type or NULL.
}
function CVImageBufferGetColorSpace( imageBuffer: CVImageBufferRef ): CGColorSpaceRef; external name '_CVImageBufferGetColorSpace';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{!
   @function   CVImageBufferCreateColorSpaceFromAttachments
   @abstract   Attempts to synthesize a CGColorSpace from an image buffer's attachments.
   @param      attachments A CFDictionary of attachments for an image buffer, obtained using CVBufferGetAttachments().
   @result     A CGColorSpaceRef representing the color space of the buffer.
		Returns NULL if the attachments dictionary does not contain the information required to synthesize a CGColorSpace.
   @discussion
	To generate a CGColorSpace, the attachments dictionary should include values for either:
		1. kCVImageBufferICCProfile
		2. kCVImageBufferColorPrimariesKey, kCVImageBufferTransferFunctionKey, and kCVImageBufferYCbCrMatrixKey (and possibly kCVImageBufferGammaLevelKey)
	The client is responsible for releasing the CGColorSpaceRef when it is done with it (CGColorSpaceRelease() or CFRelease())
		
}
function CVImageBufferCreateColorSpaceFromAttachments( attachments: CFDictionaryRef ): CGColorSpaceRef; external name '_CVImageBufferCreateColorSpaceFromAttachments';
(* __OSX_AVAILABLE_STARTING(__MAC_10_8,__IPHONE_NA) *)

{$endc} {TARGET_OS_MAC}

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
