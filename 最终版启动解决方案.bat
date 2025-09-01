@echo off
setlocal enabledelayedexpansion

REM 明确指定Python的完整路径
set "PYTHON_EXE=d:\1-软件\python\python.exe"
set "APP_DIR=%~dp0"
set "APP_PY=%APP_DIR%app.py"
set "REQUIREMENTS_TXT=%APP_DIR%requirements.txt"
set "INDEX_HTML=%APP_DIR%index.html"

REM 检查Python是否存在
if not exist "%PYTHON_EXE%" (
    echo 错误：未找到Python解释器在 %PYTHON_EXE%
    echo 请确认Python是否正确安装在此路径下
    pause
    exit /b 1
)

REM 检查app.py是否存在
if not exist "%APP_PY%" (
    echo 错误：未找到app.py文件
    pause
    exit /b 1
)

REM 显示启动信息
cls
echo AI复盘工具 - 完整启动解决方案
 echo. 

echo [步骤1/5] 正在检查Python环境...
%PYTHON_EXE% --version >nul 2>nul
if errorlevel 1 (
    echo 警告：Python版本检查失败，但将继续尝试
) else (
    for /f "tokens=2" %%i in ('%PYTHON_EXE% --version') do set "PYTHON_VERSION=%%i"
    echo 已检测到Python版本: !PYTHON_VERSION!
)

REM 检查并修复pip

echo. 
echo [步骤2/5] 检查并安装pip...

REM 尝试使用get-pip.py安装pip
set "GET_PIP_PY=%APP_DIR%get-pip.py"
if not exist "%GET_PIP_PY%" (
    echo 正在下载get-pip.py...
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://bootstrap.pypa.io/get-pip.py', '%GET_PIP_PY%')"
)

REM 安装pip
%PYTHON_EXE% "%GET_PIP_PY%" --user >nul 2>nul
if errorlevel 1 (
    echo 警告：pip安装失败，将尝试使用已有的pip
) else (
    echo pip安装成功！
)

REM 定义pip路径（可能在用户目录下）
set "PYTHON_USER_SCRIPTS=%USERPROFILE%\AppData\Roaming\Python\Python%PYTHON_VERSION:~0,3%\Scripts"
set "PIP_EXE=%PYTHON_USER_SCRIPTS%\pip.exe"

REM 检查是否有pip可用
set "PIP_COMMAND=%PYTHON_EXE% -m pip"

REM 安装项目依赖
echo. 
echo [步骤3/5] 安装项目依赖...

if exist "%REQUIREMENTS_TXT%" (
    echo 正在安装requirements.txt中的依赖...
    %PIP_COMMAND% install -r "%REQUIREMENTS_TXT%" --user
    if errorlevel 1 (
        echo 警告：依赖安装过程中出现错误，但将继续尝试启动服务
    ) else (
        echo 依赖安装成功！
    )
) else (
    echo 警告：未找到requirements.txt文件，将尝试直接安装所需包
    %PIP_COMMAND% install flask openai python-dotenv flask-cors requests --user
)

REM 检查.env文件
echo. 
echo [步骤4/5] 检查环境配置...
if not exist "%APP_DIR%.env" (
    echo 警告：未找到.env文件，将使用默认配置或示例文件
    if exist "%APP_DIR%.env.example" (
        echo 已找到.env.example文件，请确保已配置OpenAI API密钥
    )
) else (
    echo 已找到.env文件，配置检查通过
)

REM 启动后端服务
echo. 
echo [步骤5/5] 正在启动后端服务...
start "AI Review Backend" cmd /k ""%PYTHON_EXE%" "%APP_PY%""

REM 等待后端服务启动
ping -n 5 127.0.0.1 >nul

echo 正在打开前端页面...
start "" "%INDEX_HTML%"

echo. 
echo ✅ 启动完成！
echo. 
echo [使用说明]
echo 1. 后端服务已在标题为"AI Review Backend"的窗口中运行
echo 2. 前端页面已在浏览器中打开
echo 3. 使用完毕后，请先关闭浏览器，再关闭后端服务窗口
echo. 
echo [问题排查]
echo - 如果浏览器未打开，请手动双击index.html文件
echo - 如果后端服务报错，请检查后端窗口中的错误信息
echo - 常见错误：API密钥无效、依赖未正确安装
echo. 
echo 按任意键关闭此窗口...
pause >nul
endlocal