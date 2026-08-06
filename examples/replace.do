clear
import delimited "data/student_scores.csv"
generate write_filled = write
replace write_filled = (read + math) / 2 if missing(write_filled)
list id read write math write_filled if missing(write)
