{
     File:       QuickTime/QuickTimeComponents.h
 
     Contains:   QuickTime Interfaces.
 
     Version:    QuickTime 7.7.1
 
     Copyright:  � 1990-2012 by Apple Inc., all rights reserved
 
     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:
 
                     http://www.freepascal.org/bugs.html
 
}
{  Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
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

unit QuickTimeComponents;
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
uses MacTypes,Aliases,Components,Dialogs,Events,Files,Menus,Video,ImageCompression,Movies,QuickdrawTypes,QDOffscreen,QuickTimeMusic,CFBase,CoreAudioTypes;
{$endc} {not MACOSALLINCLUDE}


{$ifc TARGET_OS_MAC}

{$ALIGN MAC68K}

{ QuickTime is not available to 64-bit clients }

{$ifc not TARGET_CPU_64}

const
	clockComponentType = FourCharCode('clok');
	systemTickClock = FourCharCode('tick'); { subtype: 60ths since boot   }
	systemSecondClock = FourCharCode('seco'); { subtype: seconds since 1904       }
	systemMillisecondClock = FourCharCode('mill'); { subtype: 1000ths since boot       }
	systemMicrosecondClock = FourCharCode('micr'); { subtype: 1000000ths since boot }

const
	kClockRateIsLinear = 1;
	kClockImplementsCallBacks = 2;
	kClockCanHandleIntermittentSound = 4;  { sound clocks only }

{* These are Clock procedures *}
{
 *  ClockGetTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ClockGetTime( aClock: ComponentInstance; var out: TimeRecord ): ComponentResult; external name '_ClockGetTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClockNewCallBack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ClockNewCallBack( aClock: ComponentInstance; tb: TimeBase; callBackType: SInt16 ): QTCallBack; external name '_ClockNewCallBack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClockDisposeCallBack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ClockDisposeCallBack( aClock: ComponentInstance; cb: QTCallBack ): ComponentResult; external name '_ClockDisposeCallBack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClockCallMeWhen()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ClockCallMeWhen( aClock: ComponentInstance; cb: QTCallBack; param1: SIGNEDLONG; param2: SIGNEDLONG; param3: SIGNEDLONG ): ComponentResult; external name '_ClockCallMeWhen';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClockCancelCallBack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ClockCancelCallBack( aClock: ComponentInstance; cb: QTCallBack ): ComponentResult; external name '_ClockCancelCallBack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClockRateChanged()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ClockRateChanged( aClock: ComponentInstance; cb: QTCallBack ): ComponentResult; external name '_ClockRateChanged';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClockTimeChanged()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ClockTimeChanged( aClock: ComponentInstance; cb: QTCallBack ): ComponentResult; external name '_ClockTimeChanged';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClockSetTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ClockSetTimeBase( aClock: ComponentInstance; tb: TimeBase ): ComponentResult; external name '_ClockSetTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClockStartStopChanged()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ClockStartStopChanged( aClock: ComponentInstance; cb: QTCallBack; startChanged: Boolean; stopChanged: Boolean ): ComponentResult; external name '_ClockStartStopChanged';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClockGetRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ClockGetRate( aClock: ComponentInstance; var rate: Fixed ): ComponentResult; external name '_ClockGetRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClockGetTimesForRateChange()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function ClockGetTimesForRateChange( aClock: ComponentInstance; fromRate: Fixed; toRate: Fixed; var currentTime: TimeRecord; var preferredTime: TimeRecord; var safeIncrementForPreferredTime: TimeRecord ): ComponentResult; external name '_ClockGetTimesForRateChange';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  ClockGetRateChangeConstraints()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function ClockGetRateChangeConstraints( aClock: ComponentInstance; var minimumDelay: TimeRecord; var maximumDelay: TimeRecord ): ComponentResult; external name '_ClockGetRateChangeConstraints';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
   ************************************************
   Standard Compression component type and subtypes
   ************************************************
}

const
	StandardCompressionType = FourCharCode('scdi');
	StandardCompressionSubType = FourCharCode('imag');

  {
   * StandardCompressionSubTypeSound is the legacy StandardCompression
   * component that uses the SoundMgr.  It is limited to mono/stereo,
   * and to sample rates under 64kHz. It is still present in QuickTime
   * to support older apps (use of the new
   * StandardCompressionSubTypeAudio requires app developers to modify
   * their code).
   }
	StandardCompressionSubTypeSound = FourCharCode('soun');

  {
   * StandardCompressionSubTypeAudio is the StandardCompression
   * component that adds the ability to configure multi-channel, high
   * sample rate output formats.  It uses CoreAudio internally instead
   * of the SoundMgr, and has a full set of component properties to
   * make configuration easier, especially when the developer wishes to
   * bring up his/her own dialog rather than the default dialog.  See
   * StandardCompressionSubTypeAudio Properties below for a full list
   * of Component Properties supported by the
   * StandardCompressionSubTypeAudio component.
   }
	StandardCompressionSubTypeAudio = FourCharCode('audi');

type
	SCModalFilterProcPtr = function( theDialog: DialogRef; var theEvent: EventRecord; var itemHit: SInt16; refcon: SIGNEDLONG ): Boolean;
	SCModalFilterUPP = SCModalFilterProcPtr;

	SCModalHookProcPtr = function( theDialog: DialogRef; itemHit: SInt16; params: UnivPtr; refcon: SIGNEDLONG ): SInt16;
	SCModalHookUPP = SCModalHookProcPtr;
{  Preference flags.}
const
	scListEveryCodec = 1 shl 1;
	scAllowZeroFrameRate = 1 shl 2;
	scAllowZeroKeyFrameRate = 1 shl 3;
	scShowBestDepth = 1 shl 4;
	scUseMovableModal = 1 shl 5;
	scDisableFrameRateItem = 1 shl 6;
	scShowDataRateAsKilobits = 1 shl 7;


{  Possible test flags for setting test image.}
const
	scPreferCropping = 1 shl 0;
	scPreferScaling = 1 shl 1;
	scPreferScalingAndCropping = scPreferScaling or scPreferCropping;
	scDontDetermineSettingsFromTestImage = 1 shl 2;


{  Dimensions of the image preview box.}
const
	scTestImageWidth = 80;
	scTestImageHeight = 80;

{  Possible items returned by hookProc.}
const
	scOKItem = 1;
	scCancelItem = 2;
	scCustomItem = 3;

{  Result returned when user cancelled.}
const
	scUserCancelled = 1;

{ Component selectors}
{ -- prefixed with "k" because otherwise some of them conflict with function
   names, such as SCPositionRect - Jonas Maebe }
const
	kscPositionRect = 2;
	kscPositionDialog = 3;
	kscSetTestImagePictHandle = 4;
	kscSetTestImagePictFile = 5;
	kscSetTestImagePixMap = 6;
	kscGetBestDeviceRect = 7;
	kscRequestImageSettings = 10;
	kscCompressImage = 11;
	kscCompressPicture = 12;
	kscCompressPictureFile = 13;
	kscRequestSequenceSettings = 14;
	kscCompressSequenceBegin = 15;
	kscCompressSequenceFrame = 16;
	kscCompressSequenceEnd = 17;
	kscDefaultPictHandleSettings = 18;
	kscDefaultPictFileSettings = 19;
	kscDefaultPixMapSettings = 20;
	kscGetInfo = 21;
	kscSetInfo = 22;
	kscNewGWorld = 23;

{  Get/SetInfo structures.}

type
	SCSpatialSettingsPtr = ^SCSpatialSettings;
	SCSpatialSettings = record
		codecType: CodecType_fix;
		codec: CodecComponent;
		depth: SInt16;
		spatialQuality: CodecQ;
	end;
type
	SCTemporalSettingsPtr = ^SCTemporalSettings;
	SCTemporalSettings = record
		temporalQuality: CodecQ;
		frameRate: Fixed;
		keyFrameRate: SIGNEDLONG;
	end;
type
	SCDataRateSettingsPtr = ^SCDataRateSettings;
	SCDataRateSettings = record
		dataRate: SIGNEDLONG;
		frameDuration: SIGNEDLONG;
		minSpatialQuality: CodecQ;
		minTemporalQuality: CodecQ;
	end;
type
	SCExtendedProcsPtr = ^SCExtendedProcs;
	SCExtendedProcs = record
		filterProc: SCModalFilterUPP;
		hookProc: SCModalHookUPP;
		refcon: SIGNEDLONG;
		customName: Str31;
	end;
const
	scWindowRefKindCarbon = FourCharCode('carb'); { WindowRef}

type
	SCWindowSettings = record
		size: SIGNEDLONG;                   { must be sizeof(SCWindowSettings)}
		windowRefKind: SIGNEDLONG;          { type of parent window}
		parentWindow: UnivPtr;           { parent window, for sheets or NIL for none}
	end;
{  Get/SetInfo selectors}
const
	scSpatialSettingsType = FourCharCode('sptl'); { pointer to SCSpatialSettings struct}
	scTemporalSettingsType = FourCharCode('tprl'); { pointer to SCTemporalSettings struct}
	scDataRateSettingsType = FourCharCode('drat'); { pointer to SCDataRateSettings struct}
	scColorTableType = FourCharCode('clut'); { pointer to CTabHandle}
	scProgressProcType = FourCharCode('prog'); { pointer to ProgressRecord struct}
	scExtendedProcsType = FourCharCode('xprc'); { pointer to SCExtendedProcs struct}
	scPreferenceFlagsType = FourCharCode('pref'); { pointer to long}
	scSettingsStateType = FourCharCode('ssta'); { pointer to Handle}
	scSequenceIDType = FourCharCode('sequ'); { pointer to ImageSequence}
	scWindowPositionType = FourCharCode('wndw'); { pointer to Point}
	scCodecFlagsType = FourCharCode('cflg'); { pointer to CodecFlags}
	scCodecSettingsType = FourCharCode('cdec'); { pointer to Handle}
	scForceKeyValueType = FourCharCode('ksim'); { pointer to long}
	scCompressionListType = FourCharCode('ctyl'); { pointer to OSType Handle}
	scCodecManufacturerType = FourCharCode('cmfr'); { pointer to OSType}
	scAvailableCompressionListType = FourCharCode('avai'); { pointer to OSType Handle}
	scWindowOptionsType = FourCharCode('shee'); { pointer to SCWindowSettings struct}
	scSoundVBRCompressionOK = FourCharCode('cvbr'); { pointer to Boolean}
	scSoundSampleRateChangeOK = FourCharCode('rcok'); { pointer to Boolean}
	scSoundCompressionType = FourCharCode('ssct'); { pointer to OSType}
	scSoundSampleRateType = FourCharCode('ssrt'); { pointer to UnsignedFixed}
	scSoundInputSampleRateType = FourCharCode('ssir'); { pointer to UnsignedFixed}
	scSoundSampleSizeType = FourCharCode('ssss'); { pointer to short}
	scSoundChannelCountType = FourCharCode('sscc'); { pointer to short}

{  scTypeNotFoundErr returned by Get/SetInfo when type cannot be found.}


type
	SCParamsPtr = ^SCParams;
	SCParams = record
		flags: SIGNEDLONG;
		theCodecType: CodecType;
		theCodec: CodecComponent;
		spatialQuality: CodecQ;
		temporalQuality: CodecQ;
		depth: SInt16;
		frameRate: Fixed;
		keyFrameRate: SIGNEDLONG;
		reserved1: SIGNEDLONG;
		reserved2: SIGNEDLONG;
	end;
const
	scGetCompression = 1;
	scShowMotionSettings = 1 shl 0;
	scSettingsChangedItem = -1;

const
	scCompressFlagIgnoreIdenticalFrames = 1;

{ QTAtomTypes for atoms found in settings atom containers}
const
	kQTSettingsVideo = FourCharCode('vide'); { Container for video/image compression related atoms (Get/SetInfo selectors)}
	kQTSettingsSound = FourCharCode('soun'); { Container for sound compression related atoms (Get/SetInfo selectors)}
	kQTSettingsComponentVersion = FourCharCode('vers'); { . Version of component that wrote settings (QTSettingsVersionAtomRecord)}

{ Format of 'vers' atom found in settings atom containers}
type
	QTSettingsVersionAtomRecordPtr = ^QTSettingsVersionAtomRecord;
	QTSettingsVersionAtomRecord = record
		componentVersion: SIGNEDLONG;       { standard compression component version}
		flags: SInt16;                  { low bit is 1 if little endian platform, 0 if big endian platform}
		reserved: SInt16;               { should be 0}
	end;
{ Video Specific Definitions for B frame / multi pass support}


{
 *  SCVideoMultiPassEncodingSettings
 *  
 *  Summary:
 *    Struct for passing multi pass encoding settings through
 *    scVideoMultiPassEncodingSettingsType
 }
type
	SCVideoMultiPassEncodingSettings = record
{
   * True if multi pass encoding can be performed.
   }
		allowMultiPassEncoding: Boolean;
		maxEncodingPassCount: UInt8;
	end;

{
 *  Summary:
 *    SCGetInfo/SetInfo Selectors
 }
const
{
   * Specifies if frame reordering can occur in encoding.
   }
	scVideoAllowFrameReorderingType = FourCharCode('bfra'); { pointer to Boolean}

  {
   * The settings to control multi pass encoding.
   }
	scVideoMultiPassEncodingSettingsType = FourCharCode('mpes'); { pointer to SCVideoMultiPassEncodingSettings struct}


{
 *  Summary:
 *    Preference Flags for scPreferenceFlagsType
 *  
 *  Discussion:
 *    Preference flags that specify how StdCompression should handle
 *    frame reordering and multi pass encoding settings.
 }
const
{
   * Indicates the client is ready to use the ICM compression session
   * API to perform compression operations. StdCompression disables
   * frame reordering and multi pass encoding if this flag is cleared.
   }
	scAllowEncodingWithCompressionSession = 1 shl 8;

  {
   * Indicates the client does not want the user to change the frame
   * reordering setting.
   }
	scDisableFrameReorderingItem = 1 shl 9;

  {
   * Indicates the client does not want the user to change the multi
   * pass encoding setting
   }
	scDisableMultiPassEncodingItem = 1 shl 10;


{
   ******************************************
   StandardCompressionSubTypeAudio Properties
   ******************************************
}


{
   In StandardCompressionSubTypeAudio, instead of using Get/SetInfo, the developer will
   get and set component properties.  (QTGetComponentPropertyInfo(), QTGetComponentProperty(),
   QTSetComponentProperty(), QTAddComponentPropertyListener(), QTRemoveComponentPropertyListener())
   These properties have a class and ID, instead of just a single selector.
   Note that implementers of MovieExport "from procedures" getProperty procs (that choose
   to opt-in to the new support; see kQTMovieExporterPropertyID_EnableHighResolutionAudioFeatures
   in this header) will need to support these property IDs as new selectors.  In other
   words, the MovieExporter getProperty proc API is not changing to add a class.  The
   class is implied in that case.  Such procs, of course, do not implement any of the
   list properties, or the non-settable properties, as well as some others.  The
   properties getProperty procs can implement are marked below with the word "DataProc".
}


{
 *  Summary:
 *    ComponentPropertyClasses for StandardCompressionSubTypeAudio
 }
const
{
   * All Component Properties used by StandardCompressionSubTypeAudio
   * component use kQTPropertyClass_SCAudio, except for the following:
   * kQTAudioPropertyID_FormatString - use kQTPropertyClass_Audio (see
   * Movies.h) kQTAudioPropertyID_ChannelLayoutString - use
   * kQTPropertyClass_Audio (see Movies.h)
   * kQTAudioPropertyID_SampleRateString - use kQTPropertyClass_Audio
   * (see Movies.h) kQTAudioPropertyID_SampleSizeString - use
   * kQTPropertyClass_Audio (see Movies.h)
   * kQTAudioPropertyID_BitRateString - use kQTPropertyClass_Audio (see
   * Movies.h) kQTAudioPropertyID_SummaryString - use
   * kQTPropertyClass_Audio (see Movies.h)
   }
	kQTPropertyClass_SCAudio = FourCharCode('scda');


{
 *  Summary:
 *    ComponentPropertyID selectors for kQTPropertyClass_SCAudio
 }
const
{
   * kQTSCAudioPropertyID_ClientRestrictedCompressionFormatList:
   * Specifies a client-restricted set of output compression formats
   * that should be listed as available. Use QTGetComponentPropertyInfo
   * to discover the number of bytes you should allocate to hold the
   * array.
   }
	kQTSCAudioPropertyID_ClientRestrictedCompressionFormatList = FourCharCode('crf#'); { C-style array of OSType's, Read/Write/Listen}

  {
   * kQTSCAudioPropertyID_AvailableCompressionFormatList: Specifies the
   * list of available output compression formats. By default, this
   * list includes all the kAudioEncoderComponentType components and
   * kSoundCompressor type components on the system. The list may be
   * restricted by clients using the
   * kQTSCAudioPropertyID_ClientRestrictedCompressionFormatList
   * property. Use QTGetComponentPropertyInfo to discover the number of
   * bytes you should allocate to hold the array.
   }
	kQTSCAudioPropertyID_AvailableCompressionFormatList = FourCharCode('acf#'); { C-style array of OSType's, Read/Listen }

  {
   * kQTSCAudioPropertyID_AvailableCompressionFormatNamesList:
   * Specifies the human readable names for corresponding to each item
   * in kQTSCAudioPropertyID_AvailableCompressionFormatList. Caller
   * assumes responsibility for CFRelease()'ing the resulting
   * CFArrayRef.
   }
	kQTSCAudioPropertyID_AvailableCompressionFormatNamesList = FourCharCode('cnm#'); { CFArrayRef of CFStringRef's, Read/Write }

  {
   * kQTSCAudioPropertyID_HasLegacyCodecOptionsDialog: Some compression
   * formats have format-specific properties that are only accessible
   * via a compressor-provided dialog. 
   * kQTSCAudioPropertyID_HasLegacyCodecOptionsDialog lets you know if
   * the current compression format has such a dialog.
   }
	kQTSCAudioPropertyID_HasLegacyCodecOptionsDialog = FourCharCode('opn?'); { Boolean, Read/Listen }

  {
   * kQTSCAudioPropertyID_ConstantBitRateFormatsOnly: By default,
   * constant as well as variable bit rate compression formats are
   * shown in the available format list. a client may restrict the
   * available formats to constant bit rate formats only by setting
   * this property to true.
   }
	kQTSCAudioPropertyID_ConstantBitRateFormatsOnly = FourCharCode('!vbr'); { Boolean, Read/Write/Listen }

  {
   * kQTSCAudioPropertyID_ClientRestrictedSampleRateList: Specifies a
   * client-restricted set of output sample rate ranges that should be
   * listed as available. Use QTGetComponentPropertyInfo to discover
   * the number of bytes you should allocate to hold the array.
   }
	kQTSCAudioPropertyID_ClientRestrictedSampleRateList = FourCharCode('crr#'); { C-style array of AudioValueRange's, Read/Write/Listen }

  {
   * kQTSCAudioPropertyID_AvailableSampleRateList: Specifies a list of
   * available output sample rates.  This list is compression format
   * specific, and takes into account any restrictions imposed by a
   * client using the
   * kQTSCAudioPropertyID_ClientRestrictedSampleRateList property. Use
   * QTGetComponentPropertyInfo to discover the number of bytes you
   * should allocate to hold the array.
   }
	kQTSCAudioPropertyID_AvailableSampleRateList = FourCharCode('avr#'); { C-style array of AudioValueRange's, Read/Listen}

  {
   * kQTSCAudioPropertyID_ApplicableSampleRateList: Specifies which of
   * the value ranges in the
   * kQTSCAudioPropertyID_AvailableSampleRateList are currently
   * applicable. The kQTSCAudioPropertyID_AvailableSampleRateList takes
   * into account client restrictions, and a compression format's
   * general sample rate restrictions. 
   * kQTSCAudioPropertyID_ApplicableSampleRateList further filters the
   * list to just those sample rates that are legal and valid given the
   * current codec configuration.  Use QTGetComponentPropertyInfo to
   * discover the number of bytes you should allocate to hold the array.
   }
	kQTSCAudioPropertyID_ApplicableSampleRateList = FourCharCode('apr#'); { C-style array of AudioValueRanges, Read/Listen}

  {
   * kQTSCAudioPropertyID_SampleRateRecommended: Clients not wishing to
   * set an output sample rate manually may set the output rate to the
   * recommended rate.  Some compressors can perform rate conversion,
   * and can pick optimal settings for a desired bitrate (AAC is an
   * example).  For other formats, the "Recommended" rate is simply the
   * closest output rate to the input rate that's allowed by the output
   * format.  kQTSCAudioPropertyID_SampleRateIsRecommended is
   * read-only.  To set the sample rate to recommended, a client sets
   * the kQTSCAudioPropertyID_BasicDescription with mSampleRate = 0.0. 
   * To unset the sample rate as recommended, the client sets the
   * kQTSCAudioPropertyID_BasicDescription with a non-zero mSampleRate
   * field.
   }
	kQTSCAudioPropertyID_SampleRateIsRecommended = FourCharCode('reco'); { Boolean, Read/Listen}

  {
   * kQTSCAudioPropertyID_InputMagicCookie: Some decompressors make use
   * of untyped codec-specific data (a magic cookie) in order to decode
   * their input. Magic cookies are variable size, so you must call
   * QTGetComponentPropertyInfo in order to discover the size of the
   * buffer you should allocate to hold the cookie.
   }
	kQTSCAudioPropertyID_InputMagicCookie = FourCharCode('ikki'); { void * (opaque data), Read/Write/Listen }

  {
   * kQTSCAudioPropertyID_MagicCookie: Some compressors make use of
   * untyped codec-specific data (a magic cookie) in order to configure
   * their output. Magic cookies are variable size, so you must call
   * QTGetComponentPropertyInfo in order to discover the size of the
   * buffer you should allocate to hold the cookie.
   }
	kQTSCAudioPropertyID_MagicCookie = FourCharCode('kuki'); { void * (opaque data), Read/Write/Listen }

  {
   * kQTSCAudioPropertyID_ClientRestrictedLPCMBitsPerChannelList:
   * Specifies a client-restricted set of output bits per channel that
   * should be listed as available. Use QTGetComponentPropertyInfo to
   * discover the number of bytes you should allocate to hold the array.
   }
	kQTSCAudioPropertyID_ClientRestrictedLPCMBitsPerChannelList = FourCharCode('crb#'); { C-style array of UInt32's, Read/Write/Listen }

  {
   * kQTSCAudioPropertyID_AvailableLPCMBitsPerChannelList: Specifies a
   * list of available bits-per-channel.  This list is specific to
   * LPCM, and takes into account any restrictions imposed by a client
   * using the
   * kQTSCAudioPropertyID_ClientRestrictedLPCMBitsPerChannelList
   * property. Use QTGetComponentPropertyInfo to discover the number of
   * bytes you should allocate to hold the array.
   }
	kQTSCAudioPropertyID_AvailableLPCMBitsPerChannelList = FourCharCode('avb#'); { C-style array of UInt32's, Read/Listen }

  {
   * kQTSCAudioPropertyID_ApplicableLPCMBitsPerChannelList: Specifies
   * which of the values in the
   * kQTSCAudioPropertyID_AvailableLPCMBitsPerChannelList are currently
   * applicable. The
   * kQTSCAudioPropertyID_AvailableLPCMBitsPerChannelList takes into
   * account client restrictions, and LPCM's general bits per channel
   * restrictions. 
   * kQTSCAudioPropertyID_ApplicableLPCMBitsPerChannelList further
   * filters the list to just those bits per channel that are legal and
   * valid given the current LPCM configuration.  Use
   * QTGetComponentPropertyInfo to discover the number of bytes you
   * should allocate to hold the array.
   }
	kQTSCAudioPropertyID_ApplicableLPCMBitsPerChannelList = FourCharCode('apb#'); { C-style array of UInt32's, Read/Listen}

  {
   * kQTSCAudioPropertyID_InputChannelLayout: Specifies the audio
   * channel layout of the input description.  AudioChannelLayout is a
   * variable size struct, so use QTGetComponentPropertyInfo to
   * discover the number of bytes you should allocate.
   }
	kQTSCAudioPropertyID_InputChannelLayout = FourCharCode('icly'); { AudioChannelLayout (variable-size), Read/Write/Listen }

  {
   * kQTSCAudioPropertyID_InputChannelLayoutName: Specifies the human
   * readable name for kQTSCAudioPropertyID_InputChannelLayout (if one
   * exists).  Caller assumes responsibility for CFRelease()'ing the
   * resulting string.
   }
	kQTSCAudioPropertyID_InputChannelLayoutName = FourCharCode('icln'); { CFStringRef, Read }

  {
   * kQTSCAudioPropertyID_ChannelLayout: Specifies the audio channel
   * layout of the output description.  AudioChannelLayout is a
   * variable size struct, so use QTGetComponentPropertyInfo to
   * discover the number of bytes you should allocate.
   }
	kQTSCAudioPropertyID_ChannelLayout = FourCharCode('clay'); { AudioChannelLayout (variable-size), Read/Write/Listen }

  {
   * kQTSCAudioPropertyID_ChannelLayoutName: Specifies the human
   * readable name for kQTSCAudioPropertyID_ChannelLayout (if one
   * exists).  Caller assumes responsibility for CFRelease()'ing the
   * resulting string.
   }
	kQTSCAudioPropertyID_ChannelLayoutName = FourCharCode('clyn'); { CFStringRef, Read }

  {
   * kQTSCAudioPropertyID_ClientRestrictedChannelLayoutTagList:
   * Specifies a client-restricted set of channel layout tags that
   * should be listed as available. Use QTGetComponentPropertyInfo to
   * discover the number of bytes you should allocate to hold the array.
   }
	kQTSCAudioPropertyID_ClientRestrictedChannelLayoutTagList = FourCharCode('crl#'); { C-style array of AudioChannelLayoutTag's, Read/Write}

  {
   * kQTSCAudioPropertyID_AvailableChannelLayoutTagList: Specifies a
   * list of available audio channel layout tags.  This list is
   * compression format specific, and takes into account any
   * restrictions imposed by a client using the
   * kQTSCAudioPropertyID_ClientRestrictedChannelLayoutTagList
   * property. Use QTGetComponentPropertyInfo to discover the number of
   * bytes you should allocate to hold the array.
   }
	kQTSCAudioPropertyID_AvailableChannelLayoutTagList = FourCharCode('avl#'); { C-style array of AudioChannelLayoutTag's, Read/Listen }

  {
   * kQTSCAudioPropertyID_AvailableChannelLayoutTagNamesList: Specifies
   * the human readable names for the AudioChannelLayoutTags in
   * kQTSCAudioPropertyID_AvailableChannelLayoutTagList. Each element
   * in the array is a CFStringRef.  Caller assumes responsibility for
   * CFRelease()'ing the array.
   }
	kQTSCAudioPropertyID_AvailableChannelLayoutTagNamesList = FourCharCode('vln#'); { CFArrayRef, Read}

  {
   * kQTSCAudioPropertyID_ApplicableChannelLayoutTagList: Specifies
   * which of the values in the
   * kQTSCAudioPropertyID_AvailableChannelLayoutTagList are currently
   * applicable. The kQTSCAudioPropertyID_AvailableChannelLayoutTagList
   * takes into account client restrictions, and the current output
   * format's general channel layout restrictions. 
   * kQTSCAudioPropertyID_ApplicableChannelLayoutTagList further
   * filters the list to just those channel layouts that are legal and
   * valid given the current codec configuration.  Use
   * QTGetComponentPropertyInfo to discover the number of bytes you
   * should allocate to hold the array.
   }
	kQTSCAudioPropertyID_ApplicableChannelLayoutTagList = FourCharCode('apl#'); { C-style array of AudioChannelLayoutTag's, Read/Listen}

  {
   * kQTSCAudioPropertyID_ApplicableChannelLayoutTagNamesList:
   * Specifies the human readable names for the AudioChannelLayoutTags
   * in kQTSCAudioPropertyID_ApplicableChannelLayoutTagList. Each
   * element in the array is a CFStringRef.  Caller assumes
   * responsibility for CFRelease()'ing the array.
   }
	kQTSCAudioPropertyID_ApplicableChannelLayoutTagNamesList = FourCharCode('pln#'); { CFArrayRef, Read}

  {
   * kQTSCAudioPropertyID_ClientRestrictedLPCMFlags: Specifies a
   * client-restricted set of flags corresponding to the mFormatFlags
   * fields in an AudioStreamBasicDescription.  Data type is a
   * SCAudioFormatFlagsRestrictions struct. For instance, if a client
   * wishes to specify to the StandardAudioCompression component that
   * his file format requires little endian pcm data, he may set this
   * property, with formatFlagsMask set to kAudioFormatFlagIsBigEndian,
   * and formatFlagsValues set to zero (indicating that the IsBigEndian
   * bit should be interpreted as LittleEndian only).
   }
	kQTSCAudioPropertyID_ClientRestrictedLPCMFlags = FourCharCode('crlp'); { SCAudioFormatFlagsRestrictions (see below), Read/Write/Listen }

  {
   * kQTSCAudioPropertyID_InputSoundDescription: Specifies the current
   * input description as a SoundDescriptionHandle (lowest possible
   * version for the current format).  When calling
   * QTGetComponentProperty, the caller passes a pointer to an
   * unallocated Handle, and assumes responsibility for calling
   * DisposeHandle() when done.
   }
	kQTSCAudioPropertyID_InputSoundDescription = FourCharCode('isdh'); { SoundDescriptionHandle, Read/Write }

  {
   * kQTSCAudioPropertyID_SoundDescription: Specifies the current
   * output description as a SoundDescriptionHandle (lowest possible
   * version for the current format).  When calling
   * QTGetComponentProperty, the caller passes a pointer to an
   * unallocated Handle, and assumes responsibility for calling
   * DisposeHandle() when done.
   }
	kQTSCAudioPropertyID_SoundDescription = FourCharCode('osdh'); { SoundDescriptionHandle, Read/Write }

  {
   * kQTSCAudioPropertyID_InputBasicDescription: Specifies the current
   * input description as an AudioStreamBasicDescription.
   }
	kQTSCAudioPropertyID_InputBasicDescription = FourCharCode('isbd'); { AudioStreamBasicDescription, Read/Write/Listen/DataProc }

  {
   * kQTSCAudioPropertyID_BasicDescription: Specifies the current
   * output description as an AudioStreamBasicDescription.
   }
	kQTSCAudioPropertyID_BasicDescription = FourCharCode('osbd'); { AudioStreamBasicDescription, Read/Write/Listen/DataProc }

  {
   * kQTSCAudioPropertyID_CodecSpecificSettingsArray: Some compressors
   * publish a CFArray of CFDictionaries that describe various
   * parameters specific to the configuring of the codec.  This array
   * of dictionaries can be parsed to generate UI.  When any value in
   * the array changes, a client should call QTSetComponentProperty,
   * passing the entire array.
   }
	kQTSCAudioPropertyID_CodecSpecificSettingsArray = FourCharCode('cdst'); { CFArrayRef, Read/Write }

  {
   * kQTSCAudioPropertyID_BitRate: Specifies the current bitrate of the
   * output audio format in bit per second. Note that this property may
   * not be available for formats that are inherently very variable in
   * bitrate and highly source-data dependent (such as Apple Lossless).
   *  This property is available in QT 7.1 and later.
   }
	kQTSCAudioPropertyID_BitRate = kQTSoundDescriptionPropertyID_BitRate; { UInt32, Read}
                                        { Old Sound Get/SetInfo types as property id's.}

  {
   * kQTSCAudioPropertyID_SettingsState: Used to save off the current
   * state of the StandardCompressionSubTypeAudio component, such that
   * the state may be restored at a later time with a single call.  The
   * Handle returned from from QTGetComponentProperty(...
   * kQTSCAudioPropertyID_SettingsState ...) contains classic atoms
   * that have not been Endian flipped, so this Handle is not suitable
   * for writing to disk.  If you wish to store settings from a
   * scdi/audi component instance to disk (as a compression preset,
   * etc.), use SCGetSettingsAsAtomContainer(), the result of which is
   * a QTAtomContainer filled with settings that have been Endian
   * flipped.  To restore a settings QTAtomContainer from disk at a
   * later time, use SCSetSettingsFromAtomContainer().  Note that a
   * scdi/audi instance will accept (via
   * SCSetSettingsFromAtomContainer()) a QTAtomContainer produced by a
   * legacy scdi/soun component.  And the QTAtomContainer produced by
   * an scdi/audi component (using SCGetSettingsAsAtomContainer()) will
   * contain settings that are backward compatible with a scdi/soun
   * component, so long as the current state of the scdi/audi component
   * instance reflects an output format capable of being described by a
   * SoundDescriptionV1. Also note that the
   * kQTSCAudioPropertyID_SettingsState Handle from a scdi/audi
   * component and the Handle produced from a scdi/soun component's
   * SCGetInfo(... scSettingsStateType ...) are not compatible with one
   * another.
   }
	kQTSCAudioPropertyID_SettingsState = scSettingsStateType; { Handle, Read/Write }

  {
   * kQTSCAudioPropertyID_MaximumOutputPacketSize: Specifies the
   * greatest size in bytes of a packet obtained using the
   * SCAudioFillBuffer call. This size is dependent on the output
   * format of the compression/decompression/transcode operation being
   * performed.  This property is available in QT 7.1 and later.
   * Maximum output packet size is a read-only property.
   }
	kQTSCAudioPropertyID_MaximumOutputPacketSize = FourCharCode('xops'); { UInt32, Read}

  {
   * kQTSCAudioPropertyID_OutputFormatIsExternallyFramed: Specifies
   * whether the output format currently selected requires external
   * framing information.  This information is necessary when using the
   * SCAudioFillBuffer API call to determine whether
   * AudioStreamPacketDescriptions must be passed.  If the format is
   * externally framed, an array of AudioStreamPacketDescriptions must
   * be passed to SCAudioFillBuffer, otherwise not.  This property is
   * available in QT 7.1 and later. This property is read-only.
   }
	kQTSCAudioPropertyID_OutputFormatIsExternallyFramed = FourCharCode('fexf'); { Boolean, Read}

  {
   * kQTSCAudioPropertyID_RenderQuality: Specifies the quality with
   * which QuickTime should render the audio stream during the
   * compression/decompression/transcode operation.  Accepted constants
   * are defined in Movies.h: kQTAudioRenderQuality_Max,
   * kQTAudioRenderQuality_High, kQTAudioRenderQuality_Medium,
   * kQTAudioRenderQuality_Low, kQTAudioRenderQuality_Min. This
   * property is available in QT 7.1 and later.
   }
	kQTSCAudioPropertyID_RenderQuality = FourCharCode('qlty'); { UInt32, Read/Write/Listen}

  {
   * kQTSCAudioPropertyID_ExtendedProcs: Used to get/set an
   * SCExtendedProcs struct.
   }
	kQTSCAudioPropertyID_ExtendedProcs = scExtendedProcsType; { SCExtendedProcs struct, Read/Write/Listen }

  {
   * kQTSCAudioPropertyID_PreferenceFlags: Used to specify dialog
   * preferences, such as scUseMovableModal.
   }
	kQTSCAudioPropertyID_PreferenceFlags = scPreferenceFlagsType; { SInt32, Read/Write/Listen }

  {
   * kQTSCAudioPropertyID_WindowOptions: Used to set an
   * SCWindowSettings struct, which tells the dialog about its parent
   * window, so that it can draw itself as a sheet on top of the parent
   * window.
   }
	kQTSCAudioPropertyID_WindowOptions = scWindowOptionsType; { SCWindowSettings struct, Read/Write/Listen }

  {
   * kQTSCAudioPropertyID_PreviewSourceMovie: Used for audio preview
   * purposes. If a source movie has been specified prior to invoking
   * the StdAudio dialog using SCRequestImageSettings(), the StdAudio
   * dialog ui will contain an additional "preview/stop" button and a
   * "play source" check box to allow quick toggling between the source
   * audio and the encoded result.  The StdAudio dialog ui previews
   * from the movie's current time (obtained from GetMovieTime()) and
   * loops a segment of up to 10 seconds, starting at that time.  If
   * the current movie time is at the end of the movie, the preview
   * begins at the start of the movie instead.
   }
	kQTSCAudioPropertyID_PreviewSourceMovie = FourCharCode('prmv'); { Movie, Read/Write}

  {
   * kQTSCAudioPropertyID_PreviewSourceTrack: Used to specify a
   * particular track for audio preview. The track must be found in the
   * movie specified by kQTSCAudioPropertyID_PreviewSourceMovie.
   }
	kQTSCAudioPropertyID_PreviewSourceTrack = FourCharCode('prtk'); { Track, Read/Write}


{
   These are for movie export getProperty procs only (not SCAudio), so that variable size
   properties can be handled in that API where there is no associated size parameter.
   The getProperty proc can be asked the size first, then the caller can allocate memory
   for the associated SCAudio property and call the getProperty proc again to get the
   property.
}
const
	movieExportChannelLayoutSize = FourCharCode('clsz'); { UInt32.  Proc only}
	movieExportMagicCookieSize = FourCharCode('mcsz'); { UInt32.  Proc only}
	movieExportUseHighResolutionAudioProperties = FourCharCode('hrau'); { Boolean. Proc only}


{
 *  SCAudioFormatFlagsRestrictions
 *  
 *  Summary:
 *    Struct describing the restrictions a client wishes to impose on
 *    the mFormatFlags fields of an AudioStreamBasicDescription.  In
 *    formatFlagsMask, the client specifies the fields to be
 *    restricted, and in formatFlagsValues, the client specifies the
 *    restricted value of each field set in the mask.
 }
type
	SCAudioFormatFlagsRestrictions = record
{
   * NOTE: Currently QuickTime only supports restrictions on the
   * following bits: kAudioFormatFlagIsFloat,
   * kAudioFormatFlagIsBigEndian, kAudioFormatFlagIsSignedInteger. If
   * other bits are set in the formatFlagsMask, paramErr will be
   * returned.
   }
		formatFlagsMask: UInt32;

  {
   * NOTE regarding the kAudioFormatFlagIsSignedInteger flag: Integer
   * samples over 8 bits must always be signed.  Setting this bit
   * applies to 8 bit integer samples only.
   }
		formatFlagsValues: UInt32;
	end;
{
 *  SCAudioInvokeLegacyCodecOptionsDialog()
 *  
 *  Discussion:
 *    If kQTSCAudioPropertyID_HasLegacyCodecOptionsDialog is true,
 *    SCAudioInvokeLegacyCodecOptionsDialog invokes the compressor's
 *    options dialog. Note - this call blocks until the options dialog
 *    "OK" or "Cancel" buttons are pressed.
 *  
 *  Parameters:
 *    
 *    ci:
 *      The client's connection to a StdAudio Compression component
 *  
 *  Result:
 *    ComponentResult
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SCAudioInvokeLegacyCodecOptionsDialog( ci: ComponentInstance ): ComponentResult; external name '_SCAudioInvokeLegacyCodecOptionsDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
   *************************************************
   StandardCompressionSubTypeAudio Compression API's
   *************************************************
}

{
   The StandardCompressionSubTypeAudio component provides an SCAudioFillBuffer
   call with the same parameters and behaviors of AudioConverterFillComplexBuffer.
   One important difference between the AudioConverter and SCAudio component is
   that the SCAudio compression API's can do mixing as well as n -> n channels 
   conversion.  A client wishes to compress/decompress/transcode audio using
   the SCAudioFillBuffer interface configures the StandardCompressionSubTypeAudio 
   component with the desired input and output formats (or uses the SCRequestImageSettings
   API to present a dialog and let a user pick an output format), then calls
   SCAudioFillBuffer, providing an SCAudioInputDataProc callback which will be
   called for audio in the specified source format.
}


{
 *  SCAudioInputDataProc
 *  
 *  Discussion:
 *    Clients using the SCAudioFillBuffer API call must provide an
 *    input data proc in which they provide source packets of audio.
 *    SCAudioInputDataProc is available in QT 7.1 and later.
 *  
 *  Parameters:
 *    
 *    ci:
 *      The client's connection to a StdAudio Compression component
 *    
 *    ioNumberDataPackets:
 *      On input, the number of audio packets requested. On output, the
 *      number of audio packets you've actually provided.
 *    
 *    ioData:
 *      An AudioBufferList in which you store the requested data.
 *    
 *    outDataPacketDescription:
 *      An array of AudioStreamPacketDescriptions you provide to inform
 *      downstream components how to decode your externally framed
 *      audio packets.
 *    
 *    inRefCon:
 *      The ref con you provided to SCAudioFillBuffer.
 *  
 *  Result:
 *    ComponentResult An error code you return.
 }
type
	SCAudioInputDataProc = function( ci: ComponentInstance; var ioNumberDataPackets: UInt32; var ioData: AudioBufferList; var outDataPacketDescription: AudioStreamPacketDescriptionPtr; inRefCon: UnivPtr ): ComponentResult;


{
 *  SCAudioFillBuffer()
 *  
 *  Discussion:
 *    Used to pull compressed frames from the StdAudio component in
 *    kQTSCAudioPropertyID_BasicDescription format.  The StdAudio
 *    component can perform any combination of
 *    decompression/mixing/compression, combining the facilities of
 *    CoreAudio AudioConverters and Matrix Mixer AudioUnits.  The
 *    behavior of the SCAudioFillBuffer call (signalling end of data,
 *    etc.) is identical to the AudioConverter's
 *    AudioConverterFillComplexBuffer API.
 *  
 *  Parameters:
 *    
 *    ci:
 *      The client's connection to a StdAudio Compression component
 *    
 *    inInputDataProc:
 *      The proc address of the function that will be called to supply
 *      data in the kQTSCAudioPropertyID_InputBasicDescription format
 *      to SCAudio.
 *    
 *    inInputDataProcRefCon:
 *      The client refcon that will be passed to the user-provided
 *      SCAudioInputDataProc function.
 *    
 *    ioOutputDataPacketSize:
 *      On input, the number of desired packets.  On output, the actual
 *      number of packets delivered (can be fewer than the input
 *      desired packets).
 *    
 *    outOutputData:
 *      An AudioBufferList providing sufficiently large buffers to hold
 *      the requested number of packets.
 *    
 *    outPacketDescription:
 *      An array of AudioStreamPacketDescriptions.  If the requested
 *      output format requires external framing info (i.e. a VBR format
 *      such as AAC), allocate and pass an array of packet descriptions
 *      as large as the number of packets you are requesting.
 *  
 *  Result:
 *    ComponentResult
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SCAudioFillBuffer( ci: ComponentInstance; inInputDataProc: SCAudioInputDataProc; inInputDataProcRefCon: UnivPtr; var ioOutputDataPacketSize: UInt32; var outOutputData: AudioBufferList; var outPacketDescription: AudioStreamPacketDescription ): ComponentResult; external name '_SCAudioFillBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  SCAudioReset()
 *  
 *  Discussion:
 *    Used to reset an SCAudio conversion chain, flushing any latency
 *    present in internal buffers
 *  
 *  Parameters:
 *    
 *    ci:
 *      The client's connection to a StdAudio Compression component
 *  
 *  Result:
 *    ComponentResult
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SCAudioReset( ci: ComponentInstance ): ComponentResult; external name '_SCAudioReset';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


// #define SCGetCompression(ci, params, where) SCGetCompressionExtended(ci,params,where,0,0,0,0)
{* These are Progress procedures *}
{
 *  SCGetCompressionExtended()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCGetCompressionExtended( ci: ComponentInstance; var params: SCParams; where: Point; filterProc: SCModalFilterUPP; hookProc: SCModalHookUPP; refcon: SIGNEDLONG; customName: StringPtr ): ComponentResult; external name '_SCGetCompressionExtended';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCPositionRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCPositionRect( ci: ComponentInstance; var rp: Rect; var where: Point ): ComponentResult; external name '_SCPositionRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCPositionDialog()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCPositionDialog( ci: ComponentInstance; id: SInt16; var where: Point ): ComponentResult; external name '_SCPositionDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCSetTestImagePictHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCSetTestImagePictHandle( ci: ComponentInstance; testPict: PicHandle; var testRect: Rect; testFlags: SInt16 ): ComponentResult; external name '_SCSetTestImagePictHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCSetTestImagePictFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCSetTestImagePictFile( ci: ComponentInstance; testFileRef: SInt16; var testRect: Rect; testFlags: SInt16 ): ComponentResult; external name '_SCSetTestImagePictFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCSetTestImagePixMap()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCSetTestImagePixMap( ci: ComponentInstance; testPixMap: PixMapHandle; var testRect: Rect; testFlags: SInt16 ): ComponentResult; external name '_SCSetTestImagePixMap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCGetBestDeviceRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCGetBestDeviceRect( ci: ComponentInstance; var r: Rect ): ComponentResult; external name '_SCGetBestDeviceRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCRequestImageSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCRequestImageSettings( ci: ComponentInstance ): ComponentResult; external name '_SCRequestImageSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCCompressImage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCCompressImage( ci: ComponentInstance; src: PixMapHandle; const (*var*) srcRect: Rect; var desc: ImageDescriptionHandle; var data: Handle ): ComponentResult; external name '_SCCompressImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCCompressPicture()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCCompressPicture( ci: ComponentInstance; srcPicture: PicHandle; dstPicture: PicHandle ): ComponentResult; external name '_SCCompressPicture';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCCompressPictureFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCCompressPictureFile( ci: ComponentInstance; srcRefNum: SInt16; dstRefNum: SInt16 ): ComponentResult; external name '_SCCompressPictureFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCRequestSequenceSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCRequestSequenceSettings( ci: ComponentInstance ): ComponentResult; external name '_SCRequestSequenceSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCCompressSequenceBegin()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCCompressSequenceBegin( ci: ComponentInstance; src: PixMapHandle; const (*var*) srcRect: Rect; var desc: ImageDescriptionHandle ): ComponentResult; external name '_SCCompressSequenceBegin';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCCompressSequenceFrame()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCCompressSequenceFrame( ci: ComponentInstance; src: PixMapHandle; const (*var*) srcRect: Rect; var data: Handle; var dataSize: SIGNEDLONG; var notSyncFlag: SInt16 ): ComponentResult; external name '_SCCompressSequenceFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCCompressSequenceEnd()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCCompressSequenceEnd( ci: ComponentInstance ): ComponentResult; external name '_SCCompressSequenceEnd';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCDefaultPictHandleSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCDefaultPictHandleSettings( ci: ComponentInstance; srcPicture: PicHandle; motion: SInt16 ): ComponentResult; external name '_SCDefaultPictHandleSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCDefaultPictFileSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCDefaultPictFileSettings( ci: ComponentInstance; srcRef: SInt16; motion: SInt16 ): ComponentResult; external name '_SCDefaultPictFileSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCDefaultPixMapSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCDefaultPixMapSettings( ci: ComponentInstance; src: PixMapHandle; motion: SInt16 ): ComponentResult; external name '_SCDefaultPixMapSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCGetInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCGetInfo( ci: ComponentInstance; infoType: OSType; info: UnivPtr ): ComponentResult; external name '_SCGetInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCSetInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCSetInfo( ci: ComponentInstance; infoType: OSType; info: UnivPtr ): ComponentResult; external name '_SCSetInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCNewGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCNewGWorld( ci: ComponentInstance; var gwp: GWorldPtr; var rp: Rect; flags: GWorldFlags ): ComponentResult; external name '_SCNewGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCSetCompressFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCSetCompressFlags( ci: ComponentInstance; flags: SIGNEDLONG ): ComponentResult; external name '_SCSetCompressFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCGetCompressFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCGetCompressFlags( ci: ComponentInstance; var flags: SIGNEDLONG ): ComponentResult; external name '_SCGetCompressFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCGetSettingsAsText()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCGetSettingsAsText( ci: ComponentInstance; var text: Handle ): ComponentResult; external name '_SCGetSettingsAsText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCGetSettingsAsAtomContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCGetSettingsAsAtomContainer( ci: ComponentInstance; var settings: QTAtomContainer ): ComponentResult; external name '_SCGetSettingsAsAtomContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCSetSettingsFromAtomContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SCSetSettingsFromAtomContainer( ci: ComponentInstance; settings: QTAtomContainer ): ComponentResult; external name '_SCSetSettingsFromAtomContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Note: if you're using SCCompressSequenceFrameAsync with a scForceKeyValue setting, you must call SCAsyncIdle occasionally at main task time. }
{
 *  SCCompressSequenceFrameAsync()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function SCCompressSequenceFrameAsync( ci: ComponentInstance; src: PixMapHandle; const (*var*) srcRect: Rect; var data: Handle; var dataSize: SIGNEDLONG; var notSyncFlag: SInt16; asyncCompletionProc: ICMCompletionProcRecordPtr ): ComponentResult; external name '_SCCompressSequenceFrameAsync';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCAsyncIdle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function SCAsyncIdle( ci: ComponentInstance ): ComponentResult; external name '_SCAsyncIdle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SCCopyCompressionSessionOptions()
 *  
 *  Summary:
 *    Retrieve relevant settings in a form of compression session
 *    options that can be given to a compression session. The caller
 *    must release it when it is done.
 *  
 *  Parameters:
 *    
 *    ci:
 *      A component instance of type StdCompression subtype
 *      StandardCompressionSubTypeVideo.
 *    
 *    outOptions:
 *      A pointer to ICMCompressionSettionOptionsRef where a reference
 *      to a new instance of ICM Compression Session Options object is
 *      returned.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SCCopyCompressionSessionOptions( ci: ComponentInstance; var outOptions: ICMCompressionSessionOptionsRef ): ComponentResult; external name '_SCCopyCompressionSessionOptions';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


const
	TweenComponentType = FourCharCode('twen');


type
	TweenerComponent = ComponentInstance;
{
 *  TweenerInitialize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TweenerInitialize( tc: TweenerComponent; container: QTAtomContainer; tweenAtom: QTAtom; dataAtom: QTAtom ): ComponentResult; external name '_TweenerInitialize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TweenerDoTween()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TweenerDoTween( tc: TweenerComponent; var tr: TweenRecord ): ComponentResult; external name '_TweenerDoTween';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TweenerReset()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TweenerReset( tc: TweenerComponent ): ComponentResult; external name '_TweenerReset';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	TCSourceRefNameType = FourCharCode('name');

const
	tcDropFrame = 1 shl 0;
	tc24HourMax = 1 shl 1;
	tcNegTimesOK = 1 shl 2;
	tcCounter = 1 shl 3;


{$endc} {not TARGET_CPU_64}

type
	TimeCodeDefPtr = ^TimeCodeDef;
	TimeCodeDef = record
		flags: SInt32;                  { drop-frame, etc.}
		fTimeScale: TimeScale;             { time scale of frameDuration (eg. 2997)}
		frameDuration: TimeValue;          { duration of each frame (eg. 100)}
		numFrames: UInt8;              { frames/sec for timecode (eg. 30) OR frames/tick for counter mode}
		padding: UInt8;                { unused padding byte}
	end;
	TimeCodeDef_fix = TimeCodeDef;  { used as field type when a record declaration contains a TimeCodeDef field identifier }

{$ifc not TARGET_CPU_64}

const
	tctNegFlag = $80;  { negative bit is in minutes}

type
	TimeCodeTimePtr = ^TimeCodeTime;
	TimeCodeTime = record
		hours: UInt8;
		minutes: UInt8;
		seconds: UInt8;
		frames: UInt8;
	end;
type
	TimeCodeCounterPtr = ^TimeCodeCounter;
	TimeCodeCounter = record
		counter: SIGNEDLONG;
	end;

	TimeCodeRecordPtr = ^TimeCodeRecord;
	TimeCodeRecord = record
		case SInt16 of
		0: (
			t: TimeCodeTime;
			);
		1: (
			c: TimeCodeCounter;
			);
	end;

{$endc} {not TARGET_CPU_64}

type
	TimeCodeDescription = record
		descSize: SInt32;               { standard sample description header}
		dataFormat: SInt32;
		resvd1: SInt32;
		resvd2: SInt16;
		dataRefIndex: SInt16;
		flags: SInt32;                  { timecode specific stuff}
		timeCodeDef: TimeCodeDef_fix;
    srcRef: array [0..0] of SInt32;
	end;
	TimeCodeDescriptionPtr = ^TimeCodeDescription;
type
	TimeCodeDescriptionHandle = ^TimeCodeDescriptionPtr;

{$ifc not TARGET_CPU_64}

const
	tcdfShowTimeCode = 1 shl 0;


type
	TCTextOptions = record
		txFont: SInt16;
		txFace: SInt16;
		txSize: SInt16;
		pad: SInt16;                    { let's make it longword aligned - thanks.. }
		foreColor: RGBColor;
		backColor: RGBColor;
	end;
	TCTextOptionsPtr = ^TCTextOptions;

type
	TimeCode64Counter = SInt64;
{
 *  TCGetCurrentTimeCode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TCGetCurrentTimeCode( mh: MediaHandler; var frameNum: SIGNEDLONG; var tcdef: TimeCodeDef; var tcrec: TimeCodeRecord; var srcRefH: UserData ): HandlerError; external name '_TCGetCurrentTimeCode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TCGetTimeCodeAtTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TCGetTimeCodeAtTime( mh: MediaHandler; mediaTime: TimeValue; var frameNum: SIGNEDLONG; var tcdef: TimeCodeDef; var tcdata: TimeCodeRecord; var srcRefH: UserData ): HandlerError; external name '_TCGetTimeCodeAtTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TCTimeCodeToString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TCTimeCodeToString( mh: MediaHandler; var tcdef: TimeCodeDef; var tcrec: TimeCodeRecord; tcStr: StringPtr ): HandlerError; external name '_TCTimeCodeToString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TCTimeCodeToFrameNumber()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TCTimeCodeToFrameNumber( mh: MediaHandler; var tcdef: TimeCodeDef; var tcrec: TimeCodeRecord; var frameNumber: SIGNEDLONG ): HandlerError; external name '_TCTimeCodeToFrameNumber';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TCFrameNumberToTimeCode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TCFrameNumberToTimeCode( mh: MediaHandler; frameNumber: SIGNEDLONG; var tcdef: TimeCodeDef; var tcrec: TimeCodeRecord ): HandlerError; external name '_TCFrameNumberToTimeCode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TCGetSourceRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TCGetSourceRef( mh: MediaHandler; tcdH: TimeCodeDescriptionHandle; var srefH: UserData ): HandlerError; external name '_TCGetSourceRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TCSetSourceRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TCSetSourceRef( mh: MediaHandler; tcdH: TimeCodeDescriptionHandle; srefH: UserData ): HandlerError; external name '_TCSetSourceRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TCSetTimeCodeFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TCSetTimeCodeFlags( mh: MediaHandler; flags: SIGNEDLONG; flagsMask: SIGNEDLONG ): HandlerError; external name '_TCSetTimeCodeFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TCGetTimeCodeFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TCGetTimeCodeFlags( mh: MediaHandler; var flags: SIGNEDLONG ): HandlerError; external name '_TCGetTimeCodeFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TCSetDisplayOptions()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TCSetDisplayOptions( mh: MediaHandler; textOptions: TCTextOptionsPtr ): HandlerError; external name '_TCSetDisplayOptions';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TCGetDisplayOptions()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TCGetDisplayOptions( mh: MediaHandler; textOptions: TCTextOptionsPtr ): HandlerError; external name '_TCGetDisplayOptions';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ The following are the 64-bit TimeCode Media API's}
{
 *  TCGetCurrentFrameAndTimeCodeDef()
 *  
 *  Summary:
 *    Retrieves the frame number and time code format information for
 *    the current movie time.
 *  
 *  Parameters:
 *    
 *    mh:
 *      The time code media handler.
 *    
 *    outFrameNum:
 *      Pointer to a field that receives the current frame number.
 *    
 *    outTCDef:
 *      Pointer to field that receives the time code format information.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function TCGetCurrentFrameAndTimeCodeDef( mh: MediaHandler; var outFrameNum: SInt64; var outTCDef: TimeCodeDef ): HandlerError; external name '_TCGetCurrentFrameAndTimeCodeDef';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  TCGetFrameAndTimeCodeDefAtTime()
 *  
 *  Summary:
 *    Retrieves the frame number and time code format information for a
 *    specific movie time.
 *  
 *  Parameters:
 *    
 *    mh:
 *      The time code media handler.
 *    
 *    mediaTime:
 *      A const pointer to the field containing the media time at which
 *      time code information is required.
 *    
 *    outFrameNum:
 *      Pointer to a field that receives the frame number at time
 *      mediaTime.
 *    
 *    outTCDef:
 *      Pointer to field that receives the time code format information.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function TCGetFrameAndTimeCodeDefAtTime( mh: MediaHandler; (*const*) var mediaTime: TimeValue64; var outFrameNum: SInt64; var outTCDef: TimeCodeDef ): HandlerError; external name '_TCGetFrameAndTimeCodeDefAtTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  TCTimeCodeTimeToString()
 *  
 *  Summary:
 *    Converts a time value into a text string in the (-) HH:MM:SS:FF
 *    format.
 *  
 *  Parameters:
 *    
 *    mh:
 *      The time code media handler.
 *    
 *    tCDef:
 *      A const pointer to a TimeCodeDef that contains time code format
 *      info for the conversion.
 *    
 *    tCTime:
 *      A const pointer to a SMPTETime structure that contains the time
 *      value to convert.
 *    
 *    outTCStr:
 *      Pointer to a CFStringRef that is to receive the converted time
 *      value. Client responsible for disposing string.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function TCTimeCodeTimeToString( mh: MediaHandler; const (*var*) tCDef: TimeCodeDef; const (*var*) tCTime: SMPTETime; var outTCStr: CFStringRef ): HandlerError; external name '_TCTimeCodeTimeToString';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  TCTimeCodeCounterToString()
 *  
 *  Summary:
 *    Converts a counter value into a text string.
 *  
 *  Parameters:
 *    
 *    mh:
 *      The time code media handler.
 *    
 *    tCDef:
 *      A const pointer to a TimeCodeDef that contains time code format
 *      info for the conversion.
 *    
 *    tCCounter:
 *      A const pointer to a TimeCode64Counter that contains the
 *      counter value to convert.
 *    
 *    outTCStr:
 *      Pointer to a CFStringRef that is to receive the converted time
 *      value. Client reponsible for disposing string.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function TCTimeCodeCounterToString( mh: MediaHandler; const (*var*) tCDef: TimeCodeDef; const (*var*) tCCounter: TimeCode64Counter; var outTCStr: CFStringRef ): HandlerError; external name '_TCTimeCodeCounterToString';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  TCTimeCodeTimeToFrameNumber()
 *  
 *  Summary:
 *    Converts a time value into its corresponding frame number.
 *  
 *  Parameters:
 *    
 *    mh:
 *      The time code media handler.
 *    
 *    tCDef:
 *      A const pointer to a TimeCodeDef that contains time code format
 *      info for the conversion.
 *    
 *    tCTime:
 *      A const pointer to a SMPTETime structure that contains the time
 *      value to convert.
 *    
 *    outFrameNum:
 *      Pointer to a field that is to receive the frame number
 *      corresponding to the time value in tCTime.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function TCTimeCodeTimeToFrameNumber( mh: MediaHandler; const (*var*) tCDef: TimeCodeDef; const (*var*) tCTime: SMPTETime; var outFrameNum: SInt64 ): HandlerError; external name '_TCTimeCodeTimeToFrameNumber';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  TCTimeCodeCounterToFrameNumber()
 *  
 *  Summary:
 *    Converts a counter value into its corresponding frame number.
 *  
 *  Parameters:
 *    
 *    mh:
 *      The time code media handler.
 *    
 *    tCDef:
 *      A const pointer to a TimeCodeDef that contains format info for
 *      the conversion.
 *    
 *    tCCounter:
 *      A const pointer to a TimeCode64Counter that contains the
 *      counter value to convert.
 *    
 *    outFrameNum:
 *      Pointer to a field that is to receive the frame number
 *      corresponding to the counter value in tCCounter.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function TCTimeCodeCounterToFrameNumber( mh: MediaHandler; const (*var*) tCDef: TimeCodeDef; const (*var*) tCCounter: TimeCode64Counter; var outFrameNum: SInt64 ): HandlerError; external name '_TCTimeCodeCounterToFrameNumber';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  TCFrameNumberToTimeCodeTime()
 *  
 *  Summary:
 *    Converts a frame number to its corresponding timecode time value.
 *  
 *  Parameters:
 *    
 *    mh:
 *      The time code media handler.
 *    
 *    frameNumber:
 *      A const pointer to the field containing the frame number that
 *      is to be converted.
 *    
 *    tCDef:
 *      A const pointer to a TimeCodeDef that contains format info for
 *      the conversion.
 *    
 *    outTCTime:
 *      Pointer to a SMPTETime structure that is to receive the time
 *      value.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function TCFrameNumberToTimeCodeTime( mh: MediaHandler; (*const*) var frameNumber: SInt64; const (*var*) tCDef: TimeCodeDef; var outTCTime: SMPTETime ): HandlerError; external name '_TCFrameNumberToTimeCodeTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  TCFrameNumberToTimeCodeCounter()
 *  
 *  Summary:
 *    Converts a frame number to its corresponding counter value.
 *  
 *  Parameters:
 *    
 *    mh:
 *      The time code media handler.
 *    
 *    frameNumber:
 *      A const pointer to the field containing the frame number that
 *      is to be converted.
 *    
 *    tCDef:
 *      A const pointer to a TimeCodeDef that contains format info for
 *      the conversion.
 *    
 *    outTCCounter:
 *      Pointer to a TimeCode64Counter that is to receive the counter
 *      value.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function TCFrameNumberToTimeCodeCounter( mh: MediaHandler; (*const*) var frameNumber: SInt64; const (*var*) tCDef: TimeCodeDef; var outTCCounter: TimeCode64Counter ): HandlerError; external name '_TCFrameNumberToTimeCodeCounter';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


type
	MovieImportComponent = ComponentInstance;
	MovieExportComponent = ComponentInstance;
const
	MovieImportType = FourCharCode('eat ');
	MovieExportType = FourCharCode('spit');

const
	canMovieImportHandles = 1 shl 0;
	canMovieImportFiles = 1 shl 1;
	hasMovieImportUserInterface = 1 shl 2;
	canMovieExportHandles = 1 shl 3;
	canMovieExportFiles = 1 shl 4;
	hasMovieExportUserInterface = 1 shl 5;
	movieImporterIsXMLBased = 1 shl 5;
	dontAutoFileMovieImport = 1 shl 6;
	canMovieExportAuxDataHandle = 1 shl 7;
	canMovieImportValidateHandles = 1 shl 8;
	canMovieImportValidateFile = 1 shl 9;
	dontRegisterWithEasyOpen = 1 shl 10;
	canMovieImportInPlace = 1 shl 11;
	movieImportSubTypeIsFileExtension = 1 shl 12;
	canMovieImportPartial = 1 shl 13;
	hasMovieImportMIMEList = 1 shl 14;
	canMovieImportAvoidBlocking = 1 shl 15;
	canMovieExportFromProcedures = 1 shl 15;
	canMovieExportValidateMovie = 1 shl 16;
	movieImportMustGetDestinationMediaType = 1 shl 16;
	movieExportNeedsResourceFork = 1 shl 17;
	canMovieImportDataReferences = 1 shl 18;
	movieExportMustGetSourceMediaType = 1 shl 19;
	canMovieImportWithIdle = 1 shl 20;
	canMovieImportValidateDataReferences = 1 shl 21;
	reservedForUseByGraphicsImporters = 1 shl 23;

const
	movieImportCreateTrack = 1;
	movieImportInParallel = 2;
	movieImportMustUseTrack = 4;
	movieImportWithIdle = 16;

const
	movieImportResultUsedMultipleTracks = 8;
	movieImportResultNeedIdles = 32;
	movieImportResultComplete = 64;

const
	kMovieExportTextOnly = 0;
	kMovieExportAbsoluteTime = 1;
	kMovieExportRelativeTime = 2;

{ Movie exporter property class}
const
	kQTPropertyClass_MovieExporter = FourCharCode('spit');

{ kPropertyClass_MovieExporter IDs}
const
	kQTMovieExporterPropertyID_EnableHighResolutionAudioFeatures = FourCharCode('hrau'); { value is Boolean}

const
	kMIDIImportSilenceBefore = 1 shl 0;
	kMIDIImportSilenceAfter = 1 shl 1;
	kMIDIImport20Playable = 1 shl 2;
	kMIDIImportWantLyrics = 1 shl 3;


const
	kQTMediaConfigResourceType = FourCharCode('mcfg');
	kQTMediaConfigResourceVersion = 2;
	kQTMediaGroupResourceType = FourCharCode('mgrp');
	kQTMediaGroupResourceVersion = 1;
	kQTBrowserInfoResourceType = FourCharCode('brws');
	kQTBrowserInfoResourceVersion = 1;


const
	kQTMediaMIMEInfoHasChanged = 1 shl 1; { the MIME type(s) is(are) new or has changed since the last time}
                                        {  someone asked about it}
	kQTMediaFileInfoHasChanged = 1 shl 2; { the file extension(s) is(are) new or has changed since the last time}
                                        {  anyone asked about it}
	kQTMediaConfigCanUseApp = 1 shl 18; { this MIME type can be configured to use app}
	kQTMediaConfigCanUsePlugin = 1 shl 19; { this MIME type can be configured to use plug-in}
	kQTMediaConfigUNUSED = 1 shl 20; { currently unused}
	kQTMediaConfigBinaryFile = 1 shl 23; { file should be transfered in binary mode}
	kQTMediaConfigTextFile = 0;    { not a bit, defined for clarity}
	kQTMediaConfigMacintoshFile = 1 shl 24; { file's resource fork is significant}
	kQTMediaConfigCanDoFileAssociation = 1 shl 26; { can configure this file association }
	kQTMediaConfigAssociateByDefault = 1 shl 27; { Deprecated, use kQTMediaConfigTakeFileAssociationByDefault instead}
	kQTMediaConfigTakeFileAssociationByDefault = 1 shl 27; { take this file association by default}
	kQTMediaConfigUseAppByDefault = 1 shl 28; { use the app by default for this MIME type}
	kQTMediaConfigUsePluginByDefault = 1 shl 29; { use the plug-in by default for this MIME type}
	kQTMediaConfigDefaultsMask = kQTMediaConfigUseAppByDefault or kQTMediaConfigUsePluginByDefault;
	kQTMediaConfigDefaultsShift = 12;   { ((flags & kQTMediaConfigDefaultsMask) >> kQTMediaConfigDefaultsShift) to get default setting }
	kQTMediaConfigHasFileHasQTAtoms = 1 shl 30; { the file has a "QuickTime like" file format }


{ mime type group constants for groupID field of 'mcfg' resource}
const
	kQTMediaConfigStreamGroupID = FourCharCode('strm');
	kQTMediaConfigInteractiveGroupID = FourCharCode('intr');
	kQTMediaConfigVideoGroupID = FourCharCode('eyes');
	kQTMediaConfigAudioGroupID = FourCharCode('ears');
	kQTMediaConfigMPEGGroupID = FourCharCode('mpeg');
	kQTMediaConfigMP3GroupID = FourCharCode('mp3 ');
	kQTMediaConfigImageGroupID = FourCharCode('ogle');
	kQTMediaConfigMiscGroupID = FourCharCode('misc');

{ file type group constants for groupID field of 'mcfg' resource}
const
	kQTMediaInfoNetGroup = FourCharCode('net ');
	kQTMediaInfoWinGroup = FourCharCode('win ');
	kQTMediaInfoMacGroup = FourCharCode('mac ');
	kQTMediaInfoMiscGroup = $3F3F3F3F; { '????'}


const
	kMimeInfoMimeTypeTag = FourCharCode('mime');
	kMimeInfoFileExtensionTag = FourCharCode('ext ');
	kMimeInfoDescriptionTag = FourCharCode('desc');
	kMimeInfoGroupTag = FourCharCode('grop');
	kMimeInfoDoNotOverrideExistingFileTypeAssociation = FourCharCode('nofa');

const
	kQTFileTypeAIFF = FourCharCode('AIFF');
	kQTFileTypeAIFC = FourCharCode('AIFC');
	kQTFileTypeDVC = FourCharCode('dvc!');
	kQTFileTypeMIDI = FourCharCode('Midi');
	kQTFileTypePicture = FourCharCode('PICT');
	kQTFileTypeMovie = FourCharCode('MooV');
	kQTFileTypeText = FourCharCode('TEXT');
	kQTFileTypeWave = FourCharCode('WAVE');
	kQTFileTypeSystemSevenSound = FourCharCode('sfil');
	kQTFileTypeMuLaw = FourCharCode('ULAW');
	kQTFileTypeAVI = FourCharCode('VfW ');
	kQTFileTypeSoundDesignerII = FourCharCode('Sd2f');
	kQTFileTypeAudioCDTrack = FourCharCode('trak');
	kQTFileTypePICS = FourCharCode('PICS');
	kQTFileTypeGIF = FourCharCode('GIFf');
	kQTFileTypePNG = FourCharCode('PNGf');
	kQTFileTypeTIFF = FourCharCode('TIFF');
	kQTFileTypePhotoShop = FourCharCode('8BPS');
	kQTFileTypeSGIImage = FourCharCode('.SGI');
	kQTFileTypeBMP = FourCharCode('BMPf');
	kQTFileTypeJPEG = FourCharCode('JPEG');
	kQTFileTypeJFIF = FourCharCode('JPEG');
	kQTFileTypeMacPaint = FourCharCode('PNTG');
	kQTFileTypeTargaImage = FourCharCode('TPIC');
	kQTFileTypeQuickDrawGXPicture = FourCharCode('qdgx');
	kQTFileTypeQuickTimeImage = FourCharCode('qtif');
	kQTFileType3DMF = FourCharCode('3DMF');
	kQTFileTypeFLC = FourCharCode('FLC ');
	kQTFileTypeFlash = FourCharCode('SWFL');
	kQTFileTypeFlashPix = FourCharCode('FPix');
	kQTFileTypeMP4 = FourCharCode('mpg4');
	kQTFileTypePDF = FourCharCode('PDF ');
	kQTFileType3GPP = FourCharCode('3gpp');
	kQTFileTypeAMR = FourCharCode('amr ');
	kQTFileTypeSDV = FourCharCode('sdv ');
	kQTFileType3GP2 = FourCharCode('3gp2');
	kQTFileTypeAMC = FourCharCode('amc ');
	kQTFileTypeJPEG2000 = FourCharCode('jp2 ');

{ QTAtomTypes for atoms in import/export settings containers}
const
	kQTSettingsDVExportNTSC = FourCharCode('dvcv'); { True is export as NTSC, false is export as PAL. (Boolean)}
	kQTSettingsDVExportLockedAudio = FourCharCode('lock'); { True if audio locked to video. (Boolean)}
	kQTSettingsEffect = FourCharCode('effe'); { Parent atom whose contents are atoms of an effects description}
	kQTSettingsGraphicsFileImportSequence = FourCharCode('sequ'); { Parent atom of graphic file movie import component}
	kQTSettingsGraphicsFileImportSequenceEnabled = FourCharCode('enab'); { . If true, import numbered image sequence (Boolean)}
	kQTSettingsMovieExportEnableVideo = FourCharCode('envi'); { Enable exporting of video track (Boolean)}
	kQTSettingsMovieExportEnableSound = FourCharCode('enso'); { Enable exporting of sound track (Boolean)}
	kQTSettingsMovieExportSaveOptions = FourCharCode('save'); { Parent atom of save options}
	kQTSettingsMovieExportSaveForInternet = FourCharCode('fast'); { . Save for Internet}
	kQTSettingsMovieExportSaveCompressedMovie = FourCharCode('cmpm'); { . Save compressed movie resource}
	kQTSettingsMIDI = FourCharCode('MIDI'); { MIDI import related container}
	kQTSettingsMIDISettingFlags = FourCharCode('sttg'); { . MIDI import settings (UInt32)}
	kQTSettingsText = FourCharCode('text'); { Text related container}
	kQTSettingsTextDescription = FourCharCode('desc'); { . Text import settings (TextDescription record)}
	kQTSettingsTextSize = FourCharCode('size'); { . Width/height to create during import (FixedPoint)}
	kQTSettingsTextSettingFlags = FourCharCode('sttg'); { . Text export settings (UInt32)}
	kQTSettingsTextTimeFraction = FourCharCode('timf'); { . Movie time fraction for export (UInt32)}
	kQTSettingsTime = FourCharCode('time'); { Time related container}
	kQTSettingsTimeDuration = FourCharCode('dura'); { . Time related container}
	kQTSettingsAudioCDTrack = FourCharCode('trak'); { Audio CD track related container}
	kQTSettingsAudioCDTrackRateShift = FourCharCode('rshf'); { . Rate shift to be performed (SInt16)}
	kQTSettingsDVExportDVFormat = FourCharCode('dvcf'); { Exported DV Format, DV('dv  ') or DVCPRO('dvp '). (OSType)}
	kQTSettingsVideoSize = FourCharCode('isiz'); { Video size related container}
	kQTSettingsImageWidth = FourCharCode('iwdt'); { . Destination width. If this is zero, it means the source width. (SInt32)}
	kQTSettingsImageHeight = FourCharCode('ihgt'); { . Destination height. If this is zero, it means the source height. (SInt32)}
	kQTSettingsCleanAperture = FourCharCode('clap'); { . Clean aperture for compression sessions. If this is all zeros, it means no clean aperture (i.e. full width and height). (CleanApertureImageDescriptionExtension)}
	kQTSettingsPixelAspectRatio = FourCharCode('pasp'); { . Pixel aspect ratio for compression sessions. If this is all zeros, it means square pixels (i.e. 1:1). (PixelAspectRatioImageDescriptionExtension)}
	kQTSettingsScalingMode = FourCharCode('scam'); { . Scaling mode for compression sessions. If this is zero, it means scaling mode based on the source aperture mode. (OSType)}
	kQTSettingsUseCodecEnforcedDimensions = FourCharCode('uenf'); { . If true, compressor's enforced dimension overrides the image size settings. (Boolean)}
	kQTSettingsDeinterlaceSource = FourCharCode('dint'); { . If true, deinterlacing is applied to source frames. (Boolean)}


{
 *  Summary:
 *    Scaling modes
 }
const
{
   * Adjusts destination dimensions so that the source fits within the
   * dimensions specified with kQTSettingsImageWidth and
   * kQTSettingsImageHeight by fitting to the shortest side, and scales
   * the source to the destination. Internally, the default scaling
   * mode, which is based on the source aperture mode, �       is used
   * for compression session, instead of this scaling mode.
   }
	kQTSpecialScalingMode_FitWithinDimensions = FourCharCode('fit ');

type
	MovieExportGetDataParamsPtr = ^MovieExportGetDataParams;
	MovieExportGetDataParams = record
		recordSize: SIGNEDLONG;

		trackID: SIGNEDLONG;

		sourceTimeScale: TimeScale;
		requestedTime: TimeValue;
		actualTime: TimeValue;

		dataPtr: Ptr;
		dataSize: SIGNEDLONG;

		desc: SampleDescriptionHandle;
		descType: OSType;
		descSeed: SIGNEDLONG;

		requestedSampleCount: SIGNEDLONG;
		actualSampleCount: SIGNEDLONG;
		durationPerSample: TimeValue;
		sampleFlags: SIGNEDLONG;
	end;
type
	MovieExportGetDataProcPtr = function( refCon: UnivPtr; var params: MovieExportGetDataParams ): OSErr;
	MovieExportGetPropertyProcPtr = function( refcon: UnivPtr; trackID: SIGNEDLONG; propertyType: OSType; propertyValue: UnivPtr ): OSErr;
	MovieExportStageReachedCallbackProcPtr = function( inStage: OSType; inMovie: Movie; inDataHandler: ComponentInstance; inDataRef: Handle; inDataRefType: OSType; refCon: UnivPtr ): OSErr;
const
	kQTPresetsListResourceType = FourCharCode('stg#');
	kQTPresetsPlatformListResourceType = FourCharCode('stgp');

const
	kQTPresetInfoIsDivider = 1;

type
	QTPresetInfoPtr = ^QTPresetInfo;
	QTPresetInfo = record
		presetKey: OSType;              { unique key for this preset in presetsArray }
		presetFlags: UInt32;            { flags about this preset }
		settingsResourceType: OSType;   { resource type of settings resource }
		settingsResourceID: SInt16;     { resource id of settings resource }
		padding1: SInt16;
		nameStringListID: SInt16;       { name string list resource id }
		nameStringIndex: SInt16;        { name string index }
		infoStringListID: SInt16;       { info string list resource id }
		infoStringIndex: SInt16;        { info string index }
	end;
type
	QTPresetListRecordPtr = ^QTPresetListRecord;
	QTPresetListRecord = record
		flags: UInt32;                  { flags for whole list }
		count: UInt32;                  { number of elements in presetsArray }
		reserved: UInt32;
		presetsArray: array [0..0] of QTPresetInfo;        { info about each preset  }
	end;
const
	kQTMovieExportSourceInfoResourceType = FourCharCode('src#');
	kQTMovieExportSourceInfoIsMediaType = 1 shl 0;
	kQTMovieExportSourceInfoIsMediaCharacteristic = 1 shl 1;
	kQTMovieExportSourceInfoIsSourceType = 1 shl 2;

type
	QTMovieExportSourceInfoPtr = ^QTMovieExportSourceInfo;
	QTMovieExportSourceInfo = record
		mediaType: OSType;              { Media type of source }
		minCount: UInt16;               { min number of sources of this kind required, zero if none required }
		maxCount: UInt16;               { max number of sources of this kind allowed, -1 if unlimited allowed }
		flags: SIGNEDLONG;                  { reserved for flags }
	end;
type
	QTMovieExportSourceRecordPtr = ^QTMovieExportSourceRecord;
	QTMovieExportSourceRecord = record
		count: SIGNEDLONG;
		reserved: SIGNEDLONG;
		sourceArray: array [0..0] of QTMovieExportSourceInfo;
	end;
type
	MovieExportGetDataUPP = MovieExportGetDataProcPtr;
	MovieExportGetPropertyUPP = MovieExportGetPropertyProcPtr;
	MovieExportStageReachedCallbackUPP = MovieExportGetPropertyProcPtr;
{
 *  NewSCModalFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSCModalFilterUPP( userRoutine: SCModalFilterProcPtr ): SCModalFilterUPP; external name '_NewSCModalFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewSCModalHookUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSCModalHookUPP( userRoutine: SCModalHookProcPtr ): SCModalHookUPP; external name '_NewSCModalHookUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewMovieExportGetDataUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewMovieExportGetDataUPP( userRoutine: MovieExportGetDataProcPtr ): MovieExportGetDataUPP; external name '_NewMovieExportGetDataUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewMovieExportGetPropertyUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewMovieExportGetPropertyUPP( userRoutine: MovieExportGetPropertyProcPtr ): MovieExportGetPropertyUPP; external name '_NewMovieExportGetPropertyUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewMovieExportStageReachedCallbackUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewMovieExportStageReachedCallbackUPP( userRoutine: MovieExportStageReachedCallbackProcPtr ): MovieExportStageReachedCallbackUPP; external name '_NewMovieExportStageReachedCallbackUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  DisposeSCModalFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSCModalFilterUPP( userUPP: SCModalFilterUPP ); external name '_DisposeSCModalFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeSCModalHookUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSCModalHookUPP( userUPP: SCModalHookUPP ); external name '_DisposeSCModalHookUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeMovieExportGetDataUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeMovieExportGetDataUPP( userUPP: MovieExportGetDataUPP ); external name '_DisposeMovieExportGetDataUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeMovieExportGetPropertyUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeMovieExportGetPropertyUPP( userUPP: MovieExportGetPropertyUPP ); external name '_DisposeMovieExportGetPropertyUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeMovieExportStageReachedCallbackUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeMovieExportStageReachedCallbackUPP( userUPP: MovieExportStageReachedCallbackUPP ); external name '_DisposeMovieExportStageReachedCallbackUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  InvokeSCModalFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeSCModalFilterUPP( theDialog: DialogRef; var theEvent: EventRecord; var itemHit: SInt16; refcon: SIGNEDLONG; userUPP: SCModalFilterUPP ): Boolean; external name '_InvokeSCModalFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeSCModalHookUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeSCModalHookUPP( theDialog: DialogRef; itemHit: SInt16; params: UnivPtr; refcon: SIGNEDLONG; userUPP: SCModalHookUPP ): SInt16; external name '_InvokeSCModalHookUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeMovieExportGetDataUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeMovieExportGetDataUPP( refCon: UnivPtr; var params: MovieExportGetDataParams; userUPP: MovieExportGetDataUPP ): OSErr; external name '_InvokeMovieExportGetDataUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeMovieExportGetPropertyUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeMovieExportGetPropertyUPP( refcon: UnivPtr; trackID: SIGNEDLONG; propertyType: OSType; propertyValue: UnivPtr; userUPP: MovieExportGetPropertyUPP ): OSErr; external name '_InvokeMovieExportGetPropertyUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeMovieExportStageReachedCallbackUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeMovieExportStageReachedCallbackUPP( inStage: OSType; inMovie: Movie; inDataHandler: ComponentInstance; inDataRef: Handle; inDataRefType: OSType; refCon: UnivPtr; userUPP: MovieExportStageReachedCallbackUPP ): OSErr; external name '_InvokeMovieExportStageReachedCallbackUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  MovieImportHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportHandle( ci: MovieImportComponent; dataH: Handle; theMovie: Movie; targetTrack: Track; var usedTrack: Track; atTime: TimeValue; var addedDuration: TimeValue; inFlags: SIGNEDLONG; var outFlags: SIGNEDLONG ): ComponentResult; external name '_MovieImportHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportFile( ci: MovieImportComponent; const (*var*) theFile: FSSpec; theMovie: Movie; targetTrack: Track; var usedTrack: Track; atTime: TimeValue; var addedDuration: TimeValue; inFlags: SIGNEDLONG; var outFlags: SIGNEDLONG ): ComponentResult; external name '_MovieImportFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetSampleDuration()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportSetSampleDuration( ci: MovieImportComponent; duration: TimeValue; scale: TimeScale ): ComponentResult; external name '_MovieImportSetSampleDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetSampleDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportSetSampleDescription( ci: MovieImportComponent; desc: SampleDescriptionHandle; mediaType: OSType ): ComponentResult; external name '_MovieImportSetSampleDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetMediaFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportSetMediaFile( ci: MovieImportComponent; alias: AliasHandle ): ComponentResult; external name '_MovieImportSetMediaFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetDimensions()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportSetDimensions( ci: MovieImportComponent; width: Fixed; height: Fixed ): ComponentResult; external name '_MovieImportSetDimensions';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetChunkSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportSetChunkSize( ci: MovieImportComponent; chunkSize: SIGNEDLONG ): ComponentResult; external name '_MovieImportSetChunkSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetProgressProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportSetProgressProc( ci: MovieImportComponent; proc: MovieProgressUPP; refcon: SIGNEDLONG ): ComponentResult; external name '_MovieImportSetProgressProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetAuxiliaryData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportSetAuxiliaryData( ci: MovieImportComponent; data: Handle; handleType: OSType ): ComponentResult; external name '_MovieImportSetAuxiliaryData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetFromScrap()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportSetFromScrap( ci: MovieImportComponent; fromScrap: Boolean ): ComponentResult; external name '_MovieImportSetFromScrap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportDoUserDialog()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportDoUserDialog( ci: MovieImportComponent; const (*var*) theFile: FSSpec; theData: Handle; var canceled: Boolean ): ComponentResult; external name '_MovieImportDoUserDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetDuration()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportSetDuration( ci: MovieImportComponent; duration: TimeValue ): ComponentResult; external name '_MovieImportSetDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportGetAuxiliaryDataType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportGetAuxiliaryDataType( ci: MovieImportComponent; var auxType: OSType ): ComponentResult; external name '_MovieImportGetAuxiliaryDataType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportValidate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportValidate( ci: MovieImportComponent; const (*var*) theFile: FSSpec; theData: Handle; var valid: Boolean ): ComponentResult; external name '_MovieImportValidate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportGetFileType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportGetFileType( ci: MovieImportComponent; var fileType: OSType ): ComponentResult; external name '_MovieImportGetFileType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportDataRef( ci: MovieImportComponent; dataRef: Handle; dataRefType: OSType; theMovie: Movie; targetTrack: Track; var usedTrack: Track; atTime: TimeValue; var addedDuration: TimeValue; inFlags: SIGNEDLONG; var outFlags: SIGNEDLONG ): ComponentResult; external name '_MovieImportDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportGetSampleDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportGetSampleDescription( ci: MovieImportComponent; var desc: SampleDescriptionHandle; var mediaType: OSType ): ComponentResult; external name '_MovieImportGetSampleDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportGetMIMETypeList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportGetMIMETypeList( ci: MovieImportComponent; var mimeInfo: QTAtomContainer ): ComponentResult; external name '_MovieImportGetMIMETypeList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetOffsetAndLimit()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportSetOffsetAndLimit( ci: MovieImportComponent; offset: UNSIGNEDLONG; limit: UNSIGNEDLONG ): ComponentResult; external name '_MovieImportSetOffsetAndLimit';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportGetSettingsAsAtomContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportGetSettingsAsAtomContainer( ci: MovieImportComponent; var settings: QTAtomContainer ): ComponentResult; external name '_MovieImportGetSettingsAsAtomContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetSettingsFromAtomContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieImportSetSettingsFromAtomContainer( ci: MovieImportComponent; settings: QTAtomContainer ): ComponentResult; external name '_MovieImportSetSettingsFromAtomContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetOffsetAndLimit64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function MovieImportSetOffsetAndLimit64( ci: MovieImportComponent; const (*var*) offset: wide; const (*var*) limit: wide ): ComponentResult; external name '_MovieImportSetOffsetAndLimit64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportIdle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function MovieImportIdle( ci: MovieImportComponent; inFlags: SIGNEDLONG; var outFlags: SIGNEDLONG ): ComponentResult; external name '_MovieImportIdle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportValidateDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function MovieImportValidateDataRef( ci: MovieImportComponent; dataRef: Handle; dataRefType: OSType; var valid: UInt8 ): ComponentResult; external name '_MovieImportValidateDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportGetLoadState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function MovieImportGetLoadState( ci: MovieImportComponent; var importerLoadState: SIGNEDLONG ): ComponentResult; external name '_MovieImportGetLoadState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportGetMaxLoadedTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function MovieImportGetMaxLoadedTime( ci: MovieImportComponent; var time: TimeValue ): ComponentResult; external name '_MovieImportGetMaxLoadedTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportEstimateCompletionTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function MovieImportEstimateCompletionTime( ci: MovieImportComponent; var time: TimeRecord ): ComponentResult; external name '_MovieImportEstimateCompletionTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetDontBlock()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function MovieImportSetDontBlock( ci: MovieImportComponent; dontBlock: Boolean ): ComponentResult; external name '_MovieImportSetDontBlock';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportGetDontBlock()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function MovieImportGetDontBlock( ci: MovieImportComponent; var willBlock: Boolean ): ComponentResult; external name '_MovieImportGetDontBlock';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieImportSetIdleManager()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function MovieImportSetIdleManager( ci: MovieImportComponent; im: IdleManager ): ComponentResult; external name '_MovieImportSetIdleManager';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  MovieImportSetNewMovieFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function MovieImportSetNewMovieFlags( ci: MovieImportComponent; newMovieFlags: SIGNEDLONG ): ComponentResult; external name '_MovieImportSetNewMovieFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  MovieImportGetDestinationMediaType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function MovieImportGetDestinationMediaType( ci: MovieImportComponent; var mediaType: OSType ): ComponentResult; external name '_MovieImportGetDestinationMediaType';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  MovieImportSetMediaDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function MovieImportSetMediaDataRef( ci: MovieImportComponent; dataRef: Handle; dataRefType: OSType ): ComponentResult; external name '_MovieImportSetMediaDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  MovieImportDoUserDialogDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function MovieImportDoUserDialogDataRef( ci: MovieImportComponent; dataRef: Handle; dataRefType: OSType; var canceled: Boolean ): ComponentResult; external name '_MovieImportDoUserDialogDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  MovieExportToHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportToHandle( ci: MovieExportComponent; dataH: Handle; theMovie: Movie; onlyThisTrack: Track; startTime: TimeValue; duration: TimeValue ): ComponentResult; external name '_MovieExportToHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportToFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportToFile( ci: MovieExportComponent; const (*var*) theFile: FSSpec; theMovie: Movie; onlyThisTrack: Track; startTime: TimeValue; duration: TimeValue ): ComponentResult; external name '_MovieExportToFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportGetAuxiliaryData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportGetAuxiliaryData( ci: MovieExportComponent; dataH: Handle; var handleType: OSType ): ComponentResult; external name '_MovieExportGetAuxiliaryData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportSetProgressProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportSetProgressProc( ci: MovieExportComponent; proc: MovieProgressUPP; refcon: SIGNEDLONG ): ComponentResult; external name '_MovieExportSetProgressProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportSetSampleDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportSetSampleDescription( ci: MovieExportComponent; desc: SampleDescriptionHandle; mediaType: OSType ): ComponentResult; external name '_MovieExportSetSampleDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportDoUserDialog()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportDoUserDialog( ci: MovieExportComponent; theMovie: Movie; onlyThisTrack: Track; startTime: TimeValue; duration: TimeValue; var canceled: Boolean ): ComponentResult; external name '_MovieExportDoUserDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportGetCreatorType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportGetCreatorType( ci: MovieExportComponent; var creator: OSType ): ComponentResult; external name '_MovieExportGetCreatorType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportToDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportToDataRef( ci: MovieExportComponent; dataRef: Handle; dataRefType: OSType; theMovie: Movie; onlyThisTrack: Track; startTime: TimeValue; duration: TimeValue ): ComponentResult; external name '_MovieExportToDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportFromProceduresToDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportFromProceduresToDataRef( ci: MovieExportComponent; dataRef: Handle; dataRefType: OSType ): ComponentResult; external name '_MovieExportFromProceduresToDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportAddDataSource()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportAddDataSource( ci: MovieExportComponent; trackType: OSType; scale: TimeScale; var trackID: SIGNEDLONG; getPropertyProc: MovieExportGetPropertyUPP; getDataProc: MovieExportGetDataUPP; refCon: UnivPtr ): ComponentResult; external name '_MovieExportAddDataSource';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportValidate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportValidate( ci: MovieExportComponent; theMovie: Movie; onlyThisTrack: Track; var valid: Boolean ): ComponentResult; external name '_MovieExportValidate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportGetSettingsAsAtomContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportGetSettingsAsAtomContainer( ci: MovieExportComponent; var settings: QTAtomContainer ): ComponentResult; external name '_MovieExportGetSettingsAsAtomContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportSetSettingsFromAtomContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportSetSettingsFromAtomContainer( ci: MovieExportComponent; settings: QTAtomContainer ): ComponentResult; external name '_MovieExportSetSettingsFromAtomContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportGetFileNameExtension()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportGetFileNameExtension( ci: MovieExportComponent; var extension: OSType ): ComponentResult; external name '_MovieExportGetFileNameExtension';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportGetShortFileTypeString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportGetShortFileTypeString( ci: MovieExportComponent; var typeString: Str255 ): ComponentResult; external name '_MovieExportGetShortFileTypeString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportGetSourceMediaType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportGetSourceMediaType( ci: MovieExportComponent; var mediaType: OSType ): ComponentResult; external name '_MovieExportGetSourceMediaType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportSetGetMoviePropertyProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function MovieExportSetGetMoviePropertyProc( ci: MovieExportComponent; getPropertyProc: MovieExportGetPropertyUPP; refCon: UnivPtr ): ComponentResult; external name '_MovieExportSetGetMoviePropertyProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Text Export Display Info data structure}
type
	TextDisplayData = record
		displayFlags: SIGNEDLONG;
		textJustification: SIGNEDLONG;
		bgColor: RGBColor;
		textBox: Rect;

		beginHilite: SInt16;
		endHilite: SInt16;
		hiliteColor: RGBColor;
		doHiliteColor: Boolean;
		filler: SInt8;
		scrollDelayDur: TimeValue;
		dropShadowOffset: Point;
		dropShadowTransparency: SInt16;
	end;

type
	TextExportComponent = ComponentInstance;
	GraphicImageMovieImportComponent = ComponentInstance;
{
 *  TextExportGetDisplayData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TextExportGetDisplayData( ci: TextExportComponent; var textDisplay: TextDisplayData ): ComponentResult; external name '_TextExportGetDisplayData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TextExportGetTimeFraction()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TextExportGetTimeFraction( ci: TextExportComponent; var movieTimeFraction: SIGNEDLONG ): ComponentResult; external name '_TextExportGetTimeFraction';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TextExportSetTimeFraction()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TextExportSetTimeFraction( ci: TextExportComponent; movieTimeFraction: SIGNEDLONG ): ComponentResult; external name '_TextExportSetTimeFraction';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TextExportGetSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TextExportGetSettings( ci: TextExportComponent; var setting: SIGNEDLONG ): ComponentResult; external name '_TextExportGetSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TextExportSetSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TextExportSetSettings( ci: TextExportComponent; setting: SIGNEDLONG ): ComponentResult; external name '_TextExportSetSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MIDIImportGetSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MIDIImportGetSettings( ci: TextExportComponent; var setting: SIGNEDLONG ): ComponentResult; external name '_MIDIImportGetSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MIDIImportSetSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MIDIImportSetSettings( ci: TextExportComponent; setting: SIGNEDLONG ): ComponentResult; external name '_MIDIImportSetSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportNewGetDataAndPropertiesProcs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportNewGetDataAndPropertiesProcs( ci: MovieExportComponent; trackType: OSType; var scale: TimeScale; theMovie: Movie; theTrack: Track; startTime: TimeValue; duration: TimeValue; var getPropertyProc: MovieExportGetPropertyUPP; var getDataProc: MovieExportGetDataUPP; var refCon: UnivPtr ): ComponentResult; external name '_MovieExportNewGetDataAndPropertiesProcs';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExportDisposeGetDataAndPropertiesProcs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieExportDisposeGetDataAndPropertiesProcs( ci: MovieExportComponent; getPropertyProc: MovieExportGetPropertyUPP; getDataProc: MovieExportGetDataUPP; refCon: UnivPtr ): ComponentResult; external name '_MovieExportDisposeGetDataAndPropertiesProcs';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	movieExportUseConfiguredSettings = FourCharCode('ucfg'); { pointer to Boolean}
	movieExportWidth = FourCharCode('wdth'); { pointer to Fixed}
	movieExportHeight = FourCharCode('hegt'); { pointer to Fixed}
	movieExportDuration = FourCharCode('dura'); { pointer to TimeRecord}
	movieExportVideoFilter = FourCharCode('iflt'); { pointer to QTAtomContainer}
	movieExportTimeScale = FourCharCode('tmsc'); { pointer to TimeScale}
	movieExportSourceApertureMode = FourCharCode('srap'); { pointer to OSType. Source movie's aperture mode.�Set the aperture mode on the decompression session.}

{ Component Properties specific to Movie Export components}
const
	kQTMovieExporterPropertyID_StageReachedCallback = FourCharCode('stgr'); { value is a MovieExportStageReachedCallbackProcRecord}
	kQTMovieExporterPropertyID_DeinterlaceVideo = FourCharCode('dint'); { value is a Boolean }

{ Stages passed to MovieExportStageReachedCallbackProc}
const
	kQTMovieExportStage_EmptyMovieCreated = FourCharCode('empt');
	kQTMovieExportStage_AllTracksAddedToMovie = FourCharCode('trax');

type
	MovieExportStageReachedCallbackProcRecord = record
		stageReachedCallbackProc: MovieExportStageReachedCallbackUPP;
		stageReachedCallbackRefCon: UnivPtr;
	end;
{
 *  GraphicsImageImportSetSequenceEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImageImportSetSequenceEnabled( ci: GraphicImageMovieImportComponent; enable: Boolean ): ComponentResult; external name '_GraphicsImageImportSetSequenceEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GraphicsImageImportGetSequenceEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GraphicsImageImportGetSequenceEnabled( ci: GraphicImageMovieImportComponent; var enable: Boolean ): ComponentResult; external name '_GraphicsImageImportGetSequenceEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{----------------------------'brws' � browser prefs configuration info ------------------------}
const
	kQTBrowserInfoCanUseSystemFolderPlugin = 1 shl 0; { Mac browser can use plug-in from System "Internet Plug-ins" folder }


const
	kQTPreFlightOpenComponent = 1 shl 1; { Open component as preflight check}

type
	ComponentPreflightFlagsPtr = ^ComponentPreflightFlags;
	ComponentPreflightFlags = record
		flags: SIGNEDLONG;
	end;


{**************

    File Preview Components

**************}

type
	pnotComponent = ComponentInstance;
const
	pnotComponentWantsEvents = 1;
	pnotComponentNeedsNoCache = 2;

const
	ShowFilePreviewComponentType = FourCharCode('pnot');
	CreateFilePreviewComponentType = FourCharCode('pmak');

{
 *  PreviewShowData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PreviewShowData( p: pnotComponent; dataType: OSType; data: Handle; const (*var*) inHere: Rect ): ComponentResult; external name '_PreviewShowData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PreviewMakePreview()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PreviewMakePreview( p: pnotComponent; var previewType: OSType; var previewResult: Handle; const (*var*) sourceFile: FSSpec; progress: ICMProgressProcRecordPtr ): ComponentResult; external name '_PreviewMakePreview';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PreviewMakePreviewReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PreviewMakePreviewReference( p: pnotComponent; var previewType: OSType; var resID: SInt16; const (*var*) sourceFile: FSSpec ): ComponentResult; external name '_PreviewMakePreviewReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PreviewEvent()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PreviewEvent( p: pnotComponent; var e: EventRecord; var handledEvent: Boolean ): ComponentResult; external name '_PreviewEvent';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


type
	DataCompressorComponent = ComponentInstance;
	DataDecompressorComponent = ComponentInstance;
	DataCodecComponent = ComponentInstance;
const
	DataCompressorComponentType = FourCharCode('dcom');
	DataDecompressorComponentType = FourCharCode('ddec');
	AppleDataCompressorSubType = FourCharCode('adec');
	zlibDataCompressorSubType = FourCharCode('zlib');


{* These are DataCodec procedures *}
{
 *  DataCodecDecompress()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataCodecDecompress( dc: DataCodecComponent; srcData: UnivPtr; srcSize: UInt32; dstData: UnivPtr; dstBufferSize: UInt32 ): ComponentResult; external name '_DataCodecDecompress';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataCodecGetCompressBufferSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataCodecGetCompressBufferSize( dc: DataCodecComponent; srcSize: UInt32; var dstSize: UInt32 ): ComponentResult; external name '_DataCodecGetCompressBufferSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataCodecCompress()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataCodecCompress( dc: DataCodecComponent; srcData: UnivPtr; srcSize: UInt32; dstData: UnivPtr; dstBufferSize: UInt32; var actualDstSize: UInt32; var decompressSlop: UInt32 ): ComponentResult; external name '_DataCodecCompress';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataCodecBeginInterruptSafe()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataCodecBeginInterruptSafe( dc: DataCodecComponent; maxSrcSize: UNSIGNEDLONG ): ComponentResult; external name '_DataCodecBeginInterruptSafe';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataCodecEndInterruptSafe()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataCodecEndInterruptSafe( dc: DataCodecComponent ): ComponentResult; external name '_DataCodecEndInterruptSafe';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataCodecDecompressPartial()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataCodecDecompressPartial( dc: DataCodecComponent; var next_in: UnivPtr; var avail_in: UNSIGNEDLONG; var total_in: UNSIGNEDLONG; var next_out: UnivPtr; var avail_out: UNSIGNEDLONG; var total_out: UNSIGNEDLONG; var didFinish: Boolean ): ComponentResult; external name '_DataCodecDecompressPartial';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataCodecCompressPartial()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataCodecCompressPartial(dc: DataCodecComponent; var next_in: UnivPtr; var avail_in: UNSIGNEDLONG; var total_in: UNSIGNEDLONG; var next_out: UnivPtr; var avail_out: UNSIGNEDLONG; var total_out: UNSIGNEDLONG; tryToFinish: boolean; var didFinish: boolean): ComponentResult; external name '_DataCodecCompressPartial';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


type
	DataHCompletionProcPtr = procedure( request: Ptr; refcon: SIGNEDLONG; err: OSErr );
	DataHCompletionUPP = DataHCompletionProcPtr;

const
	kDataHCanRead = 1 shl 0;
	kDataHSpecialRead = 1 shl 1;
	kDataHSpecialReadFile = 1 shl 2;
	kDataHCanWrite = 1 shl 3;
	kDataHSpecialWrite = 1 shl 4;
	kDataHSpecialWriteFile = 1 shl 5;
	kDataHCanStreamingWrite = 1 shl 6;
	kDataHMustCheckDataRef = 1 shl 7;

{ Data reference records for specific data ref types}
type
	HandleDataRefRecordPtr = ^HandleDataRefRecord;
	HandleDataRefRecord = record
		dataHndl: Handle;
	end;
type
	HandleDataRefPtr = HandleDataRefRecordPtr;
	HandleDataRef = ^HandleDataRefPtr;
	PointerDataRefRecordPtr = ^PointerDataRefRecord;
	PointerDataRefRecord = record
		data: UnivPtr;
		dataLength: Size;
	end;
type
	PointerDataRefPtr = PointerDataRefRecordPtr;
	PointerDataRef = ^PointerDataRefPtr;
{ Data reference extensions}
const
	kDataRefExtensionChokeSpeed = FourCharCode('chok');
	kDataRefExtensionFileName = FourCharCode('fnam');
	kDataRefExtensionMIMEType = FourCharCode('mime');
	kDataRefExtensionMacOSFileType = FourCharCode('ftyp');
	kDataRefExtensionInitializationData = FourCharCode('data');
	kDataRefExtensionQuickTimeMediaType = FourCharCode('mtyp');

const
	kDataHChokeToMovieDataRate = 1 shl 0; { param is 0}
	kDataHChokeToParam = 1 shl 1; { param is bytes per second}

type
	DataHChokeAtomRecordPtr = ^DataHChokeAtomRecord;
	DataHChokeAtomRecord = record
		flags: SIGNEDLONG;                  { one of kDataHChokeTo constants}
		param: SIGNEDLONG;
	end;

type
	DataHVolumeListRecordPtr = ^DataHVolumeListRecord;
	DataHVolumeListRecord = record
		vRefNum: SInt16;
		flags: SIGNEDLONG;
	end;
type
	DataHVolumeListPtr = DataHVolumeListRecordPtr;
	DataHVolumeList = ^DataHVolumeListPtr;
const
	kDataHExtendedSchedule = FourCharCode('xtnd');

type
	DataHScheduleRecordPtr = ^DataHScheduleRecord;
	DataHScheduleRecord = record
		timeNeededBy: TimeRecord;
		extendedID: SIGNEDLONG;             { always is kDataHExtendedSchedule}
		extendedVers: SIGNEDLONG;           { always set to 0}
		priority: Fixed;               { 100.0 or more means must have. lower numbers�}
	end;
type
	DataHSchedulePtr = DataHScheduleRecordPtr;
{ Flags for DataHGetInfoFlags}
const
	kDataHInfoFlagNeverStreams = 1 shl 0; { set if this data handler doesn't stream}
	kDataHInfoFlagCanUpdateDataRefs = 1 shl 1; { set if this data handler might update data reference}
	kDataHInfoFlagNeedsNetworkBandwidth = 1 shl 2; { set if this data handler may need to occupy the network}


{ Types for DataHGetFileTypeOrdering}
const
	kDataHFileTypeMacOSFileType = FourCharCode('ftyp');
	kDataHFileTypeExtension = FourCharCode('fext');
	kDataHFileTypeMIME = FourCharCode('mime');

type
	DataHFileTypeOrderingPtr = OSTypePtr;
	DataHFileTypeOrderingHandle = ^DataHFileTypeOrderingPtr;

{
 *  DataHGetData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetData( dh: DataHandler; h: Handle; hOffset: SIGNEDLONG; offset: SIGNEDLONG; size: SIGNEDLONG ): ComponentResult; external name '_DataHGetData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHPutData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHPutData( dh: DataHandler; h: Handle; hOffset: SIGNEDLONG; var offset: SIGNEDLONG; size: SIGNEDLONG ): ComponentResult; external name '_DataHPutData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHFlushData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHFlushData( dh: DataHandler ): ComponentResult; external name '_DataHFlushData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHOpenForWrite()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHOpenForWrite( dh: DataHandler ): ComponentResult; external name '_DataHOpenForWrite';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHCloseForWrite()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHCloseForWrite( dh: DataHandler ): ComponentResult; external name '_DataHCloseForWrite';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHOpenForRead()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHOpenForRead( dh: DataHandler ): ComponentResult; external name '_DataHOpenForRead';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHCloseForRead()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHCloseForRead( dh: DataHandler ): ComponentResult; external name '_DataHCloseForRead';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHSetDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHSetDataRef( dh: DataHandler; dataRef: Handle ): ComponentResult; external name '_DataHSetDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetDataRef( dh: DataHandler; var dataRef: Handle ): ComponentResult; external name '_DataHGetDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHCompareDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHCompareDataRef( dh: DataHandler; dataRef: Handle; var equal: Boolean ): ComponentResult; external name '_DataHCompareDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHTask()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHTask( dh: DataHandler ): ComponentResult; external name '_DataHTask';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHScheduleData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHScheduleData( dh: DataHandler; PlaceToPutDataPtr: Ptr; FileOffset: SIGNEDLONG; DataSize: SIGNEDLONG; RefCon: SIGNEDLONG; scheduleRec: DataHSchedulePtr; CompletionRtn: DataHCompletionUPP ): ComponentResult; external name '_DataHScheduleData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHFinishData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHFinishData( dh: DataHandler; PlaceToPutDataPtr: Ptr; Cancel: Boolean ): ComponentResult; external name '_DataHFinishData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHFlushCache()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHFlushCache( dh: DataHandler ): ComponentResult; external name '_DataHFlushCache';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHResolveDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHResolveDataRef( dh: DataHandler; theDataRef: Handle; var wasChanged: Boolean; userInterfaceAllowed: Boolean ): ComponentResult; external name '_DataHResolveDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetFileSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetFileSize( dh: DataHandler; var fileSize: SIGNEDLONG ): ComponentResult; external name '_DataHGetFileSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHCanUseDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
  *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHCanUseDataRef( dh: DataHandler; dataRef: Handle; var useFlags: SIGNEDLONG ): ComponentResult; external name '_DataHCanUseDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetVolumeList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetVolumeList( dh: DataHandler; var volumeList: DataHVolumeList ): ComponentResult; external name '_DataHGetVolumeList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHWrite()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHWrite( dh: DataHandler; data: Ptr; offset: SIGNEDLONG; size: SIGNEDLONG; completion: DataHCompletionUPP; refCon: SIGNEDLONG ): ComponentResult; external name '_DataHWrite';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHPreextend()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHPreextend( dh: DataHandler; maxToAdd: UNSIGNEDLONG; var spaceAdded: UNSIGNEDLONG ): ComponentResult; external name '_DataHPreextend';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHSetFileSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHSetFileSize( dh: DataHandler; fileSize: SIGNEDLONG ): ComponentResult; external name '_DataHSetFileSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetFreeSpace()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetFreeSpace( dh: DataHandler; var freeSize: UNSIGNEDLONG ): ComponentResult; external name '_DataHGetFreeSpace';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHCreateFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHCreateFile( dh: DataHandler; creator: OSType; deleteExisting: Boolean ): ComponentResult; external name '_DataHCreateFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetPreferredBlockSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetPreferredBlockSize( dh: DataHandler; var blockSize: SIGNEDLONG ): ComponentResult; external name '_DataHGetPreferredBlockSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetDeviceIndex()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetDeviceIndex( dh: DataHandler; var deviceIndex: SIGNEDLONG ): ComponentResult; external name '_DataHGetDeviceIndex';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHIsStreamingDataHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHIsStreamingDataHandler( dh: DataHandler; var yes: Boolean ): ComponentResult; external name '_DataHIsStreamingDataHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetDataInBuffer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetDataInBuffer( dh: DataHandler; startOffset: SIGNEDLONG; var size: SIGNEDLONG ): ComponentResult; external name '_DataHGetDataInBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetScheduleAheadTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetScheduleAheadTime( dh: DataHandler; var millisecs: SIGNEDLONG ): ComponentResult; external name '_DataHGetScheduleAheadTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHSetCacheSizeLimit()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHSetCacheSizeLimit( dh: DataHandler; cacheSizeLimit: Size ): ComponentResult; external name '_DataHSetCacheSizeLimit';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetCacheSizeLimit()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetCacheSizeLimit( dh: DataHandler; var cacheSizeLimit: Size ): ComponentResult; external name '_DataHGetCacheSizeLimit';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetMovie( dh: DataHandler; var theMovie: Movie; var id: SInt16 ): ComponentResult; external name '_DataHGetMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHAddMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHAddMovie( dh: DataHandler; theMovie: Movie; var id: SInt16 ): ComponentResult; external name '_DataHAddMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHUpdateMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHUpdateMovie( dh: DataHandler; theMovie: Movie; id: SInt16 ): ComponentResult; external name '_DataHUpdateMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHDoesBuffer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHDoesBuffer( dh: DataHandler; var buffersReads: Boolean; var buffersWrites: Boolean ): ComponentResult; external name '_DataHDoesBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetFileName()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetFileName( dh: DataHandler; var str: Str255 ): ComponentResult; external name '_DataHGetFileName';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetAvailableFileSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetAvailableFileSize( dh: DataHandler; var fileSize: SIGNEDLONG ): ComponentResult; external name '_DataHGetAvailableFileSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetMacOSFileType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetMacOSFileType( dh: DataHandler; var fileType: OSType ): ComponentResult; external name '_DataHGetMacOSFileType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetMIMEType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetMIMEType( dh: DataHandler; var mimeType: Str255 ): ComponentResult; external name '_DataHGetMIMEType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHSetDataRefWithAnchor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHSetDataRefWithAnchor( dh: DataHandler; anchorDataRef: Handle; dataRefType: OSType; dataRef: Handle ): ComponentResult; external name '_DataHSetDataRefWithAnchor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetDataRefWithAnchor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHGetDataRefWithAnchor( dh: DataHandler; anchorDataRef: Handle; dataRefType: OSType; var dataRef: Handle ): ComponentResult; external name '_DataHGetDataRefWithAnchor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHSetMacOSFileType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHSetMacOSFileType( dh: DataHandler; fileType: OSType ): ComponentResult; external name '_DataHSetMacOSFileType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHSetTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHSetTimeBase( dh: DataHandler; tb: TimeBase ): ComponentResult; external name '_DataHSetTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetInfoFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function DataHGetInfoFlags( dh: DataHandler; var flags: UInt32 ): ComponentResult; external name '_DataHGetInfoFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHScheduleData64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function DataHScheduleData64( dh: DataHandler; PlaceToPutDataPtr: Ptr; const (*var*) FileOffset: wide; DataSize: SIGNEDLONG; RefCon: SIGNEDLONG; scheduleRec: DataHSchedulePtr; CompletionRtn: DataHCompletionUPP ): ComponentResult; external name '_DataHScheduleData64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHWrite64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function DataHWrite64( dh: DataHandler; data: Ptr; const (*var*) offset: wide; size: SIGNEDLONG; completion: DataHCompletionUPP; refCon: SIGNEDLONG ): ComponentResult; external name '_DataHWrite64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetFileSize64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function DataHGetFileSize64( dh: DataHandler; var fileSize: wide ): ComponentResult; external name '_DataHGetFileSize64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHPreextend64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function DataHPreextend64( dh: DataHandler; const (*var*) maxToAdd: wide; var spaceAdded: wide ): ComponentResult; external name '_DataHPreextend64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHSetFileSize64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function DataHSetFileSize64( dh: DataHandler; const (*var*) fileSize: wide ): ComponentResult; external name '_DataHSetFileSize64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetFreeSpace64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function DataHGetFreeSpace64( dh: DataHandler; var freeSize: wide ): ComponentResult; external name '_DataHGetFreeSpace64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHAppend64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function DataHAppend64( dh: DataHandler; data: UnivPtr; var fileOffset: wide; size: UNSIGNEDLONG ): ComponentResult; external name '_DataHAppend64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHReadAsync()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function DataHReadAsync( dh: DataHandler; dataPtr: UnivPtr; dataSize: UInt32; const (*var*) dataOffset: wide; completion: DataHCompletionUPP; refCon: SIGNEDLONG ): ComponentResult; external name '_DataHReadAsync';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHPollRead()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function DataHPollRead( dh: DataHandler; dataPtr: UnivPtr; var dataSizeSoFar: UInt32 ): ComponentResult; external name '_DataHPollRead';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetDataAvailability()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function DataHGetDataAvailability( dh: DataHandler; offset: SIGNEDLONG; len: SIGNEDLONG; var missing_offset: SIGNEDLONG; var missing_len: SIGNEDLONG ): ComponentResult; external name '_DataHGetDataAvailability';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetFileSizeAsync()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function DataHGetFileSizeAsync( dh: DataHandler; var fileSize: wide; completionRtn: DataHCompletionUPP; refCon: SIGNEDLONG ): ComponentResult; external name '_DataHGetFileSizeAsync';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetDataRefAsType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function DataHGetDataRefAsType( dh: DataHandler; requestedType: OSType; var dataRef: Handle ): ComponentResult; external name '_DataHGetDataRefAsType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHSetDataRefExtension()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function DataHSetDataRefExtension( dh: DataHandler; extension: Handle; idType: OSType ): ComponentResult; external name '_DataHSetDataRefExtension';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetDataRefExtension()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function DataHGetDataRefExtension( dh: DataHandler; var extension: Handle; idType: OSType ): ComponentResult; external name '_DataHGetDataRefExtension';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetMovieWithFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function DataHGetMovieWithFlags( dh: DataHandler; var theMovie: Movie; var id: SInt16; flags: SInt16 ): ComponentResult; external name '_DataHGetMovieWithFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetFileTypeOrdering()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function DataHGetFileTypeOrdering( dh: DataHandler; var orderingListHandle: DataHFileTypeOrderingHandle ): ComponentResult; external name '_DataHGetFileTypeOrdering';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ flags for DataHCreateFileWithFlags}
const
	kDataHCreateFileButDontCreateResFile = 1 shl 0;

{
 *  DataHCreateFileWithFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function DataHCreateFileWithFlags( dh: DataHandler; creator: OSType; deleteExisting: Boolean; flags: UInt32 ): ComponentResult; external name '_DataHCreateFileWithFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetMIMETypeAsync()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function DataHGetMIMETypeAsync( dh: DataHandler; var mimeType: Str255; completionRtn: DataHCompletionUPP; refCon: SIGNEDLONG ): ComponentResult; external name '_DataHGetMIMETypeAsync';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHGetInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.1 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0.1 and later
 *    Windows:          in qtmlClient.lib 5.0.1 and later
 }
function DataHGetInfo( dh: DataHandler; what: OSType; info: UnivPtr ): ComponentResult; external name '_DataHGetInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_1_AND_LATER *)


{
 *  DataHSetIdleManager()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function DataHSetIdleManager( dh: DataHandler; im: IdleManager ): ComponentResult; external name '_DataHSetIdleManager';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  DataHDeleteFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function DataHDeleteFile( dh: DataHandler ): ComponentResult; external name '_DataHDeleteFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


const
	kDataHMovieUsageDoAppendMDAT = 1 shl 0; { if set, datahandler should append wide and mdat atoms in append call}

{
 *  DataHSetMovieUsageFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function DataHSetMovieUsageFlags( dh: DataHandler; flags: SIGNEDLONG ): ComponentResult; external name '_DataHSetMovieUsageFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


const
	kDataHTempUseSameDirectory = 1 shl 0; { temp data ref should be in same directory as current data ref (vs. in temporary directory)}
	kDataHTempUseSameVolume = 1 shl 1; { temp data ref should be on same volume as current data ref (vs. find "best" volume)}
	kDataHTempCreateFile = 1 shl 2; { create the file}
	kDataHTempOpenFile = 1 shl 3; { open temporary file for write (kDataHTempCreateFile must be passed, too)}

{
 *  DataHUseTemporaryDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function DataHUseTemporaryDataRef( dh: DataHandler; inFlags: SIGNEDLONG ): ComponentResult; external name '_DataHUseTemporaryDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  DataHGetTemporaryDataRefCapabilities()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function DataHGetTemporaryDataRefCapabilities( dh: DataHandler; var outUnderstoodFlags: SIGNEDLONG ): ComponentResult; external name '_DataHGetTemporaryDataRefCapabilities';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  DataHRenameFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function DataHRenameFile( dh: DataHandler; newDataRef: Handle ): ComponentResult; external name '_DataHRenameFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{ selector 74 skipped }
{ selector 75 skipped }
{ selector 76 skipped }
{ selector 77 skipped }
{
 *  DataHGetAvailableFileSize64()
 *  
 *  Summary:
 *    Returns the amount of contiguous data from the start of the file
 *    that's currently available for reading.
 *  
 *  Discussion:
 *    The 64-bit variant of DataHGetAvailableFileSize. Note that all
 *    data handlers that support fast-start playback, e.g. an http data
 *    handler, must implement DataHGetAvailableFileSize. Those that
 *    support files larger than 2 GB must also implement
 *    DataHGetAvailableFileSize64.
 *  
 *  Parameters:
 *    
 *    dh:
 *      Component instance / instance globals.
 *    
 *    fileSize:
 *      Points to a variable to receive the amount of contiguous data
 *      from the start of the file that's currently available for
 *      reading.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function DataHGetAvailableFileSize64( dh: DataHandler; var fileSize: wide ): ComponentResult; external name '_DataHGetAvailableFileSize64';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  DataHGetDataAvailability64()
 *  
 *  Summary:
 *    Checks the availability of the specified range of data and
 *    returns the first range of missing data needed to satisfy a read
 *    request. Returns an empty range starting at the end of the
 *    specified range when a read request for the specified range can
 *    be satisfied immediately.
 *  
 *  Discussion:
 *    The 64-bit variant of DataHGetDataAvailability. Note that all
 *    data handlers that support fast-start playback, e.g. an http data
 *    handler, should implement DataHGetDataAvailability. Those that
 *    support files larger than 2 GB should also implement
 *    DataHGetDataAvailability64.
 *  
 *  Parameters:
 *    
 *    dh:
 *      Component instance / instance globals.
 *    
 *    offset:
 *      The start of the requested range of data.
 *    
 *    len:
 *      The length of the requested range of data.
 *    
 *    missing_offset:
 *      The offset from the start of the file of the first byte of data
 *      within the requested range that's not yet available. If the
 *      entire range is available, the offset returned is the offset of
 *      the first byte after the requested range.
 *    
 *    missing_len:
 *      The length of the range of data starting at missing_offset
 *      that's not yet available. If the entire range of data is
 *      available, the length returned is 0.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function DataHGetDataAvailability64( dh: DataHandler; const (*var*) offset: wide; len: SIGNEDLONG; var missing_offset: wide; var missing_len: SIGNEDLONG ): ComponentResult; external name '_DataHGetDataAvailability64';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ selector 80 skipped }
{ selector 81 skipped }
{
 *  DataHPlaybackHints()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DataHPlaybackHints( dh: DataHandler; flags: SIGNEDLONG; minFileOffset: UNSIGNEDLONG; maxFileOffset: UNSIGNEDLONG; bytesPerSecond: SIGNEDLONG ): ComponentResult; external name '_DataHPlaybackHints';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DataHPlaybackHints64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function DataHPlaybackHints64( dh: DataHandler; flags: SIGNEDLONG; const (*var*) minFileOffset: wide; const (*var*) maxFileOffset: wide; bytesPerSecond: SIGNEDLONG ): ComponentResult; external name '_DataHPlaybackHints64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Symbolic constants for DataHGetDataRate}
const
	kDataHGetDataRateInfiniteRate = $7FFFFFFF; { all the data arrived instantaneously}

{
 *  DataHGetDataRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function DataHGetDataRate( dh: DataHandler; flags: SIGNEDLONG; var bytesPerSecond: SIGNEDLONG ): ComponentResult; external name '_DataHGetDataRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Flags for DataHSetTimeHints}
const
	kDataHSetTimeHintsSkipBandwidthRequest = 1 shl 0; { set if this data handler should use the network without requesting bandwidth}

{
 *  DataHSetTimeHints()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function DataHSetTimeHints( dh: DataHandler; flags: SIGNEDLONG; bandwidthPriority: SIGNEDLONG; scale: TimeScale; minTime: TimeValue; maxTime: TimeValue ): ComponentResult; external name '_DataHSetTimeHints';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Standard type for video digitizers }
const
	videoDigitizerComponentType = FourCharCode('vdig');
	vdigInterfaceRev = 2;

{ Input Format Standards }
const
	ntscIn = 0;    { current input format }
	currentIn = 0;    { ntsc input format }
	palIn = 1;    { pal input format }
	secamIn = 2;    { secam input format }
	ntscReallyIn = 3;     { ntsc input format }

{ Input Formats }
const
	compositeIn = 0;    { input is composite format }
	sVideoIn = 1;    { input is sVideo format }
	rgbComponentIn = 2;    { input is rgb component format }
	rgbComponentSyncIn = 3;    { input is rgb component format (sync on green?)}
	yuvComponentIn = 4;    { input is yuv component format }
	yuvComponentSyncIn = 5;    { input is yuv component format (sync on green?) }
	tvTunerIn = 6;
	sdiIn = 7;


{ Video Digitizer PlayThru States }
const
	vdPlayThruOff = 0;
	vdPlayThruOn = 1;

{ Input Color Space Modes }
const
	vdDigitizerBW = 0;    { black and white }
	vdDigitizerRGB = 1;     { rgb color }

{ Phase Lock Loop Modes }
const
	vdBroadcastMode = 0;    { Broadcast / Laser Disk video mode }
	vdVTRMode = 1;     { VCR / Magnetic media mode }

{ Field Select Options }
const
	vdUseAnyField = 0;    { Digitizers choice on field use }
	vdUseOddField = 1;    { Use odd field for half size vert and smaller }
	vdUseEvenField = 2;     { Use even field for half size vert and smaller }

{ vdig types }
const
	vdTypeBasic = 0;    { basic, no clipping }
	vdTypeAlpha = 1;    { supports clipping with alpha channel }
	vdTypeMask = 2;    { supports clipping with mask plane }
	vdTypeKey = 3;     { supports clipping with key color(s) }


{ Digitizer Input Capability/Current Flags }
const
	digiInDoesNTSC = 1 shl 0; { digitizer supports NTSC input format }
	digiInDoesPAL = 1 shl 1; { digitizer supports PAL input format }
	digiInDoesSECAM = 1 shl 2; { digitizer supports SECAM input format }
	digiInDoesGenLock = 1 shl 7; { digitizer does genlock }
	digiInDoesComposite = 1 shl 8; { digitizer supports composite input type }
	digiInDoesSVideo = 1 shl 9; { digitizer supports S-Video input type }
	digiInDoesComponent = 1 shl 10; { digitizer supports component = rgb, input type }
	digiInVTR_Broadcast = 1 shl 11; { digitizer can differentiate between the two }
	digiInDoesColor = 1 shl 12; { digitizer supports color }
	digiInDoesBW = 1 shl 13; { digitizer supports black & white }
                                        { Digitizer Input Current Flags = these are valid only during active operating conditions,   }
	digiInSignalLock = 1 shl 31; { digitizer detects input signal is locked, this bit = horiz lock || vertical lock }


{ Digitizer Output Capability/Current Flags }
const
	digiOutDoes1 = 1 shl 0; { digitizer supports 1 bit pixels }
	digiOutDoes2 = 1 shl 1; { digitizer supports 2 bit pixels }
	digiOutDoes4 = 1 shl 2; { digitizer supports 4 bit pixels }
	digiOutDoes8 = 1 shl 3; { digitizer supports 8 bit pixels }
	digiOutDoes16 = 1 shl 4; { digitizer supports 16 bit pixels }
	digiOutDoes32 = 1 shl 5; { digitizer supports 32 bit pixels }
	digiOutDoesDither = 1 shl 6; { digitizer dithers in indexed modes }
	digiOutDoesStretch = 1 shl 7; { digitizer can arbitrarily stretch }
	digiOutDoesShrink = 1 shl 8; { digitizer can arbitrarily shrink }
	digiOutDoesMask = 1 shl 9; { digitizer can mask to clipping regions }
	digiOutDoesDouble = 1 shl 11; { digitizer can stretch to exactly double size }
	digiOutDoesQuad = 1 shl 12; { digitizer can stretch exactly quadruple size }
	digiOutDoesQuarter = 1 shl 13; { digitizer can shrink to exactly quarter size }
	digiOutDoesSixteenth = 1 shl 14; { digitizer can shrink to exactly sixteenth size }
	digiOutDoesRotate = 1 shl 15; { digitizer supports rotate transformations }
	digiOutDoesHorizFlip = 1 shl 16; { digitizer supports horizontal flips Sx < 0 }
	digiOutDoesVertFlip = 1 shl 17; { digitizer supports vertical flips Sy < 0 }
	digiOutDoesSkew = 1 shl 18; { digitizer supports skew = shear,twist, }
	digiOutDoesBlend = 1 shl 19;
	digiOutDoesWarp = 1 shl 20;
	digiOutDoesHW_DMA = 1 shl 21; { digitizer not constrained to local device }
	digiOutDoesHWPlayThru = 1 shl 22; { digitizer doesn't need time to play thru }
	digiOutDoesILUT = 1 shl 23; { digitizer does inverse LUT for index modes }
	digiOutDoesKeyColor = 1 shl 24; { digitizer does key color functions too }
	digiOutDoesAsyncGrabs = 1 shl 25; { digitizer supports async grabs }
	digiOutDoesUnreadableScreenBits = 1 shl 26; { playthru doesn't generate readable bits on screen}
	digiOutDoesCompress = 1 shl 27; { supports alternate output data types }
	digiOutDoesCompressOnly = 1 shl 28; { can't provide raw frames anywhere }
	digiOutDoesPlayThruDuringCompress = 1 shl 29; { digi can do playthru while providing compressed data }
	digiOutDoesCompressPartiallyVisible = 1 shl 30; { digi doesn't need all bits visible on screen to do hardware compress }
	digiOutDoesNotNeedCopyOfCompressData = 1 shl 31; { digi doesn't need any bufferization when providing compressed data }

{ Types }
type
	VideoDigitizerComponent = ComponentInstance;
	VideoDigitizerError = ComponentResult;
	DigitizerInfoPtr = ^DigitizerInfo;
	DigitizerInfo = record
		vdigType: SInt16;
		inputCapabilityFlags: SIGNEDLONG;
		outputCapabilityFlags: SIGNEDLONG;
		inputCurrentFlags: SIGNEDLONG;
		outputCurrentFlags: SIGNEDLONG;
		slot: SInt16;                   { temporary for connection purposes }
		gdh: GDHandle;                    { temporary for digitizers that have preferred screen }
		maskgdh: GDHandle;                { temporary for digitizers that have mask planes }
		minDestHeight: SInt16;          { Smallest resizable height }
		minDestWidth: SInt16;           { Smallest resizable width }
		maxDestHeight: SInt16;          { Largest resizable height }
		maxDestWidth: SInt16;           { Largest resizable width }
		blendLevels: SInt16;            { Number of blend levels supported (2 if 1 bit mask) }
		reserved: SIGNEDLONG;               { reserved }
	end;
type
	VdigTypePtr = ^VdigType;
	VdigType = record
		digType: SIGNEDLONG;
		reserved: SIGNEDLONG;
	end;
type
	VdigTypeListPtr = ^VdigTypeList;
	VdigTypeList = record
		count: SInt16;
		list: array [0..0] of VdigType;
	end;
type
	VdigBufferRecPtr = ^VdigBufferRec;
	VdigBufferRec = record
		dest: PixMapHandle;
		location: Point;
		reserved: SIGNEDLONG;
	end;
type
	VdigBufferRecList = record
		count: SInt16;
		matrix: MatrixRecordPtr;
		mask: RgnHandle;
		list: array [0..0] of VdigBufferRec;
	end;
	VdigBufferRecListPtr = ^VdigBufferRecList;
type
	VdigBufferRecListHandle = ^VdigBufferRecListPtr;
	VdigIntProcPtr = procedure( flags: SIGNEDLONG; refcon: SIGNEDLONG );
	VdigIntUPP = VdigIntProcPtr;
	VDCompressionList = record
		codec: CodecComponent;
		cType: CodecType;
		typeName: Str63;
		name: Str63;
		formatFlags: SIGNEDLONG;
		compressFlags: SIGNEDLONG;
		reserved: SIGNEDLONG;
	end;
	VDCompressionListPtr = ^VDCompressionList;
type
	VDCompressionListHandle = ^VDCompressionListPtr;
const
	dmaDepth1 = 1;
	dmaDepth2 = 2;
	dmaDepth4 = 4;
	dmaDepth8 = 8;
	dmaDepth16 = 16;
	dmaDepth32 = 32;
	dmaDepth2Gray = 64;
	dmaDepth4Gray = 128;
	dmaDepth8Gray = 256;

const
	kVDIGControlledFrameRate = -1;


{
 *  VDGetMaxSrcRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetMaxSrcRect( ci: VideoDigitizerComponent; inputStd: SInt16; var maxSrcRect: Rect ): VideoDigitizerError; external name '_VDGetMaxSrcRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetActiveSrcRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetActiveSrcRect( ci: VideoDigitizerComponent; inputStd: SInt16; var activeSrcRect: Rect ): VideoDigitizerError; external name '_VDGetActiveSrcRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetDigitizerRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetDigitizerRect( ci: VideoDigitizerComponent; var digitizerRect: Rect ): VideoDigitizerError; external name '_VDSetDigitizerRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetDigitizerRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetDigitizerRect( ci: VideoDigitizerComponent; var digitizerRect: Rect ): VideoDigitizerError; external name '_VDGetDigitizerRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetVBlankRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetVBlankRect( ci: VideoDigitizerComponent; inputStd: SInt16; var vBlankRect: Rect ): VideoDigitizerError; external name '_VDGetVBlankRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetMaskPixMap()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetMaskPixMap( ci: VideoDigitizerComponent; maskPixMap: PixMapHandle ): VideoDigitizerError; external name '_VDGetMaskPixMap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetPlayThruDestination()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetPlayThruDestination( ci: VideoDigitizerComponent; var dest: PixMapHandle; var destRect: Rect; var m: MatrixRecord; var mask: RgnHandle ): VideoDigitizerError; external name '_VDGetPlayThruDestination';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDUseThisCLUT()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDUseThisCLUT( ci: VideoDigitizerComponent; colorTableHandle: CTabHandle ): VideoDigitizerError; external name '_VDUseThisCLUT';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetInputGammaValue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetInputGammaValue( ci: VideoDigitizerComponent; channel1: Fixed; channel2: Fixed; channel3: Fixed ): VideoDigitizerError; external name '_VDSetInputGammaValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetInputGammaValue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetInputGammaValue( ci: VideoDigitizerComponent; var channel1: Fixed; var channel2: Fixed; var channel3: Fixed ): VideoDigitizerError; external name '_VDGetInputGammaValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetBrightness()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetBrightness( ci: VideoDigitizerComponent; var brightness: UInt16 ): VideoDigitizerError; external name '_VDSetBrightness';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetBrightness()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetBrightness( ci: VideoDigitizerComponent; var brightness: UInt16 ): VideoDigitizerError; external name '_VDGetBrightness';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetContrast()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetContrast( ci: VideoDigitizerComponent; var contrast: UInt16 ): VideoDigitizerError; external name '_VDSetContrast';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetHue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetHue( ci: VideoDigitizerComponent; var hue: UInt16 ): VideoDigitizerError; external name '_VDSetHue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetSharpness()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetSharpness( ci: VideoDigitizerComponent; var sharpness: UInt16 ): VideoDigitizerError; external name '_VDSetSharpness';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetSaturation()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetSaturation( ci: VideoDigitizerComponent; var saturation: UInt16 ): VideoDigitizerError; external name '_VDSetSaturation';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetContrast()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetContrast( ci: VideoDigitizerComponent; var contrast: UInt16 ): VideoDigitizerError; external name '_VDGetContrast';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetHue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetHue( ci: VideoDigitizerComponent; var hue: UInt16 ): VideoDigitizerError; external name '_VDGetHue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetSharpness()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetSharpness( ci: VideoDigitizerComponent; var sharpness: UInt16 ): VideoDigitizerError; external name '_VDGetSharpness';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetSaturation()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetSaturation( ci: VideoDigitizerComponent; var saturation: UInt16 ): VideoDigitizerError; external name '_VDGetSaturation';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGrabOneFrame()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGrabOneFrame( ci: VideoDigitizerComponent ): VideoDigitizerError; external name '_VDGrabOneFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetMaxAuxBuffer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetMaxAuxBuffer( ci: VideoDigitizerComponent; var pm: PixMapHandle; var r: Rect ): VideoDigitizerError; external name '_VDGetMaxAuxBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetDigitizerInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetDigitizerInfo( ci: VideoDigitizerComponent; var info: DigitizerInfo ): VideoDigitizerError; external name '_VDGetDigitizerInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetCurrentFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetCurrentFlags( ci: VideoDigitizerComponent; var inputCurrentFlag: SIGNEDLONG; var outputCurrentFlag: SIGNEDLONG ): VideoDigitizerError; external name '_VDGetCurrentFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetKeyColor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetKeyColor( ci: VideoDigitizerComponent; index: SIGNEDLONG ): VideoDigitizerError; external name '_VDSetKeyColor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetKeyColor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetKeyColor( ci: VideoDigitizerComponent; var index: SIGNEDLONG ): VideoDigitizerError; external name '_VDGetKeyColor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDAddKeyColor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDAddKeyColor( ci: VideoDigitizerComponent; var index: SIGNEDLONG ): VideoDigitizerError; external name '_VDAddKeyColor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetNextKeyColor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetNextKeyColor( ci: VideoDigitizerComponent; index: SIGNEDLONG ): VideoDigitizerError; external name '_VDGetNextKeyColor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetKeyColorRange()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetKeyColorRange( ci: VideoDigitizerComponent; var minRGB: RGBColor; var maxRGB: RGBColor ): VideoDigitizerError; external name '_VDSetKeyColorRange';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetKeyColorRange()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetKeyColorRange( ci: VideoDigitizerComponent; var minRGB: RGBColor; var maxRGB: RGBColor ): VideoDigitizerError; external name '_VDGetKeyColorRange';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetDigitizerUserInterrupt()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetDigitizerUserInterrupt( ci: VideoDigitizerComponent; flags: SIGNEDLONG; userInterruptProc: VdigIntUPP; refcon: SIGNEDLONG ): VideoDigitizerError; external name '_VDSetDigitizerUserInterrupt';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetInputColorSpaceMode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetInputColorSpaceMode( ci: VideoDigitizerComponent; colorSpaceMode: SInt16 ): VideoDigitizerError; external name '_VDSetInputColorSpaceMode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetInputColorSpaceMode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetInputColorSpaceMode( ci: VideoDigitizerComponent; var colorSpaceMode: SInt16 ): VideoDigitizerError; external name '_VDGetInputColorSpaceMode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetClipState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetClipState( ci: VideoDigitizerComponent; clipEnable: SInt16 ): VideoDigitizerError; external name '_VDSetClipState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetClipState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetClipState( ci: VideoDigitizerComponent; var clipEnable: SInt16 ): VideoDigitizerError; external name '_VDGetClipState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetClipRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetClipRgn( ci: VideoDigitizerComponent; clipRegion: RgnHandle ): VideoDigitizerError; external name '_VDSetClipRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDClearClipRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDClearClipRgn( ci: VideoDigitizerComponent; clipRegion: RgnHandle ): VideoDigitizerError; external name '_VDClearClipRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetCLUTInUse()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetCLUTInUse( ci: VideoDigitizerComponent; var colorTableHandle: CTabHandle ): VideoDigitizerError; external name '_VDGetCLUTInUse';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetPLLFilterType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetPLLFilterType( ci: VideoDigitizerComponent; pllType: SInt16 ): VideoDigitizerError; external name '_VDSetPLLFilterType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetPLLFilterType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetPLLFilterType( ci: VideoDigitizerComponent; var pllType: SInt16 ): VideoDigitizerError; external name '_VDGetPLLFilterType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetMaskandValue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetMaskandValue( ci: VideoDigitizerComponent; blendLevel: UInt16; var mask: SIGNEDLONG; var value: SIGNEDLONG ): VideoDigitizerError; external name '_VDGetMaskandValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetMasterBlendLevel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetMasterBlendLevel( ci: VideoDigitizerComponent; var blendLevel: UInt16 ): VideoDigitizerError; external name '_VDSetMasterBlendLevel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetPlayThruDestination()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetPlayThruDestination( ci: VideoDigitizerComponent; dest: PixMapHandle; destRect: RectPtr; m: MatrixRecordPtr; mask: RgnHandle ): VideoDigitizerError; external name '_VDSetPlayThruDestination';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetPlayThruOnOff()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetPlayThruOnOff( ci: VideoDigitizerComponent; state: SInt16 ): VideoDigitizerError; external name '_VDSetPlayThruOnOff';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetFieldPreference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetFieldPreference( ci: VideoDigitizerComponent; fieldFlag: SInt16 ): VideoDigitizerError; external name '_VDSetFieldPreference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetFieldPreference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetFieldPreference( ci: VideoDigitizerComponent; var fieldFlag: SInt16 ): VideoDigitizerError; external name '_VDGetFieldPreference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDPreflightDestination()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDPreflightDestination( ci: VideoDigitizerComponent; var digitizerRect: Rect; var dest: PixMapPtr; destRect: RectPtr; m: MatrixRecordPtr ): VideoDigitizerError; external name '_VDPreflightDestination';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDPreflightGlobalRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDPreflightGlobalRect( ci: VideoDigitizerComponent; theWindow: GrafPtr; var globalRect: Rect ): VideoDigitizerError; external name '_VDPreflightGlobalRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetPlayThruGlobalRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetPlayThruGlobalRect( ci: VideoDigitizerComponent; theWindow: GrafPtr; var globalRect: Rect ): VideoDigitizerError; external name '_VDSetPlayThruGlobalRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetInputGammaRecord()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetInputGammaRecord( ci: VideoDigitizerComponent; inputGammaPtr: VDGamRecPtr ): VideoDigitizerError; external name '_VDSetInputGammaRecord';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetInputGammaRecord()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetInputGammaRecord( ci: VideoDigitizerComponent; var inputGammaPtr: VDGamRecPtr ): VideoDigitizerError; external name '_VDGetInputGammaRecord';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetBlackLevelValue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetBlackLevelValue( ci: VideoDigitizerComponent; var blackLevel: UInt16 ): VideoDigitizerError; external name '_VDSetBlackLevelValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetBlackLevelValue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetBlackLevelValue( ci: VideoDigitizerComponent; var blackLevel: UInt16 ): VideoDigitizerError; external name '_VDGetBlackLevelValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetWhiteLevelValue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetWhiteLevelValue( ci: VideoDigitizerComponent; var whiteLevel: UInt16 ): VideoDigitizerError; external name '_VDSetWhiteLevelValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetWhiteLevelValue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetWhiteLevelValue( ci: VideoDigitizerComponent; var whiteLevel: UInt16 ): VideoDigitizerError; external name '_VDGetWhiteLevelValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetVideoDefaults()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetVideoDefaults( ci: VideoDigitizerComponent; var blackLevel: UInt16; var whiteLevel: UInt16; var brightness: UInt16; var hue: UInt16; var saturation: UInt16; var contrast: UInt16; var sharpness: UInt16 ): VideoDigitizerError; external name '_VDGetVideoDefaults';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetNumberOfInputs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetNumberOfInputs( ci: VideoDigitizerComponent; var inputs: SInt16 ): VideoDigitizerError; external name '_VDGetNumberOfInputs';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetInputFormat()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetInputFormat( ci: VideoDigitizerComponent; input: SInt16; var format: SInt16 ): VideoDigitizerError; external name '_VDGetInputFormat';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetInput()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetInput( ci: VideoDigitizerComponent; input: SInt16 ): VideoDigitizerError; external name '_VDSetInput';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetInput()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetInput( ci: VideoDigitizerComponent; var input: SInt16 ): VideoDigitizerError; external name '_VDGetInput';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetInputStandard()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetInputStandard( ci: VideoDigitizerComponent; inputStandard: SInt16 ): VideoDigitizerError; external name '_VDSetInputStandard';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetupBuffers()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetupBuffers( ci: VideoDigitizerComponent; bufferList: VdigBufferRecListHandle ): VideoDigitizerError; external name '_VDSetupBuffers';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGrabOneFrameAsync()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGrabOneFrameAsync( ci: VideoDigitizerComponent; buffer: SInt16 ): VideoDigitizerError; external name '_VDGrabOneFrameAsync';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDDone()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDDone( ci: VideoDigitizerComponent; buffer: SInt16 ): VideoDigitizerError; external name '_VDDone';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetCompression()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetCompression( ci: VideoDigitizerComponent; compressType: OSType; depth: SInt16; var bounds: Rect; spatialQuality: CodecQ; temporalQuality: CodecQ; keyFrameRate: SIGNEDLONG ): VideoDigitizerError; external name '_VDSetCompression';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDCompressOneFrameAsync()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDCompressOneFrameAsync( ci: VideoDigitizerComponent ): VideoDigitizerError; external name '_VDCompressOneFrameAsync';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{    Note that UInt8* queuedFrameCount replaces Boolean* done. 0(==false) still means no frames, and 1(==true) one, 
    but if more than one are available the number should be returned here. The value 2 previously meant more than one frame,
    so some VDIGs may return 2 even if more than 2 are available, and some will still return 1 as they are using the original definition }
{
 *  VDCompressDone()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDCompressDone( ci: VideoDigitizerComponent; var queuedFrameCount: UInt8; var theData: Ptr; var dataSize: SIGNEDLONG; var similarity: UInt8; var t: TimeRecord ): VideoDigitizerError; external name '_VDCompressDone';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDReleaseCompressBuffer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDReleaseCompressBuffer( ci: VideoDigitizerComponent; bufferAddr: Ptr ): VideoDigitizerError; external name '_VDReleaseCompressBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetImageDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetImageDescription( ci: VideoDigitizerComponent; desc: ImageDescriptionHandle ): VideoDigitizerError; external name '_VDGetImageDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDResetCompressSequence()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDResetCompressSequence( ci: VideoDigitizerComponent ): VideoDigitizerError; external name '_VDResetCompressSequence';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetCompressionOnOff()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetCompressionOnOff( ci: VideoDigitizerComponent; state: Boolean ): VideoDigitizerError; external name '_VDSetCompressionOnOff';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetCompressionTypes()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetCompressionTypes( ci: VideoDigitizerComponent; h: VDCompressionListHandle ): VideoDigitizerError; external name '_VDGetCompressionTypes';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetTimeBase( ci: VideoDigitizerComponent; t: TimeBase ): VideoDigitizerError; external name '_VDSetTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetFrameRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetFrameRate( ci: VideoDigitizerComponent; framesPerSecond: Fixed ): VideoDigitizerError; external name '_VDSetFrameRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetDataRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetDataRate( ci: VideoDigitizerComponent; var milliSecPerFrame: SIGNEDLONG; var framesPerSecond: Fixed; var bytesPerSecond: SIGNEDLONG ): VideoDigitizerError; external name '_VDGetDataRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetSoundInputDriver()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetSoundInputDriver( ci: VideoDigitizerComponent; var soundDriverName: Str255 ): VideoDigitizerError; external name '_VDGetSoundInputDriver';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetDMADepths()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetDMADepths( ci: VideoDigitizerComponent; var depthArray: SIGNEDLONG; var preferredDepth: SIGNEDLONG ): VideoDigitizerError; external name '_VDGetDMADepths';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetPreferredTimeScale()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetPreferredTimeScale( ci: VideoDigitizerComponent; var preferred: TimeScale ): VideoDigitizerError; external name '_VDGetPreferredTimeScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDReleaseAsyncBuffers()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDReleaseAsyncBuffers( ci: VideoDigitizerComponent ): VideoDigitizerError; external name '_VDReleaseAsyncBuffers';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ 83 is reserved for compatibility reasons }
{
 *  VDSetDataRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetDataRate( ci: VideoDigitizerComponent; bytesPerSecond: SIGNEDLONG ): VideoDigitizerError; external name '_VDSetDataRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetTimeCode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetTimeCode( ci: VideoDigitizerComponent; var atTime: TimeRecord; timeCodeFormat: UnivPtr; timeCodeTime: UnivPtr ): VideoDigitizerError; external name '_VDGetTimeCode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDUseSafeBuffers()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDUseSafeBuffers( ci: VideoDigitizerComponent; useSafeBuffers: Boolean ): VideoDigitizerError; external name '_VDUseSafeBuffers';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetSoundInputSource()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetSoundInputSource( ci: VideoDigitizerComponent; videoInput: SIGNEDLONG; var soundInput: SIGNEDLONG ): VideoDigitizerError; external name '_VDGetSoundInputSource';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetCompressionTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetCompressionTime( ci: VideoDigitizerComponent; compressionType: OSType; depth: SInt16; var srcRect: Rect; var spatialQuality: CodecQ; var temporalQuality: CodecQ; var compressTime: UNSIGNEDLONG ): VideoDigitizerError; external name '_VDGetCompressionTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetPreferredPacketSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetPreferredPacketSize( ci: VideoDigitizerComponent; preferredPacketSizeInBytes: SIGNEDLONG ): VideoDigitizerError; external name '_VDSetPreferredPacketSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetPreferredImageDimensions()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetPreferredImageDimensions( ci: VideoDigitizerComponent; width: SIGNEDLONG; height: SIGNEDLONG ): VideoDigitizerError; external name '_VDSetPreferredImageDimensions';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetPreferredImageDimensions()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetPreferredImageDimensions( ci: VideoDigitizerComponent; var width: SIGNEDLONG; var height: SIGNEDLONG ): VideoDigitizerError; external name '_VDGetPreferredImageDimensions';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDGetInputName()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDGetInputName( ci: VideoDigitizerComponent; videoInput: SIGNEDLONG; var name: Str255 ): VideoDigitizerError; external name '_VDGetInputName';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VDSetDestinationPort()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VDSetDestinationPort( ci: VideoDigitizerComponent; destPort: CGrafPtr ): VideoDigitizerError; external name '_VDSetDestinationPort';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
   The following call is designed to give the VDIG a little more control over how it is presented to the User, to clarify the 
   distinction between Devices and Inputs. Historically, the assumption has been that there is one component registered per device
   and the component name is displayed. This change lets a component choose its name after registration.
   vdDeviceFlagShowInputsAsDevices is meant for components that register once and support multiple devices 
   The UI is clearer if these are presented as device rather than inputs, 
   and this allows a VDIG to present itself this way without huge restructuring
   vdDeviceFlagHideDevice is for the kind of VDIG that registers itself, and then can register a further VDIG for each device. 
   If no hardware is available, returning this flag will omit it from the list. 
   This call being made is also a good time to check for hardware and register further VDIG components if needed, 
   allowing for lazy initialization when the Application needs to find a VDIG rather than on every launch or replug.
}

const
	vdDeviceFlagShowInputsAsDevices = 1 shl 0; { Tell the Panel to promote Inputs to Devices}
	vdDeviceFlagHideDevice = 1 shl 1; { Omit this Device entirely from the list}

{
 *  VDGetDeviceNameAndFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function VDGetDeviceNameAndFlags( ci: VideoDigitizerComponent; var outName: Str255; var outNameFlags: UInt32 ): VideoDigitizerError; external name '_VDGetDeviceNameAndFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


const
	vdFlagCaptureStarting = 1 shl 0; { Capture is about to start; allocate bandwidth }
	vdFlagCaptureStopping = 1 shl 1; { Capture is about to stop; stop queuing frames}
	vdFlagCaptureIsForPreview = 1 shl 2; { Capture is just to screen for preview purposes}
	vdFlagCaptureIsForRecord = 1 shl 3; { Capture is going to be recorded}
	vdFlagCaptureLowLatency = 1 shl 4; { Fresh frames are more important than delivering every frame - don't queue too much}
	vdFlagCaptureAlwaysUseTimeBase = 1 shl 5; { Use the timebase for every frame; don't worry about making durations uniform}
	vdFlagCaptureSetSettingsBegin = 1 shl 6; { A series of calls are about to be made to restore settings.}
	vdFlagCaptureSetSettingsEnd = 1 shl 7; { Finished restoring settings; any set calls after this are from the app or UI}

{
 *  VDCaptureStateChanging()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function VDCaptureStateChanging( ci: VideoDigitizerComponent; inStateFlags: UInt32 ): VideoDigitizerError; external name '_VDCaptureStateChanging';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
   These UniqueID calls are so that the VDIG can give the SG information enabling it to restore a particular
   configuration - choose a particular device and input from those available.
   For example, restoring the specific camera for a set of several hot-plugged FireWire cameras 
   the caller can pass nil if it is not interested in one of the IDs
   returning 0 in an ID means you don't have one
}

{
 *  VDGetUniqueIDs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function VDGetUniqueIDs( ci: VideoDigitizerComponent; var outDeviceID: UInt64; var outInputID: UInt64 ): VideoDigitizerError; external name '_VDGetUniqueIDs';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
   Note this is a 'Select' not a 'Set' - the assumption is that the Unique ID is a function of the hardware
   and not modifiable by the calling application. Either a nil pointer or 0 an the ID means don't care.
   return vdDontHaveThatUniqueIDErr if your device doesn't have a match.
}

{
 *  VDSelectUniqueIDs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function VDSelectUniqueIDs( ci: VideoDigitizerComponent; (*const*) var inDeviceID: UInt64; (*const*) var inInputID: UInt64 ): VideoDigitizerError; external name '_VDSelectUniqueIDs';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  VDCopyPreferredAudioDevice()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function VDCopyPreferredAudioDevice( vdig: ComponentInstance; var outAudioDeviceUID: CFStringRef ): ComponentResult; external name '_VDCopyPreferredAudioDevice';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
   IIDC (Instrumentation & Industrial Digital Camera) Video Digitizers
   Video Digitizers of subtype vdSubtypeIIDC support FireWire cameras which conform to the
   "IIDC 1394-based Digital Camera Specification." 
}

const
	vdSubtypeIIDC = FourCharCode('iidc'); { Subtype for IIDC 1394-Digital Camera video digitizer}

{
   vdIIDCAtomTypeFeature
   Parent node for the QTAtoms which describe a given feature.  
}
const
	vdIIDCAtomTypeFeature = FourCharCode('feat');

{
   vdIIDCAtomTypeFeatureAtomTypeAndID
   This atom describes the feature's OSType/group/name and QTAtomType & QTAtomID needed to retrieve its settings.
   The contents of this atom is a VDIIDCFeatureAtomTypeAndID structure.  
}
const
	vdIIDCAtomTypeFeatureAtomTypeAndID = FourCharCode('t&id');
	vdIIDCAtomIDFeatureAtomTypeAndID = 1;

type
	VDIIDCFeatureAtomTypeAndIDPtr = ^VDIIDCFeatureAtomTypeAndID;
	VDIIDCFeatureAtomTypeAndID = record
		feature: OSType;                { OSType of feature}
		group: OSType;                  { OSType of group that feature is categorized into}
		name: Str255;                   { Name of this feature}
		atomType: QTAtomType;               { Atom type which contains feature's settings}
		atomID: QTAtomID;                 { Atom ID which contains feature's settings}
	end;
{ IIDC Feature OSTypes}
const
	vdIIDCFeatureHue = FourCharCode('hue '); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureSaturation = FourCharCode('satu'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureSharpness = FourCharCode('shrp'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureBrightness = FourCharCode('brit'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureGain = FourCharCode('gain'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureIris = FourCharCode('iris'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureShutter = FourCharCode('shtr'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureExposure = FourCharCode('xpsr'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureWhiteBalanceU = FourCharCode('whbu'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureWhiteBalanceV = FourCharCode('whbv'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureGamma = FourCharCode('gmma'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureTemperature = FourCharCode('temp'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureZoom = FourCharCode('zoom'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureFocus = FourCharCode('fcus'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeaturePan = FourCharCode('pan '); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureTilt = FourCharCode('tilt'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureOpticalFilter = FourCharCode('opft'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureTrigger = FourCharCode('trgr'); { Trigger's setttings handled by VDIIDCTriggerSettings}
	vdIIDCFeatureCaptureSize = FourCharCode('cpsz'); { Feature's settings is not defined}
	vdIIDCFeatureCaptureQuality = FourCharCode('cpql'); { Feature's settings is not defined}
	vdIIDCFeatureFocusPoint = FourCharCode('fpnt'); { Focus Point's settings handled by VDIIDCFocusPointSettings}
	vdIIDCFeatureEdgeEnhancement = FourCharCode('eden'); { Feature's settings handled by VDIIDCFeatureSettings}
	vdIIDCFeatureLightingHint = FourCharCode('lhnt'); { Feature's settings handled by VDIIDCLightingHintSettings}

{
   IIDC Group OSTypes that features are categorized into
   (The values used for the constants cannot be the same as any of the IIDC Feature OSTypes constants)
}
const
	vdIIDCGroupImage = FourCharCode('imag'); { Feature related to camera's image}
	vdIIDCGroupColor = FourCharCode('colr'); { Feature related to camera's color control}
	vdIIDCGroupMechanics = FourCharCode('mech'); { Feature related to camera's mechanics}
	vdIIDCGroupTrigger = FourCharCode('trig'); { Feature related to camera's trigger}

{
   vdIIDCAtomTypeFeatureSettings
   This atom describes the settings for the majority of features.
   The contents of this atom is a VDIIDCFeatureSettings structure.
}
const
	vdIIDCAtomTypeFeatureSettings = FourCharCode('fstg');
	vdIIDCAtomIDFeatureSettings = 1;

type
	VDIIDCFeatureCapabilitiePtr = ^VDIIDCFeatureCapabilities;
	VDIIDCFeatureCapabilities = record
		flags: UInt32;
		rawMinimum: UInt16;
		rawMaximum: UInt16;
		absoluteMinimum: QTFloatSingle;
		absoluteMaximum: QTFloatSingle;
	end;
type
	VDIIDCFeatureStatePtr = ^VDIIDCFeatureState;
	VDIIDCFeatureState = record
		flags: UInt32;
		value: QTFloatSingle;
	end;
type
	VDIIDCFeatureSettingsPtr = ^VDIIDCFeatureSettings;
	VDIIDCFeatureSettings = record
		capabilities: VDIIDCFeatureCapabilities;
		state: VDIIDCFeatureState;
	end;
{
   Flags for use in VDIIDCFeatureCapabilities.flags & VDIIDCFeatureState.flags
   When indicating capabilities, the flag being set indicates that the feature can be put into the given state.
   When indicating/setting state, the flag represents the current/desired state.
   Note that certain combinations of flags are valid for capabilities (i.e. vdIIDCFeatureFlagOn | vdIIDCFeatureFlagOff)
   but are mutually exclusive for state.
}
const
	vdIIDCFeatureFlagOn = 1 shl 0;
	vdIIDCFeatureFlagOff = 1 shl 1;
	vdIIDCFeatureFlagManual = 1 shl 2;
	vdIIDCFeatureFlagAuto = 1 shl 3;
	vdIIDCFeatureFlagTune = 1 shl 4;
	vdIIDCFeatureFlagRawControl = 1 shl 5;
	vdIIDCFeatureFlagAbsoluteControl = 1 shl 6;

{
   vdIIDCAtomTypeTriggerSettings
   This atom describes the settings for the trigger feature.
   The contents of this atom is a VDIIDCTriggerSettings structure.
}
const
	vdIIDCAtomTypeTriggerSettings = FourCharCode('tstg');
	vdIIDCAtomIDTriggerSettings = 1;

type
	VDIIDCTriggerCapabilities = record
		flags: UInt32;
		absoluteMinimum: QTFloatSingle;
		absoluteMaximum: QTFloatSingle;
	end;
type
	VDIIDCTriggerState = record
		flags: UInt32;
		mode2TransitionCount: UInt16;
		mode3FrameRateMultiplier: UInt16;
		absoluteValue: QTFloatSingle;
	end;
type
	VDIIDCTriggerSettings = record
		capabilities: VDIIDCTriggerCapabilities;
		state: VDIIDCTriggerState;
	end;
{
   Flags for use in VDIIDCTriggerCapabilities.flags & VDIIDCTriggerState.flags
   When indicating capabilities, the flag being set indicates that the trigger can be put into the given state.
   When indicating/setting state, the flag represents the current/desired state.
   Note that certain combinations of flags are valid for capabilities (i.e. vdIIDCTriggerFlagOn | vdIIDCTriggerFlagOff)
   but are mutually exclusive for state.
}
const
	vdIIDCTriggerFlagOn = 1 shl 0;
	vdIIDCTriggerFlagOff = 1 shl 1;
	vdIIDCTriggerFlagActiveHigh = 1 shl 2;
	vdIIDCTriggerFlagActiveLow = 1 shl 3;
	vdIIDCTriggerFlagMode0 = 1 shl 4;
	vdIIDCTriggerFlagMode1 = 1 shl 5;
	vdIIDCTriggerFlagMode2 = 1 shl 6;
	vdIIDCTriggerFlagMode3 = 1 shl 7;
	vdIIDCTriggerFlagRawControl = 1 shl 8;
	vdIIDCTriggerFlagAbsoluteControl = 1 shl 9;


{
   vdIIDCAtomTypeFocusPointSettings
   This atom describes the settings for the focus point feature.
   The contents of this atom is a VDIIDCFocusPointSettings structure.
}
const
	vdIIDCAtomTypeFocusPointSettings = FourCharCode('fpst');
	vdIIDCAtomIDFocusPointSettings = 1;

type
	VDIIDCFocusPointSettings = record
		focusPoint: Point;
	end;
{
   vdIIDCAtomTypeLightingHintSettings
   This atom describes the settings for the light hint feature.
   The contents of this atom is a VDIIDCLightingHintSettings structure.
}
const
	vdIIDCAtomTypeLightingHintSettings = FourCharCode('lhst');
	vdIIDCAtomIDLightingHintSettings = 1;

type
	VDIIDCLightingHintSettings = record
		capabilityFlags: UInt32;
		stateFlags: UInt32;
	end;
{
   Flags for use in VDIIDCLightingHintSettings.capabilityFlags & VDIIDCLightingHintSettings.capabilityFlags
   When indicating capabilities, the flag being set indicates that the hint can be applied.
   When indicating/setting state, the flag represents the current/desired hints applied/to apply.
   Certain combinations of flags are valid for capabilities (i.e. vdIIDCLightingHintNormal | vdIIDCLightingHintLow)
   but are mutually exclusive for state.
}
const
	vdIIDCLightingHintNormal = 1 shl 0;
	vdIIDCLightingHintLow = 1 shl 1;


{
   VDIIDC calls are additional calls for IIDC digitizers (vdSubtypeIIDC)
   These calls are only valid for video digitizers of subtype vdSubtypeIIDC.
}
{
 *  VDIIDCGetFeatures()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function VDIIDCGetFeatures( ci: VideoDigitizerComponent; var container: QTAtomContainer ): VideoDigitizerError; external name '_VDIIDCGetFeatures';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  VDIIDCSetFeatures()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function VDIIDCSetFeatures( ci: VideoDigitizerComponent; container: QTAtomContainer ): VideoDigitizerError; external name '_VDIIDCSetFeatures';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  VDIIDCGetDefaultFeatures()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function VDIIDCGetDefaultFeatures( ci: VideoDigitizerComponent; var container: QTAtomContainer ): VideoDigitizerError; external name '_VDIIDCGetDefaultFeatures';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  VDIIDCGetCSRData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function VDIIDCGetCSRData( ci: VideoDigitizerComponent; offsetFromUnitBase: Boolean; offset: UInt32; var data: UInt32 ): VideoDigitizerError; external name '_VDIIDCGetCSRData';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  VDIIDCSetCSRData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function VDIIDCSetCSRData( ci: VideoDigitizerComponent; offsetFromUnitBase: Boolean; offset: UInt32; data: UInt32 ): VideoDigitizerError; external name '_VDIIDCSetCSRData';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  VDIIDCGetFeaturesForSpecifier()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function VDIIDCGetFeaturesForSpecifier( ci: VideoDigitizerComponent; specifier: OSType; var container: QTAtomContainer ): VideoDigitizerError; external name '_VDIIDCGetFeaturesForSpecifier';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


const
	xmlParseComponentType = FourCharCode('pars');
	xmlParseComponentSubType = FourCharCode('xml ');

const
	xmlIdentifierInvalid = 0;
	xmlIdentifierUnrecognized = $FFFFFFFF;
	xmlContentTypeInvalid = 0;
	xmlContentTypeElement = 1;
	xmlContentTypeCharData = 2;

const
	elementFlagAlwaysSelfContained = 1 shl 0; {    Element doesn't have contents or closing tag even if it doesn't end with />, as in the HTML <img> tag}
	elementFlagPreserveWhiteSpace = 1 shl 1; {  Preserve whitespace in content, default is to remove it }
	xmlParseFlagAllowUppercase = 1 shl 0; {    Entities and attributes do not have to be lowercase (strict XML), but can be upper or mixed case as in HTML}
	xmlParseFlagAllowUnquotedAttributeValues = 1 shl 1; {    Attributes values do not have to be enclosed in quotes (strict XML), but can be left unquoted if they contain no spaces}
	xmlParseFlagEventParseOnly = 1 shl 2; {    Do event parsing only}
	xmlParseFlagPreserveWhiteSpace = 1 shl 3; {    Preserve whitespace throughout the document}

const
	attributeValueKindCharString = 0;
	attributeValueKindInteger = 1 shl 0; {    Number}
	attributeValueKindPercent = 1 shl 1; {    Number or percent}
	attributeValueKindBoolean = 1 shl 2; {    "true" or "false"}
	attributeValueKindOnOff = 1 shl 3; {    "on" or "off"}
	attributeValueKindColor = 1 shl 4; {    Either "#rrggbb" or a color name}
	attributeValueKindEnum = 1 shl 5; {    one of a number of strings; the enum strings are passed as a zero-separated, double-zero-terminated C string in the attributeKindValueInfo param}
	attributeValueKindCaseSensEnum = 1 shl 6; {    one of a number of strings; the enum strings are passed as for attributeValueKindEnum, but the values are case-sensitive}
	MAX_ATTRIBUTE_VALUE_KIND = attributeValueKindCaseSensEnum;

const
	nameSpaceIDNone = 0;

{  A Parsed XML attribute value, one of number/percent, boolean/on-off, color, or enumerated type}
type
	XMLAttributeValuePtr = ^XMLAttributeValue;
	XMLAttributeValue = record
		case SInt16 of
		0: (
			number: SInt32;									{     The value when valueKind is attributeValueKindInteger or attributeValueKindPercent }
			);
		1: (
			boolean: boolean_fix;		                    {     The value when valueKind is attributeValueKindBoolean or attributeValueKindOnOff }
			);
		2: (
			color: RGBColor;								{     The value when valueKind is attributeValueKindColor }
			);
		3: (
			enumType: UInt32;									{     The value when valueKind is attributeValueKindEnum }
			);
	end;

{  An XML attribute-value pair}
type
	XMLAttribute = record
		identifier: UInt32;             {    Tokenized identifier, if the attribute name was recognized by the parser}
		name: CStringPtr;                   {    Attribute name, Only present if identifier == xmlIdentifierUnrecognized}
		valueKind: SIGNEDLONG;              {    Type of parsed value, if the value was recognized and parsed; otherwise, attributeValueKindCharString}
		value: XMLAttributeValue;                  {    Parsed attribute value}
		valueStr: CStringPtr;               {    Always present}
	end;
	XMLAttributePtr = ^XMLAttribute;
{  Forward struct declarations for recursively-defined tree structure}
type
	XMLContentPtr = ^XMLContent;
{
    An XML Element, i.e.
        <element attr="value" attr="value" ...> [contents] </element>
    or
        <element attr="value" attr="value" .../>
}
	XMLElement = record
		identifier: UInt32;             {    Tokenized identifier, if the element name was recognized by the parser}
		name: CStringPtr;                   {    Element name, only present if identifier == xmlIdentifierUnrecognized}
		attributes: XMLAttributePtr;             {    Array of attributes, terminated with an attribute with identifier == xmlIdentifierInvalid}
		contents: XMLContentPtr;               {    Array of contents, terminated with a content with kind == xmlIdentifierInvalid}
	end;
	XMLElementPtr = ^XMLElement;
{
    The content of an XML element is a series of parts, each of which may be either another element
    or simply character data.
}
	XMLElementContentPtr = ^XMLElementContent;
	XMLElementContent = record
		case SInt16 of
		0: (
			element: XMLElement;								{     The contents when the content kind is xmlContentTypeElement }
			);
		1: (
			charData: CStringPtr;								{     The contents when the content kind is xmlContentTypeCharData }
			);
	end;
	XMLContent = record
		kind: UInt32;
		actualContent: XMLElementContent;
	end;

type
	XMLDocRecordPtr = ^XMLDocRecord;
	XMLDocRecord = record
		xmlDataStorage: UnivPtr;         {    opaque storage}
		rootElement: XMLElement;
	end;
type
	XMLDoc = XMLDocRecordPtr;
{callback routines for event parsing}
type
	StartDocumentHandler = function( refcon: SIGNEDLONG ): ComponentResult;
	EndDocumentHandler = function( refcon: SIGNEDLONG ): ComponentResult;
	StartElementHandler = function( name: ConstCStringPtr; var atts: ConstCStringPtr; refcon: SIGNEDLONG ): ComponentResult;
	EndElementHandler = function( name: ConstCStringPtr; refcon: SIGNEDLONG ): ComponentResult;
	CharDataHandler = function( charData: ConstCStringPtr; refcon: SIGNEDLONG ): ComponentResult;
	PreprocessInstructionHandler = function( name: ConstCStringPtr; atts: ConstCStringPtrPtr; refcon: SIGNEDLONG ): ComponentResult;
	CommentHandler = function( comment: ConstCStringPtr; refcon: SIGNEDLONG ): ComponentResult;
	CDataHandler = function( cdata: ConstCStringPtr; refcon: SIGNEDLONG ): ComponentResult;
	StartDocumentHandlerUPP = StartDocumentHandler;
	EndDocumentHandlerUPP = EndDocumentHandler;
	StartElementHandlerUPP = StartElementHandler;
	EndElementHandlerUPP = EndElementHandler;
	CharDataHandlerUPP = CharDataHandler;
	PreprocessInstructionHandlerUPP = PreprocessInstructionHandler;
	CommentHandlerUPP = CommentHandler;
	CDataHandlerUPP = CDataHandler;
{  Parses the XML file pointed to by dataRef, returning a XMLDoc parse tree}
{
 *  XMLParseDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseDataRef( aParser: ComponentInstance; dataRef: Handle; dataRefType: OSType; parseFlags: SIGNEDLONG; var document: XMLDoc ): ComponentResult; external name '_XMLParseDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{  Parses the XML file pointed to by fileSpec, returning a XMLDoc parse tree}
{
 *  XMLParseFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseFile( aParser: ComponentInstance; fileSpec: ConstFSSpecPtr; parseFlags: SIGNEDLONG; var document: XMLDoc ): ComponentResult; external name '_XMLParseFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{  Disposes of a XMLDoc parse tree}
{
 *  XMLParseDisposeXMLDoc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseDisposeXMLDoc( aParser: ComponentInstance; document: XMLDoc ): ComponentResult; external name '_XMLParseDisposeXMLDoc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    Returns a more detailed description of the error and the line in which it occurred, if a
    file failed to parse properly.
}
{
 *  XMLParseGetDetailedParseError()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseGetDetailedParseError( aParser: ComponentInstance; var errorLine: SIGNEDLONG; errDesc: StringPtr ): ComponentResult; external name '_XMLParseGetDetailedParseError';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    Tell the parser of an element to be recognized. The tokenized element unique identifier is
    passed in *elementID, unless *elementID is zero, whereupon a unique ID is generated and returned.
    Thus, a valid element identifier can never be zero.
}
{
 *  XMLParseAddElement()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseAddElement( aParser: ComponentInstance; elementName: CStringPtr; nameSpaceID: UInt32; var elementID: UInt32; elementFlags: SIGNEDLONG ): ComponentResult; external name '_XMLParseAddElement';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    Tells the parser of an attribute for the specified element. The tokenized attribute unique
    ID is passed in *attributeID, unless *attributeID is zero, whereupon a unique ID is generated and
    returned. Thus, a valid attribute identifier can never be zero.
}
{
 *  XMLParseAddAttribute()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseAddAttribute( aParser: ComponentInstance; elementID: UInt32; nameSpaceID: UInt32; attributeName: CStringPtr; var attributeID: UInt32 ): ComponentResult; external name '_XMLParseAddAttribute';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    Tells the parser of several attributes for the specified element. The attributes are passed
    as a zero-delimited, double-zero-terminated C string in attributeNames, and the attribute
    IDs are passed in on attributeIDs as an array; if any attributeIDs are zero, unique IDs
    are generated for those and returned
}
{
 *  XMLParseAddMultipleAttributes()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseAddMultipleAttributes( aParser: ComponentInstance; elementID: UInt32; var nameSpaceIDs: UInt32; attributeNames: CStringPtr; var attributeIDs: UInt32 ): ComponentResult; external name '_XMLParseAddMultipleAttributes';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    Tells the parser of an attribute, which may have a particular type of value, for the
    specified element. Params are as in XMLParseAddAttribute, plus all the kinds of values
    the attribute may have are passed in attributeValueKind, and optional additional information
    required to tokenize the particular kind of attribute is passed in attributeValueKindInfo
}
{
 *  XMLParseAddAttributeAndValue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseAddAttributeAndValue ( aParser: ComponentInstance; elementID: UInt32; nameSpaceID: UInt32; attributeName: CStringPtr; var attributeID: UInt32; attributeValueKind: UInt32; attributeValueKindInfo: UnivPtr ): ComponentResult; external name '_XMLParseAddAttributeAndValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    Tells the parser of several attributes, which may have a particular type of value, for the
    specified element. Params are as in XMLParseAddMultipleAttributes, plus all the kinds of values
    the attributes may have are passed in attributeValueKinds, and optional additional information
    required to tokenize the particular kind of attributes is passed in attributeValueKindInfos
}
{
 *  XMLParseAddMultipleAttributesAndValues()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseAddMultipleAttributesAndValues( aParser: ComponentInstance; elementID: UInt32; var nameSpaceIDs: UInt32; attributeNames: CStringPtr; var attributeIDs: UInt32; var attributeValueKinds: UInt32; var attributeValueKindInfos: UnivPtr ): ComponentResult; external name '_XMLParseAddMultipleAttributesAndValues';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    Tells the parser that the particular attribute may have an additional kind of
    value, as specified by attributeValueKind and attributeValueKindInfo
}
{
 *  XMLParseAddAttributeValueKind()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseAddAttributeValueKind( aParser: ComponentInstance; elementID: UInt32; attributeID: UInt32; attributeValueKind: UInt32; attributeValueKindInfo: UnivPtr ): ComponentResult; external name '_XMLParseAddAttributeValueKind';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    Tell the parser of a namespace to be recognized. The tokenized namespace unique identifier is
    passed in *nameSpaceID, unless *nameSpaceID is zero, whereupon a unique ID is generated and returned.
    Thus, a valid nameSpaceID identifier can never be zero.
}
{
 *  XMLParseAddNameSpace()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseAddNameSpace( aParser: ComponentInstance; nameSpaceURL: CStringPtr; var nameSpaceID: UInt32 ): ComponentResult; external name '_XMLParseAddNameSpace';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{  Specifies the offset and limit for reading from the dataref to be used when parsing}
{
 *  XMLParseSetOffsetAndLimit()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseSetOffsetAndLimit( aParser: ComponentInstance; offset: UInt32; limit: UInt32 ): ComponentResult; external name '_XMLParseSetOffsetAndLimit';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{  Set the event parse refcon}
{
 *  XMLParseSetEventParseRefCon()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseSetEventParseRefCon( aParser: ComponentInstance; refcon: SIGNEDLONG ): ComponentResult; external name '_XMLParseSetEventParseRefCon';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{  Set the start document handler UPP for event parsing}
{
 *  XMLParseSetStartDocumentHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseSetStartDocumentHandler( aParser: ComponentInstance; startDocument: StartDocumentHandlerUPP ): ComponentResult; external name '_XMLParseSetStartDocumentHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{  Set the end document handler UPP for event parsing}
{
 *  XMLParseSetEndDocumentHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseSetEndDocumentHandler( aParser: ComponentInstance; endDocument: EndDocumentHandlerUPP ): ComponentResult; external name '_XMLParseSetEndDocumentHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{  Set the start element handler UPP for event parsing}
{
 *  XMLParseSetStartElementHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseSetStartElementHandler( aParser: ComponentInstance; startElement: StartElementHandlerUPP ): ComponentResult; external name '_XMLParseSetStartElementHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{  Set the end element handler UPP for event parsing}
{
 *  XMLParseSetEndElementHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseSetEndElementHandler( aParser: ComponentInstance; endElement: EndElementHandlerUPP ): ComponentResult; external name '_XMLParseSetEndElementHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{  Set the character data handler UPP for event parsing}
{
 *  XMLParseSetCharDataHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseSetCharDataHandler( aParser: ComponentInstance; charData: CharDataHandlerUPP ): ComponentResult; external name '_XMLParseSetCharDataHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{  Set the preprocess instruction handler UPP for event parsing}
{
 *  XMLParseSetPreprocessInstructionHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseSetPreprocessInstructionHandler( aParser: ComponentInstance; preprocessInstruction: PreprocessInstructionHandlerUPP ): ComponentResult; external name '_XMLParseSetPreprocessInstructionHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{  Set the comment handler UPP for event parsing}
{
 *  XMLParseSetCommentHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function XMLParseSetCommentHandler( aParser: ComponentInstance; comment: CommentHandlerUPP ): ComponentResult; external name '_XMLParseSetCommentHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{  Set the cdata handler UPP for event parsing}
{
 *  XMLParseSetCDataHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function XMLParseSetCDataHandler( aParser: ComponentInstance; cdata: CDataHandlerUPP ): ComponentResult; external name '_XMLParseSetCDataHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
    Helper Macros
    
        These macros allow you to easily add entities and attributes to the parser
        in an error free manner when the identifiers are defined in a particular manner.
        For these to work, you must define the identifiers as follows:
        
        For entities, they must be defined as element_elementName, as in:
        
            enum
            (
                element_xml =   1,      //  "xml"
                element_head,           //  "head"
                element_body            //  "body"
            );
            
        If the element name has characters that are illegal in an identifier,
        some of the macros support that, but the identifier must not contain
        the illegal characters:
        
            enum
            (
                element_rootlayout      //  "root-layout"
            )
            
        For attribute names, similar rules apply except that they must be defined
        as attr_attributeName, as in:
            
            enum
            (
                attr_src    =   1,      //  "src"
                attr_href,
                attr_width,
                attr_height
            )
            
        Finally, the existence of local variables elementID and attributeID is required.
}
{
    Adds the specified element to the parser, i.e. XML_ADD_ELEMENT(head) adds the element "head" with
    a unique identifier of element_head
}
{
    Adds the specified element to the parser, not using the same string to generate the identifier and
    the element name. Use for element names that contain characters which are illegal in identifiers,
    i.e XML_ADD_COMPLEX_ELEMENT("root-layout",rootlayout) adds the element "root-layout" with a unique
    identifier of element_rootlayout
}
{
    Adds the specified attribute to the current element in the parser, i.e. XML_ADD_ATTRIBUTE(src)
    adds the attribute "src" to the current element, and identifies it by attr_src
}
{
    Adds the specified attribute to the current element in the parser, i.e. XML_ADD_ATTRIBUTE(element_img, src)
    adds the attribute "src" to the element_img element, and identifies it by attr_src
    Adds the specified attribute to the current element in the parser, not using the same string to
    generate the identifier and the element name. Use for attribute names that contain characters which
    are illegal in identifiers, i.e XML_ADD_COMPLEX_ATTRIBUTE("http-equiv",httpequiv) adds the element
    "http-equiv" with a unique identifier of attr_httpequiv
}


{
    General Sequence Grab stuff
}
type
	SeqGrabComponent = ComponentInstance;
	SGChannel = ComponentInstance;
const
	SeqGrabComponentType = FourCharCode('barg');
	SeqGrabChannelType = FourCharCode('sgch');
	SeqGrabPanelType = FourCharCode('sgpn');
	SeqGrabCompressionPanelType = FourCharCode('cmpr');
	SeqGrabSourcePanelType = FourCharCode('sour');

const
	seqGrabToDisk = 1;
	seqGrabToMemory = 2;
	seqGrabDontUseTempMemory = 4;
	seqGrabAppendToFile = 8;
	seqGrabDontAddMovieResource = 16;
	seqGrabDontMakeMovie = 32;
	seqGrabPreExtendFile = 64;
	seqGrabDataProcIsInterruptSafe = 128;
	seqGrabDataProcDoesOverlappingReads = 256;
	seqGrabDontPreAllocateFileSize = 512;  { Don't set the size of the file before capture unless the file has been pre-extended }

type
	SeqGrabDataOutputEnum = UNSIGNEDLONG;
const
	seqGrabRecord = 1;
	seqGrabPreview = 2;
	seqGrabPlayDuringRecord = 4;
	seqGrabLowLatencyCapture = 8;    { return the freshest frame possible, for live work (videoconferencing, live broadcast, live image processing) }
	seqGrabAlwaysUseTimeBase = 16;   { Tell VDIGs to use TimebaseTime always, rather than creating uniform frame durations, for more accurate live sync with audio }
	seqGrabRecordPreferQualityOverFrameRate = 32; { quality is more important than frame rate: client rather drop frame instead of lower quality to achieve full frame rate }

type
	SeqGrabUsageEnum = UNSIGNEDLONG;
const
	seqGrabHasBounds = 1;
	seqGrabHasVolume = 2;
	seqGrabHasDiscreteSamples = 4;
	seqGrabDoNotBufferizeData = 8;
	seqGrabCanMoveWindowWhileRecording = 16;

type
	SeqGrabChannelInfoEnum = UNSIGNEDLONG;
	SGOutputRecord = record
		data: array [0..0] of SIGNEDLONG;
	end;
	SGOutputRecordPtr = ^SGOutputRecord;
type
	SGOutput							= ^SGOutputRecord;
	SeqGrabFrameInfo = record
		frameOffset: SIGNEDLONG;
		frameTime: SIGNEDLONG;
		frameSize: SIGNEDLONG;
		frameChannel: SGChannel;
		frameRefCon: SIGNEDLONG;
	end;
	SeqGrabFrameInfoPtr = ^SeqGrabFrameInfo;
type
	SeqGrabExtendedFrameInfo = record
		frameOffset: wide;
		frameTime: SIGNEDLONG;
		frameSize: SIGNEDLONG;
		frameChannel: SGChannel;
		frameRefCon: SIGNEDLONG;
		frameOutput: SGOutput;
	end;
	SeqGrabExtendedFrameInfoPtr = ^SeqGrabExtendedFrameInfo;
const
	grabPictOffScreen = 1;
	grabPictIgnoreClip = 2;
	grabPictCurrentImage = 4;

const
	sgFlagControlledGrab = 1 shl 0;
	sgFlagAllowNonRGBPixMaps = 1 shl 1;

type
	SGDataProcPtr = function( c: SGChannel; p: Ptr; len: SIGNEDLONG; var offset: SIGNEDLONG; chRefCon: SIGNEDLONG; time: TimeValue; writeType: SInt16; refCon: SIGNEDLONG ): OSErr;
	SGDataUPP = SGDataProcPtr;
type
	SGDeviceInputNamePtr = ^SGDeviceInputName;
	SGDeviceInputName = record
		name: Str63;
		icon: Handle;
		flags: SIGNEDLONG;
		reserved: SIGNEDLONG;               { zero}
	end;
const
	sgDeviceInputNameFlagInputUnavailable = 1 shl 0;

type
	SGDeviceInputListRecordPtr = ^SGDeviceInputListRecord;
	SGDeviceInputListRecord = record
		count: SInt16;
		selectedIndex: SInt16;
		reserved: SIGNEDLONG;               { zero}
		entry: array [0..0] of SGDeviceInputName;
	end;
type
	SGDeviceInputListPtr = SGDeviceInputListRecordPtr;
	SGDeviceInputList = ^SGDeviceInputListPtr;
	SGDeviceNamePtr = ^SGDeviceName;
	SGDeviceName = record
		name: Str63;
		icon: Handle;
		flags: SIGNEDLONG;
		refCon: SIGNEDLONG;
		inputs: SGDeviceInputList;                 { list of inputs; formerly reserved to 0}
	end;
const
	sgDeviceNameFlagDeviceUnavailable = 1 shl 0;
	sgDeviceNameFlagShowInputsAsDevices = 1 shl 1;

type
	SGDeviceListRecordPtr = ^SGDeviceListRecord;
	SGDeviceListRecord = record
		count: SInt16;
		selectedIndex: SInt16;
		reserved: SIGNEDLONG;               { zero}
		entry: array [0..0] of SGDeviceName;
	end;
type
	SGDeviceListPtr = SGDeviceListRecordPtr;
	SGDeviceList = ^SGDeviceListPtr;
const
	sgDeviceListWithIcons = 1 shl 0;
	sgDeviceListDontCheckAvailability = 1 shl 1;
	sgDeviceListIncludeInputs = 1 shl 2;

const
	seqGrabWriteAppend = 0;
	seqGrabWriteReserve = 1;
	seqGrabWriteFill = 2;

const
	seqGrabUnpause = 0;
	seqGrabPause = 1;
	seqGrabPauseForMenu = 3;

const
	channelFlagDontOpenResFile = 2;
	channelFlagHasDependency = 4;

type
	SGModalFilterProcPtr = function( theDialog: DialogRef; const (*var*) theEvent: EventRecord; var itemHit: SInt16; refCon: SIGNEDLONG ): Boolean;
	SGModalFilterUPP = SGModalFilterProcPtr;
const
	sgPanelFlagForPanel = 1;

const
	seqGrabSettingsPreviewOnly = 1;


{
 *  Summary:
 *    Bit fields used in SGGetChannelPlayFlags and SGSetChannelPlayFlags
 }
const
{
   * Play flag specifying that the SGChannel should use its default
   * preview/playthru methodology.  Currently it is only used by the
   * VideoMediaType SGChannel.
   }
	channelPlayNormal = 0;

  {
   * Play flag specifying that the SGChannel should sacrifice playback
   * quality to achieve the specified playback rate.  Currently it is
   * only used by the VideoMediaType SGChannel.
   }
	channelPlayFast = 1 shl 0;

  {
   * Play flag specifying that the SGChannel should play its data at
   * the highest possible quality. This option sacrifices playback rate
   * for the sake of image quality. It may reduce the amount of
   * processor time available to other programs in the computer. This
   * option should not affect the quality of the recorded data,
   * however.  Currently it is only used by the VideoMediaType
   * SGChannel.
   }
	channelPlayHighQuality = 1 shl 1;

  {
   * Play flag specifying that the SGChannel should try to play all of
   * the data it captures, even the data that is stored in offscreen
   * buffers. This option is useful when you want to be sure that the
   * user sees as much of the captured data as possible. The sequence
   * grabber component sets this flag to 1 to play all the captured
   * data. The sequence grabber component may combine this flag with
   * any of the other values for the playFlags parameter.  Currently it
   * is only used by the VideoMediaType SGChannel.
   }
	channelPlayAllData = 1 shl 2;

  {
   * Play flag specifying that the SGChannel should preview/play raw
   * audio samples just after they are captured from its recording
   * device.  Currently it is only used by the SGAudioMediaType
   * SGChannel.
   }
	channelPlayPreMix = 1 shl 3;

  {
   * Play flag specifying that the SGChannel should preview/play audio
   * samples just after they are mixed down to the client-specified
   * movie track channel layout.  Currently it is only used by the
   * SGAudioMediaType SGChannel.
   }
	channelPlayPostMix = 1 shl 4;

  {
   * Play flag specifying that the SGChannel should preview/play audio
   * samples just before they are interleaved/converted/compressed to
   * the client-specified movie track format.  Currently it is only
   * used by the SGAudioMediaType SGChannel.
   }
	channelPlayPreConversion = 1 shl 5;

  {
   * Play flag specifying that the SGChannel should preview/play audio
   * samples after they have been interleaved/converted/compressed to
   * the client-specified movie track format.  Currently it is only
   * used by the SGAudioMediaType SGChannel.
   }
	channelPlayPostConversion = 1 shl 6;

{
 *  SGInitialize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGInitialize( s: SeqGrabComponent ): ComponentResult; external name '_SGInitialize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetDataOutput()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetDataOutput( s: SeqGrabComponent; const (*var*) movieFile: FSSpec; whereFlags: SIGNEDLONG ): ComponentResult; external name '_SGSetDataOutput';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetDataOutput()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetDataOutput( s: SeqGrabComponent; var movieFile: FSSpec; var whereFlags: SIGNEDLONG ): ComponentResult; external name '_SGGetDataOutput';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetGWorld( s: SeqGrabComponent; gp: CGrafPtr; gd: GDHandle ): ComponentResult; external name '_SGSetGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetGWorld( s: SeqGrabComponent; var gp: CGrafPtr; var gd: GDHandle ): ComponentResult; external name '_SGGetGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGNewChannel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGNewChannel( s: SeqGrabComponent; channelType: OSType; var ref: SGChannel ): ComponentResult; external name '_SGNewChannel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGDisposeChannel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGDisposeChannel( s: SeqGrabComponent; c: SGChannel ): ComponentResult; external name '_SGDisposeChannel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGStartPreview()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGStartPreview( s: SeqGrabComponent ): ComponentResult; external name '_SGStartPreview';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGStartRecord()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGStartRecord( s: SeqGrabComponent ): ComponentResult; external name '_SGStartRecord';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGIdle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGIdle( s: SeqGrabComponent ): ComponentResult; external name '_SGIdle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGStop()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGStop( s: SeqGrabComponent ): ComponentResult; external name '_SGStop';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPause()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPause( s: SeqGrabComponent; pause: ByteParameter ): ComponentResult; external name '_SGPause';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPrepare()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPrepare( s: SeqGrabComponent; prepareForPreview: Boolean; prepareForRecord: Boolean ): ComponentResult; external name '_SGPrepare';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGRelease()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGRelease( s: SeqGrabComponent ): ComponentResult; external name '_SGRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetMovie( s: SeqGrabComponent ): Movie; external name '_SGGetMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetMaximumRecordTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetMaximumRecordTime( s: SeqGrabComponent; ticks: UNSIGNEDLONG ): ComponentResult; external name '_SGSetMaximumRecordTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetMaximumRecordTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetMaximumRecordTime( s: SeqGrabComponent; var ticks: UNSIGNEDLONG ): ComponentResult; external name '_SGGetMaximumRecordTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetStorageSpaceRemaining()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetStorageSpaceRemaining( s: SeqGrabComponent; var bytes: UNSIGNEDLONG ): ComponentResult; external name '_SGGetStorageSpaceRemaining';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetTimeRemaining()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetTimeRemaining( s: SeqGrabComponent; var ticksLeft: SIGNEDLONG ): ComponentResult; external name '_SGGetTimeRemaining';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGrabPict()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGrabPict( s: SeqGrabComponent; var p: PicHandle; const (*var*) bounds: Rect; offscreenDepth: SInt16; grabPictFlags: SIGNEDLONG ): ComponentResult; external name '_SGGrabPict';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetLastMovieResID()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetLastMovieResID( s: SeqGrabComponent; var resID: SInt16 ): ComponentResult; external name '_SGGetLastMovieResID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetFlags( s: SeqGrabComponent; sgFlags: SIGNEDLONG ): ComponentResult; external name '_SGSetFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetFlags( s: SeqGrabComponent; var sgFlags: SIGNEDLONG ): ComponentResult; external name '_SGGetFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetDataProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetDataProc( s: SeqGrabComponent; proc: SGDataUPP; refCon: SIGNEDLONG ): ComponentResult; external name '_SGSetDataProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGNewChannelFromComponent()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGNewChannelFromComponent( s: SeqGrabComponent; var newChannel: SGChannel; sgChannelComponent: Component ): ComponentResult; external name '_SGNewChannelFromComponent';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGDisposeDeviceList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGDisposeDeviceList( s: SeqGrabComponent; list: SGDeviceList ): ComponentResult; external name '_SGDisposeDeviceList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGAppendDeviceListToMenu()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGAppendDeviceListToMenu( s: SeqGrabComponent; list: SGDeviceList; mh: MenuRef ): ComponentResult; external name '_SGAppendDeviceListToMenu';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetSettings( s: SeqGrabComponent; ud: UserData; flags: SIGNEDLONG ): ComponentResult; external name '_SGSetSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetSettings( s: SeqGrabComponent; var ud: UserData; flags: SIGNEDLONG ): ComponentResult; external name '_SGGetSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetIndChannel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetIndChannel( s: SeqGrabComponent; index: SInt16; var ref: SGChannel; var chanType: OSType ): ComponentResult; external name '_SGGetIndChannel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGUpdate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGUpdate( s: SeqGrabComponent; updateRgn: RgnHandle ): ComponentResult; external name '_SGUpdate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetPause()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetPause( s: SeqGrabComponent; var paused: Byte ): ComponentResult; external name '_SGGetPause';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


type
	ConstComponentListPtr = ^Component;
{
 *  SGSettingsDialog()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSettingsDialog( s: SeqGrabComponent; c: SGChannel; numPanels: SInt16; panelList: ConstComponentListPtr; flags: SIGNEDLONG; proc: SGModalFilterUPP; procRefNum: SIGNEDLONG ): ComponentResult; external name '_SGSettingsDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetAlignmentProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetAlignmentProc( s: SeqGrabComponent; alignmentProc: ICMAlignmentProcRecordPtr ): ComponentResult; external name '_SGGetAlignmentProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetChannelSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetChannelSettings( s: SeqGrabComponent; c: SGChannel; ud: UserData; flags: SIGNEDLONG ): ComponentResult; external name '_SGSetChannelSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetChannelSettings( s: SeqGrabComponent; c: SGChannel; var ud: UserData; flags: SIGNEDLONG ): ComponentResult; external name '_SGGetChannelSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetMode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetMode( s: SeqGrabComponent; var previewMode: Boolean; var recordMode: Boolean ): ComponentResult; external name '_SGGetMode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetDataRef( s: SeqGrabComponent; dataRef: Handle; dataRefType: OSType; whereFlags: SIGNEDLONG ): ComponentResult; external name '_SGSetDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetDataRef( s: SeqGrabComponent; var dataRef: Handle; var dataRefType: OSType; var whereFlags: SIGNEDLONG ): ComponentResult; external name '_SGGetDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGNewOutput()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGNewOutput( s: SeqGrabComponent; dataRef: Handle; dataRefType: OSType; whereFlags: SIGNEDLONG; var sgOut: SGOutput ): ComponentResult; external name '_SGNewOutput';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGDisposeOutput()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGDisposeOutput( s: SeqGrabComponent; sgOut: SGOutput ): ComponentResult; external name '_SGDisposeOutput';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetOutputFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetOutputFlags( s: SeqGrabComponent; sgOut: SGOutput; whereFlags: SIGNEDLONG ): ComponentResult; external name '_SGSetOutputFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetChannelOutput()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetChannelOutput( s: SeqGrabComponent; c: SGChannel; sgOut: SGOutput ): ComponentResult; external name '_SGSetChannelOutput';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetDataOutputStorageSpaceRemaining()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetDataOutputStorageSpaceRemaining( s: SeqGrabComponent; sgOut: SGOutput; var space: UNSIGNEDLONG ): ComponentResult; external name '_SGGetDataOutputStorageSpaceRemaining';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGHandleUpdateEvent()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGHandleUpdateEvent( s: SeqGrabComponent; const (*var*) event: EventRecord; var handled: Boolean ): ComponentResult; external name '_SGHandleUpdateEvent';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetOutputNextOutput()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetOutputNextOutput( s: SeqGrabComponent; sgOut: SGOutput; nextOut: SGOutput ): ComponentResult; external name '_SGSetOutputNextOutput';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetOutputNextOutput()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetOutputNextOutput( s: SeqGrabComponent; sgOut: SGOutput; var nextOut: SGOutput ): ComponentResult; external name '_SGGetOutputNextOutput';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetOutputMaximumOffset()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetOutputMaximumOffset( s: SeqGrabComponent; sgOut: SGOutput; const (*var*) maxOffset: wide ): ComponentResult; external name '_SGSetOutputMaximumOffset';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetOutputMaximumOffset()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetOutputMaximumOffset( s: SeqGrabComponent; sgOut: SGOutput; var maxOffset: wide ): ComponentResult; external name '_SGGetOutputMaximumOffset';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetOutputDataReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetOutputDataReference( s: SeqGrabComponent; sgOut: SGOutput; var dataRef: Handle; var dataRefType: OSType ): ComponentResult; external name '_SGGetOutputDataReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGWriteExtendedMovieData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGWriteExtendedMovieData( s: SeqGrabComponent; c: SGChannel; p: Ptr; len: SIGNEDLONG; var offset: wide; var sgOut: SGOutput ): ComponentResult; external name '_SGWriteExtendedMovieData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetStorageSpaceRemaining64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function SGGetStorageSpaceRemaining64( s: SeqGrabComponent; var bytes: wide ): ComponentResult; external name '_SGGetStorageSpaceRemaining64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetDataOutputStorageSpaceRemaining64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function SGGetDataOutputStorageSpaceRemaining64( s: SeqGrabComponent; sgOut: SGOutput; var space: wide ): ComponentResult; external name '_SGGetDataOutputStorageSpaceRemaining64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    calls from Channel to seqGrab
}
{
 *  SGWriteMovieData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGWriteMovieData( s: SeqGrabComponent; c: SGChannel; p: Ptr; len: SIGNEDLONG; var offset: SIGNEDLONG ): ComponentResult; external name '_SGWriteMovieData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGAddFrameReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGAddFrameReference( s: SeqGrabComponent; frameInfo: SeqGrabFrameInfoPtr ): ComponentResult; external name '_SGAddFrameReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetNextFrameReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetNextFrameReference( s: SeqGrabComponent; frameInfo: SeqGrabFrameInfoPtr; var frameDuration: TimeValue; var frameNumber: SIGNEDLONG ): ComponentResult; external name '_SGGetNextFrameReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetTimeBase( s: SeqGrabComponent; var tb: TimeBase ): ComponentResult; external name '_SGGetTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSortDeviceList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSortDeviceList( s: SeqGrabComponent; list: SGDeviceList ): ComponentResult; external name '_SGSortDeviceList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGAddMovieData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGAddMovieData( s: SeqGrabComponent; c: SGChannel; p: Ptr; len: SIGNEDLONG; var offset: SIGNEDLONG; chRefCon: SIGNEDLONG; time: TimeValue; writeType: SInt16 ): ComponentResult; external name '_SGAddMovieData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGChangedSource()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGChangedSource( s: SeqGrabComponent; c: SGChannel ): ComponentResult; external name '_SGChangedSource';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGAddExtendedFrameReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGAddExtendedFrameReference( s: SeqGrabComponent; frameInfo: SeqGrabExtendedFrameInfoPtr ): ComponentResult; external name '_SGAddExtendedFrameReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetNextExtendedFrameReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetNextExtendedFrameReference( s: SeqGrabComponent; frameInfo: SeqGrabExtendedFrameInfoPtr; var frameDuration: TimeValue; var frameNumber: SIGNEDLONG ): ComponentResult; external name '_SGGetNextExtendedFrameReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGAddExtendedMovieData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGAddExtendedMovieData( s: SeqGrabComponent; c: SGChannel; p: Ptr; len: SIGNEDLONG; var offset: wide; chRefCon: SIGNEDLONG; time: TimeValue; writeType: SInt16; var whichOutput: SGOutput ): ComponentResult; external name '_SGAddExtendedMovieData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGAddOutputDataRefToMedia()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGAddOutputDataRefToMedia( s: SeqGrabComponent; sgOut: SGOutput; theMedia: Media; desc: SampleDescriptionHandle ): ComponentResult; external name '_SGAddOutputDataRefToMedia';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetSettingsSummary()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function SGSetSettingsSummary( s: SeqGrabComponent; summaryText: Handle ): ComponentResult; external name '_SGSetSettingsSummary';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{** Sequence Grab CHANNEL Component Stuff **}

{
 *  SGSetChannelUsage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetChannelUsage( c: SGChannel; usage: SIGNEDLONG ): ComponentResult; external name '_SGSetChannelUsage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelUsage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetChannelUsage( c: SGChannel; var usage: SIGNEDLONG ): ComponentResult; external name '_SGGetChannelUsage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetChannelBounds()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetChannelBounds( c: SGChannel; const (*var*) bounds: Rect ): ComponentResult; external name '_SGSetChannelBounds';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelBounds()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetChannelBounds( c: SGChannel; var bounds: Rect ): ComponentResult; external name '_SGGetChannelBounds';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetChannelVolume()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetChannelVolume( c: SGChannel; volume: SInt16 ): ComponentResult; external name '_SGSetChannelVolume';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelVolume()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetChannelVolume( c: SGChannel; var volume: SInt16 ): ComponentResult; external name '_SGGetChannelVolume';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetChannelInfo( c: SGChannel; var channelInfo: SIGNEDLONG ): ComponentResult; external name '_SGGetChannelInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetChannelPlayFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetChannelPlayFlags( c: SGChannel; playFlags: SIGNEDLONG ): ComponentResult; external name '_SGSetChannelPlayFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelPlayFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetChannelPlayFlags( c: SGChannel; var playFlags: SIGNEDLONG ): ComponentResult; external name '_SGGetChannelPlayFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetChannelMaxFrames()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetChannelMaxFrames( c: SGChannel; frameCount: SIGNEDLONG ): ComponentResult; external name '_SGSetChannelMaxFrames';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelMaxFrames()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetChannelMaxFrames( c: SGChannel; var frameCount: SIGNEDLONG ): ComponentResult; external name '_SGGetChannelMaxFrames';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetChannelRefCon()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetChannelRefCon( c: SGChannel; refCon: SIGNEDLONG ): ComponentResult; external name '_SGSetChannelRefCon';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetChannelClip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetChannelClip( c: SGChannel; theClip: RgnHandle ): ComponentResult; external name '_SGSetChannelClip';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelClip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetChannelClip( c: SGChannel; var theClip: RgnHandle ): ComponentResult; external name '_SGGetChannelClip';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelSampleDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetChannelSampleDescription( c: SGChannel; sampleDesc: Handle ): ComponentResult; external name '_SGGetChannelSampleDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelDeviceList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetChannelDeviceList( c: SGChannel; selectionFlags: SIGNEDLONG; var list: SGDeviceList ): ComponentResult; external name '_SGGetChannelDeviceList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetChannelDevice()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetChannelDevice( c: SGChannel; name: StringPtr ): ComponentResult; external name '_SGSetChannelDevice';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetChannelMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetChannelMatrix( c: SGChannel; const (*var*) m: MatrixRecord ): ComponentResult; external name '_SGSetChannelMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetChannelMatrix( c: SGChannel; var m: MatrixRecord ): ComponentResult; external name '_SGGetChannelMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelTimeScale()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetChannelTimeScale( c: SGChannel; var scale: TimeScale ): ComponentResult; external name '_SGGetChannelTimeScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGChannelPutPicture()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGChannelPutPicture( c: SGChannel ): ComponentResult; external name '_SGChannelPutPicture';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGChannelSetRequestedDataRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGChannelSetRequestedDataRate( c: SGChannel; bytesPerSecond: SIGNEDLONG ): ComponentResult; external name '_SGChannelSetRequestedDataRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGChannelGetRequestedDataRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGChannelGetRequestedDataRate( c: SGChannel; var bytesPerSecond: SIGNEDLONG ): ComponentResult; external name '_SGChannelGetRequestedDataRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGChannelSetDataSourceName()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGChannelSetDataSourceName( c: SGChannel; const (*var*) name: Str255; scriptTag: ScriptCode ): ComponentResult; external name '_SGChannelSetDataSourceName';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGChannelGetDataSourceName()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGChannelGetDataSourceName( c: SGChannel; var name: Str255; var scriptTag: ScriptCode ): ComponentResult; external name '_SGChannelGetDataSourceName';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGChannelSetCodecSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function SGChannelSetCodecSettings( c: SGChannel; settings: Handle ): ComponentResult; external name '_SGChannelSetCodecSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGChannelGetCodecSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function SGChannelGetCodecSettings( c: SGChannel; var settings: Handle ): ComponentResult; external name '_SGChannelGetCodecSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function SGGetChannelTimeBase( c: SGChannel; var tb: TimeBase ): ComponentResult; external name '_SGGetChannelTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetChannelRefCon()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function SGGetChannelRefCon( c: SGChannel; var refCon: SIGNEDLONG ): ComponentResult; external name '_SGGetChannelRefCon';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{ A utility call to find out the current device and input names, instead of having to call GetDeviceList and walk it yourself }
{
 *  SGGetChannelDeviceAndInputNames()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function SGGetChannelDeviceAndInputNames( c: SGChannel; var outDeviceName: Str255; var outInputName: Str255; var outInputNumber: SInt16 ): ComponentResult; external name '_SGGetChannelDeviceAndInputNames';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{ A media format independent call for this. Inputs start at 0 here (Sound starts at 1, VDIGs at 0 in direct calls) }
{
 *  SGSetChannelDeviceInput()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function SGSetChannelDeviceInput( c: SGChannel; inInputNumber: SInt16 ): ComponentResult; external name '_SGSetChannelDeviceInput';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{ A call to bracket SetSettings related calls, to give downstream components an opportunity to deal with the entire 
    settings change in one go }
const
	sgSetSettingsBegin = 1 shl 0; { SGSetSettings related set calls about to start}
	sgSetSettingsEnd = 1 shl 1; { Finished SGSetSettings calls. Get ready to use the new settings}

{
 *  SGSetChannelSettingsStateChanging()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function SGSetChannelSettingsStateChanging( c: SGChannel; inFlags: UInt32 ): ComponentResult; external name '_SGSetChannelSettingsStateChanging';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
    calls from seqGrab to Channel
}
{
 *  SGInitChannel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGInitChannel( c: SGChannel; owner: SeqGrabComponent ): ComponentResult; external name '_SGInitChannel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGWriteSamples()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGWriteSamples( c: SGChannel; m: Movie; theFile: AliasHandle ): ComponentResult; external name '_SGWriteSamples';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetDataRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetDataRate( c: SGChannel; var bytesPerSecond: SIGNEDLONG ): ComponentResult; external name '_SGGetDataRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGAlignChannelRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGAlignChannelRect( c: SGChannel; var r: Rect ): ComponentResult; external name '_SGAlignChannelRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    Dorky dialog panel calls
}
{
 *  SGPanelGetDitl()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPanelGetDitl( s: SeqGrabComponent; var ditl: Handle ): ComponentResult; external name '_SGPanelGetDitl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPanelGetTitle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPanelGetTitle( s: SeqGrabComponent; var title: Str255 ): ComponentResult; external name '_SGPanelGetTitle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPanelCanRun()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPanelCanRun( s: SeqGrabComponent; c: SGChannel ): ComponentResult; external name '_SGPanelCanRun';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPanelInstall()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPanelInstall( s: SeqGrabComponent; c: SGChannel; d: DialogRef; itemOffset: SInt16 ): ComponentResult; external name '_SGPanelInstall';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPanelEvent()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPanelEvent( s: SeqGrabComponent; c: SGChannel; d: DialogRef; itemOffset: SInt16; const (*var*) theEvent: EventRecord; var itemHit: SInt16; var handled: Boolean ): ComponentResult; external name '_SGPanelEvent';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPanelItem()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPanelItem( s: SeqGrabComponent; c: SGChannel; d: DialogRef; itemOffset: SInt16; itemNum: SInt16 ): ComponentResult; external name '_SGPanelItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPanelRemove()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPanelRemove( s: SeqGrabComponent; c: SGChannel; d: DialogRef; itemOffset: SInt16 ): ComponentResult; external name '_SGPanelRemove';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPanelSetGrabber()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPanelSetGrabber( s: SeqGrabComponent; sg: SeqGrabComponent ): ComponentResult; external name '_SGPanelSetGrabber';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPanelSetResFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPanelSetResFile( s: SeqGrabComponent; resRef: SInt16 ): ComponentResult; external name '_SGPanelSetResFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPanelGetSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPanelGetSettings( s: SeqGrabComponent; c: SGChannel; var ud: UserData; flags: SIGNEDLONG ): ComponentResult; external name '_SGPanelGetSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPanelSetSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPanelSetSettings( s: SeqGrabComponent; c: SGChannel; ud: UserData; flags: SIGNEDLONG ): ComponentResult; external name '_SGPanelSetSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPanelValidateInput()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPanelValidateInput( s: SeqGrabComponent; var ok: Boolean ): ComponentResult; external name '_SGPanelValidateInput';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGPanelSetEventFilter()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGPanelSetEventFilter( s: SeqGrabComponent; proc: SGModalFilterUPP; refCon: SIGNEDLONG ): ComponentResult; external name '_SGPanelSetEventFilter';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    SGPanelGetDITLForSize is used to retrieve user interface elements that fit within a specified size
    panel.  The component should return badComponentSelector for sizes it does not support.  The component
    is required to support kSGSmallestDITLSize, and it is recommended to support kSGLargestDITLSize.
    
    If SGPanelGetDITLForSize is unimplemented entirely, the panel is assumed to not have resizable UI elements.
}
const
	kSGSmallestDITLSize = -1;   { requestedSize h and v set to this to retrieve small size}
	kSGLargestDITLSize = -2;    { requestedSize h and v set to this to retrieve large size}

{
 *  SGPanelGetDITLForSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function SGPanelGetDITLForSize( s: SeqGrabComponent; var ditl: Handle; var requestedSize: Point ): ComponentResult; external name '_SGPanelGetDITLForSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{** Sequence Grab VIDEO CHANNEL Component Stuff **}
{
    Video stuff
}
type
	SGCompressInfoPtr = ^SGCompressInfo;
	SGCompressInfo = record
		buffer: Ptr;
		bufferSize: UNSIGNEDLONG;
		similarity: UInt8;
		reserved: UInt8;
	end;
type
	SGGrabBottleProcPtr = function( c: SGChannel; bufferNum: SInt16; refCon: SIGNEDLONG ): ComponentResult;
	SGGrabCompleteBottleProcPtr = function( c: SGChannel; bufferNum: SInt16; var done: Boolean; refCon: SIGNEDLONG ): ComponentResult;
	SGDisplayBottleProcPtr = function( c: SGChannel; bufferNum: SInt16; var mp: MatrixRecord; clipRgn: RgnHandle; refCon: SIGNEDLONG ): ComponentResult;
	SGCompressBottleProcPtr = function( c: SGChannel; bufferNum: SInt16; refCon: SIGNEDLONG ): ComponentResult;
	SGCompressCompleteBottleProcPtr = function( c: SGChannel; bufferNum: SInt16; var done: Boolean; var ci: SGCompressInfo; refCon: SIGNEDLONG ): ComponentResult;
	SGAddFrameBottleProcPtr = function( c: SGChannel; bufferNum: SInt16; atTime: TimeValue; scale: TimeScale; const (*var*) ci: SGCompressInfo; refCon: SIGNEDLONG ): ComponentResult;
	SGTransferFrameBottleProcPtr = function( c: SGChannel; bufferNum: SInt16; var mp: MatrixRecord; clipRgn: RgnHandle; refCon: SIGNEDLONG ): ComponentResult;
{    Note that UInt8 *queuedFrameCount replaces Boolean *done. 0(==false) still means no frames, and 1(==true) one, 
    but if more than one are available the number should be returned here. The value 2 previously meant more than one frame,
    so some VDIGs may return 2 even if more than 2 are available, and some will still return 1 as they are using the original definition. }
type
	SGGrabCompressCompleteBottleProcPtr = function( c: SGChannel; var queuedFrameCount: UInt8; var ci: SGCompressInfo; var t: TimeRecord; refCon: SIGNEDLONG ): ComponentResult;
	SGDisplayCompressBottleProcPtr = function( c: SGChannel; dataPtr: Ptr; desc: ImageDescriptionHandle; var mp: MatrixRecord; clipRgn: RgnHandle; refCon: SIGNEDLONG ): ComponentResult;
	SGGrabBottleUPP = SGGrabBottleProcPtr;
	SGGrabCompleteBottleUPP = SGGrabCompleteBottleProcPtr;
	SGDisplayBottleUPP = SGDisplayBottleProcPtr;
	SGCompressBottleUPP = SGCompressBottleProcPtr;
	SGCompressCompleteBottleUPP = SGCompressCompleteBottleProcPtr;
	SGAddFrameBottleUPP = SGAddFrameBottleProcPtr;
	SGTransferFrameBottleUPP = SGTransferFrameBottleProcPtr;
	SGGrabCompressCompleteBottleUPP = SGGrabCompressCompleteBottleProcPtr;
	SGDisplayCompressBottleUPP = SGDisplayCompressBottleProcPtr;

	VideoBottlesPtr = ^VideoBottles;
	VideoBottles = record
		procCount: SInt16;
		grabProc: SGGrabBottleUPP;
		grabCompleteProc: SGGrabCompleteBottleUPP;
		displayProc: SGDisplayBottleUPP;
		compressProc: SGCompressBottleUPP;
		compressCompleteProc: SGCompressCompleteBottleUPP;
		addFrameProc: SGAddFrameBottleUPP;
		transferFrameProc: SGTransferFrameBottleUPP;
		grabCompressCompleteProc: SGGrabCompressCompleteBottleUPP;
		displayCompressProc: SGDisplayCompressBottleUPP;
	end;
{
 *  SGGetSrcVideoBounds()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetSrcVideoBounds( c: SGChannel; var r: Rect ): ComponentResult; external name '_SGGetSrcVideoBounds';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetVideoRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetVideoRect( c: SGChannel; const (*var*) r: Rect ): ComponentResult; external name '_SGSetVideoRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetVideoRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetVideoRect( c: SGChannel; var r: Rect ): ComponentResult; external name '_SGGetVideoRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetVideoCompressorType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetVideoCompressorType( c: SGChannel; var compressorType: OSType ): ComponentResult; external name '_SGGetVideoCompressorType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetVideoCompressorType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetVideoCompressorType( c: SGChannel; compressorType: OSType ): ComponentResult; external name '_SGSetVideoCompressorType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetVideoCompressor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetVideoCompressor( c: SGChannel; depth: SInt16; compressor: CompressorComponent; spatialQuality: CodecQ; temporalQuality: CodecQ; keyFrameRate: SIGNEDLONG ): ComponentResult; external name '_SGSetVideoCompressor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetVideoCompressor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetVideoCompressor( c: SGChannel; var depth: SInt16; var compressor: CompressorComponent; var spatialQuality: CodecQ; var temporalQuality: CodecQ; var keyFrameRate: SIGNEDLONG ): ComponentResult; external name '_SGGetVideoCompressor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetVideoDigitizerComponent()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetVideoDigitizerComponent( c: SGChannel ): ComponentInstance; external name '_SGGetVideoDigitizerComponent';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetVideoDigitizerComponent()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetVideoDigitizerComponent( c: SGChannel; vdig: ComponentInstance ): ComponentResult; external name '_SGSetVideoDigitizerComponent';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGVideoDigitizerChanged()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGVideoDigitizerChanged( c: SGChannel ): ComponentResult; external name '_SGVideoDigitizerChanged';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetVideoBottlenecks()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetVideoBottlenecks( c: SGChannel; var vb: VideoBottles ): ComponentResult; external name '_SGSetVideoBottlenecks';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetVideoBottlenecks()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetVideoBottlenecks( c: SGChannel; var vb: VideoBottles ): ComponentResult; external name '_SGGetVideoBottlenecks';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGrabFrame()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGrabFrame( c: SGChannel; bufferNum: SInt16 ): ComponentResult; external name '_SGGrabFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGrabFrameComplete()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGrabFrameComplete( c: SGChannel; bufferNum: SInt16; var done: Boolean ): ComponentResult; external name '_SGGrabFrameComplete';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGDisplayFrame()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGDisplayFrame( c: SGChannel; bufferNum: SInt16; const (*var*) mp: MatrixRecord; clipRgn: RgnHandle ): ComponentResult; external name '_SGDisplayFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGCompressFrame()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGCompressFrame( c: SGChannel; bufferNum: SInt16 ): ComponentResult; external name '_SGCompressFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGCompressFrameComplete()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGCompressFrameComplete( c: SGChannel; bufferNum: SInt16; var done: Boolean; var ci: SGCompressInfo ): ComponentResult; external name '_SGCompressFrameComplete';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGAddFrame()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGAddFrame( c: SGChannel; bufferNum: SInt16; atTime: TimeValue; scale: TimeScale; const (*var*) ci: SGCompressInfo ): ComponentResult; external name '_SGAddFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGTransferFrameForCompress()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGTransferFrameForCompress( c: SGChannel; bufferNum: SInt16; const (*var*) mp: MatrixRecord; clipRgn: RgnHandle ): ComponentResult; external name '_SGTransferFrameForCompress';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetCompressBuffer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetCompressBuffer( c: SGChannel; depth: SInt16; const (*var*) compressSize: Rect ): ComponentResult; external name '_SGSetCompressBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetCompressBuffer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetCompressBuffer( c: SGChannel; var depth: SInt16; var compressSize: Rect ): ComponentResult; external name '_SGGetCompressBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetBufferInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetBufferInfo( c: SGChannel; bufferNum: SInt16; var bufferPM: PixMapHandle; var bufferRect: Rect; var compressBuffer: GWorldPtr; var compressBufferRect: Rect ): ComponentResult; external name '_SGGetBufferInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetUseScreenBuffer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetUseScreenBuffer( c: SGChannel; useScreenBuffer: Boolean ): ComponentResult; external name '_SGSetUseScreenBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetUseScreenBuffer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetUseScreenBuffer( c: SGChannel; var useScreenBuffer: Boolean ): ComponentResult; external name '_SGGetUseScreenBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{    Note that UInt8 *queuedFrameCount replaces Boolean *done. 0(==false) still means no frames, and 1(==true) one, 
    but if more than one are available the number should be returned here. The value 2 previously meant more than one frame,
    so some VDIGs may return 2 even if more than 2 are available, and some will still return 1 as they are using the original definition. }
{
 *  SGGrabCompressComplete()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGrabCompressComplete( c: SGChannel; var queuedFrameCount: UInt8; var ci: SGCompressInfo; var tr: TimeRecord ): ComponentResult; external name '_SGGrabCompressComplete';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGDisplayCompress()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGDisplayCompress( c: SGChannel; dataPtr: Ptr; desc: ImageDescriptionHandle; var mp: MatrixRecord; clipRgn: RgnHandle ): ComponentResult; external name '_SGDisplayCompress';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetFrameRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetFrameRate( c: SGChannel; frameRate: Fixed ): ComponentResult; external name '_SGSetFrameRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetFrameRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetFrameRate( c: SGChannel; var frameRate: Fixed ): ComponentResult; external name '_SGGetFrameRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetPreferredPacketSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetPreferredPacketSize( c: SGChannel; preferredPacketSizeInBytes: SIGNEDLONG ): ComponentResult; external name '_SGSetPreferredPacketSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetPreferredPacketSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetPreferredPacketSize( c: SGChannel; var preferredPacketSizeInBytes: SIGNEDLONG ): ComponentResult; external name '_SGGetPreferredPacketSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetUserVideoCompressorList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetUserVideoCompressorList( c: SGChannel; compressorTypes: Handle ): ComponentResult; external name '_SGSetUserVideoCompressorList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetUserVideoCompressorList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetUserVideoCompressorList( c: SGChannel; var compressorTypes: Handle ): ComponentResult; external name '_SGGetUserVideoCompressorList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{** Sequence Grab AUDIO CHANNEL Component Stuff **}
{ -----------------------------------------------------------------------------
|                                                                               |
| *************************************                                         |
| * SGAUDIOCHANNEL COMPONENT SUBTYPE  *                                         |
| *************************************                                         |
|   SGAudioMediaType channel (aka SGAudioChannel) is a new Sequence Grabber     |
|   channel that enables multi-channel, high sample rate, wide bit-depth audio  |
|   recording, as well as writing of vbr audio compression formats.             |
|   SGAudioChannel is meant to replace the SoundMediaType SGChannel, as it can  |
|   do everything the old channel can do, and enables new features.             |
|                                                                               |
 ------------------------------------------------------------------------------}
const
	SGAudioMediaType = FourCharCode('audi');

{ -----------------------------------------------------------------------------
|                                                                               |
|   COMPONENT PROPERTY CLASSES used by SGAudioChannel                           |
|                                                                               |
|   Note: QTComponentProperty API's are defined in ImageCompression.h:          |
|       QTGetComponentPropertyInfo                                              |
|       QTGetComponentProperty                                                  |
|       QTSetComponentProperty                                                  |
|       QTAddComponentPropertyListener                                          |
|       QTRemoveComponentPropertyListener                                       |
|                                                                               |
|   Discussion: SGAudioMediaType channel uses standard QT Component Property    |
|   selectors to get, set, and listen to properties.  Component properties      |
|   take a property class as well as a property id.  SGAudioMediaType uses      |
|   the following property classes (see each property ID's discussion           |
|   for the specific property classes it understands)                           |
|                                                                               |
 ------------------------------------------------------------------------------}

{
 *  Summary:
 *    ComponentPropertyClass constants used by SGAudioChannel
 }
const
{
   * kQTPropertyClass_SGAudio: Used with properties that pertain to the
   * SGChannel as a whole, or to the output of an SGAudioChannel (i.e.
   * the resulting track in a QuickTime movie)
   }
	kQTPropertyClass_SGAudio = FourCharCode('audo');

  {
   * kQTPropertyClass_SGAudioRecordDevice: Used with properties that
   * pertain specifically to the physical settings of the device *FROM*
   * which SGAudioChannel is set to record or preview
   }
	kQTPropertyClass_SGAudioRecordDevice = FourCharCode('audr');

  {
   * kQTPropertyClass_SGAudioPreviewDevice: Used with properties that
   * pertain specifically to the physical settings of the device *TO*
   * which SGAudioChannel is set to preview
   }
	kQTPropertyClass_SGAudioPreviewDevice = FourCharCode('audp');


{ -----------------------------------------------------------------------------
|                                                                               |
|   COMPONENT PROPERTY ID'S used by SGAudioMediaType channel                    |
|                                                                               |
|   In addition to the Property ID's declared below, SGAudioMediaType channel   |
|   responds to kComponentPropertyClassPropertyInfo/kComponentPropertyInfoList, |
|   which returns a CFDataRef containing an array of ComponentPropertyInfo      |
|   structs (defined in ImageCompression.h)                                     |
|                                                                               |
|   Besides Component Property API's, SGAudioChannel responds to the following  |
|   old-style Sequence Grabber Channel property selectors:                      |
|                                                                               |
|       SGGetChannelUsage()                                                     |
|       SGSetChannelUsage()                                                     |
|           SGAudioChannel responds to the following usage flags:               |
|               seqGrabRecord                                                   |
|               seqGrabPreview                                                  |
|               seqGrabPlayDuringRecord                                         |
|                                                                               |
|       SGGetChannelInfo()                                                      |
|                                                                               |
|       SGGetChannelPlayFlags()                                                 |
|       SGSetChannelPlayFlags()                                                 |
|           SGAudioChannel responds to the following play flags:                |
|               channelPlayPreMix                                               |
|               channelPlayPostMix                                              |
|               channelPlayPreConversion                                        |
|               channelPlayPostConversion                                       |
|                                                                               |
|       SGGetChannelRefCon()                                                    |
|       SGSetChannelRefCon()                                                    |
|                                                                               |
|       SGGetChannelTimeBase()                                                  |
|                                                                               |
|       SGSetChannelSettingsStateChanging()                                     |
|       SGGetChannelSettings()                                                  |
|       SGSetChannelSettings()                                                  |
|                                                                               |
|       SGGetDataRate()                                                         |
|                                                                               |
|       SGGetChannelTimeScale()                                                 |
|                                                                               |
 ------------------------------------------------------------------------------}

{
 *  Summary:
 *    ComponentPropertyID constants used by SGAudioChannel
 }
const
{
   * kQTSGAudioPropertyID_DeviceListWithAttributes: Used to get a
   * CFArray of CFDictionaryRef's.  Each dictionary represents
   * attributes of one audio device. See below for list of supported
   * dictionary keys.  Note: all keys are not guaranteed to be present
   * for a given device. If the device list changes (i.e. a device is
   * hotplugged or unplugged), listeners of this property will be
   * notified. Note - caller is responsible for calling CFRelease() on
   * the resulting CFArray.
   }
	kQTSGAudioPropertyID_DeviceListWithAttributes = FourCharCode('#dva'); { Data: CFArrayRef, R/W/L: Read/Listen, Class(es): kQTPropertyClass_SGAudio  }

  {
   * kQTSGAudioPropertyID_DeviceAttributes: Used to get a
   * CFDictionaryRef representing attributes of the specified audio
   * device (record or preview). See below for list of supported
   * dictionary keys.  Note: all keys are not guaranteed to be present
   * for a given device. Note - caller is responsible for calling
   * CFRelease() on the resulting CFDictionary.
   }
	kQTSGAudioPropertyID_DeviceAttributes = FourCharCode('deva'); { Data: CFDictionaryRef, R/W/L: Read, Class(es): kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice }

  {
   * kQTSGAudioPropertyID_DeviceUID: Used to get the audio device
   * unique id for the current recording or preview, or set the current
   * recording or preview device to the specified audio device unique
   * id.  You may obtain the list of devices on the system using
   * kQTSGAudioPropertyID_DeviceListWithAttributes.  Note - caller is
   * responsible for calling CFRelease() on the resulting CFString.
   }
	kQTSGAudioPropertyID_DeviceUID = FourCharCode('uid '); { Data: CFStringRef, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice }

  {
   * kQTSGAudioPropertyID_DeviceAlive: If the device in question dies
   * (is hot unplugged) listeners of this property will be notified. 
   * If a record/preview operation is in progress, it will be stopped,
   * but it is left to the client to select a new device.
   }
	kQTSGAudioPropertyID_DeviceAlive = FourCharCode('aliv'); { Data: Boolean, R/W/L: Read/Listen, Class(es): kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice }

  {
   * kQTSGAudioPropertyID_DeviceHogged: If the device in question
   * becomes hogged or unhogged by another process, listeners of this
   * property will be notified. SGAudioMediaType channel does not hogs
   * devices, but if a client has reason to gain exclusive access to a
   * device, he may set this property to his process id (obtained by
   * calling getpid()).
   }
	kQTSGAudioPropertyID_DeviceHogged = FourCharCode('hogg'); { Data: pid_t, R/W/L: Read/Write/Listen, Class(es): kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice }

  {
   * kQTSGAudioPropertyID_DeviceInUse: If the device in question starts
   * to be used (for instance, another process starts performing i/o
   * with the device), listeners of this property will be notified.
   }
	kQTSGAudioPropertyID_DeviceInUse = FourCharCode('used'); { Data: Boolean, R/W/L: Read/Listen, Class(es): kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice }

  {
   * kQTSGAudioPropertyID_HardwarePlaythruEnabled: Use this property to
   * set hardware playthru during seqGrabPreview or
   * seqGrabPlayDuringRecord operations. Setting this value will have
   * no effect if the record device and preview device are not the
   * same.  Also, some devices do not support hardware playthru. 
   * Devices report whether or not they support this feature through
   * the kQTSGAudioPropertyID_DeviceListWithAttributes property.
   }
	kQTSGAudioPropertyID_HardwarePlaythruEnabled = FourCharCode('hard'); { Data: Boolean, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudioRecordDevice }

  {
   * kQTSGAudioPropertyID_ChannelLayout: Used to get/set a spatial or
   * discrete channel layout.  If used with kQTPropertyClass_SGAudio,
   * the AudioChannelLayout refers to the channels in the resulting
   * QuickTime movie sound track.  If used with
   * kQTPropertyClass_SGAudioRecordDevice, the AudioChannelLayout
   * refers to the input channels on the record device.  If used with
   * kQTPropertyClass_SGAudioPreviewDevice, the AudioChannelLayout
   * refers to the preview device output channels.  Note -
   * AudioChannelLayout is a variable size struct, so before calling
   * QTGetComponentProperty, you should call QTGetComponentPropertyInfo
   * to discover the size of the block of memory you should allocate to
   * hold the result.
   }
	kQTSGAudioPropertyID_ChannelLayout = FourCharCode('clay'); { Data: AudioChannelLayout, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudio, kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice }

  {
   * kQTSGAudioPropertyID_ChannelMap: Allows a client to enable or
   * disable channels on a recording device, as well as reorder them or
   * duplicate them to several output channels.  This property need not
   * be set if a client wishes to capture all channels from the record
   * device (this is the DEFAULT behavior).  Each element in the SInt32
   * array represents one output bus (into the SGAudioChannel) from the
   * record device.  The value of each element is the source channel
   * (zero-based) on the input device that should feed the specified
   * output. CHANNEL-DISABLING EXAMPLE: if you wish to capture just the
   * 1st, 3rd, and 5th channels from a 6-channel input device, your
   * channel map should be: SInt32 map[3] = ( 0, 2, 4 ).
   * CHANNEL-REORDERING EXAMPLE: if you wish to capture both channels
   * from a stereo input device, but you know the left and right
   * channels are reversed in the data source, you set your channel map
   * to: SInt32 map[2] = ( 1, 0 ). CHANNEL-DUPLICATION EXAMPLE: if you
   * wish to duplicate the second source channel into 4 outputs, set
   * your channel map thusly: SInt32 map[4] = ( 1, 1, 1, 1 ). EMPTY
   * CHANNEL EXAMPLE: if you need to produce a conformant stream of
   * audio, say, a 6-channel stream to send to an external 5.1 AC3
   * encoder, but you only have audio for the L, R, and C channels (on
   * record device channels 0, 1, and 2), you may set your channel map
   * thusly:  SInt32 map[6] = ( 0, 1, 2, -1, -1, -1 ).  The last 3
   * channels will be filled with silence.
   }
	kQTSGAudioPropertyID_ChannelMap = FourCharCode('cmap'); { Data: C-style array of SInt32's, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudioRecordDevice }

  {
   * kQTSGAudioPropertyID_CodecSpecificSettingsArray: Used to get or
   * set compressor-specific out-of-band settings.  This property is
   * only applicable when you are encoding to a compressed output
   * format (i.e. AAC, AMR).  This property is analogous to SCAudio's
   * kQTSCAudioPropertyID_CodecSpecificSettingsArray property (defined
   * in this header), or an AudioConverter's
   * kAudioConverterPropertySettings property (defined in
   * <AudioToolbox/AudioConverter.h>).  Note that not all compressed
   * formats expose a settings array. Older codecs may only expose a
   * magic cookie for out-of-band data (see the following property). 
   * When an audio compressor exposes a settings array, prefer it over
   * a magic cookie, as the settings array is richer. The
   * CodecSpecificSettingsArray is a CFArray of CFDictionaries, where
   * each dictionary represents one node in the audio converter's
   * processing chain.   The dictionary keys are defined in
   * <AudioUnit/AudioCodec.h>. For further information, see technotes:
   * <http://developer.apple.com/qa/qa2006/qa1437.html>
   * <http://developer.apple.com/qa/qa2006/qa1390.html>
   }
	kQTSGAudioPropertyID_CodecSpecificSettingsArray = FourCharCode('cdst'); { Data: CFArrayRef,  Read/Write, Class(es): kQTPropertyClass_SGAudio}

  {
   * kQTSGAudioPropertyID_MagicCookie: Used to get or set
   * compressor-specific out-of-band settings.  This is property is
   * only applicable to compressed formats that use a cookie.  The
   * kQTSGAudioPropertyID_CodecSpecificSettingsArray property should be
   * preferred over kQTSGAudioPropertyID_MagicCookie whenever a
   * compressor supports it.
   }
	kQTSGAudioPropertyID_MagicCookie = FourCharCode('kuki'); { Data: void * (opaque), R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudio     }

  {
   * kQTSGAudioPropertyID_StreamFormat: For kQTPropertyClass_SGAudio,
   * get/set the format of the audio as it will be written to the
   * destination QuickTime movie track.  For
   * kQTPropertyClass_SGAudioRecordDevice, get/set the format of audio
   * as it is physically recorded on the device (must be one of the
   * formats passed in kQTSGAudioPropertyID_StreamFormatList) Note that
   * the mChannelsPerFrame of the StreamFormat read from the
   * RecordDevice will not reflect channels that have been enabled or
   * disabled with the ChannelMap property.
   }
	kQTSGAudioPropertyID_StreamFormat = FourCharCode('frmt'); { Data: AudioStreamBasicDescription, R/W/L: Read/Write/Listen, Class(es): kQTPropertyClass_SGAudio, kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice }

  {
   * kQTSGAudioPropertyID_StreamFormatList: Used to get an array of
   * AudioStreamBasicDescriptions that describe valid combinations of
   * settings supported by the physical device in its current
   * configuration (sample rate, bit depth, number of channels).
   }
	kQTSGAudioPropertyID_StreamFormatList = FourCharCode('#frm'); { Data: C-style array of AudioStreamBasicDescription's, R/W/L: Read/Listen, Class(es): kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice }

  {
   * kQTSGAudioPropertyID_SoundDescription: The sound description that
   * describes the data written to the QuickTime movie track.  A
   * QTGetComponentProperty call allocates the SoundDescriptionHandle
   * for you.  Caller should declare a SoundDescriptionHandle and set
   * it to NULL, and pass its address to QTGetComponentProperty. 
   * Caller must DisposeHandle() the resulting SoundDescriptionHandle
   * when done with it.
   }
	kQTSGAudioPropertyID_SoundDescription = FourCharCode('snds'); { Data: SoundDescriptionHandle, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudio }

  {
   * kQTSGAudioPropertyID_InputSelection: Some devices allow switching
   * between data sources, such as analog, adat, sdi, aes/ebu, spdif.
   * Use this property to change the current input selection.  Note
   * that when input selection changes, the StreamFormat of the device
   * may change as well (In particular, the number of channels may
   * change).
   }
	kQTSGAudioPropertyID_InputSelection = FourCharCode('inpt'); { Data: OSType, R/W/L: Read/Write/Listen, Class(es): kQTPropertyClass_SGAudioRecordDevice }

  {
   * kQTSGAudioPropertyID_InputListWithAttributes: Used to get the list
   * of available input sources for a given device.  A CFArrayRef of
   * CFDictionaryRef's is returned, where each CFDictionaryRef
   * represents the attributes of one input (see below for a list of
   * valid keys). The caller is responsible for CFRelease()'ing the
   * returned array.
   }
	kQTSGAudioPropertyID_InputListWithAttributes = FourCharCode('#inp'); { Data: CFArrayRef, R/W/L: Read/Listen, Class(es): kQTPropertyClass_SGAudioRecordDevice }

  {
   * kQTSGAudioPropertyID_OutputSelection: Some devices allow switching
   * between output destinations, such as analog, adat, sdi, aes/ebu,
   * spdif. Use this property to change the current output selection. 
   * Note that when output selection changes, the StreamFormat of the
   * device may change as well (In particular, the number of channels
   * may change).
   }
	kQTSGAudioPropertyID_OutputSelection = FourCharCode('otpt'); { Data: OSType, R/W/L: Read/Write/Listen, Class(es): kQTPropertyClass_SGAudioPreviewDevice }

  {
   * kQTSGAudioPropertyID_OutputListWithAttributes: Used to get the
   * list of available output destinations for a given device.  A
   * CFArrayRef of CFDictionaryRef's is returned, where each
   * CFDictionaryRef represents the attributes of one output (see below
   * for a list of valid keys). The caller is responsible for
   * CFRelease()'ing the returned array.
   }
	kQTSGAudioPropertyID_OutputListWithAttributes = FourCharCode('#otp'); { Data: CFArrayRef, R/W/L: Read/Listen, Class(es): kQTPropertyClass_SGAudioPreviewDevice }

  {
   * kQTSGAudioPropertyID_LevelMetersEnabled: When used with
   * kQTPropertyClass_SGAudioRecordDevice or
   * kQTPropertyClass_SGAudioPreviewDevice, this turns device level
   * metering on/off.  When used with kQTPropertyClass_SGAudio, this
   * turns output level metering on/off.  When level meters are
   * enabled, use kQTSGAudioPropertyID_AveragePowerLevels to get
   * instantaneous levels.  Use kQTSGAudioPropertyID_PeakHoldLevels to
   * get peak-hold style meters (better for clipping detection, etc). 
   * Level meters should only be enabled if you intend to poll for
   * levels, as they incur an added CPU load when enabled.
   }
	kQTSGAudioPropertyID_LevelMetersEnabled = FourCharCode('lmet'); { Data: Boolean, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice, kQTPropertyClass_SGAudio }

  {
   * kQTSGAudioPropertyID_PeakHoldLevels:
   * kQTSGAudioPropertyID_PeakHoldLevelsmay only be read when level
   * meters are enabled.  The result is an array of Float32 values, one
   * for each channel on the device (or output) in question.  values
   * are in dB.  Poll for PeakHoldLevels as often as you would like to
   * update ui or look for clipping.  Note that the number of elements
   * in the float-32 array will be equal to the number of input
   * channels on your record device for
   * kQTPropertyClass_SGAudioRecordDevice (or the number of elements in
   * your kQTSGAudioPropertyID_ChannelMap, if you've set one), equal to
   * the number of output channels on your preview device for
   * kQTPropertyClass_SGAudioPreviewDevice, and equal to the number of
   * channels in your kQTSGAudioPropertyID_StreamFormat
   * (format.mChannelsPerFrame) for kQTPropertyClass_SGAudio.  Also
   * note that if you have requested hardware playthru, level metering
   * is unavailable.  Also note that if no channel mixdown is being
   * performed between record device and output formats, then
   * kQTSGAudioPropertyID_PeakHoldLevels for
   * kQTPropertyClass_SGAudioRecordDevice and kQTPropertyClass_SGAudio
   * will be equivalent.
   }
	kQTSGAudioPropertyID_PeakHoldLevels = FourCharCode('phlv'); { Data: C-style array of Float32's, R/W/L: Read, Class(es): kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice, kQTPropertyClass_SGAudio }

  {
   * kQTSGAudioPropertyID_AveragePowerLevels:
   * kQTSGAudioPropertyID_AveragePowerLevels may only be read when
   * level meters are enabled.  The result is an array of Float32
   * values, one for each channel on the device (or output) in
   * question.  values are in dB.  Poll for AveragePowerLevels as
   * frequently as you would like to update ui.  Note that the number
   * of elements in the float-32 array will be equal to the number of
   * input channels on your record device for
   * kQTPropertyClass_SGAudioRecordDevice (or the number of elements in
   * your kQTSGAudioPropertyID_ChannelMap, if you've set one), equal to
   * the number of output channels on your preview device for
   * kQTPropertyClass_SGAudioPreviewDevice, and equal to the number of
   * channels in your kQTSGAudioPropertyID_StreamFormat
   * (format.mChannelsPerFrame) for kQTPropertyClass_SGAudio.  Also
   * note that if you have requested hardware playthru, level metering
   * is unavailable.  Also note that if no channel mixdown is being
   * performed between record device and output formats, then
   * kQTSGAudioPropertyID_PeakHoldLevels for
   * kQTPropertyClass_SGAudioRecordDevice and kQTPropertyClass_SGAudio
   * will be equivalent.
   }
	kQTSGAudioPropertyID_AveragePowerLevels = FourCharCode('aplv'); { Data: C-style array of Float32's, R/W/L: Read, Class(es): kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice, kQTPropertyClass_SGAudio }

  {
   * kQTSGAudioPropertyID_MasterGain: With
   * kQTPropertyClass_SGAudioRecordDevice, this property gets/sets
   * master gain on the physical recording device with 0.0 = minimum
   * volume and 1.0 = the max volume of the device.  With
   * kQTPropertyClass_SGAudioPreviewDevice, this property gets/sets
   * master gain on the physical previewing device with 0.0 = minimum
   * volume and 1.0 = the max volume of the device.  With
   * kQTPropertyClass_SGAudio, this property gets/sets the master gain
   * (volume) of the recorded audio data in software (pre-mixdown) min
   * = 0.0, max = unbounded.  Normally you wouldn't set the volume
   * greater than 1.0, but if the source material provided by the
   * device is too soft, a gain of > 1.0 may be set to boost the gain. 
   * Note that some devices do not respond to this property setting.
   }
	kQTSGAudioPropertyID_MasterGain = FourCharCode('mgan'); { Data: Float32, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudio, kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice }

  {
   * kQTSGAudioPropertyID_PerChannelGain: With
   * kQTPropertyClass_SGAudioRecordDevice, this property gets/sets the
   * gain of each channel on the physical recording device.  Note that
   * the number of channels in the array for
   * kQTPropertyClass_SGAudioRecordDevice and
   * kQTPropertyClass_SGAudioPreviewDevice is equal to the total number
   * of channels on the device, which can be discovered using the
   * kQTSGAudioPropertyID_StreamFormat (on the recording device or
   * preview device).  The number of channels (and order of channels)
   * in the array for the kQTPropertyClass_SGAudio class must
   * correspond to the valence of channels on output (which is affected
   * by a channel map, if you've set one).  With
   * kQTPropertyClass_SGAudio, this property gets/sets the gain
   * (volume) of each channel of recorded audio data in software. 
   * Levels set on the record device or preview device must adhere to
   * min = 0.0, max = 1.0.  Levels set in software may be set to values
   * greater than 1.0 in order to boost low signals.  Caller may
   * specify that a particular channel gain level should be left alone
   * by setting the value to -1.0.  For instance, to set the gain of
   * channels 1, 2, and 3 to 0.5 on a 6 channel device, pass the
   * following array values in a SetProperty call: ( 0.5, 0.5, 0.5,
   * -1., -1., -1. ).
   }
	kQTSGAudioPropertyID_PerChannelGain = FourCharCode('cgan'); { Data: C-style array of Float32's, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudio, kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice              }

  {
   * kQTSGAudioPropertyID_GainScalarToDecibels: Both
   * kQTSGAudioPropertyID_MasterGain and
   * kQTSGAudioPropertyID_PerChannelGain properties express gain as a
   * scalar floating point value from 0.0 - 1.0 (for
   * kQTPropertyClass_SGAudioRecordDevice and
   * kQTPropertyClass_SGAudioPreviewDevice classes), and from 0.0 - 1.0
   * or greater (for kQTPropertyClass_SGAudio).  For UI purposes, it
   * may be useful to map the scalar gain value to a decibel value. 
   * kQTSGAudioPropertyID_GainScalarToDecibels is a read-only property
   * that takes a Float32 scalar value and returns the corresponding
   * decibel value for that scalar value.  Note that this property uses
   * the outPropValueAddress parameter of QTGetComponentProperty for
   * both input and output.  This property is available in QT 7.1 and
   * later.
   }
	kQTSGAudioPropertyID_GainScalarToDecibels = FourCharCode('gsdb'); { Data: Float32, R/W/L: Read, Class(es): kQTPropertyClass_SGAudio, kQTPropertyClass_SGAudioRecordDevice, kQTPropertyClass_SGAudioPreviewDevice}

  {
   * kQTSGAudioPropertyID_MixerCoefficients: If you wish to perform a
   * custom mix-down from the incoming record device channel valence
   * (discoverable using a combination of 
   * kQTPropertyClass_SGAudioRecordDevice /
   * kQTSGAudioPropertyID_StreamFormat &
   * kQTPropertyClass_SGAudioRecordDevice /
   * kQTSGAudioPropertyID_ChannelMap) to a different output number of
   * channels
   * (kQTPropertyClass_SGAudio-kQTSGAudioPropertyID_StreamFormat), you
   * may specify your own set of mixer coefficients which will be set
   * as volume values at each crosspoint in SGAudioMediaType's internal
   * matrix mixer. The value you pass is a two-dimensional array of
   * Float32's where the first dimension (rows) is the input channel
   * and the second dimension (columns) is the output channel.  Each
   * Float32 value is the gain level to apply.
   }
	kQTSGAudioPropertyID_MixerCoefficients = FourCharCode('mixc'); { Data: C-style array of Float32's, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudio}

  {
   * kQTSGAudioPropertyID_Settings: This property takes supercedes the
   * SGGet/SetChannelSettings calls.  SGAudioMediaType channel accepts
   * old-style 'soun' SGChannel settings in a QTSetComponentProperty
   * call, but always produces new-style settings in a
   * QTGetComponentProperty call.
   }
	kQTSGAudioPropertyID_Settings = FourCharCode('setu'); { Data: UserData, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudio }

  {
   * kQTSGAudioPropertyID_ChunkSize: Use this property to get/set the
   * number of seconds of audio that the SGAudioChannel should buffer
   * before writing.
   }
	kQTSGAudioPropertyID_ChunkSize = FourCharCode('chnk'); { Data: Float32, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudio }

  {
   * kQTSGAudioPropertyID_SoftPreviewLatency: If previewing or playing
   * thru while recording (and
   * kQTSGAudioPropertyID_HardwarePlaythruEnabled is not in use), a
   * client may specify in seconds the amount of latency to introduce
   * before beginning playback. By default, soft preview latency is 0
   * seconds.  As soon as audio data arrives from the recording device,
   * it is eligible to be played out to the preview device.  This
   * property may be of use if software preview breaks up due to the
   * recording device not delivering samples fast enough for the
   * preview device.
   }
	kQTSGAudioPropertyID_SoftPreviewLatency = FourCharCode('slat'); { Data: Float32, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudio }

  {
   * kQTSGAudioPropertyID_PreMixCallback: If you wish to receive a
   * callback when new audio samples become available from the
   * recording device (before they've been mixed down), set
   * kQTSGAudioPropertyID_PreMixCallback using an SGAudioCallbackStruct
   * containing a pointer to your SGAudioCallback function and a
   * refcon.  If you've previously registered a callback and no longer
   * wish to receive it, call QTSetComponentProperty again, this time
   * passing NULL for your inputProc and 0 for your inputRefCon.
   }
	kQTSGAudioPropertyID_PreMixCallback = FourCharCode('_mxc'); { Data: SGAudioCallbackStruct, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudio }

  {
   * kQTSGAudioPropertyID_PreMixCallbackFormat: Call
   * QTGetComponentProperty with
   * kQTSGAudioPropertyID_PreMixCallbackFormat to discover the format
   * of the audio that will be received in your Pre-Mix
   * SGAudioCallback.  Note that the format may not be available until
   * you've called SGPrepare().
   }
	kQTSGAudioPropertyID_PreMixCallbackFormat = FourCharCode('_mcf'); { Data: AudioStreamBasicDescription, R/W/L: Read, Class(es): kQTPropertyClass_SGAudio}

  {
   * kQTSGAudioPropertyID_PostMixCallback: If you wish to receive a
   * callback after audio samples have been mixed (the first step after
   * they are received from a recording device by SGAudioMediaType
   * channel), set kQTSGAudioPropertyID_PostMixCallback using an
   * SGAudioCallbackStruct containing a pointer to your SGAudioCallback
   * function and a refcon.  If you've previously registered a callback
   * and no longer wish to receive it, call QTSetComponentProperty
   * again, this time passing NULL for your inputProc and 0 for your
   * inputRefCon.
   }
	kQTSGAudioPropertyID_PostMixCallback = FourCharCode('mx_c'); { Data: SGAudioCallbackStruct, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudio }

  {
   * kQTSGAudioPropertyID_PostMixCallbackFormat: Call
   * QTGetComponentProperty with
   * kQTSGAudioPropertyID_PostMixCallbackFormat to discover the format
   * of the audio that will be received in your Post-Mix
   * SGAudioCallback.  Note that the format may not be available until
   * you've called SGPrepare().
   }
	kQTSGAudioPropertyID_PostMixCallbackFormat = FourCharCode('m_cf'); { Data: AudioStreamBasicDescription, R/W/L: Read, Class(es): kQTPropertyClass_SGAudio}

  {
   * kQTSGAudioPropertyID_PreConversionCallback: If you wish to receive
   * a callback just before audio samples are about to be sent through
   * an AudioConverter (for format conversion or compression), set
   * kQTSGAudioPropertyID_PreConversionCallback using an
   * SGAudioCallbackStruct containing a pointer to your SGAudioCallback
   * function and a refcon.  If you've previously registered a callback
   * and no longer wish to receive it, call QTSetComponentProperty
   * again, this time passing NULL for your inputProc and 0 for your
   * inputRefCon.
   }
	kQTSGAudioPropertyID_PreConversionCallback = FourCharCode('_cvc'); { Data: SGAudioCallbackStruct, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudio }

  {
   * kQTSGAudioPropertyID_PreConversionCallbackFormat: Call
   * QTGetComponentProperty with
   * kQTSGAudioPropertyID_PreConversionCallbackFormat to discover the
   * format of the audio that will be received in your Pre-Conversion
   * SGAudioCallback.  Note that the format may not be available until
   * you've called SGPrepare().
   }
	kQTSGAudioPropertyID_PreConversionCallbackFormat = FourCharCode('_ccf'); { Data: AudioStreamBasicDescription, R/W/L: Read, Class(es): kQTPropertyClass_SGAudio}

  {
   * kQTSGAudioPropertyID_PostConversionCallback: If you wish to
   * receive a callback right after audio samples have been sent
   * through an AudioConverter (for format conversion or compression),
   * set kQTSGAudioPropertyID_PostConversionCallback using an
   * SGAudioCallbackStruct containing a pointer to your SGAudioCallback
   * function and a refcon.  If you've previously registered a callback
   * and no longer wish to receive it, call QTSetComponentProperty
   * again, this time passing NULL for your inputProc and 0 for your
   * inputRefCon.
   }
	kQTSGAudioPropertyID_PostConversionCallback = FourCharCode('cv_c'); { Data: SGAudioCallbackStruct, R/W/L: Read/Write, Class(es): kQTPropertyClass_SGAudio }

  {
   * kQTSGAudioPropertyID_PostConversionCallbackFormat: Call
   * QTGetComponentProperty with
   * kQTSGAudioPropertyID_PostConversionCallbackFormat to discover the
   * format of the audio that will be received in your Post-Conversion
   * SGAudioCallback.  Note that the format may not be available until
   * you've called SGPrepare().
   }
	kQTSGAudioPropertyID_PostConversionCallbackFormat = FourCharCode('c_cf'); { Data: AudioStreamBasicDescription, R/W/L: Read, Class(es): kQTPropertyClass_SGAudio}


{ -----------------------------------------------------------------------------
|                                                                               |
|   SGAudioMediaType Channel - Device Attribute Keys                            |
|                                                                               |
|   These dictionary keys may be used to parse CFDictionaries returned by       |
|   kQTSGAudioPropertyID_DeviceListWithAttributes &                             |
|   kQTSGAudioPropertyID_DeviceAttributes                                       |
|                                                                               |
 ------------------------------------------------------------------------------}

{
 *  Summary:
 *    Device Attribute Key constants used by SGAudioChannel
 }
const
{
   * kQTAudioDeviceAttribute_DeviceUIDKey: value = CFStringRef. A
   * unique identifier for the device.
   }
	kQTAudioDeviceAttribute_DeviceUIDKey = kQTSGAudioPropertyID_DeviceUID;

  {
   * kQTAudioDeviceAttribute_DeviceNameKey: value = CFStringRef.  The
   * device printable name (suitable for gui).
   }
	kQTAudioDeviceAttribute_DeviceNameKey = FourCharCode('name');

  {
   * kQTAudioDeviceAttribute_DeviceManufacturerKey: value =
   * CFStringRef.  Device manufacturer printable name (suitable for
   * gui).
   }
	kQTAudioDeviceAttribute_DeviceManufacturerKey = FourCharCode('manu');

  {
   * kQTAudioDeviceAttribute_DeviceTransportTypeKey: value =
   * CFNumberRef. Wraps an OSType (i.e. '1394' for fw, see
   * IOAudioTypes.h).
   }
	kQTAudioDeviceAttribute_DeviceTransportTypeKey = FourCharCode('tran');

  {
   * kQTAudioDeviceAttribute_DeviceAliveKey: value = CFBooleanRef. 
   * True if device is present.
   }
	kQTAudioDeviceAttribute_DeviceAliveKey = kQTSGAudioPropertyID_DeviceAlive;

  {
   * kQTAudioDeviceAttribute_DeviceCanRecordKey: value = CFBooleanRef. 
   * True if device can be used for recording (some can only do
   * playback)
   }
	kQTAudioDeviceAttribute_DeviceCanRecordKey = FourCharCode('rec ');

  {
   * kQTAudioDeviceAttribute_DeviceCanPreviewKey: value = CFBooleanRef.
   *  True if device can be used to preview a grab.
   }
	kQTAudioDeviceAttribute_DeviceCanPreviewKey = FourCharCode('prev');

  {
   * kQTAudioDeviceAttribute_DeviceHoggedKey: value = CFNumberRef. 
   * CFNumber wraps the unique process ID that is hogging the device,
   * or -1 if the device is currently not being hogged.  Process id
   * comes from getpid().
   }
	kQTAudioDeviceAttribute_DeviceHoggedKey = kQTSGAudioPropertyID_DeviceHogged;

  {
   * kQTAudioDeviceAttribute_DeviceInUseKey: value = CFBooleanRef. 
   * True if someone is performing IO w/ the device (in any process).
   }
	kQTAudioDeviceAttribute_DeviceInUseKey = kQTSGAudioPropertyID_DeviceInUse;

  {
   * kQTAudioDeviceAttribute_DeviceSupportsHardwarePlaythruKey: value =
   * CFBooleanRef.  True if the device supports hardware playthru of
   * inputs to outputs.
   }
	kQTAudioDeviceAttribute_DeviceSupportsHardwarePlaythruKey = FourCharCode('hard');

  {
   * kQTAudioDeviceAttribute_InputSelectionKey: value = CFNumberRef. 
   * CFNumber wraps an OSType (device may or may not have an input
   * selection)
   }
	kQTAudioDeviceAttribute_InputSelectionKey = kQTSGAudioPropertyID_InputSelection;

  {
   * kQTAudioDeviceAttribute_InputListWithAttributesKey: value =
   * CFArrayRef.  Same as kQTSGAudioPropertyID_InputListWithAttributes.
   }
	kQTAudioDeviceAttribute_InputListWithAttributesKey = kQTSGAudioPropertyID_InputListWithAttributes;
	kQTAudioDeviceAttribute_OutputSelectionKey = kQTSGAudioPropertyID_OutputSelection;

  {
   * kQTAudioDeviceAttribute_OutputListWithAttributesKey: value =
   * CFArrayRef.  Same as kQTSGAudioPropertyID_OutputListWithAttributes.
   }
	kQTAudioDeviceAttribute_OutputListWithAttributesKey = kQTSGAudioPropertyID_OutputListWithAttributes;

  {
   * kQTAudioDeviceAttribute_DefaultInputDeviceKey: value =
   * CFBooleanRef.  True if it's the user-selected default input in
   * AudioMidiSetup.
   }
	kQTAudioDeviceAttribute_DefaultInputDeviceKey = FourCharCode('dIn ');

  {
   * kQTAudioDeviceAttribute_DefaultOutputDeviceKey: value =
   * CFBooleanRef.  True if it's the user-selected default output in
   * AudioMidiSetup.
   }
	kQTAudioDeviceAttribute_DefaultOutputDeviceKey = FourCharCode('dOut');

  {
   * kQTAudioDeviceAttribute_DefaultSystemOutputDeviceKey: value =
   * CFBooleanRef.  True if it's the user-selected device where system
   * alerts plays.
   }
	kQTAudioDeviceAttribute_DefaultSystemOutputDeviceKey = FourCharCode('sOut');

  {
   * kQTAudioDeviceAttribute_IsCoreAudioDeviceKey: value =
   * CFBooleanRef.  True if the device is a Core Audio device.
   }
	kQTAudioDeviceAttribute_IsCoreAudioDeviceKey = FourCharCode('hal!');


{ -----------------------------------------------------------------------------
|                                                                               |
|   SGAudioMediaType Channel - Device Attribute Keys for Inputs & Outputs       |
|                                                                               |
|   These dictionary keys may be used to parse CFDictionaries returned by       |
|   kQTSGAudioPropertyID_InputListWithAttributes &                              |
|   kQTSGAudioPropertyID_OutputListWithAttributes.                              |
|                                                                               |
 ------------------------------------------------------------------------------}

{
 *  Summary:
 *    Device Attribute Key constants for Inputs and Outputs used by
 *    SGAudioChannel
 }
const
{
   * kQTAudioDeviceAttribute_DeviceInputID: value = CFNumberRef that
   * wraps an OSType.
   }
	kQTAudioDeviceAttribute_DeviceInputID = FourCharCode('inID');

  {
   * kQTAudioDeviceAttribute_DeviceInputDescription: value =
   * CFStringRef containing a string suitable for ui display.
   }
	kQTAudioDeviceAttribute_DeviceInputDescription = FourCharCode('inds');

  {
   * kQTAudioDeviceAttribute_DeviceOutputID: value = CFNumberRef that
   * wraps an OSType.
   }
	kQTAudioDeviceAttribute_DeviceOutputID = FourCharCode('otID');

  {
   * kQTAudioDeviceAttribute_DeviceOutputDescription: value =
   * CFStringRef containing a string suitable for ui display.
   }
	kQTAudioDeviceAttribute_DeviceOutputDescription = FourCharCode('otds');


{ -----------------------------------------------------------------------------
|                                                                               |
|   SG SETTINGS CODES USED BY SGAudioMediaType SGChannel                        |
|                                                                               |
 ------------------------------------------------------------------------------}
const
	sgcAudioRecordDeviceSettingsAtom = kQTPropertyClass_SGAudioRecordDevice;
	sgcAudioPreviewDeviceSettingsAtom = kQTPropertyClass_SGAudioPreviewDevice;
	sgcAudioOutputSettingsAtom = kQTPropertyClass_SGAudio;
	sgcAudioSettingsVersion = FourCharCode('vers');
	sgcAudioDeviceUID = kQTAudioDeviceAttribute_DeviceUIDKey;
	sgcAudioDeviceName = kQTAudioDeviceAttribute_DeviceNameKey;
	sgcAudioStreamFormat = kQTSGAudioPropertyID_StreamFormat;
	sgcAudioInputSelection = kQTSGAudioPropertyID_InputSelection;
	sgcAudioOutputSelection = kQTSGAudioPropertyID_OutputSelection;
	sgcAudioChannelMap = kQTSGAudioPropertyID_ChannelMap;
	sgcAudioMasterGain = kQTSGAudioPropertyID_MasterGain;
	sgcAudioPerChannelGain = kQTSGAudioPropertyID_PerChannelGain;
	sgcAudioLevelMetersEnabled = kQTSGAudioPropertyID_LevelMetersEnabled;
	sgcAudioChannelLayout = kQTSGAudioPropertyID_ChannelLayout;
	sgcAudioCodecSpecificSettingsArray = kQTSGAudioPropertyID_CodecSpecificSettingsArray;
	sgcAudioMagicCookie = kQTSGAudioPropertyID_MagicCookie;
	sgcAudioHardwarePlaythruEnabled = kQTSGAudioPropertyID_HardwarePlaythruEnabled;
	sgcAudioMixerCoefficients = kQTSGAudioPropertyID_MixerCoefficients;
	sgcAudioChunkSize = kQTSGAudioPropertyID_ChunkSize;
	sgcAudioSoftPreviewLatency = kQTSGAudioPropertyID_SoftPreviewLatency;

{ -----------------------------------------------------------------------------
|                                                                               |
|   SGAudioMediaType Channel Callback Declarations                              |
|                                                                               |
 ------------------------------------------------------------------------------}

type
	SGAudioCallbackFlags = UInt32;

{
 *  SGAudioCallback
 *  
 *  Discussion:
 *    Clients define an SGAudioCallback to tap into an SGAudio channel,
 *    and gain access to its data at various point along the signal
 *    flow chain.  Clients should be aware that they may be called back
 *    on threads other than the thread on which they registered for the
 *    callback. They should do as little work as possible inside their
 *    callback, returning control as soon as possible to the calling
 *    SGAudio channel.
 *  
 *  Parameters:
 *    
 *    c:
 *      The SGChannel originating this callback
 *    
 *    inRefCon:
 *      The refCon assigned by the client when filling out an
 *      SGAudioCallbackStruct
 *    
 *    ioFlags:
 *      This flags field is currently unused.
 *    
 *    inTimeStamp:
 *      The time stamp associated with the first sample passed in inData
 *    
 *    inNumberPackets:
 *      The number of data packets (if dealing with LPCM formats,
 *      number of packets is the same as number of frames) held in
 *      inData.
 *    
 *    inData:
 *      A bufferlist containing the requested sample data.
 *    
 *    inPacketDescriptions:
 *      If the packets contained in inData are of variable size,
 *      inPacketDescriptions will contain an array of inNumberPackets
 *      packet descriptions.
 *  
 *  Result:
 *    OSStatus Your SGAudioCallback function should return noErr.
 }
type
	SGAudioCallback = function( c: SGChannel; inRefCon: UnivPtr; var ioFlags: SGAudioCallbackFlags; const (*var*) inTimeStamp: AudioTimeStamp; const (*var*) inNumberPackets: UInt32; const (*var*) inData: AudioBufferList; const (*var*) inPacketDescriptions: AudioStreamPacketDescription ): OSStatus;
	SGAudioCallbackStructPtr = ^SGAudioCallbackStruct;
	SGAudioCallbackStruct = record
		inputProc: SGAudioCallback;
		inputProcRefCon: UnivPtr;
	end;
{** Sequence Grab SOUND CHANNEL Component Stuff **}

{
    Sound stuff
}
{
 *  SGSetSoundInputDriver()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetSoundInputDriver( c: SGChannel; const (*var*) driverName: Str255 ): ComponentResult; external name '_SGSetSoundInputDriver';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetSoundInputDriver()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetSoundInputDriver( c: SGChannel ): SIGNEDLONG; external name '_SGGetSoundInputDriver';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSoundInputDriverChanged()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSoundInputDriverChanged( c: SGChannel ): ComponentResult; external name '_SGSoundInputDriverChanged';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetSoundRecordChunkSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetSoundRecordChunkSize( c: SGChannel; seconds: SIGNEDLONG ): ComponentResult; external name '_SGSetSoundRecordChunkSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetSoundRecordChunkSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetSoundRecordChunkSize( c: SGChannel ): SIGNEDLONG; external name '_SGGetSoundRecordChunkSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetSoundInputRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetSoundInputRate( c: SGChannel; rate: Fixed ): ComponentResult; external name '_SGSetSoundInputRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetSoundInputRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetSoundInputRate( c: SGChannel ): Fixed; external name '_SGGetSoundInputRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetSoundInputParameters()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetSoundInputParameters( c: SGChannel; sampleSize: SInt16; numChannels: SInt16; compressionType: OSType ): ComponentResult; external name '_SGSetSoundInputParameters';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetSoundInputParameters()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetSoundInputParameters( c: SGChannel; var sampleSize: SInt16; var numChannels: SInt16; var compressionType: OSType ): ComponentResult; external name '_SGGetSoundInputParameters';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetAdditionalSoundRates()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetAdditionalSoundRates( c: SGChannel; rates: Handle ): ComponentResult; external name '_SGSetAdditionalSoundRates';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetAdditionalSoundRates()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetAdditionalSoundRates( c: SGChannel; var rates: Handle ): ComponentResult; external name '_SGGetAdditionalSoundRates';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    Text stuff
}
{
 *  SGSetFontName()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetFontName( c: SGChannel; pstr: StringPtr ): ComponentResult; external name '_SGSetFontName';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetFontSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetFontSize( c: SGChannel; fontSize: SInt16 ): ComponentResult; external name '_SGSetFontSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetTextForeColor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetTextForeColor( c: SGChannel; var theColor: RGBColor ): ComponentResult; external name '_SGSetTextForeColor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetTextBackColor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetTextBackColor( c: SGChannel; var theColor: RGBColor ): ComponentResult; external name '_SGSetTextBackColor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetJustification()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetJustification( c: SGChannel; just: SInt16 ): ComponentResult; external name '_SGSetJustification';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGGetTextReturnToSpaceValue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetTextReturnToSpaceValue( c: SGChannel; var rettospace: SInt16 ): ComponentResult; external name '_SGGetTextReturnToSpaceValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetTextReturnToSpaceValue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetTextReturnToSpaceValue( c: SGChannel; rettospace: SInt16 ): ComponentResult; external name '_SGSetTextReturnToSpaceValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    Music stuff
}
{
 *  SGGetInstrument()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGGetInstrument( c: SGChannel; var td: ToneDescription ): ComponentResult; external name '_SGGetInstrument';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SGSetInstrument()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SGSetInstrument( c: SGChannel; var td: ToneDescription ): ComponentResult; external name '_SGSetInstrument';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	sgChannelAtom = FourCharCode('chan');
	sgChannelSettingsAtom = FourCharCode('ctom');
	sgChannelDescription = FourCharCode('cdsc');
	sgChannelSettings = FourCharCode('cset');

const
	sgDeviceNameType = FourCharCode('name');
	sgDeviceDisplayNameType = FourCharCode('dnam');
	sgDeviceUIDType = FourCharCode('duid');
	sgInputUIDType = FourCharCode('iuid');
	sgUsageType = FourCharCode('use ');
	sgPlayFlagsType = FourCharCode('plyf');
	sgClipType = FourCharCode('clip');
	sgMatrixType = FourCharCode('mtrx');
	sgVolumeType = FourCharCode('volu');

const
	sgPanelSettingsAtom = FourCharCode('ptom');
	sgPanelDescription = FourCharCode('pdsc');
	sgPanelSettings = FourCharCode('pset');

const
	sgcSoundCompressionType = FourCharCode('scmp');
	sgcSoundCodecSettingsType = FourCharCode('cdec');
	sgcSoundSampleRateType = FourCharCode('srat');
	sgcSoundChannelCountType = FourCharCode('schn');
	sgcSoundSampleSizeType = FourCharCode('ssiz');
	sgcSoundInputType = FourCharCode('sinp');
	sgcSoundGainType = FourCharCode('gain');

const
	sgcVideoHueType = FourCharCode('hue ');
	sgcVideoSaturationType = FourCharCode('satr');
	sgcVideoContrastType = FourCharCode('trst');
	sgcVideoSharpnessType = FourCharCode('shrp');
	sgcVideoBrigtnessType = FourCharCode('brit');
	sgcVideoBlackLevelType = FourCharCode('blkl');
	sgcVideoWhiteLevelType = FourCharCode('whtl');
	sgcVideoInputType = FourCharCode('vinp');
	sgcVideoFormatType = FourCharCode('vstd');
	sgcVideoFilterType = FourCharCode('vflt');
	sgcVideoRectType = FourCharCode('vrct');
	sgcVideoDigitizerType = FourCharCode('vdig');


type
	QTVideoOutputComponent = ComponentInstance;
{ Component type and subtype enumerations}
const
	QTVideoOutputComponentType = FourCharCode('vout');
	QTVideoOutputComponentBaseSubType = FourCharCode('base');


{ QTVideoOutput Component flags}

const
	kQTVideoOutputDontDisplayToUser = 1 shl 0;

{ Display mode atom types}

const
	kQTVODisplayModeItem = FourCharCode('qdmi');
	kQTVODimensions = FourCharCode('dimn'); { atom contains two longs - pixel count - width, height}
	kQTVOResolution = FourCharCode('resl'); { atom contains two Fixed - hRes, vRes in dpi}
	kQTVORefreshRate = FourCharCode('refr'); { atom contains one Fixed - refresh rate in Hz}
	kQTVOPixelType = FourCharCode('pixl'); { atom contains one OSType - pixel format of mode}
	kQTVOName = FourCharCode('name'); { atom contains string (no length byte) - name of mode for display to user}
	kQTVODecompressors = FourCharCode('deco'); { atom contains other atoms indicating supported decompressors}
                                        { kQTVODecompressors sub-atoms}
	kQTVODecompressorType = FourCharCode('dety'); { atom contains one OSType - decompressor type code}
	kQTVODecompressorContinuous = FourCharCode('cont'); { atom contains one Boolean - true if this type is displayed continuously}
	kQTVODecompressorComponent = FourCharCode('cmpt'); { atom contains one Component - component id of decompressor}

{* These are QTVideoOutput procedures *}
{
 *  QTVideoOutputGetDisplayModeList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputGetDisplayModeList( vo: QTVideoOutputComponent; var outputs: QTAtomContainer ): ComponentResult; external name '_QTVideoOutputGetDisplayModeList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputGetCurrentClientName()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputGetCurrentClientName( vo: QTVideoOutputComponent; var str: Str255 ): ComponentResult; external name '_QTVideoOutputGetCurrentClientName';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputSetClientName()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputSetClientName( vo: QTVideoOutputComponent; const (*var*) str: Str255 ): ComponentResult; external name '_QTVideoOutputSetClientName';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputGetClientName()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputGetClientName( vo: QTVideoOutputComponent; var str: Str255 ): ComponentResult; external name '_QTVideoOutputGetClientName';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputBegin()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputBegin( vo: QTVideoOutputComponent ): ComponentResult; external name '_QTVideoOutputBegin';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputEnd()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputEnd( vo: QTVideoOutputComponent ): ComponentResult; external name '_QTVideoOutputEnd';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputSetDisplayMode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputSetDisplayMode( vo: QTVideoOutputComponent; displayModeID: SIGNEDLONG ): ComponentResult; external name '_QTVideoOutputSetDisplayMode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputGetDisplayMode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputGetDisplayMode( vo: QTVideoOutputComponent; var displayModeID: SIGNEDLONG ): ComponentResult; external name '_QTVideoOutputGetDisplayMode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputCustomConfigureDisplay()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputCustomConfigureDisplay( vo: QTVideoOutputComponent; filter: ModalFilterUPP ): ComponentResult; external name '_QTVideoOutputCustomConfigureDisplay';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputSaveState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputSaveState( vo: QTVideoOutputComponent; var state: QTAtomContainer ): ComponentResult; external name '_QTVideoOutputSaveState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputRestoreState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputRestoreState( vo: QTVideoOutputComponent; state: QTAtomContainer ): ComponentResult; external name '_QTVideoOutputRestoreState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputGetGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputGetGWorld( vo: QTVideoOutputComponent; var gw: GWorldPtr ): ComponentResult; external name '_QTVideoOutputGetGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputGetGWorldParameters()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputGetGWorldParameters( vo: QTVideoOutputComponent; var baseAddr: Ptr; var rowBytes: SIGNEDLONG; var colorTable: CTabHandle ): ComponentResult; external name '_QTVideoOutputGetGWorldParameters';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputGetIndSoundOutput()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputGetIndSoundOutput( vo: QTVideoOutputComponent; index: SIGNEDLONG; var outputComponent: Component ): ComponentResult; external name '_QTVideoOutputGetIndSoundOutput';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputGetClock()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputGetClock( vo: QTVideoOutputComponent; var clock: ComponentInstance ): ComponentResult; external name '_QTVideoOutputGetClock';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputSetEchoPort()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTVideoOutputSetEchoPort( vo: QTVideoOutputComponent; echoPort: CGrafPtr ): ComponentResult; external name '_QTVideoOutputSetEchoPort';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputGetIndImageDecompressor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function QTVideoOutputGetIndImageDecompressor( vo: QTVideoOutputComponent; index: SIGNEDLONG; var codec: Component ): ComponentResult; external name '_QTVideoOutputGetIndImageDecompressor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTVideoOutputBaseSetEchoPort()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTVideoOutputBaseSetEchoPort( vo: QTVideoOutputComponent; echoPort: CGrafPtr ): ComponentResult; external name '_QTVideoOutputBaseSetEchoPort';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTVideoOutputCopyIndAudioOutputDeviceUID()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTVideoOutputCopyIndAudioOutputDeviceUID( vo: QTVideoOutputComponent; index: SIGNEDLONG; var audioDeviceUID: CFStringRef ): ComponentResult; external name '_QTVideoOutputCopyIndAudioOutputDeviceUID';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{ UPP call backs }
{
 *  NewDataHCompletionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewDataHCompletionUPP( userRoutine: DataHCompletionProcPtr ): DataHCompletionUPP; external name '_NewDataHCompletionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewVdigIntUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewVdigIntUPP( userRoutine: VdigIntProcPtr ): VdigIntUPP; external name '_NewVdigIntUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewStartDocumentHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewStartDocumentHandlerUPP( userRoutine: StartDocumentHandler ): StartDocumentHandlerUPP; external name '_NewStartDocumentHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewEndDocumentHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewEndDocumentHandlerUPP( userRoutine: EndDocumentHandler ): EndDocumentHandlerUPP; external name '_NewEndDocumentHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewStartElementHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewStartElementHandlerUPP( userRoutine: StartElementHandler ): StartElementHandlerUPP; external name '_NewStartElementHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewEndElementHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewEndElementHandlerUPP( userRoutine: EndElementHandler ): EndElementHandlerUPP; external name '_NewEndElementHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewCharDataHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewCharDataHandlerUPP( userRoutine: CharDataHandler ): CharDataHandlerUPP; external name '_NewCharDataHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewPreprocessInstructionHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewPreprocessInstructionHandlerUPP( userRoutine: PreprocessInstructionHandler ): PreprocessInstructionHandlerUPP; external name '_NewPreprocessInstructionHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewCommentHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewCommentHandlerUPP( userRoutine: CommentHandler ): CommentHandlerUPP; external name '_NewCommentHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewCDataHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewCDataHandlerUPP( userRoutine: CDataHandler ): CDataHandlerUPP; external name '_NewCDataHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)

{
 *  NewSGDataUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSGDataUPP( userRoutine: SGDataProcPtr ): SGDataUPP; external name '_NewSGDataUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewSGModalFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSGModalFilterUPP( userRoutine: SGModalFilterProcPtr ): SGModalFilterUPP; external name '_NewSGModalFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewSGGrabBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSGGrabBottleUPP( userRoutine: SGGrabBottleProcPtr ): SGGrabBottleUPP; external name '_NewSGGrabBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewSGGrabCompleteBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSGGrabCompleteBottleUPP( userRoutine: SGGrabCompleteBottleProcPtr ): SGGrabCompleteBottleUPP; external name '_NewSGGrabCompleteBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewSGDisplayBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSGDisplayBottleUPP( userRoutine: SGDisplayBottleProcPtr ): SGDisplayBottleUPP; external name '_NewSGDisplayBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewSGCompressBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSGCompressBottleUPP( userRoutine: SGCompressBottleProcPtr ): SGCompressBottleUPP; external name '_NewSGCompressBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewSGCompressCompleteBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSGCompressCompleteBottleUPP( userRoutine: SGCompressCompleteBottleProcPtr ): SGCompressCompleteBottleUPP; external name '_NewSGCompressCompleteBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewSGAddFrameBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSGAddFrameBottleUPP( userRoutine: SGAddFrameBottleProcPtr ): SGAddFrameBottleUPP; external name '_NewSGAddFrameBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewSGTransferFrameBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSGTransferFrameBottleUPP( userRoutine: SGTransferFrameBottleProcPtr ): SGTransferFrameBottleUPP; external name '_NewSGTransferFrameBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewSGGrabCompressCompleteBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSGGrabCompressCompleteBottleUPP( userRoutine: SGGrabCompressCompleteBottleProcPtr ): SGGrabCompressCompleteBottleUPP; external name '_NewSGGrabCompressCompleteBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewSGDisplayCompressBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSGDisplayCompressBottleUPP( userRoutine: SGDisplayCompressBottleProcPtr ): SGDisplayCompressBottleUPP; external name '_NewSGDisplayCompressBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeDataHCompletionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeDataHCompletionUPP( userUPP: DataHCompletionUPP ); external name '_DisposeDataHCompletionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeVdigIntUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeVdigIntUPP( userUPP: VdigIntUPP ); external name '_DisposeVdigIntUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeStartDocumentHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeStartDocumentHandlerUPP( userUPP: StartDocumentHandlerUPP ); external name '_DisposeStartDocumentHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeEndDocumentHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeEndDocumentHandlerUPP( userUPP: EndDocumentHandlerUPP ); external name '_DisposeEndDocumentHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeStartElementHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeStartElementHandlerUPP( userUPP: StartElementHandlerUPP ); external name '_DisposeStartElementHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeEndElementHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeEndElementHandlerUPP( userUPP: EndElementHandlerUPP ); external name '_DisposeEndElementHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeCharDataHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeCharDataHandlerUPP( userUPP: CharDataHandlerUPP ); external name '_DisposeCharDataHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposePreprocessInstructionHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposePreprocessInstructionHandlerUPP( userUPP: PreprocessInstructionHandlerUPP ); external name '_DisposePreprocessInstructionHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeCommentHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeCommentHandlerUPP( userUPP: CommentHandlerUPP ); external name '_DisposeCommentHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeCDataHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeCDataHandlerUPP( userUPP: CDataHandlerUPP ); external name '_DisposeCDataHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)

{
 *  DisposeSGDataUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSGDataUPP( userUPP: SGDataUPP ); external name '_DisposeSGDataUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeSGModalFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSGModalFilterUPP( userUPP: SGModalFilterUPP ); external name '_DisposeSGModalFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeSGGrabBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSGGrabBottleUPP( userUPP: SGGrabBottleUPP ); external name '_DisposeSGGrabBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeSGGrabCompleteBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSGGrabCompleteBottleUPP( userUPP: SGGrabCompleteBottleUPP ); external name '_DisposeSGGrabCompleteBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeSGDisplayBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSGDisplayBottleUPP( userUPP: SGDisplayBottleUPP ); external name '_DisposeSGDisplayBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeSGCompressBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSGCompressBottleUPP( userUPP: SGCompressBottleUPP ); external name '_DisposeSGCompressBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeSGCompressCompleteBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSGCompressCompleteBottleUPP( userUPP: SGCompressCompleteBottleUPP ); external name '_DisposeSGCompressCompleteBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeSGAddFrameBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSGAddFrameBottleUPP( userUPP: SGAddFrameBottleUPP ); external name '_DisposeSGAddFrameBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeSGTransferFrameBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSGTransferFrameBottleUPP( userUPP: SGTransferFrameBottleUPP ); external name '_DisposeSGTransferFrameBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeSGGrabCompressCompleteBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSGGrabCompressCompleteBottleUPP( userUPP: SGGrabCompressCompleteBottleUPP ); external name '_DisposeSGGrabCompressCompleteBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeSGDisplayCompressBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSGDisplayCompressBottleUPP( userUPP: SGDisplayCompressBottleUPP ); external name '_DisposeSGDisplayCompressBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeDataHCompletionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeDataHCompletionUPP( request: Ptr; refcon: SIGNEDLONG; err: OSErr; userUPP: DataHCompletionUPP ); external name '_InvokeDataHCompletionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeVdigIntUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeVdigIntUPP( flags: SIGNEDLONG; refcon: SIGNEDLONG; userUPP: VdigIntUPP ); external name '_InvokeVdigIntUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeStartDocumentHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeStartDocumentHandlerUPP( refcon: SIGNEDLONG; userUPP: StartDocumentHandlerUPP ): ComponentResult; external name '_InvokeStartDocumentHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeEndDocumentHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeEndDocumentHandlerUPP( refcon: SIGNEDLONG; userUPP: EndDocumentHandlerUPP ): ComponentResult; external name '_InvokeEndDocumentHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeStartElementHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeStartElementHandlerUPP( name: ConstCStringPtr; var atts: ConstCStringPtr; refcon: SIGNEDLONG; userUPP: StartElementHandlerUPP ): ComponentResult; external name '_InvokeStartElementHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeEndElementHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeEndElementHandlerUPP( name: ConstCStringPtr; refcon: SIGNEDLONG; userUPP: EndElementHandlerUPP ): ComponentResult; external name '_InvokeEndElementHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeCharDataHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeCharDataHandlerUPP( charData: ConstCStringPtr; refcon: SIGNEDLONG; userUPP: CharDataHandlerUPP ): ComponentResult; external name '_InvokeCharDataHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokePreprocessInstructionHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokePreprocessInstructionHandlerUPP( name: ConstCStringPtr; atts: ConstCStringPtrPtr; refcon: SIGNEDLONG; userUPP: PreprocessInstructionHandlerUPP ): ComponentResult; external name '_InvokePreprocessInstructionHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeCommentHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeCommentHandlerUPP( comment: ConstCStringPtr; refcon: SIGNEDLONG; userUPP: CommentHandlerUPP ): ComponentResult; external name '_InvokeCommentHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeCDataHandlerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeCDataHandlerUPP( cdata: ConstCStringPtr; refcon: SIGNEDLONG; userUPP: CDataHandlerUPP ): ComponentResult; external name '_InvokeCDataHandlerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)

{
 *  InvokeSGDataUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeSGDataUPP( c: SGChannel; p: Ptr; len: SIGNEDLONG; var offset: SIGNEDLONG; chRefCon: SIGNEDLONG; time: TimeValue; writeType: SInt16; refCon: SIGNEDLONG; userUPP: SGDataUPP ): OSErr; external name '_InvokeSGDataUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeSGModalFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeSGModalFilterUPP( theDialog: DialogRef; const (*var*) theEvent: EventRecord; var itemHit: SInt16; refCon: SIGNEDLONG; userUPP: SGModalFilterUPP ): Boolean; external name '_InvokeSGModalFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeSGGrabBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeSGGrabBottleUPP( c: SGChannel; bufferNum: SInt16; refCon: SIGNEDLONG; userUPP: SGGrabBottleUPP ): ComponentResult; external name '_InvokeSGGrabBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeSGGrabCompleteBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeSGGrabCompleteBottleUPP( c: SGChannel; bufferNum: SInt16; var done: Boolean; refCon: SIGNEDLONG; userUPP: SGGrabCompleteBottleUPP ): ComponentResult; external name '_InvokeSGGrabCompleteBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeSGDisplayBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeSGDisplayBottleUPP( c: SGChannel; bufferNum: SInt16; var mp: MatrixRecord; clipRgn: RgnHandle; refCon: SIGNEDLONG; userUPP: SGDisplayBottleUPP ): ComponentResult; external name '_InvokeSGDisplayBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeSGCompressBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeSGCompressBottleUPP( c: SGChannel; bufferNum: SInt16; refCon: SIGNEDLONG; userUPP: SGCompressBottleUPP ): ComponentResult; external name '_InvokeSGCompressBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeSGCompressCompleteBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeSGCompressCompleteBottleUPP( c: SGChannel; bufferNum: SInt16; var done: Boolean; var ci: SGCompressInfo; refCon: SIGNEDLONG; userUPP: SGCompressCompleteBottleUPP ): ComponentResult; external name '_InvokeSGCompressCompleteBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeSGAddFrameBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeSGAddFrameBottleUPP( c: SGChannel; bufferNum: SInt16; atTime: TimeValue; scale: TimeScale; const (*var*) ci: SGCompressInfo; refCon: SIGNEDLONG; userUPP: SGAddFrameBottleUPP ): ComponentResult; external name '_InvokeSGAddFrameBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeSGTransferFrameBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeSGTransferFrameBottleUPP( c: SGChannel; bufferNum: SInt16; var mp: MatrixRecord; clipRgn: RgnHandle; refCon: SIGNEDLONG; userUPP: SGTransferFrameBottleUPP ): ComponentResult; external name '_InvokeSGTransferFrameBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeSGGrabCompressCompleteBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeSGGrabCompressCompleteBottleUPP( c: SGChannel; var queuedFrameCount: UInt8; var ci: SGCompressInfo; var t: TimeRecord; refCon: SIGNEDLONG; userUPP: SGGrabCompressCompleteBottleUPP ): ComponentResult; external name '_InvokeSGGrabCompressCompleteBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeSGDisplayCompressBottleUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeSGDisplayCompressBottleUPP( c: SGChannel; dataPtr: Ptr; desc: ImageDescriptionHandle; var mp: MatrixRecord; clipRgn: RgnHandle; refCon: SIGNEDLONG; userUPP: SGDisplayCompressBottleUPP ): ComponentResult; external name '_InvokeSGDisplayCompressBottleUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{ selectors for component calls }
const
	kClockGetTimeSelect = $0001;
	kClockNewCallBackSelect = $0002;
	kClockDisposeCallBackSelect = $0003;
	kClockCallMeWhenSelect = $0004;
	kClockCancelCallBackSelect = $0005;
	kClockRateChangedSelect = $0006;
	kClockTimeChangedSelect = $0007;
	kClockSetTimeBaseSelect = $0008;
	kClockStartStopChangedSelect = $0009;
	kClockGetRateSelect = $000A;
	kClockGetTimesForRateChangeSelect = $000B;
	kClockGetRateChangeConstraintsSelect = $000C;
	kSCAudioInvokeLegacyCodecOptionsDialogSelect = $0081;
	kSCAudioFillBufferSelect = $0082;
	kSCAudioResetSelect = $0083;
	kSCGetCompressionExtendedSelect = $0001;
	kSCPositionRectSelect = $0002;
	kSCPositionDialogSelect = $0003;
	kSCSetTestImagePictHandleSelect = $0004;
	kSCSetTestImagePictFileSelect = $0005;
	kSCSetTestImagePixMapSelect = $0006;
	kSCGetBestDeviceRectSelect = $0007;
	kSCRequestImageSettingsSelect = $000A;
	kSCCompressImageSelect = $000B;
	kSCCompressPictureSelect = $000C;
	kSCCompressPictureFileSelect = $000D;
	kSCRequestSequenceSettingsSelect = $000E;
	kSCCompressSequenceBeginSelect = $000F;
	kSCCompressSequenceFrameSelect = $0010;
	kSCCompressSequenceEndSelect = $0011;
	kSCDefaultPictHandleSettingsSelect = $0012;
	kSCDefaultPictFileSettingsSelect = $0013;
	kSCDefaultPixMapSettingsSelect = $0014;
	kSCGetInfoSelect = $0015;
	kSCSetInfoSelect = $0016;
	kSCNewGWorldSelect = $0017;
	kSCSetCompressFlagsSelect = $0018;
	kSCGetCompressFlagsSelect = $0019;
	kSCGetSettingsAsTextSelect = $001A;
	kSCGetSettingsAsAtomContainerSelect = $001B;
	kSCSetSettingsFromAtomContainerSelect = $001C;
	kSCCompressSequenceFrameAsyncSelect = $001D;
	kSCAsyncIdleSelect = $001E;
	kSCCopyCompressionSessionOptionsSelect = $001F;
	kTweenerInitializeSelect = $0001;
	kTweenerDoTweenSelect = $0002;
	kTweenerResetSelect = $0003;
	kTCGetCurrentTimeCodeSelect = $0101;
	kTCGetTimeCodeAtTimeSelect = $0102;
	kTCTimeCodeToStringSelect = $0103;
	kTCTimeCodeToFrameNumberSelect = $0104;
	kTCFrameNumberToTimeCodeSelect = $0105;
	kTCGetSourceRefSelect = $0106;
	kTCSetSourceRefSelect = $0107;
	kTCSetTimeCodeFlagsSelect = $0108;
	kTCGetTimeCodeFlagsSelect = $0109;
	kTCSetDisplayOptionsSelect = $010A;
	kTCGetDisplayOptionsSelect = $010B;
	kTCGetCurrentFrameAndTimeCodeDefSelect = $010C;
	kTCGetFrameAndTimeCodeDefAtTimeSelect = $010D;
	kTCTimeCodeTimeToStringSelect = $010E;
	kTCTimeCodeCounterToStringSelect = $010F;
	kTCTimeCodeTimeToFrameNumberSelect = $0110;
	kTCTimeCodeCounterToFrameNumberSelect = $0111;
	kTCFrameNumberToTimeCodeTimeSelect = $0112;
	kTCFrameNumberToTimeCodeCounterSelect = $0113;
	kMovieImportHandleSelect = $0001;
	kMovieImportFileSelect = $0002;
	kMovieImportSetSampleDurationSelect = $0003;
	kMovieImportSetSampleDescriptionSelect = $0004;
	kMovieImportSetMediaFileSelect = $0005;
	kMovieImportSetDimensionsSelect = $0006;
	kMovieImportSetChunkSizeSelect = $0007;
	kMovieImportSetProgressProcSelect = $0008;
	kMovieImportSetAuxiliaryDataSelect = $0009;
	kMovieImportSetFromScrapSelect = $000A;
	kMovieImportDoUserDialogSelect = $000B;
	kMovieImportSetDurationSelect = $000C;
	kMovieImportGetAuxiliaryDataTypeSelect = $000D;
	kMovieImportValidateSelect = $000E;
	kMovieImportGetFileTypeSelect = $000F;
	kMovieImportDataRefSelect = $0010;
	kMovieImportGetSampleDescriptionSelect = $0011;
	kMovieImportGetMIMETypeListSelect = $0012;
	kMovieImportSetOffsetAndLimitSelect = $0013;
	kMovieImportGetSettingsAsAtomContainerSelect = $0014;
	kMovieImportSetSettingsFromAtomContainerSelect = $0015;
	kMovieImportSetOffsetAndLimit64Select = $0016;
	kMovieImportIdleSelect = $0017;
	kMovieImportValidateDataRefSelect = $0018;
	kMovieImportGetLoadStateSelect = $0019;
	kMovieImportGetMaxLoadedTimeSelect = $001A;
	kMovieImportEstimateCompletionTimeSelect = $001B;
	kMovieImportSetDontBlockSelect = $001C;
	kMovieImportGetDontBlockSelect = $001D;
	kMovieImportSetIdleManagerSelect = $001E;
	kMovieImportSetNewMovieFlagsSelect = $001F;
	kMovieImportGetDestinationMediaTypeSelect = $0020;
	kMovieImportSetMediaDataRefSelect = $0021;
	kMovieImportDoUserDialogDataRefSelect = $0022;
	kMovieExportToHandleSelect = $0080;
	kMovieExportToFileSelect = $0081;
	kMovieExportGetAuxiliaryDataSelect = $0083;
	kMovieExportSetProgressProcSelect = $0084;
	kMovieExportSetSampleDescriptionSelect = $0085;
	kMovieExportDoUserDialogSelect = $0086;
	kMovieExportGetCreatorTypeSelect = $0087;
	kMovieExportToDataRefSelect = $0088;
	kMovieExportFromProceduresToDataRefSelect = $0089;
	kMovieExportAddDataSourceSelect = $008A;
	kMovieExportValidateSelect = $008B;
	kMovieExportGetSettingsAsAtomContainerSelect = $008C;
	kMovieExportSetSettingsFromAtomContainerSelect = $008D;
	kMovieExportGetFileNameExtensionSelect = $008E;
	kMovieExportGetShortFileTypeStringSelect = $008F;
	kMovieExportGetSourceMediaTypeSelect = $0090;
	kMovieExportSetGetMoviePropertyProcSelect = $0091;
	kTextExportGetDisplayDataSelect = $0100;
	kTextExportGetTimeFractionSelect = $0101;
	kTextExportSetTimeFractionSelect = $0102;
	kTextExportGetSettingsSelect = $0103;
	kTextExportSetSettingsSelect = $0104;
	kMIDIImportGetSettingsSelect = $0100;
	kMIDIImportSetSettingsSelect = $0101;
	kMovieExportNewGetDataAndPropertiesProcsSelect = $0100;
	kMovieExportDisposeGetDataAndPropertiesProcsSelect = $0101;
	kGraphicsImageImportSetSequenceEnabledSelect = $0100;
	kGraphicsImageImportGetSequenceEnabledSelect = $0101;
	kPreviewShowDataSelect = $0001;
	kPreviewMakePreviewSelect = $0002;
	kPreviewMakePreviewReferenceSelect = $0003;
	kPreviewEventSelect = $0004;
	kDataCodecDecompressSelect = $0001;
	kDataCodecGetCompressBufferSizeSelect = $0002;
	kDataCodecCompressSelect = $0003;
	kDataCodecBeginInterruptSafeSelect = $0004;
	kDataCodecEndInterruptSafeSelect = $0005;
	kDataCodecDecompressPartialSelect = $0006;
	kDataCodecCompressPartialSelect = $0007;
	kDataHGetDataSelect = $0002;
	kDataHPutDataSelect = $0003;
	kDataHFlushDataSelect = $0004;
	kDataHOpenForWriteSelect = $0005;
	kDataHCloseForWriteSelect = $0006;
	kDataHOpenForReadSelect = $0008;
	kDataHCloseForReadSelect = $0009;
	kDataHSetDataRefSelect = $000A;
	kDataHGetDataRefSelect = $000B;
	kDataHCompareDataRefSelect = $000C;
	kDataHTaskSelect = $000D;
	kDataHScheduleDataSelect = $000E;
	kDataHFinishDataSelect = $000F;
	kDataHFlushCacheSelect = $0010;
	kDataHResolveDataRefSelect = $0011;
	kDataHGetFileSizeSelect = $0012;
	kDataHCanUseDataRefSelect = $0013;
	kDataHGetVolumeListSelect = $0014;
	kDataHWriteSelect = $0015;
	kDataHPreextendSelect = $0016;
	kDataHSetFileSizeSelect = $0017;
	kDataHGetFreeSpaceSelect = $0018;
	kDataHCreateFileSelect = $0019;
	kDataHGetPreferredBlockSizeSelect = $001A;
	kDataHGetDeviceIndexSelect = $001B;
	kDataHIsStreamingDataHandlerSelect = $001C;
	kDataHGetDataInBufferSelect = $001D;
	kDataHGetScheduleAheadTimeSelect = $001E;
	kDataHSetCacheSizeLimitSelect = $001F;
	kDataHGetCacheSizeLimitSelect = $0020;
	kDataHGetMovieSelect = $0021;
	kDataHAddMovieSelect = $0022;
	kDataHUpdateMovieSelect = $0023;
	kDataHDoesBufferSelect = $0024;
	kDataHGetFileNameSelect = $0025;
	kDataHGetAvailableFileSizeSelect = $0026;
	kDataHGetMacOSFileTypeSelect = $0027;
	kDataHGetMIMETypeSelect = $0028;
	kDataHSetDataRefWithAnchorSelect = $0029;
	kDataHGetDataRefWithAnchorSelect = $002A;
	kDataHSetMacOSFileTypeSelect = $002B;
	kDataHSetTimeBaseSelect = $002C;
	kDataHGetInfoFlagsSelect = $002D;
	kDataHScheduleData64Select = $002E;
	kDataHWrite64Select = $002F;
	kDataHGetFileSize64Select = $0030;
	kDataHPreextend64Select = $0031;
	kDataHSetFileSize64Select = $0032;
	kDataHGetFreeSpace64Select = $0033;
	kDataHAppend64Select = $0034;
	kDataHReadAsyncSelect = $0035;
	kDataHPollReadSelect = $0036;
	kDataHGetDataAvailabilitySelect = $0037;
	kDataHGetFileSizeAsyncSelect = $003A;
	kDataHGetDataRefAsTypeSelect = $003B;
	kDataHSetDataRefExtensionSelect = $003C;
	kDataHGetDataRefExtensionSelect = $003D;
	kDataHGetMovieWithFlagsSelect = $003E;
	kDataHGetFileTypeOrderingSelect = $0040;
	kDataHCreateFileWithFlagsSelect = $0041;
	kDataHGetMIMETypeAsyncSelect = $0042;
	kDataHGetInfoSelect = $0043;
	kDataHSetIdleManagerSelect = $0044;
	kDataHDeleteFileSelect = $0045;
	kDataHSetMovieUsageFlagsSelect = $0046;
	kDataHUseTemporaryDataRefSelect = $0047;
	kDataHGetTemporaryDataRefCapabilitiesSelect = $0048;
	kDataHRenameFileSelect = $0049;
	kDataHGetAvailableFileSize64Select = $004E;
	kDataHGetDataAvailability64Select = $004F;
	kDataHPlaybackHintsSelect = $0103;
	kDataHPlaybackHints64Select = $010E;
	kDataHGetDataRateSelect = $0110;
	kDataHSetTimeHintsSelect = $0111;
	kVDGetMaxSrcRectSelect = $0001;
	kVDGetActiveSrcRectSelect = $0002;
	kVDSetDigitizerRectSelect = $0003;
	kVDGetDigitizerRectSelect = $0004;
	kVDGetVBlankRectSelect = $0005;
	kVDGetMaskPixMapSelect = $0006;
	kVDGetPlayThruDestinationSelect = $0008;
	kVDUseThisCLUTSelect = $0009;
	kVDSetInputGammaValueSelect = $000A;
	kVDGetInputGammaValueSelect = $000B;
	kVDSetBrightnessSelect = $000C;
	kVDGetBrightnessSelect = $000D;
	kVDSetContrastSelect = $000E;
	kVDSetHueSelect = $000F;
	kVDSetSharpnessSelect = $0010;
	kVDSetSaturationSelect = $0011;
	kVDGetContrastSelect = $0012;
	kVDGetHueSelect = $0013;
	kVDGetSharpnessSelect = $0014;
	kVDGetSaturationSelect = $0015;
	kVDGrabOneFrameSelect = $0016;
	kVDGetMaxAuxBufferSelect = $0017;
	kVDGetDigitizerInfoSelect = $0019;
	kVDGetCurrentFlagsSelect = $001A;
	kVDSetKeyColorSelect = $001B;
	kVDGetKeyColorSelect = $001C;
	kVDAddKeyColorSelect = $001D;
	kVDGetNextKeyColorSelect = $001E;
	kVDSetKeyColorRangeSelect = $001F;
	kVDGetKeyColorRangeSelect = $0020;
	kVDSetDigitizerUserInterruptSelect = $0021;
	kVDSetInputColorSpaceModeSelect = $0022;
	kVDGetInputColorSpaceModeSelect = $0023;
	kVDSetClipStateSelect = $0024;
	kVDGetClipStateSelect = $0025;
	kVDSetClipRgnSelect = $0026;
	kVDClearClipRgnSelect = $0027;
	kVDGetCLUTInUseSelect = $0028;
	kVDSetPLLFilterTypeSelect = $0029;
	kVDGetPLLFilterTypeSelect = $002A;
	kVDGetMaskandValueSelect = $002B;
	kVDSetMasterBlendLevelSelect = $002C;
	kVDSetPlayThruDestinationSelect = $002D;
	kVDSetPlayThruOnOffSelect = $002E;
	kVDSetFieldPreferenceSelect = $002F;
	kVDGetFieldPreferenceSelect = $0030;
	kVDPreflightDestinationSelect = $0032;
	kVDPreflightGlobalRectSelect = $0033;
	kVDSetPlayThruGlobalRectSelect = $0034;
	kVDSetInputGammaRecordSelect = $0035;
	kVDGetInputGammaRecordSelect = $0036;
	kVDSetBlackLevelValueSelect = $0037;
	kVDGetBlackLevelValueSelect = $0038;
	kVDSetWhiteLevelValueSelect = $0039;
	kVDGetWhiteLevelValueSelect = $003A;
	kVDGetVideoDefaultsSelect = $003B;
	kVDGetNumberOfInputsSelect = $003C;
	kVDGetInputFormatSelect = $003D;
	kVDSetInputSelect = $003E;
	kVDGetInputSelect = $003F;
	kVDSetInputStandardSelect = $0040;
	kVDSetupBuffersSelect = $0041;
	kVDGrabOneFrameAsyncSelect = $0042;
	kVDDoneSelect = $0043;
	kVDSetCompressionSelect = $0044;
	kVDCompressOneFrameAsyncSelect = $0045;
	kVDCompressDoneSelect = $0046;
	kVDReleaseCompressBufferSelect = $0047;
	kVDGetImageDescriptionSelect = $0048;
	kVDResetCompressSequenceSelect = $0049;
	kVDSetCompressionOnOffSelect = $004A;
	kVDGetCompressionTypesSelect = $004B;
	kVDSetTimeBaseSelect = $004C;
	kVDSetFrameRateSelect = $004D;
	kVDGetDataRateSelect = $004E;
	kVDGetSoundInputDriverSelect = $004F;
	kVDGetDMADepthsSelect = $0050;
	kVDGetPreferredTimeScaleSelect = $0051;
	kVDReleaseAsyncBuffersSelect = $0052;
	kVDSetDataRateSelect = $0054;
	kVDGetTimeCodeSelect = $0055;
	kVDUseSafeBuffersSelect = $0056;
	kVDGetSoundInputSourceSelect = $0057;
	kVDGetCompressionTimeSelect = $0058;
	kVDSetPreferredPacketSizeSelect = $0059;
	kVDSetPreferredImageDimensionsSelect = $005A;
	kVDGetPreferredImageDimensionsSelect = $005B;
	kVDGetInputNameSelect = $005C;
	kVDSetDestinationPortSelect = $005D;
	kVDGetDeviceNameAndFlagsSelect = $005E;
	kVDCaptureStateChangingSelect = $005F;
	kVDGetUniqueIDsSelect = $0060;
	kVDSelectUniqueIDsSelect = $0061;
	kVDCopyPreferredAudioDeviceSelect = $0063;
	kVDIIDCGetFeaturesSelect = $0200;
	kVDIIDCSetFeaturesSelect = $0201;
	kVDIIDCGetDefaultFeaturesSelect = $0202;
	kVDIIDCGetCSRDataSelect = $0203;
	kVDIIDCSetCSRDataSelect = $0204;
	kVDIIDCGetFeaturesForSpecifierSelect = $0205;
	kXMLParseDataRefSelect = $0001;
	kXMLParseFileSelect = $0002;
	kXMLParseDisposeXMLDocSelect = $0003;
	kXMLParseGetDetailedParseErrorSelect = $0004;
	kXMLParseAddElementSelect = $0005;
	kXMLParseAddAttributeSelect = $0006;
	kXMLParseAddMultipleAttributesSelect = $0007;
	kXMLParseAddAttributeAndValueSelect = $0008;
	kXMLParseAddMultipleAttributesAndValuesSelect = $0009;
	kXMLParseAddAttributeValueKindSelect = $000A;
	kXMLParseAddNameSpaceSelect = $000B;
	kXMLParseSetOffsetAndLimitSelect = $000C;
	kXMLParseSetEventParseRefConSelect = $000D;
	kXMLParseSetStartDocumentHandlerSelect = $000E;
	kXMLParseSetEndDocumentHandlerSelect = $000F;
	kXMLParseSetStartElementHandlerSelect = $0010;
	kXMLParseSetEndElementHandlerSelect = $0011;
	kXMLParseSetCharDataHandlerSelect = $0012;
	kXMLParseSetPreprocessInstructionHandlerSelect = $0013;
	kXMLParseSetCommentHandlerSelect = $0014;
	kXMLParseSetCDataHandlerSelect = $0015;
	kSGInitializeSelect = $0001;
	kSGSetDataOutputSelect = $0002;
	kSGGetDataOutputSelect = $0003;
	kSGSetGWorldSelect = $0004;
	kSGGetGWorldSelect = $0005;
	kSGNewChannelSelect = $0006;
	kSGDisposeChannelSelect = $0007;
	kSGStartPreviewSelect = $0010;
	kSGStartRecordSelect = $0011;
	kSGIdleSelect = $0012;
	kSGStopSelect = $0013;
	kSGPauseSelect = $0014;
	kSGPrepareSelect = $0015;
	kSGReleaseSelect = $0016;
	kSGGetMovieSelect = $0017;
	kSGSetMaximumRecordTimeSelect = $0018;
	kSGGetMaximumRecordTimeSelect = $0019;
	kSGGetStorageSpaceRemainingSelect = $001A;
	kSGGetTimeRemainingSelect = $001B;
	kSGGrabPictSelect = $001C;
	kSGGetLastMovieResIDSelect = $001D;
	kSGSetFlagsSelect = $001E;
	kSGGetFlagsSelect = $001F;
	kSGSetDataProcSelect = $0020;
	kSGNewChannelFromComponentSelect = $0021;
	kSGDisposeDeviceListSelect = $0022;
	kSGAppendDeviceListToMenuSelect = $0023;
	kSGSetSettingsSelect = $0024;
	kSGGetSettingsSelect = $0025;
	kSGGetIndChannelSelect = $0026;
	kSGUpdateSelect = $0027;
	kSGGetPauseSelect = $0028;
	kSGSettingsDialogSelect = $0029;
	kSGGetAlignmentProcSelect = $002A;
	kSGSetChannelSettingsSelect = $002B;
	kSGGetChannelSettingsSelect = $002C;
	kSGGetModeSelect = $002D;
	kSGSetDataRefSelect = $002E;
	kSGGetDataRefSelect = $002F;
	kSGNewOutputSelect = $0030;
	kSGDisposeOutputSelect = $0031;
	kSGSetOutputFlagsSelect = $0032;
	kSGSetChannelOutputSelect = $0033;
	kSGGetDataOutputStorageSpaceRemainingSelect = $0034;
	kSGHandleUpdateEventSelect = $0035;
	kSGSetOutputNextOutputSelect = $0036;
	kSGGetOutputNextOutputSelect = $0037;
	kSGSetOutputMaximumOffsetSelect = $0038;
	kSGGetOutputMaximumOffsetSelect = $0039;
	kSGGetOutputDataReferenceSelect = $003A;
	kSGWriteExtendedMovieDataSelect = $003B;
	kSGGetStorageSpaceRemaining64Select = $003C;
	kSGGetDataOutputStorageSpaceRemaining64Select = $003D;
	kSGWriteMovieDataSelect = $0100;
	kSGAddFrameReferenceSelect = $0101;
	kSGGetNextFrameReferenceSelect = $0102;
	kSGGetTimeBaseSelect = $0103;
	kSGSortDeviceListSelect = $0104;
	kSGAddMovieDataSelect = $0105;
	kSGChangedSourceSelect = $0106;
	kSGAddExtendedFrameReferenceSelect = $0107;
	kSGGetNextExtendedFrameReferenceSelect = $0108;
	kSGAddExtendedMovieDataSelect = $0109;
	kSGAddOutputDataRefToMediaSelect = $010A;
	kSGSetSettingsSummarySelect = $010B;
	kSGSetChannelUsageSelect = $0080;
	kSGGetChannelUsageSelect = $0081;
	kSGSetChannelBoundsSelect = $0082;
	kSGGetChannelBoundsSelect = $0083;
	kSGSetChannelVolumeSelect = $0084;
	kSGGetChannelVolumeSelect = $0085;
	kSGGetChannelInfoSelect = $0086;
	kSGSetChannelPlayFlagsSelect = $0087;
	kSGGetChannelPlayFlagsSelect = $0088;
	kSGSetChannelMaxFramesSelect = $0089;
	kSGGetChannelMaxFramesSelect = $008A;
	kSGSetChannelRefConSelect = $008B;
	kSGSetChannelClipSelect = $008C;
	kSGGetChannelClipSelect = $008D;
	kSGGetChannelSampleDescriptionSelect = $008E;
	kSGGetChannelDeviceListSelect = $008F;
	kSGSetChannelDeviceSelect = $0090;
	kSGSetChannelMatrixSelect = $0091;
	kSGGetChannelMatrixSelect = $0092;
	kSGGetChannelTimeScaleSelect = $0093;
	kSGChannelPutPictureSelect = $0094;
	kSGChannelSetRequestedDataRateSelect = $0095;
	kSGChannelGetRequestedDataRateSelect = $0096;
	kSGChannelSetDataSourceNameSelect = $0097;
	kSGChannelGetDataSourceNameSelect = $0098;
	kSGChannelSetCodecSettingsSelect = $0099;
	kSGChannelGetCodecSettingsSelect = $009A;
	kSGGetChannelTimeBaseSelect = $009B;
	kSGGetChannelRefConSelect = $009C;
	kSGGetChannelDeviceAndInputNamesSelect = $009D;
	kSGSetChannelDeviceInputSelect = $009E;
	kSGSetChannelSettingsStateChangingSelect = $009F;
	kSGInitChannelSelect = $0180;
	kSGWriteSamplesSelect = $0181;
	kSGGetDataRateSelect = $0182;
	kSGAlignChannelRectSelect = $0183;
	kSGPanelGetDitlSelect = $0200;
	kSGPanelGetTitleSelect = $0201;
	kSGPanelCanRunSelect = $0202;
	kSGPanelInstallSelect = $0203;
	kSGPanelEventSelect = $0204;
	kSGPanelItemSelect = $0205;
	kSGPanelRemoveSelect = $0206;
	kSGPanelSetGrabberSelect = $0207;
	kSGPanelSetResFileSelect = $0208;
	kSGPanelGetSettingsSelect = $0209;
	kSGPanelSetSettingsSelect = $020A;
	kSGPanelValidateInputSelect = $020B;
	kSGPanelSetEventFilterSelect = $020C;
	kSGPanelGetDITLForSizeSelect = $020D;
	kSGGetSrcVideoBoundsSelect = $0100;
	kSGSetVideoRectSelect = $0101;
	kSGGetVideoRectSelect = $0102;
	kSGGetVideoCompressorTypeSelect = $0103;
	kSGSetVideoCompressorTypeSelect = $0104;
	kSGSetVideoCompressorSelect = $0105;
	kSGGetVideoCompressorSelect = $0106;
	kSGGetVideoDigitizerComponentSelect = $0107;
	kSGSetVideoDigitizerComponentSelect = $0108;
	kSGVideoDigitizerChangedSelect = $0109;
	kSGSetVideoBottlenecksSelect = $010A;
	kSGGetVideoBottlenecksSelect = $010B;
	kSGGrabFrameSelect = $010C;
	kSGGrabFrameCompleteSelect = $010D;
	kSGDisplayFrameSelect = $010E;
	kSGCompressFrameSelect = $010F;
	kSGCompressFrameCompleteSelect = $0110;
	kSGAddFrameSelect = $0111;
	kSGTransferFrameForCompressSelect = $0112;
	kSGSetCompressBufferSelect = $0113;
	kSGGetCompressBufferSelect = $0114;
	kSGGetBufferInfoSelect = $0115;
	kSGSetUseScreenBufferSelect = $0116;
	kSGGetUseScreenBufferSelect = $0117;
	kSGGrabCompressCompleteSelect = $0118;
	kSGDisplayCompressSelect = $0119;
	kSGSetFrameRateSelect = $011A;
	kSGGetFrameRateSelect = $011B;
	kSGSetPreferredPacketSizeSelect = $0121;
	kSGGetPreferredPacketSizeSelect = $0122;
	kSGSetUserVideoCompressorListSelect = $0123;
	kSGGetUserVideoCompressorListSelect = $0124;
	kSGSetSoundInputDriverSelect = $0100;
	kSGGetSoundInputDriverSelect = $0101;
	kSGSoundInputDriverChangedSelect = $0102;
	kSGSetSoundRecordChunkSizeSelect = $0103;
	kSGGetSoundRecordChunkSizeSelect = $0104;
	kSGSetSoundInputRateSelect = $0105;
	kSGGetSoundInputRateSelect = $0106;
	kSGSetSoundInputParametersSelect = $0107;
	kSGGetSoundInputParametersSelect = $0108;
	kSGSetAdditionalSoundRatesSelect = $0109;
	kSGGetAdditionalSoundRatesSelect = $010A;
	kSGSetFontNameSelect = $0100;
	kSGSetFontSizeSelect = $0101;
	kSGSetTextForeColorSelect = $0102;
	kSGSetTextBackColorSelect = $0103;
	kSGSetJustificationSelect = $0104;
	kSGGetTextReturnToSpaceValueSelect = $0105;
	kSGSetTextReturnToSpaceValueSelect = $0106;
	kSGGetInstrumentSelect = $0100;
	kSGSetInstrumentSelect = $0101;
	kQTVideoOutputGetDisplayModeListSelect = $0001;
	kQTVideoOutputGetCurrentClientNameSelect = $0002;
	kQTVideoOutputSetClientNameSelect = $0003;
	kQTVideoOutputGetClientNameSelect = $0004;
	kQTVideoOutputBeginSelect = $0005;
	kQTVideoOutputEndSelect = $0006;
	kQTVideoOutputSetDisplayModeSelect = $0007;
	kQTVideoOutputGetDisplayModeSelect = $0008;
	kQTVideoOutputCustomConfigureDisplaySelect = $0009;
	kQTVideoOutputSaveStateSelect = $000A;
	kQTVideoOutputRestoreStateSelect = $000B;
	kQTVideoOutputGetGWorldSelect = $000C;
	kQTVideoOutputGetGWorldParametersSelect = $000D;
	kQTVideoOutputGetIndSoundOutputSelect = $000E;
	kQTVideoOutputGetClockSelect = $000F;
	kQTVideoOutputSetEchoPortSelect = $0010;
	kQTVideoOutputGetIndImageDecompressorSelect = $0011;
	kQTVideoOutputBaseSetEchoPortSelect = $0012;
	kQTVideoOutputCopyIndAudioOutputDeviceUIDSelect = $0016;

{$endc} {not TARGET_CPU_64}

{$endc} {TARGET_OS_MAC}
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
