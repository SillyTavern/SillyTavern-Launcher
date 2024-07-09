@echo off

:install_vsbuildtools
REM Check if file exists
if not exist "%bin_dir%\vs_buildtools.exe" (
    REM Check if the folder exists
    if not exist "%bin_dir%" (
        mkdir "%bin_dir%"
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Created folder: "bin"  
    ) else (
        echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "bin" folder already exists.%reset%
    )
    curl -L -o "%bin_dir%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "vs_buildtools.exe" file already exists. Downloading latest version...%reset%
    del "%bin_dir%\vs_buildtools.exe"
    curl -L -o "%bin_dir%\vs_buildtools.exe" "https://aka.ms/vs/17/release/vs_BuildTools.exe"
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing Visual Studio BuildTools 2022...
start "" "%bin_dir%\vs_buildtools.exe" --norestart --passive --downloadThenInstall --includeRecommended --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Workload.MSBuildTools
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%When install is finished:%reset%
pause

REM Prompt user to restart
echo Restarting launcher...
timeout /t 5
cd /d %stl_root%
start %stl_root%Launcher.bat
exit