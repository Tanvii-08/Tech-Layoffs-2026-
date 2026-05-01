create database Tanvi;
use Tanvi;

select * from tech_layoffs_2026;

--1 Find the total number of layoffs across all companies.
select sum(jobs_cut) as total_layoffs  from tech_layoffs_2026; 


--2 List all companies and calculate total layoffs per company, sorted from highest to lowest.
 select company,sum(jobs_cut) as total_layoffss  from tech_layoffs_2026 group by company
order by total_layoffss desc; 


--3 Show total layoffs by industry in descending order.
select sector,sum(jobs_cut) as total_layoffx from tech_layoffs_2026 group by sector order by total_layoffx desc


--4 Find total layoffs by location/country.
select country,sum(jobs_cut) as total_layoff  from tech_layoffs_2026 group by country ;


--5 Display layoffs grouped by month and year.
select year(layoff_date) as years ,month(layoff_date) as months,sum(jobs_cut) as total_layoff from tech_layoffs_2026 group by  year(layoff_date), month(layoff_date) order by years,months


--6 Find the top 5 companies with highest layoffs.
select Top 5  company,sum(jobs_cut) as total_layoff  from tech_layoffs_2026 group by company order by total_layoff desc


--7 Which industry has the highest average layoffs per company?
select top 1  sector,avg(jobs_cut) as total_layoffss  from tech_layoffs_2026 group by sector order by total_layoffss desc;


--8 Calculate running total of layoffs over time.
select layoff_date,sum(jobs_cut) as total_layoffs,sum( sum(layoffs_2024+layoffs_2025)) over (order by layoff_date) as running_total  from tech_layoffs_2026 group by layoff_date order by layoff_date;


--9 Rank companies based on total layoffs.

SELECT 
    company, 
    SUM(jobs_cut) AS total_layoff, 
    DENSE_RANK() OVER (ORDER BY SUM(jobs_cut) DESC) AS Ranks 
FROM tech_layoffs_2026 
GROUP BY company 
ORDER BY total_layoff DESC;


--10 Find total layoffs by company stage.
select sum(jobs_cut) as total_layoffs from tech_layoffs_2026;


--11 Find companies where 100% employees were laid off.
SELECT 
    company,
    jobs_cut,
    pre_layoff_headcount,
    pct_workforce_cut
FROM tech_layoffs_2026
WHERE jobs_cut = pre_layoff_headcount
   OR pct_workforce_cut = 100;




--12 Analyze relationship between funds raised and layoffs.

SELECT 
    company,
    sector,
    country,
    company_revenue_2025_bn AS revenue_2025_bn,
    SUM(jobs_cut) AS total_layoffs,
    ROUND(SUM(jobs_cut) * 100.0 / NULLIF(SUM(pre_layoff_headcount),0), 2) AS pct_workforce_cut,
    ROUND(SUM(jobs_cut) * 1.0 / NULLIF(company_revenue_2025_bn,0), 2) AS layoffs_per_billion_revenue
FROM tech_layoffs_2026
GROUP BY company, sector, country, company_revenue_2025_bn
ORDER BY layoffs_per_billion_revenue DESC;



--13 Find top industry in each country with highest layoffs.
WITH industry_layoffs AS (
    SELECT 
        country,
        sector AS industry,
        SUM(jobs_cut) AS total_layoffs,
        ROW_NUMBER() OVER (
            PARTITION BY country 
            ORDER BY SUM(jobs_cut) DESC
        ) AS rn
    FROM tech_layoffs_2026
    GROUP BY country, sector
)
SELECT 
    country, 
    industry, 
    total_layoffs
FROM industry_layoffs
WHERE rn = 1;


--✅ Query: Find sectors where AI was cited most often in layoffs
SELECT 
    sector,
    COUNT(*) AS ai_layoff_count
FROM 
    tech_layoffs_2026
WHERE 
    ai_cited = 1  
GROUP BY 
    sector
ORDER BY 
    ai_layoff_count DESC;
