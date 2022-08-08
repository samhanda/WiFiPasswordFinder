#Window Title
$host.ui.RawUI.WindowTitle = "WiFi Key Finder by Samir Handa"
#Set Policy Scope so script is able to be run
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Start-Sleep -Seconds 1

cls

#start with netsh command to show all available wifi networks and passwords
$networknames = netsh wlan show profiles | findstr /i /c:"All User Profile     :"
$networknames = $networknames.Replace("All User Profile     :", "")
$networknames = $networknames.Trim()

#iterates through every network name found and displays password in cleartext
$passwords = foreach($name in $networknames){netsh wlan show profiles $name key=clear}

$passwords = $passwords.Replace(":", "|")
$passwords = $passwords.Replace("    ", "")

#cleans up what we find in the foreach loop so we see only what we need
$passwords = $passwords | Select-String -Pattern "SSID name", "Key Content"

$passwords -split '[\n]'
