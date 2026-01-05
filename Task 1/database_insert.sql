INSERT INTO max_allocated_courses (max_allocated_courses_per_period) VALUES
(4);

INSERT INTO study_period (period_name) VALUES
('P1'),('P2'),('P3'),('P4');

INSERT INTO address (city, street, zip) VALUES
('Värnamo', '937-2211 Eu St.', '15121'),
('Borlänge', '8742 Aliquam Road', '54121'),
('Boo', '9423 Pede Rd.', '66574'),
('Värnamo', '552-6385 Nec, St.', '81575'),
('Mora', '7905 Purus, Ave', '42852');

INSERT INTO person (personal_number, first_name, last_name, address_id) VALUES
('19760302-1351', 'Talon', 'Spence', 1),
('19970726-7192', 'Emery', 'Golden', 2),
('19570427-2116', 'Sylvester', 'Berger', 3),
('19960717-8445', 'Hu', 'Allen', 4),
('19460121-1472', 'TaShya', 'Blankenship', 5);

INSERT INTO phone (phone_number) VALUES
('+46 86-925 8483'),
('+46 88-844 6126'),
('+46 97-958 5024'),
('+46 26-612 6582');

INSERT INTO person_phone (person_id, phone_id) VALUES
(1, 1),
(2, 2),
(4, 3),
(5, 4);

INSERT INTO email (email_address) VALUES
('talonspence@notkth.se'),
('emeryg@notkth.se'),
('sylber@notkth.se'),
('huall@notkth.se'),
('tashyabl@notkth.se');

INSERT INTO person_email (person_id, email_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO job_title (job_title) VALUES
('Professor'),
('Associate Professor'),
('Lecturer'),
('PhD Student'),
('Teaching Assistant');

INSERT INTO department (department_name) VALUES
('Civil and Architectural Engineering'),
('Computer Science'),
('Electrical Engineering'),
('Chemical Engineering'),
('Chemistry');

INSERT INTO employee (person_id, department_id, job_title_id) VALUES
(1, 1, 3),
(2, 2, 1),
(3, 2, 3),
(4, 2, 5),
(5, 4, 4);

UPDATE employee
SET supervisor_id = 1
WHERE employment_id = 1;
UPDATE employee
SET supervisor_id = 2
WHERE employment_id = 2 OR employment_id = 3 OR employment_id = 4;
UPDATE employee
SET supervisor_id = 5
WHERE employment_id = 5;

UPDATE department
SET manager_id = 1
WHERE department_id = 1;
UPDATE department
SET manager_id = 2
WHERE department_id = 2;

INSERT INTO skill (skill_name, skill_description) VALUES
('Database Design','Database design is the organization of data according to a database model.'),
('Discrete Mathematics','Discrete mathematics is the study of mathematical structures that can be considered "discrete" (in a way analogous to discrete variables, having a one-to-one correspondence (bijection) with natural numbers), rather than "continuous" (analogously to continuous functions).'),
('Mathematical Statistics','Mathematical statistics is the application of probability theory and other mathematical concepts to statistics, as opposed to techniques for collecting statistical data.'),
('Parallel Programming','Parallel programming is a type of programming in which many calculations or processes are carried out simultaneously.'),
('Concurrent Programming','Concurrent programming is a form of programming in which several computations are executed concurrently—during overlapping time periods—instead of sequentially—with one completing before the next starts.'),
('Hardware Security','Hardware security is a discipline originated from the cryptographic engineering and involves hardware design, access control, secure multi-party computation, secure key storage, ensuring code authenticity, measures to ensure that the supply chain that built the product is secure among other things.'),
('Machine Learning','Machine learning is a field of study in artificial intelligence concerned with the development and study of statistical algorithms that can learn from data and generalise to unseen data, and thus perform tasks without explicit instructions.');

INSERT INTO employee_skill (employment_id, skill_id) VALUES
(1, 2),
(1, 3),
(1, 6),
(2, 1),
(2, 6),
(3, 1),
(3, 7),
(4, 3),
(4, 4),
(4, 5),
(5, 4);

INSERT INTO salary (employment_id, salary, start_date) VALUES
(1, 100.1, '2020-01-01'),
(1, 153.52, '2022-04-27'),
(2, 123.62, '2019-06-13'),
(2, 165.84, '2022-07-11'),
(2, 211.26, '2025-02-26'),
(3, 231.42, '2024-11-16'),
(4, 174.38, '2025-04-23'),
(5, 211.99, '2022-07-30');

INSERT INTO course_layout (course_code, course_name) VALUES
('IV1351','Data Storage Paradigms'),
('IX1500','Discrete Mathematics'),
('ID1217','Concurrent Programming'),
('IL1333','Hardware Security');

INSERT INTO course_version (hp, min_students, max_students, course_layout_id) VALUES
(7.5, 40, 90, 1),
(15, 50, 90, 1),
(7.5, 30, 75, 2),
(6, 40, 80, 3),
(7.5, 25, 55, 4);

INSERT INTO course_instance (num_students, study_year, study_period_id, course_version_id) VALUES
(55, '2024', 2, 1),
(47, '2025', 2, 1),
(62, '2024', 3, 2),
(68, '2023', 1, 3),
(68, '2025', 2, 3),
(44, '2024', 4, 4),
(54, '2025', 3, 5);

INSERT INTO teaching_activity (activity_name, factor) VALUES
('Lecture', 3.6),
('Lab', 2.4),
('Tutorial', 2.4),
('Seminar', 1.8);

INSERT INTO planned_activity (course_instance_id, teaching_activity_id, planned_hours) VALUES
(1, 1, 4),
(1, 1, 2),
(1, 2, 5),
(2, 1, 2),
(2, 1, 3),
(2, 2, 4),
(2, 3, 2),
(2, 4, 4),
(3, 1, 4),
(4, 2, 4),
(4, 3, 3),
(5, 2, 3),
(6, 3, 2),
(6, 2, 3),
(7, 2, 4),
(7, 3, 2);

INSERT INTO allocated_activity (employment_id, planned_activity_id) VALUES
(1, 1),
(2, 2),
(1, 3),
(5, 3),
(4, 4),
(1, 5),
(3, 6),
(5, 6),
(4, 7),
(2, 8),
(3, 9),
(2, 9),
(4, 10),
(1, 11),
(2, 11),
(1, 12),
(4, 12),
(3, 13),
(3, 14),
(4, 15),
(2, 15),
(2, 16);