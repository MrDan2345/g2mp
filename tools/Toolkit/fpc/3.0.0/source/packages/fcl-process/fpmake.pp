{$ifndef ALLPACKAGES}
{$mode objfpc}{$H+}
program fpmake;

uses fpmkunit;

Var
  T : TTarget;
  P : TPackage;
begin
  With Installer do
    begin
{$endif ALLPACKAGES}

    P:=AddPackage('fcl-process');
    P.ShortName:='fclp';
{$ifdef ALLPACKAGES}
    P.Directory:=ADirectory;
{$endif ALLPACKAGES}
    P.Version:='3.0.0rc2';
    P.Author := 'Michael van Canneyt and Free Pascal Development team';
    P.License := 'LGPL with modification';
    P.HomepageURL := 'www.freepascal.org';
    P.Email := '';
    P.Description := 'Process (execution) related parts of Free Component Libraries (FCL), FPC''s OOP library.';
    P.Options.Add('-S2h');
    P.NeedLibC:= false;
    P.OSes:=AllOSes-[embedded,msdos];

    P.SourcePath.Add('src');
    P.IncludePath.Add('src/unix',AllUnixOSes);
    P.IncludePath.Add('src/win',[win32,win64]);
    P.IncludePath.Add('src/amicommon',AllAmigaLikeOSes);
    P.IncludePath.Add('src/$(OS)',AllOSes-[win32,win64]-AllUnixOSes-AllAmigaLikeOSes);
    P.IncludePath.Add('src/dummy',AllOSes-[win32,win64]-AllUnixOSes-AllAmigaLikeOSes);
    
    P.Dependencies.add('morphunits',[morphos]);
    P.Dependencies.add('arosunits',[aros]);
    P.Dependencies.add('amunits',[amiga]);

    T:=P.Targets.AddUnit('pipes.pp');
      T.Dependencies.AddInclude('pipes.inc');
    T:=P.Targets.AddUnit('process.pp');
      T.Dependencies.AddInclude('process.inc');
    T.ResourceStrings:=True;
    T:=P.Targets.AddUnit('simpleipc.pp');
      T.Dependencies.AddInclude('simpleipc.inc');
      T.ResourceStrings:=True;
    T:=P.Targets.AddUnit('pipesipc.pp',AllUnixOSes);
      T.Dependencies.AddInclude('simpleipc.inc');
      T.ResourceStrings:=True;
    T:=P.Targets.AddUnit('dbugmsg.pp');
      T.ResourceStrings:=True;
    T:=P.Targets.AddUnit('dbugintf.pp');
      T.ResourceStrings:=True;

{$ifndef ALLPACKAGES}
    Run;
    end;
end.
{$endif ALLPACKAGES}
