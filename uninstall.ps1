# Service name
$serviceName = "VDManagerService"
$taskName = "VDManagerServiceStartup"

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

Uninstall-Module -Name VirtualDesktop

# Remove scheduled task
$task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($task -ne $null) {
    try {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
        Write-Output "Successfully deleted scheduled task '$taskName'."
    }
    catch {
        Write-Error "Error occurred while deleting scheduled task: $_"
    }
}
else {
    Write-Host "Could not find scheduled task '$taskName'."
}

Pause
