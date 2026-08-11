/*
# Seed starter HR workspace data

1. Purpose
- Add a small, reusable starter team so the new HR workspace is useful on first open.
- Inserts are idempotent and do not overwrite user-managed records.

2. New sample records
- Four departments: Product, Engineering, People, and Marketing.
- Five employees distributed across the departments.
- Attendance for the sample team on the current date.
- One pending and one approved time-off request.

3. Safety
- Uses conflict-safe inserts keyed by unique department names and employee emails.
- Does not delete or modify existing records.
*/

INSERT INTO departments (name, description, color) VALUES
  ('Product', 'Builds the experiences our customers love.', '#2f6f70'),
  ('Engineering', 'Turns ambitious ideas into dependable products.', '#5f8ca3'),
  ('People', 'Supports a healthy, high-performing team.', '#b67842'),
  ('Marketing', 'Shares our story with the world.', '#8a7898')
ON CONFLICT (name) DO NOTHING;

INSERT INTO employees (first_name, last_name, email, job_title, department_id, employment_type, location, avatar_color)
SELECT 'Maya', 'Chen', 'maya.chen@acme.example', 'Product Designer', id, 'Full-time', 'Remote', '#d9e8e3' FROM departments WHERE name = 'Product'
ON CONFLICT (email) DO NOTHING;
INSERT INTO employees (first_name, last_name, email, job_title, department_id, employment_type, location, avatar_color)
SELECT 'Noah', 'Williams', 'noah.williams@acme.example', 'Senior Engineer', id, 'Full-time', 'New York', '#dfe8f0' FROM departments WHERE name = 'Engineering'
ON CONFLICT (email) DO NOTHING;
INSERT INTO employees (first_name, last_name, email, job_title, department_id, employment_type, location, avatar_color)
SELECT 'Ava', 'Patel', 'ava.patel@acme.example', 'People Partner', id, 'Full-time', 'Remote', '#f0dbc0' FROM departments WHERE name = 'People'
ON CONFLICT (email) DO NOTHING;
INSERT INTO employees (first_name, last_name, email, job_title, department_id, employment_type, location, avatar_color)
SELECT 'Liam', 'Garcia', 'liam.garcia@acme.example', 'Marketing Lead', id, 'Full-time', 'London', '#f0dedc' FROM departments WHERE name = 'Marketing'
ON CONFLICT (email) DO NOTHING;
INSERT INTO employees (first_name, last_name, email, job_title, department_id, employment_type, location, avatar_color)
SELECT 'Sofia', 'Morgan', 'sofia.morgan@acme.example', 'Frontend Engineer', id, 'Full-time', 'Remote', '#e3e0f0' FROM departments WHERE name = 'Engineering'
ON CONFLICT (email) DO NOTHING;

INSERT INTO attendance (employee_id, work_date, check_in, status)
SELECT id, current_date, now() - interval '2 hours', 'Present' FROM employees WHERE email IN ('maya.chen@acme.example', 'noah.williams@acme.example', 'ava.patel@acme.example', 'liam.garcia@acme.example', 'sofia.morgan@acme.example')
ON CONFLICT (employee_id, work_date) DO NOTHING;

INSERT INTO leave_requests (employee_id, leave_type, start_date, end_date, reason, status)
SELECT id, 'Annual leave', current_date + 5, current_date + 7, 'Family trip', 'Pending' FROM employees WHERE email = 'maya.chen@acme.example'
AND NOT EXISTS (SELECT 1 FROM leave_requests WHERE reason = 'Family trip');
INSERT INTO leave_requests (employee_id, leave_type, start_date, end_date, reason, status)
SELECT id, 'Personal day', current_date - 2, current_date - 1, 'Personal appointment', 'Approved' FROM employees WHERE email = 'liam.garcia@acme.example'
AND NOT EXISTS (SELECT 1 FROM leave_requests WHERE reason = 'Personal appointment');
