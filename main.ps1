###### Settings ######
$desktop = [System.Environment]::GetFolderPath('Desktop')
$maxTelegram = 10
$timeout = 1
###### Settings ######

# Check if running with administrator privileges
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-NoExit -c `"cd '$pwd'; & '" + $MyInvocation.MyCommand.Path + "'`""
        Start-Process powershell -Verb runas -ArgumentList $CommandLine
        Exit
    }
}

# Check if VirtualDesktop module is installed, install if not
if (-not (Get-Module -ListAvailable -Name VirtualDesktop)) {
    Write-Output "VirtualDesktop module not found. Installing..."
    Install-PackageProvider NuGet -Force;
    Set-PSRepository PSGallery -InstallationPolicy Trusted
    Install-Module -Name VirtualDesktop -Scope CurrentUser -Confirm:$False -Force
}
else {
    Write-Output "VirtualDesktop module already installed."
}

# Hello world!
Write-Output "Current desktop: $(Get-DesktopCount)"

# Clear all desktops
#Remove-AllDesktops
#Write-Output "All desktops removed."

# Get all Telegram lnk files from startup directory
$lnkfiles = Get-ChildItem -Path "$desktop\Startup\Telegram_*.lnk" | Sort-Object { [int]($_.BaseName -replace 'Telegram_', '') }
Write-Output "Telegram_*.lnk files: $($lnkfiles.Count)"
Write-Output "$($lnkfiles.Count) / $maxTelegram => $([math]::Ceiling($lnkfiles.Count / $maxTelegram))"
# get how many desktops need to add
$add_desk = [math]::Ceiling($lnkfiles.Count / $maxTelegram)
Write-Output "total need $add_desk VD."

# Initial add desktops
if ((Get-DesktopCount) - 1 -lt $add_desk) {
    Write-Output "Not enough VD, adding more..."

    $VDN = (Get-DesktopCount) - 1
    $final_VD = $add_desk - $VDN
    Write-Output "need create more $final_VD"
    for ($i = 0; $i -lt $final_VD; $i++) {
        New-Desktop
        Write-Output "Desktop $i added."
    }
}
else {
    Write-Output "Enough VD"
}

$desktops_count = Get-DesktopCount
$desktops_index = 1
Write-Output "Desktops count: $desktops_count"
Write-Output "Desktops index: $desktops_index"

# Initial switch to desktop 1
Switch-Desktop -Desktop $desktops_index
Write-Output "Switch to desktop $desktops_index"
Start-Sleep -Seconds 1

# Main loop
$lnkCounter = 0
for ($i = 1; $i -le $lnkfiles.Count; $i++) {
    if ($lnkCounter -ge $maxTelegram) {
        $desktops_index++
        if ($desktops_index -gt $desktops_count) {
            $desktops_index = 1
        }
        Switch-Desktop -Desktop $desktops_index
        Write-Output "Switch to desktop $desktops_index"
        $lnkCounter = 0
        Start-Sleep -Seconds $timeout
    }
    $lnkFile = $lnkfiles[$i - 1]
    Start-Process -FilePath $lnkFile.FullName
    Write-Output "Start $($lnkFile.FullName) on desktop $desktops_index with lnkCounter $lnkCounter"
    $lnkCounter++
    Start-Sleep -Seconds $timeout
}