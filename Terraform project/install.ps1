# Log file paths
$pythonLogFile = "C:\python_installation.log"


# Function to log messages
function Log-Message {
    param (
        [string]$logFile,
        [string]$message
    )
    $dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "$dateTime - $message"
    Write-Host $message
}

try {
    # Python installation
    $pythonInstallerUrl = "https://www.python.org/ftp/python/3.9.9/python-3.9.9-amd64.exe"
    $installerPath = "$env:TEMP\python-installer.exe"

    Log-Message $pythonLogFile "Downloading Python installer..."
    Invoke-WebRequest -Uri $pythonInstallerUrl -OutFile $installerPath -ErrorAction Stop
    Log-Message $pythonLogFile "Installing Python..."
    Start-Process -FilePath $installerPath -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1 Include_launcher=1 Include_Examples=1' -Wait

    if (Test-Path "C:\Program Files\Python39\python.exe") {
        Log-Message $pythonLogFile "Python installed successfully."
    } else {
        throw "Python installation failed."
    }
} catch {
    Log-Message $pythonLogFile "Error: $($_.Exception.Message)"
}



### VS Code Installation ###

Set-ExecutionPolicy Bypass -Scope Process -Force

# Log file path for VS Code installation
$vscodeLogFile = "C:\vscode_install.log"

# Function to log messages
function Log-Message {
    param(
        [string]$logFile,
        [string]$message
    )
    $datevar = Get-Date
    Add-Content -Path $logFile -Value "$datevar - $message"
    Write-Host "$message"
}

# Install VS Code
try {
    $vscodeUrl = "https://update.code.visualstudio.com/latest/win32-x64/stable"
    $destination = "$env:TEMP\vscode_installer.exe"
    Log-Message $vscodeLogFile "Downloading VS Code installer from $vscodeUrl"

    Invoke-WebRequest -Uri $vscodeUrl -OutFile $destination -UseBasicParsing
    Log-Message $vscodeLogFile "Starting VS Code installation"

    Start-Process -Wait -FilePath $destination -ArgumentList '/verysilent', '/mergetasks=!runcode'
    Remove-Item $destination

    # Verify VS Code installation
    $vscodePath = "C:\Program Files\Microsoft VS Code\Code.exe"
    if (Test-Path $vscodePath) {
        Log-Message $vscodeLogFile "VS Code installation completed successfully"
    } else {
        Log-Message $vscodeLogFile "VS Code installation failed: Executable not found at $vscodePath"
    }
} catch {
    Log-Message $vscodeLogFile "VS Code installation failed: $($_.Exception.Message)"
    Write-Host "Error: $_"
}

