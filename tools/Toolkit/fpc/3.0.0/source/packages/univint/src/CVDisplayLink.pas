{
 *  CVDisplayLink.h
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

unit CVDisplayLink;
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
uses MacTypes, CFBase, CGDirectDisplay, CVBase, CVReturns, CGLTypes;
{$endc} {not MACOSALLINCLUDE}

{$ALIGN POWER}

{$ifc TARGET_OS_MAC}

 
  {! @header CVDisplayLink.h
	@copyright 2004 Apple Computer, Inc. All rights reserved.
	@availability Mac OS X 10.4 or later
    @discussion The main purpose of the CoreVideo DisplayLink API is to provide a worker thread to the VideoUnit subsystem that is clocked based on the refresh rate of a CGDirectDisplay device. In the current implementation, these DisplayLinks are created automatically by the Video Unit display nodes, and the developer does not have to deal with them directly.
		A CoreVideo DisplayLink is represented in code by a CVDisplayLinkRef. The CVDisplayLinkRef API uses the CoreFoundation class system internally to provide reference counting behaviour and other such goodies. There are three different ways to create a CVDisplayLinkRef in the current API. The first call is the most general case, and the other two are provided as a convenience (the third will probably go away, as it's only marginally useful). 
		   
}


type
	CVDisplayLinkRef = ^__CVDisplayLink; { an opaque type }
	__CVDisplayLink = record end;


type
	CVDisplayLinkOutputCallback = function( displayLink: CVDisplayLinkRef; const (*var*) inNow: CVTimeStamp; const (*var*) inOutputTime: CVTimeStamp; flagsIn: CVOptionFlags; var flagsOut: CVOptionFlags; displayLinkContext: UnivPtr ): CVReturn;

function CVDisplayLinkGetTypeID: CFTypeID; external name '_CVDisplayLinkGetTypeID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkCreateWithCGDisplays
    @abstract   General call to create a CVDisplayLink
    @discussion Use this call to create a CVDisplayLink for a set of displays indentified by the CGDirectDisplayIDs.
    @param      displayArray array of CGDirectDisplayIDs
    @param      count   number of displays in the displayArray
    @param      displayLisk The new display link will be returned here
    @result	returns kCVReturnSuccesss on success.
}
function CVDisplayLinkCreateWithCGDisplays( displayArray: {variable-size-array} CGDirectDisplayIDPtr; count: CFIndex; var displayLinkOut: CVDisplayLinkRef ): CVReturn; external name '_CVDisplayLinkCreateWithCGDisplays';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkCreateWithOpenGLDisplayMask
    @abstract   Convenience call to create a CVDisplayLink from an OpenGL display mask.
    @discussion Use this call to create a CVDisplayLink for a CGOpenGLDisplayMask.
    @param      mask CGOpenGLDisplayMask describing the display
    @param      displayLisk The new display link will be returned here
    @result	returns kCVReturnSuccesss on success.
}
function CVDisplayLinkCreateWithOpenGLDisplayMask( mask: CGOpenGLDisplayMask; var displayLinkOut: CVDisplayLinkRef ): CVReturn; external name '_CVDisplayLinkCreateWithOpenGLDisplayMask';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkCreateWithCGDisplay
    @abstract   Convenience call to create a CVDisplayLink for a single CGDirectDisplay.
    @discussion Use this call to create a CVDisplayLink for a single CGDirectDisplay.
    @param      displayID CGDirectDisplayID of the target display
    @param      displayLisk The new display link will be returned here
    @result	returns kCVReturnSuccesss on success.
}
function CVDisplayLinkCreateWithCGDisplay( displayID: CGDirectDisplayID; var displayLinkOut: CVDisplayLinkRef ): CVReturn; external name '_CVDisplayLinkCreateWithCGDisplay';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkCreateWithActiveCGDisplays
    @abstract   Convenience function to create a CVDisplayLink capable of being used with all active CGDisplays
    @param      displayLinkOut The newly created CVDisplayLink
    @result     kCVReturnSuccess if the device was created, or failure
}
function CVDisplayLinkCreateWithActiveCGDisplays( var displayLinkOut: CVDisplayLinkRef ): CVReturn; external name '_CVDisplayLinkCreateWithActiveCGDisplays';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkSetCurrentCGDisplay
    @abstract   Sets the current display of a DisplayLink
    @discussion It is safe to call this with a running display link, but be aware that there will likely be a timestamp
                discontinuity in the video time stamp
    @param      displayLink target CVDisplayLinkRef
    @param      displayID target CGDirectDisplayID
    @result     CVReturn. kCVReturnSuccesss if successfull.
}
function CVDisplayLinkSetCurrentCGDisplay( displayLink: CVDisplayLinkRef; displayID: CGDirectDisplayID ): CVReturn; external name '_CVDisplayLinkSetCurrentCGDisplay';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext
    @abstract   Convenience function to select a CVDisplayLink most optimal for the current renderer of the passed in OpenGL context
    @param      displayLink The CVDisplayLink for which you want to set the current CGDisplay
    @param      cglContext The OpenGL context to retrieve the current renderer from.
    @param      cglPixelFormat The OpenGL pixel format used to create the passed in OpenGL context
    @result     kCVReturnSuccess if a device was found, or failure.
}
function CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext( displayLink: CVDisplayLinkRef; cglContext: CGLContextObj; cglPixelFormat: CGLPixelFormatObj ): CVReturn; external name '_CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
{!
    @function   CVDisplayLinkGetCurrentCGDisplay
    @abstract   Gets the current display of a DisplayLink
    @discussion (description)
    @param      displayLink target CVDisplayLinkRef
    @result     CGDirectDisplayID
}
function CVDisplayLinkGetCurrentCGDisplay( displayLink: CVDisplayLinkRef ): CGDirectDisplayID; external name '_CVDisplayLinkGetCurrentCGDisplay';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkSetOutputCallback
    @abstract   Set the renderer output callback function	
    @discussion The DisplayLink will invoke this callback whenever it wants you to output a frame.
    @param      displayLink target CVDisplayLinkRef
    @param	callback	CVDisplayLinkOutputCallback function
    @param	userInfo  User data for the callback to identify the context.
    @result     CVReturn. kCVReturnSuccesss if successfull.
}
function CVDisplayLinkSetOutputCallback( displayLink: CVDisplayLinkRef; callback: CVDisplayLinkOutputCallback; userInfo: UnivPtr ): CVReturn; external name '_CVDisplayLinkSetOutputCallback';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkStart
    @abstract   Start timer for DisplayLink
    @discussion (description)
    @param      displayLink target CVDisplayLinkRef
    @result     CVReturn. kCVReturnSuccesss if successfull.
                kCVReturnDisplayLinkCallbacksNotSet The DisplayLink cannot be started untill both callbacks are set.
}
function CVDisplayLinkStart( displayLink: CVDisplayLinkRef ): CVReturn; external name '_CVDisplayLinkStart';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkStop
    @abstract   Stop timer for DisplayLink
    @discussion (description)
    @param      displayLink target CVDisplayLinkRef
    @result     CVReturn. kCVReturnSuccesss if successfull.
}
function CVDisplayLinkStop( displayLink: CVDisplayLinkRef ): CVReturn; external name '_CVDisplayLinkStop';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkGetNominalOutputVideoRefreshPeriod
    @abstract   Retrieves the nominal refresh period of a CVDisplayLink.
    @discussion This call allows one to retrieve the device's "ideal" refresh period.   For example, an NTSC output device might report 1001/60000 to represent the exact NTSC vertial refresh rate.
    @param      displayLink The CVDisplayLink to get the refresh period from.
    @result     A CVTime struct that holds the nominal refresh period.    This value may be indefinite.
}
function CVDisplayLinkGetNominalOutputVideoRefreshPeriod( displayLink: CVDisplayLinkRef ): CVTime; external name '_CVDisplayLinkGetNominalOutputVideoRefreshPeriod';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkGetOutputVideoLatency
    @abstract   Retrieves the nominal latency of a CVDisplayLink.
    @discussion This call allows one to retrieve the device's built in output latency. An NTSC device with one frame of latency might report back 1001/30000 or 2002/60000, for example.
    @param      displayLink The CVDisplayLink to get the latency period from.
    @result     A CVTime struct that holds the latency.   This value may be indefinite.
}
function CVDisplayLinkGetOutputVideoLatency( displayLink: CVDisplayLinkRef ): CVTime; external name '_CVDisplayLinkGetOutputVideoLatency';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkGetActualOutputVideoRefreshPeriod
    @abstract   Retrieves the actual output refresh period of a display as measured by the host timebase.
    @discussion This call returns the actual output refresh period (in seconds) as computed relative to the host's timebase.
    @param      displayLink The CVDisplayLink to get the refresh period from.
    @result     A double containing the actual refresh period.   This value may be zero if the device is not running, or is otherwise unavailable.
}
function CVDisplayLinkGetActualOutputVideoRefreshPeriod( displayLink: CVDisplayLinkRef ): Float64; external name '_CVDisplayLinkGetActualOutputVideoRefreshPeriod';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkIsRunning
    @abstract   Retrieves the running state of a CVDisplayLink.
    @discussion This call queries the running state of the given CVDisplayLink.
    @param      displayLink The CVDisplayLink to get the running state from.
    @result     A boolean describing the running state. It returns true if it is running and false if it is not running or the CVDisplayLink is invalid.
}
function CVDisplayLinkIsRunning( displayLink: CVDisplayLinkRef ): Boolean; external name '_CVDisplayLinkIsRunning';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkGetCurrentTime
    @abstract   Retrieves the current ("now") time of a given CVDisplayLink
    @discussion This call may be used to get the current time of a running CVDisplayLink, outside of the output callback.
    @param      displayLink The CVDisplayLink to get the current time from.
    @param      outTime A pointer to a CVTimeStamp struct.  This struct's version field must currently be set correctly (currently 0) to indicate which version of the timestamp struct is desired.
    @result     kCVReturnSuccess if the current time could be retrieved, otherwise an error indicating why the operation failed.
}
function CVDisplayLinkGetCurrentTime( displayLink: CVDisplayLinkRef; var outTime: CVTimeStamp ): CVReturn; external name '_CVDisplayLinkGetCurrentTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkTranslateTime
    @abstract   Translates the time in the CVDisplayLink's time base from one representation to
                    another. Note that the device has to be running for this call to succeed.
    @param      displayLink The CVDisplayLink who's timebase should be used to do the translation.
    @param      inTime A CVTimeStamp containing the source time to be translated.
    @param      outTime A CVTimeStamp into which the target time will be written. This struct's version field must currently be set correctly 
                (currently 0) to indicate which version of the timestamp struct is desired.  As well, the flags field should be used to specify
                which representations to translate to.
    @result     kCVReturnSuccess if the time could be translated, otherwise an error indicating why the operation failed.
}
function CVDisplayLinkTranslateTime( displayLink: CVDisplayLinkRef; const (*var*) inTime: CVTimeStamp; var outTime: CVTimeStamp ): CVReturn; external name '_CVDisplayLinkTranslateTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkRetain
    @abstract   Retains the CVDisplayLink
    @discussion Use this call to retain a CVDisplayLink.
    @param      displayLink target CVDisplayLinkRef.   NULL safe.
	@result		If successfull the passed in dislplayLink
}
function CVDisplayLinkRetain( displayLink: CVDisplayLinkRef ): CVDisplayLinkRef; external name '_CVDisplayLinkRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{!
    @function   CVDisplayLinkRelease
    @abstract   Releases the CVDisplayLink
    @discussion Use this call to release a CVDisplayLink.
    @param      displayLink target CVDisplayLinkRef.  NULL safe.
}
procedure CVDisplayLinkRelease( displayLink: CVDisplayLinkRef ); external name '_CVDisplayLinkRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{$endc}	//TARGET_OS_MAC
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
