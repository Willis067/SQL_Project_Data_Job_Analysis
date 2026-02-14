# 📊 Data Analyst Job Market Analysis (Hong Kong)
This project dives into the job market to uncover the highest-paying roles, most requested skills, and the "sweet spot" where high demand meets high compensation in Hong Kong.

🔍 Explore the code: [project_sql folder](/project_sql/)

## 🏗️ The Methodology
I focused on answering five core questions to guide career strategy in the HK market:
1. What are the **highest-paying** Data Analyst jobs?
2. Which **skills** do these top-paying roles require?
3. What are the **most in-demand** skills for analysts?
4. Which skills are linked to the **highest average salaries**?
5. What are the **optimal skills** to learn (balancing demand and pay)?

### 🛠️ Tools Used
* **SQL:** The backbone of the analysis.
* **PostgreSQL:** Database management system used for querying.



## 📈 Analysis & Insights

### 1. Top Paying Data Analyst Jobs
I filtered for roles explicitly titled "Data Analyst" in Hong Kong with non-null salary data to find the current market leaders.
```SQL
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
LIMIT 10;
```
- **Salary Range:** Annual salaries in this sample range from **$53,014** to **$111,175**, with an average of **$77,548**.

- **Top Sectors:** High-paying roles are dominated by **Fintech (Crypto), Insurance, and Financial Analytics**.


![Top paying roles](assests\1_top_paying_roles.png)

### 2. Skills for Top Paying Jobs
This section explores the specific skills associated with the top-paying Data Analyst positions in Hong Kong.
```SQL
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
    LIMIT 10
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
```
**Most Frequent Skills in High-Paying Roles:**
1. **SQL (4 mentions)** - The foundational skill for almost all high-salary data positions.
2. **Python (3 mentions)** - Critical for research and financial market data roles.
3. **VBA (2 mentions)** - Relevant for financial sector analysis
4. **Big Data/Cloud (Azure, Spark, Hadoop, Kafka)** - Predominant in infrastructure-focused roles

**Insight:**
To maximize earning potential, prioritize **SQL** and **Python**, and supplement with **Cloud (Azure)** or **Big Data (Spark/Hadoop)** skills.

![Skills for Top Paying Jobs](assests\2_top_paying_job_skills.png)

### 3. In-demand Skills for Data Analysts 
Querying the most frequently requested skills:
```SQL
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
```
| Skills   | Demand Count |
|---------|------------------|
| SQL     | 1,101            |
| Python  | 909              |
| Tableau | 643              |
| Excel   | 610              |
| SAS     | 526              |

*Table of the demand for the top 5 skills in Data Analyst job postings*

**Key Insights:**
- **Foundation:** **SQL** is the most essential skill, required by nearly every employer.

- **Programming:** **Python** is the most sought-after language.

- **Tools:** A combination of **Tableau** for dashboarding and **Excel** for quick analysis covers business intelligence needs.

- **Banking Influence:** SAS reflects strong demand in traditional financial roles.





### 4. Skills Based on Salary
This analysis calculates the average annual salary associated with each skill in the Hong Kong market to identify the most lucrative technical proficiencies.

```SQL
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
LIMIT 10
```


**SQL** is the most consistent skill for earners. If you're looking to maximize salary, combining **SQL** with Cloud/Big Data tools (Azure/Spark) appears to be a winning strategy in Hong Kong.

| Skill      | Avg. Salary (USD) |
|-----------|-----------------|
| Assembly  | 102,500   |
| Sheets    | 102,500      |
| SQL       | 67,629       |
| Kafka     | 59,400      |
| Hadoop    | 59,400       |
| Azure     | 59,400      |
| Spark     | 59,400     |
| VBA       | 57,500      |
| Python    | 56,005  |
| GraphQL   | 53,014       |

*Table of the average salary for the top 10 paying skills for Data Analysts*

### 5. Optimal Skills for Data Analysts
This analysis cross-references skill demand with average annual salary to identify the most valuable skills for Data Analysts in Hong Kong.

```SQL
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
```
**Key Insights:**

- **Core Skills:** **SQL** and **Python** remain essential, but **Spark** and **AWS** are the key to breaking the $100k barrier while maintaining high marketability.

- **Shift Toward Data Engineering**: The high salaries for **Airflow**, **Terraform**, and **Kubernetes** suggest that top-tier “Data Analyst” positions in Hong Kong now often require Data Engineering and DevOps competencies.

- **Cloud Dominance**: Skills related to Cloud Warehousing (Snowflake, BigQuery, Redshift) are tied to the absolute highest salary points recorded, emphasizing the premium on cloud warehousing and analytics skills.

| Skill     | Job Demand  | Avg. Salary (USD) |
|----------|-----------------|-----------------|
| SQL      | 11              | 90,792      |
| Python   | 10              | 86,742     |
| Spark    | 4               | 108,350      |
| AWS      | 3               | 114,433      |
| Hadoop   | 3               | 113,133      |
| Azure    | 3               | 85,067     |
| Airflow  | 2               | 120,751     |
| Java     | 2               | 113,350      |
| R        | 2               | 57,600       |
| VBA      | 2               | 57,500       |

*Table of the most optimal skills for Data Analyst sorted by salary*


## 🧠 What I Learned
Through this project, I gained practical experience in analyzing real-world job market data for Data Analyst roles in Hong Kong. Key skills and takeaways include:

- **Advanced SQL:** Using joins, aggregations, and CTEs to extract insights from multiple tables.

- **Data Analysis & Interpretation:** Identifying high-paying roles, in-demand skills, and optimal skill combinations.


## 🎯 Conclusion
### Insights
From this analysis, several clear insights emerged:
1. **Financial Services & Fintech Lead:** High-paying roles are concentrated in cryptocurrency exchanges, financial analytics firms, and insurance companies.

2. **SQL & Python Remain Core Skills:** SQL remains essential across all roles, and Python continues to be highly demanded. Mastery of these skills ensures both market stability and access to a wide range of opportunities.

3. **Specialized Skills Drive Salary:** Mastery of SQL provides stability, but cloud competency (AWS/Terraform) provides leverage.

### Thoughts
This project strengthened my SQL and data analysis skills while providing actionable insights into the Hong Kong Data Analyst job market. The analysis serves as a guide for:

- **Prioritizing Skill Development:** Focus on foundational tools like SQL and Python, while exploring cloud and big data platforms to maximize earning potential.

- **Job Search Strategy:** Target high-paying sectors such as fintech and financial services.

- **Continuous Learning:** Adapt to emerging trends, including data engineering and cloud analytics, to remain competitive in the market.