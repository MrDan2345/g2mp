{------------------------------------------------------------------------------------------------------------------------------
 *
 *  ImageCapture/ICACamera.h
 *
 *  Copyright (c) 2000-2006 Apple Computer, Inc. All rights reserved.
 *
 *  For bug reports, consult the following page onthe World Wide Web:
 *  http://www.freepascal.org/bugs.html
 *
 *----------------------------------------------------------------------------------------------------------------------------}
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

unit ICACamera;
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

//------------------------------------------------------------------------------------------------------------------------------


//------------------------------------------------------------------------------------------------------------------------------
{!
    @header ICACamera.h
    @discussion
        ICACamera.h defines digital still cameras specific constants used with the Image Capture framework APIs. 
}

//-------------------------------------------------------------------------------------------------------- Constant Descriptions

{! 
    @enum Fields in StorageInfo Dataset 
    @discussion
        Refer to section 5.5.3 of the PIMA 15740 (PTP) specification for descriptions and usage notes.
    @constant kICAPropertyCameraStorageType
        Storage type. <BR>Data type: UInt16.
    @constant kICAPropertyCameraFilesystemType
        File system type. <BR>Data type: UInt16.
    @constant kICAPropertyCameraAccessCapability
        Access capability. <BR>Data type: UInt16.
    @constant kICAPropertyCameraMaxCapacity
        Total storage capacity in bytes. <BR>Data type: UInt64.
    @constant kICAPropertyCameraFreeSpaceInBytes
        Free space available on storage in bytes. <BR>Data type: UInt64.
    @constant kICAPropertyCameraFreeSpaceInImages
        Number of images that may still be captured in to this store based on the current image capture settings on the camera. <BR>Data type: UInt32.
    @constant kICAPropertyCameraStorageDescription
        Storage description. <BR>Data type: null terminated string.
    @constant kICAPropertyCameraVolumeLabel
        Volume label. <BR>Data type: null terminated string.
  }
const
	kICAPropertyCameraStorageType = FourCharCode('stor');
	kICAPropertyCameraFilesystemType = FourCharCode('fsys');
	kICAPropertyCameraAccessCapability = FourCharCode('acap');
	kICAPropertyCameraMaxCapacity = FourCharCode('maxc');
	kICAPropertyCameraFreeSpaceInBytes = FourCharCode('fres');
	kICAPropertyCameraFreeSpaceInImages = FourCharCode('frei');
	kICAPropertyCameraStorageDescription = FourCharCode('stod');
	kICAPropertyCameraVolumeLabel = FourCharCode('voll');

{!
    @enum Values for kICAPropertyCameraStorageType 
    @discussion
        Values for kICAPropertyCameraStorageType.
    @constant kICAStorageUndefined
        Undefined.
    @constant kICAStorageFixedROM
        Fixed ROM.
    @constant kICAStorageRemovableROM
        Removable ROM.
    @constant kICAStorageFixedRAM
        Fixed RAM.
    @constant kICAStorageRemovableRAM
        Removable RAM.
  }
const
	kICAStorageUndefined = $0000;
	kICAStorageFixedROM = $0001;
	kICAStorageRemovableROM = $0002;
	kICAStorageFixedRAM = $0003;
	kICAStorageRemovableRAM = $0004;

{!
    @enum Values for kICAPropertyCameraFilesystemType 
    @discussion
        Values for kICAPropertyCameraFilesystemType.
    @constant kICAFileystemUndefined
        Undefined.
    @constant kICAFileystemGenericFlat
        Generic flat.
    @constant kICAFileystemGenericHierarchical
        Generic hierarchical.
    @constant kICAFileystemDCF
        DCF-conformant.
  }
const
	kICAFileystemUndefined = $0000;
	kICAFileystemGenericFlat = $0001;
	kICAFileystemGenericHierarchical = $0002;
	kICAFileystemDCF = $0003;

{! 
    @enum Values for kICAPropertyCameraAccessCapability 
    @discussion
        Values for kICAPropertyCameraAccessCapability.
    @constant kICAAccessReadWrite
        Read-write.
    @constant kICAAccessReadOnly
        Read-only without object deletion.
    @constant kICAAccessReadOnlyWithObjectDeletion
        Read-only with object deletion.
  }
const
	kICAAccessReadWrite = $0000;
	kICAAccessReadOnly = $0001;
	kICAAccessReadOnlyWithObjectDeletion = $0002;

{!
    @enum Standard camera properties
    @discussion
        Refer to section 13 of the PIMA 15740 (PTP) specification for descriptions and usage notes for these standard properties.
    @constant kICAPropertyCameraBatteryLevel
        Battery level. <BR>Property data type: UInt8; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraFunctionalMode
        Functional mode. <BR>Property data type: UInt16; Property desc forms: Enum.
    @constant kICAPropertyCameraImageSize
        Image size. <BR>Property data type: CFString; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraCompressionSetting
        Compression setting. <BR>Property data type: UInt8; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraWhiteBalance
        White balance. <BR>Property data type: UInt16; Property desc forms: Enum.
    @constant kICAPropertyCameraRGBGain
        RGB gain. <BR>Property data type: null terminated string; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraFNumber
        F-number. <BR>Property data type: UInt8; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraFocalLength
        Focal length. <BR>Property data type: UInt32; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraFocusDistance
        Focus distance. <BR>Property data type: UInt16; Property desc forms: Enum.
    @constant kICAPropertyCameraFocusMode
        Focus mode. <BR>Property data type: UInt16; Property desc forms: Enum.
    @constant kICAPropertyCameraExposureMeteringMode
        Exposure Metering mode. <BR>Property data type: UInt16; Property desc forms: Enum.
    @constant kICAPropertyCameraFlashMode
        Flash mode. <BR>Property data type: UInt16; Property desc forms: Enum.
    @constant kICAPropertyCameraExposureTime
        Exposure time. <BR>Property data type: UInt32; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraExposureProgramMode
        Exposure program mode. <BR>Property data type: UInt16; Property desc forms: Enum.
    @constant kICAPropertyCameraExposureIndex
        Exposure index. <BR>Property data type: UInt16; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraExposureBiasCompensation
        Exposure bias compensation. <BR>Property data type: UInt16; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraDateTime
        Date & time. <BR>Property data type: null terminated string; Property desc forms: none.
    @constant kICAPropertyCameraCaptureDelay
        Capture delay. <BR>Property data type: UInt32; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraStillCaptureMode
        Still capture mode. <BR>Property data type: UInt16; Property desc forms: Enum.
    @constant kICAPropertyCameraContrast
        Contrast. <BR>Property data type: UInt8; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraSharpness
        Sharpness. <BR>Property data type: UInt8; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraDigitalZoom
        Digital zoom. <BR>Property data type: UInt8; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraEffectMode
        Effect mode. <BR>Property data type: UInt16; Property desc forms: Enum.
    @constant kICAPropertyCameraBurstNumber
        Burst number. <BR>Property data type: UInt16; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraBurstInterval
        Burst interval. <BR>Property data type: UInt16; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraTimelapseNumber
        Timelapse number. <BR>Property data type: UInt16; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraTimelapseInterval
        Timelapse interval. <BR>Property data type: UInt32; Property desc forms: Enum/Range.
    @constant kICAPropertyCameraFocusMeteringMode
        Focus metering mode. <BR>Property data type: UInt16; Property desc forms: Enum.
    @constant kICAPropertyCameraUploadURL
        Upload URL. <BR>Property data type: null terminated string; Property desc forms: none.
    @constant kICAPropertyCameraArtist
        Artist. <BR>Property data type: null terminated string; Property desc forms: none.
    @constant kICAPropertyCameraCopyrightInfo
        Copyright info. <BR>Property data type: null terminated string; Property desc forms: none.
  }
const
	kICAPropertyCameraBatteryLevel = FourCharCode('5001');
	kICAPropertyCameraFunctionalMode = FourCharCode('5002');
	kICAPropertyCameraImageSize = FourCharCode('5003');
	kICAPropertyCameraCompressionSetting = FourCharCode('5004');
	kICAPropertyCameraWhiteBalance = FourCharCode('5005');
	kICAPropertyCameraRGBGain = FourCharCode('5006');
	kICAPropertyCameraFNumber = FourCharCode('5007');
	kICAPropertyCameraFocalLength = FourCharCode('5008');
	kICAPropertyCameraFocusDistance = FourCharCode('5009');
	kICAPropertyCameraFocusMode = FourCharCode('500A');
	kICAPropertyCameraExposureMeteringMode = FourCharCode('500B');
	kICAPropertyCameraFlashMode = FourCharCode('500C');
	kICAPropertyCameraExposureTime = FourCharCode('500D');
	kICAPropertyCameraExposureProgramMode = FourCharCode('500E');
	kICAPropertyCameraExposureIndex = FourCharCode('500F');
	kICAPropertyCameraExposureBiasCompensation = FourCharCode('5010');
	kICAPropertyCameraDateTime = FourCharCode('5011');
	kICAPropertyCameraCaptureDelay = FourCharCode('5012');
	kICAPropertyCameraStillCaptureMode = FourCharCode('5013');
	kICAPropertyCameraContrast = FourCharCode('5014');
	kICAPropertyCameraSharpness = FourCharCode('5015');
	kICAPropertyCameraDigitalZoom = FourCharCode('5016');
	kICAPropertyCameraEffectMode = FourCharCode('5017');
	kICAPropertyCameraBurstNumber = FourCharCode('5018');
	kICAPropertyCameraBurstInterval = FourCharCode('5019');
	kICAPropertyCameraTimelapseNumber = FourCharCode('501A');
	kICAPropertyCameraTimelapseInterval = FourCharCode('501B');
	kICAPropertyCameraFocusMeteringMode = FourCharCode('501C');
	kICAPropertyCameraUploadURL = FourCharCode('501D');
	kICAPropertyCameraArtist = FourCharCode('501E');
	kICAPropertyCameraCopyrightInfo = FourCharCode('501F');

{!
    @enum ImageCapture framework specific camera properties 
    @discussion
        ImageCapture framework specific camera properties.
    @constant kICAPropertyCameraIcon
        Camera icon in ICAThumbnail format.
    @constant kICAPropertyCameraSupportedMessages
        Messages supported/understood by the camera.
  }
const
	kICAPropertyCameraIcon = FourCharCode('icon');
	kICAPropertyCameraSupportedMessages = FourCharCode('msgs');

{!
    @enum Camera messages 
    @discussion
        Messages that can be sent to digital still cameras.
    @constant kICAMessageCameraCaptureNewImage
        Capture a new image using the camera.
    @constant kICAMessageCameraDeleteOne
        Delete one image stored in the camera.
    @constant kICAMessageCameraDeleteAll
        Delete all images stored in the camera.
    @constant kICAMessageCameraSyncClock
        Synchronize camera's clock with the computer's clock.
    @constant kICAMessageCameraUploadData
        Upload data to the camera.
  }
const
	kICAMessageCameraCaptureNewImage = FourCharCode('ccni');
	kICAMessageCameraDeleteOne = FourCharCode('del1');
	kICAMessageCameraDeleteAll = FourCharCode('dela');
	kICAMessageCameraSyncClock = FourCharCode('sclk');
	kICAMessageCameraUploadData = FourCharCode('load');

{!
    @enum Camera capabilities 
    @discussion
        Capabilities of digital still cameras.
    @constant kICAMessageCameraCaptureNewImage
        Can capture a new image using the camera.
    @constant kICAMessageCameraDeleteOne
        Can delete one image stored in the camera.
    @constant kICAMessageCameraDeleteAll
        Can delete all images stored in the camera.
    @constant kICAMessageCameraSyncClock
        Can synchronize camera's clock with the computer's clock.
    @constant kICAMessageCameraUploadData
        Can upload data to the camera.
  }
const
	kICACapabilityCanCameraCaptureNewImage = FourCharCode('ccni');
	kICACapabilityCanCameraDeleteOne = FourCharCode('del1');
	kICACapabilityCanCameraDeleteAll = FourCharCode('dela');
	kICACapabilityCanCameraSyncClock = FourCharCode('sclk');
	kICACapabilityCanCameraUploadData = FourCharCode('load');
	kICACapabilityMayStoreNewImagesInTempStore = FourCharCode('temp');

//------------------------------------------------------------------------------------------------------------------------------


//------------------------------------------------------------------------------------------------------------------------------

{$endc} {TARGET_OS_MAC}
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
