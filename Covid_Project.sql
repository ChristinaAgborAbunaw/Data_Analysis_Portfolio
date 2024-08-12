-- Retrieve all columns from the CovidDeaths table, ordered by the 3rd and 4th columns 
SELECT *
    FROM Portfolio_Project..CovidDeaths
	WHERE continent IS NOT NULL
    ORDER BY 3, 4;


Retrieve all columns from the CovidVaccinations table, ordered by the 3rd and 4th columns
 SELECT *
     FROM Portfolio_Project..CovidVaccinations
	 WHERE continent IS NOT NULL
     ORDER BY 3, 4;


-- Retrieve specific columns (location, date, total_cases, new_cases, total_deaths, population)
	--from the CovidDeaths table
SELECT location, date, total_cases, new_cases, total_deaths, population
    FROM Portfolio_Project..CovidDeaths
	WHERE continent IS NOT NULL;


-- Question: What are the total cases and total deaths in Cameroon?
SELECT location, 
       FORMAT(CAST(date AS date), 'dd-MM-yyyy') AS DATES,  
       total_cases, 
       total_deaths 
	FROM Portfolio_Project..CovidDeaths 
	WHERE location = 'Cameroon' 
	ORDER BY total_deaths DESC;



-- Question: How many new COVID-19 cases were reported in Cameroon on or after January 8, 2020?
SELECT location, date, new_cases 
	FROM Portfolio_Project..CovidDeaths  
	WHERE location = 'Cameroon' AND date >= '2020-01-08';


-- Question: What is the total number of new COVID-19 cases reported in each location?
SELECT location, SUM(new_cases) AS total_new_cases 
	FROM Portfolio_Project..CovidDeaths  
	WHERE continent IS NOT NULL
	GROUP BY location;

-- Comparing Total Cases vs. Deaths
-- Calculate the death percentage by dividing total_deaths by total_cases and multiplying by 100
SELECT location, date, population, total_cases, total_deaths, 
       ROUND((total_deaths / total_cases) * 100, 1 )AS DeathPercentage
    FROM Portfolio_Project..CovidDeaths
		WHERE total_cases > 0 AND total_deaths >0 AND  continent IS NOT NULL
    ORDER BY location, date;

-- Question: Which countries have the highest infection rates relative
	-- to their population, and what is their corresponding death percentage?

SELECT location, 
       MAX(date) AS LatestDate,
       FORMAT(population,'N0') AS InfectedPop, 
       MAX(total_cases) AS HighestInfectionCounts,
       ROUND((MAX(total_cases) / population) * 100, 2) AS InfectionRatePercentage,
       ROUND((MAX(total_deaths) / MAX(total_cases)) * 100, 2) AS DeathPercentage
	FROM Portfolio_Project..CovidDeaths
	WHERE total_cases > 0 AND total_deaths > 0 AND continent IS NOT NULL
	GROUP BY location, population
	ORDER BY InfectionRatePercentage DESC;


-- Question: Which location has the highest number of total COVID-19 cases?
SELECT TOP 1 continent,
			FORMAT(MAX(CAST(total_cases AS INT)),'N0') AS CASES
	FROM Portfolio_Project..CovidDeaths 
	WHERE continent IS NOT NULL 
	GROUP BY continent
	ORDER BY CASES DESC;
	

-- Question: What are the total COVID-19 cases and the number of new tests conducted
	--on the same date in Cameroon?
SELECT a.location, a.date, a.total_cases, b.new_tests 
	FROM Portfolio_Project..CovidDeaths a 
	JOIN Portfolio_Project..CovidVaccinations b 
	ON a.location = b.location AND a.date = b.date;


-- Question: What is the cumulative number of new COVID-19 cases over time in Cameroon?
SELECT location, date, SUM(new_cases) OVER (PARTITION BY location ORDER BY date) AS cumulative_cases 
	FROM Portfolio_Project..CovidDeaths 
	WHERE location = 'Cameroon';

-- Question: How can the date format be standardized in the dataset for Cameroon?
SELECT location, CAST(date AS DATE) AS formatted_date 
FROM Portfolio_Project..CovidDeaths  
WHERE location = 'Cameroon';


-- Question: How can we ensure that missing values in the `new_cases`
	--column are replaced with zero for Cameroon?
SELECT location, COALESCE(new_cases, 0) AS cases 
	FROM Portfolio_Project..CovidDeaths   
	WHERE location = 'Cameroon';


