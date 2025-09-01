@echo off

REM 设置代码页为UTF-8，确保中文正常显示
chcp 65001 >nul

REM 定义变量时避免使用中文
set "DIR=%~dp0"

REM 启动后端服务（使用英文标题）
start "AI Review Backend" cmd /k "python "%DIR%app.py""

REM 等待后端服务启动
cls
echo 正在启动后端服务，请稍候...
ping -n 4 127.0.0.1 >nul

REM 打开前端页面
cls
echo 正在打开AI复盘工具...
start "" "%DIR%index.html"

REM 显示完成信息（使用简单英文和符号）
cls
echo.
echo [OK] 应用已成功启动！
echo [INFO] 后端服务运行在 http://localhost:5000
echo [INFO] 前端页面已在浏览器中打开
echo.
echo [NOTE] 如需停止服务，请关闭标题为"AI Review Backend"的命令窗口
echo.
echo 按任意键关闭此窗口...
pause >nul