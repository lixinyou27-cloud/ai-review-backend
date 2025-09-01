@echo off
REM 简化版启动脚本 - 直接启动应用并在浏览器中打开

REM 设置项目路径
SET PROJECT_DIR=%~dp0

REM 步骤1：启动后端服务
start "AI复盘工具后端服务" cmd /k "python "%PROJECT_DIR%app.py"

REM 等待一小段时间确保服务能够正常启动
timeout /t 3 /nobreak >nul

REM 步骤2：在默认浏览器中打开前端页面
start "" "file:///%PROJECT_DIR%index.html"

REM 显示提示信息
echo AI复盘工具已启动！
echo 后端服务正在运行在 http://localhost:5000
echo 前端页面已在浏览器中打开

echo 注意：如需停止应用，请关闭显示"AI复盘工具后端服务"的命令窗口
echo 按任意键退出此窗口...
pause >nul