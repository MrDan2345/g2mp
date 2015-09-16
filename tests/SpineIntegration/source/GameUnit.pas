unit GameUnit;

interface

uses
  Gen2MP,
  G2Types,
  G2Math,
  Classes,
  Spine,
  G2Spine;

type
  TGame = class
  protected
    Display: TG2Display2D;
    SpineRender: TG2SpineRender;
    Skeleton: TSpineSkeleton;
    State: TSpineAnimationState;
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
  //const CharacterName = 'spineboy';
  const CharacterName = 'raptor';
  var sb: TSpineSkeletonBinary;
  var sd: TSpineSkeletonData;
  var al: TSpineAtlasList;
  var ad: TSpineAnimationStateData;
  var Atlas: TSpineAtlas;
begin
  Display := TG2Display2D.Create;
  SpineDataProvider := TG2SpineDataProvider;
  SpineRender := TG2SpineRender.Create;
  Atlas := TSpineAtlas.Create(CharacterName + '.atlas');
  al := TSpineAtlasList.Create;
  al.Add(Atlas);
  sb := TSpineSkeletonBinary.Create(al);
  sb.Scale := 0.5;
  sd := sb.ReadSkeletonData(CharacterName + '.skel');
  Skeleton := TSpineSkeleton.Create(sd);
  Skeleton.x := 800;
  Skeleton.y := 800;
  Skeleton.ScaleX := 1;
  Skeleton.ScaleY := 1;
  ad := TSpineAnimationStateData.Create(sd);
  ad.SetMix('walk', 'run', 0.2);
  ad.SetMix('run', 'walk', 0.2);
  ad.SetMix('run', 'jump', 0.2);
  ad.SetMix('jump', 'run', 0.2);
  State := TSpineAnimationState.Create(ad);
  State.TimeScale := 1;
  State.SetAnimation(0, 'walk', True);
  //State.SetAnimation(0, 'walk', False);
  //State.AddAnimation(0, 'walk', False, 0);
  //State.AddAnimation(0, 'run', False, 0);
  //State.AddAnimation(0, 'jump', False, 0);
  //State.AddAnimation(0, 'run', False, 0);
  //State.AddAnimation(0, 'run', False, 0);
  //State.AddAnimation(0, 'jump', False, 0);
  //State.AddAnimation(0, 'run', False, 0);
  //State.AddAnimation(0, 'run', False, 0);
  //State.AddAnimation(0, 'jump', False, 0);
  //State.AddAnimation(0, 'run', False, 0);
  //State.AddAnimation(0, 'run', False, 0);
  //State.AddAnimation(0, 'walk', True, 0);
  ad.Free;
  sd.Free;
  sb.Free;
  al.Free;
  Atlas.Free;
end;

procedure TGame.Finalize;
begin
  State.Free;
  Skeleton.Free;
  SpineRender.Free;
  TSpineClass.Report('SpineReport.txt');
  Display.Free;
end;

procedure TGame.Update;
begin
  State.TimeScale := (Sin(G2PiTime()) + 1) * 0.25 + 0.5;
  State.Update(g2.DeltaTimeSec);
  State.Apply(Skeleton);
  Skeleton.UpdateWorldTransform;
end;

procedure TGame.Render;
begin
  g2.Clear($ff80c0c0);
  Skeleton.Draw(SpineRender);
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
