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
  Classes;

type
  TGame = class
  protected
  public
    var Display: TG2Display2D;
    var Scene: TG2Scene2D;
    var Tex: TG2Texture2D;
    var Font1: TG2Font;
    var PickList: TG2Scene2DEntityList;
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
  var str: String;
  var dm: TG2DataManager;
begin
  //g2.Log.WriteLn('TGame.Initialize');
  //g2.Log.WriteLn('g2.Gfx = ' + IntToStr(LongWord(g2.Gfx)));
  //Tex := TG2Texture2D.Create;
  //Tex.Load('TestCharA.png', tu2D);
  //Font1 := TG2Font.Create;
  //Font1.Make(32);
  //Scene := TG2Scene2D.Create;
  //Scene.Load('Scene0.g2s2d');
  //Scene.Simulate := True;
  //Scene.EnablePhysics;
  //Display := TG2Display2D.Create;
  //Display.Width := 10;
  //Display.Height := 10;
  //Display.Position := G2Vec2(0, 0);
  //PickList.Clear;
  //AndroidBinding.ResetTitle;
  //SetLength(str, 4);
  //dm := TG2DataManager.Create('test.txt', dmAsset);
  //dm.ReadBuffer(@str[1], 4);
  //AndroidBinding.FAOpen('test.txt', 0);
  //AndroidBinding.FARead(@str[1], 4);
  //AndroidBinding.FClose;
  //dm.Free;
  //g2.Log.WriteLn(str);
end;

procedure TGame.Finalize;
begin
  //Tex.Free;
  //Display.Free;
  //Scene.Free;
  //Font1.Free;
  Free;
end;

procedure TGame.Update;
begin

end;

procedure TGame.Render;
begin
  g2.Clear($ffffc0c0);
  //Scene.Render(Display);
  //g2.PrimRect(
  //  10, 10, 100, 100, $ffff0000
  //);
  ////g2.PicRect(200, 10, $ffffffff, Tex);
  //Font1.Print(20, 20, 1, 1, $ff000000, 'FPS: ' + IntToStr(g2.FPS), bmNormal, tfPoint);
  //Font1.Print(20, 50, 1, 1, $ff000000, IntToStr(g2.Params.Width) + 'x' + IntToStr(g2.Params.Height), bmNormal, tfPoint);
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
