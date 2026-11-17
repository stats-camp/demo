#!/usr/bin/env python3
"""Rebuild the explicitly synthetic Excel workbook used by first-analysis.do.

Requires Python 3 and openpyxl 3.1.5. All randomness comes from the fixed seed;
workbook properties and ZIP timestamps are normalized for repeatable output.
"""
from datetime import datetime
from io import BytesIO
import math
from pathlib import Path
import random
import re
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo

from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill

SEED = 20261117
DESTINATION = Path(__file__).with_name("first-analysis.xlsx")
STAMP = "2026-11-17T00:00:00Z"
DISTRICTS = [
    (1, "Riverside", 112, 28, 4.5, 0.12),
    (2, "Midtown", 104, 43, 2.0, 0.22),
    (3, "Garden", 128, 18, 8.0, 0.04),
    (4, "Harbor", 108, 36, 6.0, -0.02),
]


def build_workbook():
    rng = random.Random(SEED)
    book = Workbook()
    sales = book.active
    sales.title = "Sales"
    sales.append([
        "sale_id", "sale_year", "district", "district_name", "area_m2",
        "age_years", "distance_km", "energy_efficient", "rooms", "price_k",
    ])
    for year in range(2015, 2025):
        for district, name, mean_area, mean_age, mean_distance, premium in DISTRICTS:
            for _ in range(60):
                area = round(min(210, max(45, rng.gauss(mean_area, 25))), 1)
                age = round(min(95, max(0, rng.gauss(mean_age, 14))))
                distance = round(max(0.4, rng.gauss(mean_distance, 1.3)), 1)
                efficient_probability = min(0.85, max(0.1,
                    0.28 + 0.035 * (year - 2015) + 0.12 * (district == 3) - 0.003 * age))
                efficient = int(rng.random() < efficient_probability)
                rooms = min(8, max(2, round(area / 27 + rng.gauss(0, 0.45))))
                log_price = (5.65 + 0.050 * (area - 110) / 10 - 0.025 * age / 10
                    - 0.032 * distance / 5 + 0.075 * efficient + premium
                    + 0.035 * (year - 2015) + 0.025 * math.sin((year - 2015) * 0.8)
                    + rng.gauss(0, 0.12 + area * 0.00015))
                sales.append([sales.max_row, year, district, name, area, age,
                    distance, efficient, rooms, round(math.exp(log_price), 1)])
    sales.freeze_panes = "A2"
    sales.auto_filter.ref = sales.dimensions
    for cell in sales[1]:
        cell.font = Font(bold=True, color="FFFFFF")
        cell.fill = PatternFill("solid", fgColor="1A476F")
    for column, width in {"A":12,"B":12,"C":12,"D":18,"E":14,"F":14,"G":15,"H":20,"I":12,"J":16}.items():
        sales.column_dimensions[column].width = width
    for row in sales.iter_rows(min_row=2):
        for index in (4, 6, 9):
            row[index].number_format = "#,##0.0"
    about = book.create_sheet("About")
    for row in [
        ["Synthetic housing sales — stats.camp teaching example"],
        ["These are invented observations, not real homes, people, prices or market evidence."],
        ["Rows", 2400], ["Design", "60 sales per district per year; four districts; 2015–2024"],
        ["Seed", SEED], ["Regenerate", "python3 data/generate_first_analysis.py"],
        ["Price units", "Invented sale price in thousands of dollars"],
        ["area_m2", "Floor area in square metres"], ["age_years", "Building age at sale"],
        ["distance_km", "Distance to the invented city centre"],
        ["energy_efficient", "Synthetic energy-efficiency indicator: 1 yes, 0 no"],
        ["rooms", "Number of rooms"],
        ["Model", "Log price depends on area, age, distance, efficiency, district, year and random noise."],
        ["Interpretation", "Regression coefficients and intervals illustrate methods; they are not causal or market claims."],
        ["License", "CC0 1.0 — public domain"],
    ]:
        about.append(row)
    about.column_dimensions["A"].width = 25
    about.column_dimensions["B"].width = 100
    book.properties.creator = "stats.camp"
    book.properties.title = "Synthetic housing sales: first analysis"
    book.properties.description = "2,400 explicitly synthetic observations for a browser statistics demonstration."
    book.properties.created = datetime(2026, 11, 17)
    book.properties.modified = datetime(2026, 11, 17)
    output = BytesIO()
    book.save(output)
    # openpyxl updates modified time while saving. Normalize it and the ZIP
    # entry metadata so rerunning the generator does not create binary noise.
    with ZipFile(output) as source, ZipFile(DESTINATION, "w", compression=ZIP_DEFLATED) as target:
        for name in sorted(source.namelist()):
            payload = source.read(name)
            if name == "docProps/core.xml":
                text = payload.decode("utf-8")
                text = re.sub(r"(<dcterms:(?:created|modified)[^>]*>)[^<]+", r"\g<1>" + STAMP, text)
                payload = text.encode("utf-8")
            entry = ZipInfo(name, date_time=(2026, 11, 17, 0, 0, 0))
            entry.compress_type = ZIP_DEFLATED
            entry.external_attr = 0o600 << 16
            target.writestr(entry, payload)
    print(f"Wrote {DESTINATION}: {sales.max_row - 1:,} synthetic sales")


if __name__ == "__main__":
    build_workbook()
