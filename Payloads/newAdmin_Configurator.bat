@echo off
:: Versión del 21 de noviembre del 2019


Title NewAdmin Configurator (0.1)

:Info
echo.
echo Configura el payload para incorporar un nuevo usuario admin en el equipo. 
echo Asigne los parametros a continuacion.   (o escribe "l" para limpiar directorio)
echo.

:Start
set/p "user=Nuevo usuario: " || cls && goto Info
if %user%==l goto Limpieza
set/p "pass=Nuevo password: "
echo.

:: Comprueba user != pass
if %user%==%pass% echo No pueden ser iguales! && echo. && goto Start

copy /Y newAdmin.duck newAdmin_%user%.duck >nul 2>nul

:: Asignar usuario
powershell -Command "(gc newAdmin_%user%.duck) -replace 'ducku', '%user%' | Out-File -encoding ASCII newAdmin_%user%.duck"

:: Asignar contraseña
powershell -Command "(gc newAdmin_%user%.duck) -replace 'passcuack', '%pass%' | Out-File -encoding ASCII newAdmin_%user%.duck"

echo Nuevo payload creado! YEAH!
echo.
set /p a=Compilar payload? (S/n): || cd .. && start DigiCuack_Encoder.bat newAdmin_%user%
if %a%==n exit
if %a%==N exit
cd .. && start DigiCuack_Encoder.bat newAdmin_%user%
exit

:Limpieza
:: Borra todos los newAdmin_*.duck que hayan en la carpeta
cls 
set /p ans=Borrar payloads newAdmin_*? (s/N): || cls && goto Info
if %ans%==s goto Borra
if %ans%==S goto Borra
goto Info
:Borra
del -r newAdmin_*.duck
echo Limpieza compleada!
timeout 3 > nul
goto Info
