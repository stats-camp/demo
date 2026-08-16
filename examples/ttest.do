clear
import delimited "data/student_scores.csv"
ttest math == 55
ttest math, by(female)
ttest read == math
ttest math, by(female) unequal
