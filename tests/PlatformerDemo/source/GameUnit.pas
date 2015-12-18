unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  G2Scene2D,
  Types,
  Classes;

type
  TGame = class
  protected
  public
    var Scene: TG2Scene2D;
    var Display: TG2Display2D;
    var Player: TG2Scene2DEntity;
    var Background: TG2Scene2DEntity;
    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    procedure Finalize;
    procedure Update;
    procedure Render;
    procedure KeyDown(const Key: Integer);
    procedure KeyUp(const Key: Integer);
    procedure MouseDown(const Button, x, y: Integer);
    procedure MouseUp(const Button, x, y: Integer);
    procedure Scroll(const y: Integer);
    procedure Print(const c: AnsiChar);
  end;

var
  Game: TGame;

implementation

//TGame BEGIN
constructor TGame.Create;
begin
  g2.CallbackInitializeAdd(@Initialize);
  g2.CallbackFinalizeAdd(@Finalize);
  g2.CallbackUpdateAdd(@Update);
  g2.CallbackRenderAdd(@Render);
  g2.CallbackKeyDownAdd(@KeyDown);
  g2.CallbackKeyUpAdd(@KeyUp);
  g2.CallbackMouseDownAdd(@MouseDown);
  g2.CallbackMouseUpAdd(@MouseUp);
  g2.CallbackScrollAdd(@Scroll);
  g2.CallbackPrintAdd(@Print);
  g2.Params.MaxFPS := 100;
  g2.Params.Width := 1024;
  g2.Params.Height := 768;
  g2.Params.ScreenMode := smWindow;
end;

destructor TGame.Destroy;
begin
  g2.CallbackInitializeRemove(@Initialize);
  g2.CallbackFinalizeRemove(@Finalize);
  g2.CallbackUpdateRemove(@Update);
  g2.CallbackRenderRemove(@Render);
  g2.CallbackKeyDownRemove(@KeyDown);
  g2.CallbackKeyUpRemove(@KeyUp);
  g2.CallbackMouseDownRemove(@MouseDown);
  g2.CallbackMouseUpRemove(@MouseUp);
  g2.CallbackScrollRemove(@Scroll);
  g2.CallbackPrintRemove(@Print);
  inherited Destroy;
end;

procedure TGame.Initialize;
begin
  Display := TG2Display2D.Create;
  Display.Width := 10;
  Display.Height := 10;
  Display.Position := G2Vec2(0, 0);
  Display.Zoom := 1.3;
  Scene := TG2Scene2D.Create;
  Scene.Load('Map1.g2s2d');
  Scene.Simulate := True;
  Scene.EnablePhysics;
  Player := Scene.FindEntityByName('Player');
  Background := Scene.FindEntityByName('Background');
end;

procedure TGame.Finalize;
begin
  Scene.Free;
  Display.Free;
  Free;
end;

procedure TGame.Update;
  var Character: TG2Scene2DComponentCharacter;
  var Animation: TG2Scene2DComponentSpineAnimation;
begin
  if Assigned(Player) then
  begin
    Display.Position := Player.Transform.p;
    Character := TG2Scene2DComponentCharacter(Player.ComponentOfType[TG2Scene2DComponentCharacter]);
    Animation := TG2Scene2DComponentSpineAnimation(Player.ComponentOfType[TG2Scene2DComponentSpineAnimation]);
    if Assigned(Character) then
    begin
      if Character.Standing then
      begin
        if g2.KeyDown[G2K_D] then
        begin
          Character.Walk(15);
          if Assigned(Animation) then
          begin
            Animation.Animation := 'run';
            Animation.FlipX := False;
          end;
        end
        else if g2.KeyDown[G2K_A] then
        begin
          Character.Walk(-15);
          if Assigned(Animation) then
          begin
            Animation.Animation := 'run';
            Animation.FlipX := True;
          end;
        end
        else
        begin
          if Assigned(Animation) then
          begin
            Animation.Animation := 'idle';
          end;
        end;
        if g2.KeyDown[G2K_Space] then
        begin
          Character.Jump(G2Vec2(0, -10));
          if Assigned(Animation) then
          begin
            Animation.Animation := '';
            Animation.AnimationState.SetAnimation(0, 'jump', False).EndTime := 1;
          end;
        end;
      end
      else
      begin
        if g2.KeyDown[G2K_D] then
        begin
          Character.Glide(G2Vec2(0.25, 0));
        end
        else if g2.KeyDown[G2K_A] then
        begin
          Character.Glide(G2Vec2(-0.25, 0));
        end;
        if Assigned(Animation)
        and (Animation.Animation <> '') then
        begin
          Animation.Animation := '';
          with Animation.AnimationState.SetAnimation(0, 'jump', False) do
          begin
            Time := 0.5;
            EndTime := 1;
          end;
        end;
      end;
    end;
  end;
  if Assigned(Background) then
  begin
    Background.Transform := G2Transform2(Display.Position, Background.Transform.r);
  end;
end;

procedure TGame.Render;
begin
  Scene.Render(Display);
end;

procedure TGame.KeyDown(const Key: Integer);
begin

end;

procedure TGame.KeyUp(const Key: Integer);
begin

end;

procedure TGame.MouseDown(const Button, x, y: Integer);
begin

end;

procedure TGame.MouseUp(const Button, x, y: Integer);
begin

end;

procedure TGame.Scroll(const y: Integer);
begin

end;

procedure TGame.Print(const c: AnsiChar);
begin

end;
//TGame END

end.