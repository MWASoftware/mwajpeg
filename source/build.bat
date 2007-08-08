REM Build File for JPEG Component Library
set CB5=c:\Program Files\Borland\cbuilder5
set CB6=c:\Program Files\Borland\cbuilder6
set D6=c:\Program Files\Borland\Delphi6
set D7=c:\Program Files\Borland\Delphi7
set D9=C:\Program Files\Borland\BDS\3.0
set D10=C:\Program Files\Borland\BDS\4.0
Set D11=C:\Program Files\CodeGear\RAD Studio\5.0
Set DEFS=

call :mkdir Units
call :mkdir Units\d6
call :mkdir Units\d7
call :mkdir Units\d9
call :mkdir Units\d10
call :mkdir Units\d11
call :mkdir Units\cb5
call :mkdir Units\cb6
call :mkdir Units\cb10
call :mkdir Packages
call :mkdir Packages\d6
call :mkdir Packages\d7
call :mkdir Packages\d9
call :mkdir Packages\d10
call :mkdir Packages\d11
call :mkdir Packages\cb5
call :mkdir Packages\cb6
call :mkdir Packages\QR
call :mkdir Packages\QR\d9
call :mkdir Packages\QR\d10
call :mkdir Packages\QR\d11
call :mkdir Packages\QRstd
call :mkdir Packages\QRstd\d10


rem MAKE Delphi 6

:D6
IF NOT EXIST "%D6%\bin\dcc32.exe" goto D7
"%D6%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;QREPORTS;%DEFS% /$D-,L-,Y-,R- /B /Z- /OObj /NUnits\D6 
IF ERRORLEVEL 1 goto Quit
move dclmwajpgD6.bpl Packages
del mwajpg.dcp

"%D6%\bin\dcc32" mwajpg.dpk /DNODLL;QREPORTS;%DEFS% /$D-,L-,Y-,R- /M /Z- /OObj /UUnits\D6 /NUnits\D6
IF ERRORLEVEL 1 goto Quit
move mwajpgd6.bpl Packages
move mwajpg.dcp Packages\D6\mwajpg.dcp
del Units\D6\jpegreg2.dcu Units\D6\mwajpg.dcu

rem MAKE Delphi 7

:D7
IF NOT EXIST "%D7%\bin\dcc32.exe" goto D9
"%D7%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;QREPORTS;%DEFS% /$D-,L-,Y-,R- /B /Z- /OObj /NUnits\D7 /LEPackages 
IF ERRORLEVEL 1 goto Quit
"%D7%\bin\dcc32" mwajpg.dpk /DNODLL;QREPORTS;%DEFS% /$D-,L-,Y-,R- /M /Z- /OObj /UUnits\D7 /NUnits\D7 /LEPackages /LNPackages\D7
IF ERRORLEVEL 1 goto Quit
del Units\D7\jpegreg2.dcu Units\D7\mwajpg.dcu

rem MAKE Delphi 2005

:D9
If NOT EXIST "%D9%\bin\QR4runDX.dcp" goto D9QRSTD
"%D9%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;QREPORTS;%DEFS% /$D-,L-,Y-,R- /B /Z- /LUQR4runDX -u"%D9%\bin" /OObj /NUnits\D9 /LNPackages\QR\D9 /LEPackages\QR
IF ERRORLEVEL 1 goto Quit
:D9STD
IF NOT EXIST "%D9%\bin\dcc32.exe" goto D10
"%D9%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;%DEFS% /$D-,L-,Y-,R- /B /Z- /OObj /NUnits\D9 /LEPackages
IF ERRORLEVEL 1 goto Quit
del mwajpg.dcp
"%D9%\bin\dcc32" mwajpg.dpk /DNODLL;%DEFS% /$D-,L-,Y-,R- /M /Z- /OObj /UUnits\D9 /NUnits\D9 /LNPackages\D9 /LEPackages
IF ERRORLEVEL 1 goto Quit
del Units\D9\jpegreg2.dcu Units\D9\mwajpg.dcu

rem MAKE Delphi 2006 

:D10
If NOT EXIST "%D10%\QuickRep\bpl\QR4runD2006.dcp" goto D10QRSTD
"%D10%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;QREPORTS;%DEFS% /$D-,L-,Y-,R- /B /Z- /LUQR4runD2006 -u"%D10%\QuickRep\bpl" /OObj /NUnits\D10 /LNPackages\QR\D10 /LEPackages\QR
IF ERRORLEVEL 1 goto Quit
:D10QRSTD
If NOT EXIST "%D10%\QRStandard\QR4StdRunD2006.dcp" goto D10QRSTD
"%D10%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;QREPORTS;%DEFS% /$D-,L-,Y-,R- /B /Z- /QR4StdRunD2006 -u"%D10%\QRStandard" /OObj /NUnits\D10 /LNPackages\QRstd\D10 /LEPackages\QRstd
IF ERRORLEVEL 1 goto Quit
:D10STD
IF NOT EXIST "%D10%\bin\dcc32.exe" goto D11
"%D10%\bin\dcc32" source\mwadbjpg.pas /DNODLL;CBUILDER;%DEFS% /$D-,L-,Y-,R- /JPHNE /B  /OObj  /N0Units\d10 /NHUnits\d10 /NOUnits\d10
"%D10%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;%DEFS% /$D-,L-,Y-,R- /OObj /M /Z- /UUnits\d10 /LEPackages 
IF ERRORLEVEL 1 goto Quit
del mwajpg.dcp
"%D10%\bin\dcc32" mwajpg.dpk /DNODLL;%DEFS% /$D-,L-,Y-,R- /M /Z- /OObj /UUnits\D10 /NUnits\D10 /LNPackages\D10 /LEPackages
IF ERRORLEVEL 1 goto Quit
del Units\D10\jpegreg2.dcu Units\D10\mwajpg.dcu

rem MAKE Delphi 2007

:D11
IF NOT EXIST "%D11%\bin\dcc32.exe" goto CB5

If NOT EXIST "%D11%\QuickRep\bpl\QR4runD2007.dcp" goto D11STD
"%D11%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;QREPORTS;%DEFS% /$D-,L-,Y-,R- /B /Z- /LUQR4runD2007 -u"%D11%\QuickRep\bpl" /OObj /NUnits\D11 /LNPackages\QR\D11 /LEPackages\QR
IF ERRORLEVEL 1 goto Quit
:D11STD
"%D11%\bin\dcc32" mwajpg.dpk /DDESIGNTIME;NODLL;%DEFS% /$D-,L-,Y-,R- /B /Z- /OObj /NUnits\D11 /LEPackages
IF ERRORLEVEL 1 goto Quit
del mwajpg.dcp
"%D11%\bin\dcc32" mwajpg.dpk /DNODLL;%DEFS% /$D-,L-,Y-,R- /M /Z- /OObj /UUnits\D11 /NUnits\D11 /LNPackages\D11 /LEPackages
IF ERRORLEVEL 1 goto Quit
del Units\D11\jpegreg2.dcu Units\D11\mwajpg.dcu



rem Make C++Builder 5.0 

:CB5
IF NOT EXIST "%CB5%\bin\dcc32.exe" goto CB6
rem compile jpeglib first in order to avoid bug
"%CB5%\bin\dcc32" -D_RTLDLL;USEPACKAGES;STATIC_LIBRARY;CBUILDER5;%DEFS% -Oobj -$Y -$W -$O-  -JPHN source\jpeglib.pas /N0Units\cb5 /NHUnits\cb5 /NO.
IF ERRORLEVEL 1 goto Quit
"%CB5%\bin\dcc32" -B -D_RTLDLL;USEPACKAGES;NODLL;CBUILDER5;%DEFS% -$Y -$W -$O- -Oobj  -JPN source\jpeglib.pas  /N0Units\cb5 /NHUnits\cb5 /NO.
IF ERRORLEVEL 1 goto Quit
rename source\jpeglib.pas _jpeglib.pas
"%CB5%\bin\make" -B PDEFS=DESIGNTIME;CBUILDER5;QREPORTS;%DEFS% DLLSTATE=NODLL -f mwajpg.mak -DB5 -DUNITDIR=Units\cb5
IF ERRORLEVEL 1 goto QUIT1
move mwajpg.bpl Packages\dclmwajpgcb5.bpl
del mwajpg.bpi
"%CB5%\bin\make" -B PDEFS=CBUILDER5;QREPORTS;%DEFS% DLLSTATE=NODLL -f mwajpg.mak -DB5 -DUNITDIR=Units\cb5 -DRUNTIME
IF ERRORLEVEL 1 goto QUIT1
rename source\_jpeglib.pas jpeglib.pas
del jpeg_reg.obj mwajpg.obj mwajpg.dcu mwajpg.tds mwajpg.lib
move mwajpg.bpl Packages\mwajpgcb5.bpl
move mwajpg.bpi Packages\cb5
move *.obj Units\cb5

:CB6

rem Make C++Builder 6.0 

IF NOT EXIST "%CB6%\bin\dcc32.exe" goto QUIT
rem compile jpeglib first in order to avoid bug
"%CB6%\bin\dcc32" -D_RTLDLL;USEPACKAGES;STATIC_LIBRARY;CBUILDER5;%DEFS% -Oobj -$Y -$W -$O-  -JPHN source\jpeglib.pas /N0Units\cb6 /NHUnits\cb6 /NO.
IF ERRORLEVEL 1 goto Quit
"%CB6%\bin\dcc32" -B -D_RTLDLL;USEPACKAGES;NODLL;CBUILDER5;%DEFS% -$Y -$W -$O- -Oobj  -JPN source\jpeglib.pas  /N0Units\cb6 /NHUnits\cb6 /NO.
IF ERRORLEVEL 1 goto Quit
rename source\jpeglib.pas _jpeglib.pas
"%CB6%\bin\make" -B PDEFS=DESIGNTIME;CBUILDER5;QREPORTS;%DEFS% DLLSTATE=NODLL -f mwajpg.mak -DB6 -DUNITDIR=Units\cb6
IF ERRORLEVEL 1 goto QUIT1
move mwajpg.bpl Packages\dclmwajpgcb6.bpl
del mwajpg.bpi
"%CB6%\bin\make" -B PDEFS=CBUILDER5;QREPORTS;%DEFS% DLLSTATE=NODLL -f mwajpg.mak -DB6 -DUNITDIR=Units\cb6 -DRUNTIME
IF ERRORLEVEL 1 goto QUIT1
rename source\_jpeglib.pas jpeglib.pas
del jpeg_reg.obj mwajpg.obj mwajpg.dcu mwajpg.tds mwajpg.lib
move mwajpg.bpl Packages\mwajpgcb6.bpl
move mwajpg.bpi Packages\cb6
move *.obj Units\cb6
goto :EOF
:QUIT1
rename source\_jpeglib.pas jpeglib.pas
del /Q *.obj
:QUIT
goto :EOF

:mkdir
if Exist "%1" goto Clear
mkdir "%1"
goto :EOF
:Clear
del /Q /S "%1\*.*"
goto :EOF
