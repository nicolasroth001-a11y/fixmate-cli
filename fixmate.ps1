# FixMate v1.1 — Modular CLI with logging, copy, and JSON output

param (
    [string]$ErrorMessage,
    [switch]$Json,
    [switch]$Copy
)

# Version stamp
$version = "FixMate v1.1"

# Prepare request body
$body = @{ error = $ErrorMessage } | ConvertTo-Json -Compress

# Send request to FixMate Lambda
$response = Invoke-RestMethod -Uri "https://c4cqf1sz07.execute-api.us-east-2.amazonaws.com/Prod/diagnose" `
    -Method POST `
    -Body $body `
    -ContentType "application/json"

# Extract the response body cleanly
$bodyText = $response.body

# Create logs folder if it doesn't exist
$logDir = Join-Path $PSScriptRoot "logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir | Out-Null
}

# Generate timestamped log file
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logFile = Join-Path $logDir "fixmate_$timestamp.log"
$logContent = "$version`nErrorMessage: $ErrorMessage`n`n$bodyText"
Set-Content -Path $logFile -Value $logContent

# Output to console
if ($Json) {
    $bodyText | ConvertFrom-Json | ConvertTo-Json -Depth 5
} else {
    Write-Host $version
    Write-Host ""
    $bodyText -split "`n" | ForEach-Object { Write-Host $_ }

    if ($Copy) {
        Set-Clipboard -Value $bodyText
        Write-Host "`n✅ Output copied to clipboard."
    }
}

Write-Host "`nLogged to: $logFile"

