param (
    [string]$ErrorMessage
)

if ($ErrorMessage -match "Availability Zone '([\w-]+)' is not covered by subnet group") {
    $AZ = $matches[1]
    Write-Host "`nSubnet Mismatch Detected: Missing AZ $AZ in DB Subnet Group.`n"

    Write-Host "Fix Steps:"
    Write-Host "1. Open the AWS Console and go to RDS -> Subnet Groups."
    Write-Host "2. Select the DB Subnet Group used in your deployment."
    Write-Host "3. Click `"Edit`" and add a subnet from Availability Zone $AZ."
    Write-Host "4. Save changes and retry the deployment.`n"

    $FixJson = @{
        Action = "AddSubnetToGroup"
        MissingAZ = $AZ
        Notes = "Ensure at least one subnet per AZ is included in the DB Subnet Group."
    }

    $Json = $FixJson | ConvertTo-Json -Depth 3
    Write-Host "Suggested Fix Block:`n$Json`n"
}
else {
    Write-Host "`nNo subnet mismatch pattern detected.`n"
}
