program helloworld;

{$mode objfpc}{$H+}

uses
  fpCGI, webmodule;

{$R *.res}

begin
  Application.Initialize;
  Application.Run;
end.

