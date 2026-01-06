DROP VIEW IF EXISTS employees_allocated_course_over_specified_amount_period;

CREATE OR REPLACE VIEW employees_allocated_course_over_specified_amount_period AS (
	SELECT
		e.employment_id AS "Employment ID",
		CONCAT(p.last_name, ', ', p.first_name) AS "Employee Name",
		sp.period_name AS "Period",
		COUNT(DISTINCT ci.course_instance_id) AS "# Courses"
	FROM course_instance ci
	
	JOIN study_period sp
		ON ci.study_period_id = sp.study_period_id
	JOIN planned_activity pa
		ON ci.course_instance_id = pa.course_instance_id
	JOIN allocated_activity aa
		ON pa.planned_activity_id = aa.planned_activity_id
	JOIN employee e
		ON aa.employment_id = e.employment_id
	JOIN person p
		ON e.person_id = p.person_id
	WHERE ci.study_year = '2025' AND ci.study_period_id = 2 -- Specified year and period
	
	GROUP BY
		p.first_name,
		p.last_name,
		e.employment_id,
		ci.study_year,
		sp.period_name
	
	HAVING COUNT(DISTINCT ci.course_instance_id) > 1 -- Specified allocated course amount

	ORDER BY e.employment_id
);

-- Run the query below to use the view.
SELECT *

FROM employees_allocated_course_over_specified_amount_period;
