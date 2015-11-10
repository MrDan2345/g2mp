{	CFPlugIn.h
	Copyright (c) 1999-2012, Apple Inc.  All rights reserved.
}
{   Pascal Translation Updated:  Peter N Lewis, <peter@stairways.com.au>, September 2005 }
{   Pascal Translation Updated:  Gorazd Krosl, <gorazd_1957@yahoo.ca, October 2009 }
{   Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
{   Pascal Translation Updated:  Jonas Maebe <jonas@freepascal.org>, September 2012 }
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

unit CFPlugIn;
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
uses MacTypes,CFBase,CFArray,CFBundle,CFString,CFURL,CFUUID;
{$endc} {not MACOSALLINCLUDE}

{$ALIGN POWER}

{
# if !defined(COREFOUNDATION_CFPLUGINCOM_SEPARATE)
const
	COREFOUNDATION_CFPLUGINCOM_SEPARATE = 1;
# endif
}

{ ================ Standard Info.plist keys for plugIns ================ }

var kCFPlugInDynamicRegistrationKey: CFStringRef; external name '_kCFPlugInDynamicRegistrationKey'; (* attribute const *)
var kCFPlugInDynamicRegisterFunctionKey: CFStringRef; external name '_kCFPlugInDynamicRegisterFunctionKey'; (* attribute const *)
var kCFPlugInUnloadFunctionKey: CFStringRef; external name '_kCFPlugInUnloadFunctionKey'; (* attribute const *)
var kCFPlugInFactoriesKey: CFStringRef; external name '_kCFPlugInFactoriesKey'; (* attribute const *)
var kCFPlugInTypesKey: CFStringRef; external name '_kCFPlugInTypesKey'; (* attribute const *)

{ ================= Function prototypes for various callbacks ================= }
{ Function types that plugIn authors can implement for various purposes. }

type
	CFPlugInDynamicRegisterFunction = procedure( plugIn: CFPlugInRef );
	CFPlugInUnloadFunction = procedure( plugIn: CFPlugInRef );
	CFPlugInFactoryFunction = function( allocator: CFAllocatorRef; typeUUID: CFUUIDRef ): UnivPtr;

{ ================= Creating PlugIns ================= }

function CFPlugInGetTypeID: CFTypeID; external name '_CFPlugInGetTypeID';

function CFPlugInCreate( allocator: CFAllocatorRef; plugInURL: CFURLRef ): CFPlugInRef; external name '_CFPlugInCreate';
    { Might return an existing instance with the ref-count bumped. }

function CFPlugInGetBundle( plugIn: CFPlugInRef ): CFBundleRef; external name '_CFPlugInGetBundle';

{ ================= Controlling load on demand ================= }
{ For plugIns. }
{ PlugIns that do static registration are load on demand by default. }
{ PlugIns that do dynamic registration are not load on demand by default. }
{ A dynamic registration function can call CFPlugInSetLoadOnDemand(). }

procedure CFPlugInSetLoadOnDemand( plugIn: CFPlugInRef; flag: Boolean ); external name '_CFPlugInSetLoadOnDemand';

function CFPlugInIsLoadOnDemand( plugIn: CFPlugInRef ): Boolean; external name '_CFPlugInIsLoadOnDemand';

{ ================= Finding factories and creating instances ================= }
{ For plugIn hosts. }
{ Functions for finding factories to create specific types and actually creating instances of a type. }

function CFPlugInFindFactoriesForPlugInType( typeUUID: CFUUIDRef ): CFArrayRef; external name '_CFPlugInFindFactoriesForPlugInType';
    { This function finds all the factories from any plugin for the given type.  Returns an array that the caller must release. }
    
function CFPlugInFindFactoriesForPlugInTypeInPlugIn( typeUUID: CFUUIDRef; plugIn: CFPlugInRef ): CFArrayRef; external name '_CFPlugInFindFactoriesForPlugInTypeInPlugIn';
    { This function restricts the result to factories from the given plug-in that can create the given type.  Returns an array that the caller must release. }

function CFPlugInInstanceCreate( allocator: CFAllocatorRef; factoryUUID: CFUUIDRef; typeUUID: CFUUIDRef ): UnivPtr; external name '_CFPlugInInstanceCreate';
    { This function returns the IUnknown interface for the new instance. }

{ ================= Registering factories and types ================= }
{ For plugIn writers who must dynamically register things. }
{ Functions to register factory functions and to associate factories with types. }

function CFPlugInRegisterFactoryFunction( factoryUUID: CFUUIDRef; func: CFPlugInFactoryFunction ): Boolean; external name '_CFPlugInRegisterFactoryFunction';

function CFPlugInRegisterFactoryFunctionByName( factoryUUID: CFUUIDRef; plugIn: CFPlugInRef; functionName: CFStringRef ): Boolean; external name '_CFPlugInRegisterFactoryFunctionByName';

function CFPlugInUnregisterFactory( factoryUUID: CFUUIDRef ): Boolean; external name '_CFPlugInUnregisterFactory';

function CFPlugInRegisterPlugInType( factoryUUID: CFUUIDRef; typeUUID: CFUUIDRef ): Boolean; external name '_CFPlugInRegisterPlugInType';

function CFPlugInUnregisterPlugInType( factoryUUID: CFUUIDRef; typeUUID: CFUUIDRef ): Boolean; external name '_CFPlugInUnregisterPlugInType';

{ ================= Registering instances ================= }
{ When a new instance of a type is created, the instance is responsible for registering itself with the factory that created it and unregistering when it deallocates. }
{ This means that an instance must keep track of the CFUUIDRef of the factory that created it so it can unregister when it goes away. }

procedure CFPlugInAddInstanceForFactory( factoryID: CFUUIDRef ); external name '_CFPlugInAddInstanceForFactory';

procedure CFPlugInRemoveInstanceForFactory( factoryID: CFUUIDRef ); external name '_CFPlugInRemoveInstanceForFactory';


{ Obsolete API }

type
	CFPlugInInstanceRef = ^__CFPlugInInstance; { an opaque type }
	__CFPlugInInstance = record end;
	CFPlugInInstanceRefPtr = ^CFPlugInInstanceRef;

type
	CFPlugInInstanceGetInterfaceFunction = function( instance: CFPlugInInstanceRef; interfaceName: CFStringRef; var ftbl: UnivPtr ): Boolean;
	CFPlugInInstanceDeallocateInstanceDataFunction = procedure( instanceData: UnivPtr );

function CFPlugInInstanceGetInterfaceFunctionTable( instance: CFPlugInInstanceRef; interfaceName: CFStringRef; var ftbl: UnivPtr ): Boolean; external name '_CFPlugInInstanceGetInterfaceFunctionTable';
function CFPlugInInstanceGetFactoryName( instance: CFPlugInInstanceRef ): CFStringRef; external name '_CFPlugInInstanceGetFactoryName';
function CFPlugInInstanceGetInstanceData( instance: CFPlugInInstanceRef ): UnivPtr; external name '_CFPlugInInstanceGetInstanceData';
function CFPlugInInstanceGetTypeID: CFTypeID; external name '_CFPlugInInstanceGetTypeID';
function CFPlugInInstanceCreateWithInstanceDataSize( allocator: CFAllocatorRef; instanceDataSize: CFIndex; deallocateInstanceFunction: CFPlugInInstanceDeallocateInstanceDataFunction; factoryName: CFStringRef; getInterfaceFunction: CFPlugInInstanceGetInterfaceFunction ): CFPlugInInstanceRef; external name '_CFPlugInInstanceCreateWithInstanceDataSize';



{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
