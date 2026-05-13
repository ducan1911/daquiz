// supabase-config.js
const SUPABASE_URL = 'https://hroclpmbsfehdduxhnzh.supabase.co'; 
const SUPABASE_ANON_KEY = 'sb_publishable_m6glIESoWGnZogPZnEyIEw_X7QVEy4-';

// Gán thẳng vào window để mọi file HTML đều thấy
window.supabase = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

console.log('Supabase đã được cấu hình toàn cục')