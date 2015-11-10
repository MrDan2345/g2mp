{

    This file is part of the Free Pascal run time library.
    Copyright (c) 2004 by Karoly Balogh

    Sysutils unit for Nintendo Wii.
    This unit is based on the MorphOS one and is adapted for Nintendo Wii
    simply by stripping out all stuff inside funcs and procs. 
    Copyright (c) 2011 by Francesco Lombardi

    Based on Amiga version by Carl Eric Codere, and other
    parts of the RTL

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
{$DEFINE HAS_SLEEP}
{ used OS file system APIs use ansistring }
{$define SYSUTILS_HAS_ANSISTR_FILEUTIL_IMPL}
{ OS has an ansistring/single byte environment variable API }
{$define SYSUTILS_HAS_ANSISTR_ENVVAR_IMPL}

{ Include platform independent interface part }
{$i sysutilh.inc}

implementation

uses 
  dos, sysconst;

{ Include platform independent implementation part }
{$i sysutils.inc}


{****************************************************************************
                              File Functions
****************************************************************************}
function FileOpen(const FileName: rawbytestring; Mode: Integer): LongInt;
begin
  result := -1;
end;


function FileGetDate(Handle: LongInt) : LongInt;
begin
  result := -1;
end;


function FileSetDate(Handle, Age: LongInt) : LongInt;
begin
  result := -1;
end;


function FileCreate(const FileName: RawByteString) : LongInt;
begin
  result := -1;
end;


function FileCreate(const FileName: RawByteString; Rights: integer): LongInt;
begin
  result := -1;
end;

function FileCreate(const FileName: RawByteString; ShareMode: integer; Rights: integer): LongInt;
begin
  result := -1;
end;


function FileRead(Handle: LongInt; Out Buffer; Count: LongInt): LongInt;
begin
  result := -1;
end;


function FileWrite(Handle: LongInt; const Buffer; Count: LongInt): LongInt;
begin
  result := -1;
end;


function FileSeek(Handle, FOffset, Origin: LongInt) : LongInt;
begin
  result := -1;
end;

function FileSeek(Handle: LongInt; FOffset: Int64; Origin: Longint): Int64;
begin
  result := -1;
end;


procedure FileClose(Handle: LongInt);
begin
end;


function FileTruncate(Handle: THandle; Size: Int64): Boolean;
begin
  result := false;
end;


function DeleteFile(const FileName: RawByteString) : Boolean;
begin
  result := false;
end;


function RenameFile(const OldName, NewName: RawByteString): Boolean;
begin
  result := false;
end;


(****** end of non portable routines ******)


Function FileAge (Const FileName : RawByteString): Longint;
begin
  result := -1;
end;


Function FileExists (Const FileName : RawByteString) : Boolean;
Begin
  result := false;
end;



Function InternalFindFirst (Const Path : RawByteString; Attr : Longint; out Rslt : TAbstractSearchRec; var Name: RawByteString) : Longint;
begin
  result := -1;
end;


Function InternalFindNext (var Rslt : TAbstractSearchRec; var Name : RawByteString) : Longint;
begin
  result := -1;
end;

Procedure InternalFindClose(var Handle: THandle);
begin
end;

Function FileGetAttr (Const FileName : RawByteString) : Longint;
begin
  result := -1;
end;


Function FileSetAttr (Const Filename : RawByteString; Attr: longint) : Longint;
begin
  result := -1;
end;



{****************************************************************************
                              Disk Functions
****************************************************************************}

Procedure AddDisk(const path:string);
begin

end;



Function DiskFree(Drive: Byte): int64;
Begin
  result := -1;
End;


Function DiskSize(Drive: Byte): int64;
Begin
  result := -1;
End;


function DirectoryExists(const Directory: RawByteString): Boolean;
begin
  result := false;
end;



{****************************************************************************
                              Misc Functions
****************************************************************************}

Procedure SysBeep;
begin
end;

Procedure Sleep(Milliseconds : Cardinal);
var
  i,j : Cardinal;
  calib : Cardinal;
begin
{ $warning no idea if this calibration value is correct (FK) }
{ I estimated it roughly on the CPU clock of 16 MHz and 1+3 clock cycles for the loop }
{ 
  calib:=4000000;
  for i:=1 to Milliseconds do
    asm
      ldr r0,calib
    .L1:
      sub r0,r0,#1
      bne .L1
    end;
    }
end;
{****************************************************************************
                              Locale Functions
****************************************************************************}

Procedure GetLocalTime(var SystemTime: TSystemTime);
begin
end ;


function SysErrorMessage(ErrorCode: Integer): String;
begin
{  Result:=StrError(ErrorCode);}
  result := '';
end;

{****************************************************************************
                              OS utility functions
****************************************************************************}

Function GetEnvironmentVariable(Const EnvVar : String) : String;
begin
  result := '';
end;

Function GetEnvironmentVariableCount : Integer;
begin
  result := -1;
end;

Function GetEnvironmentString(Index : Integer) : {$ifdef FPC_RTL_UNICODE}UnicodeString{$else}AnsiString{$endif};
begin
  result := '';
end;

function ExecuteProcess (const Path: AnsiString; const ComLine: AnsiString;Flags:TExecuteFlags=[]): integer;
begin
  result := -1;
end;

function ExecuteProcess (const Path: AnsiString;
                                  const ComLine: array of AnsiString;Flags:TExecuteFlags=[]): integer;
begin
  result := -1;
end;


{****************************************************************************
                              Initialization code
****************************************************************************}

Initialization
  InitExceptions;
Finalization
  DoneExceptions;
end.
