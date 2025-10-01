library(DBI)
library(RSQLite)
library(dplyr)

BIRDS_DB <- system.file(
  "extdata",
  "sbr.db",
  package = "swedishbirdrecoveries"
)

if (identical(BIRDS_DB, "")) {
  BIRDS_DB <- file.path("inst", "extdata", "sbr.db")
}

con <- DBI::dbConnect(RSQLite::SQLite(), BIRDS_DB)

int_to_date <- function(x) as.Date(x, "1970-01-01")

birdrecoveries_swe <- dplyr::collect(dplyr::mutate(
 	tibble::as_tibble(DBI::dbReadTable(con, "birdrecoveries_swe")),
 		ringing_date = int_to_date(ringing_date),
 		recovery_date = int_to_date(recovery_date),
 		modified_date = int_to_date(modified_date)
 	))

# sbr_i18n <- tibble::as_tibble(
# 	DBI::dbReadTable(con, "birdrecoveries_i18n"))
#

DBI::dbDisconnect(con)
