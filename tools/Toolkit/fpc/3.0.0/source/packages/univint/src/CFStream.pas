{	CFStream.h
	Copyright (c) 2000-2012, Apple Inc. All rights reserved.
}
{	  Pascal Translation:  Peter N Lewis, <peter@stairways.com.au>, 2004 }
{	  Pascal Translation Updated:  Peter N Lewis, <peter@stairways.com.au>, November 2005 }
{     Pascal Translation Updated:  Gale R Paeper, <gpaeper@empirenet.com>, 2008 }
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

unit CFStream;
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
uses MacTypes,CFBase,CFString,CFDictionary,CFURL,CFRunLoop,CFSocket,CFError;
{$endc} {not MACOSALLINCLUDE}

{$ALIGN POWER}


const
	kCFStreamStatusNotOpen = 0;
	kCFStreamStatusOpening = 1;  { open is in-progress }
	kCFStreamStatusOpen = 2;
	kCFStreamStatusReading = 3;
	kCFStreamStatusWriting = 4;
	kCFStreamStatusAtEnd = 5;    { no further bytes can be read/written }
	kCFStreamStatusClosed = 6;
	kCFStreamStatusError = 7;
type
	CFStreamStatus = CFIndex;

const
	kCFStreamEventNone = 0;
	kCFStreamEventOpenCompleted = 1;
	kCFStreamEventHasBytesAvailable = 2;
	kCFStreamEventCanAcceptBytes = 4;
	kCFStreamEventErrorOccurred = 8;
	kCFStreamEventEndEncountered = 16;
type
	CFStreamEventType = CFOptionFlags;

type
	CFStreamClientContext = record
		version: CFIndex;
		info: UnivPtr;
		retain: function( info: {const} UnivPtr ): UnivPtr;
		release: procedure( info: {const} UnivPtr );
		copyDescription: function( info: {const} UnivPtr ): CFStringRef;
	end;

type
	CFReadStreamRef = ^__CFReadStream; { an opaque type }
	__CFReadStream = record end;
	CFWriteStreamRefPtr = ^CFWriteStreamRef;
	CFWriteStreamRef = ^__CFWriteStream; { an opaque type }
	__CFWriteStream = record end;
	CFReadStreamRefPtr = ^CFReadStreamRef;

type
	CFReadStreamClientCallBack = procedure( stream: CFReadStreamRef; typ: CFStreamEventType; clientCallBackInfo: UnivPtr );
	CFWriteStreamClientCallBack = procedure( stream: CFWriteStreamRef; typ: CFStreamEventType; clientCallBackInfo: UnivPtr );

function CFReadStreamGetTypeID: CFTypeID; external name '_CFReadStreamGetTypeID';
function CFWriteStreamGetTypeID: CFTypeID; external name '_CFWriteStreamGetTypeID';

{ Memory streams }

{ Value will be a CFData containing all bytes thusfar written; used to recover the data written to a memory write stream. }
var kCFStreamPropertyDataWritten: CFStringRef; external name '_kCFStreamPropertyDataWritten'; (* attribute const *)

{ Pass kCFAllocatorNull for bytesDeallocator to prevent CFReadStream from deallocating bytes; otherwise, CFReadStream will deallocate bytes when the stream is destroyed }
function CFReadStreamCreateWithBytesNoCopy( alloc: CFAllocatorRef; bytes: UnivPtr; length: CFIndex; bytesDeallocator: CFAllocatorRef ): CFReadStreamRef; external name '_CFReadStreamCreateWithBytesNoCopy';

{ The stream writes into the buffer given; when bufferCapacity is exhausted, the stream is exhausted (status becomes kCFStreamStatusAtEnd) }
function CFWriteStreamCreateWithBuffer( alloc: CFAllocatorRef; buffer: UnivPtr; bufferCapacity: CFIndex ): CFWriteStreamRef; external name '_CFWriteStreamCreateWithBuffer';

{ New buffers are allocated from bufferAllocator as bytes are written to the stream.  At any point, you can recover the bytes thusfar written by asking for the property kCFStreamPropertyDataWritten, above }
function CFWriteStreamCreateWithAllocatedBuffers( alloc: CFAllocatorRef; bufferAllocator: CFAllocatorRef ): CFWriteStreamRef; external name '_CFWriteStreamCreateWithAllocatedBuffers';

{ File streams }
function CFReadStreamCreateWithFile( alloc: CFAllocatorRef; fileURL: CFURLRef ): CFReadStreamRef; external name '_CFReadStreamCreateWithFile';
function CFWriteStreamCreateWithFile( alloc: CFAllocatorRef; fileURL: CFURLRef ): CFWriteStreamRef; external name '_CFWriteStreamCreateWithFile';
{ CF_IMPLICIT_BRIDGING_DISABLED }
procedure CFStreamCreateBoundPair( alloc: CFAllocatorRef; var readStream: CFReadStreamRef; var writeStream: CFWriteStreamRef; transferBufferSize: CFIndex ); external name '_CFStreamCreateBoundPair';
{ CF_IMPLICIT_BRIDGING_ENABLED }

{#if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED}
{ Property for file write streams; value should be a CFBoolean.  Set to TRUE to append to a file, rather than to replace its contents }
var kCFStreamPropertyAppendToFile: CFStringRef; external name '_kCFStreamPropertyAppendToFile'; (* attribute const *)
{#endif}

// Value is a CFNumber
var kCFStreamPropertyFileCurrentOffset: CFStringRef; external name '_kCFStreamPropertyFileCurrentOffset'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{ Socket stream properties }

{ Value will be a CFData containing the native handle }
var kCFStreamPropertySocketNativeHandle: CFStringRef; external name '_kCFStreamPropertySocketNativeHandle'; (* attribute const *)

{ Value will be a CFString, or NULL if unknown }
var kCFStreamPropertySocketRemoteHostName: CFStringRef; external name '_kCFStreamPropertySocketRemoteHostName'; (* attribute const *)

{ Value will be a CFNumber, or NULL if unknown }
var kCFStreamPropertySocketRemotePortNumber: CFStringRef; external name '_kCFStreamPropertySocketRemotePortNumber'; (* attribute const *)

{ Socket streams; the returned streams are paired such that they use the same socket; pass NULL if you want only the read stream or the write stream }
procedure CFStreamCreatePairWithSocket( alloc: CFAllocatorRef; sock: CFSocketNativeHandle; var readStream: CFReadStreamRef; var writeStream: CFWriteStreamRef ); external name '_CFStreamCreatePairWithSocket';
procedure CFStreamCreatePairWithSocketToHost( alloc: CFAllocatorRef; host: CFStringRef; port: UInt32; var readStream: CFReadStreamRef; var writeStream: CFWriteStreamRef ); external name '_CFStreamCreatePairWithSocketToHost';
{#if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED}
procedure CFStreamCreatePairWithPeerSocketSignature( alloc: CFAllocatorRef; const (*var*) signature: CFSocketSignature; var readStream: CFReadStreamRef; var writeStream: CFWriteStreamRef ); external name '_CFStreamCreatePairWithPeerSocketSignature';
{#endif}


{ Returns the current state of the stream }
function CFReadStreamGetStatus( stream: CFReadStreamRef ): CFStreamStatus; external name '_CFReadStreamGetStatus';
function CFWriteStreamGetStatus( stream: CFWriteStreamRef ): CFStreamStatus; external name '_CFWriteStreamGetStatus';

{ Returns NULL if no error has occurred; otherwise returns the error. }
function CFReadStreamCopyError( stream: CFReadStreamRef ): CFErrorRef; external name '_CFReadStreamCopyError';
(* CF_AVAILABLE_STARTING(10_5, 2_0) *)
function CFWriteStreamCopyError( stream: CFWriteStreamRef ): CFErrorRef; external name '_CFWriteStreamCopyError';
(* CF_AVAILABLE_STARTING(10_5, 2_0) *)

{ Returns success/failure.  Opening a stream causes it to reserve all the system
   resources it requires.  If the stream can open non-blocking, this will always 
   return TRUE; listen to the run loop source to find out when the open completes
   and whether it was successful, or poll using CFRead/WriteStreamGetStatus(), waiting 
   for a status of kCFStreamStatusOpen or kCFStreamStatusError.  }
function CFReadStreamOpen( stream: CFReadStreamRef ): Boolean; external name '_CFReadStreamOpen';
function CFWriteStreamOpen( stream: CFWriteStreamRef ): Boolean; external name '_CFWriteStreamOpen';

{ Terminates the flow of bytes; releases any system resources required by the 
   stream.  The stream may not fail to close.  You may call CFStreamClose() to 
   effectively abort a stream. }
procedure CFReadStreamClose( stream: CFReadStreamRef ); external name '_CFReadStreamClose';
procedure CFWriteStreamClose( stream: CFWriteStreamRef ); external name '_CFWriteStreamClose';

{ Whether there is data currently available for reading; returns TRUE if it's 
   impossible to tell without trying }
function CFReadStreamHasBytesAvailable( stream: CFReadStreamRef ): Boolean; external name '_CFReadStreamHasBytesAvailable';

{ Returns the number of bytes read, or -1 if an error occurs preventing any 
   bytes from being read, or 0 if the stream's end was encountered.  
   It is an error to try and read from a stream that hasn't been opened first.  
   This call will block until at least one byte is available; it will NOT block
   until the entire buffer can be filled.  To avoid blocking, either poll using
   CFReadStreamHasBytesAvailable() or use the run loop and listen for the 
   kCFStreamCanRead event for notification of data available. }
function CFReadStreamRead( stream: CFReadStreamRef; buffer: UnivPtr; bufferLength: CFIndex ): CFIndex; external name '_CFReadStreamRead';

{ Returns a pointer to an internal buffer if possible (setting *numBytesRead
   to the length of the returned buffer), otherwise returns NULL; guaranteed 
   to return in O(1).  Bytes returned in the buffer are considered read from 
   the stream; if maxBytesToRead is greater than 0, not more than maxBytesToRead
   will be returned.  If maxBytesToRead is less than or equal to zero, as many bytes
   as are readily available will be returned.  The returned buffer is good only 
   until the next stream operation called on the stream.  Caller should neither 
   change the contents of the returned buffer nor attempt to deallocate the buffer;
   it is still owned by the stream. }
function CFReadStreamGetBuffer( stream: CFReadStreamRef; maxBytesToRead: CFIndex; var numBytesRead: CFIndex ): UInt8Ptr; external name '_CFReadStreamGetBuffer';

{ Whether the stream can currently be written to without blocking;
   returns TRUE if it's impossible to tell without trying }
function CFWriteStreamCanAcceptBytes( stream: CFWriteStreamRef ): Boolean; external name '_CFWriteStreamCanAcceptBytes';

{ Returns the number of bytes successfully written, -1 if an error has
   occurred, or 0 if the stream has been filled to capacity (for fixed-length
   streams).  If the stream is not full, this call will block until at least
   one byte is written.  To avoid blocking, either poll via CFWriteStreamCanAcceptBytes
   or use the run loop and listen for the kCFStreamCanWrite event. }
function CFWriteStreamWrite( stream: CFWriteStreamRef; buffer: UnivPtr; bufferLength: CFIndex ): CFIndex; external name '_CFWriteStreamWrite';

{ Particular streams can name properties and assign meanings to them; you
   access these properties through the following calls.  A property is any interesting
   information about the stream other than the data being transmitted itself.
   Examples include the headers from an HTTP transmission, or the expected 
   number of bytes, or permission information, etc.  Properties that can be set
   configure the behavior of the stream, and may only be settable at particular times
   (like before the stream has been opened).  See the documentation for particular 
   properties to determine their get- and set-ability. }
function CFReadStreamCopyProperty( stream: CFReadStreamRef; propertyName: CFStringRef ): CFTypeRef; external name '_CFReadStreamCopyProperty';
function CFWriteStreamCopyProperty( stream: CFWriteStreamRef; propertyName: CFStringRef ): CFTypeRef; external name '_CFWriteStreamCopyProperty';

{#if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED}
{ Returns TRUE if the stream recognizes and accepts the given property-value pair; 
   FALSE otherwise. }
function CFReadStreamSetProperty( stream: CFReadStreamRef; propertyName: CFStringRef; propertyValue: CFTypeRef ): Boolean; external name '_CFReadStreamSetProperty';
function CFWriteStreamSetProperty( stream: CFWriteStreamRef; propertyName: CFStringRef; propertyValue: CFTypeRef ): Boolean; external name '_CFWriteStreamSetProperty';
{#endif}

{ Asynchronous processing - If you wish to neither poll nor block, you may register 
   a client to hear about interesting events that occur on a stream.  Only one client
   per stream is allowed; registering a new client replaces the previous one.

   Once you have set a client, you need to schedule a run loop on which that client
   can be notified.  You may schedule multiple run loops (for instance, if you are 
   using a thread pool).  The client callback will be triggered via one of the scheduled
   run loops; It is the caller's responsibility to ensure that at least one of the 
   scheduled run loops is being run.

   NOTE: Unlike other CoreFoundation APIs, pasing a NULL clientContext here will remove
   the client.  If you do not care about the client context (i.e. your only concern
   is that your callback be called), you should pass in a valid context where every
   entry is 0 or NULL.

}

function CFReadStreamSetClient( stream: CFReadStreamRef; streamEvents: CFOptionFlags; clientCB: CFReadStreamClientCallBack; var clientContext: CFStreamClientContext ): Boolean; external name '_CFReadStreamSetClient';
function CFWriteStreamSetClient( stream: CFWriteStreamRef; streamEvents: CFOptionFlags; clientCB: CFWriteStreamClientCallBack; var clientContext: CFStreamClientContext ): Boolean; external name '_CFWriteStreamSetClient';

procedure CFReadStreamScheduleWithRunLoop( stream: CFReadStreamRef; runLoop: CFRunLoopRef; runLoopMode: CFStringRef ); external name '_CFReadStreamScheduleWithRunLoop';
procedure CFWriteStreamScheduleWithRunLoop( stream: CFWriteStreamRef; runLoop: CFRunLoopRef; runLoopMode: CFStringRef ); external name '_CFWriteStreamScheduleWithRunLoop';

procedure CFReadStreamUnscheduleFromRunLoop( stream: CFReadStreamRef; runLoop: CFRunLoopRef; runLoopMode: CFStringRef ); external name '_CFReadStreamUnscheduleFromRunLoop';
procedure CFWriteStreamUnscheduleFromRunLoop( stream: CFWriteStreamRef; runLoop: CFRunLoopRef; runLoopMode: CFStringRef ); external name '_CFWriteStreamUnscheduleFromRunLoop';


{ The following API is deprecated starting in 10.5; please use CFRead/WriteStreamCopyError(), above, instead }
const
	kCFStreamErrorDomainCustom = -1;      { custom to the kind of stream in question }
	kCFStreamErrorDomainPOSIX = 1;        { POSIX errno; interpret using <sys/errno.h> }
	kCFStreamErrorDomainMacOSStatus = 2;      { OSStatus type from Carbon APIs; interpret using <MacTypes.h> }
type
	CFStreamErrorDomain = CFIndex;

type
	CFStreamError = record
		domain: CFIndex; 
		error: SInt32;
	end;
	CFStreamErrorPtr = ^CFStreamError;

{ 0 is returned if no error has occurred.  errorDomain specifies the domain
   in which the error code should be interpretted; pass NULL if you are not 
   interested. }
function CFReadStreamGetError( stream: CFReadStreamRef ): CFStreamError; external name '_CFReadStreamGetError';
function CFWriteStreamGetError( stream: CFWriteStreamRef ): CFStreamError; external name '_CFWriteStreamGetError';
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
