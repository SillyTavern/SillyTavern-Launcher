@echo off

:fix_github_conflicts
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Trying to resolve unresolved conflicts in the working directory or unmerged files...
cd /d "%st_install_path%"
git merge --abort
git reset --hard
git pull --rebase --autostash
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Done.
pause

if "%caller%"=="home" (
    exit /b 1
) else (
    exit /b 0
)

