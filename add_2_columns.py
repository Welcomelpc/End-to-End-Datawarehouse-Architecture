import psycopg2  # establish the connection from PostgreSQL
import pandas as pd  # read the CSV file
from db_connection import create_connection, close_connection  # Importing connection functions
from datetime import datetime
 
def read_csv(file_path):
    try:
        # Adjusting the delimiter to tab
        df = pd.read_csv(file_path, delimiter='\t')
        print("CSV File Content:\n", df.to_string(index=False))
        return df
    except Exception as e:
        print("An error occurred while reading the CSV file:", e)
        return None
 
def create_columns(conn, schema_name, table_name):
    try:
        with conn.cursor() as cur:
            # Quoting schema and table names to handle case sensitivity
            schema_name = f'"{schema_name}"'
            table_name = f'"{table_name}"'
           
            # Adding batchID column as SERIAL
            cur.execute(f'ALTER TABLE {schema_name}.{table_name} ADD COLUMN "batchID" SERIAL;')
            print("Added 'batchID' column.")
           
            # Adding loadingTime column as TIMESTAMP
            cur.execute(f'ALTER TABLE {schema_name}.{table_name} ADD COLUMN "loadingTime" TIMESTAMP;')
            print("Added 'loadingTime' column.")
           
            # Commit the changes
            conn.commit()
    except Exception as e:
        print("An error occurred while creating columns:", e)
        conn.rollback()
 
def insert_data_to_db(conn, df, schema_name, table_name):
    try:
        with conn.cursor() as cur:
            # Ensure the columns exist by creating them
            create_columns(conn, schema_name, table_name)
           
            # Quoting schema and table names to handle case sensitivity
            schema_name = f'"{schema_name}"'
            table_name = f'"{table_name}"'
           
            # Prepare the loading time
            loading_time = datetime.now()
 
            # Insert data into the existing table with batchID and loadingTime after the existing columns
            for _, row in df.iterrows():
                insert_query = f"""
                INSERT INTO {schema_name}.{table_name}
                ({', '.join([f'"{col}"' for col in df.columns])}, "batchID", "loadingTime")
                VALUES ({', '.join(['%s'] * len(row))}, nextval(pg_get_serial_sequence('{schema_name}.{table_name}', 'batchID')), %s);
                """
                cur.execute(insert_query, (*tuple(row), loading_time))
           
            # Commit the transaction
            conn.commit()
            print("Data inserted into the database successfully!")
    except Exception as e:
        print("An error occurred while inserting data into the database:", e)
        conn.rollback()  # Roll back the transaction in case of error
 
if __name__ == "__main__":
    conn = create_connection()
    if conn:
        temp = "C:\\Users\\LungeloNkambule\\Documents\\InternshipProject\\2024 G2 Internship Technical Project\\McD Data\\data2\\Franchisee.csv"
        csv_file_path = temp
        df = read_csv(csv_file_path)
        if df is not None:
            insert_data_to_db(conn, df, 'StgSales', 'franchisee_stg')
        close_connection(conn)