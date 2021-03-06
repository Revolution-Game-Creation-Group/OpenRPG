@echo off

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

set buildVars=
set buildType=Debug

if %OS%==32BIT set buildVars=%buildVars% -A Win32
if %OS%==64BIT set buildVars=%buildVars% -A x64

if "%1" == "help"   goto notYetSupported
if "%1" == "/h"     goto notYetSupported

if "%1" == "clean"      goto cleanBuild
if "%1" == "nuke"       goto cleanBuild
if "%1" == "rebuild"    goto cleanBuild
if "%1" == "install"    goto cleanBuild
if "%2" == "install"    goto cleanBuild
goto checkBuild

:cleanBuild (
    if exist build/ (
        rd /s /q build
        REM We should be able to just wildcard away here
        if exist include\character\exports (rd /s /q include\character\exports)
        if exist include\core\exports (rd /s /q include\core\exports)
        if exist include\names\exports (rd /s /q include\names\exports)
        if exist include\roll\exports (rd /s /q include\roll\exports)
    )
    if "%1" == "clean" goto commonExit
    if "%1" == "nuke"  goto commonExit
)

:checkBuild
if "%1" == "release"    goto setReleaseBuild
if "%2" == "release"    goto setReleaseBuild
if "%1" == "install"    goto setReleaseBuild
if "%2" == "install"    goto setReleaseBuild
goto startBuild

:setReleaseBuild
set buildVars=%buildVars% -DCMAKE_BUILD_TYPE=RELEASE
set buildType=Release


:startBuild
WHERE cmake
if %ERRORLEVEL% == 0 goto cmakeFound
if %ERRORLEVEL% neq 0 goto cmakeMissing

:cmakeFound
if exist build/ (
    pushd build

    cmake %buildVars% ..

    WHERE msbuild
    if %ERRORLEVEL% == 0 goto msbuildFound
    if %ERRORLEVEL% neq 0 goto msbuildMissing

    :msbuildFound
    msbuild OpenRPG.sln /property:Configuration=%buildType%

    if "%1" == "package"    goto package
    if "%2" == "package"    goto package
    goto poptag
    
    :package
    cmake --build . --target package

    :poptag
    popd
    goto commonExit
)
mkdir build
goto cmakeFound

:cmakeMissing
echo cmake not found in PATH
exit 1

:msbuildMissing
echo msbuild not found in PATH
exit 1

:notYetSupported
echo This option is not yet supported: %1
exit 1

:commonExit
echo exiting
