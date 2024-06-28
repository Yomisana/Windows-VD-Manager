# 服務名稱
$serviceName = "VDManagerService"

# 停止服務
if (Get-Service -Name $serviceName -ErrorAction SilentlyContinue) {
    Stop-Service -Name $serviceName
    # 刪除服務
    Remove-Service -Name $serviceName

    Write-Host "VDManagerService 已成功卸載。"
}
else {
    Write-Host "服務 $serviceName 不存在。"
}
