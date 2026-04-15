clear
import delimited "data/showcase.csv"

describe
summarize y treatment age experience score income female

regress y treatment age experience score
eststo baseline

regress y treatment age experience score female income
eststo full

esttab baseline full, se
coefplot (baseline, label(Baseline)) (full, label(Full)), drop(_cons) xline(0) title(Coefficient comparison)
scatter y score, title(Outcome and score)
histogram y, normal title(Outcome distribution)
