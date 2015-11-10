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

    P:=AddPackage('fcl-web');
    P.ShortName:='fclw';
{$ifdef ALLPACKAGES}
    P.Directory:=ADirectory;
{$endif ALLPACKAGES}
    P.Version:='3.0.0rc2';
    P.OSes := [beos,haiku,freebsd,darwin,iphonesim,solaris,netbsd,openbsd,linux,win32,win64,wince,aix,amiga,aros,morphos,dragonfly];
    P.Dependencies.Add('fcl-base');
    P.Dependencies.Add('fcl-db');
    P.Dependencies.Add('fcl-xml');
    P.Dependencies.Add('fcl-json');
    P.Dependencies.Add('fcl-net');
    P.Dependencies.Add('fcl-process');
    P.Dependencies.Add('fastcgi');
    P.Dependencies.Add('httpd22', AllOses - [amiga,aros,morphos]);
    P.Dependencies.Add('httpd24', AllOses - [amiga,aros,morphos]);
    // (Temporary) indirect dependencies, not detected by fpcmake:
    P.Dependencies.Add('univint',[MacOSX,iphonesim]);

    P.Author := 'FreePascal development team';
    P.License := 'LGPL with modification, ';
    P.HomepageURL := 'www.freepascal.org';
    P.Email := '';
    P.Description := 'Web(app) related parts of Free Component Libraries (FCL), FPC''s OOP library.';
    P.NeedLibC:= false;

    P.SourcePath.Add('src/base');
    P.SourcePath.Add('src/webdata');
    P.SourcePath.Add('src/jsonrpc');

    T:=P.Targets.AddUnit('cgiapp.pp');
    T.ResourceStrings:=true;
    T:=P.Targets.AddUnit('custcgi.pp');
    T.ResourceStrings:=true;
      with T.Dependencies do
        begin
          AddUnit('httpprotocol');
          AddUnit('cgiprotocol');
          AddUnit('httpdefs');
        end;
    T:=P.Targets.AddUnit('ezcgi.pp');
    T:=P.Targets.AddUnit('fpcgi.pp');
      with T.Dependencies do
        begin
          AddUnit('httpdefs');
          AddUnit('fphttp');
        end;
    T:=P.Targets.AddUnit('fpdatasetform.pp');
      with T.Dependencies do
        begin
          AddUnit('fphtml');
        end;
    T:=P.Targets.AddUnit('fphtml.pp');
    T.ResourceStrings:=true;
      with T.Dependencies do
        begin
          AddUnit('httpdefs');
          AddUnit('fphttp');
        end;
    T:=P.Targets.AddUnit('fphttp.pp');
    T.ResourceStrings:=true;
      with T.Dependencies do
        begin
          AddUnit('httpdefs');
        end;
    T:=P.Targets.AddUnit('fpweb.pp');
    T.ResourceStrings:=true;
      with T.Dependencies do
        begin
          AddUnit('httpdefs');
          AddUnit('fphttp');
          AddUnit('websession');
        end;
    T:=P.Targets.AddUnit('httpprotocol.pp');
    T:=P.Targets.AddUnit('cgiprotocol.pp');

    T:=P.Targets.AddUnit('httpdefs.pp');
    T.Dependencies.AddUnit('httpprotocol');
    
    T.ResourceStrings:=true;
    T:=P.Targets.AddUnit('iniwebsession.pp');
    T.ResourceStrings:=true;
      with T.Dependencies do
        begin
          AddUnit('fphttp');
          AddUnit('httpdefs');
        end;
    T:=P.Targets.AddUnit('websession.pp');
      with T.Dependencies do
        begin
          AddUnit('iniwebsession');
        end;
    T:=P.Targets.AddUnit('webutil.pp');
      with T.Dependencies do
        begin
          AddUnit('httpdefs');
        end;
    with P.Targets.AddUnit('custweb.pp') do
      begin
        ResourceStrings:=true;
        Dependencies.AddUnit('httpdefs');
        Dependencies.AddUnit('fphttp');
      end;
    with P.Targets.AddUnit('webpage.pp') do
      begin
        Dependencies.AddUnit('httpdefs');
        Dependencies.AddUnit('fphtml');
        Dependencies.AddUnit('fpweb');
      end;
    with P.Targets.AddUnit('fpfcgi.pp') do
      begin
        OSes:=AllOses-[wince,darwin,iphonesim,aix,amiga,aros,morphos];
        Dependencies.AddUnit('custfcgi');
      end;
    with P.Targets.AddUnit('custfcgi.pp') do
      begin
        OSes:=AllOses-[wince,darwin,iphonesim,aix,amiga,aros,morphos];
        Dependencies.AddUnit('httpprotocol');
        Dependencies.AddUnit('cgiprotocol');
        Dependencies.AddUnit('custcgi');
        Dependencies.AddUnit('httpdefs');
        Dependencies.AddUnit('custweb');
        ResourceStrings:=true;
      end;
    with P.Targets.AddUnit('fpapache.pp') do
      begin
        OSes:=AllOses-[amiga,aros,morphos];
        Dependencies.AddUnit('httpprotocol');
        Dependencies.AddUnit('fphttp');
        Dependencies.AddUnit('custweb');
        ResourceStrings:=true;
      end;
    with P.Targets.AddUnit('fpapache24.pp') do
      begin
        OSes:=AllOses-[amiga,aros,morphos];
        Dependencies.AddUnit('fphttp');
        Dependencies.AddUnit('custweb');
        ResourceStrings:=true;
      end;
    T:=P.Targets.AddUnit('fcgigate.pp');
    T.ResourceStrings:=true;
    With T.Dependencies do
      begin
      AddUnit('httpdefs');
      AddUnit('custcgi');
      end;
    T:=P.Targets.AddUnit('fphttpserver.pp');
    T.ResourceStrings:=true;
      with T.Dependencies do
        begin
          AddUnit('httpdefs');
        end;
    T:=P.Targets.AddUnit('fphttpclient.pp');
    T.ResourceStrings:=true;
    T:=P.Targets.AddUnit('custhttpapp.pp');
    // T.ResourceStrings:=true;
    T:=P.Targets.AddUnit('fphttpapp.pp');
    T:=P.Targets.AddUnit('fpwebfile.pp');
    T.ResourceStrings:=true;
    T:=P.Targets.AddUnit('fpwebdata.pp');
    T.ResourceStrings:=true;
    With T.Dependencies do
      begin
      AddUnit('httpdefs');
      AddUnit('fphttp');
      AddUnit('websession');
      end;
    T:=P.Targets.AddUnit('sqldbwebdata.pp');
    T.ResourceStrings:=true;
    With T.Dependencies do
      begin
      AddUnit('fpwebdata');
      AddUnit('fphttp');
      end;
    T:=P.Targets.AddUnit('fpextjs.pp');
    T.ResourceStrings:=true;
    With T.Dependencies do
      begin
      AddUnit('fpwebdata');
      AddUnit('httpdefs');
      AddUnit('fphttp');
      end;
    T:=P.Targets.AddUnit('extjsxml.pp');
    T.ResourceStrings:=true;
    With T.Dependencies do
      begin
      AddUnit('fpwebdata');
      AddUnit('httpdefs');
      AddUnit('fpextjs');
      end;
    T:=P.Targets.AddUnit('extjsjson.pp');
    T.ResourceStrings:=true;
    With T.Dependencies do
      begin
      AddUnit('fpwebdata');
      AddUnit('httpdefs');
      AddUnit('fpextjs');
      end;
    T:=P.Targets.AddUnit('fpjsonrpc.pp');
    T.ResourceStrings:=true;
    T:=P.Targets.AddUnit('webjsonrpc.pp');
    With T.Dependencies do
      begin
      AddUnit('fpjsonrpc');
      end;
    T:=P.Targets.AddUnit('fpdispextdirect.pp');
    With T.Dependencies do
      begin
      AddUnit('fpjsonrpc');
      end;
    T:=P.Targets.AddUnit('fpextdirect.pp');
    T.ResourceStrings:=true;
    With T.Dependencies do
      begin
      AddUnit('fpdispextdirect');
      AddUnit('webjsonrpc');
      AddUnit('httpdefs');
      end;
    T:=P.Targets.AddUnit('fpwebclient.pp');
    T:=P.Targets.AddUnit('fpjwt.pp');
    T:=P.Targets.AddUnit('fpoauth2.pp');
    T.Dependencies.AddUnit('fpwebclient');
    T.Dependencies.AddUnit('fpjwt');
    T:=P.Targets.AddUnit('fpoauth2ini.pp');
    T.Dependencies.AddUnit('fpoauth2');
    T:=P.Targets.AddUnit('fphttpwebclient.pp');
    T.Dependencies.AddUnit('fpwebclient');
    T:=P.Targets.AddUnit('restbase.pp');
    T:=P.Targets.AddUnit('restcodegen.pp');
{$ifndef ALLPACKAGES}
    Run;
    end;
end.
{$endif ALLPACKAGES}
