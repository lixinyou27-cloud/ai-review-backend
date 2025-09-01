@echo off
setlocal enabledelayedexpansion

REM 明确指定Python的完整路径
set "PYTHON_EXE=d:\1-软件\python\python.exe"
set "APP_DIR=%~dp0"
set "APP_PY=%APP_DIR%app.py"
set "INDEX_HTML=%APP_DIR%index.html"
set "REQUIREMENTS_TXT=%APP_DIR%requirements.txt"

cls
echo ==========================================================
echo                     AI复盘工具 - 最终启动器
echo ==========================================================

echo [1/4] 正在检查Python环境...
%PYTHON_EXE% --version >nul 2>nul
if errorlevel 1 (
    echo 错误：Python无法正常运行
    echo 请确认您已经正确安装了Python
    pause
    exit /b 1
) else (
    for /f "tokens=2" %%i in ('%PYTHON_EXE% --version') do set "PYTHON_VERSION=%%i"
    echo 已检测到Python版本: !PYTHON_VERSION!
)

REM 检查pip是否可用
echo.
echo [2/4] 正在检查pip是否安装...
%PYTHON_EXE% -m pip --version >nul 2>nul
if errorlevel 1 (
    echo 错误：pip未安装或无法正常使用
    echo 请运行"强制安装依赖.bat"来安装pip
    pause
    exit /b 1
) else (
    echo pip已成功安装
)

REM 检查项目依赖
echo.
echo [3/4] 正在检查项目依赖...
set "MISSING_DEPENDENCIES=false"

REM 检查主要依赖包
echo 正在检查关键依赖包...
for %%d in (flask openai python-dotenv flask-cors requests) do (
    %PYTHON_EXE% -c "import %%d" >nul 2>nul
    if errorlevel 1 (
        echo 警告：缺少依赖包 %%d
        set "MISSING_DEPENDENCIES=true"
    )
)

REM 如果缺少依赖，尝试安装
echo.
if "!MISSING_DEPENDENCIES!" equ "true" (
    echo 检测到缺少依赖包，正在尝试安装...
    %PYTHON_EXE% -m pip install -r "%REQUIREMENTS_TXT%" --user
    if errorlevel 1 (
        echo 警告：依赖安装失败，但将尝试启动应用
    )
) else (
    echo 所有关键依赖包已安装完成！
)

REM 检查.env文件
echo.
echo [4/4] 正在检查环境配置...
if not exist "%APP_DIR%.env" (
    echo 警告：未找到.env文件！
    echo 请确保已创建.env文件并配置了OpenAI API密钥
    if exist "%APP_DIR%.env.example" (
        echo 您可以参考.env.example文件进行配置
    )
) else (
    echo 已找到.env文件
    REM 检查是否包含API密钥（简单检查，不读取实际密钥值）
    findstr /i "OPENAI_API_KEY=" "%APP_DIR%.env" >nul
    if errorlevel 1 (
        echo 警告：.env文件中未找到OPENAI_API_KEY配置！
        echo 请确保正确配置了OpenAI API密钥
    ) else (
        echo OpenAI API密钥已配置
    )
)

REM 启动后端服务
echo.
echo ==========================================================
echo ✅ 环境检查完成，准备启动后端服务
echo ==========================================================
echo 正在启动AI复盘工具后端服务...
echo 请不要关闭此窗口，也不要关闭后端服务窗口

echo.
echo [重要提示]
echo 1. 后端服务启动后，前端页面将自动打开
echo 2. 使用过程中请保持后端服务窗口运行
echo 3. 使用完毕后，请先关闭浏览器，再关闭后端服务窗口
echo.
echo 按任意键开始启动...
pause >nul

REM 启动后端服务（新窗口）
start "AI Review Backend" cmd /k ""%PYTHON_EXE%" "%APP_PY%""

REM 等待后端服务启动
ping -n 5 127.0.0.1 >nul

REM 打开前端页面
echo 正在打开前端页面...
start "" "%INDEX_HTML%"

echo.
echo ==========================================================
echo ✅ AI复盘工具已成功启动！
echo ==========================================================
echo 后端服务正在端口5000运行
 echo 前端页面已在浏览器中打开
echo.
echo [使用帮助]
echo - 如果浏览器未自动打开，请手动双击index.html文件
 echo - 如果后端服务报错，请检查后端窗口中的错误信息
 echo - 常见问题：OpenAI API密钥无效、端口被占用

echo 按任意键关闭此窗口...
pause >nul

endlocal