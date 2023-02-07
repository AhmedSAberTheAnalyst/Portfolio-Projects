SELECT *
FROM [SQL Project 2]..['CovidDeaths]
WHERE continent IS NOT NULL
ORDER BY 3,4
-- IAM GOING TO USE THE COVID DATA TOO SEE SOME INFO IN MY COUNTRY EGYPT AND MY CONTINENT AFRICA 
-- LET`S SELECT THE DATA WE ARE GOING TO USE

SELECT continent,  location, date,  total_cases, new_cases, total_deaths, population
FROM [SQL Project 2]..['CovidDeaths]
WHERE continent IS NOT NULL
ORDER BY 2,3

-- LET`S LOOK AT TOTAL CASES VS TOTAL DEATHS IN EGYPT

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM [SQL Project 2]..['CovidDeaths]
WHERE location LIKE '%Egypt%' AND continent is not null
ORDER BY 2,3

--	LET`S LOOK AT TOTAL CASES VS POPULATION IN EGYPT 
--  SHOW WHAT PERCENTAGE GOT COVID IN EGYPT

SELECT location, date, total_cases, population, (total_cases/population)*100 AS Population_Covid_Percentage
FROM [SQL Protfolio Project] ..CovidDeaths
WHERE location like '%Egypt%'
AND continent is not null	
ORDER BY 1,2
-- AS WE SEE HERE THE CASES INCREASDED FROM 60 CASES TO 285 IN JUST 9 DAYS AND REACHED ITS MAX WHERE WE HAVE 227552 CASES IN JUST 1 YEAR 

-- LOOKING AT COUNTRIES THAT HAS THE HIGHIEST INFECTION RATE IN AFRICA

SELECT location, MAX(total_cases) as Highest_Infection_Count, population, MAX((total_cases/population))*100 AS Population_Covid_Percentage
FROM [SQL Protfolio Project] ..CovidDeaths
WHERE continent like '%Africa%'
AND continent is not null	
GROUP BY location, population
ORDER BY Population_Covid_Percentage DESC
-- HERE WE SEE THE TOP 10 COUNTRIES WITH HIGHEST INFECTION ARE
-- 10 (DJIBOUTI) 9 (MOROCCO) 8 (ESWATINI) 7 (NAMIBIA) 6 (BOTSWANA)
-- 5 (LIBYA) 4 (TUNISIA) 3 (SOUTH AFRICA) 2 (CAPE VERDE) 1 (SEYCHELLES)

-- LET`S LOOK AT COUNTRIES WITH HIGHEST DEATHS COUNT IN AFRICA

SELECT  location, MAX(CAST(total_deaths as int)) as Total_Deaths_Count
FROM [SQL Protfolio Project] ..CovidDeaths
WHERE continent like '%Africa%'
AND continent is not null	
GROUP BY location
ORDER BY Total_Deaths_Count DESC
-- HERE WE SEE THE TOP 10 COUNTRIES WITH HIGHIEST DEATHS ARE
-- 10 (NIGERIA) 9 (SUDAN) 8 (KENYA) 7 (LIBYA) 6 (ALGERIA)
-- 5 (ETHIOPIA) 4 (MOROCCO) 3 (TUNISIA) 2 (EGYPT) 1 (SOUTHAFRICA)

-- LETS BREAK DOWN THINGS BY CONTINENT 
-- TO SEE AFRICA COMPARED TO OTHER CONTINENT

SELECT continent, MAX(CAST(total_deaths as int)) as Total_Deaths_Count
FROM [SQL Protfolio Project] ..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null	
GROUP BY continent
ORDER BY Total_Deaths_Count DESC
-- HERE WE SEE AFRICA COMES AT NUMBER 6 WITH 54350 DEATHS AND NUMBER 1 IS NORTH AMERICA WITH 576232 DEATHS

-- NOW WE JOIN COVID DEAHTS AND COVID VACCINATIONS TOGETHER 
-- LOOKING AT TOTAL VACCINATION VS POPULATION IN EGYPT AND IN AFRICA

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition BY	dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM [SQL Project 2]..['CovidDeaths] dea
JOIN [SQL Project 2]..['Covid Vaccinations] vac
 ON dea.location = vac.location
 AND	dea.date = vac.date
 WHERE dea.location like '%Egypt%'
 AND dea.continent is not null
 ORDER BY 2,3  
 -- HERE WE SEE VACCINATIONS STARTED AT 23/5/2021 WITH 84223 NEW VACCINATIONS IN EGYPT

 -- LETS CHECK ON AFRICA

 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition BY	dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM [SQL Project 2]..['CovidDeaths] dea
JOIN [SQL Project 2]..['Covid Vaccinations] vac
 ON dea.location = vac.location
 AND	dea.date = vac.date
 WHERE dea.continent like '%Africa%'
 AND dea.continent is not null
 ORDER BY 2,3 
 -- HERE WE SEE ALGERIA FOR EXAMPLE STARTED AT 30/1/2021 WITH 30 NEW VACCINATIONS AND HERE WE SEE ALL AFRICAN COUNTRIES AND THERE NUMBERS

 -- USE CTE 

 With PopvsVac (Continent, Location, Date, Population, New_Vaccinations,  RollingPeopleVaccinated) 
 as
 (
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition BY	dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM [SQL Project 2]..['CovidDeaths] dea
JOIN [SQL Project 2]..['Covid Vaccinations] vac
 ON dea.location = vac.location
 AND	dea.date = vac.date
 WHERE dea.location like '%Egypt%'
 AND dea.continent is not null
 )
  SELECT *, (RollingPeopleVaccinated/Population)*100 Percent_of_People_vaccinated
 FROM PopvsVac

 -- IN EGYPT IT STARTED AT 23/5/2021 WITH 84223 ROLING PEOPLE VACCINATED  AND 0.0758 PERCENT 
 -- TO GO UP TO 2157499 ROLLING PEOPLE VACCINATED AND 1.943 PERCENT AT 21/1/2023

 -- TEMP TABLE

  DROP Table if exists #Percent_Egyptians_Vaccinated
 Create Table #Percent_Egyptians_Vaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population  numeric,
 New_Vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
 Insert into #Percent_Egyptians_Vaccinated
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition BY	dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM [SQL Project 2]..['CovidDeaths] dea
JOIN [SQL Project 2]..['Covid Vaccinations] vac
 ON dea.location = vac.location
 AND	dea.date = vac.date
 WHERE dea.location like '%Egypt%'
 AND dea.continent is not null

   SELECT *, (RollingPeopleVaccinated/Population)*100 as Percent_of_People_vaccinated
 FROM #Percent_Egyptians_Vaccinated
 -- HERE WE SEE PERCENT OF PEOPLE VACCINATED IS 0.7588 AT 23/5/2021 AND IT GOES UP TO 1.94 AT 21/1/2023

 -- CREATING A VIEW FOR LATER VISUALIZATIONS

Create View Percent_Egyptians_Vaccinated as
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition BY	dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM [SQL Project 2]..['CovidDeaths] dea
JOIN [SQL Project 2]..['Covid Vaccinations] vac
 ON dea.location = vac.location
 AND	dea.date = vac.date
 WHERE dea.location like '%Egypt%'
 AND dea.continent is not null

 SELECT*
 FROM Percent_Egyptians_Vaccinated