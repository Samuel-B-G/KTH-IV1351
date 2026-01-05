SELECT
	cl.course_name AS "Course Name",
	cl.course_code AS "Course Code",
	ci.course_instance_id AS "Course Instance ID",
	cv.hp AS "HP",
	ci.study_year AS "Study Year",
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
	ROUND(SUM(pa.planned_hours * ta.factor)::NUMERIC, 2) AS "Total Hours"
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
WHERE ci.study_year = '2025'

GROUP BY 
	cl.course_name,
	cl.course_code,
	ci.course_instance_id,
	ci.study_year,
	sp.period_name,
	ci.num_students,
	cv.hp;