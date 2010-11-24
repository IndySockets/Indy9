@echo off

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

cd ..\C10
REM ***************************************************
REM Compile Runtime Package Indy100
REM ***************************************************
REM IdCompressionIntercept can never be built as part of a package.  It has to be compiled separately
REM due to a DCC32 bug.
%NDC10%\bin\dcc32.exe IdCompressionIntercept.pas /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4

%NDC10%\bin\dcc32.exe Indy100.dpk /O..\Source\objs /DBCB /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
%NDC10%\bin\dcc32.exe IdDummyUnit.pas /LIndy100.dcp /DBCB /O..\Source\objs /M /H /W /JPHN -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror
del IdDummyUnit.dcu > nul
del IdDummyUnit.hpp > nul
del IdDummyUnit.obj > nul

%NDC10%\bin\dcc32.exe Indy100.dpk /M /DBCB /O..\Source\objs /H /W -$d-l-n+p+r-s-t-w-y- %2 %3 %4
if errorlevel 1 goto enderror

REM ***************************************************
REM Create .LIB file
REM ***************************************************
echo Creating Indy100.LIB file, please wait...
%NDC10%\bin\tlib.exe Indy100.lib /P32 @IndyWin32.rsp > nul
if exist ..\C10\Indy100.bak del ..\C10\Indy100.bak > nul

REM ***************************************************
REM Compile Design-time Package RPDT30
REM ***************************************************
%NDC10%\bin\dcc32.exe dclIndy100.dpk /DBCB /O..\Source\objs /H /W /N..\C10 /LIndy100.dcp -$d-l-n+p+r-s-t-w-y- %2 %3 %4
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
