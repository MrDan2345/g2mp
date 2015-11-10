{	CFXMLParser.h
	Copyright (c) 1998-2012, Apple Inc. All rights reserved.
}
{	  Pascal Translation Updated:  Peter N Lewis, <peter@stairways.com.au>, November 2005 }
{	  Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
{	  Pascal Translation Updated:  Jonas Maebe <jonas@freepascal.org>, September 2012 }
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

unit CFXMLParser;
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
uses MacTypes,CFBase,CFArray,CFData,CFDictionary,CFTree,CFURL,CFXMLNode;
{$endc} {not MACOSALLINCLUDE}

{$ALIGN POWER}


type
	CFXMLParserRef = ^__CFXMLParser; { an opaque type }
	__CFXMLParser = record end;
	CFXMLParserRefPtr = ^CFXMLParserRef;

{ These are the various options you can configure the parser with.  These are
   chosen such that an option flag of 0 (kCFXMLParserNoOptions) leaves the XML
   as "intact" as possible (reports all structures; performs no replacements).
   Hence, to make the parser do the most work, returning only the pure element
   tree, set the option flag to kCFXMLParserAllOptions.

kCFXMLParserValidateDocument -
   validate the document against its grammar from the DTD, reporting any errors.
   Currently not supported.

kCFXMLParserSkipMetaData -
   silently skip over metadata constructs (the DTD and comments)

kCFXMLParserReplacePhysicalEntities -
   replace declared entities like &lt;.  Note that other than the 5 predefined
   entities (lt, gt, quot, amp, apos), these must be defined in the DTD.
   Currently not supported.

kCFXMLParserSkipWhitespace -
   skip over all whitespace that does not abut non-whitespace character data.
   In other words, given <foo>  <bar> blah </bar></foo>, the whitespace between
   foo's open tag and bar's open tag would be suppressed, but the whitespace
   around blah would be preserved.

kCFXMLParserAddImpliedAttributes -
   where the DTD specifies implied attribute-value pairs for a particular element,
   add those pairs to any occurances of the element in the element tree.
   Currently not supported.
}

type
	CFXMLParserOptions = CFOptionFlags;
const
	kCFXMLParserValidateDocument = 1 shl 0;
	kCFXMLParserSkipMetaData = 1 shl 1;
	kCFXMLParserReplacePhysicalEntities = 1 shl 2;
	kCFXMLParserSkipWhitespace = 1 shl 3;
	kCFXMLParserResolveExternalEntities = 1 shl 4;
	kCFXMLParserAddImpliedAttributes = 1 shl 5;
	kCFXMLParserAllOptions = $00FFFFFF;
	kCFXMLParserNoOptions = 0;

{ This list is expected to grow }
type
	CFXMLParserStatusCode = CFIndex;
const
	kCFXMLStatusParseNotBegun	= -2;
	kCFXMLStatusParseInProgress	= -1;
	kCFXMLStatusParseSuccessful	= 0;
	kCFXMLErrorUnexpectedEOF	= 1;
	kCFXMLErrorUnknownEncoding	= 2;
	kCFXMLErrorEncodingConversionFailure = 3;
	kCFXMLErrorMalformedProcessingInstruction = 4;
	kCFXMLErrorMalformedDTD		= 5;
	kCFXMLErrorMalformedName	= 6;
	kCFXMLErrorMalformedCDSect	= 7;
	kCFXMLErrorMalformedCloseTag = 8;
	kCFXMLErrorMalformedStartTag = 9;
	kCFXMLErrorMalformedDocument = 10;
	kCFXMLErrorElementlessDocument = 11;
	kCFXMLErrorMalformedComment	= 12;
	kCFXMLErrorMalformedCharacterReference = 13;
	kCFXMLErrorMalformedParsedCharacterData = 14;
	kCFXMLErrorNoData			= 15;


{  These functions are called as a parse progresses.

createXMLStructure -
  called as new XML structures are encountered by the parser.  May return NULL to indicate
  that the given structure should be skipped; if NULL is returned for a given structure,
  only minimal parsing is done for that structure (enough to correctly determine its end,
  and to extract any data necessary for the remainder of the parse, such as Entity definitions).
  createXMLStructure (or indeed, any of the tree-creation callbacks) will not be called for any
  children of the skipped structure.  The only exception is that the top-most element will always
  be reported even if NULL was returned for the document as a whole.  NOTE: for performance reasons,
  the node passed to createXMLStructure cannot be safely retained by the client; the node as
  a whole must be copied (via CFXMLNodeCreateCopy), or its contents must be extracted and copied.

addChild -
  called as children are parsed and are ready to be added to the tree.  If createXMLStructure
  returns NULL for a given structure, that structure is omitted entirely, and addChild will
  NOT be called for either a NULL child or parent.

endXMLStructure -
  called once a structure (and all its children) are completely parsed.  As elements are encountered,
  createXMLStructure is called for them first, then addChild to add the new structure to its parent,
  then addChild (potentially several times) to add the new structure's children to it, then finally 
  endXMLStructure to show that the structure has been fully parsed.

createXMLStructure, addChild, and endXMLStructure are all REQUIRED TO BE NON-NULL.

resolveExternalEntity -
  called when external entities are referenced (NOT when they are simply defined).  If the function
  pointer is NULL, the parser uses its internal routines to try and resolve the entity.  If the
  function pointer is set, and the function returns NULL, a place holder for the external entity
  is inserted into the tree.  In this manner, the parser's client can prevent any external network 
  or file accesses.

handleError - called as errors/warnings are encountered in the data stream.  At some point, we will
  have an enum of the expected errors, some of which will be fatal, others of which will not.  If
  the function pointer is NULL, the parser will silently attempt to recover.  The
  handleError function may always return false to force the parser to stop; if handleError returns
  true, the parser will attempt to recover (fatal errors will still cause the parse to abort
  immediately).
}

type
	CFXMLParserCreateXMLStructureCallBack = function( parser: CFXMLParserRef; nodeDesc: CFXMLNodeRef; info: UnivPtr ): UnivPtr;
	CFXMLParserAddChildCallBack = procedure( parser: CFXMLParserRef; parent: UnivPtr; child: UnivPtr; info: UnivPtr );
	CFXMLParserEndXMLStructureCallBack = procedure( parser: CFXMLParserRef; xmlType: UnivPtr; info: UnivPtr );
	CFXMLParserResolveExternalEntityCallBack = function( parser: CFXMLParserRef; var extID: CFXMLExternalID; info: UnivPtr ): CFDataRef;
	CFXMLParserHandleErrorCallBack = function( parser: CFXMLParserRef; error: CFXMLParserStatusCode; info: UnivPtr ): Boolean;
	CFXMLParserCallBacksPtr = ^CFXMLParserCallBacks;
	CFXMLParserCallBacks = record
		version: CFIndex;
		createXMLStructure: CFXMLParserCreateXMLStructureCallBack;
		addChild: CFXMLParserAddChildCallBack;
		endXMLStructure: CFXMLParserEndXMLStructureCallBack;
		resolveExternalEntity: CFXMLParserResolveExternalEntityCallBack;
		handleError: CFXMLParserHandleErrorCallBack;
	end;

type
	CFXMLParserRetainCallBack = function( info: {const} UnivPtr ): UnivPtr;
	CFXMLParserReleaseCallBack = procedure( info: {const} UnivPtr );
	CFXMLParserCopyDescriptionCallBack = function( info: {const} UnivPtr ): CFStringRef;
	CFXMLParserContextPtr = ^CFXMLParserContext;
	CFXMLParserContext = record
		version: CFIndex;
		info: UnivPtr;
		retain: CFXMLParserRetainCallBack;
		release: CFXMLParserReleaseCallBack;
		copyDescription: CFXMLParserCopyDescriptionCallBack;
	end;

function CFXMLParserGetTypeID: CFTypeID; external name '_CFXMLParserGetTypeID';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

{ Creates a parser which will parse the given data with the given options.  xmlData may not be NULL. 
   dataSource should be the URL from which the data came, and may be NULL; it is used to resolve any
   relative references found in xmlData. versionOfNodes determines which version CFXMLNodes are produced
   by the parser; see CFXMLNode.h for more details.  callBacks are the callbacks called by the parser as
   the parse progresses; callBacks, callBacks->createXMLStructure, callBacks->addChild, and
   callBacks->endXMLStructure must all be non-NULL.  context determines what if any info pointer is
   passed to the callbacks as the parse progresses; context may be NULL.  }
function CFXMLParserCreate( allocator: CFAllocatorRef; xmlData: CFDataRef; dataSource: CFURLRef; parseOptions: CFOptionFlags; versionOfNodes: CFIndex; var callBacks: CFXMLParserCallBacks; var context: CFXMLParserContext ): CFXMLParserRef; external name '_CFXMLParserCreate';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

{ Arguments as above, except that the data to be parsed is loaded directly 
   from dataSource.  dataSource may not be NULL.  }
function CFXMLParserCreateWithDataFromURL( allocator: CFAllocatorRef; dataSource: CFURLRef; parseOptions: CFOptionFlags; versionOfNodes: CFIndex; var callBacks: CFXMLParserCallBacks; var context: CFXMLParserContext ): CFXMLParserRef; external name '_CFXMLParserCreateWithDataFromURL';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

procedure CFXMLParserGetContext( parser: CFXMLParserRef; var context: CFXMLParserContext ); external name '_CFXMLParserGetContext';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

procedure CFXMLParserGetCallBacks( parser: CFXMLParserRef; var callBacks: CFXMLParserCallBacks ); external name '_CFXMLParserGetCallBacks';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

function CFXMLParserGetSourceURL( parser: CFXMLParserRef ): CFURLRef; external name '_CFXMLParserGetSourceURL';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

{ Returns the character index of the current parse location }
function CFXMLParserGetLocation( parser: CFXMLParserRef ): CFIndex; external name '_CFXMLParserGetLocation';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

{ Returns the line number of the current parse location }
function CFXMLParserGetLineNumber( parser: CFXMLParserRef ): CFIndex; external name '_CFXMLParserGetLineNumber';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

{ Returns the top-most object returned by the createXMLStructure callback }
function CFXMLParserGetDocument( parser: CFXMLParserRef ): UnivPtr; external name '_CFXMLParserGetDocument';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

{ Get the status code or a user-readable description of the last error that occurred in a parse.
   If no error has occurred, a null description string is returned.  See the enum above for
   possible status returns }
function CFXMLParserGetStatusCode( parser: CFXMLParserRef ): CFXMLParserStatusCode; external name '_CFXMLParserGetStatusCode';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

function CFXMLParserCopyErrorDescription( parser: CFXMLParserRef ): CFStringRef; external name '_CFXMLParserCopyErrorDescription';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

{ Cause any in-progress parse to abort with the given error code and description.  errorCode
   must be positive, and errorDescription may not be NULL.  Cannot be called asynchronously
   (i.e. must be called from within a parser callback) }
procedure CFXMLParserAbort( parser: CFXMLParserRef; errorCode: CFXMLParserStatusCode; errorDescription: CFStringRef ); external name '_CFXMLParserAbort';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

{ Starts a parse of the data the parser was created with; returns success or failure.
   Upon success, use CFXMLParserGetDocument() to get the product of the parse.  Upon
   failure, use CFXMLParserGetErrorCode() or CFXMLParserCopyErrorDescription() to get
   information about the error.  It is an error to call CFXMLParserParse() while a
   parse is already underway. }
function CFXMLParserParse( parser: CFXMLParserRef ): Boolean; external name '_CFXMLParserParse';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

{ These functions provide a higher-level interface.  The XML data is parsed to a
   special CFTree (an CFXMLTree) with known contexts and callbacks.  See CFXMLNode.h
   for full details on using an CFXMLTree and the CFXMLNodes contained therein.
}
{ Parse to an CFXMLTreeRef.  parseOptions are as above. versionOfNodes determines
   what version CFXMLNodes are used to populate the tree.  }
function CFXMLTreeCreateFromData( allocator: CFAllocatorRef; xmlData: CFDataRef; dataSource: CFURLRef; parseOptions: CFOptionFlags; versionOfNodes: CFIndex ): CFXMLTreeRef; external name '_CFXMLTreeCreateFromData';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

{ As above, with the additional by-reference pass of a CFDictionaryRef containing
   various error information (see below). The caller is responsible for releasing the
   returned dictionary. If the error dictionary is not desired, pass NULL. }
function CFXMLTreeCreateFromDataWithError( allocator: CFAllocatorRef; xmlData: CFDataRef; dataSource: CFURLRef; parseOptions: CFOptionFlags; versionOfNodes: CFIndex; var errorDict: CFDictionaryRef ): CFXMLTreeRef; external name '_CFXMLTreeCreateFromDataWithError';
(* CF_AVAILABLE_BUT_DEPRECATED(10_3, 10_8, 2_0, 6_0) *)

{ Loads the data to be parsed directly from dataSource.  Arguments as above. }
function CFXMLTreeCreateWithDataFromURL( allocator: CFAllocatorRef; dataSource: CFURLRef; parseOptions: CFOptionFlags; versionOfNodes: CFIndex ): CFXMLTreeRef; external name '_CFXMLTreeCreateWithDataFromURL';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

{ Generate the XMLData (ready to be written to whatever permanent storage is to be
   used) from an CFXMLTree.  Will NOT regenerate entity references (except those
   required for syntactic correctness) if they were replaced at the parse time;
   clients that wish this should walk the tree and re-insert any entity references
   that should appear in the final output file. }
function CFXMLTreeCreateXMLData( allocator: CFAllocatorRef; xmlTree: CFXMLTreeRef ): CFDataRef; external name '_CFXMLTreeCreateXMLData';
(* CF_AVAILABLE_BUT_DEPRECATED(10_0, 10_8, 2_0, 6_0) *)

{ Escaping and unescaping XML entities in CFStrings. The standard XML entities
   are always replaced.  }
{ Creates a CFString by replacing entities that appear in the entities dictionary.
   Dictionary keys are the entities themselves, and the values should be CFStrings
   containing the expansion. Pass NULL for entitiesDictionary to indicate no entities
   other than the standard five. }
function CFXMLCreateStringByEscapingEntities( allocator: CFAllocatorRef; strng: CFStringRef; entitiesDictionary: CFDictionaryRef ): CFStringRef; external name '_CFXMLCreateStringByEscapingEntities';

function CFXMLCreateStringByUnescapingEntities( allocator: CFAllocatorRef; strng: CFStringRef; entitiesDictionary: CFDictionaryRef ): CFStringRef; external name '_CFXMLCreateStringByUnescapingEntities';
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)

{ CFXMLTreeCreateFromDataWithError error dictionary key constants. }
var kCFXMLTreeErrorDescription: CFStringRef; external name '_kCFXMLTreeErrorDescription'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
    { value is a CFString containing the readable error string. }

var kCFXMLTreeErrorLineNumber: CFStringRef; external name '_kCFXMLTreeErrorLineNumber'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
    { value is a CFNumber containing the line on which the error appears. }

var kCFXMLTreeErrorLocation: CFStringRef; external name '_kCFXMLTreeErrorLocation'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
    { value is a CFNumber containing the byte location at which the error occurred. }

var kCFXMLTreeErrorStatusCode: CFStringRef; external name '_kCFXMLTreeErrorStatusCode'; (* attribute const *)
(* AVAILABLE_MAC_OS_X_VERSION_10_3_AND_LATER *)
    { value is a CFNumber containing the error status code. }

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
