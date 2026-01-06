DROP VIEW IF EXISTS course_instance_allocated_hours;

CREATE OR REPLACE VIEW course_instance_allocated_hours AS (
	SELECT
		cl.course_code AS "Course Code",
		ci.course_instance_id AS "Course Instance ID",
		CONCAT(p.last_name, ', ', p.first_name) AS "Employee Name",
		jt.job_title AS "Designation",
		cv.hp AS "HP",
		ci.study_year AS "Study Year",
		ROUND(SUM(CASE WHEN ta.activity_name = 'Lecture'
			THEN pa.planned_hours * ta.factor ELSE 0 END)::NUMERIC, 2) AS "Lecture Hours",
		ROUND(SUM(CASE WHEN ta.activity_name = 'Lab'
			THEN pa.planned_hours * ta.factor ELSE 0 END)::NUMERIC, 2) AS "Lab Hours",
		ROUND(SUM(CASE WHEN ta.activity_name = 'Tutorial'
			THEN pa.planned_hours * ta.factor ELSE 0 END)::NUMERIC, 2) AS "Tutorial Hours",
		ROUND(SUM(CASE WHEN ta.activity_name = 'Seminar'
			THEN pa.planned_hours * ta.factor ELSE 0 END)::NUMERIC, 2) AS "Seminar Hours",
			
		ROUND(SUM(CASE WHEN ta.activity_name = 'Exam'
			THEN cv.hp * ac.hp_factor + ac.constant_value + ci.num_students * ac.student_factor ELSE 0 END)::NUMERIC, 2) AS "Exam Hours",
		ROUND(SUM(CASE WHEN ta.activity_name = 'Admin'
			THEN cv.hp * ac.hp_factor + ac.constant_value + ci.num_students * ac.student_factor ELSE 0 END)::NUMERIC, 2) AS "Admin Hours",
			
		ROUND(SUM(CASE WHEN ta.teaching_activity_id = ac.teaching_activity_id
			THEN cv.hp * ac.hp_factor + ac.constant_value + ci.num_students * ac.student_factor
			ELSE pa.planned_hours * ta.factor END)::NUMERIC, 2) AS "Total Hours"
			
	FROM course_instance ci
	
	JOIN course_version cv
		ON ci.course_version_id = cv.course_version_id
	JOIN course_layout cl
		ON cv.course_layout_id = cl.course_layout_id
	JOIN planned_activity pa
		ON ci.course_instance_id = pa.course_instance_id
	JOIN allocated_activity aa
		ON pa.planned_activity_id = aa.planned_activity_id
	JOIN employee e
		ON aa.employment_id = e.employment_id
	JOIN person p
		ON e.person_id = p.person_id
	JOIN job_title jt
		ON e.job_title_id = jt.job_title_id
	JOIN teaching_activity ta
		ON pa.teaching_activity_id = ta.teaching_activity_id
	LEFT JOIN activity_constants ac
		ON ta.teaching_activity_id = ac.teaching_activity_id
	WHERE ci.study_year = '2025' AND ci.course_instance_id = 2 -- Specified year and course instance
	
	GROUP BY 
		cl.course_code,
		e.employment_id,
		p.first_name,
		p.last_name,
		jt.job_title,
		ci.course_instance_id,
		ci.study_year,
		cv.hp
		
	ORDER BY p.last_name
);

-- Run the query below to use the view.
SELECT *

FROM course_instance_allocated_hours;
