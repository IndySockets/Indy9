@echo off

REM ****************************************************************************
REM 
REM Author : Malcolm Smith, MJ freelancing
REM          http://www.mjfreelancing.com
REM 
REM ****************************************************************************

computil SetupC10
if exist setenv.bat call setenv.bat
if exist setenv.bat del setenv.bat > nul
if (%NDC10%)==() goto enderror

if not exist %NDC10%\bin\dcc32.exe goto endnocompiler
if not exist ..\C10\*.* md ..\C10 > nul
if exist ..\C10\*.* call clean.bat ..\C10\

copy *Indy100.dpk ..\C10
copy *.pas ..\C10
copy *.obj ..\C10
copy *.inc ..\C10
copy *.res ..\C10
copy *.dcr ..\C10
copy *.rsp ..\C10
copy *Indy100.cfg1 ..\C10
copy *Indy100.cfg2 ..\C10

cd ..\C10


REM ************************************************************
REM Compile IndyCore100 - Round 1
REM ************************************************************
copy Indy100.cfg1 Indy100.cfg > nul
%NDC10%\bin\dcc32.exe /B Indy100.dpk
if errorlevel 1 goto enderror


REM ************************************************************
REM Compile IndyCore100 - Round 2
REM ************************************************************
del Indy100.cfg > nul
copy Indy100.cfg2 Indy100.cfg > nul
%NDC10%\bin\dcc32.exe /B Indy100.dpk
if errorlevel 1 goto enderror



REM ************************************************************
REM Compile dclIndyCore100 - Round 1
REM ************************************************************
copy dclIndy100.cfg1 dclIndy100.cfg > nul
%NDC10%\bin\dcc32.exe /B dclIndy100.dpk
if errorlevel 1 goto enderror


REM ************************************************************
REM Compile dclIndyCore100 - Round 2
REM ************************************************************
del dclIndy100.cfg > nul
copy  dclIndy100.cfg2 dclIndy100.cfg > nul
%NDC10%\bin\dcc32.exe /B dclIndy100.dpk
if errorlevel 1 goto enderror



REM ************************************************************
REM Set all files we want to keep with the R attribute then 
REM delete the rest before restoring the attribute
REM ************************************************************
attrib +r Id*.hpp
attrib +r *.bpl
attrib +r Indy*.bpi
attrib +r Indy*.lib
attrib +r indy100.res
del /Q /A:-R *.*
attrib -r Id*.hpp
attrib -r *.bpl
attrib -r Indy*.bpi
attrib -r Indy*.lib
attrib -r indy100.res

goto endok

:enderror
echo Error!
goto endok

:endnocompiler
echo C++Builder 10 Compiler Not Present!
goto endok

:endok
cd ..\Source
