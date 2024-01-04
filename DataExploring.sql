--DATA EXPLORATION-----
SELECT *
FROM Project1.dbo.CovidDeaths
WHERE continent IS NOT NULL
order by 3,4

--SELECT *
--FROM Project1.dbo.CovidVaccinations
--order by 3,4

--Selecting data that we are going to use

SELECT location, date, population, total_cases, new_cases, total_deaths
FROM Project1.dbo.CovidDeaths
order by 1,2

--Total Cases vs Total deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Deathpercent
FROM Project1.dbo.CovidDeaths
--Where location like '%Nepal%'
order by 1,2

--Total cases VS Population
SELECT location, date,population, total_cases, (total_deaths/population)*100 AS InfectedPopulationpercent
FROM Project1.dbo.CovidDeaths
--Where location like '%Nepal%'
order by 1,2

--Countries with highest infection rate compared to population
SELECT location, max(total_cases) AS HighestInfection, population, Max((total_cases/population))*100 AS InfectedPopulationpercent
FROM Project1.dbo.CovidDeaths
--Where location like '%Nepal%'
GROUP BY population, location
order by InfectedPopulationpercent desc

--Countries with highest death count per population
SELECT location, max(total_deaths) AS DeathCount
FROM Project1.dbo.CovidDeaths
--Where location like '%Nepal%'
WHERE continent IS NOT NULL
GROUP BY location
order by DeathCount desc

--BY CONTINENT
--Continents with highest death count
SELECT continent, max(total_deaths) AS DeathCount
FROM Project1.dbo.CovidDeaths
--Where location like '%Nepal%'
WHERE continent IS NOT NULL
GROUP BY continent
order by DeathCount desc

--GLOBAL DATA
SELECT date, SUM(total_cases) as total_cases, sum(total_deaths) as total_deaths, sum(total_deaths)/SUM(total_cases)*100 AS DeathPercent
FROM Project1.dbo.CovidDeaths
where continent is not null
GROUP BY date
order by 1,2

SELECT SUM(total_cases) as total_cases, sum(total_deaths) as total_deaths, sum(total_deaths)/SUM(total_cases)*100 AS DeathPercent
FROM Project1.dbo.CovidDeaths
where continent is not null
order by 1,2

--JOIN
SELECT *
FROM Project1.dbo.CovidDeaths as deaths
JOIN Project1.dbo.CovidVaccinations as vaccines
on deaths.location=vaccines.location
and deaths.date=vaccines.date 

--Total population vs Vaccinations
SELECT deaths.continent, deaths.location,deaths.population, deaths.date, vaccines.new_vaccinations, sum(vaccines.new_vaccinations) 
over (Partition by deaths.location order by deaths.location, deaths.date) as PeopleVaccinated
FROM Project1.dbo.CovidDeaths as deaths
JOIN Project1.dbo.CovidVaccinations as vaccines
on deaths.location=vaccines.location
and deaths.date=vaccines.date 
where deaths.continent is not null
order by 2,3

--USING CTE
WITH Popnvac (continent, location, date, population,new_vaccinations, PeopleVaccinated)
as(
SELECT deaths.continent, deaths.location,deaths.population, deaths.date, vaccines.new_vaccinations, sum(vaccines.new_vaccinations) 
over (Partition by deaths.location order by deaths.location, deaths.date) as PeopleVaccinated
FROM Project1.dbo.CovidDeaths as deaths
JOIN Project1.dbo.CovidVaccinations as vaccines
on deaths.location=vaccines.location
and deaths.date=vaccines.date 
where deaths.continent is not null
--order by 2,3
)
SELECT *, (PeopleVaccinated / population) * 100
FROM Popnvac


--TEMP Table
DROP TABLE IF EXISTS #VaccinatedPopulationPercents
CREATE TABLE #VaccinatedPopulationPercents
(
    Continent nvarchar(255),
    Location nvarchar(255),
    date datetime,
    Population float,
    New_vaccinations float,
    PeopleVaccinated float
)

INSERT INTO #VaccinatedPopulationPercents
SELECT 
    deaths.continent, 
    deaths.location,
    deaths.date, 
    deaths.population, 
    vaccines.new_vaccinations,
    SUM(vaccines.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.date) as PeopleVaccinated
FROM 
    Project1.dbo.CovidDeaths as deaths
JOIN 
    Project1.dbo.CovidVaccinations as vaccines
    ON deaths.location = vaccines.location
    AND deaths.date = vaccines.date 
WHERE 
    deaths.continent IS NOT NULL

-- SELECT statement to calculate percentage
SELECT 
    *, 
    (PeopleVaccinated / Population) * 100 as VaccinationPercentage
FROM 
    #VaccinatedPopulationPercents

--CREATING VIEW 
CREATE VIEW VaccintedPopulationPercents as
SELECT 
    deaths.continent, 
    deaths.location,
    deaths.date, 
    deaths.population, 
    vaccines.new_vaccinations,
    SUM(vaccines.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.date) as PeopleVaccinated
FROM 
    Project1.dbo.CovidDeaths as deaths
JOIN 
    Project1.dbo.CovidVaccinations as vaccines
    ON deaths.location = vaccines.location
    AND deaths.date = vaccines.date 
WHERE 
    deaths.continent IS NOT NULL

SELECT * 
FROM VaccintedPopulationPercents

