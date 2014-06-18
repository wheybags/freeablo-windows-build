IF NOT EXIST build\ GOTO NOBUILDFOLDER
    rmdir /s /q build\
:NOBUILDFOLDER

mkdir build

mkdir build\Debug
copy deps\SDL2-2.0.3\lib\SDL2.dll build\Debug\
copy deps\SDL2_image-2.0.0\lib\*.dll build\Debug\
copy deps\freetype-2.3.5-1\bin\freetype6.dll build\Debug\
copy deps\Python27\python27_d.dll build\Debug\
copy deps\libRocket\lib\RocketCore_d.dll build\Debug
copy deps\libRocket\lib\RocketDebugger_d.dll build\Debug
copy deps\libRocket\lib\RocketControls_d.dll build\Debug


mkdir build\Release
copy deps\SDL2-2.0.3\lib\SDL2.dll build\Release\
copy deps\SDL2_image-2.0.0\lib\*.dll build\Release\
copy deps\freetype-2.3.5-1\bin\freetype6.dll build\Release\
copy deps\Python27\python27.dll build\Release
copy deps\libRocket\lib\RocketCore.dll build\Release
copy deps\libRocket\lib\RocketDebugger.dll build\Release
copy deps\libRocket\lib\RocketControls.dll build\Release

copy deps\libRocket\lib\*.pyd build\
copy deps\libRocket\lib\rocket.py build\
copy DIABDAT.MPQ build\
copy Diablo.exe build\

mklink /j build\resources freeablo\resources
mklink /j build\Python27 deps\Python27

cd build
set CURRDIR=%CD%

cd ..\deps\SDL2-2.0.3
set SDL2DIR=%CD%
cd %CURRDIR%

cd ..\deps\SDL2_image-2.0.0
set SDL2IMAGEDIR=%CD%
cd %CURRDIR%

cd ..\deps\boost_1_54_0
set BOOST_ROOT=%CD%
cd %CURRDIR%

cd ..\deps\freetype-2.3.5-1
set FREETYPE_DIR=%CD%
cd %CURRDIR%

cd ..\deps\libRocket
set ROCKET_ROOT=%CD%
cd %CURRDIR%

cd ..\deps\Python27
set PYTHON_INCLUDE_DIR=%CD%\include
set PYTHON_LIBRARY=%CD%\libs\python27.lib
set PYTHON_DEBUG_LIBRARY=%CD%\libs\python27_d.lib
cd %CURRDIR%


cmake.exe  -G "Visual Studio 10" ..\freeablo -DPYTHON_INCLUDE_DIR=%PYTHON_INCLUDE_DIR% -DPYTHON_LIBRARY=%PYTHON_LIBRARY% -DPYTHON_DEBUG_LIBRARY=%PYTHON_DEBUG_LIBRARY%

for /f "usebackq delims=|" %%f in (`dir /s/b *.vcxproj`) do echo f | xcopy ..\template.vcxproj.user %%~dpnf.vcxproj.user
cd ..