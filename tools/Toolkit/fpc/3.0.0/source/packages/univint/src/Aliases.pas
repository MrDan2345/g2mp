{
     File:       CarbonCore/Aliases.h
 
     Contains:   Alias Manager Interfaces.
                 The contents of this header file are deprecated.
                 Use Foundation or CoreFoundation URL Bookmarks instead.
 
     Copyright:  � 1989-2011 by Apple Inc. All rights reserved.
}
{	  Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
{	  Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, September 2012 }
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

unit Aliases;
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
uses MacTypes,Files,UTCUtils,CFBase;
{$endc} {not MACOSALLINCLUDE}


{$ifc TARGET_OS_MAC}

{$ALIGN MAC68K}


type
	FSAliasInfoBitmap = UInt32;
	FSAliasInfoBitmapPtr = ^FSAliasInfoBitmap;
const
	kFSAliasInfoNone = $00000000; { no valid info}
	kFSAliasInfoVolumeCreateDate = $00000001; { volume creation date is valid}
	kFSAliasInfoTargetCreateDate = $00000002; { target creation date is valid}
	kFSAliasInfoFinderInfo = $00000004; { file type and creator are valid}
	kFSAliasInfoIsDirectory = $00000008; { isDirectory boolean is valid}
	kFSAliasInfoIDs = $00000010; { parentDirID and nodeID are valid}
	kFSAliasInfoFSInfo = $00000020; { filesystemID and signature are valid}
	kFSAliasInfoVolumeFlags = $00000040; { volumeIsBootVolume, volumeIsAutomounted, volumeIsEjectable and volumeHasPersistentFileIDs are valid}

const
	rAliasType = FourCharCode('alis'); { Aliases are stored as resources of this type }

const
{ define alias resolution action rules mask }
	kARMMountVol = $00000001; { mount the volume automatically }
	kARMNoUI = $00000002; { no user interface allowed during resolution }
	kARMMultVols = $00000008; { search on multiple volumes }
	kARMSearch = $00000100; { search quickly }
	kARMSearchMore = $00000200; { search further }
	kARMSearchRelFirst = $00000400; { search target on a relative path first }
	kARMTryFileIDFirst = $00000800; { search by file id before path }

const
{ define alias record information types }
	asiZoneName = -3;   { get zone name }
	asiServerName = -2;   { get server name }
	asiVolumeName = -1;   { get volume name }
	asiAliasName = 0;    { get aliased file/folder/volume name }
	asiParentName = 1;     { get parent folder name }

{ ResolveAliasFileWithMountFlags options }
const
	kResolveAliasFileNoUI = $00000001; { no user interaction during resolution }
	kResolveAliasTryFileIDFirst = $00000002; { search by file id before path }

	{	 define the alias record that will be the blackbox for the caller 	}

type
	AliasRecordPtr = ^AliasRecord;
  { Opaque as of Mac OS X 10.4 ... }
	AliasRecord = record
		userType: OSType;               { appl stored type like creator type }
		aliasSize: UInt16;              { alias record size in bytes, for appl usage }
	end;

type
	AliasPtr = AliasRecordPtr;
	AliasHandle = ^AliasPtr;
{ info block to pass to FSCopyAliasInfo }
type
	FSAliasInfo = record
		volumeCreateDate: UTCDateTime;
		targetCreateDate: UTCDateTime;
		fileType: OSType;
		fileCreator: OSType;
		parentDirID: UInt32;
		nodeID: UInt32;
		filesystemID: UInt16;
		signature: UInt16;
		volumeIsBootVolume: Boolean;
		volumeIsAutomounted: Boolean;
		volumeIsEjectable: Boolean;
		volumeHasPersistentFileIDs: Boolean;
		isDirectory: Boolean;
	end;
	FSAliasInfoPtr = ^FSAliasInfo;
{ alias record information type }
type
	AliasInfoType = SInt16;
{$ifc not TARGET_CPU_64}
type
	AliasFilterProcPtr = function( cpbPtr: CInfoPBPtr; var quitFlag: Boolean; myDataPtr: Ptr ): Boolean;
	AliasFilterUPP = AliasFilterProcPtr;
{
 *  NewAliasFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
{ old name was NewAliasFilterProc }
function NewAliasFilterUPP( userRoutine: AliasFilterProcPtr ): AliasFilterUPP; external name '_NewAliasFilterUPP';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)
{
 *  DisposeAliasFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeAliasFilterUPP( userUPP: AliasFilterUPP ); external name '_DisposeAliasFilterUPP';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)

{
 *  InvokeAliasFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeAliasFilterUPP( cpbPtr: CInfoPBPtr; var quitFlag: Boolean; myDataPtr: Ptr; userUPP: AliasFilterUPP ): Boolean; external name '_InvokeAliasFilterUPP';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)

{#if __MACH__
    #define NewAliasFilterUPP(userRoutine)                      ((AliasFilterUPP)userRoutine)
    #define DisposeAliasFilterUPP(userUPP)
    #define InvokeAliasFilterUPP(cpbPtr, quitFlag, myDataPtr, userUPP) (*userUPP)(cpbPtr, quitFlag, myDataPtr)
#endif}

{$endc} {not TARGET_CPU_64}

type
	FSAliasFilterProcPtr = function( const (*var*) ref: FSRef; var quitFlag: Boolean; myDataPtr: Ptr ): Boolean;
	FSAliasFilterUPP = FSAliasFilterProcPtr;

{
 *  FSNewAlias()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in InterfaceLib 9.1 and later
 }
function FSNewAlias( {const} fromFile: FSRefPtr { can be NULL }; const (*var*) target: FSRef; var inAlias: AliasHandle ): OSErr; external name '_FSNewAlias';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSNewAliasMinimal()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in InterfaceLib 9.1 and later
 }
function FSNewAliasMinimal( const (*var*) target: FSRef; var inAlias: AliasHandle ): OSErr; external name '_FSNewAliasMinimal';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSIsAliasFile()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in InterfaceLib 9.1 and later
 }
function FSIsAliasFile( const (*var*) fileRef: FSRef; var aliasFileFlag: Boolean; var folderFlag: Boolean ): OSErr; external name '_FSIsAliasFile';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSResolveAliasWithMountFlags()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in InterfaceLib 9.1 and later
 }
function FSResolveAliasWithMountFlags( {const} fromFile: FSRefPtr { can be NULL }; inAlias: AliasHandle; var target: FSRef; var wasChanged: Boolean; mountFlags: UNSIGNEDLONG ): OSErr; external name '_FSResolveAliasWithMountFlags';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSResolveAlias()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in InterfaceLib 9.1 and later
 }
function FSResolveAlias( {const} fromFile: FSRefPtr { can be NULL }; alias: AliasHandle; var target: FSRef; var wasChanged: Boolean ): OSErr; external name '_FSResolveAlias';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSResolveAliasFileWithMountFlags()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in InterfaceLib 9.1 and later
 }
function FSResolveAliasFileWithMountFlags( var theRef: FSRef; resolveAliasChains: Boolean; var targetIsFolder: Boolean; var wasAliased: Boolean; mountFlags: UNSIGNEDLONG ): OSErr; external name '_FSResolveAliasFileWithMountFlags';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSResolveAliasFile()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in InterfaceLib 9.1 and later
 }
function FSResolveAliasFile( var theRef: FSRef; resolveAliasChains: Boolean; var targetIsFolder: Boolean; var wasAliased: Boolean ): OSErr; external name '_FSResolveAliasFile';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSFollowFinderAlias()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in InterfaceLib 9.1 and later
 }
function FSFollowFinderAlias( fromFile: FSRefPtr { can be NULL }; alias: AliasHandle; logon: Boolean; var target: FSRef; var wasChanged: Boolean ): OSErr; external name '_FSFollowFinderAlias';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSUpdateAlias()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in InterfaceLib 9.1 and later
 }
function FSUpdateAlias( {const} fromFile: FSRefPtr { can be NULL }; const (*var*) target: FSRef; alias: AliasHandle; var wasChanged: Boolean ): OSErr; external name '_FSUpdateAlias';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSNewAliasUnicode()
 *  
 *  Summary:
 *    Creates an alias given a ref to the target's parent directory and
 *    the target's unicode name.  If the target does not exist fnfErr
 *    will be returned but the alias will still be created.  This
 *    allows the creation of aliases to targets that do not exist.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Parameters:
 *    
 *    fromFile:
 *      The starting point for a relative search.
 *    
 *    targetParentRef:
 *      An FSRef to the parent directory of the target.
 *    
 *    targetNameLength:
 *      Number of Unicode characters in the target's name.
 *    
 *    targetName:
 *      A pointer to the Unicode name.
 *    
 *    inAlias:
 *      A Handle to the newly created alias record.
 *    
 *    isDirectory:
 *      On input, if target does not exist, a flag to indicate whether
 *      or not the target is a directory.  On output, if the target did
 *      exist, a flag indicating if the target is a directory.  Pass
 *      NULL in the non-existant case if unsure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in CoreServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function FSNewAliasUnicode( {const} fromFile: FSRefPtr { can be NULL }; const (*var*) targetParentRef: FSRef; targetNameLength: UniCharCount; targetName: ConstUniCharPtr; var inAlias: AliasHandle; isDirectory: BooleanPtr { can be NULL } ): OSErr; external name '_FSNewAliasUnicode';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_2, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSNewAliasMinimalUnicode()
 *  
 *  Summary:
 *    Creates a minimal alias given a ref to the target's parent
 *    directory and the target's unicode name.  If the target does not
 *    exist fnfErr will be returned but the alias will still be created.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Parameters:
 *    
 *    targetParentRef:
 *      An FSRef to the parent directory of the target.
 *    
 *    targetNameLength:
 *      Number of Unicode characters in the target's name.
 *    
 *    targetName:
 *      A pointer to the Unicode name.
 *    
 *    inAlias:
 *      A Handle to the newly created alias record.
 *    
 *    isDirectory:
 *      On input, if target does not exist, a flag to indicate whether
 *      or not the target is a directory.  On output, if the target did
 *      exist, a flag indicating if the target is a directory.  Pass
 *      NULL in the non-existant case if unsure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in CoreServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function FSNewAliasMinimalUnicode( const (*var*) targetParentRef: FSRef; targetNameLength: UniCharCount; targetName: ConstUniCharPtr; var inAlias: AliasHandle; isDirectory: BooleanPtr { can be NULL } ): OSErr; external name '_FSNewAliasMinimalUnicode';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_2, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSNewAliasFromPath()
 *  
 *  Summary:
 *    Creates an alias given a POSIX style utf-8 path to the target. 
 *    If the target file does not exist but the path up to the leaf
 *    does then fnfErr will be returned but the alias will still be
 *    created.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.5
 *  
 *  Parameters:
 *    
 *    fromFilePath:
 *      The starting point for a relative search.
 *    
 *    targetPath:
 *      POSIX style UTF-8 path to target.
 *    
 *    flags:
 *      Options for future use.  Pass in 0.
 *    
 *    inAlias:
 *      A Handle to the newly created alias record.
 *    
 *    isDirectory:
 *      On input, if target does not exist, a flag to indicate whether
 *      or not the target is a directory.  On output, if the target did
 *      exist, a flag indicating if the target is a directory.  Pass
 *      NULL in the non-existant case if unsure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in CoreServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.5 and later
 *    Non-Carbon CFM:   not available
 }
function FSNewAliasFromPath( fromFilePath: ConstCStringPtr { can be NULL }; targetPath: ConstCStringPtr; flags: OptionBits; var inAlias: AliasHandle; isDirectory: BooleanPtr { can be NULL } ): OSStatus; external name '_FSNewAliasFromPath';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_5, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSMatchAliasBulk()
 *  
 *  Summary:
 *    Given an alias handle and fromFile, match the alias and return
 *    FSRefs to the aliased file(s) and needsUpdate flag
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.5
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in CoreServices.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function FSMatchAliasBulk( {const} fromFile: FSRefPtr { can be NULL }; rulesMask: UNSIGNEDLONG; inAlias: AliasHandle; var aliasCount: SInt16; var aliasList: FSRef; var needsUpdate: Boolean; aliasFilter: FSAliasFilterProcPtr { can be NULL }; yourDataPtr: UnivPtr { can be NULL } ): OSStatus; external name '_FSMatchAliasBulk';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_5, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSCopyAliasInfo()
 *  
 *  Discussion:
 *    This routine will return the requested information from the
 *    passed in aliasHandle.  The information is gathered only from the
 *    alias record so it may not match what is on disk (no disk i/o is
 *    performed).  The whichInfo paramter is an output parameter that
 *    signifies which fields in the info record contain valid data.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Parameters:
 *    
 *    inAlias:
 *      A handle to the alias record to get the information from.
 *    
 *    targetName:
 *      The name of the target item.
 *    
 *    volumeName:
 *      The name of the volume the target resides on.
 *    
 *    pathString:
 *      POSIX path to target.
 *    
 *    whichInfo:
 *      An indication of which fields in the info block contain valid
 *      data.
 *    
 *    info:
 *      Returned information about the alias.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in CoreServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function FSCopyAliasInfo( inAlias: AliasHandle; targetName: HFSUniStr255Ptr { can be NULL }; volumeName: HFSUniStr255Ptr { can be NULL }; pathString: CFStringRefPtr { can be NULL }; whichInfo: FSAliasInfoBitmapPtr { can be NULL }; info: FSAliasInfoPtr { can be NULL } ): OSStatus; external name '_FSCopyAliasInfo';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_2, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  GetAliasSize()
 *  
 *  Discussion:
 *    This routine will return the size of the alias record referenced
 *    by the AliasHandle alias.  This will be smaller than the size
 *    returned by GetHandleSize if any custom data has been added (IM
 *    Files 4-13).
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.4
 *  
 *  Parameters:
 *    
 *    alias:
 *      A handle to the alias record to get the information from.
 *  
 *  Result:
 *    The size of the private section of the alias record.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in CoreServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function GetAliasSize( alias: AliasHandle ): Size; external name '_GetAliasSize';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_4, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  GetAliasUserType()
 *  
 *  Discussion:
 *    This routine will return the usertype associated with the alias
 *    record referenced by the AliasHandle alias.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.4
 *  
 *  Parameters:
 *    
 *    alias:
 *      A handle to the alias record to get the userType from.
 *  
 *  Result:
 *    The userType associated with the alias as an OSType
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in CoreServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
function GetAliasUserType( alias: AliasHandle ): OSType; external name '_GetAliasUserType';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_4, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  SetAliasUserType()
 *  
 *  Discussion:
 *    This routine will set the userType associated with an alias
 *    record.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.4
 *  
 *  Parameters:
 *    
 *    alias:
 *      A handle to the alias record to set the userType for.
 *    
 *    userType:
 *      The OSType to set the userType to.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in CoreServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.4 and later
 *    Non-Carbon CFM:   not available
 }
procedure SetAliasUserType( alias: AliasHandle; userType: OSType ); external name '_SetAliasUserType';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_4, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  GetAliasSizeFromPtr()
 *  
 *  Discussion:
 *    This routine will return the size of the alias record referenced
 *    by a pointer to the AliasRecord.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.4
 *  
 *  Parameters:
 *    
 *    alias:
 *      A pointer to the alias record to get the information from.
 *  
 *  Result:
 *    The size of the private section of the alias record.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in CoreServices.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetAliasSizeFromPtr( const (*var*) alias: AliasRecord ): Size; external name '_GetAliasSizeFromPtr';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_4, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  GetAliasUserTypeFromPtr()
 *  
 *  Discussion:
 *    This routine will return the usertype associated withthe alias
 *    record pointed to by alias.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.4
 *  
 *  Parameters:
 *    
 *    alias:
 *      A pointer to the alias record to get the userType from.
 *  
 *  Result:
 *    The userType associated with the alias as an OSType
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in CoreServices.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetAliasUserTypeFromPtr( const (*var*) alias: AliasRecord ): OSType; external name '_GetAliasUserTypeFromPtr';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_4, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  SetAliasUserTypeWithPtr()
 *  
 *  Discussion:
 *    This routine will set the userType associated with an alias
 *    record.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.4
 *  
 *  Parameters:
 *    
 *    alias:
 *      A pointer to the alias record to set the userType for.
 *    
 *    userType:
 *      The OSType to set the userType to.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in CoreServices.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure SetAliasUserTypeWithPtr( alias: AliasPtr; userType: OSType ); external name '_SetAliasUserTypeWithPtr';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_4, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{ Functions beyond this point are deprecated}

{$ifc not TARGET_CPU_64}
{
 *  FSMatchAlias()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use FSMatchAliasBulk instead
 *  
 *  Summary:
 *    Given an alias handle and fromFile, match the alias and return
 *    FSRefs to the aliased file(s) and needsUpdate flag
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in CoreServices.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function FSMatchAlias( {const} fromFile: FSRefPtr { can be NULL }; rulesMask: UNSIGNEDLONG; inAlias: AliasHandle; var aliasCount: SInt16; var aliasList: FSRef; var needsUpdate: Boolean; aliasFilter: AliasFilterUPP; yourDataPtr: UnivPtr ): OSErr; external name '_FSMatchAlias';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_2, __MAC_10_5, __IPHONE_NA, __IPHONE_NA) *)


{
 *  FSMatchAliasNoUI()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use FSMatchAliasBulk with the kARMNoUI flag instead
 *  
 *  Summary:
 *    variation on FSMatchAlias that does not prompt user with a dialog
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in CoreServices.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.2 and later
 *    Non-Carbon CFM:   not available
 }
function FSMatchAliasNoUI( {const} fromFile: FSRefPtr { can be NULL }; rulesMask: UNSIGNEDLONG; inAlias: AliasHandle; var aliasCount: SInt16; var aliasList: FSRef; var needsUpdate: Boolean; aliasFilter: AliasFilterUPP; yourDataPtr: UnivPtr ): OSErr; external name '_FSMatchAliasNoUI';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_2, __MAC_10_5, __IPHONE_NA, __IPHONE_NA) *)


{
 *  NewAlias()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use FSNewAlias
 *  
 *  Summary:
 *    create a new alias between fromFile and target, returns alias
 *    record handle
 *  
 *  Discussion:
 *    Create an alias betwen fromFile and target, and return it in an
 *    AliasHandle. This function is deprecated in Mac OS X 10.4;
 *    instead, you should use FSNewAliasUnicode() because NewAlias()
 *    has problems creating aliases to certain files, including those
 *    which are impossible to represent in an FSSpec.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function NewAlias( {const} fromFile: FSSpecPtr { can be NULL }; const (*var*) target: FSSpec; var alias: AliasHandle ): OSErr; external name '_NewAlias';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_4, __IPHONE_NA, __IPHONE_NA) *)


{
 *  NewAliasMinimal()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use FSNewAliasMinimalUnicode
 *  
 *  Summary:
 *    create a minimal new alias for a target and return alias record
 *    handle
 *  
 *  Discussion:
 *    Create a minimal alias for a target, and return it in an
 *    AliasHandle. This function is deprecated in Mac OS X 10.4;
 *    instead, you should use FSNewAliasMinimalUnicode() because
 *    NewAliasMinimalAlias() has problems creating aliases to certain
 *    files, including those which are impossible to represent in an
 *    FSSpec.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function NewAliasMinimal( const (*var*) target: FSSpec; var alias: AliasHandle ): OSErr; external name '_NewAliasMinimal';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_4, __IPHONE_NA, __IPHONE_NA) *)


{
 *  NewAliasMinimalFromFullPath()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use FSNewAliasMinimalUnicode
 *  
 *  Summary:
 *    create a minimal new alias from a target fullpath (optional zone
 *    and server name) and return alias record handle
 *  
 *  Discussion:
 *    Create a minimal alias for a target fullpath, and return it in an
 *    AliasHandle. This function is deprecated in Mac OS X 10.4;
 *    instead, you should use FSNewAliasMinimalUnicode() because
 *    NewAliasMinimalFromFullPath() has problems creating aliases to
 *    certain files, including those which are impossible to represent
 *    in an FSSpec.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function NewAliasMinimalFromFullPath( fullPathLength: SInt16; fullPath: {const} UnivPtr; const (*var*) zoneName: Str32; const (*var*) serverName: Str31; var alias: AliasHandle ): OSErr; external name '_NewAliasMinimalFromFullPath';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_4, __IPHONE_NA, __IPHONE_NA) *)


{
 *  ResolveAlias()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use FSResolveAlias() or FSResolveAliasWithMountFlags() instead.
 *  
 *  Summary:
 *    given an alias handle and fromFile, resolve the alias, update the
 *    alias record and return aliased filename and wasChanged flag.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function ResolveAlias( {const} fromFile: FSSpecPtr { can be NULL }; alias: AliasHandle; var target: FSSpec; var wasChanged: Boolean ): OSErr; external name '_ResolveAlias';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_4, __IPHONE_NA, __IPHONE_NA) *)


{
 *  GetAliasInfo()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use FSCopyAliasInfo instead.
 *  
 *  Summary:
 *    This call does not work on all aliases. Given an alias handle and
 *    an index specifying requested alias information type, return the
 *    information from alias record as a string. An empty string is
 *    returned when the index is greater than the number of levels
 *    between the target and root.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.0
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.3
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function GetAliasInfo( alias: AliasHandle; itemIndex: AliasInfoType; var theString: Str63 ): OSErr; external name '_GetAliasInfo';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_3, __IPHONE_NA, __IPHONE_NA) *)


{
 *  IsAliasFile()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use FSIsAliasFile() instead.
 *  
 *  Summary:
 *    Return true if the file pointed to by fileFSSpec is an alias file.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.0
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function IsAliasFile( const (*var*) fileFSSpec: FSSpec; var aliasFileFlag: Boolean; var folderFlag: Boolean ): OSErr; external name '_IsAliasFile';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_4, __IPHONE_NA, __IPHONE_NA) *)


{
 *  ResolveAliasWithMountFlags()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use FSResolveAliasWithMountFlags() instead.
 *  
 *  Summary:
 *    Given an AliasHandle, return target file spec. It resolves the
 *    entire alias chain or one step of the chain.  It returns info
 *    about whether the target is a folder or file; and whether the
 *    input file spec was an alias or not.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function ResolveAliasWithMountFlags( {const} fromFile: FSSpecPtr { can be NULL }; alias: AliasHandle; var target: FSSpec; var wasChanged: Boolean; mountFlags: UNSIGNEDLONG ): OSErr; external name '_ResolveAliasWithMountFlags';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_4, __IPHONE_NA, __IPHONE_NA) *)


{
 *  ResolveAliasFile()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use FSResolveAliasFile
 *  
 *  Summary:
 *    Given a file spec, return target file spec if input file spec is
 *    an alias. It resolves the entire alias chain or one step of the
 *    chain.  It returns info about whether the target is a folder or
 *    file; and whether the input file spec was an alias or not.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function ResolveAliasFile( var theSpec: FSSpec; resolveAliasChains: Boolean; var targetIsFolder: Boolean; var wasAliased: Boolean ): OSErr; external name '_ResolveAliasFile';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_4, __IPHONE_NA, __IPHONE_NA) *)


{ Deprecated: Use FSResolveAliasFileWithMountFlags instead}
{
 *  ResolveAliasFileWithMountFlags()   *** DEPRECATED ***
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function ResolveAliasFileWithMountFlags( var theSpec: FSSpec; resolveAliasChains: Boolean; var targetIsFolder: Boolean; var wasAliased: Boolean; mountFlags: UNSIGNEDLONG ): OSErr; external name '_ResolveAliasFileWithMountFlags';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_5, __IPHONE_NA, __IPHONE_NA) *)


{ Deprecated:  Use FSFollowFinderAlias instead}
{
 *  FollowFinderAlias()   *** DEPRECATED ***
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function FollowFinderAlias( {const} fromFile: FSSpecPtr { can be NULL }; alias: AliasHandle; logon: Boolean; var target: FSSpec; var wasChanged: Boolean ): OSErr; external name '_FollowFinderAlias';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_5, __IPHONE_NA, __IPHONE_NA) *)


{ 
   Low Level Routines 
}
{
 *  UpdateAlias()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    UseFSUpdateAlias
 *  
 *  Summary:
 *    given a fromFile-target pair and an alias handle, update the
 *    alias record pointed to by alias handle to represent target as
 *    the new alias.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function UpdateAlias( {const} fromFile: FSSpecPtr { can be NULL }; const (*var*) target: FSSpec; alias: AliasHandle; var wasChanged: Boolean ): OSErr; external name '_UpdateAlias';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_4, __IPHONE_NA, __IPHONE_NA) *)


{
 *  MatchAlias()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use FSMatchAliasBulk instead
 *  
 *  Summary:
 *    Given an alias handle and fromFile, match the alias and return
 *    FSSpecs to the aliased file(s) and needsUpdate flag
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function MatchAlias( {const} fromFile: FSSpecPtr { can be NULL }; rulesMask: UNSIGNEDLONG; alias: AliasHandle; var aliasCount: SInt16; aliasList: FSSpecArrayPtr; var needsUpdate: Boolean; aliasFilter: AliasFilterUPP; yourDataPtr: UnivPtr ): OSErr; external name '_MatchAlias';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_4, __IPHONE_NA, __IPHONE_NA) *)


{
 *  ResolveAliasFileWithMountFlagsNoUI()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use FSResolveAliasFileWithMountFlags passing in the
 *    kResolveAliasFileNoUI flag
 *  
 *  Summary:
 *    variation on ResolveAliasFile that does not prompt user with a
 *    dialog
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function ResolveAliasFileWithMountFlagsNoUI( var theSpec: FSSpec; resolveAliasChains: Boolean; var targetIsFolder: Boolean; var wasAliased: Boolean; mountFlags: UNSIGNEDLONG ): OSErr; external name '_ResolveAliasFileWithMountFlagsNoUI';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_4, __IPHONE_NA, __IPHONE_NA) *)


{
 *  MatchAliasNoUI()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use FSMatchAliasBulk with the kARMNoUI flag instead
 *  
 *  Summary:
 *    variation on MatchAlias that does not prompt user with a dialog
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.3
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function MatchAliasNoUI( {const} fromFile: FSSpecPtr { can be NULL }; rulesMask: UNSIGNEDLONG; alias: AliasHandle; var aliasCount: SInt16; aliasList: FSSpecArrayPtr; var needsUpdate: Boolean; aliasFilter: AliasFilterUPP; yourDataPtr: UnivPtr ): OSErr; external name '_MatchAliasNoUI';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_5, __IPHONE_NA, __IPHONE_NA) *)



{$endc} {not TARGET_CPU_64}

{$endc} {TARGET_OS_MAC}

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
