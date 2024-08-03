@echo off
setlocal
set SOURCE_DIR=%cd%\windows
set TARGET_DIR=%cd%\build\windows\x64\runner\Debug

if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"
copy "%SOURCE_DIR%\sqlite3.dll" "%TARGET_DIR%"
echo Copied sqlite3.dll to %TARGET_DIR%
