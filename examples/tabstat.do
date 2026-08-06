clear
import delimited "data/student_scores.csv"
tabstat math read write, statistics(count mean sd min max)
by race: tabstat math, statistics(count mean sd)
