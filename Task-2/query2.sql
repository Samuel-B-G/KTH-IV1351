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
	ROUND(SUM(pa.planned_hours * ta.factor)::NUMERIC, 2) AS "Total Hours"
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
WHERE ci.study_year = '2025' AND ci.course_instance_id = 2

GROUP BY 
	cl.course_code,
	p.first_name,
	p.last_name,
	jt.job_title,
	ci.course_instance_id,
	ci.study_year,
	cv.hp

ORDER BY p.last_name;