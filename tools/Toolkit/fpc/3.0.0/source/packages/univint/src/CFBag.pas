{	CFBag.h
	Copyright (c) 1998-2012, Apple Inc. All rights reserved.
}
{       Pascal Translation Updated:  Peter N Lewis, <peter@stairways.com.au>, September 2005 }
{       Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
{       Pascal Translation Updated: Jonas Maebe <jonas@freepascal.org>, September 2012 }
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

unit CFBag;
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
uses MacTypes,CFBase;
{$endc} {not MACOSALLINCLUDE}

{$ALIGN POWER}


type
	CFBagRetainCallBack = function( allocator: CFAllocatorRef; value: {const} UnivPtr ): UnivPtr;
	CFBagReleaseCallBack = procedure( allocator: CFAllocatorRef; value: {const} UnivPtr );
	CFBagCopyDescriptionCallBack = function( value: {const} UnivPtr ): CFStringRef;
	CFBagEqualCallBack = function( value1: {const} UnivPtr; value2: {const} UnivPtr ): Boolean;
	CFBagHashCallBack = function( value: {const} UnivPtr ): CFHashCode;
	CFBagCallBacksPtr = ^CFBagCallBacks;
	CFBagCallBacks = record
		version: CFIndex;
		retain: CFBagRetainCallBack;
		release: CFBagReleaseCallBack;
		copyDescription: CFBagCopyDescriptionCallBack;
		equal: CFBagEqualCallBack;
		hash: CFBagHashCallBack;
	end;

var kCFTypeBagCallBacks: CFBagCallBacks; external name '_kCFTypeBagCallBacks'; (* attribute const *)
var kCFCopyStringBagCallBacks: CFBagCallBacks; external name '_kCFCopyStringBagCallBacks'; (* attribute const *)

type
	CFBagApplierFunction = procedure( value: {const} UnivPtr; context: UnivPtr );

type
	CFBagRef = ^__CFBag; { an opaque type }
	__CFBag = record end;
	CFBagRefPtr = ^CFBagRef;
	CFMutableBagRef = CFBagRef;
	CFMutableBagRefPtr = ^CFMutableBagRef;

function CFBagGetTypeID: CFTypeID; external name '_CFBagGetTypeID';

function CFBagCreate( allocator: CFAllocatorRef; {const} values: {variable-size-array} UnivPtrPtr; numValues: CFIndex; {const} callBacks: CFBagCallBacksPtr { can be NULL } ): CFBagRef; external name '_CFBagCreate';

function CFBagCreateCopy( allocator: CFAllocatorRef; theBag: CFBagRef ): CFBagRef; external name '_CFBagCreateCopy';

function CFBagCreateMutable( allocator: CFAllocatorRef; capacity: CFIndex; callBacks: CFBagCallBacksPtr ): CFMutableBagRef; external name '_CFBagCreateMutable';

function CFBagCreateMutableCopy( allocator: CFAllocatorRef; capacity: CFIndex; theBag: CFBagRef ): CFMutableBagRef; external name '_CFBagCreateMutableCopy';

function CFBagGetCount( theBag: CFBagRef ): CFIndex; external name '_CFBagGetCount';

function CFBagGetCountOfValue( theBag: CFBagRef; value: {const} UnivPtr ): CFIndex; external name '_CFBagGetCountOfValue';

function CFBagContainsValue( theBag: CFBagRef; value: {const} UnivPtr ): Boolean; external name '_CFBagContainsValue';

function CFBagGetValue( theBag: CFBagRef; value: {const} UnivPtr ): UnivPtr; external name '_CFBagGetValue';

function CFBagGetValueIfPresent( theBag: CFBagRef; candidate: {const} UnivPtr; var value: UnivPtr ): Boolean; external name '_CFBagGetValueIfPresent';

procedure CFBagGetValues( theBag: CFBagRef; {const} values: {variable-size-array} UnivPtrPtr ); external name '_CFBagGetValues';

procedure CFBagApplyFunction( theBag: CFBagRef; applier: CFBagApplierFunction; context: UnivPtr ); external name '_CFBagApplyFunction';

procedure CFBagAddValue( theBag: CFMutableBagRef; value: {const} UnivPtr ); external name '_CFBagAddValue';

procedure CFBagReplaceValue( theBag: CFMutableBagRef; value: {const} UnivPtr ); external name '_CFBagReplaceValue';

procedure CFBagSetValue( theBag: CFMutableBagRef; value: {const} UnivPtr ); external name '_CFBagSetValue';

procedure CFBagRemoveValue( theBag: CFMutableBagRef; value: {const} UnivPtr ); external name '_CFBagRemoveValue';

procedure CFBagRemoveAllValues( theBag: CFMutableBagRef ); external name '_CFBagRemoveAllValues';

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
