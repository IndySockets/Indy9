@echo off

computil SetupC6
if exist setenv.bat call setenv.bat
if exist setenv.bat del  setenv.bat > nul
if (%NDC6%)==() goto enderror

if not exist %NDC6%\bin\dcc32.exe goto endnocompiler
if not exist ..\C6\*.* md ..\C6 > nul
if exist ..\C6\*.* call clean.bat ..\C6\

copy *Indy60.dpk ..\C6
copy *.pas ..\C6
copy *.obj ..\C6
copy *.inc ..\C6
copy *.res ..\C6
copy *.dcr ..\C6
copy *.rsp ..\C6

cd ..\C6
REM ***************************************************
REM Compile Runtime Package Indy60
REM ***************************************************
REM IdCompressionIntercept can never be built as part of a package.  It has to be compiled separately
REM due to a DCC32 bug.
%NDC6%\bin\dcc32.exe IdCompressionIntercept.pas /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4

%NDC6%\bin\dcc32.exe Indy60.dpk /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
%NDC6%\bin\dcc32.exe IdDummyUnit.pas /LIndy60.dcp /DBCB /O..\Source\objs /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
del IdDummyUnit.dcu > nul
del IdDummyUnit.hpp > nul
del IdDummyUnit.obj > nul

%NDC6%\bin\dcc32.exe Indy60.dpk /M /DBCB /O..\Source\objs /H /W -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror

REM ***************************************************
REM Create .LIB file
REM ***************************************************
echo Creating Indy60.LIB file, please wait...
%NDC6%\bin\tlib.exe Indy60.lib /P32 @IndyWin32.rsp > nul
if exist ..\C6\Indy60.bak del ..\C6\Indy60.bak > nul

REM ***************************************************
REM Compile Design-time Package RPDT30
REM ***************************************************
%NDC6%\bin\dcc32.exe dclIndy60.dpk /DBCB /O..\Source\objs /H /W /N..\C6 /LIndy60.dcp -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror

REM ************************************************************
REM Set all files we want to keep with the R attribute then 
REM delete the rest before restoring the attribute
REM ************************************************************
attrib +r Id*.hpp
attrib +r *.bpl
attrib +r Indy*.bpi
attrib +r Indy*.lib
attrib +r indy60.res
del /Q /A:-R *.*
attrib -r Id*.hpp
attrib -r *.bpl
attrib -r Indy*.bpi
attrib -r Indy*.lib
attrib -r indy60.res

goto endok

:enderror
echo Error!
goto endok

:endnocompiler
echo C++Builder 6 Compiler Not Present!
goto endok

:endok
cd ..\Source
