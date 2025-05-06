# COVIDAnalysisProject
# SQL Data Exploration Project: COVID-19 Dataset

This repository contains SQL scripts used to explore and analyze a COVID-19 dataset. The scripts perform data cleaning, transformation, and analysis to gain insights into the spread and impact of the virus, as well as vaccination efforts.

## Table of Contents
* [Data Sources](#data-sources)
* [Data Cleaning and Transformation](#data-cleaning-and-transformation)
* [Exploratory Data Analysis](#exploratory-data-analysis)
* [Key Findings (Example)](#key-findings-example)
* [Usage](#usage)

## Data Sources

The analysis is based on two tables:

* `CovidDeaths`: Contains information about COVID-19 deaths and cases by location and date.
* `CovidVaccinations`: Contains information about COVID-19 vaccinations by location and date.

Both datasets are assumed to be stored within a SQL Server database under the schema `Portfolio`.

## Data Cleaning and Transformation
* **Date Conversion:** Converts the `date` column in both tables from a `VARCHAR` data type to `DATE`, allowing for proper date-based analysis and filtering.
* **Data Type Correction:** Ensures that key numerical columns (`total_cases`, `total_deaths`, `population`, `new_cases`, `new_deaths`, `new_vaccinations`) have appropriate numerical data types (`float` for cases and deaths to handle potential fractional values, `BIGINT` for population to accommodate large numbers).

## Exploratory Data Analysis

The subsequent scripts perform various exploratory data analysis tasks:

* Examining the raw data from both tables.
* Calculating the death percentage relative to total cases.
* Analyzing the percentage of the population affected by COVID-19.
* Identifying countries with the highest infection rates.
* Determining the total death count by continent.
* Finding countries with the highest death count per population.
* Calculating global COVID-19 numbers over time.
* Analyzing the relationship between population and vaccinations using window functions, CTEs, and temporary tables.
* Creating a view to simplify the calculation of the percentage of the population vaccinated.

## Key Findings (only a fraction of possible findings, dataset is large)

* The death percentage varies significantly across different locations.
* Certain regions have a much higher percentage of their population infected.
* Continents show different total death counts.
* The percentage of the population vaccinated is increasing over time.

## Usage

1.  Ensure you have a SQL Server database set up and the `CovidDeaths` and `CovidVaccinations` tables are populated under the `Portfolio` schema.
2.  Run the data type conversion scripts included and refresh database
3.  Execute the subsequent SQL scripts in the desired order to explore different aspects of the dataset.
4.  Analyze the results of each query to gain insights into the COVID-19 pandemic.
5.  The `PercentagePopulationVaccinated` view can be used for simplified querying or integration with data visualization tools.
