@echo off
REM 一键运行AI复盘工具项目的批处理脚本
REM 此脚本使用完整的Python路径，无需将Python添加到PATH

SET PYTHON_PATH=d:\1-软件\python
SET PROJECT_DIR=%~dp0

REM 检查Python安装路径是否存在
IF NOT EXIST "%PYTHON_PATH%\python.exe" (
    echo 错误：Python安装路径 %PYTHON_PATH% 不存在或Python未正确安装。
    echo 请修改此脚本中的PYTHON_PATH变量为您的Python实际安装路径。
    pause
    exit /b 1
)

REM 步骤1：安装项目依赖
cls
echo ====================================================================
echo 步骤1：安装项目依赖
echo ====================================================================
"%PYTHON_PATH%\python.exe" -m pip install -r "%PROJECT_DIR%requirements.txt"

IF %ERRORLEVEL% NEQ 0 (
    echo 错误：依赖安装失败。
    echo 请检查您的网络连接和Python环境。
    pause
    exit /b 1
)

REM 步骤2：测试OpenAI API连接
echo.
echo ====================================================================
echo 步骤2：测试OpenAI API连接
echo ====================================================================
"%PYTHON_PATH%\python.exe" "%PROJECT_DIR%test_with_full_path.py"

IF %ERRORLEVEL% NEQ 0 (
    echo 警告：API连接测试失败。
    echo 您仍然可以启动后端服务，但AI功能可能无法正常工作。
    pause
)

REM 步骤3：启动后端服务
echo.
echo ====================================================================
echo 步骤3：启动后端服务
echo ====================================================================
echo 后端服务将在 http://localhost:5000 启动

echo 正在打开浏览器...
REM 等待一小段时间确保服务能够正常启动
timeout /t 2 /nobreak >nul
REM 打开浏览器访问前端页面
start chrome "file:///%PROJECT_DIR%index.html" || start "" "file:///%PROJECT_DIR%index.html"

echo 按 Ctrl+C 可以停止后端服务
echo.
"%PYTHON_PATH%\python.exe" "%PROJECT_DIR%app.py"

pause