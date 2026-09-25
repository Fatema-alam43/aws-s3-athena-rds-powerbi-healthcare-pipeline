import pandas as pd
import os
from sqlalchemy import create_engine

# Load your cleaned data
df = pd.read_csv('clean_data.csv')

# Connect to RDS
host = "healthcare-db.c7msuyoagzae.us-east-2.rds.amazonaws.com"
port = 5432
username = "postgres"
password = os.environ.get("RDS_PASSWORD", "")
if not password:
    raise ValueError("RDS_PASSWORD environment variable is not set. Run: export RDS_PASSWORD='your_password'")
database = "postgres"

engine = create_engine(f'postgresql://{username}:{password}@{host}:{port}/{database}')

# Load the dataframe into a table called stroke_data
df.to_sql('stroke_data', engine, if_exists='replace', index=False)

print("Data loaded successfully into RDS.")