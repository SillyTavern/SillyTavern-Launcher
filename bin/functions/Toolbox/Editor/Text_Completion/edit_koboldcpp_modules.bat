@echo off

REM ############################################################
REM ########### EDIT KOBOLDCPP MODULES - FRONTEND ##############
REM ############################################################
:edit_koboldcpp_modules
title STL [EDIT KOBOLDCPP MODULES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Text Completion / Edit KOBOLDCPP Modules%reset%
echo -------------------------------------------------------------
echo Choose KOBOLDCPP modules to enable or disable (e.g., "1 2 4" to enable extensions openai, listen, and api-port)



REM Display module options with colors based on their status
call :printModule "1. verbose (!--quiet)" %koboldcpp_verbose_trigger%

echo 00. Quick Start koboldcpp
echo 0. Back

set "launch_command="

set /p koboldcpp_module_choices=Choose modules to enable/disable:

REM Handle the user's module choices and construct the Python command
for %%i in (%koboldcpp_module_choices%) do (
    if "%%i"=="1" (
        if "%koboldcpp_verbose_trigger%"=="true" (
            set "koboldcpp_verbose_trigger=false"
        ) else (
            set "koboldcpp_verbose_trigger=true"
        )

    ) else if "%%i"=="00" (
        goto :start_koboldcpp

    ) else if "%%i"=="0" (
        goto :editor_text_completion
    )
)

REM Save the module flags to modules-koboldcpp
echo koboldcpp_preferred_exe=%koboldcpp_preferred_exe%>%koboldcpp_modules_path%
echo koboldcpp_verbose_trigger=%koboldcpp_verbose_trigger%>>%koboldcpp_modules_path%

REM Compile the command
set "launch_command=%koboldcpp_preferred_exe%"
if "%koboldcpp_verbose_trigger%"=="false" (
    set "launch_command=%launch_command% --quiet"
)

REM Save the constructed Python command to modules-koboldcpp for testing
echo koboldcpp_start_command=%launch_command%>>%koboldcpp_modules_path%
goto :edit_koboldcpp_modules

REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b