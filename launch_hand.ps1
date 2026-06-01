# Stop any c-lab tracking script that is already running
Get-CimInstance Win32_Process -Filter "name='python.exe'" |
    Where-Object { $_.CommandLine -like "*$PSScriptRoot*" } |
    ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }

Start-Sleep -Milliseconds 500

Write-Host "Starting Hand Tracking..." -ForegroundColor Cyan
Set-Location $PSScriptRoot
& "$PSScriptRoot\venv\Scripts\python.exe" "$PSScriptRoot\hand_recognition.py"
