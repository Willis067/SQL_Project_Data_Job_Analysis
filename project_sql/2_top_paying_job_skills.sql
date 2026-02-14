WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim
        USING (company_id)
    WHERE
        job_title_short = 'Data Analyst' 
        AND job_location = 'Hong Kong' 
        AND salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
)
SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs 
JOIN skills_job_dim
    USING (job_id)
JOIN skills_dim
    USING (skill_id)
ORDER BY
    salary_year_avg DESC
