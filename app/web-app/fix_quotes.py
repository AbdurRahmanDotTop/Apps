import sys

with open(r'c:\Users\abdur\OneDrive\Desktop\Abdurrahman\Abdurrahman_Developer\Techily_Fly\Techily_Fly_Apps\app\web-app\d1_import.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

# Replace MySQL \' with SQLite ''
sql = sql.replace("\\'", "''")

with open(r'c:\Users\abdur\OneDrive\Desktop\Abdurrahman\Abdurrahman_Developer\Techily_Fly\Techily_Fly_Apps\app\web-app\d1_import_fixed.sql', 'w', encoding='utf-8') as f:
    f.write(sql)
