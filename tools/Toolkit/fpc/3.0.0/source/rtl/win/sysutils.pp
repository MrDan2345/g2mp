{

    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by Florian Klaempfl
    member of the Free Pascal development team

    Sysutils unit for win32

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit sysutils;
interface

{$MODE objfpc}
{$MODESWITCH OUT}
{ force ansistrings }
{$H+}

uses
  windows;

{$DEFINE HAS_SLEEP}
{$DEFINE HAS_OSERROR}
{$DEFINE HAS_OSCONFIG}
{$DEFINE HAS_OSUSERDIR}
{$DEFINE HAS_CREATEGUID}
{$DEFINE HAS_LOCALTIMEZONEOFFSET}
{$DEFINE HAS_GETTICKCOUNT}
{$DEFINE HAS_GETTICKCOUNT64}
{$DEFINE OS_FILESETDATEBYNAME}

{ used OS file system APIs use unicodestring }
{$define SYSUTILS_HAS_UNICODESTR_FILEUTIL_IMPL}
{ OS has an ansistring/single byte environment variable API }
{$define SYSUTILS_HAS_ANSISTR_ENVVAR_IMPL}
{ OS has a unicodestring/two byte environment variable API }
{$define SYSUTILS_HAS_UNICODESTR_ENVVAR_IMPL}

{ Include platform independent interface part }
{$i sysutilh.inc}

type
  TSystemTime = Windows.TSystemTime;

  EWin32Error = class(Exception)
  public
    ErrorCode : DWORD;
  end;


Var
  Win32Platform : Longint;
  Win32MajorVersion,
  Win32MinorVersion,
  Win32BuildNumber   : dword;
  Win32CSDVersion    : ShortString;   // CSD record is 128 bytes only?

const
  MaxEraCount = 7;

var
  EraNames: array [1..MaxEraCount] of String;
  EraYearOffsets: array [1..MaxEraCount] of Integer;

{ Compatibility with Delphi }
function Win32Check(res:boolean):boolean;inline;
function WinCheck(res:boolean):boolean;
function CheckWin32Version(Major,Minor : Integer ): Boolean;
function CheckWin32Version(Major : Integer): Boolean;
Procedure RaiseLastWin32Error;

function GetFileVersion(const AFileName: string): Cardinal;

procedure GetFormatSettings;
procedure GetLocaleFormatSettings(LCID: Integer; var FormatSettings: TFormatSettings); platform;

implementation

  uses
    sysconst,
    windirs;

function WinCheck(res:boolean):boolean;
  begin
    if not res then
      RaiseLastOSError;
    result:=res;
  end;


function Win32Check(res:boolean):boolean;inline;
  begin
    result:=WinCheck(res);
  end;


procedure RaiseLastWin32Error;
  begin
    RaiseLastOSError;
  end;


function CheckWin32Version(Major : Integer): Boolean;
  begin
    Result:=CheckWin32Version(Major,0)
  end;


function CheckWin32Version(Major,Minor: Integer): Boolean;
  begin
    Result:=(Win32MajorVersion>dword(Major)) or
            ((Win32MajorVersion=dword(Major)) and (Win32MinorVersion>=dword(Minor)));
  end;


function GetFileVersion(const AFileName:string):Cardinal;
  var
    { useful only as long as we don't need to touch different stack pages }
    buf : array[0..3071] of byte;
    bufp : pointer;
    fn : string;
    valsize,
    size : DWORD;
    h : DWORD;
    valrec : PVSFixedFileInfo;
  begin
    result:=$fffffff;
    fn:=AFileName;
    UniqueString(fn);
    size:=GetFileVersionInfoSizeA(pchar(fn),@h);
    if size>sizeof(buf) then
      begin
        getmem(bufp,size);
        try
          if GetFileVersionInfoA(pchar(fn),h,size,bufp) then
            if VerQueryValue(bufp,'\',valrec,valsize) then
              result:=valrec^.dwFileVersionMS;
        finally
          freemem(bufp);
        end;
      end
    else
      begin
        if GetFileVersionInfoA(pchar(fn),h,size,@buf) then
          if VerQueryValue(@buf,'\',valrec,valsize) then
            result:=valrec^.dwFileVersionMS;
      end;
  end;


{$define HASCREATEGUID}
{$define HASEXPANDUNCFILENAME}

{$DEFINE FPC_NOGENERICANSIROUTINES}

{$DEFINE FPC_FEXPAND_UNC} (* UNC paths are supported *)
{$DEFINE FPC_FEXPAND_DRIVES} (* Full paths begin with drive specification *)

function ConvertEraYearString(Count ,Year,Month,Day : integer) : string; forward;
function ConvertEraString(Count ,Year,Month,Day : integer) : string; forward;
{ Include platform independent implementation part }
{$i sysutils.inc}

function GetTempFileName(Dir,Prefix: PChar; uUnique: DWORD; TempFileName: PChar):DWORD;

begin
  Result:= Windows.GetTempFileNameA(Dir,Prefix,uUnique,TempFileName);
end;


{ UUID generation. }

function CoCreateGuid(out guid: TGUID): HResult; stdcall; external 'ole32.dll' name 'CoCreateGuid';

function SysCreateGUID(out Guid: TGUID): Integer;
begin
  Result := Integer(CoCreateGuid(Guid));
end;


function ExpandUNCFileName (const filename:rawbytestring) : rawbytestring;
{ returns empty string on errors }
var
  u: unicodestring;
begin
  { prevent data loss due to unsupported characters in ansi code page }
  u:=ExpandUNCFileName(unicodestring(filename));
  widestringmanager.Unicode2AnsiMoveProc(punicodechar(u),result,DefaultRTLFileSystemCodePage,length(u));
end;


function ExpandUNCFileName (const filename:unicodestring) : unicodestring;
{ returns empty string on errors }
var
  s    : unicodestring;
  size : dword;
  rc   : dword;
  buf : pwidechar;
begin
  s := ExpandFileName (filename);

  s := s + #0;

  size := max_path;
  getmem(buf,size);

  try
    rc := WNetGetUniversalNameW (pwidechar(s), UNIVERSAL_NAME_INFO_LEVEL, buf, @size);

    if rc=ERROR_MORE_DATA then
      begin
        buf:=reallocmem(buf,size);
        rc := WNetGetUniversalNameW (pwidechar(s), UNIVERSAL_NAME_INFO_LEVEL, buf, @size);
      end;
    if rc = NO_ERROR then
      Result := PRemoteNameInfo(buf)^.lpUniversalName
    else if rc = ERROR_NOT_CONNECTED then
      Result := filename
    else
      Result := '';
  finally
    freemem(buf);
  end;
end;


{****************************************************************************
                              File Functions
****************************************************************************}

const
  AccessMode: array[0..2] of Cardinal  = (
    GENERIC_READ,
    GENERIC_WRITE,
    GENERIC_READ or GENERIC_WRITE or FILE_WRITE_ATTRIBUTES);
  ShareModes: array[0..4] of Integer = (
               0,
               0,
               FILE_SHARE_READ,
               FILE_SHARE_WRITE,
               FILE_SHARE_READ or FILE_SHARE_WRITE);


Function FileOpen (Const FileName : unicodestring; Mode : Integer) : THandle;
begin
  result := CreateFileW(PWideChar(FileName), dword(AccessMode[Mode and 3]),
                       dword(ShareModes[(Mode and $F0) shr 4]), nil, OPEN_EXISTING,
                       FILE_ATTRIBUTE_NORMAL, 0);
  //if fail api return feInvalidHandle (INVALIDE_HANDLE=feInvalidHandle=-1)
end;

Function FileCreate (Const FileName : UnicodeString) : THandle;
begin
  FileCreate:=FileCreate(FileName, fmShareExclusive, 0);
end;

Function FileCreate (Const FileName : UnicodeString; Rights:longint) : THandle;
begin
  FileCreate:=FileCreate(FileName, fmShareExclusive, Rights);
end;

Function FileCreate (Const FileName : UnicodeString; ShareMode : Integer; Rights : Integer) : THandle;
begin
  Result := CreateFileW(PwideChar(FileName), GENERIC_READ or GENERIC_WRITE,
                       dword(ShareModes[(ShareMode and $F0) shr 4]), nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
end;

Function FileRead (Handle : THandle; out Buffer; Count : longint) : Longint;
Var
  res : dword;
begin
  if ReadFile(Handle, Buffer, Count, res, nil) then
   FileRead:=Res
  else
   FileRead:=-1;
end;


Function FileWrite (Handle : THandle; const Buffer; Count : Longint) : Longint;
Var
  Res : dword;
begin
  if WriteFile(Handle, Buffer, Count, Res, nil) then
   FileWrite:=Res
  else
   FileWrite:=-1;
end;


Function FileSeek (Handle : THandle;FOffset,Origin : Longint) : Longint;
begin
  Result := longint(SetFilePointer(Handle, FOffset, nil, Origin));
end;


Function FileSeek (Handle : THandle; FOffset: Int64; Origin: Longint) : Int64;
var
  rslt: Int64Rec;
begin
  rslt := Int64Rec(FOffset);
  rslt.lo := SetFilePointer(Handle, rslt.lo, @rslt.hi, Origin);
  if (rslt.lo = $FFFFFFFF) and (GetLastError <> 0) then
    rslt.hi := $FFFFFFFF;
  Result := Int64(rslt);
end;


Procedure FileClose (Handle : THandle);
begin
  if Handle<=4 then
   exit;
  CloseHandle(Handle);
end;


Function FileTruncate (Handle : THandle;Size: Int64) : boolean;
begin
{
  Result:=longint(SetFilePointer(handle,Size,nil,FILE_BEGIN))<>-1;
}
  if FileSeek (Handle, Size, FILE_BEGIN) = Size then
   Result:=SetEndOfFile(handle)
  else
   Result := false;
end;

Function DosToWinTime (DTime:longint;Var Wtime : TFileTime):longbool;
var
  lft : TFileTime;
begin
  DosToWinTime:=DosDateTimeToFileTime(longrec(dtime).hi,longrec(dtime).lo,@lft) and
                LocalFileTimeToFileTime(lft,Wtime);
end;


Function WinToDosTime (Var Wtime : TFileTime;var DTime:longint):longbool;
var
  lft : TFileTime;
begin
  WinToDosTime:=FileTimeToLocalFileTime(WTime,lft) and
                FileTimeToDosDateTime(lft,Longrec(Dtime).Hi,LongRec(DTIME).lo);
end;


Function FileAge (Const FileName : UnicodeString): Longint;
var
  Handle: THandle;
  FindData: TWin32FindDataW;
begin
  Handle := FindFirstFileW(Pwidechar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
    begin
      Windows.FindClose(Handle);
      if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
        If WinToDosTime(FindData.ftLastWriteTime,Result) then
          exit;
    end;
  Result := -1;
end;


Function FileExists (Const FileName : UnicodeString) : Boolean;
var
  Attr:Dword;
begin

  Attr:=GetFileAttributesW(PWideChar(FileName));
  if Attr <> $ffffffff then
    Result:= (Attr and FILE_ATTRIBUTE_DIRECTORY) = 0
  else
    Result:=False;
end;


Function DirectoryExists (Const Directory : UnicodeString) : Boolean;
var
  Attr:Dword;
begin
  Attr:=GetFileAttributesW(PWideChar(Directory));
  if Attr <> $ffffffff then
    Result:= (Attr and FILE_ATTRIBUTE_DIRECTORY) > 0
  else
    Result:=False;
end;

Function FindMatch(var f: TAbstractSearchRec; var Name: UnicodeString) : Longint;
begin
  { Find file with correct attribute }
  While (F.FindData.dwFileAttributes and cardinal(F.ExcludeAttr))<>0 do
   begin
     if not FindNextFileW (F.FindHandle,F.FindData) then
      begin
        Result:=GetLastError;
        exit;
      end;
   end;
  { Convert some attributes back }
  WinToDosTime(F.FindData.ftLastWriteTime,F.Time);
  f.size:=F.FindData.NFileSizeLow+(qword(maxdword)+1)*F.FindData.NFileSizeHigh;
  f.attr:=F.FindData.dwFileAttributes;
  Name:=F.FindData.cFileName;
  Result:=0;
end;


Function InternalFindFirst (Const Path : UnicodeString; Attr : Longint; out Rslt : TAbstractSearchRec; var Name : UnicodeString) : Longint;
begin
  Name:=Path;
  Rslt.Attr:=attr;
  Rslt.ExcludeAttr:=(not Attr) and ($1e);
                 { $1e = faHidden or faSysFile or faVolumeID or faDirectory }
  { FindFirstFile is a Win32 Call }
  Rslt.FindHandle:=FindFirstFileW (PWideChar(Path),Rslt.FindData);
  If Rslt.FindHandle=Invalid_Handle_value then
   begin
     Result:=GetLastError;
     exit;
   end;
  { Find file with correct attribute }
  Result:=FindMatch(Rslt,Name);
end;

Function InternalFindNext (Var Rslt : TAbstractSearchRec; var Name: UnicodeString) : Longint;
begin
  if FindNextFileW(Rslt.FindHandle, Rslt.FindData) then
    Result := FindMatch(Rslt, Name)
  else
    Result := GetLastError;
end;


Procedure InternalFindClose (var Handle: THandle; var FindData: TFindData);
begin
   if Handle <> INVALID_HANDLE_VALUE then
    Windows.FindClose(Handle);
end;


Function FileGetDate (Handle : THandle) : Longint;
Var
  FT : TFileTime;
begin
  If GetFileTime(Handle,nil,nil,@ft) and
     WinToDosTime(FT,Result) then
    exit;
  Result:=-1;
end;

Function FileSetDate (Handle : THandle;Age : Longint) : Longint;
Var
  FT: TFileTime;
begin
  Result := 0;
  if DosToWinTime(Age,FT) and
    SetFileTime(Handle, nil, nil, @FT) then
    Exit;
  Result := GetLastError;
end;

{$IFDEF OS_FILESETDATEBYNAME}
Function FileSetDate (Const FileName : UnicodeString;Age : Longint) : Longint;
Var
  fd : THandle;
begin
  FD := CreateFileW (PWideChar (FileName), GENERIC_READ or GENERIC_WRITE,
                     FILE_SHARE_WRITE, nil, OPEN_EXISTING,
                     FILE_FLAG_BACKUP_SEMANTICS, 0);  
  If (Fd<>feInvalidHandle) then
    try
      Result:=FileSetDate(fd,Age);
    finally
      FileClose(fd);
    end
  else
    Result:=GetLastOSError;
end;
{$ENDIF}                                                                                

Function FileGetAttr (Const FileName : UnicodeString) : Longint;
begin
  Result:=Longint(GetFileAttributesW(PWideChar(FileName)));
end;


Function FileSetAttr (Const Filename : UnicodeString; Attr: longint) : Longint;
begin
  if SetFileAttributesW(PWideChar(FileName), Attr) then
    Result:=0
  else
    Result := GetLastError;
end;


Function DeleteFile (Const FileName : UnicodeString) : Boolean;
begin
  Result:=Windows.DeleteFileW(PWidechar(FileName));
end;


Function RenameFile (Const OldName, NewName : UnicodeString) : Boolean;
begin
  Result := MoveFileW(PWideChar(OldName), PWideChar(NewName));
end;


{****************************************************************************
                              Disk Functions
****************************************************************************}

type
   TGetDiskFreeSpaceEx = function(drive:pchar;var availableforcaller,total,free):longbool;stdcall;

var
 GetDiskFreeSpaceEx : TGetDiskFreeSpaceEx;

function diskfree(drive : byte) : int64;
var
  disk : array[1..4] of char;
  secs,bytes,
  free,total : dword;
  qwtotal,qwfree,qwcaller : int64;
begin
  if drive=0 then
   begin
     disk[1]:='\';
     disk[2]:=#0;
   end
  else
   begin
     disk[1]:=chr(drive+64);
     disk[2]:=':';
     disk[3]:='\';
     disk[4]:=#0;
   end;
  if assigned(GetDiskFreeSpaceEx) then
    begin
       if GetDiskFreeSpaceEx(@disk[1],qwcaller,qwtotal,qwfree) then
         diskfree:=qwfree
       else
         diskfree:=-1;
    end
  else
    begin
       if GetDiskFreeSpace(@disk[1],secs,bytes,free,total) then
         diskfree:=int64(free)*secs*bytes
       else
         diskfree:=-1;
    end;
end;


function disksize(drive : byte) : int64;
var
  disk : array[1..4] of char;
  secs,bytes,
  free,total : dword;
  qwtotal,qwfree,qwcaller : int64;
begin
  if drive=0 then
   begin
     disk[1]:='\';
     disk[2]:=#0;
   end
  else
   begin
     disk[1]:=chr(drive+64);
     disk[2]:=':';
     disk[3]:='\';
     disk[4]:=#0;
   end;
  if assigned(GetDiskFreeSpaceEx) then
    begin
       if GetDiskFreeSpaceEx(@disk[1],qwcaller,qwtotal,qwfree) then
         disksize:=qwtotal
       else
         disksize:=-1;
    end
  else
    begin
       if GetDiskFreeSpace(@disk[1],secs,bytes,free,total) then
         disksize:=int64(total)*secs*bytes
       else
         disksize:=-1;
    end;
end;


{****************************************************************************
                              Time Functions
****************************************************************************}


Procedure GetLocalTime(var SystemTime: TSystemTime);
begin
  windows.Getlocaltime(SystemTime);
end;

function GetLocalTimeOffset: Integer;

var 
  TZInfo: TTimeZoneInformation;

begin
   case GetTimeZoneInformation(TZInfo) of
     TIME_ZONE_ID_UNKNOWN:
       Result := TZInfo.Bias;
     TIME_ZONE_ID_STANDARD:
       Result := TZInfo.Bias + TZInfo.StandardBias;
     TIME_ZONE_ID_DAYLIGHT:
       Result := TZInfo.Bias + TZInfo.DaylightBias;
     else
       Result := 0;
   end;
end; 


function GetTickCount: LongWord;
begin
  Result := Windows.GetTickCount;
end;


{$IFNDEF WINCE}
type
  TGetTickCount64 = function : QWord; stdcall;

var
  WinGetTickCount64: TGetTickCount64 = Nil;
{$ENDIF}

function GetTickCount64: QWord;
{$IFNDEF WINCE}
var
  lib: THandle;
{$ENDIF}
begin
{$IFNDEF WINCE}
  { on Vista and newer there is a GetTickCount64 implementation }
  if Win32MajorVersion >= 6 then begin
    if not Assigned(WinGetTickCount64) then begin
      lib := LoadLibrary('kernel32.dll');
      WinGetTickCount64 := TGetTickCount64(
                             GetProcAddress(lib, 'GetTickCount64'));
    end;
    Result := WinGetTickCount64();
  end else
{$ENDIF}
    Result := Windows.GetTickCount;
end;
                                                                    

{****************************************************************************
                              Misc Functions
****************************************************************************}

procedure sysbeep;
begin
  MessageBeep(0);
end;


{****************************************************************************
                              Locale Functions
****************************************************************************}

function GetLocaleStr(LID, LT: Longint; const Def: string): ShortString;
var
  L: Integer;
  Buf: array[0..255] of Char;
begin
  L := GetLocaleInfoA(LID, LT, Buf, SizeOf(Buf));
  if L > 0 then
    SetString(Result, @Buf[0], L - 1)
  else
    Result := Def;
end;


function GetLocaleChar(LID, LT: Longint; Def: Char): Char;
var
  Buf: array[0..3] of Char; // sdate allows 4 chars.
begin
  if GetLocaleInfoA(LID, LT, Buf, sizeof(buf)) > 0 then
    Result := Buf[0]
  else
    Result := Def;
end;

function ConvertEraString(Count ,Year,Month,Day : integer) : string;
  var
    ASystemTime: TSystemTime;
    buf: array[0..100] of char;
    ALCID : LCID;
    PriLangID : Word;
    SubLangID : Word;
begin
  Result := ''; if (Count<=0) then exit;
  DateTimeToSystemTime(EncodeDate(Year,Month,Day),ASystemTime);

  ALCID := GetThreadLocale;
//  ALCID := SysLocale.DefaultLCID;
  if GetDateFormatA(ALCID , DATE_USE_ALT_CALENDAR
      , @ASystemTime, PChar('gg')
      , @buf, SizeOf(buf)) > 0 then
  begin
    Result := buf;
    if Count = 1 then
    begin
      PriLangID := ALCID and $3FF;
      SubLangID := (ALCID and $FFFF) shr 10;
      case PriLangID of
        LANG_JAPANESE:
          begin
            Result := Copy(WideString(Result),1,1);
          end;
        LANG_CHINESE:
          if (SubLangID = SUBLANG_CHINESE_TRADITIONAL) then
          begin
            Result := Copy(WideString(Result),1,1);
          end;
      end;
    end;
  end;
// if Result = '' then Result := StringOfChar('G',Count);
end;

function ConvertEraYearString(Count ,Year,Month,Day : integer) : string;
  var
    ALCID : LCID;
    ASystemTime : TSystemTime;
    AFormatText : string;
    buf : array[0..100] of Char;
begin
  Result := '';
  DateTimeToSystemTime(EncodeDate(Year,Month,Day),ASystemTime);

  if Count <= 2 then
    AFormatText := 'yy'
  else
    AFormatText := 'yyyy';

  ALCID := GetThreadLocale;
//  ALCID := SysLocale.DefaultLCID;

  if GetDateFormatA(ALCID, DATE_USE_ALT_CALENDAR
      , @ASystemTime, PChar(AFormatText)
      , @buf, SizeOf(buf)) > 0 then
  begin
    Result := buf;
    if (Count = 1) and (Result[1] = '0') then
      Result := Copy(Result, 2, Length(Result)-1);
  end;
end;


Function GetLocaleInt(LID,TP,Def: LongInt): LongInt;
Var
  S: String;
  C: Integer;
Begin
  S:=GetLocaleStr(LID,TP,'0');
  Val(S,Result,C);
  If C<>0 Then
    Result:=Def;
End;

function EnumEraNames(Names: PChar): WINBOOL; stdcall;
var
  i : integer;
begin
  Result := False;
  for i := Low(EraNames) to High(EraNames) do
   if (EraNames[i] = '') then
   begin
     EraNames[i] := Names;
     Result := True;
     break;
   end;
end;

function EnumEraYearOffsets(YearOffsets: PChar): WINBOOL; stdcall;
var
  i : integer;
begin
  Result := False;
  for i := Low(EraYearOffsets) to High(EraYearOffsets) do
   if (EraYearOffsets[i] = -1) then
   begin
     EraYearOffsets[i] := StrToIntDef(YearOffsets, 0);
     Result := True;
     break;
   end;
end;

procedure GetEraNamesAndYearOffsets;
  var
    ACALID : CALID;
    ALCID : LCID;
    buf : array[0..10] of char;
    i : integer;
begin
  for i:= 1 to MaxEraCount do
   begin
     EraNames[i] := '';  EraYearOffsets[i] := -1;
   end;
  ALCID := GetThreadLocale;
  if GetLocaleInfoA(ALCID , LOCALE_IOPTIONALCALENDAR, buf, sizeof(buf)) <= 0 then exit;
  ACALID := StrToIntDef(buf,1);

  if ACALID in [3..5] then
  begin
    EnumCalendarInfoA(@EnumEraNames, ALCID, ACALID , CAL_SERASTRING);
    EnumCalendarInfoA(@EnumEraYearOffsets, ALCID, ACALID, CAL_IYEAROFFSETRANGE);
  end;
(*
1 CAL_GREGORIAN Gregorian (localized)
2 CAL_GREGORIAN_US Gregorian (English strings always)
3 CAL_JAPAN Japanese Emperor Era
4 CAL_TAIWAN Taiwan Calendar
5 CAL_KOREA Korean Tangun Era
6 CAL_HIJRI Hijri (Arabic Lunar)
7 CAL_THAI Thai
8 CAL_HEBREW Hebrew (Lunar)
9 CAL_GREGORIAN_ME_FRENCH Gregorian Middle East French
10 CAL_GREGORIAN_ARABIC Gregorian Arabic
11 CAL_GREGORIAN_XLIT_ENGLISH Gregorian transliterated English
12 CAL_GREGORIAN_XLIT_FRENCH Gregorian transliterated French
23 CAL_UMALQURA Windows Vista or later: Um Al Qura (Arabic lunar) calendar
*)
end;

procedure GetLocaleFormatSettings(LCID: Integer; var FormatSettings: TFormatSettings);
var
  HF  : Shortstring;
  LID : Windows.LCID;
  I,Day : longint;
begin
  LID := LCID;
  with FormatSettings do
    begin
  { Date stuff }
      for I := 1 to 12 do
        begin
        ShortMonthNames[I]:=GetLocaleStr(LID,LOCALE_SABBREVMONTHNAME1+I-1,ShortMonthNames[i]);
        LongMonthNames[I]:=GetLocaleStr(LID,LOCALE_SMONTHNAME1+I-1,LongMonthNames[i]);
        end;
      for I := 1 to 7 do
        begin
        Day := (I + 5) mod 7;
        ShortDayNames[I]:=GetLocaleStr(LID,LOCALE_SABBREVDAYNAME1+Day,ShortDayNames[i]);
        LongDayNames[I]:=GetLocaleStr(LID,LOCALE_SDAYNAME1+Day,LongDayNames[i]);
        end;
      DateSeparator := GetLocaleChar(LID, LOCALE_SDATE, '/');
      ShortDateFormat := GetLocaleStr(LID, LOCALE_SSHORTDATE, 'm/d/yy');
      LongDateFormat := GetLocaleStr(LID, LOCALE_SLONGDATE, 'mmmm d, yyyy');
      { Time stuff }
      TimeSeparator := GetLocaleChar(LID, LOCALE_STIME, ':');
      TimeAMString := GetLocaleStr(LID, LOCALE_S1159, 'AM');
      TimePMString := GetLocaleStr(LID, LOCALE_S2359, 'PM');
      if StrToIntDef(GetLocaleStr(LID, LOCALE_ITLZERO, '0'), 0) = 0 then
        HF:='h'
      else
        HF:='hh';
      // No support for 12 hour stuff at the moment...
      ShortTimeFormat := HF+':nn';
      LongTimeFormat := HF + ':nn:ss';
      { Currency stuff }
      CurrencyString:=GetLocaleStr(LID, LOCALE_SCURRENCY, '');
      CurrencyFormat:=StrToIntDef(GetLocaleStr(LID, LOCALE_ICURRENCY, '0'), 0);
      NegCurrFormat:=StrToIntDef(GetLocaleStr(LID, LOCALE_INEGCURR, '0'), 0);
      { Number stuff }
      ThousandSeparator:=GetLocaleChar(LID, LOCALE_STHOUSAND, ',');
      DecimalSeparator:=GetLocaleChar(LID, LOCALE_SDECIMAL, '.');
      CurrencyDecimals:=StrToIntDef(GetLocaleStr(LID, LOCALE_ICURRDIGITS, '0'), 0);
      ListSeparator := GetLocaleChar(LID, LOCALE_SLIST, ',');
    end;
end;

procedure GetFormatSettings;
begin
  GetlocaleFormatSettings(GetThreadLocale, DefaultFormatSettings);
end;

Procedure InitInternational;
var
  { A call to GetSystemMetrics changes the value of the 8087 Control Word on
    Pentium4 with WinXP SP2 }
  old8087CW: word;
  DefaultCustomLocaleID : LCID;   // typedef DWORD LCID;
  DefaultCustomLanguageID : Word; // typedef WORD LANGID;
begin
  /// workaround for Windows 7 bug, see bug report #18574
  SetThreadLocale(GetUserDefaultLCID);
  InitInternationalGeneric;
  old8087CW:=Get8087CW;
  SysLocale.MBCS:=GetSystemMetrics(SM_DBCSENABLED)<>0;
  SysLocale.RightToLeft:=GetSystemMetrics(SM_MIDEASTENABLED)<>0;
  SysLocale.DefaultLCID := $0409;
  SysLocale.PriLangID := LANG_ENGLISH;
  SysLocale.SubLangID := SUBLANG_ENGLISH_US;
  // probably needs update with getthreadlocale. post 2.0.2

  DefaultCustomLocaleID := GetThreadLocale;
  if DefaultCustomLocaleID <> 0 then
    begin
      { Locale Identifiers
        +-------------+---------+-------------------------+
        |   Reserved  | Sort ID |      Language ID        |
        +-------------+---------+-------------------------+
        31         20 19      16 15                       0   bit }
      DefaultCustomLanguageID := DefaultCustomLocaleID and $FFFF; // 2^16
      if DefaultCustomLanguageID <> 0 then
        begin
          SysLocale.DefaultLCID := DefaultCustomLocaleID;
          { Language Identifiers
            +-------------------------+-------------------------+
            |     SubLanguage ID      |   Primary Language ID   |
            +-------------------------+-------------------------+
            15                      10  9                         0   bit  }
          SysLocale.PriLangID := DefaultCustomLanguageID and $3ff; // 2^10
          SysLocale.SubLangID := DefaultCustomLanguageID shr 10;
        end;
     end;

  Set8087CW(old8087CW);
  GetFormatSettings;
  if SysLocale.FarEast then GetEraNamesAndYearOffsets;
end;


{****************************************************************************
                           Target Dependent
****************************************************************************}

function SysErrorMessage(ErrorCode: Integer): String;
const
  MaxMsgSize = Format_Message_Max_Width_Mask;
var
  MsgBuffer: pChar;
begin
  GetMem(MsgBuffer, MaxMsgSize);
  FillChar(MsgBuffer^, MaxMsgSize, #0);
  FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM,
                 nil,
                 ErrorCode,
                 MakeLangId(LANG_NEUTRAL, SUBLANG_DEFAULT),
                 MsgBuffer,                 { This function allocs the memory }
                 MaxMsgSize,                           { Maximum message size }
                 nil);
  SysErrorMessage := MsgBuffer;
  FreeMem(MsgBuffer, MaxMsgSize);
end;

{****************************************************************************
                              Initialization code
****************************************************************************}

{$push}
{ GetEnvironmentStrings cannot be checked by CheckPointer function }
{$checkpointer off}

Function GetEnvironmentVariable(Const EnvVar : String) : String;

var
   oemenvvar, oemstr : RawByteString;
   i, hplen : longint;
   hp,p : pchar;
begin
   oemenvvar:=uppercase(envvar);
   SetCodePage(oemenvvar,CP_OEMCP);
   Result:='';
   p:=GetEnvironmentStringsA;
   hp:=p;
   while hp^<>#0 do
     begin
        oemstr:=hp;
        { cache length, may change after uppercasing depending on code page }
        hplen:=length(oemstr);
        { all environment variables are encoded in the oem code page }
        SetCodePage(oemstr,CP_OEMCP,false);
        i:=pos('=',oemstr);
        if uppercase(copy(oemstr,1,i-1))=oemenvvar then
          begin
             Result:=copy(oemstr,i+1,length(oemstr)-i);
             break;
          end;
        { next string entry}
        hp:=hp+hplen+1;
     end;
   FreeEnvironmentStringsA(p);
end;

Function GetEnvironmentVariable(Const EnvVar : UnicodeString) : UnicodeString;

var
   s, upperenv : Unicodestring;
   i : longint;
   hp,p : pwidechar;
begin
   Result:='';
   p:=GetEnvironmentStringsW;
   hp:=p;
   upperenv:=uppercase(envvar);
   while hp^<>#0 do
     begin
        s:=hp;
        i:=pos('=',s);
        if uppercase(copy(s,1,i-1))=upperenv then
          begin
             Result:=copy(s,i+1,length(s)-i);
             break;
          end;
        { next string entry}
        hp:=hp+strlen(hp)+1;
     end;
   FreeEnvironmentStringsW(p);
end;

Function GetEnvironmentVariableCount : Integer;

var
  hp,p : pchar;
begin
  Result:=0;
  p:=GetEnvironmentStringsA;
  hp:=p;
  If (Hp<>Nil) then
    while hp^<>#0 do
      begin
      Inc(Result);
      hp:=hp+strlen(hp)+1;
      end;
  FreeEnvironmentStringsA(p);
end;

Function GetEnvironmentString(Index : Integer) : {$ifdef FPC_RTL_UNICODE}UnicodeString{$else}AnsiString{$endif};

var
  hp,p : pchar;
{$ifdef FPC_RTL_UNICODE}
  tmpstr : RawByteString;
{$endif}
begin
  Result:='';
  p:=GetEnvironmentStringsA;
  hp:=p;
  If (Hp<>Nil) then
    begin
      while (hp^<>#0) and (Index>1) do
        begin
          Dec(Index);
          hp:=hp+strlen(hp)+1;
        end;
    If (hp^<>#0) then
      begin
{$ifdef FPC_RTL_UNICODE}
        tmpstr:=hp;
        SetCodePage(tmpstr,CP_OEMCP,false);
        Result:=tmpstr;
{$else}
        Result:=hp;
        SetCodePage(RawByteString(Result),CP_OEMCP,false);
{$endif}
      end;
    end;
  FreeEnvironmentStringsA(p);
end;

{$pop}

function ExecuteProcess(Const Path: AnsiString; Const ComLine: AnsiString;Flags:TExecuteFlags=[]):integer;
// win specific  function
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  Proc : THandle;
  l    : DWord;
  CommandLine : ansistring;
  e : EOSError;
  ExecInherits : longbool;
begin
  FillChar(SI, SizeOf(SI), 0);
  SI.cb:=SizeOf(SI);
  SI.wShowWindow:=1;
  { always surround the name of the application by quotes
    so that long filenames will always be accepted. But don't
    do it if there are already double quotes, since Win32 does not
    like double quotes which are duplicated!
  }
  if pos('"',path)=0 then
    CommandLine:='"'+path+'"'
  else
    CommandLine:=path;
  if ComLine <> '' then
    CommandLine:=Commandline+' '+ComLine+#0
  else
    CommandLine := CommandLine + #0;

  ExecInherits:=ExecInheritsHandles in Flags;

  if not CreateProcessA(nil, pchar(CommandLine),
    Nil, Nil, ExecInherits,$20, Nil, Nil, SI, PI) then
    begin
      e:=EOSError.CreateFmt(SExecuteProcessFailed,[CommandLine,GetLastError]);
      e.ErrorCode:=GetLastError;
      raise e;
    end;
  Proc:=PI.hProcess;
  if WaitForSingleObject(Proc, dword($ffffffff)) <> $ffffffff then
    begin
      GetExitCodeProcess(Proc,l);
      CloseHandle(Proc);
      CloseHandle(PI.hThread);
      result:=l;
    end
  else
    begin
      e:=EOSError.CreateFmt(SExecuteProcessFailed,[CommandLine,GetLastError]);
      e.ErrorCode:=GetLastError;
      CloseHandle(Proc);
      CloseHandle(PI.hThread);
      raise e;
    end;
end;

function ExecuteProcess(Const Path: AnsiString; Const ComLine: Array of AnsiString;Flags:TExecuteFlags=[]):integer;

var
  CommandLine: AnsiString;
  I: integer;

begin
  Commandline := '';
  for I := 0 to High (ComLine) do
   if Pos (' ', ComLine [I]) <> 0 then
    CommandLine := CommandLine + ' ' + '"' + ComLine [I] + '"'
   else
    CommandLine := CommandLine + ' ' + Comline [I];
  ExecuteProcess := ExecuteProcess (Path, CommandLine,Flags);
end;

Procedure Sleep(Milliseconds : Cardinal);

begin
  Windows.Sleep(MilliSeconds)
end;

Function GetLastOSError : Integer;

begin
  Result:=GetLastError;
end;

{****************************************************************************
                              Initialization code
****************************************************************************}

var
   kernel32dll : THandle;

Procedure LoadVersionInfo;
// and getfreespaceex
Var
   versioninfo : TOSVERSIONINFO;
begin
  GetDiskFreeSpaceEx:=nil;
  versioninfo.dwOSVersionInfoSize:=sizeof(versioninfo);
  GetVersionEx(versioninfo);
  Win32Platform:=versionInfo.dwPlatformId;
  Win32MajorVersion:=versionInfo.dwMajorVersion;
  Win32MinorVersion:=versionInfo.dwMinorVersion;
  Win32BuildNumber:=versionInfo.dwBuildNumber;
  Move (versioninfo.szCSDVersion ,Win32CSDVersion[1],128);
  win32CSDVersion[0]:=chr(strlen(pchar(@versioninfo.szCSDVersion)));
  kernel32dll:=GetModuleHandle('kernel32');
  if kernel32dll<>0 then
    GetDiskFreeSpaceEx:=TGetDiskFreeSpaceEx(GetProcAddress(kernel32dll,'GetDiskFreeSpaceExA'));
end;

Function GetAppConfigDir(Global : Boolean) : String;
begin
  If Global then
    Result:=GetWindowsSpecialDir(CSIDL_COMMON_APPDATA)
  else
    Result:=GetWindowsSpecialDir(CSIDL_LOCAL_APPDATA);
  If (Result<>'') then
    begin
      if VendorName<>'' then
        Result:=IncludeTrailingPathDelimiter(Result+VendorName);
      Result:=IncludeTrailingPathDelimiter(Result+ApplicationName);
    end
  else
    Result:=IncludeTrailingPathDelimiter(DGetAppConfigDir(Global));
end;

Function GetAppConfigFile(Global : Boolean; SubDir : Boolean) : String;

begin
  result:=DGetAppConfigFile(Global,SubDir);
end;

Function GetUserDir : String;

begin
  Result:=GetWindowsSpecialDir(CSIDL_PROFILE);
end;

Procedure InitSysConfigDir;

begin
  SetLength(SysConfigDir, MAX_PATH);
  SetLength(SysConfigDir, GetWindowsDirectoryA(PChar(SysConfigDir), MAX_PATH));
end;

{****************************************************************************
                    Target Dependent WideString stuff
****************************************************************************}

{ This is the case of Win9x. Limited to current locale of course, but it's better
  than not working at all. }
function DoCompareStringA(P1, P2: PWideChar; L1, L2: PtrUInt; Flags: DWORD): PtrInt;
  var
    a1, a2: AnsiString;
  begin
    if L1>0 then
      widestringmanager.Wide2AnsiMoveProc(P1,a1,DefaultSystemCodePage,L1);
    if L2>0 then
      widestringmanager.Wide2AnsiMoveProc(P2,a2,DefaultSystemCodePage,L2);
    SetLastError(0);
    Result:=CompareStringA(LOCALE_USER_DEFAULT,Flags,pchar(a1),
      length(a1),pchar(a2),length(a2))-2;
  end;

function DoCompareStringW(P1, P2: PWideChar; L1, L2: PtrUInt; Flags: DWORD): PtrInt;
  begin
    SetLastError(0);
    Result:=CompareStringW(LOCALE_USER_DEFAULT,Flags,P1,L1,P2,L2)-2;
    if GetLastError=0 then
      Exit;
    if GetLastError=ERROR_CALL_NOT_IMPLEMENTED then  // Win9x case
      Result:=DoCompareStringA(P1, P2, L1, L2, Flags);
    if GetLastError<>0 then
      RaiseLastOSError;
  end;

function Win32CompareWideString(const s1, s2 : WideString) : PtrInt;
  begin
    Result:=DoCompareStringW(PWideChar(s1), PWideChar(s2), Length(s1), Length(s2), 0);
  end;


function Win32CompareTextWideString(const s1, s2 : WideString) : PtrInt;
  begin
    Result:=DoCompareStringW(PWideChar(s1), PWideChar(s2), Length(s1), Length(s2), NORM_IGNORECASE);
  end;


function Win32AnsiUpperCase(const s: string): string;
  begin
    if length(s)>0 then
      begin
        result:=s;
        UniqueString(result);
        CharUpperBuffA(pchar(result),length(result));
      end
    else
      result:='';
  end;


function Win32AnsiLowerCase(const s: string): string;
  begin
    if length(s)>0 then
      begin
        result:=s;
        UniqueString(result);
        CharLowerBuffA(pchar(result),length(result));
      end
    else
      result:='';
  end;


function Win32AnsiCompareStr(const S1, S2: string): PtrInt;
  begin
    result:=CompareStringA(LOCALE_USER_DEFAULT,0,pchar(s1),length(s1),
      pchar(s2),length(s2))-2;
  end;


function Win32AnsiCompareText(const S1, S2: string): PtrInt;
  begin
    result:=CompareStringA(LOCALE_USER_DEFAULT,NORM_IGNORECASE,pchar(s1),length(s1),
      pchar(s2),length(s2))-2;
  end;


function Win32AnsiStrComp(S1, S2: PChar): PtrInt;
  begin
    result:=CompareStringA(LOCALE_USER_DEFAULT,0,s1,-1,s2,-1)-2;
  end;


function Win32AnsiStrIComp(S1, S2: PChar): PtrInt;
  begin
    result:=CompareStringA(LOCALE_USER_DEFAULT,NORM_IGNORECASE,s1,-1,s2,-1)-2;
  end;


function Win32AnsiStrLComp(S1, S2: PChar; MaxLen: PtrUInt): PtrInt;
  begin
    result:=CompareStringA(LOCALE_USER_DEFAULT,0,s1,maxlen,s2,maxlen)-2;
  end;


function Win32AnsiStrLIComp(S1, S2: PChar; MaxLen: PtrUInt): PtrInt;
  begin
    result:=CompareStringA(LOCALE_USER_DEFAULT,NORM_IGNORECASE,s1,maxlen,s2,maxlen)-2;
  end;


function Win32AnsiStrLower(Str: PChar): PChar;
  begin
    CharLowerA(str);
    result:=str;
  end;


function Win32AnsiStrUpper(Str: PChar): PChar;
  begin
    CharUpperA(str);
    result:=str;
  end;

function Win32CompareUnicodeString(const s1, s2 : UnicodeString) : PtrInt;
  begin
    Result:=DoCompareStringW(PWideChar(s1), PWideChar(s2), Length(s1), Length(s2), 0);
  end;


function Win32CompareTextUnicodeString(const s1, s2 : UnicodeString) : PtrInt;
  begin
    Result:=DoCompareStringW(PWideChar(s1), PWideChar(s2), Length(s1), Length(s2), NORM_IGNORECASE);
  end;


{ there is a similiar procedure in the system unit which inits the fields which
  are relevant already for the system unit }
procedure InitWin32Widestrings;
  begin
    { return value: number of code points in the string. Whenever an invalid
      code point is encountered, all characters part of this invalid code point
      are considered to form one "character" and the next character is
      considered to be the start of a new (possibly also invalid) code point }
//!!!    CharLengthPCharProc : function(const Str: PChar): PtrInt;
    { return value:
      -1 if incomplete or invalid code point
      0 if NULL character,
      > 0 if that's the length in bytes of the code point }
//!!!!    CodePointLengthProc : function(const Str: PChar; MaxLookAead: PtrInt): Ptrint;
    widestringmanager.CompareWideStringProc:=@Win32CompareWideString;
    widestringmanager.CompareTextWideStringProc:=@Win32CompareTextWideString;
    widestringmanager.UpperAnsiStringProc:=@Win32AnsiUpperCase;
    widestringmanager.LowerAnsiStringProc:=@Win32AnsiLowerCase;
    widestringmanager.CompareStrAnsiStringProc:=@Win32AnsiCompareStr;
    widestringmanager.CompareTextAnsiStringProc:=@Win32AnsiCompareText;
    widestringmanager.StrCompAnsiStringProc:=@Win32AnsiStrComp;
    widestringmanager.StrICompAnsiStringProc:=@Win32AnsiStrIComp;
    widestringmanager.StrLCompAnsiStringProc:=@Win32AnsiStrLComp;
    widestringmanager.StrLICompAnsiStringProc:=@Win32AnsiStrLIComp;
    widestringmanager.StrLowerAnsiStringProc:=@Win32AnsiStrLower;
    widestringmanager.StrUpperAnsiStringProc:=@Win32AnsiStrUpper;
    widestringmanager.CompareUnicodeStringProc:=@Win32CompareUnicodeString;
    widestringmanager.CompareTextUnicodeStringProc:=@Win32CompareTextUnicodeString;
  end;

{ Platform-specific exception support }

function WinExceptionObject(code: Longint; const rec: TExceptionRecord): Exception;
var
  entry: PExceptMapEntry;
begin
  entry := FindExceptMapEntry(code);
  if assigned(entry) then
    result:=entry^.cls.CreateRes(entry^.msg)
  else
    result:=EExternalException.CreateResFmt(@SExternalException,[rec.ExceptionCode]);

  if result is EExternal then
    EExternal(result).FExceptionRecord:=rec;
end;

function WinExceptionClass(code: longint): ExceptClass;
var
  entry: PExceptMapEntry;
begin
  entry := FindExceptMapEntry(code);
  if assigned(entry) then
    result:=entry^.cls
  else
    result:=EExternalException;
end;


Initialization
  InitWin32Widestrings;
  InitExceptions;       { Initialize exceptions. OS independent }
{$ifdef mswindows}      { Keeps exe size down for systems that do not use SEH }
  ExceptObjProc:=@WinExceptionObject;
  ExceptClsProc:=@WinExceptionClass;
{$endif mswindows}
  InitInternational;    { Initialize internationalization settings }
  LoadVersionInfo;
  InitSysConfigDir;
  OnBeep:=@SysBeep;
Finalization
  DoneExceptions;
end.
