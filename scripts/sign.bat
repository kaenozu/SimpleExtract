@echo off
REM SimpleExtract 署名バッチ（PowerShellラッパー）
echo === SimpleExtract コード署名 ===
powershell -ExecutionPolicy Bypass -File "%~dp0sign.ps1" %*
pause
