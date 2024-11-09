#THIS CODE truncate_all_tables AT THE VERY SAME TIME

import psycopg2
from db_connection import create_connection, close_connection  # Importting connection functions
 
def truncate_all_tables(conn, schema_name):
    try:
        with conn.cursor() as cur:
            # Retrieving all table names in the specified schema
            cur.execute(f"""
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = %s AND table_type = 'BASE TABLE';
            """, (schema_name,))
            tables = cur.fetchall()
            if not tables:
                print(f"No tables found in schema '{schema_name}'.")
                return
            # Generating TRUNCATE statements for all tables
            truncate_statements = [f'TRUNCATE TABLE "{schema_name}"."{table[0]}" CASCADE;' for table in tables]
            # Executing the TRUNCATE statements
            for stmt in truncate_statements:
                cur.execute(stmt)
                print(f"Truncated table: {stmt}")
 
            # Committing the transaction
            conn.commit()
            print(f"All tables in schema '{schema_name}' have been truncated successfully!")
    except Exception as e:
        print(f"An error occurred while truncating tables: {e}")
        conn.rollback()  # Rolling back the transaction in case of error
 
if __name__ == "__main__":
    conn = create_connection()
    if conn:
        schema_name = 'StgSales' 
        truncate_all_tables(conn, schema_name)
        close_connection(conn)