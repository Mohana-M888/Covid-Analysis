
# COVID ANALYSIS

Analysing covid data from the year 2020 to 2021 using SQL, POWERBI

Power BI
Dashboard Link:https://app.powerbi.com/view?r=eyJrIjoiZmQ5ZmUxMDYtMTY5Yi00ZDczLWI3ZWMtOGRmOTdhMWY3ZDBkIiwidCI6IjM2MDA1NDJjLTNkYjktNDViMC04MWFlLTEwMWViYzg5ZmM3MCJ9

## Problem Statement

Given a dataset of daily reported COVID-19 cases across various regions, the goal is to perform a analysis to uncover key insights. 

### Steps followed 

- Step 1 : Load data into Power BI Desktop, dataset from SQL server.
- Step 2 : Open power query editor & in view tab under Data preview section, check "column distribution", "column quality" & "column profile" options.
- Step 3 : Also since by default, profile will be opened only for 1000 rows so you need to select "column profiling based on entire dataset".
- Step 4 : Replace the null value in the number data type columns to 0.
- Step 5 : Round off all the decimal digits to 2 decimal places.
- Step 6 : Rename the column names as per requirement.Close and Apply
- Step 7 : Since the data contains various ratings, thus in order to represent ratings, a new visual was added using the three ellipses in the visualizations pane in report view. 
- Step 8 : Showed all the data from the new metrics table in a table visual. (Global numbers of the covid data)
- Step 9 : Calculate 4 DAX columns for further visualization
Snap of DAX calculated columns:

Case fatality rate:
![DAX_1](https://github.com/user-attachments/assets/6b20d578-ffec-4c16-b4fd-ae32de8e0efc)

Infection rate:
![DAX_2](https://github.com/user-attachments/assets/d530ea53-d320-49cd-94b0-fe6de42a7986)

Recovery rate:
![DAX_3](https://github.com/user-attachments/assets/305d279e-a409-4250-9153-282b85e72c18)

Vaccination rate:
![DAX_4](https://github.com/user-attachments/assets/e3b41526-8188-4307-b98b-7b3d0c21cdfc)

- Step 10 : Added a slicer visual selecting all the continents. Thus enabling ti view continent wise covid analysis
- Step 11 : Added 4 card visuals to show total cases, deaths, hospitalizations and vaccinations
- Step 12 : Added a Line and clustered column chart to show Infection and case fatality rate of 10 most densely populated countries
- Step 13 : Added a tree map chart to show Human development index of 10 most densely populated countries
- Step 14 : Added a table chart to show GDP per capita and median age of 10 most densely populated countries
- Step 15 : Added two buttons that navigates to two different paged that shows the covid analysis on the basis of Human development Index anad case fatality rate respectively.
- Step 16 : For the HDI analysis filtered location on the basis of top 15 HDI and lowest 15 HDI, also showed total hospitalized patients and total vaccination all in a table visual
- Step 17 : Added card visuals to show vaccination and case fatality rate of the above 30 filtered locations.
![Filtered_Location](https://github.com/user-attachments/assets/35e0e037-7356-40a8-af84-c75b76ab8fd6)

![Filtered_Location_2](https://github.com/user-attachments/assets/f1bbbc29-ef0f-4c34-bc1c-3698a9d9c271)

- Step 18 : For the Case fatality rate analysis showed all the countries in a table visual that has its case fatality rate greater than the global number 2.11%, also sowed these countries' population density and HDI.

![Case_Fatality_rate_greater](https://github.com/user-attachments/assets/122788bb-9dbb-4564-b8e3-454d3905b672)

- Step 19 : Published the report into power BI service


