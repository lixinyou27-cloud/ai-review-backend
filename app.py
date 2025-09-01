from flask import Flask, request, jsonify
from flask_cors import CORS
import openai
import os
from dotenv import load_dotenv

# 加载环境变量
load_dotenv()

# 创建Flask应用
app = Flask(__name__)
CORS(app)  # 启用CORS，允许前端请求

# 设置OpenAI API密钥
openai.api_key = os.getenv('OPENAI_API_KEY')

@app.route('/analyze_content', methods=['POST'])
def analyze_content():
    try:
        # 获取请求数据
        data = request.json
        review_content = data.get('content', '')
        tags = data.get('tags', [])
        
        if not review_content:
            return jsonify({'error': '请提供复盘内容'}), 400
        
        # 构建提示词
        prompt = f"""我需要分析一段个人复盘内容，并从中提取有价值的信息。请按照以下要求进行分析：
1. 内容拆解：将复盘内容拆分为关键事件、情感、遇到的问题、解决方案、学习心得等字段
2. 下一步行动策略：根据复盘内容，提供具体、可操作的行动建议
3. 推荐学习资源：根据复盘内容中提到的技能或知识缺口，推荐相关学习资源
4. 潜在天赋：分析内容中显示的个人优势和潜在天赋
5. 可变现的商业需求：分析内容中提到的问题是否存在商业机会
6. 明日待办清单：根据今天的复盘内容，生成合理的明日待办事项

复盘内容：{review_content}
标签：{', '.join(tags)} """
        
        # 调用OpenAI API
        response = openai.Completion.create(
            engine="text-davinci-003",  # 使用适合的模型
            prompt=prompt,
            max_tokens=1000,
            n=1,
            stop=None,
            temperature=0.7,
        )
        
        # 解析响应
        analysis_result = response.choices[0].text.strip()
        
        # 这里是简化的处理，实际应用中可能需要更复杂的解析逻辑
        # 将AI返回的文本分割成不同部分
        result_parts = analysis_result.split('\n\n')
        
        # 构建返回结果
        result = {
            'analysis': analysis_result,
            'fields': [],
            'action_strategies': [],
            'recommended_resources': [],
            'potential_talents': '',
            'business_opportunities': '',
            'tomorrow_todo': []
        }
        
        # 简单的结果解析（实际应用中需要更复杂的逻辑）
        for part in result_parts:
            if '内容拆解' in part:
                # 提取内容拆解部分
                fields_text = part.split('内容拆解：')[1] if '内容拆解：' in part else part
                for line in fields_text.split('\n'):
                    if ':' in line:
                        key_value = line.split(':', 1)
                        if len(key_value) == 2:
                            result['fields'].append({
                                'field': key_value[0].strip(),
                                'content': key_value[1].strip(),
                                'analysis': ''  # 这里可以添加更多的分析
                            })
            elif '下一步行动策略' in part:
                # 提取行动策略部分
                strategies_text = part.split('下一步行动策略：')[1] if '下一步行动策略：' in part else part
                for line in strategies_text.split('\n'):
                    if line.strip():
                        result['action_strategies'].append(line.strip())
            elif '推荐学习资源' in part:
                # 提取推荐资源部分
                resources_text = part.split('推荐学习资源：')[1] if '推荐学习资源：' in part else part
                result['recommended_resources'] = resources_text.strip()
            elif '潜在天赋' in part:
                # 提取潜在天赋部分
                talents_text = part.split('潜在天赋：')[1] if '潜在天赋：' in part else part
                result['potential_talents'] = talents_text.strip()
            elif '可变现的商业需求' in part:
                # 提取商业机会部分
                business_text = part.split('可变现的商业需求：')[1] if '可变现的商业需求：' in part else part
                result['business_opportunities'] = business_text.strip()
            elif '明日待办清单' in part:
                # 提取明日待办部分
                todo_text = part.split('明日待办清单：')[1] if '明日待办清单：' in part else part
                for line in todo_text.split('\n'):
                    if line.strip():
                        result['tomorrow_todo'].append(line.strip())
        
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/')
def home():
    return "AI复盘工具后端服务正在运行！"

if __name__ == '__main__':
    app.run(debug=True)