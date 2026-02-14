SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS skill_demand_count
FROM job_postings_fact
JOIN skills_job_dim
    USING (job_id)
JOIN skills_dim
    USING (skill_id)
WHERE
    job_title_short = 'Data Analyst'
    AND job_location = 'Hong Kong'
GROUP BY
    skills
ORDER BY 
    skill_demand_count DESC
LIMIT 5