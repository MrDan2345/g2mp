unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  G2Utils,
  G2DataManager,
  box2d,
  Types,
  SysUtils,
  Classes;

type
  t_draw = class (tb2_draw)
  public
    procedure draw_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color); override;
    procedure draw_solid_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color); override;
    procedure draw_circle(const center: tb2_vec2; const radius: tb2_float32; const color: tb2_color); override;
    procedure draw_solid_circle(const center: tb2_vec2; const radius: tb2_float32; const axis: tb2_vec2; const color: tb2_color); override;
    procedure draw_segment(const p0, p1: tb2_vec2; const color: tb2_color); override;
    procedure draw_transform(const xf: tb2_transform); override;
  end;

  TGame = class
  protected
    var font: TG2Font;
    var draw: t_draw;
    var gravity, position: tb2_vec2;
    var world: tb2_world;
    var ground_body_def, body_def: tb2_body_def;
    var ground_body, body: pb2_body;
    var ground_box, box: tb2_polygon_shape;
    var fixture_def: tb2_fixture_def;
    var time_step, angle: tb2_float32;
    var boxes: array[0..399] of pb2_body;
    var velocity_iterations, position_iterations: tb2_int32;
  public
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
  disp: TG2Display2D;

implementation

procedure t_draw.draw_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color);
  var i, i1: integer;
  var c: TG2Color;
  var v: pb2_vec2_arr absolute vertices;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $ff));
  for i := 0 to vertex_count - 1 do
  begin
    i1 := (i + 1) mod vertex_count;
    disp.PrimLine(v^[i].x, v^[i].y, v^[i1].x, v^[i1].y, c);
  end;
end;

procedure t_draw.draw_solid_polygon(const vertices: pb2_vec2; const vertex_count: tb2_int32; const color: tb2_color);
  var i, i1, i2: integer;
  var c: TG2Color;
  var v: pb2_vec2_arr absolute vertices;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $ff));
  for i := 0 to vertex_count - 2 do
  begin
    i1 := (i + 1) mod vertex_count;
    i2 := (i + 2) mod vertex_count;
    disp.PrimTriCol(
      v^[i].x, v^[i].y,
      v^[i1].x, v^[i1].y,
      v^[i2].x, v^[i2].y,
      c, c, c
    );
  end;
end;

procedure t_draw.draw_circle(const center: tb2_vec2; const radius: tb2_float32; const color: tb2_color);
  var c: TG2Color;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $ff));
  disp.PrimCircleHollow(center.x, center.y, radius, c);
end;

procedure t_draw.draw_solid_circle(const center: tb2_vec2; const radius: tb2_float32; const axis: tb2_vec2; const color: tb2_color);
  var c: TG2Color;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $ff));
  disp.PrimCircleCol(center.x, center.y, radius, c, c);
  disp.PrimLine(center.x, center.y, center.x + axis.x * radius, center.y + axis.y * radius, $ff000000);
end;

procedure t_draw.draw_segment(const p0, p1: tb2_vec2; const color: tb2_color);
  var c: TG2Color;
begin
  c := G2Color(round(color.r * $ff), round(color.g * $ff), round(color.b * $ff), round(color.a * $ff));
  disp.PrimLine(p0.x, p0.y, p1.x, p1.y, c);
end;

procedure t_draw.draw_transform(const xf: tb2_transform);
begin

end;

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
  g2.Params.ScreenMode := smMaximized;
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
  var i: Integer;
begin
  Font := TG2Font.Create;
  Font.Make(32);
  gravity.set_value(0, 10);
  world.create(gravity);
  world.set_continuous_physics(false);
  ground_body_def := b2_body_def;
  ground_body_def.position.set_value(0, 10);
  ground_body := world.create_body(ground_body_def);
  ground_box.create;
  ground_box.set_as_box(100, 10);
  ground_body^.create_fixture(@ground_box, 0);
  body_def := b2_body_def;
  body_def.&type := b2_dynamic_body;
  box.create;
  box.set_as_box(1, 1);
  fixture_def := b2_fixture_def;
  fixture_def.shape := @box;
  fixture_def.density := 1;
  fixture_def.friction := 0.3;
  for i := 0 to High(boxes) do
  begin
    body_def.position := b2_vec2(Random(301) * 0.1 - 15, -Random(301) * 0.1 - 5);
    body_def.angle := G2Random2Pi;
    boxes[i] := world.create_body(body_def);
    boxes[i]^.create_fixture(fixture_def);
  end;
  time_step := 1 / g2.Params.TargetUPS;
  velocity_iterations := 6;
  position_iterations := 2;
  draw := t_draw.create;
  draw.set_flags(longint(e_df_shape_bit) or longint(e_df_joint_bit) {or longint(e_df_aabb_bit) or longint(e_df_pair_bit)} or longint(e_df_center_of_mass_bit));
  world.set_debug_draw(draw);
  disp := TG2Display2D.Create;
  disp.Position := G2Vec2(0, 0);
  disp.Zoom := 7;
end;

procedure TGame.Finalize;
begin
  draw.free;
  world.destroy;
  Font.Free;
end;

procedure TGame.Update;
begin
  world.step(time_step, velocity_iterations, position_iterations);
end;

procedure TGame.Render;
begin
  world.draw_debug_data;
  g2.Window.Caption := inttostr(world.get_stack_allocator^.get_max_allocation);
end;

procedure TGame.KeyDown(const Key: Integer);
  var i: integer;
begin
  if Key = G2K_Space then
  begin
    for i := 0 to High(boxes) do
    begin
      boxes[i]^.set_transform(b2_vec2(Random(301) * 0.1 - 15, -Random(301) * 0.1 - 5), G2Random2Pi);
      boxes[i]^.set_awake(true);
    end;
  end;
  if Key = G2K_S then
  world.step(time_step, velocity_iterations, position_iterations);
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
  if y > 0 then
  disp.Zoom := disp.Zoom / 1.1
  else
  disp.Zoom := disp.Zoom * 1.1;
end;

procedure TGame.Print(const c: AnsiChar);
begin

end;
//TGame END

end.
