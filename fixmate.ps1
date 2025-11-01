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
Write-Host "`nDiagnosis:"
Write-Host "The error message indicates that the user `"DevUser`" does not have the necessary permissions to describe instances in Amazon EC2, as there is no identity-based policy allowing the `"ec2:DescribeInstances`" action for this user.`n"

Write-Host "Fix Steps:"
Write-Host "1. Log in to the AWS Management Console using an account with administrative permissions."
Write-Host "2. Navigate to the IAM service."
Write-Host "3. Locate the user `"DevUser`" under the Users section."
Write-Host "4. Click on the user to view their details."
Write-Host "5. Click on the `"Add permissions`" button."
Write-Host "6. Choose `"Attach policies directly`"."
Write-Host "7. In the search box, enter “AmazonEC2ReadOnlyAccess” to find the managed policy."
Write-Host "8. Select the policy and click `"Attach policy`"."
Write-Host "9. Ask the user to log out and log back in to apply the new permissions.`n"

