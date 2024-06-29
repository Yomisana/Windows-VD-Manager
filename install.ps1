# Define variables
$taskName = "VDManagerServiceStartup"
$taskDescription = "Task to start VD Manager Service on user logon"
$serviceName = "VDManagerService"
$originalPath = Get-Location
$scriptPath = Join-Path $originalPath "main.ps1"
Write-Output $($scriptPath)

# Check if running with administrator privileges
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-NoExit -c `"cd '$pwd'; & '" + $MyInvocation.MyCommand.Path + "'`""
        Start-Process powershell -Verb runas -ArgumentList $CommandLine
        Exit
    }
}

# Create trigger - At logon
$trigger = New-ScheduledTaskTrigger -AtLogon

# Create action - Run PowerShell script
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""

# Register scheduled task
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -RunLevel Highest -Force
Write-Output "Successfully configured task '$taskName' to start the service on user logon."
Pause