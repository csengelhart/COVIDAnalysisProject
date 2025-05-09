-- change date column from varchar to DATE data type in CovidDeaths and CovidVaccinations
ALTER TABLE Portfolio..CovidDeaths ALTER COLUMN date DATE
ALTER TABLE Portfolio..CovidVaccinations ALTER COLUMN date DATE
 
 -- Change required fields to usable dataatypes
ALTER TABLE Portfolio..CovidDeaths ALTER COLUMN total_cases float
ALTER TABLE Portfolio..CovidDeaths ALTER COLUMN total_deaths float
ALTER TABLE portfolio..CovidDeaths ALTER COLUMN population BIGINT
ALTER TABLE portfolio..CovidDeaths ALTER COLUMN new_cases float
ALTER TABLE portfolio..CovidDeaths ALTER COLUMN new_deaths float
ALTER TABLE portfolio..CovidVaccinations ALTER COLUMN new_vaccinations float


-- Scripts for visualization

-- 1 . 
-- Percent of total cases globally that resulted in death
SELECT 
	SUM(new_cases) as TotalCases, 
	SUM(new_deaths) as TotalDeaths, 
	SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
FROM
	Portfolio..CovidDeaths
WHERE
	continent != ''


-- 2. 

-- get death count from all continents, removing grouped country locations like EU, World and International from query

SELECT
	location AS Location, 
	SUM(new_deaths) AS TotalDeathCount
FROM 
	Portfolio..CovidDeaths
WHERE 
	continent = ''
	AND location NOT IN('World', 'European Union', 'International')
GROUP BY
	location
ORDER BY 
	TotalDeathCount desc


-- 3.
-- Get infection count for each country and the percent of population, countries with population of 0 are filtered out

SELECT
	location AS Location, 
	population AS Population,
	MAX(total_cases) AS HighestInfectionCount, 
	MAX((total_cases/population))*100 AS PercentPopulationInfected
From
	Portfolio..CovidDeaths
WHERE
	population != 0
GROUP BY 
	Location, 
	Population
ORDER BY 
	PercentPopulationInfected DESC


-- 4.
-- For each country get the rolling infection count by date
-- and the percent population infected at that point in time

SELECT 
	location AS Location, 
	population AS Population,
	date AS Date, 
	MAX(total_cases) as HighestInfectionCount,  
	Max((total_cases/population))*100 as PercentPopulationInfected
FROM
	Portfolio..CovidDeaths
WHERE
	population != 0

GROUP BY 
	location, 
	population, 
	date
ORDER BY 
	PercentPopulationInfected desc


	