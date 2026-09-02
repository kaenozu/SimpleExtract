@echo off
REM SimpleExtract ビルドスクリプト (Windows)
echo === SimpleExtract ビルド開始 ===
pip install -r requirements.txt
pyinstaller --noconfirm --windowed --name SimpleExtract --icon=NONE --add-data "NUL;." ^
  --hidden-import=py7zr --hidden-import=rarfile --hidden-import=PIL ^
  simple_extract.py
echo.
echo 完了: dist\SimpleExtract\SimpleExtract.exe
pause
