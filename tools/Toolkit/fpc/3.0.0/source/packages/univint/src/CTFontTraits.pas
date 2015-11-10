{
 *  CTFontTraits.h
 *  CoreText
 *
 *  Copyright (c) 2006-2012 Apple Inc. All rights reserved.
 *
 }
{  Initial Pascal Translation:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
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

unit CTFontTraits;
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


{!
    @defined    kCTFontSymbolicTrait
    @abstract   Dictionary key to access the symbolic traits value.
    @discussion Use this key to access the symbolic traits value from the font traits dictionary. The value is returned as a CFNumberRef.
}
var kCTFontSymbolicTrait: CFStringRef; external name '_kCTFontSymbolicTrait'; (* attribute const *)
(* CT_AVAILABLE_STARTING( __MAC_10_5, __IPHONE_3_2) *)
{!
    @defined    kCTFontWeightTrait
    @abstract   Dictionary key to access the weight trait value.
    @discussion Use this key to access the normalized weigth trait from the font traits dictionary. The value returned is a CFNumberRef representing a float value between -1.0 and 1.0 for normalized weight. The value of 0.0 corresponds to the regular or medium font weight.
}
var kCTFontWeightTrait: CFStringRef; external name '_kCTFontWeightTrait'; (* attribute const *)
(* CT_AVAILABLE_STARTING( __MAC_10_5, __IPHONE_3_2) *)
{!
    @defined    kCTFontWidthTrait
    @abstract   Dictionary key to access the width (condense/expand) trait value.
    @discussion Use this key to access the normalized proportion trait from the font traits dictionary. This value corresponds to the relative inter-glyph spacing for a given font. The value returned is a CFNumberRef representing a float between -1.0 and 1.0. The value of 0.0 corresponds to regular glyph spacing while negative values represent condensed glyph spacing.
}
var kCTFontWidthTrait: CFStringRef; external name '_kCTFontWidthTrait'; (* attribute const *)
(* CT_AVAILABLE_STARTING( __MAC_10_5, __IPHONE_3_2) *)
{!
    @defined    kCTFontSlantTrait
    @abstract   Dictionary key to access the slant trait value.
    @discussion Use this key to access the normalized slant angle from the font traits dictionary. The value returned is a CFNumberRef representing a float value between -1.0 and 1.0 for normalized slant angle. The value or 0.0 corresponds to 0 degree clockwise rotation from the vertical and 1.0 corresponds to 30 degrees clockwise rotation.
}
var kCTFontSlantTrait: CFStringRef; external name '_kCTFontSlantTrait'; (* attribute const *)
(* CT_AVAILABLE_STARTING( __MAC_10_5, __IPHONE_3_2) *)

{!
    @const      kCTFontClassMaskShift
    @abstract   The font class shift.
    @discussion This is used to shift the font class to the upper most 4 bits of the symbolic traits.
}
const
	kCTFontClassMaskShift = 28;

{!
    @enum       CTFontSymbolicTraits
    @abstract   Symbolic representation of stylistic font attributes.
    @discussion CTFontSymbolicTraits symbolically describes stylistic aspects of a font. The upper 16 bits is used to describe appearance of the font whereas the lower 16 bits for typeface. The font appearance information represented by the upper 16 bits can be used for stylistic font matching.
}
const
	kCTFontTraitItalic = 1 shl 0;     // Additional detail available via kCTFontSlantTrait
	kCTFontTraitBold = 1 shl 1;     // Additional detail available via kCTFontWeightTrait
	kCTFontTraitExpanded = 1 shl 5;     // Expanded and condensed traits are mutually exclusive
	kCTFontTraitCondensed = 1 shl 6;     // Additional detail available via kCTFontWidthTrait
	kCTFontTraitMonoSpace = 1 shl 10;    // Use fixed-pitch glyphs if available. May have multiple glyph advances (most CJK glyphs may contain two spaces)
	kCTFontTraitVertical = 1 shl 11;    // Use vertical glyph variants and metrics
	kCTFontTraitUIOptimized = 1 shl 12;    // Synthesize appropriate attributes for UI rendering such as control titles if necessary
    kCTFontTraitColorGlyphs         = 1 shl 13;    // Color bitmap glyphs are available. 
    kCTFontTraitComposite           = 1 shl 14;    // The font is a CFR (Composite font reference), a cascade list is expected per font. 

	kCTFontTraitClassMask = 15 shl kCTFontClassMaskShift; // Mask for the font class

    kCTFontItalicTrait = kCTFontTraitItalic;
    kCTFontBoldTrait = kCTFontTraitBold;
    kCTFontExpandedTrait = kCTFontTraitExpanded;
    kCTFontCondensedTrait = kCTFontTraitCondensed;
    kCTFontMonoSpaceTrait = kCTFontTraitMonoSpace;
    kCTFontVerticalTrait = kCTFontTraitVertical;
    kCTFontUIOptimizedTrait = kCTFontTraitUIOptimized;
    kCTFontColorGlyphsTrait = kCTFontTraitColorGlyphs;
    kCTFontCompositeTrait = kCTFontTraitComposite;
    kCTFontClassMaskTrait = kCTFontTraitClassMask;
type
	CTFontSymbolicTraits = UInt32;

{!
    @enum       CTFontStylisticClass
    @abstract   Stylistic class values.
    @discussion CTFontStylisticClass classifies certain stylistic qualities of the font. These values correspond closely to the font class values in the OpenType 'OS/2' table. The class values are bundled in the upper four bits of the CTFontSymbolicTraits and can be obtained via the kCTFontClassMaskTrait.
}
const
	kCTFontClassUnknown = 0 shl kCTFontClassMaskShift;
	kCTFontClassOldStyleSerifs = 1 shl kCTFontClassMaskShift;
	kCTFontClassTransitionalSerifs = 2 shl kCTFontClassMaskShift;
	kCTFontClassModernSerifs = 3 shl kCTFontClassMaskShift;
	kCTFontClassClarendonSerifs = 4 shl kCTFontClassMaskShift;
	kCTFontClassSlabSerifs = 5 shl kCTFontClassMaskShift;
	kCTFontClassFreeformSerifs = 7 shl kCTFontClassMaskShift;
	kCTFontClassSansSerif = 8 shl kCTFontClassMaskShift;
	kCTFontClassOrnamentals = 9 shl kCTFontClassMaskShift;
	kCTFontClassScripts = 10 shl kCTFontClassMaskShift;
	kCTFontClassSymbolic = 12 shl kCTFontClassMaskShift;

    kCTFontUnknownClass = kCTFontClassUnknown;
    kCTFontOldStyleSerifsClass = kCTFontClassOldStyleSerifs;
    kCTFontTransitionalSerifsClass = kCTFontClassTransitionalSerifs;
    kCTFontModernSerifsClass = kCTFontClassModernSerifs;
    kCTFontClarendonSerifsClass = kCTFontClassClarendonSerifs;
    kCTFontSlabSerifsClass = kCTFontClassSlabSerifs;
    kCTFontFreeformSerifsClass = kCTFontClassFreeformSerifs;
    kCTFontSansSerifClass = kCTFontClassSansSerif;
    kCTFontOrnamentalsClass = kCTFontClassOrnamentals;
    kCTFontScriptsClass = kCTFontClassScripts;
    kCTFontSymbolicClass = kCTFontClassSymbolic;
type
	CTFontStylisticClass = UInt32;
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
