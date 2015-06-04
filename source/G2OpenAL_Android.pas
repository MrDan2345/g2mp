unit G2OpenAL_Android;
{$include Gen2MP.inc}
interface

uses
  G2OpenALTypes;

const
  LibAL = 'libopenal.so';

  {$message 'OpenAL for Android'}

procedure alInit(argc: PALInt; argv: PALUByte); cdecl; external LibAL;
procedure alExit; cdecl; external LibAL;
procedure alEnable(Capability: TALEnum); cdecl; external LibAL;
procedure alDisable(Capability: TALEnum); cdecl; external LibAL;
function alIsEnabled(Capability: TALEnum): TALBoolean; cdecl; external LibAL;
procedure alHint(Target, Mode: TALEnum); cdecl; external LibAL;
function alGetBoolean(Param: TALEnum): TALBoolean; cdecl; external LibAL;
function alGetInteger(Param: TALEnum): TALInt; cdecl; external LibAL;
function alGetFloat(Param: TALEnum): TALFloat; cdecl; external LibAL;
function alGetDouble(Param: TALEnum): TALDouble; cdecl; external LibAL;
procedure alGetBooleanv(Param: TALEnum; Data: PALBoolean); cdecl; external LibAL;
procedure alGetIntegerv(Param: TALEnum; Data: PALInt); cdecl; external LibAL;
procedure alGetFloatv(Param: TALEnum; Data: PALFloat); cdecl; external LibAL;
procedure alGetDoublev(Param: TALEnum; Data: PALDouble); cdecl; external LibAL;
function alGetString(Param: TALEnum): PALUByte; cdecl; external LibAL;
function alGetError: TALEnum; cdecl; external LibAL;
function alIsExtensionPresent(FName: PAnsiChar): TALBoolean; cdecl; external LibAL;
function alGetProcAddress(FName: PALUByte): Pointer; cdecl; external LibAL;
function alGetEnumValue(EName: PALUByte): TALEnum; cdecl; external LibAL;
procedure alListeneri(Param: TAlEnum; Value: TALInt); cdecl; external LibAL;
procedure alListenerf(Param: TALEnum; Value: TALFloat); cdecl; external LibAL;
procedure alListener3f(Param: TALEnum; f1: TALFloat; f2: TALFloat; f3: TALFloat); cdecl; external LibAL;
procedure alListenerfv(Param: TALEnum; Values: PALFloat); cdecl; external LibAL;
procedure alGetListeneriv(Param: TALEnum; Values: PALInt); cdecl; external LibAL;
procedure alGetListenerfv(Param: TALEnum; Values: PALFloat); cdecl; external LibAL;
procedure alGenSources(n: TALSizei; Sources: PALUInt); cdecl; external LibAL;
procedure alDeleteSources(n: TALSizei; Sources: PALUInt); cdecl; external LibAL;
function alIsSource(id: TALUInt): TALBoolean; cdecl; external LibAL;
procedure alSourcei(Source: TALUInt; Param: TALEnum; Value: TALInt); cdecl; external LibAL;
procedure alSourcef(Source: TALUInt; Param: TALEnum; Value: TALFloat); cdecl; external LibAL;
procedure alSource3f(Source: TALUInt; Param: TALEnum; v1: TALFloat; v2: TALFloat; v3: TALFloat); cdecl; external LibAL;
procedure alSourcefv(Source: TALUInt; Param: TALEnum; Values: PALFloat); cdecl; external LibAL;
procedure alGetSourcei(Source: TALUInt; Param: TALEnum; Value: PALInt); cdecl; external LibAL;
procedure alGetSourcef(Source: TALUInt; Param: TALEnum; Value: PALFloat); cdecl; external LibAL;
procedure alGetSource3f(Source: TALUInt; Param: TALEnum; v1: PALFloat; v2: PALFloat; v3: PALFloat); cdecl; external LibAL;
procedure alGetSourcefv(Source: TALUInt; Param: TALEnum; Values: PALFloat); cdecl; external LibAL;
procedure alSourcePlayv(n: TALSizei; Sources: PALUInt); cdecl; external LibAL;
procedure alSourceStopv(n: TALSizei; Sources: PALUInt); cdecl; external LibAL;
procedure alSourceRewindv(n: TALSizei; Sources: PALUInt); cdecl; external LibAL;
procedure alSourcePausev(n: TALSizei; Sources: PALUInt); cdecl; external LibAL;
procedure alSourcePlay(Source: TALUInt); cdecl; external LibAL;
procedure alSourcePause(Source: TALUInt); cdecl; external LibAL;
procedure alSourceStop(Source: TALUInt); cdecl; external LibAL;
procedure alSourceRewind(Source: TALUInt); cdecl; external LibAL;
procedure alGenBuffers(n: TALSizei; Buffers: PALUInt); cdecl; external LibAL;
procedure alDeleteBuffers(n: TALSizei; Buffers: PALUInt); cdecl; external LibAL;
function alIsBuffer(Buffer: TALUInt): TALBoolean; cdecl; external LibAL;
procedure alBufferData(Buffer: TALUInt; Format: TALEnum; Data: Pointer; Size, Freq: TALSizei); cdecl; external LibAL;
procedure alGetBufferi(Buffer: TALUInt; Param: TALEnum; Value: PALInt); cdecl; external LibAL;
procedure alGetBufferf(Buffer: TALUInt; Param: TALEnum; Value: PALFloat); cdecl; external LibAL;
function alGenEnvironmentIASIG(n: TALSizei; Environs: PALUInt): TALsizei; cdecl; external LibAL;
procedure alDeleteEnvironmentIASIG(n: TALSizei; Environs: PALUInt); cdecl; external LibAL;
function alIsEnvironmentIASIG(Environ: TALUInt): TALBoolean; cdecl; external LibAL;
procedure alEnvironmentiIASIG(eid: TALUint; Param: TALEnum; Value: TALInt); cdecl; external LibAL;
procedure alEnvironmentfIASIG(eid: TALUint; Param: TALEnum; Value: TALFloat); cdecl; external LibAL;
procedure alSourceQueueBuffers(Source: TALUint; n: TALSizei; Buffers: PALUInt); cdecl; external LibAL;
procedure alSourceUnqueueBuffers(Source: TALUInt; n: TALSizei; Buffers: PALUInt); cdecl; external LibAL;
procedure alQueuei(Source: TALUint; n: TALSizei; Buffers: PALUInt); cdecl; external LibAL;
procedure alDistanceModel(Value: TALEnum); cdecl; external LibAL;
procedure alDopplerFactor(Value: TALFloat); cdecl; external LibAL;
procedure alDopplerVelocity(Value: TALFloat); cdecl; external LibAL;

function alcGetString(Device: TALCDevice; Param: TALCenum): PALCUByte; cdecl; external LibAL;
procedure alcGetIntegerv(Device: TALCDevice; Param: TALCenum; Size: TALCSizei; Data: PALCint); cdecl; external LibAL;
function alcOpenDevice(DeviceName: PALCUByte): TALCdevice; cdecl; external LibAL;
procedure alcCloseDevice(Device: TALCDevice); cdecl; external LibAL;
function alcCreateContext(Device: TALCDevice; AttrList: PALCInt): TALCContext; cdecl; external LibAL;
function alcMakeContextCurrent(Context: TALCContext): TALCEnum; cdecl; external LibAL;
procedure alcProcessContext(Context: TALCContext); cdecl; external LibAL;
function alcGetCurrentContext: TALCContext; cdecl; external LibAL;
function alcGetContextsDevice(Context: TALCContext): TALCDevice; cdecl; external LibAL;
procedure alcSuspendContext(Context: TALCContext); cdecl; external LibAL;
procedure alcDestroyContext(Context: TALCContext); cdecl; external LibAL;
function alcGetError(Device: TALCDevice): TALCEnum; cdecl; external LibAL;
function alcIsExtensionPresent(Device: TALCDevice; ExtName: PALCUByte): TALCBoolean; cdecl; external LibAL;
function alcGetProcAddress(Device: TALCDevice; FuncName: PALCUByte): TALCVoid; cdecl; external LibAL;
function alcGetEnumValue(Device: TALCDevice; EnumName: PALCUByte): TALCEnum; cdecl; external LibAL;

implementation

end.
