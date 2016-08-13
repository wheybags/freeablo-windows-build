::@echo off

:http://stackoverflow.com/questions/3551888/pausing-a-batch-file-when-double-clicked-but-not-when-run-from-a-console-window
for %%x in (%cmdcmdline%) do if /i "%%~x"=="/c" set DOUBLECLICKED=1

IF DEFINED APPVEYOR GOTO QTINSTALLED
IF EXIST Qt GOTO QTINSTALLED
    echo downloading qt, this may take a while (~700mb installer)...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('http://download.qt.io/official_releases/qt/5.6/5.6.0/qt-opensource-windows-x86-msvc2015-5.6.0.exe', 'qt-opensource-windows-x86-msvc2015-5.6.0.exe')"
       
    echo executing qt installer, please select %CD%\Qt\Qt5.6.0\ as the installation directory
    pause
    start /WAIT qt-opensource-windows-x86-msvc2015-5.6.0.exe
    
:QTINSTALLED

IF NOT EXIST build\ GOTO NOBUILDFOLDER
    rmdir /s /q build\
:NOBUILDFOLDER

set CURRDIR=%CD%
if defined APPVEYOR goto appveyor_qt
    cd Qt\Qt5.6.0\5.6\msvc2015
    set QTDIR=%CD%
goto qtdone
:appveyor_qt
    cd C:\Qt\5.6\msvc2015
    set QTDIR=%CD%
:qtdone

cd %CURRDIR%




mkdir build

mkdir build\Debug
copy deps\SDL2-2.0.4\lib\SDL2.dll build\Debug\
copy deps\SDL2_image-2.0.0\lib\*.dll build\Debug\
copy deps\SDL2_mixer-2.0.0\lib\*.dll build\Debug\
copy deps\freetype-2.3.5-1\bin\freetype.dll build\Debug\
copy deps\freetype-2.3.5-1\bin\freetype6.dll build\Debug\
copy deps\Python27\python27.dll build\Debug\
copy deps\libRocket\lib\RocketCore_d.dll build\Debug\RocketCore.dll
copy deps\libRocket\lib\RocketDebugger_d.dll build\Debug\RocketDebugger.dll
copy deps\libRocket\lib\RocketControls_d.dll build\Debug\RocketControls.dll
copy deps\libRocket\lib\_rocketcore_d.pyd build\Debug\_rocketcore.pyd
copy deps\libRocket\lib\_rocketcontrols_d.pyd build\Debug\_rocketcontrols.pyd
copy deps\libpng\lib\*.dll build\Debug
copy %QTDIR%\bin\Qt5Widgetsd.dll build\Debug
copy %QTDIR%\bin\Qt5Guid.dll build\Debug
copy %QTDIR%\bin\Qt5Cored.dll build\Debug
copy %QTDIR%\bin\icudt54.dll build\Debug
copy %QTDIR%\bin\icuin54.dll build\Debug
copy %QTDIR%\bin\icuuc54.dll build\Debug
copy deps\boost_1_61_0\lib\*-mt-gd-1_61.dll build\Debug



mkdir build\Release
copy deps\SDL2-2.0.4\lib\SDL2.dll build\Release\
copy deps\SDL2_image-2.0.0\lib\*.dll build\Release\
copy deps\SDL2_mixer-2.0.0\lib\*.dll build\Release\
copy deps\freetype-2.3.5-1\bin\freetype.dll build\Release\
copy deps\freetype-2.3.5-1\bin\freetype6.dll build\Release\
copy deps\Python27\python27.dll build\Release
copy deps\libRocket\lib\RocketCore.dll build\Release
copy deps\libRocket\lib\RocketDebugger.dll build\Release
copy deps\libRocket\lib\RocketControls.dll build\Release
copy deps\libRocket\lib\_rocketcore.pyd build\Release\_rocketcore.pyd
copy deps\libRocket\lib\_rocketcontrols.pyd build\Release\_rocketcontrols.pyd
copy deps\libpng\lib\*.dll build\Release
copy %QTDIR%\bin\Qt5Widgets.dll build\Release
copy %QTDIR%\bin\Qt5Gui.dll build\Release
copy %QTDIR%\bin\Qt5Core.dll build\Release
copy %QTDIR%\bin\icudt54.dll build\Release
copy %QTDIR%\bin\icuin54.dll build\Release
copy %QTDIR%\bin\icuuc54.dll build\Release
copy deps\boost_1_61_0\lib\*-mt-1_61.dll build\Release

mkdir build\RelWithDebInfo
copy build\Release\* build\RelWithDebInfo

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

cd ..\deps\SDL2-2.0.4
set SDL2DIR=%CD%
cd %CURRDIR%

cd ..\deps\SDL2_image-2.0.0
set SDL2IMAGEDIR=%CD%
cd %CURRDIR%

cd ..\deps\SDL2_mixer-2.0.0
set SDL2MIXERDIR=%CD%
cd %CURRDIR%

cd ..\deps\boost_1_61_0
set BOOST_ROOT=%CD%
cd %CURRDIR%

cd ..\deps\freetype-2.3.5-1
set FREETYPE_DIR=%CD%
cd %CURRDIR%

cd ..\deps\libRocket
set ROCKET_ROOT=%CD%
cd %CURRDIR%

cd ..\deps\enet-13.13
set ENETDIR=%CD%
cd %CURRDIR%

cd ..\deps\Python27
set PYTHON_INCLUDE_DIR=%CD%\include
set PYTHON_LIBRARY=%CD%\libs\python27.lib
cd %CURRDIR%




cd ..\windows-include\
set WIN_INCLUDE=%CD%
cd %CURRDIR%

cmake.exe -DCMAKE_PREFIX_PATH=%QTDIR% -G "Visual Studio 14" ..\freeablo -DCLI_INCLUDE_DIRS=%WIN_INCLUDE% -DPYTHON_INCLUDE_DIR=%PYTHON_INCLUDE_DIR% -DPYTHON_LIBRARY=%PYTHON_LIBRARY% -DPYTHON_DEBUG_LIBRARY=%PYTHON_DEBUG_LIBRARY% -DZLIB_LIBRARY=%ZLIB_LIBRARY% -DZLIB_INCLUDE_DIR=%ZLIB_INCLUDE_DIR% -DPNG_LIBRARY=%PNG_LIBRARY% -DPNG_PNG_INCLUDE_DIR=%PNG_INCLUDE_DIR% -DCLI_DEFINES=-DBOOST_ALL_DYN_LINK


for /f "usebackq delims=|" %%f in (`dir /s/b *.vcxproj`) do echo f | xcopy ..\template.vcxproj.user %%~dpnf.vcxproj.user
cd ..

if defined APPVEYOR goto finished
if defined DOUBLECLICKED pause

:finished
