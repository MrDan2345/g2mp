{
 * Copyright (c) 2000-2011 Apple Inc. All rights reserved.
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

unit SCSchemaDefinitions;
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
uses MacTypes,CFBase;
{$endc} {not MACOSALLINCLUDE}

{$ALIGN POWER}


{
 * This file is automatically generated
 * DO NOT EDIT!
 }

{
 * Reserved Keys
 *
 *   kSCResvLink                                        "__LINK__"                     CFString
 *   kSCResvInactive                                    "__INACTIVE__"
 *
 * Generic Keys
 *
 *   kSCPropInterfaceName                               "InterfaceName"                CFString
 *   kSCPropMACAddress                                  "MACAddress"                   CFString
 *   kSCPropUserDefinedName                             "UserDefinedName"              CFString
 *   kSCPropVersion                                     "Version"                      CFString
 *
 * Preference Keys
 *
 *   kSCPrefCurrentSet                                  "CurrentSet"                   CFString
 *   kSCPrefNetworkServices                             "NetworkServices"              CFDictionary
 *   kSCPrefSets                                        "Sets"                         CFDictionary
 *   kSCPrefSystem                                      "System"                       CFDictionary
 *
 * Component Keys
 *
 *   kSCCompNetwork                                     "Network"
 *   kSCCompService                                     "Service"
 *   kSCCompGlobal                                      "Global"
 *   kSCCompHostNames                                   "HostNames"
 *   kSCCompInterface                                   "Interface"
 *   kSCCompSystem                                      "System"
 *   kSCCompUsers                                       "Users"
 *
 *   --- Regex pattern which matches any component ---
 *   kSCCompAnyRegex                                    "[^/]+"
 *
 * Network Entity Keys
 *
 *   kSCEntNetAirPort                                   "AirPort"                      CFDictionary
 *   kSCEntNetDHCP                                      "DHCP"                         CFDictionary
 *   kSCEntNetDNS                                       "DNS"                          CFDictionary
 *   kSCEntNetEthernet                                  "Ethernet"                     CFDictionary
 *   kSCEntNetFireWire                                  "FireWire"                     CFDictionary
 *   kSCEntNetInterface                                 "Interface"                    CFDictionary
 *   kSCEntNetIPSec                                     "IPSec"                        CFDictionary
 *   kSCEntNetIPv4                                      "IPv4"                         CFDictionary
 *   kSCEntNetIPv6                                      "IPv6"                         CFDictionary
 *   kSCEntNetL2TP                                      "L2TP"                         CFDictionary
 *   kSCEntNetLink                                      "Link"                         CFDictionary
 *   kSCEntNetModem                                     "Modem"                        CFDictionary
 *   kSCEntNetPPP                                       "PPP"                          CFDictionary
 *   kSCEntNetPPPoE                                     "PPPoE"                        CFDictionary
 *   kSCEntNetPPPSerial                                 "PPPSerial"                    CFDictionary
 *   kSCEntNetPPTP                                      "PPTP"                         CFDictionary
 *   kSCEntNetProxies                                   "Proxies"                      CFDictionary
 *   kSCEntNetSMB                                       "SMB"                          CFDictionary
 *   kSCEntNet6to4                                      "6to4"                         CFDictionary
 *
 * kSCCompNetwork Properties
 *
 *   kSCPropNetOverridePrimary                          "OverridePrimary"              CFNumber (0 or 1)
 *   kSCPropNetServiceOrder                             "ServiceOrder"                 CFArray[CFString]
 *   kSCPropNetPPPOverridePrimary                       "PPPOverridePrimary"           CFNumber (0 or 1)
 *
 * kSCCompNetworkInterface Properties
 *
 *   kSCPropNetInterfaces                               "Interfaces"                   CFArray[CFString]
 *
 * kSCCompNetworkHostNames Properties
 *
 *   kSCPropNetLocalHostName                            "LocalHostName"                CFString
 *
 * kSCEntNetAirPort (Hardware) Entity Keys
 *
 *   kSCPropNetAirPortAllowNetCreation                  "AllowNetCreation"             CFNumber (0 or 1)
 *   kSCPropNetAirPortAuthPassword                      "AuthPassword"                 CFData
 *   kSCPropNetAirPortAuthPasswordEncryption            "AuthPasswordEncryption"       CFString
 *   kSCPropNetAirPortJoinMode                          "JoinMode"                     CFString
 *   kSCPropNetAirPortPowerEnabled                      "PowerEnabled"                 CFNumber (0 or 1)
 *   kSCPropNetAirPortPreferredNetwork                  "PreferredNetwork"             CFString
 *   kSCPropNetAirPortSavePasswords                     "SavePasswords"                CFNumber (0 or 1)
 *
 *   --- kSCPropNetAirPortJoinMode values ---
 *   kSCValNetAirPortJoinModeAutomatic                  "Automatic"
 *   kSCValNetAirPortJoinModePreferred                  "Preferred"
 *   kSCValNetAirPortJoinModeRanked                     "Ranked"
 *   kSCValNetAirPortJoinModeRecent                     "Recent"
 *   kSCValNetAirPortJoinModeStrongest                  "Strongest"
 *
 *   --- kSCPropNetAirPortPasswordEncryption values ---
 *   kSCValNetAirPortAuthPasswordEncryptionKeychain     "Keychain"
 *
 * kSCEntNetDNS Entity Keys
 *
 *   kSCPropNetDNSDomainName                            "DomainName"                   CFString
 *   kSCPropNetDNSOptions                               "Options"                      CFString
 *   kSCPropNetDNSSearchDomains                         "SearchDomains"                CFArray[CFString]
 *   kSCPropNetDNSSearchOrder                           "SearchOrder"                  CFNumber
 *   kSCPropNetDNSServerAddresses                       "ServerAddresses"              CFArray[CFString]
 *   kSCPropNetDNSServerPort                            "ServerPort"                   CFNumber
 *   kSCPropNetDNSServerTimeout                         "ServerTimeout"                CFNumber
 *   kSCPropNetDNSSortList                              "SortList"                     CFArray[CFString]
 *   kSCPropNetDNSSupplementalMatchDomains              "SupplementalMatchDomains"     CFArray[CFString]
 *   kSCPropNetDNSSupplementalMatchOrders               "SupplementalMatchOrders"      CFArray[CFNumber]
 *
 * kSCEntNetEthernet (Hardware) Entity Keys
 *
 *   kSCPropNetEthernetMediaSubType                     "MediaSubType"                 CFString
 *   kSCPropNetEthernetMediaOptions                     "MediaOptions"                 CFArray[CFString]
 *   kSCPropNetEthernetMTU                              "MTU"                          CFNumber
 *
 * kSCEntNetFireWire (Hardware) Entity Keys
 *
 *   * RESERVED FOR FUTURE USE *
 *
 * kSCEntNetInterface Entity Keys
 *
 *   kSCPropNetInterfaceDeviceName                      "DeviceName"                   CFString
 *   kSCPropNetInterfaceHardware                        "Hardware"                     CFString
 *   kSCPropNetInterfaceType                            "Type"                         CFString
 *   kSCPropNetInterfaceSubType                         "SubType"                      CFString
 *   kSCPropNetInterfaceSupportsModemOnHold             "SupportsModemOnHold"          CFNumber (0 or 1)
 *
 *   --- kSCPropNetInterfaceType values ---
 *   kSCValNetInterfaceTypeEthernet                     "Ethernet"
 *   kSCValNetInterfaceTypeFireWire                     "FireWire"
 *   kSCValNetInterfaceTypePPP                          "PPP"
 *   kSCValNetInterfaceType6to4                         "6to4"
 *   kSCValNetInterfaceTypeIPSec                        "IPSec"
 *
 *   --- kSCPropNetServiceSubType values (for PPP) ---
 *   kSCValNetInterfaceSubTypePPPoE                     "PPPoE"
 *   kSCValNetInterfaceSubTypePPPSerial                 "PPPSerial"
 *   kSCValNetInterfaceSubTypePPTP                      "PPTP"
 *   kSCValNetInterfaceSubTypeL2TP                      "L2TP"
 *
 * kSCEntNetIPSec Entity Keys
 *
 *   kSCPropNetIPSecAuthenticationMethod                "AuthenticationMethod"         CFString
 *   kSCPropNetIPSecLocalCertificate                    "LocalCertificate"             CFData
 *   kSCPropNetIPSecLocalIdentifier                     "LocalIdentifier"              CFString
 *   kSCPropNetIPSecLocalIdentifierType                 "LocalIdentifierType"          CFString
 *   kSCPropNetIPSecSharedSecret                        "SharedSecret"                 CFString
 *   kSCPropNetIPSecSharedSecretEncryption              "SharedSecretEncryption"       CFString
 *   kSCPropNetIPSecConnectTime                         "ConnectTime"                  CFNumber
 *   kSCPropNetIPSecRemoteAddress                       "RemoteAddress"                CFString
 *   kSCPropNetIPSecStatus                              "Status"                       CFNumber
 *   kSCPropNetIPSecXAuthEnabled                        "XAuthEnabled"                 CFNumber (0 or 1)
 *   kSCPropNetIPSecXAuthName                           "XAuthName"                    CFString
 *   kSCPropNetIPSecXAuthPassword                       "XAuthPassword"                CFString
 *   kSCPropNetIPSecXAuthPasswordEncryption             "XAuthPasswordEncryption"      CFString
 *
 *   --- kSCPropNetIPSecAuthenticationMethod values ---
 *   kSCValNetIPSecAuthenticationMethodSharedSecret     "SharedSecret"
 *   kSCValNetIPSecAuthenticationMethodCertificate      "Certificate"
 *   kSCValNetIPSecAuthenticationMethodHybrid           "Hybrid"
 *
 *   --- kSCPropNetIPSecLocalIdentifierType values ---
 *   kSCValNetIPSecLocalIdentifierTypeKeyID             "KeyID"
 *
 *   --- kSCPropNetIPSecSharedSecretEncryption values ---
 *   kSCValNetIPSecSharedSecretEncryptionKeychain       "Keychain"
 *
 *   --- kSCPropNetIPSecXAuthPasswordEncryption values ---
 *   kSCValNetIPSecXAuthPasswordEncryptionKeychain      "Keychain"
 *   kSCValNetIPSecXAuthPasswordEncryptionPrompt        "Prompt"
 *
 * kSCEntNetIPv4 Entity Keys
 *
 *   kSCPropNetIPv4Addresses                            "Addresses"                    CFArray[CFString]
 *   kSCPropNetIPv4ConfigMethod                         "ConfigMethod"                 CFString
 *   kSCPropNetIPv4DHCPClientID                         "DHCPClientID"                 CFString
 *   kSCPropNetIPv4Router                               "Router"                       CFString
 *   kSCPropNetIPv4SubnetMasks                          "SubnetMasks"                  CFArray[CFString]
 *   kSCPropNetIPv4DestAddresses                        "DestAddresses"                CFArray[CFString]
 *   kSCPropNetIPv4BroadcastAddresses                   "BroadcastAddresses"           CFArray[CFString]
 *
 *   --- kSCPropNetIPv4ConfigMethod values ---
 *   kSCValNetIPv4ConfigMethodAutomatic                 "Automatic"
 *   kSCValNetIPv4ConfigMethodBOOTP                     "BOOTP"
 *   kSCValNetIPv4ConfigMethodDHCP                      "DHCP"
 *   kSCValNetIPv4ConfigMethodINFORM                    "INFORM"
 *   kSCValNetIPv4ConfigMethodLinkLocal                 "LinkLocal"
 *   kSCValNetIPv4ConfigMethodManual                    "Manual"
 *   kSCValNetIPv4ConfigMethodPPP                       "PPP"
 *
 * kSCEntNetIPv6 Entity Keys
 *
 *   kSCPropNetIPv6Addresses                            "Addresses"                    CFArray[CFString]
 *   kSCPropNetIPv6ConfigMethod                         "ConfigMethod"                 CFString
 *   kSCPropNetIPv6DestAddresses                        "DestAddresses"                CFArray[CFString]
 *   kSCPropNetIPv6Flags                                "Flags"                        CFNumber
 *   kSCPropNetIPv6PrefixLength                         "PrefixLength"                 CFArray[CFNumber]
 *   kSCPropNetIPv6Router                               "Router"                       CFString
 *
 *   --- kSCPropNetIPv6ConfigMethod values ---
 *   kSCValNetIPv6ConfigMethodAutomatic                 "Automatic"
 *   kSCValNetIPv6ConfigMethodLinkLocal                 "LinkLocal"
 *   kSCValNetIPv6ConfigMethodManual                    "Manual"
 *   kSCValNetIPv6ConfigMethodRouterAdvertisement       "RouterAdvertisement"
 *   kSCValNetIPv6ConfigMethod6to4                      "6to4"
 *
 * kSCEntNet6to4 Entity Keys
 *
 *   kSCPropNet6to4Relay                                "Relay"                        CFString
 *
 * kSCEntNetLink Entity Keys
 *
 *   kSCPropNetLinkActive                               "Active"                       CFBoolean
 *   kSCPropNetLinkDetaching                            "Detaching"                    CFBoolean
 *
 * kSCEntNetModem (Hardware) Entity Keys
 *
 *   kSCPropNetModemAccessPointName                     "AccessPointName"              CFString
 *   kSCPropNetModemConnectionPersonality               "ConnectionPersonality"        CFString
 *   kSCPropNetModemConnectionScript                    "ConnectionScript"             CFString
 *   kSCPropNetModemConnectSpeed                        "ConnectSpeed"                 CFNumber
 *   kSCPropNetModemDataCompression                     "DataCompression"              CFNumber (0 or 1)
 *   kSCPropNetModemDeviceContextID                     "DeviceContextID"              CFString
 *   kSCPropNetModemDeviceModel                         "DeviceModel"                  CFString
 *   kSCPropNetModemDeviceVendor                        "DeviceVendor"                 CFString
 *   kSCPropNetModemDialMode                            "DialMode"                     CFString
 *   kSCPropNetModemErrorCorrection                     "ErrorCorrection"              CFNumber (0 or 1)
 *   kSCPropNetModemHoldCallWaitingAudibleAlert         "HoldCallWaitingAudibleAlert"  CFNumber (0 or 1)
 *   kSCPropNetModemHoldDisconnectOnAnswer              "HoldDisconnectOnAnswer"       CFNumber (0 or 1)
 *   kSCPropNetModemHoldEnabled                         "HoldEnabled"                  CFNumber (0 or 1)
 *   kSCPropNetModemHoldReminder                        "HoldReminder"                 CFNumber (0 or 1)
 *   kSCPropNetModemHoldReminderTime                    "HoldReminderTime"             CFNumber
 *   kSCPropNetModemNote                                "Note"                         CFString
 *   kSCPropNetModemPulseDial                           "PulseDial"                    CFNumber (0 or 1)
 *   kSCPropNetModemSpeaker                             "Speaker"                      CFNumber (0 or 1)
 *   kSCPropNetModemSpeed                               "Speed"                        CFNumber
 *
 *   --- kSCPropNetModemDialMode values ---
 *   kSCValNetModemDialModeIgnoreDialTone               "IgnoreDialTone"
 *   kSCValNetModemDialModeManual                       "Manual"
 *   kSCValNetModemDialModeWaitForDialTone              "WaitForDialTone"
 *
 * kSCEntNetPPP Entity Keys
 *
 *   kSCPropNetPPPACSPEnabled                           "ACSPEnabled"                  CFNumber (0 or 1)
 *   kSCPropNetPPPConnectTime                           "ConnectTime"                  CFNumber
 *   kSCPropNetPPPDeviceLastCause                       "DeviceLastCause"              CFNumber
 *   kSCPropNetPPPDialOnDemand                          "DialOnDemand"                 CFNumber (0 or 1)
 *   kSCPropNetPPPDisconnectOnFastUserSwitch            "DisconnectOnFastUserSwitch"   CFNumber (0 or 1)
 *   kSCPropNetPPPDisconnectOnIdle                      "DisconnectOnIdle"             CFNumber (0 or 1)
 *   kSCPropNetPPPDisconnectOnIdleTimer                 "DisconnectOnIdleTimer"        CFNumber
 *   kSCPropNetPPPDisconnectOnLogout                    "DisconnectOnLogout"           CFNumber (0 or 1)
 *   kSCPropNetPPPDisconnectOnSleep                     "DisconnectOnSleep"            CFNumber (0 or 1)
 *   kSCPropNetPPPDisconnectTime                        "DisconnectTime"               CFNumber
 *   kSCPropNetPPPIdleReminderTimer                     "IdleReminderTimer"            CFNumber
 *   kSCPropNetPPPIdleReminder                          "IdleReminder"                 CFNumber (0 or 1)
 *   kSCPropNetPPPLastCause                             "LastCause"                    CFNumber
 *   kSCPropNetPPPLogfile                               "Logfile"                      CFString
 *   kSCPropNetPPPPlugins                               "Plugins"                      CFArray[CFString]
 *   kSCPropNetPPPRetryConnectTime                      "RetryConnectTime"             CFNumber
 *   kSCPropNetPPPSessionTimer                          "SessionTimer"                 CFNumber
 *   kSCPropNetPPPStatus                                "Status"                       CFNumber
 *   kSCPropNetPPPUseSessionTimer                       "UseSessionTimer"              CFNumber (0 or 1)
 *   kSCPropNetPPPVerboseLogging                        "VerboseLogging"               CFNumber (0 or 1)
 *
 *   --- Auth: ---
 *   kSCPropNetPPPAuthEAPPlugins                        "AuthEAPPlugins"               CFArray[CFString]
 *   kSCPropNetPPPAuthName                              "AuthName"                     CFString
 *   kSCPropNetPPPAuthPassword                          "AuthPassword"                 CFString
 *   kSCPropNetPPPAuthPasswordEncryption                "AuthPasswordEncryption"       CFString
 *   kSCPropNetPPPAuthPrompt                            "AuthPrompt"                   CFString
 *   kSCPropNetPPPAuthProtocol                          "AuthProtocol"                 CFArray[CFString]
 *
 *   --- kSCPropNetPPPAuthPasswordEncryption values ---
 *   kSCValNetPPPAuthPasswordEncryptionKeychain         "Keychain"
 *   kSCValNetPPPAuthPasswordEncryptionToken            "Token"
 *
 *   --- kSCPropNetPPPAuthPrompt values ---
 *   kSCValNetPPPAuthPromptBefore                       "Before"                       CFString
 *   kSCValNetPPPAuthPromptAfter                        "After"                        CFString
 *
 *   --- kSCPropNetPPPAuthProtocol values ---
 *   kSCValNetPPPAuthProtocolCHAP                       "CHAP"                         CFString
 *   kSCValNetPPPAuthProtocolEAP                        "EAP"                          CFString
 *   kSCValNetPPPAuthProtocolMSCHAP1                    "MSCHAP1"                      CFString
 *   kSCValNetPPPAuthProtocolMSCHAP2                    "MSCHAP2"                      CFString
 *   kSCValNetPPPAuthProtocolPAP                        "PAP"                          CFString
 *
 *   --- Comm: ---
 *   kSCPropNetPPPCommAlternateRemoteAddress            "CommAlternateRemoteAddress"   CFString
 *   kSCPropNetPPPCommConnectDelay                      "CommConnectDelay"             CFNumber
 *   kSCPropNetPPPCommDisplayTerminalWindow             "CommDisplayTerminalWindow"    CFNumber (0 or 1)
 *   kSCPropNetPPPCommRedialCount                       "CommRedialCount"              CFNumber
 *   kSCPropNetPPPCommRedialEnabled                     "CommRedialEnabled"            CFNumber (0 or 1)
 *   kSCPropNetPPPCommRedialInterval                    "CommRedialInterval"           CFNumber
 *   kSCPropNetPPPCommRemoteAddress                     "CommRemoteAddress"            CFString
 *   kSCPropNetPPPCommTerminalScript                    "CommTerminalScript"           CFString
 *   kSCPropNetPPPCommUseTerminalScript                 "CommUseTerminalScript"        CFNumber (0 or 1)
 *
 *   --- CCP: ---
 *   kSCPropNetPPPCCPEnabled                            "CCPEnabled"                   CFNumber (0 or 1)
 *   kSCPropNetPPPCCPMPPE40Enabled                      "CCPMPPE40Enabled"             CFNumber (0 or 1)
 *   kSCPropNetPPPCCPMPPE128Enabled                     "CCPMPPE128Enabled"            CFNumber (0 or 1)
 *
 *   --- IPCP: ---
 *   kSCPropNetPPPIPCPCompressionVJ                     "IPCPCompressionVJ"            CFNumber (0 or 1)
 *   kSCPropNetPPPIPCPUsePeerDNS                        "IPCPUsePeerDNS"               CFNumber (0 or 1)
 *
 *   --- LCP: ---
 *   kSCPropNetPPPLCPEchoEnabled                        "LCPEchoEnabled"               CFNumber (0 or 1)
 *   kSCPropNetPPPLCPEchoFailure                        "LCPEchoFailure"               CFNumber
 *   kSCPropNetPPPLCPEchoInterval                       "LCPEchoInterval"              CFNumber
 *   kSCPropNetPPPLCPCompressionACField                 "LCPCompressionACField"        CFNumber (0 or 1)
 *   kSCPropNetPPPLCPCompressionPField                  "LCPCompressionPField"         CFNumber (0 or 1)
 *   kSCPropNetPPPLCPMRU                                "LCPMRU"                       CFNumber
 *   kSCPropNetPPPLCPMTU                                "LCPMTU"                       CFNumber
 *   kSCPropNetPPPLCPReceiveACCM                        "LCPReceiveACCM"               CFNumber
 *   kSCPropNetPPPLCPTransmitACCM                       "LCPTransmitACCM"              CFNumber
 *
 * kSCEntNetPPPoE Entity Keys
 *
 *   * RESERVED FOR FUTURE USE *
 *
 * kSCEntNetPPPSerial Entity Keys
 *
 *   * RESERVED FOR FUTURE USE *
 *
 * kSCEntNetPPTP Entity Keys
 *
 *   * RESERVED FOR FUTURE USE *
 *
 * kSCEntNetL2TP Entity Keys
 *
 *   kSCPropNetL2TPIPSecSharedSecret                    "IPSecSharedSecret"            CFString
 *   kSCPropNetL2TPIPSecSharedSecretEncryption          "IPSecSharedSecretEncryption"  CFString
 *   kSCPropNetL2TPTransport                            "Transport"                    CFString
 *
 *   --- kSCPropNetL2TPIPSecSharedSecretEncryption values ---
 *   kSCValNetL2TPIPSecSharedSecretEncryptionKeychain   "Keychain"
 *
 *   --- kSCPropNetL2TPTransport values ---
 *   kSCValNetL2TPTransportIP                           "IP"
 *   kSCValNetL2TPTransportIPSec                        "IPSec"
 *
 * kSCEntNetProxies Entity Keys
 *
 *   kSCPropNetProxiesExceptionsList                    "ExceptionsList"               CFArray[CFString]
 *   kSCPropNetProxiesExcludeSimpleHostnames            "ExcludeSimpleHostnames"       CFNumber (0 or 1)
 *   kSCPropNetProxiesFTPEnable                         "FTPEnable"                    CFNumber (0 or 1)
 *   kSCPropNetProxiesFTPPassive                        "FTPPassive"                   CFNumber (0 or 1)
 *   kSCPropNetProxiesFTPPort                           "FTPPort"                      CFNumber
 *   kSCPropNetProxiesFTPProxy                          "FTPProxy"                     CFString
 *   kSCPropNetProxiesGopherEnable                      "GopherEnable"                 CFNumber (0 or 1)
 *   kSCPropNetProxiesGopherPort                        "GopherPort"                   CFNumber
 *   kSCPropNetProxiesGopherProxy                       "GopherProxy"                  CFString
 *   kSCPropNetProxiesHTTPEnable                        "HTTPEnable"                   CFNumber (0 or 1)
 *   kSCPropNetProxiesHTTPPort                          "HTTPPort"                     CFNumber
 *   kSCPropNetProxiesHTTPProxy                         "HTTPProxy"                    CFString
 *   kSCPropNetProxiesHTTPSEnable                       "HTTPSEnable"                  CFNumber (0 or 1)
 *   kSCPropNetProxiesHTTPSPort                         "HTTPSPort"                    CFNumber
 *   kSCPropNetProxiesHTTPSProxy                        "HTTPSProxy"                   CFString
 *   kSCPropNetProxiesRTSPEnable                        "RTSPEnable"                   CFNumber (0 or 1)
 *   kSCPropNetProxiesRTSPPort                          "RTSPPort"                     CFNumber
 *   kSCPropNetProxiesRTSPProxy                         "RTSPProxy"                    CFString
 *   kSCPropNetProxiesSOCKSEnable                       "SOCKSEnable"                  CFNumber (0 or 1)
 *   kSCPropNetProxiesSOCKSPort                         "SOCKSPort"                    CFNumber
 *   kSCPropNetProxiesSOCKSProxy                        "SOCKSProxy"                   CFString
 *   kSCPropNetProxiesProxyAutoConfigEnable             "ProxyAutoConfigEnable"        CFNumber (0 or 1)
 *   kSCPropNetProxiesProxyAutoConfigJavaScript         "ProxyAutoConfigJavaScript"    CFString
 *   kSCPropNetProxiesProxyAutoConfigURLString          "ProxyAutoConfigURLString"     CFString
 *   kSCPropNetProxiesProxyAutoDiscoveryEnable          "ProxyAutoDiscoveryEnable"     CFNumber (0 or 1)
 *
 * kSCEntNetSMB Entity Keys
 *
 *   kSCPropNetSMBNetBIOSName                           "NetBIOSName"                  CFString
 *   kSCPropNetSMBNetBIOSNodeType                       "NetBIOSNodeType"              CFString
 *   kSCPropNetSMBNetBIOSScope                          "NetBIOSScope"                 CFString
 *   kSCPropNetSMBWINSAddresses                         "WINSAddresses"                CFArray[CFString]
 *   kSCPropNetSMBWorkgroup                             "Workgroup"                    CFString
 *
 *   --- kSCPropNetSMBNetBIOSNodeType values ---
 *   kSCValNetSMBNetBIOSNodeTypeBroadcast               "Broadcast"
 *   kSCValNetSMBNetBIOSNodeTypePeer                    "Peer"
 *   kSCValNetSMBNetBIOSNodeTypeMixed                   "Mixed"
 *   kSCValNetSMBNetBIOSNodeTypeHybrid                  "Hybrid"
 *
 * kSCCompUsers Entity Keys
 *
 *   kSCEntUsersConsoleUser                             "ConsoleUser"
 *
 * kSCCompSystem Properties
 *
 *   kSCPropSystemComputerName                          "ComputerName"                 CFString
 *   kSCPropSystemComputerNameEncoding                  "ComputerNameEncoding"         CFNumber
 *
 * SCDynamicStore "domain" prefixes
 *
 *   kSCDynamicStoreDomainFile                          "File:"
 *   kSCDynamicStoreDomainPlugin                        "Plugin:"
 *   kSCDynamicStoreDomainSetup                         "Setup:"
 *   kSCDynamicStoreDomainState                         "State:"
 *   kSCDynamicStoreDomainPrefs                         "Prefs:"
 *
 * Preference ("location") Keys
 *
 *   kSCDynamicStorePropSetupCurrentSet                 "CurrentSet"                   CFString
 *   kSCDynamicStorePropSetupLastUpdated                "LastUpdated"
 *
 * Common/shared Keys
 *
 *   kSCDynamicStorePropNetInterfaces                   "Interfaces"                   CFArray[CFString]
 *   kSCDynamicStorePropNetPrimaryInterface             "PrimaryInterface"             CFString
 *   kSCDynamicStorePropNetPrimaryService               "PrimaryService"               CFString
 *   kSCDynamicStorePropNetServiceIDs                   "ServiceIDs"                   CFArray[CFString]
 }


{
 * Note: The MACOSX_DEPLOYMENT_TARGET environment variable should be used
 *       when building an application targeted for an earlier version of
 *       Mac OS X.  Please reference Technical Note TN2064 for more details.
 }

{
 * Note: For Cocoa/Obj-C/Foundation applications accessing these preference
 *       keys you may want to consider the following :
 *
 *       #define SC_SCHEMA_DECLARATION(k,q)	extern NSString * k;
 *       #import <SystemConfiguration/SystemConfiguration.h>
 }

{
 * Note: For CFM applications using these schema keys you may want to
 *       consider the following :
 *
 *       #define SC_SCHEMA_DECLARATION(k,q)
 *       #define SC_SCHEMA_KV(k,v,t)	lookup_SC_key( CFSTR( #k ) )
 *       #include <SystemConfiguration/SystemConfiguration.h>
 *
 *       CFStringRef lookup_SC_key(CFStringRef key)
 *       (
 *         // this function should [dynamically, on-demand] load the
 *         // SystemConfiguration.framework, look up the provided key,
 *         // and return the associated value.
 *       )
 }

{
 * Note: Earlier versions of this header file defined a "SCSTR" macro
 *       which helped to facilitate Obj-C development. Use of this macro
 *       has been deprecated (in Mac OS X 10.4) in favor of the newer
 *       "SC_SCHEMA_DECLARATION" and "SC_SCHEMA_KV" macros
 }



{ -------------------- HeaderDoc comments -------------------- }


{ -------------------- Schema declarations -------------------- }

{ until __IPHONE_NA is automatically translated }
{$ifc TARGET_OS_MAC}

var kSCResvLink: CFStringRef; external name '_kSCResvLink'; (* attribute const *) { CFString	"__LINK__" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCResvInactive: CFStringRef; external name '_kSCResvInactive'; (* attribute const *) { 	"__INACTIVE__" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropInterfaceName: CFStringRef; external name '_kSCPropInterfaceName'; (* attribute const *) { CFString	"InterfaceName" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropMACAddress: CFStringRef; external name '_kSCPropMACAddress'; (* attribute const *) { CFString	"MACAddress" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropUserDefinedName: CFStringRef; external name '_kSCPropUserDefinedName'; (* attribute const *) { CFString	"UserDefinedName" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropVersion: CFStringRef; external name '_kSCPropVersion'; (* attribute const *) { CFString	"Version" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPrefCurrentSet: CFStringRef; external name '_kSCPrefCurrentSet'; (* attribute const *) { CFString	"CurrentSet" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPrefNetworkServices: CFStringRef; external name '_kSCPrefNetworkServices'; (* attribute const *) { CFDictionary	"NetworkServices" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPrefSets: CFStringRef; external name '_kSCPrefSets'; (* attribute const *) { CFDictionary	"Sets" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPrefSystem: CFStringRef; external name '_kSCPrefSystem'; (* attribute const *) { CFDictionary	"System" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCCompNetwork: CFStringRef; external name '_kSCCompNetwork'; (* attribute const *) { 	"Network" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCCompService: CFStringRef; external name '_kSCCompService'; (* attribute const *) { 	"Service" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCCompGlobal: CFStringRef; external name '_kSCCompGlobal'; (* attribute const *) { 	"Global" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCCompHostNames: CFStringRef; external name '_kSCCompHostNames'; (* attribute const *) { 	"HostNames" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCCompInterface: CFStringRef; external name '_kSCCompInterface'; (* attribute const *) { 	"Interface" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCCompSystem: CFStringRef; external name '_kSCCompSystem'; (* attribute const *) { 	"System" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCCompUsers: CFStringRef; external name '_kSCCompUsers'; (* attribute const *) { 	"Users" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCCompAnyRegex: CFStringRef; external name '_kSCCompAnyRegex'; (* attribute const *) { 	"[^/]+" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCEntNetAirPort: CFStringRef; external name '_kSCEntNetAirPort'; (* attribute const *) { CFDictionary	"AirPort" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

{$ifc not TARGET_OS_IPHONE}

var kSCEntNetAppleTalk: CFStringRef; external name '_kSCEntNetAppleTalk'; (* attribute const *) { CFDictionary	"AppleTalk" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)

{$endc} {not TARGET_OS_IPHONE}

var kSCEntNetDHCP: CFStringRef; external name '_kSCEntNetDHCP'; (* attribute const *) { CFDictionary	"DHCP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCEntNetDNS: CFStringRef; external name '_kSCEntNetDNS'; (* attribute const *) { CFDictionary	"DNS" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCEntNetEthernet: CFStringRef; external name '_kSCEntNetEthernet'; (* attribute const *) { CFDictionary	"Ethernet" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCEntNetFireWire: CFStringRef; external name '_kSCEntNetFireWire'; (* attribute const *) { CFDictionary	"FireWire" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCEntNetInterface: CFStringRef; external name '_kSCEntNetInterface'; (* attribute const *) { CFDictionary	"Interface" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCEntNetIPSec: CFStringRef; external name '_kSCEntNetIPSec'; (* attribute const *) { CFDictionary	"IPSec" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCEntNetIPv4: CFStringRef; external name '_kSCEntNetIPv4'; (* attribute const *) { CFDictionary	"IPv4" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCEntNetIPv6: CFStringRef; external name '_kSCEntNetIPv6'; (* attribute const *) { CFDictionary	"IPv6" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCEntNetL2TP: CFStringRef; external name '_kSCEntNetL2TP'; (* attribute const *) { CFDictionary	"L2TP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCEntNetLink: CFStringRef; external name '_kSCEntNetLink'; (* attribute const *) { CFDictionary	"Link" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCEntNetModem: CFStringRef; external name '_kSCEntNetModem'; (* attribute const *) { CFDictionary	"Modem" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

{$ifc not TARGET_OS_IPHONE}

var kSCEntNetNetInfo: CFStringRef; external name '_kSCEntNetNetInfo'; (* attribute const *) { CFDictionary	"NetInfo" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA) *)

{$endc} {not TARGET_OS_IPHONE}

var kSCEntNetPPP: CFStringRef; external name '_kSCEntNetPPP'; (* attribute const *) { CFDictionary	"PPP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCEntNetPPPoE: CFStringRef; external name '_kSCEntNetPPPoE'; (* attribute const *) { CFDictionary	"PPPoE" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCEntNetPPPSerial: CFStringRef; external name '_kSCEntNetPPPSerial'; (* attribute const *) { CFDictionary	"PPPSerial" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCEntNetPPTP: CFStringRef; external name '_kSCEntNetPPTP'; (* attribute const *) { CFDictionary	"PPTP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCEntNetProxies: CFStringRef; external name '_kSCEntNetProxies'; (* attribute const *) { CFDictionary	"Proxies" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

{$ifc not TARGET_OS_IPHONE}

var kSCEntNetSMB: CFStringRef; external name '_kSCEntNetSMB'; (* attribute const *) { CFDictionary	"SMB" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

{$endc} {not TARGET_OS_IPHONE}

var kSCEntNet6to4: CFStringRef; external name '_kSCEntNet6to4'; (* attribute const *) { CFDictionary	"6to4" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetOverridePrimary: CFStringRef; external name '_kSCPropNetOverridePrimary'; (* attribute const *) { CFNumber (0 or 1)	"OverridePrimary" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetServiceOrder: CFStringRef; external name '_kSCPropNetServiceOrder'; (* attribute const *) { CFArray[CFString]	"ServiceOrder" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPOverridePrimary: CFStringRef; external name '_kSCPropNetPPPOverridePrimary'; (* attribute const *) { CFNumber (0 or 1)	"PPPOverridePrimary" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetInterfaces: CFStringRef; external name '_kSCPropNetInterfaces'; (* attribute const *) { CFArray[CFString]	"Interfaces" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetLocalHostName: CFStringRef; external name '_kSCPropNetLocalHostName'; (* attribute const *) { CFString	"LocalHostName" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetAirPortAllowNetCreation: CFStringRef; external name '_kSCPropNetAirPortAllowNetCreation'; (* attribute const *) { CFNumber (0 or 1)	"AllowNetCreation" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetAirPortAuthPassword: CFStringRef; external name '_kSCPropNetAirPortAuthPassword'; (* attribute const *) { CFData	"AuthPassword" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetAirPortAuthPasswordEncryption: CFStringRef; external name '_kSCPropNetAirPortAuthPasswordEncryption'; (* attribute const *) { CFString	"AuthPasswordEncryption" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetAirPortJoinMode: CFStringRef; external name '_kSCPropNetAirPortJoinMode'; (* attribute const *) { CFString	"JoinMode" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetAirPortPowerEnabled: CFStringRef; external name '_kSCPropNetAirPortPowerEnabled'; (* attribute const *) { CFNumber (0 or 1)	"PowerEnabled" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetAirPortPreferredNetwork: CFStringRef; external name '_kSCPropNetAirPortPreferredNetwork'; (* attribute const *) { CFString	"PreferredNetwork" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetAirPortSavePasswords: CFStringRef; external name '_kSCPropNetAirPortSavePasswords'; (* attribute const *) { CFNumber (0 or 1)	"SavePasswords" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCValNetAirPortJoinModeAutomatic: CFStringRef; external name '_kSCValNetAirPortJoinModeAutomatic'; (* attribute const *) { 	"Automatic" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetAirPortJoinModePreferred: CFStringRef; external name '_kSCValNetAirPortJoinModePreferred'; (* attribute const *) { 	"Preferred" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCValNetAirPortJoinModeRanked: CFStringRef; external name '_kSCValNetAirPortJoinModeRanked'; (* attribute const *) { 	"Ranked" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCValNetAirPortJoinModeRecent: CFStringRef; external name '_kSCValNetAirPortJoinModeRecent'; (* attribute const *) { 	"Recent" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCValNetAirPortJoinModeStrongest: CFStringRef; external name '_kSCValNetAirPortJoinModeStrongest'; (* attribute const *) { 	"Strongest" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCValNetAirPortAuthPasswordEncryptionKeychain: CFStringRef; external name '_kSCValNetAirPortAuthPasswordEncryptionKeychain'; (* attribute const *) { 	"Keychain" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

{$ifc not TARGET_OS_IPHONE}

var kSCPropNetAppleTalkComputerName: CFStringRef; external name '_kSCPropNetAppleTalkComputerName'; (* attribute const *) { CFString	"ComputerName" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)

var kSCPropNetAppleTalkComputerNameEncoding: CFStringRef; external name '_kSCPropNetAppleTalkComputerNameEncoding'; (* attribute const *) { CFNumber	"ComputerNameEncoding" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)

var kSCPropNetAppleTalkConfigMethod: CFStringRef; external name '_kSCPropNetAppleTalkConfigMethod'; (* attribute const *) { CFString	"ConfigMethod" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)

var kSCPropNetAppleTalkDefaultZone: CFStringRef; external name '_kSCPropNetAppleTalkDefaultZone'; (* attribute const *) { CFString	"DefaultZone" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)

var kSCPropNetAppleTalkNetworkID: CFStringRef; external name '_kSCPropNetAppleTalkNetworkID'; (* attribute const *) { CFNumber	"NetworkID" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)

var kSCPropNetAppleTalkNetworkRange: CFStringRef; external name '_kSCPropNetAppleTalkNetworkRange'; (* attribute const *) { CFArray[CFNumber]	"NetworkRange" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_2,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)

var kSCPropNetAppleTalkNodeID: CFStringRef; external name '_kSCPropNetAppleTalkNodeID'; (* attribute const *) { CFNumber	"NodeID" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)

var kSCPropNetAppleTalkSeedNetworkRange: CFStringRef; external name '_kSCPropNetAppleTalkSeedNetworkRange'; (* attribute const *) { CFArray[CFNumber]	"SeedNetworkRange" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)

var kSCPropNetAppleTalkSeedZones: CFStringRef; external name '_kSCPropNetAppleTalkSeedZones'; (* attribute const *) { CFArray[CFString]	"SeedZones" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)

var kSCValNetAppleTalkConfigMethodNode: CFStringRef; external name '_kSCValNetAppleTalkConfigMethodNode'; (* attribute const *) { 	"Node" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)

var kSCValNetAppleTalkConfigMethodRouter: CFStringRef; external name '_kSCValNetAppleTalkConfigMethodRouter'; (* attribute const *) { 	"Router" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)

var kSCValNetAppleTalkConfigMethodSeedRouter: CFStringRef; external name '_kSCValNetAppleTalkConfigMethodSeedRouter'; (* attribute const *) { 	"SeedRouter" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_6,__IPHONE_NA,__IPHONE_NA) *)

{$endc} {not TARGET_OS_IPHONE}

var kSCPropNetDNSDomainName: CFStringRef; external name '_kSCPropNetDNSDomainName'; (* attribute const *) { CFString	"DomainName" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetDNSOptions: CFStringRef; external name '_kSCPropNetDNSOptions'; (* attribute const *) { CFString	"Options" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCPropNetDNSSearchDomains: CFStringRef; external name '_kSCPropNetDNSSearchDomains'; (* attribute const *) { CFArray[CFString]	"SearchDomains" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetDNSSearchOrder: CFStringRef; external name '_kSCPropNetDNSSearchOrder'; (* attribute const *) { CFNumber	"SearchOrder" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCPropNetDNSServerAddresses: CFStringRef; external name '_kSCPropNetDNSServerAddresses'; (* attribute const *) { CFArray[CFString]	"ServerAddresses" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetDNSServerPort: CFStringRef; external name '_kSCPropNetDNSServerPort'; (* attribute const *) { CFNumber	"ServerPort" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCPropNetDNSServerTimeout: CFStringRef; external name '_kSCPropNetDNSServerTimeout'; (* attribute const *) { CFNumber	"ServerTimeout" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCPropNetDNSSortList: CFStringRef; external name '_kSCPropNetDNSSortList'; (* attribute const *) { CFArray[CFString]	"SortList" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetDNSSupplementalMatchDomains: CFStringRef; external name '_kSCPropNetDNSSupplementalMatchDomains'; (* attribute const *) { CFArray[CFString]	"SupplementalMatchDomains" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCPropNetDNSSupplementalMatchOrders: CFStringRef; external name '_kSCPropNetDNSSupplementalMatchOrders'; (* attribute const *) { CFArray[CFNumber]	"SupplementalMatchOrders" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCPropNetEthernetMediaSubType: CFStringRef; external name '_kSCPropNetEthernetMediaSubType'; (* attribute const *) { CFString	"MediaSubType" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetEthernetMediaOptions: CFStringRef; external name '_kSCPropNetEthernetMediaOptions'; (* attribute const *) { CFArray[CFString]	"MediaOptions" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetEthernetMTU: CFStringRef; external name '_kSCPropNetEthernetMTU'; (* attribute const *) { CFNumber	"MTU" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetInterfaceDeviceName: CFStringRef; external name '_kSCPropNetInterfaceDeviceName'; (* attribute const *) { CFString	"DeviceName" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetInterfaceHardware: CFStringRef; external name '_kSCPropNetInterfaceHardware'; (* attribute const *) { CFString	"Hardware" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetInterfaceType: CFStringRef; external name '_kSCPropNetInterfaceType'; (* attribute const *) { CFString	"Type" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetInterfaceSubType: CFStringRef; external name '_kSCPropNetInterfaceSubType'; (* attribute const *) { CFString	"SubType" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetInterfaceSupportsModemOnHold: CFStringRef; external name '_kSCPropNetInterfaceSupportsModemOnHold'; (* attribute const *) { CFNumber (0 or 1)	"SupportsModemOnHold" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCValNetInterfaceTypeEthernet: CFStringRef; external name '_kSCValNetInterfaceTypeEthernet'; (* attribute const *) { 	"Ethernet" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetInterfaceTypeFireWire: CFStringRef; external name '_kSCValNetInterfaceTypeFireWire'; (* attribute const *) { 	"FireWire" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetInterfaceTypePPP: CFStringRef; external name '_kSCValNetInterfaceTypePPP'; (* attribute const *) { 	"PPP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetInterfaceType6to4: CFStringRef; external name '_kSCValNetInterfaceType6to4'; (* attribute const *) { 	"6to4" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetInterfaceTypeIPSec: CFStringRef; external name '_kSCValNetInterfaceTypeIPSec'; (* attribute const *) { 	"IPSec" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_NA) *)

var kSCValNetInterfaceSubTypePPPoE: CFStringRef; external name '_kSCValNetInterfaceSubTypePPPoE'; (* attribute const *) { 	"PPPoE" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetInterfaceSubTypePPPSerial: CFStringRef; external name '_kSCValNetInterfaceSubTypePPPSerial'; (* attribute const *) { 	"PPPSerial" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetInterfaceSubTypePPTP: CFStringRef; external name '_kSCValNetInterfaceSubTypePPTP'; (* attribute const *) { 	"PPTP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCValNetInterfaceSubTypeL2TP: CFStringRef; external name '_kSCValNetInterfaceSubTypeL2TP'; (* attribute const *) { 	"L2TP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetIPSecAuthenticationMethod: CFStringRef; external name '_kSCPropNetIPSecAuthenticationMethod'; (* attribute const *) { CFString	"AuthenticationMethod" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetIPSecLocalCertificate: CFStringRef; external name '_kSCPropNetIPSecLocalCertificate'; (* attribute const *) { CFData	"LocalCertificate" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetIPSecLocalIdentifier: CFStringRef; external name '_kSCPropNetIPSecLocalIdentifier'; (* attribute const *) { CFString	"LocalIdentifier" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetIPSecLocalIdentifierType: CFStringRef; external name '_kSCPropNetIPSecLocalIdentifierType'; (* attribute const *) { CFString	"LocalIdentifierType" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetIPSecSharedSecret: CFStringRef; external name '_kSCPropNetIPSecSharedSecret'; (* attribute const *) { CFString	"SharedSecret" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetIPSecSharedSecretEncryption: CFStringRef; external name '_kSCPropNetIPSecSharedSecretEncryption'; (* attribute const *) { CFString	"SharedSecretEncryption" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetIPSecConnectTime: CFStringRef; external name '_kSCPropNetIPSecConnectTime'; (* attribute const *) { CFNumber	"ConnectTime" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_NA) *)

var kSCPropNetIPSecRemoteAddress: CFStringRef; external name '_kSCPropNetIPSecRemoteAddress'; (* attribute const *) { CFString	"RemoteAddress" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_NA) *)

var kSCPropNetIPSecStatus: CFStringRef; external name '_kSCPropNetIPSecStatus'; (* attribute const *) { CFNumber	"Status" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_NA) *)

var kSCPropNetIPSecXAuthEnabled: CFStringRef; external name '_kSCPropNetIPSecXAuthEnabled'; (* attribute const *) { CFNumber (0 or 1)	"XAuthEnabled" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_NA) *)

var kSCPropNetIPSecXAuthName: CFStringRef; external name '_kSCPropNetIPSecXAuthName'; (* attribute const *) { CFString	"XAuthName" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_NA) *)

var kSCPropNetIPSecXAuthPassword: CFStringRef; external name '_kSCPropNetIPSecXAuthPassword'; (* attribute const *) { CFString	"XAuthPassword" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_NA) *)

var kSCPropNetIPSecXAuthPasswordEncryption: CFStringRef; external name '_kSCPropNetIPSecXAuthPasswordEncryption'; (* attribute const *) { CFString	"XAuthPasswordEncryption" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_NA) *)

var kSCValNetIPSecAuthenticationMethodSharedSecret: CFStringRef; external name '_kSCValNetIPSecAuthenticationMethodSharedSecret'; (* attribute const *) { 	"SharedSecret" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCValNetIPSecAuthenticationMethodCertificate: CFStringRef; external name '_kSCValNetIPSecAuthenticationMethodCertificate'; (* attribute const *) { 	"Certificate" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCValNetIPSecAuthenticationMethodHybrid: CFStringRef; external name '_kSCValNetIPSecAuthenticationMethodHybrid'; (* attribute const *) { 	"Hybrid" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCValNetIPSecLocalIdentifierTypeKeyID: CFStringRef; external name '_kSCValNetIPSecLocalIdentifierTypeKeyID'; (* attribute const *) { 	"KeyID" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCValNetIPSecSharedSecretEncryptionKeychain: CFStringRef; external name '_kSCValNetIPSecSharedSecretEncryptionKeychain'; (* attribute const *) { 	"Keychain" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCValNetIPSecXAuthPasswordEncryptionKeychain: CFStringRef; external name '_kSCValNetIPSecXAuthPasswordEncryptionKeychain'; (* attribute const *) { 	"Keychain" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_NA) *)

var kSCValNetIPSecXAuthPasswordEncryptionPrompt: CFStringRef; external name '_kSCValNetIPSecXAuthPasswordEncryptionPrompt'; (* attribute const *) { 	"Prompt" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_NA) *)

var kSCPropNetIPv4Addresses: CFStringRef; external name '_kSCPropNetIPv4Addresses'; (* attribute const *) { CFArray[CFString]	"Addresses" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetIPv4ConfigMethod: CFStringRef; external name '_kSCPropNetIPv4ConfigMethod'; (* attribute const *) { CFString	"ConfigMethod" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetIPv4DHCPClientID: CFStringRef; external name '_kSCPropNetIPv4DHCPClientID'; (* attribute const *) { CFString	"DHCPClientID" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetIPv4Router: CFStringRef; external name '_kSCPropNetIPv4Router'; (* attribute const *) { CFString	"Router" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetIPv4SubnetMasks: CFStringRef; external name '_kSCPropNetIPv4SubnetMasks'; (* attribute const *) { CFArray[CFString]	"SubnetMasks" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetIPv4DestAddresses: CFStringRef; external name '_kSCPropNetIPv4DestAddresses'; (* attribute const *) { CFArray[CFString]	"DestAddresses" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetIPv4BroadcastAddresses: CFStringRef; external name '_kSCPropNetIPv4BroadcastAddresses'; (* attribute const *) { CFArray[CFString]	"BroadcastAddresses" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetIPv4ConfigMethodAutomatic: CFStringRef; external name '_kSCValNetIPv4ConfigMethodAutomatic'; (* attribute const *) { 	"Automatic" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_NA) *)

var kSCValNetIPv4ConfigMethodBOOTP: CFStringRef; external name '_kSCValNetIPv4ConfigMethodBOOTP'; (* attribute const *) { 	"BOOTP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetIPv4ConfigMethodDHCP: CFStringRef; external name '_kSCValNetIPv4ConfigMethodDHCP'; (* attribute const *) { 	"DHCP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetIPv4ConfigMethodINFORM: CFStringRef; external name '_kSCValNetIPv4ConfigMethodINFORM'; (* attribute const *) { 	"INFORM" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetIPv4ConfigMethodLinkLocal: CFStringRef; external name '_kSCValNetIPv4ConfigMethodLinkLocal'; (* attribute const *) { 	"LinkLocal" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCValNetIPv4ConfigMethodManual: CFStringRef; external name '_kSCValNetIPv4ConfigMethodManual'; (* attribute const *) { 	"Manual" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetIPv4ConfigMethodPPP: CFStringRef; external name '_kSCValNetIPv4ConfigMethodPPP'; (* attribute const *) { 	"PPP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetIPv6Addresses: CFStringRef; external name '_kSCPropNetIPv6Addresses'; (* attribute const *) { CFArray[CFString]	"Addresses" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetIPv6ConfigMethod: CFStringRef; external name '_kSCPropNetIPv6ConfigMethod'; (* attribute const *) { CFString	"ConfigMethod" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetIPv6DestAddresses: CFStringRef; external name '_kSCPropNetIPv6DestAddresses'; (* attribute const *) { CFArray[CFString]	"DestAddresses" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetIPv6Flags: CFStringRef; external name '_kSCPropNetIPv6Flags'; (* attribute const *) { CFNumber	"Flags" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetIPv6PrefixLength: CFStringRef; external name '_kSCPropNetIPv6PrefixLength'; (* attribute const *) { CFArray[CFNumber]	"PrefixLength" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetIPv6Router: CFStringRef; external name '_kSCPropNetIPv6Router'; (* attribute const *) { CFString	"Router" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetIPv6ConfigMethodAutomatic: CFStringRef; external name '_kSCValNetIPv6ConfigMethodAutomatic'; (* attribute const *) { 	"Automatic" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetIPv6ConfigMethodLinkLocal: CFStringRef; external name '_kSCValNetIPv6ConfigMethodLinkLocal'; (* attribute const *) { 	"LinkLocal" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_NA) *)

var kSCValNetIPv6ConfigMethodManual: CFStringRef; external name '_kSCValNetIPv6ConfigMethodManual'; (* attribute const *) { 	"Manual" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetIPv6ConfigMethodRouterAdvertisement: CFStringRef; external name '_kSCValNetIPv6ConfigMethodRouterAdvertisement'; (* attribute const *) { 	"RouterAdvertisement" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetIPv6ConfigMethod6to4: CFStringRef; external name '_kSCValNetIPv6ConfigMethod6to4'; (* attribute const *) { 	"6to4" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNet6to4Relay: CFStringRef; external name '_kSCPropNet6to4Relay'; (* attribute const *) { CFString	"Relay" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetLinkActive: CFStringRef; external name '_kSCPropNetLinkActive'; (* attribute const *) { CFBoolean	"Active" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetLinkDetaching: CFStringRef; external name '_kSCPropNetLinkDetaching'; (* attribute const *) { CFBoolean	"Detaching" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetModemAccessPointName: CFStringRef; external name '_kSCPropNetModemAccessPointName'; (* attribute const *) { CFString	"AccessPointName" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetModemConnectionPersonality: CFStringRef; external name '_kSCPropNetModemConnectionPersonality'; (* attribute const *) { CFString	"ConnectionPersonality" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetModemConnectionScript: CFStringRef; external name '_kSCPropNetModemConnectionScript'; (* attribute const *) { CFString	"ConnectionScript" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetModemConnectSpeed: CFStringRef; external name '_kSCPropNetModemConnectSpeed'; (* attribute const *) { CFNumber	"ConnectSpeed" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetModemDataCompression: CFStringRef; external name '_kSCPropNetModemDataCompression'; (* attribute const *) { CFNumber (0 or 1)	"DataCompression" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetModemDeviceContextID: CFStringRef; external name '_kSCPropNetModemDeviceContextID'; (* attribute const *) { CFString	"DeviceContextID" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetModemDeviceModel: CFStringRef; external name '_kSCPropNetModemDeviceModel'; (* attribute const *) { CFString	"DeviceModel" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetModemDeviceVendor: CFStringRef; external name '_kSCPropNetModemDeviceVendor'; (* attribute const *) { CFString	"DeviceVendor" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetModemDialMode: CFStringRef; external name '_kSCPropNetModemDialMode'; (* attribute const *) { CFString	"DialMode" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetModemErrorCorrection: CFStringRef; external name '_kSCPropNetModemErrorCorrection'; (* attribute const *) { CFNumber (0 or 1)	"ErrorCorrection" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetModemHoldCallWaitingAudibleAlert: CFStringRef; external name '_kSCPropNetModemHoldCallWaitingAudibleAlert'; (* attribute const *) { CFNumber (0 or 1)	"HoldCallWaitingAudibleAlert" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetModemHoldDisconnectOnAnswer: CFStringRef; external name '_kSCPropNetModemHoldDisconnectOnAnswer'; (* attribute const *) { CFNumber (0 or 1)	"HoldDisconnectOnAnswer" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetModemHoldEnabled: CFStringRef; external name '_kSCPropNetModemHoldEnabled'; (* attribute const *) { CFNumber (0 or 1)	"HoldEnabled" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetModemHoldReminder: CFStringRef; external name '_kSCPropNetModemHoldReminder'; (* attribute const *) { CFNumber (0 or 1)	"HoldReminder" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetModemHoldReminderTime: CFStringRef; external name '_kSCPropNetModemHoldReminderTime'; (* attribute const *) { CFNumber	"HoldReminderTime" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetModemNote: CFStringRef; external name '_kSCPropNetModemNote'; (* attribute const *) { CFString	"Note" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetModemPulseDial: CFStringRef; external name '_kSCPropNetModemPulseDial'; (* attribute const *) { CFNumber (0 or 1)	"PulseDial" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetModemSpeaker: CFStringRef; external name '_kSCPropNetModemSpeaker'; (* attribute const *) { CFNumber (0 or 1)	"Speaker" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetModemSpeed: CFStringRef; external name '_kSCPropNetModemSpeed'; (* attribute const *) { CFNumber	"Speed" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetModemDialModeIgnoreDialTone: CFStringRef; external name '_kSCValNetModemDialModeIgnoreDialTone'; (* attribute const *) { 	"IgnoreDialTone" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetModemDialModeManual: CFStringRef; external name '_kSCValNetModemDialModeManual'; (* attribute const *) { 	"Manual" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetModemDialModeWaitForDialTone: CFStringRef; external name '_kSCValNetModemDialModeWaitForDialTone'; (* attribute const *) { 	"WaitForDialTone" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

{$ifc not TARGET_OS_IPHONE}

var kSCPropNetNetInfoBindingMethods: CFStringRef; external name '_kSCPropNetNetInfoBindingMethods'; (* attribute const *) { CFString	"BindingMethods" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA) *)

var kSCPropNetNetInfoServerAddresses: CFStringRef; external name '_kSCPropNetNetInfoServerAddresses'; (* attribute const *) { CFArray[CFString]	"ServerAddresses" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA) *)

var kSCPropNetNetInfoServerTags: CFStringRef; external name '_kSCPropNetNetInfoServerTags'; (* attribute const *) { CFArray[CFString]	"ServerTags" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA) *)

var kSCPropNetNetInfoBroadcastServerTag: CFStringRef; external name '_kSCPropNetNetInfoBroadcastServerTag'; (* attribute const *) { CFString	"BroadcastServerTag" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA) *)

var kSCValNetNetInfoBindingMethodsBroadcast: CFStringRef; external name '_kSCValNetNetInfoBindingMethodsBroadcast'; (* attribute const *) { 	"Broadcast" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA) *)

var kSCValNetNetInfoBindingMethodsDHCP: CFStringRef; external name '_kSCValNetNetInfoBindingMethodsDHCP'; (* attribute const *) { 	"DHCP" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA) *)

var kSCValNetNetInfoBindingMethodsManual: CFStringRef; external name '_kSCValNetNetInfoBindingMethodsManual'; (* attribute const *) { 	"Manual" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA) *)

var kSCValNetNetInfoDefaultServerTag: CFStringRef; external name '_kSCValNetNetInfoDefaultServerTag'; (* attribute const *) { 	"network" }
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_5,__IPHONE_NA,__IPHONE_NA) *)

{$endc} {not TARGET_OS_IPHONE}

var kSCPropNetPPPACSPEnabled: CFStringRef; external name '_kSCPropNetPPPACSPEnabled'; (* attribute const *) { CFNumber (0 or 1)	"ACSPEnabled" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetPPPConnectTime: CFStringRef; external name '_kSCPropNetPPPConnectTime'; (* attribute const *) { CFNumber	"ConnectTime" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetPPPDeviceLastCause: CFStringRef; external name '_kSCPropNetPPPDeviceLastCause'; (* attribute const *) { CFNumber	"DeviceLastCause" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetPPPDialOnDemand: CFStringRef; external name '_kSCPropNetPPPDialOnDemand'; (* attribute const *) { CFNumber (0 or 1)	"DialOnDemand" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPDisconnectOnFastUserSwitch: CFStringRef; external name '_kSCPropNetPPPDisconnectOnFastUserSwitch'; (* attribute const *) { CFNumber (0 or 1)	"DisconnectOnFastUserSwitch" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCPropNetPPPDisconnectOnIdle: CFStringRef; external name '_kSCPropNetPPPDisconnectOnIdle'; (* attribute const *) { CFNumber (0 or 1)	"DisconnectOnIdle" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPDisconnectOnIdleTimer: CFStringRef; external name '_kSCPropNetPPPDisconnectOnIdleTimer'; (* attribute const *) { CFNumber	"DisconnectOnIdleTimer" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPDisconnectOnLogout: CFStringRef; external name '_kSCPropNetPPPDisconnectOnLogout'; (* attribute const *) { CFNumber (0 or 1)	"DisconnectOnLogout" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPDisconnectOnSleep: CFStringRef; external name '_kSCPropNetPPPDisconnectOnSleep'; (* attribute const *) { CFNumber (0 or 1)	"DisconnectOnSleep" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetPPPDisconnectTime: CFStringRef; external name '_kSCPropNetPPPDisconnectTime'; (* attribute const *) { CFNumber	"DisconnectTime" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetPPPIdleReminderTimer: CFStringRef; external name '_kSCPropNetPPPIdleReminderTimer'; (* attribute const *) { CFNumber	"IdleReminderTimer" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPIdleReminder: CFStringRef; external name '_kSCPropNetPPPIdleReminder'; (* attribute const *) { CFNumber (0 or 1)	"IdleReminder" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPLastCause: CFStringRef; external name '_kSCPropNetPPPLastCause'; (* attribute const *) { CFNumber	"LastCause" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetPPPLogfile: CFStringRef; external name '_kSCPropNetPPPLogfile'; (* attribute const *) { CFString	"Logfile" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPPlugins: CFStringRef; external name '_kSCPropNetPPPPlugins'; (* attribute const *) { CFArray[CFString]	"Plugins" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetPPPRetryConnectTime: CFStringRef; external name '_kSCPropNetPPPRetryConnectTime'; (* attribute const *) { CFNumber	"RetryConnectTime" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetPPPSessionTimer: CFStringRef; external name '_kSCPropNetPPPSessionTimer'; (* attribute const *) { CFNumber	"SessionTimer" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPStatus: CFStringRef; external name '_kSCPropNetPPPStatus'; (* attribute const *) { CFNumber	"Status" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetPPPUseSessionTimer: CFStringRef; external name '_kSCPropNetPPPUseSessionTimer'; (* attribute const *) { CFNumber (0 or 1)	"UseSessionTimer" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetPPPVerboseLogging: CFStringRef; external name '_kSCPropNetPPPVerboseLogging'; (* attribute const *) { CFNumber (0 or 1)	"VerboseLogging" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPAuthEAPPlugins: CFStringRef; external name '_kSCPropNetPPPAuthEAPPlugins'; (* attribute const *) { CFArray[CFString]	"AuthEAPPlugins" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetPPPAuthName: CFStringRef; external name '_kSCPropNetPPPAuthName'; (* attribute const *) { CFString	"AuthName" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPAuthPassword: CFStringRef; external name '_kSCPropNetPPPAuthPassword'; (* attribute const *) { CFString	"AuthPassword" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPAuthPasswordEncryption: CFStringRef; external name '_kSCPropNetPPPAuthPasswordEncryption'; (* attribute const *) { CFString	"AuthPasswordEncryption" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPAuthPrompt: CFStringRef; external name '_kSCPropNetPPPAuthPrompt'; (* attribute const *) { CFString	"AuthPrompt" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetPPPAuthProtocol: CFStringRef; external name '_kSCPropNetPPPAuthProtocol'; (* attribute const *) { CFArray[CFString]	"AuthProtocol" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetPPPAuthPasswordEncryptionKeychain: CFStringRef; external name '_kSCValNetPPPAuthPasswordEncryptionKeychain'; (* attribute const *) { 	"Keychain" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetPPPAuthPasswordEncryptionToken: CFStringRef; external name '_kSCValNetPPPAuthPasswordEncryptionToken'; (* attribute const *) { 	"Token" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCValNetPPPAuthPromptBefore: CFStringRef; external name '_kSCValNetPPPAuthPromptBefore'; (* attribute const *) { CFString	"Before" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetPPPAuthPromptAfter: CFStringRef; external name '_kSCValNetPPPAuthPromptAfter'; (* attribute const *) { CFString	"After" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetPPPAuthProtocolCHAP: CFStringRef; external name '_kSCValNetPPPAuthProtocolCHAP'; (* attribute const *) { CFString	"CHAP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCValNetPPPAuthProtocolEAP: CFStringRef; external name '_kSCValNetPPPAuthProtocolEAP'; (* attribute const *) { CFString	"EAP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetPPPAuthProtocolMSCHAP1: CFStringRef; external name '_kSCValNetPPPAuthProtocolMSCHAP1'; (* attribute const *) { CFString	"MSCHAP1" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetPPPAuthProtocolMSCHAP2: CFStringRef; external name '_kSCValNetPPPAuthProtocolMSCHAP2'; (* attribute const *) { CFString	"MSCHAP2" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetPPPAuthProtocolPAP: CFStringRef; external name '_kSCValNetPPPAuthProtocolPAP'; (* attribute const *) { CFString	"PAP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPCommAlternateRemoteAddress: CFStringRef; external name '_kSCPropNetPPPCommAlternateRemoteAddress'; (* attribute const *) { CFString	"CommAlternateRemoteAddress" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPCommConnectDelay: CFStringRef; external name '_kSCPropNetPPPCommConnectDelay'; (* attribute const *) { CFNumber	"CommConnectDelay" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPCommDisplayTerminalWindow: CFStringRef; external name '_kSCPropNetPPPCommDisplayTerminalWindow'; (* attribute const *) { CFNumber (0 or 1)	"CommDisplayTerminalWindow" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPCommRedialCount: CFStringRef; external name '_kSCPropNetPPPCommRedialCount'; (* attribute const *) { CFNumber	"CommRedialCount" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPCommRedialEnabled: CFStringRef; external name '_kSCPropNetPPPCommRedialEnabled'; (* attribute const *) { CFNumber (0 or 1)	"CommRedialEnabled" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPCommRedialInterval: CFStringRef; external name '_kSCPropNetPPPCommRedialInterval'; (* attribute const *) { CFNumber	"CommRedialInterval" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPCommRemoteAddress: CFStringRef; external name '_kSCPropNetPPPCommRemoteAddress'; (* attribute const *) { CFString	"CommRemoteAddress" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPCommTerminalScript: CFStringRef; external name '_kSCPropNetPPPCommTerminalScript'; (* attribute const *) { CFString	"CommTerminalScript" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPCommUseTerminalScript: CFStringRef; external name '_kSCPropNetPPPCommUseTerminalScript'; (* attribute const *) { CFNumber (0 or 1)	"CommUseTerminalScript" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetPPPCCPEnabled: CFStringRef; external name '_kSCPropNetPPPCCPEnabled'; (* attribute const *) { CFNumber (0 or 1)	"CCPEnabled" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_2,__IPHONE_NA) *)

var kSCPropNetPPPCCPMPPE40Enabled: CFStringRef; external name '_kSCPropNetPPPCCPMPPE40Enabled'; (* attribute const *) { CFNumber (0 or 1)	"CCPMPPE40Enabled" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCPropNetPPPCCPMPPE128Enabled: CFStringRef; external name '_kSCPropNetPPPCCPMPPE128Enabled'; (* attribute const *) { CFNumber (0 or 1)	"CCPMPPE128Enabled" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCPropNetPPPIPCPCompressionVJ: CFStringRef; external name '_kSCPropNetPPPIPCPCompressionVJ'; (* attribute const *) { CFNumber (0 or 1)	"IPCPCompressionVJ" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPIPCPUsePeerDNS: CFStringRef; external name '_kSCPropNetPPPIPCPUsePeerDNS'; (* attribute const *) { CFNumber (0 or 1)	"IPCPUsePeerDNS" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCPropNetPPPLCPEchoEnabled: CFStringRef; external name '_kSCPropNetPPPLCPEchoEnabled'; (* attribute const *) { CFNumber (0 or 1)	"LCPEchoEnabled" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPLCPEchoFailure: CFStringRef; external name '_kSCPropNetPPPLCPEchoFailure'; (* attribute const *) { CFNumber	"LCPEchoFailure" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPLCPEchoInterval: CFStringRef; external name '_kSCPropNetPPPLCPEchoInterval'; (* attribute const *) { CFNumber	"LCPEchoInterval" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPLCPCompressionACField: CFStringRef; external name '_kSCPropNetPPPLCPCompressionACField'; (* attribute const *) { CFNumber (0 or 1)	"LCPCompressionACField" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPLCPCompressionPField: CFStringRef; external name '_kSCPropNetPPPLCPCompressionPField'; (* attribute const *) { CFNumber (0 or 1)	"LCPCompressionPField" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPLCPMRU: CFStringRef; external name '_kSCPropNetPPPLCPMRU'; (* attribute const *) { CFNumber	"LCPMRU" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPLCPMTU: CFStringRef; external name '_kSCPropNetPPPLCPMTU'; (* attribute const *) { CFNumber	"LCPMTU" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPLCPReceiveACCM: CFStringRef; external name '_kSCPropNetPPPLCPReceiveACCM'; (* attribute const *) { CFNumber	"LCPReceiveACCM" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetPPPLCPTransmitACCM: CFStringRef; external name '_kSCPropNetPPPLCPTransmitACCM'; (* attribute const *) { CFNumber	"LCPTransmitACCM" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetL2TPIPSecSharedSecret: CFStringRef; external name '_kSCPropNetL2TPIPSecSharedSecret'; (* attribute const *) { CFString	"IPSecSharedSecret" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetL2TPIPSecSharedSecretEncryption: CFStringRef; external name '_kSCPropNetL2TPIPSecSharedSecretEncryption'; (* attribute const *) { CFString	"IPSecSharedSecretEncryption" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetL2TPTransport: CFStringRef; external name '_kSCPropNetL2TPTransport'; (* attribute const *) { CFString	"Transport" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetL2TPIPSecSharedSecretEncryptionKeychain: CFStringRef; external name '_kSCValNetL2TPIPSecSharedSecretEncryptionKeychain'; (* attribute const *) { 	"Keychain" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetL2TPTransportIP: CFStringRef; external name '_kSCValNetL2TPTransportIP'; (* attribute const *) { 	"IP" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCValNetL2TPTransportIPSec: CFStringRef; external name '_kSCValNetL2TPTransportIPSec'; (* attribute const *) { 	"IPSec" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_3,__IPHONE_NA) *)

var kSCPropNetProxiesExceptionsList: CFStringRef; external name '_kSCPropNetProxiesExceptionsList'; (* attribute const *) { CFArray[CFString]	"ExceptionsList" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesExcludeSimpleHostnames: CFStringRef; external name '_kSCPropNetProxiesExcludeSimpleHostnames'; (* attribute const *) { CFNumber (0 or 1)	"ExcludeSimpleHostnames" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCPropNetProxiesFTPEnable: CFStringRef; external name '_kSCPropNetProxiesFTPEnable'; (* attribute const *) { CFNumber (0 or 1)	"FTPEnable" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesFTPPassive: CFStringRef; external name '_kSCPropNetProxiesFTPPassive'; (* attribute const *) { CFNumber (0 or 1)	"FTPPassive" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesFTPPort: CFStringRef; external name '_kSCPropNetProxiesFTPPort'; (* attribute const *) { CFNumber	"FTPPort" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesFTPProxy: CFStringRef; external name '_kSCPropNetProxiesFTPProxy'; (* attribute const *) { CFString	"FTPProxy" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesGopherEnable: CFStringRef; external name '_kSCPropNetProxiesGopherEnable'; (* attribute const *) { CFNumber (0 or 1)	"GopherEnable" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesGopherPort: CFStringRef; external name '_kSCPropNetProxiesGopherPort'; (* attribute const *) { CFNumber	"GopherPort" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesGopherProxy: CFStringRef; external name '_kSCPropNetProxiesGopherProxy'; (* attribute const *) { CFString	"GopherProxy" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesHTTPEnable: CFStringRef; external name '_kSCPropNetProxiesHTTPEnable'; (* attribute const *) { CFNumber (0 or 1)	"HTTPEnable" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesHTTPPort: CFStringRef; external name '_kSCPropNetProxiesHTTPPort'; (* attribute const *) { CFNumber	"HTTPPort" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesHTTPProxy: CFStringRef; external name '_kSCPropNetProxiesHTTPProxy'; (* attribute const *) { CFString	"HTTPProxy" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesHTTPSEnable: CFStringRef; external name '_kSCPropNetProxiesHTTPSEnable'; (* attribute const *) { CFNumber (0 or 1)	"HTTPSEnable" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesHTTPSPort: CFStringRef; external name '_kSCPropNetProxiesHTTPSPort'; (* attribute const *) { CFNumber	"HTTPSPort" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesHTTPSProxy: CFStringRef; external name '_kSCPropNetProxiesHTTPSProxy'; (* attribute const *) { CFString	"HTTPSProxy" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesRTSPEnable: CFStringRef; external name '_kSCPropNetProxiesRTSPEnable'; (* attribute const *) { CFNumber (0 or 1)	"RTSPEnable" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesRTSPPort: CFStringRef; external name '_kSCPropNetProxiesRTSPPort'; (* attribute const *) { CFNumber	"RTSPPort" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesRTSPProxy: CFStringRef; external name '_kSCPropNetProxiesRTSPProxy'; (* attribute const *) { CFString	"RTSPProxy" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesSOCKSEnable: CFStringRef; external name '_kSCPropNetProxiesSOCKSEnable'; (* attribute const *) { CFNumber (0 or 1)	"SOCKSEnable" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesSOCKSPort: CFStringRef; external name '_kSCPropNetProxiesSOCKSPort'; (* attribute const *) { CFNumber	"SOCKSPort" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesSOCKSProxy: CFStringRef; external name '_kSCPropNetProxiesSOCKSProxy'; (* attribute const *) { CFString	"SOCKSProxy" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropNetProxiesProxyAutoConfigEnable: CFStringRef; external name '_kSCPropNetProxiesProxyAutoConfigEnable'; (* attribute const *) { CFNumber (0 or 1)	"ProxyAutoConfigEnable" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCPropNetProxiesProxyAutoConfigJavaScript: CFStringRef; external name '_kSCPropNetProxiesProxyAutoConfigJavaScript'; (* attribute const *) { CFString	"ProxyAutoConfigJavaScript" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_NA) *)

var kSCPropNetProxiesProxyAutoConfigURLString: CFStringRef; external name '_kSCPropNetProxiesProxyAutoConfigURLString'; (* attribute const *) { CFString	"ProxyAutoConfigURLString" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

var kSCPropNetProxiesProxyAutoDiscoveryEnable: CFStringRef; external name '_kSCPropNetProxiesProxyAutoDiscoveryEnable'; (* attribute const *) { CFNumber (0 or 1)	"ProxyAutoDiscoveryEnable" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_4,__IPHONE_NA) *)

{$ifc not TARGET_OS_IPHONE}

var kSCPropNetSMBNetBIOSName: CFStringRef; external name '_kSCPropNetSMBNetBIOSName'; (* attribute const *) { CFString	"NetBIOSName" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetSMBNetBIOSNodeType: CFStringRef; external name '_kSCPropNetSMBNetBIOSNodeType'; (* attribute const *) { CFString	"NetBIOSNodeType" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetSMBNetBIOSScope: CFStringRef; external name '_kSCPropNetSMBNetBIOSScope'; (* attribute const *) { CFString	"NetBIOSScope" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetSMBWINSAddresses: CFStringRef; external name '_kSCPropNetSMBWINSAddresses'; (* attribute const *) { CFArray[CFString]	"WINSAddresses" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCPropNetSMBWorkgroup: CFStringRef; external name '_kSCPropNetSMBWorkgroup'; (* attribute const *) { CFString	"Workgroup" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCValNetSMBNetBIOSNodeTypeBroadcast: CFStringRef; external name '_kSCValNetSMBNetBIOSNodeTypeBroadcast'; (* attribute const *) { 	"Broadcast" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCValNetSMBNetBIOSNodeTypePeer: CFStringRef; external name '_kSCValNetSMBNetBIOSNodeTypePeer'; (* attribute const *) { 	"Peer" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCValNetSMBNetBIOSNodeTypeMixed: CFStringRef; external name '_kSCValNetSMBNetBIOSNodeTypeMixed'; (* attribute const *) { 	"Mixed" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

var kSCValNetSMBNetBIOSNodeTypeHybrid: CFStringRef; external name '_kSCValNetSMBNetBIOSNodeTypeHybrid'; (* attribute const *) { 	"Hybrid" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_5,__IPHONE_NA) *)

{$endc} {not TARGET_OS_IPHONE}

{$ifc not TARGET_OS_IPHONE}

var kSCEntUsersConsoleUser: CFStringRef; external name '_kSCEntUsersConsoleUser'; (* attribute const *) { 	"ConsoleUser" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

{$endc} {not TARGET_OS_IPHONE}

var kSCPropSystemComputerName: CFStringRef; external name '_kSCPropSystemComputerName'; (* attribute const *) { CFString	"ComputerName" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCPropSystemComputerNameEncoding: CFStringRef; external name '_kSCPropSystemComputerNameEncoding'; (* attribute const *) { CFNumber	"ComputerNameEncoding" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCDynamicStoreDomainFile: CFStringRef; external name '_kSCDynamicStoreDomainFile'; (* attribute const *) { 	"File:" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCDynamicStoreDomainPlugin: CFStringRef; external name '_kSCDynamicStoreDomainPlugin'; (* attribute const *) { 	"Plugin:" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCDynamicStoreDomainSetup: CFStringRef; external name '_kSCDynamicStoreDomainSetup'; (* attribute const *) { 	"Setup:" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCDynamicStoreDomainState: CFStringRef; external name '_kSCDynamicStoreDomainState'; (* attribute const *) { 	"State:" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCDynamicStoreDomainPrefs: CFStringRef; external name '_kSCDynamicStoreDomainPrefs'; (* attribute const *) { 	"Prefs:" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCDynamicStorePropSetupCurrentSet: CFStringRef; external name '_kSCDynamicStorePropSetupCurrentSet'; (* attribute const *) { CFString	"CurrentSet" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCDynamicStorePropSetupLastUpdated: CFStringRef; external name '_kSCDynamicStorePropSetupLastUpdated'; (* attribute const *) { 	"LastUpdated" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCDynamicStorePropNetInterfaces: CFStringRef; external name '_kSCDynamicStorePropNetInterfaces'; (* attribute const *) { CFArray[CFString]	"Interfaces" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCDynamicStorePropNetPrimaryInterface: CFStringRef; external name '_kSCDynamicStorePropNetPrimaryInterface'; (* attribute const *) { CFString	"PrimaryInterface" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCDynamicStorePropNetPrimaryService: CFStringRef; external name '_kSCDynamicStorePropNetPrimaryService'; (* attribute const *) { CFString	"PrimaryService" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

var kSCDynamicStorePropNetServiceIDs: CFStringRef; external name '_kSCDynamicStorePropNetServiceIDs'; (* attribute const *) { CFArray[CFString]	"ServiceIDs" }
(* __OSX_AVAILABLE_STARTING(__MAC_10_1,__IPHONE_NA) *)

{$ifc not TARGET_OS_IPHONE}

{$ifc USE_CFSTR_CONSTANT_MACROS}
{$definec kSCPropUsersConsoleUserName CFSTRP('Name')}
{$endc}                            { CFString }
// __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_4,__IPHONE_NA,__IPHONE_NA);

{$ifc USE_CFSTR_CONSTANT_MACROS}
{$definec kSCPropUsersConsoleUserUID CFSTRP('UID')}
{$endc}                             { CFNumber }
// __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_4,__IPHONE_NA,__IPHONE_NA);

{$ifc USE_CFSTR_CONSTANT_MACROS}
{$definec kSCPropUsersConsoleUserGID CFSTRP('GID')}
{$endc}                             { CFNumber }
// __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_1,__MAC_10_4,__IPHONE_NA,__IPHONE_NA);

{$endc} {not TARGET_OS_IPHONE}


{$endc} {TARGET_OS_MAC}

{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
