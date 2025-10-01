# This script reads data from the source SQLite database and creates
# the .rda data files for the package.
# It is intended to be run by a developer from the project root.

library(DBI)
library(RSQLite)
library(dplyr)
library(usethis)

# --- Configuration ---
DB_PATH <- file.path("inst", "extdata", "sbr.db")

# --- Helper function ---
int_to_date <- function(x) as.Date(x, "1970-01-01")

# --- Main processing ---
message("Connecting to database at: ", DB_PATH)
con <- DBI::dbConnect(RSQLite::SQLite(), DB_PATH)

message("Reading and processing 'birdrecoveries_eng'...")
birdrecoveries_eng <- dplyr::collect(dplyr::mutate(
 	tibble::as_tibble(DBI::dbReadTable(con, "birdrecoveries_eng")),
 		ringing_date = int_to_date(ringing_date),
 		recovery_date = int_to_date(recovery_date),
 		modified_date = int_to_date(modified_date)
 	))

message("Reading and processing 'birdrecoveries_swe'...")
birdrecoveries_swe <- dplyr::collect(dplyr::mutate(
 	tibble::as_tibble(DBI::dbReadTable(con, "birdrecoveries_swe")),
 		ringing_date = int_to_date(ringing_date),
 		recovery_date = int_to_date(recovery_date),
 		modified_date = int_to_date(modified_date)
 	))

message("Reading and processing 'birdrecoveries_i18n'...")
birdrecoveries_i18n <- tibble::as_tibble(
 	DBI::dbReadTable(con, "birdrecoveries_i18n"))

message("Disconnecting from database...")
DBI::dbDisconnect(con)

message("Saving .rda files to data/ directory...")
usethis::use_data(birdrecoveries_eng, birdrecoveries_swe, birdrecoveries_i18n, overwrite = TRUE)

message("Done.")
