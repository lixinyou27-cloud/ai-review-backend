# 此PowerShell脚本用于在桌面上创建AI复盘工具的快捷方式
Write-Host "=====================================================" -ForegroundColor Green
Write-Host "正在为AI复盘工具创建桌面快捷方式..." -ForegroundColor Green
Write-Host "====================================================="

# 获取当前脚本所在路径
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
# 获取用户桌面路径
$DesktopPath = [System.Environment]::GetFolderPath('Desktop')
# 设置快捷方式名称
$ShortcutName = "AI复盘工具.lnk"
# 设置要创建快捷方式的目标脚本路径
$TargetScript = Join-Path -Path $ScriptPath -ChildPath "run_project.bat"
# 快捷方式完整路径
$ShortcutPath = Join-Path -Path $DesktopPath -ChildPath $ShortcutName

# 检查目标脚本是否存在
if (-Not (Test-Path -Path $TargetScript)) {
    Write-Host "错误：找不到目标脚本 $TargetScript" -ForegroundColor Red
    Write-Host "请确保项目文件完整。" -ForegroundColor Red
    pause
    exit 1
}

# 创建快捷方式
try {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $TargetScript
    $Shortcut.WorkingDirectory = $ScriptPath
    $Shortcut.Save()
    
    Write-Host ""
    Write-Host "=====================================================" -ForegroundColor Green
    Write-Host "成功！快捷方式已创建在您的桌面上。" -ForegroundColor Green
    Write-Host "快捷方式名称：$ShortcutName" -ForegroundColor Green
    Write-Host "=====================================================" -ForegroundColor Green
    Write-Host "使用方法：" -ForegroundColor Green
    Write-Host "1. 双击桌面上的"$ShortcutName"图标" -ForegroundColor Green
    Write-Host "2. 等待脚本自动安装依赖、测试API并启动后端服务" -ForegroundColor Green
    Write-Host "3. 服务启动后，会自动在浏览器中打开前端页面" -ForegroundColor Green
    Write-Host "=====================================================" -ForegroundColor Green
    Write-Host "注意事项：" -ForegroundColor Green
    Write-Host "- 首次运行可能需要一些时间安装依赖" -ForegroundColor Green
    Write-Host "- 请确保您的电脑已连接互联网" -ForegroundColor Green
    Write-Host "- 请不要关闭运行中的命令提示符窗口" -ForegroundColor Green
    Write-Host "=====================================================" -ForegroundColor Green
} catch {
    Write-Host "错误：创建快捷方式失败。错误信息：$($_.Exception.Message)" -ForegroundColor Red
    Write-Host "请尝试以管理员身份运行此脚本。" -ForegroundColor Red
}

pause