clear
import delimited "data/student_scores.csv"
collapse (mean) mean_math=math mean_read=read (count) n_write=write, by(race)
list
