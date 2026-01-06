DROP VIEW IF EXISTS planned_hours_year;

CREATE OR REPLACE VIEW planned_hours_year AS (
	SELECT
		cl.course_code AS "Course Code",
		ci.course_instance_id AS "Course Instance ID",
		cv.hp AS "HP",
		sp.period_name AS "Period",
		ci.num_students AS "# Students",
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
	
	JOIN study_period sp
		ON ci.study_period_id = sp.study_period_id
	JOIN course_version cv
		ON ci.course_version_id = cv.course_version_id
	JOIN course_layout cl
		ON cv.course_layout_id = cl.course_layout_id
	JOIN planned_activity pa
		ON ci.course_instance_id = pa.course_instance_id
	JOIN teaching_activity ta
		ON pa.teaching_activity_id = ta.teaching_activity_id
	LEFT JOIN activity_constants ac
		ON ta.teaching_activity_id = ac.teaching_activity_id
	WHERE ci.study_year = '2025' -- Specified year
	
	GROUP BY 
		cl.course_code,
		ci.course_instance_id,
		sp.period_name,
		ci.num_students,
		cv.hp

	ORDER BY ci.course_instance_id
);

-- Run the query below to use the view.
SELECT *

FROM planned_hours_year;
