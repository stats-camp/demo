clear
import delimited "data/student_scores.csv"
egen mean_math = mean(math)
egen count_math = count(math)
egen z_math = std(math)
egen score_mean = rowmean(read write math)
egen score_total = rowtotal(read write math)
egen race_female = group(race female)
list id math mean_math count_math z_math score_mean score_total race_female in 13/16
