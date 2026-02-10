/*
Question: Do remote jobs offer higher pay and better benefits compared to non-remote roles?
- Compare average salaries between remote and non-remote jobs.
- Measure the percentage of jobs offering health insurance by work type.
- Measure the percentage of jobs that do not require a formal degree.
Why? This analysis evaluates whether remote roles actually offer higher pay, stronger benefits, 
    and greater accessibility compared to non-remote positions, helping job seekers and 
    employers make data-driven decisions.
*/

WITH base_jobs AS (
    SELECT
        job_id,
        job_work_from_home,
        salary_year_avg,
        job_health_insurance,
        job_no_degree_mention
    FROM job_postings_fact
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
),
aggre_metrics AS (
    SELECT
        job_work_from_home AS remote_jobs,
        COUNT(job_id) AS job_count,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary,
        COUNT(
            CASE
                WHEN job_health_insurance = TRUE THEN 1
            END) AS health_insurance_jobs,
        COUNT(
            CASE
                WHEN job_no_degree_mention = TRUE THEN 1
            END) AS no_degree_jobs
    FROM base_jobs
    WHERE salary_year_avg IS NOT NULL
    GROUP BY job_work_from_home
)
SELECT
    remote_jobs,
    job_count,
    avg_salary,
    ROUND((health_insurance_jobs * 100.0 / job_count), 2) 
        AS health_insurance_jobs_pct,
    ROUND((no_degree_jobs * 100.0 / job_count), 2) 
        AS no_degree_jobs_pct
FROM 
    aggre_metrics;