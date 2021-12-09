# Storyline: view services, running and/or stopped and allow users to view which ones they would like to see

# Stopped services: Get-Service | where{ $_. Status -eq "Stopped" }
# Running services: Get-Service | where{ $_. Status -eq "Running" }

function select_services() {

    cls
    
    # Prompt the user for the log to view or quit.
    $readStatus = Read-Host -Prompt "Enter 'r' to see running services, 's' to see stopped services, 'a' to see all services or 'q' to quit the program"

    # Check if user wants to quit
    if ($readStatus -match "^[qQ]") {

        # Stop executing the programs and close the script
        break

    } elseif ($readStatus -match "^[rR]") {

        # This variable will be used to filter running Services.
        $userStatus = Get-Service | where{ $_. Status -eq "Running"}

    } elseif ($readStatus -match "^[sS]") {

        # This variable will be used to filter stopped Services.
        $userStatus = Get-Service | where{ $_. Status -eq "Stopped"}

    } elseif ($readStatus -match "^[aA]") {

        # This variable will be used later to show all Services.
        $userStatus = Get-Service

    } else {

        # Warn user and restart program if invalid input is entered. 
        write-host -BackgroundColor red -ForegroundColor white "Invalid input."

        sleep 2
        select_services
    }

    # List the filtered services from user choice. 
    $theServices = $userStatus
    $theServices | Out-Host
}

#Run the select_services
select_services