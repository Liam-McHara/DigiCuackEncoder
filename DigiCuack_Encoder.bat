@echo off
:: Versión del 30 de noviembre del 2019

Title DigiCuack Encoder (1.2.1)

:Start
echo "______ _       _ _____                  _      _____                    _           "
echo "|  _  (_)     (_)  __ \                | |    |  ___|                  | |          "
echo "| | | |_  __ _ _| /  \/_   _  __ _  ___| | __ | |__ _ __   ___ ___   __| | ___ _ __ "
echo "| | | | |/ _\ | | |   | | | |/ _\ |/ __| |/ / |  __| '_ \ / __/ _ \ / _\ |/ _ \ '__|"
echo "| |/ /| | (_| | | \__/\ |_| | (_| | (__|   <  | |__| | | | (_| (_) | (_| |  __/ |   "
echo "|___/ |_|\__, |_|\____/\__,_|\__,_|\___|_|\_\ \____/_| |_|\___\___/ \__,_|\___|_|   "
echo "          __/ |                                                                     "
echo "         |___/                                        v 1.2.1      By: Liam McHara    "
echo.

:: Salta la selección si se envía como parámetro
if NOT [%1]==[] set payload=%1 && goto Selected

::Selección
echo Se han encontrado los siguientes payloads:
echo.

:: Lista los archivos .duck de la carpeta Payloads (sin la extensión)
setlocal enableextensions enabledelayedexpansion
set /a cantidad=0
for %%a in ("Payloads\*.duck") do (
	set /a cantidad += 1 
	@echo !cantidad!  %%~na
)
endlocal && set cantidad=%cantidad%
echo.
echo Cantidad de payloads en carpeta: %cantidad%
echo.
echo.
setlocal enableextensions enabledelayedexpansion
set /p "numero=Escribe el numero del payload que quieras cargar: " || cls && goto Start
set /a numero="%numero%"	
set numero=%numero: =%
echo tu numero es el: %numero%


set /a i=1
for %%a in ("Payloads\*.duck") do (
	@echo Evaluando: !i! igual a %numero% ?
	if !i! EQU numero (echo SI) else (echo nop)
	set /a i += 1 
)
endlocal && set payload=%payload%
echo %payload%

timeout 100










:Selected
:: Elimina espacios en la variable 
set payload=%payload: =%
echo Has seleccionado: %payload%
echo.

:: CODIFICACION
:: 0. borrado de datos anteriores (just in case, para que tenga sentido el paso 2)
del raw.bin >nul 2>nul

:: 1. codifiacion (sin echo)
java -jar encoder.jar -i Payloads\%payload%.duck -o raw.bin -l es >nul 2>nul

:: 2. comprobación
IF NOT EXIST raw.bin (goto Error)

:: 3. digi-coding
echo Codificacion inicial - OK!
rmdir /Q /S Sketches\%payload% >nul 2>nul
mkdir Sketches\%payload%\sketch
duck2spark.py -i raw.bin -l 1 -f 2000 -o Sketches\%payload%\sketch\sketch.ino
echo Conversion a Digispark - OK!
echo|set /p="Iniciando Arduino IDE... "

Sketches\%payload%\sketch\sketch.ino

:: Método sin GUI:
::"C:\Program Files (x86)\Arduino\arduino_debug.exe" --upload Sketches\%payload%\sketch\sketch.ino

echo OK!
goto Salir


:Error
echo ERROR: Aprende a escribir!
set /p "ans=Otra oportunidad? (S/n)" || cls && goto Start
if %ans%==n goto Salir
cls
goto Start

:Salir
echo.
del raw.bin >nul 2>nul
echo Ciao, baby! :)
timeout 3 >nul 2>nul
exit