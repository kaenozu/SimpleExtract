# SimpleExtract Code Signing Script (ASCII)
param(
    [string]$Sign,
    [string]$CertPath,
    [string]$CertPassword,
    [switch]$CreateCert,
    [string]$CertName = "SimpleExtract Self-Signed"
)
$ErrorActionPreference = "Stop"
function Create-SelfSignedCert {
    Write-Host "Creating self-signed certificate..." -ForegroundColor Cyan
    $existing = Get-ChildItem Cert:\CurrentUser\My | Where-Object { $_.Subject -eq "CN=$CertName" } | Select-Object -First 1
    if ($existing) {
        Write-Host "Existing cert found: $($existing.Thumbprint)" -ForegroundColor Yellow
        return $existing
    }
    $cert = New-SelfSignedCertificate -Subject "CN=$CertName" -FriendlyName $CertName -CertStoreLocation "Cert:\CurrentUser\My" -KeyUsage DigitalSignature -Type CodeSigningCert -NotAfter (Get-Date).AddYears(5) -KeyAlgorithm RSA -KeyLength 2048 -HashAlgorithm SHA256
    Write-Host "Cert created: $($cert.Thumbprint)" -ForegroundColor Green
    Write-Host "Note: Self-signed cert still triggers SmartScreen on first run. For production, buy OV/EV cert." -ForegroundColor Yellow
    return $cert
}
function Sign-File {
    param([string]$FilePath, $Cert)
    if (-not (Test-Path $FilePath)) { Write-Error "File not found: $FilePath"; return }
    $FilePath = Resolve-Path $FilePath
    Write-Host "Signing: $FilePath" -ForegroundColor Cyan
    $result = Set-AuthenticodeSignature -FilePath $FilePath -Certificate $Cert -HashAlgorithm SHA256 -TimestampServer "http://timestamp.digicert.com"
    if ($result.Status -eq "Valid") { Write-Host "Sign OK: $($result.Status)" -ForegroundColor Green }
    else { Write-Host "Sign failed: $($result.Status) $($result.StatusMessage)" -ForegroundColor Red }
    $verify = Get-AuthenticodeSignature -FilePath $FilePath
    Write-Host "Verify: $($verify.Status)" -ForegroundColor Green
}
if ($CreateCert) { Create-SelfSignedCert; exit 0 }
if ($Sign) {
    $cert = $null
    if ($CertPath) {
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertPath, $CertPassword, 1)
        $store = New-Object System.Security.Cryptography.X509Certificates.X509Store("My","CurrentUser")
        $store.Open(1); $store.Add($cert); $store.Close()
    } else {
        $cert = Get-ChildItem Cert:\CurrentUser\My | Where-Object { $_.Subject -eq "CN=$CertName" } | Select-Object -First 1
        if (-not $cert) { $cert = Create-SelfSignedCert }
    }
    Sign-File -FilePath $Sign -Cert $cert
    exit 0
}
Write-Host "Usage:"
Write-Host '  Create cert: .\scripts\sign.ps1 -CreateCert'
Write-Host '  Sign file:   .\scripts\sign.ps1 -Sign "dist\SimpleExtract\SimpleExtract.exe"'
Write-Host '  PFX sign:    .\scripts\sign.ps1 -Sign "app.exe" -CertPath "cert.pfx" -CertPassword "pass"'
