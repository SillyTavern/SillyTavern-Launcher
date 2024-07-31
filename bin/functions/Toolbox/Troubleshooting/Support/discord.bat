@echo off

REM ############################################################
REM ############## DISCORD SERVERS - FRONTEND ##################
REM ############################################################
:discord_servers_menu
title STL [DISCORD SERVERS]
cls
echo %blue_fg_strong%^| ^> / Home / Troubleshooting ^& Support / Discord Servers       ^|%reset%
echo %blue_fg_strong% ==============================================================%reset%
echo    1. Join SillyTavern
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Discord - LLM Backends:                                      ^|%reset%
echo    2. Join TabbyAPI
echo    3. Join KoboldAI
echo    4. Join Text Generation WEBUI ooba
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Discord - Cloud API:                                         ^|%reset%
echo    5. Join Mancer
echo    6. Join OpenRouter
echo    7. Join AI Horde
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Discord - Model Devs ^& Research:                             ^|%reset%
echo    8. Join TheBloke
echo    9. Join PygmalionAI
echo    10. Join Nous Research
echo    11. Join RWKV
echo    12. Join EleutherAI
echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^| Menu Options:                                                ^|%reset%
echo    0. Back

echo %cyan_fg_strong% ______________________________________________________________%reset%
echo %cyan_fg_strong%^|                                                              ^|%reset%

REM Set the prompt with spaces
set /p "discord_servers_choice=%BS%   Choose Your Destiny: "


REM ############## UPDATE MANAGER - BACKEND ####################
if "%discord_servers_choice%"=="1" (
    call :discord_sillytavern
) else if "%discord_servers_choice%"=="2" (
    call :discord_tabbyapi
) else if "%discord_servers_choice%"=="3" (
    call :discord_koboldai
) else if "%discord_servers_choice%"=="4" (
    call :discord_textgenwebuiooba
) else if "%discord_servers_choice%"=="5" (
    call :discord_mancer
) else if "%discord_servers_choice%"=="6" (
    call :discord_openrouter
) else if "%discord_servers_choice%"=="7" (
    call :discord_aihorde
) else if "%discord_servers_choice%"=="8" (
    call :discord_thebloke
) else if "%discord_servers_choice%"=="9" (
    call :discord_pygmalionai
) else if "%discord_servers_choice%"=="10" (
    call :discord_nousresearch
) else if "%discord_servers_choice%"=="11" (
    call :discord_rwkv
) else if "%discord_servers_choice%"=="12" (
    call :discord_eleutherai
) else if "%discord_servers_choice%"=="0" (
    goto :exit_discord_servers_menu
) else (
    echo [%DATE% %TIME%] %log_invalidinput% >> %logs_stl_console_path%
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
)

goto :discord_servers_menu


:discord_sillytavern
start "" "https://discord.gg/sillytavern"
goto :eof

:discord_tabbyapi
start "" "https://discord.gg/sYQxnuD7Fj"
goto :eof

:discord_koboldai
start "" "https://discord.gg/UCyXV7NssH"
goto :eof

:discord_textgenwebuiooba
start "" "https://discord.gg/jwZCF2dPQN"
goto :eof

:discord_mancer
start "" "https://discord.gg/6DZaU9Gv9F"
goto :eof

:discord_openrouter
start "" "https://discord.gg/H9tjZYgauh"
goto :eof

:discord_aihorde
start "" "https://discord.gg/3DxrhksKzn"
goto :eof

:discord_thebloke
start "" "https://discord.gg/Jq4vkcDakD"
goto :eof

:discord_pygmalionai
start "" "https://discord.gg/pygmalionai"
goto :eof

:discord_nousresearch
start "" "https://discord.gg/jqVphNsB4H"
goto :eof

:discord_rwkv
start "" "https://discord.gg/bDSBUMeFpc"
goto :eof

:discord_eleutherai
start "" "https://discord.gg/zBGx3azzUn"
goto :eof

:exit_discord_servers_menu
goto :troubleshooting
