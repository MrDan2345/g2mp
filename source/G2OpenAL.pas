unit G2OpenAL;
{$include Gen2MP.inc}
interface

uses
  G2Utils;

const
  {$if defined(G2Target_Windows)}
  LibAL = 'OpenAL32.dll';
  {$elseif defined(G2Target_Linux)}
  LibAL = 'libopenal.so';
  {$elseif defined(G2Target_OSX) or defined(G2Target_iOS)}
  LibAL = '/System/Library/Frameworks/OpenAL.framework/OpenAL';
  {$endif}

  {$message 'OpenAL All'}

type
  TALBoolean = Boolean;
  PALBoolean = ^TALBoolean;
  TALByte = ShortInt;
  PALByte = ^TALByte;
  TALUByte = Byte;
  PALUByte = ^TALUByte;
  TALShort = SmallInt;
  PALShort = ^TALShort;
  TALUShort = Word;
  PALUShort = ^TALUShort;
  TALUInt = LongWord;
  PALUInt = ^TALUInt;
  TALInt = Integer;
  PALInt = ^TALInt;
  TALFloat = Single;
  PALFloat = ^TALFloat;
  TALDouble = Double;
  PALDouble = ^TALDouble;
  TALSizei = LongWord;
  PALSizei = ^TALSizei;
  TALVoid = Pointer;
  PALVoid = ^TALVoid;
  PPALVoid = ^PALVoid;
  TALEnum = Integer;
  PALEnum = ^TALEnum;
  TALBitField = LongWord;
  PALBitField = ^TALBitField;
  TALClampf = TALFloat;
  PALClampf = ^TALClampf;
  TALClampd = TALDouble;
  PALClampd = ^TALClampd;
  TALCBoolean = Boolean;
  PALCBoolean = ^TALCBoolean;
  TALCByte = ShortInt;
  PALCByte = ^TALCByte;
  TALCUByte = Byte;
  PALCUByte = ^TALCUByte;
  TALCShort = SmallInt;
  PALCShort = ^TALCShort;
  TALCUShort = Word;
  PALCUShort = ^TALCUShort;
  TALCUInt = LongWord;
  PALCUInt = ^TALCUInt;
  TALCInt = Integer;
  PALCInt = ^TALCInt;
  TALCFloat = Single;
  PALCFloat = ^TALCFloat;
  TALCDouble = Double;
  PALCDouble = ^TALCDouble;
  TALCSizei = Integer;
  PALCSizei = ^TALCSizei;
  TALCEnum = Integer;
  PALCEnum = ^TALCEnum;
  TALCVoid = Pointer;
  PALCVoid = ^TALCvoid;
  PALCContext = ^TALCContext;
  TALCContext = TALCVoid;
  PALCDevice = ^TALCDevice;
  TALCDevice = TALCVoid;

const
  AL_INVALID = -1;
  AL_NONE = 0;
  AL_FALSE = 0;
  AL_TRUE = 1;

  AL_SOURCE_TYPE = $200;
  AL_SOURCE_ABSOLUTE = $201;
  AL_SOURCE_RELATIVE = $202;
  AL_SOURCE_MULTICHANNEL = $204;
  AL_SOURCE_POINT = $205;

  AL_CONE_INNER_ANGLE = $1001;
  AL_CONE_OUTER_ANGLE = $1002;
  AL_PITCH = $1003;
  AL_POSITION = $1004;
  AL_DIRECTION = $1005;
  AL_VELOCITY = $1006;
  AL_LOOPING = $1007;
  AL_STREAMING = $1008;
  AL_BUFFER = $1009;
  AL_GAIN = $100A;
  AL_SOURCE_AMBIENT = $100B;
  AL_BYTE_LOKI = $100C;
  AL_MIN_GAIN = $100D;
  AL_MAX_GAIN = $100E;
  AL_ORIENTATION = $100F;
  AL_SOURCE_STATE = $1010;
  AL_INITIAL = $1011;
  AL_PLAYING = $1012;
  AL_PAUSED = $1013;
  AL_STOPPED = $1014;
  AL_BUFFERS_QUEUED = $1015;
  AL_BUFFERS_PROCESSED = $1016;

  AL_FORMAT_MONO8 = $1100;
  AL_FORMAT_MONO16 = $1101;
  AL_FORMAT_STEREO8 = $1102;
  AL_FORMAT_STEREO16 = $1103;

  AL_REFERENCE_DISTANCE = $1020;
  AL_ROLLOFF_FACTOR = $1021;
  AL_CONE_OUTER_GAIN = $1022;
  AL_MAX_DISTANCE = $1023;

  AL_FREQUENCY = $2001;
  AL_BITS = $2002;
  AL_CHANNELS = $2003;
  AL_SIZE = $2004;
  AL_DATA = $2005;

  AL_UNUSED = $2010;
  AL_PENDING = $2011;
  AL_CURRENT = $2012;

  AL_NO_ERROR = AL_FALSE;
  AL_INVALID_NAME = $A001;
  AL_INVALID_ENUM = $A002;
  AL_INVALID_VALUE = $A003;
  AL_INVALID_OPERATION = $A004;
  AL_OUT_OF_MEMORY = $A005;

  AL_VENDOR = $B001;
  AL_VERSION = $B002;
  AL_RENDERER = $B003;
  AL_EXTENSIONS = $B004;

  AL_DOPPLER_FACTOR = $C000;
  AL_DOPPLER_VELOCITY = $C001;
  AL_DISTANCE_SCALE = $C002;

  AL_DISTANCE_MODEL = $D000;
  AL_INVERSE_DISTANCE = $D001;
  AL_INVERSE_DISTANCE_CLAMPED = $D002;

  AL_CHANNEL_MASK = $3000;
  AL_ENV_ROOM_IASIG = $3001;
  AL_ENV_ROOM_HIGH_FREQUENCY_IASIG = $3002;
  AL_ENY_ROOM_ROLLOFF_FACTOR_IASIG = $3003;
  AL_ENV_DECAY_TIME_IASIG = $3004;
  AL_ENV_DECAY_HIGH_FREQUENCY_RATIO_IASIG = $3005;
  AL_ENV_REFLECTIONS_IASIG = $3006;
  AL_ENV_REFLECTIONS_DELAY_IASIG = $3006;
  AL_ENV_REVERB_IASIG = $3007;
  AL_ENV_REVERB_DELAY_IASIG = $3008;
  AL_ENV_DIFFUSION_IASIG = $3009;
  AL_ENV_DENSITY_IASIG = $300A;
  AL_ENV_HIGH_FREQUENCY_REFERENCE_IASIG = $300B;
  AL_ENV_LISTENER_ENVIRONMENT_IASIG = $300C;
  AL_ENV_SOURCE_ENVIRONMENT_IASIG = $300D;

  ALC_INVALID = -1;
  ALC_FALSE = 0;
  ALC_TRUE = 1;
  ALC_NO_ERROR = ALC_FALSE;

  ALC_MAJOR_VERSION = $1000;
  ALC_MINOR_VERSION = $1001;
  ALC_ATTRIBUTES_SIZE = $1002;
  ALC_ALL_ATTRIBUTES = $1003;
  ALC_DEFAULT_DEVICE_SPECIFIER = $1004;
  ALC_DEVICE_SPECIFIER = $1005;
  ALC_EXTENSIONS = $1006;
  ALC_FREQUENCY = $1007;
  ALC_REFRESH = $1008;
  ALC_SYNC = $1009;

  ALC_INVALID_DEVICE = $A001;
  ALC_INVALID_CONTEXT = $A002;
  ALC_INVALID_ENUM = $A003;
  ALC_INVALID_VALUE = $A004;
  ALC_OUT_OF_MEMORY = $A005;

var
  alInit: procedure (argc: PALInt; argv: PALUByte); cdecl;
  alExit: procedure ; cdecl;
  alEnable: procedure (Capability: TALEnum); cdecl;
  alDisable: procedure (Capability: TALEnum); cdecl;
  alIsEnabled: function (Capability: TALEnum): TALBoolean; cdecl;
  alHint: procedure (Target, Mode: TALEnum); cdecl;
  alGetBoolean: function (Param: TALEnum): TALBoolean; cdecl;
  alGetInteger: function (Param: TALEnum): TALInt; cdecl;
  alGetFloat: function (Param: TALEnum): TALFloat; cdecl;
  alGetDouble: function (Param: TALEnum): TALDouble; cdecl;
  alGetBooleanv: procedure (Param: TALEnum; Data: PALBoolean); cdecl;
  alGetIntegerv: procedure (Param: TALEnum; Data: PALInt); cdecl;
  alGetFloatv: procedure (Param: TALEnum; Data: PALFloat); cdecl;
  alGetDoublev: procedure (Param: TALEnum; Data: PALDouble); cdecl;
  alGetString: function (Param: TALEnum): PALUByte; cdecl;
  alGetError: function : TALEnum; cdecl;
  alIsExtensionPresent: function (FName: PAnsiChar): TALBoolean; cdecl;
  alGetProcAddress: function (FName: PALUByte): Pointer; cdecl;
  alGetEnumValue: function (EName: PALUByte): TALEnum; cdecl;
  alListeneri: procedure (Param: TAlEnum; Value: TALInt); cdecl;
  alListenerf: procedure (Param: TALEnum; Value: TALFloat); cdecl;
  alListener3f: procedure (Param: TALEnum; f1: TALFloat; f2: TALFloat; f3: TALFloat); cdecl;
  alListenerfv: procedure (Param: TALEnum; Values: PALFloat); cdecl;
  alGetListeneriv: procedure (Param: TALEnum; Values: PALInt); cdecl;
  alGetListenerfv: procedure (Param: TALEnum; Values: PALFloat); cdecl;
  alGenSources: procedure (n: TALSizei; Sources: PALUInt); cdecl;
  alDeleteSources: procedure (n: TALSizei; Sources: PALUInt); cdecl;
  alIsSource: function (id: TALUInt): TALBoolean; cdecl;
  alSourcei: procedure (Source: TALUInt; Param: TALEnum; Value: TALInt); cdecl;
  alSourcef: procedure (Source: TALUInt; Param: TALEnum; Value: TALFloat); cdecl;
  alSource3f: procedure (Source: TALUInt; Param: TALEnum; v1: TALFloat; v2: TALFloat; v3: TALFloat); cdecl;
  alSourcefv: procedure (Source: TALUInt; Param: TALEnum; Values: PALFloat); cdecl;
  alGetSourcei: procedure (Source: TALUInt; Param: TALEnum; Value: PALInt); cdecl;
  alGetSourcef: procedure (Source: TALUInt; Param: TALEnum; Value: PALFloat); cdecl;
  alGetSource3f: procedure (Source: TALUInt; Param: TALEnum; v1: PALFloat; v2: PALFloat; v3: PALFloat); cdecl;
  alGetSourcefv: procedure (Source: TALUInt; Param: TALEnum; Values: PALFloat); cdecl;
  alSourcePlayv: procedure (n: TALSizei; Sources: PALUInt); cdecl;
  alSourceStopv: procedure (n: TALSizei; Sources: PALUInt); cdecl;
  alSourceRewindv: procedure (n: TALSizei; Sources: PALUInt); cdecl;
  alSourcePausev: procedure (n: TALSizei; Sources: PALUInt); cdecl;
  alSourcePlay: procedure (Source: TALUInt); cdecl;
  alSourcePause: procedure (Source: TALUInt); cdecl;
  alSourceStop: procedure (Source: TALUInt); cdecl;
  alSourceRewind: procedure (Source: TALUInt); cdecl;
  alGenBuffers: procedure (n: TALSizei; Buffers: PALUInt); cdecl;
  alDeleteBuffers: procedure (n: TALSizei; Buffers: PALUInt); cdecl;
  alIsBuffer: function (Buffer: TALUInt): TALBoolean; cdecl;
  alBufferData: procedure (Buffer: TALUInt; Format: TALEnum; Data: Pointer; Size, Freq: TALSizei); cdecl;
  alGetBufferi: procedure (Buffer: TALUInt; Param: TALEnum; Value: PALInt); cdecl;
  alGetBufferf: procedure (Buffer: TALUInt; Param: TALEnum; Value: PALFloat); cdecl;
  alGenEnvironmentIASIG: function (n: TALSizei; Environs: PALUInt): TALsizei; cdecl;
  alDeleteEnvironmentIASIG: procedure (n: TALSizei; Environs: PALUInt); cdecl;
  alIsEnvironmentIASIG: function (Environ: TALUInt): TALBoolean; cdecl;
  alEnvironmentiIASIG: procedure (eid: TALUint; Param: TALEnum; Value: TALInt); cdecl;
  alEnvironmentfIASIG: procedure (eid: TALUint; Param: TALEnum; Value: TALFloat); cdecl;
  alSourceQueueBuffers: procedure (Source: TALUint; n: TALSizei; Buffers: PALUInt); cdecl;
  alSourceUnqueueBuffers: procedure (Source: TALUInt; n: TALSizei; Buffers: PALUInt); cdecl;
  alQueuei: procedure (Source: TALUint; n: TALSizei; Buffers: PALUInt); cdecl;
  alDistanceModel: procedure (Value: TALEnum); cdecl;
  alDopplerFactor: procedure (Value: TALFloat); cdecl;
  alDopplerVelocity: procedure (Value: TALFloat); cdecl;

  alcGetString: function (Device: TALCDevice; Param: TALCenum): PALCUByte; cdecl;
  alcGetIntegerv: procedure (Device: TALCDevice; Param: TALCenum; Size: TALCSizei; Data: PALCint); cdecl;
  alcOpenDevice: function (DeviceName: PALCUByte): TALCdevice; cdecl;
  alcCloseDevice: procedure (Device: TALCDevice); cdecl;
  alcCreateContext: function (Device: TALCDevice; AttrList: PALCInt): TALCContext; cdecl;
  alcMakeContextCurrent: function (Context: TALCContext): TALCEnum; cdecl;
  alcProcessContext: procedure (Context: TALCContext); cdecl;
  alcGetCurrentContext: function : TALCContext; cdecl;
  alcGetContextsDevice: function (Context: TALCContext): TALCDevice; cdecl;
  alcSuspendContext: procedure (Context: TALCContext); cdecl;
  alcDestroyContext: procedure (Context: TALCContext); cdecl;
  alcGetError: function (Device: TALCDevice): TALCEnum; cdecl;
  alcIsExtensionPresent: function (Device: TALCDevice; ExtName: PALCUByte): TALCBoolean; cdecl;
  alcGetProcAddress: function (Device: TALCDevice; FuncName: PALCUByte): TALCVoid; cdecl;
  alcGetEnumValue: function (Device: TALCDevice; EnumName: PALCUByte): TALCEnum; cdecl;

implementation

var LibOpenAL: TG2DynLib;

  procedure alInitDummy (argc: PALInt; argv: PALUByte); cdecl; begin end;
  procedure alExitDummy; cdecl; begin end;
  procedure alEnableDummy (Capability: TALEnum); cdecl; begin end;
  procedure alDisableDummy (Capability: TALEnum); cdecl; begin end;
  function alIsEnabledDummy (Capability: TALEnum): TALBoolean; cdecl; begin Result := False; end;
  procedure alHintDummy (Target, Mode: TALEnum); cdecl; begin end;
  function alGetBooleanDummy (Param: TALEnum): TALBoolean; cdecl; begin Result := False; end;
  function alGetIntegerDummy (Param: TALEnum): TALInt; cdecl; begin Result := 0; end;
  function alGetFloatDummy (Param: TALEnum): TALFloat; cdecl; begin Result := 0; end;
  function alGetDoubleDummy (Param: TALEnum): TALDouble; cdecl; begin Result := 0; end;
  procedure alGetBooleanvDummy (Param: TALEnum; Data: PALBoolean); cdecl; begin end;
  procedure alGetIntegervDummy (Param: TALEnum; Data: PALInt); cdecl; begin end;
  procedure alGetFloatvDummy (Param: TALEnum; Data: PALFloat); cdecl; begin end;
  procedure alGetDoublevDummy (Param: TALEnum; Data: PALDouble); cdecl; begin end;
  function alGetStringDummy (Param: TALEnum): PALUByte; cdecl; begin Result := nil; end;
  function alGetErrorDummy: TALEnum; cdecl; begin Result := 0; end;
  function alIsExtensionPresentDummy (FName: PAnsiChar): TALBoolean; cdecl; begin Result := False; end;
  function alGetProcAddressDummy (FName: PALUByte): Pointer; cdecl; begin Result := nil; end;
  function alGetEnumValueDummy (EName: PALUByte): TALEnum; cdecl; begin Result := 0; end;
  procedure alListeneriDummy (Param: TAlEnum; Value: TALInt); cdecl; begin end;
  procedure alListenerfDummy (Param: TALEnum; Value: TALFloat); cdecl; begin end;
  procedure alListener3fDummy (Param: TALEnum; f1: TALFloat; f2: TALFloat; f3: TALFloat); cdecl; begin end;
  procedure alListenerfvDummy (Param: TALEnum; Values: PALFloat); cdecl; begin end;
  procedure alGetListenerivDummy (Param: TALEnum; Values: PALInt); cdecl; begin end;
  procedure alGetListenerfvDummy (Param: TALEnum; Values: PALFloat); cdecl; begin end;
  procedure alGenSourcesDummy (n: TALSizei; Sources: PALUInt); cdecl; begin end;
  procedure alDeleteSourcesDummy (n: TALSizei; Sources: PALUInt); cdecl; begin end;
  function alIsSourceDummy (id: TALUInt): TALBoolean; cdecl; begin Result := False; end;
  procedure alSourceiDummy (Source: TALUInt; Param: TALEnum; Value: TALInt); cdecl; begin end;
  procedure alSourcefDummy (Source: TALUInt; Param: TALEnum; Value: TALFloat); cdecl; begin end;
  procedure alSource3fDummy (Source: TALUInt; Param: TALEnum; v1: TALFloat; v2: TALFloat; v3: TALFloat); cdecl; begin end;
  procedure alSourcefvDummy (Source: TALUInt; Param: TALEnum; Values: PALFloat); cdecl; begin end;
  procedure alGetSourceiDummy (Source: TALUInt; Param: TALEnum; Value: PALInt); cdecl; begin end;
  procedure alGetSourcefDummy (Source: TALUInt; Param: TALEnum; Value: PALFloat); cdecl; begin end;
  procedure alGetSource3fDummy (Source: TALUInt; Param: TALEnum; v1: PALFloat; v2: PALFloat; v3: PALFloat); cdecl; begin end;
  procedure alGetSourcefvDummy (Source: TALUInt; Param: TALEnum; Values: PALFloat); cdecl; begin end;
  procedure alSourcePlayvDummy (n: TALSizei; Sources: PALUInt); cdecl; begin end;
  procedure alSourceStopvDummy (n: TALSizei; Sources: PALUInt); cdecl; begin end;
  procedure alSourceRewindvDummy (n: TALSizei; Sources: PALUInt); cdecl; begin end;
  procedure alSourcePausevDummy (n: TALSizei; Sources: PALUInt); cdecl; begin end;
  procedure alSourcePlayDummy (Source: TALUInt); cdecl; begin end;
  procedure alSourcePauseDummy (Source: TALUInt); cdecl; begin end;
  procedure alSourceStopDummy (Source: TALUInt); cdecl; begin end;
  procedure alSourceRewindDummy (Source: TALUInt); cdecl; begin end;
  procedure alGenBuffersDummy (n: TALSizei; Buffers: PALUInt); cdecl; begin end;
  procedure alDeleteBuffersDummy (n: TALSizei; Buffers: PALUInt); cdecl; begin end;
  function alIsBufferDummy (Buffer: TALUInt): TALBoolean; cdecl; begin Result := False; end;
  procedure alBufferDataDummy (Buffer: TALUInt; Format: TALEnum; Data: Pointer; Size, Freq: TALSizei); cdecl; begin end;
  procedure alGetBufferiDummy (Buffer: TALUInt; Param: TALEnum; Value: PALInt); cdecl; begin end;
  procedure alGetBufferfDummy (Buffer: TALUInt; Param: TALEnum; Value: PALFloat); cdecl; begin end;
  function alGenEnvironmentIASIGDummy (n: TALSizei; Environs: PALUInt): TALsizei; cdecl; begin Result := 0; end;
  procedure alDeleteEnvironmentIASIGDummy (n: TALSizei; Environs: PALUInt); cdecl; begin end;
  function alIsEnvironmentIASIGDummy (Environ: TALUInt): TALBoolean; cdecl; begin Result := False; end;
  procedure alEnvironmentiIASIGDummy (eid: TALUint; Param: TALEnum; Value: TALInt); cdecl; begin end;
  procedure alEnvironmentfIASIGDummy (eid: TALUint; Param: TALEnum; Value: TALFloat); cdecl; begin end;
  procedure alSourceQueueBuffersDummy (Source: TALUint; n: TALSizei; Buffers: PALUInt); cdecl; begin end;
  procedure alSourceUnqueueBuffersDummy (Source: TALUInt; n: TALSizei; Buffers: PALUInt); cdecl; begin end;
  procedure alQueueiDummy (Source: TALUint; n: TALSizei; Buffers: PALUInt); cdecl; begin end;
  procedure alDistanceModelDummy (Value: TALEnum); cdecl; begin end;
  procedure alDopplerFactorDummy (Value: TALFloat); cdecl; begin end;
  procedure alDopplerVelocityDummy (Value: TALFloat); cdecl; begin end;

  function alcGetStringDummy (Device: TALCDevice; Param: TALCenum): PALCUByte; cdecl; begin Result := nil; end;
  procedure alcGetIntegervDummy (Device: TALCDevice; Param: TALCenum; Size: TALCSizei; Data: PALCint); cdecl; begin end;
  function alcOpenDeviceDummy (DeviceName: PALCUByte): TALCdevice; cdecl; begin Result := nil; end;
  procedure alcCloseDeviceDummy (Device: TALCDevice); cdecl; begin end;
  function alcCreateContextDummy (Device: TALCDevice; AttrList: PALCInt): TALCContext; cdecl; begin Result := nil; end;
  function alcMakeContextCurrentDummy (Context: TALCContext): TALCEnum; cdecl; begin Result := 0; end;
  procedure alcProcessContextDummy (Context: TALCContext); cdecl; begin end;
  function alcGetCurrentContextDummy: TALCContext; cdecl; begin Result := nil; end;
  function alcGetContextsDeviceDummy (Context: TALCContext): TALCDevice; cdecl; begin Result := nil; end;
  procedure alcSuspendContextDummy (Context: TALCContext); cdecl; begin end;
  procedure alcDestroyContextDummy (Context: TALCContext); cdecl; begin end;
  function alcGetErrorDummy (Device: TALCDevice): TALCEnum; cdecl; begin Result := 0; end;
  function alcIsExtensionPresentDummy (Device: TALCDevice; ExtName: PALCUByte): TALCBoolean; cdecl; begin Result := False; end;
  function alcGetProcAddressDummy (Device: TALCDevice; FuncName: PALCUByte): TALCVoid; cdecl; begin Result := nil; end;
  function alcGetEnumValueDummy (Device: TALCDevice; EnumName: PALCUByte): TALCEnum; cdecl; begin Result := 0; end;

procedure UnInitOpenAL;
begin
  if LibOpenAL <> 0 then
  G2DynLibClose(LibOpenAL);
end;

procedure InitOpenAL;
begin
  if LibOpenAL <> 0 then UnInitOpenAL;
  LibOpenAL := G2DynLibOpen(LibAL);
  {$ifdef G2Target_Linux}
  if LibOpenAL = 0 then LibOpenAL := G2DynLibOpen('openal.so');
  if LibOpenAL = 0 then LibOpenAL := G2DynLibOpen('libopenal.so.0');
  if LibOpenAL = 0 then LibOpenAL := G2DynLibOpen('libopenal.so.1');
  {$endif}
  if LibOpenAL <> 0 then
  begin
    Pointer(alInit) := G2DynLibAddress(LibOpenAL, 'alInit');
    Pointer(alExit) := G2DynLibAddress(LibOpenAL, 'alExit');
    Pointer(alEnable) := G2DynLibAddress(LibOpenAL, 'alEnable');
    Pointer(alDisable) := G2DynLibAddress(LibOpenAL, 'alDisable');
    Pointer(alIsEnabled) := G2DynLibAddress(LibOpenAL, 'alIsEnabled');
    Pointer(alHint) := G2DynLibAddress(LibOpenAL, 'alHint');
    Pointer(alGetBoolean) := G2DynLibAddress(LibOpenAL, 'alGetBoolean');
    Pointer(alGetInteger) := G2DynLibAddress(LibOpenAL, 'alGetInteger');
    Pointer(alGetFloat) := G2DynLibAddress(LibOpenAL, 'alGetFloat');
    Pointer(alGetDouble) := G2DynLibAddress(LibOpenAL, 'alGetDouble');
    Pointer(alGetBooleanv) := G2DynLibAddress(LibOpenAL, 'alGetBooleanv');
    Pointer(alGetIntegerv) := G2DynLibAddress(LibOpenAL, 'alGetIntegerv');
    Pointer(alGetFloatv) := G2DynLibAddress(LibOpenAL, 'alGetFloatv');
    Pointer(alGetDoublev) := G2DynLibAddress(LibOpenAL, 'alGetDoublev');
    Pointer(alGetString) := G2DynLibAddress(LibOpenAL, 'alGetString');
    Pointer(alGetError) := G2DynLibAddress(LibOpenAL, 'alGetError');
    Pointer(alIsExtensionPresent) := G2DynLibAddress(LibOpenAL, 'alIsExtensionPresent');
    Pointer(alGetProcAddress) := G2DynLibAddress(LibOpenAL, 'alGetProcAddress');
    Pointer(alGetEnumValue) := G2DynLibAddress(LibOpenAL, 'alGetEnumValue');
    Pointer(alListeneri) := G2DynLibAddress(LibOpenAL, 'alListeneri');
    Pointer(alListenerf) := G2DynLibAddress(LibOpenAL, 'alListenerf');
    Pointer(alListener3f) := G2DynLibAddress(LibOpenAL, 'alListener3f');
    Pointer(alListenerfv) := G2DynLibAddress(LibOpenAL, 'alListenerfv');
    Pointer(alGetListeneriv) := G2DynLibAddress(LibOpenAL, 'alGetListeneriv');
    Pointer(alGetListenerfv) := G2DynLibAddress(LibOpenAL, 'alGetListenerfv');
    Pointer(alGenSources) := G2DynLibAddress(LibOpenAL, 'alGenSources');
    Pointer(alDeleteSources) := G2DynLibAddress(LibOpenAL, 'alDeleteSources');
    Pointer(alIsSource) := G2DynLibAddress(LibOpenAL, 'alIsSource');
    Pointer(alSourcei) := G2DynLibAddress(LibOpenAL, 'alSourcei');
    Pointer(alSourcef) := G2DynLibAddress(LibOpenAL, 'alSourcef');
    Pointer(alSource3f) := G2DynLibAddress(LibOpenAL, 'alSource3f');
    Pointer(alSourcefv) := G2DynLibAddress(LibOpenAL, 'alSourcefv');
    Pointer(alGetSourcei) := G2DynLibAddress(LibOpenAL, 'alGetSourcei');
    Pointer(alGetSourcef) := G2DynLibAddress(LibOpenAL, 'alGetSourcef');
    Pointer(alGetSource3f) := G2DynLibAddress(LibOpenAL, 'alGetSource3f');
    Pointer(alGetSourcefv) := G2DynLibAddress(LibOpenAL, 'alGetSourcefv');
    Pointer(alSourcePlayv) := G2DynLibAddress(LibOpenAL, 'alSourcePlayv');
    Pointer(alSourceStopv) := G2DynLibAddress(LibOpenAL, 'alSourceStopv');
    Pointer(alSourceRewindv) := G2DynLibAddress(LibOpenAL, 'alSourceRewindv');
    Pointer(alSourcePausev) := G2DynLibAddress(LibOpenAL, 'alSourcePausev');
    Pointer(alSourcePlay) := G2DynLibAddress(LibOpenAL, 'alSourcePlay');
    Pointer(alSourcePause) := G2DynLibAddress(LibOpenAL, 'alSourcePause');
    Pointer(alSourceStop) := G2DynLibAddress(LibOpenAL, 'alSourceStop');
    Pointer(alSourceRewind) := G2DynLibAddress(LibOpenAL, 'alSourceRewind');
    Pointer(alGenBuffers) := G2DynLibAddress(LibOpenAL, 'alGenBuffers');
    Pointer(alDeleteBuffers) := G2DynLibAddress(LibOpenAL, 'alDeleteBuffers');
    Pointer(alIsBuffer) := G2DynLibAddress(LibOpenAL, 'alIsBuffer');
    Pointer(alBufferData) := G2DynLibAddress(LibOpenAL, 'alBufferData');
    Pointer(alGetBufferi) := G2DynLibAddress(LibOpenAL, 'alGetBufferi');
    Pointer(alGetBufferf) := G2DynLibAddress(LibOpenAL, 'alGetBufferf');
    Pointer(alGenEnvironmentIASIG) := G2DynLibAddress(LibOpenAL, 'alGenEnvironmentIASIG');
    Pointer(alDeleteEnvironmentIASIG) := G2DynLibAddress(LibOpenAL, 'alDeleteEnvironmentIASIG');
    Pointer(alIsEnvironmentIASIG) := G2DynLibAddress(LibOpenAL, 'alIsEnvironmentIASIG');
    Pointer(alEnvironmentiIASIG) := G2DynLibAddress(LibOpenAL, 'alEnvironmentiIASIG');
    Pointer(alEnvironmentfIASIG) := G2DynLibAddress(LibOpenAL, 'alEnvironmentfIASIG');
    Pointer(alSourceQueueBuffers) := G2DynLibAddress(LibOpenAL, 'alSourceQueueBuffers');
    Pointer(alSourceUnqueueBuffers) := G2DynLibAddress(LibOpenAL, 'alSourceUnqueueBuffers');
    Pointer(alQueuei) := G2DynLibAddress(LibOpenAL, 'alQueuei');
    Pointer(alDistanceModel) := G2DynLibAddress(LibOpenAL, 'alDistanceModel');
    Pointer(alDopplerFactor) := G2DynLibAddress(LibOpenAL, 'alDopplerFactor');
    Pointer(alDopplerVelocity) := G2DynLibAddress(LibOpenAL, 'alDopplerVelocity');

    Pointer(alcGetString) := G2DynLibAddress(LibOpenAL, 'alcGetString');
    Pointer(alcGetIntegerv) := G2DynLibAddress(LibOpenAL, 'alcGetIntegerv');
    Pointer(alcOpenDevice) := G2DynLibAddress(LibOpenAL, 'alcOpenDevice');
    Pointer(alcCloseDevice) := G2DynLibAddress(LibOpenAL, 'alcCloseDevice');
    Pointer(alcCreateContext) := G2DynLibAddress(LibOpenAL, 'alcCreateContext');
    Pointer(alcMakeContextCurrent) := G2DynLibAddress(LibOpenAL, 'alcMakeContextCurrent');
    Pointer(alcProcessContext) := G2DynLibAddress(LibOpenAL, 'alcProcessContext');
    Pointer(alcGetCurrentContext) := G2DynLibAddress(LibOpenAL, 'alcGetCurrentContext');
    Pointer(alcGetContextsDevice) := G2DynLibAddress(LibOpenAL, 'alcGetContextsDevice');
    Pointer(alcSuspendContext) := G2DynLibAddress(LibOpenAL, 'alcSuspendContext');
    Pointer(alcDestroyContext) := G2DynLibAddress(LibOpenAL, 'alcDestroyContext');
    Pointer(alcGetError) := G2DynLibAddress(LibOpenAL, 'alcGetError');
    Pointer(alcIsExtensionPresent) := G2DynLibAddress(LibOpenAL, 'alcIsExtensionPresent');
    Pointer(alcGetProcAddress) := G2DynLibAddress(LibOpenAL, 'alcGetProcAddress');
    Pointer(alcGetEnumValue) := G2DynLibAddress(LibOpenAL, 'alcGetEnumValue');
  end
  else
  begin
    Pointer(alInit) := @alInitDummy;
    Pointer(alExit) := @alExitDummy;
    Pointer(alEnable) := @alEnableDummy;
    Pointer(alDisable) := @alDisableDummy;
    Pointer(alIsEnabled) := @alIsEnabledDummy;
    Pointer(alHint) := @alHintDummy;
    Pointer(alGetBoolean) := @alGetBooleanDummy;
    Pointer(alGetInteger) := @alGetIntegerDummy;
    Pointer(alGetFloat) := @alGetFloatDummy;
    Pointer(alGetDouble) := @alGetDoubleDummy;
    Pointer(alGetBooleanv) := @alGetBooleanvDummy;
    Pointer(alGetIntegerv) := @alGetIntegervDummy;
    Pointer(alGetFloatv) := @alGetFloatvDummy;
    Pointer(alGetDoublev) := @alGetDoublevDummy;
    Pointer(alGetString) := @alGetStringDummy;
    Pointer(alGetError) := @alGetErrorDummy;
    Pointer(alIsExtensionPresent) := @alIsExtensionPresentDummy;
    Pointer(alGetProcAddress) := @alGetProcAddressDummy;
    Pointer(alGetEnumValue) := @alGetEnumValueDummy;
    Pointer(alListeneri) := @alListeneriDummy;
    Pointer(alListenerf) := @alListenerfDummy;
    Pointer(alListener3f) := @alListener3fDummy;
    Pointer(alListenerfv) := @alListenerfvDummy;
    Pointer(alGetListeneriv) := @alGetListenerivDummy;
    Pointer(alGetListenerfv) := @alGetListenerfvDummy;
    Pointer(alGenSources) := @alGenSourcesDummy;
    Pointer(alDeleteSources) := @alDeleteSourcesDummy;
    Pointer(alIsSource) := @alIsSourceDummy;
    Pointer(alSourcei) := @alSourceiDummy;
    Pointer(alSourcef) := @alSourcefDummy;
    Pointer(alSource3f) := @alSource3fDummy;
    Pointer(alSourcefv) := @alSourcefvDummy;
    Pointer(alGetSourcei) := @alGetSourceiDummy;
    Pointer(alGetSourcef) := @alGetSourcefDummy;
    Pointer(alGetSource3f) := @alGetSource3fDummy;
    Pointer(alGetSourcefv) := @alGetSourcefvDummy;
    Pointer(alSourcePlayv) := @alSourcePlayvDummy;
    Pointer(alSourceStopv) := @alSourceStopvDummy;
    Pointer(alSourceRewindv) := @alSourceRewindvDummy;
    Pointer(alSourcePausev) := @alSourcePausevDummy;
    Pointer(alSourcePlay) := @alSourcePlayDummy;
    Pointer(alSourcePause) := @alSourcePauseDummy;
    Pointer(alSourceStop) := @alSourceStopDummy;
    Pointer(alSourceRewind) := @alSourceRewindDummy;
    Pointer(alGenBuffers) := @alGenBuffersDummy;
    Pointer(alDeleteBuffers) := @alDeleteBuffersDummy;
    Pointer(alIsBuffer) := @alIsBufferDummy;
    Pointer(alBufferData) := @alBufferDataDummy;
    Pointer(alGetBufferi) := @alGetBufferiDummy;
    Pointer(alGetBufferf) := @alGetBufferfDummy;
    Pointer(alGenEnvironmentIASIG) := @alGenEnvironmentIASIGDummy;
    Pointer(alDeleteEnvironmentIASIG) := @alDeleteEnvironmentIASIGDummy;
    Pointer(alIsEnvironmentIASIG) := @alIsEnvironmentIASIGDummy;
    Pointer(alEnvironmentiIASIG) := @alEnvironmentiIASIGDummy;
    Pointer(alEnvironmentfIASIG) := @alEnvironmentfIASIGDummy;
    Pointer(alSourceQueueBuffers) := @alSourceQueueBuffersDummy;
    Pointer(alSourceUnqueueBuffers) := @alSourceUnqueueBuffersDummy;
    Pointer(alQueuei) := @alQueueiDummy;
    Pointer(alDistanceModel) := @alDistanceModelDummy;
    Pointer(alDopplerFactor) := @alDopplerFactorDummy;
    Pointer(alDopplerVelocity) := @alDopplerVelocityDummy;

    Pointer(alcGetString) := @alcGetStringDummy;
    Pointer(alcGetIntegerv) := @alcGetIntegervDummy;
    Pointer(alcOpenDevice) := @alcOpenDeviceDummy;
    Pointer(alcCloseDevice) := @alcCloseDeviceDummy;
    Pointer(alcCreateContext) := @alcCreateContextDummy;
    Pointer(alcMakeContextCurrent) := @alcMakeContextCurrentDummy;
    Pointer(alcProcessContext) := @alcProcessContextDummy;
    Pointer(alcGetCurrentContext) := @alcGetCurrentContextDummy;
    Pointer(alcGetContextsDevice) := @alcGetContextsDeviceDummy;
    Pointer(alcSuspendContext) := @alcSuspendContextDummy;
    Pointer(alcDestroyContext) := @alcDestroyContextDummy;
    Pointer(alcGetError) := @alcGetErrorDummy;
    Pointer(alcIsExtensionPresent) := @alcIsExtensionPresentDummy;
    Pointer(alcGetProcAddress) := @alcGetProcAddressDummy;
    Pointer(alcGetEnumValue) := @alcGetEnumValueDummy;
  end;
end;

initialization
begin
  InitOpenAL;
end;

finalization
begin
  UnInitOpenAL;
end;

end.
