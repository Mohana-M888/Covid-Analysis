--QUERY 1.
select * from corona..coviddeaths
WHERE CONTINENT IS NOT NULL
order by location,date;

--QUERY 2.
select * from corona..covidvaccinations
WHERE CONTINENT IS NOT NULL
order by location,date;

--QUERY 3.
SELECT LOCATION, DATE,TOTAL_CASES,NEW_CASES,TOTAL_DEATHS, POPULATION FROM CORONA..COVIDDEATHS
WHERE CONTINENT IS NOT NULL
order by location,date;

--QUERY 4.
SELECT CONTINENT,LOCATION FROM CORONA..COVIDDEATHS
WHERE CONTINENT IS NOT NULL
order by CONTINENT;


--QUERY 5.
--LOOKING AT TOTAL CASES VS TOTAL DEATHS (SHOWS LIKELIHOOD OF DYING IF YOU CONTRACT COVID IN ASIA)
SELECT LOCATION, DATE,TOTAL_CASES,TOTAL_DEATHS, (total_deaths/total_cases)*100 AS DEATHPERCENTAGE
FROM CORONA..COVIDDEATHS
WHERE CONTINENT = 'ASIA'
order by location,date;


--QUERY 6.
--LOOKING AT TOTAL CASES VS POPULATION (SHOWS WHAT PRCENTAGE OF POPULATION GOT COVID)
SELECT LOCATION,POPULATION,MAX(TOTAL_CASES) AS COVID_CASES,ROUND((MAX(TOTAL_CASES)/population)*100,2) AS COVID_CASE_PERCENTAGE
FROM CORONA..COVIDDEATHS
WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION,POPULATION
order by LOCATION;


--QUERY 7.
--SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION
SELECT LOCATION, POPULATION,MAX(CAST(TOTAL_DEATHS AS INT)) AS HIGHESTDEATHCOUNT
FROM CORONA..COVIDDEATHS
WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION,POPULATION
order by HIGHESTDEATHCOUNT DESC;


--QUERY 8.
--BREAK DOWN BY CONTINENT
--TOTAL CASES COUNTS SORTED FROM HIGHEST TO LOWEST
WITH CONTINENT_WISE_CASES AS (SELECT CONTINENT,LOCATION, MAX(TOTAL_CASES) AS TOTALCASES
FROM CORONA..COVIDDEATHS
WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION,CONTINENT)
SELECT CONTINENT,SUM(TOTALCASES) AS TOTALCASECOUNT FROM CONTINENT_WISE_CASES
GROUP BY CONTINENT
ORDER BY SUM(TOTALCASES) DESC ;


--QUERY 9.
--TOTAL DEATH COUNTS SORTED FROM HIGHEST TO LOWEST
WITH CONTINENT_WISE_DEATH AS (SELECT CONTINENT,LOCATION, MAX(CAST(TOTAL_DEATHS AS INT)) AS TOTALDEATHCOUNT
FROM CORONA..COVIDDEATHS
WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION,CONTINENT)
SELECT CONTINENT,SUM(TOTALDEATHCOUNT) AS TOTALDEATHS FROM CONTINENT_WISE_DEATH
GROUP BY CONTINENT
ORDER BY SUM(TOTALDEATHCOUNT) DESC ;


--QUERY 10.
--GLOBAL NUMBERS
SELECT date, SUM(NEW_CASES) as NEWCASE, SUM(CAST(NEW_DEATHS AS INT)) as NEWDEATH, SUM(CAST(NEW_DEATHS AS INT))/SUM(NEW_CASES)*100 as Deathpercentage
FROM CORONA..COVIDDEATHS
WHERE CONTINENT IS NOT NULL AND NEW_CASES IS NOT NULL
GROUP BY date
order by 1,2;


--QUERY 11.
--DATA AFTER JOINING BOTH TABLES
SELECT * FROM corona..coviddeaths D
JOIN
corona..covidvaccinations V 
ON
D.location=V.location
AND
D.date=V.date

--QUERY 12.
--TOTAL VACCINATIONS GIVEN
SELECT D.CONTINENT,D.LOCATION,D.DATE,D.POPULATION,V.NEW_VACCINATIONS
,SUM(CONVERT(INT,V.NEW_VACCINATIONS)) OVER(PARTITION BY D.LOCATION ORDER BY D.LOCATION,D.DATE) AS TOTAL_VACCINATION_TILL_DATE 
FROM corona..coviddeaths D
JOIN
corona..covidvaccinations V 
ON
D.location=V.location
AND
D.date=V.date
WHERE D.CONTINENT IS NOT NULL
ORDER BY 2,3

--QUERY 13.
--TOTAL VACCINATION GIVEN IN EACH LOCATION
WITH TOTALVACCINE_LOCATION_WISE AS 
(SELECT D.CONTINENT,D.LOCATION,D.DATE,D.POPULATION,V.NEW_VACCINATIONS
,SUM(CONVERT(INT,V.NEW_VACCINATIONS)) OVER(PARTITION BY D.LOCATION ORDER BY D.LOCATION,D.DATE) AS TOTAL_VACCINATION_TILL_DATE 
FROM corona..coviddeaths D
JOIN
corona..covidvaccinations V 
ON
D.location=V.location
AND
D.date=V.date
WHERE D.CONTINENT IS NOT NULL)
SELECT LOCATION,MAX(TOTAL_VACCINATION_TILL_DATE) FROM TOTALVACCINE_LOCATION_WISE
GROUP BY LOCATION
ORDER BY LOCATION;


--QUERY 14.
--PERCENTAGE  OF POPULATION VACCINATED IN EACH LOCATION
WITH POPVSVAC AS(
SELECT D.CONTINENT,D.LOCATION,D.DATE,D.POPULATION,V.NEW_VACCINATIONS
,SUM(CONVERT(INT,V.NEW_VACCINATIONS)) OVER(PARTITION BY D.LOCATION ORDER BY D.LOCATION,D.DATE) AS NEW_VACCINATION_TILL_DATE 
FROM corona..coviddeaths D
JOIN
corona..covidvaccinations V 
ON
D.location=V.location
AND
D.date=V.date
WHERE D.CONTINENT IS NOT NULL)
SELECT LOCATION, ROUND(MAX((NEW_VACCINATION_TILL_DATE/population)*100),2) AS PERCENT_OF_POPULATION_VACCINATED FROM POPVSVAC
GROUP BY LOCATION
ORDER BY LOCATION;


--QUERY 15.
--TEMP TABLE
DROP TABLE IF EXISTS PERCENTPOPULANVACCINATED
CREATE TABLE PERCENTPOPULANVACCINATED
( CONTINENT NVARCHAR(255),
LOCATION NVARCHAR(255),
DATE DATETIME,
POPULATION NUMERIC,
NEW_VACCINATIONS NUMERIC,
ROLLINGPEOPLEVACCINATED NUMERIC)
INSERT INTO PERCENTPOPULANVACCINATED
SELECT D.CONTINENT,D.LOCATION,D.DATE,D.POPULATION,V.NEW_VACCINATIONS
,SUM(CONVERT(INT,V.NEW_VACCINATIONS)) OVER(PARTITION BY D.LOCATION ORDER BY D.LOCATION,D.DATE) AS NEW_VACCINATION_TILL_DATE 
FROM corona..coviddeaths D
JOIN
corona..covidvaccinations V 
ON
D.location=V.location
AND
D.date=V.date
WHERE D.CONTINENT IS NOT NULL


--QUERY 16.
--TOTAL VACCINATIONS GIVEN ACROSS GLOBE DATE WISE
SELECT DATE, SUM(ROLLINGPEOPLEVACCINATED) FROM PERCENTPOPULANVACCINATED
GROUP BY DATE
ORDER BY DATE;

--------------------------------CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION----------------------------------------------


--QUERY 17.
--VIEW 1 
CREATE VIEW PERCENTPOPULATIONVACCINATED AS
SELECT D.CONTINENT,D.LOCATION,D.DATE,D.POPULATION,V.NEW_VACCINATIONS
,SUM(CONVERT(INT,V.NEW_VACCINATIONS)) OVER(PARTITION BY D.LOCATION ORDER BY D.LOCATION,D.DATE) AS NEW_VACCINATION_TILL_DATE 
FROM corona..coviddeaths D
JOIN
corona..covidvaccinations V 
ON
D.location=V.location
AND
D.date=V.date
WHERE D.CONTINENT IS NOT NULL

--QUERY 18.
SELECT * FROM PERCENTPOPULATIONVACCINATED

--QUERY 19
--VIEW 2
CREATE VIEW NEW_METRICS AS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, ROUND(SUM(cast(new_deaths as int))/SUM(New_Cases)*100,2) as DeathPercentage
From CORONA..CovidDeaths
where continent is not null 

--QUERY 20
--VIEW 3
CREATE VIEW INFECTION_COUNT AS
Select Location, Population, SUM(new_cases) as Total_Cases,  (sum(new_cases)/population)*100 as Infection_Rate
,SUM(cast(new_deaths as int)) as Total_Deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as Death_Rate
,sum(cast(hosp_patients as int)) as Total_Patients_Hospitalized
,(SUM(cast(hosp_patients as int))/SUM(new_cases))*100 as Hospitalization_Rate
From CORONA..CovidDeaths
Where continent is not null
Group by Location, Population


--QUERY 21
--VIEW 4
CREATE VIEW DATE_WISE_NUMBERS AS
Select D.Location, D.Population,D.date, CONVERT(INT,D.new_cases) AS NEW_CASES,CONVERT(INT,D.new_deaths) AS NEW_DEATHS,CONVERT(INT,V.NEW_VACCINATIONS) AS NEW_VACCINATIONS,
SUM(CONVERT(INT,V.NEW_VACCINATIONS)) OVER(PARTITION BY D.LOCATION ORDER BY D.LOCATION,D.DATE) AS TOTAL_VACCINATION_TILL_DATE
FROM corona..coviddeaths D
JOIN
corona..covidvaccinations V 
ON
D.location=V.location
AND
D.date=V.date
WHERE D.CONTINENT IS NOT NULL


--QUERY 22
--VIEW 5
CREATE VIEW CONTINENT_Location AS
Select CONTINENT, LOCATION,max(median_age) as median_age,
max(population_density) as population_density,max(human_development_index) as human_development_index,
max(gdp_per_capita) as gdp_per_capita
From CORONA..covidvaccinations
Where continent is not null 
group by continent,location
