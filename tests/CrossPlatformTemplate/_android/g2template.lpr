library g2template;

uses
  Gen2MP,
  G2Types,
  G2AndroidJNI,
  G2App;

procedure Main;
begin
  g2.CallbackInitializeAdd(@App.Initialize);
  g2.CallbackFinalizeAdd(@App.Finalize);
  g2.CallbackUpdateAdd(@App.Update);
  g2.CallbackRenderAdd(@App.Render);
  g2.CallbackMouseDownAdd(@App.MouseDown);
  g2.CallbackMouseUpAdd(@App.MouseUp);
  g2.Start;
end;

procedure Java_com_example_g2template_g2template_MessageJNI(Env: PJNIEnv; Obj: JObject; MessageType, Param0, Param1, Param2: Integer);
begin
  TG2Core.AndroidMessage(Env, Obj, MessageType, Param0, Param1, Param2);
  if MessageType = 1 then Main;
end;

exports Java_com_example_g2template_g2template_MessageJNI;

end.
