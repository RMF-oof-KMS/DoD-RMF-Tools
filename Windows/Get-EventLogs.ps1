# This script exports all Security, System, and Application logs from the first day of the previous month.
# SecureStrux provides a very nice way to do this which performs log rotations as well.

$path = "C:\ConMon\Event_Logs" # Export directory location

# Audits from the first day of the last month up to today as we like having the tad bit of redundancy.
$startAuditDate = Get-Date
$startAuditDate = Get-Date ($startAuditDate.AddMonths(-1)) -F yyyy-MM-dd
# First day of current month (start hour is hardcoded due to time format differences)
$queryAuditDate = Get-Date $startAuditDate -Day 1 -Minute 0 -Second 0 -Format "yyyy-MM-ddT00:mm:ss"

wevtutil epl Security $exportPath /q:"*[System[TimeCreated[@SystemTime>='$($queryAuditDate)']]]"
$exportPath = "$($path)\$($env:computername)_$($currentDate)_SecurityLogs.evtx"
wevtutil epl System $exportPath /q:"*[System[TimeCreated[@SystemTime>='$($queryAuditDate)']]]"
$exportPath = "$($path)\$($env:computername)_$($currentDate)_SystemLogs.evtx"
wevtutil epl Application $exportPath /q:"*[System[TimeCreated[@SystemTime>='$($queryAuditDate)']]]"
$exportPath = "$($path)\$($env:computername)_$($currentDate)_ApplicationLogs.evtx"
