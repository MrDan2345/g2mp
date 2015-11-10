{ CoreGraphics - CGWindowLevel.h
   Copyright (c) 2000-2008 Apple Inc.
   All rights reserved. }
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

unit CGWindowLevels;
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
uses MacTypes,CGBase;
{$endc} {not MACOSALLINCLUDE}

{$ALIGN POWER}


{ Windows may be assigned to a particular level. When assigned to a level,
   the window is ordered relative to all other windows in that level.
   Windows with a higher level are sorted in front of windows with a lower
   level.

   A common set of window levels is defined here for use within higher level
   frameworks. The levels are accessed via a key and function, so that
   levels may be changed or adjusted in future releases without breaking
   binary compatability. }

type
	CGWindowLevel = SInt32;
	CGWindowLevelKey = SInt32;

const
	kCGBaseWindowLevelKey = 0;
	kCGMinimumWindowLevelKey = 1;
	kCGDesktopWindowLevelKey = 2;
	kCGBackstopMenuLevelKey = 3;
	kCGNormalWindowLevelKey = 4;
	kCGFloatingWindowLevelKey = 5;
	kCGTornOffMenuWindowLevelKey = 6;
	kCGDockWindowLevelKey = 7;
	kCGMainMenuWindowLevelKey = 8;
	kCGStatusWindowLevelKey = 9;
	kCGModalPanelWindowLevelKey = 10;
	kCGPopUpMenuWindowLevelKey = 11;
	kCGDraggingWindowLevelKey = 12;
	kCGScreenSaverWindowLevelKey = 13;
	kCGMaximumWindowLevelKey = 14;
	kCGOverlayWindowLevelKey = 15;
	kCGHelpWindowLevelKey = 16;
	kCGUtilityWindowLevelKey = 17;
	kCGDesktopIconWindowLevelKey = 18;
	kCGCursorWindowLevelKey = 19;
	kCGAssistiveTechHighWindowLevelKey = 20;
	kCGNumberOfWindowLevelKeys = 21;	{ Must be last. }

{$ifc TARGET_OS_MAC}

{ Return the window level that corresponds to one of the standard window
   types. }

function CGWindowLevelForKey( key: CGWindowLevelKey ): CGWindowLevel; external name '_CGWindowLevelForKey';
(* CG_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)

{$endc}

{ The number of window levels reserved by Apple for internal use. }
const
	kCGNumReservedWindowLevels = 16;

(*
{ Definitions of older constant values as calls }
#define kCGBaseWindowLevel		CGWindowLevelForKey(kCGBaseWindowLevelKey)	{ LONG_MIN }
#define kCGMinimumWindowLevel 		CGWindowLevelForKey(kCGMinimumWindowLevelKey)	{ (kCGBaseWindowLevel + 1) }
#define kCGDesktopWindowLevel		CGWindowLevelForKey(kCGDesktopWindowLevelKey)	{ kCGMinimumWindowLevel }
#define kCGDesktopIconWindowLevel		CGWindowLevelForKey(kCGDesktopIconWindowLevelKey)	{ kCGMinimumWindowLevel + 20 }
#define kCGBackstopMenuLevel		CGWindowLevelForKey(kCGBackstopMenuLevelKey)	{ -20 }
#define kCGNormalWindowLevel		CGWindowLevelForKey(kCGNormalWindowLevelKey)	{ 0 }
#define kCGFloatingWindowLevel		CGWindowLevelForKey(kCGFloatingWindowLevelKey)	{ 3 }
#define kCGTornOffMenuWindowLevel	CGWindowLevelForKey(kCGTornOffMenuWindowLevelKey)	{ 3 }
#define kCGDockWindowLevel		CGWindowLevelForKey(kCGDockWindowLevelKey)	{ 20 }
#define kCGMainMenuWindowLevel		CGWindowLevelForKey(kCGMainMenuWindowLevelKey)	{ 24 }
#define kCGStatusWindowLevel		CGWindowLevelForKey(kCGStatusWindowLevelKey)	{ 25 }
#define kCGModalPanelWindowLevel	CGWindowLevelForKey(kCGModalPanelWindowLevelKey)	{ 8 }
#define kCGPopUpMenuWindowLevel		CGWindowLevelForKey(kCGPopUpMenuWindowLevelKey)	{ 101 }
#define kCGDraggingWindowLevel		CGWindowLevelForKey(kCGDraggingWindowLevelKey)	{ 500 }
#define kCGScreenSaverWindowLevel	CGWindowLevelForKey(kCGScreenSaverWindowLevelKey)	{ 1000 }
#define kCGCursorWindowLevel		CGWindowLevelForKey(kCGCursorWindowLevelKey)	{ 2000 }
#define kCGOverlayWindowLevel		CGWindowLevelForKey(kCGOverlayWindowLevelKey)	{ 102 }
#define kCGHelpWindowLevel		CGWindowLevelForKey(kCGHelpWindowLevelKey)	{ 102 }
#define kCGUtilityWindowLevel		CGWindowLevelForKey(kCGUtilityWindowLevelKey)	{ 19 }

#define kCGAssistiveTechHighWindowLevel		CGWindowLevelForKey(kCGAssistiveTechHighWindowLevelKey)	{ 1500 }

#define kCGMaximumWindowLevel 		CGWindowLevelForKey(kCGMaximumWindowLevelKey)	{ LONG_MAX - kCGNumReservedWindowLevels }
*)
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
