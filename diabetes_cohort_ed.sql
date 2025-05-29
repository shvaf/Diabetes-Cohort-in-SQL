/*
Goal:
Find patients whose first diagnosis of diabetes occurred 
before age 40, and who had an ED (Emergency Department) 
visit within 6 months of that diagnosis.
*/

-- Step 0: Load tables
SELECT * FROM encounters;
SELECT * FROM patients;
SELECT * FROM conditions;
 
-- Step 1: Build a dataset of diabetes diagnoses
/*
In this step, I am creating a list of the conditions
that contain the word diabetes. The distinct descriptions
are: "Diabetes mellitus type 2 (disorder)"
"Disorder of kidney due to diabetes mellitus (disorder)"
"Microalbuminuria due to type 2 diabetes mellitus (disorder)"
"Neuropathy due to type 2 diabetes mellitus (disorder)"
"Nonproliferative retinopathy due to type 2 diabetes mellitus (disorder)"
"Prediabetes (finding)"
"Proteinuria due to type 2 diabetes mellitus (disorder)"
"Retinopathy due to type 2 diabetes mellitus (disorder)"

Since Prediabetes is not diabetes, I am going to remove 
that value from this list.
*/
WITH diabetes_conditions AS (
	SELECT *
	FROM conditions
	WHERE LOWER(description) LIKE '%diabetes%' AND LOWER(description) NOT LIKE '%prediabetes%'
),

-- Step 2: First Diabetes Diagnosis per Patient
/*
In the code below, I am creating a table that includes each patient with diabetes and 
the first record of their diabetes diagnosis. 
*/
first_diabetes AS(
	SELECT
		patient,
		start AS diabetes_start_date
	FROM(
		SELECT 
			patient,
			start,
			ROW_NUMBER() OVER (PARTITION BY patient ORDER BY start) AS rn
		FROM diabetes_conditions
	) sub
	WHERE rn = 1	
),


-- Step 3: Add Age at Diagnosis
diabetes_with_age AS(
	SELECT
		f.patient,
		f.diabetes_start_date,
		p.birthdate,
		DATE_PART('year', AGE(f.diabetes_start_date::DATE, p.birthdate::DATE)) AS age_at_diagnosis
	FROM 
		first_diabetes f
	JOIN 
		patients p ON f.patient = p.id
),


-- Step 4: Filter for Age < 40
diabetes_under_40 AS(
	SELECT *
	FROM diabetes_with_age
	WHERE age_at_diagnosis < 40
),

-- Step 5: Find ED Visits Within 2 Years of Diagnosis
/*
The distinct encounterclass's are: 
"hospice"
"ambulatory"
"virtual"
"outpatient"
"emergency"
"urgentcare"
"wellness"
"snf"
"inpatient"
"home"

For this analysis, I am only considering the emergency encounterclass
*/

ed_visits AS(
	SELECT 
		e.id AS encounter_id,
		e.patient,
		e.start AS encounter_start
	FROM encounters e
	WHERE LOWER(e.encounterclass) = 'emergency'
)

-- Step 6: Create the Final Table that includes
/*
	- Patients under 40 with Diabetes
	- Patient who have an Emergency Room visit within 6 months of their diabetes diagnosis
	- The age at Diabetes onset
*/
SELECT 
    d.patient,
    d.diabetes_start_date,
    d.age_at_diagnosis,
    e.encounter_start
FROM 
    diabetes_under_40 d
JOIN 
    ed_visits e ON d.patient = e.patient
WHERE 
    e.encounter_start::DATE BETWEEN d.diabetes_start_date::DATE 
    AND d.diabetes_start_date::DATE + INTERVAL '6 Months'
ORDER BY d.patient;