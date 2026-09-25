import pandas as pd
import boto3

# Download the raw file from S3
s3 = boto3.client('s3')
s3.download_file('fatema43-healthcare-raw', 'healthcare-dataset-stroke-data.csv', 'local_data.csv')

# Load it into a dataframe
df = pd.read_csv('local_data.csv')

# Profile the data first 
print(df.info())
print(df.isnull().sum())
print(df.describe())

print(df['gender'].value_counts())
print(df['smoking_status'].value_counts())

# Fill missing bmi with the median (robust to outliers, unlike the mean)
df['bmi'] = df['bmi'].fillna(df['bmi'].median())

# Check for exact duplicate rows
print("Duplicate rows:", df.duplicated().sum())
df = df.drop_duplicates()

# Confirm the fix worked
print(df.isnull().sum())

# Save cleaned data locally
df.to_csv('clean_data.csv', index=False)

print("Cleaning complete. Final shape:", df.shape)