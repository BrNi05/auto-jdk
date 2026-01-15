
# Error mgmt
$ErrorActionPreference = "Stop"
trap {
    Write-Error "Script failed. Terminating..."
    Read-Host "Press [Enter] to exit..."
    exit 1
}

# Privilege check
$IsAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "Script not running as Administrator. Terminating..."
    Read-Host "Press [Enter] to exit..."
    exit 1
}

# Manual steps
Write-Host "`nRemove JAVA_HOME and Path entries from user environment variables to avoid conflicts!"
Write-Host "Also consider removing old JDK installations."
Read-Host "Press [Enter] to continue..."

$JdkVersion = "25"
$InstallDir = "C:\Program Files\Java"
$TempDir = "$env:TEMP\jdksetup"

Write-Host "`nInstalling JDK $JdkVersion...`n"

New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

# Download JDK
$JdkUrl = "https://download.oracle.com/java/25/latest/jdk-25_windows-x64_bin.zip"
$JdkZip = "$TempDir\jdk.zip"
Invoke-WebRequest $JdkUrl -OutFile $JdkZip

# Extract JDK
Expand-Archive $JdkZip $InstallDir -Force

$JdkDir = Get-ChildItem $InstallDir |
    Where-Object { $_.Name -Like "jdk-25*" } |
    Select-Object -First 1

if (-not $JdkDir) { throw "JDK directory not found after extraction!" }

# Environment setup
[Environment]::SetEnvironmentVariable(
    "JAVA_HOME",
    $JdkDir.FullName,
    "Machine"
)

$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

if ($CurrentPath -notlike "*$($JdkDir.FullName)\bin*") {
    [Environment]::SetEnvironmentVariable(
        "Path",
        "$CurrentPath;$($JdkDir.FullName)\bin",
        "Machine"
    )
}

# Cleanup
Remove-Item -Recurse -Force $TempDir

Write-Host "`nDone. Restart terminal (or log out) to persist environment variables."
