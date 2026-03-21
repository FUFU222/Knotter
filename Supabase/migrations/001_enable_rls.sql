-- ============================================
-- Knotter RLS (Row Level Security) ポリシー
-- Supabase Dashboard > SQL Editor で実行してください
-- ============================================

-- ==================
-- 1. profiles テーブル
-- ==================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "profiles_select_public" ON profiles
  FOR SELECT USING (true);

CREATE POLICY "profiles_update_own" ON profiles
  FOR UPDATE USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- ==================
-- 2. posts テーブル
-- ==================
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "posts_select_public" ON posts
  FOR SELECT USING (true);

CREATE POLICY "posts_insert_own" ON posts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "posts_delete_own" ON posts
  FOR DELETE USING (auth.uid() = user_id);

-- ==================
-- 3. likes テーブル
-- ==================
ALTER TABLE likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "likes_select_public" ON likes
  FOR SELECT USING (true);

CREATE POLICY "likes_insert_own" ON likes
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "likes_delete_own" ON likes
  FOR DELETE USING (auth.uid() = user_id);

-- ==================
-- 4. comments テーブル
-- ==================
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "comments_select_public" ON comments
  FOR SELECT USING (true);

CREATE POLICY "comments_insert_own" ON comments
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "comments_delete_own" ON comments
  FOR DELETE USING (auth.uid() = user_id);

-- ==================
-- 5. follows テーブル
-- ==================
ALTER TABLE follows ENABLE ROW LEVEL SECURITY;

CREATE POLICY "follows_select_public" ON follows
  FOR SELECT USING (true);

CREATE POLICY "follows_insert_own" ON follows
  FOR INSERT WITH CHECK (auth.uid() = follower_id);

CREATE POLICY "follows_delete_own" ON follows
  FOR DELETE USING (auth.uid() = follower_id);

-- ==================
-- 6. notifications テーブル（プライベート）
-- ==================
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "notifications_select_own" ON notifications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "notifications_update_own" ON notifications
  FOR UPDATE USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- 通知の作成はサーバーサイド（トリガー/RPC）から行うため
-- INSERT ポリシーは service_role 経由を想定

-- ==================
-- 7. knot_types テーブル（公開参照データ）
-- ==================
ALTER TABLE knot_types ENABLE ROW LEVEL SECURITY;

CREATE POLICY "knot_types_select_public" ON knot_types
  FOR SELECT USING (true);

-- ==================
-- 8. Storage: post-media バケット
-- ==================
CREATE POLICY "post_media_select_public" ON storage.objects
  FOR SELECT USING (bucket_id = 'post-media');

CREATE POLICY "post_media_insert_own" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'post-media'
    AND auth.uid()::text = (string_to_array(name, '/'))[1]
  );

CREATE POLICY "post_media_delete_own" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'post-media'
    AND auth.uid()::text = (string_to_array(name, '/'))[1]
  );

-- ==================
-- 9. Storage: avatars バケット
-- ==================
CREATE POLICY "avatars_select_public" ON storage.objects
  FOR SELECT USING (bucket_id = 'avatars');

CREATE POLICY "avatars_insert_own" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'avatars'
    AND auth.uid()::text = (string_to_array(name, '/'))[1]
  );

CREATE POLICY "avatars_update_own" ON storage.objects
  FOR UPDATE USING (
    bucket_id = 'avatars'
    AND auth.uid()::text = (string_to_array(name, '/'))[1]
  );
