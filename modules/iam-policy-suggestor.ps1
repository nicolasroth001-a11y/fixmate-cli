param (
    [string]$ErrorMessage
)

if ($ErrorMessage -match "perform: ([\w:-]+)") {
    $Action = $matches[1]

    Write-Host "`nMissing IAM Action Detected: $Action`n"

    $Policy = @{
        Version = "2012-10-17"
        Statement = @(
            @{
                Effect = "Allow"
                Action = $Action
                Resource = "*"
            }
        )
    }

    $Json = $Policy | ConvertTo-Json -Depth 3
    Write-Host "Suggested IAM Policy:`n$Json`n"
}
else {
    Write-Host "`nNo IAM action found in error message.`n"
}
