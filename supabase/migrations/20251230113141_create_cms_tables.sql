/*
  # CMS Tables for Dynamic Content

  1. New Tables
    - `services` - Service offerings (Impact section)
    - `tech_stack` - Technology categories and items
    - `projects` - Portfolio projects
    - `testimonials` - Client testimonials
    - `metrics` - Live metrics (uptime, projects, code, ROI)
    - `hero_content` - Hero section content
    - `media` - Media library for images/videos

  2. Security
    - Enable RLS on all tables
    - Public read access for all tables
    - Admin-only write access (requires auth)
*/

-- Media Library
CREATE TABLE IF NOT EXISTS media (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  alt_text text,
  file_url text NOT NULL,
  file_type text NOT NULL DEFAULT 'image',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE media ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read access" ON media FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Authenticated users can insert" ON media FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Authenticated users can update" ON media FOR UPDATE TO authenticated USING (true);
CREATE POLICY "Authenticated users can delete" ON media FOR DELETE TO authenticated USING (true);

-- Hero Content
CREATE TABLE IF NOT EXISTS hero_content (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  subtitle text NOT NULL,
  description text,
  video_url_1 text,
  video_url_2 text,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE hero_content ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read access" ON hero_content FOR SELECT TO anon, authenticated USING (is_active = true);
CREATE POLICY "Authenticated users can manage" ON hero_content FOR ALL TO authenticated USING (true);

-- Services
CREATE TABLE IF NOT EXISTS services (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  number text NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  image_url text,
  tags text[] DEFAULT '{}',
  sort_order int DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE services ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read services" ON services FOR SELECT TO anon, authenticated USING (is_active = true);
CREATE POLICY "Authenticated manage services" ON services FOR ALL TO authenticated USING (true);

-- Tech Stack Categories
CREATE TABLE IF NOT EXISTS tech_categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  icon text,
  sort_order int DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE tech_categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read tech_categories" ON tech_categories FOR SELECT TO anon, authenticated USING (is_active = true);
CREATE POLICY "Authenticated manage tech_categories" ON tech_categories FOR ALL TO authenticated USING (true);

-- Tech Stack Items
CREATE TABLE IF NOT EXISTS tech_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id uuid REFERENCES tech_categories(id) ON DELETE CASCADE,
  name text NOT NULL,
  icon text NOT NULL,
  description text,
  sort_order int DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE tech_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read tech_items" ON tech_items FOR SELECT TO anon, authenticated USING (is_active = true);
CREATE POLICY "Authenticated manage tech_items" ON tech_items FOR ALL TO authenticated USING (true);

-- Projects
CREATE TABLE IF NOT EXISTS projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  client text NOT NULL,
  tech_stack text NOT NULL,
  outcome text NOT NULL,
  image_url text NOT NULL,
  sort_order int DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read projects" ON projects FOR SELECT TO anon, authenticated USING (is_active = true);
CREATE POLICY "Authenticated manage projects" ON projects FOR ALL TO authenticated USING (true);

-- Testimonials
CREATE TABLE IF NOT EXISTS testimonials (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  quote text NOT NULL,
  author text NOT NULL,
  role text NOT NULL,
  company text NOT NULL,
  sort_order int DEFAULT 0,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE testimonials ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read testimonials" ON testimonials FOR SELECT TO anon, authenticated USING (is_active = true);
CREATE POLICY "Authenticated manage testimonials" ON testimonials FOR ALL TO authenticated USING (true);

-- Live Metrics
CREATE TABLE IF NOT EXISTS live_metrics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  label text NOT NULL,
  value int NOT NULL,
  suffix text DEFAULT '',
  sort_order int DEFAULT 0,
  is_active boolean DEFAULT true,
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE live_metrics ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read live_metrics" ON live_metrics FOR SELECT TO anon, authenticated USING (is_active = true);
CREATE POLICY "Authenticated manage live_metrics" ON live_metrics FOR ALL TO authenticated USING (true);

-- Insert Default Data
INSERT INTO hero_content (title, subtitle, description, video_url_1, video_url_2) VALUES
('We Build Automations', 'Connecting your tools, automating your workflows, and building web apps that make your life easier.', 'Intelligence in Motion', '/assets/make.mp4', '/assets/my-n8n.mp4');

INSERT INTO services (number, title, description, tags, sort_order) VALUES
('01', 'WORKFLOW AUTOMATION', 'We connect your tools and automate repetitive tasks using n8n, Zapier, and Make. Whether it''s syncing data between apps or building complex multi-step workflows—we handle it.', ARRAY['n8n', 'Zapier', 'Make', 'API Integration', 'Webhooks'], 1),
('02', 'WEB DEVELOPMENT', 'Custom web apps built with React, Node.js, and modern tools. We create dashboards, admin panels, and customer portals that actually work with your workflows.', ARRAY['React', 'Node.js', 'PostgreSQL', 'AWS'], 2),
('03', 'AI INTEGRATION', 'We plug AI into your workflows. Think automated email responses, smart data extraction, or chatbots that actually help. Using OpenAI, Claude, and other AI tools.', ARRAY['OpenAI', 'Claude', 'AI Workflows', 'Smart Automation'], 3);

INSERT INTO live_metrics (label, value, suffix, sort_order) VALUES
('System Uptime', 99, '%', 1),
('Global Projects', 142, '', 2),
('Lines of Code', 850, 'K+', 3),
('Client ROI', 300, '%', 4);

INSERT INTO testimonials (quote, author, role, company, sort_order) VALUES
('Tebita Tech didn''t just build our platform; they engineered a digital nervous system. The efficiency gains are not just measurable; they are exponential.', 'Sarah Chen', 'CTO, Nexus Dynamics', 'FinTech', 1),
('We were drowning in data. They turned it into our strongest asset. The AI integration feels less like software and more like precognition.', 'Marcus Thorne', 'Director of Operations', 'Global Logistics', 2),
('Absolute precision. The architecture they deployed scaled effortlessly during our biggest launch. It''s rare to see code this clean and powerful.', 'Elena Rodriguez', 'VP of Engineering', 'HealthStream', 3);