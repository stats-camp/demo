clear
import delimited "data/student_scores.csv"
generate read_gapped = read
replace read_gapped = . if id <= 4
pwcorr math read_gapped write
