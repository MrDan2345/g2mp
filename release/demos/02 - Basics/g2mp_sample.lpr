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
  g2.Window.Caption := 'Hello World';
  Font := TG2Font.Create;
  Font.Make(32);
end;

procedure Finalize;
begin
  //the g2mp resources are managed by the engine and will be freed upon finalization,
  //so freeing the resources manually is optional.
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
  g2.Stop; //this will free all the g2mp resources and finalize the engine.
end;

{$R *.res}

begin
  //the callback methods link the engine to the program.
  //the engine can also connect to the methods of an object.
  g2.CallbackInitializeAdd(@Initialize);
  g2.CallbackFinalizeAdd(@Finalize);
  g2.CallbackUpdateAdd(@Update);
  g2.CallbackRenderAdd(@Render);
  g2.CallbackKeyDownAdd(@KeyDown);
  //there are tree screen mode options:
  //smWindow - the engine will start in a window
  //the window size if defined by g2.Params.Width and g2.Params.Height.
  //smMaximized - the engine will start in a maximized window
  //the Width and Height parameters have no effect and instead will
  //be set to whatever size the maximized window is going to be.
  //smFullscreen - the engine will start in a fullscreen window
  //note that this mode is not an exclusive fullscreen and the
  //Width and Height properties will have no effect, they will
  //be set to the dimensions of the fullscreen borderless window.
  //the exclusive fullscreen mode is currently not supported.
  //it is not yet possible to change the resolution or the screen mode
  //after the initialization.
  g2.Params.ScreenMode := smWindow;
  g2.Params.Width := 1024;
  g2.Params.Width := 768;
  g2.Start; //this starts the engine.
end.

