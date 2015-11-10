{
     File:       IconsCore.h
 
     Contains:   Icon Utilities and Icon Services Interfaces.
 
     Copyright:  Copyright 2003-2009 by Apple Inc., all rights reserved.
 
     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:
 
                     http://www.freepascal.org/bugs.html
}
{       Initial Pascal Translation:  Gorazd Krosl, <gorazd_1957@yahoo.ca>, October 2009 }
{       Updated Pascal Translation:  Jonas Maebe, <jonas@freepascal.org>, September 2012 }
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

unit IconsCore;
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
uses MacTypes,CFBase,CFURL,IconStorage,Components,Files;
{$endc} {not MACOSALLINCLUDE}


{$ifc TARGET_OS_MAC}

{$ALIGN POWER}


{ The following are icons for which there are both icon suites and SICNs. }
{ Avoid using icon resources if possible. Use IconServices instead. }
const
	kGenericDocumentIconResource = -4000;
	kGenericStationeryIconResource = -3985;
	kGenericEditionFileIconResource = -3989;
	kGenericApplicationIconResource = -3996;
	kGenericDeskAccessoryIconResource = -3991;
	kGenericFolderIconResource = -3999;
	kPrivateFolderIconResource = -3994;
	kFloppyIconResource = -3998;
	kTrashIconResource = -3993;
	kGenericRAMDiskIconResource = -3988;
	kGenericCDROMIconResource = -3987;

{ The following are icons for which there are SICNs only. }
{ Avoid using icon resources if possible. Use IconServices instead. }
const
	kDesktopIconResource = -3992;
	kOpenFolderIconResource = -3997;
	kGenericHardDiskIconResource = -3995;
	kGenericFileServerIconResource = -3972;
	kGenericSuitcaseIconResource = -3970;
	kGenericMoverObjectIconResource = -3969;

{ The following are icons for which there are icon suites only. }
{ Avoid using icon resources if possible. Use IconServices instead. }
const
	kGenericPreferencesIconResource = -3971;
	kGenericQueryDocumentIconResource = -16506;
	kGenericExtensionIconResource = -16415;
	kSystemFolderIconResource = -3983;
	kHelpIconResource = -20271;
	kAppleMenuFolderIconResource = -3982;

{ Obsolete. Use named constants defined above. }
const
	genericDocumentIconResource = kGenericDocumentIconResource;
	genericStationeryIconResource = kGenericStationeryIconResource;
	genericEditionFileIconResource = kGenericEditionFileIconResource;
	genericApplicationIconResource = kGenericApplicationIconResource;
	genericDeskAccessoryIconResource = kGenericDeskAccessoryIconResource;
	genericFolderIconResource = kGenericFolderIconResource;
	privateFolderIconResource = kPrivateFolderIconResource;
	floppyIconResource = kFloppyIconResource;
	trashIconResource = kTrashIconResource;
	genericRAMDiskIconResource = kGenericRAMDiskIconResource;
	genericCDROMIconResource = kGenericCDROMIconResource;
	desktopIconResource = kDesktopIconResource;
	openFolderIconResource = kOpenFolderIconResource;
	genericHardDiskIconResource = kGenericHardDiskIconResource;
	genericFileServerIconResource = kGenericFileServerIconResource;
	genericSuitcaseIconResource = kGenericSuitcaseIconResource;
	genericMoverObjectIconResource = kGenericMoverObjectIconResource;
	genericPreferencesIconResource = kGenericPreferencesIconResource;
	genericQueryDocumentIconResource = kGenericQueryDocumentIconResource;
	genericExtensionIconResource = kGenericExtensionIconResource;
	systemFolderIconResource = kSystemFolderIconResource;
	appleMenuFolderIconResource = kAppleMenuFolderIconResource;

{ Avoid using icon resources if possible. Use IconServices instead. }
const
	kStartupFolderIconResource = -3981;
	kOwnedFolderIconResource = -3980;
	kDropFolderIconResource = -3979;
	kSharedFolderIconResource = -3978;
	kMountedFolderIconResource = -3977;
	kControlPanelFolderIconResource = -3976;
	kPrintMonitorFolderIconResource = -3975;
	kPreferencesFolderIconResource = -3974;
	kExtensionsFolderIconResource = -3973;
	kFontsFolderIconResource = -3968;
	kFullTrashIconResource = -3984;

{ Obsolete. Use named constants defined above. }
const
	startupFolderIconResource = kStartupFolderIconResource;
	ownedFolderIconResource = kOwnedFolderIconResource;
	dropFolderIconResource = kDropFolderIconResource;
	sharedFolderIconResource = kSharedFolderIconResource;
	mountedFolderIconResource = kMountedFolderIconResource;
	controlPanelFolderIconResource = kControlPanelFolderIconResource;
	printMonitorFolderIconResource = kPrintMonitorFolderIconResource;
	preferencesFolderIconResource = kPreferencesFolderIconResource;
	extensionsFolderIconResource = kExtensionsFolderIconResource;
	fontsFolderIconResource = kFontsFolderIconResource;
	fullTrashIconResource = kFullTrashIconResource;

{ IconRefs are 32-bit values identifying cached icon data. IconRef 0 is invalid.}
type
	IconRef = ^OpaqueIconRef; { an opaque type }
	OpaqueIconRef = record end;
	IconRef_fix = IconRef;	{ used as a type identifiers in records containing iconRef field }
	IconRefPtr = ^IconRef;
{
   IconServices is an efficient mechanism to share icon data amongst multiple 
   clients. It avoids duplication of data; it provides efficient caching, 
   releasing memory when the icon data is no longer needed; it can provide
   the appropriate icon for any filesystem object; it can provide commonly 
   used icons (caution, note, help...); it is Appearance-savvy: the icons
   are switched when appropriate.
   IconServices refer to cached icon data using IconRef, a 32-bit opaque
   value. IconRefs are reference counted. When there are no more "owners" 
   of an IconRef, the memory used by the icon bitmap is disposed of.
   Two files of same type and creator with no custom icon will have the same IconRef.
   Files with custom icons will have their own IconRef.
}
{
   Use the special creator kSystemIconsCreator to get "standard" icons 
   that are not associated with a file, such as the help icon.
   Note that all lowercase creators are reserved by Apple.
}
const
	kSystemIconsCreator = FourCharCode('macs');


{
   Type of the predefined/generic icons. For example, the call:
      err = GetIconRef(kOnSystemDisk, kSystemIconsCreator, kHelpIcon, &iconRef);
   will retun in iconRef the IconRef for the standard help icon.
}

{ Generic Finder icons }
const
	kClipboardIcon = FourCharCode('CLIP');
	kClippingUnknownTypeIcon = FourCharCode('clpu');
	kClippingPictureTypeIcon = FourCharCode('clpp');
	kClippingTextTypeIcon = FourCharCode('clpt');
	kClippingSoundTypeIcon = FourCharCode('clps');
	kDesktopIcon = FourCharCode('desk');
	kFinderIcon = FourCharCode('FNDR');
	kComputerIcon = FourCharCode('root');
	kFontSuitcaseIcon = FourCharCode('FFIL');
	kFullTrashIcon = FourCharCode('ftrh');
	kGenericApplicationIcon = FourCharCode('APPL');
	kGenericCDROMIcon = FourCharCode('cddr');
	kGenericControlPanelIcon = FourCharCode('APPC');
	kGenericControlStripModuleIcon = FourCharCode('sdev');
	kGenericComponentIcon = FourCharCode('thng');
	kGenericDeskAccessoryIcon = FourCharCode('APPD');
	kGenericDocumentIcon = FourCharCode('docu');
	kGenericEditionFileIcon = FourCharCode('edtf');
	kGenericExtensionIcon = FourCharCode('INIT');
	kGenericFileServerIcon = FourCharCode('srvr');
	kGenericFontIcon = FourCharCode('ffil');
	kGenericFontScalerIcon = FourCharCode('sclr');
	kGenericFloppyIcon = FourCharCode('flpy');
	kGenericHardDiskIcon = FourCharCode('hdsk');
	kGenericIDiskIcon = FourCharCode('idsk');
	kGenericRemovableMediaIcon = FourCharCode('rmov');
	kGenericMoverObjectIcon = FourCharCode('movr');
	kGenericPCCardIcon = FourCharCode('pcmc');
	kGenericPreferencesIcon = FourCharCode('pref');
	kGenericQueryDocumentIcon = FourCharCode('qery');
	kGenericRAMDiskIcon = FourCharCode('ramd');
	kGenericSharedLibaryIcon = FourCharCode('shlb');
	kGenericStationeryIcon = FourCharCode('sdoc');
	kGenericSuitcaseIcon = FourCharCode('suit');
	kGenericURLIcon = FourCharCode('gurl');
	kGenericWORMIcon = FourCharCode('worm');
	kInternationalResourcesIcon = FourCharCode('ifil');
	kKeyboardLayoutIcon = FourCharCode('kfil');
	kSoundFileIcon = FourCharCode('sfil');
	kSystemSuitcaseIcon = FourCharCode('zsys');
	kTrashIcon = FourCharCode('trsh');
	kTrueTypeFontIcon = FourCharCode('tfil');
	kTrueTypeFlatFontIcon = FourCharCode('sfnt');
	kTrueTypeMultiFlatFontIcon = FourCharCode('ttcf');
	kUserIDiskIcon = FourCharCode('udsk');
	kUnknownFSObjectIcon = FourCharCode('unfs');
	kInternationResourcesIcon = kInternationalResourcesIcon; { old name}

{ Internet locations }
const
	kInternetLocationHTTPIcon = FourCharCode('ilht');
	kInternetLocationFTPIcon = FourCharCode('ilft');
	kInternetLocationAppleShareIcon = FourCharCode('ilaf');
	kInternetLocationAppleTalkZoneIcon = FourCharCode('ilat');
	kInternetLocationFileIcon = FourCharCode('ilfi');
	kInternetLocationMailIcon = FourCharCode('ilma');
	kInternetLocationNewsIcon = FourCharCode('ilnw');
	kInternetLocationNSLNeighborhoodIcon = FourCharCode('ilns');
	kInternetLocationGenericIcon = FourCharCode('ilge');

{ Folders }
const
	kGenericFolderIcon = FourCharCode('fldr');
	kDropFolderIcon = FourCharCode('dbox');
	kMountedFolderIcon = FourCharCode('mntd');
	kOpenFolderIcon = FourCharCode('ofld');
	kOwnedFolderIcon = FourCharCode('ownd');
	kPrivateFolderIcon = FourCharCode('prvf');
	kSharedFolderIcon = FourCharCode('shfl');

{ Sharing Privileges icons }
const
	kSharingPrivsNotApplicableIcon = FourCharCode('shna');
	kSharingPrivsReadOnlyIcon = FourCharCode('shro');
	kSharingPrivsReadWriteIcon = FourCharCode('shrw');
	kSharingPrivsUnknownIcon = FourCharCode('shuk');
	kSharingPrivsWritableIcon = FourCharCode('writ');


{ Users and Groups icons }
const
	kUserFolderIcon = FourCharCode('ufld');
	kWorkgroupFolderIcon = FourCharCode('wfld');
	kGuestUserIcon = FourCharCode('gusr');
	kUserIcon = FourCharCode('user');
	kOwnerIcon = FourCharCode('susr');
	kGroupIcon = FourCharCode('grup');

{ Special folders }
const
	kAppearanceFolderIcon = FourCharCode('appr');
	kAppleExtrasFolderIcon = $616578C4; {'aex�'}
	kAppleMenuFolderIcon = FourCharCode('amnu');
	kApplicationsFolderIcon = FourCharCode('apps');
	kApplicationSupportFolderIcon = FourCharCode('asup');
	kAssistantsFolderIcon = $617374C4; {'ast�'}
	kColorSyncFolderIcon = FourCharCode('prof');
	kContextualMenuItemsFolderIcon = FourCharCode('cmnu');
	kControlPanelDisabledFolderIcon = FourCharCode('ctrD');
	kControlPanelFolderIcon = FourCharCode('ctrl');
	kControlStripModulesFolderIcon = $736476C4; {'sdv�'}
	kDocumentsFolderIcon = FourCharCode('docs');
	kExtensionsDisabledFolderIcon = FourCharCode('extD');
	kExtensionsFolderIcon = FourCharCode('extn');
	kFavoritesFolderIcon = FourCharCode('favs');
	kFontsFolderIcon = FourCharCode('font');
	kHelpFolderIcon = $C4686C70; {'�hlp' }
	kInternetFolderIcon = $696E74C4; {'int�'}
	kInternetPlugInFolderIcon = $C46E6574; {'�net' }
	kInternetSearchSitesFolderIcon = FourCharCode('issf');
	kLocalesFolderIcon = $C46C6F63; {'�loc' }
	kMacOSReadMeFolderIcon = $6D6F72C4; {'mor�'}
	kPublicFolderIcon = FourCharCode('pubf');
	kPreferencesFolderIcon = $707266C4; {'prf�'}
	kPrinterDescriptionFolderIcon = FourCharCode('ppdf');
	kPrinterDriverFolderIcon = $C4707264; {'�prd' }
	kPrintMonitorFolderIcon = FourCharCode('prnt');
	kRecentApplicationsFolderIcon = FourCharCode('rapp');
	kRecentDocumentsFolderIcon = FourCharCode('rdoc');
	kRecentServersFolderIcon = FourCharCode('rsrv');
	kScriptingAdditionsFolderIcon = $C4736372; {'�scr' }
	kSharedLibrariesFolderIcon = $C46C6962; {'�lib' }
	kScriptsFolderIcon = $736372C4; {'scr�'}
	kShutdownItemsDisabledFolderIcon = FourCharCode('shdD');
	kShutdownItemsFolderIcon = FourCharCode('shdf');
	kSpeakableItemsFolder = FourCharCode('spki');
	kStartupItemsDisabledFolderIcon = FourCharCode('strD');
	kStartupItemsFolderIcon = FourCharCode('strt');
	kSystemExtensionDisabledFolderIcon = FourCharCode('macD');
	kSystemFolderIcon = FourCharCode('macs');
	kTextEncodingsFolderIcon = $C4746578; {'�tex' }
	kUsersFolderIcon = $757372C4; {'usr�'}
	kUtilitiesFolderIcon = $757469C4; {'uti�'}
	kVoicesFolderIcon = FourCharCode('fvoc');

{ Badges }
const
	kAppleScriptBadgeIcon = FourCharCode('scrp');
	kLockedBadgeIcon = FourCharCode('lbdg');
	kMountedBadgeIcon = FourCharCode('mbdg');
	kSharedBadgeIcon = FourCharCode('sbdg');
	kAliasBadgeIcon = FourCharCode('abdg');
	kAlertCautionBadgeIcon = FourCharCode('cbdg');

{ Alert icons }
const
	kAlertNoteIcon = FourCharCode('note');
	kAlertCautionIcon = FourCharCode('caut');
	kAlertStopIcon = FourCharCode('stop');

{ Networking icons }
const
	kAppleTalkIcon = FourCharCode('atlk');
	kAppleTalkZoneIcon = FourCharCode('atzn');
	kAFPServerIcon = FourCharCode('afps');
	kFTPServerIcon = FourCharCode('ftps');
	kHTTPServerIcon = FourCharCode('htps');
	kGenericNetworkIcon = FourCharCode('gnet');
	kIPFileServerIcon = FourCharCode('isrv');

{ Toolbar icons }
const
	kToolbarCustomizeIcon = FourCharCode('tcus');
	kToolbarDeleteIcon = FourCharCode('tdel');
	kToolbarFavoritesIcon = FourCharCode('tfav');
	kToolbarHomeIcon = FourCharCode('thom');
	kToolbarAdvancedIcon = FourCharCode('tbav');
	kToolbarInfoIcon = FourCharCode('tbin');
	kToolbarLabelsIcon = FourCharCode('tblb');
	kToolbarApplicationsFolderIcon = FourCharCode('tAps');
	kToolbarDocumentsFolderIcon = FourCharCode('tDoc');
	kToolbarMovieFolderIcon = FourCharCode('tMov');
	kToolbarMusicFolderIcon = FourCharCode('tMus');
	kToolbarPicturesFolderIcon = FourCharCode('tPic');
	kToolbarPublicFolderIcon = FourCharCode('tPub');
	kToolbarDesktopFolderIcon = FourCharCode('tDsk');
	kToolbarDownloadsFolderIcon = FourCharCode('tDwn');
	kToolbarLibraryFolderIcon = FourCharCode('tLib');
	kToolbarUtilitiesFolderIcon = FourCharCode('tUtl');
	kToolbarSitesFolderIcon = FourCharCode('tSts');

{ Other icons }
const
	kAppleLogoIcon = FourCharCode('capl');
	kAppleMenuIcon = FourCharCode('sapl');
	kBackwardArrowIcon = FourCharCode('baro');
	kFavoriteItemsIcon = FourCharCode('favr');
	kForwardArrowIcon = FourCharCode('faro');
	kGridIcon = FourCharCode('grid');
	kHelpIcon = FourCharCode('help');
	kKeepArrangedIcon = FourCharCode('arng');
	kLockedIcon = FourCharCode('lock');
	kNoFilesIcon = FourCharCode('nfil');
	kNoFolderIcon = FourCharCode('nfld');
	kNoWriteIcon = FourCharCode('nwrt');
	kProtectedApplicationFolderIcon = FourCharCode('papp');
	kProtectedSystemFolderIcon = FourCharCode('psys');
	kRecentItemsIcon = FourCharCode('rcnt');
	kShortcutIcon = FourCharCode('shrt');
	kSortAscendingIcon = FourCharCode('asnd');
	kSortDescendingIcon = FourCharCode('dsnd');
	kUnlockedIcon = FourCharCode('ulck');
	kConnectToIcon = FourCharCode('cnct');
	kGenericWindowIcon = FourCharCode('gwin');
	kQuestionMarkIcon = FourCharCode('ques');
	kDeleteAliasIcon = FourCharCode('dali');
	kEjectMediaIcon = FourCharCode('ejec');
	kBurningIcon = FourCharCode('burn');
	kRightContainerArrowIcon = FourCharCode('rcar');


{  IconServicesUsageFlags }
type
	IconServicesUsageFlags = UInt32;
const
	kIconServicesNormalUsageFlag = $00000000;
	kIconServicesNoBadgeFlag = $00000001; { available on Panther and later }
	kIconServicesUpdateIfNeededFlag = $00000002; { available on Panther and later }


{
  kIconServicesCatalogInfoMask - Minimal bitmask for use with
    GetIconRefFromFileInfo(). Use this mask with FSGetCatalogInfo
    before calling GetIconRefFromFileInfo(). Please note kFSCatInfoFinderXInfo flag is
    valid only on MacOS X and must be cleared from CatalogInfoMask before
    passing to GetIconRefFromFileInfo while running under MacOS 9 (or error will be returned)
}
const
	kIconServicesCatalogInfoMask = kFSCatInfoNodeID or kFSCatInfoParentDirID or kFSCatInfoVolume or kFSCatInfoNodeFlags or kFSCatInfoFinderInfo or kFSCatInfoFinderXInfo or kFSCatInfoUserAccess or kFSCatInfoPermissions or kFSCatInfoContentMod;


{
  ==============================================================================
   Reference counting
  ==============================================================================
}


{
   GetIconRefOwners
   
   This routine returns the reference count for the IconRef, or number of owners.
   
   A valid IconRef always has at least one owner.
}

{
 *  GetIconRefOwners()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function GetIconRefOwners( theIconRef: IconRef; var owners: UInt16 ): OSErr; external name '_GetIconRefOwners';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{
   AcquireIconRef
   This routine increments the reference count for the IconRef
}

{
 *  AcquireIconRef()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function AcquireIconRef( theIconRef: IconRef ): OSErr; external name '_AcquireIconRef';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{
   ReleaseIconRef
   
   This routine decrements the reference count for the IconRef.
   
   When the reference count reaches 0, all memory allocated for the icon
   is disposed. Any subsequent use of the IconRef is invalid.
}

{
 *  ReleaseIconRef()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function ReleaseIconRef( theIconRef: IconRef ): OSErr; external name '_ReleaseIconRef';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{
  ==============================================================================
   Getting an IconRef
  ==============================================================================
}


{
   GetIconRefFromFile
   
   This routine returns an icon ref for the specified file, folder or volume.
   The label information is provided separately, since two files with the same icon 
   but a different label would share the same iconRef. The label can be used in 
   PlotIconRef() for example.
   
   Use this routine if you have no information about the file system object. If 
   you have already done a GetCatInfo on the file and want to save some I/O, 
   call GetIconRefFromFolder() if you know it's a folder with no custom icon or 
   call GetIconRef() if it's a file with no custom icon.
   This routine increments the reference count of the returned IconRef. Call 
   ReleaseIconRef() when you're done with it.
   This call is deprecated. Please use GetIconRefFromFileInfo() instead.
}

{$ifc not TARGET_CPU_64}
{
 *  GetIconRefFromFile()   *** DEPRECATED ***
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function GetIconRefFromFile( const (*var*) theFile: FSSpec; var theIconRef: IconRef; var theLabel: SInt16 ): OSErr; external name '_GetIconRefFromFile';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_5, __IPHONE_NA, __IPHONE_NA) *)

{$endc}	{ not TARGET_CPU_64 }

{
   GetIconRef
   
   This routine returns an icon ref for an icon in the desktop database or
   for a registered icon.
   The system registers a set of icon such as the help icon with the creator 
   code kSystemIconsCreator. See above for a list of the registered system types.
   The vRefNum is used as a hint on where to look for the icon first. Use 
   kOnSystemDisk if you don't know what to pass.
   This routine increments the reference count of the returned IconRef. Call 
   ReleaseIconRef() when you're done with it.
}

{
 *  GetIconRef()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function GetIconRef( vRefNum: SInt16; creator: OSType; iconType: OSType; var theIconRef: IconRef ): OSErr; external name '_GetIconRef';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{
   GetIconRefFromFolder
   
   This routine returns an icon ref for a folder with no custom icon.
   Use the more generic, but slightly slower, GetIconRefFromFile() if
   you don't already have the necessary info about the file.
   Attributes should be CInfoPBRec.dirInfo.ioFlAttrib for this folder.
   Access privileges should be CInfoPBRec.dirInfo.ioACUser for this folder.
   This routine increments the reference count of the IconRef. Call ReleaseIconRef() 
   when you're done with it.
}

{
 *  GetIconRefFromFolder()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function GetIconRefFromFolder( vRefNum: SInt16; parentFolderID: SInt32; folderID: SInt32; attributes: SInt8; accessPrivileges: SInt8; var theIconRef: IconRef ): OSErr; external name '_GetIconRefFromFolder';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{ GetIconRefFromFileInfo}
{
 *  GetIconRefFromFileInfo()
 *  
 *  Summary:
 *    This routine returns an IconRef for a file with minimal file I/O.
 *  
 *  Discussion:
 *    To minimize file operations, FSGetCatalogInfo should be called
 *    prior to calling this routine. The FSCatalogInfo should
 *    correspond to kIconServicesCatalogInfoMask The name should be
 *    fetched and passed in. If either the name or the correct catalog
 *    info is not passed in, this routine will do file operations for
 *    this information instead.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Parameters:
 *    
 *    inRef:
 *      An FSRef for the target file
 *    
 *    inFileNameLength:
 *      The length of the name of the target file
 *    
 *    inFileName:
 *      The name of the target file
 *    
 *    inWhichInfo:
 *      The mask of file info already acquired.
 *    
 *    inCatalogInfo:
 *      The catalog info already acquired.
 *    
 *    inUsageFlags:
 *      The usage flags for this call (use
 *      kIconServicesNormalUsageFlag).
 *    
 *    outIconRef:
 *      The output IconRef for the routine.
 *    
 *    outLabel:
 *      The output label for the icon/file.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.1 and later in ApplicationServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.1 and later
 *    Non-Carbon CFM:   not available
 }
function GetIconRefFromFileInfo( const (*var*) inRef: FSRef; inFileNameLength: UniCharCount; {const} inFileName: UniCharPtr { can be NULL }; inWhichInfo: FSCatalogInfoBitmap; {const} inCatalogInfo: FSCatalogInfoPtr { can be NULL }; inUsageFlags: IconServicesUsageFlags; var outIconRef: IconRef; outLabel: SInt16Ptr { can be NULL } ): OSStatus; external name '_GetIconRefFromFileInfo';
(* __OSX_AVAILABLE_STARTING(__MAC_10_1, __IPHONE_NA) *)


{ GetIconRefFromTypeInfo}
{
 *  GetIconRefFromTypeInfo()
 *  
 *  Summary:
 *    Create an IconRef for a type information.
 *  
 *  Discussion:
 *    Creates IconRef based on provided type info. Any of the input
 *    parameters can be zero (meaning it is unknown). Returns generic
 *    document icon in case if all parameters are zeroes. Calling the
 *    routine with non zero inCreator and inType and zero inExtension
 *    and inMIMEType is equivalent to GetIconRef(kOnSystemDisk,
 *    inCreator, inType).
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inCreator:
 *      The creator.
 *    
 *    inType:
 *      The type.
 *    
 *    inExtension:
 *      The extension.
 *    
 *    inMIMEType:
 *      The MIME type.
 *    
 *    inUsageFlags:
 *      The usage flags for this call (use
 *      kIconServicesNormalUsageFlag).
 *    
 *    outIconRef:
 *      The output IconRef for the routine.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in ApplicationServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function GetIconRefFromTypeInfo( inCreator: OSType; inType: OSType; inExtension: CFStringRef; inMIMEType: CFStringRef; inUsageFlags: IconServicesUsageFlags; var outIconRef: IconRef ): OSErr; external name '_GetIconRefFromTypeInfo';
(* __OSX_AVAILABLE_STARTING(__MAC_10_3, __IPHONE_NA) *)


{ GetIconRefFromIconFamilyPtr}
{
 *  GetIconRefFromIconFamilyPtr()
 *  
 *  Summary:
 *    Create an IconRef for the IconFamilyPtr.
 *  
 *  Discussion:
 *    This routine creates IconRef for the IconFamilyPtr.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inIconFamilyPtr:
 *      The icon data
 *    
 *    inSize:
 *      The icon data size
 *    
 *    outIconRef:
 *      The output IconRef for the routine.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in ApplicationServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function GetIconRefFromIconFamilyPtr( const (*var*) inIconFamilyPtr: IconFamilyResource; inSize: Size; var outIconRef: IconRef ): OSStatus; external name '_GetIconRefFromIconFamilyPtr';
(* __OSX_AVAILABLE_STARTING(__MAC_10_3, __IPHONE_NA) *)


{ GetIconRefFromComponent}
{
 *  GetIconRefFromComponent()
 *  
 *  Summary:
 *    Create an IconRef for the component.
 *  
 *  Discussion:
 *    Creates IconRef based on componentIconFamily field of component's
 *    'thng' resource.. This routine increments the reference count of
 *    the IconRef. Call ReleaseIconRef() when you're done with it.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.5
 *  
 *  Parameters:
 *    
 *    inComponent:
 *      A component identifier.
 *    
 *    outIconRef:
 *      The output IconRef for the routine.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 and later in ApplicationServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.5 and later
 *    Non-Carbon CFM:   not available
 }
function GetIconRefFromComponent( inComponent: Component; var outIconRef: IconRef ): OSStatus; external name '_GetIconRefFromComponent';
(* __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_NA) *)


{
  ==============================================================================
   Adding and modifying IconRef
  ==============================================================================
}


{
   RegisterIconRefFromIconFamily
   This routine adds a new entry to the IconRef registry. Other clients will be 
   able to access it using the (creator, iconType) pair specified here.
   Lower-case creators are reserved for the system.
   Consider using RegisterIconRefFromResource() if possible, since the data 
   registered using RegisterIconRefFromFamily() cannot be purged.
   The iconFamily data is copied and the caller is reponsible for disposing of it.
   This routine increments the reference count of the IconRef. Call ReleaseIconRef() 
   when you're done with it.
}

{
 *  RegisterIconRefFromIconFamily()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function RegisterIconRefFromIconFamily( creator: OSType; iconType: OSType; iconFamily: IconFamilyHandle; var theIconRef: IconRef ): OSErr; external name '_RegisterIconRefFromIconFamily';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{
   RegisterIconRefFromResource
   
   Registers an IconRef from a resouce file.  
   Lower-case creators are reserved for the system.
   The icon data to be fetched is either classic icon data or an icon family.  
   The 'icns' icon family is searched for before the classic icon data.
   This routine increments the reference count of the IconRef. Call ReleaseIconRef() 
   when you're done with it.
}

{$ifc not TARGET_CPU_64}
{
 *  RegisterIconRefFromResource()   *** DEPRECATED ***
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function RegisterIconRefFromResource( creator: OSType; iconType: OSType; const (*var*) resourceFile: FSSpec; resourceID: SInt16; var theIconRef: IconRef ): OSErr; external name '_RegisterIconRefFromResource';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_5, __IPHONE_NA, __IPHONE_NA) *)

{$endc}	{ not TARGET_CPU_64 }

{ RegisterIconRefFromFSRef}

{
 *  RegisterIconRefFromFSRef()
 *  
 *  Discussion:
 *    This routine registers an IconRef from a ".icns" file and
 *    associates it with a creator/type pair.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Parameters:
 *    
 *    creator:
 *      The creator code for the icns file.
 *    
 *    iconType:
 *      The type code for the icns file
 *    
 *    iconFile:
 *      The FSRef of the icns file.
 *    
 *    theIconRef:
 *      The output IconRef for the routine.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.1 and later in ApplicationServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.1 and later
 *    Non-Carbon CFM:   not available
 }
function RegisterIconRefFromFSRef( creator: OSType; iconType: OSType; const (*var*) iconFile: FSRef; var theIconRef: IconRef ): OSStatus; external name '_RegisterIconRefFromFSRef';
(* __OSX_AVAILABLE_STARTING(__MAC_10_1, __IPHONE_NA) *)


{
   UnregisterIconRef
   
   Removes the specified icon from the icon cache (if there are no users of it).  
   If some clients are using this iconRef, then the IconRef will be removed when the 
   last user calls ReleaseIconRef.
}

{
 *  UnregisterIconRef()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function UnregisterIconRef( creator: OSType; iconType: OSType ): OSErr; external name '_UnregisterIconRef';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{
   UpdateIconRef
   
   Call this routine to force an update of the data for iconRef.
   
   For example after changing an icon in the desktop database or changing the custom 
   icon of a file. Note that after _adding_ a custom icon to file or folder, you 
   need to call GetIconRefFromFile() to get a new IconRef specific to this file. 
   
   This routine does nothing if the IconRef is a registered icon.
}

{
 *  UpdateIconRef()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function UpdateIconRef( theIconRef: IconRef ): OSErr; external name '_UpdateIconRef';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{
   OverrideIconRefFromResource
   
   This routines replaces the bitmaps of the specified IconRef with the ones
   in the specified resource file.
}

{$ifc not TARGET_CPU_64}
{
 *  OverrideIconRefFromResource()   *** DEPRECATED ***
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function OverrideIconRefFromResource( theIconRef: IconRef; const (*var*) resourceFile: FSSpec; resourceID: SInt16 ): OSErr; external name '_OverrideIconRefFromResource';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_5, __IPHONE_NA, __IPHONE_NA) *)

{$endc}	{ not TARGET_CPU_64 }

{
   OverrideIconRef
   
   This routines replaces the bitmaps of the specified IconRef with the ones
   from the new IconRef.
}

{
 *  OverrideIconRef()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function OverrideIconRef( oldIconRef: IconRef; newIconRef: IconRef ): OSErr; external name '_OverrideIconRef';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{
   RemoveIconRefOverride
   This routine remove an override if one was applied to the icon and 
   reverts back to the original bitmap data.
}

{
 *  RemoveIconRefOverride()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function RemoveIconRefOverride( theIconRef: IconRef ): OSErr; external name '_RemoveIconRefOverride';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{
  ==============================================================================
   Creating composite IconRef
  ==============================================================================
}


{
   CompositeIconRef
   
   Superimposes an IconRef on top of another one
}

{
 *  CompositeIconRef()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function CompositeIconRef( backgroundIconRef: IconRef; foregroundIconRef: IconRef; var compositeIconRef: IconRef ): OSErr; external name '_CompositeIconRef';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{
   IsIconRefComposite
   Indicates if a given icon ref is a composite of two other icon refs (and which ones)
   If it isn't a composite, backgroundIconRef and foreGroundIconRef will be 0.
}

{
 *  IsIconRefComposite()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function IsIconRefComposite( compositeIconRef: IconRef; var backgroundIconRef: IconRef; var foregroundIconRef: IconRef ): OSErr; external name '_IsIconRefComposite';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{
  ==============================================================================
   Using IconRef
  ==============================================================================
}

{
   IsValidIconRef
   Return true if the iconRef passed in is a valid icon ref
}

{
 *  IsValidIconRef()
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function IsValidIconRef( theIconRef: IconRef ): Boolean; external name '_IsValidIconRef';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{ IsDataAvailableInIconRef}
{
 *  IsDataAvailableInIconRef()
 *  
 *  Summary:
 *    Check if IconRef has specific data.
 *  
 *  Discussion:
 *    This routine returns true if inIconKind icon data is availabe or
 *    can be created.
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.4
 *  
 *  Parameters:
 *    
 *    inIconKind:
 *      The icon data kind
 *    
 *    inIconRef:
 *      The IconRef to test.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 and later in ApplicationServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.3 and later
 *    Non-Carbon CFM:   not available
 }
function IsDataAvailableInIconRef( inIconKind: OSType; inIconRef: IconRef ): Boolean; external name '_IsDataAvailableInIconRef';
(* __OSX_AVAILABLE_STARTING(__MAC_10_3, __IPHONE_NA) *)


{
  ==============================================================================
   Flushing IconRef data
  ==============================================================================
}


{
   FlushIconRefs
   
   Making this call will dispose of all the data for the specified icons if 
   the data can be reacquired, for example if the data is provided from a resource.
   '****' is a wildcard for all types or all creators.
}

{$ifc not TARGET_CPU_64}
{
 *  FlushIconRefs()   *** DEPRECATED ***
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework [32-bit only] but deprecated in 10.3
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function FlushIconRefs( creator: OSType; iconType: OSType ): OSErr; external name '_FlushIconRefs';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_3, __IPHONE_NA, __IPHONE_NA) *)


{
   FlushIconRefsByVolume
   
   This routine disposes of the data for the icons related to the indicated volume
   if this data can be reacquired, for example if the data is provided from a 
   resource.
}

{
 *  FlushIconRefsByVolume()   *** DEPRECATED ***
 *  
 *  Mac OS X threading:
 *    Thread safe since version 10.2
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework [32-bit only] but deprecated in 10.3
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function FlushIconRefsByVolume( vRefNum: SInt16 ): OSErr; external name '_FlushIconRefsByVolume';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_3, __IPHONE_NA, __IPHONE_NA) *)

{$endc}	{ not TARGET_CPU_64 }

{
  ==============================================================================
   Controling custom icons
  ==============================================================================
}


{
   SetCustomIconsEnabled
   
   Enable or disable custom icons on the specified volume.
}


{
 *  SetCustomIconsEnabled()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function SetCustomIconsEnabled( vRefNum: SInt16; enableCustomIcons: Boolean ): OSErr; external name '_SetCustomIconsEnabled';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{
   GetCustomIconsEnabled
   
   Return true if custom icons are enabled on the specified volume, false otherwise.
}

{
 *  GetCustomIconsEnabled()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 8.5 and later
 }
function GetCustomIconsEnabled( vRefNum: SInt16; var customIconsEnabled: Boolean ): OSErr; external name '_GetCustomIconsEnabled';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_NA) *)


{
  ==============================================================================
   Icon files (.icns files)
  ==============================================================================
}


{
   RegisterIconRefFromIconFile
   This routine adds a new entry to the IconRef registry. Other clients will be 
   able to access it using the (creator, iconType) pair specified here.
   Lower-case creators are reserved for the system.
   If the creator is kSystemIconsCreator and the iconType is 0, a new IconRef
   is always returned. Otherwise, if the creator and type have already been
   registered, the previously registered IconRef is returned.
   This routine increments the reference count of the IconRef. Call ReleaseIconRef() 
   when you're done with it.
}

{$ifc not TARGET_CPU_64}
{
 *  RegisterIconRefFromIconFile()   *** DEPRECATED ***
 *  
 *  Mac OS X threading:
 *    Thread safe since version Jagua
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 9.0 and later
 }
function RegisterIconRefFromIconFile( creator: OSType; iconType: OSType; const (*var*) iconFile: FSSpec; var theIconRef: IconRef ): OSErr; external name '_RegisterIconRefFromIconFile';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_5, __IPHONE_NA, __IPHONE_NA) *)


{
   ReadIconFile
   Read the specified icon file into the icon family handle.
   The caller is responsible for disposing the iconFamily
}

{
 *  ReadIconFile()   *** DEPRECATED ***
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 9.0 and later
 }
function ReadIconFile( const (*var*) iconFile: FSSpec; var iconFamily: IconFamilyHandle ): OSErr; external name '_ReadIconFile';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_5, __IPHONE_NA, __IPHONE_NA) *)


{
   WriteIconFile
   Write the iconFamily handle to the specified file
}

{
 *  WriteIconFile()   *** DEPRECATED ***
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in ApplicationServices.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in IconServicesLib 9.0 and later
 }
function WriteIconFile( iconFamily: IconFamilyHandle; const (*var*) iconFile: FSSpec ): OSErr; external name '_WriteIconFile';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_5, __IPHONE_NA, __IPHONE_NA) *)

{$endc}	{ not TARGET_CPU_64 }

{ ReadIconFromFSRef}

{
 *  ReadIconFromFSRef()
 *  
 *  Discussion:
 *    This routine reads an icon (icns) file into memory.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    ref:
 *      The FSRef for the icon file.
 *    
 *    iconFamily:
 *      The handle for the icon family.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.1 and later in ApplicationServices.framework
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.1 and later
 *    Non-Carbon CFM:   not available
 }
function ReadIconFromFSRef( const (*var*) ref: FSRef; var iconFamily: IconFamilyHandle ): OSStatus; external name '_ReadIconFromFSRef';
(* __OSX_AVAILABLE_STARTING(__MAC_10_1, __IPHONE_NA) *)

{$endc} {TARGET_OS_MAC}
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
