import psycopg2
import pandas as pd
 
def create_connection():
    conn_params = {
        "dbname": "StgProductSalesAnalyticsDB",
        "user": "postgres",
        "password": "Lungelo2001",
        "host": "localhost",
        "port": "5432"
    }
    try:
        conn = psycopg2.connect(**conn_params)
        print("Connected to the database successfully!")
        return conn
    except psycopg2.Error as e:
        print("Unable to connect to the database:", e)
        return None
 
def close_connection(conn):
    if conn:
        conn.close()
        print("Connection closed.")
 
def read_csv(file_path):
    try:
        df = pd.read_csv(file_path, delimiter=';')  # Adjust delimiter if necessary
        print("CSV File Content:\n", df.to_string(index=False))
        return df
    except Exception as e:
        print("An error occurred while reading the CSV file:", e)
        return None
 
def insert_data_to_db(conn, df, schema_name, table_name):
    try:
        with conn.cursor() as cur:
            # Create schema if it doesn't exist
            cur.execute(f"CREATE SCHEMA IF NOT EXISTS {schema_name};")
           
            # Create table if it doesn't exist
            create_table_query = f"""
            CREATE TABLE IF NOT EXISTS {schema_name}.{table_name} (
                {', '.join([f'{col} TEXT' for col in df.columns])}
            );
            """
            cur.execute(create_table_query)
            print(f"Table {schema_name}.{table_name} created or already exists.")
           
            # Insert data into the table
            for _, row in df.iterrows():
                insert_query = f"""
                INSERT INTO {schema_name}.{table_name} ({', '.join(df.columns)})
                VALUES ({', '.join(['%s'] * len(row))});
                """
                cur.execute(insert_query, tuple(row))
                print(f"Inserted row: {tuple(row)}")
               
            # Commit the transaction
            conn.commit()
            print("Data inserted into the database successfully!")
    except Exception as e:
        print("An error occurred while inserting data into the database:", e)
        conn.rollback()  # Roll back the transaction in case of error
 
if __name__ == "__main__":
    conn = create_connection()
    if conn:
        csv_file_path = 'C:\\Users\\LungeloNkambule\\Documents\\Projects\\Internship project\\McD Data\\data\\volumnBand.csv'
        df = read_csv(csv_file_path)
        if df is not None:
            insert_data_to_db(conn, df, 'StgSales', 'volumn_band_stg')
        close_connection(conn)