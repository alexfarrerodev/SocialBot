@echo off

:: Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed. Starting installation...

    :: Use PowerShell to download and install Python
    powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.6/python-3.11.6-amd64.exe' -OutFile '%TEMP%\python-installer.exe'"
    if exist "%TEMP%\python-installer.exe" (
        echo Installer downloaded successfully.
        powershell -Command "Start-Process -FilePath '%TEMP%\python-installer.exe' -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait"
        if %errorlevel% neq 0 (
            echo Error during Python installation.
            pause
            exit /b
        )
        echo Python installed successfully.
    ) else (
        echo Failed to download the Python installer.
        pause
        exit /b
    )
)

:: Check if pip is installed
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Pip is not installed. Attempting to install pip...
    python -m ensurepip --upgrade
    python -m pip install --upgrade pip
    if %errorlevel% neq 0 (
        echo There was an error installing pip.
        pause
        exit /b
    )
)

:: Create virtual environment if it doesn't exist
if not exist "venv" (
    echo Creating the virtual environment...
    python -m venv venv
    if %errorlevel% neq 0 (
        echo Error creating the virtual environment.
        pause
        exit /b
    )
)

:: Activate the virtual environment
echo Activating the virtual environment...
call venv\Scripts\activate

:: Install dependencies from requirements.txt
echo Installing dependencies from requirements.txt...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo Error installing dependencies.
    pause
    exit /b
)

:: Run the program
echo Running the program...
python detector.py

:: Pause to prevent the terminal from closing
pause
