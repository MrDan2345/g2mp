{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2006 by Francesco Lombardi.

    System unit for Nintendo DS

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

unit System;

interface

{$define FPC_IS_SYSTEM}
{$define HAS_CMDLINE}
{$define FPC_HAS_FEATURE_CONSOLEIO}
{$define FPC_HAS_FEATURE_COMMANDARGS}
{$define FPC_HAS_FEATURE_TEXTIO}
{$define FPC_HAS_FEATURE_FILEIO}
{$define FPC_HAS_FEATURE_THREADING}

{$i systemh.inc}
{$i ndsbiosh.inc}
{$i ndsh.inc}
{$i libch.inc}



{$define fpc_softfpu_interface}
{$i softfpu.pp}
{$undef fpc_softfpu_interface}


const
  LineEnding = #10;
  LFNSupport = true;
  DirectorySeparator = '/';
  DriveSeparator = ':';
  ExtensionSeparator = '.';
  PathSeparator = ':';
  AllowDirectorySeparators : set of char = ['\','/'];
  AllowDriveSeparators : set of char = [':'];
  maxExitCode = 255;

  MaxPathLen = 1024; // BSDs since 1993, Solaris 10, Darwin
  AllFilesMask = '*';

  UnusedHandle    = -1;
  StdInputHandle  = 0;
  StdOutputHandle = 1;
  StdErrorHandle  = 2;

  FileNameCaseSensitive : boolean = true;
  FileNameCasePreserving: boolean = true;
  CtrlZMarksEOF: boolean = true; (* #26 not considered as end of file *)

  sLineBreak = LineEnding;
  DefaultTextLineBreakStyle : TTextLineBreakStyle = tlbsLF;

var
  argc: LongInt = 0;
  argv: PPChar;
  envp: PPChar;
//  errno: integer;
  fake_heap_end: ^byte; cvar; external;
  irq_vector: integer; external name '__irq_vector';
  
function get_cmdline:Pchar;

property cmdline:Pchar read get_cmdline;

implementation

const 
  calculated_cmdline: Pchar = nil;
  { System limits, POSIX value in parentheses, used for buffer and stack allocation }
  ARG_MAX  = 65536;   {4096}  { Maximum number of argument size     }
  PATH_MAX = 1024;    {255}   { Maximum number of bytes in pathname }  

{$define fpc_softfpu_implementation}
{$i softfpu.pp}
{$undef fpc_softfpu_implementation}

{ we get these functions and types from the softfpu code }
{$define FPC_SYSTEM_HAS_float64}
{$define FPC_SYSTEM_HAS_float32}
{$define FPC_SYSTEM_HAS_flag}
{$define FPC_SYSTEM_HAS_extractFloat64Frac0}
{$define FPC_SYSTEM_HAS_extractFloat64Frac1}
{$define FPC_SYSTEM_HAS_extractFloat64Exp}
{$define FPC_SYSTEM_HAS_extractFloat64Sign}
{$define FPC_SYSTEM_HAS_ExtractFloat32Frac}
{$define FPC_SYSTEM_HAS_extractFloat32Exp}
{$define FPC_SYSTEM_HAS_extractFloat32Sign}

{$i system.inc}
{$i ndsbios.inc}
{$i nds.inc}
{$i libc.inc}



{$ifdef FPC_HAS_FEATURE_PROCESSES}
function GetProcessID: SizeUInt;
begin
  GetProcessID := 0;
end;
{$endif}


{*****************************************************************************
                       Misc. System Dependent Functions
*****************************************************************************}
procedure System_exit;
begin
  // Boo!
end;



{*****************************************************************************
                             ParamStr/Randomize
*****************************************************************************}
const
  QRAN_SHIFT  = 15;
  QRAN_MASK   = ((1 shl QRAN_SHIFT) - 1);
  QRAN_MAX    = QRAN_MASK;
  QRAN_A      = 1664525;
  QRAN_C      = 1013904223;

{ set randseed to a new pseudo random value }
procedure randomize;
var
  IPC_Timer: array [0..2] of byte absolute $27FF01B;
begin
  RandSeed := (IPC_Timer[0]  * 3600) + (IPC_Timer[1] * 60) + IPC_Timer[2]; 
end;

function random(): integer; 
begin	
	RandSeed := QRAN_A * RandSeed + QRAN_C;
	random := (RandSeed shr 16) and QRAN_MAX;
end;

function random(value: integer): integer; 
var
  a: integer;
begin	
	RandSeed := QRAN_A * RandSeed + QRAN_C;
	a := (RandSeed shr 16) and QRAN_MAX;
  random := (a * value) shr 15;
end;



Function ParamCount: Longint;
Begin
  Paramcount:=argc-1
End;


 { variable where full path and filename and executable is stored }
 { is setup by the startup of the system unit.                    }
var
 execpathstr : shortstring;

function paramstr(l: longint) : string;
 begin
   { stricly conforming POSIX applications  }
   { have the executing filename as argv[0] }
   if l=0 then
     begin
       paramstr := execpathstr;
     end
   else
     paramstr:=strpas(argv[l]);
 end;

{*****************************************************************************
                                    cmdline
*****************************************************************************}

procedure SetupCmdLine;
var
  bufsize,
  len,j,
  size,i : longint;
  found  : boolean;
  buf    : pchar;

  procedure AddBuf;
  begin
    reallocmem(calculated_cmdline,size+bufsize);
    move(buf^,calculated_cmdline[size],bufsize);
    inc(size,bufsize);
    bufsize:=0;
  end;

begin
  if argc<=0 then
    exit;
  GetMem(buf,ARG_MAX);
  size:=0;
  bufsize:=0;
  i:=0;
  while (i<argc) do
   begin
     len:=strlen(argv[i]);
     if len>ARG_MAX-2 then
      len:=ARG_MAX-2;
     found:=false;
     for j:=1 to len do
      if argv[i][j]=' ' then
       begin
         found:=true;
         break;
       end;
     if bufsize+len>=ARG_MAX-2 then
      AddBuf;
     if found then
      begin
        buf[bufsize]:='"';
        inc(bufsize);
      end;
     move(argv[i]^,buf[bufsize],len);
     inc(bufsize,len);
     if found then
      begin
        buf[bufsize]:='"';
        inc(bufsize);
      end;
     if i<argc-1 then
      buf[bufsize]:=' '
     else
      buf[bufsize]:=#0;
     inc(bufsize);
     inc(i);
   end;
  AddBuf;
  FreeMem(buf,ARG_MAX);
end;

function get_cmdline:Pchar;
begin
  if calculated_cmdline=nil then
    setupcmdline;
  get_cmdline:=calculated_cmdline;
end;


procedure SysInitStdIO;
begin
  OpenStdIO(Input,fmInput,StdInputHandle);
  OpenStdIO(Output,fmOutput,StdOutputHandle);
  OpenStdIO(ErrOutput,fmOutput,StdErrorHandle);
  OpenStdIO(StdOut,fmOutput,StdOutputHandle);
  OpenStdIO(StdErr,fmOutput,StdErrorHandle);
end;


function CheckInitialStkLen(stklen : SizeUInt) : SizeUInt;
begin
  result := stklen;
end;


begin
  StackLength := CheckInitialStkLen(InitialStkLen);
  StackBottom := Sptr - StackLength;
{ OS specific startup }

{ Set up signals handlers }
  fpc_cpucodeinit;

{ Setup heap }
  InitHeap;
  SysInitExceptions;

  SetupCmdLine;
  
{$ifdef FPC_HAS_FEATURE_CONSOLEIO}
  { Setup stdin, stdout and stderr }
  SysInitStdIO;
  { Reset IO Error }
  InOutRes:=0;
{$endif FPC_HAS_FEATURE_CONSOLEIO}
{ Arguments }
{$ifdef FPC_HAS_FEATURE_THREADING}
  { threading }
  InitSystemThreads;
{$endif FPC_HAS_FEATURE_THREADING}
end.
