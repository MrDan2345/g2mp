program g2template;

{$mode objfpc}{$H+}
{$R *.res}

uses
  Gen2MP,
  G2Types,
  G2App;

begin
  g2.CallbackInitializeAdd(@App.Initialize);
  g2.CallbackFinalizeAdd(@App.Finalize);
  g2.CallbackUpdateAdd(@App.Update);
  g2.CallbackRenderAdd(@App.Render);
  g2.CallbackKeyDownAdd(@App.KeyDown);
  g2.CallbackKeyUpAdd(@App.KeyUp);
  g2.CallbackMouseDownAdd(@App.MouseDown);
  g2.CallbackMouseUpAdd(@App.MouseUp);
  g2.Params.Width := 1024;
  g2.Params.Height := 768;
  g2.Params.ScreenMode := smWindow;
  g2.Start;
end.

