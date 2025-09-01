@echo off
REM 使用简单命令创建桌面快捷方式
setlocal enabledelayedexpansion

REM 获取桌面路径
for /f "tokens=2*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v Desktop') do set "DESKTOP=%%b"

REM 定义项目路径
set "PROJECT_DIR=%~dp0"

REM 创建快捷方式（通过临时VBS脚本）
echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "!DESKTOP!\AI复盘工具.lnk" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "!PROJECT_DIR!run_project.bat" >> CreateShortcut.vbs
echo oLink.WorkingDirectory = "!PROJECT_DIR!" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs

REM 运行VBS脚本创建快捷方式
cscript //nologo CreateShortcut.vbs

REM 删除临时VBS文件
del CreateShortcut.vbs

REM 显示结果
if exist "!DESKTOP!\AI复盘工具.lnk" (
    echo 成功：桌面快捷方式已创建！
) else (
    echo 错误：无法创建桌面快捷方式。
    echo 请手动创建：右键点击run_project.bat，选择"发送到" - "桌面快捷方式"
    echo 然后将桌面快捷方式重命名为"AI复盘工具"
)

pause
endlocal