{
     File:       OpenScripting/AppleScript.h
 
     Contains:   AppleScript Specific Interfaces.
 
     Version:    OSA-148~28
 
     Copyright:  � 1992-2008 by Apple Computer, Inc., all rights reserved
 
     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:
 
                     http://www.freepascal.org/bugs.html
 
}

{  Pascal Translation Updated: Gorazd Krosl <gorazd_1957@yahoo.ca>, October 2009 }
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

unit AppleScript;
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
uses MacTypes,AEDataModel,Components,MacErrors,OSA,TextEdit,CFBase,CFArray;
{$endc} {not MACOSALLINCLUDE}


{$ifc TARGET_OS_MAC}

{$ALIGN POWER}


{*************************************************************************
    Types and Constants
*************************************************************************}
{
    The specific type for the AppleScript instance of the
    Open Scripting Architecture type.
}
const
	typeAppleScript = FourCharCode('ascr');
	kAppleScriptSubtype = typeAppleScript;
	typeASStorage = typeAppleScript;

{*************************************************************************
    Component Selectors
*************************************************************************}

const
	kASSelectInit = $1001;
	kASSelectSetSourceStyles = $1002;
	kASSelectGetSourceStyles = $1003;
	kASSelectGetSourceStyleNames = $1004;
	kASSelectCopySourceAttributes = $1005;
	kASSelectSetSourceAttributes = $1006;


{*************************************************************************
    OSAGetScriptInfo Selectors
*************************************************************************}
const
	kASHasOpenHandler = FourCharCode('hsod');

{
        This selector is used to query a context as to whether it contains
        a handler for the kAEOpenDocuments event. This allows "applets" to be 
        distinguished from "droplets."  OSAGetScriptInfo returns false if
        there is no kAEOpenDocuments handler, and returns the error value 
        errOSAInvalidAccess if the input is not a context.
    }
{*************************************************************************
    Initialization
*************************************************************************}
{
 *  ASInit()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppleScriptLib 1.1 and later
 }
function ASInit( scriptingComponent: ComponentInstance; modeFlags: SInt32; minStackSize: UInt32; preferredStackSize: UInt32; maxStackSize: UInt32; minHeapSize: UInt32; preferredHeapSize: UInt32; maxHeapSize: UInt32 ): OSAError; external name '_ASInit';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
        ComponentCallNow(kASSelectInit, 28);
        This call can be used to explicitly initialize AppleScript.  If it is
        not called, the a scripting size resource is looked for and used. If
        there is no scripting size resource, then the constants listed below
        are used.  If at any stage (the init call, the size resource, the 
        defaults) any of these parameters are zero, then parameters from the
        next stage are used.  ModeFlags are not currently used.
        Errors:
        errOSASystemError       initialization failed
    }
{
    These values will be used if ASInit is not called explicitly, or if any
    of ASInit's parameters are zero:
}
const
	kASDefaultMinStackSize = 4 * 1024;
	kASDefaultPreferredStackSize = 16 * 1024;
	kASDefaultMaxStackSize = 16 * 1024;
	kASDefaultMinHeapSize = 4 * 1024;
	kASDefaultPreferredHeapSize = 16 * 1024;
	kASDefaultMaxHeapSize = 32 * 1024 * 1024;

{*************************************************************************
    Source Styles
*************************************************************************}
{
 *  ASSetSourceStyles()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    use ASSetSourceAttributes instead.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppleScriptLib 1.1 and later
 }
function ASSetSourceStyles( scriptingComponent: ComponentInstance; sourceStyles: STHandle ): OSAError; external name '_ASSetSourceStyles';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
 *  ASGetSourceStyles()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    use ASCopySourceAttributes instead.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppleScriptLib 1.1 and later
 }
function ASGetSourceStyles( scriptingComponent: ComponentInstance; var resultingSourceStyles: STHandle ): OSAError; external name '_ASGetSourceStyles';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
 *  ASCopySourceAttributes()
 *  
 *  Summary:
 *    Get the current AppleScript source style attributes.
 *  
 *  Discussion:
 *    A "style attribute" will typically be something meaningful to a
 *    CFAttributedString, but clients may add any attributes they like
 *    using ASSetSourceAttributes.
 *  
 *  Parameters:
 *    
 *    scriptingComponent:
 *      A valid AppleScript component instance.
 *    
 *    resultingSourceAttributes:
 *      If successful, *resultingSourceAttributes will be set to a
 *      CFArray of CFDictionaries of text attributes.  The order of the
 *      array elements corresponds to the source style constants below,
 *      and therefore also to the names returned by
 *      ASGetSourceStyleNames. The caller is responsible for releasing
 *      this array.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ASCopySourceAttributes( scriptingComponent: ComponentInstance; var resultingSourceAttributes: CFArrayRef ): OSAError; external name '_ASCopySourceAttributes';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  ASSetSourceAttributes()
 *  
 *  Summary:
 *    Set the AppleScript source style attributes.
 *  
 *  Discussion:
 *    A "style attribute" will typically be something meaningful to a
 *    CFAttributedString, but clients may add any attributes they like.
 *     Because of this, you should generally call ASSetSourceAttributes
 *    with a modified copy of the result from ASCopySourceAttributes,
 *    not a built-from-scratch set of attributes.
 *  
 *  Parameters:
 *    
 *    scriptingComponent:
 *      A valid AppleScript component instance.
 *    
 *    sourceAttributes:
 *      A CFArray of CFDictionaries of text attributes.  The order of
 *      the array elements corresponds to the source style constants
 *      below, and therefore also to the names returned by
 *      ASGetSourceStyleNames.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in Carbon.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ASSetSourceAttributes( scriptingComponent: ComponentInstance; sourceAttributes: CFArrayRef ): OSAError; external name '_ASSetSourceAttributes';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  ASGetSourceStyleNames()
 *  
 *  Summary:
 *    Returns the AppleScript source style names.
 *  
 *  Discussion:
 *    This call returns an AEList of text descriptors with the names of
 *    the source styles.  The order of the names corresponds to the
 *    order of the source style constants, below.  The precise type of
 *    the text descriptors is not defined; you should coerce them to
 *    the type you want to handle.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppleScriptLib 1.1 and later
 }
function ASGetSourceStyleNames( scriptingComponent: ComponentInstance; modeFlags: SInt32; var resultingSourceStyleNamesList: AEDescList ): OSAError; external name '_ASGetSourceStyleNames';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    Elements of STHandle correspond to following categories of tokens, and
    accessed through following index constants:
}
const
	kASSourceStyleUncompiledText = 0;
	kASSourceStyleNormalText = 1;
	kASSourceStyleLanguageKeyword = 2;
	kASSourceStyleApplicationKeyword = 3;
	kASSourceStyleComment = 4;
	kASSourceStyleLiteral = 5;
	kASSourceStyleUserSymbol = 6;
	kASSourceStyleObjectSpecifier = 7;    { Obsolete. Has been reused for strings. }
	kASSourceStyleString = 7;    { This and after were added in Mac OS X 10.6. }
	kASSourceStyleEventName = 8;
	kASSourceStyleParameterName = 9;
	kASSourceStyleClass = 10;
	kASSourceStyleProperty = 11;
	kASSourceStyleEnumValue = 12;
	kASSourceStyleDynamicEventName = 13;
	kASSourceStyleDynamicParameterName = 14;
	kASSourceStyleDynamicClass = 15;
	kASSourceStyleDynamicProperty = 16;
	kASSourceStyleDynamicEnumValue = 17;
	kASNumberOfSourceStyles = 18;    { Deprecated. Don't assume the array length is fixed, and don't assume all indices are in the array. Always get its size at runtime. }

{$endc} {TARGET_OS_MAC}
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
