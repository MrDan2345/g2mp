unit G2App;

interface

uses
  Gen2MP,
  G2Utils,
  G2Types;

type
  TG2App = object
    Font1: TG2Font;
    procedure Initialize;
    procedure Finalize;
    procedure Update;
    procedure Render;
    procedure KeyDown(const Key: Integer);
    procedure KeyUp(const Key: Integer);
    procedure MouseDown(const Button, x, y: Integer);
    procedure MouseUp(const Button, x, y: Integer);
  end;

var App: TG2App;
var gs: Single;

implementation

//TG2App BEGIN
procedure TG2App.Initialize;
  var ws, hs: Single;
begin
  g2.Window.Caption := 'template v1.0';
  ws := g2.Params.Width / 1024;
  hs := g2.Params.Height / 768;
  if ws < hs then gs := ws else gs := hs;
  Font1 := TG2Font.Create;
  Font1.Load('Font.g2f');
end;

procedure TG2App.Finalize;
begin
  Font1.Free;
end;

procedure TG2App.Update;
begin

end;

procedure TG2App.Render;
  var Text: AnsiString;
begin
  Text := 'Cross platform template';
  Font1.Print(
    (g2.Params.Width - Font1.TextWidth(Text) * 2 * gs) * 0.5,
    (g2.Params.Height - Font1.TextHeight(Text) * 2 * gs) * 0.5,
     2 * gs, 2 * gs, Text
  );
end;

procedure TG2App.KeyDown(const Key: Integer);
begin

end;

procedure TG2App.KeyUp(const Key: Integer);
begin

end;

procedure TG2App.MouseDown(const Button, x, y: Integer);
begin

end;

procedure TG2App.MouseUp(const Button, x, y: Integer);
begin

end;
//TG2App END

end.
