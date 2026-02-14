SELECT 
    skill_id,
    skills,
    COUNT(job_id) AS job_demand_count,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM job_postings_fact
JOIN skills_job_dim
    USING (job_id)
JOIN skills_dim
    USING (skill_id)
WHERE
    salary_year_avg IS NOT NULL
    AND job_location = 'Hong Kong'
    --AND job_title_short = 'Data Analyst'
GROUP BY 
    skill_id,
    skills
ORDER BY 
    job_demand_count DESC,
    avg_salary DESC
LIMIT 10;