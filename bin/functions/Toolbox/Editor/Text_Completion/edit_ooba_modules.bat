@echo off

REM ############################################################
REM ############## EDIT OOBA MODULES - FRONTEND ################
REM ############################################################
:edit_ooba_modules
title STL [EDIT OOBA MODULES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Text Completion / Edit OOBA Modules%reset%
echo -------------------------------------------------------------
echo Choose OOBA modules to enable or disable (e.g., "1 2 4" to enable extensions openai, listen, and api-port)



REM Display module options with colors based on their status
call :printModule "1. extensions openai (--extensions openai)" %ooba_extopenai_trigger%
call :printModule "2. listen (--listen)" %ooba_listen_trigger%
call :printModule "3. listen-port (--listen-port 7910)" %ooba_listenport_trigger%
call :printModule "4. api-port (--api-port 7911)" %ooba_apiport_trigger%
call :printModule "5. autolaunch (--autolaunch)" %ooba_autolaunch_trigger%
call :printModule "6. verbose (--verbose)" %ooba_verbose_trigger%

echo 00. Quick Start Text generation web UI oobabooga
echo 0. Back

set "python_command="

set /p ooba_module_choices=Choose modules to enable/disable: 

REM Handle the user's module choices and construct the Python command
for %%i in (%ooba_module_choices%) do (
    if "%%i"=="1" (
        if "%ooba_extopenai_trigger%"=="true" (
            set "ooba_extopenai_trigger=false"
        ) else (
            set "ooba_extopenai_trigger=true"
        )

    ) else if "%%i"=="2" (
        if "%ooba_listen_trigger%"=="true" (
            set "ooba_listen_trigger=false"
        ) else (
            set "ooba_listen_trigger=true"
        )

    ) else if "%%i"=="3" (
        if "%ooba_listenport_trigger%"=="true" (
            set "ooba_listenport_trigger=false"
        ) else (
            set "ooba_listenport_trigger=true"
        )

    ) else if "%%i"=="4" (
        if "%ooba_apiport_trigger%"=="true" (
            set "ooba_apiport_trigger=false"
        ) else (
            set "ooba_apiport_trigger=true"
        )

    ) else if "%%i"=="5" (
        if "%ooba_autolaunch_trigger%"=="true" (
            set "ooba_autolaunch_trigger=false"
        ) else (
            set "ooba_autolaunch_trigger=true"
        )
    ) else if "%%i"=="6" (
        if "%ooba_verbose_trigger%"=="true" (
            set "ooba_verbose_trigger=false"
        ) else (
            set "ooba_verbose_trigger=true"
        )

    ) else if "%%i"=="00" (
        goto :start_ooba

    ) else if "%%i"=="0" (
        goto :editor_text_completion
    )
)

REM Save the module flags to modules-ooba
echo ooba_extopenai_trigger=%ooba_extopenai_trigger%>%ooba_modules_path%
echo ooba_listen_trigger=%ooba_listen_trigger%>>%ooba_modules_path%
echo ooba_listenport_trigger=%ooba_listenport_trigger%>>%ooba_modules_path%
echo ooba_apiport_trigger=%ooba_apiport_trigger%>>%ooba_modules_path%
echo ooba_autolaunch_trigger=%ooba_autolaunch_trigger%>>%ooba_modules_path%
echo ooba_verbose_trigger=%ooba_verbose_trigger%>>%ooba_modules_path%


REM remove modules_enable
set "modules_enable="

REM Compile the Python command
set "python_command=start start_windows.bat"
if "%ooba_extopenai_trigger%"=="true" (
    set "python_command=%python_command% --extensions openai"
)
if "%ooba_listen_trigger%"=="true" (
    set "python_command=%python_command% --listen"
)
if "%ooba_listenport_trigger%"=="true" (
    set "python_command=%python_command% --listen-port 7910"
)
if "%ooba_apiport_trigger%"=="true" (
    set "python_command=%python_command% --api-port 7911"
)
if "%ooba_autolaunch_trigger%"=="true" (
    set "python_command=%python_command% --auto-launch"
)
if "%ooba_verbose_trigger%"=="true" (
    set "python_command=%python_command% --verbose"
)


REM is modules_enable empty?
if defined modules_enable (
    REM remove last comma
    set "modules_enable=%modules_enable:~0,-1%"
)

REM command completed
if defined modules_enable (
    set "python_command=%python_command% --enable-modules=%modules_enable%"
)

REM Save the constructed Python command to modules-ooba for testing
echo ooba_start_command=%python_command%>>%ooba_modules_path%
goto :edit_ooba_modules

REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b