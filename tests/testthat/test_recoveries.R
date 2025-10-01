library(swedishbirdrecoveries)
context("Dataset content")

test_that("datasets are not empty", {
	data("birdrecoveries_eng")
	data("birdrecoveries_swe")
  expect_gt(nrow(birdrecoveries_eng), 0)
	expect_gt(nrow(birdrecoveries_swe), 0)
})