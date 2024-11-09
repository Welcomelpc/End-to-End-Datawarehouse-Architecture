import psycopg2
import pandas as pd
from db_connection import create_connection, close_connection  # Import connection functions

def read_csv(file_path, delimiter=','):
    try:
        df = pd.read_csv(file_path, delimiter=delimiter, skipinitialspace=True)
        print(f"CSV File Content from {file_path}:\n", df.to_string(index=False))
        return df
    except Exception as e:
        print("An error occurred while reading the CSV file:", e)
        return None

def insert_data_to_db(conn, df, schema_name, table_name):
    try:
        with conn.cursor() as cur:
            # Create schema if it doesn't exist
            cur.execute(f'CREATE SCHEMA IF NOT EXISTS "{schema_name}";')
            
            # Create table if it doesn't exist (all columns as TEXT for simplicity)
            create_table_query = f"""
            CREATE TABLE IF NOT EXISTS "{schema_name}"."{table_name}" (
                {', '.join([f'"{col}" TEXT' for col in df.columns])}
            );
            """
            cur.execute(create_table_query)
            print(f'Table "{schema_name}"."{table_name}" created or already exists.')
            
            # Check if the table already contains data
            cur.execute(f'SELECT COUNT(*) FROM "{schema_name}"."{table_name}";')
            row_count = cur.fetchone()[0]
            
            if row_count > 0:
                print(f"Table {schema_name}.{table_name} already contains data. Skipping data insertion.")
                return
            
            # Insert data into the table
            insert_query = f"""
            INSERT INTO "{schema_name}"."{table_name}" ({', '.join([f'"{col}"' for col in df.columns])})
            VALUES ({', '.join(['%s'] * len(df.columns))});
            """
            cur.executemany(insert_query, df.values.tolist())
            print(f"All rows inserted into {table_name}.")
            
            # Commit the transaction
            conn.commit()
            print(f"Data inserted into the {table_name} table successfully!")
    except Exception as e:
        print(f"An error occurred while inserting data into the {table_name} table:", e)
        conn.rollback()  # Roll back the transaction in case of error

if __name__ == "__main__":
    conn = create_connection()
    if conn:
        # Insert data into the "product_category_stg" table
        product_category_csv_path = "C:\\Users\\LungeloNkambule\\Documents\\InternshipProject\\2024 G2 Internship Technical Project\\McD Data\\data\\ProductCategory.csv"
        product_category_df = read_csv(product_category_csv_path)
        if product_category_df is not None:
            insert_data_to_db(conn, product_category_df, 'StgSales', 'product_category_stg')
        
        # Insert data into the "product_group_level_1_stg" table
        product_group_level_1_csv_path = "C:\\Users\\LungeloNkambule\\Documents\\InternshipProject\\2024 G2 Internship Technical Project\\McD Data\\data\\ProductGroupLevel1.csv"
        product_group_level_1_df = read_csv(product_group_level_1_csv_path)
        if product_group_level_1_df is not None:
            insert_data_to_db(conn, product_group_level_1_df, 'StgSales', 'product_group_level_1_stg')

        # Insert data into the "product_group_level_2_stg" table
        product_group_level_2_csv_path = "C:\\Users\\LungeloNkambule\\Documents\\InternshipProject\\2024 G2 Internship Technical Project\\McD Data\\data\\ProductGroupLevel2.csv"
        product_group_level_2_df = read_csv(product_group_level_2_csv_path)
        if product_group_level_2_df is not None:
            insert_data_to_db(conn, product_group_level_2_df, 'StgSales', 'product_group_level_2_stg')

        # Insert data into the "product_group_level_3_stg" table
        product_group_level_3_csv_path = "C:\\Users\\LungeloNkambule\\Documents\\InternshipProject\\2024 G2 Internship Technical Project\\McD Data\\data\\ProductGroupLevel3.csv"
        product_group_level_3_df = read_csv(product_group_level_3_csv_path)
        if product_group_level_3_df is not None:
            insert_data_to_db(conn, product_group_level_3_df, 'StgSales', 'product_group_level_3_stg')

        # Insert data into the "product_group_level_4_stg" table
        day_date_csv_path = "C:\\Users\\LungeloNkambule\\Documents\\InternshipProject\\2024 G2 Internship Technical Project\\McD Data\\data\\VolummBand.csv"
        day_date_df = read_csv(day_date_csv_path)
        if day_date_df is not None:
            insert_data_to_db(conn, day_date_df, 'StgSales', 'daydate_stg')
        
        close_connection(conn)
