SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary_year
FROM job_postings_fact
JOIN skills_job_dim
    USING (job_id)
JOIN skills_dim
    USING (skill_id)
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_location = 'Hong Kong'
GROUP BY
    skills
ORDER BY 
    avg_salary_year DESC
LIMIT 20