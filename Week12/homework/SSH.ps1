cls
# Storyline: Login to a remote SSH server
New-SSHSession -ComputerName '10.0.17.61' -Credential (Get-Credential champuser)


while ($true) {

    # Add a prompt to run commands
    $the_cmd = Read-Host -Prompt "Please enter a command"

    # Run command on remote SSH server
    (Invoke-SSHCommand -index 0 $the_cmd).Output

}


# Set-SCPFile -ComputerName '10.0.17.61' -Credential (Get-Credential sys320) `
# -RemotePath '/home/sys320' -LocalFile '.\test.txt'

# Remove-SSHSession -SessionId 0