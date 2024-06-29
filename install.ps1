# Define variables
$taskName = "VDManagerServiceStartup"
$taskDescription = "Task to start VD Manager Service on user logon"
$serviceName = "VDManagerService"
#$originalPath = Get-Location
#$scriptPath = Join-Path $originalPath "main.ps1"
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
Set-Location -Path $scriptPath

$scriptToRun = Join-Path -Path $scriptPath -ChildPath "main.ps1"
Write-Output $($scriptPath)
Write-Output $($scriptToRun)
# Check if running with administrator privileges
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-NoExit -c `"cd '$pwd'; & '" + $MyInvocation.MyCommand.Path + "'`""
        Start-Process powershell -Verb runas -ArgumentList $CommandLine
        Exit
    }
}

# RemoteSigned Unrestricted
$executionPolicy = Get-ExecutionPolicy -Scope Process
if ($executionPolicy -ne "RemoteSigned" -and $executionPolicy -ne "Unrestricted") {
    Set-ExecutionPolicy RemoteSigned -Scope Process -Force
}


# Create trigger - At logon
$trigger = New-ScheduledTaskTrigger -AtLogon

# Create action - Run PowerShell script
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptToRun`""

# Register scheduled task
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -RunLevel Highest -Force
Write-Output "Successfully configured task '$taskName' to start the service on user logon."
Pause