{
     File:       QuickTime/Movies.h
 
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

unit Movies;
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
uses MacTypes,Aliases,Components,Dialogs,Events,Files,Menus,ImageCompression,QDOffscreen,QuickdrawTypes,TextEdit,HIObject,CFBase,CFDictionary,CFString,CoreAudioTypes,AUComponent;
{$endc} {not MACOSALLINCLUDE}


{$ifc TARGET_OS_MAC}

{
    Important note regarding availability macros
    ============================================
    
    QuickTime APIs that were introduced in QuickTime 6.0 and later are tagged with 
    availability macros indicating the first Mac OS X version in which they were 
    *always* available.  Such APIs may also be present on systems running earlier 
    Mac OS X releases when QuickTime updates have been installed.
    
    For example, QTNewDataReferenceFromCFURL was introduced in QuickTime 6.4.
    It is always available on Mac OS X 10.3, which shipped with QuickTime 6.4.
    However, QuickTime 6.4 can also be installed as an update to Mac OS X 10.2.x,
    so QTNewDataReferenceFromCFURL is also available on some systems running 
    Mac OS X 10.2.x.
    
    QuickTime 6.0 / Mac OS X 10.2  :  AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER
    QuickTime 6.4 / Mac OS X 10.3  :  AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER
    QuickTime 7.0 / Mac OS X 10.4  :  AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER
    QuickTime 7.2 / Mac OS X 10.5  :  AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER
    
    As described in /usr/include/AvailabilityMacros.h, you can use the
    MAC_OS_X_VERSION_MIN_REQUIRED macro to weak-link to the APIs that may not be 
    available on the Mac OS X versions your software targets.
}


{$ALIGN MAC68K}

{ This sets the user defined exportset name i.e. fw_QuickTime_XManchego, available on 10.5 or later, and comment [4486184] }
{ NOTE:  Requires Interfacer-35 or later }
{ <exportset=fw_QuickTime_XManchego> }
{ <exportset=fw_QuickTime_XMaguro> }

{  "kFix1" is defined in FixMath as "fixed1"  }
{ error codes are in Errors.[haa] }
{ gestalt codes are in Gestalt.[hpa] }
const
	MovieFileType = FourCharCode('MooV');
	MovieScrapType = FourCharCode('moov');

const
	MovieResourceType = FourCharCode('moov');
	MovieForwardPointerResourceType = FourCharCode('fore');
	MovieBackwardPointerResourceType = FourCharCode('back');

const
	MovieResourceAtomType = FourCharCode('moov');
	MovieDataAtomType = FourCharCode('mdat');
	FreeAtomType = FourCharCode('free');
	SkipAtomType = FourCharCode('skip');
	WideAtomPlaceholderType = FourCharCode('wide');

const
	MediaHandlerType = FourCharCode('mhlr');
	DataHandlerType = FourCharCode('dhlr');

const
	VideoMediaType = FourCharCode('vide');
	SoundMediaType = FourCharCode('soun');
	TextMediaType = FourCharCode('text');
	BaseMediaType = FourCharCode('gnrc');
	MPEGMediaType = FourCharCode('MPEG');
	MusicMediaType = FourCharCode('musi');
	TimeCodeMediaType = FourCharCode('tmcd');
	SpriteMediaType = FourCharCode('sprt');
	FlashMediaType = FourCharCode('flsh');
	MovieMediaType = FourCharCode('moov');
	TweenMediaType = FourCharCode('twen');
	ThreeDeeMediaType = FourCharCode('qd3d');
	SkinMediaType = FourCharCode('skin');
	HandleDataHandlerSubType = FourCharCode('hndl');
	PointerDataHandlerSubType = FourCharCode('ptr ');
	NullDataHandlerSubType = FourCharCode('null');
	ResourceDataHandlerSubType = FourCharCode('rsrc');
	URLDataHandlerSubType = FourCharCode('url ');
	AliasDataHandlerSubType = FourCharCode('alis');
	WiredActionHandlerType = FourCharCode('wire');
	kQTQuartzComposerMediaType = FourCharCode('qtz ');
	TimeCode64MediaType = FourCharCode('tc64');

const
	VisualMediaCharacteristic = FourCharCode('eyes');
	AudioMediaCharacteristic = FourCharCode('ears');
	kCharacteristicCanSendVideo = FourCharCode('vsnd');
	kCharacteristicProvidesActions = FourCharCode('actn');
	kCharacteristicNonLinear = FourCharCode('nonl');
	kCharacteristicCanStep = FourCharCode('step');
	kCharacteristicHasNoDuration = FourCharCode('noti');
	kCharacteristicHasSkinData = FourCharCode('skin');
	kCharacteristicProvidesKeyFocus = FourCharCode('keyf');
	kCharacteristicSupportsDisplayOffsets = FourCharCode('dtdd');

const
	kUserDataMovieControllerType = FourCharCode('ctyp');
	kUserDataName = FourCharCode('name');
	kUserDataTextAlbum = FourCharCode('�alb');
	kUserDataTextArtist = FourCharCode('�ART');
	kUserDataTextAuthor = FourCharCode('�aut');
	kUserDataTextChapter = FourCharCode('�chp');
	kUserDataTextComment = FourCharCode('�cmt');
	kUserDataTextComposer = FourCharCode('�com');
	kUserDataTextCopyright = FourCharCode('�cpy');
	kUserDataTextCreationDate	= FourCharCode('�day');
	kUserDataTextDescription = FourCharCode('�des');
	kUserDataTextDirector = FourCharCode('�dir');
	kUserDataTextDisclaimer = FourCharCode('�dis');
	kUserDataTextEncodedBy = FourCharCode('�enc');
	kUserDataTextFullName = FourCharCode('�nam');
	kUserDataTextGenre = FourCharCode('�gen');
	kUserDataTextHostComputer	= FourCharCode('�hst');
	kUserDataTextInformation = FourCharCode('�inf');
	kUserDataTextKeywords = FourCharCode('�key');
	kUserDataTextMake = FourCharCode('�mak');
	kUserDataTextModel = FourCharCode('�mod');
	kUserDataTextOriginalArtist	= FourCharCode('�ope');
	kUserDataTextOriginalFormat	= FourCharCode('�fmt');
	kUserDataTextOriginalSource	= FourCharCode('�src');
	kUserDataTextPerformers = FourCharCode('�prf');
	kUserDataTextProducer = FourCharCode('�prd');
	kUserDataTextPublisher = FourCharCode('�pub');
	kUserDataTextProduct = FourCharCode('�PRD');
	kUserDataTextSoftware = FourCharCode('�swr');
	kUserDataTextSpecialPlaybackRequirements = FourCharCode('�req');
	kUserDataTextTrack = FourCharCode('�trk');
	kUserDataTextWarning = FourCharCode('�wrn');
	kUserDataTextWriter = FourCharCode('�wrt');
	kUserDataTextURLLink = FourCharCode('�url');
	kUserDataTextEditDate1 = FourCharCode('�ed1');
	kUserDataAnimatedGIFLoopCount = FourCharCode('gifc'); { data is big-endian UInt16 }
	kQTAnimatedGIFLoopCountInfinite = 0;
	kUserDataAnimatedGIFBufferingSize = FourCharCode('gifb'); { data is big-endian UInt32 }

const
	kUserDataUnicodeBit = 1 shl 7;

const
	DoTheRightThing = 0;


{$ifc not TARGET_CPU_64}

{ property types}
type
	QTPropertyClass = OSType;
	QTPropertyID = OSType;
	QTPropertyValueType = OSType;
	QTPropertyValueTypePtr = ^QTPropertyValueType;
	QTPropertyValuePtr = UnivPtr;
	ConstQTPropertyValuePtr = {const} UnivPtr;
	MovieTypePtr = ^SInt32; { an opaque type }
	Movie = ^MovieTypePtr;
	Movie_fix = Movie; { used as field type when a record declaration contains a Movie field identifier }
	MoviePtr = ^Movie;
	PtrToMovie = MoviePtr;
	TrackTypePtr = ^SInt32; { an opaque type }
	Track = ^TrackTypePtr;
	Track_fix = Track; { used as field type when a record declaration contains a Track field identifier }
	MediaTypePtr = ^SInt32; { an opaque type }
	Media = ^MediaTypePtr;
	UserDataRecordPtr = ^SInt32; { an opaque type }
	UserData = ^UserDataRecordPtr;
	MovieEditStateRecordPtr = ^SInt32; { an opaque type }
	MovieEditState = ^MovieEditStateRecordPtr;
	TrackEditStateRecordPtr = ^SInt32; { an opaque type }
	TrackEditState = ^TrackEditStateRecordPtr;
	QTRestrictionSetRecordPtr = ^SInt32; { an opaque type }
	QTRestrictionSet = ^QTRestrictionSetRecordPtr;
	SpriteWorld = ^SInt32; { an opaque type }
	Sprite = ^SInt32; { an opaque type }
	QTTweener = ^SInt32; { an opaque type }

{$endc} {not TARGET_CPU_64}


type
	SampleDescription = record
		descSize: SInt32;
		dataFormat: SInt32;
		resvd1: SInt32;
		resvd2: SInt16;
		dataRefIndex: SInt16;
	end;
	SampleDescriptionPtr = ^SampleDescription;
type
	SampleDescriptionHandle = ^SampleDescriptionPtr;

{$ifc not TARGET_CPU_64}

const
	kQTNetworkStatusNoNetwork = -2;
	kQTNetworkStatusUncertain = -1;
	kQTNetworkStatusNotConnected = 0;
	kQTNetworkStatusConnected = 1;

type
	QTAtomContainer = Handle;
	QTAtom = SIGNEDLONG;
	QTAtomType = SIGNEDLONG;
	QTAtomID = SIGNEDLONG;
{ QTFloatDouble is the 64-bit IEEE-754 standard}
type
	QTFloatDouble = Float64;
{ QTFloatSingle is the 32-bit IEEE-754 standard}
type
	QTFloatSingle = Float32;

{$endc} {not TARGET_CPU_64}

{************************
 * SoundDescription
 ************************}
type
	SoundDescription = record
		descSize: SInt32;               { total size of SoundDescription including extra data }
		dataFormat: SInt32;             { sound format }
		resvd1: SInt32;                 { reserved for apple use. set to zero }
		resvd2: SInt16;                 { reserved for apple use. set to zero }
		dataRefIndex: SInt16;
		version: SInt16;                { which version is this data }
		revlevel: SInt16;               { what version of that codec did this }
		vendor: SInt32;                 { whose  codec compressed this data }
		numChannels: SInt16;            { number of channels of sound }
		sampleSize: SInt16;             { number of bits per sample }
		compressionID: SInt16;          { unused. set to zero. }
		packetSize: SInt16;             { unused. set to zero. }
		sampleRate: UnsignedFixed;             { sample rate sound is captured at }
	end;
	SoundDescriptionPtr = ^SoundDescription;
type
	SoundDescriptionHandle = ^SoundDescriptionPtr;
{ version 1 of the SoundDescription record}
type
	SoundDescriptionV1 = record
{ original fields}
		desc: SoundDescription;
                                              { fixed compression ratio information}
		samplesPerPacket: UInt32;
		bytesPerPacket: UInt32;
		bytesPerFrame: UInt32;
		bytesPerSample: UInt32;
                                              { additional atom based fields ([long size, long type, some data], repeat)}
	end;
	SoundDescriptionV1Ptr = ^SoundDescriptionV1;
type
	SoundDescriptionV1Handle = ^SoundDescriptionV1Ptr;
{
   Definitions for SoundDescriptionV2:
        LPCMFrame = one uncompressed sample in each of the channels (ie. 44100Hz audio has
                44100 LPCMFrames per second, whether it is mono, stereo, 5.1, or whatever).
                In other words, LPCMFrames/audioSampleRate is duration in seconds.
        AudioPacket = For compressed audio, an AudioPacket is the natural compressed access
                unit of that format.  For uncompressed audio, an AudioPacket is simply one
                LPCMFrame.
}
{ version 2 of the SoundDescription record}
type
	SoundDescriptionV2 = record
		descSize: SInt32;               { total size of SoundDescription including extra data }
		dataFormat: OSType;             { 'lpcm' for uncompressed, compression type otherwise (eg. 'ima4') }
		resvd1: SInt32;                 { reserved for apple use. Must be set to zero }
		resvd2: SInt16;                 { reserved for apple use. Must be set to zero }
		dataRefIndex: SInt16;
		version: SInt16;                { which version is this data (2 in this case) }
		revlevel: SInt16;               { what version of that codec did this }
		vendor: SInt32;                 { whose  codec compressed this data }

		always3: SInt16;                { Reserved, must be set to 3 }
		always16: SInt16;               { Reserved, must be set to 16 (0x0010) }
		alwaysMinus2: SInt16;           { Reserved, must be set to -2 (0xFFFE) }
		always0: SInt16;                { Reserved, must be set to 0 }
		always65536: UInt32;            { Reserved, must be set to 65536 (0x00010000) }

		sizeOfStructOnly: UInt32;       { must be set to sizeof(SoundDescriptionV2), ie. offset to extensions }
		audioSampleRate: Float64;        { audio frames per second, eg. 44100.0 }
		numAudioChannels: UInt32;       { any channel assignment info will be in an extension }

		always7F000000: SInt32;         { Reserved, must be set to 0x7F000000 }
		constBitsPerChannel: UInt32;    { only set if constant (and only for uncompressed audio) }

		formatSpecificFlags: UInt32;    { eg. see LPCM flag definitions in CoreAudioTypes.h }
		constBytesPerAudioPacket: UInt32; { only set if constant }
		constLPCMFramesPerAudioPacket: UInt32; { only set if constant }

                                              { additional atom based extensions ([long size, long type, some data], repeat)}
	end;
	SoundDescriptionV2Ptr = ^SoundDescriptionV2;
type
	SoundDescriptionV2Handle = ^SoundDescriptionV2Ptr;

{$ifc not TARGET_CPU_64}

const
	kQTSoundDescriptionKind_Movie_Version1 = FourCharCode('mvv1');
	kQTSoundDescriptionKind_Movie_Version2 = FourCharCode('mvv2');
	kQTSoundDescriptionKind_Movie_LowestPossibleVersion = FourCharCode('mvlo');
	kQTSoundDescriptionKind_Movie_AnyVersion = FourCharCode('mvny');

type
	QTSoundDescriptionKind = FourCharCode;
{
 *  QTSoundDescriptionCreate()
 *  
 *  Summary:
 *    QTSoundDescriptionCreate creates a SoundDescription of the
 *    requested kind from an AudioStreamBasicDescription, optional
 *    AudioChannelLayout, and optional magic cookie. 
 *    QTSoundDescriptionCreate allocates the returned
 *    SoundDescriptionHandle, and the caller is responsible for
 *    disposing it.
 *  
 *  Parameters:
 *    
 *    inASBD:
 *      a description of the format
 *    
 *    inLayout:
 *      the audio channel layout (can be NULL if there isn't one)
 *    
 *    inLayoutSize:
 *      size of the audio channel layout (should be 0 if inLayout is
 *      NULL)
 *    
 *    inMagicCookie:
 *      the magic cookie for the decompressor (can be NULL if there
 *      isn't one)
 *    
 *    inMagicCookieSize:
 *      size of the magic cookie (should be 0 if inMagicCookie is NULL)
 *    
 *    inRequestedKind:
 *      the kind of SoundDescription to create
 *    
 *    outSoundDesc:
 *      the resulting SoundDescription.  Caller must dispose with
 *      DisposeHandle.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTSoundDescriptionCreate( var inASBD: AudioStreamBasicDescription; inLayout: AudioChannelLayoutPtr { can be NULL }; inLayoutSize: ByteCount; inMagicCookie: UnivPtr; inMagicCookieSize: ByteCount; inRequestedKind: QTSoundDescriptionKind; var outSoundDesc: SoundDescriptionHandle ): OSStatus; external name '_QTSoundDescriptionCreate';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSoundDescriptionConvert()
 *  
 *  Summary:
 *    Converts from one kind of SoundDescription to another. Note that
 *    fromKind is reserved for future expansion.  You must set it to
 *    kSoundDescriptionKind_Movie_AnyVersion. You can specify (via
 *    toKind) that you would like a specific SoundDescription version,
 *    the lowest possible version (given the constraints of the format
 *    described by fromDescription), or any version of SoundDescription
 *    at all. QTSoundDescriptionConvert allocates the returned
 *    SoundDescriptionHandle and the caller is responsible for
 *    disposing it.
 *  
 *  Parameters:
 *    
 *    fromKind:
 *      reserved, must be set to kSoundDescriptionKind_Movie_AnyVersion
 *    
 *    fromDescription:
 *      input description to be converted
 *    
 *    toKind:
 *      kind of description toDescription will be
 *    
 *    toDescription:
 *      the resulting SoundDescription.  Caller must dispose with
 *      DisposeHandle.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTSoundDescriptionConvert( fromKind: QTSoundDescriptionKind; fromDescription: SoundDescriptionHandle; toKind: QTSoundDescriptionKind; var toDescription: SoundDescriptionHandle ): OSStatus; external name '_QTSoundDescriptionConvert';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ SoundDescription Properties}

const
{
   * Properties of a SoundDescription
   }
	kQTPropertyClass_SoundDescription = FourCharCode('sdes'); { class for SoundDescription properties}


const
{
   * kQTSoundDescriptionPropertyID_AudioChannelLayout: Value is
   * AudioChannelLayout (Get/Set) Note that this is a variable sized
   * property (since it may contain an array of ChannelDescriptions;
   * see CoreAudioTypes.h).  You must get the size first (by calling
   * QTSoundDescriptionGetPropertyInfo), allocate a struct of that
   * size, and then get the property.
   }
	kQTSoundDescriptionPropertyID_AudioChannelLayout = FourCharCode('clay');

  {
   * kQTSoundDescriptionPropertyID_MagicCookie: Value is opaque bytes
   * (Get/Set) Note that this is a variable sized property (since it is
   * completely defined by the codec in question).  You must get the
   * size first (by calling QTSoundDescriptionGetPropertyInfo),
   * allocate a struct of that size, and then get the property.
   }
	kQTSoundDescriptionPropertyID_MagicCookie = FourCharCode('kuki');

  {
   * kQTSoundDescriptionPropertyID_AudioStreamBasicDescription: Value
   * is AudioStreamBasicDescription (Get only)
   }
	kQTSoundDescriptionPropertyID_AudioStreamBasicDescription = FourCharCode('asbd');

  {
   * kQTSoundDescriptionPropertyID_BitRate: Value is UInt32 in bits per
   * second (Get only) kQTSoundDescriptionPropertyID_BitRate Note that
   * this property may not be available for formats that are inherently
   * very variable in bitrate and highly source-data dependent (such as
   * Apple Lossless).
   }
	kQTSoundDescriptionPropertyID_BitRate = FourCharCode('brat');

  {
   * kQTSoundDescriptionPropertyID_UserReadableText: Value is
   * CFStringRef (Get only) QTSoundDescriptionGetProperty does a
   * CFRetain of the returned CFString on behalf of the caller, so the
   * caller is responsible for calling CFRelease on the returned
   * CFString.
   }
	kQTSoundDescriptionPropertyID_UserReadableText = FourCharCode('text');

{
 *  QTSoundDescriptionGetPropertyInfo()
 *  
 *  Summary:
 *    Gets info about a particular property of a SoundDescription.
 *  
 *  Parameters:
 *    
 *    inDesc:
 *      SoundDescription being interrogated
 *    
 *    inPropClass:
 *      class of property being requested
 *    
 *    inPropID:
 *      ID of property being requested
 *    
 *    outPropType:
 *      type of property is returned here (can be NULL)
 *    
 *    outPropValueSize:
 *      size of property is returned here (can be NULL)
 *    
 *    outPropertyFlags:
 *      property flags are returned here (can be NULL)
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTSoundDescriptionGetPropertyInfo( inDesc: SoundDescriptionHandle; inPropClass: QTPropertyClass; inPropID: QTPropertyID; outPropType: QTPropertyValueTypePtr { can be NULL }; outPropValueSize: ByteCountPtr { can be NULL }; outPropertyFlags: UInt32Ptr { can be NULL } ): OSStatus; external name '_QTSoundDescriptionGetPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSoundDescriptionGetProperty()
 *  
 *  Summary:
 *    Gets a particular property of a SoundDescription.
 *  
 *  Parameters:
 *    
 *    inDesc:
 *      SoundDescription being interrogated
 *    
 *    inPropClass:
 *      class of property being requested
 *    
 *    inPropID:
 *      ID of property being requested
 *    
 *    inPropValueSize:
 *      size of property value buffer
 *    
 *    outPropValueAddress:
 *      pointer to property value buffer
 *    
 *    outPropValueSizeUsed:
 *      actual size of returned property value (can be NULL)
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTSoundDescriptionGetProperty( inDesc: SoundDescriptionHandle; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; outPropValueAddress: QTPropertyValuePtr; outPropValueSizeUsed: ByteCountPtr { can be NULL } ): OSStatus; external name '_QTSoundDescriptionGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSoundDescriptionSetProperty()
 *  
 *  Summary:
 *    Sets a particular property of a SoundDescription.
 *  
 *  Parameters:
 *    
 *    inDesc:
 *      SoundDescription being modified
 *    
 *    inPropClass:
 *      class of property being set
 *    
 *    inPropID:
 *      ID of property being set
 *    
 *    inPropValueSize:
 *      size of property value buffer
 *    
 *    inPropValueAddress:
 *      pointer to property value buffer
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTSoundDescriptionSetProperty( inDesc: SoundDescriptionHandle; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstQTPropertyValuePtr ): OSStatus; external name '_QTSoundDescriptionSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ Sound Description Extensions}

{
 *  AddSoundDescriptionExtension()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function AddSoundDescriptionExtension( desc: SoundDescriptionHandle; extension: Handle; idType: OSType ): OSErr; external name '_AddSoundDescriptionExtension';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetSoundDescriptionExtension()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetSoundDescriptionExtension( desc: SoundDescriptionHandle; var extension: Handle; idType: OSType ): OSErr; external name '_GetSoundDescriptionExtension';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  RemoveSoundDescriptionExtension()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function RemoveSoundDescriptionExtension( desc: SoundDescriptionHandle; idType: OSType ): OSErr; external name '_RemoveSoundDescriptionExtension';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{$endc} {not TARGET_CPU_64}


const
	kTx3gSampleType = FourCharCode('tx3g');
	kTx3gFontTableAtomType = FourCharCode('ftab');
	kTx3gBlinkAtomType = FourCharCode('blnk');

type
	Tx3gRGBAColor = record
		red: UInt8;
		green: UInt8;
		blue: UInt8;
		transparency: UInt8;
	end;
type
	Tx3gStyleRecordPtr = ^Tx3gStyleRecord;
	Tx3gStyleRecord = record
		startChar: UInt16;
		endChar: UInt16;
		fontID: UInt16;
		fontFace: UInt8;
		fontSize: UInt8;
		fontColor: Tx3gRGBAColor;
	end;
type
	Tx3gStylePtr = Tx3gStyleRecordPtr;
	Tx3gStyleHandle = ^Tx3gStylePtr;
	Tx3gStyleTableRecordPtr = ^Tx3gStyleTableRecord;
	Tx3gStyleTableRecord = record
		count: UInt16;
    table: array [0..0] of Tx3gStyleRecord;
	end;
type
	Tx3gStyleTablePtr = Tx3gStyleTableRecordPtr;
	Tx3gStyleTableHandle = ^Tx3gStyleTablePtr;
	Tx3gFontRecord = record
		fontID: UInt16;
		nameLength: UInt8;
    name: array[0..0] of SInt8;
	end;
	Tx3gFontRecordPtr = ^Tx3gFontRecord;
type
	Tx3gFontTableRecordPtr = ^Tx3gFontTableRecord;
	Tx3gFontTableRecord = record
		entryCount: UInt16;
    fontEntries: array[0..0] of Tx3gFontRecord;
	end;
type
	Tx3gFontTablePtr = Tx3gFontTableRecordPtr;
	Tx3gFontTableHandle = ^Tx3gFontTablePtr;
	Tx3gDescription = record
		descSize: SInt32;
		dataFormat: SInt32;
		resvd1: SInt32;
		resvd2: SInt16;
		dataRefIndex: SInt16;

		displayFlags: UInt32;
		horizontalJustification: char;
		verticalJustification: char;
		backgroundColor: Tx3gRGBAColor;
		defaultTextBox: Rect;
		defaultStyle: Tx3gStyleRecord;
	end;
	Tx3gDescriptionPtr = ^Tx3gDescription;
type
	Tx3gDescriptionHandle = ^Tx3gDescriptionPtr;

{$ifc TARGET_CPU_64}

{ QuickDraw legacy }
type
	QTRGBColor = record
		red: UInt16;                    { magnitude of red component}
		green: UInt16;                  { magnitude of green component}
		blue: UInt16;                   { magnitude of blue component}
	end;

{$endc} {TARGET_CPU_64}

type
	TextDescription = record
		descSize: SInt32;               { Total size of TextDescription}
		dataFormat: SInt32;             { 'text'}

		resvd1: SInt32;
		resvd2: SInt16;
		dataRefIndex: SInt16;

		displayFlags: SInt32;           { see enum below for flag values}

		textJustification: SInt32;      { Can be: teCenter,teFlush -Default,-Right,-Left}


{$ifc TARGET_CPU_64}


		bgColor: QTRGBColor;                { Background color}

{$elsec} {TARGET_CPU_64}


		bgColor: RGBColor;                { Background color}

{$endc} {TARGET_CPU_64}


		defaultTextBox: Rect;         { Location to place the text within the track bounds}
		defaultStyle: ScrpSTElement;           { Default style (struct defined in TextEdit.h)}
    defaultFontName: array[0..0] of SInt8;     { Font Name (pascal string - struct extended to fit) }
	end;
	TextDescriptionPtr = ^TextDescription;
type
	TextDescriptionHandle = ^TextDescriptionPtr;

{$ifc not TARGET_CPU_64}

type
	SpriteDescription = record
		descSize: SIGNEDLONG;               { total size of SpriteDescription including extra data }
		dataFormat: SIGNEDLONG;             {  }
		resvd1: SIGNEDLONG;                 { reserved for apple use }
		resvd2: SInt16;
		dataRefIndex: SInt16;
		version: SIGNEDLONG;                { which version is this data }
		decompressorType: OSType;       { which decompressor to use, 0 for no decompression }
		sampleFlags: SIGNEDLONG;            { how to interpret samples }
	end;
	SpriteDescriptionPtr = ^SpriteDescription;
type
	SpriteDescriptionHandle = ^SpriteDescriptionPtr;
	FlashDescription = record
		descSize: SIGNEDLONG;
		dataFormat: SIGNEDLONG;
		resvd1: SIGNEDLONG;
		resvd2: SInt16;
		dataRefIndex: SInt16;
		version: SIGNEDLONG;                { which version is this data }
		decompressorType: OSType;       { which decompressor to use, 0 for no decompression }
		flags: SIGNEDLONG;
	end;
	FlashDescriptionPtr = ^FlashDescription;
type
	FlashDescriptionHandle = ^FlashDescriptionPtr;
	ThreeDeeDescription = record
		descSize: SIGNEDLONG;               { total size of ThreeDeeDescription including extra data }
		dataFormat: SIGNEDLONG;             {  }
		resvd1: SIGNEDLONG;                 { reserved for apple use }
		resvd2: SInt16;
		dataRefIndex: SInt16;
		version: SIGNEDLONG;                { which version is this data }
		rendererType: SIGNEDLONG;           { which renderer to use, 0 for default }
		decompressorType: SIGNEDLONG;       { which decompressor to use, 0 for default }
	end;
	ThreeDeeDescriptionPtr = ^ThreeDeeDescription;
type
	ThreeDeeDescriptionHandle = ^ThreeDeeDescriptionPtr;
	DataReferenceRecordPtr = ^DataReferenceRecord;
	DataReferenceRecord = record
		dataRefType: OSType;
		dataRef: Handle;
	end;
type
	DataReferencePtr = DataReferenceRecordPtr;
{--------------------------
  Music Sample Description
--------------------------}
type
	MusicDescription = record
		descSize: SIGNEDLONG;
		dataFormat: SIGNEDLONG;             { 'musi' }

		resvd1: SIGNEDLONG;
		resvd2: SInt16;
		dataRefIndex: SInt16;

		musicFlags: SIGNEDLONG;
    headerData: array [0..0] of UNSIGNEDLONG;          { variable size! }
	end;
	MusicDescriptionPtr = ^MusicDescription;
type
	MusicDescriptionHandle = ^MusicDescriptionPtr;
const
	kMusicFlagDontPlay2Soft = 1 shl 0;
	kMusicFlagDontSlaveToMovie = 1 shl 1;


const
	dfDontDisplay = 1 shl 0; { Don't display the text}
	dfDontAutoScale = 1 shl 1; { Don't scale text as track bounds grows or shrinks}
	dfClipToTextBox = 1 shl 2; { Clip update to the textbox}
	dfUseMovieBGColor = 1 shl 3; { Set text background to movie's background color}
	dfShrinkTextBoxToFit = 1 shl 4; { Compute minimum box to fit the sample}
	dfScrollIn = 1 shl 5; { Scroll text in until last of text is in view }
	dfScrollOut = 1 shl 6; { Scroll text out until last of text is gone (if both set, scroll in then out)}
	dfHorizScroll = 1 shl 7; { Scroll text horizontally (otherwise it's vertical)}
	dfReverseScroll = 1 shl 8; { vert: scroll down rather than up; horiz: scroll backwards (justfication dependent)}
	dfContinuousScroll = 1 shl 9; { new samples cause previous samples to scroll out }
	dfFlowHoriz = 1 shl 10; { horiz scroll text flows in textbox rather than extend to right }
	dfContinuousKaraoke = 1 shl 11; { ignore begin offset, hilite everything up to the end offset(karaoke)}
	dfDropShadow = 1 shl 12; { display text with a drop shadow }
	dfAntiAlias = 1 shl 13; { attempt to display text anti aliased}
	dfKeyedText = 1 shl 14; { key the text over background}
	dfInverseHilite = 1 shl 15; { Use inverse hiliting rather than using hilite color}
	dfTextColorHilite = 1 shl 16; { changes text color in place of hiliting. }

const
	searchTextDontGoToFoundTime = 1 shl 16;
	searchTextDontHiliteFoundText = 1 shl 17;
	searchTextOneTrackOnly = 1 shl 18;
	searchTextEnabledTracksOnly = 1 shl 19;

{use these with the text property routines}
const
{ set property parameter / get property parameter}
	kTextTextHandle = 1;    { Handle / preallocated Handle}
	kTextTextPtr = 2;    { Pointer}
	kTextTEStyle = 3;    { TextStyle * / TextStyle *}
	kTextSelection = 4;    { long [2] / long [2]}
	kTextBackColor = 5;    { RGBColor * / RGBColor *}
	kTextForeColor = 6;    { RGBColor * / RGBColor *}
	kTextFace = 7;    { long / long *}
	kTextFont = 8;    { long / long *}
	kTextSize = 9;    { long / long *}
	kTextAlignment = 10;   { short * / short *}
	kTextHilite = 11;   { hiliteRecord * / hiliteRecord *}
	kTextDropShadow = 12;   { dropShadowRecord * / dropShadowRecord *}
	kTextDisplayFlags = 13;   { long / long *}
	kTextScroll = 14;   { TimeValue * / TimeValue *}
	kTextRelativeScroll = 15;   { Point *}
	kTextHyperTextFace = 16;   { hyperTextSetFace * / hyperTextSetFace *}
	kTextHyperTextColor = 17;   { hyperTextSetColor * / hyperTextSetColor *}
	kTextKeyEntry = 18;   { short}
	kTextMouseDown = 19;   { Point *}
	kTextTextBox = 20;   { Rect * / Rect *}
	kTextEditState = 21;   { short / short *}
	kTextLength = 22;    {       / long *}

const
	k3DMediaRendererEntry = FourCharCode('rend');
	k3DMediaRendererName = FourCharCode('name');
	k3DMediaRendererCode = FourCharCode('rcod');

{ progress messages }
const
	movieProgressOpen = 0;
	movieProgressUpdatePercent = 1;
	movieProgressClose = 2;

{ progress operations }
const
	progressOpFlatten = 1;
	progressOpInsertTrackSegment = 2;
	progressOpInsertMovieSegment = 3;
	progressOpPaste = 4;
	progressOpAddMovieSelection = 5;
	progressOpCopy = 6;
	progressOpCut = 7;
	progressOpLoadMovieIntoRam = 8;
	progressOpLoadTrackIntoRam = 9;
	progressOpLoadMediaIntoRam = 10;
	progressOpImportMovie = 11;
	progressOpExportMovie = 12;

const
	mediaQualityDraft = $0000;
	mediaQualityNormal = $0040;
	mediaQualityBetter = $0080;
	mediaQualityBest = $00C0;

{****
    Interactive Sprites Support
****}
{ QTEventRecord flags}
const
	kQTEventPayloadIsQTList = 1 shl 0;

type
	QTEventRecord = record
		version: SIGNEDLONG;
		eventType: OSType;
		where: Point;
		flags: SIGNEDLONG;
		payloadRefcon: SIGNEDLONG;          { from here down only present if version >= 2}
		param1: SIGNEDLONG;
		param2: SIGNEDLONG;
		param3: SIGNEDLONG;
	end;
	QTEventRecordPtr = ^QTEventRecord;
type
	QTAtomSpec = record
		container: QTAtomContainer;
		atom: QTAtom;
	end;
	QTAtomSpecPtr = ^QTAtomSpec;
type
	ResolvedQTEventSpec = record
		actionAtom: QTAtomSpec;
		targetTrack: Track;
		targetRefCon: SIGNEDLONG;
	end;
	ResolvedQTEventSpecPtr = ^ResolvedQTEventSpec;

{ action constants }
const
	kActionMovieSetVolume = 1024; { (short movieVolume) }
	kActionMovieSetRate = 1025; { (Fixed rate) }
	kActionMovieSetLoopingFlags = 1026; { (long loopingFlags) }
	kActionMovieGoToTime = 1027; { (TimeValue time) }
	kActionMovieGoToTimeByName = 1028; { (Str255 timeName) }
	kActionMovieGoToBeginning = 1029; { no params }
	kActionMovieGoToEnd = 1030; { no params }
	kActionMovieStepForward = 1031; { no params }
	kActionMovieStepBackward = 1032; { no params }
	kActionMovieSetSelection = 1033; { (TimeValue startTime, TimeValue endTime) }
	kActionMovieSetSelectionByName = 1034; { (Str255 startTimeName, Str255 endTimeName) }
	kActionMoviePlaySelection = 1035; { (Boolean selectionOnly) }
	kActionMovieSetLanguage = 1036; { (long language) }
	kActionMovieChanged = 1037; { no params }
	kActionMovieRestartAtTime = 1038; { (TimeValue startTime, Fixed rate) }
	kActionMovieGotoNextChapter = 1039; { no params }
	kActionMovieGotoPreviousChapter = 1040; { no params }
	kActionMovieGotoFirstChapter = 1041; { no params }
	kActionMovieGotoLastChapter = 1042; { no params }
	kActionMovieGotoChapterByIndex = 1043; { ( short index ) }
	kActionMovieSetScale = 1044; { (Fixed xScale, Fixed yScale) }
	kActionTrackSetVolume = 2048; { (short volume) }
	kActionTrackSetBalance = 2049; { (short balance) }
	kActionTrackSetEnabled = 2050; { (Boolean enabled) }
	kActionTrackSetMatrix = 2051; { (MatrixRecord matrix) }
	kActionTrackSetLayer = 2052; { (short layer) }
	kActionTrackSetClip = 2053; { (RgnHandle clip) }
	kActionTrackSetCursor = 2054; { (QTATomID cursorID) }
	kActionTrackSetGraphicsMode = 2055; { (ModifierTrackGraphicsModeRecord graphicsMode) }
	kActionTrackSetIdleFrequency = 2056; { (long frequency) }
	kActionTrackSetBassTreble = 2057; { (short base, short treble) }
	kActionSpriteSetMatrix = 3072; { (MatrixRecord matrix) }
	kActionSpriteSetImageIndex = 3073; { (short imageIndex) }
	kActionSpriteSetVisible = 3074; { (short visible) }
	kActionSpriteSetLayer = 3075; { (short layer) }
	kActionSpriteSetGraphicsMode = 3076; { (ModifierTrackGraphicsModeRecord graphicsMode) }
	kActionSpritePassMouseToCodec = 3078; { no params }
	kActionSpriteClickOnCodec = 3079; { Point localLoc }
	kActionSpriteTranslate = 3080; { (Fixed x, Fixed y, Boolean isAbsolute) }
	kActionSpriteScale = 3081; { (Fixed xScale, Fixed yScale) }
	kActionSpriteRotate = 3082; { (Fixed degrees) }
	kActionSpriteStretch = 3083; { (Fixed p1x, Fixed p1y, Fixed p2x, Fixed p2y, Fixed p3x, Fixed p3y, Fixed p4x, Fixed p4y) }
	kActionSpriteSetCanBeHitTested = 3094; { (short canBeHitTested) }
	kActionQTVRSetPanAngle = 4096; { (float panAngle) }
	kActionQTVRSetTiltAngle = 4097; { (float tiltAngle) }
	kActionQTVRSetFieldOfView = 4098; { (float fieldOfView) }
	kActionQTVRShowDefaultView = 4099; { no params }
	kActionQTVRGoToNodeID = 4100; { (UInt32 nodeID) }
	kActionQTVREnableHotSpot = 4101; { long ID, Boolean enable }
	kActionQTVRShowHotSpots = 4102; { Boolean show }
	kActionQTVRTranslateObject = 4103; { float xMove, float yMove }
	kActionQTVRSetViewState = 4109; { long viewStateType, short state }
	kActionMusicPlayNote = 5120; { (long sampleDescIndex, long partNumber, long delay, long pitch, long velocity, long duration) }
	kActionMusicSetController = 5121; { (long sampleDescIndex, long partNumber, long delay, long controller, long value) }
	kActionCase = 6144; { [(CaseStatementActionAtoms)] }
	kActionWhile = 6145; { [(WhileStatementActionAtoms)] }
	kActionGoToURL = 6146; { (C string urlLink) }
	kActionSendQTEventToSprite = 6147; { ([(SpriteTargetAtoms)], QTEventRecord theEvent) }
	kActionDebugStr = 6148; { (Str255 theString) }
	kActionPushCurrentTime = 6149; { no params }
	kActionPushCurrentTimeWithLabel = 6150; { (Str255 theLabel) }
	kActionPopAndGotoTopTime = 6151; { no params }
	kActionPopAndGotoLabeledTime = 6152; { (Str255 theLabel) }
	kActionStatusString = 6153; { (C string theString, long stringTypeFlags) }
	kActionSendQTEventToTrackObject = 6154; { ([(TrackObjectTargetAtoms)], QTEventRecord theEvent) }
	kActionAddChannelSubscription = 6155; { (Str255 channelName, C string channelsURL, C string channelsPictureURL) }
	kActionRemoveChannelSubscription = 6156; { (C string channelsURL) }
	kActionOpenCustomActionHandler = 6157; { (long handlerID, ComponentDescription handlerDesc) }
	kActionDoScript = 6158; { (long scriptTypeFlags, CString command, CString arguments) }
	kActionDoCompressedActions = 6159; { (compressed QTAtomContainer prefixed with eight bytes: long compressorType, long decompressedSize) }
	kActionSendAppMessage = 6160; { (long appMessageID) }
	kActionLoadComponent = 6161; { (ComponentDescription handlerDesc) }
	kActionSetFocus = 6162; { [(TargetAtoms theObject)] }
	kActionDontPassKeyEvent = 6163; { no params }
	kActionSetRandomSeed = 6164; { long randomSeed }
	kActionSpriteTrackSetVariable = 7168; { (QTAtomID variableID, float value) }
	kActionSpriteTrackNewSprite = 7169; { (QTAtomID spriteID, short imageIndex, MatrixRecord *matrix, short visible, short layer, ModifierTrackGraphicsModeRecord *graphicsMode, QTAtomID actionHandlingSpriteID) }
	kActionSpriteTrackDisposeSprite = 7170; { (QTAtomID spriteID) }
	kActionSpriteTrackSetVariableToString = 7171; { (QTAtomID variableID, C string value) }
	kActionSpriteTrackConcatVariables = 7172; { (QTAtomID firstVariableID, QTAtomID secondVariableID, QTAtomID resultVariableID ) }
	kActionSpriteTrackSetVariableToMovieURL = 7173; { (QTAtomID variableID, < optional: [(MovieTargetAtoms)] > ) }
	kActionSpriteTrackSetVariableToMovieBaseURL = 7174; { (QTAtomID variableID, < optional: [(MovieTargetAtoms)] > ) }
	kActionSpriteTrackSetAllSpritesHitTestingMode = 7181;
	kActionSpriteTrackNewImage = 7182; { (C string imageURL, QTAtomID desiredID) }
	kActionSpriteTrackDisposeImage = 7183; { (short imageIndex) }
	kActionApplicationNumberAndString = 8192; { (long aNumber, Str255 aString ) }
	kActionQD3DNamedObjectTranslateTo = 9216; { (Fixed x, Fixed y, Fixed z ) }
	kActionQD3DNamedObjectScaleTo = 9217; { (Fixed xScale, Fixed yScale, Fixed zScale ) }
	kActionQD3DNamedObjectRotateTo = 9218; { (Fixed xDegrees, Fixed yDegrees, Fixed zDegrees ) }
	kActionFlashTrackSetPan = 10240; { (short xPercent, short yPercent ) }
	kActionFlashTrackSetZoom = 10241; { (short zoomFactor ) }
	kActionFlashTrackSetZoomRect = 10242; { (long left, long top, long right, long bottom ) }
	kActionFlashTrackGotoFrameNumber = 10243; { (long frameNumber ) }
	kActionFlashTrackGotoFrameLabel = 10244; { (C string frameLabel ) }
	kActionFlashTrackSetFlashVariable = 10245; { (C string path, C string name, C string value, Boolean updateFocus) }
	kActionFlashTrackDoButtonActions = 10246; { (C string path, long buttonID, long transition) }
	kActionMovieTrackAddChildMovie = 11264; { (QTAtomID childMovieID, C string childMovieURL) }
	kActionMovieTrackLoadChildMovie = 11265; { (QTAtomID childMovieID) }
	kActionMovieTrackLoadChildMovieWithQTListParams = 11266; { (QTAtomID childMovieID, C string qtlistXML) }
	kActionTextTrackPasteText = 12288; { (C string theText, long startSelection, long endSelection ) }
	kActionTextTrackSetTextBox = 12291; { (short left, short top, short right, short bottom) }
	kActionTextTrackSetTextStyle = 12292; { (Handle textStyle) }
	kActionTextTrackSetSelection = 12293; { (long startSelection, long endSelection ) }
	kActionTextTrackSetBackgroundColor = 12294; { (ModifierTrackGraphicsModeRecord backgroundColor ) }
	kActionTextTrackSetForegroundColor = 12295; { (ModifierTrackGraphicsModeRecord foregroundColor ) }
	kActionTextTrackSetFace = 12296; { (long fontFace ) }
	kActionTextTrackSetFont = 12297; { (long fontID ) }
	kActionTextTrackSetSize = 12298; { (long fontSize ) }
	kActionTextTrackSetAlignment = 12299; { (short alignment ) }
	kActionTextTrackSetHilite = 12300; { (long startHighlight, long endHighlight, ModifierTrackGraphicsModeRecord highlightColor ) }
	kActionTextTrackSetDropShadow = 12301; { (Point dropShadow, short transparency ) }
	kActionTextTrackSetDisplayFlags = 12302; { (long flags ) }
	kActionTextTrackSetScroll = 12303; { (long delay ) }
	kActionTextTrackRelativeScroll = 12304; { (short deltaX, short deltaY ) }
	kActionTextTrackFindText = 12305; { (long flags, Str255 theText, ModifierTrackGraphicsModeRecord highlightColor ) }
	kActionTextTrackSetHyperTextFace = 12306; { (short index, long fontFace ) }
	kActionTextTrackSetHyperTextColor = 12307; { (short index, ModifierTrackGraphicsModeRecord highlightColor ) }
	kActionTextTrackKeyEntry = 12308; { (short character ) }
	kActionTextTrackMouseDown = 12309; { no params }
	kActionTextTrackSetEditable = 12310; { (short editState) }
	kActionListAddElement = 13312; { (C string parentPath, long atIndex, C string newElementName) }
	kActionListRemoveElements = 13313; { (C string parentPath, long startIndex, long endIndex) }
	kActionListSetElementValue = 13314; { (C string elementPath, C string valueString) }
	kActionListPasteFromXML = 13315; { (C string xml, C string targetParentPath, long startIndex) }
	kActionListSetMatchingFromXML = 13316; { (C string xml, C string targetParentPath) }
	kActionListSetFromURL = 13317; { (C string url, C string targetParentPath ) }
	kActionListExchangeLists = 13318; { (C string url, C string parentPath) }
	kActionListServerQuery = 13319; { (C string url, C string keyValuePairs, long flags, C string parentPath) }
	kActionListAddAttribute = 13320; { (C string elementPath, long atIndex, C string newAttributeName) }
	kActionListRemoveAttributes = 13321; { (C string elementPath, long startIndex, long endIndex) }
	kActionListSetAttributeValue = 13322; { (C string elementPath, C string attributeName, C string valueString) }


const
	kOperandExpression = 1;
	kOperandConstant = 2;
	kOperandSubscribedToChannel = 3;    { C string channelsURL }
	kOperandUniqueCustomActionHandlerID = 4;
	kOperandCustomActionHandlerIDIsOpen = 5; { long ID }
	kOperandConnectionSpeed = 6;
	kOperandGMTDay = 7;
	kOperandGMTMonth = 8;
	kOperandGMTYear = 9;
	kOperandGMTHours = 10;
	kOperandGMTMinutes = 11;
	kOperandGMTSeconds = 12;
	kOperandLocalDay = 13;
	kOperandLocalMonth = 14;
	kOperandLocalYear = 15;
	kOperandLocalHours = 16;
	kOperandLocalMinutes = 17;
	kOperandLocalSeconds = 18;
	kOperandRegisteredForQuickTimePro = 19;
	kOperandPlatformRunningOn = 20;
	kOperandQuickTimeVersion = 21;
	kOperandComponentVersion = 22;   { C string type, C string subType, C string manufacturer }
	kOperandOriginalHandlerRefcon = 23;
	kOperandTicks = 24;
	kOperandMaxLoadedTimeInMovie = 25;
	kOperandEventParameter = 26;   { short index }
	kOperandFreeMemory = 27;
	kOperandNetworkStatus = 28;
	kOperandQuickTimeVersionRegistered = 29; { long version }
	kOperandSystemVersion = 30;
	kOperandMovieVolume = 1024;
	kOperandMovieRate = 1025;
	kOperandMovieIsLooping = 1026;
	kOperandMovieLoopIsPalindrome = 1027;
	kOperandMovieTime = 1028;
	kOperandMovieDuration = 1029;
	kOperandMovieTimeScale = 1030;
	kOperandMovieWidth = 1031;
	kOperandMovieHeight = 1032;
	kOperandMovieLoadState = 1033;
	kOperandMovieTrackCount = 1034;
	kOperandMovieIsActive = 1035;
	kOperandMovieName = 1036;
	kOperandMovieID = 1037;
	kOperandMovieChapterCount = 1038;
	kOperandMovieChapterIndex = 1039;
	kOperandMovieChapterName = 1040;
	kOperandMovieChapterNameByIndex = 1041; { ( short index ) }
	kOperandMovieChapterIndexByName = 1042; { (c string name)  }
	kOperandMovieAnnotation = 1043; { (c string requested, long flags) }
	kOperandMovieConnectionFlags = 1044;
	kOperandMovieConnectionString = 1045;
	kOperandTrackVolume = 2048;
	kOperandTrackBalance = 2049;
	kOperandTrackEnabled = 2050;
	kOperandTrackLayer = 2051;
	kOperandTrackWidth = 2052;
	kOperandTrackHeight = 2053;
	kOperandTrackDuration = 2054;
	kOperandTrackName = 2055;
	kOperandTrackID = 2056;
	kOperandTrackIdleFrequency = 2057;
	kOperandTrackBass = 2058;
	kOperandTrackTreble = 2059;
	kOperandSpriteBoundsLeft = 3072;
	kOperandSpriteBoundsTop = 3073;
	kOperandSpriteBoundsRight = 3074;
	kOperandSpriteBoundsBottom = 3075;
	kOperandSpriteImageIndex = 3076;
	kOperandSpriteVisible = 3077;
	kOperandSpriteLayer = 3078;
	kOperandSpriteTrackVariable = 3079; { [QTAtomID variableID] }
	kOperandSpriteTrackNumSprites = 3080;
	kOperandSpriteTrackNumImages = 3081;
	kOperandSpriteID = 3082;
	kOperandSpriteIndex = 3083;
	kOperandSpriteFirstCornerX = 3084;
	kOperandSpriteFirstCornerY = 3085;
	kOperandSpriteSecondCornerX = 3086;
	kOperandSpriteSecondCornerY = 3087;
	kOperandSpriteThirdCornerX = 3088;
	kOperandSpriteThirdCornerY = 3089;
	kOperandSpriteFourthCornerX = 3090;
	kOperandSpriteFourthCornerY = 3091;
	kOperandSpriteImageRegistrationPointX = 3092;
	kOperandSpriteImageRegistrationPointY = 3093;
	kOperandSpriteTrackSpriteIDAtPoint = 3094; { short x, short y }
	kOperandSpriteName = 3095;
	kOperandSpriteCanBeHitTested = 3105; { short }
	kOperandSpriteTrackAllSpritesHitTestingMode = 3106;
	kOperandSpriteTrackImageIDByIndex = 3107; { short imageIndex }
	kOperandSpriteTrackImageIndexByID = 3108; { QTAtomID }
	kOperandQTVRPanAngle = 4096;
	kOperandQTVRTiltAngle = 4097;
	kOperandQTVRFieldOfView = 4098;
	kOperandQTVRNodeID = 4099;
	kOperandQTVRHotSpotsVisible = 4100;
	kOperandQTVRViewCenterH = 4101;
	kOperandQTVRViewCenterV = 4102;
	kOperandQTVRViewStateCount = 4103;
	kOperandQTVRViewState = 4104; { long viewStateType }
	kOperandMouseLocalHLoc = 5120; { [TargetAtoms aTrack] }
	kOperandMouseLocalVLoc = 5121; { [TargetAtoms aTrack] }
	kOperandKeyIsDown = 5122; { [short modKeys, char asciiValue] }
	kOperandRandom = 5123; { [short min, short max] }
	kOperandCanHaveFocus = 5124; { [(TargetAtoms theObject)] }
	kOperandHasFocus = 5125; { [(TargetAtoms theObject)] }
	kOperandTextTrackEditable = 6144;
	kOperandTextTrackCopyText = 6145; { long startSelection, long endSelection }
	kOperandTextTrackStartSelection = 6146;
	kOperandTextTrackEndSelection = 6147;
	kOperandTextTrackTextBoxLeft = 6148;
	kOperandTextTrackTextBoxTop = 6149;
	kOperandTextTrackTextBoxRight = 6150;
	kOperandTextTrackTextBoxBottom = 6151;
	kOperandTextTrackTextLength = 6152;
	kOperandListCountElements = 7168; { (C string parentPath) }
	kOperandListGetElementPathByIndex = 7169; { (C string parentPath, long index) }
	kOperandListGetElementValue = 7170; { (C string elementPath) }
	kOperandListCopyToXML = 7171; { (C string parentPath, long startIndex, long endIndex) }
	kOperandListCountAttributes = 7172; { (C string elementPath) }
	kOperandListGetAttributeNameByIndex = 7173; { (C string elementPath, long index) }
	kOperandListGetAttributeValue = 7174; { (C string elementPath, C string attributeName) }
	kOperandSin = 8192; { float x    }
	kOperandCos = 8193; { float x    }
	kOperandTan = 8194; { float x    }
	kOperandATan = 8195; { float x    }
	kOperandATan2 = 8196; { float y, float x   }
	kOperandDegreesToRadians = 8197; { float x }
	kOperandRadiansToDegrees = 8198; { float x }
	kOperandSquareRoot = 8199; { float x }
	kOperandExponent = 8200; { float x }
	kOperandLog = 8201; { float x }
	kOperandFlashTrackVariable = 9216; { [CString path, CString name] }
	kOperandStringLength = 10240; { (C string text) }
	kOperandStringCompare = 10241; { (C string aText, C string bText, Boolean caseSensitive, Boolan diacSensitive) }
	kOperandStringSubString = 10242; { (C string text, long offset, long length) }
	kOperandStringConcat = 10243; { (C string aText, C string bText) }

const
	kFirstMovieAction = kActionMovieSetVolume;
	kLastMovieAction = kActionMovieSetScale;
	kFirstTrackAction = kActionTrackSetVolume;
	kLastTrackAction = kActionTrackSetBassTreble;
	kFirstSpriteAction = kActionSpriteSetMatrix;
	kLastSpriteAction = kActionSpriteSetCanBeHitTested;
	kFirstQTVRAction = kActionQTVRSetPanAngle;
	kLastQTVRAction = kActionQTVRSetViewState;
	kFirstMusicAction = kActionMusicPlayNote;
	kLastMusicAction = kActionMusicSetController;
	kFirstSystemAction = kActionCase;
	kLastSystemAction = kActionSetRandomSeed;
	kFirstSpriteTrackAction = kActionSpriteTrackSetVariable;
	kLastSpriteTrackAction = kActionSpriteTrackDisposeImage;
	kFirstApplicationAction = kActionApplicationNumberAndString;
	kLastApplicationAction = kActionApplicationNumberAndString;
	kFirstQD3DNamedObjectAction = kActionQD3DNamedObjectTranslateTo;
	kLastQD3DNamedObjectAction = kActionQD3DNamedObjectRotateTo;
	kFirstFlashTrackAction = kActionFlashTrackSetPan;
	kLastFlashTrackAction = kActionFlashTrackDoButtonActions;
	kFirstMovieTrackAction = kActionMovieTrackAddChildMovie;
	kLastMovieTrackAction = kActionMovieTrackLoadChildMovieWithQTListParams;
	kFirstTextTrackAction = kActionTextTrackPasteText;
	kLastTextTrackAction = kActionTextTrackSetEditable;
	kFirstMultiTargetAction = kActionListAddElement;
	kLastMultiTargetAction = kActionListSetAttributeValue;
	kFirstAction = kFirstMovieAction;
	kLastAction = kLastMultiTargetAction;

{ target atom types}
const
	kTargetMovie = FourCharCode('moov'); { no data }
	kTargetMovieName = FourCharCode('mona'); { (PString movieName) }
	kTargetMovieID = FourCharCode('moid'); { (long movieID) }
	kTargetRootMovie = FourCharCode('moro'); { no data }
	kTargetParentMovie = FourCharCode('mopa'); { no data }
	kTargetChildMovieTrackName = FourCharCode('motn'); { (PString childMovieTrackName) }
	kTargetChildMovieTrackID = FourCharCode('moti'); { (long childMovieTrackID) }
	kTargetChildMovieTrackIndex = FourCharCode('motx'); { (long childMovieTrackIndex) }
	kTargetChildMovieMovieName = FourCharCode('momn'); { (PString childMovieName) }
	kTargetChildMovieMovieID = FourCharCode('momi'); { (long childMovieID) }
	kTargetTrackName = FourCharCode('trna'); { (PString trackName) }
	kTargetTrackID = FourCharCode('trid'); { (long trackID) }
	kTargetTrackType = FourCharCode('trty'); { (OSType trackType) }
	kTargetTrackIndex = FourCharCode('trin'); { (long trackIndex) }
	kTargetSpriteName = FourCharCode('spna'); { (PString spriteName) }
	kTargetSpriteID = FourCharCode('spid'); { (QTAtomID spriteID) }
	kTargetSpriteIndex = FourCharCode('spin'); { (short spriteIndex) }
	kTargetQD3DNamedObjectName = FourCharCode('nana'); { (CString objectName) }
	kTargetCurrentQTEventParams = FourCharCode('evpa'); { no data }

{ action container atom types}
const
	kQTEventType = FourCharCode('evnt');
	kAction = FourCharCode('actn');
	kWhichAction = FourCharCode('whic');
	kActionParameter = FourCharCode('parm');
	kActionTarget = FourCharCode('targ');
	kActionFlags = FourCharCode('flag');
	kActionParameterMinValue = FourCharCode('minv');
	kActionParameterMaxValue = FourCharCode('maxv');
	kActionListAtomType = FourCharCode('list');
	kExpressionContainerAtomType = FourCharCode('expr');
	kConditionalAtomType = FourCharCode('test');
	kOperatorAtomType = FourCharCode('oper');
	kOperandAtomType = FourCharCode('oprn');
	kCommentAtomType = FourCharCode('why ');
	kCustomActionHandler = FourCharCode('cust');
	kCustomHandlerID = FourCharCode('id  ');
	kCustomHandlerDesc = FourCharCode('desc');
	kQTEventRecordAtomType = FourCharCode('erec');

{ QTEvent types }
const
	kQTEventMouseClick = FourCharCode('clik');
	kQTEventMouseClickEnd = FourCharCode('cend');
	kQTEventMouseClickEndTriggerButton = FourCharCode('trig');
	kQTEventMouseEnter = FourCharCode('entr');
	kQTEventMouseExit = FourCharCode('exit');
	kQTEventMouseMoved = FourCharCode('move');
	kQTEventFrameLoaded = FourCharCode('fram');
	kQTEventIdle = FourCharCode('idle');
	kQTEventKey = FourCharCode('key '); { qtevent.param1 = key, qtevent.param2 = modifiers, qtEvent.param3 = scanCode }
	kQTEventMovieLoaded = FourCharCode('load');
	kQTEventRequestToModifyMovie = FourCharCode('reqm');
	kQTEventListReceived = FourCharCode('list');
	kQTEventKeyUp = FourCharCode('keyU'); { qtevent.param1 = key, qtevent.param2 = modifiers, qtEvent.param3 = scanCode }

{ flags for the kActionFlags atom }
const
	kActionFlagActionIsDelta = 1 shl 1;
	kActionFlagParameterWrapsAround = 1 shl 2;
	kActionFlagActionIsToggle = 1 shl 3;

{ flags for stringTypeFlags field of the QTStatusStringRecord }
const
	kStatusStringIsURLLink = 1 shl 1;
	kStatusStringIsStreamingStatus = 1 shl 2;
	kStatusHasCodeNumber = 1 shl 3; { high 16 bits of stringTypeFlags is error code number}
	kStatusIsError = 1 shl 4;

{ flags for scriptTypeFlags field of the QTDoScriptRecord}
const
	kScriptIsUnknownType = 1 shl 0;
	kScriptIsJavaScript = 1 shl 1;
	kScriptIsLingoEvent = 1 shl 2;
	kScriptIsVBEvent = 1 shl 3;
	kScriptIsProjectorCommand = 1 shl 4;
	kScriptIsAppleScript = 1 shl 5;

{ flags for CheckQuickTimeRegistration routine}
const
	kQTRegistrationDialogTimeOutFlag = 1 shl 0;
	kQTRegistrationDialogShowDialog = 1 shl 1;
	kQTRegistrationDialogForceDialog = 1 shl 2;

{ constants for kOperatorAtomType IDs (operator types)}
const
	kOperatorAdd = FourCharCode('add ');
	kOperatorSubtract = FourCharCode('sub ');
	kOperatorMultiply = FourCharCode('mult');
	kOperatorDivide = FourCharCode('div ');
	kOperatorOr = FourCharCode('or  ');
	kOperatorAnd = FourCharCode('and ');
	kOperatorNot = FourCharCode('not ');
	kOperatorLessThan = FourCharCode('<   ');
	kOperatorLessThanEqualTo = FourCharCode('<=  ');
	kOperatorEqualTo = FourCharCode('=   ');
	kOperatorNotEqualTo = FourCharCode('!=  ');
	kOperatorGreaterThan = FourCharCode('>   ');
	kOperatorGreaterThanEqualTo = FourCharCode('>=  ');
	kOperatorModulo = FourCharCode('mod ');
	kOperatorIntegerDivide = FourCharCode('idiv');
	kOperatorAbsoluteValue = FourCharCode('abs ');
	kOperatorNegate = FourCharCode('neg ');

{ constants for kOperandPlatformRunningOn}
const
	kPlatformMacintosh = 1;
	kPlatformWindows = 2;

{ flags for kOperandSystemVersion}
const
	kSystemIsWindows9x = $00010000;
	kSystemIsWindowsNT = $00020000;
	kSystemIsClassicBlueBox = $00040000;

{ constants for MediaPropertiesAtom}
const
	kMediaPropertyNonLinearAtomType = FourCharCode('nonl');
	kMediaPropertyHasActions = 105;


{ TimeBase and TimeRecord moved to MacTypes.h }
type
	TimeBaseFlags = UInt32;
const
	loopTimeBase = 1;
	palindromeLoopTimeBase = 2;
	maintainTimeBaseZero = 4;

{ CallBack equates }
type
	QTCallBackFlags = UInt16;
const
	triggerTimeFwd = $0001; { when curTime exceeds triggerTime going forward }
	triggerTimeBwd = $0002; { when curTime exceeds triggerTime going backwards }
	triggerTimeEither = $0003; { when curTime exceeds triggerTime going either direction }
	triggerRateLT = $0004; { when rate changes to less than trigger value }
	triggerRateGT = $0008; { when rate changes to greater than trigger value }
	triggerRateEqual = $0010; { when rate changes to equal trigger value }
	triggerRateLTE = triggerRateLT or triggerRateEqual;
	triggerRateGTE = triggerRateGT or triggerRateEqual;
	triggerRateNotEqual = triggerRateGT or triggerRateEqual or triggerRateLT;
	triggerRateChange = 0;
	triggerAtStart = $0001;
	triggerAtStop = $0002;

type
	TimeBaseStatus = UInt32;
const
	timeBaseBeforeStartTime = 1;
	timeBaseAfterStopTime = 2;
	timeBaseRateChanging = 4;


type
	QTCallBackType = UInt16;
const
	callBackAtTime = 1;
	callBackAtRate = 2;
	callBackAtTimeJump = 3;
	callBackAtExtremes = 4;
	callBackAtTimeBaseDisposed = 5;
	callBackAtInterrupt = $8000;
	callBackAtDeferredTask = $4000;

type
	QTCallBack = ^QTCallBackOpaqueHeader;
	QTCallBackProcPtr = procedure( cb: QTCallBack; refCon: SIGNEDLONG );
	QTCallBackUPP = QTCallBackProcPtr;
	QTCallBackOpaqueHeaderPtr = ^QTCallBackOpaqueHeader;
	QTCallBackOpaqueHeader = record
		callBackFlags: SIGNEDLONG;
		reserved1: SIGNEDLONG;
		qtPrivate: array [0..51] of SInt8;
	end;

const
	qtcbNeedsRateChanges = 1;    { wants to know about rate changes }
	qtcbNeedsTimeChanges = 2;    { wants to know about time changes }
	qtcbNeedsStartStopChanges = 4;     { wants to know when TimeBase start/stop is changed}

type
	QTSyncTaskProcPtr = procedure( task: UnivPtr );
	QTSyncTaskUPP = QTSyncTaskProcPtr;
	QTSyncTaskRecordPtr = ^QTSyncTaskRecord;
	QTSyncTaskRecord = record
		qLink: UnivPtr;
		proc: QTSyncTaskUPP;
	end;
type
	QTSyncTaskPtr = QTSyncTaskRecordPtr;

type
	MovieRgnCoverProcPtr = function( theMovie: Movie; changedRgn: RgnHandle; refcon: SIGNEDLONG ): OSErr;
	MovieProgressProcPtr = function( theMovie: Movie; message: SInt16; whatOperation: SInt16; percentDone: Fixed; refcon: SIGNEDLONG ): OSErr;
	MovieDrawingCompleteProcPtr = function( theMovie: Movie; refCon: SIGNEDLONG ): OSErr;
	TrackTransferProcPtr = function( t: Track; refCon: SIGNEDLONG ): OSErr;
	GetMovieProcPtr = function( offset: SIGNEDLONG; size: SIGNEDLONG; dataPtr: UnivPtr; refCon: UnivPtr ): OSErr;
	MoviePreviewCallOutProcPtr = function( refcon: SIGNEDLONG ): Boolean;
	TextMediaProcPtr = function( theText: Handle; theMovie: Movie; var displayFlag: SInt16; refcon: SIGNEDLONG ): OSErr;
	ActionsProcPtr = function( refcon: UnivPtr; targetTrack: Track; targetRefCon: SIGNEDLONG; theEvent: QTEventRecordPtr ): OSErr;
	DoMCActionProcPtr = function( refcon: UnivPtr; action: SInt16; params: UnivPtr; var handled: Boolean ): OSErr;
	MovieExecuteWiredActionsProcPtr = function( theMovie: Movie; refcon: UnivPtr; flags: SIGNEDLONG; wiredActions: QTAtomContainer ): OSErr;
	MoviePrePrerollCompleteProcPtr = procedure( theMovie: Movie; prerollErr: OSErr; refcon: UnivPtr );
	QTNextTaskNeededSoonerCallbackProcPtr = procedure( duration: TimeValue; flags: UNSIGNEDLONG; refcon: UnivPtr );
	MoviesErrorProcPtr = procedure( theErr: OSErr; refcon: SIGNEDLONG );
	MovieRgnCoverUPP = MovieRgnCoverProcPtr;
	MovieProgressUPP = MovieProgressProcPtr;
	MovieDrawingCompleteUPP = MovieDrawingCompleteProcPtr;
	TrackTransferUPP = TrackTransferProcPtr;
	GetMovieUPP = GetMovieProcPtr;
	MoviePreviewCallOutUPP = MoviePreviewCallOutProcPtr;
	TextMediaUPP = TextMediaProcPtr;
	ActionsUPP = ActionsProcPtr;
	DoMCActionUPP = DoMCActionProcPtr;
	MovieExecuteWiredActionsUPP = MovieExecuteWiredActionsProcPtr;
	MoviePrePrerollCompleteUPP = MoviePrePrerollCompleteProcPtr;
	QTNextTaskNeededSoonerCallbackUPP = QTNextTaskNeededSoonerCallbackProcPtr;
	MoviesErrorUPP = MoviesErrorProcPtr;
	MediaHandler = ComponentInstance;
	DataHandler = ComponentInstance;
	MediaHandlerComponent = Component;
	DataHandlerComponent = Component;
	HandlerError = ComponentResult;
const
	keepInRam = 1 shl 0; { load and make non-purgable}
	unkeepInRam = 1 shl 1; { mark as purgable}
	flushFromRam = 1 shl 2; { empty those handles}
	loadForwardTrackEdits = 1 shl 3; {    load track edits into ram for playing forward}
	loadBackwardTrackEdits = 1 shl 4; {    load track edits into ram for playing in reverse}

const
	newMovieActive = 1 shl 0;
	newMovieDontResolveDataRefs = 1 shl 1;
	newMovieDontAskUnresolvedDataRefs = 1 shl 2;
	newMovieDontAutoAlternates = 1 shl 3;
	newMovieDontUpdateForeBackPointers = 1 shl 4;
	newMovieDontAutoUpdateClock = 1 shl 5;
	newMovieAsyncOK = 1 shl 8;
	newMovieIdleImportOK = 1 shl 10;
	newMovieDontInteractWithUser = 1 shl 11;

{ track usage bits }
const
	trackUsageInMovie = 1 shl 1;
	trackUsageInPreview = 1 shl 2;
	trackUsageInPoster = 1 shl 3;


{$endc} {not TARGET_CPU_64}

{ Add/GetMediaSample flags }
const
	mediaSampleNotSync = 1 shl 0; { sample is not a sync sample (eg. is frame differenced }
	mediaSampleShadowSync = 1 shl 1; { sample is a shadow sync }
	mediaSampleDroppable = 1 shl 27; { sample is not required to be decoded for later samples to be decoded properly }
	mediaSamplePartialSync = 1 shl 16; { sample is a partial sync (e.g., I frame after open GOP) }
	mediaSampleHasRedundantCoding = 1 shl 24; { sample is known to contain redundant coding }
	mediaSampleHasNoRedundantCoding = 1 shl 25; { sample is known not to contain redundant coding }
	mediaSampleIsDependedOnByOthers = 1 shl 26; { one or more other samples depend upon the decode of this sample }
	mediaSampleIsNotDependedOnByOthers = 1 shl 27; { synonym for mediaSampleDroppable }
	mediaSampleDependsOnOthers = 1 shl 28; { sample's decode depends upon decode of other samples }
	mediaSampleDoesNotDependOnOthers = 1 shl 29; { sample's decode does not depend upon decode of other samples }
	mediaSampleEarlierDisplayTimesAllowed = 1 shl 30; { samples later in decode order may have earlier display times }


{$ifc not TARGET_CPU_64}

{
MediaSampleFlags is defined in ImageCompression.h:
typedef UInt32 MediaSampleFlags;
}
const
	pasteInParallel = 1 shl 0;
	showUserSettingsDialog = 1 shl 1;
	movieToFileOnlyExport = 1 shl 2;
	movieFileSpecValid = 1 shl 3;

const
	nextTimeMediaSample = 1 shl 0;
	nextTimeMediaEdit = 1 shl 1;
	nextTimeTrackEdit = 1 shl 2;
	nextTimeSyncSample = 1 shl 3;
	nextTimeStep = 1 shl 4;
	nextTimePartialSyncSample = 1 shl 5;
	nextTimeEdgeOK = 1 shl 14;
	nextTimeIgnoreActiveSegment = 1 shl 15;

type
	nextTimeFlagsEnum = UInt16;
const
	createMovieFileDeleteCurFile = 1 shl 31;
	createMovieFileDontCreateMovie = 1 shl 30;
	createMovieFileDontOpenFile = 1 shl 29;
	createMovieFileDontCreateResFile = 1 shl 28;

type
	createMovieFileFlagsEnum = UNSIGNEDLONG;
const
	flattenAddMovieToDataFork = 1 shl 0;
	flattenActiveTracksOnly = 1 shl 2;
	flattenDontInterleaveFlatten = 1 shl 3;
	flattenFSSpecPtrIsDataRefRecordPtr = 1 shl 4;
	flattenCompressMovieResource = 1 shl 5;
	flattenForceMovieResourceBeforeMovieData = 1 shl 6;

type
	movieFlattenFlagsEnum = UNSIGNEDLONG;
const
	movieInDataForkResID = -1;    { magic res ID }

const
	mcTopLeftMovie = 1 shl 0; { usually centered }
	mcScaleMovieToFit = 1 shl 1; { usually only scales down }
	mcWithBadge = 1 shl 2; { give me a badge }
	mcNotVisible = 1 shl 3; { don't show controller }
	mcWithFrame = 1 shl 4; { gimme a frame }

const
	movieScrapDontZeroScrap = 1 shl 0;
	movieScrapOnlyPutMovie = 1 shl 1;

const
	dataRefSelfReference = 1 shl 0;
	dataRefWasNotResolved = 1 shl 1;

type
	dataRefAttributesFlags = UNSIGNEDLONG;
const
	kMovieAnchorDataRefIsDefault = 1 shl 0; { data ref returned is movie default data ref }

const
	hintsScrubMode = 1 shl 0; { mask == && (if flags == scrub on, flags != scrub off) }
	hintsLoop = 1 shl 1;
	hintsDontPurge = 1 shl 2;
	hintsUseScreenBuffer = 1 shl 5;
	hintsAllowInterlace = 1 shl 6;
	hintsUseSoundInterp = 1 shl 7;
	hintsHighQuality = 1 shl 8; { slooooow }
	hintsPalindrome = 1 shl 9;
	hintsInactive = 1 shl 11;
	hintsOffscreen = 1 shl 12;
	hintsDontDraw = 1 shl 13;
	hintsAllowBlacklining = 1 shl 14;
	hintsDontUseVideoOverlaySurface = 1 shl 16;
	hintsIgnoreBandwidthRestrictions = 1 shl 17;
	hintsPlayingEveryFrame = 1 shl 18;
	hintsAllowDynamicResize = 1 shl 19;
	hintsSingleField = 1 shl 20;
	hintsNoRenderingTimeOut = 1 shl 21;
	hintsFlushVideoInsteadOfDirtying = 1 shl 22;
	hintsEnableSubPixelPositioning = 1 shl 23;
	hintsRenderingMode = 1 shl 24;
	hintsAllowIdleSleep = 1 shl 25; { asks media handlers not to call UpdateSystemActivity etc }
	hintsDeinterlaceFields = 1 shl 26;

type
	playHintsEnum = UNSIGNEDLONG;
const
	mediaHandlerFlagBaseClient = 1;

type
	mediaHandlerFlagsEnum = UNSIGNEDLONG;
const
	movieTrackMediaType = 1 shl 0;
	movieTrackCharacteristic = 1 shl 1;
	movieTrackEnabledOnly = 1 shl 2;

{
   Opaque replacement for SampleReferenceRecord/SampleReference64Record arrays able to carry information
   not described in those arrays of those records
}
type
	QTSampleTableRef = ^SInt32; { an opaque type }
	QTMutableSampleTableRef = ^SInt32; { an opaque type }
	SampleReferenceRecordPtr = ^SampleReferenceRecord;
	SampleReferenceRecord = record
		dataOffset: SIGNEDLONG;
		dataSize: SIGNEDLONG;
		durationPerSample: TimeValue;
		numberOfSamples: SIGNEDLONG;
		sampleFlags: SInt16;
	end;
type
	SampleReferencePtr = SampleReferenceRecordPtr;
	SampleReference64RecordPtr = ^SampleReference64Record;
	SampleReference64Record = record
		dataOffset: wide;
		dataSize: UNSIGNEDLONG;
		durationPerSample: TimeValue;
		numberOfSamples: UNSIGNEDLONG;
		sampleFlags: SInt16;
	end;
type
	SampleReference64Ptr = SampleReference64RecordPtr;

{************************
* Initialization Routines 
*************************}
{
 *  CheckQuickTimeRegistration()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure CheckQuickTimeRegistration( registrationKey: UnivPtr; flags: SIGNEDLONG ); external name '_CheckQuickTimeRegistration';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  EnterMovies()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function EnterMovies: OSErr; external name '_EnterMovies';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ExitMovies()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure ExitMovies; external name '_ExitMovies';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	kQTEnterMoviesFlagDontSetComponentsThreadMode = 1 shl 0;

{
 *  EnterMoviesOnThread()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function EnterMoviesOnThread( inFlags: UInt32 ): OSErr; external name '_EnterMoviesOnThread';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  ExitMoviesOnThread()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function ExitMoviesOnThread: OSErr; external name '_ExitMoviesOnThread';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{************************
* Error Routines 
*************************}

{
 *  GetMoviesError()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMoviesError: OSErr; external name '_GetMoviesError';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClearMoviesStickyError()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure ClearMoviesStickyError; external name '_ClearMoviesStickyError';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMoviesStickyError()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMoviesStickyError: OSErr; external name '_GetMoviesStickyError';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMoviesErrorProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMoviesErrorProc( errProc: MoviesErrorUPP; refcon: SIGNEDLONG ); external name '_SetMoviesErrorProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Idle Routines 
*************************}
{
 *  MoviesTask()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure MoviesTask( theMovie: Movie; maxMilliSecToUse: SIGNEDLONG ); external name '_MoviesTask';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PrerollMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PrerollMovie( theMovie: Movie; time: TimeValue; Rate: Fixed ): OSErr; external name '_PrerollMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PrePrerollMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function PrePrerollMovie( m: Movie; time: TimeValue; rate: Fixed; proc: MoviePrePrerollCompleteUPP; refcon: UnivPtr ): OSErr; external name '_PrePrerollMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AbortPrePrerollMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
procedure AbortPrePrerollMovie( m: Movie; err: OSErr ); external name '_AbortPrePrerollMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  LoadMovieIntoRam()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function LoadMovieIntoRam( theMovie: Movie; time: TimeValue; duration: TimeValue; flags: SIGNEDLONG ): OSErr; external name '_LoadMovieIntoRam';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  LoadTrackIntoRam()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function LoadTrackIntoRam( theTrack: Track; time: TimeValue; duration: TimeValue; flags: SIGNEDLONG ): OSErr; external name '_LoadTrackIntoRam';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  LoadMediaIntoRam()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function LoadMediaIntoRam( theMedia: Media; time: TimeValue; duration: TimeValue; flags: SIGNEDLONG ): OSErr; external name '_LoadMediaIntoRam';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieActive()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieActive( theMovie: Movie; active: Boolean ); external name '_SetMovieActive';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieActive()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieActive( theMovie: Movie ): Boolean; external name '_GetMovieActive';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetWallClockTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTGetWallClockTimeBase( var wallClockTimeBase: TimeBase ): OSErr; external name '_QTGetWallClockTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{************************
* Idle Management
*************************}
type
	IdleManager = ^OpaqueIdleManager; { an opaque type }
	OpaqueIdleManager = record end;
{
 *  QTIdleManagerOpen()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTIdleManagerOpen: IdleManager; external name '_QTIdleManagerOpen';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTIdleManagerClose()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTIdleManagerClose( im: IdleManager ): OSErr; external name '_QTIdleManagerClose';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTIdleManagerGetNextIdleTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTIdleManagerGetNextIdleTime( im: IdleManager; var nextIdle: TimeRecord ): OSErr; external name '_QTIdleManagerGetNextIdleTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTIdleManagerSetNextIdleTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTIdleManagerSetNextIdleTime( im: IdleManager; var nextIdle: TimeRecord ): OSErr; external name '_QTIdleManagerSetNextIdleTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTIdleManagerSetNextIdleTimeNever()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTIdleManagerSetNextIdleTimeNever( im: IdleManager ): OSErr; external name '_QTIdleManagerSetNextIdleTimeNever';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTIdleManagerSetNextIdleTimeNow()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTIdleManagerSetNextIdleTimeNow( im: IdleManager ): OSErr; external name '_QTIdleManagerSetNextIdleTimeNow';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTIdleManagerSetNextIdleTimeDelta()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTIdleManagerSetNextIdleTimeDelta( im: IdleManager; duration: TimeValue; scale: TimeScale ): OSErr; external name '_QTIdleManagerSetNextIdleTimeDelta';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTIdleManagerSetParent()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTIdleManagerSetParent( im: IdleManager; parent: IdleManager ): OSErr; external name '_QTIdleManagerSetParent';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTIdleManagerNeedsAnIdle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTIdleManagerNeedsAnIdle( im: IdleManager; var needsOne: Boolean ): OSErr; external name '_QTIdleManagerNeedsAnIdle';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{************************
* Carbon Movie Control
*************************}
{ Movie Control option bits}
const
	kMovieControlOptionHideController = 1 shl 0;
	kMovieControlOptionLocateTopLeft = 1 shl 1;
	kMovieControlOptionEnableEditing = 1 shl 2;
	kMovieControlOptionHandleEditingHI = 1 shl 3;
	kMovieControlOptionSetKeysEnabled = 1 shl 4;
	kMovieControlOptionManuallyIdled = 1 shl 5;

{ Item tags for use in GetControlData() (some with SetControlData()) calls on Movie Controls}
const
	kMovieControlDataMovieController = FourCharCode('mc  ');
	kMovieControlDataMovie = FourCharCode('moov');
	kMovieControlDataManualIdling = FourCharCode('manu');

{
** CreateMovieControl() -   This is the public API routine that creates a Movie Control. Given a window and location
**                          plus a movie, it constructs a Movie Control with a Movie Controller in the window.
}
{
 *  CreateMovieControl()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   not available
 }
function CreateMovieControl( theWindow: WindowRef; var localRect: Rect; theMovie: Movie; options: UInt32; var returnedControl: ControlRef ): OSErr; external name '_CreateMovieControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{************************
* calls for playing movies, previews, posters
*************************}
{
 *  StartMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure StartMovie( theMovie: Movie ); external name '_StartMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  StopMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure StopMovie( theMovie: Movie ); external name '_StopMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GoToBeginningOfMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GoToBeginningOfMovie( theMovie: Movie ); external name '_GoToBeginningOfMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GoToEndOfMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GoToEndOfMovie( theMovie: Movie ); external name '_GoToEndOfMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  IsMovieDone()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function IsMovieDone( theMovie: Movie ): Boolean; external name '_IsMovieDone';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMoviePreviewMode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMoviePreviewMode( theMovie: Movie ): Boolean; external name '_GetMoviePreviewMode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMoviePreviewMode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMoviePreviewMode( theMovie: Movie; usePreview: Boolean ); external name '_SetMoviePreviewMode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ShowMoviePoster()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure ShowMoviePoster( theMovie: Movie ); external name '_ShowMoviePoster';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PlayMoviePreview()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure PlayMoviePreview( theMovie: Movie; callOutProc: MoviePreviewCallOutUPP; refcon: SIGNEDLONG ); external name '_PlayMoviePreview';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* calls for controlling movies & tracks which are playing
*************************}
{
 *  GetMovieTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieTimeBase( theMovie: Movie ): TimeBase; external name '_GetMovieTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieMasterTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieMasterTimeBase( theMovie: Movie; tb: TimeBase; const (*var*) slaveZero: TimeRecord ); external name '_SetMovieMasterTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieMasterClock()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieMasterClock( theMovie: Movie; clockMeister: Component; const (*var*) slaveZero: TimeRecord ); external name '_SetMovieMasterClock';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ChooseMovieClock()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
procedure ChooseMovieClock( m: Movie; flags: SIGNEDLONG ); external name '_ChooseMovieClock';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  GetMovieGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetMovieGWorld( theMovie: Movie; var port: CGrafPtr; var gdh: GDHandle ); external name '_GetMovieGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieGWorld( theMovie: Movie; port: CGrafPtr; gdh: GDHandle ); external name '_SetMovieGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	movieDrawingCallWhenChanged = 0;
	movieDrawingCallAlways = 1;

{
 *  SetMovieDrawingCompleteProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieDrawingCompleteProc( theMovie: Movie; flags: SIGNEDLONG; proc: MovieDrawingCompleteUPP; refCon: SIGNEDLONG ); external name '_SetMovieDrawingCompleteProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieNaturalBoundsRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetMovieNaturalBoundsRect( theMovie: Movie; var naturalBounds: Rect ); external name '_GetMovieNaturalBoundsRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetNextTrackForCompositing()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetNextTrackForCompositing( theMovie: Movie; theTrack: Track ): Track; external name '_GetNextTrackForCompositing';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetPrevTrackForCompositing()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetPrevTrackForCompositing( theMovie: Movie; theTrack: Track ): Track; external name '_GetPrevTrackForCompositing';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTrackGWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTrackGWorld( theTrack: Track; port: CGrafPtr; gdh: GDHandle; proc: TrackTransferUPP; refCon: SIGNEDLONG ); external name '_SetTrackGWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMoviePict()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMoviePict( theMovie: Movie; time: TimeValue ): PicHandle; external name '_GetMoviePict';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackPict()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackPict( theTrack: Track; time: TimeValue ): PicHandle; external name '_GetTrackPict';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMoviePosterPict()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMoviePosterPict( theMovie: Movie ): PicHandle; external name '_GetMoviePosterPict';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ called between Begin & EndUpdate }
{
 *  UpdateMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function UpdateMovie( theMovie: Movie ): OSErr; external name '_UpdateMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  InvalidateMovieRegion()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function InvalidateMovieRegion( theMovie: Movie; invalidRgn: RgnHandle ): OSErr; external name '_InvalidateMovieRegion';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{*** spatial movie routines ***}
{
 *  GetMovieBox()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetMovieBox( theMovie: Movie; var boxRect: Rect ); external name '_GetMovieBox';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieBox()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieBox( theMovie: Movie; const (*var*) boxRect: Rect ); external name '_SetMovieBox';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{* movie display clip }
{
 *  GetMovieDisplayClipRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieDisplayClipRgn( theMovie: Movie ): RgnHandle; external name '_GetMovieDisplayClipRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieDisplayClipRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieDisplayClipRgn( theMovie: Movie; theClip: RgnHandle ); external name '_SetMovieDisplayClipRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{* movie src clip }
{
 *  GetMovieClipRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieClipRgn( theMovie: Movie ): RgnHandle; external name '_GetMovieClipRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieClipRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieClipRgn( theMovie: Movie; theClip: RgnHandle ); external name '_SetMovieClipRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{* track src clip }
{
 *  GetTrackClipRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackClipRgn( theTrack: Track ): RgnHandle; external name '_GetTrackClipRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTrackClipRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTrackClipRgn( theTrack: Track; theClip: RgnHandle ); external name '_SetTrackClipRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{* bounds in display space (not clipped by display clip) }
{
 *  GetMovieDisplayBoundsRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieDisplayBoundsRgn( theMovie: Movie ): RgnHandle; external name '_GetMovieDisplayBoundsRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackDisplayBoundsRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackDisplayBoundsRgn( theTrack: Track ): RgnHandle; external name '_GetTrackDisplayBoundsRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{* bounds in movie space }
{
 *  GetMovieBoundsRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieBoundsRgn( theMovie: Movie ): RgnHandle; external name '_GetMovieBoundsRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackMovieBoundsRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackMovieBoundsRgn( theTrack: Track ): RgnHandle; external name '_GetTrackMovieBoundsRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{* bounds in track space }
{
 *  GetTrackBoundsRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackBoundsRgn( theTrack: Track ): RgnHandle; external name '_GetTrackBoundsRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{* mattes - always in track space }
{
 *  GetTrackMatte()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackMatte( theTrack: Track ): PixMapHandle; external name '_GetTrackMatte';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTrackMatte()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTrackMatte( theTrack: Track; theMatte: PixMapHandle ); external name '_SetTrackMatte';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeMatte()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure DisposeMatte( theMatte: PixMapHandle ); external name '_DisposeMatte';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{* video out }
{
 *  SetMovieVideoOutput()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
procedure SetMovieVideoOutput( theMovie: Movie; vout: ComponentInstance ); external name '_SetMovieVideoOutput';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
 * Audio Context
 ************************}
{
   The QTAudioContextRef type encapsulates a connection to an audio output device.
   It represents a destination audio rendering environment that can be used for
   playback of a movie.
}
type
	QTAudioContextRef = ^OpaqueQTAudioContextRef; { an opaque type }
	OpaqueQTAudioContextRef = record end;
{
 *  QTAudioContextRetain()
 *  
 *  Summary:
 *    Retains a QTAudioContext object by incrementing its reference
 *    count. You should retain the object when you receive it from
 *    elsewhere (that is, you did not create it) and you want it to
 *    persist. If you retain a QTAudioContext object you are
 *    responsible for releasing it. The same audio context is returned
 *    for convenience. If audioContext is NULL, nothing happens.
 *  
 *  Parameters:
 *    
 *    audioContext:
 *      [in] The audio context to retain.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTAudioContextRetain( audioContext: QTAudioContextRef ): QTAudioContextRef; external name '_QTAudioContextRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTAudioContextRelease()
 *  
 *  Summary:
 *    Release a QTAudioContext object by decrementing its reference
 *    count. If that count consequently becomes zero the memory
 *    allocated to the object is deallocated and the object is
 *    destroyed. If you create or explicitly retain a QTAudioContext
 *    object, you are responsible for releasing it when you no longer
 *    need it. If audioContext is NULL, nothing happens.
 *  
 *  Parameters:
 *    
 *    audioContext:
 *      [in] The audio context to release.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure QTAudioContextRelease( audioContext: QTAudioContextRef ); external name '_QTAudioContextRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTAudioContextCreateForAudioDevice()
 *  
 *  Summary:
 *    Creates a QTAudioContext object that encapsulates a connection to
 *    an audio output device. This object is suitable for passing to
 *    SetMovieAudioContext or NewMovieFromProperties, which targets the
 *    audio output of the movie to that device. A QTAudioContext object
 *    cannot be associated with more than one movie. Each movie needs
 *    its own connection to the device. In order to play more than one
 *    movie to a particular device, create a QTAudioContext object for
 *    each movie. You are responsible for releasing the QTAudioContext
 *    object created by this routine. After calling
 *    SetMovieAudioContext or NewMovieFromProperties, you can release
 *    the object since these APIs will retain it for their own use. On
 *    Windows, the audioDeviceUID is the GUID of a DirectSound device,
 *    stringified using such Win32 functions as StringFromCLSID() or
 *    StringFromGUID2(), then wrapped in a CFStringRef using
 *    CFStringCreateWithCharacters().  After passing the audioDeviceUID
 *    CFStringRef to QTAudioContextCreateForAudioDevice(), remember to
 *    CFRelease() the CFStringRef you created.
 *  
 *  Parameters:
 *    
 *    allocator:
 *      [in]  Allocator used to create the audio context.
 *    
 *    audioDeviceUID:
 *      [in]  Audio device UID.  NULL means the default CoreAudio
 *      device.
 *    
 *    options:
 *      [in]  Reserved.  Pass NULL.
 *    
 *    newAudioContextOut:
 *      [out] Points to a variable to receive the new audio context.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTAudioContextCreateForAudioDevice( allocator: CFAllocatorRef; audioDeviceUID: CFStringRef; options: CFDictionaryRef; var newAudioContextOut: QTAudioContextRef ): OSStatus; external name '_QTAudioContextCreateForAudioDevice';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{************************
 * Audio Context Inserts
 ************************}
{
   Theory of operations:
    To register for a Movie Audio Context Insert during playback:
        1) Get the movie's current audio context: GetMovieAudioContext()
        2) Register the application insert: QTAudioContextRegisterInsert()
    To unregister a Movie Audio Context Insert:
        Call QTAudioContextRegisterInsert() with a NULL QTAudioContextInsertRegistryInfoRef
           If the registry ptr is non-NULL but the processDataCallback is NULL, this has the same effect.
    To register for a Track Audio Context Insert during playback:
        Set the kQTAudioPropertyID_RegisterAudioContextInsert property on the track,
            providing the same registry info structure that is used for the QTAudioContextRegisterInsert() call.
    To unregister a Track Audio Context Insert:
        Set the kQTAudioPropertyID_RegisterAudioContextInsert property on the track,
            with a NULL processDataCallback
}


{
 *  AudioContextInsertProcessDataCallback
 *  
 *  Summary:
 *    A client-supplied function to be called during playback to get
 *    data from the audio insert.
 *  
 *  Discussion:
 *    This routine is called by the Audio Context for each buffer of
 *    audio data it renders. The client receives a source buffer list
 *    and a destination buffer list, and it is responsible for
 *    supplying output buffers to the destination buffer list. This
 *    routine is generally called on the IOProc at high thread
 *    priority, and so should not do memory allocation or release,
 *    acquire mutex resources, nor take very long to process.
 *  
 *  Parameters:
 *    
 *    inUserData:
 *      An opaque pointer to the client's data.
 *    
 *    ioRenderFlags:
 *      A field that contains render action flags (see AUComponent.h).
 *    
 *    inTimeStamp:
 *      An AudioTimeStamp that indicates the start time of the buffer
 *      to be processed. During normal playback or audio extraction,
 *      the timestamp mSampleTime is normalized to the movie time that
 *      this particular input sample buffer represents, expressed in
 *      the sample rate being processed. During reverse playback, the
 *      first Process Data call after Reset will contain a timestamp
 *      designating the movie time, but subsequent timestamps will
 *      advance forward instead of in reverse.
 *    
 *    inNumberFrames:
 *      A UInt32 that specifies the number of frames to be rendered.
 *    
 *    inInputData:
 *      An AudioBufferList used to pass input data to the insert.
 *    
 *    outOutputData:
 *      An AudioBufferList to receive the processed data that is
 *      produced by the insert. QuickTime sets buffer pointers in the
 *      list to NULL. The client must set the buffer pointers to refer
 *      to either its own allocated buffers or to be copies of the
 *      buffer pointers received in inInputData.
 }
type
	AudioContextInsertProcessDataCallback = function( inUserData: UnivPtr; var ioRenderFlags: AudioUnitRenderActionFlags; const (*var*) inTimeStamp: AudioTimeStamp; inNumberFrames: UInt32; var inInputData: AudioBufferList; var outOutputData: AudioBufferList ): OSStatus;

{
 *  AudioContextInsertResetCallback
 *  
 *  Summary:
 *    A client-supplied function to be called to initialize and reset
 *    for processing data.
 *  
 *  Discussion:
 *    This routine is called by the Audio Context to initialize for
 *    rendering. The client is told the sample rate and the maximum
 *    number of frames it will be asked to process on any single
 *    ProcessData callback (ie, inNumberFrames will always be <=
 *    inMaxFrames). On return, the client reports its processing
 *    latency and tail times. This callback is invoked whenever the
 *    rendering chain is interrupted (eg, when playback jumps to a new
 *    point or changes direction). The client should call
 *    AudioUnitReset on any audio units in use, and should be prepared
 *    to respond to changes of sample rate or maxframes.
 *  
 *  Parameters:
 *    
 *    inUserData:
 *      An opaque pointer to the client's data.
 *    
 *    inSampleRate:
 *      A Float64 that will specifies the sample rate of the data to be
 *      processed.
 *    
 *    inMaxFrames:
 *      A UInt32 that specifies the maximum number of maximum frame
 *      count that will be processed in a single call.
 *    
 *    outLatency:
 *      A pointer to a Float64 that specifies the insert's render
 *      latency, in seconds. Latency data will be pulled and discarded
 *      by QuickTime after each reset.
 *    
 *    outTailTime:
 *      A pointer to a Float64 that specifies the insert's tail render
 *      time, in seconds.
 }
type
	AudioContextInsertResetCallback = function( inUserData: UnivPtr; inSampleRate: Float64; inMaxFrames: UInt32; var outLatency: Float64; var outTailTime: Float64 ): OSStatus;

{
 *  AudioContextInsertFinalizeCallback
 *  
 *  Summary:
 *    A client-supplied function to be called to release any resources
 *    in use by the insert.
 *  
 *  Discussion:
 *    This routine is called when the Audio Context is being disposed
 *    (ie, the MovieAudioContext has been reset or the movie was
 *    disposed). Once this callback returns, no more calls for this
 *    registered insert will be made.
 *  
 *  Parameters:
 *    
 *    inUserData:
 *      An opaque pointer to the client's data.
 }
type
	AudioContextInsertFinalizeCallback = function( inUserData: UnivPtr ): OSStatus;

{
 *  QTAudioContextInsertRegistryInfo
 *  
 *  Summary:
 *    Parameters for registering an Audio Context insert
 *  
 *  Discussion:
 *    This is used with QTAudioContextRegisterInsert() and the Movie
 *    Audio Extraction
 *    kQTMovieAudioExtractionAudioPropertyID_RegisterMovieInsert
 *    property.
 }
type
	QTAudioContextInsertRegistryInfoPtr = ^QTAudioContextInsertRegistryInfo;
	QTAudioContextInsertRegistryInfo = record
{
   * client user data to be passed to all client-specified callbacks.
   }
		userData: UnivPtr;

  {
   * The size of the input channel layout structure.
   }
		inputChannelLayoutSize: UInt32;

  {
   * An AudioChannelLayout that describes the channel layout (and,
   * implicitly, channel valence) of the data that the insert expects
   * as input.
   }
		inputChannelLayout: AudioChannelLayoutPtr;

  {
   * The size of the output channel layout structure.
   }
		outputChannelLayoutSize: UInt32;

  {
   * An AudioChannelLayout that describes the channel layout (and,
   * implicitly, channel valence) of the processed data that the insert
   * will output.
   }
		outputChannelLayout: AudioChannelLayoutPtr;

  {
   * Client-specified process data callback.
   }
		processDataCallback: AudioContextInsertProcessDataCallback;

  {
   * Client-specified reset callback.
   }
		resetCallback: AudioContextInsertResetCallback;

  {
   * Client-specified finalize callback (may be NULL). NOTE: Calls to
   * the client callbacks are interlocked with respect to each other:
   * there will never be simultaneous calls, with an identical
   * inUserData, on different threads.
   }
		finalizeCallback: AudioContextInsertFinalizeCallback;
	end;
type
	QTAudioContextInsertRegistryInfoRef = QTAudioContextInsertRegistryInfoPtr;
{
 *  QTAudioContextRegisterInsert()
 *  
 *  Summary:
 *    Register an audio insert with QuickTime
 *  
 *  Discussion:
 *    This routine is called to register an application to tap into the
 *    audio playback stream, via callbacks during audio rendering. The
 *    inAudioContext parameter refers to a Movie Audio Context that has
 *    not yet been associated with a movie. Once the application has
 *    successfully registered its insert, it may associate a movie with
 *    this Audio Context by calling SetMovieAudioContext(). The
 *    application must then be prepared to handle callbacks, which may
 *    be executed on different threads, until the Finalize callback
 *    with a matching userData parameter, is received. The application
 *    may supply a NULL Finalize callback if it has its own logic for
 *    detecting when it may release its insert resources.
 *  
 *  Parameters:
 *    
 *    inAudioContext:
 *      A QTAudioContextRef that specifies the Audio Context to tap
 *      into.
 *    
 *    inRegistryInfoSize:
 *      Size, in bytes, of the supplied
 *      QTAudioContextInsertRegistryInfo structure.
 *    
 *    inRegistryInfo:
 *      Pointer to a QTAudioContextInsertRegistryInfo structure
 *      containing setup parameters for the Audio Context insert and
 *      callbacks.
 *  
 *  Result:
 *    readErr Cannot register an insert on a movie containing protected
 *    data.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.2) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTAudioContextRegisterInsert( inAudioContext: QTAudioContextRef; inRegistryInfoSize: UInt32; inRegistryInfo: QTAudioContextInsertRegistryInfoRef ): OSStatus; external name '_QTAudioContextRegisterInsert';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{ Track-level Audio Context Insert property (kQTPropertyClass_Audio)}

const
{
   * kQTAudioPropertyID_RegisterAudioContextInsert: Value is
   * QTAudioContextInsertRegistryInfoRef  (Get/Set) Set on a Track to
   * register/unregister an Audio Context Insert for that specific
   * track.    When this property is read back (QTGetTrackProperty) the
   * channel layout pointers will will be NULL.  To unregister, supply
   * a NULL processDataCallback (in which case the rest of the registry
   * info will be ignored).
   }
	kQTAudioPropertyID_RegisterAudioContextInsert = FourCharCode('regt'); { value is QTAudioContextInsertRegistryInfoRef. Get/Set.}


{*****************************************
 * Using Audio/Visual contexts with movies
 ****************************************}
{
 *  SetMovieVisualContext()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetMovieVisualContext( movie_: Movie; visualContext: QTVisualContextRef ): OSStatus; external name '_SetMovieVisualContext';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMovieVisualContext()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieVisualContext( movie_: Movie; var visualContext: QTVisualContextRef ): OSStatus; external name '_GetMovieVisualContext';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  SetMovieAudioContext()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetMovieAudioContext( movie_: Movie; audioContext: QTAudioContextRef ): OSStatus; external name '_SetMovieAudioContext';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMovieAudioContext()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieAudioContext( movie_: Movie; var audioContext: QTAudioContextRef ): OSStatus; external name '_GetMovieAudioContext';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{************************
* calls for getting/saving movies
*************************}
{* Properties for NewMovieFromProperties }
const
	kQTPropertyClass_DataLocation = FourCharCode('dloc');
	kQTDataLocationPropertyID_DataReference = FourCharCode('dref'); { DataReferenceRecord (for semantics of NewMovieFromDataRef)}
	kQTDataLocationPropertyID_CFStringNativePath = FourCharCode('cfnp');
	kQTDataLocationPropertyID_CFStringPosixPath = FourCharCode('cfpp');
	kQTDataLocationPropertyID_CFStringHFSPath = FourCharCode('cfhp');
	kQTDataLocationPropertyID_CFStringWindowsPath = FourCharCode('cfwp');
	kQTDataLocationPropertyID_CFURL = FourCharCode('cfur');
	kQTDataLocationPropertyID_QTDataHandler = FourCharCode('qtdh'); { for semantics of NewMovieFromStorageOffset}
	kQTDataLocationPropertyID_Scrap = FourCharCode('scrp');
	kQTDataLocationPropertyID_LegacyMovieResourceHandle = FourCharCode('rezh'); { QTNewMovieUserProcInfo * (for semantics of NewMovieFromHandle)}
	kQTDataLocationPropertyID_MovieUserProc = FourCharCode('uspr'); { for semantics of NewMovieFromUserProc}
	kQTDataLocationPropertyID_ResourceFork = FourCharCode('rfrk'); { for semantics of NewMovieFromFile}
	kQTDataLocationPropertyID_DataFork = FourCharCode('dfrk'); { for semantics of NewMovieFromDataFork64}
	kQTPropertyClass_Context = FourCharCode('ctxt'); { Media Contexts}
	kQTContextPropertyID_AudioContext = FourCharCode('audi');
	kQTContextPropertyID_VisualContext = FourCharCode('visu');
	kQTPropertyClass_MovieResourceLocator = FourCharCode('rloc');
	kQTMovieResourceLocatorPropertyID_LegacyResID = FourCharCode('rezi'); { (input/result property)}
	kQTMovieResourceLocatorPropertyID_LegacyResName = FourCharCode('rezn'); { (result property)}
	kQTMovieResourceLocatorPropertyID_FileOffset = FourCharCode('foff'); { NewMovieFromDataFork[64]}
	kQTMovieResourceLocatorPropertyID_Callback = FourCharCode('calb'); { NewMovieFromUserProc(getProc,refcon)}
                                        { Uses kQTMovieDefaultDataRefPropertyID for default dataref}
	kQTPropertyClass_MovieInstantiation = FourCharCode('mins');
	kQTMovieInstantiationPropertyID_DontResolveDataRefs = FourCharCode('rdrn');
	kQTMovieInstantiationPropertyID_DontAskUnresolvedDataRefs = FourCharCode('aurn');
	kQTMovieInstantiationPropertyID_DontAutoAlternates = FourCharCode('aaln');
	kQTMovieInstantiationPropertyID_DontUpdateForeBackPointers = FourCharCode('fbpn');
	kQTMovieInstantiationPropertyID_AsyncOK = FourCharCode('asok');
	kQTMovieInstantiationPropertyID_IdleImportOK = FourCharCode('imok');
	kQTMovieInstantiationPropertyID_DontAutoUpdateClock = FourCharCode('aucl');
	kQTMovieInstantiationPropertyID_ResultDataLocationChanged = FourCharCode('dlch'); { (result property)}
	kQTMovieInstantiationPropertyID_AllowMediaOptimization = FourCharCode('amop');
	kQTPropertyClass_NewMovieProperty = FourCharCode('mprp');
	kQTNewMoviePropertyID_DefaultDataRef = FourCharCode('ddrf'); { DataReferenceRecord}
	kQTNewMoviePropertyID_Active = FourCharCode('actv');
	kQTNewMoviePropertyID_DontInteractWithUser = FourCharCode('intn');


{* Property value for kQTDataLocationPropertyID_MovieUserProc }
type
	QTNewMovieUserProcRecord = record
		getMovieUserProc: GetMovieUPP;
		getMovieUserProcRefcon: UnivPtr;
		defaultDataRef: DataReferenceRecord;
	end;
{* Property structure for NewMovieFromProperties }
type
	QTNewMoviePropertyElement = record
		propClass: QTPropertyClass;
		propID: QTPropertyID;
		propValueSize: ByteCount;
		propValueAddress: QTPropertyValuePtr;
		propStatus: OSStatus;
	end;
{
 *  NewMovieFromProperties()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function NewMovieFromProperties( inputPropertyCount: ItemCount; var inputProperties: QTNewMoviePropertyElement; outputPropertyCount: ItemCount; var outputProperties: QTNewMoviePropertyElement; var theMovie: Movie ): OSStatus; external name '_NewMovieFromProperties';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  NewMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewMovie( flags: SIGNEDLONG ): Movie; external name '_NewMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PutMovieIntoHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PutMovieIntoHandle( theMovie: Movie; publicMovie: Handle ): OSErr; external name '_PutMovieIntoHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PutMovieIntoDataFork()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PutMovieIntoDataFork( theMovie: Movie; fRefNum: SInt16; offset: SIGNEDLONG; maxSize: SIGNEDLONG ): OSErr; external name '_PutMovieIntoDataFork';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PutMovieIntoDataFork64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function PutMovieIntoDataFork64( theMovie: Movie; fRefNum: SIGNEDLONG; const (*var*) offset: wide; maxSize: UNSIGNEDLONG ): OSErr; external name '_PutMovieIntoDataFork64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PutMovieIntoStorage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function PutMovieIntoStorage( theMovie: Movie; dh: DataHandler; const (*var*) offset: wide; maxSize: UNSIGNEDLONG ): OSErr; external name '_PutMovieIntoStorage';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  PutMovieForDataRefIntoHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function PutMovieForDataRefIntoHandle( theMovie: Movie; dataRef: Handle; dataRefType: OSType; publicMovie: Handle ): OSErr; external name '_PutMovieForDataRefIntoHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  DisposeMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure DisposeMovie( theMovie: Movie ); external name '_DisposeMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Movie State Routines
*************************}
{
 *  GetMovieCreationTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieCreationTime( theMovie: Movie ): UNSIGNEDLONG; external name '_GetMovieCreationTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieModificationTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieModificationTime( theMovie: Movie ): UNSIGNEDLONG; external name '_GetMovieModificationTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieTimeScale()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieTimeScale( theMovie: Movie ): TimeScale; external name '_GetMovieTimeScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieTimeScale()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieTimeScale( theMovie: Movie; timeScale_: TimeScale ); external name '_SetMovieTimeScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieDuration()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieDuration( theMovie: Movie ): TimeValue; external name '_GetMovieDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieRate( theMovie: Movie ): Fixed; external name '_GetMovieRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieRate( theMovie: Movie; rate: Fixed ); external name '_SetMovieRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMoviePreferredRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMoviePreferredRate( theMovie: Movie ): Fixed; external name '_GetMoviePreferredRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMoviePreferredRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMoviePreferredRate( theMovie: Movie; rate: Fixed ); external name '_SetMoviePreferredRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetMovieMatrix( theMovie: Movie; var matrix: MatrixRecord ); external name '_GetMovieMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieMatrix( theMovie: Movie; const (*var*) matrix: MatrixRecord ); external name '_SetMovieMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMoviePreviewTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetMoviePreviewTime( theMovie: Movie; var previewTime: TimeValue; var previewDuration: TimeValue ); external name '_GetMoviePreviewTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMoviePreviewTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMoviePreviewTime( theMovie: Movie; previewTime: TimeValue; previewDuration: TimeValue ); external name '_SetMoviePreviewTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMoviePosterTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMoviePosterTime( theMovie: Movie ): TimeValue; external name '_GetMoviePosterTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMoviePosterTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMoviePosterTime( theMovie: Movie; posterTime: TimeValue ); external name '_SetMoviePosterTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieSelection()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetMovieSelection( theMovie: Movie; var selectionTime: TimeValue; var selectionDuration: TimeValue ); external name '_GetMovieSelection';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieSelection()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieSelection( theMovie: Movie; selectionTime: TimeValue; selectionDuration: TimeValue ); external name '_SetMovieSelection';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieActiveSegment()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieActiveSegment( theMovie: Movie; startTime: TimeValue; duration: TimeValue ); external name '_SetMovieActiveSegment';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieActiveSegment()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetMovieActiveSegment( theMovie: Movie; var startTime: TimeValue; var duration: TimeValue ); external name '_GetMovieActiveSegment';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieTime( theMovie: Movie; var currentTime: TimeRecord ): TimeValue; external name '_GetMovieTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieTime( theMovie: Movie; const (*var*) newtime: TimeRecord ); external name '_SetMovieTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieTimeValue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieTimeValue( theMovie: Movie; newtime: TimeValue ); external name '_SetMovieTimeValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieUserData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieUserData( theMovie: Movie ): UserData; external name '_GetMovieUserData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetTimeUntilNextTask()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTGetTimeUntilNextTask( var duration: SIGNEDLONG; scale: SIGNEDLONG ): OSErr; external name '_QTGetTimeUntilNextTask';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTInstallNextTaskNeededSoonerCallback()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTInstallNextTaskNeededSoonerCallback( callbackProc: QTNextTaskNeededSoonerCallbackUPP; scale: TimeScale; flags: UNSIGNEDLONG; refcon: UnivPtr ): OSErr; external name '_QTInstallNextTaskNeededSoonerCallback';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTUninstallNextTaskNeededSoonerCallback()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTUninstallNextTaskNeededSoonerCallback( callbackProc: QTNextTaskNeededSoonerCallbackUPP; refcon: UnivPtr ): OSErr; external name '_QTUninstallNextTaskNeededSoonerCallback';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  GetMovieRateChangeConstraints()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function GetMovieRateChangeConstraints( theMovie: Movie; var minimumDelay: TimeRecord; var maximumDelay: TimeRecord ): OSErr; external name '_GetMovieRateChangeConstraints';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{************************
* Track/Media finding routines
*************************}
{
 *  GetMovieTrackCount()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieTrackCount( theMovie: Movie ): SIGNEDLONG; external name '_GetMovieTrackCount';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieTrack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieTrack( theMovie: Movie; trackID: SIGNEDLONG ): Track; external name '_GetMovieTrack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieIndTrack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieIndTrack( theMovie: Movie; index: SIGNEDLONG ): Track; external name '_GetMovieIndTrack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieIndTrackType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieIndTrackType( theMovie: Movie; index: SIGNEDLONG; trackType: OSType; flags: SIGNEDLONG ): Track; external name '_GetMovieIndTrackType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackID()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackID( theTrack: Track ): SIGNEDLONG; external name '_GetTrackID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackMovie( theTrack: Track ): Movie; external name '_GetTrackMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Track creation routines
*************************}
{
 *  NewMovieTrack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewMovieTrack( theMovie: Movie; width: Fixed; height: Fixed; trackVolume: SInt16 ): Track; external name '_NewMovieTrack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeMovieTrack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure DisposeMovieTrack( theTrack: Track ); external name '_DisposeMovieTrack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Track State routines
*************************}
{
 *  GetTrackCreationTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackCreationTime( theTrack: Track ): UNSIGNEDLONG; external name '_GetTrackCreationTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackModificationTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackModificationTime( theTrack: Track ): UNSIGNEDLONG; external name '_GetTrackModificationTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackEnabled( theTrack: Track ): Boolean; external name '_GetTrackEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTrackEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTrackEnabled( theTrack: Track; isEnabled: Boolean ); external name '_SetTrackEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackUsage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackUsage( theTrack: Track ): SIGNEDLONG; external name '_GetTrackUsage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTrackUsage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTrackUsage( theTrack: Track; usage: SIGNEDLONG ); external name '_SetTrackUsage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackDuration()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackDuration( theTrack: Track ): TimeValue; external name '_GetTrackDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackOffset()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackOffset( theTrack: Track ): TimeValue; external name '_GetTrackOffset';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTrackOffset()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTrackOffset( theTrack: Track; movieOffsetTime: TimeValue ); external name '_SetTrackOffset';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackLayer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackLayer( theTrack: Track ): SInt16; external name '_GetTrackLayer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTrackLayer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTrackLayer( theTrack: Track; layer: SInt16 ); external name '_SetTrackLayer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackAlternate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackAlternate( theTrack: Track ): Track; external name '_GetTrackAlternate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTrackAlternate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTrackAlternate( theTrack: Track; alternateT: Track ); external name '_SetTrackAlternate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetAutoTrackAlternatesEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetAutoTrackAlternatesEnabled( theMovie: Movie; enable: Boolean ); external name '_SetAutoTrackAlternatesEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SelectMovieAlternates()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SelectMovieAlternates( theMovie: Movie ); external name '_SelectMovieAlternates';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetTrackMatrix( theTrack: Track; var matrix: MatrixRecord ); external name '_GetTrackMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTrackMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTrackMatrix( theTrack: Track; const (*var*) matrix: MatrixRecord ); external name '_SetTrackMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackDimensions()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetTrackDimensions( theTrack: Track; var width: Fixed; var height: Fixed ); external name '_GetTrackDimensions';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTrackDimensions()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTrackDimensions( theTrack: Track; width: Fixed; height: Fixed ); external name '_SetTrackDimensions';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackUserData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackUserData( theTrack: Track ): UserData; external name '_GetTrackUserData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackDisplayMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackDisplayMatrix( theTrack: Track; var matrix: MatrixRecord ): OSErr; external name '_GetTrackDisplayMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* get Media routines
*************************}
{
 *  NewTrackMedia()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewTrackMedia( theTrack: Track; mediaType: OSType; timeScale_: TimeScale; dataRef: Handle; dataRefType: OSType ): Media; external name '_NewTrackMedia';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeTrackMedia()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure DisposeTrackMedia( theMedia: Media ); external name '_DisposeTrackMedia';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackMedia()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackMedia( theTrack: Track ): Media; external name '_GetTrackMedia';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaTrack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaTrack( theMedia: Media ): Track; external name '_GetMediaTrack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Media State routines
*************************}
{
 *  GetMediaCreationTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaCreationTime( theMedia: Media ): UNSIGNEDLONG; external name '_GetMediaCreationTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaModificationTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaModificationTime( theMedia: Media ): UNSIGNEDLONG; external name '_GetMediaModificationTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaTimeScale()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaTimeScale( theMedia: Media ): TimeScale; external name '_GetMediaTimeScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaTimeScale()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMediaTimeScale( theMedia: Media; timeScale_: TimeScale ); external name '_SetMediaTimeScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaDecodeDuration()
 *  
 *  Summary:
 *    Returns the decode duration of a media.
 *  
 *  Discussion:
 *    A media's decode duration is the sum of the decode durations of
 *    its samples.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation. Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function GetMediaDecodeDuration( theMedia: Media ): TimeValue64; external name '_GetMediaDecodeDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMediaAdvanceDecodeTime()
 *  
 *  Summary:
 *    Returns the advance decode time of a media.
 *  
 *  Discussion:
 *    A media's advance decode time is the absolute value of the
 *    greatest-magnitude negative display offset of its samples, or
 *    zero if there are no samples with negative display offsets. 
 *     This is the amount that the decode time axis must be adjusted
 *    ahead of the display time axis to ensure that no sample's
 *    adjusted decode time is later than its display time. 
 *    For media without nonzero display offsets, the advance decode
 *    time is zero.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation. Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function GetMediaAdvanceDecodeTime( theMedia: Media ): TimeValue64; external name '_GetMediaAdvanceDecodeTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMediaDisplayDuration()
 *  
 *  Summary:
 *    Returns the display duration of a media.
 *  
 *  Discussion:
 *    A media's display duration is its display end time minus its
 *    display start time. For media without nonzero display offsets,
 *    the decode duration and display duration are the same, so
 *    GetMediaDisplayDuration and GetMediaDisplayDuration are
 *    equivalent to GetMediaDuration.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation. Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function GetMediaDisplayDuration( theMedia: Media ): TimeValue64; external name '_GetMediaDisplayDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMediaDisplayStartTime()
 *  
 *  Summary:
 *    Returns the display start time of a media.
 *  
 *  Discussion:
 *    A media's display start time is the earliest display time of any
 *    of its samples. For media without nonzero display offsets, the
 *    display start time is always zero.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation. Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function GetMediaDisplayStartTime( theMedia: Media ): TimeValue64; external name '_GetMediaDisplayStartTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMediaDisplayEndTime()
 *  
 *  Summary:
 *    Returns the display end time of a media.
 *  
 *  Discussion:
 *    A media's display end time is the sum of the display time and
 *    decode duration of the sample with the greatest display time. For
 *    media without nonzero display offsets, the display end time is
 *    the same as the media decode duration, which is the same as the
 *    media duration.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation. Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function GetMediaDisplayEndTime( theMedia: Media ): TimeValue64; external name '_GetMediaDisplayEndTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMediaDuration()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaDuration( theMedia: Media ): TimeValue; external name '_GetMediaDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaLanguage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaLanguage( theMedia: Media ): SInt16; external name '_GetMediaLanguage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaLanguage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMediaLanguage( theMedia: Media; language: SInt16 ); external name '_SetMediaLanguage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaQuality()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaQuality( theMedia: Media ): SInt16; external name '_GetMediaQuality';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaQuality()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMediaQuality( theMedia: Media; quality: SInt16 ); external name '_SetMediaQuality';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaHandlerDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetMediaHandlerDescription( theMedia: Media; var mediaType: OSType; var creatorName: Str255; var creatorManufacturer: OSType ); external name '_GetMediaHandlerDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaUserData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaUserData( theMedia: Media ): UserData; external name '_GetMediaUserData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaInputMap()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaInputMap( theMedia: Media; var inputMap: QTAtomContainer ): OSErr; external name '_GetMediaInputMap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaInputMap()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetMediaInputMap( theMedia: Media; inputMap: QTAtomContainer ): OSErr; external name '_SetMediaInputMap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Media Handler routines
*************************}
{
 *  GetMediaHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaHandler( theMedia: Media ): MediaHandler; external name '_GetMediaHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetMediaHandler( theMedia: Media; mH: MediaHandlerComponent ): OSErr; external name '_SetMediaHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Media's Data routines
*************************}
{
 *  BeginMediaEdits()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function BeginMediaEdits( theMedia: Media ): OSErr; external name '_BeginMediaEdits';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  EndMediaEdits()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function EndMediaEdits( theMedia: Media ): OSErr; external name '_EndMediaEdits';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaDefaultDataRefIndex()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetMediaDefaultDataRefIndex( theMedia: Media; index: SInt16 ): OSErr; external name '_SetMediaDefaultDataRefIndex';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaDataHandlerDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetMediaDataHandlerDescription( theMedia: Media; index: SInt16; var dhType: OSType; var creatorName: Str255; var creatorManufacturer: OSType ); external name '_GetMediaDataHandlerDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaDataHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaDataHandler( theMedia: Media; index: SInt16 ): DataHandler; external name '_GetMediaDataHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaDataHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetMediaDataHandler( theMedia: Media; index: SInt16; dataHandler: DataHandlerComponent ): OSErr; external name '_SetMediaDataHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetDataHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetDataHandler( dataRef: Handle; dataHandlerSubType: OSType; flags: SIGNEDLONG ): Component; external name '_GetDataHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  OpenADataHandler()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function OpenADataHandler( dataRef: Handle; dataHandlerSubType: OSType; anchorDataRef: Handle; anchorDataRefType: OSType; tb: TimeBase; flags: SIGNEDLONG; var dh: ComponentInstance ): OSErr; external name '_OpenADataHandler';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Media Sample Table Routines
*************************}
{
 *  GetMediaSampleDescriptionCount()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaSampleDescriptionCount( theMedia: Media ): SIGNEDLONG; external name '_GetMediaSampleDescriptionCount';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaSampleDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetMediaSampleDescription( theMedia: Media; index: SIGNEDLONG; descH: SampleDescriptionHandle ); external name '_GetMediaSampleDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaSampleDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetMediaSampleDescription( theMedia: Media; index: SIGNEDLONG; descH: SampleDescriptionHandle ): OSErr; external name '_SetMediaSampleDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaSampleCount()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaSampleCount( theMedia: Media ): SIGNEDLONG; external name '_GetMediaSampleCount';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaSyncSampleCount()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaSyncSampleCount( theMedia: Media ): SIGNEDLONG; external name '_GetMediaSyncSampleCount';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MediaContainsDisplayOffsets()
 *  
 *  Summary:
 *    Tests whether a media contains display offsets.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation. Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *  
 *  Result:
 *    True, if the media is valid and contains at least one sample with
 *    a nonzero display offset.  False otherwise.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function MediaContainsDisplayOffsets( theMedia: Media ): Boolean; external name '_MediaContainsDisplayOffsets';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  SampleNumToMediaDecodeTime()
 *  
 *  Summary:
 *    Finds the decode time for a specified sample.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation. Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *    
 *    logicalSampleNum:
 *      The sample number.
 *    
 *    sampleDecodeTime:
 *      A pointer to a time value. The function updates this time value
 *      to indicate the decode time of the sample specified by the
 *      logicalSampleNum parameter. This time value is expressed in the
 *      media's time scale. Set this parameter to NULL if you do not
 *      want this information.
 *    
 *    sampleDecodeDuration:
 *      A pointer to a time value. The function updates this time value
 *      to indicate the decode duration of the sample specified by the
 *      logicalSampleNum parameter. This time value is expressed in the
 *      media's time scale. Set this parameter to NULL if you do not
 *      want this information.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
procedure SampleNumToMediaDecodeTime( theMedia: Media; logicalSampleNum: SInt64; sampleDecodeTime: TimeValue64Ptr { can be NULL }; sampleDecodeDuration: TimeValue64Ptr { can be NULL} ); external name '_SampleNumToMediaDecodeTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  MediaDecodeTimeToSampleNum()
 *  
 *  Summary:
 *    Finds the sample for a specified decode time.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation. Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *    
 *    decodeTime:
 *      The decode time for which you are retrieving sample
 *      information. You must specify this value in the media's time
 *      scale.
 *    
 *    sampleNum:
 *      Points to a variable that is to receive the sample number. The
 *      function returns the sample number that identifies the sample
 *      that contains data for the specified decode time, or zero if it
 *      is not found.
 *    
 *    sampleDecodeTime:
 *      A pointer to a time value. The function updates this time value
 *      to indicate the decode time of the sample specified by the
 *      logicalSampleNum parameter. This time value is expressed in the
 *      media's time scale. Set this parameter to NULL if you do not
 *      want this information.
 *    
 *    sampleDecodeDuration:
 *      A pointer to a time value. The function updates this time value
 *      to indicate the decode duration of the sample specified by the
 *      logicalSampleNum parameter. This time value is expressed in the
 *      media's time scale. Set this parameter to NULL if you do not
 *      want this information.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
procedure MediaDecodeTimeToSampleNum( theMedia: Media; decodeTime: TimeValue64; var sampleNum: SInt64; sampleDecodeTime: TimeValue64Ptr { can be NULL }; sampleDecodeDuration: TimeValue64Ptr { can be NULL } ); external name '_MediaDecodeTimeToSampleNum';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  SampleNumToMediaDisplayTime()
 *  
 *  Summary:
 *    Finds the display time for a specified sample.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation. Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *    
 *    logicalSampleNum:
 *      The sample number.
 *    
 *    sampleDisplayTime:
 *      A pointer to a time value. The function updates this time value
 *      to indicate the display time of the sample specified by the
 *      logicalSampleNum parameter. This time value is expressed in the
 *      media's time scale. Set this parameter to NULL if you do not
 *      want this information.
 *    
 *    sampleDisplayDuration:
 *      A pointer to a time value. The function updates this time value
 *      to indicate the display duration of the sample specified by the
 *      logicalSampleNum parameter. This time value is expressed in the
 *      media's time scale. Set this parameter to NULL if you do not
 *      want this information.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
procedure SampleNumToMediaDisplayTime( theMedia: Media; logicalSampleNum: SInt64; sampleDisplayTime: TimeValue64Ptr { can be NULL }; sampleDisplayDuration: TimeValue64Ptr { can be NULL } ); external name '_SampleNumToMediaDisplayTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  MediaDisplayTimeToSampleNum()
 *  
 *  Summary:
 *    Finds the sample number for a specified display time.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation. Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *    
 *    displayTime:
 *      The display time for which you are retrieving sample
 *      information. You must specify this value in the media's time
 *      scale.
 *    
 *    sampleNum:
 *      Points to a long integer that is to receive the sample number.
 *      The function returns the sample number that identifies the
 *      sample for the specified display time, or zero if it is not
 *      found.
 *    
 *    sampleDisplayTime:
 *      A pointer to a time value. The function updates this time value
 *      to indicate the display time of the sample specified by the
 *      logicalSampleNum parameter. This time value is expressed in the
 *      media's time scale. Set this parameter to NULL if you do not
 *      want this information.
 *    
 *    sampleDisplayDuration:
 *      A pointer to a time value. The function updates this time value
 *      to indicate the display duration of the sample specified by the
 *      logicalSampleNum parameter. This time value is expressed in the
 *      media's time scale. Set this parameter to NULL if you do not
 *      want this information.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
procedure MediaDisplayTimeToSampleNum( theMedia: Media; displayTime: TimeValue64; var sampleNum: SInt64; var sampleDisplayTime: TimeValue64; var sampleDisplayDuration: TimeValue64 ); external name '_MediaDisplayTimeToSampleNum';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  SampleNumToMediaTime()
 *  
 *  Summary:
 *    Finds the media time for a specified sample.
 *  
 *  Discussion:
 *    For media with display offsets, SampleNumToMediaTime is ambiguous
 *    and will return kQTMediaHasDisplayOffsetsErr. Call
 *    SampleNumToMediaDecodeTime or SampleNumToMediaDisplayTime instead.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SampleNumToMediaTime( theMedia: Media; logicalSampleNum: SIGNEDLONG; var sampleTime: TimeValue; var sampleDuration: TimeValue ); external name '_SampleNumToMediaTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MediaTimeToSampleNum()
 *  
 *  Summary:
 *    Finds the sample number for a specified media time.
 *  
 *  Discussion:
 *    For media with display offsets, MediaTimeToSampleNum is ambiguous
 *    and will return kQTMediaHasDisplayOffsetsErr. Call
 *    MediaDecodeTimeToSampleNum or MediaDisplayTimeToSampleNum instead.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure MediaTimeToSampleNum( theMedia: Media; time: TimeValue; var sampleNum: SIGNEDLONG; var sampleTime: TimeValue; var sampleDuration: TimeValue ); external name '_MediaTimeToSampleNum';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AddMediaSample2()
 *  
 *  Summary:
 *    Adds sample data and a description to a media. AddMediaSample2
 *    extends and supercedes AddMediaSample.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation.  Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *    
 *    dataIn:
 *      Points to sample data.
 *    
 *    size:
 *      The number of bytes of sample data to be added to the media.
 *      This parameter indicates the total number of bytes in the
 *      sample data to be added to the media, not the number of bytes
 *      per sample. Use the numberOfSamples parameter to indicate the
 *      number of samples that are contained in the sample data.
 *    
 *    decodeDurationPerSample:
 *      The duration of each sample to be added. You must specify this
 *      parameter in the media time scale. For example, if you are
 *      adding sound that was sampled at 22 kHz to a media that
 *      contains a sound track with the same time scale, you would set
 *      durationPerSample to 1. Similarly, if you are adding video that
 *      was recorded at 10 frames per second to a video media that has
 *      a time scale of 600, you would set this parameter to 60 to add
 *      a single sample.
 *    
 *    displayOffset:
 *      The offset from decode time to display time of each sample to
 *      be added. You must specify this parameter in the media time
 *      scale. If the decode times and display times for the samples
 *      are identical, pass zero.
 *    
 *    sampleDescriptionH:
 *      A handle to a SampleDescription structure. Some media
 *      structures may require sample descriptions. There are different
 *      descriptions for different types of samples. For example, a
 *      media that contains compressed video requires that you supply
 *      an ImageDescription structure. A media that contains sound
 *      requires that you supply a SoundDescription structure.
 *    
 *    numberOfSamples:
 *      The number of samples contained in the sample data to be added
 *      to the media.
 *    
 *    sampleFlags:
 *      Specifies the media sample flags for the samples to be added.
 *    
 *    sampleDecodeTimeOut:
 *      A pointer to a time value. After adding the sample data to the
 *      media, the AddMediaSample function returns the decode time
 *      where the first sample was inserted in the time value referred
 *      to by this parameter. If you don't want to receive this
 *      information, set this parameter to NULL.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function AddMediaSample2( theMedia: Media; const (*var*) dataIn: UInt8; size: ByteCount; decodeDurationPerSample: TimeValue64; displayOffset: TimeValue64; sampleDescriptionH: SampleDescriptionHandle; numberOfSamples: ItemCount; sampleFlags: MediaSampleFlags; sampleDecodeTimeOut: TimeValue64Ptr { can be NULL } ): OSErr; external name '_AddMediaSample2';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  AddMediaSampleFromEncodedFrame()
 *  
 *  Summary:
 *    Adds sample data and description from an encoded frame to a media.
 *  
 *  Discussion:
 *    This is a convenience API to make it easy to add frames emitted
 *    by ICM compression session APIs to media.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation.  Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *    
 *    encodedFrame:
 *      An encoded frame token returned by an ICMCompressionSequence.
 *    
 *    sampleDecodeTimeOut:
 *      A pointer to a time value. After adding the sample data to the
 *      media, the function returns the decode time where the first
 *      sample was inserted in the time value referred to by this
 *      parameter. If you don't want to receive this information, set
 *      this parameter to NULL.
 *  
 *  Result:
 *    An operating system result code.
 *    kQTMediaDoesNotSupportDisplayOffsetsErr if the media does not
 *    support nonzero display offsets. kQTDisplayTimeAlreadyInUseErr if
 *    there is already a sample with this display time.
 *    kQTDisplayTimeTooEarlyErr if a sample's display time would be
 *    earlier than the display time of an existing sample that does not
 *    have the mediaSampleEarlierDisplayTimesAllowed flag set.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function AddMediaSampleFromEncodedFrame( theMedia: Media; encodedFrame: ICMEncodedFrameRef; sampleDecodeTimeOut: TimeValue64Ptr { can be NULL } ): OSErr; external name '_AddMediaSampleFromEncodedFrame';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  AddSampleTableToMedia()
 *  
 *  Summary:
 *    Adds sample references from a sample table to a media.
 *    AddSampleTableToMedia supercedes AddMediaSampleReferences and
 *    AddMediaSampleReferences64.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation.  Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *    
 *    sampleTable:
 *      The sample table containing sample references to be added to
 *      the media.
 *    
 *    startSampleNum:
 *      The sample number of the first sample reference in the sample
 *      table to be added to the media.  The first sample's number is 1.
 *    
 *    numberOfSamples:
 *      The number of sample references from the sample table to be
 *      added to the media.
 *    
 *    sampleDecodeTimeOut:
 *      A pointer to a time value. After adding the sample references
 *      to the media, the function returns the decode time where the
 *      first sample was inserted in the time value referred to by this
 *      parameter. If you don't want to receive this information, set
 *      this parameter to NULL.
 *  
 *  Result:
 *    An operating system result code.
 *    kQTMediaDoesNotSupportDisplayOffsetsErr if the media does not
 *    support nonzero display offsets. kQTDisplayTimeAlreadyInUseErr if
 *    there is already a sample with this display time.
 *    kQTDisplayTimeTooEarlyErr if a sample's display time would be
 *    earlier than the display time of an existing sample that does not
 *    have the mediaSampleEarlierDisplayTimesAllowed flag set.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function AddSampleTableToMedia( theMedia: Media; sampleTable: QTSampleTableRef; startSampleNum: SInt64; numberOfSamples: SInt64; sampleDecodeTimeOut: TimeValue64Ptr { can be NULL } ): OSErr; external name '_AddSampleTableToMedia';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  AddMediaSample()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function AddMediaSample( theMedia: Media; dataIn: Handle; inOffset: SIGNEDLONG; size: UNSIGNEDLONG; durationPerSample: TimeValue; sampleDescriptionH: SampleDescriptionHandle; numberOfSamples: SIGNEDLONG; sampleFlags: SInt16; var sampleTime: TimeValue ): OSErr; external name '_AddMediaSample';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AddMediaSampleReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function AddMediaSampleReference( theMedia: Media; dataOffset: SIGNEDLONG; size: UNSIGNEDLONG; durationPerSample: TimeValue; sampleDescriptionH: SampleDescriptionHandle; numberOfSamples: SIGNEDLONG; sampleFlags: SInt16; var sampleTime: TimeValue ): OSErr; external name '_AddMediaSampleReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AddMediaSampleReferences()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function AddMediaSampleReferences( theMedia: Media; sampleDescriptionH: SampleDescriptionHandle; numberOfSamples: SIGNEDLONG; sampleRefs: SampleReferencePtr; var sampleTime: TimeValue ): OSErr; external name '_AddMediaSampleReferences';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AddMediaSampleReferences64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function AddMediaSampleReferences64( theMedia: Media; sampleDescriptionH: SampleDescriptionHandle; numberOfSamples: SIGNEDLONG; sampleRefs: SampleReference64Ptr; var sampleTime: TimeValue ): OSErr; external name '_AddMediaSampleReferences64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ExtendMediaDecodeDurationToDisplayEndTime()
 *  
 *  Summary:
 *    Prepares a media for the addition of a completely new sequence of
 *    samples by ensuring that the media display end time is not later
 *    than the media decode end time.
 *  
 *  Discussion:
 *    After adding a complete, well-formed set of samples to a media,
 *    the media's display end time should be the same as the media's
 *    decode end time (also called the media decode duration). 
 *    However, this is not necessarily the case after individual
 *    sample-adding operations, and hence it is possible for a media to
 *    be left with a display end time later than its decode end time --
 *    if adding a sequence of frames is aborted halfway, for example.
 *    
 *    This may make it difficult to add a new group of samples, because
 *    a well-formed group of samples' earliest display time should be
 *    the same as the first frame's decode time.  If such a well-formed
 *    group is added to an incompletely finished media, frames from the
 *    old and new groups frames might collide in display time. 
 *     ExtendMediaDecodeDurationToDisplayEndTime prevents any such
 *    collision or overlap by extending the last sample's decode
 *    duration as necessary.  It ensures that the next added sample
 *    will have a decode time no earlier than the media's display end
 *    time.  If this was already the case, it makes no change to the
 *    media. 
 *    You can call ExtendMediaDecodeDurationToDisplayEndTime before you
 *    begin adding samples to a media if you're not certain that the
 *    media was left in a well-finished state.  You do not need to call
 *    it before adding samples to a newly created media, nor should you
 *    call it in between samples from the same compression session.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation.  Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *    
 *    mediaChanged:
 *      Points to a variable which will be set to true if any samples
 *      in the media were adjusted, false otherwise. If you don't want
 *      to receive this information, set this parameter to NULL.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function ExtendMediaDecodeDurationToDisplayEndTime( theMedia: Media; var mediaChanged: Boolean ): OSErr; external name '_ExtendMediaDecodeDurationToDisplayEndTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMediaSample2()
 *  
 *  Summary:
 *    Retrieves sample data from a media file. GetMediaSample2 extends
 *    and supercedes GetMediaSample.
 *  
 *  Discussion:
 *    GetMediaSample2 will only return multiple samples that all have
 *    the same decode duration per sample, the same display offset, the
 *    same sample description, and the same size per sample.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation.  Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *    
 *    dataOut:
 *      Points to a buffer to receive sample data. The buffer must be
 *      large enough to contain at least maxDataSize bytes. If you do
 *      not want to receive sample data, pass NULL.
 *    
 *    maxDataSize:
 *      The maximum number of bytes of data to receive.
 *    
 *    size:
 *      Points to a long integer to receive the number of bytes of
 *      sample data returned. Pass NULL if you are not interested this
 *      information.
 *    
 *    decodeTime:
 *      The decode time for which you are retrieving sample
 *      information. You must specify this value in the media's time
 *      scale.
 *    
 *    sampleDecodeTime:
 *      A pointer to a time value. The function updates this time value
 *      to indicate the actual decode time of the returned sample data.
 *      (The returned time may differ from the time you specified with
 *      the decodeTime parameter. This will occur if the time you
 *      specified falls in the middle of a sample.) If you are not
 *      interested in this information, set this parameter to NULL.
 *    
 *    decodeDurationPerSample:
 *      A pointer to a time value. The function updates this time value
 *      to indicate the decode duration of each of the returned
 *      samples. This time value is expressed in the media's time
 *      scale. Set this parameter to NULL if you don't want this
 *      information.
 *    
 *    displayOffset:
 *      A pointer to a time value. The function updates this time value
 *      to indicate the display offset of the returned sample.  This
 *      time value is expressed in the media's time scale. Set this
 *      parameter to NULL if you don't want this information.
 *    
 *    sampleDescriptionH:
 *      A handle to a SampleDescription structure. The function returns
 *      the sample description corresponding to the returned sample
 *      data.  The function resizes this handle as appropriate. If you
 *      don't want a SampleDescription structure, set this parameter to
 *      NULL.
 *    
 *    sampleDescriptionIndex:
 *      A pointer to a long integer. The function returns an index
 *      value to the SampleDescription structure that corresponds to
 *      the returned sample data. You can retrieve the structure by
 *      calling GetMediaSampleDescription and passing this index in the
 *      index parameter. If you don't want this information, set this
 *      parameter to NULL.
 *    
 *    maxNumberOfSamples:
 *      The maximum number of samples to be returned. The Movie Toolbox
 *      does not return more samples than you specify with this
 *      parameter. If you set this parameter to 0, the Movie Toolbox
 *      uses a value that is appropriate for the media, and returns
 *      that value in the field referenced by the numberOfSamples
 *      parameter.
 *    
 *    numberOfSamples:
 *      A pointer to a long integer. The function updates the field
 *      referred to by this parameter with the number of samples it
 *      actually returns. If you don't want this information, set this
 *      parameter to NULL.
 *    
 *    sampleFlags:
 *      A pointer to a short integer in which the function returns
 *      media sample flags for the returned samples. If you don't want
 *      this information, set this parameter to NULL.
 *  
 *  Result:
 *    An operating system result code. maxSizeToGrowTooSmall if the
 *    sample data is larger than maxDataSize.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function GetMediaSample2( theMedia: Media; var dataOut: UInt8; maxDataSize: ByteCount; var size: ByteCount; decodeTime: TimeValue64; var sampleDecodeTime: TimeValue64; var decodeDurationPerSample: TimeValue64; var displayOffset: TimeValue64; sampleDescriptionH: SampleDescriptionHandle; var sampleDescriptionIndex: ItemCount; maxNumberOfSamples: ItemCount; var numberOfSamples: ItemCount; var sampleFlags: MediaSampleFlags ): OSErr; external name '_GetMediaSample2';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMediaSample()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaSample( theMedia: Media; dataOut: Handle; maxSizeToGrow: SIGNEDLONG; var size: SIGNEDLONG; time: TimeValue; var sampleTime: TimeValue; var durationPerSample: TimeValue; sampleDescriptionH: SampleDescriptionHandle; var sampleDescriptionIndex: SIGNEDLONG; maxNumberOfSamples: SIGNEDLONG; var numberOfSamples: SIGNEDLONG; var sampleFlags: SInt16 ): OSErr; external name '_GetMediaSample';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CopyMediaMutableSampleTable()
 *  
 *  Summary:
 *    Obtains information about sample references in a media in the
 *    form of a sample table. CopyMediaMutableSampleTable supercedes
 *    GetMediaSampleReferences and GetMediaSampleReferences64.
 *  
 *  Discussion:
 *    When you are done with the returned sample table, release it with
 *    QTSampleTableRelease. 
 *    To find out how many samples were returned in the sample table,
 *    call QTSampleTableGetNumberOfSamples.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation.  Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *    
 *    startDecodeTime:
 *      The starting decode time of the sample references to be
 *      retrieved. You must specify this value in the media's time
 *      scale.
 *    
 *    sampleStartDecodeTime:
 *      A pointer to a time value. The function updates this time value
 *      to indicate the actual decode time of the first returned sample
 *      reference. (The returned time may differ from the time you
 *      specified with the startDecodeTime parameter.  This will occur
 *      if the time you specified falls in the middle of a sample.) If
 *      you are not interested in this information, set this parameter
 *      to NULL.
 *    
 *    maxNumberOfSamples:
 *      The maximum number of sample references to be returned. If you
 *      set this parameter to 0, the Movie Toolbox uses a value that is
 *      appropriate to the media.
 *    
 *    maxDecodeDuration:
 *      The maximum decode duration to be returned. The function does
 *      not return samples with greater decode duration than you
 *      specify with this parameter. If you set this parameter to 0,
 *      the Movie Toolbox uses a value that is appropriate for the
 *      media.
 *    
 *    sampleTableOut:
 *      A pointer to a sample table reference to receive the newly
 *      created mutable sample table.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function CopyMediaMutableSampleTable( theMedia: Media; startDecodeTime: TimeValue64; var sampleStartDecodeTime: TimeValue64; maxNumberOfSamples: SInt64; maxDecodeDuration: TimeValue64; var sampleTableOut: QTMutableSampleTableRef ): OSErr; external name '_CopyMediaMutableSampleTable';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMediaSampleReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaSampleReference( theMedia: Media; var dataOffset: SIGNEDLONG; var size: SIGNEDLONG; time: TimeValue; var sampleTime: TimeValue; var durationPerSample: TimeValue; sampleDescriptionH: SampleDescriptionHandle; var sampleDescriptionIndex: SIGNEDLONG; maxNumberOfSamples: SIGNEDLONG; var numberOfSamples: SIGNEDLONG; var sampleFlags: SInt16 ): OSErr; external name '_GetMediaSampleReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaSampleReferences()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaSampleReferences( theMedia: Media; time: TimeValue; var sampleTime: TimeValue; sampleDescriptionH: SampleDescriptionHandle; var sampleDescriptionIndex: SIGNEDLONG; maxNumberOfEntries: SIGNEDLONG; var actualNumberofEntries: SIGNEDLONG; sampleRefs: SampleReferencePtr ): OSErr; external name '_GetMediaSampleReferences';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaSampleReferences64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GetMediaSampleReferences64( theMedia: Media; time: TimeValue; var sampleTime: TimeValue; sampleDescriptionH: SampleDescriptionHandle; var sampleDescriptionIndex: SIGNEDLONG; maxNumberOfEntries: SIGNEDLONG; var actualNumberofEntries: SIGNEDLONG; sampleRefs: SampleReference64Ptr ): OSErr; external name '_GetMediaSampleReferences64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaPreferredChunkSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetMediaPreferredChunkSize( theMedia: Media; maxChunkSize: SIGNEDLONG ): OSErr; external name '_SetMediaPreferredChunkSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaPreferredChunkSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaPreferredChunkSize( theMedia: Media; var maxChunkSize: SIGNEDLONG ): OSErr; external name '_GetMediaPreferredChunkSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaShadowSync()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetMediaShadowSync( theMedia: Media; frameDiffSampleNum: SIGNEDLONG; syncSampleNum: SIGNEDLONG ): OSErr; external name '_SetMediaShadowSync';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaShadowSync()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaShadowSync( theMedia: Media; frameDiffSampleNum: SIGNEDLONG; var syncSampleNum: SIGNEDLONG ): OSErr; external name '_GetMediaShadowSync';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Editing Routines
*************************}
{
    When inserting media that might have nonzero display offsets into a track, use display time:
      InsertMediaIntoTrack( track, 
                            0,                                 // track start time
                            GetMediaDisplayStartTime( media ), // media start time
                            GetMediaDisplayDuration( media ), 
                            fixed1 );                          // normal speed
    It is safe to use these display time calls for media without display offsets.
}
{
 *  InsertMediaIntoTrack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function InsertMediaIntoTrack( theTrack: Track; trackStart: TimeValue; mediaTime: TimeValue; mediaDuration: TimeValue; mediaRate: Fixed ): OSErr; external name '_InsertMediaIntoTrack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  InsertTrackSegment()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function InsertTrackSegment( srcTrack: Track; dstTrack: Track; srcIn: TimeValue; srcDuration: TimeValue; dstIn: TimeValue ): OSErr; external name '_InsertTrackSegment';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  InsertMovieSegment()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function InsertMovieSegment( srcMovie: Movie; dstMovie: Movie; srcIn: TimeValue; srcDuration: TimeValue; dstIn: TimeValue ): OSErr; external name '_InsertMovieSegment';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  InsertEmptyTrackSegment()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function InsertEmptyTrackSegment( dstTrack: Track; dstIn: TimeValue; dstDuration: TimeValue ): OSErr; external name '_InsertEmptyTrackSegment';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  InsertEmptyMovieSegment()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function InsertEmptyMovieSegment( dstMovie: Movie; dstIn: TimeValue; dstDuration: TimeValue ): OSErr; external name '_InsertEmptyMovieSegment';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DeleteTrackSegment()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DeleteTrackSegment( theTrack: Track; startTime: TimeValue; duration: TimeValue ): OSErr; external name '_DeleteTrackSegment';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DeleteMovieSegment()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DeleteMovieSegment( theMovie: Movie; startTime: TimeValue; duration: TimeValue ): OSErr; external name '_DeleteMovieSegment';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ScaleTrackSegment()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ScaleTrackSegment( theTrack: Track; startTime: TimeValue; oldDuration: TimeValue; newDuration: TimeValue ): OSErr; external name '_ScaleTrackSegment';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ScaleMovieSegment()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ScaleMovieSegment( theMovie: Movie; startTime: TimeValue; oldDuration: TimeValue; newDuration: TimeValue ): OSErr; external name '_ScaleMovieSegment';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Hi-level Editing Routines
*************************}
{
 *  CutMovieSelection()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CutMovieSelection( theMovie: Movie ): Movie; external name '_CutMovieSelection';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CopyMovieSelection()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CopyMovieSelection( theMovie: Movie ): Movie; external name '_CopyMovieSelection';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PasteMovieSelection()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure PasteMovieSelection( theMovie: Movie; src: Movie ); external name '_PasteMovieSelection';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AddMovieSelection()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure AddMovieSelection( theMovie: Movie; src: Movie ); external name '_AddMovieSelection';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClearMovieSelection()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure ClearMovieSelection( theMovie: Movie ); external name '_ClearMovieSelection';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PasteHandleIntoMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PasteHandleIntoMovie( h: Handle; handleType: OSType; theMovie: Movie; flags: SIGNEDLONG; userComp: ComponentInstance ): OSErr; external name '_PasteHandleIntoMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PutMovieIntoTypedHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PutMovieIntoTypedHandle( theMovie: Movie; targetTrack: Track; handleType: OSType; publicMovie: Handle; start: TimeValue; dur: TimeValue; flags: SIGNEDLONG; userComp: ComponentInstance ): OSErr; external name '_PutMovieIntoTypedHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  IsScrapMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function IsScrapMovie( targetTrack: Track ): Component; external name '_IsScrapMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Middle-level Editing Routines
*************************}
{
 *  CopyTrackSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CopyTrackSettings( srcTrack: Track; dstTrack: Track ): OSErr; external name '_CopyTrackSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CopyMovieSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CopyMovieSettings( srcMovie: Movie; dstMovie: Movie ): OSErr; external name '_CopyMovieSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AddEmptyTrackToMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function AddEmptyTrackToMovie( srcTrack: Track; dstMovie: Movie; dataRef: Handle; dataRefType: OSType; var dstTrack: Track ): OSErr; external name '_AddEmptyTrackToMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	kQTCloneShareSamples = 1 shl 0;
	kQTCloneDontCopyEdits = 1 shl 1;

{
 *  AddClonedTrackToMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function AddClonedTrackToMovie( srcTrack: Track; dstMovie: Movie; flags: SIGNEDLONG; var dstTrack: Track ): OSErr; external name '_AddClonedTrackToMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* movie & track edit state routines
*************************}
{
 *  NewMovieEditState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewMovieEditState( theMovie: Movie ): MovieEditState; external name '_NewMovieEditState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  UseMovieEditState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function UseMovieEditState( theMovie: Movie; toState: MovieEditState ): OSErr; external name '_UseMovieEditState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeMovieEditState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DisposeMovieEditState( state: MovieEditState ): OSErr; external name '_DisposeMovieEditState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewTrackEditState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewTrackEditState( theTrack: Track ): TrackEditState; external name '_NewTrackEditState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  UseTrackEditState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function UseTrackEditState( theTrack: Track; state: TrackEditState ): OSErr; external name '_UseTrackEditState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeTrackEditState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DisposeTrackEditState( state: TrackEditState ): OSErr; external name '_DisposeTrackEditState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* track reference routines
*************************}
{
 *  AddTrackReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function AddTrackReference( theTrack: Track; refTrack: Track; refType: OSType; var addedIndex: SIGNEDLONG ): OSErr; external name '_AddTrackReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DeleteTrackReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DeleteTrackReference( theTrack: Track; refType: OSType; index: SIGNEDLONG ): OSErr; external name '_DeleteTrackReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTrackReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetTrackReference( theTrack: Track; refTrack: Track; refType: OSType; index: SIGNEDLONG ): OSErr; external name '_SetTrackReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackReference( theTrack: Track; refType: OSType; index: SIGNEDLONG ): Track; external name '_GetTrackReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetNextTrackReferenceType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetNextTrackReferenceType( theTrack: Track; refType: OSType ): OSType; external name '_GetNextTrackReferenceType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackReferenceCount()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackReferenceCount( theTrack: Track; refType: OSType ): SIGNEDLONG; external name '_GetTrackReferenceCount';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* high level file conversion routines
*************************}
{
 *  ConvertFileToMovieFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ConvertFileToMovieFile( const (*var*) inputFile: FSSpec; const (*var*) outputFile: FSSpec; creator: OSType; scriptTag: ScriptCode; var resID: SInt16; flags: SIGNEDLONG; userComp: ComponentInstance; proc: MovieProgressUPP; refCon: SIGNEDLONG ): OSErr; external name '_ConvertFileToMovieFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ConvertMovieToFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ConvertMovieToFile( theMovie: Movie; onlyTrack: Track; var outputFile: FSSpec; fileType: OSType; creator: OSType; scriptTag: ScriptCode; var resID: SInt16; flags: SIGNEDLONG; userComp: ComponentInstance ): OSErr; external name '_ConvertMovieToFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ConvertMovieToDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function ConvertMovieToDataRef( m: Movie; onlyTrack: Track; dataRef: Handle; dataRefType: OSType; fileType: OSType; creator: OSType; flags: SIGNEDLONG; userComp: ComponentInstance ): OSErr; external name '_ConvertMovieToDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  ConvertDataRefToMovieDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function ConvertDataRefToMovieDataRef( inputDataRef: Handle; inputDataRefType: OSType; outputDataRef: Handle; outputDataRefType: OSType; creator: OSType; flags: SIGNEDLONG; userComp: ComponentInstance; proc: MovieProgressUPP; refCon: SIGNEDLONG ): OSErr; external name '_ConvertDataRefToMovieDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


const
	kGetMovieImporterValidateToFind = 1 shl 0;
	kGetMovieImporterAllowNewFile = 1 shl 1;
	kGetMovieImporterDontConsiderGraphicsImporters = 1 shl 2;
	kGetMovieImporterDontConsiderFileOnlyImporters = 1 shl 6;
	kGetMovieImporterAutoImportOnly = 1 shl 10; { reject aggressive movie importers which have dontAutoFileMovieImport set}

{
 *  GetMovieImporterForDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieImporterForDataRef( dataRefType: OSType; dataRef: Handle; flags: SIGNEDLONG; var importer: Component ): OSErr; external name '_GetMovieImporterForDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	kQTGetMIMETypeInfoIsQuickTimeMovieType = FourCharCode('moov'); { info is a pointer to a Boolean}
	kQTGetMIMETypeInfoIsUnhelpfulType = FourCharCode('dumb'); { info is a pointer to a Boolean}

{
 *  QTGetMIMETypeInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function QTGetMIMETypeInfo( mimeStringStart: ConstCStringPtr; mimeStringLength: SInt16; infoSelector: OSType; infoDataPtr: UnivPtr; var infoDataSize: SIGNEDLONG ): OSErr; external name '_QTGetMIMETypeInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{***************************
* Movie importer properties
****************************}

const
	kQTPropertyClass_MovieImporter = FourCharCode('eat ');

  {
   * kQTMovieImporterPropertyID_AllowMediaOptimization: Value is
   * Boolean (get/set) Allow QuickTime importers to optimize the media
   * representation during import. This may create media that is not
   * fully compatible with applications that use older low-level APIs
   * to access and manipulate media samples.  For instance, this
   * property allows the MP3 importer to create VBR sample tables,
   * which may be incompatible with applications that use
   * GetMediaSample and SoundConverter to manually decode audio samples.
   }
	kQTMovieImporterPropertyID_AllowMediaOptimization = FourCharCode('amop'); { Boolean}


{************************
* Movie Timebase Conversion Routines
*************************}
{
 *  TrackTimeToMediaDisplayTime()
 *  
 *  Summary:
 *    Converts a track's time value to a display time value that is
 *    appropriate to the track's media, using the track's edit list.
 *    This is a 64-bit replacement for TrackTimeToMediaTime.
 *  
 *  Discussion:
 *    This function maps the track time through the track's edit list
 *    to come up with the media time. This time value contains the
 *    track's time value according to the media's time coordinate
 *    system. If the time you specified lies outside of the movie's
 *    active segment or corresponds to empty space in the track, this
 *    function returns a value of -1. Hence you can use it to determine
 *    whether a specified track edit is empty.
 *  
 *  Parameters:
 *    
 *    value:
 *      The track's time value; must be expressed in the time scale of
 *      the movie that contains the track.
 *    
 *    theTrack:
 *      The track for this operation.  Your application obtains this
 *      track identifier from such functions as NewMovieTrack and
 *      GetMovieTrack.
 *  
 *  Result:
 *    The corresponding time in media display time, in the media's time
 *    coordinate system. If the track time corresponds to empty space,
 *    this function returns a value of -1.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function TrackTimeToMediaDisplayTime( value: TimeValue64; theTrack: Track ): TimeValue64; external name '_TrackTimeToMediaDisplayTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  TrackTimeToMediaTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TrackTimeToMediaTime( value: TimeValue; theTrack: Track ): TimeValue; external name '_TrackTimeToMediaTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackEditRate64()
 *  
 *  Summary:
 *    Returns the rate of the track edit of a specified track at an
 *    indicated time. This is a 64-bit replacement for GetTrackEditRate.
 *  
 *  Discussion:
 *    This function is useful if you are stepping through track edits
 *    directly in your application or if you are a client of
 *    QuickTime's base media handler.
 *  
 *  Parameters:
 *    
 *    theTrack:
 *      The track identifier for which the rate of a track edit (at the
 *      time given in the atTime parameter) is to be determined.
 *    
 *    atTime:
 *      Indicates a time value at which the rate of a track edit (of a
 *      track identified in the parameter theTrack) is to be determined.
 *  
 *  Result:
 *    The rate of the track edit of the specified track at the
 *    specified time.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function GetTrackEditRate64( theTrack: Track; atTime: TimeValue64 ): Fixed; external name '_GetTrackEditRate64';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetTrackEditRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackEditRate( theTrack: Track; atTime: TimeValue ): Fixed; external name '_GetTrackEditRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Miscellaneous Routines
*************************}

{
 *  GetMovieDataSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieDataSize( theMovie: Movie; startTime: TimeValue; duration: TimeValue ): SIGNEDLONG; external name '_GetMovieDataSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieDataSize64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GetMovieDataSize64( theMovie: Movie; startTime: TimeValue; duration: TimeValue; var dataSize: wide ): OSErr; external name '_GetMovieDataSize64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackDataSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackDataSize( theTrack: Track; startTime: TimeValue; duration: TimeValue ): SIGNEDLONG; external name '_GetTrackDataSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackDataSize64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GetTrackDataSize64( theTrack: Track; startTime: TimeValue; duration: TimeValue; var dataSize: wide ): OSErr; external name '_GetTrackDataSize64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaDataSizeTime64()
 *  
 *  Summary:
 *    Determines the size, in bytes, of the sample data in a media
 *    segment. This function uses 64-bit time values and returns a
 *    64-bit size.
 *  
 *  Discussion:
 *    The only difference between this function and GetMediaDataSize64
 *    is that it uses 64-bit time values.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation.  Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *    
 *    startDisplayTime:
 *      A time value specifying the starting point of the segment in
 *      media display time.
 *    
 *    displayDuration:
 *      A time value that specifies the duration of the segment in
 *      media display time.
 *    
 *    dataSize:
 *      Points to a variable to receive the size, in bytes, of the
 *      sample data in the defined media segment.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function GetMediaDataSizeTime64( theMedia: Media; startDisplayTime: TimeValue64; displayDuration: TimeValue64; var dataSize: SInt64 ): OSErr; external name '_GetMediaDataSizeTime64';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMediaDataSize()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaDataSize( theMedia: Media; startTime: TimeValue; duration: TimeValue ): SIGNEDLONG; external name '_GetMediaDataSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaDataSize64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function GetMediaDataSize64( theMedia: Media; startTime: TimeValue; duration: TimeValue; var dataSize: wide ): OSErr; external name '_GetMediaDataSize64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PtInMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PtInMovie( theMovie: Movie; pt: Point ): Boolean; external name '_PtInMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PtInTrack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PtInTrack( theTrack: Track; pt: Point ): Boolean; external name '_PtInTrack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Group Selection Routines
*************************}

{
 *  SetMovieLanguage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieLanguage( theMovie: Movie; language: SIGNEDLONG ); external name '_SetMovieLanguage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* User Data
*************************}

{
 *  GetUserData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetUserData( theUserData: UserData; data: Handle; udType: OSType; index: SIGNEDLONG ): OSErr; external name '_GetUserData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AddUserData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function AddUserData( theUserData: UserData; data: Handle; udType: OSType ): OSErr; external name '_AddUserData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  RemoveUserData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function RemoveUserData( theUserData: UserData; udType: OSType; index: SIGNEDLONG ): OSErr; external name '_RemoveUserData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CountUserDataType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CountUserDataType( theUserData: UserData; udType: OSType ): SInt16; external name '_CountUserDataType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetNextUserDataType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetNextUserDataType( theUserData: UserData; udType: OSType ): SIGNEDLONG; external name '_GetNextUserDataType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetUserDataItem()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetUserDataItem( theUserData: UserData; data: UnivPtr; size: SIGNEDLONG; udType: OSType; index: SIGNEDLONG ): OSErr; external name '_GetUserDataItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetUserDataItem()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetUserDataItem( theUserData: UserData; data: UnivPtr; size: SIGNEDLONG; udType: OSType; index: SIGNEDLONG ): OSErr; external name '_SetUserDataItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AddUserDataText()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function AddUserDataText( theUserData: UserData; data: Handle; udType: OSType; index: SIGNEDLONG; itlRegionTag: SInt16 ): OSErr; external name '_AddUserDataText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetUserDataText()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetUserDataText( theUserData: UserData; data: Handle; udType: OSType; index: SIGNEDLONG; itlRegionTag: SInt16 ): OSErr; external name '_GetUserDataText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  RemoveUserDataText()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function RemoveUserDataText( theUserData: UserData; udType: OSType; index: SIGNEDLONG; itlRegionTag: SInt16 ): OSErr; external name '_RemoveUserDataText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewUserData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewUserData( var theUserData: UserData ): OSErr; external name '_NewUserData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeUserData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DisposeUserData( theUserData: UserData ): OSErr; external name '_DisposeUserData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewUserDataFromHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewUserDataFromHandle( h: Handle; var theUserData: UserData ): OSErr; external name '_NewUserDataFromHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  PutUserDataIntoHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PutUserDataIntoHandle( theUserData: UserData; h: Handle ): OSErr; external name '_PutUserDataIntoHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	kQTCopyUserDataReplace = FourCharCode('rplc'); { Delete all destination user data items and then add source user data items }
	kQTCopyUserDataMerge = FourCharCode('merg'); { Add source user data items to destination user data }

{
 *  CopyMovieUserData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function CopyMovieUserData( srcMovie: Movie; dstMovie: Movie; copyRule: OSType ): OSErr; external name '_CopyMovieUserData';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  CopyTrackUserData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function CopyTrackUserData( srcTrack: Track; dstTrack: Track; copyRule: OSType ): OSErr; external name '_CopyTrackUserData';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  CopyMediaUserData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function CopyMediaUserData( srcMedia: Media; dstMedia: Media; copyRule: OSType ): OSErr; external name '_CopyMediaUserData';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  CopyUserData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function CopyUserData( srcUserData: UserData; dstUserData: UserData; copyRule: OSType ): OSErr; external name '_CopyUserData';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  SetMoviePropertyAtom()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function SetMoviePropertyAtom( theMovie: Movie; propertyAtom: QTAtomContainer ): OSErr; external name '_SetMoviePropertyAtom';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMoviePropertyAtom()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function GetMoviePropertyAtom( theMovie: Movie; var propertyAtom: QTAtomContainer ): OSErr; external name '_GetMoviePropertyAtom';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaNextInterestingDecodeTime()
 *  
 *  Summary:
 *    Searches for decode times of interest in a media.
 *  
 *  Discussion:
 *    This function takes the same flags as GetMediaNextInterestingTime.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation.  Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *    
 *    interestingTimeFlags:
 *      Contains flags that determine the search criteria. Note that
 *      you may set only one of the nextTimeMediaSample,
 *      nextTimeMediaEdit or nextTimeSyncSample flags to 1.  Set unused
 *      flags to 0.
 *    
 *    decodeTime:
 *      Specifies a time value that establishes the starting point for
 *      the search. This time value must be expressed in the media's
 *      time scale.
 *    
 *    rate:
 *      The search direction. Negative values cause the Movie Toolbox
 *      to search backward from the starting point specified in the
 *      decodeTime parameter. Other values cause a forward search.
 *    
 *    interestingDecodeTime:
 *      A pointer to a time value. The Movie Toolbox returns the first
 *      decode time value it finds that meets the search criteria
 *      specified in the flags parameter. This time value is in the
 *      media's time scale. If there are no times that meet the search
 *      criteria you specify, the Movie Toolbox sets this value to -1.
 *      Set this parameter to NULL if you are not interested in this
 *      information.
 *    
 *    interestingDecodeDuration:
 *      A pointer to a time value. The Movie Toolbox returns the decode
 *      duration of the interesting time. This time value is in the
 *      media's time coordinate system. Set this parameter to NULL if
 *      you don't want this information; this lets the function work
 *      faster.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
procedure GetMediaNextInterestingDecodeTime( theMedia: Media; interestingTimeFlags: SInt16; decodeTime: TimeValue64; rate: Fixed; var interestingDecodeTime: TimeValue64; var interestingDecodeDuration: TimeValue64 ); external name '_GetMediaNextInterestingDecodeTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMediaNextInterestingDisplayTime()
 *  
 *  Summary:
 *    Searches for display times of interest in a media.
 *  
 *  Discussion:
 *    This function takes the same flags as GetMediaNextInterestingTime.
 *  
 *  Parameters:
 *    
 *    theMedia:
 *      The media for this operation.  Your application obtains this
 *      media identifier from such functions as NewTrackMedia and
 *      GetTrackMedia.
 *    
 *    interestingTimeFlags:
 *      Contains flags that determine the search criteria. Note that
 *      you may set only one of the nextTimeMediaSample,
 *      nextTimeMediaEdit or nextTimeSyncSample flags to 1. Set unused
 *      flags to 0.
 *    
 *    displayTime:
 *      Specifies a time value that establishes the starting point for
 *      the search. This time value must be expressed in the media's
 *      time scale.
 *    
 *    rate:
 *      The search direction. Negative values cause the Movie Toolbox
 *      to search backward from the starting point specified in the
 *      time parameter. Other values cause a forward search.
 *    
 *    interestingDisplayTime:
 *      A pointer to a time value. The Movie Toolbox returns the first
 *      display time value it finds that meets the search criteria
 *      specified in the flags parameter. This time value is in the
 *      media's time scale. If there are no times that meet the search
 *      criteria you specify, the Movie Toolbox sets this value to -1.
 *      Set this parameter to NULL if you are not interested in this
 *      information.
 *    
 *    interestingDisplayDuration:
 *      A pointer to a time value. The Movie Toolbox returns the
 *      display duration of the interesting time. This time value is in
 *      the media's time coordinate system. Set this parameter to NULL
 *      if you don't want this information; this lets the function work
 *      faster.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
procedure GetMediaNextInterestingDisplayTime( theMedia: Media; interestingTimeFlags: SInt16; displayTime: TimeValue64; rate: Fixed; var interestingDisplayTime: TimeValue64; var interestingDisplayDuration: TimeValue64 ); external name '_GetMediaNextInterestingDisplayTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMediaNextInterestingTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetMediaNextInterestingTime( theMedia: Media; interestingTimeFlags: SInt16; time: TimeValue; rate: Fixed; var interestingTime: TimeValue; var interestingDuration: TimeValue ); external name '_GetMediaNextInterestingTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackNextInterestingTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetTrackNextInterestingTime( theTrack: Track; interestingTimeFlags: SInt16; time: TimeValue; rate: Fixed; var interestingTime: TimeValue; var interestingDuration: TimeValue ); external name '_GetTrackNextInterestingTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieNextInterestingTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetMovieNextInterestingTime( theMovie: Movie; interestingTimeFlags: SInt16; numMediaTypes: SInt16; whichMediaTypes: OSTypePtr; time: TimeValue; rate: Fixed; var interestingTime: TimeValue; var interestingDuration: TimeValue ); external name '_GetMovieNextInterestingTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CreateMovieFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CreateMovieFile( const (*var*) fileSpec: FSSpec; creator: OSType; scriptTag: ScriptCode; createMovieFileFlags: SIGNEDLONG; var resRefNum: SInt16; var newmovie: Movie ): OSErr; external name '_CreateMovieFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  OpenMovieFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function OpenMovieFile( const (*var*) fileSpec: FSSpec; var resRefNum: SInt16; permission: SInt8 ): OSErr; external name '_OpenMovieFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CloseMovieFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CloseMovieFile( resRefNum: SInt16 ): OSErr; external name '_CloseMovieFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DeleteMovieFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function DeleteMovieFile( const (*var*) fileSpec: FSSpec ): OSErr; external name '_DeleteMovieFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewMovieFromFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewMovieFromFile( var theMovie: Movie; resRefNum: SInt16; resId: SInt16Ptr { can be NULL }; resName: StringPtr; newMovieFlags: SInt16; dataRefWasChanged: BooleanPtr { can be NULL } ): OSErr; external name '_NewMovieFromFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewMovieFromHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewMovieFromHandle( var theMovie: Movie; h: Handle; newMovieFlags: SInt16; var dataRefWasChanged: Boolean ): OSErr; external name '_NewMovieFromHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewMovieFromDataFork()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewMovieFromDataFork( var theMovie: Movie; fRefNum: SInt16; fileOffset: SIGNEDLONG; newMovieFlags: SInt16; var dataRefWasChanged: Boolean ): OSErr; external name '_NewMovieFromDataFork';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewMovieFromDataFork64()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function NewMovieFromDataFork64( var theMovie: Movie; fRefNum: SIGNEDLONG; const (*var*) fileOffset: wide; newMovieFlags: SInt16; var dataRefWasChanged: Boolean ): OSErr; external name '_NewMovieFromDataFork64';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewMovieFromUserProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewMovieFromUserProc( var m: Movie; flags: SInt16; var dataRefWasChanged: Boolean; getProc: GetMovieUPP; refCon: UnivPtr; defaultDataRef: Handle; dataRefType: OSType ): OSErr; external name '_NewMovieFromUserProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewMovieFromDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewMovieFromDataRef( var m: Movie; flags: SInt16; var id: SInt16; dataRef: Handle; dataRefType: OSType ): OSErr; external name '_NewMovieFromDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewMovieFromStorageOffset()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function NewMovieFromStorageOffset( var theMovie: Movie; dh: DataHandler; const (*var*) fileOffset: wide; newMovieFlags: SInt16; var dataRefWasChanged: Boolean ): OSErr; external name '_NewMovieFromStorageOffset';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  NewMovieForDataRefFromHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function NewMovieForDataRefFromHandle( var theMovie: Movie; h: Handle; newMovieFlags: SInt16; var dataRefWasChanged: Boolean; dataRef: Handle; dataRefType: OSType ): OSErr; external name '_NewMovieForDataRefFromHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  AddMovieResource()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function AddMovieResource( theMovie: Movie; resRefNum: SInt16; var resId: SInt16; const (*var*) resName: Str255 ): OSErr; external name '_AddMovieResource';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  UpdateMovieResource()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function UpdateMovieResource( theMovie: Movie; resRefNum: SInt16; resId: SInt16; const (*var*) resName: Str255 ): OSErr; external name '_UpdateMovieResource';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  RemoveMovieResource()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function RemoveMovieResource( resRefNum: SInt16; resId: SInt16 ): OSErr; external name '_RemoveMovieResource';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CreateMovieStorage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function CreateMovieStorage( dataRef: Handle; dataRefType: OSType; creator: OSType; scriptTag: ScriptCode; createMovieFileFlags: SIGNEDLONG; var outDataHandler: DataHandler; var newmovie: Movie ): OSErr; external name '_CreateMovieStorage';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  OpenMovieStorage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function OpenMovieStorage( dataRef: Handle; dataRefType: OSType; flags: SIGNEDLONG; var outDataHandler: DataHandler ): OSErr; external name '_OpenMovieStorage';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  CloseMovieStorage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function CloseMovieStorage( dh: DataHandler ): OSErr; external name '_CloseMovieStorage';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  DeleteMovieStorage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function DeleteMovieStorage( dataRef: Handle; dataRefType: OSType ): OSErr; external name '_DeleteMovieStorage';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  AddMovieToStorage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function AddMovieToStorage( theMovie: Movie; dh: DataHandler ): OSErr; external name '_AddMovieToStorage';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  UpdateMovieInStorage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function UpdateMovieInStorage( theMovie: Movie; dh: DataHandler ): OSErr; external name '_UpdateMovieInStorage';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  HasMovieChanged()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function HasMovieChanged( theMovie: Movie ): Boolean; external name '_HasMovieChanged';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClearMovieChanged()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure ClearMovieChanged( theMovie: Movie ); external name '_ClearMovieChanged';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieDefaultDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetMovieDefaultDataRef( theMovie: Movie; dataRef: Handle; dataRefType: OSType ): OSErr; external name '_SetMovieDefaultDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieDefaultDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieDefaultDataRef( theMovie: Movie; var dataRef: Handle; var dataRefType: OSType ): OSErr; external name '_GetMovieDefaultDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieAnchorDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function SetMovieAnchorDataRef( theMovie: Movie; dataRef: Handle; dataRefType: OSType ): OSErr; external name '_SetMovieAnchorDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieAnchorDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function GetMovieAnchorDataRef( theMovie: Movie; var dataRef: Handle; var dataRefType: OSType; var outFlags: SIGNEDLONG ): OSErr; external name '_GetMovieAnchorDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieColorTable()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetMovieColorTable( theMovie: Movie; ctab: CTabHandle ): OSErr; external name '_SetMovieColorTable';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieColorTable()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieColorTable( theMovie: Movie; var ctab: CTabHandle ): OSErr; external name '_GetMovieColorTable';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlattenMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure FlattenMovie( theMovie: Movie; movieFlattenFlags: SIGNEDLONG; const (*var*) theFile: FSSpec; creator: OSType; scriptTag: ScriptCode; createMovieFileFlags: SIGNEDLONG; var resId: SInt16; const (*var*) resName: Str255 ); external name '_FlattenMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlattenMovieData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function FlattenMovieData( theMovie: Movie; movieFlattenFlags: SIGNEDLONG; const (*var*) theFile: FSSpec; creator: OSType; scriptTag: ScriptCode; createMovieFileFlags: SIGNEDLONG ): Movie; external name '_FlattenMovieData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlattenMovieDataToDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function FlattenMovieDataToDataRef( theMovie: Movie; movieFlattenFlags: SIGNEDLONG; dataRef: Handle; dataRefType: OSType; creator: OSType; scriptTag: ScriptCode; createMovieFileFlags: SIGNEDLONG ): Movie; external name '_FlattenMovieDataToDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  SetMovieProgressProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieProgressProc( theMovie: Movie; p: MovieProgressUPP; refcon: SIGNEDLONG ); external name '_SetMovieProgressProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieProgressProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
procedure GetMovieProgressProc( theMovie: Movie; var p: MovieProgressUPP; var refcon: SIGNEDLONG ); external name '_GetMovieProgressProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CreateShortcutMovieFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function CreateShortcutMovieFile( const (*var*) fileSpec: FSSpec; creator: OSType; scriptTag: ScriptCode; createMovieFileFlags: SIGNEDLONG; targetDataRef: Handle; targetDataRefType: OSType ): OSErr; external name '_CreateShortcutMovieFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieSearchText()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MovieSearchText( theMovie: Movie; text: Ptr; size: SIGNEDLONG; searchFlags: SIGNEDLONG; var searchTrack: Track; var searchTime: TimeValue; var searchOffset: SIGNEDLONG ): OSErr; external name '_MovieSearchText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetPosterBox()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetPosterBox( theMovie: Movie; var boxRect: Rect ); external name '_GetPosterBox';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetPosterBox()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetPosterBox( theMovie: Movie; const (*var*) boxRect: Rect ); external name '_SetPosterBox';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieSegmentDisplayBoundsRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieSegmentDisplayBoundsRgn( theMovie: Movie; time: TimeValue; duration: TimeValue ): RgnHandle; external name '_GetMovieSegmentDisplayBoundsRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackSegmentDisplayBoundsRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackSegmentDisplayBoundsRgn( theTrack: Track; time: TimeValue; duration: TimeValue ): RgnHandle; external name '_GetTrackSegmentDisplayBoundsRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieCoverProcs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieCoverProcs( theMovie: Movie; uncoverProc: MovieRgnCoverUPP; coverProc: MovieRgnCoverUPP; refcon: SIGNEDLONG ); external name '_SetMovieCoverProcs';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieCoverProcs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieCoverProcs( theMovie: Movie; var uncoverProc: MovieRgnCoverUPP; var coverProc: MovieRgnCoverUPP; var refcon: SIGNEDLONG ): OSErr; external name '_GetMovieCoverProcs';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackStatus()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackStatus( theTrack: Track ): ComponentResult; external name '_GetTrackStatus';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieStatus()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieStatus( theMovie: Movie; var firstProblemTrack: Track ): ComponentResult; external name '_GetMovieStatus';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	kMovieLoadStateError = -1;
	kMovieLoadStateLoading = 1000;
	kMovieLoadStateLoaded = 2000;
	kMovieLoadStatePlayable = 10000;
	kMovieLoadStatePlaythroughOK = 20000;
	kMovieLoadStateComplete = 100000;

{
 *  GetMovieLoadState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function GetMovieLoadState( theMovie: Movie ): SIGNEDLONG; external name '_GetMovieLoadState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{***
    Thread related Movie routines
***}
{
 *  AttachMovieToCurrentThread()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function AttachMovieToCurrentThread( m: Movie ): OSErr; external name '_AttachMovieToCurrentThread';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  DetachMovieFromCurrentThread()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function DetachMovieFromCurrentThread( m: Movie ): OSErr; external name '_DetachMovieFromCurrentThread';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  GetMovieThreadAttachState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieThreadAttachState( m: Movie; var outAttachedToCurrentThread: Boolean; var outAttachedToAnyThread: Boolean ): OSErr; external name '_GetMovieThreadAttachState';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{***
    CanQuickTimeOpenFile, etc.
***}
{ Input flags for CanQuickTimeOpenFile/DataRef }
const
	kQTDontUseDataToFindImporter = 1 shl 0;
	kQTDontLookForMovieImporterIfGraphicsImporterFound = 1 shl 1;
	kQTAllowOpeningStillImagesAsMovies = 1 shl 2;
	kQTAllowImportersThatWouldCreateNewFile = 1 shl 3;
	kQTAllowAggressiveImporters = 1 shl 4; { eg, TEXT and PICT movie importers}

{ Determines whether the file could be opened using a graphics importer or opened in place as a movie. }
{
 *  CanQuickTimeOpenFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function CanQuickTimeOpenFile( fileSpec: FSSpecPtr; fileType: OSType; fileNameExtension: OSType; var outCanOpenWithGraphicsImporter: Boolean; var outCanOpenAsMovie: Boolean; var outPreferGraphicsImporter: Boolean; inFlags: UInt32 ): OSErr; external name '_CanQuickTimeOpenFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Determines whether the file could be opened using a graphics importer or opened in place as a movie. }
{
 *  CanQuickTimeOpenDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function CanQuickTimeOpenDataRef( dataRef: Handle; dataRefType: OSType; var outCanOpenWithGraphicsImporter: Boolean; var outCanOpenAsMovie: Boolean; var outPreferGraphicsImporter: Boolean; inFlags: UInt32 ): OSErr; external name '_CanQuickTimeOpenDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{***
    Data Reference Utilities
***}
const
	kQTNativeDefaultPathStyle = -1;
	kQTPOSIXPathStyle = 0;
	kQTHFSPathStyle = 1;
	kQTWindowsPathStyle = 2;


type
	QTPathStyle = UNSIGNEDLONG;
{
 *  QTNewDataReferenceFromFSRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTNewDataReferenceFromFSRef( const (*var*) fileRef: FSRef; flags: UInt32; var outDataRef: Handle; var outDataRefType: OSType ): OSErr; external name '_QTNewDataReferenceFromFSRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTNewDataReferenceFromFSRefCFString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTNewDataReferenceFromFSRefCFString( const (*var*) directoryRef: FSRef; fileName: CFStringRef; flags: UInt32; var outDataRef: Handle; var outDataRefType: OSType ): OSErr; external name '_QTNewDataReferenceFromFSRefCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTNewDataReferenceFromFSSpec()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTNewDataReferenceFromFSSpec( const (*var*) fsspec_: FSSpec; flags: UInt32; var outDataRef: Handle; var outDataRefType: OSType ): OSErr; external name '_QTNewDataReferenceFromFSSpec';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTNewDataReferenceWithDirectoryCFString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTNewDataReferenceWithDirectoryCFString( inDataRef: Handle; inDataRefType: OSType; targetName: CFStringRef; flags: UInt32; var outDataRef: Handle; var outDataRefType: OSType ): OSErr; external name '_QTNewDataReferenceWithDirectoryCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTNewDataReferenceFromFullPathCFString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTNewDataReferenceFromFullPathCFString( filePath: CFStringRef; pathStyle: QTPathStyle; flags: UInt32; var outDataRef: Handle; var outDataRefType: OSType ): OSErr; external name '_QTNewDataReferenceFromFullPathCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTNewDataReferenceFromCFURL()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTNewDataReferenceFromCFURL( url: CFURLRef; flags: UInt32; var outDataRef: Handle; var outDataRefType: OSType ): OSErr; external name '_QTNewDataReferenceFromCFURL';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTNewDataReferenceFromURLCFString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTNewDataReferenceFromURLCFString( urlString: CFStringRef; flags: UInt32; var outDataRef: Handle; var outDataRefType: OSType ): OSErr; external name '_QTNewDataReferenceFromURLCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTGetDataReferenceDirectoryDataReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTGetDataReferenceDirectoryDataReference( dataRef: Handle; dataRefType: OSType; flags: UInt32; var outDataRef: Handle; var outDataRefType: OSType ): OSErr; external name '_QTGetDataReferenceDirectoryDataReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTGetDataReferenceTargetNameCFString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTGetDataReferenceTargetNameCFString( dataRef: Handle; dataRefType: OSType; var name: CFStringRef ): OSErr; external name '_QTGetDataReferenceTargetNameCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTGetDataReferenceFullPathCFString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTGetDataReferenceFullPathCFString( dataRef: Handle; dataRefType: OSType; style: QTPathStyle; var outPath: CFStringRef ): OSErr; external name '_QTGetDataReferenceFullPathCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTGetDataHandlerDirectoryDataReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTGetDataHandlerDirectoryDataReference( dh: DataHandler; flags: UInt32; var outDataRef: Handle; var outDataRefType: OSType ): OSErr; external name '_QTGetDataHandlerDirectoryDataReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTGetDataHandlerTargetNameCFString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTGetDataHandlerTargetNameCFString( dh: DataHandler; var fileName: CFStringRef ): OSErr; external name '_QTGetDataHandlerTargetNameCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTGetDataHandlerFullPathCFString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTGetDataHandlerFullPathCFString( dh: DataHandler; style: QTPathStyle; var outPath: CFStringRef ): OSErr; external name '_QTGetDataHandlerFullPathCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{***
    Movie Controller support routines
***}
{
 *  NewMovieController()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewMovieController( theMovie: Movie; const (*var*) movieRect: Rect; someFlags: SIGNEDLONG ): ComponentInstance; external name '_NewMovieController';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeMovieController()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure DisposeMovieController( mc: ComponentInstance ); external name '_DisposeMovieController';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ShowMovieInformation()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure ShowMovieInformation( theMovie: Movie; filterProc: ModalFilterUPP; refCon: SIGNEDLONG ); external name '_ShowMovieInformation';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{****
    Scrap routines
****}
{
 *  PutMovieOnScrap()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function PutMovieOnScrap( theMovie: Movie; movieScrapFlags: SIGNEDLONG ): OSErr; external name '_PutMovieOnScrap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewMovieFromScrap()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewMovieFromScrap( newMovieFlags: SIGNEDLONG ): Movie; external name '_NewMovieFromScrap';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{****
    DataRef routines
****}

{
 *  GetMediaDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaDataRef( theMedia: Media; index: SInt16; var dataRef: Handle; var dataRefType: OSType; var dataRefAttributes: SIGNEDLONG ): OSErr; external name '_GetMediaDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetMediaDataRef( theMedia: Media; index: SInt16; dataRef: Handle; dataRefType: OSType ): OSErr; external name '_SetMediaDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaDataRefAttributes()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetMediaDataRefAttributes( theMedia: Media; index: SInt16; dataRefAttributes: SIGNEDLONG ): OSErr; external name '_SetMediaDataRefAttributes';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AddMediaDataRef()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function AddMediaDataRef( theMedia: Media; var index: SInt16; dataRef: Handle; dataRefType: OSType ): OSErr; external name '_AddMediaDataRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaDataRefCount()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaDataRefCount( theMedia: Media; var count: SInt16 ): OSErr; external name '_GetMediaDataRefCount';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTNewAlias()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTNewAlias( const (*var*) fss: FSSpec; var alias: AliasHandle; minimal: Boolean ): OSErr; external name '_QTNewAlias';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{****
    Playback hint routines
****}
{
 *  SetMoviePlayHints()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMoviePlayHints( theMovie: Movie; flags: SIGNEDLONG; flagsMask: SIGNEDLONG ); external name '_SetMoviePlayHints';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaPlayHints()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMediaPlayHints( theMedia: Media; flags: SIGNEDLONG; flagsMask: SIGNEDLONG ); external name '_SetMediaPlayHints';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaPlayHints()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetMediaPlayHints( theMedia: Media; var flags: SIGNEDLONG ); external name '_GetMediaPlayHints';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{****
    Load time track hints
****}
const
	preloadAlways = 1 shl 0;
	preloadOnlyIfEnabled = 1 shl 1;

{
 *  SetTrackLoadSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTrackLoadSettings( theTrack: Track; preloadTime: TimeValue; preloadDuration: TimeValue; preloadFlags: SIGNEDLONG; defaultHints: SIGNEDLONG ); external name '_SetTrackLoadSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackLoadSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure GetTrackLoadSettings( theTrack: Track; var preloadTime: TimeValue; var preloadDuration: TimeValue; var preloadFlags: SIGNEDLONG; var defaultHints: SIGNEDLONG ); external name '_GetTrackLoadSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{****
    Big screen TV
****}
const
	fullScreenHideCursor = 1 shl 0;
	fullScreenAllowEvents = 1 shl 1;
	fullScreenDontChangeMenuBar = 1 shl 2;
	fullScreenPreflightSize = 1 shl 3;
	fullScreenDontSwitchMonitorResolution = 1 shl 4;
	fullScreenCaptureDisplay = 1 shl 5; { capturedisplay is a mac os x specific parameter }
	fullScreenCaptureAllDisplays = 1 shl 6; { capturealldisplays is a mac os x specific parameter }

{
 *  BeginFullScreen()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function BeginFullScreen( var restoreState: Ptr; whichGD: GDHandle; var desiredWidth: SInt16; var desiredHeight: SInt16; var newWindow: WindowRef; var eraseColor: RGBColor; flags: SIGNEDLONG ): OSErr; external name '_BeginFullScreen';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  EndFullScreen()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function EndFullScreen( fullState: Ptr; flags: SIGNEDLONG ): OSErr; external name '_EndFullScreen';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{****
    Wired Actions
****}
{ flags for MovieExecuteWiredActions}
const
	movieExecuteWiredActionDontExecute = 1 shl 0;

{
 *  AddMovieExecuteWiredActionsProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function AddMovieExecuteWiredActionsProc( theMovie: Movie; proc: MovieExecuteWiredActionsUPP; refCon: UnivPtr ): OSErr; external name '_AddMovieExecuteWiredActionsProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  RemoveMovieExecuteWiredActionsProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function RemoveMovieExecuteWiredActionsProc( theMovie: Movie; proc: MovieExecuteWiredActionsUPP; refCon: UnivPtr ): OSErr; external name '_RemoveMovieExecuteWiredActionsProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieExecuteWiredActions()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function MovieExecuteWiredActions( theMovie: Movie; flags: SIGNEDLONG; actions: QTAtomContainer ): OSErr; external name '_MovieExecuteWiredActions';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{****
    Keyboard Navigation/Editable Text Field Support
****}
{
   Navigation Direction Constants
        for MediaNavigateTargetRefCon
}
const
	kRefConNavigationNext = 0;
	kRefConNavigationPrevious = 1;

{
   Refcon Properties 
        for MediaRefConGetProerty/MediaRefConSetProperty
}
const
	kRefConPropertyCanHaveFocus = 1;    { Boolean }
	kRefConPropertyHasFocus = 2;     { Boolean }

{ media properties}
const
	kTrackFocusCanEditFlag = FourCharCode('kedt');
	kTrackDefaultFocusFlags = FourCharCode('kfoc');
	kTrackFocusDefaultRefcon = FourCharCode('kref');

{ focus flags}
const
	kTrackFocusOn = 1;
	kTrackHandlesTabs = 2;     { this is reserved for a future release}

{****
    Flash track properties
****}
const
	kFlashTrackPropertyAcceptAllClicks = FourCharCode('clik'); { type of media property atom; data is a Boolean }

{****
    Sprite Toolbox
****}
const
	kBackgroundSpriteLayerNum = 32767;


{  Sprite Properties}
const
	kSpritePropertyMatrix = 1;
	kSpritePropertyImageDescription = 2;
	kSpritePropertyImageDataPtr = 3;
	kSpritePropertyVisible = 4;
	kSpritePropertyLayer = 5;
	kSpritePropertyGraphicsMode = 6;
	kSpritePropertyImageDataSize = 7;
	kSpritePropertyActionHandlingSpriteID = 8;
	kSpritePropertyCanBeHitTested = 9;
	kSpritePropertyImageIndex = 100;
	kSpriteTrackPropertyBackgroundColor = 101;
	kSpriteTrackPropertyOffscreenBitDepth = 102;
	kSpriteTrackPropertySampleFormat = 103;
	kSpriteTrackPropertyScaleSpritesToScaleWorld = 104;
	kSpriteTrackPropertyHasActions = 105;
	kSpriteTrackPropertyVisible = 106;
	kSpriteTrackPropertyQTIdleEventsFrequency = 107;
	kSpriteTrackPropertyAllSpritesHitTestingMode = 108;
	kSpriteTrackPropertyPreferredDepthInterpretationMode = 109;
	kSpriteImagePropertyRegistrationPoint = 1000;
	kSpriteImagePropertyGroupID = 1001;

{ values for kSpriteTrackPropertyPreferredDepthInterpretationMode}
const
	kSpriteTrackPreferredDepthCompatibilityMode = 0;
	kSpriteTrackPreferredDepthModernMode = 1;

{ values for kSpriteTrackPropertyAllSpritesHitTestingMode}
const
	kSpriteHitTestUseSpritesOwnPropertiesMode = 0;
	kSpriteHitTestTreatAllSpritesAsHitTestableMode = 1;
	kSpriteHitTestTreatAllSpritesAsNotHitTestableMode = 2;

{ special value for kSpriteTrackPropertyQTIdleEventsFrequency (the default)}
const
	kNoQTIdleEvents = -1;

{ GetSpriteProperties for accessing invalid SpriteWorldRegion}
const
	kGetSpriteWorldInvalidRegionAndLeaveIntact = -1;
	kGetSpriteWorldInvalidRegionAndThenSetEmpty = -2;

{ flagsIn for SpriteWorldIdle}
const
	kOnlyDrawToSpriteWorld = 1 shl 0;
	kSpriteWorldPreflight = 1 shl 1;

{ flagsOut for SpriteWorldIdle}
const
	kSpriteWorldDidDraw = 1 shl 0;
	kSpriteWorldNeedsToDraw = 1 shl 1;

{ flags for sprite track sample format}
const
	kKeyFrameAndSingleOverride = 1 shl 1;
	kKeyFrameAndAllOverrides = 1 shl 2;

{ sprite world flags}
const
	kScaleSpritesToScaleWorld = 1 shl 1;
	kSpriteWorldHighQuality = 1 shl 2;
	kSpriteWorldDontAutoInvalidate = 1 shl 3;
	kSpriteWorldInvisible = 1 shl 4;
	kSpriteWorldDirtyInsteadOfFlush = 1 shl 5;

{
 *  NewSpriteWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewSpriteWorld( var newSpriteWorld: SpriteWorld; destination: GWorldPtr; spriteLayer: GWorldPtr; var backgroundColor: RGBColor; background: GWorldPtr ): OSErr; external name '_NewSpriteWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeSpriteWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure DisposeSpriteWorld( theSpriteWorld: SpriteWorld ); external name '_DisposeSpriteWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetSpriteWorldClip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetSpriteWorldClip( theSpriteWorld: SpriteWorld; clipRgn: RgnHandle ): OSErr; external name '_SetSpriteWorldClip';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetSpriteWorldMatrix()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetSpriteWorldMatrix( theSpriteWorld: SpriteWorld; const (*var*) matrix: MatrixRecord ): OSErr; external name '_SetSpriteWorldMatrix';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetSpriteWorldGraphicsMode()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetSpriteWorldGraphicsMode( theSpriteWorld: SpriteWorld; mode: SIGNEDLONG; const (*var*) opColor: RGBColor ): OSErr; external name '_SetSpriteWorldGraphicsMode';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteWorldIdle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteWorldIdle( theSpriteWorld: SpriteWorld; flagsIn: SIGNEDLONG; var flagsOut: SIGNEDLONG ): OSErr; external name '_SpriteWorldIdle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  InvalidateSpriteWorld()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function InvalidateSpriteWorld( theSpriteWorld: SpriteWorld; var invalidArea: Rect ): OSErr; external name '_InvalidateSpriteWorld';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteWorldHitTest()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteWorldHitTest( theSpriteWorld: SpriteWorld; flags: SIGNEDLONG; loc: Point; var spriteHit: Sprite ): OSErr; external name '_SpriteWorldHitTest';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteHitTest()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteHitTest( theSprite: Sprite; flags: SIGNEDLONG; loc: Point; var wasHit: Boolean ): OSErr; external name '_SpriteHitTest';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeAllSprites()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure DisposeAllSprites( theSpriteWorld: SpriteWorld ); external name '_DisposeAllSprites';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetSpriteWorldFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetSpriteWorldFlags( spriteWorld_: SpriteWorld; flags: SIGNEDLONG; flagsMask: SIGNEDLONG ): OSErr; external name '_SetSpriteWorldFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  NewSprite()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewSprite( var newSprite: Sprite; itsSpriteWorld: SpriteWorld; idh: ImageDescriptionHandle; imageDataPtr: Ptr; var matrix: MatrixRecord; visible: Boolean; layer: SInt16 ): OSErr; external name '_NewSprite';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeSprite()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure DisposeSprite( theSprite: Sprite ); external name '_DisposeSprite';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  InvalidateSprite()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure InvalidateSprite( theSprite: Sprite ); external name '_InvalidateSprite';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetSpriteProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetSpriteProperty( theSprite: Sprite; propertyType: SIGNEDLONG; propertyValue: UnivPtr ): OSErr; external name '_SetSpriteProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetSpriteProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetSpriteProperty( theSprite: Sprite; propertyType: SIGNEDLONG; propertyValue: UnivPtr ): OSErr; external name '_GetSpriteProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{****
    QT Atom Data Support
****}
const
	kParentAtomIsContainer = 0;

{ create and dispose QTAtomContainer objects}

{
 *  QTNewAtomContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTNewAtomContainer( var atomData: QTAtomContainer ): OSErr; external name '_QTNewAtomContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTDisposeAtomContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTDisposeAtomContainer( atomData: QTAtomContainer ): OSErr; external name '_QTDisposeAtomContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ locating nested atoms within QTAtomContainer container}

{
 *  QTGetNextChildType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTGetNextChildType( container: QTAtomContainer; parentAtom: QTAtom; currentChildType: QTAtomType ): QTAtomType; external name '_QTGetNextChildType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTCountChildrenOfType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTCountChildrenOfType( container: QTAtomContainer; parentAtom: QTAtom; childType: QTAtomType ): SInt16; external name '_QTCountChildrenOfType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTFindChildByIndex()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTFindChildByIndex( container: QTAtomContainer; parentAtom: QTAtom; atomType: QTAtomType; index: SInt16; var id: QTAtomID ): QTAtom; external name '_QTFindChildByIndex';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTFindChildByID()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTFindChildByID( container: QTAtomContainer; parentAtom: QTAtom; atomType: QTAtomType; id: QTAtomID; var index: SInt16 ): QTAtom; external name '_QTFindChildByID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTNextChildAnyType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTNextChildAnyType( container: QTAtomContainer; parentAtom: QTAtom; currentChild: QTAtom; var nextChild: QTAtom ): OSErr; external name '_QTNextChildAnyType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ set a leaf atom's data}
{
 *  QTSetAtomData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTSetAtomData( container: QTAtomContainer; atom: QTAtom; dataSize: SIGNEDLONG; atomData: UnivPtr ): OSErr; external name '_QTSetAtomData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ extracting data}
{
 *  QTCopyAtomDataToHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTCopyAtomDataToHandle( container: QTAtomContainer; atom: QTAtom; targetHandle: Handle ): OSErr; external name '_QTCopyAtomDataToHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTCopyAtomDataToPtr()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTCopyAtomDataToPtr( container: QTAtomContainer; atom: QTAtom; sizeOrLessOK: Boolean; size: SIGNEDLONG; targetPtr: UnivPtr; var actualSize: SIGNEDLONG ): OSErr; external name '_QTCopyAtomDataToPtr';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetAtomTypeAndID()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTGetAtomTypeAndID( container: QTAtomContainer; atom: QTAtom; var atomType: QTAtomType; var id: QTAtomID ): OSErr; external name '_QTGetAtomTypeAndID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ extract a copy of an atom and all of it's children, caller disposes}
{
 *  QTCopyAtom()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTCopyAtom( container: QTAtomContainer; atom: QTAtom; var targetContainer: QTAtomContainer ): OSErr; external name '_QTCopyAtom';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ obtaining direct reference to atom data}
{
 *  QTLockContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTLockContainer( container: QTAtomContainer ): OSErr; external name '_QTLockContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetAtomDataPtr()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTGetAtomDataPtr( container: QTAtomContainer; atom: QTAtom; var dataSize: SIGNEDLONG; var atomData: Ptr ): OSErr; external name '_QTGetAtomDataPtr';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTUnlockContainer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTUnlockContainer( container: QTAtomContainer ): OSErr; external name '_QTUnlockContainer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
   building QTAtomContainer trees
   creates and inserts new atom at specified index, existing atoms at or after index are moved toward end of list
   used for Top-Down tree creation
}
{
 *  QTInsertChild()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTInsertChild( container: QTAtomContainer; parentAtom: QTAtom; atomType: QTAtomType; id: QTAtomID; index: SInt16; dataSize: SIGNEDLONG; data: UnivPtr; var newAtom: QTAtom ): OSErr; external name '_QTInsertChild';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ inserts children from childrenContainer as children of parentAtom}
{
 *  QTInsertChildren()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTInsertChildren( container: QTAtomContainer; parentAtom: QTAtom; childrenContainer: QTAtomContainer ): OSErr; external name '_QTInsertChildren';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ destruction}
{
 *  QTRemoveAtom()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTRemoveAtom( container: QTAtomContainer; atom: QTAtom ): OSErr; external name '_QTRemoveAtom';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTRemoveChildren()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTRemoveChildren( container: QTAtomContainer; atom: QTAtom ): OSErr; external name '_QTRemoveChildren';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ replacement must be same type as target}
{
 *  QTReplaceAtom()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTReplaceAtom( targetContainer: QTAtomContainer; targetAtom: QTAtom; replacementContainer: QTAtomContainer; replacementAtom: QTAtom ): OSErr; external name '_QTReplaceAtom';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTSwapAtoms()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTSwapAtoms( container: QTAtomContainer; atom1: QTAtom; atom2: QTAtom ): OSErr; external name '_QTSwapAtoms';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTSetAtomID()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTSetAtomID( container: QTAtomContainer; atom: QTAtom; newID: QTAtomID ): OSErr; external name '_QTSetAtomID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetAtomParent()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function QTGetAtomParent( container: QTAtomContainer; childAtom: QTAtom ): QTAtom; external name '_QTGetAtomParent';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMediaPropertyAtom()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetMediaPropertyAtom( theMedia: Media; propertyAtom: QTAtomContainer ): OSErr; external name '_SetMediaPropertyAtom';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMediaPropertyAtom()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMediaPropertyAtom( theMedia: Media; var propertyAtom: QTAtomContainer ): OSErr; external name '_GetMediaPropertyAtom';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{****
    Tween Support
****}

type
	TweenRecordPtr = ^TweenRecord;
	TweenerDataProcPtr = function( tr: TweenRecordPtr; tweenData: UnivPtr; tweenDataSize: SIGNEDLONG; dataDescriptionSeed: SIGNEDLONG; dataDescription: Handle; asyncCompletionProc: ICMCompletionProcRecordPtr; transferProc: UniversalProcPtr; refCon: UnivPtr ): ComponentResult;
	TweenerDataUPP = TweenerDataProcPtr;
	TweenRecord = record
		version: SIGNEDLONG;

		container: QTAtomContainer;
		tweenAtom: QTAtom;
		dataAtom: QTAtom;
		percent: Fixed;

		dataProc: TweenerDataUPP;

		private1: UnivPtr;
		private2: UnivPtr;
	end;

type
	TweenV1RecordPtr = ^TweenV1Record;
	TweenV1Record = record
		version: SIGNEDLONG;

		container: QTAtomContainer;
		tweenAtom: QTAtom;
		dataAtom: QTAtom;
		percent: Fixed;

		dataProc: TweenerDataUPP;

		private1: UnivPtr;
		private2: UnivPtr;

		fractPercent: Fract;
	end;
const
	kTweenRecordNoFlags = 0;
	kTweenRecordIsAtInterruptTime = $00000001;

type
	TweenV2RecordPtr = ^TweenV2Record;
	TweenV2Record = record
		version: SIGNEDLONG;

		container: QTAtomContainer;
		tweenAtom: QTAtom;
		dataAtom: QTAtom;
		percent: Fixed;

		dataProc: TweenerDataUPP;

		private1: UnivPtr;
		private2: UnivPtr;

		fractPercent: Fract;

		flags: SIGNEDLONG;
	end;
{
 *  QTNewTween()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTNewTween( var tween: QTTweener; container: QTAtomContainer; tweenAtom: QTAtom; maxTime: TimeValue ): OSErr; external name '_QTNewTween';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTDisposeTween()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTDisposeTween( tween: QTTweener ): OSErr; external name '_QTDisposeTween';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTDoTween()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTDoTween( tween: QTTweener; atTime: TimeValue; result: Handle; var resultSize: SIGNEDLONG; tweenDataProc: TweenerDataUPP; tweenDataRefCon: UnivPtr ): OSErr; external name '_QTDoTween';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    QTDoTweenPtr is an interrupt-safe version of QTDoTween.  It has the following limitations:
     - not all tween types support this call (those which must allocated memory), in which case they return codecUnimpErr.
     - the QTAtomContainer used for the tween must be locked
     - the dataSize must be large enough to contain the result
     - this call is not supported for sequence tweens, use interpolation tweens instead
}
{
 *  QTDoTweenPtr()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTDoTweenPtr( tween: QTTweener; atTime: TimeValue; result: Ptr; resultSize: SIGNEDLONG ): OSErr; external name '_QTDoTweenPtr';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{****
    Preferences
****}
{
 *  GetQuickTimePreference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetQuickTimePreference( preferenceType: OSType; var preferenceAtom: QTAtomContainer ): OSErr; external name '_GetQuickTimePreference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetQuickTimePreference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetQuickTimePreference( preferenceType: OSType; preferenceAtom: QTAtomContainer ): OSErr; external name '_SetQuickTimePreference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{****
    Effects and dialog Support
****}
{ atom types for entries in the effects list}
const
	kEffectNameAtom = FourCharCode('name'); { name of effect }
	kEffectTypeAtom = FourCharCode('type'); { codec sub-type for effect }
	kEffectManufacturerAtom = FourCharCode('manu'); { codec manufacturer for effect }

type
	QTParamPreviewRecordPtr = ^QTParamPreviewRecord;
	QTParamPreviewRecord = record
		sourceID: SIGNEDLONG;               { 1 based source identifier}
		sourcePicture: PicHandle;          { picture for preview, must not dispose until dialog is disposed}
	end;
type
	QTParamPreviewPtr = QTParamPreviewRecordPtr;
	QTParamDialogEventRecordPtr = ^QTParamDialogEventRecord;
	QTParamDialogEventRecord = record
		theEvent: EventRecordPtr;               { Event received by the dialog }
		whichDialog: DialogRef;            { dialog that event was directed towards }
		itemHit: SInt16;                { dialog item which was hit }
	end;
type
	QTParamDialogEventPtr = QTParamDialogEventRecordPtr;
	QTParamFetchPreviewRecordPtr = ^QTParamFetchPreviewRecord;
	QTParamFetchPreviewRecord = record
		theWorld: GWorldPtr;               { the world into which to draw the preview }
		percentage: Fixed;             { frame percentage (from 0.0 - 1.0) to be drawn }
	end;
type
	QTParamFetchPreviewPtr = QTParamFetchPreviewRecordPtr;

{ Only available on OS X }
const
	kEffectParentWindowCarbon = FourCharCode('carb');
type
	QTEventLoopDescriptionRecordPtr = ^QTEventLoopDescriptionRecord;
	QTEventLoopDescriptionRecord = record
		recordSize: SIGNEDLONG;     { must be == sizeof(QTEventLoopDescriptionRecord) }
		windowRefKind: SIGNEDLONG;  { kind of window reference }
		parentWindow: UnivPtr;   { parent window (for sheets) or NIL to use Carbon FrontWindow() }
		eventTarget: UnivPtr;    { EventTargetRef to receive kHICommandOK and kHICommandCancel }
	end;
type
  QTEventLoopDescriptionPtr = QTEventLoopDescriptionRecordPtr;

const
	pdActionConfirmDialog = 1;    { no param}
	pdActionSetAppleMenu = 2;    { param is MenuRef}
	pdActionSetEditMenu = 3;    { param is MenuRef}
	pdActionGetDialogValues = 4;    { param is QTAtomContainer}
	pdActionSetPreviewUserItem = 5;    { param is long}
	pdActionSetPreviewPicture = 6;    { param is QTParamPreviewPtr;}
	pdActionSetColorPickerEventProc = 7;  { param is UserEventUPP}
	pdActionSetDialogTitle = 8;    { param is StringPtr }
	pdActionGetSubPanelMenu = 9;    { param is MenuRef* }
	pdActionActivateSubPanel = 10;   { param is long }
	pdActionConductStopAlert = 11;   { param is StringPtr }
	pdActionModelessCallback = 12;   { param is QTParamDialogEventPtr }
	pdActionFetchPreview = 13;   { param is QTParamFetchPreviewPtr }
	pdActionSetDialogSettings = 14;   { param is QTAtomContainer }
	pdActionGetDialogSettings = 15;   { param is QTAtomContainer }
	pdActionGetNextSample = 16;   { param is QTAtomContainer with effect sample to change - createdDialog may be NIL }
	pdActionGetPreviousSample = 17;   { param is QTAtomContainer with effect sample to change - createdDialog may be NIL }
	pdActionCompactSample = 18;   { param is QTAtomContainer with effect sample to compact, - createdDialog may be NIL }
	pdActionSetEditCallout = 19;   { param is QTParamPreviewCalloutPtr, can be NIL }
	pdActionSetSampleTime = 20;   { param is QTParamSampleTimePtr, can be NIL }
	pdActionDoEditCommand = 21;   { param is long with menu command (ie, mcMenuCut etc) }
	pdActionGetSubPanelMenuValue = 22;   { param is long and returns current sub-panel value selected by the effect }
                                        { Action codes and typedefs used for custom controls within effects }
	pdActionCustomNewControl = 23;   { param is QTCustomControlNewPtr }
	pdActionCustomDisposeControl = 24;   { param is QTCustomControlNewPtr }
	pdActionCustomPositionControl = 25;   { param is QTCustomControlPositionControlPtr }
	pdActionCustomShowHideControl = 26;   { param is QTCustomControlShowHideControlPtr }
	pdActionCustomHandleEvent = 27;   { param is QTCustomControlHandleEventPtr }
	pdActionCustomSetFocus = 28;   { param is QTCustomControlSetFocusPtr }
	pdActionCustomSetEditMenu = 29;   { param is QTCustomControlSetEditMenuPtr }
	pdActionCustomSetPreviewPicture = 30; { param is QTCustomControlSetPreviewPicturePtr }
	pdActionCustomSetEditCallout = 31;   { param is QTCustomControlSetEditCalloutPtr }
	pdActionCustomGetEnableValue = 32;   { param is QTCustomControlGetEnableValuePtr }
	pdActionCustomSetSampleTime = 33;   { param is QTCustomControlSetSampleTimePtr }
	pdActionCustomGetValue = 34;   { param is QTCustomControlGetValue }
	pdActionCustomDoEditCommand = 35;   { param is QTCustomControlDoEditCommand }
                                        { more actions for the dialog }
	pdActionRunInEventLoop = 36;   { param is QTEventLoopDescriptionPtr - OS X only}
	pdActionConvertSettingsToXML = 37;   { param is QTAtomContainer* inbound, Handle* outbound contains the XML - createdDialog may be NIL }
	pdActionConvertSettingsToXMLWithComments = 38; { param is QTAtomContainer* inbound, Handle* outbound contains the XML with comments - createdDialog may be NIL }
	pdActionConvertSettingsToText = 39;   { param is QTAtomContainer* inbound, Handle* outbound contains human readable text - createdDialog may be NIL }
	pdActionConvertXMLToSettings = 40;   { param is Handle* inbound, QTAtomContainer* outbound contains parameters - createdDialog may be NIL }
	pdActionSetPropertyComponent = 41;    { param is QTParamComponentPropertyPtr }

{ Sample Time information }
const
	pdSampleTimeDisplayOptionsNone = $00000000;

type
	QTParamComponentPropertyRecord = record
		component: ComponentInstance;              { component to call for get/set properties}
		defaultClass: OSType;           { default property class if not overriden by a given parameter}
	end;
type
	QTParamSampleTimeRecordPtr = ^QTParamSampleTimeRecord;
	QTParamSampleTimeRecord = record
		displayOptions: SIGNEDLONG;
		sampleStartTime: TimeRecord;
		sampleDuration: TimeValue;
		framesPerSecond: SIGNEDLONG;        { if 0, will cause revert to seconds display}
	end;
type
	QTParamSampleTimePtr = QTParamSampleTimeRecordPtr;
{ Preview change callout information }
type
	QTParamPreviewCalloutRecordPtr = ^QTParamPreviewCalloutRecord;
	QTParamPreviewCalloutRecord = record
		calloutProc: MoviePreviewCallOutUPP;        { called when user makes editing changes to dialog.  May be NIL.  You should return true from your function. }
		refCon: SIGNEDLONG;                 { passed to the callout procedure }
	end;
type
	QTParamPreviewCalloutPtr = QTParamPreviewCalloutRecordPtr;
const
	pdOptionsCollectOneValue = $00000001; { should collect a single value only}
	pdOptionsAllowOptionalInterpolations = $00000002; { non-novice interpolation options are shown }
	pdOptionsModalDialogBox = $00000004; { dialog box should be modal }
	pdOptionsEditCurrentEffectOnly = $00000008; { List of effects will not be shown }
	pdOptionsHidePreview = $00000010; { Preview item will not be shown }
	pdOptionsDisplayAsSheet = $00000020; { Dialog will be used as a sheet (on platforms that support it) }

type
	QTParameterDialogOptions = SIGNEDLONG;
{ ------- CUSTOM EFFECT CONTROLS}
{
    Effects may choose to implement custom controls to allow the user to more easily edit complex parameters
    that are ill-served by simple sliders or type in boxes.   Effects may allow a custom control for either
    a single parameter, or for a group of parameters.
    
    Parameter(s) for a custom control must still be data types defined by the standard set, or for
    complex records of data, must be defined within a group as individual parameters made up from base
    data types (for example, a point is a group containing two Fixed point numbers).  
    This is to allow applications that do not wish to use the custom control for the effect to set values themselves.
    
    Effects should be aware that these custom controls may be deployed by the application in either a dialog or
    a window, with application defined background colors or patterns, along with application defined font
    characteristics for the window.
    
    It is recommended that effects implement custom controls only when needed, and that custom controls be used
    for specific types of parameters (ie, point, rectangle, polygon, path) rather than the entire user interface
    for the effect.  Effects may choose to implement multiple custom controls which combine with standard controls
    to present the total user interface.  For effects which have very complex user interfaces not well suited for 
    inclusion within a single window, it is recommended to use kParameterImageIsPreset -- which allows the effect to
    have an external editing application for parameters which may then be set within the standard UI via the open file 
    dialog or drag and drop.  The Lens Flare effect's "Flare Type" is an example of such a preset.

    For parameters that use a custom control to control a single parameter value, a new behavior
    flag has been added (kCustomControl), and the behavior for the parameter should be kParameterItemControl.
    
    For parameters that are groups, the same flag (kCustomControl) should be used, and the behavior
    should be kParameterItemGroupDivider.  Groups with the kCustomControl bit set will be implemented
    by calling the custom control for that group -- the parameters within that group will not be processed
    in the normal manner.
    
    In both cases, the new customType and customID fields of the behavior must be filled in.  These are 
    used in order to allow your custom control to determine which parameter is being edited in the case
    where the custom control is used for the editing of multiple parameters.  These values are passed into
    the pdActionCustomNewControl call.  Since the custom control mechanism is also used by QuickTime's
    default effect dialogs, you should be prepared to pass onto the base effect any pdActionCustomNewControl
    calls for type/id pairs that you do not handle yourself.  When  pdActionCustomNewControl is called
    for controls of types handled by QuickTime, customType is kParameterAtomTypeAndID and customID is
    the ID of the parameter atom. 
}


{
    pdActionCustomNewControlControl is called by application to create a new custom control or set of controls
    for an effect parameter.  When pdActionCustomNewControl is called, the effect should perform any
    basic allocation it needs for storage and return the result in storage. The options parameter tells
    the control if the application wishes to support interpolated, optionally interpolated, or a single
    value parameter.
    
    Since pdActionCustomNewControlControl may be called upon your effect for other items within the
    dialog, it is recommended that your effect have an easy way to determine which controls it implements:
     a) by having storage be a pointer with an OSType at the begining to mark controls
        implemented by your code.
     - or -
     b) keeping track in your component globals those custom controls which you have created.
    
    When pdActionCustomDisposeControl is called any allocation done by the control should be disposed. In addition, 
    pdActionCustomDisposeControl is the last chance the control has to commit any user changes into the sample.
    Controls which implement type in fields typically need to commit any final user edits at this time.
}
type
	QTCustomControlNewRecordPtr = ^QTCustomControlNewRecord;
	QTCustomControlNewRecord = record
		storage: UnivPtr;                { storage allocated/disposed by the control}
		options: QTParameterDialogOptions;          { options used to control interpolation/not}
		sample: QTAtomContainer;                 { sample that holds the data to be edited}
		customType: SIGNEDLONG;             { custom type and ID specified by effect for creation of this control}
		customID: SIGNEDLONG;
	end;
type
	QTCustomControlNewPtr = QTCustomControlNewRecordPtr;
{
    pdActionCustomPositionControl is called by the application to position the control within a window or dialog.

    The control should determine if it will fit in the alloted area and position itself there.  It should also
    return the space taken up by the control.   Note you are free to implement controls which are variable in size depending upon
    which parameter you are editing.  You need not scale your control to the requested size.  If the area presented to your
    control is too small, set didFit to false.  You should still return in used the size you would have liked to use for
    the control.   The application will then try again with a new size.  Note that all
    controls must be able to fit within a minimum of 300 by 250 pixels.
    
    Custom controls that draw text should make note of the text font, size, and style at this time in order
    to properly display within application windows.
    
    Note that the default state for the control is hidden.  You will receive a pdActionCustomShowHideControl
    in order to enable your control.  You should not draw your control in response to pdActionCustomPositionControl.
}
type
	QTCustomControlPositionControlRecordPtr = ^QTCustomControlPositionControlRecord;
	QTCustomControlPositionControlRecord = record
		storage: UnivPtr;                { storage for the control}
		window: WindowPtr;                 { window to be used by the control}
		location: Rect;               { location within the window the control may use}
		used: Rect;                   { returned by the control to indicate size it actually used}
		didFit: Boolean;                 { did the control fit in the specified area?}
    pad: array [0..2] of Boolean;
	end;
type
	QTCustomControlPositionControlPtr = QTCustomControlPositionControlRecordPtr;
{
    pdActionCustomShowHideControl is called when the application wishes to enable/disable your control, or 
    completely disable drawing of the control
    
    Your control should make note of the new state (if different from the last) and perform an InvalRect()
    on your drawing area, or you may draw your control's initial state in the case of show.  You should not
    attempt to erase your control as the result of a hide -- instead call InvalRect() and allow the application
    to process the resulting event as appropriate.
}
type
	QTCustomControlShowHideControlRecordPtr = ^QTCustomControlShowHideControlRecord;
	QTCustomControlShowHideControlRecord = record
		storage: UnivPtr;                { storage for the control}
		show: Boolean;                   { display the control?}
		enable: Boolean;                 { enable the control (ie, black vs gray display)}
		pad: array [0..1] of Boolean;
	end;
type
	QTCustomControlShowHideControlPtr = QTCustomControlShowHideControlRecordPtr;
{
    pdActionCustomHandleEvent is called to allow your custom control to process events.
    
    Typical controls handle the following events:
        - activate - to draw your control in normal/gray mode
        - update - to draw your control
        - mouseDown - to handle clicks
        - keyDown - to handle typing when you have focus
        - idle - to perform idle drawing (if applicable)
    If your control handles the entire event, set didProcess to true.  If
    you handled the event, but other controls still need the event, set didProcess to false.
    
    If your control supports the concept of focus for the purposes of typing (such as by having
    a type-in box for the parameter) then you set the tookFocus Boolean as part of your processing
    of the event.  It is assumed that your control will draw the appropriate focus UI as a result, and
    the calling application will disable any focus drawing within the remainder of the UI.

    By default, custom controls are not given idle time.  If you need idle time, set needIdle to true
    in response to the even that causes you to need idle (typically the taking of focus, or the first draw).
    Your control will continue to be given idle events until you set needIdle to false in response to
    a nullEvent.
}
type
	QTCustomControlHandleEventRecordPtr = ^QTCustomControlHandleEventRecord;
	QTCustomControlHandleEventRecord = record
		storage: UnivPtr;                { storage for the control}
		pEvent: EventRecordPtr;                 { event to process}
		didProcess: Boolean;             { did we process entire event?}
		tookFocus: Boolean;              { did we take focus as a result of this event (typically mouseDowns)}
		needIdle: Boolean;               { does this control need idle events?}
		didEdit: Boolean;                { did we edit the samples?}
	end;
type
	QTCustomControlHandleEventPtr = QTCustomControlHandleEventRecordPtr;
{
    pdActionCustomSetFocus is called in order to set or advance the current focus of the user interface, typically
    because the user has pressed the tab or shift-tab keys, or because the user clicked within the area defined by
    your control.
    
    Your control will be called with pdActionFocusFirst,  pdActionFocusLast, or pdActionFocusOff to set or clear focus on your
    control.  Your control will be called with pdActionFocusForward or pdActionFocusBackward to cycle
    focus within your control (if your control has multiple focus).  If your control does not support focus,
    or the focus request results in focus moving beyond your supported range, return pdActionFocusOff in
    the focus parameter.  Otherwise, return the focus that you set.
    
    Controls which have no focus would always set focus to be pdActionFocusOff.
    
    Controls with a single focus would set pdActionFocusFirst when requsted to set either
    pdActionFocusFirst or pdActionFocusLast, and would set pdActionFocusOff for either
    pdActionFocusForward or pdActionFocusBackward.
}
const
	pdActionFocusOff = 0;    { no focus }
	pdActionFocusFirst = 1;    { focus on first element }
	pdActionFocusLast = 2;    { focus on last element }
	pdActionFocusForward = 3;    { focus on next element }
	pdActionFocusBackward = 4;     { focus on previous element }

type
	QTCustomControlSetFocusRecordPtr = ^QTCustomControlSetFocusRecord;
	QTCustomControlSetFocusRecord = record
		storage: UnivPtr;                { storage for the control}
		focus: SIGNEDLONG;                  { focus to set, return resulting focus}
	end;
type
	QTCustomControlSetFocusPtr = QTCustomControlSetFocusRecordPtr;
{ 
    pdActionCustomSetEditMenu will be called to inform your custom control of the location of the edit menu.
    
    If your control has editing boxes, this is useful in order to allow the user to perform cut/copy/paste operations
    when focus is on one of these boxes.
}
type
	QTCustomControlSetEditMenuRecordPtr = ^QTCustomControlSetEditMenuRecord;
	QTCustomControlSetEditMenuRecord = record
		storage: UnivPtr;                { storage for the control}
		editMenu: MenuHandle;               { edit menu, or NIL}
	end;
type
	QTCustomControlSetEditMenuPtr = QTCustomControlSetEditMenuRecordPtr;
{
    pdActionCustomSetPreviewPicture will be called to inform your custom control of preview information that you
    may wish to use in the drawing of your user interface.  
}
type
	QTCustomControlSetPreviewPictureRecordPtr = ^QTCustomControlSetPreviewPictureRecord;
	QTCustomControlSetPreviewPictureRecord = record
		storage: UnivPtr;                { storage for the control}
		preview: QTParamPreviewPtr;                { preview to set}
	end;
type
	QTCustomControlSetPreviewPicturePtr = QTCustomControlSetPreviewPictureRecordPtr;
{
    pdActionCustomSetEditCallout tells your control of the need by the application to be informed of
    changes to the parameter values (typically for the purposes of updating previews).
    
    If a callout is available, your custom control should call it whenever a change has been
    made to the parameter(s) that your control is editing (as a result of user actions, most typically).
    If you choose not to implement this, live dragging or updating of values will not work.
}
type
	QTCustomControlSetEditCalloutRecordPtr = ^QTCustomControlSetEditCalloutRecord;
	QTCustomControlSetEditCalloutRecord = record
		storage: UnivPtr;                { storage for the control}
		callout: QTParamPreviewCalloutPtr;          { requested callout, or NIL to disable}
	end;
type
	QTCustomControlSetEditCalloutPtr = QTCustomControlSetEditCalloutRecordPtr;
{
    pdActionCustomGetEnableValue allows you to return a value for the purposes of enabling/disabling
    other controls.
    Most custom controls do not need to implement this call.
    
    If your control is able to control the enabling and disabling of other parameter controls (such as is done
    by standard pop up or enumerated type controls), you need to supply a value that can be use for greater than/less than
    types of comparisons.
}
type
	QTCustomControlGetEnableValueRecordPtr = ^QTCustomControlGetEnableValueRecord;
	QTCustomControlGetEnableValueRecord = record
		storage: UnivPtr;                { storage for the control}
		currentValue: SIGNEDLONG;           { value to compare against for enable/disable purposes}
	end;
type
	QTCustomControlGetEnableValuePtr = QTCustomControlGetEnableValueRecordPtr;
{
    pdActionCustomSetSampleTime tells your control information from the application about the duration
    and start time for the sample being edited.
    
    Most controls do not need this information, but some may choose to use it in the interface
    they present the user.  However, this call need not be made by applications, so the custom
    control should be prepared to run when the sample time information is not available.
}
type
	QTCustomControlSetSampleTimeRecordPtr = ^QTCustomControlSetSampleTimeRecord;
	QTCustomControlSetSampleTimeRecord = record
		storage: UnivPtr;                { storage for the control}
		sampleTime: QTParamSampleTimePtr;           { sample time information or NIL}
	end;
type
	QTCustomControlSetSampleTimePtr = QTCustomControlSetSampleTimeRecordPtr;
{
    pdActionCustomGetValue tells your control to store any value(s) into the specified atom container.
    
    All custom controls must implement this call
}
type
	QTCustomControlGetValueRecordPtr = ^QTCustomControlGetValueRecord;
	QTCustomControlGetValueRecord = record
		storage: UnivPtr;                { storage for the control}
		sample: QTAtomContainer;                 { sample to store into}
	end;
type
	QTCustomControlGetValuePtr = QTCustomControlGetValueRecordPtr;
{
    pdActionCustomDoEditCommand tells your control to handle edit commands if it allow focus and type in boxes.
    
    All custom controls must implement this call if they support edit boxes
}
type
	QTCustomControlDoEditCommandRecordPtr = ^QTCustomControlDoEditCommandRecord;
	QTCustomControlDoEditCommandRecord = record
		storage: UnivPtr;                { storage for the control}
		command: SIGNEDLONG;                { command to execute, return 0 here if processed}
	end;
type
	QTCustomControlDoEditCommandPtr = QTCustomControlDoEditCommandRecordPtr;
	QTParameterDialog = SIGNEDLONG;
const
	elOptionsIncludeNoneInList = $00000001; { "None" effect is included in list }

type
	QTEffectListOptions = SIGNEDLONG;
const
	effectIsRealtime = 0;     { effect can be rendered in real time }

{
    QTGetEffectsListExtended is a call that provides for 
    more advanced filtering of effects to be placed into the
    effect list.  Applications can filter on:
     1) number of input sources
     2) effect major or minor class
     3) custom filtering through a callback
    The callback will be called for each effect which passes
    the other criteria for inclusion.  If the callback
    returns a true result the effect will be included in the list.
    
    Note that your filter proc may receive multiple effects from various
    manufacturers.  If you return true for multiple effects of a given type
    only the one with the higher parameter version number will be included.
    If you wish other filtering (such as effects from a given manufacturer, you
    can do this by return false for the other effects and true for those
    that you prefer.
}
type
	QTEffectListFilterProcPtr = function( effect: Component; effectMinSource: SIGNEDLONG; effectMaxSource: SIGNEDLONG; majorClass: OSType; minorClass: OSType; refcon: UnivPtr ): Boolean;
	QTEffectListFilterUPP = QTEffectListFilterProcPtr;
{
 *  QTGetEffectsList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTGetEffectsList( var returnedList: QTAtomContainer; minSources: SIGNEDLONG; maxSources: SIGNEDLONG; getOptions: QTEffectListOptions ): OSErr; external name '_QTGetEffectsList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetEffectsListExtended()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTGetEffectsListExtended( var returnedList: QTAtomContainer; minSources: SIGNEDLONG; maxSources: SIGNEDLONG; getOptions: QTEffectListOptions; majorClass: OSType; minorClass: OSType; filterProc: QTEffectListFilterUPP; filterRefCon: UnivPtr ): OSErr; external name '_QTGetEffectsListExtended';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTCreateStandardParameterDialog()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTCreateStandardParameterDialog( effectList: QTAtomContainer; parameters: QTAtomContainer; dialogOptions: QTParameterDialogOptions; var createdDialog: QTParameterDialog ): OSErr; external name '_QTCreateStandardParameterDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTIsStandardParameterDialogEvent()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTIsStandardParameterDialogEvent( var pEvent: EventRecord; createdDialog: QTParameterDialog ): OSErr; external name '_QTIsStandardParameterDialogEvent';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTDismissStandardParameterDialog()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTDismissStandardParameterDialog( createdDialog: QTParameterDialog ): OSErr; external name '_QTDismissStandardParameterDialog';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTStandardParameterDialogDoAction()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTStandardParameterDialogDoAction( createdDialog: QTParameterDialog; action: SIGNEDLONG; params: UnivPtr ): OSErr; external name '_QTStandardParameterDialogDoAction';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetEffectSpeed()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTGetEffectSpeed( parameters: QTAtomContainer; var pFPS: Fixed ): OSErr; external name '_QTGetEffectSpeed';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Movie Audio/Sound APIs}

{
    SetMovieAudioGain:
    This API sets the audio gain level for the mixed audio output of a movie.  This alters the
    perceived volume of the movie's playback.  The gain level is multiplicative; eg. 0.0
    is silent, 0.5 is -6dB, 1.0 is 0dB (ie. the audio from the movie is not
    modified), 2.0 is +6dB, etc.  The gain level can be set higher than 1.0 in order
    to allow quiet movies to be boosted in volume.  Settings higher than 1.0 may result in
    audio clipping, of course.  The setting is not stored in the movie.  It is only used until
    the movie is closed, at which time it is not saved.
 }
{
 *  SetMovieAudioGain()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetMovieAudioGain( m: Movie; gain: Float32; flags: UInt32 ): OSStatus; external name '_SetMovieAudioGain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMovieAudioGain()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieAudioGain( m: Movie; var gain: Float32; flags: UInt32 ): OSStatus; external name '_GetMovieAudioGain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
    SetTrackAudioGain:
    This API sets the audio gain level for the audio output of a track.  This alters the
    perceived volume of the track's playback.  The gain level is multiplicative; eg. 0.0
    is silent, 0.5 is -6dB, 1.0 is 0dB (ie. the audio from the track is not
    modified), 2.0 is +6dB, etc.  The gain level can be set higher than 1.0 in order
    to allow quiet tracks to be boosted in volume.  Settings higher than 1.0 may result in
    audio clipping, of course.  The setting is not stored in the movie.  It is only used until
    the movie is closed, at which time it is not saved.
 }
{
 *  SetTrackAudioGain()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetTrackAudioGain( t: Track; gain: Float32; flags: UInt32 ): OSStatus; external name '_SetTrackAudioGain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetTrackAudioGain()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetTrackAudioGain( t: Track; var gain: Float32; flags: UInt32 ): OSStatus; external name '_GetTrackAudioGain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
    SetMovieAudioBalance:
    This API sets the audio balance level for the mixed audio output of a movie.  -1.0
    means full left, 0.0 means centered, and 1.0 means full right.  The setting is not
    stored in the movie.  It is only used until the movie is closed, at which time it
    is not saved.
 }
{
 *  SetMovieAudioBalance()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetMovieAudioBalance( m: Movie; leftRight: Float32; flags: UInt32 ): OSStatus; external name '_SetMovieAudioBalance';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMovieAudioBalance()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieAudioBalance( m: Movie; var leftRight: Float32; flags: UInt32 ): OSStatus; external name '_GetMovieAudioBalance';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
    SetMovieAudioMute:
    This API mutes or unmutes the mixed audio output from a movie.
 }
{
 *  SetMovieAudioMute()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetMovieAudioMute( m: Movie; muted: Boolean; flags: UInt32 ): OSStatus; external name '_SetMovieAudioMute';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMovieAudioMute()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieAudioMute( m: Movie; var muted: Boolean; flags: UInt32 ): OSStatus; external name '_GetMovieAudioMute';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
    SetTrackAudioMute:
    This API mutes or unmutes the audio output from a track.
 }
{
 *  SetTrackAudioMute()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetTrackAudioMute( t: Track; muted: Boolean; flags: UInt32 ): OSStatus; external name '_SetTrackAudioMute';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetTrackAudioMute()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetTrackAudioMute( t: Track; var muted: Boolean; flags: UInt32 ): OSStatus; external name '_GetTrackAudioMute';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


const
{
   * Properties of an audio presentation (eg. a movie's audio)
   }
	kQTPropertyClass_Audio = FourCharCode('audi');


const
{
   * kQTAudioPropertyID_Gain:  Value is Float32.  Get/Set/Listenable
   * The audio gain of a movie or track.  The gain level is
   * multiplicative; eg. 0.0 is silent, 0.5 is -6dB, 1.0 is 0dB (ie.
   * the audio from the movie is not modified), 2.0 is +6dB, etc.  The
   * gain level can be set higher than 1.0 in order to allow quiet
   * movies/tracks to be boosted in volume. Settings higher than 1.0
   * may result in audio clipping, of course. The setting is not stored
   * in the movie/track.  It is only used until the movie/track is
   * disposed.
   }
	kQTAudioPropertyID_Gain = FourCharCode('gain'); { value is Float32. Gettable/Settable.}

  {
   * kQTAudioPropertyID_Mute:  Value is Boolean.  Get/Set/Listenable
   * The audio mute state of a movie or track.  If true, the
   * movie/track is muted.  The setting is not stored in the
   * movie/track.  It is only used until the movie/track is disposed.
   }
	kQTAudioPropertyID_Mute = FourCharCode('mute'); { value is Boolean. Gettable/Settable.}

  {
   * kQTAudioPropertyID_Balance:  Value is Float32.  Get/Set/Listenable
   * The audio balance of a movie.  -1.0 means full left, 0.0 means
   * centered, and 1.0 means full right.  The setting is not stored in
   * the movie.  It is only used until the movie is disposed.  This is
   * only supported for movies, not tracks.
   }
	kQTAudioPropertyID_Balance = FourCharCode('bala'); { value is Float32. Gettable/Settable.}

  {
   * kQTAudioPropertyID_RateChangesPreservePitch:   Value is Boolean. 
   * Get/Set When the playback rate is not unity, audio must be
   * resampled in order to play at the new rate.  The default
   * resampling affects the pitch of the audio (eg, playing at 2x speed
   * raises the pitch by an octave, 1/2x lowers an octave). If this
   * property is set on the Movie, an alternative algorithm may be
   * used, which alters the speed without changing the pitch.  As this
   * is more computationally expensive, this property may be silently
   * ignored on some slow CPUs. Media handlers may query this movie
   * property and honor it when performing Scaled Edits. This property
   * can be specified as a property to the NewMovieFromProperties()
   * API. Currently, it has no effect when set on an open movie.
   }
	kQTAudioPropertyID_RateChangesPreservePitch = FourCharCode('aucp'); { value is Boolean.  Gettable/Settable.}

  {
   * kQTAudioPropertyID_Pitch:   Value is Float32.  Get/Set/Listenable
   * Movie pitch adjustment.  Adjusts the pitch of all audio tracks
   * that contribute to the AudioContext mix.  Pitch control takes
   * effect only if kQTAudioPropertyID_RateChangesPreservePitch is in
   * effect, otherwise returns kQTMessageNotHandledErr. The Float32
   * value is specified in cents: 0.0 == no change, 1.0 == one cent up,
   * 100.0 == one semi-tone up, -1.0 == one cent down. The most useful
   * ranges for pitch are +/- 1200. (ie, one octave)
   }
	kQTAudioPropertyID_Pitch = FourCharCode('pitc'); { value is Float32. Get/Set/Listenable.}

  {
   * kQTAudioPropertyID_RenderQuality:   Value is UInt32.  Get/Set
   * Movie audio render quality takes effect for movie playback. UInt32
   * values vary from 0x00 (kQTAudioRenderQuality_Min) to 0x7F
   * (kQTAudioRenderQuality_Max). We also define a special value
   * (kQTAudioRenderQuality_PlaybackDefault) which resets the quality
   * settings of the playback processing chain to values that are
   * chosen to be an optimal balance of performance and quality.
   }
	kQTAudioPropertyID_RenderQuality = FourCharCode('qual'); { value is UInt32.  Gettable/Settable.}

  {
   * kQTAudioPropertyID_ChannelLayout:  Value is AudioChannelLayout. 
   * Get/Set The AudioChannelLayout of a track, or other audio stream. 
   * Currently only settable/gettable for tracks.  (See
   * kQTAudioPropertyID_SummaryChannelLayout if you want to get the
   * summary AudioChannelLayout of a movie.) Note that this is a
   * variable sized property (since it may contain an array of
   * ChannelDescriptions; see CoreAudioTypes.h).  You must get the size
   * first (by calling QTGetTrackPropertyInfo), allocate a struct of
   * that size, and then get the property.
   }
	kQTAudioPropertyID_ChannelLayout = FourCharCode('tlay'); { value is AudioChannelLayout. Gettable/Settable.}

  {
   * kQTAudioPropertyID_SummaryChannelLayout:  Value is
   * AudioChannelLayout.  Get-only The summary AudioChannelLayout of a
   * movie, or other grouping of audio streams. All like-labelled
   * channels are combined, so there are no duplicates.  For example,
   * if there is a stereo (L/R) track, 5 single-channel tracks marked
   * Left, Right, Left Surround, Right Surround and Center, and a 4
   * channel track marked L/R/Ls/Rs, then the summary
   * AudioChannelLayout will be L/R/Ls/Rs/C. It will _not_ be
   * L/R/L/R/Ls/Rs/C/L/R/Ls/Rs. Note that this is a variable sized
   * property (since it may contain an array of ChannelDescriptions;
   * see CoreAudioTypes.h).  You must get the size first (by calling,
   * for example, QTGetMoviePropertyInfo) allocate a struct of that
   * size, and then get the property.
   }
	kQTAudioPropertyID_SummaryChannelLayout = FourCharCode('clay'); { value is AudioChannelLayout. Gettable.}

  {
   * kQTAudioPropertyID_DeviceChannelLayout:  Value is
   * AudioChannelLayout.  Get-only The AudioChannelLayout of the device
   * this movie is playing to.  Note that this is a variable sized
   * property (since it may contain an array of ChannelDescriptions;
   * see CoreAudioTypes.h).  You must get the size first (by calling,
   * for example, QTGetMoviePropertyInfo) allocate a struct of that
   * size, and then get the property.
   }
	kQTAudioPropertyID_DeviceChannelLayout = FourCharCode('dcly'); { value is AudioChannelLayout. Gettable.}

  {
   * kQTAudioPropertyID_DeviceASBD:  Value is
   * AudioStreamBasicDescription.  Get-only Returns the
   * AudioStreamBasicDescription of the device this movie is playing
   * to. The interesting fields are the sample rate, which reflects
   * device's current state, and the number of channels, which matches
   * what is reported by kQTAudioPropertyID_DeviceChannelLayout.
   }
	kQTAudioPropertyID_DeviceASBD = FourCharCode('dasd'); { value is AudioStreamBasicDescription. Gettable.}

  {
   * kQTAudioPropertyID_SummaryASBD:  Value is
   * AudioStreamBasicDescription.  Get-only Returns the
   * AudioStreamBasicDescription corresponding to the Summary Mix of a
   * movie.  This will describe non-interleaved, Float32 linear PCM
   * data, with a sample rate equal to the highest audio sample rate
   * found among the sound tracks contributing to the AudioContext mix,
   * and a number of channels that matches what is reported by
   * kQTAudioPropertyID_SummaryChannelLayout.
   }
	kQTAudioPropertyID_SummaryASBD = FourCharCode('sasd'); { value is AudioStreamBasicDescription. Gettable.}

  {
   * kQTAudioPropertyID_FormatString:  Value is CFStringRef.  Get-only
   * kQTAudioPropertyID_FormatString returns a localized, human
   * readable string describing the audio format as a CFStringRef, i.e.
   * "MPEG Layer 3". You may get this property from a SoundDescription
   * Handle by calling QTSoundDescriptionGetProperty(), or from a
   * StandardAudioCompression (scdi/audi) component instance by calling
   * QTGetComponentProperty().
   }
	kQTAudioPropertyID_FormatString = FourCharCode('fstr'); { value is CFStringRef.  Gettable.}

  {
   * kQTAudioPropertyID_ChannelLayoutString:  Value is CFStringRef. 
   * Get-only kQTAudioPropertyID_ChannelLayoutString returns a
   * localized, human readable string describing the audio channel
   * layout as a CFStringRef, i.e. "5.0 (L R C Ls Rs)". You may get
   * this property from a SoundDescription Handle by calling
   * QTSoundDescriptionGetProperty(), or from a
   * StandardAudioCompression (scdi/audi) component instance by calling
   * QTGetComponentProperty().
   }
	kQTAudioPropertyID_ChannelLayoutString = FourCharCode('lstr'); { value is CFStringRef.  Gettable.}

  {
   * kQTAudioPropertyID_SampleRateString:  Value is CFStringRef. 
   * Get-only kQTAudioPropertyID_SampleRateString returns a localized,
   * human readable string describing the audio sample rate as a
   * CFStringRef, i.e. "44.100 kHz". You may get this property from a
   * SoundDescription Handle by calling
   * QTSoundDescriptionGetProperty(), or from a
   * StandardAudioCompression (scdi/audi) component instance by calling
   * QTGetComponentProperty().
   }
	kQTAudioPropertyID_SampleRateString = FourCharCode('rstr'); { value is CFStringRef.  Gettable.}

  {
   * kQTAudioPropertyID_SampleSizeString:  Value is CFStringRef. 
   * Get-only kQTAudioPropertyID_SampleSizeString returns a localized,
   * human readable string describing the audio sample size as a
   * CFStringRef, i.e. "24-bit". Note, this property will only return a
   * valid string if the format is uncompressed (LPCM) audio. You may
   * get this property from a SoundDescription Handle by calling
   * QTSoundDescriptionGetProperty(), or from a
   * StandardAudioCompression (scdi/audi) component instance by calling
   * QTGetComponentProperty().
   }
	kQTAudioPropertyID_SampleSizeString = FourCharCode('sstr'); { value is CFStringRef.  Gettable.}

  {
   * kQTAudioPropertyID_BitRateString:  Value is CFStringRef.  Get-only
   * kQTAudioPropertyID_BitRateString returns a localized, human
   * readable string describing the audio bit rate as a CFStringRef,
   * i.e. "12 kbps". You may get this property from a SoundDescription
   * Handle by calling QTSoundDescriptionGetProperty(), or from a
   * StandardAudioCompression (scdi/audi) component instance by calling
   * QTGetComponentProperty().
   }
	kQTAudioPropertyID_BitRateString = FourCharCode('bstr'); { value is CFStringRef.  Gettable.}

  {
   * kQTAudioPropertyID_SummaryString:  Value is CFStringRef.  Get-only
   * kQTAudioPropertyID_SummaryString returns a localized, human
   * readable string summarizing the audio as a CFStringRef, i.e.
   * "16-bit Integer (Big Endian), Stereo (L R), 48.000 kHz". You may
   * get this property from a SoundDescription Handle calling
   * QTSoundDescriptionGetProperty(), or from a
   * StandardAudioCompression (scdi/audi) component instance by calling
   * QTGetComponentProperty().
   }
	kQTAudioPropertyID_SummaryString = FourCharCode('asum'); { value is CFStringRef.  Gettable.}


{
 *  Audio Render Quality constants
 *  
 *  Summary:
 *    Render quality is an integer that ranges from
 *    kQTAudioRenderQuality_Min to kQTAudioRenderQuality_Max.
 *    kQTAudioRenderQuality_Low, kQTAudioRenderQuality_Medium, and
 *    kQTAudioRenderQuality_High are the preferred values.
 }
const
{
   * The maximum value.
   }
	kQTAudioRenderQuality_Max = $7F;

  {
   * A value that increases quality but requires more computational
   * resources.
   }
	kQTAudioRenderQuality_High = $60;

  {
   * A value that represents a good quality/performance tradeoff.
   }
	kQTAudioRenderQuality_Medium = $40;

  {
   * A value that reduces quality for better performance.
   }
	kQTAudioRenderQuality_Low = $20;

  {
   * The minimum value.
   }
	kQTAudioRenderQuality_Min = $00;

  {
   * A QuickTime-specific value that selects optimal settings for
   * playback.
   }
	kQTAudioRenderQuality_PlaybackDefault = $8000;


{ whatMixToMeter constants}

const
{
   * kQTAudioMeter_DeviceMix: Meter the movie's mix to the device
   * channel layout. To determine the channel layout of this mix, call
   * QTGetMovieProperty(..., kQTAudioPropertyID_DeviceChannelLayout,
   * ...).
   }
	kQTAudioMeter_DeviceMix = kQTAudioPropertyID_DeviceChannelLayout;

  {
   * kQTAudioMeter_StereoMix: Meter a stereo (two-channel) mix of the
   * enabled sound tracks in the movie. This option is offered only for
   * MovieAudioFrequencyMetering.
   }
	kQTAudioMeter_StereoMix = FourCharCode('stmx');

  {
   * kQTAudioMeter_MonoMix: Meter a monarual (one-channel) mix of the
   * enabled sound tracks in the movie. This option is offered only for
   * MovieAudioFrequencyMetering.
   }
	kQTAudioMeter_MonoMix = FourCharCode('momx');

{
    SetMovieAudioVolumeMeteringEnabled:
    This API enables or disables volume metering of a particular mix of this movie.  The only possible
    mix to meter is currently kQTAudioMeter_DeviceMix.  See kQTAudioMeter_DeviceMix above to see
    how to determine the channel layout of the movie's device mix.
 }
{
 *  SetMovieAudioVolumeMeteringEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetMovieAudioVolumeMeteringEnabled( m: Movie; whatMixToMeter: FourCharCode; enabled: Boolean ): OSStatus; external name '_SetMovieAudioVolumeMeteringEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMovieAudioVolumeMeteringEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieAudioVolumeMeteringEnabled( m: Movie; whatMixToMeter: FourCharCode; var enabled: Boolean ): OSStatus; external name '_GetMovieAudioVolumeMeteringEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
    GetMovieAudioVolumeLevels:
    This API returns the current volume meter levels of the movie.  It can return both average power
    levels and peak hold levels.  whatMixToMeter must be set to kQTAudioMeter_DeviceMix.  Either
    QTAudioVolumeLevels parameter may be nil.  If non-nil, each must have its numChannels field set to
    the number of channels in the movie's device mix, and must be allocated large enough to hold levels
    for all those channels.  See kQTAudioMeter_DeviceMix above to see how to determine the channel
    layout of the device mix. The levels returned are measured in decibels, where 0.0 means full volume,
    -6.0 means half volume, -12.0 means quarter volume, and -inf means silence.
 }
type
	QTAudioVolumeLevelsPtr = ^QTAudioVolumeLevels;
	QTAudioVolumeLevels = record
		numChannels: UInt32;
		level: array [0..0] of Float32;               { numChannels entries}
	end;
{
 *  GetMovieAudioVolumeLevels()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieAudioVolumeLevels( m: Movie; whatMixToMeter: FourCharCode; var pAveragePowerLevels: QTAudioVolumeLevels; var pPeakHoldLevels: QTAudioVolumeLevels ): OSStatus; external name '_GetMovieAudioVolumeLevels';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ 
    SetTrackAudioVolumeMeteringEnabled:
    This API enables or disables volume metering of a particular track of this movie.
    This API should be used in preference to the legacy SoundMedia interface, but
    may interfere with its operation if both are in use at the same time.
}
{
 *  SetTrackAudioVolumeMeteringEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetTrackAudioVolumeMeteringEnabled( t: Track; enabled: Boolean ): OSStatus; external name '_SetTrackAudioVolumeMeteringEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetTrackAudioVolumeMeteringEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetTrackAudioVolumeMeteringEnabled( t: Track; var enabled: Boolean ): OSStatus; external name '_GetTrackAudioVolumeMeteringEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
    GetTrackAudioVolumeLevels:
    This API returns the current volume meter levels of the track.  It can return both average power
    levels and peak hold levels.  Either QTAudioVolumeLevels parameter may be nil.  If non-nil,
    each must have its numChannels field set to the number of channels of interest, and must be
    allocated large enough to hold levels for all those channels.
    The levels returned are measured in decibels, where 0.0 means full volume,
    -6.0 means half volume, -12.0 means quarter volume, and -inf means silence.
}
{
 *  GetTrackAudioVolumeLevels()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetTrackAudioVolumeLevels( t: Track; var pAveragePowerLevels: QTAudioVolumeLevels; var pPeakHoldLevels: QTAudioVolumeLevels ): OSStatus; external name '_GetTrackAudioVolumeLevels';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
    SetMovieAudioFrequencyMeteringNumBands:
    This API configures and enables (or disables) frequency metering for a movie.
    Note that ioNumBands is an in/out parameter.  You specify the number of frequency bands you
    want to meter, and if that number is higher than is possible (determined by, among other things,
    the sample rate of the audio being metered), this API will return the number of bands it is
    actually going to meter.  ioNumBands can be nil or a pointer to 0 to disable metering.
    whatMixToMeter must be set to kQTAudioMeter_StereoMix, kQTAudioMeter_MonoMix, or
    kQTAudioMeter_DeviceMix.  When metering movies playing to audio devices that offer a
    large number of channels, it may be prohibitively expensive to perform spectral analysis
    on every channel; in these cases, stereo or mono mix metering may be preferable.
 }
{
 *  SetMovieAudioFrequencyMeteringNumBands()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetMovieAudioFrequencyMeteringNumBands( m: Movie; whatMixToMeter: FourCharCode; var ioNumBands: UInt32 ): OSStatus; external name '_SetMovieAudioFrequencyMeteringNumBands';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMovieAudioFrequencyMeteringNumBands()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieAudioFrequencyMeteringNumBands( m: Movie; whatMixToMeter: FourCharCode; var outNumBands: UInt32 ): OSStatus; external name '_GetMovieAudioFrequencyMeteringNumBands';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
    GetMovieAudioFrequencyMeteringBandFrequencies:
    This API returns the actual chosen middle frequency for each band in the configured
    frequency metering of a movie.  This is useful for labeling visual meters
    in a user interface.  Frequencies are returned in Hz.  whatMixToMeter must be set
    to the same value that was passed most recently to SetMovieAudioFrequencyMeteringNumBands().
 }
{
 *  GetMovieAudioFrequencyMeteringBandFrequencies()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieAudioFrequencyMeteringBandFrequencies( m: Movie; whatMixToMeter: FourCharCode; numBands: UInt32; var outBandFrequencies: Float32 ): OSStatus; external name '_GetMovieAudioFrequencyMeteringBandFrequencies';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
    GetMovieAudioFrequencyLevels:
    This API returns the current frequency meter levels of the movie. pAveragePowerLevels should
    have its numChannels field set to the number of channels being metered, and its numBands field
    set to the number of bands being metered (as previously configured).  pAveragePowerLevels must be
    allocated large enough to hold levels for all bands in all channels.  The levels are returned with
    all the band levels for the first channel first, then all the band levels for the second channel, etc.
    whatMixToMeter must be set  to the same value that was passed most recently to
    SetMovieAudioFrequencyMeteringNumBands().
 }
type
	QTAudioFrequencyLevels = record
		numChannels: UInt32;
		numFrequencyBands: UInt32;
                                              { numChannels * numFrequencyBands entries, with the frequency bands for a single channel stored contiguously.}
		level: array [0..0] of Float32;
	end;
{
 *  GetMovieAudioFrequencyLevels()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieAudioFrequencyLevels( m: Movie; whatMixToMeter: FourCharCode; var pAveragePowerLevels: QTAudioFrequencyLevels ): OSStatus; external name '_GetMovieAudioFrequencyLevels';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ Movie Audio Extraction}

{
    MovieAudioExtractionBegin:
    This API must be called before doing any movie audio extraction.  The returned session
    object is to be passed to the other movie audio extraction APIs.  Note that the extracted
    format defaults to the aggregate channel layout of the movie (eg. all Rights mixed together,
    all Left Surrounds mixed together, etc), 32-bit float, de-interleaved, with the sample rate
    set to the highest sample rate found in the movie.  You can get this info, and you can also
    set the format to be something else (as long as it is uncompressed, and you do it before
    the first call to MovieAudioExtractionFillBuffer). 
 }
type
	MovieAudioExtractionRef = ^OpaqueMovieAudioExtractionRef; { an opaque type }
	OpaqueMovieAudioExtractionRef = record end;
{
 *  MovieAudioExtractionBegin()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function MovieAudioExtractionBegin( m: Movie; flags: UInt32; var outSession: MovieAudioExtractionRef ): OSStatus; external name '_MovieAudioExtractionBegin';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
    MovieAudioExtractionEnd:
    This API must be called when movie audio extraction is complete.
 }
{
 *  MovieAudioExtractionEnd()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function MovieAudioExtractionEnd( session: MovieAudioExtractionRef ): OSStatus; external name '_MovieAudioExtractionEnd';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ Movie audio extraction property classes}

const
{
   * Properties of the movie being extracted from
   }
	kQTPropertyClass_MovieAudioExtraction_Movie = FourCharCode('xmov');

  {
   * Properties of the output audio
   }
	kQTPropertyClass_MovieAudioExtraction_Audio = FourCharCode('xaud');

{ "Movie class" property IDs}

const
{
   * kQTMovieAudioExtractionMoviePropertyID_CurrentTime: Value is
   * TimeRecord (set & get) When setting, set the timescale to anything
   * you want (output audio sample rate, movie timescale) When getting,
   * the timescale will be output audio sample rate for best accuracy.
   }
	kQTMovieAudioExtractionMoviePropertyID_CurrentTime = FourCharCode('time'); { value is TimeRecord. Get/Set.}

  {
   * kQTMovieAudioExtractionMoviePropertyID_AllChannelsDiscrete: Value
   * is Boolean (set & get) Set to implement export of all audio
   * channels without mixing. When this is set and the extraction asbd
   * or channel layout are read back, you will get information relating
   * to the re-mapped movie.
   }
	kQTMovieAudioExtractionMoviePropertyID_AllChannelsDiscrete = FourCharCode('disc'); { value is Boolean. Get/Set.}

  {
   * kQTMovieAudioExtractionAudioPropertyID_RenderQuality: Value is
   * UInt32 (set & get) Set the render quality to be used for this
   * audio extraction session. UInt32 values vary from 0x00
   * (kQTAudioRenderQuality_Min) to 0x7F (kQTAudioRenderQuality_Max).
   * We also define a special value
   * (kQTAudioRenderQuality_PlaybackDefault) which resets the quality
   * settings to the same values that were chosen by default for
   * playback.
   }
	kQTMovieAudioExtractionAudioPropertyID_RenderQuality = FourCharCode('qual'); { value is UInt32. Get/Set.}


{ "Output Audio class" property IDs}

const
{ kQTPropertyClass_MovieAudioExtraction_Audio}

  {
   * 
   * QTMovieAudioExtractionAudioPropertyID_AudioStreamBasicDescription:
   * Value is AudioStreamBasicDescription.  Get/Set. (get any time, set
   * before first MovieAudioExtractionFillBuffer call) If you get this
   * property immediately after beginning an audio extraction session,
   * it will tell you the default extraction format for the movie. 
   * This will include the number of channels in the default movie mix.
   * If you set the output AudioStreamBasicDescription, it is
   * recommended that you also set the output channel layout.  If your
   * output ASBD has a different number of channels that the default
   * extraction mix, you _must_ set the output channel layout. You can
   * only set PCM output formats.  Setting a compressed output format
   * will fail.
   }
	kQTMovieAudioExtractionAudioPropertyID_AudioStreamBasicDescription = FourCharCode('asbd'); { value is AudioStreamBasicDescription. Get/Set.}

  {
   * kQTMovieAudioExtractionAudioPropertyID_AudioChannelLayout: Value
   * is AudioChannelLayout.  Get/Set. (get any time, set before first
   * MovieAudioExtractionFillBuffer call) If you get this property
   * immediately after beginning an audio extraction session, it will
   * tell you what the channel layout is for the default extraction mix.
   }
	kQTMovieAudioExtractionAudioPropertyID_AudioChannelLayout = FourCharCode('clay'); { value is AudioChannelLayout. Get/Set.}

  {
   * kQTMovieAudioExtractionAudioPropertyID_RemainingAudioDuration:
   * Value is TimeRecord. Get only. Returns the total duration of audio
   * data that can be expected from the audio extraction session as
   * currently configured.  This is computed by examining all tracks
   * that contribute to the audio mix, finding the highest end time
   * among them, adding in all relevant tail times from any Audio
   * Context Inserts that have been registered, and subtracting any
   * extraction start time that has been set.  If this property is
   * queried once extraction has started, it will return the remaining
   * duration, or zero once extraction has advanced to the end of all
   * contributing audio tracks.
   }
	kQTMovieAudioExtractionAudioPropertyID_RemainingAudioDuration = FourCharCode('dura'); { value is TimeRecord. Get only.}


{
 *  MovieAudioExtractionGetPropertyInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function MovieAudioExtractionGetPropertyInfo( session: MovieAudioExtractionRef; inPropClass: QTPropertyClass; inPropID: QTPropertyID; var outPropType: QTPropertyValueType; var outPropValueSize: ByteCount; var outPropertyFlags: UInt32 ): OSStatus; external name '_MovieAudioExtractionGetPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  MovieAudioExtractionGetProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function MovieAudioExtractionGetProperty( session: MovieAudioExtractionRef; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; outPropValueAddress: QTPropertyValuePtr; var outPropValueSizeUsed: ByteCount ): OSStatus; external name '_MovieAudioExtractionGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  MovieAudioExtractionSetProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function MovieAudioExtractionSetProperty( session: MovieAudioExtractionRef; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstQTPropertyValuePtr ): OSStatus; external name '_MovieAudioExtractionSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
    MovieAudioExtractionFillBuffer:
    Each call to MovieAudioExtractionFillBuffer will continue where the last call left off.
    It will extract as many of the requested PCM frames as it can, given the limits of the
    buffer(s) supplied, and the limits of the input movie.  ioNumFrames will be updated
    with the exact number of valid frames being returned.
    When there is no more audio to extract from the movie, MovieAudioExtractionFillBuffer
    will continue to return noErr, but no audio data will be returned.  outFlags will have
    the kQTMovieAudioExtractionComplete bit set in this case.  It is possible that the
    kQTMovieAudioExtractionComplete bit will accompany the last buffer of valid data.
 }
const
	kQTMovieAudioExtractionComplete = 1 shl 0;

{
 *  MovieAudioExtractionFillBuffer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function MovieAudioExtractionFillBuffer( session: MovieAudioExtractionRef; var ioNumFrames: UInt32; var ioData: AudioBufferList; var outFlags: UInt32 ): OSStatus; external name '_MovieAudioExtractionFillBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ Audio Context Insert properties for MovieAudioExtraction}

{
   Theory of operations:
    To register for a Movie Audio Context Insert during Movie Audio Extraction:
        Set the kQTMovieAudioExtractionAudioPropertyID_RegisterMovieInsert
            property on the extraction session, providing the same registry info structure
            that is used for the QTAudioContextRegisterInsert call.
    To register for a Track Audio Context Insert during Movie Audio Extraction:
        Set the kQTMovieAudioExtractionAudioPropertyID_RegisterTrackInsert
            property on the extraction session, providing a QTAudioTrackInsertRegistryInfoRef,
            described below.
    Note: Once extraction has begun (ie, MovieAudioExtractionFillBuffer() has been
            called), attempts to set these properties will return qtReadOnlyErr.
            This is consistent with the behavior of most extraction properties.
}


{
 *  QTAudioTrackInsertRegistryInfo
 *  
 *  Summary:
 *    Parameters for registering an Audio Context Track Insert during
 *    Movie Audio Extraction
 *  
 *  Discussion:
 *    This is used with the
 *    kQTMovieAudioExtractionMoviePropertyID_RegisterTrackInsert
 *    property.
 }
type
	QTAudioTrackInsertRegistryInfoPtr = ^QTAudioTrackInsertRegistryInfo;
	QTAudioTrackInsertRegistryInfo = record
{
   * The track of the source movie on which to apply the insert.
   }
		track: Track_fix;

  {
   * The Audio Context Insert registration info (channel layouts,
   * callbacks).
   }
		regInfo: QTAudioContextInsertRegistryInfo;
	end;
type
	QTAudioTrackInsertRegistryInfoRef = QTAudioTrackInsertRegistryInfoPtr;
{ Movie and Track level audio context inserts for extraction (kQTPropertyClass_MovieAudioExtraction_Audio)}

const
{
   * kQTMovieAudioExtractionAudioPropertyID_RegisterMovieInsert: Value
   * is QTAudioContextInsertRegistryInfoRef  (Get/Set) Set on an
   * extraction session to register/unregister an Audio Context Insert
   * for the movie summary mix.  When this property is read back
   * (MovieAudioExtractionGetProperty) the channel layout pointers will
   * will be NULL. To unregister, supply a NULL processDataCallback (in
   * which case the rest of the registry info will be ignored).
   }
	kQTMovieAudioExtractionAudioPropertyID_RegisterMovieInsert = FourCharCode('regm'); { value is QTAudioContextInsertRegistryInfoRef. Get/Set.}

  {
   * kQTMovieAudioExtractionAudioPropertyID_RegisterTrackInsert: Value
   * is QTAudioTrackInsertRegistryInfoRef  (Get/Set) Set on an
   * extraction session to register/unregister an Audio Context Insert
   * for a particular track of the movie.  When this property is read
   * back (MovieAudioExtractionGetProperty) the channel layout pointers
   * will will be NULL. To unregister, supply a NULL
   * processDataCallback (in which case the rest of the registry info
   * will be ignored).
   }
	kQTMovieAudioExtractionAudioPropertyID_RegisterTrackInsert = FourCharCode('regt'); { value is QTAudioTrackInsertRegistryInfoRef. Get/Set.}


//#define kQTMovieAudioExtractionMoviePropertyID_RegisterInsert  Use kQTPropertyClass_MovieAudioExtraction_Audio / kQTMovieAudioExtractionAudioPropertyID_RegisterMovieInsert instead!

{ Legacy Audio/Sound APIs}

{
 *  GetMoviePreferredVolume()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMoviePreferredVolume( theMovie: Movie ): SInt16; external name '_GetMoviePreferredVolume';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMoviePreferredVolume()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMoviePreferredVolume( theMovie: Movie; volume: SInt16 ); external name '_SetMoviePreferredVolume';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMovieVolume()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMovieVolume( theMovie: Movie ): SInt16; external name '_GetMovieVolume';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetMovieVolume()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetMovieVolume( theMovie: Movie; volume: SInt16 ); external name '_SetMovieVolume';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackVolume()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackVolume( theTrack: Track ): SInt16; external name '_GetTrackVolume';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTrackVolume()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTrackVolume( theTrack: Track; volume: SInt16 ); external name '_SetTrackVolume';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTrackSoundLocalizationSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTrackSoundLocalizationSettings( theTrack: Track; var settings: Handle ): OSErr; external name '_GetTrackSoundLocalizationSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTrackSoundLocalizationSettings()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SetTrackSoundLocalizationSettings( theTrack: Track; settings: Handle ): OSErr; external name '_SetTrackSoundLocalizationSettings';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Performance properties}


const
	kQTPropertyClass_Performance = FourCharCode('perf');

  {
   * kQTPerformancePropertyID_MediaStallCount:  Value is UInt32. 
   * Get/Set/Listenable Media stalls occur when a media handler is
   * unable to provide its media data at the time required for seamless
   * playback.  The exact interpretation of a track's MediaStallCount
   * property is media-handler dependent, but may indicate conditions
   * such as a video frame not decoded in time, the sound queue runs
   * dry, etc.  When requested on a specific track, this property
   * returns the current stall count of that track.  When requested on
   * a movie, it returns the accumulated MediaStallCounts for all the
   * tracks in the movie. The track property may be set to zero to
   * reset it.  Setting the movie property to zero resets all the track
   * counts. Setting the value to anything other than zero yields
   * paramErr. The movie toolbox defers property-changed notifications
   * to any property listeners until the next time the movie is idled.
   }
	kQTPerformancePropertyID_MediaStallCount = FourCharCode('stal'); { UInt32, Get/Set/Listenable }

  {
   * kQTPerformancePropertyID_AudioIOOverloadCount:  Value is UInt32. 
   * Get/Set/Listenable Audio I/O overloads occur when the
   * high-priority audio processing thread does not provide the
   * requested buffer of data in time to ensure seamless playback. 
   * This movie property accumulates the number of Audio Device I/O
   * overloads that are detected during playback of a movie.  I/O
   * overloads that are detected when the movie is not playing (but
   * other movies may be playing), are not counted. This property may
   * be set to zero to reset the counter.  Setting the value to
   * anything other than zero yields paramErr. The movie toolbox defers
   * property-changed notifications to any property listeners until the
   * next time the movie is idled.
   }
	kQTPerformancePropertyID_AudioIOOverloadCount = FourCharCode('ovct'); { UInt32, Get/Set/Listenable}


{ Movie Visual Adjustment APIs}


{
 *  Summary:
 *    Visual movie properties.
 }
const
{
   * Class for visual properties.
   }
	kQTPropertyClass_Visual = FourCharCode('visu');

  {
   * The hue adjustment for the movie.   The value is a Float32 between
   * -1.0 and 1.0, with 0.0 meaning no adjustment. This adjustment
   * wraps around, such that -1.0 and 1.0 yield the same result.
   }
	kQTVisualPropertyID_Hue = FourCharCode('vhue'); { Float32, Read/Write }

  {
   * The color saturation adjustment for the movie.  The value is a
   * Float32 percentage (1.0f = 100%), such that 0.0 gives grayscale.
   }
	kQTVisualPropertyID_Saturation = FourCharCode('vsat'); { Float32, Read/Write }

  {
   * The brightness adjustment for the movie.  The value is a Float32
   * for which -1.0 means full black, 0.0 means no adjustment, and 1.0
   * means full white.
   }
	kQTVisualPropertyID_Brightness = FourCharCode('vbrt'); { Float32, Read/Write }

  {
   * The contrast adjustment for the movie.  The value is a Float32
   * percentage (1.0f = 100%), such that 0.0 gives solid grey.
   }
	kQTVisualPropertyID_Contrast = FourCharCode('vcon'); { Float32, Read/Write }


{
 *  SetMovieVisualHue()
 *  
 *  Summary:
 *    This API sets the hue adjustment for the movie.
 *  
 *  Discussion:
 *    See kQTPropertyClass_Visual/kQTVisualPropertyID_Hue for details.
 *    The setting is not stored in the movie.  It is only used until
 *    the movie is closed, at which time it is not saved.
 *  
 *  Parameters:
 *    
 *    movie:
 *      [in]  The movie.
 *    
 *    hue:
 *      [in]  New hue adjustment.
 *    
 *    flags:
 *      [in]  Reserved. Pass 0.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetMovieVisualHue( movie_: Movie; hue: Float32; flags: UInt32 ): OSStatus; external name '_SetMovieVisualHue';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMovieVisualHue()
 *  
 *  Summary:
 *    This API gets the hue adjustment for the movie.
 *  
 *  Discussion:
 *    See kQTPropertyClass_Visual/kQTVisualPropertyID_Hue for details.
 *  
 *  Parameters:
 *    
 *    movie:
 *      [in]  The movie.
 *    
 *    hueOut:
 *      [out] Current hue adjustment.
 *    
 *    flags:
 *      [in]  Reserved. Pass 0.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieVisualHue( movie_: Movie; var hueOut: Float32; flags: UInt32 ): OSStatus; external name '_GetMovieVisualHue';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  SetMovieVisualSaturation()
 *  
 *  Summary:
 *    This API sets the color saturation adjustment for the movie.
 *  
 *  Discussion:
 *    See kQTPropertyClass_Visual/kQTVisualPropertyID_Saturation for
 *    details. The setting is not stored in the movie.  It is only used
 *    until the movie is closed, at which time it is not saved.
 *  
 *  Parameters:
 *    
 *    movie:
 *      [in]  The movie.
 *    
 *    saturation:
 *      [in]  New saturation adjustment.
 *    
 *    flags:
 *      [in]  Reserved. Pass 0.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetMovieVisualSaturation( movie_: Movie; saturation: Float32; flags: UInt32 ): OSStatus; external name '_SetMovieVisualSaturation';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMovieVisualSaturation()
 *  
 *  Summary:
 *    This API gets the color saturation adjustment for the movie.
 *  
 *  Discussion:
 *    See kQTPropertyClass_Visual/kQTVisualPropertyID_Saturation for
 *    details.
 *  
 *  Parameters:
 *    
 *    movie:
 *      [in]  The movie.
 *    
 *    saturationOut:
 *      [out] Current saturation adjustment.
 *    
 *    flags:
 *      [in]  Reserved. Pass 0.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieVisualSaturation( movie_: Movie; var saturationOut: Float32; flags: UInt32 ): OSStatus; external name '_GetMovieVisualSaturation';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  SetMovieVisualBrightness()
 *  
 *  Summary:
 *    This API sets the brightness adjustment for the movie.
 *  
 *  Discussion:
 *    See kQTPropertyClass_Visual/kQTVisualPropertyID_Brightness for
 *    details. The setting is not stored in the movie.  It is only used
 *    until the movie is closed, at which time it is not saved.
 *  
 *  Parameters:
 *    
 *    movie:
 *      [in]  The movie.
 *    
 *    brightness:
 *      [in]  New brightness adjustment.
 *    
 *    flags:
 *      [in]  Reserved. Pass 0.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetMovieVisualBrightness( movie_: Movie; brightness: Float32; flags: UInt32 ): OSStatus; external name '_SetMovieVisualBrightness';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMovieVisualBrightness()
 *  
 *  Summary:
 *    This API gets the brightness adjustment for the movie.
 *  
 *  Discussion:
 *    See kQTPropertyClass_Visual/kQTVisualPropertyID_Brightness for
 *    details.
 *  
 *  Parameters:
 *    
 *    movie:
 *      [in]  The movie.
 *    
 *    brightnessOut:
 *      [out] Current brightness adjustment.
 *    
 *    flags:
 *      [in]  Reserved. Pass 0.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieVisualBrightness( movie_: Movie; var brightnessOut: Float32; flags: UInt32 ): OSStatus; external name '_GetMovieVisualBrightness';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  SetMovieVisualContrast()
 *  
 *  Summary:
 *    This API sets the contrast adjustment for the movie.
 *  
 *  Discussion:
 *    See kQTPropertyClass_Visual/kQTVisualPropertyID_Contrast for
 *    details. The setting is not stored in the movie.  It is only used
 *    until the movie is closed, at which time it is not saved.
 *  
 *  Parameters:
 *    
 *    movie:
 *      [in]  The movie.
 *    
 *    contrast:
 *      [in]  New contrast adjustment.
 *    
 *    flags:
 *      [in]  Reserved. Pass 0.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetMovieVisualContrast( movie_: Movie; contrast: Float32; flags: UInt32 ): OSStatus; external name '_SetMovieVisualContrast';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  GetMovieVisualContrast()
 *  
 *  Summary:
 *    This API gets the contrast adjustment for the movie.
 *  
 *  Discussion:
 *    See kQTPropertyClass_Visual/kQTVisualPropertyID_Contrast for
 *    details.
 *  
 *  Parameters:
 *    
 *    movie:
 *      [in]  The movie.
 *    
 *    contrastOut:
 *      [out] Current contrast adjustment.
 *    
 *    flags:
 *      [in]  Reserved. Pass 0.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetMovieVisualContrast( movie_: Movie; var contrastOut: Float32; flags: UInt32 ): OSStatus; external name '_GetMovieVisualContrast';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{ Movie Aperture APIs}


{
 *  Summary:
 *    Visual properties of movies for aperture modes.
 }
const
{
   * You can set the aperture mode property on a movie to indicate
   * whether aspect ratio and clean aperture correction should be
   * performed. The values for this property have the prefix
   * kQTApertureMode_ and are in ImageCompression.h. 
   * When a movie is in clean, production or encoded pixels aperture
   * mode, each track's dimensions are overriden by special dimensions
   * for that mode. The original track dimensions are preserved and can
   * be restored by setting the movie into classic aperture mode.
   }
	kQTVisualPropertyID_ApertureMode = FourCharCode('apmd'); { OSType, Read/Write/Listen }


{
 *  Summary:
 *    Visual properties of tracks for aperture modes
 *  
 *  Discussion:
 *    A track's dimensions may vary depending on the movie's aperture
 *    mode. The dimensions for a given aperture mode may be accessed
 *    using these properties.
 }
const
{
   * The track dimensions used in QuickTime 7.0.x and earlier. Setting
   * this property is equivalent to calling SetTrackDimensions, except
   * that SetTrackDimensions also changes the aperture mode to
   * kQTApertureMode_Classic, and setting this property does not.
   }
	kQTVisualPropertyID_ClassicDimensions = FourCharCode('cldi'); { FixedPoint, Read/Write }

  {
   * The track dimensions to use in clean aperture mode.
   }
	kQTVisualPropertyID_CleanApertureDimensions = FourCharCode('cadi'); { FixedPoint, Read/Write }

  {
   * The track dimensions to use in production aperture mode.
   }
	kQTVisualPropertyID_ProductionApertureDimensions = FourCharCode('prdi'); { FixedPoint, Read/Write }

  {
   * The track dimensions to use in encoded pixels aperture mode.
   }
	kQTVisualPropertyID_EncodedPixelsDimensions = FourCharCode('endi'); { FixedPoint, Read/Write }

  {
   * True if aperture mode dimensions have been set on this movie, even
   * if they are all identical to the classic dimensions (as is the
   * case for content with square pixels and no edge processing
   * region). 
   * This property can also be tested on a movie, where it is true if
   * any track has aperture mode dimensions.
   }
	kQTVisualPropertyID_HasApertureModeDimensions = FourCharCode('hamd'); { Boolean, Read }


{
 *  Summary:
 *    Media Characteristics
 }
const
{
   * Indicates that a media handler supports aperture modes, which
   * enable video to be automatically scaled and cropped to compensate
   * for non-square pixel aspect ratios and to trim possibly-dirty edge
   * processing regions. The dimensions of such a track may change when
   * the movie's aperture mode is changed.
   }
	kCharacteristicSupportsApertureModes = FourCharCode('apmd');

{
 *  SetTrackApertureModeDimensionsUsingSampleDescription()
 *  
 *  Summary:
 *    Sets a track's aperture mode dimensions using values calculated
 *    using a sample description.
 *  
 *  Discussion:
 *    This function should be used to add information needed to support
 *    aperture modes to newly created tracks. This information is
 *    calculated using the given sample description. If sampleDesc is
 *    NULL, the track's first sample description is used.
 *  
 *  Parameters:
 *    
 *    track:
 *      [in] The track.
 *    
 *    sampleDesc:
 *      [in] The sample description handle.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function SetTrackApertureModeDimensionsUsingSampleDescription( track_: Track; sampleDesc: SampleDescriptionHandle { can be NULL } ): OSErr; external name '_SetTrackApertureModeDimensionsUsingSampleDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  GenerateMovieApertureModeDimensions()
 *  
 *  Summary:
 *    Examines a movie and sets up track aperture mode dimensions.
 *  
 *  Discussion:
 *    This function can be used to add information needed to support
 *    aperture modes to movies created with applications and/or
 *    versions of QuickTime that did not support aperture mode
 *    dimensions. If the image descriptions in video tracks lack tags
 *    describing clean aperture and pixel aspect ratio information, the
 *    media data may be scanned to see if the correct values can be
 *    divined and attached. Then the aperture mode dimensions are
 *    calculated and set for each track. Afterwards, the
 *    kQTVisualPropertyID_HasApertureModeDimensions property will be
 *    set to true for these tracks. Tracks which do not support
 *    aperture modes are not changed.
 *  
 *  Parameters:
 *    
 *    movie:
 *      [in] The movie.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GenerateMovieApertureModeDimensions( movie_: Movie ): OSErr; external name '_GenerateMovieApertureModeDimensions';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  GenerateTrackApertureModeDimensions()
 *  
 *  Summary:
 *    Examines a track and sets up aperture mode dimensions.
 *  
 *  Discussion:
 *    This function can be used to add information needed to support
 *    aperture modes to tracks created with applications and/or
 *    versions of QuickTime that did not support aperture mode
 *    dimensions. If the image descriptions in video tracks lack tags
 *    describing clean aperture and pixel aspect ratio information, the
 *    media data may be scanned to see if the correct values can be
 *    divined and attached. Then the aperture mode dimensions are
 *    calculated and set. Afterwards, the
 *    kQTVisualPropertyID_HasApertureModeDimensions property will be
 *    set to true for these tracks. Tracks which do not support
 *    aperture modes are not changed.
 *  
 *  Parameters:
 *    
 *    track:
 *      [in] The track.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GenerateTrackApertureModeDimensions( track_: Track ): OSErr; external name '_GenerateTrackApertureModeDimensions';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  RemoveMovieApertureModeDimensions()
 *  
 *  Summary:
 *    Removes aperture mode dimension information from a movie.
 *  
 *  Discussion:
 *    This function removes aperture mode dimension information from a
 *    movie's tracks. It does not attempt to modify sample
 *    descriptions, so it may not completely reverse the effect of
 *    GenerateMovieApertureModeDimensions. It sets the
 *    kQTVisualPropertyID_HasApertureModeDimensions property to false.
 *  
 *  Parameters:
 *    
 *    movie:
 *      [in] The movie.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function RemoveMovieApertureModeDimensions( movie_: Movie ): OSErr; external name '_RemoveMovieApertureModeDimensions';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  RemoveTrackApertureModeDimensions()
 *  
 *  Summary:
 *    Removes aperture mode dimension information from a track.
 *  
 *  Discussion:
 *    This function removes aperture mode dimension information from a
 *    track. It does not attempt to modify sample descriptions, so it
 *    may not completely reverse the effect of
 *    GenerateTrackApertureModeDimensions. It sets the
 *    kQTVisualPropertyID_HasApertureModeDimensions property to false.
 *  
 *  Parameters:
 *    
 *    track:
 *      [in] The track.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.1) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function RemoveTrackApertureModeDimensions( track_: Track ): OSErr; external name '_RemoveTrackApertureModeDimensions';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{****
    Error reporting
****}
type
	QTErrorReplacementRecordPtr = ^QTErrorReplacementRecord;
	QTErrorReplacementRecord = record
		numEntries: SIGNEDLONG;
		replacementString: array [0..1] of StringPtr;   { array of numEntries StringPtrs (each String is allocated separately).}
	end;
type
	QTErrorReplacementPtr = QTErrorReplacementRecordPtr;
{
    QTAddMovieError is used to add orthogonal errors to a list of errors that will
    later be reported (at the end of an import or playback, for example).  Errors are stored
    in 'qter' resources within the component.
    
    QTAddMovieError(Movie       addTo,                          // in: movie to add error to
                    Component   adder,                          // in: component which is adding the error
                    long        errorCode,                      // in: error code being added
                    QTErrorReplacementPtr   stringReplacements);// in: list of strings to subsitute (in order) for "^1", "^2", etc
}
{
 *  QTAddMovieError()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTAddMovieError( movieH: Movie; c: Component; errorCode: SIGNEDLONG; stringReplacements: QTErrorReplacementPtr ): OSErr; external name '_QTAddMovieError';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{****
    Access Keys
****}
const
	kAccessKeyAtomType = FourCharCode('acky');

const
	kAccessKeySystemFlag = 1 shl 0;

{
 *  QTGetAccessKeys()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTGetAccessKeys( var accessKeyType: Str255; flags: SIGNEDLONG; var keys: QTAtomContainer ): OSErr; external name '_QTGetAccessKeys';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTRegisterAccessKey()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTRegisterAccessKey( var accessKeyType: Str255; flags: SIGNEDLONG; accessKey: Handle ): OSErr; external name '_QTRegisterAccessKey';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTUnregisterAccessKey()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTUnregisterAccessKey( var accessKeyType: Str255; flags: SIGNEDLONG; accessKey: Handle ): OSErr; external name '_QTUnregisterAccessKey';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{****
    Content Restrictions
****}

{
 *  QTGetMovieRestrictions()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTGetMovieRestrictions( theMovie: Movie; var outRestrictionSet: QTRestrictionSet; var outSeed: UInt32 ): OSErr; external name '_QTGetMovieRestrictions';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTRestrictionsGetInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTRestrictionsGetInfo( inRestrictionSet: QTRestrictionSet; var outRestrictionClassCount: SIGNEDLONG; var outSeed: SIGNEDLONG ): OSErr; external name '_QTRestrictionsGetInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTRestrictionsGetIndClass()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTRestrictionsGetIndClass( inRestrictionSet: QTRestrictionSet; inIndex: SIGNEDLONG; var outClass: OSType ): OSErr; external name '_QTRestrictionsGetIndClass';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTRestrictionsGetItem()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTRestrictionsGetItem( inRestrictionSet: QTRestrictionSet; inRestrictionClass: OSType; var outRestrictions: UInt32 ): OSErr; external name '_QTRestrictionsGetItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTGetSupportedRestrictions()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTGetSupportedRestrictions( inRestrictionClass: OSType; var outRestrictionIDs: UInt32 ): OSErr; external name '_QTGetSupportedRestrictions';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTCreateUUID()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTCreateUUID( var outUUID: QTUUID; creationFlags: SIGNEDLONG ): OSErr; external name '_QTCreateUUID';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  QTEqualUUIDs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function QTEqualUUIDs( const (*var*) uuid1: QTUUID; const (*var*) uuid2: QTUUID ): Boolean; external name '_QTEqualUUIDs';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{****
    Time table
****}
{
 *  MakeTrackTimeTable()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MakeTrackTimeTable( trackH: Track; var offsets: SIGNEDLONGPtr; startTime: TimeValue; endTime: TimeValue; timeIncrement: TimeValue; firstDataRefIndex: SInt16; lastDataRefIndex: SInt16; var retdataRefSkew: SIGNEDLONG ): OSErr; external name '_MakeTrackTimeTable';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MakeMediaTimeTable()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MakeMediaTimeTable( theMedia: Media; var offsets: SIGNEDLONGPtr; startTime: TimeValue; endTime: TimeValue; timeIncrement: TimeValue; firstDataRefIndex: SInt16; lastDataRefIndex: SInt16; var retdataRefSkew: SIGNEDLONG ): OSErr; external name '_MakeMediaTimeTable';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetMaxLoadedTimeInMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetMaxLoadedTimeInMovie( theMovie: Movie; var time: TimeValue ): OSErr; external name '_GetMaxLoadedTimeInMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTMovieNeedsTimeTable()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTMovieNeedsTimeTable( theMovie: Movie; var needsTimeTable: Boolean ): OSErr; external name '_QTMovieNeedsTimeTable';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTGetDataRefMaxFileOffset()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTGetDataRefMaxFileOffset( movieH: Movie; dataRefType: OSType; dataRef: Handle; var offset: SIGNEDLONG ): OSErr; external name '_QTGetDataRefMaxFileOffset';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	kQTIdlePriority = 10;
	kQTNonRealTimePriority = 20;
	kQTRealTimeSharedPriority = 25;
	kQTRealTimePriority = 30;


{
 *  NewQTCallBackUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewQTCallBackUPP( userRoutine: QTCallBackProcPtr ): QTCallBackUPP; external name '_NewQTCallBackUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewQTSyncTaskUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewQTSyncTaskUPP( userRoutine: QTSyncTaskProcPtr ): QTSyncTaskUPP; external name '_NewQTSyncTaskUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewMovieRgnCoverUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewMovieRgnCoverUPP( userRoutine: MovieRgnCoverProcPtr ): MovieRgnCoverUPP; external name '_NewMovieRgnCoverUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewMovieProgressUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewMovieProgressUPP( userRoutine: MovieProgressProcPtr ): MovieProgressUPP; external name '_NewMovieProgressUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewMovieDrawingCompleteUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewMovieDrawingCompleteUPP( userRoutine: MovieDrawingCompleteProcPtr ): MovieDrawingCompleteUPP; external name '_NewMovieDrawingCompleteUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewTrackTransferUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewTrackTransferUPP( userRoutine: TrackTransferProcPtr ): TrackTransferUPP; external name '_NewTrackTransferUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewGetMovieUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewGetMovieUPP( userRoutine: GetMovieProcPtr ): GetMovieUPP; external name '_NewGetMovieUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewMoviePreviewCallOutUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewMoviePreviewCallOutUPP( userRoutine: MoviePreviewCallOutProcPtr ): MoviePreviewCallOutUPP; external name '_NewMoviePreviewCallOutUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewTextMediaUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewTextMediaUPP( userRoutine: TextMediaProcPtr ): TextMediaUPP; external name '_NewTextMediaUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewActionsUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewActionsUPP( userRoutine: ActionsProcPtr ): ActionsUPP; external name '_NewActionsUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewDoMCActionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewDoMCActionUPP( userRoutine: DoMCActionProcPtr ): DoMCActionUPP; external name '_NewDoMCActionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewMovieExecuteWiredActionsUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewMovieExecuteWiredActionsUPP( userRoutine: MovieExecuteWiredActionsProcPtr ): MovieExecuteWiredActionsUPP; external name '_NewMovieExecuteWiredActionsUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewMoviePrePrerollCompleteUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewMoviePrePrerollCompleteUPP( userRoutine: MoviePrePrerollCompleteProcPtr ): MoviePrePrerollCompleteUPP; external name '_NewMoviePrePrerollCompleteUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewQTNextTaskNeededSoonerCallbackUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewQTNextTaskNeededSoonerCallbackUPP( userRoutine: QTNextTaskNeededSoonerCallbackProcPtr ): QTNextTaskNeededSoonerCallbackUPP; external name '_NewQTNextTaskNeededSoonerCallbackUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)

{
 *  NewMoviesErrorUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewMoviesErrorUPP( userRoutine: MoviesErrorProcPtr ): MoviesErrorUPP; external name '_NewMoviesErrorUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewTweenerDataUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewTweenerDataUPP( userRoutine: TweenerDataProcPtr ): TweenerDataUPP; external name '_NewTweenerDataUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewQTEffectListFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewQTEffectListFilterUPP( userRoutine: QTEffectListFilterProcPtr ): QTEffectListFilterUPP; external name '_NewQTEffectListFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)

{
 *  DisposeQTCallBackUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeQTCallBackUPP( userUPP: QTCallBackUPP ); external name '_DisposeQTCallBackUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeQTSyncTaskUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeQTSyncTaskUPP( userUPP: QTSyncTaskUPP ); external name '_DisposeQTSyncTaskUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeMovieRgnCoverUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeMovieRgnCoverUPP( userUPP: MovieRgnCoverUPP ); external name '_DisposeMovieRgnCoverUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeMovieProgressUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeMovieProgressUPP( userUPP: MovieProgressUPP ); external name '_DisposeMovieProgressUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeMovieDrawingCompleteUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeMovieDrawingCompleteUPP( userUPP: MovieDrawingCompleteUPP ); external name '_DisposeMovieDrawingCompleteUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeTrackTransferUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeTrackTransferUPP( userUPP: TrackTransferUPP ); external name '_DisposeTrackTransferUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeGetMovieUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeGetMovieUPP( userUPP: GetMovieUPP ); external name '_DisposeGetMovieUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeMoviePreviewCallOutUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeMoviePreviewCallOutUPP( userUPP: MoviePreviewCallOutUPP ); external name '_DisposeMoviePreviewCallOutUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeTextMediaUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeTextMediaUPP( userUPP: TextMediaUPP ); external name '_DisposeTextMediaUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeActionsUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeActionsUPP( userUPP: ActionsUPP ); external name '_DisposeActionsUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeDoMCActionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeDoMCActionUPP( userUPP: DoMCActionUPP ); external name '_DisposeDoMCActionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeMovieExecuteWiredActionsUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeMovieExecuteWiredActionsUPP( userUPP: MovieExecuteWiredActionsUPP ); external name '_DisposeMovieExecuteWiredActionsUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeMoviePrePrerollCompleteUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeMoviePrePrerollCompleteUPP( userUPP: MoviePrePrerollCompleteUPP ); external name '_DisposeMoviePrePrerollCompleteUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeQTNextTaskNeededSoonerCallbackUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeQTNextTaskNeededSoonerCallbackUPP( userUPP: QTNextTaskNeededSoonerCallbackUPP ); external name '_DisposeQTNextTaskNeededSoonerCallbackUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)

{
 *  DisposeMoviesErrorUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeMoviesErrorUPP( userUPP: MoviesErrorUPP ); external name '_DisposeMoviesErrorUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeTweenerDataUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeTweenerDataUPP( userUPP: TweenerDataUPP ); external name '_DisposeTweenerDataUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeQTEffectListFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeQTEffectListFilterUPP( userUPP: QTEffectListFilterUPP ); external name '_DisposeQTEffectListFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)

{
 *  InvokeQTCallBackUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeQTCallBackUPP( cb: QTCallBack; refCon: SIGNEDLONG; userUPP: QTCallBackUPP ); external name '_InvokeQTCallBackUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeQTSyncTaskUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeQTSyncTaskUPP( task: UnivPtr; userUPP: QTSyncTaskUPP ); external name '_InvokeQTSyncTaskUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeMovieRgnCoverUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeMovieRgnCoverUPP( theMovie: Movie; changedRgn: RgnHandle; refcon: SIGNEDLONG; userUPP: MovieRgnCoverUPP ): OSErr; external name '_InvokeMovieRgnCoverUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeMovieProgressUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeMovieProgressUPP( theMovie: Movie; message: SInt16; whatOperation: SInt16; percentDone: Fixed; refcon: SIGNEDLONG; userUPP: MovieProgressUPP ): OSErr; external name '_InvokeMovieProgressUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeMovieDrawingCompleteUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeMovieDrawingCompleteUPP( theMovie: Movie; refCon: SIGNEDLONG; userUPP: MovieDrawingCompleteUPP ): OSErr; external name '_InvokeMovieDrawingCompleteUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeTrackTransferUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeTrackTransferUPP( t: Track; refCon: SIGNEDLONG; userUPP: TrackTransferUPP ): OSErr; external name '_InvokeTrackTransferUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeGetMovieUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeGetMovieUPP( offset: SIGNEDLONG; size: SIGNEDLONG; dataPtr: UnivPtr; refCon: UnivPtr; userUPP: GetMovieUPP ): OSErr; external name '_InvokeGetMovieUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeMoviePreviewCallOutUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeMoviePreviewCallOutUPP( refcon: SIGNEDLONG; userUPP: MoviePreviewCallOutUPP ): Boolean; external name '_InvokeMoviePreviewCallOutUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeTextMediaUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeTextMediaUPP( theText: Handle; theMovie: Movie; var displayFlag: SInt16; refcon: SIGNEDLONG; userUPP: TextMediaUPP ): OSErr; external name '_InvokeTextMediaUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeActionsUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeActionsUPP( refcon: UnivPtr; targetTrack: Track; targetRefCon: SIGNEDLONG; theEvent: QTEventRecordPtr; userUPP: ActionsUPP ): OSErr; external name '_InvokeActionsUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeDoMCActionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeDoMCActionUPP( refcon: UnivPtr; action: SInt16; params: UnivPtr; var handled: Boolean; userUPP: DoMCActionUPP ): OSErr; external name '_InvokeDoMCActionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeMovieExecuteWiredActionsUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeMovieExecuteWiredActionsUPP( theMovie: Movie; refcon: UnivPtr; flags: SIGNEDLONG; wiredActions: QTAtomContainer; userUPP: MovieExecuteWiredActionsUPP ): OSErr; external name '_InvokeMovieExecuteWiredActionsUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeMoviePrePrerollCompleteUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeMoviePrePrerollCompleteUPP( theMovie: Movie; prerollErr: OSErr; refcon: UnivPtr; userUPP: MoviePrePrerollCompleteUPP ); external name '_InvokeMoviePrePrerollCompleteUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeQTNextTaskNeededSoonerCallbackUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeQTNextTaskNeededSoonerCallbackUPP( duration: TimeValue; flags: UNSIGNEDLONG; refcon: UnivPtr; userUPP: QTNextTaskNeededSoonerCallbackUPP ); external name '_InvokeQTNextTaskNeededSoonerCallbackUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)

{
 *  InvokeMoviesErrorUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeMoviesErrorUPP( theErr: OSErr; refcon: SIGNEDLONG; userUPP: MoviesErrorUPP ); external name '_InvokeMoviesErrorUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeTweenerDataUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeTweenerDataUPP( tr: TweenRecordPtr; tweenData: UnivPtr; tweenDataSize: SIGNEDLONG; dataDescriptionSeed: SIGNEDLONG; dataDescription: Handle; asyncCompletionProc: ICMCompletionProcRecordPtr; transferProc: UniversalProcPtr; refCon: UnivPtr; userUPP: TweenerDataUPP ): ComponentResult; external name '_InvokeTweenerDataUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeQTEffectListFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeQTEffectListFilterUPP( effect: Component; effectMinSource: SIGNEDLONG; effectMaxSource: SIGNEDLONG; majorClass: OSType; minorClass: OSType; refcon: UnivPtr; userUPP: QTEffectListFilterUPP ): Boolean; external name '_InvokeQTEffectListFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{****
    Connection Speed
****}
const
	ConnectionSpeedPrefsType = FourCharCode('cspd');
	ConnectionSpeedIsValidPrefsType = FourCharCode('vspd');

type
	ConnectionSpeedPrefsRecordPtr = ^ConnectionSpeedPrefsRecord;
	ConnectionSpeedPrefsRecord = record
		connectionSpeed: SIGNEDLONG;
	end;
type
	ConnectionSpeedPrefsPtr = ^ConnectionSpeedPrefsRecord;
	ConnectionSpeedPrefsHandle = ^ConnectionSpeedPrefsPtr;
{
 *  QTGetConnectionSpeedFromPrefs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function QTGetConnectionSpeedFromPrefs( var pConnectionSpeed: SIGNEDLONG ): OSErr; external name '_QTGetConnectionSpeedFromPrefs';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{****
    QT International Text Atom Support
****}
const
	kITextRemoveEverythingBut = 0 shl 1;
	kITextRemoveLeaveSuggestedAlternate = 1 shl 1;

const
	kITextAtomType = FourCharCode('itxt');
	kITextStringAtomType = FourCharCode('text');

{
 *  ITextAddString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ITextAddString( container: QTAtomContainer; parentAtom: QTAtom; theRegionCode: RegionCode; const (*var*) theString: Str255 ): OSErr; external name '_ITextAddString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ITextRemoveString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ITextRemoveString( container: QTAtomContainer; parentAtom: QTAtom; theRegionCode: RegionCode; flags: SIGNEDLONG ): OSErr; external name '_ITextRemoveString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ITextGetString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function ITextGetString( container: QTAtomContainer; parentAtom: QTAtom; requestedRegion: RegionCode; var foundRegion: RegionCode; theString: StringPtr ): OSErr; external name '_ITextGetString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  QTTextToNativeText()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function QTTextToNativeText( theText: Handle; encoding: SIGNEDLONG; flags: SIGNEDLONG ): OSErr; external name '_QTTextToNativeText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ QTParseTextHREF inContainer atoms}
const
	kQTParseTextHREFText = FourCharCode('text'); { string}
	kQTParseTextHREFBaseURL = FourCharCode('burl'); { string}
	kQTParseTextHREFClickPoint = FourCharCode('clik'); { Point; if present, QTParseTextHREF will expand URLs to support server-side image maps}
	kQTParseTextHREFUseAltDelim = FourCharCode('altd'); { boolean; if no kQTParseTextHREFDelimiter, delim is ':'}
	kQTParseTextHREFDelimiter = FourCharCode('delm'); { character}
	kQTParseTextHREFRecomposeHREF = FourCharCode('rhrf'); { Boolean; if true, QTParseTextHREF returns recomposed HREF with URL expanded as appropriate}

{ QTParseTextHREF outContainer atoms}
const
	kQTParseTextHREFURL = FourCharCode('url '); { string}
	kQTParseTextHREFTarget = FourCharCode('targ'); { string}
	kQTParseTextHREFChapter = FourCharCode('chap'); { string}
	kQTParseTextHREFIsAutoHREF = FourCharCode('auto'); { Boolean}
	kQTParseTextHREFIsServerMap = FourCharCode('smap'); { Boolean}
	kQTParseTextHREFHREF = FourCharCode('href'); { string; recomposed HREF with URL expanded as appropriate, suitable for mcActionLinkToURL}
	kQTParseTextHREFEMBEDArgs = FourCharCode('mbed'); { string; text between 'E<' and '>' to be used as new movie's embed tags}

{
 *  QTParseTextHREF()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function QTParseTextHREF( href: CStringPtr; hrefLen: SInt32; inContainer: QTAtomContainer; var outContainer: QTAtomContainer ): OSErr; external name '_QTParseTextHREF';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* track reference types
*************************}
const
	kTrackReferenceChapterList = FourCharCode('chap');
	kTrackReferenceTimeCode = FourCharCode('tmcd');
	kTrackReferenceModifier = FourCharCode('ssrc');

{************************
* modifier track types
*************************}
const
	kTrackModifierInput = $696E; { is really 'in'}
	kTrackModifierType = $7479; { is really 'ty'}
	kTrackModifierReference = FourCharCode('ssrc');
	kTrackModifierObjectID = FourCharCode('obid');
	kTrackModifierInputName = FourCharCode('name');

const
	kInputMapSubInputID = FourCharCode('subi');

const
	kTrackModifierTypeMatrix = 1;
	kTrackModifierTypeClip = 2;
	kTrackModifierTypeGraphicsMode = 5;
	kTrackModifierTypeVolume = 3;
	kTrackModifierTypeBalance = 4;
	kTrackModifierTypeImage = FourCharCode('vide'); { was kTrackModifierTypeSpriteImage}
	kTrackModifierObjectMatrix = 6;
	kTrackModifierObjectGraphicsMode = 7;
	kTrackModifierType3d4x4Matrix = 8;
	kTrackModifierCameraData = 9;
	kTrackModifierSoundLocalizationData = 10;
	kTrackModifierObjectImageIndex = 11;
	kTrackModifierObjectLayer = 12;
	kTrackModifierObjectVisible = 13;
	kTrackModifierAngleAspectCamera = 14;
	kTrackModifierPanAngle = FourCharCode('pan ');
	kTrackModifierTiltAngle = FourCharCode('tilt');
	kTrackModifierVerticalFieldOfViewAngle = FourCharCode('fov ');
	kTrackModifierObjectQTEventSend = FourCharCode('evnt');
	kTrackModifierObjectCanBeHitTested = 15;


type
	ModifierTrackGraphicsModeRecordPtr = ^ModifierTrackGraphicsModeRecord;
	ModifierTrackGraphicsModeRecord = record
		graphicsMode: SIGNEDLONG;
		opColor: RGBColor;
	end;

{************************
* tween track types
*************************}
const
	kTweenTypeShort = 1;
	kTweenTypeLong = 2;
	kTweenTypeFixed = 3;
	kTweenTypePoint = 4;
	kTweenTypeQDRect = 5;
	kTweenTypeQDRegion = 6;
	kTweenTypeMatrix = 7;
	kTweenTypeRGBColor = 8;
	kTweenTypeGraphicsModeWithRGBColor = 9;
	kTweenTypeQTFloatSingle = 10;
	kTweenTypeQTFloatDouble = 11;
	kTweenTypeFixedPoint = 12;
	kTweenType3dScale = FourCharCode('3sca');
	kTweenType3dTranslate = FourCharCode('3tra');
	kTweenType3dRotate = FourCharCode('3rot');
	kTweenType3dRotateAboutPoint = FourCharCode('3rap');
	kTweenType3dRotateAboutAxis = FourCharCode('3rax');
	kTweenType3dRotateAboutVector = FourCharCode('3rvc');
	kTweenType3dQuaternion = FourCharCode('3qua');
	kTweenType3dMatrix = FourCharCode('3mat');
	kTweenType3dCameraData = FourCharCode('3cam');
	kTweenType3dAngleAspectCameraData = FourCharCode('3caa');
	kTweenType3dSoundLocalizationData = FourCharCode('3slc');
	kTweenTypePathToMatrixTranslation = FourCharCode('gxmt');
	kTweenTypePathToMatrixRotation = FourCharCode('gxpr');
	kTweenTypePathToMatrixTranslationAndRotation = FourCharCode('gxmr');
	kTweenTypePathToFixedPoint = FourCharCode('gxfp');
	kTweenTypePathXtoY = FourCharCode('gxxy');
	kTweenTypePathYtoX = FourCharCode('gxyx');
	kTweenTypeAtomList = FourCharCode('atom');
	kTweenTypePolygon = FourCharCode('poly');
	kTweenTypeMultiMatrix = FourCharCode('mulm');
	kTweenTypeSpin = FourCharCode('spin');
	kTweenType3dMatrixNonLinear = FourCharCode('3nlr');
	kTweenType3dVRObject = FourCharCode('3vro');

const
	kTweenEntry = FourCharCode('twen');
	kTweenData = FourCharCode('data');
	kTweenType = FourCharCode('twnt');
	kTweenStartOffset = FourCharCode('twst');
	kTweenDuration = FourCharCode('twdu');
	kTweenFlags = FourCharCode('flag');
	kTweenOutputMin = FourCharCode('omin');
	kTweenOutputMax = FourCharCode('omax');
	kTweenSequenceElement = FourCharCode('seqe');
	kTween3dInitialCondition = FourCharCode('icnd');
	kTweenInterpolationID = FourCharCode('intr');
	kTweenRegionData = FourCharCode('qdrg');
	kTweenPictureData = FourCharCode('PICT');
	kListElementType = FourCharCode('type');
	kListElementDataType = FourCharCode('daty');
	kNameAtom = FourCharCode('name');
	kInitialRotationAtom = FourCharCode('inro');
	kNonLinearTweenHeader = FourCharCode('nlth');

{ kTweenFlags}
const
	kTweenReturnDelta = 1 shl 0;

type
	TweenSequenceEntryRecord = record
		endPercent: Fixed;
		tweenAtomID: QTAtomID;
		dataAtomID: QTAtomID;
	end;

(* #ifdef __QD3D__

type
	ThreeDeeVRObjectSample = record
		rows: SIGNEDLONG;  
		columns: SIGNEDLONG;
		calib1: TQ3Matrix4x4;
		calib2: TQ3Matrix4x4;
		reserved1: SIGNEDLONG;
		reserved2: SIGNEDLONG;
	end;

type
	ThreeDeeNonLinearSample = record
		DurFromLastSample: Float32;  { 0 to 1 }
		matrix: TQ3Matrix4x4;
	end;

type
	ThreeDeeNonLinearTweenHeaderAtom = record
		number: SIGNEDLONG;
		dataSize: SIGNEDLONG;
		tensionFactor: Float32;  { default is 0 }
		reserved1: SIGNEDLONG;
		reserved2: SIGNEDLONG;
	end;


#endif
*)


(* #if OLDROUTINENAMES

{************************
* Video Media routines
*************************}

#define GetVideoMediaGraphicsMode      MediaGetGraphicsMode
#define SetVideoMediaGraphicsMode      MediaSetGraphicsMode

{ use these two routines at your own peril }
#define ResetVideoMediaStatistics      VideoMediaResetStatistics
#define GetVideoMediaStatistics           VideoMediaGetStatistics

{************************
* Sound Media routines
*************************}

#define GetSoundMediaBalance            MediaGetSoundBalance
#define SetSoundMediaBalance           MediaSetSoundBalance

{************************
* Text Media routines
*************************}

#define SetTextProc         TextMediaSetTextProc
#define AddTextSample      TextMediaAddTextSample
#define AddTESample          TextMediaAddTESample
#define AddHiliteSample        TextMediaAddHiliteSample
#define FindNextText       TextMediaFindNextText
#define HiliteTextSample  TextMediaHiliteTextSample
#define SetTextSampleData TextMediaSetTextSampleData
#define DrawRaw              TextMediaDrawRaw
#define RawSetup           TextMediaRawSetup
#define RawIdle               TextMediaRawIdle
#define SetTextProperty        TextMediaSetTextProperty

{************************
* Sprite Media routines
*************************}

#define SetSpriteMediaSpriteProperty  SpriteMediaSetProperty
#define GetSpriteMediaSpriteProperty SpriteMediaGetProperty
#define HitTestSpriteMedia               SpriteMediaHitTestSprites
#define CountSpriteMediaSprites           SpriteMediaCountSprites
#define CountSpriteMediaImages          SpriteMediaCountImages
#define GetSpriteMediaIndImageDescription    SpriteMediaGetIndImageDescription
#define GetDisplayedSampleNumber      SpriteMediaGetDisplayedSampleNumber
#endif { OLDROUTINENAMES }
*)

{****
    Content Restrictions
****}
const
	kQTRestrictionClassSave = FourCharCode('save');
	kQTRestrictionSaveDontAddMovieResource = 1 shl 0;
	kQTRestrictionSaveDontFlatten = 1 shl 1;
	kQTRestrictionSaveDontExport = 1 shl 2;
	kQTRestrictionSaveDontExtract = 1 shl 3; { don't allow any form of extraction of content}
	kQTRestrictionClassEdit = FourCharCode('edit');
	kQTRestrictionEditDontCopy = 1 shl 0; { disable copy }
	kQTRestrictionEditDontCut = 1 shl 1; { disable cut }
	kQTRestrictionEditDontPaste = 1 shl 2; { disable paste }
	kQTRestrictionEditDontClear = 1 shl 3; { disable clear}
	kQTRestrictionEditDontModify = 1 shl 4; { don't allow modification of content}
	kQTRestrictionEditDontExtract = 1 shl 5; { don't allow any form of extraction of content}
	kQTRestrictionClassPlay = FourCharCode('play');
	kQTRestrictionPlayDontPlay = 1 shl 0; { disable playback   }


{************************
* Video Media routines
*************************}


const
	videoFlagDontLeanAhead = 1 shl 0;


{ use these five routines at your own peril}
{
 *  VideoMediaResetStatistics()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VideoMediaResetStatistics( mh: MediaHandler ): ComponentResult; external name '_VideoMediaResetStatistics';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VideoMediaGetStatistics()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VideoMediaGetStatistics( mh: MediaHandler ): ComponentResult; external name '_VideoMediaGetStatistics';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VideoMediaGetStallCount()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function VideoMediaGetStallCount( mh: MediaHandler; var stalls: UNSIGNEDLONG ): ComponentResult; external name '_VideoMediaGetStallCount';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VideoMediaSetCodecParameter()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function VideoMediaSetCodecParameter( mh: MediaHandler; cType: CodecType; parameterID: OSType; parameterChangeSeed: SIGNEDLONG; dataPtr: UnivPtr; dataSize: SIGNEDLONG ): ComponentResult; external name '_VideoMediaSetCodecParameter';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  VideoMediaGetCodecParameter()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function VideoMediaGetCodecParameter( mh: MediaHandler; cType: CodecType; parameterID: OSType; outParameterData: Handle ): ComponentResult; external name '_VideoMediaGetCodecParameter';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Text Media routines
*************************}


{ Return displayFlags for TextProc }
const
	txtProcDefaultDisplay = 0;    {    Use the media's default}
	txtProcDontDisplay = 1;    {    Don't display the text}
	txtProcDoDisplay = 2;     {    Do display the text}

{
 *  TextMediaSetTextProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TextMediaSetTextProc( mh: MediaHandler; TextProc: TextMediaUPP; refcon: SIGNEDLONG ): ComponentResult; external name '_TextMediaSetTextProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TextMediaAddTextSample()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TextMediaAddTextSample( mh: MediaHandler; text: Ptr; size: UNSIGNEDLONG; fontNumber: SInt16; fontSize: SInt16; txtFace: ByteParameter; var textColor: RGBColor; var backColor: RGBColor; textJustification: SInt16; var textBox: Rect; displayFlags: SIGNEDLONG; scrollDelay: TimeValue; hiliteStart: SInt16; hiliteEnd: SInt16; var rgbHiliteColor: RGBColor; duration: TimeValue; var sampleTime: TimeValue ): ComponentResult; external name '_TextMediaAddTextSample';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TextMediaAddTESample()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TextMediaAddTESample( mh: MediaHandler; hTE: TEHandle; var backColor: RGBColor; textJustification: SInt16; var textBox: Rect; displayFlags: SIGNEDLONG; scrollDelay: TimeValue; hiliteStart: SInt16; hiliteEnd: SInt16; var rgbHiliteColor: RGBColor; duration: TimeValue; var sampleTime: TimeValue ): ComponentResult; external name '_TextMediaAddTESample';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TextMediaAddHiliteSample()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TextMediaAddHiliteSample( mh: MediaHandler; hiliteStart: SInt16; hiliteEnd: SInt16; var rgbHiliteColor: RGBColor; duration: TimeValue; var sampleTime: TimeValue ): ComponentResult; external name '_TextMediaAddHiliteSample';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TextMediaDrawRaw()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function TextMediaDrawRaw( mh: MediaHandler; gw: GWorldPtr; gd: GDHandle; data: UnivPtr; dataSize: SIGNEDLONG; tdh: TextDescriptionHandle ): ComponentResult; external name '_TextMediaDrawRaw';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TextMediaSetTextProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function TextMediaSetTextProperty( mh: MediaHandler; atMediaTime: TimeValue; propertyType: SIGNEDLONG; data: UnivPtr; dataSize: SIGNEDLONG ): ComponentResult; external name '_TextMediaSetTextProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TextMediaRawSetup()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function TextMediaRawSetup( mh: MediaHandler; gw: GWorldPtr; gd: GDHandle; data: UnivPtr; dataSize: SIGNEDLONG; tdh: TextDescriptionHandle; sampleDuration: TimeValue ): ComponentResult; external name '_TextMediaRawSetup';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TextMediaRawIdle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function TextMediaRawIdle( mh: MediaHandler; gw: GWorldPtr; gd: GDHandle; sampleTime: TimeValue; flagsIn: SIGNEDLONG; var flagsOut: SIGNEDLONG ): ComponentResult; external name '_TextMediaRawIdle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TextMediaGetTextProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function TextMediaGetTextProperty( mh: MediaHandler; atMediaTime: TimeValue; propertyType: SIGNEDLONG; data: UnivPtr; dataSize: SIGNEDLONG ): ComponentResult; external name '_TextMediaGetTextProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	findTextEdgeOK = 1 shl 0; { Okay to find text at specified sample time}
	findTextCaseSensitive = 1 shl 1; { Case sensitive search}
	findTextReverseSearch = 1 shl 2; { Search from sampleTime backwards}
	findTextWrapAround = 1 shl 3; { Wrap search when beginning or end of movie is hit}
	findTextUseOffset = 1 shl 4; { Begin search at the given character offset into sample rather than edge}

{
 *  TextMediaFindNextText()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TextMediaFindNextText( mh: MediaHandler; text: Ptr; size: SIGNEDLONG; findFlags: SInt16; startTime: TimeValue; var foundTime: TimeValue; var foundDuration: TimeValue; var offset: SIGNEDLONG ): ComponentResult; external name '_TextMediaFindNextText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TextMediaHiliteTextSample()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TextMediaHiliteTextSample( mh: MediaHandler; sampleTime: TimeValue; hiliteStart: SInt16; hiliteEnd: SInt16; var rgbHiliteColor: RGBColor ): ComponentResult; external name '_TextMediaHiliteTextSample';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


const
	dropShadowOffsetType = FourCharCode('drpo');
	dropShadowTranslucencyType = FourCharCode('drpt');

{
 *  TextMediaSetTextSampleData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function TextMediaSetTextSampleData( mh: MediaHandler; data: UnivPtr; dataType: OSType ): ComponentResult; external name '_TextMediaSetTextSampleData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* Sprite Media routines
*************************}
{ flags for sprite hit test routines }
const
	spriteHitTestBounds = 1 shl 0; {    point must only be within sprite's bounding box}
	spriteHitTestImage = 1 shl 1; {  point must be within the shape of the sprite's image}
	spriteHitTestInvisibleSprites = 1 shl 2; {  invisible sprites may be hit tested}
	spriteHitTestIsClick = 1 shl 3; {  for codecs that want mouse events}
	spriteHitTestLocInDisplayCoordinates = 1 shl 4; {    set if you want to pass a display coordiate point to SpriteHitTest}
	spriteHitTestTreatAllSpritesAsHitTestable = 1 shl 5; { set if you want to override each sprites hittestable property as true}

{ atom types for sprite media }
const
	kSpriteAtomType = FourCharCode('sprt');
	kSpriteImagesContainerAtomType = FourCharCode('imct');
	kSpriteImageAtomType = FourCharCode('imag');
	kSpriteImageDataAtomType = FourCharCode('imda');
	kSpriteImageDataRefAtomType = FourCharCode('imre');
	kSpriteImageDataRefTypeAtomType = FourCharCode('imrt');
	kSpriteImageGroupIDAtomType = FourCharCode('imgr');
	kSpriteImageRegistrationAtomType = FourCharCode('imrg');
	kSpriteImageDefaultImageIndexAtomType = FourCharCode('defi');
	kSpriteSharedDataAtomType = FourCharCode('dflt');
	kSpriteNameAtomType = FourCharCode('name');
	kSpriteImageNameAtomType = FourCharCode('name');
	kSpriteUsesImageIDsAtomType = FourCharCode('uses'); { leaf data is an array of QTAtomID's, one per image used}
	kSpriteBehaviorsAtomType = FourCharCode('beha');
	kSpriteImageBehaviorAtomType = FourCharCode('imag');
	kSpriteCursorBehaviorAtomType = FourCharCode('crsr');
	kSpriteStatusStringsBehaviorAtomType = FourCharCode('sstr');
	kSpriteVariablesContainerAtomType = FourCharCode('vars');
	kSpriteStringVariableAtomType = FourCharCode('strv');
	kSpriteFloatingPointVariableAtomType = FourCharCode('flov');

type
	QTRuntimeSpriteDescStructPtr = ^QTRuntimeSpriteDescStruct;
	QTRuntimeSpriteDescStruct = record
		version: SIGNEDLONG;                { set to zero}
		spriteID: QTAtomID;
		imageIndex: SInt16;
		matrix: MatrixRecord;
		visible: SInt16;
		layer: SInt16;
		graphicsMode: ModifierTrackGraphicsModeRecord;
		actionHandlingSpriteID: QTAtomID;
	end;
type
	QTRuntimeSpriteDescPtr = QTRuntimeSpriteDescStructPtr;
{
   when filling in QTSpriteButtonBehaviorStruct values -1 may be used to indicate that
   the state transition does not change the property
}
type
	QTSpriteButtonBehaviorStructPtr = ^QTSpriteButtonBehaviorStruct;
	QTSpriteButtonBehaviorStruct = record
		notOverNotPressedStateID: QTAtomID;
		overNotPressedStateID: QTAtomID;
		overPressedStateID: QTAtomID;
		notOverPressedStateID: QTAtomID;
	end;
type
	QTSpriteButtonBehaviorPtr = QTSpriteButtonBehaviorStructPtr;
{
 *  SpriteMediaSetProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaSetProperty( mh: MediaHandler; spriteIndex: SInt16; propertyType: SIGNEDLONG; propertyValue: UnivPtr ): ComponentResult; external name '_SpriteMediaSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaGetProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaGetProperty( mh: MediaHandler; spriteIndex: SInt16; propertyType: SIGNEDLONG; propertyValue: UnivPtr ): ComponentResult; external name '_SpriteMediaGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaHitTestSprites()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaHitTestSprites( mh: MediaHandler; flags: SIGNEDLONG; loc: Point; var spriteHitIndex: SInt16 ): ComponentResult; external name '_SpriteMediaHitTestSprites';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaCountSprites()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaCountSprites( mh: MediaHandler; var numSprites: SInt16 ): ComponentResult; external name '_SpriteMediaCountSprites';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaCountImages()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaCountImages( mh: MediaHandler; var numImages: SInt16 ): ComponentResult; external name '_SpriteMediaCountImages';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaGetIndImageDescription()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaGetIndImageDescription( mh: MediaHandler; imageIndex: SInt16; imageDescription: ImageDescriptionHandle ): ComponentResult; external name '_SpriteMediaGetIndImageDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaGetDisplayedSampleNumber()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaGetDisplayedSampleNumber( mh: MediaHandler; var sampleNum: SIGNEDLONG ): ComponentResult; external name '_SpriteMediaGetDisplayedSampleNumber';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaGetSpriteName()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaGetSpriteName( mh: MediaHandler; spriteID: QTAtomID; var spriteName: Str255 ): ComponentResult; external name '_SpriteMediaGetSpriteName';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaGetImageName()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaGetImageName( mh: MediaHandler; imageIndex: SInt16; var imageName: Str255 ): ComponentResult; external name '_SpriteMediaGetImageName';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaSetSpriteProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaSetSpriteProperty( mh: MediaHandler; spriteID: QTAtomID; propertyType: SIGNEDLONG; propertyValue: UnivPtr ): ComponentResult; external name '_SpriteMediaSetSpriteProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaGetSpriteProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaGetSpriteProperty( mh: MediaHandler; spriteID: QTAtomID; propertyType: SIGNEDLONG; propertyValue: UnivPtr ): ComponentResult; external name '_SpriteMediaGetSpriteProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaHitTestAllSprites()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaHitTestAllSprites( mh: MediaHandler; flags: SIGNEDLONG; loc: Point; var spriteHitID: QTAtomID ): ComponentResult; external name '_SpriteMediaHitTestAllSprites';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaHitTestOneSprite()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaHitTestOneSprite( mh: MediaHandler; spriteID: QTAtomID; flags: SIGNEDLONG; loc: Point; var wasHit: Boolean ): ComponentResult; external name '_SpriteMediaHitTestOneSprite';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaSpriteIndexToID()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaSpriteIndexToID( mh: MediaHandler; spriteIndex: SInt16; var spriteID: QTAtomID ): ComponentResult; external name '_SpriteMediaSpriteIndexToID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaSpriteIDToIndex()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaSpriteIDToIndex( mh: MediaHandler; spriteID: QTAtomID; var spriteIndex: SInt16 ): ComponentResult; external name '_SpriteMediaSpriteIDToIndex';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaGetSpriteActionsForQTEvent()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaGetSpriteActionsForQTEvent( mh: MediaHandler; event: QTEventRecordPtr; spriteID: QTAtomID; var container: QTAtomContainer; var atom: QTAtom ): ComponentResult; external name '_SpriteMediaGetSpriteActionsForQTEvent';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaSetActionVariable()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaSetActionVariable( mh: MediaHandler; variableID: QTAtomID; value: Float32Ptr ): ComponentResult; external name '_SpriteMediaSetActionVariable';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaGetActionVariable()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaGetActionVariable( mh: MediaHandler; variableID: QTAtomID; var value: Float32 ): ComponentResult; external name '_SpriteMediaGetActionVariable';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaGetIndImageProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function SpriteMediaGetIndImageProperty( mh: MediaHandler; imageIndex: SInt16; imagePropertyType: SIGNEDLONG; imagePropertyValue: UnivPtr ): ComponentResult; external name '_SpriteMediaGetIndImageProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaNewSprite()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function SpriteMediaNewSprite( mh: MediaHandler; newSpriteDesc: QTRuntimeSpriteDescPtr ): ComponentResult; external name '_SpriteMediaNewSprite';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaDisposeSprite()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function SpriteMediaDisposeSprite( mh: MediaHandler; spriteID: QTAtomID ): ComponentResult; external name '_SpriteMediaDisposeSprite';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaSetActionVariableToString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function SpriteMediaSetActionVariableToString( mh: MediaHandler; variableID: QTAtomID; theCString: Ptr ): ComponentResult; external name '_SpriteMediaSetActionVariableToString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaGetActionVariableAsString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function SpriteMediaGetActionVariableAsString( mh: MediaHandler; variableID: QTAtomID; var theCString: Handle ): ComponentResult; external name '_SpriteMediaGetActionVariableAsString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SpriteMediaNewImage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function SpriteMediaNewImage( mh: MediaHandler; dataRef: Handle; dataRefType: OSType; desiredID: QTAtomID ): ComponentResult; external name '_SpriteMediaNewImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  SpriteMediaDisposeImage()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function SpriteMediaDisposeImage( mh: MediaHandler; imageIndex: SInt16 ): ComponentResult; external name '_SpriteMediaDisposeImage';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  SpriteMediaImageIndexToID()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function SpriteMediaImageIndexToID( mh: MediaHandler; imageIndex: SInt16; var imageID: QTAtomID ): ComponentResult; external name '_SpriteMediaImageIndexToID';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{
 *  SpriteMediaImageIDToIndex()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function SpriteMediaImageIDToIndex( mh: MediaHandler; imageID: QTAtomID; var imageIndex: SInt16 ): ComponentResult; external name '_SpriteMediaImageIDToIndex';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{************************
* Flash Media routines
*************************}

{
 *  FlashMediaSetPan()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function FlashMediaSetPan( mh: MediaHandler; xPercent: SInt16; yPercent: SInt16 ): ComponentResult; external name '_FlashMediaSetPan';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlashMediaSetZoom()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function FlashMediaSetZoom( mh: MediaHandler; factor: SInt16 ): ComponentResult; external name '_FlashMediaSetZoom';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlashMediaSetZoomRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function FlashMediaSetZoomRect( mh: MediaHandler; left: SIGNEDLONG; top: SIGNEDLONG; right: SIGNEDLONG; bottom: SIGNEDLONG ): ComponentResult; external name '_FlashMediaSetZoomRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlashMediaGetRefConBounds()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function FlashMediaGetRefConBounds( mh: MediaHandler; refCon: SIGNEDLONG; var left: SIGNEDLONG; var top: SIGNEDLONG; var right: SIGNEDLONG; var bottom: SIGNEDLONG ): ComponentResult; external name '_FlashMediaGetRefConBounds';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlashMediaGetRefConID()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function FlashMediaGetRefConID( mh: MediaHandler; refCon: SIGNEDLONG; var refConID: SIGNEDLONG ): ComponentResult; external name '_FlashMediaGetRefConID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlashMediaIDToRefCon()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function FlashMediaIDToRefCon( mh: MediaHandler; refConID: SIGNEDLONG; var refCon: SIGNEDLONG ): ComponentResult; external name '_FlashMediaIDToRefCon';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlashMediaGetDisplayedFrameNumber()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function FlashMediaGetDisplayedFrameNumber( mh: MediaHandler; var flashFrameNumber: SIGNEDLONG ): ComponentResult; external name '_FlashMediaGetDisplayedFrameNumber';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlashMediaFrameNumberToMovieTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function FlashMediaFrameNumberToMovieTime( mh: MediaHandler; flashFrameNumber: SIGNEDLONG; var movieTime: TimeValue ): ComponentResult; external name '_FlashMediaFrameNumberToMovieTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlashMediaFrameLabelToMovieTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function FlashMediaFrameLabelToMovieTime( mh: MediaHandler; theLabel: Ptr; var movieTime: TimeValue ): ComponentResult; external name '_FlashMediaFrameLabelToMovieTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlashMediaGetFlashVariable()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function FlashMediaGetFlashVariable( mh: MediaHandler; path: CStringPtr; name: CStringPtr; var theVariableCStringOut: Handle ): ComponentResult; external name '_FlashMediaGetFlashVariable';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlashMediaSetFlashVariable()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function FlashMediaSetFlashVariable( mh: MediaHandler; path: CStringPtr; name: CStringPtr; value: CStringPtr; updateFocus: Boolean ): ComponentResult; external name '_FlashMediaSetFlashVariable';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlashMediaDoButtonActions()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function FlashMediaDoButtonActions( mh: MediaHandler; path: CStringPtr; buttonID: SIGNEDLONG; transition: SIGNEDLONG ): ComponentResult; external name '_FlashMediaDoButtonActions';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FlashMediaGetSupportedSwfVersion()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function FlashMediaGetSupportedSwfVersion( mh: MediaHandler; var swfVersion: UInt8 ): ComponentResult; external name '_FlashMediaGetSupportedSwfVersion';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ sample format atoms}
const
	kMovieMediaDataReference = FourCharCode('mmdr'); { data reference}
	kMovieMediaDefaultDataReferenceID = FourCharCode('ddri'); { atom id}
	kMovieMediaSlaveTime = FourCharCode('slti'); { boolean}
	kMovieMediaSlaveAudio = FourCharCode('slau'); { boolean}
	kMovieMediaSlaveGraphicsMode = FourCharCode('slgr'); { boolean}
	kMovieMediaAutoPlay = FourCharCode('play'); { boolean}
	kMovieMediaLoop = FourCharCode('loop'); { UInt8 (0=no loop, 1=loop, 2=palindrome loop)}
	kMovieMediaUseMIMEType = FourCharCode('mime'); { string indicating the MIME type to use for the dataref (usually not required)}
	kMovieMediaTitle = FourCharCode('titl'); { string of the media's title (tooltips)}
	kMovieMediaAltText = FourCharCode('altt'); { string of alternate text if media isn't loaded}
	kMovieMediaClipBegin = FourCharCode('clpb'); { MovieMediaTimeRecord of start time of embedded media}
	kMovieMediaClipDuration = FourCharCode('clpd'); { MovieMediaTimeRecord of duration of embedded media}
	kMovieMediaRegionAtom = FourCharCode('regi'); { contains subatoms that describe layout}
	kMovieMediaSlaveTrackDuration = FourCharCode('sltr'); { Boolean indicating that media handler should adjust track and media based on actual embedded movie duration}
	kMovieMediaEnableFrameStepping = FourCharCode('enfs'); { boolean. if true stepping on external movie steps frames within embedded movie.}
	kMovieMediaBackgroundColor = FourCharCode('bkcl'); { RGBColor.}
	kMovieMediaPrerollTime = FourCharCode('prer'); { SInt32 indicating preroll time}

{ fit types}
const
	kMovieMediaFitNone = 0;
	kMovieMediaFitScroll = FourCharCode('scro');
	kMovieMediaFitClipIfNecessary = FourCharCode('hidd');
	kMovieMediaFitFill = FourCharCode('fill');
	kMovieMediaFitMeet = FourCharCode('meet');
	kMovieMediaFitSlice = FourCharCode('slic');

{ sub atoms for region atom}
const
	kMovieMediaSpatialAdjustment = FourCharCode('fit '); { OSType from kMovieMediaFit*}
	kMovieMediaRectangleAtom = FourCharCode('rect');
	kMovieMediaTop = FourCharCode('top ');
	kMovieMediaLeft = FourCharCode('left');
	kMovieMediaWidth = FourCharCode('wd  ');
	kMovieMediaHeight = FourCharCode('ht  ');

{ contained movie properties}
const
	kMoviePropertyDuration = FourCharCode('dura'); { TimeValue *}
	kMoviePropertyTimeScale = FourCharCode('tims'); { TimeValue *}
	kMoviePropertyTime = FourCharCode('timv'); { TimeValue *}
	kMoviePropertyNaturalBounds = FourCharCode('natb'); { Rect *}
	kMoviePropertyMatrix = FourCharCode('mtrx'); { Matrix *}
	kMoviePropertyTrackList = FourCharCode('tlst'); { long ***}


const
	kTrackPropertyMediaType = FourCharCode('mtyp'); { OSType}
	kTrackPropertyInstantiation = FourCharCode('inst'); { MovieMediaInstantiationInfoRecord}

type
	MovieMediaTimeRecordPtr = ^MovieMediaTimeRecord;
	MovieMediaTimeRecord = record
		time: wide;
		scale: TimeScale;
	end;
type
	MovieMediaInstantiationInfoRecordPtr = ^MovieMediaInstantiationInfoRecord;
	MovieMediaInstantiationInfoRecord = record
		immediately: Boolean;
		pad: Boolean;
		bitRate: SInt32;
	end;
{************************
* Movie Media routines
*************************}


{
 *  MovieMediaGetChildDoMCActionCallback()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function MovieMediaGetChildDoMCActionCallback( mh: MediaHandler; var doMCActionCallbackProc: DoMCActionUPP; var refcon: SIGNEDLONG ): ComponentResult; external name '_MovieMediaGetChildDoMCActionCallback';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieMediaGetDoMCActionCallback()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function MovieMediaGetDoMCActionCallback( mh: MediaHandler; var doMCActionCallbackProc: DoMCActionUPP; var refcon: SIGNEDLONG ): ComponentResult; external name '_MovieMediaGetDoMCActionCallback';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieMediaGetCurrentMovieProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function MovieMediaGetCurrentMovieProperty( mh: MediaHandler; whichProperty: OSType; value: UnivPtr ): ComponentResult; external name '_MovieMediaGetCurrentMovieProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieMediaGetCurrentTrackProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function MovieMediaGetCurrentTrackProperty( mh: MediaHandler; trackID: SIGNEDLONG; whichProperty: OSType; value: UnivPtr ): ComponentResult; external name '_MovieMediaGetCurrentTrackProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieMediaGetChildMovieDataReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function MovieMediaGetChildMovieDataReference( mh: MediaHandler; dataRefID: QTAtomID; dataRefIndex: SInt16; var dataRefType: OSType; var dataRef: Handle; var dataRefIDOut: QTAtomID; var dataRefIndexOut: SInt16 ): ComponentResult; external name '_MovieMediaGetChildMovieDataReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieMediaSetChildMovieDataReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function MovieMediaSetChildMovieDataReference( mh: MediaHandler; dataRefID: QTAtomID; dataRefType: OSType; dataRef: Handle ): ComponentResult; external name '_MovieMediaSetChildMovieDataReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MovieMediaLoadChildMovieFromDataReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function MovieMediaLoadChildMovieFromDataReference( mh: MediaHandler; dataRefID: QTAtomID ): ComponentResult; external name '_MovieMediaLoadChildMovieFromDataReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{************************
* 3D Media routines
*************************}
{
 *  Media3DGetNamedObjectList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function Media3DGetNamedObjectList( mh: MediaHandler; var objectList: QTAtomContainer ): ComponentResult; external name '_Media3DGetNamedObjectList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Media3DGetRendererList()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function Media3DGetRendererList( mh: MediaHandler; var rendererList: QTAtomContainer ): ComponentResult; external name '_Media3DGetRendererList';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Media3DGetCurrentGroup()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function Media3DGetCurrentGroup( mh: MediaHandler; group: UnivPtr ): ComponentResult; external name '_Media3DGetCurrentGroup';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Media3DTranslateNamedObjectTo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function Media3DTranslateNamedObjectTo( mh: MediaHandler; objectName: CStringPtr; x: Fixed; y: Fixed; z: Fixed ): ComponentResult; external name '_Media3DTranslateNamedObjectTo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Media3DScaleNamedObjectTo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function Media3DScaleNamedObjectTo( mh: MediaHandler; objectName: CStringPtr; xScale: Fixed; yScale: Fixed; zScale: Fixed ): ComponentResult; external name '_Media3DScaleNamedObjectTo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Media3DRotateNamedObjectTo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function Media3DRotateNamedObjectTo( mh: MediaHandler; objectName: CStringPtr; xDegrees: Fixed; yDegrees: Fixed; zDegrees: Fixed ): ComponentResult; external name '_Media3DRotateNamedObjectTo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Media3DSetCameraData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function Media3DSetCameraData( mh: MediaHandler; cameraData: UnivPtr ): ComponentResult; external name '_Media3DSetCameraData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Media3DGetCameraData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function Media3DGetCameraData( mh: MediaHandler; cameraData: UnivPtr ): ComponentResult; external name '_Media3DGetCameraData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Media3DSetCameraAngleAspect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function Media3DSetCameraAngleAspect( mh: MediaHandler; fov: QTFloatSingle; aspectRatioXToY: QTFloatSingle ): ComponentResult; external name '_Media3DSetCameraAngleAspect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Media3DGetCameraAngleAspect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function Media3DGetCameraAngleAspect( mh: MediaHandler; var fov: QTFloatSingle; var aspectRatioXToY: QTFloatSingle ): ComponentResult; external name '_Media3DGetCameraAngleAspect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Media3DSetCameraRange()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function Media3DSetCameraRange( mh: MediaHandler; tQ3CameraRange: UnivPtr ): ComponentResult; external name '_Media3DSetCameraRange';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Media3DGetCameraRange()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function Media3DGetCameraRange( mh: MediaHandler; tQ3CameraRange: UnivPtr ): ComponentResult; external name '_Media3DGetCameraRange';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Media3DGetViewObject()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function Media3DGetViewObject( mh: MediaHandler; tq3viewObject: UnivPtr ): ComponentResult; external name '_Media3DGetViewObject';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{***************************************
*                                       *
*   M O V I E   C O N T R O L L E R     *
*                                       *
***************************************}
const
	MovieControllerComponentType = FourCharCode('play');


const
	kMovieControllerQTVRFlag = 1 shl 0;
	kMovieControllerDontDisplayToUser = 1 shl 1;


type
	MovieController = ComponentInstance;
	MovieControllerPtr = ^MovieController;
const
	mcActionIdle = 1;    { no param}
	mcActionDraw = 2;    { param is WindowRef}
	mcActionActivate = 3;    { no param}
	mcActionDeactivate = 4;    { no param}
	mcActionMouseDown = 5;    { param is pointer to EventRecord}
	mcActionKey = 6;    { param is pointer to EventRecord}
	mcActionPlay = 8;    { param is Fixed, play rate}
	mcActionGoToTime = 12;   { param is TimeRecord}
	mcActionSetVolume = 14;   { param is a short}
	mcActionGetVolume = 15;   { param is pointer to a short}
	mcActionStep = 18;   { param is number of steps (short)}
	mcActionSetLooping = 21;   { param is Boolean}
	mcActionGetLooping = 22;   { param is pointer to a Boolean}
	mcActionSetLoopIsPalindrome = 23;   { param is Boolean}
	mcActionGetLoopIsPalindrome = 24;   { param is pointer to a Boolean}
	mcActionSetGrowBoxBounds = 25;   { param is a Rect}
	mcActionControllerSizeChanged = 26;   { no param}
	mcActionSetSelectionBegin = 29;   { param is TimeRecord}
	mcActionSetSelectionDuration = 30;   { param is TimeRecord, action only taken on set-duration}
	mcActionSetKeysEnabled = 32;   { param is Boolean}
	mcActionGetKeysEnabled = 33;   { param is pointer to Boolean}
	mcActionSetPlaySelection = 34;   { param is Boolean}
	mcActionGetPlaySelection = 35;   { param is pointer to Boolean}
	mcActionSetUseBadge = 36;   { param is Boolean}
	mcActionGetUseBadge = 37;   { param is pointer to Boolean}
	mcActionSetFlags = 38;   { param is long of flags}
	mcActionGetFlags = 39;   { param is pointer to a long of flags}
	mcActionSetPlayEveryFrame = 40;   { param is Boolean}
	mcActionGetPlayEveryFrame = 41;   { param is pointer to Boolean}
	mcActionGetPlayRate = 42;   { param is pointer to Fixed}
	mcActionShowBalloon = 43;   { param is a pointer to a boolean. set to false to stop balloon}
	mcActionBadgeClick = 44;   { param is pointer to Boolean. set to false to ignore click}
	mcActionMovieClick = 45;   { param is pointer to event record. change "what" to nullEvt to kill click}
	mcActionSuspend = 46;   { no param}
	mcActionResume = 47;   { no param}
	mcActionSetControllerKeysEnabled = 48; { param is Boolean}
	mcActionGetTimeSliderRect = 49;   { param is pointer to rect}
	mcActionMovieEdited = 50;   { no param}
	mcActionGetDragEnabled = 51;   { param is pointer to Boolean}
	mcActionSetDragEnabled = 52;   { param is Boolean}
	mcActionGetSelectionBegin = 53;   { param is TimeRecord}
	mcActionGetSelectionDuration = 54;   { param is TimeRecord}
	mcActionPrerollAndPlay = 55;   { param is Fixed, play rate}
	mcActionGetCursorSettingEnabled = 56; { param is pointer to Boolean}
	mcActionSetCursorSettingEnabled = 57; { param is Boolean}
	mcActionSetColorTable = 58;   { param is CTabHandle}
	mcActionLinkToURL = 59;   { param is Handle to URL}
	mcActionCustomButtonClick = 60;   { param is pointer to EventRecord}
	mcActionForceTimeTableUpdate = 61;   { no param}
	mcActionSetControllerTimeLimits = 62; { param is pointer to 2 time values min/max. do no send this message to controller. used internally only.}
	mcActionExecuteAllActionsForQTEvent = 63; { param is ResolvedQTEventSpecPtr}
	mcActionExecuteOneActionForQTEvent = 64; { param is ResolvedQTEventSpecPtr}
	mcActionAdjustCursor = 65;   { param is pointer to EventRecord (WindowRef is in message parameter)}
	mcActionUseTrackForTimeTable = 66;   { param is pointer to (long trackID; Boolean useIt). do not send this message to controller. }
	mcActionClickAndHoldPoint = 67;   { param is point (local coordinates). return true if point has click & hold action (e.g., VR object movie autorotate spot)}
	mcActionShowMessageString = 68;   { param is a StringPtr}
	mcActionShowStatusString = 69;   { param is a QTStatusStringPtr}
	mcActionGetExternalMovie = 70;   { param is a QTGetExternalMoviePtr}
	mcActionGetChapterTime = 71;   { param is a QTGetChapterTimePtr}
	mcActionPerformActionList = 72;   { param is a QTAtomSpecPtr}
	mcActionEvaluateExpression = 73;   { param is a QTEvaluateExpressionPtr}
	mcActionFetchParameterAs = 74;   { param is a QTFetchParameterAsPtr}
	mcActionGetCursorByID = 75;   { param is a QTGetCursorByIDPtr}
	mcActionGetNextURL = 76;   { param is a Handle to URL}
	mcActionMovieChanged = 77;
	mcActionDoScript = 78;   { param is QTDoScriptPtr}
	mcActionRestartAtTime = 79;   { param is QTResartAtTimePtr}
	mcActionGetIndChapter = 80;   { param is QTChapterInfoPtr}
	mcActionLinkToURLExtended = 81;   { param is QTAtomContainer as used by QTParseHREF}
	mcActionSetVolumeStep = 82;   { param is short containing amount to step volume via arrow keys - default = 64}
	mcActionAutoPlay = 83;   { param is Fixed, play rate}
	mcActionPauseToBuffer = 84;   { param is Fixed, play rate on restart}
	mcActionAppMessageReceived = 85;   { param is a long, application message}
	mcActionMovieFinished = 86;   { no param}
	mcActionEvaluateExpressionWithType = 89; { param is a QTEvaluateExpressionWithTypePtr}
	mcActionGetMovieName = 90;   { param is a p String Handle}
	mcActionGetMovieID = 91;   { param is pointer to long}
	mcActionGetMovieActive = 92;   { param is pointer to Boolean}
	mcActionGetKeyboardFocus = 93;   { param is QTKeyboardFocusPtr}
	mcActionSetKeyboardFocus = 94;   { param is QTKeyboardFocusPtr}
	mcActionAddActionNotification = 95;   { param is QTMCActionNotificationPtr}
	mcActionRemoveActionNotification = 96; { param is QTMCActionNotificationPtr}
	mcActionKeyUp = 97;   { param is pointer to EventRecord }
	mcActionGetConnectionStatus = 98;   { param is QTConnectionStatusPtr}
	mcActionChapterListChanged = 99;   { no param }
	mcActionMovieLoadStateChanged = 100;  { param is SInt32, new load state}
	mcActionEditStateChanged = 101;  { param is a Boolean, editing enabled?}
	mcActionCurrentChapterChanged = 102;   { param is a UInt32, new chapter index }

type
	mcAction = SInt16;
const
	mcFlagSuppressMovieFrame = 1 shl 0;
	mcFlagSuppressStepButtons = 1 shl 1;
	mcFlagSuppressSpeakerButton = 1 shl 2;
	mcFlagsUseWindowPalette = 1 shl 3;
	mcFlagsDontInvalidate = 1 shl 4;
	mcFlagsUseCustomButton = 1 shl 5;


const
	mcPositionDontInvalidate = 1 shl 5;

type
	mcFlags = UNSIGNEDLONG;
const
	kMCIEEnabledButtonPicture = 1;
	kMCIEDisabledButtonPicture = 2;
	kMCIEDepressedButtonPicture = 3;
	kMCIEEnabledSizeBoxPicture = 4;
	kMCIEDisabledSizeBoxPicture = 5;
	kMCIEEnabledUnavailableButtonPicture = 6;
	kMCIEDisabledUnavailableButtonPicture = 7;
	kMCIESoundSlider = 128;
	kMCIESoundThumb = 129;
	kMCIEColorTable = 256;
	kMCIEIsFlatAppearance = 257;
	kMCIEDoButtonIconsDropOnDepress = 258;

type
	MCInterfaceElement = UNSIGNEDLONG;
	MCActionFilterProcPtr = function( mc: MovieController; var action: SInt16; params: UnivPtr ): Boolean;
	MCActionFilterWithRefConProcPtr = function( mc: MovieController; action: SInt16; params: UnivPtr; refCon: SIGNEDLONG ): Boolean;
	MCActionNotificationProcPtr = function( mc: MovieController; action: SInt16; params: UnivPtr; inFlags: UInt32; var outFlags: UInt32; refCon: UnivPtr ): Boolean;
	MCActionFilterUPP = MCActionFilterProcPtr;
	MCActionFilterWithRefConUPP = MCActionFilterWithRefConProcPtr;
	MCActionNotificationUPP = MCActionNotificationProcPtr;
{
    menu related stuff
}
const
	mcInfoUndoAvailable = 1 shl 0;
	mcInfoCutAvailable = 1 shl 1;
	mcInfoCopyAvailable = 1 shl 2;
	mcInfoPasteAvailable = 1 shl 3;
	mcInfoClearAvailable = 1 shl 4;
	mcInfoHasSound = 1 shl 5;
	mcInfoIsPlaying = 1 shl 6;
	mcInfoIsLooping = 1 shl 7;
	mcInfoIsInPalindrome = 1 shl 8;
	mcInfoEditingEnabled = 1 shl 9;
	mcInfoMovieIsInteractive = 1 shl 10;

{ menu item codes}
const
	mcMenuUndo = 1;
	mcMenuCut = 3;
	mcMenuCopy = 4;
	mcMenuPaste = 5;
	mcMenuClear = 6;

{ messages to the application via mcActionAppMessageReceived}
const
	kQTAppMessageSoftwareChanged = 1;    { notification to app that installed QuickTime software has been updated}
	kQTAppMessageWindowCloseRequested = 3; { request for app to close window containing movie controller}
	kQTAppMessageExitFullScreenRequested = 4; { request for app to turn off full screen mode if active}
	kQTAppMessageDisplayChannels = 5;    { request for app to display the channel UI}
	kQTAppMessageEnterFullScreenRequested = 6; { request for app to turn on full screen mode}

{ structures used as mcActionFilterProc params}
type
	QTStatusStringRecordPtr = ^QTStatusStringRecord;
	QTStatusStringRecord = record
		stringTypeFlags: SIGNEDLONG;
		statusString: CStringPtr;
	end;
type
	QTStatusStringPtr = QTStatusStringRecordPtr;
	QTGetExternalMovieRecordPtr = ^QTGetExternalMovieRecord;
	QTGetExternalMovieRecord = record
		targetType: SIGNEDLONG;             { set to kTargetMovieName or kTargetMovieID}
		movieName: StringPtr;
		movieID: SIGNEDLONG;
		theMovie: PtrToMovie;
		theController: MovieControllerPtr;
	end;
type
	QTGetChapterTimeRecordPtr = ^QTGetChapterTimeRecord;
	QTGetExternalMoviePtr = QTGetExternalMovieRecordPtr;
	QTGetChapterTimeRecord = record
		chapterName: StringPtr;
		chapterTime: TimeRecord;
	end;
type
	QTGetChapterTimePtr = QTGetChapterTimeRecordPtr;
	QTChapterInfoRecordPtr = ^QTChapterInfoRecord;
	QTChapterInfoRecord = record
		index: SIGNEDLONG;                  { first chapter has index of 1}
		time: TimeValue;                   { -1 if no more chapters available}
		name: Str255;
	end;
type
	QTChapterInfoPtr = QTChapterInfoRecordPtr;
	QTEvaluateExpressionRecordPtr = ^QTEvaluateExpressionRecord;
	QTEvaluateExpressionRecord = record
		expressionSpec: QTAtomSpec;
		expressionResult: Float32Ptr;
	end;
type
	QTEvaluateExpressionPtr = QTEvaluateExpressionRecordPtr;
	QTEvaluateExpressionWithTypeRecordPtr = ^QTEvaluateExpressionWithTypeRecord;
	QTEvaluateExpressionWithTypeRecord = record
		recordSize: SIGNEDLONG;             { Size of structure (fill in at allocation) }
		expressionSpec: QTAtomSpec;
		expressionResult: Float32Ptr;
		fetchAsType: SIGNEDLONG;
		nonNumericResult: Handle;
                                              { Current size is 24 }
	end;
type
	QTEvaluateExpressionWithTypePtr = QTEvaluateExpressionWithTypeRecordPtr;
	QTFetchParameterAsRecordPtr = ^QTFetchParameterAsRecord;
	QTFetchParameterAsRecord = record
		paramListSpec: QTAtomSpec;
		paramIndex: SIGNEDLONG;
		paramType: SIGNEDLONG;
		allowedFlags: SIGNEDLONG;
		min: UnivPtr;
		max: UnivPtr;
		currentValue: UnivPtr;
		newValue: UnivPtr;
		isUnsignedValue: Boolean;
	end;
type
	QTFetchParameterAsPtr = QTFetchParameterAsRecordPtr;
	QTGetCursorByIDRecordPtr = ^QTGetCursorByIDRecord;
	QTGetCursorByIDRecord = record
		cursorID: SInt16;
		colorCursorData: Handle;
		reserved1: SIGNEDLONG;
	end;
type
	QTGetCursorByIDPtr = QTGetCursorByIDRecordPtr;
	QTDoScriptRecordPtr = ^QTDoScriptRecord;
	QTDoScriptRecord = record
		scriptTypeFlags: SIGNEDLONG;
		command: CStringPtr;
		arguments: CStringPtr;
	end;
type
	QTDoScriptPtr = QTDoScriptRecordPtr;
	QTRestartAtTimeRecordPtr = ^QTRestartAtTimeRecord;
	QTRestartAtTimeRecord = record
		startTime: TimeValue;              { time scale is the movie timescale}
		rate: Fixed;                   { if rate is zero, the movie's current rate is maintained}
	end;
type
	QTRestartAtTimePtr = QTRestartAtTimeRecordPtr;
{ values for paramType field of QTFetchParameterAsRecord}
const
	kFetchAsBooleanPtr = 1;
	kFetchAsShortPtr = 2;
	kFetchAsLongPtr = 3;
	kFetchAsMatrixRecordPtr = 4;
	kFetchAsModifierTrackGraphicsModeRecord = 5;
	kFetchAsHandle = 6;
	kFetchAsStr255 = 7;
	kFetchAsFloatPtr = 8;
	kFetchAsPointPtr = 9;
	kFetchAsNewAtomContainer = 10;
	kFetchAsQTEventRecordPtr = 11;
	kFetchAsFixedPtr = 12;
	kFetchAsSetControllerValuePtr = 13;
	kFetchAsRgnHandle = 14;   { flipped to native}
	kFetchAsComponentDescriptionPtr = 15;
	kFetchAsCString = 16;

const
	kQTCursorOpenHand = -19183;
	kQTCursorClosedHand = -19182;
	kQTCursorPointingHand = -19181;
	kQTCursorRightArrow = -19180;
	kQTCursorLeftArrow = -19179;
	kQTCursorDownArrow = -19178;
	kQTCursorUpArrow = -19177;
	kQTCursorIBeam = -19176;


{ keyboard focus items}

const
	kKeyboardAllowFocus = 1;
	kKeyboardHaveFocus = 2;
	kKeyboardValidate = 4;


const
	kRefConNavigateClick = FourCharCode('clik');


type
	QTKeyboardFocusRecordPtr = ^QTKeyboardFocusRecord;
	QTKeyboardFocusRecord = record
		recordSize: SIGNEDLONG;             { -> size of structure}
		navigation: SIGNEDLONG;             { -> same as in MediaNavigateTargetRefCon}
		focusRefCon: SIGNEDLONG;            { <-> refcon}
		focusFlags: SInt16;             { <-> flags from kKeyboard... enum }
	end;
type
	QTKeyboardFocusPtr = QTKeyboardFocusRecordPtr;
const
	kQTMCActionNotifyBefore = 1 shl 0;
	kQTMCActionNotifyAfter = 1 shl 1;
	kQTMCActionNotifyParamChanged = 1 shl 8;
	kQTMCActionNotifyCancelled = 1 shl 9;
	kQTMCActionNotifyUserFilterCancelled = 1 shl 10;
	kQTMCActionNotifySignature = FourCharCode('noti');

type
	QTMCActionNotificationRecordPtr = ^QTMCActionNotificationRecord;
	QTMCActionNotificationRecord = record
		returnSignature: OSType;        { Set to zero when passed to movieController, set to 'noti' if mcActionAddActionNotification is implemented}
		notifyAction: MCActionNotificationUPP;      { Function to be called at action time}
		refcon: UnivPtr;                 { Something to pass to the action function}
		flags: UInt32;                  { Option flags}
	end;
type
	QTMCActionNotificationPtr = QTMCActionNotificationRecordPtr;
	QTConnectionStatusRecordPtr = ^QTConnectionStatusRecord;
	QTConnectionStatusRecord = record
		flags: SInt16;
		error: SInt16;

		message: Handle;
	end;
type
	QTConnectionStatusPtr = QTConnectionStatusRecordPtr;

{ target management }
{
 *  MCSetMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCSetMovie( mc: MovieController; theMovie: Movie; movieWindow: WindowRef; where: Point ): ComponentResult; external name '_MCSetMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCGetIndMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCGetIndMovie( mc: MovieController; index: SInt16 ): Movie; external name '_MCGetIndMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCRemoveAllMovies()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCRemoveAllMovies( mc: MovieController ): ComponentResult; external name '_MCRemoveAllMovies';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCRemoveAMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCRemoveAMovie( mc: MovieController; m: Movie ): ComponentResult; external name '_MCRemoveAMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCRemoveMovie()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCRemoveMovie( mc: MovieController ): ComponentResult; external name '_MCRemoveMovie';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ event handling etc. }
{
 *  MCIsPlayerEvent()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCIsPlayerEvent( mc: MovieController; const (*var*) e: EventRecord ): ComponentResult; external name '_MCIsPlayerEvent';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ obsolete. use MCSetActionFilterWithRefCon instead. }
{
 *  MCSetActionFilter()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCSetActionFilter( mc: MovieController; blob: MCActionFilterUPP ): ComponentResult; external name '_MCSetActionFilter';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    proc is of the form:
        Boolean userPlayerFilter(MovieController mc, short *action, void *params) =
    proc returns TRUE if it handles the action, FALSE if not
    action is passed as a VAR so that it could be changed by filter
    this is consistent with the current dialog manager stuff
    params is any potential parameters that go with the action
        such as set playback rate to xxx.
}
{
 *  MCDoAction()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCDoAction( mc: MovieController; action: SInt16; params: UnivPtr ): ComponentResult; external name '_MCDoAction';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ state type things }
{
 *  MCSetControllerAttached()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCSetControllerAttached( mc: MovieController; attach: Boolean ): ComponentResult; external name '_MCSetControllerAttached';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCIsControllerAttached()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCIsControllerAttached( mc: MovieController ): ComponentResult; external name '_MCIsControllerAttached';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCSetControllerPort()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCSetControllerPort( mc: MovieController; gp: CGrafPtr ): ComponentResult; external name '_MCSetControllerPort';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCGetControllerPort()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCGetControllerPort( mc: MovieController ): CGrafPtr; external name '_MCGetControllerPort';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCSetVisible()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCSetVisible( mc: MovieController; visible: Boolean ): ComponentResult; external name '_MCSetVisible';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCGetVisible()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCGetVisible( mc: MovieController ): ComponentResult; external name '_MCGetVisible';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCGetControllerBoundsRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCGetControllerBoundsRect( mc: MovieController; var bounds: Rect ): ComponentResult; external name '_MCGetControllerBoundsRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCSetControllerBoundsRect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCSetControllerBoundsRect( mc: MovieController; const (*var*) bounds: Rect ): ComponentResult; external name '_MCSetControllerBoundsRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCGetControllerBoundsRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCGetControllerBoundsRgn( mc: MovieController ): RgnHandle; external name '_MCGetControllerBoundsRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCGetWindowRgn()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCGetWindowRgn( mc: MovieController; w: WindowRef ): RgnHandle; external name '_MCGetWindowRgn';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ other stuff }
{
 *  MCMovieChanged()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCMovieChanged( mc: MovieController; m: Movie ): ComponentResult; external name '_MCMovieChanged';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    called when the app has changed thing about the movie (like bounding rect) or rate. So that we
        can update our graphical (and internal) state accordingly.
}
{
 *  MCSetDuration()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCSetDuration( mc: MovieController; duration: TimeValue ): ComponentResult; external name '_MCSetDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    duration to use for time slider -- will be reset next time MCMovieChanged is called
        or MCSetMovie is called
}
{
 *  MCGetCurrentTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCGetCurrentTime( mc: MovieController; var scale: TimeScale ): TimeValue; external name '_MCGetCurrentTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    returns the time value and the time scale it is on. if there are no movies, the
        time scale is passed back as 0. scale is an optional parameter

}
{
 *  MCNewAttachedController()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCNewAttachedController( mc: MovieController; theMovie: Movie; w: WindowRef; where: Point ): ComponentResult; external name '_MCNewAttachedController';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    makes theMovie the only movie attached to the controller. makes the controller visible.
    the window and where parameters are passed a long to MCSetMovie and behave as
    described there
}
{
 *  MCDraw()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCDraw( mc: MovieController; w: WindowRef ): ComponentResult; external name '_MCDraw';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCActivate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCActivate( mc: MovieController; w: WindowRef; activate: Boolean ): ComponentResult; external name '_MCActivate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCIdle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCIdle( mc: MovieController ): ComponentResult; external name '_MCIdle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCKey()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCKey( mc: MovieController; key: SInt8; modifiers: SIGNEDLONG ): ComponentResult; external name '_MCKey';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCClick()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCClick( mc: MovieController; w: WindowRef; where: Point; when: SIGNEDLONG; modifiers: SIGNEDLONG ): ComponentResult; external name '_MCClick';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    calls for editing
}
{
 *  MCEnableEditing()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCEnableEditing( mc: MovieController; enabled: Boolean ): ComponentResult; external name '_MCEnableEditing';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCIsEditingEnabled()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCIsEditingEnabled( mc: MovieController ): SIGNEDLONG; external name '_MCIsEditingEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCCopy()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCCopy( mc: MovieController ): Movie; external name '_MCCopy';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCCut()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCCut( mc: MovieController ): Movie; external name '_MCCut';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCPaste()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCPaste( mc: MovieController; srcMovie: Movie ): ComponentResult; external name '_MCPaste';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCClear()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCClear( mc: MovieController ): ComponentResult; external name '_MCClear';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCUndo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCUndo( mc: MovieController ): ComponentResult; external name '_MCUndo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  somewhat special stuff
 }
{
 *  MCPositionController()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCPositionController( mc: MovieController; const (*var*) movieRect: Rect; const (*var*) controllerRect: Rect; someFlags: SIGNEDLONG ): ComponentResult; external name '_MCPositionController';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCGetControllerInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCGetControllerInfo( mc: MovieController; var someFlags: SIGNEDLONG ): ComponentResult; external name '_MCGetControllerInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCSetClip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCSetClip( mc: MovieController; theClip: RgnHandle; movieClip: RgnHandle ): ComponentResult; external name '_MCSetClip';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCGetClip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCGetClip( mc: MovieController; var theClip: RgnHandle; var movieClip: RgnHandle ): ComponentResult; external name '_MCGetClip';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCDrawBadge()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCDrawBadge( mc: MovieController; movieRgn: RgnHandle; var badgeRgn: RgnHandle ): ComponentResult; external name '_MCDrawBadge';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCSetUpEditMenu()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCSetUpEditMenu( mc: MovieController; modifiers: SIGNEDLONG; mh: MenuRef ): ComponentResult; external name '_MCSetUpEditMenu';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCGetMenuString()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCGetMenuString( mc: MovieController; modifiers: SIGNEDLONG; item: SInt16; var aString: Str255 ): ComponentResult; external name '_MCGetMenuString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCSetActionFilterWithRefCon()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCSetActionFilterWithRefCon( mc: MovieController; blob: MCActionFilterWithRefConUPP; refCon: SIGNEDLONG ): ComponentResult; external name '_MCSetActionFilterWithRefCon';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCPtInController()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCPtInController( mc: MovieController; thePt: Point; var inController: Boolean ): ComponentResult; external name '_MCPtInController';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCInvalidate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCInvalidate( mc: MovieController; w: WindowRef; invalidRgn: RgnHandle ): ComponentResult; external name '_MCInvalidate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCAdjustCursor()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCAdjustCursor( mc: MovieController; w: WindowRef; where: Point; modifiers: SIGNEDLONG ): ComponentResult; external name '_MCAdjustCursor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCGetInterfaceElement()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MCGetInterfaceElement( mc: MovieController; whichElement: MCInterfaceElement; element: UnivPtr ): ComponentResult; external name '_MCGetInterfaceElement';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCGetDoActionsProc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function MCGetDoActionsProc( mc: MovieController; var doMCActionProc: DoMCActionUPP; var doMCActionRefCon: SIGNEDLONG ): ComponentResult; external name '_MCGetDoActionsProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCAddMovieSegment()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function MCAddMovieSegment( mc: MovieController; srcMovie: Movie; scaled: Boolean ): ComponentResult; external name '_MCAddMovieSegment';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCTrimMovieSegment()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   in QuickTimeLib 5.0 and later
 *    Windows:          in qtmlClient.lib 5.0 and later
 }
function MCTrimMovieSegment( mc: MovieController ): ComponentResult; external name '_MCTrimMovieSegment';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  MCSetIdleManager()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function MCSetIdleManager( mc: MovieController; im: IdleManager ): ComponentResult; external name '_MCSetIdleManager';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{ Called (but not implemented) by controllers that derive from the standard movie controller.
   All controllers except standard movie controller must delegate this call. }
const
	kControllerUnderstandsIdleManagers = 1 shl 0;

{
 *  MCSetControllerCapabilities()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.6 and later
 *    Non-Carbon CFM:   in QuickTimeLib 6.0 and later
 *    Windows:          in qtmlClient.lib 6.0 and later
 }
function MCSetControllerCapabilities( mc: MovieController; flags: SIGNEDLONG; flagsMask: SIGNEDLONG ): ComponentResult; external name '_MCSetControllerCapabilities';
(* AVAILABLE_MAC_OS_X_VERSION_10_2_AND_LATER *)


{***************************************
*                                       *
*       T  I  M  E  B  A  S  E          *
*                                       *
***************************************}
{
 *  NewTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewTimeBase: TimeBase; external name '_NewTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure DisposeTimeBase( tb: TimeBase ); external name '_DisposeTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTimeBaseTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTimeBaseTime( tb: TimeBase; s: TimeScale; var tr: TimeRecord ): TimeValue; external name '_GetTimeBaseTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTimeBaseTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTimeBaseTime( tb: TimeBase; const (*var*) tr: TimeRecord ); external name '_SetTimeBaseTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTimeBaseValue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTimeBaseValue( tb: TimeBase; t: TimeValue; s: TimeScale ); external name '_SetTimeBaseValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTimeBaseRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTimeBaseRate( tb: TimeBase ): Fixed; external name '_GetTimeBaseRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTimeBaseRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTimeBaseRate( tb: TimeBase; r: Fixed ); external name '_SetTimeBaseRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTimeBaseStartTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTimeBaseStartTime( tb: TimeBase; s: TimeScale; var tr: TimeRecord ): TimeValue; external name '_GetTimeBaseStartTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTimeBaseStartTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTimeBaseStartTime( tb: TimeBase; const (*var*) tr: TimeRecord ); external name '_SetTimeBaseStartTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTimeBaseStopTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTimeBaseStopTime( tb: TimeBase; s: TimeScale; var tr: TimeRecord ): TimeValue; external name '_GetTimeBaseStopTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTimeBaseStopTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTimeBaseStopTime( tb: TimeBase; const (*var*) tr: TimeRecord ); external name '_SetTimeBaseStopTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTimeBaseFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTimeBaseFlags( tb: TimeBase ): SIGNEDLONG; external name '_GetTimeBaseFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTimeBaseFlags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTimeBaseFlags( tb: TimeBase; timeBaseFlags: SIGNEDLONG ); external name '_SetTimeBaseFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTimeBaseMasterTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTimeBaseMasterTimeBase( slave: TimeBase; master: TimeBase; const (*var*) slaveZero: TimeRecord ); external name '_SetTimeBaseMasterTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTimeBaseMasterTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTimeBaseMasterTimeBase( tb: TimeBase ): TimeBase; external name '_GetTimeBaseMasterTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTimeBaseMasterClock()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTimeBaseMasterClock( slave: TimeBase; clockMeister: Component; const (*var*) slaveZero: TimeRecord ); external name '_SetTimeBaseMasterClock';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTimeBaseMasterClock()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTimeBaseMasterClock( tb: TimeBase ): ComponentInstance; external name '_GetTimeBaseMasterClock';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ConvertTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure ConvertTime( var theTime: TimeRecord; newBase: TimeBase ); external name '_ConvertTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ConvertTimeScale()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure ConvertTimeScale( var theTime: TimeRecord; newScale: TimeScale ); external name '_ConvertTimeScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AddTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure AddTime( var dst: TimeRecord; const (*var*) src: TimeRecord ); external name '_AddTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SubtractTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SubtractTime( var dst: TimeRecord; const (*var*) src: TimeRecord ); external name '_SubtractTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTimeBaseStatus()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTimeBaseStatus( tb: TimeBase; var unpinnedTime: TimeRecord ): SIGNEDLONG; external name '_GetTimeBaseStatus';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetTimeBaseZero()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure SetTimeBaseZero( tb: TimeBase; var zero: TimeRecord ); external name '_SetTimeBaseZero';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTimeBaseEffectiveRate()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetTimeBaseEffectiveRate( tb: TimeBase ): Fixed; external name '_GetTimeBaseEffectiveRate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetTimeBaseRateChangeStatus()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function GetTimeBaseRateChangeStatus( tb: TimeBase; scale: TimeScale; var ratedChangedTo: Fixed; var flags: TimeBaseStatus; var rateChangeTimeBaseTime: TimeRecord; var rateChangeClockTime: TimeRecord; var currentClockTime: TimeRecord ): OSErr; external name '_GetTimeBaseRateChangeStatus';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  ConvertTimeToClockTime()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
procedure ConvertTimeToClockTime( var time: TimeRecord ); external name '_ConvertTimeToClockTime';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  GetTimeBaseMasterOffsetTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function GetTimeBaseMasterOffsetTimeBase( tb: TimeBase ): TimeBase; external name '_GetTimeBaseMasterOffsetTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  SetTimeBaseOffsetTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib 6.5 and later
 }
function SetTimeBaseOffsetTimeBase( tb: TimeBase; offsettb: TimeBase; const (*var*) offsetZero: TimeRecord ): OSErr; external name '_SetTimeBaseOffsetTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  AttachTimeBaseToCurrentThread()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function AttachTimeBaseToCurrentThread( tb: TimeBase ): OSErr; external name '_AttachTimeBaseToCurrentThread';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  DetachTimeBaseFromCurrentThread()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function DetachTimeBaseFromCurrentThread( tb: TimeBase ): OSErr; external name '_DetachTimeBaseFromCurrentThread';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  GetTimeBaseThreadAttachState()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function GetTimeBaseThreadAttachState( inTimeBase: TimeBase; var outAttachedToCurrentThread: Boolean; var outAttachedToAnyThread: Boolean ): OSErr; external name '_GetTimeBaseThreadAttachState';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{***************************************
*                                       *
*       C  A  L  L  B  A  C  K          *
*                                       *
***************************************}
{
 *  NewCallBack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function NewCallBack( tb: TimeBase; cbType: SInt16 ): QTCallBack; external name '_NewCallBack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeCallBack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure DisposeCallBack( cb: QTCallBack ); external name '_DisposeCallBack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetCallBackType()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetCallBackType( cb: QTCallBack ): SInt16; external name '_GetCallBackType';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetCallBackTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetCallBackTimeBase( cb: QTCallBack ): TimeBase; external name '_GetCallBackTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CallMeWhen()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function CallMeWhen( cb: QTCallBack; callBackProc: QTCallBackUPP; refCon: SIGNEDLONG; param1: SIGNEDLONG; param2: SIGNEDLONG; param3: SIGNEDLONG ): OSErr; external name '_CallMeWhen';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CancelCallBack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure CancelCallBack( cb: QTCallBack ); external name '_CancelCallBack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{***************************************
*                                       *
*       C L O C K   C A L L B A C K     *
*             S U P P O R T             *
*                                       *
***************************************}
{
 *  AddCallBackToTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function AddCallBackToTimeBase( cb: QTCallBack ): OSErr; external name '_AddCallBackToTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  RemoveCallBackFromTimeBase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function RemoveCallBackFromTimeBase( cb: QTCallBack ): OSErr; external name '_RemoveCallBackFromTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetFirstCallBack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetFirstCallBack( tb: TimeBase ): QTCallBack; external name '_GetFirstCallBack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetNextCallBack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function GetNextCallBack( cb: QTCallBack ): QTCallBack; external name '_GetNextCallBack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ExecuteCallBack()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 2.5 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
procedure ExecuteCallBack( cb: QTCallBack ); external name '_ExecuteCallBack';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{***************************************
*                                       *
*   M O V I E  P R O P E R T I E S      *
*                                       *
***************************************}

type
	QTMoviePropertyListenerProcPtr = procedure( inMovie: Movie; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inUserData: UnivPtr );
	QTMoviePropertyListenerUPP = QTMoviePropertyListenerProcPtr;
{
 *  QTGetMoviePropertyInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTGetMoviePropertyInfo( inMovie: Movie; inPropClass: QTPropertyClass; inPropID: QTPropertyID; var outPropType: QTPropertyValueType; var outPropValueSize: ByteCount; var outPropertyFlags: UInt32 ): OSErr; external name '_QTGetMoviePropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTGetMovieProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTGetMovieProperty( inMovie: Movie; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; outPropValueAddress: QTPropertyValuePtr; var outPropValueSizeUsed: ByteCount ): OSErr; external name '_QTGetMovieProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTSetMovieProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTSetMovieProperty( inMovie: Movie; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstQTPropertyValuePtr ): OSErr; external name '_QTSetMovieProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTAddMoviePropertyListener()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTAddMoviePropertyListener( inMovie: Movie; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inListenerProc: QTMoviePropertyListenerUPP; inUserData: UnivPtr ): OSErr; external name '_QTAddMoviePropertyListener';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{
 *  QTRemoveMoviePropertyListener()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTRemoveMoviePropertyListener( inMovie: Movie; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inListenerProc: QTMoviePropertyListenerUPP; inUserData: UnivPtr ): OSErr; external name '_QTRemoveMoviePropertyListener';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)


{***************************************
*                                       *
*   T R A C K  P R O P E R T I E S      *
*                                       *
***************************************}

type
	QTTrackPropertyListenerProcPtr = procedure( inTrack: Track; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inUserData: UnivPtr );
	QTTrackPropertyListenerUPP = QTTrackPropertyListenerProcPtr;
{
 *  QTGetTrackPropertyInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTGetTrackPropertyInfo( inTrack: Track; inPropClass: QTPropertyClass; inPropID: QTPropertyID; var outPropType: QTPropertyValueType; var outPropValueSize: ByteCount; var outPropertyFlags: UInt32 ): OSErr; external name '_QTGetTrackPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTGetTrackProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTGetTrackProperty( inTrack: Track; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; outPropValueAddress: QTPropertyValuePtr; var outPropValueSizeUsed: ByteCount ): OSErr; external name '_QTGetTrackProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSetTrackProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTSetTrackProperty( inTrack: Track; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstQTPropertyValuePtr ): OSErr; external name '_QTSetTrackProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTAddTrackPropertyListener()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTAddTrackPropertyListener( inTrack: Track; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inListenerProc: QTTrackPropertyListenerUPP; inUserData: UnivPtr ): OSErr; external name '_QTAddTrackPropertyListener';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTRemoveTrackPropertyListener()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTRemoveTrackPropertyListener( inTrack: Track; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inListenerProc: QTTrackPropertyListenerUPP; inUserData: UnivPtr ): OSErr; external name '_QTRemoveTrackPropertyListener';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{***************************************
*                                       *
*     Q T S A M P L E T A B L E         *
*                                       *
***************************************}

type
	QTSampleDescriptionID = SIGNEDLONG;
{
 *  QTSampleTableCreateMutable()
 *  
 *  Summary:
 *    Creates a new empty sample table.
 *  
 *  Discussion:
 *    The newly created sample table will contain no sample references.
 *    When sample references are added, their durations and display
 *    offsets will be interpreted according to the sample table's
 *    current timescale.
 *  
 *  Parameters:
 *    
 *    allocator:
 *      The allocator to use for the new sample table.
 *    
 *    timescale:
 *      The timescale to use for durations and display offsets.
 *    
 *    hints:
 *      Reserved.  Pass NULL.
 *    
 *    newSampleTable:
 *      Points to a variable to receive the new sample table.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableCreateMutable( allocator: CFAllocatorRef; timescale_: TimeScale; hints: UnivPtr; var newSampleTable: QTMutableSampleTableRef ): OSStatus; external name '_QTSampleTableCreateMutable';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableRetain()
 *  
 *  Summary:
 *    Increments the retain count of a sample table.
 *  
 *  Discussion:
 *    The same sample table is returned for convenience. If sampleTable
 *    is NULL, nothing happens.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableRetain( sampleTable: QTSampleTableRef ): QTSampleTableRef; external name '_QTSampleTableRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableRelease()
 *  
 *  Summary:
 *    Decrements the retain count of a sample table.
 *  
 *  Discussion:
 *    If the retain count decreases to zero, the sample table is
 *    disposed. If sampleTable is NULL, nothing happens.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
procedure QTSampleTableRelease( sampleTable: QTSampleTableRef ); external name '_QTSampleTableRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableCreateMutableCopy()
 *  
 *  Summary:
 *    Copies a sample table.
 *  
 *  Discussion:
 *    All the sample references and sample descriptions in the sample
 *    table are copied.
 *  
 *  Parameters:
 *    
 *    allocator:
 *      The allocator to use for the new sample table.
 *    
 *    sampleTable:
 *      The sample table to copy.
 *    
 *    hints:
 *      Reserved, set to NULL.
 *    
 *    newSampleTable:
 *      Points to a variable to receive the new sample table.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableCreateMutableCopy( allocator: CFAllocatorRef; sampleTable: QTSampleTableRef; hints: UnivPtr; var newSampleTable: QTMutableSampleTableRef ): OSStatus; external name '_QTSampleTableCreateMutableCopy';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableGetTypeID()
 *  
 *  Summary:
 *    Returns the CFTypeID for QTSampleTableRef.
 *  
 *  Discussion:
 *    You could use this to test whether a CFTypeRef that extracted
 *    from a CF container such as a CFArray was a QTSampleTableRef.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableGetTypeID: CFTypeID; external name '_QTSampleTableGetTypeID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableSetTimeScale()
 *  
 *  Summary:
 *    Changes the timescale of a sample table.
 *  
 *  Discussion:
 *    The durations and display offsets of all the sample references in
 *    the sample table are scaled from the old timescale to the new
 *    timescale. No durations will be scaled to a value less than 1.
 *    Display offsets will be adjusted to avoid display time collisions.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    newTimeScale:
 *      The new timescale.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableSetTimeScale( sampleTable: QTMutableSampleTableRef; newTimeScale: TimeScale ): OSStatus; external name '_QTSampleTableSetTimeScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableGetTimeScale()
 *  
 *  Summary:
 *    Returns the timescale of a sample table.
 *  
 *  Discussion:
 *    Returns 0 if sampleTable is NULL.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableGetTimeScale( sampleTable: QTSampleTableRef ): TimeScale; external name '_QTSampleTableGetTimeScale';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  Summary:
 *    Attribute flags for QTSampleTableGetNextAttributeChange
 }
const
{
   * Set this flag to find first num such that samples num-1 and num
   * are not adjacent, ie, dataOffset of num-1 + dataSize of num-1 !=
   * dataOffset of num
   }
	kQTSampleTableAttribute_DiscontiguousData = 1 shl 0;

  {
   * Set this flag to find the first sample with data size per sample
   * different from that of the starting sample.
   }
	kQTSampleTableAttribute_DataSizePerSampleChange = 1 shl 1;

  {
   * Set this flag to find the first sample with decode duration
   * different from that of the starting sample.
   }
	kQTSampleTableAttribute_DecodeDurationChange = 1 shl 2;

  {
   * Set this flag to find the first sample with display offset
   * different from that of the starting sample.
   }
	kQTSampleTableAttribute_DisplayOffsetChange = 1 shl 3;

  {
   * Set this flag to find the first sample with sample description ID
   * different from that of the starting sample.
   }
	kQTSampleTableAttribute_SampleDescriptionIDChange = 1 shl 4;

  {
   * Set this flag to find the first sample with any media sample flags
   * different from those of the starting sample.
   }
	kQTSampleTableAttribute_SampleFlagsChange = 1 shl 5;

  {
   * If no flags are set, find the first sample with any attribute
   * different from the starting sample.
   }
	kQTSampleTableAnyAttributeChange = 0;

type
	QTSampleTableAttribute = UInt32;
{
 *  QTSampleTableGetNextAttributeChange()
 *  
 *  Summary:
 *    Finds the next sample number at which one or more of given sample
 *    attributes change.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    startSampleNum:
 *      A sample number.
 *    
 *    attributeMask:
 *      A collection of flags that indicates which kinds of attribute
 *      changes to search for.
 *    
 *    sampleNumOut:
 *      Points to a variable to receive the next sample number after
 *      startSampleNum at which any of the requested attributes
 *      changes. If no attribute changes are found, this variable is
 *      set to zero.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableGetNextAttributeChange( sampleTable: QTSampleTableRef; startSampleNum: SInt64; attributeMask: QTSampleTableAttribute; var sampleNumOut: SInt64 ): OSStatus; external name '_QTSampleTableGetNextAttributeChange';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableAddSampleDescription()
 *  
 *  Summary:
 *    Adds a sample description to a sample table, returning a sample
 *    description ID that can be used to refer to it.
 *  
 *  Discussion:
 *    You can use the returned sample description ID when adding
 *    samples to the sample table. 
 *    Note: Sample description IDs are local to each sample table. The
 *    same sample description handle may have different IDs when
 *    referenced in different sample tables.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    sampleDescriptionH:
 *      The sample description handle. The QTSampleTable will make its
 *      own copy of this handle.
 *    
 *    mediaSampleDescriptionIndex:
 *      Indicates the sample description index of this sample
 *      description in a media. Pass zero for sample descriptions you
 *      add to sample tables, to indicate that this was not retrieved
 *      from a media.
 *    
 *    sampleDescriptionIDOut:
 *      Points to a variable to receive a sample description ID.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableAddSampleDescription( sampleTable: QTMutableSampleTableRef; sampleDescriptionH: SampleDescriptionHandle; mediaSampleDescriptionIndex: SIGNEDLONG; var sampleDescriptionIDOut: QTSampleDescriptionID ): OSStatus; external name '_QTSampleTableAddSampleDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableCopySampleDescription()
 *  
 *  Summary:
 *    Retrieves a sample description from a sample table.
 *  
 *  Discussion:
 *    The caller is responsible for disposing the returned sampled
 *    description handle with DisposeHandle.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    sampleDescriptionID:
 *      The sample description ID.
 *    
 *    mediaSampleDescriptionIndexOut:
 *      Points to a variable to receive a media sample description
 *      index. If the sample description came from a media, this is the
 *      index that could be passed to GetMediaSampleDescription to
 *      retrieve the same sample description handle. The index will be
 *      zero if the sample description did not come directly from a
 *      media. Pass NULL if you do not want to receive this information.
 *    
 *    sampleDescriptionHOut:
 *      Points to a variable to receive a newly allocated sample
 *      description handle. Pass NULL if you do not want one.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableCopySampleDescription( sampleTable: QTSampleTableRef; sampleDescriptionID: QTSampleDescriptionID; var mediaSampleDescriptionIndexOut: SIGNEDLONG; var sampleDescriptionHOut: SampleDescriptionHandle ): OSStatus; external name '_QTSampleTableCopySampleDescription';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableAddSampleReferences()
 *  
 *  Summary:
 *    Adds sample references to a sample table.
 *  
 *  Discussion:
 *    Note that you must pass the data size per sample, not the total
 *    size of all the samples as with some other APIs.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    dataOffset:
 *      Specifies the offset at which the first sample begins.
 *    
 *    dataSizePerSample:
 *      Specifies the number of bytes of data per sample.
 *    
 *    decodeDurationPerSample:
 *      Specifies the decode duration of each sample.
 *    
 *    displayOffset:
 *      Specifies the offset from decode time to display time of each
 *      sample. If the decode times and display times will be the same,
 *      pass 0.
 *    
 *    numberOfSamples:
 *      Specifies the number of samples.  Must be greater than zero.
 *    
 *    sampleFlags:
 *      Specifies the media sample flags for all samples.
 *    
 *    sampleDescriptionID:
 *      Specifies the ID of a sample description that has been added to
 *      the sample table with QTSampleTableAddSampleDescription.
 *    
 *    newSampleNumOut:
 *      Points to a variable to receive the sample number of the first
 *      sample that was added.  Pass NULL if you don't want this
 *      information.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableAddSampleReferences( sampleTable: QTMutableSampleTableRef; dataOffset: SInt64; dataSizePerSample: ByteCount; decodeDurationPerSample: TimeValue64; displayOffset: TimeValue64; numberOfSamples: SInt64; sampleFlags: MediaSampleFlags; sampleDescriptionID: QTSampleDescriptionID; var newSampleNumOut: SInt64 ): OSStatus; external name '_QTSampleTableAddSampleReferences';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableGetNumberOfSamples()
 *  
 *  Summary:
 *    Returns the number of samples in a sample table.
 *  
 *  Discussion:
 *    Returns 0 if sampleTable is NULL.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableGetNumberOfSamples( sampleTable: QTSampleTableRef ): SInt64; external name '_QTSampleTableGetNumberOfSamples';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableReplaceRange()
 *  
 *  Summary:
 *    Replaces a range of samples in a sample table with a range of
 *    samples from another sample table. Can also be used to delete a
 *    range of samples, or to insert samples without removing any.
 *  
 *  Discussion:
 *    This function removes destSampleCount samples from
 *    destSampleTable starting with destStartingSampleNum, and then
 *    inserts sourceSampleCount samples from sourceSampleTable starting
 *    with sourceStartingSampleNum where the removed samples were.
 *    Sample descriptions will be copied if necessary and new sample
 *    description IDs defined.
 *  
 *  Parameters:
 *    
 *    destSampleTable:
 *      The sample table to be modified.
 *    
 *    destStartingSampleNum:
 *      The first sample number in destSampleTable to be replaced or
 *      deleted, or the sample number at which samples should be
 *      inserted.
 *    
 *    destSampleCount:
 *      The number of samples to be removed from destSampleTable. Pass
 *      0 to insert without removing samples.
 *    
 *    sourceSampleTable:
 *      The sample table from which samples should be copied, or NULL
 *      to delete samples.
 *    
 *    sourceStartingSampleNum:
 *      The first sample number to be copied. Ignored when deleting
 *      samples.
 *    
 *    sourceSampleCount:
 *      The number of samples which should be copied. Pass 0 to delete
 *      samples.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableReplaceRange( destSampleTable: QTMutableSampleTableRef; destStartingSampleNum: SInt64; destSampleCount: SInt64; sourceSampleTable: QTSampleTableRef; sourceStartingSampleNum: SInt64; sourceSampleCount: SInt64 ): OSStatus; external name '_QTSampleTableReplaceRange';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableGetDataOffset()
 *  
 *  Summary:
 *    Returns the data offset of a sample.
 *  
 *  Discussion:
 *    Returns 0 if the sample table is NULL, or if the sample number is
 *    out of range.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    sampleNum:
 *      The sample number.  The first sample's number is 1.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableGetDataOffset( sampleTable: QTSampleTableRef; sampleNum: SInt64 ): SInt64; external name '_QTSampleTableGetDataOffset';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableGetDataSizePerSample()
 *  
 *  Summary:
 *    Returns the data size of a sample.
 *  
 *  Discussion:
 *    Returns 0 if the sample table is NULL, or if the sample number is
 *    out of range.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    sampleNum:
 *      The sample number.  The first sample's number is 1.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableGetDataSizePerSample( sampleTable: QTSampleTableRef; sampleNum: SInt64 ): ByteCount; external name '_QTSampleTableGetDataSizePerSample';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableGetDecodeDuration()
 *  
 *  Summary:
 *    Returns the decode duration of a sample.
 *  
 *  Discussion:
 *    Returns 0 if the sample table is NULL, or if the sample number is
 *    out of range.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    sampleNum:
 *      The sample number.  The first sample's number is 1.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableGetDecodeDuration( sampleTable: QTSampleTableRef; sampleNum: SInt64 ): TimeValue64; external name '_QTSampleTableGetDecodeDuration';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableGetDisplayOffset()
 *  
 *  Summary:
 *    Returns the offset from decode time to display time of a sample.
 *  
 *  Discussion:
 *    Returns 0 if the sample table is NULL, or if the sample number is
 *    out of range.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    sampleNum:
 *      The sample number.  The first sample's number is 1.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableGetDisplayOffset( sampleTable: QTSampleTableRef; sampleNum: SInt64 ): TimeValue64; external name '_QTSampleTableGetDisplayOffset';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableGetSampleDescriptionID()
 *  
 *  Summary:
 *    Returns the sample description ID of a sample.
 *  
 *  Discussion:
 *    Returns 0 if the sample table is NULL, or if the sample number is
 *    out of range.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    sampleNum:
 *      The sample number.  The first sample's number is 1.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableGetSampleDescriptionID( sampleTable: QTSampleTableRef; sampleNum: SInt64 ): QTSampleDescriptionID; external name '_QTSampleTableGetSampleDescriptionID';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableGetSampleFlags()
 *  
 *  Summary:
 *    Returns the media sample flags of a sample.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    sampleNum:
 *      The sample number.  The first sample's number is 1.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableGetSampleFlags( sampleTable: QTSampleTableRef; sampleNum: SInt64 ): MediaSampleFlags; external name '_QTSampleTableGetSampleFlags';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  Summary:
 *    Properties of sample tables
 }
const
{
   * Property class for sample tables.
   }
	kQTPropertyClass_SampleTable = FourCharCode('qtst');

  {
   * The total decode duration of all samples in the sample table. 
   * Read-only.
   }
	kQTSampleTablePropertyID_TotalDecodeDuration = FourCharCode('tded'); { TimeValue64, Read }

  {
   * The least display offset in the table. (-50 is a lesser offset
   * than 20.)  Read-only.
   }
	kQTSampleTablePropertyID_MinDisplayOffset = FourCharCode('<ddd'); { TimeValue64, Read }

  {
   * The greatest display offset in the table. (20 is a greater offset
   * than -50.)  Read-only.
   }
	kQTSampleTablePropertyID_MaxDisplayOffset = FourCharCode('>ddd'); { TimeValue64, Read }

  {
   * The least display time of all samples in the table, relative to
   * the decode time of the first sample in the table.  Read-only.
   }
	kQTSampleTablePropertyID_MinRelativeDisplayTime = FourCharCode('<dis'); { TimeValue64, Read }

  {
   * The greatest display time of all samples in the table, relative to
   * the decode time of the first sample in the table.  Read-only.
   }
	kQTSampleTablePropertyID_MaxRelativeDisplayTime = FourCharCode('>dis'); { TimeValue64, Read }


{
 *  QTSampleTableGetPropertyInfo()
 *  
 *  Summary:
 *    Returns information about the properties of a sample table.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    inPropClass:
 *      A property class.
 *    
 *    inPropID:
 *      A property ID.
 *    
 *    outPropType:
 *      A pointer to memory allocated to hold the property type on
 *      return. Pass NULL if you do not want this information.
 *    
 *    outPropValueSize:
 *      A pointer to memory allocated to hold the size of the property
 *      value on return. Pass NULL if you do not want this information.
 *    
 *    outPropertyFlags:
 *      A pointer to memory allocated to hold property flags on return.
 *      Pass NULL if you do not want this information.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableGetPropertyInfo( sampleTable: QTSampleTableRef; inPropClass: QTPropertyClass; inPropID: QTPropertyID; outPropType: QTPropertyValueTypePtr { can be NULL }; outPropValueSize: ByteCountPtr { can be NULL }; outPropertyFlags: UInt32Ptr { can be NULL } ): OSStatus; external name '_QTSampleTableGetPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableGetProperty()
 *  
 *  Summary:
 *    Returns the value of a specific sample table property.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    inPropClass:
 *      A property class.
 *    
 *    inPropID:
 *      A property ID.
 *    
 *    inPropValueSize:
 *      The size of the buffer allocated to hold the property value.
 *    
 *    outPropValueAddress:
 *      A pointer to the buffer allocated to hold the property value.
 *    
 *    outPropValueSizeUsed:
 *      On return, the actual size of the value written to the buffer.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableGetProperty( sampleTable: QTSampleTableRef; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; outPropValueAddress: QTPropertyValuePtr; outPropValueSizeUsed: ByteCountPtr { can be NULL } ): OSStatus; external name '_QTSampleTableGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTSampleTableSetProperty()
 *  
 *  Summary:
 *    Sets the value of a specific sample table property.
 *  
 *  Parameters:
 *    
 *    sampleTable:
 *      The sample table.
 *    
 *    inPropClass:
 *      A property class.
 *    
 *    inPropID:
 *      A property ID.
 *    
 *    inPropValueSize:
 *      The size of the property value.
 *    
 *    inPropValueAddress:
 *      A pointer to the property value.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTSampleTableSetProperty( sampleTable: QTSampleTableRef; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstQTPropertyValuePtr ): OSStatus; external name '_QTSampleTableSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{***************************************************************************
*                                                                           *
*           M E T A  D A T A                                                *
*                                                                           *
* QUICKTIME METADATA API OVERVIEW                                           *
*                                                                           *
* A QTMetaDataRef represents a metadata repository consisting of one or     *
* more native metadata containers. The QuickTime MetaData API supports      *
* unified access to and management of these containers.                     *
*                                                                           *
* Each container may be addressed by its storage format                     *
* (kQTMetaDataStorageFormat). Initially, there is support for classic       *
* QuickTime UserData, iTunes metadata, and a richer QuickTime metadata      *
* container format. A QTMetaDataRef may have one or all of these. No        *
* direct access to the native storage containers is provided.               *
*                                                                           *
* Each container consists of some number of metadata items. Metadata items  *
* correspond to individually labeled values with characteristics such as    *
* keys, data types, locale information, etc. What are called items here     *
* are sometimes referred to as attributes or properties in other metadata   *
* systems. Here, the focus is on the management of the pieces of metadata   *
* instead of the associations with objects. This parallels existing         *
* management of the classic QuickTime UserData construct.                   *
*                                                                           *
* QTMetaDataRefs may be associated with the Movie, Track and Media levels.  *
* This parallels UserData placement today but provides access to other      *
* kinds of metadata storage at those levels.                                *
*                                                                           *
* A metadata item is assigned a runtime identifier (QTMetaDataItem) that    *
* along with the QTMetaDataRef identifies the particular item (and value)   *
* across all native containers managed by the QTMetaDataRef.                *
*                                                                           *
* Each item is addressed by a key (or label). The key is not necessarily    *
* unique within its container as it is possible to have multiple items      *
* with the same key (e.g., multiple author items). Operations exist to      *
* enumerate all items or only items with a particular key.                  *
*                                                                           *
* Because a QTMetaDataRef may provide access to different native metadata   *
* containers with differing key structures (a four-char-code for one, a     *
* string for another, etc.), the key structure is also specified. A         *
* QTMetaDataKeyFormat indicates the key structure in APIs accepting keys.   *
* This is also done because some container formats allow multiple key       *
* structures or multiple versions of key structures.                        *
*                                                                           *
* To allow unified access across disparate containers, a wildcard storage   *
* format can be specified. This will direct operations like searches        *
* across container formats. A special key format called                     *
* kQTMetaDataKeyFormatCommon indicates one of a set of common keys that     *
* can be handled by native containers (e.g., copyright).                    *
*                                                                           *
* So, both of these modes of operation are possible: - access metadata      *
* regardless of native container format through the use a common key -      *
* access metadata natively using a native key format                        *
*                                                                           *
***************************************************************************}
{ Opaque reference to a metadata object}
type
	QTMetaDataRef = ^SInt32; { an opaque type }
{ Opaque identifier for metadata item}
type
	QTMetaDataItem = UInt64;
const
	kQTMetaDataItemUninitialized = 0;     { Uninitialized metadata item identifier}

{
    Metadata Storage Format.
}
type
	QTMetaDataStorageFormat = OSType;
const
	kQTMetaDataStorageFormatWildcard = 0;  { Wildcard storage format}

{
    Metadata Key Format.
}
type
	QTMetaDataKeyFormat = OSType;
const
	kQTMetaDataKeyFormatWildcard = 0;     { Match any key regardless of key format}

{***************************************
 *  Common Key Format                   *
 **************************************}
const
	kQTMetaDataKeyFormatCommon = FourCharCode('comn');

{ Pre-defined meta keys}
const
	kQTMetaDataCommonKeyAuthor = FourCharCode('auth');
	kQTMetaDataCommonKeyComment = FourCharCode('cmmt');
	kQTMetaDataCommonKeyCopyright = FourCharCode('cprt');
	kQTMetaDataCommonKeyDirector = FourCharCode('dtor');
	kQTMetaDataCommonKeyDisplayName = FourCharCode('name');
	kQTMetaDataCommonKeyInformation = FourCharCode('info');
	kQTMetaDataCommonKeyKeywords = FourCharCode('keyw');
	kQTMetaDataCommonKeyProducer = FourCharCode('prod');
	kQTMetaDataCommonKeyAlbum = FourCharCode('albm');
	kQTMetaDataCommonKeyArtist = FourCharCode('arts');
	kQTMetaDataCommonKeyArtwork = FourCharCode('artw');
	kQTMetaDataCommonKeyChapterName = FourCharCode('chap');
	kQTMetaDataCommonKeyComposer = FourCharCode('comp');
	kQTMetaDataCommonKeyDescription = FourCharCode('desc');
	kQTMetaDataCommonKeyGenre = FourCharCode('genr');
	kQTMetaDataCommonKeyOriginalFormat = FourCharCode('orif');
	kQTMetaDataCommonKeyOriginalSource = FourCharCode('oris');
	kQTMetaDataCommonKeyPerformers = FourCharCode('perf');
	kQTMetaDataCommonKeySoftware = FourCharCode('soft');
	kQTMetaDataCommonKeyWriter = FourCharCode('wrtr');


{***************************************
 *  QuickTime Native Metadata Format    *
 **************************************}
{ QTMetaDataStorageFormat type}
const
	kQTMetaDataStorageFormatQuickTime = FourCharCode('mdta'); { QuickTime metadata storage format}

{ QTMetaDataKeyFormat type}
const
	kQTMetaDataKeyFormatQuickTime = FourCharCode('mdta'); { Reverse DNS format}

{***************************************
 *  iTunes Native Metadata Format       *
 **************************************}
{ QTMetaDataStorageFormat type}
const
	kQTMetaDataStorageFormatiTunes = FourCharCode('itms'); { iTunes metadata storage format}

{ QTMetaDataKeyFormat type}
const
	kQTMetaDataKeyFormatiTunesShortForm = FourCharCode('itsk'); { FourCharCode}
	kQTMetaDataKeyFormatiTunesLongForm = FourCharCode('itlk'); { Reverse DNS format}

{ The list of keys for iTunes metadata is TBA.}

{***************************************
 *  UserData Native Format              *
 **************************************}
{ QTMetaDataStorageFormat type}
const
	kQTMetaDataStorageFormatUserData = FourCharCode('udta'); { UserData storage format}

{ QTMetaDataKeyFormat type}
const
	kQTMetaDataKeyFormatUserData = FourCharCode('udta'); { FourCharCode}

{ The list of keys are the User Data Identifiers (e.g. kUserDataTextAuthor, kUserDataTextCopyright, etc.)}

{
    Mapping from common keys to user data identifiers:
    
    kQTMetaDataCommonKeyAuthor                  -> kUserDataTextAuthor
    kQTMetaDataCommonKeyComment                 -> kUserDataTextComment
    kQTMetaDataCommonKeyCopyright               -> kUserDataTextCopyright
    kQTMetaDataCommonKeyDirector                -> kUserDataTextDirector
    kQTMetaDataCommonKeyDisplayName             -> kUserDataTextFullName
    kQTMetaDataCommonKeyInformation             -> kUserDataTextInformation
    kQTMetaDataCommonKeyKeywords                -> kUserDataTextKeywords
    kQTMetaDataCommonKeyProducer                -> kUserDataTextProducer
    kQTMetaDataCommonKeyAlbum                   -> kUserDataTextAlbum
    kQTMetaDataCommonKeyArtist                  -> kUserDataTextArtist
    kQTMetaDataCommonKeyChapterName             -> kUserDataTextChapter
    kQTMetaDataCommonKeyComposer                -> kUserDataTextComposer
    kQTMetaDataCommonKeyDescription             -> kUserDataTextDescription
    kQTMetaDataCommonKeyGenre                   -> kUserDataTextGenre
    kQTMetaDataCommonKeyOriginalFormat          -> kUserDataTextOriginalFormat
    kQTMetaDataCommonKeyOriginalSource          -> kUserDataTextOriginalSource
    kQTMetaDataCommonKeyPerformers              -> kUserDataTextPerformers
    kQTMetaDataCommonKeySoftware                -> kUserDataTextSoftware
    kQTMetaDataCommonKeyWriter                  -> kUserDataTextWriter
}
{***************************************
 *  Metadata Property Class ID          *
 **************************************}
const
	kPropertyClass_MetaData = FourCharCode('meta');

{ Metadata Property ID }

const
{
   * kQTMetaDataPropertyID_StorageFormats: The list of storage formats
   * (QTMetaDataStorageFormat) associated with this QTMetaDataRef
   * object. Return - C-style array of OSTypes, Read
   }
	kQTMetaDataPropertyID_StorageFormats = FourCharCode('fmts');

  {
   * kQTMetaDataPropertyID_OwnerType: The owner type associated with
   * this QTMetaDataRef object. Return - OSType (QT_MOVIE_TYPE,
   * QT_TRACK_TYPE, QT_MEDIA_TYPE), Read
   }
	kQTMetaDataPropertyID_OwnerType = FourCharCode('ownt');

  {
   * kQTMetaDataPropertyID_Owner: The owner associated with this
   * QTMetaDataRef object. The QTMetaDataRef object does not
   * necessarily need to have an owner. Return - Movie, Track, or
   * Media, Read
   }
	kQTMetaDataPropertyID_Owner = FourCharCode('ownr');

{ 
    Metadata Item Property Class ID 
}
const
	kPropertyClass_MetaDataItem = FourCharCode('mdit');

{ Metadata Item Property ID }

const
{
   * kQTMetaDataItemPropertyID_Value: The value of the metadata item.
   * Return - C-style array of UInt8, Read
   }
	kQTMetaDataItemPropertyID_Value = FourCharCode('valu');

  {
   * kQTMetaDataItemPropertyID_DataType: The value type of the metadata
   * item. Return - UInt32, Read/Write
   }
	kQTMetaDataItemPropertyID_DataType = FourCharCode('dtyp');

  {
   * kQTMetaDataItemPropertyID_StorageFormat: The storage format
   * (QTMetaDataStorageFormat). Return - QTMetaDataStorageFormat, Read
   }
	kQTMetaDataItemPropertyID_StorageFormat = FourCharCode('sfmt');

  {
   * kQTMetaDataItemPropertyID_Key: The key associated with the
   * metadata item. Return - C-style array of UInt8, Read/Write
   }
	kQTMetaDataItemPropertyID_Key = FourCharCode('key ');

  {
   * kQTMetaDataItemPropertyID_KeyFormat: The format of the key used.
   * Return - OSType, Read/Write
   }
	kQTMetaDataItemPropertyID_KeyFormat = FourCharCode('keyf');

  {
   * kQTMetaDataItemPropertyID_Locale: The locale identifier based on
   * the naming convention defined by the International Components for
   * Unicode (ICU). The identifier consists of two pieces of ordered
   * information: a language code and a region code. The language code
   * is based on the ISO 639-1 standard, which defines two-character
   * codes, such as "en" and "fr", for the world's most commonly used
   * languages. If a two-letter code is not available, then ISO 639-2
   * three-letter identifiers are accepted as well, for example "haw"
   * for Hawaiian. The region code is defined by ISO 3166-1. The region
   * code is in all caps and appended, after an underscore, after the
   * language code, for example "en_US", "en_GB", and "fr_FR". Return -
   * C-string, Read/Write
   }
	kQTMetaDataItemPropertyID_Locale = FourCharCode('loc ');

{ Well-known data type code}
const
	kQTMetaDataTypeBinary = 0;
	kQTMetaDataTypeUTF8 = 1;
	kQTMetaDataTypeUTF16BE = 2;
	kQTMetaDataTypeMacEncodedText = 3;
	kQTMetaDataTypeJPEGImage = 13;
	kQTMetaDataTypePNGImage = 14;
	kQTMetaDataTypeSignedIntegerBE = 21;  { The size of the integer is defined by the value size}
	kQTMetaDataTypeUnsignedIntegerBE = 22; { The size of the integer is defined by the value size}
	kQTMetaDataTypeFloat32BE = 23;
	kQTMetaDataTypeFloat64BE = 24;
	kQTMetaDataTypeBMPImage = 27;
	kQTMetaDataTypeQuickTimeMetaData = 28;


{***************************************
 *  QTMetaDataRef Access                *
 **************************************}
{
 *  QTCopyMovieMetaData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTCopyMovieMetaData( inMovie: Movie; var outMetaData: QTMetaDataRef ): OSStatus; external name '_QTCopyMovieMetaData';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTCopyTrackMetaData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTCopyTrackMetaData( inTrack: Track; var outMetaData: QTMetaDataRef ): OSStatus; external name '_QTCopyTrackMetaData';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTCopyMediaMetaData()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTCopyMediaMetaData( inMedia: Media; var outMetaData: QTMetaDataRef ): OSStatus; external name '_QTCopyMediaMetaData';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataRetain()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataRetain( inMetaData: QTMetaDataRef ): QTMetaDataRef; external name '_QTMetaDataRetain';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataRelease()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
procedure QTMetaDataRelease( inMetaData: QTMetaDataRef ); external name '_QTMetaDataRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataCreateFromBuffer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.2) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTMetaDataCreateFromBuffer( const (*var*) inBufferPtr: UInt8; inBufferSize: ByteCount; var outMetaData: QTMetaDataRef ): OSStatus; external name '_QTMetaDataCreateFromBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{
 *  QTMetaDataGetBytes()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.5 (or QuickTime 7.2) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function QTMetaDataGetBytes( inMetaData: QTMetaDataRef; inBufferSize: ByteCount; var inBufferPtr: UInt8; var outBufferSizeNeeded: ByteCount ): OSStatus; external name '_QTMetaDataGetBytes';
(* AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER *)


{***************************************
 *  Metadata Item Routines              *
 **************************************}
{
 *  QTMetaDataGetPropertyInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataGetPropertyInfo( inMetaData: QTMetaDataRef; inPropClass: QTPropertyClass; inPropID: QTPropertyID; var outPropType: QTPropertyValueType; var outPropValueSize: ByteCount; var outPropFlags: UInt32 ): OSStatus; external name '_QTMetaDataGetPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataGetProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataGetProperty( inMetaData: QTMetaDataRef; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; outPropValueAddress: QTPropertyValuePtr; var outPropValueSizeUsed: ByteCount ): OSStatus; external name '_QTMetaDataGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataSetProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataSetProperty( inMetaData: QTMetaDataRef; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstQTPropertyValuePtr ): OSStatus; external name '_QTMetaDataSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataGetItemValue()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataGetItemValue( inMetaData: QTMetaDataRef; inItem: QTMetaDataItem; var outValuePtr: UInt8; inValueSize: ByteCount; var outActualSize: ByteCount ): OSStatus; external name '_QTMetaDataGetItemValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataGetNextItem()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataGetNextItem( inMetaData: QTMetaDataRef; inMetaDataFormat: QTMetaDataStorageFormat; inCurrentItem: QTMetaDataItem; inKeyFormat: QTMetaDataKeyFormat; const (*var*) inKeyPtr: UInt8; inKeySize: ByteCount; var outNextItem: QTMetaDataItem ): OSStatus; external name '_QTMetaDataGetNextItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataGetItemPropertyInfo()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataGetItemPropertyInfo( inMetaData: QTMetaDataRef; inItem: QTMetaDataItem; inPropClass: QTPropertyClass; inPropID: QTPropertyID; var outPropType: QTPropertyValueType; var outPropValueSize: ByteCount; var outPropFlags: UInt32 ): OSStatus; external name '_QTMetaDataGetItemPropertyInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataGetItemProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataGetItemProperty( inMetaData: QTMetaDataRef; inItem: QTMetaDataItem; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; outPropValueAddress: QTPropertyValuePtr; var outPropValueSizeUsed: ByteCount ): OSStatus; external name '_QTMetaDataGetItemProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataSetItemProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataSetItemProperty( inMetaData: QTMetaDataRef; inItem: QTMetaDataItem; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inPropValueSize: ByteCount; inPropValueAddress: ConstQTPropertyValuePtr ): OSStatus; external name '_QTMetaDataSetItemProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataGetItemCountWithKey()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataGetItemCountWithKey( inMetaData: QTMetaDataRef; inMetaDataFormat: QTMetaDataStorageFormat; inKeyFormat: QTMetaDataKeyFormat; const (*var*) inKeyPtr: UInt8; inKeySize: ByteCount; var outCount: ItemCount ): OSStatus; external name '_QTMetaDataGetItemCountWithKey';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataAddItem()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataAddItem( inMetaData: QTMetaDataRef; inMetaDataFormat: QTMetaDataStorageFormat; inKeyFormat: QTMetaDataKeyFormat; const (*var*) inKeyPtr: UInt8; inKeySize: ByteCount; const (*var*) inValuePtr: UInt8; inValueSize: ByteCount; inDataType: UInt32; var outItem: QTMetaDataItem ): OSStatus; external name '_QTMetaDataAddItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataSetItem()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataSetItem( inMetaData: QTMetaDataRef; inItem: QTMetaDataItem; var inValuePtr: UInt8; inValueSize: ByteCount; inDataType: UInt32 ): OSStatus; external name '_QTMetaDataSetItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataRemoveItem()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataRemoveItem( inMetaData: QTMetaDataRef; inItem: QTMetaDataItem ): OSStatus; external name '_QTMetaDataRemoveItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  QTMetaDataRemoveItemsWithKey()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 *    Windows:          in qtmlClient.lib version 10.4 (or QuickTime 7.0) and later
 }
function QTMetaDataRemoveItemsWithKey( inMetaData: QTMetaDataRef; inMetaDataFormat: QTMetaDataStorageFormat; inKeyFormat: QTMetaDataKeyFormat; const (*var*) inKeyPtr: UInt8; inKeySize: ByteCount ): OSStatus; external name '_QTMetaDataRemoveItemsWithKey';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)


{
 *  MusicMediaGetIndexedTunePlayer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in QuickTimeLib 3.0 and later
 *    Windows:          in qtmlClient.lib 3.0 and later
 }
function MusicMediaGetIndexedTunePlayer( ti: ComponentInstance; sampleDescIndex: SIGNEDLONG; var tp: ComponentInstance ): ComponentResult; external name '_MusicMediaGetIndexedTunePlayer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


type
	QTBandwidthUsageRecordPtr = ^OpaqueQTBandwidthUsageRecordPtr; { an opaque type }
	OpaqueQTBandwidthUsageRecordPtr = record end;
	QTBandwidthReference = ^QTBandwidthUsageRecordPtr; 
	QTBandwidthReferencePtr = ^QTBandwidthReference;  { when a var xx:QTBandwidthReference parameter can be nil, it is changed to xx: QTBandwidthReferencePtr }
	QTScheduledBandwidthUsageRecordPtr = ^OpaqueQTScheduledBandwidthUsageRecordPtr; { an opaque type }
	OpaqueQTScheduledBandwidthUsageRecordPtr = record end;
	QTScheduledBandwidthReference    = ^QTScheduledBandwidthUsageRecordPtr;
	QTScheduledBandwidthReferencePtr = ^QTScheduledBandwidthReference;  { when a var xx:QTScheduledBandwidthReference parameter can be nil, it is changed to xx: QTScheduledBandwidthReferencePtr }
const
	BandwidthManagementPrefsType = FourCharCode('bwmg');


type
	BandwidthManagementPrefsRecordPtr = ^BandwidthManagementPrefsRecord;
	BandwidthManagementPrefsRecord = record
		overrideConnectionSpeedForBandwidth: Boolean;
	end;
type
	BandwidthManagementPrefsPtr = BandwidthManagementPrefsRecordPtr;
	BandwidthManagementPrefsHandle = ^BandwidthManagementPrefsPtr;
const
	kQTBandwidthNotifyNeedToStop = 1 shl 0;
	kQTBandwidthNotifyGoodToGo = 1 shl 1;
	kQTBandwidthChangeRequest = 1 shl 2;
	kQTBandwidthQueueRequest = 1 shl 3;
	kQTBandwidthScheduledRequest = 1 shl 4;
	kQTBandwidthVoluntaryRelease = 1 shl 5;

type
	QTBandwidthNotificationProcPtr = function( flags: SIGNEDLONG; reserved: UnivPtr; refcon: UnivPtr ): OSErr;
	QTScheduledBandwidthRecordPtr = ^QTScheduledBandwidthRecord;
	QTScheduledBandwidthRecord = record
		recordSize: SIGNEDLONG;             { total number of bytes in QTScheduledBandwidthRecord}

		priority: SIGNEDLONG;
		dataRate: SIGNEDLONG;
		startTime: CompTimeValue;              { bandwidth usage start time}
		duration: CompTimeValue;               { duration of bandwidth usage (0 if unknown)}
		prerollDuration: CompTimeValue;        { time for negotiation before startTime (0 if unknown)}
		scale: TimeScale;                  { timescale of value/duration/prerollDuration fields}
		base: TimeBase;                   { timebase}
	end;
type
	QTScheduledBandwidthPtr = QTScheduledBandwidthRecordPtr;
	QTScheduledBandwidthHandle = ^QTScheduledBandwidthPtr;
	QTBandwidthNotificationUPP = QTBandwidthNotificationProcPtr;
{
 *  QTBandwidthRequest()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    No longer need to call bandwidth management functions.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function QTBandwidthRequest( priority: SIGNEDLONG; callback: QTBandwidthNotificationUPP; refcon: {const} UnivPtr; var bwRef: QTBandwidthReference; flags: SIGNEDLONG ): OSErr; external name '_QTBandwidthRequest';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  QTBandwidthRequestForTimeBase()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    No longer need to call bandwidth management functions.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function QTBandwidthRequestForTimeBase( tb: TimeBase; priority: SIGNEDLONG; callback: QTBandwidthNotificationUPP; refcon: {const} UnivPtr; var bwRef: QTBandwidthReference; flags: SIGNEDLONG ): OSErr; external name '_QTBandwidthRequestForTimeBase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  QTBandwidthRelease()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    No longer need to call bandwidth management functions.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.0 and later
 *    Windows:          in qtmlClient.lib 4.0 and later
 }
function QTBandwidthRelease( bwRef: QTBandwidthReference; flags: SIGNEDLONG ): OSErr; external name '_QTBandwidthRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  QTScheduledBandwidthRequest()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    No longer need to call bandwidth management functions.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function QTScheduledBandwidthRequest( scheduleRec: QTScheduledBandwidthPtr; notificationCallback: QTBandwidthNotificationUPP; refcon: UnivPtr; var sbwRef: QTScheduledBandwidthReference; flags: SIGNEDLONG ): OSErr; external name '_QTScheduledBandwidthRequest';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  QTScheduledBandwidthRelease()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    No longer need to call bandwidth management functions.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in QuickTimeLib 4.1 and later
 *    Windows:          in qtmlClient.lib 4.1 and later
 }
function QTScheduledBandwidthRelease( sbwRef: QTScheduledBandwidthReference; flags: SIGNEDLONG ): OSErr; external name '_QTScheduledBandwidthRelease';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  NewMCActionFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewMCActionFilterUPP( userRoutine: MCActionFilterProcPtr ): MCActionFilterUPP; external name '_NewMCActionFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewMCActionFilterWithRefConUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewMCActionFilterWithRefConUPP( userRoutine: MCActionFilterWithRefConProcPtr ): MCActionFilterWithRefConUPP; external name '_NewMCActionFilterWithRefConUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  NewMCActionNotificationUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewMCActionNotificationUPP( userRoutine: MCActionNotificationProcPtr ): MCActionNotificationUPP; external name '_NewMCActionNotificationUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  NewQTMoviePropertyListenerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 9.9 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewQTMoviePropertyListenerUPP( userRoutine: QTMoviePropertyListenerProcPtr ): QTMoviePropertyListenerUPP; external name '_NewQTMoviePropertyListenerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  NewQTTrackPropertyListenerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 9.9 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewQTTrackPropertyListenerUPP( userRoutine: QTTrackPropertyListenerProcPtr ): QTTrackPropertyListenerUPP; external name '_NewQTTrackPropertyListenerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{
 *  NewQTBandwidthNotificationUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewQTBandwidthNotificationUPP( userRoutine: QTBandwidthNotificationProcPtr ): QTBandwidthNotificationUPP; external name '_NewQTBandwidthNotificationUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  DisposeMCActionFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeMCActionFilterUPP( userUPP: MCActionFilterUPP ); external name '_DisposeMCActionFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeMCActionFilterWithRefConUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeMCActionFilterWithRefConUPP( userUPP: MCActionFilterWithRefConUPP ); external name '_DisposeMCActionFilterWithRefConUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeMCActionNotificationUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeMCActionNotificationUPP( userUPP: MCActionNotificationUPP ); external name '_DisposeMCActionNotificationUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  DisposeQTMoviePropertyListenerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 9.9 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeQTMoviePropertyListenerUPP( userUPP: QTMoviePropertyListenerUPP ); external name '_DisposeQTMoviePropertyListenerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  DisposeQTTrackPropertyListenerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 9.9 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeQTTrackPropertyListenerUPP( userUPP: QTTrackPropertyListenerUPP ); external name '_DisposeQTTrackPropertyListenerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{
 *  DisposeQTBandwidthNotificationUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeQTBandwidthNotificationUPP( userUPP: QTBandwidthNotificationUPP ); external name '_DisposeQTBandwidthNotificationUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  InvokeMCActionFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeMCActionFilterUPP( mc: MovieController; var action: SInt16; params: UnivPtr; userUPP: MCActionFilterUPP ): Boolean; external name '_InvokeMCActionFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeMCActionFilterWithRefConUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeMCActionFilterWithRefConUPP( mc: MovieController; action: SInt16; params: UnivPtr; refCon: SIGNEDLONG; userUPP: MCActionFilterWithRefConUPP ): Boolean; external name '_InvokeMCActionFilterWithRefConUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeMCActionNotificationUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeMCActionNotificationUPP( mc: MovieController; action: SInt16; params: UnivPtr; inFlags: UInt32; var outFlags: UInt32; refCon: UnivPtr; userUPP: MCActionNotificationUPP ): Boolean; external name '_InvokeMCActionNotificationUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  InvokeQTMoviePropertyListenerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.3 (or QuickTime 6.4) and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 9.9 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeQTMoviePropertyListenerUPP( inMovie: Movie; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inUserData: UnivPtr; userUPP: QTMoviePropertyListenerUPP ); external name '_InvokeQTMoviePropertyListenerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{
 *  InvokeQTTrackPropertyListenerUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 (or QuickTime 7.0) and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 9.9 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeQTTrackPropertyListenerUPP( inTrack: Track; inPropClass: QTPropertyClass; inPropID: QTPropertyID; inUserData: UnivPtr; userUPP: QTTrackPropertyListenerUPP ); external name '_InvokeQTTrackPropertyListenerUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER *)

{
 *  InvokeQTBandwidthNotificationUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in QuickTime.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeQTBandwidthNotificationUPP( flags: SIGNEDLONG; reserved: UnivPtr; refcon: UnivPtr; userUPP: QTBandwidthNotificationUPP ): OSErr; external name '_InvokeQTBandwidthNotificationUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{ UPP call backs }

{ selectors for component calls }
const
	kVideoMediaResetStatisticsSelect = $0105;
	kVideoMediaGetStatisticsSelect = $0106;
	kVideoMediaGetStallCountSelect = $010E;
	kVideoMediaSetCodecParameterSelect = $010F;
	kVideoMediaGetCodecParameterSelect = $0110;
	kTextMediaSetTextProcSelect = $0101;
	kTextMediaAddTextSampleSelect = $0102;
	kTextMediaAddTESampleSelect = $0103;
	kTextMediaAddHiliteSampleSelect = $0104;
	kTextMediaDrawRawSelect = $0109;
	kTextMediaSetTextPropertySelect = $010A;
	kTextMediaRawSetupSelect = $010B;
	kTextMediaRawIdleSelect = $010C;
	kTextMediaGetTextPropertySelect = $010D;
	kTextMediaFindNextTextSelect = $0105;
	kTextMediaHiliteTextSampleSelect = $0106;
	kTextMediaSetTextSampleDataSelect = $0107;
	kSpriteMediaSetPropertySelect = $0101;
	kSpriteMediaGetPropertySelect = $0102;
	kSpriteMediaHitTestSpritesSelect = $0103;
	kSpriteMediaCountSpritesSelect = $0104;
	kSpriteMediaCountImagesSelect = $0105;
	kSpriteMediaGetIndImageDescriptionSelect = $0106;
	kSpriteMediaGetDisplayedSampleNumberSelect = $0107;
	kSpriteMediaGetSpriteNameSelect = $0108;
	kSpriteMediaGetImageNameSelect = $0109;
	kSpriteMediaSetSpritePropertySelect = $010A;
	kSpriteMediaGetSpritePropertySelect = $010B;
	kSpriteMediaHitTestAllSpritesSelect = $010C;
	kSpriteMediaHitTestOneSpriteSelect = $010D;
	kSpriteMediaSpriteIndexToIDSelect = $010E;
	kSpriteMediaSpriteIDToIndexSelect = $010F;
	kSpriteMediaGetSpriteActionsForQTEventSelect = $0110;
	kSpriteMediaSetActionVariableSelect = $0111;
	kSpriteMediaGetActionVariableSelect = $0112;
	kSpriteMediaGetIndImagePropertySelect = $0113;
	kSpriteMediaNewSpriteSelect = $0114;
	kSpriteMediaDisposeSpriteSelect = $0115;
	kSpriteMediaSetActionVariableToStringSelect = $0116;
	kSpriteMediaGetActionVariableAsStringSelect = $0117;
	kSpriteMediaNewImageSelect = $011B;
	kSpriteMediaDisposeImageSelect = $011C;
	kSpriteMediaImageIndexToIDSelect = $011D;
	kSpriteMediaImageIDToIndexSelect = $011E;
	kFlashMediaSetPanSelect = $0101;
	kFlashMediaSetZoomSelect = $0102;
	kFlashMediaSetZoomRectSelect = $0103;
	kFlashMediaGetRefConBoundsSelect = $0104;
	kFlashMediaGetRefConIDSelect = $0105;
	kFlashMediaIDToRefConSelect = $0106;
	kFlashMediaGetDisplayedFrameNumberSelect = $0107;
	kFlashMediaFrameNumberToMovieTimeSelect = $0108;
	kFlashMediaFrameLabelToMovieTimeSelect = $0109;
	kFlashMediaGetFlashVariableSelect = $010A;
	kFlashMediaSetFlashVariableSelect = $010B;
	kFlashMediaDoButtonActionsSelect = $010C;
	kFlashMediaGetSupportedSwfVersionSelect = $010D;
	kMovieMediaGetChildDoMCActionCallbackSelect = $0102;
	kMovieMediaGetDoMCActionCallbackSelect = $0103;
	kMovieMediaGetCurrentMoviePropertySelect = $0104;
	kMovieMediaGetCurrentTrackPropertySelect = $0105;
	kMovieMediaGetChildMovieDataReferenceSelect = $0106;
	kMovieMediaSetChildMovieDataReferenceSelect = $0107;
	kMovieMediaLoadChildMovieFromDataReferenceSelect = $0108;
	kMedia3DGetNamedObjectListSelect = $0101;
	kMedia3DGetRendererListSelect = $0102;
	kMedia3DGetCurrentGroupSelect = $0103;
	kMedia3DTranslateNamedObjectToSelect = $0104;
	kMedia3DScaleNamedObjectToSelect = $0105;
	kMedia3DRotateNamedObjectToSelect = $0106;
	kMedia3DSetCameraDataSelect = $0107;
	kMedia3DGetCameraDataSelect = $0108;
	kMedia3DSetCameraAngleAspectSelect = $0109;
	kMedia3DGetCameraAngleAspectSelect = $010A;
	kMedia3DSetCameraRangeSelect = $010D;
	kMedia3DGetCameraRangeSelect = $010E;
	kMedia3DGetViewObjectSelect = $010F;
	kMCSetMovieSelect = $0002;
	kMCGetIndMovieSelect = $0005;
	kMCRemoveAllMoviesSelect = $0006;
	kMCRemoveAMovieSelect = $0003;
	kMCRemoveMovieSelect = $0006;
	kMCIsPlayerEventSelect = $0007;
	kMCSetActionFilterSelect = $0008;
	kMCDoActionSelect = $0009;
	kMCSetControllerAttachedSelect = $000A;
	kMCIsControllerAttachedSelect = $000B;
	kMCSetControllerPortSelect = $000C;
	kMCGetControllerPortSelect = $000D;
	kMCSetVisibleSelect = $000E;
	kMCGetVisibleSelect = $000F;
	kMCGetControllerBoundsRectSelect = $0010;
	kMCSetControllerBoundsRectSelect = $0011;
	kMCGetControllerBoundsRgnSelect = $0012;
	kMCGetWindowRgnSelect = $0013;
	kMCMovieChangedSelect = $0014;
	kMCSetDurationSelect = $0015;
	kMCGetCurrentTimeSelect = $0016;
	kMCNewAttachedControllerSelect = $0017;
	kMCDrawSelect = $0018;
	kMCActivateSelect = $0019;
	kMCIdleSelect = $001A;
	kMCKeySelect = $001B;
	kMCClickSelect = $001C;
	kMCEnableEditingSelect = $001D;
	kMCIsEditingEnabledSelect = $001E;
	kMCCopySelect = $001F;
	kMCCutSelect = $0020;
	kMCPasteSelect = $0021;
	kMCClearSelect = $0022;
	kMCUndoSelect = $0023;
	kMCPositionControllerSelect = $0024;
	kMCGetControllerInfoSelect = $0025;
	kMCSetClipSelect = $0028;
	kMCGetClipSelect = $0029;
	kMCDrawBadgeSelect = $002A;
	kMCSetUpEditMenuSelect = $002B;
	kMCGetMenuStringSelect = $002C;
	kMCSetActionFilterWithRefConSelect = $002D;
	kMCPtInControllerSelect = $002E;
	kMCInvalidateSelect = $002F;
	kMCAdjustCursorSelect = $0030;
	kMCGetInterfaceElementSelect = $0031;
	kMCGetDoActionsProcSelect = $0032;
	kMCAddMovieSegmentSelect = $0033;
	kMCTrimMovieSegmentSelect = $0034;
	kMCSetIdleManagerSelect = $0035;
	kMCSetControllerCapabilitiesSelect = $0036;
	kMusicMediaGetIndexedTunePlayerSelect = $0101;

{$endc} {not TARGET_CPU_64}

{$endc} {TARGET_OS_MAC}
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
