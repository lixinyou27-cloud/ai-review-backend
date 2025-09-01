@echo off

REM 这个脚本会在桌面上创建AI复盘工具的快捷方式

REM 请以管理员身份运行此脚本

powershell -Command "$wsh = New-Object -ComObject WScript.Shell; $shortcut = $wsh.CreateShortcut([Environment]::GetFolderPath('Desktop')+'\AI复盘工具.lnk'); $shortcut.TargetPath = 'd:\1-软件\Ai编程\run_project.bat'; $shortcut.WorkingDirectory = 'd:\1-软件\Ai编程'; $shortcut.Save(); Write-Host '快捷方式已创建到桌面！'; pause"