# Data Profiling Report — Stroke Prediction Dataset

- 5110 rows, 12 columns, no duplicate rows
- `bmi` had 201 missing values (~4%) — filled with median (28.1) to preserve sample size
- `gender` has one row labeled "Other" alongside Male/Female — kept as-is, noted as a single outlier
- `smoking_status` has 1544 "Unknown" values (~30%) — not a null, but represents missing information; kept as its own category rather than imputed, since guessing smoking status would be misleading