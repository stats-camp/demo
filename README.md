# stats.camp demos and examples

This repository contains the source material for the anonymous stats.camp
showcase and the runnable examples linked from the stats.camp learning pages.

- Open `showcase.do` for the main product demo.
- Open `examples/first-analysis.do` for an Excel-based housing analysis with
  2,400 synthetic sales, regression models, and four layered figures.
- Open a file under `examples/` for one focused command example.
- Shared example datasets live under `data/`.

The bundled `.dta` workflow uses `data/student_scores.dta` and
`examples/open-dta.do`, so visitors can open a real Stata-format dataset
without uploading a file or creating an account.

Each learning-page link clones this repository and opens the matching `.do`
file. Keep published paths stable: moving a file breaks existing links.

## Example data

The files under `data/` are small synthetic teaching datasets created for
stats.camp. They do not describe real students, homes, or markets. The datasets
and focused example do-files are dedicated to the public domain under
[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).

## First analysis: Excel and synthetic housing sales

`data/first-analysis.xlsx` contains a `Sales` sheet with 2,400 observations and
an `About` sheet describing its fields. There are 60 invented sales for each
combination of four districts and ten years (2015–2024). Price is generated
from floor area, building age, distance, energy efficiency, district, year,
and random noise. None of the results is evidence about a real housing market
or a causal effect.

`examples/first-analysis.do` imports the Excel sheet, summarizes the data,
draws a scatter plot with a fitted line and confidence band, compares four
price distributions, compares robust regression coefficients, and layers
annual means with confidence bands. It restores the original 2,400-row dataset
after aggregation so visitors can continue exploring it.

Regenerate the workbook from this repository's root with
`python3 data/generate_first_analysis.py` (Python 3 and `openpyxl==3.1.5`). The
generator uses seed `20261117` and normalizes workbook/ZIP timestamps; repeated
runs produce the same workbook. The workbook includes no macros or external
links. All inputs are bundled, so the analysis needs no additional downloads.
