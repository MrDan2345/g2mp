{
	 File:	   CFNetwork/CFNetDiagnostics.h
 
	 Contains:   CFNetDiagnostics interface
  
	 Copyright:  Copyright (c) 2004-2008, Apple Inc. All rights reserved.
 
	 Bugs?:	  For bug reports, consult the following page on
				 the World Wide Web:
 
					 http://www.freepascal.org/bugs.html
 
}
{       Pascal Translation:  Gale R Paeper, <gpaeper@empirenet.com>, 2008 }
{       Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
{       Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2012 }
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

unit CFNetDiagnostics;
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
uses MacTypes, CFBase, CFStream, CFURL;
{$endc} {not MACOSALLINCLUDE}

{$ALIGN POWER}



{
 *  CFNetDiagnosticRef
 *  
 *  Discussion:
 *	This is the type used to describe the types of connection that
 *	clients may be querying about
 }
type
	CFNetDiagnosticRef = ^__CFNetDiagnostic; { an opaque type }
	__CFNetDiagnostic = record end;

{
 *  CFNetDiagnosticStatusValues
 *  
 *  Discussion:
 *	Values for CFNetDiagnosticStatus
 }
type
	CFNetDiagnosticStatusValues = SInt32;
const
{
   * There is no status, but no error has occured
   }
	kCFNetDiagnosticNoErr = 0;

  {
   * An error occured that prevented the call from completing
   }
	kCFNetDiagnosticErr = -66560;

  {
   * The connection appears to be working
   }
	kCFNetDiagnosticConnectionUp = -66559;
	kCFNetDiagnosticConnectionIndeterminate = -66558;

  {
   * The connection does not appear to be working
   }
	kCFNetDiagnosticConnectionDown = -66557;


{
 *  CFNetDiagnosticStatus
 *  
 *  Discussion:
 *	Returned by the various status and diagnostic calls
 }
type
	CFNetDiagnosticStatus = CFIndex;
{
 *  CFNetDiagnosticCreateWithStreams()
 *  
 *  Discussion:
 *	Creates a CFNetDiagnosticRef from a pair of CFStreams. Either
 *	stream may be NULL. This is the preferred interface for creating
 *	a CFNetDiagnosticRef.
 *  
 *  Parameters:
 *	
 *	alloc:
 *	  The CF allocator to use.
 *	
 *	readStream:
 *	  CFReadStreamRef referring to the failed connection. May be NULL.
 *	
 *	writeStream:
 *	  CFWriteStreamRef referring to the failed connection. May be
 *	  NULL.
 *  
 *  Result:
 *	A CFNetDiagnosticRef referring to the current networking issue.
 *  
 *  Availability:
 *	Mac OS X:		 in version 10.4 and later in CoreServices.framework
 *	CarbonLib:		not available
 *	Non-Carbon CFM:   not available
 }
function CFNetDiagnosticCreateWithStreams( alloc: CFAllocatorRef; readStream: CFReadStreamRef; writeStream: CFWriteStreamRef ): CFNetDiagnosticRef; external name '_CFNetDiagnosticCreateWithStreams';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_2_0) *)


{
 *  CFNetDiagnosticCreateWithURL()
 *  
 *  Discussion:
 *	Creates a CFNetDiagnosticRef based on a CFURLRef passed in by the
 *	application.
 *  
 *  Parameters:
 *	
 *	alloc:
 *	  The CF allocator to use.
 *	
 *	url:
 *	  CFURLRef referring to the failed connection.
 *  
 *  Result:
 *	A CFNetDiagnosticRef referring to the current networking issue.
 *  
 *  Availability:
 *	Mac OS X:		 in version 10.4 and later in CoreServices.framework
 *	CarbonLib:		not available
 *	Non-Carbon CFM:   not available
 }
function CFNetDiagnosticCreateWithURL( alloc: CFAllocatorRef; url: CFURLRef ): CFNetDiagnosticRef; external name '_CFNetDiagnosticCreateWithURL';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_2_0) *)


{
 *  CFNetDiagnosticSetName()
 *  
 *  Discussion:
 *	If the framework requires an application name to be displayed to
 *	the user it will derive it from the bundle identifier of the
 *	currently running application, in that application's current
 *	localization. If you want to override that you may use
 *	CFNetDiagnosticSetName to specify a CFStringRef to be used.
 *  
 *  Parameters:
 *	
 *	details:
 *	  CFNetDiagnosticRef referring to the current problem.
 *	
 *	name:
 *	  The localized name that should appear to the user when
 *	  referring to the application.
 *  
 *  Availability:
 *	Mac OS X:		 in version 10.4 and later in CoreServices.framework
 *	CarbonLib:		not available
 *	Non-Carbon CFM:   not available
 }
procedure CFNetDiagnosticSetName( details: CFNetDiagnosticRef; name: CFStringRef ); external name '_CFNetDiagnosticSetName';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_2_0) *)


{
 *  CFNetDiagnosticDiagnoseProblemInteractively()
 *  
 *  Discussion:
 *	Opens the Network Diagnostics window and returns immediately once
 *	it is open. The client passes in a CFNetDiagnosticRef built with
 *	one of the creator functions.
 *  
 *  Parameters:
 *	
 *	details:
 *	  CFNetDiagnosticRef referring to the current problem.
 *  
 *  Result:
 *	A CFNetDiagnosticStatus. Will either be CFNetDiagnosticNoErr, or
 *	CFNetDiagnosticErr if there was an error attempting to run the
 *	diagnosis.
 *  
 *  Availability:
 *	Mac OS X:		 in version 10.4 and later in CoreServices.framework
 *	CarbonLib:		not available
 *	Non-Carbon CFM:   not available
 }
function CFNetDiagnosticDiagnoseProblemInteractively( details: CFNetDiagnosticRef ): CFNetDiagnosticStatus; external name '_CFNetDiagnosticDiagnoseProblemInteractively';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_2_0) *)


{
 *  CFNetDiagnosticCopyNetworkStatusPassively()
 *  
 *  Discussion:
 *	Returns a status value that can be used to display basic
 *	information about the connection. If the caller wishes they may
 *	pass in a pointer to a CFStringRef that will be used to pass back
 *	a localized description of the problem. It is the caller's
 *	responsibility to release the CFStringRef. If the caller does not
 *	want a description they may pass in NULL.
 *	CFNetDiagnosticCopyNetworkStatusPassively() is guaranteed not to
 *	cause network activity.
 *  
 *  Parameters:
 *	
 *	details:
 *	  CFNetDiagnosticRef referring to the current problem.
 *	
 *	description:
 *	  A pointer to a CFStringRef that, upon return, will point to a
 *	  localized string containing a description of the current
 *	  network status. May be NULL. If it is not NULL, the client must
 *	  call CFRelease on the returned object.
 *  
 *  Availability:
 *	Mac OS X:		 in version 10.4 and later in CoreServices.framework
 *	CarbonLib:		not available
 *	Non-Carbon CFM:   not available
 }
function CFNetDiagnosticCopyNetworkStatusPassively( details: CFNetDiagnosticRef; description: CFStringRefPtr { can be NULL } ): CFNetDiagnosticStatus; external name '_CFNetDiagnosticCopyNetworkStatusPassively';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_2_0) *)

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
