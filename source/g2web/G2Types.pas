unit G2Types;

//The contents of this software are used with permission, subject to
//the Mozilla Public License Version 1.1 (the "License"); you may
//not use this software except in compliance with the License. You may
//obtain a copy of the License at
//http://www.mozilla.org/MPL/MPL-1.1.html
//
//Software distributed under the License is distributed on an
//"AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
//implied. See the License for the specific language governing
//rights and limitations under the License.
//
//This module is a part of g2mp game development framework.

interface

type
  Single = Float;
  Char = String;
  AnsiChar = Char;
  AnsiString = String;
  Pointer = TObject;
  TG2Float = Float;
  TG2IntS8 = Integer;
  TG2IntU8 = Integer;
  TG2IntS16 = Integer;
  TG2IntU16 = Integer;
  TG2IntS32 = Integer;
  TG2IntU32 = Integer;
  TG2StrArr = array of String;

  TG2Proc = procedure ();
  TG2ProcObj = TG2Proc;

const
  G2K_Escape = 0;
  G2K_F1 = 1;
  G2K_F2 = 2;
  G2K_F3 = 3;
  G2K_F4 = 4;
  G2K_F5 = 5;
  G2K_F6 = 6;
  G2K_F7 = 7;
  G2K_F8 = 8;
  G2K_F9 = 9;
  G2K_F10 = 10;
  G2K_F11 = 11;
  G2K_F12 = 12;
  G2K_ScrlLock = 13;
  G2K_Pause = 14;
  G2K_Tilda = 15;
  G2K_1 = 16;
  G2K_2 = 17;
  G2K_3 = 18;
  G2K_4 = 19;
  G2K_5 = 20;
  G2K_6 = 21;
  G2K_7 = 22;
  G2K_8 = 23;
  G2K_9 = 24;
  G2K_0 = 25;
  G2K_Minus = 26;
  G2K_Plus = 27;
  G2K_Back = 28;
  G2K_Tab = 29;

  G2K_A = 30;
  G2K_B = 31;
  G2K_C = 32;
  G2K_D = 33;
  G2K_E = 34;
  G2K_F = 35;
  G2K_G = 36;
  G2K_H = 37;
  G2K_I = 38;
  G2K_J = 39;
  G2K_K = 40;
  G2K_L = 41;
  G2K_M = 42;
  G2K_N = 43;
  G2K_O = 44;
  G2K_P = 45;
  G2K_Q = 46;
  G2K_R = 47;
  G2K_S = 48;
  G2K_T = 49;
  G2K_U = 50;
  G2K_V = 51;
  G2K_W = 52;
  G2K_X = 53;
  G2K_Y = 54;
  G2K_Z = 55;

  G2K_BrktL = 56;
  G2K_BrktR = 57;
  G2K_SemiCol = 58;
  G2K_Quote = 59;
  G2K_Comma = 60;
  G2K_Period = 61;
  G2K_Slash = 62;
  G2K_SlashR = 63;
  G2K_CapsLock = 64;
  G2K_ShiftL = 65;
  G2K_ShiftR = 66;
  G2K_CtrlL = 67;
  G2K_CtrlR = 68;
  G2K_WinL = 69;
  G2K_WinR = 70;
  G2K_AltL = 71;
  G2K_AltR = 72;
  G2K_Menu = 73;
  G2K_Return = 74;
  G2K_Space = 75;

  G2K_Insert = 76;
  G2K_Home = 77;
  G2K_PgUp = 78;
  G2K_Delete = 79;
  G2K_End = 80;
  G2K_PgDown = 81;

  G2K_Up = 82;
  G2K_Down = 83;
  G2K_Left = 84;
  G2K_Right = 85;

  G2K_NumLock = 86;
  G2K_NumDiv = 87;
  G2K_NumMul = 88;
  G2K_NumMinus = 89;
  G2K_NumPlus = 90;
  G2K_NumReturn = 91;
  G2K_NumPeriod = 92;
  G2K_Num0 = 93;
  G2K_Num1 = 94;
  G2K_Num2 = 95;
  G2K_Num3 = 96;
  G2K_Num4 = 97;
  G2K_Num5 = 98;
  G2K_Num6 = 99;
  G2K_Num7 = 100;
  G2K_Num8 = 101;
  G2K_Num9 = 102;

  G2K_Ctrl = G2K_CtrlL;
  G2K_Shift = G2K_ShiftL;
  G2K_Alt = G2K_AltL;

  G2MB_Undefined = 0;
  G2MB_Left = 1;
  G2MB_Right = 2;
  G2MB_Middle = 3;

  TwoPi = Pi * 2;
  HalfPi = Pi * 0.5;
  QuatPi = Pi * 0.25;
  RcpPi = 1 / Pi;
  Rcp255 = 1 / $ff;
  G2EPS = 1E-6;

  G2TextureCubeFaceGL: array[0..5] of Integer = (
    $8515, $8516, $8517, $8518, $8519, $851A
  );

implementation

end.
