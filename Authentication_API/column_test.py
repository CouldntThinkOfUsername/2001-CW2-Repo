import pyodbc

server = 'dist-6-505.uopnet.plymouth.ac.uk'
database = 'COMP2001_JWoodacre'
username = 'JWoodacre'
password = 'SxnG691'
driver = '{ODBC Driver 17 for SQL Server}'

conn_str = (
    f'DRIVER={driver};'
    f'SERVER={server};'
    f'DATABASE={database};'
    f'UID={username};'
    f'PWD={password};'
    'Encrypt=Yes;'
    'TrustServerCertificate=Yes;'
)

try:
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()
    
    print(f"--- Columns in Table: CW2.user_data ---")
    
    query = """
    SELECT COLUMN_NAME 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'CW2' 
      AND TABLE_NAME = 'user_data'
    """
    
    cursor.execute(query)
    columns = cursor.fetchall()
    
    if not columns:
        print("No columns found! Does the table 'CW2.user_data' exist?")
    else:
        for col in columns:
            print(f" - {col[0]}")
            
    conn.close()

except Exception as e:
    print("Error connecting:", e)