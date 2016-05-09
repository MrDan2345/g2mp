(* project settings:
  {#include
    source = "$(project_root)source"
  #}
*)
program Scene2DModelComponent;

uses
  Gen2MP,
  GameUnit;

begin
  Game := TGame.Create;
  g2.Start;
end.