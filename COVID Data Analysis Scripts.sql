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

SELECT * 
FROM Portfolio..CovidDeaths
ORDER BY location, date

SELECT * 
FROM Portfolio..CovidVaccinations
ORDER BY location, date

-- Select needed data
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio..CovidDeaths
ORDER BY location, date

-- total cases vs Total deaths
SELECT
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage 
FROM
    Portfolio..CovidDeaths
WHERE
    total_cases != 0 AND location LIKE '%states%'
ORDER BY
    location,
	date;


-- total cases vs population
SELECT
    location,
    date,
	population AS Population,
    total_cases  AS TotalCases,
	(total_cases / population) * 100 AS PercentagePopulation
FROM
    Portfolio..CovidDeaths
WHERE
    population != 0 AND location LIKE '%states%'
ORDER BY
    location,
    date;


-- find countries with highest infection rate compared to population
SELECT
    location AS Location,
	population AS Population,
    MAX(total_cases)  AS HighestInfectionCount,
	MAX(total_cases / population) * 100 AS PercentagePopulationInfected
FROM
    Portfolio..CovidDeaths
WHERE
    population != 0
GROUP BY Location, Population
ORDER BY
    PercentagePopulationInfected DESC



-- Total death count by continent 
SELECT
	continent AS Continent,
	MAX(total_deaths) AS TotalDeathCount
FROM 
	Portfolio..CovidDeaths
WHERE
	Population != 0 AND continent != ''
GROUP BY 
	Continent
ORDER BY TotalDeathCount DESC




-- Countries with highest death count per population
SELECT
	location AS Location,
	population AS Population,
	MAX(total_deaths) AS TotalDeathCount,
	(MAX(total_deaths) / Population) * 100 AS PercentagePopulationDied
FROM 
	Portfolio..CovidDeaths
WHERE
	Population != 0 AND continent != ''
GROUP BY 
	Location,Population
ORDER BY PercentagePopulationDied DESC




-- Calculate global numbers
SELECT
	date AS Date,
	SUM(new_cases) AS TotalCases,
	SUM(new_deaths) AS TotalDeaths,
	(SUM(new_deaths) / SUM(new_cases)) * 100 AS DeathPercentage
FROM
	Portfolio..CovidDeaths
WHERE 
	continent != '' AND new_cases != 0
GROUP BY date
ORDER BY date, TotalCases


-- Total population vs vaccinations
SELECT
	dea.continent AS Continent,
	dea.location AS Location,
	dea.date AS Date,
	dea.population AS Population,
	vac.new_vaccinations AS NewVaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingNumberVaccinated
FROM
	Portfolio..CovidDeaths  AS dea
JOIN
	Portfolio..CovidVaccinations AS vac
ON
	dea.location = vac.location AND 
	dea.date = vac.date
WHERE
	dea.continent != '' 
--GROUP BY
--dea.location
ORDER BY
location, date


-- CTE
WITH PopVsVac (Continent, Location, Date, Population, NewVaccinations, RollingNumberVaccinated)
AS 
(
SELECT
	dea.continent AS Continent,
	dea.location AS Location,
	dea.date AS Date,
	dea.population AS Population,
	vac.new_vaccinations AS NewVaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingNumberVaccinated
FROM
	Portfolio..CovidDeaths  AS dea
JOIN
	Portfolio..CovidVaccinations AS vac
ON
	dea.location = vac.location AND 
	dea.date = vac.date
WHERE
	dea.continent != '' 
)


SELECT 
	*,
	(RollingNumberVaccinated / Population) * 100
FROM
	PopVsVac
WHERE
	Population != 0
ORDER BY
	Location, Date


-- Create table
CREATE TABLE #PercentagePopulationVaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	NewVaccinations numeric,
	RollingNumberVaccinated numeric
)

-- Temp Table
INSERT INTO #PercentagePopulationVaccinated
	SELECT
		dea.continent AS Continent,
		dea.location AS Location,
		dea.date AS Date,
		dea.population AS Population,
		vac.new_vaccinations AS NewVaccinations,
		SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingNumberVaccinated
	FROM
		Portfolio..CovidDeaths  AS dea
	JOIN
		Portfolio..CovidVaccinations AS vac
	ON
		dea.location = vac.location AND 
		dea.date = vac.date
	WHERE
		dea.continent != '' 

SELECT
	*,
	(RollingNumberVaccinated / Population) * 100
FROM 
	#PercentagePopulationVaccinated
WHERE
	Population != 0



-- Create View for visualization
CREATE VIEW PercentagePopulationVaccinated AS
	SELECT
		dea.continent AS Continent,
		dea.location AS Location,
		dea.date AS Date,
		dea.population AS Population,
		vac.new_vaccinations AS NewVaccinations,
		SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingNumberVaccinated
	FROM
		Portfolio..CovidDeaths  AS dea
	JOIN
		Portfolio..CovidVaccinations AS vac
	ON
		dea.location = vac.location AND 
		dea.date = vac.date
	WHERE
		dea.continent != ''
		

