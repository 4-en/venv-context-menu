# activate venv menu uninstaller
#

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

# Define the registry path for context menu
$regKeyPath = "HKCR\Directory\shell\$contextMenuName"
$commandKeyPath = "HKCR\Directory\shell\$contextMenuName\command"

# remove the context menu item
Remove-Item -Path "Registry::$commandKeyPath" -Force
Remove-Item -Path "Registry::$regKeyPath" -Force

# remove the uninstall script from the registry
$uninstallRegKeyPath = "HKCR\Directory\shell\$contextMenuName\command\uninstall"
Remove-Item -Path "Registry::$uninstallRegKeyPath" -Force

# remove the app data directory
Remove-Item -Path $appDataDir -Force -Recurse
