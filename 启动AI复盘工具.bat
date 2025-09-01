@echo off
chcp 65001 >nul

REM 最简单的AI复盘工具启动脚本

REM 获取当前文件夹路径（不含反斜杠）
set "CURRENT_DIR=%~dp0"
if %CURRENT_DIR:~-1%==\ set "CURRENT_DIR=%CURRENT_DIR:~0,-1%"

REM 启动后端服务
start "AI复盘工具后端" cmd /k "python "%CURRENT_DIR%\app.py""

REM 等待后端服务启动
echo 正在启动后端服务，请稍候...
ping -n 4 127.0.0.1 >nul

REM 打开前端页面
echo 正在打开AI复盘工具...
start "" "%CURRENT_DIR%\index.html"

REM 显示完成信息
echo.
echo ✅ AI复盘工具已成功启动！
echo ℹ️  后端服务运行在 http://localhost:5000
echo ℹ️  前端页面已在浏览器中打开
echo.
echo ⚠️  注意：如需停止服务，请关闭标题为"AI复盘工具后端"的命令窗口
echo.
echo 按任意键关闭此窗口...
pause >nul