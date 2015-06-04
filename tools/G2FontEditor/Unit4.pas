unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls;

type
  TForm4 = class(TForm)
    Bevel1: TBevel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    ColorDialog1: TColorDialog;
    procedure Button1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpinEdit3Change(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  FreezeChange: boolean = false;

implementation

{$R *.dfm}

procedure UpdateColor;
begin
  with Form4 do
  begin
    ColorDialog1.Color := rgb(
      SpinEdit1.Value,
      SpinEdit2.Value,
      SpinEdit3.Value
    );
    Panel1.Color := ColorDialog1.Color;
  end;
end;

procedure TForm4.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm4.FormShow(Sender: TObject);
begin
  FreezeChange := true;
  SpinEdit1.Value := GetRValue(ColorDialog1.Color);
  SpinEdit2.Value := GetGValue(ColorDialog1.Color);
  SpinEdit3.Value := GetBValue(ColorDialog1.Color);
  UpdateColor;
  FreezeChange := false;
end;

procedure TForm4.Panel1Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    FreezeChange := true;
    SpinEdit1.Value := GetRValue(ColorDialog1.Color);
    SpinEdit2.Value := GetGValue(ColorDialog1.Color);
    SpinEdit3.Value := GetBValue(ColorDialog1.Color);
    UpdateColor;
    FreezeChange := false;
  end;
end;

procedure TForm4.SpinEdit1Change(Sender: TObject);
begin
  if not FreezeChange then
  UpdateColor;
end;

procedure TForm4.SpinEdit2Change(Sender: TObject);
begin
  if not FreezeChange then
  UpdateColor;
end;

procedure TForm4.SpinEdit3Change(Sender: TObject);
begin
  if not FreezeChange then
  UpdateColor;
end;

end.
