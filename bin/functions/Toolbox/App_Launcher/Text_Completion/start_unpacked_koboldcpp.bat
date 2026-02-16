@echo off

:start_koboldcpp
REM Check if dev-koboldcpp directory exists
if not exist "%koboldcpp_install_path%" (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] dev-koboldcpp directory not found in: %text_completion_dir%%reset%
    pause
    goto :home
)

cd /d "%koboldcpp_install_path%"

REM Check if koboldcpp-launcher file exists [koboldcpp NVIDIA/AMD]
if exist "%koboldcpp_install_path%\koboldcpp-launcher.exe" (
    echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% koboldcpp-launcher launched in a new window.
    start "" "koboldcpp-launcher.exe"
    goto :home
)