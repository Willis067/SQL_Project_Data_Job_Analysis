WITH top_demanded_skills AS (
    SELECT 
        skill_id,
        skills,
        COUNT(job_id) AS skill_demand_count
    FROM job_postings_fact
    JOIN skills_job_dim
        USING (job_id)
    JOIN skills_dim
        USING (skill_id)
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
        --AND job_location = 'Hong Kong'
    GROUP BY
        skill_id, skills
), 

average_salary AS(
    SELECT 
        skill_id,
        ROUND(AVG(salary_year_avg), 2) AS avg_salary_year
    FROM job_postings_fact
    JOIN skills_job_dim
        USING (job_id)
    JOIN skills_dim
        USING (skill_id)
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
        --AND job_location = 'Hong Kong'
    GROUP BY
        skill_id
)

SELECT
    top_demanded_skills.skill_id,
    top_demanded_skills.skills,
    skill_demand_count,
    avg_salary_year
FROM top_demanded_skills
JOIN average_salary
    USING (skill_id)
ORDER BY 
    skill_demand_count DESC, 
    avg_salary_year DESC
LIMIT 20;

-- Alternative query

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
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
    --AND job_location = 'Hong Kong'
GROUP BY 
    skill_id,
    skills
ORDER BY 
    job_demand_count DESC,
    avg_salary DESC
LIMIT 20;