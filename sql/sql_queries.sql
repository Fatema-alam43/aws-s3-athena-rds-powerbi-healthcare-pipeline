-- Query 1: Stroke Rate by Age Band
SELECT
  CASE
    WHEN age < 30 THEN 'Under 30'
    WHEN age < 50 THEN '30-49'
    WHEN age < 70 THEN '50-69'
    ELSE '70+'
  END AS age_band,
  COUNT(*) AS total_patients,
  SUM(stroke) AS stroke_count,
  ROUND(CAST(100.0 * SUM(stroke) / COUNT(*) AS numeric), 2) AS stroke_rate_pct
FROM stroke_data
GROUP BY age_band
ORDER BY age_band;


-- Query 2: Stroke Rate by Smoking Status
SELECT smoking_status, COUNT(*) AS total, SUM(stroke) AS strokes,
       ROUND(CAST(100.0 * SUM(stroke) / COUNT(*) AS numeric), 2) AS stroke_rate_pct
FROM stroke_data
GROUP BY smoking_status
ORDER BY stroke_rate_pct DESC;


-- Query 3: Stroke Rate by Hypertension and Heart Disease
SELECT hypertension, heart_disease, COUNT(*) AS total, SUM(stroke) AS strokes,
       ROUND(CAST(100.0 * SUM(stroke) / COUNT(*) AS numeric), 2) AS stroke_rate_pct
FROM stroke_data
GROUP BY hypertension, heart_disease
ORDER BY stroke_rate_pct DESC;


-- Query 4: Average Glucose and BMI, Stroke vs No Stroke
SELECT stroke,
       ROUND(CAST(AVG(avg_glucose_level) AS numeric), 2) AS avg_glucose,
       ROUND(CAST(AVG(bmi) AS numeric), 2) AS avg_bmi
FROM stroke_data
GROUP BY stroke;


-- Query 5: Stroke Rate by Work Type
SELECT work_type, COUNT(*) AS total, SUM(stroke) AS strokes,
       ROUND(CAST(100.0 * SUM(stroke) / COUNT(*) AS numeric), 2) AS stroke_rate_pct
FROM stroke_data
GROUP BY work_type
ORDER BY stroke_rate_pct DESC;


-- Query 6: Patient-Level Risk Factors (raw, for Power BI Key Influencers / Decomposition Tree)
SELECT
  age,
  hypertension,
  heart_disease,
  CASE WHEN avg_glucose_level >= 126 THEN 1 ELSE 0 END AS high_glucose,
  CASE WHEN bmi >= 30 THEN 1 ELSE 0 END AS obese,
  stroke
FROM stroke_data;


-- Query 7: Stroke Rate by Single-Year Age (for a smooth line chart)
SELECT
  CAST(age AS INT) AS age_year,
  COUNT(*) AS total_patients,
  SUM(stroke) AS stroke_count,
  ROUND(CAST(100.0 * SUM(stroke) / COUNT(*) AS numeric), 2) AS stroke_rate_pct
FROM stroke_data
GROUP BY CAST(age AS INT)
ORDER BY age_year;


-- Query 8: Stroke Rate by BMI Category (for a treemap)
SELECT
  CASE
    WHEN bmi < 18.5 THEN 'Underweight'
    WHEN bmi < 25 THEN 'Normal'
    WHEN bmi < 30 THEN 'Overweight'
    ELSE 'Obese'
  END AS bmi_category,
  COUNT(*) AS total_patients,
  SUM(stroke) AS stroke_count,
  ROUND(CAST(100.0 * SUM(stroke) / COUNT(*) AS numeric), 2) AS stroke_rate_pct
FROM stroke_data
GROUP BY bmi_category;


-- Query 9: Stroke Rate by Glucose Category (for a treemap)
SELECT
  CASE
    WHEN avg_glucose_level < 100 THEN 'Normal'
    WHEN avg_glucose_level < 126 THEN 'Prediabetic'
    ELSE 'Diabetic'
  END AS glucose_category,
  COUNT(*) AS total_patients,
  SUM(stroke) AS stroke_count,
  ROUND(CAST(100.0 * SUM(stroke) / COUNT(*) AS numeric), 2) AS stroke_rate_pct
FROM stroke_data
GROUP BY glucose_category;


-- Query 10: Stroke Rate by Gender and Age Band (for a heatmap matrix)
SELECT
  gender,
  CASE
    WHEN age < 30 THEN 'Under 30'
    WHEN age < 50 THEN '30-49'
    WHEN age < 70 THEN '50-69'
    ELSE '70+'
  END AS age_band,
  COUNT(*) AS total_patients,
  ROUND(CAST(100.0 * SUM(stroke) / COUNT(*) AS numeric), 2) AS stroke_rate_pct
FROM stroke_data
GROUP BY gender, age_band
ORDER BY age_band, gender;


-- Query 11: High-Risk Population Funnel
SELECT 'All Patients' AS stage, COUNT(*) AS patient_count FROM stroke_data
UNION ALL
SELECT 'Age 50+', COUNT(*) FROM stroke_data WHERE age >= 50
UNION ALL
SELECT 'Age 50+ with Hypertension or Heart Disease', COUNT(*) FROM stroke_data WHERE age >= 50 AND (hypertension = 1 OR heart_disease = 1)
UNION ALL
SELECT 'Age 50+, Hypertension/Heart Disease, High Glucose', COUNT(*) FROM stroke_data WHERE age >= 50 AND (hypertension = 1 OR heart_disease = 1) AND avg_glucose_level >= 126;


-- Query 12: Top-Line KPI Summary
SELECT
  COUNT(*) AS total_patients,
  SUM(stroke) AS total_stroke_cases,
  ROUND(CAST(100.0 * SUM(stroke) / COUNT(*) AS numeric), 2) AS overall_stroke_rate_pct,
  ROUND(CAST(AVG(age) AS numeric), 1) AS avg_age,
  ROUND(CAST(AVG(CASE WHEN stroke = 1 THEN age END) AS numeric), 1) AS avg_age_stroke_patients
FROM stroke_data;