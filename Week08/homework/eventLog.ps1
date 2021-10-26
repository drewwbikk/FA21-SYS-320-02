# Storyline: Review the Security Event Log

# Directory to save files
$myDir = "C:\Users\champuser\Desktop\"

# List all the available Windows Event logs
Get-EventLog -list

# Create a prompt to allow user to select the Log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"

# Task: Create a prompt that allows the user to specify a keyword or phrase to search on.
# Find a string from your event logs to search on.
$searchLog = "*" + (Read-Host -Prompt "Please enter the keyword or phrase to search for") + "*"

# Print the results for the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike $searchLog} | Export-Csv -NoTypeInformation `
-Path "$myDir\securityLogs.csv"