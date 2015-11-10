Program PenShare;


{ Dieses Programm demonstriert die ObtainPen Funktion der graphics.lib V39+

  Ab OS3.0 gibt es sogenanntes Pen Sharing. Das bedeutet, da� sich
  verschiedene Programme die Farben der Workbench teilen. Zum Beispiel
  k�nnen Sie mit Multiview 2 Bilder mit 256 auf der Workbench anzeigen,
  wobei beide noch relativ gut aussehen.

  Mit der Funktion ObtainPen k�nnen Sie sich ein Farbregister mit einem
  ganz bestimmten Farbwert reservieren lassen.

  Es gibt noch eine zweite Funktion namens ObtainBestPen (Multiview
  benutzt diese Fkt.). Mit ihr werden die Farbwerte nicht 100%ig exakt
  behandelt. So wird z.B. zwei leicht unterschiedlichen Rott�nen dasselbe
  Farbregister zugeordnet.


  Autor: Andreas Tetzl
  Datum: 22.12.1994
}

{
  Translated to fpc pascal
  20 Mar 2001.

  Reworked to use systemvartags.
  Text to GText.
  28 Nov 2002.

  nils.sjoholm@mailbox.swipnet.se
}

uses exec, agraphics, intuition, utility,systemvartags;

VAR RP : pRastPort;
    Win : pWindow;
    Colors : Array[0..2] of longint;
    Msg : pMessage;
    VP : pViewPort;
    i : Integer;


PROCEDURE CleanExit(Why : String; RC : longint);
Begin
 For i:=0 to 2 do
  If Colors[i]<>-1 then ReleasePen(VP^.ColorMap,Colors[i]);

 If Win<>NIL then CloseWindow(Win);
 If Why<>'' then Writeln(Why);
 halt(RC);
end;

Begin
 For i:=0 to 2 do Colors[i]:=-1; { Farbwerte vorbelegen (wegen CleanExit()) }


  Win:=OpenWindowTags(nil,[WA_Width,150,
                        WA_Height,100,
                        WA_Title,'PenShare',
                        WA_Flags,WFLG_CLOSEGADGET+WFLG_DRAGBAR,
                        WA_IDCMP,IDCMP_CLOSEWINDOW,
                        TAG_END]);



 If Win=NIL then CleanExit('Can''t open window',10);
 VP:=ViewPortAddress(Win);
 RP:=Win^.RPort;

 { F�r n geben Sie die gew�nschte Farbregisternummer }
 { an (-1, wenn es Ihnen egal ist).                  }
 { Die folgenden drei RGB-Werte m�ssen die ganzen    }
 { 32 Bit ausnutzen. Wenn Sie z.B. f�r Rot den Wert  }
 { $F0 setzen wollen, m�ssen Sie in r den Wert       }
 { $F0F0F0F0 einsetzen !                             }
 { Wenn Sie die Farbe sp�ter ver�ndern               }
 { (z.B. ColorCycling), m�ssen Sie im Flags          }
 { Parameter PENF_EXCLUSIVE setzen !                 }
 { (siehe Include:graphics/View.i                    }

 Colors[0]:=ObtainPen(VP^.ColorMap,-1,$FFFFFFFF,0,0,0); { Rot  }
 Colors[1]:=ObtainPen(VP^.ColorMap,-1,0,$FFFFFFFF,0,0); { Gr�n }
 Colors[2]:=ObtainPen(VP^.ColorMap,-1,0,0,$FFFFFFFF,0); { Blau }
 If (Colors[0]=-1) or (Colors[1]=-1) or (Colors[1]=-1) then
  CleanExit('Please set more colors for Workbench.',10);

 SetAPen(RP,Colors[0]);
 GfxMove(RP,40,40);
 GfxText(RP,'Red',3);

 SetAPen(RP,Colors[1]);
 GfxMove(RP,40,60);
 GfxText(RP,'Green',5);

 SetAPen(RP,Colors[2]);
 GfxMove(RP,40,80);
 GfxText(RP,'Blue',4);

 Msg:=WaitPort(Win^.UserPort);
 Msg:=GetMsg(Win^.UserPort);
 ReplyMsg(Msg);

 CleanExit('',0);
end.
