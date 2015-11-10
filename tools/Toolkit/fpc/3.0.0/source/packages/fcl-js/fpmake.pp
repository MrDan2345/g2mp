{$ifndef ALLPACKAGES}
{$mode objfpc}{$H+}
program fpmake;

uses fpmkunit;

Var
  P : TPackage;
  T : TTarget;
begin
  With Installer do
    begin
{$endif ALLPACKAGES}

    P:=AddPackage('fcl-js');
    P.ShortName:='fcjs';
{$ifdef ALLPACKAGES}
    P.Directory:=ADirectory;
{$endif ALLPACKAGES}
    P.Version:='3.0.0rc2';
    P.Author := 'Michael Van Canneyt';
    P.License := 'LGPL with FPC modification';
    P.HomepageURL := 'www.freepascal.org';
    P.Email := 'michael@freepascal.org';
    P.Description := 'Javascript scanner/parser/syntax tree units';
    P.OSes:=AllOSes-[embedded,msdos];

    P.SourcePath.Add('src');
    P.IncludePath.Add('src');

    T:=P.Targets.AddUnit('jsbase.pp');
    T:=P.Targets.AddUnit('jstoken.pp');
    T:=P.Targets.AddUnit('jstree.pp');
    T:=P.Targets.AddUnit('jsscanner.pp');
      T.ResourceStrings:=true;
    T:=P.Targets.AddUnit('jsparser.pp');
      T.ResourceStrings:=true;
    T:=P.Targets.AddUnit('jswriter.pp');
      T.ResourceStrings:=true;
{$ifndef ALLPACKAGES}
    Run;
    end;
end.
{$endif ALLPACKAGES}
