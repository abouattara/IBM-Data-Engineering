--- Create database sales
CREATE DATABASE sales;

--- Execute 
-- Bash code
-- wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0321EN-SkillsNetwork/ETL/sales.sql
-- mysql --host=172.21.137.132 --port=3306 --user=root --password=rPoxby1JHDi4WPAkF9cWioa0 -D sales > -f sales.sql
-- Checking if importation has successfully run in msql cli
use sales;
show tables;
--- Use python to connect and make query
-- Before starting with python excetution on terminal you need to run this code bellow
-- python3.11 -m pip install mysql-connector-python; 
-- grant your connection infos to python script and execute
-- pip3 install mysql-connector-python
-- python3 mysqlconnect.py
-- make sales.csv file readable
-- chmod u+x sales-csv3mo8i5SHvta76u7DzUfhiw.csv && ls -l sales-csv3mo8i5SHvta76u7DzUfhiw.csv
\COPY public."sales_data" FROM 'sales-csv3mo8i5SHvta76u7DzUfhiw.csv' DELIMITER ',' CSV HEADER;
how to "wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/sales-csv3mo8i5SHvta76u7DzUfhiw.csv to /var/lib/pgadmin/



