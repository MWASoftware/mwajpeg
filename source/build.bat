REM Build File for JPEG Component Library
rem @echo off
set D1=c:\delphi
set D2=c:\Program Files\Borland\Delphi 2.0
set D3=c:\Program Files\Borland\Delphi 3
set D4=c:\Program Files\Borland\Delphi4
set D5=c:\Program Files\Borland\Delphi5
set D6=c:\Program Files\Borland\Delphi6
set D7=c:\Program Files\Borland\Delphi7
set D9=C:\Program Files\Borland\BDS\3.0
set D10=C:\Program Files\Borland\BDS\4.0
Set D11=C:\Program Files\CodeGear\RAD Studio\5.0
set CB1=c:\Program Files\Borland\cbuilder
set CB3=c:\Program Files\Borland\cbuilder3
set CB4=c:\Program Files\Borland\cbuilder4
set CB5=c:\Program Files\Borland\cbuilder5
set CB6=c:\Program Files\Borland\cbuilder6
Set DEFS=
touch source\cbuilder\mwaQRjpg.cpp

IF NOT EXIST "%D1%\bin\dcc.exe" goto D2
rem
rem MAKE 16-bit DELPHI COMPONENTS
rem
call :mkdir Units\d1
"%D1%\bin\dcc" Source\jpegreg1 /$D-,L-,Y- /USource /B /EUnits\d1
IF ERRORLEVEL 1 goto Quit
copy source\jpegreg1.pas Units\d1
copy source\jpgreg16.dcr Units\d1

rem
rem MAKE 32-bit Delphi 2.0  COMPONENTS
rem
:D2
IF NOT EXIST "%D2%\bin\dcc32.exe" goto D3
call :mkdir Units\d2
"%D2%\bin\dcc32" Source\jpegreg2 /$D-,L-,Y- /B /USource  /NUnits\d2
IF ERRORLEVEL 1 goto Quit
copy source\jpegreg1.pas units\d2
copy source\jpegreg2.pas units\d2
copy source\jpeg_reg.dcr units\d2

rem MAKE 32-bit Delphi 3.0 COMPONENTS

:D3
IF NOT EXIST "%D3%\bin\dcc32.exe" goto D4
call :mkdir Units\d3
call :mkdir Packages\d3
copy /Y mwajpg.cfg archive\mwajpg30.cfg
copy /Y mwajpg.res archive\mwajpg30.res
"%D3%\bin\dcc32" archive\mwajpg30.dpk /$D-,L-,Y- /DDESIGNTIME /OObj /USource /Nunits\d3 /LN. /LEPackages
IF ERRORLEVEL 1 goto Quit2
rename Packages\mwajpg30.dpl dclmwajpg30.dpl
move mwajpg30.dcp Packages\D3\dclmwajpg30.dcp
"%D3%\bin\dcc32" archive\mwajpg30.dpk /$D-,L-,Y- /USource /Rsource /OObj /LNPackages/d3 /Nunits\d3 /LEPackages 
IF ERRORLEVEL 1 goto Quit2

rem MAKE Delphi 4 

:D4
IF NOT EXIST "%D4%\bin\dcc32.exe" goto D5
call :mkdir Units\d4
call :mkdir Packages\d4
copy /Y mwajpg.cfg archive\mwajpg40.cfg
copy /Y mwajpg.res archive\mwajpg40.res
"%D4%\bin\dcc32" archive\mwajpg40.dpk /$D-,L-,Y- /DDESIGNTIME /OObj /Usource /NUnits\d4 /RSource  /LN. /LEPackages
IF ERRORLEVEL 1 goto Quit2
rename Packages\mwajpg40.bpl dclmwajpg40.bpl
move mwajpg40.dcp Packages\D4\dclmwajpg40.dcp
"%D4%\bin\dcc32" archive\mwajpg40.dpk /$D-,L-,Y- /Usource /NUnits\d4  /OObj /LNPackages\d4 /LEPackages
IF ERRORLEVEL 1 goto Quit2

rem MAKE Delphi 5 

:D5
IF NOT EXIST "%D5%\bin\dcc32.exe" goto D6
call :mkdir Units\d5
call :mkdir Packages\d5
copy /Y mwajpg.cfg archive\mwajpg50.cfg
copy /Y mwajpg.res archive\mwajpg50.res
"%D5%\bin\dcc32" archive\mwajpg50.dpk /$D-,L-,Y- /DDESIGNTIME /OObj /Usource /NUnits\d5 /RSource  /LN. /LEPackages
IF ERRORLEVEL 1 goto Quit
rename Packages\mwajpg50.bpl dclmwajpg50.bpl
move mwajpg50.dcp Packages\D5\dclmwajpg50.dcp
"%D5%\bin\dcc32" archive\mwajpg50.dpk /$D-,L-,Y- /Usource /NUnits\d5 /OObj /RSource /LNPackages\d5 /LEPackages
IF ERRORLEVEL 1 goto Quit


rem MAKE Delphi 6

:D6
IF NOT EXIST "%D6%\bin\dcc32.exe" goto D7
call :mkdir Units\d6
call :mkdir Packages\d6
"%D6%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;QREPORTS;%DEFS% /LUqrpt /$D-,L-,Y-,R- /B /Z- /OObj /NUnits\D6 
IF ERRORLEVEL 1 goto Quit
move dclmwajpgD6.bpl Packages
move mwajpg.dcp Packages\D6\dclmwajpg.dcp

"%D6%\bin\dcc32" mwajpg.dpk /DNODLL;%DEFS% /$D-,L-,Y-,R- /B /Z- /OObj /UUnits\D6 /NUnits\D6
IF ERRORLEVEL 1 goto Quit
move mwajpgd6.bpl Packages
move mwajpg.dcp Packages\D6\mwajpg.dcp
del Units\D6\jpegreg2.dcu Units\D6\mwajpg.dcu

rem MAKE Delphi 7

:D7
IF NOT EXIST "%D7%\bin\dcc32.exe" goto D9
call :mkdir Units\d7
call :mkdir Packages\d7
"%D7%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;QREPORTS;%DEFS% /LUqrpt /$D-,L-,Y-,R- /B /Z- /OObj /NUnits\D7 /LEPackages 
IF ERRORLEVEL 1 goto Quit
move mwajpg.dcp Packages\D7\dclmwajpg.dcp
"%D7%\bin\dcc32" mwajpg.dpk /DNODLL;%DEFS% /$D-,L-,Y-,R- /B /Z- /OObj /UUnits\D7 /NUnits\D7 /LEPackages /LNPackages\D7
IF ERRORLEVEL 1 goto Quit
del Units\D7\jpegreg2.dcu Units\D7\mwajpg.dcu

rem MAKE Delphi 2005

:D9
IF NOT EXIST "%D9%\bin\dcc32.exe" goto D10
call :mkdir Units\d9
call :mkdir Packages\d9
If NOT EXIST "%D9%\bin\QR4runDX.dcp" goto D9QRSTD
call :mkdir Packages\QR\d9
"%D9%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;QREPORTS;%DEFS% /$D-,L-,Y-,R- /B /Z- /LUQR4DesignDX -u"%D9%\bin" /OObj /NUnits\D9  /LEPackages\QR
IF ERRORLEVEL 1 goto Quit
move mwajpg.dcp Packages\QR\D9\dclmwajpg.dcp
:D9STD
"%D9%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;%DEFS% /$D-,L-,Y-,R- /B /Z- /OObj /NUnits\D9 /LEPackages
IF ERRORLEVEL 1 goto Quit
move mwajpg.dcp Packages\D9\dclmwajpg.dcp
"%D9%\bin\dcc32" mwajpg.dpk /DNODLL;%DEFS% /$D-,L-,Y-,R- /B /Z- /OObj /UUnits\D9 /NUnits\D9 /LNPackages\D9 /LEPackages
IF ERRORLEVEL 1 goto Quit
del Units\D9\jpegreg2.dcu Units\D9\mwajpg.dcu

rem MAKE BDS 2006 

:D10
IF NOT EXIST "%D10%\bin\dcc32.exe" goto D11
call :mkdir Units\d10
call :mkdir Packages\d10
If NOT EXIST "%D10%\QuickRep\bpl\QR4runD2006.dcp" goto D10QRSTD
call :mkdir Packages\QR\d10
"%D10%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;QREPORTS;%DEFS% /$D-,L-,Y-,R- /B /Z- /JL /LUQR4DesignD2006 -u"%D10%\QuickRep\bpl" /OObj /NUnits\D10  /LEPackages\QR
IF ERRORLEVEL 1 goto Quit
move mwajpg.dcp Packages\QR\D10\dclmwajpg.dcp
move mwajpg.bpi Packages\QR\D10\dclmwajpg.bpi
move mwajpg.lib Packages\QR\D10\dclmwajpg.lib
:D10QRSTD
If NOT EXIST "%D10%\QRStandard\QR4StdRunD2006.dcp" goto D10STD
call :mkdir Packages\QRstd
call :mkdir Packages\QRstd\d10
"%D10%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;QREPORTS;%DEFS% /$D-,L-,Y-,R- /B /Z- /JL /LUQR4StdDesD2006 -u"%D10%\QRStandard" /OObj /NUnits\D10  /LEPackages\QRstd
IF ERRORLEVEL 1 goto Quit
move mwajpg.dcp Packages\QRstd\D10\dclmwajpg.dcp
move mwajpg.bpi Packages\QRstd\D10\dclmwajpg.bpi
move mwajpg.lib Packages\QRstd\D10\dclmwajpg.lib
:D10STD
"%D10%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;%DEFS% /$D-,L-,Y-,R- /OObj /B /Z- /JL /UUnits\d10 /NUnits\D10 /LEPackages 
IF ERRORLEVEL 1 goto Quit
move mwajpg.dcp Packages\D10\dclmwajpg.dcp
move mwajpg.bpi Packages\D10\dclmwajpg.bpi
move mwajpg.lib Packages\D10\dclmwajpg.lib
"%D10%\bin\dcc32" mwajpg.dpk /DNODLL;%DEFS% /$D-,L-,Y-,R- /B /Z- /OObj /UUnits\D10 /NUnits\D10 /JL /LNPackages\D10 /LEPackages /NBPackages\D10
IF ERRORLEVEL 1 goto Quit
move mwajpg.lib Packages\D10\mwajpg.lib
del Units\D10\jpegreg2.dcu Units\D10\mwajpg.dcu
"%D10%\bin\dcc32" source\mwadbjpg.pas /DNODLL;%DEFS% /$D-,L-,Y-,R- /JPHNE /B  /OObj  /N0Units\d10 /NHUnits\d10 /NOUnits\d10
IF ERRORLEVEL 1 goto Quit
"%D10%\bin\dcc32" source\jpeglib.pas /DNODLL;CBUILDER;%DEFS% /$D-,L-,Y-,R- /JPHNE /B  /OObj  /N0. /NHUnits\d10 /NOUnits\d10
IF ERRORLEVEL 1 goto Quit
del jpeglib.dcu
rem MAKE Delphi 2007

:D11
IF NOT EXIST "%D11%\bin\dcc32.exe" goto CB1
call :mkdir Units\d11
call :mkdir Packages\d11

If NOT EXIST "%D11%\QuickRep\bpl\QR4runD2007.dcp" goto D11STD
call :mkdir Packages\QR\d11
"%D11%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;QREPORTS;%DEFS% /$D-,L-,Y-,R- /B /Z- /LUQR4DesignD2007 -u"%D11%\QuickRep\bpl" /OObj /NUnits\D11  /LEPackages\QR
IF ERRORLEVEL 1 goto Quit
move mwajpg.dcp Packages\QR\D11\dclmwajpg.dcp
:D11STD
"%D11%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;%DEFS% /$D-,L-,Y-,R- /B /Z- /OObj /NUnits\D11 /LEPackages 
IF ERRORLEVEL 1 goto Quit
move mwajpg.dcp Packages\D11\dclmwajpg.dcp
"%D11%\bin\dcc32" mwajpg.dpk /DNODLL;%DEFS% /$D-,L-,Y-,R- /B /Z- /OObj /UUnits\D11 /NUnits\D11 /LNPackages\D11 /LEPackages
IF ERRORLEVEL 1 goto Quit
del Units\D11\jpegreg2.dcu Units\D11\mwajpg.dcu

rem
rem Make C++ Builder 
rem
:CB1
IF NOT EXIST "%CB1%\bin\dcc32.exe" goto CB3
call :mkdir Units\cb1
"%CB1%\bin\dcc32" Source\jpegreg2.pas /$D-,L-,Y- /OObj /USource /ISource /B /JPHN /NUnits\cb1
IF ERRORLEVEL 1 goto QUIT1
copy source\cbuilder\jpeg_reg.cpp units\cb1
copy source\jpeg_reg.dcr units\cb1
move Source\*.hpp Units\cb1
move Source\*.obj Units\cb1

rem Make C++ Builder 3

:CB3
IF NOT EXIST "%CB3%\bin\dcc32.exe" goto CB4
call :mkdir Units\cb3
call :mkdir Packages\cb3
rem compile jpeglib first in order to avoid bug
"%CB3%\bin\dcc32" -D_RTLDLL;USEPACKAGES;STATIC_LIBRARY;%DEFS% -Oobj -$Y -$W -$O-  -JPHN source\jpeglib.pas /NUnits\cb3 
IF ERRORLEVEL 1 goto Quit
"%CB3%\bin\dcc32" -B -D_RTLDLL;USEPACKAGES;NODLL;%DEFS% -$Y -$W -$O- -Oobj  -JPN source\jpeglib.pas  /NUnits\cb3 
IF ERRORLEVEL 1 goto Quit
Move source\*.hpp units\cb3
Move source\*.obj units\cb3
rename source\jpeglib.pas _jpeglib.pas
Set BCB=%CB3%
"%CB3%\bin\make" -B  -f mwajpg.mak -DB3 -DUNITDIR=Units\cb3
IF ERRORLEVEL 1 goto QUIT1
move mwajpg.bpl Packages\dclmwajpgcb3.bpl
move mwajpg.bpi Packages\cb3\dclmwajpg.bpi
"%CB3%\bin\make" -B -f mwajpg.mak -DB3 -DUNITDIR=Units\cb3 -DRUNTIME
IF ERRORLEVEL 1 goto QUIT1
rename source\_jpeglib.pas jpeglib.pas
move source\*.obj units\cb3
move source\*.hpp units\cb3
del  mwajpg.dcu mwajpg.tds 
move mwajpg.bpl Packages\mwajpgcb3.bpl
move mwajpg.bpi Packages\cb3
move mwajpg.lib Packages\cb3
move *.obj Units\cb3

rem Make C++ Builder 4

:CB4
IF NOT EXIST "%CB4%\bin\dcc32.exe" goto CB5
call :mkdir Units\cb4
call :mkdir Packages\cb4
rem compile jpeglib first in order to avoid bug
"%CB4%\bin\dcc32" -D_RTLDLL;USEPACKAGES;STATIC_LIBRARY;%DEFS% -Oobj -$Y -$W -$O-  -JPHN source\jpeglib.pas /NUnits\cb4 
IF ERRORLEVEL 1 goto Quit
"%CB4%\bin\dcc32" -B -D_RTLDLL;USEPACKAGES;NODLL;%DEFS% -$Y -$W -$O- -Oobj  -JPN source\jpeglib.pas  /NUnits\cb4 
IF ERRORLEVEL 1 goto Quit
Move source\*.hpp units\cb4
Move source\*.obj units\cb4
rename source\jpeglib.pas _jpeglib.pas
Set BCB=%CB4%
"%CB4%\bin\make" -B  -f mwajpg.mak -DB4 -DUNITDIR=Units\cb4
IF ERRORLEVEL 1 goto QUIT1
move mwajpg.bpl Packages\dclmwajpgcb4.bpl
move mwajpg.bpi Packages\cb4\dclmwajpg.bpi
"%CB4%\bin\make" -B -f mwajpg.mak -DB4 -DUNITDIR=Units\cb4 -DRUNTIME
IF ERRORLEVEL 1 goto QUIT1
rename source\_jpeglib.pas jpeglib.pas
move source\*.obj units\cb4
move source\*.hpp units\cb4
del mwajpg.dcu mwajpg.tds 
move mwajpg.bpl Packages\mwajpgcb4.bpl
move mwajpg.bpi Packages\cb4
move mwajpg.lib Packages\cb4
move *.obj Units\cb4


rem Make C++Builder 5.0 

:CB5
IF NOT EXIST "%CB5%\bin\dcc32.exe" goto CB6
call :mkdir Units\cb5
call :mkdir Packages\cb5
rem compile jpeglib first in order to avoid bug
"%CB5%\bin\dcc32" -D_RTLDLL;USEPACKAGES;STATIC_LIBRARY;CBUILDER5;%DEFS% -Oobj -$Y -$W -$O-  -JPHN source\jpeglib.pas /N0Units\cb5 /NHUnits\cb5 /NO.
IF ERRORLEVEL 1 goto Quit
"%CB5%\bin\dcc32" -B -D_RTLDLL;USEPACKAGES;NODLL;CBUILDER5;%DEFS% -$Y -$W -$O- -Oobj  -JPN source\jpeglib.pas  /N0Units\cb5 /NHUnits\cb5 /NO.
IF ERRORLEVEL 1 goto Quit
rename source\jpeglib.pas _jpeglib.pas
"%CB5%\bin\make" -B PDEFS=%DEFS% DLLSTATE=NODLL -f mwajpg.mak -DB5 -DUNITDIR=Units\cb5
IF ERRORLEVEL 1 goto QUIT1

move mwajpg.bpl Packages\dclmwajpgcb5.bpl
move mwajpg.bpi Packages\cb5\dclmwajpg.bpi
Set BCB=%CB5%
"%CB5%\bin\make" -B PDEFS=%DEFS% DLLSTATE=NODLL -f mwajpg.mak -DB5 -DUNITDIR=Units\cb5 -DRUNTIME
IF ERRORLEVEL 1 goto QUIT1
rename source\_jpeglib.pas jpeglib.pas
del jpeg_reg.obj mwajpg.obj mwajpg.dcu mwajpg.tds 
move mwajpg.bpl Packages\mwajpgcb5.bpl
move mwajpg.bpi Packages\cb5
move mwajpg.lib Packages\cb5
move *.obj Units\cb5

:CB6

rem Make C++Builder 6.0 

IF NOT EXIST "%CB6%\bin\dcc32.exe" goto QUIT
call :mkdir Units\cb6
call :mkdir Packages\cb6
rem compile jpeglib first in order to avoid bug
"%CB6%\bin\dcc32" -D_RTLDLL;USEPACKAGES;STATIC_LIBRARY;CBUILDER5;%DEFS% -Oobj -$Y -$W -$O-  -JPHN source\jpeglib.pas /N0Units\cb6 /NHUnits\cb6 /NO.
IF ERRORLEVEL 1 goto Quit
"%CB6%\bin\dcc32" -B -D_RTLDLL;USEPACKAGES;NODLL;CBUILDER5;%DEFS% -$Y -$W -$O- -Oobj  -JPN source\jpeglib.pas  /N0Units\cb6 /NHUnits\cb6 /NO.
IF ERRORLEVEL 1 goto Quit
rename source\jpeglib.pas _jpeglib.pas
Set BCB=%CB6%
"%CB6%\bin\make" -B PDEFS=%DEFS% DLLSTATE=NODLL -f mwajpg.mak -DB6 -DUNITDIR=Units\cb6
IF ERRORLEVEL 1 goto QUIT1
move mwajpg.bpl Packages\dclmwajpgcb6.bpl
move mwajpg.bpi Packages\cb6\dclmwajpg.bpi
"%CB6%\bin\make" -B PDEFS=%DEFS% DLLSTATE=NODLL -f mwajpg.mak -DB6 -DUNITDIR=Units\cb6 -DRUNTIME
IF ERRORLEVEL 1 goto QUIT1
rename source\_jpeglib.pas jpeglib.pas
del jpeg_reg.obj mwajpg.obj mwajpg.dcu mwajpg.tds
move mwajpg.bpl Packages\mwajpgcb6.bpl
move mwajpg.bpi Packages\cb6
move mwajpg.lib Packages\cb6
move *.obj Units\cb6
goto QUIT
:QUIT1
rename source\_jpeglib.pas jpeglib.pas
del /Q *.obj
:QUIT
pause
goto :EOF

:mkdir
if Exist "%1" goto Clear
mkdir "%1"
goto :EOF
:Clear
del /Q /S "%1\*.*"
goto :EOF
