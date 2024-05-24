@echo off
setlocal

REM Set your Git repository URL and branch
set REPO_URL=https://github.com/imprialmc/overlay-finder.git
set BRANCH=main

REM Set the path to your JSON file within the repository
set JSON_FILE_PATH=packs.json

REM Set the path to the packs folder
set PACKS_FOLDER=%~dp0\packs

REM Create a temporary directory
set TEMP_DIR=%TEMP%\git_temp_%RANDOM%
mkdir %TEMP_DIR%
cd %TEMP_DIR%

REM Clone the repository
git clone %REPO_URL%
cd overlay-finder

REM Checkout the branch
git checkout %BRANCH%

REM Get latest changes
git pull origin %BRANCH%

REM Check if packs folder exists
if not exist "%PACKS_FOLDER%" (
    echo Packs folder does not exist.
    pause
    exit /b
) else (
    echo Packs folder found.
)

REM Create an empty JSON array
echo [ > %JSON_FILE_PATH%

REM Loop through each folder in the packs directory and append to JSON
for /D %%i in ("%PACKS_FOLDER%\*") do (
    echo %%~nxi
    echo   { >> %JSON_FILE_PATH%
    echo     "pack": "%%~nxi" >> %JSON_FILE_PATH%
    echo   }, >> %JSON_FILE_PATH%
)

REM Remove the trailing comma from the last object
powershell -Command "(Get-Content '%JSON_FILE_PATH%') | ForEach-Object { $_ -replace '},$', '}' } | Set-Content '%JSON_FILE_PATH%'"

REM Append closing bracket to JSON
echo ] >> %JSON_FILE_PATH%

REM Commit changes
git add %JSON_FILE_PATH%
git commit -m "Updated packs.json"

REM Push changes
git push origin %BRANCH%

REM Clean up
cd ..
rmdir /s /q overlay-finder

echo Done.
pause
