freeablo-windows-build
=======================

This repository is forr people who want to build https://github.com/wheybags/freeablo on windows.
It is a bundle of the dependencies, and a script to tell cmake where to find them.

Requirements
============
cmake - get the windows installer from here: http://www.cmake.org/cmake/resources/software.html
Make sure to tell the installer to add cmake to PATH (either for current user or all users), it will ask you about this on the second page.

Visual studio 2010 - yes, actually needs to be 2010. You can install 2010 express for free even if you have a newer version already installed, and you can even then use the solution in 2012 or whatever, but you need to have 2010 installed.

Usage
=====
Clone the main freeablo repo into this folder, and place DIABDAT.MPQ and Diablo.exe in here as well.
Your directory structure should look like this:

freeablo-windows-build/

|

|-deps/

|-freeablo/

|-cmake.bat

|-DIABDAT.MPQ

|-Diablo.exe

|-template.vcxproj.user

Now run cmake.bat by clicking, or in cmd.exe. This will create a build folder with a vs2010 solution inside.
