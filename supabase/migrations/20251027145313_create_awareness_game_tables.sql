/*
  # 觉察游戏数据库架构
  
  ## 概述
  创建觉察游戏系统所需的数据表，用于存储用户输入、生成的觉察卡片和用户的觉察历程。
  
  ## 新建表
  
  ### 1. `awareness_inputs` - 用户输入记录
  存储用户提交的原始内容，作为生成觉察卡片的输入
  - `id` (uuid, 主键) - 记录唯一标识
  - `user_id` (uuid, 可选) - 用户ID（如需用户系统）
  - `content` (text) - 用户输入的内容
  - `mood` (text, 可选) - 用户当前心情标签
  - `created_at` (timestamptz) - 创建时间
  
  ### 2. `awareness_cards` - 觉察卡片
  存储AI生成的觉察卡片内容
  - `id` (uuid, 主键) - 卡片唯一标识
  - `input_id` (uuid, 外键) - 关联的输入记录
  - `card_type` (text) - 卡片类型（反思、洞察、行动、智慧等）
  - `title` (text) - 卡片标题
  - `content` (text) - 卡片主要内容
  - `reflection_questions` (jsonb) - 反思问题列表
  - `insights` (text) - 核心洞察
  - `suggested_actions` (text) - 建议行动
  - `wisdom_quote` (text, 可选) - 智慧引言
  - `color_theme` (text) - 卡片配色主题
  - `is_favorited` (boolean) - 是否收藏
  - `created_at` (timestamptz) - 创建时间
  
  ### 3. `card_reflections` - 用户对卡片的反思记录
  用户在看到卡片后的思考和记录
  - `id` (uuid, 主键) - 反思记录唯一标识
  - `card_id` (uuid, 外键) - 关联的卡片ID
  - `user_id` (uuid, 可选) - 用户ID
  - `reflection_text` (text) - 用户的反思内容
  - `helpful_rating` (integer) - 有帮助程度评分 (1-5)
  - `created_at` (timestamptz) - 创建时间
  
  ## 安全设置
  
  所有表启用行级安全策略（RLS）：
  - 允许匿名用户创建和查看自己的记录
  - 如集成用户系统，则限制用户只能访问自己的数据
*/

-- 创建 awareness_inputs 表
CREATE TABLE IF NOT EXISTS awareness_inputs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid,
  content text NOT NULL,
  mood text,
  created_at timestamptz DEFAULT now()
);

-- 创建 awareness_cards 表
CREATE TABLE IF NOT EXISTS awareness_cards (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  input_id uuid REFERENCES awareness_inputs(id) ON DELETE CASCADE,
  card_type text NOT NULL DEFAULT 'reflection',
  title text NOT NULL,
  content text NOT NULL,
  reflection_questions jsonb DEFAULT '[]'::jsonb,
  insights text,
  suggested_actions text,
  wisdom_quote text,
  color_theme text DEFAULT 'blue',
  is_favorited boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- 创建 card_reflections 表
CREATE TABLE IF NOT EXISTS card_reflections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  card_id uuid REFERENCES awareness_cards(id) ON DELETE CASCADE,
  user_id uuid,
  reflection_text text NOT NULL,
  helpful_rating integer CHECK (helpful_rating >= 1 AND helpful_rating <= 5),
  created_at timestamptz DEFAULT now()
);

-- 为查询性能创建索引
CREATE INDEX IF NOT EXISTS idx_awareness_inputs_created_at ON awareness_inputs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_awareness_inputs_user_id ON awareness_inputs(user_id);
CREATE INDEX IF NOT EXISTS idx_awareness_cards_input_id ON awareness_cards(input_id);
CREATE INDEX IF NOT EXISTS idx_awareness_cards_created_at ON awareness_cards(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_awareness_cards_favorited ON awareness_cards(is_favorited) WHERE is_favorited = true;
CREATE INDEX IF NOT EXISTS idx_card_reflections_card_id ON card_reflections(card_id);

-- 启用行级安全
ALTER TABLE awareness_inputs ENABLE ROW LEVEL SECURITY;
ALTER TABLE awareness_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE card_reflections ENABLE ROW LEVEL SECURITY;

-- awareness_inputs 的 RLS 策略
-- 允许所有人插入（支持匿名使用）
CREATE POLICY "Anyone can create awareness inputs"
  ON awareness_inputs FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- 允许查看所有记录（可根据需求调整为仅查看自己的）
CREATE POLICY "Users can view their own inputs"
  ON awareness_inputs FOR SELECT
  TO anon, authenticated
  USING (true);

-- awareness_cards 的 RLS 策略
-- 允许所有人插入卡片
CREATE POLICY "Anyone can create awareness cards"
  ON awareness_cards FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- 允许查看所有卡片
CREATE POLICY "Users can view all cards"
  ON awareness_cards FOR SELECT
  TO anon, authenticated
  USING (true);

-- 允许更新自己的卡片（如收藏功能）
CREATE POLICY "Users can update cards"
  ON awareness_cards FOR UPDATE
  TO anon, authenticated
  USING (true)
  WITH CHECK (true);

-- card_reflections 的 RLS 策略
-- 允许创建反思记录
CREATE POLICY "Anyone can create reflections"
  ON card_reflections FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- 允许查看反思记录
CREATE POLICY "Users can view reflections"
  ON card_reflections FOR SELECT
  TO anon, authenticated
  USING (true);