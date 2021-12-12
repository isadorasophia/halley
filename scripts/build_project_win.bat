@echo off

set generateBuildScript=%1
set gameRootPath=%~2
set gameBinaryName=%~3
set buildConfig=%4

set targetDllDir="%gameRootPath%\bin"
if not exist %targetDllDir% (
    mkdir %targetDllDir%
)

cd /d %gameRootPath%
if not exist build mkdir build
cd build

set sdlPath="%gameRootPath%\halley_deps\bin\SDL2.dll"
set targetDllPath="%gameRootPath%\build\SDL2.dll"

if not exist %targetDllPath% (
    echo Copying %sdlPath% to %targetDllPath%
    copy %sdlPath% %targetDllPath% || exit /b 1
)

set slnName="%gameBinaryName%.sln"
set binTargetName="%gameBinaryName%-gamebins"
set exeName="%gameBinaryName%.exe"

taskkill /IM %exeName% /F >nul 2>nul

if not exist %slnName% (
    if exist %generateBuildScript% (
        echo Generating build files with %generateBuildScript%.

        %generateBuildScript%
    )
    else if (
        echo Generating build files through the default Halley command.

        @rem Use default command line if no custom script is set.
        cmake -G "Visual Studio 17 2022" ^
            -A x64 ^
            -DHALLEY_PATH=../halley ^
            -DBUILD_HALLEY_TOOLS=0 ^
            -DBUILD_HALLEY_TESTS=0 ^
            -DCMAKE_PREFIX_PATH="halley_deps" ^
            -DCMAKE_INCLUDE_PATH="halley_deps\include" ^
            -DCMAKE_LIBRARY_PATH="halley_deps\lib" ^
            -DBOOST_ROOT="halley_deps\Boost" ^
            -DBoost_USE_STATIC_LIBS=1 ^
            .. || exit /b 1
    )
)

cmake.exe --build . --target %binTargetName% --config %buildConfig% || exit /b 1

echo Build successful.