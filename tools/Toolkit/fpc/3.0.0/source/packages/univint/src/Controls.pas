{
     File:       HIToolbox/Controls.h
 
     Contains:   Control Manager interfaces
 
     Version:    HIToolbox-624~3
 
     Copyright:  � 1985-2008 by Apple Computer, Inc., all rights reserved
 
     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:
 
                     http://www.freepascal.org/bugs.html
 
}
{       Pascal Translation Updated:  Peter N Lewis, <peter@stairways.com.au>, August 2005 }
{       Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
{       Pascal Translation Updated:  Gorazd Krosl, <gorazd_1957@yahoo.ca>, October 2009 }
{       Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2012 }
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

unit Controls;
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
uses MacTypes,Appearance,Collections,Drag,Events,Files,IconsCore,Icons,Menus,QuickdrawTypes,CFBase,CGImage,HIObject;
{$endc} {not MACOSALLINCLUDE}


{$ifc TARGET_OS_MAC}

{$ALIGN MAC68K}

{������������������������������������������������������������������������������������������������������}
{  � Resource Types                                                                                    }
{������������������������������������������������������������������������������������������������������}
const
	kControlDefProcType = FourCharCode('CDEF');
	kControlTemplateResourceType = FourCharCode('CNTL');
	kControlColorTableResourceType = FourCharCode('cctb');
	kControlDefProcResourceType = FourCharCode('CDEF');

{������������������������������������������������������������������������������������������������������}
{  � Format of a �CNTL� resource                                                                       }
{������������������������������������������������������������������������������������������������������}
type
	ControlTemplate = record
		controlRect: Rect;
		controlValue: SInt16;
		controlVisible: Boolean;
		fill: UInt8;
		controlMaximum: SInt16;
		controlMinimum: SInt16;
		controlDefProcID: SInt16;
		controlReference: SInt32;
		controlTitle: Str255;
	end;
	ControlTemplatePtr = ^ControlTemplate;
type
	ControlTemplateHandle = ^ControlTemplatePtr;


type
	ControlPartCode = SInt16;
	ControlPartCodePtr = ^ControlPartCode; { when a var xx:ControlPartCode parameter can be nil, it is changed to xx: ControlPartCodePtr }
{������������������������������������������������������������������������������������������������������}
{ � Control ActionProcPtr                                                                              }
{������������������������������������������������������������������������������������������������������}
type
	ControlActionProcPtr = procedure( theControl: ControlRef; partCode: ControlPartCode );
type
	ControlActionUPP = ControlActionProcPtr;

{������������������������������������������������������������������������������������������������������}
{ � Control ActionProcPtr : Epilogue                                                                   }
{������������������������������������������������������������������������������������������������������}
{
 *  NewControlActionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewControlActionUPP( userRoutine: ControlActionProcPtr ): ControlActionUPP; external name '_NewControlActionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeControlActionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeControlActionUPP( userUPP: ControlActionUPP ); external name '_DisposeControlActionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeControlActionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure InvokeControlActionUPP( theControl: ControlRef; partCode: ControlPartCode; userUPP: ControlActionUPP ); external name '_InvokeControlActionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{������������������������������������������������������������������������������������������������������}
{  � Control Color Table                                                                               }
{������������������������������������������������������������������������������������������������������}
const
	cFrameColor = 0;
	cBodyColor = 1;
	cTextColor = 2;
	cThumbColor = 3;
	kNumberCtlCTabEntries = 4;

type
	CtlCTabPtr = ^CtlCTab;
	CtlCTab = record
		ccSeed: SInt32;
		ccRider: SInt16;
		ctSize: SInt16;
		ctTable: array [0..3] of ColorSpec;
	end;
type
	CCTabPtr = CtlCTabPtr;
type
	CCTabHandle = ^CCTabPtr;

{��������������������������������������������������������������������������������������}
{  � Control Variants                                                                  }
{��������������������������������������������������������������������������������������}
type
	ControlVariant = SInt16;
const
	kControlNoVariant = 0;    { No variant}
	kControlUsesOwningWindowsFontVariant = 1 shl 3; { Control uses owning windows font to display text}


{��������������������������������������������������������������������������������������}
{  � Control Part Codes                                                                }
{��������������������������������������������������������������������������������������}
{ Basic part codes }
const
	kControlNoPart = kAppearancePartMetaNone;
	kControlIndicatorPart = kAppearancePartIndicator;
	kControlDisabledPart = kAppearancePartMetaDisabled;
	kControlInactivePart = kAppearancePartMetaInactive;

{ Use this constant in Get/SetControlData when the data referred to is not         }
{ specific to a part, but rather the entire control, e.g. the list handle of a     }
{ list box control.                                                                }
const
	kControlEntireControl = kControlNoPart;


{
 *  Control meta-parts
 *  
 *  Discussion:
 *    If you haven't guessed from looking at other toolbox headers, we
 *    like the word 'meta'. It's cool. So here's one more for you. A
 *    meta-part is a part used in a call to the GetControlRegion API.
 *    These parts might be defined by a control, but should not be
 *    returned from calls such as TestControl, et al. They define a
 *    region of a control. 
 *    
 *    Along with these parts, you can also pass in normal part codes to
 *    get the regions of the parts. Not all controls fully support this
 *    at the time this was written.
 }
const
{
   * The entire area that the control will draw into. When a composited
   * control is drawn, the Control Manager clips the control's drawing
   * to the structure area. This area may extend beyond the bounds of
   * the control (for example, if the control draws a focus ring
   * outside of its bounds). You may return a superset of the drawn
   * area if this is computationally easier to construct. This area is
   * used to determine the area of a window that should be invalidated
   * and redrawn when a control is invalidated. It is not necessary for
   * a control to return a shape that precisely describes the structure
   * area; for example, a control whose structure is an oval may simply
   * return the oval's bounding rectangle. The default handler for the
   * kEventControlGetPartRegion event will return the control's bounds
   * when this part is requested.
   }
	kControlStructureMetaPart = -1;

  {
   * The area of the control in which embedded controls should be
   * positioned. This part is only defined for controls that can
   * contain other controls (for example, the group box). This area is
   * largely informational and is not used by the Control Manager
   * itself. The default handler for the kEventControlGetPartRegion
   * event will return errInvalidPartCode when this part is requested.
   }
	kControlContentMetaPart = -2;

  {
   * The area of the control that, when drawn, is filled with opaque
   * pixels. You may also return a subset of the opaque area if this is
   * computationally easier to construct. If a control is contained in
   * a composited window, the Control Manager will use this area to
   * optimize drawing of other controls that intersect this area;
   * controls that are entirely contained within the opaque area, and
   * that are z-ordered underneath this control, will not be drawn at
   * all, since any drawing would be completely overwritten by this
   * control. The default handler for the kEventControlGetPartRegion
   * event will return an empty area when this part is requested. This
   * meta-part is available in Mac OS X 10.2 or later.
   }
	kControlOpaqueMetaPart = -3;

  {
   * The area of the control that causes a mouse event to be captured
   * by that control. If a mouse event falls inside the control bounds
   * but outside of this area, then the Control Manager will allow the
   * event to pass through the control to the next control behind it in
   * z-order. This area is used to determine which parts of a window
   * should allow async window dragging when clicked (the draggable
   * area is computed by subtracting the clickable areas of controls in
   * the window from the window's total area). You can also customize
   * the clickable area of a control if you want the control to have an
   * effectively transparent area (for example, a control that draws
   * multiple tabs might want clicks in the space between the tabs to
   * fall through to the next control rather than be captured by the
   * tab-drawing control). The default handler for the
   * kEventControlGetPartRegion event will return the control's bounds
   * when this part is requested. This meta-part is available in Mac OS
   * X 10.3 or later.
   }
	kControlClickableMetaPart = -4;

{ focusing part codes }
const
	kControlFocusNoPart = kControlNoPart; { tells control to clear its focus}
	kControlFocusNextPart = -1;   { tells control to focus on the next part}
	kControlFocusPrevPart = -2;    { tells control to focus on the previous part}

type
	ControlFocusPart = ControlPartCode;
{������������������������������������������������������������������������������������������������������}
{  � Control Collection Tags                                                                           }
{������������������������������������������������������������������������������������������������������}
{  These are standard tags that you will find in the initial data Collection that is passed in the     }
{  'param' parameter to the initCntl message, and in the kEventParamInitCollection parameter to the    }
{  kEventControlInitialize event (Carbon only).                                                        }
{  All tags at ID zero in a control's Collection are reserved for Control Manager use.                 }
{  Custom control definitions should use other IDs.                                                    }
{  Most of these tags are interpreted when you call CreateCustomControl; the Control Manager will put  }
{  the value in the right place before calling the control definition with the initialization message. }


{
 *  Discussion:
 *    Control Collection Tags
 }
const
{
   * Rect - the bounding rectangle.
   }
	kControlCollectionTagBounds = FourCharCode('boun');

  {
   * SInt32 - the value
   }
	kControlCollectionTagValue = FourCharCode('valu');

  {
   * SInt32 - the minimum
   }
	kControlCollectionTagMinimum = FourCharCode('min ');

  {
   * SInt32 - the maximum
   }
	kControlCollectionTagMaximum = FourCharCode('max ');

  {
   * SInt32 - the view size
   }
	kControlCollectionTagViewSize = FourCharCode('view');

  {
   * Boolean - the visible state. Only interpreted on CarbonLib
   * versions up through 1.5.x and Mac OS X versions 10.0.x. Not
   * interpreted on CarbonLib 1.6 and later. Not interpreted on Mac OS
   * 10.1 and later. We recommend you do not use this tag at all.
   }
	kControlCollectionTagVisibility = FourCharCode('visi');

  {
   * SRefCon - the refCon
   }
	kControlCollectionTagRefCon = FourCharCode('refc');

  {
   * arbitrarily sized character array - the title
   }
	kControlCollectionTagTitle = FourCharCode('titl');

  {
   * bytes as received via CFStringCreateExternalRepresentation
   }
	kControlCollectionTagUnicodeTitle = FourCharCode('uttl');

  {
   * OSType - the ControlID signature
   }
	kControlCollectionTagIDSignature = FourCharCode('idsi');

  {
   * SInt32 - the ControlID id
   }
	kControlCollectionTagIDID = FourCharCode('idid');

  {
   * UInt32 - the command
   }
	kControlCollectionTagCommand = FourCharCode('cmd ');

  {
   * SInt16 - the variant
   }
	kControlCollectionTagVarCode = FourCharCode('varc');


{������������������������������������������������������������������������������������������������������}
{  � Control Image Content                                                                             }
{������������������������������������������������������������������������������������������������������}

{
 *  Summary:
 *    Control image content types
 }
const
{
   * The control has no content other than text.
   }
	kControlContentTextOnly = 0;

  {
   * The control has no content.
   }
	kControlNoContent = 0;

  {
   * The control's content is an icon suite identified by a resource
   * ID. The resource ID of the 'icns' resource should be placed in
   * ControlImageContentInfo.u.resID .
   }
	kControlContentIconSuiteRes = 1;

  {
   * The control's content is a color icon identified by a resource ID.
   * The resource ID of the 'cicn' resource should be placed in
   * ControlImageContentInfo.u.resID .
   }
	kControlContentCIconRes = 2;

  {
   * The control's content is a picture identified by a resource ID.
   * The resource ID of the 'PICT' resource should be placed in
   * ControlImageContentInfo.u.resID .
   }
	kControlContentPictRes = 3;

  {
   * The control's content is an icon identified by a resource ID. The
   * resource ID of the 'ICON' resource should be placed in
   * ControlImageContentInfo.u.resID .
   }
	kControlContentICONRes = 4;

  {
   * The control's content is a note, caution, or stop icon identified
   * by a resource ID. The resource ID should be placed in
   * ControlImageContentInfo.u.resID. The resource ID must be one of
   * kStopIcon, kNoteIcon, or kCautionIcon. When the icon is drawn, it
   * may be modified to correspond to the current Mac OS X user
   * interface guidelines. This content type is supported on Mac OS X
   * 10.1 and later by the Icon control.
   }
	kControlContentAlertIconRes = 5;

  {
   * The control's content is an IconSuiteHandle. The icon suite handle
   * should be placed in HIViewContentInfo.u.iconSuite.
   }
	kControlContentIconSuiteHandle = 129;

  {
   * The control's content is a CIconHandle. The color icon handle
   * should be placed in HIViewContentInfo.u.cIconHandle.
   }
	kControlContentCIconHandle = 130;

  {
   * The control's content is a PicHandle. The picture handle should be
   * placed in HIViewContentInfo.u.picture.
   }
	kControlContentPictHandle = 131;

  {
   * The control's content is an IconRef. The IconRef should be placed
   * in HIViewContentInfo.u.iconRef.
   }
	kControlContentIconRef = 132;

  {
   * The control's content is a handle to a monochrome icon. The icon
   * handle should be placed in HIViewContentInfo.u.ICONHandle.
   }
	kControlContentICON = 133;

  {
   * The control's content is a CGImageRef. The CGImageRef should be
   * placed in HIViewContentInfo.u.imageRef. This content type is
   * supported on Mac OS X 10.4 and later.
   }
	kControlContentCGImageRef = 134;

type
	ControlContentType = SInt16;
type
	ControlButtonContentInfo = record
		contentType: ControlContentType;
		case SInt16 of
		0: (
			resID: SInt16;
			);
		1: (
			iconRef: IconRef_fix;
			);
		2: (
			imageRef: CGImageRef;
			);
{$ifc not TARGET_CPU_64}
		3: (
			cIconHandle: CIconHandle_fix;
			);
		4: (
			iconSuite: Handle;
			);
		5: (
			picture: PicHandle;
			);
		6: (
			ICONHandle: Handle;
			);
{$endc} {not TARGET_CPU_64}
	end;
	ControlButtonContentInfoPtr = ^ControlButtonContentInfo;
type
	ControlImageContentInfo = ControlButtonContentInfo;
	ControlImageContentInfoPtr = ControlButtonContentInfoPtr;
{������������������������������������������������������������������������������������������������������}
{  � Control Key Script Behavior                                                                       }
{������������������������������������������������������������������������������������������������������}
const
	kControlKeyScriptBehaviorAllowAnyScript = FourCharCode('any '); { leaves the current keyboard alone and allows user to change the keyboard.}
	kControlKeyScriptBehaviorPrefersRoman = FourCharCode('prmn'); { switches the keyboard to roman, but allows them to change it as desired.}
	kControlKeyScriptBehaviorRequiresRoman = FourCharCode('rrmn'); { switches the keyboard to roman and prevents the user from changing it.}

type
	ControlKeyScriptBehavior = UInt32;
{������������������������������������������������������������������������������������������������������}
{  � Control Font Style                                                                                }
{������������������������������������������������������������������������������������������������������}
{    SPECIAL FONT USAGE NOTES: You can specify the font to use for many control types.
    The constants below are meta-font numbers which you can use to set a particular
    control's font usage. There are essentially two modes you can use: 1) default,
    which is essentially the same as it always has been, i.e. it uses the system font, unless
    directed to use the window font via a control variant. 2) you can specify to use
    the big or small system font in a generic manner. The Big system font is the font
    used in menus, etc. Chicago has filled that role for some time now. Small system
    font is currently Geneva 10. The meta-font number implies the size and style.

    NOTE:       Not all font attributes are used by all controls. Most, in fact, ignore
                the fore and back color (Static Text is the only one that does, for
                backwards compatibility). Also size, face, and addFontSize are ignored
                when using the meta-font numbering.
}
{ Meta-font numbering - see note above }
const
	kControlFontBigSystemFont = -1;   { force to big system font}
	kControlFontSmallSystemFont = -2;   { force to small system font}
	kControlFontSmallBoldSystemFont = -3; { force to small bold system font}
	kControlFontViewSystemFont = -4;   { force to views system font (DataBrowser control only)}
	kControlFontMiniSystemFont = -5;    { force to mini system font}

{ Add these masks together to set the flags field of a ControlFontStyleRec }
{ They specify which fields to apply to the text. It is important to make  }
{ sure that you specify only the fields that you wish to set.              }
const
	kControlUseFontMask = $0001;
	kControlUseFaceMask = $0002;
	kControlUseSizeMask = $0004;
	kControlUseForeColorMask = $0008;
	kControlUseBackColorMask = $0010;
	kControlUseModeMask = $0020;
	kControlUseJustMask = $0040;
	kControlUseAllMask = $00FF;
	kControlAddFontSizeMask = $0100;

{ AddToMetaFont indicates that we want to start with a standard system     }
{ font, but then we'd like to add the other attributes. Normally, the meta }
{ font ignores all other flags                                             }
const
	kControlAddToMetaFontMask = $0200; { Available in Appearance 1.1 or later}

{ UseThemeFontID indicates that the font field of the ControlFontStyleRec  }
{ should be interpreted as a ThemeFontID (see Appearance.h). In all other  }
{ ways, specifying a ThemeFontID is just like using one of the control     }
{ meta-fonts IDs. kControlUseThemeFontIDMask and kControlUseFontMask are   }
{ mutually exclusive; you can only specify one of them. If you specify     }
{ both of them, the behavior is undefined.                                 }
const
	kControlUseThemeFontIDMask = $0080; { Available in Mac OS X or later}

type
	ControlFontStyleRecPtr = ^ControlFontStyleRec;
	ControlFontStyleRec = record
		flags: SInt16;
		font: SInt16;
		size: SInt16;
		style: SInt16;
		mode: SInt16;
		just: SInt16;
		foreColor: RGBColor;
		backColor: RGBColor;
	end;
type
	ControlFontStylePtr = ControlFontStyleRecPtr;
{������������������������������������������������������������������������������������������������������}
{  � Click Activation Results                                                                          }
{������������������������������������������������������������������������������������������������������}
{  These are for use with GetControlClickActivation. The enumerated values should be pretty            }
{  self-explanatory, but just in case:                                                                 }
{  � Activate/DoNotActivate indicates whether or not to change the owning window's z-ordering before   }
{      processing the click. If activation is requested, you may also want to immediately redraw the   }
{      newly exposed portion of the window.                                                            }
{  � Ignore/Handle Click indicates whether or not to call an appropriate click handling API (like      }
{      HandleControlClick) in respose to the event.                                                    }
const
	kDoNotActivateAndIgnoreClick = 0;    { probably never used. here for completeness.}
	kDoNotActivateAndHandleClick = 1;    { let the control handle the click while the window is still in the background.}
	kActivateAndIgnoreClick = 2;    { control doesn't want to respond directly to the click, but window should still be brought forward.}
	kActivateAndHandleClick = 3;     { control wants to respond to the click, but only after the window has been activated.}

type
	ClickActivationResult = UInt32;
{������������������������������������������������������������������������������������������������������}
{  � Common data tags for Get/SetControlData                                                           }
{������������������������������������������������������������������������������������������������������}

{
 *  Summary:
 *    Get/SetControlData Common Tags
 }
const
	kControlFontStyleTag = FourCharCode('font');
	kControlKeyFilterTag = FourCharCode('fltr');

  {
   * Sent with a pointer to a ControlKind record to be filled in.  Only
   * valid for GetControlData.
   }
	kControlKindTag = FourCharCode('kind');

  {
   * Sent with a pointer to a ControlSize. Only valid with explicitly
   * sizeable controls. Supported in 10.2 by the check box, combo box,
   * progress bar, indeterminate progress bar, radio button, round
   * button, scroll bar, slider and the tab. Check your return value
   * from SetControlData to determine if the control supports the size
   * that you requested. 
   * 
   * As of 10.2.5, the push button and DataBrowser accept this tag. The
   * DataBrowser only changes the size of its scrollbars. 
   * 
   * As of 10.3, the chasing arrows, disclosure button, popup button,
   * scroll view, search field and little arrows controls also accept
   * this tag. 
   * 
   * As of 10.4, if the font of the editable text has not been
   * overridden, the font size of the combo box and search field will
   * adjust to respect the size of the control. Also, if the font of a
   * static text control has not been overridden, the font size of the
   * static text control will respect the size of the control. Note,
   * however, that if the font _has_ been overridden (using
   * SetControlFontStyle), then these controls may return a control
   * size in response to GetControlData that is different from the
   * effective font size. 
   * 
   * As of 10.5, the bevel button control now supports the small
   * control size, and uses its control size to determine the size of
   * its popup menu arrow (if it has a menu associated with the
   * control). The default behavior is to use the width of the button
   * to determine whether to use a small or normal-sized arrow. This
   * behavior can be explicitly requested using kControlSizeAuto.
   * However, you may also use kControlSizeSmall and kControlSizeNormal
   * to explicitly request a small or normal-sized popup arrow.
   * 
   * 
   * Also as of 10.5, the group box now supports the normal, small, and
   * mini sizes. <BR><BR> Still check your return values!
   }
	kControlSizeTag = FourCharCode('size');

  {
   * Sent with a pointer to a ControlImageContentInfo (or
   * HIViewContentInfo) structure. Valid for both GetControlData and
   * SetControlData. All controls that support this tag will retain
   * refcountable image content when SetControlData is used to supply
   * new image content. Most controls that support this tag will not
   * retain refcountable image content when GetControlData is used to
   * retrieve image content; the exception is the tab control, which
   * does retain IconRef and CGImageRef content in response to
   * GetControlData. If you are implementing support for this tag in a
   * new view, you should retain refcountable image content when new
   * content is provided with SetControlData, but should not retain
   * refcountable image content when returning current image content in
   * response to GetControlData.
   }
	kControlContentTag = FourCharCode('cont');

  {
   * Sent with a pointer to a CTFontRef. Valid for both GetControlData
   * and SetControlData. The value of this CTFontRef must be retained
   * by the view when SetControlData is used and the view must retain
   * it when passing it back as a result of GetControlData. It is up to
   * the caller to release this value when it is no longer needed.
   }
	kControlThemeTextFontTag = FourCharCode('thft');

  {
   * Sent with a pointer to an HIThemeTextHorizontalFlush. Valid for
   * both GetControlData and SetControlData.
   }
	kControlThemeTextHorizontalFlushTag = FourCharCode('thhf');

  {
   * Sent with a pointer to an HIThemeTextVerticalFlush. Valid for both
   * GetControlData and SetControlData.
   }
	kControlThemeTextVerticalFlushTag = FourCharCode('thvf');

  {
   * Sent with a pointer to an HIThemeTextTruncation. Valid for both
   * GetControlData and SetControlData.
   }
	kControlThemeTextTruncationTag = FourCharCode('thtt');

  {
   * Sent with a pointer to an HIThemeTextInfo. Valid for
   * GetControlData. The version field of the HIThemeTextInfo must be
   * initialized to the version number of the structure that the client
   * is requesting the information for. When being requested with the
   * API HIViewGetThemeTextInfo, the version field will be initialized
   * to that which is given in the inVersion parameter.
   }
	kControlThemeTextInfoTag = FourCharCode('thti');

{������������������������������������������������������������������������������������������������������}
{  � Control Feature Bits                                                                              }
{������������������������������������������������������������������������������������������������������}

{
 *  Discussion:
 *    Control Feature Bits - Returned by GetControlFeatures 
 *    
 *    This list is similar to the list of HIView features in HIView.h.
 *    Historical note: This list is longer because some of these
 *    constants were introduced to enable the Control Manager to tell
 *    whether a CDEF supported a new CDEF message.
 }
const
	kControlSupportsGhosting = 1 shl 0;
	kControlSupportsEmbedding = 1 shl 1;
	kControlSupportsFocus = 1 shl 2;
	kControlWantsIdle = 1 shl 3;
	kControlWantsActivate = 1 shl 4;
	kControlHandlesTracking = 1 shl 5;
	kControlSupportsDataAccess = 1 shl 6;
	kControlHasSpecialBackground = 1 shl 7;
	kControlGetsFocusOnClick = 1 shl 8;
	kControlSupportsCalcBestRect = 1 shl 9;
	kControlSupportsLiveFeedback = 1 shl 10;
	kControlHasRadioBehavior = 1 shl 11; { Available in Appearance 1.0.1 or later}
	kControlSupportsDragAndDrop = 1 shl 12; { Available in Carbon}
	kControlAutoToggles = 1 shl 14; { Available in Appearance 1.1 or later}
	kControlSupportsGetRegion = 1 shl 17; { Available in Appearance 1.1 or later}
	kControlSupportsFlattening = 1 shl 19; { Available in Carbon}
	kControlSupportsSetCursor = 1 shl 20; { Available in Carbon}
	kControlSupportsContextualMenus = 1 shl 21; { Available in Carbon}
	kControlSupportsClickActivation = 1 shl 22; { Available in Carbon}
	kControlIdlesWithTimer = 1 shl 23; { Available in Carbon - this bit indicates that the control animates automatically}

  {
   * Reported by controls that expect clients to use an action proc
   * that increments its value when the up button is pressed and
   * decrement its value when the down button is pressed. (Most
   * controls, such as scroll bars and sliders, expect the opposite).
   * This allows the Control Manager to calculate the proper amount of
   * sleep time during a tracking loop. This is only respected in Mac
   * OS X 10.3 and later.
   }
	kControlInvertsUpDownValueMeaning = 1 shl 24;

{������������������������������������������������������������������������������������������������������}
{  � Control Messages                                                                                  }
{������������������������������������������������������������������������������������������������������}
{$ifc not TARGET_CPU_64}
const
	drawCntl = 0;
	testCntl = 1;
	calcCRgns = 2;
	initCntl = 3;    { Param is Collection, result is OSStatus}
	dispCntl = 4;
	posCntl = 5;
	thumbCntl = 6;
	dragCntl = 7;
	autoTrack = 8;
	calcCntlRgn = 10;
	calcThumbRgn = 11;
	drawThumbOutline = 12;
	kControlMsgDrawGhost = 13;
	kControlMsgCalcBestRect = 14;   { Calculate best fitting rectangle for control}
	kControlMsgHandleTracking = 15;
	kControlMsgFocus = 16;   { param indicates action.}
	kControlMsgKeyDown = 17;
	kControlMsgIdle = 18;
	kControlMsgGetFeatures = 19;
	kControlMsgSetData = 20;
	kControlMsgGetData = 21;
	kControlMsgActivate = 22;
	kControlMsgSetUpBackground = 23;
	kControlMsgCalcValueFromPos = 26;
	kControlMsgTestNewMsgSupport = 27;   { See if this control supports new messaging}
	kControlMsgSubValueChanged = 25;   { Available in Appearance 1.0.1 or later}
	kControlMsgSubControlAdded = 28;   { Available in Appearance 1.0.1 or later}
	kControlMsgSubControlRemoved = 29;   { Available in Appearance 1.0.1 or later}
	kControlMsgApplyTextColor = 30;   { Available in Appearance 1.1 or later}
	kControlMsgGetRegion = 31;   { Available in Appearance 1.1 or later}
	kControlMsgFlatten = 32;   { Available in Carbon. Param is Collection.}
	kControlMsgSetCursor = 33;   { Available in Carbon. Param is ControlSetCursorRec}
	kControlMsgDragEnter = 38;   { Available in Carbon. Param is DragRef, result is boolean indicating acceptibility of drag.}
	kControlMsgDragLeave = 39;   { Available in Carbon. As above.}
	kControlMsgDragWithin = 40;   { Available in Carbon. As above.}
	kControlMsgDragReceive = 41;   { Available in Carbon. Param is DragRef, result is OSStatus indicating success/failure.}
	kControlMsgDisplayDebugInfo = 46;   { Available in Carbon on X.}
	kControlMsgContextualMenuClick = 47;  { Available in Carbon. Param is ControlContextualMenuClickRec}
	kControlMsgGetClickActivation = 48;    { Available in Carbon. Param is ControlClickActivationRec}

type
	ControlDefProcMessage = SInt16;
{$endc} {not TARGET_CPU_64}

{��������������������������������������������������������������������������������������}
{  � Control Sizes                                                                     }
{��������������������������������������������������������������������������������������}

{
 *  Discussion:
 *    ControlSize values to be used in conjunction with SetControlData
 *    and the kControlSizeTag constant.
 }
const
{
   * Use the control's default drawing variant. This does not apply to
   * Scroll Bars, for which Normal is Large.
   }
	kControlSizeNormal = 0;

  {
   * Use the control's small drawing variant. Supported in 10.4 by the
   * Check Box, Combo Box, Disclosure Button, HIScrollView,
   * HISearchField, HISegmentedView, Little Arrows, Popup Button, Push
   * Button, Radio Button, Scroll Bar, Slider, Static Text, and Tab
   * controls. Supported in 10.5 by the Bevel Button and Group Box.
   }
	kControlSizeSmall = 1;

  {
   * Use the control's large drawing variant. Supported in 10.4 by the
   * Indeterminate Progress Bar, Progress Bar, Round Button, and Static
   * Text controls. Supported in 10.5 by the Chasing Arrows control.
   }
	kControlSizeLarge = 2;

  {
   * Use the control's miniature drawing variant. Supported in 10.4 by
   * the Check Box, Combo Box, Disclosure Button, HISearchField, Little
   * Arrows, Popup Button, Push Button, Radio Button, Slider, Static
   * Text, and Tabs controls. Supported in 10.5 by the Group Box
   * control.
   }
	kControlSizeMini = 3;

  {
   * Used by certain controls to support their legacy behavior of
   * drawing differently based on the control's bounds. Supported in
   * 10.4 by the Scroll Bar, Popup Button, Push Button, and Static Text
   * controls. Supported in 10.5 by the Bevel Button and Chasing Arrows
   * controls. It is preferred to explicitly use one of the available
   * control sizes.
   }
	kControlSizeAuto = $FFFF;

type
	ControlSize = UInt16;
{��������������������������������������������������������������������������������������}
{  � Constants for drawCntl message (passed in param)                                  }
{��������������������������������������������������������������������������������������}
const
	kDrawControlEntireControl = 0;
	kDrawControlIndicatorOnly = 129;

{$ifc not TARGET_CPU_64}
{��������������������������������������������������������������������������������������}
{  � Constants for dragCntl message (passed in param)                                  }
{��������������������������������������������������������������������������������������}
const
	kDragControlEntireControl = 0;
	kDragControlIndicator = 1;

{$endc} {not TARGET_CPU_64}
{��������������������������������������������������������������������������������������}
{  � Drag Constraint Structure for thumbCntl message (passed in param)                 }
{��������������������������������������������������������������������������������������}
type
	IndicatorDragConstraint = record
		limitRect: Rect;
		slopRect: Rect;
		axis: DragConstraint;
	end;
	IndicatorDragConstraintPtr = ^IndicatorDragConstraint;
{$ifc not TARGET_CPU_64}
{��������������������������������������������������������������������������������������}
{  CDEF should return as result of kControlMsgTestNewMsgSupport                        }
{��������������������������������������������������������������������������������������}
const
	kControlSupportsNewMessages = FourCharCode(' ok ');

{��������������������������������������������������������������������������������������}
{  This structure is passed into a CDEF when called with the kControlMsgHandleTracking }
{  message                                                                             }
{��������������������������������������������������������������������������������������}
type
	ControlTrackingRecPtr = ^ControlTrackingRec;
	ControlTrackingRec = record
		startPt: Point;
		modifiers: EventModifiers;
		action: ControlActionUPP;
	end;
type
	ControlTrackingPtr = ControlTrackingRecPtr;
{��������������������������������������������������������������������������������������}
{ This structure is passed into a CDEF when called with the kControlMsgKeyDown message }
{��������������������������������������������������������������������������������������}
type
	ControlKeyDownRecPtr = ^ControlKeyDownRec;
	ControlKeyDownRec = record
		modifiers: EventModifiers;
		keyCode: SInt16;
		charCode: SInt16;
	end;
type
	ControlKeyDownPtr = ControlKeyDownRecPtr;
{��������������������������������������������������������������������������������������}
{ This structure is passed into a CDEF when called with the kControlMsgGetData or      }
{ kControlMsgSetData message                                                           }
{��������������������������������������������������������������������������������������}
type
	ControlDataAccessRecPtr = ^ControlDataAccessRec;
	ControlDataAccessRec = record
		tag: ResType;
		part: ResType;
		size: Size_fix;
		dataPtr: Ptr;
	end;
type
	ControlDataAccessPtr = ControlDataAccessRecPtr;
{��������������������������������������������������������������������������������������}
{ This structure is passed into a CDEF when called with the kControlCalcBestRect msg   }
{��������������������������������������������������������������������������������������}
type
	ControlCalcSizeRecPtr = ^ControlCalcSizeRec;
	ControlCalcSizeRec = record
		height: SInt16;
		width: SInt16;
		baseLine: SInt16;
	end;
type
	ControlCalcSizePtr = ControlCalcSizeRecPtr;
{��������������������������������������������������������������������������������������}
{ This structure is passed into a CDEF when called with the kControlMsgSetUpBackground }
{ message is sent                                                                      }
{��������������������������������������������������������������������������������������}
type
	ControlBackgroundRecPtr = ^ControlBackgroundRec;
	ControlBackgroundRec = record
		depth: SInt16;
		colorDevice: Boolean;
	end;
type
	ControlBackgroundPtr = ControlBackgroundRecPtr;
{��������������������������������������������������������������������������������������}
{ This structure is passed into a CDEF when called with the kControlMsgApplyTextColor  }
{ message is sent                                                                      }
{��������������������������������������������������������������������������������������}
type
	ControlApplyTextColorRecPtr = ^ControlApplyTextColorRec;
	ControlApplyTextColorRec = record
		depth: SInt16;
		colorDevice: Boolean;
		active: Boolean;
	end;
type
	ControlApplyTextColorPtr = ControlApplyTextColorRecPtr;
{��������������������������������������������������������������������������������������}
{ This structure is passed into a CDEF when called with the kControlMsgGetRegion       }
{ message is sent                                                                      }
{��������������������������������������������������������������������������������������}
type
	ControlGetRegionRecPtr = ^ControlGetRegionRec;
	ControlGetRegionRec = record
		region: RgnHandle;
		part: ControlPartCode;
	end;
type
	ControlGetRegionPtr = ControlGetRegionRecPtr;
{��������������������������������������������������������������������������������������}
{ This structure is passed into a CDEF when the kControlMsgSetCursor message is sent   }
{ Only sent on Carbon                                                                  }
{��������������������������������������������������������������������������������������}
type
	ControlSetCursorRecPtr = ^ControlSetCursorRec;
	ControlSetCursorRec = record
		localPoint: Point;
		modifiers: EventModifiers;
		cursorWasSet: Boolean;           { your CDEF must set this to true if you set the cursor, or false otherwise}
	end;
type
	ControlSetCursorPtr = ControlSetCursorRecPtr;
{��������������������������������������������������������������������������������������}
{ This structure is passed into a CDEF when the kControlMsgContextualMenuClick message }
{ is sent                                                                              }
{ Only sent on Carbon                                                                  }
{��������������������������������������������������������������������������������������}
type
	ControlContextualMenuClickRecPtr = ^ControlContextualMenuClickRec;
	ControlContextualMenuClickRec = record
		localPoint: Point;
		menuDisplayed: Boolean;          { your CDEF must set this to true if you displayed a menu, or false otherwise}
	end;
type
	ControlContextualMenuClickPtr = ControlContextualMenuClickRecPtr;
{��������������������������������������������������������������������������������������}
{ This structure is passed into a CDEF when the kControlMsgGetClickActivation message  }
{ is sent                                                                              }
{ Only sent on Carbon                                                                  }
{��������������������������������������������������������������������������������������}
type
	ControlClickActivationRecPtr = ^ControlClickActivationRec;
	ControlClickActivationRec = record
		localPoint: Point;
		modifiers: EventModifiers;
		result: ClickActivationResult;              { your CDEF must pass the desired result back}
	end;
type
	ControlClickActivationPtr = ControlClickActivationRecPtr;
{��������������������������������������������������������������������������������������}
{  � �CDEF� entrypoint                                                                 }
{��������������������������������������������������������������������������������������}

{
 *  ControlDefProcPtr
 *  
 *  Summary:
 *    Callback function for a custom control definition.
 }
type
	ControlDefProcPtr = function( varCode: SInt16; theControl: ControlRef; message: ControlDefProcMessage; param: SInt32 ): SInt32;
type
	ControlDefUPP = ControlDefProcPtr;
{
 *  NewControlDefUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewControlDefUPP( userRoutine: ControlDefProcPtr ): ControlDefUPP; external name '_NewControlDefUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)

{
 *  DisposeControlDefUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeControlDefUPP( userUPP: ControlDefUPP ); external name '_DisposeControlDefUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)

{
 *  InvokeControlDefUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeControlDefUPP( varCode: SInt16; theControl: ControlRef; message: ControlDefProcMessage; param: SInt32; userUPP: ControlDefUPP ): SInt32; external name '_InvokeControlDefUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)

{$endc} {not TARGET_CPU_64}

{��������������������������������������������������������������������������������������}
{  Control Key Filter                                                                  }
{��������������������������������������������������������������������������������������}
{ Certain controls can have a keyfilter attached to them.                              }
{ Definition of a key filter for intercepting and possibly changing keystrokes         }
{ which are destined for a control.                                                    }
{ IMPORTANT! Because this filter provides WorldScript-encoded text in its parameters,  }
{ it provides no meaningful information for key events generated when a Unicode        }
{ keyboard layout or input method is active; these layouts and input methods generate  }
{ Unicode text that often cannot be translated into any WorldScript encoding. On       }
{ Mac OS X, you should avoid using this filter, or at most, use the filter as an       }
{ indication that the text is changing but do not depend on the charCode parameter to  }
{ the filter. Use a kEventTextInputUnicodeForKeyEvent Carbon event handler as a        }
{ replacement for the ControlKeyFilter callback; on Mac OS X 10.4 and later, you can   }
{ also use a kEventTextShouldChangeInRange or kEventTextDidChange event handler.       }
{ Key Filter Result Codes                                                          }
{ The filter proc should return one of the two constants below. If                 }
{ kKeyFilterBlockKey is returned, the key is blocked and never makes it to the     }
{ control. If kKeyFilterPassKey is returned, the control receives the keystroke.   }
const
	kControlKeyFilterBlockKey = 0;
	kControlKeyFilterPassKey = 1;

type
	ControlKeyFilterResult = SInt16;
	ControlKeyFilterProcPtr = function( theControl: ControlRef; var keyCode: SInt16; var charCode: SInt16; var modifiers: EventModifiers ): ControlKeyFilterResult;
	ControlKeyFilterUPP = ControlKeyFilterProcPtr;
{
 *  NewControlKeyFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewControlKeyFilterUPP( userRoutine: ControlKeyFilterProcPtr ): ControlKeyFilterUPP; external name '_NewControlKeyFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeControlKeyFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeControlKeyFilterUPP( userUPP: ControlKeyFilterUPP ); external name '_DisposeControlKeyFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeControlKeyFilterUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeControlKeyFilterUPP( theControl: ControlRef; var keyCode: SInt16; var charCode: SInt16; var modifiers: EventModifiers; userUPP: ControlKeyFilterUPP ): ControlKeyFilterResult; external name '_InvokeControlKeyFilterUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � DragGrayRgn Constatns                                                             }
{   For DragGrayRgnUPP used in TrackControl()                                          }
{��������������������������������������������������������������������������������������}
const
	noConstraint = kNoConstraint;
	hAxisOnly = 1;
	vAxisOnly = 2;

{��������������������������������������������������������������������������������������}
{  � Control Creation/Deletion/Persistence                                             }
{��������������������������������������������������������������������������������������}
{$ifc not TARGET_CPU_64}
const
	kControlDefProcPtr = 0;    { raw proc-ptr based access}
	kControlDefObjectClass = 1;     { event-based definition (Mac OS X only)}

type
	ControlDefType = UInt32;
type
	ControlDefSpecPtr = ^ControlDefSpec;
	ControlDefSpec = record
		defType: ControlDefType;
		case SInt16 of
		0: (
			defProc: ControlDefUPP;
			);
		1: (
			classRef: UnivPtr;
			);
	end;
{$endc} {not TARGET_CPU_64}

{$ifc not TARGET_CPU_64}
{
 *  CreateCustomControl()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    On Mac OS X 10.2 and later, register your own custom subclass of
 *    the HIView class and create an instance of your class using
 *    HIObjectCreate.
 *  
 *  Summary:
 *    Creates a control using a custom ControlDefProcPtr or
 *    ToolboxObjectClassRef.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function CreateCustomControl( owningWindow: WindowRef; const (*var*) contBounds: Rect; const (*var*) def: ControlDefSpec; initData: Collection; var outControl: ControlRef ): OSStatus; external name '_CreateCustomControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
 *  NewControl()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use one of the Create*Control APIs (CreatePushButtonControl,
 *    CreateIconControl, etc) instead.
 *  
 *  Summary:
 *    Creates a new control.
 *  
 *  Discussion:
 *    The parameters to this API are overloaded with different meanings
 *    depending on the control proc ID. See the "Settings Values for
 *    Standard Controls" section of the Mac OS 8 Control Manager
 *    reference documentation at
 *    oolbox/ControlManager/ControlMgr8Ref/ControlMgrRef.11.html#28136>
 *    for documentation on the parameter semantics for each type of
 *    control proc.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function NewControl( owningWindow: WindowRef; const (*var*) boundsRect: Rect; const (*var*) controlTitle: Str255; initiallyVisible: Boolean; initialValue: SInt16; minimumValue: SInt16; maximumValue: SInt16; procID: SInt16; controlReference: SRefCon ): ControlRef; external name '_NewControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
 *  GetNewControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function GetNewControl( resourceID: SInt16; owningWindow: WindowRef ): ControlRef; external name '_GetNewControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisposeControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure DisposeControl( theControl: ControlRef ); external name '_DisposeControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  KillControls()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure KillControls( theWindow: WindowRef ); external name '_KillControls';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Definition Registration                                                   }
{��������������������������������������������������������������������������������������}
{$endc} {not TARGET_CPU_64}

{$ifc not TARGET_CPU_64}
type
	ControlCNTLToCollectionProcPtr = function( const (*var*) bounds: Rect; value: SInt16; visible: Boolean; max: SInt16; min: SInt16; procID: SInt16; refCon: SRefCon; const (*var*) title: Str255; collection_: Collection ): OSStatus;
type
	ControlCNTLToCollectionUPP = ControlCNTLToCollectionProcPtr;
{
 *  NewControlCNTLToCollectionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewControlCNTLToCollectionUPP( userRoutine: ControlCNTLToCollectionProcPtr ): ControlCNTLToCollectionUPP; external name '_NewControlCNTLToCollectionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeControlCNTLToCollectionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeControlCNTLToCollectionUPP( userUPP: ControlCNTLToCollectionUPP ); external name '_DisposeControlCNTLToCollectionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeControlCNTLToCollectionUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeControlCNTLToCollectionUPP( const (*var*) bounds: Rect; value: SInt16; visible: Boolean; max: SInt16; min: SInt16; procID: SInt16; refCon: SRefCon; const (*var*) title: Str255; collection_: Collection; userUPP: ControlCNTLToCollectionUPP ): OSStatus; external name '_InvokeControlCNTLToCollectionUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{$endc} {not TARGET_CPU_64}

{$ifc not TARGET_CPU_64}
{
 *  RegisterControlDefinition()
 *  
 *  Summary:
 *    Associates or dissociates a control definition with a virtual
 *    CDEF resource ID.
 *  
 *  Discussion:
 *    In GetNewControl or NewControl on Carbon, the Control Manager
 *    needs to know how to map the procID to a ControlDefSpec. With
 *    RegisterControlDefinition, your application can inform the
 *    Control Manager which ControlDefSpec to call when it sees a
 *    request to use a 'CDEF' of a particular resource ID. Since custom
 *    control definitions receive their initialization data in a
 *    Collection passed in the 'param' parameter, you must also provide
 *    a procedure to convert the bounds, min, max, and other parameters
 *    to NewControl into a Collection. If you don't provide a
 *    conversion proc, your control will receive an empty collection
 *    when it is sent the initialization message. If you want the
 *    value, min, visibility, etc. to be given to the control, you must
 *    add the appropriate tagged data to the collection. See the
 *    Control Collection Tags above. If you want to unregister a
 *    ControlDefSpec that you have already registered, call
 *    RegisterControlDefinition with the same CDEF resource ID, but
 *    pass NULL for the inControlDef parameter. In this situation,
 *    inConversionProc is effectively ignored.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inCDEFResID:
 *      The virtual CDEF resource ID to which you'd like to associate
 *      or dissociate the control definition.
 *    
 *    inControlDef:
 *      A pointer to a ControlDefSpec which represents the control
 *      definition you want to register, or NULL if you are attempting
 *      to unregister a control definition.
 *    
 *    inConversionProc:
 *      The conversion proc which will translate the NewControl
 *      parameters into a Collection.
 *  
 *  Result:
 *    An OSStatus code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function RegisterControlDefinition( inCDEFResID: SInt16; const (*var*) inControlDef: ControlDefSpec; inConversionProc: ControlCNTLToCollectionUPP ): OSStatus; external name '_RegisterControlDefinition';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Visible State                                                             }
{��������������������������������������������������������������������������������������}
{
 *  HiliteControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure HiliteControl( theControl: ControlRef; hiliteState: ControlPartCode ); external name '_HiliteControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ShowControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure ShowControl( theControl: ControlRef ); external name '_ShowControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  HideControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure HideControl( theControl: ControlRef ); external name '_HideControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ following state routines available only with Appearance 1.0 and later}
{
 *  IsControlActive()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function IsControlActive( inControl: ControlRef ): Boolean; external name '_IsControlActive';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  IsControlVisible()
 *  
 *  Summary:
 *    Returns whether a control is visible.
 *  
 *  Discussion:
 *    Note that IsControlVisible returns a control's effective
 *    visibility, which is determined both by the control's own
 *    visibility and the visibility of its parent controls. If a parent
 *    control is invisible, then this control is considered to be
 *    invisible also. 
 *    
 *    Latent visibility can be determined with HIViewIsLatentlyVisible.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The control whose visibility you wish to determine.
 *  
 *  Result:
 *    A boolean value indicating whether the control is visible (true)
 *    or hidden (false).
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function IsControlVisible( inControl: ControlRef ): Boolean; external name '_IsControlVisible';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ActivateControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function ActivateControl( inControl: ControlRef ): OSErr; external name '_ActivateControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DeactivateControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function DeactivateControl( inControl: ControlRef ): OSErr; external name '_DeactivateControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControlVisibility()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function SetControlVisibility( inControl: ControlRef; inIsVisible: Boolean; inDoDraw: Boolean ): OSErr; external name '_SetControlVisibility';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ following state routines available only on Mac OS X and later}
{
 *  IsControlEnabled()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.0 and later
 *    Non-Carbon CFM:   not available
 }
function IsControlEnabled( inControl: ControlRef ): Boolean; external name '_IsControlEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  EnableControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.0 and later
 *    Non-Carbon CFM:   not available
 }
function EnableControl( inControl: ControlRef ): OSStatus; external name '_EnableControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DisableControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        not available in CarbonLib 1.x, is available on Mac OS X version 10.0 and later
 *    Non-Carbon CFM:   not available
 }
function DisableControl( inControl: ControlRef ): OSStatus; external name '_DisableControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Imaging                                                                   }
{��������������������������������������������������������������������������������������}
{
 *  DrawControls()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure DrawControls( theWindow: WindowRef ); external name '_DrawControls';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  Draw1Control()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure Draw1Control( theControl: ControlRef ); external name '_Draw1Control';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


procedure DrawOneControl( theControl: ControlRef ); external name '_Draw1Control';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  UpdateControls()
 *  
 *  Summary:
 *    Redraws the controls that intersect a specified region in a
 *    window.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The window whose controls to redraw.
 *    
 *    inUpdateRegion:
 *      The region (in local coordinates) describing which controls to
 *      redraw. In Mac OS 10.1 and later, and in CarbonLib 1.5 and
 *      later, you may pass NULL for this parameter to redraw the
 *      controls intersecting the visible region of the window.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure UpdateControls( inWindow: WindowRef; inUpdateRegion: RgnHandle { can be NULL } ); external name '_UpdateControls';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ following imaging routines available only with Appearance 1.0 and later}
{
 *  GetBestControlRect()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function GetBestControlRect( inControl: ControlRef; var outRect: Rect; var outBaseLineOffset: SInt16 ): OSErr; external name '_GetBestControlRect';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControlFontStyle()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function SetControlFontStyle( inControl: ControlRef; const (*var*) inStyle: ControlFontStyleRec ): OSErr; external name '_SetControlFontStyle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DrawControlInCurrentPort()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
procedure DrawControlInCurrentPort( inControl: ControlRef ); external name '_DrawControlInCurrentPort';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetUpControlBackground()
 *  
 *  Summary:
 *    Applies the proper background color for the given control to the
 *    current port.
 *  
 *  Discussion:
 *    An embedding-savvy control which erases before drawing must
 *    ensure that its background color properly matches the body color
 *    of any parent controls on top of which it draws. This routine
 *    asks the Control Manager to determine and apply the proper
 *    background color to the current port. If a ControlColorProc has
 *    been provided for the given control, the proc will be called to
 *    set up the background color. If no proc exists, or if the proc
 *    returns a value other than noErr, the Control Manager ascends the
 *    parent chain for the given control looking for a control which
 *    has a special background (see the kControlHasSpecialBackground
 *    feature bit). The first such parent is asked to set up the
 *    background color (see the kControlMsgSetUpBackground message). If
 *    no such parent exists, the Control Manager applies any ThemeBrush
 *    which has been associated with the owning window (see
 *    SetThemeWindowBackground). Available in Appearance 1.0 (Mac OS
 *    8), CarbonLib 1.0, Mac OS X, and later.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The ControlRef that wants to erase.
 *    
 *    inDepth:
 *      A short integer indicating the color depth of the device onto
 *      which drawing will take place.
 *    
 *    inIsColorDevice:
 *      A Boolean indicating whether the draw device is a color device.
 *  
 *  Result:
 *    An OSStatus code indicating success or failure. The most likely
 *    error is a controlHandleInvalidErr, resulting from a bad
 *    ControlRef. Any non-noErr result indicates that the color set up
 *    failed, and that the caller should probably give up its attempt
 *    to draw.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function SetUpControlBackground( inControl: ControlRef; inDepth: SInt16; inIsColorDevice: Boolean ): OSErr; external name '_SetUpControlBackground';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetUpControlTextColor()
 *  
 *  Summary:
 *    Applies the proper text color for the given control to the
 *    current port.
 *  
 *  Discussion:
 *    An embedding-savvy control which draws text must ensure that its
 *    text color properly contrasts the background on which it draws.
 *    This routine asks the Control Manager to determine and apply the
 *    proper text color to the current port. If a ControlColorProc has
 *    been provided for the given control, the proc will be called to
 *    set up the text color. If no proc exists, or if the proc returns
 *    a value other than noErr, the Control Manager ascends the parent
 *    chain for the given control looking for a control which has a
 *    special background (see the kControlHasSpecialBackground feature
 *    bit). The first such parent is asked to set up the text color
 *    (see the kControlMsgApplyTextColor message). If no such parent
 *    exists, the Control Manager chooses a text color which contrasts
 *    any ThemeBrush which has been associated with the owning window
 *    (see SetThemeWindowBackground). Available in Appearance 1.1 (Mac
 *    OS 8.5), CarbonLib 1.0, Mac OS X, and later.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The ControlRef that wants to draw text.
 *    
 *    inDepth:
 *      A short integer indicating the color depth of the device onto
 *      which drawing will take place.
 *    
 *    inIsColorDevice:
 *      A Boolean indicating whether the draw device is a color device.
 *  
 *  Result:
 *    An OSStatus code indicating success or failure. The most likely
 *    error is a controlHandleInvalidErr, resulting from a bad
 *    ControlRef. Any non-noErr result indicates that the color set up
 *    failed, and that the caller should probably give up its attempt
 *    to draw.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
function SetUpControlTextColor( inControl: ControlRef; inDepth: SInt16; inIsColorDevice: Boolean ): OSErr; external name '_SetUpControlTextColor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{$endc} {not TARGET_CPU_64}

{$ifc not TARGET_CPU_64}

{
 *  ControlColorProcPtr
 *  
 *  Discussion:
 *    Callback allowing clients to specify/override the background
 *    color and text color that a Control will use during drawing. Your
 *    procedure should make the color changes to the current port. See
 *    SetControlColorProc, SetUpControlBackground, and
 *    SetUpControlTextColor for more information. Available on Mac OS
 *    8.5, CarbonLib 1.1, Mac OS X, and later.
 *  
 *  Parameters:
 *    
 *    inControl:
 *      A reference to the control for whom your proc is setting up
 *      colors.
 *    
 *    inMessage:
 *      A ControlDefProcMessage indicating what sort of color your
 *      procedure should set up. It will be either
 *      kControlMsgApplyTextColor or kControlMsgSetUpBackground.
 *      kControlMsgApplyTextColor is a request to set up the
 *      appropriate text color (by setting the current port's
 *      foreground color, pen information, etc.).
 *      kControlMsgSetUpBackground is a request to set up the
 *      appropriate background color (the current port's background
 *      color, pattern, etc.).
 *    
 *    inDrawDepth:
 *      A short integer indicating the bit depth of the device into
 *      which the Control is drawing. The bit depth is typically passed
 *      in as a result of someone someone trying to draw properly
 *      across multiple monitors with different bit depths. If your
 *      procedure wants to handle proper color set up based on bit
 *      depth, it should use this parameter to help decide what color
 *      to apply.
 *    
 *    inDrawInColor:
 *      A Boolean indicating whether or not the device that the Control
 *      is drawing into is a color device. The value is typically
 *      passed in as a result of someone trying to draw properly across
 *      multiple monitors which may or may not be color devices. If
 *      your procedure wants to handle proper color set up for both
 *      color and grayscale devices, it should use this parameter to
 *      help decide what color to apply.
 *  
 *  Result:
 *    An OSStatus code indicating success or failure. Returning noErr
 *    is an indication that your proc completely handled the color set
 *    up. If you return any other value, the Control Manager will fall
 *    back to the normal color set up mechanism.
 }
type
	ControlColorProcPtr = function( inControl: ControlRef; inMessage: SInt16; inDrawDepth: SInt16; inDrawInColor: Boolean ): OSStatus;
type
	ControlColorUPP = ControlColorProcPtr;
{
 *  NewControlColorUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function NewControlColorUPP( userRoutine: ControlColorProcPtr ): ControlColorUPP; external name '_NewControlColorUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  DisposeControlColorUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
procedure DisposeControlColorUPP( userUPP: ControlColorUPP ); external name '_DisposeControlColorUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{
 *  InvokeControlColorUPP()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   available as macro/inline
 }
function InvokeControlColorUPP( inControl: ControlRef; inMessage: SInt16; inDrawDepth: SInt16; inDrawInColor: Boolean; userUPP: ControlColorUPP ): OSStatus; external name '_InvokeControlColorUPP';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{$endc} {not TARGET_CPU_64}

{$ifc not TARGET_CPU_64}
{
 *  SetControlColorProc()
 *  
 *  Summary:
 *    Associates a ControlColorUPP with a given Control, thereby
 *    allowing you to bypass the embedding hierarchy-based color setup
 *    of SetUpControlBackground/SetUpControlTextColor and replace it
 *    with your own.
 *  
 *  Discussion:
 *    Before an embedded Control can erase, it calls
 *    SetUpControlBackground to have its background color set up by any
 *    parent controls. Similarly, any Control which draws text calls
 *    SetUpControlTextColor to have the appropriate text color set up.
 *    This allows certain controls (such as Tabs and Placards) to offer
 *    special backgrounds and text colors for any child controls. By
 *    default, the SetUp routines only move up the Control Manager
 *    embedding hierarchy looking for a parent which has a special
 *    background. This is fine in a plain vanilla embedding case, but
 *    many application frameworks find it troublesome; if there are
 *    interesting views between two Controls in the embedding
 *    hierarchy, the framework needs to be in charge of the background
 *    and text colors, otherwise drawing defects will occur. You can
 *    only associate a single color proc with a given ControlRef.
 *    Available on Mac OS 8.5, CarbonLib 1.1, Mac OS X, and later.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The ControlRef with whom the color proc should be associated.
 *    
 *    inProc:
 *      The color proc to associate with the ControlRef. If you pass
 *      NULL, the ControlRef will be dissociated from any previously
 *      installed color proc.
 *  
 *  Result:
 *    An OSStatus code indicating success or failure. The most likely
 *    error is a controlHandleInvalidErr resulting from a bad
 *    ControlRef.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
function SetControlColorProc( inControl: ControlRef; inProc: ControlColorUPP ): OSStatus; external name '_SetControlColorProc';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Mousing                                                                   }
{��������������������������������������������������������������������������������������}
{
    NOTE ON CONTROL ACTION PROCS

    When using the TrackControl() call when tracking an indicator, the actionProc parameter
    (type ControlActionUPP) should be replaced by a parameter of type DragGrayRgnUPP
    (see Quickdraw.h).

    If, however, you are using the live feedback variants of scroll bars or sliders, you
    must pass a ControlActionUPP in when tracking the indicator as well. This functionality
    is available in Appearance 1.0 or later.
}
{
 *  TrackControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function TrackControl( theControl: ControlRef; startPoint: Point; actionProc: ControlActionUPP { can be NULL } ): ControlPartCode; external name '_TrackControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  DragControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure DragControl( theControl: ControlRef; startPoint: Point; const (*var*) limitRect: Rect; const (*var*) slopRect: Rect; axis: DragConstraint ); external name '_DragControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  TestControl()
 *  
 *  Summary:
 *    Determines the control part that is at a given point.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    theControl:
 *      The control to test.
 *    
 *    testPoint:
 *      The location to test. For a non-compositing control, this
 *      location should be in port-local coordinates; for a compositing
 *      control, this location should be in view-local coordinates.
 *  
 *  Result:
 *    The control part code that was at the specified location.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function TestControl( theControl: ControlRef; testPoint: Point ): ControlPartCode; external name '_TestControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  FindControl()
 *  
 *  Summary:
 *    Finds the control in a window that is at a given point.
 *  
 *  Discussion:
 *    FindControl does not work properly in compositing windows prior
 *    to Mac OS X 10.4. In earlier releases of Mac OS X, it will return
 *    the correct control, but the part code parameter will be invalid
 *    (usually kControlNoPart). 
 *    
 *    In Mac OS X 10.2 and later, we recommend using
 *    HIViewGetViewForMouseEvent or HIViewGetSubviewHit instead of
 *    FindControl.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    testPoint:
 *      The point to test. The point should be given in port-local
 *      coordinates for the specified window.
 *    
 *    theWindow:
 *      The window whose controls to test.
 *    
 *    theControl:
 *      On exit, contains the control that was at the specified
 *      location.
 *  
 *  Result:
 *    The control part code that was at the specified location.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function FindControl( testPoint: Point; theWindow: WindowRef; var theControl: ControlRef ): ControlPartCode; external name '_FindControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ The following mousing routines available only with Appearance 1.0 and later  }
{ HandleControlClick is preferable to TrackControl when running under          }
{ Appearance 1.0 as you can pass in modifiers, which some of the new controls  }
{ use, such as edit text and list boxes.                                       }
{ NOTE: Passing NULL for the outPart parameter of FindControlUnderMouse is only}
{       supported in systems later than 10.1.x                                 }
{
 *  FindControlUnderMouse()
 *  
 *  Summary:
 *    Finds the control in a window that is at a given point.
 *  
 *  Discussion:
 *    FindControlUnderMouse does not work properly in compositing
 *    windows prior to Mac OS X 10.4. In earlier releases of Mac OS X,
 *    it will return the correct control, but the part code parameter
 *    will be invalid (usually kControlNoPart). 
 *    
 *    In Mac OS X 10.2 and later, we recommend using
 *    HIViewGetViewForMouseEvent or HIViewGetSubviewHit instead of
 *    FindControlUnderMouse.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWhere:
 *      The point to test. The point should be given in port-local
 *      coordinates for the specified window.
 *    
 *    inWindow:
 *      The window whose controls to test.
 *    
 *    outPart:
 *      On exit, contains the control part code that was at the
 *      specified location. You may pass NULL for this parameter if you
 *      don't need this information.
 *  
 *  Result:
 *    The control that was at the specified location.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function FindControlUnderMouse( inWhere: Point; inWindow: WindowRef; outPart: ControlPartCodePtr { can be NULL } ): ControlRef; external name '_FindControlUnderMouse';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  HandleControlClick()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function HandleControlClick( inControl: ControlRef; inWhere: Point; inModifiers: EventModifiers; inAction: ControlActionUPP { can be NULL } ): ControlPartCode; external name '_HandleControlClick';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Contextual Menu support in the Control Manager is only available on Carbon.  }
{ If the control didn't display a contextual menu (possibly because the point  }
{ was in a non-interesting part), the menuDisplayed output parameter will be   }
{ false. If the control did display a menu, menuDisplayed will be true.        }
{ This in on Carbon only                                                       }
{
 *  HandleControlContextualMenuClick()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 9.0 and later
 }
function HandleControlContextualMenuClick( inControl: ControlRef; inWhere: Point; var menuDisplayed: Boolean ): OSStatus; external name '_HandleControlContextualMenuClick';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Some complex controls (like Data Browser) require proper sequencing of       }
{ window activation and click processing. In some cases, the control might     }
{ want the window to be left inactive yet still handle the click, or vice-     }
{ versa. The GetControlClickActivation routine lets a control client ask the   }
{ control how it wishes to behave for a particular click.                      }
{ This in on Carbon only.                                                      }
{
 *  GetControlClickActivation()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 9.0 and later
 }
function GetControlClickActivation( inControl: ControlRef; inWhere: Point; inModifiers: EventModifiers; var outResult: ClickActivationResult ): OSStatus; external name '_GetControlClickActivation';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Events (available only with Appearance 1.0 and later)                     }
{��������������������������������������������������������������������������������������}
{
 *  HandleControlKey()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    This API only works for a limited set of controls in Mac OS X. No
 *    HIView-based controls except for the Clock and UserPane controls
 *    support this API. The EditText, ListBox, and ScrollingTextBox
 *    controls are not HIView-based and do still support this API. For
 *    HIView-based controls, you should send a
 *    kEventTextInputUnicodeForKeyEvent event to a control if you need
 *    to feed it keyboard input.
 *  
 *  Summary:
 *    Sends WorldScript-encoded keyboard input to a control using
 *    kControlMsgKeyDown.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The control to receive the keyboard input.
 *    
 *    inKeyCode:
 *      The virtual keycode to send.
 *    
 *    inCharCode:
 *      The character code to send. This character should use the
 *      current keyboard text encoding.
 *    
 *    inModifiers:
 *      The keyboard modifiers to send.
 *  
 *  Result:
 *    The part code that was modified by keyboard event processing.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function HandleControlKey( inControl: ControlRef; inKeyCode: SInt16; inCharCode: SInt16; inModifiers: EventModifiers ): ControlPartCode; external name '_HandleControlKey';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{��������������������������������������������������������������������������������������}
{ � Control Mouse Tracking (available with Carbon)                                     }
{��������������������������������������������������������������������������������������}
{ The HandleControlSetCursor routine requests that a given control set the cursor to   }
{ something appropriate based on the mouse location.                                   }
{ If the control didn't want to set the cursor (because the point was in a             }
{ non-interesting part), the cursorWasSet output parameter will be false. If the       }
{ control did set the cursor, cursorWasSet will be true.                               }
{ Carbon only.                                                                         }
{
 *  HandleControlSetCursor()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 9.0 and later
 }
function HandleControlSetCursor( control: ControlRef; localPoint: Point; modifiers: EventModifiers; var cursorWasSet: Boolean ): OSStatus; external name '_HandleControlSetCursor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Positioning                                                               }
{��������������������������������������������������������������������������������������}
{
 *  MoveControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure MoveControl( theControl: ControlRef; h: SInt16; v: SInt16 ); external name '_MoveControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SizeControl()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure SizeControl( theControl: ControlRef; w: SInt16; h: SInt16 ); external name '_SizeControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Title                                                                     }
{��������������������������������������������������������������������������������������}
{
 *  SetControlTitle()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use HIViewSetText or SetControlTitleWithCFString instead of
 *    SetControlTitle.
 *  
 *  Summary:
 *    Sets the title of a control to a Pascal string.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure SetControlTitle( theControl: ControlRef; const (*var*) title: Str255 ); external name '_SetControlTitle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
 *  GetControlTitle()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Use HIViewCopyText or CopyControlTitleAsCFString instead of
 *    GetControlTitle.
 *  
 *  Summary:
 *    Retrieves the title of a control as a Pascal string.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.5
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure GetControlTitle( theControl: ControlRef; var title: Str255 ); external name '_GetControlTitle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_5 *)


{
 *  SetControlTitleWithCFString()
 *  
 *  Summary:
 *    Sets the title of a control to the text contained in a CFString.
 *  
 *  Discussion:
 *    The Control Manager will either make its own copy or just
 *    increment the refcount of the CFString before returning from
 *    SetControlTitleWithCFString, depending on whether the string is
 *    mutable or immutable. If the string is mutable, modifying the
 *    string after calling SetControlTitleWithCFString will have no
 *    effect on the control's actual title. The caller may release the
 *    string after calling SetControlTitleWithCFString. 
 *    
 *    Note that setting the title of some controls (such as the
 *    StaticText and EditText controls) does not affect the text that
 *    is displayed by the control. These controls only read their title
 *    text at creation, and changes to the title text after creation
 *    are ignored. To set the text that is displayed by such a control,
 *    use HIViewSetText, or SetControlData with
 *    kControlStatic/EditTextTextTag.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The control whose title to set.
 *    
 *    inString:
 *      The string containing the new control title text.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   not available
 }
function SetControlTitleWithCFString( inControl: ControlRef; inString: CFStringRef ): OSStatus; external name '_SetControlTitleWithCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CopyControlTitleAsCFString()
 *  
 *  Summary:
 *    Returns a CFString containing the title of a control.
 *  
 *  Discussion:
 *    Note that retrieving the title of some controls (such as the
 *    StaticText and EditText controls) does not retrieve the text that
 *    is displayed by the control. These controls store the displayed
 *    text in a location that is separate from the title. To retrieve
 *    the text that is displayed by such a control, use HIViewCopyText,
 *    or SetControlData with kControlStatic/EditTextTextTag.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The control whose title to return.
 *    
 *    outString:
 *      On exit, a CFString containing the control's title. This string
 *      must be released by the caller.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   not available
 }
function CopyControlTitleAsCFString( inControl: ControlRef; var outString: CFStringRef ): OSStatus; external name '_CopyControlTitleAsCFString';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Value                                                                     }
{��������������������������������������������������������������������������������������}
{
 *  GetControlValue()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function GetControlValue( theControl: ControlRef ): SInt16; external name '_GetControlValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControlValue()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure SetControlValue( theControl: ControlRef; newValue: SInt16 ); external name '_SetControlValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlMinimum()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function GetControlMinimum( theControl: ControlRef ): SInt16; external name '_GetControlMinimum';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControlMinimum()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure SetControlMinimum( theControl: ControlRef; newMinimum: SInt16 ); external name '_SetControlMinimum';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlMaximum()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function GetControlMaximum( theControl: ControlRef ): SInt16; external name '_GetControlMaximum';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControlMaximum()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure SetControlMaximum( theControl: ControlRef; newMaximum: SInt16 ); external name '_SetControlMaximum';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ proportional scrolling/32-bit value support is new with Appearance 1.1}

{
 *  GetControlViewSize()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
function GetControlViewSize( theControl: ControlRef ): SInt32; external name '_GetControlViewSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControlViewSize()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
procedure SetControlViewSize( theControl: ControlRef; newViewSize: SInt32 ); external name '_SetControlViewSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControl32BitValue()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
function GetControl32BitValue( theControl: ControlRef ): SInt32; external name '_GetControl32BitValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControl32BitValue()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
procedure SetControl32BitValue( theControl: ControlRef; newValue: SInt32 ); external name '_SetControl32BitValue';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControl32BitMaximum()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
function GetControl32BitMaximum( theControl: ControlRef ): SInt32; external name '_GetControl32BitMaximum';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControl32BitMaximum()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
procedure SetControl32BitMaximum( theControl: ControlRef; newMaximum: SInt32 ); external name '_SetControl32BitMaximum';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControl32BitMinimum()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
function GetControl32BitMinimum( theControl: ControlRef ): SInt32; external name '_GetControl32BitMinimum';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControl32BitMinimum()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
procedure SetControl32BitMinimum( theControl: ControlRef; newMinimum: SInt32 ); external name '_SetControl32BitMinimum';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
    IsValidControlHandle will tell you if the handle you pass in belongs to a control
    the Control Manager knows about. It does not sanity check the data in the control.
}

{
 *  IsValidControlHandle()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
function IsValidControlHandle( theControl: ControlRef ): Boolean; external name '_IsValidControlHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{ � Control IDs                                                                        }
{ Carbon only.                                                                         }
{��������������������������������������������������������������������������������������}
{$endc} {not TARGET_CPU_64}

{
 *  ControlID
 *  
 *  Summary:
 *    A unique identifier for a control in a window.
 }
type
	ControlIDPtr = ^ControlID;
	ControlID = record
{
   * A four-character signature. When assigning a control ID to your
   * own controls, you should typically use your application signature
   * here, or some other signature with an uppercase character. Apple
   * reserves signatures that contain only lowercase characters.
   }
		signature: OSType;

  {
   * A integer identifying the control. This value should be unique for
   * a given control across all controls in the same window with the
   * same signature.
   }
		id: SInt32;
	end;
{$ifc not TARGET_CPU_64}
{
 *  SetControlID()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function SetControlID( inControl: ControlRef; const (*var*) inID: ControlID ): OSStatus; external name '_SetControlID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlID()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function GetControlID( inControl: ControlRef; var outID: ControlID ): OSStatus; external name '_GetControlID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlByID()
 *  
 *  Discussion:
 *    Find a control in a window by its unique ID. 
 *    
 *    HIView Notes: As of Mac OS X 10.3, this call is replaced by
 *    HIViewFindByID. That call lets you start your search at any point
 *    in the hierarchy, as the first parameter is a view and not a
 *    window. Either will work, but the HIView API is preferred.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The window to search.
 *    
 *    inID:
 *      The ID to search for.
 *    
 *    outControl:
 *      The control that was found, or NULL if no control in the window
 *      had the ID specified.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function GetControlByID( inWindow: WindowRef; const (*var*) inID: ControlID; var outControl: ControlRef ): OSStatus; external name '_GetControlByID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{ � Control Command IDs                                                                    }
{ Carbon only.                                                                         }
{��������������������������������������������������������������������������������������}
{
 *  SetControlCommandID()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   not available
 }
function SetControlCommandID( inControl: ControlRef; inCommandID: UInt32 ): OSStatus; external name '_SetControlCommandID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlCommandID()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.1 and later
 *    Non-Carbon CFM:   not available
 }
function GetControlCommandID( inControl: ControlRef; var outCommandID: UInt32 ): OSStatus; external name '_GetControlCommandID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{ � Control Identification                                                             }
{ Carbon only.                                                                         }
{��������������������������������������������������������������������������������������}
{$endc} {not TARGET_CPU_64}

type
	ControlKindPtr = ^ControlKind;
	ControlKind = record
		signature: OSType;
		kind: OSType;
	end;

{
 *  Discussion:
 *    Control signature kind
 }
const
{
   * Signature of all system controls.
   }
	kControlKindSignatureApple = FourCharCode('appl');

{$ifc not TARGET_CPU_64}
{
 *  GetControlKind()
 *  
 *  Summary:
 *    Returns the kind of the given control.
 *  
 *  Discussion:
 *    GetControlKind allows you to query the kind of any control.
 *    
 *    
 *    HIView Note: With the advent of HIView, you can just as easily
 *    use HIObjectCopyClassID to determine what kind of control you are
 *    looking at. The class ID is only truly deterministic for
 *    HIToolbox-supplied controls as of Mac OS X 10.3 or later due to
 *    the fact that the class IDs underwent naming changes between Mac
 *    OS X 10.2 and Mac OS X 10.3.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The ControlRef to find the kind of.
 *    
 *    outControlKind:
 *      On successful exit, this will contain the control signature and
 *      kind. See ControlDefinitions.h for the kinds of each system
 *      control.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.5 and later
 *    Non-Carbon CFM:   not available
 }
function GetControlKind( inControl: ControlRef; var outControlKind: ControlKind ): OSStatus; external name '_GetControlKind';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{ � Properties                                                                         }
{��������������������������������������������������������������������������������������}
{$endc} {not TARGET_CPU_64}

const
	kControlPropertyPersistent = $00000001; { whether this property gets saved when flattening the control}

{$ifc not TARGET_CPU_64}
{
 *  GetControlProperty()
 *  
 *  Discussion:
 *    Obtains a piece of data that has been previously associated with
 *    a control.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    control:
 *      A ControlRef to the control whose associated data you wish to
 *      obtain.
 *    
 *    propertyCreator:
 *      An OSType signature, usually the signature of your application.
 *      Do not use all lower case signatures, as these are reserved for
 *      use by Apple.
 *    
 *    propertyTag:
 *      An OSType signature, application-defined, identifying the
 *      property.
 *    
 *    bufferSize:
 *      A value specifying the size of the data to be retrieved. If the
 *      size of the data is unknown, use the function
 *      GetControlPropertySize to get the data�s size. If the size
 *      specified in the bufferSize parameter does not match the actual
 *      size of the property, GetControlProperty only retrieves data up
 *      to the size specified or up to the actual size of the property,
 *      whichever is smaller, and an error is returned.
 *    
 *    actualSize:
 *      On output, the actual size of the property data. Pass NULL if
 *      you don't want this information.
 *    
 *    propertyBuffer:
 *      On input, a pointer to a buffer. This buffer must be big enough
 *      to fit bufferSize bytes of data. On return, this buffer
 *      contains a copy of the data that is associated with the
 *      specified control.
 *  
 *  Result:
 *    A result code indicating success or failure. Most common return
 *    values are: noErr, paramErr, controlHandleInvalidErr,
 *    controlPropertyInvalid and controlPropertyNotFoundErr.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
function GetControlProperty( control: ControlRef; propertyCreator: OSType; propertyTag: OSType; bufferSize: ByteCount; actualSize: ByteCountPtr { can be NULL }; propertyBuffer: UnivPtr ): OSStatus; external name '_GetControlProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlPropertySize()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
function GetControlPropertySize( control: ControlRef; propertyCreator: OSType; propertyTag: OSType; var size: ByteCount ): OSStatus; external name '_GetControlPropertySize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControlProperty()
 *  
 *  Discussion:
 *    Obtains a piece of data that has been previously associated with
 *    a control.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    control:
 *      A ControlRef to the control whose associated data you wish to
 *      obtain.
 *    
 *    propertyCreator:
 *      An OSType signature, usually the signature of your application.
 *      Do not use all lower case signatures, as these are reserved for
 *      use by Apple.
 *    
 *    propertyTag:
 *      An OSType signature, application-defined, identifying the
 *      property.
 *    
 *    propertySize:
 *      A value specifying the size of the data.
 *    
 *    propertyData:
 *      On input, a pointer to data of any type. Pass a pointer to a
 *      buffer containing the data to be associated; this buffer should
 *      be at least as large as the value specified in the propertySize
 *      parameter.
 *    
 *    propertyBuffer:
 *      On input, a pointer to a buffer. This buffer must be big enough
 *      to fit bufferSize bytes of data. On return, this buffer
 *      contains a copy of the data that is associated with the
 *      specified control.
 *  
 *  Result:
 *    A result code indicating success or failure. Most common return
 *    values are: noErr, paramErr, controlHandleInvalidErr and
 *    controlPropertyInvalid
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
function SetControlProperty( control: ControlRef; propertyCreator: OSType; propertyTag: OSType; propertySize: ByteCount; propertyData: {const} UnivPtr ): OSStatus; external name '_SetControlProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  RemoveControlProperty()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
function RemoveControlProperty( control: ControlRef; propertyCreator: OSType; propertyTag: OSType ): OSStatus; external name '_RemoveControlProperty';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlPropertyAttributes()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function GetControlPropertyAttributes( control: ControlRef; propertyCreator: OSType; propertyTag: OSType; var attributes: OptionBits ): OSStatus; external name '_GetControlPropertyAttributes';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ChangeControlPropertyAttributes()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   not available
 }
function ChangeControlPropertyAttributes( control: ControlRef; propertyCreator: OSType; propertyTag: OSType; attributesToSet: OptionBits; attributesToClear: OptionBits ): OSStatus; external name '_ChangeControlPropertyAttributes';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Regions (Appearance 1.1 or later)                                         }
{  See the discussion on meta-parts in this header for more information                }
{��������������������������������������������������������������������������������������}
{
 *  GetControlRegion()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 8.5 and later
 }
function GetControlRegion( inControl: ControlRef; inPart: ControlPartCode; outRegion: RgnHandle ): OSStatus; external name '_GetControlRegion';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Variant                                                                   }
{��������������������������������������������������������������������������������������}
{
 *  GetControlVariant()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function GetControlVariant( theControl: ControlRef ): ControlVariant; external name '_GetControlVariant';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Action                                                                    }
{��������������������������������������������������������������������������������������}
{
 *  SetControlAction()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure SetControlAction( theControl: ControlRef; actionProc: ControlActionUPP ); external name '_SetControlAction';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlAction()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function GetControlAction( theControl: ControlRef ): ControlActionUPP; external name '_GetControlAction';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{ � Control Accessors                                                                  }
{��������������������������������������������������������������������������������������}
{
 *  SetControlReference()
 *  
 *  Summary:
 *    This is somewhat of a legacy API. The Set/GetControlProperty API
 *    is a better mechanism to associate data with a control.
 *  
 *  Discussion:
 *    When you create a control, you specify an initial reference
 *    value, either in the control resource or in the refCon parameter
 *    of the function NewControl. You can use the function
 *    GetControlReference to obtain the current value. You can use this
 *    value for any purpose.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    theControl:
 *      A ControlRef to the control whose reference value you wish to
 *      change.
 *    
 *    data:
 *      The new reference value for the control.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
procedure SetControlReference( theControl: ControlRef; data: SRefCon ); external name '_SetControlReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlReference()
 *  
 *  Summary:
 *    This is somewhat of a legacy API. The Set/GetControlProperty API
 *    is a better mechanism to associate data with a control.
 *  
 *  Discussion:
 *    When you create a control, you specify an initial reference
 *    value, either in the control resource or in the refCon parameter
 *    of the function NewControl. You can use this reference value for
 *    any purpose, and you can use the function SetControlReference to
 *    change this value.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    theControl:
 *      A ControlRef to the control whose reference value you wish to
 *      retrieve.
 *  
 *  Result:
 *    The current reference value for the specified control.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 7.1 and later
 }
function GetControlReference( theControl: ControlRef ): SRefCon; external name '_GetControlReference';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Hierarchy (Appearance 1.0 and later only)                                 }
{��������������������������������������������������������������������������������������}
{
 *  SendControlMessage()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function SendControlMessage( inControl: ControlRef; inMessage: SInt16; inParam: UnivPtr ): SInt32; external name '_SendControlMessage';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CreateRootControl()
 *  
 *  Discussion:
 *    Creates a new 'root control' for a window. This root is actually
 *    the content area of a window, and spans all of Quickdraw space.
 *    
 *    
 *    HIView Notes: In a composited window, this routine will return
 *    errRootAlreadyExists. Technically, you cannot create a root
 *    control in such a window. Instead you would embed views into the
 *    content view of the window. GetRootControl will return the
 *    content view in that situation as well.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The window for which to create a root control.
 *    
 *    outControl:
 *      On exit, contains the window's root control. In Mac OS 10.1 and
 *      CarbonLib 1.5 and later, this parameter may be NULL if you
 *      don't need the ControlRef.
 *  
 *  Result:
 *    A result code indicating success or failure. errRootAlreadyExists
 *    is returned if the window already has a root control.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function CreateRootControl( inWindow: WindowRef; outControl: ControlRefPtr { can be NULL } ): OSErr; external name '_CreateRootControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetRootControl()
 *  
 *  Discussion:
 *    Returns the 'root control' for a given window. If no root exists
 *    for the window, errNoRootControl is returned. This root control
 *    represents the content area of the window, and spans all of
 *    Quickdraw space. 
 *    
 *    HIView Notes: With the advent of HIView, this API and concept are
 *    considered deprecated. The root of the window in a composited
 *    window is actually the structure view, and all views (window
 *    widgets, content view, etc.) are subviews of that top-level view.
 *    It can be fetched with HIViewGetRoot. In a composited window,
 *    calling GetRootControl will return the content view, not the true
 *    root to maintain compatibility with past usage of GetRootControl.
 *    We recommend using HIViewFindByID with the kHIViewWindowContentID
 *    control ID to fetch the content view instead of using this call.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The window to query.
 *    
 *    outControl:
 *      The root control, on output.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function GetRootControl( inWindow: WindowRef; var outControl: ControlRef ): OSErr; external name '_GetRootControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  EmbedControl()
 *  
 *  Discussion:
 *    Adds a subcontrol to the given parent. 
 *    
 *    HIView Note: This is replaced by HIViewAddSubview in Mac OS X
 *    10.2 and beyond. You can call either function in a composited or
 *    non-composited window, but the HIView variant is preferred.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The subcontrol being added.
 *    
 *    inContainer:
 *      The control which will receive the new subcontrol.
 *  
 *  Result:
 *    An operating system result code. 
 *    errNeedsCompositedWindow will be returned when you try to embed
 *    into the content view in a non-compositing window; you can only
 *    embed into the content view in compositing windows.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function EmbedControl( inControl: ControlRef; inContainer: ControlRef ): OSErr; external name '_EmbedControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AutoEmbedControl()
 *  
 *  Discussion:
 *    Based on the bounds of the given control, embed it in the window
 *    specified. It basically finds the deepest parent the control
 *    would fit into and embeds it there. This was invented primarily
 *    for the Dialog Manager so that hierarchies could be generated
 *    from the flattened DITL list. 
 *    
 *    HIView Note: Do NOT call this API in a composited window, its
 *    results will be unpredictable as the coordinate systems are very
 *    different.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The subcontrol being added.
 *    
 *    inWindow:
 *      The window which will receive the new subcontrol.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function AutoEmbedControl( inControl: ControlRef; inWindow: WindowRef ): OSErr; external name '_AutoEmbedControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetSuperControl()
 *  
 *  Discussion:
 *    Returns the parent control of the given one. 
 *    
 *    HIView Note: HIViewGetSuperview is the preferred API as of Mac OS
 *    X 10.2. Either call will work in a composited or non- composited
 *    window.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The control to query.
 *    
 *    outParent:
 *      The parent control.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function GetSuperControl( inControl: ControlRef; var outParent: ControlRef ): OSErr; external name '_GetSuperControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  CountSubControls()
 *  
 *  Discussion:
 *    Returns the number of children a given control has. This count
 *    can then be used for calls to GetIndexedSubControl. 
 *    
 *    HIView Note: As of Mac OS X 10.2, the preferred way to walk the
 *    control hierarchy is to use HIViewGetFirstSubView followed by
 *    repeated calls to HIViewGetNextView until NULL is returned.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The control to query.
 *    
 *    outNumChildren:
 *      A pointer to a UInt16 to receive the number of children
 *      controls.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function CountSubControls( inControl: ControlRef; var outNumChildren: UInt16 ): OSErr; external name '_CountSubControls';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetIndexedSubControl()
 *  
 *  Discussion:
 *    Returns the child control at a given index in the list of
 *    subcontrols for the specified parent. 
 *    
 *    HIView Note: As of Mac OS X 10.2, the preferred way to walk the
 *    control hierarchy is to use HIViewGetFirstSubView followed by
 *    repeated calls to HIViewGetNextView until NULL is returned.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The parent control to query.
 *    
 *    inIndex:
 *      The index of the subcontrol to fetch.
 *    
 *    outSubControl:
 *      A pointer to a control reference to receive the subcontrol. If
 *      the index is out of range, the contents of this parameter are
 *      undefined after the call.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function GetIndexedSubControl( inControl: ControlRef; inIndex: UInt16; var outSubControl: ControlRef ): OSErr; external name '_GetIndexedSubControl';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControlSupervisor()
 *  
 *  Discussion:
 *    Allow one view to intercept clicks for another. When something
 *    like FindControl or the like is called on the target, it will
 *    instead return the supervisor. This is largely deprecated these
 *    days. 
 *    
 *    HIView Note: As of Mac OS X 10.2, you can intercept subview
 *    clicks by overriding the kEventControlInterceptSubviewClick event
 *    (see CarbonEvents.h).
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The control to intercept clicks for.
 *    
 *    inBoss:
 *      The new supervisor control (can be NULL).
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function SetControlSupervisor( inControl: ControlRef; inBoss: ControlRef { can be NULL } ): OSErr; external name '_SetControlSupervisor';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Keyboard Focus (available only with Appearance 1.0 and later)                     }
{��������������������������������������������������������������������������������������}
{
 *  GetKeyboardFocus()
 *  
 *  Discussion:
 *    Passes back the currently focused control within the given window.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The window to get the focus of.
 *    
 *    outControl:
 *      On output, this will contain the ControlRef that is currently
 *      focused in the given window. If there is no currently focused
 *      control, outControl will contain NULL.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function GetKeyboardFocus( inWindow: WindowRef; var outControl: ControlRef ): OSErr; external name '_GetKeyboardFocus';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetKeyboardFocus()
 *  
 *  Discussion:
 *    Focuses the given part of the given control in a particular
 *    window. If another control is currently focused in the window,
 *    focus will be removed from the other control before focus is
 *    given to the desired control. SetKeyboardFocus respects the full
 *    keyboard navigation mode.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The window which contains the control you want to focus. If the
 *      window does not contain the control, an error will be returned.
 *    
 *    inControl:
 *      The control you want to focus.
 *    
 *    inPart:
 *      The part of the control you wish to focus. You may pass
 *      kControlFocusNoPart to clear the focus in the given control.
 *      You may pass kControlFocusNextPart or kControlFocusPrevPart to
 *      move the focus within the given control.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function SetKeyboardFocus( inWindow: WindowRef; inControl: ControlRef; inPart: ControlFocusPart ): OSErr; external name '_SetKeyboardFocus';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  AdvanceKeyboardFocus()
 *  
 *  Discussion:
 *    Advances the focus to the next most appropriate control. Unless
 *    overridden in some fashion (either by overriding certain carbon
 *    events or using the HIViewSetNextFocus API), the Toolbox will use
 *    a spacially determinant method of focusing, attempting to focus
 *    left to right, top to bottom in a window, taking groups of
 *    controls into account. AdvanceKeyboardFocus does not respect the
 *    full keyboard navigation mode. It will only advance the focus
 *    between traditionally focusable controls. If you want to advance
 *    the focus in a way that respects the full keyboard navigation
 *    mode, use the HIViewAdvanceFocus API. AdvanceKeyboardFocus does
 *    not work for windows in compositing mode. For compositing
 *    windows, you must call HIViewAdvanceFocus instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The window to advance the focus in.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function AdvanceKeyboardFocus( inWindow: WindowRef ): OSErr; external name '_AdvanceKeyboardFocus';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ReverseKeyboardFocus()
 *  
 *  Discussion:
 *    Reverses the focus to the next most appropriate control. Unless
 *    overridden in some fashion (either by overriding certain carbon
 *    events or using the HIViewSetNextFocus API), the Toolbox will use
 *    a spacially determinant method of focusing, attempting to focus
 *    left to right, top to bottom in a window, taking groups of
 *    controls into account. ReverseKeyboardFocus does not respect the
 *    full keyboard navigation mode. It will only reverse the focus
 *    between traditionally focusable controls. If you want to reverse
 *    the focus in a way that respects the full keyboard navigation
 *    mode, use the HIViewAdvanceFocus API. ReverseKeyboardFocus does
 *    not work for windows in compositing mode. For compositing
 *    windows, you must call HIViewAdvanceFocus instead.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The window to reverse the focus in.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function ReverseKeyboardFocus( inWindow: WindowRef ): OSErr; external name '_ReverseKeyboardFocus';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  ClearKeyboardFocus()
 *  
 *  Discussion:
 *    Clears focus from the currently focused control in a given
 *    window. The window will be left such that no control is focused
 *    within it.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The window that you want to clear the focus in.
 *  
 *  Result:
 *    An operating system result code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function ClearKeyboardFocus( inWindow: WindowRef ): OSErr; external name '_ClearKeyboardFocus';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Data (available only with Appearance 1.0 and later)                       }
{��������������������������������������������������������������������������������������}

{
 *  GetControlFeatures()
 *  
 *  Discussion:
 *    Returns the set of behaviors, etc. the given view supports. This
 *    set of features is immutable before Mac OS X 10.3. As of that
 *    release, the features can be changed with HIViewChangeFeatures.
 *    That API is the recommended call on Mac OS X 10.3 and later.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The control to query.
 *    
 *    outFeatures:
 *      A pointer to a 32-bit feature bitfield.
 *  
 *  Result:
 *    An operating system error code.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function GetControlFeatures( inControl: ControlRef; var outFeatures: UInt32 ): OSErr; external name '_GetControlFeatures';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControlData()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function SetControlData( inControl: ControlRef; inPart: ControlPartCode; inTagName: ResType; inSize: Size; inData: {const} UnivPtr ): OSErr; external name '_SetControlData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlData()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function GetControlData( inControl: ControlRef; inPart: ControlPartCode; inTagName: ResType; inBufferSize: Size; inBuffer: UnivPtr; outActualSize: SizePtr { can be NULL } ): OSErr; external name '_GetControlData';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlDataSize()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
function GetControlDataSize( inControl: ControlRef; inPart: ControlPartCode; inTagName: ResType; var outMaxSize: Size ): OSErr; external name '_GetControlDataSize';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{��������������������������������������������������������������������������������������}
{  � Control Drag & Drop                                                               }
{      Carbon only.                                                                    }
{��������������������������������������������������������������������������������������}
{$endc} {not TARGET_CPU_64}

{
 *  Discussion:
 *    DragTrackingMessage values for use with
 *    HandleControlDragTracking. These are deprecated in favor of the
 *    drag Carbon Events introduced in Mac OS X 10.2 via HIView.
 }
const
{
   * The drag was previously outside the control and it just now
   * entered the control.
   }
	kDragTrackingEnterControl = 2;

  {
   * The drag was previously inside the control and it is still inside
   * the control.
   }
	kDragTrackingInControl = 3;

  {
   * The drag was previously inside the control and it just now left
   * the control.
   }
	kDragTrackingLeaveControl = 4;


{$ifc not TARGET_CPU_64}
{
 *  HandleControlDragTracking()
 *  
 *  Summary:
 *    Tells a control to respond visually to a drag.
 *  
 *  Discussion:
 *    Call HandleControlDragTracking when a drag is above a control in
 *    your window and you want to give that control a chance to draw
 *    appropriately in response to the drag. Note that in order for a
 *    control to have any chance of responding to this API, you must
 *    enable the control's drag and drop support with
 *    SetControlDragTrackingEnabled. 
 *    
 *    HIView Note: The HandleControlDragTracking API should not be
 *    called in a composited window. Instead, the
 *    SetAutomaticControlDragTrackingEnabledForWindow API should be
 *    used to enable automatic control drag tracking.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The control the drag is over. Most controls won't track drags
 *      unless you enable drag tracking on it with
 *      SetControlDragTrackingEnabled.
 *    
 *    inMessage:
 *      A drag message indicating the state of the drag above the
 *      control. The meaning of the value you pass in must be relative
 *      to the control, not the whole window. For when the drag first
 *      enters the control, you should pass kDragTrackingEnterControl.
 *      While the drag stays within the control, pass
 *      kDragTrackingInControl. When the drag leaves the control, pass
 *      kDragTrackingLeaveControl.
 *    
 *    inDrag:
 *      The drag reference that is over the control.
 *    
 *    outLikesDrag:
 *      On output, this will be a boolean indicating whether the
 *      control "likes" the drag. A control "likes" the drag if the
 *      data in the drag ref can be accepted by the control. If the
 *      control does not like the drag, don't bother calling
 *      HandleControlDragReceive if the user drops the dragged object
 *      onto the control.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 9.0 and later
 }
function HandleControlDragTracking( inControl: ControlRef; inMessage: DragTrackingMessage; inDrag: DragReference; var outLikesDrag: Boolean ): OSStatus; external name '_HandleControlDragTracking';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  HandleControlDragReceive()
 *  
 *  Summary:
 *    Tells a control to accept the data in drag reference.
 *  
 *  Discussion:
 *    Call HandleControlDragReceive when the user dropped a drag on a
 *    control in your window. This gives the control the opportunity to
 *    pull any interesting data out of the drag and insert the data
 *    into itself. Note that in order for a control to have any chance
 *    of responding to this API, you must enable the control's drag and
 *    drop support with SetControlDragTrackingEnabled. 
 *    
 *    HIView Note: The HandleControlDragReceive API should not be
 *    called in a composited window. Instead, the
 *    SetAutomaticControlDragTrackingEnabledForWindow API should be
 *    used to enable automatic control drag tracking.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The control that should accept the data. Most controls won't
 *      accept drags unless you enable drag tracking on it with
 *      SetControlDragTrackingEnabled.
 *    
 *    inDrag:
 *      The drag reference that was dropped on the control.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 9.0 and later
 }
function HandleControlDragReceive( inControl: ControlRef; inDrag: DragReference ): OSStatus; external name '_HandleControlDragReceive';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControlDragTrackingEnabled()
 *  
 *  Summary:
 *    Tells a control that it should track and receive drags, including
 *    the kEventControlDrag* suite of Carbon events.
 *  
 *  Discussion:
 *    Call SetControlDragTrackingEnabled to enable a control's support
 *    for drag and drop, including receipt of the kEventControlDrag*
 *    suite of Carbon events. Controls won't receive these events or
 *    track drags unless you first turn on drag and drop support with
 *    this API. Some controls don't support drag and drop at all; these
 *    controls won't track or receive drags even if you call this API
 *    with true (but they will receive the Carbon events, so you can
 *    add your own drag handling to a control by installing your own
 *    Carbon event handlers).
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The control whose drag tracking enabled state you'd like to set.
 *    
 *    inTracks:
 *      A Boolean indicating whether you want this control to track and
 *      receive drags.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 9.0 and later
 }
function SetControlDragTrackingEnabled( inControl: ControlRef; inTracks: Boolean ): OSStatus; external name '_SetControlDragTrackingEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  IsControlDragTrackingEnabled()
 *  
 *  Summary:
 *    Tells you whether a control's drag track and receive support is
 *    enabled.
 *  
 *  Discussion:
 *    Call IsControlDragTrackingEnabled to query a whether a control's
 *    drag and drop support is enabled. Some controls don't support
 *    drag and drop at all; these controls won't track or receive drags
 *    even if you call this API and see a true output value.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inControl:
 *      The control whose drag tracking enabled state you'd like to
 *      query.
 *    
 *    outTracks:
 *      On output, this will contain a Boolean value whether the
 *      control's drag and drop support is enabled.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 9.0 and later
 }
function IsControlDragTrackingEnabled( inControl: ControlRef; var outTracks: Boolean ): OSStatus; external name '_IsControlDragTrackingEnabled';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetAutomaticControlDragTrackingEnabledForWindow()
 *  
 *  Summary:
 *    Enables or disables the Control Manager's automatic drag tracking
 *    for a given window.
 *  
 *  Discussion:
 *    Call SetAutomaticControlDragTrackingEnabledForWindow to turn on
 *    or off the Control Manager's automatic drag tracking support for
 *    a given window. If you are using a composited window or the
 *    standard event handler, you should generally always call this API
 *    if you need drag support for controls in your window. 
 *    
 *    By default, your application code is responsible for installing
 *    drag tracking and receive handlers on a newly created window. The
 *    Control Manager, however, has support for automatically tracking
 *    and receiving drags over controls. The Control Manager will
 *    detect the control the drag is over and call
 *    HandleControlDragTracking and HandleControlDragReceive
 *    appropriately. By default, this automatic support is turned off.
 *    You can turn on this support by calling
 *    SetAutomaticControlDragTrackingEnabledForWindow with true. Note
 *    that earlier versions of system software incorrectly enable this
 *    support by default; do not rely on this buggy behavior. As of Mac
 *    OS 10.1.3, Mac OS 9.2, and CarbonLib 1.4, the buggy behavior is
 *    fixed, and you must call this routine with true to enable
 *    automatic drag tracking.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The window for which you'd like to enable or disable the
 *      Control Manager's automatic drag tracking support.
 *    
 *    inTracks:
 *      A Boolean value indicating whether you want to enable the
 *      Control Manager's automatic drag tracking support.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 9.0 and later
 }
function SetAutomaticControlDragTrackingEnabledForWindow( inWindow: WindowRef; inTracks: Boolean ): OSStatus; external name '_SetAutomaticControlDragTrackingEnabledForWindow';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  IsAutomaticControlDragTrackingEnabledForWindow()
 *  
 *  Summary:
 *    Tells you whether the Control Manager's automatic drag tracking
 *    is enabled for a given window.
 *  
 *  Discussion:
 *    Call IsAutomaticControlDragTrackingEnabledForWindow to query the
 *    enabled state of the Control Manager's automatic drag tracking
 *    support for a given window. See the information on
 *    SetAutomaticControlDragTrackingEnabledForWindow for more details.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The window whose Control Manager automatic drag tracking enable
 *      state you'd like to query.
 *    
 *    outTracks:
 *      On output, this will contain a Boolean value whether the
 *      Control Manager's automatic drag tracking is enabled.
 *  
 *  Result:
 *    A result code indicating success or failure.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in ControlsLib 9.0 and later
 }
function IsAutomaticControlDragTrackingEnabledForWindow( inWindow: WindowRef; var outTracks: Boolean ): OSStatus; external name '_IsAutomaticControlDragTrackingEnabledForWindow';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)

{$endc} {not TARGET_CPU_64}

(*
#if OLDROUTINENAMES
{��������������������������������������������������������������������������������������}
{  � OLDROUTINENAMES                                                                   }
{��������������������������������������������������������������������������������������}
const
	useWFont = kControlUsesOwningWindowsFontVariant;

const
	inThumb = kControlIndicatorPart;
	kNoHiliteControlPart = kControlNoPart;
	kInIndicatorControlPart = kControlIndicatorPart;
	kReservedControlPart = kControlDisabledPart;
	kControlInactiveControlPart = kControlInactivePart;


#define SetCTitle(theControl, title) SetControlTitle(theControl, title)
#define GetCTitle(theControl, title) GetControlTitle(theControl, title)
#define UpdtControl(theWindow, updateRgn) UpdateControls(theWindow, updateRgn)
#define SetCtlValue(theControl, theValue) SetControlValue(theControl, theValue)
#define GetCtlValue(theControl) GetControlValue(theControl)
#define SetCtlMin(theControl, minValue) SetControlMinimum(theControl, minValue)
#define GetCtlMin(theControl) GetControlMinimum(theControl)
#define SetCtlMax(theControl, maxValue) SetControlMaximum(theControl, maxValue)
#define GetCtlMax(theControl) GetControlMaximum(theControl)
#define GetAuxCtl(theControl, acHndl) GetAuxiliaryControlRecord(theControl, acHndl)
#define SetCRefCon(theControl, data) SetControlReference(theControl, data)
#define GetCRefCon(theControl) GetControlReference(theControl)
#define SetCtlAction(theControl, actionProc) SetControlAction(theControl, actionProc)
#define GetCtlAction(theControl) GetControlAction(theControl)
#define SetCtlColor(theControl, newColorTable) SetControlColor(theControl, newColorTable)
#define GetCVariant(theControl) GetControlVariant(theControl)
#define getctitle(theControl, title) getcontroltitle(theControl, title)
#define setctitle(theControl, title) setcontroltitle(theControl, title)
#endif  { OLDROUTINENAMES }
*)

{ Getters }
{$ifc not TARGET_CPU_64}
{
 *  GetControlBounds()
 *  
 *  Discussion:
 *    Returns the bounds of a control, assumed to be in port
 *    coordinates. 
 *    
 *    HIView Notes: When called in a composited window, this routine
 *    returns the view's frame; i.e., it is equivalent to calling
 *    HIViewGetFrame.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    control:
 *      The control to query
 *    
 *    bounds:
 *      A pointer to a Quickdraw rectangle to be filled in by this call.
 *  
 *  Result:
 *    A pointer to the rectangle passed in bounds.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later
 }
function GetControlBounds( control: ControlRef; var bounds: Rect ): RectPtr; external name '_GetControlBounds';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  IsControlHilited()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later
 }
function IsControlHilited( control: ControlRef ): Boolean; external name '_IsControlHilited';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlHilite()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later
 }
function GetControlHilite( control: ControlRef ): UInt16; external name '_GetControlHilite';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlOwner()
 *  
 *  Discussion:
 *    Returns the window a control is bound to, or NULL if the control
 *    is not currently attached to any window. 
 *    
 *    HIView replacement: HIViewGetWindow (Mac OS X 10.3 or later).
 *    Either call will work in a composited or non-composited view.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    control:
 *      The control to query
 *  
 *  Result:
 *    A window reference, or NULL if the control is not attached to a
 *    window
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later
 }
function GetControlOwner( control: ControlRef ): WindowRef; external name '_GetControlOwner';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlDataHandle()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later
 }
function GetControlDataHandle( control: ControlRef ): Handle; external name '_GetControlDataHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  GetControlPopupMenuHandle()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later
 }
function GetControlPopupMenuHandle( control: ControlRef ): MenuRef; external name '_GetControlPopupMenuHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


function GetControlPopupMenuRef( control: ControlRef ): MenuRef; external name '_GetControlPopupMenuHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)
{
 *  GetControlPopupMenuID()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later
 }
function GetControlPopupMenuID( control: ControlRef ): SInt16; external name '_GetControlPopupMenuID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{ Setters }
{
 *  SetControlDataHandle()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later
 }
procedure SetControlDataHandle( control: ControlRef; dataHandle: Handle ); external name '_SetControlDataHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControlBounds()
 *  
 *  Discussion:
 *    Sets the bounds of a control, assumed to be in port coordinates.
 *    
 *    
 *    HIView Notes: When called in a composited window, this routine
 *    sets the view's frame, i.e. it is equivalent to calling
 *    HIViewSetFrame. The view will be invalidated as necessary in a
 *    composited window. HIViewSetFrame is the recommended call in that
 *    environment.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    control:
 *      The control to query
 *    
 *    bounds:
 *      A pointer to a Quickdraw rectangle to be used by this call.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later
 }
procedure SetControlBounds( control: ControlRef; const (*var*) bounds: Rect ); external name '_SetControlBounds';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{
 *  SetControlPopupMenuHandle()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later
 }
procedure SetControlPopupMenuHandle( control: ControlRef; popupMenu: MenuRef ); external name '_SetControlPopupMenuHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


procedure SetControlPopupMenuRef( control: ControlRef; popupMenu: MenuRef ); external name '_SetControlPopupMenuHandle';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)
{
 *  SetControlPopupMenuID()
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only]
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in CarbonAccessors.o 1.0 and later
 }
procedure SetControlPopupMenuID( control: ControlRef; menuID: SInt16 ); external name '_SetControlPopupMenuID';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER *)


{$endc} {not TARGET_CPU_64}

{--------------------------------------------------------------------------------------}
{  � DEPRECATED                                                                        }
{  All functions below this point are either deprecated (they continue to function     }
{  but are not the most modern nor most efficient solution to a problem), or they are  }
{  completely unavailable on Mac OS X.                                                 }
{--------------------------------------------------------------------------------------}

{$ifc not TARGET_CPU_64}
{
 *  IdleControls()   *** DEPRECATED ***
 *  
 *  Deprecated:
 *    Applications should remove calls to IdleControls. Custom control
 *    definitions should use Carbon event loop timers instead.
 *  
 *  Summary:
 *    Gives idle time to any controls that want the kControlMsgIdle
 *    message.
 *  
 *  Discussion:
 *    IdleControls gives idle processing time for controls that set the
 *    kControlWantsIdle feature bit. IdleControls is deprecated on Mac
 *    OS X.  System-supplied controls do not respond to IdleControls
 *    being called on Mac OS X. 
 *    
 *    Custom controls should use repeating Carbon event loop timers to
 *    perform tasks, such as animation, that previously used time given
 *    with IdleControls().  See InstallEventLoopTimer() in
 *    CarbonEventsCore.h for more information.
 *  
 *  Mac OS X threading:
 *    Not thread safe
 *  
 *  Parameters:
 *    
 *    inWindow:
 *      The WindowRef whose controls are offered idle time.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in Carbon.framework [32-bit only] but deprecated in 10.4
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in AppearanceLib 1.0 and later
 }
procedure IdleControls( inWindow: WindowRef ); external name '_IdleControls';
(* AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER_BUT_DEPRECATED_IN_MAC_OS_X_VERSION_10_4 *)


{$endc} {not TARGET_CPU_64}


{$endc} {not TARGET_OS_MAC}

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
