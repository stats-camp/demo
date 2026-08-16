clear
import delimited "data/student_scores.csv"
ranksum math, by(female) exact porder
