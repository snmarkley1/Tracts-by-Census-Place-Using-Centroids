#  Tracts-by-Census-Place-Using-Centroids

## Summary
The R scripts in this repository produce output .csv and .xlsx files that include all census tracts in the U.S. assigned to the Census-defined [place](https://www2.census.gov/geo/pdfs/reference/GARM/Ch9GARM.pdf) (*e.g.*, city, town, village, etc.) in which their centroid is located. The scripts are written to allow users to produce this file for the whole U.S. or for individual states. Further, they can specify which tract or place vintage (2010 or later) they would like to use. In the `file_download` folder, I have provided .csv and .xlsx files using 2010 and 2020 tract vintages with 2021 place vintages.

## Contents
This repository includes three folders: `file_download`, `input_tables`, and `scripts`.

The `file_download` folder contains two identical .csv and .xlsx files.
- `tracts_by_place_centroid_USA_t2010_p2021` uses 2010 tract vintages and 2021 place vintages.
- `tracts_by_place_centroid_USA_t2020_p2021` uses 2020 tract vintages and 2021 place vintages.

The `scripts` folder contains two R scripts:

- `00_preamble.R` prepares the workspace by loading the required packages, etc. It is called in `01_tracts_place.R`.
- `01_tracts_place.R` generates the outputs. It is set to prepare the table and shapefiles for the whole U.S. for tract vintage 2020 and place vintage 2021. Users can change these specifications in *lines 15 - 23*

The `input_tables` folder contains on Excel workbook copied from the [U.S. Census](https://www.census.gov/library/reference/code-lists/legal-status-codes.html) that translates the place types from numerical Legal/Statistical Area Description (LSAD) codes to readable text. These LSADs specify if a place is a city, borough, township, village, Census Designated Place (CDP), and so on.

## Codebook
The codebook for the .csv and .xlsx files is as follows:
- `STATE`: state abbreviation in which a tract is located
- `COUNTY`: county in which a tract is located
- `TRACTID`: unique tract identifier provided by the U.S. Census. This identifier should be 11 characters long, but the .csv drops leading zeroes for Alabama, Alaska, Arizona, Arkansas, California, Colorado, and Connecticut.
- `NHGISID`: unique tract identifier in [NHGIS](https://www.nhgis.org/) format.
- `PLACEID`: unique place identifier provided by the U.S. Census. If blank (.xlsx) or NA (.csv), then that tract's centroid does not land in a census place.
- `PLACE`: the name of the place in which the tract's centroid is located. If blank (.xlsx) or NA (.csv), then that tract's centroid does not land in a census place.
- `PLACE_TYPE`: the place type based on their LSAD (*e.g.*, city, borough, township, village, CDP, etc.). If blank (.xlsx) or NA (.csv), then that tract's centroid does not land in a census place.
- `TR_VINTAGE` - the tract's vintage (either 2010 or 2020)
- `PL_VINTAGE` - the place's vintage (set to 2021 in output files but can be changed by user).

## License
The data collected and presented are licensed under the [Creative Commons Attribution 4.0 International license](https://creativecommons.org/licenses/by/4.0/), and the underlying code used to format, analyze, and display that content is licensed under the [MIT license](http://opensource.org/licenses/mit-license.php).
