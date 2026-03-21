-- 通報テーブル
CREATE TABLE IF NOT EXISTS reports (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    reporter_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
    reported_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    reason TEXT NOT NULL CHECK (reason IN ('spam', 'harassment', 'inappropriate_content', 'impersonation', 'other')),
    created_at TIMESTAMPTZ DEFAULT now(),
    -- 投稿かユーザーのどちらかは必須
    CONSTRAINT report_target CHECK (post_id IS NOT NULL OR reported_user_id IS NOT NULL)
);

-- ブロックテーブル
CREATE TABLE IF NOT EXISTS blocks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    blocker_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    blocked_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(blocker_id, blocked_id)
);

-- RLS有効化
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE blocks ENABLE ROW LEVEL SECURITY;

-- 通報ポリシー: 自分の通報のみ挿入可能、管理者以外は読み取り不可
CREATE POLICY "users_can_create_reports" ON reports
    FOR INSERT WITH CHECK (auth.uid() = reporter_id);

CREATE POLICY "users_can_view_own_reports" ON reports
    FOR SELECT USING (auth.uid() = reporter_id);

-- ブロックポリシー
CREATE POLICY "users_can_manage_own_blocks" ON blocks
    FOR ALL USING (auth.uid() = blocker_id);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_reports_reporter ON reports(reporter_id);
CREATE INDEX IF NOT EXISTS idx_reports_post ON reports(post_id);
CREATE INDEX IF NOT EXISTS idx_blocks_blocker ON blocks(blocker_id);
CREATE INDEX IF NOT EXISTS idx_blocks_blocked ON blocks(blocked_id);
