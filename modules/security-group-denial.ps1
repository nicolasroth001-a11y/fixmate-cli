param (
    [string]$ErrorMessage
)

if ($ErrorMessage -match "timed out|Permission denied|ECONNREFUSED|ECONNRESET|Unable to connect to port") {
    Write-Host "`nSecurity Group or Network ACL Issue Detected.`n"

    Write-Host "Fix Steps:"
    Write-Host "1. Go to the EC2 Console → Instances → Select your instance."
    Write-Host "2. Under 'Security', click the Security Group linked to the instance."
    Write-Host "3. Edit inbound rules to allow the required port (e.g., 22 for SSH, 443 for HTTPS)."
    Write-Host "4. Ensure the source IP or CIDR block matches your access location."
    Write-Host "5. If using a custom NACL, verify it allows inbound and outbound traffic on the same port.`n"

    $FixJson = @{
        Action = "UpdateSecurityGroup"
        CommonPorts = @("22", "80", "443")
        Notes = "Ensure inbound rules allow traffic from your IP on the required port."
    }

    $Json = $FixJson | ConvertTo-Json -Depth 3
    Write-Host "Suggested Fix Block:`n$Json`n"
}
else {
    Write-Host "`nNo security group or network denial pattern detected.`n"
}
