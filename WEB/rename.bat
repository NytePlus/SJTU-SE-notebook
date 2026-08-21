@echo off
setlocal enabledelayedexpansion

for %%f in (*.png) do (
    set "filename=%%~nf"
    set "extension=%%~xf"
    ren "%%f" "!filename!_docker!extension!"
)

echo 所有PNG文件已重命名。
pause