unit pkgcommands;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, pkghandler, fpmkunit;

implementation

uses
  zipper,
  pkgmessages,
  pkgglobals,
  pkgoptions,
  pkgdownload,
  pkgrepos,
  fpxmlrep,
  fprepos;

type
  { TCommandAddConfig }

  TCommandAddConfig = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandUpdate }

  TCommandUpdate = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandListPackages }

  TCommandListPackages = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandScanPackages }

  TCommandScanPackages = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandDownload }

  TCommandDownload = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandUnzip }

  TCommandUnzip = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandCompile }

  TCommandCompile = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandBuild }

  TCommandBuild = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandInstall }

  TCommandInstall = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandUnInstall }

  TCommandUnInstall = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandClean }

  TCommandClean = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandArchive }

  TCommandArchive = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandInstallDependencies }

  TCommandInstallDependencies = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandFixBroken }

  TCommandFixBroken = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

  { TCommandListSettings }

  TCommandListSettings = Class(TPackagehandler)
  Public
    Procedure Execute;override;
  end;

var
  DependenciesDepth: integer;

{ TCommandUnInstall }

procedure TCommandUnInstall.Execute;
var
  AvailP: TFPPackage;
  APackage: TFPPackage;
begin
  if PackageName<>'' then
    begin
      if (PackageName=CmdLinePackageName) then
        begin
          ExecuteAction(PackageName,'unzip');
        end
      else if (PackageName<>CurrentDirPackageName) then
        begin
          AvailP:=AvailableRepository.FindPackage(PackageName);
          if not assigned(AvailP) then
            begin
              APackage := InstalledRepository.FindPackage(PackageName);
              if assigned(APackage) and (APackage.SourcePath<>'') then
                begin
                  AvailP := AvailableRepository.AddPackage(PackageName);
                  AvailP.Assign(APackage);
                  // The package won't be recompiled, but should be handled as such.
                  AvailP.RecompileBroken:=true;
                end
              else
                begin
                  // The package is not available locally, download and unzip it.
                  ExecuteAction(PackageName,'unzip');
                end;
            end;
        end;
    end;
  ExecuteAction(PackageName,'fpmakeuninstall');
end;

{ TCommandListSettings }

procedure TCommandListSettings.Execute;
begin
  GlobalOptions.LogValues(llProgres);
  CompilerOptions.LogValues(llProgres,'');
  FPMakeCompilerOptions.LogValues(llProgres,'fpmake-building ');
end;


procedure TCommandAddConfig.Execute;
begin
{
  Log(llInfo,SLogGeneratingCompilerConfig,[S]);
  Options.InitCompilerDefaults(Args[2]);
  Options.SaveCompilerToFile(S);
}
end;


procedure TCommandUpdate.Execute;
var
  PackagesURL :  String;
begin
  // Download and load mirrors.xml
  // This can be skipped when a custom RemoteRepository is configured
  if (GlobalOptions.RemoteMirrorsURL<>'') and
     (GlobalOptions.RemoteRepository='auto') then
    begin
      Log(llCommands,SLogDownloading,[GlobalOptions.RemoteMirrorsURL,GlobalOptions.LocalMirrorsFile]);
      DownloadFile(GlobalOptions.RemoteMirrorsURL,GlobalOptions.LocalMirrorsFile);
      LoadLocalAvailableMirrors;
    end;
  // Download packages.xml
  PackagesURL:=GetRemoteRepositoryURL(PackagesFileName);
  Log(llCommands,SLogDownloading,[PackagesURL,GlobalOptions.LocalPackagesFile]);
  DownloadFile(PackagesURL,GlobalOptions.LocalPackagesFile);
  // Read the repository again
  LoadLocalAvailableRepository;
  // no need to log errors again
  FindInstalledPackages(CompilerOptions,False);
end;


procedure TCommandListPackages.Execute;
begin
  ListPackages(GlobalOptions.ShowLocation);
end;


procedure TCommandScanPackages.Execute;
begin
  { nothing, already handled in fppkg.pp as special case
    before the local fppkg directory is processed }
end;


procedure TCommandDownload.Execute;
var
  P : TFPPackage;
begin
  if PackageName='' then
    Error(SErrNoPackageSpecified);
  P:=AvailableRepository.PackageByName(PackageName);
  if not FileExists(PackageLocalArchive(P)) then
    ExecuteAction(PackageName,'downloadpackage');
end;


procedure TCommandUnzip.Execute;
Var
  BuildDir : string;
  ArchiveFile : String;
  P : TFPPackage;
begin
  if PackageName='' then
    Error(SErrNoPackageSpecified);
  P:=AvailableRepository.PackageByName(PackageName);
  BuildDir:=PackageBuildPath(P);
  ArchiveFile:=PackageLocalArchive(P);
  if not FileExists(ArchiveFile) then
    ExecuteAction(PackageName,'downloadpackage');
  { Create builddir, remove it first if needed }
  if DirectoryExists(BuildDir) then
    DeleteDir(BuildDir);
  ForceDirectories(BuildDir);
  SetCurrentDir(BuildDir);
  { Unzip Archive }
  With TUnZipper.Create do
    try
      Log(llCommands,SLogUnzippping,[ArchiveFile]);
      OutputPath:=PackageBuildPath(P);
      UnZipAllFiles(ArchiveFile);
    Finally
      Free;
    end;
end;


procedure TCommandCompile.Execute;
begin
  if PackageName<>'' then
    begin
      // For local files we need the information inside the zip to get the
      // dependencies
      if (PackageName=CmdLinePackageName) then
        begin
          ExecuteAction(PackageName,'unzip');
          ExecuteAction(PackageName,'installdependencies');
        end
      else
        if (PackageName=CurrentDirPackageName) then
          begin
            ExecuteAction(PackageName,'installdependencies');
          end
      else
        begin
          ExecuteAction(PackageName,'installdependencies');
          ExecuteAction(PackageName,'unzip');
        end;
    end;
  ExecuteAction(PackageName,'fpmakecompile');
end;


procedure TCommandBuild.Execute;
var
  P: TFPPackage;
begin
  if PackageName<>'' then
    begin
      // For local files we need the information inside the zip to get the
      // dependencies
      if (PackageName=CmdLinePackageName) then
        begin
          ExecuteAction(PackageName,'unzip');
          ExecuteAction(PackageName,'installdependencies');
        end
      else
        if (PackageName=CurrentDirPackageName) then
          begin
            ExecuteAction(PackageName,'installdependencies');
          end
      else
        begin
          ExecuteAction(PackageName,'installdependencies');
          // Check if the package is not installed but being recompiled because of changed
          // dependencies while the original source is still available.
          P := AvailableRepository.FindPackage(PackageName);
          if not (assigned(P) and P.RecompileBroken and (P.SourcePath<>'')) then
            // The package is not available locally, download and unzip it.
            ExecuteAction(PackageName,'unzip');
        end;
    end;
  ExecuteAction(PackageName,'fpmakebuild');
end;


procedure TCommandInstall.Execute;

var
  S : String;
  P   : TFPPackage;

  function GetUnitConfigFilename: string;
  begin
    if P.RecompileBroken then
      begin
        // If the package is recompiled, the installation-location is dependent on where
        // the package was installed originally.
        if P.InstalledLocally then
          Result:=CompilerOptions.LocalUnitDir
        else
          Result:=CompilerOptions.GlobalUnitDir;
        // Setting RecompileBroken to false is in a strict sense not needed. But it is better
        // to clean this temporary flag, to avoid problems with changes in the future
        P.RecompileBroken := false;
        AvailableRepository.FindPackage(P.Name).RecompileBroken:=false;
      end
    else
      begin
        if (IsSuperUser or GlobalOptions.InstallGlobal) then
          Result:=CompilerOptions.GlobalUnitDir
        else
          Result:=CompilerOptions.LocalUnitDir;
      end;
    Result:=IncludeTrailingPathDelimiter(Result)+S+PathDelim+UnitConfigFileName;
  end;

  function GetFpmFilename: string;
  begin
    if P.RecompileBroken then
      begin
        // If the package is recompiled, the installation-location is dependent on where
        // the package was installed originally.
        if P.InstalledLocally then
          Result:=CompilerOptions.LocalInstallDir
        else
          Result:=CompilerOptions.GlobalInstallDir;
        // Setting RecompileBroken to false is in a strict sense not needed. But it is better
        // to clean this temporary flag, to avoid problems with changes in the future
        P.RecompileBroken := false;
        AvailableRepository.FindPackage(P.Name).RecompileBroken:=false;
      end
    else
      begin
        if (IsSuperUser or GlobalOptions.InstallGlobal) then
          Result:=CompilerOptions.GlobalInstallDir
        else
          Result:=CompilerOptions.LocalInstallDir;
      end;
    Result:=IncludeTrailingPathDelimiter(Result)+'fpmkinst'+PathDelim+CompilerOptions.CompilerTarget+PathDelim+s+FpmkExt;
  end;


var
  UFN : String;
begin
  if PackageName<>'' then
    begin
      ExecuteAction(PackageName,'build');
      ExecuteAction(PackageName,'fpmakeinstall');
      if (PackageName=CmdLinePackageName) or (PackageName=CurrentDirPackageName) then
        begin
          // Load package name from manifest
          if not FileExists(ManifestFileName) then
            ExecuteAction(PackageName,'fpmakemanifest');
          P:=LoadManifestFromFile(ManifestFileName);
          S:=P.Name;
          FreeAndNil(P);
        end
      else
        S:=PackageName;
      P:=InstalledRepository.FindPackage(S);
      if not assigned(P) then
        P:=InstalledRepository.AddPackage(S);

      UFN:=GetFpmFilename;
      // If there is no fpm-file, search for an (obsolete, pre-2.7.x)
      // fpunits.cfg-file
      if not FileExists(ufn) then
        UFN:=GetUnitConfigFilename;

      P.LoadUnitConfigFromFile(UFN);
      if P.IsFPMakeAddIn then
        AddFPMakeAddIn(P);
    end
  else
    ExecuteAction(PackageName,'fpmakeinstall');
end;


procedure TCommandClean.Execute;
begin
  ExecuteAction(PackageName,'fpmakeclean');
end;


procedure TCommandArchive.Execute;
begin
  ExecuteAction(PackageName,'fpmakearchive');
end;


procedure TCommandInstallDependencies.Execute;
var
  i : Integer;
  MissingDependency,
  D : TFPDependency;
  P,
  InstalledP,
  AvailP : TFPPackage;
  PackNr: integer;
  ManifestPackages : TFPPackages;
  X : TFPXMLRepositoryHandler;
  L : TStringList;
  status : string;
begin
  if PackageName='' then
    Error(SErrNoPackageSpecified);
  ManifestPackages:=nil;
  // Load dependencies for local packages
  if (PackageName=CmdLinePackageName) or (PackageName=CurrentDirPackageName) then
    begin
      ExecuteAction(PackageName,'fpmakemanifest');
      ManifestPackages:=TFPPackages.Create(TFPPackage);
      X:=TFPXMLRepositoryHandler.Create;
      try
        X.LoadFromXml(ManifestPackages,ManifestFileName);
      finally
        X.Free;
      end;
      if ManifestPackages.Count>0 then
        begin
          PackNr:=0;
          P := ManifestPackages[PackNr];
        end
      else
        begin
          ManifestPackages.Free;
          Error(SErrManifestNoSinglePackage,[ManifestFileName]);
        end;
    end
  else
    P:=AvailableRepository.PackageByName(PackageName);

  MissingDependency:=nil;
  while assigned(P) do
    begin
      // Find and List dependencies
      L:=TStringList.Create;
      for i:=0 to P.Dependencies.Count-1 do
        begin
          D:=P.Dependencies[i];
          if not ((CompilerOptions.CompilerOS in D.OSes) and (CompilerOptions.CompilerCPU in D.CPUs)) then
            Log(llDebug,SDbgPackageDependencyOtherTarget,[D.PackageName,MakeTargetString(CompilerOptions.CompilerCPU,CompilerOptions.CompilerOS)])
          // Skip dependencies that are available within the fpmake-file itself
          else if not (assigned(ManifestPackages) and assigned(ManifestPackages.FindPackage(D.PackageName))) then
            begin
              InstalledP:=InstalledRepository.FindPackage(D.PackageName);
              // Need installation?
              if not assigned(InstalledP) or
                 (InstalledP.Version.CompareVersion(D.MinVersion)<0) then
                begin
                  AvailP:=AvailableRepository.FindPackage(D.PackageName);
                  if not assigned(AvailP) or
                     (AvailP.Version.CompareVersion(D.MinVersion)<0) then
                    begin
                      status:='Not Available!';
                      MissingDependency:=D;
                    end
                  else
                    begin
                      status:='Updating';
                      L.Add(D.PackageName);
                    end;
                end
              else
                begin
                  if PackageIsBroken(InstalledP, True) then
                    begin
                      status:='Broken, recompiling';
                      L.Add(D.PackageName);
                    end
                  else
                    status:='OK';
                end;
              Log(llInfo,SLogPackageDependency,
                  [D.PackageName,D.MinVersion.AsString,PackageInstalledVersionStr(D.PackageName),
                   PackageAvailableVersionStr(D.PackageName),status])
            end
        end;
      if assigned(ManifestPackages) and (PackNr<ManifestPackages.Count-1)  then
        begin
          inc(PackNr);
          P := ManifestPackages[PackNr]
        end
      else
        p := nil;
    end;
  // Give error on first missing dependency
  if assigned(MissingDependency) then
    Error(SErrNoPackageAvailable,[MissingDependency.PackageName,MissingDependency.MinVersion.AsString]);
  // Install needed updates
  if L.Count > 0 then
    begin
      if DependenciesDepth=0 then
        pkgglobals.Log(llProgres,SProgrInstallDependencies);
      inc(DependenciesDepth);

      for i:=0 to L.Count-1 do
        ExecuteAction(L[i],'install');

      dec(DependenciesDepth);
      if DependenciesDepth=0 then
        pkgglobals.Log(llProgres,SProgrDependenciesInstalled);
    end;
  FreeAndNil(L);
  if assigned(ManifestPackages) then
    ManifestPackages.Free;
end;


procedure TCommandFixBroken.Execute;
var
  i : integer;
  SL : TStringList;
begin
  SL:=TStringList.Create;
  repeat
    FindBrokenPackages(SL);
    if SL.Count=0 then
      break;
    pkgglobals.Log(llProgres,SProgrReinstallDependent);
    for i:=0 to SL.Count-1 do
      begin
        ExecuteAction(SL[i],'build');
        ExecuteAction(SL[i],'install');
      end;
  until false;
  FreeAndNil(SL);
end;


initialization
  DependenciesDepth:=0;
  RegisterPkgHandler('update',TCommandUpdate);
  RegisterPkgHandler('list',TCommandListPackages);
  RegisterPkgHandler('scan',TCommandScanPackages);
  RegisterPkgHandler('download',TCommandDownload);
  RegisterPkgHandler('unzip',TCommandUnzip);
  RegisterPkgHandler('compile',TCommandCompile);
  RegisterPkgHandler('build',TCommandBuild);
  RegisterPkgHandler('install',TCommandInstall);
  RegisterPkgHandler('uninstall',TCommandUnInstall);
  RegisterPkgHandler('clean',TCommandClean);
  RegisterPkgHandler('archive',TCommandArchive);
  RegisterPkgHandler('installdependencies',TCommandInstallDependencies);
  RegisterPkgHandler('fixbroken',TCommandFixBroken);
  RegisterPkgHandler('listsettings',TCommandListSettings);
end.
