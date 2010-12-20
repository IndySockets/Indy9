@echo off

REM ****************************************************************************
REM 
REM Author : Malcolm Smith, MJ freelancing
REM          http://www.mjfreelancing.com
REM 
REM ****************************************************************************

computil SetupC11
if exist setenv.bat call setenv.bat
if exist setenv.bat del setenv.bat > nul
if (%NDC11%)==() goto enderror

if not exist %NDC11%\bin\dcc32.exe goto endnocompiler
if not exist ..\C11\*.* md ..\C11 > nul
if exist ..\C11\*.* call clean.bat ..\C11\

copy *Indy110.dpk ..\C11
copy *.pas ..\C11
copy *.obj ..\C11
copy *.inc ..\C11
copy *.res ..\C11
copy *.dcr ..\C11
copy *.rsp ..\C11
copy *Indy110.cfg1 ..\C11
copy *Indy110.cfg2 ..\C11

cd ..\C11


REM ************************************************************
REM Compile IndyCore110 - Round 1
REM ************************************************************
copy Indy110.cfg1 Indy110.cfg > nul
%NDC11%\bin\dcc32.exe /B Indy110.dpk
if errorlevel 1 goto enderror


REM ************************************************************
REM Compile IndyCore110 - Round 2
REM ************************************************************
del Indy110.cfg > nul
copy Indy110.cfg2 Indy110.cfg > nul
%NDC11%\bin\dcc32.exe /B Indy110.dpk
if errorlevel 1 goto enderror



REM ************************************************************
REM Compile dclIndyCore110 - Round 1
REM ************************************************************
copy dclIndy110.cfg1 dclIndy110.cfg > nul
%NDC11%\bin\dcc32.exe /B dclIndy110.dpk
if errorlevel 1 goto enderror


REM ************************************************************
REM Compile dclIndyCore110 - Round 2
REM ************************************************************
del dclIndy110.cfg > nul
copy dclIndy110.cfg2 dclIndy110.cfg > nul
%NDC11%\bin\dcc32.exe /B dclIndy110.dpk
if errorlevel 1 goto enderror



REM ************************************************************
REM Set all files we want to keep with the R attribute then 
REM delete the rest before restoring the attribute
REM ************************************************************
attrib +r Id*.hpp
attrib +r *.bpl
attrib +r Indy*.bpi
attrib +r Indy*.lib
attrib +r indy110.res
del /Q /A:-R *.*
attrib -r Id*.hpp
attrib -r *.bpl
attrib -r Indy*.bpi
attrib -r Indy*.lib
attrib -r indy110.res

goto endok

:enderror
echo Error!
goto endok

:endnocompiler
echo C++Builder 11 Compiler Not Present!
goto endok

:endok
cd ..\Source
