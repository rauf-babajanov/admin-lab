# New-LabUsers.ps1
$csvPath = "C:\Users\Administrator\Desktop\users.csv"
$users = Import-Csv -Path $csvPath

foreach ($user in $users) {
    $username = "$($user.FirstName).$($user.LastName)".ToLower()
    $upn = "$username@atlaslab.de"

    $existing = Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue

    if ($existing) {
        Write-Host "SKIP: $username already exists" -ForegroundColor Yellow
        continue
    }

    New-ADUser `
        -Name "$($user.FirstName) $($user.LastName)" `
        -GivenName $user.FirstName `
        -Surname $user.LastName `
        -SamAccountName $username `
        -UserPrincipalName $upn `
        -Path "OU=Users,OU=ATLAS,DC=corp,DC=atlas,DC=test" `
        -AccountPassword (ConvertTo-SecureString "TempPass123!" -AsPlainText -Force) `
        -Enabled $true `
        -Department $user.Department `
        -Title $user.Title

    Write-Host "CREATED: $username ($($user.Department))" -ForegroundColor Green

    if ($user.Department -eq "Finance") {
        Add-ADGroupMember -Identity "SG-Finance-Read" -Members $username
        Write-Host "  -> added to SG-Finance-Read" -ForegroundColor Cyan
    }
}