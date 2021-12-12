@echo off

set targetDllDir="%~1\bin"
if not exist %targetDllDir% (
    mkdir %targetDllDir%
)
set targetDllPath="%~1\bin\SDL2.dll"
if not exist %targetDllPath% (
    echo Copying SDL2.dll to %targetDllPath%
    copy SDL2.dll %targetDllPath% || exit /b 1
)

cd /d %1
if not exist build mkdir build
cd build

set slnName="%~2.sln"
set binTargetName="%~2-gamebins"
set exeName="%~2.exe"

taskkill /IM %exeName% /F >nul 2>nul

IF NOT EXIST %slnName% (
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

cmake.exe --build . --target %binTargetName% --config %3 || exit /b 1

echo Build successful.