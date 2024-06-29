# 服務名稱
$serviceName = "VDManagerService"

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "請以管理員權限運行此腳本！"
    if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
        Exit
    }
    Pause
    #exit 1
}

# 停止服務
if (Get-Service -Name $serviceName -ErrorAction SilentlyContinue) {
    #Stop-Service -Name $serviceName
    # 刪除服務
    #Remove-Service -Name $serviceName
    sc.exe delete $serviceName
    #Write-Host "VDManagerService 已成功卸載。"
}
else {
    Write-Host "服務 $serviceName 不存在。"
}

Pause