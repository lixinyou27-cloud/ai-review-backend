@echo off
chcp 65001 >nul

REM 此脚本用于在桌面上创建AI复盘工具的快捷方式
cls
echo ====================================================================
echo 正在为AI复盘工具创建桌面快捷方式...
echo ====================================================================

REM 直接调用PowerShell执行创建快捷方式的命令
powershell -Command "
$desktop = [Environment]::GetFolderPath('Desktop');
$shortcutPath = Join-Path -Path $desktop -ChildPath 'AI复盘工具.lnk';
$wsh = New-Object -ComObject WScript.Shell;
$shortcut = $wsh.CreateShortcut($shortcutPath);
$shortcut.TargetPath = 'd:\1-软件\Ai编程\run_project.bat';
$shortcut.WorkingDirectory = 'd:\1-软件\Ai编程';
$shortcut.Save();
Write-Host '快捷方式已创建到桌面：AI复盘工具.lnk';
" -NoProfile -ExecutionPolicy Bypass

echo.
echo ====================================================================
echo 操作完成！
echo - 如果看到错误信息，请尝试以管理员身份运行此脚本
 echo - 否则，请检查您的桌面是否已经生成了"AI复盘工具"图标
echo ====================================================================

pause