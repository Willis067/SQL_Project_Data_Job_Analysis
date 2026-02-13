SELECT *
FROM (  -- SubQuery starts here
	SELECT *
	FROM job_postings_fact
	WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jabs;
-- SubQuery ends here