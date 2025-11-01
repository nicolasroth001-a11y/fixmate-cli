param (
    [string]$ErrorMessage,
    [switch]$Json
)

$body = @{ error = $ErrorMessage } | ConvertTo-Json -Compress
$response = Invoke-RestMethod -Uri "https://c4cqf1sz07.execute-api.us-east-2.amazonaws.com/Prod/diagnose" `
    -Method POST `
    -Body $body `
    -ContentType "application/json"

if ($Json) {
    $response | ConvertTo-Json -Depth 5
} else {
    Write-Host "`n$response.body"
}
