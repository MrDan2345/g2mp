{
 *  CVPixelBufferPool.h
 *  CoreVideo
 *
 *  Copyright 2004 Apple Computer, Inc. All rights reserved.
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

unit CVPixelBufferPool;
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
uses MacTypes, CFBase, CFDictionary, CVBase, CVPixelBuffer, CVReturns;
{$endc} {not MACOSALLINCLUDE}


{$ALIGN POWER}


 {! @header CVPixelBufferPool.h
	@copyright 2004 Apple Computer, Inc. All rights reserved.
	@availability Mac OS X 10.4 or later
    @discussion CVPixelBufferPool is a utility object for managing a set of CVPixelBuffer objects that are going to be recycled.
		   
}


type
	CVPixelBufferPoolRef = ^__CVPixelBufferPool; { an opaque type }
	__CVPixelBufferPool = record end;

// By default, buffers will age out after one second.   If required, setting an age of zero will disable
// the age-out mechanism completely.

var kCVPixelBufferPoolMinimumBufferCountKey: CFStringRef; external name '_kCVPixelBufferPoolMinimumBufferCountKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)
var kCVPixelBufferPoolMaximumBufferAgeKey: CFStringRef; external name '_kCVPixelBufferPoolMaximumBufferAgeKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)


function CVPixelBufferPoolGetTypeID: CFTypeID; external name '_CVPixelBufferPoolGetTypeID';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{!
    @function   CVPixelBufferPoolRetain
    @abstract   Retains a CVPixelBufferPoolRef object
    @discussion Equivalent to CFRetain, but NULL safe
    @param      buffer A CVPixelBufferPoolRef object that you want to retain.
    @result     A CVPixelBufferPoolRef object that is the same as the passed in buffer.
}
function CVPixelBufferPoolRetain( pixelBufferPool: CVPixelBufferPoolRef ): CVPixelBufferPoolRef; external name '_CVPixelBufferPoolRetain';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *) // NULL-safe

{!
    @function   CVPixelBufferPoolRelease
    @abstract   Releases a CVPixelBufferPoolRef object
    @discussion Equivalent to CFRelease, but NULL safe
    @param      buffer A CVPixelBufferPoolRef object that you want to release.
}
procedure CVPixelBufferPoolRelease( pixelBufferPool: CVPixelBufferPoolRef ); external name '_CVPixelBufferPoolRelease';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *) // NULL-safe

{!
    @function   CVPixelBufferPoolCreate
    @abstract   Creates a new Pixel Buffer pool.
    @param      allocator The CFAllocatorRef to use for allocating this buffer pool.  May be NULL.
    @param      attributes   A CFDictionaryRef containing the attributes to be used for creating new PixelBuffers within the pool.
    @param      poolOut   The newly created pool will be placed here
    @result     Returns kCVReturnSuccess on success
}
function CVPixelBufferPoolCreate( allocator: CFAllocatorRef; poolAttributes: CFDictionaryRef; pixelBufferAttributes: CFDictionaryRef; var poolOut: CVPixelBufferPoolRef ): CVReturn; external name '_CVPixelBufferPoolCreate';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{!
    @function   CVPixelBufferPoolGetAttributes
    @abstract   Returns the pool attributes dictionary for a CVPixelBufferPool
    @param      pool  The CVPixelBufferPoolRef to retrieve the attributes from
    @result     Returns the pool attributes dictionary, or NULL on failure.
}
function CVPixelBufferPoolGetAttributes( pool: CVPixelBufferPoolRef ): CFDictionaryRef; external name '_CVPixelBufferPoolGetAttributes';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{!
    @function   CVPixelBufferPoolGetPixelBufferAttributes
    @abstract   Returns the attributes of pixel buffers that will be created from this pool.
    @discussion This function is provided for those cases where you may need to know some information about the buffers that
                will be created up front.
    @param      pool  The CVPixelBufferPoolRef to retrieve the attributes from
    @result     Returns the pixel buffer attributes dictionary, or NULL on failure.
}
function CVPixelBufferPoolGetPixelBufferAttributes( pool: CVPixelBufferPoolRef ): CFDictionaryRef; external name '_CVPixelBufferPoolGetPixelBufferAttributes';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)

{!
    @function   CVPixelBufferPoolCreatePixelBuffer
    @abstract   Creates a new PixelBuffer object from the pool.
    @discussion The function creates a new (attachment-free) CVPixelBuffer using the pixel buffer attributes specifed during pool creation.
    @param      allocator The CFAllocatorRef to use for creating the pixel buffer.  May be NULL.
    @param      pool      The CVPixelBufferPool that should create the new CVPixelBuffer.
    @param      pixelBufferOut   The newly created pixel buffer will be placed here
    @result     Returns kCVReturnSuccess on success
}
function CVPixelBufferPoolCreatePixelBuffer( allocator: CFAllocatorRef; pixelBufferPool: CVPixelBufferPoolRef; var pixelBufferOut: CVPixelBufferRef ): CVReturn; external name '_CVPixelBufferPoolCreatePixelBuffer';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_4_0) *)


{
    @function   CVPixelBufferPoolCreatePixelBufferWithAuxAttributes
    @abstract   Creates a new PixelBuffer object from the pool.
    @discussion This function creates a new CVPixelBuffer using the pixel buffer attributes specified during pool creation and the attributes specified in the auxAttributes parameter.
    @param      allocator The CFAllocatorRef to use for creating the pixel buffer.  May be NULL.
    @param      pixelBufferPool      The CVPixelBufferPool that should create the new CVPixelBuffer.
    @param      auxAttributes	Attributes describing this specific allocation request.  May be NULL.
    @param      pixelBufferOut   The newly created pixel buffer will be placed here
    @result     Returns kCVReturnSuccess on success
}
function CVPixelBufferPoolCreatePixelBufferWithAuxAttributes( allocator: CFAllocatorRef; pixelBufferPool: CVPixelBufferPoolRef; auxAttributes: CFDictionaryRef; var pixelBufferOut: CVPixelBufferRef ): CVReturn; external name '_CVPixelBufferPoolCreatePixelBufferWithAuxAttributes';
(* __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0) *)

// Key for the auxiliary attributes dictionary passed to CVPixelBufferPoolCreatePixelBufferWithAuxAttributes().

// When set, indicates that a new pixel buffer should not be allocated if
// the pool already has this many or more pixel buffers allocated.
// This does not prevent already-allocated buffers from being recycled.
// If this key causes CVPixelBufferPoolCreatePixelBufferWithAuxAttributes to fail,
// it will return kCVReturnWouldExceedAllocationThreshold.
var kCVPixelBufferPoolAllocationThresholdKey: CFStringRef; external name '_kCVPixelBufferPoolAllocationThresholdKey'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0) *) // CFNumberRef -- for use only in auxAttributes

// kCVPixelBufferPoolFreeBufferNotification is posted if a buffer becomes available after
// CVPixelBufferPoolCreatePixelBufferWithAuxAttributes has failed due to kCVPixelBufferPoolAllocationThresholdKey.
// This notification will not be posted by the pool if kCVPixelBufferPoolAllocationThresholdKey 
// has never been passed to CVPixelBufferPoolCreatePixelBufferWithAuxAttributes.
var kCVPixelBufferPoolFreeBufferNotification: CFStringRef; external name '_kCVPixelBufferPoolFreeBufferNotification'; (* attribute const *)
(* __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0) *)

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
