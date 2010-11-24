@echo off

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

cd ..\C11
REM ***************************************************
REM Compile Runtime Package Indy110
REM ***************************************************
REM IdCompressionIntercept can never be built as part of a package.  It has to be compiled separately
REM due to a DCC32 bug.
%NDC11%\bin\dcc32.exe IdCompressionIntercept.pas /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4

%NDC11%\bin\dcc32.exe Indy110.dpk /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
%NDC11%\bin\dcc32.exe IdDummyUnit.pas /LIndy110.dcp /DBCB /O..\Source\objs /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
del IdDummyUnit.dcu > nul
del IdDummyUnit.hpp > nul
del IdDummyUnit.obj > nul

%NDC11%\bin\dcc32.exe Indy110.dpk /M /DBCB /O..\Source\objs /H /W -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror

REM ***************************************************
REM Create .LIB file
REM ***************************************************
echo Creating Indy110.LIB file, please wait...
%NDC11%\bin\tlib.exe Indy110.lib /P32 @IndyWin32.rsp > nul
if exist ..\C11\Indy110.bak del ..\C11\Indy110.bak > nul

REM ***************************************************
REM Compile Design-time Package RPDT30
REM ***************************************************
%NDC11%\bin\dcc32.exe dclIndy110.dpk /DBCB /O..\Source\objs /H /W /N..\C11 /LIndy110.dcp -$d-l-n+p+r-s-t-w-y- %2 %3 %4
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
echo Compiler Not Present!
goto endok

:endok
cd ..\Source
