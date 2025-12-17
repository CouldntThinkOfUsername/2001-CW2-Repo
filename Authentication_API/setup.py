import pyodbc

server = 'dist-6-505.uopnet.plymouth.ac.uk'
database = 'COMP2001_JWoodacre'
username = 'JWoodacre'
password = 'SxnG691'
driver = '{ODBC Driver 17 for SQL Server}'

print("--- Testing Connection ---")

try:
    conn_str = (
        f'DRIVER={driver};'
        f'SERVER={server};'
        f'DATABASE={database};'
        f'UID={username};'
        f'PWD={password};'
        'Encrypt=Yes;'
        'TrustServerCertificate=Yes;'
    )
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()
    print("Connection Successful!")
    
    print("\n--- Testing Select on CW2.user_data ---")
    cursor.execute("SELECT TOP 5 * FROM CW2.user_data")
    rows = cursor.fetchall()
    
    if not rows:
        print("Connected, but table is empty.")
    for row in rows:
        print(row)
        
    conn.close()

except Exception as e:
    print("\nERROR:")
    print(e)