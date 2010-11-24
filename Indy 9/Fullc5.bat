@echo off

computil SetupC5
if exist setenv.bat call setenv.bat
if exist setenv.bat del setenv.bat > nul

if (%NDC5%)==() goto enderror
if not exist %NDC5%\bin\dcc32.exe goto endnocompiler
if not exist ..\C5\*.* md ..\C5 > nul
if exist ..\C5\*.* call clean.bat ..\C5\

copy *Indy50.dpk ..\C5
copy *.pas ..\C5
copy *.obj ..\C5
copy *.inc ..\C5
copy *.res ..\C5
copy *.dcr ..\C5
copy *.rsp ..\C5

cd ..\C5
REM ***************************************************
REM Compile Runtime Package Indy50
REM ***************************************************
REM IdCompressionIntercept can never be built as part of a package.  It has to be compiled separately
REM due to a DCC32 bug.
%NDC5%\bin\dcc32.exe IdCompressionIntercept.pas /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4

%NDC5%\bin\dcc32.exe Indy50.dpk /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
%NDC5%\bin\dcc32.exe IdDummyUnit.pas /LIndy50.dcp /DBCB /O..\Source\objs /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
del IdDummyUnit.dcu > nul
del IdDummyUnit.hpp > nul
del IdDummyUnit.obj > nul

%NDC5%\bin\dcc32.exe Indy50.dpk /M /DBCB /O..\Source\objs /H /W -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror

REM ***************************************************
REM Create .LIB file
REM ***************************************************
echo Creating Indy50.LIB file, please wait...
%NDC5%\bin\tlib.exe Indy50.lib /P32 @IndyWin32.rsp > nul
if exist ..\C5\Indy50.bak del ..\C5\Indy50.bak > nul

REM ***************************************************
REM Compile Design-time Package RPDT30
REM ***************************************************
%NDC5%\bin\dcc32.exe dclIndy50.dpk /DBCB /O..\Source\objs /H /W /N..\C5 /LIndy50.dcp -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror


REM ************************************************************
REM Set all files we want to keep with the R attribute then 
REM delete the rest before restoring the attribute
REM ************************************************************
attrib +r Id*.hpp
attrib +r *.bpl
attrib +r Indy*.bpi
attrib +r Indy*.lib
attrib +r indy50.res
del /Q /A:-R *.*
attrib -r Id*.hpp
attrib -r *.bpl
attrib -r Indy*.bpi
attrib -r Indy*.lib
attrib -r indy50.res

goto endok

:enderror
echo Error!
goto endok

:endnocompiler
echo C++Builder 5 Compiler Not Present!
goto endok

:endok
cd ..\Source
