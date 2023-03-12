  --Looking at Total Cases vs Total Deaths
SELECT
  Location,
  Date,
  total_cases,
  total_deaths,
  (total_deaths/total_cases)*100 AS DeathPercentage
FROM
  `primer-projecto-372413.COVID_Project.CovidDeaths`
WHERE
  location = 'United States'
ORDER BY
  1,
  2
  -- looking at total cases VS the population
  -- Shows what percentage of population got Covid
SELECT
  Location,
  Date,
  total_cases,
  population,
  (total_cases/population)*100 AS DeathPercentage
FROM
  `primer-projecto-372413.COVID_Project.CovidDeaths`
WHERE
  location = 'United States'
ORDER BY
  1,
  2
  -- Shows what percentage of population got Covid
SELECT
  Location,
  Date,
  population,
  total_cases,
  (total_cases/population)*100 AS DeathPercentage
FROM
  `primer-projecto-372413.COVID_Project.CovidDeaths`
WHERE
  location = 'United States'
ORDER BY
  1,
  2
  --Looking at Countries with Highest Infection Rate compared to Population
SELECT
  Location,
  population,
  MAX(total_cases) AS HighestInfectionCount,
  MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM
  `primer-projecto-372413.COVID_Project.CovidDeaths`
GROUP BY
  location,
  population
ORDER BY
  PercentPopulationInfected DESC
  -- Showing Countries with Highest Death Count Per Population
SELECT
  Location,
  MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM
  `primer-projecto-372413.COVID_Project.CovidDeaths`
WHERE
  continent IS NOT NULL
GROUP BY
  location,
  population
ORDER BY
  TotalDeathCount DESC
  -- Let's Break things down by continent--
  —- showing continents w/ the highest death coun per population--
SELECT
  continent,
  MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM
  `primer-projecto-372413.COVID_Project.CovidDeaths`
WHERE
  continent IS NOT NULL
GROUP BY
  continent
ORDER BY
  TotalDeathCount DESC
  
  -- Let's Break things down by continent
  
SELECT
  location,
  MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM
  `primer-projecto-372413.COVID_Project.CovidDeaths`
WHERE
  continent IS NULL
GROUP BY
  location
ORDER BY
  TotalDeathCount DESC ;
  
  -- Global Numbers
  
SELECT
  date,
  SUM(new_cases) AS total_cases,
  SUM(CAST(new_deaths AS int)) AS total_deaths,
  SUM(CAST(New_deaths AS int))/SUM(New_Cases)*100 DeathPercentage
FROM
  `primer-projecto-372413.COVID_Project.CovidDeaths`
WHERE
  continent IS NOT NULL
GROUP BY
  date
ORDER BY
  1,
  2;
  
  --Looking at Total Population vs Vaccinations
SELECT
  dea.continent,
  dea.location,
  dea.date,
  dea.population,
  vac.new_vaccinations,
  SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location)
FROM
  `primer-projecto-372413.COVID_Project.CovidDeaths` dea
JOIN
  `primer-projecto-372413.COVID_Project.CovidVaccinations` vac
ON
  dea.location = vac.location
  AND dea.date = vac.date
WHERE
  dea.continent IS NOT NULL
ORDER BY
  2,
  3
  
  --Looking at Total Population vs Vaccinations
  --Percent of Population Vaccinated
  -- USE CTE
  
WITH
  PopvsVac AS (
  SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
  FROM
    `primer-projecto-372413.COVID_Project.CovidDeaths` dea
  JOIN
    `primer-projecto-372413.COVID_Project.CovidVaccinations` vac
  ON
    dea.location = vac.location
    AND dea.date = vac.date
  WHERE
    dea.continent IS NOT NULL
    --Order by 2,3
    )
SELECT
  *,
  (RollingPeopleVaccinated/population)*100 AS PercentofPopVaccinated
FROM
  PopvsVac
  
--Temp 
  
 DROP TABLE IF exists 
 primer-projecto-372413.COVID_Project.PERCENTPOPULATIONVACCINATED
;

CREATE TABLE primer-projecto-372413.COVID_Project.PERCENTPOPULATIONVACCINATED

(
continent STRING(255), 
location STRING(255), 
date datetime, 
population numeric, 
new_vaccinations numeric, 
RollingVaccinations numeric

);
INSERT INTO  primer-projecto-372413.COVID_Project.PERCENTPOPULATIONVACCINATED

SELECT POP.continent, POP.location, POP.date, POP.population, VACS.new_vaccinations, 

SUM(VACS.new_vaccinations) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingVaccinations

FROM  `primer-projecto-372413.COVID_Project.CovidDeaths` DEA

JOIN `primer-projecto-372413.COVID_Project.CovidVaccinations`  VACS

  ON dea.location = vac.location

  and dea.date = vac.date

WHERE dea.continent is not null ;

SELECT *, (RollingVaccinations/population)*100
FROM primer-projecto-372413.COVID_Project.PERCENTPOPULATIONVACCINATED