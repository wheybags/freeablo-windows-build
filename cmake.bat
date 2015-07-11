@echo off

:http://stackoverflow.com/questions/3551888/pausing-a-batch-file-when-double-clicked-but-not-when-run-from-a-console-window
for %%x in (%cmdcmdline%) do if /i "%%~x"=="/c" set DOUBLECLICKED=1


IF EXIST Qt GOTO QTINSTALLED
    echo downloading qt, this may take a while (~600mb installer)...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('http://download.qt.io/official_releases/qt/5.4/5.4.1/qt-opensource-windows-x86-msvc2010_opengl-5.4.1.exe', 'qt-opensource-windows-x86-msvc2010_opengl-5.4.1.exe')"
       
    echo executing qt installer, please select %CD%\Qt\Qt5.4.1\ as the installation directory
    pause
    start /WAIT qt-opensource-windows-x86-msvc2010_opengl-5.4.1.exe
    
:QTINSTALLED

IF NOT EXIST build\ GOTO NOBUILDFOLDER
    rmdir /s /q build\
:NOBUILDFOLDER


mkdir build

mkdir build\Debug
copy deps\SDL2-2.0.3\lib\SDL2.dll build\Debug\
copy deps\SDL2_image-2.0.0\lib\*.dll build\Debug\
copy deps\SDL2_mixer-2.0.0\lib\*.dll build\Debug\
copy deps\freetype-2.3.5-1\bin\freetype6.dll build\Debug\
copy deps\Python27\python27_d.dll build\Debug\
copy deps\libRocket\lib\RocketCore_d.dll build\Debug
copy deps\libRocket\lib\RocketDebugger_d.dll build\Debug
copy deps\libRocket\lib\RocketControls_d.dll build\Debug
copy deps\libpng\lib\*.dll build\Debug
copy Qt\Qt5.4.1\5.4\msvc2010_opengl\bin\Qt5Widgetsd.dll build\Debug
copy Qt\Qt5.4.1\5.4\msvc2010_opengl\bin\Qt5Guid.dll build\Debug
copy Qt\Qt5.4.1\5.4\msvc2010_opengl\bin\Qt5Cored.dll build\Debug
copy Qt\Qt5.4.1\5.4\msvc2010_opengl\bin\icudt53.dll build\Debug
copy Qt\Qt5.4.1\5.4\msvc2010_opengl\bin\icuin53.dll build\Debug
copy Qt\Qt5.4.1\5.4\msvc2010_opengl\bin\icuuc53.dll build\Debug



mkdir build\Release
copy deps\SDL2-2.0.3\lib\SDL2.dll build\Release\
copy deps\SDL2_image-2.0.0\lib\*.dll build\Release\
copy deps\SDL2_mixer-2.0.0\lib\*.dll build\Release\
copy deps\freetype-2.3.5-1\bin\freetype6.dll build\Release\
copy deps\Python27\python27.dll build\Release
copy deps\libRocket\lib\RocketCore.dll build\Release
copy deps\libRocket\lib\RocketDebugger.dll build\Release
copy deps\libRocket\lib\RocketControls.dll build\Release
copy deps\libpng\lib\*.dll build\Release
copy Qt\Qt5.4.1\5.4\msvc2010_opengl\bin\Qt5Widgets.dll build\Release
copy Qt\Qt5.4.1\5.4\msvc2010_opengl\bin\Qt5Gui.dll build\Release
copy Qt\Qt5.4.1\5.4\msvc2010_opengl\bin\Qt5Core.dll build\Release
copy Qt\Qt5.4.1\5.4\msvc2010_opengl\bin\icudt53.dll build\Release
copy Qt\Qt5.4.1\5.4\msvc2010_opengl\bin\icuin53.dll build\Release
copy Qt\Qt5.4.1\5.4\msvc2010_opengl\bin\icuuc53.dll build\Release

copy deps\libRocket\lib\*.pyd build\
copy deps\libRocket\lib\rocket.py build\
copy DIABDAT.MPQ build\
copy Diablo.exe build\

mklink /j build\resources freeablo\resources
mklink /j build\Python27 deps\Python27

cd build
set CURRDIR=%CD%

cd ..\deps\zlib
set ZLIB_LIBRARY=%CD%\lib\zlib.lib
set ZLIB_INCLUDE_DIR=%CD%\include
cd %CURRDIR%

cd ..\deps\libpng
set PNG_LIBRARY=%CD%\lib\libpng.lib
set PNG_INCLUDE_DIR=%CD%\include
cd %CURRDIR%

cd ..\deps\SDL2-2.0.3
set SDL2DIR=%CD%
cd %CURRDIR%

cd ..\deps\SDL2_image-2.0.0
set SDL2IMAGEDIR=%CD%
cd %CURRDIR%

cd ..\deps\SDL2_mixer-2.0.0
set SDL2MIXERDIR=%CD%
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




cd ..\windows-include\
set WIN_INCLUDE=%CD%
cd %CURRDIR%

cd ..\Qt\Qt5.4.1\5.4\msvc2010_opengl
set CMAKE_PREFIX_PATH=%CD%
cd %CURRDIR%

cmake.exe  -G "Visual Studio 10" ..\freeablo -DCLI_INCLUDE_DIRS=%WIN_INCLUDE% -DPYTHON_INCLUDE_DIR=%PYTHON_INCLUDE_DIR% -DPYTHON_LIBRARY=%PYTHON_LIBRARY% -DPYTHON_DEBUG_LIBRARY=%PYTHON_DEBUG_LIBRARY% -DZLIB_LIBRARY=%ZLIB_LIBRARY% -DZLIB_INCLUDE_DIR=%ZLIB_INCLUDE_DIR% -DPNG_LIBRARY=%PNG_LIBRARY% -DPNG_PNG_INCLUDE_DIR=%PNG_INCLUDE_DIR% -DBoost_USE_STATIC_LIBS=On


for /f "usebackq delims=|" %%f in (`dir /s/b *.vcxproj`) do echo f | xcopy ..\template.vcxproj.user %%~dpnf.vcxproj.user
cd ..

if defined DOUBLECLICKED pause