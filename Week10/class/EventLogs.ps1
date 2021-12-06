#Storyline: View the event logs, check for a valid log, and print the results

function select_log() {

    cls

    # List all event logs
    $theLogs = Get-EventLog -list | Select Log
    $theLogs | Out-Host

    # Initialize  the array to store the logs
    $arrLog = @()

    foreach ($tempLog in $theLogs) {

        # Add each log to the array
        # NOTE: These are stored in the array as a hastable in the format:
        # @(Log=LOGNAME)
        $arrLog += $tempLog

    }

    # Test to be sure our array is being populated.
    #$arrLog

    # Prompt the user for the log to view or quit.
    $readLog = Read-Host -Prompt "Please enter a log from the list above or 'q' to quit the program"

    # Check if user wants to quit.
    if ($readLog -match "^[qQ]") {

        # Stop executing the programs and close the script
        break

    }

    log_check -logToSearch $readLog

} # ends the select_log()

function log_check() {
    
    # String the user types in within the select_log function
    Param([string]$logToSearch)
    # Format the user input
    # Example: @(Log=Security)
    $theLog = "^@{Log=" + $logToSearch + "}$"

    # Search the array for the exact hashtable string
    if ($arrlog -match $theLog) {

        write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the log entries."
        sleep 2

        # Call the function to view the log
        view_log -logToSearch $logToSearch

    } else {

        write-host -BackgroundColor red -ForegroundColor white "The log specified does not exist."

        sleep 2

        select_log
    }

} # ends the log_check()

function view_log() {

    cls

    # get the logs
    Get-EventLog -log $logtosearch -newest 10 -after "1/18/2020"

    # Pause the screen and wait until the user is ready to proceed.
    Read-Host -Prompt "Press enter when you are done."

    # Go back to select_log
    select_log

} # ends the view_log()

# Run the select_log() as the first function
select_log