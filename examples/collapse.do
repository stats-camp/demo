clear
import delimited "data/student_scores.csv"
collapse (mean) mean_math=math mean_read=read (sum) total_math=math (count) n_write=write, by(race)
list
