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
regress experience treatment
regress score treatment
histogram age if treatment == 0, percent addlabel name(hist_age_0, replace) title("Histogram of Age for Treatment Group 0")
histogram age if treatment == 1, percent addlabel name(hist_age_1, replace) title("Histogram of Age for Treatment Group 1")
histogram age if treatment == 0, percent name(hist_age_0, replace) title("Histogram of Age for Treatment Group 0")
histogram age if treatment == 1, percent name(hist_age_1, replace) title("Histogram of Age for Treatment Group 1")
histogram age if treatment == 0, percent title("Histogram of Age for Treatment Group 0")
histogram age if treatment == 1, percent title("Histogram of Age for Treatment Group 1")
