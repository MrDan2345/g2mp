{	CFBundle.h
	Copyright (c) 1999-2012, Apple Inc.  All rights reserved.
}
{       Pascal Translation Updated:  Peter N Lewis, <peter@stairways.com.au>, September 2005 }
{       Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
{       Pascal Translation Updated:  Jonas Maebe <jonas@freepascal.org>, September 2012 }
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

unit CFBundle;
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
uses MacTypes,CFBase,CFArray,CFDictionary,CFError,CFString,CFURL;
{$endc} {not MACOSALLINCLUDE}

{$ALIGN POWER}


type
	CFBundleRef = ^__CFBundle; { an opaque type }
	__CFBundle = record end;
	CFBundleRefPtr = ^CFBundleRef;
	CFPlugInRef = ^__CFBundle; { an opaque type }
	CFPlugInRefPtr = ^CFPlugInRef;

{ ===================== Standard Info.plist keys ===================== }
var kCFBundleInfoDictionaryVersionKey: CFStringRef; external name '_kCFBundleInfoDictionaryVersionKey'; (* attribute const *)
    { The version of the Info.plist format }
var kCFBundleExecutableKey: CFStringRef; external name '_kCFBundleExecutableKey'; (* attribute const *)
    { The name of the executable in this bundle, if any }
var kCFBundleIdentifierKey: CFStringRef; external name '_kCFBundleIdentifierKey'; (* attribute const *)
    { The bundle identifier (for CFBundleGetBundleWithIdentifier()) }
var kCFBundleVersionKey: CFStringRef; external name '_kCFBundleVersionKey'; (* attribute const *)
    { The version number of the bundle.  For Mac OS 9 style version numbers (for example "2.5.3d5"), }
    { clients can use CFBundleGetVersionNumber() instead of accessing this key directly since that }
    { function will properly convert the version string into its compact integer representation. }
var kCFBundleDevelopmentRegionKey: CFStringRef; external name '_kCFBundleDevelopmentRegionKey'; (* attribute const *)
    { The name of the development language of the bundle. }
var kCFBundleNameKey: CFStringRef; external name '_kCFBundleNameKey'; (* attribute const *)
    { The human-readable name of the bundle.  This key is often found in the InfoPlist.strings since it is usually localized. }
{#if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED}
var kCFBundleLocalizationsKey: CFStringRef; external name '_kCFBundleLocalizationsKey'; (* attribute const *)
    { Allows an unbundled application that handles localization itself to specify which localizations it has available. }
{#endif}

{ ===================== Finding Bundles ===================== }

function CFBundleGetMainBundle: CFBundleRef; external name '_CFBundleGetMainBundle';

function CFBundleGetBundleWithIdentifier( bundleID: CFStringRef ): CFBundleRef; external name '_CFBundleGetBundleWithIdentifier';
    { A bundle can name itself by providing a key in the info dictionary. }
    { This facility is meant to allow bundle-writers to get hold of their }
    { bundle from their code without having to know where it was on the disk. }
    { This is meant to be a replacement mechanism for +bundleForClass: users. }
    { Note that this does not search for bundles on the disk; it will locate }
    { only bundles already loaded or otherwise known to the current process. }

function CFBundleGetAllBundles: CFArrayRef; external name '_CFBundleGetAllBundles';
    { This is potentially expensive, and not thread-safe.  Use with care. }
    { Best used for debuggging or other diagnostic purposes. }

{ ===================== Creating Bundles ===================== }

function CFBundleGetTypeID: CFTypeID; external name '_CFBundleGetTypeID';

function CFBundleCreate( allocator: CFAllocatorRef; bundleURL: CFURLRef ): CFBundleRef; external name '_CFBundleCreate';
    { Might return an existing instance with the ref-count bumped. }

function CFBundleCreateBundlesFromDirectory( allocator: CFAllocatorRef; directoryURL: CFURLRef; bundleType: CFStringRef ): CFArrayRef; external name '_CFBundleCreateBundlesFromDirectory';
    { Create instances for all bundles in the given directory matching the given type }
    { (or all of them if bundleType is NULL).  Instances are created using CFBundleCreate() and are not released. }

{ ==================== Basic Bundle Info ==================== }

function CFBundleCopyBundleURL( bundle: CFBundleRef ): CFURLRef; external name '_CFBundleCopyBundleURL';

function CFBundleGetValueForInfoDictionaryKey( bundle: CFBundleRef; key: CFStringRef ): CFTypeRef; external name '_CFBundleGetValueForInfoDictionaryKey';
    { Returns a localized value if available, otherwise the global value. }
    { This is the recommended function for examining the info dictionary. }

function CFBundleGetInfoDictionary( bundle: CFBundleRef ): CFDictionaryRef; external name '_CFBundleGetInfoDictionary';
    { This is the global info dictionary.  Note that CFBundle may add }
    { extra keys to the dictionary for its own use. }

function CFBundleGetLocalInfoDictionary( bundle: CFBundleRef ): CFDictionaryRef; external name '_CFBundleGetLocalInfoDictionary';
    { This is the localized info dictionary. }

procedure CFBundleGetPackageInfo( bundle: CFBundleRef; var packageType: OSType; var packageCreator: OSType ); external name '_CFBundleGetPackageInfo';

function CFBundleGetIdentifier( bundle: CFBundleRef ): CFStringRef; external name '_CFBundleGetIdentifier';

function CFBundleGetVersionNumber( bundle: CFBundleRef ): UInt32; external name '_CFBundleGetVersionNumber';

function CFBundleGetDevelopmentRegion( bundle: CFBundleRef ): CFStringRef; external name '_CFBundleGetDevelopmentRegion';

function CFBundleCopySupportFilesDirectoryURL( bundle: CFBundleRef ): CFURLRef; external name '_CFBundleCopySupportFilesDirectoryURL';

function CFBundleCopyResourcesDirectoryURL( bundle: CFBundleRef ): CFURLRef; external name '_CFBundleCopyResourcesDirectoryURL';

function CFBundleCopyPrivateFrameworksURL( bundle: CFBundleRef ): CFURLRef; external name '_CFBundleCopyPrivateFrameworksURL';

function CFBundleCopySharedFrameworksURL( bundle: CFBundleRef ): CFURLRef; external name '_CFBundleCopySharedFrameworksURL';

function CFBundleCopySharedSupportURL( bundle: CFBundleRef ): CFURLRef; external name '_CFBundleCopySharedSupportURL';

function CFBundleCopyBuiltInPlugInsURL( bundle: CFBundleRef ): CFURLRef; external name '_CFBundleCopyBuiltInPlugInsURL';

{ ------------- Basic Bundle Info without a CFBundle instance ------------- }
{ This API is provided to enable developers to retrieve basic information }
{ about a bundle without having to create an instance of CFBundle. }
{ Because of caching behavior when a CFBundle instance exists, it will be faster }
{ to actually create a CFBundle if you need to retrieve multiple pieces of info. }
function CFBundleCopyInfoDictionaryInDirectory( bundleURL: CFURLRef ): CFDictionaryRef; external name '_CFBundleCopyInfoDictionaryInDirectory';

function CFBundleGetPackageInfoInDirectory( url: CFURLRef; var packageType: UInt32; var packageCreator: UInt32 ): Boolean; external name '_CFBundleGetPackageInfoInDirectory';

{ ==================== Resource Handling API ==================== }

function CFBundleCopyResourceURL( bundle: CFBundleRef; resourceName: CFStringRef; resourceType: CFStringRef; subDirName: CFStringRef ): CFURLRef; external name '_CFBundleCopyResourceURL';

function CFBundleCopyResourceURLsOfType( bundle: CFBundleRef; resourceType: CFStringRef; subDirName: CFStringRef ): CFArrayRef; external name '_CFBundleCopyResourceURLsOfType';

function CFBundleCopyLocalizedString( bundle: CFBundleRef; key: CFStringRef; value: CFStringRef; tableName: CFStringRef ): CFStringRef; external name '_CFBundleCopyLocalizedString';

function CFCopyLocalizedString( key: CFStringRef; comment: PChar ): CFStringRef; inline;
function CFCopyLocalizedStringFromTable( key: CFStringRef; tableName: CFStringRef; comment: PChar ): CFStringRef; inline;
function CFCopyLocalizedStringFromTableInBundle( key: CFStringRef; tableName: CFStringRef; bundle: CFBundleRef; comment: PChar ): CFStringRef; inline;
function CFCopyLocalizedStringWithDefaultValue( key: CFStringRef; tableName: CFStringRef; bundle: CFBundleRef; value: CFStringRef; comment: PChar ): CFStringRef; inline;

{ ------------- Resource Handling without a CFBundle instance ------------- }
{ This API is provided to enable developers to use the CFBundle resource }
{ searching policy without having to create an instance of CFBundle. }
{ Because of caching behavior when a CFBundle instance exists, it will be faster }
{ to actually create a CFBundle if you need to access several resources. }

function CFBundleCopyResourceURLInDirectory( bundleURL: CFURLRef; resourceName: CFStringRef; resourceType: CFStringRef; subDirName: CFStringRef ): CFURLRef; external name '_CFBundleCopyResourceURLInDirectory';

function CFBundleCopyResourceURLsOfTypeInDirectory( bundleURL: CFURLRef; resourceType: CFStringRef; subDirName: CFStringRef ): CFArrayRef; external name '_CFBundleCopyResourceURLsOfTypeInDirectory';

{ =========== Localization-specific Resource Handling API =========== }
{ This API allows finer-grained control over specific localizations,  }
{ as distinguished from the above API, which always uses the user's   }
{ preferred localizations for the bundle in the current app context.  }

function CFBundleCopyBundleLocalizations( bundle: CFBundleRef ): CFArrayRef; external name '_CFBundleCopyBundleLocalizations';
    { Lists the localizations that a bundle contains.  }

function CFBundleCopyPreferredLocalizationsFromArray( locArray: CFArrayRef ): CFArrayRef; external name '_CFBundleCopyPreferredLocalizationsFromArray';
    { Given an array of possible localizations, returns the one or more }
    { of them that CFBundle would use in the current application context. }
    { To determine the localizations that would be used for a particular }
    { bundle in the current application context, apply this function to the }
    { result of CFBundleCopyBundleLocalizations().  }

{#if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED}
function CFBundleCopyLocalizationsForPreferences( locArray: CFArrayRef; prefArray: CFArrayRef ): CFArrayRef; external name '_CFBundleCopyLocalizationsForPreferences';
    { Given an array of possible localizations, returns the one or more of }
    { them that CFBundle would use, without reference to the current application }
    { context, if the user's preferred localizations were given by prefArray. }
    { If prefArray is NULL, the current user's actual preferred localizations will }
    { be used. This is not the same as CFBundleCopyPreferredLocalizationsFromArray(), }
    { because that function takes the current application context into account. }
    { To determine the localizations that another application would use, apply }
    { this function to the result of CFBundleCopyBundleLocalizations().  }
{#endif}

function CFBundleCopyResourceURLForLocalization( bundle: CFBundleRef; resourceName: CFStringRef; resourceType: CFStringRef; subDirName: CFStringRef; localizationName: CFStringRef ): CFURLRef; external name '_CFBundleCopyResourceURLForLocalization';

function CFBundleCopyResourceURLsOfTypeForLocalization( bundle: CFBundleRef; resourceType: CFStringRef; subDirName: CFStringRef; localizationName: CFStringRef ): CFArrayRef; external name '_CFBundleCopyResourceURLsOfTypeForLocalization';
    { The localizationName argument to CFBundleCopyResourceURLForLocalization() or }
    { CFBundleCopyResourceURLsOfTypeForLocalization() must be identical to one of the }
    { localizations in the bundle, as returned by CFBundleCopyBundleLocalizations(). }
    { It is recommended that either CFBundleCopyPreferredLocalizationsFromArray() or }
    { CFBundleCopyLocalizationsForPreferences() be used to select the localization. }

{#if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED}
{ =================== Unbundled application info ===================== }
{ This API is provided to enable developers to retrieve bundle-related }
{ information about an application that may be bundled or unbundled.   }
function CFBundleCopyInfoDictionaryForURL( url: CFURLRef ): CFDictionaryRef; external name '_CFBundleCopyInfoDictionaryForURL';
    { For a directory URL, this is equivalent to CFBundleCopyInfoDictionaryInDirectory(). }
    { For a plain file URL representing an unbundled executable, this will attempt to read }
    { an info dictionary from the (__TEXT, __info_plist) section, if it is a Mach-o file, }
    { or from a 'plst' resource.  }

function CFBundleCopyLocalizationsForURL( url: CFURLRef ): CFArrayRef; external name '_CFBundleCopyLocalizationsForURL';
    { For a directory URL, this is equivalent to calling CFBundleCopyBundleLocalizations() }
    { on the corresponding bundle.  For a plain file URL representing an unbundled executable, }
    { this will attempt to determine its localizations using the CFBundleLocalizations and }
    { CFBundleDevelopmentRegion keys in the dictionary returned by CFBundleCopyInfoDictionaryForURL,}
    { or from a 'vers' resource if those are not present.  }
{#endif}

function CFBundleCopyExecutableArchitecturesForURL( url: CFURLRef ): CFArrayRef; external name '_CFBundleCopyExecutableArchitecturesForURL';
(* CF_AVAILABLE_STARTING(10_5, 2_0) *)
    { For a directory URL, this is equivalent to calling CFBundleCopyExecutableArchitectures() }
    { on the corresponding bundle.  For a plain file URL representing an unbundled executable, }
    { this will return the architectures it provides, if it is a Mach-o file, or NULL otherwise. }

{ ==================== Primitive Code Loading API ==================== }
{ This API abstracts the various different executable formats supported on }
{ various platforms.  It can load DYLD, CFM, or DLL shared libraries (on their }
{ appropriate platforms) and gives a uniform API for looking up functions. }
{ Note that Cocoa-based bundles containing Objective-C or Java code must }
{ be loaded with NSBundle, not CFBundle.  Once they are loaded, however, }
{ either CFBundle or NSBundle can be used. }

function CFBundleCopyExecutableURL( bundle: CFBundleRef ): CFURLRef; external name '_CFBundleCopyExecutableURL';

{#if MAC_OS_X_VERSION_10_5 <= MAC_OS_X_VERSION_MAX_ALLOWED}
const
	kCFBundleExecutableArchitectureI386 = $00000007;
	kCFBundleExecutableArchitecturePPC = $00000012;
	kCFBundleExecutableArchitectureX86_64 = $01000007;
	kCFBundleExecutableArchitecturePPC64 = $01000012;
{#endif} { MAC_OS_X_VERSION_10_5 <= MAC_OS_X_VERSION_MAX_ALLOWED }

function CFBundleCopyExecutableArchitectures( bundle: CFBundleRef ): CFArrayRef; external name '_CFBundleCopyExecutableArchitectures';
(* CF_AVAILABLE_STARTING(10_5, 2_0) *)
    { If the bundle's executable exists and is a Mach-o file, this function will return an array }
    { of CFNumbers whose values are integers representing the architectures the file provides. }
    { The values currently in use are those listed in the enum above, but others may be added }
    { in the future.  If the executable is not a Mach-o file, this function returns NULL. }

function CFBundlePreflightExecutable( bundle: CFBundleRef; var error: CFErrorRef ): Boolean; external name '_CFBundlePreflightExecutable';
(* CF_AVAILABLE_STARTING(10_5, 2_0) *)
    { This function will return true if the bundle is loaded, or if the bundle appears to be }
    { loadable upon inspection.  This does not mean that the bundle is definitively loadable, }
    { since it may fail to load due to link errors or other problems not readily detectable. }
    { If this function detects problems, it will return false, and return a CFError by reference. }
    { It is the responsibility of the caller to release the CFError. }

function CFBundleLoadExecutableAndReturnError( bundle: CFBundleRef; var error: CFErrorRef ): Boolean; external name '_CFBundleLoadExecutableAndReturnError';
(* CF_AVAILABLE_STARTING(10_5, 2_0) *)
    { If the bundle is already loaded, this function will return true.  Otherwise, it will attempt }
    { to load the bundle, and it will return true if that attempt succeeds.  If the bundle fails }
    { to load, this function will return false, and it will return a CFError by reference.  }
    { It is the responsibility of the caller to release the CFError. }

function CFBundleLoadExecutable( bundle: CFBundleRef ): Boolean; external name '_CFBundleLoadExecutable';

function CFBundleIsExecutableLoaded( bundle: CFBundleRef ): Boolean; external name '_CFBundleIsExecutableLoaded';

procedure CFBundleUnloadExecutable( bundle: CFBundleRef ); external name '_CFBundleUnloadExecutable';

function CFBundleGetFunctionPointerForName( bundle: CFBundleRef; functionName: CFStringRef ): UnivPtr; external name '_CFBundleGetFunctionPointerForName';

procedure CFBundleGetFunctionPointersForNames( bundle: CFBundleRef; functionNames: CFArrayRef; ftbl: {variable-size-array} UnivPtrPtr ); external name '_CFBundleGetFunctionPointersForNames';

function CFBundleGetDataPointerForName( bundle: CFBundleRef; symbolName: CFStringRef ): UnivPtr; external name '_CFBundleGetDataPointerForName';

procedure CFBundleGetDataPointersForNames( bundle: CFBundleRef; symbolNames: CFArrayRef; stbl: {variable-size-array} UnivPtrPtr ); external name '_CFBundleGetDataPointersForNames';

function CFBundleCopyAuxiliaryExecutableURL( bundle: CFBundleRef; executableName: CFStringRef ): CFURLRef; external name '_CFBundleCopyAuxiliaryExecutableURL';
    { This function can be used to find executables other than your main }
    { executable.  This is useful, for instance, for applications that have }
    { some command line tool that is packaged with and used by the application. }
    { The tool can be packaged in the various platform executable directories }
    { in the bundle and can be located with this function.  This allows an }
    { app to ship versions of the tool for each platform as it does for the }
    { main app executable. }

{ ==================== Getting a bundle's plugIn ==================== }

function CFBundleGetPlugIn( bundle: CFBundleRef ): CFPlugInRef; external name '_CFBundleGetPlugIn';

{ ==================== Resource Manager-Related API ==================== }

{$ifc TARGET_CPU_64}
type
	CFBundleRefNum = SInt32;
{$elsec}
type
	CFBundleRefNum = SInt16;
{$endc}

function CFBundleOpenBundleResourceMap( bundle: CFBundleRef ): CFBundleRefNum; external name '_CFBundleOpenBundleResourceMap';
   { This function opens the non-localized and the localized resource files }
   { (if any) for the bundle, creates and makes current a single read-only }
   { resource map combining both, and returns a reference number for it. }
   { If it is called multiple times, it opens the files multiple times, }
   { and returns distinct reference numbers.  }

function CFBundleOpenBundleResourceFiles( bundle: CFBundleRef; var refNum: CFBundleRefNum; var localizedRefNum: CFBundleRefNum ): SInt32; external name '_CFBundleOpenBundleResourceFiles';
   { Similar to CFBundleOpenBundleResourceMap(), except that it creates two }
   { separate resource maps and returns reference numbers for both. }

procedure CFBundleCloseBundleResourceMap( bundle: CFBundleRef; refNum: CFBundleRefNum ); external name '_CFBundleCloseBundleResourceMap';


{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}
implementation


{$R-}

function CFCopyLocalizedString( key: CFStringRef; comment: PChar ): CFStringRef; inline;
begin
	CFCopyLocalizedString := CFBundleCopyLocalizedString( CFBundleGetMainBundle, key, key, nil );
end;

function CFCopyLocalizedStringFromTable( key: CFStringRef; tableName: CFStringRef; comment: PChar ): CFStringRef; inline;
begin
	CFCopyLocalizedStringFromTable := CFBundleCopyLocalizedString( CFBundleGetMainBundle, key, key, tableName );
end;

function CFCopyLocalizedStringFromTableInBundle( key: CFStringRef; tableName: CFStringRef; bundle: CFBundleRef; comment: PChar ): CFStringRef; inline;
begin
	CFCopyLocalizedStringFromTableInBundle := CFBundleCopyLocalizedString( bundle, key, key, tableName );
end;

function CFCopyLocalizedStringWithDefaultValue( key: CFStringRef; tableName: CFStringRef; bundle: CFBundleRef; value: CFStringRef; comment: PChar ): CFStringRef; inline;
begin
	CFCopyLocalizedStringWithDefaultValue := CFBundleCopyLocalizedString( bundle, key, value, tableName );
end;


end.

{$endc} {not MACOSALLINCLUDE}
