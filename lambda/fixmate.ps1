param (
    [string]$ErrorMessage,
    [switch]$Json,
    [switch]$Copy
)

# Prepare request body
$body = @{ error = $ErrorMessage } | ConvertTo-Json -Compress

# Send request to FixMate Lambda
$response = Invoke-RestMethod -Uri "https://c4cqf1sz07.execute-api.us-east-2.amazonaws.com/Prod/diagnose" `
    -Method POST `
    -Body $body `
    -ContentType "application/json"

# Convert response to string
$responseText = $response.ToString()

# Extract everything after 'body='
$bodyStart = $responseText.IndexOf("body=") + 5
$bodyRaw = $responseText.Substring($bodyStart)

# Remove trailing '}'
$bodyClean = $bodyRaw.TrimEnd("}")

# Print clean output
if ($Json) {
    $bodyClean | ConvertFrom-Json | ConvertTo-Json -Depth 5
} else {
    $bodyClean -split "`n" | ForEach-Object { Write-Host $_ }

    if ($Copy) {
        Set-Clipboard -Value $bodyClean
        Write-Host "`n✅ Output copied to clipboard."
    }
}




}
