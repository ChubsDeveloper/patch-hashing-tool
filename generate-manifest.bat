@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

set WORK_DIR=%cd%
set MANIFEST_FILE=%WORK_DIR%\patch-manifest.json
set MANIFEST_TMP=%WORK_DIR%\patch-manifest.json.tmp
set CACHE_FILE=%WORK_DIR%\patch-manifest.cache.json

echo Scanning directory for Patch-*.mpq files...
echo Working directory: %WORK_DIR%
echo.

(
    echo {
    echo   "manifestVersion": 1,
    echo   "baseUrl": "https://www.thorium-reforged.org/Downloads/",
    echo   "generatedAt": "%date% %time%",
    echo   "files": [
) > "%MANIFEST_TMP%"

set FILE_COUNT=0
set FIRST_FILE=1

for /f %%F in ('dir /b /a-d "%WORK_DIR%\Patch-*.mpq" 2^>nul') do (
    set FILE_COUNT=!FILE_COUNT!+1
    set /a FILE_COUNT=!FILE_COUNT!

    set "FILENAME=%%F"
    set "FILEPATH=%WORK_DIR%\!FILENAME!"

    for %%Z in ("!FILEPATH!") do set FILE_SIZE=%%~zZ
    set FILE_SIZE_MB=!FILE_SIZE!

    echo   [!FILE_COUNT!] !FILENAME! - HASHING

    for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-FileHash -Path '!FILEPATH!' -Algorithm SHA256).Hash.ToLower()" 2^>nul') do (
        set "SHA256=%%A"
    )

    if !FIRST_FILE! equ 1 (
        set FIRST_FILE=0
    ) else (
        echo     }, >> "%MANIFEST_TMP%"
    )

    (
        echo     {
        echo       "name": "!FILENAME!",
        echo       "url": "!FILENAME!",
        echo       "size": !FILE_SIZE!,
        echo       "sha256": "!SHA256!"
    ) >> "%MANIFEST_TMP%"
)

if !FILE_COUNT! gtr 0 (
    echo     } >> "%MANIFEST_TMP%"
)

(
    echo   ] >> "%MANIFEST_TMP%"
    echo } >> "%MANIFEST_TMP%"
)

if !FILE_COUNT! equ 0 (
    echo.
    echo   No Patch-*.mpq files found!
    del "%MANIFEST_TMP%" 2>nul
) else (
    echo.
    echo Processing complete:
    echo   Files processed: !FILE_COUNT!
    echo.

    if exist "%MANIFEST_FILE%" del "%MANIFEST_FILE%"
    ren "%MANIFEST_TMP%" "patch-manifest.json"

    echo OK: Manifest written to: %MANIFEST_FILE%
)

echo.
pause
