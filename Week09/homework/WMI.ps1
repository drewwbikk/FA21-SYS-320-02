# Use the Get-WmiObject cmdlet
# Get-WmiObject -Class Win32_service | select Name, PathName, ProcessId

# Get-WmiObject -list | where { $_.Name -ilike "Win32_[n-o]*" } | Sort-Object

# Get-WmiObject -Class Win32_Account | Get-Member

# Task: Grab the network adapter information using the WMI class.
# Get the IP address, default gateway, and the DNS servers.
# BONUS: get the DHCP server.
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | select IPAddress, DefaultIPGateway, DNSServerSearchOrder, DHCPServer

# Export your list of running processes and services on your system into separate files.
Get-Service | where { $_.Status -eq "Running" } | Export-Csv -Path "C:\Users\champuser\FA21-SYS-320-02\Week09\homework\runningServices.csv" -NoTypeInformation
Get-Process | Select-Object ProcessName, Path, ID | Export-Csv -Path "C:\Users\champuser\FA21-SYS-320-02\Week09\homework\runningProcesses.csv" -NoTypeInformation

# Start and Stop the Windows Calculator
Start-Process -FilePath "C:\Windows\System32\calc.exe"
pause
Stop-Process -Name win32calc