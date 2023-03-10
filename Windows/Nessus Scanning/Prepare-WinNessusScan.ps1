# Check if LocalAccountTokenFilterPolicy exists, and create it if it doesn't
if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\LocalAccountTokenFilterPolicy")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -PropertyType DWORD -Value 0
    echo "LocalAccountTokenFilterPolicy did not exist. Created and set to 0 (disabled)."
}

# Get the current value of LocalAccountTokenFilterPolicy
$policy = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System").LocalAccountTokenFilterPolicy
$username = "Scan_Account" # Change Scan_Account to the appropriate account name for your environment

if ($policy -eq 0) {
    # LocalAccountTokenFilterPolicy is 0, so run the script to set it to 1, enable a user account, and start RemoteRegistry service
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -Value 1
    # Enable the user account used for scanning
    Enable-LocalUser -Name $username
    # Start the RemoteRegistry service
    Start-Service -Name "RemoteRegistry"
} elseif ($policy -eq 1) {
    # LocalAccountTokenFilterPolicy is 1, so run the script to set it to 0, disable a user account, and stop RemoteRegistry service
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -Value 0
    # Disable the user account used for scanning
    Disable-LocalUser -Name $username
    Stop-Service -Name "RemoteRegistry"
} else {
    # LocalAccountTokenFilterPolicy has an invalid value
    Write-Host "LocalAccountTokenFilterPolicy has an invalid value: $policy"
}
