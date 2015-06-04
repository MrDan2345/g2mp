(* project settings:
  {#include
    source = "$(project_root)source"
  #}
*)
program TestDisplay2D;

uses
  Gen2MP,
  GameUnit;

begin
  Game := TGame.Create;
  g2.Start;
  Game.Free;
end.