REM This script makes the JPEG Component Library
Call SetConfig
Buildno
updttext version.txt source\mwajpg.rc %major% %minor% %step% @BuildNo.dat %year%
IF ERRORLEVEL 1 goto Quit
"%BRCC%\bin\brcc32" -i"%BRCC%\include" -dWIN32 source\mwajpg.rc
IF ERRORLEVEL 1 goto Quit
%hc32% /c /m /e help\mwjpeg.hpj
%hc32% /c /m /e help\mwjpegcb.hpj

cd source
del mwajpg.rc
Call Build.bat
IF ERRORLEVEL 1 goto QUIT1
rem
rem MAKE 16-bit DELPHI COMPONENTS
rem
IF NOT EXIST "%D1%\bin\dcc.exe" goto D2
call :mkdir evaluationUnits\d1
"%D1%\bin\dcc" Source\jpegreg1 /DDELPHI_REQUIRED /$D-,L-,Y- /USource /B 
IF ERRORLEVEL 1 goto Quit1
move source\*.dcu evaluationUnits\d1

rem
rem MAKE 32-bit Delphi 2.0  COMPONENTS
rem
:D2
IF NOT EXIST "%D2%\bin\dcc32.exe" goto D3
call :mkdir evaluationUnits\d2
"%D2%\bin\dcc32" Source\jpegreg2 /DDELPHI_REQUIRED /$D-,L-,Y- /B /USource  /NevaluationUnits\d2
IF ERRORLEVEL 1 goto Quit1

rem MAKE 32-bit Delphi 3.0 COMPONENTS

:D3
IF NOT EXIST "%D3%\bin\dcc32.exe" goto D4
call :mkdir evaluationUnits\d3
"%D3%\bin\dcc32" Source\jpegreg2 /DDELPHI_REQUIRED /$D-,L-,Y- /B /OObj /USource  /NevaluationUnits\d3
IF ERRORLEVEL 1 goto Quit1

rem MAKE Delphi 4 

:D4
IF NOT EXIST "%D4%\bin\dcc32.exe" goto D5
call :mkdir evaluationUnits\d4
"%D4%\bin\dcc32" Source\jpegreg2 /DDELPHI_REQUIRED /$D-,L-,Y- /B /OObj /USource  /NevaluationUnits\d4
IF ERRORLEVEL 1 goto Quit1

rem MAKE Delphi 5 

:D5
IF NOT EXIST "%D5%\bin\dcc32.exe" goto D6
call :mkdir evaluationUnits\d5
"%D4%\bin\dcc32" Source\jpegreg2 /DDELPHI_REQUIRED /$D-,L-,Y- /B /OObj /USource  /NevaluationUnits\d5
IF ERRORLEVEL 1 goto Quit1


rem MAKE Delphi 6

:D6
IF NOT EXIST "%D6%\bin\dcc32.exe" goto D7
call :mkdir evaluationUnits\d6
"%D6%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL /$D-,L-,Y-,R- /B /Z- /OObj /NevaluationUnits\D6 
IF ERRORLEVEL 1 goto QUIT1

rem MAKE Delphi 7

:D7
IF NOT EXIST "%D7%\bin\dcc32.exe" goto D9
call :mkdir evaluationUnits\d7
"%D7%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL /$D-,L-,Y-,R- /B /Z- /OObj /NevaluationUnits\D7 
IF ERRORLEVEL 1 goto QUIT1

rem MAKE Delphi 2005

:D9

IF NOT EXIST "%D9%\bin\dcc32.exe" goto D10
call :mkdir evaluationUnits\d9
"%D9%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL /$D-,L-,Y-,R- /B /Z- /OObj /NevaluationUnits\D9 
IF ERRORLEVEL 1 goto QUIT1

rem MAKE BDS 2006

:D10
call :mkdir evaluationUnits\d10
IF NOT EXIST "%D10%\bin\dcc32.exe" goto D11
"%D10%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL /$D-,L-,Y-,R- /JPHNE /B /Z- /OObj /N0evaluationUnits\D10 /NOevaluationUnits\D10 /NHevaluationUnits\D10 
IF ERRORLEVEL 1 goto QUIT1
"%D10%\bin\dcc32" source\jpeglib.pas /DDELPHI_REQUIRED;NODLL;CBUILDER; /$D-,L-,Y-,R- /JPHNE /B /Z- /OObj /N0. /NOevaluationUnits\D10 /NHevaluationUnits\D10 
IF ERRORLEVEL 1 goto QUIT1
del jpeglib.dcu

rem MAKE Delphi 2007

:D11
call :mkdir evaluationUnits\d11
IF NOT EXIST "%D11%\bin\dcc32.exe" goto CB5
"%D11%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL /$D-,L-,Y-,R- /JPHNE /B /Z- /OObj /N0evaluationUnits\D11 /NOevaluationUnits\D11 /NHevaluationUnits\D11 
IF ERRORLEVEL 1 goto QUIT1
"%D11%\bin\dcc32" source\jpeglib.pas /DDELPHI_REQUIRED;NODLL;CBUILDER; /$D-,L-,Y-,R- /JPHNE /B /Z- /OObj /N0. /NOevaluationUnits\D11 /NHevaluationUnits\D11
IF ERRORLEVEL 1 goto QUIT1
del jpeglib.dcu

rem Make C++ Builder 
rem
:CB1
IF NOT EXIST "%CB1%\bin\dcc32.exe" goto CB3
call :mkdir evaluationUnits\cb1
"%CB1%\bin\dcc32" Source\jpegreg2 /$D-,L-,Y- /DDELPHI_REQUIRED /OObj /USource /ISource /B /JPHN /NevaluationUnits\cb1
IF ERRORLEVEL 1 goto QUIT1
move Source\*.hpp evaluationUnits\cb1
move Source\*.obj evaluationUnits\cb1

rem Make C++ Builder 3
rem
:CB3
IF NOT EXIST "%CB3%\bin\dcc32.exe" goto CB4
call :mkdir evaluationUnits\cb3
"%CB3%\bin\dcc32" Source\jpegreg2 /$D-,L-,Y- /DDELPHI_REQUIRED /OObj /USource /ISource /B /JPHN /NevaluationUnits\cb3
IF ERRORLEVEL 1 goto QUIT1
move Source\*.hpp evaluationUnits\cb3
move Source\*.obj evaluationUnits\cb3

rem Make C++ Builder 4
rem
:CB4
IF NOT EXIST "%CB4%\bin\dcc32.exe" goto CB5
call :mkdir evaluationUnits\cb4
"%CB4%\bin\dcc32" Source\jpegreg2 /$D-,L-,Y- /DDELPHI_REQUIRED /OObj /USource /ISource /B /JPHN /NevaluationUnits\cb4
IF ERRORLEVEL 1 goto QUIT1
move Source\*.hpp evaluationUnits\cb4
move Source\*.obj evaluationUnits\cb4


rem Make C++Builder 5.0 

:CB5
IF NOT EXIST "%CB5%\bin\dcc32.exe" goto CB6
call :mkdir evaluationUnits\cb5
"%CB5%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL;CBUILDER5 /$D-,L-,Y-,R- /JPHN /B /Z- /OObj /N0evaluationUnits\cb5 /NOevaluationUnits\cb5 /NHevaluationUnits\cb5 
IF ERRORLEVEL 1 goto QUIT1

rem Make C++Builder 6.0 

:CB6
IF NOT EXIST "%CB6%\bin\dcc32.exe" goto CB6
call :mkdir evaluationUnits\cb6
"%CB6%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL;CBUILDER5 /$D-,L-,Y-,R- /JPHN /B /Z- /OObj /N0evaluationUnits\cb6 /NOevaluationUnits\cb6 /NHevaluationUnits\cb6 
IF ERRORLEVEL 1 goto QUIT1

cd ..
:QUIT
goto :EOF
:QUIT1
cd ..
goto :EOF

:mkdir
if Exist "%1" goto Clear
mkdir "%1"
goto :EOF
:Clear
del /Q /S "%1\*.*"
goto :EOF
