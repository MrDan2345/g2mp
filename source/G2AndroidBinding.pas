unit G2AndroidBinding;
{$include Gen2MP.inc}
interface

uses
  G2Types,
  G2AndroidJNI,
  G2AndroidLog,
  SysUtils;

type

  { TG2AndroidBinding }

  TG2AndroidBinding = object
  private
    _Env: PJNIEnv;
    _Mgr: JObject;
    _MgrClass: JClass;
    _MIDAppClose: JMethodID;
    _MIDFOpenInput: JMethodID;
    _MIDFOpenOutput: JMethodID;
    _MIDFClose: JMethodID;
    _MIDFSetPos: JMethodID;
    _MIDFWrite: JMethodID;
    _MIDFRead: JMethodID;
    _MIDFExists: JMethodID;
    _MIDFAOpen: JMethodID;
    _MIDFAClose: JMethodID;
    _MIDFASetPos: JMethodID;
    _MIDFARead: JMethodID;
    _MIDFontMake: JMethodID;
    _MIDFontGetW: JMethodID;
    _MIDFontGetH: JMethodID;
    _MIDFontGetD: JMethodID;
  public
    procedure Init(const Env: PJNIEnv; const Mgr: JObject);
    procedure AppClose;
    function FOpenInput(const FileName: String; const Len: Integer): Integer;
    procedure FOpenOutput(const FileName: String; const Len: Integer);
    procedure FClose;
    procedure FSetPos(const Pos: TG2IntS64);
    procedure FWrite(const Buffer: Pointer; const Count: Integer);
    function FRead(const Buffer: Pointer; const Count: Integer): Integer;
    function FExists(const FileName: String; const Len: Integer): Boolean;
    function FAOpen(const FileName: String; const Len: Integer): Integer;
    procedure FAClose;
    procedure FASetPos(const Pos: TG2IntS64);
    function FARead(const Buffer: Pointer; const Count: Integer): Integer;
    procedure FontMake(var Buffer: Pointer; var tw, th: Integer; const Size: Integer; const chw, chh: PInteger);
    procedure ResetTitle;
  end;

var AndroidBinding: TG2AndroidBinding;

implementation

uses
  G2Image,
  G2ImagePNG,
  G2Audio,
  G2AudioWAV;

procedure TG2AndroidBinding.Init(const Env: PJNIEnv; const Mgr: JObject);
begin
  _Env := Env;
  _Mgr := Mgr;
  _MgrClass := (_Env^)^.GetObjectClass(_Env, _Mgr);
  _MIDAppClose := (_Env^)^.GetMethodID(_Env, _MgrClass, 'appclose', '()V');
  _MIDFOpenInput := (_Env^)^.GetMethodID(_Env, _MgrClass, 'fopeninput', '(Ljava/lang/String;)I');
  _MIDFOpenOutput := (_Env^)^.GetMethodID(_Env, _MgrClass, 'fopenoutput', '(Ljava/lang/String;)V');
  _MIDFClose := (_Env^)^.GetMethodID(_Env, _MgrClass, 'fclose', '()V');
  _MIDFSetPos := (_Env^)^.GetMethodID(_Env, _MgrClass, 'fsetpos', '(I)V');
  _MIDFRead := (_Env^)^.GetMethodID(_Env, _MgrClass, 'fread', '([BII)I');
  _MIDFWrite := (_Env^)^.GetMethodID(_Env, _MgrClass, 'fwrite', '([BII)V');
  _MIDFExists := (_Env^)^.GetMethodID(_Env, _MgrClass, 'fexists', '(Ljava/lang/String;)Z');
  _MIDFAOpen := (_Env^)^.GetMethodID(_Env, _MgrClass, 'faopen', '(Ljava/lang/String;)I');
  _MIDFAClose := (_Env^)^.GetMethodID(_Env, _MgrClass, 'faclose', '()V');
  _MIDFASetPos := (_Env^)^.GetMethodID(_Env, _MgrClass, 'fasetpos', '(I)V');
  _MIDFARead := (_Env^)^.GetMethodID(_Env, _MgrClass, 'faread', '([BII)I');
  _MIDFontMake := (_Env^)^.GetMethodID(_Env, _MgrClass, 'fontmake', '(I[I[I)V');
  _MIDFontGetW := (_Env^)^.GetMethodID(_Env, _MgrClass, 'fontgetw', '()I');
  _MIDFontGetH := (_Env^)^.GetMethodID(_Env, _MgrClass, 'fontgeth', '()I');
  _MIDFontGetD := (_Env^)^.GetMethodID(_Env, _MgrClass, 'fontgetd', '([I)I');
  //G2AddImageFormat(TG2ImagePNG);
  //G2AddAudioFormat(TG2AudioWAV);
end;

procedure TG2AndroidBinding.AppClose;
begin
  (_Env^)^.CallVoidMethod(_Env, _Mgr, _MIDAppClose);
end;

function TG2AndroidBinding.FOpenInput(const FileName: String; const Len: Integer): Integer;
  var JStr: JString;
  var Ptr: Pointer;
  var i: Integer;
begin
  GetMem(Ptr, Len * 2);
  for i := 0 to Len - 1 do
  begin
    PByteArray(Ptr)^[i * 2] := Byte(FileName[i + 1]);
    PByteArray(Ptr)^[i * 2 + 1] := 0;
  end;
  JStr := (_Env^)^.NewString(_Env, PJChar(@FileName[1]), Len);
  Result := (_Env^)^.CallIntMethodV(_Env, _Mgr, _MIDFOpenInput, va_list(@JStr));
  (_Env^)^.DeleteLocalRef(_Env, JStr);
  FreeMem(Ptr, Len * 2);
end;

procedure TG2AndroidBinding.FOpenOutput(const FileName: String; const Len: Integer);
  var JStr: JString;
  var Ptr: Pointer;
  var i: Integer;
begin
  GetMem(Ptr, Len * 2);
  for i := 0 to Len - 1 do
  begin
    PByteArray(Ptr)^[i * 2] := Byte(FileName[i + 1]);
    PByteArray(Ptr)^[i * 2 + 1] := 0;
  end;
  JStr := (_Env^)^.NewString(_Env, PJChar(@FileName[1]), Len);
  (_Env^)^.CallVoidMethodV(_Env, _Mgr, _MIDFOpenOutput, va_list(@JStr));
  (_Env^)^.DeleteLocalRef(_Env, JStr);
  FreeMem(Ptr, Len * 2);
end;

procedure TG2AndroidBinding.FClose;
begin
  (_Env^)^.CallVoidMethod(_Env, _Mgr, _MIDFClose);
end;

procedure TG2AndroidBinding.FSetPos(const Pos: TG2IntS64);
  var PosInt: Integer;
begin
  PosInt := Pos;
  (_Env^)^.CallVoidMethodV(_Env, _Mgr, _MIDFSetPos, va_list(@PosInt));
end;

procedure TG2AndroidBinding.FWrite(const Buffer: Pointer; const Count: Integer);
  var ArgArr: packed record
    Buffer: jbyteArray;
    Offset: JInt;
    Len: JInt;
  end;
  var IsCopy: JBoolean;
  var Data: PJByte;
begin
  ArgArr.Offset := 0;
  ArgArr.Len := Count;
  ArgArr.Buffer := (_Env^)^.NewByteArray(_Env, ArgArr.Len);
  (_Env^)^.NewGlobalRef(_Env, ArgArr.Buffer);
  IsCopy := 0;
  Data := (_Env^)^.GetByteArrayElements(_Env, ArgArr.Buffer, IsCopy);
  Move(Buffer^, Data^, Count);
  (_Env^)^.CallVoidMethodV(_Env, _Mgr, _MIDFWrite, va_list(@ArgArr));
  (_Env^)^.ReleaseByteArrayElements(_Env, ArgArr.Buffer, Data, 0);
  (_Env^)^.DeleteGlobalRef(_Env, ArgArr.Buffer);
end;

function TG2AndroidBinding.FRead(const Buffer: Pointer; const Count: Integer): Integer;
  var ArgArr: packed record
    Buffer: jbyteArray;
    Offset: JInt;
    Len: JInt;
  end;
  var IsCopy: JBoolean;
  var Data: PJByte;
begin
  ArgArr.Offset := 0;
  ArgArr.Len := Count;
  ArgArr.Buffer := (_Env^)^.NewByteArray(_Env, ArgArr.Len);
  (_Env^)^.NewGlobalRef(_Env, ArgArr.Buffer);
  Result := (_Env^)^.CallIntMethodV(_Env, _Mgr, _MIDFRead, va_list(@ArgArr));
  IsCopy := 0;
  Data := (_Env^)^.GetByteArrayElements(_Env, ArgArr.Buffer, IsCopy);
  Move(Data^, Buffer^, Count);
  (_Env^)^.ReleaseByteArrayElements(_Env, ArgArr.Buffer, Data, 0);
  (_Env^)^.DeleteGlobalRef(_Env, ArgArr.Buffer);
end;

function TG2AndroidBinding.FExists(const FileName: String; const Len: Integer): Boolean;
  var JStr: JString;
  var Res: JBoolean;
  var Ptr: Pointer;
  var i: Integer;
begin
  GetMem(Ptr, Len * 2);
  for i := 0 to Len - 1 do
  begin
    PByteArray(Ptr)^[i * 2] := Byte(FileName[i + 1]);
    PByteArray(Ptr)^[i * 2 + 1] := 0;
  end;
  JStr := (_Env^)^.NewString(_Env, PJChar(Ptr), Len);
  Res := (_Env^)^.CallBooleanMethodV(_Env, _Mgr, _MIDFExists, va_list(@JStr));
  Result := Res > 0;
  (_Env^)^.DeleteLocalRef(_Env, JStr);
  FreeMem(Ptr, Len * 2);
end;

function TG2AndroidBinding.FAOpen(const FileName: String; const Len: Integer): Integer;
  var JStr: JString;
  var Ptr: Pointer;
  var i: Integer;
  var fs: AnsiString;
begin
  SetLength(fs, Length(FileName) + 1);
  Move(FileName[1], fs[1], Length(FileName));
  fs[Length(fs)] := #0;
  //G2AndroidJNI.NewStringUTF(PAnsiChar(FileName));
  //GetMem(Ptr, Length(FileName) * 2);
  //for i := 0 to Length(FileName) - 1 do
  //begin
  //  PByteArray(Ptr)^[i * 2] := Byte(FileName[i + 1]);
  //  PByteArray(Ptr)^[i * 2 + 1] := 0;
  //end;
  //JStr := (_Env^)^.NewString(_Env, PJChar(@FileName[1]), Length(FileName));
  JStr := (_Env^)^.NewStringUTF(_Env, PAnsiChar(@fs[1]));
  Result := (_Env^)^.CallIntMethodV(_Env, _Mgr, _MIDFAOpen, va_list(@JStr));
  (_Env^)^.DeleteLocalRef(_Env, JStr);
  //FreeMem(Ptr, Length(FileName) * 2);
end;

procedure TG2AndroidBinding.FAClose();
begin
  (_Env^)^.CallVoidMethod(_Env, _Mgr, _MIDFAClose);
end;

procedure TG2AndroidBinding.FASetPos(const Pos: TG2IntS64);
  var PosInt: Integer;
begin
  PosInt := Pos;
  (_Env^)^.CallVoidMethodV(_Env, _Mgr, _MIDFASetPos, va_list(@PosInt));
end;

function TG2AndroidBinding.FARead(const Buffer: Pointer; const Count: Integer): Integer;
  var ArgArr: packed record
    Buffer: jbyteArray;
    Offset: JInt;
    Len: JInt;
  end;
  var IsCopy: JBoolean;
  var Data: PJByte;
begin
  ArgArr.Offset := 0;
  ArgArr.Len := Count;
  ArgArr.Buffer := (_Env^)^.NewByteArray(_Env, ArgArr.Len);
  (_Env^)^.NewLocalRef(_Env, ArgArr.Buffer);
  Result := (_Env^)^.CallIntMethodV(_Env, _Mgr, _MIDFARead, va_list(@ArgArr));
  IsCopy := 0;
  Data := (_Env^)^.GetByteArrayElements(_Env, ArgArr.Buffer, IsCopy);
  Move(Data^, Buffer^, Count);
  (_Env^)^.ReleaseByteArrayElements(_Env, ArgArr.Buffer, Data, 0);
  (_Env^)^.DeleteLocalRef(_Env, ArgArr.Buffer);
end;

procedure TG2AndroidBinding.FontMake(var Buffer: Pointer; var tw, th: Integer; const Size: Integer; const chw, chh: PInteger);
  var ArgArr: packed record
    Size: JInt;
    CharWidths: JIntArray;
    CharHeights: JIntArray;
  end;
  var TexBuffer: JIntArray;
  var TexWidth: JInt;
  var TexHeight: JInt;
  var IsCopy: JBoolean;
  var Data: PJInt;
begin
  ArgArr.Size := Size;
  ArgArr.CharWidths := (_Env^)^.NewIntArray(_Env, 256);
  (_Env^)^.NewLocalRef(_Env, ArgArr.CharWidths);
  ArgArr.CharHeights := (_Env^)^.NewIntArray(_Env, 256);
  (_Env^)^.NewLocalRef(_Env, ArgArr.CharHeights);
  (_Env^)^.CallVoidMethodV(_Env, _Mgr, _MIDFontMake, va_list(@ArgArr));
  IsCopy := 0;
  Data := (_Env^)^.GetIntArrayElements(_Env, ArgArr.CharWidths, IsCopy);
  Move(Data^, chw^, 1024);
  (_Env^)^.ReleaseIntArrayElements(_Env, ArgArr.CharWidths, Data, 0);
  (_Env^)^.DeleteLocalRef(_Env, ArgArr.CharWidths);
  IsCopy := 0;
  Data := (_Env^)^.GetIntArrayElements(_Env, ArgArr.CharHeights, IsCopy);
  Move(Data^, chh^, 1024);
  (_Env^)^.ReleaseIntArrayElements(_Env, ArgArr.CharHeights, Data, 0);
  (_Env^)^.DeleteLocalRef(_Env, ArgArr.CharHeights);
  TexWidth := (_Env^)^.CallIntMethod(_Env, _Mgr, _MIDFontGetW);
  TexHeight := (_Env^)^.CallIntMethod(_Env, _Mgr, _MIDFontGetH);
  tw := TexWidth; th := TexHeight;
  TexBuffer := (_Env^)^.NewIntArray(_Env, tw * th);
  (_Env^)^.NewLocalRef(_Env, TexBuffer);
  (_Env^)^.CallIntMethodV(_Env, _Mgr, _MIDFontGetD, va_list(@TexBuffer));
  Buffer := GetMem(tw * th * 4);
  IsCopy := 0;
  Data := (_Env^)^.GetIntArrayElements(_Env, TexBuffer, IsCopy);
  Move(Data^, Buffer^, tw * th * 4);
  (_Env^)^.ReleaseIntArrayElements(_Env, TexBuffer, Data, 0);
  (_Env^)^.DeleteLocalRef(_Env, TexBuffer);
end;

procedure TG2AndroidBinding.ResetTitle;
  var m: JMethodID;
begin
  m := (_Env^)^.GetMethodID(_Env, _MgrClass, 'resettitle', '()V');
  (_Env^)^.CallVoidMethod(_Env, _Mgr, m);
end;

end.
