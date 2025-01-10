

# Get the path to the .venv directory from the first argument
param(
    [Parameter(Mandatory=$true)]
    [string]$VenvPath
)

# Check if the specified path exists and contains the virtual environment activation script
if (-Not (Test-Path "$VenvPath")) {
    Write-Error "The specified .venv path does not exist: $VenvPath"
    exit 1
}

# Determine the activation script location
$activateScript = Join-Path -Path $VenvPath -ChildPath "Scripts\Activate.ps1"
$parentDir = Split-Path -Path $VenvPath -Parent


# Verify the activation script exists
if (-Not (Test-Path $activateScript)) {
    Write-Error "The activation script was not found in the specified .venv path: $activateScript"
    exit 1
}

# Source the activation script
try {
    Write-Host "Activating venv: $VenvPath" -ForegroundColor Green
    # open new powershell session to activate the virtual environment
    powershell -NoExit -Command "cd $parentDir; . $activateScript"
} catch {
    Write-Error "Failed to activate the virtual environment: $_"
    exit 1
}