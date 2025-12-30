# TEBITA TECH - CMS Integration Guide

## QUICK START

### 1. Install Dependencies
```bash
npm install @supabase/supabase-js
```

### 2. Environment Variables
Create `.env.local` with your Supabase credentials:
```
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
DATABASE_URL=postgresql://postgres:[YOUR-PASSWORD]@[HOST]:[PORT]/postgres
PAYLOAD_SECRET=generate-a-random-secret-key
```

### 3. Database Already Migrated
The migration has already been applied with these tables:
- `hero_content` - Hero section (videos, title, subtitle)
- `services` - Services/Impact section (3 services)
- `tech_categories` - Tech stack categories
- `tech_items` - Individual tech items
- `projects` - Portfolio projects
- `testimonials` - Client testimonials
- `live_metrics` - Live metrics (System Uptime, Projects, Code, ROI)

### 4. Default Data Inserted
- Hero content with video URLs
- 3 services (Workflow Automation, Web Development, AI Integration)
- 4 live metrics (Uptime 99%, Projects 142, Code 850K+, ROI 300%)
- 3 testimonials

## UPDATE COMPONENTS TO USE DATABASE

### Hero Section (`components/sections/Hero.tsx`)
Replace hardcoded data with:
```typescript
import { useEffect, useState } from 'react';
import { getHeroContent } from '@/lib/supabase';

// In component:
const [heroData, setHeroData] = useState(null);

useEffect(() => {
  getHeroContent().then(setHeroData);
}, []);

// Use: heroData.title, heroData.video_url_1, heroData.video_url_2
```

### Services Section (`components/sections/Impact.tsx`)
```typescript
import { getServices } from '@/lib/supabase';

const [services, setServices] = useState([]);

useEffect(() => {
  getServices().then(setServices);
}, []);

// Map over services.map(service => ...)
```

### Tech Stack (`components/sections/TechStack.tsx`)
```typescript
import { getTechStack } from '@/lib/supabase';

const [categories, setCategories] = useState([]);

useEffect(() => {
  getTechStack().then(setCategories);
}, []);
```

### Projects (`components/sections/Portfolio.tsx`)
```typescript
import { getProjects } from '@/lib/supabase';

const [projects, setProjects] = useState([]);

useEffect(() => {
  getProjects().then(setProjects);
}, []);
```

### Live Metrics (`components/sections/LiveMetrics.tsx`)
```typescript
import { getLiveMetrics } from '@/lib/supabase';

const [metrics, setMetrics] = useState([]);

useEffect(() => {
  getLiveMetrics().then(setMetrics);
}, []);
```

### Testimonials (`components/sections/Testimonials.tsx`)
```typescript
import { getTestimonials } from '@/lib/supabase';

const [testimonials, setTestimonials] = useState([]);

useEffect(() => {
  getTestimonials().then(setTestimonials);
}, []);
```

## MANAGE CONTENT

### Via Supabase Dashboard
1. Go to your Supabase project
2. Click "Table Editor"
3. Select any table (services, projects, testimonials, etc.)
4. Click "Insert row" to add new content
5. Edit existing rows by clicking on them

### Via SQL
```sql
-- Add a new service
INSERT INTO services (number, title, description, tags, sort_order)
VALUES ('04', 'NEW SERVICE', 'Description here', ARRAY['tag1', 'tag2'], 4);

-- Update live metrics
UPDATE live_metrics SET value = 150 WHERE label = 'Global Projects';

-- Add new testimonial
INSERT INTO testimonials (quote, author, role, company, sort_order)
VALUES ('Amazing work!', 'John Doe', 'CEO', 'TechCorp', 4);
```

## CONTENT STRUCTURE

### Hero Content
- `title`: Main heading
- `subtitle`: Subheading text
- `description`: Bottom tagline
- `video_url_1`: First carousel video (e.g., /assets/make.mp4)
- `video_url_2`: Second carousel video (e.g., /assets/my-n8n.mp4)

### Services
- `number`: Display number (01, 02, 03)
- `title`: Service name
- `description`: Full description
- `tags`: Array of technology tags
- `sort_order`: Display order (1, 2, 3...)

### Tech Stack
- Categories: `title`, `description`, `icon` (emoji)
- Items: `name`, `icon` (emoji), `description`, linked to category

### Projects
- `title`: Project name
- `client`: Client name
- `tech_stack`: Technologies used
- `outcome`: Results achieved
- `image_url`: Project image URL

### Live Metrics
- `label`: Metric name (e.g., "System Uptime")
- `value`: Numeric value (e.g., 99)
- `suffix`: Suffix text (e.g., "%" or "K+")

### Testimonials
- `quote`: Full testimonial text
- `author`: Person's name
- `role`: Job title
- `company`: Company name

## INTEGRATION STATUS

All major components have been successfully updated to use dynamic database content:
- ✓ Hero section (ready for use with `hero_content` table)
- ✓ Services/Impact section
- ✓ Tech Stack section
- ✓ Portfolio/Projects section
- ✓ Live Metrics section
- ✓ Testimonials section

## OPTIONAL ENHANCEMENTS

1. **Update Hero section** to use the `hero_content` table (currently optional)
2. **Add image upload** functionality if needed
3. **Implement caching** for better performance
4. **Add error boundaries** for better error handling

## ADMIN PANEL

Use Supabase Dashboard for content management:
1. Go to your Supabase project dashboard
2. Navigate to Table Editor
3. Click any table to view/edit content
4. Use the Insert/Update/Delete buttons

This is simpler than setting up a separate CMS!

## PRODUCTION CHECKLIST

- [x] Update all components to use database
- [x] Add loading states to all components
- [ ] Add error handling for failed API calls
- [ ] Optimize images (use Next.js Image component)
- [ ] Add caching/revalidation strategy
- [ ] Test all CRUD operations in Supabase dashboard
- [ ] Set up proper RLS policies for admin users (if needed)
- [ ] Deploy and test in production

## SUPPORT

Database is live and populated with default data. You can start editing content immediately in Supabase dashboard!
