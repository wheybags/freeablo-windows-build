freeablo-windows-build
=======================

This repository is for people who want to build https://github.com/wheybags/freeablo on windows.
It is a bundle of the dependencies, and a script to tell cmake where to find them.


Requirements
============
cmake - get the windows installer from here: http://www.cmake.org/cmake/resources/software.html
Make sure to tell the installer to add cmake to PATH (either for current user or all users), it will ask you about this on the second page.

Visual studio 2015 - needs to be 2015. The free version should work fine.

Usage
=====
Clone the main freeablo repo into this folder (don't forget git submodule update --init), and place DIABDAT.MPQ and Diablo.exe in here as well.
Your directory structure should look like this:

```
freeablo-windows-build/
|
|-deps/
|-freeablo/
|-cmake.bat
|-DIABDAT.MPQ
|-Diablo.exe
|-template.vcxproj.user
```

Now run cmake.bat by clicking, or in cmd.exe. This will create a new folder called build with a visual studio solution inside.
