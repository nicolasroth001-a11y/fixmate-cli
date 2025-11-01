param (
    [string]$ErrorMessage
)

if ($ErrorMessage -match "timed out after ([\d\.]+) seconds") {
    $Timeout = $matches[1]
    Write-Host "`nLambda Timeout Detected: Function exceeded $Timeout seconds.`n"

    Write-Host "Fix Steps:"
    Write-Host "1. Open the AWS Console and go to Lambda → Functions."
    Write-Host "2. Select the function that triggered the timeout."
    Write-Host "3. Click 'Configuration' → 'General configuration'."
    Write-Host "4. Increase the timeout value to accommodate longer execution."
    Write-Host "5. Consider redesigning the function for async processing if needed.`n"

    $FixJson = @{
        Action = "IncreaseLambdaTimeout"
        CurrentTimeout = "$Timeout seconds"
        Notes = "Consider async redesign if function consistently exceeds timeout."
    }

    $Json = $FixJson | ConvertTo-Json -Depth 3
    Write-Host "Suggested Fix Block:`n$Json`n"
}
else {
    Write-Host "`nNo Lambda timeout pattern detected.`n"
}
