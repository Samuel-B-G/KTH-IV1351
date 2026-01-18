CREATE TABLE max_allocated_courses (
	max_allocated_courses_id SERIAL PRIMARY KEY,
	max_allocated_courses_per_period INT NOT NULL
);

CREATE TABLE address (
	address_id SERIAL PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    street VARCHAR(100) NOT NULL,
    zip VARCHAR(100) NOT NULL
);

CREATE TABLE person (
    person_id SERIAL PRIMARY KEY,
    personal_number VARCHAR(13) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
	address_id INT,
    FOREIGN KEY (address_id) REFERENCES address(address_id)
		ON DELETE SET NULL
);

CREATE TABLE phone (
	phone_id SERIAL PRIMARY KEY,
    phone_number VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE person_phone (
	person_id INT NOT NULL,
    phone_id INT NOT NULL,
    FOREIGN KEY (person_id) REFERENCES person(person_id)
		ON DELETE CASCADE,
    FOREIGN KEY (phone_id) REFERENCES phone(phone_id)
		ON DELETE CASCADE,
    PRIMARY KEY (person_id, phone_id)
);

CREATE TABLE email (
	email_id SERIAL PRIMARY KEY,
    email_address VARCHAR(254) NOT NULL UNIQUE
);

CREATE TABLE person_email (
	person_id INT NOT NULL,
    email_id INT NOT NULL,
    FOREIGN KEY (person_id) REFERENCES person(person_id)
		ON DELETE CASCADE,
    FOREIGN KEY (email_id) REFERENCES email(email_id)
		ON DELETE CASCADE,
    PRIMARY KEY (person_id, email_id)
);

CREATE TABLE job_title (
    job_title_id SERIAL PRIMARY KEY,
    job_title VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE employee (
    employment_id SERIAL PRIMARY KEY,
    supervisor_id INT,
    person_id INT NOT NULL UNIQUE,
    job_title_id INT NOT NULL,
	department_id INT,
    FOREIGN KEY (supervisor_id) REFERENCES employee(employment_id)
		ON DELETE SET NULL,
    FOREIGN KEY (person_id) REFERENCES person(person_id),
    FOREIGN KEY (job_title_id) REFERENCES job_title(job_title_id)
);

CREATE TABLE department (
	department_id SERIAL PRIMARY KEY,
	department_name VARCHAR(100) NOT NULL UNIQUE,
	manager_id INT,
	FOREIGN KEY (manager_id) REFERENCES employee(employment_id)
		ON DELETE SET NULL
);

ALTER TABLE employee
	ADD FOREIGN KEY (department_id) REFERENCES department(department_id)
		ON DELETE SET NULL;

CREATE TABLE skill (
	skill_id SERIAL PRIMARY KEY,
	skill_name VARCHAR(50) NOT NULL UNIQUE,
	skill_description VARCHAR(300) NOT NULL
);

CREATE TABLE employee_skill (
	employment_id INT NOT NULL,
	skill_id INT NOT NULL,
	FOREIGN KEY (employment_id) REFERENCES employee(employment_id)
		ON DELETE CASCADE,
	FOREIGN KEY (skill_id) REFERENCES skill(skill_id)
		ON DELETE CASCADE,
	PRIMARY KEY (employment_id, skill_id)
);


CREATE TABLE course_layout (
	course_layout_id SERIAL PRIMARY KEY,
	course_code VARCHAR(20) NOT NULL UNIQUE,
	course_name VARCHAR(50) NOT NULL
);

CREATE TABLE course_version (
	course_version_id SERIAL PRIMARY KEY,
	hp DOUBLE PRECISION NOT NULL,
	min_students INT NOT NULL,
	max_students INT NOT NULL,
	course_layout_id INT NOT NULL,
	FOREIGN KEY (course_layout_id) REFERENCES course_layout(course_layout_id)
);

CREATE TABLE study_period (
	study_period_id SERIAL PRIMARY KEY,
	period_name VARCHAR(2) NOT NULL
);

CREATE TABLE course_instance (
	course_instance_id SERIAL PRIMARY KEY,
	num_students INT NOT NULL,
	study_year VARCHAR(4) NOT NULL,
	study_period_id INT NOT NULL,
	course_version_id INT NOT NULL,
	FOREIGN KEY (study_period_id) REFERENCES study_period(study_period_id),
	FOREIGN KEY (course_version_id) REFERENCES course_version(course_version_id)
);

CREATE TABLE teaching_activity (
	teaching_activity_id SERIAL PRIMARY KEY,
	activity_name VARCHAR(50) NOT NULL UNIQUE,
	factor DOUBLE PRECISION NOT NULL
);

CREATE TABLE activity_constants (
	teaching_activity_id INT NOT NULL,
	hp_factor DOUBLE PRECISION NOT NULL,
	student_factor DOUBLE PRECISION NOT NULL,
	constant_value INT NOT NULL,
	FOREIGN KEY (teaching_activity_id) REFERENCES teaching_activity(teaching_activity_id)
		ON DELETE CASCADE,
	PRIMARY KEY (teaching_activity_id)
);

CREATE TABLE planned_activity (
	planned_activity_id SERIAL PRIMARY KEY,
	course_instance_id INT NOT NULL,
	teaching_activity_id INT NOT NULL,
	planned_hours INT NOT NULL,
	FOREIGN KEY (course_instance_id) REFERENCES course_instance(course_instance_id)
		ON DELETE CASCADE,
	FOREIGN KEY (teaching_activity_id) REFERENCES teaching_activity(teaching_activity_id)
);

CREATE TABLE allocated_activity (
	employment_id INT NOT NULL,
	planned_activity_id INT NOT NULL,
	allocated_hours INT NOt NULL,
	FOREIGN KEY (employment_id) REFERENCES employee(employment_id)
		ON DELETE CASCADE,
	FOREIGN KEY (planned_activity_id) REFERENCES planned_activity(planned_activity_id)
		ON DELETE CASCADE,
	PRIMARY KEY (employment_id, planned_activity_id)
);

CREATE TABLE salary (
	salary_id SERIAL PRIMARY KEY,
	employment_id INT NOT NULL,
	salary DOUBLE PRECISION NOT NULL,
	start_date DATE NOT NULL,
	FOREIGN KEY (employment_id) REFERENCES employee(employment_id)
);

CREATE OR REPLACE FUNCTION is_at_max_allocated_courses()
	RETURNS TRIGGER AS $$
	DECLARE
		new_year VARCHAR;
		new_period INT;
		course_count INT;
BEGIN
	SELECT ci.study_year, ci.study_period_id, ci.course_instance_id
	INTO new_year, new_period
	FROM planned_activity pa
	
	JOIN course_instance ci
		ON ci.course_instance_id = pa.course_instance_id
	
	WHERE new.planned_activity_id = pa.planned_activity_id;


	SELECT COUNT(DISTINCT ci.course_instance_id)
	INTO course_count
	FROM course_instance ci

	JOIN planned_activity pa
		ON pa.course_instance_id = ci.course_instance_id
	JOIN allocated_activity aa
		ON aa.planned_activity_id = pa.planned_activity_id AND aa.employment_id = new.employment_id
	
	WHERE ci.study_year = new_year AND ci.study_period_id = new_period;
	
	IF (SELECT max_allocated_courses_per_period FROM max_allocated_courses LIMIT 1) = course_count
	THEN RAISE EXCEPTION 'This teacher (Employment ID: %) has already been assigned to the maximum amount of courses (%) this period.', new.employment_id, course_count;
	END IF;
	
	RETURN new;
END; $$
LANGUAGE PLPGSQL;

CREATE TRIGGER is_at_max_allocated_courses_trigger
	BEFORE INSERT ON allocated_activity
	FOR EACH ROW EXECUTE FUNCTION is_at_max_allocated_courses();