{ ATK -  Accessibility Toolkit
   Copyright 2001 Sun Microsystems Inc.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the
   Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.
  }
unit atk; // keep unit name lowercase for kylix

{$IFDEF FPC}
  {$mode objfpc}
{$ENDIF}
{$IFDEF VER140}
  {$DEFINE KYLIX}
{$ENDIF}

interface

uses glib2;

const
{$ifdef windows}
  {$define atkwin}
  atklib = 'libatk-1.0-0.dll';
  {$IFDEF FPC}
    {$ifndef NO_SMART_LINK}
      {$smartlink on}
    {$endif}
  {$ENDIF}
{$else}
  {$ifdef UseCustomLibs}
  atklib = '';
  {$else}
  atklib = 'libatk-1.0.so';
  {$endif}
{$endif}

{$IFNDEF KYLIX}
  {$PACKRECORDS C}
{$ELSE}
  {$ALIGN 4}
  {$WEAKPACKAGEUNIT}
  {$WARNINGS OFF}
{$ENDIF}

type
{$DEFINE read_forward_definitions}
  // internal types
  PAtkImplementor = pointer;
  PAtkAction = pointer;
  PAtkComponent = pointer;
  PAtkDocument = pointer;
  PAtkEditableText = pointer;
  PAtkHypertext = pointer;
  PAtkImage = pointer;
  PAtkSelection = pointer;
  PAtkStreamableContent = pointer;
  PAtkTable = pointer;
  PAtkText = pointer;
  PAtkValue = pointer;

{$include atkincludes.inc}
{$UNDEF read_forward_definitions}

{$DEFINE read_interface_types}
{$include atkincludes.inc}
{$UNDEF read_interface_types}

{$DEFINE read_interface_rest}
{$include atkincludes.inc}
{$UNDEF read_interface_rest}

implementation

// call implementation parts of header files
{$DEFINE read_implementation}
{$include atkincludes.inc}
{$UNDEF read_implementation}

end.
