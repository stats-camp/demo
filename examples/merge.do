clear
import delimited "data/student_scores.csv"
merge 1:1 id using "data/student_schools.csv"
tabulate _merge
list id math school _merge if _merge != 3
