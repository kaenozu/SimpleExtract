# コード署名ガイド

## 概要
Windows SmartScreen は未署名の EXE/インストーラーを「不明な発行元」としてブロックします。
署名することで発行者が表示され、信頼性が向上します。

## 自己署名（開発・社内配布用）
無料で即時利用可能。ただし初回は SmartScreen が完全には消えません。

```powershell
# 証明書作成（初回のみ）
.\scripts\sign.ps1 -CreateCert

# 署名
.\scripts\sign.ps1 -Sign "dist\SimpleExtract\SimpleExtract.exe"
.\scripts\sign.ps1 -Sign "dist-installer\SimpleExtract-Setup-1.4.0.exe"
```

証明書は `Cert:\CurrentUser\My` に保存されます。有効期限5年。

### ローカルで信頼させる（任意）
```powershell
$cert = Get-ChildItem Cert:\CurrentUser\My | Where Subject -eq "CN=SimpleExtract Self-Signed"
# 信頼された発行元とルートに追加
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root","CurrentUser")
$store.Open("ReadWrite"); $store.Add($cert); $store.Close()
```

## 本番用 OV/EV 証明書（推奨）
Microsoft 推奨の署名で SmartScreen が即時に消えます。

### 購入先
- DigiCert, Sectigo, GlobalSign, etc. で「OV Code Signing」または「EV Code Signing」

### 署名方法
PFXファイルを取得後:

```powershell
.\scripts\sign.ps1 -Sign "app.exe" -CertPath "C:\certs\mycert.pfx" -CertPassword "yourpass"
```

### Inno Setup での自動署名
`installer.iss` に以下を追加:

```iss
[Setup]
SignTool=signtool $p
```

`signtool` は Windows SDK の `signtool.exe` を PATH に追加してください。

## 価格目安
- OV: 年間 ¥15,000〜¥30,000
- EV: 年間 ¥40,000〜¥80,000（USBトークン付属）
