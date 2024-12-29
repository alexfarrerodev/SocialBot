# Path where the Python installer will be downloaded
$pythonInstaller = "$env:TEMP\python-installer.exe"

# URL of the Python installer (adjust the version if necessary)
$pythonURL = "https://www.python.org/ftp/python/3.11.6/python-3.11.6-amd64.exe"

# Download the Python installer
Write-Host "Downloading the Python installer..."
Invoke-WebRequest -Uri $pythonURL -OutFile $pythonInstaller

# Install Python silently (including adding it to the PATH)
Write-Host "Installing Python..."
Start-Process -FilePath $pythonInstaller -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait

# Verify the installation
Write-Host "Verifying the installation..."
$pythonVersion = python --version
if ($LASTEXITCODE -eq 0) {
    Write-Host "Python was successfully installed: $pythonVersion"
} else {
    Write-Host "There was an error installing Python."
}

# Remove the installer
Remove-Item $pythonInstaller -Force
