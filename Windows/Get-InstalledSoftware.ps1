# Author: Joshua Perrette
# Date Created: 9/23/2022
# Date Modified: 9/23/2022

$date = Get-Date -Format yyyy-MM-dd
$targetFolder = "C:\ConMon\Artifacts"
$targetPath = "${targetFolder}\InstalledSoftware_${date}.csv"

# Check if target directory exists
if (!(Test-Path -Path $targetFolder -PathType Container)) {
    echo "${targetFolder} does not exist. Creating..."
    mkdir $targetFolder > $null
}

$InstalledSoftware = Get-WmiObject -Class Win32_Product | select Name, Version, Vendor | Sort -Property Name
$allSoftware = [System.Collections.ArrayList]@()
foreach($obj in $InstalledSoftware) {
    $software = New-Object -TypeName PSObject
    $software | Add-Member -MemberType NoteProperty -Name DisplayName -Value $obj.Name
    $software | Add-Member -MemberType NoteProperty -Name Version -Value $obj.Version
    $software | Add-Member -MemberType NoteProperty -Name Vendor -Value $obj.Vendor
    $null = $allSoftware.Add($software)
}

# Export results and remove junk
$allSoftware | Export-Csv -Path $targetPath
$softwareCSV = Import-Csv $targetPath | Select -Skip 1
$softwareCSV | Export-Csv $targetPath -Force -NoTypeInformation

$response = Read-Host "Open ${targetPath} (y/n)?"
if ($response -eq 'y') {
    Invoke-Item ${targetPath}
}
else {
    echo "`n${targetPath} created successfully."
}