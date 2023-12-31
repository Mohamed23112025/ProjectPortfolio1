select* 
from portfolioproject.dbo.COVIDDeath  
where continent is not null 

-- select date we are going to be use 

 select location,date , total_cases,new_cases, total_deaths,population 
 from portfolioproject..COVIDDeath
 where continent is not null
 order by 1,2 

 --looking at total cases vs total deaths 
 -- shows what percentage of deaths 
  select location,date , total_cases , total_deaths , (cast(total_deaths as int) /cast(total_cases as int))
 from portfolioproject..COVIDDeath
 where location like '%states%'
   order by 1,2 

  --looking at total cases vs population 
  --shows what percentage of population got Covid

    select location,date ,population , total_cases ,  (total_cases/population)*100 as gotCovidPercentage 
 from portfolioproject..COVIDDeath
where continent is not null
order by 1,2 

 --look at countries with highest infection rate compared to population 
     select location  ,population ,max( total_cases)as highestinfectioncount  , max  (total_cases/population)*100 as  GotCovidPercentage 
	from portfolioproject..COVIDDeath
	where continent is not null
	group by location  ,population
	order by   GotCovidPercentage desc

 --  let's break things down by continent 

      select continent, max(cast(total_deaths as int))as TotalDeathCount
	from portfolioproject..Coviddeath
	where continent is not null
	group by continent   
	order by  TotalDeathCount desc
	 
	 -- global numbers 
	 select  sum(new_cases) as totalcases ,sum(new_deaths) as totaldeaths, sum(new_deaths)/sum(new_cases)*100
	from portfolioproject..COVIDDeath
	where continent is not null 
	--group by date 
	order by 1,2
	
	-- looking at total population vs vaccinations
	select dea.continent, dea.location , dea.date, dea.population,vac.new_vaccinations
	,sum(cast(vac.new_vaccinations as int )) over (partition by dea.location order by dea.location , dea.date)
	from portfolioproject..COVIDDeath  dea
	join portfolioproject..[COVIDVaccination ] vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	and vac.new_vaccinations is not null 
	order by  2,3
