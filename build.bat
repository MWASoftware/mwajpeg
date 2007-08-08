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

call :mkdir evaluationUnits
call :mkdir evaluationUnits\d6
call :mkdir evaluationUnits\d7
call :mkdir evaluationUnits\d9
call :mkdir evaluationUnits\d10
call :mkdir evaluationUnits\d11
call :mkdir evaluationUnits\cb5
call :mkdir evaluationUnits\cb6


rem MAKE Delphi 6

:D6
IF NOT EXIST "%D6%\bin\dcc32.exe" goto D7
"%D6%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL /$D-,L-,Y-,R- /B /Z- /OObj /NevaluationUnits\D6 
IF ERRORLEVEL 1 goto QUIT1

rem MAKE Delphi 7

:D7
IF NOT EXIST "%D7%\bin\dcc32.exe" goto D9
"%D7%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL /$D-,L-,Y-,R- /B /Z- /OObj /NevaluationUnits\D7 
IF ERRORLEVEL 1 goto QUIT1

rem MAKE Delphi 2005

:D9

IF NOT EXIST "%D9%\bin\dcc32.exe" goto D10
"%D9%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL /$D-,L-,Y-,R- /B /Z- /OObj /NevaluationUnits\D9 
IF ERRORLEVEL 1 goto QUIT1

rem MAKE BDS 2006

:D10
IF NOT EXIST "%D10%\bin\dcc32.exe" goto D11
"%D10%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL /$D-,L-,Y-,R- /JPHNE /B /Z- /OObj /N0evaluationUnits\D10 /NOevaluationUnits\D10 /NHevaluationUnits\D10 
IF ERRORLEVEL 1 goto QUIT1

rem MAKE Delphi 2007

:D11
IF NOT EXIST "%D11%\bin\dcc32.exe" goto CB5
"%D11%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL /$D-,L-,Y-,R- /B /Z- /OObj /NevaluationUnits\D11 
IF ERRORLEVEL 1 goto QUIT1

rem Make C++Builder 5.0 

:CB5
IF NOT EXIST "%CB5%\bin\dcc32.exe" goto CB6
"%CB5%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL;CBUILDER5 /$D-,L-,Y-,R- /JPHN /B /Z- /OObj /N0evaluationUnits\cb5 /NOevaluationUnits\cb5 /NHevaluationUnits\cb5 
IF ERRORLEVEL 1 goto QUIT1

rem Make C++Builder 6.0 

:CB6
IF NOT EXIST "%CB5%\bin\dcc32.exe" goto CB6
"%CB5%\bin\dcc32" source\mwadbjpg.pas /DDELPHI_REQUIRED;NODLL;CBUILDER5 /$D-,L-,Y-,R- /JPHN /B /Z- /OObj /N0evaluationUnits\cb6 /NOevaluationUnits\cb6 /NHevaluationUnits\cb6 
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
