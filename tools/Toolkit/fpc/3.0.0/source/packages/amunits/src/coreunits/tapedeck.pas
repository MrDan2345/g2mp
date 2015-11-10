{
    This file is part of the Free Pascal run time library.

    A file in Amiga system run time library.
    Copyright (c) 1998 by Nils Sjoholm
    member of the Amiga RTL development team.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

unit tapedeck;

INTERFACE

uses utility;

const
    TDECK_Dummy            = (TAG_USER+$05000000);
    TDECK_Mode             = (TDECK_Dummy + 1);
    TDECK_Paused           = (TDECK_Dummy + 2);

    TDECK_Tape             = (TDECK_Dummy + 3);
        { (BOOL) Indicate whether tapedeck or animation controls.  Defaults
         * to FALSE. }

    TDECK_Frames           = (TDECK_Dummy + 11);
        { (LONG) Number of frames in animation.  Only valid when using
         * animation controls. }

    TDECK_CurrentFrame     = (TDECK_Dummy + 12);
        { (LONG) Current frame.  Only valid when using animation controls. }

{***************************************************************************}

{ Possible values for TDECK_Mode }
    BUT_REWIND     = 0;
    BUT_PLAY       = 1;
    BUT_FORWARD    = 2;
    BUT_STOP       = 3;
    BUT_PAUSE      = 4;
    BUT_BEGIN      = 5;
    BUT_FRAME      = 6;
    BUT_END        = 7;

{***************************************************************************}

IMPLEMENTATION

end.
