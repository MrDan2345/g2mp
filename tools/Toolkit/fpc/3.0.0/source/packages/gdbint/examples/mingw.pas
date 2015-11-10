unit mingw;
{
    This file is part of the Free Pascal Integrated Development Environment
    Copyright (c) 2009 by Marco van de Voort

    Mingw helpers. Currently mostly atexit.
    Copied from fpmingw unit from ide directory.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

interface

// mingw put atexit in binaries, so that it can have one atexit, and call it from
// dll and .exe startup code.
// This unit provides a similar service for when mingw code (read: libgdb and friends) are statically
// linked to FPC.

Type
  TCFunction = function:longint cdecl; // prototype of an handler to be registered with atexit

function atexit(p:TCFunction):longint; cdecl;  // export our own atexit handler

implementation

uses gdbint; // force dependancies that hopefully make it execute at the right moment.

// prototype of atexit:
Type
  TAtexitFunction = function(p:TCFUnction):longint cdecl;

{$ifdef win64}
var __imp_atexit : TAtExitFunction; Cvar; external;  // "true" atexit in mingw libs.
{$else not win64}
var _imp__atexit : TAtExitFunction; Cvar; external;  // "true" atexit in mingw libs.
{$endif not win64}

function atexit(p:TCFunction):longint;cdecl; [public, alias : '_atexit'];

begin
{$ifdef win64}
  atexit:=__imp_atexit(p);  // simply route to "true" atexit
{$else not win64}
  atexit:=_imp__atexit(p);  // simply route to "true" atexit
{$endif not win64}
end;

{$ifdef win32}
procedure __cpu_features_init; cdecl; external;
{$endif win32}
procedure _pei386_runtime_relocator; cdecl; external;
procedure __main; cdecl;external;

procedure doinit;
// other mingw initialization. Sequence from crt1.c
begin
 // not (yet) done: set mingw exception handlers:
 // SetUnhandledExceptionFilter (_gnu_exception_handler);
{$ifdef win32}
  __cpu_features_init;        // load CPU features. Might be useful for debugger :-)
{$endif win32}

 // fpreset; 		      // don't do this, we init our own fp mask

 //  _mingw32_init_mainargs ();  // mingw doesn't handle arguments not necessary.
 //  _mingw32_init_fmode ();     // Set default filemode. Is not done for libraries, so we don't.

 // Adust references to dllimported data that have non-zero offsets.
  _pei386_runtime_relocator;  //

 // aligns stack here to 16 bytes

  {From libgcc.a, __main calls global class constructors via
      __do_global_ctors, This in turn  registers  __do_global_dtors
      as the first entry of the app's atexit table.  We do this
      explicitly at app startup rather than rely on gcc to generate
      the call in main's  prologue, since main may be imported from a dll
      which has its own __do_global_ctors.  }
 //  __main;                   // should be libgcc initialization but this causes infinite loop.
end;

procedure _cexit; cdecl; external;

procedure doatexit;
begin
{
   * Perform exit processing for the C library. This means
   * flushing output and calling 'atexit' registered functions.
}
 _cexit ();
end;

initialization
  doinit;
finalization
  doatexit;
end.
