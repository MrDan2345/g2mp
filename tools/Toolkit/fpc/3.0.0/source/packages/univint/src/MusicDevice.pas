{
     File:       MusicDevice.h
 
     Contains:   MusicDevice Interfaces
  
     Copyright:  � 2000-2011 by Apple, Inc., all rights reserved.
 
     Bugs?:      For bug reports, consult the following page on
                 the World Wide Web:
 
                     http://www.freepascal.org/bugs.html
 
}
{  Pascal Translation:  Gorazd Krosl <gorazd_1957@yahoo.ca>, October 2009 }
{  Pascal Translation Update: Jonas Maebe <jonas@freepascal.org>, October 2012 }

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

unit MusicDevice;
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
uses MacTypes,AUComponent,AudioComponents,CoreAudioTypes;
{$endc} {not MACOSALLINCLUDE}

{$ifc TARGET_OS_MAC}
{$ALIGN POWER}

{$ifc not TARGET_CPU_64}
{$ALIGN MAC68K}
{$endc}

//=====================================================================================================================
//#pragma mark -
//#pragma mark Overview

{!
    @header MusicDevice
	
	@discussion
	A music device audio unit - what is commonly referred to as a music instrument - is used to render notes. 
	A note is a sound, usually pitched, that is started and stopped with a note number or pitch specifier.	
	A note is played on a group (in MIDI this is called a MIDI Channel) and the various state values of a 
	group (such as pitch bend, after-touch, etc) is inherited and controlled by every playing note on a given group. 
	A note can be individually stopped (which is the common case), or stopped with the "All Notes Off" message that 
	is sent to a specific group.

	A music instrument can be multi-timbral - that is, each group can have a particular patch (or sound) associated with 
	it, and different groups can have different patches. This is a common case for music instruments that implement 
	the General MIDI specification. In this case, the music instrument should return the number of available 
	patches at a given time as the value for the _InstrumentCount property.
	
	It is also common for instruments to be mono-timbral - that is, they are only capable of producing notes using a 
	single patch/sound and typically only respond to commands on one group. In this case, the music instrument 
	should return 0 as the value for the _InstrumentCount property.
	
	Parameters can be defined in Group Scope, and these parameter IDs within the range of 0 < 1024, are equivalent 
	to the standard definitions of control in the MIDI specification (up to the ID of). Parameters in group scope 
	above 1024 are audio unit defined.

	Notes can be created/started with one of two methods. To stop a note it must be stopped with the same API group 
	as was used to start it (MIDI or the extended Start/Stop note API.
	
	(1) the MIDI Note on event (MusicDeviceMIDIEvent)
		- notes must be stopped with the MIDI note off event (MusicDeviceMIDIEvent)
		The MIDI Note number is used to turn the note off for the specified channel
		
	(2) the extended Note API (MusicDeviceStartNote). This API returns a note instance ID.
		This is unique and can be used with the kAudioUnitScope_Note.
		It is also used to turn the note off with MusicDeviceStopNote
}

//=====================================================================================================================
//#pragma mark -
//#pragma mark Types

{!
	@typedef MusicDeviceInstrumentID
	@abstract type for instrument identifiers
}
type
	MusicDeviceInstrumentID = UInt32;

{!
	@typedef MusicDeviceStdNoteParams
	@abstract convenience struct for specifying a note and velocity
	
	@discussion This struct is the common usage for MusicDeviceStartNote, as most synths that implement this functionality 
				will only allow for the specification of a note number and velocity when starting a new note.
	
	@param			argCount
			Should be set to 2
	@param			mPitch
			The pitch of the new note, typically specified using a MIDI note number (and a fractional pitch) within the 
					range of 0 < 128. So 60 is middle C, 60.5 is middle C + 50 cents.
	@param			mVelocity
			The velocity of the new note - this can be a fractional value - specified as MIDI (within the range of 0 < 128)
}
type
	MusicDeviceStdNoteParams = record
		argCount: UInt32;		{ should be 2}
		mPitch: Float32;
		mVelocity: Float32;
	end;
	MusicDeviceStdNoteParamsPtr = ^MusicDeviceStdNoteParams;
	
{!
	@typedef NoteParamsControlValue
	@abstract used to describe a control and value
	
	@discussion This struct is used to describe a parameterID (a control in MIDI terminology, though it is not limited to 
					MIDI CC specifications) and the value of this parameter.
	
	@param			mID
			The parameter ID
	@param			mValue
			The value of that parameter
}
type
	NoteParamsControlValue = record
		mID: AudioUnitParameterID;
		mValue: AudioUnitParameterValue;
	end;
	NoteParamsControlValuePtr = ^NoteParamsControlValue;
	
{!
	@typedef MusicDeviceNoteParams
	@abstract Used to hold the value of the inParams parameter for the MusicDeviceStartNote function.
	
	@discussion The generic version of this structure describes an arg count (which is the number of mControls values 
				+ 1 for mPitch and 1 for mVelocity). So, argCount should at least be two. See MusicDeviceStdNoteParams 
				for the common use case, as many audio unit instruments will not respond to control values provided 
				in the start note function
	
	@param			argCount
			The number of controls + 2 (for mPitch and mVelocity)
	@param			mPitch
			The pitch of the new note, typically specified using a MIDI note number (and a fractional pitch) within the 
				range of 0 < 128. So 60 is middle C, 60.5 is middle C + 50 cents.
	@param			mVelocity
			The velocity of the new note - this can be a fractional value - specified as MIDI (within the range of 0 < 128)
	@param			mControls
			A variable length array with the number of elements: argCount - 2.
}
type
	MusicDeviceNoteParams = record
		argCount: UInt32;
		mPitch: Float32;
		mVelocity: Float32;
		mControls: array[0..0] of NoteParamsControlValue;				{ arbitrary length }
	end;
	MusicDeviceNoteParamsPtr = ^MusicDeviceNoteParams;
	
{!
	@enum	MusicNoteEvent
	@discussion This is used to signify that the patch used to start a note (its sound) is defined by the current 
					selection for the group ID; this is the normal usage in MIDI as any notes started on a given channel 
					(group ID) use the sound (patch) defined for that channel. See MusicDeviceStartNote
	
	@constant	kMusicNoteEvent_UseGroupInstrument
			Use the patch (instrument number) assigned to the new notes group ID
	@constant	kMusicNoteEvent_Unused
			The instrument ID is not specified
	
}
const
	kMusicNoteEvent_UseGroupInstrument = $FFFFFFFF;
	kMusicNoteEvent_Unused = $FFFFFFFF;

{!
	@typedef		MusicDeviceGroupID
	@discussion The type used to specify which group (channel number in MIDI) is used with a given command (new note, 
				control or parameter value change)
}
type
	MusicDeviceGroupID = UInt32;

{!
	@typedef		NoteInstanceID
	@discussion The type used to hold an unique identifier returned by MusicDeviceStartNote that is used to then address 
				that note (typically to turn the note off). An ID must be used for notes, because notes can be specified 
				by fractional pitches, and so using the MIDI note number is not sufficient to identify the note to turn 
				it off (or to apply polyphonic after touch). 
}
type
	NoteInstanceID = UInt32;

{!
	@typedef		MusicDeviceComponent
	@discussion	The unique type of a MusicDevice audio unit (which is an AudioComponentInstance)
}
type
	MusicDeviceComponent = AudioComponentInstance;

//=====================================================================================================================
//#pragma mark -
//#pragma mark Functions

{!
	@function	MusicDeviceMIDIEvent
	@abstract	Used to sent MIDI channel messages to an audio unit
	
	@discussion	This is the API used to send MIDI channel messages to an audio unit. The status and data parameters 
				are used exactly as described by the MIDI specification, including the combination of channel and 
				command in the status byte.
	
	@param			inUnit
				The audio unit
	@param			inStatus
				The MIDI status byte
	@param			inData1
				The first MIDI data byte (value is in the range 0 < 128)
	@param			inData2
				The second MIDI data byte (value is in the range 0 < 128). If the MIDI status byte only has one 
					
					data byte, this should be set to zero.
	@param			inOffsetSampleFrame
				If you are scheduling the MIDI Event from the audio unit's render thread, then you can supply a 
					sample offset that the audio unit may apply when applying that event in its next audio unit render. 
					This allows you to schedule to the sample, the time when a MIDI command is applied and is particularly 
					important when starting new notes. If you are not scheduling in the audio unit's render thread, 
					then you should set this value to 0

	@result			noErr, or an audio unit error code
}
function MusicDeviceMIDIEvent( inUnit: MusicDeviceComponent; inStatus: UInt32; inData1: UInt32; inData2: UInt32; inOffsetSampleFrame: UInt32 ): OSStatus; external name '_MusicDeviceMIDIEvent';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0,__IPHONE_NA) *)

{!
	@function	MusicDeviceSysEx
	@abstract	used to send any non-channel MIDI event to an audio unit
	
	@discussion	This is used to send any non-channel MIDI event to an audio unit. In practise this is a System Exclusive 
					(SysEx) MIDI message
	
	@param			inUnit
				The audio unit
	@param			inData
				The complete MIDI SysEx message including the F0 and F7 start and termination bytes
	@param			inLength
				The size, in bytes, of the data

	@result			noErr, or an audio unit error code
}
function MusicDeviceSysEx( inUnit: MusicDeviceComponent; const inData: UnivPtr; inLength: UInt32 ): OSStatus; external name '_MusicDeviceSysEx';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0,__IPHONE_NA) *)


{!
	@function	MusicDeviceStartNote
	@abstract	used to start a note
	
	@discussion	This function is used to start a note.  The caller must provide a NoteInstanceID to receive a 
					token that is then used to stop the note. The MusicDeviceStopNote call should be used to stop 
					notes started with this API. The token can also be used to address individual notes on the 
					kAudioUnitScope_Note if the audio unit supports it. The instrumentID is no longer used and the 
					kMusicNoteEvent_Unused constant should be specified (this takes the current patch for the 
					specifed group as the sound to use for the note).
	
			The Audio unit must provide an unique ID for the note instance ID. This ID must be non-zero and not 
					0xFFFFFFFF (any other UInt32 value is valid).
			
			Not all Music Device audio units implement the semantics of this API (though it is strongly recommended 
					that they do). A host application shoudl query the kMusicDeviceProperty_SupportsStartStopNote to 
					check that this is supported.
			
	@param			inUnit
				The audio unit
	@param			inInstrument
				The instrumentID is no longer used and the kMusicNoteEvent_Unused constant should be specified (this takes 
					the current patch for the specifed group as the sound to use for the note)
	@param			inGroupID
				The group ID that this note will be attached too. As with MIDI, all notes sounding on a groupID can be 
					controlled through the various parameters (such as pitch bend, etc) that can be specified on the Group 
					Scope
	@param			outNoteInstanceID
				A pointer to receive the token that is used to identify the note. This parameter must be specified
	@param			inOffsetSampleFrame
				If you are scheduling the MIDI Event from the audio unit's render thread, then you can supply a sample offset 
					that the audio unit may apply when starting the note in its next audio unit render. This allows you to 
					schedule to the sample and is particularly important when starting new notes. If you are not scheduling 
					in the audio unit's render thread, then you should set this value to 0
	@param			inParams
				The parameters to be used when starting the note - pitch and velocity must be specified
	
	@result			noErr, or an audio unit error code
}
function MusicDeviceStartNote( inUnit: MusicDeviceComponent; inInstrument: MusicDeviceInstrumentID; inGroupID: MusicDeviceGroupID; var outNoteInstanceID: NoteInstanceID; inOffsetSampleFrame: UInt32; const (*var*) inParams: MusicDeviceNoteParams ): OSStatus; external name '_MusicDeviceStartNote';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0,__IPHONE_NA) *)

{!
	@function	MusicDeviceStopNote
	@abstract	used to stop notes started with the MusicDeviceStartNote call

	@discussion	This call is used to stop notes that have been started with the MusicDeviceStartNote call; both the group ID 
					that the note was started on and the noteInstanceID should be specified.
	
	@param			inUnit
				The audio unit
	@param			inGroupID
				the group ID
	@param			inNoteInstanceID
				the note instance ID
	@param			inOffsetSampleFrame
				the sample offset within the next buffer rendered that the note should be turned off at

	@result			noErr, or an audio unit error code
}
function MusicDeviceStopNote( inUnit: MusicDeviceComponent; inGroupID: MusicDeviceGroupID; inNoteInstanceID: NoteInstanceID; inOffsetSampleFrame: UInt32 ): OSStatus; external name '_MusicDeviceStopNote';
(* __OSX_AVAILABLE_STARTING(__MAC_10_0,__IPHONE_NA) *)


{!
	@enum	Music Device range
	@constant	kMusicDeviceRange
				delineates the start of the selector ranges for music devices
				
	@constant	kMusicDeviceMIDIEventSelect
	@constant	kMusicDeviceSysExSelect
	@constant	kMusicDevicePrepareInstrumentSelect
	@constant	kMusicDeviceReleaseInstrumentSelect
	@constant	kMusicDeviceStartNoteSelect
	@constant	kMusicDeviceStopNoteSelect
}
const
	kMusicDeviceRange = $0100;
	kMusicDeviceMIDIEventSelect = $0101;
	kMusicDeviceSysExSelect = $0102;
	kMusicDevicePrepareInstrumentSelect = $0103;
	kMusicDeviceReleaseInstrumentSelect = $0104;
	kMusicDeviceStartNoteSelect = $0105;
	kMusicDeviceStopNoteSelect = $0106;

//=====================================================================================================================
//#pragma mark -
//#pragma mark Fast-dispatch function prototypes

{!
	@typedef		MusicDeviceMIDIEventProc
	@discussion		This proc can be exported through the FastDispatch property or is used as the prototype for
					an audio component dispatch for this selector. 
					
					The arguments are the same as are provided to the corresponding API call
	
	@param			inComponentStorage
					For a component manager component, this is the component instance storage pointer
	@param			inStatus
	@param			inData1
	@param			inData2
	@param			inOffsetSampleFrame

	@result			noErr, or an audio unit error code
}
type
	MusicDeviceMIDIEventProc = function( inComponentStorage: UnivPtr; inStatus: UInt32; inData1: UInt32; inData2: UInt32; inOffsetSampleFrame: UInt32 ): OSStatus;

{!
	@typedef		MusicDeviceSysExProc
	@discussion		This proc can be exported through the FastDispatch property or is used as the prototype for
					an audio component dispatch for this selector. 
					
					The arguments are the same as are provided to the corresponding API call
	
	@param			inComponentStorage
					For a component manager component, this is the component instance storage pointer
	@param			inData
	@param			inLength

	@result			noErr, or an audio unit error code
}
type
	MusicDeviceSysExProc = function( inComponentStorage: UnivPtr; (*const*) inData: UnivPtr; inLength: UInt32 ): OSStatus;

{!
	@typedef		MusicDeviceStartNoteProc
	@discussion		This proc can be exported through the FastDispatch property or is used as the prototype for
					an audio component dispatch for this selector. 
					
					The arguments are the same as are provided to the corresponding API call
	
	@param			inComponentStorage
					For a component manager component, this is the component instance storage pointer
	@param			inInstrument
	@param			inGroupID
	@param			outNoteInstanceID
	@param			inOffsetSampleFrame
	@param			inParams
	
	@result			noErr, or an audio unit error code
}
type
	MusicDeviceStartNoteProc = function( inComponentStorage: UnivPtr; inInstrument: MusicDeviceInstrumentID; inGroupID: MusicDeviceGroupID; var outNoteInstanceID: NoteInstanceID; inOffsetSampleFrame: UInt32; const (*var*) inParams: MusicDeviceNoteParams ): OSStatus;

{!
	@typedef		MusicDeviceStopNoteProc
	@discussion		This proc can be exported through the FastDispatch property or is used as the prototype for
					an audio component dispatch for this selector. 
					
					The arguments are the same as are provided to the corresponding API call
	
	@param			inComponentStorage
					For a component manager component, this is the component instance storage pointer
	@param			inGroupID
	@param			inNoteInstanceID
	@param			inOffsetSampleFrame
	
	@result			noErr, or an audio unit error code
}
type
	MusicDeviceStopNoteProc = function( inComponentStorage: UnivPtr; inGroupID: MusicDeviceGroupID; inNoteInstanceID: NoteInstanceID; inOffsetSampleFrame: UInt32 ): OSStatus;


//=====================================================================================================================
//#pragma mark -
//#pragma mark Deprecated
{
	The notion of instruments (separate voices assigned to different control groups) is a deprecated concept.
	
	Going forward, multitimbral synths are implemented using Part Scopes.
	
	Thus, the Prepare and Release Instrument API calls are deprecated (see also MusicDeviceStartNote)

}
function MusicDevicePrepareInstrument( inUnit: MusicDeviceComponent; inInstrument: MusicDeviceInstrumentID ): OSStatus; external name '_MusicDevicePrepareInstrument';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0,__MAC_10_5, __IPHONE_NA, __IPHONE_NA) *)


function MusicDeviceReleaseInstrument( inUnit: MusicDeviceComponent; inInstrument: MusicDeviceInstrumentID ): OSStatus; external name '_MusicDeviceReleaseInstrument';
(* __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_0,__MAC_10_5, __IPHONE_NA, __IPHONE_NA) *)

{$endc} { TARGET_OS_MAC }
{$ifc not defined MACOSALLINCLUDE or not MACOSALLINCLUDE}

end.
{$endc} {not MACOSALLINCLUDE}
