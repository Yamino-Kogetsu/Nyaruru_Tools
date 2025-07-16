@echo off
title Local Modding Tool Server

:: CRITICAL: Change the directory to the script's location.
:: This ensures the server runs in the correct folder to find index.html.
cd /d "%~dp0"

:: ===================================================================
:: 1. CHECK FOR PYTHON
:: ===================================================================
echo [*] Checking for Python installation...
where /q python
if %errorlevel% equ 0 goto checkPythonVersion

echo [!] Python not found. Trying Node.js next...
goto checkNode


:checkPythonVersion
echo [*] Python detected. Checking version...

:: Capture the output of "python --version". 
:: The "2>&1" part is crucial as Python 2 prints to stderr.
for /f "tokens=*" %%i in ('python --version 2^>^&1') do (
    set "PY_VERSION=%%i"
)

:: Check if the version string contains "Python 3".
echo %PY_VERSION% | find "Python 3" > nul
if %errorlevel% equ 0 (
    goto startPython3Server
) else (
    goto startPython2Server
)


:startPython3Server
echo [*] Python 3 detected.
echo [*] Starting server with 'http.server'...
echo.
echo =================================================================
echo  Server is running! Open your web browser and go to:
echo.
echo    http://localhost:8000
echo.
echo  Press CTRL+C in this window to stop the server.
echo =================================================================
python -m http.server 8000
goto end


:startPython2Server
echo [*] Python 2 detected.
echo [*] Starting legacy server with 'SimpleHTTPServer'...
echo.
echo =================================================================
echo  Server is running! Open your web browser and go to:
echo.
echo    http://localhost:8000
echo.
echo  Press CTRL+C in this window to stop the server.
echo =================================================================
python -m SimpleHTTPServer 8000
goto end


:: ===================================================================
:: 2. CHECK FOR NODE.JS
:: ===================================================================
:checkNode
echo [*] Checking for Node.js installation...
where /q node
if %errorlevel% neq 0 goto noServerFound

echo [*] Node.js detected.
echo [*] Checking for 'http-server' package...
where /q http-server
if %errorlevel% neq 0 goto noHttpServer

goto startNodeServer


:startNodeServer
echo [*] 'http-server' package found.
echo [*] Starting server with 'http-server'...
echo.
echo =================================================================
echo  Server is running! Open your web browser and go to:
echo.
echo    http://localhost:8000
echo.
echo  Press CTRL+C in this window to stop the server.
echo =================================================================
http-server -p 8000
goto end


:: ===================================================================
:: MESSAGES AND ERROR HANDLING
:: ===================================================================
:noHttpServer
echo [!] ========================= ERROR ===========================
echo [!] Node.js is installed, but the 'http-server' package
echo [!] was not found. The server cannot be started.
echo.
echo [!] To fix this, open a new Command Prompt and run:
echo [!] npm install -g http-server
echo [!] ===========================================================
echo.
pause
goto end


:noServerFound
echo [!] ========================= ERROR ===========================
echo [!] Neither Python nor Node.js could be found on your system.
echo [!] The server cannot be started.
echo.
echo [!] Please install either Python 3 (from python.org) or
echo [!] Node.js (from nodejs.org) to run the server.
echo [!] ===========================================================
echo.
pause
goto end


:end