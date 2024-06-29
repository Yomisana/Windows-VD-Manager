# 服務名稱
$serviceName = "VDManagerService"
$taskName = "VDManagerServiceStartup"

# 檢查是否以管理員權限運行
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-NoExit -c `"cd '$pwd'; & '" + $MyInvocation.MyCommand.Path + "'`""
        Start-Process powershell -Verb runas -ArgumentList $CommandLine
        Exit
    }
}

Uninstall-Module -Name VirtualDesktop

# 刪除工作排程
$task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($task -ne $null) {
    try {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        Write-Output "成功刪除工作排程 '$taskName'。"
    }
    catch {
        Write-Error "刪除工作排程時發生錯誤： $_"
    }
}
else {
    Write-Host "找不到名為 '$taskName' 的工作排程。"
}

Pause
