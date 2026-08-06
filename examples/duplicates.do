clear
import delimited "data/student_scores.csv"
expand 2 if id <= 2
duplicates report id
duplicates tag id, generate(duplicate_count)
list id math duplicate_count if duplicate_count > 0
