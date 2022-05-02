Select location,date,total_cases,new_cases,population,total_deaths
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

Select location,date,total_cases,population,(total_cases/population)*100 as Gotcovid
From PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2

Select location,population,MAX(total_cases) as HighesInfectionCount,MAX((total_cases/population))*100 as Infectedpopulation
From PortfolioProject..CovidDeaths
--where location like '%india%'
group by location,population
order by Infectedpopulation desc

Select continent,MAX(cast(total_deaths as int)) as totalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%india%'
where continent is not null
group by continent
order by totalDeathCount desc

Select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) as deathpercent --,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
From PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2

with popvsvac (continent,location,date,population,New_vaccinations,RollingPeopleVaccinated)
as (
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.Location,dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--and dea.location like '%india%'
)

--order by 2,3
Select *,(RollingPeopleVaccinated/population)*100 as VacpeopleRatio
From popvsvac

DROP Table if exists #percentpopulationvaccinated
Create Table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccination numeric,
Rollingpeoplevaccinated  numeric
)
Insert into #percentpopulationvaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.Location,dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--and dea.location like '%india%'
Select *,(RollingPeopleVaccinated/population)*100 as VacpeopleRatio
From #percentpopulationvaccinated


Create View percentpopuVac as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.Location,dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null

Select * 
From percentpopuVac