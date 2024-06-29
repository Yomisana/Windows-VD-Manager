# 定義變數
$taskName = "VDManagerServiceStartup"
$taskDescription = "Task to start VD Manager Service on user logon"
$serviceName = "VDManagerService"
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

# 建立觸發器 - 登入時啟動
$trigger = New-ScheduledTaskTrigger -AtLogon

# 建立動作 - 執行 PowerShell 腳本
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""

# 註冊工作排程
#Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Description $taskDescription -User "SYSTEM"
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -RunLevel Highest -Force
Write-Output "已成功設置工作排程 '$taskName' 以在使用者登入時啟動服務。"
Pause