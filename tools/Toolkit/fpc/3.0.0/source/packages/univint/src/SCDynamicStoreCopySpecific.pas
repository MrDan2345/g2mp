{
 * Copyright (c) 2000-2005, 2008 Apple Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 * 
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 * 
 * @APPLE_LICENSE_HEADER_END@
 }
{  Pascal Translation:  Peter N Lewis, <peter@stairways.com.au>, 2004 }
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

unit SCDynamicStoreCopySpecific;
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
uses MacTypes,CFBase,SCDynamicStore,MacOSXPosix,CFString,CFDictionary;
{$endc} {not MACOSALLINCLUDE}


{ until the __IPHONE_NA is automatically handled }
{$ifc TARGET_OS_MAC}

{$ALIGN POWER}

{!
	@header SCDynamicStoreCopySpecific
	@discussion The functions of the SCDynamicStoreCopySpecific API
		allow an application to determine specific configuration
		information about the current system (for example, the
		computer or sharing name, the currently logged-in user, etc.).
 }


{!
	@function SCDynamicStoreCopyComputerName
	@discussion Gets the current computer name.
	@param store An SCDynamicStoreRef representing the dynamic store
		session that should be used for communication with the server.
		If NULL, a temporary session will be used.
	@param nameEncoding A pointer to memory that, if non-NULL, will be
		filled with the encoding associated with the computer or
		host name.
	@result Returns the current computer name;
		NULL if the name has not been set or if an error was encountered.
		You must release the returned value.
 }
function SCDynamicStoreCopyComputerName( store: SCDynamicStoreRef; nameEncoding: CFStringEncodingPtr ): CFStringRef; external name '_SCDynamicStoreCopyComputerName';
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

{!
	@function SCDynamicStoreCopyConsoleUser
	@discussion Gets the name, user ID, and group ID of the currently
		logged-in user.

		Note: this function only provides information about the
		      primary console.  It does not provide any details
		      about console sessions that have fast user switched
		      out or about other consoles.
	@param store An SCDynamicStoreRef representing the dynamic store
		session that should be used for communication with the server.
		If NULL, a temporary session will be used.
	@param uid A pointer to memory that will be filled with the user ID
		of the current console user. If NULL, this value will not
		be returned.
	@param gid A pointer to memory that will be filled with the group ID
		of the current console user. If NULL, this value will not be
		returned.
	@result Returns the user currently logged into the system;
		NULL if no user is logged in or if an error was encountered.
		You must release the returned value.
 }
function SCDynamicStoreCopyConsoleUser( store: SCDynamicStoreRef; uid: uid_t_ptr; gid: gid_t_ptr ): CFStringRef; external name '_SCDynamicStoreCopyConsoleUser';
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

{!
	@function SCDynamicStoreCopyLocalHostName
	@discussion Gets the current local host name.
	@param store An SCDynamicStoreRef representing the dynamic store
		session that should be used for communication with the server.
		If NULL, a temporary session will be used.
	@result Returns the current local host name;
		NULL if the name has not been set or if an error was encountered.
		You must release the returned value.
 }
function SCDynamicStoreCopyLocalHostName( store: SCDynamicStoreRef ): CFStringRef; external name '_SCDynamicStoreCopyLocalHostName';
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

{!
	@function SCDynamicStoreCopyLocation
	@discussion Gets the current location identifier.
	@param store An SCDynamicStoreRef representing the dynamic store
		session that should be used for communication with the server.
		If NULL, a temporary session will be used.
	@result Returns a string representing the current location identifier;
		NULL if no location identifier has been defined or if an error
		was encountered.
		You must release the returned value.
 }
function SCDynamicStoreCopyLocation( store: SCDynamicStoreRef ): CFStringRef; external name '_SCDynamicStoreCopyLocation';
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

{!
	@function SCDynamicStoreCopyProxies
	@discussion Gets the current internet proxy settings.
		The returned proxy settings dictionary includes:

		<TABLE BORDER>
		<TR>
			<TH>key</TD>
			<TH>type</TD>
			<TH>description</TD>
		</TR>
		<TR>
			<TD>kSCPropNetProxiesExceptionsList</TD>
			<TD>CFArray[CFString]</TD>
			<TD>Host name patterns which should bypass the proxy</TD>
		</TR>
		<TR>
			<TD>kSCPropNetProxiesHTTPEnable</TD>
			<TD>CFNumber (0 or 1)</TD>
			<TD>Enables/disables the use of an HTTP proxy</TD>
		</TR>
		<TR>
			<TD>kSCPropNetProxiesHTTPProxy</TD>
			<TD>CFString</TD>
			<TD>The proxy host</TD>
		</TR>
		<TR>
			<TD>kSCPropNetProxiesHTTPPort</TD>
			<TD>CFNumber</TD>
			<TD>The proxy port number</TD>
		</TR>
		<TR>
			<TD>kSCPropNetProxiesHTTPSEnable</TD>
			<TD>CFNumber (0 or 1)</TD>
			<TD>Enables/disables the use of an HTTPS proxy</TD>
		</TR>
		<TR>
			<TD>kSCPropNetProxiesHTTPSProxy</TD>
			<TD>CFString</TD>
			<TD>The proxy host</TD>
		</TR>
		<TR>
			<TD>kSCPropNetProxiesHTTPSPort</TD>
			<TD>CFNumber</TD>
			<TD>The proxy port number</TD>
		</TR>
		<TR>
			<TD>kSCPropNetProxiesFTPEnable</TD>
			<TD>CFNumber (0 or 1)</TD>
			<TD>Enables/disables the use of an FTP proxy</TD>
		</TR>
		<TR>
			<TD>kSCPropNetProxiesFTPProxy</TD>
			<TD>CFString</TD>
			<TD>The proxy host</TD>
		</TR>
		<TR>
			<TD>kSCPropNetProxiesFTPPort</TD>
			<TD>CFNumber</TD>
			<TD>The proxy port number</TD>
		</TR>
		<TR>
			<TD>kSCPropNetProxiesFTPPassive</TD>
			<TD>CFNumber (0 or 1)</TD>
			<TD>Enable passive mode operation for use behind connection
			filter-ing firewalls.</TD>
		</TR>
		</TABLE>

		Other key-value pairs are defined in the SCSchemaDefinitions.h
		header file.
	@param store An SCDynamicStoreRef representing the dynamic store
		session that should be used for communication with the server.
		If NULL, a temporary session will be used.
	@result Returns a dictionary containing key-value pairs that represent
		the current internet proxy settings;
		NULL if no proxy settings have been defined or if an error
		was encountered.
		You must release the returned value.
 }
function SCDynamicStoreCopyProxies( store: SCDynamicStoreRef ): CFDictionaryRef; external name '_SCDynamicStoreCopyProxies';
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

{$endc} {TARGET_OS_MAC}

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
