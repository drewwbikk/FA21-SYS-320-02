# Storyline: Using the Get-process and Get-service

# Shows available properties
# Get-Process | Get-Member

# Use Get-Alias to find aliases
# ps | gm

Get-Process | Select-Object ProcessName, Path, ID # | ` 
# Export-Csv -Path "C:\Users\champuser\Desktop\myProcesses.csv" -NoTypeInformation

# Get-Service | Where { $_.Status -eq "Running" }
# ps | where { $_.ProcessName -eq "svchost"} | select ProcessName, ID, Path

# Stop-Service, Start-Service, Stop-Process, Start-Process