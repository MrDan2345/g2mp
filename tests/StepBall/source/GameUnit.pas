unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  G2Scene2D,
  SysUtils,
  Types,
  Classes,
  box2d;

type
  TGameState = (gs_game, gs_goal);

  TGame = class
  protected
  public
    Font1: TG2Font;
    Display: TG2Display2D;
    Scene: TG2Scene2D;
    PickList: TG2Scene2DEntityList;
    Players: array[0..7] of TG2Scene2DEntity;
    Gates: array[0..1] of TG2Scene2DEntity;
    Field, Ball, TeamMarker: TG2Scene2DEntity;
    Score: array[0..1] of Integer;
    SelectPlayer: Integer;
    PicArrow: TG2Picture;
    PushBallUp: Boolean;
    PushBallRight: Boolean;
    PushBallLeft: Boolean;
    PushBallDown: Boolean;
    State: TGameState;
    ResetBall: TG2Transform2;
    ResetPlayers: array[0..7] of TG2Transform2;
    Team: Byte;
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
    procedure OnPushBallUpBegin(const EventData: TG2Scene2DEventData);
    procedure OnPushBallUpEnd(const EventData: TG2Scene2DEventData);
    procedure OnPushBallRightBegin(const EventData: TG2Scene2DEventData);
    procedure OnPushBallRightEnd(const EventData: TG2Scene2DEventData);
    procedure OnPushBallLeftBegin(const EventData: TG2Scene2DEventData);
    procedure OnPushBallLeftEnd(const EventData: TG2Scene2DEventData);
    procedure OnPushBallDownBegin(const EventData: TG2Scene2DEventData);
    procedure OnPushBallDownEnd(const EventData: TG2Scene2DEventData);
    procedure OnGoalLeft(const EventData: TG2Scene2DEventData);
    procedure OnGoalRight(const EventData: TG2Scene2DEventData);
    procedure OnGoal;
    procedure UpdateTeamMarker;
    function ResetGoalTimer(const Interval: Integer): Integer;
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
  var i, j: Integer;
  var Sprite: TG2Scene2DComponentSprite;
  var e: TG2Scene2DEntity;
  var ct: TG2Scene2DComponentText;
begin
  Font1 := TG2Font.Create;
  Font1.Make(16);
  PicArrow := TG2Picture.SharedAsset('Arrow.png', tu2D);
  PicArrow.RefInc;
  Display := TG2Display2D.Create;
  Display.Width := 9;
  Display.Height := 7;
  Display.Position := G2Vec2(0, 0);
  Scene := TG2Scene2D.Create;
  Scene.Load('Scene0.g2s2d');
  Scene.EnablePhysics;
  Scene.Simulate := True;
  Score[0] := 0;
  Score[1] := 0;
  for i := 0 to High(Players) do
  begin
    Players[i] := Scene.FindEntityByName('Player' + IntToStr(i + 1));
    ResetPlayers[i] := Players[i].Transform;
    for j := 0 to Players[i].ComponentCount - 1 do
    if Players[i].Components[j] is TG2Scene2DComponentSprite then
    begin
      Sprite := TG2Scene2DComponentSprite(Players[i].Components[j]);
      if Sprite.HasTag('player_color') then
      begin
        if i < Length(Players) shr 1 then
        begin
          Sprite.Color := $ffcc0000;
        end
        else
        begin
          Sprite.Color := $ff0000cc;
        end;
      end;
    end;
  end;
  for i := 0 to High(Gates) do
  Gates[i] := Scene.FindEntityByName('Gate' + IntToStr(i + 1));
  Gates[0].AddEvent('OnGoal', @OnGoalLeft);
  Gates[1].AddEvent('OnGoal', @OnGoalRight);
  Ball := Scene.FindEntityByName('Ball');
  ResetBall := Ball.Transform;
  Field := Scene.FindEntityByName('Field');
  Field.AddEvent('OnPushBallUpBegin', @OnPushBallUpBegin);
  Field.AddEvent('OnPushBallUpEnd', @OnPushBallUpEnd);
  Field.AddEvent('OnPushBallRightBegin', @OnPushBallRightBegin);
  Field.AddEvent('OnPushBallRightEnd', @OnPushBallRightEnd);
  Field.AddEvent('OnPushBallLeftBegin', @OnPushBallLeftBegin);
  Field.AddEvent('OnPushBallLeftEnd', @OnPushBallLeftEnd);
  Field.AddEvent('OnPushBallDownBegin', @OnPushBallDownBegin);
  Field.AddEvent('OnPushBallDownEnd', @OnPushBallDownEnd);
  TeamMarker := Scene.FindEntityByName('TeamMarker');
  PickList.Clear;
  e := Scene.FindEntityByName('Goal');
  if Assigned(e) then
  begin
    ct := TG2Scene2DComponentText(e.ComponentOfType[TG2Scene2DComponentText]);
    if Assigned(ct) then
    begin
      ct.Visible := False;
    end;
  end;
  Team := Random(2);
  UpdateTeamMarker;
  State := gs_game;
  SelectPlayer := -1;
end;

procedure TGame.Finalize;
begin
  Scene.Free;
  Display.Free;
  PicArrow.RefDec;
  Font1.Free;
  Free;
end;

procedure TGame.Update;
  var rb: TG2Scene2DComponentRigidBody;
begin
  Scene.QueryPoint(Display.CoordToDisplay(g2.MousePos), PickList);
  rb := TG2Scene2DComponentRigidBody(Ball.ComponentOfType[TG2Scene2DComponentRigidBody]);
  if Assigned(rb) then
  begin
    if PushBallDown then rb.PhysBody^.apply_force_to_center(b2_vec2(0, 0.1), true);
    if PushBallLeft then rb.PhysBody^.apply_force_to_center(b2_vec2(-0.1, 0), true);
    if PushBallRight then rb.PhysBody^.apply_force_to_center(b2_vec2(0.1, 0), true);
    if PushBallUp then rb.PhysBody^.apply_force_to_center(b2_vec2(0, -0.1), true);
  end;
end;

procedure TGame.Render;
  var mc, v, p, p0: TG2Vec2;
  var l: TG2Float;
begin
  Scene.Render(Display);
  if SelectPlayer > -1 then
  begin
    mc := Display.CoordToDisplay(g2.MousePos);
    p0 := Players[SelectPlayer].Transform.p;
    v := mc - p0;
    l := v.Len;
    if l > 0.5 then
    begin
      if l > 2 then v := v.Norm * 2;
      p := v.Perp.Norm * 0.125;
      Display.PicQuad(
        p0 - p, p0 - p + v,
        p0 + p, p0 + p + v,
        PicArrow.TexCoords.tl, PicArrow.TexCoords.tr,
        PicArrow.TexCoords.bl, PicArrow.TexCoords.br,
        $ffffffff, PicArrow.Texture
      );
    end;
  end;
  Font1.Print(10, 10, 1, 1, $ffffffff, IntToStr(PickList.Count), bmNormal, tfPoint);
end;

procedure TGame.KeyDown(const Key: Integer);
begin

end;

procedure TGame.KeyUp(const Key: Integer);
begin

end;

procedure TGame.MouseDown(const Button, x, y: Integer);
  var i, j: Integer;
begin
  g2.Log.WriteLn('Mouse Down');
  Scene.QueryPoint(Display.CoordToDisplay(G2Vec2(x, y)), PickList);
  case Button of
    G2MB_Left:
    begin
      for i := 0 to PickList.Count - 1 do
      begin
        for j := 0 to High(Players) do
        if Players[j] = PickList[i] then
        begin
          if (j >= Team * 4) and (j < (Team + 1) * 4) then
          SelectPlayer := j;
          Break;
        end;
        if SelectPlayer > -1 then Break;
      end;
    end;
  end;
end;

procedure TGame.MouseUp(const Button, x, y: Integer);
  var l: TG2Float;
  var mc, v: TG2Vec2;
  var rb: TG2Scene2DComponentRigidBody;
begin
  g2.Log.WriteLn('Mouse Up');
  case Button of
    G2MB_Left:
    begin
      if SelectPlayer > -1 then
      begin
        mc := Display.CoordToDisplay(g2.MousePos);
        v := mc - Players[SelectPlayer].Transform.p;
        l := v.Len;
        if l > 0.5 then
        begin
          if l > 2 then v := v.Norm * 2;
          rb := TG2Scene2DComponentRigidBody(Players[SelectPlayer].ComponentOfType[TG2Scene2DComponentRigidBody]);
          if Assigned(rb) then
          begin
            rb.PhysBody^.apply_force_to_center(v * 70, True);
            Team := (Team + 1) mod 2;
            UpdateTeamMarker;
          end;
        end;
      end;
      SelectPlayer := -1;
    end
  end;
end;

procedure TGame.Scroll(const y: Integer);
begin

end;

procedure TGame.Print(const c: AnsiChar);
begin

end;

procedure TGame.OnPushBallUpBegin(const EventData: TG2Scene2DEventData);
  var Data: TG2Scene2DEventBeginContactData absolute EventData;
begin
  if Assigned(Data.Shapes[1]) and (Data.Shapes[1].Owner.Name = 'Ball') then
  begin
    PushBallUp := True;
  end;
end;

procedure TGame.OnPushBallUpEnd(const EventData: TG2Scene2DEventData);
  var Data: TG2Scene2DEventEndContactData absolute EventData;
begin
  if Assigned(Data.Shapes[1]) and (Data.Shapes[1].Owner.Name = 'Ball') then
  begin
    PushBallUp := False;
  end;
end;

procedure TGame.OnPushBallRightBegin(const EventData: TG2Scene2DEventData);
  var Data: TG2Scene2DEventBeginContactData absolute EventData;
begin
  if Assigned(Data.Shapes[1]) and (Data.Shapes[1].Owner.Name = 'Ball') then
  begin
    PushBallRight := True;
  end;
end;

procedure TGame.OnPushBallRightEnd(const EventData: TG2Scene2DEventData);
  var Data: TG2Scene2DEventEndContactData absolute EventData;
begin
  if Assigned(Data.Shapes[1]) and (Data.Shapes[1].Owner.Name = 'Ball') then
  begin
    PushBallRight := False;
  end;
end;

procedure TGame.OnPushBallLeftBegin(const EventData: TG2Scene2DEventData);
  var Data: TG2Scene2DEventBeginContactData absolute EventData;
begin
  if Assigned(Data.Shapes[1]) and (Data.Shapes[1].Owner.Name = 'Ball') then
  begin
    PushBallLeft := True;
  end;
end;

procedure TGame.OnPushBallLeftEnd(const EventData: TG2Scene2DEventData);
  var Data: TG2Scene2DEventEndContactData absolute EventData;
begin
  if Assigned(Data.Shapes[1]) and (Data.Shapes[1].Owner.Name = 'Ball') then
  begin
    PushBallLeft := False;
  end;
end;

procedure TGame.OnPushBallDownBegin(const EventData: TG2Scene2DEventData);
  var Data: TG2Scene2DEventBeginContactData absolute EventData;
begin
  if Assigned(Data.Shapes[1]) and (Data.Shapes[1].Owner.Name = 'Ball') then
  begin
    PushBallDown := True;
  end;
end;

procedure TGame.OnPushBallDownEnd(const EventData: TG2Scene2DEventData);
  var Data: TG2Scene2DEventEndContactData absolute EventData;
begin
  if Assigned(Data.Shapes[1]) and (Data.Shapes[1].Owner.Name = 'Ball') then
  begin
    PushBallDown := False;
  end;
end;

procedure TGame.OnGoalLeft(const EventData: TG2Scene2DEventData);
  var Data: TG2Scene2DEventBeginContactData absolute EventData;
begin
  if State <> gs_game then Exit;
  if Assigned(Data.Shapes[1]) and (Data.Shapes[1].Owner.Name = 'Ball') then
  begin
    Inc(Score[1]);
    OnGoal;
  end;
end;

procedure TGame.OnGoalRight(const EventData: TG2Scene2DEventData);
  var Data: TG2Scene2DEventBeginContactData absolute EventData;
begin
  if State <> gs_game then Exit;
  if Assigned(Data.Shapes[1]) and (Data.Shapes[1].Owner.Name = 'Ball') then
  begin
    Inc(Score[0]);
    OnGoal;
  end;
end;

procedure TGame.OnGoal;
  var e: TG2Scene2DEntity;
  var c: TG2Scene2DComponentText;
begin
  e := Scene.FindEntityByName('Score');
  if Assigned(e) then
  begin
    c := TG2Scene2DComponentText(e.ComponentOfType[TG2Scene2DComponentText]);
    if Assigned(c) then
    begin
      c.Text := IntToStr(Score[0]) + ':' + IntToStr(Score[1]);
    end;
  end;
  e := Scene.FindEntityByName('Goal');
  if Assigned(e) then
  begin
    c := TG2Scene2DComponentText(e.ComponentOfType[TG2Scene2DComponentText]);
    if Assigned(c) then
    begin
      c.Visible := True;
    end;
  end;
  State := gs_goal;
  g2.CustomTimer(@ResetGoalTimer, 3000);
end;

procedure TGame.UpdateTeamMarker;
  var xf: TG2Transform2;
begin
  xf := TeamMarker.Transform;
  xf.p.x := Team * 2 - 1;
  TeamMarker.Transform := xf;
end;

function TGame.ResetGoalTimer(const Interval: Integer): Integer;
  var e: TG2Scene2DEntity;
  var c: TG2Scene2DComponentText;
  var i: Integer;
begin
  e := Scene.FindEntityByName('Goal');
  if Assigned(e) then
  begin
    c := TG2Scene2DComponentText(e.ComponentOfType[TG2Scene2DComponentText]);
    if Assigned(c) then
    begin
      c.Visible := False;
    end;
  end;
  Scene.DisablePhysics;
  Ball.Transform := ResetBall;
  for i := 0 to High(Players) do
  Players[i].Transform := ResetPlayers[i];
  Scene.EnablePhysics;
  Team := Random(2);
  UpdateTeamMarker;
  State := gs_game;
  Result := 0;
end;

//TGame END

end.
