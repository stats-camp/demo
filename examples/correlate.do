clear
import delimited "data/student_scores.csv"
correlate math read write
correlate math read if !missing(write)
