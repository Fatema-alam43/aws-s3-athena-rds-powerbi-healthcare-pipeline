import pandas as pd

df = pd.read_csv('clean_data.csv')
df.to_parquet('clean_data.parquet', index=False)
print("Converted to Parquet.")