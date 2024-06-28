###### 設定 ######
$desktop = [System.Environment]::GetFolderPath('Desktop')
$maxTelegram = 10
$timeout = 1
###### 設定 ######

# 確認是否安裝了 VirtualDesktop 模組，沒有的話就安裝
if (-not (Get-Module -ListAvailable -Name VirtualDesktop)) {
    Write-Output "VirtualDesktop module not found. Installing..."
    Install-Module -Name VirtualDesktop -Scope CurrentUser -Force
}
else {
    Write-Output "VirtualDesktop module already installed."
}

# Hello world!
Write-Output "Current desktop: $(Get-DesktopCount)"

# Clear all desktops
Remove-AllDesktops
Write-Output "All desktops removed."

$lnkfiles = Get-ChildItem -Path "$desktop\Startup\Telegram_*.lnk" | Sort-Object { [int]($_.BaseName -replace 'Telegram_', '') }
Write-Output "Telegram_*.lnk files: $($lnkfiles.Count)"

# get how many desktops need to add
$add_desk = [math]::Round($lnkfiles.Count / $maxTelegram, 0, [MidpointRounding]::AwayFromZero)
Write-Output "$add_desk need add."

# Initial add desktops
for ($i = 0; $i -lt $add_desk; $i++) {
    New-Desktop
    Write-Output "Desktop $i added."
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