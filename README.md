
<!-- README.md is generated from README.Rmd. Please edit that file -->
swedishbirdrecoveries
=====================

[![Travis-CI Build Status](https://travis-ci.org/mskyttner/swedishbirdrecoveries.svg?branch=master)](https://travis-ci.org/mskyttner/swedishbirdrecoveries)[![AGPLv3 License](http://img.shields.io/badge/license-AGPLv3-blue.svg)](LICENSE)

The Swedish Museum for Natural History manages bird ringing data in Sweden. This R package - `swedishbirdrecoveries` - provides a programmatic interface to Swedish Bird Recovery data.

Functionality and Stakeholders
------------------------------

Stakeholders and their needs:

### Museum Staff (Ringmärkningscentralen)

Needs to manage the data internally and externally.

Can participate in the process and develop the package further. Can control which data is made public and update frequency. Can also use the package to work with internal data in the same format.

### Research Community

Needs access to the data for scientific use.

Can install and use an R-package with datasets and visuals (see installation instructions below).

### Citizens / General Public

Needs web-friendly way to look at the data.

Can use a web user interface to explore the data with no installation required, by browsing to a server which has deloyed this package.

Can use a DINA-Web application such as The Naturalist, which can link to the data in relevant presentation formats.

### Public Sector Information

Needs to aggregate and disseminate the data internationally and nationally.

Can be achieved by ensuring that data can flow to GBIF via DINA-Web for international and national use, which will enable that data can be made available at nrm.se/psi-data, in line with the Museum's mission and regulations.

Installation
------------

You can get started by installing from Github:

``` r
install.packages("devtools")
devtools::install_github("mskyttner/swedishbirdrecoveries")

# load the package
library(swedishbirdrecoveries)
```

Usage
-----

The data include several dimensions:

-   Species
-   Ringing date
-   Ringing position
-   Ringing age category
-   Sex
-   Recovery date
-   Recovery position

### Searches

Search for recoveries that has occurred within a specific time period (begin - end for original ringing and recovery dates) - this can be used to study seasonality and which recoveries happen in the same season...

Recaptures made within less than 10 km from the original ringing location are by default not returned.

### Report about seasonal average position

Search for recoveries with known recovery date by season and get average position by species.

### Reports about average percentage shot recoveries

Study the perentage of recoveries for species that are shot across countries or regions.

### Kernels

Given recoveries per species, what would a kernel look like?

### Potential other searches

TODO: write section here

Meta
----

-   Please [report any requests, issues or bugs](https://github.com/mskyttner/swedishbirdrecoveries/issues).
-   License: Affero GPL v3
