Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   C-Lab Scripts - Windows Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Set execution policy permanently for this user
# Wrapped in try/catch — on managed machines a Group Policy may already set Bypass at a higher
# level, which is fine (more permissive). The warning looks scary but scripts will run.
Write-Host "[1/4] Setting script execution policy..." -ForegroundColor Yellow
try {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop
} catch {
    Write-Host "      (Policy already managed by your system — no change needed)" -ForegroundColor Gray
}

# Unblock all scripts in this repo (git downloads are flagged as "from the internet")
Get-ChildItem $PSScriptRoot -Filter "*.ps1" | ForEach-Object { Unblock-File $_.FullName }
Write-Host "      Done." -ForegroundColor Green

# 2. Check for Python 3.12, install if missing
Write-Host "[2/4] Checking for Python 3.12..." -ForegroundColor Yellow
$pythonCheck = py -3.12 --version 2>$null
if (-not $pythonCheck) {
    Write-Host "      Not found. Installing Python 3.12 via winget..." -ForegroundColor Yellow
    winget install Python.Python.3.12 --silent --accept-package-agreements --accept-source-agreements
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
    Write-Host "      Python 3.12 installed." -ForegroundColor Green
} else {
    Write-Host "      Found: $pythonCheck" -ForegroundColor Green
}

# 3. Create virtual environment and install dependencies
Write-Host "[3/4] Creating virtual environment and installing dependencies..." -ForegroundColor Yellow
Write-Host "      (This may take a few minutes, please wait)" -ForegroundColor Gray
py -3.12 -m venv "$PSScriptRoot\venv"
& "$PSScriptRoot\venv\Scripts\pip.exe" install -r "$PSScriptRoot\requirements.txt"
Write-Host "      Dependencies installed." -ForegroundColor Green

# 4. Create desktop shortcuts
Write-Host "[4/4] Creating desktop shortcuts..." -ForegroundColor Yellow
$desktop = [Environment]::GetFolderPath("Desktop")
$shell = New-Object -ComObject WScript.Shell

$shortcuts = @(
    @{ Name = "Hand Tracking";  Launcher = "launch_hand.ps1"  },
    @{ Name = "Body Tracking";  Launcher = "launch_body.ps1"  }
)

foreach ($s in $shortcuts) {
    $lnk = $shell.CreateShortcut("$desktop\$($s.Name).lnk")
    $lnk.TargetPath      = "powershell.exe"
    $lnk.Arguments       = "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$PSScriptRoot\$($s.Launcher)`""
    $lnk.WorkingDirectory = $PSScriptRoot
    $lnk.Description     = "$($s.Name) - C-Lab Workshop"
    $lnk.WindowStyle     = 1
    $lnk.Save()
}

Write-Host "      Done." -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   Setup complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "-> Use the desktop shortcuts to launch the scripts." -ForegroundColor Cyan
Write-Host "   (Do NOT run 'python ...' directly in this terminal" -ForegroundColor Cyan
Write-Host "    unless you first run: .\venv\Scripts\activate)" -ForegroundColor Cyan
Write-Host ""
Read-Host "Press Enter to close"
