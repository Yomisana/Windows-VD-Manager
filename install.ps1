# 服務名稱
$serviceName = "VDManagerService"
# 服務顯示名稱
$serviceDisplayName = "VD Manager Service"
# 服務描述
$serviceDescription = "Service to manage Windows virtual desktops"
# PowerShell 腳本的路徑
$scriptPath = (Join-Path (Get-Location) "main.ps1")

# 檢查服務是否已存在
if (Get-Service -Name $serviceName -ErrorAction SilentlyContinue) {
    Write-Host "服務 $serviceName 已經存在。"
    exit 1
}

# 創建服務
New-Service -Name $serviceName -Binary "powershell.exe" -ArgumentList "-File `"$scriptPath`"" -DisplayName $serviceDisplayName -Description $serviceDescription -StartupType Automatic

# 啟動服務
Start-Service -Name $serviceName

Write-Host "VDManagerService 已成功安裝並啟動。"
