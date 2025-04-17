import mysql.connector
import psycopg2

# Connect to MySQL
mysql_conn = mysql.connector.connect(
    user='root', host='172.21.137.132', password='rPoxby1JHDi4WPAkF9cWioa0', database='sales'
)
mysql_cursor = mysql_conn.cursor()

# Connect to PostgreSQL
dsn_hostname = '172.21.51.50'
dsn_user = 'postgres'
dsn_pwd = 'rWB7QvlPBKHOMVa8Gg9lJwod'
dsn_port = '5432'
dsn_database = 'postgres'

pg_conn = psycopg2.connect(
    database=dsn_database, 
    user=dsn_user,
    password=dsn_pwd,
    host=dsn_hostname, 
    port=dsn_port
)
pg_cursor = pg_conn.cursor()

# Find out the last rowid from DB2 data warehouse or PostgreSql data warehouse
# The function get_last_rowid must return the last rowid of the table sales_data on the IBM DB2 database or PostgreSql.

def get_last_rowid():
    """Retrieve the last row ID from PostgreSQL."""
    query = """
    SELECT COALESCE(MAX(rowid), 0) FROM sales_data;
    """
    pg_cursor.execute(query)
    last_rowid = pg_cursor.fetchone()[0]
    return last_rowid

last_row_id = get_last_rowid()
print("Last row id on production datawarehouse = ", last_row_id)

# List out all records in MySQL database with rowid greater than the one on the Data warehouse
# The function get_latest_records must return a list of all records that have a rowid greater than the last_row_id in the sales_data table in the sales database on the MySQL staging data warehouse.

def get_latest_records(rowid):
    """Retrieve all records from MySQL where rowid is greater than the last row ID."""
    query = """
    SELECT * FROM sales_data WHERE rowid > %s;
    """
    mysql_cursor.execute(query, (rowid,))
    return mysql_cursor.fetchall()
	

new_records = get_latest_records(last_row_id)
print("New rows on staging datawarehouse = ", len(new_records))

# Insert the additional records from MySQL into DB2 or PostgreSql data warehouse.
# The function insert_records must insert all the records passed to it into the sales_data table in IBM DB2 database or PostgreSql.

def insert_records(records):
    """Insert new records into PostgreSQL."""
    if not records:
        return
    
    query = """
    INSERT INTO 
    sales_data (rowid, product_id, customer_id, quantity) 
    VALUES (%s, %s, %s, %s);
    """  # Adjust columns based on your table structure
    pg_cursor.executemany(query, records)
    pg_conn.commit()

insert_records(new_records)
print("New rows inserted into production datawarehouse = ", len(new_records))

mysql_cursor.close()
mysql_conn.close()
pg_cursor.close()
pg_conn.close()

print("Data synchronization completed successfully.")

# End of program