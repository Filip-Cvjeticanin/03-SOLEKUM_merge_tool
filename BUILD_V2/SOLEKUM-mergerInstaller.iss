; SOLEKUM-merger Installer Script

[Setup]
AppName=SOLEKUM-merger
AppVersion=2.0.0.0
DefaultDirName={autopf}\SOLEKUM-merger
DefaultGroupName=SOLEKUM-merger
OutputBaseFilename=SOLEKUM-merger-Setup-2.0.0.0
Compression=lzma
SolidCompression=yes
UninstallDisplayIcon={app}\SOLEKUM-merger.exe
UninstallDisplayName=SOLEKUM-merger
ArchitecturesInstallIn64BitMode=x64

[Files]
Source: "dist\SOLEKUM-merger\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\SOLEKUM-merger"; Filename: "{app}\SOLEKUM-merger.exe"

[Registry]
; Add install folder to system PATH
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; \
    ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}"; \
    Flags: preservestringtype uninsdeletevalue

[UninstallDelete]
; Remove the app folder if empty
Type: dirifempty; Name: "{app}"
