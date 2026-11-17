* 2,400 invented home sales. This is a teaching example, not market evidence.
clear
import excel "data/first-analysis.xlsx", sheet("Sales") firstrow clear
describe
summarize price_k area_m2 age_years distance_km
label define district_names 1 "Riverside" 2 "Midtown" 3 "Garden" 4 "Harbor"
label values district district_names
label variable price_k "Sale price ($ thousands)"
label variable area_m2 "Floor area (sq m)"

* 1. Explore the raw data: four districts, a fitted line and its 95% band.
twoway (lfitci price_k area_m2, lcolor(gs5) fcolor(gs12%35)) ///
    (scatter price_k area_m2 if district == 1, mcolor(navy%40) msize(vsmall)) ///
    (scatter price_k area_m2 if district == 2, mcolor(maroon%40) msize(vsmall)) ///
    (scatter price_k area_m2 if district == 3, mcolor(teal%40) msize(vsmall)) ///
    (scatter price_k area_m2 if district == 4, mcolor(orange%40) msize(vsmall)), ///
    title("Larger homes tend to sell for more") ///
    subtitle("2,400 synthetic sales across four districts, 2015-2024") ///
    xtitle("Floor area (sq m)") ytitle("Sale price ($ thousands)") ///
    legend(order(3 "Riverside" 4 "Midtown" 5 "Garden" 6 "Harbor") rows(1)) ///
    note("Line and shaded band: pooled linear fit and 95% confidence interval. All data are synthetic.") ///
    graphregion(color(white)) name(price_area, replace)

* 2. Compare entire price distributions rather than only averages.
twoway (kdensity price_k if district == 1, lcolor(navy) lwidth(medthick)) ///
    (kdensity price_k if district == 2, lcolor(maroon) lwidth(medthick)) ///
    (kdensity price_k if district == 3, lcolor(teal) lwidth(medthick)) ///
    (kdensity price_k if district == 4, lcolor(orange) lwidth(medthick)), ///
    title("Different districts, overlapping price distributions") ///
    xtitle("Sale price ($ thousands)") ytitle("Density") ///
    legend(order(1 "Riverside" 2 "Midtown" 3 "Garden" 4 "Harbor") rows(1)) ///
    note("Kernel density estimates from 600 synthetic sales per district.") ///
    graphregion(color(white)) name(price_distributions, replace)

* 3. Fit two models and compare their coefficients with robust 95% intervals.
generate ln_price = ln(price_k)
generate area_10 = area_m2 / 10
generate age_10 = age_years / 10
generate distance_5 = distance_km / 5
regress ln_price area_10 age_10 distance_5 energy_efficient, vce(robust)
estimates store features
regress ln_price area_10 age_10 distance_5 energy_efficient i.district i.sale_year, vce(robust)
estimates store adjusted
coefplot (features, label("Property features only") mcolor(navy)) ///
    (adjusted, label("Plus district and year") mcolor(teal)), ///
    keep(area_10 age_10 distance_5 energy_efficient) ///
    coeflabels(area_10 = "Area (+10 sq m)" age_10 = "Age (+10 years)" distance_5 = "Distance (+5 km)" energy_efficient = "Energy-efficient home") ///
    xline(0, lcolor(gs10) lpattern(dash)) ciopts(recast(rcap)) ///
    title("Which associations remain after adjustment?") ///
    xtitle("Change in log sale price (95% confidence interval)") ///
    legend(rows(1)) note("Robust standard errors. These synthetic associations are not causal effects.") ///
    graphregion(color(white)) name(model_comparison, replace)

* 4. Aggregate by year and district, then layer confidence bands and trend lines.
preserve
collapse (mean) mean_price = price_k (sd) sd_price = price_k (count) n_sales = price_k, by(sale_year district)
generate lower = mean_price - 1.96 * sd_price / sqrt(n_sales)
generate upper = mean_price + 1.96 * sd_price / sqrt(n_sales)
sort district sale_year
twoway (rarea lower upper sale_year if district == 1, fcolor(navy%15) lcolor(none)) ///
    (line mean_price sale_year if district == 1, lcolor(navy) lwidth(medthick)) ///
    (rarea lower upper sale_year if district == 2, fcolor(maroon%15) lcolor(none)) ///
    (line mean_price sale_year if district == 2, lcolor(maroon) lwidth(medthick)) ///
    (rarea lower upper sale_year if district == 3, fcolor(teal%15) lcolor(none)) ///
    (line mean_price sale_year if district == 3, lcolor(teal) lwidth(medthick)) ///
    (rarea lower upper sale_year if district == 4, fcolor(orange%15) lcolor(none)) ///
    (line mean_price sale_year if district == 4, lcolor(orange) lwidth(medthick)), ///
    title("Follow annual prices with uncertainty in view") ///
    xtitle("Sale year") ytitle("Mean sale price ($ thousands)") xlabel(2015(3)2024) ///
    legend(order(2 "Riverside" 4 "Midtown" 6 "Garden" 8 "Harbor") rows(1)) ///
    note("Shaded bands: mean +/- 1.96 standard errors; 60 synthetic sales per district-year.") ///
    graphregion(color(white)) name(annual_trends, replace)
restore
