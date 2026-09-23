@echo off
REM FinTech Platform Docker Startup Script for Windows
REM Batch script to manage Docker containers

setlocal enabledelayedexpansion

REM Check command
if "%1%"=="" goto help
if "%1%"=="start" goto start
if "%1%"=="stop" goto stop
if "%1%"=="restart" goto restart
if "%1%"=="logs" goto logs
if "%1%"=="status" goto status
if "%1%"=="clean" goto clean
if "%1%"=="help" goto help
echo Noma'lum komanda: %1%
goto help

:start
echo [INFO] Konteynerlar ishga tushirilmoqda...
docker-compose up --build -d
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Konteynerlar muvaffaqiyatli ishga tushdi!
    echo [INFO] Platformalar:
    echo   Frontend:   http://localhost:3000
    echo   Backend:    http://localhost:2027
    echo   Swagger:    http://localhost:2027/swagger-ui.html
    echo   Database:   localhost:5432
) else (
    echo [ERROR] Konteynerlar ishga tushmadi
    exit /b 1
)
goto end

:stop
echo [INFO] Konteynerlar to'xtatilyapti...
docker-compose down
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Konteynerlar muvaffaqiyatli to'xtatildi
) else (
    echo [ERROR] Konteynerlarni to'xtatishda xato
    exit /b 1
)
goto end

:restart
echo [INFO] Konteynerlar qayta boshlanyapti...
docker-compose restart
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Konteynerlar muvaffaqiyatli qayta boshlandi
) else (
    echo [ERROR] Konteynerlarni qayta boshlashda xato
    exit /b 1
)
goto end

:logs
echo [INFO] Loglar ko'rsatilmoqda...
docker-compose logs -f
goto end

:status
echo [INFO] Konteynerlar holati:
docker-compose ps
goto end

:clean
echo [WARNING] Barcha konteynerlar va ma'lumotlar o'chiriladi...
set /p confirm="Ishonchingiz komilmi? (y/n): "
if /i "%confirm%"=="y" (
    docker-compose down -v
    docker system prune -a -f
    echo [SUCCESS] Tozalash yakunlandi
) else (
    echo [INFO] Tozalash bekor qilindi
)
goto end

:help
echo FinTech Platform Docker Manager
echo.
echo Qo'llanish: start.bat [komanda]
echo.
echo Buyruqlar:
echo   start       - Konteynerlarni ishga tushirish
echo   stop        - Konteynerlarni to'xtatish
echo   restart     - Konteynerlarni qayta boshlash
echo   logs        - Barcha loglarni ko'rish
echo   status      - Konteynerlar holatini ko'rish
echo   clean       - Barcha ma'lumotlarni o'chirish
echo   help        - Bu ko'rsatmani ko'rish
echo.

:end
endlocal
