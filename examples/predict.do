clear
import delimited "data/student_scores.csv"
regress math read female
predict fitted_math
predict residual, residuals
predict fitted_se, stdp
list id math fitted_math residual fitted_se in 1/6
