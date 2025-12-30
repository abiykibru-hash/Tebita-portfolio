import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export async function getHeroContent() {
  const { data, error } = await supabase
    .from('hero_content')
    .select('*')
    .eq('is_active', true)
    .single();

  if (error) throw error;
  return data;
}

export async function getServices() {
  const { data, error } = await supabase
    .from('services')
    .select('*')
    .eq('is_active', true)
    .order('sort_order', { ascending: true });

  if (error) throw error;
  return data;
}

export async function getTechStack() {
  const { data: categories, error: catError } = await supabase
    .from('tech_categories')
    .select('*')
    .eq('is_active', true)
    .order('sort_order', { ascending: true });

  if (catError) throw catError;

  const categoriesWithItems = await Promise.all(
    categories.map(async (category) => {
      const { data: items } = await supabase
        .from('tech_items')
        .select('*')
        .eq('category_id', category.id)
        .eq('is_active', true)
        .order('sort_order', { ascending: true });

      return { ...category, items: items || [] };
    })
  );

  return categoriesWithItems;
}

export async function getProjects() {
  const { data, error } = await supabase
    .from('projects')
    .select('*')
    .eq('is_active', true)
    .order('sort_order', { ascending: true });

  if (error) throw error;
  return data;
}

export async function getTestimonials() {
  const { data, error } = await supabase
    .from('testimonials')
    .select('*')
    .eq('is_active', true)
    .order('sort_order', { ascending: true });

  if (error) throw error;
  return data;
}

export async function getLiveMetrics() {
  const { data, error } = await supabase
    .from('live_metrics')
    .select('*')
    .eq('is_active', true)
    .order('sort_order', { ascending: true });

  if (error) throw error;
  return data;
}
