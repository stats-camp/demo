clear
import delimited "data/student_scores.csv"
generate score_average = (read + write + math) / 3
generate byte high_math = math >= 60
list id read write math score_average high_math in 13/16
sort id
generate cumulative_math = sum(math)
list id math cumulative_math in 1/6
