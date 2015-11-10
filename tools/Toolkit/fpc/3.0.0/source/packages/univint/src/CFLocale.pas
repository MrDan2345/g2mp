{	CFLocale.h
	Copyright (c) 2002-2012, Apple Inc. All rights reserved.
}
{	  Pascal Translation:  Peter N Lewis, <peter@stairways.com.au>, 2004 }
{	  Pascal Translation Updated:  Peter N Lewis, <peter@stairways.com.au>, September 2005 }
{   Pascal Translation Updated:  Gorazd Krosl, <gorazd_1957@yahoo.ca>, October 2009 }
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

unit CFLocale;
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
uses MacTypes,CFBase,CFArray,CFDictionary;
{$endc} {not MACOSALLINCLUDE}

{$ALIGN POWER}


{#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_3}


type
	CFLocaleRef = ^__CFLocale; { an opaque type }
	__CFLocale = record end;

function CFLocaleGetTypeID: CFTypeID; external name '_CFLocaleGetTypeID';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

function CFLocaleGetSystem: CFLocaleRef; external name '_CFLocaleGetSystem';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
	// Returns the "root", canonical locale.  Contains fixed "backstop" settings.

function CFLocaleCopyCurrent: CFLocaleRef; external name '_CFLocaleCopyCurrent';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
	// Returns the logical "user" locale for the current user.
	// [This is Copy in the sense that you get a retain you have to release,
	// but we may return the same cached object over and over.]  Settings
	// you get from this locale do not change under you as CFPreferences
	// are changed (for safety and correctness).  Generally you would not
	// grab this and hold onto it forever, but use it to do the operations
	// you need to do at the moment, then throw it away.  (The non-changing
	// ensures that all the results of your operations are consistent.)

function CFLocaleCopyAvailableLocaleIdentifiers: CFArrayRef; external name '_CFLocaleCopyAvailableLocaleIdentifiers';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
	// Returns an array of CFStrings that represents all locales for
	// which locale data is available.

function CFLocaleCopyISOLanguageCodes: CFArrayRef; external name '_CFLocaleCopyISOLanguageCodes';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
	// Returns an array of CFStrings that represents all known legal ISO
	// language codes.  Note: many of these will not have any supporting
	// locale data in Mac OS X.

function CFLocaleCopyISOCountryCodes: CFArrayRef; external name '_CFLocaleCopyISOCountryCodes';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
	// Returns an array of CFStrings that represents all known legal ISO
	// country codes.  Note: many of these will not have any supporting
	// locale data in Mac OS X.

function CFLocaleCopyISOCurrencyCodes: CFArrayRef; external name '_CFLocaleCopyISOCurrencyCodes';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
	// Returns an array of CFStrings that represents all known legal ISO
	// currency codes.  Note: some of these currencies may be obsolete, or
	// represent other financial instruments.

function CFLocaleCopyCommonISOCurrencyCodes: CFArrayRef; external name '_CFLocaleCopyCommonISOCurrencyCodes';
(* CF_AVAILABLE_STARTING(10_5, 2_0) *)
	// Returns an array of CFStrings that represents ISO currency codes for
	// currencies in common use.

function CFLocaleCopyPreferredLanguages: CFArrayRef; external name '_CFLocaleCopyPreferredLanguages';
(* CF_AVAILABLE_STARTING(10_5, 2_0) *)
	// Returns the array of canonicalized CFString locale IDs that the user prefers.

function CFLocaleCreateCanonicalLanguageIdentifierFromString( allocator: CFAllocatorRef; localeIdentifier: CFStringRef ): CFStringRef; external name '_CFLocaleCreateCanonicalLanguageIdentifierFromString';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
	// Map an arbitrary language identification string (something close at
	// least) to a canonical language identifier.

function CFLocaleCreateCanonicalLocaleIdentifierFromString( allocator: CFAllocatorRef; localeIdentifier: CFStringRef ): CFStringRef; external name '_CFLocaleCreateCanonicalLocaleIdentifierFromString';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
	// Map an arbitrary locale identification string (something close at
	// least) to the canonical identifier.

function CFLocaleCreateCanonicalLocaleIdentifierFromScriptManagerCodes( allocator: CFAllocatorRef; lcode: LangCode; rcode: RegionCode ): CFStringRef; external name '_CFLocaleCreateCanonicalLocaleIdentifierFromScriptManagerCodes';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
	// Map a Mac OS LangCode and RegionCode to the canonical locale identifier.

function CFLocaleCreateLocaleIdentifierFromWindowsLocaleCode( allocator: CFAllocatorRef; lcid: UInt32 ): CFStringRef; external name '_CFLocaleCreateLocaleIdentifierFromWindowsLocaleCode';
(* CF_AVAILABLE_STARTING(10_6, 4_0) *)
	// Map a Windows LCID to the canonical locale identifier.

function CFLocaleGetWindowsLocaleCodeFromLocaleIdentifier( localeIdentifier: CFStringRef ): UInt32; external name '_CFLocaleGetWindowsLocaleCodeFromLocaleIdentifier';
(* CF_AVAILABLE_STARTING(10_6, 4_0) *)
	// Map a locale identifier to a Windows LCID.

type
	CFLocaleLanguageDirection = CFIndex;
const
	kCFLocaleLanguageDirectionUnknown = 0;
	kCFLocaleLanguageDirectionLeftToRight = 1;
	kCFLocaleLanguageDirectionRightToLeft = 2;
	kCFLocaleLanguageDirectionTopToBottom = 3;
	kCFLocaleLanguageDirectionBottomToTop = 4;

function CFLocaleGetLanguageCharacterDirection( isoLangCode: CFStringRef ): CFLocaleLanguageDirection; external name '_CFLocaleGetLanguageCharacterDirection';
(* CF_AVAILABLE_STARTING(10_6, 4_0) *)

function CFLocaleGetLanguageLineDirection( isoLangCode: CFStringRef ): CFLocaleLanguageDirection; external name '_CFLocaleGetLanguageLineDirection';
(* CF_AVAILABLE_STARTING(10_6, 4_0) *)

function CFLocaleCreateComponentsFromLocaleIdentifier( allocator: CFAllocatorRef; localeID: CFStringRef ): CFDictionaryRef; external name '_CFLocaleCreateComponentsFromLocaleIdentifier';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
	// Parses a locale ID consisting of language, script, country, variant,
	// and keyword/value pairs into a dictionary. The keys are the constant
	// CFStrings corresponding to the locale ID components, and the values
	// will correspond to constants where available.
	// Example: "en_US@calendar=japanese" yields a dictionary with three
	// entries: kCFLocaleLanguageCode=en, kCFLocaleCountryCode=US, and
	// kCFLocaleCalendarIdentifier=kCFJapaneseCalendar.

function CFLocaleCreateLocaleIdentifierFromComponents( allocator: CFAllocatorRef; dictionary: CFDictionaryRef ): CFStringRef; external name '_CFLocaleCreateLocaleIdentifierFromComponents';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
	// Reverses the actions of CFLocaleCreateDictionaryFromLocaleIdentifier,
	// creating a single string from the data in the dictionary. The
	// dictionary {kCFLocaleLanguageCode=en, kCFLocaleCountryCode=US,
	// kCFLocaleCalendarIdentifier=kCFJapaneseCalendar} becomes
	// "en_US@calendar=japanese".

function CFLocaleCreate( allocator: CFAllocatorRef; localeIdentifier: CFStringRef ): CFLocaleRef; external name '_CFLocaleCreate';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
	// Returns a CFLocaleRef for the locale named by the "arbitrary" locale identifier.

function CFLocaleCreateCopy( allocator: CFAllocatorRef; locale: CFLocaleRef ): CFLocaleRef; external name '_CFLocaleCreateCopy';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
	// Having gotten a CFLocale from somebody, code should make a copy
	// if it is going to use it for several operations
	// or hold onto it.  In the future, there may be mutable locales.

function CFLocaleGetIdentifier( locale: CFLocaleRef ): CFStringRef; external name '_CFLocaleGetIdentifier';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
	// Returns the locale's identifier.  This may not be the same string
	// that the locale was created with (CFLocale may canonicalize it).

function CFLocaleGetValue( locale: CFLocaleRef; key: CFStringRef ): CFTypeRef; external name '_CFLocaleGetValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
	// Returns the value for the given key.  This is how settings and state
	// are accessed via a CFLocale.  Values might be of any CF type.

function CFLocaleCopyDisplayNameForPropertyValue( displayLocale: CFLocaleRef; key: CFStringRef; value: CFStringRef ): CFStringRef; external name '_CFLocaleCopyDisplayNameForPropertyValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
	// Returns the display name for the given value.  The key tells what
	// the value is, and is one of the usual locale property keys, though
	// not all locale property keys have values with display name values.


var kCFLocaleCurrentLocaleDidChangeNotification: CFStringRef; external name '_kCFLocaleCurrentLocaleDidChangeNotification'; (* attribute const *)
(* CF_AVAILABLE_STARTING(10_5, 2_0) *)


// Locale Keys
var kCFLocaleIdentifier: CFStringRef; external name '_kCFLocaleIdentifier'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFLocaleLanguageCode: CFStringRef; external name '_kCFLocaleLanguageCode'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFLocaleCountryCode: CFStringRef; external name '_kCFLocaleCountryCode'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFLocaleScriptCode: CFStringRef; external name '_kCFLocaleScriptCode'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFLocaleVariantCode: CFStringRef; external name '_kCFLocaleVariantCode'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

var kCFLocaleExemplarCharacterSet: CFStringRef; external name '_kCFLocaleExemplarCharacterSet'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFLocaleCalendarIdentifier: CFStringRef; external name '_kCFLocaleCalendarIdentifier'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFLocaleCalendar: CFStringRef; external name '_kCFLocaleCalendar'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFLocaleCollationIdentifier: CFStringRef; external name '_kCFLocaleCollationIdentifier'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFLocaleUsesMetricSystem: CFStringRef; external name '_kCFLocaleUsesMetricSystem'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFLocaleMeasurementSystem: CFStringRef; external name '_kCFLocaleMeasurementSystem'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *) // "Metric" or "U.S."
var kCFLocaleDecimalSeparator: CFStringRef; external name '_kCFLocaleDecimalSeparator'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
var kCFLocaleGroupingSeparator: CFStringRef; external name '_kCFLocaleGroupingSeparator'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
var kCFLocaleCurrencySymbol: CFStringRef; external name '_kCFLocaleCurrencySymbol'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
var kCFLocaleCurrencyCode: CFStringRef; external name '_kCFLocaleCurrencyCode'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *) // ISO 3-letter currency code
var kCFLocaleCollatorIdentifier: CFStringRef; external name '_kCFLocaleCollatorIdentifier'; (* attribute const *)
(* CF_AVAILABLE_STARTING(10_6, 4_0) *)
var kCFLocaleQuotationBeginDelimiterKey: CFStringRef; external name '_kCFLocaleQuotationBeginDelimiterKey'; (* attribute const *)
(* CF_AVAILABLE_STARTING(10_6, 4_0) *)
var kCFLocaleQuotationEndDelimiterKey: CFStringRef; external name '_kCFLocaleQuotationEndDelimiterKey'; (* attribute const *)
(* CF_AVAILABLE_STARTING(10_6, 4_0) *)
var kCFLocaleAlternateQuotationBeginDelimiterKey: CFStringRef; external name '_kCFLocaleAlternateQuotationBeginDelimiterKey'; (* attribute const *)
(* CF_AVAILABLE_STARTING(10_6, 4_0) *)
var kCFLocaleAlternateQuotationEndDelimiterKey: CFStringRef; external name '_kCFLocaleAlternateQuotationEndDelimiterKey'; (* attribute const *)
(* CF_AVAILABLE_STARTING(10_6, 4_0) *)

// Values for kCFLocaleCalendarIdentifier
var kCFGregorianCalendar: CFStringRef; external name '_kCFGregorianCalendar'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
var kCFBuddhistCalendar: CFStringRef; external name '_kCFBuddhistCalendar'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFChineseCalendar: CFStringRef; external name '_kCFChineseCalendar'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFHebrewCalendar: CFStringRef; external name '_kCFHebrewCalendar'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFIslamicCalendar: CFStringRef; external name '_kCFIslamicCalendar'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFIslamicCivilCalendar: CFStringRef; external name '_kCFIslamicCivilCalendar'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFJapaneseCalendar: CFStringRef; external name '_kCFJapaneseCalendar'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)
var kCFRepublicOfChinaCalendar: CFStringRef; external name '_kCFRepublicOfChinaCalendar'; (* attribute const *)
(* CF_AVAILABLE_STARTING(10_6, 4_0) *)
var kCFPersianCalendar: CFStringRef; external name '_kCFPersianCalendar'; (* attribute const *)
(* CF_AVAILABLE_STARTING(10_6, 4_0) *)
var kCFIndianCalendar: CFStringRef; external name '_kCFIndianCalendar'; (* attribute const *)
(* CF_AVAILABLE_STARTING(10_6, 4_0) *)
var kCFISO8601Calendar: CFStringRef; external name '_kCFISO8601Calendar'; (* attribute const *)
(* CF_AVAILABLE_STARTING(10_6, 4_0) *)

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
