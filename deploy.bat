Call SetConfig
Set WIX=\utils\wix
Set ZIP7=\Program Files\7-Zip

cd Examples\Viewer
updttext version.txt jpegdemo.rc %major% %minor% %step% @..\..\BuildNo.dat %year%
IF ERRORLEVEL 1 goto Quit2
"%BRCC%\bin\brcc32" -i"%BRCC%\include" -dWIN32 jpegdemo.rc
"%BRCC%\bin\brcc32" -i"%BRCC%\include" -dWIN32 test.rc
cd ..\db
updttext version.txt dbdemo.rc %major% %minor% %step% @..\..\BuildNo.dat %year%
IF ERRORLEVEL 1 goto Quit2
"%BRCC%\bin\brcc32" -i"%BRCC%\include" -dWIN32 dbdemo.rc
cd ..\..

call :mkdir release
call :mkdir release\evaluation
call :mkdir release\full
call :mkdir release\singleimage

pcopy source\source\mwajpeg.pas .

"%WIX%\candle" setup\src\*.wxs
IF ERRORLEVEL 1 goto QUIT
copy docs\licence\Registrd\Licence.rtf license.rtf
"%WIX%\light" -out release\full\mwajpeg.msi install.wixobj examples.wixobj delphi6.wixobj delphi7.wixobj delphi2005.wixobj bds2006.wixobj delphi2007.wixobj cbuilder5.wixobj cbuilder6.wixobj source.wixobj OldProductsdlg.wixobj ..\customactions\mwaca.wixlib %WIX%\WixUI.wixlib -loc %WIX%\WixUI_en-us.wxl
IF ERRORLEVEL 1 goto QUIT

"%WIX%\candle" -dEVALUATION setup\src\*.wxs
IF ERRORLEVEL 1 goto QUIT
copy docs\licence\shrware\Licence.rtf license.rtf
"%WIX%\light" -out release\evaluation\mwajpeg.msi install.wixobj examples.wixobj delphi6.wixobj delphi7.wixobj delphi2005.wixobj bds2006.wixobj delphi2007.wixobj cbuilder5.wixobj cbuilder6.wixobj OldProductsdlg.wixobj  ..\customactions\mwaca.wixlib  %WIX%\WixUI.wixlib -loc %WIX%\WixUI_en-us.wxl
IF ERRORLEVEL 1 goto QUIT
del license.rtf mwajpeg.pas


call :MKSINGLEIMAGE full mwajpegfull.%RELEASE% Full
call :MKSINGLEIMAGE evaluation mwajpegevaluation.%RELEASE% Evaluation
del *.wixobj
goto :EOF

:QUIT
goto :EOF

:Quit2
cd ..\..
goto :EOF

:MKSINGLEIMAGE
Rem %1 = msi directory
Rem %2 = package title
Rem %3 Edition
cd release\%1
"%ZIP7%\7z" a -r temp.zip *.*

echo ;!@Install@!UTF-8!>config.txt
echo Title="MWA JPEG Component Library %RELEASE%">>config.txt
echo BeginPrompt="Install MWA JPEG Component Library (%3 Edition)?">>config.txt
echo ExecuteFile="msiexec.exe">>config.txt
echo ExecuteParameters="/i mwajpeg.msi">>config.txt
echo ;!@InstallEnd@!>>config.txt

copy /b "%ZIP7%\7zS.sfx" + config.txt + temp.zip ..\SingleImage\%2.exe
del config.txt temp.zip
cd ..\..
goto :EOF

:mkdir
if Exist "%1" goto Clear
mkdir "%1"
goto :EOF
:Clear
del /Q /S "%1\*.*"
goto :EOF
