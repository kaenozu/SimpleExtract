; SimpleExtract Installer - Inno Setup 6
#define MyAppName "SimpleExtract"
#define MyAppVersion "1.6.1"
#define MyAppPublisher "SimpleExtract"
#define MyAppURL "https://github.com/simpleextract"
#define MyAppExeName "SimpleExtract.exe"

[Setup]
AppId={{3B9E9B9A-7F1A-4D2B-9E8A-1B2C3D4E5F60}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=dist-installer
OutputBaseFilename=SimpleExtract-Setup-{#MyAppVersion}
SetupIconFile=assets\icon.ico
WizardStyle=modern
WizardSizePercent=120
Compression=lzma2/ultra64
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
CloseApplications=yes
RestartApplications=no
UninstallDisplayIcon={app}\{#MyAppExeName}
VersionInfoVersion={#MyAppVersion}
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription=シンプル解凍ソフト
VersionInfoProductName={#MyAppName}
LicenseFile=

[Languages]
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "associate"; Description: "ZIP/7Z/RARを関連付けする"; GroupDescription: "関連付け:"; Flags: checkedonce
Name: "contextmenu"; Description: "右クリックメニューに追加"; GroupDescription: "関連付け:"; Flags: checkedonce

[Files]
Source: "..\dist\SimpleExtract\SimpleExtract.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\dist\SimpleExtract\_internal\*"; DestDir: "{app}\_internal"; Flags: ignoreversion recursesubdirs createallsubdirs
; assets
Source: "assets\icon.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\icon.ico"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; IconFilename: "{app}\icon.ico"

[Registry]
; 関連付け - タスク選択時のみ
Root: HKCU; Subkey: "Software\Classes\.zip"; ValueType: string; ValueName: ""; ValueData: "SimpleExtract.zip"; Tasks: associate; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Classes\SimpleExtract.zip"; ValueType: string; ValueName: ""; ValueData: "ZIP 圧縮ファイル (SimpleExtract)"; Tasks: associate; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\SimpleExtract.zip\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"; Tasks: associate
Root: HKCU; Subkey: "Software\Classes\SimpleExtract.zip\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Tasks: associate

Root: HKCU; Subkey: "Software\Classes\.7z"; ValueType: string; ValueName: ""; ValueData: "SimpleExtract.7z"; Tasks: associate; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Classes\SimpleExtract.7z"; ValueType: string; ValueName: ""; ValueData: "7-Zip 圧縮ファイル (SimpleExtract)"; Tasks: associate; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\SimpleExtract.7z\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"; Tasks: associate
Root: HKCU; Subkey: "Software\Classes\SimpleExtract.7z\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Tasks: associate

Root: HKCU; Subkey: "Software\Classes\.rar"; ValueType: string; ValueName: ""; ValueData: "SimpleExtract.rar"; Tasks: associate; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Classes\SimpleExtract.rar"; ValueType: string; ValueName: ""; ValueData: "RAR 圧縮ファイル (SimpleExtract)"; Tasks: associate; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\SimpleExtract.rar\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"; Tasks: associate
Root: HKCU; Subkey: "Software\Classes\SimpleExtract.rar\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Tasks: associate

Root: HKCU; Subkey: "Software\Classes\*\shell\SimpleExtract"; ValueType: string; ValueName: ""; ValueData: "SimpleExtractで解凍"; Tasks: contextmenu
Root: HKCU; Subkey: "Software\Classes\*\shell\SimpleExtract"; ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#MyAppExeName}"; Tasks: contextmenu
Root: HKCU; Subkey: "Software\Classes\*\shell\SimpleExtract\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Tasks: contextmenu

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: filesandordirs; Name: "{app}\_internal"

[Code]
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
  begin
    // レジストリ掃除は Inno が Flags: uninsdeletekey でやってくれる
  end;
end;
