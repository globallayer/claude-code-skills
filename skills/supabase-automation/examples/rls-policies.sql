-- Example: Row Level Security Policies for Supabase
-- ================================================

-- Enable RLS on a table
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;

-- Policy 1: Anyone can read published posts
CREATE POLICY "Public posts are viewable by everyone"
ON posts FOR SELECT
USING (published = true);

-- Policy 2: Users can only insert their own posts
CREATE POLICY "Users can insert their own posts"
ON posts FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Policy 3: Users can update their own posts
CREATE POLICY "Users can update their own posts"
ON posts FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Policy 4: Users can delete their own posts
CREATE POLICY "Users can delete their own posts"
ON posts FOR DELETE
USING (auth.uid() = user_id);

-- Policy 5: Admins can do anything
CREATE POLICY "Admins have full access"
ON posts FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- Common pattern: User profiles
CREATE TABLE profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  username TEXT UNIQUE,
  avatar_url TEXT,
  role TEXT DEFAULT 'user'
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Users can view all profiles
CREATE POLICY "Profiles are viewable by everyone"
ON profiles FOR SELECT
USING (true);

-- Users can update own profile
CREATE POLICY "Users can update own profile"
ON profiles FOR UPDATE
USING (auth.uid() = id);

-- Auto-create profile on signup (trigger)
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, username)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'username');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Storage policies (for storage.objects)
CREATE POLICY "Users can upload their own avatar"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'avatars' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Avatar images are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars');
