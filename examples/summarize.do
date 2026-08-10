clear
import delimited "data/student_scores.csv"
summarize math read write
by race: summarize math
summarize math, detail
