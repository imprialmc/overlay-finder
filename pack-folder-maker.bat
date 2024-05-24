@echo off
setlocal EnableDelayedExpansion

echo Please provide the following JSON values:

:input_id
set /p "id=ID* (current: %id%): "
if "%id%"=="" (
    echo ID is required.
    goto input_id
)

:input_pack_name
set /p "pack_name=Pack Name* (current: %pack_name%): "
if "%pack_name%"=="" (
    echo Pack Name is required.
    goto input_pack_name
)

:input_pack_uploader
set /p "pack_uploader=Pack Uploader* (current: %pack_uploader%): "
if "%pack_uploader%"=="" (
    echo Pack Uploader is required.
    goto input_pack_uploader
)

:input_pack_creator
set /p "pack_creator=Pack Creator* (current: %pack_creator%): "
if "%pack_creator%"=="" (
    echo Pack Creator is required.
    goto input_pack_creator
)

:input_download_link
set /p "download_link=Download Link* (current: %download_link%): "
REM Validate download link
echo %download_link% | findstr /R "^https://.*" > nul
if errorlevel 1 (
    echo Invalid URL format! Please enter a valid URL starting with 'https://'.
    goto input_download_link
)

:input_youtube_id
set /p "youtube_id=YouTube ID (optional) (current: %youtube_id%): "
if /i "%correct%"=="no" (
    set "youtube_id="
)

:input_tags
set /p "tags=Tags (separated by spaces)* (current: %tags%): "
if "%tags%"=="" (
    echo Tags are required.
    goto input_tags
)

:input_description
set /p "description=Description* (current: %description%): "
if "%description%"=="" (
    echo Description is required.
    goto input_description
)

:input_images
set /p "images=Number of Images (default is 1, current: %images%): "
REM Validate images as integer
if not "%images%"=="" (
    for /f "delims=0123456789" %%a in ("%images%") do (
        if not "%%a"=="" (
            echo Invalid input! Please enter a valid number for the number of images.
            goto input_images
        )
    )
)

if "%images%"=="" (
    set "images=1"
)

rem Create JSON string
set json={
set json=!json!    "id": "%id%",
set json=!json!    "pack_name": "%pack_name%",
set json=!json!    "pack_uploader": "%pack_uploader%",
set json=!json!    "pack_creator": "%pack_creator%",
set json=!json!    "download_link": "%download_link%",
if not "%youtube_id%"=="" (
    set json=!json!    "youtube_id": "%youtube_id%",
)
set json=!json!    "tags": [ "%tags:" =" ,"%" ],
set json=!json!    "description": "%description%",
set json=!json!    "images": %images%
set json=!json!}

echo.
echo Generated JSON:
echo !json!

:confirm
set /p "correct=Is everything correct? (yes/no): "
if /i "%correct%"=="no" goto input_id
if /i "%correct%"=="yes" goto create_files
goto confirm

:create_files
rem Create directory with id as name
mkdir "%id%"

rem Write JSON to file
echo !json!>"%id%\data.json"

echo Folder and JSON file created successfully!
pause
