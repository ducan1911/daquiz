-- ============================================
-- SETUP DATABASE CHO QUIZ APP
-- ============================================

-- 1. Mở rộng UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Bảng teachers (mở rộng auth.users)
CREATE TABLE teachers (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Bảng classes
CREATE TABLE classes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  teacher_id UUID NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Bảng students
CREATE TABLE students (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  class_id UUID NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  student_code TEXT DEFAULT '',
  token TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Bảng questions
CREATE TABLE questions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  teacher_id UUID NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('single', 'multiple', 'truefalse')),
  category TEXT DEFAULT '',
  content TEXT,
  options JSONB DEFAULT '[]'::jsonb,
  correct_answers JSONB DEFAULT '[]'::jsonb,
  points NUMERIC DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Bảng tests
CREATE TABLE tests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  teacher_id UUID NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  duration INTEGER DEFAULT 15,
  shuffle_questions BOOLEAN DEFAULT true,
  shuffle_options BOOLEAN DEFAULT true,
  max_attempts INTEGER DEFAULT 1,
  show_answers BOOLEAN DEFAULT true,
  start_time TIMESTAMPTZ,
  end_time TIMESTAMPTZ,
  questions JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Bảng test_assignments
CREATE TABLE test_assignments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  test_id UUID NOT NULL REFERENCES tests(id) ON DELETE CASCADE,
  class_id UUID NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
  assigned_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. Bảng submissions
CREATE TABLE submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  test_id UUID NOT NULL REFERENCES tests(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  class_id UUID NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
  attempt_number INTEGER DEFAULT 1,
  status TEXT DEFAULT 'in-progress' CHECK (status IN ('in-progress', 'submitted', 'timed-out')),
  started_at TIMESTAMPTZ,
  submitted_at TIMESTAMPTZ,
  answers JSONB DEFAULT '[]'::jsonb,
  score NUMERIC,
  total_points NUMERIC,
  auto_saved BOOLEAN DEFAULT false,
  question_order JSONB DEFAULT '[]'::jsonb,
  option_mappings JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================
ALTER TABLE teachers ENABLE ROW LEVEL SECURITY;
ALTER TABLE classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE tests ENABLE ROW LEVEL SECURITY;
ALTER TABLE test_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;

-- 9. Policies cho teachers
CREATE POLICY "teachers_select_own" ON teachers
  FOR SELECT TO authenticated USING (id = auth.uid());
CREATE POLICY "teachers_insert_own" ON teachers
  FOR INSERT TO authenticated WITH CHECK (id = auth.uid());

-- 10. Policies cho classes (giáo viên toàn quyền với lớp của mình)
CREATE POLICY "classes_all_teacher" ON classes
  FOR ALL TO authenticated USING (teacher_id = auth.uid());

-- 11. Policies cho students
-- Giáo viên quản lý học sinh trong lớp của mình
CREATE POLICY "students_all_teacher" ON students
  FOR ALL TO authenticated
  USING (class_id IN (SELECT id FROM classes WHERE teacher_id = auth.uid()));

-- Học sinh (anon) đọc thông tin của chính mình qua token + đọc danh sách
CREATE POLICY "students_select_anon" ON students
  FOR SELECT TO anon USING (true);

-- 12. Policies cho questions
CREATE POLICY "questions_all_teacher" ON questions
  FOR ALL TO authenticated USING (teacher_id = auth.uid());
CREATE POLICY "questions_select_anon" ON questions
  FOR SELECT TO anon USING (true);

-- 13. Policies cho tests
CREATE POLICY "tests_all_teacher" ON tests
  FOR ALL TO authenticated USING (teacher_id = auth.uid());
CREATE POLICY "tests_select_anon" ON tests
  FOR SELECT TO anon USING (true);

-- 14. Policies cho test_assignments
CREATE POLICY "assign_all_teacher" ON test_assignments
  FOR ALL TO authenticated
  USING (test_id IN (SELECT id FROM tests WHERE teacher_id = auth.uid()));
CREATE POLICY "assign_select_anon" ON test_assignments
  FOR SELECT TO anon USING (true);

-- 15. Policies cho submissions
-- Giáo viên xem bài nộp của bài kiểm tra mình tạo
CREATE POLICY "sub_select_teacher" ON submissions
  FOR SELECT TO authenticated
  USING (test_id IN (SELECT id FROM tests WHERE teacher_id = auth.uid()));

-- Học sinh (anon) tạo, đọc và cập nhật bài nộp
CREATE POLICY "sub_insert_anon" ON submissions FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "sub_update_anon" ON submissions FOR UPDATE TO anon USING (true);
CREATE POLICY "sub_select_anon" ON submissions FOR SELECT TO anon USING (true);

-- ============================================
-- INDEXES cho hiệu năng
-- ============================================
CREATE INDEX idx_classes_teacher ON classes(teacher_id);
CREATE INDEX idx_students_class ON students(class_id);
CREATE INDEX idx_students_token ON students(token);
CREATE INDEX idx_questions_teacher ON questions(teacher_id);
CREATE INDEX idx_tests_teacher ON tests(teacher_id);
CREATE INDEX idx_assign_test ON test_assignments(test_id);
CREATE INDEX idx_assign_class ON test_assignments(class_id);
CREATE INDEX idx_sub_test ON submissions(test_id);
CREATE INDEX idx_sub_student ON submissions(student_id);
CREATE INDEX idx_sub_class ON submissions(class_id);

-- Thêm cột test_code vào bảng tests
ALTER TABLE tests ADD COLUMN IF NOT EXISTS test_code TEXT UNIQUE;

-- Tạo index cho test_code
CREATE INDEX IF NOT EXISTS idx_tests_code ON tests(test_code);

-- Cập nhật bảng submissions: thêm cột student_name (học sinh tự nhập tên)
ALTER TABLE submissions ADD COLUMN IF NOT EXISTS student_name TEXT;

-- Cho phép đọc tests theo test_code
CREATE POLICY IF NOT EXISTS "tests_select_by_code" ON tests FOR SELECT TO anon USING (true);

-- Cho phép submissions không cần student_id
ALTER TABLE submissions ALTER COLUMN student_id DROP NOT NULL;
ALTER TABLE submissions ALTER COLUMN class_id DROP NOT NULL;
