; ---- SOLEKUM-merger Installer (CLI) ----
; Build your EXE first with:
;   pyinstaller --onefile --name SOLEKUM-merger main.py

[Setup]
AppName=SOLEKUM-merger
AppVersion=1.0.0
DefaultDirName={autopf}\SOLEKUM-merger
DefaultGroupName=SOLEKUM-merger
UninstallDisplayIcon={app}\SOLEKUM-merger.exe
OutputDir=.
OutputBaseFilename=SOLEKUM-merger_setup
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin
ChangesEnvironment=yes
ArchitecturesInstallIn64BitMode=x64compatible

[Files]
Source: "ExeBuild\dist\SOLEKUM-merger.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\SOLEKUM-merger"; Filename: "{app}\SOLEKUM-merger.exe"

[Run]
Filename: "{app}\SOLEKUM-merger.exe"; Description: "Run SOLEKUM-merger"; Flags: nowait postinstall skipifsilent

[Code]
procedure AddDirToMachinePath(const Dir: string);
var
  OldPath, NewPath: string;
  SubKey: string;
begin
  SubKey := 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';
  if not RegQueryStringValue(HKLM, SubKey, 'Path', OldPath) then
    OldPath := '';

  if Pos(';' + LowerCase(Dir) + ';', ';' + LowerCase(OldPath) + ';') = 0 then
  begin
    if (OldPath = '') then
      NewPath := Dir
    else if (Copy(OldPath, Length(OldPath), 1) = ';') then
      NewPath := OldPath + Dir
    else
      NewPath := OldPath + ';' + Dir;

    RegWriteExpandStringValue(HKLM, SubKey, 'Path', NewPath);
  end;
end;

procedure RemoveDirFromMachinePath(const Dir: string);
var
  OldPath, NewPath: string;
  SubKey: string;
  P: Integer;
begin
  SubKey := 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';
  if RegQueryStringValue(HKLM, SubKey, 'Path', OldPath) then
  begin
    NewPath := OldPath;
    
    // Remove ;Dir; pattern
    P := Pos(';' + Dir + ';', NewPath);
    if P > 0 then
      Delete(NewPath, P, Length(Dir) + 1);
    
    // Remove Dir; at start
    if Copy(NewPath, 1, Length(Dir) + 1) = Dir + ';' then
      Delete(NewPath, 1, Length(Dir) + 1);
    
    // Remove ;Dir at end
    if Copy(NewPath, Length(NewPath) - Length(Dir), Length(Dir) + 1) = ';' + Dir then
      Delete(NewPath, Length(NewPath) - Length(Dir), Length(Dir) + 1);
    
    // Remove Dir if it's the only entry
    if NewPath = Dir then
      NewPath := '';
    
    RegWriteExpandStringValue(HKLM, SubKey, 'Path', NewPath);
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    AddDirToMachinePath(ExpandConstant('{app}'));
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
    RemoveDirFromMachinePath(ExpandConstant('{app}'));
end;
