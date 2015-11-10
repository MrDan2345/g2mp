{
     File:       SpeechRecognition/SpeechRecognition.h
 
     Contains:   Apple Speech Recognition Toolbox Interfaces.
 
     Version:    SpeechRecognition-4.1.5~11
 
     Copyright:  � 1992-2008 by Apple Computer, Inc., all rights reserved.
 
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

unit SpeechRecognition;
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
uses MacTypes,Files,AEDataModel;
{$endc} {not MACOSALLINCLUDE}


{$ifc TARGET_OS_MAC}

{$ALIGN MAC68K}

{ Error Codes [Speech recognition gets -5100 through -5199] }
const
	kSRNotAvailable = -5100; { the service requested is not avail or applicable }
	kSRInternalError = -5101; { a system internal or hardware error condition }
	kSRComponentNotFound = -5102; { a needed system resource was not located }
	kSROutOfMemory = -5103; { an out of memory error occurred in the toolbox memory space }
	kSRNotASpeechObject = -5104; { the object specified is no longer or never was valid }
	kSRBadParameter = -5105; { an invalid parameter was specified }
	kSRParamOutOfRange = -5106; { when we say 0-100, don't pass in 101. }
	kSRBadSelector = -5107; { an unrecognized selector was specified }
	kSRBufferTooSmall = -5108; { returned from attribute access functions }
	kSRNotARecSystem = -5109; { the object used was not a SRRecognitionSystem }
	kSRFeedbackNotAvail = -5110; { there is no feedback window associated with SRRecognizer }
	kSRCantSetProperty = -5111; { a non-settable property was specified }
	kSRCantGetProperty = -5112; { a non-gettable property was specified }
	kSRCantSetDuringRecognition = -5113; { the property can't be set while recognition is in progress -- do before or between utterances. }
	kSRAlreadyListening = -5114; { in response to SRStartListening }
	kSRNotListeningState = -5115; { in response to SRStopListening }
	kSRModelMismatch = -5116; { no acoustical models are avail to match request }
	kSRNoClientLanguageModel = -5117; { trying to access a non-specified SRLanguageModel }
	kSRNoPendingUtterances = -5118; { nothing to continue search on }
	kSRRecognitionCanceled = -5119; { an abort error occurred during search }
	kSRRecognitionDone = -5120; { search has finished, but nothing was recognized }
	kSROtherRecAlreadyModal = -5121; { another recognizer is modal at the moment, so can't set this recognizer's kSRBlockModally property right now }
	kSRHasNoSubItems = -5122; { SRCountItems or related routine was called on an object without subelements -- e.g. a word -- rather than phrase, path, or LM. }
	kSRSubItemNotFound = -5123; { returned when accessing a non-existent sub item of a container }
	kSRLanguageModelTooBig = -5124; { Cant build language models so big }
	kSRAlreadyReleased = -5125; { this object has already been released before }
	kSRAlreadyFinished = -5126; { the language model can't be finished twice }
	kSRWordNotFound = -5127; { the spelling couldn't be found in lookup(s) }
	kSRNotFinishedWithRejection = -5128; { property not found because the LMObj is not finished with rejection }
	kSRExpansionTooDeep = -5129; { Language model is left recursive or is embedded too many levels }
	kSRTooManyElements = -5130; { Too many elements added to phrase or path or other langauge model object }
	kSRCantAdd = -5131; { Can't add given type of object to the base SRLanguageObject (e.g.in SRAddLanguageObject)   }
	kSRSndInSourceDisconnected = -5132; { Sound input source is disconnected }
	kSRCantReadLanguageObject = -5133; { An error while trying to create new Language object from file or pointer -- possibly bad format }
                                        { non-release debugging error codes are included here }
	kSRNotImplementedYet = -5199; { you'd better wait for this feature in a future release }


{ Type Definitions }
type
	SRSpeechObject = ^OpaqueSRSpeechObject; { an opaque type }
	OpaqueSRSpeechObject = record end;
	SRSpeechObjectPtr = ^SRSpeechObject;  { when a var xx:SRSpeechObject parameter can be nil, it is changed to xx: SRSpeechObjectPtr }
	SRRecognitionSystem = SRSpeechObject;
	SRRecognizer = SRSpeechObject;
	SRSpeechSource = SRSpeechObject;
	SRRecognitionResult = SRSpeechSource;
	SRLanguageObject = SRSpeechObject;
	SRLanguageModel = SRLanguageObject;
	SRPath = SRLanguageObject;
	SRPhrase = SRLanguageObject;
	SRWord = SRLanguageObject;
{ between 0 and 100 }
type
	SRSpeedSetting = UInt16;
{ between 0 and 100 }
type
	SRRejectionLevel = UInt16;
{ When an event occurs, the user supplied proc will be called with a pointer   }
{  to the param passed in and a flag to indicate conditions such               }
{  as interrupt time or system background time.                                }
type
	SRCallBackStructPtr = ^SRCallBackStruct;
	SRCallBackStruct = record
		what: UInt32;                   { one of notification flags }
		message: SIGNEDLONG;                { contains SRRecognitionResult id (32 / 64 bits) }
		instance: SRRecognizer;               { ID of recognizer being notified }
		status: OSErr;                 { result status of last search }
		flags: SInt16;                  { non-zero if occurs during interrupt }
		refCon: SRefCon;                 { user defined - set from SRCallBackParam }
	end;
{ Call back procedure definition }
type
	SRCallBackProcPtr = procedure( var param: SRCallBackStruct );
	SRCallBackUPP = SRCallBackProcPtr;
{
 *  NewSRCallBackUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewSRCallBackUPP( userRoutine: SRCallBackProcPtr ): SRCallBackUPP; external name '_NewSRCallBackUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeSRCallBackUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeSRCallBackUPP( userUPP: SRCallBackUPP ); external name '_DisposeSRCallBackUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeSRCallBackUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0.2 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeSRCallBackUPP( var param: SRCallBackStruct; userUPP: SRCallBackUPP ); external name '_InvokeSRCallBackUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

type
	SRCallBackParamPtr = ^SRCallBackParam;
	SRCallBackParam = record
		callBack: SRCallBackUPP;
		refCon: SRefCon;
	end;
{ Recognition System Types }
const
	kSRDefaultRecognitionSystemID = 0;

{ Recognition System Properties }
const
	kSRFeedbackAndListeningModes = FourCharCode('fbwn'); { short: one of kSRNoFeedbackHasListenModes, kSRHasFeedbackHasListenModes, kSRNoFeedbackNoListenModes }
	kSRRejectedWord = FourCharCode('rejq'); { the SRWord used to represent a rejection }
	kSRCleanupOnClientExit = FourCharCode('clup'); { Boolean: Default is true. The rec system and everything it owns is disposed when the client application quits }

const
	kSRNoFeedbackNoListenModes = 0;    { next allocated recognizer has no feedback window and doesn't use listening modes   }
	kSRHasFeedbackHasListenModes = 1;    { next allocated recognizer has feedback window and uses listening modes          }
	kSRNoFeedbackHasListenModes = 2;     { next allocated recognizer has no feedback window but does use listening modes  }

{ Speech Source Types }
const
	kSRDefaultSpeechSource = 0;
	kSRLiveDesktopSpeechSource = FourCharCode('dklv'); { live desktop sound input }
	kSRCanned22kHzSpeechSource = FourCharCode('ca22'); { AIFF file based 16 bit, 22.050 KHz sound input }

{ Notification via Apple Event or Callback }
{ Notification Flags }
const
	kSRNotifyRecognitionBeginning = 1 shl 0; { recognition can begin. client must now call SRContinueRecognition or SRCancelRecognition }
	kSRNotifyRecognitionDone = 1 shl 1; { recognition has terminated. result (if any) is available. }

{ Apple Event selectors }
{ AppleEvent message class  }
const
	kAESpeechSuite = FourCharCode('sprc');

{ AppleEvent message event ids }
const
	kAESpeechDone = FourCharCode('srsd');
	kAESpeechDetected = FourCharCode('srbd');

{ AppleEvent Parameter ids }
const
	keySRRecognizer = FourCharCode('krec');
	keySRSpeechResult = FourCharCode('kspr');
	keySRSpeechStatus = FourCharCode('ksst');

{ AppleEvent Parameter types }
const
	typeSRRecognizer = FourCharCode('trec');
	typeSRSpeechResult = FourCharCode('tspr');


{ SRRecognizer Properties }
const
	kSRNotificationParam = FourCharCode('noti'); { SInt32: See notification flags below }
	kSRCallBackParam = FourCharCode('call'); { type SRCallBackParam }
	kSRSearchStatusParam = FourCharCode('stat'); { SInt32: see status flags below }
	kSRAutoFinishingParam = FourCharCode('afin'); { SInt32: Automatic finishing applied on LM for search }
	kSRForegroundOnly = FourCharCode('fgon'); { Boolean: Default is true. If true, client recognizer only active when in foreground.   }
	kSRBlockBackground = FourCharCode('blbg'); { Boolean: Default is false. If true, when client recognizer in foreground, rest of LMs are inactive.    }
	kSRBlockModally = FourCharCode('blmd'); { Boolean: Default is false. When true, this client's LM is only active LM; all other LMs are inactive. Be nice, don't be modal for long periods! }
	kSRWantsResultTextDrawn = FourCharCode('txfb'); { Boolean: Default is true. If true, search results are posted to Feedback window }
	kSRWantsAutoFBGestures = FourCharCode('dfbr'); { Boolean: Default is true. If true, client needn't call SRProcessBegin/End to get default feedback behavior }
	kSRSoundInVolume = FourCharCode('volu'); { short in [0..100] log scaled sound input power. Can't set this property }
	kSRReadAudioFSSpec = FourCharCode('aurd'); { *FSSpec: Specify FSSpec where raw audio is to be read (AIFF format) using kSRCanned22kHzSpeechSource. Reads until EOF }
	kSRReadAudioURL = FourCharCode('aurl'); { CFURLRef: Specify CFURLRef where raw audio is to be read (AIFF format) using kSRCanned22kHzSpeechSource. Reads until EOF }
	kSRCancelOnSoundOut = FourCharCode('caso'); { Boolean: Default is true.  If any sound is played out during utterance, recognition is aborted. }
	kSRSpeedVsAccuracyParam = FourCharCode('sped'); { SRSpeedSetting between 0 and 100 }

{ 0 means more accurate but slower. }
{ 100 means (much) less accurate but faster. }
const
	kSRUseToggleListen = 0;    { listen key modes }
	kSRUsePushToTalk = 1;

const
	kSRListenKeyMode = FourCharCode('lkmd'); { short: either kSRUseToggleListen or kSRUsePushToTalk }
	kSRListenKeyCombo = FourCharCode('lkey'); { short: Push-To-Talk key combination; high byte is high byte of event->modifiers, the low byte is the keycode from event->message }
	kSRListenKeyName = FourCharCode('lnam'); { Str63: string representing ListenKeyCombo }
	kSRKeyWord = FourCharCode('kwrd'); { Str255: keyword preceding spoken commands in kSRUseToggleListen mode }
	kSRKeyExpected = FourCharCode('kexp'); { Boolean: Must the PTT key be depressed or the key word spoken before recognition can occur? }

{ Operational Status Flags }
const
	kSRIdleRecognizer = 1 shl 0; { engine is not active }
	kSRSearchInProgress = 1 shl 1; { search is in progress }
	kSRSearchWaitForAllClients = 1 shl 2; { search is suspended waiting on all clients' input }
	kSRMustCancelSearch = 1 shl 3; { something has occurred (sound played, non-speech detected) requiring the search to abort }
	kSRPendingSearch = 1 shl 4; { we're about to start searching }

{ Recognition Result Properties }
const
	kSRTEXTFormat = FourCharCode('TEXT'); { raw text in user supplied memory }
	kSRPhraseFormat = FourCharCode('lmph'); { SRPhrase containing result words }
	kSRPathFormat = FourCharCode('lmpt'); { SRPath containing result phrases or words }
	kSRLanguageModelFormat = FourCharCode('lmfm'); { top level SRLanguageModel for post parse }

{ SRLanguageObject Family Properties }
const
	kSRSpelling = FourCharCode('spel'); { spelling of a SRWord or SRPhrase or SRPath, or name of a SRLanguageModel }
	kSRLMObjType = FourCharCode('lmtp'); { Returns one of SRLanguageObject Types listed below }
	kSRRefCon = FourCharCode('refc'); { long (4/8 bytes) for user storage }
	kSROptional = FourCharCode('optl'); { Boolean -- true if SRLanguageObject is optional    }
	kSREnabled = FourCharCode('enbl'); { Boolean -- true if SRLanguageObject enabled }
	kSRRepeatable = FourCharCode('rptb'); { Boolean -- true if SRLanguageObject is repeatable }
	kSRRejectable = FourCharCode('rjbl'); { Boolean -- true if SRLanguageObject is rejectable (Recognition System's kSRRejectedWord }
                                        {       object can be returned in place of SRLanguageObject with this property)   }
	kSRRejectionLevel = FourCharCode('rjct'); { SRRejectionLevel between 0 and 100 }

{ LM Object Types -- returned as kSRLMObjType property of language model objects }
const
	kSRLanguageModelType = FourCharCode('lmob'); { SRLanguageModel }
	kSRPathType = FourCharCode('path'); { SRPath }
	kSRPhraseType = FourCharCode('phra'); { SRPhrase }
	kSRWordType = FourCharCode('word'); { SRWord }

{ a normal and reasonable rejection level }
const
	kSRDefaultRejectionLevel = 50;

{******************************************************************************}
{                      NOTES ON USING THE API                                  }
{      All operations (with the exception of SRGetRecognitionSystem) are       }
{      directed toward an object allocated or begot from New, Get and Read     }
{      type calls.                                                             }
{      There is a simple rule in dealing with allocation and disposal:         }
{      *   all toolbox allocations are obtained from a SRRecognitionSystem     }
{      *   if you obtain an object via New or Get, then you own a reference    }
{          to that object and it must be released via SRReleaseObject when     }
{          you no longer need it                                               }
{      *   when you receive a SRRecognitionResult object via AppleEvent or     }
{          callback, it has essentially been created on your behalf and so     }
{          you are responsible for releasing it as above                       }
{      *   when you close a SRRecognitionSystem, all remaining objects which       }
{          were allocated with it will be forcefully released and any          }
{          remaining references to those objects will be invalid.              }
{      This translates into a very simple guideline:                           }
{          If you allocate it or have it allocated for you, you must release   }
{          it.  If you are only peeking at it, then don't release it.          }
{******************************************************************************}
{ Opening and Closing of the SRRecognitionSystem }
{
 *  SROpenRecognitionSystem()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SROpenRecognitionSystem( var system: SRRecognitionSystem; systemID: OSType ): OSErr; external name '_SROpenRecognitionSystem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRCloseRecognitionSystem()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRCloseRecognitionSystem( system: SRRecognitionSystem ): OSErr; external name '_SRCloseRecognitionSystem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Accessing Properties of any Speech Object }
{
 *  SRSetProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRSetProperty( srObject: SRSpeechObject; selector: OSType; proprty: {const} UnivPtr; propertyLen: Size ): OSErr; external name '_SRSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRGetProperty()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRGetProperty( srObject: SRSpeechObject; selector: OSType; proprty: UnivPtr; var propertyLen: Size ): OSErr; external name '_SRGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Any object obtained via New or Get type calls must be released }
{
 *  SRReleaseObject()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRReleaseObject( srObject: SRSpeechObject ): OSErr; external name '_SRReleaseObject';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRGetReference()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRGetReference( srObject: SRSpeechObject; var newObjectRef: SRSpeechObject ): OSErr; external name '_SRGetReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ SRRecognizer Instance Functions }
{
 *  SRNewRecognizer()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRNewRecognizer( system: SRRecognitionSystem; var recognizer: SRRecognizer; sourceID: OSType ): OSErr; external name '_SRNewRecognizer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRStartListening()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRStartListening( recognizer: SRRecognizer ): OSErr; external name '_SRStartListening';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRStopListening()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRStopListening( recognizer: SRRecognizer ): OSErr; external name '_SRStopListening';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRSetLanguageModel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRSetLanguageModel( recognizer: SRRecognizer; languageModel: SRLanguageModel ): OSErr; external name '_SRSetLanguageModel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRGetLanguageModel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRGetLanguageModel( recognizer: SRRecognizer; var languageModel: SRLanguageModel ): OSErr; external name '_SRGetLanguageModel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRContinueRecognition()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRContinueRecognition( recognizer: SRRecognizer ): OSErr; external name '_SRContinueRecognition';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRCancelRecognition()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRCancelRecognition( recognizer: SRRecognizer ): OSErr; external name '_SRCancelRecognition';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRIdle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRIdle: OSErr; external name '_SRIdle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Language Model Building and Manipulation Functions }
{
 *  SRNewLanguageModel()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRNewLanguageModel( system: SRRecognitionSystem; var model: SRLanguageModel; name: {const} UnivPtr; nameLength: SInt32 ): OSErr; external name '_SRNewLanguageModel';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRNewPath()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRNewPath( system: SRRecognitionSystem; var path: SRPath ): OSErr; external name '_SRNewPath';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRNewPhrase()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRNewPhrase( system: SRRecognitionSystem; var phrase: SRPhrase; text: {const} UnivPtr; textLength: SInt32 ): OSErr; external name '_SRNewPhrase';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRNewWord()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRNewWord( system: SRRecognitionSystem; var word: SRWord; text: {const} UnivPtr; textLength: SInt32 ): OSErr; external name '_SRNewWord';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Operations on any object of the SRLanguageObject family }
{
 *  SRPutLanguageObjectIntoHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRPutLanguageObjectIntoHandle( languageObject: SRLanguageObject; lobjHandle: Handle ): OSErr; external name '_SRPutLanguageObjectIntoHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRPutLanguageObjectIntoDataFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRPutLanguageObjectIntoDataFile( languageObject: SRLanguageObject; fRefNum: SInt16 ): OSErr; external name '_SRPutLanguageObjectIntoDataFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRNewLanguageObjectFromHandle()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRNewLanguageObjectFromHandle( system: SRRecognitionSystem; var languageObject: SRLanguageObject; lObjHandle: Handle ): OSErr; external name '_SRNewLanguageObjectFromHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRNewLanguageObjectFromDataFile()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRNewLanguageObjectFromDataFile( system: SRRecognitionSystem; var languageObject: SRLanguageObject; fRefNum: SInt16 ): OSErr; external name '_SRNewLanguageObjectFromDataFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SREmptyLanguageObject()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SREmptyLanguageObject( languageObject: SRLanguageObject ): OSErr; external name '_SREmptyLanguageObject';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRChangeLanguageObject()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRChangeLanguageObject( languageObject: SRLanguageObject; text: {const} UnivPtr; textLength: SInt32 ): OSErr; external name '_SRChangeLanguageObject';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRAddLanguageObject()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRAddLanguageObject( base: SRLanguageObject; addon: SRLanguageObject ): OSErr; external name '_SRAddLanguageObject';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRAddText()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRAddText( base: SRLanguageObject; text: {const} UnivPtr; textLength: SInt32; refCon: SRefCon ): OSErr; external name '_SRAddText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRRemoveLanguageObject()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRRemoveLanguageObject( base: SRLanguageObject; toRemove: SRLanguageObject ): OSErr; external name '_SRRemoveLanguageObject';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Traversing SRRecognitionResults or SRLanguageObjects }
{
 *  SRCountItems()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRCountItems( container: SRSpeechObject; var count: SIGNEDLONG ): OSErr; external name '_SRCountItems';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRGetIndexedItem()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRGetIndexedItem( container: SRSpeechObject; var item: SRSpeechObject; index: SIGNEDLONG ): OSErr; external name '_SRGetIndexedItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRSetIndexedItem()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRSetIndexedItem( container: SRSpeechObject; item: SRSpeechObject; index: SIGNEDLONG ): OSErr; external name '_SRSetIndexedItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRRemoveIndexedItem()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRRemoveIndexedItem( container: SRSpeechObject; index: SIGNEDLONG ): OSErr; external name '_SRRemoveIndexedItem';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Utilizing the System Feedback Window }
{
 *  SRDrawText()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRDrawText( recognizer: SRRecognizer; dispText: {const} UnivPtr; dispLength: SInt32 ): OSErr; external name '_SRDrawText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRDrawRecognizedText()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRDrawRecognizedText( recognizer: SRRecognizer; dispText: {const} UnivPtr; dispLength: SInt32 ): OSErr; external name '_SRDrawRecognizedText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRSpeakText()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRSpeakText( recognizer: SRRecognizer; speakText: {const} UnivPtr; speakLength: SInt32 ): OSErr; external name '_SRSpeakText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRSpeakAndDrawText()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRSpeakAndDrawText( recognizer: SRRecognizer; text: {const} UnivPtr; textLength: SInt32 ): OSErr; external name '_SRSpeakAndDrawText';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRStopSpeech()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRStopSpeech( recognizer: SRRecognizer ): OSErr; external name '_SRStopSpeech';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRSpeechBusy()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRSpeechBusy( recognizer: SRRecognizer ): Boolean; external name '_SRSpeechBusy';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRProcessBegin()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRProcessBegin( recognizer: SRRecognizer; failed: Boolean ): OSErr; external name '_SRProcessBegin';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SRProcessEnd()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in SpeechRecognitionLib 1.0 and later
 }
function SRProcessEnd( recognizer: SRRecognizer; failed: Boolean ): OSErr; external name '_SRProcessEnd';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{$endc} {TARGET_OS_MAC}
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
