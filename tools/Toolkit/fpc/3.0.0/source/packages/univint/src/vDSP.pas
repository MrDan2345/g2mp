{
     File:       vecLib/vDSP.h
 
     Contains:   AltiVec DSP Interfaces
 
     Version:    vecLib-380.6
 
     Copyright:  � 2000-2012 by Apple Computer, Inc., all rights reserved.
 
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

unit vDSP;
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
uses MacTypes;
{$endc} {not MACOSALLINCLUDE}


{  For documentation on vDSP, see _vDSP Library_ at
    http://developer.apple.com/documentation/Performance/index-date.html or
    search for "vDSP Library" at http://developer.apple.com.
}

{$ALIGN POWER}


{	These symbols describe the vecLib version associated with this header.

	vDSP_Version0 is a major version number.
	vDSP_Version1 is a minor version number.
}
const
	vDSP_Version0 = 380;
const
	vDSP_Version1 = 6;


type
	vDSP_Length = UNSIGNEDLONG;
{    vDSP_Length is for numbers of elements in arrays and indices of
    elements in arrays.

    (It is also used for the base-two logarithm of numbers of elements,
    although a much smaller type is suitable for that.)
    }
type
	vDSP_Stride = SIGNEDLONG;
{    vDSP_Stride is for differences of indices of elements (which of
    course includes strides).
    }

type
	DSPComplexPtr = ^DSPComplex;
	DSPComplex = record
		real: Float32;
		imag: Float32;
	end;
type
	DSPSplitComplexPtr = ^DSPSplitComplex;
	DSPSplitComplex = record
		realp: Float32Ptr;
		imagp: Float32Ptr;
	end;
type
	DSPDoubleComplexPtr = ^DSPDoubleComplex;
	DSPDoubleComplex = record
		real: Float64;
		imag: Float64;
	end;
type
	DSPDoubleSplitComplexPtr = ^DSPDoubleSplitComplex;
	DSPDoubleSplitComplex = record
		realp: Float64Ptr;
		imagp: Float64Ptr;
	end;
type
	FFTSetup = ^OpaqueFFTSetup; { an opaque type }
	OpaqueFFTSetup = record end;
	FFTSetupD = ^OpaqueFFTSetupD; { an opaque type }
	OpaqueFFTSetupD = record end;

type
	FFTDirection = SInt32;
	FFTRadix = SInt32;
const
	kFFTDirection_Forward = 1;
	kFFTDirection_Inverse = -1;

const
	kFFTRadix2 = 0;
	kFFTRadix3 = 1;
	kFFTRadix5 = 2;

const
	vDSP_HALF_WINDOW = 1;
	vDSP_HANN_DENORM = 0;
	vDSP_HANN_NORM = 2;


{  create_fftsetup and create_ffsetupD allocate memory and prepare constants
    used by single- and double-precision FFT routines, respectively.

    destroy_fftsetup and destroy_fftsetupD free the memory.
}
{
 *  vDSP_create_fftsetup()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
function vDSP_create_fftsetup( __vDSP_log2n: vDSP_Length; __vDSP_radix: FFTRadix ): FFTSetup; external name '_vDSP_create_fftsetup';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_destroy_fftsetup()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_destroy_fftsetup( __vDSP_setup: FFTSetup ); external name '_vDSP_destroy_fftsetup';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_create_fftsetupD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
function vDSP_create_fftsetupD( __vDSP_log2n: vDSP_Length; __vDSP_radix: FFTRadix ): FFTSetupD; external name '_vDSP_create_fftsetupD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_destroy_fftsetupD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_destroy_fftsetupD( __vDSP_setup: FFTSetupD ); external name '_vDSP_destroy_fftsetupD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  ctoz and ctozD convert a complex array to a complex-split array.
    ztoc and ztocD convert a complex-split array to a complex array.
}
{
 *  vDSP_ctoz()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_ctoz( {const} __vDSP_C: {variable-size-array} DSPComplexPtr; __vDSP_strideC: vDSP_Stride; __vDSP_Z: DSPSplitComplexPtr; __vDSP_strideZ: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_ctoz';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_ztoc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_ztoc( const __vDSP_Z: DSPSplitComplexPtr; __vDSP_strideZ: vDSP_Stride; __vDSP_C: {variable-size-array} DSPComplexPtr; __vDSP_strideC: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_ztoc';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_ctozD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_ctozD( {const} __vDSP_C: {variable-size-array} DSPDoubleComplexPtr; __vDSP_strideC: vDSP_Stride; __vDSP_Z: DSPDoubleSplitComplexPtr; __vDSP_strideZ: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_ctozD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_ztocD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_ztocD( const __vDSP_Z: DSPDoubleSplitComplexPtr; __vDSP_strideZ: vDSP_Stride; __vDSP_C: {variable-size-array} DSPDoubleComplexPtr; __vDSP_strideC: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_ztocD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  In-place complex Discrete Fourier Transform routines.

    fft_zip Single-precision without temporary memory.
    fft_zipt    Single-precision with temporary memory.
    fft_zipD    Double-precision without temporary memory.
    fft_ziptD   Double-precision with temporary memory.
}
{
 *  vDSP_fft_zip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft_zip( __vDSP_setup: FFTSetup; __vDSP_ioData: DSPSplitComplexPtr; __vDSP_stride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft_zip';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft_zipt()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft_zipt( __vDSP_setup: FFTSetup; __vDSP_ioData: DSPSplitComplexPtr; __vDSP_stride: vDSP_Stride; __vDSP_bufferTemp: DSPSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft_zipt';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft_zipD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft_zipD( __vDSP_setup: FFTSetupD; __vDSP_ioData: DSPDoubleSplitComplexPtr; __vDSP_stride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft_zipD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fft_ziptD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft_ziptD( __vDSP_setup: FFTSetupD; __vDSP_ioData: DSPDoubleSplitComplexPtr; __vDSP_stride: vDSP_Stride; __vDSP_bufferTemp: DSPDoubleSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft_ziptD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  Out-of-place complex Discrete Fourier Transform routines.

    fft_zop Single-precision without temporary memory.
    fft_zopt    Single-precision with temporary memory.
    fft_zopD    Double-precision without temporary memory.
    fft_zoptD   Double-precision with temporary memory.
}
{
 *  vDSP_fft_zop()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft_zop( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft_zop';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft_zopt()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft_zopt( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_bufferTemp: DSPSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft_zopt';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft_zopD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft_zopD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft_zopD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fft_zoptD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft_zoptD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_bufferTemp: DSPDoubleSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft_zoptD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  In-place real-to-complex Discrete Fourier Transform routines.

    fft_zrip    Single-precision without temporary memory.
    fft_zript   Single-precision with temporary memory.
    fft_zripD   Double-precision without temporary memory.
    fft_zriptD  Double-precision with temporary memory.
}
{
 *  vDSP_fft_zrip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft_zrip( __vDSP_setup: FFTSetup; __vDSP_ioData: DSPSplitComplexPtr; __vDSP_stride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft_zrip';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft_zript()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft_zript( __vDSP_setup: FFTSetup; __vDSP_ioData: DSPSplitComplexPtr; __vDSP_stride: vDSP_Stride; __vDSP_bufferTemp: DSPSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft_zript';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft_zripD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft_zripD( __vDSP_setup: FFTSetupD; __vDSP_ioData: DSPDoubleSplitComplexPtr; __vDSP_stride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft_zripD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fft_zriptD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft_zriptD( __vDSP_setup: FFTSetupD; __vDSP_ioData: DSPDoubleSplitComplexPtr; __vDSP_stride: vDSP_Stride; __vDSP_bufferTemp: DSPDoubleSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft_zriptD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  Out-of-place real-to-complex Discrete Fourier Transform routines.

    fft_zrop    Single-precision without temporary memory.
    fft_zropt   Single-precision with temporary memory.
    fft_zropD   Double-precision without temporary memory.
    fft_zroptD  Double-precision with temporary memory.
}
{
 *  vDSP_fft_zrop()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft_zrop( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft_zrop';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft_zropt()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft_zropt( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_bufferTemp: DSPSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft_zropt';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft_zropD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft_zropD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft_zropD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fft_zroptD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft_zroptD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_bufferTemp: DSPDoubleSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft_zroptD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  In-place two-dimensional complex Discrete Fourier Transform routines.

    fft2d_zip   Single-precision without temporary memory.
    fft2d_zipt  Single-precision with temporary memory.
    fft2d_zipD  Double-precision without temporary memory.
    fft2d_ziptD Double-precision with temporary memory.
}
{
 *  vDSP_fft2d_zip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft2d_zip( __vDSP_setup: FFTSetup; __vDSP_ioData: DSPSplitComplexPtr; __vDSP_strideInRow: vDSP_Stride; __vDSP_strideInCol: vDSP_Stride; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft2d_zip';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft2d_zipt()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft2d_zipt( __vDSP_setup: FFTSetup; __vDSP_ioData: DSPSplitComplexPtr; __vDSP_strideInRow: vDSP_Stride; __vDSP_strideInCol: vDSP_Stride; __vDSP_bufferTemp: DSPSplitComplexPtr; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft2d_zipt';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft2d_zipD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft2d_zipD( __vDSP_setup: FFTSetupD; __vDSP_ioData: DSPDoubleSplitComplexPtr; __vDSP_strideInRow: vDSP_Stride; __vDSP_strideInCol: vDSP_Stride; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft2d_zipD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fft2d_ziptD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft2d_ziptD( __vDSP_setup: FFTSetupD; __vDSP_ioData: DSPDoubleSplitComplexPtr; __vDSP_strideInRow: vDSP_Stride; __vDSP_strideInCol: vDSP_Stride; __vDSP_bufferTemp: DSPDoubleSplitComplexPtr; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft2d_ziptD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  Out-of-place two-dimensional complex Discrete Fourier Transform routines.

    fft2d_zop   Single-precision without temporary memory.
    fft2d_zopt  Single-precision with temporary memory.
    fft2d_zopD  Double-precision without temporary memory.
    fft2d_zoptD Double-precision with temporary memory.
}
{
 *  vDSP_fft2d_zop()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft2d_zop( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStrideInRow: vDSP_Stride; __vDSP_signalStrideInCol: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResultInRow: vDSP_Stride; __vDSP_strideResultInCol: vDSP_Stride; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft2d_zop';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft2d_zopt()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft2d_zopt( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStrideInRow: vDSP_Stride; __vDSP_signalStrideInCol: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResultInRow: vDSP_Stride; __vDSP_strideResultInCol: vDSP_Stride; __vDSP_bufferTemp: DSPSplitComplexPtr; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft2d_zopt';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft2d_zopD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft2d_zopD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStrideInRow: vDSP_Stride; __vDSP_signalStrideInCol: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResultInRow: vDSP_Stride; __vDSP_strideResultInCol: vDSP_Stride; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft2d_zopD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fft2d_zoptD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft2d_zoptD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStrideInRow: vDSP_Stride; __vDSP_signalStrideInCol: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResultInRow: vDSP_Stride; __vDSP_strideResultInCol: vDSP_Stride; __vDSP_bufferTemp: DSPDoubleSplitComplexPtr; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft2d_zoptD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  In-place two-dimensional real-to-complex Discrete Fourier Transform
    routines.

    fft2d_zrip      Single-precision without temporary memory.
    fft2d_zript     Single-precision with temporary memory.
    fft2d_zripD     Double-precision without temporary memory.
    fft2d_zriptD    Double-precision with temporary memory.
}
{
 *  vDSP_fft2d_zrip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft2d_zrip( __vDSP_setup: FFTSetup; __vDSP_ioData: DSPSplitComplexPtr; __vDSP_strideInRow: vDSP_Stride; __vDSP_strideInCol: vDSP_Stride; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft2d_zrip';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft2d_zript()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft2d_zript( __vDSP_setup: FFTSetup; __vDSP_ioData: DSPSplitComplexPtr; __vDSP_strideInRow: vDSP_Stride; __vDSP_strideInCol: vDSP_Stride; __vDSP_bufferTemp: DSPSplitComplexPtr; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_direction: FFTDirection ); external name '_vDSP_fft2d_zript';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft2d_zripD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft2d_zripD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_strideInRow: vDSP_Stride; __vDSP_strideInCol: vDSP_Stride; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft2d_zripD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fft2d_zriptD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft2d_zriptD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_strideInRow: vDSP_Stride; __vDSP_strideInCol: vDSP_Stride; __vDSP_bufferTemp: DSPDoubleSplitComplexPtr; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft2d_zriptD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  Out-of-place two-dimensional real-to-complex Discrete Fourier Transform
    routines.

    fft2d_zrop      Single-precision without temporary memory.
    fft2d_zropt     Single-precision with temporary memory.
    fft2d_zropD     Double-precision without temporary memory.
    fft2d_zroptD    Double-precision with temporary memory.
}
{
 *  vDSP_fft2d_zrop()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft2d_zrop( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStrideInRow: vDSP_Stride; __vDSP_signalStrideInCol: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResultInRow: vDSP_Stride; __vDSP_strideResultInCol: vDSP_Stride; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft2d_zrop';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft2d_zropt()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_fft2d_zropt( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStrideInRow: vDSP_Stride; __vDSP_signalStrideInCol: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResultInRow: vDSP_Stride; __vDSP_strideResultInCol: vDSP_Stride; __vDSP_bufferTemp: DSPSplitComplexPtr; __vDSP_log2nInCol: vDSP_Length; __vDSP_log2nInRow: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft2d_zropt';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{
 *  vDSP_fft2d_zropD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft2d_zropD( __vDSP_setup: FFTSetupD; __vDSP_ioData: DSPDoubleSplitComplexPtr; __vDSP_Kr: vDSP_Stride; __vDSP_Kc: vDSP_Stride; __vDSP_ioData2: DSPDoubleSplitComplexPtr; __vDSP_Ir: vDSP_Stride; __vDSP_Ic: vDSP_Stride; __vDSP_log2nc: vDSP_Length; __vDSP_log2nr: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft2d_zropD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fft2d_zroptD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft2d_zroptD( __vDSP_setup: FFTSetupD; __vDSP_ioData: DSPDoubleSplitComplexPtr; __vDSP_Kr: vDSP_Stride; __vDSP_Kc: vDSP_Stride; __vDSP_ioData2: DSPDoubleSplitComplexPtr; __vDSP_Ir: vDSP_Stride; __vDSP_Ic: vDSP_Stride; __vDSP_temp: DSPDoubleSplitComplexPtr; __vDSP_log2nc: vDSP_Length; __vDSP_log2nr: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft2d_zroptD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  In-place multiple complex Discrete Fourier Transform routines.

    fftm_zip    Single-precision without temporary memory.
    fftm_zipt   Single-precision with temporary memory.
    fftm_zipD   Double-precision without temporary memory.
    fftm_ziptD  Double-precision with temporary memory.
}
{
 *  vDSP_fftm_zip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zip( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zip';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fftm_zipt()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zipt( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_temp: DSPSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zipt';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fftm_zipD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zipD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zipD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fftm_ziptD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_ziptD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_temp: DSPDoubleSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_ziptD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  Out-of-place multiple complex Discrete Fourier Transform routines.

    fftm_zop    Single-precision without temporary memory.
    fftm_zopt   Single-precision with temporary memory.
    fftm_zopD   Double-precision without temporary memory.
    fftm_zoptD  Double-precision with temporary memory.
}
{
 *  vDSP_fftm_zop()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zop( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_resultStride: vDSP_Stride; __vDSP_rfftStride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zop';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fftm_zopt()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zopt( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_resultStride: vDSP_Stride; __vDSP_rfftStride: vDSP_Stride; __vDSP_temp: DSPSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zopt';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fftm_zopD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zopD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_resultStride: vDSP_Stride; __vDSP_rfftStride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zopD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fftm_zoptD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zoptD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_resultStride: vDSP_Stride; __vDSP_rfftStride: vDSP_Stride; __vDSP_temp: DSPDoubleSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zoptD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  In-place multiple real-to-complex Discrete Fourier Transform routines.

    fftm_zip    Single-precision without temporary memory.
    fftm_zipt   Single-precision with temporary memory.
    fftm_zipD   Double-precision without temporary memory.
    fftm_ziptD  Double-precision with temporary memory.
}
{
 *  vDSP_fftm_zrip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zrip( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zrip';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fftm_zript()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zript( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_temp: DSPSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zript';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fftm_zripD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zripD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zripD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fftm_zriptD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zriptD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_temp: DSPDoubleSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zriptD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  Out-of-place multiple real-to-complex Discrete Fourier Transform routines.

    fftm_zrop   Single-precision without temporary memory.
    fftm_zropt  Single-precision with temporary memory.
    fftm_zropD  Double-precision without temporary memory.
    fftm_zroptD Double-precision with temporary memory.
}
{
 *  vDSP_fftm_zrop()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zrop( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_resultStride: vDSP_Stride; __vDSP_rfftStride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zrop';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fftm_zropt()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zropt( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_resultStride: vDSP_Stride; __vDSP_rfftStride: vDSP_Stride; __vDSP_temp: DSPSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zropt';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fftm_zropD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zropD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_resultStride: vDSP_Stride; __vDSP_rfftStride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zropD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fftm_zroptD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fftm_zroptD( __vDSP_setup: FFTSetupD; __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_fftStride: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_resultStride: vDSP_Stride; __vDSP_rfftStride: vDSP_Stride; __vDSP_temp: DSPDoubleSplitComplexPtr; __vDSP_log2n: vDSP_Length; __vDSP_numFFT: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fftm_zroptD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{  Non-power-of-two out-of-place complex Discrete Fourier Transform routines.

    fft3_zop    3*2**n elements, single-precision without temporary memory.
    fft3_zopD   3*2**n elements, double-precision without temporary memory.
    fft5_zop    5*2**n elements, single-precision without temporary memory.
    fft5_zopD   5*2**n elements, double-precision without temporary memory.
}
{
 *  vDSP_fft3_zop()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft3_zop( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_resultStride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft3_zop';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fft5_zop()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft5_zop( __vDSP_setup: FFTSetup; __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_resultStride: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft5_zop';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fft3_zopD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft3_zopD( __vDSP_setup: FFTSetupD; __vDSP_ioData: DSPDoubleSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_ioData2: DSPDoubleSplitComplexPtr; __vDSP_L: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft3_zopD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{
 *  vDSP_fft5_zopD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_fft5_zopD( __vDSP_setup: FFTSetupD; __vDSP_ioData: DSPDoubleSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_ioData2: DSPDoubleSplitComplexPtr; __vDSP_L: vDSP_Stride; __vDSP_log2n: vDSP_Length; __vDSP_flag: FFTDirection ); external name '_vDSP_fft5_zopD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Convolution (or correlation), single-precision.}
{
 *  vDSP_conv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_conv( {const} __vDSP_signal: {variable-size-array} Float32Ptr; __vDSP_signalStride: vDSP_Stride; {const} __vDSP_filter: {variable-size-array} Float32Ptr; __vDSP_strideFilter: vDSP_Stride; __vDSP_result: {variable-size-array} Float32Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_lenResult: vDSP_Length; __vDSP_lenFilter: vDSP_Length ); external name '_vDSP_conv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Convolution (or correlation), double-precision.}
{
 *  vDSP_convD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_convD( {const} __vDSP_signal: {variable-size-array} Float64Ptr; __vDSP_signalStride: vDSP_Stride; {const} __vDSP_filter: {variable-size-array} Float64Ptr; __vDSP_strideFilter: vDSP_Stride; __vDSP_result: {variable-size-array} Float64Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_lenResult: vDSP_Length; __vDSP_lenFilter: vDSP_Length ); external name '_vDSP_convD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ 3*3 filter convolution, single-precision.}
{
 *  vDSP_f3x3()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_f3x3( __vDSP_signal: Float32Ptr; __vDSP_rows: vDSP_Length; __vDSP_cols: vDSP_Length; __vDSP_filter: Float32Ptr; __vDSP_result: Float32Ptr ); external name '_vDSP_f3x3';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ 3*3 filter convolution, double-precision.}
{
 *  vDSP_f3x3D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_f3x3D( __vDSP_signal: Float64Ptr; __vDSP_rows: vDSP_Length; __vDSP_cols: vDSP_Length; __vDSP_filter: Float64Ptr; __vDSP_result: Float64Ptr ); external name '_vDSP_f3x3D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ 5*5 filter convolution, single-precision.}
{
 *  vDSP_f5x5()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_f5x5( __vDSP_signal: Float32Ptr; __vDSP_rows: vDSP_Length; __vDSP_cols: vDSP_Length; __vDSP_filter: Float32Ptr; __vDSP_result: Float32Ptr ); external name '_vDSP_f5x5';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ 5*5 filter convolution, double-precision.}
{
 *  vDSP_f5x5D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_f5x5D( __vDSP_signal: Float64Ptr; __vDSP_rows: vDSP_Length; __vDSP_cols: vDSP_Length; __vDSP_filter: Float64Ptr; __vDSP_result: Float64Ptr ); external name '_vDSP_f5x5D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ General two-dimensional (image) convolution, single-precision.}
{
 *  vDSP_imgfir()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_imgfir( __vDSP_signal: Float32Ptr; __vDSP_numRow: vDSP_Length; __vDSP_numCol: vDSP_Length; __vDSP_filter: Float32Ptr; __vDSP_result: Float32Ptr; __vDSP_fnumRow: vDSP_Length; __vDSP_fnumCol: vDSP_Length ); external name '_vDSP_imgfir';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ General two-dimensional (image) convolution, double-precision.}
{
 *  vDSP_imgfirD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_imgfirD( __vDSP_signal: Float64Ptr; __vDSP_numRow: vDSP_Length; __vDSP_numCol: vDSP_Length; __vDSP_filter: Float64Ptr; __vDSP_result: Float64Ptr; __vDSP_fnumRow: vDSP_Length; __vDSP_fnumCol: vDSP_Length ); external name '_vDSP_imgfirD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Matrix transpose, single-precision.}
{
 *  vDSP_mtrans()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_mtrans( __vDSP_a: Float32Ptr; __vDSP_aStride: vDSP_Stride; __vDSP_c: Float32Ptr; __vDSP_cStride: vDSP_Stride; __vDSP_M: vDSP_Length; __vDSP_N: vDSP_Length ); external name '_vDSP_mtrans';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Matrix transpose, double-precision.}
{
 *  vDSP_mtransD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_mtransD( __vDSP_a: Float64Ptr; __vDSP_aStride: vDSP_Stride; __vDSP_c: Float64Ptr; __vDSP_cStride: vDSP_Stride; __vDSP_M: vDSP_Length; __vDSP_N: vDSP_Length ); external name '_vDSP_mtransD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Matrix multiply, single-precision.}
{
 *  vDSP_mmul()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_mmul( __vDSP_a: Float32Ptr; __vDSP_aStride: vDSP_Stride; __vDSP_b: Float32Ptr; __vDSP_bStride: vDSP_Stride; __vDSP_c: Float32Ptr; __vDSP_cStride: vDSP_Stride; __vDSP_M: vDSP_Length; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_mmul';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Matrix multiply, double-precision.}
{
 *  vDSP_mmulD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_mmulD( __vDSP_a: Float64Ptr; __vDSP_aStride: vDSP_Stride; __vDSP_b: Float64Ptr; __vDSP_bStride: vDSP_Stride; __vDSP_c: Float64Ptr; __vDSP_cStride: vDSP_Stride; __vDSP_M: vDSP_Length; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_mmulD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split matrix multiply and add, single-precision.}
{
 *  vDSP_zmma()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zmma( __vDSP_a: DSPSplitComplexPtr; __vDSP_i: vDSP_Stride; __vDSP_b: DSPSplitComplexPtr; __vDSP_j: vDSP_Stride; __vDSP_c: DSPSplitComplexPtr; __vDSP_k: vDSP_Stride; __vDSP_d: DSPSplitComplexPtr; __vDSP_l: vDSP_Stride; __vDSP_M: vDSP_Length; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_zmma';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split matrix multiply and add, double-precision.}
{
 *  vDSP_zmmaD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zmmaD( __vDSP_a: DSPDoubleSplitComplexPtr; __vDSP_i: vDSP_Stride; __vDSP_b: DSPDoubleSplitComplexPtr; __vDSP_j: vDSP_Stride; __vDSP_c: DSPDoubleSplitComplexPtr; __vDSP_k: vDSP_Stride; __vDSP_d: DSPDoubleSplitComplexPtr; __vDSP_l: vDSP_Stride; __vDSP_M: vDSP_Length; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_zmmaD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split matrix multiply and subtract, single-precision.}
{
 *  vDSP_zmms()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zmms( __vDSP_a: DSPSplitComplexPtr; __vDSP_i: vDSP_Stride; __vDSP_b: DSPSplitComplexPtr; __vDSP_j: vDSP_Stride; __vDSP_c: DSPSplitComplexPtr; __vDSP_k: vDSP_Stride; __vDSP_d: DSPSplitComplexPtr; __vDSP_l: vDSP_Stride; __vDSP_M: vDSP_Length; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_zmms';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split matrix multiply and subtract, double-precision.}
{
 *  vDSP_zmmsD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zmmsD( __vDSP_a: DSPDoubleSplitComplexPtr; __vDSP_i: vDSP_Stride; __vDSP_b: DSPDoubleSplitComplexPtr; __vDSP_j: vDSP_Stride; __vDSP_c: DSPDoubleSplitComplexPtr; __vDSP_k: vDSP_Stride; __vDSP_d: DSPDoubleSplitComplexPtr; __vDSP_l: vDSP_Stride; __vDSP_M: vDSP_Length; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_zmmsD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split matrix subtract and multiply, single-precision.}
{
 *  vDSP_zmsm()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zmsm( __vDSP_a: DSPSplitComplexPtr; __vDSP_i: vDSP_Stride; __vDSP_b: DSPSplitComplexPtr; __vDSP_j: vDSP_Stride; __vDSP_c: DSPSplitComplexPtr; __vDSP_k: vDSP_Stride; __vDSP_d: DSPSplitComplexPtr; __vDSP_l: vDSP_Stride; __vDSP_M: vDSP_Length; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_zmsm';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split matrix subtract and multiply, double-precision.}
{
 *  vDSP_zmsmD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zmsmD( __vDSP_a: DSPDoubleSplitComplexPtr; __vDSP_i: vDSP_Stride; __vDSP_b: DSPDoubleSplitComplexPtr; __vDSP_j: vDSP_Stride; __vDSP_c: DSPDoubleSplitComplexPtr; __vDSP_k: vDSP_Stride; __vDSP_d: DSPDoubleSplitComplexPtr; __vDSP_l: vDSP_Stride; __vDSP_M: vDSP_Length; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_zmsmD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split matrix multiply, single-precision.}
{
 *  vDSP_zmmul()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zmmul( __vDSP_a: DSPSplitComplexPtr; __vDSP_i: vDSP_Stride; __vDSP_b: DSPSplitComplexPtr; __vDSP_j: vDSP_Stride; __vDSP_c: DSPSplitComplexPtr; __vDSP_k: vDSP_Stride; __vDSP_M: vDSP_Length; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_zmmul';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split matrix multiply, double-precision.}
{
 *  vDSP_zmmulD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zmmulD( __vDSP_a: DSPDoubleSplitComplexPtr; __vDSP_i: vDSP_Stride; __vDSP_b: DSPDoubleSplitComplexPtr; __vDSP_j: vDSP_Stride; __vDSP_c: DSPDoubleSplitComplexPtr; __vDSP_k: vDSP_Stride; __vDSP_M: vDSP_Length; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_zmmulD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Vector add, single-precision.}
{
 *  vDSP_vadd()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_vadd( {const} __vDSP_input1: {variable-size-array} Float32Ptr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float32Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: {variable-size-array} Float32Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vadd';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Vector add, double-precision.}
{
 *  vDSP_vaddD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vaddD( {const} __vDSP_input1: {variable-size-array} Float64Ptr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float64Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: {variable-size-array} Float64Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vaddD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Vector subtract, single-precision.}
{
 *  vDSP_vsub()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_vsub( {const} __vDSP_input1: {variable-size-array} Float32Ptr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float32Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: {variable-size-array} Float32Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vsub';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Vector subtract, double-precision.}
{
 *  vDSP_vsubD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsubD( {const} __vDSP_input1: {variable-size-array} Float64Ptr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float64Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: {variable-size-array} Float64Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vsubD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Vector multiply, single-precision.}
{
 *  vDSP_vmul()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_vmul( {const} __vDSP_input1: {variable-size-array} Float32Ptr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float32Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: {variable-size-array} Float32Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vmul';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Vector multiply, double-precision.}
{
 *  vDSP_vmulD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmulD( {const} __vDSP_input1: {variable-size-array} Float64Ptr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float64Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: {variable-size-array} Float64Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vmulD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Vector-scalar multiply, single-precision.}
{
 *  vDSP_vsmul()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_vsmul( {const} __vDSP_input1: {variable-size-array} Float32Ptr; __vDSP_stride1: vDSP_Stride; const __vDSP_input2: Float32Ptr; __vDSP_result: {variable-size-array} Float32Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vsmul';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Vector-scalar multiply, double-precision.}
{
 *  vDSP_vsmulD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsmulD( {const} __vDSP_input1: {variable-size-array} Float64Ptr; __vDSP_stride1: vDSP_Stride; const __vDSP_input2: Float64Ptr; __vDSP_result: {variable-size-array} Float64Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vsmulD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Vector square, single-precision.}
{
 *  vDSP_vsq()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_vsq( {const} __vDSP_input: {variable-size-array} Float32Ptr; __vDSP_strideInput: vDSP_Stride; __vDSP_result: {variable-size-array} Float32Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vsq';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Vector square, double-precision.}
{
 *  vDSP_vsqD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsqD( {const} __vDSP_input: {variable-size-array} Float64Ptr; __vDSP_strideInput: vDSP_Stride; __vDSP_result: {variable-size-array} Float64Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vsqD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Vector signed square, single-precision.}
{
 *  vDSP_vssq()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_vssq( {const} __vDSP_input: {variable-size-array} Float32Ptr; __vDSP_strideInput: vDSP_Stride; __vDSP_result: {variable-size-array} Float32Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vssq';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Vector signed square, double-precision.}
{
 *  vDSP_vssqD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vssqD( {const} __vDSP_input: {variable-size-array} Float64Ptr; __vDSP_strideInput: vDSP_Stride; __vDSP_result: {variable-size-array} Float64Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vssqD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)

{ Euclidean distance square, single-precision.}
{
 *  vDSP_distancesq()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_distancesq( {const} __vDSP_input1: {variable-size-array} Float32Ptr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float32Ptr; __vDSP_stride2: vDSP_Stride;  __vDSP_result:  {variable-size-array} Float32Ptr; __vDSP_size: vDSP_Length ); external name '_vDSP_distancesq';
(* __OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_5_0) *)

{ Dot product, single-precision.}
{
 *  vDSP_dotpr()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_dotpr( {const} __vDSP_input1: {variable-size-array} Float32Ptr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float32Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: Float32Ptr; __vDSP_size: vDSP_Length ); external name '_vDSP_dotpr';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Dot product, double-precision.}
{
 *  vDSP_dotprD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_dotprD( {const} __vDSP_input1: {variable-size-array} Float64Ptr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float64Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: Float64Ptr; __vDSP_size: vDSP_Length ); external name '_vDSP_dotprD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Vector add and multiply, single-precision.}
{
 *  vDSP_vam()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_vam( {const} __vDSP_input1: {variable-size-array} Float32Ptr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float32Ptr; __vDSP_stride2: vDSP_Stride; {const} __vDSP_input3: {variable-size-array} Float32Ptr; __vDSP_stride3: vDSP_Stride; __vDSP_result: {variable-size-array} Float32Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vam';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Vector add and multiply, double-precision.}
{
 *  vDSP_vamD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vamD( {const} __vDSP_input1: {variable-size-array} Float64Ptr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float64Ptr; __vDSP_stride2: vDSP_Stride; {const} __vDSP_input3: {variable-size-array} Float64Ptr; __vDSP_stride3: vDSP_Stride; __vDSP_result: {variable-size-array} Float64Ptr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_vamD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split convolution, single-precision.}
{
 *  vDSP_zconv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_zconv( __vDSP_signal: DSPSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_filter: DSPSplitComplexPtr; __vDSP_strideFilter: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_lenResult: vDSP_Length; __vDSP_lenFilter: vDSP_Length ); external name '_vDSP_zconv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Complex-split convolution, double-precision.}
{
 *  vDSP_zconvD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zconvD( __vDSP_signal: DSPDoubleSplitComplexPtr; __vDSP_signalStride: vDSP_Stride; __vDSP_filter: DSPDoubleSplitComplexPtr; __vDSP_strideFilter: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_lenResult: vDSP_Length; __vDSP_lenFilter: vDSP_Length ); external name '_vDSP_zconvD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split vector add, single-precision.}
{
 *  vDSP_zvadd()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_zvadd( __vDSP_input1: DSPSplitComplexPtr; __vDSP_stride1: vDSP_Stride; __vDSP_input2: DSPSplitComplexPtr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_zvadd';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Complex-split vector add, double-precision.}
{
 *  vDSP_zvaddD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvaddD( __vDSP_input1: DSPDoubleSplitComplexPtr; __vDSP_stride1: vDSP_Stride; __vDSP_input2: DSPDoubleSplitComplexPtr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_zvaddD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split vector subtract, single-precision.}
{
 *  vDSP_zvsub()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_zvsub( __vDSP_input1: DSPSplitComplexPtr; __vDSP_stride1: vDSP_Stride; __vDSP_input2: DSPSplitComplexPtr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_zvsub';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Complex-split vector subtract, double-precision.}
{
 *  vDSP_zvsubD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvsubD( __vDSP_input1: DSPDoubleSplitComplexPtr; __vDSP_stride1: vDSP_Stride; __vDSP_input2: DSPDoubleSplitComplexPtr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_zvsubD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split vector multiply, single-precision.}
{
 *  vDSP_zvmul()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_zvmul( const __vDSP_input1: DSPSplitComplexPtr; __vDSP_stride1: vDSP_Stride; const __vDSP_input2: DSPSplitComplexPtr; __vDSP_stride2: vDSP_Stride; const __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length; __vDSP_conjugate: SInt32 ); external name '_vDSP_zvmul';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Complex-split vector multiply, double-precision.}
{
 *  vDSP_zvmulD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvmulD( __vDSP_input1: DSPDoubleSplitComplexPtr; __vDSP_stride1: vDSP_Stride; __vDSP_input2: DSPDoubleSplitComplexPtr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length; __vDSP_conjugate: SInt32 ); external name '_vDSP_zvmulD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split dot product, single-precision.}
{
 *  vDSP_zdotpr()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_zdotpr( __vDSP_input1: DSPSplitComplexPtr; __vDSP_stride1: vDSP_Stride; __vDSP_input2: DSPSplitComplexPtr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_size: vDSP_Length ); external name '_vDSP_zdotpr';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Complex-split dot product, double-precision.}
{
 *  vDSP_zdotprD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zdotprD( __vDSP_input1: DSPDoubleSplitComplexPtr; __vDSP_stride1: vDSP_Stride; __vDSP_input2: DSPDoubleSplitComplexPtr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_size: vDSP_Length ); external name '_vDSP_zdotprD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split inner (conjugate) dot product, single-precision.}
{
 *  vDSP_zidotpr()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_zidotpr( __vDSP_input1: DSPSplitComplexPtr; __vDSP_stride1: vDSP_Stride; __vDSP_input2: DSPSplitComplexPtr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_size: vDSP_Length ); external name '_vDSP_zidotpr';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Complex-split inner (conjugate) dot product, double-precision.}
{
 *  vDSP_zidotprD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zidotprD( __vDSP_input1: DSPDoubleSplitComplexPtr; __vDSP_stride1: vDSP_Stride; __vDSP_input2: DSPDoubleSplitComplexPtr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_size: vDSP_Length ); external name '_vDSP_zidotprD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Dot product of complex-split with real, single-precision.}
{
 *  vDSP_zrdotpr()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_zrdotpr( __vDSP_input1: DSPSplitComplexPtr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float32Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_size: vDSP_Length ); external name '_vDSP_zrdotpr';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Dot product of complex-split with real, double-precision.}
{
 *  vDSP_zrdotprD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zrdotprD( __vDSP_input1: DSPDoubleSplitComplexPtr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float64Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_size: vDSP_Length ); external name '_vDSP_zrdotprD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Complex-split conjugate multiply and add, single-precision.}
{
 *  vDSP_zvcma()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_zvcma( const __vDSP_input1: DSPSplitComplexPtr; __vDSP_stride1: vDSP_Stride; const __vDSP_input2: DSPSplitComplexPtr; __vDSP_stride2: vDSP_Stride; const __vDSP_input3: DSPSplitComplexPtr; __vDSP_stride3: vDSP_Stride; const __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_zvcma';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Complex-split conjugate multiply and add, double-precision.}
{
 *  vDSP_zvcmaD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvcmaD( __vDSP_input1: DSPDoubleSplitComplexPtr; __vDSP_stride1: vDSP_Stride; __vDSP_input2: DSPDoubleSplitComplexPtr; __vDSP_stride2: vDSP_Stride; __vDSP_input3: DSPDoubleSplitComplexPtr; __vDSP_stride3: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_zvcmaD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Add complex-split and real, single-precision.}
{
 *  vDSP_zrvadd()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_zrvadd( __vDSP_input1: DSPSplitComplexPtr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float32Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_zrvadd';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Add complex-split and real, double-precision.}
{
 *  vDSP_zrvaddD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zrvaddD( __vDSP_input1: DSPDoubleSplitComplexPtr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float64Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_zrvaddD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Subtract real from complex-split, single-precision.}
{
 *  vDSP_zrvsub()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_zrvsub( __vDSP_input1: DSPSplitComplexPtr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float32Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_zrvsub';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Subtract real from complex-split, double-precision.}
{
 *  vDSP_zrvsubD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zrvsubD( __vDSP_input1: DSPDoubleSplitComplexPtr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float64Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_zrvsubD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Multiply complex-split and real, single-precision.}
{
 *  vDSP_zrvmul()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in vecLib.framework
 *    CarbonLib:        not in Carbon, but vecLib is compatible with CarbonLib
 *    Non-Carbon CFM:   in vecLib 1.0 and later
 }
procedure vDSP_zrvmul( __vDSP_input1: DSPSplitComplexPtr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float32Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_zrvmul';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_4_0) *)


{ Multiply complex-split and real, double-precision.}
{
 *  vDSP_zrvmulD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.2 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zrvmulD( __vDSP_input1: DSPDoubleSplitComplexPtr; __vDSP_stride1: vDSP_Stride; {const} __vDSP_input2: {variable-size-array} Float64Ptr; __vDSP_stride2: vDSP_Stride; __vDSP_result: DSPDoubleSplitComplexPtr; __vDSP_strideResult: vDSP_Stride; __vDSP_size: vDSP_Length ); external name '_vDSP_zrvmulD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_4_0) *)


{ Vector convert double-precision to single-precision.}
{
 *  vDSP_vdpsp()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vdpsp( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vdpsp';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert single-precision to double-precision.}
{
 *  vDSP_vspdp()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vspdp( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vspdp';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector absolute value, integer.}
{
 *  vDSP_vabsi()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vabsi( __vDSP_A: SInt32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: SInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vabsi';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector (bit-wise) equivalence (not (A xor B)), integer.}
{
 *  vDSP_veqvi()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_veqvi( __vDSP_A: SInt32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: SInt32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: SInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_veqvi';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector divide, integer.}
{
 *  vDSP_vdivi()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vdivi( __vDSP_A: SInt32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: SInt32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: SInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vdivi';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector fill, integer.}
{
 *  vDSP_vfilli()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfilli( __vDSP_A: SInt32Ptr; __vDSP_C: SInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfilli';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector-scalar add, integer.}
{
 *  vDSP_vsaddi()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsaddi( __vDSP_A: SInt32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: SInt32Ptr; __vDSP_C: SInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsaddi';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector-scalar divide, integer.}
{
 *  vDSP_vsdivi()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsdivi( __vDSP_A: SInt32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: SInt32Ptr; __vDSP_C: SInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsdivi';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split accumulating autospectrum, single-precision.}
{
 *  vDSP_zaspec()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zaspec( __vDSP_A: DSPSplitComplexPtr; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_zaspec';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split accumulating autospectrum, double-precision.}
{
 *  vDSP_zaspecD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zaspecD( var A: DSPDoubleSplitComplex; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_zaspecD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Create Blackman window, single-precision.}
{
 *  vDSP_blkman_window()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_blkman_window( __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length; __vDSP_FLAG: SInt32 ); external name '_vDSP_blkman_window';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Create Blackman window, double-precision.}
{
 *  vDSP_blkman_windowD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_blkman_windowD( __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length; __vDSP_FLAG: SInt32 ); external name '_vDSP_blkman_windowD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split coherence function, single-precision.}
{
 *  vDSP_zcoher()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zcoher( __vDSP_A: Float32Ptr; __vDSP_B: Float32Ptr; __vDSP_C: DSPSplitComplexPtr; __vDSP_D: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_zcoher';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split coherence function, double-precision.}
{
 *  vDSP_zcoherD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zcoherD( __vDSP_A: Float64Ptr; __vDSP_B: Float64Ptr; __vDSP_C: DSPDoubleSplitComplexPtr; __vDSP_D: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_zcoherD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split anti-aliasing down-sample with real filter, single-precision.}
{
 *  vDSP_zrdesamp()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zrdesamp( __vDSP_A: DSPSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: DSPSplitComplexPtr; __vDSP_N: vDSP_Length; __vDSP_M: vDSP_Length ); external name '_vDSP_zrdesamp';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split anti-aliasing down-sample with real filter, double-precision.}
{
 *  vDSP_zrdesampD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zrdesampD( var A: DSPDoubleSplitComplex; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: DSPDoubleSplitComplexPtr; __vDSP_N: vDSP_Length; __vDSP_M: vDSP_Length ); external name '_vDSP_zrdesampD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector complex-split divide by real, single-precision.}
{
 *  vDSP_zrvdiv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zrvdiv( __vDSP_A: DSPSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: DSPSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zrvdiv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector complex-split divide by real, double-precision.}
{
 *  vDSP_zrvdivD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zrvdivD( var A: DSPDoubleSplitComplex; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: DSPDoubleSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zrvdivD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Transfer function (B/A), single-precision.}
{
 *  vDSP_ztrans()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_ztrans( __vDSP_A: Float32Ptr; __vDSP_B: DSPSplitComplexPtr; __vDSP_C: DSPSplitComplexPtr; __vDSP_N: vDSP_Length ); external name '_vDSP_ztrans';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Transfer function (B/A), double-precision.}
{
 *  vDSP_ztransD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_ztransD( __vDSP_A: Float64Ptr; __vDSP_B: DSPDoubleSplitComplexPtr; __vDSP_C: DSPDoubleSplitComplexPtr; __vDSP_N: vDSP_Length ); external name '_vDSP_ztransD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector divide, single-precision.}
{
 *  vDSP_zvdiv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvdiv( __vDSP_A: DSPSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_B: DSPSplitComplexPtr; __vDSP_J: vDSP_Stride; __vDSP_C: DSPSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvdiv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector divide, double-precision.}
{
 *  vDSP_zvdivD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvdivD( var A: DSPDoubleSplitComplex; __vDSP_I: vDSP_Stride; __vDSP_B: DSPDoubleSplitComplexPtr; __vDSP_J: vDSP_Stride; __vDSP_C: DSPDoubleSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvdivD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split accumulating cross-spectrum, single-precision.}
{
 *  vDSP_zcspec()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zcspec( __vDSP_A: DSPSplitComplexPtr; __vDSP_B: DSPSplitComplexPtr; __vDSP_C: DSPSplitComplexPtr; __vDSP_N: vDSP_Length ); external name '_vDSP_zcspec';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split accumulating cross-spectrum, double-precision.}
{
 *  vDSP_zcspecD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zcspecD( var A: DSPDoubleSplitComplex; __vDSP_B: DSPDoubleSplitComplexPtr; __vDSP_C: DSPDoubleSplitComplexPtr; __vDSP_N: vDSP_Length ); external name '_vDSP_zcspecD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector absolute value, single-precision.}
{
 *  vDSP_zvabs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvabs( __vDSP_A: DSPSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvabs';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector absolute value, double-precision.}
{
 *  vDSP_zvabsD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvabsD( __vDSP_A: DSPDoubleSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvabsD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector conjugate and multiply, single-precision.}
{
 *  vDSP_zvcmul()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvcmul( __vDSP_A: DSPSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_B: DSPSplitComplexPtr; __vDSP_J: vDSP_Stride; __vDSP_C: DSPSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvcmul';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector conjugate and multiply, double-precision.}
{
 *  vDSP_zvcmulD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvcmulD( __vDSP_A: DSPDoubleSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_B: DSPDoubleSplitComplexPtr; __vDSP_J: vDSP_Stride; __vDSP_C: DSPDoubleSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvcmulD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector conjugate, single-precision.}
{
 *  vDSP_zvconj()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvconj( __vDSP_A: DSPSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_C: DSPSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvconj';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector conjugate, double-precision.}
{
 *  vDSP_zvconjD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvconjD( __vDSP_A: DSPDoubleSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_C: DSPDoubleSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvconjD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector multiply with scalar, single-precision.}
{
 *  vDSP_zvzsml()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvzsml( __vDSP_A: DSPSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_B: DSPSplitComplexPtr; __vDSP_C: DSPSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvzsml';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector multiply with scalar, double-precision.}
{
 *  vDSP_zvzsmlD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvzsmlD( __vDSP_A: DSPDoubleSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_B: DSPDoubleSplitComplexPtr; __vDSP_C: DSPDoubleSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvzsmlD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector fill, single-precision.}
{
 *  vDSP_zvfill()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvfill( __vDSP_A: DSPSplitComplexPtr; __vDSP_C: DSPSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvfill';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector fill, double-precision.}
{
 *  vDSP_zvfillD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvfillD( __vDSP_A: DSPDoubleSplitComplexPtr; __vDSP_C: DSPDoubleSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvfillD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector magnitudes squared, single-precision.}
{
 *  vDSP_zvmags()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvmags( __vDSP_A: DSPSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvmags';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector magnitudes squared, double-precision.}
{
 *  vDSP_zvmagsD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvmagsD( __vDSP_A: DSPDoubleSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvmagsD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector magnitudes square and add, single-precision.}
{
 *  vDSP_zvmgsa()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvmgsa( __vDSP_A: DSPSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvmgsa';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector magnitudes square and add, double-precision.}
{
 *  vDSP_zvmgsaD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvmgsaD( __vDSP_A: DSPDoubleSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvmgsaD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector move, single-precision.}
{
 *  vDSP_zvmov()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvmov( __vDSP_A: DSPSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_C: DSPSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvmov';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector move, double-precision.}
{
 *  vDSP_zvmovD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvmovD( __vDSP_A: DSPDoubleSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_C: DSPDoubleSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvmovD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector negate, single-precision.}
{
 *  vDSP_zvneg()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvneg( __vDSP_A: DSPSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_C: DSPSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvneg';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector negate, double-precision.}
{
 *  vDSP_zvnegD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvnegD( __vDSP_A: DSPDoubleSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_C: DSPDoubleSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvnegD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector phase, single-precision.}
{
 *  vDSP_zvphas()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvphas( __vDSP_A: DSPSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvphas';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector phase, double-precision.}
{
 *  vDSP_zvphasD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvphasD( __vDSP_A: DSPDoubleSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvphasD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector multiply by scalar and add, single-precision.}
{
 *  vDSP_zvsma()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvsma( __vDSP_A: DSPSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_B: DSPSplitComplexPtr; __vDSP_C: DSPSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_D: DSPSplitComplexPtr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvsma';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Complex-split vector multiply by scalar and add, double-precision.}
{
 *  vDSP_zvsmaD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_zvsmaD( __vDSP_A: DSPDoubleSplitComplexPtr; __vDSP_I: vDSP_Stride; __vDSP_B: DSPDoubleSplitComplexPtr; __vDSP_C: DSPDoubleSplitComplexPtr; __vDSP_K: vDSP_Stride; __vDSP_D: DSPDoubleSplitComplexPtr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_zvsmaD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Difference equation, 2 poles, 2 zeros, single-precision.}
{
 *  vDSP_deq22()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_deq22( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_deq22';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Difference equation, 2 poles, 2 zeros, double-precision.}
{
 *  vDSP_deq22D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_deq22D( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_deq22D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Convolution with decimation (desampling), single-precision.}
{
 *  vDSP_desamp()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_desamp( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length; __vDSP_M: vDSP_Length ); external name '_vDSP_desamp';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Convolution with decimation (desampling), double-precision.}
{
 *  vDSP_desampD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_desampD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length; __vDSP_M: vDSP_Length ); external name '_vDSP_desampD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Create Hamming window, single-precision.}
{
 *  vDSP_hamm_window()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_hamm_window( __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length; __vDSP_FLAG: SInt32 ); external name '_vDSP_hamm_window';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Create Hamming window, double-precision.}
{
 *  vDSP_hamm_windowD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_hamm_windowD( __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length; __vDSP_FLAG: SInt32 ); external name '_vDSP_hamm_windowD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Create Hanning window, single-precision.}
{
 *  vDSP_hann_window()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_hann_window( __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length; __vDSP_FLAG: SInt32 ); external name '_vDSP_hann_window';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Create Hanning window, double-precision.}
{
 *  vDSP_hann_windowD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_hann_windowD( __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length; __vDSP_FLAG: SInt32 ); external name '_vDSP_hann_windowD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Maximum magnitude of vector, single-precision.}
{
 *  vDSP_maxmgv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_maxmgv( const __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_maxmgv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Maximum magnitude of vector, double-precision.}
{
 *  vDSP_maxmgvD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_maxmgvD( const __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_maxmgvD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Maximum magnitude of vector, with index, single-precision.}
{
 *  vDSP_maxmgvi()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_maxmgvi( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; var __vDSP_IC: vDSP_Length; __vDSP_N: vDSP_Length ); external name '_vDSP_maxmgvi';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Maximum magnitude of vector, with index, double-precision.}
{
 *  vDSP_maxmgviD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_maxmgviD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; var __vDSP_IC: vDSP_Length; __vDSP_N: vDSP_Length ); external name '_vDSP_maxmgviD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Maximum value of vector, single-precision.}
{
 *  vDSP_maxv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_maxv( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_maxv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Maximum value of vector, double-precision.}
{
 *  vDSP_maxvD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_maxvD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_maxvD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Maximum value of vector, with index, single-precision.}
{
 *  vDSP_maxvi()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_maxvi( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; var __vDSP_IC: vDSP_Length; __vDSP_N: vDSP_Length ); external name '_vDSP_maxvi';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Maximum value of vector, with index, double-precision.}
{
 *  vDSP_maxviD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_maxviD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; var __vDSP_IC: vDSP_Length; __vDSP_N: vDSP_Length ); external name '_vDSP_maxviD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Mean magnitude of vector, single-precision.}
{
 *  vDSP_meamgv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_meamgv( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_meamgv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Mean magnitude of vector, double-precision.}
{
 *  vDSP_meamgvD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_meamgvD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_meamgvD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Mean of vector, single-precision.}
{
 *  vDSP_meanv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_meanv( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_meanv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Mean of vector, double-precision.}
{
 *  vDSP_meanvD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_meanvD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_meanvD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Mean square of vector, single-precision.}
{
 *  vDSP_measqv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_measqv( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_measqv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Mean square of vector, double-precision.}
{
 *  vDSP_measqvD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_measqvD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_measqvD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Minimum magnitude of vector, single-precision.}
{
 *  vDSP_minmgv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_minmgv( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_minmgv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Minimum magnitude of vector, double-precision.}
{
 *  vDSP_minmgvD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_minmgvD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_minmgvD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Minimum magnitude of vector, with index, single-precision.}
{
 *  vDSP_minmgvi()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_minmgvi( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; var __vDSP_IC: vDSP_Length; __vDSP_N: vDSP_Length ); external name '_vDSP_minmgvi';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Minimum magnitude of vector, with index, double-precision.}
{
 *  vDSP_minmgviD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_minmgviD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; var __vDSP_IC: vDSP_Length; __vDSP_N: vDSP_Length ); external name '_vDSP_minmgviD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Minimum value of vector, single-precision.}
{
 *  vDSP_minv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_minv( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_minv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Minimum value of vector, double-precision.}
{
 *  vDSP_minvD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_minvD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_minvD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Minimum value of vector, with index, single-precision.}
{
 *  vDSP_minvi()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_minvi( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; var __vDSP_IC: vDSP_Length; __vDSP_N: vDSP_Length ); external name '_vDSP_minvi';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Minimum value of vector, with index, double-precision.}
{
 *  vDSP_minviD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_minviD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; var __vDSP_IC: vDSP_Length; __vDSP_N: vDSP_Length ); external name '_vDSP_minviD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Matrix move, single-precision.}
{
 *  vDSP_mmov()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_mmov( __vDSP_A: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_NC: vDSP_Length; __vDSP_NR: vDSP_Length; __vDSP_TCA: vDSP_Length; __vDSP_TCC: vDSP_Length ); external name '_vDSP_mmov';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Matrix move, double-precision.}
{
 *  vDSP_mmovD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_mmovD( __vDSP_A: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_NC: vDSP_Length; __vDSP_NR: vDSP_Length; __vDSP_TCA: vDSP_Length; __vDSP_TCC: vDSP_Length ); external name '_vDSP_mmovD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Mean of signed squares of vector, single-precision.}
{
 *  vDSP_mvessq()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_mvessq( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_mvessq';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Mean of signed squares of vector, double-precision.}
{
 *  vDSP_mvessqD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_mvessqD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_mvessqD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Find zero crossing, single-precision.}
{
 *  vDSP_nzcros()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_nzcros( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: vDSP_Length; var __vDSP_C: vDSP_Length; var __vDSP_D: vDSP_Length; __vDSP_N: vDSP_Length ); external name '_vDSP_nzcros';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Find zero crossing, double-precision.}
{
 *  vDSP_nzcrosD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_nzcrosD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: vDSP_Length; var __vDSP_C: vDSP_Length; var __vDSP_D: vDSP_Length; __vDSP_N: vDSP_Length ); external name '_vDSP_nzcrosD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Convert rectangular to polar, single-precision.}
{
 *  vDSP_polar()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_polar( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_polar';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Convert rectangular to polar, double-precision.}
{
 *  vDSP_polarD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_polarD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_polarD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Convert polar to rectangular, single-precision.}
{
 *  vDSP_rect()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_rect( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_rect';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Convert polar to rectangular, double-precision.}
{
 *  vDSP_rectD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_rectD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_rectD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Root-mean-square of vector, single-precision.}
{
 *  vDSP_rmsqv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_rmsqv( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_rmsqv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Root-mean-square of vector, double-precision.}
{
 *  vDSP_rmsqvD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_rmsqvD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_rmsqvD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Scalar-vector divide, single-precision.}
{
 *  vDSP_svdiv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_svdiv( __vDSP_A: Float32Ptr; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_svdiv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Scalar-vector divide, double-precision.}
{
 *  vDSP_svdivD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_svdivD( __vDSP_A: Float64Ptr; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_svdivD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Sum of vector elements, single-precision.}
{
 *  vDSP_sve()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_sve( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_sve';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Sum of vector elements, double-precision.}
{
 *  vDSP_sveD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_sveD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_sveD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Sum of vector elements magnitudes, single-precision.}
{
 *  vDSP_svemg()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_svemg( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_svemg';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Sum of vector elements' magnitudes, double-precision.}
{
 *  vDSP_svemgD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_svemgD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_svemgD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Sum of vector elements' squares, single-precision.}
{
 *  vDSP_svesq()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_svesq( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_svesq';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Sum of vector elements' squares, double-precision.}
{
 *  vDSP_svesqD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_svesqD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_svesqD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)

{$ifc TARGET_OS_MAC}
{ Sum of vector elements and sum of vector elements' squares,
 * single-precision.
 *
 * vDSP_sve_svesq()
 }
procedure vDSP_sve_svesq( {const} __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; var __vDSP_Sum: Float32; var __vDSP_SumOfSquares: Float32; __vDSP_N: vDSP_Length ); external name '_vDSP_sve_svesq';
(* __OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_NA) *)


{ Sum of vector elements and sum of vector elements' squares,
 * double-precision.
 *
 * vDSP_sve_svesqD()
 }
procedure vDSP_sve_svesqD( {const} __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; var __vDSP_Sum: Float64; var __vDSP_SumOfSquares: Float64; __vDSP_N: vDSP_Length ); external name '_vDSP_sve_svesqD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_NA) *)


{ Normalize elements to zero mean and unit standard deviation,
 * single-precision.
 *
 * vDSP_normalize()
 }
procedure vDSP_normalize( {const} __vDSP_A: Float32Ptr; __vDSP_IA: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_IC: vDSP_Stride; var __vDSP_Mean: Float32; var __vDSP_StandardDeviation: Float32; __vDSP_N: vDSP_Length ); external name '_vDSP_normalize';
(* __OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_NA) *)


{ Normalize elements to zero mean and unit standard deviation,
 * double-precision.
 *
 * vDSP_normalize()
 }
procedure vDSP_normalizeD( {const} __vDSP_A: Float64Ptr; __vDSP_IA: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_IC: vDSP_Stride; var __vDSP_Mean: Float64; var __vDSP_StandardDeviation: Float64; __vDSP_N: vDSP_Length ); external name '_vDSP_normalizeD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_8, __IPHONE_NA) *)
{$endc} { TARGET_OS_MAC }

{ Sum of vector elements' signed squares, single-precision.}
{
 *  vDSP_svs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_svs( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_svs';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Sum of vector elements' signed squares, double-precision.}
{
 *  vDSP_svsD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_svsD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_svsD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector add, add, and multiply, single-precision.}
{
 *  vDSP_vaam()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vaam( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_E: Float32Ptr; __vDSP_M: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vaam';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector add, add, and multiply, double-precision.}
{
 *  vDSP_vaamD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vaamD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_E: Float64Ptr; __vDSP_M: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vaamD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector absolute value, single-precision.}
{
 *  vDSP_vabs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vabs( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vabs';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector absolute value, double-precision.}
{
 *  vDSP_vabsD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vabsD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vabsD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector add, subtract, and multiply, single-precision.}
{
 *  vDSP_vasbm()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vasbm( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_E: Float32Ptr; __vDSP_M: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vasbm';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector add, subtract, and multiply, double-precision.}
{
 *  vDSP_vasbmD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vasbmD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_E: Float64Ptr; __vDSP_M: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vasbmD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector add and scalar multiply, single-precision.}
{
 *  vDSP_vasm()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vasm( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vasm';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector add and scalar multiply, double-precision.}
{
 *  vDSP_vasmD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vasmD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vasmD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector linear average, single-precision.}
{
 *  vDSP_vavlin()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vavlin( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vavlin';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector linear average, double-precision.}
{
 *  vDSP_vavlinD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vavlinD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vavlinD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector clip, single-precision.}
{
 *  vDSP_vclip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vclip( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vclip';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector clip, double-precision.}
{
 *  vDSP_vclipD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vclipD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vclipD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector clip and count, single-precision.}
{
 *  vDSP_vclipc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vclipc( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length; var __vDSP_NLOW: vDSP_Length; var __vDSP_NHI: vDSP_Length ); external name '_vDSP_vclipc';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector clip and count, double-precision.}
{
 *  vDSP_vclipcD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vclipcD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length; var __vDSP_NLOW: vDSP_Length; var __vDSP_NHI: vDSP_Length ); external name '_vDSP_vclipcD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector clear, single-precision.}
{
 *  vDSP_vclr()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vclr( __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vclr';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector clear, double-precision.}
{
 *  vDSP_vclrD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vclrD( __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vclrD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector compress, single-precision.}
{
 *  vDSP_vcmprs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vcmprs( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vcmprs';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector compress, double-precision.}
{
 *  vDSP_vcmprsD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vcmprsD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vcmprsD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to decibels, power, or amplitude, single-precision.}
{
 *  vDSP_vdbcon()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vdbcon( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length; __vDSP_F: UInt32 ); external name '_vDSP_vdbcon';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to decibels, power, or amplitude, double-precision.}
{
 *  vDSP_vdbconD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vdbconD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length; __vDSP_F: UInt32 ); external name '_vDSP_vdbconD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector distance, single-precision.}
{
 *  vDSP_vdist()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vdist( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vdist';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector distance, double-precision.}
{
 *  vDSP_vdistD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vdistD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vdistD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector divide, single-precision.}
{
 *  vDSP_vdiv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vdiv( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vdiv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector divide, double-precision.}
{
 *  vDSP_vdivD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vdivD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vdivD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector envelope, single-precision.}
{
 *  vDSP_venvlp()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_venvlp( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_venvlp';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector envelope, double-precision.}
{
 *  vDSP_venvlpD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_venvlpD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_venvlpD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector fill, single-precision.}
{
 *  vDSP_vfill()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfill( __vDSP_A: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfill';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector fill, double-precision.}
{
 *  vDSP_vfillD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfillD( __vDSP_A: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfillD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to 8-bit integer, round toward zero, single-precision.}
{
 *  vDSP_vfix8()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfix8( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: SInt8Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfix8';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to 8-bit integer, round toward zero, double-precision.}
{
 *  vDSP_vfix8D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfix8D( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: SInt8Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfix8D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to 16-bit integer, round toward zero, single-precision.}
{
 *  vDSP_vfix16()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfix16( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: SInt16Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfix16';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to 16-bit integer, round toward zero, double-precision.}
{
 *  vDSP_vfix16D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfix16D( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: SInt16Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfix16D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to 32-bit integer, round toward zero, single-precision.}
{
 *  vDSP_vfix32()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfix32( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: SInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfix32';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to 32-bit integer, round toward zero, double-precision.}
{
 *  vDSP_vfix32D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfix32D( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: SInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfix32D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to 8-bit integer, round to nearest, single-precision.}
{
 *  vDSP_vfixr8()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixr8( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: SInt8Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixr8';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to 8-bit integer, round to nearest, double-precision.}
{
 *  vDSP_vfixr8D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixr8D( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: SInt8Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixr8D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to 16-bit integer, round to nearest, single-precision.}
{
 *  vDSP_vfixr16()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixr16( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: SInt16Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixr16';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to 16-bit integer, round to nearest, double-precision.}
{
 *  vDSP_vfixr16D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixr16D( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: SInt16Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixr16D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to 32-bit integer, round to nearest, single-precision.}
{
 *  vDSP_vfixr32()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixr32( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: SInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixr32';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to 32-bit integer, round to nearest, double-precision.}
{
 *  vDSP_vfixr32D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixr32D( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: SInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixr32D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to unsigned 8-bit integer, toward zero, single-precision.}
{
 *  vDSP_vfixu8()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixu8( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: UInt8Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixu8';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to unsigned 8-bit integer, toward zero, double-precision.}
{
 *  vDSP_vfixu8D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixu8D( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: UInt8Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixu8D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to unsigned 16-bit integer, toward zero, single-precision.}
{
 *  vDSP_vfixu16()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixu16( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: UInt16Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixu16';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to unsigned 16-bit integer, toward zero, double-precision.}
{
 *  vDSP_vfixu16D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixu16D( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: UInt16Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixu16D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to unsigned 32-bit integer, toward zero, single-precision.}
{
 *  vDSP_vfixu32()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixu32( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: UInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixu32';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to unsigned 32-bit integer, toward zero, double-precision.}
{
 *  vDSP_vfixu32D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixu32D( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: UInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixu32D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to unsigned 8-bit integer, to nearest, single-precision.}
{
 *  vDSP_vfixru8()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixru8( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: UInt8Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixru8';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to unsigned 8-bit integer, to nearest, double-precision.}
{
 *  vDSP_vfixru8D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixru8D( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: UInt8Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixru8D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to unsigned 16-bit integer, to nearest, single-precision.}
{
 *  vDSP_vfixru16()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixru16( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: UInt16Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixru16';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to unsigned 16-bit integer, to nearest, double-precision.}
{
 *  vDSP_vfixru16D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixru16D( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: UInt16Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixru16D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to unsigned 32-bit integer, to nearest, single-precision.}
{
 *  vDSP_vfixru32()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixru32( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: UInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixru32';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert to unsigned 32-bit integer, to nearest, double-precision.}
{
 *  vDSP_vfixru32D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfixru32D( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: UInt32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfixru32D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert from 8-bit integer, single-precision.}
{
 *  vDSP_vflt8()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vflt8( var A: char; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vflt8';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert from 8-bit integer, double-precision.}
{
 *  vDSP_vflt8D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vflt8D( var A: char; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vflt8D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert from 16-bit integer, single-precision.}
{
 *  vDSP_vflt16()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vflt16( var A: SInt16; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vflt16';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert from 16-bit integer, double-precision.}
{
 *  vDSP_vflt16D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vflt16D( var A: SInt16; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vflt16D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert from 32-bit integer, single-precision.}
{
 *  vDSP_vflt32()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vflt32( __vDSP_A: SInt32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vflt32';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert from 32-bit integer, double-precision.}
{
 *  vDSP_vflt32D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vflt32D( __vDSP_A: SInt32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vflt32D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert from 8-bit integer, single-precision.}
{
 *  vDSP_vfltu8()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfltu8( A: UInt8Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfltu8';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert from 8-bit integer, double-precision.}
{
 *  vDSP_vfltu8D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfltu8D( A: UInt8Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfltu8D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert from 16-bit integer, single-precision.}
{
 *  vDSP_vfltu16()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfltu16( A: UInt16Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfltu16';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert from 16-bit integer, double-precision.}
{
 *  vDSP_vfltu16D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfltu16D( A: UInt16Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfltu16D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert from 32-bit integer, single-precision.}
{
 *  vDSP_vfltu32()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfltu32( __vDSP_A: UInt32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfltu32';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector convert from 32-bit integer, double-precision.}
{
 *  vDSP_vfltu32D()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfltu32D( __vDSP_A: UInt32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfltu32D';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector fraction part (subtract integer toward zero), single-precision.}
{
 *  vDSP_vfrac()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfrac( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfrac';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector fraction part (subtract integer toward zero), double-precision.}
{
 *  vDSP_vfracD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vfracD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vfracD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector gather, single-precision.}
{
 *  vDSP_vgathr()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vgathr( __vDSP_A: Float32Ptr; var __vDSP_B: vDSP_Length; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vgathr';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector gather, double-precision.}
{
 *  vDSP_vgathrD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vgathrD( __vDSP_A: Float64Ptr; var __vDSP_B: vDSP_Length; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vgathrD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector gather, absolute pointers, single-precision.}
{
 *  vDSP_vgathra()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vgathra( var A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vgathra';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector gather, absolute pointers, double-precision.}
{
 *  vDSP_vgathraD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vgathraD( var A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vgathraD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector generate tapered ramp, single-precision.}
{
 *  vDSP_vgen()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vgen( __vDSP_A: Float32Ptr; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vgen';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector generate tapered ramp, double-precision.}
{
 *  vDSP_vgenD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vgenD( __vDSP_A: Float64Ptr; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vgenD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector generate by extrapolation and interpolation, single-precision.}
{
 *  vDSP_vgenp()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vgenp( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length; __vDSP_M: vDSP_Length ); external name '_vDSP_vgenp';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector generate by extrapolation and interpolation, double-precision.}
{
 *  vDSP_vgenpD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vgenpD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length; __vDSP_M: vDSP_Length ); external name '_vDSP_vgenpD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector inverted clip, single-precision.}
{
 *  vDSP_viclip()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_viclip( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_viclip';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector inverted clip, double-precision.}
{
 *  vDSP_viclipD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_viclipD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_viclipD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector index (C[i] = A[truncate[B[i]]), single-precision.}
{
 *  vDSP_vindex()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vindex( __vDSP_A: Float32Ptr; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vindex';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector index (C[i] = A[truncate[B[i]]), double-precision.}
{
 *  vDSP_vindexD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vindexD( __vDSP_A: Float64Ptr; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vindexD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector interpolation between vectors, single-precision.}
{
 *  vDSP_vintb()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vintb( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vintb';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector interpolation between vectors, double-precision.}
{
 *  vDSP_vintbD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vintbD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vintbD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector test limit, single-precision.}
{
 *  vDSP_vlim()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vlim( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vlim';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector test limit, double-precision.}
{
 *  vDSP_vlimD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vlimD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vlimD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector linear interpolation, single-precision.}
{
 *  vDSP_vlint()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vlint( __vDSP_A: Float32Ptr; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length; __vDSP_M: vDSP_Length ); external name '_vDSP_vlint';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector linear interpolation, double-precision.}
{
 *  vDSP_vlintD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vlintD( __vDSP_A: Float64Ptr; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length; __vDSP_M: vDSP_Length ); external name '_vDSP_vlintD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector multiply and add, single-precision.}
{
 *  vDSP_vma()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vma( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vma';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector multiply and add, double-precision.}
{
 *  vDSP_vmaD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmaD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmaD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector maxima, single-precision.}
{
 *  vDSP_vmax()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmax( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmax';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector maxima, double-precision.}
{
 *  vDSP_vmaxD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmaxD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmaxD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector maximum magnitude, single-precision.}
{
 *  vDSP_vmaxmg()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmaxmg( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmaxmg';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector maximum magnitude, double-precision.}
{
 *  vDSP_vmaxmgD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmaxmgD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmaxmgD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector minima, single-precision.}
{
 *  vDSP_vmin()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmin( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmin';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector minima, double-precision.}
{
 *  vDSP_vminD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vminD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vminD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector minimum magnitude, single-precision.}
{
 *  vDSP_vminmg()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vminmg( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vminmg';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector minimum magnitude, double-precision.}
{
 *  vDSP_vminmgD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vminmgD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vminmgD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector multiply, multiply, and add, single-precision.}
{
 *  vDSP_vmma()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmma( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_E: Float32Ptr; __vDSP_M: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmma';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector multiply, multiply, and add, double-precision.}
{
 *  vDSP_vmmaD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmmaD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_E: Float64Ptr; __vDSP_M: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmmaD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector multiply, multiply, and subtract, single-precision.}
{
 *  vDSP_vmmsb()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmmsb( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_E: Float32Ptr; __vDSP_M: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmmsb';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector multiply, multiply, and subtract, double-precision.}
{
 *  vDSP_vmmsbD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmmsbD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_E: Float64Ptr; __vDSP_M: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmmsbD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector multiply and scalar add, single-precision.}
{
 *  vDSP_vmsa()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmsa( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmsa';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector multiply and scalar add, double-precision.}
{
 *  vDSP_vmsaD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmsaD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmsaD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector multiply and subtract, single-precision.}
{
 *  vDSP_vmsb()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmsb( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmsb';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector multiply and subtract, double-precision.}
{
 *  vDSP_vmsbD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vmsbD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vmsbD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector negative absolute value, single-precision.}
{
 *  vDSP_vnabs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vnabs( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vnabs';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector negative absolute value, double-precision.}
{
 *  vDSP_vnabsD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vnabsD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vnabsD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector negate, single-precision.}
{
 *  vDSP_vneg()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vneg( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vneg';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector negate, double-precision.}
{
 *  vDSP_vnegD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vnegD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vnegD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector polynomial, single-precision.}
{
 *  vDSP_vpoly()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vpoly( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_vpoly';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector polynomial, single-precision.}
{
 *  vDSP_vpolyD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vpolyD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_vpolyD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector Pythagoras, single-precision.}
{
 *  vDSP_vpythg()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vpythg( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_E: Float32Ptr; __vDSP_M: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vpythg';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector Pythagoras, double-precision.}
{
 *  vDSP_vpythgD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vpythgD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_E: Float64Ptr; __vDSP_M: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vpythgD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector quadratic interpolation, single-precision.}
{
 *  vDSP_vqint()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vqint( __vDSP_A: Float32Ptr; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length; __vDSP_M: vDSP_Length ); external name '_vDSP_vqint';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector quadratic interpolation, double-precision.}
{
 *  vDSP_vqintD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vqintD( __vDSP_A: Float64Ptr; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length; __vDSP_M: vDSP_Length ); external name '_vDSP_vqintD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector build ramp, single-precision.}
{
 *  vDSP_vramp()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vramp( __vDSP_A: Float32Ptr; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vramp';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector build ramp, double-precision.}
{
 *  vDSP_vrampD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vrampD( __vDSP_A: Float64Ptr; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrampD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector running sum integration, single-precision.}
{
 *  vDSP_vrsum()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vrsum( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_S: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrsum';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector running sum integration, double-precision.}
{
 *  vDSP_vrsumD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vrsumD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_S: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrsumD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector reverse order, in-place, single-precision.}
{
 *  vDSP_vrvrs()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vrvrs( __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrvrs';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector reverse order, in-place, double-precision.}
{
 *  vDSP_vrvrsD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vrvrsD( __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrvrsD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector-scalar add, single-precision.}
{
 *  vDSP_vsadd()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsadd( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsadd';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector-scalar add, double-precision.}
{
 *  vDSP_vsaddD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsaddD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsaddD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector subtract and multiply, single-precision.}
{
 *  vDSP_vsbm()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsbm( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsbm';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector subtract and multiply, double-precision.}
{
 *  vDSP_vsbmD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsbmD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsbmD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector subtract, subtract, and multiply, single-precision.}
{
 *  vDSP_vsbsbm()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsbsbm( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_E: Float32Ptr; __vDSP_M: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsbsbm';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector subtract, subtract, and multiply, double-precision.}
{
 *  vDSP_vsbsbmD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsbsbmD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_E: Float64Ptr; __vDSP_M: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsbsbmD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector subtract and scalar multiply, single-precision.}
{
 *  vDSP_vsbsm()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsbsm( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsbsm';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector subtract and scalar multiply, double-precision.}
{
 *  vDSP_vsbsmD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsbsmD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsbsmD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector-scalar divide, single-precision.}
{
 *  vDSP_vsdiv()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsdiv( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsdiv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector-scalar divide, double-precision.}
{
 *  vDSP_vsdivD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsdivD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsdivD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector Simpson integration, single-precision.}
{
 *  vDSP_vsimps()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsimps( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsimps';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector Simpson integration, double-precision.}
{
 *  vDSP_vsimpsD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsimpsD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsimpsD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector-scalar multiply and vector add, single-precision.}
{
 *  vDSP_vsma()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsma( const __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; const __vDSP_B: Float32Ptr; const __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsma';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector-scalar multiply and vector add, double-precision.}
{
 *  vDSP_vsmaD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsmaD( const __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; const __vDSP_B: Float64Ptr; const __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsmaD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector-scalar multiply and scalar add, single-precision.}
{
 *  vDSP_vsmsa()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsmsa( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsmsa';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector-scalar multiply and scalar add, double-precision.}
{
 *  vDSP_vsmsaD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsmsaD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsmsaD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector scalar multiply and vector subtract, single-precision.}
{
 *  vDSP_vsmsb()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsmsb( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsmsb';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector scalar multiply and vector subtract, double-precision.}
{
 *  vDSP_vsmsbD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsmsbD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vsmsbD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector sort, in-place, single-precision.}
{
 *  vDSP_vsort()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsort( __vDSP_C: Float32Ptr; __vDSP_N: vDSP_Length; __vDSP_OFLAG: SInt32 ); external name '_vDSP_vsort';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector sort, in-place, double-precision.}
{
 *  vDSP_vsortD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsortD( __vDSP_C: Float64Ptr; __vDSP_N: vDSP_Length; __vDSP_OFLAG: SInt32 ); external name '_vDSP_vsortD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector sort, in-place, integer, single-precision.}
{
 *  vDSP_vsorti()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsorti( __vDSP_C: Float32Ptr; var __vDSP_IC: vDSP_Length; var __vDSP_List_addr: vDSP_Length; __vDSP_N: vDSP_Length; __vDSP_OFLAG: SInt32 ); external name '_vDSP_vsorti';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector sort, in-place, integer, double-precision.}
{
 *  vDSP_vsortiD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vsortiD( __vDSP_C: Float64Ptr; var __vDSP_IC: vDSP_Length; var __vDSP_List_addr: vDSP_Length; __vDSP_N: vDSP_Length; __vDSP_OFLAG: SInt32 ); external name '_vDSP_vsortiD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector swap, single-precision.}
{
 *  vDSP_vswap()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vswap( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vswap';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector swap, double-precision.}
{
 *  vDSP_vswapD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vswapD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vswapD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector sliding window sum, single-precision.}
{
 *  vDSP_vswsum()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vswsum( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_vswsum';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector sliding window sum, double-precision.}
{
 *  vDSP_vswsumD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vswsumD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length; __vDSP_P: vDSP_Length ); external name '_vDSP_vswsumD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector table lookup and interpolation, single-precision.}
{
 *  vDSP_vtabi()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vtabi( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_S1: Float32Ptr; __vDSP_S2: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_M: vDSP_Length; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vtabi';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector table lookup and interpolation, double-precision.}
{
 *  vDSP_vtabiD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vtabiD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_S1: Float64Ptr; __vDSP_S2: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_M: vDSP_Length; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vtabiD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector threshold, single-precision.}
{
 *  vDSP_vthr()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vthr( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vthr';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector threshold, double-precision.}
{
 *  vDSP_vthrD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vthrD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vthrD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector threshold with zero fill, single-precision.}
{
 *  vDSP_vthres()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vthres( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vthres';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector threshold with zero fill, double-precision.}
{
 *  vDSP_vthresD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vthresD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vthresD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector threshold with signed constant, single-precision.}
{
 *  vDSP_vthrsc()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vthrsc( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_D: Float32Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vthrsc';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector threshold with signed constant, double-precision.}
{
 *  vDSP_vthrscD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vthrscD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_D: Float64Ptr; __vDSP_L: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vthrscD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector tapered merge, single-precision.}
{
 *  vDSP_vtmerg()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vtmerg( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vtmerg';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector tapered merge, double-precision.}
{
 *  vDSP_vtmergD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vtmergD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_J: vDSP_Stride; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vtmergD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector trapezoidal integration, single-precision.}
{
 *  vDSP_vtrapz()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vtrapz( __vDSP_A: Float32Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vtrapz';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Vector trapezoidal integration, double-precision.}
{
 *  vDSP_vtrapzD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_vtrapzD( __vDSP_A: Float64Ptr; __vDSP_I: vDSP_Stride; __vDSP_B: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_K: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vtrapzD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Wiener Levinson, single-precision.}
{
 *  vDSP_wiener()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_wiener( __vDSP_L: vDSP_Length; __vDSP_A: Float32Ptr; __vDSP_C: Float32Ptr; __vDSP_F: Float32Ptr; __vDSP_P: Float32Ptr; __vDSP_IFLG: SInt32; var __vDSP_IERR: SInt32 ); external name '_vDSP_wiener';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{ Wiener Levinson, double-precision.}
{
 *  vDSP_wienerD()
 *  
 *  Availability:
 *    Mac OS X:         in version 10.4 and later in vecLib.framework
 *    CarbonLib:        not available
 *    Non-Carbon CFM:   not available
 }
procedure vDSP_wienerD( __vDSP_L: vDSP_Length; __vDSP_A: Float64Ptr; __vDSP_C: Float64Ptr; __vDSP_F: Float64Ptr; __vDSP_P: Float64Ptr; __vDSP_IFLG: SInt32; var __vDSP_IERR: SInt32 ); external name '_vDSP_wienerD';
(* __OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_4_0) *)


{	vDSP_FFT16_copv and vDSP_FFT32_copv perform 16- and 32-element FFTs on
	interleaved complex unit-stride vector-block-aligned data.

	Parameters:

		float *Output

			Pointer to space for output data (interleaved complex).  This
			address must be vector-block aligned.

		const float *Input

			Pointer to input data (interleaved complex).  This address must be
			vector-block aligned.

		FFT_Direction Direction

			Transform direction, FFT_FORWARD or FFT_INVERSE.

	These routines calculate:

		For 0 <= k < N,

			H[k] = sum(1**(S * j*k/N) * h[j], 0 <= j < N),

	where:

		N is 16 or 32, as specified by the routine name,

		h[j] is Input[2*j+0] + i * Input[2*j+1] at routine entry,

		H[j] is Output[2*j+0] + i * Output[2*j+1] at routine exit,

		S is -1 if Direction is FFT_FORWARD and +1 if Direction is FFT_INVERSE,
		and

		1**x is e**(2*pi*i*x).

	Input and Output may be equal but may not otherwise overlap.
}
procedure vDSP_FFT16_copv( __vDSP_Output: Float32Ptr; {const} __vDSP_Input: Float32Ptr; __vDSP_Direction: FFTDirection ); external name '_vDSP_FFT16_copv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)
procedure vDSP_FFT32_copv( __vDSP_Output: Float32Ptr; {const} __vDSP_Input: Float32Ptr; __vDSP_Direction: FFTDirection ); external name '_vDSP_FFT32_copv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_FFT16_zopv and vDSP_FFT32_zopv perform 16- and 32-element FFTs on
	separated complex unit-stride vector-block-aligned data.

	Parameters:

		float *Or, float *Oi

			Pointers to space for real and imaginary output data.  These
			addresses must be vector-block aligned.

		const float *Ir, *Ii

			Pointers to real and imaginary input data.  These addresses must be
			vector-block aligned.

		FFT_Direction Direction

			Transform direction, FFT_FORWARD or FFT_INVERSE.

	These routines calculate:

		For 0 <= k < N,

			H[k] = sum(1**(S * j*k/N) * h[j], 0 <= j < N),

	where:

		N is 16 or 32, as specified by the routine name,

		h[j] is Ir[j] + i * Ii[j] at routine entry,

		H[j] is Or[j] + i * Oi[j] at routine exit,

		S is -1 if Direction is FFT_FORWARD and +1 if Direction is FFT_INVERSE,
		and

		1**x is e**(2*pi*i*x).

	Or may equal Ir or Ii, and Oi may equal Ii or Ir, but the ararys may not
	otherwise overlap.
}
procedure vDSP_FFT16_zopv( __vDSP_Or: Float32Ptr; __vDSP_Oi: Float32Ptr; {const} __vDSP_Ir: Float32Ptr; {const} __vDSP_Ii: Float32Ptr; __vDSP_Direction: FFTDirection ); external name '_vDSP_FFT16_zopv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)
procedure vDSP_FFT32_zopv( __vDSP_Or: Float32Ptr; __vDSP_Oi: Float32Ptr; {const} __vDSP_Ir: Float32Ptr; {const} __vDSP_Ii: Float32Ptr; __vDSP_Direction: FFTDirection ); external name '_vDSP_FFT32_zopv';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	How to use the Discrete Fourier Transform (DFT) interface.

	There are three steps to performing a DFT:

		Call a setup routine (e.g., vDSP_DFT_zop_CreateSetup) to get a setup
		object.

			This is a preparation step to be done when a program is starting or
			is starting some new phase (e.g., when a communication channel is
			opened).  It should never be done during real-time processing.  The
			setup routine is slow and is called only once to prepare data that
			can be used many times.

		Call an execution routine (e.g., vDSP_DFT_Execute) to perform a DFT,
		and pass it the setup object.

			The execution routine is fast (for selected cases) and is generally
			called many times.

		Call a destroy routine (e.g., vDSP_DFT_DestroySetup) to release the
		memory held by the setup object.

			This is done when a program is ending or is ending some phase.
			After calling a destroy routine, the setup data is no longer valid
			and should not be used.

	Discussion:

		The current sequences of setup, execution, destroy routines are:

			vDSP_DFT_zop_CreateSetup, vDSP_DFT_Execute, vDSP_DFT_DestroySetup;

			vDSP_DFT_zrop_CreateSetup, vDSP_DFT_Execute, vDSP_DFT_DestroySetup;
		
			vDSP_DFT_CreateSetup, vDSP_DFT_zop, vDSP_DFT_DestroySetup.

		Sharing DFT setups:

			Any setup returned by a DFT setup routine may be passed as input to
			any DFT setup routine, in the parameter named Previous.  (This
			allows the setups to share data, avoiding unnecessary duplication
			of some setup data.)  Setup routines may be executed in any order.
			Passing any setup of a group of setups sharing data will result in
			a new setup sharing data with all of the group.

			When calling an execution routine, each setup can be used only with
			its intended execution routine.  Thus the setup returned by
			vDSP_DFT_CreateSetup can only be used with vDSP_DFT_zop and not
			with vDSP_DFT_Execute.

			vDSP_DFT_DestroySetup is used to destroy any DFT setup.

		History:

			vDSP_DFT_CreateSetup and vDSP_DFT_zop are the original vDSP DFT
			routines.  vDSP_DFT_zop_CreateSetup, vDSP_DFT_zrop_CreateSetup, and
			vDSP_DFT_Execute are newer, more specialized DFT routines.  These
			newer routines do not have stride parameters (stride is one) and
			incorporate the direction parameter into the setup.  This reduces
			the number of arguments passed to the execution routine, which
			receives only the setup and four address parameters.  Additionally,
			the complex-to-complex DFT (zop) and real-to-complex DFT (zrop) use
			the same execution routine (the setup indicates which function to
			perform).

			We recommend you use vDSP_DFT_zop_CreateSetup,
			vDPS_DFT_zrop_CreateSetup, and vDSP_DFT_Execute, and that you not
			use vDSP_DFT_CreateSetup and vDSP_DFT_zop.

	Multithreading:

		Never call a setup or destroy routine in a thread when any DFT routine
		(setup, execution, or destroy) that shares setup data may be
		executing.  (This applies not just to multiple threads but also to
		calling DFT routines in signal handlers.)

		Multiple DFT execution routines may be called simultaneously.  (Their
		access to the setup data is read-only.)

		If you need to call setup and/or destroy routines while other DFT
		routines might be executing, you can either use Grand Central Dispatch
		or locks (costs time) to avoid simultaneous execution or you can create
		separate setup objects for them (costs memory).
}


{	A vDSP_DFT_Setup object is a pointer to a structure whose definition is
	unpublished.
}
type
	vDSP_DFT_Setup = ^vDSP_DFT_SetupStruct;
	vDSP_DFT_SetupStruct = record end;


// DFT direction may be specified as vDSP_DFT_FORWARD or vDSP_DFT_INVERSE.
const
  vDSP_DFT_FORWARD = 1;
  vDSP_DFT_INVERSE = -1;
type
	vDSP_DFT_Direction = UInt32;


{	vDSP_DFT_CreateSetup is a DFT setup routine.  It creates a setup object
	for use with the vDSP_DFT_zop execution routine.  We recommend you use
	vDSP_DFT_zop_CreateSetup instead of this routine.

	Parameters:

		vDSP_DFT_Setup Previous

			Previous is either zero or a previous DFT setup.  If a previous
			setup is passed, the new setup will share data with the previous
			setup, if feasible (and with any other setups the previous setup
			shares with).  If zero is passed, the routine will allocate and
			initialize new memory.

		vDSP_Length Length

			Length is the number of complex elements to be transformed.

	Return value:

		Zero is returned if memory is unavailable.

	The returned setup object may be used only with vDSP_DFT_zop for the length
	given during setup.  Unlike previous vDSP FFT routines, the setup may not
	be used to execute transforms with shorter lengths.

	Do not call this routine while any DFT routine sharing setup data might be
	executing.
}
function vDSP_DFT_CreateSetup( __vDSP_Previous: vDSP_DFT_Setup; __vDSP_Length: vDSP_Length ): vDSP_DFT_Setup; external name '_vDSP_DFT_CreateSetup';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_DFT_zop_CreateSetup is a DFT setup routine.  It creates a setup object
	for use with the vDSP_DFT_Execute execution routine, to perform a
	complex-to-complex DFT.

	Parameters:

		vDSP_DFT_Setup Previous

			Previous is either zero or a previous DFT setup.  If a previous
			setup is passed, the new setup will share data with the previous
			setup, if feasible (and with any other setups the previous setup
			shares with).  If zero is passed, the routine will allocate and
			initialize new memory.

		vDSP_Length Length

			Length is the number of complex elements to be transformed.

		vDSP_DFT_Direction Direction

			Transform direction, vDSP_DFT_FORWARD or vDSP_DFT_INVERSE.

	Return value:

		Zero is returned if memory is unavailable or if there is no
		implementation for the requested case.  Currently, the implemented
		cases are:

			Length = f * 2**n, where f is 3, 5, or 15 and 3 <= n.

		Additionally, only cases where the array addresses (passed to
		vDSP_DFT_Execute) are 16-byte aligned are optimized.

	Function:

		When vDSP_DFT_Execute is called with a setup returned from this
		routine, it calculates:

			For 0 <= k < N,

				H[k] = sum(1**(S * j*k/N) * h[j], 0 <= j < N),

		where:

			N is the length given in the setup;

			h is the array of complex numbers specified by Ir and Ii when
			vDSP_DFT_Execute is called:

				for 0 <= j < N,
					h[j] = Ir[j] + i * Ii[j];

			H is the array of complex numbers specified by Or and Oi when
			vDSP_DFT_Execute returns:

				for 0 <= k < N,
					H[k] = Or[k] + i * Oi[k];

			S is -1 if Direction is vDSP_DFT_FORWARD and +1 if Direction is
			vDSP_DFT_INVERSE; and

			1**x is e**(2*pi*i*x).

	Performance:

		Performance is good for these cases:

			All addresses are 16-byte aligned, and the length is f * 2**n,
			where f is 3, 5, or 15 and 3 <= n.

		Performance is extremely slow for all other cases.

	In-Place Operation:

		For the cases with good performance as described above, Or may equal Ir
		and Oi may equal Ii (in the call to vDSP_DFT_Execute).  Otherwise, no
		overlap of Or, Oi, Ir, and Ii is supported.

	The returned setup object may be used only with vDSP_DFT_Execute for the
	length given during setup.  Unlike previous vDSP FFT routines, the setup
	may not be used to execute transforms with shorter lengths.

	Do not call this routine while any DFT routine sharing setup data might be
	executing.
}
function vDSP_DFT_zop_CreateSetup( __vDSP_Previous: vDSP_DFT_Setup; __vDSP_Length: vDSP_Length; __vDSP_Direction: vDSP_DFT_Direction ): vDSP_DFT_Setup; external name '_vDSP_DFT_zop_CreateSetup';
(* __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_4_0) *)


{	vDSP_DFT_zrop_CreateSetup is a DFT setup routine.  It creates a setup
	object for use with the vDSP_DFT_Execute execution routine, to perform a
	real-to-complex DFT or a complex-to-real DFT.

	Parameters:

		vDSP_DFT_Setup Previous

			Previous is either zero or a previous DFT setup.  If a previous
			setup is passed, the new setup will share data with the previous
			setup, if feasible (and with any other setups the previous setup
			shares with).  If zero is passed, the routine will allocate and
			initialize new memory.

		vDSP_Length Length

			Length is the number of real elements to be transformed (in a a
			forward, real-to-complex transform) or produced (in a reverse,
			complex-to-real transform).  Length must be even.

		vDSP_DFT_Direction Direction

			Transform direction, vDSP_DFT_FORWARD or vDSP_DFT_INVERSE.

	Return value:

		Zero is returned if memory is unavailable or if there is no
		implementation for the requested case.  Currently, the implemented
		cases are:

			Length = f * 2**n, where f is 3, 5, or 15 and 4 <= n.

		Additionally, only cases where the array addresses (passed to
		vDSP_DFT_Execute) are 16-byte aligned are optimized.

	Function:

		When vDSP_DFT_Execute is called with a setup returned from this
		routine, it calculates:

			For 0 <= k < N,

				H[k] = C * sum(1**(S * j*k/N) * h[j], 0 <= j < N),

		where:

			N is the Length given in the setup;

			h is the array of numbers specified by Ir and Ii when
			vDSP_DFT_Execute is called (see "Data Layout" below);

			H is the array of numbers specified by Or and Oi when
			vDSP_DFT_Execute returns (see "Data Layout" below);

			C is 2 if Direction is vDSP_DFT_FORWARD and 1 if Direction is
			vDSP_DFT_INVERSE;

			S is -1 if Direction is vDSP_DFT_FORWARD and +1 if Direction is
			vDSP_DFT_INVERSE; and

			1**x is e**(2*pi*i*x).

		Data Layout:

			If Direction is vDSP_DFT_FORWARD, then:

				h is an array of real numbers, with its even-index elements
				stored in Ir and its odd-index elements stored in Ii:

					For 0 <= j < N/2,
						h[2*j+0] = Ir[j], and
						h[2*j+1] = Ii[j].

				H is an array of complex numbers, stored in Or and Oi:

					H[0  ] = Or[0].  (H[0  ] is pure real.)
					H[N/2] = Oi[0].  (H[N/2] is pure real.)
					For 1 < k < N/2,
						H[k] = Or[k] + i * Oi[k].

				For N/2 < k < N, H[k] is not explicitly stored in memory but is
				known because it necessarily equals the conjugate of H[N-k],
				which is stored as described above.

			If Direction is vDSP_DFT_Inverse, then the layouts of the input and
			output arrays are swapped.  Ir and Ii describe an input array with
			complex elements laid out as described above for Or and Oi.  When
			vDSP_DFT_Execute returns, Or and Oi contain a pure real array, with
			its even-index elements stored in Or and its odd-index elements in
			Oi.

	Performance:

		Performance is good for these cases:

			All addresses are 16-byte aligned, and the length is f * 2**n,
			where f is 3, 5, or 15 and 4 <= n.

		Performance is extremely slow for all other cases.

	In-Place Operation:

		For the cases with good performance as described above, Or may equal Ir
		and Oi may equal Ii (in the call to vDSP_DFT_Execute).  Otherwise, no
		overlap of Or, Oi, Ir, and Ii is supported.

	The returned setup object may be used only with vDSP_DFT_Execute for the
	length given during setup.  Unlike previous vDSP FFT routines, the setup
	may not be used to execute transforms with shorter lengths.

	Do not call this routine while any DFT routine sharing setup data might be
	executing.
}
function vDSP_DFT_zrop_CreateSetup( __vDSP_Previous: vDSP_DFT_Setup; __vDSP_Length: vDSP_Length; __vDSP_Direction: vDSP_DFT_Direction ): vDSP_DFT_Setup; external name '_vDSP_DFT_zrop_CreateSetup';
(* __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_4_0) *)


{	vDSP_DFT_DestroySetup is a DFT destroy routine.  It releases the memory
	used by a setup object.

	Parameters:

		vDSP_DFT_Setup Setup

			Setup is the setup object to be released.  The object may have
			been previously allocated with any DFT setup routine, such as
			vDSP_DFT_zop_CreateSetup or vDSP_DFT_zrop_CreateSetup.

	Destroying a setup with shared data is safe; it will release only memory
	not needed by other undestroyed setups.  Memory (and the data it contains)
	is freed only when all setup objects using it have been destroyed.

	Do not call this routine while any DFT routine sharing setup data might be
	executing.
}
procedure vDSP_DFT_DestroySetup( __vDSP_Setup: vDSP_DFT_Setup ); external name '_vDSP_DFT_DestroySetup';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_DFT_zop is a DFT execution routine.  It performs a DFT, with the aid
	of previously created setup data.

	Parameters:

		vDSP_DFT_Setup Setup

			A setup object returned by a previous call to
			vDSP_DFT_zop_CreateSetup.

		const float *Ir
		const float *Ii

			Pointers to real and imaginary components of input data.

		vDSP_Stride Is

			The number of physical elements from one logical input element to
			the next.

		float *Or
		float *Oi

			Pointers to space for real and imaginary components of output
			data.

			The input and output arrays may not overlap except as specified
			in "In-Place Operation", below.

		vDSP_Stride Os

			The number of physical elements from one logical output element to
			the next.

		vDSP_DFT_Direction Direction

			Transform direction, vDSP_DFT_FORWARD or vDSP_DFT_INVERSE.

	Observe there is no separate length parameter.  The length is passed via
	the setup object.

	Performance:

		Performance is good for these cases:

			All addresses are 16-byte aligned, all strides are one, and the
			length is f * 2**n, where f is 3, 5, or 15 and 3 <= n.

		Performance is extremely slow for all other cases.

	In-Place Operation:

		For the cases with good performance as described above, Or may equal Ir
		and Oi may equal Ii.  Otherwise, no overlap of Or, Oi, Ir, and Ii is
		supported.

	This routine calculates:

		For 0 <= k < N,

			H[k] = sum(1**(S * j*k/N) * h[j], 0 <= j < N),

	where:

		N is the length given in the setup,

		h is the array of complex numbers specified by Ir, Ii, and Is at
		routine entry:

			h[j] = Ir[j*Is] + i * Ii[j*Is],
			for 0 <= j < N,

		H is the array of complex numbers stored as specified by Or, Oi, and Os
		at routine exit:

			H[k] = Or[k*Os] + i * Oi[k*Os],
			for 0 <= k < N,

		S is -1 if Direction is vDSP_DFT_FORWARD and +1 if Direction is
		vDSP_DFT_INVERSE, and

		1**x is e**(2*pi*i*x).

	Do not call this routine while any DFT setup or destroy routine sharing
	setup data might be executing.
}
procedure vDSP_DFT_zop( {const} __vDSP_Setup: vDSP_DFT_Setup; {const} __vDSP_Ir: Float32Ptr; {const} __vDSP_Ii: Float32Ptr; __vDSP_Is: vDSP_Stride; __vDSP_Or: Float32Ptr; __vDSP_Oi: Float32Ptr; __vDSP_Os: vDSP_Stride; __vDSP_Direction: vDSP_DFT_Direction ); external name '_vDSP_DFT_zop';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_DFT_Execute is a DFT execution routine.  It performs a DFT, with the
	aid of previously created setup data.

	Parameters:

		vDSP_DFT_Setup Setup

			A setup object returned by a previous call to
			vDSP_DFT_zop_CreateSetup or vDSP_DFT_zrop_CreateSetup.

		const float *Ir
		const float *Ii

			Pointers to input data.

		float *Or
		float *Oi

			Pointers to output data.

			The input and output arrays may not overlap except as specified
			in "In-Place Operation", below.

	Performance and In-Place Operation:

		See notes for the setup routine for the operation being executed.

	Function:

		The function performed by this routine is determined by the setup
		passed to it.  The documentation for the routine used to create the
		setup describes the function.

		Note that different numbers of elements are required when this routine
		is called, depending on the setup used:

			When the setup is from vDSP_zop_CreateSetup, each array (Ir, Ii,
			Or, and Oi) must have Length elements.

			When the setup is from vDSP_zrop_CreateSetup, each array (Ir, Ii,
			Or, and Oi) must have Length/2 elements.

	Do not call this routine while any DFT setup or destroy routine sharing
	setup data might be executing.
}
procedure vDSP_DFT_Execute( {const} __vDSP_Setup: vDSP_DFT_Setup; {const} __vDSP_Ir: Float32Ptr; {const} __vDSP_Ii: Float32Ptr; __vDSP_Or: Float32Ptr; __vDSP_Oi: Float32Ptr ); external name '_vDSP_DFT_Execute';
(* __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_4_0) *)


{	vDSP_dotpr2, vector single-precision stereo dot product.

	Function:

		This routine calculates the dot product of A0 with B and the dot
		product of A1 with B.  This is functionally equivalent to calculating
		two dot products but might execute faster.

		In pseudocode, the operation is:

			sum0 = 0;
			sum1 = 0;
			for (i = 0; i < Length; ++i)
			(
				sum0 += A0[i*A0Stride] * B[i*BStride];
				sum1 += A1[i*A1Stride] * B[i*BStride];
			)
			*C0 = sum0;
			*C1 = sum1;

	Input:

		const float *A0, vDSP_Stride A0Stride.

			Starting address and stride for input vector A0.

		const float *A1, vDSP_Stride A1Stride.

			Starting address and stride for input vector A1.

		const float *B,  vDSP_Stride BStride.

			Starting address and stride for input vector B.

		float *C0.

			Address for dot product of A0 and B.

		float *C1.

			Address for dot product of A1 and B.

		vDSP_Length Length.

			Number of elements in each vector.

	Output:

		The results are written to *C0 and *C1.
}
procedure vDSP_dotpr2( {const} __vDSP_A0: Float32Ptr; __vDSP_A0Stride: vDSP_Stride; {const} __vDSP_A1: Float32Ptr; __vDSP_A1Stride: vDSP_Stride; {const} __vDSP_B: Float32Ptr; __vDSP_BStride: vDSP_Stride; __vDSP_C0: Float32Ptr; __vDSP_C1: Float32Ptr; __vDSP_Length: vDSP_Length ); external name '_vDSP_dotpr2';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_dotpr_s1_15, vector integer 1.15 format dot product.

	Function:

		This routine calculates the dot product of A with B.

		In pseudocode, the operation is:

			sum = 0;
			for (i = 0; i < N; ++i)
			(
				sum0 += A[i*AStride] * B[i*BStride];
			)
			*C = sum;

	The elements are fixed-point numbers, each with one sign bit and 15
	fraction bits.  Where the value of the short int is normally x, it is
	x/32768 for the purposes of this routine.

	Input:

		const short int *A, vDSP_Stride AStride.

			Starting address and stride for input vector A.

		const short int *B,  vDSP_Stride BStride.

			Starting address and stride for input vector B.

		short int *C.

			Address for dot product of A and B.

		vDSP_Length N.

			Number of elements in each vector.

	Output:

		The result is written to *C.
}
procedure vDSP_dotpr_s1_15( {const} __vDSP_A: SInt16Ptr; __vDSP_AStride: vDSP_Stride; {const} __vDSP_B: SInt16Ptr; __vDSP_BStride: vDSP_Stride; __vDSP_C: SInt16Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_dotpr_s1_15';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_dotpr2_s1_15, vector integer 1.15 format stereo dot product.

	Function:

		This routine calculates the dot product of A0 with B and the dot
		product of A1 with B.  This is functionally equivalent to calculating
		two dot products but might execute faster.

		In pseudocode, the operation is:

			sum0 = 0;
			sum1 = 0;
			for (i = 0; i < N; ++i)
			(
				sum0 += A0[i*A0Stride] * B[i*BStride];
				sum1 += A1[i*A1Stride] * B[i*BStride];
			)
			*C0 = sum0;
			*C1 = sum1;

	The elements are fixed-point numbers, each with one sign bit and 15
	fraction bits.  Where the value of the short int is normally x, it is
	x/32768 for the purposes of this routine.

	Input:

		const short int *A0, vDSP_Stride A0Stride.

			Starting address and stride for input vector A0.

		const short int *A1, vDSP_Stride A1Stride.

			Starting address and stride for input vector A1.

		const short int *B,  vDSP_Stride BStride.

			Starting address and stride for input vector B.

		short int *C0.

			Address for dot product of A0 and B.

		short int *C1.

			Address for dot product of A1 and B.

		vDSP_Length N.

			Number of elements in each vector.

	Output:

		The results are written to *C0 and *C1.
}
procedure vDSP_dotpr2_s1_15( {const} __vDSP_A0: SInt16Ptr; __vDSP_A0Stride: vDSP_Stride; {const} __vDSP_A1: SInt16Ptr; __vDSP_A1Stride: vDSP_Stride; {const} __vDSP_B: SInt16Ptr; __vDSP_BStride: vDSP_Stride; __vDSP_C0: SInt16Ptr; __vDSP_C1: SInt16Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_dotpr2_s1_15';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_dotpr_s8_24, vector integer 8.24 format dot product.

	Function:

		This routine calculates the dot product of A with B.

		In pseudocode, the operation is:

			sum = 0;
			for (i = 0; i < N; ++i)
			(
				sum0 += A[i*AStride] * B[i*BStride];
			)
			*C = sum;

	The elements are fixed-point numbers, each with eight integer bits
	(including sign) and 24 fraction bits.  Where the value of the int is
	normally x, it is x/16777216 for the purposes of this routine.

	Input:

		const int *A, vDSP_Stride AStride.

			Starting address and stride for input vector A.

		const int *B,  vDSP_Stride BStride.

			Starting address and stride for input vector B.

		int *C.

			Address for dot product of A and B.

		vDSP_Length N.

			Number of elements in each vector.

	Output:

		The result is written to *C.
}
procedure vDSP_dotpr_s8_24( {const} __vDSP_A: SInt32Ptr; __vDSP_AStride: vDSP_Stride; {const} __vDSP_B: SInt32Ptr; __vDSP_BStride: vDSP_Stride; __vDSP_C: SInt32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_dotpr_s8_24';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_dotpr2_s8_24, vector integer 8.24 format stereo dot product.

	Function:

		This routine calculates the dot product of A0 with B and the dot
		product of A1 with B.  This is functionally equivalent to calculating
		two dot products but might execute faster.

		In pseudocode, the operation is:

			sum0 = 0;
			sum1 = 0;
			for (i = 0; i < N; ++i)
			(
				sum0 += A0[i*A0Stride] * B[i*BStride];
				sum1 += A1[i*A1Stride] * B[i*BStride];
			)
			*C0 = sum0;
			*C1 = sum1;

	The elements are fixed-point numbers, each with eight integer bits
	(including sign) and 24 fraction bits.  Where the value of the int is
	normally x, it is x/16777216 for the purposes of this routine.

	Input:

		const int *A0, vDSP_Stride A0Stride.

			Starting address and stride for input vector A0.

		const int *A1, vDSP_Stride A1Stride.

			Starting address and stride for input vector A1.

		const int *B,  vDSP_Stride BStride.

			Starting address and stride for input vector B.

		int *C0.

			Address for dot product of A0 and B.

		int *C1.

			Address for dot product of A1 and B.

		vDSP_Length N.

			Number of elements in each vector.

	Output:

		The results are written to *C0 and *C1.
}
procedure vDSP_dotpr2_s8_24( {const} __vDSP_A0: SInt32Ptr; __vDSP_A0Stride: vDSP_Stride; {const} __vDSP_A1: SInt32Ptr; __vDSP_A1Stride: vDSP_Stride; {const} __vDSP_B: SInt32Ptr; __vDSP_BStride: vDSP_Stride; __vDSP_C0: SInt32Ptr; __vDSP_C1: SInt32Ptr; __vDSP_N: vDSP_Length ); external name '_vDSP_dotpr2_s8_24';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_vrampmul, vector single-precision vramp and multiply.

	This routine puts into O the product of I and a ramp function with initial
	value *Start and slope *Step.  *Start is updated to continue the ramp
	in a consecutive call.  To continue the ramp smoothly, the new value of
	*Step includes rounding errors accumulated during the routine rather than
	being calculated directly as *Start + N * *Step.

	This routine calculates:

		for (i = 0; i < N; ++i)
		(
			O[i*OS] = *Start * I[i*IS];
			*Start += *Step;
		)

	Input:

		const float *I, vDSP_Stride IS.

			Starting address and stride for the input vector.

		float *Start.

			Starting value for the ramp.

		const float *Step.

			Value of the step for the ramp.

		float *O, vDSP_Stride *OS.

			Starting address and stride for the output vector.

		vDSP_Length Length.

			Number of elements in each vector.

	Output:

		The results are written to O.

		On return, *Start contains initial *Start + N * *Step.
}
procedure vDSP_vrampmul( {const} __vDSP_I: Float32Ptr; __vDSP_IS: vDSP_Stride; {var} __vDSP_Start: Float32Ptr; {const} __vDSP_Step: Float32Ptr; __vDSP_O: Float32Ptr; __vDSP_OS: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrampmul';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_vrampmuladd, vector single-precision vramp, multiply and add.

	This routine adds to O the product of I and a ramp function with initial
	value *Start and slope *Step.  *Start is updated to continue the ramp in a
	consecutive call.  To continue the ramp smoothly, the new value of *Step
	includes rounding errors accumulated during the routine rather than being
	calculated directly as *Start + N * *Step.

	This routine calculates:

		for (i = 0; i < N; ++i)
		(
			O[i*OS] += *Start * I[i*IS];
			*Start += *Step;
		)

	Input:

		const float *I, vDSP_Stride IS.

			Starting address and stride for the input vector.

		float *Start.

			Starting value for the ramp.

		const float *Step.

			Value of the step for the ramp.

		float *O, vDSP_Stride *OS.

			Starting address and stride for the output vector.

		vDSP_Length Length.

			Number of elements in each vector.

	Output:

		The results are added to O.

		On return, *Start contains initial *Start + N * *Step.
}
procedure vDSP_vrampmuladd( {const} __vDSP_I: Float32Ptr; __vDSP_IS: vDSP_Stride; __vDSP_Start: Float32Ptr; {const} __vDSP_Step: Float32Ptr; __vDSP_O: Float32Ptr; __vDSP_OS: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrampmuladd';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_vrampmul2, stereo vector single-precision vramp and multiply.

	This routine:

		Puts into O0 the product of I0 and a ramp function with initial value
		*Start and slope *Step.

		Puts into O1 the product of I1 and a ramp function with initial value
		*Start and slope *Step.

	*Start is updated to continue the ramp in a consecutive call.  To continue
	the ramp smoothly, the new value of *Step includes rounding errors
	accumulated during the routine rather than being calculated directly as
	*Start + N * *Step.

	This routine calculates:

		for (i = 0; i < N; ++i)
		(
			O0[i*OS] = *Start * I0[i*IS];
			O1[i*OS] = *Start * I1[i*IS];
			*Start += *Step;
		)

	Input:

		const float *I0, const float *I1, vDSP_Stride IS.

			Starting addresses of both inputs and stride for the input vectors.

		float *Start.

			Starting value for the ramp.

		const float *Step.

			Value of the step for the ramp.

		float *O0, float *O1, vDSP_Stride *OS.

			Starting addresses of both outputs and stride for the output vectors.

		vDSP_Length Length.

			Number of elements in each vector.

	Output:

		The results are written to O0 and O1.

		On return, *Start contains initial *Start + N * *Step.
}
procedure vDSP_vrampmul2( {const} __vDSP_I0: Float32Ptr; {const} __vDSP_I1: Float32Ptr; __vDSP_IS: vDSP_Stride; __vDSP_Start: Float32Ptr; {const} __vDSP_Step: Float32Ptr; __vDSP_O0: Float32Ptr; __vDSP_O1: Float32Ptr; __vDSP_OS: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrampmul2';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_vrampmuladd2, stereo vector single-precision vramp, multiply and add.

	This routine:

		Adds to O0 the product of I0 and a ramp function with initial value
		*Start and slope *Step.

		Adds to O1 the product of I1 and a ramp function with initial value
		*Start and slope *Step.

	*Start is updated to continue the ramp in a consecutive call.  To continue
	the ramp smoothly, the new value of *Step includes rounding errors
	accumulated during the routine rather than being calculated directly as
	*Start + N * *Step.

	This routine calculates:

		for (i = 0; i < N; ++i)
		(
			O0[i*OS] += *Start * I0[i*IS];
			O1[i*OS] += *Start * I1[i*IS];
			*Start += *Step;
		)

	Input:

		const float *I0, const float *I1, vDSP_Stride IS.

			Starting addresses of both inputs and stride for the input vectors.

		float *Start.

			Starting value for the ramp.

		const float *Step.

			Value of the step for the ramp.

		float *O0, float *O1, vDSP_Stride *OS.

			Starting addresses of both outputs and stride for the output vectors.

		vDSP_Length Length.

			Number of elements in each vector.

	Output:

		The results are written to O0 and O1.

		On return, *Start contains initial *Start + N * *Step.
}
procedure vDSP_vrampmuladd2( {const} __vDSP_I0: Float32Ptr; {const} __vDSP_I1: Float32Ptr; __vDSP_IS: vDSP_Stride; __vDSP_Start: Float32Ptr; {const} __vDSP_Step: Float32Ptr; __vDSP_O0: Float32Ptr; __vDSP_O1: Float32Ptr; __vDSP_OS: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrampmuladd2';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_vrampmul_s1_15, vector integer 1.15 format vramp and multiply.

	This routine puts into O the product of I and a ramp function with initial
	value *Start and slope *Step.  *Start is updated to continue the ramp
	in a consecutive call.

	This routine calculates:

		for (i = 0; i < N; ++i)
		(
			O[i*OS] = *Start * I[i*IS];
			*Start += *Step;
		)

	The elements are fixed-point numbers, each with one sign bit and 15
	fraction bits.  Where the value of the short int is normally x, it is
	x/32768 for the purposes of this routine.

	Input:

		const short int *I, vDSP_Stride IS.

			Starting address and stride for the input vector.

		short int *Start.

			Starting value for the ramp.

		const short int *Step.

			Value of the step for the ramp.

		short int *O, vDSP_Stride *OS.

			Starting address and stride for the output vector.

		vDSP_Length Length.

			Number of elements in each vector.

	Output:

		The results are written to O.

		On return, *Start contains initial *Start + N * *Step.
}
procedure vDSP_vrampmul_s1_15( {const} __vDSP_I: SInt16Ptr; __vDSP_IS: vDSP_Stride; __vDSP_Start: SInt16Ptr; {const} __vDSP_Step: SInt16Ptr; __vDSP_O: SInt16Ptr; __vDSP_OS: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrampmul_s1_15';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_vrampmuladd_s1_15, vector integer 1.15 format vramp, multiply and add.

	This routine adds to O the product of I and a ramp function with initial
	value *Start and slope *Step.  *Start is updated to continue the ramp in a
	consecutive call.

	This routine calculates:

		for (i = 0; i < N; ++i)
		(
			O[i*OS] += *Start * I[i*IS];
			*Start += *Step;
		)

	The elements are fixed-point numbers, each with one sign bit and 15
	fraction bits.  Where the value of the short int is normally x, it is
	x/32768 for the purposes of this routine.

	Input:

		const short int *I, vDSP_Stride IS.

			Starting address and stride for the input vector.

		short int *Start.

			Starting value for the ramp.

		const short int *Step.

			Value of the step for the ramp.

		short int *O, vDSP_Stride *OS.

			Starting address and stride for the output vector.

		vDSP_Length Length.

			Number of elements in each vector.

	Output:

		The results are added to O.

		On return, *Start contains initial *Start + N * *Step.
}
procedure vDSP_vrampmuladd_s1_15( {const} __vDSP_I: SInt16Ptr; __vDSP_IS: vDSP_Stride; __vDSP_Start: SInt16Ptr; {const} __vDSP_Step: SInt16Ptr; __vDSP_O: SInt16Ptr; __vDSP_OS: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrampmuladd_s1_15';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_vrampmul2_s1_15, stereo vector integer 1.15 format vramp and multiply.

	This routine:

		Puts into O0 the product of I0 and a ramp function with initial value
		*Start and slope *Step.

		Puts into O1 the product of I1 and a ramp function with initial value
		*Start and slope *Step.

	*Start is updated to continue the ramp in a consecutive call.

	This routine calculates:

		for (i = 0; i < N; ++i)
		(
			O0[i*OS] = *Start * I0[i*IS];
			O1[i*OS] = *Start * I1[i*IS];
			*Start += *Step;
		)

	The elements are fixed-point numbers, each with one sign bit and 15
	fraction bits.  Where the value of the short int is normally x, it is
	x/32768 for the purposes of this routine.

	Input:

		const short int *I0, const short int *I1, vDSP_Stride IS.

			Starting addresses of both inputs and stride for the input vectors.

		short int *Start.

			Starting value for the ramp.

		const short int *Step.

			Value of the step for the ramp.

		short int *O0, short int *O1, vDSP_Stride *OS.

			Starting addresses of both outputs and stride for the output vectors.

		vDSP_Length Length.

			Number of elements in each vector.

	Output:

		The results are written to O0 and O1.

		On return, *Start contains initial *Start + N * *Step.

}
procedure vDSP_vrampmul2_s1_15( {const} __vDSP_I0: SInt16Ptr; {const} __vDSP_I1: SInt16Ptr; __vDSP_IS: vDSP_Stride; __vDSP_Start: SInt16Ptr; {const} __vDSP_Step: SInt16Ptr; __vDSP_O0: SInt16Ptr; __vDSP_O1: SInt16Ptr; __vDSP_OS: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrampmul2_s1_15';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_vrampmuladd2_s1_15, stereo vector integer 1.15 format vramp, multiply
	and add.

	This routine:

		Adds to O0 the product of I0 and a ramp function with initial value
		*Start and slope *Step.

		Adds to O1 the product of I1 and a ramp function with initial value
		*Start and slope *Step.

	*Start is updated to continue the ramp in a consecutive call.

	This routine calculates:

		for (i = 0; i < N; ++i)
		(
			O0[i*OS] += *Start * I0[i*IS];
			O1[i*OS] += *Start * I1[i*IS];
			*Start += *Step;
		)

	The elements are fixed-point numbers, each with one sign bit and 15
	fraction bits.  Where the value of the short int is normally x, it is
	x/32768 for the purposes of this routine.

	Input:

		const short int *I0, const short int *I1, vDSP_Stride IS.

			Starting addresses of both inputs and stride for the input vectors.

		short int *Start.

			Starting value for the ramp.

		const short int *Step.

			Value of the step for the ramp.

		short int *O0, short int *O1, vDSP_Stride *OS.

			Starting addresses of both outputs and stride for the output vectors.

		vDSP_Length Length.

			Number of elements in each vector.

	Output:

		The results are added to O0 and O1.

		On return, *Start contains initial *Start + N * *Step.

}
procedure vDSP_vrampmuladd2_s1_15( {const} __vDSP_I0: SInt16Ptr; {const} __vDSP_I1: SInt16Ptr; __vDSP_IS: vDSP_Stride; __vDSP_Start: SInt16Ptr; {const} __vDSP_Step: SInt16Ptr; __vDSP_O0: SInt16Ptr; __vDSP_O1: SInt16Ptr; __vDSP_OS: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrampmuladd2_s1_15';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_vrampmul_s8_24, vector integer 8.24 format vramp and multiply.

	This routine puts into O the product of I and a ramp function with initial
	value *Start and slope *Step.  *Start is updated to continue the ramp
	in a consecutive call.

	This routine calculates:

		for (i = 0; i < N; ++i)
		(
			O[i*OS] = *Start * I[i*IS];
			*Start += *Step;
		)

	The elements are fixed-point numbers, each with eight integer bits
	(including sign) and 24 fraction bits.  Where the value of the int is
	normally x, it is x/16777216 for the purposes of this routine.

	Input:

		const int *I, vDSP_Stride IS.

			Starting address and stride for the input vector.

		int *Start.

			Starting value for the ramp.

		const int *Step.

			Value of the step for the ramp.

		int *O, vDSP_Stride *OS.

			Starting address and stride for the output vector.

		vDSP_Length Length.

			Number of elements in each vector.

	Output:

		The results are written to O.

		On return, *Start contains initial *Start + N * *Step.
}
procedure vDSP_vrampmul_s8_24( {const} __vDSP_I: SInt32Ptr; __vDSP_IS: vDSP_Stride; __vDSP_Start: SInt32Ptr; {const} __vDSP_Step: SInt32Ptr; __vDSP_O: SInt32Ptr; __vDSP_OS: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrampmul_s8_24';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_vrampmuladd_s8_24, vector integer 8.24 format vramp, multiply and add.

	This routine adds to O the product of I and a ramp function with initial
	value *Start and slope *Step.  *Start is updated to continue the ramp in a
	consecutive call.

	This routine calculates:

		for (i = 0; i < N; ++i)
		(
			O[i*OS] += *Start * I[i*IS];
			*Start += *Step;
		)

	The elements are fixed-point numbers, each with eight integer bits
	(including sign) and 24 fraction bits.  Where the value of the int is
	normally x, it is x/16777216 for the purposes of this routine.

	Input:

		const int *I, vDSP_Stride IS.

			Starting address and stride for the input vector.

		int *Start.

			Starting value for the ramp.

		const int *Step.

			Value of the step for the ramp.

		int *O, vDSP_Stride *OS.

			Starting address and stride for the output vector.

		vDSP_Length Length.

			Number of elements in each vector.

	Output:

		The results are added to O.

		On return, *Start contains initial *Start + N * *Step.
}
procedure vDSP_vrampmuladd_s8_24( {const} __vDSP_I: SInt32Ptr; __vDSP_IS: vDSP_Stride; var __vDSP_Start: SInt32; {const} __vDSP_Step: SInt32Ptr; __vDSP_O: SInt32Ptr; __vDSP_OS: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrampmuladd_s8_24';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_vrampmul2_s8_24, stereo vector integer 8.24 format vramp and multiply.

	This routine:

		Puts into O0 the product of I0 and a ramp function with initial value
		*Start and slope *Step.

		Puts into O1 the product of I1 and a ramp function with initial value
		*Start and slope *Step.

	*Start is updated to continue the ramp in a consecutive call.

	This routine calculates:

		for (i = 0; i < N; ++i)
		(
			O0[i*OS] = *Start * I0[i*IS];
			O1[i*OS] = *Start * I1[i*IS];
			*Start += *Step;
		)

	The elements are fixed-point numbers, each with eight integer bits
	(including sign) and 24 fraction bits.  Where the value of the int is
	normally x, it is x/16777216 for the purposes of this routine.

	Input:

		const int *I0, const int *I1, vDSP_Stride IS.

			Starting addresses of both inputs and stride for the input vectors.

		int *Start.

			Starting value for the ramp.

		const int *Step.

			Value of the step for the ramp.

		int *O0, int *O1, vDSP_Stride *OS.

			Starting addresses of both outputs and stride for the output vectors.

		vDSP_Length Length.

			Number of elements in each vector.

	Output:

		The results are written to O0 and O1.

		On return, *Start contains initial *Start + N * *Step.

}
procedure vDSP_vrampmul2_s8_24( {const} __vDSP_I0: SInt32Ptr; {const} __vDSP_I1: SInt32Ptr; __vDSP_IS: vDSP_Stride; __vDSP_Start: SInt32Ptr; {const} __vDSP_Step: SInt32Ptr; __vDSP_O0: SInt32Ptr; __vDSP_O1: SInt32Ptr; __vDSP_OS: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrampmul2_s8_24';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)


{	vDSP_vrampmuladd2_s8_24, stereo vector integer 8.24 format vramp, multiply
	and add.

	This routine:

		Adds to O0 the product of I0 and a ramp function with initial value
		*Start and slope *Step.

		Adds to O1 the product of I1 and a ramp function with initial value
		*Start and slope *Step.

	*Start is updated to continue the ramp in a consecutive call.

	This routine calculates:

		for (i = 0; i < N; ++i)
		(
			O0[i*OS] += *Start * I0[i*IS];
			O1[i*OS] += *Start * I1[i*IS];
			*Start += *Step;
		)

	The elements are fixed-point numbers, each with eight integer bits
	(including sign) and 24 fraction bits.  Where the value of the int is
	normally x, it is x/16777216 for the purposes of this routine.

	Input:

		const int *I0, const int *I1, vDSP_Stride IS.

			Starting addresses of both inputs and stride for the input vectors.

		int *Start.

			Starting value for the ramp.

		const int *Step.

			Value of the step for the ramp.

		int *O0, int *O1, vDSP_Stride *OS.

			Starting addresses of both outputs and stride for the output vectors.

		vDSP_Length Length.

			Number of elements in each vector.

	Output:

		The results are written to O0 and O1.

		On return, *Start contains initial *Start + N * *Step.

}
procedure vDSP_vrampmuladd2_s8_24( {const} __vDSP_I0: SInt32Ptr; {const} __vDSP_I1: SInt32Ptr; __vDSP_IS: vDSP_Stride; __vDSP_Start: SInt32Ptr; {const} __vDSP_Step: SInt32Ptr; __vDSP_O0: SInt32Ptr; __vDSP_O1: SInt32Ptr; __vDSP_OS: vDSP_Stride; __vDSP_N: vDSP_Length ); external name '_vDSP_vrampmuladd2_s8_24';
(* __OSX_AVAILABLE_STARTING(__MAC_10_6, __IPHONE_4_0) *)

{$ifc undefined USE_NONE_APPLE_STANDARD_DATATYPES}
{$setc USE_NON_APPLE_STANDARD_DATATYPES := 1}
{$endc} {not defined USE_NON_APPLE_STANDARD_DATATYPES }

{$ifc USE_NON_APPLE_STANDARD_DATATYPES}
const
	FFT_FORWARD = kFFTDirection_Forward;
	FFT_INVERSE = kFFTDirection_Inverse;

const
	FFT_RADIX2 = kFFTRadix2;
	FFT_RADIX3 = kFFTRadix3;
	FFT_RADIX5 = kFFTRadix5;

type
	COMPLEX = DSPComplex;
	COMPLEX_SPLIT = DSPSplitComplex;
	DOUBLE_COMPLEX = DSPDoubleComplex;
	DOUBLE_COMPLEX_SPLIT = DSPDoubleSplitComplex;
{$endc} {USE_NON_APPLE_STANDARD_DATATYPES}

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
