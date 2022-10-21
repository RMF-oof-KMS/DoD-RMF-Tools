# Gets the security logs for the current month up to current time
$currentDate = Get-Date -Format "MM-dd-yyyy"

# First day of current month (start hour is hardcoded due to time format differences)
$firstDayMonth = Get-Date -Day 1 -Minute 0 -Second 0 -Format "yyyy-MM-ddT00:mm:ss"

# Export location and log name
$exportPath = "C:\Users\perrettej\OneDrive - Lyn AeroSpace, LLC\Desktop\$($env:computername)_$($currentDate)_SecurityLogs.evtx"

wevtutil epl Security $exportPath /q:"*[System[TimeCreated[@SystemTime>='$($firstDayMonth)']]]"