/*
# Create HR workspace tables

1. New Tables
- `departments`: shared company departments with names, descriptions, and headcount targets.
- `employees`: employee directory records including contact details, role, department, status, start date, and compensation.
- `attendance`: daily attendance records with employee, date, check-in, check-out, and status.
- `leave_requests`: shared leave requests with employee, dates, type, reason, and approval status.

2. Security
- Row Level Security is enabled on every table.
- This app intentionally has no sign-in screen, so anon and authenticated roles can manage the shared HR workspace.
- Four separate CRUD policies are defined per table.

3. Notes
- Foreign keys keep employee, department, attendance, and leave data connected.
- Indexes support common dashboard filters by department, employee, date, and status.
*/

CREATE TABLE IF NOT EXISTS departments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  description text NOT NULL DEFAULT '',
  color text NOT NULL DEFAULT '#2f6f70',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS employees (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name text NOT NULL,
  last_name text NOT NULL,
  email text NOT NULL UNIQUE,
  phone text NOT NULL DEFAULT '',
  job_title text NOT NULL,
  department_id uuid REFERENCES departments(id) ON DELETE SET NULL,
  employment_type text NOT NULL DEFAULT 'Full-time',
  status text NOT NULL DEFAULT 'Active',
  start_date date NOT NULL DEFAULT current_date,
  location text NOT NULL DEFAULT 'Remote',
  salary numeric(12,2) NOT NULL DEFAULT 0,
  avatar_color text NOT NULL DEFAULT '#d9e8e3',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS attendance (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id uuid NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  work_date date NOT NULL DEFAULT current_date,
  check_in timestamptz,
  check_out timestamptz,
  status text NOT NULL DEFAULT 'Present',
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(employee_id, work_date)
);

CREATE TABLE IF NOT EXISTS leave_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  employee_id uuid NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
  leave_type text NOT NULL DEFAULT 'Annual leave',
  start_date date NOT NULL,
  end_date date NOT NULL,
  reason text NOT NULL DEFAULT '',
  status text NOT NULL DEFAULT 'Pending',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS employees_department_id_idx ON employees(department_id);
CREATE INDEX IF NOT EXISTS employees_status_idx ON employees(status);
CREATE INDEX IF NOT EXISTS attendance_work_date_idx ON attendance(work_date);
CREATE INDEX IF NOT EXISTS attendance_employee_id_idx ON attendance(employee_id);
CREATE INDEX IF NOT EXISTS leave_requests_status_idx ON leave_requests(status);

ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE leave_requests ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "shared_select_departments" ON departments;
CREATE POLICY "shared_select_departments" ON departments FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "shared_insert_departments" ON departments;
CREATE POLICY "shared_insert_departments" ON departments FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "shared_update_departments" ON departments;
CREATE POLICY "shared_update_departments" ON departments FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "shared_delete_departments" ON departments;
CREATE POLICY "shared_delete_departments" ON departments FOR DELETE TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "shared_select_employees" ON employees;
CREATE POLICY "shared_select_employees" ON employees FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "shared_insert_employees" ON employees;
CREATE POLICY "shared_insert_employees" ON employees FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "shared_update_employees" ON employees;
CREATE POLICY "shared_update_employees" ON employees FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "shared_delete_employees" ON employees;
CREATE POLICY "shared_delete_employees" ON employees FOR DELETE TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "shared_select_attendance" ON attendance;
CREATE POLICY "shared_select_attendance" ON attendance FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "shared_insert_attendance" ON attendance;
CREATE POLICY "shared_insert_attendance" ON attendance FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "shared_update_attendance" ON attendance;
CREATE POLICY "shared_update_attendance" ON attendance FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "shared_delete_attendance" ON attendance;
CREATE POLICY "shared_delete_attendance" ON attendance FOR DELETE TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "shared_select_leave_requests" ON leave_requests;
CREATE POLICY "shared_select_leave_requests" ON leave_requests FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "shared_insert_leave_requests" ON leave_requests;
CREATE POLICY "shared_insert_leave_requests" ON leave_requests FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "shared_update_leave_requests" ON leave_requests;
CREATE POLICY "shared_update_leave_requests" ON leave_requests FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "shared_delete_leave_requests" ON leave_requests;
CREATE POLICY "shared_delete_leave_requests" ON leave_requests FOR DELETE TO anon, authenticated USING (true);
