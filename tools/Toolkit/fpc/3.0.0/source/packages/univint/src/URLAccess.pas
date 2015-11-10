{
     File:       SecurityHI/URLAccess.h
 
     Contains:   URL Access Interfaces.
 
     Version:    SecurityHI-55002~751
 
     Copyright:  � 1994-2008 by Apple Computer, Inc., all rights reserved
 
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

unit URLAccess;
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
uses MacTypes,Files,CodeFragments,MacErrors,Events;
{$endc} {not MACOSALLINCLUDE}


{$ifc TARGET_OS_MAC}

{$ALIGN MAC68K}

{ Data structures and types }
type
	URLReference = ^OpaqueURLReference; { an opaque type }
	OpaqueURLReference = record end;
	URLReferencePtr = ^URLReference;  { when a var xx:URLReference parameter can be nil, it is changed to xx: URLReferencePtr }
	URLOpenFlags = UInt32;
const
	kURLReplaceExistingFlag = 1 shl 0;
	kURLBinHexFileFlag = 1 shl 1; { Binhex before uploading if necessary}
	kURLExpandFileFlag = 1 shl 2; { Use StuffIt engine to expand file if necessary}
	kURLDisplayProgressFlag = 1 shl 3;
	kURLDisplayAuthFlag = 1 shl 4; { Display auth dialog if guest connection fails}
	kURLUploadFlag = 1 shl 5; { Do an upload instead of a download}
	kURLIsDirectoryHintFlag = 1 shl 6; { Hint: the URL is a directory}
	kURLDoNotTryAnonymousFlag = 1 shl 7; { Don't try to connect anonymously before getting logon info}
	kURLDirectoryListingFlag = 1 shl 8; { Download the directory listing, not the whole directory}
	kURLExpandAndVerifyFlag = 1 shl 9; { Expand file and then verify using signature resource}
	kURLNoAutoRedirectFlag = 1 shl 10; { Do not automatically redirect to new URL}
	kURLDebinhexOnlyFlag = 1 shl 11; { Do not use Stuffit Expander - just internal debinhex engine}
	kURLDoNotDeleteOnErrorFlag = 1 shl 12; { Do not delete the downloaded file if an error or abort occurs.}
                                        { This flag applies to downloading only and should be used if}
                                        { interested in later resuming the download.}
	kURLResumeDownloadFlag = 1 shl 13; { The passed in file is partially downloaded, attempt to resume}
                                        { it.  Currently works for HTTP only.  If no FSSpec passed in,}
                                        { this flag will be ignored. Overriden by kURLReplaceExistingFlag. }
	kURLReservedFlag = $80000000; { reserved for Apple internal use}

type
	URLState = UInt32;
const
	kURLNullState = 0;
	kURLInitiatingState = 1;
	kURLLookingUpHostState = 2;
	kURLConnectingState = 3;
	kURLResourceFoundState = 4;
	kURLDownloadingState = 5;
	kURLDataAvailableState = $10 + kURLDownloadingState;
	kURLTransactionCompleteState = 6;
	kURLErrorOccurredState = 7;
	kURLAbortingState = 8;
	kURLCompletedState = 9;
	kURLUploadingState = 10;

type
	URLEvent = UInt32;
const
	kURLInitiatedEvent = kURLInitiatingState;
	kURLResourceFoundEvent = kURLResourceFoundState;
	kURLDownloadingEvent = kURLDownloadingState;
	kURLAbortInitiatedEvent = kURLAbortingState;
	kURLCompletedEvent = kURLCompletedState;
	kURLErrorOccurredEvent = kURLErrorOccurredState;
	kURLDataAvailableEvent = kURLDataAvailableState;
	kURLTransactionCompleteEvent = kURLTransactionCompleteState;
	kURLUploadingEvent = kURLUploadingState;
	kURLSystemEvent = 29;
	kURLPercentEvent = 30;
	kURLPeriodicEvent = 31;
	kURLPropertyChangedEvent = 32;

type
	URLEventMask = UNSIGNEDLONG;
const
	kURLInitiatedEventMask = 1 shl (kURLInitiatedEvent - 1);
	kURLResourceFoundEventMask = 1 shl (kURLResourceFoundEvent - 1);
	kURLDownloadingMask = 1 shl (kURLDownloadingEvent - 1);
	kURLUploadingMask = 1 shl (kURLUploadingEvent - 1);
	kURLAbortInitiatedMask = 1 shl (kURLAbortInitiatedEvent - 1);
	kURLCompletedEventMask = 1 shl (kURLCompletedEvent - 1);
	kURLErrorOccurredEventMask = 1 shl (kURLErrorOccurredEvent - 1);
	kURLDataAvailableEventMask = 1 shl (kURLDataAvailableEvent - 1);
	kURLTransactionCompleteEventMask = 1 shl (kURLTransactionCompleteEvent - 1);
	kURLSystemEventMask = 1 shl (kURLSystemEvent - 1);
	kURLPercentEventMask = 1 shl (kURLPercentEvent - 1);
	kURLPeriodicEventMask = 1 shl (kURLPeriodicEvent - 1);
	kURLPropertyChangedEventMask = 1 shl (kURLPropertyChangedEvent - 1);
	kURLAllBufferEventsMask = kURLDataAvailableEventMask + kURLTransactionCompleteEventMask;
	kURLAllNonBufferEventsMask = kURLInitiatedEventMask + kURLDownloadingMask + kURLUploadingMask + kURLAbortInitiatedMask + kURLCompletedEventMask + kURLErrorOccurredEventMask + kURLPercentEventMask + kURLPeriodicEventMask + kURLPropertyChangedEventMask;
	kURLAllEventsMask = -1;


type
	URLCallbackInfo = record
		version: UInt32;
		urlRef: URLReference;
		proprty: ConstCStringPtr;
		currentSize: UInt32;
		systemEvent: EventRecordPtr;
	end;

{ authentication type flags}
const
	kUserNameAndPasswordFlag = $00000001;

const
	kURLURL = 'URLString';
const
	kURLResourceSize = 'URLResourceSize';
const
	kURLLastModifiedTime = 'URLLastModifiedTime';
const
	kURLMIMEType = 'URLMIMEType';
const
	kURLFileType = 'URLFileType';
const
	kURLFileCreator = 'URLFileCreator';
const
	kURLCharacterSet = 'URLCharacterSet';
const
	kURLResourceName = 'URLResourceName';
const
	kURLHost = 'URLHost';
const
	kURLAuthType = 'URLAuthType';
const
	kURLUserName = 'URLUserName';
const
	kURLPassword = 'URLPassword';
const
	kURLStatusString = 'URLStatusString';
const
	kURLIsSecure = 'URLIsSecure';
const
	kURLCertificate = 'URLCertificate';
const
	kURLTotalItems = 'URLTotalItems';
const
	kURLConnectTimeout = 'URLConnectTimeout';
{ http and https properties}
const
	kURLHTTPRequestMethod = 'URLHTTPRequestMethod';
const
	kURLHTTPRequestHeader = 'URLHTTPRequestHeader';
const
	kURLHTTPRequestBody = 'URLHTTPRequestBody';
const
	kURLHTTPRespHeader = 'URLHTTPRespHeader';
const
	kURLHTTPUserAgent = 'URLHTTPUserAgent';
const
	kURLHTTPRedirectedURL = 'URLHTTPRedirectedURL';
const
	kURLSSLCipherSuite = 'URLSSLCipherSuite';

{$ifc not TARGET_CPU_64}

{
 *  URLGetURLAccessVersion()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Return the version number ( in the same format as a
 *    NumVersionVariant.whole ) of the URLAccess libraries
 *    available.
 *    URLAccess is deprecated on Mac OS X.  See Technical Q&A 1291 for
 *    more information on the replacements available.
 *     http://developer.apple.com/qa/qa2001/qa1291.html
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLGetURLAccessVersion( var returnVers: UInt32 ): OSStatus; external name '_URLGetURLAccessVersion';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{$ifc TARGET_RT_MAC_CFM}
//    #define URLAccessAvailable()    ((URLGetURLAccessVersion != (void*)kUnresolvedCFragSymbolAddress) )
{$elsec}
  {$ifc TARGET_RT_MAC_MACHO}
{ URL Access is always available on OS X }
//    #define URLAccessAvailable()    (true)
  {$endc}
{$endc}  {  }

{$endc} {not TARGET_CPU_64}

type
	URLNotifyProcPtr = function( userContext: UnivPtr; event: URLEvent; var callbackInfo: URLCallbackInfo ): OSStatus;
	URLSystemEventProcPtr = function( userContext: UnivPtr; var event: EventRecord ): OSStatus;
	URLNotifyUPP = URLNotifyProcPtr;
	URLSystemEventUPP = URLSystemEventProcPtr;
{
 *  NewURLNotifyUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewURLNotifyUPP( userRoutine: URLNotifyProcPtr ): URLNotifyUPP; external name '_NewURLNotifyUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  NewURLSystemEventUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewURLSystemEventUPP( userRoutine: URLSystemEventProcPtr ): URLSystemEventUPP; external name '_NewURLSystemEventUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  DisposeURLNotifyUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeURLNotifyUPP( userUPP: URLNotifyUPP ); external name '_DisposeURLNotifyUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  DisposeURLSystemEventUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeURLSystemEventUPP( userUPP: URLSystemEventUPP ); external name '_DisposeURLSystemEventUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  InvokeURLNotifyUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeURLNotifyUPP( userContext: UnivPtr; event: URLEvent; var callbackInfo: URLCallbackInfo; userUPP: URLNotifyUPP ): OSStatus; external name '_InvokeURLNotifyUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  InvokeURLSystemEventUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeURLSystemEventUPP( userContext: UnivPtr; var event: EventRecord; userUPP: URLSystemEventUPP ): OSStatus; external name '_InvokeURLSystemEventUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{$ifc not TARGET_CPU_64}
{
 *  URLSimpleDownload()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLSimpleDownload( url: ConstCStringPtr; destination: FSSpecPtr { can be NULL }; destinationHandle: Handle { can be NULL }; openFlags: URLOpenFlags; eventProc: URLSystemEventUPP { can be NULL }; userContext: UnivPtr { can be NULL } ): OSStatus; external name '_URLSimpleDownload';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLDownload()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLDownload( urlRef: URLReference; destination: FSSpecPtr { can be NULL }; destinationHandle: Handle { can be NULL }; openFlags: URLOpenFlags; eventProc: URLSystemEventUPP { can be NULL }; userContext: UnivPtr { can be NULL } ): OSStatus; external name '_URLDownload';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLSimpleUpload()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLSimpleUpload( url: ConstCStringPtr; const (*var*) source: FSSpec; openFlags: URLOpenFlags; eventProc: URLSystemEventUPP { can be NULL }; userContext: UnivPtr { can be NULL } ): OSStatus; external name '_URLSimpleUpload';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLUpload()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLUpload( urlRef: URLReference; const (*var*) source: FSSpec; openFlags: URLOpenFlags; eventProc: URLSystemEventUPP { can be NULL }; userContext: UnivPtr { can be NULL } ): OSStatus; external name '_URLUpload';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLNewReference()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLNewReference( url: ConstCStringPtr; var urlRef: URLReference ): OSStatus; external name '_URLNewReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLDisposeReference()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLDisposeReference( urlRef: URLReference ): OSStatus; external name '_URLDisposeReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLOpen()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLOpen( urlRef: URLReference; fileSpec: FSSpecPtr { can be NULL }; openFlags: URLOpenFlags; notifyProc: URLNotifyUPP { can be NULL }; eventRegister: URLEventMask; userContext: UnivPtr { can be NULL } ): OSStatus; external name '_URLOpen';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLAbort()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLAbort( urlRef: URLReference ): OSStatus; external name '_URLAbort';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLGetDataAvailable()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLGetDataAvailable( urlRef: URLReference; var dataSize: Size ): OSStatus; external name '_URLGetDataAvailable';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLGetBuffer()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLGetBuffer( urlRef: URLReference; var buffer: UnivPtr; var bufferSize: Size ): OSStatus; external name '_URLGetBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLReleaseBuffer()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLReleaseBuffer( urlRef: URLReference; buffer: UnivPtr ): OSStatus; external name '_URLReleaseBuffer';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLGetProperty()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLGetProperty( urlRef: URLReference; proprty: ConstCStringPtr; propertyBuffer: UnivPtr; bufferSize: Size ): OSStatus; external name '_URLGetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLGetPropertySize()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLGetPropertySize( urlRef: URLReference; proprty: ConstCStringPtr; var propertySize: Size ): OSStatus; external name '_URLGetPropertySize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLSetProperty()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLSetProperty( urlRef: URLReference; proprty: ConstCStringPtr; propertyBuffer: UnivPtr; bufferSize: Size ): OSStatus; external name '_URLSetProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLGetCurrentState()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLGetCurrentState( urlRef: URLReference; var state: URLState ): OSStatus; external name '_URLGetCurrentState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLGetError()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLGetError( urlRef: URLReference; var urlError: OSStatus ): OSStatus; external name '_URLGetError';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLIdle()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLIdle: OSStatus; external name '_URLIdle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  URLGetFileInfo()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in URLAccessLib 1.0 and later
 }
function URLGetFileInfo( fName: StringPtr; var fType: OSType; var fCreator: OSType ): OSStatus; external name '_URLGetFileInfo';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{$endc} {not TARGET_CPU_64}


{$endc} {TARGET_OS_MAC}

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
