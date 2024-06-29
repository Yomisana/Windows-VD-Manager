# 服務名稱
$serviceName = "VDManagerService"
# 服務顯示名稱
$serviceDisplayName = "VD Manager Service"
# 服務描述
$serviceDescription = "Service to manage Windows virtual desktops"
# PowerShell 腳本的路徑
# 保存原始的工作目錄
$originalPath = Get-Location
$scriptPath = Join-Path $originalPath "main.ps1"
Write-Output $($scriptPath)

# 檢查是否以管理員權限運行
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-NoExit -c `"cd '$pwd'; & '" + $MyInvocation.MyCommand.Path + "'`""
        Start-Process powershell -Verb runas -ArgumentList $CommandLine
        Exit
    }
}


# 檢查服務是否已存在
if (Get-Service -Name $serviceName -ErrorAction SilentlyContinue) {
    Write-Host "服務 $serviceName 已經存在。"
    Pause
    exit 1
}


New-Service -Name $serviceName -BinaryPathName $scriptPath -DisplayName $serviceDisplayName -StartupType "Automatic" -Description $serviceDescription

Pause