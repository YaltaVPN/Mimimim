@echo off
:: Включаем поддержку кириллицы (UTF-8)
chcp 65001 > nul

:: --- ОБРАБОТКА ПЕРВОЙ ПАПКИ (data) ---
echo === Сканирование папки: data ===
cd /d "C:\РОБЛОКС ЧИТ\data" 2>nul
if %errorlevel% equ 0 (
    for %%f in (*.bat *.com *.exe) do (
        if not "%%~dpnxf"=="%~dpnx0" (
            echo Запуск из data: %%f
            start "" "%%f"
        )
    )
) else (
    echo [Ошибка] Папка "data" не найдена.
)

echo.

:: --- ОБРАБОТКА ВТОРОЙ ПАПКИ (scr) ---
echo === Сканирование папки: scr ===
cd /d "C:\РОБЛОКС ЧИТ\scr" 2>nul
if %errorlevel% equ 0 (
    for %%f in (*.bat *.com *.exe) do (
        if not "%%~dpnxf"=="%~dpnx0" (
            echo Запуск из scr: %%f
            start "" "%%f"
        )
    )
) else (
    echo [Ошибка] Папка "scr" не найдена.
)

echo.
echo Все задачи запущены!
pause
