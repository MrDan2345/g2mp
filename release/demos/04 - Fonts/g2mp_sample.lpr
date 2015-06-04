program g2mp_sample;

{$mode objfpc}{$H+}

uses
  Gen2MP,
  G2Types,
  G2Math;

var
  Font: TG2Font;

procedure Initialize;
begin
  g2.Window.Caption := 'Fonts';
  Font := TG2Font.Create;
  Font.Load('Font.g2f');
end;

procedure Finalize;
begin
  Font.Free;
end;

procedure Update;
begin

end;

procedure Render;
begin
  Font.Print(
    (g2.Params.Width - Font.TextWidth('Hello World')) * 0.5,
    (g2.Params.Height - Font.TextHeight('Hello World')) * 0.5,
    'Hello World'
  );
end;

procedure KeyDown(const Key: Integer);
begin
  if Key = G2K_Escape then
  g2.Stop;
end;

{$R *.res}

begin
  g2.CallbackInitializeAdd(@Initialize);
  g2.CallbackFinalizeAdd(@Finalize);
  g2.CallbackUpdateAdd(@Update);
  g2.CallbackRenderAdd(@Render);
  g2.CallbackKeyDownAdd(@KeyDown);
  g2.Params.ScreenMode := smWindow;
  g2.Params.Width := 1024;
  g2.Params.Width := 768;
  g2.Start;
end.

