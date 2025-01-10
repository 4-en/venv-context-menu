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

# Determine the activation script based on the operating system
$activateScript = if ($IsWindows) {
    Join-Path -Path $VenvPath -ChildPath "Scripts\Activate.ps1"
} else {
    Join-Path -Path $VenvPath -ChildPath "bin/activate"
}

# Verify the activation script exists
if (-Not (Test-Path $activateScript)) {
    Write-Error "The activation script was not found in the specified .venv path: $activateScript"
    exit 1
}

# Source the activation script
try {
    & $activateScript
    Write-Host "Virtual environment activated from: $VenvPath" -ForegroundColor Green
} catch {
    Write-Error "Failed to activate the virtual environment: $_"
    exit 1
}