@echo off
setlocal enableextensions enabledelayedexpansion

::          X.X   DD-MM-YYYY  Author   Description
set version=1.4 &:06-02-2020  Liam     Framework ready
:: !! For a new version entry, copy the last entry down and modify Date, Author and Description
set version=%version: =%

:: Set the title
set title=DigiCuack Encoder (%version%)
title %title%

:Start
echo "______ _       _ _____                  _      _____                    _           "
echo "|  _  (_)     (_)  __ \                | |    |  ___|                  | |          "
echo "| | | |_  __ _ _| /  \/_   _  __ _  ___| | __ | |__ _ __   ___ ___   __| | ___ _ __ "
echo "| | | | |/ _\ | | |   | | | |/ _\ |/ __| |/ / |  __| '_ \ / __/ _ \ / _\ |/ _ \ '__|"
echo "| |/ /| | (_| | | \__/\ |_| | (_| | (__|   <  | |__| | | | (_| (_) | (_| |  __/ |   "
echo "|___/ |_|\__, |_|\____/\__,_|\__,_|\___|_|\_\ \____/_| |_|\___\___/ \__,_|\___|_|   "
echo "          __/ |                                                                     "
echo "         |___/                                        v %version%      By: Liam McHara    "
echo.

:: Salta la selección si se envía como parámetro
if NOT [%1]==[] set payload=%1 && goto Selected

::Selección
echo I've found these payloads:
echo.

:: Lista los archivos .duck de la carpeta Payloads (sin la extensión), los cuenta (cantidad)
set /a cantidad=0
for %%a in ("Payloads\*.duck") do (
	set /a cantidad += 1 
	@echo   !cantidad!  %%~na
)
echo.

set /p "numero=Select the payload you wish to load (write its number): " || cls && goto Start

set /a i=1
for %%a in ("Payloads\*.duck") do (
	if !i! EQU !numero! (set payload=%%~na)
	set /a i += 1 
)

if not defined payload cls && goto Start

:Selected
:: Removes spaces at end of filename (needed if payload sent as a parameter)

if "!payload:~-1!"==" " set payload=!payload:~0,-1!

echo Selected payload: "%payload%"
echo.

:: 0. borrado de datos anteriores (just in case, para que tenga sentido el paso 2)
del raw.bin >nul 2>nul

:: 1. codifiacion (sin echo)
java -jar encoder.jar -i "Payloads\%payload%.duck" -o raw.bin -l es >nul 2>nul

:: 2. comprobación
IF NOT EXIST raw.bin (goto Error)

:: 3. digi-coding
echo Initial coding - OK!
rmdir /Q /S "Sketches\%payload%" >nul 2>nul
mkdir "Sketches\%payload%\sketch"
duck2spark.py -i raw.bin -l 1 -f 2000 -o "Sketches\%payload%\sketch\sketch.ino"
echo Conversion to Digispark - OK!
echo|set /p="Starting the Arduino thingy... "

:: Método con GUI 
:: Sketches\%payload%\sketch\sketch.ino

:: Método sin GUI:
"C:\Program Files (x86)\Arduino\arduino_debug.exe" --upload "Sketches\%payload%\sketch\sketch.ino" 

echo OK!
goto Salir


:Error
echo ERROR: Wrong input!
set /p "ans=Try again? (Y/n)" || cls && goto Start
if %ans%==n goto Salir
cls && goto Start

:Salir
echo.
del raw.bin >nul 2>nul
echo Ciao, baby! :)
timeout 3 >nul 2>nul
exit