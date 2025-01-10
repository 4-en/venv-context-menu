# Function to check if the script is running as administrator
function Ensure-Administrator {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "The script is not running as an administrator. Attempting to relaunch with elevated privileges..." -ForegroundColor Yellow
        
        # Relaunch the script with elevated privileges
        $arguments = "-ExecutionPolicy Bypass -File `"$PSCommandPath`""
        Start-Process -FilePath "powershell.exe" -ArgumentList $arguments -Verb RunAs
        
        # Exit the current (non-elevated) session
        exit
    }
}

# Ensure the script is running as administrator
Ensure-Administrator

# Variables
$appDataDir = "$env:APPDATA\.activate_venv_menu"
$resolvedAppDataDir = $appDataDir
$contextMenuName = "Activate VEnv"
$activateScriptName = "activate_venv.ps1"
$uninstallScriptName = "uninstall_venv.ps1"
$iconName = "venv_folder_python.ico"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$activateScriptSource = [System.IO.Path]::Combine($scriptDir, $activateScriptName)
$uninstallScriptSource = [System.IO.Path]::Combine($scriptDir, $uninstallScriptName)
$iconSource = [System.IO.Path]::Combine($scriptDir, $iconName)

$activateScriptFullPath = [System.IO.Path]::Combine($resolvedAppDataDir, $activateScriptName)
$uninstallScriptFullPath = [System.IO.Path]::Combine($resolvedAppDataDir, $uninstallScriptName)
$iconFullPath = [System.IO.Path]::Combine($resolvedAppDataDir, $iconName)

# Create the directory in %APPDATA%
if (-not (Test-Path -Path $resolvedAppDataDir)) {
    New-Item -ItemType Directory -Path $resolvedAppDataDir | Out-Null
}

# Copy the activate script to the app data directory
if (Test-Path -Path $activateScriptSource) {
    Copy-Item -Path $activateScriptSource -Destination $resolvedAppDataDir -Force
} else {
    Write-Error "Source file not found: $activateScriptSource"
}

# Copy the uninstall script to the app data directory
if (Test-Path -Path $uninstallScriptSource) {
    Copy-Item -Path $uninstallScriptSource -Destination $resolvedAppDataDir -Force
} else {
    Write-Error "Source file not found: $uninstallScriptSource"
}

# Copy the icon to the app data directory
if (Test-Path -Path $iconSource) {
    Copy-Item -Path $iconSource -Destination $resolvedAppDataDir -Force
} else {
    Write-Error "Source file not found: $iconSource"
}

# Define the registry path for context menu
$regKeyPath = "HKCR\Directory\shell\$contextMenuName"
$commandKeyPath = "HKCR\Directory\shell\$contextMenuName\command"

# Add the context menu item
New-Item -Path "Registry::$regKeyPath" -Force | Out-Null
Set-ItemProperty -Path "Registry::$regKeyPath" -Name "(Default)" -Value $contextMenuName
Set-ItemProperty -Path "Registry::$regKeyPath" -Name "Icon" -Value "`"$iconFullPath`""

# Add the command to execute the batch file (use full resolved path)
New-Item -Path "Registry::$commandKeyPath" -Force | Out-Null
Set-ItemProperty -Path "Registry::$commandKeyPath" -Name "(Default)" -Value "`"powershell.exe`" -NoProfile -ExecutionPolicy Bypass -File `"$activateScriptFullPath`" -VenvPath `"%1`""


# register the uninstall script in the registry
$uninstallRegKeyPath = "HKCR\Directory\shell\$contextMenuName\command\uninstall"
New-Item -Path "Registry::$uninstallRegKeyPath" -Force | Out-Null
Set-ItemProperty -Path "Registry::$uninstallRegKeyPath" -Name "(Default)" -Value "`"$uninstallScriptFullPath`""
Set-ItemProperty -Path "Registry::$uninstallRegKeyPath" -Name "Icon" -Value "`"$iconFullPath`""
Set-ItemProperty -Path "Registry::$uninstallRegKeyPath" -Name "IsolatedCommand" -Value "`"$uninstallScriptFullPath`""


Write-Host "Context menu option '$contextMenuName' added successfully!"
