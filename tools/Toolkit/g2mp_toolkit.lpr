program g2mp_toolkit;

{$mode objfpc}{$H+}
{$R *.res}

uses
  Gen2MP,
  G2Types,
  Toolkit;

begin
  g2.CallbackInitializeAdd(@App.Initialize);
  g2.CallbackFinalizeAdd(@App.Finalize);
  g2.CallbackUpdateAdd(@App.Update);
  g2.CallbackRenderAdd(@App.Render);
  g2.CallbackKeyDownAdd(@App.KeyDown);
  g2.CallbackKeyUpAdd(@App.KeyUp);
  g2.CallbackMouseDownAdd(@App.MouseDown);
  g2.CallbackMouseUpAdd(@App.MouseUp);
  g2.CallbackScrollAdd(@App.Scroll);
  g2.CallbackPrintAdd(@App.Print);
  g2.CallbackResizeAdd(@App.Resize);
  g2.Params.MaxFPS := 60;
  g2.Params.TargetUPS := 60;
  g2.Params.Resizable := False;
  //g2.Params.Width := 960;//480;//960;//1440;
  //g2.Params.Height := 640;//320;//640;//960;
  g2.Params.ScreenMode := smMaximized;
  g2.Start;
end.

