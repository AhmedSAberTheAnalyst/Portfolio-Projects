SELECT *
FROM [SQL Protfolio Project] ..CovidDeaths
WHERE continent is not null	
ORDER BY 3,4

--SELECT *
--FROM [SQL Protfolio Project] ..CovidVaccinations	
--ORDER BY 3,4

-- Lets select the data that we are going to use 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [SQL Protfolio Project] ..CovidDeaths
WHERE continent is not null	
ORDER BY 1,2


-- Lets look ata total cases vs total deaths
-- Shows likelihood of dying if you have contracted covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM [SQL Protfolio Project] ..CovidDeaths
WHERE location like '%states%'
AND continent is not null	
ORDER BY 1,2

--Looking at total cases vs population
-- shows what percentage of population got covid

SELECT location, date, total_cases, population, (total_cases/population)*100 AS Population_Covid_Percentage
FROM [SQL Protfolio Project] ..CovidDeaths
WHERE location like '%states%'
AND continent is not null	
ORDER BY 1,2


-- Looking at countries thhat has the higest infection rate vs population

SELECT location, MAX(total_cases) as Highest_Infection_Count, population, MAX((total_cases/population))*100 AS Population_Covid_Percentage
FROM [SQL Protfolio Project] ..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null	
GROUP BY location, population
ORDER BY Population_Covid_Percentage DESC

-- Showing Countries with highest death counts per population

SELECT location, MAX(CAST(total_deaths as int)) as Total_Deaths_Count
FROM [SQL Protfolio Project] ..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null	
GROUP BY location
ORDER BY Total_Deaths_Count DESC

-- Lets break down things by continent
-- Showing the contnient  with the highest death count per population

SELECT continent, MAX(CAST(total_deaths as int)) as Total_Deaths_Count
FROM [SQL Protfolio Project] ..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null	
GROUP BY continent
ORDER BY Total_Deaths_Count DESC

-- Global Nmbers

SELECT  SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as INT)) as Total_Death, SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 AS Death_Percentage
FROM [SQL Protfolio Project] ..CovidDeaths
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2  

-- Join Covid deaths and Covid vaccinations together
-- Looking at Total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition BY	dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM [SQL Protfolio Project]..CovidDeaths dea
JOIN [SQL Protfolio Project]..CovidVaccinations vac
 ON dea.location = vac.location
 AND	dea.date = vac.date
  WHERE dea.continent is not null
 ORDER BY 2,3  




 --Use CTE


 With PopvsVac (Continent, Location, Date, Population, New_Vaccinations,  RollingPeopleVaccinated) 
 as
 (
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition BY	dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM [SQL Protfolio Project]..CovidDeaths dea
JOIN [SQL Protfolio Project]..CovidVaccinations vac
 ON dea.location = vac.location
 AND	dea.date = vac.date
  WHERE dea.continent is not null
 --ORDER BY 2,3  
 )
 SELECT *, (RollingPeopleVaccinated/Population)*100
 FROM PopvsVac

 --Temp Table
 DROP Table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population  numeric,
 New_Vaccinations numeric,
 RollingPeopleVaccinated numeric
 )

 Insert into #PercentPopulationVaccinated
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition BY	dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM [SQL Protfolio Project]..CovidDeaths dea
JOIN [SQL Protfolio Project]..CovidVaccinations vac
 ON dea.location = vac.location
 AND	dea.date = vac.date
 -- WHERE dea.continent is not null
 --ORDER BY 2,3

  SELECT *, (RollingPeopleVaccinated/Population)*100 as PopvsVac
 FROM #PercentPopulationVaccinated

 -- Creat a view to store data for later visualizations

 Create View PercentPopulationVaccinated as
  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition BY	dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM [SQL Protfolio Project]..CovidDeaths dea
JOIN [SQL Protfolio Project]..CovidVaccinations vac
 ON dea.location = vac.location
 AND	dea.date = vac.date
 WHERE dea.continent is not null
 --ORDER BY 2,3

 SELECT*
 FROM PercentPopulationVaccinated