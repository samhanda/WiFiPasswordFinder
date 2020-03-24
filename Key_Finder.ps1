$host.ui.RawUI.WindowTitle = "WiFi Key Finder by Samir Handa"

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Start-Sleep -Seconds 1

cls

$networknames = netsh wlan show profiles

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

$passwords = foreach($name in $networknames){netsh wlan show profiles $name key=clear}

$passwords = $passwords.Replace(":", "|")

#$color = Write-Host -f red -nonewline

$passwords = $passwords.Replace("    ", "")

$nl = [Environment]::NewLine

$nl

$passwords = $passwords | Select-String -Pattern "SSID name", "Key Content"

#Write-Output $passwords[3]

$passwords -split '[\n]'

#$passwords = Write-Host "$passwords" -ForegroundColor Red | Select-String -Pattern "SSID name", "Key Content"

$user = $env:UserName

$appdata = $env:LOCALAPPDATA

cd $appdata

$passwords >> "Network Keys for $user.txt"

Remove-Item "Network Keys for $user.txt"

$nl

$end = Read-Host -Prompt 'Enter any key to exit program'

