@echo off
setlocal enabledelayedexpansion

REM 明确指定Python的完整路径
set "PYTHON_EXE=d:\1-软件\python\python.exe"
set "APP_DIR=%~dp0"
set "REQUIREMENTS_TXT=%APP_DIR%requirements.txt"

REM 检查Python是否存在
if not exist "%PYTHON_EXE%" (
    echo 错误：未找到Python解释器在 %PYTHON_EXE%
    echo 请确认Python是否正确安装在此路径下
    pause
    exit /b 1
)

cls
echo ==========================================================
echo            AI复盘工具 - 强制安装pip和项目依赖
echo ==========================================================

echo [1/3] 正在检查Python环境...
%PYTHON_EXE% --version
if errorlevel 1 (
    echo 错误：Python无法正常运行，请检查Python安装
    pause
    exit /b 1
)

REM 显示Python版本
for /f "tokens=2" %%i in ('%PYTHON_EXE% --version') do set "PYTHON_VERSION=%%i"
echo 已检测到Python版本: !PYTHON_VERSION!

REM 下载get-pip.py
echo.
echo [2/3] 正在下载get-pip.py安装脚本...
set "GET_PIP_PY=%APP_DIR%get-pip.py"
if exist "%GET_PIP_PY%" (
    echo 已找到get-pip.py，跳过下载
) else (
    echo 正在从官方网站下载get-pip.py...
    powershell -Command "Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile '%GET_PIP_PY%'"
    if errorlevel 1 (
        echo 错误：下载get-pip.py失败
        echo 请手动下载get-pip.py并放在此目录下
        pause
        exit /b 1
    )
)

REM 强制安装pip
echo.
echo [3/3] 正在强制安装pip...
%PYTHON_EXE% "%GET_PIP_PY%" --force-reinstall --user
if errorlevel 1 (
    echo 错误：pip安装失败！
    echo 请尝试以管理员身份运行此脚本
    pause
    exit /b 1
)

REM 安装成功后，验证pip是否可用
echo.
echo 正在验证pip是否安装成功...
for /d %%i in ("%USERPROFILE%\AppData\Roaming\Python\Python*\Scripts") do (
    set "PIP_PATH=%%i\pip.exe"
    if exist "!PIP_PATH!" (
        echo 找到pip: !PIP_PATH!
        goto pip_found
    )
)

:pip_found
if not defined PIP_PATH (
    echo 警告：未找到pip安装路径，但将尝试使用Python -m pip
    set "PIP_COMMAND=%PYTHON_EXE% -m pip"
) else (
    set "PIP_COMMAND=!PIP_PATH!"
)

REM 安装项目依赖
echo.
echo 正在安装项目依赖...

if exist "%REQUIREMENTS_TXT%" (
    echo 正在安装requirements.txt中的依赖...
    !PIP_COMMAND! install -r "%REQUIREMENTS_TXT%" --user --force-reinstall
) else (
    echo 未找到requirements.txt，直接安装所需包...
    !PIP_COMMAND! install flask==2.0.1 openai==0.27.0 python-dotenv==0.20.0 flask-cors==3.0.10 requests==2.27.1 --user --force-reinstall
)

if errorlevel 1 (
    echo 错误：依赖安装失败！
    echo 请检查网络连接或尝试手动安装
    echo 手动安装命令：!PIP_COMMAND! install flask openai python-dotenv flask-cors requests --user
    pause
    exit /b 1
) else (
    echo.
echo ==========================================================
echo ✅ 成功！pip和所有项目依赖已安装完成
echo ==========================================================
echo 现在您可以运行 "最终版启动解决方案.bat" 来启动应用了
 echo 或直接运行：%PYTHON_EXE% %APP_DIR%app.py
echo.
echo 按任意键关闭此窗口...
    pause >nul
)

endlocal