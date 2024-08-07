@echo off

:install_cudatoolkit
REM Check if file exists
if not exist "%bin_dir%\cuda_12.5.1_windows_network.exe" (
    curl -L -o "%bin_dir%\cuda_12.5.1_windows_network.exe" "https://developer.download.nvidia.com/compute/cuda/12.5.1/network_installers/cuda_12.5.1_windows_network.exe"
) else (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO] "cuda_12.5.1_windows_network.exe" file already exists.%reset%
)

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Installing CUDA Toolkit...
start "" "%bin_dir%\cuda_12.5.1_windows_network.exe" visual_studio_integration_12.5.1
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% %green_fg_strong%When install is finished:%reset%

REM If CUDA Toolkit fails to install then copy all files from MSBuildExtensions into BuildCustomizations
REM xcopy /s /i /y "%ProgramFiles%\NVIDIA GPU Computing Toolkit\CUDA\v12.5.1\extras\visual_studio_integration\MSBuildExtensions\*" "%ProgramFiles%\Microsoft Visual Studio\2022\Community\MSBuild\Microsoft\VC\v170\BuildCustomizations"

pause
REM Prompt user to restart
echo Restarting launcher...
timeout /t 5
cd /d %stl_root%
start %stl_root%Launcher.bat
exit