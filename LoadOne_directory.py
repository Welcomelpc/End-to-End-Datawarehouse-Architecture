import os
import psycopg2
import pandas as pd
from db_connection import create_connection, close_connection  # Importing connection functions
 
def read_csv(file_path):
    try:
        df = pd.read_csv(file_path, delimiter=',')  # Assuming comma is the delimiter
        print(f"CSV File Content from {file_path}:\n", df.to_string(index=False))
        return df
    except Exception as e:
        df = pd.read_csv(file_path, delimiter='\t')
        #df = df.fillna('')
        #df = df.where(pd.notnull(df), None)
        df = df.applymap(lambda x: None
                 if pd.isna(x)
                 else x)
        print(f"An error occurred while reading the CSV file {file_path}: {e}")
        return None
 
def insert_data_to_db(conn, df, schema_name, table_name):
    try:
        with conn.cursor() as cur:
            schema_name = f'"{schema_name}"'
            table_name = f'"{table_name}"'
           
            # Check if the table already contains data
            cur.execute(f'SELECT COUNT(*) FROM {schema_name}.{table_name};')
            row_count = cur.fetchone()[0]
           
            if row_count > 0:
                print(f"Table {schema_name}.{table_name} already contains data. Skipping data insertion.")
                return
           
            # Insert data into the existing table
            columns = ', '.join([f'"{col}"' for col in df.columns])
            values = ', '.join(['%s'] * len(df.columns))
           
            insert_query = f"""
            INSERT INTO {schema_name}.{table_name} ({columns})
            VALUES ({values});
            """
           
            cur.executemany(insert_query, df.values.tolist())
            print(f"Data inserted into the {table_name} table successfully!")
           
            # Commit the transaction
            conn.commit()
           
    except psycopg2.Error as e:
        print(f"Database error while inserting data into the {table_name} table: {e}")
        conn.rollback()
    except Exception as e:
        print(f"An error occurred while inserting data into the {table_name} table: {e}")
        conn.rollback()
 
if __name__ == "__main__":
    conn = create_connection()
    if conn:
        csv_directory = r"C:\Users\LungeloNkambule\Documents\InternshipProject\2024 G2 Internship Technical Project\McD Data\data2\\"
         # Loop through all CSV files in the directory
        for file_name in os.listdir(csv_directory):
            if file_name.endswith(".csv"):
                # Derive the table name from the file name (without extension)
                table_name = file_name.replace('.csv', '_stg').lower()
                csv_file_path = os.path.join(csv_directory, file_name)
               
                df = read_csv(csv_file_path)
                if df is not None:
                    insert_data_to_db(conn, df, 'StgSales', table_name)
       
        close_connection(conn)