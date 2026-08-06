clear
import delimited "data/student_scores.csv"
recode math (min/49 = 1 "Below 50") (50/59 = 2 "50 to 59") (60/max = 3 "60 or more"), generate(math_band) label(math_band_labels)
tabulate math_band
list id math math_band in 1/8
