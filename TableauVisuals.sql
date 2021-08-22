-- Tableau
--1.

Select SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as totalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
From PortfolioProjects..CovidDeaths
--Where location like '%states
where continent is not null
--Group By date 
order by 1,2

--2.
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProjects..CovidDeaths
--Where location like '%states%'
Where continent is null and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--3. 
Select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentageofInfectedPopulation
From PortfolioProjects..CovidDeaths
--Where location like '%states%'
Group by location, population
order by PercentageofInfectedPopulation desc

--4.
Select location, population, date, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentageofInfectedPopulation
From PortfolioProjects..CovidDeaths
--Where location like '%states%'
Group by location, population, date
order by PercentageofInfectedPopulation desc

