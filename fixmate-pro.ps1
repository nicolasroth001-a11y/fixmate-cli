param (
    [string]$ErrorMessage
)

Write-Host "FixMate Pro v1.1"

# Start logging
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logPath = ".\logs\fixmate_pro_$timestamp.log"
Start-Transcript -Path $logPath -Append

# Core diagnosis (example for EC2 DescribeInstances)
Write-Host "`nDiagnosis:"
Write-Host "The error message indicates that the user `"DevUser`" does not have the necessary permissions to describe instances in Amazon EC2, as there is no identity-based policy allowing the `"ec2:DescribeInstances`" action for this user.`n"

Write-Host "Fix Steps:"
Write-Host "1. Log in to the AWS Management Console using an account with administrative permissions."
Write-Host "2. Navigate to the IAM service."
Write-Host "3. Locate the user `"DevUser`" under the Users section."
Write-Host "4. Click on the user to view their details."
Write-Host "5. Click on the `"Add permissions`" button."
Write-Host "6. Choose `"Attach policies directly`"."
Write-Host "7. In the search box, enter \"AmazonEC2ReadOnlyAccess\" to find the managed policy."
Write-Host "8. Select the policy and click `"Attach policy`"."
Write-Host "9. Ask the user to log out and log back in to apply the new permissions.`n"

Write-Host "Reference Links:"
Write-Host "- AWS Managed Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_managed-vs-inline.html"

# Pro Module: IAM Permission Suggestor
if ($ErrorMessage -like "*not authorized to perform:*") {
    .\modules\iam-policy-suggestor.ps1 -ErrorMessage $ErrorMessage
}

# Pro Module: Subnet Mismatch Detector
if ($ErrorMessage -like "*Availability Zone*" -and $ErrorMessage -like "*not covered by subnet group*") {
    .\modules\subnet-mismatch-detector.ps1 -ErrorMessage $ErrorMessage
}

# Pro Module: Lambda Timeout Helper
if ($ErrorMessage -like "*timed out after*" -or $ErrorMessage -like "*timeout exceeded*") {
    .\modules\lambda-timeout-helper.ps1 -ErrorMessage $ErrorMessage
}

# Pro Module: Security Group Denial
if ($ErrorMessage -match "timed out|Permission denied|ECONNREFUSED|ECONNRESET|Unable to connect to port") {
    .\modules\security-group-denial.ps1 -ErrorMessage $ErrorMessage
}

# End logging
Stop-Transcript
Write-Host "`nLogged to: $logPath"

