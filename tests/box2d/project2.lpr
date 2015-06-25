program project2;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes,
  Gen2MP,
  box2d
  { you can add units after this };

var gravity, position: tb2_vec2;
var world: tb2_world;
var ground_body_def, body_def: tb2_body_def;
var ground_body, body: pb2_body;
var ground_box, box: tb2_polygon_shape;
var fixture_def: tb2_fixture_def;
var time_step, angle: tb2_float32;
var velocity_iterations, position_iterations, i: tb2_int32;

begin
  gravity.set_value(0.0, -10.0);
  world.create(gravity);
  ground_body_def := b2_body_def;
  ground_body_def.position.set_value(0.0, -10.0);
  ground_body := world.create_body(ground_body_def);
  ground_box.create;
  ground_box.set_as_box(50.0, 10.0);
  ground_body^.create_fixture(@ground_box, 0.0);
  body_def := b2_body_def;
  body_def.body_type := b2_dynamic_body;
  body_def.position.set_value(0.0, 4.0);
  body := world.create_body(body_def);
  box.create;
  box.set_as_box(1.0, 1.0);
  fixture_def := b2_fixture_def;
  fixture_def.shape := @box;
  fixture_def.density := 1.0;
  fixture_def.friction := 0.3;
  body^.create_fixture(fixture_def);
  time_step := 1.0 / 60.0;
  velocity_iterations := 6;
  position_iterations := 2;
  for i := 0 to 60 - 1 do
  begin
    world.step(time_step, velocity_iterations, position_iterations);
    position := body^.get_position;
    angle := body^.get_angle;
    writeln(position.x, ' ', position.y, ' ', angle);
  end;
  world.destroy;
  readln;
end.

