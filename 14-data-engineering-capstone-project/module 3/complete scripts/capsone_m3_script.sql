-- Create the table

---------------------------------------
CREATE TABLE public."DimDate"
(
    dateid integer NOT NULL,
    date date,
    Year integer,
    Quarter integer,
    QuarterName character(50),
    Month integer,
    Monthname character(50),
    Day integer,
    Weekday integer,
    WeekdayName character(50),
    CONSTRAINT "DimDate_pkey" PRIMARY KEY (dateid)
);

-------------------------------------------------------

CREATE TABLE public."DimCategory"
(
    categoryid integer NOT NULL,
    category character(50),
    CONSTRAINT "DimCategory_pkey" PRIMARY KEY (categoryid)
);

-------------------------------------------------------

CREATE TABLE public."DimCountry"
(
    countryid integer NOT NULL,
    country character(50),
    CONSTRAINT "DimCountry_pkey" PRIMARY KEY (countryid)
);

-----------------------------------------------------------

CREATE TABLE public."FactSales"
(
    orderid integer NOT NULL,
    dateid integer,
    countryid integer,
    categoryid integer,
    amount integer,
    CONSTRAINT "FactSales_pkey" PRIMARY KEY (orderid)
);

--- Import data from csv file

-- wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0321EN-SkillsNetwork/datawarehousing/DimCategory.csv
-- wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0321EN-SkillsNetwork/datawarehousing/DimCountry.csv
-- wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0321EN-SkillsNetwork/datawarehousing/DimDate.csv
-- wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0321EN-SkillsNetwork/datawarehousing/FactSales.csv

\copy public."DimDate" FROM 'DimDate.csv' DELIMITER ',' CSV HEADER;
\copy public."DimCategory" FROM 'DimCategory.csv' DELIMITER ',' CSV HEADER;
\copy public."DimCountry" FROM 'DimCountry.csv' DELIMITER ',' CSV HEADER;
\copy public."FactSales" FROM 'FactSales.csv' DELIMITER ',' CSV HEADER;

--- Make querry in all of theses databases

SELECT * FROM public."DimDate" LIMIT 5;
SELECT * FROM public."DimCategory" LIMIT 5;
SELECT * FROM public."DimCountry" LIMIT 5;
SELECT * FROM public."FactSales" LIMIT 5;

--- Make query with grouping sets
-- Create a grouping sets query using the columns country, category, totalsales.
SELECT country, category, sum(amount) AS TotalSales 
FROM public."FactSales" sa, public."DimCategory" ca, public."DimCountry" co
WHERE sa.categoryid = ca.categoryid and  sa.countryid = co.countryid
GROUP BY GROUPING SETS(country, category,());

-- Create a rollup query using the columns year, country, and totalsales.
SELECT year, country, sum(amount) AS TotalSales 
FROM public."FactSales" sa, public."DimDate" da, public."DimCountry" co
WHERE sa.dateid = da.dateid and  sa.countryid = co.countryid
GROUP BY rollup(year, country);

-- Create a cube query using the columns year, country, and average sales.
SELECT year, country, avg(amount) AS AverageSales 
FROM public."FactSales" sa, public."DimDate" da, public."DimCountry" co
WHERE sa.dateid = da.dateid and  sa.countryid = co.countryid
GROUP BY CUBE(year, country);

-- Create an MQT named total_sales_per_country that has the columns country and total_sales.
CREATE MATERIALIZED VIEW IF NOT EXISTS total_sales_per_country
    AS SELECT country, sum(amount) AS total_sales
    FROM public."FactSales" sa, public."DimCountry" co
    WHERE sa.countryid = co.countryid
    GROUP BY country;