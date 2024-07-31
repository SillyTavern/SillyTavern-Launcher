@echo off

REM ############################################################
REM ############## EDIT EXTRAS MODULES - FRONTEND ##############
REM ############################################################
:edit_extras_modules
title STL [EDIT EXTRAS MODULES]
cls
echo %blue_fg_strong%/ Home / Toolbox / Editor / Edit Extras Modules%reset%
echo -------------------------------------------------------------
echo Choose extras modules to enable or disable (e.g., "1 2 4" to enable Cuda, RVC, and Caption)

REM Display module options with colors based on their status
call :printModule "1. Cuda (--cuda)" %cuda_trigger%
call :printModule "2. RVC (--enable-modules=rvc --rvc-save-file --max-content-length=1000)" %rvc_trigger%
call :printModule "3. talkinghead (--enable-modules=talkinghead --talkinghead-gpu)" %talkinghead_trigger%
call :printModule "4. caption (--enable-modules=caption)" %caption_trigger%
call :printModule "5. summarize (--enable-modules=summarize)" %summarize_trigger%
call :printModule "6. listen (--listen)" %listen_trigger%
call :printModule "7. whisper (--enable-modules=whisper-stt)" %whisper_trigger%
call :printModule "8. Edge-tts (--enable-modules=edge-tts)" %edge_tts_trigger%
call :printModule "9. Websearch (--enable-modules=websearch)" %websearch_trigger%
echo 00. Quick Start Extras
echo 0. Back

set "python_command="

set /p module_choices=Choose modules to enable/disable: 

REM Handle the user's module choices and construct the Python command
for %%i in (%module_choices%) do (
    if "%%i"=="1" (
        if "%cuda_trigger%"=="true" (
            set "cuda_trigger=false"
        ) else (
            set "cuda_trigger=true"
        )

    ) else if "%%i"=="2" (
        if "%rvc_trigger%"=="true" (
            set "rvc_trigger=false"
        ) else (
            set "rvc_trigger=true"
        )

    ) else if "%%i"=="3" (
        if "%talkinghead_trigger%"=="true" (
            set "talkinghead_trigger=false"
        ) else (
            set "talkinghead_trigger=true"
        )

    ) else if "%%i"=="4" (
        if "%caption_trigger%"=="true" (
            set "caption_trigger=false"
        ) else (
            set "caption_trigger=true"
        )

    ) else if "%%i"=="5" (
        if "%summarize_trigger%"=="true" (
            set "summarize_trigger=false"
        ) else (
            set "summarize_trigger=true"
        )
    ) else if "%%i"=="6" (
        if "%listen_trigger%"=="true" (
            set "listen_trigger=false"
        ) else (
            set "listen_trigger=true"
        )

    ) else if "%%i"=="7" (
        if "%whisper_trigger%"=="true" (
            set "whisper_trigger=false"
        ) else (
            set "whisper_trigger=true"
        )

    ) else if "%%i"=="8" (
        if "%edge_tts_trigger%"=="true" (
            set "edge_tts_trigger=false"
        ) else (
            set "edge_tts_trigger=true"
        )

    ) else if "%%i"=="9" (
        if "%websearch_trigger%"=="true" (
            set "websearch_trigger=false"
        ) else (
            set "websearch_trigger=true"
        )

    ) else if "%%i"=="00" (
        set "caller=edit_extras_modules"
        if exist "%app_launcher_core_utilities_dir%\start_extras.bat" (
            call %app_launcher_core_utilities_dir%\start_extras.bat
            goto :eof
        ) else (
            echo "start_extras.bat not found"
        )
    ) else if "%%i"=="0" (
        goto :exit_edit_extras_modules
    )
)

REM Save the module flags
echo cuda_trigger=%cuda_trigger%>%extras_modules_path%
echo rvc_trigger=%rvc_trigger%>>%extras_modules_path%
echo talkinghead_trigger=%talkinghead_trigger%>>%extras_modules_path%
echo caption_trigger=%caption_trigger%>>%extras_modules_path%
echo summarize_trigger=%summarize_trigger%>>%extras_modules_path%
echo listen_trigger=%listen_trigger%>>%extras_modules_path%
echo whisper_trigger=%whisper_trigger%>>%extras_modules_path%
echo edge_tts_trigger=%edge_tts_trigger%>>%extras_modules_path%
echo websearch_trigger=%websearch_trigger%>>%extras_modules_path%


REM remove modules_enable
set "modules_enable="

REM Compile the Python command
set "python_command=python server.py"
if "%listen_trigger%"=="true" (
    set "python_command=%python_command% --listen"
)
if "%cuda_trigger%"=="true" (
    set "python_command=%python_command% --cuda"
)
if "%rvc_trigger%"=="true" (
    set "python_command=%python_command% --rvc-save-file --max-content-length=1000"
    set "modules_enable=%modules_enable%rvc,"
)
if "%talkinghead_trigger%"=="true" (
    set "python_command=%python_command% --talkinghead-gpu"
    set "modules_enable=%modules_enable%talkinghead,"
)
if "%caption_trigger%"=="true" (
    set "modules_enable=%modules_enable%caption,"
)
if "%summarize_trigger%"=="true" (
    set "modules_enable=%modules_enable%summarize,"
)
if "%whisper_trigger%"=="true" (
    set "modules_enable=%modules_enable%whisper-stt,"
)
if "%edge_tts_trigger%"=="true" (
    set "modules_enable=%modules_enable%edge-tts,"
)
if "%websearch_trigger%"=="true" (
    set "modules_enable=%modules_enable%websearch,"
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

REM Save the constructed Python command to modules-extras for testing
echo extras_start_command=%python_command%>>%extras_modules_path%
goto :edit_extras_modules

REM Function to print module options with color based on their status
:printModule
if "%2"=="true" (
    echo %green_fg_strong%%1 [Enabled]%reset%
) else (
    echo %red_fg_strong%%1 [Disabled]%reset%
)
exit /b

:exit_edit_extras_modules
goto :editor_core_utilities