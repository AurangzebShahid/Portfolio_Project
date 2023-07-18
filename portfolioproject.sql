/*
Covid 19 Data Exploration 

Skills used: Joins, Windows Functions, Aggregate Functions, Creating Views, 
Converting Data Types

*/

SELECT*
FROM [CovidDeaths ]

SELECT*
FROM CovidVaccinations


-- Select Data that we are going to be starting with

SELECT Location, date,total_cases, new_cases, total_deaths,population 
FROM [CovidDeaths ]
WHERE Continent is not Null
ORDER BY 1,2

-- Total Cases vs Total Deaths
-- Shows likelidood of deaths who contracted covid in Pakistan

SELECT Location, date,total_cases, total_deaths, (total_deaths/total_cases)*100 
AS DeathPercentage
FROM [CovidDeaths ]
WHERE Location like '%kistan%'
AND Continent is not Null
ORDER BY 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT Location,Population,max(Total_Cases) as HighestInfections, Max(total_Cases/population)*100
AS percentpeopleinfected
FROM [CovidDeaths ]
--WHERE Location like '%kistan%'
WHERE continent IS NOT NULL
GROUP BY location, Population
ORDER BY percentpeopleinfected DESC


-- Countries with Highest Infection Rate compared to Population

SELECT Location,population,(new_cases/population)*100
AS percentageInfectedpopulation
FROM [CovidDeaths ]
--WHERE Location like '%kistan%'
WHERE Continent is not Null
GROUP BY LOCATION
ORDER BY 1,2

-- Countries with Highest Death Count per Population

SELECT Location,max(total_deaths) as Totaldeathcounts
FROM [CovidDeaths ]
--WHERE Location like '%kistan%'
WHERE continent IS NOT NULL
GROUP BY location, Population
ORDER BY Totaldeathcounts DESC

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT Continent, MAX(CONVERT(INT, total_deaths)) as Totaldeathcounts
FROM [CovidDeaths ]
--WHERE Location like '%kistan%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Totaldeathcounts DESC

-- GLOBAL NUMBERS

SELECT SUM(New_Cases) as TotalCases,SUM(New_Deaths)as TotalDeaths, (SUM(New_deaths)/SUM(New_cases))*100
AS DeathPercentage
FROM [CovidDeaths ]
--WHERE Location like '%kistan%'
WHERE continent IS NOT NULL

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT deaths.continent, deaths.Location, deaths.date, deaths.population, vacc.new_vaccinations,
SUM(VACC.new_vaccinations) OVER (partition by deaths.location Order by deaths.location,deaths.date) as RollingPeopleVaccinated

FROM [CovidDeaths ] deaths
JOIN CovidVaccinations vacc
ON Deaths.location = vacc.location AND deaths.date = Vacc.date
--where location like '%kistan%'
WHERE deaths.continent is not Null









