--TEMP TABLE

DROP Table if exists #PercentageVaccinatedPopulation
Create Table #PercentageVaccinatedPopulation
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaxxed numeric
)

Insert into #PercentageVaccinatedPopulation
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaxxed
--, (RollingPeopleVaxxed/population) 
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaxxed/Population)*100 as PercentageofVaxxedPopulation
From #PercentageVaccinatedPopulation




Select *
From PortfolioProjects..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProjects..CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjects..CovidDeaths
order by 1,2

-- Total Cases vs Total Deaths
-- Shows how likely you are to die from Covid19 in the US
Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjects..CovidDeaths
Where location like '%states%'
order by 1,2

-- Total Cases Vs Population
-- Shows the percentage of people that contracted Covid19 in the US
Select location, date, population,total_cases, (total_cases/population)*100 as InfectedPopulationPercentage
From PortfolioProjects..CovidDeaths
Where location like '%states%'
order by 1,2

-- Looking at countries with highest infection rate compared to population

Select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as InfectedPopulationPercentage
From PortfolioProjects..CovidDeaths
--Where location like '%states%'
Group by location, population
order by InfectedPopulationPercentage desc

-- Looking at countries with highet death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProjects..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
order by TotalDeathCount desc

--Highest death count per population by continent 

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProjects..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- WORLD NUMBERS

Select SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as totalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
From PortfolioProjects..CovidDeaths
--Where location like '%states
where continent is not null
--Group By date 
order by 1,2


-- Total Population vs Vax
Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations
, SUM(CONVERT(bigint,vax.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaxxed
--, (RollingPeopleVaxxed/population) 
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vax
	On dea.location = vax.location
	and dea.date = vax.date
where dea.continent is not null
order by 2,3

--CTE
With PopvsVax (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaxxed)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations
, SUM(CONVERT(bigint,vax.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaxxed
--, (RollingPeopleVaxxed/population) 
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vax
	On dea.location = vax.location
	and dea.date = vax.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaxxed/Population)*100 as PercentageofVaxxedPopulation
From PopvsVax

--Data For Visulizations

Create View PercentofVaxxedPopulation as 
Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations
, SUM(CONVERT(bigint,vax.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaxxed
--, (RollingPeopleVaxxed/population) 
From PortfolioProjects..CovidDeaths dea
Join PortfolioProjects..CovidVaccinations vax
	On dea.location = vax.location
	and dea.date = vax.date
where dea.continent is not null
--order by 2,3

Create View TotalDeath as 
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProjects..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
--order by TotalDeathCount desc