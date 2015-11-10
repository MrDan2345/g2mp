{
     File:       CarbonCore/DriverSynchronization.h
 
     Contains:   Driver Synchronization Interfaces.
                 The contents of this header file are deprecated.
                 Use OSAtomic API instead.
 
     Copyright:  � 1985-2011 by Apple Inc. All rights reserved.
}
{   Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, October 2009 }
{   Pascal Translation Updated:  Jonas Maebe, <jonas@freepascal.org>, September 2012 }
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

unit DriverSynchronization;
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


{$ifc TARGET_OS_MAC}

{$ALIGN POWER}


{
 *  CompareAndSwap()
 *  
 *  Summary:
 *    Compare and swap operation, performed atomically with respect to
 *    all devices that participate in the coherency architecture of the
 *    platform.
 *  
 *  Discussion:
 *    The CompareAndSwap function compares the value at the specified
 *    address with oldVal. The value of newValue is written to the
 *    address only if oldValue and the value at the address are equal.
 *    CompareAndSwap returns true if newValue is written to the
 *    address; otherwise, it returns false.
 *    This function guarantees atomicity only with main system memory.
 *    It is specifically unsuitable for use on noncacheable memory such
 *    as that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Parameters:
 *    
 *    oldValue:
 *      The value to compare at address.
 *    
 *    newValue:
 *      The value to write to address if oldValue compares true.
 *    
 *    address:
 *      The 4-byte aligned address of the data to update atomically.
 *  
 *  Result:
 *    true if newValue was written to the address.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function CompareAndSwap( oldValue: UInt32; newValue: UInt32; var address: UInt32 ): Boolean; external name '_CompareAndSwap';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  TestAndClear()
 *  
 *  Summary:
 *    Bit test and clear operation, performed atomically with respect
 *    to all devices that participate in the coherency architecture of
 *    the platform.
 *  
 *  Discussion:
 *    The TestAndClear function clears a single bit in a byte at a
 *    specified address. It returns false if the bit was already clear,
 *    true otherwise.
 *     ------------------------------------------------------------
 *     THIS ROUTINE WAS DOCUMENTED AS RETURNING TRUE IF THE BIT WAS
 *    ALREADY CLEAR AND FALSE OTHERWISE, and on MAC OS 9.x and earlier
 *    it did have this behavior, but on Mac OS X 10.0 and later it has
 *    always returned the state of the bit before the operation ( false
 *    if the bit was clear; true if it was set ).  We have decided that
 *    changing the documentation ( leaving the implementation as is )
 *    is less risky than changing the implementation to match the
 *    documented behavior.
 *     ------------------------------------------------------------
 *     This function guarantees atomicity only with main system memory.
 *    It is specifically unsuitable for use on noncacheable memory such
 *    as that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Parameters:
 *    
 *    bit:
 *      The bit number in the range 0 through 7.
 *    
 *    address:
 *      The address of the byte to update atomically.
 *  
 *  Result:
 *    true if the bit was already clear, false otherwise.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function TestAndClear( bit: UInt32; address: UnivPtr ): Boolean; external name '_TestAndClear';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  TestAndSet()
 *  
 *  Summary:
 *    Bit test and set operation, performed atomically with respect to
 *    all devices that participate in the coherency architecture of the
 *    platform.
 *    This function guarantees atomicity only with main system memory.
 *    It is specifically unsuitable for use on noncacheable memory such
 *    as that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Discussion:
 *    The TestAndSet function sets a single bit in a byte at a
 *    specified address. It returns true if the bit was already set,
 *    false otherwise.
 *  
 *  Parameters:
 *    
 *    bit:
 *      The bit number in the range 0 through 7.
 *    
 *    address:
 *      The address of the byte to update atomically.
 *  
 *  Result:
 *    true if the bit was already set, false otherwise.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function TestAndSet( bit: UInt32; address: UnivPtr ): Boolean; external name '_TestAndSet';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  IncrementAtomic8()
 *  
 *  Summary:
 *    8-bit increment operation, performed atomically with respect to
 *    all devices that participate in the coherency architecture of the
 *    platform.
 *  
 *  Discussion:
 *    The IncrementAtomic8 function increments the value at the
 *    specified address by one and returns the original value. 
 *     This function guarantees atomicity only with main system memory.
 *    It is specifically unsuitable for use on noncacheable memory such
 *    as that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Parameters:
 *    
 *    address:
 *      The address of the value to update atomically.
 *  
 *  Result:
 *    The value before the increment.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function IncrementAtomic8( var address: SInt8 ): SInt8; external name '_IncrementAtomic8';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  DecrementAtomic8()
 *  
 *  Summary:
 *    8-bit decrement operation, performed atomically with respect to
 *    all devices that participate in the coherency architecture of the
 *    platform.
 *  
 *  Discussion:
 *    The DecrementAtomic8 function decrements the value at the
 *    specified address by one and returns the original value.
 *    This function guarantees atomicity only with main system memory.
 *    It is specifically unsuitable for use on noncacheable memory such
 *    as that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Parameters:
 *    
 *    address:
 *      The address of the value to update atomically.
 *  
 *  Result:
 *    The value before the decrement.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function DecrementAtomic8( var address: SInt8 ): SInt8; external name '_DecrementAtomic8';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  AddAtomic8()
 *  
 *  Summary:
 *    8-bit add operation, performed atomically with respect to all
 *    devices that participate in the coherency architecture of the
 *    platform.
 *  
 *  Discussion:
 *    The AddAtomic8 function adds the specified amount to the value at
 *    the specified address and returns the original value.
 *    This function guarantees atomicity only with main system memory.
 *    It is specifically unsuitable for use on noncacheable memory such
 *    as that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Parameters:
 *    
 *    amount:
 *      The amount to add.
 *    
 *    address:
 *      The address of the value to update atomically.
 *  
 *  Result:
 *    The value before the addition
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function AddAtomic8( amount: SInt32; var address: SInt8 ): SInt8; external name '_AddAtomic8';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  BitAndAtomic8()
 *  
 *  Summary:
 *    8-bit logical and operation, performed atomically with respect to
 *    all devices that participate in the coherency architecture of the
 *    platform.
 *  
 *  Discussion:
 *    The BitAndAtomic8 function logically ands the bits of the
 *    specified mask into the value at the specified address and
 *    returns the original value.
 *    This function guarantees atomicity only with main system memory.
 *    It is specifically unsuitable for use on noncacheable memory such
 *    as that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Parameters:
 *    
 *    mask:
 *      The mask to logically and with the value.
 *    
 *    address:
 *      The address of the value to update atomically.
 *  
 *  Result:
 *    The value before the bitwise operation.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function BitAndAtomic8( mask: UInt32; var address: UInt8 ): UInt8; external name '_BitAndAtomic8';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  BitOrAtomic8()
 *  
 *  Summary:
 *    8-bit logical or operation, performed atomically with respect to
 *    all devices that participate in the coherency architecture of the
 *    platform.
 *    This function guarantees atomicity only with main system memory.
 *    It is specifically unsuitable for use on noncacheable memory such
 *    as that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Discussion:
 *    The BitOrAtomic8 function logically ors the bits of the specified
 *    mask into the value at the specified address and returns the
 *    original value.
 *  
 *  Parameters:
 *    
 *    mask:
 *      The mask to logically or with the value.
 *    
 *    address:
 *      The address of the value to update atomically.
 *  
 *  Result:
 *    The value before the bitwise operation.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function BitOrAtomic8( mask: UInt32; var address: UInt8 ): UInt8; external name '_BitOrAtomic8';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  BitXorAtomic8()
 *  
 *  Summary:
 *    8-bit logical xor operation, performed atomically with respect to
 *    all devices that participate in the coherency architecture of the
 *    platform.
 *    This function guarantees atomicity only with main system memory.
 *    It is specifically unsuitable for use on noncacheable memory such
 *    as that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Discussion:
 *    The BitXorAtomic8 function logically xors the bits of the
 *    specified mask into the value at the specified address and
 *    returns the original value.
 *  
 *  Parameters:
 *    
 *    mask:
 *      The mask to logically or with the value.
 *    
 *    address:
 *      The address of the value to update atomically.
 *  
 *  Result:
 *    The value before the bitwise operation.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function BitXorAtomic8( mask: UInt32; var address: UInt8 ): UInt8; external name '_BitXorAtomic8';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  IncrementAtomic16()
 *  
 *  Summary:
 *    16-bit increment operation, performed atomically with respect to
 *    all devices that participate in the coherency architecture of the
 *    platform.
 *  
 *  Discussion:
 *    The IncrementAtomic16 function increments the value at the
 *    specified address by one and returns the original value. 
 *     This function guarantees atomicity only with main system memory.
 *    It is specifically unsuitable for use on noncacheable memory such
 *    as that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Parameters:
 *    
 *    address:
 *      The 2-byte aligned address of the value to update atomically.
 *  
 *  Result:
 *    The value before the increment.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function IncrementAtomic16( var address: SInt16 ): SInt16; external name '_IncrementAtomic16';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  DecrementAtomic16()
 *  
 *  Summary:
 *    16-bit decrement operation, performed atomically with respect to
 *    all devices that participate in the coherency architecture of the
 *    platform.
 *  
 *  Discussion:
 *    The DecrementAtomic16 function decrements the value at the
 *    specified address by one and returns the original value. 
 *     This function guarantees atomicity only with main system memory.
 *    It is specifically unsuitable for use on noncacheable memory such
 *    as that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Parameters:
 *    
 *    address:
 *      The 2-byte aligned address of the value to update atomically.
 *  
 *  Result:
 *    The value before the decrement.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function DecrementAtomic16( var address: SInt16 ): SInt16; external name '_DecrementAtomic16';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  AddAtomic16()
 *  
 *  Summary:
 *    16-bit add operation, performed atomically with respect to all
 *    devices that participate in the coherency architecture of the
 *    platform.
 *  
 *  Discussion:
 *    The AddAtomic16 function adds the specified amount to the value
 *    at the specified address and returns the original value.
 *    This function guarantees atomicity only with main system memory.
 *    It is specifically unsuitable for use on noncacheable memory such
 *    as that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Parameters:
 *    
 *    amount:
 *      The amount to add.
 *    
 *    address:
 *      The 2-byte aligned address of the value to update atomically.
 *  
 *  Result:
 *    The value before the addition
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function AddAtomic16( amount: SInt32; var address: SInt16 ): SInt16; external name '_AddAtomic16';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  BitAndAtomic16()
 *  
 *  Summary:
 *    16-bit logical and operation, performed atomically with respect
 *    to all devices that participate in the coherency architecture of
 *    the platform.
 *  
 *  Discussion:
 *    The BitAndAtomic16 function logically ands the bits of the
 *    specified mask into the value at the specified address and
 *    returns the original value.
 *    This function guarantees atomicity only with main system memory.
 *    It is specifically unsuitable for use on noncacheable memory such
 *    as that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Parameters:
 *    
 *    mask:
 *      The mask to logically and with the value.
 *    
 *    address:
 *      The 2-byte aligned address of the value to update atomically.
 *  
 *  Result:
 *    The value before the bitwise operation.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function BitAndAtomic16( mask: UInt32; var address: UInt16 ): UInt16; external name '_BitAndAtomic16';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  BitOrAtomic16()
 *  
 *  Summary:
 *    16-bit logical or operation, performed atomically with respect to
 *    all devices that participate in the coherency architecture of the
 *    platform.
 *  
 *  Discussion:
 *    The BitOrAtomic16 function logically ors the bits of the
 *    specified mask into the value at the specified address and
 *    returns the original value. This function guarantees atomicity
 *    only with main system memory. It is specifically unsuitable for
 *    use on noncacheable memory such as that in devices; this function
 *    cannot guarantee atomicity, for example, on memory mapped from a
 *    PCI device.
 *  
 *  Parameters:
 *    
 *    mask:
 *      The mask to logically or with the value.
 *    
 *    address:
 *      The 2-byte aligned address of the value to update atomically.
 *  
 *  Result:
 *    The value before the bitwise operation.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function BitOrAtomic16( mask: UInt32; var address: UInt16 ): UInt16; external name '_BitOrAtomic16';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  BitXorAtomic16()
 *  
 *  Summary:
 *    16-bit logical xor operation, performed atomically with respect
 *    to all devices that participate in the coherency architecture of
 *    the platform.
 *  
 *  Discussion:
 *    The BitXorAtomic16 function logically xors the bits of the
 *    specified mask into the value at the specified address and
 *    returns the original value. This function guarantees atomicity
 *    only with main system memory. It is specifically unsuitable for
 *    use on noncacheable memory such as that in devices; this function
 *    cannot guarantee atomicity, for example, on memory mapped from a
 *    PCI device.
 *  
 *  Parameters:
 *    
 *    mask:
 *      The mask to logically or with the value.
 *    
 *    address:
 *      The 2-byte aligned address of the value to update atomically.
 *  
 *  Result:
 *    The value before the bitwise operation.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function BitXorAtomic16( mask: UInt32; var address: UInt16 ): UInt16; external name '_BitXorAtomic16';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  IncrementAtomic()
 *  
 *  Summary:
 *    32-bit increment operation, performed atomically with respect to
 *    all devices that participate in the coherency architecture of the
 *    platform.
 *  
 *  Discussion:
 *    The IncrementAtomic function increments the value at the
 *    specified address by one and returns the original value. This
 *    function guarantees atomicity only with main system memory. It is
 *    specifically unsuitable for use on noncacheable memory such as
 *    that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Parameters:
 *    
 *    address:
 *      The 4-byte aligned address of the value to update atomically.
 *  
 *  Result:
 *    The value before the increment.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function IncrementAtomic( var address: SInt32 ): SInt32; external name '_IncrementAtomic';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  DecrementAtomic()
 *  
 *  Summary:
 *    32-bit decrement operation, performed atomically with respect to
 *    all devices that participate in the coherency architecture of the
 *    platform.
 *  
 *  Discussion:
 *    The DecrementAtomic function decrements the value at the
 *    specified address by one and returns the original value. This
 *    function guarantees atomicity only with main system memory. It is
 *    specifically unsuitable for use on noncacheable memory such as
 *    that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Parameters:
 *    
 *    address:
 *      The 4-byte aligned address of the value to update atomically.
 *  
 *  Result:
 *    The value before the decrement.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function DecrementAtomic( var address: SInt32 ): SInt32; external name '_DecrementAtomic';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  AddAtomic()
 *  
 *  Summary:
 *    32-bit add operation, performed atomically with respect to all
 *    devices that participate in the coherency architecture of the
 *    platform.
 *  
 *  Discussion:
 *    The AddAtomic function adds the specified amount to the value at
 *    the specified address and returns the original value. This
 *    function guarantees atomicity only with main system memory. It is
 *    specifically unsuitable for use on noncacheable memory such as
 *    that in devices; this function cannot guarantee atomicity, for
 *    example, on memory mapped from a PCI device.
 *  
 *  Parameters:
 *    
 *    amount:
 *      The amount to add.
 *    
 *    address:
 *      The 4-byte aligned address of the value to update atomically.
 *  
 *  Result:
 *    The value before the addition
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function AddAtomic( amount: SInt32; var address: SInt32 ): SInt32; external name '_AddAtomic';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  BitAndAtomic()
 *  
 *  Summary:
 *    32-bit logical and operation, performed atomically with respect
 *    to all devices that participate in the coherency architecture of
 *    the platform.
 *  
 *  Discussion:
 *    The BitAndAtomic function logically ands the bits of the
 *    specified mask into the value at the specified address and
 *    returns the original value. This function guarantees atomicity
 *    only with main system memory. It is specifically unsuitable for
 *    use on noncacheable memory such as that in devices; this function
 *    cannot guarantee atomicity, for example, on memory mapped from a
 *    PCI device.
 *  
 *  Parameters:
 *    
 *    mask:
 *      The mask to logically and with the value.
 *    
 *    address:
 *      The 4-byte aligned address of the value to update atomically.
 *  
 *  Result:
 *    The value before the bitwise operation
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function BitAndAtomic( mask: UInt32; var address: UInt32 ): UInt32; external name '_BitAndAtomic';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  BitOrAtomic()
 *  
 *  Summary:
 *    32-bit logical or operation, performed atomically with respect to
 *    all devices that participate in the coherency architecture of the
 *    platform.
 *  
 *  Discussion:
 *    The BitOrAtomic function logically ors the bits of the specified
 *    mask into the value at the specified address and returns the
 *    original value. This function guarantees atomicity only with main
 *    system memory. It is specifically unsuitable for use on
 *    noncacheable memory such as that in devices; this function cannot
 *    guarantee atomicity, for example, on memory mapped from a PCI
 *    device.
 *  
 *  Parameters:
 *    
 *    mask:
 *      The mask to logically or with the value.
 *    
 *    address:
 *      The 4-byte aligned address of the value to update atomically.
 *  
 *  Result:
 *    The value before the bitwise operation.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function BitOrAtomic( mask: UInt32; var address: UInt32 ): UInt32; external name '_BitOrAtomic';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)


{
 *  BitXorAtomic()
 *  
 *  Summary:
 *    32-bit logical xor operation, performed atomically with respect
 *    to all devices that participate in the coherency architecture of
 *    the platform. This function guarantees atomicity only with main
 *    system memory. It is specifically unsuitable for use on
 *    noncacheable memory such as that in devices; this function cannot
 *    guarantee atomicity, for example, on memory mapped from a PCI
 *    device.
 *  
 *  Discussion:
 *    The BitXorAtomic function logically xors the bits of the
 *    specified mask into the value at the specified address and
 *    returns the original value.
 *  
 *  Parameters:
 *    
 *    mask:
 *      The mask to logically or with the value.
 *    
 *    address:
 *      The 4-byte aligned address of the value to update atomically.
 *  
 *  Result:
 *    The value before the bitwise operation.
 *  
 *  Availability:
 *    Mac OS X:         in version 10.0 and later in CoreServices.framework
 *    CarbonLib:        in CarbonLib 1.0 and later
 *    Non-Carbon CFM:   in InterfaceLib 8.5 and later
 }
function BitXorAtomic( mask: UInt32; var address: UInt32 ): UInt32; external name '_BitXorAtomic';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0, __MAC_10_8, __IPHONE_NA, __IPHONE_NA) *)

{$endc} {TARGET_OS_MAC}
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
