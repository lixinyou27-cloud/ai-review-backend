# AI辅助复盘工具

一个基于AI的个人复盘分析工具，可以帮助用户记录和分析每日复盘内容，提供行动建议和学习资源推荐。

## 功能特性

- 每日复盘记录和分析
- AI驱动的内容拆解和洞察生成
- 个性化的行动策略建议
- 学习资源推荐
- 潜在天赋和商业机会分析
- 明日待办清单生成

## 技术栈

- 前端：HTML, CSS, JavaScript, Tailwind CSS
- 后端：Python, Flask
- AI服务：OpenAI API

## 项目结构

```
├── index.html       # 前端主页面
├── app.py           # 后端API服务
├── requirements.txt # Python依赖包
├── .gitignore       # Git忽略文件配置
└── .env.example     # 环境变量示例文件
```

## 快速开始

### 前置要求

- Python 3.7+ 已安装
- OpenAI API密钥
- Git 已安装

### 本地开发环境设置

1. 克隆仓库

```bash
git clone https://github.com/lixinyou27-cloud/ai-review-backend.git
cd ai-review-backend
```

2. 安装依赖

```bash
pip install -r requirements.txt
```

3. 配置环境变量

复制`.env.example`文件并重命名为`.env`，然后填入你的OpenAI API密钥：

```bash
cp .env.example .env
# 编辑.env文件，设置OPENAI_API_KEY=你的API密钥
```

4. 启动后端服务

```bash
python app.py
```

5. 打开前端页面

直接在浏览器中打开`index.html`文件即可使用。

## 部署指南

可以将后端服务部署到各种平台，如Render、Koyeb、Deta等。部署时需要设置`OPENAI_API_KEY`环境变量。

部署后，需要修改`index.html`文件中的`backendUrl`变量，指向你的实际后端服务URL。

## 使用说明

1. 在文本框中输入你的每日复盘内容
2. 选择或添加相关标签
3. 点击"让AI分析"按钮
4. 查看AI生成的分析结果、行动策略、推荐资源等
5. 可以保存或导出分析结果

## 注意事项

- OpenAI API调用可能会产生费用，请确保你的账户有足够的余额
- 请妥善保管你的API密钥，不要泄露给他人
- 免费的部署平台可能有使用时长限制

## 贡献指南

欢迎提交Issue和Pull Request来改进这个项目。

## License

[MIT](LICENSE)