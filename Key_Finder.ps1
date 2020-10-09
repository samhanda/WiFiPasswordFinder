#Window Title
$host.ui.RawUI.WindowTitle = "WiFi Key Finder by Samir Handa"
#Set Policy Scope so script is able to be run
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Start-Sleep -Seconds 1

cls

#start with netsh command to show all available wifi networks and passwords
$networknames = netsh wlan show profiles

#Get rid of any unnecessary characters, removing white space as well 
$networknames = $networknames.Replace("Profiles on interface Wi-Fi:", "")
$networknames = $networknames.Replace("Group policy profiles (read only)", "")
$networknames = $networknames.Replace("<None>", "")
$networknames = $networknames.Replace("All User Profile", "")
$networknames = $networknames.Replace("User profiles", "")
$networknames = $networknames.Replace("---------------------------------", "")
$networknames = $networknames.Replace("-------------", "")
$networknames = $networknames.split(':')

$networknames = $networknames.Trim()
$networknames = $networknames | Sort-Object -Descending
$networknames = $networknames.trim() -ne ""

#for loop to iterate through every network found and to show every password in cleartext 
$passwords = foreach($name in $networknames){netsh wlan show profiles $name key=clear}

$passwords = $passwords.Replace(":", "|")
$passwords = $passwords.Replace("    ", "")

$nl = [Environment]::NewLine

$nl

$passwords = $passwords | Select-String -Pattern "SSID name", "Key Content"

$passwords -split '[\n]'

$user = $env:UserName

#change current directory to AppData directory to store our txt file
$appdata = $env:LOCALAPPDATA
cd $appdata

#write txt file and then later delete txt file after we retrieve information needed from it
$passwords >> "Network Keys for $user.txt"

Remove-Item "Network Keys for $user.txt"

$nl

$end = Read-Host -Prompt 'Enter any key to exit program'

