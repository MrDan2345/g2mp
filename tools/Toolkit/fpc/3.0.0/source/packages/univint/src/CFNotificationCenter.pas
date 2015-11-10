{	CFNotificationCenter.h
	Copyright (c) 1998-2012, Apple Inc. All rights reserved.
}
{	  Pascal Translation:  Peter N Lewis, <peter@stairways.com.au>, 2004 }
{	  Pascal Translation Updated:  Peter N Lewis, <peter@stairways.com.au>, September 2005 }
{	  Pascal Translation Updated:  Gorazd Krosl, <gorazd_1957@yahoo.ca>, October 2009 }
{	  Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
{	  Pascal Translation Updated:  Jonas Maebe <jonas@freepascal.org>, September 2012 }
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

unit CFNotificationCenter;
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
uses MacTypes,CFBase,CFDictionary;
{$endc} {not MACOSALLINCLUDE}

{$ALIGN POWER}


type
	CFNotificationCenterRef = ^__CFNotificationCenter; { an opaque type }
	__CFNotificationCenter = record end;

type
	CFNotificationCallback = procedure( center: CFNotificationCenterRef; observer: UnivPtr; name: CFStringRef; objct: {const} UnivPtr; userInfo: CFDictionaryRef );

type
	CFNotificationSuspensionBehavior = CFIndex;
const
	CFNotificationSuspensionBehaviorDrop = 1;
        // The server will not queue any notifications with this name and object while the process/app is in the background.
	CFNotificationSuspensionBehaviorCoalesce = 2;
        // The server will only queue the last notification of the specified name and object; earlier notifications are dropped. 
	CFNotificationSuspensionBehaviorHold = 3;
        // The server will hold all matching notifications until the queue has been filled (queue size determined by the server) at which point the server may flush queued notifications.
	CFNotificationSuspensionBehaviorDeliverImmediately = 4;
        // The server will deliver notifications matching this registration whether or not the process is in the background.  When a notification with this suspension behavior is matched, it has the effect of first flushing any queued notifications.

function CFNotificationCenterGetTypeID: CFTypeID; external name '_CFNotificationCenterGetTypeID';

function CFNotificationCenterGetLocalCenter: CFNotificationCenterRef; external name '_CFNotificationCenterGetLocalCenter';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{$ifc TARGET_OS_MAC or TARGET_OS_WIN32}
function CFNotificationCenterGetDistributedCenter: CFNotificationCenterRef; external name '_CFNotificationCenterGetDistributedCenter';
{$endc}

function CFNotificationCenterGetDarwinNotifyCenter: CFNotificationCenterRef; external name '_CFNotificationCenterGetDarwinNotifyCenter';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
// The Darwin Notify Center is based on the <notify.h> API.
// For this center, there are limitations in the API. There are no notification "objects",
// "userInfo" cannot be passed in the notification, and there are no suspension behaviors
// (always "deliver immediately"). Other limitations in the <notify.h> API as described in
// that header will also apply.
// - In the CFNotificationCallback, the 'object' and 'userInfo' parameters must be ignored.
// - CFNotificationCenterAddObserver(): the 'object' and 'suspensionBehavior' arguments are ignored.
// - CFNotificationCenterAddObserver(): the 'name' argument may not be NULL (for this center).
// - CFNotificationCenterRemoveObserver(): the 'object' argument is ignored.
// - CFNotificationCenterPostNotification(): the 'object', 'userInfo', and 'deliverImmediately' arguments are ignored.
// - CFNotificationCenterPostNotificationWithOptions(): the 'object', 'userInfo', and 'options' arguments are ignored.
// The Darwin Notify Center has no notion of per-user sessions, all notifications are system-wide.
// As with distributed notifications, the main thread's run loop must be running in one of the
// common modes (usually kCFRunLoopDefaultMode) for Darwin-style notifications to be delivered.
// NOTE: NULL or 0 should be passed for all ignored arguments to ensure future compatibility.


procedure CFNotificationCenterAddObserver( center: CFNotificationCenterRef; observer: {const} UnivPtr; callBack: CFNotificationCallback; name: CFStringRef; objct: {const} UnivPtr; suspensionBehavior: CFNotificationSuspensionBehavior ); external name '_CFNotificationCenterAddObserver';

procedure CFNotificationCenterRemoveObserver( center: CFNotificationCenterRef; observer: {const} UnivPtr; name: CFStringRef; objct: {const} UnivPtr ); external name '_CFNotificationCenterRemoveObserver';
procedure CFNotificationCenterRemoveEveryObserver( center: CFNotificationCenterRef; observer: {const} UnivPtr ); external name '_CFNotificationCenterRemoveEveryObserver';

procedure CFNotificationCenterPostNotification( center: CFNotificationCenterRef; name: CFStringRef; objct: {const} UnivPtr; userInfo: CFDictionaryRef; deliverImmediately: Boolean ); external name '_CFNotificationCenterPostNotification';

{#if MAC_OS_X_VERSION_10_3 <= MAC_OS_X_VERSION_MAX_ALLOWED}

const
	kCFNotificationDeliverImmediately = 1 shl 0;
	kCFNotificationPostToAllSessions = 1 shl 1;

procedure CFNotificationCenterPostNotificationWithOptions( center: CFNotificationCenterRef; name: CFStringRef; objct: {const} UnivPtr; userInfo: CFDictionaryRef; options: CFOptionFlags ); external name '_CFNotificationCenterPostNotificationWithOptions';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{#endif}

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
