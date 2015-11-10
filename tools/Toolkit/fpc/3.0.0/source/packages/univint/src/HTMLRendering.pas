{
     File:       HTMLRendering/HTMLRendering.h
 
     Contains:   HTML Rendering Library Interfaces.
 
     Version:    HTMLRenderingLib-78~55
 
     Copyright:  � 1999-2008 by Apple Computer, Inc., all rights reserved
 
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

unit HTMLRendering;
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
uses MacTypes,CFBase,QuickdrawTypes,Events,Files,CodeFragments,Controls,CFData,CFString,CFURL,HIObject;
{$endc} {not MACOSALLINCLUDE}


{$ifc TARGET_OS_MAC}

{
    HTMLRenderingLib has been deprecated. Please use WebKit instead for your OS X Carbon web widget needs.
 }


type
	HRReference = ^OpaqueHRReference; { an opaque type }
	OpaqueHRReference = record end;
{
 *  HRGetHTMLRenderingLibVersion()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRGetHTMLRenderingLibVersion( var returnVers: NumVersion ): OSStatus; external name '_HRGetHTMLRenderingLibVersion';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


const
	kHRRendererHTML32Type = FourCharCode('ht32'); { HTML 3.2 }


{
 *  HRNewReference()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRNewReference( var hrRef: HRReference; rendererType: OSType; grafPtr_: GrafPtr ): OSStatus; external name '_HRNewReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRNewReferenceInWindow()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use this API from  a Carbon App. All the contrrols created by the
 *    HTML renderer will be embedded in the root control of the window
 *    specified by the window ref.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Pointer to the new reference created and returned by the
 *      renderer.
 *    
 *    rendererType:
 *      Type of the renderer e.g. kHRRendererHTML32Type. Only this type
 *      is supported for now.
 *    
 *    inWindowRef:
 *      Reference to the window for which rendering area will be
 *      specified.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRNewReferenceInWindow( var hrRef: HRReference; rendererType: OSType; inWindowRef: WindowRef ): OSStatus; external name '_HRNewReferenceInWindow';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRDisposeReference()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRDisposeReference( hrRef: HRReference ): OSStatus; external name '_HRDisposeReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRFreeMemory()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRFreeMemory( inBytesNeeded: Size ): SInt32; external name '_HRFreeMemory';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{ System level notifications }
{
 *  HRScreenConfigurationChanged()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
procedure HRScreenConfigurationChanged; external name '_HRScreenConfigurationChanged';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRIsHREvent()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRIsHREvent( const (*var*) eventRecord_: EventRecord ): Boolean; external name '_HRIsHREvent';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{ Drawing }
{
 *  HRSetGrafPtr()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRSetGrafPtr( hrRef: HRReference; grafPtr_: GrafPtr ): OSStatus; external name '_HRSetGrafPtr';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRSetWindowRef()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use this API from  a Carbon App. All the contrrols created by the
 *    HTML renderer will be moved in the root control of the window
 *    specified by the window ref. All the drawing will now happen in
 *    the specified window.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    windowRef:
 *      new Reference to the window to be attached to the above hrRef.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRSetWindowRef( hrRef: HRReference; windowRef_: WindowRef ): OSStatus; external name '_HRSetWindowRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRSetEmbeddingControl()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use this API to tell the HTML Renderer to embed all the controls
 *    it has created so far and the new controls it creates after this
 *    call to be embedded in the given control. Useful if you wish to
 *    have an HTML displayed with in your dialog. e.g. Software Update
 *    needs this.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    controlRef:
 *      all the future controls created by renderer are embeded in this
 *      controlRef.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRSetEmbeddingControl( hrRef: HRReference; controlRef_: ControlRef ): OSStatus; external name '_HRSetEmbeddingControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRActivate()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRActivate( hrRef: HRReference ): OSStatus; external name '_HRActivate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRDeactivate()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRDeactivate( hrRef: HRReference ): OSStatus; external name '_HRDeactivate';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRDraw()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRDraw( hrRef: HRReference; updateRgnH: RgnHandle ): OSStatus; external name '_HRDraw';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRDrawInPort()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use this API from  a Carbon App.  All the drawing will now happen
 *    in the specified port. This is the API you want to use to draw in
 *    an offscreen port, for example when printing. You could also use
 *    this API to draw in an on screen port.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    updateRgnH:
 *      Region to be updated.
 *    
 *    grafPtr:
 *      A graf pointer to render HTML into.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRDrawInPort( hrRef: HRReference; updateRgnH: RgnHandle; grafPtr: CGrafPtr ): OSStatus; external name '_HRDrawInPort';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRSetRenderingRect()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRSetRenderingRect( hrRef: HRReference; const (*var*) renderingRect: Rect ): OSStatus; external name '_HRSetRenderingRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGetRenderedImageSize()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRGetRenderedImageSize( hrRef: HRReference; var renderingSize: Point ): OSStatus; external name '_HRGetRenderedImageSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGetRenderedImageSize32()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use this API when the rendered image could have coordinates
 *    larger than what SInt16 can hold.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    height:
 *      Height of the image is returned in this parameter.
 *    
 *    width:
 *      Width of the image is returned in this parameter.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRGetRenderedImageSize32( hrRef: HRReference; var height: UInt32; var width: UInt32 ): OSStatus; external name '_HRGetRenderedImageSize32';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRScrollToLocation()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRScrollToLocation( hrRef: HRReference; var location: Point ): OSStatus; external name '_HRScrollToLocation';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRScrollToImageLocation32()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use this API when specifying location to scroll to. Location is
 *    specified in image space.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    h:
 *      Horizontal location.
 *    
 *    v:
 *      Vertical location.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRScrollToImageLocation32( hrRef: HRReference; h: SInt32; v: SInt32 ): OSStatus; external name '_HRScrollToImageLocation32';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRForceQuickdraw()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRForceQuickdraw( hrRef: HRReference; forceQuickdraw: Boolean ): OSStatus; external name '_HRForceQuickdraw';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


type
	HRScrollbarState = SInt16;
const
	eHRScrollbarOn = 0;
	eHRScrollbarOff = 1;
	eHRScrollbarAuto = 2;

{
 *  HRSetScrollbarState()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRSetScrollbarState( hrRef: HRReference; hScrollbarState: HRScrollbarState; vScrollbarState: HRScrollbarState ): OSStatus; external name '_HRSetScrollbarState';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRSetDrawBorder()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRSetDrawBorder( hrRef: HRReference; drawBorder: Boolean ): OSStatus; external name '_HRSetDrawBorder';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRSetGrowboxCutout()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRSetGrowboxCutout( hrRef: HRReference; allowCutout: Boolean ): OSStatus; external name '_HRSetGrowboxCutout';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{ Navigation }
{
 *  HRGoToFile()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRGoToFile( hrRef: HRReference; const (*var*) fsspec_: FSSpec; addToHistory: Boolean; forceRefresh: Boolean ): OSStatus; external name '_HRGoToFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGoToURL()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRGoToURL( hrRef: HRReference; url: ConstCStringPtr; addToHistory: Boolean; forceRefresh: Boolean ): OSStatus; external name '_HRGoToURL';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGoToAnchor()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRGoToAnchor( hrRef: HRReference; anchorName: ConstCStringPtr ): OSStatus; external name '_HRGoToAnchor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGoToPtr()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRGoToPtr( hrRef: HRReference; buffer: CStringPtr; bufferSize: UInt32; addToHistory: Boolean; forceRefresh: Boolean ): OSStatus; external name '_HRGoToPtr';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGoToFSRef()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use these API from  a Carbon App instead of using HRGoToFile,
 *    HRGoToURL, HRGoToAnchor and HRGoToPtr. These APIs are same in
 *    behavior with their old counter parts. The only difference is
 *    that they take FSRef, CFURLRef, CFString, and CFData as
 *    parameters.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    fref:
 *      Reference to HTML file that is be opened and rendered.
 *    
 *    addToHistory:
 *      true if this file URL should be added to history.
 *    
 *    forceRefresh:
 *      true if the rendering area should be refreshed.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRGoToFSRef( hrRef: HRReference; const (*var*) fref: FSRef; addToHistory: Boolean; forceRefresh: Boolean ): OSStatus; external name '_HRGoToFSRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGoToCFURL()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use these API from  a Carbon App instead of using HRGoToFile,
 *    HRGoToURL, HRGoToAnchor and HRGoToPtr. These APIs are same in
 *    behavior with their old counter parts. The only difference is
 *    that they take FSRef, CFURLRef, CFString, and CFData as
 *    parameters.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    url:
 *      Reference to url that is be rendered.
 *    
 *    addToHistory:
 *      true if this URL should be added to history.
 *    
 *    forceRefresh:
 *      true if the rendering area should be refreshed.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRGoToCFURL( hrRef: HRReference; url: CFURLRef; addToHistory: Boolean; forceRefresh: Boolean ): OSStatus; external name '_HRGoToCFURL';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGoToAnchorCFString()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use these API from  a Carbon App instead of using HRGoToFile,
 *    HRGoToURL, HRGoToAnchor and HRGoToPtr. These APIs are same in
 *    behavior with their old counter parts. The only difference is
 *    that they take FSRef, CFURLRef, CFString, and CFData as
 *    parameters.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    anchorName:
 *      Name of the anchor to be displayed.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRGoToAnchorCFString( hrRef: HRReference; anchorName: CFStringRef ): OSStatus; external name '_HRGoToAnchorCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGoToData()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use these API from  a Carbon App instead of using HRGoToFile,
 *    HRGoToURL, HRGoToAnchor and HRGoToPtr. These APIs are same in
 *    behavior with their old counter parts. The only difference is
 *    that they take FSRef, CFURLRef, CFString, and CFData as
 *    parameters.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    data:
 *      Reference to data in the memory that is be rendered.
 *    
 *    addToHistory:
 *      true if this file URL should be added to history.
 *    
 *    forceRefresh:
 *      true if the rendering area should be refreshed.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRGoToData( hrRef: HRReference; data: CFDataRef; addToHistory: Boolean; forceRefresh: Boolean ): OSStatus; external name '_HRGoToData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{ Accessors }
{ either file url or url of <base> tag }
{
 *  HRGetRootURL()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRGetRootURL( hrRef: HRReference; rootURLH: Handle ): OSStatus; external name '_HRGetRootURL';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{ url of <base> tag }
{
 *  HRGetBaseURL()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRGetBaseURL( hrRef: HRReference; baseURLH: Handle ): OSStatus; external name '_HRGetBaseURL';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{ file url }
{
 *  HRGetHTMLURL()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRGetHTMLURL( hrRef: HRReference; HTMLURLH: Handle ): OSStatus; external name '_HRGetHTMLURL';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGetTitle()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRGetTitle( hrRef: HRReference; title: StringPtr ): OSStatus; external name '_HRGetTitle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGetHTMLFile()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRGetHTMLFile( hrRef: HRReference; var fsspec_: FSSpec ): OSStatus; external name '_HRGetHTMLFile';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGetRootURLAsCFString()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use these API from  a Carbon App instead of using HRGetRootURL,
 *    HRGetBaseURL, HRGetHTMLURL, HRGetTitle and HRGetHTMLFile. These
 *    APIs are same in behavior with their old counter parts. The only
 *    difference is that they take CFString, CFURLRef, and FSRef as
 *    parameters.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    rootString:
 *      Get CFString equivalent for the root url.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRGetRootURLAsCFString( hrRef: HRReference; var rootString: CFStringRef ): OSStatus; external name '_HRGetRootURLAsCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGetBaseURLAsCFString()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use these API from  a Carbon App instead of using HRGetRootURL,
 *    HRGetBaseURL, HRGetHTMLURL, HRGetTitle and HRGetHTMLFile. These
 *    APIs are same in behavior with their old counter parts. The only
 *    difference is that they take CFString, CFURLRef, and FSRef as
 *    parameters.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    baseString:
 *      Get CFString equivalent for the base url.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRGetBaseURLAsCFString( hrRef: HRReference; var baseString: CFStringRef ): OSStatus; external name '_HRGetBaseURLAsCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGetHTMLURLAsCFURL()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use these API from  a Carbon App instead of using HRGetRootURL,
 *    HRGetBaseURL, HRGetHTMLURL, HRGetTitle and HRGetHTMLFile. These
 *    APIs are same in behavior with their old counter parts. The only
 *    difference is that they take CFString, CFURLRef, and FSRef as
 *    parameters.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    theURL:
 *      Get currently displayed HTML as a CFURL.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRGetHTMLURLAsCFURL( hrRef: HRReference; var theURL: CFURLRef ): OSStatus; external name '_HRGetHTMLURLAsCFURL';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGetTitleAsCFString()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use these API from  a Carbon App instead of using HRGetRootURL,
 *    HRGetBaseURL, HRGetHTMLURL, HRGetTitle and HRGetHTMLFile. These
 *    APIs are same in behavior with their old counter parts. The only
 *    difference is that they take CFString, CFURLRef, and FSRef as
 *    parameters.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    title:
 *      Get title of the currently displayed HTML as a CFString.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRGetTitleAsCFString( hrRef: HRReference; var title: CFStringRef ): OSStatus; external name '_HRGetTitleAsCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRGetHTMLFileAsFSRef()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use these API from  a Carbon App instead of using HRGetRootURL,
 *    HRGetBaseURL, HRGetHTMLURL, HRGetTitle and HRGetHTMLFile. These
 *    APIs are same in behavior with their old counter parts. The only
 *    difference is that they take CFString, CFURLRef, and FSRef as
 *    parameters.
 *  
 *  Parameters:
 *    
 *    hrRef:
 *      Reference to the renderer object.
 *    
 *    fref:
 *      Get currently displayed HTML as a FSRef.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRGetHTMLFileAsFSRef( hrRef: HRReference; var fref: FSRef ): OSStatus; external name '_HRGetHTMLFileAsFSRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{ Utilities }
{
 *  HRUtilCreateFullURL()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRUtilCreateFullURL( rootURL: ConstCStringPtr; linkURL: ConstCStringPtr; fullURLH: Handle ): OSStatus; external name '_HRUtilCreateFullURL';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRUtilGetFSSpecFromURL()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRUtilGetFSSpecFromURL( rootURL: ConstCStringPtr; linkURL: ConstCStringPtr; var destSpec: FSSpec ): OSStatus; external name '_HRUtilGetFSSpecFromURL';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{ urlHandle should be valid on input }
{
 *  HRUtilGetURLFromFSSpec()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
function HRUtilGetURLFromFSSpec( const (*var*) fsspec_: FSSpec; urlHandle: Handle ): OSStatus; external name '_HRUtilGetURLFromFSSpec';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRUtilCreateFullCFURL()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use these API from  a Carbon App instead of using
 *    HRUtilCreateFullURL, HRUtilGetFSSpecFromURL,
 *    HRUtilGetURLFromFSSpec. These APIs are same in behavior with
 *    their old counter parts. The only difference is that they take
 *    CFURLRef, and FSRef as parameters.
 *  
 *  Parameters:
 *    
 *    rootString:
 *      a CFString for the root.
 *    
 *    linkString:
 *      a CFString for a partial link.
 *    
 *    url:
 *      Fully qualified URL is returned after attaching a link string
 *      to the root.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRUtilCreateFullCFURL( rootString: CFStringRef; linkString: CFStringRef; var url: CFURLRef ): OSStatus; external name '_HRUtilCreateFullCFURL';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRUtilGetFSRefFromURL()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use these API from  a Carbon App instead of using
 *    HRUtilCreateFullURL, HRUtilGetFSSpecFromURL,
 *    HRUtilGetURLFromFSSpec. These APIs are same in behavior with
 *    their old counter parts. The only difference is that they take
 *    CFURLRef, and FSRef as parameters.
 *  
 *  Parameters:
 *    
 *    rootString:
 *      a CFString for the root.
 *    
 *    linkString:
 *      a CFString for a partial link.
 *    
 *    destRef:
 *      File reference is returned for the complete path created after
 *      attaching link string to the root. If File does not exist,
 *      fnfErr is returned as a function result.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRUtilGetFSRefFromURL( rootString: CFStringRef; linkString: CFStringRef; var destRef: FSRef ): OSStatus; external name '_HRUtilGetFSRefFromURL';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRUtilGetURLFromFSRef()   *** DEPRECATED ***
 *  
 *  Discussion:
 *    Use these API from  a Carbon App instead of using
 *    HRUtilCreateFullURL, HRUtilGetFSSpecFromURL,
 *    HRUtilGetURLFromFSSpec. These APIs are same in behavior with
 *    their old counter parts. The only difference is that they take
 *    CFURLRef, and FSRef as parameters.
 *  
 *  Parameters:
 *    
 *    fileRef:
 *      Refernce to a file whose URL is desired.
 *    
 *    url:
 *      a fully qualified URL is returned in this parameter. The
 *      returned URL gives the path of the file specified in the above
 *      parameter.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function HRUtilGetURLFromFSRef( const (*var*) fileRef: FSRef; var url: CFURLRef ): OSStatus; external name '_HRUtilGetURLFromFSRef';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
    Visited links

    If you register a function here, it will be called to determine
    whether or not the given URL has been visited. It should return
    true if the URL has been visited.
    
    In addition to the URLs that the application may add to the list
    of visited links, it should also add URLs that the user clicks
    on. These URLs can be caught by the "add URL to history" callback
    below.
 }
type
	HRWasURLVisitedProcPtr = function( url: ConstCStringPtr; refCon: UnivPtr ): Boolean;
	HRWasURLVisitedUPP = HRWasURLVisitedProcPtr;
{
 *  HRRegisterWasURLVisitedUPP()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
procedure HRRegisterWasURLVisitedUPP( inWasURLVisitedUPP: HRWasURLVisitedUPP; hrRef: HRReference; inRefCon: UnivPtr ); external name '_HRRegisterWasURLVisitedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRUnregisterWasURLVisitedUPP()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
procedure HRUnregisterWasURLVisitedUPP( hrRef: HRReference ); external name '_HRUnregisterWasURLVisitedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
    Use these API from  a Carbon App instead of using HRRegisterWasURLVisitedUPP, HRUnregisterWasURLVisitedUPP. 
    These APIs are same in behavior with their old counter parts. The only difference is that they take 
    CFURLRef as parameters.
        
}
type
	HRWasCFURLVisitedProcPtr = function( url: CFURLRef; refCon: UnivPtr ): Boolean;
	HRWasCFURLVisitedUPP = HRWasCFURLVisitedProcPtr;
{
 *  HRRegisterWasCFURLVisitedUPP()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
procedure HRRegisterWasCFURLVisitedUPP( inWasCFURLVisitedUPP: HRWasCFURLVisitedUPP; hrRef: HRReference; inRefCon: UnivPtr ); external name '_HRRegisterWasCFURLVisitedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRUnregisterWasCFURLVisitedUPP()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
procedure HRUnregisterWasCFURLVisitedUPP( hrRef: HRReference ); external name '_HRUnregisterWasCFURLVisitedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
    New URL

    If you register a function here, it will be called every time
    the renderer is going to display a new URL. A few examples of how
    you might use this include...
    
        (a) maintaining a history of URLs
        (b) maintainging a list of visited links
        (c) setting a window title based on the new URL
}
type
	HRNewURLProcPtr = function( url: ConstCStringPtr; targetFrame: ConstCStringPtr; addToHistory: Boolean; refCon: UnivPtr ): OSStatus;
	HRNewURLUPP = HRNewURLProcPtr;
{
 *  HRRegisterNewURLUPP()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
procedure HRRegisterNewURLUPP( inNewURLUPP: HRNewURLUPP; hrRef: HRReference; inRefCon: UnivPtr ); external name '_HRRegisterNewURLUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRUnregisterNewURLUPP()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
procedure HRUnregisterNewURLUPP( hrRef: HRReference ); external name '_HRUnregisterNewURLUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{ 
    Use these API from  a Carbon App instead of using HRRegisterNewURLUPP, HRUnregisterNewURLUPP. 
    These APIs are same in behavior with their old counter parts. The only difference is that they take 
    CFURLRef as parameters.
}
type
	HRNewCFURLProcPtr = function( url: CFURLRef; targetString: CFStringRef; addToHistory: Boolean; refCon: UnivPtr ): OSStatus;
	HRNewCFURLUPP = HRNewCFURLProcPtr;
{
 *  HRRegisterNewCFURLUPP()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
procedure HRRegisterNewCFURLUPP( inURLUPP: HRNewCFURLUPP; hrRef: HRReference; inRefCon: UnivPtr ); external name '_HRRegisterNewCFURLUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRUnregisterNewCFURLUPP()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
procedure HRUnregisterNewCFURLUPP( hrRef: HRReference ); external name '_HRUnregisterNewCFURLUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
    URL to FSSpec function

    If you register a function here, it will be called every time
    the renderer is going to locate a file. The function will be
    passed an enum indicating the type of file being asked for.
 }
type
	URLSourceType = UInt16;
const
	kHRLookingForHTMLSource = 1;
	kHRLookingForImage = 2;
	kHRLookingForEmbedded = 3;
	kHRLookingForImageMap = 4;
	kHRLookingForFrame = 5;

type
	HRURLToFSSpecProcPtr = function( rootURL: ConstCStringPtr; linkURL: ConstCStringPtr; var fsspec_: FSSpec; urlSourceType_: URLSourceType; refCon: UnivPtr ): OSStatus;
	HRURLToFSSpecUPP = HRURLToFSSpecProcPtr;
{
 *  HRRegisterURLToFSSpecUPP()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
procedure HRRegisterURLToFSSpecUPP( inURLToFSSpecUPP: HRURLToFSSpecUPP; hrRef: HRReference; inRefCon: UnivPtr ); external name '_HRRegisterURLToFSSpecUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRUnregisterURLToFSSpecUPP()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in HTMLRenderingLib 1.0 and later
 }
procedure HRUnregisterURLToFSSpecUPP( hrRef: HRReference ); external name '_HRUnregisterURLToFSSpecUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{ 
    Use these API from  a Carbon App instead of using HRRegisterURLToFSSpecUPP, HRUnregisterURLToFSSpecUPP. 
    These APIs are same in behavior with their old counter parts. The only difference is that they take 
    FSRef as parameters.
}
type
	HRURLToFSRefProcPtr = function( rootString: CFStringRef; linkString: CFStringRef; var fref: FSRef; urlSourceType_: URLSourceType; refCon: UnivPtr ): OSStatus;
	HRURLToFSRefUPP = HRURLToFSRefProcPtr;
{
 *  HRRegisterURLToFSRefUPP()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
procedure HRRegisterURLToFSRefUPP( inURLToFSRefUPP: HRURLToFSRefUPP; hrRef: HRReference; inRefCon: UnivPtr ); external name '_HRRegisterURLToFSRefUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  HRUnregisterURLToFSRefUPP()   *** DEPRECATED ***
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
procedure HRUnregisterURLToFSRefUPP( hrRef: HRReference ); external name '_HRUnregisterURLToFSRefUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{
 *  NewHRWasURLVisitedUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewHRWasURLVisitedUPP( userRoutine: HRWasURLVisitedProcPtr ): HRWasURLVisitedUPP; external name '_NewHRWasURLVisitedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  NewHRWasCFURLVisitedUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function NewHRWasCFURLVisitedUPP( userRoutine: HRWasCFURLVisitedProcPtr ): HRWasCFURLVisitedUPP; external name '_NewHRWasCFURLVisitedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  NewHRNewURLUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewHRNewURLUPP( userRoutine: HRNewURLProcPtr ): HRNewURLUPP; external name '_NewHRNewURLUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  NewHRNewCFURLUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function NewHRNewCFURLUPP( userRoutine: HRNewCFURLProcPtr ): HRNewCFURLUPP; external name '_NewHRNewCFURLUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  NewHRURLToFSSpecUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewHRURLToFSSpecUPP( userRoutine: HRURLToFSSpecProcPtr ): HRURLToFSSpecUPP; external name '_NewHRURLToFSSpecUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  NewHRURLToFSRefUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function NewHRURLToFSRefUPP( userRoutine: HRURLToFSRefProcPtr ): HRURLToFSRefUPP; external name '_NewHRURLToFSRefUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  DisposeHRWasURLVisitedUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeHRWasURLVisitedUPP( userUPP: HRWasURLVisitedUPP ); external name '_DisposeHRWasURLVisitedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  DisposeHRWasCFURLVisitedUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
procedure DisposeHRWasCFURLVisitedUPP( userUPP: HRWasCFURLVisitedUPP ); external name '_DisposeHRWasCFURLVisitedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  DisposeHRNewURLUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeHRNewURLUPP( userUPP: HRNewURLUPP ); external name '_DisposeHRNewURLUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  DisposeHRNewCFURLUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
procedure DisposeHRNewCFURLUPP( userUPP: HRNewCFURLUPP ); external name '_DisposeHRNewCFURLUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  DisposeHRURLToFSSpecUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeHRURLToFSSpecUPP( userUPP: HRURLToFSSpecUPP ); external name '_DisposeHRURLToFSSpecUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  DisposeHRURLToFSRefUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
procedure DisposeHRURLToFSRefUPP( userUPP: HRURLToFSRefUPP ); external name '_DisposeHRURLToFSRefUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  InvokeHRWasURLVisitedUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeHRWasURLVisitedUPP( url: ConstCStringPtr; refCon: UnivPtr; userUPP: HRWasURLVisitedUPP ): Boolean; external name '_InvokeHRWasURLVisitedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  InvokeHRWasCFURLVisitedUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function InvokeHRWasCFURLVisitedUPP( url: CFURLRef; refCon: UnivPtr; userUPP: HRWasCFURLVisitedUPP ): Boolean; external name '_InvokeHRWasCFURLVisitedUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  InvokeHRNewURLUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeHRNewURLUPP( url: ConstCStringPtr; targetFrame: ConstCStringPtr; addToHistory: Boolean; refCon: UnivPtr; userUPP: HRNewURLUPP ): OSStatus; external name '_InvokeHRNewURLUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  InvokeHRNewCFURLUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function InvokeHRNewCFURLUPP( url: CFURLRef; targetString: CFStringRef; addToHistory: Boolean; refCon: UnivPtr; userUPP: HRNewCFURLUPP ): OSStatus; external name '_InvokeHRNewCFURLUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  InvokeHRURLToFSSpecUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeHRURLToFSSpecUPP( rootURL: ConstCStringPtr; linkURL: ConstCStringPtr; var fsspec_: FSSpec; urlSourceType_: URLSourceType; refCon: UnivPtr; userUPP: HRURLToFSSpecUPP ): OSStatus; external name '_InvokeHRURLToFSSpecUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{
 *  InvokeHRURLToFSRefUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.3 and later
 *    Non-Carbon CFM:   not available
 }
function InvokeHRURLToFSRefUPP( rootString: CFStringRef; linkString: CFStringRef; var fref: FSRef; urlSourceType_: URLSourceType; refCon: UnivPtr; userUPP: HRURLToFSRefUPP ): OSStatus; external name '_InvokeHRURLToFSRefUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)

{$endc} {TARGET_OS_MAC}
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
