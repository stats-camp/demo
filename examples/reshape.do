clear
import delimited "data/student_scores_wide.csv"
reshape long math read, i(id) j(term)
sort id term
list
