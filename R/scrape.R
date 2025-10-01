#' Scrape recoveries from Falsterbo
#'
#' This function is deprecated because the website is no longer available.
#' @importFrom lifecycle deprecate_warn
#' @keywords internal
#' @export
scrape_recoveries_falsterbo <- function(species = "ACNIS") {
  lifecycle::deprecate_warn("1.0.0", "scrape_recoveries_falsterbo()", details = "The Falsterbo Fagelstation website has changed and this function is no longer working.")
}

#' Scrape checklist from Falsterbo
#'
#' This function is deprecated because the website is no longer available.
#' @keywords internal
#' @export
scrape_checklist_falsterbo <- function() {
  lifecycle::deprecate_warn("1.0.0", "scrape_checklist_falsterbo()", details = "The Falsterbo Fagelstation website has changed and this function is no longer working.")
}

#' Scrape checklist from Ottenby
#'
#' This function is deprecated because the website is no longer available.
#' @keywords internal
#' @export
scrape_checklist_ottenby <- function() {
  lifecycle::deprecate_warn("1.0.0", "scrape_checklist_ottenby()", details = "The Ottenby Fagelstation website is not available and this function is no longer working.")
}

#' Scrape recoveries from Ottenby
#'
#' This function is deprecated because the website is no longer available.
#' @keywords internal
#' @export
scrape_recoveries_ottenby <- function() {
  lifecycle::deprecate_warn("1.0.0", "scrape_recoveries_ottenby()", details = "The Ottenby Fagelstation website is not available and this function is no longer working.")
}

#' Scrape checklist from Norway
#'
#' This function is deprecated because the website is no longer available.
#' @keywords internal
#' @export
scrape_checklist_norway <- function() {
  lifecycle::deprecate_warn("1.0.0", "scrape_checklist_norway()", details = "The Norwegian bird ringing website is not available and this function is no longer working.")
}

#' Scrape recoveries from Norway
#'
#' This function is deprecated because the website is no longer available.
#' @keywords internal
#' @export
scrape_recoveries_norway <- function(species_id = 01580) {
  lifecycle::deprecate_warn("1.0.0", "scrape_recoveries_norway()", details = "The Norwegian bird ringing website is not available and this function is no longer working.")
}
