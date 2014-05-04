IF NOT EXIST build\ GOTO NOBUILDFOLDER
    rmdir /s /q build\
:NOBUILDFOLDER

mkdir build

mkdir build\Debug
xcopy deps\SDL2-2.0.3\lib\SDL2.dll build\Debug\

mkdir build\Release
xcopy deps\SDL2-2.0.3\lib\SDL2.dll build\Release\

xcopy DIABDAT.MPQ build\
xcopy Diablo.exe build\

mklink /j build\resources freeablo\resources

cd build
set CURRDIR=%CD%

cd ..\deps\SDL2-2.0.3
set SDL2DIR=%CD%
cd %CURRDIR%

cd ..\deps\boost_1_54_0
set BOOST_ROOT=%CD%
cd %CURRDIR%

cd ..\windows-include\
set WIN_INCLUDE=%CD%
cd %CURRDIR%

cmake  -G "Visual Studio 10" ..\freeablo -DCLI_INCLUDE_DIRS=%WIN_INCLUDE%

for /f "usebackq delims=|" %%f in (`dir /s/b *.vcxproj`) do echo f | xcopy ..\template.vcxproj.user %%~dpnf.vcxproj.user
cd ..