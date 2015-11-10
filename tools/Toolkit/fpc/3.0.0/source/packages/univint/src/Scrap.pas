{
     File:       HIToolbox/Scrap.h
 
     Contains:   Scrap Manager Interfaces.
 
     Version:    HIToolbox-437~1
 
     Copyright:  � 1985-2008 by Apple Computer, Inc., all rights reserved
 
     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:
 
                     http://www.freepascal.org/bugs.html
 
}
{       Pascal Translation Updated:  Peter N Lewis, <peter@stairways.com.au>, August 2005 }
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

unit Scrap;
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
uses MacTypes,CFBase,MixedMode,MacErrors,CFString;
{$endc} {not MACOSALLINCLUDE}


{$ifc TARGET_OS_MAC}

{$ALIGN MAC68K}

{
    ________________________________________________________________
    UNIVERSAL SCRAP MANAGER INTERFACES
    ________________________________________________________________
    The following interfaces are available when compiling for BOTH
    Carbon AND Mac OS 8.
    ________________________________________________________________
}
{
    While we're in here mucking about, we defined a new type to
    to put some confusion to rest. The old calls, as well as the
    new calls, use the new type. Existing clients should be
    blissfully ignorant.
}

type
	ScrapFlavorType = FourCharCode;
{
    Newsflash! After 15 years of arduous toil, it's finally possible
    for specially trained typists wielding advanced text editing
    technology to define symbolic names for commonly used scrap
    flavor type constants! Apple triumphs again!
}
const
	kScrapFlavorTypePicture = FourCharCode('PICT'); { contents of a PicHandle}
	kScrapFlavorTypeText = FourCharCode('TEXT'); { stream of characters}
	kScrapFlavorTypeTextStyle = FourCharCode('styl'); { see TEGetStyleScrapHandle}
	kScrapFlavorTypeMovie = FourCharCode('moov'); { reference to a movie}
	kScrapFlavorTypeSound = FourCharCode('snd '); { see SndRecord and SndPlay}
	kScrapFlavorTypeUnicode = FourCharCode('utxt'); { stream of UTF16 characters (internal representation)}
	kScrapFlavorTypeUTF16External = FourCharCode('ut16'); { stream of UTF16 characters (external representation)}
	kScrapFlavorTypeUnicodeStyle = FourCharCode('ustl'); { ATSUI defines; Textension uses}

{
    If you are a Carbon client and you need to run on Mac OS 8,
    you may still need to load and unload the scrap. Under Mac OS
    X, the scrap is held by the pasteboard server instead of in a
    handle in your app's heap, so LoadScrap and UnloadScrap do
    nothing when called under Mac OS X.
}

{$ifc not TARGET_CPU_64}
{
 *  LoadScrap()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    LoadScrap does nothing on Mac OS X.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function LoadScrap: OSStatus; external name '_LoadScrap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
 *  UnloadScrap()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    UnloadScrap does nothing on Mac OS X.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function UnloadScrap: OSStatus; external name '_UnloadScrap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
    ________________________________________________________________
    CARBON SCRAP MANAGER INTERFACES
    ________________________________________________________________
    The following interfaces are available only when compiling for
    Carbon.
    ________________________________________________________________
}

{
    When promising a scrap flavor, it's OK if you
    don't yet know how big the flavor data will be.
    In this case, just pass kScrapFlavorSizeUnknown
    for the flavor data size.
}

{$endc} {not TARGET_CPU_64}

const
	kScrapFlavorSizeUnknown = -1;

{
    kScrapReservedFlavorType is a flavor type which is reserved
    for use by Scrap Manager. If you pass it to Scrap Manager,
    it will be rejected.
}

const
	kScrapReservedFlavorType = FourCharCode('srft');

{
    We've added scrap flavor flags ala Drag Manager.

    kScrapFlavorMaskNone means you want none of the flags.

    kScrapFlavorSenderOnlyMask means only the process which
    put the flavor on the scrap can see it. If some other
    process put a flavor with this flag on the scrap,
    your process will never see the flavor, so there's
    no point in testing for this flag.

    kScrapFlavorTranslated means the flavor was translated
    from some other flavor in the scrap by Translation Manager.
    Most callers should not care about this bit.
}
const
	kScrapFlavorMaskNone = $00000000;
	kScrapFlavorMaskSenderOnly = $00000001;
	kScrapFlavorMaskTranslated = $00000002;

type
	ScrapFlavorFlags = UInt32;
{
    ScrapFlavorInfo describes a single flavor within
    a scrap.
}
type
	ScrapFlavorInfoPtr = ^ScrapFlavorInfo;
	ScrapFlavorInfo = record
		flavorType: ScrapFlavorType;
		flavorFlags: ScrapFlavorFlags;
	end;
type
	ScrapRef = ^OpaqueScrapRef; { an opaque type }
	OpaqueScrapRef = record end;
{
    kScrapRefNone is guaranteed to be an invalid ScrapRef.  This 
    is convenient when initializing application variables.
}
const
	kScrapRefNone = nil;
{
    Defined Apple scrap names for GetScrapByName
    kScrapClipboardScrap    traditional clipboard scrap
    kScrapFindScrap         compatible with Cocoa's global find scrap
}
{$ifc USE_CFSTR_CONSTANT_MACROS}
{$definec kScrapClipboardScrap CFSTRP('com.apple.scrap.clipboard')}
{$endc}
{$ifc USE_CFSTR_CONSTANT_MACROS}
{$definec kScrapFindScrap CFSTRP('com.apple.scrap.find')}
{$endc}

{  Enumerated options to be passed to GetScrapByName}

const
	kScrapGetNamedScrap = 0;    { get current named scrap without bumping}
	kScrapClearNamedScrap = 1 shl 0; { acquire the named scrap, bumping and clearing}

{
    GetScrapByName allows access to an indefinite number of public or private
    scraps.  The constant kScrapClipboardScrap refers to the "current" scrap
    we've all come to know and love.  kScrapFindScrap allows Carbon apps to
    interact seamlessly with Cocoa's global find scrap.  Note that calling:

        GetScrapByName( kScrapClipboardScrap, kScrapGetNamedScrap, &scrap );

    is an exact match to the call:
    
        GetCurrentScrap( &scrap );

    Additionally, a call to:

        GetScrapByName( kScrapClipboardScrap, kScrapClearNamedScrap, &scrap );

    is a replacement for the sequence:
    
        ClearCurrentScrap();
        GetCurrentScrap( &scrap );

    You can use this API to generate your own private scraps to use as a high
    level interprocess communication between your main and helper apps.  The Java
    naming convention is suggested for your scraps ( ie. com.joeco.scrap.secret ).
    
    CarbonLib does not support arbitrary named scraps; when calling this API on
    CarbonLib, kScrapClipboardScrap is the only supported value for the name parameter.
}
{$ifc not TARGET_CPU_64}
{
 *  GetScrapByName()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    The Scrap Manager is deprecated. Use PasteboardCreate instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.1 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.5 and later
 *    Non-Carbon CFM:   not available
 }
function GetScrapByName( name: CFStringRef; options: OptionBits; var scrap: ScrapRef ): OSStatus; external name '_GetScrapByName';
(* AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
    GetCurrentScrap obtains a reference to the current scrap.
    The ScrapRef obtained via GetCurrentScrap will become
    invalid and unusable after the scrap is cleared.
}

{
 *  GetCurrentScrap()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    The Scrap Manager is deprecated. Use PasteboardCreate instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function GetCurrentScrap( var scrap: ScrapRef ): OSStatus; external name '_GetCurrentScrap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
    GetScrapFlavorFlags tells you [a] whether the scrap contains
    data for a particular flavor and [b] some things about that
    flavor if it exists. This call never blocks, and is useful
    for deciding whether to enable the Paste item in your Edit
    menu, among other things.
}

{
 *  GetScrapFlavorFlags()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    The Scrap Manager is deprecated. Use PasteboardGetItemFlavorFlags
 *    instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function GetScrapFlavorFlags( scrap: ScrapRef; flavorType: ScrapFlavorType; var flavorFlags: ScrapFlavorFlags ): OSStatus; external name '_GetScrapFlavorFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
    GetScrapFlavorSize gets the size of the data of the specified
    flavor. This function blocks until the specified flavor
    data is available. GetScrapFlavorSize is intended as a prelude
    to allocating memory and calling GetScrapFlavorData.
}

{
 *  GetScrapFlavorSize()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    The Scrap Manager is deprecated. Use PasteboardCopyItemFlavorData
 *    instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function GetScrapFlavorSize( scrap: ScrapRef; flavorType: ScrapFlavorType; var byteCount: Size ): OSStatus; external name '_GetScrapFlavorSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
    GetScrapFlavorData gets the data from the specified flavor in the
    specified scrap. This function blocks until the specified flavor
    data is available. Specify the maximum size your buffer can contain;
    on output, this function produces the number of bytes that were
    available (even if this is more than you requested).
}

{
 *  GetScrapFlavorData()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    The Scrap Manager is deprecated. Use PasteboardCopyItemFlavorData
 *    instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function GetScrapFlavorData( scrap: ScrapRef; flavorType: ScrapFlavorType; var byteCount: Size; destination: UnivPtr ): OSStatus; external name '_GetScrapFlavorData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
    ClearCurrentScrap clears the current scrap. Call this
    first when the user requests a Copy or Cut operation --
    even if you maintain a private scrap! You should not wait
    until receiving a suspend event to call ClearCurrentScrap. Call
    it immediately after the user requests a Copy or Cut operation.
    You don't need to put any data on the scrap immediately (although
    it's perfectly fine to do so). You DO need to call GetCurrentScrap
    after ClearCurrentScrap so you'll have a valid ScrapRef to pass
    to other functions.
}

{
 *  ClearCurrentScrap()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    The Scrap Manager is deprecated. Use PasteboardClear instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function ClearCurrentScrap: OSStatus; external name '_ClearCurrentScrap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
        ClearScrap will clear the scrap passed in and return the bumped
        ScrapRef value. ClearScrap behaves similarly to GetScrapByName
        when called with the kScrapClearNamedScrap option with the
        benefit of not requiring a name in the event one is not available.
        
        CarbonLib does not support arbitrary named scraps; when calling this
        API on CarbonLib, only clearing the current scrap is supported.
}
{
 *  ClearScrap()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    The Scrap Manager is deprecated. Use PasteboardClear instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.1 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.5 and later
 *    Non-Carbon CFM:   not available
 }
function ClearScrap( var inOutScrap: ScrapRef ): OSStatus; external name '_ClearScrap';
(* AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
        PutScrapFlavor is a lot like PutScrap, with two differences:
        we added a ScrapRef parameter at the beginning and you can
        "promise" various aspects of a flavor. If you pass a NIL
        data pointer, this is a promise that in the future you
        will provide data for this flavor. Provide the data
        through a subsequent call to PutScrapFlavor, either later
        in the same code flow or during a scrap promise keeper proc.
        If you know how big the data is, you can pass the size as
        well, and this may allow subsequent callers of GetScrapFlavorInfo
        to avoid blocking. If you don't know the size, pass -1.
        If you pass a 0 size, you are telling Scrap Manager not to
        expect any data for this flavor. In this case, the flavor
        data pointer is ignored. NOTE: the last time you can provide
        scrap flavor data is when your scrap promise keeper gets
        called. It is NOT possible to call PutScrapFlavor while
        handling a suspend event; suspend events under Carbon
        simply don't work the way they do under Mac OS 8.

        The method for setting Scrap Manager promises differs from that for Drag Manger promises.
        This chart describes the method for setting scrap promises via PutScrapFlavor().
    
        dataPtr         dataSize                                result
     pointer value  actual data size    The data of size dataSize pointed to by dataPtr is added to the scrap.
           0        actual data size    A promise for data of size dataSize is placed on the scrap.
           0               -1           A promise for data of an undetermined size is placed on the scrap.
        ignored             0           A flavor with no data expected is placed on the scrap.  This is not a promise.
}
{
 *  PutScrapFlavor()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    The Scrap Manager is deprecated. Use PasteboardPutItemFlavor
 *    instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function PutScrapFlavor( scrap: ScrapRef; flavorType: ScrapFlavorType; flavorFlags: ScrapFlavorFlags; flavorSize: Size; flavorData: {const} UnivPtr { can be NULL } ): OSStatus; external name '_PutScrapFlavor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
    ScrapPromiseKeeper is a function you write which is called by
    Scrap Manager as needed to keep your earlier promise of a
    particular scrap flavor. When your function is called, deliver
    the requested data by calling PutScrapFlavor.
}

{$endc} {not TARGET_CPU_64}

type
	ScrapPromiseKeeperProcPtr = function( scrap: ScrapRef; flavorType: ScrapFlavorType; userData: UnivPtr ): OSStatus;
	ScrapPromiseKeeperUPP = ScrapPromiseKeeperProcPtr;
{
 *  NewScrapPromiseKeeperUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewScrapPromiseKeeperUPP( userRoutine: ScrapPromiseKeeperProcPtr ): ScrapPromiseKeeperUPP; external name '_NewScrapPromiseKeeperUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)

{
 *  DisposeScrapPromiseKeeperUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeScrapPromiseKeeperUPP( userUPP: ScrapPromiseKeeperUPP ); external name '_DisposeScrapPromiseKeeperUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)

{
 *  InvokeScrapPromiseKeeperUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeScrapPromiseKeeperUPP( scrap: ScrapRef; flavorType: ScrapFlavorType; userData: UnivPtr; userUPP: ScrapPromiseKeeperUPP ): OSStatus; external name '_InvokeScrapPromiseKeeperUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)

{
    SetScrapPromiseKeeper associates a ScrapPromiseKeeper with a
    scrap. You can remove a ScrapPromiseKeeper from a scrap by
    passing a NIL ScrapPromiseKeeper to SetScrapPromiseKeeper.
    Pass whatever you like in the last parameter; its value will
    be passed to your ScrapPromiseKeeper, which can do whatever
    it likes with the value. You might choose to pass a pointer
    or handle to some private scrap data which the
    ScrapPromiseKeeper could use in fabricating one or more
    promised flavors.
}
{$ifc not TARGET_CPU_64}
{
 *  SetScrapPromiseKeeper()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    The Scrap Manager is deprecated. Use PasteboardSetPromiseKeeper
 *    instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function SetScrapPromiseKeeper( scrap: ScrapRef; upp: ScrapPromiseKeeperUPP; userData: {const} UnivPtr ): OSStatus; external name '_SetScrapPromiseKeeper';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
    GetScrapFlavorCount produces the number of
    items which can be obtained by GetScrapFlavorInfoList.
}

{
 *  GetScrapFlavorCount()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    The Scrap Manager is deprecated. Use PasteboardCopyItemFlavors
 *    instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function GetScrapFlavorCount( scrap: ScrapRef; var infoCount: UInt32 ): OSStatus; external name '_GetScrapFlavorCount';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
    GetScrapFlavorInfoList fills a list (array)
    of items which each describe the corresponding
    flavor in the scrap. It fills no more array
    elements as are specified. On exit, it produces
    the count of elements it filled (which may be
    smaller than the count requested). Yes, YOU
    must provide the memory for the array.
}

{
 *  GetScrapFlavorInfoList()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    The Scrap Manager is deprecated. Use PasteboardCopyItemFlavors
 *    instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function GetScrapFlavorInfoList( scrap: ScrapRef; var infoCount: UInt32; info: {variable-size-array} ScrapFlavorInfoPtr ): OSStatus; external name '_GetScrapFlavorInfoList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
    CallInScrapPromises forces all promises to be kept.
    If your application promises at least one flavor
    AND it does NOT adopt the new event model, you
    should call this function when your application
    is about to quit. If your app promises no flavors,
    there is no need to call this function, and if
    your app adopts the new event model, this function
    will be called automagically for you. It doesn't
    hurt to call this function more than once, though
    promise keepers may be asked to keep promises
    they already tried and failed.
}

{
 *  CallInScrapPromises()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    The Scrap Manager is deprecated. Use PasteboardResolvePromises
 *    instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function CallInScrapPromises: OSStatus; external name '_CallInScrapPromises';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{$endc} {not TARGET_CPU_64}

{$endc} {TARGET_OS_MAC}
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
