
CREATE VIEW course_statistics AS
SELECT 
    l.c_id,
    l.semester,
    l.course_year,
    c.l_id,
    p.first_name || ' ' || p.last_name AS lecturer_full_name, 
    ct.credits, 
    d.dep_name, 
    ROUND(AVG(l.grade), 2) AS avg_grade, 
    COUNT(l.grade) AS count_grades, 
    MAX(l.grade) AS max_grade, 
    MIN(l.grade) AS min_grade 
FROM learned l
JOIN course c
    ON l.c_id = c.c_id AND l.semester = c.semester AND l.course_year = c.course_year
JOIN lecturer lec
    ON c.l_id = lec.l_id
JOIN person p
    ON lec.l_id = p.person_id
JOIN course_type ct
    ON c.c_id = ct.c_id 
JOIN department d
    ON ct.dep_name = d.dep_name 
GROUP BY 
    l.c_id, 
    l.semester, 
    l.course_year, 
    c.l_id, 
    p.first_name, 
    p.last_name, 
    ct.credits, 
    d.dep_name;

COMMIT;


SELECT dep_name, ROUND(AVG(avg_grade), 2) AS overall_avg_grade
FROM course_statistics
GROUP BY dep_name
ORDER BY overall_avg_grade DESC;


SELECT 
    c.c_id,
    c.dep_name,
    c.credits,
    max_avg.course_year || '/' || 
    CASE max_avg.semester
        WHEN 1 THEN 'A'
        WHEN 2 THEN 'B'
        ELSE TO_CHAR(max_avg.semester)
    END AS year_semester_max_avg, 
    max_avg.lecturer_full_name AS lecturer_with_max_avg, 
    c.max_avg_grade AS highest_avg_grade,
    min_avg.course_year || '/' || 
    CASE min_avg.semester
        WHEN 1 THEN 'A'
        WHEN 2 THEN 'B'
        ELSE TO_CHAR(min_avg.semester)
    END AS year_semester_min_avg, 
    min_avg.lecturer_full_name AS lecturer_with_min_avg,
    c.min_avg_grade AS lowest_avg_grade
FROM (
    SELECT 
        c_id,
        dep_name,
        credits,
        MAX(avg_grade) AS max_avg_grade, 
        MIN(avg_grade) AS min_avg_grade 
    FROM course_statistics
    GROUP BY c_id, dep_name, credits
) c
LEFT JOIN course_statistics max_avg
    ON c.c_id = max_avg.c_id 
    AND c.max_avg_grade = max_avg.avg_grade
LEFT JOIN course_statistics min_avg
    ON c.c_id = min_avg.c_id 
    AND c.min_avg_grade = min_avg.avg_grade
ORDER BY c.c_id, year_semester_max_avg;

