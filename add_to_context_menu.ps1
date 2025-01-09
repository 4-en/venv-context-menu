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
$appDataDir = "$env:APPDATA\MyPythonScript"
$contextMenuName = "Run Python Script"
$scriptName = "process_folder.py"
$batchFileName = "run_script.bat"

# Resolve the full path for %APPDATA%
$resolvedAppDataDir = [System.IO.Path]::Combine($env:APPDATA, "MyPythonScript")
$batchFileFullPath = [System.IO.Path]::Combine($resolvedAppDataDir, $batchFileName)

# Create the directory in %APPDATA%
if (-not (Test-Path -Path $resolvedAppDataDir)) {
    New-Item -ItemType Directory -Path $resolvedAppDataDir | Out-Null
}

# Save the Python script
$pythonScriptContent = @"
import sys
import os

def main(folder_path):
    if os.path.isdir(folder_path):
        print(f"Processing folder: {folder_path}")
        # Add your script logic here
    else:
        print("The provided path is not a valid folder.")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        main(sys.argv[1])
    else:
        print("No folder path provided.")
"@
Set-Content -Path "$resolvedAppDataDir\$scriptName" -Value $pythonScriptContent

# Save the batch file to call the Python script
$batchFileContent = @"
@echo off
echo "$resolvedAppDataDir\$scriptName" "%1"
pause
"@
Set-Content -Path "$batchFileFullPath" -Value $batchFileContent

# Define the registry path for context menu
$regKeyPath = "HKCR\Directory\shell\$contextMenuName"
$commandKeyPath = "HKCR\Directory\shell\$contextMenuName\command"

# Add the context menu item
New-Item -Path "Registry::$regKeyPath" -Force | Out-Null
Set-ItemProperty -Path "Registry::$regKeyPath" -Name "(Default)" -Value $contextMenuName
Set-ItemProperty -Path "Registry::$regKeyPath" -Name "Icon" -Value "C:\Windows\System32\shell32.dll,-153"

# Add the command to execute the batch file (use full resolved path)
New-Item -Path "Registry::$commandKeyPath" -Force | Out-Null
Set-ItemProperty -Path "Registry::$commandKeyPath" -Name "(Default)" -Value "`"$batchFileFullPath`" `%1"

Write-Host "Context menu option '$contextMenuName' added successfully!"
