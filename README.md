## Project: Cohort Builder – Diabetes + ED Visits

This SQL script defines a real-world-style cohort of patients with:
- A first diagnosis of diabetes (excluding prediabetes)
- Diagnosed before age 40
- Who had an emergency department (ED) visit within 6 months of diagnosis

Although the synthetic data only returns one patient meeting these criteria, the logic is easily extendable to other conditions or encounter types. The sample size is only 1000 patients and tweaking the criteria for age and time between diabetes diagnosis and ED visit did not increase the number of available patients. 

### Technologies Used
- PostgreSQL
- Common Table Expressions (CTEs)
- Window functions
- Clinical reasoning applied to synthetic EHR data
- Relational Databases

### Data Source 

The synthetic data comes from  SyntheaTM, an open-source patient population simulation made available by The MITRE Corporation which can be found at this [link](https://synthea.mitre.org/downloads). I used the 1k patient sample.

### References
Jason Walonoski, Mark Kramer, Joseph Nichols, Andre Quina, Chris Moesel, Dylan Hall, Carlton Duffett, Kudakwashe Dube, Thomas Gallagher, Scott McLachlan, Synthea: An approach, method, and software mechanism for generating synthetic patients and the synthetic electronic health care record, Journal of the American Medical Informatics Association, Volume 25, Issue 3, March 2018, Pages 230–238, https://doi.org/10.1093/jamia/ocx079
